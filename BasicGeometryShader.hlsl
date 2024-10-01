#include"Object3d.hlsli" 
[maxvertexcount(6)]
void main(
	triangle VertexShaderOutput input[3],
	inout TriangleStream<GSOutput> output
)
{
   
    for (uint j = 0; j < 3; j++)
    {
        GSOutput element;
        element.svpos = input[j].position;
        element.normal = input[j].nomal;
        element.uv = input[j].texcoord;
        element.worldPosition = input[j].worldPosition;
        output.Append(element);
    }
    output.RestartStrip();
    for (uint i = 0; i < 3; i++)
    {
        GSOutput element;
        element.svpos = input[i].position + float4(20.0f, 0.0f, 0.0f, 0.0f);
        element.normal = input[i].nomal;
        element.uv = input[i].texcoord * 5.0f;
        element.worldPosition = input[i].worldPosition + float3(20.0f, 0.0f, 0.0f);
        output.Append(element);
        
    }
}