#Version 8
#BeginDescription
Last modified by: Alberto Jena (aj@hsb-cad.com)
16.11.2021  -  version 1.11
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 11
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2009 by
*  hsbSOFT 
*  IRELAND
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
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 01.11.2009
* version 1.0: Release Version
*
* date: 27.03.2012
* version 1.1: Release Version
*
* date: 08.06.2012
* version 1.2: Bugfix with angled plates, increased birdsmouth beamcut to accomodate for steeper angles.  Added Beam types in properties if certain types dont want to be notched.
*
* date: 02.07.2012
* version 1.3: Add tolerance property
*/

_ThisInst.setSequenceNumber(110);

Unit(1,"mm"); // script uses mm

String sArNY[] = {T("No"), T("Yes")};

PropDouble dDepth1 (0, U(8), T("Depth inside Plate"));
dDepth1.setDescription(T("Depth that the Studs are going to be cut inside the top and bottom plate"));

PropDouble dTolerance (1, 0, T("Tolerance"));

PropString sSquareTool(23, sArNY, T("|Square tool to plate|"),0);

PropString sFilterElementByInformation(30, "", T("Exclude elements with Information field"));
sFilterElementByInformation.setDescription(T("Please type the information separated by ; "));
//BEAM TYPES
int nBmType[0];

PropString sbmName00(1, sArNY, T("Jack Over Opening"),1);			sbmName00.setCategory(T("Wall beams to notch"));		nBmType.append(_kSFJackOverOpening);
PropString sbmName01(2, sArNY, T("Jack Under Opening"),1);		sbmName01.setCategory(T("Wall beams to notch"));		nBmType.append(_kSFJackUnderOpening);
PropString sbmName02(3, sArNY, T("Cripple Stud"),1);				sbmName02.setCategory(T("Wall beams to notch"));		nBmType.append(_kCrippleStud);
PropString sbmName03(4, sArNY, T("Transom"),1);					sbmName03.setCategory(T("Wall beams to notch"));		nBmType.append(_kSFTransom);
PropString sbmName04(5, sArNY, T("King Stud"),1);					sbmName04.setCategory(T("Wall beams to notch"));		nBmType.append(_kKingStud);
PropString sbmName05(6, sArNY, T("Sill"),1);							sbmName05.setCategory(T("Wall beams to notch"));		nBmType.append(_kSill);
PropString sbmName06(7, sArNY, T("Angled TopPlate Left"),1);		sbmName06.setCategory(T("Wall beams to notch"));		nBmType.append(_kSFAngledTPLeft);
PropString sbmName07(8, sArNY, T("Angled TopPlate Right"),1);		sbmName07.setCategory(T("Wall beams to notch"));		nBmType.append(_kSFAngledTPRight);
PropString sbmName08(9, sArNY, T("TopPlate"),1);					sbmName08.setCategory(T("Wall beams to notch"));		nBmType.append(_kSFTopPlate);
PropString sbmName09(10, sArNY, T("Bottom Plate"),1);				sbmName09.setCategory(T("Wall beams to notch"));		nBmType.append(_kSFBottomPlate);
PropString sbmName10(11, sArNY, T("Blocking"),1);					sbmName10.setCategory(T("Wall beams to notch"));		nBmType.append(_kSFBlocking);
PropString sbmName11(12, sArNY, T("Supporting Beam"),1);			sbmName11.setCategory(T("Wall beams to notch"));		nBmType.append(_kSFSupportingBeam);
PropString sbmName12(13, sArNY, T("Stud"),1);						sbmName12.setCategory(T("Wall beams to notch"));		nBmType.append(_kStud);
PropString sbmName13(14, sArNY, T("Stud Left"),1);					sbmName13.setCategory(T("Wall beams to notch"));		nBmType.append(_kSFStudLeft);
PropString sbmName14(15, sArNY, T("Stud Right"),1);				sbmName14.setCategory(T("Wall beams to notch"));		nBmType.append(_kSFStudRight);
PropString sbmName15(16, sArNY, T("Header"),1);					sbmName15.setCategory(T("Wall beams to notch"));		nBmType.append(_kHeader);
PropString sbmName16(17, sArNY, T("Brace"),1);						sbmName16.setCategory(T("Wall beams to notch"));		nBmType.append(_kBrace);
PropString sbmName17(18, sArNY, T("Locating Plate"),1);				sbmName17.setCategory(T("Wall beams to notch"));		nBmType.append(_kLocatingPlate);
PropString sbmName18(19, sArNY, T("Packer"),1);					sbmName18.setCategory(T("Wall beams to notch"));		nBmType.append(_kSFPacker);
PropString sbmName19(20, sArNY, T("SolePlate"),1);					sbmName19.setCategory(T("Wall beams to notch"));		nBmType.append(_kSFSolePlate);
PropString sbmName20(21, sArNY, T("HeadBinder/Very Top Plate"),1);	sbmName20.setCategory(T("Wall beams to notch"));		nBmType.append(_kBlocking);
PropString sbmName21(22, sArNY, T("Vent"),1);						sbmName21.setCategory(T("Wall beams to notch"));		nBmType.append(_kSFVent);

PropString sbmFloorName00(0, sArNY, T("Rim Board")); 					sbmFloorName00.setCategory(T("Floor beams to notch"));	nBmType.append(_kRimBeam);
PropString sbmFloorName01(24, sArNY, T("Joist")); 						sbmFloorName01.setCategory(T("Floor beams to notch"));	nBmType.append(_kJoist);
PropString sbmFloorName02(25, sArNY, T("Trimmer")); 					sbmFloorName02.setCategory(T("Floor beams to notch"));	nBmType.append(_kFloorBeam);
PropString sbmFloorName03(26, sArNY, T("Rim Joist")); 					sbmFloorName03.setCategory(T("Floor beams to notch"));	nBmType.append(_kRimJoist);
PropString sbmFloorName04(27, sArNY, T("Blocking")); 					sbmFloorName04.setCategory(T("Floor beams to notch"));	nBmType.append(_kBlocking);
PropString sbmFloorName05(28, sArNY, T("Packers")); 					sbmFloorName05.setCategory(T("Floor beams to notch"));	nBmType.append(_kExtraBlock);
PropString sbmFloorName06(29, sArNY, T("Strongbacks")); 				sbmFloorName06.setCategory(T("Floor beams to notch"));	nBmType.append(_kSupportingCrossBeam);

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}

	if (_kExecuteKey=="")
		showDialogOnce();

	PrEntity ssE(T("Please select Elements"),Element());
 	if (ssE.go())
	{
 		Entity ents[0];
 		ents = ssE.set();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			Element el = (Element) ents[i];
			if (el.bIsValid())
 				_Element.append(el);
 		 }
 	}
 	
 	return;
}

int nSquareTool = sArNY.find(sSquareTool, 0);

String sNotch[0];
sNotch.setLength(0);
sNotch.append(sbmName00);
sNotch.append(sbmName01);
sNotch.append(sbmName02);
sNotch.append(sbmName03);
sNotch.append(sbmName04);
sNotch.append(sbmName05);
sNotch.append(sbmName06);
sNotch.append(sbmName07);
sNotch.append(sbmName08);
sNotch.append(sbmName09);
sNotch.append(sbmName10);
sNotch.append(sbmName11);
sNotch.append(sbmName12);
sNotch.append(sbmName13);
sNotch.append(sbmName14);
sNotch.append(sbmName15);
sNotch.append(sbmName16);
sNotch.append(sbmName17);
sNotch.append(sbmName18);
sNotch.append(sbmName19);
sNotch.append(sbmName20);
sNotch.append(sbmName21);
sNotch.append(sbmFloorName00);
sNotch.append(sbmFloorName01);
sNotch.append(sbmFloorName02);
sNotch.append(sbmFloorName03);
sNotch.append(sbmFloorName04);
sNotch.append(sbmFloorName05);
sNotch.append(sbmFloorName06);

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

//Fill the values for the externall Walls
String sElementFilter[0];
String sInformation=sFilterElementByInformation;
sInformation.trimLeft();
sInformation.trimRight();
sInformation=sInformation+";";
for (int i=0; i<sInformation.length(); i++)
{
	String str=sInformation.token(i);
	str.trimLeft();
	str.trimRight();
	str.makeUpper();
	if (str.length()>0)
		sElementFilter.append(str);
}

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	
	CoordSys csEl=el.coordSys();
	Vector3d vx=csEl.vecX();
	Vector3d vy=csEl.vecY();
	Vector3d vz=csEl.vecZ();
	
	String sElementInformation = el.information();
	sElementInformation.trimLeft();
	sElementInformation.trimRight();
	sElementInformation.makeUpper();
	
	if (sElementFilter.find(sElementInformation, -1) != -1)
	{ 
		continue;
	}
	
	Beam bmAll[]=el.beam();
	if (bmAll.length()<1)	
	{
		return;
	}
	
	//TrussData
	TrussEntity entTruss[0];
	Beam bmToErase[0];
	//Check if there are any space joists
	Group grpElement = el.elementGroup();
	Entity entElement[] = grpElement.collectEntities(false, TrussEntity(), _kModelSpace);
	for (int i = 0; i < entElement.length(); i++)
	{
		//Get the truss entity
		TrussEntity truss = (TrussEntity) entElement[i];
		if ( ! truss.bIsValid()) continue;
		entTruss.append(truss);
	}
	
	//Get the truss definition data
	String sTrussDefinitions[0];
	double dTrussWidth[0];
	double dTrussHeight[0];
	double dTrussLength[0];
	Point3d ptLocation[0];
	CoordSys csForBeams[0];
	Body bdTrusses[0];
	
	for (int i = 0; i < entTruss.length(); i++)
	{
		TrussEntity truss = entTruss[i];
		String sDefinition = truss.definition();
		CoordSys csTruss = truss.coordSys();
		
		//Get all the beams in the definition
		TrussDefinition trussDef(sDefinition);
		Beam bmTruss[] = trussDef.beam();
		Body bdTruss;
		for (int b = 0; b < bmTruss.length(); b++)
		{
			Beam bm = bmTruss[b];
			if ( ! bm.bIsValid()) continue;
			
			Body bd = bm.envelopeBody();
			bdTruss.combine(bd);
		}
		
		sTrussDefinitions.append(sDefinition);
		
		//Add in the locations for the beams
		//Rotate the point to the truss position as the definition is at 0,0,0
		CoordSys csTransform;
		Point3d pt(0, 0, 0);
		csTransform.setToAlignCoordSys(pt, _XW, _YW, _ZW, csTruss.ptOrg(), csTruss.vecX(), csTruss.vecY(), csTruss.vecZ());
		Point3d ptTrussCen = bdTruss.ptCen();
		ptTrussCen.transformBy(csTransform);
		bdTruss.transformBy(csTransform);
		ptTrussCen.vis();
		bdTruss.vis(2);
		bdTrusses.append(bdTruss);
		ptLocation.append(ptTrussCen);
		csForBeams.append(csTruss);
	}
	
	for (int i = 0; i < sTrussDefinitions.length(); i++)
	{ 
		Beam bmNew;
		bmNew.dbCreate(bdTrusses[i]);
		//bmNew.dbCreate(ptLocation[i], csForBeams[i].vecX(), csForBeams[i].vecY(), csForBeams[i].vecZ(), dTrussLength[i], dTrussHeight[i], dTrussWidth[i]);
		bmNew.setType(_kJoist);
		bmNew.setColor(1);
		bmAll.append(bmNew);
		bmToErase.append(bmNew);
	}

	_Pt0=el.ptOrg();
	Beam bmHor[]=vy.filterBeamsPerpendicular(bmAll);
	Beam bmHeaders[0];
	for (int h=0; h<bmHor.length(); h++)
	{
		if (bmHor[h].type()==_kHeader)
			bmHeaders.append(bmHor[h]);
	}
	for (int i=0; i<bmAll.length(); i++)
	{
		Beam bm=bmAll[i];
		
		int nHeader=FALSE;
		if (bm.type()==_kHeader)
		{
			nHeader=TRUE;
		}
		//	continue;

		//Check if the beam needs to be notched
		
		int nType=bm.type();
		int nIndex=nBmType.find(nType);
		int nNotchBeam=false;

		if(nIndex!=-1)
		{
			nNotchBeam=sArNY.find(sNotch[nIndex]);
		}
		if(!nNotchBeam) continue;
	
		BeamCut bc (bm.ptCen(), bm.vecX(), bm.vecY(), bm.vecZ(), U(1), U(1), U(1), 0,0,0);
		bm.removeToolsStatic(bc);
		
		Beam bmToCut[0];
		bm.realBody().vis(i);
		Beam bmAux[]=bm.filterGenBeamsNotThis(bmAll);
		bmToCut=bm.filterBeamsCapsuleIntersect(bmAux);//, U(10), false
		
		
		
//		bm.realBody().vis(1);
		for (int j=0; j<bmToCut.length(); j++)
		{
			Beam bmCut=bmToCut[j];
			int nIsAngledPlate = FALSE;
			
			if (bmCut.type() == _kSFAngledTPLeft || bmCut.type() == _kSFAngledTPRight ||
			bm.type() == _kSFAngledTPLeft || bm.type() == _kSFAngledTPRight)
			{
				nIsAngledPlate = TRUE;
			}
		
			//Check if the beam needs to be notched
			int nTypeCut=bmCut.type();
			int nIndexCut=nBmType.find(nType);
			int nNotchBeamCut=true;			
			if(nIndex!=-1)
			{
				nNotchBeamCut=sArNY.find(sNotch[nIndexCut]);
			}
			if(!nNotchBeamCut) continue;
			
//			bmCut.realBody().vis(2);
			if (bmCut.dD(vx)>bmCut.dD(vz))
				continue;
			if (bmCut.hasTConnection(bm, U(15), TRUE))
			{
				//Not dealing with the situation where we have two angled plates so check
				if( 
					abs(bm.vecX().dotProduct(vx)) < U(0.99) &&
					abs(bm.vecX().dotProduct(vy)) < U(0.99) && 
					abs(bmCut.vecX().dotProduct(vx)) < U(0.99) &&
					abs(bmCut.vecX().dotProduct(vy)) < U(0.99) 
				)
				{ 
					continue;
				}
				
				Vector3d vecCenters = bm.ptCen() - bmCut.ptCen();
				
				Vector3d vCut=bm.vecD(vecCenters);
				vCut.vis(bmCut.ptCen(), 2);
				Plane pln (bm.ptCen()-vCut*(bm.dD(vCut)*0.5), vCut);
				
				Vector3d vNormalCut=bmCut.vecX();
				if (vCut.dotProduct(vNormalCut)<0)
					vNormalCut=-vNormalCut;
				
				//Check if beam is the first beam intersecting this beam, if not we are not interested
				//This is to mitigate issues where beams skim the edge of other beams
				Beam bmAllButThis[] = bmCut.filterGenBeamsNotThis(bmAll);
				
				Beam intersectingBeams[] = Beam().filterBeamsHalfLineIntersectSort(bmAllButThis, bmCut.ptCen(), vNormalCut, TRUE);
				bmCut.realBody().vis(j);
				vNormalCut.vis(bmCut.ptCen());
				for(int z = 0 ; z < intersectingBeams.length() ; z++)
				{ 
					intersectingBeams[z].realBody().vis(z);
				}
				//No intersections found - this should not happen
				if (intersectingBeams.length() == 0) continue;
				//Its not intersecting with the female beam
				if (intersectingBeams[0] != bm) continue;
				
				
				Point3d ptTmp1=Line(bmCut.ptCen()-vx*U(bmCut.dD(vx)*0.5), bmCut.vecX()).intersect(pln, 0);
				Point3d ptTmp2=Line(bmCut.ptCen()+vx*U(bmCut.dD(vx)*0.5), bmCut.vecX()).intersect(pln, 0);
				Point3d ptInter;
				if (ptTmp1.Z()>=ptTmp2.Z())
				{
					ptInter=Line(bmCut.ptCen(), bmCut.vecX()).closestPointTo(ptTmp1);
				}
				else
				{
					ptInter=Line(bmCut.ptCen(), bmCut.vecX()).closestPointTo(ptTmp2);
				}
				ptInter.vis();
				
				//Cut ctMale (ptInter+vCut*dDepth1, vCut);
				if (nIsAngledPlate)
				{
					if (nSquareTool)
					{
						Vector3d vAngledCut = vCut;
						vAngledCut.normalize();
						double dCosMaleXFemaleX = vAngledCut.dotProduct(bmCut.vecX());
						 
						//Vertical distance between the two vectors
						double dVerticalOffset = abs( dDepth1 / dCosMaleXFemaleX);
						//Horizontal distance between the two vectors
						double dHorizontalOffset = sqrt(pow(dVerticalOffset, 2) - pow(dDepth1, 2));
						
						//Intersection of the male beam with the underside of the female
						Point3d ptTIntersection = bmCut.ptCen().projectPoint(pln, 0, bmCut.vecX());
						Point3d ptIntersectForSquareTool = ptTIntersection + dVerticalOffset * vNormalCut;
						Vector3d vecFemaleXPointingUp = bm.vecX().dotProduct(vNormalCut) > 0 ? bm.vecX() : - bm.vecX();
						
						//The center of the beamcut is the midpoint between the intersection of the male and the underside of the female and 
						// the interesction cut position of the male, of course in the plane of the cut.
						Point3d ptCenterBeamCut = ptIntersectForSquareTool - dHorizontalOffset * 0.5 * vecFemaleXPointingUp;
						
						vAngledCut.vis(ptIntersectForSquareTool, 1);

						Cut ctMale (ptIntersectForSquareTool, vAngledCut);
						bmCut.addToolStatic(ctMale, TRUE);//_kStretchOnToolChange
						
						double dCosMaleYFemaleX = vNormalCut.dotProduct(bm.vecD(vCut)); //Replave vx for vCut AJ
						double dWidthOfMaleCut = abs(bmCut.dD(vCut) / dCosMaleXFemaleX);
						
						// The total width of the cut is going to be the width of the male beam at an angle plus an extra amount which is the horizontal distance between the two vectors
						double dFinalBeamCutWidth = dWidthOfMaleCut + dHorizontalOffset + dTolerance;
						BeamCut bcFemale (ptCenterBeamCut, vz, vAngledCut, vz.crossProduct(vAngledCut), U(500), dDepth1 + U(10), dFinalBeamCutWidth, 0,-1,0 );
						bcFemale.cuttingBody().vis(1);
						bm.addToolStatic(bcFemale);

					}
					else
					{
						Cut ctMale (ptInter, vNormalCut);
						bmCut.addToolStatic(ctMale, TRUE);//_kStretchOnToolChange
						
						BeamCut bcFemale (ptInter, vNormalCut, vz, vNormalCut.crossProduct(vz), U(200), U(500), bmCut.dD(vx), - 1, 0, 0 );
						bcFemale.cuttingBody().vis(2);
						bm.addToolStatic(bcFemale);
					}
				}
				else
				{
					if (nHeader)
					{
						Cut ctMale (ptInter + vNormalCut * dDepth1, vNormalCut);
						bmCut.addToolStatic(ctMale, TRUE);//_kStretchOnToolChange
						
						BeamCut bcFemale (ptInter + vNormalCut * dDepth1, vNormalCut, vz, vNormalCut.crossProduct(vz), U(20), U(500), bmCut.dD(bm.vecX()) + dTolerance, - 1, 0, 0 );
						Body dbNotch = bcFemale.cuttingBody(3);
						dbNotch.vis();
						for (int k = 0; k < bmHeaders.length(); k++)
						{
							if (bmHeaders[k].envelopeBody(FALSE, TRUE).hasIntersection(dbNotch))
							{
									bmHeaders[k].addToolStatic(bcFemale);
							}
						}
					}
					else
					{
						Cut ctMale (ptInter+vNormalCut*dDepth1, vNormalCut);
						bmCut.addToolStatic(ctMale, TRUE);//_kStretchOnToolChange

						BeamCut bcFemale (ptInter+vNormalCut*dDepth1, vNormalCut, vz, vNormalCut.crossProduct(vz), U(20), U(500), bmCut.dD(bm.vecX())+dTolerance, -1,0,0 );
						bcFemale.cuttingBody().vis(4);
						bm.addToolStatic(bcFemale);
					}
				}
			}
		}
	}
	
	for (int i = 0; i < bmToErase.length(); i++)
	{ 
		bmToErase[i].dbErase();
	}
}

eraseInstance();
return;








#End
#BeginThumbnail










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
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End