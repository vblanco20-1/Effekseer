#pragma clang diagnostic ignored "-Wmissing-prototypes"

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct VS_Input
{
    float2 Pos;
    float2 UV;
};

struct VS_Output
{
    float4 Position;
    float2 UV;
};

struct main0_out
{
    float2 _entryPointOutput_UV [[user(locn0)]];
    float4 gl_Position [[position]];
};

struct main0_in
{
    float2 Input_Pos [[attribute(0)]];
    float2 Input_UV [[attribute(1)]];
};

static inline __attribute__((always_inline))
VS_Output _main(VS_Input Input)
{
    float4 pos4 = float4(Input.Pos.x, Input.Pos.y, 0.0, 1.0);
    VS_Output Output;
    Output.Position = pos4;
    Output.UV = Input.UV;
    return Output;
}

vertex main0_out main0(main0_in in [[stage_in]])
{
    main0_out out = {};
    VS_Input Input;
    Input.Pos = in.Input_Pos;
    Input.UV = in.Input_UV;
    VS_Output flattenTemp = _main(Input);
    out.gl_Position = flattenTemp.Position;
    out._entryPointOutput_UV = flattenTemp.UV;
    return out;
}

