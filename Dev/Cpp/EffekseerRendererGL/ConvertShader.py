import os
import sys
import subprocess
from pathlib import Path

dxsdk_dir = os.environ.get("DXSDK_DIR")
fxc = dxsdk_dir + "\\Utilities\\bin\\x86\\fxc"

shader_files = [
    "ad_sprite_unlit_vs.fx",
    "ad_sprite_lit_vs.fx",
    "ad_sprite_distortion_vs.fx",
    "ad_model_unlit_vs.fx",
    "ad_model_unlit_ps.fx",
    "ad_model_lit_vs.fx",
    "ad_model_lit_ps.fx",
    "ad_model_distortion_vs.fx",
    "ad_model_distortion_ps.fx",
    "sprite_unlit_vs.fx",
    "sprite_lit_vs.fx",
    "sprite_distortion_vs.fx",
    "model_unlit_vs.fx",
    "model_unlit_ps.fx",
    "model_lit_vs.fx",
    "model_lit_ps.fx",
    "model_distortion_vs.fx",
    "model_distortion_ps.fx",
]


def convert_dx11(profile: str, src_path: Path, dst_path: Path):
    target_path = dst_path / (src_path.stem + ".h")
    subprocess.run(f"{fxc} /Zpc /T{profile} /Emain /D __INST__=40 /Fh {target_path} {src_path}")
    
    code = target_path.read_text()
    code = code.replace("const BYTE g_main", f"const uint8_t dx11_{src_path.stem}")
    target_path.write_text(code)


if __name__ == "__main__":
    root_path = Path('EffekseerRenderer/Shader/')
    dst_path = Path('EffekseerRenderer/ShaderHeader/')
    os.makedirs(dst_path, exist_ok=True)

    for src in shader_files:
        if src.endswith("vs.fx"):
            convert_dx11("vs_4_0", root_path / src, dst_path)
        elif src.endswith("ps.fx"):
            convert_dx11("ps_4_0", root_path / src, dst_path)
