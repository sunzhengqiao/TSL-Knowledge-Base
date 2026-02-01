#Version 8
#BeginDescription
Joins all bottom plates of SIP panels, can be used on generation as well as selecting elements

Modified by: CS (csawjani@itw-industry.com)
Date: 26.02.2013  -  version 1.1



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
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
* Last modified by: CS
* 12.04.2011  -  version 1.0
*
* Last modified by: AJ
* 26.02.2013  -  version 1.1 : Add pressure treated plate
*/


Unit(1,"mm");

if (_bOnInsert) {
	//Select main SIP panel
	PrEntity ssE("\nSelect Element",Element());

	if (ssE.go()) { 
		Entity ents[0];
    		ents = ssE.set(); 
    		for (int i=0; i<ents.length(); i++) { 
			 Element el = (Element)ents[i];   
			if (el.bIsValid()) { 
			 _Element.append(el);  
			}		
		}
	}

	return;
}

//Check if there are any beams in the element
Element el=_Element[0];
Beam bmAll[]=el.beam();
if(bmAll.length()==0)
{
	eraseInstance();
	return;
}
//Collect all beams which are bottom plates
Beam bmBottomPlate[0];
Beam bmSoleplate[0];
for(int i=0;i<bmAll.length();i++)
{
	Beam bmCurr=bmAll[i];
	int nType=bmCurr.type();
	if(nType==_kPanelBottomPlate)
	{
		bmBottomPlate.append(bmCurr);
	}
	
	if(nType==_kPanelPressureTreatedPlate)
	{
		bmSoleplate.append(bmCurr);
	}

}
if(bmBottomPlate.length()==0 && bmSoleplate.length()==0)
{
	eraseInstance();
	return;
}

int nSafetyCount=0;

while(nSafetyCount<=100 && bmBottomPlate.length()>1)
{
	Beam bmPrimary=bmBottomPlate[0];
	Beam bmToJoin=bmBottomPlate[1];
	bmPrimary.dbJoin(bmToJoin);
	bmBottomPlate.removeAt(1);
	nSafetyCount++;
}
if(nSafetyCount==100)
{
	reportNotice("Error in joining bottom plates on panel "+el.number()+" Safety Limit reached");
}

nSafetyCount=0;

while(nSafetyCount<=100 && bmSoleplate.length()>1)
{
	Beam bmPrimary=bmSoleplate[0];
	Beam bmToJoin=bmSoleplate[1];
	bmPrimary.dbJoin(bmToJoin);
	bmSoleplate.removeAt(1);
	nSafetyCount++;
}
if(nSafetyCount==100)
{
	reportNotice("Error in joining soleplates on panel "+el.number()+" Safety Limit reached");
}

eraseInstance();
return;







#End
#BeginThumbnail







#End
