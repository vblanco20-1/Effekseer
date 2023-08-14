struct PS_Input
{
    float4 Pos;
    float2 UV;
};

cbuffer PS_ConstantBuffer : register(b1)
{
    float4 _36_g_toneparams : packoffset(c0);
};

Texture2D<float4> g_texture : register(t0);
SamplerState g_sampler : register(s0);

static float4 gl_FragCoord;
static float2 Input_UV;
static float4 _entryPointOutput;

struct SPIRV_Cross_Input
{
    float2 Input_UV : TEXCOORD0;
    float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output
{
    float4 _entryPointOutput : SV_Target0;
};

float4 _main(PS_Input Input)
{
    float3 texel = g_texture.Sample(g_sampler, Input.UV).xyz;
    float lum = _36_g_toneparams.x * dot(texel, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
    lum /= (1.0f + lum);
    return float4(texel * lum, 1.0f);
}

void frag_main()
{
    PS_Input Input;
    Input.Pos = gl_FragCoord;
    Input.UV = Input_UV;
    _entryPointOutput = _main(Input);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    gl_FragCoord = stage_input.gl_FragCoord;
    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
    Input_UV = stage_input.Input_UV;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output._entryPointOutput = _entryPointOutput;
    return stage_output;
}
