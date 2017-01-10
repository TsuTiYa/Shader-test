Shader "Custom/My Shader1_1" {
	Properties {
		_Color ("Diffuse Color",Color)=(1.0,1.0,1.0)
	//	_MainTex ("Albedo (RGB)", 2D) = "white" {}
	//	_Glossiness ("Smoothness", Range(0,1)) = 0.5
	//	_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
	
		struct Input {
			float4 color:COLOR;
		};
		float4  _Color;
		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			//o.Albedo = half3(1.0,0.5,0.4);
			o.Albedo = _Color.rgb;
			// Metallic and smoothness come from slider variables
			
		}
		ENDCG
	}
	FallBack "Diffuse"
}
