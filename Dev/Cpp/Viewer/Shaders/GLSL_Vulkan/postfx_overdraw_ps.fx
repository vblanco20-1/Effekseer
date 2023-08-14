#pragma clang diagnostic ignored "-Wmissing-prototypes"

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct PS_Input
{
    float4 Pos;
    float2 UV;
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
float4 _main(PS_Input Input, texture2d<float> g_texture, sampler g_sampler)
{
    float value = g_texture.sample(g_sampler, Input.UV).x / 8.0;
    return float4(fast::min(1.0, value * 2.0), abs(1.0 - (value * 2.0)), fast::max(0.0, (value * 2.0) - 1.0), 1.0);
}

fragment main0_out main0(main0_in in [[stage_in]], texture2d<float> g_texture [[texture(0)]], sampler g_sampler [[sampler(0)]], float4 gl_FragCoord [[position]])
{
    main0_out out = {};
    PS_Input Input;
    Input.Pos = gl_FragCoord;
    Input.UV = in.Input_UV;
    out._entryPointOutput = _main(Input, g_texture, g_sampler);
    return out;
}

