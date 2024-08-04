#include"Object3d.hlsli" 

// 四角形の頂点数
static const uint vnum = 4;

// センターからのオフセット
static const float4 offset_array[vnum] =
{
    float4(-0.5f, -0.5f, 0, 0),
    float4(-0.5f, +0.5f, 0, 0),
    float4(+0.5f, -0.5f, 0, 0),
    float4(+0.5f, +0.5f, 0, 0),
};

static const float2 uv_array[vnum] =
{
    float2(0, 1),
    float2(0, 0),
    float2(1, 1),
    float2(1, 0),
};

[maxvertexcount(vnum)]
void main(
	point VertexShaderOutput input[1],
	inout TriangleStream<GSOutput> output
)
{
    GSOutput element;
   
    for (uint i = 0; i < vnum; i++)
    {
        // ワールド座標ベースでずらす
        element.svpos = input[0].position + offset_array[i];
        // ビュー、座標変換
        //element.svpos = mul(input[i].worldPosition, element.svpos);
        element.uv = uv_array[i];
        output.Append(element);
    }
    
}