#Version 8
#BeginDescription
Set the beam code of the headbinder to "V" and the beam type to _kSFVeryTopPlate

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 21.07.2011 - version 1.2



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
* date: 26.05.2010
* version 1.0: Release Version
*
* date: 26.05.2010
* version 1.2: Bugfix
*/

_ThisInst.setSequenceNumber(-200);

Unit(1,"mm"); // script uses mm

double dEps = Unit(0.01,"mm");

// Load the values from the catalog
if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	
	PrEntity ssE("\nSelect a set of elements",ElementWall());	
  	if (ssE.go()) { 
		_Element.append(ssE.elementSet());
	}
	return;
}

if( _Element.length() == 0 ){
	eraseInstance();
	return;
}

int arValidBeamType[]={
	_kSFTopPlate, _kSFVeryTopPlate
};


int nErase = false;

for (int e=0; e<_Element.length(); e++)
{
	Element el  = _Element[e];

	Beam bmAll[] = el.beam();
	
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	
	//Create beams
	Beam arBmNew[0];
	Plane plnZ(csEl.ptOrg(), csEl.vecZ());
	
	Beam bmToCheck[0];

	for ( int i=0; i<bmAll.length(); i++ )
	{
		if (arValidBeamType.find(bmAll[i].type(), -1) != -1 )
			bmToCheck.append(bmAll[i]);
	}
	
	Beam bmHor[]=vy.filterBeamsPerpendicularSort(bmToCheck);
	if (bmHor.length()==0)
	{
		continue;
	}
	
	Point3d ptTop=bmHor[bmHor.length()-1].ptCen();
	
	for	(int i=0; i<bmHor.length(); i++)
	{
		Beam bm=bmHor[i];
		if (abs(vy.dotProduct(bm.ptCen()-ptTop))<U(1))
		{
			Beam bmIntersect[]=bm.filterBeamsCapsuleIntersect(bmHor);
			if (bmIntersect.length()>0)
			{
				for (int j=0; j<bmIntersect.length(); j++)
				{
					if (abs(abs(vy.dotProduct(bmIntersect[j].ptCen()-bm.ptCen()))-(bmIntersect[j].dD(vy)*.5 + bm.dD(vy)*0.5))<U(1))
					{
						String sBeamCode=bm.beamCode();
						String sCode=sBeamCode.token(0);
						sBeamCode.delete(0,sCode.length());
						
						String sNewCode="V"+sBeamCode;
						bm.setBeamCode(sNewCode);
						bm.setType(_kSFVeryTopPlate);
						break;
					}
				}
			}
		}
		nErase=true;
	}
}		

if (_bOnElementConstructed || nErase)
{
	eraseInstance();
	return;
}



#End
#BeginThumbnail


#End
