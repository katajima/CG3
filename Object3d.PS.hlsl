#include"Object3d.hlsli"

//色など三角形の表面の材質を決定するものMaterial
struct Material
{
    
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

struct PointLight
{
    float32_t4 color; //ライト色
    float32_t3 position; // ライト位置
    float intensity; //輝度
    float radius; // !< ライトの届く最大距離
    float decay; //!< 減衰率 
};

struct SpotLight
{
    float32_t4 color; //ライト色
    float32_t3 position; // ライト位置
    float32_t intensity; //輝度
    float32_t3 direction; //!< ライトの向き
    float32_t distance; //!< ライト届く距離
    float32_t decay; //!< 減衰率 
    float32_t cosAngle; //!< スポットライトの余弦
    float32_t cosFalloffStart;
};


ConstantBuffer<Material> gMaterial : register(b0);
ConstantBuffer<DirectionalLight> gDirectionalLight : register(b1);
Texture2D<float32_t4> gTexture : register(t0);
SamplerState sSampler : register(s0);
ConstantBuffer<Camera> gCamera : register(b2);
ConstantBuffer<PointLight> gPointLight : register(b3);
ConstantBuffer<SpotLight> gSpotLight : register(b4);

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
    
       
    
    if (gMaterial.enableLighting != 0) // Lightingする場合
    {
        
        float32_t3 pointLightDirection = normalize(input.worldPosition - gPointLight.position);
    
        float32_t3 spotLightDirectionOnSurface = normalize(input.worldPosition - gSpotLight.position);
     
        
        float32_t3 toEye = normalize(gCamera.worldPosition - input.worldPosition);
        
        // 平行光源の処理
        //拡散反射
        float32_t3 halfVectorv = normalize(-gDirectionalLight.direction + toEye);
        float NdotL = dot(normalize(input.nomal), halfVectorv);
        float cos = pow(NdotL * 0.5f + 0.5f, 2.0f);
        //鏡面反射
        float32_t3 reflectLight = reflect(gDirectionalLight.direction, normalize(input.nomal));
        float RdotE = dot(reflectLight, toEye);
        float specularPow = pow(saturate(RdotE), gMaterial.shininess);
        
        //ライト
        float32_t3 diffuseDirectionalLight = gMaterial.color.rgb * textureColor.rgb * gDirectionalLight.color.rgb * cos * gDirectionalLight.intensity;
        float32_t3 specularDirectionalLight = gDirectionalLight.color.rgb * gDirectionalLight.intensity * specularPow * float32_t3(1.0f, 1.0f, 1.0f);
        
        
        // ポイントライトの処理
        //拡散反射
        float3 halfVectorP = normalize(-pointLightDirection + toEye);
        float NdotLP = dot(normalize(input.nomal), halfVectorP);
        float cosP = pow(NdotLP * 0.5f + 0.5f, 2.0f);
        
        float3 reflectLightP = reflect(pointLightDirection, normalize(input.nomal));
        float RdotEP = dot(reflectLightP, toEye);
        float specularPowP = pow(saturate(RdotEP), gMaterial.shininess);
        
        float distanceP = length(gPointLight.position - input.worldPosition);
        float attenuationFactorP = pow(saturate(-distanceP / gPointLight.radius + 1.0), gPointLight.decay);
        
        float3 diffusePointLight = gMaterial.color.rgb * textureColor.rgb * gPointLight.color.rgb * cosP * gPointLight.intensity * attenuationFactorP;
        float3 specularPointLight = gPointLight.color.rgb * gPointLight.intensity * specularPowP * attenuationFactorP * float3(1.0f, 1.0f, 1.0f);
        
        
        ///スポットライト
        // スポットライトの計算
        float3 halfVectorvS = normalize(-spotLightDirectionOnSurface + toEye);
        float NdotLS = dot(normalize(input.nomal), halfVectorvS);
        float cosS = pow(NdotLS * 0.5f + 0.5f, 2.0f);
        
        float3 reflectLightS = reflect(spotLightDirectionOnSurface, normalize(input.nomal));
        float RdotES = dot(reflectLightS, toEye);
        float specularPowS = pow(saturate(RdotES), gMaterial.shininess);
        
        // 距離減衰の計算
        float distanceS = length(gSpotLight.position - input.worldPosition);
        float attenuationFactorS = pow(saturate(-distanceS / gSpotLight.distance + 1.0), gSpotLight.decay);
        
        // フォールオフの計算
        float cosAngle = dot(spotLightDirectionOnSurface, normalize(gSpotLight.direction));
        float falloffFactor = saturate((cosAngle - gSpotLight.cosAngle) / (gSpotLight.cosFalloffStart - gSpotLight.cosAngle));
        
        // スポットライトの拡散反射と鏡面反射の計算
        float3 diffuseSpotLight = gMaterial.color.rgb * textureColor.rgb * gSpotLight.color.rgb * cosS * gSpotLight.intensity * attenuationFactorS * falloffFactor;
        float3 specularSpotLight = gSpotLight.color.rgb * gSpotLight.intensity * specularPowS * attenuationFactorS * falloffFactor;
        
        
        
        
        
        output.color.rgb = 
        diffuseDirectionalLight + specularDirectionalLight + 
        diffusePointLight + specularPointLight + 
        diffuseSpotLight + specularSpotLight;
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