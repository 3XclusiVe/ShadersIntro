Shader "ShadersIntro/LigtingModel/Phong"
{
    Properties
    {
        _MainTint ("Diffuse Tint", Color) = (1,1,1,1) 
        _MainTex ("Base (RGB)", 2D) = "white" {} 
        _SpecularColor ("Specular Color", Color) = (1,1,1,1) 
        _SpecPower ("Specular Power", Range(0,30)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        Cull Off //render backside


        CGPROGRAM
        #pragma surface surf Phong fullforwardshadows

        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };

        float4 _SpecularColor;
        sampler2D _MainTex;
        float4 _MainTint;
        float _SpecPower;
        
        
        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        
        fixed4 LightingPhong (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) 
        {
            // Reflection
            float NdotL = dot(s.Normal, lightDir);
            float3 reflectionVector = normalize(2.0 * s.Normal * NdotL - lightDir);
            
            // Specular
            float spec = pow(max(0, dot(reflectionVector, viewDir)), _SpecPower);
            float3 finalSpec = _SpecularColor.rgb * spec;
            
            // Final effect
            fixed4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * max(0,NdotL) * atten) + (_LightColor0.rgb * finalSpec); 
            c.a = s.Alpha;
            
            return c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
