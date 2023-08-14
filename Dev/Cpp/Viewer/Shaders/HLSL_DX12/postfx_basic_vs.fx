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

static float4 gl_Position;
static float2 Input_Pos;
static float2 Input_UV;
static float2 _entryPointOutput_UV;

struct SPIRV_Cross_Input
{
    float2 Input_Pos : TEXCOORD0;
    float2 Input_UV : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float2 _entryPointOutput_UV : TEXCOORD0;
    float4 gl_Position : SV_Position;
};

VS_Output _main(VS_Input Input)
{
    float4 pos4 = float4(Input.Pos.x, Input.Pos.y, 0.0f, 1.0f);
    VS_Output Output;
    Output.Position = pos4;
    Output.UV = Input.UV;
    return Output;
}

void vert_main()
{
    VS_Input Input;
    Input.Pos = Input_Pos;
    Input.UV = Input_UV;
    VS_Output flattenTemp = _main(Input);
    gl_Position = flattenTemp.Position;
    _entryPointOutput_UV = flattenTemp.UV;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    Input_Pos = stage_input.Input_Pos;
    Input_UV = stage_input.Input_UV;
    vert_main();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._entryPointOutput_UV = _entryPointOutput_UV;
    return stage_output;
}
