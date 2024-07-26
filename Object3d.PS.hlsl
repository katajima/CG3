#include"Object3d.hlsli"

//�F�ȂǎO�p�`�̕\�ʂ̍ގ������肷�����Material
struct Material
{
    
    float4 color;
    int enableLighting;
    float4x4 uvTransform;
    float shininess;
};

struct Camera
{
    float3 worldPosition;
};

struct DirectionalLight
{
    float4 color; //!< ���C�g�̐F
    float3 direction; //!< ���C�g�̌���
    float intensity; //!< �P�x
};

struct PointLight
{
    float4 color; //���C�g�F
    float3 position; // ���C�g�ʒu
    float intensity; //�P�x
    float radius; // !< ���C�g�̓͂��ő勗��
    float decay; //!< ������ 
};

struct SpotLight
{
    float4 color; //���C�g�F
    float3 position; // ���C�g�ʒu
    float intensity; //�P�x
    float3 direction; //!< ���C�g�̌���
    float distance; //!< ���C�g�͂�����
    float decay; //!< ������ 
    float cosAngle; //!< �X�|�b�g���C�g�̗]��
    float cosFalloffStart;
};


ConstantBuffer<Material> gMaterial : register(b0);
ConstantBuffer<DirectionalLight> gDirectionalLight : register(b1);
Texture2D<float4> gTexture : register(t0);
SamplerState sSampler : register(s0);
ConstantBuffer<Camera> gCamera : register(b2);
ConstantBuffer<PointLight> gPointLight : register(b3);
ConstantBuffer<SpotLight> gSpotLight : register(b4);

////------PixelShader------////
struct PixelShaderOutput
{
    float4 color : SV_TARGET0;
};


PixelShaderOutput main(GSOutput input)
{
    PixelShaderOutput output;
    
    float4 transformedUV = mul(float4(input.uv, 0.0f, 1.0f), gMaterial.uvTransform);
    float4 textureColor = gTexture.Sample(sSampler, transformedUV.xy);
    
       
    
    if (gMaterial.enableLighting != 0) // Lighting����ꍇ
    {
        
        float3 pointLightDirection = normalize(input.worldPosition - gPointLight.position);
    
        float3 spotLightDirectionOnSurface = normalize(input.worldPosition - gSpotLight.position);
     
        
        float3 toEye = normalize(gCamera.worldPosition - input.worldPosition);
        
        // ���s�����̏���
        //�g�U����
        float3 halfVectorv = normalize(-gDirectionalLight.direction + toEye);
        float NdotL = dot(normalize(input.normal), halfVectorv);
        float cos = pow(NdotL * 0.5f + 0.5f, 2.0f);
        //���ʔ���
        float3 reflectLight = reflect(gDirectionalLight.direction, normalize(input.normal));
        float RdotE = dot(reflectLight, toEye);
        float specularPow = pow(saturate(RdotE), gMaterial.shininess);
        
        //���C�g
        float3 diffuseDirectionalLight = gMaterial.color.rgb * textureColor.rgb * gDirectionalLight.color.rgb * cos * gDirectionalLight.intensity;
        float3 specularDirectionalLight = gDirectionalLight.color.rgb * gDirectionalLight.intensity * specularPow * float3(1.0f, 1.0f, 1.0f);
        
        
        // �|�C���g���C�g�̏���
        //�g�U����
        float3 halfVectorP = normalize(-pointLightDirection + toEye);
        float NdotLP = dot(normalize(input.normal), halfVectorP);
        float cosP = pow(NdotLP * 0.5f + 0.5f, 2.0f);
        
        float3 reflectLightP = reflect(pointLightDirection, normalize(input.normal));
        float RdotEP = dot(reflectLightP, toEye);
        float specularPowP = pow(saturate(RdotEP), gMaterial.shininess);
        
        float distanceP = length(gPointLight.position - input.worldPosition);
        float attenuationFactorP = pow(saturate(-distanceP / gPointLight.radius + 1.0), gPointLight.decay);
        
        float3 diffusePointLight = gMaterial.color.rgb * textureColor.rgb * gPointLight.color.rgb * cosP * gPointLight.intensity * attenuationFactorP;
        float3 specularPointLight = gPointLight.color.rgb * gPointLight.intensity * specularPowP * attenuationFactorP * float3(1.0f, 1.0f, 1.0f);
        
        
        ///�X�|�b�g���C�g
        // �X�|�b�g���C�g�̌v�Z
        float3 halfVectorvS = normalize(-spotLightDirectionOnSurface + toEye);
        float NdotLS = dot(normalize(input.normal), halfVectorvS);
        float cosS = pow(NdotLS * 0.5f + 0.5f, 2.0f);
        
        float3 reflectLightS = reflect(spotLightDirectionOnSurface, normalize(input.normal));
        float RdotES = dot(reflectLightS, toEye);
        float specularPowS = pow(saturate(RdotES), gMaterial.shininess);
        
        // ���������̌v�Z
        float distanceS = length(gSpotLight.position - input.worldPosition);
        float attenuationFactorS = pow(saturate(-distanceS / gSpotLight.distance + 1.0), gSpotLight.decay);
        
        // �t�H�[���I�t�̌v�Z
        float cosAngle = dot(spotLightDirectionOnSurface, normalize(gSpotLight.direction));
        float falloffFactor = saturate((cosAngle - gSpotLight.cosAngle) / (gSpotLight.cosFalloffStart - gSpotLight.cosAngle));
        
        // �X�|�b�g���C�g�̊g�U���˂Ƌ��ʔ��˂̌v�Z
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
    else // Lighting���Ȃ��ꍇ�B�O��܂łƓ������Z
    {
        output.color = gMaterial.color * textureColor;
    }
    
    
    return output;
}