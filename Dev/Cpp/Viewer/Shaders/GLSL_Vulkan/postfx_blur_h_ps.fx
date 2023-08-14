#pragma clang diagnostic ignored "-Wmissing-prototypes"

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct PS_Input
{
    float4 Pos;
    float2 UV;
};

struct _Global
{
    float4 g_size;
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
float4 _main(PS_Input Input, constant _Global& _18, texture2d<float> g_texture, sampler g_sampler)
{
    float2 size = _18.g_size.xy;
    float4 color = g_texture.sample(g_sampler, Input.UV) * 0.2230674326419830322265625;
    color += (g_texture.sample(g_sampler, (Input.UV + float2((-5.152032375335693359375) / size.x, 0.0))) * 0.0052916849963366985321044921875);
    color += (g_texture.sample(g_sampler, (Input.UV + float2((-3.2509129047393798828125) / size.x, 0.0))) * 0.07297551631927490234375);
    color += (g_texture.sample(g_sampler, (Input.UV + float2((-1.38491213321685791015625) / size.x, 0.0))) * 0.310199081897735595703125);
    color += (g_texture.sample(g_sampler, (Input.UV + float2(1.38491213321685791015625 / size.x, 0.0))) * 0.310199081897735595703125);
    color += (g_texture.sample(g_sampler, (Input.UV + float2(3.2509129047393798828125 / size.x, 0.0))) * 0.07297551631927490234375);
    color += (g_texture.sample(g_sampler, (Input.UV + float2(5.152032375335693359375 / size.x, 0.0))) * 0.0052916849963366985321044921875);
    return float4(color.xyz, 1.0);
}

fragment main0_out main0(main0_in in [[stage_in]], constant _Global& _18 [[buffer(0)]], texture2d<float> g_texture [[texture(0)]], sampler g_sampler [[sampler(0)]], float4 gl_FragCoord [[position]])
{
    main0_out out = {};
    PS_Input Input;
    Input.Pos = gl_FragCoord;
    Input.UV = in.Input_UV;
    out._entryPointOutput = _main(Input, _18, g_texture, g_sampler);
    return out;
}

