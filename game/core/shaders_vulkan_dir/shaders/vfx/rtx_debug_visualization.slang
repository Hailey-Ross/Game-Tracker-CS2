//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Debug visualization for various ray traced properties";
	DevShader = true;
	Version = 0;
	
	// Platform: VULKAN_SM_60
	// Programs: rtx
}

MODES
{
	RayTrace();
}

FEATURES
{
}

COMMON
{
	#include "system.fxc"
}

RTX
{
	DynamicCombo( D_DEBUG_MODE, 0..12 );
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5319
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#if defined(GL_AMD_gpu_shader_half_float)
	#extension GL_AMD_gpu_shader_half_float : require
	#elif defined(GL_EXT_shader_explicit_arithmetic_types_float16)
	#extension GL_EXT_shader_explicit_arithmetic_types_float16 : require
	#else
	#error No extension available for FP16.
	#endif
	#extension GL_EXT_shader_16bit_storage : require
	#extension GL_EXT_ray_tracing : require
	#extension GL_EXT_shader_image_load_formatted : require
	
	struct MaterialDataMinimal_t
	{
	    f16vec3 vNormalWs;
	    float16_t flMetalness;
	    f16vec3 vAlbedo;
	    float16_t flRoughness;
	    f16vec3 vEmissive;
	    float16_t flReflectance;
	    uint nMaterialTypeAndFlags;
	    f16vec4 vMaterialBits;
	};
	
	struct Payload_t
	{
	    vec3 vSmoothPositionWs;
	    vec3 vFaceNormalWs;
	    vec3 vInterpolatedNormalWs;
	    float flHitT;
	    float flOpacityRng;
	    int nInstance;
	    bool bFlippedNormal;
	    MaterialDataMinimal_t material;
	};
	
	struct PayloadShadow_t
	{
	    float m_flVisibility;
	};
	
	struct SceneGlobalInfoGPU_t_natural
	{
	    vec4 m_vSkyColor;
	    vec4 m_vSkyAmbientBounce;
	    vec4 m_vSunLightIrradiance;
	    vec4 m_vLocalLightMinBounds;
	    vec4 m_vLocalLightMaxBounds;
	    ivec4 m_vLightBinCellCount_nLightCount;
	    mat4x3 m_mIBLTransformI;
	    vec4 m_vIBLCubeMapScale;
	    int m_nIBLTexture;
	    int m_nIBLCubeMap;
	    int m_nIBLCubeMapFormat;
	    uint m_nSkyLightFlags;
	    int m_nBrdfLut;
	    int m_nBrdfMultiscatterLut;
	    uint m_nSceneGlobalInfoFlags;
	    uint _unused0;
	};
	
	vec4 _143;
	
	layout(set = 3, binding = 37, std430) readonly buffer StructuredBuffer
	{
	    layout(row_major) SceneGlobalInfoGPU_t_natural _member0[];
	} g_SceneGlobalInfo;
	
	layout(push_constant, std430) uniform PushConstants_t_t_natural
	{
	    layout(row_major) mat4 m_mInvViewProj;
	    vec4 m_vCameraOrigin;
	    vec4 m_vRandomOffsets;
	    ivec4 m_nIntParams;
	} PushConstants_t;
	
	layout(set = 6, binding = 158) uniform image2D g_OutputImage;
	layout(set = 6, binding = 161) uniform readonly image3D g_RandomSamples;
	layout(location = 0) rayPayloadEXT Payload_t p;
	layout(set = 3, binding = 30) uniform accelerationStructureEXT g_AccelStruct;
	layout(location = 1) rayPayloadEXT PayloadShadow_t p_1;
	layout(set = 4, binding = 46) uniform textureCube g_bindless_TextureCube[65536];
	layout(set = 3, binding = 14) uniform sampler g_Sampler;
	layout(set = 6, binding = 159) uniform image2D g_VarianceImage;
	
	void main()
	{
	    vec2 _215 = (((vec2(gl_LaunchIDEXT.xy) + PushConstants_t.m_vRandomOffsets.xy) / vec2(gl_LaunchSizeEXT.xy)) * 2.0) - vec2(1.0);
	    _215.y = -_215.y;
	    vec4 _221 = PushConstants_t.m_mInvViewProj * vec4(_215.xy, 0.0, 1.0);
	    vec3 _225 = _221.xyz / vec3(_221.w);
	    vec4 _227;
	    _227.x = _225.x;
	    _227.y = _225.y;
	    _227.z = _225.z;
	    vec3 _236 = normalize(_227.xyz - PushConstants_t.m_vCameraOrigin.xyz);
	    vec4 vCurrentSample;
	    if (PushConstants_t.m_nIntParams.y > 0)
	    {
	        vCurrentSample = imageLoad(g_OutputImage, ivec2(gl_LaunchIDEXT.xy));
	    }
	    else
	    {
	        vCurrentSample = vec4(0.0);
	    }
	    uvec3 _251 = uvec3(imageSize(g_RandomSamples));
	    ivec3 _197;
	    ivec3 _254 = _197;
	    _254.x = int(_251.x);
	    _254.y = int(_251.y);
	    _254.z = int(_251.z);
	    _197 = _254;
	    ivec2 _263 = ivec2(gl_LaunchIDEXT.xy) - _254.xy * (ivec2(gl_LaunchIDEXT.xy) / _254.xy);
	    f16vec3 _270 = f16vec3(vec3(0.0));
	    vec3 _172;
	    p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _172, 3.4028234663852885981170418348452e+38, imageLoad(g_RandomSamples, ivec3(_263.xy, 1)).xy.y, -1, false, MaterialDataMinimal_t(_270, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _270, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	    traceRayEXT(g_AccelStruct, 16u, 1u, 0u, 2u, 0u, PushConstants_t.m_vCameraOrigin.xyz, 0.0, _236, 56755.83984375, 0);
	    vec3 _171 = p.vSmoothPositionWs;
	    vec3 _170 = p.vFaceNormalWs;
	    float _169 = p.flHitT;
	    f16vec3 _152 = p.material.vNormalWs;
	    float16_t _151 = p.material.flMetalness;
	    f16vec3 _150 = p.material.vAlbedo;
	    float16_t _149 = p.material.flRoughness;
	    f16vec3 _148 = p.material.vEmissive;
	    float16_t _147 = p.material.flReflectance;
	    uint _146 = p.material.nMaterialTypeAndFlags;
	    f16vec4 _145 = p.material.vMaterialBits;
	    vec3 vNewSample;
	    if (p.nInstance != (-1))
	    {
	        vec3 _168 = PushConstants_t.m_vCameraOrigin.xyz;
	        vec3 _167 = _236;
	        do
	        {
	            vec3 _175 = _171;
	            vec3 _174 = _170;
	            float _173 = _169;
	            f16vec3 _161 = _152;
	            vec3 _177 = (_168 + (_167 * _173)) + (_174 * ((abs(_168) + vec3(abs(_173))) * 9.9999997473787516355514526367188e-05));
	            vec3 _176 = _174;
	            bool _196;
	            if (false)
	            {
	                _196 = any(notEqual(_175, vec3(3.4028234663852885981170418348452e+38)));
	            }
	            else
	            {
	                _196 = false;
	            }
	            vec3 _340 = _175 - _177;
	            float _341 = length(_340);
	            vec3 _180 = _177;
	            float _179 = 0.0;
	            vec3 _178 = vec4(_340 / vec3(_341), _341).xyz;
	            float _195;
	            if (_196)
	            {
	                _195 = _341;
	            }
	            else
	            {
	                _195 = 0.0;
	            }
	            p_1 = PayloadShadow_t(1.0);
	            traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _180, _179, _178, _195, 1);
	            if (_196)
	            {
	                _195 = p_1.m_flVisibility;
	            }
	            else
	            {
	                _195 = 0.0;
	            }
	            if (_195 == 1.0)
	            {
	                _177 = _175;
	                _176 = vec3(_161);
	            }
	            vec3 _181;
	            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _181, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_152, _151, _150, _149, _148, _147, _146, _145));
	            traceRayEXT(g_AccelStruct, 32u, 32u, 0u, 2u, 0u, _177 - ((_176 * 0.5) * 0.5), 0.0, _176, 0.5, 0);
	            f16vec3 _160 = p.material.vNormalWs;
	            float16_t _159 = p.material.flMetalness;
	            f16vec3 _158 = p.material.vAlbedo;
	            float16_t _157 = p.material.flRoughness;
	            f16vec3 _156 = p.material.vEmissive;
	            float16_t _155 = p.material.flReflectance;
	            uint _154 = p.material.nMaterialTypeAndFlags;
	            f16vec4 _153 = p.material.vMaterialBits;
	            if (p.nInstance != (-1))
	            {
	                _152 = _160;
	                _151 = _159;
	                _150 = _158;
	                _149 = _157;
	                _148 = _156;
	                _147 = _155;
	                _146 = _154;
	                _145 = _153;
	                break;
	            }
	            else
	            {
	                break;
	            }
	            break;
	        } while(false);
	        vec3 _166 = PushConstants_t.m_vCameraOrigin.xyz;
	        vec3 _165 = _236;
	        vec3 _164 = _171;
	        vec3 _163 = _170;
	        float _162 = _169;
	        vec3 _182 = (_166 + (_165 * _162)) + (_163 * ((abs(_166) + vec3(abs(_162))) * 9.9999997473787516355514526367188e-05));
	        bool _194;
	        if (true)
	        {
	            _194 = any(notEqual(_164, vec3(3.4028234663852885981170418348452e+38)));
	        }
	        else
	        {
	            _194 = false;
	        }
	        vec3 _445 = _164 - _182;
	        float _446 = length(_445);
	        vec3 _185 = _182;
	        float _184 = 0.0;
	        vec3 _183 = vec4(_445 / vec3(_446), _446).xyz;
	        float _193;
	        if (_194)
	        {
	            _193 = _446;
	        }
	        else
	        {
	            _193 = 0.0;
	        }
	        p_1 = PayloadShadow_t(1.0);
	        traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _185, _184, _183, _193, 1);
	        if (_194)
	        {
	            _193 = p_1.m_flVisibility;
	        }
	        else
	        {
	            _193 = 0.0;
	        }
	        if (_193 == 1.0)
	        {
	            _182 = _164;
	        }
	        vNewSample = vec3(_150);
	    }
	    else
	    {
	        vec3 _187;
	        do
	        {
	            vec2 _188 = imageLoad(g_RandomSamples, ivec3(_263.xy, 2)).xy;
	            if ((g_SceneGlobalInfo._member0[0].m_nSkyLightFlags & 1u) == 0u)
	            {
	                _187 = vec3(0.0);
	                break;
	            }
	            bool _189;
	            if (_236.z < 0.0)
	            {
	                float _190 = _188.y;
	                bool _186;
	                do
	                {
	                    if (g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w <= 0.0)
	                    {
	                        _186 = false;
	                        break;
	                    }
	                    if (g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w >= 1.0)
	                    {
	                        _186 = true;
	                        break;
	                    }
	                    if (_190 < g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w)
	                    {
	                        _190 = min(_190 / g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w, 0.99999988079071044921875);
	                        _186 = true;
	                        break;
	                    }
	                    _190 = min((_190 - g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w) / (1.0 - g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w), 0.99999988079071044921875);
	                    _186 = false;
	                    break;
	                } while(false);
	                vec2 _518 = _188;
	                _518.y = _190;
	                _188 = _518;
	                _189 = _186;
	            }
	            else
	            {
	                _189 = false;
	            }
	            vec3 _191;
	            vec3 _192;
	            if (_189)
	            {
	                float _526 = sqrt(_188.y);
	                float _528 = 6.283185482025146484375 * _188.x;
	                _191 = vec3(cos(_528) * _526, sin(_528) * _526, sqrt(max(0.0, 1.0 - _188.y)));
	                _192 = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance.xyz;
	            }
	            else
	            {
	                _191 = _236;
	                _192 = vec3(0.0);
	            }
	            if (g_SceneGlobalInfo._member0[0].m_nIBLCubeMap >= 0)
	            {
	                vec4 _567 = textureLod(samplerCube(g_bindless_TextureCube[g_SceneGlobalInfo._member0[0].m_nIBLCubeMap], g_Sampler), normalize(g_SceneGlobalInfo._member0[0].m_mIBLTransformI * vec4(_191, 0.0)), 0.0);
	                if (dot(_567.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) < g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance.w)
	                {
	                    _192 += (g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale.xyz * _567.xyz);
	                }
	            }
	            else
	            {
	                _192 += g_SceneGlobalInfo._member0[0].m_vSkyColor.xyz;
	            }
	            if (false)
	            {
	                _192 *= g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale.w;
	            }
	            if (_189)
	            {
	                _192 *= g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.xyz;
	            }
	            _187 = _192;
	            break;
	        } while(false);
	        vNewSample = _187;
	    }
	    vec4 _611 = vec4(mix(vCurrentSample.xyz, vNewSample, vec3(1.0 / (1.0 + vCurrentSample.w))), 1.0 + vCurrentSample.w);
	    imageStore(g_OutputImage, ivec2(gl_LaunchIDEXT.xy), _611);
	    vec2 _198;
	    if (PushConstants_t.m_nIntParams.y == 0)
	    {
	        _198 = vec2(0.0);
	    }
	    else
	    {
	        _198 = imageLoad(g_VarianceImage, ivec2(gl_LaunchIDEXT.xy)).xy;
	    }
	    float _628 = dot(vNewSample.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    float _633 = _628 - _198.x;
	    float _635 = _198.x + (_633 / _611.w);
	    imageStore(g_VarianceImage, ivec2(gl_LaunchIDEXT.xy), vec4(vec2(_635, _198.y + (_633 * (_628 - _635))), 0.0, 0.0));
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
