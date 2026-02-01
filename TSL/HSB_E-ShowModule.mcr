#Version 8
#BeginDescription
Last modified by: Ronald van Wijngaarden (support.nl@hsbcad.com)

22.08.2019  -  version 1.05

This tsl allows you to assign and add/remove module data from genbeams. The hatch is shown on the info layer.
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

/// <version  value="1.05" date="22-08-2019"></version>

/// <history>
/// RP		- 1.00 - 22-06-2018 -  Pilot version.
/// RP		- 1.01 - 18-07-2018 -  Set display on elemzone
/// RP		- 1.02 - 19-07-2018 -  Set display to only do hatch
/// RP		- 1.03 - 15-10-2018 -  Show text always in device view and only in z of element
/// RVW		- 1.04 - 05-04-2019 -  Make text movable by using _PtG
/// RVW		- 1.05 - 22-08-2019 -  Add option to show module name yes/no. And add option to assign the hatching to a certain zone.

/// </history>
//endregion

U(1,"mm");	
double dEps =U(.1);
int nDoubleIndex, nStringIndex, nIntIndex;
String sDoubleClick= "TslDoubleClick";
int bDebug=_bOnDebug;
bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
String sDefault =T("|_Default|");
String sLastInserted =T("|_LastInserted|");	
String category = T("|General|");
String sNoYes[] = { T("|No|"), T("|Yes|")};
String filterDefinitionTslName = "HSB_G-FilterEntities";
String executeKey = "ManualInsert";
int zones[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
int realZones[] = {0, 1, 2, 3, 4, 5, - 1, -2, -3, -4, -5};

PropString dimStyle(0, _DimStyles, T("|Dimension style|"));
dimStyle.setCategory(category);
dimStyle.setDescription(T("|Set the dimstyle for the module name text|"));

PropInt bodyColor(0, 2, T("|Body Color|"));
bodyColor.setCategory(category);
bodyColor.setDescription(T("|Set the color of the body visualisation|"));

PropInt nameColor(1, -1, T("|Name Color|"));
nameColor.setCategory(category);
nameColor.setDescription(T("|Set the color of the module text|"));

PropInt hatchColor(2, -1, T("|Hatch Color|"));
hatchColor.setCategory(category);
hatchColor.setDescription(T("|Set the color of the module hatch|"));

PropString sShowModuleName(3, sNoYes, T("|Show module name|"), 1);
sShowModuleName.setCategory(category);
sShowModuleName.setDescription(T("|Select to show the module name Yes / No|"));

PropString moduleName(1, T("|Auto|"), T("|Module name|"));
moduleName.setCategory(category);
moduleName.setDescription(T("|Set the module name|"));
moduleName.setReadOnly(false);

PropString hatchPattern(2, _HatchPatterns, T("|Module hatch|"));
hatchPattern.setCategory(category);
hatchPattern.setDescription(T("|Set the module hatch pattern|"));

PropDouble patternScale(0, U(1), T("|Hatch scale|"));
hatchPattern.setCategory(category);
hatchPattern.setDescription(T("|Set the module hatch scale|"));

PropInt hatchZone (3, zones, T("|Show hatch in zone|"), 8);
hatchZone.setCategory(category);
hatchZone.setDescription(T("|Set the zone for the hatch to show|"));


if (_bOnInsert)
{
	moduleName.setReadOnly(true);
}

_ThisInst.setSequenceNumber(2000);

String arSTrigger[] = {
	T("|Add GenBeams|"),
	T("|Remove GenBeams|"),
	T("|Remove all GenBeams|")
};
for( int i=0;i<arSTrigger.length();i++ )
{
	addRecalcTrigger(_kContext, arSTrigger[i] );
}
// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( _bOnDbCreated && catalogNames.find(_kExecuteKey) != -1 ) 
{
	setPropValuesFromCatalog(_kExecuteKey);	
}

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
			sEntries[i] = sEntries[i].makeUpper();	
		if (sEntries.find(sKey)>-1)
			setPropValuesFromCatalog(sKey);
		else
			setPropValuesFromCatalog(T("|_LastInserted|"));					
	}	
	else	
	{
		showDialog();
	}
	
// prompt for elements
	PrEntity ssE(T("|Select element(s)|"), Element());
  	if (ssE.go())
		_Element.append(ssE.elementSet());

// prepare tsl cloning
	TslInst tslNew;
	Vector3d vecXTsl= _XE;
	Vector3d vecYTsl= _YE;
	GenBeam gbsTsl[] = {};
	Entity entsTsl[1] ;
	Point3d ptsTsl[1];
	int nProps[]={};
	double dProps[]={};
	String sProps[]={};
	Map mapTsl;	
	String sScriptname = scriptName();

			
	if(bDebug)reportMessage("\n"+ scriptName() + " will be cloned" + 
		"\n	vecX  	" + vecXTsl+
		"\n	vecY  	" + vecYTsl+
		"\n	GenBeams 	(" + gbsTsl.length()+")" +
		"\n	Entities 	(" + entsTsl.length()+")"+
		"\n	Points   	(" + ptsTsl.length()+")"+
		"\n	PropInt  	(" + nProps.length()+")"+ ((nProps.length()==nIntIndex) ? " OK" : (" Warning: should be " + nIntIndex))+
		"\n	PropDouble	(" + dProps.length()+")"+ ((dProps.length()==nDoubleIndex) ? " OK" : (" Warning: should be " + nDoubleIndex))+
		"\n	PropString	(" + sProps.length()+")"+ ((sProps.length()==nStringIndex) ? " OK" : (" Warning: should be " + nStringIndex))+
		"\n	Map      	(" + mapTsl.length()+") " + mapTsl+"\n");			

		
// insert per element
	for(int i=0;i<_Element.length();i++)
	{
		Element element = _Element[i];
		entsTsl[0]= element;	
		ptsTsl[0];
		GenBeam genBeams[] = element.genBeam();
		String modules[0];
		
		for (int index=0;index<genBeams.length();index++) 
		{ 
			GenBeam genBeam = genBeams[index]; 
			String module = genBeam.module();
			if (module != "" && modules.find(module) == -1)
			{
				modules.append(module);
			}
		}
		
		for (int m=0;m<modules.length();m++) 
		{ 
			gbsTsl.setLength(0);
			String module = modules[m]; 
			for (int g=0;g<genBeams.length();g++) 
			{ 
				GenBeam genBeam = genBeams[g]; 
				if (genBeam.module() == module)
				{
					gbsTsl.append(genBeam);
				} 
			}
						
			if (gbsTsl.length() > 0) tslNew.dbCreate(scriptName(), vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, sLastInserted, true, mapTsl, executeKey, "");
		}
	}

	eraseInstance();
	return;
}	
// end on insert	__________________

int iShowModuleName = sNoYes.find(sShowModuleName);
int nZone=realZones[zones.find(hatchZone, 0)];

// validate and declare element variables
if (_Element.length()<1)
{
	reportMessage(TN("|Element reference not found.|"));
	eraseInstance();
	return;	
}
Element el = _Element[0];
CoordSys cs = el.coordSys();
Vector3d vecX = cs.vecX();
Vector3d vecY = cs.vecY();
Vector3d vecZ = cs.vecZ();
Point3d ptOrg = cs.ptOrg();
assignToElementGroup(el,true, 0,'E');// assign to element tool sublayer

if (_kExecuteKey == arSTrigger[0])
{
	// prompt for entities
	Entity ents[0];
	PrEntity ssE(T("|Select entity(s)"), GenBeam());
  	if (ssE.go())
		ents.append(ssE.set());
	for (int index=0;index<ents.length();index++) 
	{ 
		GenBeam gb = (GenBeam)ents[index]; 
		if (_GenBeam.find(gb) == -1) 
		{
			_GenBeam.append(gb);
			gb.setModule(moduleName);
		}
	}	
}

if (_kExecuteKey == arSTrigger[1])
{
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select entity(s)"), GenBeam());
	  	if (ssE.go())
			ents.append(ssE.set());
		for (int index=0;index<ents.length();index++) 
		{ 
			GenBeam gb = (GenBeam)ents[index]; 
			if (_GenBeam.find(gb) != -1) 
			{
				_GenBeam.removeAt(_GenBeam.find(gb));
				gb.setModule("");
			}
		}	
}

if (_kExecuteKey == arSTrigger[2])
{
	for (int index=0;index<_GenBeam.length();index++) 
	{ 
		GenBeam gb = _GenBeam[index]; 
		gb.setModule("");
	}	
	_GenBeam.setLength(0);
}

if (_GenBeam.length() > 0 && _bOnDbCreated)
{
	moduleName.set(_GenBeam[0].module());
}

Hatch hatch(hatchPattern, patternScale);

Display hatchDisplay(hatchColor);
hatchDisplay.elemZone(el, nZone, 'I'); 

Point3d allPoints[0];

for (int index=0;index<_GenBeam.length();index++) 
{ 
	GenBeam genBeam = _GenBeam[index]; 
	if (! genBeam.bIsValid()) continue;
	
	if (genBeam.module() != moduleName)
	{
		genBeam.setModule(moduleName);
	}
	
	Body body = genBeam.realBody();
	Point3d vertexPoints[] = body.extremeVertices(vecZ);
	Point3d centerPoint = genBeam.ptCenSolid();
	Line zLine(centerPoint, vecZ);
	vertexPoints = zLine.orderPoints(vertexPoints);
	allPoints.append(centerPoint);
	Point3d topPoint = vertexPoints[vertexPoints.length() - 1];
	double distanceBetweenTopAndCenter = vecZ.dotProduct(topPoint - centerPoint);
	Plane genBeamTop(centerPoint + vecZ * distanceBetweenTopAndCenter, - vecZ);
	PlaneProfile gBmPP(genBeamTop);
	gBmPP.unionWith(body.shadowProfile(genBeamTop));

	hatchDisplay.draw(gBmPP, hatch);
}


//Point3d midPoint;

if (_GenBeam.length() > 0)
{
	
	_Pt0.setToAverage(allPoints);
	
}

if (_bOnDbCreated)
{
	_PtG.append(_Pt0 + vecX * U(100) + vecY * U(100));
}



Display nameDisplay(nameColor);
nameDisplay.dimStyle(dimStyle);
nameDisplay.addViewDirection(vecZ); 
nameDisplay.addViewDirection(- vecZ); 
nameDisplay.elemZone(el, nZone, 'I'); 
if (iShowModuleName == 1)
{
	nameDisplay.draw(moduleName, _PtG[0], vecX, vecY, 0, 0, 1);	
}



if (_bOnElementDeleted)
{
	eraseInstance();
	return;
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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End