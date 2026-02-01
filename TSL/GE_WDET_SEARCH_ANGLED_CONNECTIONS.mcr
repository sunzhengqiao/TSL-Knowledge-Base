#Version 8
#BeginDescription
Finds angled connections between carrying wall and proper cleaned up walls connected to it. Then applies proper tsl according to connection type (creates 1 child tsl per connection). 
PLEASE NOTICE: All these tsl ARE NECESARRY on the drawing
- GE_WALLS_SKEWED_TEE_CONNECTION
- GE_WDET_AUTOLADDER
- GE_WALLS_MITER_TO_MITER_ANGLED
v1.1: 21.jul.2012: David Rueda (dr@hsb-cad.com)
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
*************************************************************************
 COPYRIGHT
 ---------
 Copyright (C) 2007 by
 hsbSOFT N.V.
 ECUADOR

 The program may be used and/or copied only with the written
 permission from hsbSOFT N.V., or in accordance with
 the terms and conditions stipulated in the agreement/contract
 under which the program has been supplied.
 All rights reserved.
*************************************************************************

REVISION HISTORY
* -------------------------
v1.1: 21.jul.2012: David Rueda (dr@hsb-cad.com)
	- Description updated
	- Thumbnail added
v1.0: 	08-Dic-2010: 	David Rueda (dr@hsb-cad.com): 	- Release

*/ 

double dTol=U(0.01,0.0001);
String sSkewedTslName="GE_WALLS_SKEWED_TEE_CONNECTION";
String sMiter2MiterTslName="GE_WALLS_MITER_TO_MITER_ANGLED";

if(_bOnInsert)
{
	_Element.append(getElement(T("|Select element|")));
	return;
}

//Checking element selected
if(_Element.length()==0)
{
	reportMessage("\n"+T("|No element selected|"));
	return;
}

//Casting to wall
if(!_Element0.bIsKindOf(Wall()))
{
	reportMessage("\n"+T("|No valid wall selected|"));
	return;
}

//Casting to elementwall
Element el1=_Element0;
ElementWall elWallThis = (ElementWall) el1;
if (!elWallThis.bIsValid()) return;

//Get elements vector. 
CoordSys csEl1=el1.coordSys();
Vector3d vx1=csEl1.vecX();
_Pt0=csEl1.ptOrg();
																			
//Get all elements conected to this wall
Element elAllConnected[]=elWallThis.getConnectedElements();
if(elAllConnected.length()==0)
{
	eraseInstance();
	return;
}

PLine plEl1=el1.plOutlineWall();
for(int e=0;e<elAllConnected.length();e++)
{
	Element el2=elAllConnected[e];																						
	CoordSys csEl2=el2.coordSys();
	Vector3d vx2=csEl2.vecX();
																																		el2.plOutlineWall().vis(1);
	if(!vx2.isPerpendicularTo(vx1)//Filtering out perpendicular walls
	&&!vx2.isParallelTo(vx1))//Filtering out paralell walls
	{
		//Getting contact points
		PLine plEl2=el2.plOutlineWall();
		Point3d ptAllInt[]=plEl1.intersectPLine(plEl2);
		int nPoints=ptAllInt.length();
		if(nPoints<1||nPoints>2)// Valid cases only when there is 1 or 2 points exclusively
		{
			reportMessage("\n"+T("|Warning|")+" : "+T("|Connection between wall|")+" "+el1.code()+"-"+el1.number()+" "+T("|and|")+" "+el2.code()+"-"+el2.number()+" "+T("|cannot be established. Check proper clean up|")+".\n"); 
			continue;
		}
		//Defining cases (see "Possible angled connections analysis.dwg")
		if(nPoints==1)
		{
			
		}
		else if(nPoints==2)
		{
			Point3d ptCon1=ptAllInt[0];
			Point3d ptCon2=ptAllInt[1];
			int nEl1HasCon1, nEl1HasCon2, nEl2HasCon1, nEl2HasCon2; 
			nEl1HasCon1=nEl1HasCon2=nEl2HasCon1=nEl2HasCon2=false;
			//Checking cioncident vertex
			//Element 1
			Point3d ptAllEl1[]=plEl1.vertexPoints(1);
			for(int p=0;p<ptAllEl1.length();p++)
			{
				if((ptAllEl1[p]-ptCon1).length()<dTol)
				{
						nEl1HasCon1=true;
				}
				if((ptAllEl1[p]-ptCon2).length()<dTol)
				{
						nEl1HasCon2=true;
				}
			}
			
			Point3d ptAllEl2[]=plEl2.vertexPoints(1);
			for(int p=0;p<ptAllEl2.length();p++)
			{
				if((ptAllEl2[p]-ptCon1).length()<dTol)
				{
						nEl2HasCon1=true;
				}
				if((ptAllEl2[p]-ptCon2).length()<dTol)
				{
						nEl2HasCon2=true;
				}
			}
			
			//Defining if is skewed or mitre connection
			//Mitre
			if(nEl1HasCon1&&nEl1HasCon2//el1 has 2 coincident vertexes -> el1 is male
			&& nEl2HasCon1&&nEl2HasCon2) //el2 has 2 coincident vertexes -> el2 is male
			{
																																					el2.plOutlineWall().vis(4);
				//Clone	MITERED connection tsl
				//PREPARE TO CLONING - MUST ALWAYS CLONE, ASUMES THAT CLONED TSL WILL ERASE ITSELF (IT DOES)
				// declare tsl props 
				TslInst tsl;
				String sScriptName = sMiter2MiterTslName;
				Vector3d vecUcsX = _XW;
				Vector3d vecUcsY = _YW;
				Beam lstBeams[0];
				Entity lstEnts[2];
				Point3d lstPoints[1];
				int lstPropInt[0];
				double lstPropDouble[0];
				String lstPropString[0];
				//lstPropInt.append();
				//lstPropDouble.append();
				//lstPropString.append();
				lstEnts[0] = el1;
				lstEnts[1] = el2;
				tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );				//reportMessage("\n"+T("|Connection between wall|")+" "+el1.code()+"-"+el1.number()+" "+T("|and|")+" "+el2.code()+"-"+el2.number()+" :"+T("|Mitre|")+".\n"); 
				continue
			}
			else if(
				(nEl1HasCon1&&nEl1HasCon2&& !nEl2HasCon1&&!nEl2HasCon2)	//el1 has 2 coincident vertexes and el2 has NONE coincident vertexes
				||																										//OR
				(!nEl1HasCon1&&!nEl1HasCon2&& nEl2HasCon1&&nEl2HasCon2)	//el1 has NONE coincident vertexes and el2 has 2 coincident vertexes
				)																								//SKEWED CONNECTION
			{
																																					el2.plOutlineWall().vis(4);
				//Clone	SKEWED connection tsl
				//PREPARE TO CLONING - MUST ALWAYS CLONE, ASUMES THAT CLONED TSL WILL ERASE ITSELF (IT DOES)
				// declare tsl props 
				TslInst tsl;
				String sScriptName = sSkewedTslName;
				Vector3d vecUcsX = _XW;
				Vector3d vecUcsY = _YW;
				Beam lstBeams[0];
				Entity lstEnts[2];
				Point3d lstPoints[1];
				int lstPropInt[0];
				double lstPropDouble[0];
				String lstPropString[0];
				//lstPropInt.append();
				//lstPropDouble.append();
				//lstPropString.append();
				lstEnts[0] = el1;
				lstEnts[1] = el2;
				tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );				//reportMessage("\n"+T("|Connection between wall|")+" "+el1.code()+"-"+el1.number()+" "+T("|and|")+" "+el2.code()+"-"+el2.number()+" :"+T("|Skewed|")+".\n"); 

				continue
			}
			
		}
		reportMessage("\n"+T("|Warning|")+" : "+T("|Connection between wall|")+" "+el1.code()+"-"+el1.number()+" "+T("|and|")+" "+el2.code()+"-"+el2.number()+" "+T("|cannot be established. Check proper clean up|")+".\n"); 
	}
}	
eraseInstance();
return;






#End
#BeginThumbnail
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
M2[C)&X@$@]&'0_E_*M:RN1=VJ2C&2,,!V/>GW,"W-M)"W`88SZ'L:P]'N&M;
MQ[67@,<8)Z,/\X_*MOCAYHY7^ZJWZ2_,Z&J.JVGVJS;:,R)\R\<GU'^?:KU%
M9)V=T=$HJ47%F/H-UOB:V8\I\R_3O^O\ZV*YN\C;3-56:-?D)WJ.V.XZ?YR*
MZ)'62-70Y5@"#[5I56O,NICAY.SA+=#J***R.@****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`*P=<MS%.EW&2-Q`)!Z,.A_+^5;U17,
M"W-M)"W`88SZ'L:N$N65S*M3YX-#+*Y%W:I*,9(PP'8]ZL5SVCW#6MX]K+P&
M.,$]&'^<?E5Z]UF&`;8"LTGL?E'X]_PJI4WS61%.O'V?-)DFL6Z36#.2JM'\
MRD\?A^/\\56T&ZWQ-;,>4^9?IW_7^=4H[>]U>7S)&*QYR&;.T>RC\/TYK9LM
M-@LQE1OD_OL.1]/2JE:,.5O4SAS3J^TBK+\RY1116!V!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!BZKILD]W')`N3)\K^@(
M[G\/Y>]36>BPP$/.1*^.A'RC\.]:E%:>TE:QC["',YV"BBBLS8****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
7`HHHH`****`"BBB@`HHHH`****`/_]DH
`

#End
