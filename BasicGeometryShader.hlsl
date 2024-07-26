#include"BasicShaderHeader.hlsli" 
[maxvertexcount(3)]
void main(
    triangle VSOutput input[3], // ���͂̎O�p�`
    inout TriangleStream<GSOutput> output // �o�͂̃g���C�A���O���X�g���[��
)
{
    for (uint i = 0; i < 3; i++)
    {
        GSOutput element;
        element.svpos = input[i].svpos; // ���͂���ʒu���擾
        element.normal = input[i].normal; // ���͂���@�����擾
        element.uv = input[i].uv; // ���͂���UV���擾
        output.Append(element); // ���_��ǉ�
    }
    output.RestartStrip(); // �K�v�ɉ����ăX�g���b�v���ċN��
}