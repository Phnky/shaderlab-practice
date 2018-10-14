Shader "Phunky/Basic/Toon-Lit"{
    //shader properties
    Properties{
        //_Name ("Name in Material Settings", input) = (default settings) {}
        _Color ("Main Color", Color) = (0.5,0.5,0.5,1){}
        _MainTex ("Main Texture". 2D) = "white" {}
        _Noisetex ("Noise", 2D) = "white" {}
        _Ramp ("Ramp", 2D) = "gray" {}
    }

    SubShader {
        Tags{ "RenderType" = "Opaque"}
        LOD 200

        CGPROGRAM

        //write properties again so that the shader can use them in functions
        // sampler2D for textures, float4 for colors(rgb and transparency)
        sampler2D _MainTex;
        sampler2D _NoiseTex;
        float4 _Color;
        
        //Struct input is where Unity takes the meshes uv sets.
        //Take the uv set (uv_) for the base main texture (MainTex) and put into a texture interpolator (TEXCOORD0)
        struct Input {
            float2 uv_MainTex : TEXCOORD0;
            //To use a second uv set:
            // float2 uv2_SecondTex : TEXCOORD1;
        };

        void surf (Input IN, inout SurfaceOutput o){
            
            //c is the MainTexture projected over the first UV set, multiplied by the Main Color we choose in the material settings
            half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;

            //set abledo(diffuse) to the c value, making the texture show up on the model
            o.Abledo = c.rgb;

            //deals with transparency
            o.Alpha = c.a;
        }

        ENDCG

    }

}