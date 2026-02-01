#Version 8
#BeginDescription
Applies chamfer operation to one or more beam edges
#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 10
#KeyWords 
#BeginContents
/*
<>--<>--<>--<>--<>--<>--<>--<>____ Craig Colomb _____<>--<>--<>--<>--<>--<>--<>--<>



//######################################################################################
//############################ Documentation #########################################

Applies chamfer operation to one or more beam edges


//########################## End Documentation #########################################
//######################################################################################

                              craig.colomb@hsbcad.com
<>--<>--<>--<>--<>--<>--<>--<>_____ hsbcad.us  _____<>--<>--<>--<>--<>--<>--<>--<>

*/

//constants
int bIsMetricDwg = U(1, "mm") == 1;//__script units are inches
double dUnitConversion = bIsMetricDwg ? 1 : 1 / 25.4; //__mm to .dwg units
double dAreaConversion = pow(dUnitConversion, 2);
double dVolumeConversion = pow(dUnitConversion, 3);
double dEquivalientTolerance = .01;		
//Display dp(-1);
String stYN[] = { "No", "Yes"};
String stSpecial = projectSpecial();
int bInDebug = stSpecial == "db" || stSpecial == scriptName();
if(_bOnDebug) bInDebug = true;


String stChamferTypes[] = { T("|Round|"), T("|45|"), T("|90|")};
int feedTypes[] = { _kChamferRound, _kChamfer45, _kChamfer90};
PropString psChamferType(0, stChamferTypes, T("|Chamfer Type|"));
PropDouble pdDepth(0, U(.5, "inch"), T("|Chamfer Depth|"));
PropDouble pdLength(1, U(6, "inch"), T("|Chamfer Length|"));

PropString psNegYPosZ(1, stYN, T("|Neg Y Pos Z|"));
PropString psNegYNegZ(2, stYN, T("|Neg Y Neg Z|"));
PropString psPosYPosZ(3, stYN, T("|Pos Y Pos Z|"));
PropString psPosYNegZ(4, stYN, T("|Pos Y Neg Z|"));

setMarbleDiameter(U(.25, "inch"));


int iSides;
if (psNegYPosZ == stYN[1]) iSides += _kNYPZ;
if (psNegYNegZ == stYN[1]) iSides += _kNYNZ;
if (psPosYPosZ == stYN[1]) iSides += _kPYPZ;
if (psPosYNegZ == stYN[1]) iSides += _kPYNZ;

if(_bOnInsert)
{ 
	if(insertCycleCount() > 1)
	{ 
		eraseInstance();
		return;
	}
	
	showDialogOnce();
	
	Beam bm = getBeam();
	_Beam.append(bm);
	Vector3d vBmX = bm.vecX();
	
	_Pt0 = getPoint(T("|Select Location|"));
	
	PrPoint prp(T("|Select Start and End of chamfer|"), _Pt0);
	
	while(prp.go() && _PtG.length() < 2)
	{ 
		_PtG.append(prp.value());
	}
	
	if(_PtG.length() < 2)
	{ 		
		Point3d ptNegX = _Pt0 - vBmX * pdLength / 2;
		Point3d ptPosX = _Pt0 + vBmX * pdLength / 2;
		
		if(_PtG.length() < 1)
		{ 
			_PtG.append(ptNegX);
		}
		else
		{ 
			_PtG[0] = ptNegX;
		}
		
		if(_PtG.length() < 2)
		{ 
			_PtG.append(ptPosX);
		}
		else
		{ 
			_PtG[1] = ptPosX;
		}
	}
	
	Line lnBm(bm.ptCen(), vBmX);
	_PtG[0] = lnBm.closestPointTo(_PtG[0]);
	_PtG[1] = lnBm.closestPointTo(_PtG[1]);
	
	
	Vector3d vGrips = _PtG[0] - _PtG[1];
	pdLength.set(vGrips.length());
	
	return;
}


Beam bm = _Beam0;
Vector3d vX = bm.vecX();
Vector3d vY = bm.vecY();
Vector3d vZ = bm.vecZ();

Point3d& ptChamferStart = _PtG[0];
Point3d& ptChamferEnd = _PtG[1];

Line lnBmAxis(_Pt0, vX);

ptChamferEnd = lnBmAxis.closestPointTo(ptChamferEnd);
ptChamferStart = lnBmAxis.closestPointTo(ptChamferStart);

if((ptChamferEnd - ptChamferStart).dotProduct(vX) < 0)
{ 
	Point3d ptTemp = ptChamferStart;
	ptChamferStart = ptChamferEnd;
	ptChamferEnd = ptTemp;
}

if(_kNameLastChangedProp == "_PtG0" || _kNameLastChangedProp == "_PtG1")
{ 
	Vector3d vGrips = ptChamferEnd - ptChamferStart;
	pdLength.set(vGrips.length());
	_Pt0 = ptChamferStart + vGrips / 2;
}

if(_kNameLastChangedProp == T("|Chamfer Length|"))
{ 
	ptChamferStart = _Pt0 - vX * pdLength / 2;
	ptChamferEnd = _Pt0 + vX * pdLength / 2;
}

if(iSides > 0)
{ 
	Chamfer cm(_Pt0, vX, vY, vZ, pdLength, bm.solidWidth(), bm.solidHeight(), iSides, pdDepth);
	int chamferType = feedTypes[stChamferTypes.find(psChamferType)];
	cm.setFeed(chamferType);
	
	bm.addTool(cm);
}


#End
#BeginThumbnail

#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]" />
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End