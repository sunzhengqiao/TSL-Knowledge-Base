#Version 8
#BeginDescription
Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 11.07.2013 - version 1.2

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
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

* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 14.05.2012
* version 1.0: Release Version
*
* date: 11.07.2012
* version 1.2: Made it more robust so it wont crash when one of the bodies is not valid.
*/

String sArYesNo[] = {T("No"), T("Yes")};

PropString sMode(0, sArYesNo, T("Add Tolls to Curve Segments"),0);

if (_bOnInsert)
{
	if( insertCycleCount() > 1 )
	{
		eraseInstance();
		return;
	}
	
	if (_kExecuteKey=="")
		showDialogOnce();
	
	int nFixings= sArYesNo.find(sMode, 0);
	
	String arSValidObjectTypes[] = {"AecbDbConduit", "AecbDbPipe", "AecbDbDuct", "AecbDbPipeFlex", "AecbDbDuctFlex", "AecDbMassElem"};
	
	if (nFixings)
	{
		arSValidObjectTypes.append("AecbDbConduitFitting");
		arSValidObjectTypes.append("AecbDbPipeFitting");
		arSValidObjectTypes.append("AecbDbDuctFitting");
	}
	
	PrEntity ssE(T("Select MEP objects"), Entity());
	ssE.allowNested(true);
	
	if( ssE.go() ){
		Entity arEnt[] = ssE.set();
		for( int e=0;e<arEnt.length();e++ )
		{
			Entity ent = arEnt[e];
			//Entity ent = getEntity(T("Select a MEP objects of type conduit"), true);
			

			String sObjectType = ent.typeName();

			if( arSValidObjectTypes.find(sObjectType) != -1 ) 
			{
	                  _Entity.append(ent);
			}
		}
	}
	
	PrEntity ssElement(T("Select elements"), Element());
	if( ssElement.go() ){
		_Element.append(ssElement.elementSet());
	}
	
	return;
}
//End bOnInsert

if( _Entity.length() == 0 ){eraseInstance(); return;}

if( _Element.length() == 0 ){eraseInstance(); return;}

int nErase=false;

TslInst tsl;

String strScriptName = "ScandiByg_MEPSingleObject";

Vector3d vecUcsX(1,0,0);
Vector3d vecUcsY(0,1,0);

Beam lstBeams[0];
Entity lstEntity[0];
Point3d lstPoints[0];

int lstPropInt[0];
double lstPropDouble[0];
String lstPropString[0];

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	
	CoordSys csEl=el.coordSys();
	Vector3d vx=el.vecX();
	Vector3d vy=el.vecY();
	Vector3d vz=el.vecZ();
	
	Point3d ptFront=el.zone(10).ptOrg();
	Point3d ptBack=el.zone(-10).ptOrg();
	
	_Pt0=csEl.ptOrg();
	
	double dThick=abs(vz.dotProduct(ptFront-ptBack));
	
	Plane plnBack(ptBack, vz);

	/*
	PlaneProfile ppEl=el.profBrutto(0);
	
	
	ppEl.project(plnBack, vz, U(2));
	ppEl.vis();
	PLine plAllRings[]=ppEl.allRings();
	int nIsOpening[]=ppEl.ringIsOpening();
	
	PLine plOutline;
	double dArea=0;
	
	for (int i=0; i<plAllRings.length(); i++)
	{
		if(plAllRings[i].area()>dArea)
		{
			dArea=plAllRings[i].area();
			plOutline=plAllRings[i];
		}
	}
	*/
	PLine plOutline=el.plEnvelope();
	double dArea=plOutline.area();
	if (dArea==0)
		continue;
	
	Body bdElement(plOutline, vz*(dThick), 1);
	bdElement.vis(1);
	TslInst tslAll[]=el.tslInst();
	
	for( int e=0;e<_Entity.length();e++ )
	{
		Entity ent = _Entity[e];
		
		Element elAux=(Element) ent;
		if (elAux.bIsValid())
			continue;
		
		for( int t=0; t<tslAll.length(); t++ )
		{
			tsl=tslAll[t];
			if (!tsl.bIsValid()) continue;
			Map mpAux=tsl.map();
			if (mpAux.hasString("Code"))
			{
				String sCode=mpAux.getString("Code");
				if (ent.handle()==sCode)
				{
					tslAll[t].dbErase();
				}
			}
		}
		
		Map mpEnt=ent.getAutoPropertyMap();
		
		//Collect the entity real body
		//Body bdEnt = ent.realBody();
		Body bdEnt;
		
		
		CoordSys csEnt = ent.coordSys();
		Vector3d vxEnt = csEnt.vecX();
		Vector3d vyEnt = csEnt.vecY();
		Vector3d vzEnt = csEnt.vecZ();
		
		double dEntLength;
		if (mpEnt.hasDouble("LENGTH"))
		{
			dEntLength=mpEnt.getDouble("LENGTH");
		}
		
		if (dEntLength>U(1))
		{
		
			bdEnt=Body(csEnt.ptOrg(), vxEnt, vyEnt, vzEnt, dEntLength, U(10), U(10), 1, 0, 0);
			bdEnt.vis(2);
		}
		else
		{
			bdEnt=Body(csEnt.ptOrg(), vxEnt, vyEnt, vzEnt, U(2), U(2), U(2), 1, 0, 0);
			bdEnt.vis(2);
		}
			
		if (bdElement.hasIntersection(bdEnt))
		{
			//Clone the child TSL only with that element and entity
	
			lstEntity.setLength(0);
			lstEntity.append(el);
			lstEntity.append(ent);

			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY, lstBeams, lstEntity, lstPoints, lstPropInt, lstPropDouble, lstPropString);
			//reportNotice("\n true");
		}
	}
	nErase=true;
}

if (_bOnElementConstructed || nErase)
{
	eraseInstance();
	return;
}


#End
#BeginThumbnail



#End
