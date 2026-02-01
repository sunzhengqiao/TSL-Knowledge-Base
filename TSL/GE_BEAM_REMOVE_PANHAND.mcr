#Version 8
#BeginDescription
v1.0: 31-oct-2013: David Rueda (dr@hsb-cad.com)
Removes PANHAND from selected beams


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
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
*  hsbSOFT 
*  UNITED STATES OF AMERICA
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
* v1.0: 31-oct-2013: David Rueda (dr@hsb-cad.com)
	- Release
*/

if (_bOnInsert) {
	
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	PrEntity ssE("select a set beams", Beam());
	if (ssE.go()) {
		Beam ssBeams[] = ssE.beamSet();
		for (int b=0; b<ssBeams.length(); b++)
		 	_Beam.append(ssBeams[b]);
	}
	if(_Beam.length()==0){
		eraseInstance();
		return;
	}
	return;
}

if (_Beam.length()==0){
	eraseInstance();
	return;
}

int nCount=0;
for(int i=0; i<_Beam.length();i++){
	Beam bm=_Beam[i];
    	if (bm.bIsValid())
	{ 
		bm.setPanhand(_ThisInst);
		nCount++;
    	}
}
reportNotice("\n"+nCount+" "+"Beams affected");
eraseInstance();


#End
#BeginThumbnail


#End
