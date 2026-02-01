#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
12.12.2012  -  version 1.0



























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
/// <summary Lang=en>
/// Tsl to create nail lines on specific zones
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="12.12.2012"></version>

/// <history>
/// 1.00 - 12.12.2012 - 	Pilot version
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
int arNColorForZnToProcess[] = {
	1,
	2,
	3,
	4,
	6,
	5,// color 5 was in old tsl also set for nailing on zone 6
	7,
	8,
	9,
	10
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
		
		String strScriptName = "HSB_W-StudMarker"; // name of the script
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

// nail these zones
int arNZone[0];
int nZnToProcess = arNZnToProcess[arSZnToProcess.find(sApplyToolingTo,5)];
arNZone.append(nZnToProcess);
int arNColorIndex[0];
arNColorIndex.append(arNColorForZnToProcess[arSZnToProcess.find(sApplyToolingTo,5)]);

// do not nail on beams with one of the following beamcodes
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
Beam arBm[0];
Beam arBmVertical[0];
for( int i=0;i<arBmAll.length();i++ ){
	Beam bm = arBmAll[i];
	
	if( arSBmCodeFilter.length() > 0 && arSBmCodeFilter.find(bm.beamCode().token(0)) == -1 )
		continue;
	
	arBm.append(bm);
	
	if( bm.vecX().isParallelTo(vyEl) )
		arBmVertical.append(bm);
}

// remove all nailing lines of nZone with color nColorIndex
for( int i=0;i<arNZone.length();i++ ){
	// zone
	int nZone = arNZone[i];
	
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
	
}























#End
#BeginThumbnail



#End
