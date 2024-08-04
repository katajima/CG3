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
    
    // �ŏ��̒��_
    element.svpos = input[0].position;
    element.uv = input[0].texcoord;
    output.Append(element);
   
    // 2�Ԗڂ̒��_
    element.svpos = input[0].position + float4(10.0f, 10.0f, 0, 0);
    element.uv = input[0].texcoord + float2(1.0f, 1.0f); // �e�N�X�`�����W�𒲐�
    output.Append(element);
    
    // 3�Ԗڂ̒��_
    element.svpos = input[0].position + float4(10.0f, 0.0f, 0, 0);
    element.uv = input[0].texcoord + float2(1.0f, 0.0f); // �e�N�X�`�����W�𒲐�
    output.Append(element);
}