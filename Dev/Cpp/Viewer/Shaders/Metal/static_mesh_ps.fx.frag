#version 430

struct PS_Input
{
    vec4 Pos;
    vec2 UV;
    vec4 Color;
    vec3 Normal;
    vec4 Position;
};

struct PS_OUTPUT
{
    vec4 o0;
    vec4 o1;
};

layout(set = 1, binding = 0, std140) uniform PS_ConstantBuffer
{
    vec4 isLit;
    vec4 directionalLightDirection;
    vec4 directionalLightColor;
    vec4 ambientLightColor;
} _40;

layout(location = 0, set = 1, binding = 1) uniform sampler2D Sampler_g_sampler;

layout(location = 0) in vec2 Input_UV;
layout(location = 1) in vec4 Input_Color;
layout(location = 2) in vec3 Input_Normal;
layout(location = 3) in vec4 Input_Position;
layout(location = 0) out vec4 _entryPointOutput_o0;
layout(location = 1) out vec4 _entryPointOutput_o1;

PS_OUTPUT _main(PS_Input Input)
{
    PS_OUTPUT _output;
    _output.o0 = Input.Color * texture(Sampler_g_sampler, Input.UV);
    if (_40.isLit.x > 0.0)
    {
        float diffuse = max(dot(_40.directionalLightDirection.xyz, Input.Normal), 0.0);
        vec3 _73 = _output.o0.xyz * ((_40.directionalLightColor.xyz * diffuse) + _40.ambientLightColor.xyz);
        _output.o0 = vec4(_73.x, _73.y, _73.z, _output.o0.w);
    }
    _output.o1 = vec4(1.0);
    _output.o1.x = Input.Position.z / Input.Position.w;
    return _output;
}

void main()
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

