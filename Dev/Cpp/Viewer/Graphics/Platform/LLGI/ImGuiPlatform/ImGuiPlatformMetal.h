
#pragma once

#include "ImGuiPlatform.h"
#include <unordered_set>

namespace efk
{

class ImguiPlatformMetal_Impl;

class ImguiPlatformMetal : public ImguiPlatform
{
	ImguiPlatformMetal_Impl* impl = nullptr;
	std::unordered_set<std::shared_ptr<LLGI::Texture>> textures_;

public:
	ImguiPlatformMetal(LLGI::Graphics* g);

	~ImguiPlatformMetal() override;

	void Init() override;

	void Shutdown() override;

	void NewFrame(LLGI::RenderPass* renderPass) override;

	void RenderDrawData(ImDrawData* draw_data, LLGI::CommandList* commandList) override;

	ImTextureID ToTextureID(LLGI::Texture* texture) override;

	void CreateFont() override;

	void DisposeFont() override;
};

}
