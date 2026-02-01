#Version 8
#BeginDescription
#Versions
1.8 08.01.2025 HSB-23037: Fix spelling error 
1.7 01.09.2023 HSB-19784: TSL can be attached at elements and operate on generation 
Version 1.6 03.06.2022 HSB-15372 purging duplicates improved 


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 8
#KeyWords Opening,Milling,UK
#BeginContents
// #Versions
// 1.8 08.01.2025 HSB-23037: Fix spelling error Author: Marsel Nakuci
// 1.7 01.09.2023 HSB-19784: TSL can be attached at elements and operate on generation Author: Marsel Nakuci
// 1.6 03.06.2022 HSB-15372 purging duplicates improved , Author Thorsten Huck


/*
*  COPYRIGHT
*  ---------
*  Copyright (C) 2004 by
*  hsbSOFT N.V.
*  THE NETHERLANDS
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT N.V., or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
*
* REVISION HISTORY
* ----------------
*
* Created: Chirag Sawjani	
* date: 16/11/2012
* version 1.0: Release based on Assign Millings to Openings
*
*/

//Script uses inches.

Unit(1,"mm");
//int nLunit = 4; // architectural (only used for beam length, others depend on hsb_settings)
//int nPrec = 3; // precision (only used for beam length, others depend on hsb_settings)
String arSYesNo[] = {T("Yes"), T("No")};
int arNYesNo[] = {_kYes, _kNo};
String categories[] = { T("|Milling|"), T("|Dimensions - Windows|"), T("|Locations|"), T("|Dimensions - Doors|"), T("|Dimensions - General|")};

String modes[] = { T("|Opening|"), T("|Opening where sheets intersect|")};
PropString sMode(5, modes, T("|Milling mode|"), 0);
sMode.setCategory(categories[0]);

String sZoneToLookForOptions[]={T("Specified zone"), T("Outermost zone"), T("Innermost zone") };
PropString sZoneToLookFor (4, sZoneToLookForOptions, T("Zone to mill"), 0);

int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nValidZone(0, nValidZones, T("Specified zone"));

//int arNZone[] = { -5, -4, -3, -2, -1, 1, 2, 3, 4, 5};
//PropInt nZone(0,arNZone,T("Zone"),5);
// HSB-23037
PropDouble millDepth (0,U(0),T("Milling Depth '0=Zone depth'"));
millDepth.setCategory(categories[0]);

PropInt nToolingIndex(1,1,T("Tooling index"));
nToolingIndex.setCategory(categories[0]);

String arSSide[]= {T("Left"),T("Right")};
int arNSide[]={_kLeft, _kRight};
PropString strSide(0,arSSide,T("Side"),0);
strSide.setCategory(categories[0]);

String arSTurn[]= {T("Against course"),T("With course")};
int arNTurn[]={_kTurnAgainstCourse, _kTurnWithCourse};
PropString strTurn(1,arSTurn,T("Turning direction"),1);
strTurn.setCategory(categories[0]);

String arSOShoot[]= {T("No"),T("Yes")};
int arNOShoot[]={_kNo, _kYes};
PropString strOShoot(2,arSOShoot,T("Overshoot"));
strOShoot.setCategory(categories[0]);

String arSVacuum[]= {T("No"),T("Yes")};

int arNVacuum[]={_kNo, _kYes};
PropString strVacuum(3,arSVacuum,T("Vacuum"),1);
strVacuum.setCategory(categories[0]);

//Windows
PropDouble dOffsetWindowTop(1,U(0),T("Offset milling opening top"));
dOffsetWindowTop.setCategory(categories[1]);

PropDouble dOffsetWindowBottom(2,U(0),T("Offset milling opening bottom"));
dOffsetWindowBottom.setCategory(categories[1]);

PropDouble dOffsetWindowLeft(3,U(0),T("Offset milling opening left"));
dOffsetWindowLeft.setCategory(categories[1]);

PropDouble dOffsetWindowRight(4,U(0),T("Offset milling opening right"));
dOffsetWindowRight.setCategory(categories[1]);

//Doors
PropDouble dOffsetDoorTop(6,U(0),T("Offset milling door top"));
dOffsetDoorTop.setCategory(categories[3]);

PropDouble dOffsetDoorBottom(7,U(0),T("Offset milling door bottom"));
dOffsetDoorBottom.setCategory(categories[3]);

PropDouble dOffsetDoorLeft(8,U(0),T("Offset milling door left"));
dOffsetDoorLeft.setCategory(categories[3]);

PropDouble dOffsetDoorRight(9,U(0),T("Offset milling door right"));
dOffsetDoorRight.setCategory(categories[3]);

//General
PropDouble dEdgeOffsetFromHole(5, U(0), T("Offset from hole edge"));
dEdgeOffsetFromHole.setCategory(categories[4]);

// HSB-19784
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

//Insert done in script
if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialog();
	
	PrEntity ssE(T("Select one or More Elements"), ElementWallSF());
	ssE.addAllowedClass(ElementRoof());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}

	//Insert the TSL again for each Element
	TslInst tsl;
	String sScriptName = scriptName(); // name of the script
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Entity lstEnts[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];
	
	int lstPropInt[0];
	lstPropInt.append(nValidZone);
	lstPropInt.append(nToolingIndex);

	String lstPropString[0];	
	lstPropString.append(strSide);
	lstPropString.append(strTurn);
	lstPropString.append(strOShoot);
	lstPropString.append(strVacuum);
	lstPropString.append(sZoneToLookFor);	
	lstPropString.append(sMode);
	
	double lstPropDouble[0];	  
	lstPropDouble.append(millDepth);
	lstPropDouble.append(dOffsetWindowTop);
	lstPropDouble.append(dOffsetWindowBottom);		
	lstPropDouble.append(dOffsetWindowLeft);
	lstPropDouble.append(dOffsetWindowRight);		
	lstPropDouble.append(dEdgeOffsetFromHole);		
	lstPropDouble.append(dOffsetDoorTop);
	lstPropDouble.append(dOffsetDoorBottom);		
	lstPropDouble.append(dOffsetDoorLeft);
	lstPropDouble.append(dOffsetDoorRight);	
	
	for (int i=0; i<_Element.length(); i++)
	{
		Element el=_Element[i];
		Opening opElement[]=el.opening();
		for(int j=0;j<opElement.length();j++)
		{
			Opening op=opElement[j];
			if(!op.bIsValid()) return;
			
			Map mpToClone;
			mpToClone.setInt("ExecutionMode",0);
			mpToClone.setString("OpeningHandle",op.handle());
			
			lstEnts.setLength(0);
			lstEnts.append(op);
			tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
		}
	}
	// 
	ElementRoof elRoofs[0];
	for (int i=0;i<_Element.length();i++) 
	{ 
		ElementRoof eRoof = (ElementRoof)_Element[i];
		if(eRoof.bIsValid() && elRoofs.find(eRoof)<0)
		{ 
			elRoofs.append(eRoof);
		}
	}//next i
	
	
	double dEps =U(.1);
	
	// for each elRoof get all OpeningRoof
	for (int i=0;i<elRoofs.length();i++) 
	{ 
		
		ElementRoof elRoofI = elRoofs[i];
		Group grpEl = elRoofI.elementGroup();
		String sGroupRoof = grpEl.namePart(0) + "\\" + grpEl.namePart(1);
		Group grpOp(sGroupRoof);
		Entity entsOpeningRoof[] = grpOp.collectEntities(true, OpeningRoof(), _kModelSpace);
		if (entsOpeningRoof.length() == 0)continue;
		// find relevant openings in elemetRoof
		
		// openingRoofs related to group of this element
		OpeningRoof opRoofs[0];
		for (int j=0;j<entsOpeningRoof.length();j++) 
		{ 
			OpeningRoof oR = (OpeningRoof)entsOpeningRoof[j];
			if(oR.bIsValid() && opRoofs.find(oR)<0)
				opRoofs.append(oR);
		}//next i
		
		// 
		OpeningRoof opRoofsEl[0];
		CoordSys csEl = elRoofI.coordSys();
		PlaneProfile ppElEnvelope(csEl);
		ppElEnvelope.joinRing(elRoofI.plEnvelope(), _kAdd);
		
		for (int j=0;j<opRoofs.length();j++) 
		{ 
			PlaneProfile ppOp(csEl);
			ppOp.joinRing(opRoofs[j].plShape(), _kAdd);
			PlaneProfile ppIntersect = ppElEnvelope;
			ppIntersect.vis(1);
			ppOp.vis(i);
			if (ppIntersect.intersectWith(ppOp));
			{ 
				if (ppIntersect.area() < pow(dEps, 2))continue;
//				ppIntersect.shrink(-U(200));
//				ppIntersect.vis(3);
				if(opRoofsEl.find(opRoofs[j])<0)
					opRoofsEl.append(opRoofs[j]);
			}
		}//next i
		
		// tsl for each opening
		for (int j=0;j<opRoofsEl.length();j++) 
		{ 
			OpeningRoof oRj = opRoofsEl[j];
			
			Map mpToClone;
			mpToClone.setInt("ExecutionMode",0);
			mpToClone.setString("OpeningHandle",oRj.handle());
			
			lstEnts.setLength(0);
			lstEnts.append(oRj);
			lstEnts.append(elRoofI);
			reportMessage("\n"+ scriptName() + " creating OpeningRoof TSL");
			
			tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
		}//next j
	}//next i
	
	eraseInstance();
	//Return to drawing
	return;
}


// HSB-19784: if tsl attached in element
if(_Element.length()==1 && _Opening.length()==0)
{ 
	Element el=_Element[0];
	Opening ops[]=el.opening();
	
// create TSL
	TslInst tslNew;	Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
	GenBeam gbsTsl[]={}; Entity entsTsl[1]; Point3d ptsTsl[]={_Pt0};
	int nProps[]={nValidZone,nToolingIndex}; 
	double dProps[]={millDepth,dOffsetWindowTop,dOffsetWindowBottom,
		dOffsetWindowLeft,dOffsetWindowRight,dEdgeOffsetFromHole,
		dOffsetDoorTop,dOffsetDoorBottom,dOffsetDoorLeft,dOffsetDoorRight}; 
	String sProps[]={strSide,strTurn,strOShoot,strVacuum,sZoneToLookFor,sMode};
	Map mapTsl;
	for (int i=0;i<ops.length();i++) 
	{ 
		OpeningSF opSf=(OpeningSF)ops[i];
		if(!opSf.bIsValid())continue;
		
		entsTsl[0]=opSf;
		tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
			ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
	}//next i
	
	eraseInstance();
	return;
}

//Check if there are elements selected.
int iOpeningRoof;
OpeningRoof oR;
ElementRoof eR;
if(_Opening.length()==0)
{ 
	// check if OpeningRoof
	for (int i=0;i<_Entity.length();i++) 
	{ 
		OpeningRoof oRi = (OpeningRoof)_Entity[i];
		if (oRi.bIsValid())oR = oRi;
		ElementRoof eRi = (ElementRoof)_Entity[i];
		if (eRi.bIsValid())eR = eRi;
	}//next i
	if(!oR.bIsValid() || !eR.bIsValid())
	{ 
		eraseInstance();
		return;
	}
	else
	{ 
		iOpeningRoof = true;
	}
}


if(!iOpeningRoof)
	if(_Opening.length() == 0){eraseInstance(); return;}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

int nZone=nRealZones[nValidZones.find(nValidZone, 0)];
int nVacuum = arNVacuum[arSVacuum.find(strVacuum,0)];
int nOShoot = arNOShoot[arSOShoot.find(strOShoot,0)];
int nSide = arNSide[arSSide.find(strSide,0)];
int nTurn = arNTurn[arSTurn.find(strTurn,0)];
int nZoneToMill=sZoneToLookForOptions.find(sZoneToLookFor, 0);
int nMode = modes.find(sMode,0);

//Assign selected element to el.
Opening op;
Element el;
if(!iOpeningRoof)
{
	op=_Opening[0];
	el = op.element();
	if(!el.bIsValid()){eraseInstance(); return;}
}
else
{ 
	el = eR;
}

int nExecute=_Map.getInt("ExecutionMode");
Entity dependantEntities[0];



if (nZoneToMill==1) // most outer zone
{
	for (int i=10; i>0; i--)
	{
		ElemZone elZone=el.zone(i);
		if(elZone.dH()>0)
		{
			nZone=i;
			nValidZone.set(nZone);
			break;
		}
	}
}
else if (nZoneToMill==2) //most inner zone
{
	for (int i=-10; i<0; i++)
	{
		ElemZone elZone=el.zone(i);
		if(elZone.dH()>0)
		{
			nZone=i;
			nValidZone.set(5+abs(nZone));
			break;
		}
	}
}
else
{
	nZone=nRealZones[nValidZones.find(nValidZone, 0)];
}





TslInst tslAll[]=el.tslInstAttached();

// purge duplictaes
	for (int i=tslAll.length()-1; i>=0 ; i--) 
	{ 
		TslInst& t=tslAll[i];	
		if (!t.bIsValid() || t.scriptName()!=scriptName() || t == _ThisInst)	{continue;}
		
		// get seelcted zone of other tsl
		int option=sZoneToLookForOptions.find(t.propString(4), 0);
		int n = t.propInt(0);
		n = n > 5 ? (n-5)*-1 : n;
		
		// look for outmost
		if (option==1 || option==2)
		{ 
			int sgn = option == 1 ?1 : -1;
			for (int j=0; j<6; j++)
				if(el.zone(sgn*j).dH()>0)
					n = sgn * j;
		}
	
		// zone match
		if (nZone!=n){ continue;}

		// purge
		if (t.entity().find(op)>-1)
		{ 	
			//reportNotice("\n" + t.handle() + " is candiate to be erased in zone " + nZone);
			if (!_bOnDebug)
				t.dbErase();
			continue;
		}
	}

//if(nExecute==false)
//{
//	for (int i=0; i<tslAll.length(); i++)
//	{
//		TslInst tsl=tslAll[i];
//		Map mp=tsl.map();
//		String sOpHandle=mp.getString("OpeningHandle");
//
//		reportNotice("\n   vs " +tsl.handle()+" handle " + sOpHandle + " vs " + op.handle() );
//
//		if ( tslAll[i].scriptName() == scriptName() && tslAll[i].handle() != _ThisInst.handle())
//		{
//			if(sOpHandle==op.handle())
//			{
//					//remove duplicate TSL
//					tslAll[i].dbErase();
//			}
//		}
//	}
//}











//Place _Pt0 in origin of element
Point3d elOrg = el.ptOrg();
_Pt0 = el.ptOrg();

//Define a ccordsys of the element.
CoordSys csEl = el.coordSys();	
//Define a useful set of vectors.
Vector3d vX = csEl.vecX();vX.vis(_Pt0,1);
Vector3d vY = csEl.vecY();vY.vis(_Pt0,3);
Vector3d vZ = csEl.vecZ();vZ.vis(_Pt0,150);

CoordSys csOp;
Vector3d vXop, vYop, vZop;

if(iOpeningRoof)
{ 
	csOp = oR.coordSys();
	vXop = csOp.vecX();
	vYop = csOp.vecY();
	vZop = csOp.vecZ();
}
csOp.vis(4);
//Cast op to OpeningSF and assign it to opSf
OpeningSF opSf;
if(!iOpeningRoof)
	opSf = (OpeningSF)op;
if(!opSf.bIsValid())
{ 
	reportMessage("\n"+scriptName()+" "+T("|Opening is not a SF opening|"));
	reportMessage("\n"+scriptName()+" "+T("|No hsb Data attached to opening|"));
	eraseInstance();
	return;
}
//Get the shape of the opening as a poly line
PLine plOp;
if(!iOpeningRoof)
{
	plOp = opSf.plShape();
}
else
{ 
	plOp = oR.plShape();
}
//Get the points of this poly line
Point3d arPtOp[] = plOp.vertexPoints(TRUE);  

//Calculate the center pointof the opening
Point3d ptOpCen;
for(int j=0;j<arPtOp.length();j++){
	Point3d pt = arPtOp[j];
	ptOpCen = ptOpCen + pt;
}
ptOpCen = ptOpCen/arPtOp.length();
ptOpCen.vis(5);
//calculate the left and right point of the opening.
Point3d ptLeft;
Point3d ptRight;

double dWidthOp, dHeightOp;
if(iOpeningRoof)
{ 
	PlaneProfile ppOp(csOp);
	ppOp.joinRing(plOp, _kAdd);
	ppOp.vis(3);
	// get extents of profile
	LineSeg seg = ppOp.extentInDir(vXop);
//	dWidthOp = abs(vXop.dotProduct(seg.ptStart()-seg.ptEnd()));
//	dHeightOp = abs(vYop.dotProduct(seg.ptStart()-seg.ptEnd()));
	dWidthOp = abs(vX.dotProduct(seg.ptStart()-seg.ptEnd()));
	dHeightOp = abs(vY.dotProduct(seg.ptStart()-seg.ptEnd()));
}

if(!iOpeningRoof)
{ 
	ptLeft = ptOpCen - vX * 0.5 * opSf.width();
	ptRight = ptOpCen + vX * 0.5 * opSf.width();
}
else
{ 
//	double dOpHeight = oR.dOpeningHeight();
//	int uu;
//	PlaneProfile ppOp(csOp);
//	ppOp.joinRing(plOp, _kAdd);
//	// get extents of profile
//	LineSeg seg = ppOp.extentInDir(vXop);
//	double dX = abs(vXop.dotProduct(seg.ptStart()-seg.ptEnd()));
//	double dY = abs(vYop.dotProduct(seg.ptStart()-seg.ptEnd()));
	
	ptLeft = ptOpCen - vXop * 0.5 * dWidthOp;
	ptRight = ptOpCen + vXop * 0.5 * dHeightOp;
	ptLeft.vis(1);
	ptRight.vis(1);
}

//Calculate the type of offset to set based on the opening type (window or door)
int dOffsetTop = dOffsetWindowTop;
int dOffsetBottom = dOffsetWindowBottom;
int dOffsetLeft = dOffsetWindowLeft;
int dOffsetRight = dOffsetWindowRight;

if (opSf.openingType()==_kDoor)
{ 
	dOffsetTop = dOffsetDoorTop;
	dOffsetBottom = dOffsetDoorBottom;
	dOffsetLeft = dOffsetDoorLeft;
	dOffsetRight = dOffsetDoorRight;
}

//Find the sill which belongs to this opening.
//Get all the beams of this element.
Beam arBm[] = el.beam();
Sheet arSheetsInZone[] = el.sheet(nZone);
PlaneProfile ppSheetsInZone[0];
PlaneProfile ppAllSheetsInZone(csEl);
Plane plElement(elOrg, vZ);
for(int i=0;i<arSheetsInZone.length();i++)
{
	Sheet sheetInZone= arSheetsInZone[i];
	PlaneProfile ppSheet(csEl);
	ppSheet.unionWith(sheetInZone.envelopeBody(FALSE, TRUE).shadowProfile(plElement));
	if (ppSheet.area() < U(1) * U(1)) continue;

	ppAllSheetsInZone.unionWith(ppSheet);
	ppSheetsInZone.append(ppSheet);
}

ppAllSheetsInZone.shrink(U(-10));
ppAllSheetsInZone.shrink(U(10));

//Create a new beam, nothing assigned to it yet.
Beam bmSill;
Beam bmSills[0];
//Loop over all beams
for(int j=0;j<arBm.length();j++){
	//Assign the current beam to bm.
	Beam bm = arBm[j];
	//Continue if the current beam is NOT a sill.
	if(bm.type() != _kSill)continue;
   
	//Check if the sill belongs to this element.
	double d1 = vX.dotProduct(bm.ptCen() - ptLeft);
	double d2 = vX.dotProduct(bm.ptCen() - ptRight);    
	if( (d1 * d2) < 0 ){
		bmSills.append (bm);
	}
}

//Sort the sills and bottom plates to get bottom most sill and top most bottom plate
bmSills = Beam().filterBeamsHalfLineIntersectSort(bmSills, ptOpCen, - vY);
if (bmSills.length()>0)
	bmSill = bmSills[0];

//Default gap is set to 0.
double dGapB = 0;
//If there is a sill: calculate the gap on the bottom.
if( bmSill.bIsValid() )
{
	if(!iOpeningRoof)
	{
		dGapB = vY.dotProduct((ptOpCen - vY * 0.5 * opSf.height()) - (bmSill.ptCen() + vY * 0.5 * bmSill.dW()));
	}
	else
	{ 
		dGapB = vY.dotProduct((ptOpCen - vY * 0.5 * dHeightOp) - (bmSill.ptCen() + vY * 0.5 * bmSill.dW()));
	}
}

//Total width of the opening, gaps included.
double dOpW;
if(!iOpeningRoof)
{
	dOpW = opSf.width() + 2 * opSf.dGapSide();
}
else
{ 
	dOpW = dWidthOp;
}

//Calculate the vertexpoints of the opening, all gaps included.
Point3d ptLL;
Point3d ptLR;
Point3d ptUR;
Point3d ptUL;

if(!iOpeningRoof)
{ 
	ptLL = ptOpCen - vX * (0.5 * dOpW + dOffsetLeft) - vY * (0.5 * opSf.height() + dGapB + dOffsetBottom);
	ptLR = ptOpCen + vX * (0.5 * dOpW + dOffsetRight) - vY * (0.5 * opSf.height() + dGapB + dOffsetBottom);
	ptUR = ptOpCen + vX * (0.5 * dOpW + dOffsetRight) + vY * (0.5 * opSf.height() + opSf.dGapTop() + dOffsetTop);
	ptUL = ptOpCen - vX * (0.5 * dOpW + dOffsetLeft) + vY * (0.5 * opSf.height() + opSf.dGapTop() + dOffsetTop);
}
else
{ 
	ptLL = ptOpCen - vX * (0.5 * dOpW + dOffsetLeft) - vY * (0.5 * dHeightOp + dGapB + dOffsetBottom);
	ptLR = ptOpCen + vX * (0.5 * dOpW + dOffsetRight) - vY * (0.5 * dHeightOp + dGapB + dOffsetBottom);
	ptUR = ptOpCen + vX * (0.5 * dOpW + dOffsetRight) + vY * (0.5 * dHeightOp + dOffsetTop);
	ptUL = ptOpCen - vX * (0.5 * dOpW + dOffsetLeft) + vY * (0.5 * dHeightOp + dOffsetTop);
}

ElemZone elZone = el.zone(nZone);

double dMillDepth = 0;
if (abs(millDepth) < 0.01)
{
	dMillDepth = elZone.dH();
}
else
{
	dMillDepth = millDepth;
}

if (nMode == 0)
{
	
	//Create a poly line with those vertex points.
	//Create Pline with a normal.
	PLine plMill(vZ);
	plMill.addVertex(ptLL);
	plMill.addVertex(ptUL);
	plMill.addVertex(ptUR);
	plMill.addVertex(ptLR);
	plMill.close();
	plMill.vis(5);
	
	
	
	ElemMill millOp(nZone, plMill, dMillDepth, nToolingIndex, nSide, nTurn, nOShoot);
	millOp.setVacuum(nVacuum);
	el.addTool(millOp);
}
if (nMode == 1)
{
	LineSeg lsOpeningSeg(ptLL, ptUR);
	PLine plOpeningRect;
	plOpeningRect.createRectangle(lsOpeningSeg, vX, vY);
	PlaneProfile ppOpeningRect(csEl);
	ppOpeningRect.joinRing(plOpeningRect, FALSE);
	
	PlaneProfile ppOpeningIntersections(ppOpeningRect);
	
	ppOpeningIntersections.intersectWith(ppAllSheetsInZone);
	ppOpeningRect.vis(3);
	
	PLine plOpeningIntersectionRings[] = ppOpeningIntersections.allRings();
	int nOpeningIntersectionRingOpenings[] = ppOpeningIntersections.ringIsOpening();
	
	PlaneProfile ppMillings(csEl);
	
	for (int j = 0; j < plOpeningIntersectionRings.length(); j++)
	{
		PLine& plOpeningIntersection = plOpeningIntersectionRings[j];
		if ( nOpeningIntersectionRingOpenings[j] )continue;
		
		Point3d vertices[] = plOpeningIntersection.vertexPoints(TRUE);
		if (vertices.length() == 0) continue;
		
		for (int x = 0; x < vertices.length(); x++)
		{
			Point3d& ptStart = vertices[x];
			Point3d& ptEnd = x == vertices.length() - 1 ? vertices[0] : vertices[x + 1];
			
			LineSeg lsSeg(ptStart, ptEnd);
			Point3d ptMid = lsSeg.ptMid();
			Vector3d vecSeg = ptEnd - ptStart;
			vecSeg.normalize();
			Vector3d vecOut = vecSeg.crossProduct(vZ);
			
			Point3d ptOut = ptMid + vecOut * U(1);
			vecOut.vis(ptOut);
			ptStart.vis(x);
			ptEnd.vis(x);
			if (ppOpeningRect.pointInProfile(ptOut) == _kPointInProfile)
			{
				//Point is inside the opening which means we need to offset this edge
				ptStart.transformBy(-vecOut * dEdgeOffsetFromHole);
				ptEnd.transformBy(-vecOut * dEdgeOffsetFromHole);
			}
		}
		
		PLine plMilling(vZ);
		for (int x = 0; x < vertices.length(); x++)
		{
			plMilling.addVertex(vertices[x]);
		}
		
		plMilling.close();
		double dDepth = el.zone(nZone).dH();
		ElemMill millOp(nZone, plMilling, dMillDepth, nToolingIndex, nSide, nTurn, nOShoot);
		millOp.setVacuum(nVacuum);
		el.addTool(millOp);
		
		ppMillings.joinRing(plMilling, false);
		
		ppMillings.vis(1);
		
		//		//Find all the sheets that participated in this milling
		//		int sheetIndexesForMilling[0];
		//		for (int x = 0; x < vertices.length(); x++)
		//		{
		//			Point3d& ptVertex = vertices[x];
		//			for (int y = 0; y < ppSheetsInZone.length(); y++)
		//			{
		//				PlaneProfile& sheetProfile = ppSheetsInZone[y];
		//				if (sheetProfile.pointInProfile(ptVertex) == _kPointInProfile && sheetIndexesForMilling.find(y, - 1) == -1)
		//				{
		//					sheetIndexesForMilling.append(y);
		//				}
		//			}
		//		}
		//
		//		for (int x = 0; x < sheetIndexesForMilling.length(); x++)
		//		{
		//			dependantEntities.append(arSheetsInZone[sheetIndexesForMilling[x]]);
		//		}
	}
	
	for (int i = 0; i < arSheetsInZone.length(); i++)
	{
		Sheet sheetInZone = arSheetsInZone[i];
		PlaneProfile ppSheet(csEl);
		ppSheet.unionWith(sheetInZone.envelopeBody(FALSE, TRUE).shadowProfile(plElement));
		ppSheet.vis(3);
		ppSheet.shrink(-U(5));
		ppSheet.intersectWith(ppMillings);
		if (ppSheet.area() > U(1) * U(1))
		{ 
			dependantEntities.append(sheetInZone);
		}
	}
}

//ElemZone elZn = el.zone(nZone);
//String sCode = elZn.code();
//double dGapZn = 0;
//if( sCode == "HSB-PL03" ){
//	if( elZn.hasVar("gap") ){
//		dGapZn = U(elZn.dVar("gap"), "mm");
//	}
//}
	
_Map.setInt("ExecutionMode",1);

assignToElementGroup(el,TRUE,nZone,'E');

Map dependantEntityArrayMap;
for(int i=0;i<dependantEntities.length();i++)
{
	Entity ent = dependantEntities[i];
	Map dependantEntityMap;
	dependantEntityMap.setEntity("Entity", ent);
	dependantEntityArrayMap.appendMap("DependantEntity", dependantEntityMap);
}

_Map.setMap("DependantEntity[]", dependantEntityArrayMap);



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
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23037: Fix spelling error" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="1/8/2025 9:55:26 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-19784: TSL can be attached at elements and operate on generation" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="9/1/2023 3:21:25 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15372 purging duplicates improved" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="6/3/2022 11:45:42 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Adapt for ElementRoof" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="1/18/2021 11:42:00 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End