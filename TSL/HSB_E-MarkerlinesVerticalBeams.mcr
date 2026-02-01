#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
22.12.2016  -  version 1.01




























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
/// <summary Lang=en>
/// Tsl to create marker lines at the location of vertical beams on a specific zone.
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="22.12.2016"></version>

/// <history>
/// 1.00 - 19.03.2013 - 	Pilot version
/// 1.01 - 22.12.2016 - 	Update summary.
/// </hsitory>

double dEps(Unit(0.01,"mm"));

PropString sSeperator01(0, "", T("|Selection|"));
sSeperator01.setReadOnly(true);
String arSElementType[] = {T("|Roof|"), T("|Floor|"), T("|Wall|")};
String arSElementTypeCombinations[0];
int jStart = 1;
for( int i=0;i<arSElementType.length();i++ ){
	String sTypeA = arSElementType[i];
	if( arSElementTypeCombinations.find(sTypeA) == -1 )
		arSElementTypeCombinations.append(sTypeA);
	
	int j = jStart;

	while( j<arSElementType.length() ){
		String sTypeB = arSElementType[j];
		
		sTypeA += ";"+sTypeB;
		arSElementTypeCombinations.append(sTypeA);

		j++;
	}
	
	jStart++;
	if( jStart < arSElementType.length() )
		i--;
	else
		jStart = i+2;
}
PropString sApplyToolingToElementType(1, arSElementTypeCombinations, "     "+T("|Apply tooling to element type(s)|"),6);
// filter beams with beamcode
PropString sFilterBC(2,"","     "+T("Only mark beams with beamcode"));


String arSZnToProcess[] = {
	"Zone 1",
	"Zone 2",
	"Zone 3",
	"Zone 4",
	"Zone 5",
	"Zone 6",
	"Zone 7",
	"Zone 8",
	"Zone 9",
	"Zone 10"
};
int arNZnToProcess[] = {
	1,
	2,
	3,
	4,
	5,
	-1,
	-2,
	-3,
	-4,
	-5
};

PropString sSeperator02(3, "", T("|Tooling|"));
sSeperator02.setReadOnly(true);
PropDouble dMarkSize(0, U(300), "     "+T("|Length markerline|"));
PropString sApplyToolingTo(4, arSZnToProcess, "     "+T("|Apply tooling to|"),0);

PropInt nToolingIndex(0, 10, "     "+T("|Toolindex|"));



if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	showDialog();
	
	PrEntity ssE(T("Select a set of elements"), Element());
	
	if( ssE.go() ){
		Element arSelectedElement[] = ssE.elementSet();
		
		String strScriptName = "HSB_E-MarkerlinesVerticalBeams"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Element lstElements[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", TRUE);
		setCatalogFromPropValues("MasterToSatellite");
				
		for( int e=0;e<arSelectedElement.length();e++ ){
			Element el = arSelectedElement[e];
			lstElements[0] = el;
			
			TslInst arTsl[] = el.tslInst();
			for( int i=0;i<arTsl.length();i++ ){
				TslInst tsl = arTsl[i];
				if( tsl.scriptName() == strScriptName && tsl.propString("     "+T("|Apply tooling to|")) == sApplyToolingTo){
					tsl.dbErase();
				}
			}
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}
	}
	
	eraseInstance();
	return;
}

if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", TRUE);
	}
}

// resolve properties

int nZone = arNZnToProcess[arSZnToProcess.find(sApplyToolingTo,5)];

// only nail on beams with one of the following beamcodes, empty means all beams
String sFBC = sFilterBC + ";";
sFBC.makeUpper();
String arSBmCodeFilter[0];
int nIndexBC = 0; 
int sIndexBC = 0;
while(sIndexBC < sFBC.length()-1){
	String sTokenBC = sFBC.token(nIndexBC);
	nIndexBC++;
	if(sTokenBC.length()==0){
		sIndexBC++;
		continue;
	}
	sIndexBC = sFBC.find(sTokenBC,0);
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSBmCodeFilter.append(sTokenBC);
}

// check if there is a valid element selected.
if( _Element.length()==0 ){
	eraseInstance();
	return;
}

// get element
Element el = _Element[0];


Opening arOp[] = el.opening();

// create coordsys
CoordSys csEl = el.coordSys();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
// set origin point
_Pt0 = csEl.ptOrg();

Point3d ptZone = el.zone(nZone).coordSys().ptOrg();
int nSide = nZone/abs(nZone);

double dz = vzEl.dotProduct(_ZW);
String sElemType;
if( abs(dz - 1) < dEps ){
	sElemType = T("|Floor|");
}
else if( abs(dz) < dEps ){
	sElemType = T("|Wall|");
}
else{
	sElemType = T("|Roof|");
}

if( sApplyToolingToElementType.find(sElemType,0) == -1 ){
	reportMessage(TN("|Element type filtered out|"+": "+sElemType));
	eraseInstance();
	return;
}

// display
Display dp(-1);

// collect beams used for nailing
Beam arBmAll[] = el.beam();
Beam arBmVertical[0];
for( int i=0;i<arBmAll.length();i++ ){
	Beam bm = arBmAll[i];
	// Beam must be vertical.
	if( !bm.vecX().isParallelTo(vyEl) )
		continue;
	
	//Ignore beams which are not on top of the specified zone.
	if( (nSide*vzEl).dotProduct(bm.ptCen() - ptZone) < (0.45 * bm.dD(vzEl)) )
		continue;
	
	//Only accept beamcodes from the specified list. All beams are taken if the list is empty.
	if( arSBmCodeFilter.length() > 0 && arSBmCodeFilter.find(bm.beamCode().token(0)) == -1 )
		continue;
	
	// Valid beam found. Add it to the list of beams to process.
	arBmVertical.append(bm);
}

PlaneProfile ppZn = el.profNetto(nZone);
for( int j=0;j<arBmVertical.length();j++ ){
	Beam bm  = arBmVertical[j];
	
	Point3d arPtBm[] = {
		bm.ptRef() + bm.vecX() * bm.dLMin(),
		bm.ptRef() + bm.vecX() * bm.dLMax()
	};
	Vector3d arVDir[] = {
		bm.vecX(),
		-bm.vecX()
	};
	
	for( int k=0;k<arPtBm.length();k++ ){
		Point3d ptStartMark = arPtBm[k] - vxEl * 0.5 * bm.dD(vxEl);
		Vector3d vDir = arVDir[k];
		
		PLine plMark(vzEl);
		plMark.addVertex(ptStartMark);
		plMark.addVertex(ptStartMark + vDir * dMarkSize);
		
		ElemMarker elMarker(nZone, plMark, nToolingIndex);
		el.addTool(elMarker);
		
		plMark.transformBy(vxEl * bm.dD(vxEl));
		elMarker = ElemMarker(nZone, plMark, nToolingIndex);
		el.addTool(elMarker);
	}		
}
























#End
#BeginThumbnail
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
,5E4JRJ;EPIJ&Q__9
`

#End
