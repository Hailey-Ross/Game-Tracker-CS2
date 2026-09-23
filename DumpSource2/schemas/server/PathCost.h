// MGetKV3ClassDefaults = {
//	"_class": "PathCost",
//	"m_navHull":
//	{
//		"m_nHullIdx": 0
//	},
//	"m_bAllowLadders": true,
//	"m_bCanFly": false,
//	"m_bCanSwim": false,
//	"m_flWaterToGroundMaxHeight": 100.000000,
//	"m_flGroundToWaterMaxHeight": 100.000000,
//	"m_flGroundToWaterTransitionDistance": -1.000000,
//	"m_flWaterToGroundTransitionDistance": -1.000000,
//	"m_flFlyingTransitionTolerance": 140.000000,
//	"m_bOptimizeFlySpacePathfinds": true,
//	"m_bStringPullFlySpacePathfinds": false,
//	"m_bSupportsTransitions": false,
//	"m_flTransitionPenalty": 200.000000,
//	"m_dangerFactor": 0.000000,
//	"m_damagingAreasPenaltyCost": 0.000000,
//	"m_flAgentMaxClimb": 0.000000
//}
class PathCost : public CNavPathCost
{
	float32 m_dangerFactor;
	float32 m_damagingAreasPenaltyCost;
	float32 m_flAgentMaxClimb;
};
