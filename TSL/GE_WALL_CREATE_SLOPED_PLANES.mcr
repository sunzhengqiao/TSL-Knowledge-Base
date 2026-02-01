#Version 8
#BeginDescription
Creates EroofPlane entities in every angle cut of an element
v1.2: 15.ago.2012: David Rueda (dr@hsb-cad.com)

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
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
*
* v1.2: 15.ago.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Thumbnail added
* v1.1: 10.may.2012: David Rueda (dr@hsb-cad.com)
	- Set red color to roof planes
	- Roof planes assigned to element group
* v1.0: 10.may.2012: David Rueda (dr@hsb-cad.com)
	Release

*/

U(25,1);
double dTolerance= U(1, 0.001);

PropString sDimStyle(0,_DimStyles,"DimStyle");

if(_bOnInsert){
	
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}

	PrEntity ssE("\n"+T("|Select elements|"),Element());	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}

	// Clone TSL per element 
	for( int e=0; e< _Element.length(); e++)
	{
		Element el= _Element[e];
		TslInst tsl;
		String sScriptName = scriptName();
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEnts[0];
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];

		lstEnts.append( el);
		
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString); 
	}
	eraseInstance();
	return;
}

if( _Element.length() == 0 || !_Element[0].bIsValid())
{
	eraseInstance();
	return;
}

Element el= _Element[0];
Point3d ptOrg= el.ptOrg();
Vector3d vx= el.vecX();
Vector3d vy= el.vecY();
Vector3d vz= el.vecZ();
double dElW= el.dBeamWidth();

PLine plEl= el.plEnvelope();
Point3d ptAll[]= plEl.vertexPoints(0);
for( int p=0; p<ptAll.length()-1; p++)
{
	Point3d pt0= ptAll[p];
	Point3d pt1= ptAll[p+1];
	
	// Take out vertical faces
	if( abs( vx.dotProduct( pt0-pt1)) < dTolerance)
	{
		continue;
	}
	
	// Check horizontal faces
	if( abs( vy.dotProduct( pt0-pt1)) < dTolerance)
	{
		// Check base face
		if( abs( vy.dotProduct( pt0-ptOrg)) < dTolerance || abs( vy.dotProduct( pt1-ptOrg)) < dTolerance)
		{
			continue;	
		}
	}
	
	//Create eRoofPlane	
	PLine pl();
	pl.addVertex( pt0);
	pl.addVertex( pt1);
	pl.addVertex( pt1-vz*dElW);
	pl.addVertex( pt0-vz*dElW);
	pl.close();	
	ERoofPlane erPln;
	erPln.dbCreate(pl);
	erPln.setColor(1);
	erPln.assignToElementGroup(el, 1);
}

eraseInstance();
return;

#End
#BeginThumbnail
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
MJ[_H8FF>&-+M-,MK>?3;*69(P))&B#[GQ\QRPSUS6%'X<U#2?':W^FV2_P!F
M2$!UCF"!588;()['YL`$<#&.W<45E'%5(N3;OS:._F;SP-&2BDK<K35K=/D<
M;X>T/4K'QIJNH7-MLM9_.\N3>IW;I`PX!R.!4/C?PG=:K=PW^F0+),1Y<Z;E
M7./NMSC/<'G^[7<452QM15555KI6(EEM&5!T'>S=_._W'&_V'J7_``K7^R/L
MW^G?\\MZ_P#/;=USCISUK&L;'Q[IMG':6D?EP1YVIN@.,DD\GGJ37I=%5''3
M2:<4[N^JOJR)Y93DXRC.47&*CH[:+Y'&Z'_PFO\`;,']K_\`'C\WF_ZG^Z<?
M=YZXZ51U'PEK.DZS)J7AN10)"?W2E5*;LDC!^4J.,>G''&:]`HI+&S4^:,4K
MJS5M'\AO+:<J:A*<FT[IMZKT9YQ+X=\8>(MD6L7,<,$3@@.4YSP2%CX)`]2.
MO'4UZ';P1VMM%;PKMBB0(BY)PH&`.:DHK.MB954DTDET6B-L-@X8=N2;;>[;
MNPHHHKG.L****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
*HHHH`****`/_V8HH
`

#End
