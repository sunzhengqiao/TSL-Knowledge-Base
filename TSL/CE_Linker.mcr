#Version 8
#BeginDescription
Used to insert and link a CollectionEntity to one or more beams

#Versions
1.40 5/5/2025 Revised calculations for drill points cc
1.36 11/12/2024 Writing CE block name to Hardware list. Exposing a Manufacturer string property, also present in Hardware. cc
V1.35 4/6/2023 re-Bugfix to 1.32 bugfix cc
V1.34 4/5/2023 Updated drill logic to catch completely through case cc
V1.33 4/3/2023 Enabled gathering of HardWrComp from Collection entities cc
V1.32 3/26/2023 More robust checking for drill intersection cc
V1.31 2/23/2023 Bugfix on applying drills, may or may not intersect cc
V1.3 4/22/2022 Bugfix on BeamCut dimensions cc
V1.0 4/20/2022 Public Release cc








#End
#Type O
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 40
#KeyWords 
#BeginContents
Unit(1, "mm" ) ;
String stDoNotShowInstallations[] = { "NONE", "SITE"};


//__Collect data
String stCollectionEntityNames[] = CollectionDefinition().getAllEntryNames();

//__Density will also be required
double dSteelDensity;

// get densitites
MapObject moDensities("Material", "Density");
String sPath = _kPathHsbCompany + "\\Abbund\\Materials.xml";
double dDensity;
Map mpDensities;
if(moDensities.bIsValid())
{ 
	mpDensities = moDensities.map();
}

if(mpDensities.length() == 0)
{ 
	String sFind = findFile(sPath);
	if (sFind == sPath)
	{
		Map mpMaterials;
		mpMaterials.readFromXmlFile(sPath);
		Map mpMats = mpMaterials.getMap("MATERIAL[]");
	
		for (int i = 0; i < mpMats.length(); i++)
		{
			Map mpMaterial = mpMats.getMap(i);
			mpDensities.setDouble(mpMaterial.getString("MATERIAL").makeUpper(),
				mpMaterial.getDouble("DENSITY"), _kNoUnit);
		}
		moDensities.dbCreate(mpDensities);
	}
	else
	{
		//reportWarning("\nDensity file missing in '" + sPath + "'");
	}
}
dSteelDensity = mpDensities.getDouble("STEEL");

int bInDebug = projectSpecial() == "db";
if(_bOnDebug) bInDebug = true;

//__Properties

Display dp(-1) ;
int iPropI, iPropD, iPropS ;
String stYN[] = { "Yes", "No"}; 

PropString psCollectionEntityName (0, stCollectionEntityNames, "Assembly Name");
psCollectionEntityName.setReadOnly(true);//__this is controlled by insertion and rt-click
PropString psManufacturer(5, "Generic", T("|Manufacturer|"));


String arInstallation[]={"Installed", "Shipped Loose"};
PropString psInstallation (1, arInstallation, "Installation");
psInstallation.setReadOnly(true);

PropString psDoDrills(2, stYN, "Apply Drills");
PropDouble pdTextH(0, U(1), "Text Height");
PropInt piParentNumber (0, -1, "Parent Entity");
piParentNumber.setReadOnly(true);
if(pdTextH>U(0))dp.textHeight(pdTextH);

PropString psNotes(3, "", "Shopdraw Notes");

PropString psShowLabel (4, stYN, "Show Label?", 1);
int bShowLabel = psShowLabel == stYN[0];
PropDouble pdLabelTextHeight(1, U(25), "Label Text Height");
PropInt piLabelColor(1, 30, "Label Text Color");
Display dpLabel(piLabelColor);

// bOnInsert
if (_bOnInsert)
{
	Entity entsCE[0];
	
	PrEntity ssE("Select Existing", CollectionEntity());
	if(ssE.go()) entsCE = ssE.set();
	
	if(entsCE.length() > 0)
	{
		for(int i=0;i<entsCE.length(); i++)
		{
			CollectionEntity ce = (CollectionEntity)entsCE[i];
			if(!ce.bIsValid())continue;
			
			String stName = ce.definition();
			
			psCollectionEntityName.set(stName);
			
			_Entity.append(entsCE[0]);
			break;
		}
	}
	else
	{
		reportMessage("\nNothing selected");
		eraseInstance();
		return;
	}
	
		
	_GenBeam.append(getGenBeam("Select Main Beam/Panel (Parent)"));
	
	
	PrEntity pre ("Select Other Beams/Panels (Children)", GenBeam());
	if (pre.go())
	{
		Entity entBms[] = pre.set();
		for(int i=0;i<entBms.length();i++)
		{
			GenBeam gb = (GenBeam)entBms[i];
			if(!gb.bIsValid())continue;
			if(_GenBeam.find(gb) == -1)_GenBeam.append(gb);
		}
	}
}

if(_Entity.length() == 0)
{ 
	eraseInstance();
	return;
}

CollectionEntity ce;
ce = (CollectionEntity)_Entity[0];
if(! ce.bIsValid())
{ 
	reportMessage("\n" + scriptName() + " did no have ColEnt reference, self-desctructing");
	eraseInstance();
	return;
}


//region  Context Commands
//######################################################################################		
//######################################################################################	


String stResetParent = 	"Reselect Parent Beam";
String stResetChildren = "Reselect Child Beams";
String stAddChild = "Add Chilld Beams";
String stResetAll = "Reselect All Beams";
String stChangeAssemblyInUse = "Pick New Custom Assembly";

addRecalcTrigger(_kContext, stResetParent);
addRecalcTrigger(_kContext, stResetChildren);
addRecalcTrigger(_kContext, stResetAll);
addRecalcTrigger(_kContext, stChangeAssemblyInUse);


if(_kExecuteKey == stResetParent || _kExecuteKey == stResetAll )
{
	if (_kExecuteKey == stResetAll) _GenBeam.setLength(0);
	
	GenBeam bm = getGenBeam("Select a new primary beam/panel");
	int iFind = _GenBeam.find(bm);
	if(iFind > -1)_GenBeam.swap(0,iFind);
	else _GenBeam.insertAt(0,bm);
}

if(_kExecuteKey == stResetChildren || _kExecuteKey == stAddChild || _kExecuteKey == stResetAll)
{
	if(_kExecuteKey == stResetChildren)_GenBeam.setLength(1);
	
	PrEntity pre ("Select new child beams", GenBeam());
	if (pre.go())
	{
		Entity entBms[] = pre.set();
		for(int i=0;i<entBms.length();i++)
		{
			GenBeam gb = (GenBeam)entBms[i];
			if ( ! gb.bIsValid()) continue;
			if(_GenBeam.find(gb) == -1)_GenBeam.append(gb);
		}
	}
}

if(_kExecuteKey == stChangeAssemblyInUse)
{
	psCollectionEntityName.setReadOnly(false);
	showDialog();
	psCollectionEntityName.setReadOnly(true);
	
	//__replace existing instance
	ce.setDefinition(psCollectionEntityName);	
}


//######################################################################################
//######################################################################################	
//endregion End Context Commands 			



GenBeam gb;
if(_GenBeam.length() > 0)
{
	gb = _GenBeam[0];
	int iPosnum = gb.posnum();
	piParentNumber.set(iPosnum);
	
	if(_Entity.length() ==1)
	{ 
		_Entity.append(gb);
		setDependencyOnEntity(gb);
	}
}
		


CollectionDefinition cd = ce.definitionObject();
CoordSys csDefinitionTransform = ce.coordSys();

TslInst tslAll[] = cd.tslInst();
Map mpDrills, mpBeamCuts, mpCuts, mpFastenerRequests;

String stDefinition = ce.definition();

_Pt0 = csDefinitionTransform.ptOrg();
dp.draw(scriptName() + "(" +psCollectionEntityName +")", _Pt0, _XE, _YE, 0, 0, _kDeviceX);


if(bShowLabel)
{
	if(_PtG.length() == 0) _PtG.append(_Pt0 + _XW * U(100) + _YW * U(100));
	double dTailLength = pdLabelTextHeight/2;
	PLine plLabelLeader(_Pt0, _PtG[0]);
	Vector3d vLeaderDir = _PtG[0] - _Pt0;
	int iTailFlip = vLeaderDir.dotProduct(_XW) < 0 ? - 1 : 1;
	Vector3d vTail = _XW * iTailFlip;
	plLabelLeader.addVertex(_PtG[0] + vTail * dTailLength);
	Point3d ptLabelText = _PtG[0] + vTail * dTailLength *1.1;
	dpLabel.draw(stDefinition, ptLabelText, _XW, _YW, iTailFlip, 0);
	dp.draw(plLabelLeader);
}



//region  Gather Geometry, tool requests
//######################################################################################		
//######################################################################################	

//__Store envelopeBody for tool start/end point calculations
//__done here to prevent expensive repeatative operations in loops
Body bdEnvelopes[0];
Quader qdGenBeams[0];
for(int i=0;i<_GenBeam.length();i++)
{
	GenBeam gb = _GenBeam[i];
	Body bd = gb.envelopeBody(false, false);
	bdEnvelopes.append(bd);
	
	bd.transformBy(_ZW * 100);
	//bd.vis(3);
	
	Quader qd = gb.quader();	
	qdGenBeams.append(qd);
}

for(int i=0; i<tslAll.length(); i++)
{
	TslInst tsl = tslAll[i];
	Map mpTsl = tsl.map();
	String stDB = tsl.scriptName();

	if (stDB.makeUpper() == "SC_CUTTINGELEMENT")
	{
		Map mpBeams;
		for (int j = 0; j < _GenBeam.length(); j++) mpBeams.appendEntity("beam", _GenBeam[j]);
		mpTsl.setMap("mpBeams", mpBeams);
		tsl.setMap(mpTsl);
	}

	Map mpDrill = mpTsl.getMap("mpDrill");
	if (mpDrill.length() > 0) mpDrills.appendMap("mp", mpDrill);	
	
	
	Map mpBeamCut = mpTsl.getMap("mpBeamCut");
	if (mpBeamCut.length() > 0) mpBeamCuts.appendMap("mpBeamCut", mpBeamCut);	
	
	Map mpCut = mpTsl.getMap("mpCut");
	if (mpCut.length() > 0) mpCuts.appendMap("mpCut", mpCut);	

	//__Fastener requests
	if(mpTsl.hasMap("mpFastenerRequest"))
	{	
		mpFastenerRequests.appendMap("mpFastenerRequest", mpTsl.getMap("mpFastenerRequest"));
	}
}

//######################################################################################
//######################################################################################	
//endregion End Gather Geometry, tool requests 			


//region  Drills & BeamCuts & Cuts
//######################################################################################		
//######################################################################################	

int pointInQuader(Point3d pt, Quader qd)
{ 
	Vector3d vQdX = qd.vecX();
	Vector3d vQdY = qd.vecY();
	Vector3d vQdZ = qd.vecZ();
	Plane pnsTestPos[] = { qd.plFaceD(vQdX), qd.plFaceD(vQdY), qd.plFaceD(vQdZ)};
	Plane pnsTestNeg[] = { qd.plFaceD(-vQdX), qd.plFaceD(-vQdY), qd.plFaceD(-vQdZ)};
	
	for(int i=0; i<pnsTestPos.length(); i++)
	{
		Plane pnPos = pnsTestPos[i];
		Plane pnNeg = pnsTestNeg[i];
		Vector3d vPosDir = pnPos.closestPointTo(pt) - pt;
		Vector3d vNegDir = pnNeg.closestPointTo(pt) - pt;
		
		//__if point is between the 2 planes, vectors will point in opposite directions
		//__if point is outside both planes, vectors will point in same direction
		if (vNegDir.dotProduct(vPosDir) > 0) return 0;
	}
	
	return true;
}

double distToLine(Line ln, Point3d pt)
{ 
	return (ln.closestPointTo(pt) - pt).length();
}

//__determine optimal drill location/direction given 2 points and target
String stDrillStartKey = "ptDrillStart";
String stDrillEndKey = "ptDrillEnd";
Map CalculateDrill(Point3d ptRef1, Point3d ptRef2, Quader qdTarget)
{ 
	int b1IsInQuader = pointInQuader(ptRef1, qdTarget);
	int b2IsInQuader = pointInQuader(ptRef2, qdTarget);
	
	qdTarget.vis(6);
	ptRef1.vis(3);
	ptRef2.vis(5);
	Body bdTarget (qdTarget);
	Map mpDrill;
	
	if(! b1IsInQuader && ! b2IsInQuader)//__both points are outside target
	{ 
		Vector3d vProbe = ptRef1 - ptRef2;
		Line lnProbe(ptRef1, vProbe);
		Point3d ptsInt[] = bdTarget.intersectPoints(lnProbe);
		if(ptsInt.length() < 2) //__no valid intersection with target, return empty map
		{ 
			return mpDrill;
		}
		
		//__2 intersect points will define drill, use the one farthest from target axis for start point
		Line lnAxis(qdTarget.ptOrg(), qdTarget.vecX());
		Point3d ptIntStart = ptsInt.first();
		Point3d ptIntEnd = ptsInt.last();
		double dStartDist = distToLine(lnAxis, ptIntStart);
		double dEndDist = distToLine(lnAxis, ptIntEnd);
		Point3d ptDrillStart, ptDrillEnd;
		if(dStartDist < dEndDist)
		{ 
			ptDrillStart = ptIntEnd;
			ptDrillEnd = ptIntStart;
		}
		else
		{ 
			ptDrillStart = ptIntStart;
			ptDrillEnd = ptIntEnd;
		}
		
		mpDrill.setPoint3d(stDrillStartKey, ptDrillStart);
		mpDrill.setPoint3d(stDrillEndKey, ptDrillEnd);
		return mpDrill;
	}
	
	if(b1IsInQuader == ! b2IsInQuader)//__one and only one of the points is contained.
	{ 
		Point3d ptInside = b1IsInQuader ? ptRef1 : ptRef2;
		Point3d ptOutside = b1IsInQuader ? ptRef2 : ptRef1;
		
		Vector3d vRaySearch = ptOutside - ptInside;
		vRaySearch.normalize();
		Point3d ptInt;
		int bFoundInt = bdTarget.rayIntersection(ptInside, vRaySearch, ptInt);
		
		if(bFoundInt)
		{ 
			Point3d ptDrillStart = ptInt + vRaySearch * U(1, "inch");//__some clearance for tool startf
			mpDrill.setPoint3d(stDrillStartKey, ptDrillStart);
			mpDrill.setPoint3d(stDrillEndKey, ptInside);
			return mpDrill;
		}
		
		//__some unknown error/condition
		reportMessage("Could not determine drill locaion");
		return mpDrill;//__return empty map as error
	}
	
	if(b1IsInQuader && b2IsInQuader)//__both points in target, need to find best start point
	{ 
		Point3d ptInt1, ptInt2;
		Vector3d v1To2 = ptRef2 - ptRef1; v1To2.normalize();
		int found1 = bdTarget.rayIntersection(ptRef1, v1To2, ptInt1);
		int found2 = bdTarget.rayIntersection(ptRef2, - v1To2, ptInt2);
		
		if(found1 && found2)//__this should always be the case
		{ 
			double dOption1 = (ptInt1 - ptRef1).length();
			double dOption2 = (ptInt2 - ptRef2).length();
			int bUse1 = dOption1 < dOption2; //__shorter drill direction is probably best
			Point3d ptDrillStart, ptDrillEnd;
			if(bUse1) 
			{ 
				ptDrillStart = ptInt1;
				ptDrillEnd = ptRef1;
			}
			else
			{ 
				ptDrillStart = ptInt2;
				ptDrillEnd = ptRef2;
			}
			
			mpDrill.setPoint3d(stDrillStartKey, ptDrillStart);
			mpDrill.setPoint3d(stDrillEndKey, ptDrillEnd);
			return mpDrill;
		}
		else
		{ 
			reportMessage("\nCould not find drill tube intersection");//__basically an error condition, not expected
		}
	}
	return mpDrill;//__this line should never be hit.
}

if(psDoDrills == "Yes")
{
	for(int i=0; i<mpDrills.length(); i++)
	{
		Map mpDrill = mpDrills.getMap(i);
		
		GenBeam bmTargets[0];
		Body bdTargets[0];
		Quader qdTargets[0];
		
		String stTargetBeams = mpDrill.getString("stTargetBeams");		
		if (stTargetBeams == "Parent" || stTargetBeams == "All") 
		{
			bmTargets.append(_GenBeam[0]);
			bdTargets.append(bdEnvelopes[0]);
			qdTargets.append(qdGenBeams[0]);
		}
		if (stTargetBeams == "Children" || stTargetBeams == "All") 
		{
			for(int k=1; k<_GenBeam.length(); k++) 
			{
				bmTargets.append(_GenBeam[k]);
				bdTargets.append(bdEnvelopes[k]);
				qdTargets.append(qdGenBeams[k]);
			}
		}

		Point3d ptDrill = mpDrill.getPoint3d("ptDrillEnd");
		ptDrill.transformBy(csDefinitionTransform);
			//ptDrill.vis(1);
			
		Vector3d vDrill = mpDrill.getVector3d("vDrill");
		vDrill.transformBy(csDefinitionTransform);
		
		Point3d ptDrill2;
		if( mpDrill.hasPoint3d("ptDrillEnd2"))
		{ 
			ptDrill2 = mpDrill.getPoint3d("ptDrillEnd2");
			ptDrill2.transformBy(csDefinitionTransform);			
		}
		else
		{ 
			ptDrill2 = ptDrill - vDrill * U(100, "inch");
		}
		
		
		double dDrillRadius = mpDrill.getDouble("dRadius");
		for(int k=0; k<bmTargets.length(); k++)
		{
			GenBeam gb = bmTargets[k];
			//Body bdTarget = bdTargets[k];
			Quader qdTarget = qdTargets[k];
			Map mpDrillCalc = CalculateDrill(ptDrill, ptDrill2, qdTarget);
			if (mpDrillCalc.length() == 0) continue;
			
			Point3d ptStartDrill = mpDrillCalc.getPoint3d(stDrillStartKey);
			Point3d ptEndDrill = mpDrillCalc.getPoint3d(stDrillEndKey);
			ptStartDrill.vis(i);
			ptEndDrill.vis(i);
			Drill dr(ptStartDrill, ptEndDrill, dDrillRadius);
			gb.addTool(dr);
		}
	}
}

for(int i=0; i<mpBeamCuts.length(); i++)
{		
	Map mpBeamCut = mpBeamCuts.getMap(i);
	Point3d ptBCOrg = mpBeamCut.getPoint3d("ptOrg");
	ptBCOrg.transformBy(csDefinitionTransform);
	Vector3d vX = mpBeamCut.getVector3d("vX");
	Vector3d vY = mpBeamCut.getVector3d("vY");
	Vector3d vZ = mpBeamCut.getVector3d("vZ");
	vX.transformBy(csDefinitionTransform);
	vY.transformBy(csDefinitionTransform);
	vZ.transformBy(csDefinitionTransform);
	
	double dX = mpBeamCut.getDouble("dX");
	double dY = mpBeamCut.getDouble("dY");
	double dZ = mpBeamCut.getDouble("dZ");

	int iRoundType = mpBeamCut.getInt("iRoundType");

	String stToolType = "";
	
	if (mpBeamCut.hasString("stToolType")) 
	{
		stToolType = mpBeamCut.getString("stToolType");
	}

	
	String stTargetBeams = mpBeamCut.getString("stTargetBeams");
	GenBeam bmTargets[0];
	if (stTargetBeams == "Parent" || stTargetBeams == "All") bmTargets.append(_GenBeam[0]);
	if (stTargetBeams == "Children" || stTargetBeams == "All") for(int k=1; k<_GenBeam.length(); k++) bmTargets.append(_GenBeam[k]);
	
	for(int k=0; k<bmTargets.length(); k++)
	{
		GenBeam bm = bmTargets[k];
		Quader qdCut( ptBCOrg, vX, vY, vZ, dX, dY, dZ, 0, 0, -1);
		Body bdBm = bm.envelopeBody(true, true);
		Body bdQd(qdCut);
		
		if ( ! bdBm.hasIntersection(bdQd)) continue;
		bdQd.vis(6);

		qdCut.modifyBoxUntilFaceCompletelyOut(-vZ, bdBm, true);
		
		double dNewDepth = qdCut.dD(vZ) + U(.25, "inch");
		Point3d ptBeamCut = ptBCOrg - vZ * dNewDepth;
		int bToolNotAdded = true;

		if (stToolType == "House") 
		{
			House hs(ptBeamCut, vX, vY, vZ, dX, dY, dNewDepth, 0, 0, 1);
			hs.setRoundType(iRoundType);
			bm.addTool(hs);
			bToolNotAdded = false;
		}
		
		if(stToolType == "Slot")
		{
			Slot slt(ptBeamCut, vX, vY, vZ, dX, dY, dNewDepth, 0, 0, 1);
			bm.addTool(slt);
			bToolNotAdded = false;
		}
				
		if (bToolNotAdded) 
		{
			BeamCut bc(ptBeamCut,  vX, vY, vZ, dX, dY, dNewDepth, 0, 0, 1);
			bm.addTool(bc);
		}
	}	
}

for(int i=0;i<mpCuts.length();i++)
	{
		Map mpCut = mpCuts.getMap(i);
		Point3d ptCutOrg = mpCut.getPoint3d("ptCut");
		ptCutOrg.transformBy(csDefinitionTransform);
		Vector3d vCut = mpCut.getVector3d("vCut");
		vCut.transformBy(csDefinitionTransform);
		String stTarget = mpCut.getString("stTarget");
		int bTargetParent = stTarget == "Parent";
		GenBeam bmCutTarget;

		if(bTargetParent)
		{ 
			bmCutTarget = _GenBeam[0];
		}
		else
		{ 
			if (_GenBeam.length() < 2) continue;
			bmCutTarget = _GenBeam[1];
		}
		
		Cut ct(ptCutOrg, vCut);
		bmCutTarget.addTool(ct, _kStretchOnToolChange);
	}


//######################################################################################
//######################################################################################	
//endregion End Drills & BeamCuts & Cuts	

//region  Fastener Requests
//######################################################################################		
//######################################################################################	

Map mpFastenersCreated = _Map.getMap("mpFastenersCreated");
Map mpFastenersValidated;
Map mpMaleEntsShopdraw, mpFemaleEntsShopdraw;

//String arFace[] = { "Z", "-Z", "X", "-X", "Y", "-Y" };
Body bdMale = gb.envelopeBody(false, true);
Body bdFemale;
int bHaveFemale;
GenBeam gbFemale;
if(_GenBeam.length() > 1)
{
	gbFemale = _GenBeam[0];
	bdFemale = gbFemale.envelopeBody(false, true);
	bHaveFemale = true;
}

for(int i=0;i<mpFastenerRequests.length();i++)
{
	Map mpRequest = mpFastenerRequests.getMap(i);
	Entity entCollection = mpRequest.getEntity("entCollection");
	CollectionEntity ce = (CollectionEntity)entCollection;
	Entity entTsl = mpRequest.getEntity("entTsl");
	TslInst tsl = (TslInst)entTsl;
	CoordSys csColEnt = ce.coordSys();
	
	Map mpFastenerRequest = mpRequest.getMap("mpFastenerRequest");
	Point3d ptFastener = mpFastenerRequest.getPoint3d("ptFastener");
	ptFastener.transformBy(csColEnt);
	String stFastenerKey = mpFastenerRequest.getString("stFastenerKey");
	Vector3d vFastenerDir = mpFastenerRequest.getVector3d("vFastenerDir");
	vFastenerDir.transformBy(csColEnt);
	String stInstallation = mpFastenerRequest.getString("stInstallation");
	String stTslHandle = mpFastenerRequest.getString("stHandle");
	double dFastenerLength = mpFastenerRequest.getDouble("dFastenerLength");
	
	
	String stFastenerEntityKey = ce.handle() + stTslHandle;
	Entity entFastener = mpFastenersCreated.getEntity(stFastenerEntityKey);
	TslInst tslFastener = (TslInst)entFastener;
	
	Map mpFastener;
	mpFastener.setString("FastenerModel", stFastenerKey);
	mpFastener.setEntity("ParentTSL", _ThisInst);
	mpFastener.setVector3d("vFastener", vFastenerDir);
	mpFastener.setPoint3d("ptMainPoint", ptFastener);
	mpFastener.setString("installedBy", stInstallation);


	Body bdProbe (ptFastener, ptFastener + vFastenerDir * dFastenerLength, U(.2, "inch"));
	int foundMaleIntersect = bdProbe.hasIntersection(bdMale);
	int foundFemaleIntersect;
	if(bHaveFemale) foundFemaleIntersect = bdProbe.hasIntersection(bdFemale);
	
	GenBeam gbTarget = gb;
	Vector3d vFastenerX = gb.vecX();
	if (foundFemaleIntersect && ! foundMaleIntersect) 
	{
		gbTarget = gbFemale;
		vFastenerX = gbFemale.vecX();
	}
	
	Vector3d vFastenerY = - vFastenerDir.crossProduct(vFastenerX);
	
	if(entFastener.bIsValid())//__fastener already created, adjust position and data
	{ 
		tslFastener.setMap(mpFastener);
		tslFastener.setPtOrg(ptFastener);
	}
	else//__need to create new fastener
	{ 		
		String sScriptName = "SC_Fastener";
		
		Vector3d vecUcsX = vFastenerX;
		Vector3d vecUcsY = vFastenerY;
		GenBeam lstBeams[1];
		Entity lstEnts[1];
		Point3d lstPoints[0];
		lstPoints.append(ptFastener);
		int lstPropInt[0];
		//lstPropInt.append(nQTY);
		double lstPropDouble[0];
		String lstPropString[0];
		lstBeams[0] = gbTarget;
		tslFastener.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,1,mpFastener );
	}	
	
	mpFastenersValidated.setEntity(stFastenerEntityKey, tslFastener);
}

_Map.setMap("mpFastenersCreated", mpFastenersValidated);

//__also add created fasteners to shopdraw if they are shop installed
for(int i=0;i<mpFastenersValidated.length();i++)
{
	Entity ent = mpFastenersValidated.getEntity(i);
	Map mpHardware = ent.getAttachedPropSetMap("SC_Hardware");
	String stInstal = mpHardware.getString("Installed");
	stInstal.makeUpper();
	if(stInstal.find("SHOP", 0) >= 0)
	{ 
		TslInst tsl = (TslInst)ent;
		Beam bms[] = tsl.beam();
		if(bms[0] == gb)
		{ 
			mpMaleEntsShopdraw.appendEntity("ent", tsl);
		}
		
		if(bms[0] == gbFemale)
		{ 
			mpFemaleEntsShopdraw.appendEntity("ent", tsl);
		}
	}
}

Map mpStoredMaleEnts = gb.subMap("mpEntsShopdraw");
for(int i=0;i<mpMaleEntsShopdraw.length();i++)
{
	Entity ent = mpMaleEntsShopdraw.getEntity(i);
	mpStoredMaleEnts.setEntity(ent.handle(), ent);
}
gb.setSubMap("mpEntsShopdraw", mpStoredMaleEnts);


if(bHaveFemale) 
{
	Map mpStoredFemaleEnts = gbFemale.subMap("mpEntsShopdraw");
	for(int i=0;i<mpFemaleEntsShopdraw.length();i++)
	{
		Entity ent = mpFemaleEntsShopdraw.getEntity(i);
		mpStoredFemaleEnts.setEntity(ent.handle(), ent);
	}
	gbFemale.setSubMap("mpEntsShopdraw", mpStoredFemaleEnts);
}


//######################################################################################
//######################################################################################	
//endregion End Fastener Requests 
			

//region  Hardware from collection
//######################################################################################		
//######################################################################################	
HardWrComp hwcCollected[0];
HardWrComp hwThis(piParentNumber, 1);
hwThis.setModel(psCollectionEntityName);
hwThis.setManufacturer(psManufacturer);
hwcCollected.append(hwThis);
for(int i=0; i<tslAll.length(); i++)
{
	TslInst tsl = tslAll[i];
	HardWrComp comps[] = tsl.hardWrComps();
	for(int k=0; k<comps.length(); k++)
	{
		HardWrComp comp = comps[k];
		comp.setLinkedEntity(gb);
		hwcCollected.append(comp);
	}
}

_ThisInst.setHardWrComps(hwcCollected);

//######################################################################################
//######################################################################################	
//endregion End Hardware from collection 			


//######################################################################################		
//########################## HardwareInfo for Shopdraw #############################################	

/*
//__density is stored in kg/m^3, .dwg is mm or inch. calculate conversion factor around this 
//__ kg/m^3 * 2.2046 = lb/m^3
//__1 m^3  = 1,000,000,000 mm^3
int bIsMetricDwg = U(1, "mm") == 1;
double dVolumeConversionFactor =  bIsMetricDwg ? .000000001 : .000016387;
double dLengthConversionFactor = bIsMetricDwg ? 1 : 25.4;

double dAssemblyWeight;
Body bdAssembly;

Beam bmAll[] = cd.beam();
for(int i=0;i<bmAll.length();i++)
{
	Beam bm = bmAll[i];
	
	String arPropSetsAttached[] = bm.attachedPropSetNames();
	int bHasPS = false;
	for(int p=0;p<arPropSetsAttached.length(); p++)
	{ 
		Map mpSet = bm.getAttachedPropSetMap(arPropSetsAttached[p]);
		if (mpSet.indexAt("ShopdrawID") > - 1)
		{
			bHasPS = true;
			stBeamPropSetName = arPropSetsAttached[p];
			break;
		}
	}
	
	
	
	if(! bHasPS) bm.attachPropSet(stBeamPropSetName);
	Body bdBm = bm.envelopeBody(true, true);
	bdBm.transformBy(csDefinitionTransform);
	double dBmVolumemm = bdBm.volume();
	double dBmVolume = bdBm.volume() * dVolumeConversionFactor;//__this should be in m^3
	double dBmWeight = dBmVolume * dSteelDensity * 2.2046;
	
	Map mpBeamProps = bm.getAttachedPropSetMap(stBeamPropSetName);
	mpBeamProps.setDouble("Weight(lbs)", dBmWeight);
	bm.setAttachedPropSetFromMap(stBeamPropSetName, mpBeamProps);
	 
	bdAssembly += bdBm;
	dAssemblyWeight += dBmWeight;
}

dAssemblyWeight = round(dAssemblyWeight * 1000) / 1000;

double dAssemblyLength = bdAssembly.lengthInDirection(csCE.vecX()) * dLengthConversionFactor;
double dAssemblyWidth = bdAssembly.lengthInDirection(csCE.vecY()) * dLengthConversionFactor;
double dAssemblyHeight = bdAssembly.lengthInDirection(csCE.vecZ()) * dLengthConversionFactor;


//########################## End HardwareInfo for Shopdraw ###############################################
//######################################################################################	
			



	
#End
#BeginThumbnail








































#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="Resource[]">
    <lst nm="IMAGE[]" />
  </lst>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="486" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Revised calculations for drill points" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="40" />
      <str nm="Date" vl="5/5/2025 2:25:59 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Writing CE block name to Hardware list. Exposing a Manufacturer string property, also present in Hardware." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="36" />
      <str nm="Date" vl="11/12/2024 12:47:53 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="re-Bugfix to 1.32 bugfix" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="35" />
      <str nm="Date" vl="4/6/2023 8:37:01 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Updated drill logic to catch completely through case" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="34" />
      <str nm="Date" vl="4/5/2023 4:16:51 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Bugfix in coordinating toolType for Beamcut operations" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="32" />
      <str nm="Date" vl="3/14/2023 4:33:48 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Bugfix on applying drills, may or may not intersect" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="31" />
      <str nm="Date" vl="2/23/2023 12:47:59 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Bugfix on BeamCut dimensions" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="4/22/2022 3:54:34 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Public Release" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="4/20/2022 10:44:49 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End