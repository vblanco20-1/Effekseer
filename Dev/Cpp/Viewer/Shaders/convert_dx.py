import os
import sys
import subprocess
from pathlib import Path

dxsdk_dir = os.environ.get("DXSDK_DIR")
fxc = dxsdk_dir + "\\Utilities\\bin\\x86\\fxc"


def convert(device: str, profile: str, src_path: Path, dst_path: Path):
    target_path = Path(f"{dst_path}\\{src_path.stem}.h")
    subprocess.run(f"{fxc} /Zpc /T{profile} /Emain /Fh {target_path} {src_path}")
    
    code = target_path.read_text()
    code = code.replace("const BYTE g_main", f"const uint8_t {device}_{src_path.stem}")
    target_path.write_text(code)


def convert_dx11():
    root_path = Path('HLSL_DX11/')
    dst_path = Path('HLSL_DX11_Header/')
    os.makedirs(dst_path, exist_ok=True)

    for src in root_path.glob("*vs.fx"):
        convert("dx11", "vs_4_0", src, dst_path)

    for src in root_path.glob("*ps.fx"):
        convert("dx11", "ps_4_0", src, dst_path)


def convert_dx12():
    root_path = Path('HLSL_DX12/')
    dst_path = Path('HLSL_DX12_Header/')
    os.makedirs(dst_path, exist_ok=True)

    for src in root_path.glob("*vs.fx"):
        convert("dx12", "vs_4_0", src, dst_path)

    for src in root_path.glob("*ps.fx"):
        convert("dx12", "ps_4_0", src, dst_path)


convert_dx11()
convert_dx12()
