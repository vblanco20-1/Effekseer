cmake_minimum_required(VERSION 3.15)
project(imgui_platform)

set(srcs
    imgui_impl_glfw.cpp
    imgui_impl_glfw.h
    imgui_impl_opengl3.cpp
    imgui_impl_opengl3.h
    imgui_impl_opengl3_loader.h)

if (WIN32)
list(APPEND srcs
	imgui_impl_dx11.cpp
	imgui_impl_dx11.h
)
endif()

if (BUILD_DX12)
list(APPEND srcs
	imgui_impl_dx12.cpp
	imgui_impl_dx12.h
)
endif()

if (BUILD_VULKAN)
list(APPEND srcs
	imgui_impl_vulkan.cpp
	imgui_impl_vulkan.h
)
endif()

if (BUILD_METAL)
list(APPEND srcs
	imgui_impl_metal.mm
	imgui_impl_metal.h
)
endif()


add_library(${PROJECT_NAME} STATIC ${srcs})
target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(${PROJECT_NAME} PRIVATE imgui)
target_include_directories(
    ${PROJECT_NAME}
    PRIVATE
    ${EFK_THIRDPARTY_INCLUDES}
)

add_dependencies(
    ${PROJECT_NAME}
	ExternalProject_glfw)

set_target_properties (${PROJECT_NAME} PROPERTIES FOLDER Thirdparty)

