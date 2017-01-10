Shader "Custom/My Shader4_4" {
	Properties
	{
		_Diffuse("Diffuse Color",color)=(1.0,1.0,1.0,1.0)
		_DispTex("Disp Texture",2D)="gray"{}
		_Displacement("Displacement",Range(0,0.2))=0.1
	}

	SubShader
	{
		Tags
		{
			"RenderType"="Opaque"
		}
		CGPROGRAM
		#pragma surface surf Lambert addshadow fullforwardshadows vertex:vert

		struct appdata
		{
			float4 vertex:POSITION;
			float4 tangent:TANGENT;
			float3 normal:NORMAL;
			float2 texcord:TEXCOORD0;
		};

		float _Displacement;
		float4 _DispTex_ST;
		sampler2D _DispTex;

		void vert(inout appdata v)
		{
			float2 uv = TRANSFORM_TEX(v.texcord,_DispTex);
			float tex = tex2Dlod(_DispTex,float4(uv,0,0)).r;

			v.vertex.xyz +=v.normal * tex * _Displacement;
 		}
		 struct Input
		 {
			 float color:COLOR;
		 };

		 float4 _Diffuse;

		 void surf(Input IN,inout SurfaceOutput o)
		 {
			 o.Albedo=_Diffuse;
		 }
		 ENDCG
	}
	FallBack"Diffuse"
}
