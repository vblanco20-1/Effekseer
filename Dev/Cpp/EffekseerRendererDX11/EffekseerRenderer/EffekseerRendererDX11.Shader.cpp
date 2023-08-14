#include "EffekseerRendererDX11.Shader.h"
#include "EffekseerRendererDX11.RendererImplemented.h"

namespace EffekseerRendererDX11
{

Shader::Shader(Effekseer::Backend::GraphicsDeviceRef graphicsDevice,
			   Backend::ShaderRef shader,
			   Backend::D3D11InputLayoutPtr vertexDeclaration)
	: graphicsDevice_(graphicsDevice)
	, shader_(shader)
	, vertexDeclaration_(std::move(vertexDeclaration))
{
}

Shader::~Shader()
{
}

std::unique_ptr<Shader> Shader::Create(Effekseer::Backend::GraphicsDeviceRef graphicsDevice,
									   Effekseer::Backend::ShaderRef shader,
									   Effekseer::Backend::VertexLayoutRef layout,
									   const char* name)
{
	auto shaderdx11 = shader.DownCast<Backend::Shader>();
	auto gd = graphicsDevice.DownCast<Backend::GraphicsDevice>();
	auto inputLayout = Backend::CreateInputLayout(*gd.Get(), layout.DownCast<Backend::VertexLayout>(), shaderdx11->GetVertexShaderData().data(), shaderdx11->GetVertexShaderData().size());

	if (inputLayout == nullptr)
	{
		printf("* %s Layout Error\n", name);
		return nullptr;
	}

	return std::unique_ptr<Shader>(new Shader(graphicsDevice, std::move(shaderdx11), std::move(inputLayout)));
}

void Shader::SetVertexConstantBufferSize(int32_t size)
{
	m_vertexConstantBuffer.reset(new uint8_t[size]);

	D3D11_BUFFER_DESC hBufferDesc;
	hBufferDesc.ByteWidth = size;
	hBufferDesc.Usage = D3D11_USAGE_DEFAULT;
	hBufferDesc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
	hBufferDesc.CPUAccessFlags = 0;
	hBufferDesc.MiscFlags = 0;
	hBufferDesc.StructureByteStride = sizeof(float);

	auto gd = graphicsDevice_.DownCast<Backend::GraphicsDevice>();
	ID3D11Buffer* buffer = nullptr;
	gd->GetDevice()->CreateBuffer(&hBufferDesc, nullptr, &buffer);
	m_constantBufferToVS.reset(buffer);

	vertexConstantBufferSize_ = size;
}

void Shader::SetPixelConstantBufferSize(int32_t size)
{
	m_pixelConstantBuffer.reset(new uint8_t[size]);

	D3D11_BUFFER_DESC hBufferDesc;
	hBufferDesc.ByteWidth = size;
	hBufferDesc.Usage = D3D11_USAGE_DEFAULT;
	hBufferDesc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
	hBufferDesc.CPUAccessFlags = 0;
	hBufferDesc.MiscFlags = 0;
	hBufferDesc.StructureByteStride = sizeof(float);

	auto gd = graphicsDevice_.DownCast<Backend::GraphicsDevice>();
	ID3D11Buffer* buffer = nullptr;
	gd->GetDevice()->CreateBuffer(&hBufferDesc, nullptr, &buffer);
	m_constantBufferToPS.reset(buffer);

	pixelConstantBufferSize_ = size;
}

void Shader::SetConstantBuffer()
{
	auto gd = graphicsDevice_.DownCast<Backend::GraphicsDevice>();

	if (m_vertexConstantBuffer != nullptr)
	{
		gd->GetContext()->UpdateSubresource(m_constantBufferToVS.get(), 0, nullptr, m_vertexConstantBuffer.get(), 0, 0);
		ID3D11Buffer* buffers[] = {m_constantBufferToVS.get()};
		gd->GetContext()->VSSetConstantBuffers(0, 1, buffers);
	}

	if (m_pixelConstantBuffer != nullptr)
	{
		gd->GetContext()->UpdateSubresource(m_constantBufferToPS.get(), 0, nullptr, m_pixelConstantBuffer.get(), 0, 0);
		ID3D11Buffer* buffers[] = {m_constantBufferToPS.get()};
		gd->GetContext()->PSSetConstantBuffers(1, 1, buffers);
	}
}

} // namespace EffekseerRendererDX11