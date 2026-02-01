#Version 8
#BeginDescription
v1.1: 29-ago-2013: David Rueda (dr@hsb-cad.com)
Changes color on selected beam(s)
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
*
* v1.1: 29-ago-2013: David Rueda (dr@hsb-cad.com)
	- Strings added to translation
* v1.0: 16-mar-2012: David Rueda (dr@hsb-cad.com)
	- Release
*/

String sColors[0]; int nColors[0];
sColors.append(T("|Default brown|")+" ("+"32)");					nColors.append(32);
sColors.append(T("|Light brown|")+" ("+"40)");					nColors.append(40);
sColors.append(T("|White|"));										nColors.append(0);
sColors.append(T("|Red|"));										nColors.append(1);
sColors.append(T("|Yellow|"));									nColors.append(2);
sColors.append(T("|Green|"));										nColors.append(3);
sColors.append(T("|Cyan|"));										nColors.append(4);
sColors.append(T("|Blue|"));										nColors.append(5);
sColors.append(T("|Magenta|"));									nColors.append(6);


PropString sTopPlate(0, sColors, T("|Top Plate|"), 0);
int nIndex= sColors.find(sTopPlate, 0);
int kTopPlate= nColors[nIndex];

PropString sSFTopPlate(1, sColors, T("|SF Top Plate|"), 0);
nIndex= sColors.find(sSFTopPlate, 0);
int kSFTopPlate= nColors[nIndex];

PropString sSFVeryTopPlate(2, sColors, T("|SF Very Top Plate|"), 0);
nIndex= sColors.find( sSFVeryTopPlate, 0);
int kSFVeryTopPlate= nColors[nIndex];

PropString sSFBottomPlate(3, sColors, T("|SF Bottom Plate|"), 0);
nIndex= sColors.find(sSFBottomPlate, 0);
int kSFBottomPlate= nColors[nIndex];

PropString sSFAngledTopPlateRight(4, sColors, T("|Angled Top Plate Right|"), 0);
nIndex= sColors.find(sSFAngledTopPlateRight, 0);
int kSFAngledTPRight= nColors[nIndex];

PropString sSFAngledTopPlateLeft(5, sColors, T("|Angled Top Plate Left|"), 0);
nIndex= sColors.find(sSFAngledTopPlateLeft, 0);
int kSFAngledTPLeft= nColors[nIndex];

PropString sStud(6, sColors, T("|Stud|"), 0);
nIndex= sColors.find(sStud, 0);
int kStud= nColors[nIndex];

PropString sKingStud(7, sColors, T("|King Stud|"), 0);
nIndex= sColors.find(sKingStud, 0);
int kKingStud= nColors[nIndex];

PropString sLeftStud(8, sColors, T("|Left Stud|"), 0);
nIndex= sColors.find(sLeftStud, 0);
int kSFStudLeft= nColors[nIndex];

PropString sRightStud(9, sColors, T("|Right Stud|"), 0);
nIndex= sColors.find(sRightStud, 0);
int kSFStudRight= nColors[nIndex];

PropString sSupportingBeam(10, sColors, T("|Supporting Beam|"), 0);
nIndex= sColors.find(sSupportingBeam, 0);
int kSFSupportingBeam= nColors[nIndex];

PropString sJackOverOpening(11, sColors, T("|Jack Over Opening|"), 0);
nIndex= sColors.find(sJackOverOpening, 0);
int kSFJackOverOpening= nColors[nIndex];

PropString sJackUnderOpening(12, sColors, T("|Jack Under Opening|"), 0);
nIndex= sColors.find(sJackUnderOpening, 0);
int kSFJackUnderOpening= nColors[nIndex];

PropString sRightShim(13, sColors, T("|Right Shim|"), 0);
nIndex= sColors.find(sRightShim, 0);
int kSFRightShim= nColors[nIndex];

PropString sLeftShim(14, sColors, T("|Left Shim|"), 0);
nIndex= sColors.find(sLeftShim, 0);
int kSFLeftShim= nColors[nIndex];

PropString sTopShim(15, sColors, T("|Top Shim|"), 0);
nIndex= sColors.find(sTopShim, 0);
int kSFTopShim= nColors[nIndex];

PropString sBottomShim(16, sColors, T("|Bottom Shim|"), 0);
nIndex= sColors.find(sBottomShim, 0);
int kSFBottomShim= nColors[nIndex];

PropString sSill(17, sColors, T("|Sill|"), 0);
nIndex= sColors.find(sSill, 0);
int kSill= nColors[nIndex];

PropString sTopHeaderSill(18, sColors, T("|Top Header Sill|"), 0);
nIndex= sColors.find(sTopHeaderSill, 0);
int kSFTopHeaderSill= nColors[nIndex];

PropString sBottomHeaderSill(19, sColors, T("|Bottom Header Sill|"), 0);
nIndex= sColors.find(sBottomHeaderSill, 0);
int kSFBottomHeaderSill= nColors[nIndex];

PropString sHeader(20, sColors, T("|Header|"), 0);
nIndex= sColors.find(sHeader, 0);
int kHeader= nColors[nIndex];

PropString sBlocking(21, sColors, T("|Blocking|"), 0);
nIndex= sColors.find(sBlocking, 0);
int kBlocking= nColors[nIndex];

PropString sSFBlocking(22, sColors, T("|SF Blocking|"), 0);
nIndex= sColors.find(sSFBlocking, 0);
int kSFBlocking= nColors[nIndex];

PropString sBeam(23, sColors, T("|Beam|"), 0);
nIndex= sColors.find(sBeam, 0);
int kBeam= nColors[nIndex];

PropString sTransom(24, sColors, T("|Transom|"), 0);
nIndex= sColors.find(sTransom, 0);
int kSFTransom= nColors[nIndex];

PropString sPost(25, sColors, T("|Post|"), 0);
nIndex= sColors.find(sPost, 0);
int kPost= nColors[nIndex];


if(_bOnInsert){
	
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	if (_kExecuteKey=="")
	{
		showDialogOnce();
	}
	
	PrEntity ssE("\n"+T("|Select beam (s)|"),Beam());
	if( ssE.go())
	{
		_Beam.append(ssE.beamSet());
	}
	return;
}

if(_Beam.length()<=0)
{
	eraseInstance();
	return
}

for(int b=0;b<_Beam.length();b++)
{
	Beam bm=_Beam[b];
	if(!bm.bIsValid())
	{
		continue;
	}
	
	int nType= bm.type();

	if( nType ==  _kTopPlate )
		bm.setColor(kTopPlate );

	if( nType ==  _kSFTopPlate )
		bm.setColor(kSFTopPlate );

	if( nType ==  _kSFVeryTopPlate )
		bm.setColor(kSFVeryTopPlate );

	if( nType ==  _kSFBottomPlate )
		bm.setColor(kSFBottomPlate );

	if( nType ==  _kSFAngledTPRight )
		bm.setColor(kSFAngledTPRight );

	if( nType ==  _kSFAngledTPLeft )
		bm.setColor(kSFAngledTPLeft );

	if( nType ==  _kStud )
		bm.setColor(kStud );

	if( nType ==  _kKingStud )
		bm.setColor(kKingStud );

	if( nType ==  _kSFStudLeft )
		bm.setColor(kSFStudLeft );

	if( nType ==  _kSFStudRight )
		bm.setColor(kSFStudRight );

	if( nType ==  _kSFSupportingBeam )
		bm.setColor(kSFSupportingBeam );

	if( nType ==  _kSFJackOverOpening )
		bm.setColor(kSFJackOverOpening );

	if( nType ==  _kSFJackUnderOpening )
		bm.setColor(kSFJackUnderOpening );

	if( nType ==  _kSFRightShim )
		bm.setColor(kSFRightShim );

	if( nType ==  _kSFLeftShim )
		bm.setColor(kSFLeftShim );

	if( nType ==  _kSFTopShim )
		bm.setColor(kSFTopShim );

	if( nType ==  _kSFBottomShim )
		bm.setColor(kSFBottomShim );

	if( nType ==  _kSill )  
		bm.setColor(kSill);

	if( nType ==  _kSFTopHeaderSill  )
		bm.setColor(kSFTopHeaderSill);

	if( nType ==  _kSFBottomHeaderSill )
		bm.setColor(kSFBottomHeaderSill);

	if( nType ==  _kHeader )
		bm.setColor(kHeader);

	if( nType ==  _kBlocking )
		bm.setColor(kBlocking);

	if( nType ==  _kSFBlocking )
		bm.setColor(kSFBlocking);

	if( nType ==  _kBeam )
		bm.setColor(kBeam);

	if( nType ==  _kSFTransom )
		bm.setColor(kSFTransom);

	if( nType ==  _kPost )
		bm.setColor(kPost);

}

eraseInstance();
return
#End
#BeginThumbnail
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
EHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#__V:*`
`



#End
