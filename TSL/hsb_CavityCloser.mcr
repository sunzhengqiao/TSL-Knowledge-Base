#Version 8
#BeginDescription
Calculate the cavity closer base on the height of the openings or the width of the doors and export an ElemItem with the information to the dBase.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 01.09.2010 - version 1.1

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

PropString sTimberWidth(0, "38", T("Timber Width"));
PropString sTimberHeight(1, "50 Sawn", T("Timber Height"));
PropString sTimberLength (2, "4800", T("Timber Length"));


PropString sDimStyle (3,_DimStyles,T("DimStyle"));
PropString sDispRep (4,"",T("Show In Display Rep"));

PropInt nColor (0,171,T("Set the Text Color"));
PropDouble dOffset (1, U(100), T("Offset Between Lines"));

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
	lstPropString.append(sTimberWidth);
	lstPropString.append(sTimberHeight);
	lstPropString.append(sTimberLength );
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

double dCavityCloserLength=0;

Opening opAll[]=el.opening();
if (opAll.length()<1)
{
	eraseInstance();
	return;
}


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
	
	if (op.openingType()==_kDoor)
	{
		dCavityCloserLength=dCavityCloserLength+(op.width()*1.15);
	}
	else
	{
		dCavityCloserLength=dCavityCloserLength+((op.height()*2)*1.15);
	}
}

String sLength;
sLength.formatUnit(dCavityCloserLength,2,2);

Map itemMap1= Map();
itemMap1.setString("LENGTH", sTimberLength );
itemMap1.setString("THICKNESS", sTimberHeight);
itemMap1.setString("WIDTH", sTimberWidth);
//itemMap1.setString("MATERIAL",bm.material());
//itemMap1.setString("ARTICLENUMBER",bm.posnum());
//itemMap1.setString("LABEL",sCompareKey);
//itemMap1.setString("DIAMETER", sCutN);
itemMap1.setString("DESCRIPTION",sLength);
ElemItem item1(1, T("CAVITYCLOSER"), el.ptOrg(), el.vecZ(), itemMap1);
item1.setShow(_kNo);
el.addTool(item1);

Display disp(-1);
disp.draw("Test", _Pt0, vx, -vz,1,-1);

assignToElementGroup(el, TRUE, 0, 'E');



#End
#BeginThumbnail


#End
