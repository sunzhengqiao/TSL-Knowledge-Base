#Version 8
#BeginDescription
Displays SF style name and description IN MODEL SPACE
v1.4: 20.mar.2013: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
*  hsbSOFT 
*  UNITED STATES OF AMERICA
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
* v1.4: 20.mar.2013: David Rueda (dr@hsb-cad.com)
	- Added informative text when no stylename or description available
	- Added option to make it visible on top view only
* v1.3: 19.mar.2013: David Rueda (dr@hsb-cad.com)
	- Renamed from GE_PLOT_OPENING_TAG_MS to GE_OPENING_SHOW_TAG_MS
* v1.2: 17.apr.2012: David Rueda (dr@hsb-cad.com)
	- Property updated: "Exclude load bearing walls" to "Exclude non load bearing walls" 
	- Set dependency on Wall entity
	- Assigned to element group
	- Added display PLine (rectangle) (no/yes) (default value yes) and color for it (default value: magenta)
	- Added alignment (Horizontal/Free to rotate and relocate) (default value: horizontal)
* v1.1: 07.feb.2012: David Rueda (dr@hsb-cad.com)	
	- Enhanced, display will follow this priorities: 
		- Fisrt value: Stylename
		- if SF description is found, last value will be override
		- if Custom description is found, last value will be override
	- Default value for disp. rep. set to be empty (meanning will be Model Space)
* v1.0: 26.jan.2012: David Rueda (dr@hsb-cad.com)	
	- Release
*/

PropInt nColor( 0, 1, T("|Tag color|"));
String sDimStyles[0]; sDimStyles.append(_DimStyles);
PropString sDimStyle( 0, sDimStyles, T("|Dimstyle|"));
PropDouble dOffset( 0, 10, T("|Offset from wall outline|"));
String sNoYes[]=  {T("|No|"), T("|Yes|")};
PropString sShowOpPline( 1, sNoYes,T("|Show opening outline|"), 1); 
int nShowOpPline= sNoYes.find( sShowOpPline, 1);
PropString sFilterLoadBearings( 2, sNoYes,T("|Exclude non load bearing walls|"), 1);
int nFilterLoadBearings= sNoYes.find( sFilterLoadBearings, 1);
PropString sDisplayLine( 3, sNoYes,T("|Display line pointing to opening|"), 1);
int nDisplayLine= sNoYes.find( sDisplayLine, 1);
PropString sDisplayRectangle( 4, sNoYes,T("|Display PLine|"), 1);
int nDisplayRectangle= sNoYes.find( sDisplayRectangle, 1);
PropInt nPLineColor( 1, 6, T("|PLine color|"));
PropString sDisplayRep( 5, "", T("|Show in display representation|")+":"+T(" |Empty|")+"="+T("|MS|"));
sDisplayRep.setDescription(T("|If empty will be shown in model space|"));
String sAlignments[]=  {T("|Horizontal|"), T("|Free to rotate and relocate|")};
PropString sAlignment( 6, sAlignments,T("|Tag orientation|"), 0);
int nAlignment= sAlignments.find( sAlignment, 1);
PropString sTopViewOnly( 7, sNoYes,T("|Visible on top view only|"), 0); 
int nTopViewOnly= sNoYes.find( sTopViewOnly, 0);

//Wall Layout Items
if(_bOnInsert)
{
	if( insertCycleCount()>1 ){ 
		eraseInstance();
		return;
	}

	PrEntity ssE("\n"+T("|Select openings|"), Opening());
	
	if( ssE.go() )
	{
		_Entity.append(ssE.set());
	}

	if( _Entity.length() == 0)
	{
		eraseInstance();
		return;
	}
	
	showDialogOnce();

	for( int o=0; o< _Entity.length(); o++)
	{		
		OpeningSF opSf= (OpeningSF)_Entity[o];
		if( !opSf.bIsValid())
			continue;

		Element el= opSf.element();
		if( !el.bIsValid())
			continue;

		// Erasing all previous inserted tsl's by THIS tsl
		TslInst tsls[0];
		tsls.append( opSf.tslInstAttached());
		for( int t=0; t<tsls.length(); t++)
		{
			TslInst tsl= tsls[t];
			String sName= tsl.scriptName();
			if( sName == scriptName());
				tsl.dbErase();
		}
			
		TslInst tsl;
		String sScriptName = scriptName();
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Point3d lstPoints[0];
		Entity lstEnts[0]; 
		lstEnts.append(opSf);
		int lstPropInt[0];
		lstPropInt.append(nColor);
		lstPropInt.append(nPLineColor);
		double lstPropDouble[0];
		lstPropDouble.append(dOffset);
		String lstPropString[0];
		lstPropString.append(sDimStyle);
		lstPropString.append(sShowOpPline);
		lstPropString.append(sFilterLoadBearings);
		lstPropString.append(sDisplayLine);
		lstPropString.append(sDisplayRectangle);		
		lstPropString.append(sDisplayRep);
		lstPropString.append(sAlignment);
		
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString);
	}	
	
	eraseInstance();
	return;
}


Display dp(nColor);
dp.dimStyle( sDimStyle);
if( sDisplayRep!= "")
	dp.showInDispRep(sDisplayRep);

if( nTopViewOnly)
	dp.addViewDirection(_ZW);

OpeningSF opSf= (OpeningSF)_Entity[0];
if( !opSf.bIsValid())
{
	eraseInstance();
	return;
}
	
Element el= opSf.element();
if( !el.bIsValid())
{
	eraseInstance();
	return;
}

ElementWallSF elSf= (ElementWallSF) el;
	
if( nFilterLoadBearings)
	if( !elSf.loadBearing())
	{
		eraseInstance();
		return;
	}	

setDependencyOnEntity(opSf);
setDependencyOnEntity(el);
assignToElementGroup(el,1);

Point3d ptElOrg= el.coordSys().ptOrg();
Vector3d vx= el.vecX();
Vector3d vy= el.vecY();
Vector3d vz= el.vecZ();

double dOpW= opSf.width();
double dOpH= opSf.height();
double dOpD= el.dBeamWidth();
CoordSys csOp = opSf.coordSys();
Point3d ptOpOrg= csOp.ptOrg();
Vector3d vxOp = csOp.vecX();
Vector3d vyOp = csOp.vecY();
Vector3d vzOp = csOp.vecZ();

// With some openings, ptOrg is not the required. Get a correct value for it
Line lnX( ptOpOrg, vxOp);
PLine plOp= opSf.plShape();
Point3d ptAllOp[]= plOp.vertexPoints(1);
ptAllOp= lnX.projectPoints( ptAllOp);
ptAllOp= lnX.orderPoints( ptAllOp);
Point3d pt1= ptAllOp[0];
Point3d pt2= ptAllOp[ptAllOp.length()-1];
Point3d ptMid= pt1+ vxOp*(abs(vxOp.dotProduct(pt2-pt1))*.5);

// Display opening outline
Point3d ptVertex;
PLine plOpOutline;
Point3d ptMidAlignedToElPtOrg= ptMid + vz* vz.dotProduct( ptElOrg- ptMid);
ptVertex= ptMidAlignedToElPtOrg;
ptVertex-= vxOp* dOpW*.5;
plOpOutline.addVertex( ptVertex);
ptVertex+= vxOp* dOpW;
plOpOutline.addVertex( ptVertex);
ptVertex-= vz* dOpD;
plOpOutline.addVertex( ptVertex);
ptVertex-= vxOp* dOpW;
plOpOutline.addVertex( ptVertex);
ptVertex+= vz* dOpD;
plOpOutline.addVertex( ptVertex);
if( nShowOpPline)
	dp.draw( plOpOutline);

// Display text
String sDisplay; // To show

String sStyleName= opSf.styleNameSF();
sDisplay = sStyleName;

String sDescriptionSF= opSf.openingDescr();
if(sDescriptionSF != "")
{
	sDisplay= sDescriptionSF;
} 
String sDescription= opSf.description();
if(sDescription != "")
{
	sDisplay= sDescription;
} 

sDisplay= sDisplay.trimLeft();
sDisplay= sDisplay.trimRight();

if(sDisplay=="")
	sDisplay=T("|No stylename or description available|");
Point3d pts[]= plOpOutline.vertexPoints(1);
_Pt0.setToAverage( pts);

Point3d ptStart= _Pt0- vx*dOpW*.5- vz* dOffset;
if( _PtG.length() == 0)
	_PtG.append(ptStart);
Point3d ptEnd= _Pt0+ vx*dOpW*.5- vz* dOffset;
if( _PtG.length() == 1)
	_PtG.append(ptEnd);

Vector3d vDir= _PtG[1]- _PtG[0];
vDir.normalize();
Point3d ptCen= _PtG[0] + vDir* dOpW*.5;
_PtG[0]= ptCen - vDir* dOpW*.5;
_PtG[1]= ptCen + vDir* dOpW*.5;
Point3d ptDisplayText= _PtG[1]- vDir* dOpW*.5;

Vector3d vReadX, vReadY;

if( nAlignment == 0 ) // Horizontal
{
	vReadX=_XW;
	vReadY=_YW;
	_PtG[1]=_PtG[0];//=ptCen;
}
else // Aligned to opening
{
	if( vDir.dotProduct( _XW)< 0)
	{
		vReadX=-vDir;
	}
	if( vDir.dotProduct( _XW)>= 0)
	{
		vReadX= vDir;
	}
	if( vDir.dotProduct( _XW)== 0)
	{
		vReadX=_YW;
	}
	
	vReadY= vReadX;
	vReadY= vReadY.rotateBy(90, _ZW);
	if( vReadY.dotProduct( _YW)<=0)
		vReadY= -vReadY;
}
	
dp.draw( sDisplay, ptDisplayText, vReadX, vReadY, 0, 0);

// Display pointing line
if( nDisplayLine)
{
	Vector3d vDir2=vReadY;
	if( vDir2.dotProduct(Vector3d(ptCen- _Pt0))> 0)
		vDir2= -vDir2;
	
	PLine plLine( ptCen+ vDir2* dp.textHeightForStyle( "A", sDimStyle) *.7 , _Pt0);
	dp.draw( plLine);
}

// Display rectangle (PLine)
if( nDisplayRectangle)
{
	double dRecW= dp.textLengthForStyle("AA"+sDisplay, sDimStyle);
	double dRecH= dp.textHeightForStyle("A", sDimStyle)*2;
	Point3d ptBottomLeft= ptDisplayText- vReadX*dRecW*.5-vReadY*dRecH*.5;
	Point3d ptTopRight= ptDisplayText+ vReadX*dRecW*.5+vReadY*dRecH*.5;
	PLine plRec; plRec.createRectangle( LineSeg(ptBottomLeft, ptTopRight), vReadX, vReadY);
	dp.color( nPLineColor);
	dp.draw( plRec);
}

#End
#BeginThumbnail
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
7`"BBB@`HHHH`****`"BBB@`HHHH`_]FB
`

#End
