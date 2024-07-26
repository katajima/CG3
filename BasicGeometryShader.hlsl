#include"Object3d.hlsli" 
[maxvertexcount(3)]
void main(
	triangle VertexShaderOutput input[3],
	inout TriangleStream<GSOutput> output
)
{
	for (uint i = 0; i < 3; i++)
	{
		GSOutput element;
		element.svpos = input[i].position;
        element.normal = input[i].nomal;
        element.uv = input[i].texcoord;
        element.worldPosition = input[i].worldPosition;
		output.Append(element);
	}
}