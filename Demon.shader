
Shader "Unlit/Demon"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Columns ("Columns", int) = 8
		_Rows("Rows", int) = 8
		[PerRendererData]_Rotation ("Rotation", Range(0.0,1.0)) = 0
		[PerRendererData]_Expression("Expression", Range(0.0,1.0)) = 0
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		Cull Back

		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float2 pos : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _Columns;
			fixed _Rows;

			UNITY_INSTANCING_CBUFFER_START(InstanceProperties)
			UNITY_DEFINE_INSTANCED_PROP(fixed, _Rotation)
			UNITY_DEFINE_INSTANCED_PROP(fixed, _Expression)
			UNITY_INSTANCING_CBUFFER_END
			
			v2f vert (appdata v)
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				
				// get the camera basis vectors
				float3 forward = normalize(UNITY_MATRIX_V._m20_m21_m22);
				float3 up = normalize(UNITY_MATRIX_V._m10_m11_m12);
				float3 right = -normalize(UNITY_MATRIX_V._m00_m01_m02);

				// rotation to face camera
				float4x4 rotationMatrix = float4x4(right, 0,
					up, 0,
					forward, 0,
					0, 0, 0, 1);

				float3 viewDir = ObjSpaceViewDir(v.vertex);
				float4 offset = float4(v.pos.x, v.pos.y, 0, 0);
				v.vertex += mul(offset, rotationMatrix);
				float viewRot = atan2(viewDir.z, viewDir.x) / (6.28318530718);

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv.x += floor((UNITY_ACCESS_INSTANCED_PROP(_Rotation) + viewRot) * _Columns) / _Columns; //offset uv based on rotation
				o.uv.y += floor((UNITY_ACCESS_INSTANCED_PROP(_Expression)) * _Rows) / _Rows; //offset uv based on expression or animation

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				clip(col.a - 0.5);
				return col;
			}
			ENDCG
		}
	}
}
