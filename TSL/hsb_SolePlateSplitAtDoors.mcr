#Version 8
#BeginDescription
1.0 11.05.2021 HSB-11750: initial Author: Marsel Nakuci
1.1 11.04.2022 HSB-15012: after splitting delete pieces at doors Author: Marsel Nakuci

This tsl split soleplates at doors

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
//region <History>
// #Versions
// 1.1 11.04.2022 HSB-15012: after splitting delete pieces at doors Author: Marsel Nakuci
// Version 1.0 11.05.2021 HSB-11750: initial Author: Marsel Nakuci

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl split soleplates at doors 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsb_SolePlateSplitAtDoors")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end Constants//endregion

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
	// standard dialog	
//		else	
//			showDialog();
		_Element.append(getElement(T("|Select wall|")));
	// prompt for beams
		Beam beams[0];
		PrEntity ssE(T("|Select beams that need be splitted at door positions|"), Beam());
		if (ssE.go())
			beams.append(ssE.beamSet());
		_Beam.append(beams)			;
		return;
	}	
// end on insert	__________________//endregion
	
if(_Element.length()==0)
{ 
	reportMessage("\n"+ scriptName() +T("|one wall needed|"));
	eraseInstance();
	return;
}

if(_Beam.length()==0)
{ 
	reportMessage("\n"+ scriptName() +T("|Soleplate beams needed|"));
	eraseInstance();
	return;
}
Element el = _Element[0];
// basic information
Point3d ptOrg = el.ptOrg();
Vector3d vecX = el.vecX();
Vector3d vecY = el.vecY();
Vector3d vecZ = el.vecZ();
Beam beams[] = el.beam();
Beam beamsSolePlate[0];
beamsSolePlate.append(_Beam);
//for (int i=0;i<beams.length();i++) 
//{ 
//	if (beams[i].name() == "SolePlate")beamsSolePlate.append(beams[i]);
//}//next i

Opening op[]=el.opening();
PlaneProfile ppDoors[0];
for (int o=0; o<op.length(); o++)
{
	if (op[o].openingType()==_kDoor)
	{
		PlaneProfile ppO(el.coordSys());
		ppO.joinRing(op[o].plShape(), _kAdd);
		ppO.vis(3);
		ppDoors.append(ppO);
	}
}

for (int iD=0;iD<ppDoors.length();iD++) 
{ 
	PlaneProfile ppId = ppDoors[iD];
	// get extents of profile
	LineSeg seg = ppId.extentInDir(el.vecX());
	// ptstart
	for (int ib=0;ib<beamsSolePlate.length();ib++) 
	{ 
		Beam bmIb = beamsSolePlate[ib];
		PlaneProfile ppSoleBig(el.coordSys());
		PLine plSoleBig;
		plSoleBig.createRectangle(LineSeg(bmIb.ptCen()-el.vecX()*.5*bmIb.solidLength()-el.vecY()*U(10e3),
		bmIb.ptCen() + el.vecX() * .5 * bmIb.solidLength() + el.vecY() * 2 * U(10e3)), el.vecX(), el.vecY());
		ppSoleBig.joinRing(plSoleBig, _kAdd);
		ppSoleBig.shrink(dEps);
		if (ppSoleBig.pointInProfile(seg.ptStart()) == _kPointInProfile)
		{
			Beam bmSoleNew = bmIb.dbSplit(seg.ptStart(), seg.ptStart());
			if (beamsSolePlate.find(bmSoleNew) < 0)
			{
				beamsSolePlate.append(bmSoleNew);
			}
//					break;
		}
	}//next ib
	// ptend
	for (int ib=0;ib<beamsSolePlate.length();ib++) 
	{ 
		Beam bmIb = beamsSolePlate[ib];
		PlaneProfile ppSoleBig(el.coordSys());
		PLine plSoleBig;
		plSoleBig.createRectangle(LineSeg(bmIb.ptCen()-el.vecX()*.5*bmIb.solidLength()-el.vecY()*U(10e3),
		bmIb.ptCen() + el.vecX() * .5 * bmIb.solidLength() + el.vecY() * 2 * U(10e3)), el.vecX(), el.vecY());
		ppSoleBig.joinRing(plSoleBig, _kAdd);
		ppSoleBig.shrink(dEps);
		if (ppSoleBig.pointInProfile(seg.ptEnd()) == _kPointInProfile)
		{
			Beam bmSoleNew = bmIb.dbSplit(seg.ptEnd(), seg.ptEnd());
			if (beamsSolePlate.find(bmSoleNew) < 0)
			{
				beamsSolePlate.append(bmSoleNew);
			}
		}
	}//next ib
}//next iD

// delete beams inside doors
for (int ib=beamsSolePlate.length()-1; ib>=0 ; ib--) 
{ 
	Beam bmI=beamsSolePlate[ib];
	for (int ip=ppDoors.length()-1; ip>=0 ; ip--) 
	{ 
		PlaneProfile ppI=ppDoors[ip]; 
		LineSeg seg = ppI.extentInDir(el.vecX());
		// get extents of profile
		double dX = abs(el.vecX().dotProduct(seg.ptStart()-seg.ptEnd()));
		double dY = abs(el.vecY().dotProduct(seg.ptStart()-seg.ptEnd()));
		
		PlaneProfile ppIstretch(ppI.coordSys());
		PLine plStretch;
		plStretch.createRectangle(LineSeg(seg.ptMid()-.5*el.vecX()*dX-el.vecY()*2*dY, 
				seg.ptMid()+.5*el.vecX()*dX+el.vecY()*2*dY),el.vecX(),el.vecY());
		ppIstretch.joinRing(plStretch, _kAdd);
		ppIstretch.shrink(U(10));
		if (ppIstretch.pointInProfile(bmI.ptCen()) == _kPointInProfile)bmI.dbErase();
	}//next ip
	
	
	
}//next ib



eraseInstance();
return;

#End
#BeginThumbnail


#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15012: after splitting delete pieces at doors" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="4/11/2022 2:20:33 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11750: initial" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="5/11/2021 3:00:07 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End