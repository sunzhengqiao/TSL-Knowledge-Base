#Version 8
#BeginDescription
version value="1.2" date="05mar2020" author="david.delombaerde@hsbcad.com 
Setting boundaries when moving the grippoint. 
And resetting the value when grip is out of bounds.
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
/// <version value="1.2" date="05mar2020" author="david.delombaerde@hsbcad.com"> setting boundaries when moving the grippoint. And resetting the value when grip is out of bounds. </version>
/// <version value="1.1" date="25apr2018" author="thorsten.huck@hsbcad.com"> alignment property added, visualisation of alignment improved </version>
/// <version value="1.0" date="24apr2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select 1 or multiple parallel beams, select properties or catalog entry and press OK
/// When selecting 1 beam or a set of non joinable beams the user will be prompted to specify a split location
/// </insert>

/// <summary Lang=en>
/// This tsl creates a parallel lap joint between two beams.
/// </summary>//endregion

// Commands
// commmand to create instance
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbParallelLapJoint")) TSLCONTENT
// command to rotate the tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Rotate around X-Axis|") (_TM "|Select tool|"))) TSLCONTENT
// command to fliup the x-Axis of the tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip X Axis|") (_TM "|Select tool|"))) TSLCONTENT
// command to re-join the beams and remove the tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Join + Erase|") (_TM "|Select tool|"))) TSLCONTENT

// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	//endregion

//region Properties
		
	String sLengthName=T("|Length|");	
	PropDouble dLength(nDoubleIndex++, U(60), sLengthName);	
	dLength.setDescription(T("|Defines the Length|"));
	dLength.setCategory(category);

// alignment
	category = T("|Alignment|");
	String sSideName=T("|Side|");	
	String sSides[] = { T("|Top|"), T("|Left|"), T("|Bottom|"), T("|Right|")};
	PropString sSide(nStringIndex++, sSides, sSideName);	
	sSide.setDescription(T("|The alignment is dependent from the UCS at the time of insertion.|") + T(" |You can also toggle sides by double clicking.|"));
	sSide.setCategory(category);

	String sAxisOffsetName=T("|Axis Offset|");	
	PropDouble dAxisOffset(nDoubleIndex++, U(0), sAxisOffsetName);	
	dAxisOffset.setDescription(T("|Defines the Axis Offset|"));
	dAxisOffset.setCategory(category);

// Gaps
	category = T("|Gaps|");
	String sGapTopName=T("|Top|");	
	PropDouble dGapTop(nDoubleIndex++, U(0), sGapTopName);	
	dGapTop.setDescription(T("|Defines the gap on the positive Z-Side of the tool.|"));
	dGapTop.setCategory(category);
	
	String sGapCenterName=T("|Center|");	
	PropDouble dGapCenter(nDoubleIndex++, U(0), sGapCenterName);	
	dGapCenter.setDescription(T("|Defines the the center gap."));
	dGapCenter.setCategory(category);	
	
	String sGapBottomName=T("|Bottom|");	
	PropDouble dGapBottom(nDoubleIndex++, U(0), sGapBottomName);	
	dGapBottom.setDescription(T("|Defines the gap on the negative Z-Side of the tool.|"));
	dGapBottom.setCategory(category);	
	
//End Properties//endregion 
	
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
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
		else	
			showDialog();

	// prompt user to select all beams (male and female)
		PrEntity ssMales(T("|Select beam(s)|"), Beam());
	  	if (ssMales.go())
			_Beam = ssMales.beamSet();

	// distinguish if couples can be found
		String sHandles[0];
		for (int b = 0; b < _Beam.length(); b++)
		{
			Beam& bm0 = _Beam[b];
			String sHandle0 = bm0.handle();
			Vector3d vecX = bm0.vecX();
			Vector3d vecY = bm0.vecY();
			Vector3d vecZ = bm0.vecZ();
			double dX = bm0.solidLength();
			Point3d ptCen = bm0.ptCenSolid();
			
			Beam bmOthers[] = vecX.filterBeamsParallel(_Beam);
			for (int i = 0; i < bmOthers.length(); i++)
			{
				Beam& bm1 = bmOthers[i];
				if (bm0 == bm1)continue;
				String sHandle1 = bm1.handle();
				
				// test if found in list of couples
				int bFound;
				for (int s = 0; s < sHandles.length(); s++)
				{
					String& sHandle = sHandles[s];
					// both are found	
					if (sHandle.find(sHandle0, 0) >- 1 && sHandle.find(sHandle1, 0) >- 1)
					{
						bFound = true;
						break;
					}
				}
				if (bFound)continue;
				
				Point3d ptCen1 = bm1.ptCenSolid();
				// test axis
				if (abs(vecY.dotProduct(ptCen - ptCen1)) > dEps || abs(vecZ.dotProduct(ptCen - ptCen1)) > dEps)
					continue;
				
				Vector3d vecDir = vecX;
				if (vecDir.dotProduct(ptCen1 - ptCen) < 0)vecDir *= -1;
				double dX1 = bm1.solidLength();
				
				Point3d ptA = ptCen + vecDir * .5 * dX;
				Point3d ptB = ptCen1 - vecDir * .5 * dX1;
				
				double dAB = vecDir.dotProduct(ptA - ptB);
				double dBC = vecDir.dotProduct(ptB - ptCen);

				if (dAB>-dLength && dBC>0)
					sHandles.append(sHandle0 + "__" + sHandle1);
			}
		}
		
		if (sHandles.length()<1)
		{
			_Map.setInt("splitBeams", true);
			_Pt0 = getPoint(T("|Select split location|"));
		}

		return;
	}// END IF on insert_________________________________________________	
	
// different modes 0= find beam connection and create single instance, 1= single instance
	int nMode = _Map.getInt("mode");	
		
//MODE 0: find beam connection and create single instance
if (nMode == 0)
{
	//bDebug = true;
	// prepare tsl cloning
	TslInst tslNew;					Map mapTsl; mapTsl.setInt("mode", 1);//single mode
	Vector3d vecXTsl = _XU;			Vector3d vecYTsl = _YU;
	GenBeam gbsTsl[0];				Entity entsTsl[] = { };			Point3d ptsTsl[] = { };
	int nProps[] ={ };				double dProps[] ={dLength,dAxisOffset, dGapTop,dGapCenter,dGapBottom};			String sProps[] ={sSide};
	
	// error msg
	String sMsg;
	
	int bSplit;// = _Map.getInt("splitBeams");
	
// find contacting beams
	String sHandles[0];
	if (!bSplit)
		for (int b=0;b<_Beam.length();b++) 
		{ 
			Beam& bm0 = _Beam[b];
			String sHandle0 = bm0.handle();
			Vector3d vecX = bm0.vecX();
			Vector3d vecY = bm0.vecY();
			Vector3d vecZ = bm0.vecZ();
			double dX = bm0.solidLength();
			Point3d ptCen = bm0.ptCenSolid();

			Beam bmOthers[] = vecX.filterBeamsParallel(_Beam);
			for (int i=0;i<bmOthers.length();i++) 
			{ 
				Beam& bm1 = bmOthers[i];			
				if(bm0==bm1)continue; 
				String sHandle1 = bm1.handle();
			
			// test if found in list of couples
				int bFound;
				for (int s=0;s<sHandles.length();s++) 
				{ 
					String& sHandle = sHandles[s]; 
				// both are found	
					if (sHandle.find(sHandle0,0)>-1 && sHandle.find(sHandle1,0)>-1) 
					{
						bFound = true;
						break;
					}
				}
				if (bFound)continue;
				
				
				Point3d ptCen1 = bm1.ptCenSolid();
				
			// test axis
				if (abs(vecY.dotProduct(ptCen-ptCen1))>dEps || abs(vecZ.dotProduct(ptCen-ptCen1))>dEps)
					continue;
				
				Vector3d vecDir = vecX;
				if (vecDir.dotProduct(ptCen1 - ptCen) < 0)vecDir *= -1;
				
				double dX1 = bm1.solidLength();
				

				Point3d ptA = ptCen + vecDir * .5 * dX;vecX.vis(ptA,2);
				Point3d ptB = ptCen1 - vecDir * .5 * dX1; ptB.vis(5);
				ptB.vis(3);
				
				double dAB = vecDir.dotProduct(ptA - ptB);
				double dBC = vecDir.dotProduct(ptB - ptCen);

				//pt2.vis(3);ptB2.vis(4);
				if (dAB>-dLength && dBC>0)// || d2<dEps || d2<dEps || d3<dEps)
				{ 
					
					sHandles.append(sHandle0 + "__" + sHandle1);
	
					gbsTsl.setLength(0);
					gbsTsl.append(bm0);
					gbsTsl.append(bm1);
	
	
					ptsTsl.setLength(0);
					Vector3d vecDir = vecX;
					if (vecDir.dotProduct(ptCen1 - ptCen) < 0)vecDir *= -1;
					//ptsTsl.append(ptCen + vecDir * .5 * dX);
					ptsTsl.append(ptCen + vecDir * .5 * (dX-dAB));
					
	
					if (!bDebug)
						tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
							nProps, dProps, sProps,_kModelSpace, mapTsl);
					else
					{
						ptsTsl[0].vis(b);
						PLine(ptCen, ptCen1).vis(i+b);
	//					gbsTsl[0].ptCen().vis(1); 
	//					gbsTsl[1].ptCen().vis(2); 					
					}		
				}
				//bm1.ptCen().vis(i);
				
			} 
		}
	
// no couples found
	if (sHandles.length()<1 || bSplit)
	{
		for (int b=0;b<_Beam.length();b++) 
		{ 
			Beam& bm0 = _Beam[b];
			Vector3d vecX = bm0.vecX();
			Vector3d vecY = bm0.vecY();
			Vector3d vecZ = bm0.vecZ();
			double dX = bm0.solidLength();
			Point3d ptCen = bm0.ptCenSolid();
			Point3d ptA1 = ptCen - vecX * .5 * dX;
			Point3d ptA2 = ptCen + vecX * .5 * dX;			
			PLine pl(ptA1, ptA2);
			Point3d pts[] = pl.intersectPoints(Plane(_Pt0, vecX));
			
			if (pts.length()>0)
			{ 
				ptsTsl.setLength(0);
				ptsTsl.append(pts[0]);
								
				gbsTsl.setLength(0);
				gbsTsl.append(bm0);
				
				if (!bDebug)
				{ 
					Beam bm1;
					bm1 = bm0.dbSplit(pts[0], pts[0]);
					gbsTsl.append(bm1);	
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
						nProps, dProps, sProps,_kModelSpace, mapTsl);
				}
				else
				{
					ptsTsl[0].vis(3); 					
				}
			}	
		}
	}
	if (!bDebug)eraseInstance();
	return;
}	
	
//MODE 1: single instance, connects a male and a female beam
else if (nMode == 1)
{
	// validate beams
	if (_Beam.length() < 2)
	{
		eraseInstance();
		return;
	}
	
	// beams and coordSys
	Beam& bm0 = _Beam[0];
	Beam& bm1 = _Beam[1];
	Point3d ptCen = bm0.ptCenSolid();
	Point3d ptCen1 = bm1.ptCenSolid();

// assigning
	Element el0 = bm0.element(), el1 =bm1.element();
	if (el0.bIsValid() && el1.bIsValid())
	{ 
		assignToElementGroup(el0, false, 0, 'T');
		assignToElementGroup(el1, false, 0, 'T');
	}
	else	
		assignToGroups(bm0, 'T');
		
// get coordsys	
	Vector3d vecX = bm0.vecX();
	if (vecX.dotProduct(ptCen1 - ptCen) < 0)
	{
		vecX *= -1;
	}
	vecX.vis(_Pt0, 2);

	Vector3d vecZ = bm0.vecD(_ZU);
	Vector3d vecY = vecX.crossProduct(-vecZ);
	
	if (_kNameLastChangedProp == "_Pt0" && _Map.hasVector3d("vecPt0"))
	{ 
		Point3d ptMax0 = ptCen - vecX * .5 * bm0.dL();
		double d0 = vecX.dotProduct(_Pt0 - ptMax0);
		Point3d ptMax1 = ptCen1 + vecX * .5 * bm1.dL();
		double d1 = vecX.dotProduct(ptMax1 - _Pt0);
		
		if (d0 < 0 || d1 < 0)
		{ 
			_Pt0 = _PtW + _Map.getVector3d("vecPt0");
		}
	}
	
	
// get rotation by side property
	int nSide = sSides.find(sSide,0);
	
// get rotaion and rotate coordSys if requiered	
	double dRotation = nSide*90;
	if (dRotation>0)
	{
		CoordSys cs;
		cs.setToRotation(dRotation, vecX, _Pt0);
		vecY.transformBy(cs);
		vecZ.transformBy(cs);
	}
	vecX.vis(_Pt0, 1);
	vecY.vis(_Pt0, 3);
	vecZ.vis(_Pt0, 150);

// get dimensions
	double dY = bm0.dD(vecY);
	double dZ = bm0.dD(vecZ);
	double dZ1 = bm1.dD(vecZ);
	double dY1 = bm1.dD(vecY);

// set axis to common axis
	Line ln0((ptCen+ptCen1)/2, vecX);

// validate connection
	int bInvalidY = abs(vecY.dotProduct(ptCen1 - ptCen)) >= .5 * (dY + dY1);
	int bInvalidZ = abs(vecZ.dotProduct(ptCen1 - ptCen)) >= .5 * (dZ + dZ1);
	if (bInvalidY || bInvalidZ)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|not possible to join beams.|"));
		bm0.addToolStatic(Cut(_Pt0, vecX), _kStretchOnToolChange);
		bm1.addToolStatic(Cut(_Pt0, -vecX), _kStretchOnToolChange);	
		eraseInstance();
		return;
	}
	
// get reference point	
	_Pt0 = ln0.closestPointTo(_Pt0);	
	Point3d ptRef = ln0.closestPointTo(_Pt0)+vecZ*dAxisOffset;
	
// stretch beams
	ptRef.vis(4);
	bm0.addTool(Cut(ptRef + vecX * .5 * dLength, vecX), _kStretchOnToolChange);
	bm1.addTool(Cut(ptRef - vecX * .5 * dLength, -vecX), _kStretchOnToolChange);	

	Plane pnY(_Pt0, vecY);

// beamcuts
	Point3d ptBcA = ptRef - .5*(vecX*dGapTop+vecZ*dGapCenter);
	BeamCut bcA(ptBcA, vecX, vecY, vecZ, dLength+dGapTop, dY+dY1, dZ+dZ1,0,0,1);
	//bcA.cuttingBody().vis(2);
	bm0.addTool(bcA);
	
	Point3d ptBcB = ptRef + .5*(vecX*dGapBottom+vecZ*dGapCenter);
	BeamCut bcB(ptBcB, vecX, vecY, vecZ, dLength+dGapBottom, dY+dY1, dZ+dZ1,0,0,-1);
	//bcB.cuttingBody().vis(3);
	bm1.addTool(bcB);

// TriggerRotate
	String sTriggerRotate = T("|Rotate around X-Axis|");
	addRecalcTrigger(_kContext, sTriggerRotate );
	if (_bOnRecalc && (_kExecuteKey==sTriggerRotate || _kExecuteKey==sDoubleClick))
	{
		nSide++;
		if (nSide == 4)nSide = 0;
		sSide.set(sSides[nSide]);
		setExecutionLoops(2);
		return;
	}
	
// Trigger FlipX
	String sTriggerFlipX = T("|Flip X Axis|");
	addRecalcTrigger(_kContext, sTriggerFlipX );
	if (_bOnRecalc && _kExecuteKey==sTriggerFlipX)
	{
		bm0.addToolStatic(Cut(_Pt0, vecX), _kStretchOnToolChange);
		bm1.addToolStatic(Cut(_Pt0, -vecX), _kStretchOnToolChange);	
		
		nSide+=2;
		if (nSide >= 4)nSide = nSide-4;
		sSide.set(sSides[nSide]);		
		
		_Beam.swap(0, 1);
		setExecutionLoops(2);
		return;
	}	
	
	
// Trigger Join
	String sTriggerJoin = T("|Join + Erase|");
	addRecalcTrigger(_kContext, sTriggerJoin );
	if (_bOnRecalc && (_kExecuteKey==sTriggerJoin || _kExecuteKey==sDoubleClick))
	{
		bm0.dbJoin(bm1);
		eraseInstance();
		return;
	}	
	


// Display
	Display dp(252);
	
	// gap display
	PlaneProfile ppGap(CoordSys(_Pt0, vecX, vecZ, - vecY));
	if(dGapBottom>0)
	{ 
		PLine pl;
		Point3d pt = ptRef + vecX * .5 * dLength+.5*vecZ*dGapCenter;
		pl.createRectangle(LineSeg(pt, pt + vecX * dGapBottom-vecZ*(.5*(dZ+dGapCenter)+dAxisOffset)), vecX, vecZ);
		ppGap.joinRing(pl,_kAdd);	
	}
	if(dGapCenter>0)
	{ 
		PLine pl;
		Point3d pt = ptRef;
		pl.createRectangle(LineSeg(pt-vecX*.5*dLength-vecZ*.5*dGapCenter, pt + vecX * .5*dLength+vecZ*.5*dGapCenter), vecX, vecZ);
		ppGap.joinRing(pl,_kAdd);	
	}
	if(dGapTop>0)
	{ 
		PLine pl;
		Point3d pt = ptRef - vecX * .5 * dLength-.5*vecZ*dGapCenter;
		pl.createRectangle(LineSeg(pt, pt - vecX * dGapTop+vecZ*(.5*(dZ+dGapCenter)-dAxisOffset)), vecX, vecZ);
		ppGap.joinRing(pl,_kAdd);	
	}	
	if (ppGap.area()>pow(dEps,2))
	{
		//dp.draw(ppGap, _kDrawFilled, 60);
		dp.draw(ppGap);
	}
	

	if(dGapBottom<dEps || dGapTop<dEps || dGapCenter<dEps)
	{ 
		PLine pl(vecZ);
		pl.addVertex(ptRef - vecX * .5 * dLength+vecZ*(.5*dZ-dAxisOffset));
		pl.addVertex(ptRef - vecX * .5 * dLength);
		pl.addVertex(ptRef - vecX * 1/6 * dLength);
		dp.draw(pl);
		
		pl = PLine(vecZ);
		pl.addVertex(ptRef + vecX * 1/6 * dLength);
		pl.addVertex(ptRef + vecX * .5 * dLength);
		pl.addVertex(ptRef + vecX * .5 * dLength-vecZ*(.5*dZ+dAxisOffset));
		dp.draw(pl);		
	}
	
//// display Z coordinate axises
//	{ 
		double dAxisMin = U(20);
		Point3d ptAxis=ptRef;
		double dX = dLength/3;
		double dXAxis = .5*dX;	if(dX > dAxisMin*2) dXAxis = dAxisMin*2;
		double dYAxis = .5*dY;	if(dY > dAxisMin) dYAxis = dAxisMin ;
		double dZAxis = .5*dZ;	if(dZ > dAxisMin) dZAxis = dAxisMin ;
//		
//		//PLine plReference (ptsRef[0], ptsRef[1]);
		PLine plXPos (ptAxis, ptAxis+vecX*dXAxis);
		PLine plXNeg (ptAxis, ptAxis-vecX*dXAxis);
		PLine plYPos (ptAxis, ptAxis+vecY*dYAxis);
		PLine plYNeg (ptAxis, ptAxis-vecY*dYAxis);
		PLine plZPos (ptAxis, ptAxis+vecZ*dZAxis);
		PLine plZNeg (ptAxis, ptAxis-vecZ*dZAxis);
//	
		Display dpAxis(7);
//		//dpAxis.draw(plReference);
//	
		dpAxis.color(1);		dpAxis.draw(plXPos);
		dpAxis.color(14);		dpAxis.draw(plXNeg);
		dpAxis.color(3);		dpAxis.draw(plYPos);
		dpAxis.color(96);		dpAxis.draw(plYNeg);
		dpAxis.color(150);	dpAxis.draw(plZPos);
		dpAxis.color(154);	dpAxis.draw(plZNeg);		
//	}

	_Map.setVector3d("vecPt0", _Pt0 - _PtW);

}
	
	
#End
#BeginThumbnail
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
-"T<:J2.G`J>BAL#_V=?Y
`



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