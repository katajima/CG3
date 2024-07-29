#include"Object3d.hlsli" 
[maxvertexcount(3)]
void main(
	point VertexShaderOutput input[1],
	inout TriangleStream<GSOutput> output
)
{
    GSOutput element;
    element.normal = input[0].nomal;
    element.worldPosition = input[0].worldPosition;
        
    
    element.svpos = input[0].position;
    element.uv = input[0].texcoord;
    output.Append(element);
   
    element.svpos = input[0].position + float4(5.0f, 5.0f, 0, 0);
    element.uv = input[0].texcoord + float2(0.0f, 0.0f);
    output.Append(element);
    
    element.svpos = input[0].position + float4(5.0f, 0, 0, 0);
    element.uv = input[0].texcoord + float2(0.0f,0.0f);
    output.Append(element);
    
    

}