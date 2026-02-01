#Version 8
#BeginDescription
Sets properties through _Map to Alpine-BearingReaction TSL's present in DWG
Only inserted by another tsl or calling script passing arguments trough map
v1.3: 29.ago.2013: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 0
#MajorVersion 1
#MinorVersion 3
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
* v1.3: 29.ago.2013: David Rueda (dr@hsb-cad.com)
	- Strings added to translation
* v1.2: 17.ago.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Copyright added
	- Thumbnail added
* v1.0 && v1.1: No author
*
*/

Unit(1,"mm");

PropDouble prMinReaction(0, 0.0 ,T("|Display Reactions above... (kN)|"));

String arYesNo[]= {T("No"),T("Yes")};
PropString strShowInfill(0,arYesNo,T("|Reaction for Infill|"));

Display disp(-1);

disp.textHeight(100); 
disp.draw(T("|Reaction Text Display|"), _Pt0, _XW, _YW, 1,1);

Entity arEnt[] = Group().collectEntities( TRUE, TslInst(), _kModelSpace);

for ( int e=0; e< arEnt.length(); e++ )
 {
	TslInst tslObj = (TslInst)arEnt[ e ];
	
	String strScriptname =tslObj.scriptName();
	strScriptname.makeUpper();

	reportError( "tsl"+ strScriptname);

	if ( strScriptname == "ALPINE-BEARINGREACTION" )
	{
		Map tslMap = tslObj.map();
		

		
		tslMap.setDouble( "MinReactionForDisplay ", prMinReaction );
		tslMap.setInt( "ReactionsOnInfill ",  strShowInfill == "Yes" );
		tslObj.setMap( tslMap );
	}
}	
return;

#End
#BeginThumbnail
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
33S,M481E=(?11106%%%%`'__V:?\
`


#End
