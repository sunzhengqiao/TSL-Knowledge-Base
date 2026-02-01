#Version 8
#BeginDescription
#Versions
Version 1.4 28.01.2022 HSB-14531 automatic element assignment if main beam belongs to element
Version 1.3 16.12.2021 HSB-14184 new property 'max female depth' which might adjust axis offset to ensure a max tooling depth
Version 1.2 25.11.2021 HSB-13609 group assignment added
Version 1.1 16.11.2021 HSB-13609 default orientation swapped
Version 1.0 22.10.2021 HSB-13609 initial version




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords Lap;lapjoint;Überblattung;Blatt
#BeginContents
//region <History>
// #Versions
// 1.4 28.01.2022 HSB-14531 automatic element assignment if main beam belongs to element , Author Thorsten Huck
// 1.3 16.12.2021 HSB-14184 new property 'max female depth' which might adjust axis offset to ensure a max tooling depth , Author Thorsten Huck
// 1.2 25.11.2021 HSB-13609 group assignment added , Author Thorsten Huck
// 1.1 16.11.2021 HSB-13609 default orientation swapped , Author Thorsten Huck
// 1.0 22.10.2021 HSB-13609 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select male and female beam.
/// </insert>

// <summary Lang=en>
// This tsl creates a lap joint between two beams
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "LapJoint")) TSLCONTENT
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
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
	
	
	
//end Constants//endregion

//region Properties
	String sAxisOffsetName=T("|Axis Offset|");	
	PropDouble dAxisOffset(0, U(0), sAxisOffsetName);	
	dAxisOffset.setDescription(T("|Defines the Axis Offset|"));
	dAxisOffset.setCategory(category);

	String sMaxFemaleDepthName=T("|Max. Female Depth|");	
	PropDouble dMaxFemaleDepth(3, U(110), sMaxFemaleDepthName);	
	dMaxFemaleDepth.setDescription(T("|Defines a maximal depth of the female beamcut which will auto adjust the axis offset.|")+ T(" |0 = disabled|"));
	dMaxFemaleDepth.setCategory(category);
	
	
	

category = T("|Gaps|");
	String sGapMaleName=T("|Male|");	
	PropDouble dGapMale(1, U(0), sGapMaleName);	
	dGapMale.setDescription(T("|Defines the side gap of the male beam|"));
	dGapMale.setCategory(category);

	String sGapFemaleName=T("|Female|");	
	PropDouble dGapFemale(2, U(0), sGapFemaleName);	
	dGapFemale.setDescription(T("|Defines the side gap of the female beam|"));
	dGapFemale.setCategory(category);

//End Properties//endregion 


//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
	// standard dialog	
		else	
			showDialog();
		
		
		_Beam.append(getBeam(T("|Select male beam|")));
		_Beam.append(getBeam(T("|Select female beam|")));
		
		if (_Beam[0].vecX().isParallelTo(_Beam[1].vecX()))
		{ 
			reportMessage("\n"+ scriptName() + T("|Parallel connections are not supported yet|, ")+T("|Tool will be deleted.|"));
			eraseInstance();
			return;
		}
		
		return;
	}	
// end on insert	__________________//endregion


//region Standards
	if (_Beam.length()<2 || _Beam[0].vecX().isParallelTo(_Beam[1].vecX()))	
	{ 
		reportMessage("\n"+ scriptName() + T("|Invalid selection set or orientation|, ")+T("|Tool will be deleted.|"));
		eraseInstance();
		return;		
	}
	setExecutionLoops(2);

	
	
	Beam bm0 = _Beam[0];
	Vector3d vecX = bm0.vecX();
	Vector3d vecY = bm0.vecY();
	Vector3d vecZ = bm0.vecZ();
	Element el = bm0.element();
	if (el.bIsValid())
	{
		assignToElementGroup(el, true, 0, 'T');
		if (_Element.find(el)<0)
			_Element.append(el);
	}
	else
	{
		assignToGroups(bm0, 'T');
		_Element.setLength(0);
	}
	
	Point3d ptCen0 = bm0.ptCen();
	Body bd0 = bm0.envelopeBody(false, true);
	
	Beam bm1 = _Beam[1];
	Point3d ptCen1 = bm1.ptCen();
	Body bd1 = bm1.envelopeBody(false, true);
	
	Point3d ptRef=_Pt0;
	if (!Line(ptCen0, vecX).hasIntersection(Plane(ptCen1, bm1.vecD(vecX)), ptRef))
	{
		reportMessage("\n"+ scriptName() + T("|Invalid selection set or orientation|, ")+T("|Tool will be deleted.|"));
		eraseInstance();
		return;
	}
	
	setDependencyOnBeamLength(bm0);
	setDependencyOnBeamLength(bm1);
	
// align coordSys to connection
	if (vecX.dotProduct(ptRef - ptCen0) < 0)vecX *= -1;
	Vector3d vecZC = vecX.crossProduct(bm1.vecX());
	if (vecZC.dotProduct(_ZW) > 0)vecZC *= -1;
	
	vecZ = bm0.vecD(vecZC);
	vecY = vecX.crossProduct(-vecZ);

	vecX.vis(ptRef, 1);
	vecY.vis(ptRef, 3);
	vecZ.vis(ptRef, 150);

	Vector3d vecX1 = bm1.vecX();
	if (vecX1.dotProduct(ptRef - ptCen1) < 0)vecX1 *= -1;
	vecX1 = vecX1.crossProduct(vecZ).crossProduct(-vecZ);
	vecX1.normalize();
	Vector3d vecY1 = vecX1.crossProduct(-vecZ);
	vecX1.vis(ptRef,12);
	vecY1.vis(ptRef, 94);
	
	
	
//region Z-Location
	if (_kNameLastChangedProp=="_Pt0")
	{ 
		double d = vecZ.dotProduct(_Pt0 - ptRef);
		if (abs(d)<.5*bm0.dD(vecZ))
		{ 
			dAxisOffset.set(d);
			setExecutionLoops(2);
		}
	}


	if (abs(dAxisOffset)>=.5*bm0.dD(vecZ))
	{ 
		reportMessage("\n"+ sAxisOffsetName + T(" |may not be >= 50% of the male beam height.|"));
		dAxisOffset.set(0);	
	}		
//endregion 	
	

	
	
	
	
//region Get Common Range
	Plane pnZ(ptRef, vecZ);
	PlaneProfile ppZ0(CoordSys(ptRef, vecX, vecY, vecZ));
	ppZ0.unionWith(bd0.shadowProfile(pnZ));
	PlaneProfile ppZ1 = bd1.shadowProfile(pnZ);
	
	PlaneProfile ppZ = ppZ0;
	ppZ.intersectWith(ppZ1);
	//
	ppZ0.vis(1);
	ppZ1.vis(170);
	
	
	PlaneProfile ppX = bd0.shadowProfile(Plane(ptRef, vecX));
	PlaneProfile ppX1 = bd1.shadowProfile(Plane(ptRef, vecY1));
	ppX.intersectWith(ppX1);	
	
	if (ppZ.area()<pow(dEps,2) ||ppX.area()<pow(dEps,2))
	{ 
		reportMessage("\n"+ scriptName() + T("|Beams do not intersect| ")+T("|Tool will be deleted.|"));
		eraseInstance();
		return;
	}
	

	ppX.vis(2);

//endregion 	
	
//region Auto Adjust Axis Offset
	Point3d pt = ppZ.ptMid();
	pt += vecZ * (vecZ.dotProduct(ppX.ptMid() - pt) + dAxisOffset);



	// identify female beam: if side is swapped the first beam could be the female beam
	Beam bmFemale = bm1;
	Point3d ptCenFemale = ptCen1;
	int nDir = 1;
	{ 
		LineSeg seg(ptRef - vecX * U(10e3), ptRef + vecX * U(10e3));seg.vis(6);
		LineSeg segs[] = ppZ1.splitSegments(seg,true);
		if (segs.length()>0)
		{ 
			seg = segs.first();
			Point3d pt1 = seg.ptStart();
			Point3d pt2 = seg.ptEnd();
			Vector3d vecXS = pt2 - pt1; vecXS.normalize();
			if (ppZ0.pointInProfile(pt1-vecXS*dEps)==_kPointInProfile && ppZ0.pointInProfile(pt2+vecXS*dEps)==_kPointInProfile)
			{ 
				seg.vis(171);
				bmFemale = bm0;
				ptCenFemale = ptCen0;	
				nDir = -1;
			}	
		}
	}

	double dFemaleDepth = (nDir*vecZ).dotProduct((ptCenFemale + nDir*vecZ * .5 * bmFemale.dD(vecZ)) - pt);
	double dDiff = nDir*(dFemaleDepth - dMaxFemaleDepth);
	if (dMaxFemaleDepth>0 && abs(dDiff)>dEps)
	{ 
		
		dAxisOffset.set(dAxisOffset + dDiff);
		if (!_bOnDbCreated)
			reportMessage("\n"+scriptName() + T(": |The axis offset has been adjusted to respect the| ")+sMaxFemaleDepthName + " ("+dMaxFemaleDepth+")");
		pt = ppZ.ptMid();
		pt += vecZ * (vecZ.dotProduct(ppX.ptMid() - pt) + dAxisOffset);
		_ThisInst.transformBy(Vector3d(0, 0, 0));
	}
//endregion 

//region Tools
	_Pt0 = pt;
	
	double dX = ppZ.dX();
	double dY = ppZ.dY()+2*dGapMale;
	double dZ = U(10e3);


	Point3d pts0[] = Line(ptRef, vecX).orderPoints(ppZ.getGripVertexPoints(), dEps);
	Point3d pts1[] = Line(ptRef, vecX1).orderPoints(ppZ.getGripVertexPoints(), dEps);

	if (pts0.length()<1 || pts1.length()<1)
	{ 
		eraseInstance();
		return;
	}

	Point3d ptFemale = ppZ.ptMid();//ptCen0;
	ptFemale +=vecZ*vecZ.dotProduct(pt-ptFemale);
	ptFemale += vecX * vecX.dotProduct(pts0.last() - ptFemale);
	ptFemale.vis(2);
	BeamCut bcFemale(ptFemale, vecX, vecY, vecZ, dX, dY, dZ, -1, 0, 1);
	bcFemale.cuttingBody().vis(6);
	bm1.addTool(bcFemale);


	double dX1 = vecX1.dotProduct(pts1.last()-pts1.first());
	double dY1 = bm1.dD(vecY1)+2*dGapFemale;
	
	Point3d ptMale = ptCen1;
	ptMale +=vecZ*vecZ.dotProduct(pt-ptMale);
	ptMale += vecX1 * vecX1.dotProduct(pts1.last() - ptMale);
	ptMale.vis(2);
	BeamCut bcMale(ptMale, vecX1, vecY1, vecZ, dX1, dY1, dZ, -1, 0, -1);
	//bcMale.cuttingBody().vis(4);
	bm0.addTool(bcMale);

//endregion 


//region Display
	Display dp(252);
	Body bd = bd0;
	bd.intersectWith(bd1);
	bd.intersectWith(bm1.realBody());
	PlaneProfile ppSym = bd.extractContactFaceInPlane(Plane(pt, vecZ), dEps);
	dp.draw(ppSym);
	dp.draw(ppSym.extentInDir(vecX1));
	
//endregion 	


//region Trigger SwapSides
// Trigger SwapSides//region
	String sTriggerSwapSides = T("|Swap Sides|");
	addRecalcTrigger(_kContextRoot, sTriggerSwapSides );
	if (_bOnRecalc && (_kExecuteKey==sTriggerSwapSides || _kExecuteKey==sDoubleClick))
	{
		_Beam.swap(0,1);
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="256" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14531 automatic element assignment if main beam belongs to element" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="1/28/2022 12:31:35 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14184 new property 'max female depth' which might adjust axis offset to ensure a max tooling depth" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="12/16/2021 11:07:58 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13609 group assignment added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="11/25/2021 10:38:03 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13609 default orientation swapped" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="11/16/2021 4:38:37 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End