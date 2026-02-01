#Version 8
#BeginDescription
Exports to the dBase the corner type, junction types and all opening information.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 09.02.2010 - version 1.1

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
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
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 01.02.2010
* version 1.0: Release Version
*
* date: 09.02.2010
* version 1.1: Add an index on the information to export
*
*/

U(1,"mm");	

int nLunit = 2; // architectural (only used for beam length, others depend on hsb_settings)
int nPrec = 0; // precision (only used for beam length, others depend on hsb_settings)

PropString sDimStyle (0,_DimStyles,T("DimStyle"));
PropString sDispRep (1,"",T("Show In Display Rep"));

PropInt nColor (0,171,T("Set the Text Color"));
PropDouble dOffset (0, 100, T("Offset Between Lines"));

if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();
	
	PrEntity ssE("\n"+T("Select a set of elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	String strScriptName = scriptName(); // name of the script
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Element lstElements[0];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	
	lstPropString.append(sDimStyle);
	lstPropString.append(sDispRep);
	lstPropDouble.append(dOffset);
	lstPropInt.append(nColor);
	
	for( int e=0;e<_Element.length();e++ ){
		Element el = _Element[e];
	
		lstElements.setLength(0);
		lstElements.append(el);
	
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString);
	}

	eraseInstance();
	return;
}

	
	
if( _Element.length()<=0 )
{
	eraseInstance();
	return;
}

ElementWallSF el = (ElementWallSF)_Element[0];

if (!el.bIsValid()){
	eraseInstance();
	return;
}

String strElCode=el.code();
String strElNumber=el.number();



//Element vectors
CoordSys csEl=el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();
Point3d ptOrgEl=csEl.ptOrg();

_Pt0=ptOrgEl;

TslInst tslAll[]=el.tslInstAttached();
for (int i=0; i<tslAll.length(); i++)
{
	if ( tslAll[i].scriptName() == scriptName() && tslAll[i].handle() != _ThisInst.handle() )
	{
		tslAll[i].dbErase();
	}
}
	
double dElThick=abs(el.dPosZOutlineBack());

Line lnFront (ptOrgEl, vx);
//Line lnBack (ptOrgEl-vz*(dElThick), vx);
	
LineSeg ls=el.segmentMinMax();
double dLen=abs(el.vecX().dotProduct(ls.ptStart()-ls.ptEnd()));

Point3d ptLeft=ptOrgEl;
Point3d ptRight=ptOrgEl+vx*dLen;

Element elAllCon[]=el.getConnectedElements();

String sCorner;
String sJunction[0];
int nCon=0;

for (int e=0; e<elAllCon.length(); e++)
{
	Element elC=elAllCon[e];
	//Element vectors
	CoordSys csElC=elC.coordSys();
	Vector3d vxC = csElC.vecX();
	Vector3d vyC = csElC.vecY();
	Vector3d vzC = csElC.vecZ();
	Point3d ptOrgElC=csElC.ptOrg();
	double dElThickC=abs(elC.dPosZOutlineBack());
	Line lnFrontC (ptOrgElC, vxC);
	Line lnBackC (ptOrgElC-vzC*(dElThickC), vxC);
	Point3d ptF,ptB;
	ptF=lnFront.closestPointTo(lnFrontC);
	ptB=lnFront.closestPointTo(lnBackC);
	
	ptF.vis(1);ptB.vis(2);
	
	Point3d ptJunction;
	Point3d ptFarSide;
	ptRight.vis();
	double dB=abs(vx.dotProduct(ptFarSide-ptRight));
	if (abs(vx.dotProduct(ptOrgEl-ptF))>dLen+U(5) || abs(vx.dotProduct(ptOrgEl-ptB))>dLen+U(5))
		continue;
	
	if (abs(vx.dotProduct(ptOrgEl-ptF))>abs(vx.dotProduct(ptOrgEl-ptB)))
	{
		ptJunction=ptB;
		ptFarSide=ptF;
	}
	else
	{
		ptJunction=ptF;
		ptFarSide=ptB;
	}
	
	if (vx.dotProduct(ptFarSide-ptOrgEl)<0)
		continue;
		
	int nCorner=FALSE;
	//Check the connections
	if (abs(vx.dotProduct(ptJunction-ptLeft))<U(20))
	{
		nCorner=TRUE;
		nCon++;
		sCorner="L";
	}
	if (abs(vx.dotProduct(ptFarSide-ptRight))<U(20))
	{
		nCorner=TRUE;
		nCon++;
		sCorner="R";
	}
	if (nCorner==FALSE)
	{
		double dDistJuction=abs(vx.dotProduct(ptOrgEl-ptJunction));
		String strDistJuction; strDistJuction.formatUnit(dDistJuction, nLunit, nPrec);
		sJunction.append(strDistJuction);
	}
}

//If there was more than i connection
if (nCon>1)
{
	sCorner="L/R";
}

ElemText et[0];//this sets the length of the array for the elements
et = el.elemTexts(); 

Point3d ptLocationDesc[0];
String sHeaderDescription[0];

for (int i = 0; i <et.length(); i++)
{
	Point3d ptTextorig = et[i].ptOrg();
	String eltext = et[i].text();

	String textCode = et[i].code();
	String textSubCode = et[i].subCode();

	if(textCode=="WINDOW" && textSubCode == "HEADER")
	{
		ptLocationDesc.append(ptTextorig);
		sHeaderDescription.append(eltext);
	}
}


String sOPWidth[0];
String sOPHeight[0];
String sOPStart[0];
String sOPLintelDesc[0];
String sOPHeadHeight[0];

Opening opAll[]=el.opening();

for (int o=0; o<opAll.length(); o++)
{
	OpeningSF op=(OpeningSF) opAll[o];
	if (!op.bIsValid()) { // want to keep only the OpeningSF types
		continue;
	}

	//double dHeightOp=op.height();
	//String sHeaderDesc=op.descrPlate();
	//double dHeadHeight=op.headHeight();
	
	PLine plOp=op.plShape();
	CoordSys csOp=op.coordSys();
	PlaneProfile ppOp (csOp);
	ppOp.joinRing(plOp, FALSE);
	LineSeg lsOp=ppOp.extentInDir(vx);
	Point3d ptStartOp=lsOp.ptStart();
	
	sOPWidth.append(op.width());
	sOPHeight.append(op.height());
	double dDistToStart=abs(vx.dotProduct(ptLeft-ptStartOp));
	String sAux; sAux.formatUnit(dDistToStart, nLunit, nPrec);
	sOPStart.append(sAux);

	
	double dMaxDist=U(10000);
	int nLoc=-1;
	for (int i=0; i<ptLocationDesc.length(); i++)
	{
		if (abs(vx.dotProduct(ptLocationDesc[i]-ptStartOp))<dMaxDist)
		{
			dMaxDist=abs(vx.dotProduct(ptLocationDesc[i]-ptStartOp));
			nLoc=i;
		}
	}
	
	if (nLoc!=-1)
		sOPLintelDesc.append(sHeaderDescription[nLoc]);
	else
		sOPLintelDesc.append("");
		
	sOPHeadHeight.append(op.headHeight());
}


//control the color if the designer places a stupid value
if (nColor > 255 || nColor < -1) nColor.set(171);
	
//setting the display colour
Display disp(nColor);
disp.dimStyle(sDimStyle);

if (sDispRep!="")
	disp.showInDispRep(sDispRep);

Point3d ptDisp=ptOrgEl;
ptDisp=ptDisp+vz*dOffset;
//display the Strings
disp.draw("Extra Data", ptDisp, vx, -vz,1,-1);
ptDisp=ptDisp+vz*dOffset;
//disp.draw("(this is only on for test)" + " " +sArPlateTagArt[nPlate],_Pt0,_XW,_YW,0,-3,_kDeviceX);
//create the compare Keys for the number sequence
String sCompareKey = strElCode+" "+strElNumber;
	
setCompareKey(sCompareKey);


//export dxa
Map itemMap= Map();
itemMap.setString("DESCRIPTION", "CORNER");
itemMap.setString("MATERIAL", sCorner);
ElemItem item(1, T("EXTRADATA"), el.ptOrg(), el.vecZ(), itemMap);
item.setShow(_kNo);
el.addTool(item);

disp.draw("Corner Type: "+sCorner, ptDisp, vx, -vz,1,-1);
ptDisp=ptDisp+vz*dOffset;

for (int i=0; i<sJunction.length(); i++)
{
	Map itemMap2= Map();
	itemMap2.setString("DESCRIPTION", "JUNCTION"+(i+1));
	itemMap2.setString("MATERIAL", sJunction[i]);
	ElemItem item2(1, T("EXTRADATA"), el.ptOrg(), el.vecZ(), itemMap2);
	item2.setShow(_kNo);
	el.addTool(item2);
	disp.draw("Junction: "+sJunction[i], ptDisp, vx, -vz,1,-1);
	ptDisp=ptDisp+vz*dOffset;
}

for (int i=0; i<sOPWidth.length(); i++)
{

	//export dxa
	Map itemMap= Map();
	itemMap.setString("DESCRIPTION", "OPWIDTH"+(i+1));
	itemMap.setString("MATERIAL", sOPWidth[i]);
	ElemItem item(1, T("EXTRADATA"), el.ptOrg(), el.vecZ(), itemMap);
	item.setShow(_kNo);
	el.addTool(item);
	disp.draw("Op Width: "+sOPWidth[i], ptDisp, vx, -vz,1,-1);
	ptDisp=ptDisp+vz*dOffset;
	
	itemMap= Map();
	itemMap.setString("DESCRIPTION", "OPHEIGHT"+(i+1));
	itemMap.setString("MATERIAL", sOPHeight[i]);
	ElemItem item2(1, T("EXTRADATA"), el.ptOrg(), el.vecZ(), itemMap);
	item2.setShow(_kNo);
	el.addTool(item2);
	disp.draw("Op Height: "+sOPHeight[i], ptDisp, vx, -vz,1,-1);
	ptDisp=ptDisp+vz*dOffset;
	
	itemMap= Map();
	itemMap.setString("DESCRIPTION", "OPSTART"+(i+1));
	itemMap.setString("MATERIAL", sOPStart[i]);
	ElemItem item3(1, T("EXTRADATA"), el.ptOrg(), el.vecZ(), itemMap);
	item3.setShow(_kNo);
	el.addTool(item3);
	disp.draw("Op Loc: "+sOPStart[i], ptDisp, vx, -vz,1,-1);
	ptDisp=ptDisp+vz*dOffset;
	
	itemMap= Map();
	itemMap.setString("DESCRIPTION", "OPLINTELDESC"+(i+1));
	itemMap.setString("MATERIAL", sOPLintelDesc[i]);
	ElemItem item4(1, T("EXTRADATA"), el.ptOrg(), el.vecZ(), itemMap);
	item4.setShow(_kNo);
	el.addTool(item4);
	disp.draw("Header Desc: "+sOPLintelDesc[i], ptDisp, vx, -vz,1,-1);
	ptDisp=ptDisp+vz*dOffset;
	
	itemMap= Map();
	itemMap.setString("DESCRIPTION", "OPHEADHEIGHT"+(i+1));
	itemMap.setString("MATERIAL", sOPHeadHeight[i]);
	ElemItem item5(1, T("EXTRADATA"), el.ptOrg(), el.vecZ(), itemMap);
	item5.setShow(_kNo);
	el.addTool(item5);
	disp.draw("Op Head H: "+sOPHeadHeight[i], ptDisp, vx, -vz,1,-1);
	ptDisp=ptDisp+vz*dOffset;
}

assignToElementGroup(el, TRUE, 0, 'E');





#End
#BeginThumbnail


#End
