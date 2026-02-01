#Version 8
#BeginDescription
GE_HDWR_ANCHOR_J-BOLT
v1.2: 15.jun.2014: David Rueda (dr@hsb-cad.com)

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
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
v1.2: 15.jun.2014: David Rueda (dr@hsb-cad.com)
	- TSL can now be inserted by other hardware systems
v1.1: 27.nov.2012: David Rueda (dr@hsb-cad.com)
	- Version control (several enhancements, coordinated with Manish Patel and Marcelo Quevedo)
*v1.0: 14.nov.2012: David Rueda (dr@hsb-cad.com)
	- Release. Created as dummy only, insertion yet to be coded. Will be useful inserted from outside
*/
String sTypes[0], sSizes[0];
sTypes.append("1/2 J_Bolt");									sSizes.append("1/2");
sTypes.append("5/8 J_Bolt");									sSizes.append("5/8");
sTypes.append("7/8 J_Bolt");									sSizes.append("7/8");

PropString sType(0, sTypes, T("|Anchor type|"),2);

if (_bOnInsert){
	reportMessage("\n"+T("|Message from|")+" GE_HDWR_ANCHOR_J-BOLT: "+ T("|This TSL has not yet a manual insertion defined. It can be inserted only by other script. Instance will be erased|")+"\n");
	eraseInstance();	
}

Display dp(254);
Vector3d vx=-_ZW;
Vector3d vy=_XW;
Vector3d vz=vx.crossProduct(vy);

// Get info from map if present
if(_Map.hasString("ANCHORTYPE"))
{
	sType.set(sTypes[sSizes.find(_Map.getString("ANCHORTYPE"),0)]);
}
if(_Map.hasVector3d("vx"))
	vx=_Map.getVector3d("vx");
if(_Map.hasVector3d("vy"))
	vy=_Map.getVector3d("vy");
if(_Map.hasVector3d("vz"))
	vz=_Map.getVector3d("vz");
int bInsertedByDirective=_Map.getInt("InsertedByDirective");
if(bInsertedByDirective)
	sType.setReadOnly(true);
int bHideWasherAndNuts=_Map.getInt("HideWasherAndNuts");

int nType=sTypes.find(sType,0);

if(_Element.length()==1)
{
	Element el=_Element[0];
	setDependencyOnEntity(el);
	if(_bOnElementDeleted)
		eraseInstance();		
}

// Rod
double dLength=U(250,10);
double dExtension=U(50,2);
double dEmbedment=dLength-dExtension;
double dRadius=U(12,0.375/2);
Point3d ptStart=_Pt0-vx*dExtension;
Point3d ptEnd=_Pt0+vx*dEmbedment;
Body bdRod(ptStart,ptEnd,dRadius);

// J arm
double dJSide=dRadius*4;// twice diameter from one side of vertical edge of rod
Body bdJSIde(ptEnd-vy*dRadius, ptEnd+vy*dJSide, dRadius);
bdRod+=bdJSIde;

dp.draw(bdRod);

if(bHideWasherAndNuts)
	return;

// Nuts
double dNutSideLength=U(25, 1.062);
double dNutSideHeight=U(15, 0.625);;
Point3d ptAllNutsBasePoints[0]; // Insertion point for all nuts, aligned center in diameter, BASE or top according to extrusion vector
Point3d ptAllNutsExtrusionPoints[0]; // define the vector to extrude body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllRodsBasePoints
Point3d ptAllNutsDirectionPoints[0]; // define the vector to align body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllRodsBasePoints

// Square washers
Point3d ptAllSquareWashersBasePoints[0]; // Insertion point for all square washers, aligned center in diameter, BASE in vertical
Point3d ptAllSquareWashersExtrusionPoints[0]; // define the vector to extrude body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllSquareBlocksBasePoints
Point3d ptAllSquareWashersDirectionPoints[0]; // define the vector to align body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllSquareBlocksBasePoints
double dSquareWasherSideLength=U(75, 3);
double dSquareWasherSideHeight=U(15, 0.625);

// Set insertion points for nuts
// All types
Point3d ptNut=_Pt0-vx*dSquareWasherSideHeight;
ptAllNutsBasePoints.append(ptNut);
ptAllNutsExtrusionPoints.append(ptNut-vx);
ptAllNutsDirectionPoints.append(ptNut+vy);

// Set insertion points for square washers
// All types
ptAllSquareWashersBasePoints.append(_Pt0);
ptAllSquareWashersExtrusionPoints.append(_Pt0-vx);
ptAllSquareWashersDirectionPoints.append(_Pt0+vy);

// Draw nuts
for(int n=0;n<ptAllNutsBasePoints.length();n++)
{
	double dRadius= dNutSideLength*.5;
	double dAngle=60;
	Point3d ptBase=ptAllNutsBasePoints[n];
	Point3d ptExtrude=ptAllNutsExtrusionPoints[n];
	Point3d ptDirection= ptAllNutsDirectionPoints[n];
	Vector3d vExtrude(ptExtrude-ptBase);vExtrude.normalize();
	Vector3d vDirection(ptDirection-ptBase);vDirection.normalize();
	Vector3d vVertex= vExtrude.crossProduct(vDirection);

	PLine plEx;
	for(int s=0;s<6;s++)
	{
		Point3d pt=ptBase+vVertex*dRadius;
		plEx.addVertex(pt);
			vVertex=vVertex.rotateBy(60, _ZW);
		
	}
	plEx.close();
	Body bdNut ( plEx, vExtrude*dNutSideHeight, 1);
	dp.draw(bdNut);
}

//Draw square washers
for(int n=0;n<ptAllSquareWashersBasePoints.length();n++)
{
	Point3d ptBase=ptAllSquareWashersBasePoints[n];
	Point3d ptExtrude=ptAllSquareWashersExtrusionPoints[n];
	Point3d ptDirection= ptAllSquareWashersDirectionPoints[n];
	Vector3d vExtrude(ptExtrude-ptBase);vExtrude.normalize();
	Vector3d vDirection(ptDirection-ptBase);vDirection.normalize();
	Vector3d vVertex= vExtrude.crossProduct(vDirection);

	PLine plEx;
	Point3d pt=ptBase+vVertex*dSquareWasherSideLength*.5+vDirection*dSquareWasherSideLength*.5; pt.vis();
	plEx.addVertex(pt);
	pt-=vDirection*dSquareWasherSideLength; pt.vis();
	plEx.addVertex(pt);
	pt-=vVertex*dSquareWasherSideLength; pt.vis();
	plEx.addVertex(pt);
	pt+=vDirection*dSquareWasherSideLength; pt.vis();
	plEx.addVertex(pt);

	plEx.close();
	Body bdSquareWasher( plEx, vExtrude*dSquareWasherSideHeight, 1);
	dp.draw(bdSquareWasher);
}

return

#End
#BeginThumbnail
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
#/__9
`


#End
