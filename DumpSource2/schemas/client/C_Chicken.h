class C_Chicken : public C_DynamicProp, public IHasAttributes
{
	CHandle< C_CSPlayerPawn > m_leader;
	CHandle< CCSPlayerController > m_owner;
	C_AttributeContainer m_AttributeManager;
	bool m_bAttributesInitialized;
	ParticleIndex_t m_hWaterWakeParticles;
	bool m_bIsPreviewModel;
	bool m_bSpawnDyingParticles;
};
