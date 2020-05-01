Shader "ShadersIntro/LigtingModel/SimpleLambert"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf SimpleLambert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };


        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
        
        half4 LightingSimpleLambert (SurfaceOutput s, half3 lightDir, half atten) 
        {
            half NdotL = dot (s.Normal, lightDir);
            half4 c;
            c.rgb = s.Albedo; //* _LightColor0.rgb * (NdotL * atten * 1);
            c.a = s.Alpha;
            
            return c; 
        }

        ENDCG
    }
    FallBack "Diffuse"
}
