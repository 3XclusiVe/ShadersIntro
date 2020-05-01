Shader "ShadersIntro/CircleShader"
{
    Properties
    {
        _MainTex("Texture", 2d) = ""{}
        _CircleColor ("Color", Color) = (1,1,1,1)
        _CircleCenter ("Center", Vector) = (0,0,0,0)
        _CircleRadius ("Radius", Float) = 2
        _CircleWidth ("Width", Float) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        #pragma target 3.0


        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos; //posistion in worlds coords
        };
        
        sampler2D _MainTex;
        float4 _CircleColor;
        float4 _CircleCenter;
        float _CircleRadius;
        float _CircleWidth;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float d = distance(_CircleCenter, IN.worldPos);
            
            if(d > _CircleRadius && d < _CircleRadius + _CircleWidth)
            {
                o.Albedo = _CircleColor.rgb;
                o.Alpha = _CircleColor.a;
            } else {
                fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
                o.Albedo = c.rgb;
                o.Alpha = c.a;
            }
        }
        ENDCG
    }
    FallBack "Diffuse"
}
