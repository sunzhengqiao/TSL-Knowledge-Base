#Version 8
#BeginDescription
v1.1: 04.jul.2014: David Rueda (dr@hsb-cad.com)
MAS Anchor Family (Simspon's MASA equivalent). Applies to selected wall(s)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords Wall;TieRod;Hardware;Anchor
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
*
*v1.1: 04.jul.2014: David Rueda (dr@hsb-cad.com)
	- Bug fix: Entity (ies) not associated properly, causing unexpected behavior when framing. Edited GE_HDWR_ANCHOR_MAS and GE_HDWR_WALL_ANCHOR_MULTIPLE. Problem Solved. 
	- Added feature: when wall is unframed MAS TSL's are still present, but display only a cross at bottom of wall so user will know this element has already anchors. 
	  When wall is framed, the display of metal part is completely done, wrapping bottom plate(s) and embedded also.
	- Added feature: MAS TSL will erase itself if is closer than 2in to other MAS
*v1.0: 17.jun.2014: David Rueda (dr@hsb-cad.com)
	- Release
*/
U(1, "inch");
double dMinDist=U(2);
if(_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}
	Element el=getElement(T("|Select element|"));
	if(!el.bIsKindOf(Wall()))
	{
		eraseInstance();
		return;
	}
	
	Point3d ptSelected[0];
	while(1)
	{
		PrPoint ssE2("\nSelect a set of points along wall (points will get proper high automatically. Wall side will be the closer to selected points)");
		if (ssE2.go() == _kOk)
		{
			ptSelected.append(ssE2.value());
		}
		else{
			break;
		}
	}

	//////////////////////////////////		Clonning tsl's				//////////////////////////////////
	String sChildTSL= scriptName();
	TslInst tsl;
	String sScriptName = sChildTSL;
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Beam lstBeams[0];
	Entity lstEnts[0];
		lstEnts.append(el);
	Point3d lstPoints[1];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map map;	
		map.setInt("ExecutionMode",0);

	for(int p=0;p<ptSelected.length();p++)
	{
		lstPoints[0]=ptSelected[p];
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,true,map); 
	}

	eraseInstance();
	return;
}

// Get element and its info
if( _Element.length()==0){
	eraseInstance();
	return;
}

ElementWall el = (ElementWall) _Element[0];

if (!el.bIsValid())
{
	eraseInstance();
	return;
}

setDependencyOnEntity(el);
assignToElementGroup(el);

if(!_Map.getInt("ExecutionMode") || _bOnElementConstructed || _bOnRecalc )
{
	_Beam= el.beam();
	_Map.setInt("ExecutionMode",1);
}

Point3d ptElOrg= el.ptOrg();
Vector3d vx = el.vecX();
Vector3d vy = el.vecY();
Vector3d vz = el.vecZ();

PlaneProfile ppEl(el.plOutlineWall());
LineSeg ls=ppEl.extentInDir(vx);
double dElLength=abs(vx.dotProduct(ls.ptStart()-ls.ptEnd()));

ls=ppEl.extentInDir(vz);
ElemZone elzStart= el.zone(-10);
ElemZone elzEnd= el.zone(10);
double dElWidth=abs(vz.dotProduct(elzStart.coordSys().ptOrg()-elzEnd.coordSys().ptOrg()));

double dElHeight= ((Wall)el).baseHeight();
Point3d ptElStart= ptElOrg;
Point3d ptElEnd= ptElOrg+vx*dElLength;
Point3d ptElCenter= ptElOrg+vx*dElLength*.5-vz*dElWidth*.5;	
Point3d ptElBack= el.ptOrg()-vz*dElWidth;

Beam bmAll[0]; 
	bmAll=_Beam;
	
Beam bmHorizontals[]=vx.filterBeamsParallel(bmAll);
Beam bmBottomPlates[0];
for( int b=0; b<bmHorizontals.length(); b++)
{
	Beam bm=	bmHorizontals[b];
	if(bm.type()== _kBottom || bm.type()== _kSFBottomPlate || bm.type()== _kSFVeryBottomPlate)
	{
		bmBottomPlates.append(bm);
	}
}

// Realign _Pt0
_Pt0+=vy*vy.dotProduct(ptElOrg-_Pt0);
if(abs(vz.dotProduct(ptElBack-_Pt0))<abs(vz.dotProduct(ptElCenter-_Pt0)))
	_Pt0+=vz*vz.dotProduct(ptElBack-_Pt0);
else
	_Pt0+=vz*vz.dotProduct(ptElStart-_Pt0);
	
Display dp(-1);
if(bmAll.length()==0) // Temporary cross display
{
	double dc=U(2);
	Vector3d vxd=_XW;
	Vector3d vyd=_YW;
	PLine pl;
	Point3d ptStart=_Pt0;
	Point3d pt=ptStart;
	pl.addVertex(pt);
	pt=ptStart+vxd*dc*.5;
	pl.addVertex(pt);
	pt=ptStart-vxd*dc*.5;
	pl.addVertex(pt);
	pt=ptStart;
	pl.addVertex(pt);
	pt=ptStart+vyd*dc*.5;
	pl.addVertex(pt);
	pt=ptStart-vyd*dc*.5;
	pl.addVertex(pt);
	dp.draw(pl);
	return;
}

bmBottomPlates=vy.filterBeamsPerpendicularSort(bmBottomPlates);
Beam bmHighestBottomPlate=bmBottomPlates[bmBottomPlates.length()-1];
Point3d ptTopOfBottomPlates=bmHighestBottomPlate.ptCen()+vy*bmHighestBottomPlate.dD(vy)*.5;
Beam bmLowestBottomPlate=bmBottomPlates[0];
Point3d ptBottomOfBottomPlates=bmLowestBottomPlate.ptCen()-vy*bmLowestBottomPlate.dD(vy)*.5;

// Checking if this TSL will be too close to other of its kind
TslInst tsls[]=el.tslInstAttached();
for( int t=0; t<tsls.length(); t++)
{
	TslInst tsl= tsls[t];

	// Erase all previous versions of this TSL
	if ( tsl.scriptName() == scriptName() && tsl.handle()!= _ThisInst.handle() && abs(vx.dotProduct(tsl.ptOrg()-_Pt0))<=dMinDist )
	{
		eraseInstance();
		return
	}		
}

// Display
double dBottomPlateBracesLength=U(10), dBottomPlateSingleBraceWidth=U(1), dSeparationBetweenBottomPlateBraces=U(.25), dThickness=U(0.125);
double dEmbeddedLength=U(6), dEmbeddedWidth=dBottomPlateSingleBraceWidth*2+dSeparationBetweenBottomPlateBraces;
Vector3d vx1,vy1,vz1; //vx1=length, vy1=width, vz1=thickness
Vector3d vWrapDirection=-vz;
if(vz.dotProduct(_Pt0-ptElCenter)<0)
	vWrapDirection=-vWrapDirection;

// Draw embedded part
double dAngle=45;
vx1=-vWrapDirection;
vx1=vx1.rotateBy(-dAngle,vx);
if(_ZW.dotProduct(vx1)>0)
{
	vx1=-vWrapDirection;
	vx1=vx1.rotateBy(dAngle,vx);
}

vy1=vx;
vz1=vx1.crossProduct(vy1);
if(_ZW.dotProduct(vz1)<0)
	vz1=-vz1;

PLine plLeftEmbedded;
Point3d pt=_Pt0-vy*dThickness;
pt+=vy1*dEmbeddedWidth*.5;
plLeftEmbedded.addVertex(pt);
pt+=vx1*dEmbeddedLength*.25;
plLeftEmbedded.addVertex(pt);
pt+=-vy1*dEmbeddedWidth*.15;
plLeftEmbedded.addVertex(pt);
pt+=vx1*dEmbeddedLength*.20-vy1*dEmbeddedWidth*.1;
plLeftEmbedded.addVertex(pt);
pt+=vx1*dEmbeddedLength*.20+vy1*dEmbeddedWidth*.1;
plLeftEmbedded.addVertex(pt);
pt+=vx1*dEmbeddedLength*.40;
plLeftEmbedded.addVertex(pt);

PLine plEmbedded;
pt=_Pt0-vy*dThickness;
pt+=-vy1*dEmbeddedWidth*.5;
plEmbedded.addVertex(pt);
pt+=vx1*dEmbeddedLength*.25;
plEmbedded.addVertex(pt);
pt+=+vy1*dEmbeddedWidth*.15;
plEmbedded.addVertex(pt);
pt+=vx1*dEmbeddedLength*.20+vy1*dEmbeddedWidth*.1;
plEmbedded.addVertex(pt);
pt+=vx1*dEmbeddedLength*.20-vy1*dEmbeddedWidth*.1;
plEmbedded.addVertex(pt);
pt+=vx1*dEmbeddedLength*.40;
plEmbedded.addVertex(pt);

Point3d ptLeftEmbeddeds[]=plLeftEmbedded.vertexPoints(1);
for(int p=ptLeftEmbeddeds.length()-1;p>=0;p--)
{
	plEmbedded.addVertex(ptLeftEmbeddeds[p]);
}

Body bdEmbedded(plEmbedded,vy*dThickness,1);
dp.draw(bdEmbedded);

// Draw bottom plate's wrap
double dLengthToDraw, dLengthLeft;

// bottom face of bottom plate wrap
vx1=vWrapDirection;
vz1=-vy;
vy1=vz1.crossProduct(vx1);vy1.normalize();

dLengthLeft=dBottomPlateBracesLength;
dLengthToDraw=bmLowestBottomPlate.dD(vx1);

if(dLengthLeft>=dLengthToDraw)
{
	dLengthLeft=dLengthLeft-dLengthToDraw;
}
else
{
	dLengthToDraw=dLengthLeft;
	dLengthLeft=0;
}

PLine plBottomWrap;
pt=_Pt0;
pt+=vy1*dSeparationBetweenBottomPlateBraces*.5;
plBottomWrap.addVertex(pt);
pt+=vy1*dBottomPlateSingleBraceWidth;
plBottomWrap.addVertex(pt);
pt+=vx1*(dLengthToDraw+dThickness);
plBottomWrap.addVertex(pt);
pt+=-vy1*dBottomPlateSingleBraceWidth;
plBottomWrap.addVertex(pt);
pt+=-vx1*(dLengthToDraw+dThickness);
plBottomWrap.addVertex(pt);
plBottomWrap.close();
Body bdBottomWrap(plBottomWrap,vz1*dThickness,1);
dp.draw(bdBottomWrap);

bdBottomWrap.transformBy(-vy1*(dThickness+dBottomPlateSingleBraceWidth+dSeparationBetweenBottomPlateBraces*.5));
dp.draw(bdBottomWrap);

// Vertical face of bottom plate wrap
if(dLengthLeft<=0)
	return;

vx1=vy;
vz1=vWrapDirection;
vy1=vz1.crossProduct(vx1);vy1.normalize();

dLengthToDraw=vx1.dotProduct(ptTopOfBottomPlates-ptBottomOfBottomPlates);
if(dLengthLeft>=dLengthToDraw)
{
	dLengthLeft=dLengthLeft-dLengthToDraw;
}
else
{
	dLengthToDraw=dLengthLeft;
	dLengthLeft=0;
}

PLine plVerticalWrap;
pt=_Pt0;
pt+=vy1*dSeparationBetweenBottomPlateBraces*.5+vz1*(bmLowestBottomPlate.dD(vz1));

plVerticalWrap.addVertex(pt);
pt+=vx1*(dLengthToDraw+dThickness);
plVerticalWrap.addVertex(pt);
pt+=vy1*dBottomPlateSingleBraceWidth;
plVerticalWrap.addVertex(pt);
pt+=-vx1*(dLengthToDraw+dThickness);
plVerticalWrap.addVertex(pt);
plVerticalWrap.close();
Body bdVerticalWrap(plVerticalWrap,vz1*dThickness,1);
dp.draw(bdVerticalWrap);

bdVerticalWrap.transformBy(-vy1*(dThickness+dBottomPlateSingleBraceWidth+dSeparationBetweenBottomPlateBraces*.5));
dp.draw(bdVerticalWrap);

// top face of bottom plate wrap
if(dLengthLeft<=0)
	return;

vx1=-vWrapDirection;
vz1=vy;
vy1=vz1.crossProduct(vx1);vy1.normalize();

dLengthToDraw=bmLowestBottomPlate.dD(vx1);
if(dLengthLeft>=dLengthToDraw)
{
	dLengthLeft=dLengthLeft-dLengthToDraw;
}
else
{
	dLengthToDraw=dLengthLeft;
	dLengthLeft=0;
}

PLine plTopWrap;
pt=_Pt0;
pt+=-vx1*bmLowestBottomPlate.dD(vx1)+vy1*dSeparationBetweenBottomPlateBraces*.5+vz1*vz1.dotProduct(ptTopOfBottomPlates-ptBottomOfBottomPlates);
plTopWrap.addVertex(pt);
pt+=vx1*dLengthToDraw;
plTopWrap.addVertex(pt);
pt+=vy1*dBottomPlateSingleBraceWidth;
plTopWrap.addVertex(pt);
pt+=-vx1*dLengthToDraw;
plTopWrap.addVertex(pt);
plTopWrap.close();
Body bdTopWrap(plTopWrap,vz1*dThickness,1);
dp.draw(bdTopWrap);

bdTopWrap.transformBy(-vy1*(dThickness+dBottomPlateSingleBraceWidth+dSeparationBetweenBottomPlateBraces*.5));
dp.draw(bdTopWrap);
#End
#BeginThumbnail
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
*BBB@`HHHH`__V2B@
`

#End
