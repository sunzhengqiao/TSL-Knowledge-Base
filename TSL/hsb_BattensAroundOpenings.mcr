#Version 8
#BeginDescription
Create battens around openings with an option to exclude doors, this battens will be assign to a zone of the element.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 12.06.2009 - version 1.0

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
*  Copyright (C) 2009 by
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
* date: 12.06.2009
* version 1.1: Release Version
*
*/

Unit(1,"mm"); // script uses mm

String sArNY[] = {T("No"), T("Yes")};

PropString sDoor(0, sArNY, T("Apply Battens Around Doors"));
sDoor.setDescription("");

String sArVH[] = {T("Extend Vertical"), T("Extend Horizontal")};
PropString sCorners(1, sArVH, T("Corners Cleanup"));
sCorners.setDescription("");

PropDouble dBattenWidth (0, U(38), T("Batten Width"));
PropDouble dBattenHeight (1, U(20), T("Batten Height"));

int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZones (0, nValidZones, T("Zone to assign the Battens"));

PropString sName(2,"Battens", "Name");
sName.setDescription("");

PropString sMaterial(3,"","Material");
sMaterial.setDescription("");

PropString sGrade(4,"","Grade");
sGrade.setDescription("");

PropString sInformation(5,"","Information");
sInformation.setDescription("");

PropString sLabel(6,"Batten","Label");
sLabel.setDescription("");

PropString sSublabel(7,"","Sublabel");
sSublabel.setDescription("");

PropString sSublabel2(8,"","Sublabel 2");
sSublabel2.setDescription("");

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

int bDoor= sArNY.find(sDoor, 0);
int bCorners= sArVH.find(sCorners, 0);
int nZone=nRealZones[nValidZones.find(nZones, 0)];

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

if( _Element.length()==0 ){
	eraseInstance();
	return;
}

for( int e=0; e<_Element.length(); e++ )
{
	ElementWall el = (ElementWall) _Element[e];
	if (!el.bIsValid()) continue;


	CoordSys cs=el.coordSys();
	Vector3d vx=cs.vecX();
	Vector3d vy=cs.vecY();
	Vector3d vz=cs.vecZ();
	Point3d ptOrgEl=cs.ptOrg();
	_Pt0=ptOrgEl;

	//Some values and point needed after
	Point3d ptFront=el.zone(nZone).coordSys().ptOrg(); ptFront.vis(1);
	
	Plane plnFront (ptFront, vz);

	Opening opAll[]=el.opening();
	for (int o=0; o<opAll.length(); o++)
	{
		if (opAll[o].openingType()==_kDoor)
		{
		}
	}
	
	for (int n=0; n<opAll.length(); n++)
	{
		Opening op=opAll[n];
		int nDoor=FALSE;
		if (op.openingType()==_kDoor)
			nDoor=TRUE;
		
		if (bDoor==FALSE && nDoor==TRUE)	continue;
		
		
		PLine plOp=op.plShape();
		plOp.vis();
		Point3d ptAllVertex[]=plOp.vertexPoints(FALSE);
		Point3d ptCenOp;
		ptCenOp.setToAverage(ptAllVertex);

		//Create the OSB Around the Opening
		ptAllVertex=plnFront.projectPoints(ptAllVertex);
		for (int j=0; j<ptAllVertex.length()-1; j++)
		{
			LineSeg ls (ptAllVertex[j+1], ptAllVertex[j]);
			Vector3d vxBm=ptAllVertex[j+1]-ptAllVertex[j];
			if (nZone<0)
				vxBm=-vxBm;
			double dLen=vxBm.length();
			vxBm.normalize();
			Vector3d vAux=ls.ptMid()-ptCenOp;
			vAux.normalize();
			Vector3d vyBm=vxBm.crossProduct(vz);
			vyBm.normalize();
			if (vyBm.dotProduct(vAux)<0)
				vyBm=-vyBm;
			Vector3d vzBm=vz;
			if (nZone<0)
				vzBm=-vzBm;
			
			if (vyBm.dotProduct(-vy)>0.95 && nDoor)
				continue;

			if (abs(vyBm.dotProduct(vy))>0.95 && bCorners==1)//Horizontal
				dLen=dLen+dBattenWidth*2;
			
			if (abs(vyBm.dotProduct(vx))>0.95 && bCorners==0)//Vertical
				dLen=dLen+dBattenWidth*2;				
			//vxBm.crossProduct(vyBm);
			vxBm.vis(ptCenOp, 1);
			vyBm.vis(ptCenOp, 3);
			vzBm.vis(ptCenOp, 150);
			
			
			Beam bm;
			bm.dbCreate(ls.ptMid(), vxBm, vyBm, vzBm, dLen, dBattenWidth, dBattenHeight, 0, 1, 1);
			bm.setColor(32);
			bm.setName(sName);
			bm.setMaterial(sMaterial);
			bm.setGrade(sGrade);
			
			bm.setInformation(sInformation);
			bm.setLabel(sLabel);
			bm.setSubLabel(sSublabel);
			bm.setSubLabel2(sSublabel2);
			
			bm.setType(_kBeam);
			
			bm.assignToElementGroup(el, TRUE, nZone, 'Z');
			
		}
	}
}

eraseInstance();
return;




#End
#BeginThumbnail




#End
