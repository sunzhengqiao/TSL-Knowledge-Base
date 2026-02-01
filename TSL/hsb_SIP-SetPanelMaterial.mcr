#Version 8
#BeginDescription
Set's the material of the SIPs inside a wall

Modified by: CS (chirag.sawjani@hsbcad.com)
Date: 26.08.2015  -  version 1.1


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
* 08.06.2012  -  version 1.0
*
* Last modified by: CS
* 26.08.2015  -  version 1.1
*/


Unit(1,"mm");

PropString sMaterial(0,"SIP",T("Material Name"));

if (_bOnInsert) {

	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();
		
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
if(_Element.length()==0)
{
	eraseInstance();
	return;
}

Element el=_Element[0];
Sip sipAll[]=el.sip();
if(sipAll.length()==0)
{
	eraseInstance();
	return;
}

for(int s=0;s<sipAll.length();s++)
{
	Sip sp=sipAll[s];
	if(!sp.bIsValid()) continue;
	
	sp.setMaterial(sMaterial);
}

eraseInstance();
return;






#End
#BeginThumbnail

#End