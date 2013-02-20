
Shader "ModifiedTextShader"
{

    Properties 
    {
      _MainTex ("Main Texture", 2D) = "white" {} 
      _Color ("Sprite Color", Color) = (1,1,1,1) 

    }

    CGINCLUDE

        #include "UnityCG.cginc"

        half4 _MainTex_ST;
        sampler2D _MainTex;
        fixed4 _Color;

        uniform float4x4 _ClipMatrix;
        uniform float _ClipWidth;
        uniform float _ClipHeight;

        struct v2f 
        {
            half4 pos : POSITION;
            half4 color : COLOR;
            half2 uv[2] : TEXCOORD0;

        };

        v2f vert ( appdata_base v )
        {

            v2f o;
            o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
            //o.uv[0].xy = TRANSFORM_TEX(v.texcoord,_MainTex);
            o.uv[0] =v.texcoord;

            float4 c = mul( _Object2World, v.vertex ); //(model mat x v.vertex) --> world space of obj
            c = mul( _ClipMatrix, c ); // (clipper world space to local space mat) x (c)
            o.uv[1] = c;

            o.color = _Color;

            return o; 
        }

        // Apply shader
        half4 frag(v2f i) : COLOR 
        { 
            fixed4 tex = tex2D(_MainTex, i.uv[0].xy);
            tex =float4(i.color.r, i.color.g, i.color.b, tex.a);

            float halfWidth =_ClipWidth;
            float halfHeight =_ClipHeight;
            if (i.uv[1].x > halfWidth || 
                i.uv[1].x < 0 || 
                i.uv[1].y > 0 || 
                i.uv[1].y < -halfHeight)
            tex.a =0;

            return tex; 

        }

    ENDCG


    SubShader
    {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }

        Cull Off
        ZWrite On 

        Fog { Mode Off } 

        Blend SrcAlpha OneMinusSrcAlpha 

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest 
            
            ENDCG
        }
    }
}
