Shader "Custom/My Shader2_3" {
	Properties
	{
		_DiffuseColor("Diffuse Color",Color)=(1.0,1.0,1.0)
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
			float3 worldPos;
		};
		float4 _DiffuseColor;

		void surf(Input IN,inout SurfaceOutput o)
		{
			o.Albedo=_DiffuseColor;
			clip(frac(IN.worldPos.y*10) - 0.5); 
			//clip(frac(In.worldPos.y*等分数)-スライスの間隔)
		}
		ENDCG
	}
	FallBack "Diffuse"
}
