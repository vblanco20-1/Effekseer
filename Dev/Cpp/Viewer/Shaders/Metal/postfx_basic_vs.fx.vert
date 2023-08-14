#version 430

struct VS_Input
{
    vec2 Pos;
    vec2 UV;
};

struct VS_Output
{
    vec4 Position;
    vec2 UV;
};

layout(location = 0) in vec2 Input_Pos;
layout(location = 1) in vec2 Input_UV;
layout(location = 0) out vec2 _entryPointOutput_UV;

VS_Output _main(VS_Input Input)
{
    vec4 pos4 = vec4(Input.Pos.x, Input.Pos.y, 0.0, 1.0);
    VS_Output Output;
    Output.Position = pos4;
    Output.UV = Input.UV;
    return Output;
}

void main()
{
    VS_Input Input;
    Input.Pos = Input_Pos;
    Input.UV = Input_UV;
    VS_Output flattenTemp = _main(Input);
    vec4 _position = flattenTemp.Position;
    _position.y = -_position.y;
    gl_Position = _position;
    _entryPointOutput_UV = flattenTemp.UV;
}

