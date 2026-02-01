#Version 8
#BeginDescription
Last modified by: Robert Pol (robert.pol@hsbcad.com)
23.03.2021  -  version 1.00

This tsl will create a packer bewteen 2 beams in an element
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
// constants //region
/// <summary Lang=en>
/// Description
/// </summary>

/// <insert>
/// Specify insert
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

//endregion

U(1,"mm");	
double pointTolerance =U(.1);
double vectorTolerance = U(.01);
int nDoubleIndex, nStringIndex, nIntIndex;
String sDoubleClick= "TslDoubleClick";
int bDebug=_bOnDebug;
bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
String sDefault =T("|_Default|");
String sLastInserted =T("|_LastInserted|");	
String category = T("|General|");
String sNoYes[] = { T("|No|"), T("|Yes|")};
String executeKey = "ManualInsert";
String sDisabled = T("<|Disabled|>");

category = T("|Tolerance|");
PropDouble minimumGap(0, pointTolerance, T("|Minimum Gap|"));
minimumGap.setCategory(category);
PropDouble maximumGap(1, U(200), T("|Maximum Gap|"));
maximumGap.setCategory(category);

category = T("|Properties|");
PropString name(0, T("Packer"), T("|Packer Name|"));
name.setCategory(category);
PropString material(1, T(""), T("|Packer Material|"));
material.setCategory(category);
PropString beamType(2, _BeamTypes, T("|Packer Type|"));
material.setCategory(category);
PropInt color(0, 32, T("|Color|"));
color.setCategory(category);

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( _bOnDbCreated && catalogNames.find(_kExecuteKey) != -1 ) 
{
	setPropValuesFromCatalog(_kExecuteKey);	
}

//region mapIO: support property dialog input via map on element creation
int bHasPropertyMap = _Map.hasMap("PROPSTRING[]") && _Map.hasMap("PROPDOUBLE[]");
if (_bOnMapIO)
{ 
	if (bHasPropertyMap)
		setPropValuesFromMap(_Map);	
	showDialog();
	_Map = mapWithPropValues();
	return;
}
if (_bOnElementDeleted)
{
	eraseInstance();
	return;
}
else if (_bOnElementConstructed && bHasPropertyMap)
{ 
	setPropValuesFromMap(_Map);
	_Map = Map();
}	
	
//End mapIO: support property dialog input via map on element creation//endregion 

// bOnInsert
if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
				
// silent/dialog
	String sKey = _kExecuteKey;
	sKey.makeUpper();

	if (sKey.length()>0)
	{
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for(int i=0;i<sEntries.length();i++)
		{
			sEntries[i] = sEntries[i].makeUpper();	
		}
		
		if (sEntries.find(sKey)>-1)
		{
			setPropValuesFromCatalog(sKey);
			setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
		}
		else
		{
			setPropValuesFromCatalog(sKey);
			setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
		}
	}	
	else	
	{
		showDialog();
		setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
	}
	
	// prompt for elements

		_Element.append(getElement());
		_Pt0 = getPoint();


				
	return;
}	
// end on insert	__________________

// validate and declare element variables
if (_Element.length()<1)
{
	reportMessage(TN("|Element reference not found.|"));
	eraseInstance();
	return;	
}

Element element = _Element[0];
CoordSys cs = element.coordSys();
Vector3d vecX = cs.vecX();
Vector3d vecY = cs.vecY();
Vector3d vecZ = cs.vecZ();
Point3d ptOrg = cs.ptOrg();
assignToElementGroup(element,false, 0,'E');// assign to element tool sublayer

LineSeg minMax = element.segmentMinMax();
_Pt0 += vecZ * vecZ.dotProduct(minMax.ptMid() - _Pt0);
_Pt0 += vecY * vecY.dotProduct(minMax.ptMid() - _Pt0);
Beam beams[] = element.beam();
Beam studs[0];
for (int index=0;index<beams.length();index++) 
{ 
	Beam beam = beams[index]; 
	if (abs(beam.vecX().dotProduct(vecX)) > vectorTolerance) continue;
	studs.append(beam);
}

Beam beamsLeft[] = Beam().filterBeamsHalfLineIntersectSort(studs, _Pt0, -vecX);
Beam beamsRight[] = Beam().filterBeamsHalfLineIntersectSort(studs, _Pt0, vecX);

if (beamsLeft.length() < 1 || beamsRight.length() < 1)
{
	reportMessage(TN("|Cannot identify nearest studs|"));
	eraseInstance();
	return;
}

Beam leftBeam = beamsLeft[0];
Beam rightBeam = beamsRight[0];

Point3d left = leftBeam.ptCen() + vecX * 0.5 * leftBeam.dD(vecX);
Point3d right = rightBeam.ptCen() - vecX * 0.5 * rightBeam.dD(vecX);

Point3d newBeamPosition = (left + right) / 2;

double packerWidth = abs(vecX.dotProduct(left - right));

if (packerWidth < pointTolerance)
{
	reportMessage(TN("|Gap is to small|"));
	eraseInstance();
	return;
}

Beam newBeam = leftBeam.dbCopy();
newBeam.transformBy(vecX * vecX.dotProduct(newBeamPosition - newBeam.ptCen()));

newBeam.setD(vecX, packerWidth);
newBeam.setType(_BeamTypes.find(beamType));
newBeam.setName(name);
newBeam.setMaterial(material);
newBeam.setColor(color);

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
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End