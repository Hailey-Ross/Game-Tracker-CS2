// MGetKV3ClassDefaults = {
//	"_class": "CNmClipDocEvent_Contact",
//	"m_flStartTime": 0.000000,
//	"m_flDuration": 0.000000,
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
class CNmClipDocEvent_Contact : public CNmClipDocEvent
{
	// MPropertyAutoRebuildOnChange
	CGlobalSymbol m_configID;
	// MPropertyAttrStateCallback (UNKNOWN FOR PARSER)
	CGlobalSymbol m_probeBoneID;
	// MPropertyAttrStateCallback (UNKNOWN FOR PARSER)
	Vector m_vBoneLocalProbeDir;
	// MPropertyAttrStateCallback (UNKNOWN FOR PARSER)
	float32 m_flProbeMaxDist;
	// MPropertyFriendlyName = "Audio"
	// MPropertyAttrStateCallback (UNKNOWN FOR PARSER)
	NmContactAudioInfo_t m_audioInfo;
};
