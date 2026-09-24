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
	
	layout(set = 6, binding = 158, std430) buffer RWStructuredBuffer
	{
	    LightmapSample_t_natural _member0[];
	} g_LightmapSamples;
	
	layout(set = 3, binding = 35, std430) readonly buffer StructuredBuffer
	{
	    PackedRtxInstanceData_t_natural _member0[];
	} g_instanceBuffer;
	
	layout(location = 0) rayPayloadEXT Payload_t p;
	layout(set = 3, binding = 30) uniform accelerationStructureEXT g_AccelStruct;
	layout(location = 1) rayPayloadEXT PayloadShadow_t p_1;
	
	void main()
	{
	    uint nSample = (gl_LaunchIDEXT.y * gl_LaunchSizeEXT.x) + gl_LaunchIDEXT.x;
	    vec4 _152 = g_LightmapSamples._member0[nSample].m_vPositionWs;
	    vec4 _151 = g_LightmapSamples._member0[nSample].m_vShadingNormalWs_vTransmissiveR;
	    vec4 _150 = g_LightmapSamples._member0[nSample].m_vInterpolatedNormalWs_vTransmissiveG;
	    vec4 _149 = g_LightmapSamples._member0[nSample].m_vFaceNormalWs_vTransmissiveB;
	    vec4 _148 = g_LightmapSamples._member0[nSample].m_vTangentWs;
	    vec2 _147 = g_LightmapSamples._member0[nSample].m_vLightmapUv;
	    int _146 = g_LightmapSamples._member0[nSample].m_nInstanceFlags;
	    uint _145 = g_LightmapSamples._member0[nSample].m_nSampleFlags;
	    vec4 _160 = g_LightmapSamples._member0[nSample].m_vPositionWs;
	    vec4 _159 = g_LightmapSamples._member0[nSample].m_vShadingNormalWs_vTransmissiveR;
	    vec4 _158 = g_LightmapSamples._member0[nSample].m_vInterpolatedNormalWs_vTransmissiveG;
	    vec4 _157 = g_LightmapSamples._member0[nSample].m_vFaceNormalWs_vTransmissiveB;
	    vec4 _156 = g_LightmapSamples._member0[nSample].m_vTangentWs;
	    vec2 _155 = g_LightmapSamples._member0[nSample].m_vLightmapUv;
	    int _154 = g_LightmapSamples._member0[nSample].m_nInstanceFlags;
	    uint _153 = g_LightmapSamples._member0[nSample].m_nSampleFlags;
	    float _201;
	    if (g_LightmapSamples._member0[nSample].m_vFaceNormalWs_vTransmissiveB.z >= 0.0)
	    {
	        _201 = 1.0;
	    }
	    else
	    {
	        _201 = -1.0;
	    }
	    float _234 = (-1.0) / (_201 + g_LightmapSamples._member0[nSample].m_vFaceNormalWs_vTransmissiveB.z);
	    float _238 = (g_LightmapSamples._member0[nSample].m_vFaceNormalWs_vTransmissiveB.x * g_LightmapSamples._member0[nSample].m_vFaceNormalWs_vTransmissiveB.y) * _234;
	    vec3 vTangent1Ws;
	    vec3 _243 = vTangent1Ws;
	    _243.x = 1.0 + (((_201 * g_LightmapSamples._member0[nSample].m_vFaceNormalWs_vTransmissiveB.x) * g_LightmapSamples._member0[nSample].m_vFaceNormalWs_vTransmissiveB.x) * _234);
	    _243.y = _201 * _238;
	    _243.z = (-_201) * g_LightmapSamples._member0[nSample].m_vFaceNormalWs_vTransmissiveB.x;
	    vTangent1Ws = _243;
	    vec3 vTangent2Ws;
	    vec3 _250 = vTangent2Ws;
	    _250.x = _238;
	    _250.y = _201 + ((g_LightmapSamples._member0[nSample].m_vFaceNormalWs_vTransmissiveB.y * g_LightmapSamples._member0[nSample].m_vFaceNormalWs_vTransmissiveB.y) * _234);
	    _250.z = -g_LightmapSamples._member0[nSample].m_vFaceNormalWs_vTransmissiveB.y;
	    vTangent2Ws = _250;
	    vec4 _258 = _160;
	    bool bValidSample_2 = _258.w != 0.0;
	    float _202;
	    if (bValidSample_2)
	    {
	        _202 = 12.0;
	    }
	    else
	    {
	        _202 = 0.0;
	    }
	    float _200 = _202;
	    vec4 _168 = _152;
	    vec4 _167 = _151;
	    vec4 _166 = _150;
	    vec4 _165 = _149;
	    vec4 _164 = _148;
	    vec2 _163 = _147;
	    int _162 = _146;
	    uint _161 = _145;
	    vec3 _274 = _149.xyz * 0.0078125;
	    vec3 _275 = _152.xyz - _274;
	    do
	    {
	        f16vec3 _279 = f16vec3(vec3(0.0));
	        vec3 _170;
	        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _170, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_279, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _279, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	        traceRayEXT(g_AccelStruct, 0u, 1u, 0u, 2u, 0u, _275, 0.0, _149.xyz, _200, 0);
	        if (!(p.nInstance != (-1)))
	        {
	            break;
	        }
	        vec3 _196;
	        if (p.bFlippedNormal)
	        {
	            _196 = -p.vFaceNormalWs;
	        }
	        else
	        {
	            _196 = p.vFaceNormalWs;
	        }
	        if (!(dot(_149.xyz, _196) > 0.0))
	        {
	            break;
	        }
	        float _197;
	        if (p.bFlippedNormal)
	        {
	            _197 = -1.0;
	        }
	        else
	        {
	            _197 = 1.0;
	        }
	        vec3 _340 = (_275 + (_149.xyz * p.flHitT)) + (p.vFaceNormalWs * ((abs(_275) + vec3(abs(p.flHitT))) * 9.9999997473787516355514526367188e-05));
	        float _344 = length(_340 - _152.xyz);
	        if (_344 < _200)
	        {
	            vec4 _350 = _168;
	            _350.x = _340.x;
	            _350.y = _340.y;
	            _350.z = _340.z;
	            _168 = _350;
	            vec3 _358 = vec3(p.material.vNormalWs) * _197;
	            vec4 _360 = _167;
	            _360.x = _358.x;
	            _360.y = _358.y;
	            _360.z = _358.z;
	            _167 = _360;
	            vec3 _367 = p.vInterpolatedNormalWs.xyz * _197;
	            vec4 _369 = _166;
	            _369.x = _367.x;
	            _369.y = _367.y;
	            _369.z = _367.z;
	            _166 = _369;
	            vec3 _375 = p.vFaceNormalWs * _197;
	            vec4 _377 = _165;
	            _377.x = _375.x;
	            _377.y = _375.y;
	            _377.z = _375.z;
	            _165 = _377;
	            uint _198;
	            if (p.nInstance >= 0)
	            {
	                uint _171 = g_instanceBuffer._member0[uint(p.nInstance)].nMaterialFlags_nInstanceFlags;
	                _198 = _171 & 65535u;
	            }
	            else
	            {
	                _198 = 0u;
	            }
	            _162 = int(_198);
	            _200 = _344;
	            f16vec4 _169 = p.material.vMaterialBits;
	            bool _195;
	            if ((p.material.nMaterialTypeAndFlags & 65535u) == 1u)
	            {
	                _195 = any(greaterThan(vec3(_169.xyz), vec3(0.0)));
	            }
	            else
	            {
	                _195 = false;
	            }
	            vec3 _199;
	            if (_195)
	            {
	                _199 = vec3(p.material.vMaterialBits.xyz) / max(vec3(p.material.vAlbedo), vec3(0.100000001490116119384765625));
	            }
	            else
	            {
	                _199 = vec3(0.0);
	            }
	            vec4 _419 = _167;
	            _419.w = _199.x;
	            _167 = _419;
	            vec4 _422 = _166;
	            _422.w = _199.y;
	            _166 = _422;
	            vec4 _425 = _165;
	            _425.w = _199.z;
	            _165 = _425;
	        }
	        break;
	    } while(false);
	    vec3 _427 = _152.xyz + _274;
	    vec3 _428 = -_149.xyz;
	    do
	    {
	        f16vec3 _432 = f16vec3(vec3(0.0));
	        vec3 _173;
	        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _173, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_432, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _432, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	        traceRayEXT(g_AccelStruct, 0u, 1u, 0u, 2u, 0u, _427, 0.0, _428, _200, 0);
	        if (!(p.nInstance != (-1)))
	        {
	            break;
	        }
	        vec3 _191;
	        if (p.bFlippedNormal)
	        {
	            _191 = -p.vFaceNormalWs;
	        }
	        else
	        {
	            _191 = p.vFaceNormalWs;
	        }
	        if (!(dot(_149.xyz, _191) > 0.0))
	        {
	            break;
	        }
	        float _192;
	        if (p.bFlippedNormal)
	        {
	            _192 = -1.0;
	        }
	        else
	        {
	            _192 = 1.0;
	        }
	        vec3 _493 = (_427 + (_428 * p.flHitT)) + (p.vFaceNormalWs * ((abs(_427) + vec3(abs(p.flHitT))) * 9.9999997473787516355514526367188e-05));
	        float _497 = length(_493 - _152.xyz);
	        if (_497 < _200)
	        {
	            vec4 _503 = _168;
	            _503.x = _493.x;
	            _503.y = _493.y;
	            _503.z = _493.z;
	            _168 = _503;
	            vec3 _511 = vec3(p.material.vNormalWs) * _192;
	            vec4 _513 = _167;
	            _513.x = _511.x;
	            _513.y = _511.y;
	            _513.z = _511.z;
	            _167 = _513;
	            vec3 _520 = p.vInterpolatedNormalWs.xyz * _192;
	            vec4 _522 = _166;
	            _522.x = _520.x;
	            _522.y = _520.y;
	            _522.z = _520.z;
	            _166 = _522;
	            vec3 _528 = p.vFaceNormalWs * _192;
	            vec4 _530 = _165;
	            _530.x = _528.x;
	            _530.y = _528.y;
	            _530.z = _528.z;
	            _165 = _530;
	            uint _193;
	            if (p.nInstance >= 0)
	            {
	                uint _174 = g_instanceBuffer._member0[uint(p.nInstance)].nMaterialFlags_nInstanceFlags;
	                _193 = _174 & 65535u;
	            }
	            else
	            {
	                _193 = 0u;
	            }
	            _162 = int(_193);
	            _200 = _497;
	            f16vec4 _172 = p.material.vMaterialBits;
	            bool _190;
	            if ((p.material.nMaterialTypeAndFlags & 65535u) == 1u)
	            {
	                _190 = any(greaterThan(vec3(_172.xyz), vec3(0.0)));
	            }
	            else
	            {
	                _190 = false;
	            }
	            vec3 _194;
	            if (_190)
	            {
	                _194 = vec3(p.material.vMaterialBits.xyz) / max(vec3(p.material.vAlbedo), vec3(0.100000001490116119384765625));
	            }
	            else
	            {
	                _194 = vec3(0.0);
	            }
	            vec4 _572 = _167;
	            _572.w = _194.x;
	            _167 = _572;
	            vec4 _575 = _166;
	            _575.w = _194.y;
	            _166 = _575;
	            vec4 _578 = _165;
	            _578.w = _194.z;
	            _165 = _578;
	        }
	        break;
	    } while(false);
	    _160 = _168;
	    _159 = _167;
	    _158 = _166;
	    _157 = _165;
	    _156 = _164;
	    _155 = _163;
	    _154 = _162;
	    _153 = _161;
	    do
	    {
	        vec3 _176 = _160.xyz;
	        vec3 _175 = _157.xyz;
	        f16vec3 _594 = f16vec3(vec3(0.0));
	        vec3 _177;
	        p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _177, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_594, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _594, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	        traceRayEXT(g_AccelStruct, 0u, 1u, 0u, 2u, 0u, _160.xyz, 0.0, _157.xyz, 1.0, 0);
	        if (!(p.nInstance != (-1)))
	        {
	            break;
	        }
	        vec3 _621 = (_176 + (_175 * p.flHitT)) + (_157.xyz * ((abs(_176) + vec3(abs(p.flHitT))) * 9.9999997473787516355514526367188e-05));
	        vec4 _623 = _160;
	        _623.x = _621.x;
	        _623.y = _621.y;
	        _623.z = _621.z;
	        _160 = _623;
	        break;
	    } while(false);
	    bool bValidSample = bValidSample_2;
	    int i = 0;
	    int nBackfacesSeen = 0;
	    bool bValidSample_1;
	    vec3 _178;
	    vec3 _186;
	    float _187;
	    bool _188;
	    bool _189;
	    for (;;)
	    {
	        bool _633_ladder_break = false;
	        do
	        {
	            if (!(i < 8))
	            {
	                _633_ladder_break = true;
	                break;
	            }
	            if (!bValidSample)
	            {
	                _633_ladder_break = true;
	                break;
	            }
	            if ((nBackfacesSeen + (8 - i)) <= 2)
	            {
	                _633_ladder_break = true;
	                break;
	            }
	            uint _650 = uint(i);
	            uint _655 = (_650 << 16u) | (_650 >> 16u);
	            uint _660 = ((_655 & 1431655765u) << 1u) | ((_655 & 2863311530u) >> 1u);
	            uint _665 = ((_660 & 858993459u) << 2u) | ((_660 & 3435973836u) >> 2u);
	            uint _670 = ((_665 & 252645135u) << 4u) | ((_665 & 4042322160u) >> 4u);
	            vec2 _678 = vec2(float(_650) * 0.125, float(((_670 & 16711935u) << 8u) | ((_670 & 4278255360u) >> 8u)) * 2.3283064365386962890625e-10);
	            float _679 = _678.y;
	            float _680 = sqrt(_679);
	            float _682 = 6.283185482025146484375 * _678.x;
	            vec3 _696 = mat3(vTangent1Ws, vTangent2Ws, _157.xyz) * vec3(cos(_682) * _680, sin(_682) * _680, sqrt(max(0.0, 1.0 - _679)));
	            vec3 _144 = _160.xyz;
	            vec3 _143 = _696;
	            f16vec3 _699 = f16vec3(vec3(0.0));
	            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _178, 3.4028234663852885981170418348452e+38, 0.0, -1, false, MaterialDataMinimal_t(_699, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _699, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	            traceRayEXT(g_AccelStruct, 0u, 16u, 0u, 2u, 0u, _160.xyz, 0.0, _696, 56755.83984375, 0);
	            float _724 = p.flHitT;
	            float flRng = p.flOpacityRng;
	            vec3 _142 = _160.xyz;
	            vec3 _141 = _696;
	            vec3 _140 = p.vSmoothPositionWs;
	            vec3 _139 = p.vFaceNormalWs;
	            float _138 = p.flHitT;
	            int _137 = p.nInstance;
	            f16vec3 _136 = p.material.vNormalWs;
	            do
	            {
	                if (!(_137 != (-1)))
	                {
	                    _189 = false;
	                    break;
	                }
	                vec3 _180 = (_142 + (_141 * _138)) + (_139 * ((abs(_142) + vec3(abs(_138))) * 9.9999997473787516355514526367188e-05));
	                vec3 _179 = _139;
	                if (bValidSample)
	                {
	                    _188 = any(notEqual(_140, vec3(3.4028234663852885981170418348452e+38)));
	                }
	                else
	                {
	                    _188 = false;
	                }
	                vec3 _761 = _140 - _180;
	                float _762 = length(_761);
	                vec3 _183 = _180;
	                float _182 = 0.0;
	                vec3 _181 = vec4(_761 / vec3(_762), _762).xyz;
	                if (_188)
	                {
	                    _187 = _762;
	                }
	                else
	                {
	                    _187 = 0.0;
	                }
	                p_1 = PayloadShadow_t(1.0);
	                traceRayEXT(g_AccelStruct, 0u, 255u, 1u, 2u, 1u, _183, _182, _181, _187, 1);
	                if (_188)
	                {
	                    _187 = p_1.m_flVisibility;
	                }
	                else
	                {
	                    _187 = 0.0;
	                }
	                if (_187 == 1.0)
	                {
	                    _180 = _140;
	                    _179 = vec3(_136);
	                }
	                uint _184 = g_instanceBuffer._member0[uint(_137)].nMaterialFlags_nInstanceFlags;
	                if ((int((_184 >> uint(16)) & 65535u) & 1) != 0)
	                {
	                    _189 = false;
	                    break;
	                }
	                if ((int(_184 & 65535u) & 2048) != 0)
	                {
	                    _189 = false;
	                    break;
	                }
	                _189 = dot(_696, _179) > 0.0;
	                break;
	            } while(false);
	            if (!_189)
	            {
	                break;
	            }
	            if (p.nInstance != (-1))
	            {
	                uint _185 = g_instanceBuffer._member0[uint(p.nInstance)].nMaterialFlags_nInstanceFlags;
	                if (!((int(_185 & 65535u) & 6) != 0))
	                {
	                    break;
	                }
	            }
	            f16vec3 _837 = f16vec3(vec3(0.0));
	            p = Payload_t(vec3(3.4028234663852885981170418348452e+38), vec3(0.0), _186, 3.4028234663852885981170418348452e+38, flRng, -1, false, MaterialDataMinimal_t(_837, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _837, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0))));
	            traceRayEXT(g_AccelStruct, 16u, 16u, 0u, 2u, 0u, _144, _724 * 0.99989998340606689453125, _143, _724 * 1.00010001659393310546875, 0);
	            flRng = p.flOpacityRng;
	            if (p.nInstance != (-1))
	            {
	                break;
	            }
	            int nBackfacesSeen_1 = nBackfacesSeen + 1;
	            if (nBackfacesSeen_1 > 2)
	            {
	                bValidSample_1 = false;
	            }
	            else
	            {
	                bValidSample_1 = bValidSample;
	            }
	            bValidSample = bValidSample_1;
	            nBackfacesSeen = nBackfacesSeen_1;
	            break;
	        } while(false);
	        if (_633_ladder_break)
	        {
	            break;
	        }
	        i++;
	        continue;
	    }
	    if (!bValidSample)
	    {
	        _160 = vec4(0.0);
	        _159 = vec4(0.0);
	        _158 = vec4(0.0);
	        _157 = vec4(0.0);
	        _156 = vec4(0.0);
	        _154 = 0;
	        _153 = 0u;
	    }
	    g_LightmapSamples._member0[nSample].m_vPositionWs = _160;
	    g_LightmapSamples._member0[nSample].m_vShadingNormalWs_vTransmissiveR = _159;
	    g_LightmapSamples._member0[nSample].m_vInterpolatedNormalWs_vTransmissiveG = _158;
	    g_LightmapSamples._member0[nSample].m_vFaceNormalWs_vTransmissiveB = _157;
	    g_LightmapSamples._member0[nSample].m_vTangentWs = _156;
	    g_LightmapSamples._member0[nSample].m_vLightmapUv = _155;
	    g_LightmapSamples._member0[nSample].m_nInstanceFlags = _154;
	    g_LightmapSamples._member0[nSample].m_nSampleFlags = _153;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	
}
