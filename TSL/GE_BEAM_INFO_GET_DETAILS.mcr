#Version 8
#BeginDescription
v1.4: 18-jul-2013:  David Rueda (dr@hsb-cad.com)
Gets beam information:
Volume, length, grade, profile, matrerial, label, sublabel, sublabel2, beamcode, type name, type number, information, name, posnumandtext, posnum, layer, hsbid, module, bIsDummy, color, bIsCutStraight 0, bIsCutStraight 1, bIsMyEnd 0, bIsMyEnd1
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
*  hsbSOFT 
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
* v1.4: 18-jul-2013:  David Rueda (dr@hsb-cad.com)
	- Thumbnail updated
* v1.3: 19.mar.2013: David Rueda (dr@hsb-cad.com)
	- Renamed from GE_INFO_GET_BEAM_DETAILS to GE_BEAM_INFO_GET_DETAILS
* v1.2: 21.jul.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Thumbnail added
	- Copyright added
* v1.1: 15-Mar-2007: David Rueda (dr@hsb-cad.com) 
* v1.0: 09-Feb-2007: David Rueda (dr@hsb-cad.com) 
*
*/

double duperm = Unit(1,"m"); // calculates how much 1 m is in drawing units
double duperm3 = duperm*duperm*duperm; // calculate the volume scale factor

if(_bOnInsert){
	_Beam.append(getBeam("Select beam"));
	return;
}

if(_Beam.length()==0){
	reportMessage("No beam selected");
	return;
}


Unit(1,"mm"); // from now on use the mm as unit in this script
int i=0;

    if (_Beam[i].bIsValid()) { 

        String strBeam = "Information beam ";
        strBeam += "\n    volume:\t" + (_Beam[i].volume()/duperm3);
        strBeam += "\n    length:\t\t" + (_Beam[i].solidLength()/duperm);
        strBeam += "\n    grade:\t\t" + _Beam[i].name("grade");
        strBeam += "\n    profile:\t\t" + _Beam[i].name("profile");
        strBeam += "\n    material:\t" + _Beam[i].name("material");
        strBeam += "\n    label:\t\t" + _Beam[i].name("label");
        strBeam += "\n    sublabel:\t" + _Beam[i].name("sublabel");
        strBeam += "\n    sublabel2:\t" + _Beam[i].name("sublabel2");
        strBeam += "\n    beamcode:\t" + _Beam[i].name("beamcode");
        strBeam += "\n    type name:\t" + _Beam[i].name("type");
        strBeam += "\n    type number:\t" + _Beam[i].type();
        strBeam += "\n    information:\t" + _Beam[i].name("information");
        strBeam += "\n    name:\t" + _Beam[i].name("name");
        strBeam += "\n    posnumandtext:\t" + _Beam[i].name("posnumandtext");
        strBeam += "\n    posnum:\t" + _Beam[i].posnum();
        strBeam += "\n    layer:\t\t" + _Beam[i].name("layer");
        strBeam += "\n    hsbId:\t\t" + _Beam[i].name("hsbId");
        strBeam += "\n    module:\t" + _Beam[i].name("module");
        strBeam += "\n    bIsDummy:\t" + _Beam[i].bIsDummy();
        strBeam += "\n    color:\t\t" + _Beam[i].color();
        strBeam += "\n    bIsCutStraight(0):\t" + _Beam[i].bIsCutStraight(0);
        strBeam += "\n    bIsCutStraight(1):\t" + _Beam[i].bIsCutStraight(1);
        strBeam += "\n    bIsMyEnd(0):\t" + _Beam[i].bIsMyEnd(0);
        strBeam += "\n    bIsMyEnd(1):\t" + _Beam[i].bIsMyEnd(1);
        reportNotice(strBeam);
    }
eraseEntity();









#End
#BeginThumbnail
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
B1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`?_V110
`

#End
