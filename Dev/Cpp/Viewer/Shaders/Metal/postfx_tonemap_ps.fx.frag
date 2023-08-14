#version 430

struct PS_Input
{
    vec4 Pos;
    vec2 UV;
};

layout(set = 1, binding = 0, std140) uniform PS_ConstantBuffer
{
    vec4 g_toneparams;
} _36;

layout(location = 0, set = 1, binding = 1) uniform sampler2D Sampler_g_sampler;

layout(location = 0) in vec2 Input_UV;
layout(location = 0) out vec4 _entryPointOutput;

vec4 _main(PS_Input Input)
{
    vec3 texel = texture(Sampler_g_sampler, Input.UV).xyz;
    float lum = _36.g_toneparams.x * dot(texel, vec3(0.2989999949932098388671875, 0.58700001239776611328125, 0.114000000059604644775390625));
    lum /= (1.0 + lum);
    return vec4(texel * lum, 1.0);
}

void main()
{
    PS_Input Input;
    Input.Pos = gl_FragCoord;
    Input.UV = Input_UV;
    _entryPointOutput = _main(Input);
}

