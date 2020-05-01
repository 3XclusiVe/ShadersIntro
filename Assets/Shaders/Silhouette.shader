Shader "ShadersIntro/Silhouette"
{
    Properties
    {
        _DotProduct ("Rim effect", Range(0,1)) = 0.5
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags 
        { 
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
        }
        //Cull Off //backside of model will be removed
        LOD 200

        CGPROGRAM
        #pragma surface surf NoLighting alpha:fade

        #pragma target 3.0


        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal; //contains world reflection vector
            float3 viewDir;  // contains view direction
        };

        float _DotProduct;
        fixed4 _Color;
        sampler2D _MainTex;


        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            
            float border = 1 - (abs(dot(IN.viewDir, IN.worldNormal)));
            
            float alpha = (border * (1 - _DotProduct) + _DotProduct);
            o.Alpha = c.a * alpha;
        }
        
        //Custom lighting that removes all shadows
        half4 LightingNoLighting (SurfaceOutput s, half3 lightDir, half atten) 
        {
            half4 c;
            
            c.rgb = s.Albedo;
            c.a = s.Alpha;
            
            return c;
        } 

        ENDCG
    }
    FallBack "Diffuse"
}
