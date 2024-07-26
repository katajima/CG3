#include"Object3d.hlsli" 
[maxvertexcount(3)]
void main(
	triangle VertexShaderOutput input[1],
	inout TriangleStream<GSOutput> output
)
{
    GSOutput element;
    element.normal = input[0].nomal;
    element.uv = input[0].texcoord;
   
        
    element.svpos = input[0].position;
    element.worldPosition = input[0].worldPosition;
    output.Append(element);
    
    element.svpos = input[0].position + float4(10.0f,10.0f,0,0);
    element.worldPosition = input[0].worldPosition;
    output.Append(element);
    
    element.svpos = input[0].position + float4(10.0f, 0, 0, 0);
    element.worldPosition = input[0].worldPosition;
    output.Append(element);
    
    

}