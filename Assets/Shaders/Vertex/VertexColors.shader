﻿Shader "ShadersIntro/Vertex/VertexColors"
{
    Properties
    {
        _MainTint("Global Color Tint", Color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {} 
        _tintAmount ("Tint Amount", Range(0,1)) = 0.5 
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (1,1,1,1)
        _Speed ("Wave Speed", Range(0.1, 80)) = 5 
        _Frequency ("Wave Frequency", Range(0, 5)) = 2 
        _Amplitude ("Wave Amplitude", Range(-1, 1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        Cull off

        CGPROGRAM
        //added custom vertex shader vertex:vert -> func void vert()
        #pragma surface surf Lambert vertex:vert
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
            float4 vertColor;
        };

        float4 _MainTint;
        sampler2D _MainTex;
        float4 _ColorA;
        float4 _ColorB;
        float _tintAmount;
        float _Speed;
        float _Frequency;
        float _Amplitude;
        float _OffsetVal;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)
        
        //custom vertex shader code
        void vert(inout appdata_full v, out Input o) 
        {
            UNITY_INITIALIZE_OUTPUT(Input, o); //DX11 support
            
            float time = _Time * _Speed;
            float waveValueA = sin(time + v.vertex.x * _Frequency) * _Amplitude;
            v.vertex.xyz = float3(v.vertex.x, v.vertex.y + waveValueA, v.vertex.z);
            v.normal = normalize(float3(v.normal.x + waveValueA, v.normal.y, v.normal.z));
            
            o.vertColor = v.color; 
        }

        void surf (Input IN, inout SurfaceOutput o)
        {            
            half4 c = tex2D (_MainTex, IN.uv_MainTex);
            float3 tintColor = lerp(_ColorA, _ColorB, IN.vertColor).rgb * _MainTint.rgb;
            
            o.Albedo = c.rgb * (tintColor * _tintAmount);
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
