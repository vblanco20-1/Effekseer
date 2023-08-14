#pragma clang diagnostic ignored "-Wmissing-prototypes"

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct VS_Input
{
    float3 Pos;
    float2 UV;
    float4 Color;
    float3 Normal;
};

struct VS_Output
{
    float4 Pos;
    float2 UV;
    float4 Color;
    float3 Normal;
    float4 Position;
};

struct VS_ConstantBuffer
{
    float4x4 projectionMatrix;
    float4x4 cameraMatrix;
    float4x4 worldMatrix;
};

struct main0_out
{
    float2 _entryPointOutput_UV [[user(locn0)]];
    float4 _entryPointOutput_Color [[user(locn1)]];
    float3 _entryPointOutput_Normal [[user(locn2)]];
    float4 _entryPointOutput_Position [[user(locn3)]];
    float4 gl_Position [[position]];
};

struct main0_in
{
    float3 input_Pos [[attribute(0)]];
    float2 input_UV [[attribute(1)]];
    float4 input_Color [[attribute(2)]];
    float3 input_Normal [[attribute(3)]];
};

static inline __attribute__((always_inline))
VS_Output _main(VS_Input _input, constant VS_ConstantBuffer& _31)
{
    float4 localPos = float4(_input.Pos, 1.0);
    float4 worldPos = _31.worldMatrix * localPos;
    float4 cameraPos = _31.cameraMatrix * worldPos;
    VS_Output _output;
    _output.Pos = _31.projectionMatrix * cameraPos;
    _output.UV = _input.UV;
    _output.Color = _input.Color;
    _output.Normal = _input.Normal;
    _output.Position = _output.Pos;
    return _output;
}

vertex main0_out main0(main0_in in [[stage_in]], constant VS_ConstantBuffer& _31 [[buffer(0)]])
{
    main0_out out = {};
    VS_Input _input;
    _input.Pos = in.input_Pos;
    _input.UV = in.input_UV;
    _input.Color = in.input_Color;
    _input.Normal = in.input_Normal;
    VS_Output flattenTemp = _main(_input, _31);
    out.gl_Position = flattenTemp.Pos;
    out._entryPointOutput_UV = flattenTemp.UV;
    out._entryPointOutput_Color = flattenTemp.Color;
    out._entryPointOutput_Normal = flattenTemp.Normal;
    out._entryPointOutput_Position = flattenTemp.Position;
    return out;
}

