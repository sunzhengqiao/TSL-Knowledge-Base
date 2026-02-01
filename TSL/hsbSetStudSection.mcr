#Version 8
#BeginDescription
version value="1.2" date="13jul2020" author="nils.gregor@hsbcad.com"> HSB-7533 redesigned stretch functionality of vertical beams

This tsl changes the width and/or height of beams, that are specified by a painter rule and that are aligned to the selected side.
All available filters occure in the list. If the list is empty, create a painter rule.
The instance can be attached to an element directly.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <History>//region

/// <version value="1.2" date="13jul2020" author="nils.gregor@hsbcad.com"> HSB-7533 redesigned stretch functionality of vertical beams</version>
/// <version value="1.1" date="16jun2020" author="nils.gregor@hsbcad.com"> HSB-7533 bugfix beam pos in T-Connection array</version>
/// <version value="1.0" date="16jun2020" author="nils.gregor@hsbcad.com"> HSB-7533 initial </version>
/// </History>

/// <insert Lang=en>
///  Select properties or catalog entry, select elements and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl changes the width and/or height of beams, that are specified by a painter rule and that are aligned to the selected side.
/// All available filters occure in the list. If the list is empty, create a painter rule.
/// The instance can be attached to an element directly.
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsb_Firewall")) TSLCONTENT
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


	String sSideNames[] = { T("|Icon side|"), T("|Opposite side|")};
	String sSideName=T("|Select Side|");	
	PropString sSide(nStringIndex++, sSideNames, sSideName);	
	sSide.setDescription(T("|Defines the side the choosen beams are aligned to|"));
	sSide.setCategory(category);
	int nSide = sSideNames.find(sSide);
	
	String sWidthName=T("|Change width|");	
	PropDouble dWidth(nDoubleIndex++, U(0), sWidthName);	
	dWidth.setDescription(T("|Changes the width of the beam(s)|"));
	dWidth.setCategory(category);
	
	String sHeightName=T("|Change height|");	
	PropDouble dHeight(nDoubleIndex++, U(0), sHeightName);	
	dHeight.setDescription(T("|Changes the height of the beam(s)|"));
	dHeight.setCategory(category);

	String sFilterRuleNames[] = PainterDefinition().getAllEntryNames().sorted();
	String sFilterRuleName=T("|Filter rule|");	
	PropString sFilterRule(nStringIndex++,sFilterRuleNames , sFilterRuleName);	
	sFilterRule.setDescription(T("|Select one of the filter rules from painter. If no rules shown, create painter rules.|"));
	sFilterRule.setCategory(category);


	//region mapIO: support property dialog input via map on element creation
	{
//		int bHasPropertyMap = _Map.hasMap("PROPSTRING[]") && _Map.hasMap("PROPINT[]") && _Map.hasMap("PROPDOUBLE[]");
		int bHasPropertyMap = _Map.hasMap("PROPSTRING[]") && _Map.hasMap("PROPDOUBLE[]");
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


// bOnInsert
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
			if (sEntries.find(sKey) == -1)
				sKey = "";					
		}	
		else	
			showDialog();
		
	// collect male beams or elements to insert on every connection
		PrEntity ssE(T("|Select element(s)|"), ElementWallSF());
		if (ssE.go())
			_Element.append(ssE.elementSet());	


	// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE;	Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[] = {};	Entity entsTsl[1];// = {};
		Point3d ptsTsl[1];// = {};
		int nProps[]={};		double dProps[]={dWidth, dHeight};		String sProps[]={sSide, sFilterRule};
		Map mapTsl;				String sScriptname = scriptName();
		
		for (int i=0;i<_Element.length();i++) 
		{ 
			entsTsl[0]= _Element[i]; 
			ptsTsl[0]=_Element[i].ptOrg();
			tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
				 nProps, dProps, sProps,_kModelSpace, mapTsl);
		}
		
		eraseInstance();
		return;
	}	
// end on insert	__________________
	
// validate selection set
	if (_Element.length()<1 || !_Element[0].bIsKindOf(ElementWall()))		
	{
		reportMessage("\n" + scriptName() + " " + T("|could not find reference to element.|"));
		eraseInstance();
		return;				
	}	
		
// standards
	ElementWall el = (ElementWall)_Element[0];
	CoordSys cs =el.coordSys();
	Point3d ptOrg = cs.ptOrg();	
	Vector3d vecX = cs.vecX();
	Vector3d vecY = cs.vecY();
	Vector3d vecZ = cs.vecZ();
	assignToElementGroup(el, true,0,'E');
	
//Collect beams
	Beam bmAll[] = el.beam();
	Beam bmToChange[0];		
	Beam bmHors[0]; 
	Beam bmVerts[0];
	
// Wait until element is constructed
	if(bmAll.length() <1)
		return;	

//Element dimensions
	PlaneProfile ppZ0 = el.profNetto(0);
	LineSeg segZ0 = ppZ0.extentInDir(vecX);
	double dElHeight = vecY.dotProduct(segZ0.ptEnd() - segZ0.ptStart());
	double dElLength = vecX.dotProduct(segZ0.ptEnd() - segZ0.ptStart());
	double dZ0Depth = el.zone(0).dH();
	
// Define contact zone
	Point3d ptZ0 = el.zone(0).ptOrg(); ptZ0.vis(1);
	Point3d ptBn = (nSide) ? ptOrg - vecZ * dZ0Depth : ptOrg;	ptBn.vis();
	Plane pnZ0(ptBn, vecZ); pnZ0.vis(2);
	PainterDefinition pdFilter(sFilterRule);
	
	if (nSide == 0) nSide = - 1;

//Check beams for filter and change height if needed. If no filter is set no beams are selected
	for (int i=0;i<bmAll.length();i++) 
	{ 
		Beam bm = bmAll[i];		
		PlaneProfile ppBm = bm.envelopeBody().extractContactFaceInPlane(pnZ0, dEps);

		if(bm.vecX().isParallelTo(vecY))
			bmVerts.append(bm);
		else
			bmHors.append(bm);
		
	//Take only beams touching the selected wall side
		if(ppBm.area() < pow(dEps,2))
			continue;	
		
	//Filter beams
		if(! bm.acceptObject(pdFilter.filter()))
			continue;	
			
	//If width is changed, check for collision
		if(dWidth > 0)
			bmToChange.append(bm);	
			
	//Change height of beams
		if(dHeight > 0)
		{
			double dBmH = bm.dD(vecZ);
			double dDiff = dBmH - dHeight;
			bm.setD(vecZ, dHeight);
			bm.transformBy(-nSide * vecZ * 0.5 * dDiff);
		}
	}//next i
	
//Split ppZ0 at openings. Studs close to the opeing have to move to opposite side of opening
	Opening ops[] = el.opening();	
	for (int i=0;i<ops.length();i++) 
	{ 
		Opening op = ops[i]; 
		CoordSys csOp = op.coordSys();
		Point3d ptOpL = csOp.ptOrg();
		Vector3d vecXOp = csOp.vecX();
		LineSeg segOp(ptOpL - vecY * dElHeight, ptOpL + vecY * dElHeight + vecXOp * dEps);
		PLine plOp;
		plOp.createRectangle(segOp, vecX, vecY);
		PlaneProfile ppOp(plOp);
		ppZ0.subtractProfile(ppOp);
		ppOp.transformBy(vecXOp * (op.width()-dEps));
		ppZ0.subtractProfile(ppOp);		 
	}//next i
	
//Width is changed and beam might be moved or move other
	for (int i=0;i<bmToChange.length();i++) 
	{ 
		Beam bm = bmToChange[i]; 
		Point3d ptBmC = bm.ptCen();
		ptBmC = pnZ0.closestPointTo(ptBmC);
		Point3d ptEdge;
		Vector3d vecXB = bm.vecX();
		int bVert = (vecXB.isParallelTo(vecX)) ? false : true;
		
	// Get closest edge of zone 0. Beams should not be reach out of wall or in an opening
		LineSeg segZ0=(bVert)?	LineSeg(ptBmC - vecX *dElLength, ptBmC + vecX*dElLength) : LineSeg(ptBmC - vecY *dElHeight, ptBmC+vecY*dElHeight);		
		LineSeg segZ0s[] = ppZ0.splitSegments(segZ0, true);		segZ0s[0].vis(1);
		Vector3d vecSeg = (bVert) ? vecX : vecY;
		
	//Filter matching LineSeg
		for (int j=0;j<segZ0s.length();j++) 
		{ 
			segZ0s[j].vis(5);
			double dTop = vecSeg.dotProduct(segZ0s[j].ptEnd() - ptBmC);
			double dBottom = vecSeg.dotProduct(ptBmC - segZ0s[j].ptStart());
				
			if(dTop > 0 &&  dBottom > 0)
			{
				if(dTop > dBottom)
					ptEdge = segZ0s[j].ptStart();
				else
					ptEdge = segZ0s[j].ptEnd();
				break;
			}				 
		}//next j
						
		Vector3d vecSide = - (ptEdge - ptBmC);
		vecSide.normalize();		
		Vector3d vecSidePerp = vecSide.crossProduct(vecZ);
		Point3d ptBHLS = ptEdge + vecZ * nSide * dEps;	
		Beam bmYs[0], bmOthers[0];
		Beam bmLast = bm;	
		double dAngle = 0;
				
		if(bVert )
		{
			bmYs = bm.filterBeamsHalfLineIntersectSort(bmVerts, ptBHLS , vecSide);
			ptBHLS += vecZ * nSide * (bm.dD(vecZ) - 2 * dEps); ptBHLS.vis(1);
			bmOthers = bm.filterBeamsHalfLineIntersectSort(bmVerts, ptBHLS , vecSide);			
		}
		else
			bmYs = bm.filterBeamsHalfLineIntersectSort(bmHors, ptBHLS , vecSide);

	//Move angled beams vertical		
		if(! bVert)
			dAngle = bm.vecX().angleTo(vecX);

		Point3d ptBefore = ptEdge; ptBefore.vis(2); vecSide.vis(ptBefore, 3);
		Point3d ptLast = ptBmC;
		double dHalfSide = (dAngle > dEps || dAngle < dEps)? 0.5 * bm.dD(vecSide) : 0.5*bm.dD(vecSide)/cos(dAngle);
		double dDW = dWidth - 2*dHalfSide;
		double dCheck = (dDW < 0)? -dDW : 0;
		int bPastBm, bTransform;
			
	//Set width of beam and transform beam if overlapping edge of zone 0
		for (int j=0;j<bmYs.length();j++) 
		{ 
			Beam bmY = bmYs[j]; 
				
		//Check if bm get`s changed on one side or on both
			if(!bPastBm && bmY != bm)
			{
				ptBefore = bmY.ptCen() + vecSide * 0.5 * bmY.dD(vecSide);
			}
			else if(!bPastBm && bmY == bm)
			{
				bPastBm = true;
						
				if(vecSide.dotProduct(ptBmC - ptBefore) < dHalfSide + 0.5 * dDW + dEps)
				{
					bTransform = true;
					ptLast += vecSide * 0.5 * dDW;
				}	
						
				bm.setD(vecSide, dWidth);	
			}
			else
			{					
				double dDiff = vecSide.dotProduct( (bmY.ptCen() - vecSide * 0.5 * bmY.dD(vecSide)) - (ptLast + vecSide * 0.5 * bmLast.dD(vecSide)));				
			
				if(dDiff < dEps + dCheck)
				{
					bmY.transformBy(-vecSide * dDiff);
					bmLast = bmY;
					ptLast = bmY.ptCen();
				}	
				else
					break;
			}						
		}//next j	
		
	//Check other beams of zone 0 for intersection
		int bOther;
		Beam bmLastO=bm;
		Point3d ptLastO= bm.ptCen();
		
		for (int j=0;j<bmOthers.length();j++) 
		{ 
			Beam bmO = bmOthers[j]; 
			
			if(bmO == bm)
			{
				bOther = true;	
				continue;
			}
				
//			if(bmO.dD(vecZ) +dEps > dZ0Depth)
//				continue;
				
			if(bOther)
			{
				double dDiff = vecSide.dotProduct( (bmO.ptCen() - vecSide * 0.5 * bmO.dD(vecSide)) - (ptLastO + vecSide * 0.5 * bmLastO.dD(vecSide)));				
			
				if(dDiff < dEps + dCheck)
				{
					bmO.transformBy(-vecSide * dDiff);
					bmLastO = bmO;
					ptLastO = bmO.ptCen();
				}	
				else
					break;				
			}		 
		}//next j
				
		if(bTransform)
			bm.transformBy(vecSide * 0.5 * dDW);			 
	}//next i		
	
	
// Connect all vertical beam to not verticals
	for (int i=0;i<bmVerts.length();i++) 
	{ 
		Beam bm = bmVerts[i]; 
		Point3d ptBmCen = bm.ptCen();
		double dBmZ = bm.dD(vecZ);
		
	//Filter potentual beams for contact	
		Vector3d vecFilter = vecY * 0.5 * dElHeight;		
		double dFilter = (bm.dH() > bm.dW()) ? bm.dH() : bm.dW();
		LineSeg segFilter(ptBmCen- vecFilter, ptBmCen + vecFilter);
		Beam bmsFiltered[] = Beam().filterBeamsCapsuleIntersect(bmHors, segFilter, dFilter);
		
	//Create an extended Planeprofile from the beam
		PLine plBm;
		LineSeg segBm(ptBmCen + vecFilter + vecX * 0.5 * bm.dD(vecX), ptBmCen - vecFilter - vecX * 0.5 * bm.dD(vecX));
		plBm.createRectangle(segBm, vecX, vecY);
		PlaneProfile ppBm(plBm);
		
		PlaneProfile ppTop[0], ppBottom[0];
		Beam bmsAsTool[0];
		int nFTop[0], nFBottom[0];
		
	// Get most bottom beam that this beam will be streched to. 
		for (int j=bmsFiltered.length()-1; j > -1;j--) 
		{ 
			Beam bmF = bmsFiltered[j];
			
			if(bmF.dD(vecZ) + dEps < dBmZ)
			{
				bmsAsTool.append(bmF);
				bmsFiltered.removeAt(i);
				continue;
			}
			
			PlaneProfile ppF = bmF.envelopeBody(true, true).shadowProfile(pnZ0);
			PlaneProfile ppB = ppBm;
			ppB.intersectWith(ppF);
			
			if(ppB.area() > pow(dEps,2))
			{
				if(vecY.dotProduct(ppB.ptMid() - ptBmCen) > 0)
				{
					nFTop.append(j);
					ppTop.append(ppB);
				}
				else
				{
					nFBottom.append(j);
					ppBottom.append(ppB);
				}

				ppBm.subtractProfile(ppF);
				
			// If PlaneProfile gets split, get the one refered to bm
				PLine pls[] = ppBm.allRings();
				if(pls.length() > 1)
				{
					for (int k=0;k<pls.length();k++) 
					{ 
						PlaneProfile pp(pls[k]); 
						
						if(pp.pointInProfile(ptBmCen))
						{
							ppBm = pp;
							break;
						}
					}//next k				
				}
			}
			
		// Stretch to top beam(s)
			for (int j=ppTop.length()-1; j > -1; j--) 
			{ 
				PlaneProfile pp = ppTop[j]; 
				pp.shrink(-dEps);
				pp.intersectWith(ppBm);
					
				if(pp.area() < pow(dEps,2))
				{
					ppTop.removeAt(j);
					nFTop.removeAt(j);
				}
			}//next j		
				
			if(nFTop.length() == 1)
				bm.stretchStaticTo(bmsFiltered[nFTop[0]], 1);
			else if(nFTop.length() == 2)
				bm.stretchStaticToMultiple(bmsFiltered[nFTop[0]], bmsFiltered[nFTop[1]],1);	

		//Stretch to bottom beams
			for (int j=ppBottom.length()-1; j > -1; j--) 
			{ 
				PlaneProfile pp = ppBottom[j]; 
				pp.shrink(-dEps);
				pp.intersectWith(ppBm);
					
				if(pp.area() < pow(dEps,2))
				{
					ppBottom.removeAt(j);
					nFBottom.removeAt(j);
				}
			}//next j		
				
			if(nFBottom.length() == 1)
				bm.stretchStaticTo(bmsFiltered[nFBottom[0]], 1);
			else if(nFBottom.length() == 2)
				bm.stretchStaticToMultiple(bmsFiltered[nFBottom[0]], bmsFiltered[nFBottom[1]],1);			

		}//next j
	}//next i
	
// Erase Instance	
	eraseInstance();

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
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End