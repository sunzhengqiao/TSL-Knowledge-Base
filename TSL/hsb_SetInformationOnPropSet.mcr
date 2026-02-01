#Version 8
#BeginDescription
Adds property set data to the openings in an element. The property set has to be called "hsbDoorInformation" and have field "WallThickness"

Last modified by: Alberto Jena (aj@hsb-cad.com)
Date:11.11.2014  -  version 1.0


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
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
* date: 11.11.2014
* version 1.0: Release Version
*
*/

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                      Properties

Unit(1,"mm"); // script uses mm

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                           Insert

if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	//if (_kExecuteKey=="")
	//	showDialogOnce();
	
	PrEntity ssE("\n"+T("Select an Elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);


if( _Element.length()<=0){
	eraseInstance();
	return;
}

//-----------------------------------------------------------------------------------------------------------------------------------
//                                      Loop over all elements.


//Reference Element
ElementWall el = (ElementWall) _Element[0];
if (!el.bIsValid())
{
	eraseInstance();
	return;
}

_Pt0=_Element[0].ptOrg();

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	Opening opAll[]=el.opening();
	for (int o=0; o<opAll.length(); o++)
	{
		Opening op=opAll[o];
		String arNamesAv[] = op.attachedPropSetNames();
		Map mp=op.getAttachedPropSetMap("Door Schedule");//"Header_Description"

		ElemText et[0];//this sets the length of the array for the elements
		et = el.elemTexts();
		
		CoordSys csOp=op.coordSys();
		
		Point3d ptOpOrg=csOp.ptOrg();
	
		Point3d ptLocationText[0];
		String sHeaderDescription[0];
		
		double dWallThickness=abs(el.vecZ().dotProduct(el.zone(5).ptOrg()-el.zone(-5).ptOrg()));
		
		int nOptions=0;
		if (nOptions==0)
		{
			//set the wall thickness
			op.attachPropSet("hsbDoorInformation");
			
			//Map sAllNames=op.getAttachedPropSetMap("hsbDoorInformation");
			
			Map mpNew;
			mpNew.setString("WallThickness", dWallThickness);
			mpNew.setString("Weight", 0);
			int bAdded = op.setAttachedPropSetFromMap("hsbDoorInformation", mpNew);
		
		}
		else if (nOptions==1)	//Add code later so there will be only one TSL to set the information of various objects in the property set, bellow the code for header
		{
			for (int i = 0; i <et.length(); i++)
			{
				String eltext = et[i].text();
				Point3d ptElText = et[i].ptOrg();
				String textCode = et[i].code();
				String textSubCode = et[i].subCode();
			
				if (textCode=="WINDOW" && textSubCode == "HEADER")
				{
					ptLocationText.append(ptElText);
					sHeaderDescription.append(eltext);
				}
			}
			String sHeader="";
			double dMin=U(10000);
			for (int i = 0; i <ptLocationText.length(); i++)
			{
				if (abs(el.vecX().dotProduct(ptLocationText[i]-ptOpOrg))<dMin)
				{
					sHeader=sHeaderDescription[i];
					dMin=abs(el.vecX().dotProduct(ptLocationText[i]-ptOpOrg));
				}
	
			}
			if (sHeader!="")
			{
				Map mpNew;
				mpNew.setString("Header_Description", sHeader);
				int bAdded = op.setAttachedPropSetFromMap("Door Schedule", mpNew);
			}
		}
	}
}

eraseInstance();
return;


#End
#BeginThumbnail



#End