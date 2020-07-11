Shader "ShadersIntro/Desaturation"
{
    //homemade desaturation
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Power ("Power", Range(-1,2)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf NoLighting fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float _Power;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            
            float d = ((2 * _Power) + 1);
            
            float r = (c.r + _Power * c.g + _Power * c.b) / d;
            float g = (_Power * c.r + c.g + _Power * c.b) / d;
            float b = (_Power * c.r + _Power * c.g + c.b) / d;
            
            c = fixed4(r, g, b, c.a);
            
            o.Albedo = c.rgb;
            o.Alpha = c.a;
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
