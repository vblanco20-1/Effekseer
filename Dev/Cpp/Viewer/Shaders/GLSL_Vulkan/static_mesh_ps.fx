#pragma clang diagnostic ignored "-Wmissing-prototypes"

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct PS_Input
{
    float4 Pos;
    float2 UV;
    float4 Color;
    float3 Normal;
    float4 Position;
};

struct PS_OUTPUT
{
    float4 o0;
    float4 o1;
};

struct PS_ConstantBuffer
{
    float4 isLit;
    float4 directionalLightDirection;
    float4 directionalLightColor;
    float4 ambientLightColor;
};

struct main0_out
{
    float4 _entryPointOutput_o0 [[color(0)]];
    float4 _entryPointOutput_o1 [[color(1)]];
};

struct main0_in
{
    float2 Input_UV [[user(locn0)]];
    float4 Input_Color [[user(locn1)]];
    float3 Input_Normal [[user(locn2)]];
    float4 Input_Position [[user(locn3)]];
};

static inline __attribute__((always_inline))
PS_OUTPUT _main(PS_Input Input, texture2d<float> g_texture, sampler g_sampler, constant PS_ConstantBuffer& _40)
{
    PS_OUTPUT _output;
    _output.o0 = Input.Color * g_texture.sample(g_sampler, Input.UV);
    if (_40.isLit.x > 0.0)
    {
        float diffuse = fast::max(dot(_40.directionalLightDirection.xyz, Input.Normal), 0.0);
        float3 _73 = _output.o0.xyz * ((_40.directionalLightColor.xyz * diffuse) + _40.ambientLightColor.xyz);
        _output.o0 = float4(_73.x, _73.y, _73.z, _output.o0.w);
    }
    _output.o1 = float4(1.0);
    _output.o1.x = Input.Position.z / Input.Position.w;
    return _output;
}

fragment main0_out main0(main0_in in [[stage_in]], constant PS_ConstantBuffer& _40 [[buffer(0)]], texture2d<float> g_texture [[texture(0)]], sampler g_sampler [[sampler(0)]], float4 gl_FragCoord [[position]])
{
    main0_out out = {};
    PS_Input Input;
    Input.Pos = gl_FragCoord;
    Input.UV = in.Input_UV;
    Input.Color = in.Input_Color;
    Input.Normal = in.Input_Normal;
    Input.Position = in.Input_Position;
    PS_OUTPUT flattenTemp = _main(Input, g_texture, g_sampler, _40);
    out._entryPointOutput_o0 = flattenTemp.o0;
    out._entryPointOutput_o1 = flattenTemp.o1;
    return out;
}

