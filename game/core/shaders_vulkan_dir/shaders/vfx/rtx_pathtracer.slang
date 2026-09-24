//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Sampled path tracer, to be used for baked lighting or general path tracing";
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
	StaticCombo( S_EXECUTION_REORDERING, 0..1 );
	DynamicCombo( D_DIRECT_LIGHT, 0..1 );
	DynamicCombo( D_INDIRECT_LIGHT, 0..1 );
	DynamicCombo( D_LIGHTING_ONLY, 0..1 );
	DynamicCombo( D_MATERIAL_MODE, 0..2 );
	DynamicCombo( D_MULTISCATTERING, 0..1 );
	DynamicCombo( D_SHADER_CLOCK, 0..1 );
	DynamicComboRule( Requires( D_MULTISCATTERING, D_MATERIAL_MODE==0 ) );
	
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
	
	vec4 _144;
	
	layout(set = 3, binding = 37, std430) readonly buffer StructuredBuffer
	{
	    layout(row_major) SceneGlobalInfoGPU_t_natural _member0[];
	} g_SceneGlobalInfo;
	
	layout(push_constant, std430) uniform PathTracePushConstants_t_natural
	{
	    layout(row_major) mat4 m_mInvViewProj;
	    vec4 m_vCameraOrigin;
	    vec4 m_vRandomOffsets;
	    uint m_nSamplerDimensionCount;
	    uint m_nSampleCount;
	    uint m_nSamplesPerFrame;
	    uint m_nBounceToShow;
	    uint m_nSharcPass;
	} PathTracePushConstants;
	
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
	    vec2 _216 = (((vec2(gl_LaunchIDEXT.xy) + PathTracePushConstants.m_vRandomOffsets.xy) / vec2(gl_LaunchSizeEXT.xy)) * 2.0) - vec2(1.0);
	    _216.y = -_216.y;
	    vec4 _222 = PathTracePushConstants.m_mInvViewProj * vec4(_216.xy, 0.0, 1.0);
	    vec3 _226 = _222.xyz / vec3(_222.w);
	    vec4 _228;
	    _228.x = _226.x;
	    _228.y = _226.y;
	    _228.z = _226.z;
	    vec3 _237 = normalize(_228.xyz - PathTracePushConstants.m_vCameraOrigin.xyz);
	    int nSampleCount = int(PathTracePushConstants.m_nSampleCount);
	    vec4 vCurrentSample;
	    if (nSampleCount > 0)
	    {
	        vCurrentSample = imageLoad(g_OutputImage, ivec2(gl_LaunchIDEXT.xy));
	    }
	    else
	    {
	        vCurrentSample = vec4(0.0);
	    }
	    uvec3 _254 = uvec3(imageSize(g_RandomSamples));
	    ivec3 _198;
	    ivec3 _257 = _198;
	    _257.x = int(_254.x);
	    _257.y = int(_254.y);
	    _257.z = int(_254.z);
	    _198 = _257;
	    ivec2 _266 = ivec2(gl_LaunchIDEXT.xy) - _257.xy * (ivec2(gl_LaunchIDEXT.xy) / _257.xy);
	    f16vec3 _273 = f16vec3(vec3(0.0));
	    vec3 _173;
	    p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _173, 3.4028234663852885981170418348452e+38, imageLoad(g_RandomSamples, ivec3(_266.xy, 1)).xy.y, -1, false, MaterialDataMinimal_t(_273, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _273, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	    traceRayEXT(g_AccelStruct, 16u, 1u, 0u, 2u, 0u, PathTracePushConstants.m_vCameraOrigin.xyz, 0.0, _237, 56755.83984375, 0);
	    vec3 _172 = p.vSmoothPositionWs;
	    vec3 _171 = p.vFaceNormalWs;
	    float _170 = p.flHitT;
	    f16vec3 _153 = p.material.vNormalWs;
	    float16_t _152 = p.material.flMetalness;
	    f16vec3 _151 = p.material.vAlbedo;
	    float16_t _150 = p.material.flRoughness;
	    f16vec3 _149 = p.material.vEmissive;
	    float16_t _148 = p.material.flReflectance;
	    uint _147 = p.material.nMaterialTypeAndFlags;
	    f16vec4 _146 = p.material.vMaterialBits;
	    vec3 vNewSample;
	    if (p.nInstance != (-1))
	    {
	        vec3 _169 = PathTracePushConstants.m_vCameraOrigin.xyz;
	        vec3 _168 = _237;
	        do
	        {
	            vec3 _176 = _172;
	            vec3 _175 = _171;
	            float _174 = _170;
	            f16vec3 _162 = _153;
	            vec3 _178 = (_169 + (_168 * _174)) + (_175 * ((abs(_169) + vec3(abs(_174))) * 9.9999997473787516355514526367188e-05));
	            vec3 _177 = _175;
	            bool _197;
	            if (false)
	            {
	                _197 = any(notEqual(_176, vec3(3.4028234663852885981170418348452e+38)));
	            }
	            else
	            {
	                _197 = false;
	            }
	            vec3 _343 = _176 - _178;
	            float _344 = length(_343);
	            vec3 _181 = _178;
	            float _180 = 0.0;
	            vec3 _179 = vec4(_343 / vec3(_344), _344).xyz;
	            float _196;
	            if (_197)
	            {
	                _196 = _344;
	            }
	            else
	            {
	                _196 = 0.0;
	            }
	            p_1 = PayloadShadow_t(1.0);
	            traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _181, _180, _179, _196, 1);
	            if (_197)
	            {
	                _196 = p_1.m_flVisibility;
	            }
	            else
	            {
	                _196 = 0.0;
	            }
	            if (_196 == 1.0)
	            {
	                _178 = _176;
	                _177 = vec3(_162);
	            }
	            vec3 _182;
	            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _182, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_153, _152, _151, _150, _149, _148, _147, _146));
	            traceRayEXT(g_AccelStruct, 32u, 32u, 0u, 2u, 0u, _178 - ((_177 * 0.5) * 0.5), 0.0, _177, 0.5, 0);
	            f16vec3 _161 = p.material.vNormalWs;
	            float16_t _160 = p.material.flMetalness;
	            f16vec3 _159 = p.material.vAlbedo;
	            float16_t _158 = p.material.flRoughness;
	            f16vec3 _157 = p.material.vEmissive;
	            float16_t _156 = p.material.flReflectance;
	            uint _155 = p.material.nMaterialTypeAndFlags;
	            f16vec4 _154 = p.material.vMaterialBits;
	            if (p.nInstance != (-1))
	            {
	                _153 = _161;
	                _152 = _160;
	                _151 = _159;
	                _150 = _158;
	                _149 = _157;
	                _148 = _156;
	                _147 = _155;
	                _146 = _154;
	                break;
	            }
	            else
	            {
	                break;
	            }
	            break;
	        } while(false);
	        vec3 _167 = PathTracePushConstants.m_vCameraOrigin.xyz;
	        vec3 _166 = _237;
	        vec3 _165 = _172;
	        vec3 _164 = _171;
	        float _163 = _170;
	        vec3 _183 = (_167 + (_166 * _163)) + (_164 * ((abs(_167) + vec3(abs(_163))) * 9.9999997473787516355514526367188e-05));
	        bool _195;
	        if (true)
	        {
	            _195 = any(notEqual(_165, vec3(3.4028234663852885981170418348452e+38)));
	        }
	        else
	        {
	            _195 = false;
	        }
	        vec3 _448 = _165 - _183;
	        float _449 = length(_448);
	        vec3 _186 = _183;
	        float _185 = 0.0;
	        vec3 _184 = vec4(_448 / vec3(_449), _449).xyz;
	        float _194;
	        if (_195)
	        {
	            _194 = _449;
	        }
	        else
	        {
	            _194 = 0.0;
	        }
	        p_1 = PayloadShadow_t(1.0);
	        traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _186, _185, _184, _194, 1);
	        if (_195)
	        {
	            _194 = p_1.m_flVisibility;
	        }
	        else
	        {
	            _194 = 0.0;
	        }
	        if (_194 == 1.0)
	        {
	            _183 = _165;
	        }
	        if (int(PathTracePushConstants.m_nBounceToShow) < 1)
	        {
	            vNewSample = vec3(_149);
	        }
	        else
	        {
	            vNewSample = vec3(0.0);
	        }
	    }
	    else
	    {
	        vec3 _188;
	        do
	        {
	            vec2 _189 = imageLoad(g_RandomSamples, ivec3(_266.xy, 2)).xy;
	            if ((g_SceneGlobalInfo._member0[0].m_nSkyLightFlags & 1u) == 0u)
	            {
	                _188 = vec3(0.0);
	                break;
	            }
	            bool _190;
	            if (_237.z < 0.0)
	            {
	                float _191 = _189.y;
	                bool _187;
	                do
	                {
	                    if (g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w <= 0.0)
	                    {
	                        _187 = false;
	                        break;
	                    }
	                    if (g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w >= 1.0)
	                    {
	                        _187 = true;
	                        break;
	                    }
	                    if (_191 < g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w)
	                    {
	                        _191 = min(_191 / g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w, 0.99999988079071044921875);
	                        _187 = true;
	                        break;
	                    }
	                    _191 = min((_191 - g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w) / (1.0 - g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w), 0.99999988079071044921875);
	                    _187 = false;
	                    break;
	                } while(false);
	                vec2 _525 = _189;
	                _525.y = _191;
	                _189 = _525;
	                _190 = _187;
	            }
	            else
	            {
	                _190 = false;
	            }
	            vec3 _192;
	            vec3 _193;
	            if (_190)
	            {
	                float _533 = sqrt(_189.y);
	                float _535 = 6.283185482025146484375 * _189.x;
	                _192 = vec3(cos(_535) * _533, sin(_535) * _533, sqrt(max(0.0, 1.0 - _189.y)));
	                _193 = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance.xyz;
	            }
	            else
	            {
	                _192 = _237;
	                _193 = vec3(0.0);
	            }
	            if (g_SceneGlobalInfo._member0[0].m_nIBLCubeMap >= 0)
	            {
	                vec4 _574 = textureLod(samplerCube(g_bindless_TextureCube[g_SceneGlobalInfo._member0[0].m_nIBLCubeMap], g_Sampler), normalize(g_SceneGlobalInfo._member0[0].m_mIBLTransformI * vec4(_192, 0.0)), 0.0);
	                if (dot(_574.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) < g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance.w)
	                {
	                    _193 += (g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale.xyz * _574.xyz);
	                }
	            }
	            else
	            {
	                _193 += g_SceneGlobalInfo._member0[0].m_vSkyColor.xyz;
	            }
	            if (false)
	            {
	                _193 *= g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale.w;
	            }
	            if (_190)
	            {
	                _193 *= g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.xyz;
	            }
	            _188 = _193;
	            break;
	        } while(false);
	        vNewSample = _188;
	    }
	    vec4 _618 = vec4(mix(vCurrentSample.xyz, vNewSample, vec3(1.0 / (1.0 + vCurrentSample.w))), 1.0 + vCurrentSample.w);
	    imageStore(g_OutputImage, ivec2(gl_LaunchIDEXT.xy), _618);
	    vec2 _199;
	    if (nSampleCount == 0)
	    {
	        _199 = vec2(0.0);
	    }
	    else
	    {
	        _199 = imageLoad(g_VarianceImage, ivec2(gl_LaunchIDEXT.xy)).xy;
	    }
	    float _635 = dot(vNewSample.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    float _640 = _635 - _199.x;
	    float _642 = _199.x + (_640 / _618.w);
	    imageStore(g_VarianceImage, ivec2(gl_LaunchIDEXT.xy), vec4(vec2(_642, _199.y + (_640 * (_635 - _642))), 0.0, 0.0));
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
