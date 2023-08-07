
#pragma once

#include <Effekseer.h>
#include <LLGI.Graphics.h>
#include <LLGI.Platform.h>
#include <LLGI.CommandList.h>
#include <EffekseerRendererLLGI/EffekseerRendererLLGI.Renderer.h>
#include <EffekseerRendererLLGI/EffekseerRendererLLGI.RendererImplemented.h>
#include <EffekseerRendererLLGI/GraphicsDevice.h>

#if defined(_WIN32)
#include <DX12/LLGI.GraphicsDX12.h>
#include <EffekseerRendererDX12/EffekseerRendererDX12.h>
#endif

#if defined(__APPLE__)
#include <Metal/LLGI.GraphicsMetal.h>
#include <EffekseerRendererMetal/EffekseerRendererMetal.h>
#endif

#if defined(ENABLE_VULKAN)
#include <Vulkan/LLGI.GraphicsVulkan.h>
#include <EffekseerRendererVulkan/EffekseerRendererVulkan.h>
#endif

#include "../../efk.Graphics.h"
#include "ImGuiPlatform/ImGuiPlatform.h"

namespace efk
{

class GraphicsLLGI : public Graphics
{
private:
	void* windowHandle = nullptr;
	int32_t windowWidth = 0;
	int32_t windowHeight = 0;
	bool isSRGBMode = false;
	Effekseer::Tool::DeviceType deviceType = {};

	std::shared_ptr<LLGI::Window> window;
	std::shared_ptr<LLGI::Platform> platform;
	std::shared_ptr<LLGI::Graphics> graphics;
	std::shared_ptr<LLGI::SingleFrameMemoryPool> memoryPool;
	std::shared_ptr<LLGI::CommandListPool> commandListPool;
	LLGI::CommandList* commandList = nullptr;

	Effekseer::RefPtr<EffekseerRendererLLGI::Backend::GraphicsDevice> graphicsDevice_;
	std::unique_ptr<ImguiPlatform> imguiPlatform_;

public:
	GraphicsLLGI(Effekseer::Tool::DeviceType deviceType);
	virtual ~GraphicsLLGI();

	bool Initialize(void* windowHandle, int32_t windowWidth, int32_t windowHeight) override;

	void CopyTo(Effekseer::Backend::TextureRef src, Effekseer::Backend::TextureRef dst) override;

	void Resize(int32_t width, int32_t height) override;

	void NewFrame() override;

	bool Present() override;

	void SetRenderTarget(std::vector<Effekseer::Backend::TextureRef> renderTextures, Effekseer::Backend::TextureRef depthTexture) override;

	void SaveTexture(Effekseer::Backend::TextureRef texture, std::vector<Effekseer::Color>& pixels) override;

	void Clear(Effekseer::Color color) override;

	void ResolveRenderTarget(Effekseer::Backend::TextureRef src, Effekseer::Backend::TextureRef dest) override;

	bool CheckFormatSupport(Effekseer::Backend::TextureFormatType format, TextureFeatureType feature) override;

	int GetMultisampleLevel(Effekseer::Backend::TextureFormatType format) override;

	void ResetDevice() override;

	Effekseer::Backend::RenderPassRef GetScreenRenderPass() override;

	LLGI::Graphics* GetDevice() const
	{
		return graphics.get();
	}

	LLGI::Platform* GetPlatform() const
	{
		return platform.get();
	}

	LLGI::CommandList* GetCommandList() const
	{
		return commandList;
	}

	Effekseer::Tool::DeviceType GetDeviceType() const override
	{
		return deviceType;
	}

	Effekseer::RefPtr<Effekseer::Backend::GraphicsDevice> GetGraphicsDevice() override
	{
		return graphicsDevice_;
	}

	ImguiPlatform* GetImguiPlatform() const
	{
		return imguiPlatform_.get();
	}
};
} // namespace efk
