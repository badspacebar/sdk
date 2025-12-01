local effect_description = [[


cbuffer cbPerFrame {
    float4x4 Transform;
    float Is3D;
    float2 pos;
    float radius;
    float4 color;
    float lineWidth;
};

struct VS_INPUT
{
    float4 Pos : POSITION;
    float4 Color : COLOR;
};

struct VS_OUTPUT
{
    float4 Position : SV_POSITION;
    float4 Color : COLOR;
    float4 InputPosition : POSITION;
};

VS_OUTPUT VS(VS_INPUT input)
{
    VS_OUTPUT output;
    output.Position = mul(input.Pos, Transform);
    output.Color = input.Color;
    output.InputPosition = input.Pos;  // as backup

    return output;
}

float4 PS(VS_OUTPUT input) : SV_TARGET
{
    float4 output = (float4)0;
    float4 v = input.InputPosition;

    float dist = distance(Is3D ? v.xz : v.xy, pos);
    float blur = lerp(1.0f, 5.0f, smoothstep(100, 500, radius));

    output.xyz = color.xyz;
    output.z = color.z;
    output.w = color.w * (
        (smoothstep(radius + lineWidth * 0.5f, radius, dist) - smoothstep(radius, radius - lineWidth * 0.5f, dist)) 
    );
    return output;
}


DepthStencilState DisableDepth
{
    DepthEnable = FALSE;
    DepthWriteMask = ALL;
    DepthFunc = LESS_EQUAL;
};

BlendState MyBlendState
{
    BlendEnable[0] = TRUE;
    SrcBlend[0] = SRC_ALPHA;
    DestBlend[0] = INV_SRC_ALPHA;
    BlendOp[0] = ADD;
    SrcBlendAlpha[0] = ONE;
    DestBlendAlpha[0] = ZERO;
    BlendOpAlpha[0] = ADD;
    RenderTargetWriteMask[0] = 0x0F;
};

technique11 Movement
{
    pass P0 {
        SetVertexShader(CompileShader(vs_5_0, VS()));
        SetGeometryShader(NULL);
        SetPixelShader(CompileShader(ps_5_0, PS()));

        SetDepthStencilState(DisableDepth, 0);
        SetBlendState(MyBlendState, float4(0.0f, 0.0f, 0.0f, 0.0f), 0xFFFFFFFF);
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

-- usage: 
-- circle.on_draw(range, 10, player.pos.xz, color)