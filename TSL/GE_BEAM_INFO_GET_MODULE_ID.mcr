#Version 8
#BeginDescription
v1.2: 25-sep-2013: David Rueda (dr@hsb-cad.com)
Gets TYPE, MODULE and INFORMATION from selected beams
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 2
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
* v1.2: 25-sep-2013: David Rueda (dr@hsb-cad.com)
	- Mispelling corrected
* v1.1: 30-ago-2013: David Rueda (dr@hsb-cad.com)
	- Added display for information field
* v1.0: 16-jul-2013: David Rueda (dr@hsb-cad.com)
	- Release
*/

if (_bOnInsert) {
	
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	PrEntity ssE("select a set of other beams", Beam());
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

String strBeam="\n";
for(int i=0; i<_Beam.length();i++){
	Beam bm=_Beam[i];
	String sModule=bm.name("module");
	String sInformation=bm.name("information");
	if( sModule=="")
		sModule="EMPTY";
	if( sInformation=="")
		sInformation="EMPTY";
    	if (bm.bIsValid())
	{ 
		strBeam = strBeam + "\nBeam ID: "+ bm.handle() +"\tType: "+bm.name("type") +"\t\t"+"Module"+" : "+sModule+"\t\t"+"Information: "+": "+sInformation;
    	}
}
reportNotice(strBeam);
eraseInstance();
#End
#BeginThumbnail
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
80`4444`%%%%`!1110`4444`%%%%`'__9
`

#End
