#Version 8
#BeginDescription
Last modified by: Nils Gregor (support.de@hsbcad.com)
13.01.2021 -  version 1.02

This tsl optimizes sheeting in chosen zone. The sheeting is cut at vertical standarized lengths.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// 				This tsl optimizes the chosen sheet with the given length. 
/// 				They are squared off and cut at standarized lengths.
/// </summary>

/// <insert>
///
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="02.04.2019"></version>

/// <history>
/// RVW		1.00 - 20.03.2019 - 	Pilot version
/// RVW		1.01 - 02.04.2019 -	Make tsl work on element generation
/// NG		1.02 - 13.01.2021		HSB-10126 Split sheets only vertical

/// </hsitory>

double dEps = Unit(0.001, "mm");

String arSYesNo[] = {T("|Yes|"), T("|No|")};

String operations[] = {
	T("|Include|"),
	T("|Exclude|")
};

String categories[] = 
{
	T("|Filtering|"),
	T("|Optimizing|")
};

String operators[] = 
{
	T("|All|"),
	T("|Any|")
};

int arNYesNo[] = {_kYes, _kNo};
int zoneIndexes[] = {1,2,3,4,5,6,7,8,9,10};

String filterDefinitionTslName = "HSB_G-FilterGenBeams";


//region Category Filtering
	PropString operator(9, operators, T("|Operator|"), 1);
	operator.setCategory(categories[0]);
	operator.setDescription(T("|Specify whether all of the specified filter properties have to match or one of them|."));
	PropInt iFilterZone (0, zoneIndexes, T("|Filter sheets in zone|"));
	iFilterZone.setCategory(categories[0]);
	PropString sFilterBeamcode (1, "", T("|Filter sheets with beamcode|"));
	sFilterBeamcode.setCategory(categories[0]);
	PropString sFilterLabel (2, "", T("|Filter sheets with label|"));
	sFilterLabel.setCategory(categories[0]);
	PropString sFilterMaterial (7, "", T("|Filter sheets with material|"));
	sFilterMaterial.setCategory(categories[0]);
	PropString sFilterHsbID (8, "", T("|Filter sheets with hsbID|"));
	sFilterHsbID.setCategory(categories[0]);	
//End Category Filtering//endregion 

//region Category Optimizing
	PropString sSquareOff(5, arSYesNo,T("|Make ends squared|"));
	sSquareOff.setCategory(categories[1]);
	PropString sOptimizeLength(6, arSYesNo,T("|Optimize length|"),0);
	sOptimizeLength.setCategory(categories[1]);
	PropDouble dOptimizedLength(0, U(10000), T("|Optimized length|"));
	dOptimizedLength.setCategory(categories[1]);
	PropDouble dGap(1, U(0), T("|Gap|"));
	dGap.setCategory(categories[1]);	
//End Category Optimizing//endregion 


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("DMW-W_SplitVerticalSheeting");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
{
	setPropValuesFromCatalog(_kExecuteKey);
}


Element elements[0];

if (_bOnInsert) {
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
//Showdialog
	if (_kExecuteKey=="")
		showDialog();
		
	PrEntity ssE(TN("|Select a set of elements|"),Element());
	if(ssE.go()){
		_Element.append(ssE.elementSet());
	}
			
	String strScriptName = scriptName();
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Element lstElements[1];
	Entity lstEntities[1];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	mapTsl.setInt("MasterToSatellite", TRUE);
	mapTsl.setInt("ManualInserted", true);
	setCatalogFromPropValues("MasterToSatellite");
	
	for( int e=0;e<_Element.length();e++ ){
		
		Element selectedElement = _Element[e];
		if (!selectedElement.bIsValid()) continue;
				
		TslInst arTsl[] = selectedElement.tslInst();
		
		lstEntities[0] = selectedElement;
			
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	}
		
	eraseInstance();
	return;
}


// set properties from master
if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", true);
	}
}

if( _Element.length() == 0 ){
	reportMessage(TN("|Invalid selection|!"));
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



int zoneIndex = iFilterZone;
if (zoneIndex>5)
{
	zoneIndex = 5 - zoneIndex;
}

String sFilterZone = (String)zoneIndex;


int bSquareOff = arNYesNo[arSYesNo.find(sSquareOff, 0)];
int bOptimizeLength = arNYesNo[arSYesNo.find(sOptimizeLength, 0)];


if ( _bOnDebug || _bOnElementConstructed || manualInserted )
{
	Element el = _Element[0];
	
	CoordSys csEl = el.coordSys();
	Point3d ptEl = csEl.ptOrg();
	Vector3d vxEl = csEl.vecX();
	Vector3d vyEl = csEl.vecY();
	Vector3d vzEl = csEl.vecZ();
	Line lnX(ptEl, vxEl);
	
	Sheet arSheets[0];
	
	Entity elementGenBeamEntities[] = el.elementGroup().collectEntities(false, (Sheet()), _kModelSpace, false);
	
	Map filterGenBeamsMap;
	filterGenBeamsMap.setEntityArray(elementGenBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
	filterGenBeamsMap.setInt("Exclude", false);
	filterGenBeamsMap.setString("Operator[]", operator);
	filterGenBeamsMap.setString("Zone[]", sFilterZone);
	filterGenBeamsMap.setString("BeamCode[]", sFilterBeamcode);
	filterGenBeamsMap.setString("Label[]", sFilterLabel);
	filterGenBeamsMap.setString("Material[]", sFilterMaterial);
	filterGenBeamsMap.setString("HsbId[]", sFilterHsbID);
	
	int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, filterGenBeamsMap);
	if ( ! successfullyFiltered)
	{
		reportWarning(T("|GenBeams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
		eraseInstance();
		return;
	}
	
	Entity filteredGenBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
	for (int index = 0; index < filteredGenBeamEntities.length(); index++)
	{
		Entity entity = filteredGenBeamEntities[index];
		Sheet fSheet = (Sheet)entity;
		arSheets.append(fSheet);
	}
	
	for ( int i = 0; i < arSheets.length(); i++) {
		Sheet sh = (Sheet)arSheets[i];
		
		PlaneProfile ppSh = sh.profShape();
		PLine arPlSh[] = ppSh.allRings();
		int arBRingIsOpening[] = ppSh.ringIsOpening();
		
		int bOutlineFound = false;
		PLine plSh(vzEl);
		for ( int j = 0; j < arPlSh.length(); j++) {
			if ( arBRingIsOpening[j] )
				continue;
			plSh = arPlSh[j];
			
			bOutlineFound = true;
			break;
		}
		
		if ( ! bOutlineFound )
		{
			continue;
		}
			
		
		Point3d arPtSh[] = plSh.vertexPoints(false);
		
		CoordSys csSh = sh.coordSys();
		Vector3d vxSh = csSh.vecX();
		Vector3d vySh = csSh.vecY();
		Vector3d vzSh = csSh.vecZ();
		
//		Vector3d vxNew = vxSh;
		Vector3d vxNew = vxEl;
		vxNew.vis(sh.ptCen(), 1);
		
		double dLongestLnSeg = U(0);
		LineSeg arLnSeg[0];
//		for ( int j = 0; j < (arPtSh.length() - 1); j++) {
//			Point3d ptFrom = arPtSh[j];
//			Point3d ptTo = arPtSh[j + 1];
//			arLnSeg.append(LineSeg(ptFrom, ptTo));
//			
//			Vector3d vLnSeg(ptTo - ptFrom);
//			double dLLnSeg = vLnSeg.length();
//			vLnSeg.normalize();
//			
//			if ( dLLnSeg > dLongestLnSeg ) {
//				dLongestLnSeg = dLLnSeg;
//				vxNew = vLnSeg;
//			}
//		}
		Line lnVxNew(sh.ptCen(), vxNew);
		Line lnVyNew(sh.ptCen(), vzEl.crossProduct(vxNew));
		
		Cut arCut[0];
		Point3d arPtCut[0];
		if ( bSquareOff ) {
			Point3d arPtStart[0];
			Point3d arPtEnd[0];
			for ( int j = 0; j < arLnSeg.length(); j++) {
				LineSeg lnSeg = arLnSeg[j];
				Point3d ptFrom = lnSeg.ptStart();
				Point3d ptTo = lnSeg.ptEnd();
				
				Vector3d vLnSeg(ptTo - ptFrom);
				vLnSeg.normalize();
				
				if ( ! vLnSeg.isParallelTo(vxNew) )
					continue;
				
				if ( vLnSeg.dotProduct(vxNew) > 0 ) {
					arPtStart.append(ptFrom);
					arPtEnd.append(ptTo);
				}
				else {
					arPtStart.append(ptTo);
					arPtEnd.append(ptFrom);
				}
			}
			
			Point3d arPtStartX[] = lnVxNew.orderPoints(arPtStart);
			Point3d arPtEndX[] = lnVxNew.orderPoints(arPtEnd);
			if ( arPtStartX.length() == 0 || arPtEndX.length() == 0 )
				continue;
			
			Sheet arShSplittedStart[] = sh.dbSplit(Plane(arPtStartX[arPtStartX.length() - 1], vxNew), U(0.001));
			if ( arShSplittedStart.length() == 2 ) {
				Sheet shA = arShSplittedStart[0];
				Sheet shB = arShSplittedStart[1];
				if ( vxNew.dotProduct(shB.ptCenSolid() - shA.ptCenSolid()) < 0 ) {
					shB.dbErase();
					sh = shA;
				}
				else {
					shA.dbErase();
					sh = shB;
				}
			}
			else if ( arShSplittedStart.length() == 1 ) {
				Sheet shA = arShSplittedStart[0];
				if ( vxNew.dotProduct(sh.ptCenSolid() - shA.ptCenSolid()) < 0 ) {
					sh.dbErase();
					sh = shA;
				}
				else {
					shA.dbErase();
				}
			}
			
			Sheet arShSplittedEnd[] = sh.dbSplit(Plane(arPtEndX[0], vxNew), U(0.001));
			if ( arShSplittedEnd.length() == 2 ) {
				Sheet shA = arShSplittedEnd[0];
				Sheet shB = arShSplittedEnd[1];
				if ( vxNew.dotProduct(shA.ptCenSolid() - shB.ptCenSolid()) < 0 ) {
					shB.dbErase();
					sh = shA;
				}
				else {
					shA.dbErase();
					sh = shB;
				}
			}
			else if ( arShSplittedEnd.length() == 1 ) {
				Sheet shA = arShSplittedEnd[0];
				if ( vxNew.dotProduct(shA.ptCenSolid() - sh.ptCenSolid()) < 0 ) {
					sh.dbErase();
					sh = shA;
				}
				else {
					shA.dbErase();
				}
			}
		}
		
		if ( bOptimizeLength ) {
			Point3d arPtSh[] = sh.profShape().getGripVertexPoints();
			arPtSh = lnVxNew.orderPoints(arPtSh);
			if ( arPtSh.length() < 2 )
				continue;
			
			double dShL = vxNew.dotProduct(arPtSh[arPtSh.length() - 1] - arPtSh[0]);
			Point3d ptSplit = arPtSh[0] + vxNew * dOptimizedLength;
			int nNrOfLoops = 0;
			while ( dShL > (dOptimizedLength + dEps) ) {
				Sheet arShSplit[] = sh.dbSplit(Plane(ptSplit + vxNew * 0.5 * dGap, vxNew), dGap);
				arShSplit.append(sh);
				if ( arShSplit.length() == 0 )
					break;
				
				double dLMax = 0;
				for ( int j = 0; j < arShSplit.length(); j++) {
					Sheet shSplitted = arShSplit[j];
					
					Point3d arPtSh[] = shSplitted.profShape().getGripVertexPoints();
					arPtSh = lnVxNew.orderPoints(arPtSh);
					if ( arPtSh.length() < 2 )
						continue;
					
					double dShL = vxNew.dotProduct(arPtSh[arPtSh.length() - 1] - arPtSh[0]);
					if ( dShL > dLMax ) {
						sh = shSplitted;
						dLMax = dShL;
						ptSplit = arPtSh[0] + vxNew * dOptimizedLength;
					}
				}
				
				if ( nNrOfLoops > 5 )
					break;
				
				nNrOfLoops++;
			}
		}
	}
	
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