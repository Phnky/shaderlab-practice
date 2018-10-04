Shader "Phunky/Basic/Unlit" {
    Properties {
        //variablename("name in material inspector", type) = default value
        _MainTex("Main Texture", 2D) = "White" {}
        _Color ("Color", Color) = (0, 0, 0, 0)
    }
    SubShader {
        Pass {
            CGPROGRAM
            //CGPROGRAM is Unity's HLSL/CG language variant
            
            //declaring function types
            #pragma vertex vertexFunction
            #pragma fragment fragmentFunction

            //includes
            //Unity defined functions
            #include "UnityCG.cginc"
            
            //data structures
            //vertices and uv doordinates
            struct appdata{
                //declare variables in struct
                //'type' 'name' : 'value';
                //position of vertices
                float4 vertex : POSITION;
                //UV Coordinates
                float2 uv : TEXCOORD0;
            };

            //vertex to fragment struct
            //contains data that will be passed to fragment function
            struct v2f{
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;

            };
            
            //shader properties
            //can appear anywhere in the top scope of CGPROGRAM
            sampler2D _MainTex
            fixed4 _Color

            //define functions
            //vertex function is taking arguments from appdata
            //passes it into v2f struct
            v2f vertexFunction(appdata IN){
                v2f OUT;
                
                //take vertex represented in local space, transform to camera's clip space
                OUT.position = UnityObjectToClipPos(IN.vertex);
                //take UV coordinates from model
                OUT.uv = IN.uv;

                return OUT;
            }
            //takes v2f struct as argument
            //:SV_TARGET - outputting fixed 4 color to be rendered using ouput semantic
            fixed4 fragmentFunction(v2f IN) : SV_TARGET{
                //return _Color; //(R,G,B,A)
                //to sample colors from texture at certain points, use builtin function tex2D
                //pass main texture and IN.uv
                return tex2D(_MainTex, IN.uv);
            }

            ENDCG
        }
    }
}