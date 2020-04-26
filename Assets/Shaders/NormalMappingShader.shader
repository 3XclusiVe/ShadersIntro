Shader "ShadersIntro/NormalMappingShader"
{
    Properties
    {
        //name  (Inspector Name, Inspector Type) = Inspector default value
        _MainTint ("Color", Color) = (1,1,1,1)
        _NormalTex ("Normal Map", 2D) = "bump" {}
        _MainTex ("Maint Texture", 2D) = "white" {}
        _NormalMapIntensity("Normal map intensity", Range(0,10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        #pragma target 3.0

        //links properties to it variables in shader code
        float4 _MainTint;
        sampler2D _NormalTex;
        float _NormalMapIntensity;
        sampler2D _MainTex;

        struct Input
        {
            //uv + _NormalTex this means uv for property called _NormalTex
            float2 uv_NormalTex;
            float2 uv_MainTex;
        };

        
        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //get color from texture
            float3 c = tex2D(_MainTex, IN.uv_MainTex);
            
            //get normal map from provided texture
            float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
            
            //Apply Intensity
            normalMap.x *= _NormalMapIntensity;
            normalMap.y *= _NormalMapIntensity;
            
            //Apply noraml map
            o.Normal = normalize(normalMap.rgb);
            
            //Apply color
            o.Albedo = c.rgb * _MainTint;
            o.Alpha = _MainTint.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
