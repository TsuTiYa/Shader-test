Shader "Custom/NewSurfaceShader" {
	Properties
	{
		_Diffuse("Diffuse Color",color)=(0.5,0.5,0.5,1.0)
		_Bump("Bump",2D)="white"{}
		_Cubemap("Cubemap",CUBE)=""{}
	}

	SubShader
	{
		Pass
		{
			Tags
			{
				"LightMode" = "ForwardBase"
			}
			CGPROGRAM
			#pragma multi_compile_fwdbase
			#pragma vertex vert
			#pragma fragment frag 
			#pragma fragmentoption ARB_precision_hint_fastest

			#include "UnityCG.cginc"
			#include "AutoLight.cginc"

			float4 _LightColor0;
			float4 _Diffuse;
			sampler2D _Bump;
			float4 _Bump_ST;
			samplerCUBE _Cubemap;

			struct vertout 
			{
				float4 pos:SV_POSITION;
				float2 TexCoord:TEXCOORD0;
				float3 lightDir:TEXCOORD1;
				float3 viewDir:TEXCOORD2;
				float4 TangentRX:TEXCOORD3;
				float4 TangentRY:TEXCOORD4;
				float4 TangentRZ:TEXCOORD5;

				LIGHTING_COORDS(6,7)
			};

			vertout vert(appdata_full v)
			{
				vertout OUT;
				OUT.pos = mul(UNITY_MATRIX_MVP,v.vertex);
				OUT.TexCoord = TRANSFORM_TEX(v.texcoord,_Bump);

				TANGENT_SPACE_ROTATION;
				OUT.TangentRX.xyz = mul(rotation,unity_ObjectToWorld[0].xyz);
				OUT.TangentRY.xyz = mul(rotation,unity_ObjectToWorld[1].xyz);
				OUT.TangentRZ.xyz = mul(rotation,unity_ObjectToWorld[2].xyz);

				OUT.lightDir = normalize(ObjSpaceLightDir(v.vertex));
				OUT.viewDir = normalize(ObjSpaceViewDir(v.vertex));

				TRANSFER_VERTEX_TO_FRAGMENT(OUT);

				return OUT;
			}

			fixed4 frag(vertout In):COLOR
			{
				fixed atten = LIGHT_ATTENUATION(In);
				float3 bumpNormal = UnpackNormal(tex2D(_Bump,In.TexCoord));

				float3 normal;
				normal.x = dot(In.TangentRX,bumpNormal);
				normal.y = dot(In.TangentRY,bumpNormal);
				normal.z = dot(In.TangentRZ,bumpNormal);
				float diffuse = max(0,mul(In.lightDir,normal));
				float specular = max(0,mul(normalize(In.lightDir + In.viewDir),normal));
				specular = pow(specular,30);
				//反射ベクトルを計算
				float4 reflectVec;
				reflectVec.xyz = reflect(-In.viewDir,normal);
				reflectVec.w = 1;
				//texCUBE関数を用いて反射ベクトルに基づいた位置の色を取得
				float4 reflectColor = texCUBE(_Cubemap,reflectVec);
				//屈折ベクトルを計算
				float4 refractVec;
				refractVec.xyz = refract(In.viewDir,normal,0.667);
				refractVec.w = 1;
				//texCUBE関数を用いて屈折ベクトルに基づいた位置の色を取得
				float4 refractColor = texCUBE(_Cubemap,refractVec);
				/*
				視点ベクトルとオブジェクトの法線ベクトルの角度によって、
				反射の映り込みの強さと、透過して屈折して見えるものの強さを計算。
				視点の方向を向いている面は、反射は弱く透過が強くなり、
				視点の方向を向いていない面ほど、反射は強く透過は弱くなる。
				*/
				float4 reflectPower = pow(dot(In.viewDir,normal),3);
				float4 refractPower = pow(1.0 - dot(In.viewDir,normal),1.5);
																					//拡散光の陰影を弱くする
				float4 color = UNITY_LIGHTMODEL_AMBIENT + _Diffuse * _LightColor0 * (diffuse + 1)/2;
				//拡散光を透過の強さに応じて調整。
				color *= (refractPower + 1)/2;
				//スペキュラは拡散光も調整の影響を受けないように独立させる。
				color += _LightColor0 * half4(1,1,1,1) * specular;
				//最後に反射と透過を足し算。
				color += reflectPower * refractColor + refractPower * reflectColor;

				return color;
			}
			ENDCG
		}
	}
	FallBack"Diffuse"
}
