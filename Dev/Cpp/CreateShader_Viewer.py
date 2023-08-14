import os
import subprocess
import sys
import glob

transpiler_path = 'ShaderTranspiler'
root_path = 'Viewer/Shaders/HLSL_DX11/'
gl_root_path = 'Viewer/Shaders/GLSL_GL/'
dx12_root_path = 'Viewer/Shaders/HLSL_DX12/'
vulkan_root_path = 'Viewer/Shaders/GLSL_Vulkan/'
metal_root_path = 'Viewer/Shaders/Metal/'

verts = glob.glob(root_path + "*_vs.fx")
frags = glob.glob(root_path + "*_ps.fx")

try:
    subprocess.call(['ShaderTranspiler'])
except:
    print('Please put ShaderTranspiler from https://github.com/altseed/LLGI/tree/master/tools')
    sys.exit(1)

llgi_common_flags = ['-D', '__INST__', '40']
gl_common_flags = ['-D', '__INST__', '10', '-D', '__OPENGL__', '1', '--plain']


def transpile_gl(shaderType, glver, sources, dst_path):
    for f in (sources):
        print('Converting {}'.format(f))
        if glver == "gl3":
            subprocess.call(['ShaderTranspiler', '--' + shaderType, '-G', '--sm', '330', '--input',
                            f, '--output', dst_path + os.path.basename(f)] + gl_common_flags)
        elif glver == "gl4":
            subprocess.call(['ShaderTranspiler', '--' + shaderType, '-G', '--sm', '430', '--input',
                            f, '--output', dst_path + os.path.basename(f)] + gl_common_flags)


def transpile_dx12(shaderType, shaderModel, sources, dst_path):
    for f in (sources):
        print('Converting {}'.format(f))
        subprocess.call(['ShaderTranspiler', '--' + shaderType, '-H', '--sm', shaderModel, '--dx12', '--input',
                        f, '--output', dst_path + os.path.basename(f)] + llgi_common_flags)


def transpile_metal(shaderType, sources, dst_path):
    for f in (sources):
        print('Converting {}'.format(f))
        subprocess.call(['ShaderTranspiler', '--' + shaderType, '-M', '--input', f,
                        '--output', dst_path + os.path.basename(f)] + llgi_common_flags)


def transpile_vulkan(shaderType, sources, dst_path):
    for f in (sources):
        print('Converting {}'.format(f))
        subprocess.call(['ShaderTranspiler', '--' + shaderType, '-V', '--input', f, '--output',
                        dst_path + os.path.basename(f) + '.' + shaderType] + llgi_common_flags)


transpile_gl("vert", "gl3", verts, gl_root_path)
transpile_gl("frag", "gl3", frags, gl_root_path)

# transpile_gl("vert", "gl4", verts, gl_root_path)
# transpile_gl("frag", "gl4", frags, gl_root_path)

os.makedirs(dx12_root_path, exist_ok=True);
transpile_dx12("vert", "50", verts, dx12_root_path)
transpile_dx12("frag", "50", frags, dx12_root_path)

os.makedirs(vulkan_root_path, exist_ok=True);
transpile_metal("vert", verts, vulkan_root_path)
transpile_metal("frag", frags, vulkan_root_path)

os.makedirs(metal_root_path, exist_ok=True);
transpile_vulkan("vert", verts, metal_root_path)
transpile_vulkan("frag", frags, metal_root_path)
