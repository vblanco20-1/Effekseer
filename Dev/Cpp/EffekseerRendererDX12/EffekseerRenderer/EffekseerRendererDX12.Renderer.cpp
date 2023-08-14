#include "EffekseerRendererDX12.Renderer.h"
#include "../../3rdParty/LLGI/src/DX12/LLGI.CommandListDX12.h"
#include "../../3rdParty/LLGI/src/DX12/LLGI.GraphicsDX12.h"
#include "../../3rdParty/LLGI/src/DX12/LLGI.TextureDX12.h"
#include "../EffekseerMaterialCompiler/DirectX12/EffekseerMaterialCompilerDX12.h"
#include "../EffekseerRendererLLGI/EffekseerRendererLLGI.RendererImplemented.h"

namespace
{
#include "ShaderHeader/ad_model_distortion_ps.h"
#include "ShaderHeader/ad_model_distortion_vs.h"
#include "ShaderHeader/ad_model_lit_ps.h"
#include "ShaderHeader/ad_model_lit_vs.h"
#include "ShaderHeader/ad_model_unlit_ps.h"
#include "ShaderHeader/ad_model_unlit_vs.h"
#include "ShaderHeader/ad_sprite_distortion_vs.h"
#include "ShaderHeader/ad_sprite_lit_vs.h"
#include "ShaderHeader/ad_sprite_unlit_vs.h"
#include "ShaderHeader/model_distortion_ps.h"
#include "ShaderHeader/model_distortion_vs.h"
#include "ShaderHeader/model_lit_ps.h"
#include "ShaderHeader/model_lit_vs.h"
#include "ShaderHeader/model_unlit_ps.h"
#include "ShaderHeader/model_unlit_vs.h"
#include "ShaderHeader/sprite_distortion_vs.h"
#include "ShaderHeader/sprite_lit_vs.h"
#include "ShaderHeader/sprite_unlit_vs.h"
} // namespace

namespace EffekseerRendererDX12
{

::Effekseer::Backend::GraphicsDeviceRef CreateGraphicsDevice(ID3D12Device* device, ID3D12CommandQueue* commandQueue, int32_t swapBufferCount)
{
	std::function<std::tuple<D3D12_CPU_DESCRIPTOR_HANDLE, LLGI::Texture*>()> getScreenFunc =
		[]() -> std::tuple<D3D12_CPU_DESCRIPTOR_HANDLE, LLGI::Texture*>
	{
		return std::tuple<D3D12_CPU_DESCRIPTOR_HANDLE, LLGI::Texture*>();
	};

	auto graphics = new LLGI::GraphicsDX12(
		device, getScreenFunc, []() -> void {}, commandQueue, swapBufferCount);

	auto ret = Effekseer::MakeRefPtr<EffekseerRendererLLGI::Backend::GraphicsDevice>(graphics);
	ES_SAFE_RELEASE(graphics);
	return ret;
}

::EffekseerRenderer::RendererRef Create(::Effekseer::Backend::GraphicsDeviceRef graphicsDevice,
										DXGI_FORMAT* renderTargetFormats,
										int32_t renderTargetCount,
										DXGI_FORMAT depthFormat,
										bool isReversedDepth,
										int32_t squareMaxCount)
{
	auto renderer = ::Effekseer::MakeRefPtr<::EffekseerRendererLLGI::RendererImplemented>(squareMaxCount);

	auto allocate_ = [](std::vector<LLGI::DataStructure>& ds, const unsigned char* data, int32_t size) -> void
	{
		ds.resize(1);
		ds[0].Size = size;
		ds[0].Data = data;
		return;
	};

	allocate_(renderer->fixedShader_.AdvancedSpriteUnlit_VS, dx12_ad_sprite_unlit_vs, sizeof(dx12_ad_sprite_unlit_vs));
	allocate_(renderer->fixedShader_.AdvancedSpriteLit_VS, dx12_ad_sprite_lit_vs, sizeof(dx12_ad_sprite_lit_vs));
	allocate_(renderer->fixedShader_.AdvancedSpriteDistortion_VS, dx12_ad_sprite_distortion_vs, sizeof(dx12_ad_sprite_distortion_vs));

	allocate_(renderer->fixedShader_.AdvancedModelUnlit_VS, dx12_ad_model_unlit_vs, sizeof(dx12_ad_model_unlit_vs));
	allocate_(renderer->fixedShader_.AdvancedModelUnlit_PS, dx12_ad_model_unlit_ps, sizeof(dx12_ad_model_unlit_ps));
	allocate_(renderer->fixedShader_.AdvancedModelLit_VS, dx12_ad_model_lit_vs, sizeof(dx12_ad_model_lit_vs));
	allocate_(renderer->fixedShader_.AdvancedModelLit_PS, dx12_ad_model_lit_ps, sizeof(dx12_ad_model_lit_ps));
	allocate_(renderer->fixedShader_.AdvancedModelDistortion_VS, dx12_ad_model_distortion_vs, sizeof(dx12_ad_model_distortion_vs));
	allocate_(renderer->fixedShader_.AdvancedModelDistortion_PS, dx12_ad_model_distortion_ps, sizeof(dx12_ad_model_distortion_ps));

	allocate_(renderer->fixedShader_.SpriteUnlit_VS, dx12_sprite_unlit_vs, sizeof(dx12_sprite_unlit_vs));
	allocate_(renderer->fixedShader_.SpriteLit_VS, dx12_sprite_lit_vs, sizeof(dx12_sprite_lit_vs));
	allocate_(renderer->fixedShader_.SpriteDistortion_VS, dx12_sprite_distortion_vs, sizeof(dx12_sprite_distortion_vs));

	allocate_(renderer->fixedShader_.ModelUnlit_VS, dx12_model_unlit_vs, sizeof(dx12_model_unlit_vs));
	allocate_(renderer->fixedShader_.ModelUnlit_PS, dx12_model_unlit_ps, sizeof(dx12_model_unlit_ps));
	allocate_(renderer->fixedShader_.ModelLit_VS, dx12_model_lit_vs, sizeof(dx12_model_lit_vs));
	allocate_(renderer->fixedShader_.ModelLit_PS, dx12_model_lit_ps, sizeof(dx12_model_lit_ps));
	allocate_(renderer->fixedShader_.ModelDistortion_VS, dx12_model_distortion_vs, sizeof(dx12_model_distortion_vs));
	allocate_(renderer->fixedShader_.ModelDistortion_PS, dx12_model_distortion_ps, sizeof(dx12_model_distortion_ps));

	renderer->platformType_ = Effekseer::CompiledMaterialPlatformType::DirectX12;
	renderer->materialCompiler_ = new Effekseer::MaterialCompilerDX12();

	LLGI::RenderPassPipelineStateKey key;
	key.RenderTargetFormats.resize(renderTargetCount);

	for (size_t i = 0; i < key.RenderTargetFormats.size(); i++)
	{
		key.RenderTargetFormats.at(i) = LLGI::ConvertFormat(renderTargetFormats[i]);
	}

	key.DepthFormat = LLGI::ConvertFormat(depthFormat);

	auto gd = graphicsDevice.DownCast<EffekseerRendererLLGI::Backend::GraphicsDevice>();

	if (renderer->Initialize(gd, key, isReversedDepth))
	{
		return renderer;
	}

	return nullptr;
}

::EffekseerRenderer::RendererRef Create(ID3D12Device* device,
										ID3D12CommandQueue* commandQueue,
										int32_t swapBufferCount,
										DXGI_FORMAT* renderTargetFormats,
										int32_t renderTargetCount,
										DXGI_FORMAT depthFormat,
										bool isReversedDepth,
										int32_t squareMaxCount)
{
	auto graphicDevice = CreateGraphicsDevice(device, commandQueue, swapBufferCount);

	auto ret = Create(graphicDevice, renderTargetFormats, renderTargetCount, depthFormat, isReversedDepth, squareMaxCount);

	if (ret != nullptr)
	{
		return ret;
	}

	return nullptr;
}

Effekseer::Backend::TextureRef CreateTexture(::Effekseer::Backend::GraphicsDeviceRef graphicsDevice, ID3D12Resource* texture)
{
	auto g = static_cast<::EffekseerRendererLLGI::Backend::GraphicsDevice*>(graphicsDevice.Get());
	return g->CreateTexture((uint64_t)texture, [] {});
}

TextureProperty GetTextureProperty(::Effekseer::Backend::TextureRef texture)
{
	if (texture != nullptr)
	{
		auto t = texture.DownCast<::EffekseerRendererLLGI::Backend::Texture>();
		auto lt = static_cast<LLGI::TextureDX12*>(t->GetTexture().get());
		return TextureProperty{lt->Get()};
	}
	else
	{
		return TextureProperty{};
	}
}

CommandListProperty GetCommandListProperty(Effekseer::RefPtr<EffekseerRenderer::CommandList> commandList)
{
	if (commandList != nullptr)
	{
		auto cl = commandList.DownCast<::EffekseerRendererLLGI::CommandList>();
		auto clDx12 = static_cast<LLGI::CommandListDX12*>(cl->GetInternal());
		return CommandListProperty{clDx12->GetCommandList()};
	}
	else
	{
		return CommandListProperty{};
	}
}

void BeginCommandList(Effekseer::RefPtr<EffekseerRenderer::CommandList> commandList, ID3D12GraphicsCommandList* dx12CommandList)
{
	assert(commandList != nullptr);

	if (dx12CommandList)
	{
		LLGI::PlatformContextDX12 context;
		context.commandList = dx12CommandList;

		auto c = static_cast<EffekseerRendererLLGI::CommandList*>(commandList.Get());
		c->GetInternal()->BeginWithPlatform(&context);
		c->SetState(EffekseerRendererLLGI::CommandListState::RunningWithPlatformCommandList);
	}
	else
	{
		auto c = static_cast<EffekseerRendererLLGI::CommandList*>(commandList.Get());
		c->GetInternal()->Begin();
		c->SetState(EffekseerRendererLLGI::CommandListState::Running);
	}
}

void EndCommandList(Effekseer::RefPtr<EffekseerRenderer::CommandList> commandList)
{
	assert(commandList != nullptr);
	auto c = static_cast<EffekseerRendererLLGI::CommandList*>(commandList.Get());

	if (c->GetState() == EffekseerRendererLLGI::CommandListState::RunningWithPlatformCommandList)
	{
		c->GetInternal()->EndWithPlatform();
	}
	else
	{
		c->GetInternal()->End();
	}
}

void ExecuteCommandList(Effekseer::RefPtr<EffekseerRenderer::CommandList> commandList)
{
	assert(commandList != nullptr);
	auto c = static_cast<EffekseerRendererLLGI::CommandList*>(commandList.Get());
	c->GetGraphics()->Execute(c->GetInternal());
}

} // namespace EffekseerRendererDX12