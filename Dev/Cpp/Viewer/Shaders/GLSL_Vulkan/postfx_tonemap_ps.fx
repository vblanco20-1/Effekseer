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
    float4 g_toneparams;
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
float4 _main(PS_Input Input, texture2d<float> g_texture, sampler g_sampler, constant PS_ConstantBuffer& _36)
{
    float3 texel = g_texture.sample(g_sampler, Input.UV).xyz;
    float lum = _36.g_toneparams.x * dot(texel, float3(0.2989999949932098388671875, 0.58700001239776611328125, 0.114000000059604644775390625));
    lum /= (1.0 + lum);
    return float4(texel * lum, 1.0);
}

fragment main0_out main0(main0_in in [[stage_in]], constant PS_ConstantBuffer& _36 [[buffer(0)]], texture2d<float> g_texture [[texture(0)]], sampler g_sampler [[sampler(0)]], float4 gl_FragCoord [[position]])
{
    main0_out out = {};
    PS_Input Input;
    Input.Pos = gl_FragCoord;
    Input.UV = in.Input_UV;
    out._entryPointOutput = _main(Input, g_texture, g_sampler, _36);
    return out;
}

