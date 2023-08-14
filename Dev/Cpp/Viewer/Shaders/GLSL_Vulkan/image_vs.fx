#pragma clang diagnostic ignored "-Wmissing-prototypes"

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct VS_Input
{
    float3 Pos;
    float2 UV;
    float4 Color;
};

struct VS_Output
{
    float4 Position;
    float4 Color;
    float2 UV;
};

struct main0_out
{
    float4 _entryPointOutput_Color [[user(locn0)]];
    float2 _entryPointOutput_UV [[user(locn1)]];
    float4 gl_Position [[position]];
};

struct main0_in
{
    float3 Input_Pos [[attribute(0)]];
    float2 Input_UV [[attribute(1)]];
    float4 Input_Color [[attribute(2)]];
};

static inline __attribute__((always_inline))
VS_Output _main(VS_Input Input)
{
    VS_Output Output = VS_Output{ float4(0.0), float4(0.0), float2(0.0) };
    float4 pos4 = float4(Input.Pos.x, Input.Pos.y, Input.Pos.z, 1.0);
    Output.Position = pos4;
    Output.Color = Input.Color;
    Output.UV = Input.UV;
    return Output;
}

vertex main0_out main0(main0_in in [[stage_in]])
{
    main0_out out = {};
    VS_Input Input;
    Input.Pos = in.Input_Pos;
    Input.UV = in.Input_UV;
    Input.Color = in.Input_Color;
    VS_Output flattenTemp = _main(Input);
    out.gl_Position = flattenTemp.Position;
    out._entryPointOutput_Color = flattenTemp.Color;
    out._entryPointOutput_UV = flattenTemp.UV;
    return out;
}

