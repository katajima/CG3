#include"Object3d.hlsli"

//色など三角形の表面の材質を決定するものMaterial
struct Material {
    
    float32_t4 color;
    int32_t enableLighting;
    float32_t4x4 uvTransform;
    float32_t shininess;
};

struct Camera
{
    float32_t3 worldPosition;
};

struct DirectionalLight
{
    float32_t4 color; //!< ライトの色
    float32_t3 direction; //!< ライトの向き
    float intensity; //!< 輝度
};

ConstantBuffer<Material> gMaterial : register(b0);
ConstantBuffer<DirectionalLight> gDirectionalLight: register(b1);
Texture2D<float32_t4> gTexture : register(t0);
SamplerState sSampler : register(s0);
ConstantBuffer<Camera> gCamera : register(b2);

////------PixelShader------////
struct PixelShaderOutput
{
    float32_t4 color : SV_TARGET0;
};


PixelShaderOutput main(VertexShaderOutput input)
{
    PixelShaderOutput output;
    
    
    float4 transformedUV = mul(float32_t4(input.texcoord, 0.0f, 1.0f), gMaterial.uvTransform);
    float32_t4 textureColor = gTexture.Sample(sSampler, transformedUV.xy);
    float32_t3 toEye = normalize(gCamera.worldPosition - input.worldPosition);
        
    
    if (gMaterial.enableLighting != 0) // Lightingする場合
    {
        float NdotL = dot(normalize(input.nomal), -gDirectionalLight.direction);
        float cos = pow(saturate(NdotL * 0.5f + 0.5f), 2.0f);
        float32_t3 reflectLight = reflect(gDirectionalLight.direction, normalize(input.nomal));
        float RdotE = dot(reflectLight, toEye);
        float specularPow = pow(saturate(RdotE), gMaterial.shininess); //反射強度
        //拡散反射
        float32_t3 diffuse = gMaterial.color.rgb * textureColor.rgb * gDirectionalLight.color.rgb * cos * gDirectionalLight.intensity;
        //鏡面反射
        float32_t3 speclar = gDirectionalLight.color.rgb * gDirectionalLight.intensity * specularPow * float32_t3(1.0f, 1.0f, 1.0f);
        
        output.color.rgb = diffuse + speclar;
        output.color.a = gMaterial.color.a * textureColor.a;

        if (textureColor.a <= 0.5f)
        {
            discard;
        }
        if (output.color.a <= 0.0f)
        {
            discard;
        }
        
    }
    else // Lightingしない場合。前回までと同じ演算
    {
        output.color = gMaterial.color * textureColor;
    }
    
    
    return output;
}