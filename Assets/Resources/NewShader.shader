Shader "ModifiedTextShader"
{ 
 Properties
 {
  _MainTex ("Font Texture", 2D) = "white" {}
  _Color ("Text Color", Color) = (1,1,1,1) 
 }
 
 SubShader
 {
  Tags
  {
   "Queue"="Transparent"
   "IgnoreProjector"="True" 
   "RenderType"="Transparent"
  }
 
  Pass
  {
   CGPROGRAM
   // Upgrade NOTE: excluded shader from OpenGL ES 2.0 because it does not contain a surface program or both vertex and fragment programs.
   #pragma exclude_renderers gles
   #pragma vertex vert
   #pragma fragment frag
   #include "UnityCG.cginc"
 
   struct v2f
   {
    float4 pos : SV_POSITION;
    float4 uv[2] : TEXCOORD0;
    float4 color : COLOR0;
   };
 
   uniform float4x4 _ClipMatrix;
   uniform float4 _Color;
   sampler2D _MainTex;
   uniform float _ClipWidth;
   uniform float _ClipHeight;
 
   v2f vert( appdata_base v )
   {
    v2f o;
    o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
 
    o.uv[0] = v.texcoord;
 
    float4 c = mul( _Object2World, v.vertex ); 
    c = mul( _ClipMatrix, c ); 
    o.uv[1] = c;
 
    o.color = _Color;
 
    return o;
   }
 
   half4 frag(v2f i) : COLOR
   {
    half4 texcol =tex2D(_MainTex, i.uv[0].xy);
    texcol =float4(i.color.r, i.color.g, i.color.b ,texcol.a);
 
    float halfWidth =_ClipWidth*0.5f;
    float halfHeight =_ClipHeight*0.5f;
    if (
     i.uv[1].x >halfWidth || 
     i.uv[1].x <-halfWidth|| 
     i.uv[1].y >halfHeight || 
     i.uv[1].y <-halfHeight)
     texcol.a =0;
 
    return texcol;
   }
 
   ENDCG
 
   Cull Off
   ZWrite On 
   Fog { Mode Off } 
   Blend SrcAlpha OneMinusSrcAlpha 
  }
 } 
}