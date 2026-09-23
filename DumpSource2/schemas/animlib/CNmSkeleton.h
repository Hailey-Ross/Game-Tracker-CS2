// MGetKV3ClassDefaults = {
//	"m_ID": <HIDDEN FOR DIFF>,
//	"m_boneIDs":
//	[
//	],
//	"m_parentIndices":
//	[
//	],
//	"m_parentSpaceReferencePose":
//	[
//	],
//	"m_modelSpaceReferencePose":
//	[
//	],
//	"m_numBonesToSampleAtLowLOD": 0,
//	"m_bIsPropSkeleton": false,
//	"m_maskDefinitions":
//	[
//	],
//	"m_secondarySkeletons":
//	[
//	],
//	"m_floatChannelSets":
//	[
//	],
//	"m_contactConfigs":
//	[
//	],
//	"m_gameplayRelevantBoneIndices":
//	[
//	],
//	"m_nSpecialDependencyHash": 0
//}
class CNmSkeleton
{
	CGlobalSymbol m_ID;
	CUtlLeanVector< CGlobalSymbol > m_boneIDs;
	CUtlVector< int32 > m_parentIndices;
	CUtlVector< CTransform > m_parentSpaceReferencePose;
	CUtlVector< CTransform > m_modelSpaceReferencePose;
	int32 m_numBonesToSampleAtLowLOD;
	bool m_bIsPropSkeleton;
	CUtlLeanVector< NmBoneMaskSetDefinition_t > m_maskDefinitions;
	CUtlLeanVector< CNmSkeleton::SecondarySkeleton_t > m_secondarySkeletons;
	CUtlLeanVector< CNmFloatChannelSet_t > m_floatChannelSets;
	CUtlVector< CNmSkeleton::ContactConfig_t > m_contactConfigs;
	CUtlVector< int32 > m_gameplayRelevantBoneIndices;
	int64 m_nSpecialDependencyHash;
};
