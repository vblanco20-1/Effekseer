#version 430

struct VS_Input
{
    vec3 Pos;
    vec2 UV;
    vec4 Color;
};

struct VS_Output
{
    vec4 Position;
    vec4 Color;
    vec2 UV;
};

layout(location = 0) in vec3 Input_Pos;
layout(location = 1) in vec2 Input_UV;
layout(location = 2) in vec4 Input_Color;
layout(location = 0) out vec4 _entryPointOutput_Color;
layout(location = 1) out vec2 _entryPointOutput_UV;

VS_Output _main(VS_Input Input)
{
    VS_Output Output = VS_Output(vec4(0.0), vec4(0.0), vec2(0.0));
    vec4 pos4 = vec4(Input.Pos.x, Input.Pos.y, Input.Pos.z, 1.0);
    Output.Position = pos4;
    Output.Color = Input.Color;
    Output.UV = Input.UV;
    return Output;
}

void main()
{
    VS_Input Input;
    Input.Pos = Input_Pos;
    Input.UV = Input_UV;
    Input.Color = Input_Color;
    VS_Output flattenTemp = _main(Input);
    vec4 _position = flattenTemp.Position;
    _position.y = -_position.y;
    gl_Position = _position;
    _entryPointOutput_Color = flattenTemp.Color;
    _entryPointOutput_UV = flattenTemp.UV;
}

