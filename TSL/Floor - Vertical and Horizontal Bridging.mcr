#Version 8
#BeginDescription
















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
//spacejoist floortruss
//spacejoist floortruss

U(1, "mm");
String sArType[] = {T("|Noggin/Dwang|"), T("|Extrusion Profile|")};
PropString sType (0, sArType, T("|Type|"));
int nType = sArType.find(sType);

String sArInsMode[] = {T("|Draw Line|"), T("|Select Walls|")};
PropString sInsMode (1, sArInsMode, T("|Insertion Mode|"), 1);

//PropDouble dJoistHeight (0, U(254.5), T("Joist Height"));
PropDouble dWidth (0, U(44), T("Width of Bridging"));
PropDouble dHeight (1, U(222), T("Height of Bridging"));
PropDouble dDistribution (2, U(400), T("Bridging Centers"));
PropString sProfile(2, ExtrProfile().getAllEntryNames(), T("|Extrusion profile name|"));
PropString sName (12, "", T("Name"));
PropString sMaterial (3, "", T("Material"));
PropString sGrade (4, "", T("Grade"));
PropString sLabel (13, "", T("Label"));
PropString sBeamCode (14, "", T("Beam Code"));

String sArJust[] = {T("|Top|"), T("|Center|"), T("|Bottom|")};
PropString sJustification (5, sArJust, T("|Vertical Justification|"));
int nVJustification = sArJust.find(sJustification);


int nHOffset[]={-1, 0, 1};
String sArHJust[] = {T("|Left|"), T("|Center|"), T("|Right|")};
PropString sHJustification (11, sArHJust, T("|Horizontal Justification|"));
int nHJustification = nHOffset[sArHJust.find(sHJustification)];

String sArNoYes[] = {T("|No|"), T("|Yes|")};
PropString sDouble (6, sArNoYes, T("|Double Bridging|"));
int nDouble = sArNoYes.find(sDouble);

//String sArMode[] = {T("|Vertical Bridging|"), T("|Horizontal Bridging|")};
//PropString sMode (7, sArMode, T("|Mode|"));
//int nMode = sArMode.find(sMode);

PropString sDimStyle (7, _DimStyles, T("|Dimstyle|"));

PropInt nColor (0,7,T("|Color|"));

// declare a property with the names of the extrusion profiles

String sArrNoYes[] = {T("No"), T("Yes")};
PropString sMetalClips(8, sArrNoYes, T("Insert Metal Part"), 1);
int bMetal= sArrNoYes.find(sMetalClips,0);

String sArPlate[] = 	{	T("UZ38")		};
PropString sPlateType (9, sArPlate, T("Connector"));

PropString sPlateModel (10, "", T("|Hanger Model|"));

//Start insert - show dialog
if( _bOnInsert )
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialogOnce();
}

int nInsMode = sArInsMode.find(sInsMode);
//nInsMode=0	->	Line
//nInsMode=1	->	Walls Above
//nInsMode=2	->	Walls Bellow


//Set the multi-wall mode based on settings done during the showdialog
//int bAutoMultiWallMode = arNYesNo[arSYesNo.find(sAutoMultiWallMode,0)];

//get data
if ( _bOnInsert )
{
	if(nInsMode==0)
	{
		PrEntity ssE(T("Please Select Floor Elements or Enter to Select Individual Beams"), ElementRoof());
	  	if (ssE.go()==_kOk)
		{
			Entity ents[0]; 
			ents = ssE.set();
			for (int i=0; i<ents.length(); i++)
			{
				ElementRoof elR= (ElementRoof)ents[i];
				if (elR.bIsValid() )
					_Element.append(elR);
			}
		}
		
		if (_Element.length() < 1)
		{
			PrEntity ssE1(T("Select two beams"), Beam());
			if (ssE1.go() && _Beam.length()<3)
			{
				Entity ents[0];
				ents = ssE1.set();
				for (int i=0; i<ents.length(); i++)
					_Beam.append((Beam)ents[i]);
			}
			if (_Beam.length() < 2)
			{
				reportMessage(T("\nThere has been no Elements or Beams Selected. Please restart command and make your Selection. Thank you."));
				eraseInstance(); 
				return;
			}
			else
			{
				_Beam.setLength(2);
			}
		}
		//_PtG.append(getPoint(T("\nSelect second point of Bridging Line"), _Pt0));
		_Pt0 = getPoint(T("Select first point of Bridging Line"));
		Point3d ptLast = _Pt0;
		for (int i=0; i<1; i++)
		{
			PrPoint ssP2("\nSelect next point",ptLast); 
			if (ssP2.go()==_kOk) { // do the actual query
				ptLast = ssP2.value(); // retrieve the selected point
				_PtG.append(ptLast); // append the selected points to the list of grippoints _PtG
			}
		}
		
		if ((_Pt0-_PtG[0]).length() < U(0.01))
		{
			reportMessage(T("Two points are on the same spot"));
			eraseInstance();
			return;
		}
	}
	else if (nInsMode>=1)
	{
		PrEntity ssE(T("Please Select Floor Elements"), ElementRoof());
	  	if (ssE.go()==_kOk)
		{
			Entity ents[0]; 
			ents = ssE.set();
			for (int i=0; i<ents.length(); i++)
			{
				ElementRoof elR= (ElementRoof)ents[i];
				if (elR.bIsValid() )
					_Element.append(elR);
			}
		}
		
		PrEntity ssE1(T("Please Select Wall Elements"),ElementWall());
	 	if (ssE1.go())
		{
	 		Element ents[0];
	 		ents = ssE1.elementSet();
	 		for (int i = 0; i < ents.length(); i++ )
			{
				ElementWall el = (ElementWall) ents[i];
				if (el.bIsValid())
				{
					_Element.append(el);
				}
	 		}
	 	}
	}

	//ExecutionMode set to Insert
	_Map.setInt("ExecutionMode",0);
	
	return;
}// end _bOnInsert

sInsMode.setReadOnly(true);

//Execution modes:
	//0 = Insert
	//1 = Recalc (default)
	//2 = Edit
	//3 = Delete
	//4 = ...
int nExecutionMode = 1;
if( _Map.hasInt("ExecutionMode") )
{
	nExecutionMode = _Map.getInt("ExecutionMode");
}
if (_bOnElementConstructed)
{
	nExecutionMode=0;
}
_Map.setInt("ExecutionMode", 1);

String sTriggerSingle[] = {T("Regenerate Beams")};
for (int i = 0; i < sTriggerSingle.length(); i++)
	addRecalcTrigger(_kContext, sTriggerSingle[i]);


//Custom Menu to Generate the construction
if ( (_bOnRecalc && _kExecuteKey==sTriggerSingle[0]) ||  nExecutionMode==0)
{
	for (int i=0; i< _Map.length(); i++)
	{
		if (_Map.keyAt(i)=="beam")
		{
			Entity ent=_Map.getEntity(i);
			ent.dbErase();
		}
	}
}

CoordSys csW(_PtW, _XW, _YW, _ZW);

ElementRoof elFloor[0];
ElementWallSF elWall[0];

PlaneProfile ppFloor(csW);
PlaneProfile ppWalls(csW);
PlaneProfile ppEachWall[0];
PlaneProfile ppEachFloor[0];

Vector3d vXEl[0];

Point3d ptOrgFloor;

for (int e=0; e<_Element .length();e++)
{
	ElementWallSF elW = (ElementWallSF) _Element[e];
	if (elW.bIsValid())
	{
		elWall.append(elW);
		PlaneProfile ppAux=PlaneProfile (elW.plOutlineWall());
		ppAux.shrink(U(1));
		ppEachWall.append(ppAux);
		vXEl.append(elW.vecX());
	}
	else
	{
		ElementRoof elR = (ElementRoof)_Element[e];
		if (elR.bIsValid())
		{
			ptOrgFloor=elR.ptOrg();
			elFloor.append(elR);
			PlaneProfile ppAux=elR.plEnvelope();
			ppAux.shrink(U(1));
			ppEachFloor.append(ppAux);
			if (ppFloor.area() < U(1)*U(1))
				ppFloor = PlaneProfile (ppAux);
			else
				ppFloor.unionWith(ppAux);
		}
	}			
}

for (int e=0; e<elFloor.length();e++)
{
	Opening op[]=elFloor[e].opening();
	for (int i=0; i<op.length(); i++)
	{
		PLine plOp=op[i].plShape();
		plOp.vis();
		ppFloor.joinRing(plOp, TRUE);
	}
}
ppFloor.vis();

//If the Insertion mode was drawing a Line
if (nInsMode==0)
{
	Vector3d vxLine=_Pt0-_PtG[0];
	vxLine.normalize();
	Vector3d vyLine=vxLine.crossProduct(_ZW);
	
	LineSeg lsPLine (_Pt0-vyLine*U(5), _PtG[0]+vyLine*U(5));
	PLine pl (_ZW);
	pl.createRectangle(lsPLine, vxLine, vyLine);
	PlaneProfile ppLine(pl);
	ppLine.vis();
	ppEachWall.append(ppLine);
	vXEl.append(vxLine);
}

Beam bmAllJoist[0];
for (int i=0; i<elFloor.length(); i++)
{
	Beam bmElement[]=elFloor[i].beam();
	if (bmElement.length()<1)
		return;
	for (int j=0; j<bmElement.length(); j++)
	{
		//if (bmElement[j].name()=="TC")
		{
			bmAllJoist.append(bmElement[j]);
		}
	}
}

Vector3d vz=_ZW;
//Point3d ptWOrg=_PtW;

Plane plnZ(ptOrgFloor, vz);

PlaneProfile ppBeams(csW);

Point3d ptLocDwang[0];
Vector3d vDirDwang[0];

Point3d ptDisplay[0];

for (int i=0; i<bmAllJoist.length(); i++)
{
	PlaneProfile ppAux=bmAllJoist[i].realBody().shadowProfile(plnZ);
	ppAux.shrink(-U(2));
	if (ppBeams.area() < U(1)*U(1))
		ppBeams = ppAux;
	else
		ppBeams.unionWith(ppAux);
}

PlaneProfile ppShapeDwang[0];
for (int i=0; i<ppEachWall.length(); i++)
{
	PlaneProfile ppIntersection=ppEachWall[i];
	ppIntersection.subtractProfile(ppBeams);
	ppIntersection.vis(2);
	if (ppIntersection.area()>=ppEachWall[i].area()*0.5)//Si Dwangs
	{
		if (ppWalls.area() < U(1)*U(1))
			ppWalls= ppEachWall[i];
		else
			ppWalls.unionWith(ppEachWall[i]);
		PLine plAll[]=ppIntersection.allRings();
		for (int j=0; j<plAll.length(); j++)
		{
			Point3d ptAllPl[]=plAll[j].vertexPoints(TRUE);
			Point3d ptCenter;
			ptCenter.setToAverage(ptAllPl);
			ppShapeDwang.append(PlaneProfile(plAll[j]));
			ptLocDwang.append(ptCenter);
			vDirDwang.append(vXEl[i]);
		}
	}
}


//Custom Menu to Generate the construction
if ( (_bOnRecalc && _kExecuteKey==sTriggerSingle[0]) ||  nExecutionMode==0)
{
	PlaneProfile ppNewDwangs(csW);
	
	for (int i=0; i<ptLocDwang.length(); i++)
	{
		for (int j=0; j<ppEachFloor.length(); j++)
		{
			if (ppEachFloor[j].pointInProfile(ptLocDwang[i])==_kPointInProfile && ppNewDwangs.pointInProfile(ptLocDwang[i])==_kPointOutsideProfile)
			{
				//String sArJust[] = {T("|Top|"), T("|Center|"), T("|Bottom|")};
				
				CoordSys cs=elFloor[j].coordSys();
				Vector3d vx=cs.vecX();
				Vector3d vy=cs.vecY();
				Vector3d vz=cs.vecZ();
				Point3d ptOrgFloor=cs.ptOrg();
				//ptOrgFloor=ptOrgFloor-vz*elFloor[j].dReferenceHeight();
				ptOrgFloor=ptOrgFloor-vz*elFloor[j].dBeamWidth();
				//reportNotice(elFloor[j].dBeamWidth());
				double dJoistHeight=elFloor[j].dBeamWidth();
				
				cs.vis();
				
				Plane plnFlr(ptOrgFloor, vz);
				ptLocDwang=plnFlr.projectPoints(ptLocDwang);
				ptLocDwang[i].vis(4);
				
				Point3d ptCreateBm=ptLocDwang[i];
				
				int nOffsetDir=1;
				if (nVJustification==0)//Top
				{
					ptCreateBm=ptCreateBm+vz*(dJoistHeight);
					nOffsetDir=-1;
				}
				if (nVJustification==1)//Center
				{
					ptCreateBm=ptCreateBm+vz*(dJoistHeight*0.5);
					nOffsetDir=0;
				}
				if (nVJustification==2)//Bottom
				{
					nOffsetDir=1;
				}
	
				if (abs(vx.dotProduct(vDirDwang[i]))>0.10)//Just one Dwang 0.98
				{
					Point3d ptToCreate[0];
					if (nDouble)
					{
						ptToCreate.append(ptCreateBm-vy*(dWidth*0.5));
						ptToCreate.append(ptCreateBm+vy*(dWidth*0.5));
					}
					else
					{
						ptToCreate.append(ptCreateBm);
					}
					
					for (int k=0; k<ptToCreate.length(); k++)
					{
						Point3d ptThis=ptToCreate[k];
						Beam bm;
						bm.dbCreate(ptThis, vx, vy, vz, U(20), dWidth, dHeight, 0, nHJustification, nOffsetDir);
						if (nType==1)
						bm.setExtrProfile(sProfile);
						bm.setColor(nColor );
						bm.setName(sName);
						bm.setMaterial(sMaterial);
						bm.setGrade(sGrade);
						bm.setLabel(sLabel);
						bm.setBeamCode(sBeamCode);
						bm.setType(_kBlocking);
						Beam bmIntersect[0];
						bmIntersect=bm.filterBeamsHalfLineIntersectSort(bmAllJoist, ptLocDwang[i]+vz*U(5), vx);
						if (bmIntersect.length()>0)
							bm.stretchDynamicTo(bmIntersect[0]);
						
						bmIntersect.setLength(0);
						bmIntersect=bm.filterBeamsHalfLineIntersectSort(bmAllJoist, ptLocDwang[i]+vz*U(5), -vx);
						if (bmIntersect.length()>0)
							bm.stretchDynamicTo(bmIntersect[0]);
						
						bm.assignToElementGroup(elFloor[j], TRUE, 0, 'Z');
						
						ptDisplay.append(bm.ptCen());
						
						PlaneProfile ppAux=bm.realBody().shadowProfile(plnZ);
						ppAux.shrink(-U(dWidth*0.5));
						if (ppNewDwangs.area() < U(1)*U(1))
							ppNewDwangs= ppAux;
						else
							ppNewDwangs.unionWith(ppAux);
					
						
						_Map.appendEntity("beam", bm);
					}
			
				}
				else if (abs(vx.dotProduct(vDirDwang[i]))<0.02)
				{
					LineSeg ls=ppShapeDwang[i].extentInDir(vy);
					ppShapeDwang[i].shrink(-U(1));
					Point3d ptStartDist=ls.ptStart();
	
					int nCreateBeam=TRUE;
					int nTimes=0;
					do
					{
						if (nTimes==0)
						{
							ptStartDist=ptStartDist+vy*(dWidth*0.5);
							nTimes++;
						}
						else
						{
							ptStartDist=ptStartDist+vy*(dDistribution);
						}
						
						ptStartDist=plnFlr.closestPointTo(ptStartDist);
						
						Point3d ptCreateBm2=ptStartDist;
				
						int nOffsetDir=1;
						if (nVJustification==0)
						{
							ptCreateBm2=ptCreateBm2+vz*(dJoistHeight);
							nOffsetDir=-1;
						}
						if (nVJustification==1)
						{
							ptCreateBm2=ptCreateBm2+vz*(dJoistHeight*0.5);
							nOffsetDir=0;
						}
						
						if (ppShapeDwang[i].pointInProfile(ptStartDist)==_kPointInProfile && ppNewDwangs.pointInProfile(ptStartDist)==_kPointOutsideProfile )
						{
							Point3d ptToCreate[0];
							if (nDouble)
							{
								ptToCreate.append(ptCreateBm2-vy*(dWidth*0.5));
								ptToCreate.append(ptCreateBm2+vy*(dWidth*0.5));
							}
							else
							{
								ptToCreate.append(ptCreateBm2);
							}
							
							
							for (int k=0; k<ptToCreate.length(); k++)
							{
								Point3d ptThis=ptToCreate[k];
								Beam bm;
								bm.dbCreate(ptThis, vx, vy, vz, U(200), dWidth, dHeight, 0, nHJustification, nOffsetDir);
								if (nType==1)
								bm.setExtrProfile(sProfile);
								bm.setColor(nColor );
								bm.setName(sName);
								bm.setMaterial(sMaterial);
								bm.setGrade(sGrade);
								bm.setLabel(sLabel);
								bm.setBeamCode(sBeamCode);
								bm.setType(_kBlocking);
								Beam bmIntersect[0];
								bmIntersect=bm.filterBeamsHalfLineIntersectSort(bmAllJoist, ptStartDist+vz*U(5), vx);
								if (bmIntersect.length()>0)
									bm.stretchDynamicTo(bmIntersect[0]);
								
								bmIntersect.setLength(0);
								bmIntersect=bm.filterBeamsHalfLineIntersectSort(bmAllJoist, ptStartDist+vz*U(5), -vx);
								if (bmIntersect.length()>0)
									bm.stretchDynamicTo(bmIntersect[0]);
								
								bm.assignToElementGroup(elFloor[j], TRUE, 0, 'Z');
								
								ptDisplay.append(bm.ptCen());
								
								PlaneProfile ppAux=bm.realBody().shadowProfile(plnZ);
								ppAux.shrink(-U(dWidth*0.5));
								if (ppNewDwangs.area() < U(1)*U(1))
									ppNewDwangs= ppAux;
								else
									ppNewDwangs.unionWith(ppAux);
								
								_Map.appendEntity("beam", bm);
							}
						}
						else
						{
							nCreateBeam=FALSE;
						}
						//ptStartDist=ptStartDist-vYBm*(dBmWidth*0.5);
					}while (nCreateBeam);
				}
				break;
			}
		}
	}
	_Map.setPoint3dArray("ptDisplay", ptDisplay);
}

//two beams
if (_Element.length() < 1)
{
	Point3d lstPoints[0];
	//get beams
	Beam bm0, bm1;
	bm0 = _Beam0;
	bm1 = _Beam1;
	
	//CoordSys
	CoordSys cs1;
	Vector3d vx, vy, vz, vLine;
	vx = bm0.vecX().normal(); vx.vis(bm0.ptCen(), 1);
	vz = _ZW; vz.vis(bm0.ptCen(), 150);
	vy = vx.crossProduct(vz).normal(); vy.vis(bm0.ptCen(), 3);
	vLine = (_PtG[0] - _Pt0).normal();
	
	Plane pn1 (bm0.ptCen() + (bm0.dD(vz)/2 - dHeight/2) * vz, vz);
	Line ln2 (_Pt0, vz);
	Line ln3 (_PtG[0], vz);
	Point3d pt0 = ln2.intersect(pn1, U(0)); pt0.vis(2);
	Point3d pt1 = ln3.intersect(pn1, U(0)); pt1.vis(2);
	
	Vector3d vLine1 = pt1 - pt0;
	double dLineLength = vLine1.length();
	
	Point3d ptLineMid = pt0 + dLineLength/2 * vLine1.normal(); ptLineMid.vis(1);
	
	//get points of beam
	Point3d ptCen0, ptCen1, pt00, pt01, pt10, pt11;
	ptCen0 = bm0.ptCen(); ptCen0.vis(1);
	ptCen1 = bm1.ptCen(); ptCen1.vis(1);
	
	Plane pnbm0 (bm0.ptCen(), vy);
	Plane pnbm1 (bm1.ptCen(), vy);
	Line ln0 (pt0, vy);
	Line ln1 (pt1, vy);
	pt00 = ln0.intersect(pnbm0, U(0));
	pt01 = ln1.intersect(pnbm0, U(0));
	pt10 = ln0.intersect(pnbm1, U(0));
	pt11 = ln1.intersect(pnbm1, U(0));
		
	double dLength0;
	dLength0 = (pt00 - pt01).length();
		
	Vector3d vx1 = vx;
	if (vx.dotProduct(vLine) > 0)
		vx1 = -vx;
	
	//amounts of spacing
	double dSpacing = U(600);
	int nNum = ((dLength0 - 2 * dHeight)/dSpacing) + 1;
	Vector3d vDir (pt00 - pt10);
	if (vy.dotProduct(vDir) < 0)
		vy = -vy;
	Point3d ptFirst, ptBmFirst, ptLast, ptBmLast, ptBetween[0], ptBm[0], ptBmAll[0];
	ptFirst = pt00 - dWidth/2 * vx1; ptFirst.vis(1);
	ptBmFirst = ptFirst - vDir.length()/2 * vy; //ptBmFirst.vis(150);
	ptBmAll.append(ptBmFirst);
	for (int i = 1; i < nNum; i++)
		ptBetween.append(ptFirst - i * dSpacing * vx1);
	for (int i = 0; i < ptBetween.length(); i++){
		ptBetween[i].vis(1);
		ptBm.append(ptBetween[i] - vDir.length()/2 * vy);
		//ptBm[i].vis(150);
		ptBmAll.append(ptBm[i]);
	}
	ptLast = pt01 + dWidth/2 * vx1; ptLast.vis(1);
	ptBmLast = ptLast - vDir.length()/2 * vy; //ptBmLast.vis(150);
	ptBmAll.append(ptBmLast);
	for (int i = 0; i < ptBmAll.length(); i++)
		ptBmAll[i].vis(150);
	
	//create Beams
	Beam bmBridges[0];
	bmBridges.setLength(0);
	
	if (!_Map.hasInt("bOnCreate"))
	{
		for (int i = 0; i < ptBmAll.length(); i++)
		{
			Beam bmBridges1;
			bmBridges1.dbCreate(ptBmAll[i], vy, vx, vz, U(10), dWidth, dHeight, 0, 0, 0);
			bmBridges1.stretchDynamicTo(bm0); 
			bmBridges1.stretchDynamicTo(bm1);
			bmBridges1.setColor(nColor );
			bmBridges1.setName(sName);
			bmBridges1.setMaterial(sMaterial);
			bmBridges1.setGrade(sGrade);
			bmBridges1.setLabel(sLabel);
			bmBridges1.setBeamCode(sBeamCode);
			bmBridges1.setType(_kBlocking);
			bmBridges1.setExtrProfile(sProfile);
			
			ptDisplay.append(bmBridges1.ptCen());
			_Map.setEntity("Beam"+i, bmBridges1);
			Line lnMale(bmBridges1.ptCen(), bmBridges1.vecX());
			Line lnFemale(bm0.ptCen(), bm0.vecX());
			Line lnFemale1(bm1.ptCen(), bm1.vecX());
			if (bMetal)
			{

				//lstPoints.setLength(0);
				//lstPoints.append(lnMale.closestPointTo(lnFemale));
				//tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString);

				//lstPoints.setLength(0);
				//lstPoints.append(lnMale.closestPointTo(lnFemale1));
				//tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString);
			}
		}
	}
	_Map.setInt("bOnCreate", 1);

	for (int i = 0; i < ptBmAll.length(); i++)
	{
		Entity ent;
		ent = _Map.getEntity("Beam"+i);
		bmBridges.append((Beam)ent);
		bmBridges[bmBridges.length() - 1].setD(vz, dHeight);
		bmBridges[bmBridges.length() - 1].setD(vx, dWidth);
		bmBridges[i].setColor(nColor );
		bmBridges[i].setName(sName);
		bmBridges[i].setMaterial(sMaterial);
		bmBridges[i].setGrade(sGrade);
		bmBridges[i].setLabel(sLabel);
		bmBridges[i].setBeamCode(sBeamCode);
		bmBridges[i].setHsbId(53335);
		CoordSys csNew(ptBmAll[i],vy,vx,vz);
  		bmBridges[i].setCoordSys(csNew);
	}
	_Map.setPoint3dArray("ptDisplay", ptDisplay);
}

Display dp(nColor);

Point3d ptAllDraw[0];
if (_Map.hasPoint3dArray("ptDisplay"))
{
	ptAllDraw=_Map.getPoint3dArray("ptDisplay");
}

for (int i=0; i<ptAllDraw.length(); i++)
{
	LineSeg ls1 (ptAllDraw[i]-_XW*U(10), ptAllDraw[i]+_XW*U(10));
	LineSeg ls2 (ptAllDraw[i]+_YW*U(10), ptAllDraw[i]-_YW*U(10));
	dp.draw(ls1);
	dp.draw(ls2);
}

if (_Element.length()>0)
{
	_ThisInst.assignToElementFloorGroup(_Element[0], true, 0, 'E');
}






#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0```0`!``#__@`N26YT96PH4BD@2E!%1R!,:6)R87)Y
M+"!V97)S:6]N(%LQ+C4Q+C$R+C0T70#_VP!#`%`W/$8\,E!&049:55!?>,B"
M>&YN>/6ON9'(________________________________________________
M____VP!#`55:6GAI>.N"@NO_____________________________________
M____________________________________Q`&B```!!0$!`0$!`0``````
M`````0(#!`4&!P@)"@L0``(!`P,"!`,%!00$```!?0$"`P`$$042(3%!!A-1
M80<B<10R@9&A""-"L<$54M'P)#-B<H()"A87&!D:)28G*"DJ-#4V-S@Y.D-$
M149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@X2%AH>(B8J2DY25EI>8
MF9JBHZ2EIJ>HJ:JRL[2UMK>XN;K"P\3%QL?(R<K2T]35UM?8V=KAXN/DY>;G
MZ.GJ\?+S]/7V]_CY^@$``P$!`0$!`0$!`0````````$"`P0%!@<("0H+$0`"
M`0($!`,$!P4$!``!`G<``0(#$00%(3$&$D%1!V%Q$R(R@0@40I&AL<$)(S-2
M\!5B<M$*%B0TX27Q%Q@9&B8G*"DJ-38W.#DZ0T1%1D=(24I35%565UA96F-D
M969G:&EJ<W1U=G=X>7J"@X2%AH>(B8J2DY25EI>8F9JBHZ2EIJ>HJ:JRL[2U
MMK>XN;K"P\3%QL?(R<K2T]35UM?8V=KBX^3EYN?HZ>KR\_3U]O?X^?K_P``1
M"`'P`>`#`1$``A$!`Q$!_]H`#`,!``(1`Q$`/P"E0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`Z3[P^@_D*;%';[_P`P?[[?6I6Q3W)XTW)'A0>03Q[M4-V;^?Y(
M!=K(9N"H)..,9&&I73M_75`5:U$%`!0`4`%`!0`4`%`!0`4`%`#YO]<_^\:4
M=D`RF`4`%`!0`4`%`!0`4`%`!0`4`/B_UJ?[PI2V8UN,IB"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@!T
MGWA]!_(4V*.WW_F#_?;ZU*V*>Y+&?W>Y\;`<#@9]?0_Y[BH>]E_7X@*Q#1LT
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
8`H`*`"@`H`*`"@`H`*`"@`H`*`"@`/_9
`






















#End