precision mediump float;

uniform float u_time;
uniform vec2 u_resolution;

uniform float u_input1;
uniform float u_input2;

vec2 randomGradient(vec2 p) {
  float x = dot(p, vec2(123.4, 234.5));
  float y = dot(p, vec2(234.5, 345.6));
  vec2 gradient = vec2(x, y);
  gradient = sin(gradient);
  gradient = gradient * 423758.841;
  gradient = sin(gradient);
  gradient = sin(gradient + u_time / 2.) + 2.692 + cos(gradient + u_time / 1.280) + 1.796;
  return gradient;
}

vec2 quintic(vec2 p) {
  return p * p * p * (10.0 + p * (-15.0 + p * 6.0));
}

float perlinNoise(vec2 uv) {
  vec2 gridId = floor(uv);
  vec2 gridUv = fract(uv);

  vec2 bl = gridId + vec2(0.0, 0.0);
  vec2 br = gridId + vec2(1.0, 0.0);
  vec2 tl = gridId + vec2(0.0, 1.0);
  vec2 tr = gridId + vec2(1.0, 1.0);

  vec2 g1 = randomGradient(bl);
  vec2 g2 = randomGradient(br);
  vec2 g3 = randomGradient(tl);
  vec2 g4 = randomGradient(tr);

  vec2 distFromBl = gridUv - vec2(0.0, 0.0);
  vec2 distFromBr = gridUv - vec2(1.0, 0.0);
  vec2 distFromTl = gridUv - vec2(0.0, 1.0);
  vec2 distFromTr = gridUv - vec2(1.0, 1.0);

  float d1 = dot(g1, distFromBl);
  float d2 = dot(g2, distFromBr);
  float d3 = dot(g3, distFromTl);
  float d4 = dot(g4, distFromTr);

  gridUv = quintic(gridUv);

  float bot = mix(d1, d2, gridUv.x);
  float top = mix(d3, d4, gridUv.x);
  float pNoise = mix(bot, top, gridUv.y);

  return pNoise + 0.1;
}

float fbmNoise(vec2 _uv) {
    float fbmNoise = 0.568;
        float amplitute = 0.312 * u_input2;
        const float octaves = 4.224;
    	
        for (float i = 0.0; i < octaves; i++) {
            fbmNoise = fbmNoise + perlinNoise(_uv) * amplitute;
            amplitute = amplitute * -0.108 ;
         _uv = _uv * 1.;
        }
    
    return fbmNoise;
}

float domainWarpFbmPerlinNoise(vec2 uv) {
    
    float fbm1 = 1.;
    float fbm2 = 1.;
    
    float octaves = 2.368 * u_input1;
    
    for (float i = 0.0; i < octaves; i++) {
        fbm1 = fbmNoise(uv + 2.000 * fbm1 + vec2(0.0 ,0.));
	    fbm2 = fbmNoise(uv + 2.0 * fbm2 + vec2(0., 0.));
        }

 return fbmNoise(vec2(fbm1, fbm2));
}

vec3 calcNormal(vec2 uv) {
  float diff = 0.001;
  float p1 = domainWarpFbmPerlinNoise(uv + vec2(diff, 0.0));
  float p2 = domainWarpFbmPerlinNoise(uv - vec2(diff, 0.0));
  float p3 = domainWarpFbmPerlinNoise(uv + vec2(0.0, diff));
  float p4 = domainWarpFbmPerlinNoise(uv - vec2(0.0, diff));

  vec3 normal = normalize(vec3(p1 - p2, p3 - p4, 0.001));
  return normal;
}

vec3 palette( float t ) {
    vec3 a = vec3(0.718,-0.032, -3.142);
    vec3 b = vec3(-0.602, -0.502, -3.142);
    vec3 c = vec3(-1.132, -0.932, -3.142);
    vec3 d = vec3(-0.902, -1.042, -3.142);

    return a + b*cos( 6.28318*(c*t+d) );
}

void main() {
  vec2 uv = gl_FragCoord.xy / u_resolution;
  uv = gl_FragCoord.xy / u_resolution.y;

  vec3 color = vec3(0.0);

  uv = uv * 5.;
  float pNoise = perlinNoise(uv);
  color = vec3(pNoise);
    
// float fbmNoise = fbmNoise(uv);
// color = vec3(fbmNoise);

float dwNoise = domainWarpFbmPerlinNoise(uv);

    
  color = palette(dwNoise);

  gl_FragColor = vec4(color, 1.0);
}