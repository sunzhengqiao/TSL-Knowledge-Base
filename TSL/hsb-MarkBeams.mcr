#Version 8
#BeginDescription
Last modified by: SupportUK (support.uk@hsbcad.com)

1.8 22/02/2023 Add Back Face and check if the marking line is inside of the beam. AJ
13.01.2021  -  version 1.7




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 8
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT IRELAND
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
* Created by: Mihai Bercuci 
* date: 28.09.2017 
* version 1.1

* Created by: Mihai Bercuci 
* date: 23.10.2017
* version 1.2
*
*/

Unit (1, "mm");

String sSides[]={T("Intersection Face"), T("Front Face"), T("Back Face")};

String sMarkingOptions[]={T("Left & Right"), T("Center")};

PropString sMode (0, sSides, T("Marking side"), 0);

PropString sMarkingSide (2, sMarkingOptions, T("Marking options"), 0);

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");

PropString genBeamFilterDefinition(1, filterDefinitions, T("|Filter definition for beams to mark|"));
genBeamFilterDefinition.setDescription(T("|Filter definition for beams to mark.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));

int nSideType = sSides.find(sMode, 0);
int nMarkingOptions = sMarkingOptions.find(sMarkingSide, 0);

if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert )
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialog();

	PrEntity ssE(T("Select one or More Elements"), Element());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	//Insert the TSL again for each Element
	TslInst tsl;
	String sScriptName = scriptName(); // name of the script
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Entity lstEnts[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	
	//lstPropInt.append(nZones1);
	//lstPropDouble.append(dSpacingEdge1);
	lstPropString.append(sMode);
	lstPropString.append(genBeamFilterDefinition);
	lstPropString.append(sMarkingSide);
	
	Map mpToClone;
	mpToClone.setInt("ExecutionMode",0);

	for (int i=0; i<_Element.length(); i++)
	{
		lstEnts.setLength(0);
		lstEnts.append(_Element[i]);
		tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
	}

	//_Element.append(getElement(T("Select an element")));
	_Map.setInt("ExecutionMode",0);
	eraseInstance();
	return;
}


if( _Element.length() == 0 ){
	eraseInstance();
	return;
}

for ( int e = 0; e < _Element.length(); e++)
{
	Element el = _Element[e];
	Vector3d vz = el.vecZ();
	Beam arBm[] = el.beam();
	_Pt0 = el.ptOrg();
	
	TslInst tslAll[]=el.tslInstAttached();
	for (int i=0; i<tslAll.length(); i++)
	{
		if ( tslAll[i].scriptName() == scriptName() && tslAll[i].handle() != _ThisInst.handle() )
		{
			tslAll[i].dbErase();
		}
	}
	
	//reportNotice ("\n"+el.number());
		
	Entity genBeamEntities[0];{ }
	for (int b=0;b<arBm.length();b++)
	{
		genBeamEntities.append(arBm[b]);
	}
	
	Map filterGenBeamsMap;
	filterGenBeamsMap.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
	int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, genBeamFilterDefinition, filterGenBeamsMap);
	if (!successfullyFiltered) {
		reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
		eraseInstance();
		return;
	} 
	
	Entity filteredGenBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
	Beam bmMarkable[0];
	for (int e=0;e<filteredGenBeamEntities.length();e++) 
	{
		Beam bm = (Beam)filteredGenBeamEntities[e];
		if (!bm.bIsValid()) continue;
	
		bmMarkable.append(bm);
	}
	
	for ( int i = 0; i < bmMarkable.length(); i++)
	{
		Beam bm = bmMarkable[i];//Male beam
		Beam arBmT[] = bm.filterBeamsTConnection(bmMarkable, U(1), TRUE);
		Body bd = bm.realBody();
		bd.vis();
		for ( int j = 0; j < arBmT.length(); j++)
		{
			Beam bmT = arBmT[j];
			int bIsValidMark = TRUE;
			Vector3d v1 = bmT.vecY();
			v1.vis(bmT.ptCen(), 1);
			
			if ( bm.vecX().isPerpendicularTo(bmT.vecX()) )
			{
				if ( ! bm.vecD(vz).isParallelTo(bmT.vecD(vz)) && ! bm.vecD(vz).isParallelTo(vz) )
				{
					bIsValidMark = FALSE;
				}
			}
			else //beams NOT perpendicular
			{
				if ( ! bm.vecD(vz).isParallelTo(bmT.vecD(vz)) )
				{
					bIsValidMark = FALSE;
				}
			}
			
			if ( bIsValidMark )
			{
				Vector3d vy = el.vecZ().crossProduct(bm.vecX());
				//vy.vis(bm.ptCen(), 2);
				Vector3d vNormal = bmT.vecY();
				
				//vNormal.vis(bm.ptCen(), 3);
				Line lnBmX(bm.ptCen(), bm.vecX());
				Vector3d vecBmT = bmT.vecY();
				vecBmT.vis(bm.ptCen(), 4);
				//variable for marking the cut
				
				
				if ( vecBmT.isPerpendicularTo(bm.vecX()) )
				{
					Vector3d vzMark = bmT.vecZ();
					vzMark.vis(bmT.ptCen(), 5);
					vecBmT = bmT.vecZ();
					vNormal = vecBmT;
				}
				
				Point3d ptIntersect = lnBmX.intersect(Plane(bmT.ptCen(), vecBmT), 0);
				
				ptIntersect.vis();
				if ( vecBmT.dotProduct(bm.ptCen() - ptIntersect) < 0 )
				{
					vNormal = - vNormal;
				}
				
				Vector3d vCut = vNormal;
				if (nSideType == 1) //Front face
				{
					//vCut = bm.vecZ();
					vCut = vz;
					//vCut =  el.vecY().crossProduct(bm.vecZ());
				}
				else if (nSideType == 2) //Back face
				{
					vCut = - vz;
				}
				
				Plane pnMark(ptIntersect + vNormal * 0.5 * bmT.dD(vNormal), vNormal);
				
				PlaneProfile ppThisBeam(pnMark);
				ppThisBeam = bmT.realBody().shadowProfile(pnMark);
				
				Point3d ptMark1 = bm.ptCen() - vy * 0.5 * bm.dD(vy);
				Point3d ptMark2 = bm.ptCen() + vy * 0.5 * bm.dD(vy);
				Point3d ptMarkCenter = bm.ptCen();
				Line lnMark1(ptMark1, bm.vecX());
				Line lnMark2(ptMark2, bm.vecX());
				Line lnMarkCenter(ptMarkCenter, bm.vecX());
				
				
				//				reportNotice("\nElement: "+el.code()+el.number());
				//				reportNotice(T("\nNo intersection found for bm: ")+bm.posnum()+T(" & bm: ")+bmT.posnum());
				
				ptMark1 = lnMark1.intersect(pnMark, 0);//ptMark1.vis(3);
				ptMark2 = lnMark2.intersect(pnMark, 0);//ptMark2.vis(3);
				ptMarkCenter = lnMarkCenter.intersect(pnMark, 0);
				
				if (nMarkingOptions == 1)
				{
					Mark mrk(ptMarkCenter, vCut);
					bmT.addTool(mrk);
				}
				else
				{
					if (ppThisBeam.pointInProfile(ptMark1)==_kPointInProfile)
					{
						Mark mrk1(ptMark1, vCut);
						//vCut.vis(bm.ptCen(), 6);
						bmT.addTool(mrk1);
					}
					if (ppThisBeam.pointInProfile(ptMark2)==_kPointInProfile)
					{
						Mark mrk2(ptMark2, vCut);
						//vCut.vis(bm.ptCen(), 6);
						bmT.addTool(mrk2);
					}
				}
			}
		}
	}
	Display dp(1);
	PLine pl1(_ZU);
	pl1.addVertex(_Pt0);
	pl1.addVertex(_Pt0 -el.vecX() * 5);
	dp.draw(pl1);
}


#End
#BeginThumbnail
M_]C_X``02D9)1@`!``$`8`!@``#__@`?3$5!1"!496-H;F]L;V=I97,@26YC
M+B!6,2XP,0#_VP"$`#DG*S(K)#DR+S)!/3E$5I!>5D]/5K%^A6B0T;C<V<ZX
MRL?G____Y_;_^<?*____________X/____________\!/4%!5DQ6JEY>JO_N
MRN[_________________________________________________________
M___________$`:(```$%`0$!`0$!```````````!`@,$!08'"`D*"P$``P$!
M`0$!`0$!`0````````$"`P0%!@<("0H+$``"`0,#`@0#!04$!````7T!`@,`
M!!$%$B$Q008346$'(G$4,H&1H0@C0K'!%5+1\"0S8G*""0H6%Q@9&B4F)R@I
M*C0U-C<X.3I#1$5&1TA)2E-455976%E:8V1E9F=H:6IS='5V=WAY>H.$A8:'
MB(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4U=;7
MV-G:X>+CY.7FY^CIZO'R\_3U]O?X^?H1``(!`@0$`P0'!00$``$"=P`!`@,1
M!`4A,08205$'87$3(C*!"!1"D:&QP0DC,U+P%6)RT0H6)#3A)?$7&!D:)B<H
M*2HU-C<X.3I#1$5&1TA)2E-455976%E:8V1E9F=H:6IS='5V=WAY>H*#A(6&
MAXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&Q\C)RM+3U-76
MU]C9VN+CY.7FY^CIZO+S]/7V]_CY^O_``!$(`H@#O0,!$0`"$0$#$0'_V@`,
M`P$``A$#$0`_`-*@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@"E>?ZX?[O^-0]RUL0CK0,=0`4"$-`QM`!2
M`6F`&@!!UH`#2`2@!PI@+2`*8!0`E`!0`4`%`!0`4`+0`4`)2`;0`@I@+WH$
M)WH&/'2@`/2D`T4`/I@)0(0T#()OO?A30F,IDA0`&@!*`%H`*`"@`H`2@!10
M`4`%`!0`"@#7L_\`CUC^G]:$#)Z8@H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`"0!D\"@"%YQT3D^IZ5+EV*4>Y`22VXG)]34E"$T`
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
.H`*`"@`H`*`"@`H`_]D`
`








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
      <str nm="COMMENT" vl="Add Back Face and check if the marking line is inside of the beam." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="2/22/2023 10:17:46 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End