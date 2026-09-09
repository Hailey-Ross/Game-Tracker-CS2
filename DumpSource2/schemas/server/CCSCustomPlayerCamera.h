class CCSCustomPlayerCamera : public CBaseEntity
{
	CHandle< CCSPlayerPawnBase > m_hPawn;
	CustomCameraMode_t m_nCameraMode;
	CHandle< CBaseEntity > m_hFollowEntity;
	bool m_bFollowEyes;
	Vector m_vecFollowOffset;
	Vector m_vecCameraOffset;
	bool m_bClipCameraOffset;
	float32 m_flCameraOffsetReturnStrength;
};
