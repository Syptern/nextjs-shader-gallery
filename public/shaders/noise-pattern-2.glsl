#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

uniform float u_input1;
uniform float u_input2;


float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))
                * 43758.5453123);
}

// Value noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/lsf3WH
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    vec2 u = f*f*(3.0-2.0*f);
    return mix( mix( random( i + vec2(0.0,0.0) ),
                     random( i + vec2(1.0,0.0) ), u.x),
                mix( random( i + vec2(0.0,1.0) ),
                     random( i + vec2(1.0,1.0) ), u.x), u.y);
}

float reverse(in float _in) {
    return abs(_in - 0.008);
}

float noiseCircle(in float _a, in float _radius, in float _speed) {
    float f = 1. + noise(vec2(sin(_a) + (u_time * _speed), cos(_a)));
    return 1.000-smoothstep(f,f+0.01,_radius) + 1.000-smoothstep(f - -0.002,f,_radius + -0.036);
}

void main(){
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    vec3 color = vec3(0.0);
    float movingSpeed = 0.536;

    vec2 pos = vec2(0.5,0.5)-st;

    float r = length(pos)*4.648;
    float a = atan(pos.y,pos.x);

    float f = 1. + noise(vec2(sin(a) + (u_time * movingSpeed), cos(a)));
    
    float circle1 = noiseCircle(a, r, 0.500000);
    
    for(int i=0;i<30;++i)
        {
        float offsetA = float(i) * 3.169 * (u_input1 * 0.2);
        float offsetR = float(i) * -0.012 * u_input2;
        float offsetSpeed = float(i) * 0.0;

        
          circle1 = circle1 * noiseCircle(a + offsetA , r + offsetR, 0.500001 + offsetSpeed);
        }
    
    // float circle1 = noiseCircle(a, r, 0.500001) * noiseCircle(a + 0.180, r+0.120, 0.500002)  * noiseCircle(a + 0.308, r+0.280, 0.500002);

    color = vec3( circle1  );

    gl_FragColor = vec4(color, 1.0);
}