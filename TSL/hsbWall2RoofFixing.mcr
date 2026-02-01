#Version 8
#BeginDescription
#Versions:
version value="1.1" date="17jan2022" author="marsel.nakuci@hsbcad.com"> HSB-13746: use continuous distribution, TSL assignment, TSL run as an element TSL

This tsl creates Nailing distribution between walls and roofs
TSL can be attached as a wall TSL and run on wall construction
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords Top hat,Nailing,wall, roof
#BeginContents
/// <History>//region
/// #Versions:
/// <version value="1.1" date="17jan2022" author="marsel.nakuci@hsbcad.com"> HSB-13746: use continuous distribution, TSL assignment, TSL run as an element TSL </version>
/// <version value="1.0" date="03feb2021" author="marsel.nakuci@hsbcad.com"> HSB-10120: initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates Nailing distribution between walls and roofs
/// TSL can be attached as a wall TSL and run on wall construction
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "ScriptName")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion
	
//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true; break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end Constants//endregion
	
//region Properties
	String sNailIndexName=T("|Nail Index|");
	int nNailIndexs[]={1,2,3};
	PropInt nNailIndex(nIntIndex++, 0, sNailIndexName);	
	nNailIndex.setDescription(T("|Defines the NailIndex|"));
	nNailIndex.setCategory(category);
	// direction of nail
	category = T("|Alignment|");
	String sDirectionName=T("|Direction|");	
	String sDirections[] ={ T("|Wall-Floor/Ceiling|"), T("|Floor/Ceiling-Wall|")};
	PropString sDirection(nStringIndex++, sDirections, sDirectionName);	
	sDirection.setDescription(T("|Defines the direction of nail|"));
	sDirection.setCategory(category);
	// 
	String sDistributionAreaName=T("|Distribution Areas|");	
	String sDistributionAreas[] ={ T("|Continuous|"), T("|Separately|")};
	PropString sDistributionArea(nStringIndex++, sDistributionAreas, sDistributionAreaName);	
	sDistributionArea.setDescription(T("|Defines how the nailing distribution should be done.|")+" "+
	T("|Continuously from start to end or separately for each distribution area.|"));
	sDistributionArea.setCategory(category);
//	sDistributionArea.setReadOnly(_kHidden);
	sDistributionArea.setReadOnly(_kReadOnly);
	category = T("|Distribution|");
	String sModeDistributionName=T("|Mode|");
	String sModeDistributions[] ={ T("|Even|"), T("|Fixed|")};
	PropString sModeDistribution(nStringIndex++, sModeDistributions, sModeDistributionName);	
	sModeDistribution.setDescription(T("|Defines the Distribution Mode between even or fixed.|")+" "+
	T("|User can enter|")+" "+T("|Even|")+ " or "+T("|Fixed|"));
	sModeDistribution.setCategory(category);
	//distance from the bottom / start
	String sDistanceBottomName = T("|Distance Bottom/Start|");
	PropDouble dDistanceBottom(nDoubleIndex++, U(0), sDistanceBottomName);
	dDistanceBottom.setDescription(T("|Defines the distance at the bottom or start of distribution|"));
	dDistanceBottom.setCategory(category);
	// distance from the top/end
	String sDistanceTopName = T("|Distance Top/End|");
	PropDouble dDistanceTop(nDoubleIndex++, U(0), sDistanceTopName);
	dDistanceTop.setDescription(T("|Defines the distance at the top or end of distribution|"));
	dDistanceTop.setCategory(category);
	// distance in between/ nr of parts (when negative input)
	String sDistanceBetweenName=T("|Max. Distance between| ");	
	PropDouble dDistanceBetween(nDoubleIndex++, U(10), sDistanceBetweenName);
	dDistanceBetween.setDescription(T("|Defines the MAx. distance between the parts.|"));
	// Negative number will indicate nr of parts from the integer part of the inserted double
	dDistanceBetween.setCategory(category);
	// nr of parts/distance in between after calculation
	String sDistanceBetweenResultName=T("|Distance between calculated|");
	PropDouble dDistanceBetweenResult(nDoubleIndex++, U(0), sDistanceBetweenResultName);
	dDistanceBetweenResult.setDescription(T("|Exact distance between nails for an equal distribution|"));
	dDistanceBetweenResult.setReadOnly(_kHidden);
	dDistanceBetweenResult.setCategory(category);
	String sNrResultName=T("|Nr.|");
//	int nNrResults[]={1,2,3};
	PropInt nNrResult(nIntIndex++, 0, sNrResultName);
	nNrResult.setDescription(T("|Number of nails|"));
	nNrResult.setReadOnly(true);
	nNrResult.setCategory(category);
	
	// safe distance from stud and tooling
	String sDistaceStudName=T("|Distace Stud|");
	PropDouble dDistaceStud(nDoubleIndex++, U(0), sDistaceStudName);
	dDistaceStud.setDescription(T("|Defines the Distace from Stud|"));
	dDistaceStud.setCategory(category);
	
	String sDistanceToolingName=T("|Distance Tooling|");
	PropDouble dDistanceTooling(nDoubleIndex++, U(0), sDistanceToolingName);
	dDistanceTooling.setDescription(T("|Defines the Distance from Tooling|"));
	dDistanceTooling.setCategory(category);
	
	// define whether the TSL applies for floor or ceiling
	String sTypeName=T("|Type|");
	String sTypes[] ={ T("|Floor|"), T("|Ceiling|")};
	PropString sType(nStringIndex++, sTypes, sTypeName);
	sType.setDescription(T("|Defines the Type|"));
	sType.setCategory(category);
//End Properties//endregion 
	
//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
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
		
		Entity ents[0];
		PrEntity ssE(T("|Select stick frame wall(s) and roof(s) elements|"), ElementWallSF());
		ssE.addAllowedClass(ElementRoof());
		if (ssE.go())
			ents.append(ssE.set());
		
		for (int i=0;i<ents.length();i++) 
		{ 
			Element el = (Element)ents[i];
			if (el.bIsValid())
				if (_Element.find(el) < 0)
				{
					_Element.append(el);
					continue;
				}
		}//next i
		
		if(_Element.length()<2)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|At least a wall and a roof are needed|"));
			eraseInstance();
			return;
		}
		_Map.setInt("Inserted", true);
		return;
	}	
// end on insert	__________________//endregion
	
//region mapIO: support property dialog input via map on element creation
	{
		int bHasPropertyMap = _Map.hasMap("PROPSTRING[]") && _Map.hasMap("PROPINT[]") && _Map.hasMap("PROPDOUBLE[]");
		if (_bOnMapIO)
		{ 
			if (bHasPropertyMap)
				setPropValuesFromMap(_Map);	
			showDialog();
			_Map = mapWithPropValues();
			return;
		}
		if (_bOnElementDeleted)
		{
			eraseInstance();
			return;
		}
		else if (_bOnElementConstructed && bHasPropertyMap)
		{ 
			setPropValuesFromMap(_Map);
			_Map = Map();
		}	
	}		
//End mapIO: support property dialog input via map on element creation//endregion 

int nInserted = _Map.getInt("Inserted");
if(!nInserted && _bOnElementConstructed)
{ 
	// on wall construction get the floor and ceiling
	if(_Element.length()==0)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|wall not found|"));
		eraseInstance();
		return;
	}	
	Element el = _Element[0];
	ElementWallSF wall = (ElementWallSF) el;
	if(!el.bIsKindOf(ElementWallSF()) || !wall.bIsValid())
	{ 
		reportMessage("\n"+scriptName()+" "+T("|TSL should only be attached to SF Walls|"));
		eraseInstance();
		return;
	}
	
	// get floor or ceilin
	Entity entFloors[] = Group().collectEntities(true, ElementRoof(), _kModelSpace);
	ElementRoof floors[0];
	// remove all roofs, keep only floors
	for (int i=entFloors.length()-1; i>=0 ; i--) 
	{ 
		ElementRoof eRoofI = (ElementRoof)entFloors[i];
		if(!eRoofI.bIsAFloor())
		{
			entFloors.removeAt(i);
		}
		else
		{ 
			floors.append(eRoofI);
		}
		
	}//next i
	
	ElementWallSF el0 = wall;
	Point3d ptOrg0 = el0.ptOrg();
	Vector3d vecX0 = el0.vecX();
	Vector3d vecY0 = el0.vecY();
	Vector3d vecZ0 = el0.vecZ();
	PLine plOutlineWall0 = el0.plOutlineWall();
	// in xy, vertical planeprofile
	PlaneProfile ppEnvelope0 = el0.plEnvelope();
	// plane at base of el0
	Plane pn0(ptOrg0, vecY0);
	CoordSys csHor(pn0.ptOrg(), pn0.vecX(), pn0.vecY(), pn0.vecZ());
	PlaneProfile pp0(csHor);
	pp0.joinRing(plOutlineWall0, _kAdd);
	
	Point3d ptCen0;
	double dX0, dY0, dZ0;
	// get extents of profile
	{
		LineSeg seg = pp0.extentInDir(vecX0);
		ptCen0 = seg.ptMid();
		
		dX0 = abs(vecX0.dotProduct(seg.ptStart()-seg.ptEnd()));
		dZ0 = abs(vecZ0.dotProduct(seg.ptStart()-seg.ptEnd()));
		//
		// get extents of profile
		seg = ppEnvelope0.extentInDir(vecX0);
		dY0 = abs(vecY0.dotProduct(seg.ptStart() - seg.ptEnd()));
		ptCen0 += (vecY0 * vecY0.dotProduct(seg.ptMid() - ptCen0));
		ptCen0.vis(3);
	}
	Quader qd0(ptCen0, vecX0, vecY0, vecZ0, dX0, dY0, dZ0, 0, 0, 0);
	Body bd0(qd0);
	// extended body to get intersection with slab when needed
	Quader qd0Extend(ptCen0, vecX0, vecY0, vecZ0, dX0, dY0+U(200), dZ0, 0, 0, 0);
	Body bd0Extend(qd0Extend);
	
	// floor attached with the wall
	ElementRoof floorFound;
	
	for (int j=0;j<floors.length();j++) 
	{ 
		ElementRoof el1 = floors[j]; 
		Point3d ptOrg1 = el1.ptOrg();
		Vector3d vecX1 = el1.vecX();
		Vector3d vecY1 = el1.vecY();
		Vector3d vecZ1 = el1.vecZ();
		LineSeg seg1MinMax = el1.segmentMinMax();
		Point3d ptCen1;
		double dX1, dY1, dZ1;
		{ 
			ptCen1 = seg1MinMax.ptMid();
			dX1 = abs(vecX1.dotProduct(seg1MinMax.ptStart() - seg1MinMax.ptEnd()));
			dY1 = abs(vecY1.dotProduct(seg1MinMax.ptStart() - seg1MinMax.ptEnd()));
			dZ1 = abs(vecZ1.dotProduct(seg1MinMax.ptStart() - seg1MinMax.ptEnd()));
		}
		Quader qd1(ptCen1, vecX1, vecY1, vecZ1, dX1, dY1, dZ1, 0, 0, 0);
		Body bd1(qd1);
		
		Body bdWall=bd0Extend;
		Body bdFloor = bd1;
		
	// see if wall and floor intrsect each other
		if(!bdWall.hasIntersection(bdFloor))
			continue;
			
		// create TSL
		TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {}; Entity entsTsl[] = {el0, el1}; Point3d ptsTsl[] = {_Pt0};
		int nProps[]={nNailIndex, nNrResult};	
		double dProps[]={dDistanceBottom, dDistanceTop, dDistanceBetween, dDistanceBetweenResult, dDistaceStud, dDistanceTooling};
		String sProps[]={sDirection,sDistributionArea,sModeDistribution,sType};
		Map mapTsl;	
		mapTsl.setInt("iMode", 1);
		mapTsl.setInt("Inserted", true);
		//
		tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);

	}//next j
	// delete distribution TSL
	eraseInstance();
	return;
}
else if(!nInserted)
{ 
	// tsl created from wall
	// wait for wall calculation
	return;
}
	
	ElementWallSF elWalls[0];
	ElementRoof elRoofs[0];
	
	for (int i=0;i<_Element.length();i++) 
	{ 
		Element el=_Element[i];
		if(el.bIsKindOf(ElementWallSF()))
		{ 
			ElementWallSF elWall = (ElementWallSF) el;
			if(elWalls.find(elWall)<0)
				elWalls.append(elWall);
		}
		else if(el.bIsKindOf(ElementRoof()))
		{ 
			ElementRoof elRoof = (ElementRoof)el;
			if (elRoofs.find(elRoof) < 0)
				elRoofs.append(elRoof);
		} 
	}//next i

if(elWalls.length()==0)
{ 
	reportMessage("\n"+scriptName()+" "+T("|At least one wall is needed|"));
	eraseInstance();
	return;
}
if(elRoofs.length()==0)
{ 
	reportMessage("\n"+scriptName()+" "+T("|At least one roof is needed|"));
	eraseInstance();
	return;
}

int iMode = _Map.getInt("iMode");
if(iMode==0)
{ 
	// distribution mode
	int iCoupleIds[0];
	for (int i=0;i<_Element.length();i++) 
	{ 
		ElementWallSF el0 = (ElementWallSF) _Element[i];
		if ( ! el0.bIsValid())
			continue;
		// general data of el0
		Point3d ptOrg0 = el0.ptOrg();
		Vector3d vecX0 = el0.vecX();
		Vector3d vecY0 = el0.vecY();
		Vector3d vecZ0 = el0.vecZ();
		PLine plOutlineWall0 = el0.plOutlineWall();
		// in xy, vertical planeprofile
		PlaneProfile ppEnvelope0 = el0.plEnvelope();
		// plane at base of el0
		Plane pn0(ptOrg0, vecY0);
		CoordSys csHor(pn0.ptOrg(), pn0.vecX(), pn0.vecY(), pn0.vecZ());
		PlaneProfile pp0(csHor);
		pp0.joinRing(plOutlineWall0, _kAdd);
		
		Point3d ptCen0;
		double dX0, dY0, dZ0;
		// get extents of profile
		{
			LineSeg seg = pp0.extentInDir(vecX0);
			ptCen0 = seg.ptMid();
			
			dX0 = abs(vecX0.dotProduct(seg.ptStart()-seg.ptEnd()));
			dZ0 = abs(vecZ0.dotProduct(seg.ptStart()-seg.ptEnd()));
			//
			// get extents of profile
			seg = ppEnvelope0.extentInDir(vecX0);
			dY0 = abs(vecY0.dotProduct(seg.ptStart() - seg.ptEnd()));
			ptCen0 += (vecY0 * vecY0.dotProduct(seg.ptMid() - ptCen0));
			ptCen0.vis(3);
		}
		Quader qd0(ptCen0, vecX0, vecY0, vecZ0, dX0, dY0, dZ0, 0, 0, 0);
		Body bd0(qd0);
		// extended body to get intersection with slab when needed
		Quader qd0Extend(ptCen0, vecX0, vecY0, vecZ0, dX0, dY0+U(200), dZ0, 0, 0, 0);
		Body bd0Extend(qd0Extend);
		for (int j = 0; j < _Element.length(); j++)
		{
			if (i == j)
				continue;
			// avoid couples ij and ji
			int iThisId = 1000 * i + j;
			int iCheckId = 1000 * j + i;
			if(iCoupleIds.find(iCheckId)>-1)
				continue
			ElementRoof el1 = (ElementRoof)_Element[j];
			if ( ! el1.bIsValid())
				continue;
			// general data of el1
			Point3d ptOrg1 = el1.ptOrg();
			Vector3d vecX1 = el1.vecX();
			Vector3d vecY1 = el1.vecY();
			Vector3d vecZ1 = el1.vecZ();
			vecX1.vis(ptOrg1);
			vecY1.vis(ptOrg1);
			vecZ1.vis(ptOrg1);
			LineSeg seg1MinMax = el1.segmentMinMax();
			seg1MinMax.vis(4);
			
			Point3d ptCen1;
			double dX1, dY1, dZ1;
			{ 
				ptCen1 = seg1MinMax.ptMid();
				dX1 = abs(vecX1.dotProduct(seg1MinMax.ptStart() - seg1MinMax.ptEnd()));
				dY1 = abs(vecY1.dotProduct(seg1MinMax.ptStart() - seg1MinMax.ptEnd()));
				dZ1 = abs(vecZ1.dotProduct(seg1MinMax.ptStart() - seg1MinMax.ptEnd()));
			}
			Quader qd1(ptCen1, vecX1, vecY1, vecZ1, dX1, dY1, dZ1, 0, 0, 0);
			Body bd1(qd1);
			
//			PLine plOutlineWall1 = el1.plOutlineWall();
//			// in xy, vertical planeprofile
//			PlaneProfile ppEnvelope1 = el1.plEnvelope();
//			// plane at base of el1
//			Plane pn1(ptOrg1, vecY1);
//			CoordSys csHor(pn1.ptOrg(), pn1.vecX(), pn1.vecY(), pn1.vecZ());
//			PlaneProfile pp1(csHor);
//			pp1.joinRing(plOutlineWall1, _kAdd);
//			pp1.vis(3);
//			Point3d ptCen1;
//			double dX1, dY1, dZ1;
//			// get extents of profile
//			{
//				LineSeg seg = pp1.extentInDir(vecX1);
//				ptCen1 = seg.ptMid();
//				
//				dX1 = abs(vecX1.dotProduct(seg.ptStart()-seg.ptEnd()));
//				dZ1 = abs(vecZ1.dotProduct(seg.ptStart()-seg.ptEnd()));
//				//
//				// get extents of profile
//				seg = ppEnvelope1.extentInDir(vecX1);
//				dY1 = abs(vecY1.dotProduct(seg.ptStart() - seg.ptEnd()));
//				ptCen1 += (vecY1 * vecY1.dotProduct(seg.ptMid() - ptCen1));
//				ptCen1.vis(3);
//			}
//			Quader qd1(ptCen1, vecX1, vecY1, vecZ1, dX1, dY1, dZ1, 0, 0, 0);
//			Body bd1(qd1);
//			// extended body to get intersection with slab when needed
//			Quader qd1Extend(ptCen1, vecX1, vecY1, vecZ1, dX1, dY1+10*dEps, dZ1, 0, 0, 0);
//			Body bd1Extend(qd1Extend);
			
		// get body of wall
			Body bdWall=bd0Extend;
			Body bdFloor = bd1;
			
		// see if wall and floor intrsect each other
			if(!bdWall.hasIntersection(bdFloor))
				continue;
				
			// Wall- floor will be mode 1 connection
		 // create TSL
			TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {}; Entity entsTsl[] = {el0, el1}; Point3d ptsTsl[] = {_Pt0};
			int nProps[]={nNailIndex, nNrResult};	
			double dProps[]={dDistanceBottom, dDistanceTop, dDistanceBetween, dDistanceBetweenResult, dDistaceStud, dDistanceTooling};
			String sProps[]={sDirection,sDistributionArea,sModeDistribution,sType};
			Map mapTsl;	
			mapTsl.setInt("iMode", 1);
			mapTsl.setInt("Inserted", nInserted);
			
			//
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
		}
	}//next i
	// delete distribution TSL
	eraseInstance();
	return;
}

if(_Element.length()!=2)
{ 
	reportMessage("\n"+scriptName()+" "+T("|a wall and a roof element are needed|"));
	eraseInstance();
	return;
}

ElementWallSF el0 = (ElementWallSF)_Element[0];
if(!el0.bIsValid())
{ 
	reportMessage("\n"+scriptName()+" "+T("|first element must be a wall element|"));
	eraseInstance();
	return;
}
ElementRoof el1 = (ElementRoof)_Element[1];
if(!el1.bIsValid())
{ 
	reportMessage("\n"+scriptName()+" "+T("|second element must be a roof element|"));
	eraseInstance();
	return;
}

// general data of el0
Point3d ptOrg0 = el0.ptOrg();
Vector3d vecX0 = el0.vecX();
Vector3d vecY0 = el0.vecY();
Vector3d vecZ0 = el0.vecZ();
_Pt0 = ptOrg0;
PLine plOutlineWall0 = el0.plOutlineWall();
// in xy, vertical planeprofile
PlaneProfile ppEnvelope0 = el0.plEnvelope();
// plane at base of el0
Plane pn0(ptOrg0, vecY0);
CoordSys csHor(pn0.ptOrg(), pn0.vecX(), pn0.vecY(), pn0.vecZ());
PlaneProfile pp0(csHor);
pp0.joinRing(plOutlineWall0, _kAdd);

Point3d ptCen0;
double dX0, dY0, dZ0;
// get extents of profile
{
	LineSeg seg = pp0.extentInDir(vecX0);
	ptCen0 = seg.ptMid();
	
	dX0 = abs(vecX0.dotProduct(seg.ptStart()-seg.ptEnd()));
	dZ0 = abs(vecZ0.dotProduct(seg.ptStart()-seg.ptEnd()));
	//
	// get extents of profile
	seg = ppEnvelope0.extentInDir(vecX0);
	dY0 = abs(vecY0.dotProduct(seg.ptStart() - seg.ptEnd()));
	ptCen0 += (vecY0 * vecY0.dotProduct(seg.ptMid() - ptCen0));
	ptCen0.vis(3);
}
Quader qd0(ptCen0, vecX0, vecY0, vecZ0, dX0, dY0, dZ0, 0, 0, 0);
Body bd0(qd0);
// extended body to get intersection with slab when needed
Quader qd0Extend(ptCen0, vecX0, vecY0, vecZ0, dX0, dY0+10*dEps, dZ0, 0, 0, 0);
Body bd0Extend(qd0Extend);
bd0.vis(4);

Point3d ptOrg1 = el1.ptOrg();
Vector3d vecX1 = el1.vecX();
Vector3d vecY1 = el1.vecY();
Vector3d vecZ1 = el1.vecZ();
LineSeg seg1MinMax = el1.segmentMinMax();
//seg1MinMax.vis(4);

Point3d ptCen1;
double dX1, dY1, dZ1;
{ 
	ptCen1 = seg1MinMax.ptMid();
	dX1 = abs(vecX1.dotProduct(seg1MinMax.ptStart() - seg1MinMax.ptEnd()));
	dY1 = abs(vecY1.dotProduct(seg1MinMax.ptStart() - seg1MinMax.ptEnd()));
	dZ1 = abs(vecZ1.dotProduct(seg1MinMax.ptStart() - seg1MinMax.ptEnd()));
}
Quader qd1(ptCen1, vecX1, vecY1, vecZ1, dX1, dY1, dZ1, 0, 0, 0);
Body bd1(qd1);
bd1.vis(5);

// get body of wall
Body bdWall = bd0Extend;
Body bdFloor = bd1;

// see if wall and floor intrsect each other
if(!bdWall.hasIntersection(bdFloor))
{
	reportMessage("\n"+scriptName()+" "+T("|wall and floor do not intersect each other|"));
	eraseInstance();
	return;
}


// check if a Floor or ceiling
int nType = sTypes.find(sType);


if((nType==0 && vecY0.dotProduct(bdFloor.ptCen()-bdWall.ptCen())>0)
	|| (nType==1 && vecY0.dotProduct(bdFloor.ptCen()-bdWall.ptCen())<0))
{ 
	// floor selected but its a Ceiling
	// or ceiling selected but its a floor
	eraseInstance();
	return;
}
sType.setReadOnly(_kHidden);
// get the wall top /bottom plate
Beam bmWall;
Beam bmWalls[0];
Vector3d vecYwallRoof;
Beam bmStuds[0];
PlaneProfile ppBmWalls(Plane(ptOrg0, vecY0));
PlaneProfile ppStuds(Plane(ptOrg0, vecY0));
{ 
	vecYwallRoof = vecY0;
	if (vecY0.dotProduct(bd1.ptCen() - bd0.ptCen()) < 0)vecYwallRoof *= -1;
	Beam beamsWall[] = el0.beam();
	for (int i=beamsWall.length()-1; i>=0 ; i--) 
	{ 
		if(beamsWall[i].myZoneIndex()!=0) 
			beamsWall.removeAt(i);
	}//next i
	
	// from top to bottom
	Beam beamsHor[] = (-vecYwallRoof).filterBeamsPerpendicularSort(beamsWall);
	bmStuds = vecX0.filterBeamsPerpendicularSort(beamsWall);
	if(beamsHor.length()==0)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|wall has no top/bottom plate|"));
		eraseInstance();
		return;
	}
	// closest to the roof
	bmWall = beamsHor[0];
	bmWall.envelopeBody().vis(6);
	// collect all beams in same axis
	bmWalls.append(bmWall);
	ppBmWalls.unionWith(bmWall.envelopeBody().shadowProfile(Plane(ptOrg0, vecY0)));
	// all horizontal in same axis with bmWall
	PlaneProfile ppBmWallsVert(Plane(ptOrg0, vecZ0));
	// vertical profile of top beams
	ppBmWallsVert.unionWith(bmWall.envelopeBody().shadowProfile(Plane(ptOrg0, vecZ0)));
	
	for (int i=0;i<beamsHor.length();i++) 
	{ 
		if((Line(bmWall.ptCen(),bmWall.vecX()).closestPointTo(beamsHor[i].ptCen())-beamsHor[i].ptCen()).length()<dEps)
		{ 
			// all horizontal beams in same axis with the most top beam
			if(bmWalls.find(beamsHor[i])<0)
			{
				bmWalls.append(beamsHor[i]);
				ppBmWalls.unionWith(beamsHor[i].envelopeBody().shadowProfile(Plane(ptOrg0, vecY0)));
				ppBmWallsVert.unionWith(beamsHor[i].envelopeBody().shadowProfile(Plane(ptOrg0, vecZ0)));
			}
		}
	}//next i
	
	for (int i=bmStuds.length()-1; i>=0 ; i--) 
	{ 
		PlaneProfile ppStudVert = bmStuds[i].envelopeBody().shadowProfile(Plane(ptOrg0, vecZ0));
		ppStudVert.shrink(-5*dEps);
		
		PlaneProfile ppStud = bmStuds[i].envelopeBody().shadowProfile(Plane(ptOrg0, vecY0));
		
		if(!ppStudVert.intersectWith(ppBmWallsVert) || !ppStud.intersectWith(ppBmWalls))
		{ 
			bmStuds.removeAt(i);
			continue;
		}
		else
		{
			PlaneProfile ppI = bmStuds[i].envelopeBody().shadowProfile(Plane(ptOrg0, vecY0));
			ppI.shrink(-dDistaceStud);
			ppStuds.unionWith(ppI);
		}
	}//next i
}
ppBmWalls.shrink(-U(100));
ppBmWalls.shrink(U(100));
ppBmWalls.vis(1);
// for each ring do the distribution
ppStuds.vis(5);

Beam bmRoof;
Beam bmRoofs[0];
PlaneProfile ppBmRoofs(Plane(ptOrg0, vecY0));
{ 
	Beam beamsRoof[] = el1.beam();
	Beam beamsDirWall[] = vecX0.filterBeamsParallel(beamsRoof);
	if(beamsDirWall.length()==0)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|no roof beam in wall direction, connection not possible|"));
		eraseInstance();
		return;
	}
	for (int i=0;i<beamsDirWall.length();i++) 
	{ 
		PlaneProfile ppI = beamsDirWall[i].envelopeBody().shadowProfile(Plane(ptOrg0, vecY0));
		PlaneProfile ppIntersect = ppI;
		if(ppIntersect.intersectWith(ppBmWalls))
		{ 
			if (bmRoofs.find(beamsDirWall[i]) < 0)
			{
				bmRoofs.append(beamsDirWall[i]);
				ppBmRoofs.unionWith(beamsDirWall[i].envelopeBody().shadowProfile(Plane(ptOrg0, vecY0)));
			}
		}
	}//next i
}

// get all tools and planeprofiles
AnalysedTool aTools[0];
for (int i=0;i<bmWalls.length();i++) 
{ 
	AnalysedTool aToolsI[] = bmWalls[i].analysedTools();
	aTools.append(aToolsI);
//	for (int ii=0;ii<aToolsI.length();ii++) 
//	{ 
//		if(aTools.find(aToolsI[ii])<0)
//			aTools.append(aToolsI[ii]);
//	}//next ii
}//next i
for (int i=0;i<bmRoofs.length();i++) 
{ 
	AnalysedTool aToolsI[] = bmRoofs[i].analysedTools();
	aTools.append(aToolsI);
//	for (int ii=0;ii<aToolsI.length();ii++) 
//	{ 
//		if(aTools.find(aToolsI[ii])<0)
//			aTools.append(aToolsI[ii]);
//	}//next ii
}//next i
AnalysedBeamCut beamcuts[] = AnalysedBeamCut().filterToolsOfToolType(aTools);
AnalysedMortise mortises[] = AnalysedMortise().filterToolsOfToolType(aTools);
AnalysedDrill drills[] = AnalysedDrill().filterToolsOfToolType(aTools);
PlaneProfile ppTools(Plane(ptOrg0, vecY0));
PLine plTools[0];
for (int i=0;i<beamcuts.length();i++) 
{ 
	Body bdI = beamcuts[i].cuttingBody();
	bdI.vis(3);
	PlaneProfile ppI = bdI.shadowProfile(Plane(ptOrg0, vecY0));
	// get extents of profile
	LineSeg seg = ppI.extentInDir(vecX0);
	double dX = abs(vecX0.dotProduct(seg.ptStart()-seg.ptEnd()));
	double dY = abs(vecX0.dotProduct(seg.ptStart()-seg.ptEnd()));
	
	PLine plI;
	plI.createRectangle(LineSeg(seg.ptMid() - vecX0 * .5 * dX - U(10e3) * vecZ0, seg.ptMid() + vecX0 * .5 * dX + U(10e3) * vecZ0), vecX0, vecZ0);
	plTools.append(plI);
	PlaneProfile ppToolI(Plane(ptOrg0, vecY0));
	ppToolI.joinRing(plI, _kAdd);
	ppToolI.shrink(-dDistanceTooling);
	ppTools.unionWith(ppToolI);
}//next i
for (int i=0;i<mortises.length();i++) 
{ 
	Body bdI = mortises[i].cuttingBody();
	bdI.vis(3);
	
	PlaneProfile ppI = bdI.shadowProfile(Plane(ptOrg0, vecY0));
	// get extents of profile
	LineSeg seg = ppI.extentInDir(vecX0);
	double dX = abs(vecX0.dotProduct(seg.ptStart()-seg.ptEnd()));
	double dY = abs(vecX0.dotProduct(seg.ptStart()-seg.ptEnd()));
	
	PLine plI;
	plI.createRectangle(LineSeg(seg.ptMid() - vecX0 * .5 * dX - U(10e3) * vecZ0, seg.ptMid() + vecX0 * .5 * dX + U(10e3) * vecZ0), vecX0, vecZ0);
	plTools.append(plI);
	PlaneProfile ppToolI(Plane(ptOrg0, vecY0));
	ppToolI.joinRing(plI, _kAdd);
	ppToolI.shrink(-dDistanceTooling);
	ppTools.unionWith(ppToolI);
}//next i
for (int i=0;i<drills.length();i++) 
{ 
	Body bdI(drills[i].ptStartExtreme(), drills[i].ptEndExtreme(), drills[i].dRadius());
	bdI.vis(3);
	PlaneProfile ppI = bdI.shadowProfile(Plane(ptOrg0, vecY0));
	// get extents of profile
	LineSeg seg = ppI.extentInDir(vecX0);
	double dX = abs(vecX0.dotProduct(seg.ptStart()-seg.ptEnd()));
	double dY = abs(vecX0.dotProduct(seg.ptStart()-seg.ptEnd()));
	
	PLine plI;
	plI.createRectangle(LineSeg(seg.ptMid() - vecX0 * .5 * dX - U(10e3) * vecZ0, seg.ptMid() + vecX0 * .5 * dX + U(10e3) * vecZ0), vecX0, vecZ0);
	plTools.append(plI);
	PlaneProfile ppToolI(Plane(ptOrg0, vecY0));
	ppToolI.joinRing(plI, _kAdd);
	ppToolI.shrink(-dDistanceTooling);
	ppTools.unionWith(ppToolI);
}//next i
//ppTools.transformBy(vecY0 * U(400));
//ppTools.vis(5);

for (int i=0;i<bmRoofs.length();i++) 
{ 
	bmRoofs[i].envelopeBody().vis(1); 
}//next i
//ppBmRoofs.vis(3);
PlaneProfile ppCommon = ppBmWalls;
ppCommon.intersectWith(ppBmRoofs);
ppCommon.vis(3);

PlaneProfile ppRanges = ppCommon;
PlaneProfile ppStudsExtended = ppStuds;
//ppStudsExtended.shrink(-dDistaceStud);
ppRanges.subtractProfile(ppStudsExtended);
ppRanges.subtractProfile(ppTools);
ppRanges.transformBy(vecY0 * U(200));
ppRanges.vis(2);
ppRanges.transformBy(vecY0 * -U(200));

PLine plRanges[] = ppRanges.allRings(true, false);
int iNrRanges = plRanges.length();
double dLengthRanges;
// sort plRanges
// order alphabetically
Vector3d vecDir = vecX0;
for (int i=0;i<plRanges.length();i++) 
{
	for (int j=0;j<plRanges.length()-1;j++) 
	{ 
		PlaneProfile ppJ(ppRanges.coordSys());
		PlaneProfile ppJ1(ppRanges.coordSys());
		
	// get extents of profile
		ppJ.joinRing(plRanges[j], _kAdd);
		LineSeg segJ = ppJ.extentInDir(vecDir);
		ppJ1.joinRing(plRanges[j+1], _kAdd);
		LineSeg segJ1 = ppJ1.extentInDir(vecDir);
		
		
		if (vecDir.dotProduct(segJ.ptMid()-segJ1.ptMid())>0)
		{
			plRanges.swap(j, j + 1);
		}
	}
}
Point3d ptStartRanges, ptEndRanges;
{ 
	LineSeg seg = ppRanges.extentInDir(vecX0);
	double dX = abs(vecZ0.dotProduct(seg.ptStart()-seg.ptEnd()));
	double dY = abs(vecX0.dotProduct(seg.ptStart()-seg.ptEnd()));
	dLengthRanges = dY;
	ptStartRanges = seg.ptMid() - vecX0 * .5 * dY;
	ptEndRanges = seg.ptMid() + vecX0 * .5 * dY;
}
ptStartRanges.vis(1);
ptEndRanges.vis(1);
if(dDistanceBetween+dDistanceTop>dLengthRanges)
{ 
	reportMessage("\n"+scriptName()+" "+T("|no distribution possible|"));
	return;
}
double dPartLength = U(0);
Point3d ptsDis[0];
if(vecDir.dotProduct(ptEndRanges-(ptStartRanges + vecDir * (dDistanceBottom + dPartLength / 2)))<0)
{ 
	// not possible 
	reportMessage("\n"+scriptName()+" "+T("|Distribution not possible|"));
	return;
}
double dDistTotRanges = vecDir.dotProduct((ptEndRanges - vecDir * dDistanceTop) - (ptStartRanges + vecDir * dDistanceBottom));
	
// total distance for valid regions where distribution is placed no studs7
double dDistTotRangesValid;
PlaneProfile ppRangesValid;
{ 
	ppRangesValid = ppRanges;
	PlaneProfile ppStart(ppRanges.coordSys());
	PlaneProfile ppEnd(ppRanges.coordSys());
	PLine plStart(ppRanges.coordSys().vecZ());
	plStart.createRectangle(LineSeg(ptStartRanges - vecZ0 * U(10e3), ptStartRanges + vecDir * dDistanceBottom + vecZ0 * U(10e3)), vecX0, vecZ0);
	ppStart.joinRing(plStart, _kAdd);
	PLine plEnd(ppRanges.coordSys().vecZ());
	plEnd.createRectangle(LineSeg(ptEndRanges - vecZ0 * U(10e3)- vecDir * dDistanceTop, ptEndRanges  + vecZ0 * U(10e3)), vecX0, vecZ0);
	ppEnd.joinRing(plEnd, _kAdd);
	ppRangesValid.joinRing(plStart, _kSubtract);
	ppRangesValid.joinRing(plEnd, _kSubtract);
}
PLine plRangesValid[] = ppRangesValid.allRings(true, false);
for (int i=0;i<plRangesValid.length();i++) 
{ 
	PLine plI = plRanges[i];
	PlaneProfile ppI(ppRanges.coordSys());
	ppI.joinRing(plI, _kAdd);
	LineSeg seg = ppI.extentInDir(vecX0);
	double dY = abs(vecX0.dotProduct(seg.ptStart() - seg.ptEnd()));
	dDistTotRangesValid += dY;
}//next i
dDistTotRangesValid -= dDistanceBottom;
dDistTotRangesValid -= dDistanceTop;

int iDistributionArea = sDistributionAreas.find(sDistributionArea);
int iModeDistribution = sModeDistributions.find(sModeDistribution);

if(iDistributionArea==0)
{ 
	// continuous
	LineSeg seg = ppRanges.extentInDir(vecX0);
	double dX = abs(vecZ0.dotProduct(seg.ptStart() - seg.ptEnd()));
	double dY = abs(vecX0.dotProduct(seg.ptStart() - seg.ptEnd()));
	Point3d ptStart = seg.ptMid() - vecX0 * .5 * dY;
	Point3d ptEnd = seg.ptMid() + vecX0 * .5 * dY;
	double dLengthTot = dY;
	
	Point3d pt1 = ptStartRanges + vecDir * dDistanceBottom;
	if (vecDir.dotProduct(ptStart - pt1) > 0)
	{
		pt1 = ptStart;
	}
	Point3d pt2 = ptEndRanges - vecDir * (dDistanceTop + dPartLength);
	if (vecDir.dotProduct(pt2 - ptEnd) > 0)
	{
		pt2 = ptEnd;
	}
	
	double dDistTot = (pt2 - pt1).dotProduct(vecDir);
//	if (vecDir.dotProduct(pt2 - pt1) <= 0)
//	{
//		continue;
//	}
	if(iModeDistribution==0)
	{ 
		double dDistMod = dDistanceBetween + dPartLength;
		int iNrParts = dDistTot / dDistMod;
		
		double dNrParts = dDistTot / dDistMod;
		if (dNrParts - iNrParts > 0)iNrParts += 1;
		double dDistModCalc = 0;
		if (iNrParts != 0)
			dDistModCalc = dDistTot / iNrParts;
		
		Point3d pt;
		pt = pt1 + vecDir * (dPartLength / 2);
		
	//	ptsDisI.append(pt);
		ptsDis.append(pt);
		if (dDistModCalc > 0)
		{
			for (int i = 0; i < iNrParts; i++)
			{
				pt += vecDir * dDistModCalc;
				if (ppRanges.pointInProfile(pt) != _kPointInProfile)
					continue;
				//					pt.vis(1);
	//			ptsDisI.append(pt);
				ptsDis.append(pt);
			}
		}
		dDistanceBetweenResult.set(dDistModCalc - dPartLength);
		nNrResult.set(ptsDis.length());
	}
	else if(iModeDistribution==1)
	{ 
		// fixed
		double dDistMod = dDistanceBetween + dPartLength;
		int iNrParts = dDistTot / dDistMod;
		double dDistModCalc = 0;
		dDistModCalc = dDistMod;
		// first point
		Point3d pt;
		pt = pt1 + vecDir * (dDistanceBottom + dPartLength / 2);
		ptsDis.append(pt);
		if(dDistModCalc>0)
		{ 
			for (int i = 0; i < iNrParts; i++)
			{ 
				pt += vecDir * dDistModCalc;
				if (ppRanges.pointInProfile(pt) != _kPointInProfile)
					continue;
	//					pt.vis(1);
				ptsDis.append(pt);
			}
		}
		// last
		ptsDis.append(pt2- vecDir * (dDistanceTop + dPartLength / 2));
		dDistanceBetweenResult.set(dDistModCalc-dPartLength);
		nNrResult.set(ptsDis.length());
	}
}
else if(iDistributionArea==1)
{ 
	// separately
	if(dDistanceBetween>=0)
	{ 
		for (int i = 0; i < plRanges.length(); i++)
		{
			Point3d ptsDisI[0];
			PLine plI = plRanges[i];
			PlaneProfile ppI(ppRanges.coordSys());
			ppI.joinRing(plI, _kAdd);
			// get extents of profile
			LineSeg seg = ppI.extentInDir(vecX0);
			//	vecDir.vis(_Pt0);
			double dX = abs(vecZ0.dotProduct(seg.ptStart() - seg.ptEnd()));
			double dY = abs(vecX0.dotProduct(seg.ptStart() - seg.ptEnd()));
			
			if (dY <= 0)
			{
				continue;
			}
			
			// start end for the current range I
			Point3d ptStart = seg.ptMid() - vecX0 * .5 * dY;
			Point3d ptEnd = seg.ptMid() + vecX0 * .5 * dY;
			double dLengthTot = dY;
			
			Point3d pt1 = ptStartRanges + vecDir * dDistanceBottom;
			if (vecDir.dotProduct(ptStart - pt1) > 0)
			{
				pt1 = ptStart;
			}
			Point3d pt2 = ptEndRanges - vecDir * (dDistanceTop + dPartLength);
			if (vecDir.dotProduct(pt2 - ptEnd) > 0)
			{
				pt2 = ptEnd;
			}
			pt1.vis(1);
			pt2.vis(4);
			
			double dDistTot = (pt2 - pt1).dotProduct(vecDir);
			if (vecDir.dotProduct(pt2 - pt1) <= 0)
			{
				continue;
			}
			if(iModeDistribution==0)
			{ 
				// equal
				double dDistMod = dDistanceBetween + dPartLength;
				int iNrParts = dDistTot / dDistMod;
				
				double dNrParts = dDistTot / dDistMod;
				if (dNrParts - iNrParts > 0)iNrParts += 1;
				double dDistModCalc = 0;
				if (iNrParts != 0)
					dDistModCalc = dDistTot / iNrParts;
				
				Point3d pt;
				pt = pt1 + vecDir * (dPartLength / 2);
				ptsDisI.append(pt);
				ptsDis.append(pt);
				if (dDistModCalc > 0)
				{
					for (int i = 0; i < iNrParts; i++)
					{
						pt += vecDir * dDistModCalc;
						//					pt.vis(1);
						if (ppRanges.pointInProfile(pt) != _kPointInProfile)
							continue;
						ptsDisI.append(pt);
						ptsDis.append(pt);
					}
				}
				dDistanceBetweenResult.set(dDistModCalc - dPartLength);
				nNrResult.set(ptsDis.length());
			}
			else if(iModeDistribution==1)
			{ 
				// fixed
				double dDistMod = dDistanceBetween + dPartLength;
				int iNrParts = dDistTot / dDistMod;
				double dDistModCalc = 0;
				dDistModCalc = dDistMod;
				// first point
				Point3d pt;
				pt = pt1 + vecDir * (dDistanceBottom + dPartLength / 2);
				ptsDis.append(pt);
				if(dDistModCalc>0)
				{ 
					for (int i = 0; i < iNrParts; i++)
					{ 
						pt += vecDir * dDistModCalc;
							if (ppRanges.pointInProfile(pt) != _kPointInProfile)
								continue;
			//					pt.vis(1);
						ptsDis.append(pt);
					}
				}
				// last
				ptsDis.append(pt2- vecDir * (dDistanceTop + dPartLength / 2));
				dDistanceBetweenResult.set(dDistModCalc-dPartLength);
				nNrResult.set(ptsDis.length());
			}
		}
	}
//	else
//	{
//		double dDistModCalc;
//		int nNrPartsRanges = -dDistanceBetween / 1;
//		double dDistTotProgressive;
//		int nNrPartsProgressive;
//		for (int i = 0; i < plRanges.length(); i++)
//		{
//			Point3d ptsDisI[0];
//			PLine plI = plRanges[i];
//			PlaneProfile ppI(ppRanges.coordSys());
//			ppI.joinRing(plI, _kAdd);
//			// get extents of profile
//			LineSeg seg = ppI.extentInDir(vecX0);
//			Vector3d vecDir = vecX0;
//			//	vecDir.vis(_Pt0);
//			double dX = abs(vecZ0.dotProduct(seg.ptStart() - seg.ptEnd()));
//			double dY = abs(vecX0.dotProduct(seg.ptStart() - seg.ptEnd()));
//			
//			if (dY <= 0)
//			{
//				continue;
//			}
//			
//			Point3d ptStart = seg.ptMid() - vecX0 * .5 * dY;
//			Point3d ptEnd = seg.ptMid() + vecX0 * .5 * dY;
//			double dLengthTot = dY;
//			
//			Point3d pt1 = ptStartRanges + vecDir * dDistanceBottom;
//			if (vecDir.dotProduct(ptStart - pt1) > 0)
//			{
//				pt1 = ptStart;
//			}
//			Point3d pt2 = ptEndRanges - vecDir * (dDistanceTop + dPartLength);
//			if (vecDir.dotProduct(pt2 - ptEnd) > 0)
//			{
//				pt2 = ptEnd;
//			}
//			pt1.vis(1);
//			pt2.vis(4);
//			double dDistTot = (pt2 - pt1).dotProduct(vecDir);
//			if (vecDir.dotProduct(pt2 - pt1) <= 0)
//			{
//				continue;
//			}
//			
//			dDistTotProgressive = dDistTotProgressive + dDistTot;
//			int nNrPartsProgressiveI = (dDistTotProgressive / dDistTotRangesValid)*nNrPartsRanges;
//			int nNrParts = nNrPartsProgressiveI - nNrPartsProgressive;
//			
//			if(nNrParts<2)
//			{ 
//				nNrParts=2;
//			}
//			nNrPartsProgressive += nNrParts;
//			double dDistMod = dDistTot / (nNrParts - 1);
//			dDistModCalc = dDistMod;
//			int nNrPartsCalc = nNrParts;
//			double dDistBet = dDistMod - dPartLength;
//			if (dDistBet < 0)
//			{ 
//				// distance between 2 subsequent parts < 0
//				// minimum allowed distance is dPartLength
//				dDistModCalc = dPartLength;
//				// nr of parts in between 
//				nNrPartsCalc = dDistTot / dDistModCalc;
//				nNrPartsCalc += 1;
//			}
//			// first point
//			Point3d pt;
//			pt = pt1 + vecDir * (dPartLength / 2);
//			ptsDisI.append(pt);
//			ptsDis.append(pt);
//			if (dDistModCalc > 0)
//			{
//				for (int i = 0; i < (nNrPartsCalc - 1); i++)
//				{
//					pt += vecDir * dDistModCalc;
//					//					pt.vis(1);
//					ptsDisI.append(pt);
//					ptsDis.append(pt);
//				}
//			}
//		}
//	}
}
if(sDirections.find(sDirection)==0)
	_ThisInst.assignToElementGroup(el0,true,0,'T');
else
	_ThisInst.assignToElementGroup(el1,true,0,'T');

Vector3d vecNail;
// 
nNrResult.set(ptsDis.length());
dDistanceBetweenResult.set((dDistTotRanges));
if(nNrResult>1)dDistanceBetweenResult.set((dDistTotRanges/(nNrResult-1)));
//vecYwallRoof
// draw distribution
Display dp(7);
for (int i=0;i<ptsDis.length();i++) 
{ 
	Point3d pt = ptsDis[i];
	// beam where nail is applied
	Beam bmPlate;
	if (sDirections.find(sDirection) == 0)
	{
		// wall roof
		Beam beamsIntersect[] = Beam().filterBeamsHalfLineIntersectSort(bmWalls, pt - U(10e4) * vecYwallRoof, vecYwallRoof);
		if (beamsIntersect.length() == 0)continue;
		
		Beam bmIntersect = beamsIntersect[0];
		bmPlate = bmIntersect;
		LineBeamIntersect lBi(pt - U(10e4) * vecYwallRoof, vecYwallRoof, bmIntersect);
		pt = lBi.pt1();
		vecNail = vecYwallRoof;
	}
	else if (sDirections.find(sDirection) == 1)
	{
		// roof-wall
		Beam beamsIntersect[] = Beam().filterBeamsHalfLineIntersectSort(bmRoofs, pt + U(10e4) * vecYwallRoof, -vecYwallRoof);
		if (beamsIntersect.length() == 0)continue;
		
		Beam bmIntersect = beamsIntersect[0];
		bmPlate = bmIntersect;
		LineBeamIntersect lBi(pt + U(10e4) * vecYwallRoof, -vecYwallRoof, bmIntersect);
		pt = lBi.pt1();
		vecNail = -vecYwallRoof;
	}
	
	
	PLine pl(vecY0);
//					pl.createCircle(pt, vecZ1, dPartLength / 2);
	pl.createCircle(pt, vecZ1, U(5));
	dp.draw(pl);
	
	PLine plNail1(pt, pt + vecNail * U(90));
	dp.draw(plNail1);
	PLine plNail2(pt - vecY0 * U(10), pt + vecY0 * U(10));
	dp.draw(plNail2);
	Vector3d vecZnail = vecNail.crossProduct(vecY0);
	PLine plNail3(pt - vecZnail * U(10), pt + vecZnail * U(10));
	dp.draw(plNail3);
	// 
	String ToolIndexKey = "ToolIndex";
	String StartPointKey = "StartPoint";
	String EndPointKey = "EndPoint";
	String MaleBeamHandleKey = "MaleBeamHandle";
	String FemaleBeamHandleKey = "FemaleBeamHandle";
	
	
//		Map itemMap = Map();
//		itemMap.setInt("INDEX",prIndexes);
	
	Map mapCncExportSteelTool;
	mapCncExportSteelTool.setInt(ToolIndexKey, nNailIndex);
	mapCncExportSteelTool.setPoint3d(StartPointKey, pt);
	mapCncExportSteelTool.setPoint3d(EndPointKey, pt + vecNail * U(90));
	mapCncExportSteelTool.setEntity(FemaleBeamHandleKey, bmPlate);
	CncExport cncExportSteelTool("FrameNailTool", mapCncExportSteelTool);
	bmPlate.addTool(cncExportSteelTool);
}//next i

// Trigger Swap Direction//region
String sTriggerSwapDirection = T("|Swap Direction|");
addRecalcTrigger(_kContextRoot, sTriggerSwapDirection );
if (_bOnRecalc && (_kExecuteKey==sTriggerSwapDirection || _kExecuteKey==sDoubleClick))
{
	if(sDirections.find(sDirection)==0)
		sDirection.set(sDirections[1]);
	else if(sDirections.find(sDirection)==1)
		sDirection.set(sDirections[0]);
		
	setExecutionLoops(2);
	return;
}//endregion
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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End