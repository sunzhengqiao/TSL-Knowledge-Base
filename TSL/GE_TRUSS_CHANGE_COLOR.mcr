#Version 8
#BeginDescription
Changes color of selected Truss Entities
v1.0: 01.jul.2013: David Rueda (dr@hsb-cad.com)

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
* v1.0: 01.jul.2013: David Rueda (dr@hsb-cad.com)
	- Release
*
*/

String sColors[0]; 					int nColors[0];
sColors.append(T("|Beam|")); 	nColors.append(32);
sColors.append(T("|Steel|")); 		nColors.append(254);

String sPropName=T("|Display reaction label|");
PropString sColor(0,sColors,T("New color|"),0);

if(_bOnInsert){

	PrEntity ssTr("\n"+T("|Select truss(es)|"), TrussEntity());
	if(ssTr.go())
	{
		_Entity.append(ssTr.set());
	}
	
	if(_Entity.length()==0)
	{
		eraseInstance();
		return;	
	}
	
	showDialogOnce("_LastInserted");
	
	int nColor= nColors[ sColors.find( sColor, 0) ];
	
	// Getting truss
	for(int en=0; en<_Entity.length();en++)
	{
		TrussEntity teTruss= (TrussEntity)_Entity[en];
		if( !teTruss.bIsValid())
			continue;
		
		String strDefinition = teTruss.definition();
		TrussDefinition trussDefinition(strDefinition);
		
		// Getting all beams representations
		Beam bmAllInTruss[]=trussDefinition.beam();
		for (int b=0; b< bmAllInTruss.length(); b++)
		{
			bmAllInTruss[b].setColor(nColor);
		}
	}
	reportNotice(T("|Please select all affected trusses again and execute the HSB_RECALC command to update display|"));
	eraseInstance();
	return;
}




#End
#BeginThumbnail
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
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"L#5_"EEJ.Z:`
M"UNSSYB#@_[P[UOT4`>5:GI5WI5G=65_:JUG<D9D5"RCYADJ1RC$?_JJSHK'
M0;UO"_B5FNK(NK6DUP1LP/ND>WKGH?8UZ60&&"`1[UD>(_#UMXATXP282XC^
M:";&3&W]0>XI\SY>7H--Q=UN:X`````';%+7$^$O$%S;W;^'=;RE[`=L3N?O
MCL,]_8]Q7;4A!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`<UXN\,+KMJMQ;;8]2MQF&3IN'78?;
MT]#4/@_Q,^J1MINH*T>J6P(D5Q@OC@G'J.,_GWKJZJ1Z;9Q:E-J,=NJWDR".
M24=64=`:`+=%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
)%%`!1110!__9
`

#End
