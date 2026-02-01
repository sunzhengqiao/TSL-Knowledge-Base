#Version 8
#BeginDescription
Changes the beam type of a Packer to Header when it is directly under the top plate.

Modify by: Alberto Jena (alberto.jena@hsbcad.com)
Date: 08.07.2025 - version 1.0
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
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
*  UK
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
* date: 08.07.2025
* version 1.0: Release Version
*
*/

U(1,"mm");	

_ThisInst.setSequenceNumber(-120);

if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
		
	PrEntity ssE("\n"+T("Select a set of elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	String strScriptName = scriptName(); // name of the script
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Element lstElements[0];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	
	for( int e=0;e<_Element.length();e++ ){
		Element el = _Element[e];

		TslInst tslAll[]=el.tslInstAttached();
		 for (int i=0; i<tslAll.length(); i++)
		 {
			  if ( tslAll[i].scriptName() == scriptName() && tslAll[i].handle() != _ThisInst.handle() )
			  {
				   tslAll[i].dbErase();
			  }
		 }	
	
		lstElements.setLength(0);
		lstElements.append(el);
	
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString);
	}

	eraseInstance();
	return;
}


if( _Element.length()<=0 )
{
	eraseInstance();
	return;
}

ElementWallSF el = (ElementWallSF)_Element[0];

if (!el.bIsValid()){
	eraseInstance();
	return;
}

//Element vectors
CoordSys csEl=el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();
Point3d ptOrgEl=csEl.ptOrg();

_Pt0=ptOrgEl;




//Get beams from zone 0
Beam bmAll[0];
GenBeam gbmAll[]=el.genBeam(0);
for(int g=0;g<gbmAll.length();g++)
{
	Beam bm=(Beam)gbmAll[g];
	if(bm.bIsValid())
	{
		bmAll.append(bm);
	}
}

if(bmAll.length()==0) return;

Beam bmTop[0];
Beam bmPacker[0];

for (int i=0; i<bmAll.length(); i++)
{
	Beam bm=bmAll[i];
	if ( bm.type()==_kSFTopPlate || bm.type()==_kSFAngledTPLeft || bm.type()==_kSFAngledTPRight )
	{
		bmTop.append(bm);
	}else if ( bm.type()==_kSFPacker || bm.type()==_kBeam)
	{
		if (abs(bm.vecX().dotProduct(vx)>0.99))
			bmPacker.append(bm);
	}
}

Plane pln(ptOrgEl, vz);
PlaneProfile ppPlate(pln);

Beam bmToChange[0];

for (int i=0; i<bmTop.length(); i++)
{ 
	Beam bm0 = bmTop[i];
	bmToChange.append(  bm0.filterBeamsCapsuleIntersect(bmPacker));
}

for (int i=0; i<bmToChange.length(); i++)
{ 
	Beam bm0 = bmToChange[i];
	bm0.setType(_kHeader);
}

eraseInstance();
return;
#End
#BeginThumbnail







#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Release Version" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="7/8/2025 10:39:23 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End