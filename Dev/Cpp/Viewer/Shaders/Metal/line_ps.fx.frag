#version 430

struct PS_Input
{
    vec4 Pos;
    vec4 Color;
    vec2 UV;
    vec4 Position;
};

struct PS_Output
{
    vec4 o0;
    vec4 o1;
};

layout(location = 0) in vec4 Input_Color;
layout(location = 1) in vec2 Input_UV;
layout(location = 2) in vec4 Input_Position;
layout(location = 0) out vec4 _entryPointOutput_o0;
layout(location = 1) out vec4 _entryPointOutput_o1;

PS_Output _main(PS_Input Input)
{
    PS_Output _output;
    _output.o0 = Input.Color;
    _output.o1 = vec4(1.0);
    _output.o1.x = Input.Position.z / Input.Position.w;
    if (_output.o0.w == 0.0)
    {
        discard;
    }
    return _output;
}

void main()
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

