#Version 8
#BeginDescription
Hatch beams with an specific code in paper or shopdraw space.

Modified by: Chirag Sawjani
Date: 04.09.2018 - version 1.8


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 8
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT 
*  IRELAND
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 28.08.2008
* version 1.1: Add Spline Hatch
*
* date: 09.03.2011
* version 1.2: Add Beam Code so only beams with that code will be hatch
*
* Modified by CS
* date: 09.05.2011
* version 1.3: Added functionality to hatch in shop drawings
*
* date: 24.07.2012
* version 1.4: Now have the option to filter by zone
*/

Unit (1,"mm");
double dEps = U(0.1);

String arSYesNo[] = {T("Yes"),T("No")};
int arNTrueFalse[] = {TRUE, FALSE};

String arSLocationInZone[] = {T("All"),T("Front"),T("Back")};

int nValidZones[]={0,1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={0,1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZones (2, nValidZones, T("Zone to hatch"));

PropString sLocationInZone(6, arSLocationInZone, T("|Location in zone|"), 0);
int nLocationInZone = arSLocationInZone.find(sLocationInZone, 0);

PropString sFilterBeams(2, "TP;BP;", T("|Hatch Only Beams with Code|"));
sFilterBeams.setDescription(T("|Separate multiple entries by|") +" ';'"+T(" |Leave blank for all|"));

PropString sFilterBeamName(5, "", T("|Hatch Only Beams with Name|"));
sFilterBeamName.setDescription(T("|Separate multiple entries by|") +" ';'"+T(" |Leave blank for all|"));


String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");

PropString genBeamFilterDefinition(7, filterDefinitions, T("|Filter definition for beams to hatch|"));
genBeamFilterDefinition.setDescription(T("|Filter definition for beams to hatch.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));

PropString pHatchPattern(0,_HatchPatterns,"Hatch pattern");

//PropDouble dHatch(0, U(30), T("Distance between hatch lines"));
PropDouble dAngle(0, 45, T("Hatch Angle"));
dAngle.setFormat(_kAngle);
PropDouble dHatchScale(1,U(1),T("Hatch Scale"));
//dAngle.setReadOnly(TRUE);
//PropString sCrossHatch(0, arSYesNo, T("Cross hatch"),0);
//int nCrossHatch = FALSE;//arNTrueFalse[ arSYesNo.find(sCrossHatch,0) ];
PropInt nColorHatch(0, 1, T("Hatch Color"));

PropString pHatchPatternSPline(1,_HatchPatterns,"Hatch pattern Spline");
PropDouble dAngleSPline(2, 45, T("Hatch Angle Spline"));
dAngleSPline.setFormat(_kAngle);
PropDouble dHatchScaleSPline(3,U(1),T("Hatch Scale Spline"));
PropInt nColorHatchSPline(1, 1, T("Hatch Color SPline"));
//PropString sLineType(0, "ByLayer", T("Line type"));
//
String sPaperSpace = T("|paper space|");
String sShopdrawSpace = T("|shopdraw multipage|");
String sArSpace[] = { sPaperSpace , sShopdrawSpace };
PropString sSpace(3,sArSpace,T("|Drawing space|"));

PropString sDefaultBeamColour(4, arSYesNo, T("|Default colour should be beam colour| "),0);

//------------------------------------------------------------------------------------------------------------------------
//                                                                    Insert

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

int nZone=nRealZones[nValidZones.find(nZones, 0)];

if( _bOnInsert ){
	
	showDialog();
	if (sSpace == sPaperSpace)
	{	//Paper Space
  		Viewport vp = getViewport(T("Select the viewport from which the element is taken")); // select viewport
		_Viewport.append(vp);
	}
	else if (sSpace == sShopdrawSpace)
	{	//Shopdraw Space
		Entity ent = getShopDrawView(T("|Select the view entity from which the module is taken|")); // select ShopDrawView
		_Entity.append(ent);
	}
}

//paperspace
Viewport vp;
CoordSys ms2ps;
CoordSys ps2ms;
Element el;
Beam arBm[0];

if ( sSpace == sPaperSpace )
{
	if( _Viewport.length() == 0 )
	{
		eraseInstance();
		return;
	}
	

	vp	= _Viewport[0];
	_Pt0 = vp.ptCenPS();


	ms2ps = vp.coordSys();
	ps2ms = ms2ps; ps2ms.invert();	
	
	el = vp.element();
	if(!el.bIsValid())return;

}
else if (sSpace == sShopdrawSpace ) {
	
	if (_Entity.length()==0)
	{
		eraseInstance();
		return; // _Entity array has some elements
	}
	
	ShopDrawView sv = (ShopDrawView)_Entity[0];
	
	if (!sv.bIsValid()) 
		return;
	
	// interprete the list of ViewData in my _Map
	ViewData arViewData[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
	int nIndFound = ViewData().findDataForViewport(arViewData, sv);// find the viewData for my view
	if (nIndFound<0) 
		return; // no viewData found
	
	ViewData vwData = arViewData[nIndFound];
	Entity arEnt[] = vwData.showSetEntities();
	
	ms2ps = vwData.coordSys();
	ps2ms = ms2ps;
	ps2ms.invert();
	
	for (int i = 0; i < arEnt.length(); i++)
	{
		Entity ent = arEnt[i];
		if (ent.bIsKindOf(Element()))
		{
			el=(Element) ent;
			break;
		}
		if(ent.bIsKindOf(Beam()))
		{
			arBm.append((Beam)ent);
		}
	}
}

Display dpHatch(nColorHatch);

Display dpHatchSPline(nColorHatchSPline);

Hatch hatch(pHatchPattern ,dHatchScale);
hatch.setAngle(dAngle); 

Hatch hatchSPline(pHatchPatternSPline ,dHatchScaleSPline);
hatchSPline.setAngle(dAngleSPline); 

CoordSys cs=el.coordSys();
Vector3d vx=cs.vecX();
Vector3d vy=cs.vecY();
Vector3d vz=cs.vecZ();
Point3d ptOrgEl=cs.ptOrg();

// transform filter tsl property into array
String sBeamFilter[0];
String sList = sFilterBeams;
int bBmFilter=FALSE;

while (sList.length()>0 || sList.find(";",0)>-1)
{
	String sToken = sList.token(0);	
	sToken.trimLeft();
	sToken.trimRight();		
	sToken.makeUpper();
	sBeamFilter.append(sToken);
	//double dToken = sToken.atof();
	//int nToken = sToken.atoi();
	int x = sList.find(";",0);
	sList.delete(0,x+1);
	sList.trimLeft();	
	if (x==-1)
		sList = "";
}

if (sBeamFilter.length() > 0)
	bBmFilter=TRUE;

// transform filter tsl property into array
String sBeamFilterName[0];
String sListName = sFilterBeamName;
int bBmFilterName=FALSE;

while (sListName.length()>0 || sListName.find(";",0)>-1)
{
	String sToken = sListName.token(0);	
	sToken.trimLeft();
	sToken.trimRight();		
	sToken.makeUpper();
	sBeamFilterName.append(sToken);
	//double dToken = sToken.atof();
	//int nToken = sToken.atoi();
	int x = sListName.find(";",0);
	sListName.delete(0,x+1);
	sListName.trimLeft();	
	if (x==-1)
		sListName = "";
}

if (sBeamFilterName.length() > 0)
	bBmFilterName=TRUE;

if(el.bIsValid())
{
	GenBeam gbmAux[]=el.genBeam(nZone);
	arBm.setLength(0);
	for (int i=0; i<gbmAux.length(); i++)
	{
		Beam bm=(Beam) gbmAux[i];
		if (bm.bIsValid())
		{
			arBm.append(bm);
		}
	}
}
else
{
	for(int i=0;i<_Entity.length();i++)
	{
		Entity ent=_Entity[i];
		if(ent.bIsKindOf(Beam()))
		{
			arBm.append((Beam)ent);
		}
	}
}


Entity genBeamEntities[0];{ }
for (int b=0;b<arBm.length();b++)
{
	genBeamEntities.append(arBm[b]);
}

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, genBeamFilterDefinition, filterGenBeamsMap);
if (!successfullyFiltered) {
	reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
} 

Entity filteredGenBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
GenBeam gbFiltered[0];
for (int e=0;e<filteredGenBeamEntities.length();e++) 
{
	GenBeam bm = (GenBeam)filteredGenBeamEntities[e];
	if (!bm.bIsValid()) continue;

	gbFiltered.append(bm);
}

arBm.setLength(0);
for (int b=0;b<gbFiltered.length();b++)
{
	Beam bm = (Beam)gbFiltered[b];
	if ( ! bm.bIsValid()) continue;
	
	arBm.append(bm);
}


if (arBm.length()<1)
	return;




if(el.bIsValid())
{
	Plane pln(ptOrgEl-vz*U(10), vz);
	ElemZone elZone = el.zone(nZone);
	double zoneThickness = elZone.dH();
	CoordSys zoneCoords = elZone.coordSys();
	zoneCoords.vis();
	
	for( int i=0; i<arBm.length(); i++ )
	{
		
		Beam bm = arBm[i];
		if(sDefaultBeamColour=="Yes")
		{
			dpHatch = Display(bm.color());
		}
		Body bdBm=bm.realBody();
		bdBm.vis();
		
		PlaneProfile ppBm;
		if(nLocationInZone == 0)
		{ 
			ppBm=bdBm.shadowProfile(pln);	
		}
		else if(nLocationInZone==1)
		{ 
			Plane plFront;
			if(nZone >= 0)
			{ 
				plFront = Plane(zoneCoords.ptOrg() + vz * zoneThickness, vz);
			}
			else
			{ 
				plFront = Plane(zoneCoords.ptOrg() - vz * zoneThickness, vz);
			}
			plFront.vis(1);
			ppBm=bdBm.extractContactFaceInPlane(plFront, U(0.01));
		}
		else if(nLocationInZone==2)
		{ 
			Plane plBack;
			if(nZone >= 0)
			{ 
				plBack = Plane(zoneCoords.ptOrg(), vz);
			}
			else
			{ 
				plBack = Plane(zoneCoords.ptOrg(), vz);
			}
			plBack.vis(1);
			
			ppBm=bdBm.extractContactFaceInPlane(plBack, U(0.01));
		}
		ppBm.vis(1);
		ppBm.shrink(U(1));
		ppBm.transformBy(ms2ps);
		String sName=bm.name();
		sName.makeUpper();
		if (sName=="SPLINE")
		{
			dpHatchSPline.draw(ppBm, hatchSPline);
		}
		else if (bBmFilter==false && bBmFilterName==false)
		{
			dpHatch.draw(ppBm, hatch);
		}
		else if (bBmFilter==true)
		{
			if (sBeamFilter.find(bm.beamCode().token(0), -1) != -1)
			{
				dpHatch.draw(ppBm, hatch);
			}
		}else  if (bBmFilterName==true)
		{
			String sBeamNameThis = bm.name().makeUpper();
			sBeamNameThis.trimLeft();
			sBeamNameThis.trimRight();
			if (sBeamFilterName.find(sBeamNameThis, -1) != -1)
			{
				dpHatch.draw(ppBm, hatch);
			}
		}
	}
}
else
{
	for(int i=0;i<arBm.length();i++)
	{
		Beam bm=arBm[i];
		Body bdBm=bm.realBody();
		Plane plnY(bm.ptCen(),bm.vecY());
		Plane plnZ(bm.ptCen(),bm.vecZ());
		PlaneProfile ppBmY=bdBm.shadowProfile(plnY);
		PlaneProfile ppBmZ=bdBm.shadowProfile(plnZ);
		
		ppBmY.transformBy(ms2ps);
		ppBmZ.transformBy(ms2ps);
		dpHatch.draw(ppBmY,hatch);
		dpHatch.draw(ppBmZ,hatch);		
	}
}




#End
#BeginThumbnail










#End
#BeginMapX

#End