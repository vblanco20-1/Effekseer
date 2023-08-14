#version 430

struct PS_Input
{
    vec4 Pos;
    vec2 UV;
};

layout(set = 1, binding = 0, std140) uniform _Global
{
    vec4 g_size;
} _18;

layout(location = 0, set = 1, binding = 1) uniform sampler2D Sampler_g_sampler;

layout(location = 0) in vec2 Input_UV;
layout(location = 0) out vec4 _entryPointOutput;

vec4 _main(PS_Input Input)
{
    vec2 size = _18.g_size.xy;
    vec4 color1 = texture(Sampler_g_sampler, Input.UV + (vec2(-0.5) / size));
    vec4 color2 = texture(Sampler_g_sampler, Input.UV + (vec2(0.5, -0.5) / size));
    vec4 color3 = texture(Sampler_g_sampler, Input.UV + (vec2(-0.5, 0.5) / size));
    vec4 color4 = texture(Sampler_g_sampler, Input.UV + (vec2(0.5) / size));
    return (((color1 + color2) + color3) + color4) * 0.25;
}

void main()
{
    PS_Input Input;
    Input.Pos = gl_FragCoord;
    Input.UV = Input_UV;
    _entryPointOutput = _main(Input);
}

