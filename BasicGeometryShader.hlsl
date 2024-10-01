#include"Object3d.hlsli" 
[maxvertexcount(3)]
void main(
	point VertexShaderOutput input[1],
	inout TriangleStream<GSOutput> output
)
{
    GSOutput element;
    float3 edge1 = (input[0].worldPosition + float3(10.0f, 10.0f, 0)) - input[0].worldPosition;
    float3 edge2 = (input[0].worldPosition + float3(10.0f, 0.0f, 0)) - input[0].worldPosition;
    float3 normal = normalize(cross(edge1, edge2));

// 最初の頂点
    element.svpos = input[0].position;
    element.uv = input[0].texcoord;
    element.worldPosition = input[0].worldPosition;
    element.normal = normal;
    output.Append(element);

// 2番目の頂点
    element.svpos = input[0].position + float4(10.0f, 10.0f, 0, 0);
    element.uv = input[0].texcoord + float2(1.0f, 1.0f);
    element.worldPosition = input[0].worldPosition + float3(10.0f, 10.0f, 0);
    element.normal = normal; // 同じ法線を適用
    output.Append(element);

// 3番目の頂点
    element.svpos = input[0].position + float4(10.0f, 0.0f, 0, 0);
    element.uv = input[0].texcoord + float2(1.0f, 0.0f);
    element.worldPosition = input[0].worldPosition + float3(10.0f, 0.0f, 0);
    element.normal = normal; // 同じ法線を適用
    output.Append(element);
}