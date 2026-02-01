#Version 8
#BeginDescription
Displays information of what was created for every TRUSS POINT LOAD at every floor level. This tsl will be automatically inserted by GE_TRUSS_POINTLOAD.
v1.4: 25.jul.2012: David Rueda (dr@hsb-cad.com)

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
//////////////////////////////////		COPYRIGHT				//////////////////////////////////  
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
*
* v1.4: 25.jul.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Thumbnail added
* v1.3: 15.feb.2012: David Rueda (dr@hsb-cad.com): 	
	- Version control
* v1.2: 07.nov.2011: David Rueda (dr@hsb-cad.com): 	Added arrow to display when is a connection at truss
* v1.1: 24.oct.2011: David Rueda (dr@hsb-cad.com): 	Added visualization for connection at trusses (when truss is present)
* v1.0: 09.oct.2011: David Rueda (dr@hsb-cad.com): 	Release

*/

PropInt nBeams(0,0,T("|Beams|"));
PropInt nFloorToFloorStraps(1,0,T("|Floor to floor straps|"));
PropDouble dFloorToFloorStrapLength(0,0,T("|Strap length|"));
String sNoYes[]={T("|No|"), T("|Yes|")};
PropString sFloorToFloorStrapForcedToCS16(0,sNoYes,T("|Strap forced to CS16|"));
PropString sHoldDown(1,"",T("|Hold down|"));
PropString sConnectionAtTruss(2,"",T("|Connection at truss|"));
PropInt nConnectionsAtTruss(2,0,T("|Number of metal parts for connection at truss|"));
PropString sDimstyle(3, _DimStyles,T("|Dimstyle|"));
PropInt nColor(3,2,T("|Color|"));

if(_bOnInsert){
	
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	_Pt0=getPoint();
	
//	_Element.append(getElement(T("|Select wall|")));
      _Entity.append(getEntity(T("|Select wall or truss|")));

	setCatalogFromPropValues(T("_LastInserted"));

	return;
}

if( _Entity.length()==0){
	eraseInstance();
	return;
}


ElementWall el;
TrussEntity tr;
int bWallFound=false;
int bTrussFound=false;

Entity ent=_Entity[0];
if(ent.bIsKindOf(ElementWall()))
{
	el = (ElementWall)_Entity[0];
	bWallFound=true;
}
else if(ent.bIsKindOf(TrussEntity()))
{
	tr=(TrussEntity)_Entity[0];
	bTrussFound=true;
}

if (bWallFound==false && bTrussFound==false)
{
	eraseInstance();
	return;
}
	
if (!el.bIsValid() && !tr.bIsValid())
{
	eraseInstance();
	return;
}

Display dp(nColor);
dp.dimStyle(sDimstyle);
dp.showInDispRep("Wall Layout Items");
	
if(bWallFound)
{
	setDependencyOnEntity(el);
	assignToElementGroup(el,TRUE,0,'E');
	
	if( nBeams==0 && nFloorToFloorStraps==0 && sHoldDown=="")
	{
		eraseInstance();
		return;
	}
	
	// Setting grippoint
	Point3d ptGrip=_Pt0-U(24)*_XW+U(24)*_YW;
	if(_PtG.length()==0)
	_PtG.append(ptGrip);
	_PtG[0]+=_ZW*_ZW.dotProduct(_Pt0-_PtG[0]);
	
	Vector3d vDir=_XW;
	if(_XW.dotProduct(_Pt0-_PtG[0])>0)vDir=-_XW;
	
	// Display line from _Pt0 to rectangle(s)
	Point3d ptRecSt=_PtG[0]-vDir*U(50,2);
	PLine plPointer;
	plPointer.addVertex(_PtG[0]);
	plPointer.addVertex(ptRecSt);
	plPointer.addVertex(_Pt0);
	dp.draw(plPointer);
	
	String sStudsText="";
	if(nBeams>0)
		sStudsText=nBeams + "STUDS";
	
	String sStrapsText="";
	if(nFloorToFloorStraps>0)
	{
		sStrapsText.formatUnit(dFloorToFloorStrapLength,2,0);
		if(sNoYes.find(sFloorToFloorStrapForcedToCS16,0)==0)
		{
			sStrapsText=" MSTA"+sStrapsText;
		}
		else
		{
			sStrapsText=" CS16-"+sStrapsText;
		}
		sStrapsText=nFloorToFloorStraps+sStrapsText;
	}
	
	String sHoldDownText="";
	sHoldDownText=sHoldDown;
	
	// Setting rectangle sizes (independent on dimstyle)
	double dTextHeight=dp.textHeightForStyle("A", sDimstyle);
	double dMargin=dTextHeight*.25;
	double dRectHeight=(dTextHeight+dMargin)*2;
	
	double dRectWidth=0;
	if(dRectWidth<dp.textLengthForStyle(sStudsText, sDimstyle))
		dRectWidth=dp.textLengthForStyle(sStudsText, sDimstyle);
	if(dRectWidth<dp.textLengthForStyle(sStrapsText, sDimstyle))
		dRectWidth=dp.textLengthForStyle(sStrapsText, sDimstyle);
	if(dRectWidth<dp.textLengthForStyle(sHoldDownText, sDimstyle))
		dRectWidth=dp.textLengthForStyle(sHoldDownText, sDimstyle);
	
	dRectWidth=dRectWidth+dMargin*2;
	
	
	Point3d ptLeftTopCorner=_PtG[0]+vDir*dRectWidth+_YW*dRectHeight*.5;
	Point3d ptRightBottomCorner=_PtG[0]-_YW*dRectHeight*.5;
	PLine plRectangle; plRectangle.createRectangle(LineSeg(ptLeftTopCorner,ptRightBottomCorner), _XW, _YW);
	dp.draw(plRectangle);
	
	LineSeg lnCenter(_PtG[0],_PtG[0]+vDir*dRectWidth);
	dp.draw(lnCenter); // Midline on rectangle
	
	
	Point3d ptTopRectangleCenter=_PtG[0]+vDir*dRectWidth*.5+_YW*(dRectHeight*.25);
	Point3d ptBottomRectangleCenter=_PtG[0]+vDir*dRectWidth*.5-_YW*(dRectHeight*.25);
	
	dp.draw(sStudsText,ptTopRectangleCenter,_XW,_YW,0,0);
	if(nFloorToFloorStraps>0)
		dp.draw(sStrapsText,ptBottomRectangleCenter,_XW,_YW,0,0);
	else if (sHoldDown!="")
		dp.draw(sHoldDownText,ptBottomRectangleCenter,_XW,_YW,0,0);
}

else if(bTrussFound)
{
	setDependencyOnEntity(tr);
	assignToGroups(tr);


	
	// Setting grippoint
	Point3d ptGrip=_Pt0-U(24)*_XW+U(24)*_YW;
	if(_PtG.length()==0)
	_PtG.append(ptGrip);
	_PtG[0]+=_ZW*_ZW.dotProduct(_Pt0-_PtG[0]);
	
	Vector3d vDir=_XW;
	if(_XW.dotProduct(_Pt0-_PtG[0])>0)vDir=-_XW;
	
	// Display line from _Pt0 to rectangle(s)
	Point3d ptRecSt=_PtG[0]-vDir*U(250,10);
	PLine plPointer;
	plPointer.addVertex(_PtG[0]);
	plPointer.addVertex(ptRecSt);
	plPointer.addVertex(_Pt0);
	dp.draw(plPointer);

	// Display arrow
	Vector3d vArrowX(_Pt0-ptRecSt);vArrowX.normalize();
	Vector3d vArrowY=vArrowX.rotateBy(90,_ZW);	
	double dArrowLength=U(115,4.5);
	double dArrowSide=U(36,1.5);
	PLine plArrow;
	Point3d ptTmp;
	ptTmp=_Pt0;
	plArrow.addVertex(ptTmp);
	ptTmp-=vArrowX*dArrowLength;
	ptTmp+=vArrowY*dArrowSide*.5;ptTmp.vis();
	plArrow.addVertex(ptTmp);
	ptTmp-=vArrowY*dArrowSide;
	plArrow.addVertex(ptTmp);
	plArrow.close();
	Hatch hSolid("Solid",U(1));
	dp.draw(PlaneProfile(plArrow),hSolid);	

	String sConnectorsText="";
	int nConns=nConnectionsAtTruss;
	sConnectorsText=nConns+" "+sConnectionAtTruss;

	double dRectWidth=0;
	dRectWidth=dp.textLengthForStyle(sConnectorsText, sDimstyle);
	dp.draw(sConnectorsText,_PtG[0]+vDir*dRectWidth*.6,_XW,_YW,0,0);	
}



#End
#BeginThumbnail
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
;`%%%%`!1110`4444`%%%%`!1110`4444`?_9
`

#End
