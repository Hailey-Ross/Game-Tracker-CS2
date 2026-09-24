// MGetKV3ClassDefaults = {
//	"m_bEnabled": true,
//	"m_nMutatorCommandType": "COMP_MAT_PROPERTY_MUTATOR_SET_VALUE",
//	"m_strInitWith_Container": "",
//	"m_strCopyProperty_InputContainerSrc": "",
//	"m_strCopyProperty_InputContainerProperty": "",
//	"m_strCopyProperty_TargetProperty": "",
//	"m_strRandomRollInputVars_SeedInputVar": "",
//	"m_vecRandomRollInputVars_InputVarsToRoll":
//	[
//	],
//	"m_strCopyMatchingKeys_InputContainerSrc": "",
//	"m_strCopyKeysWithSuffix_InputContainerSrc": "",
//	"m_strCopyKeysWithSuffix_FindSuffix": "",
//	"m_strCopyKeysWithSuffix_ReplaceSuffix": "",
//	"m_nSetValue_Value":
//	{
//		"m_strName": "",
//		"m_bExposeExternally": false,
//		"m_strExposedFriendlyName": "",
//		"m_strExposedFriendlyGroupName": "",
//		"m_bExposedVariableIsFixedRange": false,
//		"m_strExposedVisibleWhenTrue": "",
//		"m_strExposedHiddenWhenTrue": "",
//		"m_strExposedValueList": "",
//		"m_nVariableType": "LOOSE_VARIABLE_TYPE_FLOAT1",
//		"m_bValueBoolean": false,
//		"m_nValueIntX": 0,
//		"m_nValueIntY": 0,
//		"m_nValueIntZ": 0,
//		"m_nValueIntW": 0,
//		"m_bHasFloatBounds": false,
//		"m_flValueFloatX": 0.000000,
//		"m_flValueFloatX_Min": 0.000000,
//		"m_flValueFloatX_Max": 1.000000,
//		"m_flValueFloatY": 0.000000,
//		"m_flValueFloatY_Min": 0.000000,
//		"m_flValueFloatY_Max": 1.000000,
//		"m_flValueFloatZ": 0.000000,
//		"m_flValueFloatZ_Min": 0.000000,
//		"m_flValueFloatZ_Max": 1.000000,
//		"m_flValueFloatW": 0.000000,
//		"m_flValueFloatW_Min": 0.000000,
//		"m_flValueFloatW_Max": 1.000000,
//		"m_cValueColor4":
//		[
//			0,
//			0,
//			0,
//			0
//		],
//		"m_nValueSystemVar": "COMPMATSYSVAR_COMPOSITETIME",
//		"m_strResourceMaterial": "",
//		"m_strTextureContentAssetPath": "",
//		"m_strTextureRuntimeResourcePath": "",
//		"m_strTextureCompilationVtexTemplate": "",
//		"m_nTextureType": "INPUT_TEXTURE_TYPE_DEFAULT",
//		"m_strString": "",
//		"m_strPanoramaPanelPath": "",
//		"m_nPanoramaRenderRes": 512
//	},
//	"m_strGenerateTexture_TargetParam": "",
//	"m_strGenerateTexture_InitialContainer": "",
//	"m_nResolution": 256,
//	"m_bIsScratchTarget": false,
//	"m_strCompressionFormat": "",
//	"m_bSplatDebugInfo": false,
//	"m_bCaptureInRenderDoc": false,
//	"m_vecTexGenInstructions":
//	[
//	],
//	"m_vecConditionalMutators":
//	[
//	],
//	"m_strPopInputQueue_Container": "",
//	"m_strDrawText_InputContainerSrc": "",
//	"m_strDrawText_InputContainerProperty": "",
//	"m_vecDrawText_Position":
//	[
//		0.000000,
//		0.000000
//	],
//	"m_colDrawText_Color":
//	[
//		255,
//		255,
//		255
//	],
//	"m_strDrawText_Font": "Times New Roman",
//	"m_vecConditions":
//	[
//	]
//}
// MPropertyElementNameFn
class CompMatPropertyMutator_t
{
	// MPropertyAutoRebuildOnChange
	// MPropertyFriendlyName = "Enabled"
	bool m_bEnabled;
	// MPropertyAutoRebuildOnChange
	// MPropertyFriendlyName = "Mutator Command"
	// MPropertyAttrStateCallback
	CompMatPropertyMutatorType_t m_nMutatorCommandType;
	// MPropertyFriendlyName = "Container to Init With"
	// MPropertyAttrStateCallback
	CUtlString m_strInitWith_Container;
	// MPropertyFriendlyName = "Input Container"
	// MPropertyAttrStateCallback
	CUtlString m_strCopyProperty_InputContainerSrc;
	// MPropertyFriendlyName = "Input Container Property"
	// MPropertyAttrStateCallback
	CUtlString m_strCopyProperty_InputContainerProperty;
	// MPropertyFriendlyName = "Target Property"
	// MPropertyAttrStateCallback
	CUtlString m_strCopyProperty_TargetProperty;
	// MPropertyFriendlyName = "Seed Input Var"
	// MPropertyAttrStateCallback
	CUtlString m_strRandomRollInputVars_SeedInputVar;
	// MPropertyFriendlyName = "Input Vars"
	// MPropertyAttrStateCallback
	CUtlVector< CUtlString > m_vecRandomRollInputVars_InputVarsToRoll;
	// MPropertyFriendlyName = "Input Container"
	// MPropertyAttrStateCallback
	CUtlString m_strCopyMatchingKeys_InputContainerSrc;
	// MPropertyFriendlyName = "Input Container"
	// MPropertyAttrStateCallback
	CUtlString m_strCopyKeysWithSuffix_InputContainerSrc;
	// MPropertyFriendlyName = "Find Suffix"
	// MPropertyAttrStateCallback
	CUtlString m_strCopyKeysWithSuffix_FindSuffix;
	// MPropertyFriendlyName = "Replace Suffix"
	// MPropertyAttrStateCallback
	CUtlString m_strCopyKeysWithSuffix_ReplaceSuffix;
	// MPropertyFriendlyName = "Value"
	// MPropertyAttrStateCallback
	CompositeMaterialInputLooseVariable_t m_nSetValue_Value;
	// MPropertyFriendlyName = "Target Texture Param"
	// MPropertyAttrStateCallback
	CUtlString m_strGenerateTexture_TargetParam;
	// MPropertyFriendlyName = "Initial Container"
	// MPropertyAttrStateCallback
	CUtlString m_strGenerateTexture_InitialContainer;
	// MPropertyFriendlyName = "Resolution"
	// MPropertyAttrStateCallback
	int32 m_nResolution;
	// MPropertyAutoRebuildOnChange
	// MPropertyFriendlyName = "Scratch Target"
	// MPropertyAttrStateCallback
	bool m_bIsScratchTarget;
	// MPropertyFriendlyName = "Compression Format"
	// MPropertyAttrStateCallback
	CUtlString m_strCompressionFormat;
	// MPropertyAutoRebuildOnChange
	// MPropertyFriendlyName = "Splat Debug info on Texture"
	// MPropertyAttrStateCallback
	bool m_bSplatDebugInfo;
	// MPropertyAutoRebuildOnChange
	// MPropertyFriendlyName = "Capture in RenderDoc"
	// MPropertyAttrStateCallback
	bool m_bCaptureInRenderDoc;
	// MPropertyFriendlyName = "Texture Generation Instructions"
	// MPropertyAttrStateCallback
	CUtlVector< CompMatPropertyMutator_t > m_vecTexGenInstructions;
	// MPropertyFriendlyName = "Mutators"
	// MPropertyAttrStateCallback
	CUtlVector< CompMatPropertyMutator_t > m_vecConditionalMutators;
	// MPropertyFriendlyName = "Container to Pop"
	// MPropertyAttrStateCallback
	CUtlString m_strPopInputQueue_Container;
	// MPropertyFriendlyName = "Input Container"
	// MPropertyAttrStateCallback
	CUtlString m_strDrawText_InputContainerSrc;
	// MPropertyFriendlyName = "Input Container Property"
	// MPropertyAttrStateCallback
	CUtlString m_strDrawText_InputContainerProperty;
	// MPropertyFriendlyName = "Text Position"
	// MPropertyAttrStateCallback
	Vector2D m_vecDrawText_Position;
	// MPropertyFriendlyName = "Text Color"
	// MPropertyAttrStateCallback
	Color m_colDrawText_Color;
	// MPropertyFriendlyName = "Font"
	// MPropertyAttrStateCallback
	CUtlString m_strDrawText_Font;
	// MPropertyFriendlyName = "Conditions"
	// MPropertyAttrStateCallback
	CUtlVector< CompMatMutatorCondition_t > m_vecConditions;
};
