// MGetKV3ClassDefaults = {
//	"m_ID": "",
//	"m_nBoneIdx": -1,
//	"m_vBoneLocalProbeDir":
//	[
//		1.000000,
//		0.000000,
//		0.000000
//	],
//	"m_flProbeMaxDist": 5.000000,
//	"m_audioInfo":
//	{
//		"m_audioActionID": "",
//		"m_audioTypeID": "",
//		"m_soundeventOverrideID": ""
//	}
//}
class CNmSkeleton::ContactConfig_t
{
	CGlobalSymbol m_ID;
	int32 m_nBoneIdx;
	Vector m_vBoneLocalProbeDir;
	float32 m_flProbeMaxDist;
	NmContactAudioInfo_t m_audioInfo;
};
