
#include "efk.GraphicsLLGI.h"

#include <fstream>
#include <iostream>
#include <Utils/LLGI.CommandListPool.h>
#include "efk.LLGIWindow.h"

#if defined(_WIN32)
#include "ImGuiPlatform/ImGuiPlatformDX12.h"
#endif

#if defined(__APPLE__)
#include "ImGuiPlatform/ImGuiPlatformMetal.h"
#endif

#if defined(ENABLE_VULKAN)
#include "ImGuiPlatform/ImGuiPlatformVulkan.h"
#endif


namespace efk
{

GraphicsLLGI::GraphicsLLGI(Effekseer::Tool::DeviceType deviceType)
{
	this->deviceType = deviceType;
}

GraphicsLLGI::~GraphicsLLGI()
{
	graphics->WaitFinish();
}

bool GraphicsLLGI::Initialize(void* windowHandle, int32_t windowWidth, int32_t windowHeight)
{
	std::string log = "";

	LLGI::PlatformParameter platformParam{};
#if defined(_WIN32)
	if (this->deviceType == Effekseer::Tool::DeviceType::DirectX12)
	{
		platformParam.Device = LLGI::DeviceType::DirectX12;
	}
#endif
#if defined(__APPLE__)
	if (this->deviceType == Effekseer::Tool::DeviceType::DirectX12)
	{
		platformParam.Device = LLGI::DeviceType::DirectX12;
	}
#endif
#if defined(ENABLE_VULKAN)
	if (this->deviceType == Effekseer::Tool::DeviceType::Vulkan)
	{
		platformParam.Device = LLGI::DeviceType::DirectVulkan;
	}
#endif
	platformParam.WaitVSync = true;

	window = std::shared_ptr<LLGI::Window>(new LLGIWindow((GLFWwindow*)windowHandle));
	if (window == nullptr)
	{
		return false;
	}

	platform = LLGI::CreateSharedPtr(LLGI::CreatePlatform(platformParam, window.get()));
	if (platform == nullptr)
	{
		return false;
	}

	graphics = LLGI::CreateSharedPtr(platform->CreateGraphics());
	if (graphics == nullptr)
	{
		return false;
	}

	memoryPool = LLGI::CreateSharedPtr(graphics->CreateSingleFrameMemoryPool(4 * 1024 * 1024, 128));
	commandListPool = std::make_shared<LLGI::CommandListPool>(graphics.get(), memoryPool.get(), 3);

	this->isSRGBMode = isSRGBMode;
	this->windowHandle = windowHandle;
	this->windowWidth = windowWidth;
	this->windowHeight = windowHeight;

	graphicsDevice_ = Effekseer::MakeRefPtr<EffekseerRendererLLGI::Backend::GraphicsDevice>(graphics.get());

#if defined(_WIN32)
	if (this->deviceType == Effekseer::Tool::DeviceType::DirectX12)
	{
		imguiPlatform_ = std::make_unique<ImguiPlatformDX12>(GetDevice());
	}
#endif
#if defined(__APPLE__)
	if (this->deviceType == Effekseer::Tool::DeviceType::DirectX12)
	{
		imguiPlatform_ = std::make_unique<ImguiPlatformMetal>(GetDevice());
	}
#endif
#if defined(ENABLE_VULKAN)
	if (this->deviceType == Effekseer::Tool::DeviceType::Vulkan)
	{
		imguiPlatform_ = std::make_unique<ImguiPlatformVulkan>(GetDevice(), GetPlatform());
	}
#endif

	return true;

End:
	std::ofstream outputfile("error_native.txt");
	outputfile << log.c_str();
	outputfile.close();

	return false;
}

void GraphicsLLGI::CopyTo(Effekseer::Backend::TextureRef src, Effekseer::Backend::TextureRef dst)
{
	if (src->GetParameter().Size != dst->GetParameter().Size)
		return;

	if (src->GetParameter().Format != dst->GetParameter().Format)
		return;

	if (src->GetParameter().SampleCount != dst->GetParameter().SampleCount)
	{
		ResolveRenderTarget(src, dst);
	}
	else
	{
		// Copy to background
	}
}

void GraphicsLLGI::Resize(int32_t width, int32_t height)
{
	this->windowWidth = width;
	this->windowHeight = height;
	platform->SetWindowSize({width, height});
}

void GraphicsLLGI::NewFrame()
{
	platform->NewFrame();
	memoryPool->NewFrame();

	commandList = commandListPool->Get();
	graphicsDevice_->SetCommandList(commandList);
	commandList->Begin();
}

bool GraphicsLLGI::Present()
{
	commandList->End();
	graphics->Execute(commandList);
	graphicsDevice_->SetCommandList(nullptr);
	platform->Present();
	
	if (Presented)
	{
		Presented();
	}
	
	return true;
}

void GraphicsLLGI::SetRenderTarget(std::vector<Effekseer::Backend::TextureRef> renderTextures, Effekseer::Backend::TextureRef depthTexture)
{
}

void GraphicsLLGI::SaveTexture(Effekseer::Backend::TextureRef texture, std::vector<Effekseer::Color>& pixels)
{
	auto t = texture.DownCast<EffekseerRendererLLGI::Backend::Texture>();

}

void GraphicsLLGI::Clear(Effekseer::Color color)
{
	float ClearColor[] = {color.R / 255.0f, color.G / 255.0f, color.B / 255.0f, color.A / 255.0f};

}

void GraphicsLLGI::ResolveRenderTarget(Effekseer::Backend::TextureRef src, Effekseer::Backend::TextureRef dest)
{
}

bool GraphicsLLGI::CheckFormatSupport(Effekseer::Backend::TextureFormatType format, TextureFeatureType feature)
{
	if (feature == TextureFeatureType::Texture2D)
	{
		return true;
	}
	else if (feature == TextureFeatureType::MultisampledTexture2DRenderTarget)
	{
		return false;
	}
	else if (feature == TextureFeatureType::MultisampledTexture2DResolve)
	{
		return false;
	}
	else
	{
		assert(0);
	}

	return false;
}

int GraphicsLLGI::GetMultisampleLevel(Effekseer::Backend::TextureFormatType format)
{
	return 1;
}

void GraphicsLLGI::ResetDevice()
{
}

Effekseer::Backend::RenderPassRef GraphicsLLGI::GetScreenRenderPass()
{
	auto renderPass = Effekseer::MakeRefPtr<EffekseerRendererLLGI::Backend::RenderPass>(graphicsDevice_.Get());

	renderPass->Init(GetPlatform()->GetCurrentScreen());

	return renderPass;
}

} // namespace efk