#include"Object3d.hlsli" 
[maxvertexcount(3)]
void main(
	point VertexShaderOutput input[1],
	inout TriangleStream<GSOutput> output
)
{
    GSOutput element;
    element.normal = input[0].normal;
    element.worldPosition = input[0].worldPosition;
    
    // 最初の頂点
    element.svpos = input[0].position;
    element.uv = input[0].texcoord;
    output.Append(element);
   
    // 2番目の頂点
    element.svpos = input[0].position + float4(10.0f, 10.0f, 0, 0);
    element.uv = input[0].texcoord + float2(1.0f, 1.0f); // テクスチャ座標を調整
    output.Append(element);
    
    // 3番目の頂点
    element.svpos = input[0].position + float4(10.0f, 0.0f, 0, 0);
    element.uv = input[0].texcoord + float2(1.0f, 0.0f); // テクスチャ座標を調整
    output.Append(element);
}