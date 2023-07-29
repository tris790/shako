#version 330

const float MAX_DEPTH = 10000.0;

// Input fragment attributes (from fragment shader)
in vec2 fragTexCoord;
in vec4 fragColor;

// Input uniform values
uniform sampler2D texture0;
uniform float deltaTime;

// Output fragment color
out vec4 finalColor;

void main()
{
    finalColor = fragColor;
}
