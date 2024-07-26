#include"BasicShaderHeader.hlsli" 

struct BasicPixelShaderOutput
{
    float32_t4 color : SV_TARGET0;
};

float4 main(GSOutput input) : SV_TARGET
{
    return float4(1.0f, 1.0f, 1.0f, 1.0f);
}