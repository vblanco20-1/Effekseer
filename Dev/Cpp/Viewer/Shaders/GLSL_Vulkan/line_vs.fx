#pragma clang diagnostic ignored "-Wmissing-prototypes"

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct VS_Input
{
    float3 Pos;
    float4 Color;
    float2 UV;
};

struct VS_Output
{
    float4 Pos;
    float4 Color;
    float2 UV;
    float4 Position;
};

struct _Global
{
    float4x4 mCamera;
    float4x4 mProj;
};

struct main0_out
{
    float4 _entryPointOutput_Color [[user(locn0)]];
    float2 _entryPointOutput_UV [[user(locn1)]];
    float4 _entryPointOutput_Position [[user(locn2)]];
    float4 gl_Position [[position]];
};

struct main0_in
{
    float3 Input_Pos [[attribute(0)]];
    float4 Input_Color [[attribute(1)]];
    float2 Input_UV [[attribute(2)]];
};

static inline __attribute__((always_inline))
VS_Output _main(VS_Input Input, constant _Global& _40)
{
    VS_Output Output = VS_Output{ float4(0.0), float4(0.0), float2(0.0), float4(0.0) };
    float4 pos4 = float4(Input.Pos.x, Input.Pos.y, Input.Pos.z, 1.0);
    float4 cameraPos = _40.mCamera * pos4;
    cameraPos /= float4(cameraPos.w);
    Output.Position = _40.mProj * cameraPos;
    Output.Pos = Output.Position;
    Output.UV = Input.UV;
    Output.Color = Input.Color;
    return Output;
}

vertex main0_out main0(main0_in in [[stage_in]], constant _Global& _40 [[buffer(0)]])
{
    main0_out out = {};
    VS_Input Input;
    Input.Pos = in.Input_Pos;
    Input.Color = in.Input_Color;
    Input.UV = in.Input_UV;
    VS_Output flattenTemp = _main(Input, _40);
    out.gl_Position = flattenTemp.Pos;
    out._entryPointOutput_Color = flattenTemp.Color;
    out._entryPointOutput_UV = flattenTemp.UV;
    out._entryPointOutput_Position = flattenTemp.Position;
    return out;
}

