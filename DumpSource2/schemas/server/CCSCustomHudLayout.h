// MNetworkNoBase
class CCSCustomHudLayout : public CBaseEntity
{
	CUtlSymbolLarge m_strLayout;
	bool m_bObservable;
	CUtlVectorEmbeddedNetworkVar< CCSCustomHudLayoutState > m_vecPlayerLayoutStates;
	CCSCustomHudLayoutState m_globalLayoutState;
	CNetworkUtlVectorBase< CUtlString > m_vecPanelIds;
	CNetworkUtlVectorBase< CUtlString > m_vecClassNames;
	CNetworkUtlVectorBase< CUtlString > m_vecDialogVariableNames;
};
