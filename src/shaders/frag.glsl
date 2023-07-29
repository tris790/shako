#version 330

const float MAX_DEPTH = 10000.0;

// Input fragment attributes (from fragment shader)
in vec2 fragTexCoord;
in vec4 fragColor;

// Input uniform values
uniform sampler2D texture0;
uniform float depth;
uniform float deltaTime;

// Output fragment color
out vec4 finalColor;

void main()
{
    vec2 size = textureSize(texture0, 0);
    vec4 distortion = texture(texture0, vec2(mod(fragTexCoord.x + 10, size.x), mod(fragTexCoord.y + 10,  size.y)));

    vec4 texelColor = texture(texture0, fragTexCoord) * fragColor;
    float depthColor = max(0.2, min(depth / MAX_DEPTH, 1.0));
    vec4 waterColor = mix(texelColor, vec4(0.0, 0.3, 1.0, 1.0), depthColor);

    float waveStrength = (sin(deltaTime) + 10) / 10;
    vec4 ripple = waveStrength * waterColor;

    finalColor = ripple;
}
