#version 430

struct VS_Input
{
    vec3 Pos;
    vec2 UV;
    vec4 Color;
    vec3 Normal;
};

struct VS_Output
{
    vec4 Pos;
    vec2 UV;
    vec4 Color;
    vec3 Normal;
    vec4 Position;
};

layout(set = 0, binding = 0, std140) uniform VS_ConstantBuffer
{
    layout(row_major) mat4 projectionMatrix;
    layout(row_major) mat4 cameraMatrix;
    layout(row_major) mat4 worldMatrix;
} _31;

layout(location = 0) in vec3 input_Pos;
layout(location = 1) in vec2 input_UV;
layout(location = 2) in vec4 input_Color;
layout(location = 3) in vec3 input_Normal;
layout(location = 0) out vec2 _entryPointOutput_UV;
layout(location = 1) out vec4 _entryPointOutput_Color;
layout(location = 2) out vec3 _entryPointOutput_Normal;
layout(location = 3) out vec4 _entryPointOutput_Position;

VS_Output _main(VS_Input _input)
{
    vec4 localPos = vec4(_input.Pos, 1.0);
    vec4 worldPos = localPos * _31.worldMatrix;
    vec4 cameraPos = worldPos * _31.cameraMatrix;
    VS_Output _output;
    _output.Pos = cameraPos * _31.projectionMatrix;
    _output.UV = _input.UV;
    _output.Color = _input.Color;
    _output.Normal = _input.Normal;
    _output.Position = _output.Pos;
    return _output;
}

void main()
{
    VS_Input _input;
    _input.Pos = input_Pos;
    _input.UV = input_UV;
    _input.Color = input_Color;
    _input.Normal = input_Normal;
    VS_Output flattenTemp = _main(_input);
    vec4 _position = flattenTemp.Pos;
    _position.y = -_position.y;
    gl_Position = _position;
    _entryPointOutput_UV = flattenTemp.UV;
    _entryPointOutput_Color = flattenTemp.Color;
    _entryPointOutput_Normal = flattenTemp.Normal;
    _entryPointOutput_Position = flattenTemp.Position;
}

