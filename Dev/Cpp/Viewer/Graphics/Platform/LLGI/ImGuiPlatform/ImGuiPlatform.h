#pragma once

#include <LLGI.CommandList.h>
#include <LLGI.Graphics.h>
#include <LLGI.Platform.h>

#include <imgui.h>

#if defined(_WIN32)
#undef CreateFont
#endif

namespace efk
{

class ImguiPlatform
{
public:
	ImguiPlatform() = default;
	virtual ~ImguiPlatform() = default;

	virtual void Init() = 0;

	virtual void Shutdown() = 0;

	virtual void NewFrame(LLGI::RenderPass* renderPass) = 0;

	virtual void RenderDrawData(ImDrawData* draw_data, LLGI::CommandList* commandList) = 0;

	virtual ImTextureID ToTextureID(LLGI::Texture* texture) { return nullptr; }

	virtual void CreateFont() {}

	virtual void DisposeFont() {}
};

}
