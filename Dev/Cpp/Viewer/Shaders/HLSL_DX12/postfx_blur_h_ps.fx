struct PS_Input
{
    float4 Pos;
    float2 UV;
};

cbuffer _Global : register(b1)
{
    float4 _18_g_size : packoffset(c0);
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
    float2 size = _18_g_size.xy;
    float4 color = g_texture.Sample(g_sampler, Input.UV) * 0.2230674326419830322265625f;
    color += (g_texture.Sample(g_sampler, Input.UV + float2((-5.152032375335693359375f) / size.x, 0.0f)) * 0.0052916849963366985321044921875f);
    color += (g_texture.Sample(g_sampler, Input.UV + float2((-3.2509129047393798828125f) / size.x, 0.0f)) * 0.07297551631927490234375f);
    color += (g_texture.Sample(g_sampler, Input.UV + float2((-1.38491213321685791015625f) / size.x, 0.0f)) * 0.310199081897735595703125f);
    color += (g_texture.Sample(g_sampler, Input.UV + float2(1.38491213321685791015625f / size.x, 0.0f)) * 0.310199081897735595703125f);
    color += (g_texture.Sample(g_sampler, Input.UV + float2(3.2509129047393798828125f / size.x, 0.0f)) * 0.07297551631927490234375f);
    color += (g_texture.Sample(g_sampler, Input.UV + float2(5.152032375335693359375f / size.x, 0.0f)) * 0.0052916849963366985321044921875f);
    return float4(color.xyz, 1.0f);
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
