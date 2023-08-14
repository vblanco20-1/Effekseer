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

static float4 gl_FragCoord;
static float4 Input_Color;
static float2 Input_UV;
static float4 Input_Position;
static float4 _entryPointOutput_o0;
static float4 _entryPointOutput_o1;

struct SPIRV_Cross_Input
{
    float4 Input_Color : TEXCOORD0;
    float2 Input_UV : TEXCOORD1;
    float4 Input_Position : TEXCOORD2;
    float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output
{
    float4 _entryPointOutput_o0 : SV_Target0;
    float4 _entryPointOutput_o1 : SV_Target1;
};

PS_Output _main(PS_Input Input)
{
    PS_Output _output;
    _output.o0 = Input.Color;
    _output.o1 = 1.0f.xxxx;
    _output.o1.x = Input.Position.z / Input.Position.w;
    if (_output.o0.w == 0.0f)
    {
        discard;
    }
    return _output;
}

void frag_main()
{
    PS_Input Input;
    Input.Pos = gl_FragCoord;
    Input.Color = Input_Color;
    Input.UV = Input_UV;
    Input.Position = Input_Position;
    PS_Output _67 = _main(Input);
    PS_Output flattenTemp = _67;
    _entryPointOutput_o0 = flattenTemp.o0;
    _entryPointOutput_o1 = flattenTemp.o1;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    gl_FragCoord = stage_input.gl_FragCoord;
    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
    Input_Color = stage_input.Input_Color;
    Input_UV = stage_input.Input_UV;
    Input_Position = stage_input.Input_Position;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output._entryPointOutput_o0 = _entryPointOutput_o0;
    stage_output._entryPointOutput_o1 = _entryPointOutput_o1;
    return stage_output;
}
