# Install script for directory: E:/ProgrammingProjects/advnGame/third_party/Effekseer/EffekseerForCpp/src

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "E:/ProgrammingProjects/advnGame/third_party/Effekseer/EffekseerForCpp/install_vulkan_msvc2022_x64")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("E:/ProgrammingProjects/advnGame/third_party/Effekseer/EffekseerForCpp/build_vulkan_msvc2022_x64/src/Effekseer/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("E:/ProgrammingProjects/advnGame/third_party/Effekseer/EffekseerForCpp/build_vulkan_msvc2022_x64/src/EffekseerRendererCommon/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("E:/ProgrammingProjects/advnGame/third_party/Effekseer/EffekseerForCpp/build_vulkan_msvc2022_x64/src/3rdParty/LLGI/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("E:/ProgrammingProjects/advnGame/third_party/Effekseer/EffekseerForCpp/build_vulkan_msvc2022_x64/src/EffekseerRendererLLGI/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("E:/ProgrammingProjects/advnGame/third_party/Effekseer/EffekseerForCpp/build_vulkan_msvc2022_x64/src/EffekseerRendererDX9/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("E:/ProgrammingProjects/advnGame/third_party/Effekseer/EffekseerForCpp/build_vulkan_msvc2022_x64/src/EffekseerRendererDX11/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("E:/ProgrammingProjects/advnGame/third_party/Effekseer/EffekseerForCpp/build_vulkan_msvc2022_x64/src/EffekseerRendererGL/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("E:/ProgrammingProjects/advnGame/third_party/Effekseer/EffekseerForCpp/build_vulkan_msvc2022_x64/src/EffekseerRendererDX12/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("E:/ProgrammingProjects/advnGame/third_party/Effekseer/EffekseerForCpp/build_vulkan_msvc2022_x64/src/EffekseerRendererVulkan/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("E:/ProgrammingProjects/advnGame/third_party/Effekseer/EffekseerForCpp/build_vulkan_msvc2022_x64/src/EffekseerSoundDSound/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("E:/ProgrammingProjects/advnGame/third_party/Effekseer/EffekseerForCpp/build_vulkan_msvc2022_x64/src/EffekseerSoundXAudio2/cmake_install.cmake")
endif()

