//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Shader to generate lightmaps";
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
	DynamicCombo( D_SH_LIGHTMAPS, 0..1 );
	
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
	#extension GL_EXT_nonuniform_qualifier : require
	#extension GL_EXT_samplerless_texture_functions : require
	#if defined(GL_EXT_control_flow_attributes)
	#extension GL_EXT_control_flow_attributes : require
	#define SPIRV_CROSS_FLATTEN [[flatten]]
	#define SPIRV_CROSS_BRANCH [[dont_flatten]]
	#define SPIRV_CROSS_UNROLL [[unroll]]
	#define SPIRV_CROSS_LOOP [[dont_unroll]]
	#else
	#define SPIRV_CROSS_FLATTEN
	#define SPIRV_CROSS_BRANCH
	#define SPIRV_CROSS_UNROLL
	#define SPIRV_CROSS_LOOP
	#endif
	#extension GL_KHR_shader_subgroup_arithmetic : require
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
	
	struct Luxel_t_natural
	{
	    vec4 vIrradiance_flSampleCount;
	    vec4 vShr;
	    vec4 vShg;
	    vec4 vShb;
	    vec4 vQuadraticr;
	    vec4 vQuadraticg;
	    vec4 vQuadraticb;
	    vec4 vQuadraticFinalrgb;
	    vec4 vBakedShadow;
	    vec4 vBakedShadowUnoccluded;
	    ivec4 vBakedShadowLightId;
	    vec4 vTangent;
	    vec4 vNormal;
	    vec4 flAmbientOcclusion_vPadding;
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
	
	struct LightmapSample_t_natural
	{
	    vec4 m_vPositionWs;
	    vec4 m_vShadingNormalWs_vTransmissiveR;
	    vec4 m_vInterpolatedNormalWs_vTransmissiveG;
	    vec4 m_vFaceNormalWs_vTransmissiveB;
	    vec4 m_vTangentWs;
	    vec2 m_vLightmapUv;
	    int m_nInstanceFlags;
	    uint m_nSampleFlags;
	};
	
	struct PackedRtxInstanceData_t_natural
	{
	    uint nSrgbColor;
	    uint nTriangleGeometry;
	    uint nMaterialData;
	    uint nMaterialFlags_nInstanceFlags;
	    float fEmissiveBoost;
	    uint nInstanceFlags;
	    uint _pad1;
	    uint _pad2;
	};
	
	struct PayloadShadow_t
	{
	    float m_flVisibility;
	};
	
	struct _Array_natural_vector_float_4_5
	{
	    vec4 data[5];
	};
	
	struct PathTraceBarnLightGPU_t_natural
	{
	    mat4 m_mToClipSpace;
	    mat4 m_mFromClipSpace;
	    vec4 m_vNearPlane;
	    vec4 m_vLightPosition;
	    vec4 m_vCookieParameters;
	    vec4 m_vColor;
	    vec4 m_vBounceColor;
	    vec4 m_vOrientation;
	    vec4 m_vAngleFade;
	    vec4 m_vDistanceFade_vSkirt;
	    _Array_natural_vector_float_4_5 m_vLuminaireVectors;
	    vec4 m_vMinBounds;
	    vec4 m_vMaxBounds;
	    vec4 m_vIlluminationBoundsCenter;
	    vec4 m_qIlluminationBoundsOrient;
	    vec4 m_vIlluminationBoundsExtent;
	    mat4x3 m_mBarnIlluminationFromWorld;
	    int m_nCookie;
	    int m_nLuminaireType;
	    int m_nPathTraceFlags;
	    int m_bSphericalCookie;
	    int m_nBakedShadowIndex;
	    int m_nShadowedLightId;
	    int m_nPreviewBakedShadowIndex;
	    int _pad;
	};
	
	struct _Array_natural_vector_float_4_480
	{
	    vec4 data[480];
	};
	
	struct SSProfileConstants_natural
	{
	    vec4 m_vNearInv2Variance;
	    vec4 m_vNearInvPi2Variance;
	    vec4 m_vFarInv2Variance;
	    vec4 m_vFarInvPi2Variance_NearWt;
	    vec4 m_vNormalization;
	    uint m_bDualLobeSpecular;
	    float m_fDualLobeRoughness0;
	    float m_fDualLobeRoughness1;
	    float m_fDualLobeRoughnessMix;
	    vec3 m_vTransmissiveLogColor;
	    float m_fTransmissiveSaturation;
	    float m_fFresnelExponent;
	    float m_fPad0;
	    float m_fPad1;
	    float m_fPad2;
	};
	
	struct _Array_natural_SSProfileConstants32
	{
	    SSProfileConstants_natural data[32];
	};
	
	const vec4 _303[5] = vec4[](vec4(0.0), vec4(1.0, 0.0, 0.0, 0.0), vec4(0.0, 1.0, 0.0, 0.0), vec4(0.0, 0.0, 1.0, 0.0), vec4(0.0, 0.0, 0.0, 1.0));
	vec4 _336;
	float _337;
	
	layout(set = 6, binding = 158, std430) buffer RWStructuredBuffer
	{
	    Luxel_t_natural _member0[];
	} g_Luxels;
	
	layout(set = 3, binding = 37, std430) readonly buffer StructuredBuffer
	{
	    layout(row_major) SceneGlobalInfoGPU_t_natural _member0[];
	} g_SceneGlobalInfo;
	
	layout(set = 6, binding = 160, std430) buffer g_LightmapSamples
	{
	    LightmapSample_t_natural _member0[];
	} g_LightmapSamples_1;
	
	layout(set = 3, binding = 35, std430) readonly buffer g_instanceBuffer
	{
	    PackedRtxInstanceData_t_natural _member0[];
	} g_instanceBuffer_1;
	
	layout(set = 6, binding = 159, std430) buffer g_LightBins
	{
	    uint _member0[];
	} g_LightBins_1;
	
	layout(set = 3, binding = 36, std430) readonly buffer g_Lights
	{
	    layout(row_major) PathTraceBarnLightGPU_t_natural _member0[];
	} g_Lights_1;
	
	struct SLANG_ParameterGroup_SubsurfaceProfilesConstantBuffer_t_natural
	{
	    uint g_nSampleCount;
	    uint _padA;
	    uint _padB;
	    uint _padC;
	    _Array_natural_vector_float_4_480 g_vSubsurfaceSamples;
	    _Array_natural_SSProfileConstants32 g_SubsurfaceProfile;
	};
	
	layout(set = 3) uniform SLANG_ParameterGroup_SubsurfaceProfilesConstantBuffer_t_natural SubsurfaceProfilesConstantBuffer_t;
	
	layout(push_constant, std430) uniform LightmapPushConstants_t_natural
	{
	    ivec4 m_nEstimate_DimensionCount;
	    vec4 m_vLightmapOffsetAndSize;
	    vec4 m_vCordonMins;
	    vec4 m_vCordonMaxs;
	} g_PushConstants;
	
	layout(set = 6, binding = 162, r32ui) uniform readonly uimage3D g_LightmapBlockConverged;
	layout(set = 6, binding = 161) uniform readonly image3D g_RandomSamples;
	layout(set = 6, binding = 30) uniform utexture2D g_LuxelChartIDs;
	layout(location = 0) rayPayloadEXT Payload_t p;
	layout(set = 3, binding = 30) uniform accelerationStructureEXT g_AccelStruct;
	layout(set = 4, binding = 46) uniform textureCube g_bindless_TextureCube[65536];
	layout(set = 3, binding = 14) uniform sampler g_Sampler;
	layout(location = 1) rayPayloadEXT PayloadShadow_t p_1;
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D[65536];
	layout(set = 3, binding = 15) uniform sampler g_CookieSampler;
	
	void main()
	{
	    bool _649 = false;
	    bool _749 = false;
	    bool _803 = false;
	    do
	    {
	        uint _883 = (gl_LaunchIDEXT.y * gl_LaunchSizeEXT.x) + gl_LaunchIDEXT.x;
	        if (g_PushConstants.m_nEstimate_DimensionCount.x == 0)
	        {
	            g_Luxels._member0[_883].vIrradiance_flSampleCount = vec4(0.0);
	            g_Luxels._member0[_883].vShr = vec4(0.0);
	            g_Luxels._member0[_883].vShg = vec4(0.0);
	            g_Luxels._member0[_883].vShb = vec4(0.0);
	            g_Luxels._member0[_883].vQuadraticr = vec4(0.0);
	            g_Luxels._member0[_883].vQuadraticg = vec4(0.0);
	            g_Luxels._member0[_883].vQuadraticb = vec4(0.0);
	            g_Luxels._member0[_883].vQuadraticFinalrgb = vec4(0.0);
	            g_Luxels._member0[_883].vBakedShadow = vec4(0.0);
	            g_Luxels._member0[_883].vBakedShadowUnoccluded = vec4(0.0);
	            g_Luxels._member0[_883].vBakedShadowLightId = ivec4(255);
	            g_Luxels._member0[_883].vTangent = vec4(0.0);
	            g_Luxels._member0[_883].vNormal = vec4(0.0);
	            g_Luxels._member0[_883].flAmbientOcclusion_vPadding = vec4(0.0);
	        }
	        else
	        {
	            if (imageLoad(g_LightmapBlockConverged, ivec3(gl_LaunchIDEXT / uvec3(4u, 4u, 1u))).x != 0u)
	            {
	                break;
	            }
	        }
	        uvec3 _923 = uvec3(imageSize(g_RandomSamples));
	        ivec3 _868;
	        ivec3 _926 = _868;
	        _926.x = int(_923.x);
	        _926.y = int(_923.y);
	        _926.z = int(_923.z);
	        _868 = _926;
	        ivec2 _935 = ivec2(gl_LaunchIDEXT.xy) - _926.xy * (ivec2(gl_LaunchIDEXT.xy) / _926.xy);
	        uint _936 = uint(g_PushConstants.m_nEstimate_DimensionCount.y);
	        uint _956 = uint(max(1, ((g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount.w + 31) / 32)));
	        uvec3 _957 = uvec3(g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount.xyz);
	        vec3 _960 = vec3(_957) / (g_SceneGlobalInfo._member0[0].m_vLocalLightMaxBounds.xyz - g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds.xyz);
	        vec3 _962 = (-g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds.xyz) * _960;
	        uvec4 _sampled = texelFetch(g_LuxelChartIDs, ivec2(gl_LaunchIDEXT.xy), 0);
	        uint _966 = _sampled.x;
	        if (_966 == 4294967295u)
	        {
	            break;
	        }
	        vec2 _974 = (g_PushConstants.m_vLightmapOffsetAndSize.xy + vec2(gl_LaunchIDEXT.xy)) + vec2(0.5);
	        vec2 vSeed = imageLoad(g_RandomSamples, ivec3(_935.xy, 1)).xy;
	        float flReservoirWt = 0.0;
	        vec4 _516 = vec4(0.0);
	        vec4 _515 = vec4(0.0);
	        vec4 _514 = vec4(0.0);
	        vec4 _513 = vec4(0.0);
	        vec4 _512 = vec4(0.0);
	        int _511 = 0;
	        uint _510 = 0u;
	        int dy = -2;
	        bool _866;
	        bool _867;
	        bool _869;
	        bool _870;
	        for (;;)
	        {
	            if (!(dy <= 2))
	            {
	                break;
	            }
	            int dx = -2;
	            for (;;)
	            {
	                bool _994_ladder_break = false;
	                do
	                {
	                    if (!(dx <= 2))
	                    {
	                        _994_ladder_break = true;
	                        break;
	                    }
	                    uvec2 _1007 = gl_LaunchIDEXT.xy + uvec2(ivec2(dx, dy));
	                    ivec2 _1008 = ivec2(_1007);
	                    int _1009 = _1008.x;
	                    if (_1009 < 0)
	                    {
	                        _869 = true;
	                    }
	                    else
	                    {
	                        _869 = uint(_1009) >= gl_LaunchSizeEXT.x;
	                    }
	                    if (_869)
	                    {
	                        break;
	                    }
	                    int _1021 = _1008.y;
	                    if (_1021 < 0)
	                    {
	                        _870 = true;
	                    }
	                    else
	                    {
	                        _870 = uint(_1021) >= gl_LaunchSizeEXT.y;
	                    }
	                    if (_870)
	                    {
	                        break;
	                    }
	                    if (texelFetch(g_LuxelChartIDs, ivec2(_1007), 0).x != _966)
	                    {
	                        break;
	                    }
	                    uint nSample = (uint(_1021) * gl_LaunchSizeEXT.y) + uint(_1009);
	                    vec2 _509 = g_LightmapSamples_1._member0[nSample].m_vLightmapUv;
	                    if (g_LightmapSamples_1._member0[nSample].m_vPositionWs.w <= 0.0)
	                    {
	                        break;
	                    }
	                    vec2 vDx = (_509.xy * g_PushConstants.m_vLightmapOffsetAndSize.zw) - _974;
	                    float _1070 = 0.79788458347320556640625 * exp(dot(vDx, vDx) * (-2.0));
	                    float _871 = vSeed.y;
	                    do
	                    {
	                        float _1075 = flReservoirWt;
	                        float _1076 = _1075 + _1070;
	                        flReservoirWt = _1076;
	                        if (_1076 == 0.0)
	                        {
	                            _866 = false;
	                            break;
	                        }
	                        float _1081 = _1070 / flReservoirWt;
	                        do
	                        {
	                            if (_1081 <= 0.0)
	                            {
	                                _867 = false;
	                                break;
	                            }
	                            if (_1081 >= 1.0)
	                            {
	                                _867 = true;
	                                break;
	                            }
	                            if (_871 < _1081)
	                            {
	                                _871 = min(_871 / _1081, 0.99999988079071044921875);
	                                _867 = true;
	                                break;
	                            }
	                            _871 = min((_871 - _1081) / (1.0 - _1081), 0.99999988079071044921875);
	                            _867 = false;
	                            break;
	                        } while(false);
	                        _866 = _867;
	                        break;
	                    } while(false);
	                    vec2 _1106 = vSeed;
	                    _1106.y = _871;
	                    vSeed = _1106;
	                    if (_866)
	                    {
	                        _516 = g_LightmapSamples_1._member0[nSample].m_vPositionWs;
	                        _515 = g_LightmapSamples_1._member0[nSample].m_vShadingNormalWs_vTransmissiveR;
	                        _514 = g_LightmapSamples_1._member0[nSample].m_vInterpolatedNormalWs_vTransmissiveG;
	                        _513 = g_LightmapSamples_1._member0[nSample].m_vFaceNormalWs_vTransmissiveB;
	                        _512 = g_LightmapSamples_1._member0[nSample].m_vTangentWs;
	                        _511 = g_LightmapSamples_1._member0[nSample].m_nInstanceFlags;
	                        _510 = g_LightmapSamples_1._member0[nSample].m_nSampleFlags;
	                    }
	                    break;
	                } while(false);
	                if (_994_ladder_break)
	                {
	                    break;
	                }
	                dx++;
	                continue;
	            }
	            dy++;
	            continue;
	        }
	        if (!(_516.w != 0.0))
	        {
	            break;
	        }
	        vec3 _1126 = abs(_516.xyz);
	        vec3 _508 = _516.xyz + (_513.xyz * ((abs(_516.xyz) + vec3(abs(max(_1126.x, max(_1126.y, _1126.z))))) * 9.9999997473787516355514526367188e-05));
	        vec3 _1142 = abs(_516.xyz);
	        vec3 _507 = _516.xyz + ((-_513.xyz) * ((abs(_516.xyz) + vec3(abs(max(_1142.x, max(_1142.y, _1142.z))))) * 9.9999997473787516355514526367188e-05));
	        f16vec3 _348 = f16vec3(_515.xyz);
	        vec3 _506 = _513.xyz;
	        vec3 _398;
	        vec3 _872 = _398;
	        vec3 _397;
	        vec3 _873 = _397;
	        float _865;
	        if (_515.z >= 0.0)
	        {
	            _865 = 1.0;
	        }
	        else
	        {
	            _865 = -1.0;
	        }
	        float _1168 = (-1.0) / (_865 + _515.z);
	        float _1172 = (_515.x * _515.y) * _1168;
	        vec3 _1177 = _872;
	        _1177.x = 1.0 + (((_865 * _515.x) * _515.x) * _1168);
	        _1177.y = _865 * _1172;
	        _1177.z = (-_865) * _515.x;
	        _872 = _1177;
	        vec3 _1184 = _873;
	        _1184.x = _1172;
	        _1184.y = _865 + ((_515.y * _515.y) * _1168);
	        _1184.z = -_515.y;
	        _873 = _1184;
	        _398 = _1177;
	        _397 = _1184;
	        f16vec3 _346 = f16vec3(vec3(1.0));
	        int _505 = _511;
	        vec3 vTransmissiveRatio = vec3(_515.w, _514.w, _513.w);
	        vec4 _504 = vec4(0.0);
	        vec4 _503 = vec4(0.0);
	        vec4 _502 = vec4(0.0);
	        vec4 _501 = vec4(0.0);
	        vec4 _500 = vec4(0.0);
	        vec4 _499 = vec4(0.0);
	        vec4 _498 = vec4(0.0);
	        vec4 _497 = vec4(0.0);
	        vec4 _496 = vec4(0.0);
	        vec4 _495 = vec4(0.0);
	        ivec4 _494 = ivec4(255);
	        vec4 _493 = vec4(0.0);
	        vec4 _492 = vec4(0.0);
	        vec4 _491 = vec4(0.0);
	        if (all(greaterThanEqual(_516.xyz, g_PushConstants.m_vCordonMins.xyz)))
	        {
	            _869 = all(lessThanEqual(_516.xyz, g_PushConstants.m_vCordonMaxs.xyz));
	        }
	        else
	        {
	            _869 = false;
	        }
	        if (_869)
	        {
	            f16vec4 _342;
	            uint _343;
	            float16_t _344;
	            float16_t _345;
	            float16_t _347;
	            if ((_510 & 2u) != 0u)
	            {
	                f16vec3 _1232 = f16vec3(vec3(0.0));
	                vec3 _517;
	                p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _517, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_1232, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _1232, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                traceRayEXT(g_AccelStruct, 0u, 1u, 0u, 2u, 0u, _508 + (_513.xyz * 0.037500001490116119384765625), 0.0, -_513.xyz, 0.07500000298023223876953125, 0);
	                if (p.nInstance != (-1))
	                {
	                    _348 = p.material.vNormalWs;
	                    _347 = p.material.flMetalness;
	                    _346 = p.material.vAlbedo;
	                    _345 = p.material.flRoughness;
	                    _344 = p.material.flReflectance;
	                    _343 = p.material.nMaterialTypeAndFlags;
	                    _342 = p.material.vMaterialBits;
	                }
	            }
	            _510 &= 4294967292u;
	            vec4 _1263 = _492;
	            _1263.x = _514.x;
	            _1263.y = _514.y;
	            _1263.z = _514.z;
	            _492 = _1263;
	            _493 = _512;
	            vec3 _394;
	            float _395;
	            float _396;
	            ivec2 _490 = _935;
	            uint _489 = _936;
	            uint _488 = _956;
	            uvec3 _487 = _957;
	            vec3 _486 = _962;
	            vec3 _485 = _960;
	            vec3 _521 = _508;
	            vec3 _520 = _507;
	            vec3 _519 = _506;
	            int _518 = _505;
	            f16vec3 _355 = _348;
	            float16_t _354 = _347;
	            f16vec3 _353 = _346;
	            float16_t _352 = _345;
	            float16_t _351 = _344;
	            uint _350 = _343;
	            f16vec4 _349 = _342;
	            vec3 _403 = _398;
	            vec3 _402 = _397;
	            float _401 = _396;
	            float _400 = _395;
	            vec3 _399 = _394;
	            vec2 _857 = vSeed;
	            float _858;
	            if (false)
	            {
	                _858 = 0.5;
	            }
	            else
	            {
	                float _1291 = max(_515.w, max(_514.w, _513.w));
	                _858 = _1291 / (_1291 + 1.0);
	            }
	            float _859 = _857.x;
	            bool _856;
	            do
	            {
	                if (_858 <= 0.0)
	                {
	                    _856 = false;
	                    break;
	                }
	                if (_858 >= 1.0)
	                {
	                    _856 = true;
	                    break;
	                }
	                if (_859 < _858)
	                {
	                    _859 = min(_859 / _858, 0.99999988079071044921875);
	                    _856 = true;
	                    break;
	                }
	                _859 = min((_859 - _858) / (1.0 - _858), 0.99999988079071044921875);
	                _856 = false;
	                break;
	            } while(false);
	            vec2 _1319 = _857;
	            _1319.x = _859;
	            _857 = _1319;
	            if (_856)
	            {
	                _521 = _520;
	            }
	            else
	            {
	                _858 = 1.0 - _858;
	            }
	            float _1329 = sqrt(_857.y);
	            float _1331 = 6.283185482025146484375 * _857.x;
	            vec3 _1339 = vec3(cos(_1331) * _1329, sin(_1331) * _1329, sqrt(max(0.0, 1.0 - _857.y)));
	            vec3 _860 = _1339;
	            float _1342 = _858;
	            if (_856)
	            {
	                _858 = -_860.z;
	            }
	            else
	            {
	                _858 = _860.z;
	            }
	            vec3 _1353 = _860;
	            _1353.z = _858;
	            _860 = _1353;
	            vec3 _1360 = mat3(_403, _402, vec3(_355)) * _1353;
	            vec3 _845 = _1360;
	            vec3 _549 = _521;
	            vec3 _548 = _520;
	            vec3 _547 = _519;
	            int _546 = _518;
	            f16vec3 _377 = _355;
	            float16_t _376 = _354;
	            f16vec3 _375 = _353;
	            float16_t _374 = _352;
	            float16_t _373 = _351;
	            uint _372 = _350;
	            f16vec4 _371 = _349;
	            vec3 _439 = _403;
	            vec3 _438 = _402;
	            float _437 = _401;
	            float _436 = _400;
	            vec3 _435 = _399;
	            int _846 = 1;
	            vec3 _847 = vec3(1.0 / (_1342 * (_1339.z * 0.3183098733425140380859375)));
	            vec3 _848 = vec3(0.0);
	            vec3 _550;
	            vec3 _566;
	            vec3 _596;
	            bool _686;
	            float _687;
	            bool _688;
	            vec3 _689;
	            bool _690;
	            vec3 _691;
	            vec3 _692;
	            float _693;
	            float _694;
	            bool _695;
	            vec3 _696;
	            bool _697;
	            vec3 _698;
	            bool _701;
	            bool _702;
	            bool _703;
	            float _704;
	            uint _705;
	            float _706;
	            bool _707;
	            float _708;
	            bool _709;
	            bool _710;
	            float _711;
	            float _712;
	            float _713;
	            bool _714;
	            float _715;
	            bool _716;
	            vec3 _717;
	            bool _718;
	            vec3 _719;
	            vec3 _720;
	            bool _721;
	            bool _722;
	            float _723;
	            vec4 _724;
	            vec4 _725;
	            float _726;
	            vec3 _727;
	            float _728;
	            float _729;
	            bool _730;
	            float _731;
	            vec4 _732;
	            vec2 _733;
	            float _734;
	            float _735;
	            vec4 _736;
	            float _737;
	            vec3 _738;
	            vec3 _739;
	            bool _740;
	            float _741;
	            vec4 _742;
	            vec2 _743;
	            float _744;
	            float _745;
	            vec3 _747;
	            vec3 _748;
	            vec4 _750;
	            float _751;
	            float _752;
	            vec3 _753;
	            vec3 _754;
	            float _755;
	            float _756;
	            bool _757;
	            vec3 _758;
	            vec3 _759;
	            bool _760;
	            bool _761;
	            vec3 _762;
	            float _769;
	            bool _771;
	            float _772;
	            bool _773;
	            vec3 _774;
	            bool _775;
	            vec3 _776;
	            vec3 _777;
	            vec4 _778;
	            vec4 _779;
	            float _780;
	            vec3 _781;
	            float _782;
	            float _783;
	            bool _784;
	            float _785;
	            vec4 _786;
	            vec2 _787;
	            float _788;
	            float _789;
	            vec4 _790;
	            float _791;
	            vec3 _792;
	            vec3 _793;
	            bool _794;
	            float _795;
	            vec4 _796;
	            vec2 _797;
	            float _798;
	            float _799;
	            vec3 _801;
	            vec3 _802;
	            vec4 _804;
	            float _805;
	            float _806;
	            vec3 _807;
	            vec3 _808;
	            float _809;
	            float _810;
	            bool _811;
	            vec3 _812;
	            vec3 _813;
	            bool _814;
	            bool _815;
	            vec3 _816;
	            float _821;
	            bool _822;
	            bool _823;
	            bool _824;
	            vec3 _826;
	            float _828;
	            float _829;
	            bool _832;
	            float _833;
	            float _834;
	            bool _837;
	            bool _838;
	            vec3 _839;
	            bool _841;
	            vec3 _843;
	            vec3 _844;
	            vec3 _849;
	            float _850;
	            float _853;
	            vec3 _855;
	            SPIRV_CROSS_LOOP
	            for (;;)
	            {
	                if (!(_846 <= 16))
	                {
	                    break;
	                }
	                SPIRV_CROSS_FLATTEN
	                if (false)
	                {
	                    SPIRV_CROSS_FLATTEN
	                    if (_846 > (-1))
	                    {
	                        _850 = 1.0;
	                        _849 = vec3(0.0);
	                    }
	                    else
	                    {
	                        if (_846 != (-1))
	                        {
	                            _850 = 0.0;
	                        }
	                        else
	                        {
	                            _850 = 1.0;
	                        }
	                        _849 = _847;
	                    }
	                }
	                else
	                {
	                    _850 = 1.0;
	                    _849 = _847;
	                }
	                if (all(equal(_849, vec3(0.0))))
	                {
	                    break;
	                }
	                vec3 _545 = _549;
	                vec3 _544 = _845;
	                vec2 _1417 = imageLoad(g_RandomSamples, ivec3(_490.xy, int(1u + uint(_846)))).xy;
	                f16vec3 _1419 = f16vec3(vec3(0.0));
	                vec2 _1425 = _1417;
	                _1425.y = 0.0;
	                p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _550, 3.4028234663852885981170418348452e+38, _1417.y, -1, false, MaterialDataMinimal_t(_1419, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _1419, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                traceRayEXT(g_AccelStruct, 0u, 4u, 0u, 2u, 0u, _549, 0.0, _845, 56755.83984375, 0);
	                float _1459 = p.flHitT;
	                vec2 _1460 = _1417;
	                _1460.y = p.flOpacityRng;
	                vec2 _851 = _1460;
	                if (!(p.nInstance != (-1)))
	                {
	                    vec2 _1475 = imageLoad(g_RandomSamples, ivec3(_490.xy, int(1u + uint(_846 + 1)))).xy;
	                    _851 = _1475;
	                    do
	                    {
	                        vec2 _840 = _1475;
	                        if ((g_SceneGlobalInfo._member0[0].m_nSkyLightFlags & 1u) == 0u)
	                        {
	                            _839 = vec3(0.0);
	                            break;
	                        }
	                        if (_845.z < 0.0)
	                        {
	                            float _842 = _840.y;
	                            do
	                            {
	                                if (g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w <= 0.0)
	                                {
	                                    _838 = false;
	                                    break;
	                                }
	                                if (g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w >= 1.0)
	                                {
	                                    _838 = true;
	                                    break;
	                                }
	                                if (_842 < g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w)
	                                {
	                                    _842 = min(_842 / g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w, 0.99999988079071044921875);
	                                    _838 = true;
	                                    break;
	                                }
	                                _842 = min((_842 - g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w) / (1.0 - g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w), 0.99999988079071044921875);
	                                _838 = false;
	                                break;
	                            } while(false);
	                            vec2 _1520 = _840;
	                            _1520.y = _842;
	                            _840 = _1520;
	                            _841 = _838;
	                        }
	                        else
	                        {
	                            _841 = false;
	                        }
	                        if (_841)
	                        {
	                            float _1528 = sqrt(_840.y);
	                            float _1530 = 6.283185482025146484375 * _840.x;
	                            _843 = vec3(cos(_1530) * _1528, sin(_1530) * _1528, sqrt(max(0.0, 1.0 - _840.y)));
	                            _844 = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance.xyz;
	                        }
	                        else
	                        {
	                            _843 = _845;
	                            _844 = vec3(0.0);
	                        }
	                        if (g_SceneGlobalInfo._member0[0].m_nIBLCubeMap >= 0)
	                        {
	                            vec4 _1575 = textureLod(samplerCube(g_bindless_TextureCube[g_SceneGlobalInfo._member0[0].m_nIBLCubeMap], g_Sampler), normalize(g_SceneGlobalInfo._member0[0].m_mIBLTransformI * vec4(_843, 0.0)), 0.0);
	                            if (dot(_1575.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) < g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance.w)
	                            {
	                                _844 += (g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale.xyz * _1575.xyz);
	                            }
	                        }
	                        else
	                        {
	                            _844 += g_SceneGlobalInfo._member0[0].m_vSkyColor.xyz;
	                        }
	                        if (_846 > 1)
	                        {
	                            _844 *= g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale.w;
	                        }
	                        if (_841)
	                        {
	                            _844 *= g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.xyz;
	                        }
	                        _839 = _844;
	                        break;
	                    } while(false);
	                    _848 += ((_849 * _839) * _850);
	                    break;
	                }
	                uint _551 = g_instanceBuffer_1._member0[uint(p.nInstance)].nMaterialFlags_nInstanceFlags;
	                if ((int((_551 >> uint(16)) & 65535u) & 4) != 0)
	                {
	                    break;
	                }
	                vec3 _539 = _545;
	                vec3 _538 = _544;
	                vec3 _537 = p.vSmoothPositionWs;
	                vec3 _536 = p.vFaceNormalWs;
	                float _535 = p.flHitT;
	                f16vec3 _429 = p.material.vNormalWs;
	                float16_t _428 = p.material.flMetalness;
	                f16vec3 _427 = p.material.vAlbedo;
	                float16_t _426 = p.material.flRoughness;
	                f16vec3 _425 = p.material.vEmissive;
	                float16_t _424 = p.material.flReflectance;
	                uint _423 = p.material.nMaterialTypeAndFlags;
	                f16vec4 _422 = p.material.vMaterialBits;
	                uint _1627 = uint(p.nInstance);
	                uint _557 = g_instanceBuffer_1._member0[_1627].nMaterialFlags_nInstanceFlags;
	                float _556 = g_instanceBuffer_1._member0[_1627].fEmissiveBoost;
	                vec3 _555 = (_539 + (_538 * _535)) + (_536 * ((abs(_539) + vec3(abs(_535))) * 9.9999997473787516355514526367188e-05));
	                vec3 _554 = (_539 + (_538 * _535)) + ((-_536) * ((abs(_539) + vec3(abs(_535))) * 9.9999997473787516355514526367188e-05));
	                vec3 _553 = _536;
	                int _552 = int(_557 & 65535u);
	                vec3 _562 = vec3(0.0);
	                vec3 _561 = vec3(0.0);
	                float _560 = 0.0;
	                float _559 = 0.0;
	                vec3 _558 = vec3(0.0);
	                f16vec3 _452 = _429;
	                float16_t _451 = _428;
	                f16vec3 _450 = _427;
	                f16vec3 _448 = _425;
	                float16_t _447 = _424;
	                uint _446 = _423;
	                f16vec4 _445 = _422;
	                float16_t _449 = float16_t(max(float(_426), 0.07999999821186065673828125));
	                vec3 _1675 = vec3(_429);
	                vec3 _835 = vec3(0.0);
	                vec3 _836 = vec3(0.0);
	                float _1676 = _1675.z;
	                if (_1676 >= 0.0)
	                {
	                    _834 = 1.0;
	                }
	                else
	                {
	                    _834 = -1.0;
	                }
	                float _1683 = (-1.0) / (_834 + _1676);
	                float _1684 = _1675.x;
	                float _1685 = _1675.y;
	                float _1687 = (_1684 * _1685) * _1683;
	                vec3 _1692 = _835;
	                _1692.x = 1.0 + (((_834 * _1684) * _1684) * _1683);
	                _1692.y = _834 * _1687;
	                _1692.z = (-_834) * _1684;
	                _835 = _1692;
	                vec3 _1699 = _836;
	                _1699.x = _1687;
	                _1699.y = _834 + ((_1685 * _1685) * _1683);
	                _1699.z = -_1685;
	                _836 = _1699;
	                _562 = _1692;
	                _561 = _1699;
	                vec3 _1711 = transpose(mat3(_1692, _1699, vec3(_452))) * (-_538);
	                _558 = _1711;
	                vec3 _1719 = vec3(mix(f16vec3(_447), _450, f16vec3(_451)));
	                _560 = dot((_1719 + ((vec3(1.0) - _1719) * pow(max(0.0, 1.0 - _1711.z), 5.0))).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                if ((_446 & 65535u) == 1u)
	                {
	                    float _1738 = dot(vec3(_445.xyz).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                    _559 = _1738 / max(9.9999997473787516355514526367188e-05, _1738 + dot(vec3(_450).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)));
	                }
	                f16vec3 _385 = _452;
	                float16_t _384 = _451;
	                f16vec3 _383 = _450;
	                float16_t _382 = _449;
	                f16vec3 _381 = _448;
	                float16_t _380 = _447;
	                uint _379 = _446;
	                f16vec4 _378 = _445;
	                vec3 _444 = _562;
	                vec3 _443 = _561;
	                float _442 = _560;
	                float _441 = _559;
	                vec3 _440 = _558;
	                if (true)
	                {
	                    if ((_552 & 256) != 0)
	                    {
	                        _381 *= float16_t(_556);
	                    }
	                    else
	                    {
	                        _381 = f16vec3(vec3(0.0));
	                    }
	                }
	                if (true)
	                {
	                    _837 = any(notEqual(_537, vec3(3.4028234663852885981170418348452e+38)));
	                }
	                else
	                {
	                    _837 = false;
	                }
	                vec3 _1779 = _537 - _555;
	                float _1780 = length(_1779);
	                vec3 _565 = _555;
	                float _564 = 0.0;
	                vec3 _563 = vec4(_1779 / vec3(_1780), _1780).xyz;
	                if (_837)
	                {
	                    _833 = _1780;
	                }
	                else
	                {
	                    _833 = 0.0;
	                }
	                p_1 = PayloadShadow_t(1.0);
	                traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _565, _564, _563, _833, 1);
	                if (_837)
	                {
	                    _833 = p_1.m_flVisibility;
	                }
	                else
	                {
	                    _833 = 0.0;
	                }
	                if (_833 == 1.0)
	                {
	                    _555 = _537;
	                    _553 = vec3(_429);
	                }
	                vec3 _543 = _555;
	                vec3 _542 = _554;
	                vec3 _541 = _553;
	                int _540 = _552;
	                f16vec3 _370 = _385;
	                float16_t _369 = _384;
	                f16vec3 _368 = _383;
	                float16_t _367 = _382;
	                f16vec3 _366 = _381;
	                float16_t _365 = _380;
	                uint _364 = _379;
	                f16vec4 _363 = _378;
	                vec3 _434 = _444;
	                vec3 _433 = _443;
	                float _432 = _442;
	                float _431 = _441;
	                vec3 _430 = _440;
	                if (!(dot(_553, -_845) > 0.0))
	                {
	                    if ((_540 & 1024) != 0)
	                    {
	                        _541 = -_541;
	                        _370 = -_370;
	                        vec3 _2093 = _549;
	                        _549 = _548;
	                        _548 = _2093;
	                    }
	                    else
	                    {
	                        vec2 _1846 = imageLoad(g_RandomSamples, ivec3(_490.xy, int(1u + uint(_846)))).xy;
	                        f16vec3 _1848 = f16vec3(vec3(0.0));
	                        vec2 _1854 = _1846;
	                        _1854.y = 0.0;
	                        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _566, 3.4028234663852885981170418348452e+38, _1846.y, -1, false, MaterialDataMinimal_t(_1848, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _1848, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                        traceRayEXT(g_AccelStruct, 16u, 4u, 0u, 2u, 0u, _545, _1459 * 0.99989998340606689453125, _544, _1459 * 1.00010001659393310546875, 0);
	                        vec2 _1887 = _1846;
	                        _1887.y = p.flOpacityRng;
	                        _851 = _1887;
	                        if (p.nInstance != (-1))
	                        {
	                            vec3 _534 = _545;
	                            vec3 _533 = _544;
	                            vec3 _532 = p.vSmoothPositionWs;
	                            vec3 _531 = p.vFaceNormalWs;
	                            float _530 = p.flHitT;
	                            f16vec3 _421 = p.material.vNormalWs;
	                            float16_t _420 = p.material.flMetalness;
	                            f16vec3 _419 = p.material.vAlbedo;
	                            float16_t _418 = p.material.flRoughness;
	                            f16vec3 _417 = p.material.vEmissive;
	                            float16_t _416 = p.material.flReflectance;
	                            uint _415 = p.material.nMaterialTypeAndFlags;
	                            f16vec4 _414 = p.material.vMaterialBits;
	                            uint _1894 = uint(p.nInstance);
	                            uint _572 = g_instanceBuffer_1._member0[_1894].nMaterialFlags_nInstanceFlags;
	                            float _571 = g_instanceBuffer_1._member0[_1894].fEmissiveBoost;
	                            vec3 _570 = (_534 + (_533 * _530)) + (_531 * ((abs(_534) + vec3(abs(_530))) * 9.9999997473787516355514526367188e-05));
	                            vec3 _569 = (_534 + (_533 * _530)) + ((-_531) * ((abs(_534) + vec3(abs(_530))) * 9.9999997473787516355514526367188e-05));
	                            vec3 _568 = _531;
	                            int _567 = int(_572 & 65535u);
	                            vec3 _577 = vec3(0.0);
	                            vec3 _576 = vec3(0.0);
	                            float _575 = 0.0;
	                            float _574 = 0.0;
	                            vec3 _573 = vec3(0.0);
	                            f16vec3 _465 = _421;
	                            float16_t _464 = _420;
	                            f16vec3 _463 = _419;
	                            f16vec3 _461 = _417;
	                            float16_t _460 = _416;
	                            uint _459 = _415;
	                            f16vec4 _458 = _414;
	                            float16_t _462 = float16_t(max(float(_418), 0.07999999821186065673828125));
	                            vec3 _1942 = vec3(_421);
	                            vec3 _830 = vec3(0.0);
	                            vec3 _831 = vec3(0.0);
	                            float _1943 = _1942.z;
	                            if (_1943 >= 0.0)
	                            {
	                                _829 = 1.0;
	                            }
	                            else
	                            {
	                                _829 = -1.0;
	                            }
	                            float _1950 = (-1.0) / (_829 + _1943);
	                            float _1951 = _1942.x;
	                            float _1952 = _1942.y;
	                            float _1954 = (_1951 * _1952) * _1950;
	                            vec3 _1959 = _830;
	                            _1959.x = 1.0 + (((_829 * _1951) * _1951) * _1950);
	                            _1959.y = _829 * _1954;
	                            _1959.z = (-_829) * _1951;
	                            _830 = _1959;
	                            vec3 _1966 = _831;
	                            _1966.x = _1954;
	                            _1966.y = _829 + ((_1952 * _1952) * _1950);
	                            _1966.z = -_1952;
	                            _831 = _1966;
	                            _577 = _1959;
	                            _576 = _1966;
	                            vec3 _1978 = transpose(mat3(_1959, _1966, vec3(_465))) * (-_533);
	                            _573 = _1978;
	                            vec3 _1986 = vec3(mix(f16vec3(_460), _463, f16vec3(_464)));
	                            _575 = dot((_1986 + ((vec3(1.0) - _1986) * pow(max(0.0, 1.0 - _1978.z), 5.0))).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                            if ((_459 & 65535u) == 1u)
	                            {
	                                float _2005 = dot(vec3(_458.xyz).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                                _574 = _2005 / max(9.9999997473787516355514526367188e-05, _2005 + dot(vec3(_463).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)));
	                            }
	                            f16vec3 _393 = _465;
	                            float16_t _392 = _464;
	                            f16vec3 _391 = _463;
	                            float16_t _390 = _462;
	                            f16vec3 _389 = _461;
	                            float16_t _388 = _460;
	                            uint _387 = _459;
	                            f16vec4 _386 = _458;
	                            vec3 _457 = _577;
	                            vec3 _456 = _576;
	                            float _455 = _575;
	                            float _454 = _574;
	                            vec3 _453 = _573;
	                            if (true)
	                            {
	                                if ((_567 & 256) != 0)
	                                {
	                                    _389 *= float16_t(_571);
	                                }
	                                else
	                                {
	                                    _389 = f16vec3(vec3(0.0));
	                                }
	                            }
	                            if (true)
	                            {
	                                _832 = any(notEqual(_532, vec3(3.4028234663852885981170418348452e+38)));
	                            }
	                            else
	                            {
	                                _832 = false;
	                            }
	                            vec3 _2046 = _532 - _570;
	                            float _2047 = length(_2046);
	                            vec3 _580 = _570;
	                            float _579 = 0.0;
	                            vec3 _578 = vec4(_2046 / vec3(_2047), _2047).xyz;
	                            if (_832)
	                            {
	                                _828 = _2047;
	                            }
	                            else
	                            {
	                                _828 = 0.0;
	                            }
	                            p_1 = PayloadShadow_t(1.0);
	                            traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _580, _579, _578, _828, 1);
	                            if (_832)
	                            {
	                                _828 = p_1.m_flVisibility;
	                            }
	                            else
	                            {
	                                _828 = 0.0;
	                            }
	                            if (_828 == 1.0)
	                            {
	                                _570 = _532;
	                                _568 = vec3(_421);
	                            }
	                            _543 = _570;
	                            _542 = _569;
	                            _541 = _568;
	                            _540 = _567;
	                            _370 = _393;
	                            _369 = _392;
	                            _368 = _391;
	                            _367 = _390;
	                            _366 = _389;
	                            _365 = _388;
	                            _364 = _387;
	                            _363 = _386;
	                            _434 = _457;
	                            _433 = _456;
	                            _432 = _455;
	                            _431 = _454;
	                            _430 = _453;
	                        }
	                        else
	                        {
	                            break;
	                        }
	                    }
	                }
	                vec3 _529 = _543;
	                vec3 _528 = _542;
	                vec3 _527 = _541;
	                f16vec3 _362 = _370;
	                float16_t _361 = _369;
	                f16vec3 _360 = _368;
	                float16_t _359 = _367;
	                float16_t _358 = _365;
	                uint _357 = _364;
	                f16vec4 _356 = _363;
	                vec3 _413 = _434;
	                vec3 _412 = _433;
	                vec3 _411 = _430;
	                vec3 _2110 = (_543 + _542) * 0.5;
	                bool _2111 = _846 != 0;
	                f16vec4 _582 = _363;
	                if ((_364 & 65535u) == 1u)
	                {
	                    _823 = any(greaterThan(vec3(_582.xyz), vec3(0.0)));
	                }
	                else
	                {
	                    _823 = false;
	                }
	                if (_823)
	                {
	                    _824 = true;
	                }
	                else
	                {
	                    f16vec4 _581 = _356;
	                    if ((_357 & 65535u) == 2u)
	                    {
	                        _822 = float(_581.x) > 0.0;
	                    }
	                    else
	                    {
	                        _822 = false;
	                    }
	                    _824 = _822;
	                }
	                vec2 _2149 = imageLoad(g_RandomSamples, ivec3(_490.xy, int(1u + ((2u * _489) + uint(_846))))).xy;
	                bool _825 = false;
	                vec3 _2162 = (_529 + _528) * 0.5;
	                uvec3 _2170 = min(uvec3(max(fma(_2162, _485, _486), vec3(0.0))), (_487 - uvec3(1u)));
	                uint _817 = 0u;
	                vec3 _818 = vec3(0.0);
	                for (;;)
	                {
	                    if (!(_817 < _488))
	                    {
	                        break;
	                    }
	                    uint _2186 = _488 * _487.x;
	                    uint _819 = subgroupOr(g_LightBins_1._member0[((((_2186 * _487.y) * _2170.z) + (_2186 * _2170.y)) + (_488 * _2170.x)) + _817]);
	                    vec3 _820 = _818;
	                    for (;;)
	                    {
	                        if (!(_819 != 0u))
	                        {
	                            break;
	                        }
	                        uint _2210 = _819;
	                        uint _2214 = uint(findLSB(_2210)) + (_817 * 32u);
	                        uint _2216 = _2210 & (_2210 - 1u);
	                        if ((uint(g_Lights_1._member0[_2214].m_nPathTraceFlags) & 1u) == 0u)
	                        {
	                            _819 = _2216;
	                            continue;
	                        }
	                        if ((g_Lights_1._member0[_2214].m_nPathTraceFlags & 8) != 0)
	                        {
	                            _825 = true;
	                            _819 = _2216;
	                            continue;
	                        }
	                        do
	                        {
	                            do
	                            {
	                                vec4 _2242 = g_Lights_1._member0[_2214].m_mToClipSpace * vec4(_2162.xyz, 1.0);
	                                vec3 _2246 = _2242.xyz / vec3(_2242.w);
	                                vec4 _2248;
	                                _2248.x = _2246.x;
	                                _2248.y = _2246.y;
	                                _2248.z = _2246.z;
	                                if (all(greaterThanEqual(_2248.xyz, vec3(-1.0, -1.0, 0.0))))
	                                {
	                                    _814 = all(lessThanEqual(_2248.xyz, vec3(1.0)));
	                                }
	                                else
	                                {
	                                    _814 = false;
	                                }
	                                if (!_814)
	                                {
	                                    _815 = false;
	                                    break;
	                                }
	                                if (!all(lessThanEqual(abs((g_Lights_1._member0[_2214].m_mBarnIlluminationFromWorld * vec4(_2162, 1.0)).xyz), vec3(1.0))))
	                                {
	                                    _815 = false;
	                                    break;
	                                }
	                                _815 = true;
	                                break;
	                            } while(false);
	                            if (!_815)
	                            {
	                                _816 = vec3(0.0);
	                                break;
	                            }
	                            vec4 _2285 = g_Lights_1._member0[_2214].m_mToClipSpace * vec4(_2162.xyz, 1.0);
	                            vec3 _2289 = _2285.xyz / vec3(_2285.w);
	                            vec4 _2291;
	                            _2291.x = _2289.x;
	                            _2291.y = _2289.y;
	                            _2291.z = _2289.z;
	                            if (_2111)
	                            {
	                                _813 = g_Lights_1._member0[_2214].m_vBounceColor.xyz;
	                            }
	                            else
	                            {
	                                _813 = g_Lights_1._member0[_2214].m_vColor.xyz;
	                            }
	                            if (true)
	                            {
	                                if (g_Lights_1._member0[_2214].m_nCookie >= 0)
	                                {
	                                    if (g_Lights_1._member0[_2214].m_bSphericalCookie != 0)
	                                    {
	                                        vec4 _2349 = vec4(-g_Lights_1._member0[_2214].m_vOrientation.xyz, g_Lights_1._member0[_2214].m_vOrientation.w);
	                                        vec4 _2351 = _2349.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                                        vec3 _2354 = _2351.xyz;
	                                        vec3 _2355 = vec4((-normalize(g_Lights_1._member0[_2214].m_vLightPosition.xyz - _2162)).xyz, 0.0).xyz;
	                                        vec4 _2362 = vec4((_2355 * _2351.w) + cross(_2355, _2354), -dot(_2355, _2354));
	                                        vec3 _2363 = _2362.xyz;
	                                        float _2364 = _2349.w;
	                                        vec3 _2366 = _2349.xyz;
	                                        float _2367 = _2362.w;
	                                        vec3 _2375 = vec4(((_2363 * _2364) + (_2366 * _2367)) + cross(_2366, _2363), _337).xyz;
	                                        vec2 _2384 = vec2(atan(_2375.y, -_2375.x) * 0.15915493667125701904296875, acos(_2375.z) * 0.3183098733425140380859375);
	                                        vec2 _2391 = (_2384.xy * g_Lights_1._member0[_2214].m_vCookieParameters.zw) + g_Lights_1._member0[_2214].m_vCookieParameters.xy;
	                                        vec2 _2393 = _2384;
	                                        _2393.x = _2391.x;
	                                        _2393.y = _2391.y;
	                                        _812 = textureLod(nonuniformEXT(sampler2D(g_bindless_Texture2D[g_Lights_1._member0[_2214].m_nCookie], g_Sampler)), _2393, 0.0).xyz;
	                                    }
	                                    else
	                                    {
	                                        vec2 _2322 = fma(_2291.xyz.xy, vec2(0.5, -0.5), vec2(0.5));
	                                        vec2 _2329 = (_2322.xy * g_Lights_1._member0[_2214].m_vCookieParameters.zw) + g_Lights_1._member0[_2214].m_vCookieParameters.xy;
	                                        vec2 _2331 = _2322;
	                                        _2331.x = _2329.x;
	                                        _2331.y = _2329.y;
	                                        _812 = textureLod(nonuniformEXT(sampler2D(g_bindless_Texture2D[g_Lights_1._member0[_2214].m_nCookie], g_CookieSampler)), _2331, 0.0).xyz;
	                                    }
	                                }
	                                else
	                                {
	                                    _812 = vec3(1.0);
	                                }
	                                _813 *= _812;
	                            }
	                            if (g_Lights_1._member0[_2214].m_nLuminaireType != 0)
	                            {
	                                _813 = (_813 * g_Lights_1._member0[_2214].m_vLuminaireVectors.data[0].w) * 0.3183098733425140380859375;
	                            }
	                            else
	                            {
	                                if (!(g_Lights_1._member0[_2214].m_vLightPosition.w == 0.0))
	                                {
	                                    vec3 _2420 = g_Lights_1._member0[_2214].m_vLightPosition.xyz - _2162;
	                                    _813 *= (vec3(g_Lights_1._member0[_2214].m_vLightPosition.w) / max(vec3(dot(_2420, _2420)), vec3(g_Lights_1._member0[_2214].m_vLightPosition.w)));
	                                }
	                            }
	                            if (g_Lights_1._member0[_2214].m_vDistanceFade_vSkirt.z > 0.0)
	                            {
	                                _809 = smoothstep(0.0, 1.0, _2291.xyz.z * g_Lights_1._member0[_2214].m_vDistanceFade_vSkirt.z);
	                            }
	                            else
	                            {
	                                _809 = 1.0;
	                            }
	                            if (g_Lights_1._member0[_2214].m_vDistanceFade_vSkirt.w > 0.0)
	                            {
	                                _809 *= smoothstep(0.0, 1.0, (1.0 - _2291.xyz.z) * g_Lights_1._member0[_2214].m_vDistanceFade_vSkirt.w);
	                            }
	                            if (!(g_Lights_1._member0[_2214].m_vLightPosition.w == 0.0))
	                            {
	                                vec3 _2474 = g_Lights_1._member0[_2214].m_vLightPosition.xyz - _2162;
	                                float _2475 = length(_2474);
	                                vec3 _2477 = _2474 / vec3(_2475);
	                                float _2486 = _809 * smoothstep(0.0, 1.0, g_Lights_1._member0[_2214].m_vDistanceFade_vSkirt.x + (g_Lights_1._member0[_2214].m_vDistanceFade_vSkirt.y * _2475));
	                                if (g_Lights_1._member0[_2214].m_nLuminaireType != 2)
	                                {
	                                    _811 = g_Lights_1._member0[_2214].m_nLuminaireType != 1;
	                                }
	                                else
	                                {
	                                    _811 = false;
	                                }
	                                if (_811)
	                                {
	                                    float _2505 = 2.0 * g_Lights_1._member0[_2214].m_vOrientation.x;
	                                    float _2509 = 2.0 * g_Lights_1._member0[_2214].m_vOrientation.w;
	                                    vec3 _2523 = vec3((_2505 * g_Lights_1._member0[_2214].m_vOrientation.y) - (_2509 * g_Lights_1._member0[_2214].m_vOrientation.z), (1.0 - (_2505 * g_Lights_1._member0[_2214].m_vOrientation.x)) - ((2.0 * g_Lights_1._member0[_2214].m_vOrientation.z) * g_Lights_1._member0[_2214].m_vOrientation.z), ((2.0 * g_Lights_1._member0[_2214].m_vOrientation.y) * g_Lights_1._member0[_2214].m_vOrientation.z) + (_2509 * g_Lights_1._member0[_2214].m_vOrientation.x)) * g_Lights_1._member0[_2214].m_vAngleFade.z;
	                                    vec3 _2524 = _2477 - _2523;
	                                    vec3 _2525 = _2477 + _2523;
	                                    do
	                                    {
	                                        vec3 _2528 = _2525 - _2524;
	                                        float _2530 = dot(-_2524, _2528);
	                                        if (_2530 <= 0.0)
	                                        {
	                                            _807 = _2524;
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            float _2535 = dot(_2528, _2528);
	                                            if (_2530 > _2535)
	                                            {
	                                                _807 = _2525;
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                _807 = _2524 + (_2528 * (_2530 / _2535));
	                                                break;
	                                            }
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    if (any(notEqual(_807, vec3(0.0))))
	                                    {
	                                        _808 = normalize(_807);
	                                    }
	                                    else
	                                    {
	                                        _808 = _807;
	                                    }
	                                    float _2559 = 2.0 * g_Lights_1._member0[_2214].m_vOrientation.x;
	                                    float _2562 = 2.0 * g_Lights_1._member0[_2214].m_vOrientation.w;
	                                    _810 = _2486 * saturate(g_Lights_1._member0[_2214].m_vAngleFade.x + (g_Lights_1._member0[_2214].m_vAngleFade.y * dot(vec3((1.0 - ((2.0 * g_Lights_1._member0[_2214].m_vOrientation.y) * g_Lights_1._member0[_2214].m_vOrientation.y)) - ((2.0 * g_Lights_1._member0[_2214].m_vOrientation.z) * g_Lights_1._member0[_2214].m_vOrientation.z), (_2559 * g_Lights_1._member0[_2214].m_vOrientation.y) + (_2562 * g_Lights_1._member0[_2214].m_vOrientation.z), (_2559 * g_Lights_1._member0[_2214].m_vOrientation.z) - (_2562 * g_Lights_1._member0[_2214].m_vOrientation.y)), _808)));
	                                }
	                                else
	                                {
	                                    _810 = _2486;
	                                }
	                            }
	                            else
	                            {
	                                _810 = _809;
	                            }
	                            if (g_Lights_1._member0[_2214].m_nCookie == (-1))
	                            {
	                                do
	                                {
	                                    vec2 _2591 = abs(_2291.xyz.xy);
	                                    if (g_Lights_1._member0[_2214].m_vCookieParameters.z == 0.0)
	                                    {
	                                        _805 = smoothstep(1.0, g_Lights_1._member0[_2214].m_vCookieParameters.x, _2591.x) * smoothstep(1.0, g_Lights_1._member0[_2214].m_vCookieParameters.y, _2591.y);
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        float _2596 = _2591.x;
	                                        float _2600 = _2591.y;
	                                        float _2607 = (-0.5) * g_Lights_1._member0[_2214].m_vCookieParameters.z;
	                                        float _2609 = (g_Lights_1._member0[_2214].m_vCookieParameters.x * g_Lights_1._member0[_2214].m_vCookieParameters.y) * pow(max(pow(g_Lights_1._member0[_2214].m_vCookieParameters.y * _2596, 2.0 / g_Lights_1._member0[_2214].m_vCookieParameters.z) + pow(g_Lights_1._member0[_2214].m_vCookieParameters.x * _2600, 2.0 / g_Lights_1._member0[_2214].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _2607);
	                                        float _2616 = pow(max(pow(_2596, 2.0 / g_Lights_1._member0[_2214].m_vCookieParameters.z) + pow(_2600, 2.0 / g_Lights_1._member0[_2214].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _2607);
	                                        if (_2609 < _2616)
	                                        {
	                                            _805 = smoothstep(_2616, _2609, 1.0);
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            if (_2616 > 1.0)
	                                            {
	                                                _806 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _806 = 0.0;
	                                            }
	                                            _805 = _806;
	                                            break;
	                                        }
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                _810 *= _805;
	                            }
	                            _816 = _813 * _810;
	                            break;
	                        } while(false);
	                        SPIRV_CROSS_BRANCH
	                        if (any(greaterThan(_816, vec3(0.0))))
	                        {
	                            _803 = false;
	                            do
	                            {
	                                switch (g_Lights_1._member0[_2214].m_nLuminaireType)
	                                {
	                                    case 0:
	                                    {
	                                        _821 = 1.0;
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_2214].m_vLightPosition.w == 0.0)
	                                            {
	                                                _778 = vec4(normalize(g_Lights_1._member0[_2214].m_vLightPosition.xyz), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _3164 = g_Lights_1._member0[_2214].m_vLightPosition.xyz - _2162;
	                                                float _3165 = length(_3164);
	                                                _778 = vec4(_3164 / vec3(_3165), _3165);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _803 = true;
	                                        _804 = _778;
	                                        break;
	                                    }
	                                    case 1:
	                                    {
	                                        vec3 _3004 = g_Lights_1._member0[_2214].m_vLuminaireVectors.data[1].xyz - g_Lights_1._member0[_2214].m_vLuminaireVectors.data[0].xyz;
	                                        vec3 _3008 = g_Lights_1._member0[_2214].m_vLuminaireVectors.data[2].xyz - g_Lights_1._member0[_2214].m_vLuminaireVectors.data[0].xyz;
	                                        float _3009 = length(_3004);
	                                        float _3010 = length(_3008);
	                                        vec3 _3012 = _3004 / vec3(_3009);
	                                        vec3 _3014 = _3008 / vec3(_3010);
	                                        vec3 _3015 = cross(_3012, _3014);
	                                        vec3 _3016 = g_Lights_1._member0[_2214].m_vLuminaireVectors.data[0].xyz - _2162;
	                                        float _3017 = dot(_3016, _3015);
	                                        if (_3017 > 0.0)
	                                        {
	                                            _780 = _3017 * (-1.0);
	                                            _781 = _3015 * (-1.0);
	                                        }
	                                        else
	                                        {
	                                            _780 = _3017;
	                                            _781 = _3015;
	                                        }
	                                        float _3026 = dot(_3016, _3012);
	                                        float _3027 = dot(_3016, _3014);
	                                        float _3028 = _3026 + _3009;
	                                        float _3029 = _3027 + _3010;
	                                        vec3 _3032 = vec3(_3026, _3027, _780);
	                                        vec3 _3033 = vec3(_3026, _3029, _780);
	                                        vec3 _3034 = vec3(_3028, _3027, _780);
	                                        vec3 _3035 = vec3(_3028, _3029, _780);
	                                        vec3 _3037 = normalize(cross(_3032, _3034));
	                                        vec3 _3039 = normalize(cross(_3034, _3035));
	                                        vec3 _3041 = normalize(cross(_3035, _3033));
	                                        vec3 _3043 = normalize(cross(_3033, _3032));
	                                        float _3060 = _3037.z;
	                                        float _3064 = (6.283185482025146484375 - acos(clamp(-dot(_3041, _3043), -1.0, 1.0))) - acos(clamp(-dot(_3043, _3037), -1.0, 1.0));
	                                        float _3066 = (acos(clamp(-dot(_3037, _3039), -1.0, 1.0)) + acos(clamp(-dot(_3039, _3041), -1.0, 1.0))) - _3064;
	                                        if (isnan(_3066))
	                                        {
	                                            _782 = 0.0;
	                                        }
	                                        else
	                                        {
	                                            _782 = _3066;
	                                        }
	                                        float _3074 = (_2149.x * _782) + _3064;
	                                        float _3079 = ((cos(_3074) * _3060) - _3041.z) / sin(_3074);
	                                        if (_3079 > 0.0)
	                                        {
	                                            _783 = 1.0;
	                                        }
	                                        else
	                                        {
	                                            _783 = -1.0;
	                                        }
	                                        float _3088 = _783;
	                                        float _3090 = clamp((1.0 / sqrt((_3079 * _3079) + (_3060 * _3060))) * _3088, -1.0, 1.0);
	                                        float _3098 = clamp((-(_3090 * _780)) / sqrt(1.0 - (_3090 * _3090)), _3026, _3028);
	                                        float _3101 = sqrt((_3098 * _3098) + (_780 * _780));
	                                        float _3102 = _3101 * _3101;
	                                        float _3105 = _3027 / sqrt(_3102 + (_3027 * _3027));
	                                        float _3112 = _3105 + (_2149.y * ((_3029 / sqrt(_3102 + (_3029 * _3029))) - _3105));
	                                        float _3113 = _3112 * _3112;
	                                        if (_3113 < 0.99999988079071044921875)
	                                        {
	                                            _783 = (_3112 * _3101) / sqrt(1.0 - _3113);
	                                        }
	                                        else
	                                        {
	                                            _783 = _3029;
	                                        }
	                                        vec3 _3130 = ((_2162 + (_3012 * _3098)) + (_3014 * _783)) + (_781 * _780);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_2214].m_vLightPosition.w == 0.0)
	                                            {
	                                                _779 = vec4(normalize(_3130), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _3141 = _3130 - _2162;
	                                                float _3142 = length(_3141);
	                                                _779 = vec4(_3141 / vec3(_3142), _3142);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _821 = 1.0 / _782;
	                                        _803 = true;
	                                        _804 = _779;
	                                        break;
	                                    }
	                                    case 2:
	                                    {
	                                        do
	                                        {
	                                            vec2 _2912 = (_2149 * 2.0) - vec2(1.0);
	                                            if (all(equal(_2912, vec2(0.0))))
	                                            {
	                                                _787 = vec2(0.0);
	                                                break;
	                                            }
	                                            float _2917 = _2912.x;
	                                            float _2919 = _2912.y;
	                                            if (abs(_2917) > abs(_2919))
	                                            {
	                                                _788 = _2917;
	                                                _789 = 0.785398185253143310546875 * (_2919 / _2917);
	                                            }
	                                            else
	                                            {
	                                                _788 = _2919;
	                                                _789 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_2917 / _2919));
	                                            }
	                                            _787 = vec2(cos(_789), sin(_789)) * _788;
	                                            break;
	                                        } while(false);
	                                        vec3 _2953 = (g_Lights_1._member0[_2214].m_vLuminaireVectors.data[0].xyz + (g_Lights_1._member0[_2214].m_vLuminaireVectors.data[1].xyz * _787.x)) + (g_Lights_1._member0[_2214].m_vLuminaireVectors.data[2].xyz * _787.y);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_2214].m_vLightPosition.w == 0.0)
	                                            {
	                                                _786 = vec4(normalize(_2953), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _2964 = _2953 - _2162;
	                                                float _2965 = length(_2964);
	                                                _786 = vec4(_2964 / vec3(_2965), _2965);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (isinf(_786.w))
	                                        {
	                                            _784 = true;
	                                        }
	                                        else
	                                        {
	                                            _784 = isnan(_786.w);
	                                        }
	                                        if (!_784)
	                                        {
	                                            _785 = _786.w * _786.w;
	                                        }
	                                        else
	                                        {
	                                            _785 = 1.0;
	                                        }
	                                        _821 = _785 / (max(0.0, dot(g_Lights_1._member0[_2214].m_vLuminaireVectors.data[3].xyz, -_786.xyz)) * g_Lights_1._member0[_2214].m_vLuminaireVectors.data[1].w);
	                                        _803 = true;
	                                        _804 = _786;
	                                        break;
	                                    }
	                                    case 3:
	                                    {
	                                        vec3 _2807 = g_Lights_1._member0[_2214].m_vLuminaireVectors.data[0].xyz - _2162;
	                                        float _2808 = dot(_2807, _2807);
	                                        float _2809 = sqrt(_2808);
	                                        vec3 _2811 = _2807 / vec3(_2809);
	                                        float _2812 = _2811.z;
	                                        if (_2812 >= 0.0)
	                                        {
	                                            _791 = 1.0;
	                                        }
	                                        else
	                                        {
	                                            _791 = -1.0;
	                                        }
	                                        float _2819 = (-1.0) / (_791 + _2812);
	                                        float _2820 = _2811.x;
	                                        float _2821 = _2811.y;
	                                        float _2823 = (_2820 * _2821) * _2819;
	                                        vec3 _2828 = _792;
	                                        _2828.x = 1.0 + (((_791 * _2820) * _2820) * _2819);
	                                        _2828.y = _791 * _2823;
	                                        _2828.z = (-_791) * _2820;
	                                        _792 = _2828;
	                                        vec3 _2835 = _793;
	                                        _2835.x = _2823;
	                                        _2835.y = _791 + ((_2821 * _2821) * _2819);
	                                        _2835.z = -_2821;
	                                        _793 = _2835;
	                                        float _2843 = g_Lights_1._member0[_2214].m_vLuminaireVectors.data[1].x * g_Lights_1._member0[_2214].m_vLuminaireVectors.data[1].x;
	                                        float _2847 = sqrt(max(0.0, 1.0 - (_2843 / _2808)));
	                                        float _2848 = _2149.x;
	                                        float _2851 = (1.0 - _2848) + (_2848 * _2847);
	                                        float _2855 = sqrt(max(0.0, 1.0 - (_2851 * _2851)));
	                                        float _2857 = _2149.y * 6.283185482025146484375;
	                                        float _2859 = _2809 * _2809;
	                                        float _2865 = (_2809 * _2851) - sqrt(max(0.0, _2843 - ((_2859 * _2855) * _2855)));
	                                        float _2871 = ((_2859 + _2843) - (_2865 * _2865)) / ((2.0 * _2809) * g_Lights_1._member0[_2214].m_vLuminaireVectors.data[1].x);
	                                        float _2875 = sqrt(max(0.0, 1.0 - (_2871 * _2871)));
	                                        vec3 _2887 = g_Lights_1._member0[_2214].m_vLuminaireVectors.data[0].xyz + ((mat3(-_2828, -_2835, -_2811) * vec3(cos(_2857) * _2875, sin(_2857) * _2875, _2871)) * g_Lights_1._member0[_2214].m_vLuminaireVectors.data[1].x);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_2214].m_vLightPosition.w == 0.0)
	                                            {
	                                                _790 = vec4(normalize(_2887), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _2898 = _2887 - _2162;
	                                                float _2899 = length(_2898);
	                                                _790 = vec4(_2898 / vec3(_2899), _2899);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _821 = 0.15915493667125701904296875 / (1.0 - _2847);
	                                        _803 = true;
	                                        _804 = _790;
	                                        break;
	                                    }
	                                    case 4:
	                                    case 5:
	                                    {
	                                        vec2 _800 = _2149;
	                                        if (_2149.x < g_Lights_1._member0[_2214].m_vLuminaireVectors.data[4].y)
	                                        {
	                                            vec2 _2698 = _800;
	                                            _2698.x = clamp(_2698.x / g_Lights_1._member0[_2214].m_vLuminaireVectors.data[4].y, 0.0, 0.99999988079071044921875);
	                                            _800 = _2698;
	                                            vec3 _2704 = normalize(g_Lights_1._member0[_2214].m_vLuminaireVectors.data[0].xyz - g_Lights_1._member0[_2214].m_vLuminaireVectors.data[1].xyz);
	                                            if (_2698.x >= 0.5)
	                                            {
	                                                vec2 _2715 = _800;
	                                                _2715.x = clamp((2.0 * _2715.x) - 1.0, 0.0, 0.99999988079071044921875);
	                                                _800 = _2715;
	                                                _801 = -_2704;
	                                                _802 = g_Lights_1._member0[_2214].m_vLuminaireVectors.data[1].xyz;
	                                            }
	                                            else
	                                            {
	                                                vec2 _2710 = _800;
	                                                _2710.x = clamp(2.0 * _2710.x, 0.0, 0.99999988079071044921875);
	                                                _800 = _2710;
	                                                _801 = _2704;
	                                                _802 = g_Lights_1._member0[_2214].m_vLuminaireVectors.data[0].xyz;
	                                            }
	                                            do
	                                            {
	                                                vec2 _2726 = (_800 * 2.0) - vec2(1.0);
	                                                if (all(equal(_2726, vec2(0.0))))
	                                                {
	                                                    _797 = vec2(0.0);
	                                                    break;
	                                                }
	                                                float _2731 = _2726.x;
	                                                float _2733 = _2726.y;
	                                                if (abs(_2731) > abs(_2733))
	                                                {
	                                                    _798 = _2731;
	                                                    _799 = 0.785398185253143310546875 * (_2733 / _2731);
	                                                }
	                                                else
	                                                {
	                                                    _798 = _2733;
	                                                    _799 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_2731 / _2733));
	                                                }
	                                                _797 = vec2(cos(_799), sin(_799)) * _798;
	                                                break;
	                                            } while(false);
	                                            _802 += ((g_Lights_1._member0[_2214].m_vLuminaireVectors.data[2].xyz * _797.x) + (g_Lights_1._member0[_2214].m_vLuminaireVectors.data[3].xyz * _797.y));
	                                        }
	                                        else
	                                        {
	                                            vec2 _2677 = _800;
	                                            _2677.x = clamp((_2677.x - g_Lights_1._member0[_2214].m_vLuminaireVectors.data[4].y) / (1.0 - g_Lights_1._member0[_2214].m_vLuminaireVectors.data[4].y), 0.0, 0.99999988079071044921875);
	                                            _800 = _2677;
	                                            vec3 _2692 = (g_Lights_1._member0[_2214].m_vLuminaireVectors.data[2].xyz * cos(_2677.x * 6.283185482025146484375)) + (g_Lights_1._member0[_2214].m_vLuminaireVectors.data[3].xyz * sin(_2677.x * 6.283185482025146484375));
	                                            _801 = normalize(_2692);
	                                            _802 = mix(g_Lights_1._member0[_2214].m_vLuminaireVectors.data[0].xyz, g_Lights_1._member0[_2214].m_vLuminaireVectors.data[1].xyz, vec3(_2677.y)) + _2692;
	                                        }
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_2214].m_vLightPosition.w == 0.0)
	                                            {
	                                                _796 = vec4(normalize(_802), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _2769 = _802 - _2162;
	                                                float _2770 = length(_2769);
	                                                _796 = vec4(_2769 / vec3(_2770), _2770);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (isinf(_796.w))
	                                        {
	                                            _794 = true;
	                                        }
	                                        else
	                                        {
	                                            _794 = isnan(_796.w);
	                                        }
	                                        if (!_794)
	                                        {
	                                            _795 = _796.w * _796.w;
	                                        }
	                                        else
	                                        {
	                                            _795 = 1.0;
	                                        }
	                                        _821 = _795 / (max(0.0, dot(_801, -_796.xyz)) * g_Lights_1._member0[_2214].m_vLuminaireVectors.data[1].w);
	                                        _803 = true;
	                                        _804 = _796;
	                                        break;
	                                    }
	                                    default:
	                                    {
	                                        _821 = 0.0;
	                                        _803 = true;
	                                        _804 = vec4(uintBitsToFloat(0x7fc00000u /* nan */));
	                                        break;
	                                    }
	                                }
	                                if (_803)
	                                {
	                                    break;
	                                }
	                                break;
	                            } while(false);
	                            bool _3182 = !(dot(_527, _804.xyz) > 0.0);
	                            vec3 _3184 = vec3(_362);
	                            vec3 _3189 = transpose(mat3(_413, _412, _3184)) * _804.xyz;
	                            float16_t _471 = _361;
	                            f16vec3 _470 = _360;
	                            float16_t _469 = _359;
	                            float16_t _468 = _358;
	                            uint _467 = _357;
	                            f16vec4 _466 = _356;
	                            vec3 _583 = _411;
	                            do
	                            {
	                                if (_3182)
	                                {
	                                    f16vec4 _584 = _466;
	                                    if ((_467 & 65535u) == 1u)
	                                    {
	                                        _773 = any(greaterThan(vec3(_584.xyz), vec3(0.0)));
	                                    }
	                                    else
	                                    {
	                                        _773 = false;
	                                    }
	                                    if (_773)
	                                    {
	                                        _777 = vec3(_466.xyz);
	                                    }
	                                    else
	                                    {
	                                        _777 = vec3(1.0);
	                                    }
	                                    _776 = _777 * 0.3183098733425140380859375;
	                                    break;
	                                }
	                                else
	                                {
	                                    vec3 _3209 = vec3(mix(f16vec3(_468), _470, f16vec3(_471)));
	                                    float _3211 = float(_469);
	                                    do
	                                    {
	                                        float _3214 = _3189.z;
	                                        vec3 _3216 = _3189 + _583;
	                                        if (_3214 <= 0.0)
	                                        {
	                                            _775 = true;
	                                        }
	                                        else
	                                        {
	                                            _775 = _583.z <= 0.0;
	                                        }
	                                        if (_775)
	                                        {
	                                            _774 = vec3(0.0);
	                                            break;
	                                        }
	                                        if (all(equal(_3216, vec3(0.0))))
	                                        {
	                                            _774 = vec3(0.0);
	                                            break;
	                                        }
	                                        vec3 _3229 = normalize(_3216);
	                                        float _3230 = _3229.z;
	                                        float _3238 = _3211 * _3211;
	                                        float _3239 = _3238 * _3238;
	                                        float _3243 = (((_3230 * _3239) - _3230) * _3230) + 1.0;
	                                        float _3247 = _3211 * _3211;
	                                        float _3248 = _3247 * _3247;
	                                        _774 = (_3209 + ((vec3(1.0) - _3209) * pow(max(0.0, 1.0 - dot(_3189, _3229)), 5.0))) * (((_3239 / max(9.9999999392252902907785028219223e-09, _3243 * _3243)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_3214 * sqrt(((_583.z - (_3248 * _583.z)) * _583.z) + _3248)) + (_583.z * sqrt(((_3214 - (_3248 * _3214)) * _3214) + _3248))))) * 0.3183098733425140380859375);
	                                        break;
	                                    } while(false);
	                                    _776 = ((vec3(_470) * (1.0 - float(_471))) * 0.3183098733425140380859375) + _774;
	                                    break;
	                                }
	                                break;
	                            } while(false);
	                            float _3300 = dot(_3184, _804.xyz);
	                            if (_3182)
	                            {
	                                _772 = -_3300;
	                            }
	                            else
	                            {
	                                _772 = _3300;
	                            }
	                            _820 += (((_816 / vec3(_821)) * (_776 * 3.1415927410125732421875)) * max(0.0, _772));
	                        }
	                        _819 = _2216;
	                        continue;
	                    }
	                    _817++;
	                    _818 = _820;
	                    continue;
	                }
	                if (_825)
	                {
	                    vec2 _763 = imageLoad(g_RandomSamples, ivec3(_490.xy, int(1u + (_489 + uint(_846))))).xy;
	                    vec3 _3324 = (_529 + _528) * 0.5;
	                    float _764 = 0.0;
	                    vec3 _589 = vec3(0.0);
	                    vec3 _588 = vec3(0.0);
	                    vec4 _587 = vec4(0.0);
	                    int _590 = -1;
	                    uvec3 _3332 = min(uvec3(max(fma(_3324, _485, _486), vec3(0.0))), (_487 - uvec3(1u)));
	                    float _765 = 0.0;
	                    uint _766 = 0u;
	                    for (;;)
	                    {
	                        if (!(_766 < _488))
	                        {
	                            break;
	                        }
	                        uint _3348 = _488 * _487.x;
	                        float _767 = _765;
	                        uint _768 = subgroupOr(g_LightBins_1._member0[((((_3348 * _487.y) * _3332.z) + (_3348 * _3332.y)) + (_488 * _3332.x)) + _766]);
	                        for (;;)
	                        {
	                            if (!(_768 != 0u))
	                            {
	                                break;
	                            }
	                            uint _3372 = _768;
	                            uint _3376 = uint(findLSB(_3372)) + (_766 * 32u);
	                            uint _3378 = _3372 & (_3372 - 1u);
	                            if ((uint(g_Lights_1._member0[_3376].m_nPathTraceFlags) & 1u) == 0u)
	                            {
	                                _768 = _3378;
	                                continue;
	                            }
	                            if (!((g_Lights_1._member0[_3376].m_nPathTraceFlags & 8) != 0))
	                            {
	                                _768 = _3378;
	                                continue;
	                            }
	                            do
	                            {
	                                do
	                                {
	                                    vec4 _3405 = g_Lights_1._member0[_3376].m_mToClipSpace * vec4(_3324.xyz, 1.0);
	                                    vec3 _3409 = _3405.xyz / vec3(_3405.w);
	                                    vec4 _3411;
	                                    _3411.x = _3409.x;
	                                    _3411.y = _3409.y;
	                                    _3411.z = _3409.z;
	                                    if (all(greaterThanEqual(_3411.xyz, vec3(-1.0, -1.0, 0.0))))
	                                    {
	                                        _760 = all(lessThanEqual(_3411.xyz, vec3(1.0)));
	                                    }
	                                    else
	                                    {
	                                        _760 = false;
	                                    }
	                                    if (!_760)
	                                    {
	                                        _761 = false;
	                                        break;
	                                    }
	                                    if (!all(lessThanEqual(abs((g_Lights_1._member0[_3376].m_mBarnIlluminationFromWorld * vec4(_3324, 1.0)).xyz), vec3(1.0))))
	                                    {
	                                        _761 = false;
	                                        break;
	                                    }
	                                    _761 = true;
	                                    break;
	                                } while(false);
	                                if (!_761)
	                                {
	                                    _762 = vec3(0.0);
	                                    break;
	                                }
	                                vec4 _3448 = g_Lights_1._member0[_3376].m_mToClipSpace * vec4(_3324.xyz, 1.0);
	                                vec3 _3452 = _3448.xyz / vec3(_3448.w);
	                                vec4 _3454;
	                                _3454.x = _3452.x;
	                                _3454.y = _3452.y;
	                                _3454.z = _3452.z;
	                                if (_2111)
	                                {
	                                    _759 = g_Lights_1._member0[_3376].m_vBounceColor.xyz;
	                                }
	                                else
	                                {
	                                    _759 = g_Lights_1._member0[_3376].m_vColor.xyz;
	                                }
	                                if (true)
	                                {
	                                    if (g_Lights_1._member0[_3376].m_nCookie >= 0)
	                                    {
	                                        if (g_Lights_1._member0[_3376].m_bSphericalCookie != 0)
	                                        {
	                                            vec4 _3512 = vec4(-g_Lights_1._member0[_3376].m_vOrientation.xyz, g_Lights_1._member0[_3376].m_vOrientation.w);
	                                            vec4 _3514 = _3512.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                                            vec3 _3517 = _3514.xyz;
	                                            vec3 _3518 = vec4((-normalize(g_Lights_1._member0[_3376].m_vLightPosition.xyz - _3324)).xyz, 0.0).xyz;
	                                            vec4 _3525 = vec4((_3518 * _3514.w) + cross(_3518, _3517), -dot(_3518, _3517));
	                                            vec3 _3526 = _3525.xyz;
	                                            float _3527 = _3512.w;
	                                            vec3 _3529 = _3512.xyz;
	                                            float _3530 = _3525.w;
	                                            vec3 _3538 = vec4(((_3526 * _3527) + (_3529 * _3530)) + cross(_3529, _3526), _337).xyz;
	                                            vec2 _3547 = vec2(atan(_3538.y, -_3538.x) * 0.15915493667125701904296875, acos(_3538.z) * 0.3183098733425140380859375);
	                                            vec2 _3554 = (_3547.xy * g_Lights_1._member0[_3376].m_vCookieParameters.zw) + g_Lights_1._member0[_3376].m_vCookieParameters.xy;
	                                            vec2 _3556 = _3547;
	                                            _3556.x = _3554.x;
	                                            _3556.y = _3554.y;
	                                            _758 = textureLod(nonuniformEXT(sampler2D(g_bindless_Texture2D[g_Lights_1._member0[_3376].m_nCookie], g_Sampler)), _3556, 0.0).xyz;
	                                        }
	                                        else
	                                        {
	                                            vec2 _3485 = fma(_3454.xyz.xy, vec2(0.5, -0.5), vec2(0.5));
	                                            vec2 _3492 = (_3485.xy * g_Lights_1._member0[_3376].m_vCookieParameters.zw) + g_Lights_1._member0[_3376].m_vCookieParameters.xy;
	                                            vec2 _3494 = _3485;
	                                            _3494.x = _3492.x;
	                                            _3494.y = _3492.y;
	                                            _758 = textureLod(nonuniformEXT(sampler2D(g_bindless_Texture2D[g_Lights_1._member0[_3376].m_nCookie], g_CookieSampler)), _3494, 0.0).xyz;
	                                        }
	                                    }
	                                    else
	                                    {
	                                        _758 = vec3(1.0);
	                                    }
	                                    _759 *= _758;
	                                }
	                                if (g_Lights_1._member0[_3376].m_nLuminaireType != 0)
	                                {
	                                    _759 = (_759 * g_Lights_1._member0[_3376].m_vLuminaireVectors.data[0].w) * 0.3183098733425140380859375;
	                                }
	                                else
	                                {
	                                    if (!(g_Lights_1._member0[_3376].m_vLightPosition.w == 0.0))
	                                    {
	                                        vec3 _3583 = g_Lights_1._member0[_3376].m_vLightPosition.xyz - _3324;
	                                        _759 *= (vec3(g_Lights_1._member0[_3376].m_vLightPosition.w) / max(vec3(dot(_3583, _3583)), vec3(g_Lights_1._member0[_3376].m_vLightPosition.w)));
	                                    }
	                                }
	                                if (g_Lights_1._member0[_3376].m_vDistanceFade_vSkirt.z > 0.0)
	                                {
	                                    _755 = smoothstep(0.0, 1.0, _3454.xyz.z * g_Lights_1._member0[_3376].m_vDistanceFade_vSkirt.z);
	                                }
	                                else
	                                {
	                                    _755 = 1.0;
	                                }
	                                if (g_Lights_1._member0[_3376].m_vDistanceFade_vSkirt.w > 0.0)
	                                {
	                                    _755 *= smoothstep(0.0, 1.0, (1.0 - _3454.xyz.z) * g_Lights_1._member0[_3376].m_vDistanceFade_vSkirt.w);
	                                }
	                                if (!(g_Lights_1._member0[_3376].m_vLightPosition.w == 0.0))
	                                {
	                                    vec3 _3637 = g_Lights_1._member0[_3376].m_vLightPosition.xyz - _3324;
	                                    float _3638 = length(_3637);
	                                    vec3 _3640 = _3637 / vec3(_3638);
	                                    float _3649 = _755 * smoothstep(0.0, 1.0, g_Lights_1._member0[_3376].m_vDistanceFade_vSkirt.x + (g_Lights_1._member0[_3376].m_vDistanceFade_vSkirt.y * _3638));
	                                    if (g_Lights_1._member0[_3376].m_nLuminaireType != 2)
	                                    {
	                                        _757 = g_Lights_1._member0[_3376].m_nLuminaireType != 1;
	                                    }
	                                    else
	                                    {
	                                        _757 = false;
	                                    }
	                                    if (_757)
	                                    {
	                                        float _3668 = 2.0 * g_Lights_1._member0[_3376].m_vOrientation.x;
	                                        float _3672 = 2.0 * g_Lights_1._member0[_3376].m_vOrientation.w;
	                                        vec3 _3686 = vec3((_3668 * g_Lights_1._member0[_3376].m_vOrientation.y) - (_3672 * g_Lights_1._member0[_3376].m_vOrientation.z), (1.0 - (_3668 * g_Lights_1._member0[_3376].m_vOrientation.x)) - ((2.0 * g_Lights_1._member0[_3376].m_vOrientation.z) * g_Lights_1._member0[_3376].m_vOrientation.z), ((2.0 * g_Lights_1._member0[_3376].m_vOrientation.y) * g_Lights_1._member0[_3376].m_vOrientation.z) + (_3672 * g_Lights_1._member0[_3376].m_vOrientation.x)) * g_Lights_1._member0[_3376].m_vAngleFade.z;
	                                        vec3 _3687 = _3640 - _3686;
	                                        vec3 _3688 = _3640 + _3686;
	                                        do
	                                        {
	                                            vec3 _3691 = _3688 - _3687;
	                                            float _3693 = dot(-_3687, _3691);
	                                            if (_3693 <= 0.0)
	                                            {
	                                                _753 = _3687;
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                float _3698 = dot(_3691, _3691);
	                                                if (_3693 > _3698)
	                                                {
	                                                    _753 = _3688;
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    _753 = _3687 + (_3691 * (_3693 / _3698));
	                                                    break;
	                                                }
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (any(notEqual(_753, vec3(0.0))))
	                                        {
	                                            _754 = normalize(_753);
	                                        }
	                                        else
	                                        {
	                                            _754 = _753;
	                                        }
	                                        float _3722 = 2.0 * g_Lights_1._member0[_3376].m_vOrientation.x;
	                                        float _3725 = 2.0 * g_Lights_1._member0[_3376].m_vOrientation.w;
	                                        _756 = _3649 * saturate(g_Lights_1._member0[_3376].m_vAngleFade.x + (g_Lights_1._member0[_3376].m_vAngleFade.y * dot(vec3((1.0 - ((2.0 * g_Lights_1._member0[_3376].m_vOrientation.y) * g_Lights_1._member0[_3376].m_vOrientation.y)) - ((2.0 * g_Lights_1._member0[_3376].m_vOrientation.z) * g_Lights_1._member0[_3376].m_vOrientation.z), (_3722 * g_Lights_1._member0[_3376].m_vOrientation.y) + (_3725 * g_Lights_1._member0[_3376].m_vOrientation.z), (_3722 * g_Lights_1._member0[_3376].m_vOrientation.z) - (_3725 * g_Lights_1._member0[_3376].m_vOrientation.y)), _754)));
	                                    }
	                                    else
	                                    {
	                                        _756 = _3649;
	                                    }
	                                }
	                                else
	                                {
	                                    _756 = _755;
	                                }
	                                if (g_Lights_1._member0[_3376].m_nCookie == (-1))
	                                {
	                                    do
	                                    {
	                                        vec2 _3754 = abs(_3454.xyz.xy);
	                                        if (g_Lights_1._member0[_3376].m_vCookieParameters.z == 0.0)
	                                        {
	                                            _751 = smoothstep(1.0, g_Lights_1._member0[_3376].m_vCookieParameters.x, _3754.x) * smoothstep(1.0, g_Lights_1._member0[_3376].m_vCookieParameters.y, _3754.y);
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            float _3759 = _3754.x;
	                                            float _3763 = _3754.y;
	                                            float _3770 = (-0.5) * g_Lights_1._member0[_3376].m_vCookieParameters.z;
	                                            float _3772 = (g_Lights_1._member0[_3376].m_vCookieParameters.x * g_Lights_1._member0[_3376].m_vCookieParameters.y) * pow(max(pow(g_Lights_1._member0[_3376].m_vCookieParameters.y * _3759, 2.0 / g_Lights_1._member0[_3376].m_vCookieParameters.z) + pow(g_Lights_1._member0[_3376].m_vCookieParameters.x * _3763, 2.0 / g_Lights_1._member0[_3376].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _3770);
	                                            float _3779 = pow(max(pow(_3759, 2.0 / g_Lights_1._member0[_3376].m_vCookieParameters.z) + pow(_3763, 2.0 / g_Lights_1._member0[_3376].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _3770);
	                                            if (_3772 < _3779)
	                                            {
	                                                _751 = smoothstep(_3779, _3772, 1.0);
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                if (_3779 > 1.0)
	                                                {
	                                                    _752 = 1.0;
	                                                }
	                                                else
	                                                {
	                                                    _752 = 0.0;
	                                                }
	                                                _751 = _752;
	                                                break;
	                                            }
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    _756 *= _751;
	                                }
	                                _762 = _759 * _756;
	                                break;
	                            } while(false);
	                            float _3802 = dot(_762.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                            if (_3802 == 0.0)
	                            {
	                                _768 = _3378;
	                                continue;
	                            }
	                            _749 = false;
	                            do
	                            {
	                                switch (g_Lights_1._member0[_3376].m_nLuminaireType)
	                                {
	                                    case 0:
	                                    {
	                                        _769 = 1.0;
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_3376].m_vLightPosition.w == 0.0)
	                                            {
	                                                _724 = vec4(normalize(g_Lights_1._member0[_3376].m_vLightPosition.xyz), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _4328 = g_Lights_1._member0[_3376].m_vLightPosition.xyz - _3324;
	                                                float _4329 = length(_4328);
	                                                _724 = vec4(_4328 / vec3(_4329), _4329);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _749 = true;
	                                        _750 = _724;
	                                        break;
	                                    }
	                                    case 1:
	                                    {
	                                        vec3 _4168 = g_Lights_1._member0[_3376].m_vLuminaireVectors.data[1].xyz - g_Lights_1._member0[_3376].m_vLuminaireVectors.data[0].xyz;
	                                        vec3 _4172 = g_Lights_1._member0[_3376].m_vLuminaireVectors.data[2].xyz - g_Lights_1._member0[_3376].m_vLuminaireVectors.data[0].xyz;
	                                        float _4173 = length(_4168);
	                                        float _4174 = length(_4172);
	                                        vec3 _4176 = _4168 / vec3(_4173);
	                                        vec3 _4178 = _4172 / vec3(_4174);
	                                        vec3 _4179 = cross(_4176, _4178);
	                                        vec3 _4180 = g_Lights_1._member0[_3376].m_vLuminaireVectors.data[0].xyz - _3324;
	                                        float _4181 = dot(_4180, _4179);
	                                        if (_4181 > 0.0)
	                                        {
	                                            _726 = _4181 * (-1.0);
	                                            _727 = _4179 * (-1.0);
	                                        }
	                                        else
	                                        {
	                                            _726 = _4181;
	                                            _727 = _4179;
	                                        }
	                                        float _4190 = dot(_4180, _4176);
	                                        float _4191 = dot(_4180, _4178);
	                                        float _4192 = _4190 + _4173;
	                                        float _4193 = _4191 + _4174;
	                                        vec3 _4196 = vec3(_4190, _4191, _726);
	                                        vec3 _4197 = vec3(_4190, _4193, _726);
	                                        vec3 _4198 = vec3(_4192, _4191, _726);
	                                        vec3 _4199 = vec3(_4192, _4193, _726);
	                                        vec3 _4201 = normalize(cross(_4196, _4198));
	                                        vec3 _4203 = normalize(cross(_4198, _4199));
	                                        vec3 _4205 = normalize(cross(_4199, _4197));
	                                        vec3 _4207 = normalize(cross(_4197, _4196));
	                                        float _4224 = _4201.z;
	                                        float _4228 = (6.283185482025146484375 - acos(clamp(-dot(_4205, _4207), -1.0, 1.0))) - acos(clamp(-dot(_4207, _4201), -1.0, 1.0));
	                                        float _4230 = (acos(clamp(-dot(_4201, _4203), -1.0, 1.0)) + acos(clamp(-dot(_4203, _4205), -1.0, 1.0))) - _4228;
	                                        if (isnan(_4230))
	                                        {
	                                            _728 = 0.0;
	                                        }
	                                        else
	                                        {
	                                            _728 = _4230;
	                                        }
	                                        float _4238 = (_2149.x * _728) + _4228;
	                                        float _4243 = ((cos(_4238) * _4224) - _4205.z) / sin(_4238);
	                                        if (_4243 > 0.0)
	                                        {
	                                            _729 = 1.0;
	                                        }
	                                        else
	                                        {
	                                            _729 = -1.0;
	                                        }
	                                        float _4252 = _729;
	                                        float _4254 = clamp((1.0 / sqrt((_4243 * _4243) + (_4224 * _4224))) * _4252, -1.0, 1.0);
	                                        float _4262 = clamp((-(_4254 * _726)) / sqrt(1.0 - (_4254 * _4254)), _4190, _4192);
	                                        float _4265 = sqrt((_4262 * _4262) + (_726 * _726));
	                                        float _4266 = _4265 * _4265;
	                                        float _4269 = _4191 / sqrt(_4266 + (_4191 * _4191));
	                                        float _4276 = _4269 + (_2149.y * ((_4193 / sqrt(_4266 + (_4193 * _4193))) - _4269));
	                                        float _4277 = _4276 * _4276;
	                                        if (_4277 < 0.99999988079071044921875)
	                                        {
	                                            _729 = (_4276 * _4265) / sqrt(1.0 - _4277);
	                                        }
	                                        else
	                                        {
	                                            _729 = _4193;
	                                        }
	                                        vec3 _4294 = ((_3324 + (_4176 * _4262)) + (_4178 * _729)) + (_727 * _726);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_3376].m_vLightPosition.w == 0.0)
	                                            {
	                                                _725 = vec4(normalize(_4294), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _4305 = _4294 - _3324;
	                                                float _4306 = length(_4305);
	                                                _725 = vec4(_4305 / vec3(_4306), _4306);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _769 = 1.0 / _728;
	                                        _749 = true;
	                                        _750 = _725;
	                                        break;
	                                    }
	                                    case 2:
	                                    {
	                                        do
	                                        {
	                                            vec2 _4076 = (_2149 * 2.0) - vec2(1.0);
	                                            if (all(equal(_4076, vec2(0.0))))
	                                            {
	                                                _733 = vec2(0.0);
	                                                break;
	                                            }
	                                            float _4081 = _4076.x;
	                                            float _4083 = _4076.y;
	                                            if (abs(_4081) > abs(_4083))
	                                            {
	                                                _734 = _4081;
	                                                _735 = 0.785398185253143310546875 * (_4083 / _4081);
	                                            }
	                                            else
	                                            {
	                                                _734 = _4083;
	                                                _735 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_4081 / _4083));
	                                            }
	                                            _733 = vec2(cos(_735), sin(_735)) * _734;
	                                            break;
	                                        } while(false);
	                                        vec3 _4117 = (g_Lights_1._member0[_3376].m_vLuminaireVectors.data[0].xyz + (g_Lights_1._member0[_3376].m_vLuminaireVectors.data[1].xyz * _733.x)) + (g_Lights_1._member0[_3376].m_vLuminaireVectors.data[2].xyz * _733.y);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_3376].m_vLightPosition.w == 0.0)
	                                            {
	                                                _732 = vec4(normalize(_4117), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _4128 = _4117 - _3324;
	                                                float _4129 = length(_4128);
	                                                _732 = vec4(_4128 / vec3(_4129), _4129);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (isinf(_732.w))
	                                        {
	                                            _730 = true;
	                                        }
	                                        else
	                                        {
	                                            _730 = isnan(_732.w);
	                                        }
	                                        if (!_730)
	                                        {
	                                            _731 = _732.w * _732.w;
	                                        }
	                                        else
	                                        {
	                                            _731 = 1.0;
	                                        }
	                                        _769 = _731 / (max(0.0, dot(g_Lights_1._member0[_3376].m_vLuminaireVectors.data[3].xyz, -_732.xyz)) * g_Lights_1._member0[_3376].m_vLuminaireVectors.data[1].w);
	                                        _749 = true;
	                                        _750 = _732;
	                                        break;
	                                    }
	                                    case 3:
	                                    {
	                                        vec3 _3971 = g_Lights_1._member0[_3376].m_vLuminaireVectors.data[0].xyz - _3324;
	                                        float _3972 = dot(_3971, _3971);
	                                        float _3973 = sqrt(_3972);
	                                        vec3 _3975 = _3971 / vec3(_3973);
	                                        float _3976 = _3975.z;
	                                        if (_3976 >= 0.0)
	                                        {
	                                            _737 = 1.0;
	                                        }
	                                        else
	                                        {
	                                            _737 = -1.0;
	                                        }
	                                        float _3983 = (-1.0) / (_737 + _3976);
	                                        float _3984 = _3975.x;
	                                        float _3985 = _3975.y;
	                                        float _3987 = (_3984 * _3985) * _3983;
	                                        vec3 _3992 = _738;
	                                        _3992.x = 1.0 + (((_737 * _3984) * _3984) * _3983);
	                                        _3992.y = _737 * _3987;
	                                        _3992.z = (-_737) * _3984;
	                                        _738 = _3992;
	                                        vec3 _3999 = _739;
	                                        _3999.x = _3987;
	                                        _3999.y = _737 + ((_3985 * _3985) * _3983);
	                                        _3999.z = -_3985;
	                                        _739 = _3999;
	                                        float _4007 = g_Lights_1._member0[_3376].m_vLuminaireVectors.data[1].x * g_Lights_1._member0[_3376].m_vLuminaireVectors.data[1].x;
	                                        float _4011 = sqrt(max(0.0, 1.0 - (_4007 / _3972)));
	                                        float _4012 = _2149.x;
	                                        float _4015 = (1.0 - _4012) + (_4012 * _4011);
	                                        float _4019 = sqrt(max(0.0, 1.0 - (_4015 * _4015)));
	                                        float _4021 = _2149.y * 6.283185482025146484375;
	                                        float _4023 = _3973 * _3973;
	                                        float _4029 = (_3973 * _4015) - sqrt(max(0.0, _4007 - ((_4023 * _4019) * _4019)));
	                                        float _4035 = ((_4023 + _4007) - (_4029 * _4029)) / ((2.0 * _3973) * g_Lights_1._member0[_3376].m_vLuminaireVectors.data[1].x);
	                                        float _4039 = sqrt(max(0.0, 1.0 - (_4035 * _4035)));
	                                        vec3 _4051 = g_Lights_1._member0[_3376].m_vLuminaireVectors.data[0].xyz + ((mat3(-_3992, -_3999, -_3975) * vec3(cos(_4021) * _4039, sin(_4021) * _4039, _4035)) * g_Lights_1._member0[_3376].m_vLuminaireVectors.data[1].x);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_3376].m_vLightPosition.w == 0.0)
	                                            {
	                                                _736 = vec4(normalize(_4051), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _4062 = _4051 - _3324;
	                                                float _4063 = length(_4062);
	                                                _736 = vec4(_4062 / vec3(_4063), _4063);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _769 = 0.15915493667125701904296875 / (1.0 - _4011);
	                                        _749 = true;
	                                        _750 = _736;
	                                        break;
	                                    }
	                                    case 4:
	                                    case 5:
	                                    {
	                                        vec2 _746 = _2149;
	                                        if (_2149.x < g_Lights_1._member0[_3376].m_vLuminaireVectors.data[4].y)
	                                        {
	                                            vec2 _3862 = _746;
	                                            _3862.x = clamp(_3862.x / g_Lights_1._member0[_3376].m_vLuminaireVectors.data[4].y, 0.0, 0.99999988079071044921875);
	                                            _746 = _3862;
	                                            vec3 _3868 = normalize(g_Lights_1._member0[_3376].m_vLuminaireVectors.data[0].xyz - g_Lights_1._member0[_3376].m_vLuminaireVectors.data[1].xyz);
	                                            if (_3862.x >= 0.5)
	                                            {
	                                                vec2 _3879 = _746;
	                                                _3879.x = clamp((2.0 * _3879.x) - 1.0, 0.0, 0.99999988079071044921875);
	                                                _746 = _3879;
	                                                _747 = -_3868;
	                                                _748 = g_Lights_1._member0[_3376].m_vLuminaireVectors.data[1].xyz;
	                                            }
	                                            else
	                                            {
	                                                vec2 _3874 = _746;
	                                                _3874.x = clamp(2.0 * _3874.x, 0.0, 0.99999988079071044921875);
	                                                _746 = _3874;
	                                                _747 = _3868;
	                                                _748 = g_Lights_1._member0[_3376].m_vLuminaireVectors.data[0].xyz;
	                                            }
	                                            do
	                                            {
	                                                vec2 _3890 = (_746 * 2.0) - vec2(1.0);
	                                                if (all(equal(_3890, vec2(0.0))))
	                                                {
	                                                    _743 = vec2(0.0);
	                                                    break;
	                                                }
	                                                float _3895 = _3890.x;
	                                                float _3897 = _3890.y;
	                                                if (abs(_3895) > abs(_3897))
	                                                {
	                                                    _744 = _3895;
	                                                    _745 = 0.785398185253143310546875 * (_3897 / _3895);
	                                                }
	                                                else
	                                                {
	                                                    _744 = _3897;
	                                                    _745 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_3895 / _3897));
	                                                }
	                                                _743 = vec2(cos(_745), sin(_745)) * _744;
	                                                break;
	                                            } while(false);
	                                            _748 += ((g_Lights_1._member0[_3376].m_vLuminaireVectors.data[2].xyz * _743.x) + (g_Lights_1._member0[_3376].m_vLuminaireVectors.data[3].xyz * _743.y));
	                                        }
	                                        else
	                                        {
	                                            vec2 _3841 = _746;
	                                            _3841.x = clamp((_3841.x - g_Lights_1._member0[_3376].m_vLuminaireVectors.data[4].y) / (1.0 - g_Lights_1._member0[_3376].m_vLuminaireVectors.data[4].y), 0.0, 0.99999988079071044921875);
	                                            _746 = _3841;
	                                            vec3 _3856 = (g_Lights_1._member0[_3376].m_vLuminaireVectors.data[2].xyz * cos(_3841.x * 6.283185482025146484375)) + (g_Lights_1._member0[_3376].m_vLuminaireVectors.data[3].xyz * sin(_3841.x * 6.283185482025146484375));
	                                            _747 = normalize(_3856);
	                                            _748 = mix(g_Lights_1._member0[_3376].m_vLuminaireVectors.data[0].xyz, g_Lights_1._member0[_3376].m_vLuminaireVectors.data[1].xyz, vec3(_3841.y)) + _3856;
	                                        }
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_3376].m_vLightPosition.w == 0.0)
	                                            {
	                                                _742 = vec4(normalize(_748), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _3933 = _748 - _3324;
	                                                float _3934 = length(_3933);
	                                                _742 = vec4(_3933 / vec3(_3934), _3934);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (isinf(_742.w))
	                                        {
	                                            _740 = true;
	                                        }
	                                        else
	                                        {
	                                            _740 = isnan(_742.w);
	                                        }
	                                        if (!_740)
	                                        {
	                                            _741 = _742.w * _742.w;
	                                        }
	                                        else
	                                        {
	                                            _741 = 1.0;
	                                        }
	                                        _769 = _741 / (max(0.0, dot(_747, -_742.xyz)) * g_Lights_1._member0[_3376].m_vLuminaireVectors.data[1].w);
	                                        _749 = true;
	                                        _750 = _742;
	                                        break;
	                                    }
	                                    default:
	                                    {
	                                        _769 = 0.0;
	                                        _749 = true;
	                                        _750 = vec4(uintBitsToFloat(0x7fc00000u /* nan */));
	                                        break;
	                                    }
	                                }
	                                if (_749)
	                                {
	                                    break;
	                                }
	                                break;
	                            } while(false);
	                            float _4349 = dot(vec3(_362), _750.xyz);
	                            if ((!(dot(_527, _750.xyz) > 0.0)) && _824)
	                            {
	                                _723 = -_4349;
	                            }
	                            else
	                            {
	                                _723 = _4349;
	                            }
	                            float _4356 = (_3802 / _769) * max(0.0, _723);
	                            float _770 = _763.x;
	                            do
	                            {
	                                float _4361 = _764;
	                                float _4362 = _4361 + _4356;
	                                _764 = _4362;
	                                if (_4362 == 0.0)
	                                {
	                                    _721 = false;
	                                    break;
	                                }
	                                float _4367 = _4356 / _764;
	                                do
	                                {
	                                    if (_4367 <= 0.0)
	                                    {
	                                        _722 = false;
	                                        break;
	                                    }
	                                    if (_4367 >= 1.0)
	                                    {
	                                        _722 = true;
	                                        break;
	                                    }
	                                    if (_770 < _4367)
	                                    {
	                                        _770 = min(_770 / _4367, 0.99999988079071044921875);
	                                        _722 = true;
	                                        break;
	                                    }
	                                    _770 = min((_770 - _4367) / (1.0 - _4367), 0.99999988079071044921875);
	                                    _722 = false;
	                                    break;
	                                } while(false);
	                                _721 = _722;
	                                break;
	                            } while(false);
	                            vec2 _4392 = _763;
	                            _4392.x = _770;
	                            _763 = _4392;
	                            if (_721)
	                            {
	                                _590 = int(_3376);
	                                _589 = _762 / vec3(_769);
	                                _587 = _750;
	                                _767 = _4356;
	                            }
	                            _768 = _3378;
	                            continue;
	                        }
	                        _765 = _767;
	                        _766++;
	                        continue;
	                    }
	                    if (_590 != (-1))
	                    {
	                        vec3 _4412 = _589;
	                        vec3 _4413 = _4412 * (_764 / _765);
	                        bool _4422 = !(dot(_527, _587.xyz) > 0.0);
	                        vec3 _4425 = vec3(_362);
	                        vec3 _4430 = transpose(mat3(_413, _412, _4425)) * _587.xyz;
	                        float16_t _478 = _361;
	                        f16vec3 _477 = _360;
	                        float16_t _476 = _359;
	                        float16_t _475 = _358;
	                        uint _474 = _357;
	                        f16vec4 _473 = _356;
	                        vec3 _586 = _411;
	                        do
	                        {
	                            if (_4422)
	                            {
	                                f16vec4 _591 = _473;
	                                if ((_474 & 65535u) == 1u)
	                                {
	                                    _716 = any(greaterThan(vec3(_591.xyz), vec3(0.0)));
	                                }
	                                else
	                                {
	                                    _716 = false;
	                                }
	                                if (_716)
	                                {
	                                    _720 = vec3(_473.xyz);
	                                }
	                                else
	                                {
	                                    _720 = vec3(1.0);
	                                }
	                                _719 = _720 * 0.3183098733425140380859375;
	                                break;
	                            }
	                            else
	                            {
	                                vec3 _4449 = vec3(mix(f16vec3(_475), _477, f16vec3(_478)));
	                                float _4451 = float(_476);
	                                do
	                                {
	                                    float _4454 = _4430.z;
	                                    vec3 _4456 = _4430 + _586;
	                                    if (_4454 <= 0.0)
	                                    {
	                                        _718 = true;
	                                    }
	                                    else
	                                    {
	                                        _718 = _586.z <= 0.0;
	                                    }
	                                    if (_718)
	                                    {
	                                        _717 = vec3(0.0);
	                                        break;
	                                    }
	                                    if (all(equal(_4456, vec3(0.0))))
	                                    {
	                                        _717 = vec3(0.0);
	                                        break;
	                                    }
	                                    vec3 _4469 = normalize(_4456);
	                                    float _4470 = _4469.z;
	                                    float _4478 = _4451 * _4451;
	                                    float _4479 = _4478 * _4478;
	                                    float _4483 = (((_4470 * _4479) - _4470) * _4470) + 1.0;
	                                    float _4487 = _4451 * _4451;
	                                    float _4488 = _4487 * _4487;
	                                    _717 = (_4449 + ((vec3(1.0) - _4449) * pow(max(0.0, 1.0 - dot(_4430, _4469)), 5.0))) * (((_4479 / max(9.9999999392252902907785028219223e-09, _4483 * _4483)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_4454 * sqrt(((_586.z - (_4488 * _586.z)) * _586.z) + _4488)) + (_586.z * sqrt(((_4454 - (_4488 * _4454)) * _4454) + _4488))))) * 0.3183098733425140380859375);
	                                    break;
	                                } while(false);
	                                _719 = ((vec3(_477) * (1.0 - float(_478))) * 0.3183098733425140380859375) + _717;
	                                break;
	                            }
	                            break;
	                        } while(false);
	                        float _4542 = dot(_4425, _587.xyz);
	                        if (_4422)
	                        {
	                            _715 = -_4542;
	                        }
	                        else
	                        {
	                            _715 = _4542;
	                        }
	                        _589 = (_4413 * (_719 * 3.1415927410125732421875)) * max(0.0, _715);
	                        if (_4422)
	                        {
	                            f16vec4 _585 = _356;
	                            if ((_357 & 65535u) == 2u)
	                            {
	                                _714 = float(_585.x) > 0.0;
	                            }
	                            else
	                            {
	                                _714 = false;
	                            }
	                            _771 = _714;
	                        }
	                        else
	                        {
	                            _771 = false;
	                        }
	                        if (_771)
	                        {
	                            f16vec4 _472 = _356;
	                            uint _4573 = uint(_356.w);
	                            float _4578 = pow(saturate(-dot(normalize(_527 + _4425), _587.xyz)), 2.0);
	                            f16vec3 _4579 = f16vec3(vec3(0.0));
	                            if (isinf(_587.w))
	                            {
	                                _710 = true;
	                            }
	                            else
	                            {
	                                _710 = isnan(_587.w);
	                            }
	                            if (!_710)
	                            {
	                                _711 = _587.w;
	                            }
	                            else
	                            {
	                                _711 = 1000.0;
	                            }
	                            vec3 _595 = _529 + (_587.xyz * _711);
	                            float _594 = 0.0;
	                            vec3 _593 = -_587.xyz;
	                            if (_4578 > 0.0)
	                            {
	                                _712 = _711;
	                            }
	                            else
	                            {
	                                _712 = 0.0;
	                            }
	                            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _596, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_4579, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _4579, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                            traceRayEXT(g_AccelStruct, 16u, 1u, 0u, 2u, 0u, _595, _594, _593, _712, 0);
	                            if (p.nInstance != (-1))
	                            {
	                                f16vec4 _592 = p.material.vMaterialBits;
	                                if ((p.material.nMaterialTypeAndFlags & 65535u) == 2u)
	                                {
	                                    _709 = float(_592.x) > 0.0;
	                                }
	                                else
	                                {
	                                    _709 = false;
	                                }
	                                if (!_709)
	                                {
	                                    _712 = 0.0;
	                                }
	                                else
	                                {
	                                    _712 = _4578;
	                                }
	                                _713 = _711 - p.flHitT;
	                            }
	                            else
	                            {
	                                _712 = _4578;
	                                _713 = _711;
	                            }
	                            float _4644 = _713 * float(_472.x);
	                            _588 = (_4413 * vec3(_360)) * ((exp2(SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_4573].m_vTransmissiveLogColor.xyz * (1.0 + (_4644 * SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_4573].m_fTransmissiveSaturation))) * exp(-_4644)) * _712);
	                        }
	                    }
	                    vec4 _827 = _587;
	                    if (_590 != (-1))
	                    {
	                        bool _4672 = any(notEqual(_589, vec3(0.0)));
	                        if (isinf(_827.w))
	                        {
	                            _707 = true;
	                        }
	                        else
	                        {
	                            _707 = isnan(_827.w);
	                        }
	                        if (!_707)
	                        {
	                            _708 = _827.w;
	                        }
	                        else
	                        {
	                            _708 = 56755.83984375;
	                        }
	                        vec4 _4689 = _827;
	                        _4689.w = _708;
	                        _827 = _4689;
	                        do
	                        {
	                            float _4698 = dot(_4689.xyz, g_Lights_1._member0[_590].m_vNearPlane.xyz);
	                            if (_4698 == 0.0)
	                            {
	                                _706 = 0.0;
	                                break;
	                            }
	                            _706 = (g_Lights_1._member0[_590].m_vNearPlane.w - dot(_2110, g_Lights_1._member0[_590].m_vNearPlane.xyz)) * (1.0 / _4698);
	                            break;
	                        } while(false);
	                        if (_706 > 0.0)
	                        {
	                            vec4 _4710 = _827;
	                            _4710.w = min(_4710.w, _706);
	                            _827 = _4710;
	                        }
	                        if (dot(_827.xyz, _527.xyz) < 0.0)
	                        {
	                            _826 = _542;
	                        }
	                        else
	                        {
	                            _826 = _543;
	                        }
	                        vec4 _4723 = _827;
	                        vec3 _4725 = _826 - _2110;
	                        _4723.w = _4723.w + dot(_4723.xyz, _4725);
	                        vec3 _4735 = normalize((_4723.xyz * _4723.w) + _4725);
	                        vec4 _4737 = _4723;
	                        _4737.x = _4735.x;
	                        _4737.y = _4735.y;
	                        _4737.z = _4735.z;
	                        _827 = _4737;
	                        do
	                        {
	                            int _4748 = int(g_SceneGlobalInfo._member0[0].m_nSceneGlobalInfoFlags);
	                            if ((_4748 & 1) != 0)
	                            {
	                                _705 = 32u;
	                                break;
	                            }
	                            if ((_4748 & 2) != 0)
	                            {
	                                _705 = 16u;
	                                break;
	                            }
	                            _705 = 0u;
	                            break;
	                        } while(false);
	                        vec3 _599 = _826;
	                        float _598 = 0.0;
	                        vec3 _597 = _4737.xyz;
	                        if (_4672)
	                        {
	                            _704 = _4737.w;
	                        }
	                        else
	                        {
	                            _704 = 0.0;
	                        }
	                        p_1 = PayloadShadow_t(1.0);
	                        traceRayEXT(g_AccelStruct, _705, 2u, 1u, 2u, 1u, _599, _598, _597, _704, 1);
	                        if (_4672)
	                        {
	                            _704 = p_1.m_flVisibility;
	                        }
	                        else
	                        {
	                            _704 = 0.0;
	                        }
	                        _826 = (_818 + _588) + (_589 * _704);
	                    }
	                    else
	                    {
	                        _826 = _818;
	                    }
	                }
	                else
	                {
	                    _826 = _818;
	                }
	                _549 = _543;
	                _548 = _542;
	                _547 = _541;
	                _546 = _540;
	                _377 = _370;
	                _376 = _369;
	                _375 = _368;
	                _374 = _367;
	                _373 = _365;
	                _372 = _364;
	                _371 = _363;
	                _439 = _434;
	                _438 = _433;
	                _437 = _432;
	                _436 = _431;
	                _435 = _430;
	                vec3 _4806 = vec3(_368);
	                float _4812 = min(0.89999997615814208984375, max(_4806.x, max(_4806.y, _4806.z)));
	                float _852 = _851.x;
	                do
	                {
	                    if (_4812 <= 0.0)
	                    {
	                        _703 = false;
	                        break;
	                    }
	                    if (_4812 >= 1.0)
	                    {
	                        _703 = true;
	                        break;
	                    }
	                    if (_852 < _4812)
	                    {
	                        _852 = min(_852 / _4812, 0.99999988079071044921875);
	                        _703 = true;
	                        break;
	                    }
	                    _852 = min((_852 - _4812) / (1.0 - _4812), 0.99999988079071044921875);
	                    _703 = false;
	                    break;
	                } while(false);
	                vec2 _4837 = _851;
	                _4837.x = _852;
	                _851 = _4837;
	                if (_703)
	                {
	                    float _526 = _436;
	                    do
	                    {
	                        _853 = 1.0;
	                        do
	                        {
	                            if (_526 <= 0.0)
	                            {
	                                _702 = false;
	                                break;
	                            }
	                            if (_526 >= 1.0)
	                            {
	                                _702 = true;
	                                break;
	                            }
	                            if (_851.x < _526)
	                            {
	                                vec2 _4860 = _851;
	                                _4860.x = min(_4860.x / _526, 0.99999988079071044921875);
	                                _851 = _4860;
	                                _702 = true;
	                                break;
	                            }
	                            vec2 _4865 = _851;
	                            _4865.x = min((_4865.x - _526) / (1.0 - _526), 0.99999988079071044921875);
	                            _851 = _4865;
	                            _702 = false;
	                            break;
	                        } while(false);
	                        if (_702)
	                        {
	                            _853 = _526;
	                            _701 = true;
	                            break;
	                        }
	                        else
	                        {
	                            _853 = 1.0 - _526;
	                            _701 = false;
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    if (_701)
	                    {
	                        _549 = _548;
	                    }
	                    f16vec3 _410 = _377;
	                    float16_t _409 = _376;
	                    f16vec3 _408 = _375;
	                    float16_t _407 = _374;
	                    float16_t _406 = _373;
	                    uint _405 = _372;
	                    f16vec4 _404 = _371;
	                    vec3 _525 = _439;
	                    vec3 _524 = _438;
	                    float _523 = _437;
	                    vec3 _522 = _435;
	                    do
	                    {
	                        vec2 _699 = _851;
	                        if (_701)
	                        {
	                            float _4976 = sqrt(_699.y);
	                            float _4978 = 6.283185482025146484375 * _699.x;
	                            vec3 _4986 = vec3(cos(_4978) * _4976, sin(_4978) * _4976, sqrt(max(0.0, 1.0 - _699.y)));
	                            _4986.z = -_4986.z;
	                            _698 = _4986;
	                            break;
	                        }
	                        else
	                        {
	                            float _700 = _699.x;
	                            do
	                            {
	                                if (_523 <= 0.0)
	                                {
	                                    _697 = false;
	                                    break;
	                                }
	                                if (_523 >= 1.0)
	                                {
	                                    _697 = true;
	                                    break;
	                                }
	                                if (_700 < _523)
	                                {
	                                    _700 = min(_700 / _523, 0.99999988079071044921875);
	                                    _697 = true;
	                                    break;
	                                }
	                                _700 = min((_700 - _523) / (1.0 - _523), 0.99999988079071044921875);
	                                _697 = false;
	                                break;
	                            } while(false);
	                            vec2 _4924 = _699;
	                            _4924.x = _700;
	                            _699 = _4924;
	                            if (_697)
	                            {
	                                float _4929 = float(_407);
	                                float _4937 = ((_4929 * _4929) * sqrt(_699.x)) / sqrt(1.0 - _699.x);
	                                float _4940 = 1.0 / (1.0 + (_4937 * _4937));
	                                float _4943 = sqrt(max(0.0, 1.0 - _4940));
	                                float _4946 = 6.283185482025146484375 * _699.y;
	                                vec3 _4951 = vec3(cos(_4946) * _4943, sin(_4946) * _4943, sqrt(_4940));
	                                if (dot(_522, _4951) > 0.0)
	                                {
	                                    _696 = _4951;
	                                }
	                                else
	                                {
	                                    _696 = -_4951;
	                                }
	                                _698 = -reflect(_522, _696);
	                                break;
	                            }
	                            float _4963 = sqrt(_699.y);
	                            float _4965 = 6.283185482025146484375 * _699.x;
	                            _698 = vec3(cos(_4965) * _4963, sin(_4965) * _4963, sqrt(max(0.0, 1.0 - _699.y)));
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    _845 = _698;
	                    vec3 _4993 = normalize(_698 + _522);
	                    float _4994 = _4993.z;
	                    if (_701)
	                    {
	                        _694 = _698.z * (-0.3183098733425140380859375);
	                    }
	                    else
	                    {
	                        if (_523 > 0.0)
	                        {
	                            float _5007 = float(_407);
	                            float _5008 = _5007 * _5007;
	                            float _5009 = _5008 * _5008;
	                            float _5013 = (((_4994 * _5009) - _4994) * _4994) + 1.0;
	                            _693 = 1.0 - _523;
	                            _694 = _523 * (((_5009 / max(9.9999999392252902907785028219223e-09, _5013 * _5013)) * _4994) / (12.56637096405029296875 * max(0.0, dot(_522, _4993))));
	                        }
	                        else
	                        {
	                            _693 = 1.0;
	                            _694 = 0.0;
	                        }
	                        _694 += (_693 * (_698.z * 0.3183098733425140380859375));
	                    }
	                    if (_694 == 0.0)
	                    {
	                        _695 = true;
	                    }
	                    else
	                    {
	                        _695 = isnan(_694);
	                    }
	                    if (_695)
	                    {
	                        _693 = 3.4028234663852885981170418348452e+38;
	                    }
	                    else
	                    {
	                        _693 = _694;
	                    }
	                    float _854 = _693;
	                    do
	                    {
	                        if (_701)
	                        {
	                            f16vec4 _600 = _404;
	                            if ((_405 & 65535u) == 1u)
	                            {
	                                _688 = any(greaterThan(vec3(_600.xyz), vec3(0.0)));
	                            }
	                            else
	                            {
	                                _688 = false;
	                            }
	                            if (_688)
	                            {
	                                _692 = vec3(_404.xyz);
	                            }
	                            else
	                            {
	                                _692 = vec3(1.0);
	                            }
	                            _691 = _692 * 0.3183098733425140380859375;
	                            break;
	                        }
	                        else
	                        {
	                            vec3 _5054 = vec3(mix(f16vec3(_406), _408, f16vec3(_409)));
	                            float _5056 = float(_407);
	                            do
	                            {
	                                vec3 _5061 = _845 + _522;
	                                if (_845.z <= 0.0)
	                                {
	                                    _690 = true;
	                                }
	                                else
	                                {
	                                    _690 = _522.z <= 0.0;
	                                }
	                                if (_690)
	                                {
	                                    _689 = vec3(0.0);
	                                    break;
	                                }
	                                if (all(equal(_5061, vec3(0.0))))
	                                {
	                                    _689 = vec3(0.0);
	                                    break;
	                                }
	                                vec3 _5074 = normalize(_5061);
	                                float _5075 = _5074.z;
	                                float _5083 = _5056 * _5056;
	                                float _5084 = _5083 * _5083;
	                                float _5088 = (((_5075 * _5084) - _5075) * _5075) + 1.0;
	                                float _5092 = _5056 * _5056;
	                                float _5093 = _5092 * _5092;
	                                _689 = (_5054 + ((vec3(1.0) - _5054) * pow(max(0.0, 1.0 - dot(_845, _5074)), 5.0))) * (((_5084 / max(9.9999999392252902907785028219223e-09, _5088 * _5088)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_845.z * sqrt(((_522.z - (_5093 * _522.z)) * _522.z) + _5093)) + (_522.z * sqrt(((_845.z - (_5093 * _845.z)) * _845.z) + _5093))))) * 0.3183098733425140380859375);
	                                break;
	                            } while(false);
	                            _691 = ((vec3(_408) * (1.0 - float(_409))) * 0.3183098733425140380859375) + _689;
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    vec3 _5143 = _845;
	                    vec3 _5149 = mat3(_525, _524, vec3(_410)) * _5143;
	                    _845 = _5149;
	                    float _5152 = dot(vec3(_377), _5149);
	                    if (_701)
	                    {
	                        _687 = -_5152;
	                    }
	                    else
	                    {
	                        _687 = _5152;
	                    }
	                    do
	                    {
	                        if ((_546 & 1024) != 0)
	                        {
	                            _686 = true;
	                            break;
	                        }
	                        _686 = (dot(_547, _845) > 0.0) != _701;
	                        break;
	                    } while(false);
	                    if (_686)
	                    {
	                        _855 = (_849 * (_691 * max(0.0, _687))) / vec3((_4812 * _853) * _854);
	                    }
	                    else
	                    {
	                        _855 = vec3(0.0);
	                    }
	                    _847 = _855;
	                }
	                else
	                {
	                    _847 = vec3(0.0);
	                }
	                _846++;
	                _848 = (_848 + ((_826 * _849) * _850)) + ((vec3(_366) * _849) * _850);
	                continue;
	            }
	            vec3 _5193 = abs(_848);
	            float _5198 = max(_5193.x, max(_5193.y, _5193.z));
	            vec3 _5203 = clamp(_848 / vec3(_5198), vec3(-1.0), vec3(1.0)) * clamp(_5198, -100.0, 100.0);
	            float _5204 = dot(_1360, vec3(_355));
	            float _861;
	            vec3 _862;
	            if (_856)
	            {
	                _861 = -_5204;
	                _862 = _5203 * vTransmissiveRatio;
	            }
	            else
	            {
	                _861 = _5204;
	                _862 = _5203;
	            }
	            vec4 _5210 = _504;
	            vec3 _5217 = _5210.xyz + ((_862 * max(0.0, _861)) * 0.3183098733425140380859375);
	            vec4 _5219 = _5210;
	            _5219.x = _5217.x;
	            _5219.y = _5217.y;
	            _5219.z = _5217.z;
	            vec3 _5225 = _5219.xyz + vec3(0.0);
	            vec4 _5227 = _5219;
	            _5227.x = _5225.x;
	            _5227.y = _5225.y;
	            _5227.z = _5225.z;
	            _504 = _5227;
	            if (_861 > 0.0)
	            {
	                vec4 _863;
	                vec4 _5235 = _863;
	                _5235.x = 0.2820948064327239990234375;
	                float _5237 = _1360.y;
	                _5235.y = (-0.48860251903533935546875) * _5237;
	                float _5240 = _1360.z;
	                _5235.z = 0.48860251903533935546875 * _5240;
	                float _5243 = _1360.x;
	                _5235.w = (-0.48860251903533935546875) * _5243;
	                _863 = _5235;
	                vec4 _864;
	                vec4 _5248 = _864;
	                _5248.x = (1.09254848957061767578125 * _5243) * _5237;
	                _5248.y = ((-1.09254848957061767578125) * _5237) * _5240;
	                _5248.z = 0.3153915703296661376953125 * (((3.0 * _5240) * _5240) - 1.0);
	                _5248.w = ((-1.09254848957061767578125) * _5243) * _5240;
	                _864 = _5248;
	                _503 += (_5235 * _862.x);
	                _500 += (_5248 * _862.x);
	                _502 += (_5235 * _862.y);
	                _499 += (_5248 * _862.y);
	                _501 += (_5235 * _862.z);
	                _498 += (_5248 * _862.z);
	                vec4 _5287 = _497;
	                vec3 _5290 = _5287.xyz + (_862 * (0.546274244785308837890625 * ((_5243 * _5243) - (_5237 * _5237))));
	                vec4 _5292 = _5287;
	                _5292.x = _5290.x;
	                _5292.y = _5290.y;
	                _5292.z = _5290.z;
	                _497 = _5292;
	            }
	            vec3 _484 = _506;
	            f16vec3 _341 = _348;
	            uint _340 = _343;
	            f16vec4 _339 = _342;
	            uint _483 = _956;
	            uvec3 _482 = _957;
	            vec3 _481 = _962;
	            vec3 _480 = _960;
	            vec3 _5305 = (_508 + _507) * 0.5;
	            vec2 _5313 = imageLoad(g_RandomSamples, ivec3(_935.xy, int(1u + (2u * _936)))).xy;
	            vec2 _663 = imageLoad(g_RandomSamples, ivec3(_935.xy, int(1u + _936))).xy;
	            bool _664;
	            if (any(notEqual(vTransmissiveRatio, vec3(0.0))))
	            {
	                _664 = true;
	            }
	            else
	            {
	                _664 = false;
	            }
	            if (_664)
	            {
	                _664 = true;
	            }
	            else
	            {
	                _664 = false;
	            }
	            vec4 _665 = vec4(0.0);
	            float _666 = 0.0;
	            uvec3 _5337 = min(uvec3(max(fma(_5305, _480, _481), vec3(0.0))), (_482 - uvec3(1u)));
	            int _668 = -1;
	            float _669 = 0.0;
	            bool _667 = false;
	            uint _670 = 0u;
	            vec3 _671 = vec3(0.0);
	            bool _622;
	            bool _623;
	            vec4 _624;
	            vec4 _625;
	            float _626;
	            vec3 _627;
	            float _628;
	            float _629;
	            bool _630;
	            float _631;
	            vec4 _632;
	            vec2 _633;
	            float _634;
	            float _635;
	            vec4 _636;
	            float _637;
	            vec3 _638;
	            vec3 _639;
	            bool _640;
	            float _641;
	            vec4 _642;
	            vec2 _643;
	            float _644;
	            float _645;
	            vec3 _647;
	            vec3 _648;
	            vec4 _650;
	            float _651;
	            float _652;
	            vec3 _653;
	            vec3 _654;
	            float _655;
	            float _656;
	            bool _657;
	            vec3 _658;
	            vec3 _659;
	            bool _660;
	            bool _661;
	            vec3 _662;
	            float _672;
	            uint _673;
	            vec3 _674;
	            vec3 _675;
	            float _678;
	            float _679;
	            vec4 _680;
	            vec4 _681;
	            bool _682;
	            for (;;)
	            {
	                if (!(_670 < _483))
	                {
	                    break;
	                }
	                uint _5353 = _483 * _482.x;
	                int _677 = _668;
	                _672 = _669;
	                bool _676 = _667;
	                _673 = subgroupOr(g_LightBins_1._member0[((((_5353 * _482.y) * _5337.z) + (_5353 * _5337.y)) + (_483 * _5337.x)) + _670]);
	                _674 = _671;
	                for (;;)
	                {
	                    if (!(_673 != 0u))
	                    {
	                        break;
	                    }
	                    uint _5380 = _673;
	                    uint _5384 = uint(findLSB(_5380)) + (_670 * 32u);
	                    uint _5386 = _5380 & (_5380 - 1u);
	                    if ((g_Lights_1._member0[_5384].m_nPathTraceFlags & 2) == 0)
	                    {
	                        _673 = _5386;
	                        continue;
	                    }
	                    do
	                    {
	                        do
	                        {
	                            vec4 _5404 = g_Lights_1._member0[_5384].m_mToClipSpace * vec4(_5305.xyz, 1.0);
	                            vec3 _5408 = _5404.xyz / vec3(_5404.w);
	                            vec4 _5410;
	                            _5410.x = _5408.x;
	                            _5410.y = _5408.y;
	                            _5410.z = _5408.z;
	                            if (all(greaterThanEqual(_5410.xyz, vec3(-1.0, -1.0, 0.0))))
	                            {
	                                _660 = all(lessThanEqual(_5410.xyz, vec3(1.0)));
	                            }
	                            else
	                            {
	                                _660 = false;
	                            }
	                            if (!_660)
	                            {
	                                _661 = false;
	                                break;
	                            }
	                            if (!all(lessThanEqual(abs((g_Lights_1._member0[_5384].m_mBarnIlluminationFromWorld * vec4(_5305, 1.0)).xyz), vec3(1.0))))
	                            {
	                                _661 = false;
	                                break;
	                            }
	                            _661 = true;
	                            break;
	                        } while(false);
	                        if (!_661)
	                        {
	                            _662 = vec3(0.0);
	                            break;
	                        }
	                        vec4 _5447 = g_Lights_1._member0[_5384].m_mToClipSpace * vec4(_5305.xyz, 1.0);
	                        vec3 _5451 = _5447.xyz / vec3(_5447.w);
	                        vec4 _5453;
	                        _5453.x = _5451.x;
	                        _5453.y = _5451.y;
	                        _5453.z = _5451.z;
	                        if (false)
	                        {
	                            _659 = g_Lights_1._member0[_5384].m_vBounceColor.xyz;
	                        }
	                        else
	                        {
	                            _659 = g_Lights_1._member0[_5384].m_vColor.xyz;
	                        }
	                        if (true)
	                        {
	                            if (g_Lights_1._member0[_5384].m_nCookie >= 0)
	                            {
	                                if (g_Lights_1._member0[_5384].m_bSphericalCookie != 0)
	                                {
	                                    vec4 _5511 = vec4(-g_Lights_1._member0[_5384].m_vOrientation.xyz, g_Lights_1._member0[_5384].m_vOrientation.w);
	                                    vec4 _5513 = _5511.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                                    vec3 _5516 = _5513.xyz;
	                                    vec3 _5517 = vec4((-normalize(g_Lights_1._member0[_5384].m_vLightPosition.xyz - _5305)).xyz, 0.0).xyz;
	                                    vec4 _5524 = vec4((_5517 * _5513.w) + cross(_5517, _5516), -dot(_5517, _5516));
	                                    vec3 _5525 = _5524.xyz;
	                                    float _5526 = _5511.w;
	                                    vec3 _5528 = _5511.xyz;
	                                    float _5529 = _5524.w;
	                                    vec3 _5537 = vec4(((_5525 * _5526) + (_5528 * _5529)) + cross(_5528, _5525), _337).xyz;
	                                    vec2 _5546 = vec2(atan(_5537.y, -_5537.x) * 0.15915493667125701904296875, acos(_5537.z) * 0.3183098733425140380859375);
	                                    vec2 _5553 = (_5546.xy * g_Lights_1._member0[_5384].m_vCookieParameters.zw) + g_Lights_1._member0[_5384].m_vCookieParameters.xy;
	                                    vec2 _5555 = _5546;
	                                    _5555.x = _5553.x;
	                                    _5555.y = _5553.y;
	                                    _658 = textureLod(nonuniformEXT(sampler2D(g_bindless_Texture2D[g_Lights_1._member0[_5384].m_nCookie], g_Sampler)), _5555, 0.0).xyz;
	                                }
	                                else
	                                {
	                                    vec2 _5484 = fma(_5453.xyz.xy, vec2(0.5, -0.5), vec2(0.5));
	                                    vec2 _5491 = (_5484.xy * g_Lights_1._member0[_5384].m_vCookieParameters.zw) + g_Lights_1._member0[_5384].m_vCookieParameters.xy;
	                                    vec2 _5493 = _5484;
	                                    _5493.x = _5491.x;
	                                    _5493.y = _5491.y;
	                                    _658 = textureLod(nonuniformEXT(sampler2D(g_bindless_Texture2D[g_Lights_1._member0[_5384].m_nCookie], g_CookieSampler)), _5493, 0.0).xyz;
	                                }
	                            }
	                            else
	                            {
	                                _658 = vec3(1.0);
	                            }
	                            _659 *= _658;
	                        }
	                        if (g_Lights_1._member0[_5384].m_nLuminaireType != 0)
	                        {
	                            _659 = (_659 * g_Lights_1._member0[_5384].m_vLuminaireVectors.data[0].w) * 0.3183098733425140380859375;
	                        }
	                        else
	                        {
	                            if (!(g_Lights_1._member0[_5384].m_vLightPosition.w == 0.0))
	                            {
	                                vec3 _5582 = g_Lights_1._member0[_5384].m_vLightPosition.xyz - _5305;
	                                _659 *= (vec3(g_Lights_1._member0[_5384].m_vLightPosition.w) / max(vec3(dot(_5582, _5582)), vec3(g_Lights_1._member0[_5384].m_vLightPosition.w)));
	                            }
	                        }
	                        if (g_Lights_1._member0[_5384].m_vDistanceFade_vSkirt.z > 0.0)
	                        {
	                            _655 = smoothstep(0.0, 1.0, _5453.xyz.z * g_Lights_1._member0[_5384].m_vDistanceFade_vSkirt.z);
	                        }
	                        else
	                        {
	                            _655 = 1.0;
	                        }
	                        if (g_Lights_1._member0[_5384].m_vDistanceFade_vSkirt.w > 0.0)
	                        {
	                            _655 *= smoothstep(0.0, 1.0, (1.0 - _5453.xyz.z) * g_Lights_1._member0[_5384].m_vDistanceFade_vSkirt.w);
	                        }
	                        if (!(g_Lights_1._member0[_5384].m_vLightPosition.w == 0.0))
	                        {
	                            vec3 _5636 = g_Lights_1._member0[_5384].m_vLightPosition.xyz - _5305;
	                            float _5637 = length(_5636);
	                            vec3 _5639 = _5636 / vec3(_5637);
	                            float _5648 = _655 * smoothstep(0.0, 1.0, g_Lights_1._member0[_5384].m_vDistanceFade_vSkirt.x + (g_Lights_1._member0[_5384].m_vDistanceFade_vSkirt.y * _5637));
	                            if (g_Lights_1._member0[_5384].m_nLuminaireType != 2)
	                            {
	                                _657 = g_Lights_1._member0[_5384].m_nLuminaireType != 1;
	                            }
	                            else
	                            {
	                                _657 = false;
	                            }
	                            if (_657)
	                            {
	                                float _5667 = 2.0 * g_Lights_1._member0[_5384].m_vOrientation.x;
	                                float _5671 = 2.0 * g_Lights_1._member0[_5384].m_vOrientation.w;
	                                vec3 _5685 = vec3((_5667 * g_Lights_1._member0[_5384].m_vOrientation.y) - (_5671 * g_Lights_1._member0[_5384].m_vOrientation.z), (1.0 - (_5667 * g_Lights_1._member0[_5384].m_vOrientation.x)) - ((2.0 * g_Lights_1._member0[_5384].m_vOrientation.z) * g_Lights_1._member0[_5384].m_vOrientation.z), ((2.0 * g_Lights_1._member0[_5384].m_vOrientation.y) * g_Lights_1._member0[_5384].m_vOrientation.z) + (_5671 * g_Lights_1._member0[_5384].m_vOrientation.x)) * g_Lights_1._member0[_5384].m_vAngleFade.z;
	                                vec3 _5686 = _5639 - _5685;
	                                vec3 _5687 = _5639 + _5685;
	                                do
	                                {
	                                    vec3 _5690 = _5687 - _5686;
	                                    float _5692 = dot(-_5686, _5690);
	                                    if (_5692 <= 0.0)
	                                    {
	                                        _653 = _5686;
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        float _5697 = dot(_5690, _5690);
	                                        if (_5692 > _5697)
	                                        {
	                                            _653 = _5687;
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            _653 = _5686 + (_5690 * (_5692 / _5697));
	                                            break;
	                                        }
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                if (any(notEqual(_653, vec3(0.0))))
	                                {
	                                    _654 = normalize(_653);
	                                }
	                                else
	                                {
	                                    _654 = _653;
	                                }
	                                float _5721 = 2.0 * g_Lights_1._member0[_5384].m_vOrientation.x;
	                                float _5724 = 2.0 * g_Lights_1._member0[_5384].m_vOrientation.w;
	                                _656 = _5648 * saturate(g_Lights_1._member0[_5384].m_vAngleFade.x + (g_Lights_1._member0[_5384].m_vAngleFade.y * dot(vec3((1.0 - ((2.0 * g_Lights_1._member0[_5384].m_vOrientation.y) * g_Lights_1._member0[_5384].m_vOrientation.y)) - ((2.0 * g_Lights_1._member0[_5384].m_vOrientation.z) * g_Lights_1._member0[_5384].m_vOrientation.z), (_5721 * g_Lights_1._member0[_5384].m_vOrientation.y) + (_5724 * g_Lights_1._member0[_5384].m_vOrientation.z), (_5721 * g_Lights_1._member0[_5384].m_vOrientation.z) - (_5724 * g_Lights_1._member0[_5384].m_vOrientation.y)), _654)));
	                            }
	                            else
	                            {
	                                _656 = _5648;
	                            }
	                        }
	                        else
	                        {
	                            _656 = _655;
	                        }
	                        if (g_Lights_1._member0[_5384].m_nCookie == (-1))
	                        {
	                            do
	                            {
	                                vec2 _5753 = abs(_5453.xyz.xy);
	                                if (g_Lights_1._member0[_5384].m_vCookieParameters.z == 0.0)
	                                {
	                                    _651 = smoothstep(1.0, g_Lights_1._member0[_5384].m_vCookieParameters.x, _5753.x) * smoothstep(1.0, g_Lights_1._member0[_5384].m_vCookieParameters.y, _5753.y);
	                                    break;
	                                }
	                                else
	                                {
	                                    float _5758 = _5753.x;
	                                    float _5762 = _5753.y;
	                                    float _5769 = (-0.5) * g_Lights_1._member0[_5384].m_vCookieParameters.z;
	                                    float _5771 = (g_Lights_1._member0[_5384].m_vCookieParameters.x * g_Lights_1._member0[_5384].m_vCookieParameters.y) * pow(max(pow(g_Lights_1._member0[_5384].m_vCookieParameters.y * _5758, 2.0 / g_Lights_1._member0[_5384].m_vCookieParameters.z) + pow(g_Lights_1._member0[_5384].m_vCookieParameters.x * _5762, 2.0 / g_Lights_1._member0[_5384].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _5769);
	                                    float _5778 = pow(max(pow(_5758, 2.0 / g_Lights_1._member0[_5384].m_vCookieParameters.z) + pow(_5762, 2.0 / g_Lights_1._member0[_5384].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _5769);
	                                    if (_5771 < _5778)
	                                    {
	                                        _651 = smoothstep(_5778, _5771, 1.0);
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        if (_5778 > 1.0)
	                                        {
	                                            _652 = 1.0;
	                                        }
	                                        else
	                                        {
	                                            _652 = 0.0;
	                                        }
	                                        _651 = _652;
	                                        break;
	                                    }
	                                    break;
	                                }
	                                break;
	                            } while(false);
	                            _656 *= _651;
	                        }
	                        _662 = _659 * _656;
	                        break;
	                    } while(false);
	                    if (all(equal(_662, vec3(0.0))))
	                    {
	                        _673 = _5386;
	                        continue;
	                    }
	                    _649 = false;
	                    do
	                    {
	                        switch (g_Lights_1._member0[_5384].m_nLuminaireType)
	                        {
	                            case 0:
	                            {
	                                _678 = 1.0;
	                                do
	                                {
	                                    if (g_Lights_1._member0[_5384].m_vLightPosition.w == 0.0)
	                                    {
	                                        _624 = vec4(normalize(g_Lights_1._member0[_5384].m_vLightPosition.xyz), uintBitsToFloat(0x7f800000u /* inf */));
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        vec3 _6326 = g_Lights_1._member0[_5384].m_vLightPosition.xyz - _5305;
	                                        float _6327 = length(_6326);
	                                        _624 = vec4(_6326 / vec3(_6327), _6327);
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                _649 = true;
	                                _650 = _624;
	                                break;
	                            }
	                            case 1:
	                            {
	                                vec3 _6166 = g_Lights_1._member0[_5384].m_vLuminaireVectors.data[1].xyz - g_Lights_1._member0[_5384].m_vLuminaireVectors.data[0].xyz;
	                                vec3 _6170 = g_Lights_1._member0[_5384].m_vLuminaireVectors.data[2].xyz - g_Lights_1._member0[_5384].m_vLuminaireVectors.data[0].xyz;
	                                float _6171 = length(_6166);
	                                float _6172 = length(_6170);
	                                vec3 _6174 = _6166 / vec3(_6171);
	                                vec3 _6176 = _6170 / vec3(_6172);
	                                vec3 _6177 = cross(_6174, _6176);
	                                vec3 _6178 = g_Lights_1._member0[_5384].m_vLuminaireVectors.data[0].xyz - _5305;
	                                float _6179 = dot(_6178, _6177);
	                                if (_6179 > 0.0)
	                                {
	                                    _626 = _6179 * (-1.0);
	                                    _627 = _6177 * (-1.0);
	                                }
	                                else
	                                {
	                                    _626 = _6179;
	                                    _627 = _6177;
	                                }
	                                float _6188 = dot(_6178, _6174);
	                                float _6189 = dot(_6178, _6176);
	                                float _6190 = _6188 + _6171;
	                                float _6191 = _6189 + _6172;
	                                vec3 _6194 = vec3(_6188, _6189, _626);
	                                vec3 _6195 = vec3(_6188, _6191, _626);
	                                vec3 _6196 = vec3(_6190, _6189, _626);
	                                vec3 _6197 = vec3(_6190, _6191, _626);
	                                vec3 _6199 = normalize(cross(_6194, _6196));
	                                vec3 _6201 = normalize(cross(_6196, _6197));
	                                vec3 _6203 = normalize(cross(_6197, _6195));
	                                vec3 _6205 = normalize(cross(_6195, _6194));
	                                float _6222 = _6199.z;
	                                float _6226 = (6.283185482025146484375 - acos(clamp(-dot(_6203, _6205), -1.0, 1.0))) - acos(clamp(-dot(_6205, _6199), -1.0, 1.0));
	                                float _6228 = (acos(clamp(-dot(_6199, _6201), -1.0, 1.0)) + acos(clamp(-dot(_6201, _6203), -1.0, 1.0))) - _6226;
	                                if (isnan(_6228))
	                                {
	                                    _628 = 0.0;
	                                }
	                                else
	                                {
	                                    _628 = _6228;
	                                }
	                                float _6236 = (_5313.x * _628) + _6226;
	                                float _6241 = ((cos(_6236) * _6222) - _6203.z) / sin(_6236);
	                                if (_6241 > 0.0)
	                                {
	                                    _629 = 1.0;
	                                }
	                                else
	                                {
	                                    _629 = -1.0;
	                                }
	                                float _6250 = _629;
	                                float _6252 = clamp((1.0 / sqrt((_6241 * _6241) + (_6222 * _6222))) * _6250, -1.0, 1.0);
	                                float _6260 = clamp((-(_6252 * _626)) / sqrt(1.0 - (_6252 * _6252)), _6188, _6190);
	                                float _6263 = sqrt((_6260 * _6260) + (_626 * _626));
	                                float _6264 = _6263 * _6263;
	                                float _6267 = _6189 / sqrt(_6264 + (_6189 * _6189));
	                                float _6274 = _6267 + (_5313.y * ((_6191 / sqrt(_6264 + (_6191 * _6191))) - _6267));
	                                float _6275 = _6274 * _6274;
	                                if (_6275 < 0.99999988079071044921875)
	                                {
	                                    _629 = (_6274 * _6263) / sqrt(1.0 - _6275);
	                                }
	                                else
	                                {
	                                    _629 = _6191;
	                                }
	                                vec3 _6292 = ((_5305 + (_6174 * _6260)) + (_6176 * _629)) + (_627 * _626);
	                                do
	                                {
	                                    if (g_Lights_1._member0[_5384].m_vLightPosition.w == 0.0)
	                                    {
	                                        _625 = vec4(normalize(_6292), uintBitsToFloat(0x7f800000u /* inf */));
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        vec3 _6303 = _6292 - _5305;
	                                        float _6304 = length(_6303);
	                                        _625 = vec4(_6303 / vec3(_6304), _6304);
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                _678 = 1.0 / _628;
	                                _649 = true;
	                                _650 = _625;
	                                break;
	                            }
	                            case 2:
	                            {
	                                do
	                                {
	                                    vec2 _6074 = (_5313 * 2.0) - vec2(1.0);
	                                    if (all(equal(_6074, vec2(0.0))))
	                                    {
	                                        _633 = vec2(0.0);
	                                        break;
	                                    }
	                                    float _6079 = _6074.x;
	                                    float _6081 = _6074.y;
	                                    if (abs(_6079) > abs(_6081))
	                                    {
	                                        _634 = _6079;
	                                        _635 = 0.785398185253143310546875 * (_6081 / _6079);
	                                    }
	                                    else
	                                    {
	                                        _634 = _6081;
	                                        _635 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_6079 / _6081));
	                                    }
	                                    _633 = vec2(cos(_635), sin(_635)) * _634;
	                                    break;
	                                } while(false);
	                                vec3 _6115 = (g_Lights_1._member0[_5384].m_vLuminaireVectors.data[0].xyz + (g_Lights_1._member0[_5384].m_vLuminaireVectors.data[1].xyz * _633.x)) + (g_Lights_1._member0[_5384].m_vLuminaireVectors.data[2].xyz * _633.y);
	                                do
	                                {
	                                    if (g_Lights_1._member0[_5384].m_vLightPosition.w == 0.0)
	                                    {
	                                        _632 = vec4(normalize(_6115), uintBitsToFloat(0x7f800000u /* inf */));
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        vec3 _6126 = _6115 - _5305;
	                                        float _6127 = length(_6126);
	                                        _632 = vec4(_6126 / vec3(_6127), _6127);
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                if (isinf(_632.w))
	                                {
	                                    _630 = true;
	                                }
	                                else
	                                {
	                                    _630 = isnan(_632.w);
	                                }
	                                if (!_630)
	                                {
	                                    _631 = _632.w * _632.w;
	                                }
	                                else
	                                {
	                                    _631 = 1.0;
	                                }
	                                _678 = _631 / (max(0.0, dot(g_Lights_1._member0[_5384].m_vLuminaireVectors.data[3].xyz, -_632.xyz)) * g_Lights_1._member0[_5384].m_vLuminaireVectors.data[1].w);
	                                _649 = true;
	                                _650 = _632;
	                                break;
	                            }
	                            case 3:
	                            {
	                                vec3 _5969 = g_Lights_1._member0[_5384].m_vLuminaireVectors.data[0].xyz - _5305;
	                                float _5970 = dot(_5969, _5969);
	                                float _5971 = sqrt(_5970);
	                                vec3 _5973 = _5969 / vec3(_5971);
	                                float _5974 = _5973.z;
	                                if (_5974 >= 0.0)
	                                {
	                                    _637 = 1.0;
	                                }
	                                else
	                                {
	                                    _637 = -1.0;
	                                }
	                                float _5981 = (-1.0) / (_637 + _5974);
	                                float _5982 = _5973.x;
	                                float _5983 = _5973.y;
	                                float _5985 = (_5982 * _5983) * _5981;
	                                vec3 _5990 = _638;
	                                _5990.x = 1.0 + (((_637 * _5982) * _5982) * _5981);
	                                _5990.y = _637 * _5985;
	                                _5990.z = (-_637) * _5982;
	                                _638 = _5990;
	                                vec3 _5997 = _639;
	                                _5997.x = _5985;
	                                _5997.y = _637 + ((_5983 * _5983) * _5981);
	                                _5997.z = -_5983;
	                                _639 = _5997;
	                                float _6005 = g_Lights_1._member0[_5384].m_vLuminaireVectors.data[1].x * g_Lights_1._member0[_5384].m_vLuminaireVectors.data[1].x;
	                                float _6009 = sqrt(max(0.0, 1.0 - (_6005 / _5970)));
	                                float _6010 = _5313.x;
	                                float _6013 = (1.0 - _6010) + (_6010 * _6009);
	                                float _6017 = sqrt(max(0.0, 1.0 - (_6013 * _6013)));
	                                float _6019 = _5313.y * 6.283185482025146484375;
	                                float _6021 = _5971 * _5971;
	                                float _6027 = (_5971 * _6013) - sqrt(max(0.0, _6005 - ((_6021 * _6017) * _6017)));
	                                float _6033 = ((_6021 + _6005) - (_6027 * _6027)) / ((2.0 * _5971) * g_Lights_1._member0[_5384].m_vLuminaireVectors.data[1].x);
	                                float _6037 = sqrt(max(0.0, 1.0 - (_6033 * _6033)));
	                                vec3 _6049 = g_Lights_1._member0[_5384].m_vLuminaireVectors.data[0].xyz + ((mat3(-_5990, -_5997, -_5973) * vec3(cos(_6019) * _6037, sin(_6019) * _6037, _6033)) * g_Lights_1._member0[_5384].m_vLuminaireVectors.data[1].x);
	                                do
	                                {
	                                    if (g_Lights_1._member0[_5384].m_vLightPosition.w == 0.0)
	                                    {
	                                        _636 = vec4(normalize(_6049), uintBitsToFloat(0x7f800000u /* inf */));
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        vec3 _6060 = _6049 - _5305;
	                                        float _6061 = length(_6060);
	                                        _636 = vec4(_6060 / vec3(_6061), _6061);
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                _678 = 0.15915493667125701904296875 / (1.0 - _6009);
	                                _649 = true;
	                                _650 = _636;
	                                break;
	                            }
	                            case 4:
	                            case 5:
	                            {
	                                vec2 _646 = _5313;
	                                if (_5313.x < g_Lights_1._member0[_5384].m_vLuminaireVectors.data[4].y)
	                                {
	                                    vec2 _5860 = _646;
	                                    _5860.x = clamp(_5860.x / g_Lights_1._member0[_5384].m_vLuminaireVectors.data[4].y, 0.0, 0.99999988079071044921875);
	                                    _646 = _5860;
	                                    vec3 _5866 = normalize(g_Lights_1._member0[_5384].m_vLuminaireVectors.data[0].xyz - g_Lights_1._member0[_5384].m_vLuminaireVectors.data[1].xyz);
	                                    if (_5860.x >= 0.5)
	                                    {
	                                        vec2 _5877 = _646;
	                                        _5877.x = clamp((2.0 * _5877.x) - 1.0, 0.0, 0.99999988079071044921875);
	                                        _646 = _5877;
	                                        _647 = -_5866;
	                                        _648 = g_Lights_1._member0[_5384].m_vLuminaireVectors.data[1].xyz;
	                                    }
	                                    else
	                                    {
	                                        vec2 _5872 = _646;
	                                        _5872.x = clamp(2.0 * _5872.x, 0.0, 0.99999988079071044921875);
	                                        _646 = _5872;
	                                        _647 = _5866;
	                                        _648 = g_Lights_1._member0[_5384].m_vLuminaireVectors.data[0].xyz;
	                                    }
	                                    do
	                                    {
	                                        vec2 _5888 = (_646 * 2.0) - vec2(1.0);
	                                        if (all(equal(_5888, vec2(0.0))))
	                                        {
	                                            _643 = vec2(0.0);
	                                            break;
	                                        }
	                                        float _5893 = _5888.x;
	                                        float _5895 = _5888.y;
	                                        if (abs(_5893) > abs(_5895))
	                                        {
	                                            _644 = _5893;
	                                            _645 = 0.785398185253143310546875 * (_5895 / _5893);
	                                        }
	                                        else
	                                        {
	                                            _644 = _5895;
	                                            _645 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_5893 / _5895));
	                                        }
	                                        _643 = vec2(cos(_645), sin(_645)) * _644;
	                                        break;
	                                    } while(false);
	                                    _648 += ((g_Lights_1._member0[_5384].m_vLuminaireVectors.data[2].xyz * _643.x) + (g_Lights_1._member0[_5384].m_vLuminaireVectors.data[3].xyz * _643.y));
	                                }
	                                else
	                                {
	                                    vec2 _5839 = _646;
	                                    _5839.x = clamp((_5839.x - g_Lights_1._member0[_5384].m_vLuminaireVectors.data[4].y) / (1.0 - g_Lights_1._member0[_5384].m_vLuminaireVectors.data[4].y), 0.0, 0.99999988079071044921875);
	                                    _646 = _5839;
	                                    vec3 _5854 = (g_Lights_1._member0[_5384].m_vLuminaireVectors.data[2].xyz * cos(_5839.x * 6.283185482025146484375)) + (g_Lights_1._member0[_5384].m_vLuminaireVectors.data[3].xyz * sin(_5839.x * 6.283185482025146484375));
	                                    _647 = normalize(_5854);
	                                    _648 = mix(g_Lights_1._member0[_5384].m_vLuminaireVectors.data[0].xyz, g_Lights_1._member0[_5384].m_vLuminaireVectors.data[1].xyz, vec3(_5839.y)) + _5854;
	                                }
	                                do
	                                {
	                                    if (g_Lights_1._member0[_5384].m_vLightPosition.w == 0.0)
	                                    {
	                                        _642 = vec4(normalize(_648), uintBitsToFloat(0x7f800000u /* inf */));
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        vec3 _5931 = _648 - _5305;
	                                        float _5932 = length(_5931);
	                                        _642 = vec4(_5931 / vec3(_5932), _5932);
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                if (isinf(_642.w))
	                                {
	                                    _640 = true;
	                                }
	                                else
	                                {
	                                    _640 = isnan(_642.w);
	                                }
	                                if (!_640)
	                                {
	                                    _641 = _642.w * _642.w;
	                                }
	                                else
	                                {
	                                    _641 = 1.0;
	                                }
	                                _678 = _641 / (max(0.0, dot(_647, -_642.xyz)) * g_Lights_1._member0[_5384].m_vLuminaireVectors.data[1].w);
	                                _649 = true;
	                                _650 = _642;
	                                break;
	                            }
	                            default:
	                            {
	                                _678 = 0.0;
	                                _649 = true;
	                                _650 = vec4(uintBitsToFloat(0x7fc00000u /* nan */));
	                                break;
	                            }
	                        }
	                        if (_649)
	                        {
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    vec3 _6339 = _662 * (3.1415927410125732421875 / _678);
	                    bool _6344 = !(dot(_484, _650.xyz) > 0.0);
	                    if (!((g_Lights_1._member0[_5384].m_nPathTraceFlags & 8) != 0))
	                    {
	                        vec3 _6355 = abs(_6339);
	                        float _6360 = max(_6355.x, max(_6355.y, _6355.z));
	                        vec3 _6365 = clamp(_6339 / vec3(_6360), vec3(-1.0), vec3(1.0)) * clamp(_6360, -100.0, 100.0);
	                        float _6366 = dot(_650.xyz, vec3(_341));
	                        if (_6344)
	                        {
	                            _679 = -_6366;
	                            _675 = _6365 * vTransmissiveRatio;
	                        }
	                        else
	                        {
	                            _679 = _6366;
	                            _675 = _6365;
	                        }
	                        vec4 _6372 = _504;
	                        vec3 _6379 = _6372.xyz + ((_675 * max(0.0, _679)) * 0.3183098733425140380859375);
	                        vec4 _6381 = _6372;
	                        _6381.x = _6379.x;
	                        _6381.y = _6379.y;
	                        _6381.z = _6379.z;
	                        vec3 _6387 = _6381.xyz + vec3(0.0);
	                        vec4 _6389 = _6381;
	                        _6389.x = _6387.x;
	                        _6389.y = _6387.y;
	                        _6389.z = _6387.z;
	                        _504 = _6389;
	                        if (_679 > 0.0)
	                        {
	                            vec4 _6397 = _680;
	                            _6397.x = 0.2820948064327239990234375;
	                            _6397.y = (-0.48860251903533935546875) * _650.y;
	                            _6397.z = 0.48860251903533935546875 * _650.z;
	                            _6397.w = (-0.48860251903533935546875) * _650.x;
	                            _680 = _6397;
	                            vec4 _6410 = _681;
	                            _6410.x = (1.09254848957061767578125 * _650.x) * _650.y;
	                            _6410.y = ((-1.09254848957061767578125) * _650.y) * _650.z;
	                            _6410.z = 0.3153915703296661376953125 * (((3.0 * _650.z) * _650.z) - 1.0);
	                            _6410.w = ((-1.09254848957061767578125) * _650.x) * _650.z;
	                            _681 = _6410;
	                            _503 += (_6397 * _675.x);
	                            _500 += (_6410 * _675.x);
	                            _502 += (_6397 * _675.y);
	                            _499 += (_6410 * _675.y);
	                            _501 += (_6397 * _675.z);
	                            _498 += (_6410 * _675.z);
	                            vec4 _6449 = _497;
	                            vec3 _6452 = _6449.xyz + (_675 * (0.546274244785308837890625 * ((_650.x * _650.x) - (_650.y * _650.y))));
	                            vec4 _6454 = _6449;
	                            _6454.x = _6452.x;
	                            _6454.y = _6452.y;
	                            _6454.z = _6452.z;
	                            _497 = _6454;
	                        }
	                        _673 = _5386;
	                        continue;
	                    }
	                    if (_6344)
	                    {
	                        _682 = !_664;
	                    }
	                    else
	                    {
	                        _682 = false;
	                    }
	                    if (_682)
	                    {
	                        _673 = _5386;
	                        continue;
	                    }
	                    float _6472 = max(_6339.x, max(_6339.y, _6339.z));
	                    float _683 = _663.x;
	                    do
	                    {
	                        float _6477 = _666;
	                        float _6478 = _6477 + _6472;
	                        _666 = _6478;
	                        if (_6478 == 0.0)
	                        {
	                            _622 = false;
	                            break;
	                        }
	                        float _6483 = _6472 / _666;
	                        do
	                        {
	                            if (_6483 <= 0.0)
	                            {
	                                _623 = false;
	                                break;
	                            }
	                            if (_6483 >= 1.0)
	                            {
	                                _623 = true;
	                                break;
	                            }
	                            if (_683 < _6483)
	                            {
	                                _683 = min(_683 / _6483, 0.99999988079071044921875);
	                                _623 = true;
	                                break;
	                            }
	                            _683 = min((_683 - _6483) / (1.0 - _6483), 0.99999988079071044921875);
	                            _623 = false;
	                            break;
	                        } while(false);
	                        _622 = _623;
	                        break;
	                    } while(false);
	                    vec2 _6508 = _663;
	                    _6508.x = _683;
	                    _663 = _6508;
	                    if (_622)
	                    {
	                        _665 = _650;
	                        _677 = int(_5384);
	                        _672 = _6472;
	                        _676 = _6344;
	                        _674 = _6339;
	                    }
	                    _673 = _5386;
	                    continue;
	                }
	                _668 = _677;
	                _669 = _672;
	                _667 = _676;
	                _670++;
	                _671 = _674;
	                continue;
	            }
	            bool _6523 = any(notEqual(_671, vec3(0.0)));
	            if (_668 != (-1))
	            {
	                _664 = _6523;
	            }
	            else
	            {
	                _664 = false;
	            }
	            if (_664)
	            {
	                vec3 _6537 = _671;
	                vec3 _6538 = _6537 * (_666 / _669);
	                bool _620;
	                if (isinf(_665.w))
	                {
	                    _620 = true;
	                }
	                else
	                {
	                    _620 = isnan(_665.w);
	                }
	                float _621;
	                if (!_620)
	                {
	                    _621 = _665.w;
	                }
	                else
	                {
	                    _621 = 56755.83984375;
	                }
	                vec4 _6555 = _665;
	                _6555.w = _621;
	                _665 = _6555;
	                float _619;
	                do
	                {
	                    float _6564 = dot(_6555.xyz, g_Lights_1._member0[_668].m_vNearPlane.xyz);
	                    if (_6564 == 0.0)
	                    {
	                        _619 = 0.0;
	                        break;
	                    }
	                    _619 = (g_Lights_1._member0[_668].m_vNearPlane.w - dot(_5305, g_Lights_1._member0[_668].m_vNearPlane.xyz)) * (1.0 / _6564);
	                    break;
	                } while(false);
	                if (_619 > 0.0)
	                {
	                    vec4 _6576 = _665;
	                    _6576.w = min(_6576.w, _619);
	                    _665 = _6576;
	                }
	                if (_667)
	                {
	                    _674 = _507;
	                }
	                else
	                {
	                    _674 = _508;
	                }
	                vec4 _6584 = _665;
	                vec3 _6586 = _674 - _5305;
	                _6584.w = _6584.w + dot(_6584.xyz, _6586);
	                vec3 _6596 = normalize((_6584.xyz * _6584.w) + _6586);
	                vec4 _6598 = _6584;
	                _6598.x = _6596.x;
	                _6598.y = _6596.y;
	                _6598.z = _6596.z;
	                _665 = _6598;
	                if (false)
	                {
	                    _673 = 8u;
	                }
	                else
	                {
	                    _673 = 2u;
	                }
	                uint _618;
	                do
	                {
	                    int _6612 = int(g_SceneGlobalInfo._member0[0].m_nSceneGlobalInfoFlags);
	                    if ((_6612 & 1) != 0)
	                    {
	                        _618 = 32u;
	                        break;
	                    }
	                    if ((_6612 & 2) != 0)
	                    {
	                        _618 = 16u;
	                        break;
	                    }
	                    _618 = 0u;
	                    break;
	                } while(false);
	                vec3 _604 = _674;
	                float _603 = 0.0;
	                vec3 _602 = _665.xyz;
	                float _617;
	                if (_6523)
	                {
	                    _617 = _665.w;
	                }
	                else
	                {
	                    _617 = 0.0;
	                }
	                p_1 = PayloadShadow_t(1.0);
	                traceRayEXT(g_AccelStruct, _618, _673, 1u, 2u, 1u, _604, _603, _602, _617, 1);
	                if (_6523)
	                {
	                    _617 = p_1.m_flVisibility;
	                }
	                else
	                {
	                    _617 = 0.0;
	                }
	                vec4 _6648 = _303[g_Lights_1._member0[_668].m_nBakedShadowIndex + 1] * dot(_6538.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                _496 += (_6648 * _617);
	                _495 += _6648;
	                _494 = mix(_494, ivec4(g_Lights_1._member0[_668].m_nShadowedLightId), notEqual(_6648, vec4(0.0)));
	                if (g_Lights_1._member0[_668].m_nBakedShadowIndex == (-1))
	                {
	                    if (_667)
	                    {
	                        f16vec4 _601 = _339;
	                        bool _615;
	                        if ((_340 & 65535u) == 2u)
	                        {
	                            _615 = float(_601.x) > 0.0;
	                        }
	                        else
	                        {
	                            _615 = false;
	                        }
	                        _664 = _615;
	                    }
	                    else
	                    {
	                        _664 = false;
	                    }
	                    if (_664)
	                    {
	                        f16vec4 _479 = _339;
	                        uint _6691 = uint(_339.w);
	                        float _6696 = pow(saturate(-dot(normalize(_484 + vec3(_341)), _665.xyz)), 2.0);
	                        f16vec3 _6697 = f16vec3(vec3(0.0));
	                        vec3 _609;
	                        bool _611;
	                        if (isinf(_665.w))
	                        {
	                            _611 = true;
	                        }
	                        else
	                        {
	                            _611 = isnan(_665.w);
	                        }
	                        float _612;
	                        if (!_611)
	                        {
	                            _612 = _665.w;
	                        }
	                        else
	                        {
	                            _612 = 1000.0;
	                        }
	                        vec3 _608 = _508 + (_665.xyz * _612);
	                        float _607 = 0.0;
	                        vec3 _606 = -_665.xyz;
	                        float _613;
	                        if (_6696 > 0.0)
	                        {
	                            _613 = _612;
	                        }
	                        else
	                        {
	                            _613 = 0.0;
	                        }
	                        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _609, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_6697, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _6697, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                        traceRayEXT(g_AccelStruct, 16u, 1u, 0u, 2u, 0u, _608, _607, _606, _613, 0);
	                        float _614;
	                        if (p.nInstance != (-1))
	                        {
	                            f16vec4 _605 = p.material.vMaterialBits;
	                            bool _610;
	                            if ((p.material.nMaterialTypeAndFlags & 65535u) == 2u)
	                            {
	                                _610 = float(_605.x) > 0.0;
	                            }
	                            else
	                            {
	                                _610 = false;
	                            }
	                            if (!_610)
	                            {
	                                _613 = 0.0;
	                            }
	                            else
	                            {
	                                _613 = _6696;
	                            }
	                            _614 = _612 - p.flHitT;
	                        }
	                        else
	                        {
	                            _613 = _6696;
	                            _614 = _612;
	                        }
	                        float _6762 = _614 * float(_479.x);
	                        _671 = vec3(0.0);
	                        _675 = ((exp2(SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_6691].m_vTransmissiveLogColor.xyz * (1.0 + (_6762 * SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_6691].m_fTransmissiveSaturation))) * exp(-_6762)) * _613) * _6538;
	                    }
	                    else
	                    {
	                        _671 = _6538;
	                        _675 = vec3(0.0);
	                    }
	                    vec3 _6783 = _671;
	                    vec3 _6784 = _6783 * _617;
	                    vec3 _6788 = abs(_6784);
	                    float _6793 = max(_6788.x, max(_6788.y, _6788.z));
	                    vec3 _6798 = clamp(_6784 / vec3(_6793), vec3(-1.0), vec3(1.0)) * clamp(_6793, -100.0, 100.0);
	                    vec3 _6800 = abs(_675);
	                    float _6805 = max(_6800.x, max(_6800.y, _6800.z));
	                    float _6811 = dot(_665.xyz, vec3(_341));
	                    if (_667)
	                    {
	                        _672 = -_6811;
	                        _671 = _6798 * vTransmissiveRatio;
	                    }
	                    else
	                    {
	                        _672 = _6811;
	                        _671 = _6798;
	                    }
	                    vec4 _6818 = _504;
	                    vec3 _6825 = _6818.xyz + ((_671 * max(0.0, _672)) * 0.3183098733425140380859375);
	                    vec4 _6827 = _6818;
	                    _6827.x = _6825.x;
	                    _6827.y = _6825.y;
	                    _6827.z = _6825.z;
	                    vec3 _6833 = _6827.xyz + (clamp(_675 / vec3(_6805), vec3(-1.0), vec3(1.0)) * clamp(_6805, -100.0, 100.0));
	                    vec4 _6835 = _6827;
	                    _6835.x = _6833.x;
	                    _6835.y = _6833.y;
	                    _6835.z = _6833.z;
	                    _504 = _6835;
	                    if (_672 > 0.0)
	                    {
	                        vec4 _684;
	                        vec4 _6843 = _684;
	                        _6843.x = 0.2820948064327239990234375;
	                        _6843.y = (-0.48860251903533935546875) * _665.y;
	                        _6843.z = 0.48860251903533935546875 * _665.z;
	                        _6843.w = (-0.48860251903533935546875) * _665.x;
	                        _684 = _6843;
	                        vec4 _685;
	                        vec4 _6856 = _685;
	                        _6856.x = (1.09254848957061767578125 * _665.x) * _665.y;
	                        _6856.y = ((-1.09254848957061767578125) * _665.y) * _665.z;
	                        _6856.z = 0.3153915703296661376953125 * (((3.0 * _665.z) * _665.z) - 1.0);
	                        _6856.w = ((-1.09254848957061767578125) * _665.x) * _665.z;
	                        _685 = _6856;
	                        _503 += (_6843 * _671.x);
	                        _500 += (_6856 * _671.x);
	                        _502 += (_6843 * _671.y);
	                        _499 += (_6856 * _671.y);
	                        _501 += (_6843 * _671.z);
	                        _498 += (_6856 * _671.z);
	                        vec4 _6895 = _497;
	                        vec3 _6898 = _6895.xyz + (_671 * (0.546274244785308837890625 * ((_665.x * _665.x) - (_665.y * _665.y))));
	                        vec4 _6900 = _6895;
	                        _6900.x = _6898.x;
	                        _6900.y = _6898.y;
	                        _6900.z = _6898.z;
	                        _497 = _6900;
	                    }
	                }
	            }
	            float _6912 = sqrt(vSeed.y);
	            float _6914 = 6.283185482025146484375 * vSeed.x;
	            p_1 = PayloadShadow_t(1.0);
	            traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _508, 0.0, mat3(_398, _397, vec3(_348)) * vec3(cos(_6914) * _6912, sin(_6914) * _6912, sqrt(max(0.0, 1.0 - vSeed.y))), 16.0, 1);
	            vec4 _6930 = _491;
	            _6930.x = _6930.x + p_1.m_flVisibility;
	            _491 = _6930;
	        }
	        vec4 _6934 = _504;
	        _6934.w = 1.0;
	        _504 = _6934;
	        if (g_PushConstants.m_nEstimate_DimensionCount.x > 0)
	        {
	            vec4 _6957 = g_Luxels._member0[_883].vIrradiance_flSampleCount;
	            float _6986 = 1.0 / (1.0 + _6957.w);
	            vec3 _6990 = mix(_6957.xyz, _504.xyz, vec3(_6986));
	            vec4 _6992 = _6957;
	            _6992.x = _6990.x;
	            _6992.y = _6990.y;
	            _6992.z = _6990.z;
	            vec4 _6997 = vec4(_6986);
	            _6992.w = _6992.w + 1.0;
	            _504 = _6992;
	            _503 = mix(g_Luxels._member0[_883].vShr, _503, _6997);
	            _502 = mix(g_Luxels._member0[_883].vShg, _502, _6997);
	            _501 = mix(g_Luxels._member0[_883].vShb, _501, _6997);
	            _500 = mix(g_Luxels._member0[_883].vQuadraticr, _500, _6997);
	            _499 = mix(g_Luxels._member0[_883].vQuadraticg, _499, _6997);
	            _498 = mix(g_Luxels._member0[_883].vQuadraticb, _498, _6997);
	            _497 = mix(g_Luxels._member0[_883].vQuadraticFinalrgb, _497, _6997);
	            _496 = mix(g_Luxels._member0[_883].vBakedShadow, _496, _6997);
	            _495 = mix(g_Luxels._member0[_883].vBakedShadowUnoccluded, _495, _6997);
	            _494 = mix(_494, g_Luxels._member0[_883].vBakedShadowLightId, notEqual(g_Luxels._member0[_883].vBakedShadowLightId, ivec4(255)));
	            _493 = mix(g_Luxels._member0[_883].vTangent, _493, _6997);
	            _492 = mix(g_Luxels._member0[_883].vNormal, _492, _6997);
	            _491 = mix(g_Luxels._member0[_883].flAmbientOcclusion_vPadding, _491, _6997);
	        }
	        g_Luxels._member0[_883].vIrradiance_flSampleCount = _504;
	        g_Luxels._member0[_883].vShr = _503;
	        g_Luxels._member0[_883].vShg = _502;
	        g_Luxels._member0[_883].vShb = _501;
	        g_Luxels._member0[_883].vQuadraticr = _500;
	        g_Luxels._member0[_883].vQuadraticg = _499;
	        g_Luxels._member0[_883].vQuadraticb = _498;
	        g_Luxels._member0[_883].vQuadraticFinalrgb = _497;
	        g_Luxels._member0[_883].vBakedShadow = _496;
	        g_Luxels._member0[_883].vBakedShadowUnoccluded = _495;
	        g_Luxels._member0[_883].vBakedShadowLightId = _494;
	        g_Luxels._member0[_883].vTangent = _493;
	        g_Luxels._member0[_883].vNormal = _492;
	        g_Luxels._member0[_883].flAmbientOcclusion_vPadding = _491;
	        break;
	    } while(false);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
