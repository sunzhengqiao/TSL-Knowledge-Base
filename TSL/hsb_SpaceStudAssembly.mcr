#Version 8
#BeginDescription
Last modified by: Alberto Jena (as@hsb-cad.com)
13.07.2021  -  version 1.5







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
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 04.04.2010
* version 1.0: 	First version
*
* date: 06.04.2010
* version 1.1: 	Add the option to export the angle as key too
*
* date: 06.04.2010
* version 1.2: 	Change the vector to the vector of the beam
*
* date: 08.06.2012
* version 1.4: 	Set the beam code as SS for the space stud beams and the Posnum of the subAssembly in the sublabel of the beam
*/

//Script uses mm
double dEps = U(.1,"mm");

//Symbol size
double dSymbolSize = U(50);

if( _GenBeam.length() == 0 ){
	_GenBeam.append(_Beam0);
}

//_XE = _XU;
//_YE = _YU;
//_ZE = _XE.crossProduct(_YE);
_XE=_GenBeam[0].vecX();
_YE=_GenBeam[0].vecY();
_ZE=_GenBeam[0].vecZ();

if (_Map.hasInt("NumberOfBeams"))
{ 
	int nQty = _Map.getInt("NumberOfBeams");
	if (nQty!=_Beam.length())
	{ 
		eraseInstance();
		return;
	}
}

CoordSys csThisInst = _ThisInst.coordSys();
csThisInst.vis();
_Pt0=csThisInst.ptOrg();

if (_GenBeam.length()==0) return;
Element el = _Beam[0].element();
exportToDxi(TRUE);
if (el.bIsValid())
{
	exportWithElementDxa(el);
	assignToElementGroup(el);
}

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

String sType;

if (_Map.hasDouble("Width"))
{
	_st_WF0=_Map.getDouble("Width");
}
if (_Map.hasDouble("Height"))
{
	_st_HF0=_Map.getDouble("Height");
}
if (_Map.hasDouble("Length"))
{
	_st_Len0=_Map.getDouble("Length");
}
if (_Map.hasString("Type"))
{
	sType=_Map.getString("Type");
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

Vector3d vxRef=_Beam0.vecX();
if (vxRef.dotProduct(_ZW)<0)
	vxRef=-vxRef;

Point3d ptRef=_Beam0.ptCen();

String sSubAssemblyName;

double dNewLength=0;

for( int i=0;i<_GenBeam.length();i++ )
{
	Beam bm=(Beam) _GenBeam[i];
	
	if (sType!="Group")
	{
		
		String sFullCode=bm.beamCode();
		String sCode=sFullCode.token(0);
	
		String sCodeRight=sFullCode.right(sFullCode.length()-sCode.length());
	
		bm.setBeamCode("SS"+sCodeRight);
		int nPosnum=_ThisInst.posnum();
		bm.setSubLabel(nPosnum);
	}
	
	String sAngle="";
	if (bm.bIsValid())
	{
		sAngle=bm.strCutN()+"-"+bm.strCutP();
	}
	double dBmL=_GenBeam[i].solidLength();
	
	if (dBmL>dNewLength)
	{
		dNewLength=dBmL;
	}
	
	String sLength;
	sLength.formatUnit(dBmL, 2, 0);
	sSubAssemblyName += sLength;
	sSubAssemblyName += "-";
	if (i==0 && sAngle!="")
	{
		sSubAssemblyName += "-"+sAngle;
	}
}

for( int i=0;i<_Entity.length();i++ )
{
	Point3d ptAll[]=_Entity[i].gripPoints();
	double dBmL=(ptAll[0]-ptRef).length();
	String sLength;
	sLength.formatUnit(dBmL, 2, 0);

	sSubAssemblyName += sLength;
	if( i != (_Entity.length() - 1) )
	{
		sSubAssemblyName += "-";
	}
}

setCompareKey(sSubAssemblyName);
setSubAssemblyName(sSubAssemblyName);

if (dNewLength>0)
{
	_Map.setDouble("Length", dNewLength, _kNoUnit);
	_st_Len0=dNewLength;
}


if (sType=="Group")
{
	_Map.setString("GroupAssembly", sSubAssemblyName);
	dxaout("GroupAssembly",sSubAssemblyName);
}
else
{
	_Map.setString("SpaceStudAssembly", sSubAssemblyName);
	dxaout("SpaceStudAssembly",sSubAssemblyName);
}

for(int i=0; i<2; i++)
{
	dxaout("Beam", _GenBeam[i].handle());
}

for(int i=2; i<_GenBeam.length(); i++)
{
	dxaout("Blocking", _GenBeam[i].handle());
}

for(int i=0; i<_Entity.length(); i++)
{
	dxaout("Plate", _Entity[i].handle());
}	

dxaout("Width", _st_WF0);
dxaout("Height", _st_HF0);
dxaout("Length", _st_Len0);

Display dp(-1);
//dp.dimStyle("KOS-Model Dims");

PLine pl(_ZW);
pl.addVertex(_Pt0-_XW*U(10));
pl.addVertex(_Pt0+_XW*U(10));
PLine pl1(_ZW);
pl1.addVertex(_Pt0-_YW*U(10));
pl1.addVertex(_Pt0+_YW*U(10));

dp.draw(pl);
dp.draw(pl1);

_Map.setInt("NumberOfBeams", _Beam.length());





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