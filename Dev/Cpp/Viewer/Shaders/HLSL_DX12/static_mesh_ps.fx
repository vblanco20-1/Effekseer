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

cbuffer PS_ConstantBuffer : register(b1)
{
    float4 _40_isLit : packoffset(c0);
    float4 _40_directionalLightDirection : packoffset(c1);
    float4 _40_directionalLightColor : packoffset(c2);
    float4 _40_ambientLightColor : packoffset(c3);
};

Texture2D<float4> g_texture : register(t0);
SamplerState g_sampler : register(s0);

static float4 gl_FragCoord;
static float2 Input_UV;
static float4 Input_Color;
static float3 Input_Normal;
static float4 Input_Position;
static float4 _entryPointOutput_o0;
static float4 _entryPointOutput_o1;

struct SPIRV_Cross_Input
{
    float2 Input_UV : TEXCOORD0;
    float4 Input_Color : TEXCOORD1;
    float3 Input_Normal : TEXCOORD2;
    float4 Input_Position : TEXCOORD3;
    float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output
{
    float4 _entryPointOutput_o0 : SV_Target0;
    float4 _entryPointOutput_o1 : SV_Target1;
};

PS_OUTPUT _main(PS_Input Input)
{
    PS_OUTPUT _output;
    _output.o0 = Input.Color * g_texture.Sample(g_sampler, Input.UV);
    if (_40_isLit.x > 0.0f)
    {
        float diffuse = max(dot(_40_directionalLightDirection.xyz, Input.Normal), 0.0f);
        float3 _73 = _output.o0.xyz * ((_40_directionalLightColor.xyz * diffuse) + _40_ambientLightColor.xyz);
        _output.o0 = float4(_73.x, _73.y, _73.z, _output.o0.w);
    }
    _output.o1 = 1.0f.xxxx;
    _output.o1.x = Input.Position.z / Input.Position.w;
    return _output;
}

void frag_main()
{
    PS_Input Input;
    Input.Pos = gl_FragCoord;
    Input.UV = Input_UV;
    Input.Color = Input_Color;
    Input.Normal = Input_Normal;
    Input.Position = Input_Position;
    PS_OUTPUT flattenTemp = _main(Input);
    _entryPointOutput_o0 = flattenTemp.o0;
    _entryPointOutput_o1 = flattenTemp.o1;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    gl_FragCoord = stage_input.gl_FragCoord;
    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
    Input_UV = stage_input.Input_UV;
    Input_Color = stage_input.Input_Color;
    Input_Normal = stage_input.Input_Normal;
    Input_Position = stage_input.Input_Position;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output._entryPointOutput_o0 = _entryPointOutput_o0;
    stage_output._entryPointOutput_o1 = _entryPointOutput_o1;
    return stage_output;
}
