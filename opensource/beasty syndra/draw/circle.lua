local effect_description = [[
struct VS_OUTPUT
{
    float4 Input    : POSITION;
    float4 Color    : COLOR0;
    float4 Position : TEXCOORD0;
};

float4x4 Transform;
float2 pos;
float radius;
float4 color;
float lineWidth;
float Is3D;

VS_OUTPUT VS(VS_OUTPUT input) {
  VS_OUTPUT output = (VS_OUTPUT) 0;
  output.Input = mul(input.Input, Transform);
  output.Color = input.Color;
  output.Position = input.Input;
  return output;
}

float4 PS(VS_OUTPUT input): COLOR
{
  VS_OUTPUT output = (VS_OUTPUT) 0;
  output = input;

  float4 v = output.Position;
  
  float dist = distance(Is3D ? v.xz : v.xy, pos);

  output.Color.xyz = color.xyz;
  output.Color.w = color.w * (smoothstep(radius + lineWidth * .5, radius, dist) - smoothstep(radius, radius - lineWidth * .5, dist));

  return output.Color;
}

technique Movement
{
  pass P0 {
    ZEnable = FALSE;
    AlphaBlendEnable = TRUE;
    DestBlend = InvSrcAlpha;
    SrcBlend = SrcAlpha;
    VertexShader = compile vs_3_0 VS();
    PixelShader = compile ps_3_0 PS();
  }
}
]]

local effect = shadereffect.construct(effect_description, false)

local on_draw = function(radius, width, pos, color)
  shadereffect.begin(effect, player.y, true)
  shadereffect.set_float(effect, 'Is3D', 1)
  shadereffect.set_float(effect, 'radius', radius)
  shadereffect.set_float(effect, 'lineWidth', width)
  shadereffect.set_vec2(effect, 'pos', pos)
  shadereffect.set_color(effect, 'color', color)
  shadereffect.draw(effect)
end

return {
  on_draw = on_draw,
}