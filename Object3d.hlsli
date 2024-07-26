
struct VertexShaderOutput
{
    float4 position : SV_POSITION;
    float3 nomal : NORMAL0;
    float2 texcoord : TEXCOORD0;
    float3 worldPosition : POSITION0;
};