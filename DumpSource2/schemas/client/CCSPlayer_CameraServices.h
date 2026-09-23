class CCSPlayer_CameraServices : public CCSPlayerBase_CameraServices
{
	float32 m_flDeathCamTilt;
	CHandle< C_PointDeathcamBounds > m_hDeathCamBounds;
	bool m_bDeathCamBoundsSearched;
	Vector m_vClientScopeInaccuracy;
};
