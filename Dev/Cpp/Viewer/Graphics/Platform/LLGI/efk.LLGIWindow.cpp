
#ifdef _WIN32
#define GLFW_EXPOSE_NATIVE_WIN32 1
#endif

#ifdef __APPLE__
#define GLFW_EXPOSE_NATIVE_COCOA 1
#endif

#ifdef __linux__
#define GLFW_EXPOSE_NATIVE_X11 1
#undef Always
#endif

#include <GLFW/glfw3.h>
#include <GLFW/glfw3native.h>

#ifdef __linux__
#undef Always
#endif

#include <LLGI.CommandList.h>
#include <LLGI.Graphics.h>
#include <LLGI.Platform.h>
#include <LLGI.Texture.h>

#ifdef _WIN32
#pragma comment(lib, "d3dcompiler.lib")
#elif __APPLE__
#endif

// Use a library to use imgui with LLGI
#include "ImGuiPlatform/ImGuiPlatform.h"

#ifdef _WIN32
#include "ImGuiPlatform/ImGuiPlatformDX12.h"

#elif __APPLE__
#include "ImGuiPlatform/ImGuiPlatformMetal.h"
#endif

#ifdef ENABLE_VULKAN
#include "ImGuiPlatform/ImGuiPlatformVulkan.h"
#endif

#include <imgui_impl_glfw.h>

#include "efk.LLGIWindow.h"

namespace efk
{

LLGIWindow::LLGIWindow(GLFWwindow* window)
	: window_(window)
{
}

bool LLGIWindow::OnNewFrame()
{
	return glfwWindowShouldClose(window_) == GL_FALSE;
}

void* LLGIWindow::GetNativePtr(int32_t index)
{
#ifdef _WIN32
	if (index == 0)
	{
		return glfwGetWin32Window(window_);
	}

	return (HINSTANCE)GetModuleHandle(0);
#endif

#ifdef __APPLE__
	return glfwGetCocoaWindow(window_);
#endif

#ifdef __linux__
	if (index == 0)
	{
		return glfwGetX11Display();
	}

	return reinterpret_cast<void*>(glfwGetX11Window(window_));
#endif
}

LLGI::Vec2I LLGIWindow::GetWindowSize() const
{
	int w, h;
	glfwGetWindowSize(window_, &w, &h);
	return LLGI::Vec2I(w, h);
}

LLGI::Vec2I LLGIWindow::GetFrameBufferSize() const
{
	int w, h;
	glfwGetFramebufferSize(window_, &w, &h);
	return LLGI::Vec2I(w, h);
}

}
