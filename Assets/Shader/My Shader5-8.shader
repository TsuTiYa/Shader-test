Shader "Custom/My Shader5-8" {
	//頂点＋フラグメントシェーダーにおけるアルファチャンネル
	Properties
	{
		_Color("Color",color)=(0.5,0.5,0.5,1)
	}

	SubShader
	{
		//Passの前にTagsを記述することにより透明に対応したレンダリングが可能になる
		Tags
		{
			"Queue" = "Transparent"
			"RenderType" = "Transparent"
		}
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha	//Passの直後に記述することでPassで描画された結果がAlphaBlendingされて出力される
			CGPROGRAM

			#pragma multi_compile_fwdbase
			#pragma vertex vert 
			#pragma fragment frag 

			#include "UnityCG.cginc"

			float4 _LightColor0;
			float4 _Color;

			struct vertout
			{
				float4 pos:SV_POSITION;
				float3 viewDir:TEXCOTD1;
				float3 normal:TEXCOORD2;
			};

			vertout vert(appdata_full v)
			{
				vertout OUT;
				OUT.pos = mul(UNITY_MATRIX_MVP,v.vertex);
				OUT.viewDir = normalize(ObjSpaceViewDir(v.vertex));
				OUT.normal = v.normal;

				return OUT;
			}

			fixed4 frag(vertout In):COLOR 
			{
				/*
				カメラ側を向いている面ほど、アルファチャンネルの値が大きくなるように、
				カメラ方向へのベクトルとオブジェクトの法線ベクトルの内積を求め、３乗している。
				*/
				float alpha = pow(max(0,dot(In.viewDir,In.normal)),3);
				float4 color = _Color;
				//上記の計算結果をcolorに代入。
				color.a = alpha;

				return color;
			}
			ENDCG
		}
	}
	FallBack"Diffuse"
}
