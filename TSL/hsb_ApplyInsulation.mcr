#Version 8
#BeginDescription
Created Solid Insulation between the timbers with an option for a thinner insulation when there is a flat stud.

Modified by: Alberto Jena (alberto.jena@hsbcad.com)
Date: 06.08.2020 - version 0.9

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 9
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT 
*  IRELAND
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
*Version 1.0   01.Dec.2005   th@hsbCAD.de
*   - creates insulation in zone 0 of elements
*   - display of symbol of insulation in planview
*   - color of display dependent from sublabel contents
*     L = Loose Insulation = Yellow
*     else factory fitted = Magenta
*
*Version 1.1   01.Dec.2005   th@hsbCAD.de
*   - dependency added to secure labeling process
*   - color of display is now dependent from name
*     Loose Rigid =  Yellow
*     Factory Rigid = Magenta
*   - invalid labeling will be removed
*
*Version 1.2   19.Dec.2005   th@hsbCAD.de
*   - Insulation will be created in zone -5
*
*Version 1.3   09. Jan. 2006   th@hsbCAD.de
*   - tsl instance will be assigned to element group
*
*Version 1.4   04. Apr. 2006   th@hsbCAD.de
*   - error behaviour enhanced if entities are deleted
*
*Version 1.5   06. Apr. 2006   mk@hsb-cad.com
*   - Sublabel set to insulation
*
*Version 1.6   14. May. 2006   th@hsbCAD.de
*  - deletes all existings sheets in zone -5 on insert
*   - duplicate behaviour suppressed
*
*v1.7: 26-Jan-2007: David Rueda (dr@hsb-cad.com): 
*       - Tolerance distance increased 5 mm for extractContactFaceInPlane() in every beam ( finds beams 
*         which are not touching insulation plane ).
*       - User has now the ability to reduce (only) overall width and heigth of all sheets of insulation. (0 to 10 mm)
*         This last issue works only on insertion. If user wants to change width and height reduction must re-insert the tsl.
*       - "Diagonal line, show text" (yes/no) property added
*
*v1.8: 31-Jan-2007: David Rueda (dr@hsb-cad.com): 
*       - Sheets material changed from "TW55" to "PIR Insulation". 
*
*v: 1.9 Show diagonal and dimension text Date: 03/Feb/2006  Author: Alberto Jena (aj@hsb-cad.com)
*
*v: 2.0 Erase diagonal on model space Date: 06/Feb/2006  Author: Alberto Jena (aj@hsb-cad.com)
*
*v: 2.1 Fix issue with angle sheets Date: 20/Feb/2006  Author: Alberto Jena (aj@hsb-cad.com)
*
* Modify by: Alberto Jena (aj@hsb-cad.com)
* date: 01.04.2009
* version 2.2: 	Release Version for UK Content
*				Remove the Insulation Label
*				Add a hatch Pattern when is view from Top
*				Allow to run from the palette
*
* date: 00.06.2009
* version 2.3: 	Add Display in diferent Views
*				Bugfix with the join of the profiles of the beams
*
* date: 28.07.2009
* version 2.4: 	Add Display Rep Option
*
* date: 07.09.2009
* version 2.5:	BugFix with shape of the frame (planeProfile)
*
* date: 22.02.2010
* version 2.6:	Add and ability to put a diferent insulation on the connections
*
* date: 24.04.2010
* version 2.7:	Check if the width or the height of the insulation is less than the minimun width
*
* date: 18.02.2011
* version 2.8:	Add Filter by Wall
*				Fix issue with insulation over header
*				Improve performance
*				Change the way the solid is analize
*				Remove Tools to sheeting and replacing with the analisis if there is space to add the insulation
*
* date: 23.02.2011
* version 2.9:	Add Properties for stock size of insulation
*				Export Stock sizes to dBase as ElemItem
*
* date: 28.06.2011
* version 2.10:Fix issue then the gap around openings it's big
*
* date: 09.08.2011
* version 2.11:	Add a property so the insulation can be attach to any zone (10 by default)
*				Exclude beams that are outside of the zone 0
*
* date: 13.09.2011
* version 2.12:BugFix with the top and bottom plate.
*
* date: 25.01.2012
* version 2.13:BugFix issue when the top plate is exactly with the wall outline.
*
* date: 13.03.2012
* version 2.14:Change the way the valid are is calculated
*
* date: 19.03.2012
* version 2.15:Bugfix with the zone that the Insulation is assign
*
* date: 09.07.2012
* version 2.16:Added display for the hatch property
*
* date: 11.07.2012
* version 2.17:Fix issue checking that some beams could be out of the element area
*
* date: 11.07.2012
* version 2.18:Add mapx so only sheets that have this value on it will be delete.
*
* date: 29.10.2013
* version 2.19:Fix Issue with catalog when the TSL was added to the tool palette.
*
* date: 20.11.2017
* version 2.20: Allow the TSL to link the insulation to zone 0.
*/

//basics and props
U(1,"mm");
double dEps =U(.1);
String sArNY[] = {T("No"), T("Yes")};

int nValidZones[]={0,1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={0,1,2,3,4,5,-1,-2,-3,-4,-5};

PropInt pnZoneToInsulate(0, nValidZones, T("Insulate zone")); pnZoneToInsulate.setCategory(T("Zone to insulate"));
PropInt pnZoneToAssign(1, nValidZones, T("Attach Insulation to Zone"),10); pnZoneToAssign.setCategory(T("Zone to insulate"));

PropString sName1 (0, "", T("Insulation Name")); sName1.setCategory(T("Main Insulation"));
PropString sMaterial1 (1, "Insulation", T("Insulation Material")); sMaterial1.setCategory(T("Main Insulation"));
PropDouble dThick1(0, U(89), T("Insulation Thickness")); dThick1.setCategory(T("Main Insulation"));
PropDouble dStockWidth1(1, U(1200), T("Insulation Width")); dStockWidth1.setCategory(T("Main Insulation"));
PropDouble dStockHeight1(2, U(8000), T("Insulation Height")); dStockHeight1.setCategory(T("Main Insulation"));

PropString sName2 (2, "", T("Insulation Name")); sName2.setCategory(T("Secondary Insulation (Thinner Insulation)"));
PropString sMaterial2 (3, "Insulation", T("Insulation Material")); sMaterial2.setCategory(T("Secondary Insulation (Thinner Insulation)"));
PropDouble dThick2(3, U(60), T("Insulation Thickness for Connections")); dThick2.setCategory(T("Secondary Insulation (Thinner Insulation)"));
PropDouble dStockWidth2(4, U(1200), T("Insulation Width")); dStockWidth2.setCategory(T("Secondary Insulation (Thinner Insulation)"));
PropDouble dStockHeight2(5, U(8000), T("Insulation Height")); dStockHeight2.setCategory(T("Secondary Insulation (Thinner Insulation)"));

PropDouble dWDecrease(6, 0, T("Tolerance width"));
dWDecrease.setDescription("Decrease overall width of all insulation sheets");

PropDouble dHDecrease(7, 0, T("Tolerance height"));
dHDecrease.setDescription("Decrease overall height of all insulation sheets");

PropDouble dMinWidth(8, U(20), T("Minimal width/height"));
dMinWidth.setDescription("Any Insulation Sheet smaler that this value wont be created");

PropDouble dMinThickness(9, U(20), T("Minimal Thickness"));
dMinThickness.setDescription("Any Insulation Sheet smaler that this value wont be created");

PropDouble dMaxInsulationHeight(11, 0, T("Max Insulation Height"));
dMaxInsulationHeight.setDescription("If the value is set to 0 then it will go full height");

PropString sExternalWalls (4, "EA;EB;", T("Fillter by Wall Code"));
sExternalWalls.setDescription("Please set the wall codes that you want to Insulate, use ; to insert more than one code");

PropString sDisplay(5, sArNY, T("Display Hatch Pattern"), 1); sDisplay.setCategory(T("Display"));
PropString pHatchPattern(6, _HatchPatterns, T("Hatch Pattern")); pHatchPattern.setCategory(T("Display"));
PropDouble dHatchScale(10, U(7.5), T("Hatch Scale")); dHatchScale.setCategory(T("Display"));
PropInt nColor(2, 51, T("Hatch Color")); nColor.setCategory(T("Display"));

//Entity ent = _ThisInst;
//ent.dispRepNames();
PropString sDispRep(7,"",T("|Show Only In Disp Rep Name|")); sDispRep.setCategory(T("Display"));



//Insert
if( _bOnInsert ){
	if( insertCycleCount()>1 ){eraseInstance(); return;}
	
	if (_kExecuteKey=="")
		showDialogOnce();
}

String sInsulationName1=sName1;

	
String sInsulationName2=sName2;


int bDisplay = sArNY.find(sDisplay,0);

int nZoneToAssign=nRealZones[nValidZones.find(pnZoneToAssign, 0)];
int nZoneToInsulate=nRealZones[nValidZones.find(pnZoneToInsulate, 0)];

String arSCodeExternalWalls[0];

String s = sExternalWalls+ ";";
int nIndex = 0;
int sIndex = 0;
while(sIndex < s.length()-1){
  String sToken = s.token(nIndex);
  nIndex++;
  if(sToken.length()==0){
    sIndex++;
    continue;
  }
  sIndex = s.find(sToken,0);

  arSCodeExternalWalls.append(sToken);
}

if (_bOnDbCreated || _bOnInsert ) setPropValuesFromCatalog(_kExecuteKey);

//on insert
if(_bOnInsert)
{
	PrEntity ssE("\nSelect a set of elements",Element());
	if(ssE.go()){
		_Element.append(ssE.elementSet());
	}
	
	// declare tsl props
	TslInst tsl;
	String strScriptName=scriptName();
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Element lstElements[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	
	lstPropDouble.append(dThick1);
	lstPropDouble.append(dStockWidth1);
	lstPropDouble.append(dStockHeight1);		
	lstPropDouble.append(dThick2);
	lstPropDouble.append(dStockWidth2);
	lstPropDouble.append(dStockHeight2);
	lstPropDouble.append(dWDecrease);
	lstPropDouble.append(dHDecrease);
	lstPropDouble.append(dMinWidth);
	lstPropDouble.append(dMinThickness);
	lstPropDouble.append(dHatchScale);

	lstPropInt.append(pnZoneToInsulate);
	lstPropInt.append(pnZoneToAssign);
	lstPropInt.append(nColor);
	
	lstPropString.append(sName2);
	lstPropString.append(sMaterial1);
	lstPropString.append(sName2);
	lstPropString.append(sMaterial2);
	lstPropString.append(sExternalWalls);
	lstPropString.append(sDisplay);	
	lstPropString.append(pHatchPattern);
	lstPropString.append(sDispRep);
	
	Map mpToClone;
	mpToClone.setInt("nExecutionMode", 1);
	
	for( int e=0; e<_Element.length(); e++ )
	{
		String sCode = _Element[e].code();
		if (arSCodeExternalWalls.length()>0)
			if( arSCodeExternalWalls.find(sCode, -1) == -1) continue;
		
		Element el = _Element[e];
	
		lstElements.setLength(0);
		lstElements.append(el);
	
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY, lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModel, mpToClone);
	}
	
	eraseInstance();
	return;
}

// restrict color index
if (nColor > 255 || nColor < -1) nColor.set(171);

if (_bOnElementConstructed)
{
	_Map.setInt("nExecutionMode", 1);
}

String strChangeEntity = T("Reapply Insulation Sheets");
addRecalcTrigger(_kContext, strChangeEntity );
if (_bOnRecalc && _kExecuteKey==strChangeEntity)
{
	_Map.setInt("nExecutionMode", 1);
}

//Execution Mode
int nExecutionMode=0;
if (_Map.hasInt("nExecutionMode"))
{
	nExecutionMode=_Map.getInt("nExecutionMode");
}

// declare standards
if (_Element.length() < 1)
{
	eraseInstance();
	return;
}

Element el = (Element) _Element[0];
if (!el.bIsValid()) return;

Point3d ptOrg;

CoordSys cs= el.coordSys();
Vector3d vx=cs.vecX();
Vector3d vy=cs.vecY();
Vector3d vz=cs.vecZ();

ptOrg = cs.ptOrg();

setMarbleDiameter(U(1));

	Sheet sh5[0];
	sh5 = el.sheet(nZoneToAssign);
	for (int i = 0; i < sh5.length(); i++)
	{
		Sheet sh=sh5[i];
		Map mpEnt=sh.subMapX("Insulation");
		if (mpEnt.hasInt("Erase"))
		{
			int nCanErase=mpEnt.getInt("Erase");
			if (nCanErase)
				sh.dbErase();
		}
	}

//From HERE IS TH TSL

double dZ = el.dBeamWidth();
	Plane pnZ(ptOrg, vz);
	PLine plEnvelope = el.plEnvelope();
	LineSeg segMinMax = el.segmentMinMax();
	double dX = abs(vx.dotProduct(segMinMax.ptStart() - segMinMax.ptEnd()));
	double dY = abs(vy.dotProduct(segMinMax.ptStart() - segMinMax.ptEnd()));
	Point3d ptRef = ptOrg;
	Vector3d vecZT = - vz;
	
	if (abs(nZoneToInsulate)>0)
	{ 
		ElemZone elzo = el.zone(nZoneToInsulate);
		ptRef = elzo.ptOrg();
		dZ = elzo.dH();
		vecZT = elzo.vecZ();
		pnZ = Plane(ptRef, vecZT);
		plEnvelope = el.plEnvelope(ptRef);
		cs = CoordSys(ptRef,vy.crossProduct(elzo.vecZ()), vy, vecZT);
		cs.vis(2);
	}
	
	_Pt0.transformBy(vz * vz.dotProduct(ptRef - _Pt0));

// get genbeams of element
	GenBeam gbs[] = el.genBeam();
	GenBeam genbeams[] = el.genBeam(nZoneToInsulate);
	int bZoneIsEmpty = gbs.length() > 0 && genbeams.length() < 1;


// get additional genbeams of adjacent elements
	ElementWall elw = (ElementWall)el;
	Body bdZone;
	if (elw.bIsValid())
	{ 
		Group gr(el.elementGroup().namePart(0));
		
	// get interscetion test body of zone
		LineSeg seg(ptRef-vx*U(1000), ptRef + vx * (dX+U(1000)) + vecZT * dZ);
		
		PLine plZone; plZone.createRectangle(seg, vx, vz);

		Body bdTest(plZone, vy*dY, 1);
		
	// filter by zone intersection	HSB-8224
		Point3d ptExtremes[0];
		for (int i=genbeams.length()-1; i>=0 ; i--) 
		{ 
			Body bd = genbeams[i].envelopeBody();
			if (!bd.hasIntersection(bdTest))
			{
				//genbeams[i].envelopeBody().vis(6);
				genbeams.removeAt(i); 
			}
			else
				ptExtremes.append(bd.extremeVertices(vx));
			
		}//next i
		ptExtremes = Line(_Pt0, vx).orderPoints(ptExtremes, dEps);
		
	// collect elements of this group and find adjacent genbeams		
		if (ptExtremes.length()>1)
		{ 
			double dX = vx.dotProduct(ptExtremes.last() - ptExtremes.first());
			Point3d _ptRef = ptExtremes.first();
			_ptRef += vz * vz.dotProduct(ptRef - _ptRef)+vy*vy.dotProduct(ptRef-_ptRef);
			seg=LineSeg(_ptRef-vx*U(10), _ptRef + vx * (dX+U(10)) + vecZT * dZ);
			plZone.createRectangle(seg, vx, vz);	
			bdTest=Body (plZone, vy*dY, 1);
			bdTest.vis(151);
			
			Entity ents[]=gr.collectEntities(true, ElementWall(), _kModelSpace); 
			for (int i=0;i<ents.length();i++) 
			{ 
				Element el2 = (Element)ents[i]; 
				if (ents[i] == el || !el2.bIsValid())continue;
				genbeams.append(bdTest.filterGenBeamsIntersect(el2.genBeam(nZoneToInsulate)));
			}
						
		}

	// get zone body if this zone does not contain any beams
		if (bZoneIsEmpty)
		{ 
			bdZone = Body(plEnvelope, vecZT * dZ);
			bdZone.vis(2);
		}

		
	}

// wait state if no genbeams are found
	if (genbeams.length()<1)
	{ 
		//reportNotice("No beams found");
		return;
	}
	
// base contour
	PlaneProfile ppFrame(cs);

// collect profile by genbeams
	double dMerge = U(10);
	// build frame profile out of all genbeams of current zone
	for (int i=0; i< genbeams.length(); i++)
	{
		GenBeam& gb = genbeams[i];
		if (gb.bIsValid() && gb.myZoneIndex()==nZoneToInsulate && !gb.bIsDummy())
		{
			Body bd = gb.envelopeBody(false,true);bd.vis(252);
			PlaneProfile pp = bd.shadowProfile(pnZ); 
			pp.shrink(-dMerge);
			
		// add outer rings
			PLine plRings[] = pp.allRings(true,false);
			for (int r=0;r<plRings.length();r++)
			{
				//plRings[r].vis(r);
				ppFrame.joinRing(plRings[r],_kAdd);			
			}
		}
	}

// merge little gaps
	ppFrame.shrink(dMerge);
	//ppFrame.vis(2);
	
// opening rings are the gros insulation area
	PlaneProfile ppInsulation(cs);
// if it is a ElementRoof start planeprofile by intersection of FloorContour and the elementenvelope
	ElementRoof eRoof = (ElementRoof) el;
	if(eRoof.bIsValid())
	{ 
		dMaxInsulationHeight.setReadOnly(true);
		if (dMaxInsulationHeight != 0) dMaxInsulationHeight.set(0);
		
		for (int i=0;i<_Entity.length();i++) 
		{ 
			EntPLine epl = (EntPLine)_Entity[i]; 
			if (epl.bIsValid())
			{ 
				Map m = epl.subMapX(scriptName());
//				Map m = epl.subMapX("hsbElementInsulation");
				int nMode = m.getInt("Mode");
				if (epl.bIsValid() && m.getString("Type")=="FloorContour")
				{ 
					PLine pl = epl.getPLine();
					Plane pnElement(el.ptOrg(), vz);
					pl.projectPointsToPlane(pnElement, _ZW);
					pl.close();
					if (pl.area()>pow(dEps,2))
					{ 
						setDependencyOnEntity(epl);
						// floorContour pline is assigned to all groups
						epl.assignToElementGroup(el, false, 0, 'T');
						ppInsulation.joinRing(pl, nMode);	
					}
				}
			}
		}//next i
//		ppInsulation.vis(1);
		if(ppInsulation.area()>pow(dEps,2))
		{ 
			// take the intersection of plEnvelope with FloorContour
			PlaneProfile ppEnvelope(cs);
			ppEnvelope.joinRing(el.plEnvelope(), _kAdd);
			ppInsulation.intersectWith(ppEnvelope);
		}
		// remove ppframe
		if(ppInsulation.area()>pow(dEps,2))
			ppInsulation.subtractProfile(ppFrame);
//		ppInsulation.vis(1);
//		int zzz;
	}
	PLine plRings[] = ppFrame.allRings(false,true);
	for (int r=0;r<plRings.length();r++)
		ppInsulation.joinRing(plRings[r],_kAdd);
	//ppInsulation.vis(1);

// post process the frame to identify insulation areas which are not fully embraced by the frame
	{ 
		double dStep = U(5);// closes gaps upto 150mm
		plRings = ppFrame.allRings(true,false);
		for (int i=0;i<plRings.length();i++) 
		{ 
			PlaneProfile pp(cs);
			pp.joinRing(plRings[i],_kAdd);
			for (int j=0;j<15;j++) 
			{ 
				double d = (j + 1) * U(10);
				pp.shrink(-d);
				pp.shrink(d);
				
				PLine pls[] = pp.allRings(false, true);
				for (int r=0;r<pls.length();r++) 
				{ 
					pp.joinRing(pls[r],_kAdd);
					ppInsulation.joinRing(pls[r],_kAdd);	 
					//if(bDebug)reportMessage("\nadditional ring found at step " + j + " width " + d);
				}//next r 
			}//next j 
		}//next i
	}
//	ppInsulation.vis(1);

// post process frame if still no insulation area was found, but more than 1 item found
	if(ppInsulation.area()<pow(dEps,2) && genbeams.length()>1)
	{
		PLine plHull;
		plHull.createConvexHull(pnZ, ppFrame.getGripVertexPoints());
		plHull.vis(1);
		ppInsulation.joinRing(plHull, _kAdd);
		ppInsulation.subtractProfile(ppFrame);
	}

// subtract all openings
	Opening openings[] = el.opening();
	for (int i=0;i<openings.length();i++) 
		ppInsulation.joinRing(openings[i].plShape(), _kSubtract); 

//	ppInsulation.vis(1);
// get polylines from entity
	PLine plSubtracts[0];
	for (int i=0;i<_Entity.length();i++) 
	{ 
		EntPLine epl = (EntPLine)_Entity[i]; 
		Map m = epl.subMapX(scriptName());
		// dont consider FloorContour plines
		if(m.getString("Type")=="FloorContour")
			continue;
		int nMode = m.getInt("Mode");
		if (epl.bIsValid())
		{
			PLine pl = epl.getPLine();
			pl.close();
			if (pl.area()>pow(dEps,2))
			{ 
				setDependencyOnEntity(epl);
				epl.assignToElementGroup(el, true, 0, 'T');
				ppInsulation.joinRing(pl, nMode);	
			}
		}
	}
//	ppInsulation.vis(2);
	if (ppInsulation.area()<pow(dEps,2))
	{ 
		reportMessage("\n" + scriptName() + T(": |Element| ") +el.number() + T(" |could not find any insulation area in zone| ")+ nZoneToInsulate);	
		eraseInstance();
		return;
	}	
	
// subtract area above given height
	if (dMaxInsulationHeight>0 && elw.bIsValid())
	{ 
		PLine pl;
		pl.createRectangle(LineSeg(ptOrg - vx * U(10e4), ptOrg + (vx + vy) * U(10e4)), vx, vy);
		pl.transformBy(vy * dMaxInsulationHeight);
		ppInsulation.joinRing(pl, _kSubtract);
	}
	

//subtrach area of any TSL
TslInst tlsAll[]=el.tslInstAttached();
for (int i=0; i<tlsAll.length(); i++)
{
	String sName = tlsAll[i].scriptName();
	if (sName == scriptName() && tlsAll[i].handle()!= _ThisInst.handle())
	{
		//TODO: Check if there is for the same zone
		//tlsAll[i].dbErase();
	}
	else//if (sName=="hsb_Vent")
	{
		Map mp=tlsAll[i].map();
		if (mp.hasPLine("noinsulation"))
		{ 
			PLine plToSubstract = mp.getPLine("noinsulation");
			ppInsulation.joinRing(plToSubstract, _kSubtract);
		}
	}
}

ppInsulation.vis(1);	
// END TH TSL

/*
//Plane pn(ptOrg-vz*U(1), vz);
Plane pn(ptOrg, vz);
Plane plnY(ptOrg, vy);

PlaneProfile ppBaseEl(el.plOutlineWall());
ppBaseEl.shrink(-U(0.5));
ppBaseEl.vis();

Beam bm[0];

Beam bmAllTemp[]=el.beam();
//Beam bmAll[0];



for (int i=0; i<bmAllTemp.length(); i++)
{
	if (bmAllTemp[i].myZoneIndex()==nZoneToInsulate)
	{
		Beam bmAux=bmAllTemp[i];
		//bmAll.append(bmAux);
		
		PlaneProfile ppBm=bmAux.realBody().shadowProfile(plnY);
		double dBmArea=ppBm.area();
		
		ppBm.vis(1);
		
		String sCode=bmAux.beamCode().token(0);
		sCode.makeUpper();
		
		if (sCode!="CONNECTOR")
			bm.append(bmAux);
		//else
		//{
		//	reportNotice("\n"+(dBmArea-ppBm.area()));
		//	Body bd=bmAux.realBody();
		//	bd.vis(2);
		//}
	}
}

for (int i = 0 ; i < bm.length(); i++)
{
	Body bdBeam=bm[i].envelopeBody(false, true);
	bdBeam.vis(1);
}


//if (bm.length()<1)
//	return;

double dElHeight=abs(el.dPosZOutlineBack());

//Execution Mode
int nExecutionMode=0;
if (_Map.hasInt("nExecutionMode"))
{
	nExecutionMode=_Map.getInt("nExecutionMode");
}

//Find Another TSLs that could have areas that doesnt need to have Insulation and erase if exist anothet insulation TSL and it's not this instance
PLine plToAvoid[0];

TslInst tlsAll[]=el.tslInstAttached();
for (int i=0; i<tlsAll.length(); i++)
{
	String sName = tlsAll[i].scriptName();
	if (sName == scriptName() && tlsAll[i].handle()!= _ThisInst.handle())
	{
		tlsAll[i].dbErase();
	}
	else//if (sName=="hsb_Vent")
	{
		Map mp=tlsAll[i].map();
		if (mp.hasPLine("noinsulation"))
			plToAvoid.append(mp.getPLine("noinsulation"));
	}
}

// collect opening pp's
PlaneProfile ppOp(cs);
//PlaneProfile ppTemp(cs);
Opening opAll[0];
opAll = el.opening();
for (int i = 0; i < opAll.length(); i++)
{
	OpeningSF op =(OpeningSF) opAll[i];
	if (!op.bIsValid())
		continue;

	PlaneProfile ppTemp(cs);
	ppTemp.joinRing(op.plShape(), FALSE);
	
	PlaneProfile ppAux=ppTemp;
	ppAux.transformBy(-vx*op.dGapSide());
	ppTemp.unionWith(ppAux);
	ppAux.transformBy(vx*op.dGapSide()*2);
	ppTemp.unionWith(ppAux);
	
	PlaneProfile ppAux2=ppTemp;
	ppAux2.transformBy(vy*op.dGapTop());
	ppTemp.unionWith(ppAux2);
	
	PlaneProfile ppAux3=ppTemp;
	ppAux3.transformBy(-vy*op.dGapBottom());
	ppTemp.unionWith(ppAux3);
		
	ppTemp.shrink(- U(5));
	ppOp.unionWith(ppTemp);
}

for (int i = 0; i < plToAvoid.length(); i++)
{
	PlaneProfile ppTemp(cs);
	ppTemp.joinRing(plToAvoid[i], FALSE);
	ppTemp.shrink(- U(5));
	ppOp.unionWith(ppTemp);
}
//ppOp.vis(1);

// get PP of element


Beam bmRotate[0];

//PlaneProfile pp(cs);
PlaneProfile ppRotateBeam(cs);
PlaneProfile ppRotateTop(plnY);

Body bdAllBeam;

Vector3d vxRot=vx;
vxRot=vxRot.rotateBy(30, vz);
vxRot.vis(_Pt0);


PlaneProfile ppAllBeams(cs);

for (int i = 0 ; i < bm.length(); i++)
{
	Body bdBeam=bm[i].envelopeBody(false, true);
	//bdBeam.vis(1);
	PlaneProfile ppThisBeam(cs);
	ppThisBeam=bdBeam.shadowProfile(pn);
	ppThisBeam.shrink(-U(5));
	
	PLine plAllRings[]=ppThisBeam.allRings();
	
	if (plAllRings.length()>0)
	{
		ppAllBeams.joinRing(plAllRings[0], false);
		//plAllRings[0].vis(i);
	}
	
	//bdAllBeam.addPart(bdBeam);
	
	if (bm[i].dD(vz)<bm[i].dD(vxRot))
	{
		bmRotate.append(bm[i]);
		PlaneProfile ppRot(cs);
		ppRot = bdBeam.shadowProfile(pn);
		ppRot.transformBy(U(0.01)*vy.rotateBy(i*123.456,vz));
		ppRot.shrink(-U(2));
		ppRotateBeam.unionWith(ppRot);
		
		PlaneProfile ppRotTop(plnY);
		ppRotTop = bdBeam.shadowProfile(plnY);
		ppRotTop.transformBy(U(0.01)*vy.rotateBy(i*123.456,vz));
		ppRotTop.shrink(-U(2));
		ppRotateTop.unionWith(ppRotTop);
	}
}

//ppAllBeams.vis(2);

//ppAllBeams.shrink(U(5));

//ppAllBeams.vis(2);

//bdAllBeam.vis(-1);

//pp=bdAllBeam.shadowProfile(pn);
//pp.vis(1);
//pp.shrink(-U(10));

//PLine plAllThisRings[]=ppAllBeams.allRings();
//int nIsOpening[]=ppAllBeams.ringIsOpening();

ppRotateTop.shrink(U(2));
ppRotateBeam.shrink(U(2));
if (ppOp.area()>U(5))
{
	ppAllBeams.unionWith(ppOp);
}
//pp.unionWith(ppOp);
//ppAllBeams.vis(1);

//ppRotateBeam.vis(2);
//ppRotateTop.vis(3);

int nSpecialSheet[0];
// find outer contour
//PLine plContour;
PLine plAllContour[] = ppAllBeams.allRings();
int nIsOp[]=ppAllBeams.ringIsOpening();
for (int i=0; i<plAllContour.length(); i++)
{
	nSpecialSheet.append(FALSE);
}

//PLine of Special Insulation Type
PLine plContourSheet2[] = ppRotateBeam.allRings();
int nIsOpSheet2[]=ppRotateBeam.ringIsOpening();
for (int i=0; i<plContourSheet2.length(); i++)
{
	plAllContour.append(plContourSheet2[i]);
	nIsOp.append(TRUE);
	nSpecialSheet.append(TRUE);
}

//Increase or decrease sizes due to properties
PLine plInsulation[0];
int nSpecial[0];
for(int i=0;i<plAllContour.length();i++)
{
	//plAllContour[i].vis(1);
	if (nIsOp[i]==FALSE)
		continue;
		
	Point3d ptAllExtremeFromEveryRing[0];
	ptAllExtremeFromEveryRing=plAllContour[i].vertexPoints(TRUE);
	Point3d ptCenter;
	ptCenter.setToAverage(ptAllExtremeFromEveryRing);
	for(int j=0;j<ptAllExtremeFromEveryRing.length();j++)
	{
		if ((ptAllExtremeFromEveryRing[j]-ptCenter).dotProduct(vy)<0)
		{
			ptAllExtremeFromEveryRing[j]=ptAllExtremeFromEveryRing[j]+vy*dHDecrease;
		}
		else
		{
			ptAllExtremeFromEveryRing[j]=ptAllExtremeFromEveryRing[j]-vy*dHDecrease;
		}
		if ((ptAllExtremeFromEveryRing[j]-ptCenter).dotProduct(vx)<0)
		{
			ptAllExtremeFromEveryRing[j]=ptAllExtremeFromEveryRing[j]+vx*dWDecrease;
		}
		else
		{
			ptAllExtremeFromEveryRing[j]=ptAllExtremeFromEveryRing[j]-vx*dWDecrease;
		}
	}
	
	PLine plNewRing(vz);
	for(int j=0;j<ptAllExtremeFromEveryRing.length();j++)
	{
		plNewRing.addVertex(ptAllExtremeFromEveryRing[j]);
	}
	plNewRing.close();
	
	//plNewRing.transformBy(vx*U(4000));
	//plNewRing.vis(3);
	//Replacing older ring
	plInsulation.append(plNewRing);
	nSpecial.append(nSpecialSheet[i]);
}
*/

//if (nExecutionMode)
{
	// workaround for duplicates

	PLine plInsulation[] = ppInsulation.allRings();

	for (int i = 0 ; i < plInsulation.length(); i++)
	{
		plInsulation[i].vis(1);
		PlaneProfile ppSingle (cs);
		ppSingle.joinRing(plInsulation[i], FALSE);
		LineSeg ls = ppSingle.extentInDir(vx);
		
		// specify thicknesses
		double dInsulationThickness = dThick1 > 0 ? dThick1 : dZ;
		//double dThickness=dThick1;
		String sNameIns=sInsulationName1;
		double dMoveDist=0;
		if (nZoneToInsulate==0)
			dMoveDist = dZ;
		
		
		int nCreate=true;
		/*
		if (nSpecial[i]==TRUE)
		{
			dThickness=dThick2;
			sNameIns=sInsulationName2;
			
			PLine pLineTop(vy);
			//LineSeg lsTop(ls.ptStart()+vx*U(5), (ls.ptEnd()-vx*U(5)-vz*dElHeight));

			Point3d ptLeft=ls.ptStart();
			Point3d ptRight=ls.ptEnd();

			ptLeft=plnY.closestPointTo(ptLeft);
			ptRight=plnY.closestPointTo(ptRight);

			LineSeg lsTop(ptLeft+vx*U(5), (ptRight-vx*U(5)-vz*dElHeight));
			//ptLeft.vis();
			//ptRight.vis();

			pLineTop.createRectangle(lsTop, vx, -vz);
			CoordSys cs (ptOrg, vx, -vz, vy);
			PlaneProfile ppTop(cs);
			ppTop.joinRing(pLineTop, FALSE);
			ppTop.vis(2);
			
			Vector3d vDirection=-vz;
			//vDirection=vDirection.rotateBy(25, vy);
			//vDirection=vDirection.rotateBy(20, vx);
			vDirection.normalize();
			//vDirection.vis(ptOrg);

			LineSeg lsNew=ppTop.extentInDir(vDirection);
			lsNew.vis();
			
			double aArea=ppTop.area()/U(1)*U(1);
			
			PlaneProfile ppCheckInter=ppTop;
			
			if (ppCheckInter.intersectWith(ppRotateTop)==true)
			{
				if (ppTop.subtractProfile(ppRotateTop)==true)
				{
					PLine plAllRings[]=ppTop.allRings();
					double dMaxSpaceAvailable=0;
					Point3d ptLocationSheet;
					
					for (int j = 0 ; j < plAllRings.length(); j++)
					{
						PlaneProfile ppThisRing(plAllRings[j]);
						LineSeg lsNew=ppThisRing.extentInDir(vDirection);
						double dSpaceAvailable=abs(vz.dotProduct(lsNew.ptStart()-lsNew.ptEnd()));
						ptLocationSheet=lsNew.ptStart();
						if (dSpaceAvailable>dMaxSpaceAvailable)
						{
							dMaxSpaceAvailable=dSpaceAvailable;
						}
					}
					
					if (dMaxSpaceAvailable>=dThickness)
					{
						nCreate=TRUE;
						dMoveDist=abs(vz.dotProduct(ptLocationSheet-ptOrg));
					}
				}
			}
			else
			{
				nCreate=TRUE;
			}
		}
		else
		{
			nCreate=TRUE;
		}
		*/
		if (abs(vx.dotProduct(ls.ptStart() - ls.ptEnd())) > dMinWidth && abs(vy.dotProduct(ls.ptStart() - ls.ptEnd())) > dMinWidth)
		{
			if (nCreate)
			{
				//create sheet
				Sheet sh;
				sh.dbCreate(ppSingle, dInsulationThickness, 1);
				sh.setColor(nColor);
				sh.setName(sNameIns);
				sh.setMaterial("Insulation");
				sh.assignToElementGroup(el, TRUE, nZoneToAssign, 'Z');
				//reportNotice("\nZoneToInsulate: "+nZoneToInsulate);
				if (dMoveDist>0)
					sh.transformBy(-vz*dMoveDist);

				Map mp;
				mp.setInt("Erase", true);
				sh.setSubMapX("Insulation", mp);
				
				_Sheet.append(sh);	
			}
		}
	}
}

//Display of the Hatch pf the Insulation
Display dpHatch(nColor);
Hatch hatch(pHatchPattern ,dHatchScale);
dpHatch.addViewDirection(vy);
dpHatch.showInDispRep(sDispRep);

Plane pn(ptOrg, vz);
Plane plnY(ptOrg, vy);

if (bDisplay)
{
	for( int i=0; i<_Sheet.length(); i++ ){
		Sheet sh = _Sheet[i];
		Body bdSh=sh.realBody();
		//bdBm.vis();
		PlaneProfile ppBm=bdSh.shadowProfile(plnY);
		PlaneProfile ppInsu=bdSh.shadowProfile(pn);
		ppBm.shrink(U(1));
		
		dpHatch.draw(ppBm, hatch);
	}
}

// assigning
assignToElementGroup(el,TRUE, nZoneToInsulate, 'I');

_Map.setInt("nExecutionMode", 0);




#End
#BeginThumbnail
M_]C_X``02D9)1@`!``$`8`!@``#__@`?3$5!1"!496-H;F]L;V=I97,@26YC
M+B!6,2XP,0#_VP"$``0#`P0#`P0$`P0%!00%!PP'!P8&!PX*"P@,$0\2$A$/
M$!`3%1L7$Q0:%!`0&"`8&AP='A\>$A<A)"$>)!L>'AT!!04%!P8'#@<'#AT3
M$!,='1T='1T='1T='1T='1T='1T='1T='1T='1T='1T='1T='1T='1T='1T=
M'1T='1T='?_$`:(```$%`0$!`0$!```````````!`@,$!08'"`D*"P$``P$!
M`0$!`0$!`0````````$"`P0%!@<("0H+$``"`0,#`@0#!04$!````7T!`@,`
M!!$%$B$Q008346$'(G$4,H&1H0@C0K'!%5+1\"0S8G*""0H6%Q@9&B4F)R@I
M*C0U-C<X.3I#1$5&1TA)2E-455976%E:8V1E9F=H:6IS='5V=WAY>H.$A8:'
MB(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4U=;7
MV-G:X>+CY.7FY^CIZO'R\_3U]O?X^?H1``(!`@0$`P0'!00$``$"=P`!`@,1
M!`4A,08205$'87$3(C*!"!1"D:&QP0DC,U+P%6)RT0H6)#3A)?$7&!D:)B<H
M*2HU-C<X.3I#1$5&1TA)2E-455976%E:8V1E9F=H:6IS='5V=WAY>H*#A(6&
MAXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&Q\C)RM+3U-76
MU]C9VN+CY.7FY^CIZO+S]/7V]_CY^O_``!$(`6H!B`,!$0`"$0$#$0'_V@`,
M`P$``A$#$0`_`/OZ@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`.8_X63X,_P"AN\/_`/@RA_\`BJY/K^%_Y^Q^
M]?YG5]2Q/_/N7W,/^%D^#/\`H;O#_P#X,H?_`(JCZ_A?^?L?O7^8?4L3_P`^
MY?<P_P"%D^#/^AN\/_\`@RA_^*H^OX7_`)^Q^]?YA]2Q/_/N7W,/^%D^#/\`
MH;O#_P#X,H?_`(JCZ_A?^?L?O7^8?4L3_P`^Y?<P_P"%D^#/^AN\/_\`@RA_
M^*H^OX7_`)^Q^]?YA]2Q/_/N7W,/^%D^#/\`H;O#_P#X,H?_`(JCZ_A?^?L?
MO7^8?4L3_P`^Y?<P_P"%D^#/^AN\/_\`@RA_^*H^OX7_`)^Q^]?YA]2Q/_/N
M7W,/^%D^#/\`H;O#_P#X,H?_`(JCZ_A?^?L?O7^8?4L3_P`^Y?<P_P"%D^#/
M^AN\/_\`@RA_^*H^OX7_`)^Q^]?YA]2Q/_/N7W,/^%D^#/\`H;O#_P#X,H?_
M`(JCZ_A?^?L?O7^8?4L3_P`^Y?<P_P"%D^#/^AN\/_\`@RA_^*H^OX7_`)^Q
M^]?YA]2Q/_/N7W,/^%D^#/\`H;O#_P#X,H?_`(JCZ_A?^?L?O7^8?4L3_P`^
MY?<P_P"%D^#/^AN\/_\`@RA_^*H^OX7_`)^Q^]?YA]2Q/_/N7W,/^%D^#/\`
MH;O#_P#X,H?_`(JCZ_A?^?L?O7^8?4L3_P`^Y?<P_P"%D^#/^AN\/_\`@RA_
M^*H^OX7_`)^Q^]?YA]2Q/_/N7W,/^%D^#/\`H;O#_P#X,H?_`(JCZ_A?^?L?
MO7^8?4L3_P`^Y?<P_P"%D^#/^AN\/_\`@RA_^*H^OX7_`)^Q^]?YA]2Q/_/N
M7W,/^%D^#/\`H;O#_P#X,H?_`(JCZ_A?^?L?O7^8?4L3_P`^Y?<P_P"%D^#/
M^AN\/_\`@RA_^*H^OX7_`)^Q^]?YA]2Q/_/N7W,/^%D^#/\`H;O#_P#X,H?_
M`(JCZ_A?^?L?O7^8?4L3_P`^Y?<P_P"%D^#/^AN\/_\`@RA_^*H^OX7_`)^Q
M^]?YA]2Q/_/N7W,/^%D^#/\`H;O#_P#X,H?_`(JCZ_A?^?L?O7^8?4L3_P`^
MY?<P_P"%D^#/^AN\/_\`@RA_^*H^OX7_`)^Q^]?YA]2Q/_/N7W,/^%D^#/\`
MH;O#_P#X,H?_`(JCZ_A?^?L?O7^8?4L3_P`^Y?<P_P"%D^#/^AN\/_\`@RA_
M^*H^OX7_`)^Q^]?YA]2Q/_/N7W,/^%D^#/\`H;O#_P#X,H?_`(JCZ_A?^?L?
MO7^8?4L3_P`^Y?<P_P"%D^#/^AN\/_\`@RA_^*H^OX7_`)^Q^]?YA]2Q/_/N
M7W,/^%D^#/\`H;O#_P#X,H?_`(JCZ_A?^?L?O7^8?4L3_P`^Y?<P_P"%D^#/
M^AN\/_\`@RA_^*H^OX7_`)^Q^]?YA]2Q/_/N7W,/^%D^#/\`H;O#_P#X,H?_
M`(JCZ_A?^?L?O7^8?4L3_P`^Y?<P_P"%D^#/^AN\/_\`@RA_^*H^OX7_`)^Q
M^]?YA]2Q/_/N7W,/^%D^#/\`H;O#_P#X,H?_`(JCZ_A?^?L?O7^8?4L3_P`^
MY?<P_P"%D^#/^AN\/_\`@RA_^*H^OX7_`)^Q^]?YA]2Q/_/N7W,/^%D^#/\`
MH;O#_P#X,H?_`(JCZ_A?^?L?O7^8?4L3_P`^Y?<P_P"%D^#/^AN\/_\`@RA_
M^*H^OX7_`)^Q^]?YA]2Q/_/N7W,/^%D^#/\`H;O#_P#X,H?_`(JCZ_A?^?L?
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
(*`"@`H`__]D`
`








































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