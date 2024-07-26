#include"BasicShaderHeader.hlsli" 
[maxvertexcount(3)]
void main(
    triangle VSOutput input[3], // 入力の三角形
    inout TriangleStream<GSOutput> output // 出力のトライアングルストリーム
)
{
    for (uint i = 0; i < 3; i++)
    {
        GSOutput element;
        element.svpos = input[i].svpos; // 入力から位置を取得
        element.normal = input[i].normal; // 入力から法線を取得
        element.uv = input[i].uv; // 入力からUVを取得
        output.Append(element); // 頂点を追加
    }
    output.RestartStrip(); // 必要に応じてストリップを再起動
}