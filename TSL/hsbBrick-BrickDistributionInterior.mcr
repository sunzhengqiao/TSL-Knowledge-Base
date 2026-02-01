#Version 8
#BeginDescription
version value="2.18" date="02.10.2020" author="marsel.nakuci@hsbcad.com" 

HSB-7896: dButtJointMin/Max should be taken from the mapX of course TSL
HSB-5503 fix bug when brick is divided into 2 when intersected with X-connection 
HSB-5503 implement for X-intersections
cosmetic 
read the posnum and write it in description in hardware
shrink and extend ppfacade and ppopening to correct calculation </version> 
recalculate hsbBrick-3dBricks each time the TSL is modified
3d bricks at "T" intersection of interior walls was missing
add command to generate 3d bricks
bug fix at the gap of bricks when grip point on the right side
change name
ppFacadeOdd starts after 1 joint when bIsIntersectedCorners[0]
export for intersecting walls was missing
improve calculation for grip points
new TSL created only for the calculation of internal walls

This tsl calculates and generated brick distribution for internal walls.
walls that are intersected by "T" walls are divided into distribution areas
similar to external walls for openings
Each distribution are between the start/end of wall and intersection
or between 2 intersection is calculated as a separate TSL instance
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 18
#KeyWords micasa, interior, brick, distribution, horizontal
#BeginContents
/// <History>//region
/// <version value="2.18" date="02.10.2020" author="marsel.nakuci@hsbcad.com"> HSB-7896: dButtJointMin/Max should be taken from the mapX of course TSL </version>
/// <version value="2.17" date="26.08.2019" author="marsel.nakuci@hsbcad.com"> HSB-5503 fix bug when brick is divided into 2 when intersected with X-connection </version>
/// <version value="2.16" date="21.08.2019" author="marsel.nakuci@hsbcad.com"> HSB-5503 implement for X-intersections </version>
/// <version value="2.15" date="19.08.2019" author="marsel.nakuci@hsbcad.com"> HSB-5503 if (ptsOnOther.length() > 0) </version>
/// <version value="2.14" date="14jun2019" author="marsel.nakuci@hsbcad.com"> cosmetic </version>
/// <version value="2.13" date="14jun2019" author="marsel.nakuci@hsbcad.com"> read the posnum and write it in description in hardware </version>
/// <version value="2.12" date="11jun2019" author="marsel.nakuci@hsbcad.com"> shrink and extend ppfacade and ppopening to correct calculation </version>
/// <version value="2.11" date="03jun2019" author="marsel.nakuci@hsbcad.com"> recalculate hsbBrick-3dBricks each time the TSL is modified </version>
/// <version value="2.10" date="30may2019" author="marsel.nakuci@hsbcad.com"> 3d bricks at "T" intersection of interior walls was missing</version>
/// <version value="2.9" date="30may2019" author="marsel.nakuci@hsbcad.com"> add command to generate 3d bricks  </version>
/// <version value="2.8" date="27may2019" author="marsel.nakuci@hsbcad.com"> bug fix at the gap of bricks when grip point on the right side </version>
/// <version value="2.7" date="03may2019" author="marsel.nakuci@hsbcad.com"> change name </version>
/// <version value="2.6" date="26apr2019" author="marsel.nakuci@hsbcad.com"> ppFacadeOdd starts after 1 joint when bIsIntersectedCorners[0] </version>
/// <version value="2.5" date="26apr2019" author="marsel.nakuci@hsbcad.com"> export for intersecting walls was missing </version>
/// <version value="2.4" date="01apr2019" author="marsel.nakuci@hsbcad.com"> improve calculation for grip points </version>
/// <version value="2.3" date="01apr2019" author="marsel.nakuci@hsbcad.com"> new TSL created only for the calculation of interior walls </version>
/// <version value="2.2" date="18mar2019" author="marsel.nakuci@hsbcad.com"> add grip points at interior walls for correcting horizontal distribution </version>
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
/// This tsl calculates and generated brick distribution for interior walls.
/// It is normally called by hsbBrick-CourseDistribution
/// walls that are intersected by "T" walls are divided into distribution areas
/// similar to exterior walls for openings
/// Each distribution area between the start/end of wall and intersection
/// or between 2 intersections is calculated as a separate TSL instance
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbBrick-BrickDistributionInterior")) TSLCONTENT
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
	
//region reference point common for all distributions
	
	Point3d ptRefBuilding;
	
//End reference point common for all distributions//endregion 
    
	
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
		// Trigger Add PLine
		String sTriggerAddPLine = T("|AddPLine|");
		addRecalcTrigger(_kContext, sTriggerAddPLine );
		if (_bOnRecalc && (_kExecuteKey==sTriggerAddPLine || _kExecuteKey==sDoubleClick))
		{
			_Entity.append(getEntPLine());
			setExecutionLoops(2);
			return;
		}
	}
	
//End some debug feature//endregion
	
	
//region definition of trigger for generation of special bricks
	String sTriggerGenerateSpecialBricks = T("|Generate 3d of special bricks|");
	addRecalcTrigger(_kContext, sTriggerGenerateSpecialBricks );
	
//End definition of trigger for generation of special bricks//endregion

//region definition of trigger for generation of 3d bricks
	String sTriggerGenerate3dBricks = T("|Generate 3d bricks|");
	addRecalcTrigger(_kContext, sTriggerGenerate3dBricks );
	
//End definition of trigger for generation of special bricks//endregion
	
//region trigger for delete special bricks and calculation
	String sTriggerDeleteSpecialBricks = T("|Delete 3d of special bricks|");
	addRecalcTrigger(_kContext, sTriggerDeleteSpecialBricks );
	
//End trigger for delete special bricks and calculation//endregion

//region trigger for delete 3d bricks and calculation
	String sTriggerDelete3dBricks = T("|Delete 3d bricks|");
	addRecalcTrigger(_kContext, sTriggerDelete3dBricks );
	
//End trigger for delete special bricks and calculation//endregion

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
				if (tt == _ThisInst)
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

//region remove invalid elements

// purge invalid elements
	for (int i=_Element.length()-1; i>=0 ; i--)
	{ 
		if (!_Element[i].bIsKindOf(ElementWall()))
			_Element.removeAt(i);
	}//next i
	
//End remove invalid elements//endregion


//region get brick course distribution from TSL in _Entity

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
			if (_tslCourse.opmName() == "hsbBrick-CourseDistribution")
			{ 
				mapX = _tslCourse.subMapX("hsbBrickData");
				mapFamily = mapX.getMap("Family");
				if (mapFamily.length() < 1)continue;
				
				tslCourse = _tslCourse;
				setDependencyOnEntity(tslCourse);
				nZone = tslCourse.propInt(T("|Zone|"));
				dButtJointMinMapx = mapX.getDouble("dButtJointMin");// needed for mode 0
//				dButtJointMin.set(dButtJointMinMapx);
				dButtJointMaxMapx = mapX.getDouble("dButtJointMax");// needed for mode 0
//				dButtJointMax.set(dButtJointMaxMapx);
				Point3d ptRefBuildingMapx = mapX.getPoint3d("ptRefBuilding");
				ptRefBuilding = ptRefBuildingMapx;
				if (!bDebug) break;
			}
		}
		else if (_Entity[i].bIsKindOf(EntPLine()))
		{
			debugPLine = ((EntPLine)_Entity[i]).getPLine();
		}
	}
	
//End get brick course distribution from TSL in _Entity//endregion 
	
	
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
 	
//End standards, assign distribution to the element group//endregion	
	
//region Purge elements, create opening profile and get distributrion points.
	
// purge elements not in same Z-plane
	PlaneProfile ppOpening(csZone);
	ElementWall elWall = (ElementWall)_Element[0];
	int isExterior = elWall.exposed();
	if(isExterior)
	{ 
		// exterior walls not allowed
		reportMessage(TN("|Exterior walls not allowed|"));
		eraseInstance();
		return;
	}
	
	Point3d ptsOpStart[0], ptsOpEnd[0], ptsEl[0];
	
	for (int i = _Element.length() - 1; i >= 0; i--)
	{ 
		Element el2=_Element[i];
		CoordSys cs2 =el2.coordSys();
		Vector3d vecZ2 = cs2.vecZ();
		Point3d ptOrg2 = cs2.ptOrg();
		
		if (i != 0 && ( ! vecZ2.isCodirectionalTo(vecZ) || abs(vecZ.dotProduct(ptOrg2 - ptOrg)) > dEps))
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
//End Purge elements, create opening profile and get distributrion points.//endregion 
	
	
//region get distribution profile and distinguish male/female connection
	
	PlaneProfile ppFacade(csZone);
	int bIsMaleCorners[2]; // 0 = left end , 1 = right end
	int bIsFemaleCorners[2];
	int bIsEndCorners[2]; // neither male nor female, an end corner
	int bIsIntersectedCorners[2];// T-intersections
	int bIsIntersected = 0; // if wall gets intersected in T-connection
	Point3d ptsIntersectedStart[0]; // intersection points for each intersecting wall
	Point3d ptsIntersectedEnd[0]; // intersection points for each intersecting wall
	// X-intersection
	int bIsXintersected = 0;
	// X-intersected elements
	Element elXintersected[0];
	// X-intersected walls can be female or male
	int bIsXfemale = true; //initialize
	// Initially a wall has end connections
	bIsEndCorners[0] = true;// initialize
	bIsEndCorners[1] = true;// initialize
	// it is important that for a particular facade there should be only 1 wall along its length
	// 1 continuous wall from the begginning until the end
	// if the facade is drawn with more walls in its length the algorithm will fail
	if (bDebug)reportMessage("\n" + scriptName() + " _Element.length(): " + _Element.length());
	for (int i = 0; i < _Element.length(); i++)
	{
		ElementWallSF el1 = (ElementWallSF)_Element[i];
		PlaneProfile pp(csZone);
		pp.joinRing(el1.plEnvelope(),_kAdd);//envelope of the element for the ppFacade	
		
		PLine plOutlineWall = el1.plOutlineWall();
		PlaneProfile ppOutlineWall(plOutlineWall);
		Point3d ptsThis[] = Line(ptOrg, vecX).orderPoints(plOutlineWall.vertexPoints(true));
		LineSeg seg0 = el1.segmentMinMax();// wall segment
		
		ElemZone zone = el1.zone(nZone);//zone.vecZ().vis(zone.ptOrg(),6);
		
	//region loop connected walls
		Element elConnections[] = el1.getConnectedElements();// walls connected to this wall
		if (bDebug)reportMessage("\n" + scriptName() + " elConnections.length(): " + elConnections.length());
		
		for (int j = elConnections.length() - 1; j >= 0; j--)
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
			int nOnThis=0,nOnOther=0;
			Point3d ptsOnThis[0],ptsOnOther[0];
			// points at the other wall
			for (int p = 0; p < ptsOther.length(); p++)
			{
				double d = (ptsOther[p]-plOutlineWall.closestPointTo(ptsOther[p])).length();// length of vector
				if (d < dEps)
				{
					ptsOnThis.append(ptsOther[p]);// collect connecting points between 2 walls
					nOnThis++;// count points of wall in el2 that are connected with wall in el1
				}
			}
			// points at this wall
			for (int p = 0; p < ptsThis.length(); p++)
			{
				double d = (ptsThis[p]-plOther.closestPointTo(ptsThis[p])).length();// length of vector
				if (d < dEps)
				{
					ptsOnOther.append(ptsThis[p]);
					nOnOther++;
				}
			}
			
		//End points on the contours//endregion 
		
		// corner connections
			int bIsFemale = (nOnThis == 2 && nOnOther == 1);
			int bIsMale = ((nOnThis==1||nOnThis==0) && nOnOther==2);//when wall intersects is als a male 
			int bIsIntersection = (nOnThis == 2 && nOnOther == 0);
			int bIsEnd = !(bIsFemale || bIsMale || bIsIntersection);// end connection no female, no male
//			if ((!bIsMale && !bIsFemale &&!bIsEnd) || !bIsPerpendicular) {continue;}
			
			if(bIsIntersection)
			{ 
				// if more then 1 intersected wall, it will be set to true many times
				bIsIntersected = true;
				if(ptsOnThis.length()<2)
				{ 
					// not possible
					reportMessage(TN("|unexpected error|"));
					eraseInstance();
					return;
				}
				ptsOnThis = lnX.orderPoints(ptsOnThis, dEps);// order points in X
				ptsIntersectedStart.append(ptsOnThis[0]);
				ptsIntersectedEnd.append(ptsOnThis[1]);
			}
			if(!(bIsFemale || bIsMale || bIsEnd))
			{ 
				// it is neither a female nor male nor end connection
				continue;
			}
			
			Vector3d vecSide = vecX;
			
			// 
			if (ptsOnOther.length() > 0)
			{ 
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
			}
			else
			{ 
				// if the wall is not exactly connected to the other wall 
				// it might still be counted as connection but the ptsOnOther.length() will be zero
				// this case will be treated as end connection
				continue;
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
			if ((ptEndA - ptIntersectA).length() > (ptStartA - ptIntersectA).length())
			{ 
				//
				vec0A1 = ptEndA - ptIntersectA;
			}
			vec0A1.normalize();//X0A1
			
			// X0A1 for wall B
			Vector3d vec0B1 = ptStartB - ptIntersectB;
			if ((ptEndB - ptIntersectB).length() > (ptStartB - ptIntersectB).length())
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
//			ptInt.vis(2);
		// find extreme index
			if (abs(dMove)>dEps)
			{
				int nInd = -1;
				Point3d ptsV[] = pp.getGripEdgeMidPoints();
				double dMax=-U(10e4);
				for (int j=0;j<ptsV.length();j++) 
				{
					Point3d& pt = ptsV[j]; 
					double d = vecSide.dotProduct(pt);
					if (d>dMax)
					{
						dMax=d;
						nInd = j;
					}
				}//next j
				
				if (nInd>-1 )
				{
					//ptsV[nInd].vis(2);
					int bOk=pp.moveGripEdgeMidPointAt(nInd, vecSide*dMove);
				}
			}
		}//next j
		
		// check if wall is X-intersected with any of the other walls
		Entity entsOtherWalls[] = _Map.getEntityArray("entsOtherWalls", "", "");
		if (entsOtherWalls.length() > 0)
		{ 
			for (int j = 0; j < entsOtherWalls.length(); j++)
			{ 
				Element eJ = (Element) entsOtherWalls[j];
				PLine plOutlineWallOther = eJ.plOutlineWall();
				PlaneProfile ppOutlineWallOther(plOutlineWallOther);
				PlaneProfile _ppOutlineWall = ppOutlineWall;
				if (_ppOutlineWall.intersectWith(ppOutlineWallOther))
				{ 
					// x-intersection
					elXintersected.append(eJ);
					bIsXintersected = true;
					// see if is female or male
				// get extents of profile
					{ 
						// length of ppOutlineWall
						LineSeg seg = ppOutlineWall.extentInDir(vecX);
						double dX1 = abs(vecX.dotProduct(seg.ptStart() - seg.ptEnd()));
						// length of ppOutlineWallOther
						LineSeg seg2 = ppOutlineWallOther.extentInDir(eJ.vecX());
						double dX2 = abs(eJ.vecX().dotProduct(seg2.ptStart() - seg2.ptEnd()));
						// if the wall is longer then all the walls that cross it then it is a female wall
						// otherwise it is a male wall
						if(bDebug)reportMessage("\n"+ scriptName() + " dX1: "+dX1);
						if(bDebug)reportMessage("\n"+ scriptName() + " dX2: "+dX2);
						
						if (dX1 < dX2)
						{ 
							bIsXfemale = false;
						}
					}
				}
			}//next j
			if (bDebug)reportMessage("\n" + scriptName() + " nr x-intersected elements: " + elXintersected.length());
			if (bDebug)reportMessage("\n" + scriptName() + " bIsXfemale " + bIsXfemale);
			
		}
	//End loop connected walls//endregion 
	// combine multiple floors
		if (ppFacade.area() < pow(dEps, 2))
			ppFacade = pp;
		else
			ppFacade.unionWith(pp);// add the aditional area from the normal wall
	}
//End get distribution profile//endregion
	
//region start and end points from intersecting wall; each intersecting wall has a start and an end point
 	
	if (ptsIntersectedStart.length() != ptsIntersectedEnd.length())
	{ 
		reportMessage(TN("|unexpected error|"));
		eraseInstance();
		return;
	}
	
//End start and end points from intersecting wall; each intersecting wall has a start and an end point//endregion
	
//region order horizontally ptsIntersectedStart and ptsIntersectedEnd
	
// order horizontally
	if (ptsIntersectedStart.length() > 0)
	{
		ptsIntersectedStart = lnX.orderPoints(lnX.projectPoints(ptsIntersectedStart), dEps);
		ptsIntersectedEnd = lnX.orderPoints(lnX.projectPoints(ptsIntersectedEnd), dEps);
	}
	
//End order horizontally ptsIntersectedStart and ptsIntersectedEnd//endregion
	
//region Create brick distributions for each distribution area, separated by intersecting walls
	
	int mode = _Map.getInt("Mode");
	//create first butt distributions during creation
	if (mode == 0)
	{
		// set the min max butt joint for mode=0
		dButtJointMin.set(dButtJointMinMapx);
		dButtJointMax.set(dButtJointMaxMapx);
		
		// create TSL
		TslInst tslNew;
		GenBeam gbsTsl[] = { };		Entity entsTsl[] = { tslCourse};		Point3d ptsTsl[] = {ptZoneOrg};
		int nProps[] ={ };
		// HSB-7896: dButtJointMin/Max should be taken from the mapX of course TSL
		double dProps[] ={dButtJointMin,dButtJointMax };
		String sProps[] ={ };
		Map mapTsl;
		mapTsl.setInt("Mode", 1);
		for (int i = 0; i < _Element.length(); i++)
			entsTsl.append(_Element[i]);// every tsl knows about all walls
		// save in map all other walls needed for the X-intersection
		Entity entsOtherWalls[] = _Map.getEntityArray("entsOtherWalls", "", "");
		mapTsl.setEntityArray(entsOtherWalls, true, "entsOtherWalls", "", "");
		tslNew.dbCreate(scriptName() , vecX , vecY, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		if (tslNew.bIsValid())
		{
			tslNew.recalc();
			if (bDebug)reportMessage("\n" + tslNew.handle() + " updated");
		}
		
		// for each T-intersection generate a TSL
		
		// generate a TSL instance for each distribution area
			for (int i = 0; i < ptsIntersectedStart.length(); i++)
			{
				Point3d pt = ptsIntersectedStart[i];
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
	
//region ppFacade without opening
	
	PlaneProfile ppFacadeCopy = ppFacade;
	ppFacadeCopy.shrink(-U(10));
	ppFacadeCopy.shrink(U(10));
	ppFacade = ppFacadeCopy;
	
	PlaneProfile ppOpeningCopy = ppOpening;
	ppOpeningCopy.shrink(-U(10));
	ppOpeningCopy.shrink(U(10));
	ppOpening = ppOpeningCopy;
	
	ppFacade.subtractProfile(ppOpening);

//End ppFacade without opening//endregion 
	
//region get brick data from mapFamily, nColorBrick, dLength, dWidth, dHeight, sFamily
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
	
//End get brick data//endregion 
	
	
//region get all TSL of brick distributions, order them in vecX, find the position of this_inst
// for each brick distribution generate one TslInst tslBricks
	TslInst tslBricks[0];
	Point3d ptOrgs[0];
	String sScriptName = _bOnDebug ? "hsbBrick-BrickDistributionInterior" : scriptName();
	
	for (int i=0;i<_Element.length();i++) // all elements of this TSL (interior walls only 1 wall)
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
	for (int i = 0; i < tslBricks.length(); i++)
		for (int j = 0; j < tslBricks.length() - 1; j++)
			if (vecX.dotProduct(ptOrgs[j]) > vecX.dotProduct(ptOrgs[j + 1]))
			{
				tslBricks.swap(j, j + 1);
				ptOrgs.swap(j, j + 1);	
			}
	// find my index
	int n = tslBricks.find(_ThisInst);
	
//End get all TSL of brick distributions, order them in vecX, find the position of this_inst //endregion 
	
	
//region set dependency of this_inst with all other distributions
	
	if (debugPLine.area() > pow(U(10), 2))
	{
		n = 0;
		tslBricks.setLength(0);
		ppFacade = PlaneProfile(ppFacade.coordSys());
		ppFacade.joinRing(debugPLine, _kAdd);
	}
	
	if (n<0)
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
	
	
//region indications which corner is intersected, start or end corner
	
	if(bIsIntersected)
	{ 
		// tslBricks.length()-1 > 0
		if(n==0)// start
		{ 
			// start distribution has intersection at end
			bIsIntersectedCorners[1] = true;
		}
		else if(n>0 && n<tslBricks.length()-1)// middle
		{ 
			// middle distribution is at start and end intersected
			bIsIntersectedCorners[0] = true;
			bIsIntersectedCorners[1] = true;
		}
		else if(n>0 && n== tslBricks.length()-1)// end
		{ 
			// end distribution is intersected at start
			bIsIntersectedCorners[0] = true;
		}
	}
	
//End indications which corner is intersected, start or end corner//endregion
	
	
//region FFind distribution range for this distribution

	LineSeg segFacade = ppFacade.extentInDir(vecX);
//	ppFacade.vis(2);
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
	if(bIsIntersected)
	{ 
		// project to the plane of the zone
		for (int i=0;i<ptsIntersectedStart.length();i++) 
		{ 
			ptsIntersectedStart[i] = pnZone.closestPointTo(ptsIntersectedStart[i]);
			ptsIntersectedStart[i].vis(3);
			ptsIntersectedEnd[i] = pnZone.closestPointTo(ptsIntersectedEnd[i]);
			ptsIntersectedEnd[i].vis(3);
		}//next i
	}
	ptStart.vis(5);
	ptEnd.vis(5);
	
// nomber of distribution areas between intersecting walls
	PlaneProfile ppRange(csZone);
	ppRange.createRectangle(LineSeg(ptStart - vecY * U(10e5), ptEnd + vecY * U(10e5)), vecX, vecY);
	ppRange.intersectWith(ppFacade);
	ppRange.vis(n);
	
	Display dp(n);
	//dp.draw(ppRange, _kDrawFilled, 80);
	dp.draw(ppRange);
	
//End Find distribution range for this distribution//endregion 	
	
//region depending on type of distribution, find start of distribution, ending and its range; do optimisation
	
	Point3d ptStartRange = ptStart;
	if (n>0)
	{
		Map mapX = tslBricks[n - 1].subMapX("hsbBrickData");
		int iHasPoint = mapX.hasPoint3d("ptBrick");
		if ( ! iHasPoint)return;
		ptStartRange = mapX.getPoint3d("ptBrick");// gets from previous distribution
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
	if(dRange<dEps)
	{
		// in first run it can be that the boundaries are not yet established
		// this makes sure calculation does not continue and the 
		// calculation is run another time
		return;
	}
	
//End depending on type of distribution, find start of distribution, ending and its range; do optimisation//endregion
	
//region calculate the butt joint width from optimisation; calc min and max nr of bricks that can fit for each distribution type (full, half, 1/4, 3/4)

	ptStartRange.vis(4);
//	ptEnd.vis(4);
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
	endsAtOpeningStart = true;
	for (int i=0;i<distribTypes.length();i++) 
	{
	//1- for middle distributions
		// min nr of bricks that can fit with an additional 1/4 brick
		if (n>0 && n<(tslBricks.length()-1))
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
		
	//2- for start distributions
		if(n==0 && n<(tslBricks.length()-1))
		{
			if(bIsFemaleCorners[0])//female or End
			{
				// female-> starts with brick
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
			if(bIsMaleCorners[0])
			{
				// male->starts with mortar
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
			if(bIsEndCorners[0])//End
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
	// set to the readonly property
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
//	for (int i=0;i<nNumBrick+2;i++)// loop in bricks of a row ////
	{ 
		//1,4- middle distributions
		if(n>0 && n<=tslBricks.length()-1)
		{ 
			double dX = 0.0;// + i * dModule;
			dXOdd.append(dX);
			dLengthsOdd.append(dLength);
			dX = dX + .5 * dModule;
			dXEven.append(dX);
			dLengthsEven.append(dLength);
		}
		 
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
	}//next i
	
	
	// modify the starting when intersection in the beginning
	if(bIsIntersected)
	{ 
		// intersection
		if(bIsIntersectedCorners[0])
		{ 
			// special placement done only when
			// intersection at second cornen
			for (int i=0;i<dXOdd.length();i++) 
			{ 
				dXOdd[i] += dButtJoint;
			}//next i
			for (int i=0;i<dXEven.length();i++) 
			{ 
				dXEven[i] += dButtJoint;
			}//next i
		}
	}

//End prepare arrays with brick positions//endregion 
	
//region ppFacadeOdd and ppFacadeEven, needed fo the start and en distributions, n=0 or n==tslBricks.length()-1

	// plane profile for even bricks and odd bricks at the end of the facade
	PlaneProfile ppFacadeEven = ppFacade;
	PlaneProfile ppFacadeOdd = ppFacade;
	PlaneProfile ppFacadeIntersection[3];
	ppFacadeIntersection[0] = ppFacade;// for the layer 1
	ppFacadeIntersection[1] = ppFacade;// for the layer 2
	ppFacadeIntersection[2] = ppFacade;// for the layer 3
	// for X-intersection
	PlaneProfile ppFacadeXintersection[elXintersected.length()];
	for (int i = 0; i < ppFacadeXintersection.length(); i++)
	{ 
		ppFacadeXintersection[i] = ppFacade;
	}//next i
	
	
// reverse the previously change for the ptEnd
	if (bIsMaleCorners[1] && n==(tslBricks.length()-1))// ending wall and male
	{ 
		// ptEnd is the max of odd and even
		ptEnd = ptEnd + vecX * dWidth;
	}
	Vector3d vecSide = vecX;
	if ((ptEnd - ptStart).dotProduct(vecX) < 0)
	{ 
		vecSide *= -1;
	}
	vecSide.vis(ptStart, 2);
	
// get index of the Left edge 
	int nInd = -1;
	Point3d ptsVE[] = ppFacadeEven.getGripEdgeMidPoints();
	double dMin=U(10e4);
	for (int j = 0; j < ptsVE.length(); j++)
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
		double d = vecSide.dotProduct(pt-ptStart);
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
	// intersection
	if(bIsIntersected)
	{ 
		// all cases for a distribution area
		if(bIsIntersectedCorners[0])
		{ 
			// starts with intersection
			Point3d pt1 = ptStartRange + vecY * U(10e5);
			Point3d pt2 = ptStartRange - vecX * 6 * dLength - vecY * U(10);
			LineSeg seg(pt1, pt2);
			PLine pl;
			pl.createRectangle(seg, vecX, vecY);
			PlaneProfile pp(pl);
			PlaneProfile ppFacade2 = ppFacade;
			ppFacade2.intersectWith(pp);
			ppFacadeIntersection[0].subtractProfile(ppFacade2);
//			ppFacadeIntersection[0].vis(2);

			// layer 2
			pt1 = ptStartRange + vecX * (dWidth + dButtJoint) + vecY * U(10e5);
			pt2 = ptStartRange - vecX * 6 * dLength - vecY * U(10);
			LineSeg seg2(pt1, pt2);
			pl.createRectangle(seg2, vecX, vecY);
			PlaneProfile pp2(pl);
			ppFacade2 = ppFacade;
			ppFacade2.intersectWith(pp2);
			ppFacadeIntersection[1].subtractProfile(ppFacade2);
//			ppFacadeIntersection[1].vis(2);

			// layer 3
			pt1 = ptStartRange + vecX * (dLength + dButtJoint) + vecY * U(10e5);
			pt2 = ptStartRange - vecX * 6 * dLength - vecY * U(10);
			LineSeg seg3(pt1, pt2);
			pl.createRectangle(seg3, vecX, vecY);
			PlaneProfile pp3(pl);
			ppFacade2 = ppFacade;
			ppFacade2.intersectWith(pp3);
			ppFacadeIntersection[2].subtractProfile(ppFacade2);
//			ppFacadeIntersection[2].vis(2);

			// ppFacadeOdd must start 1 joint after
			pt1 = ptStartRange - vecY * U(10e2);
			pt2 = ptStartRange + vecX * dButtJoint + vecY * U(10e5);
			LineSeg seg4(pt1, pt2);
			pl.createRectangle(seg4, vecX, vecY);
			PlaneProfile pp4(pl);
			ppFacadeOdd.subtractProfile(pp4);
		}
		if(bIsIntersectedCorners[1])// both cases can be intersected in the beginning and at the end
		{ 
			// ends with intersection
			Point3d pt1 = ptEnd + vecY * U(10) + 4 * dLength * vecX;
			Point3d pt2 = ptEnd - vecY * U(10e5);// - vecX * dButtJoint;
			LineSeg seg(pt1, pt2);
			PLine pl;
			pl.createRectangle(seg, vecX, vecY);
			PlaneProfile pp(pl);
			PlaneProfile ppFacade2 = ppFacade;
			ppFacade2.intersectWith(pp);
			ppFacadeIntersection[0].subtractProfile(ppFacade2);
//			ppFacadeIntersection[0].vis(2);
			
			//2
			pt1 = ptEnd - vecY * U(10e5) - vecX * (.5 * dLength + 2*dButtJoint);
			pt2 = ptEnd + vecY * U(10) + vecX * 4 * dLength;
			LineSeg seg2(pt1, pt2);
			pl.createRectangle(seg2, vecX, vecY);
			PlaneProfile pp2(pl);
			ppFacade2 = ppFacade;
			ppFacade2.intersectWith(pp2);
			ppFacadeIntersection[1].subtractProfile(ppFacade2);
//			ppFacadeIntersection[1].vis(3);
			
			// 3
			pt1 = ptEnd - vecY * U(10e5) - vecX * (dLength + 2*dButtJoint);
			pt2 = ptEnd + vecY * U(10) + vecX * 4 * dLength;
			LineSeg seg3(pt1, pt2);
			pl.createRectangle(seg3, vecX, vecY);
			PlaneProfile pp3(pl);
			ppFacade2 = ppFacade;
			ppFacade2.intersectWith(pp3);
			ppFacadeIntersection[2].subtractProfile(ppFacade2);
//			ppFacadeIntersection[2].vis(4);
		}
	}
	if (bIsXintersected)
	{ 
		//	wall has X intersection
		//elXintersected
		for (int i = 0; i < ppFacadeXintersection.length(); i++)
		{ 
			Element el = elXintersected[i];
			Body bdEl = el.realBody();
			Plane pn(ptOrg, vecZ);
			PlaneProfile pp = bdEl.shadowProfile(pn);
			Point3d pt1, pt2;
			{ 
			// get extents of profile
				LineSeg seg = pp.extentInDir(vecX);
				pt1 = seg.ptStart();
				pt2 = seg.ptEnd();
				if (pt2.dotProduct(vecY) < pt1.dotProduct(vecY))
				{ 
					pt1 = seg.ptEnd();
					pt2 = seg.ptStart();
				}
				pt1 -= vecY * U(10e5) + vecX * dButtJoint;
				pt2 += vecY * U(10e5) + vecX * dButtJoint;
			}
			
			LineSeg seg(pt1, pt2);
			PLine pl;
			pl.createRectangle(seg, vecX, vecY);
			PlaneProfile pp3(pl);
			PlaneProfile ppFacade2 = ppFacade;
			ppFacade2.intersectWith(pp3);
			ppFacadeXintersection[i].subtractProfile(ppFacade2);
		}//next i	
	}
	
	ppFacadeEven.vis(5);
	ppFacadeOdd.vis(5);
	
//End ppFacadeOdd and ppFacadeEven, needed fo the start and en distributions, n=0 or n==tslBricks.length()-1//endregion

	
//region prepare hardware for thisInst; remove any existing hardware

	// Hardware
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
	String sWallNr = el.number();//wall number
	double dRotation = 0.0;// wall rotation
	vecZ.vis(ptStartRange, 3);
	if (vecX.dotProduct(_XW)>0)
	{ 
		dRotation = 0.0;
	}
	else if(vecX.dotProduct(_XW)<0)
	{ 
		dRotation = 180.0;
	}
	else if(vecZ.dotProduct(_XW)>0)
	{ 
		dRotation = 90.0;
	}
	else if(vecZ.dotProduct(_XW)<0)
	{ 
		dRotation = 270;
	}
	// display for not rectangular bricks
	Display dp3(4);
	
//End prepare some data//endregion

//region get the existing 3d bricks, to get their posnum later
	
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
				if (tt == _ThisInst)
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

	// delete previously generated special bricks
	// if command for their calculation is triggered
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

//region set the grip point for each row
 	
// set point of starting of row
	Point3d ptsRowStart[0];
	// points where the row starts in the beginning
	Point3d ptsRowStartFix[0];
// set grip points
	String _PtGNames[0];
	int iIndexGrip = 0;
	
// initialize i3dBrickPosnum
	int i3dBrickPosnum = -1;
	
	//set ptsRowStartFix; Points where initially starts every row of bricks
	isEvenRow = false;
	rowIndex = 0;
	while (_ZW.dotProduct(ptEnd - ptBrick) > dEps)
	{
		// guard infinite loop
		if (rowIndex > 10000) break;
		// place ptBrick at start for odd rows
		Point3d ptBrickStart = ptStartRange + _ZW * dCourseHeight + _ZW * rowIndex * dModuleHeight;
		if(!isEvenRow)
		{
			ptBrick = ptBrickStart + vecX * dXOdd[0];
			ptsRowStartFix.append(ptBrick);
		}
		else if(isEvenRow)
		{ 
			ptBrick = ptBrickStart + vecX * dXEven[0];
			ptsRowStartFix.append(ptBrick);
		}
		isEvenRow = !isEvenRow;	
		rowIndex++;
	}
	// set grip points
	
	
	ptBrick = ptStartRange;
	if(_PtG.length()<1)
	{ 
	// initialize grip points in _PtG
		isEvenRow = false;
		rowIndex = 0;
		while (_ZW.dotProduct(ptEnd - ptBrick) > dEps)
		{
			// guard infinite loop
			if (rowIndex > 10000) break;
			// place ptBrick at start for odd rows
			Point3d ptBrickStart = ptStartRange + _ZW * dCourseHeight + _ZW * rowIndex * dModuleHeight;
			
			if(!isEvenRow)
			{
				ptBrick = ptBrickStart + vecX * dXOdd[0];
				_PtG.append(ptBrick);
				ptsRowStart.append(ptBrick);
			}
			else if(isEvenRow)
			{ 
				ptBrick = ptBrickStart + vecX * dXEven[0];
				_PtG.append(ptBrick);
				ptsRowStart.append(ptBrick);
			}
			isEvenRow = ! isEvenRow;
			rowIndex++;
		}
		// write names
	}
	else
	{ 
		// grip points are already there
		int iGripPropChanged = false;
		String name = "_PtG";
		for (int i=0;i<_PtG.length();i++) 
		{ 
			_PtGNames.append(name + i);
			// see if this is changed
			if(_kNameLastChangedProp==_PtGNames[i])
			{ 
				iGripPropChanged = true;
				iIndexGrip = i;
				break;
			}
		}//next i
		// grip point is moved
		ptsRowStart.setLength(0);
		ptsRowStart.setLength(_PtG.length());
		isEvenRow = false;
		for (int i = 0; i < _PtG.length(); i++)
		{
			Point3d ptBrickStart = ptStartRange + _ZW * dCourseHeight + _ZW * i * dModuleHeight;
			_PtG[i] = Line(ptBrickStart, vecX).closestPointTo(_PtG[i]);
			ptsRowStart[i] = _PtG[i];
			// distance from start to grip point
			double dStartGrip = (_PtG[i] - ptsRowStartFix[i]).dotProduct(vecSide);
			if(dStartGrip>0)
			{ 
				// grip point on the right of the fix starting point
				int iNModules = abs(dStartGrip) / dModule;
				iNModules += 1;
				ptsRowStart[i] = _PtG[i] - vecSide * iNModules * dModule;
			}
		}
	}
	
//End set the grip point for each row//endregion
	
	
//region draw the brick plane profiles
		
	int iIndex[] ={ 0, 1, 2, 1};
	// initialize again if changed at previous loop
	rowIndex = 0;
	ptBrick = ptStartRange;
	isEvenRow = false;
	if(!isExterior)// interior walls
	{ 
		ptBrick = ptStartRange;
		for (int i = 0; i < _PtG.length(); i++)
		{
			int ii = i + 1;
			int iii = (int((i + 1) / 4)) * 4;
			int iModule;
			if (ii == iii) 
			{
				iModule = iIndex[3];
			}
			else
			{ 
				iModule = iIndex[ii - iii - 1];
			}
			// place ptBrick at start for odd rows
//			Point3d ptBrickStart = ptStartRange + _ZW * dCourseHeight + _ZW * i * dModuleHeight;
			Point3d ptBrickStart = _PtG[i] ;
			ptBrickStart = ptsRowStart[i];
			int j = 0;
			// initialize so that it enters the loop
			double dBrickEnd = 2 * dLength;
			while (dBrickEnd > dLength)
			{ 
				i3dBrickPosnum = - 1;
				// guard infinite loop
				if (j > 10000)break;
				// dXOdd, dXEven has the distance of brick from ptstartrange
				// dXOdd[0], dXEven[0] must be removed from dXOdd[i], dXEven[i]
				if(!isEvenRow)
				{
					if(j<dXOdd.length())
					{ 
						ptBrick = ptBrickStart + vecX * dXOdd[j] - dXOdd[0] * vecX;
						dBrickLength = dLengthsOdd[j];
					}
					else
					{ 
						ptBrick +=  vecX * dModule;
						dBrickLength = dLength;
					}
				}
				else if(isEvenRow)
				{ 
					if (j < dXEven.length())
					{ 
						ptBrick = ptBrickStart + vecX * dXEven[j] - dXEven[0] * vecX;
						dBrickLength = dLengthsEven[j];
					}
					else
					{ 
						ptBrick +=  vecX * dModule;
						dBrickLength = dLength;
					}
				}
				
				LineSeg seg(ptBrick, ptBrick + vecX *dBrickLength + vecY * dHeight);
				PlaneProfile pp(csZone);
				pp.createRectangle(seg, vecX, vecY);

				if(isEvenRow)
				{ 
					// here taken ito account also the intersectiong walls
					pp.intersectWith(ppFacadeEven);
				}
				else if(!isEvenRow)
				{ 
					pp.intersectWith(ppFacadeOdd);
				}
				if(bIsIntersected)
				{ 
					pp.intersectWith(ppFacadeIntersection[iModule]);
				}
				if (bIsXintersected)
				{ 
					if (bIsXfemale)
					{ 
						if (isEvenRow)
						{ 
							for (int ii = 0; ii < ppFacadeXintersection.length(); ii++)
							{ 
								pp.intersectWith(ppFacadeXintersection[ii]);
							}//next ii
						}
					}
					else
					{ 
						if ( ! isEvenRow)
						{ 
							for (int ii = 0; ii < ppFacadeXintersection.length(); ii++)
							{ 
								pp.intersectWith(ppFacadeXintersection[ii]);
							}//next ii
						}
					}
				}

				dBrickEnd = (ptEnd - ptBrick).dotProduct(vecX);
				j++;
				if (pp.area() < dEps)continue;
				
				PlaneProfile ppCopy = pp;
				PLine plRings[0];
				plRings = ppCopy.allRings();
				
			// order alphabetically
				for (int ii = 0; ii < plRings.length(); ii++)
				{ 
					for (int jj = 0; jj < plRings.length() - 1; jj++)
					{ 
						{ 
							PlaneProfile _pp1(pp.coordSys());
							_pp1.joinRing(plRings[jj], _kAdd);
							LineSeg seg1 = _pp1.extentInDir(vecX);
							Point3d ptMid1 = seg1.ptMid();
							
							PlaneProfile _pp2(pp.coordSys());
							_pp2.joinRing(plRings[jj+1], _kAdd);
							LineSeg seg2 = _pp2.extentInDir(vecX);
							Point3d ptMid2 = seg2.ptMid();
							
							if (ptMid2.dotProduct(vecX) < ptMid1.dotProduct(vecX))
							{ 
								plRings.swap(jj, jj+1);
							}
						}
					}			
				}		
				for (int ii = 0; ii < plRings.length(); ii++)
				{ 
					PlaneProfile _pp(pp.coordSys());
					_pp.joinRing(plRings[ii], _kAdd);
					pp = _pp;
				
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
					if (_bOnRecalc && (_kExecuteKey == sTriggerGenerate3dBricks))
					{
						// create new instance
						// create TSL
						TslInst tslNew;			Vector3d vecXTsl= vecX;			Vector3d vecYTsl= vecY;
						GenBeam gbsTsl[] = {};	Entity entsTsl[] = {_ThisInst,tslCourse};	Point3d ptsTsl[] = {ptBrick};
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
					
					
					int brickIsSpecial = 0;// regular
					String sNotes = "";// tells if (top base)/(bottom base) > 60%
					// check if it is not rectangular
					int iNotRect = false;
					double dAreaReal = pp.area();
					double dAreaRect = dLengthReal * dHeightReal;
					
					// check if not rectangular shape
					if (abs(dAreaReal - dAreaRect) > dEps)
					{ 
						iNotRect = true;// not a rectangular shape
					}
					
					if (abs(pp.area() - dBrickArea) < dEps)
					{ 
					// regular brick
						dp.draw(pp, _kDrawFilled, 60);
					}
					else
					{ 
						// not regular
						if(iNotRect)
						{ 
							// special but not rectangular
							dp3.draw(pp, _kDrawFilled);
							brickIsSpecial = 2;// not regular rectangular
							// check the ratio of bottom base with top base
							{ 
								Point3d ptsPP[] = pp.getGripVertexPoints();
								int nIndBottom = - 1;
								double dMin = U(10e4);
								for (int j = 0; j < ptsPP.length(); j++)
								{
									Point3d& pt = ptsPP[j]; 
									double d = vecY.dotProduct(pt);
									if (d < dMin)
									{ 
										dMin = d;
										nIndBottom = j;
									}
								}//next j
								ptsPP[nIndBottom].vis(2);
							// bottom length
								double lengthBottom = 0;
								for (int j = 0; j < ptsPP.length(); j++)
								{ 
									Vector3d vecBottom = ptsPP[j] - ptsPP[nIndBottom];
									if (abs(vecBottom.dotProduct(vecY)) < dEps)
									{ 
										// horizontal
										double dx = abs(vecBottom.dotProduct(vecX));
										if (dx > dEps)
										{ 
											// length not zero
											if (dx > lengthBottom)
											{ 
												lengthBottom = dx;
											}
										}
									}
								}//next j
								// dLengthReal is the length of the envelope (max length)
								double dRatio = lengthBottom / dLengthReal;
								sNotes = "not stable";
								if (dRatio > 0.6)
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
									 	i3dBrickPosnum = t.posnum();
									 	break;
									 }
								}//next ii
							}
							
							if (_bOnRecalc && (_kExecuteKey == sTriggerGenerateSpecialBricks))
							{
								// create new instance
								// create TSL
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
		//							setExecutionLoops(2);
		//							return;
							}	
						}
						else
						{
							// special but rectangular
							dp.draw(pp, _kDrawFilled);
							brickIsSpecial = 1;// not regular non-rectangular
						}
					}
	
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
					
					hwc.setDOffsetX(ptBrickHardwareX);
					hwc.setDOffsetY(ptBrickHardwareY);
					hwc.setDOffsetZ(ptBrickHardwareZ);
				// apppend component to the list of components
					hwcs.append(hwc);
				
				}//next ii
			}//while
			
			if (rowIndex == 0)
			{
				// publish distribution data
				Map mapX;
				mapX.setDouble("ButtJoint", dButtJoint);
//				mapX.setPoint3d("ptBrick", ptBrick + dModule * vecX);// get the information only for the first layer of bricks
				// when saving the point for the next distribution, remove the joint height of the first row
//				Point3d ptNextDistribution = ptBrick - dCourseHeight * _ZW + dModule * vecX;
				Line ln(ptBrick - dCourseHeight * _ZW, vecX);
				// start of next will be at ptEnd of this distribution
				Point3d ptNextDistribution = ln.closestPointTo(ptEnd);
				mapX.setPoint3d("ptBrick", ptNextDistribution);// get the information only for the first layer of bricks
				_ThisInst.setSubMapX("hsbBrickData", mapX);
			}
			// if intersection
			if(bIsIntersected)
			{ 
				if(bIsIntersectedCorners[1])
				{ 
					double dXIntersection[0];
					double dLengthsIntersection[0];
					if(iModule==1)
					{ 
						// second row
						double dx = (ptEnd - vecX * (.5 * dLength + dButtJoint) - ptBrickStart).dotProduct(vecX);
						dXIntersection.append(dx);
						dLengthsIntersection.append(.5 * dLength);
					}
					else if(iModule==2)
					{ 
						// third row
						double dx = (ptEnd - vecX * (dLength + dButtJoint) - ptBrickStart).dotProduct(vecX);
						dXIntersection.append(dx);
						dLengthsIntersection.append(.75 * dLength);
						
						dXIntersection.append(dx + .75 * dLength + dButtJoint);
						dLengthsIntersection.append(.5 * dLength);
						
						dXIntersection.append(dx + 1.25*dLength + 2*dButtJoint);
						dLengthsIntersection.append(.75 * dLength);
					}
					
					for (int k=0;k<dXIntersection.length();k++) 
					{ 
						ptBrick = ptBrickStart + vecX * dXIntersection[k];
						dBrickLength = dLengthsIntersection[k];
						
						LineSeg seg(ptBrick, ptBrick + vecX *dBrickLength + vecY * dHeight);
						PlaneProfile pp(csZone);
						pp.createRectangle(seg, vecX, vecY);
						pp.intersectWith(ppFacade);
						if (pp.area() < dEps)continue;
						// bricks at intersection are not full bricks
						if (!abs(pp.area()-dBrickArea)<dEps)
						{ 
						// not a regular brick
							dp.draw(pp, _kDrawFilled);
						}
						
						int brickIsSpecial = 2;// not regular, rectangular
						String sNotes = "stable";// ratio base/lmax > 60%
						
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
							GenBeam gbsTsl[] = {};	Entity entsTsl[] = {_ThisInst,tslCourse};	Point3d ptsTsl[] = {ptBrick};
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
						}
						
						// hardware
						HardWrComp hwc(sFamily, 1); //the articleNumber and the quantity is mandatory
						String sDescription = " " + brickIsSpecial + " " + sNotes;
						
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
						hwc.setDOffsetX(ptBrickHardwareX);
						hwc.setDOffsetY(ptBrickHardwareY);
						hwc.setDOffsetZ(ptBrickHardwareZ);
					// apppend component to the list of components
						hwcs.append(hwc);
					}//next k
				}
			}
			isEvenRow = ! isEvenRow;	
			rowIndex++;
		}
	}
	
	_ThisInst.setHardWrComps(hwcs);	
	
//endregion draw the brick plane profiles

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
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="TslInfo">
    <lst nm="TSLINFO">
      <lst nm="TSLINFO">
        <lst nm="TSLINFO" />
      </lst>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End