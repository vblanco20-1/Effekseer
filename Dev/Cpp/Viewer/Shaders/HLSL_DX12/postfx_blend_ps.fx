struct PS_Input
{
    float4 Pos;
    float2 UV;
};

Texture2D<float4> g_texture0 : register(t0);
SamplerState g_sampler : register(s0);
Texture2D<float4> g_texture1 : register(t1);
Texture2D<float4> g_texture2 : register(t2);
Texture2D<float4> g_texture3 : register(t3);

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
    float3 c0 = g_texture0.Sample(g_sampler, Input.UV).xyz;
    float3 c1 = g_texture1.Sample(g_sampler, Input.UV).xyz;
    float3 c2 = g_texture2.Sample(g_sampler, Input.UV).xyz;
    float3 c3 = g_texture3.Sample(g_sampler, Input.UV).xyz;
    return float4(((c0 + c1) + c2) + c3, 1.0f);
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
