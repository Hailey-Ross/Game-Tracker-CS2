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
	DynamicCombo( D_LPV_PASS, 0..1 );
	
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
	#extension GL_KHR_shader_subgroup_vote : require
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
	
	layout(set = 6, binding = 159, std430) buffer RWStructuredBuffer
	{
	    uint _member0[];
	} g_SolidMask;
	
	layout(set = 3, binding = 35, std430) readonly buffer StructuredBuffer
	{
	    PackedRtxInstanceData_t_natural _member0[];
	} g_instanceBuffer;
	
	layout(push_constant, std430) uniform LpvPushConstants_t_natural
	{
	    int m_nEstimate;
	    int m_nDimensionCount;
	    int m_nFilterRadius;
	    int m_nFog;
	    uvec4 m_vPackedCellStartAndCount;
	    vec4 m_vOffset;
	    vec4 m_vLpvMinBounds;
	    vec4 m_vLpvMaxBounds;
	    layout(row_major) mat4x3 m_mLpvLocalToWorld;
	} g_PushConstants;
	
	layout(location = 0) rayPayloadEXT Payload_t p;
	layout(set = 3, binding = 30) uniform accelerationStructureEXT g_AccelStruct;
	layout(location = 1) rayPayloadEXT PayloadShadow_t p_1;
	
	void main()
	{
	    do
	    {
	        int nIdx = int((gl_LaunchSizeEXT.x * ((gl_LaunchIDEXT.z * gl_LaunchSizeEXT.y) + gl_LaunchIDEXT.y)) + gl_LaunchIDEXT.x);
	        vec3 _180 = g_PushConstants.m_mLpvLocalToWorld * vec4((((g_PushConstants.m_vLpvMaxBounds.xyz - g_PushConstants.m_vLpvMinBounds.xyz) / vec3(gl_LaunchSizeEXT)) * (vec3(ivec3(gl_LaunchIDEXT)) + g_PushConstants.m_vOffset.xyz)) + g_PushConstants.m_vLpvMinBounds.xyz, 1.0);
	        uint nFlags;
	        if (g_PushConstants.m_nEstimate > 0)
	        {
	            nFlags = g_SolidMask._member0[nIdx];
	        }
	        else
	        {
	            nFlags = 0u;
	        }
	        bool bValidSample_2 = (nFlags & 1u) == 0u;
	        if (subgroupAll(!bValidSample_2))
	        {
	            break;
	        }
	        bool bValidSample = bValidSample_2;
	        int i = 0;
	        int nBackfacesSeen = 0;
	        bool bValidSample_1;
	        vec3 _133;
	        float _140;
	        bool _141;
	        bool _142;
	        bool _143;
	        float _144;
	        SPIRV_CROSS_LOOP
	        for (;;)
	        {
	            if (i < 32)
	            {
	                _143 = bValidSample;
	            }
	            else
	            {
	                _143 = false;
	            }
	            if (!_143)
	            {
	                break;
	            }
	            uint _211 = uint(i);
	            uint _216 = (_211 << 16u) | (_211 >> 16u);
	            uint _221 = ((_216 & 1431655765u) << 1u) | ((_216 & 2863311530u) >> 1u);
	            uint _226 = ((_221 & 858993459u) << 2u) | ((_221 & 3435973836u) >> 2u);
	            uint _231 = ((_226 & 252645135u) << 4u) | ((_226 & 4042322160u) >> 4u);
	            vec2 _239 = vec2(float(_211) * 0.03125, float(((_231 & 16711935u) << 8u) | ((_231 & 4278255360u) >> 8u)) * 2.3283064365386962890625e-10);
	            float _240 = _239.y;
	            float _245 = 2.0 * sqrt(max(0.0, _240 - (_240 * _240)));
	            float _247 = 6.283185482025146484375 * _239.x;
	            vec3 _254 = vec3(cos(_247) * _245, sin(_247) * _245, 1.0 - (2.0 * _240));
	            vec3 _132 = _180.xyz;
	            float _131 = 0.0;
	            vec3 _130 = _254;
	            if (bValidSample)
	            {
	                _144 = 56755.83984375;
	            }
	            else
	            {
	                _144 = 0.0;
	            }
	            f16vec3 _261 = f16vec3(vec3(0.0));
	            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _133, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_261, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _261, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	            traceRayEXT(g_AccelStruct, 0u, 16u, 0u, 2u, 0u, _132, _131, _130, _144, 0);
	            vec3 _129 = _132;
	            vec3 _128 = _130;
	            vec3 _127 = p.vSmoothPositionWs;
	            vec3 _126 = p.vFaceNormalWs;
	            float _125 = p.flHitT;
	            int _124 = p.nInstance;
	            f16vec3 _123 = p.material.vNormalWs;
	            do
	            {
	                if (!(_124 != (-1)))
	                {
	                    _142 = false;
	                    break;
	                }
	                vec3 _135 = (_129 + (_128 * _125)) + (_126 * ((abs(_129) + vec3(abs(_125))) * 9.9999997473787516355514526367188e-05));
	                vec3 _134 = _126;
	                if (bValidSample)
	                {
	                    _141 = any(notEqual(_127, vec3(3.4028234663852885981170418348452e+38)));
	                }
	                else
	                {
	                    _141 = false;
	                }
	                vec3 _318 = _127 - _135;
	                float _319 = length(_318);
	                vec3 _138 = _135;
	                float _137 = 0.0;
	                vec3 _136 = vec4(_318 / vec3(_319), _319).xyz;
	                if (_141)
	                {
	                    _140 = _319;
	                }
	                else
	                {
	                    _140 = 0.0;
	                }
	                p_1 = PayloadShadow_t(1.0);
	                traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _138, _137, _136, _140, 1);
	                if (_141)
	                {
	                    _140 = p_1.m_flVisibility;
	                }
	                else
	                {
	                    _140 = 0.0;
	                }
	                if (_140 == 1.0)
	                {
	                    _135 = _127;
	                    _134 = vec3(_123);
	                }
	                uint _139 = g_instanceBuffer._member0[uint(_124)].nMaterialFlags_nInstanceFlags;
	                if ((int((_139 >> uint(16)) & 65535u) & 1) != 0)
	                {
	                    _142 = false;
	                    break;
	                }
	                if ((int(_139 & 65535u) & 2048) != 0)
	                {
	                    _142 = false;
	                    break;
	                }
	                _142 = dot(_254, _134) > 0.0;
	                break;
	            } while(false);
	            if (_142)
	            {
	                int nBackfacesSeen_1 = nBackfacesSeen + 1;
	                if (float(nBackfacesSeen_1) > 12.80000019073486328125)
	                {
	                    bValidSample_1 = false;
	                }
	                else
	                {
	                    bValidSample_1 = bValidSample;
	                }
	                bValidSample = bValidSample_1;
	                nBackfacesSeen = nBackfacesSeen_1;
	            }
	            i++;
	            continue;
	        }
	        if (!bValidSample)
	        {
	            nFlags |= 1u;
	        }
	        g_SolidMask._member0[nIdx] = nFlags;
	        break;
	    } while(false);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
