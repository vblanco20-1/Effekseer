struct PS_Input
{
    float4 PosVS;
    float4 Color;
    float2 UV;
    float4 PosP;
};

cbuffer PS_ConstanBuffer : register(b1)
{
    float4 _47_fLightDirection : packoffset(c0);
    float4 _47_fLightColor : packoffset(c1);
    float4 _47_fLightAmbient : packoffset(c2);
    float4 _47_fFlipbookParameter : packoffset(c3);
    float4 _47_fUVDistortionParameter : packoffset(c4);
    float4 _47_fBlendTextureParameter : packoffset(c5);
    float4 _47_fCameraFrontDirection : packoffset(c6);
    float4 _47_fFalloffParameter : packoffset(c7);
    float4 _47_fFalloffBeginColor : packoffset(c8);
    float4 _47_fFalloffEndColor : packoffset(c9);
    float4 _47_fEmissiveScaling : packoffset(c10);
    float4 _47_fEdgeColor : packoffset(c11);
    float4 _47_fEdgeParameter : packoffset(c12);
    float4 _47_softParticleParam : packoffset(c13);
    float4 _47_reconstructionParam1 : packoffset(c14);
    float4 _47_reconstructionParam2 : packoffset(c15);
    float4 _47_mUVInversedBack : packoffset(c16);
};

Texture2D<float4> _colorTex : register(t0);
SamplerState sampler_colorTex : register(s0);

static float4 gl_FragCoord;
static float4 Input_Color;
static float2 Input_UV;
static float4 Input_PosP;
static float4 _entryPointOutput;

struct SPIRV_Cross_Input
{
    centroid float4 Input_Color : TEXCOORD0;
    centroid float2 Input_UV : TEXCOORD1;
    float4 Input_PosP : TEXCOORD2;
    float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output
{
    float4 _entryPointOutput : SV_Target0;
};

float4 _main(PS_Input Input)
{
    return 1.0f.xxxx;
}

void frag_main()
{
    PS_Input Input;
    Input.PosVS = gl_FragCoord;
    Input.Color = Input_Color;
    Input.UV = Input_UV;
    Input.PosP = Input_PosP;
    _entryPointOutput = _main(Input);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    gl_FragCoord = stage_input.gl_FragCoord;
    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
    Input_Color = stage_input.Input_Color;
    Input_UV = stage_input.Input_UV;
    Input_PosP = stage_input.Input_PosP;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output._entryPointOutput = _entryPointOutput;
    return stage_output;
}
