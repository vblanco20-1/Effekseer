#pragma clang diagnostic ignored "-Wmissing-prototypes"

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct PS_Input
{
    float4 Pos;
    float2 UV;
};

struct PS_ConstantBuffer
{
    float4 g_filterParams;
    float4 g_intensity;
};

struct main0_out
{
    float4 _entryPointOutput [[color(0)]];
};

struct main0_in
{
    float2 Input_UV [[user(locn0)]];
};

static inline __attribute__((always_inline))
bool isNan(thread const float& val)
{
    return (((val < 0.0) || (0.0 < val)) || (val == 0.0)) ? false : true;
}

static inline __attribute__((always_inline))
float4 _main(PS_Input Input, texture2d<float> g_texture, sampler g_sampler, constant PS_ConstantBuffer& _88)
{
    float3 color = g_texture.sample(g_sampler, Input.UV).xyz;
    float param = color.x;
    if (isNan(param))
    {
        color.x = 0.0;
    }
    float param_1 = color.y;
    if (isNan(param_1))
    {
        color.y = 0.0;
    }
    float param_2 = color.z;
    if (isNan(param_2))
    {
        color.z = 0.0;
    }
    float brightness = dot(color, float3(0.2989999949932098388671875, 0.58700001239776611328125, 0.114000000059604644775390625));
    float soft = brightness - _88.g_filterParams.y;
    soft = fast::clamp(soft, 0.0, _88.g_filterParams.z);
    soft = (soft * soft) * _88.g_filterParams.w;
    float contribution = fast::max(soft, brightness - _88.g_filterParams.x);
    contribution /= fast::max(brightness, 9.9999997473787516355514526367188e-06);
    return float4((color * contribution) * _88.g_intensity.x, 1.0);
}

fragment main0_out main0(main0_in in [[stage_in]], constant PS_ConstantBuffer& _88 [[buffer(0)]], texture2d<float> g_texture [[texture(0)]], sampler g_sampler [[sampler(0)]], float4 gl_FragCoord [[position]])
{
    main0_out out = {};
    PS_Input Input;
    Input.Pos = gl_FragCoord;
    Input.UV = in.Input_UV;
    out._entryPointOutput = _main(Input, g_texture, g_sampler, _88);
    return out;
}

