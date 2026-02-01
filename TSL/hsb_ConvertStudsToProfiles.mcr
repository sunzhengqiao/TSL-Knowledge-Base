#Version 8
#BeginDescription
Last modified by: Alberto Jena (ajena@itw-industry.com)
20.10.2015  -  version 1.3










#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2013 by
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
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 20.10.2015
* version 1.0: Release Version
*
*/

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                      Properties

_ThisInst.setSequenceNumber(120);

// declare a property with the names of the extrusion profiles
PropString sProfile(0, ExtrProfile().getAllEntryNames(), T("|Extrusion profile name|"));

String sArNY[] = {T("No"), T("Yes")};

PropString psExtType(1, "I;J;",  T("Code Profile Wall"));

PropString sMes1(2, "----------", T("Beams to Ignore"));
sMes1.setReadOnly(true);

PropString sTopPlate(3, sArNY, T("Top Plate"));
sTopPlate.setDescription("");

PropString sBottomPlate(4, sArNY, T("Bottom Plate"));
sBottomPlate.setDescription("");

PropString sBlocking(5, sArNY, T("Blocking"));
sBlocking.setDescription("");

PropString sAllOpBeams(6, sArNY, T("Ignore all opening beams"));
sAllOpBeams.setDescription("This will ignore cripples, king studs, sill, transom, jacks");

PropString sCripple(7, sArNY, T("First Cripple"));
sCripple.setDescription("");

PropString sAllCripples(8, sArNY, T("All Cripples"));
sAllCripples.setDescription("");

PropString sKingStud(9, sArNY, T("King Studs"));
sKingStud.setDescription("");

PropString sIgnoreJacks(10, sArNY, T("Jacks Above/Below Opening "));
sIgnoreJacks.setDescription("");

PropString sStuds(11, sArNY, T("Left/Right Studs"));
sStuds.setDescription("");

PropString sOpBeams(12, sArNY, T("Sill/Transom"));
sOpBeams.setDescription("");

PropString sHeader(15, sArNY, T("Header"));
sHeader.setDescription("");

PropString sPacker(13, sArNY, T("Packer"));
sPacker.setDescription("");

PropString sbmCode (14,"",T("Exclude Beams with Code"));
sbmCode.setDescription(T("Please fill the codes that you dont need to be convert, use ';' if you want to filter more that 1 code"));

PropDouble dMinLength(0, U(0), T("Minimum length of beam"));
dMinLength.setDescription(T("If 0 is set then it wont use this filter"));


if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey); 


int bBlocking = sArNY.find(sBlocking,0);
int bTopPlate = sArNY.find(sTopPlate,0);
int bBottomPlate = sArNY.find(sBottomPlate,0);
int bCripple = sArNY.find(sCripple,0);
int bStuds = sArNY.find(sStuds,0);
int bOpBeams = sArNY.find(sOpBeams,0);
int bHeader = sArNY.find(sHeader,0);
int bPacker = sArNY.find(sPacker,0);
int bAllOpBeams = sArNY.find(sAllOpBeams,0);

int bAllCripples= sArNY.find(sAllCripples,0);
int bKingStud= sArNY.find(sKingStud,0);
int bIgnoreJacks= sArNY.find(sIgnoreJacks,0);


//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                           Insert

if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();
	PrEntity ssE("\n"+T("Select a set of elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}


String sAllBmCodes[0];
String sBeamType=sbmCode;
sBeamType.trimLeft();
sBeamType.trimRight();
sBeamType=sBeamType+";";
for (int i=0; i<sBeamType.length(); i++)
{
	String str=sBeamType.token(i);
	str.trimLeft();
	str.trimRight();
	str.makeUpper();
	if (str.length()>0)
		sAllBmCodes.append(str);
}


if( _Element.length()==0 ){
	eraseInstance();
	return;
}

//Fill and array with the code of the firewalls

String sArrExtCode[0];
String sExtType=psExtType;
sExtType.trimLeft();
sExtType.trimRight();
sExtType=sExtType+";";
for (int i=0; i<sExtType.length(); i++)
{
	String str=sExtType.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
		sArrExtCode.append(str);
}

//-----------------------------------------------------------------------------------------------------------------------------------
//          Loop over all elements.

ElementWallSF elWall[0];

for( int e=0; e<_Element.length(); e++ )
{
	ElementWallSF el = (ElementWallSF) _Element[e];
	if (el.bIsValid())
	{
		String sCode = el.code();
		if( sArrExtCode.find(sCode) != -1 )
		{
			elWall.append(el);
		}
	}
}

int nBmTypeToAvoid[0];

if (bBlocking)
{
	nBmTypeToAvoid.append(_kSFBlocking);
}

if (bTopPlate)
{
	nBmTypeToAvoid.append(_kSFTopPlate);
	nBmTypeToAvoid.append(_kSFAngledTPLeft);
	nBmTypeToAvoid.append(_kSFAngledTPRight);
}

if (bBottomPlate)
	nBmTypeToAvoid.append(_kSFBottomPlate);

if (bOpBeams)
{
	nBmTypeToAvoid.append(_kHeader);
	nBmTypeToAvoid.append(_kSill);
	nBmTypeToAvoid.append(_kSFTransom);
	//
}

if (bHeader)
{
	nBmTypeToAvoid.append(_kHeader);
}

if (bPacker)
{
	nBmTypeToAvoid.append(_kSFPacker);
}

if (bAllCripples)
{
	nBmTypeToAvoid.append(_kSFSupportingBeam);
}

if (bKingStud)
{
	nBmTypeToAvoid.append(_kKingStud);
}

if (bIgnoreJacks)
{
	nBmTypeToAvoid.append(_kSFJackOverOpening);
	nBmTypeToAvoid.append(_kSFJackUnderOpening);
}

if(bAllOpBeams)
{
	nBmTypeToAvoid.append(_kHeader);
	nBmTypeToAvoid.append(_kSill);
	nBmTypeToAvoid.append(_kSFTransom);
	nBmTypeToAvoid.append(_kSFPacker);
	nBmTypeToAvoid.append(_kSFJackOverOpening);
	nBmTypeToAvoid.append(_kSFJackUnderOpening);
	nBmTypeToAvoid.append(_kSFSupportingBeam);
	nBmTypeToAvoid.append(_kKingStud);

}


int nErase=false;

for( int e=0; e<elWall.length(); e++ )
{
	ElementWallSF el=elWall[e];
	CoordSys csEl=el.coordSys();
	Vector3d vx=csEl.vecX();
	Vector3d vy=csEl.vecY();
	Vector3d vz=csEl.vecZ();
	Point3d ptOrgEl=csEl.ptOrg();
	_Pt0=ptOrgEl;
	
	Plane pln (ptOrgEl, vz);
	
	PLine plEnvEl=el.plEnvelope();
	Point3d ptVertexEl[]=plEnvEl.vertexPoints(FALSE);
	
	//Some values and point needed after
	Point3d ptFront=el.zone(1).coordSys().ptOrg(); ptFront.vis(1);
	Point3d ptBack=el.zone(-1).coordSys().ptOrg(); ptBack.vis(1);
	
	double dWallThickness=abs(vz.dotProduct(ptFront-ptBack));
	
	Beam bmAll[]=el.beam();
	Beam bmAllVer[]=vx.filterBeamsPerpendicularSort(bmAll);
	
	if (bmAll.length()<=0)
	{
		continue;
	}
	
	String sHandleToAvoid[0];
	if(bmAllVer.length()>1 && bStuds)
	{
		sHandleToAvoid.append(bmAllVer[0].handle());
		sHandleToAvoid.append(bmAllVer[bmAllVer.length()-1].handle());
	}
	
	String sModuleNames[0];
	Point3d ptCenterModules[0];
	
	if (bCripple)
	{
		Beam bmCripples[0];
		for (int i=0; i<bmAllVer.length(); i++)
		{
			if (bmAllVer[i].type() == _kSFSupportingBeam)
				bmCripples.append(bmAllVer[i]);
		}
		Opening opAll[]=el.opening();
		for (int i=0; i<opAll.length(); i++)
		{
			PLine plOp=opAll[i].plShape();
			Point3d ptAll[]=plOp.vertexPoints(false);
			Point3d ptCenterOp;
			ptCenterOp.setToAverage(ptAll);
			
			PlaneProfile ppOp(csEl);
			ppOp.joinRing(plOp, false);
			ppOp.shrink(-U(150));
			Beam bmValidIntersection[0];
			for (int j=0; j<bmCripples.length(); j++)
			{
				PlaneProfile ppBm(csEl);
				ppBm=bmCripples[j].envelopeBody().extractContactFaceInPlane(pln, U(20));
				if (ppBm.intersectWith(ppOp))
				{
					bmValidIntersection.append(bmCripples[j]);
					String sModule=bmCripples[j].module();
					if (sModuleNames.find(sModule, -1) == -1)
					{
						sModuleNames.append(sModule);
						ptCenterModules.append(ptCenterOp);
					}
				}
			}
			bmValidIntersection=vx.filterBeamsPerpendicularSort(bmValidIntersection);
			for (int j=0; j<bmValidIntersection.length(); j++)
			{
				if (vx.dotProduct(bmValidIntersection[j].ptCen()-ptCenterOp)>0)
				{
					if (j>0)
					{
						sHandleToAvoid.append(bmValidIntersection[j-1].handle());
						sHandleToAvoid.append(bmValidIntersection[j].handle());
						break;
					}
				}
			}
		}
	}
	
	Beam bmToConvert[0];

	for (int i=0; i<bmAll.length(); i++)
	{
		Beam bm=bmAll[i];
		int nType=bm.type();
		String sCode=bm.beamCode().token(0);
		sCode.makeUpper();
		String sHandle=bm.handle();
		
		//if (abs(bm.dW()-dValidWidth)<U(1) && abs(bm.dH()-dValidHeight)<U(1))
		{
			if ((nBmTypeToAvoid.find(nType, -1) == -1 && sHandleToAvoid.find(sHandle, -1) == -1) && sAllBmCodes.find(sCode, -1) == -1)
			{
				double dBmLen=bm.solidLength();
				if (dMinLength!=0 && dBmLen<dMinLength)
				{
					continue;
				}
				
				bmToConvert.append(bm);
			}
		}
	}
	
	for (int b=0; b<bmToConvert.length(); b++)
	{
		Beam bm=bmToConvert[b];
		bm.setExtrProfile(sProfile);

		
	}
	nErase=true;
}

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                 Erase instance

if (_bOnElementConstructed || nErase)
{
	//reportNotice("\nTrue");
	eraseInstance();
	return;
}

#End
#BeginThumbnail


#End