﻿Shader "ShadersIntro/LigtingModel/SimpleLambert"
{
    Properties
    {
        _CelShadingLevels ("Shading", float) = 0.5
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        //last argument specify what function for lgting to use
        #pragma surface surf SimpleLambert

        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        float _CelShadingLevels;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
        
        //here our custom ligting function
        half4 LightingSimpleLambert (SurfaceOutput s, half3 lightDir, half atten) 
        {
            half NdotL = dot (s.Normal, lightDir);
            half cel = floor(NdotL * _CelShadingLevels) / (_CelShadingLevels - 0.5); // Snap
            
            half4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * (atten * cel);
            c.a = s.Alpha;
            
            return c; 
        }

        ENDCG
    }
    FallBack "Diffuse"
}
