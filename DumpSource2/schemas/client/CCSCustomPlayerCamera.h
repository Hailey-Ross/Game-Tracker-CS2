class CCSCustomPlayerCamera : public C_BaseEntity
{
	CHandle< C_CSPlayerPawnBase > m_hPawn;
	CustomCameraMode_t m_nCameraMode;
	CHandle< C_BaseEntity > m_hFollowEntity;
	bool m_bFollowEyes;
	Vector m_vecFollowOffset;
	Vector m_vecCameraOffset;
	bool m_bClipCameraOffset;
	float32 m_flCameraOffsetReturnStrength;
};
