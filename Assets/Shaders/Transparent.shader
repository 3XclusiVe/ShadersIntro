Shader "ShadersIntro/Transparent"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        /**
╔══════════════╤════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╤════════════════════╗
║ Render queue │ Render queue value                                                                                                                                                                                                                 │ Render queue value ║
╠══════════════╪════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╪════════════════════╣
║ Background   │ This render queue is rendered first. It is used for skyboxes and so on.                                                                                                                                                            │ 1000               ║
╟──────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┼────────────────────╢
║ Geometry     │ This is the default render queue. This is used for most objects. Opaque geometry uses this queue.                                                                                                                                  │ 2000               ║
╟──────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┼────────────────────╢
║ AlphaTest    │ Alpha-tested geometry uses this queue. It's different from the Geometry queue as it's more efficient to render alpha-tested objects after all the solid objects are drawn.                                                         │ 2450               ║
╟──────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┼────────────────────╢
║ Transparent  │ This render queue is rendered after Geometry and AlphaTest queues in back-to-front order. Anything alpha- blended (that is, shaders that don't write to the depth buffer) should go here, for example, glass and particle effects. │ 3000               ║
╟──────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┼────────────────────╢
║ Overlay      │ This render queue is meant for overlay effects. Anything rendered last should go here, for example, lens flares.                                                                                                                   │ 4000               ║
╚══════════════╧════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╧════════════════════╝
        **/
        Tags 
        {
            "Queue" = "Transparent" 
            "IgnoreProjector" = "True" 
            "RenderType" = "Transparent"
        }
        LOD 200
        Cull Back

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard alpha:fade

        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color; 
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
