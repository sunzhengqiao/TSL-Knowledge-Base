#Version 8
#BeginDescription
Rectangular metal plate
Only inserted by another tsl or calling script passing arguments trough map.
v1.8: 26.nov.2013: David Rueda (dr@hsb-cad.com)

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 1
#MajorVersion 1
#MinorVersion 8
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
* v1.8: 26.nov.2013: David Rueda (dr@hsb-cad.com)
	- Version control
* v1.7: 26.nov.2013: David Rueda (dr@hsb-cad.com)
	- Plate drawn once only per instance. Bill Malcolm added Alpine code to have multi plates on multi plies
	- Cleaned code, performance hit reduced
* v1.6: 15.ago.2012: David Rueda (dr@hsb-cad.com)
	- Thumbnail updated
* v1.5: 12.may.2012: David Rueda (dr@hsb-cad.com)
	- Copyright added
	- Thumbnail added
	- Description added
	- Set to store state in DWG (not recalc at dwgin)
* v1.4: 04.oct.2011: David Rueda (dr@hsb-cad.com)
	- Validations on values to create body (avoid error message when vectors become null)
* v1.3 June 18 2010: no author
	- Adapted for the new model map import
* v1.1 - Initial Coding. Bill Malcom
*
*/
int nLength = _Map.getInt("Length");

if ( _bOnDbCreated )
{
      _ThisInst.setColor( 8 );
}

if ( nLength > 0 )
{
	Display dp( -1 );

	Vector3d VecBX(_Map.getDouble("XV_X"),_Map.getDouble("XV_Y"),_Map.getDouble("XV_Z"));
	Vector3d VecBY(_Map.getDouble("YV_X"),_Map.getDouble("YV_Y"),_Map.getDouble("YV_Z"));
	Vector3d VecBZ(_Map.getDouble("ZV_X"),_Map.getDouble("ZV_Y"),_Map.getDouble("ZV_Z"));
	double vecZOffset = 0.0;
	
	// If no vectors definded in map then we are using the new modelmap. Vector are in the coord sys.
	if ( _Map.getDouble("XV_X") == 0.0 &&_Map.getDouble("XV_Y") == 0.0 && _Map.getDouble("XV_Z") == 0.0 )
	{
		CoordSys coord = _ThisInst.coordSys();

		VecBX = coord.vecX();
		VecBY = coord.vecY();
		VecBZ = coord.vecZ();
		vecZOffset= _Map.getDouble("vecZOffset");
	}

	int nDepth = _Map.getInt("Width");
	String strGauge = _Map.getString("Gauge");
	String strLabel = _Map.getString("Label");

	double dPlateThickness = U(2.0,"mm");

	PropString strPlateGauge( 1, strGauge, T( "|Plate Gauge|") );
	PropString strPlateLabel( 2, strLabel, T( "|Plate Label|") );
	PropInt nPlateLength( 3, nLength, T("|Plate Length|") );
	PropInt nPlateHeight( 4, nDepth, T("|Plate Height|") );

	nPlateLength.setReadOnly( TRUE );
	nPlateHeight.setReadOnly( TRUE );
	strPlateGauge.setReadOnly( TRUE );
	strPlateLabel.setReadOnly( TRUE );

	VecBX.normalize();
	VecBY.normalize();
	VecBZ.normalize();

	if  ( vecZOffset > 0.0 )
	{
		if( nLength >0 && nDepth>0 && dPlateThickness>0)
		{
			Body BdPlate( _Pt0 - vecZOffset* VecBZ, VecBX, VecBY, VecBZ, (double)nLength ,(double)nDepth, dPlateThickness );
			dp.draw(BdPlate);
		}
	}
	else
	{
		Body BdPlate( _Pt0, VecBX, VecBY, VecBZ, (double)nLength ,dPlateThickness , (double)nDepth );
		dp.draw(BdPlate);
	}
}
#End
#BeginThumbnail
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
M=,;LVGVN['+7=^YGD^NY^!^`%5(-0\<>(B!H?AE=,MFZ7FLOM./41#G^=:,'
MPFDU1A+XN\17^K]S:PG[/;CVVKR?THNAJ$GY%+4_'WA[3IQ:K>F^O,[5M;!#
M.Y/IQP/SIL+?$'Q"1_9NA6^A6C?\O.J/OEQZB(=#[$5Z-H_AO1?#T'E:1I=M
M9KC!,,8#-]6ZG\36O2N6J:1YK;?"&SO)%F\5ZWJ&O3`@^5)(8;<'VC4_UKN=
M+T32]%@%OIFGVUG%_=@B"9^N.OXUI44BPHHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`JWEC:ZA;M!=VT-S"W6.:,.I_`\5G:1X6T'09&DTO1[*SD<DL\,*JQ_'KCV
MK;HH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
3`****`"BBB@`HHHH`****`/_V8HH
`


#End
