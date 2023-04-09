Shader "Custom/WindowShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _WindowColor ("_WindowColor", Color) = (1,1,1,0.1)
        _FrameColor ("_FrameColor", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.0
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _FrameSize ("_FrameSize", Range(0,3)) = 1
        _Size ("_Size", Vector) = (0.15, 0.25, 1, 0)
        _WindowPos ("_WindowPos", Vector) = (0, 0, 0, 0)
    }
    SubShader
    {
        Tags { "Queue"="Transparent"  "RenderType"="Transparent" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows alpha:fade
        #pragma target 3.0

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        half _Glossiness;
        half _Metallic;
        fixed _FrameSize;
        fixed4 _Size;
        fixed4 _Color;
        fixed4 _WindowColor;
        fixed4 _FrameColor;
        fixed4 _WindowPos;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
            float3 localPos = IN.worldPos -  mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz;
            if(distance(_WindowPos.x, localPos.x) < _Size.x && distance(_WindowPos.y, localPos.y) < _Size.y && distance(_WindowPos.z, localPos.z) < _Size.z)
            {
                o.Albedo = _WindowColor.rgb;
                o.Alpha = _WindowColor.a;
                return;
            }
            if(distance(_WindowPos.x, localPos.x) < _Size.x * _FrameSize && distance(_WindowPos.y, localPos.y) < _Size.y * _FrameSize && distance(_WindowPos.z, localPos.z) < _Size.z * _FrameSize)
            {
                o.Albedo = _FrameColor.rgb;
                o.Alpha = _FrameColor.a;
            }
        }
        ENDCG
    }
    FallBack "Diffuse"
}
