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
    vec4 color = texture(Sampler_g_sampler, Input.UV) * 0.2230674326419830322265625;
    color += (texture(Sampler_g_sampler, Input.UV + vec2(0.0, (-5.152032375335693359375) / size.y)) * 0.0052916849963366985321044921875);
    color += (texture(Sampler_g_sampler, Input.UV + vec2(0.0, (-3.2509129047393798828125) / size.y)) * 0.07297551631927490234375);
    color += (texture(Sampler_g_sampler, Input.UV + vec2(0.0, (-1.38491213321685791015625) / size.y)) * 0.310199081897735595703125);
    color += (texture(Sampler_g_sampler, Input.UV + vec2(0.0, 1.38491213321685791015625 / size.y)) * 0.310199081897735595703125);
    color += (texture(Sampler_g_sampler, Input.UV + vec2(0.0, 3.2509129047393798828125 / size.y)) * 0.07297551631927490234375);
    color += (texture(Sampler_g_sampler, Input.UV + vec2(0.0, 5.152032375335693359375 / size.y)) * 0.0052916849963366985321044921875);
    return vec4(color.xyz, 1.0);
}

void main()
{
    PS_Input Input;
    Input.Pos = gl_FragCoord;
    Input.UV = Input_UV;
    _entryPointOutput = _main(Input);
}

