#Version 8
#BeginDescription
Convert any beams that match section size to one of the profiles described in the properties.

Modified by: Robert Pol
Date: 31.10.2019 - version 2.0
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 0
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2017 by
*  hsbcad
*  UK
*
*  The program may be used and/or copied only with the written
*  permission from hsbcad, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*/

_ThisInst.setSequenceNumber(-120);

Unit(1,"mm"); // script uses mm
double dEps =U(.1);
String executeKey = "ManualInsert";
String sDefault =T("|_Default|");
String sLastInserted =T("|_LastInserted|");	
String category = T("|General|");
String sArNY[] = {T("No"), T("Yes")};

category = T("|Filter|");
String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");

PropString genBeamFilterDefinition(16, filterDefinitions, T("|Filter definition for beam to convert|"));
genBeamFilterDefinition.setDescription(T("|Filter definition for beams.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
genBeamFilterDefinition.setCategory(category);

category = T("|Profiles|");
PropString sProfile1( 0, ExtrProfile().getAllEntryNames(), T("|Extrusion profile 1|"));
sProfile1.setCategory(category);

PropString sProfile2( 1, ExtrProfile().getAllEntryNames(), T("|Extrusion profile 2|"));
sProfile2.setCategory(category);

PropString sProfile3( 2, ExtrProfile().getAllEntryNames(), T("|Extrusion profile 3|"));
sProfile3.setCategory(category);

PropString sProfile4( 3, ExtrProfile().getAllEntryNames(), T("|Extrusion profile 4|"));
sProfile4.setCategory(category);

PropString sProfile5( 4, ExtrProfile().getAllEntryNames(), T("|Extrusion profile 5|"));
sProfile5.setCategory(category);

PropString sProfile6( 5, ExtrProfile().getAllEntryNames(), T("|Extrusion profile 6|"));
sProfile6.setCategory(category);

PropString sProfile7( 6, ExtrProfile().getAllEntryNames(), T("|Extrusion profile 7|"));
sProfile7.setCategory(category);

PropString sProfile8( 7, ExtrProfile().getAllEntryNames(), T("|Extrusion profile 8|"));
sProfile8.setCategory(category);

PropString sProfile9( 8, ExtrProfile().getAllEntryNames(), T("|Extrusion profile 9|"));
sProfile9.setCategory(category);

PropString sProfile10( 9, ExtrProfile().getAllEntryNames(), T("|Extrusion profile 10|"));
sProfile10.setCategory(category);

PropString sProfile11( 10, ExtrProfile().getAllEntryNames(), T("|Extrusion profile 11|"));
sProfile11.setCategory(category);

PropString sProfile12( 11, ExtrProfile().getAllEntryNames(), T("|Extrusion profile 12|"));
sProfile12.setCategory(category);

PropString sProfile13( 12, ExtrProfile().getAllEntryNames(), T("|Extrusion profile 13|"));
sProfile13.setCategory(category);

PropString sProfile14( 13, ExtrProfile().getAllEntryNames(), T("|Extrusion profile 14|"));
sProfile14.setCategory(category);

PropString sProfile15( 14, ExtrProfile().getAllEntryNames(), T("|Extrusion profile 15|"));
sProfile15.setCategory(category);

PropString sProfile16( 15, ExtrProfile().getAllEntryNames(), T("|Extrusion profile 16|"));
sProfile16.setCategory(category);

if( _Map.hasString("DspToTsl") )
{
	String sCatalogName = _Map.getString("DspToTsl");
	setPropValuesFromCatalog(sCatalogName);
	
	_Map.removeAt("DspToTsl", true);
}

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( _bOnDbCreated && catalogNames.find(_kExecuteKey) != -1 ) 
{
	setPropValuesFromCatalog(_kExecuteKey);	
}

//int nYesNoRemoveBattenAtSheetSplit = sArNY.find(sYesNoRemoveBattenAtSheetSplit, 0);

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
		}
		else
		{
			setPropValuesFromCatalog(sLastInserted);
		}
	}	
	else	
	{
		showDialog();
		setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
	}
	
// prompt for elements
	PrEntity ssE(T("|Select element(s)|"), Element());
  	if (ssE.go())
  	{
		_Element.append(ssE.elementSet());
  	}

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

// insert per element
	for(int i=0;i<_Element.length();i++)
	{
		entsTsl[0]= _Element[i];	
		ptsTsl[0]=_Element[i].ptOrg();
		
		tslNew.dbCreate(scriptName(), vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, sLastInserted, true, mapTsl, executeKey, "");
	}

	eraseInstance();
	return;
}	

if( _Element.length()==0 )
{
	eraseInstance();
	return;
}

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

Entity elementGenBeamEntities[] = el.elementGroup().collectEntities(false, (Beam()), _kModelSpace, false);

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(elementGenBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, genBeamFilterDefinition, filterGenBeamsMap);
if ( ! successfullyFiltered)
{
	reportWarning(T("|GenBeams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
}

Entity filteredGenBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");

String sProfileName[0];
double dProfileWidth[0];
double dProfileHeight[0];

if (sProfile1 != _kExtrProfRectangular && sProfile1 !=_kExtrProfRound)
{
	sProfileName.append(sProfile1);
	dProfileWidth.append(0);
	dProfileHeight.append(0);
}

if (sProfile2 != _kExtrProfRectangular && sProfile2 !=_kExtrProfRound)
{
	sProfileName.append(sProfile2);
	dProfileWidth.append(0);
	dProfileHeight.append(0);
}

if (sProfile3 != _kExtrProfRectangular && sProfile3 !=_kExtrProfRound)
{
	sProfileName.append(sProfile3);
	dProfileWidth.append(0);
	dProfileHeight.append(0);
}

if (sProfile4 != _kExtrProfRectangular && sProfile4 !=_kExtrProfRound)
{
	sProfileName.append(sProfile4);
	dProfileWidth.append(0);
	dProfileHeight.append(0);
}

if (sProfile5 != _kExtrProfRectangular && sProfile5 !=_kExtrProfRound)
{
	sProfileName.append(sProfile5);
	dProfileWidth.append(0);
	dProfileHeight.append(0);
}

if (sProfile6 != _kExtrProfRectangular && sProfile6 !=_kExtrProfRound)
{
	sProfileName.append(sProfile6);
	dProfileWidth.append(0);
	dProfileHeight.append(0);
}

if (sProfile7 != _kExtrProfRectangular && sProfile7 !=_kExtrProfRound)
{
	sProfileName.append(sProfile7);
	dProfileWidth.append(0);
	dProfileHeight.append(0);
}

if (sProfile8 != _kExtrProfRectangular && sProfile8 !=_kExtrProfRound)
{
	sProfileName.append(sProfile8);
	dProfileWidth.append(0);
	dProfileHeight.append(0);
}

if (sProfile9 != _kExtrProfRectangular && sProfile9 !=_kExtrProfRound)
{
	sProfileName.append(sProfile9);
	dProfileWidth.append(0);
	dProfileHeight.append(0);
}

if (sProfile10 != _kExtrProfRectangular && sProfile10 !=_kExtrProfRound)
{
	sProfileName.append(sProfile10);
	dProfileWidth.append(0);
	dProfileHeight.append(0);
}

if (sProfile11 != _kExtrProfRectangular && sProfile11 !=_kExtrProfRound)
{
	sProfileName.append(sProfile11);
	dProfileWidth.append(0);
	dProfileHeight.append(0);
}

if (sProfile12 != _kExtrProfRectangular && sProfile12 !=_kExtrProfRound)
{
	sProfileName.append(sProfile12);
	dProfileWidth.append(0);
	dProfileHeight.append(0);
}

if (sProfile13 != _kExtrProfRectangular && sProfile13 !=_kExtrProfRound)
{
	sProfileName.append(sProfile13);
	dProfileWidth.append(0);
	dProfileHeight.append(0);
}

if (sProfile14 != _kExtrProfRectangular && sProfile14 !=_kExtrProfRound)
{
	sProfileName.append(sProfile14);
	dProfileWidth.append(0);
	dProfileHeight.append(0);
}

if (sProfile15 != _kExtrProfRectangular && sProfile15 !=_kExtrProfRound)
{
	sProfileName.append(sProfile15);
	dProfileWidth.append(0);
	dProfileHeight.append(0);
}

if (sProfile16 != _kExtrProfRectangular && sProfile16 !=_kExtrProfRound)
{
	sProfileName.append(sProfile16);
	dProfileWidth.append(0);
	dProfileHeight.append(0);
}

for (int i=0; i<sProfileName.length(); i++)
{
	ExtrProfile epInvest(sProfileName[i]); // constructor with a extrusion profile name

	PlaneProfile profNotScaled = epInvest.planeProfile();
	LineSeg lsThisProfile = profNotScaled.extentInDir(_XW);
	double dWidthProfile=abs(_XW.dotProduct(lsThisProfile.ptStart()-lsThisProfile.ptEnd()));
	double dHeightProfile=abs(_YW.dotProduct(lsThisProfile.ptStart()-lsThisProfile.ptEnd()));
	dProfileWidth[i]=dWidthProfile;
	dProfileHeight[i]=dHeightProfile;
}

for (int x=0; x<filteredGenBeamEntities.length(); x++)
{
	Beam bm= (Beam)filteredGenBeamEntities[x];
	if ( ! bm.bIsValid()) continue;
	
	double dThisWidth=bm.dW();
	double dThisHeight=bm.dH();
	
	for (int i=0; i<dProfileWidth.length(); i++)
	{
		if (abs(dProfileWidth[i]-dThisWidth) < dEps && abs(dProfileHeight[i]-dThisHeight) < dEps)
		{
			//match
			bm.setExtrProfile(sProfileName[i]);
			//reportNotice("\n"+sProfileName[i]);
		}
	}
}

if (_kExecuteKey == executeKey || _bOnElementConstructed)
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