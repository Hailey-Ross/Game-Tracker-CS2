//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "General shaders for baked lighting preview in Hammer";
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
	
	struct VertexLightSample_t_natural
	{
	    vec4 vIrradiance_flSampleCount;
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
	
	float _282;
	vec4 _283;
	
	layout(set = 6, binding = 160, std430) buffer RWStructuredBuffer
	{
	    VertexLightSample_t_natural _member0[];
	} g_Samples;
	
	layout(set = 3, binding = 37, std430) readonly buffer StructuredBuffer
	{
	    layout(row_major) SceneGlobalInfoGPU_t_natural _member0[];
	} g_SceneGlobalInfo;
	
	layout(set = 6, binding = 158, std430) buffer g_Triangles
	{
	    float _member0[];
	} g_Triangles_1;
	
	layout(set = 3, binding = 35, std430) readonly buffer g_instanceBuffer
	{
	    PackedRtxInstanceData_t_natural _member0[];
	} g_instanceBuffer_1;
	
	layout(set = 6, binding = 161, std430) buffer g_LightBins
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
	
	layout(push_constant, std430) uniform VertexLightPushConstants_t_natural
	{
	    ivec4 m_nEstimate_nDimensionCount_nVertexStride_nMinSamples;
	    ivec4 m_nTriangleCount_Unused0;
	    vec4 m_vCordonMins;
	    vec4 m_vCordonMaxs;
	} g_PushConstants;
	
	layout(set = 6, binding = 159, r32ui) uniform readonly uimage3D g_TrianglesConverged;
	layout(set = 6, binding = 162) uniform readonly image3D g_RandomSamples;
	layout(location = 0) rayPayloadEXT Payload_t p;
	layout(set = 3, binding = 30) uniform accelerationStructureEXT g_AccelStruct;
	layout(set = 4, binding = 46) uniform textureCube g_bindless_TextureCube[65536];
	layout(set = 3, binding = 14) uniform sampler g_Sampler;
	layout(location = 1) rayPayloadEXT PayloadShadow_t p_1;
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D[65536];
	layout(set = 3, binding = 15) uniform sampler g_CookieSampler;
	
	void main()
	{
	    bool _562 = false;
	    bool _616 = false;
	    do
	    {
	        uvec2 vTriangle = gl_LaunchIDEXT.xy / uvec2(4u);
	        uint nSampleIndex = (gl_LaunchIDEXT.x + (gl_LaunchIDEXT.y * gl_LaunchSizeEXT.x)) + ((gl_LaunchIDEXT.z * gl_LaunchSizeEXT.x) * gl_LaunchSizeEXT.y);
	        int nTriangle = int(vTriangle.x + ((gl_LaunchSizeEXT.x / 4u) * vTriangle.y));
	        if (nTriangle >= g_PushConstants.m_nTriangleCount_Unused0.x)
	        {
	            break;
	        }
	        vec2 _703 = (vec2((gl_LaunchIDEXT.xy - (vTriangle.xy * uvec2(4u))).xy) + vec2(0.5)) * vec2(0.25);
	        float _705 = sqrt(_703.x);
	        vec3 _710 = vec3(1.0 - _705, _705 * (1.0 - _703.y), _282);
	        if (g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.x == 0)
	        {
	            g_Samples._member0[nSampleIndex].vIrradiance_flSampleCount = vec4(0.0);
	        }
	        else
	        {
	            if (imageLoad(g_TrianglesConverged, ivec3(ivec2(vTriangle), 0)).x != 0u)
	            {
	                break;
	            }
	        }
	        uvec3 _733 = uvec3(imageSize(g_RandomSamples));
	        ivec3 _670;
	        ivec3 _736 = _670;
	        _736.x = int(_733.x);
	        _736.y = int(_733.y);
	        _736.z = int(_733.z);
	        _670 = _736;
	        ivec2 _745 = ivec2(gl_LaunchIDEXT.xy) - _736.xy * (ivec2(gl_LaunchIDEXT.xy) / _736.xy);
	        uvec3 _767 = uvec3(g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount.xyz);
	        vec3 _770 = vec3(_767) / (g_SceneGlobalInfo._member0[0].m_vLocalLightMaxBounds.xyz - g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds.xyz);
	        int _773 = 3 * nTriangle;
	        vec3 v0 = vec3(g_Triangles_1._member0[_773 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z], g_Triangles_1._member0[(_773 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 1], g_Triangles_1._member0[(_773 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 2]);
	        int _791 = _773 + 1;
	        vec3 v1 = vec3(g_Triangles_1._member0[_791 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z], g_Triangles_1._member0[(_791 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 1], g_Triangles_1._member0[(_791 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 2]);
	        int _809 = _773 + 2;
	        vec3 v2 = vec3(g_Triangles_1._member0[_809 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z], g_Triangles_1._member0[(_809 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 1], g_Triangles_1._member0[(_809 * g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.z) + 2]);
	        vec3 _830 = normalize(cross(v1 - v0, v2 - v0));
	        float _831 = _710.x;
	        float _833 = _710.y;
	        vec3 _839 = ((v0 * ((1.0 - _831) - _833)) + (v1 * _831)) + (v2 * _833);
	        f16vec3 _291 = f16vec3(_830);
	        vec3 _417 = _830;
	        vec3 _334;
	        vec3 _671 = _334;
	        vec3 _333;
	        vec3 _672 = _333;
	        float _843 = _830.z;
	        float _669;
	        if (_843 >= 0.0)
	        {
	            _669 = 1.0;
	        }
	        else
	        {
	            _669 = -1.0;
	        }
	        float _850 = (-1.0) / (_669 + _843);
	        float _851 = _830.x;
	        float _852 = _830.y;
	        float _854 = (_851 * _852) * _850;
	        vec3 _859 = _671;
	        _859.x = 1.0 + (((_669 * _851) * _851) * _850);
	        _859.y = _669 * _854;
	        _859.z = (-_669) * _851;
	        _671 = _859;
	        vec3 _866 = _672;
	        _866.x = _854;
	        _866.y = _669 + ((_852 * _852) * _850);
	        _866.z = -_852;
	        _672 = _866;
	        _334 = _859;
	        _333 = _866;
	        f16vec3 _289 = f16vec3(vec3(1.0));
	        float _876 = abs(1.0);
	        vec3 _881 = _839 + (_830 * ((abs(_839) + vec3(_876)) * 9.9999997473787516355514526367188e-05));
	        vec3 _419 = _881;
	        vec2 _886 = imageLoad(g_RandomSamples, ivec3(_745.xy, 1)).xy;
	        bool _673;
	        if (all(greaterThanEqual(_881.xyz, g_PushConstants.m_vCordonMins.xyz)))
	        {
	            _673 = all(lessThanEqual(_419.xyz, g_PushConstants.m_vCordonMaxs.xyz));
	        }
	        else
	        {
	            _673 = false;
	        }
	        vec3 vIrradiance;
	        if (_673)
	        {
	            vec3 _330;
	            float _331;
	            float _332;
	            f16vec4 _285;
	            uint _286;
	            float16_t _287;
	            float16_t _288;
	            float16_t _290;
	            int _416;
	            vec3 _418;
	            ivec2 _415 = _745;
	            uint _414 = uint(g_PushConstants.m_nEstimate_nDimensionCount_nVertexStride_nMinSamples.y);
	            uint _413 = uint(max(1, ((g_SceneGlobalInfo._member0[0].m_vLightBinCellCount_nLightCount.w + 31) / 32)));
	            uvec3 _412 = _767;
	            vec3 _411 = (-g_SceneGlobalInfo._member0[0].m_vLocalLightMinBounds.xyz) * _770;
	            vec3 _410 = _770;
	            float _923 = _886.y;
	            float _924 = sqrt(_923);
	            float _926 = 6.283185482025146484375 * _886.x;
	            vec3 _934 = vec3(cos(_926) * _924, sin(_926) * _924, sqrt(max(0.0, 1.0 - _923)));
	            vec3 _937 = vec3(_291);
	            vec3 _939 = mat3(_334, _333, _937) * _934;
	            vec3 _658 = _939;
	            vec3 _447 = _419;
	            vec3 _446 = _418;
	            vec3 _445 = _417;
	            int _444 = _416;
	            f16vec3 _313 = _291;
	            float16_t _312 = _290;
	            f16vec3 _311 = _289;
	            float16_t _310 = _288;
	            float16_t _309 = _287;
	            uint _308 = _286;
	            f16vec4 _307 = _285;
	            vec3 _370 = _334;
	            vec3 _369 = _333;
	            float _368 = _332;
	            float _367 = _331;
	            vec3 _366 = _330;
	            int _659 = 1;
	            vec3 _660 = vec3(1.0 / (_934.z * 0.3183098733425140380859375));
	            vec3 _661 = vec3(0.0);
	            vec3 _448;
	            vec3 _464;
	            vec3 _494;
	            bool _499;
	            float _500;
	            bool _501;
	            vec3 _502;
	            bool _503;
	            vec3 _504;
	            vec3 _505;
	            float _506;
	            float _507;
	            bool _508;
	            vec3 _509;
	            bool _510;
	            vec3 _511;
	            bool _514;
	            bool _515;
	            bool _516;
	            float _517;
	            uint _518;
	            float _519;
	            bool _520;
	            float _521;
	            bool _522;
	            bool _523;
	            float _524;
	            float _525;
	            float _526;
	            bool _527;
	            float _528;
	            bool _529;
	            vec3 _530;
	            bool _531;
	            vec3 _532;
	            vec3 _533;
	            bool _534;
	            bool _535;
	            float _536;
	            vec4 _537;
	            vec4 _538;
	            float _539;
	            vec3 _540;
	            float _541;
	            float _542;
	            bool _543;
	            float _544;
	            vec4 _545;
	            vec2 _546;
	            float _547;
	            float _548;
	            vec4 _549;
	            float _550;
	            vec3 _551;
	            vec3 _552;
	            bool _553;
	            float _554;
	            vec4 _555;
	            vec2 _556;
	            float _557;
	            float _558;
	            vec3 _560;
	            vec3 _561;
	            vec4 _563;
	            float _564;
	            float _565;
	            vec3 _566;
	            vec3 _567;
	            float _568;
	            float _569;
	            bool _570;
	            vec3 _571;
	            vec3 _572;
	            bool _573;
	            bool _574;
	            vec3 _575;
	            float _582;
	            bool _584;
	            float _585;
	            bool _586;
	            vec3 _587;
	            bool _588;
	            vec3 _589;
	            vec3 _590;
	            vec4 _591;
	            vec4 _592;
	            float _593;
	            vec3 _594;
	            float _595;
	            float _596;
	            bool _597;
	            float _598;
	            vec4 _599;
	            vec2 _600;
	            float _601;
	            float _602;
	            vec4 _603;
	            float _604;
	            vec3 _605;
	            vec3 _606;
	            bool _607;
	            float _608;
	            vec4 _609;
	            vec2 _610;
	            float _611;
	            float _612;
	            vec3 _614;
	            vec3 _615;
	            vec4 _617;
	            float _618;
	            float _619;
	            vec3 _620;
	            vec3 _621;
	            float _622;
	            float _623;
	            bool _624;
	            vec3 _625;
	            vec3 _626;
	            bool _627;
	            bool _628;
	            vec3 _629;
	            float _634;
	            bool _635;
	            bool _636;
	            bool _637;
	            vec3 _639;
	            float _641;
	            float _642;
	            bool _645;
	            float _646;
	            float _647;
	            bool _650;
	            bool _651;
	            vec3 _652;
	            bool _654;
	            vec3 _656;
	            vec3 _657;
	            vec3 _662;
	            float _663;
	            float _666;
	            vec3 _668;
	            SPIRV_CROSS_LOOP
	            for (;;)
	            {
	                if (!(_659 <= 16))
	                {
	                    break;
	                }
	                SPIRV_CROSS_FLATTEN
	                if (false)
	                {
	                    SPIRV_CROSS_FLATTEN
	                    if (_659 > (-1))
	                    {
	                        _663 = 1.0;
	                        _662 = vec3(0.0);
	                    }
	                    else
	                    {
	                        if (_659 != (-1))
	                        {
	                            _663 = 0.0;
	                        }
	                        else
	                        {
	                            _663 = 1.0;
	                        }
	                        _662 = _660;
	                    }
	                }
	                else
	                {
	                    _663 = 1.0;
	                    _662 = _660;
	                }
	                if (all(equal(_662, vec3(0.0))))
	                {
	                    break;
	                }
	                vec3 _443 = _447;
	                vec3 _442 = _658;
	                vec2 _983 = imageLoad(g_RandomSamples, ivec3(_415.xy, int(1u + uint(_659)))).xy;
	                f16vec3 _985 = f16vec3(vec3(0.0));
	                vec2 _991 = _983;
	                _991.y = 0.0;
	                p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _448, 3.4028234663852885981170418348452e+38, _983.y, -1, false, MaterialDataMinimal_t(_985, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _985, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                traceRayEXT(g_AccelStruct, 0u, 4u, 0u, 2u, 0u, _447, 0.0, _658, 56755.83984375, 0);
	                float _1025 = p.flHitT;
	                vec2 _1026 = _983;
	                _1026.y = p.flOpacityRng;
	                vec2 _664 = _1026;
	                if (!(p.nInstance != (-1)))
	                {
	                    vec2 _1041 = imageLoad(g_RandomSamples, ivec3(_415.xy, int(1u + uint(_659 + 1)))).xy;
	                    _664 = _1041;
	                    do
	                    {
	                        vec2 _653 = _1041;
	                        if ((g_SceneGlobalInfo._member0[0].m_nSkyLightFlags & 1u) == 0u)
	                        {
	                            _652 = vec3(0.0);
	                            break;
	                        }
	                        if (_658.z < 0.0)
	                        {
	                            float _655 = _653.y;
	                            do
	                            {
	                                if (g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w <= 0.0)
	                                {
	                                    _651 = false;
	                                    break;
	                                }
	                                if (g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w >= 1.0)
	                                {
	                                    _651 = true;
	                                    break;
	                                }
	                                if (_655 < g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w)
	                                {
	                                    _655 = min(_655 / g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w, 0.99999988079071044921875);
	                                    _651 = true;
	                                    break;
	                                }
	                                _655 = min((_655 - g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w) / (1.0 - g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.w), 0.99999988079071044921875);
	                                _651 = false;
	                                break;
	                            } while(false);
	                            vec2 _1086 = _653;
	                            _1086.y = _655;
	                            _653 = _1086;
	                            _654 = _651;
	                        }
	                        else
	                        {
	                            _654 = false;
	                        }
	                        if (_654)
	                        {
	                            float _1094 = sqrt(_653.y);
	                            float _1096 = 6.283185482025146484375 * _653.x;
	                            _656 = vec3(cos(_1096) * _1094, sin(_1096) * _1094, sqrt(max(0.0, 1.0 - _653.y)));
	                            _657 = g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance.xyz;
	                        }
	                        else
	                        {
	                            _656 = _658;
	                            _657 = vec3(0.0);
	                        }
	                        if (g_SceneGlobalInfo._member0[0].m_nIBLCubeMap >= 0)
	                        {
	                            vec4 _1141 = textureLod(samplerCube(g_bindless_TextureCube[g_SceneGlobalInfo._member0[0].m_nIBLCubeMap], g_Sampler), normalize(g_SceneGlobalInfo._member0[0].m_mIBLTransformI * vec4(_656, 0.0)), 0.0);
	                            if (dot(_1141.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) < g_SceneGlobalInfo._member0[0].m_vSunLightIrradiance.w)
	                            {
	                                _657 += (g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale.xyz * _1141.xyz);
	                            }
	                        }
	                        else
	                        {
	                            _657 += g_SceneGlobalInfo._member0[0].m_vSkyColor.xyz;
	                        }
	                        if (_659 > 1)
	                        {
	                            _657 *= g_SceneGlobalInfo._member0[0].m_vIBLCubeMapScale.w;
	                        }
	                        if (_654)
	                        {
	                            _657 *= g_SceneGlobalInfo._member0[0].m_vSkyAmbientBounce.xyz;
	                        }
	                        _652 = _657;
	                        break;
	                    } while(false);
	                    _661 += ((_662 * _652) * _663);
	                    break;
	                }
	                uint _449 = g_instanceBuffer_1._member0[uint(p.nInstance)].nMaterialFlags_nInstanceFlags;
	                if ((int((_449 >> uint(16)) & 65535u) & 4) != 0)
	                {
	                    break;
	                }
	                vec3 _437 = _443;
	                vec3 _436 = _442;
	                vec3 _435 = p.vSmoothPositionWs;
	                vec3 _434 = p.vFaceNormalWs;
	                float _433 = p.flHitT;
	                f16vec3 _360 = p.material.vNormalWs;
	                float16_t _359 = p.material.flMetalness;
	                f16vec3 _358 = p.material.vAlbedo;
	                float16_t _357 = p.material.flRoughness;
	                f16vec3 _356 = p.material.vEmissive;
	                float16_t _355 = p.material.flReflectance;
	                uint _354 = p.material.nMaterialTypeAndFlags;
	                f16vec4 _353 = p.material.vMaterialBits;
	                uint _1193 = uint(p.nInstance);
	                uint _455 = g_instanceBuffer_1._member0[_1193].nMaterialFlags_nInstanceFlags;
	                float _454 = g_instanceBuffer_1._member0[_1193].fEmissiveBoost;
	                vec3 _453 = (_437 + (_436 * _433)) + (_434 * ((abs(_437) + vec3(abs(_433))) * 9.9999997473787516355514526367188e-05));
	                vec3 _452 = (_437 + (_436 * _433)) + ((-_434) * ((abs(_437) + vec3(abs(_433))) * 9.9999997473787516355514526367188e-05));
	                vec3 _451 = _434;
	                int _450 = int(_455 & 65535u);
	                vec3 _460 = vec3(0.0);
	                vec3 _459 = vec3(0.0);
	                float _458 = 0.0;
	                float _457 = 0.0;
	                vec3 _456 = vec3(0.0);
	                f16vec3 _383 = _360;
	                float16_t _382 = _359;
	                f16vec3 _381 = _358;
	                f16vec3 _379 = _356;
	                float16_t _378 = _355;
	                uint _377 = _354;
	                f16vec4 _376 = _353;
	                float16_t _380 = float16_t(max(float(_357), 0.07999999821186065673828125));
	                vec3 _1241 = vec3(_360);
	                vec3 _648 = vec3(0.0);
	                vec3 _649 = vec3(0.0);
	                float _1242 = _1241.z;
	                if (_1242 >= 0.0)
	                {
	                    _647 = 1.0;
	                }
	                else
	                {
	                    _647 = -1.0;
	                }
	                float _1249 = (-1.0) / (_647 + _1242);
	                float _1250 = _1241.x;
	                float _1251 = _1241.y;
	                float _1253 = (_1250 * _1251) * _1249;
	                vec3 _1258 = _648;
	                _1258.x = 1.0 + (((_647 * _1250) * _1250) * _1249);
	                _1258.y = _647 * _1253;
	                _1258.z = (-_647) * _1250;
	                _648 = _1258;
	                vec3 _1265 = _649;
	                _1265.x = _1253;
	                _1265.y = _647 + ((_1251 * _1251) * _1249);
	                _1265.z = -_1251;
	                _649 = _1265;
	                _460 = _1258;
	                _459 = _1265;
	                vec3 _1277 = transpose(mat3(_1258, _1265, vec3(_383))) * (-_436);
	                _456 = _1277;
	                vec3 _1285 = vec3(mix(f16vec3(_378), _381, f16vec3(_382)));
	                _458 = dot((_1285 + ((vec3(1.0) - _1285) * pow(max(0.0, 1.0 - _1277.z), 5.0))).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                if ((_377 & 65535u) == 1u)
	                {
	                    float _1304 = dot(vec3(_376.xyz).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                    _457 = _1304 / max(9.9999997473787516355514526367188e-05, _1304 + dot(vec3(_381).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)));
	                }
	                f16vec3 _321 = _383;
	                float16_t _320 = _382;
	                f16vec3 _319 = _381;
	                float16_t _318 = _380;
	                f16vec3 _317 = _379;
	                float16_t _316 = _378;
	                uint _315 = _377;
	                f16vec4 _314 = _376;
	                vec3 _375 = _460;
	                vec3 _374 = _459;
	                float _373 = _458;
	                float _372 = _457;
	                vec3 _371 = _456;
	                if (true)
	                {
	                    if ((_450 & 256) != 0)
	                    {
	                        _317 *= float16_t(_454);
	                    }
	                    else
	                    {
	                        _317 = f16vec3(vec3(0.0));
	                    }
	                }
	                if (true)
	                {
	                    _650 = any(notEqual(_435, vec3(3.4028234663852885981170418348452e+38)));
	                }
	                else
	                {
	                    _650 = false;
	                }
	                vec3 _1345 = _435 - _453;
	                float _1346 = length(_1345);
	                vec3 _463 = _453;
	                float _462 = 0.0;
	                vec3 _461 = vec4(_1345 / vec3(_1346), _1346).xyz;
	                if (_650)
	                {
	                    _646 = _1346;
	                }
	                else
	                {
	                    _646 = 0.0;
	                }
	                p_1 = PayloadShadow_t(1.0);
	                traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _463, _462, _461, _646, 1);
	                if (_650)
	                {
	                    _646 = p_1.m_flVisibility;
	                }
	                else
	                {
	                    _646 = 0.0;
	                }
	                if (_646 == 1.0)
	                {
	                    _453 = _435;
	                    _451 = vec3(_360);
	                }
	                vec3 _441 = _453;
	                vec3 _440 = _452;
	                vec3 _439 = _451;
	                int _438 = _450;
	                f16vec3 _306 = _321;
	                float16_t _305 = _320;
	                f16vec3 _304 = _319;
	                float16_t _303 = _318;
	                f16vec3 _302 = _317;
	                float16_t _301 = _316;
	                uint _300 = _315;
	                f16vec4 _299 = _314;
	                vec3 _365 = _375;
	                vec3 _364 = _374;
	                float _363 = _373;
	                float _362 = _372;
	                vec3 _361 = _371;
	                if (!(dot(_451, -_658) > 0.0))
	                {
	                    if ((_438 & 1024) != 0)
	                    {
	                        _439 = -_439;
	                        _306 = -_306;
	                        vec3 _1659 = _447;
	                        _447 = _446;
	                        _446 = _1659;
	                    }
	                    else
	                    {
	                        vec2 _1412 = imageLoad(g_RandomSamples, ivec3(_415.xy, int(1u + uint(_659)))).xy;
	                        f16vec3 _1414 = f16vec3(vec3(0.0));
	                        vec2 _1420 = _1412;
	                        _1420.y = 0.0;
	                        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _464, 3.4028234663852885981170418348452e+38, _1412.y, -1, false, MaterialDataMinimal_t(_1414, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _1414, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                        traceRayEXT(g_AccelStruct, 16u, 4u, 0u, 2u, 0u, _443, _1025 * 0.99989998340606689453125, _442, _1025 * 1.00010001659393310546875, 0);
	                        vec2 _1453 = _1412;
	                        _1453.y = p.flOpacityRng;
	                        _664 = _1453;
	                        if (p.nInstance != (-1))
	                        {
	                            vec3 _432 = _443;
	                            vec3 _431 = _442;
	                            vec3 _430 = p.vSmoothPositionWs;
	                            vec3 _429 = p.vFaceNormalWs;
	                            float _428 = p.flHitT;
	                            f16vec3 _352 = p.material.vNormalWs;
	                            float16_t _351 = p.material.flMetalness;
	                            f16vec3 _350 = p.material.vAlbedo;
	                            float16_t _349 = p.material.flRoughness;
	                            f16vec3 _348 = p.material.vEmissive;
	                            float16_t _347 = p.material.flReflectance;
	                            uint _346 = p.material.nMaterialTypeAndFlags;
	                            f16vec4 _345 = p.material.vMaterialBits;
	                            uint _1460 = uint(p.nInstance);
	                            uint _470 = g_instanceBuffer_1._member0[_1460].nMaterialFlags_nInstanceFlags;
	                            float _469 = g_instanceBuffer_1._member0[_1460].fEmissiveBoost;
	                            vec3 _468 = (_432 + (_431 * _428)) + (_429 * ((abs(_432) + vec3(abs(_428))) * 9.9999997473787516355514526367188e-05));
	                            vec3 _467 = (_432 + (_431 * _428)) + ((-_429) * ((abs(_432) + vec3(abs(_428))) * 9.9999997473787516355514526367188e-05));
	                            vec3 _466 = _429;
	                            int _465 = int(_470 & 65535u);
	                            vec3 _475 = vec3(0.0);
	                            vec3 _474 = vec3(0.0);
	                            float _473 = 0.0;
	                            float _472 = 0.0;
	                            vec3 _471 = vec3(0.0);
	                            f16vec3 _396 = _352;
	                            float16_t _395 = _351;
	                            f16vec3 _394 = _350;
	                            f16vec3 _392 = _348;
	                            float16_t _391 = _347;
	                            uint _390 = _346;
	                            f16vec4 _389 = _345;
	                            float16_t _393 = float16_t(max(float(_349), 0.07999999821186065673828125));
	                            vec3 _1508 = vec3(_352);
	                            vec3 _643 = vec3(0.0);
	                            vec3 _644 = vec3(0.0);
	                            float _1509 = _1508.z;
	                            if (_1509 >= 0.0)
	                            {
	                                _642 = 1.0;
	                            }
	                            else
	                            {
	                                _642 = -1.0;
	                            }
	                            float _1516 = (-1.0) / (_642 + _1509);
	                            float _1517 = _1508.x;
	                            float _1518 = _1508.y;
	                            float _1520 = (_1517 * _1518) * _1516;
	                            vec3 _1525 = _643;
	                            _1525.x = 1.0 + (((_642 * _1517) * _1517) * _1516);
	                            _1525.y = _642 * _1520;
	                            _1525.z = (-_642) * _1517;
	                            _643 = _1525;
	                            vec3 _1532 = _644;
	                            _1532.x = _1520;
	                            _1532.y = _642 + ((_1518 * _1518) * _1516);
	                            _1532.z = -_1518;
	                            _644 = _1532;
	                            _475 = _1525;
	                            _474 = _1532;
	                            vec3 _1544 = transpose(mat3(_1525, _1532, vec3(_396))) * (-_431);
	                            _471 = _1544;
	                            vec3 _1552 = vec3(mix(f16vec3(_391), _394, f16vec3(_395)));
	                            _473 = dot((_1552 + ((vec3(1.0) - _1552) * pow(max(0.0, 1.0 - _1544.z), 5.0))).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                            if ((_390 & 65535u) == 1u)
	                            {
	                                float _1571 = dot(vec3(_389.xyz).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                                _472 = _1571 / max(9.9999997473787516355514526367188e-05, _1571 + dot(vec3(_394).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)));
	                            }
	                            f16vec3 _329 = _396;
	                            float16_t _328 = _395;
	                            f16vec3 _327 = _394;
	                            float16_t _326 = _393;
	                            f16vec3 _325 = _392;
	                            float16_t _324 = _391;
	                            uint _323 = _390;
	                            f16vec4 _322 = _389;
	                            vec3 _388 = _475;
	                            vec3 _387 = _474;
	                            float _386 = _473;
	                            float _385 = _472;
	                            vec3 _384 = _471;
	                            if (true)
	                            {
	                                if ((_465 & 256) != 0)
	                                {
	                                    _325 *= float16_t(_469);
	                                }
	                                else
	                                {
	                                    _325 = f16vec3(vec3(0.0));
	                                }
	                            }
	                            if (true)
	                            {
	                                _645 = any(notEqual(_430, vec3(3.4028234663852885981170418348452e+38)));
	                            }
	                            else
	                            {
	                                _645 = false;
	                            }
	                            vec3 _1612 = _430 - _468;
	                            float _1613 = length(_1612);
	                            vec3 _478 = _468;
	                            float _477 = 0.0;
	                            vec3 _476 = vec4(_1612 / vec3(_1613), _1613).xyz;
	                            if (_645)
	                            {
	                                _641 = _1613;
	                            }
	                            else
	                            {
	                                _641 = 0.0;
	                            }
	                            p_1 = PayloadShadow_t(1.0);
	                            traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _478, _477, _476, _641, 1);
	                            if (_645)
	                            {
	                                _641 = p_1.m_flVisibility;
	                            }
	                            else
	                            {
	                                _641 = 0.0;
	                            }
	                            if (_641 == 1.0)
	                            {
	                                _468 = _430;
	                                _466 = vec3(_352);
	                            }
	                            _441 = _468;
	                            _440 = _467;
	                            _439 = _466;
	                            _438 = _465;
	                            _306 = _329;
	                            _305 = _328;
	                            _304 = _327;
	                            _303 = _326;
	                            _302 = _325;
	                            _301 = _324;
	                            _300 = _323;
	                            _299 = _322;
	                            _365 = _388;
	                            _364 = _387;
	                            _363 = _386;
	                            _362 = _385;
	                            _361 = _384;
	                        }
	                        else
	                        {
	                            break;
	                        }
	                    }
	                }
	                vec3 _427 = _441;
	                vec3 _426 = _440;
	                vec3 _425 = _439;
	                f16vec3 _298 = _306;
	                float16_t _297 = _305;
	                f16vec3 _296 = _304;
	                float16_t _295 = _303;
	                float16_t _294 = _301;
	                uint _293 = _300;
	                f16vec4 _292 = _299;
	                vec3 _344 = _365;
	                vec3 _343 = _364;
	                vec3 _342 = _361;
	                vec3 _1676 = (_441 + _440) * 0.5;
	                bool _1677 = _659 != 0;
	                f16vec4 _480 = _299;
	                if ((_300 & 65535u) == 1u)
	                {
	                    _636 = any(greaterThan(vec3(_480.xyz), vec3(0.0)));
	                }
	                else
	                {
	                    _636 = false;
	                }
	                if (_636)
	                {
	                    _637 = true;
	                }
	                else
	                {
	                    f16vec4 _479 = _292;
	                    if ((_293 & 65535u) == 2u)
	                    {
	                        _635 = float(_479.x) > 0.0;
	                    }
	                    else
	                    {
	                        _635 = false;
	                    }
	                    _637 = _635;
	                }
	                vec2 _1715 = imageLoad(g_RandomSamples, ivec3(_415.xy, int(1u + ((2u * _414) + uint(_659))))).xy;
	                bool _638 = false;
	                vec3 _1728 = (_427 + _426) * 0.5;
	                uvec3 _1736 = min(uvec3(max(fma(_1728, _410, _411), vec3(0.0))), (_412 - uvec3(1u)));
	                uint _630 = 0u;
	                vec3 _631 = vec3(0.0);
	                for (;;)
	                {
	                    if (!(_630 < _413))
	                    {
	                        break;
	                    }
	                    uint _1752 = _413 * _412.x;
	                    uint _632 = subgroupOr(g_LightBins_1._member0[((((_1752 * _412.y) * _1736.z) + (_1752 * _1736.y)) + (_413 * _1736.x)) + _630]);
	                    vec3 _633 = _631;
	                    for (;;)
	                    {
	                        if (!(_632 != 0u))
	                        {
	                            break;
	                        }
	                        uint _1776 = _632;
	                        uint _1780 = uint(findLSB(_1776)) + (_630 * 32u);
	                        uint _1782 = _1776 & (_1776 - 1u);
	                        if ((uint(g_Lights_1._member0[_1780].m_nPathTraceFlags) & 1u) == 0u)
	                        {
	                            _632 = _1782;
	                            continue;
	                        }
	                        if ((g_Lights_1._member0[_1780].m_nPathTraceFlags & 8) != 0)
	                        {
	                            _638 = true;
	                            _632 = _1782;
	                            continue;
	                        }
	                        do
	                        {
	                            do
	                            {
	                                vec4 _1808 = g_Lights_1._member0[_1780].m_mToClipSpace * vec4(_1728.xyz, 1.0);
	                                vec3 _1812 = _1808.xyz / vec3(_1808.w);
	                                vec4 _1814;
	                                _1814.x = _1812.x;
	                                _1814.y = _1812.y;
	                                _1814.z = _1812.z;
	                                if (all(greaterThanEqual(_1814.xyz, vec3(-1.0, -1.0, 0.0))))
	                                {
	                                    _627 = all(lessThanEqual(_1814.xyz, vec3(1.0)));
	                                }
	                                else
	                                {
	                                    _627 = false;
	                                }
	                                if (!_627)
	                                {
	                                    _628 = false;
	                                    break;
	                                }
	                                if (!all(lessThanEqual(abs((g_Lights_1._member0[_1780].m_mBarnIlluminationFromWorld * vec4(_1728, 1.0)).xyz), vec3(1.0))))
	                                {
	                                    _628 = false;
	                                    break;
	                                }
	                                _628 = true;
	                                break;
	                            } while(false);
	                            if (!_628)
	                            {
	                                _629 = vec3(0.0);
	                                break;
	                            }
	                            vec4 _1851 = g_Lights_1._member0[_1780].m_mToClipSpace * vec4(_1728.xyz, 1.0);
	                            vec3 _1855 = _1851.xyz / vec3(_1851.w);
	                            vec4 _1857;
	                            _1857.x = _1855.x;
	                            _1857.y = _1855.y;
	                            _1857.z = _1855.z;
	                            if (_1677)
	                            {
	                                _626 = g_Lights_1._member0[_1780].m_vBounceColor.xyz;
	                            }
	                            else
	                            {
	                                _626 = g_Lights_1._member0[_1780].m_vColor.xyz;
	                            }
	                            if (true)
	                            {
	                                if (g_Lights_1._member0[_1780].m_nCookie >= 0)
	                                {
	                                    if (g_Lights_1._member0[_1780].m_bSphericalCookie != 0)
	                                    {
	                                        vec4 _1915 = vec4(-g_Lights_1._member0[_1780].m_vOrientation.xyz, g_Lights_1._member0[_1780].m_vOrientation.w);
	                                        vec4 _1917 = _1915.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                                        vec3 _1920 = _1917.xyz;
	                                        vec3 _1921 = vec4((-normalize(g_Lights_1._member0[_1780].m_vLightPosition.xyz - _1728)).xyz, 0.0).xyz;
	                                        vec4 _1928 = vec4((_1921 * _1917.w) + cross(_1921, _1920), -dot(_1921, _1920));
	                                        vec3 _1929 = _1928.xyz;
	                                        float _1930 = _1915.w;
	                                        vec3 _1932 = _1915.xyz;
	                                        float _1933 = _1928.w;
	                                        vec3 _1941 = vec4(((_1929 * _1930) + (_1932 * _1933)) + cross(_1932, _1929), _282).xyz;
	                                        vec2 _1950 = vec2(atan(_1941.y, -_1941.x) * 0.15915493667125701904296875, acos(_1941.z) * 0.3183098733425140380859375);
	                                        vec2 _1957 = (_1950.xy * g_Lights_1._member0[_1780].m_vCookieParameters.zw) + g_Lights_1._member0[_1780].m_vCookieParameters.xy;
	                                        vec2 _1959 = _1950;
	                                        _1959.x = _1957.x;
	                                        _1959.y = _1957.y;
	                                        _625 = textureLod(nonuniformEXT(sampler2D(g_bindless_Texture2D[g_Lights_1._member0[_1780].m_nCookie], g_Sampler)), _1959, 0.0).xyz;
	                                    }
	                                    else
	                                    {
	                                        vec2 _1888 = fma(_1857.xyz.xy, vec2(0.5, -0.5), vec2(0.5));
	                                        vec2 _1895 = (_1888.xy * g_Lights_1._member0[_1780].m_vCookieParameters.zw) + g_Lights_1._member0[_1780].m_vCookieParameters.xy;
	                                        vec2 _1897 = _1888;
	                                        _1897.x = _1895.x;
	                                        _1897.y = _1895.y;
	                                        _625 = textureLod(nonuniformEXT(sampler2D(g_bindless_Texture2D[g_Lights_1._member0[_1780].m_nCookie], g_CookieSampler)), _1897, 0.0).xyz;
	                                    }
	                                }
	                                else
	                                {
	                                    _625 = vec3(1.0);
	                                }
	                                _626 *= _625;
	                            }
	                            if (g_Lights_1._member0[_1780].m_nLuminaireType != 0)
	                            {
	                                _626 = (_626 * g_Lights_1._member0[_1780].m_vLuminaireVectors.data[0].w) * 0.3183098733425140380859375;
	                            }
	                            else
	                            {
	                                if (!(g_Lights_1._member0[_1780].m_vLightPosition.w == 0.0))
	                                {
	                                    vec3 _1986 = g_Lights_1._member0[_1780].m_vLightPosition.xyz - _1728;
	                                    _626 *= (vec3(g_Lights_1._member0[_1780].m_vLightPosition.w) / max(vec3(dot(_1986, _1986)), vec3(g_Lights_1._member0[_1780].m_vLightPosition.w)));
	                                }
	                            }
	                            if (g_Lights_1._member0[_1780].m_vDistanceFade_vSkirt.z > 0.0)
	                            {
	                                _622 = smoothstep(0.0, 1.0, _1857.xyz.z * g_Lights_1._member0[_1780].m_vDistanceFade_vSkirt.z);
	                            }
	                            else
	                            {
	                                _622 = 1.0;
	                            }
	                            if (g_Lights_1._member0[_1780].m_vDistanceFade_vSkirt.w > 0.0)
	                            {
	                                _622 *= smoothstep(0.0, 1.0, (1.0 - _1857.xyz.z) * g_Lights_1._member0[_1780].m_vDistanceFade_vSkirt.w);
	                            }
	                            if (!(g_Lights_1._member0[_1780].m_vLightPosition.w == 0.0))
	                            {
	                                vec3 _2040 = g_Lights_1._member0[_1780].m_vLightPosition.xyz - _1728;
	                                float _2041 = length(_2040);
	                                vec3 _2043 = _2040 / vec3(_2041);
	                                float _2052 = _622 * smoothstep(0.0, 1.0, g_Lights_1._member0[_1780].m_vDistanceFade_vSkirt.x + (g_Lights_1._member0[_1780].m_vDistanceFade_vSkirt.y * _2041));
	                                if (g_Lights_1._member0[_1780].m_nLuminaireType != 2)
	                                {
	                                    _624 = g_Lights_1._member0[_1780].m_nLuminaireType != 1;
	                                }
	                                else
	                                {
	                                    _624 = false;
	                                }
	                                if (_624)
	                                {
	                                    float _2071 = 2.0 * g_Lights_1._member0[_1780].m_vOrientation.x;
	                                    float _2075 = 2.0 * g_Lights_1._member0[_1780].m_vOrientation.w;
	                                    vec3 _2089 = vec3((_2071 * g_Lights_1._member0[_1780].m_vOrientation.y) - (_2075 * g_Lights_1._member0[_1780].m_vOrientation.z), (1.0 - (_2071 * g_Lights_1._member0[_1780].m_vOrientation.x)) - ((2.0 * g_Lights_1._member0[_1780].m_vOrientation.z) * g_Lights_1._member0[_1780].m_vOrientation.z), ((2.0 * g_Lights_1._member0[_1780].m_vOrientation.y) * g_Lights_1._member0[_1780].m_vOrientation.z) + (_2075 * g_Lights_1._member0[_1780].m_vOrientation.x)) * g_Lights_1._member0[_1780].m_vAngleFade.z;
	                                    vec3 _2090 = _2043 - _2089;
	                                    vec3 _2091 = _2043 + _2089;
	                                    do
	                                    {
	                                        vec3 _2094 = _2091 - _2090;
	                                        float _2096 = dot(-_2090, _2094);
	                                        if (_2096 <= 0.0)
	                                        {
	                                            _620 = _2090;
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            float _2101 = dot(_2094, _2094);
	                                            if (_2096 > _2101)
	                                            {
	                                                _620 = _2091;
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                _620 = _2090 + (_2094 * (_2096 / _2101));
	                                                break;
	                                            }
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    if (any(notEqual(_620, vec3(0.0))))
	                                    {
	                                        _621 = normalize(_620);
	                                    }
	                                    else
	                                    {
	                                        _621 = _620;
	                                    }
	                                    float _2125 = 2.0 * g_Lights_1._member0[_1780].m_vOrientation.x;
	                                    float _2128 = 2.0 * g_Lights_1._member0[_1780].m_vOrientation.w;
	                                    _623 = _2052 * saturate(g_Lights_1._member0[_1780].m_vAngleFade.x + (g_Lights_1._member0[_1780].m_vAngleFade.y * dot(vec3((1.0 - ((2.0 * g_Lights_1._member0[_1780].m_vOrientation.y) * g_Lights_1._member0[_1780].m_vOrientation.y)) - ((2.0 * g_Lights_1._member0[_1780].m_vOrientation.z) * g_Lights_1._member0[_1780].m_vOrientation.z), (_2125 * g_Lights_1._member0[_1780].m_vOrientation.y) + (_2128 * g_Lights_1._member0[_1780].m_vOrientation.z), (_2125 * g_Lights_1._member0[_1780].m_vOrientation.z) - (_2128 * g_Lights_1._member0[_1780].m_vOrientation.y)), _621)));
	                                }
	                                else
	                                {
	                                    _623 = _2052;
	                                }
	                            }
	                            else
	                            {
	                                _623 = _622;
	                            }
	                            if (g_Lights_1._member0[_1780].m_nCookie == (-1))
	                            {
	                                do
	                                {
	                                    vec2 _2157 = abs(_1857.xyz.xy);
	                                    if (g_Lights_1._member0[_1780].m_vCookieParameters.z == 0.0)
	                                    {
	                                        _618 = smoothstep(1.0, g_Lights_1._member0[_1780].m_vCookieParameters.x, _2157.x) * smoothstep(1.0, g_Lights_1._member0[_1780].m_vCookieParameters.y, _2157.y);
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        float _2162 = _2157.x;
	                                        float _2166 = _2157.y;
	                                        float _2173 = (-0.5) * g_Lights_1._member0[_1780].m_vCookieParameters.z;
	                                        float _2175 = (g_Lights_1._member0[_1780].m_vCookieParameters.x * g_Lights_1._member0[_1780].m_vCookieParameters.y) * pow(max(pow(g_Lights_1._member0[_1780].m_vCookieParameters.y * _2162, 2.0 / g_Lights_1._member0[_1780].m_vCookieParameters.z) + pow(g_Lights_1._member0[_1780].m_vCookieParameters.x * _2166, 2.0 / g_Lights_1._member0[_1780].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _2173);
	                                        float _2182 = pow(max(pow(_2162, 2.0 / g_Lights_1._member0[_1780].m_vCookieParameters.z) + pow(_2166, 2.0 / g_Lights_1._member0[_1780].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _2173);
	                                        if (_2175 < _2182)
	                                        {
	                                            _618 = smoothstep(_2182, _2175, 1.0);
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            if (_2182 > 1.0)
	                                            {
	                                                _619 = 1.0;
	                                            }
	                                            else
	                                            {
	                                                _619 = 0.0;
	                                            }
	                                            _618 = _619;
	                                            break;
	                                        }
	                                        break;
	                                    }
	                                    break;
	                                } while(false);
	                                _623 *= _618;
	                            }
	                            _629 = _626 * _623;
	                            break;
	                        } while(false);
	                        SPIRV_CROSS_BRANCH
	                        if (any(greaterThan(_629, vec3(0.0))))
	                        {
	                            _616 = false;
	                            do
	                            {
	                                switch (g_Lights_1._member0[_1780].m_nLuminaireType)
	                                {
	                                    case 0:
	                                    {
	                                        _634 = 1.0;
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_1780].m_vLightPosition.w == 0.0)
	                                            {
	                                                _591 = vec4(normalize(g_Lights_1._member0[_1780].m_vLightPosition.xyz), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _2730 = g_Lights_1._member0[_1780].m_vLightPosition.xyz - _1728;
	                                                float _2731 = length(_2730);
	                                                _591 = vec4(_2730 / vec3(_2731), _2731);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _616 = true;
	                                        _617 = _591;
	                                        break;
	                                    }
	                                    case 1:
	                                    {
	                                        vec3 _2570 = g_Lights_1._member0[_1780].m_vLuminaireVectors.data[1].xyz - g_Lights_1._member0[_1780].m_vLuminaireVectors.data[0].xyz;
	                                        vec3 _2574 = g_Lights_1._member0[_1780].m_vLuminaireVectors.data[2].xyz - g_Lights_1._member0[_1780].m_vLuminaireVectors.data[0].xyz;
	                                        float _2575 = length(_2570);
	                                        float _2576 = length(_2574);
	                                        vec3 _2578 = _2570 / vec3(_2575);
	                                        vec3 _2580 = _2574 / vec3(_2576);
	                                        vec3 _2581 = cross(_2578, _2580);
	                                        vec3 _2582 = g_Lights_1._member0[_1780].m_vLuminaireVectors.data[0].xyz - _1728;
	                                        float _2583 = dot(_2582, _2581);
	                                        if (_2583 > 0.0)
	                                        {
	                                            _593 = _2583 * (-1.0);
	                                            _594 = _2581 * (-1.0);
	                                        }
	                                        else
	                                        {
	                                            _593 = _2583;
	                                            _594 = _2581;
	                                        }
	                                        float _2592 = dot(_2582, _2578);
	                                        float _2593 = dot(_2582, _2580);
	                                        float _2594 = _2592 + _2575;
	                                        float _2595 = _2593 + _2576;
	                                        vec3 _2598 = vec3(_2592, _2593, _593);
	                                        vec3 _2599 = vec3(_2592, _2595, _593);
	                                        vec3 _2600 = vec3(_2594, _2593, _593);
	                                        vec3 _2601 = vec3(_2594, _2595, _593);
	                                        vec3 _2603 = normalize(cross(_2598, _2600));
	                                        vec3 _2605 = normalize(cross(_2600, _2601));
	                                        vec3 _2607 = normalize(cross(_2601, _2599));
	                                        vec3 _2609 = normalize(cross(_2599, _2598));
	                                        float _2626 = _2603.z;
	                                        float _2630 = (6.283185482025146484375 - acos(clamp(-dot(_2607, _2609), -1.0, 1.0))) - acos(clamp(-dot(_2609, _2603), -1.0, 1.0));
	                                        float _2632 = (acos(clamp(-dot(_2603, _2605), -1.0, 1.0)) + acos(clamp(-dot(_2605, _2607), -1.0, 1.0))) - _2630;
	                                        if (isnan(_2632))
	                                        {
	                                            _595 = 0.0;
	                                        }
	                                        else
	                                        {
	                                            _595 = _2632;
	                                        }
	                                        float _2640 = (_1715.x * _595) + _2630;
	                                        float _2645 = ((cos(_2640) * _2626) - _2607.z) / sin(_2640);
	                                        if (_2645 > 0.0)
	                                        {
	                                            _596 = 1.0;
	                                        }
	                                        else
	                                        {
	                                            _596 = -1.0;
	                                        }
	                                        float _2654 = _596;
	                                        float _2656 = clamp((1.0 / sqrt((_2645 * _2645) + (_2626 * _2626))) * _2654, -1.0, 1.0);
	                                        float _2664 = clamp((-(_2656 * _593)) / sqrt(1.0 - (_2656 * _2656)), _2592, _2594);
	                                        float _2667 = sqrt((_2664 * _2664) + (_593 * _593));
	                                        float _2668 = _2667 * _2667;
	                                        float _2671 = _2593 / sqrt(_2668 + (_2593 * _2593));
	                                        float _2678 = _2671 + (_1715.y * ((_2595 / sqrt(_2668 + (_2595 * _2595))) - _2671));
	                                        float _2679 = _2678 * _2678;
	                                        if (_2679 < 0.99999988079071044921875)
	                                        {
	                                            _596 = (_2678 * _2667) / sqrt(1.0 - _2679);
	                                        }
	                                        else
	                                        {
	                                            _596 = _2595;
	                                        }
	                                        vec3 _2696 = ((_1728 + (_2578 * _2664)) + (_2580 * _596)) + (_594 * _593);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_1780].m_vLightPosition.w == 0.0)
	                                            {
	                                                _592 = vec4(normalize(_2696), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _2707 = _2696 - _1728;
	                                                float _2708 = length(_2707);
	                                                _592 = vec4(_2707 / vec3(_2708), _2708);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _634 = 1.0 / _595;
	                                        _616 = true;
	                                        _617 = _592;
	                                        break;
	                                    }
	                                    case 2:
	                                    {
	                                        do
	                                        {
	                                            vec2 _2478 = (_1715 * 2.0) - vec2(1.0);
	                                            if (all(equal(_2478, vec2(0.0))))
	                                            {
	                                                _600 = vec2(0.0);
	                                                break;
	                                            }
	                                            float _2483 = _2478.x;
	                                            float _2485 = _2478.y;
	                                            if (abs(_2483) > abs(_2485))
	                                            {
	                                                _601 = _2483;
	                                                _602 = 0.785398185253143310546875 * (_2485 / _2483);
	                                            }
	                                            else
	                                            {
	                                                _601 = _2485;
	                                                _602 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_2483 / _2485));
	                                            }
	                                            _600 = vec2(cos(_602), sin(_602)) * _601;
	                                            break;
	                                        } while(false);
	                                        vec3 _2519 = (g_Lights_1._member0[_1780].m_vLuminaireVectors.data[0].xyz + (g_Lights_1._member0[_1780].m_vLuminaireVectors.data[1].xyz * _600.x)) + (g_Lights_1._member0[_1780].m_vLuminaireVectors.data[2].xyz * _600.y);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_1780].m_vLightPosition.w == 0.0)
	                                            {
	                                                _599 = vec4(normalize(_2519), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _2530 = _2519 - _1728;
	                                                float _2531 = length(_2530);
	                                                _599 = vec4(_2530 / vec3(_2531), _2531);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (isinf(_599.w))
	                                        {
	                                            _597 = true;
	                                        }
	                                        else
	                                        {
	                                            _597 = isnan(_599.w);
	                                        }
	                                        if (!_597)
	                                        {
	                                            _598 = _599.w * _599.w;
	                                        }
	                                        else
	                                        {
	                                            _598 = 1.0;
	                                        }
	                                        _634 = _598 / (max(0.0, dot(g_Lights_1._member0[_1780].m_vLuminaireVectors.data[3].xyz, -_599.xyz)) * g_Lights_1._member0[_1780].m_vLuminaireVectors.data[1].w);
	                                        _616 = true;
	                                        _617 = _599;
	                                        break;
	                                    }
	                                    case 3:
	                                    {
	                                        vec3 _2373 = g_Lights_1._member0[_1780].m_vLuminaireVectors.data[0].xyz - _1728;
	                                        float _2374 = dot(_2373, _2373);
	                                        float _2375 = sqrt(_2374);
	                                        vec3 _2377 = _2373 / vec3(_2375);
	                                        float _2378 = _2377.z;
	                                        if (_2378 >= 0.0)
	                                        {
	                                            _604 = 1.0;
	                                        }
	                                        else
	                                        {
	                                            _604 = -1.0;
	                                        }
	                                        float _2385 = (-1.0) / (_604 + _2378);
	                                        float _2386 = _2377.x;
	                                        float _2387 = _2377.y;
	                                        float _2389 = (_2386 * _2387) * _2385;
	                                        vec3 _2394 = _605;
	                                        _2394.x = 1.0 + (((_604 * _2386) * _2386) * _2385);
	                                        _2394.y = _604 * _2389;
	                                        _2394.z = (-_604) * _2386;
	                                        _605 = _2394;
	                                        vec3 _2401 = _606;
	                                        _2401.x = _2389;
	                                        _2401.y = _604 + ((_2387 * _2387) * _2385);
	                                        _2401.z = -_2387;
	                                        _606 = _2401;
	                                        float _2409 = g_Lights_1._member0[_1780].m_vLuminaireVectors.data[1].x * g_Lights_1._member0[_1780].m_vLuminaireVectors.data[1].x;
	                                        float _2413 = sqrt(max(0.0, 1.0 - (_2409 / _2374)));
	                                        float _2414 = _1715.x;
	                                        float _2417 = (1.0 - _2414) + (_2414 * _2413);
	                                        float _2421 = sqrt(max(0.0, 1.0 - (_2417 * _2417)));
	                                        float _2423 = _1715.y * 6.283185482025146484375;
	                                        float _2425 = _2375 * _2375;
	                                        float _2431 = (_2375 * _2417) - sqrt(max(0.0, _2409 - ((_2425 * _2421) * _2421)));
	                                        float _2437 = ((_2425 + _2409) - (_2431 * _2431)) / ((2.0 * _2375) * g_Lights_1._member0[_1780].m_vLuminaireVectors.data[1].x);
	                                        float _2441 = sqrt(max(0.0, 1.0 - (_2437 * _2437)));
	                                        vec3 _2453 = g_Lights_1._member0[_1780].m_vLuminaireVectors.data[0].xyz + ((mat3(-_2394, -_2401, -_2377) * vec3(cos(_2423) * _2441, sin(_2423) * _2441, _2437)) * g_Lights_1._member0[_1780].m_vLuminaireVectors.data[1].x);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_1780].m_vLightPosition.w == 0.0)
	                                            {
	                                                _603 = vec4(normalize(_2453), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _2464 = _2453 - _1728;
	                                                float _2465 = length(_2464);
	                                                _603 = vec4(_2464 / vec3(_2465), _2465);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _634 = 0.15915493667125701904296875 / (1.0 - _2413);
	                                        _616 = true;
	                                        _617 = _603;
	                                        break;
	                                    }
	                                    case 4:
	                                    case 5:
	                                    {
	                                        vec2 _613 = _1715;
	                                        if (_1715.x < g_Lights_1._member0[_1780].m_vLuminaireVectors.data[4].y)
	                                        {
	                                            vec2 _2264 = _613;
	                                            _2264.x = clamp(_2264.x / g_Lights_1._member0[_1780].m_vLuminaireVectors.data[4].y, 0.0, 0.99999988079071044921875);
	                                            _613 = _2264;
	                                            vec3 _2270 = normalize(g_Lights_1._member0[_1780].m_vLuminaireVectors.data[0].xyz - g_Lights_1._member0[_1780].m_vLuminaireVectors.data[1].xyz);
	                                            if (_2264.x >= 0.5)
	                                            {
	                                                vec2 _2281 = _613;
	                                                _2281.x = clamp((2.0 * _2281.x) - 1.0, 0.0, 0.99999988079071044921875);
	                                                _613 = _2281;
	                                                _614 = -_2270;
	                                                _615 = g_Lights_1._member0[_1780].m_vLuminaireVectors.data[1].xyz;
	                                            }
	                                            else
	                                            {
	                                                vec2 _2276 = _613;
	                                                _2276.x = clamp(2.0 * _2276.x, 0.0, 0.99999988079071044921875);
	                                                _613 = _2276;
	                                                _614 = _2270;
	                                                _615 = g_Lights_1._member0[_1780].m_vLuminaireVectors.data[0].xyz;
	                                            }
	                                            do
	                                            {
	                                                vec2 _2292 = (_613 * 2.0) - vec2(1.0);
	                                                if (all(equal(_2292, vec2(0.0))))
	                                                {
	                                                    _610 = vec2(0.0);
	                                                    break;
	                                                }
	                                                float _2297 = _2292.x;
	                                                float _2299 = _2292.y;
	                                                if (abs(_2297) > abs(_2299))
	                                                {
	                                                    _611 = _2297;
	                                                    _612 = 0.785398185253143310546875 * (_2299 / _2297);
	                                                }
	                                                else
	                                                {
	                                                    _611 = _2299;
	                                                    _612 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_2297 / _2299));
	                                                }
	                                                _610 = vec2(cos(_612), sin(_612)) * _611;
	                                                break;
	                                            } while(false);
	                                            _615 += ((g_Lights_1._member0[_1780].m_vLuminaireVectors.data[2].xyz * _610.x) + (g_Lights_1._member0[_1780].m_vLuminaireVectors.data[3].xyz * _610.y));
	                                        }
	                                        else
	                                        {
	                                            vec2 _2243 = _613;
	                                            _2243.x = clamp((_2243.x - g_Lights_1._member0[_1780].m_vLuminaireVectors.data[4].y) / (1.0 - g_Lights_1._member0[_1780].m_vLuminaireVectors.data[4].y), 0.0, 0.99999988079071044921875);
	                                            _613 = _2243;
	                                            vec3 _2258 = (g_Lights_1._member0[_1780].m_vLuminaireVectors.data[2].xyz * cos(_2243.x * 6.283185482025146484375)) + (g_Lights_1._member0[_1780].m_vLuminaireVectors.data[3].xyz * sin(_2243.x * 6.283185482025146484375));
	                                            _614 = normalize(_2258);
	                                            _615 = mix(g_Lights_1._member0[_1780].m_vLuminaireVectors.data[0].xyz, g_Lights_1._member0[_1780].m_vLuminaireVectors.data[1].xyz, vec3(_2243.y)) + _2258;
	                                        }
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_1780].m_vLightPosition.w == 0.0)
	                                            {
	                                                _609 = vec4(normalize(_615), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _2335 = _615 - _1728;
	                                                float _2336 = length(_2335);
	                                                _609 = vec4(_2335 / vec3(_2336), _2336);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (isinf(_609.w))
	                                        {
	                                            _607 = true;
	                                        }
	                                        else
	                                        {
	                                            _607 = isnan(_609.w);
	                                        }
	                                        if (!_607)
	                                        {
	                                            _608 = _609.w * _609.w;
	                                        }
	                                        else
	                                        {
	                                            _608 = 1.0;
	                                        }
	                                        _634 = _608 / (max(0.0, dot(_614, -_609.xyz)) * g_Lights_1._member0[_1780].m_vLuminaireVectors.data[1].w);
	                                        _616 = true;
	                                        _617 = _609;
	                                        break;
	                                    }
	                                    default:
	                                    {
	                                        _634 = 0.0;
	                                        _616 = true;
	                                        _617 = vec4(uintBitsToFloat(0x7fc00000u /* nan */));
	                                        break;
	                                    }
	                                }
	                                if (_616)
	                                {
	                                    break;
	                                }
	                                break;
	                            } while(false);
	                            bool _2748 = !(dot(_425, _617.xyz) > 0.0);
	                            vec3 _2750 = vec3(_298);
	                            vec3 _2755 = transpose(mat3(_344, _343, _2750)) * _617.xyz;
	                            float16_t _402 = _297;
	                            f16vec3 _401 = _296;
	                            float16_t _400 = _295;
	                            float16_t _399 = _294;
	                            uint _398 = _293;
	                            f16vec4 _397 = _292;
	                            vec3 _481 = _342;
	                            do
	                            {
	                                if (_2748)
	                                {
	                                    f16vec4 _482 = _397;
	                                    if ((_398 & 65535u) == 1u)
	                                    {
	                                        _586 = any(greaterThan(vec3(_482.xyz), vec3(0.0)));
	                                    }
	                                    else
	                                    {
	                                        _586 = false;
	                                    }
	                                    if (_586)
	                                    {
	                                        _590 = vec3(_397.xyz);
	                                    }
	                                    else
	                                    {
	                                        _590 = vec3(1.0);
	                                    }
	                                    _589 = _590 * 0.3183098733425140380859375;
	                                    break;
	                                }
	                                else
	                                {
	                                    vec3 _2775 = vec3(mix(f16vec3(_399), _401, f16vec3(_402)));
	                                    float _2777 = float(_400);
	                                    do
	                                    {
	                                        float _2780 = _2755.z;
	                                        vec3 _2782 = _2755 + _481;
	                                        if (_2780 <= 0.0)
	                                        {
	                                            _588 = true;
	                                        }
	                                        else
	                                        {
	                                            _588 = _481.z <= 0.0;
	                                        }
	                                        if (_588)
	                                        {
	                                            _587 = vec3(0.0);
	                                            break;
	                                        }
	                                        if (all(equal(_2782, vec3(0.0))))
	                                        {
	                                            _587 = vec3(0.0);
	                                            break;
	                                        }
	                                        vec3 _2795 = normalize(_2782);
	                                        float _2796 = _2795.z;
	                                        float _2804 = _2777 * _2777;
	                                        float _2805 = _2804 * _2804;
	                                        float _2809 = (((_2796 * _2805) - _2796) * _2796) + 1.0;
	                                        float _2813 = _2777 * _2777;
	                                        float _2814 = _2813 * _2813;
	                                        _587 = (_2775 + ((vec3(1.0) - _2775) * pow(max(0.0, 1.0 - dot(_2755, _2795)), 5.0))) * (((_2805 / max(9.9999999392252902907785028219223e-09, _2809 * _2809)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_2780 * sqrt(((_481.z - (_2814 * _481.z)) * _481.z) + _2814)) + (_481.z * sqrt(((_2780 - (_2814 * _2780)) * _2780) + _2814))))) * 0.3183098733425140380859375);
	                                        break;
	                                    } while(false);
	                                    _589 = ((vec3(_401) * (1.0 - float(_402))) * 0.3183098733425140380859375) + _587;
	                                    break;
	                                }
	                                break;
	                            } while(false);
	                            float _2866 = dot(_2750, _617.xyz);
	                            if (_2748)
	                            {
	                                _585 = -_2866;
	                            }
	                            else
	                            {
	                                _585 = _2866;
	                            }
	                            _633 += (((_629 / vec3(_634)) * (_589 * 3.1415927410125732421875)) * max(0.0, _585));
	                        }
	                        _632 = _1782;
	                        continue;
	                    }
	                    _630++;
	                    _631 = _633;
	                    continue;
	                }
	                if (_638)
	                {
	                    vec2 _576 = imageLoad(g_RandomSamples, ivec3(_415.xy, int(1u + (_414 + uint(_659))))).xy;
	                    vec3 _2890 = (_427 + _426) * 0.5;
	                    float _577 = 0.0;
	                    vec3 _487 = vec3(0.0);
	                    vec3 _486 = vec3(0.0);
	                    vec4 _485 = vec4(0.0);
	                    int _488 = -1;
	                    uvec3 _2898 = min(uvec3(max(fma(_2890, _410, _411), vec3(0.0))), (_412 - uvec3(1u)));
	                    float _578 = 0.0;
	                    uint _579 = 0u;
	                    for (;;)
	                    {
	                        if (!(_579 < _413))
	                        {
	                            break;
	                        }
	                        uint _2914 = _413 * _412.x;
	                        float _580 = _578;
	                        uint _581 = subgroupOr(g_LightBins_1._member0[((((_2914 * _412.y) * _2898.z) + (_2914 * _2898.y)) + (_413 * _2898.x)) + _579]);
	                        for (;;)
	                        {
	                            if (!(_581 != 0u))
	                            {
	                                break;
	                            }
	                            uint _2938 = _581;
	                            uint _2942 = uint(findLSB(_2938)) + (_579 * 32u);
	                            uint _2944 = _2938 & (_2938 - 1u);
	                            if ((uint(g_Lights_1._member0[_2942].m_nPathTraceFlags) & 1u) == 0u)
	                            {
	                                _581 = _2944;
	                                continue;
	                            }
	                            if (!((g_Lights_1._member0[_2942].m_nPathTraceFlags & 8) != 0))
	                            {
	                                _581 = _2944;
	                                continue;
	                            }
	                            do
	                            {
	                                do
	                                {
	                                    vec4 _2971 = g_Lights_1._member0[_2942].m_mToClipSpace * vec4(_2890.xyz, 1.0);
	                                    vec3 _2975 = _2971.xyz / vec3(_2971.w);
	                                    vec4 _2977;
	                                    _2977.x = _2975.x;
	                                    _2977.y = _2975.y;
	                                    _2977.z = _2975.z;
	                                    if (all(greaterThanEqual(_2977.xyz, vec3(-1.0, -1.0, 0.0))))
	                                    {
	                                        _573 = all(lessThanEqual(_2977.xyz, vec3(1.0)));
	                                    }
	                                    else
	                                    {
	                                        _573 = false;
	                                    }
	                                    if (!_573)
	                                    {
	                                        _574 = false;
	                                        break;
	                                    }
	                                    if (!all(lessThanEqual(abs((g_Lights_1._member0[_2942].m_mBarnIlluminationFromWorld * vec4(_2890, 1.0)).xyz), vec3(1.0))))
	                                    {
	                                        _574 = false;
	                                        break;
	                                    }
	                                    _574 = true;
	                                    break;
	                                } while(false);
	                                if (!_574)
	                                {
	                                    _575 = vec3(0.0);
	                                    break;
	                                }
	                                vec4 _3014 = g_Lights_1._member0[_2942].m_mToClipSpace * vec4(_2890.xyz, 1.0);
	                                vec3 _3018 = _3014.xyz / vec3(_3014.w);
	                                vec4 _3020;
	                                _3020.x = _3018.x;
	                                _3020.y = _3018.y;
	                                _3020.z = _3018.z;
	                                if (_1677)
	                                {
	                                    _572 = g_Lights_1._member0[_2942].m_vBounceColor.xyz;
	                                }
	                                else
	                                {
	                                    _572 = g_Lights_1._member0[_2942].m_vColor.xyz;
	                                }
	                                if (true)
	                                {
	                                    if (g_Lights_1._member0[_2942].m_nCookie >= 0)
	                                    {
	                                        if (g_Lights_1._member0[_2942].m_bSphericalCookie != 0)
	                                        {
	                                            vec4 _3078 = vec4(-g_Lights_1._member0[_2942].m_vOrientation.xyz, g_Lights_1._member0[_2942].m_vOrientation.w);
	                                            vec4 _3080 = _3078.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                                            vec3 _3083 = _3080.xyz;
	                                            vec3 _3084 = vec4((-normalize(g_Lights_1._member0[_2942].m_vLightPosition.xyz - _2890)).xyz, 0.0).xyz;
	                                            vec4 _3091 = vec4((_3084 * _3080.w) + cross(_3084, _3083), -dot(_3084, _3083));
	                                            vec3 _3092 = _3091.xyz;
	                                            float _3093 = _3078.w;
	                                            vec3 _3095 = _3078.xyz;
	                                            float _3096 = _3091.w;
	                                            vec3 _3104 = vec4(((_3092 * _3093) + (_3095 * _3096)) + cross(_3095, _3092), _282).xyz;
	                                            vec2 _3113 = vec2(atan(_3104.y, -_3104.x) * 0.15915493667125701904296875, acos(_3104.z) * 0.3183098733425140380859375);
	                                            vec2 _3120 = (_3113.xy * g_Lights_1._member0[_2942].m_vCookieParameters.zw) + g_Lights_1._member0[_2942].m_vCookieParameters.xy;
	                                            vec2 _3122 = _3113;
	                                            _3122.x = _3120.x;
	                                            _3122.y = _3120.y;
	                                            _571 = textureLod(nonuniformEXT(sampler2D(g_bindless_Texture2D[g_Lights_1._member0[_2942].m_nCookie], g_Sampler)), _3122, 0.0).xyz;
	                                        }
	                                        else
	                                        {
	                                            vec2 _3051 = fma(_3020.xyz.xy, vec2(0.5, -0.5), vec2(0.5));
	                                            vec2 _3058 = (_3051.xy * g_Lights_1._member0[_2942].m_vCookieParameters.zw) + g_Lights_1._member0[_2942].m_vCookieParameters.xy;
	                                            vec2 _3060 = _3051;
	                                            _3060.x = _3058.x;
	                                            _3060.y = _3058.y;
	                                            _571 = textureLod(nonuniformEXT(sampler2D(g_bindless_Texture2D[g_Lights_1._member0[_2942].m_nCookie], g_CookieSampler)), _3060, 0.0).xyz;
	                                        }
	                                    }
	                                    else
	                                    {
	                                        _571 = vec3(1.0);
	                                    }
	                                    _572 *= _571;
	                                }
	                                if (g_Lights_1._member0[_2942].m_nLuminaireType != 0)
	                                {
	                                    _572 = (_572 * g_Lights_1._member0[_2942].m_vLuminaireVectors.data[0].w) * 0.3183098733425140380859375;
	                                }
	                                else
	                                {
	                                    if (!(g_Lights_1._member0[_2942].m_vLightPosition.w == 0.0))
	                                    {
	                                        vec3 _3149 = g_Lights_1._member0[_2942].m_vLightPosition.xyz - _2890;
	                                        _572 *= (vec3(g_Lights_1._member0[_2942].m_vLightPosition.w) / max(vec3(dot(_3149, _3149)), vec3(g_Lights_1._member0[_2942].m_vLightPosition.w)));
	                                    }
	                                }
	                                if (g_Lights_1._member0[_2942].m_vDistanceFade_vSkirt.z > 0.0)
	                                {
	                                    _568 = smoothstep(0.0, 1.0, _3020.xyz.z * g_Lights_1._member0[_2942].m_vDistanceFade_vSkirt.z);
	                                }
	                                else
	                                {
	                                    _568 = 1.0;
	                                }
	                                if (g_Lights_1._member0[_2942].m_vDistanceFade_vSkirt.w > 0.0)
	                                {
	                                    _568 *= smoothstep(0.0, 1.0, (1.0 - _3020.xyz.z) * g_Lights_1._member0[_2942].m_vDistanceFade_vSkirt.w);
	                                }
	                                if (!(g_Lights_1._member0[_2942].m_vLightPosition.w == 0.0))
	                                {
	                                    vec3 _3203 = g_Lights_1._member0[_2942].m_vLightPosition.xyz - _2890;
	                                    float _3204 = length(_3203);
	                                    vec3 _3206 = _3203 / vec3(_3204);
	                                    float _3215 = _568 * smoothstep(0.0, 1.0, g_Lights_1._member0[_2942].m_vDistanceFade_vSkirt.x + (g_Lights_1._member0[_2942].m_vDistanceFade_vSkirt.y * _3204));
	                                    if (g_Lights_1._member0[_2942].m_nLuminaireType != 2)
	                                    {
	                                        _570 = g_Lights_1._member0[_2942].m_nLuminaireType != 1;
	                                    }
	                                    else
	                                    {
	                                        _570 = false;
	                                    }
	                                    if (_570)
	                                    {
	                                        float _3234 = 2.0 * g_Lights_1._member0[_2942].m_vOrientation.x;
	                                        float _3238 = 2.0 * g_Lights_1._member0[_2942].m_vOrientation.w;
	                                        vec3 _3252 = vec3((_3234 * g_Lights_1._member0[_2942].m_vOrientation.y) - (_3238 * g_Lights_1._member0[_2942].m_vOrientation.z), (1.0 - (_3234 * g_Lights_1._member0[_2942].m_vOrientation.x)) - ((2.0 * g_Lights_1._member0[_2942].m_vOrientation.z) * g_Lights_1._member0[_2942].m_vOrientation.z), ((2.0 * g_Lights_1._member0[_2942].m_vOrientation.y) * g_Lights_1._member0[_2942].m_vOrientation.z) + (_3238 * g_Lights_1._member0[_2942].m_vOrientation.x)) * g_Lights_1._member0[_2942].m_vAngleFade.z;
	                                        vec3 _3253 = _3206 - _3252;
	                                        vec3 _3254 = _3206 + _3252;
	                                        do
	                                        {
	                                            vec3 _3257 = _3254 - _3253;
	                                            float _3259 = dot(-_3253, _3257);
	                                            if (_3259 <= 0.0)
	                                            {
	                                                _566 = _3253;
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                float _3264 = dot(_3257, _3257);
	                                                if (_3259 > _3264)
	                                                {
	                                                    _566 = _3254;
	                                                    break;
	                                                }
	                                                else
	                                                {
	                                                    _566 = _3253 + (_3257 * (_3259 / _3264));
	                                                    break;
	                                                }
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (any(notEqual(_566, vec3(0.0))))
	                                        {
	                                            _567 = normalize(_566);
	                                        }
	                                        else
	                                        {
	                                            _567 = _566;
	                                        }
	                                        float _3288 = 2.0 * g_Lights_1._member0[_2942].m_vOrientation.x;
	                                        float _3291 = 2.0 * g_Lights_1._member0[_2942].m_vOrientation.w;
	                                        _569 = _3215 * saturate(g_Lights_1._member0[_2942].m_vAngleFade.x + (g_Lights_1._member0[_2942].m_vAngleFade.y * dot(vec3((1.0 - ((2.0 * g_Lights_1._member0[_2942].m_vOrientation.y) * g_Lights_1._member0[_2942].m_vOrientation.y)) - ((2.0 * g_Lights_1._member0[_2942].m_vOrientation.z) * g_Lights_1._member0[_2942].m_vOrientation.z), (_3288 * g_Lights_1._member0[_2942].m_vOrientation.y) + (_3291 * g_Lights_1._member0[_2942].m_vOrientation.z), (_3288 * g_Lights_1._member0[_2942].m_vOrientation.z) - (_3291 * g_Lights_1._member0[_2942].m_vOrientation.y)), _567)));
	                                    }
	                                    else
	                                    {
	                                        _569 = _3215;
	                                    }
	                                }
	                                else
	                                {
	                                    _569 = _568;
	                                }
	                                if (g_Lights_1._member0[_2942].m_nCookie == (-1))
	                                {
	                                    do
	                                    {
	                                        vec2 _3320 = abs(_3020.xyz.xy);
	                                        if (g_Lights_1._member0[_2942].m_vCookieParameters.z == 0.0)
	                                        {
	                                            _564 = smoothstep(1.0, g_Lights_1._member0[_2942].m_vCookieParameters.x, _3320.x) * smoothstep(1.0, g_Lights_1._member0[_2942].m_vCookieParameters.y, _3320.y);
	                                            break;
	                                        }
	                                        else
	                                        {
	                                            float _3325 = _3320.x;
	                                            float _3329 = _3320.y;
	                                            float _3336 = (-0.5) * g_Lights_1._member0[_2942].m_vCookieParameters.z;
	                                            float _3338 = (g_Lights_1._member0[_2942].m_vCookieParameters.x * g_Lights_1._member0[_2942].m_vCookieParameters.y) * pow(max(pow(g_Lights_1._member0[_2942].m_vCookieParameters.y * _3325, 2.0 / g_Lights_1._member0[_2942].m_vCookieParameters.z) + pow(g_Lights_1._member0[_2942].m_vCookieParameters.x * _3329, 2.0 / g_Lights_1._member0[_2942].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _3336);
	                                            float _3345 = pow(max(pow(_3325, 2.0 / g_Lights_1._member0[_2942].m_vCookieParameters.z) + pow(_3329, 2.0 / g_Lights_1._member0[_2942].m_vCookieParameters.z), 1.1754943508222875079687365372222e-38), _3336);
	                                            if (_3338 < _3345)
	                                            {
	                                                _564 = smoothstep(_3345, _3338, 1.0);
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                if (_3345 > 1.0)
	                                                {
	                                                    _565 = 1.0;
	                                                }
	                                                else
	                                                {
	                                                    _565 = 0.0;
	                                                }
	                                                _564 = _565;
	                                                break;
	                                            }
	                                            break;
	                                        }
	                                        break;
	                                    } while(false);
	                                    _569 *= _564;
	                                }
	                                _575 = _572 * _569;
	                                break;
	                            } while(false);
	                            float _3368 = dot(_575.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                            if (_3368 == 0.0)
	                            {
	                                _581 = _2944;
	                                continue;
	                            }
	                            _562 = false;
	                            do
	                            {
	                                switch (g_Lights_1._member0[_2942].m_nLuminaireType)
	                                {
	                                    case 0:
	                                    {
	                                        _582 = 1.0;
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_2942].m_vLightPosition.w == 0.0)
	                                            {
	                                                _537 = vec4(normalize(g_Lights_1._member0[_2942].m_vLightPosition.xyz), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _3894 = g_Lights_1._member0[_2942].m_vLightPosition.xyz - _2890;
	                                                float _3895 = length(_3894);
	                                                _537 = vec4(_3894 / vec3(_3895), _3895);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _562 = true;
	                                        _563 = _537;
	                                        break;
	                                    }
	                                    case 1:
	                                    {
	                                        vec3 _3734 = g_Lights_1._member0[_2942].m_vLuminaireVectors.data[1].xyz - g_Lights_1._member0[_2942].m_vLuminaireVectors.data[0].xyz;
	                                        vec3 _3738 = g_Lights_1._member0[_2942].m_vLuminaireVectors.data[2].xyz - g_Lights_1._member0[_2942].m_vLuminaireVectors.data[0].xyz;
	                                        float _3739 = length(_3734);
	                                        float _3740 = length(_3738);
	                                        vec3 _3742 = _3734 / vec3(_3739);
	                                        vec3 _3744 = _3738 / vec3(_3740);
	                                        vec3 _3745 = cross(_3742, _3744);
	                                        vec3 _3746 = g_Lights_1._member0[_2942].m_vLuminaireVectors.data[0].xyz - _2890;
	                                        float _3747 = dot(_3746, _3745);
	                                        if (_3747 > 0.0)
	                                        {
	                                            _539 = _3747 * (-1.0);
	                                            _540 = _3745 * (-1.0);
	                                        }
	                                        else
	                                        {
	                                            _539 = _3747;
	                                            _540 = _3745;
	                                        }
	                                        float _3756 = dot(_3746, _3742);
	                                        float _3757 = dot(_3746, _3744);
	                                        float _3758 = _3756 + _3739;
	                                        float _3759 = _3757 + _3740;
	                                        vec3 _3762 = vec3(_3756, _3757, _539);
	                                        vec3 _3763 = vec3(_3756, _3759, _539);
	                                        vec3 _3764 = vec3(_3758, _3757, _539);
	                                        vec3 _3765 = vec3(_3758, _3759, _539);
	                                        vec3 _3767 = normalize(cross(_3762, _3764));
	                                        vec3 _3769 = normalize(cross(_3764, _3765));
	                                        vec3 _3771 = normalize(cross(_3765, _3763));
	                                        vec3 _3773 = normalize(cross(_3763, _3762));
	                                        float _3790 = _3767.z;
	                                        float _3794 = (6.283185482025146484375 - acos(clamp(-dot(_3771, _3773), -1.0, 1.0))) - acos(clamp(-dot(_3773, _3767), -1.0, 1.0));
	                                        float _3796 = (acos(clamp(-dot(_3767, _3769), -1.0, 1.0)) + acos(clamp(-dot(_3769, _3771), -1.0, 1.0))) - _3794;
	                                        if (isnan(_3796))
	                                        {
	                                            _541 = 0.0;
	                                        }
	                                        else
	                                        {
	                                            _541 = _3796;
	                                        }
	                                        float _3804 = (_1715.x * _541) + _3794;
	                                        float _3809 = ((cos(_3804) * _3790) - _3771.z) / sin(_3804);
	                                        if (_3809 > 0.0)
	                                        {
	                                            _542 = 1.0;
	                                        }
	                                        else
	                                        {
	                                            _542 = -1.0;
	                                        }
	                                        float _3818 = _542;
	                                        float _3820 = clamp((1.0 / sqrt((_3809 * _3809) + (_3790 * _3790))) * _3818, -1.0, 1.0);
	                                        float _3828 = clamp((-(_3820 * _539)) / sqrt(1.0 - (_3820 * _3820)), _3756, _3758);
	                                        float _3831 = sqrt((_3828 * _3828) + (_539 * _539));
	                                        float _3832 = _3831 * _3831;
	                                        float _3835 = _3757 / sqrt(_3832 + (_3757 * _3757));
	                                        float _3842 = _3835 + (_1715.y * ((_3759 / sqrt(_3832 + (_3759 * _3759))) - _3835));
	                                        float _3843 = _3842 * _3842;
	                                        if (_3843 < 0.99999988079071044921875)
	                                        {
	                                            _542 = (_3842 * _3831) / sqrt(1.0 - _3843);
	                                        }
	                                        else
	                                        {
	                                            _542 = _3759;
	                                        }
	                                        vec3 _3860 = ((_2890 + (_3742 * _3828)) + (_3744 * _542)) + (_540 * _539);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_2942].m_vLightPosition.w == 0.0)
	                                            {
	                                                _538 = vec4(normalize(_3860), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _3871 = _3860 - _2890;
	                                                float _3872 = length(_3871);
	                                                _538 = vec4(_3871 / vec3(_3872), _3872);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _582 = 1.0 / _541;
	                                        _562 = true;
	                                        _563 = _538;
	                                        break;
	                                    }
	                                    case 2:
	                                    {
	                                        do
	                                        {
	                                            vec2 _3642 = (_1715 * 2.0) - vec2(1.0);
	                                            if (all(equal(_3642, vec2(0.0))))
	                                            {
	                                                _546 = vec2(0.0);
	                                                break;
	                                            }
	                                            float _3647 = _3642.x;
	                                            float _3649 = _3642.y;
	                                            if (abs(_3647) > abs(_3649))
	                                            {
	                                                _547 = _3647;
	                                                _548 = 0.785398185253143310546875 * (_3649 / _3647);
	                                            }
	                                            else
	                                            {
	                                                _547 = _3649;
	                                                _548 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_3647 / _3649));
	                                            }
	                                            _546 = vec2(cos(_548), sin(_548)) * _547;
	                                            break;
	                                        } while(false);
	                                        vec3 _3683 = (g_Lights_1._member0[_2942].m_vLuminaireVectors.data[0].xyz + (g_Lights_1._member0[_2942].m_vLuminaireVectors.data[1].xyz * _546.x)) + (g_Lights_1._member0[_2942].m_vLuminaireVectors.data[2].xyz * _546.y);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_2942].m_vLightPosition.w == 0.0)
	                                            {
	                                                _545 = vec4(normalize(_3683), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _3694 = _3683 - _2890;
	                                                float _3695 = length(_3694);
	                                                _545 = vec4(_3694 / vec3(_3695), _3695);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (isinf(_545.w))
	                                        {
	                                            _543 = true;
	                                        }
	                                        else
	                                        {
	                                            _543 = isnan(_545.w);
	                                        }
	                                        if (!_543)
	                                        {
	                                            _544 = _545.w * _545.w;
	                                        }
	                                        else
	                                        {
	                                            _544 = 1.0;
	                                        }
	                                        _582 = _544 / (max(0.0, dot(g_Lights_1._member0[_2942].m_vLuminaireVectors.data[3].xyz, -_545.xyz)) * g_Lights_1._member0[_2942].m_vLuminaireVectors.data[1].w);
	                                        _562 = true;
	                                        _563 = _545;
	                                        break;
	                                    }
	                                    case 3:
	                                    {
	                                        vec3 _3537 = g_Lights_1._member0[_2942].m_vLuminaireVectors.data[0].xyz - _2890;
	                                        float _3538 = dot(_3537, _3537);
	                                        float _3539 = sqrt(_3538);
	                                        vec3 _3541 = _3537 / vec3(_3539);
	                                        float _3542 = _3541.z;
	                                        if (_3542 >= 0.0)
	                                        {
	                                            _550 = 1.0;
	                                        }
	                                        else
	                                        {
	                                            _550 = -1.0;
	                                        }
	                                        float _3549 = (-1.0) / (_550 + _3542);
	                                        float _3550 = _3541.x;
	                                        float _3551 = _3541.y;
	                                        float _3553 = (_3550 * _3551) * _3549;
	                                        vec3 _3558 = _551;
	                                        _3558.x = 1.0 + (((_550 * _3550) * _3550) * _3549);
	                                        _3558.y = _550 * _3553;
	                                        _3558.z = (-_550) * _3550;
	                                        _551 = _3558;
	                                        vec3 _3565 = _552;
	                                        _3565.x = _3553;
	                                        _3565.y = _550 + ((_3551 * _3551) * _3549);
	                                        _3565.z = -_3551;
	                                        _552 = _3565;
	                                        float _3573 = g_Lights_1._member0[_2942].m_vLuminaireVectors.data[1].x * g_Lights_1._member0[_2942].m_vLuminaireVectors.data[1].x;
	                                        float _3577 = sqrt(max(0.0, 1.0 - (_3573 / _3538)));
	                                        float _3578 = _1715.x;
	                                        float _3581 = (1.0 - _3578) + (_3578 * _3577);
	                                        float _3585 = sqrt(max(0.0, 1.0 - (_3581 * _3581)));
	                                        float _3587 = _1715.y * 6.283185482025146484375;
	                                        float _3589 = _3539 * _3539;
	                                        float _3595 = (_3539 * _3581) - sqrt(max(0.0, _3573 - ((_3589 * _3585) * _3585)));
	                                        float _3601 = ((_3589 + _3573) - (_3595 * _3595)) / ((2.0 * _3539) * g_Lights_1._member0[_2942].m_vLuminaireVectors.data[1].x);
	                                        float _3605 = sqrt(max(0.0, 1.0 - (_3601 * _3601)));
	                                        vec3 _3617 = g_Lights_1._member0[_2942].m_vLuminaireVectors.data[0].xyz + ((mat3(-_3558, -_3565, -_3541) * vec3(cos(_3587) * _3605, sin(_3587) * _3605, _3601)) * g_Lights_1._member0[_2942].m_vLuminaireVectors.data[1].x);
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_2942].m_vLightPosition.w == 0.0)
	                                            {
	                                                _549 = vec4(normalize(_3617), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _3628 = _3617 - _2890;
	                                                float _3629 = length(_3628);
	                                                _549 = vec4(_3628 / vec3(_3629), _3629);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        _582 = 0.15915493667125701904296875 / (1.0 - _3577);
	                                        _562 = true;
	                                        _563 = _549;
	                                        break;
	                                    }
	                                    case 4:
	                                    case 5:
	                                    {
	                                        vec2 _559 = _1715;
	                                        if (_1715.x < g_Lights_1._member0[_2942].m_vLuminaireVectors.data[4].y)
	                                        {
	                                            vec2 _3428 = _559;
	                                            _3428.x = clamp(_3428.x / g_Lights_1._member0[_2942].m_vLuminaireVectors.data[4].y, 0.0, 0.99999988079071044921875);
	                                            _559 = _3428;
	                                            vec3 _3434 = normalize(g_Lights_1._member0[_2942].m_vLuminaireVectors.data[0].xyz - g_Lights_1._member0[_2942].m_vLuminaireVectors.data[1].xyz);
	                                            if (_3428.x >= 0.5)
	                                            {
	                                                vec2 _3445 = _559;
	                                                _3445.x = clamp((2.0 * _3445.x) - 1.0, 0.0, 0.99999988079071044921875);
	                                                _559 = _3445;
	                                                _560 = -_3434;
	                                                _561 = g_Lights_1._member0[_2942].m_vLuminaireVectors.data[1].xyz;
	                                            }
	                                            else
	                                            {
	                                                vec2 _3440 = _559;
	                                                _3440.x = clamp(2.0 * _3440.x, 0.0, 0.99999988079071044921875);
	                                                _559 = _3440;
	                                                _560 = _3434;
	                                                _561 = g_Lights_1._member0[_2942].m_vLuminaireVectors.data[0].xyz;
	                                            }
	                                            do
	                                            {
	                                                vec2 _3456 = (_559 * 2.0) - vec2(1.0);
	                                                if (all(equal(_3456, vec2(0.0))))
	                                                {
	                                                    _556 = vec2(0.0);
	                                                    break;
	                                                }
	                                                float _3461 = _3456.x;
	                                                float _3463 = _3456.y;
	                                                if (abs(_3461) > abs(_3463))
	                                                {
	                                                    _557 = _3461;
	                                                    _558 = 0.785398185253143310546875 * (_3463 / _3461);
	                                                }
	                                                else
	                                                {
	                                                    _557 = _3463;
	                                                    _558 = 1.57079637050628662109375 - (0.785398185253143310546875 * (_3461 / _3463));
	                                                }
	                                                _556 = vec2(cos(_558), sin(_558)) * _557;
	                                                break;
	                                            } while(false);
	                                            _561 += ((g_Lights_1._member0[_2942].m_vLuminaireVectors.data[2].xyz * _556.x) + (g_Lights_1._member0[_2942].m_vLuminaireVectors.data[3].xyz * _556.y));
	                                        }
	                                        else
	                                        {
	                                            vec2 _3407 = _559;
	                                            _3407.x = clamp((_3407.x - g_Lights_1._member0[_2942].m_vLuminaireVectors.data[4].y) / (1.0 - g_Lights_1._member0[_2942].m_vLuminaireVectors.data[4].y), 0.0, 0.99999988079071044921875);
	                                            _559 = _3407;
	                                            vec3 _3422 = (g_Lights_1._member0[_2942].m_vLuminaireVectors.data[2].xyz * cos(_3407.x * 6.283185482025146484375)) + (g_Lights_1._member0[_2942].m_vLuminaireVectors.data[3].xyz * sin(_3407.x * 6.283185482025146484375));
	                                            _560 = normalize(_3422);
	                                            _561 = mix(g_Lights_1._member0[_2942].m_vLuminaireVectors.data[0].xyz, g_Lights_1._member0[_2942].m_vLuminaireVectors.data[1].xyz, vec3(_3407.y)) + _3422;
	                                        }
	                                        do
	                                        {
	                                            if (g_Lights_1._member0[_2942].m_vLightPosition.w == 0.0)
	                                            {
	                                                _555 = vec4(normalize(_561), uintBitsToFloat(0x7f800000u /* inf */));
	                                                break;
	                                            }
	                                            else
	                                            {
	                                                vec3 _3499 = _561 - _2890;
	                                                float _3500 = length(_3499);
	                                                _555 = vec4(_3499 / vec3(_3500), _3500);
	                                                break;
	                                            }
	                                            break;
	                                        } while(false);
	                                        if (isinf(_555.w))
	                                        {
	                                            _553 = true;
	                                        }
	                                        else
	                                        {
	                                            _553 = isnan(_555.w);
	                                        }
	                                        if (!_553)
	                                        {
	                                            _554 = _555.w * _555.w;
	                                        }
	                                        else
	                                        {
	                                            _554 = 1.0;
	                                        }
	                                        _582 = _554 / (max(0.0, dot(_560, -_555.xyz)) * g_Lights_1._member0[_2942].m_vLuminaireVectors.data[1].w);
	                                        _562 = true;
	                                        _563 = _555;
	                                        break;
	                                    }
	                                    default:
	                                    {
	                                        _582 = 0.0;
	                                        _562 = true;
	                                        _563 = vec4(uintBitsToFloat(0x7fc00000u /* nan */));
	                                        break;
	                                    }
	                                }
	                                if (_562)
	                                {
	                                    break;
	                                }
	                                break;
	                            } while(false);
	                            float _3915 = dot(vec3(_298), _563.xyz);
	                            if ((!(dot(_425, _563.xyz) > 0.0)) && _637)
	                            {
	                                _536 = -_3915;
	                            }
	                            else
	                            {
	                                _536 = _3915;
	                            }
	                            float _3922 = (_3368 / _582) * max(0.0, _536);
	                            float _583 = _576.x;
	                            do
	                            {
	                                float _3927 = _577;
	                                float _3928 = _3927 + _3922;
	                                _577 = _3928;
	                                if (_3928 == 0.0)
	                                {
	                                    _534 = false;
	                                    break;
	                                }
	                                float _3933 = _3922 / _577;
	                                do
	                                {
	                                    if (_3933 <= 0.0)
	                                    {
	                                        _535 = false;
	                                        break;
	                                    }
	                                    if (_3933 >= 1.0)
	                                    {
	                                        _535 = true;
	                                        break;
	                                    }
	                                    if (_583 < _3933)
	                                    {
	                                        _583 = min(_583 / _3933, 0.99999988079071044921875);
	                                        _535 = true;
	                                        break;
	                                    }
	                                    _583 = min((_583 - _3933) / (1.0 - _3933), 0.99999988079071044921875);
	                                    _535 = false;
	                                    break;
	                                } while(false);
	                                _534 = _535;
	                                break;
	                            } while(false);
	                            vec2 _3958 = _576;
	                            _3958.x = _583;
	                            _576 = _3958;
	                            if (_534)
	                            {
	                                _488 = int(_2942);
	                                _487 = _575 / vec3(_582);
	                                _485 = _563;
	                                _580 = _3922;
	                            }
	                            _581 = _2944;
	                            continue;
	                        }
	                        _578 = _580;
	                        _579++;
	                        continue;
	                    }
	                    if (_488 != (-1))
	                    {
	                        vec3 _3978 = _487;
	                        vec3 _3979 = _3978 * (_577 / _578);
	                        bool _3988 = !(dot(_425, _485.xyz) > 0.0);
	                        vec3 _3991 = vec3(_298);
	                        vec3 _3996 = transpose(mat3(_344, _343, _3991)) * _485.xyz;
	                        float16_t _409 = _297;
	                        f16vec3 _408 = _296;
	                        float16_t _407 = _295;
	                        float16_t _406 = _294;
	                        uint _405 = _293;
	                        f16vec4 _404 = _292;
	                        vec3 _484 = _342;
	                        do
	                        {
	                            if (_3988)
	                            {
	                                f16vec4 _489 = _404;
	                                if ((_405 & 65535u) == 1u)
	                                {
	                                    _529 = any(greaterThan(vec3(_489.xyz), vec3(0.0)));
	                                }
	                                else
	                                {
	                                    _529 = false;
	                                }
	                                if (_529)
	                                {
	                                    _533 = vec3(_404.xyz);
	                                }
	                                else
	                                {
	                                    _533 = vec3(1.0);
	                                }
	                                _532 = _533 * 0.3183098733425140380859375;
	                                break;
	                            }
	                            else
	                            {
	                                vec3 _4015 = vec3(mix(f16vec3(_406), _408, f16vec3(_409)));
	                                float _4017 = float(_407);
	                                do
	                                {
	                                    float _4020 = _3996.z;
	                                    vec3 _4022 = _3996 + _484;
	                                    if (_4020 <= 0.0)
	                                    {
	                                        _531 = true;
	                                    }
	                                    else
	                                    {
	                                        _531 = _484.z <= 0.0;
	                                    }
	                                    if (_531)
	                                    {
	                                        _530 = vec3(0.0);
	                                        break;
	                                    }
	                                    if (all(equal(_4022, vec3(0.0))))
	                                    {
	                                        _530 = vec3(0.0);
	                                        break;
	                                    }
	                                    vec3 _4035 = normalize(_4022);
	                                    float _4036 = _4035.z;
	                                    float _4044 = _4017 * _4017;
	                                    float _4045 = _4044 * _4044;
	                                    float _4049 = (((_4036 * _4045) - _4036) * _4036) + 1.0;
	                                    float _4053 = _4017 * _4017;
	                                    float _4054 = _4053 * _4053;
	                                    _530 = (_4015 + ((vec3(1.0) - _4015) * pow(max(0.0, 1.0 - dot(_3996, _4035)), 5.0))) * (((_4045 / max(9.9999999392252902907785028219223e-09, _4049 * _4049)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_4020 * sqrt(((_484.z - (_4054 * _484.z)) * _484.z) + _4054)) + (_484.z * sqrt(((_4020 - (_4054 * _4020)) * _4020) + _4054))))) * 0.3183098733425140380859375);
	                                    break;
	                                } while(false);
	                                _532 = ((vec3(_408) * (1.0 - float(_409))) * 0.3183098733425140380859375) + _530;
	                                break;
	                            }
	                            break;
	                        } while(false);
	                        float _4108 = dot(_3991, _485.xyz);
	                        if (_3988)
	                        {
	                            _528 = -_4108;
	                        }
	                        else
	                        {
	                            _528 = _4108;
	                        }
	                        _487 = (_3979 * (_532 * 3.1415927410125732421875)) * max(0.0, _528);
	                        if (_3988)
	                        {
	                            f16vec4 _483 = _292;
	                            if ((_293 & 65535u) == 2u)
	                            {
	                                _527 = float(_483.x) > 0.0;
	                            }
	                            else
	                            {
	                                _527 = false;
	                            }
	                            _584 = _527;
	                        }
	                        else
	                        {
	                            _584 = false;
	                        }
	                        if (_584)
	                        {
	                            f16vec4 _403 = _292;
	                            uint _4139 = uint(_292.w);
	                            float _4144 = pow(saturate(-dot(normalize(_425 + _3991), _485.xyz)), 2.0);
	                            f16vec3 _4145 = f16vec3(vec3(0.0));
	                            if (isinf(_485.w))
	                            {
	                                _523 = true;
	                            }
	                            else
	                            {
	                                _523 = isnan(_485.w);
	                            }
	                            if (!_523)
	                            {
	                                _524 = _485.w;
	                            }
	                            else
	                            {
	                                _524 = 1000.0;
	                            }
	                            vec3 _493 = _427 + (_485.xyz * _524);
	                            float _492 = 0.0;
	                            vec3 _491 = -_485.xyz;
	                            if (_4144 > 0.0)
	                            {
	                                _525 = _524;
	                            }
	                            else
	                            {
	                                _525 = 0.0;
	                            }
	                            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _494, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_4145, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _4145, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	                            traceRayEXT(g_AccelStruct, 16u, 1u, 0u, 2u, 0u, _493, _492, _491, _525, 0);
	                            if (p.nInstance != (-1))
	                            {
	                                f16vec4 _490 = p.material.vMaterialBits;
	                                if ((p.material.nMaterialTypeAndFlags & 65535u) == 2u)
	                                {
	                                    _522 = float(_490.x) > 0.0;
	                                }
	                                else
	                                {
	                                    _522 = false;
	                                }
	                                if (!_522)
	                                {
	                                    _525 = 0.0;
	                                }
	                                else
	                                {
	                                    _525 = _4144;
	                                }
	                                _526 = _524 - p.flHitT;
	                            }
	                            else
	                            {
	                                _525 = _4144;
	                                _526 = _524;
	                            }
	                            float _4210 = _526 * float(_403.x);
	                            _486 = (_3979 * vec3(_296)) * ((exp2(SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_4139].m_vTransmissiveLogColor.xyz * (1.0 + (_4210 * SubsurfaceProfilesConstantBuffer_t.g_SubsurfaceProfile.data[_4139].m_fTransmissiveSaturation))) * exp(-_4210)) * _525);
	                        }
	                    }
	                    vec4 _640 = _485;
	                    if (_488 != (-1))
	                    {
	                        bool _4238 = any(notEqual(_487, vec3(0.0)));
	                        if (isinf(_640.w))
	                        {
	                            _520 = true;
	                        }
	                        else
	                        {
	                            _520 = isnan(_640.w);
	                        }
	                        if (!_520)
	                        {
	                            _521 = _640.w;
	                        }
	                        else
	                        {
	                            _521 = 56755.83984375;
	                        }
	                        vec4 _4255 = _640;
	                        _4255.w = _521;
	                        _640 = _4255;
	                        do
	                        {
	                            float _4264 = dot(_4255.xyz, g_Lights_1._member0[_488].m_vNearPlane.xyz);
	                            if (_4264 == 0.0)
	                            {
	                                _519 = 0.0;
	                                break;
	                            }
	                            _519 = (g_Lights_1._member0[_488].m_vNearPlane.w - dot(_1676, g_Lights_1._member0[_488].m_vNearPlane.xyz)) * (1.0 / _4264);
	                            break;
	                        } while(false);
	                        if (_519 > 0.0)
	                        {
	                            vec4 _4276 = _640;
	                            _4276.w = min(_4276.w, _519);
	                            _640 = _4276;
	                        }
	                        if (dot(_640.xyz, _425.xyz) < 0.0)
	                        {
	                            _639 = _440;
	                        }
	                        else
	                        {
	                            _639 = _441;
	                        }
	                        vec4 _4289 = _640;
	                        vec3 _4291 = _639 - _1676;
	                        _4289.w = _4289.w + dot(_4289.xyz, _4291);
	                        vec3 _4301 = normalize((_4289.xyz * _4289.w) + _4291);
	                        vec4 _4303 = _4289;
	                        _4303.x = _4301.x;
	                        _4303.y = _4301.y;
	                        _4303.z = _4301.z;
	                        _640 = _4303;
	                        do
	                        {
	                            int _4314 = int(g_SceneGlobalInfo._member0[0].m_nSceneGlobalInfoFlags);
	                            if ((_4314 & 1) != 0)
	                            {
	                                _518 = 32u;
	                                break;
	                            }
	                            if ((_4314 & 2) != 0)
	                            {
	                                _518 = 16u;
	                                break;
	                            }
	                            _518 = 0u;
	                            break;
	                        } while(false);
	                        vec3 _497 = _639;
	                        float _496 = 0.0;
	                        vec3 _495 = _4303.xyz;
	                        if (_4238)
	                        {
	                            _517 = _4303.w;
	                        }
	                        else
	                        {
	                            _517 = 0.0;
	                        }
	                        p_1 = PayloadShadow_t(1.0);
	                        traceRayEXT(g_AccelStruct, _518, 2u, 1u, 2u, 1u, _497, _496, _495, _517, 1);
	                        if (_4238)
	                        {
	                            _517 = p_1.m_flVisibility;
	                        }
	                        else
	                        {
	                            _517 = 0.0;
	                        }
	                        _639 = (_631 + _486) + (_487 * _517);
	                    }
	                    else
	                    {
	                        _639 = _631;
	                    }
	                }
	                else
	                {
	                    _639 = _631;
	                }
	                _447 = _441;
	                _446 = _440;
	                _445 = _439;
	                _444 = _438;
	                _313 = _306;
	                _312 = _305;
	                _311 = _304;
	                _310 = _303;
	                _309 = _301;
	                _308 = _300;
	                _307 = _299;
	                _370 = _365;
	                _369 = _364;
	                _368 = _363;
	                _367 = _362;
	                _366 = _361;
	                vec3 _4372 = vec3(_304);
	                float _4378 = min(0.89999997615814208984375, max(_4372.x, max(_4372.y, _4372.z)));
	                float _665 = _664.x;
	                do
	                {
	                    if (_4378 <= 0.0)
	                    {
	                        _516 = false;
	                        break;
	                    }
	                    if (_4378 >= 1.0)
	                    {
	                        _516 = true;
	                        break;
	                    }
	                    if (_665 < _4378)
	                    {
	                        _665 = min(_665 / _4378, 0.99999988079071044921875);
	                        _516 = true;
	                        break;
	                    }
	                    _665 = min((_665 - _4378) / (1.0 - _4378), 0.99999988079071044921875);
	                    _516 = false;
	                    break;
	                } while(false);
	                vec2 _4403 = _664;
	                _4403.x = _665;
	                _664 = _4403;
	                if (_516)
	                {
	                    float _424 = _367;
	                    do
	                    {
	                        _666 = 1.0;
	                        do
	                        {
	                            if (_424 <= 0.0)
	                            {
	                                _515 = false;
	                                break;
	                            }
	                            if (_424 >= 1.0)
	                            {
	                                _515 = true;
	                                break;
	                            }
	                            if (_664.x < _424)
	                            {
	                                vec2 _4426 = _664;
	                                _4426.x = min(_4426.x / _424, 0.99999988079071044921875);
	                                _664 = _4426;
	                                _515 = true;
	                                break;
	                            }
	                            vec2 _4431 = _664;
	                            _4431.x = min((_4431.x - _424) / (1.0 - _424), 0.99999988079071044921875);
	                            _664 = _4431;
	                            _515 = false;
	                            break;
	                        } while(false);
	                        if (_515)
	                        {
	                            _666 = _424;
	                            _514 = true;
	                            break;
	                        }
	                        else
	                        {
	                            _666 = 1.0 - _424;
	                            _514 = false;
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    if (_514)
	                    {
	                        _447 = _446;
	                    }
	                    f16vec3 _341 = _313;
	                    float16_t _340 = _312;
	                    f16vec3 _339 = _311;
	                    float16_t _338 = _310;
	                    float16_t _337 = _309;
	                    uint _336 = _308;
	                    f16vec4 _335 = _307;
	                    vec3 _423 = _370;
	                    vec3 _422 = _369;
	                    float _421 = _368;
	                    vec3 _420 = _366;
	                    do
	                    {
	                        vec2 _512 = _664;
	                        if (_514)
	                        {
	                            float _4542 = sqrt(_512.y);
	                            float _4544 = 6.283185482025146484375 * _512.x;
	                            vec3 _4552 = vec3(cos(_4544) * _4542, sin(_4544) * _4542, sqrt(max(0.0, 1.0 - _512.y)));
	                            _4552.z = -_4552.z;
	                            _511 = _4552;
	                            break;
	                        }
	                        else
	                        {
	                            float _513 = _512.x;
	                            do
	                            {
	                                if (_421 <= 0.0)
	                                {
	                                    _510 = false;
	                                    break;
	                                }
	                                if (_421 >= 1.0)
	                                {
	                                    _510 = true;
	                                    break;
	                                }
	                                if (_513 < _421)
	                                {
	                                    _513 = min(_513 / _421, 0.99999988079071044921875);
	                                    _510 = true;
	                                    break;
	                                }
	                                _513 = min((_513 - _421) / (1.0 - _421), 0.99999988079071044921875);
	                                _510 = false;
	                                break;
	                            } while(false);
	                            vec2 _4490 = _512;
	                            _4490.x = _513;
	                            _512 = _4490;
	                            if (_510)
	                            {
	                                float _4495 = float(_338);
	                                float _4503 = ((_4495 * _4495) * sqrt(_512.x)) / sqrt(1.0 - _512.x);
	                                float _4506 = 1.0 / (1.0 + (_4503 * _4503));
	                                float _4509 = sqrt(max(0.0, 1.0 - _4506));
	                                float _4512 = 6.283185482025146484375 * _512.y;
	                                vec3 _4517 = vec3(cos(_4512) * _4509, sin(_4512) * _4509, sqrt(_4506));
	                                if (dot(_420, _4517) > 0.0)
	                                {
	                                    _509 = _4517;
	                                }
	                                else
	                                {
	                                    _509 = -_4517;
	                                }
	                                _511 = -reflect(_420, _509);
	                                break;
	                            }
	                            float _4529 = sqrt(_512.y);
	                            float _4531 = 6.283185482025146484375 * _512.x;
	                            _511 = vec3(cos(_4531) * _4529, sin(_4531) * _4529, sqrt(max(0.0, 1.0 - _512.y)));
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    _658 = _511;
	                    vec3 _4559 = normalize(_511 + _420);
	                    float _4560 = _4559.z;
	                    if (_514)
	                    {
	                        _507 = _511.z * (-0.3183098733425140380859375);
	                    }
	                    else
	                    {
	                        if (_421 > 0.0)
	                        {
	                            float _4573 = float(_338);
	                            float _4574 = _4573 * _4573;
	                            float _4575 = _4574 * _4574;
	                            float _4579 = (((_4560 * _4575) - _4560) * _4560) + 1.0;
	                            _506 = 1.0 - _421;
	                            _507 = _421 * (((_4575 / max(9.9999999392252902907785028219223e-09, _4579 * _4579)) * _4560) / (12.56637096405029296875 * max(0.0, dot(_420, _4559))));
	                        }
	                        else
	                        {
	                            _506 = 1.0;
	                            _507 = 0.0;
	                        }
	                        _507 += (_506 * (_511.z * 0.3183098733425140380859375));
	                    }
	                    if (_507 == 0.0)
	                    {
	                        _508 = true;
	                    }
	                    else
	                    {
	                        _508 = isnan(_507);
	                    }
	                    if (_508)
	                    {
	                        _506 = 3.4028234663852885981170418348452e+38;
	                    }
	                    else
	                    {
	                        _506 = _507;
	                    }
	                    float _667 = _506;
	                    do
	                    {
	                        if (_514)
	                        {
	                            f16vec4 _498 = _335;
	                            if ((_336 & 65535u) == 1u)
	                            {
	                                _501 = any(greaterThan(vec3(_498.xyz), vec3(0.0)));
	                            }
	                            else
	                            {
	                                _501 = false;
	                            }
	                            if (_501)
	                            {
	                                _505 = vec3(_335.xyz);
	                            }
	                            else
	                            {
	                                _505 = vec3(1.0);
	                            }
	                            _504 = _505 * 0.3183098733425140380859375;
	                            break;
	                        }
	                        else
	                        {
	                            vec3 _4620 = vec3(mix(f16vec3(_337), _339, f16vec3(_340)));
	                            float _4622 = float(_338);
	                            do
	                            {
	                                vec3 _4627 = _658 + _420;
	                                if (_658.z <= 0.0)
	                                {
	                                    _503 = true;
	                                }
	                                else
	                                {
	                                    _503 = _420.z <= 0.0;
	                                }
	                                if (_503)
	                                {
	                                    _502 = vec3(0.0);
	                                    break;
	                                }
	                                if (all(equal(_4627, vec3(0.0))))
	                                {
	                                    _502 = vec3(0.0);
	                                    break;
	                                }
	                                vec3 _4640 = normalize(_4627);
	                                float _4641 = _4640.z;
	                                float _4649 = _4622 * _4622;
	                                float _4650 = _4649 * _4649;
	                                float _4654 = (((_4641 * _4650) - _4641) * _4641) + 1.0;
	                                float _4658 = _4622 * _4622;
	                                float _4659 = _4658 * _4658;
	                                _502 = (_4620 + ((vec3(1.0) - _4620) * pow(max(0.0, 1.0 - dot(_658, _4640)), 5.0))) * (((_4650 / max(9.9999999392252902907785028219223e-09, _4654 * _4654)) * (0.5 / max(9.9999997473787516355514526367188e-06, (_658.z * sqrt(((_420.z - (_4659 * _420.z)) * _420.z) + _4659)) + (_420.z * sqrt(((_658.z - (_4659 * _658.z)) * _658.z) + _4659))))) * 0.3183098733425140380859375);
	                                break;
	                            } while(false);
	                            _504 = ((vec3(_339) * (1.0 - float(_340))) * 0.3183098733425140380859375) + _502;
	                            break;
	                        }
	                        break;
	                    } while(false);
	                    vec3 _4709 = _658;
	                    vec3 _4715 = mat3(_423, _422, vec3(_341)) * _4709;
	                    _658 = _4715;
	                    float _4718 = dot(vec3(_313), _4715);
	                    if (_514)
	                    {
	                        _500 = -_4718;
	                    }
	                    else
	                    {
	                        _500 = _4718;
	                    }
	                    do
	                    {
	                        if ((_444 & 1024) != 0)
	                        {
	                            _499 = true;
	                            break;
	                        }
	                        _499 = (dot(_445, _658) > 0.0) != _514;
	                        break;
	                    } while(false);
	                    if (_499)
	                    {
	                        _668 = (_662 * (_504 * max(0.0, _500))) / vec3((_4378 * _666) * _667);
	                    }
	                    else
	                    {
	                        _668 = vec3(0.0);
	                    }
	                    _660 = _668;
	                }
	                else
	                {
	                    _660 = vec3(0.0);
	                }
	                _659++;
	                _661 = (_661 + ((_639 * _662) * _663)) + ((vec3(_302) * _662) * _663);
	                continue;
	            }
	            vIrradiance = (_661 * max(0.0, dot(_939, _937))) * 0.3183098733425140380859375;
	        }
	        else
	        {
	            vIrradiance = vec3(0.0);
	        }
	        vec4 _4762 = g_Samples._member0[nSampleIndex].vIrradiance_flSampleCount;
	        vec3 _4764 = abs(vIrradiance);
	        float _4769 = max(_4764.x, max(_4764.y, _4764.z));
	        vec3 _4780 = mix(_4762.xyz, clamp(vIrradiance / vec3(_4769), vec3(-1.0), vec3(1.0)) * clamp(_4769, -100.0, 100.0), vec3(1.0 / (1.0 + _4762.w)));
	        vec4 _4782 = _4762;
	        _4782.x = _4780.x;
	        _4782.y = _4780.y;
	        _4782.z = _4780.z;
	        _4782.w = _4782.w + 1.0;
	        g_Samples._member0[nSampleIndex].vIrradiance_flSampleCount = _4782;
	        break;
	    } while(false);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
