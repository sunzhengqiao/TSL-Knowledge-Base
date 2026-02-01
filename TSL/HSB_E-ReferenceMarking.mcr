#Version 8
#BeginDescription
Last modified by: Ronald van Wijngaarden(support.nl@hsbcad.com)
16.04.2019  -  version 1.04

1.5 1/16/2023 Add Tolerance marking face  EtH
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl adds reference marking to the beams in the selected elements. These markings are used in production to make sure that the beams are correctly positioned
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.04" date="16.04.2019"></version>

/// <history>
/// AS - 1.00 - 25.01.2018 -		First revision
/// RP - 1.01 - 27.09.2018 -		Make sure short side is marked
/// RP - 1.02 - 28.09.2018 -		Add extra filtering for horizontal and vertical beams
/// RVW - 1.03 - 21.02.2019 -		Add check that tsl cant be executed twice with the same identifier in one element.
/// RVW - 1.04 - 16.04.2019 - 	Add check outside _bOnInsert for identifier
//#Versions
// 1.5 1/16/2023 Add Tolerance marking face  EtH

/// </history>

double vectorTolerance = Unit(0.01, "mm");

String referenceCategory = T("|Reference|");
String visualisationCategory = T("|Visualisation|");
String filterCategory = T("|Filtering|");
String category = referenceCategory;

String bottomLeftName = T("|Bottom left|");
String bottomRightName = T("|Bottom right|");
String topRightName = T("|Top right|");
String topLeftName = T("|Top left|");

String nothing = T("|--|");
String horizontal = T("|Horizontal|");
String vertical = T("|Vertical|");
String both = T("|Both|");

String referenceCorners[] = 
{
	bottomLeftName,
	bottomRightName,
	topRightName,
	topLeftName	
};

String extraFilters[] = 
{
	nothing,
	horizontal,
	vertical,
	both
};
PropString tslIdentifier (1, "Pos 1", " " + T("|Tsl identifier|"));
tslIdentifier.setDescription(T("|Only one instance, per identifier, can be attached to an element|."));
PropString referenceCorner(0, referenceCorners, T("|Reference corner|"));
referenceCorner.setCategory(category);
referenceCorner.setDescription(T("|Sets the reference corner.|") + T(" |All marking is offsetted from this corner.|"));
PropDouble offsetMarking(1, U(200), T("|Offset marking|"));
offsetMarking.setCategory(category);
offsetMarking.setDescription(T("|Sets the offset for the marking from the start of the beam.|"));
PropDouble distanceBewteenReferenceMarkerLines(2, U(15), T("|Distance between marker lines|"));
distanceBewteenReferenceMarkerLines.setCategory(category);
distanceBewteenReferenceMarkerLines.setDescription(T("|Sets the distance between the 2 marker lines.|"));

category = filterCategory;
String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");
PropString filterDefinition(11, filterDefinitions, T("|Filter definition beams|"));
filterDefinition.setDescription(T("|Filter definition for  beams.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
filterDefinition.setCategory(category);

PropString extraFilter(12, extraFilters, T("|Extra Filter|"));
extraFilter.setDescription(T("|specify if you also want to filter horizontal or/and vertical beams|."));
extraFilter.setCategory(category);

category = visualisationCategory;
PropInt symbolColor(0, 4, T("|Color|"));
symbolColor.setCategory(category);
symbolColor.setDescription(T("|Specifies the color of the visualisation symbol.|"));
PropDouble symbolSize(0, U(40), T("|Symbol size|"));
symbolSize.setCategory(category);
symbolSize.setDescription(T("|Specifies the size of the visualisation symbol.|"));

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( catalogNames.find(_kExecuteKey) != -1 ) 
{
	setPropValuesFromCatalog(_kExecuteKey);
}

if (_bOnInsert) 
{
	if (insertCycleCount() > 1) 
	{
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
	{
		showDialog();
	}
	setCatalogFromPropValues(T("|_LastInserted|"));
	
	Element selectedElements[0];
	PrEntity ssElements(T("|Select elements|"), Element());
	if (ssElements.go())
	{
		selectedElements.append(ssElements.elementSet());
	}
		
		String strScriptName = scriptName();
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Entity lstEntities[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("ManualInserted", true);

		for (int e=0;e<selectedElements.length();e++)
		{
			Element selectedElement = selectedElements[e];
			if (!selectedElement.bIsValid())
			{
				continue;				
			}
			
			TslInst connectedTsls[] = selectedElement.tslInst();
			for( int t=0;t<connectedTsls.length();t++ )
			{
				TslInst tsl = connectedTsls[t];
				if ( ! tsl.bIsValid() || (tsl.scriptName() == strScriptName && tsl.propString(1) == tslIdentifier ))
				{
					tsl.dbErase();
				}
			}
			
			lstEntities[0] = selectedElement;

			TslInst tslNew;
			tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}		

	
	eraseInstance();
	return;
}

if (_Element.length() == 0) 
{
	reportWarning(T("|Invalid or no element selected.|"));
	eraseInstance();
	return;
}

int manualInserted = false;
if (_Map.hasInt("ManualInserted")) 
{
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

// set properties from catalog
if (_bOnDbCreated && manualInserted)
{
	setPropValuesFromCatalog(T("|_LastInserted|"));
}

if( _Element.length() == 0 )
{
	reportMessage(TN("|Invalid selection|!"));
	eraseInstance();
	return;
}

Element el = _Element[0];
CoordSys elementCoordSys = el.coordSys();
Point3d elOrg = elementCoordSys.ptOrg();
Vector3d elX = elementCoordSys.vecX();
Vector3d elY = elementCoordSys.vecY();
Vector3d elZ = elementCoordSys.vecZ();
_Pt0 = elOrg;
assignToElementGroup(el, true, 0, 'E');
Vector3d referenceX = elX * 10 + elY;
Vector3d referenceY = elY * 10 + elX;


TslInst arTsl[] = el.tslInst();
for (int t = 0; t < arTsl.length(); t++)
{
	TslInst tsl = arTsl[t];
	if (tsl.scriptName() != scriptName() || tsl.propString(1) != tslIdentifier || tsl.handle() == _ThisInst.handle()) continue;
	tsl.dbErase();
}


if (referenceCorner == bottomRightName)
{
	referenceX = -elX * 10 + elY;
	referenceY = elY * 10 - elX;
}
else if (referenceCorner == topRightName)
{
	referenceX = -elX * 10 - elY;
	referenceY = -elY * 10 - elX;
}
else if (referenceCorner == topLeftName)
{
	referenceX = elX * 10 - elY;
	referenceY = -elY * 10 + elX;
}
referenceX.normalize();
referenceY.normalize();


Beam beams[] = el.beam();
Entity beamEntities[0];{ }
for (int b=0;b<beams.length();b++)
{
	beamEntities.append(beams[b]);
}
Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, filterDefinition, filterGenBeamsMap);
if (!successfullyFiltered) {
	reportWarning(T("|Beams could not be filtered|!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
} 
beamEntities = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");

for (int b=0;b<beamEntities.length();b++)
{
	Beam bm = (Beam)beamEntities[b];
	Vector3d bmX = bm.vecX();
	
	
	if (extraFilter ==  both)
	{
		if (abs(bmX.dotProduct(elX)) < 1- vectorTolerance && abs(bmX.dotProduct(elY)) < 1 - vectorTolerance) continue;
	}
	else if (extraFilter == horizontal)
	{
		if (abs(bmX.dotProduct(elX)) < 1 - vectorTolerance) continue;
	}
	else if (extraFilter == vertical)
	{
		if (abs(bmX.dotProduct(elY)) < 1 - vectorTolerance) continue;
	}
	
	if (bmX.dotProduct(referenceX) < 0)
	{
		bmX *= -1;
	}
	if (bmX.dotProduct(referenceY) < 0)
	{
		bmX *= -1;
	}
	
	Vector3d vzBm = bm.vecZ(); 
	if (- elZ.dotProduct(vzBm) < -vectorTolerance)
	{
		vzBm *= -1;
	}
	
	Vector3d vyBm = bm.vecY();
	if (- elZ.dotProduct(vyBm) < -vectorTolerance)
	{
		vyBm *= -1;
	}

	Vector3d markingFace =vyBm;
	
	if (abs(bm.dD(vzBm)) > abs(bm.dD(vyBm)))
	{
		markingFace = vzBm;
	}
		
	Point3d markingPosition = bm.ptCenSolid() - bmX * (0.5 * bm.solidLength() - offsetMarking);
	
	Mark referenceMark(markingPosition, markingPosition + bmX * distanceBewteenReferenceMarkerLines, markingFace);
	bm.addTool(referenceMark);
}

// visualisation
Display visualisationDisplay(symbolColor);
visualisationDisplay.textHeight(U(4));
visualisationDisplay.addHideDirection(elY);
visualisationDisplay.addHideDirection(-elY);
visualisationDisplay.elemZone(el, 0, 'I');

Point3d ptSymbol01 = _Pt0 - elY * 2 * symbolSize;
Point3d ptSymbol02 = ptSymbol01 - (elX + elY) * symbolSize;
Point3d ptSymbol03 = ptSymbol01 + (elX - elY) * symbolSize;

PLine plSymbol01(elZ);
plSymbol01.addVertex(_Pt0);
plSymbol01.addVertex(ptSymbol01);
PLine plSymbol02(elZ);
plSymbol02.addVertex(ptSymbol02);
plSymbol02.addVertex(ptSymbol01);
plSymbol02.addVertex(ptSymbol03);

visualisationDisplay.draw(plSymbol01);
visualisationDisplay.draw(plSymbol02);

Vector3d vxTxt = elX + elY;
vxTxt.normalize();
Vector3d vyTxt = elZ.crossProduct(vxTxt);
visualisationDisplay.draw(scriptName(), ptSymbol01, vxTxt, vyTxt, -1.1, 1.75);

{
	Display visualisationDisplayPlan(symbolColor);
	visualisationDisplayPlan.textHeight(U(4));
	visualisationDisplayPlan.addViewDirection(elY);
	visualisationDisplayPlan.addViewDirection(-elY);
	visualisationDisplayPlan.elemZone(el, 0, 'I');
	
	Point3d ptSymbol01 = _Pt0 + elZ * 2 * symbolSize;
	Point3d ptSymbol02 = ptSymbol01 - (elX - elZ) * symbolSize;
	Point3d ptSymbol03 = ptSymbol01 + (elX + elZ) * symbolSize;
	
	PLine plSymbol01(elY);
	plSymbol01.addVertex(_Pt0);
	plSymbol01.addVertex(ptSymbol01);
	PLine plSymbol02(elY);
	plSymbol02.addVertex(ptSymbol02);
	plSymbol02.addVertex(ptSymbol01);
	plSymbol02.addVertex(ptSymbol03);
	
	visualisationDisplayPlan.draw(plSymbol01);
	visualisationDisplayPlan.draw(plSymbol02);
	
	Vector3d vxTxt = elX - elZ;
	vxTxt.normalize();
	Vector3d vyTxt = elY.crossProduct(vxTxt);
	visualisationDisplayPlan.draw(scriptName(), ptSymbol01, vxTxt, vyTxt, -1.1, 1.75);
}

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
      <str nm="Comment" vl="Add Tolerance marking face " />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="1/16/2023 9:21:38 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End