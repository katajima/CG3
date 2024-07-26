// 定数バッファの構造体の定義
cbuffer ConstantBuffer : register(b0) // b0 レジスタにバインド
{
    float4x4 WorldViewProjection; // ワールドビュー投影行列
    float4 LightDirection; // 光源の方向
    float4 LightColor; // 光源の色
    float4 AmbientColor; // 環境光の色
};
struct GSOutput
{
    float4 svpos : SV_POSITION;
    float3 normal : NORMAL0;
    float2 uv : TEXCOORD0;
};
struct VSOutput
{
    float4 svpos : SV_POSITION;
    float3 normal : NORMAL0;
    float2 uv : TEXCOORD0;
};