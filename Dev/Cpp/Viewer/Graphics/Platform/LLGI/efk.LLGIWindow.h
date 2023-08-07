
#pragma once

#include <GLFW/glfw3.h>
#include <LLGI.Platform.h>

namespace efk
{

class LLGIWindow : public LLGI::Window
{
	GLFWwindow* window_ = nullptr;

public:
	LLGIWindow(GLFWwindow* window);

	bool OnNewFrame() override;

	void* GetNativePtr(int32_t index) override;

	LLGI::Vec2I GetWindowSize() const override;

	LLGI::Vec2I GetFrameBufferSize() const override;
};

}
