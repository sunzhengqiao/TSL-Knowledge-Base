#Version 8
#BeginDescription
Corrects the width and height convetion of timbers generation

Modified by: AJ (ajena@itw-industry.com)
Date: 15.04.2016  -  version 1.3

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2012 by
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
* Created by: Chirag Sawjani (csawjani@itw-industry.com)
* 02.07.2012
* version 1.0: Release Version
*
* Created by: Chirag Sawjani (csawjani@itw-industry.com)
* 03.07.2012
* version 1.1: Setting of width/height fixed when beams were flat to the element
*
* Created by: Chirag Sawjani (csawjani@itw-industry.com)
* 15.04.2016
* version 1.3: Bugfix on extrusion profiles which are natively the wrong convention. Generation handles them properly anyhow.
*/

_ThisInst.setSequenceNumber(-120);

Unit(1,"mm");

if (_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}
	//showDialogOnce();
	
	//Select main SIP panel
	PrEntity ssE("\nSelect Element", Element());

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

if (_Element.length()==0)
{
	eraseInstance();
	return;	
}

for (int e=0; e<_Element.length(); e++)
{
	//Check if there are any beams in the element
	Element el=_Element[e];
	CoordSys csEl=el.coordSys();
	Vector3d vx=csEl.vecX();
	Vector3d vy=csEl.vecY();
	Vector3d vz=csEl.vecZ();
	
	Beam bmAll[]=el.beam();
	if(bmAll.length()==0)
	{
		eraseInstance();
		return;
	}
	//Collect all beams which are bottom plates
	Beam bmBottomPlate[0];
	for(int i=0;i<bmAll.length();i++)
	{
		Beam bm=bmAll[i];
		if(bm.extrProfile()!=_kExtrProfRectangular)
		{
			continue;
		}
				
		bm.realBody().vis();
		double dWidth=bm.dW();
		double dHeight=bm.dH();
		
		//if the width greater than the height, the convetion is wrong and needs to be fixed
		if(dWidth>dHeight)
		{
			CoordSys cs=bm.coordSys();
			CoordSys csRotate=bm.coordSys();
			csRotate.vis(1);
			csRotate.setToRotation(90, bm.vecX(), bm.ptCen());
			
			cs.transformBy(csRotate);
			cs.vis(2);
			
			//apply rotated coordinate system to beam
			bm.setCoordSys(cs);
			
			//Swap the height and width
			bm.setD(cs.vecY(), dHeight);
			bm.setD(cs.vecZ(),dWidth);
		}
	}	
}


eraseInstance();
return;





#End
#BeginThumbnail



#End