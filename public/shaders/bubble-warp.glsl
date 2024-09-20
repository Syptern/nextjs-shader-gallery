// Author @patriciogv - 2015
// http://patriciogonzalezvivo.com

#ifdef GL_ES
precision mediump float;
#endif

 uniform vec2 u_resolution;
 uniform vec2 u_mouse;
 uniform float u_time;

 vec2 hash(vec2 p)// replace this by something better
{
    p=vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3)));
    return-1.+2.*fract(sin(p)*43758.5453123);
}

float noise(in vec2 p)  
{
    const float K1=.366025404;// (sqrt(3)-1)/2;
    const float K2=.211324865;// (3-sqrt(3))/6;
    
    vec2 i=floor(p+(p.x+p.y)*K1);
    vec2 a=p-i+(i.x+i.y)*K2;
    float m=step(a.y,a.x);
    vec2 o=vec2(m,1.-m);
    vec2 b=a-o+K2;
    vec2 c=a-1.+2.*K2;
    vec3 h=max(.5-vec3(dot(a,a),dot(b,b),dot(c,c)),0.);
    vec3 n=h*h*h*h*vec3(dot(a,hash(i+0.)),dot(b,hash(i+o)),dot(c,hash(i+1.)));
    return dot(n,vec3(70.));
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution.x;
    //vec2 mouse=u_mouse.xy/u_resolution.x;
    vec2 mouse = vec2(1.);
    vec2 di=st-mouse;//vector from center to current fragment
    
    float prop=u_resolution.x/u_resolution.y;
    
    float d=distance(st,mouse);
    float power=(1.*3.141592/.3)*(sin(u_time/4.)/2. + 0.5)*.1;
    
    float bind=.6;//radius of 1:1 effect
    // if (power > 0.0) bind = sqrt(dot(mouse, mouse));
    // else {if (prop < 1.0) bind = mouse.x; else bind = mouse.y;}//stick to borders

    
    
    st=mouse+normalize(di)*tan(d*power)*bind/tan(bind*power);
    
    st=st+(st*noise(vec2(st.x+sin(u_time/2.),st.y+cos(u_time/2.))))* pow(1.- (d),2.0);


  
    float red = 0.6;
    
   float pct=distance(st,vec2(sin(u_time),cos(u_time)))/2.*noise(vec2(st.x/100.+sin(u_time/2.),st.y/100.+cos(u_time/2.)));
   float  green=distance(st,vec2(sin(u_time-.5),cos(u_time+3.5)))/2.;
    
    //for round effect, not elliptical
    
    vec3 color=vec3(1.-pct,1.-green,1.-red);
    
    // dark circle
    //*  circle(st, 0.1, mouse);
    
    gl_FragColor=vec4(color,1.);
}