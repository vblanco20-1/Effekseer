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

cbuffer VS_ConstantBuffer : register(b0)
{
    column_major float4x4 _31_projectionMatrix : packoffset(c0);
    column_major float4x4 _31_cameraMatrix : packoffset(c4);
    column_major float4x4 _31_worldMatrix : packoffset(c8);
};


static float4 gl_Position;
static float3 input_Pos;
static float2 input_UV;
static float4 input_Color;
static float3 input_Normal;
static float2 _entryPointOutput_UV;
static float4 _entryPointOutput_Color;
static float3 _entryPointOutput_Normal;
static float4 _entryPointOutput_Position;

struct SPIRV_Cross_Input
{
    float3 input_Pos : TEXCOORD0;
    float2 input_UV : TEXCOORD1;
    float4 input_Color : TEXCOORD2;
    float3 input_Normal : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float2 _entryPointOutput_UV : TEXCOORD0;
    float4 _entryPointOutput_Color : TEXCOORD1;
    float3 _entryPointOutput_Normal : TEXCOORD2;
    float4 _entryPointOutput_Position : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

VS_Output _main(VS_Input _input)
{
    float4 localPos = float4(_input.Pos, 1.0f);
    float4 worldPos = mul(_31_worldMatrix, localPos);
    float4 cameraPos = mul(_31_cameraMatrix, worldPos);
    VS_Output _output;
    _output.Pos = mul(_31_projectionMatrix, cameraPos);
    _output.UV = _input.UV;
    _output.Color = _input.Color;
    _output.Normal = _input.Normal;
    _output.Position = _output.Pos;
    return _output;
}

void vert_main()
{
    VS_Input _input;
    _input.Pos = input_Pos;
    _input.UV = input_UV;
    _input.Color = input_Color;
    _input.Normal = input_Normal;
    VS_Output flattenTemp = _main(_input);
    gl_Position = flattenTemp.Pos;
    _entryPointOutput_UV = flattenTemp.UV;
    _entryPointOutput_Color = flattenTemp.Color;
    _entryPointOutput_Normal = flattenTemp.Normal;
    _entryPointOutput_Position = flattenTemp.Position;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    input_Pos = stage_input.input_Pos;
    input_UV = stage_input.input_UV;
    input_Color = stage_input.input_Color;
    input_Normal = stage_input.input_Normal;
    vert_main();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._entryPointOutput_UV = _entryPointOutput_UV;
    stage_output._entryPointOutput_Color = _entryPointOutput_Color;
    stage_output._entryPointOutput_Normal = _entryPointOutput_Normal;
    stage_output._entryPointOutput_Position = _entryPointOutput_Position;
    return stage_output;
}
