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

static const VS_Output _21 = { 0.0f.xxxx, 0.0f.xxxx, 0.0f.xx };

static float4 gl_Position;
static float3 Input_Pos;
static float2 Input_UV;
static float4 Input_Color;
static float4 _entryPointOutput_Color;
static float2 _entryPointOutput_UV;

struct SPIRV_Cross_Input
{
    float3 Input_Pos : TEXCOORD0;
    float2 Input_UV : TEXCOORD1;
    float4 Input_Color : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _entryPointOutput_Color : TEXCOORD0;
    float2 _entryPointOutput_UV : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

VS_Output _main(VS_Input Input)
{
    VS_Output Output = _21;
    float4 pos4 = float4(Input.Pos.x, Input.Pos.y, Input.Pos.z, 1.0f);
    Output.Position = pos4;
    Output.Color = Input.Color;
    Output.UV = Input.UV;
    return Output;
}

void vert_main()
{
    VS_Input Input;
    Input.Pos = Input_Pos;
    Input.UV = Input_UV;
    Input.Color = Input_Color;
    VS_Output flattenTemp = _main(Input);
    gl_Position = flattenTemp.Position;
    _entryPointOutput_Color = flattenTemp.Color;
    _entryPointOutput_UV = flattenTemp.UV;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    Input_Pos = stage_input.Input_Pos;
    Input_UV = stage_input.Input_UV;
    Input_Color = stage_input.Input_Color;
    vert_main();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._entryPointOutput_Color = _entryPointOutput_Color;
    stage_output._entryPointOutput_UV = _entryPointOutput_UV;
    return stage_output;
}
