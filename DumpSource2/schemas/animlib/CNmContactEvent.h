// MGetKV3ClassDefaults = {
//	"_class": "CNmContactEvent",
//	"m_flStartTime":
//	{
//		"m_flValue": 0.000000
//	},
//	"m_flDuration":
//	{
//		"m_flValue": 0.000000
//	},
//	"m_syncID": "",
//	"m_configID": "",
//	"m_probeBoneID": "",
//	"m_vBoneLocalProbeDir":
//	[
//		1.000000,
//		0.000000,
//		0.000000
//	],
//	"m_flProbeMaxDist": 3.000000,
//	"m_audioInfo":
//	{
//		"m_audioActionID": "",
//		"m_audioTypeID": "",
//		"m_soundeventOverrideID": ""
//	}
//}
// MHasKV3TransferPolymorphicClassname
class CNmContactEvent : public CNmEvent
{
	CGlobalSymbol m_configID;
	CGlobalSymbol m_probeBoneID;
	Vector m_vBoneLocalProbeDir;
	float32 m_flProbeMaxDist;
	NmContactAudioInfo_t m_audioInfo;
};
