Shader "Phunky/Basic/Toon-Lit"{
    //shader properties
    Properties{
        //_Name ("Name in Material Settings", input) = (default settings) {}
        _Color ("Main Color", Color) = (0.5,0.5,0.5,1){}
        _MainTex ("Main Texture". 2D) = "white" {}
        _NoiseTex ("Noise", 2D) = "white" {}
        _NoiseColor ("Noise Color", 2D) = "white" {}
        _Ramp ("Toon Ramp", 2D) = "gray" {}
    }

    SubShader {
        Tags{ "RenderType" = "Opaque"}
        LOD 200

        CGPROGRAM
        #pragma surface surf ToonRamp

        //write properties again so that the shader can use them in functions
        // sampler2D for textures, float4 for colors(rgb and transparency)
        sampler2D _MainTex;
        sampler2D _NoiseTex;
        float4 _Color;
        float4 _NoiseColor;
        sampler2D _Ramp;
        
        // custom lighting function that uses a texture ramp based on angle between 
        #pragma lighting ToonRamp exclude_path:prepass
        inline half4 LightingToonRamp(Surfaceoutput s, half3 lightDir, half atten){
            #ifndef USING_DIRECTIONAL_LIGHT
            lightDir = normalize(lightDir);
            #endif

            half d=dot(s.Normal, lightDir)*0.5 +0.5;
            half3 ramp = tex2D (_Ramp, float2(d,d)).rgb;

            half4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * ramp * (atten *2);
            c.a = 0;

            return c;
        }

        //Struct input is where Unity takes the meshes uv sets.
        //Take the uv set (uv_) for the base main texture (MainTex) and put into a texture interpolator (TEXCOORD0)
        struct Input {
            float2 uv_MainTex : TEXCOORD0;
            //To use a second uv set:
            // float2 uv2_SecondTex : TEXCOORD1;

            //get worldspace position
            float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutput o){
            
            //c is the MainTexture projected over the first UV set, multiplied by the Main Color we choose in the material settings
            half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;

            //a copy of the line for main texture modified for noise
            half4 n = tex2D(_NoiseTex, IN.worldPos) * _Color;

            //set abledo(diffuse) to the c value, making the texture show up on the model
            //multiplied with n to add noise.
            o.Abledo = c.rgb;

            //check if the value of the noise is greater than 0.5, if so set the albedo to be the new color.
            if(n.r>0.5){
                o.Albedo = _Color2;
            }

            //deals with transparency
            o.Alpha = c.a;
        }

        ENDCG

    }

}