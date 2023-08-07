
#pragma once

#include <imgui.h>
#include <imgui_impl_dx12.h>
#include "ImGuiPlatform.h"

#include <DX12/LLGI.CommandListDX12.h>
#include <DX12/LLGI.GraphicsDX12.h>
#include <DX12/LLGI.TextureDX12.h>

#if defined(_WIN32)
#undef CreateFont
#endif

namespace efk
{

class ImguiPlatformDX12 : public ImguiPlatform
{
	const int32_t DescriptorMax = 512;
	LLGI::GraphicsDX12* g_ = nullptr;
	ID3D12DescriptorHeap* srvDescHeap_ = nullptr;
	int32_t handleOffset_ = 0;
	int32_t handleSize_ = 0;

	std::unordered_map<std::shared_ptr<LLGI::Texture>, ImTextureID> textures_;

public:
	ImguiPlatformDX12(LLGI::Graphics* g);

	virtual ~ImguiPlatformDX12();

	void Init() override;

	void Shutdown() override;

	void NewFrame(LLGI::RenderPass* renderPass) override;

	ImTextureID ToTextureID(LLGI::Texture* texture) override;

	void RenderDrawData(ImDrawData* draw_data, LLGI::CommandList* commandList) override;

	void CreateFont() override;

	void DisposeFont() override;
};

}
