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
float4 _main(PS_Input Input, texture2d<float> g_texture0, sampler g_sampler, texture2d<float> g_texture1, texture2d<float> g_texture2, texture2d<float> g_texture3)
{
    float3 c0 = g_texture0.sample(g_sampler, Input.UV).xyz;
    float3 c1 = g_texture1.sample(g_sampler, Input.UV).xyz;
    float3 c2 = g_texture2.sample(g_sampler, Input.UV).xyz;
    float3 c3 = g_texture3.sample(g_sampler, Input.UV).xyz;
    return float4(((c0 + c1) + c2) + c3, 1.0);
}

fragment main0_out main0(main0_in in [[stage_in]], texture2d<float> g_texture0 [[texture(0)]], texture2d<float> g_texture1 [[texture(1)]], texture2d<float> g_texture2 [[texture(2)]], texture2d<float> g_texture3 [[texture(3)]], sampler g_sampler [[sampler(0)]], float4 gl_FragCoord [[position]])
{
    main0_out out = {};
    PS_Input Input;
    Input.Pos = gl_FragCoord;
    Input.UV = in.Input_UV;
    out._entryPointOutput = _main(Input, g_texture0, g_sampler, g_texture1, g_texture2, g_texture3);
    return out;
}

