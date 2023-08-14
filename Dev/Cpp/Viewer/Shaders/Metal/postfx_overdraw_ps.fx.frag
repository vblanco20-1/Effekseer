#version 430

struct PS_Input
{
    vec4 Pos;
    vec2 UV;
};

layout(location = 0, set = 1, binding = 1) uniform sampler2D Sampler_g_sampler;

layout(location = 0) in vec2 Input_UV;
layout(location = 0) out vec4 _entryPointOutput;

vec4 _main(PS_Input Input)
{
    float value = texture(Sampler_g_sampler, Input.UV).x / 8.0;
    return vec4(min(1.0, value * 2.0), abs(1.0 - (value * 2.0)), max(0.0, (value * 2.0) - 1.0), 1.0);
}

void main()
{
    PS_Input Input;
    Input.Pos = gl_FragCoord;
    Input.UV = Input_UV;
    _entryPointOutput = _main(Input);
}

