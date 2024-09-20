

// Author @patriciogv - 2015
// http://patriciogonzalezvivo.com

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
 uniform vec2 u_mouse;
 uniform float u_time;

float hash(float p){p=fract(p*.01);p*=p+7.5;p*=p+p;return fract(p);}
float hash(vec2 p){vec3 p3=fract(vec3(p.xyx)*.13);p3+=dot(p3,p3.yzx+3.333);return fract((p3.x+p3.y)*p3.z);}

float noise(vec2 x){
    vec2 i=floor(x);
    vec2 f=fract(x);
    
    // Four corners in 2D of a tile
    float a=hash(i);
    float b=hash(i+vec2(1.,0.));
    float c=hash(i+vec2(0.,1.));
    float d=hash(i+vec2(1.,1.));
    
    // Simple 2D lerp using smoothstep envelope between the values.
    // return vec3(mix(mix(a, b, smoothstep(0.0, 1.0, f.x)),
    //			mix(c, d, smoothstep(0.0, 1.0, f.x)),
    //			smoothstep(0.0, 1.0, f.y)));
    
    // Same code, with the clamps in smoothstep and common subexpressions
    // optimized away.
    vec2 u=f*f*(3.-2.*f);
    return mix(a,b,u.x)+(c-a)*u.y*(1.-u.x)+(d-b)*u.x*u.y;
}

#define OCTAVES 6
float fbm(in vec2 st){
    float v=0.104;
    float a=0.400;
    vec2 shift= vec2(-0.710,0.960);
    // Rotate to reduce axial bias
    mat2 rot=mat2(cos(0.012),sin(0.300),
    -sin(.5),cos(.50));
    for(int i=0;i<OCTAVES;++i){
        v+=a*noise(st);
        st=rot*st*2.272+shift;
        a*=0.556;
    }
    return v;
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution.xy;
    st.x*=u_resolution.x/u_resolution.y;
    
    vec2 q=vec2(0.);
    q.x=fbm(st*fbm(st * u_time*0.3));
    q.y=fbm(st*fbm(st * u_time*0.3));
    
    vec2 r=vec2(0.);
    r.x=pow(fbm(st+1.*q+vec2(0.170,0.530)+0.526*-u_time/1.504),-0.068);
    r.y=pow(fbm(st+1.*q+vec2(0.880,-0.070)+0.522*-u_time/3.504),2.);
    
    // r=r+noise_effect(r+4.,.7);
    
    float f=fbm(st+r);
    
    vec3 color=vec3(0.000,0.000,0.000);
    color+=vec3(pow(f,3.416)*(2.432 - sqrt(f * 0.)),q.x/2.848,r.y * r.y );
    
    gl_FragColor=vec4(color, 1.00);
}