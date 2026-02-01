#Version 8
#BeginDescription
This tool creates a free profile tool.  The tool can be placed anywhere on a Beam/Sheet/Panel/Sip/Clt.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
//region
/// <History>
/// <version value="1.2" date="11March2021" initial </version>
/// </History>

/// <summary Lang=en>
/// This tool creates a free profile tool. 
/// The tool can be placed anywhere on a Beam/Sheet/Panel/Sip/Clt.
/// </summary>
//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	
	int bInDebug = FALSE;
//end Constants//endregion

//region Properties
	
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
	// This tsl gets inserted automatically through the console tools actions. Keep the default behaviour!
	
	PropDouble pDepth(0, 0, T("|Depth|"));
	pDepth.setDescription(T("|Depth of the free profile. 0 means all the way through|"));
	pDepth.setCategory(category);

	PropDouble pDiam(1, 0, T("|Diameter|"));
	pDiam.setDescription(T("|Diameter of the free profile. This is used whenever an offsetted tool path is needed. 0 means value is retrieved from Hsb_Settings depending on tool index.|"));
	pDiam.setCategory(category);
	
	PropInt pToolIndex(0, 0, T("|Tool index|"));
	pToolIndex.setDescription(T("|Tool index aka cncMode. A number of predefined cnc modes exist, but it is actually a value which can be set arbitrarily, and mapped during export to the tool on the machine.|"));
	pToolIndex.setCategory(category);
	
	PropString pSolidPathOnly(0, sNoYes, T("|Solid path only|"), 0);
	pSolidPathOnly.setDescription(T("|As solid operation, process the pline path only, as opposed to the complete enclosed area.|"));
	pSolidPathOnly.setCategory(category);
	
	PropString pMachinePathOnly(1, sNoYes, T("|Machine path only|"), 1);
	pMachinePathOnly.setDescription(T("|As machining operation, process the pline path only, as opposed to the complete enclosed area.|"));
	pMachinePathOnly.setCategory(category);
	
	String arSMillSide[] = {T("|auto side|"), T("|left|"), T("|center|"), T("|right|")};
	int arNMillSide[] = {-2, -1, 0, 1};
	PropString pMillSide(2,arSMillSide, T("|Mill side|", 0));
	pMillSide.setDescription(T("|Walking the defining pline, looking up along the pline normal, this property decides what side will be cut away.|"));
	pMillSide.setCategory(category);
	
	PropString pCutDefAsOne(3, sNoYes, T("|Cut defining as one|"), 0);
	pCutDefAsOne.setDescription(T("|When this value is NO, then the defining pline is reduced and possibly split up to relevant parts where it intersects with the bounding box of GenBeam, for cnc export.|"));
	pCutDefAsOne.setCategory(category);
	
//End Properties//endregion 
	
//region OnInsert
if (_bOnInsert)
{
	if (insertCycleCount() > 1) { eraseInstance(); return; }
	
	// silent/dialog
	if (_kExecuteKey.length() > 0)
	{
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		if (sEntries.findNoCase(_kExecuteKey ,- 1) >- 1)
			setPropValuesFromCatalog(_kExecuteKey);
		else
			setPropValuesFromCatalog(sLastInserted);
	}
	// standard dialog
	else
		showDialog();
	
	_GenBeam.append(getGenBeam());
	
	EntPLine ent = getEntPLine(T("|Select polyline|"));
	_Entity.append(ent);
	
	PLine plineEnt = ent.getPLine();
	
	if (pMillSide == arSMillSide[0]) // auto
		_PtG.append(getPoint(T("|Select point to close free profile or to define part to cut|")));
	
	return;
}
// OnInsert//endregion 


if (_GenBeam.length() == 0 || !_GenBeam[0].bIsValid())
{ 
	if (bInDebug) reportMessage("\nstate invalid: missing genbeam");
	eraseInstance();
	return;
}
GenBeam bm0 = _GenBeam[0];

//InitializeFrom happens from Console->tools->(of type hex) convert to double cut entity.
if (_Map.hasMap("InitializeFrom"))
{ 
	Map mp = _Map.getMap("InitializeFrom");
	_Map.removeAt("InitializeFrom", FALSE);
	
	PLine plDefiningTop = mp.getPLine("plDefiningTop");
	Point3d arPntToClosePoly[] = mp.getPoint3dArray("arPntToClosePoly");
	int cncMode = mp.getInt("cncMode");
	double depth = mp.getDouble("depth");
	double diam = mp.getDouble("diam");
	int sidePolyNormal = mp.getInt("sidePolyNormal");
	int solidPathOnly = mp.getInt("solidPathOnly");
	int machinePathOnly = mp.getInt("machinePathOnly");
	int cutDefAsOne = mp.getInt("cutDefAsOne");
	
	// create pline
	EntPLine entPl; entPl.dbCreate(plDefiningTop);
	_Entity.append(entPl);
	
	// set grip points
	_PtG = arPntToClosePoly;
	
	pToolIndex.set(cncMode);
	pDepth.set(depth);
	pDiam.set(diam);
	
	pMillSide.set(arSMillSide[arNMillSide.find(sidePolyNormal, 0)]);
	pSolidPathOnly.set((solidPathOnly) ? sNoYes[1] : sNoYes[0]);
	pMachinePathOnly.set((machinePathOnly) ? sNoYes[1] : sNoYes[0]);
	pCutDefAsOne.set((cutDefAsOne) ? sNoYes[1] : sNoYes[0]);
	
	if (bInDebug) reportMessage("\nInitializeFrom: set");
}

//region Set general behaviour and get references
	_ThisInst.setAllowGripAtPt0(false);
	setEraseAndCopyWithBeams(_kBeam0);
	setKeepReferenceToGenBeamDuringCopy(_kBeam0);
	assignToGroups(bm0, 'T');
	
	EntPLine epl;
	PLine plDefine;
	Entity ents[0]; ents=_Entity;

	EcsMarker ecs;
	for (int i=0;i<ents.length();i++) 
	{ 
		EntPLine _epl = (EntPLine)ents[i];
		if (_epl.bIsValid() && !epl.bIsValid())
		{
			epl = _epl;
			setDependencyOnEntity(epl);
			plDefine = epl.getPLine();
			//_Pt0 = plDefine.closestPointTo(_Pt0);
		}
		else if (ents[i].bIsKindOf(EcsMarker()))
		{ 
			ecs = (EcsMarker)ents[i];
			setDependencyOnEntity(ecs);
		}
	}//next i			
//End set general behaviour and get references//endregion 



//region Trigger AddEcs
	String sTriggerAddEcs = T("../|Add Ecs|");
	if (!ecs.bIsValid())addRecalcTrigger(_kContext, sTriggerAddEcs );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddEcs)
	{
		Vector3d vecNormal = plDefine.coordSys().vecZ();
		Vector3d vecXE = plDefine.getTangentAtPoint(plDefine.getPointAtDist(dEps));
		Vector3d vecYE = vecXE.crossProduct(-vecNormal);
		CoordSys cs(plDefine.ptStart(), vecXE, vecYE, vecNormal);
		EcsMarker ecs;
		ecs.dbCreate(cs);
		if (ecs.bIsValid())
		{
			_Map.setVector3d("vecX", vecXE);
			_Map.setVector3d("vecY", vecYE);
			_Map.setVector3d("vecZ", vecNormal);
			
			_Entity.append(ecs);
		}
		setExecutionLoops(2);
		return;
	}//endregion	

//region EcsAlignment
	if (ecs.bIsValid() && _Map.hasVector3d("vecX"))
	{ 
		Vector3d vecXE = _Map.getVector3d("vecX");
		Vector3d vecYE = _Map.getVector3d("vecY");
		Vector3d vecZE = _Map.getVector3d("vecZ");
		
		vecXE.vis(_Pt0, 1);
		vecYE.vis(_Pt0, 3);
				
	// transform if anything has chasnged
		CoordSys csE = ecs.coordSys();
		csE.vecX().vis(csE.ptOrg(), 1);
		csE.vecY().vis(csE.ptOrg(), 3);
		
		
		if (!(csE.vecX().isCodirectionalTo(vecXE) && 
			csE.vecY().isCodirectionalTo(vecYE) && 
			csE.vecZ().isCodirectionalTo(vecZE)))
		{ 
			CoordSys cs;
			cs.setToAlignCoordSys(csE.ptOrg(), vecXE, vecYE, vecZE, csE.ptOrg(),csE.vecX(), csE.vecY(), csE.vecZ());
			epl.transformBy(cs);
			_Map.setVector3d("vecX", csE.vecX());
			_Map.setVector3d("vecY", csE.vecY());
			_Map.setVector3d("vecZ", csE.vecZ());		
			setExecutionLoops(2);
			return;
		}
		
		else
			vecZE.vis(_Pt0, 150);
	}
//End EcsAlignment//endregion 

int bSolidPathOnly= sNoYes.find(pSolidPathOnly);
int bMachinePathOnly= sNoYes.find(pMachinePathOnly);
int sidePolyNormal = arNMillSide[arSMillSide.find(pMillSide,0)];
int cutAsOne = sNoYes.find(pCutDefAsOne);

FreeProfile fp(plDefine, _PtG);
fp.setSolidPathOnly(bSolidPathOnly);
fp.setMachinePathOnly(bMachinePathOnly);
fp.setDepth(pDepth);
fp.setSolidMillDiameter(pDiam);
fp.setCncMode(pToolIndex);
fp.setCutDefiningAsOne(cutAsOne);
if (sidePolyNormal != -2)
	fp.setMillSidePolyNormal(sidePolyNormal);
bm0.addTool(fp);

Display dp(-1);
PLine plD = fp.plDefining(bm0);
dp.draw(plD);


	
	
#End
#BeginThumbnail




#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]" />
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End