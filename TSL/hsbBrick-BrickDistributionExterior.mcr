#Version 8
#BeginDescription
version value="2.14" date="02oct2020" author="marsel.nakuci@hsbcad.com"
 
HSB-9023: After 3 attempts if the distribution region is very small, delete the TSL
HSB-5503 fix bug at calculation of wall angle dRotation
cosmetic
read the posnum and write it in description in hardware
shrink and extend ppfacade and ppopening to correct calculation
recalculate hsbBrick-3dBricks each time the TSL is modified
add command to generate 3d bricks
fix gap when grip point moves right
fix bug stich not at the middle of brick when different joint width for different distributions 
change name
add grip point to shift distribution for all facade
change TSL name and make it only for external distribution

add grip points at internal walls for correcting horizontal distribution
include case if Width>.5*(Length-jointMin)
add custom command generate/delete special bricks
generation of special bricks
workaround for PlaneProfile bug
some bug fixes + calculation at corners according to HSBCAD-381

considering all possible scenarios in the buttJoint calculation
calculation considering corners
include some messages when calculation not possible
dependency to next distribution set 
calculation of brick distribution changed

This tsl calculates and generates brick distribution for external walls.
It is usually called by the hsbBrick-CourseDistribution
It takes from this TSL the vertical distribution and the brick family
The overall facade will be divided into distribution areas
It will generate 1 TSL instance for each distribution area
Distribution areas are defined between 
start/end walls and start/end opening or between
start/end opening with end/start of another opening or 
between start and end of an opening
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 14
#KeyWords brick, distribution, joint, butt, micasa, mortar, exterior, wall
#BeginContents
/// <History>//region
/// <version value="2.14" date="02oct2020" author="marsel.nakuci@hsbcad.com"> HSB-9023: After 3 attempts if the distribution region is very small, delete the TSL </version>
/// <version value="2.13" date="19.08.2019" author="marsel.nakuci@hsbcad.com"> HSB-5503 fix bug at calculation of wall angle dRotation </version>
/// <version value="2.12" date="14jun2019" author="marsel.nakuci@hsbcad.com"> cosmetic </version>
/// <version value="2.11" date="14jun2019" author="marsel.nakuci@hsbcad.com"> read the posnum and write it in description in hardware </version>
/// <version value="2.10" date="11jun2019" author="marsel.nakuci@hsbcad.com"> shrink and extend ppfacade and ppopening to correct calculation </version>
/// <version value="2.9" date="03jun2019" author="marsel.nakuci@hsbcad.com"> recalculate hsbBrick-3dBricks each time the TSL is modified </version>
/// <version value="2.8" date="30may2019" author="marsel.nakuci@hsbcad.com"> add command to generate 3d bricks </version>
/// <version value="2.7" date="27may2019" author="marsel.nakuci@hsbcad.com"> fix gap when grip point moves right </version>
/// <version value="2.6" date="06may2019" author="marsel.nakuci@hsbcad.com"> fix bug stich not at the middle of brick when different joint width for different distributions </version>
/// <version value="2.5" date="03may2019" author="marsel.nakuci@hsbcad.com"> change name </version>
/// <version value="2.4" date="14apr2019" author="marsel.nakuci@hsbcad.com"> add grip point to shift distribution for all facade </version>
/// <version value="2.3" date="01apr2019" author="marsel.nakuci@hsbcad.com"> change TSL name and make it only for exterior distribution </version>
/// <version value="2.2" date="18mar2019" author="marsel.nakuci@hsbcad.com"> add grip points at internal walls for correcting horizontal distribution </version>
/// <version value="2.1" date="17mar2019" author="marsel.nakuci@hsbcad.com"> include case if Width>.5*(Length-jointMin) </version>
/// <version value="2.0" date="12mar2019" author="marsel.nakuci@hsbcad.com"> add custom command generate/delete special bricks </version>
/// <version value="1.9" date="11mar2019" author="marsel.nakuci@hsbcad.com"> generation of special bricks </version>
/// <version value="1.8" date="07mar2019" author="marsel.nakuci@hsbcad.com"> workaround for PlaneProfile bug </version>
/// <version value="1.7" date="25feb2019" author="marsel.nakuci@hsbcad.com"> some bug fixes + calculation at corners according to HSBCAD-381 </version>
/// <version value="1.6" date="21feb2019" author="marsel.nakuci@hsbcad.com"> considering all possible scenarios in the buttJoint calculation </version>
/// <version value="1.5" date="20feb2019" author="marsel.nakuci@hsbcad.com"> calculation considering corners </version>
/// <version value="1.4" date="18feb2019" author="marsel.nakuci@hsbcad.com"> include some messages when calculation not possible </version>
/// <version value="1.3" date="18feb2019" author="thorsten.huck@hsbcad.com"> dependency to next distribution set  </version>
/// <version value="1.2" date="16feb2019" author="marsel.nakuci@hsbcad.com"> calculation of brick distribution changed </version>
/// <version value="1.1" date="20jan2019" author="anno.sportel@hsbcad.com"> merged with hsbBrick-Facade </version>
/// <version value="1.0" date="18jan2019" author="thorsten.huck@hsbcad.com"> initial </version>

/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl calculates and generates brick distribution for exterior walls.
/// It is usually called by the hsbBrick-CourseDistribution
/// It takes from this TSL the vertical distribution and the brick family
/// The overall facade will be divided into distribution areas
/// It will generate 1 TSL instance for each distribution area
/// Distribution areas are defined between 
/// start/end walls and start/end opening or between
/// start/end opening with end/start of another opening or 
/// between start and end of an opening
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbBrick-BrickDistributionExterior")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion

//region constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end constants//endregion

//region Properties
	category = T("|Mortar Butt Joint|");
	String sButtJointMinName=T("|Minimum|");	
	PropDouble dButtJointMin(nDoubleIndex++, U(9), sButtJointMinName);	
	dButtJointMin.setDescription(T("|Defines the minmal butt joint|"));
	dButtJointMin.setCategory(category);
	
	String sButtJointMaxName=T("|Maximum|");	
	PropDouble dButtJointMax(nDoubleIndex++, U(15), sButtJointMaxName);	
	dButtJointMax.setDescription(T("|Defines the maximal butt joint|"));
	dButtJointMax.setCategory(category);
	
	String sButtJointPropName=T("|calculated|");	
	PropDouble dButtJointProp(nDoubleIndex++, U(0), sButtJointPropName);	
	dButtJointProp.setDescription(T("|The calculated Butt Joint|"));
	dButtJointProp.setCategory(category);
	dButtJointProp.setReadOnly(true);
//End Properties//endregion
	
//region ptRefBuilding for the whole course distribution
	
  // reference point common for all distributions
    Point3d ptRefBuilding;
//End ptRefBuilding for the whole course distribution//endregion
	
// bOnInsert//region
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		
		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);
		}
		else
			showDialog();
			
	// prompt for elements
		PrEntity ssE(T("|Select element(s)|"), ElementWall());
	  	if (ssE.go())
			_Element.append(ssE.elementSet());
			
	// prompt for courseJoint distribution
		TslInst tsl = getTslInst(T("|Select course distribution|"));
		Map mapX = tsl.subMapX("hsbBrickData");
		if (mapX.length()<1)
		{ 
			reportMessage("\n" + T("|Invalid tsl instance has no brick data.|"));
			eraseInstance();
			return;
		}
		_Entity.append(tsl);
		
		eraseInstance();
		return;
	}
// end on insert	__________________//endregion

//region some debug feature
	if (bDebug)
	{
		// Trigger Add PLine//region
		String sTriggerAddPLine = T("|AddPLine|");
		addRecalcTrigger(_kContext, sTriggerAddPLine );
		if (_bOnRecalc && (_kExecuteKey==sTriggerAddPLine || _kExecuteKey==sDoubleClick))
		{
			_Entity.append(getEntPLine());
			setExecutionLoops(2);
			return;
		}//endregion
	}
	
//End some debug feature//endregion
	
//region in case not valid elements

	// purge invalid elements
	for (int i=_Element.length()-1; i>=0 ; i--)
	{ 
		if (!_Element[i].bIsKindOf(ElementWall()))
			_Element.removeAt(i);
	}//next i	

//End in case not valid elements//endregion 
	
//region get data from course distribution, dButtJointMin, dButtJointMax, ptRefBuilding

// get brick course distribution from entity
	PLine debugPLine;
	
	TslInst tslCourse;
	Map mapFamily, mapX;
	int nZone;
	double dButtJointMinMapx, dButtJointMaxMapx;
	for (int i=0;i<_Entity.length();i++) 
	{
		TslInst _tslCourse = (TslInst)_Entity[i]; 
		if (_tslCourse.bIsValid())
		{
		// get and validate family data
			mapX = _tslCourse.subMapX("hsbBrickData");
			mapFamily = mapX.getMap("Family");
			if (mapFamily.length() < 1)continue;
			
			tslCourse = _tslCourse;
			setDependencyOnEntity(tslCourse);
			nZone = tslCourse.propInt(T("|Zone|"));
			dButtJointMinMapx = mapX.getDouble("dButtJointMin");// needed to set property in mode = 0
//			dButtJointMin.set(dButtJointMinMapx);
			dButtJointMaxMapx = mapX.getDouble("dButtJointMax");// needed to set property in mode = 0
//			dButtJointMax.set(dButtJointMaxMapx);
			Point3d ptRefBuildingMapx = mapX.getPoint3d("ptRefBuilding");
			ptRefBuilding = ptRefBuildingMapx;
			if (!bDebug) break;
		}
		else if (_Entity[i].bIsKindOf(EntPLine()))
		{
			debugPLine = ((EntPLine)_Entity[i]).getPLine();
		}
	}		
//End get data from course distribution//endregion 

//region get the necessary data from mapFamily: nColorBrick, dLength, dWidth, dHeight, sFamily
// get brick data
	int nColorBrick = 3;
	double dLength = U(188), dWidth=U(88), dHeight=U(48);
	String sFamily;
	{
		String k;
		Map m = mapFamily;
		k = "Color";	if (m.hasInt(k))	nColorBrick = m.getInt(k);
		k = "Length";	if (m.hasDouble(k))	dLength = m.getDouble(k);
		k = "Width";	if (m.hasDouble(k))	dWidth = m.getDouble(k);
		k = "Height";	if (m.hasDouble(k))	dHeight = m.getDouble(k);
		k = "Name";		if (m.hasString(k))	sFamily = m.getString(k);
		if (dLength<dEps || dWidth < dEps || dHeight<dEps)
		{ 
			reportMessage("\n" + T("|Invalid brick sizes of family| ") + sFamily);
			eraseInstance();
			return;			
		}
	}
//End get the necessary data from mapFamily: nColorBrick, dLength, dWidth, dHeight, sFamily//endregion

	
//region some error handling
// validate course distribution
	if (!tslCourse.bIsValid())
	{
		reportMessage("\n" + scriptName() + ": " +T("|no valid course distribution found|"));
		eraseInstance();
		return;
	}
	
// validate selection set
	if (_Element.length()<1 || !_Element[0].bIsKindOf(ElementWall()))
	{
		reportMessage("\n" + scriptName() + " " + T("|could not find reference to element.|"));
		eraseInstance();
		return;
	}			
//End some error handling//endregion 


//region order elements in ZW from the bottom to top
	for (int i=0;i<_Element.length();i++) 
		for (int j=0;j<_Element.length()-1;j++) 
			if (_ZW.dotProduct(_Element[j].ptOrg())>_ZW.dotProduct(_Element[j+1].ptOrg()))
				_Element.swap(j, j + 1);
//endregion	

//region standards, assign distribution to the element group
// standards
	
	ElementWall el = (ElementWall)_Element[0];// element where distribution will be generated
	CoordSys cs =el.coordSys();
	Vector3d vecX = cs.vecX();
	Vector3d vecY = cs.vecY();
	Vector3d vecZ = cs.vecZ();
	Point3d ptOrg = cs.ptOrg();
	
	assignToElementGroup(el, false,0,'E');

	int bExposed = el.exposed();
	CoordSys csZone = el.coordSys(el.zone(nZone).ptOrg());
	Point3d ptZoneOrg = csZone.ptOrg();
	
	ptZoneOrg += vecY*vecY.dotProduct(ptOrg - ptZoneOrg);
	Plane pnZone(ptZoneOrg, vecZ);
//End standards//endregion 
	
	
//region Purge elements, create opening profile and get distributrion points.
// purge elements not in same Z-plane
	PlaneProfile ppOpening(csZone);
	ElementWall elWall = (ElementWall)_Element[0];
	int isExterior = elWall.exposed();
	if ( ! isExterior)
	{ 
	// tsl should be used only for exterior walls
		reportMessage(TN("|This TSL to be used only for exterior walls|"));
		eraseInstance();
		return;
	}
	Point3d ptsOpStart[0], ptsOpEnd[0], ptsEl[0];
	for (int i = _Element.length() - 1; i >= 0; i--)
	{
		Element el2 = _Element[i];
		CoordSys cs2 = el2.coordSys();
		Vector3d vecZ2 = cs2.vecZ();
		Point3d ptOrg2 = cs2.ptOrg();
		if (i!=0 && (!vecZ2.isCodirectionalTo(vecZ) || abs(vecZ.dotProduct(ptOrg2-ptOrg))>dEps))
		{
			_Element.removeAt(i);
		}
		else
		{
			LineSeg seg = el2.segmentMinMax();// wall segment 
			ptsEl.append(seg.ptStart());
			ptsEl.append(seg.ptEnd());
			Vector3d vecX = el.vecX();
			Opening openings[] = el2.opening();
			for (int j = 0; j < openings.length(); j++)
			{
				PlaneProfile pp(csZone);
				pp.joinRing(openings[j].plShape(), _kAdd);
				seg = pp.extentInDir(vecX);// segment of opening
				ptsOpStart.append(seg.ptStart());
				ptsOpEnd.append(seg.ptEnd());
				
				ppOpening.joinRing(openings[j].plShape(), _kAdd);
			}//next j
		}
	}//next i

// order horizontally
	Line lnX(ptZoneOrg, vecX);
	ptsOpStart = lnX.orderPoints(lnX.projectPoints(ptsOpStart), dEps);
	ptsOpEnd = lnX.orderPoints(lnX.projectPoints(ptsOpEnd), dEps);
	ptsEl = lnX.orderPoints(lnX.projectPoints(ptsEl), dEps);
	Point3d ptsOp[0]; ptsOp = ptsOpStart;
	ptsOp.append(ptsOpEnd);
	ptsOp = lnX.orderPoints(ptsOp, dEps);// order points in X
//End relevant points for distribution//endregion 
//End Purge elements, create opening profile and get distributrion points.//endregion 


//region mode 0 Create brick distributions for each distribution _region
	int mode = _Map.getInt("Mode");
	//create first butt distributions during creation
	if (mode == 0)
	{
	// set the initial min max butt joint from the course distribution
		dButtJointMin.set(dButtJointMinMapx);
		dButtJointMax.set(dButtJointMaxMapx);
		
	// create TSL
		TslInst tslNew;
		GenBeam gbsTsl[] = { };		Entity entsTsl[] = { tslCourse};		Point3d ptsTsl[] = {ptZoneOrg};
		int nProps[] ={ };
		double dProps[] ={dButtJointMin, dButtJointMax};
		String sProps[] ={ };
		Map mapTsl;
		mapTsl.setInt("Mode", 1);
		for (int i = 0; i < _Element.length(); i++)
			entsTsl.append(_Element[i]);// every tsl knows about all walls
		tslNew.dbCreate(scriptName() , vecX , vecY, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		if (tslNew.bIsValid())
		{
			tslNew.recalc();
			if (bDebug)reportMessage("\n" + tslNew.handle() + " updated");
		}
		
		// for each distribution generate a TSL
		// openings only considered at exterior walls
		for (int i = 0; i < ptsOp.length(); i++)
		{
			Point3d pt = ptsOp[i];
			// create TSL
			TslInst tslNew;
			ptsTsl[0] = pt;
			
			tslNew.dbCreate(scriptName() , vecX , vecY, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			if (tslNew.bIsValid())
			{
				tslNew.recalc();
				if (bDebug)reportMessage("\n" + tslNew.handle() + " updated");
			}
		}//next i
		eraseInstance();
		return;
	}
//End Create brick distributions//endregion 


// Trigger VARIABLE Generate 3d of special bricks//region
// trigger for the generation of special bricks	
	String sTriggerGenerateSpecialBricks = T("|Generate 3d of special bricks|");
	addRecalcTrigger(_kContext, sTriggerGenerateSpecialBricks );
//endregion


// Trigger generate3dBricks//region
	String sTriggerGenerate3dBricks = T("|Generate 3d Bricks|");
	addRecalcTrigger(_kContext, sTriggerGenerate3dBricks );	
//endregion

	
// Trigger VARIABLE Delete special bricks//region
	String sTriggerDeleteSpecialBricks = T("|Delete 3d of special bricks|");
	addRecalcTrigger(_kContext, sTriggerDeleteSpecialBricks );
//endregion	
	
	
// Trigger VARIABLE Delete 3d bricks//region
	String sTriggerDelete3dBricks = T("|Delete 3d bricks|");
	addRecalcTrigger(_kContext, sTriggerDelete3dBricks );
//endregion	

//region delete 3d/special bricks if triggered by the command
	if (_bOnRecalc && (_kExecuteKey == sTriggerDeleteSpecialBricks || _kExecuteKey == sTriggerDelete3dBricks))
	{
		// delete special bricks
		// delete first the previously generated special bricks
		Group grp();
		Entity arEnt[] = grp.collectEntities(true, TslInst(), _kModelSpace);
		TslInst tsl;
		String sTslName = "hsbBrick-3dBricks";
		
		// loop all collected entities and get those hsbBrick-SpecialBricks
		
		for (int i=arEnt.length()-1; i>=0 ; i--)
		{ 
			TslInst t = (TslInst)arEnt[i];
			
			if(t.scriptName() !=sTslName)
			{ 
				continue;
			}
			Entity ents[] = t.entity();
			for (int j=0;j<ents.length();j++) 
			{ 
				TslInst tt = (TslInst)ents[j];
				if(tt==_ThisInst)
				{ 
					// brick belongs to this wall
					String sBrickType = t.propString(0);
					if(_kExecuteKey == sTriggerDeleteSpecialBricks)
					{ 
						//
						if (sBrickType == T("|Special|"))
						{
							arEnt[i].dbErase();
							break;
						}
					}
					else if(_kExecuteKey == sTriggerDelete3dBricks)
					{ 
						//
						if (sBrickType == T("|Regular|"))
						{
							arEnt[i].dbErase();
							break;
						}
					}
				}
			}//next j
		}//next i
		setExecutionLoops(2);
		return;
	}
//End delete 3d/special bricks if triggered by the command//endregion

	
//region get distribution profile and distinguish male/female connection
	PlaneProfile ppFacade(csZone);
	int bIsMaleCorners[2]; // 0 = left end , 1 = right end
	int bIsFemaleCorners[2];
	int bIsEndCorners[2]; // neither male nor female, an end corner
	bIsEndCorners[0] = true;// initialize
	bIsEndCorners[1] = true;// initialize
	// it is important that for a particular facade there should be only 1 wall along its length
	// 1 continuous wall from the begginning until the end
	// if the facade is drawn with more walls in its length the algorithm will fail
	for (int i=0;i<_Element.length();i++)
	{
		ElementWallSF el1 = (ElementWallSF)_Element[i];
		PlaneProfile pp(csZone);
		pp.joinRing(el1.plEnvelope(),_kAdd);//pp.vis(i);	
		
		PLine plOutlineWall = el1.plOutlineWall();
		PlaneProfile ppOutlineWall(plOutlineWall);
		Point3d ptsThis[] = Line(ptOrg, vecX).orderPoints(plOutlineWall.vertexPoints(true));
		LineSeg seg0 = el1.segmentMinMax();// wall segment
		
		ElemZone zone = el1.zone(nZone);//zone.vecZ().vis(zone.ptOrg(),6);
		
	//region loop connected walls
		Element elConnections[] = el1.getConnectedElements();// walls connected to this wall
		
		for (int j=elConnections.length()-1; j>=0 ; j--) 
		{ 
			ElementWallSF el2 = (ElementWallSF)elConnections[j]; // connected wall
			if (!el2.bIsValid() || !el2.vecX().isPerpendicularTo(vecX))// walls not normal are disregarded
			{
				// not valid or not perpendicular
				elConnections.removeAt(j);
				continue;
			}
		//get pline and vertices of secondary wall
			ElemZone zoneOther = el2.zone(nZone);
			PLine plOther = el2.plOutlineWall(); //plOther.vis(2);
			Point3d ptsOther[]=plOther.vertexPoints(true);// vertex points of the pline conture of the other wall 
		
		//region points on the contours
			int nOnThis = 0, nOnOther = 0;
			Point3d ptsOnThis[0], ptsOnOther[0];
			for (int p= 0;p<ptsOther.length();p++)// points at the other wall
			{
				double d = (ptsOther[p]-plOutlineWall.closestPointTo(ptsOther[p])).length();// length of vector
				if(d<dEps)
				{
					ptsOnThis.append(ptsOther[p]);// collect connecting points between 2 walls
					nOnThis++;// count points of wall in el2 that are connected with wall in el1
				}
			}
			for (int p= 0;p<ptsThis.length();p++)// points at this wall
			{
				double d = (ptsThis[p]-plOther.closestPointTo(ptsThis[p])).length();// length of vector
				if(d<dEps)
				{
					ptsOnOther.append(ptsThis[p]);
					nOnOther++;
				}
			}
			
		//End points on the contours//endregion
		
		// corner connections
			int bIsFemale = (nOnThis == 2 && nOnOther == 1);
			int bIsMale = ((nOnThis==1||nOnThis==0) && nOnOther==2);
			int bIsEnd = !(bIsFemale || bIsMale);// end connection no female, no male
			if(!(bIsFemale || bIsMale || bIsEnd))
			{ 
				continue;
			}
			
			Vector3d vecSide = vecX;
			if(vecX.dotProduct(ptsOnOther[0] - seg0.ptMid()) < 0)// left corner
			{
				vecSide *= -1;
				bIsMaleCorners[0] = bIsMale;
				bIsFemaleCorners[0] = bIsFemale;
				bIsEndCorners[0] = bIsEnd;
			}
			else// right corner
			{ 
				bIsMaleCorners[1] = bIsMale;
				bIsFemaleCorners[1] = bIsFemale;
				bIsEndCorners[1] = bIsEnd;
			}
			
			Point3d ptInt;
			
		// For a corner between wall A and B the arrow of wall A should point like the direction of wall B
		// like the vector X0B1 and the arrow of wall B should point like the direction of wall A X0A1.
		// X0 is the intersection between Line(ptStartA) and plane at wall B
		// ptStartA, ptEndA are at the axis of the wall
			// arrow at wall A and B
			Vector3d vecA = -el1.vecZ();
			Vector3d vecB = -el2.vecZ();
			
			Point3d ptStartA = el1.ptStartOutline();
			Point3d ptEndA = el1.ptEndOutline();
			Line lnWallA(ptStartA, vecB);
			Plane plWallA(ptStartA, vecA);
			
			Point3d ptStartB = el2.ptStartOutline();
			Point3d ptEndB = el2.ptEndOutline();
			Line lnWallB(ptStartB, vecA);
			Plane plWallB(ptStartB, vecB);
			
			// intersection of lnWallA with plWallB
			Point3d ptIntersectA;
			int iHasIntersectA = lnWallA.hasIntersection(plWallB, ptIntersectA);
			Point3d ptIntersectB;
			int iHasIntersectB = lnWallB.hasIntersection(plWallA, ptIntersectB);
			
			// X0A1 for wall A
			Vector3d vec0A1 = ptStartA - ptIntersectA;
			if((ptEndA-ptIntersectA).length()>(ptStartA-ptIntersectA).length())
			{ 
				//
				vec0A1 = ptEndA - ptIntersectA;
			}
			vec0A1.normalize();//X0A1
			
			// X0A1 for wall B
			Vector3d vec0B1 = ptStartB - ptIntersectB;
			if((ptEndB-ptIntersectB).length()>(ptStartB-ptIntersectB).length())
			{	vec0B1 = ptEndB - ptIntersectB;
			}
			vec0B1.normalize();//X0B1
			
			Point3d ptOrgA;
			Point3d ptOrgB;
			// compare vecA with vec0B1 and vecB with vec0A1
			if(vecA.dotProduct(vec0B1)>0)// same direction
			{ 
				ptOrgA = nZone==0?el1.ptOrg():zone.ptOrg();
			}
			else
			{ 
				ptOrgA = nZone==0?zone.ptOrg():el1.ptOrg();
			}
			if(vecB.dotProduct(vec0A1)>0)// same direction
			{ 
				ptOrgB = nZone==0?el2.ptOrg():zoneOther.ptOrg();
			}
			else
			{ 
				ptOrgB = nZone==0?zoneOther.ptOrg():el2.ptOrg();
			}
			
		// find the intersection point between outer plane of this wall and other wall
		// ptInt always intersection of the outer planes of the 2 walls
			if(!Line(ptOrgA, vecSide).hasIntersection(Plane(ptOrgB,vecSide), ptInt))continue;
			double dMove;
			{
				LineSeg seg = pp.extentInDir(vecX);
				Point3d pts[] = Line(_Pt0 ,- vecSide).orderPoints(pp.getGripVertexPoints());
				if(pts.length()>0)
				dMove= vecSide.dotProduct(ptInt - pp.closestPointTo(pts[0]));// intersection point between exterior sides of 2 walls
			}
		// find extreme index
			if (abs(dMove)>dEps)
			{
				int nInd = -1;
				Point3d ptsV[] = pp.getGripEdgeMidPoints();
				double dMax = -U(10e4);
				for (int j=0;j<ptsV.length();j++) 
				{
					Point3d& pt = ptsV[j]; 
					double d = vecSide.dotProduct(pt);
					if (d>dMax)
					{
						dMax = d;
						nInd = j;
					}
				}//next j
				if (nInd>-1 )
				{
				//ptsV[nInd].vis(2);
					int bOk = pp.moveGripEdgeMidPointAt(nInd, vecSide * dMove);
				}
			}
		}//next j
		
	//End loop connected walls//endregion 
	// combine multiple floors
		if (ppFacade.area()<pow(dEps,2))
			ppFacade = pp;
		else
			ppFacade.unionWith(pp);// add the aditional area from the normal wall
	}
//End get distribution profile//endregion
	
//region ppFacade without openings
	PlaneProfile ppFacadeCopy = ppFacade;
	ppFacadeCopy.shrink(-U(10));
	ppFacadeCopy.shrink(U(10));
	ppFacade = ppFacadeCopy;
	
	PlaneProfile ppOpeningCopy = ppOpening;
	ppOpeningCopy.shrink(-U(10));
	ppOpeningCopy.shrink(U(10));
	ppOpening = ppOpeningCopy;
	
	ppFacade.subtractProfile(ppOpening);
//End ppFacade without openings//endregion
	

//region get all TSL of brick distributions, order them in vecX, find the position of this_inst
// for each brick distribution generate one TslInst tslBricks
	TslInst tslBricks[0];
	Point3d ptOrgs[0];
	String sScriptName = _bOnDebug ? "hsbBrick-BrickDistributionExterior" : scriptName();
	
	for (int i=0;i<_Element.length();i++) // all elements of this TSL (internal walls only 1 wall)
	{ 
		Element el=_Element[i];
		TslInst tsls[] = el.tslInst();// get all TSLs of the element
		
		for (int j=0;j<tsls.length();j++) 
		{ 
			TslInst t = tsls[j];
			if (t.scriptName() == sScriptName && tslBricks.find(t)<0)
			{
				tslBricks.append(t);// get all TSLs from all elements for this TSL
				ptOrgs.append(t.ptOrg());
			}
		}
	}//next i
	
// order alphabetically
	for (int i=0;i<tslBricks.length();i++) 
		for (int j=0;j<tslBricks.length()-1;j++) 
			if (vecX.dotProduct(ptOrgs[j])>vecX.dotProduct(ptOrgs[j+1]))// should it not be ordered with _XW?
			{
				tslBricks.swap(j, j + 1);
				ptOrgs.swap(j, j + 1);	
			}

// find my index
	int n = tslBricks.find(_ThisInst);
//End get all TSL of brick distributions, order them in vecX, find the position of this_inst//endregion
	
//region set dependency of this_inst with all other distributions
//	double dArea = debugPLine.area();
	if (debugPLine.area() > pow(U(10), 2))
	{
		n = 0;
		tslBricks.setLength(0);
		ppFacade = PlaneProfile(ppFacade.coordSys());
		ppFacade.joinRing(debugPLine, _kAdd);
	}
	
	if (n<0 && 0)//////////////////////////////////
	{ 
		reportMessage(TN("|Unexpected error.|"));
		if(!_bOnDebug)eraseInstance();
		return;
	}
	else if (n<tslBricks.length()-1)
	{
		// set dependencies for all following distributions
		_Entity.append(tslBricks[n+1]);
		setDependencyOnEntity(tslBricks[n+1]); 
		tslBricks[n + 1].transformBy(Vector3d(0, 0, 0));
	}//next i
//End set dependency of this_inst with all other distributions//endregion
	
	
//region Find distribution range for this distribution
	LineSeg segFacade = ppFacade.extentInDir(vecX);
	ppFacade.vis(2);
	segFacade.vis(2);
	
	Point3d ptsExtr[] = {segFacade.ptStart(),segFacade.ptEnd()};
	
	Point3d ptStart = ptsExtr[0];
	Point3d ptEnd = ptsExtr[1];
	int bIsLastButt = n==tslBricks.length()-1;
	if (n<tslBricks.length()-1)
		ptEnd += vecX* vecX.dotProduct(ptOrgs[n+1] - ptEnd);

	if (n>0)
	{
		ptStart = ptOrgs[n];
		tslBricks[n-1].recalc();
	}

	ptStart = pnZone.closestPointTo(ptStart);// start point projected to plane pnZone
	ptEnd = pnZone.closestPointTo(ptEnd);//end point projected to plane pnZone
	ptStart.vis(5);
	ptEnd.vis(5);
	
	PlaneProfile ppRange(csZone);
	ppRange.createRectangle(LineSeg(ptStart - vecY * U(10e4), ptEnd + vecY * U(10e4)), vecX, vecY);
	ppRange.intersectWith(ppFacade);
	ppRange.vis(n);
	
	Display dp(n);
	//dp.draw(ppRange, _kDrawFilled, 80);
	dp.draw(ppRange);
//End Find distribution range//endregion 	
	
//region depending on type of distribution, find start of distribution, ending and its range; do optimisation
	Point3d ptStartRange = ptStart;
	Point3d ptStartRange2; // starting for the 2nd row
	
//	ptStart.vis(3);
	if (n>0)
	{
		Map mapX = tslBricks[n - 1].subMapX("hsbBrickData");
		int iHasPoint = mapX.hasPoint3d("ptBrick");
		if ( ! iHasPoint)return;
		ptStartRange = mapX.getPoint3d("ptBrick");// gets from previous distribution
		ptStartRange2 = mapX.getPoint3d("ptBrick2");// gets from previous distribution
	}
	int endsAtOpeningStart = false;
	for (int i = 0; i < ptsOpStart.length(); i++)
	{
		Point3d pt = ptsOpStart[i];
		if (abs(vecX.dotProduct(pt - ptEnd)) < dEps) 
		{
			endsAtOpeningStart = true;
			break;
		}
	}
	vecX.vis(ptEnd, 1);
	
	// modify if starts/ends as male
	if (bIsMaleCorners[0] && n==0)// starting wall and male
	{ 
		// should start half bbrick later + mortar
		ptStartRange = ptStartRange + vecX * dWidth;
	}
	if (bIsMaleCorners[1] && n==(tslBricks.length()-1))// ending wall and male
	{ 
		// should end half brick earlier + mortar
		ptEnd = ptEnd - vecX * dWidth;
	}
	double dRange = vecX.dotProduct(ptEnd-ptStartRange);//wall range
//	dp.textHeight(U(50));
//	dp.draw("ptStartRange", ptStartRange, _XU, _YU, 0, 0, _kDeviceX);
//	dp.draw("ptEnd", ptEnd, _XU, _YU, 0, 0, _kDeviceX);
	//HSB-9023:
	int iAttempt = _Map.getInt("iAttempt");
	if(dRange<dEps)
	{ 
		if (iAttempt == 0)
		{
			_Map.setInt("iAttempt", 1);
			if (_kExecutionLoopCount == 0) setExecutionLoops(2);
			else if (_kExecutionLoopCount == 1) setExecutionLoops(3);
			else if (_kExecutionLoopCount == 2) setExecutionLoops(4);
		}
		else if (iAttempt == 1)
		{
			_Map.setInt("iAttempt", 2);
			if (_kExecutionLoopCount == 0) setExecutionLoops(2);
			else if (_kExecutionLoopCount == 1) setExecutionLoops(3);
			else if (_kExecutionLoopCount == 2) setExecutionLoops(4);
		}
		else if (iAttempt == 2)
		{
			_Map.setInt("iAttempt", 3);
			if (_kExecutionLoopCount == 0) setExecutionLoops(2);
			else if (_kExecutionLoopCount == 1) setExecutionLoops(3);
			else if (_kExecutionLoopCount == 2) setExecutionLoops(4);
		}
		else if (iAttempt == 3)
		{
			_Map.setInt("iAttempt", 4);
			if (_kExecutionLoopCount == 0) setExecutionLoops(2);
			else if (_kExecutionLoopCount == 1) setExecutionLoops(3);
			else if (_kExecutionLoopCount == 2) setExecutionLoops(4);
		}
//		reportMessage(TN("|length of distribution area < 0|"));
//		reportMessage(TN("|calculation not possible|"));
//		reportMessage(TN("|iAttempt| ")+iAttempt);
		// 
		if (iAttempt == 4)
		{
			// 3 attempts are made, distribution not possible
			reportMessage(TN("|distribution range will be deleted|"));
			eraseInstance();
			return
		}
	}
//End depending on type of distribution, find start of distribution, ending and its range; do optimisation//endregion

//region calculate the butt joint width from optimisation; calc min and max nr of bricks that can fit for each distribution type (full, half, 1/4, 3/4)
	ptStartRange.vis(4);
	// 
	int nNumBrick;
	double dButtJoint;
	double distribTypes[] ={ 1.0, 0.5, 0.25, 0.75};
	
	int nNumMin;
	int nNumMax;
	int regular = false;// true if distribution ends with full brick
	int index;
	double dBrickFirst;// first brick that is adapted to the half brick 
	double dRangeFull;// dRange only with full bricks and mortar
	int nBricksAdded; // nr bricks removed or added in order to get a regular layer (brick-mortar)for the calculation
	int iWidthIsSuperLarge = false;// for usual bricks is always true
	if (dWidth >= .5 * (dLength - dButtJointMin)) iWidthIsSuperLarge = true;
	
	int iWidthIsLarge=false; // compares dWidth ><.5*(dLength-dButtJointMax)
	if (dWidth >= .5 * (dLength - dButtJointMax)) iWidthIsLarge = true;
	double dBrickFirstFemaleEven = 1.5 * dLength - dWidth - .5 * dButtJointMax; //w > 0.5L;
	double dBrickFirstFemaleOdd = .5 * dLength + .5 * dButtJointMin + dWidth; //w < 0.5L;
	
	double dBrickFirstMaleOdd = 1.5 * dLength - dWidth - 0.5 * dButtJointMax; //w > 0.5L;
	double dBrickFirstMaleEven = dWidth + .5 * dLength + .5 * dButtJointMin;//w < 0.5L;
	
	//iWidthIsLarge=true -> female first brick modified at 2nd layer, male first brick modified at 1st layer
	// 
	double dModuleMax = dLength + dButtJointMax;
	double dModuleMin = dLength + dButtJointMin;
	
	for (int i=0;i<distribTypes.length();i++) 
	{
	//1- for middle distributions
		// min nr of bricks that can fit with an additional 1/4 brick
		if (n>0 && n<(tslBricks.length()-1))
		{
			if (endsAtOpeningStart)
			{
				dRangeFull = (dRange - distribTypes[i] * dLength);
				nBricksAdded = -1;// 1 brick is removed
				// brick - brick
				nNumMin = dRangeFull / dModuleMax + 1;
				nNumMin += 1;
				// max nr of bricks that can fit with an additional 1/4 bricks
				nNumMax = dRangeFull / dModuleMin;
				nNumMax += 1;
			}
			else
			{
				// if endsAtOpeningStart=false it has 2 options
				//1- finish with full brick and mortar
				//2- finish with a cutted brick 1/4, 1/2, 3/4
				
				if(i==0)//full brick
				{
					//ends with mortar
					dRangeFull = dRange;
					nBricksAdded = 0;
					// brick - mortar
					nNumMin = dRange / dModuleMax+1;
					// max nr of bricks that can fit with an additional 1/4 bricks
					nNumMax = dRange / dModuleMin;
				}
				else
				{
					// ends with cutted brick
					dRangeFull = (dRange - distribTypes[i] * dLength);
					nBricksAdded = -1;
					nNumMin = dRangeFull / dModuleMax+1;
					nNumMin += 1;
					// max nr of bricks that can fit with an additional 1/4 bricks
					nNumMax = dRangeFull / dModuleMin;
					nNumMax += 1;
				}
			}
		}
		
	//2- for start distributions
		if(n==0 && n<(tslBricks.length()-1))
		{
			if(bIsFemaleCorners[0])//female or End
			{
				// female-> starts with brick
				if (endsAtOpeningStart)// ends with brick
				{
					if(iWidthIsSuperLarge)
					{ 
						// use 1st row for the calculation
						dRangeFull = (dRange - distribTypes[i] * dLength );
						nBricksAdded = -1;
						// brick - brick
						nNumMin = dRangeFull / dModuleMax + 1;
						nNumMin += 1;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
						nNumMax += 1;
					}
					else if(iWidthIsLarge)
					{
						// use 1st row for the calculation
						dRangeFull = (dRange - distribTypes[i] * dLength - dModuleMax);
						nBricksAdded = -2;
						// brick - brick
						nNumMin = dRangeFull / dModuleMax + 1;
						nNumMin += 2;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
						nNumMax += 2;
					}
					
					else if(!iWidthIsLarge)// dBrickFirst at odd layer
					{
						// use 2nd row for the calculaiton
						// dBrickFirst is placed at odd layer
						dRangeFull = (dRange - distribTypes[i] * dLength - (dWidth + dButtJointMin));
						nBricksAdded = -2;
						// brick - brick
						nNumMin = dRangeFull / dModuleMax + 1;
						nNumMin += 2;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
						nNumMax += 2;
					}
				}
				else// !endsAtOpeningStart
				{
					if(i==0) //full brick, should end with joint
					{
						if(iWidthIsSuperLarge)
						{
							dRangeFull = dRange;
							nBricksAdded = 0;
							// brick - mortar
							nNumMin = dRange / dModuleMax+1;
							// max nr o<f bricks that can fit with an additional 1/4 bricks
							nNumMax = dRange / dModuleMin;
						}
						else if(iWidthIsLarge)
						{
							dRangeFull = dRange - dModuleMax;
							nBricksAdded = -1;
							// brick - mortar
							nNumMin = dRange / dModuleMax+1;
							nNumMin += 1;
							// max nr o<f bricks that can fit with an additional 1/4 bricks
							nNumMax = dRange / dModuleMin;
							nNumMax += 1;
						}
						else if(!iWidthIsLarge)
						{
							dRangeFull = (dRange - (dWidth + dButtJointMin));
							nBricksAdded = -1;
							// brick - mortar
							nNumMin = dRangeFull / dModuleMax+1;
							nNumMin += 1;
							// max nr o<f bricks that can fit with an additional 1/4 bricks
							nNumMax = dRangeFull / dModuleMin;
							nNumMax += 1;
						}
					}
					else//cutted bricks, end bith cutted brick
					{
						if (iWidthIsSuperLarge)
						{ 
							dRangeFull = (dRange - distribTypes[i] * dLength);
							nBricksAdded = -1;
							// brick - brick
							nNumMin = dRangeFull / dModuleMax+1;
							nNumMin += 1;
							// max nr of bricks that can fit with an additional 1/4 bricks
							nNumMax = dRangeFull / dModuleMin;
							nNumMax += 1;
						}
						else if(iWidthIsLarge)
						{
							dRangeFull = (dRange - distribTypes[i] * dLength - dModuleMax);
							nBricksAdded = -2;
							// brick - brick
							nNumMin = dRangeFull / dModuleMax+1;
							nNumMin += 2;
							// max nr of bricks that can fit with an additional 1/4 bricks
							nNumMax = dRangeFull / dModuleMin;
							nNumMax += 2;
						}
						else if(!iWidthIsLarge)// dBrickFirst at first layer
						{
							dRangeFull = (dRange - distribTypes[i] * dLength - (dWidth + dButtJointMin));
							nBricksAdded = - 2;
							// brick - brick
							nNumMin = dRangeFull / dModuleMax + 1;
							nNumMin += 2;
							// max nr of bricks that can fit with an additional 1/4 bricks
							nNumMax = dRangeFull / dModuleMin;
							nNumMax += 2;
						}
					}
				}
			}
			if(bIsMaleCorners[0])
			{
				// male->starts with mortar
				if (endsAtOpeningStart)// ends with brick
				{
					if (iWidthIsSuperLarge)
					{ 
						// use 1st row for the calculation
						dRangeFull = (dRange - distribTypes[i] * dLength + dWidth);
						nBricksAdded = 0;
						// mortar - brick
						nNumMin = dRangeFull / dModuleMax + 1;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
					}
					else if(iWidthIsLarge)// 
					{
						// use 1st row for the calculation
						dRangeFull = (dRange - distribTypes[i] * dLength + dWidth - dModuleMax);
						nBricksAdded = -1;
						// mortar - brick
						nNumMin = dRangeFull / dModuleMax + 1;
						nNumMin += 1;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
						nNumMax += 1;
					}
					else// !iWidthIsLarge
					{
						// use 2nd row
						dRangeFull = (dRange - distribTypes[i] * dLength - dButtJointMin);
						nBricksAdded = -1;
						// mortar - brick
						nNumMin = dRangeFull / dModuleMax + 1;
						nNumMin += 1;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
						nNumMax += 1;
					}
				}
				else// !endsAtOpeningStart
				{
					if(i==0)// full brick, ends with mortar
					{
						if(iWidthIsSuperLarge)
						{ 
							//use 1st row
							dRangeFull = (dRange + dWidth);
							nBricksAdded = 0;
							// mortar - mortar
							nNumMin = dRangeFull / dModuleMax + 1;
							// max nr of bricks that can fit with an additional 1/4 bricks
							nNumMax = dRangeFull / dModuleMin;
						}
						else if(iWidthIsLarge)
						{
							//use 1st row
							dRangeFull = (dRange + dWidth - dModuleMax);
							nBricksAdded = -1;
							// mortar - mortar
							nNumMin = dRangeFull / dModuleMax + 1;
							nNumMin += 1;
							// max nr of bricks that can fit with an additional 1/4 bricks
							nNumMax = dRangeFull / dModuleMin;
							nNumMax += 1;
						}
						else
						{
							// use 2nd row
							dRangeFull = (dRange - dButtJointMin);
							nBricksAdded = 0;
							// mortar - mortar
							nNumMin = dRangeFull / dModuleMax + 1;
							// max nr of bricks that can fit with an additional 1/4 bricks
							nNumMax = dRangeFull / dModuleMin;
						}
					}
					else//ends with cutted brick
					{
						if (iWidthIsSuperLarge)
						{ 
							//use 1st row
							dRangeFull = (dRange + dWidth - distribTypes[i] * dLength);
							nBricksAdded = -1;
							// mortar - brick
							nNumMin = dRangeFull / dModuleMax + 1;
							nNumMin += 1;
							// max nr of bricks that can fit with an additional 1/4 bricks
							nNumMax = dRangeFull / dModuleMin;
							nNumMax += 1;
						}
						else if(iWidthIsLarge)
						{
							//use 1st row
							dRangeFull = (dRange + dWidth - distribTypes[i] * dLength - dModuleMax);
							nBricksAdded = -1;
							// mortar - brick
							nNumMin = dRangeFull / dModuleMax + 1;
							nNumMin += 1;
							// max nr of bricks that can fit with an additional 1/4 bricks
							nNumMax = dRangeFull / dModuleMin;
							nNumMax += 1;
						}
						else
						{ 
							// use 2nd row
							dRangeFull = (dRange - dButtJointMin - distribTypes[i] * dLength);
							nBricksAdded = 0;
							// mortar - brick
							nNumMin = dRangeFull / dModuleMax + 1;
							// max nr of bricks that can fit with an additional 1/4 bricks
							nNumMax = dRangeFull / dModuleMin;
						}
					}
				}
			}
			if(bIsEndCorners[0])//End
			{
				if (endsAtOpeningStart)//ends with brick 
				{
					// use 1st row for the calculation
					dRangeFull = (dRange - distribTypes[i] * dLength);
					nBricksAdded = -1;
					// brick - brick
					nNumMin = dRangeFull / dModuleMax + 1;
					nNumMin += 1;
					// max nr of bricks that can fit with an additional 1/4 bricks
					nNumMax = dRangeFull / dModuleMin;
					nNumMax += 1;
				}
				else// !endsAtOpeningStart, ends with mortar
				{
					if(i==0) //full brick
					{
						dRangeFull = dRange;
						nBricksAdded = 0;
						// brick - mortar
						nNumMin = dRange / dModuleMax+1;
						// max nr o<f bricks that can fit with an additional 1/4 bricks
						nNumMax = dRange / dModuleMin;
					}
					else//cutted bricks
					{
						dRangeFull = (dRange - distribTypes[i] * dLength + dLength);
						nBricksAdded = 0;
						// brick - brick
						nNumMin = dRangeFull / dModuleMax+1;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
					}
				}
			}
		}
		
	//3- for end distributions
		if (n > 0 && n == (tslBricks.length() - 1))
		{
			if ( bIsFemaleCorners[1] || bIsEndCorners[1])//ends with female or End
			{
				// female-> ends with brick
				// brick - brick
				dRangeFull = (dRange - distribTypes[i] * dLength);
				nBricksAdded = -1;
				nNumMin = dRangeFull / dModuleMax + 1;
				nNumMin += 1;
				// max nr of bricks that can fit with an additional 1/4 bricks
				nNumMax = dRangeFull / dModuleMin;
				nNumMax += 1;
			}
			if (bIsMaleCorners[1])//ends with male
			{
				dRangeFull = (dRange - distribTypes[i] * dLength + dLength);
				nBricksAdded = 0;
				//brick - mortar
				nNumMin = dRangeFull / dModuleMax + 1;
				// max nr of bricks that can fit with an additional 1/4 bricks
				nNumMax = dRangeFull / dModuleMin;
			}
		}
		
	//4- only one distribution
		if (tslBricks.length() == 1)
		{
			if(bIsFemaleCorners[0])// female
			{
				if(bIsFemaleCorners[1])// female
				{
					if(iWidthIsSuperLarge)
					{ 
						// use 1st layer for the calculation
						dRangeFull = (dRange - distribTypes[i] * dLength);
						nBricksAdded = -1;
						// female - female brick - brick
						nNumMin = dRangeFull / dModuleMax + 1;
						nNumMin += 1;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
						nNumMax += 1;
					}
					else if(iWidthIsLarge)
					{ 
						// use 1st layer for the calculation
						dRangeFull = (dRange - distribTypes[i] * dLength - dModuleMax);
						nBricksAdded = -2;
						// female - female brick - brick
						nNumMin = dRangeFull / dModuleMax + 1;
						nNumMin += 2;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
						nNumMax += 2;
					}
					
					else if(!iWidthIsLarge)
					{
						// use 2nd layer for the calculation
						dRangeFull = (dRange - distribTypes[i] * dLength - 2*dWidth+2*dLength);
						nBricksAdded = +1;
						// female - female brick - brick
						nNumMin = dRangeFull / dModuleMax + 1;
						nNumMin -= 1;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
						nNumMax -= 1;
					}
				}
				else if(bIsMaleCorners[1])//male, ends with joint
				{
					if(iWidthIsSuperLarge)
					{ 
						// use first layer
						dRangeFull = (dRange - distribTypes[i] * dLength + dLength);
						nBricksAdded = 0;
						// female - male brick - mortar
						nNumMin = dRangeFull / dModuleMax + 1;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
					}
					else if(iWidthIsLarge)
					{
						// use first layer
						dRangeFull = (dRange - distribTypes[i] * dLength + dLength - dModuleMax);
						nBricksAdded = -1;
						// female - male brick - mortar
						nNumMin = dRangeFull / dModuleMax + 1;
						nNumMin += 1;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
						nNumMax += 1;
					}
					else if(!iWidthIsLarge)
					{ 
						// use 2nd layer for calculation
						dRangeFull = (dRange - distribTypes[i] * dLength + dLength);
						nBricksAdded = 0;
						// female - male brick - mortar
						nNumMin = dRangeFull / dModuleMax + 1;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
					}
					
				}
				else if(bIsEndCorners[1])
				{ 
					if(iWidthIsSuperLarge)
					{ 
						// use 1st layer for the calculation
						dRangeFull = (dRange - distribTypes[i] * dLength);
						nBricksAdded = -1;
						// female - female brick - brick
						nNumMin = dRangeFull / dModuleMax + 1;
						nNumMin += 1;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
						nNumMax += 1;
					}
					else if(iWidthIsLarge)
					{ 
						// use 1st layer for the calculation
						dRangeFull = (dRange - distribTypes[i] * dLength - dModuleMax);
						nBricksAdded = -2;
						// female - female brick - brick
						nNumMin = dRangeFull / dModuleMax + 1;
						nNumMin += 2;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
						nNumMax += 2;
					}
					
					else if(!iWidthIsLarge)
					{
						// use 2nd layer for the calculation
						dRangeFull = (dRange - distribTypes[i] * dLength - (dWidth + dButtJointMin));
						nBricksAdded = -2;
						// female - female brick - brick
						nNumMin = dRangeFull / dModuleMax + 1;
						nNumMin += 2;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
						nNumMax += 2;
					}
				}
			}
			if(bIsMaleCorners[0])// male
			{
				if(bIsFemaleCorners[1])// female
				{
					if(iWidthIsSuperLarge)
					{ 
						//use 2nd layer for calculation; ends 1 width before and the mortar
						//+dWidth in beginning - dWidth at the end
						dRangeFull = (dRange - distribTypes[i] * dLength + dLength);
						nBricksAdded = 0;
						// male - female mortar - brick
						nNumMin = dRangeFull / dModuleMax + 1;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
					}
					else if(iWidthIsLarge)
					{
						//use 2nd layer for calculation; ends 1 width before and the mortar
						//+dWidth in beginning - dWidth at the end
						dRangeFull = (dRange - distribTypes[i] * dLength - dModuleMax + dLength);
						nBricksAdded = -1;
						// male - female mortar - brick
						nNumMin = dRangeFull / dModuleMax + 1;
						nNumMin += 1;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
						nNumMax += 1;
					}
					else
					{ 
						// use first layer
						dRangeFull = (dRange - distribTypes[i] * dLength + dLength);
						nBricksAdded = 0;
						// male - female mortar - brick
						nNumMin = dRangeFull / dModuleMax + 1;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
					}
					
				}
				if(bIsMaleCorners[1])// male-male
				{
					if(iWidthIsSuperLarge)
					{ 
						//use 2nd layer
						dRangeFull = (dRange + 2*dWidth - distribTypes[i] * dLength);
						nBricksAdded = 0;
						// male - male mortar - mortar
						nNumMin = dRangeFull / dModuleMax + 1;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
					}
					else if(iWidthIsLarge)
					{ 
						//use 2nd layer
						dRangeFull = (dRange + 2*dWidth - distribTypes[i] * dLength - dModuleMax);
						nBricksAdded = -1;
						// male - male mortar - mortar
						nNumMin = dRangeFull / dModuleMax + 1;
						nNumMin += 1;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
						nNumMax += 1;
					}
					else // !iWidthIsLarge
					{
						// use 1st layer
						dRangeFull = (dRange - distribTypes[i] * dLength + 2*dLength);
						nBricksAdded = 1;
						// male - male mortar - mortar
						nNumMin = dRangeFull / dModuleMax + 1;
						nNumMin -= 1;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
						nNumMax -= 1;
					}
				}
				if(bIsEndCorners[1])//male-end
				{ 
					if(iWidthIsSuperLarge)
					{ 
						//use 2nd layer
						dRangeFull = (dRange + dWidth - distribTypes[i] * dLength);
						nBricksAdded = 0;
						// male - male mortar - mortar
						nNumMin = dRangeFull / dModuleMax + 1;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
					}
					else if(iWidthIsLarge)
					{
						//use 2nd layer
						dRangeFull = (dRange + dWidth - distribTypes[i] * dLength - dModuleMax);
						nBricksAdded = -1;
						// male - male mortar - mortar
						nNumMin = dRangeFull / dModuleMax + 1;
						nNumMin += 1;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
						nNumMax += 1;
					}
					else // !iWidthIsLarge
					{
						// use 1st layer
						dRangeFull = (dRange - distribTypes[i] * dLength + dLength);
						nBricksAdded = -1;
						// male - male mortar - mortar
						nNumMin = dRangeFull / dModuleMax + 1;
						nNumMin += 1;
						// max nr of bricks that can fit with an additional 1/4 bricks
						nNumMax = dRangeFull / dModuleMin;
						nNumMax += 1;
					}
				}
			}
			if(bIsEndCorners[0])// end
			{
				if(bIsFemaleCorners[1] || bIsEndCorners[1])// female or end
				{
					// use 1st layer for the calculation
					dRangeFull = (dRange - distribTypes[i] * dLength);
					nBricksAdded = -1;
					// female - female brick - brick
					nNumMin = dRangeFull / dModuleMax + 1;
					nNumMin += 1;
					// max nr of bricks that can fit with an additional 1/4 bricks
					nNumMax = dRangeFull / dModuleMin;
					nNumMax += 1;
				}
				if(bIsMaleCorners[1])//male
				{
					// use first layer
					dRangeFull = (dRange - distribTypes[i] * dLength + dLength);
					nBricksAdded = 0;
					// female - male brick - mortar
					nNumMin = dRangeFull / dModuleMax + 1;
					// max nr of bricks that can fit with an additional 1/4 bricks
					nNumMax = dRangeFull / dModuleMin;
				}
			}
		}
		//
		if (nNumMax>=nNumMin)
		{
			// a regular distribution is found, break loop
			regular = true;
			index = i;
			break;
		}
	}//next i
//End calculate the butt joint width from optimisation//endregion

	
//region Calculate butt width and set as readonly to the properties
	if(regular)
	{
		int nNumVar = nNumMax - nNumMin+1;
		int nNumVars[0];
		for (int i=0;i<nNumVar;i++) 
			nNumVars.append(nNumMin+i); 
			
		int nNumBricksSelected = _Map.hasInt("NumBrick")?_Map.getInt("NumBrick"):-1;
		if (nNumVars.find(nNumBricksSelected)<0)
			nNumBricksSelected = -1;
			
		nNumBrick = nNumBricksSelected < 0 ? nNumMin : nNumBricksSelected;
		
		if(nNumBrick + nBricksAdded>0)
		{ 
		// dButtJoint can be calculated
			dButtJoint = dRangeFull / (nNumBrick + nBricksAdded) - dLength;
		}
		else if ((nNumBrick + nBricksAdded)<=0)
		{ 
			dButtJoint = dButtJointMin;
		}
	}
	else if(!regular)
	{ 
		// none of options succeded
		dButtJoint = dButtJointMin;

		int nNumVar = 1;
		int nNumVars[0];
		for (int i=0;i<nNumVar;i++) 
			nNumVars.append(nNumMax+i);
			
		int nNumBricksSelected = _Map.hasInt("NumBrick")?_Map.getInt("NumBrick"):-1;
		if (nNumVars.find(nNumBricksSelected)<0)
			nNumBricksSelected = -1;
			
		nNumBrick = nNumBricksSelected < 0 ? nNumMax + 1 : nNumBricksSelected;
	}

	dButtJointProp.set(dButtJoint);
	
//End Calculate mortar width//endregion 
	
//region prepare arrays with brick positions

	// arrays with brick lengths and brick positions for odd and even rows
	// ptStartRange, ptEnd
	double dXOdd[0]; //start points of the bricks for odd rows
	double dXOddPrev; //keeps X of previous brick
	double dXEven[0]; // start points of the bricks for even rows relative to pstartRange
	double dXEvenPrev;// keeps X of previous brick
	double dLengthsOdd[0]; // brick lengths for bricks for odd rows
	double dLengthsEven[0]; // brick lengths for bricks for even rows
	
	double dXStart = vecX.dotProduct(ptStartRange);
	double dXEnd = vecX.dotProduct(ptEnd);
	double dModule = dLength + dButtJoint;
	
	// if iWidthIsSuperLarge
	double dBrickFirstFemaleEvenJoint = 1.5 * dLength - dWidth - .5 * dButtJoint; //w > 0.5L;
	double dBrickFirstMaleOddJoint = 1.5 * dLength - dWidth - 0.5 * dButtJoint; //w > 0.5L;
	// if iWidthIsSuperSmall or !Large
	double dBrickFirstFemaleOddJoint = dWidth + .5 * (dLength + dButtJoint);
	double dBrickFirstMaleEvenJoint = dWidth + .5 * (dLength + dButtJoint);
	
	// nr bricks in odd equal to even
//1- middle distributions
	if(n>0 && n<=tslBricks.length()-1)
	{ 
		dXOdd.append(0.0);
		dLengthsOdd.append(dLength);
		
		dXEven.append(0.0);
		dLengthsEven.append(dLength);
	}
	 //4-
	else if(n == 0)//start
	{
		if (bIsFemaleCorners[0])//female corner
		{
			if(iWidthIsSuperLarge)
			{ 
				
				// odd row
				dXOdd.append(0.0);
				dXOddPrev = dXOdd[dXOdd.length() - 1];
				dLengthsOdd.append(dLength);
				//even row
				dXEven.append((dWidth + dButtJoint));
				dXEvenPrev = dXEven[dXEven.length() - 1];
				dLengthsEven.append(dBrickFirstFemaleEvenJoint);//brick lengths
				
				// odd row
				dXOdd.append(dXOddPrev+dLength + dButtJoint);
				dXOddPrev = dXOdd[dXOdd.length() - 1];
				dLengthsOdd.append(dLength);
				// even row
				dXEven.append(dXEvenPrev + dBrickFirstFemaleEvenJoint + dButtJoint);
				dXEvenPrev = dXEven[dXEven.length() - 1];
				dLengthsEven.append(dLength);
			}
			// first brick modified and shifted
			else if (iWidthIsLarge)//iWidthIsLarge > true even row is modified
			{
				// odd row
				dXOdd.append(0.0);
				dXOddPrev = dXOdd[dXOdd.length() - 1];
				dLengthsOdd.append(dLength);
				//even row
				dXEven.append((dWidth + dButtJointMax));
				dXEvenPrev = dXEven[dXEven.length() - 1];
				dLengthsEven.append(dBrickFirstFemaleEven);//brick lengths
				
				// odd row
				dXOdd.append(dXOddPrev+dLength + dButtJointMax);
				dXOddPrev = dXOdd[dXOdd.length() - 1];
				dLengthsOdd.append(dLength);
				// even row
				dXEven.append(dXEvenPrev + dBrickFirstFemaleEven + .5 * (dButtJointMax + dButtJoint));
				dXEvenPrev = dXEven[dXEven.length() - 1];
				dLengthsEven.append(dLength);
			}
			else if ( ! iWidthIsLarge)//odd layer is modified
			{
				// odd row
				dXOdd.append(0.0);
				dXOddPrev = dXOdd[dXOdd.length() - 1];
				dLengthsOdd.append(dBrickFirstFemaleOddJoint);
				//even row
				dXEven.append((dWidth + dButtJoint));
				dXEvenPrev = dXEven[dXEven.length() - 1];
				dLengthsEven.append(dLength);//brick lengths
					
				// odd row
				dXOdd.append(dXOddPrev + dBrickFirstFemaleOddJoint + dButtJoint);
				dXOddPrev = dXOdd[dXOdd.length() - 1];
				dLengthsOdd.append(dLength);
				//even row
				dXEven.append(dXEvenPrev + dModule);
				dXEvenPrev = dXEven[dXEven.length() - 1];
				dLengthsEven.append(dLength);//brick lengths
			}
		}
		else if (bIsMaleCorners[0])//male
		{
			if (iWidthIsSuperLarge)//odd layer is modified
			{
				// odd row
				dXOdd.append(dButtJoint);
				dXOddPrev = dXOdd[dXOdd.length() - 1];
				dLengthsOdd.append(dBrickFirstMaleOddJoint);
				//even row
				dXEven.append(-dWidth);
				dXEvenPrev = dXEven[dXEven.length() - 1];
				dLengthsEven.append(dLength);//brick lengths
				// odd row
				dXOdd.append(dXOddPrev + dBrickFirstMaleOddJoint + dButtJoint);
				dXOddPrev = dXOdd[dXOdd.length() - 1];
				dLengthsOdd.append(dLength);
				//even row
				dXEven.append(dXEvenPrev + dLength + dButtJoint);
				dXEvenPrev = dXEven[dXEven.length() - 1];
				dLengthsEven.append(dLength);//brick lengths
			}
			// for male corners, ptStartRange starts at dWidth
			else if (iWidthIsLarge)//odd layer is modified
			{
				// odd row
				dXOdd.append(dButtJointMax);
				dXOddPrev = dXOdd[dXOdd.length() - 1];
				dLengthsOdd.append(dBrickFirstMaleOdd);
				//even row
				dXEven.append(-dWidth);
				dXEvenPrev = dXEven[dXEven.length() - 1];
				dLengthsEven.append(dLength);//brick lengths
				// odd row
				dXOdd.append(dXOddPrev + dBrickFirstMaleOdd + .5 * (dButtJointMax + dButtJoint));
				dXOddPrev = dXOdd[dXOdd.length() - 1];
				dLengthsOdd.append(dLength);
				//even row
				dXEven.append(dXEvenPrev + dLength + dButtJointMax);
				dXEvenPrev = dXEven[dXEven.length() - 1];
				dLengthsEven.append(dLength);//brick lengths
			}
			else if(!iWidthIsLarge)
			{ 
				// odd row
				dXOdd.append(dButtJoint);
				dXOddPrev = dXOdd[dXOdd.length() - 1];
				dLengthsOdd.append(dLength);
				//even row
				dXEven.append(-dWidth);
				dXEvenPrev = dXEven[dXEven.length() - 1];
				dLengthsEven.append(dBrickFirstMaleEvenJoint);//brick lengths
				// odd row
				dXOdd.append(dXOddPrev + dModule);
				dXOddPrev = dXOdd[dXOdd.length() - 1];
				dLengthsOdd.append(dLength);
				//even row
				dXEven.append(dXEvenPrev + dBrickFirstMaleEvenJoint + dButtJoint);
				dXEvenPrev = dXEven[dXEven.length() - 1];
				dLengthsEven.append(dLength);//brick lengths
			}
		}
		else if(bIsEndCorners[0])// it will start with full brick
		{ 
			// odd row
			dXOdd.append(0.0);
			dXOddPrev = dXOdd[dXOdd.length() - 1];
			dLengthsOdd.append(dLength);
			// even row
			dXEven.append(-.5*(dLength + dButtJoint));
			dXEvenPrev = dXEven[dXEven.length() - 1];
			dLengthsEven.append(dLength);
		}
	}
			
//End prepare arrays with brick positions//endregion 



//region ppFacadeOdd and ppFacadeEven, needed fo the start and en distributions, n=0 or n==tslBricks.length()-1
	// plane profile for even bricks and odd bricks at the end of the facade
	
	PlaneProfile ppFacadeEven = ppFacade;
	PlaneProfile ppFacadeOdd = ppFacade;
	
// reverse the previously change for the ptEnd
	// ending wall and male
	if (bIsMaleCorners[1] && n == (tslBricks.length() - 1))
	{ 
		// ptEnd is the max of odd and even
		ptEnd = ptEnd + vecX * dWidth;
	}
	Vector3d vecSide = vecX;
	if((ptEnd-ptStart).dotProduct(vecX)<0)
	{ 
		vecSide *= -1;
	}
	vecSide.vis(ptStart, 2);
	
// get index of the Left edge 
	int nInd = -1;
	Point3d ptsVE[] = ppFacadeEven.getGripEdgeMidPoints();
	double dMin=U(10e4);
	for (int j=0;j<ptsVE.length();j++) 
	{
		Point3d& pt = ptsVE[j]; 
		double d = vecSide.dotProduct(pt-ptStart);
		if (d<dMin)
		{
			dMin=d;
			nInd = j;// index of the most left edge
		}
	}//next j
	
	// create a rectangular at the start of ppfacade
	Point3d point1 = ptsVE[nInd];// first point on left
	Point3d point2 = point1 + vecSide * (dWidth + dButtJoint);
	point2 = point2 + U(5000) * vecY;
	point1 = point1 - U(5000) * vecY;
	LineSeg lSegConnection(point1, point2);
	PLine plRect;
	plRect.createRectangle(lSegConnection, vecX, vecY);
	PlaneProfile ppConnectionLeft(plRect);
	
	// get index of the right edge 
	nInd = -1;
	double dMax=-U(10e4);
	for (int j=0;j<ptsVE.length();j++) 
	{
		Point3d& pt = ptsVE[j]; 
		double d = vecSide.dotProduct(pt - ptStart);
		if (d>dMax)
		{
			dMax=d;
			nInd = j;// index of the most right edge
		}
	}//next j
	
	// create a rectangular at the end of ppfacade
	point2 = ptsVE[nInd];// last point
	point1 = point2 - vecSide * (dWidth + dButtJoint);
	point2 = point2 + U(5000) * vecY;
	point1 = point1 - U(5000) * vecY;
	LineSeg lSegConnection2(point1, point2);
	
	plRect.createRectangle(lSegConnection2, vecX, vecY);
	PlaneProfile ppConnectionRight(plRect);
	// starting
	if(bIsMaleCorners[0])
	{ 
		ppFacadeOdd.subtractProfile(ppConnectionLeft);
	}
	else if(bIsFemaleCorners[0])
	{ 
		ppFacadeEven.subtractProfile(ppConnectionLeft);
	}
	// end
	if(bIsMaleCorners[1])//male
	{ 
		ppFacadeOdd.subtractProfile(ppConnectionRight);// subtract the rectangular
	}
	else if(bIsFemaleCorners[1])
	{ 
		ppFacadeEven.subtractProfile(ppConnectionRight);// subtract the rectangular
	}
	ppFacadeEven.vis(5);
	ppFacadeOdd.vis(5);
		
//End ppFacadeOdd and ppFacadeEven, needed fo the start and en distributions, n=0 or n==tslBricks.length()-1//endregion
		


//region prepare hardware for thisInst; remove any existing hardware
	
	// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
		
	// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 

//End prepare hardware//endregion

//region prepare some data
 	
	dp.color(nColorBrick);
	Point3d ptBrick = ptStartRange;
	int isEvenRow = false;
	
	double dCourseHeight = mapX.getDouble("CourseJoint"); // Get this from the course distribution.
	
	int rowIndex = 0;
	double dBrickLength = dLength;
	double dBrickArea = dLength * dHeight;
	double dModuleHeight = dHeight + dCourseHeight;
	ptBrick.vis(1);
	int nNumBrickMax = dXOdd.length();
	if(dXEven.length()>dXOdd.length())
	{ 
		nNumBrickMax = dXEven.length();
	}
	
	// 
	//wall number
	String sWallNr = el.number();
	// wall rotation
	double dRotation = 0.0;
	
	if (abs(vecX.dotProduct(_XW)) > dEps && vecX.dotProduct(_XW) > 0)
	{ 
		// lies in X axis and in positive direction
		dRotation = 0.0;
	}
	else if (abs(vecX.dotProduct(_XW)) > dEps && vecX.dotProduct(_XW) < 0)
	{ 
		// lies in X axis and in negative direction
		dRotation = 180.0;
	}
	else if (abs(vecZ.dotProduct(_XW)) > dEps && vecZ.dotProduct(_XW) > 0)
	{ 
		// lies in Y direction and in positive direction
		dRotation = 90.0;
	}
	else if (abs(vecZ.dotProduct(_XW)) > dEps && vecZ.dotProduct(_XW) < 0)
	{ 
		// lies in Y direction and in negative direction
		dRotation = 270;
	}
	// display for not rectangular bricks
	Display dp3(4);

//End prepare some data//endregion
	
	
//region get the existing special 3d bricks, to get their posnum later
	
	//get the existing posnums of 3d special bricks
	TslInst tsl3dBricks[0];
	// get all 3dbrick tsl
	{ 
		Group grp();
		Entity arEnt[] = grp.collectEntities(true, TslInst(), _kModelSpace);
		TslInst tsl;
		String sTslName = "hsbBrick-3dBricks";
		
		// loop all collected entities and get those hsbBrick-SpecialBricks
		for (int i=arEnt.length()-1; i>=0 ; i--)
		{ 
			// 
			TslInst t = (TslInst)arEnt[i];
			if(t.scriptName() !=sTslName)
			{ 
				continue;
			}
			// all entities of TSL special-bricks
			Entity ents[] = t.entity();
			for (int j=0;j<ents.length();j++) 
			{ 
				TslInst tt = (TslInst)ents[j];
				if(tt==_ThisInst)
				{ 
					// brick attached to this distribution
					// delete previously generated bricks
					String sBrickType = t.propString(0);
					if (sBrickType == T("|Special|"))
					{
						tsl3dBricks.append(t);
						break;
					}
				}
			}//next j
		}//next i
	}
	
//End get the existing 3d bricks, to get their posnum later//endregion

//region delete previously generated 3d bricks if command for their calculation is triggered

	if (_bOnRecalc && (_kExecuteKey == sTriggerGenerateSpecialBricks || _kExecuteKey == sTriggerGenerate3dBricks))
	{
		// delete first the previously generated special bricks
		Group grp();
		Entity arEnt[] = grp.collectEntities(true, TslInst(), _kModelSpace);
		TslInst tsl;
		String sTslName = "hsbBrick-3dBricks";
		
		// loop all collected entities and get those hsbBrick-SpecialBricks
		
		for (int i=arEnt.length()-1; i>=0 ; i--)
		{ 
			// 
			TslInst t = (TslInst)arEnt[i];
			if (t.scriptName() != sTslName)
			{ 
				continue;
			}
			// all entities of TSL special-bricks
			Entity ents[] = t.entity();
			for (int j=0;j<ents.length();j++) 
			{ 
				TslInst tt = (TslInst)ents[j];
				if(tt==_ThisInst)
				{ 
					// brick attached to this distribution
					// delete previously generated bricks
					String sBrickType = t.propString(0);
					if(_kExecuteKey == sTriggerGenerateSpecialBricks)
					{ 
						if (sBrickType == T("|Special|"))
						{
							arEnt[i].dbErase();
							break;
						}
					}
					else if(_kExecuteKey == sTriggerGenerate3dBricks)
					{ 
						if (sBrickType == T("|Regular|"))
						{
							arEnt[i].dbErase();
							break;
						}
					}
				}
			}//next j
		}//next i
	}
	
//End delete previously generated 3d bricks if command for their calculation is triggered//endregion

	
//region set the grip points only for the first distribution
 	
	String _PtGNames[0];
	int iIndexGrip = 0;
	
	// initialize again if changed at previous loop
	rowIndex = 0;
	ptBrick = ptStartRange;
	isEvenRow = false;
	
// set the grip point only for the first distribution n=0
	double dGripGap = 0;// by default
	
	if(n==0)
	{
		if(_PtG.length()<1)
		{
		// initialize grip point in _PtG
			_PtG.append(ptStartRange + _ZW * dCourseHeight);
		}
		_PtG[0] = Line(ptStartRange + _ZW * dCourseHeight, vecX).closestPointTo(_PtG[0]);
		dGripGap = (ptStartRange - _PtG[0]).dotProduct(vecX);
		nNumBrickMax += int(dGripGap / dModule) + 1;
		if(dGripGap<0)
		{ 
			// grip point on the right of the starting ptStartRange
			int iNModules = abs(dGripGap) / dModule;
			iNModules += 1;
			double _dGripGap = iNModules * dModule;
			dGripGap = _dGripGap - abs(dGripGap);
		}
	}
	
//End set the grip points only for the first distribution//endregion	
	

//region draw the brick plane profiles

	// map that stores last brick for this distribution, needed from the subsequent distribution
	Map mapXSave;
	double dHalf = (ptStartRange2 - ptStartRange).dotProduct(vecX);
	if(dHalf>0)
	{ 
		ptStartRange2 += (.5 * (dLength + dButtJoint) - dHalf) * vecX;
	}
	else if(dHalf<0)
	{ 
		ptStartRange2 += (-.5 * (dLength + dButtJoint) - dHalf) * vecX;
	}
	
	int i3dBrickPosnum = -1;
	// loop in height
	while (_ZW.dotProduct(ptEnd - ptBrick) > dEps)
	{
		// guard infinite loop
		if (rowIndex > 10000) break;
		// place ptBrick at start for odd rows
		Point3d ptBrickStart;
		
		ptBrickStart = ptStartRange - dGripGap * vecX 
				+ _ZW * dCourseHeight + _ZW * rowIndex * dModuleHeight;
				
		if(isEvenRow && n>0)
		{
			ptBrickStart = ptStartRange2 - dGripGap * vecX 
				+ _ZW * dCourseHeight + _ZW * rowIndex * dModuleHeight;
		}
		
		int i = 0;
		ptBrick = ptBrickStart;
		
//		double dBrickEnd = (ptEnd - ptBrick).dotProduct(vecX);
		double dBrickEnd = 2 * dLength;// initialize so that it always enters while loop
		// add brick as long as dBrickEnd>dLength; dBrickEnd = (ptEnd - ptBrick).dotProduct(vecX) 
		while(dBrickEnd>dLength)
		{ 
		// guard infinite loop
			if (i > 10000)break;
			//initialize posnum for special bricks; only special bricks will have posnum, rest will have -1
			i3dBrickPosnum = - 1;
			if(!isEvenRow)
			{
				if(i<dXOdd.length())
				{ 
					ptBrick = ptBrickStart + vecX * dXOdd[i];
					dBrickLength = dLengthsOdd[i];
				}
				else
				{
					ptBrick += vecX * dModule;
					dBrickLength = dLength;
				}
			}
			else if(isEvenRow)
			{ 
				if(i<dXEven.length())
				{ 
					ptBrick = ptBrickStart + vecX * dXEven[i];
					dBrickLength = dLengthsEven[i];
				}
				else
				{ 
					ptBrick += vecX * dModule;
					dBrickLength = dLength;
				}
			}
			
			LineSeg seg(ptBrick, ptBrick + vecX *dBrickLength + vecY * dHeight);
			PlaneProfile pp(csZone);
			pp.createRectangle(seg, vecX, vecY);
			if(n==0 || n==tslBricks.length()-1)// end distribution or start
			{ 
				if(isEvenRow)
				{ 
					pp.intersectWith(ppFacadeEven);
				}
				else if(!isEvenRow)
				{ 
					pp.intersectWith(ppFacadeOdd);
				}
			}
			else 
			{ 
				pp.intersectWith(ppFacade);
			}
			// distance from start of brick to ptEnd
			dBrickEnd = (ptEnd - ptBrick).dotProduct(vecX);
			// index i is not used later we can safely increment it here
			i++;
			if (pp.area() < dEps) 
			{
				continue;
			}
			
			LineSeg lSegRealBrick = pp.extentInDir(vecX);
			Vector3d vecReal = lSegRealBrick.ptEnd() - lSegRealBrick.ptStart();
			Point3d ptMidBrick = .5 * (lSegRealBrick.ptStart() + lSegRealBrick.ptEnd());// middle point of the brick
			
			double dLengthReal = abs(vecReal.dotProduct(vecX));
			double dHeightReal = abs(vecReal.dotProduct(vecY));
			Point3d ptMidBrickAbsolute = ptMidBrick - .5 * dWidth * vecZ - .5 * dHeightReal * vecY;
			double ptBrickHardwareX = _XW.dotProduct(ptMidBrickAbsolute - ptRefBuilding);
			double ptBrickHardwareY = _YW.dotProduct(ptMidBrickAbsolute - ptRefBuilding);
			double ptBrickHardwareZ = _ZW.dotProduct(ptMidBrickAbsolute - ptRefBuilding);
			
			// generate 3d bricks
			if (_bOnRecalc && (_kExecuteKey==sTriggerGenerate3dBricks))
			{
				// create new instance
				// create TSL
				TslInst tslNew;			Vector3d vecXTsl= vecX;			Vector3d vecYTsl= vecY;
				GenBeam gbsTsl[] = {};	Entity entsTsl[] = {_ThisInst, tslCourse};	Point3d ptsTsl[] = {ptBrick};
				int nProps[]={};		double dProps[]={};				String sProps[]={};
				Map mapTsl;
				mapTsl.appendPlaneProfile("planeProfile", pp);// save plane profile into map
				mapTsl.setDouble("width", dWidth);
				mapTsl.setDouble("dOffsetX", ptBrickHardwareX);
				mapTsl.setDouble("dOffsetY", ptBrickHardwareY);
				mapTsl.setDouble("dOffsetZ", ptBrickHardwareZ);
				mapTsl.setString("sBrickTypeMap", T("|Regular|"));
					
				entsTsl.append(el);// save wall into entities
							
				tslNew.dbCreate("hsbBrick-3dBricks" , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
//							setExecutionLoops(2);
//							return;
			}
			
			// 
			int brickIsSpecial = 0;// regular
			// tells if (max length)/(bottom base) > 60%
			String sNotes = "";
			// check if it is not rectangular
			int iNotRect = false;
			double dAreaReal = pp.area();
			double dAreaRect = dLengthReal * dHeightReal;
			
			// distinguish between, regular, rectangular but cutted, special (not retangular)
			// check if not rectangular shape
			if(abs(dAreaReal-dAreaRect)>dEps)
			{ 
				//not a rectangular shape; special
				iNotRect = true;
			}
			
			if (abs(pp.area() - dBrickArea) < dEps)
			{ 
				// regular
				dp.draw(pp, _kDrawFilled, 60);
				pp.vis(4);
			}
			else
			{ 
				// cutted
				if(iNotRect)
				{ 
					// special i.e. not rectangular
					dp3.draw(pp, _kDrawFilled);
					brickIsSpecial = 2;// not regular rectangular
				// check the ratio of bottom base with top base
					{ 
						Point3d ptsPP[] = pp.getGripVertexPoints();
						int nIndBottom = - 1;
						double dMin = U(10e4);
						for (int j=0;j<ptsPP.length();j++) 
						{
							Point3d& pt = ptsPP[j]; 
							double d = vecY.dotProduct(pt);
							if(d<dMin)
							{ 
								dMin = d;
								nIndBottom = j;
							}
						}//next j
						ptsPP[nIndBottom].vis(2);
					// bottom length
						double lengthBottom = 0;
						for (int j=0;j<ptsPP.length();j++) 
						{ 
							Vector3d vecBottom = ptsPP[j] - ptsPP[nIndBottom];
							if(abs(vecBottom.dotProduct(vecY))<dEps)
							{ 
								// horizontal
								double dx = abs(vecBottom.dotProduct(vecX));
								if(dx>dEps)
								{ 
									// length not zero
									if(dx>lengthBottom)
									{ 
										lengthBottom = dx;
									}
								}
							}
						}//next j
						// dLengthReal is the length of the envelope (max length)
						double dRatio = lengthBottom / dLengthReal;
						sNotes = "not stable";
						if(dRatio>0.6)
						{ 
							sNotes = "stable";
						}
						else
						{ 
							sNotes = "not stable";
						}
					}
										
					// take the posnum of the brick
					{ 
						for (int ii=0;ii<tsl3dBricks.length();ii++) 
						{ 
							TslInst t = tsl3dBricks[ii];
							if (abs(t.propDouble("X") - ptBrickHardwareX) < dEps
							 && abs(t.propDouble("Y") - ptBrickHardwareY) < dEps
							 && abs(t.propDouble("Z") - ptBrickHardwareZ) < dEps)
							 { 
							 	// position of existing tsl same with this brick, take its posnum
							 	i3dBrickPosnum = t.posnum();
							 	break;
							 }
						}//next ii
					}
					
					if (_bOnRecalc && (_kExecuteKey==sTriggerGenerateSpecialBricks))
					{
					// create 3dbrick TSL for this special brick is triggeres by the command
						TslInst tslNew;			Vector3d vecXTsl= vecX;			Vector3d vecYTsl= vecY;
						GenBeam gbsTsl[] = {};	Entity entsTsl[] = {_ThisInst,tslCourse};	Point3d ptsTsl[] = {ptBrick};
						int nProps[]={};		double dProps[]={};				String sProps[]={};
						Map mapTsl;
						mapTsl.appendPlaneProfile("planeProfile", pp);// save plane profile into map
						mapTsl.setDouble("width", dWidth);
						
						mapTsl.setDouble("dOffsetX", ptBrickHardwareX);
						mapTsl.setDouble("dOffsetY", ptBrickHardwareY);
						mapTsl.setDouble("dOffsetZ", ptBrickHardwareZ);
						mapTsl.setString("sBrickTypeMap", T("|Special|"));
						
						entsTsl.append(el);// save wall into entities
									
						tslNew.dbCreate("hsbBrick-3dBricks" , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
						
					}
				}
				else
				{
					// rectangular but cutted 
					dp.draw(pp, _kDrawFilled);
					brickIsSpecial = 1;// not regular non-rectangular
				}
			}
			// write hardware
			if(pp.area()>dEps)
			{ 				
				HardWrComp hwc(sFamily, 1); //the articleNumber and the quantity is mandatory
				
				String sDescription = " " + brickIsSpecial + " " + sNotes + " PosNum: " + i3dBrickPosnum;
				hwc.setDescription(sDescription);
				hwc.setGroup(el.elementGroup().name());
				hwc.setLinkedEntity(el);
				hwc.setCategory(T("|Brick|"));
				hwc.setRepType(_kRTTsl); //the repType is used to distinguish between predefined and custom components
				hwc.setNotes(sWallNr);
				//
				hwc.setDScaleX(dLengthReal);
				hwc.setDScaleY(dWidth);
				hwc.setDScaleZ(dHeightReal);
				// rotation
				hwc.setDAngleA(dRotation);
				//
				hwc.setDOffsetX(ptBrickHardwareX);
				hwc.setDOffsetY(ptBrickHardwareY);
				hwc.setDOffsetZ(ptBrickHardwareZ);
				
				// apppend component to the list of components
				hwcs.append(hwc);
			}
		}//next i
		
		// store last brick information for first (odd) and second (even) raw
		if (rowIndex == 0)
		{
			mapXSave.setDouble("ButtJoint", dButtJoint);
			// when saving the point for the next distribution, remove the joint height of the first row 
			Point3d ptNextDistribution = ptBrick - dCourseHeight * _ZW + dModule * vecX;
			mapXSave.setPoint3d("ptBrick", ptNextDistribution);// get the information only for the first layer of bricks
		}
		if(rowIndex==1)
		{
			Point3d ptNextDistribution = ptBrick - (dCourseHeight+dModuleHeight) * _ZW 
											+ dModule * vecX;
			mapXSave.setPoint3d("ptBrick2", ptNextDistribution);
			_ThisInst.setSubMapX("hsbBrickData", mapXSave);
		}
		
		isEvenRow = ! isEvenRow;	
		rowIndex++;
	}
	_ThisInst.setHardWrComps(hwcs);	
	
//End draw the brick plane profiles//endregion 

//region recalculate all 3d bricks to get the brick distribution and have the dependency

// when the 3d bricks are generated, this tsl will run another time, so it will change
// and what is saved in 3dBricks will be another tsl. When recalculated, the 3dBrick tsl will
// be triggered and will have the last state of this tsl
	
	Group grp();
	Entity arEnt[] = grp.collectEntities(true, TslInst(), _kModelSpace);
	TslInst tsl;
	String sTslName = "hsbBrick-3dBricks";
	
	// loop all collected entities and get those hsbBrick-SpecialBricks
	for (int i=arEnt.length()-1; i>=0 ; i--)
	{ 
		TslInst t = (TslInst)arEnt[i];
		
		if(t.scriptName() !=sTslName)
		{ 
			continue;
		}
		Entity ents[] = t.entity();
		for (int j=0;j<ents.length();j++)
		{ 
			TslInst tt = (TslInst)ents[j];
			if (tt == _ThisInst)
			{ 
				t.recalc();
				break;
			}
		}//next j
	}//next i
	
//End recalculate all 3d bricks//endregion
	
	if(bDebug)reportMessage("\n" + scriptName() + " " +_ThisInst.handle() +  " ended");
	
#End
#BeginThumbnail










#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="TslInfo">
    <lst nm="TSLINFO">
      <lst nm="TSLINFO">
        <lst nm="TSLINFO">
          <lst nm="TSLINFO">
            <lst nm="TSLINFO">
              <lst nm="TSLINFO">
                <lst nm="TSLINFO" />
              </lst>
            </lst>
          </lst>
        </lst>
      </lst>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End