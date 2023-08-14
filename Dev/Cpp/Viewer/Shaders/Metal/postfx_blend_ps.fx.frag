#version 430

struct PS_Input
{
    vec4 Pos;
    vec2 UV;
};

layout(location = 0, set = 1, binding = 1) uniform sampler2D Sampler_g_sampler;
layout(location = 0, set = 1, binding = 1) uniform sampler2D Sampler_g_sampler_1;
layout(location = 0, set = 1, binding = 1) uniform sampler2D Sampler_g_sampler_2;
layout(location = 0, set = 1, binding = 1) uniform sampler2D Sampler_g_sampler_3;

layout(location = 0) in vec2 Input_UV;
layout(location = 0) out vec4 _entryPointOutput;

vec4 _main(PS_Input Input)
{
    vec3 c0 = texture(Sampler_g_sampler, Input.UV).xyz;
    vec3 c1 = texture(Sampler_g_sampler_1, Input.UV).xyz;
    vec3 c2 = texture(Sampler_g_sampler_2, Input.UV).xyz;
    vec3 c3 = texture(Sampler_g_sampler_3, Input.UV).xyz;
    return vec4(((c0 + c1) + c2) + c3, 1.0);
}

void main()
{
    PS_Input Input;
    Input.Pos = gl_FragCoord;
    Input.UV = Input_UV;
    _entryPointOutput = _main(Input);
}

