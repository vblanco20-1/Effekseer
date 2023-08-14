struct PS_Input
{
    float4 Pos;
    float2 UV;
};

cbuffer PS_ConstantBuffer : register(b1)
{
    float4 _88_g_filterParams : packoffset(c0);
    float4 _88_g_intensity : packoffset(c1);
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

bool isNan(float val)
{
    return (((val < 0.0f) || (0.0f < val)) || (val == 0.0f)) ? false : true;
}

float4 _main(PS_Input Input)
{
    float3 color = g_texture.Sample(g_sampler, Input.UV).xyz;
    float param = color.x;
    if (isNan(param))
    {
        color.x = 0.0f;
    }
    float param_1 = color.y;
    if (isNan(param_1))
    {
        color.y = 0.0f;
    }
    float param_2 = color.z;
    if (isNan(param_2))
    {
        color.z = 0.0f;
    }
    float brightness = dot(color, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
    float soft = brightness - _88_g_filterParams.y;
    soft = clamp(soft, 0.0f, _88_g_filterParams.z);
    soft = (soft * soft) * _88_g_filterParams.w;
    float contribution = max(soft, brightness - _88_g_filterParams.x);
    contribution /= max(brightness, 9.9999997473787516355514526367188e-06f);
    return float4((color * contribution) * _88_g_intensity.x, 1.0f);
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
