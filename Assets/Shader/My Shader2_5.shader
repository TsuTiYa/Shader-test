Shader "Custom/My Shader2_5" {
	Properties
	{
		_DiffuseColor("Diffuse Color",Color)=(1.0,1.0,1.0)
		_Cube("Cubemap",CUBE)=""{}
	}

	Subshader
	{
		Tags
		{
			"RenderType"="Opaque"
		}
		CGPROGRAM
		#pragma surface surf Lambert

		struct Input
		{
			float3 worldRefl;
		};

		float4 _DiffuseColor;
		samplerCUBE _Cube;

		void surf(Input IN,inout SurfaceOutput o)
		{
			o.Albedo=_DiffuseColor*0.5;
			o.Emission=texCUBE(_Cube,IN.worldRefl).rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
