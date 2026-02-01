#Version 8
#BeginDescription
Applied to Section/Elevation objects, draws dimension of elevation value from point projected back to Model. Rt-click options to set custom reference heights.

V0.12 8/31/2023 Added grip for text cc
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 12
#KeyWords 
#BeginContents
/*
<>--<>--<>--<>--<>--<>--<>--<>____ Craig Colomb _____<>--<>--<>--<>--<>--<>--<>--<>



//######################################################################################
//############################ Documentation #########################################

Purpose & Function

Map Descriptions

Requirements


//########################## End Documentation #########################################
//######################################################################################

                              craig.colomb@hsbcad.com
<>--<>--<>--<>--<>--<>--<>--<>_____ hsbcad.us  _____<>--<>--<>--<>--<>--<>--<>--<>

*/

//set properties from map
if(_Map.hasMap("mpProps"))
{
	setPropValuesFromMap(_Map.getMap("mpProps"));
	_Map.removeAt("mpProps",0);
}

//constants
int bIsMetricDwg = U(1, "mm") == 1;//__script units are inches
double dUnitConversion = bIsMetricDwg ? 1 : 1 / 25.4; //__mm to .dwg units
double dAreaConversion = pow(dUnitConversion, 2);
double dVolumeConversion = pow(dUnitConversion, 3);
double dEquivalientTolerance = .01;		
int bInDebug;
bInDebug = projectSpecial() == "db";
bInDebug = true;
String stJig = "JigAction";

PropString psDimstyle(0, _DimStyles, "Dimstyle");
PropDouble pdTextH(0, 0, "Text Height Override");
PropDouble pdArrowScale(1, 1, "Arrow Scale");
PropString psNote(1, "T. O. Beam", "Note");

PropDouble pdRefElevation(2, 0, "Base/Reference Elevation");

//region  Geometry and Jigging
//######################################################################################		
//######################################################################################	

Vector3d vX = _XW;
Vector3d vY = _YW;

PLine plArrow(_ZW);
Vector3d vArrow = _XW * cos(60) * pdArrowScale + _YW * sin(60) * pdArrowScale;
plArrow.addVertex(_PtW);
plArrow.addVertex(_PtW + vArrow);
vArrow = vArrow.rotateBy(60, _ZW);
plArrow.addVertex(_PtW + vArrow);
plArrow.addVertex(_PtW);
PlaneProfile ppArrow(plArrow);
Display dp(-1);
dp.dimStyle(psDimstyle);

Entity entSection;
Section2d section; 


//region  Insertion
//######################################################################################		
//######################################################################################	




if(_bOnInsert)
{ 
	showDialogOnce();
	_Map.setMap("mpProps", mapWithPropValues());
	//PREPARE TO CLONING
	// declare tsl props 
	TslInst tsl;
	String sScriptName = scriptName();
	
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Beam lstBeams[0];
	Entity lstEnts[1];
	Point3d lstPoints[1];
	lstPoints.append(_Pt0);
	int lstPropInt[0];
	//lstPropInt.append(nQTY);
	double lstPropDouble[0];
	String lstPropString[0];
	
	Section2d section = getSection2d();
	lstEnts[0] = section;
	
	
	PrPoint prp(T("|Select Point|")); 

	Map mapArgs;	
	mapArgs.setEntity("entSection", section);
	
	int iJigResult = -1;	
	while (iJigResult != _kOk && iJigResult != _kNone)	
	{
		iJigResult = prp.goJig(stJig, mapArgs);
		
		if(iJigResult == _kOk) 
		{
			lstPoints[0] = prp.value();
			tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, 
			lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, 1, _Map );
		}
				
		
	}
	
	eraseInstance();
	return;
}


//######################################################################################
//######################################################################################	
//endregion End Insertion 			



if(_bOnJig && _kExecuteKey == stJig)
{ 
	entSection = _Map.getEntity("entSection");
	section = (Section2d)entSection;

	
	_Pt0 = _Map.getPoint3d("_PtJig");
	return;
}
else
{ 
	entSection = _Entity[0];
	section = (Section2d)entSection;		
	_Pt0.setZ(0);
}



CoordSys csModel2Section = section.modelToSection();
CoordSys sectionToModel = csModel2Section;
sectionToModel.invert();

Vector3d vToPick = _Pt0 - _PtW;
ppArrow.transformBy(vToPick);
dp.draw(ppArrow, _kDrawFilled);

Point3d ptModel = _Pt0;
ptModel.transformBy(sectionToModel);
double dModelZ = ptModel.Z();

Point3d ptModelBaseRef = ptModel;
ptModelBaseRef.setZ(pdRefElevation);
Point3d ptSectionBaseRef = ptModelBaseRef;
ptSectionBaseRef.transformBy(csModel2Section);
ptSectionBaseRef.setZ(0);

double dTextH = pdTextH > 0 ? pdTextH : dp.textHeightForStyle("qT", psDimstyle);
dp.textHeight(dTextH);

String sign = dModelZ < 0 ? "- " : "+ ";
double dElevation = dModelZ + pdRefElevation;
String stElevation = sign + String().formatUnit(dElevation, 4, 3);
Point3d ptText = _Pt0 + pdArrowScale * vX;
dp.draw(stElevation, ptText, vX, vY, 1, 1);

int iSetGrip = _Map.getInt("iSetGrip");

if(! iSetGrip)
{ 	
	_PtG[0] =  _Pt0 + vY * dTextH * 1.5;
	_Map.setInt("iSetGrip", 1);
}

_PtG[0].setZ(0);

Point3d ptNote = _PtG[0];

dp.draw(psNote, ptNote, vX, vY, 1, 1);
//######################################################################################
//######################################################################################	
//endregion End Geometry and Jigging 			

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
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Added grip for text" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="8/31/2023 10:05:04 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End