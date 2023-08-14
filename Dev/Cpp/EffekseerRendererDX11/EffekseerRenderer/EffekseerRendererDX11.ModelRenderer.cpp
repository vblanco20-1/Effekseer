
//----------------------------------------------------------------------------------
// Include
//----------------------------------------------------------------------------------
#include "EffekseerRendererDX11.RenderState.h"
#include "EffekseerRendererDX11.RendererImplemented.h"

#include "EffekseerRendererDX11.ModelRenderer.h"
#include "EffekseerRendererDX11.Shader.h"

namespace EffekseerRendererDX11
{

namespace
{
#include "ShaderHeader/ad_model_distortion_ps.h"
#include "ShaderHeader/ad_model_distortion_vs.h"
#include "ShaderHeader/ad_model_lit_ps.h"
#include "ShaderHeader/ad_model_lit_vs.h"
#include "ShaderHeader/ad_model_unlit_ps.h"
#include "ShaderHeader/ad_model_unlit_vs.h"
#include "ShaderHeader/model_distortion_ps.h"
#include "ShaderHeader/model_distortion_vs.h"
#include "ShaderHeader/model_lit_ps.h"
#include "ShaderHeader/model_lit_vs.h"
#include "ShaderHeader/model_unlit_ps.h"
#include "ShaderHeader/model_unlit_vs.h"
} // namespace

ModelRenderer::ModelRenderer(const RendererImplementedRef& renderer,
							 std::unique_ptr<Shader> shader_advanced_lit,
							 std::unique_ptr<Shader> shader_advanced_unlit,
							 std::unique_ptr<Shader> shader_advanced_distortion,
							 std::unique_ptr<Shader> shader_lit,
							 std::unique_ptr<Shader> shader_unlit,
							 std::unique_ptr<Shader> shader_distortion)
	: m_renderer(renderer)
	, shader_advanced_lit_(std::move(shader_advanced_lit))
	, shader_advanced_unlit_(std::move(shader_advanced_unlit))
	, shader_advanced_distortion_(std::move(shader_advanced_distortion))
	, shader_lit_(std::move(shader_lit))
	, shader_unlit_(std::move(shader_unlit))
	, shader_distortion_(std::move(shader_distortion))
{
	{
		Shader* shaders[2];
		shaders[0] = shader_advanced_lit_.get();
		shaders[1] = shader_advanced_unlit_.get();

		for (int32_t i = 0; i < 2; i++)
		{
			shaders[i]->SetVertexConstantBufferSize(sizeof(::EffekseerRenderer::ModelRendererAdvancedVertexConstantBuffer<40>));
			shaders[i]->SetPixelConstantBufferSize(sizeof(::EffekseerRenderer::PixelConstantBuffer));
		}

		shader_advanced_distortion_->SetVertexConstantBufferSize(sizeof(::EffekseerRenderer::ModelRendererAdvancedVertexConstantBuffer<40>));
		shader_advanced_distortion_->SetPixelConstantBufferSize(sizeof(::EffekseerRenderer::PixelConstantBufferDistortion));
	}

	{
		Shader* shaders[2];
		shaders[0] = shader_lit_.get();
		shaders[1] = shader_unlit_.get();

		for (int32_t i = 0; i < 2; i++)
		{
			shaders[i]->SetVertexConstantBufferSize(sizeof(::EffekseerRenderer::ModelRendererVertexConstantBuffer<40>));
			shaders[i]->SetPixelConstantBufferSize(sizeof(::EffekseerRenderer::PixelConstantBuffer));
		}

		shader_distortion_->SetVertexConstantBufferSize(sizeof(::EffekseerRenderer::ModelRendererVertexConstantBuffer<40>));
		shader_distortion_->SetPixelConstantBufferSize(sizeof(::EffekseerRenderer::PixelConstantBufferDistortion));
	}

	VertexType = EffekseerRenderer::ModelRendererVertexType::Instancing;

	graphicsDevice_ = Effekseer::MakeRefPtr<Backend::GraphicsDevice>(renderer->GetDevice(), nullptr);
}

//----------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------
ModelRenderer::~ModelRenderer()
{
}

//----------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------
ModelRendererRef ModelRenderer::Create(const RendererImplementedRef& renderer)
{
	assert(renderer != nullptr);
	assert(renderer->GetDevice() != nullptr);

	auto vl = EffekseerRenderer::GetModelRendererVertexLayout(renderer->GetGraphicsDevice()).DownCast<Backend::VertexLayout>();

	std::unique_ptr<Shader> shader_advanced_lit = Shader::Create(
		renderer->GetGraphicsDevice(),
		renderer->GetGraphicsDevice()->CreateShaderFromBinary(
			dx11_ad_model_lit_vs, sizeof(dx11_ad_model_lit_vs), dx11_ad_model_lit_ps, sizeof(dx11_ad_model_lit_ps)),
		vl,
		"ModelRendererLightingTextureNormal");

	std::unique_ptr<Shader> shader_advanced_unlit = Shader::Create(
		renderer->GetGraphicsDevice(),
		renderer->GetGraphicsDevice()->CreateShaderFromBinary(
			dx11_ad_model_unlit_vs, sizeof(dx11_ad_model_unlit_vs), dx11_ad_model_unlit_ps, sizeof(dx11_ad_model_unlit_ps)),
		vl,
		"ModelRendererTexture");

	std::unique_ptr<Shader> shader_advanced_distortion = Shader::Create(
		renderer->GetGraphicsDevice(),
		renderer->GetGraphicsDevice()->CreateShaderFromBinary(
			dx11_ad_model_distortion_vs, sizeof(dx11_ad_model_distortion_vs), dx11_ad_model_distortion_ps, sizeof(dx11_ad_model_distortion_ps)),
		vl,
		"ModelRendererDistortionTexture");

	std::unique_ptr<Shader> shader_lit = Shader::Create(
		renderer->GetGraphicsDevice(),
		renderer->GetGraphicsDevice()->CreateShaderFromBinary(
			dx11_model_lit_vs, sizeof(dx11_model_lit_vs), dx11_model_lit_ps, sizeof(dx11_model_lit_ps)),
		vl,
		"ModelRendererLightingTextureNormal");

	std::unique_ptr<Shader> shader_unlit = Shader::Create(
		renderer->GetGraphicsDevice(),
		renderer->GetGraphicsDevice()->CreateShaderFromBinary(
			dx11_model_unlit_vs, sizeof(dx11_model_unlit_vs), dx11_model_unlit_ps, sizeof(dx11_model_unlit_ps)),
		vl,
		"ModelRendererTexture");

	std::unique_ptr<Shader> shader_distortion = Shader::Create(
		renderer->GetGraphicsDevice(),
		renderer->GetGraphicsDevice()->CreateShaderFromBinary(
			dx11_model_distortion_vs, sizeof(dx11_model_distortion_vs), dx11_model_distortion_ps, sizeof(dx11_model_distortion_ps)),
		vl,
		"ModelRendererDistortionTexture");

	if (shader_advanced_lit == nullptr || shader_advanced_unlit == nullptr || shader_advanced_distortion == nullptr || shader_lit == nullptr || shader_unlit == nullptr || shader_distortion == nullptr)
	{
		return nullptr;
	}

	return ModelRendererRef(new ModelRenderer(
		renderer,
		std::move(shader_advanced_lit),
		std::move(shader_advanced_unlit),
		std::move(shader_advanced_distortion),
		std::move(shader_lit),
		std::move(shader_unlit),
		std::move(shader_distortion)));
}

void ModelRenderer::BeginRendering(const efkModelNodeParam& parameter, int32_t count, void* userData)
{
	BeginRendering_(m_renderer.Get(), parameter, count, userData);
}

void ModelRenderer::Rendering(const efkModelNodeParam& parameter, const InstanceParameter& instanceParameter, void* userData)
{
	Rendering_<RendererImplemented>(m_renderer.Get(), parameter, instanceParameter, userData);
}

void ModelRenderer::EndRendering(const efkModelNodeParam& parameter, void* userData)
{
	if (parameter.ModelIndex < 0)
	{
		return;
	}

	Effekseer::ModelRef model = nullptr;

	if (parameter.IsProceduralMode)
	{
		model = parameter.EffectPointer->GetProceduralModel(parameter.ModelIndex);
	}
	else
	{
		model = parameter.EffectPointer->GetModel(parameter.ModelIndex);
	}

	if (model == nullptr)
	{
		return;
	}

	model->StoreBufferToGPU(graphicsDevice_.Get());
	if (!model->GetIsBufferStoredOnGPU())
	{
		return;
	}

	if (m_renderer->GetRenderMode() == Effekseer::RenderMode::Wireframe)
	{
		model->GenerateWireIndexBuffer(graphicsDevice_.Get());
		if (!model->GetIsWireIndexBufferGenerated())
		{
			return;
		}
	}

	EndRendering_<
		RendererImplemented,
		Shader,
		Effekseer::Model,
		true,
		40>(
		m_renderer.Get(),
		shader_advanced_lit_.get(),
		shader_advanced_unlit_.get(),
		shader_advanced_distortion_.get(),
		shader_lit_.get(),
		shader_unlit_.get(),
		shader_distortion_.get(),
		parameter,
		userData);
}

//----------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------
} // namespace EffekseerRendererDX11
//----------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------
