#pragma clang diagnostic ignored "-Wmissing-prototypes"

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct PS_Input
{
    float4 Pos;
    float4 Color;
    float2 UV;
    float4 Position;
};

struct PS_Output
{
    float4 o0;
    float4 o1;
};

struct main0_out
{
    float4 _entryPointOutput_o0 [[color(0)]];
    float4 _entryPointOutput_o1 [[color(1)]];
};

struct main0_in
{
    float4 Input_Color [[user(locn0)]];
    float2 Input_UV [[user(locn1)]];
    float4 Input_Position [[user(locn2)]];
};

static inline __attribute__((always_inline))
PS_Output _main(PS_Input Input)
{
    PS_Output _output;
    _output.o0 = Input.Color;
    _output.o1 = float4(1.0);
    _output.o1.x = Input.Position.z / Input.Position.w;
    if (_output.o0.w == 0.0)
    {
        discard_fragment();
    }
    return _output;
}

fragment main0_out main0(main0_in in [[stage_in]], float4 gl_FragCoord [[position]])
{
    main0_out out = {};
    PS_Input Input;
    Input.Pos = gl_FragCoord;
    Input.Color = in.Input_Color;
    Input.UV = in.Input_UV;
    Input.Position = in.Input_Position;
    PS_Output _67 = _main(Input);
    PS_Output flattenTemp = _67;
    out._entryPointOutput_o0 = flattenTemp.o0;
    out._entryPointOutput_o1 = flattenTemp.o1;
    return out;
}

