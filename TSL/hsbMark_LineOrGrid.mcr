#Version 8
#BeginDescription
#Versions:
1.3 28.09.2021 HSB-1247: fix grid points when 2  or more grid points are at same location Author: Marsel Nakuci
1.2 22.09.2021 HSB-1247: Plines and grids are projected to the body of the genbeam with their normal Author: Marsel Nakuci
version value="1.1" date="09sep2021" author="nilsgregor@hsbcad.com"> HSB-12477 add multiselection of marking objects

Insert:
Set properties, select the marking object (line, polyline, grip), select the marked object(s) (beam, sheet, panel)

This tsl creates marks or marker lines on beam(s), sheet(s) or panel(s). The marking objects can be a line, a polyline or a grip.
The marking object is projected on the marked objects surface. So a marking on two faces can be the result. Curved timber can only be marked at the sides . 



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
/// <History>//region
/// #Versions:
// Version 1.3 28.09.2021 HSB-1247: fix grid points when 2  or more grid points are at same location Author: Marsel Nakuci
// Version 1.2 22.09.2021 HSB-1247: Plines and grids are projected to the body of the genbeam with their normal Author: Marsel Nakuci
/// <version value="1.1" date="09sep2021" author="nilsgregor@hsbcad.com"> HSB-12477 add multiselection of marking objects </version>
/// <version value="1.0" date="02sep2021" author="nilsgregor@hsbcad.com"> HSB-12477 initial </version>
/// </History>

/// <insert Lang=en>
/// Set properties, select the marking object (line, polyline, grip), select the marked object(s) (beam, sheet, panel)
/// </insert>

/// <summary Lang=en>
/// This tsl creates marks or marker lines on beam(s), sheet(s) or panel(s). The marking objects can be a line, a polyline or a grip.
/// The marking object is projected on the marked objects surface. So a marking on two faces can be the result. Curved timber can
/// only be marked at the sides . 
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbMark_LineAndRaster")) TSLCONTENT
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

String strJigAction1 = "strJigAction1";
if (_bOnJig && (_kExecuteKey == strJigAction1))
{ 
	Display dpHighlight(1);
	Display dpAdd(3);
	Display dpDontExist(7);
	Display dpRemove(1);
	Point3d ptJig = _Map.getPoint3d("_PtJig");
	Map mapGridsSelected = _Map.getMap("GridsSelected");
	int iGridsSelected[0];
	for (int igrid=0;igrid<mapGridsSelected.length();igrid++) 
	{ 
		iGridsSelected.append(mapGridsSelected.getInt(igrid)); 
	}//next igrid
	Map mapGridPoints = _Map.getMap("GridPoints");
	Point3d gripPts[0];
	for (int ipt=0;ipt<mapGridPoints.length();ipt++) 
	{ 
		gripPts.append(mapGridPoints.getPoint3d(ipt));
	}//next ipt
	Vector3d vecNormalMarking = _Map.getVector3d("vecNormalMarking");
//	dpHighlight.draw("aa", ptJig, _XW, _YW, 0, 0, _kDeviceX);
	// get the closest gridline
	
	double dClosest = U(10e6);
	int iClosest = -1;
	
	int iNrGrids = gripPts.length() / 3;
	Point3d pt1Closest, pt2Closest, pt3Closest;
	Vector3d vecDirClosest;
	for (int igrid=0;igrid<iNrGrids;igrid++) 
	{ 
		Point3d pt1 = gripPts[(igrid) * 3 + 0];
		Point3d pt2 = gripPts[(igrid) * 3 + 1];
		Point3d pt3 = gripPts[(igrid) * 3 + 2];
		
		Vector3d vecDir = pt3 - pt1;
		vecDir.normalize();
		Line ln(pt2, vecDir);
		// point ptInside inside 2 points pt1 and pt2
		int iInside=true;
		{ 
			double dLengthPtI=abs(vecDir.dotProduct(ptJig-pt1))
				 + abs(vecDir.dotProduct(ptJig - pt3));
			double dLengthSeg = abs(vecDir.dotProduct(pt1 - pt3));
			if (abs(dLengthPtI - dLengthSeg) > dEps)iInside=false;
		}
		if ( ! iInside)continue;
		double dDistanceI = (ln.closestPointTo(ptJig) - ptJig).length();
		if(dDistanceI<dClosest)
		{ 
			iClosest = igrid;
			dClosest = dDistanceI;
			pt1Closest = pt1;
			pt2Closest = pt2;
			pt3Closest = pt3;
			vecDirClosest = vecDir;
		}
	}//next igrid
	
	for (int igrid=0;igrid<iNrGrids;igrid++) 
	{ 
		if(iGridsSelected[igrid])
		{ 
			PLine plI;
			plI.addVertex(gripPts[(igrid) * 3 + 0]);
			plI.addVertex(gripPts[(igrid) * 3 + 1]);
			plI.addVertex(gripPts[(igrid) * 3 + 2]);
			dpAdd.draw(plI);
		}
		else
		{ 
			PLine plI;
			plI.addVertex(gripPts[(igrid) * 3 + 0]);
			plI.addVertex(gripPts[(igrid) * 3 + 1]);
			plI.addVertex(gripPts[(igrid) * 3 + 2]);
//			dpRemove.draw(plI);
			dpDontExist.draw(plI);
		}
	}//next igrid
	
	if(iClosest<0)
	{ 
		dpHighlight.draw("No Edge", ptJig, _XW, _YW, 0, 0, _kDeviceX);
		return;
	}
	Vector3d vecYgrid = vecDirClosest.crossProduct(vecNormalMarking);
	vecYgrid.normalize();
	
	PlaneProfile ppGridLine(Plane(pt3Closest, vecNormalMarking));
	PLine plRecGrid;
	plRecGrid.createRectangle(LineSeg(pt1Closest-vecYgrid*U(80),
		pt3Closest + vecYgrid * U(80)), vecDirClosest, vecYgrid);
	ppGridLine.joinRing(plRecGrid, _kAdd);
	
	if(iGridsSelected[iClosest])
	{ 
		dpRemove.draw(ppGridLine, _kDrawFilled);
	}
	else
	{ 
		dpAdd.draw(ppGridLine, _kDrawFilled);
	}
	
	return;
}
//region Properties
	category = T("|Filter definition for Genbeams|");
	String sFilterGbsNames[] = {"<" + T("|No defintion|")+">" }; 
	sFilterGbsNames.append(PainterDefinition().getAllEntryNames());
	String sFilterGbsName=T("|Filter|");	
	PropString sFilterGbs(nStringIndex++, sFilterGbsNames, sFilterGbsName);	
	sFilterGbs.setDescription(T("|Use a painter definition to filter the beams, sheets or panels|"));
	sFilterGbs.setCategory(category);
	if(_bOnDbCreated)
		sFilterGbs.setReadOnly(_kHidden);
	
	category = T("|Marking definition|");
	String sMarkTypeNames[] = { T("|Mark|"), T("|Markerline|")};
	String sMarkTypeName=T("|Mark Type|");	
	PropString sMarkType(nStringIndex++, sMarkTypeNames, sMarkTypeName);	
	sMarkType.setDescription(T("|Defines if a mark or a marker line is used|"));
	sMarkType.setCategory(category);
	int nMarkType = sMarkTypeNames.find(sMarkType);
	
	String sFullLengthName=T("|Mark full length|");	
	PropString sFullLength(nStringIndex++, sNoYes, sFullLengthName);	
	sFullLength.setDescription(T("|Defines if the marking is using the complete height of the face|"));
	sFullLength.setCategory(category);	
	int nFullLength = sNoYes.find(sFullLength);
	sFullLength.setReadOnly(false);
	
	String sMarkSideNames[] = { T("|Closest side|"), T("|Opposite side|"), T("|Left side|"), T("|Right side|")};
	String sMarkSideName=T("|Mark Side|");	
	PropString sMarkSide(nStringIndex++, sMarkSideNames, sMarkSideName);	
	sMarkSide.setDescription(T("|Defines the marked side|"));
	sMarkSide.setCategory(category);
	int nMarkSide = sMarkSideNames.find(sMarkSide);
	sMarkSide.setReadOnly(false);
	
	String sRemoveMarkingObjectName=T("|Remove marking object|");	
	PropString sRemoveMarkingObject(nStringIndex++, sNoYes, sRemoveMarkingObjectName);	
	sRemoveMarkingObject.setDescription(T("|Removes the marking object after creating the marking|"));
	sRemoveMarkingObject.setCategory(category);
	int nRemoveMarkingObject = sNoYes.find(sRemoveMarkingObject);
	
	category = T("|Tool instance definition|");
	String sRemoveInstanceName=T("|Remove Instance|");	
	PropString sRemoveInstance(nStringIndex++, sNoYes, sRemoveInstanceName);	
	sRemoveInstance.setDescription(T("|Removes this tools instance affter creating the marking|"));
	sRemoveInstance.setCategory(category);
	int nRemoveInstance = sNoYes.find(sRemoveInstance);	
	
	String sColorName=T("|Color of marks|");	
	int nColors[]={1,2,3,4,5,6};
	PropInt nColor(nIntIndex++, nColors, sColorName,2);	
	nColor.setDescription(T("|Defines the color of the tool representation|"));
	nColor.setCategory(category);
	
	category = T("|Text settings|");
	String sTxtName=T("|Text|");	
	PropString sTxt(nStringIndex++, "", sTxtName);	
	sTxt.setDescription(T("|Defines the format variable and/or any static text.|")+
		T("|i.e. this argument would display the area in [m²], rounded to 3 decimal digits|: ")+"@(Area:CU;m:RL3)m²");
	sTxt.setCategory(category);
	
	String sTxtHeightName=T("|Text height|");	
	PropDouble dTxtHeight(nDoubleIndex++, U(30), sTxtHeightName);	
	dTxtHeight.setDescription(T("|Defines the text height|"));
	dTxtHeight.setCategory(category);
	
	String sTxtPositionNames[] = { T("|Right|"), T("|Middle|"), T("|Left|")};
	String sTxtPositionName=T("|Text position|");	
	PropString sTxtPosition(nStringIndex++, sTxtPositionNames, sTxtPositionName);	
	sTxtPosition.setDescription(T("|Defines the text position perpendicular to the mark|"));
	sTxtPosition.setCategory(category);
	int nTxtPosition = sTxtPositionNames.find(sTxtPosition)-1;
	
	String sTxtDirectionName=T("|Change text direction|");	
	PropString sTxtDirection(nStringIndex++, sNoYes, sTxtDirectionName);	
	sTxtDirection.setDescription(T("|Changes the text in a readable direction|"));
	sTxtDirection.setCategory(category);
	int nTxtDirection = sNoYes.find(sTxtDirection);	
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
		
		
		Entity entMarks[0];
		
		while(entMarks.length() < 1)
		{
			Entity entsInput[0];
			PrEntity ssE(TN("|Select line, polyline or grid as marking object|")); 
			if (ssE.go()==_kOk) 
				entsInput.append(ssE.set()); 
			
			for(int i=0; i < entsInput.length(); i++)
			{
				String sType = entsInput[i].typeName();
				
				if(sType == "AecDbColumnGrid" || sType == "AcDbLine" || sType == "AcDbPolyline")
				{
					entMarks.append(entsInput[i]);
				}				
			}

			if(entMarks.length() < 1)
				reportMessage(TN("|Selected entities where not of type Line, Polyline or Grid|"));
			else
				reportMessage("\n"+entMarks.length()+" "+T("|marking objects found|"));				
		}
		
		// prompt for point input
		PrEntity ssE(TN("|Select panel(s), beam(s) or sheet(s) to be a mark|"), GenBeam()); 
		if (ssE.go()==_kOk) 
			_Entity.append(ssE.set()); 
		
		//Use painter filter on gbs
		if(sFilterGbsNames.find(sFilterGbs) > 0)
		{
			PainterDefinition mps(sFilterGbs);
			_Entity = mps.filterAcceptedEntities(_Entity);
		}
		
		for(int h=0; h < entMarks.length(); h++)
		{
			Entity entMark = entMarks[h];
			
			for(int i=0; i < _Entity.length();i++)
			{
				GenBeam gb = (GenBeam)_Entity[i];
				
				
			// create TSL
				TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {gb};		Entity entsTsl[] = {entMark};			Point3d ptsTsl[] = {gb.ptCen()};
				int nProps[]={nColor};			double dProps[]={dTxtHeight};				
				String sProps[]={sFilterGbs, sMarkType, sFullLength, sMarkSide, sRemoveMarkingObject, sRemoveInstance, sTxt, sTxtPosition, sTxtDirection};
				Map mapTsl;	
				
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
			}			
		}
		
		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion
	
	Point3d gripPts[0];
	Vector3d vecNormalMarking;
	//General check
	if (nRemoveMarkingObject && _Map.hasPoint3dArray("Points"))
	{
		gripPts = _Map.getPoint3dArray("Points");
		vecNormalMarking = _Map.getVector3d("vecNormalMarking");
		if(gripPts.length() == 2)
			gripPts.append(PLine(gripPts[1], gripPts[0]).ptMid());
		else
		{
			reportMessage("\n"+scriptName()+" "+T("|Unexpected error|"));
			reportMessage(TN("|Instance will be deleted|"));
			eraseInstance();
			return;			
		}
	}
	else
	{
		if(_Entity.length() < 1 || _GenBeam.length() < 1)
		{
			reportMessage("\n"+scriptName()+" "+T("IThe marking or the marked object is missing.|"));	
			reportMessage(TN("|Instance will be deleted|"));
			eraseInstance();
			return;
		}	
		gripPts = _Entity[0].gripPoints();
		EntPLine ePl = (EntPLine)_Entity[0];
		Grid grid = (Grid)_Entity[0];
		String sType = _Entity[0].typeName();
		if(ePl.bIsValid())
		{ 
			PLine pl = ePl.getPLine();
			CoordSys csPline = pl.coordSys();
			vecNormalMarking = csPline.vecZ();
		}
		else if(grid.bIsValid())
		{ 
			// hsb_grid
			CoordSys csGrid = grid.coordSys();
			vecNormalMarking = csGrid.vecZ();
		}
		else if(_Entity[0].typeName()=="AecDbColumnGrid")
		{ 
			// Acad grid
			vecNormalMarking = _ZW;
		}
		else
		{ 
			// line
		}
	}
	for (int ip=0;ip<gripPts.length();ip++) 
	{ 
//		if(ip>8)
//			gripPts[ip].vis(4); 
//		else
//			gripPts[ip].vis(1); 
	}//next ip
	
	String s = _Entity[0].typeName();
	int iLine, iGrid, iPline;
	if (s == "AcDbLine")iLine = true;
	if (s == "AecDbColumnGrid")iGrid = true;
	if (s == "AcDbPolyline")iPline = true;
	
	if(gripPts.length() < 3)
	{
		reportMessage("\n"+scriptName()+" "+T("|The marking object does not have points to create a mark|"));	
		reportMessage(TN("|Instance will be deleted|"));
		eraseInstance();
		return;
	}
	
	_Entity.append(_GenBeam[0]);
	GenBeam gb = _GenBeam[0];	
	Body bdGb = gb.envelopeBody();	
	
	_ThisInst.setAllowGripAtPt0(false);
	setDependencyOnBeamLength(gb);
	if(!nRemoveMarkingObject)
		setDependencyOnEntity(_Entity[0]);
	else if(_Entity.length() > 0)
		_Entity[0].dbErase();
	
	assignToGroups(gb, 'T');	
		
	TslInst tsls[] = gb.tslInstAttached();
	for(int i= tsls.length()-1; i > -1; i--)
	{
		if(tsls[i].scriptName() != scriptName() || tsls[i] == _ThisInst)
			tsls.removeAt(i);
	}
	
	CoordSys csGb = gb.coordSys();
	Vector3d vecX = csGb.vecX();
	Vector3d vecY = csGb.vecY();
	Vector3d vecZ = csGb.vecZ();
	Point3d ptCen = csGb.ptOrg();
	
	Point3d ptCenGb = gb.ptCen();
	Vector3d vecXgB = gb.vecX();
	Vector3d vecYgB = gb.vecY();
	Vector3d vecZgB = gb.vecZ();
	
	Beam bmTest = (Beam)gb;
	int bIsCurved;
	Vector3d vecNoMark;
	
	if(bmTest.bIsValid())
	{
		bIsCurved = (bmTest.curvedStyle() == _kStraight || bmTest.curvedStyle() == "" ) ? false : true;
		vecNoMark = (bmTest.dD(vecY) < bmTest.dD(vecZ)) ? vecZ : vecY;
	}
	int bNoMarkCreated = true;
	
//region Formatting
	String sVariables[]=_ThisInst.formatObjectVariables();
	Map mapAdditionals;	
	{ 
//		String k;
//		k = "Area";
//		if (sVariables.findNoCase(k,-1)<0)
//		{
//			mapAdditionals.setDouble(k, ppShapeOpening.area(), _kArea);
//			sVariables.append(k);
//		}
	}		
//endregion

//region Add/RemoveFormat
	String sTriggerAddRemoveFormat = T("|Add/Remove Format|");
	addRecalcTrigger(_kContextRoot, sTriggerAddRemoveFormat );
	if (_bOnRecalc && (_kExecuteKey==sTriggerAddRemoveFormat))
	{
		String sPrompt;
		sPrompt+="\n"+  T("|Select a property by index to add or to remove|") + T(", |0 = Exit|");
		reportNotice("\n"+sPrompt);

		for (int s=0;s<sVariables.length();s++) 
		{ 
			String key = sVariables[s]; 
			String value;
			if (mapAdditionals.hasString(key))
				value = mapAdditionals.getString(key);
			else if (mapAdditionals.hasDouble(key))
				value = mapAdditionals.getDouble(key);
			else if (mapAdditionals.hasInt(key))
				value = mapAdditionals.getInt(key);
			else
				value = _ThisInst.formatObject("@(" + key + ")");

//			String sAddRemove = sFormat.find(key,0, false)<0?"   " : "√";
			String sAddRemove = sTxt.find(key,0, false)<0?"   " : "√";
			int x = s + 1;
			String sIndex = ((x<10)?"    " + x:"  " + x)+ "  "+sAddRemove+"   ";//
			
			reportNotice("\n"+sIndex+T("|"+key +"|")+ "........: "+ value);
			
		}//next i
		reportNotice("\n"+sPrompt);
		int nRetVal = getInt(sPrompt)-1;	
		
	// select property	
		while (nRetVal>-1)
		{ 
			if (nRetVal>-1 && nRetVal<=sVariables.length())
			{ 
				String newFormat = sTxt;
	
			// get variable	and append if not already in list	
				String variable ="@(" + sVariables[nRetVal] + ")";
				int x = sTxt.find(variable, 0);
				if (x>-1)
				{
					int y = sTxt.find(")", x);
					String left = sTxt.left(x);
					String right= sTxt.right(sTxt.length()-y-1);
					newFormat = left + right;
					//reportMessage("\n" + sVariables[nRetVal] + " new: " + newFormat);				
				}
				else
				{ 
					newFormat+="@(" +sVariables[nRetVal]+")";
				}
				sTxt.set(newFormat);
				reportMessage("\n" + sTxtName + " " + T("|set to|")+" " +sTxt);	
				reportNotice("\n" + sTxtName + " " + T("|set to|")+" " +sTxt);	
			}
			nRetVal = getInt(sPrompt)-1;
		}
		
		setExecutionLoops(2);
		return;
	}
//endregion

if(iGrid)
{ 
	// for grids test that each segment has 3 points
	// in case one has 2 then the third point must be found
	Point3d gripPtsNew[0];
	int iIndex = 0;
	for (int ip=0;ip<gripPts.length();ip++) 
	{ 
		if (iIndex + 2 > gripPts.length())break;
		Point3d pt1 = gripPts[iIndex];
		Point3d pt2 = gripPts[iIndex+1];
		Point3d pt3 = gripPts[iIndex+2];
		
		Vector3d vecDir = pt2 - pt1;
		vecDir.normalize();
		Line ln(pt1, vecDir);
		Point3d pt3Ln = ln.closestPointTo(pt3);
		if((pt3Ln-pt3).length()>dEps)
		{ 
			// find point pt3
			Point3d pt3New;
			Point3d pts3New[0];
			for (int jpt=0;jpt<gripPts.length();jpt++) 
			{ 
				if(jpt!=iIndex && jpt!=(iIndex+1))
				{ 
					if((ln.closestPointTo(gripPts[jpt]) - gripPts[jpt]).length() < dEps)
					{ 
						pt3New = gripPts[jpt];
//						gripPtsNew.append(pt1);
//						gripPtsNew.append(pt2);
//						gripPtsNew.append(pt3New);
						pts3New.append(pt3New);
//						iIndex += 2;
//						break;
					}
				}
			}//next jpt
			if(pts3New.length()==0)
			{ 
				iIndex += 1;
				continue;
			}
			// get extreme points
			Point3d pt1Left=pt1;
			Point3d pt2Right=pt2;
			if(vecDir.dotProduct(pt2-pt1)<0)
			{ 
				pt1Left = pt2;
				pt2Right = pt1;
			}
			for (int jpt=0;jpt<pts3New.length();jpt++) 
			{ 
				if(vecDir.dotProduct(pts3New[jpt]-pt1Left)<0)
				{ 
					pt1Left = pts3New[jpt];
				}
				if(vecDir.dotProduct(pts3New[jpt]-pt2Right)>0)
				{ 
					pt2Right = pts3New[jpt];
				}
			}//next jpt
			gripPtsNew.append(pt1Left);
			gripPtsNew.append(.5*(pt1Left+pt2Right));
			gripPtsNew.append(pt2Right);
			iIndex += 2;
		}
		else
		{ 
			// 3 points OK
			gripPtsNew.append(pt1);
			gripPtsNew.append(pt2);
			gripPtsNew.append(pt3);
			iIndex += 3;
		}
	}//next ip
	
	gripPts.setLength(0);
	gripPts.append(gripPtsNew);
}

for (int ipt=0;ipt<gripPts.length();ipt++) 
{ 
	gripPts[ipt].vis(1);
	 
}//next ipt


if(!_Map.hasMap("GridsSelected"))
{ 
	// initialize
	Map mapGridsSelectedInit;
	int iNrGridLines = gripPts.length() / 3;
	for (int igrid=0;igrid<iNrGridLines;igrid++) 
	{ 
		mapGridsSelectedInit.setInt(igrid, true);
	}//next igrid
	_Map.setMap("GridsSelected", mapGridsSelectedInit);
//	int iGridsSelected[0];
//	for (int igrid=0;igrid<mapGridsSelectedInit.length();igrid++) 
//	{ 
//		iGridsSelected.append(mapGridsSelectedInit.getInt(igrid)); 
//		 
//	}//next igrid
}
if(iGrid)
{ 
	Map mapGridsSelected = _Map.getMap("GridsSelected");
	int iGridsSelected[0];
	for (int igrid=0;igrid<mapGridsSelected.length();igrid++) 
	{ 
		iGridsSelected.append(mapGridsSelected.getInt(igrid)); 
	}//next igrid
	
	Map mapGridPoints;
	for (int ipt=0;ipt<gripPts.length();ipt++) 
	{ 
		mapGridPoints.setPoint3d(ipt, gripPts[ipt]);
	}//next ipt
	
	// trigger to add/remove gridlines
	//region Trigger addRemoveGridLine
	String sTriggeraddRemoveGridLine = T("|Add/Remove Grid Line|");
	addRecalcTrigger(_kContextRoot, sTriggeraddRemoveGridLine );
	if (_bOnRecalc && _kExecuteKey==sTriggeraddRemoveGridLine)
	{
		int iCount = 0;
		Map mapArgs;
		mapArgs.setMap("GridsSelected", mapGridsSelected);
		mapArgs.setMap("GridPoints", mapGridPoints);
		mapArgs.setVector3d("vecNormalMarking", vecNormalMarking);
		while (iCount<100)
		{ 
			
		
			// prompt for point input
			PrPoint ssP(TN("|Select Grid Line to Add/Remove|")); 
			ssP.setSnapMode(TRUE, 0); 
			
			
			
			int nGoJig = -1;
			while (nGoJig != _kOk)
			{
				nGoJig = ssP.goJig(strJigAction1, mapArgs);
				if (nGoJig == _kOk)
				{
					Point3d ptJig;
					ptJig = ssP.value();
					// find the closest 
					// 
					double dClosest = U(10e6);
					int iClosest = -1;
					
					int iNrGrids = gripPts.length() / 3;
					Point3d pt1Closest, pt2Closest, pt3Closest;
					Vector3d vecDirClosest;
					for (int igrid=0;igrid<iNrGrids;igrid++) 
					{ 
						Point3d pt1 = gripPts[(igrid) * 3 + 0];
						Point3d pt2 = gripPts[(igrid) * 3 + 1];
						Point3d pt3 = gripPts[(igrid) * 3 + 2];
						
						Vector3d vecDir = pt3 - pt1;
						vecDir.normalize();
						Line ln(pt2, vecDir);
						
						double dDistanceI = (ln.closestPointTo(ptJig) - ptJig).length();
						if(dDistanceI<dClosest)
						{ 
							iClosest = igrid;
							dClosest = dDistanceI;
							pt1Closest = pt1;
							pt2Closest = pt2;
							pt3Closest = pt3;
							vecDirClosest = vecDir;
						}
					}//next igrid
					Vector3d vecYgrid = vecDirClosest.crossProduct(vecNormalMarking);
					vecYgrid.normalize();
					iGridsSelected[iClosest] =! iGridsSelected[iClosest];
					Map mapGridsSelectedNew;
	
					for (int igrid=0;igrid<iNrGrids;igrid++) 
					{ 
						mapGridsSelectedNew.setInt(igrid, iGridsSelected[igrid]);
					}//next igrid
					_Map.setMap("GridsSelected", mapGridsSelectedNew);
					mapArgs.setMap("GridsSelected", mapGridsSelectedNew);
				}
				else
				{ 
					setExecutionLoops(2);
					return;
				}
			}
		iCount++;
		}
//		if (ssP.go()==_kOk) 
//			_PtG.append(ssP.value()); // append the selected points to the list of grippoints _PtG
		setExecutionLoops(2);
		return;
	}//endregion	
	int iNrGrids = gripPts.length() / 3;
	Point3d gripPtsSelected[0];
	for (int igrid=0;igrid<iNrGrids;igrid++) 
	{ 
		if(iGridsSelected[igrid])
		{ 
			gripPtsSelected.append(gripPts[(igrid) * 3 + 0]);
			gripPtsSelected.append(gripPts[(igrid) * 3 + 1]);
			gripPtsSelected.append(gripPts[(igrid) * 3 + 2]);
		}
		 
	}//next igrid
	gripPts.setLength(0);
	gripPts.append(gripPtsSelected);
}


//region project points to the surface of the panel
	int indexPlanes[0];
	// store index of grids for each point
	int indexGrids[0];
	PlaneProfile ppsRelevant[0], ppsRelevantRef[0];
	int indexGrid, iFactorGrid;
	if (vecNormalMarking != Vector3d(0, 0, 0))
	{ 
		// project points to corresponding side of genbeam
		Point3d _gripPts[0], _gripPtsRef[0];
		int _indexPlanes[0], _indexPlanesRef[0];
		int _indexGrids[0];
		// we have a grid or a pline
		// can project the points to the panel surface
		Point3d ptAvg;
		for (int ip=0;ip<gripPts.length();ip++) 
		{ 
			ptAvg += gripPts[ip];
		}//next ip
		
		ptAvg /= (gripPts.length());
//		ptAvg.vis(3);
		Plane pnRef(ptAvg, vecNormalMarking);
		Quader qd(ptCenGb, vecXgB, vecYgB, vecZgB, gb.dL(), gb.dW(), gb.dH(), 0, 0, 0);
		Vector3d vecs[] ={ vecXgB ,- vecXgB, vecYgB ,- vecYgB, vecZgB ,- vecZgB};
		Vector3d vecs1[] ={ vecYgB, vecYgB, vecXgB, vecXgB, vecYgB, vecYgB};
		Vector3d vecs2[] ={ vecZgB, - vecZgB, - vecZgB, - vecZgB, vecXgB, vecXgB};
		// collect only vecs that are codirectional with vecNormalMarking
		Vector3d vecsRelevant[0], vecs1Relevant[0], vecs2Relevant[0];
		for (int i=0;i<vecs.length();i++) 
		{ 
			if(vecNormalMarking.dotProduct(vecs[i])>0)
			{ 
//				vecs[i].vis(_Pt0, 2);
				vecsRelevant.append(vecs[i]);
				vecs1Relevant.append(vecs1[i]);
				vecs2Relevant.append(vecs2[i]);
			}
		}//next i
		// collect all relevant sides 
		
		PLine plsRelevant[0], plsRelevantRef[0];
		for (int i=0;i<vecsRelevant.length();i++) 
		{ 
			Point3d ptSide = ptCenGb + .5 * vecsRelevant[i] * qd.dD(vecsRelevant[i]);
//			Point3d ptSide = ptCenGb;
//			ptSide.vis(3);
			PlaneProfile ppI(Plane(ptSide, vecsRelevant[i]));
			PlaneProfile ppIref(pnRef);
			PLine plI;
			plI.createRectangle(LineSeg(ptSide - vecs1Relevant[i] * .5 * qd.dD(vecs1Relevant[i]) - vecs2Relevant[i] * .5 * qd.dD(vecs2Relevant[i]),	
				ptSide + vecs1Relevant[i] * .5 * qd.dD(vecs1Relevant[i]) + vecs2Relevant[i] * .5 * qd.dD(vecs2Relevant[i])), vecs1Relevant[i], vecs2Relevant[i]);
			plsRelevant.append(plI);
			ppI.joinRing(plI, _kAdd);
			ppsRelevant.append(ppI);
//			ppI.vis(3);
			
			plI.projectPointsToPlane(pnRef,vecNormalMarking);
			ppIref.joinRing(plI, _kAdd);
			plsRelevantRef.append(plI);
//			ppIref.vis(4);
			ppsRelevantRef.append(ppIref);
			
			// check if ppiref intersects with line
		}//next i
		// each point will be assigned a plane index
		
		for (int ip=0;ip<gripPts.length()-1;ip++) 
		{ 
			int iFactorGridI = (ip+1) / 3;
			if(iGrid)
			{ 
				if(iFactorGridI>iFactorGrid)
				{ 
					iFactorGrid = iFactorGridI;
					continue;
				}
			}
			Point3d pt1 = gripPts[ip];
			Point3d pt2 = gripPts[ip + 1];
			
			Vector3d vecDir = pt2 - pt1;
			vecDir.normalize();
			Vector3d vecYpn = vecNormalMarking.crossProduct(vecDir);
			vecYpn.normalize();
			double dL = abs(vecDir.dotProduct(pt2 - pt1));
			Point3d ptMid = .5 * (pt1 + pt2);
			PLine plStrip;
			plStrip.createRectangle(LineSeg(ptMid-.5*dL*vecDir-U(.1)*vecYpn,
				ptMid + .5 * dL * vecDir + U(.1) * vecYpn), vecDir, vecYpn);
			PlaneProfile ppStripI(pnRef);
			ppStripI.joinRing(plStrip, _kAdd);
//			ppStripI.vis(9);
			
			// 
			Point3d ptGripsSegI[0], ptGripsSegIRef[0];
			int indexPlanesSegI[0], indexPlanesSegIRef[0];
			int indexGridsSegI[0];
			for (int jpp=0;jpp<plsRelevantRef.length();jpp++) 
			{ 
				PlaneProfile ppJ = ppsRelevantRef[jpp];
				PlaneProfile ppIntersect = ppStripI;
				
				int iIntersect = ppIntersect.intersectWith(ppJ);
				if ( ! iIntersect)continue;
//				ppIntersect.vis(4);
				PLine plsIntersect[] = ppIntersect.allRings();
				PLine plIntersect = plsIntersect[0];
				// get two points
				// get extents of profile
				LineSeg seg = ppIntersect.extentInDir(vecDir);
				Line lnIntersect(seg.ptMid(), vecDir);
				
				Point3d ptsIntersect[] = plIntersect.intersectPoints(lnIntersect);
				double dX = abs(vecDir.dotProduct(seg.ptStart()-seg.ptEnd()));
				
//				Point3d pt1New = seg.ptMid() - vecDir * .5 * dX;
//				Point3d pt2New = seg.ptMid() + vecDir * .5 * dX;
				if (ptsIntersect.length() < 2)continue;
				Point3d pt1New = ptsIntersect.first();
				Point3d pt2New = ptsIntersect.last();
				if(vecDir.dotProduct(pt2New-pt1New)<0)
				{ 
					pt1New = ptsIntersect.last();
					pt2New = ptsIntersect.first();
				}
				// 
				// project to plane of the panel
				Point3d pt1NewRef, pt2NewRef;
				Plane pnPanelJ(ppsRelevant[jpp].coordSys().ptOrg(), ppsRelevant[jpp].coordSys().vecZ());
				int i1=Line(pt1New, vecNormalMarking).hasIntersection(pnPanelJ, pt1NewRef);
				int i2=Line(pt2New, vecNormalMarking).hasIntersection(pnPanelJ, pt2NewRef);
				
				int iAdd1=true;
				for (int jp=0;jp<ptGripsSegIRef.length();jp++) 
				{ 
					if((ptGripsSegIRef[jp]-pt1NewRef).length()<.1*dEps)
					{ 
						iAdd1 = false;
						break;
					}
				}//next jp
				int iAdd2=true;
				for (int jp=0;jp<ptGripsSegIRef.length();jp++) 
				{ 
					if((ptGripsSegIRef[jp]-pt2NewRef).length()<.1*dEps)
					{ 
						iAdd2 = false;
						break;
					}
				}//next jp
				
				if (iAdd1) 
				{
//					pt1New.vis(1);
					ptGripsSegI.append(pt1New);
					indexPlanesSegI.append(jpp);
					ptGripsSegIRef.append(pt1NewRef);
					indexPlanesSegIRef.append(jpp);
					indexGridsSegI.append(iFactorGridI);
				}
				
				if (iAdd2) 
				{
//					pt2New.vis(1);
					
					ptGripsSegI.append(pt2New);
					indexPlanesSegI.append(jpp);
					ptGripsSegIRef.append(pt2NewRef);
					indexPlanesSegIRef.append(jpp);
					indexGridsSegI.append(iFactorGridI);
				}
			}//next jpp
			// sort points with vecdir
			// order alphabetically
			for (int i=0;i<ptGripsSegI.length();i++) 
				for (int j=0;j<ptGripsSegI.length()-1;j++) 
					if (vecDir.dotProduct(ptGripsSegI[j]-ptGripsSegI[j+1])>0)
						{
							ptGripsSegI.swap(j, j + 1);
							ptGripsSegIRef.swap(j, j + 1);
							indexPlanesSegI.swap(j, j + 1);
							indexPlanesSegIRef.swap(j, j + 1);
							indexGridsSegI.swap(j, j + 1);
						}
			
			for (int i=0;i<ptGripsSegI.length();i++) 
			{ 
//				if (_gripPts.find(ptGripsSegI[i]) < 0)_gripPts.append(ptGripsSegI[i]);
//				if (_gripPtsRef.find(ptGripsSegIRef[i]) < 0)_gripPtsRef.append(ptGripsSegIRef[i]);
				_gripPts.append(ptGripsSegI[i]);
				_gripPtsRef.append(ptGripsSegIRef[i]);
				_indexPlanes.append(indexPlanesSegI[i]);
				_indexPlanesRef.append(indexPlanesSegIRef[i]);
				_indexGrids.append(indexGridsSegI[i]);
			}//next i
			
		}//next ip
//		for (int i=0;i<_gripPts.length();i++) 
//		{ 
//			_gripPts[i].vis(2); 
//			_gripPtsRef[i].vis(2); 
//		}//next i
		gripPts.setLength(0);
		gripPts.append(_gripPtsRef);
		indexPlanes.append(_indexPlanesRef);
		indexGrids.append(_indexGrids);
		for (int i=0;i<gripPts.length();i++) 
		{ 
//			gripPts[i].vis(2); 
//			_gripPts[i].vis(3); 
		}//next i
	}
//End project points to the surface of the panel//endregion 	
for (int ipt=0;ipt<gripPts.length();ipt++) 
{ 
	gripPts[ipt].vis(1); 
	 
}//next ipt

if (iPline || iGrid)
{ 
	for(int i=0; i < gripPts.length()-1; i++)
	{	
		if(iGrid)
		{ 
			if(i>0)
			{ 
				if (indexGrids[i+1] > indexGrids[i])continue;
			}
		}
		
	//region Create a PLine with a cartesian coordinate system
//		Vector3d vecL1 (gripPts[i] - gripPts[i - 1]);
		Vector3d vecL1 (gripPts[i+1] - gripPts[i]);
		vecL1.normalize();
		Vector3d vecL2 = vecX.isParallelTo(vecL1)? vecY.crossProduct(vecL1) : vecX.crossProduct(vecL1);
		vecL2.normalize();
		Vector3d vecL3 = vecL1.crossProduct(vecL2);	
		vecL3.normalize();
		
//		Line lnL(gripPts[i - 1], vecL1);
		Line lnL(gripPts[i], vecL1);
//		lnL.vis(5);
//		Point3d ptsAll[] = { gripPts[i - 1], gripPts[i], gripPts[i + 1]};
//		
//		if((lnL.closestPointTo(gripPts[i+1]) - gripPts[i+1]).length() > dEps)
//		{ 
//			int bContinue = true;
//			
//			for(int j=0; j < gripPts.length(); j++)
//			{
//				if(j < i-1 ||  j > i+1)
//				{
//					if((lnL.closestPointTo(gripPts[j]) - gripPts[j]).length() < dEps)
//					{
//						ptsAll.setLength(0);
//						ptsAll.append( gripPts[i - 1]);
//						ptsAll.append( gripPts[i]);
//						ptsAll.append( gripPts[j]);
//						bContinue = false;
//						break;
//					}
//				}
//			}
//			
//			if(bContinue)
//				continue;
//		}
		
//		Point3d ptsL[] = lnL.orderPoints( ptsAll);
//		PLine plL(ptsL.first(), ptsL.last());
		PLine plL(gripPts[i], gripPts[i+1]);
		if ((gripPts[i] - gripPts[i + 1]).length() < dEps)continue;
//		plL.vis(5);
		Point3d ptPlMid = plL.ptMid();
		
		vecL1.vis(plL.ptMid(), 1); vecL2.vis(plL.ptMid(), 2); vecL3.vis(plL.ptMid(), 3); 			
	//End Create a PLine with a cartesian coordinate system//endregion 
	
		PlaneProfile ppMarks[0];
		if (vecNormalMarking != Vector3d(0, 0, 0))
		{ 
			Vector3d vecFace = ppsRelevant[indexPlanes[i]].coordSys().vecZ();
			if(abs(abs(vecFace.dotProduct(vecL2))-1.0)>.1)
			{
				ppMarks.append(bdGb.getSlice(Plane(ptPlMid, vecL2)));
			}
			if(abs(abs(vecFace.dotProduct(vecL3))-1.0)>.1)
			{
				ppMarks.append(bdGb.getSlice(Plane(ptPlMid, vecL3)));
			}
		}
		else
		{ 
			ppMarks.append(bdGb.getSlice(Plane(ptPlMid, vecL2)));
			ppMarks.append(bdGb.getSlice(Plane(ptPlMid, vecL3)));
		}
		
		for(int j=0; j < ppMarks.length();j++)
		{
			if(ppMarks[j].area() < pow(dEps,2))
				continue;
			
			Point3d ptTxt;
			PlaneProfile ppMark = ppMarks[j];
//			ppMark.vis(6);
			Point3d ptsPP[] = ppMark.getGripVertexPoints();
			Point3d ptsInter[] = lnL.orderPoints(ptsPP);
			double dFirst = vecL1.dotProduct(ptsInter.last() - plL.ptStart());
			double dLast = vecL1.dotProduct(plL.ptEnd() - ptsInter.first());
			
			if(dFirst < dEps || dLast < dEps)
				continue;
			
//			plL.vis(3);
			Point3d ptsOnFace[0];
			ptsOnFace.append(ppMark.closestPointTo(plL.ptStart()));
			ptsOnFace.append(ppMark.closestPointTo(plL.ptEnd())); 
			
			if(ptsOnFace.length() != 2 || (ptsOnFace[1] - ptsOnFace[0]).length() < dEps)
				continue;
//			ptsOnFace[0].vis(1);
//			ptsOnFace[1].vis(1);
			// Remove this instance, if an instance already exists at this position
			for(int k=0; k < tsls.length();k++)
			{
				Point3d ptsTsl[] = tsls[k].map().getPoint3dArray("Points");
				
				if(ptsTsl.length() < 2)
					continue;
				
				PLine pl(ptsTsl.first(), ptsTsl.last());
				
				if(pl.isOn(ptsOnFace[0]) && pl.isOn(ptsOnFace[1]))
				{
					reportMessage("\n"+scriptName()+" "+T("|marking already exists at this position|"));
					reportMessage(TN("|Instance will be deleted|"));
					eraseInstance();
					return;							
				}
			}
						
			PLine plsPt[0];
			ptsPP.append(ptsPP.first());
			
			//region Get the marked side(s) of the object
			{ 	
				if(ppMark.pointInProfile(PLine(ptsOnFace[0], ptsOnFace[1]). ptMid()) == _kPointOnRing)
				{ 
					for(int k=0; k < ptsPP.length()-1; k++)
					{
						PLine pl(ptsPP[k], ptsPP[k + 1]);
						
						if(pl.isOn(ptsOnFace[0]) && pl.isOn(ptsOnFace[1]))
						{
							plsPt.append(pl);		
							ptTxt = pl.ptStart();
							break;
						}
					}				
				}
				else if(ppMark.pointInProfile(PLine(ptsOnFace[0], ptsOnFace[1]). ptMid()) == _kPointInProfile)
				{
					continue;
				}
				else //If points are at two sides, find the sides closest to the marking object
				{
					PLine pl1s[0], pl2s[0];
					
					for(int k=0; k < ptsPP.length()-1; k++)
					{
						PLine pl(ptsPP[k], ptsPP[k + 1]);
											
						if(pl.isOn(ptsOnFace[0]))
							pl1s.append(pl);						
	
						else if(pl.isOn(ptsOnFace[1]))
							pl2s.append(pl);				
					}
					
					if(pl1s.length() > 1)
					{
						double d1 = (pl1s[0].ptMid() - plL.closestPointTo(pl1s[0].ptMid())).length();
						double d2 = (pl1s[1].ptMid() - plL.closestPointTo(pl1s[1].ptMid())).length();
						plsPt.append(d1 < d2 ? pl1s[0] : pl1s[1]);
					}
					else if(pl1s.length() ==1)
						plsPt.append(pl1s[0]);
					if(pl2s.length() > 1)
					{
						double d1 = (pl2s[0].ptMid() - plL.closestPointTo(pl2s[0].ptMid())).length();
						double d2 = (pl2s[1].ptMid() - plL.closestPointTo(pl2s[1].ptMid())).length();
						plsPt.append(d1 < d2 ? pl2s[0] : pl2s[1]);
					}
					else if(pl2s.length() == 1)
						plsPt.append(pl2s[0]);
				}				
			}	
			//End Get the marked side(s) of the object//endregion 
								
			if(plsPt.length() < 1)
				continue;
				
			PLine plsMark[0];
			
			//Get the vecNormal of the face
			Vector3d vecsN[0];
			for(int k=0; k < plsPt.length();k++)
			{
				Vector3d vec(plsPt[k].ptMid() - ppMark.ptMid());
				vec.normalize();
				vec = Vector3d(plsPt[k].ptMid() + vec * U(1) - plsPt[k].closestPointTo(plsPt[k].ptMid() + vec * U(1)));
				vec.normalize();
				vecsN.append(vec);
			}
			
			// Check if one or two marks are needed and if marks have full length
			if(plsPt.length() == 1 && vecsN.length() == 1)
			{
				if(nFullLength == 1)
					plsMark.append(plsPt[0]);
				else
					plsMark.append(PLine(ptsOnFace[0], ptsOnFace[1]));
			}
			else if(plsPt.length() == 2 && vecsN.length() == 2)
			{
				sMarkSide.set(sMarkSideNames[0]);
				sMarkSide.setReadOnly(true);
				
				Point3d ptsJoin[] = plsPt[0].intersectPLine(plsPt[1]);
				if(ptsJoin.length() == 1)
				{
					if(nFullLength == 1)
					{
						plsMark.append(plsPt[0]);
						plsMark.append(plsPt[1]);
					}
					else
					{
						Point3d ptsJoin[] = plsPt[0]. intersectPLine(plsPt[1]);
						
						if(ptsJoin.length() == 1)
						{	
							plsMark.append(PLine(ptsOnFace[0], ptsJoin[0]));
							plsMark.append(PLine(ptsJoin[0], ptsOnFace[1]));
						}
					}
				}
			}
			
			if(plsMark.length() != vecsN.length())
			{
				reportMessage("\n"+scriptName()+" "+T("|Unexpected error|"));
				reportMessage(TN("|Instance will be deleted|"));
				eraseInstance();
				return;		
			}
			
			if(bIsCurved)
			{
				int bMessage;
				if(plsMark.length() > 1)
				{
					for(int k=plsMark.length()-1; k > -1; k--)
					{
						if(! vecsN[k].isParallelTo(vecNoMark))
						{
							plsMark.removeAt(k);
							vecsN.removeAt(k);
							bMessage = true;
						}
					}					
				}
				else
				{
					int nSide = sMarkSideNames.find(sMarkSide);
					Vector3d vecGb = gb.vecD(vecsN[0]);
					if(gb.vecD(vecsN[0]).isParallelTo(vecNoMark) && nSide < 2)
					{
						nMarkSide = (_Map.hasInt("nMarkSide"))? _Map.getInt("nMarkSide") : 2;
						sMarkSide.set(sMarkSideNames[nMarkSide]);	
						bMessage = true;							
					}
					else if(gb.vecD(vecsN[0]).isPerpendicularTo(vecNoMark) && nSide > 1)
					{
						nMarkSide = (_Map.hasInt("nMarkSide"))? _Map.getInt("nMarkSide") : 0;						
						sMarkSide.set(sMarkSideNames[nMarkSide]);	
						bMessage = true;						
					}
				}
				
				if(bMessage)
				{
					reportMessage("\n"+scriptName()+" "+T("|The marking can not be created at that side of curved timber. The marking is set to a valid side|"));					
				}
			}
						
			//region Set face of mark
			if(nMarkSide == 1)
			{
				plsMark[0].transformBy(vecsN[0] * 2*vecsN[0].dotProduct(ptCen - plsMark[0].ptMid()));
				vecsN[0] *= -1;
			}	
			else if(nMarkSide != 0)
			{
				sFullLength.set(sNoYes[1]);
				sFullLength.setReadOnly(true);
				int nSign = (nMarkSide == 2) ? -1 :  1;
				Vector3d vecMLine(plsMark[0].ptEnd() - plsMark[0].ptStart());
				vecMLine.normalize();
				vecsN[0] = nSign* vecMLine;
				Point3d ptTest = ptCen + 0.5 * vecsN[0] * gb.dD(vecsN[0]);
				ptTest = ppMark.closestPointTo(ptTest);
			
				for(int k=0; k < ptsPP.length()-1; k++)
				{
					PLine pl(ptsPP[k], ptsPP[k + 1]);
					
					if(pl.isOn(ptTest))
					{
						plsMark[0] = pl;		
						ptTxt = pl.ptStart();
						break;
					}
				}
			}					
			//End Set face of mark//endregion 			
			_Map.setInt("nMarkSide", nMarkSide);

			//Create mark, text and visualisation
			Display dp(nColor);
			
		
			for(int k=0; k < plsMark.length(); k++)
			{	
				PLine plMark = plsMark[k];
				plMark.vis(4);
				//Don´t create marks ate the edges
				Point3d ptTest = plMark.ptMid();
				ptTest.vis(6);
				PlaneProfile ppGb = bdGb.extractContactFaceInPlane(Plane(ptTest, - vecsN[k]), dEps);
				ppGb.vis(7);
				PlaneProfile ppGbShrink = ppGb;
				ppGbShrink.shrink(dEps);
				if(ppGb.pointInProfile(ptTest) == _kPointOnRing)
					continue;	
				if(ppGbShrink.pointInProfile(ptTest) == _kPointOutsideProfile)
					continue;	
				dp.draw(plMark);
				plMark.vis(5);
				MarkerLine ml(plMark.ptStart(),plMark.ptEnd(), vecsN[k]);
				if(nMarkType == 0)
					ml.exportAsMark(true);
				
				if(nRemoveInstance)
					gb.addToolStatic(ml);
				else
					gb.addTool(ml);
					
				if(sTxt.length() > 0 && k ==0)
				{
					Vector3d vecPl(plMark.ptMid() -plMark.ptStart());
					vecPl.normalize();
					Point3d pt = ptTxt + vecPl * U(1);
					Vector3d vecTxtY (pt - ppGb.closestPointTo(pt));
					vecTxtY.normalize(); vecTxtY.vis(pt, 4);					
					Vector3d vecTxtX = - vecsN[k].crossProduct(vecTxtY);
					
					if(nTxtDirection == 1 && nMarkSide < 2)
						vecsN[k]*= -1;
					else if(nTxtDirection == 1 && nMarkSide > 1)
						vecTxtY *= -1;
					
					Point3d ptCs =plMark.ptMid();
					if(nTxtPosition == -1)
						ptCs += vecTxtX * U(10);
					else if(nTxtPosition == 1)
						ptCs -= vecTxtX * U(10);
						
					CoordSys csTxt(ptCs, vecTxtX, vecTxtY, - vecsN[k]);
					String text = _ThisInst.formatObject(sTxt, mapAdditionals);
					FreeText ft(text, csTxt, dTxtHeight, nTxtPosition, _kCenter);
					
					if(nRemoveInstance)
						gb.addToolStatic(ft);
					else
						gb.addTool(ft);
					// display the text	
					dp.textHeight(dTxtHeight);
					dp.draw(text, csTxt.ptOrg(), csTxt.vecX(), csTxt.vecY(), 0, 0);
				}
				bNoMarkCreated = false;
			}
			_Map.setPoint3dArray("Points",  ptsOnFace);
		}
	}
}

if(iLine)
{ 
	// line
	for(int i=1; i < gripPts.length()-1; i++)
	{	
	//region Create a PLine with a cartesian coordinate system
		Vector3d vecL1 (gripPts[i] - gripPts[i - 1]);
		vecL1.normalize();
		Vector3d vecL2 = vecX.isParallelTo(vecL1)? vecY.crossProduct(vecL1) : vecX.crossProduct(vecL1);		
		Vector3d vecL3 = vecL1.crossProduct(vecL2);		
		Line lnL(gripPts[i - 1], vecL1);
		
		Point3d ptsAll[] = { gripPts[i - 1], gripPts[i], gripPts[i + 1]};
		
		if((lnL.closestPointTo(gripPts[i+1]) - gripPts[i+1]).length() > dEps)
		{ 
			int bContinue = true;
			
			for(int j=0; j < gripPts.length(); j++)
			{
				if(j < i-1 ||  j > i+1)
				{
					if((lnL.closestPointTo(gripPts[j]) - gripPts[j]).length() < dEps)
					{
						ptsAll.setLength(0);
						ptsAll.append( gripPts[i - 1]);
						ptsAll.append( gripPts[i]);
						ptsAll.append( gripPts[j]);
						bContinue = false;
						break;
					}
				}
			}
			
			if(bContinue)
				continue;
		}
		
		Point3d ptsL[] = lnL.orderPoints( ptsAll);
		PLine plL(ptsL.first(), ptsL.last());
		Point3d ptPlMid = plL.ptMid();
		
		vecL1.vis(plL.ptMid(), 1); vecL2.vis(plL.ptMid(), 2); vecL3.vis(plL.ptMid(), 3); 			
	//End Create a PLine with a cartesian coordinate system//endregion 
	
		PlaneProfile ppMarks[0];
		ppMarks.append(bdGb.getSlice(Plane(ptPlMid, vecL2)));
		ppMarks.append(bdGb.getSlice(Plane(ptPlMid, vecL3)));
		
		for(int j=0; j < ppMarks.length();j++)
		{
			if(ppMarks[j].area() < pow(dEps,2))
				continue;
			
			Point3d ptTxt;
			PlaneProfile ppMark = ppMarks[j];
//			ppMark.vis(6);
			
			Point3d ptsPP[] = ppMark.getGripVertexPoints();
			Point3d ptsInter[] = lnL.orderPoints(ptsPP);
			double dFirst = vecL1.dotProduct(ptsInter.last() - plL.ptStart());
			double dLast = vecL1.dotProduct(plL.ptEnd() - ptsInter.first());
			
			if(dFirst < dEps || dLast < dEps)
				continue;
				
			Point3d ptsOnFace[0];
			ptsOnFace.append(ppMark.closestPointTo(plL.ptStart()));
			ptsOnFace.append(ppMark.closestPointTo(plL.ptEnd())); 
			
			if(ptsOnFace.length() != 2 || (ptsOnFace[1] - ptsOnFace[0]).length() < dEps)
				continue;
			
			// Remove this instance, if an instance already exists at this position
			for(int k=0; k < tsls.length();k++)
			{
				Point3d ptsTsl[] = tsls[k].map().getPoint3dArray("Points");
				
				if(ptsTsl.length() < 2)
					continue;
				
				PLine pl(ptsTsl.first(), ptsTsl.last());
				
				if(pl.isOn(ptsOnFace[0]) && pl.isOn(ptsOnFace[1]))
				{
					reportMessage("\n"+scriptName()+" "+T("|marking already exists at this position|"));
					reportMessage(TN("|Instance will be deleted|"));
					eraseInstance();
					return;							
				}
			}
						
			PLine plsPt[0];
			ptsPP.append(ptsPP.first());
			
			//region Get the marked side(s) of the object
			{ 	
				if(ppMark.pointInProfile(PLine(ptsOnFace[0], ptsOnFace[1]). ptMid()) == _kPointOnRing)
				{ 
					for(int k=0; k < ptsPP.length()-1; k++)
					{
						PLine pl(ptsPP[k], ptsPP[k + 1]);
						
						if(pl.isOn(ptsOnFace[0]) && pl.isOn(ptsOnFace[1]))
						{
							plsPt.append(pl);		
							ptTxt = pl.ptStart();
							break;
						}
					}				
				}
				else if(ppMark.pointInProfile(PLine(ptsOnFace[0], ptsOnFace[1]). ptMid()) == _kPointInProfile)
				{
					continue;
				}
				else //If points are at two sides, find the sides closest to the marking object
				{
					PLine pl1s[0], pl2s[0];
					
					for(int k=0; k < ptsPP.length()-1; k++)
					{
						PLine pl(ptsPP[k], ptsPP[k + 1]);
											
						if(pl.isOn(ptsOnFace[0]))
							pl1s.append(pl);						
	
						else if(pl.isOn(ptsOnFace[1]))
							pl2s.append(pl);				
					}
					
					if(pl1s.length() > 1)
					{
						double d1 = (pl1s[0].ptMid() - plL.closestPointTo(pl1s[0].ptMid())).length();
						double d2 = (pl1s[1].ptMid() - plL.closestPointTo(pl1s[1].ptMid())).length();
						plsPt.append(d1 < d2 ? pl1s[0] : pl1s[1]);
					}
					else if(pl1s.length() ==1)
						plsPt.append(pl1s[0]);
					if(pl2s.length() > 1)
					{
						double d1 = (pl2s[0].ptMid() - plL.closestPointTo(pl2s[0].ptMid())).length();
						double d2 = (pl2s[1].ptMid() - plL.closestPointTo(pl2s[1].ptMid())).length();
						plsPt.append(d1 < d2 ? pl2s[0] : pl2s[1]);
					}
					else if(pl2s.length() == 1)
						plsPt.append(pl2s[0]);
				}				
			}	
			//End Get the marked side(s) of the object//endregion 

								
			if(plsPt.length() < 1)
				continue;
				
			PLine plsMark[0];
			
			//Get the vecNormal of the face
			Vector3d vecsN[0];
			for(int k=0; k < plsPt.length();k++)
			{
				Vector3d vec(plsPt[k].ptMid() - ppMark.ptMid());
				vec.normalize();
				vec = Vector3d(plsPt[k].ptMid() + vec * U(1) - plsPt[k].closestPointTo(plsPt[k].ptMid() + vec * U(1)));
				vec.normalize();
				
				vecsN.append(vec);
			}			
			
			// Check if one or two marks are needed and if marks have full length
			if(plsPt.length() == 1 && vecsN.length() == 1)
			{
				if(nFullLength == 1)
					plsMark.append(plsPt[0]);
				else
					plsMark.append(PLine(ptsOnFace[0], ptsOnFace[1]));
			}
			else if(plsPt.length() == 2 && vecsN.length() == 2)
			{
				sMarkSide.set(sMarkSideNames[0]);
				sMarkSide.setReadOnly(true);
				
				Point3d ptsJoin[] = plsPt[0].intersectPLine(plsPt[1]);
				if(ptsJoin.length() == 1)
				{
					if(nFullLength == 1)
					{
						plsMark.append(plsPt[0]);
						plsMark.append(plsPt[1]);
					}
					else
					{
						Point3d ptsJoin[] = plsPt[0]. intersectPLine(plsPt[1]);
						
						if(ptsJoin.length() == 1)
						{	
							plsMark.append(PLine(ptsOnFace[0], ptsJoin[0]));
							plsMark.append(PLine(ptsJoin[0], ptsOnFace[1]));
						}
					}
				}
			}
			
			if(plsMark.length() != vecsN.length())
			{
				reportMessage("\n"+scriptName()+" "+T("|Unexpected error|"));
				reportMessage(TN("|Instance will be deleted|"));
				eraseInstance();
				return;		
			}
			
			if(bIsCurved)
			{
				int bMessage;
				
				if(plsMark.length() > 1)
				{
					for(int k=plsMark.length()-1; k > -1; k--)
					{
						if(! vecsN[k].isParallelTo(vecNoMark))
						{
							plsMark.removeAt(k);
							vecsN.removeAt(k);
							bMessage = true;
						}
					}					
				}
				else
				{
					int nSide = sMarkSideNames.find(sMarkSide);
					Vector3d vecGb = gb.vecD(vecsN[0]);
					if(gb.vecD(vecsN[0]).isParallelTo(vecNoMark) && nSide < 2)
					{
						nMarkSide = (_Map.hasInt("nMarkSide"))? _Map.getInt("nMarkSide") : 2;
						sMarkSide.set(sMarkSideNames[nMarkSide]);	
						bMessage = true;							
					}
					else if(gb.vecD(vecsN[0]).isPerpendicularTo(vecNoMark) && nSide > 1)
					{
						nMarkSide = (_Map.hasInt("nMarkSide"))? _Map.getInt("nMarkSide") : 0;						
						sMarkSide.set(sMarkSideNames[nMarkSide]);	
						bMessage = true;						
					}
				}
				
				if(bMessage)
				{
					reportMessage("\n"+scriptName()+" "+T("|The marking can not be created at that side of curved timber. The marking is set to a valid side|"));					
				}
			}
						
			//region Set face of mark
			if(nMarkSide == 1)
			{
				plsMark[0].transformBy(vecsN[0] * 2*vecsN[0].dotProduct(ptCen - plsMark[0].ptMid()));
				vecsN[0] *= -1;
			}	
			else if(nMarkSide != 0)
			{
				sFullLength.set(sNoYes[1]);
				sFullLength.setReadOnly(true);
				int nSign = (nMarkSide == 2) ? -1 :  1;
				Vector3d vecMLine(plsMark[0].ptEnd() - plsMark[0].ptStart());
				vecMLine.normalize();
				vecsN[0] = nSign* vecMLine;
				Point3d ptTest = ptCen + 0.5 * vecsN[0] * gb.dD(vecsN[0]);
				ptTest = ppMark.closestPointTo(ptTest);
			
				for(int k=0; k < ptsPP.length()-1; k++)
				{
					PLine pl(ptsPP[k], ptsPP[k + 1]);
					
					if(pl.isOn(ptTest))
					{
						plsMark[0] = pl;		
						ptTxt = pl.ptStart();
						break;
					}
				}
			}					
			//End Set face of mark//endregion 
			
			_Map.setInt("nMarkSide", nMarkSide);
			

			//Create mark, text and visualisation
			Display dp(nColor);
			
		
			for(int k=0; k < plsMark.length(); k++)
			{	
				PLine plMark = plsMark[k];
				
				//Don´t create marks ate the edges
				Point3d ptTest = plMark.ptMid();
				PlaneProfile ppGb = bdGb.extractContactFaceInPlane(Plane(ptTest, - vecsN[k]), dEps);
				if(ppGb.pointInProfile(ptTest) == _kPointOnRing)
					continue;	
				
				dp.draw(plMark);
				
				MarkerLine ml(plMark.ptStart(),plMark.ptEnd(), vecsN[k]);
				if(nMarkType == 0)
					ml.exportAsMark(true);
				
				if(nRemoveInstance)
					gb.addToolStatic(ml);
				else
					gb.addTool(ml);
					
				if(sTxt.length() > 0 && k ==0)
				{
					Vector3d vecPl(plMark.ptMid() -plMark.ptStart());
					vecPl.normalize();
					Point3d pt = ptTxt + vecPl * U(1);
					Vector3d vecTxtY (pt - ppGb.closestPointTo(pt));
					vecTxtY.normalize(); vecTxtY.vis(pt, 4);					
					Vector3d vecTxtX = - vecsN[k].crossProduct(vecTxtY);
					
					if(nTxtDirection == 1 && nMarkSide < 2)
						vecsN[k]*= -1;
					else if(nTxtDirection == 1 && nMarkSide > 1)
						vecTxtY *= -1;
					
					Point3d ptCs =plMark.ptMid();
					if(nTxtPosition == -1)
						ptCs += vecTxtX * U(10);
					else if(nTxtPosition == 1)
						ptCs -= vecTxtX * U(10);
						
					CoordSys csTxt(ptCs, vecTxtX, vecTxtY, - vecsN[k]);
					FreeText ft(sTxt, csTxt, dTxtHeight, nTxtPosition, _kCenter);
					
					if(nRemoveInstance)
						gb.addToolStatic(ft);
					else
						gb.addTool(ft);
				}
				bNoMarkCreated = false;
			}
						
			_Map.setPoint3dArray("Points",  ptsOnFace);
		}
	}
}
	if(nRemoveInstance || bNoMarkCreated)
		eraseInstance();
	


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
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS">
        <int nm="BREAKPOINT" vl="821" />
        <int nm="BREAKPOINT" vl="875" />
        <int nm="BREAKPOINT" vl="548" />
        <int nm="BREAKPOINT" vl="1072" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-1247: fix grid points when 2  or more grid points are at same location" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="9/28/2021 1:56:59 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-1247: Plines and grids are projected to the body of the genbeam with their normal" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="9/22/2021 6:15:57 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End