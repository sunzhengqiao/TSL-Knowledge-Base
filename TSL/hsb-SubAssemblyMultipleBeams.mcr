#Version 8
#BeginDescription
Last modified by: Alberto Jena (as@hsb-cad.com)
06.03.2009  -  version 1.1




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
*  Copyright (C) 2008 by
*  hsbSOFT
*  IRELAND
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT N.V., or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
* Created by: Anno Sportel (as@hsb-cad.com)
* date: 04.03.2009
* version 1.0: 	Pilot version
*
* date: 06.03.2009
* version 1.1: Erase the main beam if it's selected on the second group of beams.
*
*/
//Script uses mm
double dEps = U(.1,"mm");

if (_bOnInsert)
{
	_Beam.append(getBeam(T("Select Main Beam")));
	
	Beam bmSelect[0];
	PrEntity ssE(TN("Extra beams to create SubAssembly"),Beam());
	while (ssE.go() && (ssE.set().length()>0) ) { // let the prompt class do its job, only one run
		Beam ents[0]; // the PrEntity will return a list of entities, and not elements
		ents = ssE.beamSet();
		for (int i=0; i<ents.length(); i++) {
			Beam el = (Beam) ents[i]; // cast the entity to a element 
			bmSelect.append(el);
		}
		break;
	}
	
	bmSelect=_Beam[0].filterGenBeamsNotThis(bmSelect);
	_Beam.append(bmSelect);
	return;
}

if (_Beam.length()<1)
{
	eraseInstance();
	return;
}

Beam bm=_Beam[0];
_Pt0=bm.ptCen();
//order entities
GenBeam gBmSort;
for(int s1=1;s1<_Beam.length();s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		if( _Beam[s11].handle() < _Beam[s2].handle() ){
			_Beam.swap(s2, s11);
			s11=s2;
		}
	}
}

String sSubAssemblyName;
for( int i=0;i<_Beam.length();i++ ){
	String sHandle = _Beam[i].handle();
	sSubAssemblyName += sHandle;
	if( i != (_Beam.length() - 1) ){
		sSubAssemblyName += "-";
	}
}

//Subassembly
TslInst tslSubAssembly[] = bm.subAssemblies();
int nNewInst=true;
for (int i=0; i<tslSubAssembly.length(); i++)
{
	TslInst thisInst=tslSubAssembly[i];
	Map mp=thisInst.map();
	String sSubName;
	if (mp.hasString("SubAssemblyName"))
		sSubName=mp.getString("SubAssemblyName");
	
	if (sSubName==sSubAssemblyName)
	{
		nNewInst=false;
	}
}

if( nNewInst )
{
	TslInst NewTSL;
	String strScriptName = "hsb-SubAssembly"; // name of the script
	Vector3d vecUcsX=bm.vecX();
	Vector3d vecUcsY=bm.vecZ();
	Beam lstBeams[0];
	lstBeams.append(bm);
	Element lstElements[0];
	
	Point3d lstPoints[1];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	
	//Add those plates to the sub assembly tsl
	Map mapSubAssembly;;
	for (int i=1; i<_Beam.length(); i++)
	{
		mapSubAssembly.appendEntity("Beam", _Beam[i]);
	}

	NewTSL.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModel, mapSubAssembly );
}

eraseInstance();

#End
#BeginThumbnail




#End
