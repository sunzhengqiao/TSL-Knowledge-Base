#Version 8
#BeginDescription
v1.0: 11.oct.2013: David Rueda (dr@hsb-cad.com)
Copies and locks framing from one wall to selected other(s) that match size, shape and openings (count, size and position)
NOTICE: This TSL will create an instance of GE_WALL_FRAMING_LOCK TSL, therefore it must be in the drawing also.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/*
  COPYRIGHT
  ---------------
  Copyright (C) 2011 by
  hsbSOFT 

  The program may be used and/or copied only with the written
  permission from hsbSOFT, or in accordance with
  the terms and conditions stipulated in the agreement/contract
  under which the program has been supplied.

  All rights reserved.

 REVISION HISTORY
 -------------------------
 v1.0: 11.oct.2013: David Rueda (dr@hsb-cad.com)
	- Release
*/

U(1, "inch"); // Script uses inches
double dTolerance=U(.1);
double dr=100;

// Color dropdown
String sColors[0]; int nColors[0];
sColors.append(T("|No color|")+" ("+"32)");						nColors.append(-1);
sColors.append(T("|Dark Brown|")+" ("+"32)");					nColors.append(32);
sColors.append(T("|Light Brown|")+" ("+"40)");					nColors.append(40);
sColors.append(T("|White|"));										nColors.append(0);
sColors.append(T("|Red|"));										nColors.append(1);
sColors.append(T("|Yellow|"));									nColors.append(2);
sColors.append(T("|Green|"));										nColors.append(3);
sColors.append(T("|Cyan|"));										nColors.append(4);
sColors.append(T("|Blue|"));										nColors.append(5);
sColors.append(T("|Magenta|"));									nColors.append(6);
sColors.append(T("|Black|"));										nColors.append(7);
PropString sColor(0, sColors, T("|New color for framing|"), 0);
int nIndex= sColors.find(sColor, 0);
int nColor= nColors[nIndex];

// Restrict color index
if (nColor > 255 || nColor < -1) 
	sColor.set(sColors[0]);

if(_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}
	
	Element elOriginal=getElement("\n"+T("|Select wall to copy FROM|"));
	_Element.append(elOriginal);
	_Map.setEntity("elOriginal",elOriginal);
	PrEntity ssE("\n"+T("|Select element(s) to apply copy|"),Element());	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}

	_Map.setInt("ExecutionMode",0);

	return;
}

// Get element and its info
if( _Element.length()<2){
	eraseInstance();
	return;
}

Entity ent=_Map.getEntity("elOriginal");
ElementWall el = (ElementWall)ent;
if (!el.bIsValid())
{
	eraseInstance();
	return;
}

Point3d ptElOrg= el.ptOrg();
CoordSys csEl=el.coordSys();
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

Beam bmAll[]=el.beam();
Sheet shAll[]=el.sheet();
if(bmAll.length()==0&&shAll.length()==0)
{
	reportMessage("\n"+T("|Message from|")+" "+scriptName()+" TSL: "+T("|Wall|")+" "+el.number()+" "+ T("|must be framed prior this operation.|"));
	eraseInstance();
	return;
}

PLine plEl=el.plEnvelope();
int nElPoints=plEl.vertexPoints(true).length();
 
int nC=3; // Debug only
for(int e=0;e<_Element.length();e++)
{
	Opening opEl[]=el.opening();
	int nElOps=opEl.length();

	if( !_Element[e].bIsValid())
		continue;
		
	Element elCC=_Element[e];
	if(el==elCC)
		continue;
		
	CoordSys csElCC=elCC.coordSys();
	Point3d ptElOrgCC= elCC.ptOrg();
	Vector3d vxCC= elCC.vecX();
	Vector3d vyCC= elCC.vecY();
	Vector3d vzCC= elCC.vecZ();
	
	PlaneProfile ppElCC(elCC.plOutlineWall());
	LineSeg lsCC=ppElCC.extentInDir(vxCC);
	double dElLengthCC=abs(vxCC.dotProduct(lsCC.ptStart()-lsCC.ptEnd()));
	
	ElemZone elzStartCC= elCC.zone(-10);
	ElemZone elzEndCC= elCC.zone(10);
	double dElWidthCC=abs(vzCC.dotProduct(elzStartCC.coordSys().ptOrg()-elzEndCC.coordSys().ptOrg()));
	
	double dElHeightCC= ((Wall)elCC).baseHeight();
	Point3d ptElStartCC= ptElOrgCC;
	Point3d ptElEndCC= ptElOrgCC+vxCC*dElLengthCC;
	Point3d ptElCenterCC= ptElOrgCC+vxCC*dElLengthCC*.5-vzCC*dElWidthCC*.5;	
	Point3d ptElBackCC= elCC.ptOrg()-vzCC*dElWidthCC;
	
	String sMessage="\nCopy to wall "+elCC.code()+"-"+elCC.number()+": ";

	// Define if wall has same sizes
	if( abs(dElLength-dElLengthCC)>dTolerance || abs(dElWidth-dElWidthCC)>dTolerance || abs(dElHeight-dElHeightCC)>dTolerance )
	{
		sMessage+=T("|Failed|"+" - ");
		reportMessage(sMessage+T("|Size mismatch|"));
		continue;
	}

	// Define if wall has same shape
	if(nElPoints!=elCC.plEnvelope().vertexPoints(true).length())
	{
		sMessage+=T("|Failed|"+" - ");
		reportMessage(sMessage+T("|Shape mismatch|"));
		continue;
	}

	// Define if wall has same number of openings
	Opening opElCC[]=elCC.opening();
	if(nElOps!=opElCC.length())
	{
		sMessage+=T("|Failed|"+" - ");
		reportMessage(sMessage+T("|Opening count mismatch|"));
		continue;
	}

	// Debug only
	plEl=el.plEnvelope();plEl.transformBy(vy*dr);plEl.vis();for(int i=0;i<opEl.length();i++){PLine plOpi=opEl[i].plShape();plOpi.transformBy(vy*dr);plOpi.vis(26);}plEl=el.plEnvelope();plEl.transformBy(vy*dr);plEl.vis(nC);PLine plElCC=elCC.plEnvelope();plElCC.transformBy(vy*dr);plElCC.vis();

	// Define if wall has same openings
	int nAllOpeningsMatch=false;
	for(int i=0;i<opEl.length();i++)
	{
		Opening opi=opEl[i];		
		double dWi=opi.width(), dHi=opi.height();		
		int nOpiVx=opi.plShape().vertexPoints(true).length();		
		Point3d ptOpiCen=opi.coordSys().ptOrg();		
		double dOpiPosX=vx.dotProduct(ptOpiCen-ptElOrg);		
		double dOpiPosY=vy.dotProduct(ptOpiCen-ptElOrg);
		PLine plOpi=opi.plShape();plOpi.transformBy(vy*dr);plOpi.vis();ptOpiCen.transformBy(vy*dr);ptOpiCen.vis(); // Debug only
		for(int j=0;j<opElCC.length();j++)
		{
			Opening opj=opElCC[j];			
			double dWj=opj.width(), dHj=opj.height();			
			int nOpjVx=opj.plShape().vertexPoints(true).length();			
			Point3d ptOpjCen=opj.coordSys().ptOrg();			
			double dOpjPosX=vxCC.dotProduct(ptOpjCen-ptElOrgCC);			
			double dOpjPosY=vyCC.dotProduct(ptOpjCen-ptElOrgCC);
			PLine plOpj=opj.plShape();plOpj.transformBy(vy*dr);plOpj.vis();ptOpjCen.transformBy(vy*dr);ptOpjCen.vis(); // Debug only
			if(dWi==dWj&&dHi==dHj&&nOpiVx==nOpjVx&&abs(dOpiPosX-dOpjPosX)<dTolerance)
			{	
				plOpi.vis(nC);plOpj.vis(nC);				
				opEl.removeAt(i);				
				opElCC.removeAt(j);				
				i=j=-1;				
				break;
			}
		}
	}
	if(opEl.length()==0)
		nAllOpeningsMatch=true;
	else plElCC.vis(1); // Debug only
		
	if(!nAllOpeningsMatch)
	{
		sMessage+=T("|Failed|"+" - ");
		reportMessage(sMessage+T("|Opening mismatch|"));
		continue;
	}
	else plElCC.vis(nC);nC++;  // Debug only

	// Clean all framing on copy
	Beam bmAllCC[] = elCC.beam();
	for(int b=0;b<bmAllCC.length();b++)
		bmAllCC[b].dbErase();
	
	Sheet shAllCC[]=elCC.sheet();
	for(int s=0;s<shAllCC.length();s++)
		shAllCC[s].dbErase();
		
	// Copying and relocating framing
	Vector3d vTranslation(ptElOrgCC-ptElOrg);
	double dAngleToRotate=vx.angleTo(vxCC,_ZW);
	CoordSys csRotation=csElCC; csRotation.setToRotation(dAngleToRotate,_ZW,ptElOrg);

	for(int b=0;b<bmAll.length();b++)
	{

		Beam bm=bmAll[b];
		Beam bmNew; bmNew=bm.dbCopy();
		bmNew.setPanhand(elCC);
		bmNew.assignToElementGroup(elCC,true);
		bmNew.transformBy(csRotation);
		bmNew.transformBy(vTranslation);
	}
	for(int s=0;s<shAll.length();s++)
	{
		Sheet sh=shAll[s];
		Sheet shNew; shNew=sh.dbCopy();
		shNew.setPanhand(elCC);
		shNew.assignToElementGroup(elCC,true);
		shNew.transformBy(csRotation);
		shNew.transformBy(vTranslation);
	}
	
	// Clone framing lock TSL	
	String sChildTSL="GE_WALL_FRAMING_LOCK";
	TslInst tsl;
	String sScriptName = sChildTSL;
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Beam lstBeams[0];
	Entity lstEnts[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	
	lstEnts.append(elCC);
	tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );
	
	sMessage+=T("|Success|");
	reportMessage(sMessage);
}

// Debug only
	_Pt0=ptElOrg;
	Display dpd(-1);
	double dc=U(50,2);
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
	dpd.draw(pl);
// Debug only

eraseInstance();
return;
#End
#BeginThumbnail

#End
