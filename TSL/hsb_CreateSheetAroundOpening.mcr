#Version 8
#BeginDescription
#Versions:
1.5 22.06.2023 HSB-18953: swap name and material it was other way around 
1.4 02.09.2022 HSB-16394: add property to define whether sidegape will be applied at opening or not 
1.3 24.06.2022 HSB-15357: add properties to controll sides and top, bottom 
Modified by: Alberto Jena (aj@hsb-cad.com)
21.09.2011  -  version 1.2




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords sheet,opening,greencore
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
* #Versions:
// 1.5 22.06.2023 HSB-18953: swap name and material it was other way around Author: Marsel Nakuci
// 1.4 02.09.2022 HSB-16394: add property to define whether sidegape will be applied at opening or not Author: Marsel Nakuci
// 1.3 24.06.2022 HSB-15357: add properties to controll sides and top, bottom Author: Marsel Nakuci
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 20.09.2011
* version 1.1: Release Version
* 
* date: 21.09.2011
* version 1.2: BugFix with the orientation of the sheet
*/

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                      Properties

//String arSCodeExternalWalls[] = { "A", "B", "H", "I"}; //Add more External Walls codes as you request

U(1,"mm");
double dEps =U(.1);
String category = T("|General|");
String sArNY[] = {T("No"), T("Yes")};

PropString psExtType(0, "A;B;",  T("Wall Code"));

PropDouble dThick (0, U(9), T("Sheet Thickness"));

PropString sName (1, "OSB", T("Sheet Name"));
PropString sMaterial (2, "OSB", T("Sheet Material"));

int nValidZones[]={0,1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={0,1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZones(0, nValidZones, T("Attach Sheet to Zone"));


// 
category = T("|Sides|");
String sTopName=T("|Top|");	
PropString sTop(3, sArNY, sTopName);	
sTop.setDescription(T("|Defines whether sheeting will be placed at top side|"));
sTop.setCategory(category);

String sBottomName=T("|Bottom|");	
PropString sBottom(4, sArNY, sBottomName);	
sBottom.setDescription(T("|Defines whether sheeting will be placed at bottom side|"));
sBottom.setCategory(category);

String sSidesName=T("|Vertikal|");	
PropString sSides(5, sArNY, sSidesName);	
sSides.setDescription(T("|Defines whether sheeting will be placed on vertical sides|"));
sSides.setCategory(category);
// HSB-16394:
category=T("|Side gap|");
String sGapSideName=T("|Gap|");	
PropString sGapSide(6, sArNY, sGapSideName,1);
sGapSide.setDescription(T("|Defines whether the GapSide will be applied or not|"));
sGapSide.setCategory(category);


//PropString sShowNailPlate(12, sArNY, T("Insert Nail Plates"));
//sShowNailPlate.setDescription("");
//int bShowNailPlate = sArNY.find(sShowNailPlate,0);


//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                           Insert

_ThisInst.setSequenceNumber(20);

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
	
	return;
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

int nZone=nRealZones[nValidZones.find(nZones, 0)];

if( _Element.length()==0 ){
	eraseInstance();
	return;
}

//Fill and array with the code of the firewalls

String sArrExtCode[0];
String sExtType=psExtType;
sExtType.trimLeft();
sExtType.trimRight();
sExtType=sExtType+";";
for (int i=0; i<sExtType.length(); i++)
{
	String str=sExtType.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
		sArrExtCode.append(str);
}

//-----------------------------------------------------------------------------------------------------------------------------------
//          Loop over all elements.

ElementWallSF elWall[0];

for( int e=0; e<_Element.length(); e++ )
{
	ElementWallSF el = (ElementWallSF) _Element[e];
	if (el.bIsValid())
	{
		String sCode = el.code();
		if( sArrExtCode.find(sCode) != -1 )
		{
			elWall.append(el);
		}
	}
}

int nTop = sArNY.find(sTop);
int nBottom = sArNY.find(sBottom);
int nSides = sArNY.find(sSides);
int nGapSide = sArNY.find(sGapSide);
for( int e=0; e<elWall.length(); e++ )
{
	ElementWallSF el=elWall[e];
	CoordSys cs=el.coordSys();
	Vector3d vx=cs.vecX();
	Vector3d vy=cs.vecY();
	Vector3d vz=cs.vecZ();
	Point3d ptOrgEl=cs.ptOrg();
	_Pt0=ptOrgEl;

	
	PLine plEnvEl=el.plEnvelope();
	Point3d ptVertexEl[]=plEnvEl.vertexPoints(FALSE);
	
	//Some values and point needed after
	Point3d ptFront=el.zone(1).coordSys().ptOrg(); ptFront.vis(1);
	Point3d ptBack=el.zone(-1).coordSys().ptOrg(); ptBack.vis(2);
	
	Plane plnFront (ptFront, vz);
	Plane plnBack (ptBack, vz);
	
	double dWallThickness=abs(vz.dotProduct(ptFront-ptBack));
	
	//Organize the beams in diferent Arrays
	Beam bmAll[]=el.beam();
	Beam bmToPlate[0];
	Beam bmToSplit[0];
	
	if (bmAll.length()<1)
		continue;
	
	double dBmWidth=el.dBeamWidth();
	double dBmHeight=el.dBeamHeight();
	
	//Collect the openings and find all the beam that bellong to that module and move the studs to allow insertion of OSB
	Opening opAll[]=el.opening();
	
	for (int n=0; n<opAll.length(); n++)
	{
		OpeningSF op=(OpeningSF) opAll[n];
		if (!op.bIsValid())
			continue;
		
		int nDoor=false;
		if (op.openingType()==_kDoor)
			nDoor=true;
		if(nGapSide)
		{ 
			if(nSides)
				op.setDGapSide(dThick);
			if(nBottom)
				op.setDGapBottom(dThick);
			if(nTop)
				op.setDGapTop(dThick);
		}

		PLine plOp=op.plShape();
		Point3d ptAllVertex[]=plOp.vertexPoints(FALSE);

		Point3d ptCenOp;
		ptCenOp.setToAverage(ptAllVertex);

		PlaneProfile ppOp(cs);
		ppOp.joinRing(plOp, FALSE);
		ppOp.shrink(-(dThick*2));
		
		//Create the OSB Around the Opening
		ptAllVertex=plnFront.projectPoints(ptAllVertex);
		for (int j=0; j<ptAllVertex.length()-1; j++)
		{
			LineSeg ls1 (ptAllVertex[j+1], ptAllVertex[j]);
			Point3d ptMid = ls1.ptMid();
			Vector3d vecSeg = ptAllVertex[j + 1] - ptAllVertex[j];vecSeg.normalize();
			if(abs(abs(op.coordSys().vecY().dotProduct(vecSeg))-1.0)<dEps)
			{
			// vertical
				if(nSides==0)
					continue;
			}
			if(abs(abs(op.coordSys().vecX().dotProduct(vecSeg))-1.0)<dEps)
			{ 
			// horizontal
				if(op.coordSys().vecY().dotProduct(ptMid-ptCenOp)>0)
				{ 
					// top
					if(nTop==0)
						continue;
				}
				if(op.coordSys().vecY().dotProduct(ptMid-ptCenOp)<0)
				{ 
					// bottom
					if(nBottom==0)
						continue;
				}
			}
			
			Vector3d vxSh=ptAllVertex[j+1]-ptAllVertex[j];
			double dLen=vxSh.length();
			vxSh.normalize();
			
			if ((nDoor && abs(vxSh.dotProduct(vx))>0.99) && (ls1.ptMid().Z()<ptCenOp.Z()))
				continue;
			
			// HSB-18953: 
			if(op.dGapSide()>dEps)
			if (abs(vxSh.dotProduct(vx))>0.99)
			{
				dLen+=(dThick*2);
			}
			
			Vector3d vAux=ls1.ptMid()-ptCenOp;
			vAux.normalize();
			
			Vector3d vzSh=vxSh.crossProduct(vz);
			vzSh.normalize();
			
			if (vzSh.dotProduct(vAux)<0)
				vzSh=-vzSh;
			
			Sheet sh;
			sh.dbCreate(ls1.ptMid(), vxSh, vz, vzSh, dLen, dWallThickness, dThick, 0, -1, 1);
			// HSB-18953
			sh.setMaterial(sMaterial);
			sh.setName(sName);
			sh.assignToElementGroup(el, TRUE, nZone, 'Z');
		}
	}
}


//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                 Erase instance

if (_bOnElementConstructed)
{
	eraseInstance();
	return;
}

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
      <str nm="COMMENT" vl="HSB-18953: swap name and material it was other way around" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="6/22/2023 9:56:25 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16394: add property to define whether sidegape will be applied at opening or not" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="9/2/2022 2:04:31 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15357: add properties to controll sides and top, bottom" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="6/24/2022 2:44:54 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End