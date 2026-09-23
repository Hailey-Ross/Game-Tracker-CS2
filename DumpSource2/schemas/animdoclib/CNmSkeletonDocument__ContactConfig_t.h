// MGetKV3ClassDefaults = {
//	"m_ID": <HIDDEN FOR DIFF>,
//	"m_boneID": "",
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
// MPropertyAutoExpandSelf
class CNmSkeletonDocument::ContactConfig_t
{
	CGlobalSymbol m_ID;
	CGlobalSymbol m_boneID;
	Vector m_vBoneLocalProbeDir;
	float32 m_flProbeMaxDist;
	// MPropertyFriendlyName = "Audio"
	NmContactAudioInfo_t m_audioInfo;
};
