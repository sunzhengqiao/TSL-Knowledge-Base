#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
21.04.2015  -  version 1.03




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary>
/// This TSL shows the type of surfaces which are used for the selected panel
/// </summary>

/// <insert>
/// Select a set of panels. A tsl will be auto-inserted per panel.
/// </insert>

/// <remark>
/// 
/// </remark>

/// <history>
/// AS - 1.00 - 26.02.2015	- Pilot version (FogBugzId 852).
/// AS - 1.02 - 26.03.2015	- Report when surface infromation is not set. (FogBugzId 1045).
/// AS - 1.03 - 21.04.2015	- Swap opposite and reference side. (FogBugzId 1045)
/// </history>


// basics and props
double dEps = Unit(0.01,"mm");

PropString sDimStyle(0, _DimStyles, T("|Dimension style|"));

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_P-Surface");
if (arSCatalogNames.find(_kExecuteKey) != -1) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	if (_kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1)
		showDialog();
	
	PrEntity ssE(T("|Select panels|"), Sip());
	if (ssE.go()) {
		Entity arEntSelected[] = ssE.set();
		
				//insertion point
		String strScriptName = "HSB_P-Surface"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Sip lstPanels[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", true);
		setCatalogFromPropValues("MasterToSatellite");
		mapTsl.setInt("ManualInsert", true);
		
		for( int i=0;i<arEntSelected.length();i++ ){
			Sip sip = (Sip)arEntSelected[i];
			if( !sip.bIsValid() ){
				continue;
			}
			lstPanels[0] = sip;
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstPanels, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}
	}
	
	eraseInstance();
	return;
}

// set properties from master
if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", TRUE);
	}
}
int bManualInsert = false;
if( _Map.hasInt("ManualInsert") ){
	bManualInsert = _Map.getInt("ManualInsert");
	_Map.removeAt("ManualInsert", true);
}


// Is there an panel selected?
if (_Entity.length() == 0) {
	reportWarning(T("|No panel selected.|"));
	eraseInstance();
	return;
}

// Cast it to a panel
Sip sip = (Sip)_Entity[0];
if (!sip.bIsValid()) {
	reportWarning(T("|Selected entity is not a panel.|"));
	eraseInstance();
	return;
}

// Set dependency on the panel.
_Sip.setLength(0);
_Sip.append(sip);
setDependencyOnEntity(sip);

Point3d ptSip = sip.ptCen();
_Pt0 = ptSip;

sip.coordSys().vis();

// See if there is a submap "SipProperties" is attached.
String arSAttachedSubMaps[] = sip.subMapKeys();
if (arSAttachedSubMaps.find("SipProperties") == -1)
	return;

// Get the sip properties
Map mapSipProperties = sip.subMap("SipProperties");
// Get the surface settings.
String sSurfaceReference = mapSipProperties.getString("SurfaceReference");
String sSurfaceOpposite = mapSipProperties.getString("SurfaceOpposite");

// Get the element vectors
Element el = sip.element();
if (!el.bIsValid()) {
	reportWarning(T("|Selected panel is not part of an element.|"));
	eraseInstance();
	return;
}

_ThisInst.assignToElementGroup(el, true, 0, 'E');

double dHPanel = sip.solidHeight();

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Display dpPlan(-1);
dpPlan.addViewDirection(_ZW);
dpPlan.dimStyle(sDimStyle);
dpPlan.elemZone(el, 0, 'I');

Point3d ptReference = ptSip + vyEl * vyEl.dotProduct(ptEl - ptSip);
Point3d ptOpposite = ptReference;
ptReference -= vzEl * dHPanel;
ptOpposite += vzEl * dHPanel;

ptReference.vis(3);
ptOpposite.vis(1);

String arSSurfaceCode[] = {"NVI", "IVI", "VI"};
int arNColorIndex[] = {7, 4, 1};

String arSSurface[] = {
	sSurfaceReference,
	sSurfaceOpposite
};
Point3d arPtSurface[] = {
	ptReference,
	ptOpposite
};
int arNSide[] = {
	-1,
	1
};

for (int i=0;i<arSSurface.length();i++) {
	String sSurface = arSSurface[i];
	Point3d ptSurface = arPtSurface[i];
	int nSide = arNSide[i];
	int nSurfaceCodeIndex = arSSurfaceCode.find(sSurface);
	if (nSurfaceCodeIndex < 0) {
		String sError = TN("|The surface information is not set on the reference side|");
		if (i==1)
			sError = TN("|The surface information is not set on the opposite side|");
		reportNotice("\n"+el.number() + sError);
		
		continue;
	}
	
	int nColorIndex = arNColorIndex[nSurfaceCodeIndex];
	
	dpPlan.color(nColorIndex);
	
	dpPlan.draw(sSurface, ptSurface, vxEl, -vzEl, 0, -nSide);
}


#End
#BeginThumbnail
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
"_]E,
`


#End