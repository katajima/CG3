// �萔�o�b�t�@�̍\���̂̒�`
cbuffer ConstantBuffer : register(b0) // b0 ���W�X�^�Ƀo�C���h
{
    float4x4 WorldViewProjection; // ���[���h�r���[���e�s��
    float4 LightDirection; // �����̕���
    float4 LightColor; // �����̐F
    float4 AmbientColor; // �����̐F
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