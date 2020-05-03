Shader "ShadersIntro/Vertex/VertexColors"
{
    Properties
    {
        _MainTint("Global Color Tint", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        //added custom vertex shader vertex:vert -> func void vert()
        #pragma surface surf Lambert vertex:vert
        #pragma target 3.0

        struct Input
        {
            float4 vertColor;
        };

        float4 _MainTint;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)
        
        //custom vertex shader code
        void vert(inout appdata_full v, out Input o) 
        {
            UNITY_INITIALIZE_OUTPUT(Input, o); //DX11 support
            o.vertColor = v.color; 
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = IN.vertColor.rgb * _MainTint.rgb;;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
