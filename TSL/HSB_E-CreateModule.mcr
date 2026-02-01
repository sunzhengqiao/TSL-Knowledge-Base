#Version 8
#BeginDescription
Last modified by: Robert Pol (support.nl@hsbcad.com)

17.11.2021  -  version 2.02
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 2
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

/// <version  value="2.00" date="10-07-2018"></version>

/// <history>
/// RP - 1.00 - 07-06-2018 -  Pilot version.
/// RP - 1.01 - 07-06-2018 -  set catolog from executekey
/// RP - 2.00 - 10-07-2018 -  Add option to create multiple openings based on entity selection and add genbeamfilter
/// RP - 2.01 - 18-07-2018 -  Add shrinkdistance and set it to 5 mm (Vadeko request)
/// RP - 2.02 - 17-11-2021 -  Add color prop
/// </history>
//endregion

U(1,"mm");	
double dEps =U(.1);
double shrinkDistance =U(5);
int nDoubleIndex, nStringIndex, nIntIndex;
String sDoubleClick= "TslDoubleClick";
int bDebug=_bOnDebug;
bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
String sDefault =T("|_Default|");
String sLastInserted =T("|_LastInserted|");	
String category = T("|General|");
String sNoYes[] = { T("|No|"), T("|Yes|")};
String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String executeKey = "ManualInsert";

_ThisInst.setSequenceNumber(2000);

String filterGenBeamCatalogs[0];
filterGenBeamCatalogs.append("");
filterGenBeamCatalogs.append(TslInst().getListOfCatalogNames(filterDefinitionTslName));

PropString filterGenBeamCatalog(nStringIndex++, filterGenBeamCatalogs, T("|GenBeam filter catalog|"));	
filterGenBeamCatalog.setDescription(T("|Select the catalog to filter the genbeams from the element|"));
filterGenBeamCatalog.setCategory(category);


PropDouble color(nDoubleIndex++, 2, T("|Color|"));	
color.setCategory(category);

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
		showDialog();
	
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
		entsTsl[0]= _Element[i];	
		ptsTsl[0]=_Element[i].ptOrg();
		
		tslNew.dbCreate(scriptName(), vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, sLastInserted, true, mapTsl, executeKey, "");
		
		if(bDebug && tslNew.bIsValid())reportMessage("\n"+ scriptName() + " created for " +_Element[i].number());
	}

	eraseInstance();
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
Element el = _Element[0];
CoordSys cs = el.coordSys();
Vector3d vecX = cs.vecX();
Vector3d vecY = cs.vecY();
Vector3d vecZ = cs.vecZ();
Point3d ptOrg = cs.ptOrg();
assignToElementGroup(el,true, 0,'E');// assign to element tool sublayer

GenBeam elementGenBeam[] = el.genBeam();
Entity elementGenBeamEntities[0];

for (int index=0;index<elementGenBeam.length();index++) 
{ 
	Entity entity = (Entity)elementGenBeam[index]; 
	elementGenBeamEntities.append(entity);
}

Entity filteredEntities[0];
Map filterEntitiesMap;
filterEntitiesMap.setEntityArray(elementGenBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, filterGenBeamCatalog, filterEntitiesMap);
if ( ! successfullyFiltered)
{
	reportWarning(T("|GenBeam could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
}
filteredEntities.append(filterEntitiesMap.getEntityArray("GenBeams", "GenBeams", "GenBeam"));

String moduleName;
Plane elementPlane(ptOrg, - vecZ);
PlaneProfile overallPP(el.coordSys());

for (int e=0;e<filteredEntities.length();e++)
{
	GenBeam gBm = (GenBeam)filteredEntities[e];
	if (!gBm.bIsValid()) continue;
	
	Body gBmBody = gBm.envelopeBody();
	PlaneProfile gBmPP = gBmBody.shadowProfile(elementPlane);
	gBmPP.shrink(U(-shrinkDistance));
	overallPP.unionWith(gBmPP);
	//overallPP.vis(2);
}

overallPP.vis(1);
PLine moduleRings[0];

PLine allPlines[] = overallPP.allRings();
int ringsAreOpening[] = overallPP.ringIsOpening();

for (int index=0;index<allPlines.length();index++) 
{ 
	PLine pline = allPlines[index]; 
	if (ringsAreOpening[index]) continue;
	
	moduleRings.append(pline);
}

for (int index=0;index<moduleRings.length();index++) 
{ 
	PLine pline = moduleRings[index]; 
	PlaneProfile modulePP(pline); 
	
	for (int g=0;g<filteredEntities.length();g++) 
	{ 
		GenBeam genBeam = (GenBeam)filteredEntities[g]; 
		if (!genBeam.bIsValid()) continue;
		Point3d center = genBeam.ptCenSolid();
		if (modulePP.pointInProfile(center) == _kPointInProfile)
		{
			genBeam.setModule(el.number() + "_" + (index +1) );
			genBeam.setColor((int)color);
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

#End