//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Farfield lpv computation";
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
	DynamicCombo( D_FARFIELD_PASS, 0..1 );
	
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
	
	struct FarfieldBrick_t_natural
	{
	    ivec3 m_vCellOffset;
	    uint m_nLevel;
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
	
	layout(set = 6, binding = 162, std430) buffer RWStructuredBuffer
	{
	    FarfieldBrick_t_natural _member0[];
	} g_Bricks;
	
	layout(set = 6, binding = 159, std430) buffer g_SolidMaskBits
	{
	    uint _member0[];
	} g_SolidMaskBits_1;
	
	layout(set = 3, binding = 35, std430) readonly buffer StructuredBuffer
	{
	    PackedRtxInstanceData_t_natural _member0[];
	} g_instanceBuffer;
	
	layout(push_constant, std430) uniform FarfieldPushConstants_t_natural
	{
	    int m_nEstimate;
	    int m_nDimensionCount;
	    int m_nFilterRadius;
	    int m_nFirstBrick;
	    uvec4 m_vCellCount;
	    layout(row_major) mat4x3 m_mCellToWorld;
	} g_PushConstants;
	
	layout(location = 0) rayPayloadEXT Payload_t p;
	layout(set = 3, binding = 30) uniform accelerationStructureEXT g_AccelStruct;
	layout(location = 1) rayPayloadEXT PayloadShadow_t p_1;
	
	void main()
	{
	    do
	    {
	        uint nBrick = uint(g_PushConstants.m_nFirstBrick) + gl_LaunchIDEXT.z;
	        uint _172 = gl_LaunchIDEXT.x + (gl_LaunchIDEXT.y * 512u);
	        ivec3 _146 = g_Bricks._member0[nBrick].m_vCellOffset;
	        uint _145 = g_Bricks._member0[nBrick].m_nLevel;
	        uvec3 _158;
	        uvec3 _179 = _158;
	        _179.x = _172 % 32u;
	        uint _181 = _172 / 32u;
	        _179.y = _181 % 32u;
	        _179.z = _181 / 32u;
	        _158 = _179;
	        vec3 _186 = vec3(_179);
	        vec3 _157;
	        do
	        {
	            if (_145 == 7u)
	            {
	                _157 = _186 * (vec3(g_PushConstants.m_vCellCount.xyz) * vec3(0.03125));
	                break;
	            }
	            _157 = vec3(_146) + (_186 * (float(1u << _145) * 0.03125));
	            break;
	        } while(false);
	        vec3 _210 = g_PushConstants.m_mCellToWorld * vec4(_157, 1.0);
	        uvec3 _213 = uvec3(clamp(ivec3(_179), ivec3(0), ivec3(31)));
	        uint _222 = (nBrick * 32768u) + (_213.x + (32u * (_213.y + (32u * _213.z))));
	        bool _229 = ((g_SolidMaskBits_1._member0[_222 >> uint(5)] >> (_222 & 31u)) & 1u) != 0u;
	        if (subgroupAll(_229))
	        {
	            break;
	        }
	        bool bValidSample = !_229;
	        int i = 0;
	        int nBackfacesSeen = 0;
	        bool bValidSample_1;
	        vec3 _147;
	        float _154;
	        bool _155;
	        bool _156;
	        bool _159;
	        float _160;
	        SPIRV_CROSS_LOOP
	        for (;;)
	        {
	            if (i < 32)
	            {
	                _159 = bValidSample;
	            }
	            else
	            {
	                _159 = false;
	            }
	            if (!_159)
	            {
	                break;
	            }
	            uint _249 = uint(i);
	            uint _254 = (_249 << 16u) | (_249 >> 16u);
	            uint _259 = ((_254 & 1431655765u) << 1u) | ((_254 & 2863311530u) >> 1u);
	            uint _264 = ((_259 & 858993459u) << 2u) | ((_259 & 3435973836u) >> 2u);
	            uint _269 = ((_264 & 252645135u) << 4u) | ((_264 & 4042322160u) >> 4u);
	            vec2 _277 = vec2(float(_249) * 0.03125, float(((_269 & 16711935u) << 8u) | ((_269 & 4278255360u) >> 8u)) * 2.3283064365386962890625e-10);
	            float _278 = _277.y;
	            float _283 = 2.0 * sqrt(max(0.0, _278 - (_278 * _278)));
	            float _285 = 6.283185482025146484375 * _277.x;
	            vec3 _292 = vec3(cos(_285) * _283, sin(_285) * _283, 1.0 - (2.0 * _278));
	            vec3 _144 = _210.xyz;
	            float _143 = 0.0;
	            vec3 _142 = _292;
	            if (bValidSample)
	            {
	                _160 = 56755.83984375;
	            }
	            else
	            {
	                _160 = 0.0;
	            }
	            f16vec3 _299 = f16vec3(vec3(0.0));
	            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _147, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_299, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _299, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	            traceRayEXT(g_AccelStruct, 0u, 16u, 0u, 2u, 0u, _144, _143, _142, _160, 0);
	            vec3 _141 = _144;
	            vec3 _140 = _142;
	            vec3 _139 = p.vSmoothPositionWs;
	            vec3 _138 = p.vFaceNormalWs;
	            float _137 = p.flHitT;
	            int _136 = p.nInstance;
	            f16vec3 _135 = p.material.vNormalWs;
	            do
	            {
	                if (!(_136 != (-1)))
	                {
	                    _156 = false;
	                    break;
	                }
	                vec3 _149 = (_141 + (_140 * _137)) + (_138 * ((abs(_141) + vec3(abs(_137))) * 9.9999997473787516355514526367188e-05));
	                vec3 _148 = _138;
	                if (bValidSample)
	                {
	                    _155 = any(notEqual(_139, vec3(3.4028234663852885981170418348452e+38)));
	                }
	                else
	                {
	                    _155 = false;
	                }
	                vec3 _356 = _139 - _149;
	                float _357 = length(_356);
	                vec3 _152 = _149;
	                float _151 = 0.0;
	                vec3 _150 = vec4(_356 / vec3(_357), _357).xyz;
	                if (_155)
	                {
	                    _154 = _357;
	                }
	                else
	                {
	                    _154 = 0.0;
	                }
	                p_1 = PayloadShadow_t(1.0);
	                traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _152, _151, _150, _154, 1);
	                if (_155)
	                {
	                    _154 = p_1.m_flVisibility;
	                }
	                else
	                {
	                    _154 = 0.0;
	                }
	                if (_154 == 1.0)
	                {
	                    _149 = _139;
	                    _148 = vec3(_135);
	                }
	                uint _153 = g_instanceBuffer._member0[uint(_136)].nMaterialFlags_nInstanceFlags;
	                if ((int((_153 >> uint(16)) & 65535u) & 1) != 0)
	                {
	                    _156 = false;
	                    break;
	                }
	                if ((int(_153 & 65535u) & 2048) != 0)
	                {
	                    _156 = false;
	                    break;
	                }
	                _156 = dot(_292, _148) > 0.0;
	                break;
	            } while(false);
	            if (_156)
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
	            uint _434 = (nBrick * 32768u) + (_179.x + (32u * (_179.y + (32u * _179.z))));
	            uint _439 = atomicOr(g_SolidMaskBits_1._member0[_434 >> uint(5)], 1u << (_434 & 31u));
	        }
	        break;
	    } while(false);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
