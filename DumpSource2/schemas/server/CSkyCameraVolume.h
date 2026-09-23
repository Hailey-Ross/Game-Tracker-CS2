class CSkyCameraVolume : public CBaseEntity
{
	Vector m_vBoxMins;
	Vector m_vBoxMaxs;
	CHandle< CSkyCameraVolumeTarget > m_hTarget;
	int32 m_nPriority;
	bool m_bIsEnabled;
	bool m_bSkyboxBlurEffect;
	Vector m_vBlurOrigin;
	bool m_bSkyboxReceivesWorldCsm;
	bool m_bWorldReceivesSkyboxCsm;
	bool m_bStartDisabled;
	CUtlSymbolLarge m_iszTargetName;
};
