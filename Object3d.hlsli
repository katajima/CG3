
struct VertexShaderOutput
{
    float4 position : SV_POSITION;
    
    float3 worldPosition : POSITION0;
};
struct GSOutput
{
    float4 svpos : SV_POSITION;
    float2 uv : TEXCOORD0;
    float3 worldPosition : POSITION0;
};