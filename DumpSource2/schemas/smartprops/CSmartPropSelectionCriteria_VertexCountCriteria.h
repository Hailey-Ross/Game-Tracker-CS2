// MGetKV3ClassDefaults = {
//	"_class": "CSmartPropSelectionCriteria_VertexCountCriteria",
//	"m_bEnabled": true,
//	"m_nTargetVertexCount": 0
//}
// MVDataComponentValidGrandParents = "CSmartPropElement_PlaceOnMesh"
// MPropertyFriendlyName = "Filter Faces By Vertex Count"
// MPropertyDescription = ""
class CSmartPropSelectionCriteria_VertexCountCriteria : public CSmartPropSelectionCriteria
{
	// MPropertyFriendlyName = "Target Vertex Count"
	// MPropertyDescription = "Iterate through faces with target vertex count."
	CSmartPropAttributeInt m_nTargetVertexCount;
};
