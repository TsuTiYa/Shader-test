Shader "Custom/My Shader2_1" {
	Properties
	{
		_DiffuseColor("Diffuse Color",Color)=(1.0,1.0,1.0)
		_RimColor("Rim Color",Color)=(0.0,0.0,0.0) 	//輪郭の色
		_RimWidth("Rim Width",Range(0.5,8.0))=3.0	//輪郭の大きさ？数値が大きくなるほど輪郭がくっきり
	}

	SubShader
	{
		Tags
		{
			"RenderType"="Opaque"
		}
		CGPROGRAM
		#pragma surface surf Lambert

		struct Input
		{
			float3 viewDir;
		};

		float4 _DiffuseColor;
		float4 _RimColor;
		float _RimWidth;
		void surf(Input IN,inout SurfaceOutput o)
		{
			o.Albedo=_DiffuseColor;
			half rim =1.0 - saturate(dot(normalize(IN.viewDir),o.Normal));
			o.Emission=_RimColor.rgb*pow(rim,_RimWidth);
		}
		ENDCG
	}
	FallBack"Diffuse"
}
