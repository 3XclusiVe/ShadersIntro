Shader "ShadersIntro/LigtingModel/Toon"
{
    Properties
    {
        _RampTex ("Ramp", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        //last argument specify what function for lgting to use
        #pragma surface surf LightingToon

        #pragma target 3.0

        sampler2D _RampTex;

        struct Input
        {
            float2 uv_MainTex;
        };


        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_RampTex, IN.uv_MainTex).rgb;
        }
        
        //here our custom ligting function
        half4 LightingLightingToon (SurfaceOutput s, half3 lightDir, half atten) 
        {
            half NdotL = dot (s.Normal, lightDir);
            NdotL = tex2D(_RampTex, fixed2(NdotL, 0.5));
            
            fixed4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten * 1);
            c.a = s.Alpha;
            
            return c; 
        }

        ENDCG
    }
    FallBack "Diffuse"
}
