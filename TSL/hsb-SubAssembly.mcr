#Version 8
#BeginDescription
Last modified by: Alberto Jena (as@hsb-cad.com)
16.03.2011  -  version 1.5

#End
#Type S
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT N.V.
*  THE NETHERLANDS
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
* date: 16.09.2008
* version 1.0: 	Pilot version
* date: 17.09.2008
* version 1.1: 	remove Beams/Sheets from map after they've bin used
* date: 30.09.2008
* version 1.2: 	Add tsls to the _Entity array
*
* Modify by: Alberto Jena (aj@hsb-cad.com)
* date: 08.10.2008
* version 1.3:
*
* date: 08.10.2008
* version 1.4: Change the Display Text
*/
//Script uses mm
double dEps = U(.1,"mm");

PropString sName(0, "", T("|Name Shopdraw Tag|"));
//String sName="TEST";
//Symbol size
double dSymbolSize = U(50);

if( _GenBeam.length() == 0 ){
	_GenBeam.append(_Beam0);
}

_XE = _XU;
_YE = _YU;
_ZE = _XE.crossProduct(_YE);
//_XE=_GenBeam[0].vecX();
//_XE=_GenBeam[0].vecY();
//_XE=_GenBeam[0].vecZ();

CoordSys csThisInst = _ThisInst.coordSys();
csThisInst.vis();

Entity arETool[] = _Beam0.eToolsConnected();
for( int i=0;i<arETool.length();i++ ){
	Entity ent = arETool[i];
	TslInst tsl = (TslInst)ent;
	if( !tsl.bIsValid()) continue;
	Map mapBm = tsl.map();
	PLine pl = mapBm.getPLine("Nailplate");
	Display dpPL(1);
	dpPL.draw(pl);
}

//return;
for( int i=0;i<_Map.length();i++ ){
	if( _Map.hasEntity(i) ){
		Entity ent = _Map.getEntity(i);
		
		//Cast to the right entity (only take GenBeam::Sheet and GenBeam::Beam		
		if( ent.bIsKindOf(Sheet()) ){
			_Sheet.append((Sheet)ent);
		}
		else if( ent.bIsKindOf(Beam()) ){
			_Beam.append((Beam)ent);
		}
		else if( ent.bIsKindOf(TslInst()) ){
			_Entity.append((TslInst)ent);
		}
		else{
			continue;
		}
		
		GenBeam gBm = (GenBeam)ent;
		if( gBm.bIsValid() ){
			_GenBeam.append(gBm);
		}
		
		_Map.removeAt(i, FALSE);
		i--;
	}
}

//order entities
GenBeam gBmSort;
for(int s1=1;s1<_GenBeam.length();s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		if( _GenBeam[s11].handle() < _GenBeam[s2].handle() ){
			_GenBeam.swap(s2, s11);
			s11=s2;
		}
	}
}

String sSubAssemblyName;
for( int i=0;i<_GenBeam.length();i++ ){
	String sHandle = _GenBeam[i].handle();

	sSubAssemblyName += sHandle;
	if( i != (_GenBeam.length() - 1) ){
		sSubAssemblyName += "-";
	}
}

setCompareKey(sSubAssemblyName);
setSubAssemblyName(sSubAssemblyName);

_Map.setString("SubAssemblyName", sSubAssemblyName);

Display dp(-1);
dp.dimStyle("KOS-Model Dims");
//dp.textHeight(dSymbolSize);
String sText;
if (sName!="")
{
	sText=sName;
}else
{
	sText="Shopdraw Tag";
}
//dp.draw(scriptName(), _Pt0, _XW, _YW, 1, 1, _kDeviceX);
dp.draw(sText, _Pt0, _XW, _YW, 1, 1, _kDeviceX);
//dp.draw(sSubAssemblyName, _Pt0, _XW, _YW, 1, -1.1, _kDeviceX);


#End
#BeginThumbnail




#End
