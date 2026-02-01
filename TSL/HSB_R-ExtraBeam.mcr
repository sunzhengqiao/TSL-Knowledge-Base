#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
27.06.2012  -  version 1.1













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
/// This tsl creates a brace (knee wall).
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// This tsl is attached to the DSP details
/// </remark>

/// <version  value="1.01" date="27.06.2012"></version>

/// <history>
/// AS - 1.00 - 22.06.2012 -	Pilot version
/// AS - 1.01 - 27.06.2012 -	Rename for DSP use () are not accepted.
/// </history>

//Script uses mm
double dEps = U(.001,"mm");

int arNZnIndex[] = {5,4,3,2,1,6,7,8,9,10};

PropString sSeperator01(0, "", T("|Extra beam|"));
sSeperator01.setReadOnly(true);
//Beamcode of beam to replace with extra beams
PropString sBmCodeExtraBeam(1, "KLO-01", "     "+T("|Beamcode extra beam|"));
PropDouble dWExtraBeam(0, U(45), "     "+T("|Width extra beam|"));

PropString sSeperator02(2, "", T("|Filter beams|"));
sSeperator02.setReadOnly(true);
// filter beams with beamcode
PropString sFilterBC(3,"ZKRB-03;ZKRB-04;ZKRH-03;ZKRH-04","     "+T("Filter beams with beamcode"));

if( _Map.hasString("DspToTsl") ){
	String sCatalogName = _Map.getString("DspToTsl");
	setPropValuesFromCatalog(sCatalogName);
	
	_Map.removeAt("DspToTsl", true);
}

if( _kExecuteKey != "" ){
	if( _bOnDbCreated ){
		setPropValuesFromCatalog(_kExecuteKey);
	}
}

//Insert
if( _bOnInsert ){
	//Erase after 1 cycle
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	//Showdialog
	if (_kExecuteKey=="")
	showDialog();
	
	//Select beam(s) and insertion point
	PrEntity ssE(T("|Select one or more elements|"), Element());
	if (ssE.go()) {
		Element arSelectedElements[] = ssE.elementSet();

		//insertion point
		String strScriptName = "HSB_R-ExtraBeam"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Entity lstEntities[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", TRUE);
		setCatalogFromPropValues("MasterToSatellite");
		
		for( int i=0;i<arSelectedElements.length();i++ ){
			Element el = arSelectedElements[i];
			if( !el.bIsValid() ){
				continue;
			}
			lstEntities[0] = el;
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}
	}
	
	return;
}

if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", TRUE);
	}
}

//Check if there is a valid element present
if( _Entity.length() == 0 ){
	eraseInstance();
	return;
}

//Get selected element
Element el = (Element)_Entity[0];
if( !el.bIsValid() ){
	eraseInstance();
	return;
}

String sFBC = sFilterBC + ";";
sFBC.makeUpper();
String arSFilterBmCode[0];
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
	arSFilterBmCode.append(sTokenBC);
}

String sBCExtraBeam = sBmCodeExtraBeam;
sBCExtraBeam.trimLeft();
sBCExtraBeam.trimRight();

//CoordSys
CoordSys csEl = el.coordSys();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

if( _PtG.length() == 0 ){
	_Pt0 = csEl.ptOrg();
	_PtG.append(_Pt0 + vxEl * U(5000));
}
Point3d ptStartDetail = _Pt0;
Point3d ptEndDetail = _PtG[0];
	
//_Pt0 = csEl.ptOrg();
Line lnX(csEl.ptOrg(), vxEl);

//Beams from element
Beam arBm[] = el.beam();

Point3d arPtBm[0];
//Rafters
Beam arBmRafter[0];
int arNBmTypeRafter[] = {
	_kDakCenterJoist,
	_kDakLeftEdge,
	_kDakRightEdge,
	_kExtraRafter
};
String arSHsbIdRafters[] = {
	"4101",
	"41141",
	"41145"
};

Beam arBmExtraBeam[0];

for( int i=0;i<arBm.length();i++ ){
	Beam bm = arBm[i];
	String sBmCode = bm.beamCode().token(0);
	
	arPtBm.append(bm.envelopeBody().allVertices());
	
	if( arSFilterBmCode.find(sBmCode) != -1 )
		continue;
	
	if( arNBmTypeRafter.find(bm.type()) != -1 || arSHsbIdRafters.find(bm.hsbId()) != -1 ){
		// check if it is a valid rafter
		
		Point3d ptBottom = bm.ptCenSolid() - vyEl * 0.5 * bm.solidLength();
		if( vyEl.dotProduct(ptBottom - csEl.ptOrg()) > U(200) )
			continue;
		
		arBmRafter.append(bm);
	}
	
	if( (vxEl.dotProduct(ptStartDetail - bm.ptCen()) * vxEl.dotProduct(ptEndDetail - bm.ptCen())) > 0 )
		continue;
	
	if( sBCExtraBeam != "" && sBmCode == sBCExtraBeam && bm.type() != _kStud )
		arBmExtraBeam.append(bm);
}

arPtBm = lnX.orderPoints(arPtBm);
if( arPtBm.length() == 0 ){
	eraseInstance();
	return;
}
Point3d ptElStart = arPtBm[0];
Point3d ptElEnd = arPtBm[arPtBm.length() - 1];

arBmRafter = vxEl.filterBeamsPerpendicularSort(arBmRafter);
	
Vector3d vxExtraBeam = -vyEl;
Vector3d vyExtraBeam = -vxEl;
Vector3d vzExtraBeam = -vzEl;
for( int i=0;i<arBmExtraBeam.length();i++ ){
	Beam bm = arBmExtraBeam[i];
	Body bdBm = bm.realBody();

	//CoordSys beam
	Point3d ptBm = bm.ptCen();
	Vector3d vxBm = bm.vecX();
	if( vxBm.dotProduct(vxEl) < 0 ){
		vxBm = -vxBm;
	}
	Vector3d vzBm = bm.vecZ();
	Vector3d vyBm = vzBm.crossProduct(vxBm);	
	
	Plane pnBmX(ptBm, vxEl);
	
	PlaneProfile ppExtraBeam = bdBm.getSlice(pnBmX);
	PLine arPlExtraBeam[] = ppExtraBeam.allRings();
	if( arPlExtraBeam.length() == 0 )
		return;
	//take biggest ring
	PLine plExtraBeam = arPlExtraBeam[0];
	for( int j=1;j<arPlExtraBeam.length();j++ ){
		PLine pl = arPlExtraBeam[j];
		if( pl.area() > plExtraBeam.area() )
			plExtraBeam = pl;
	}
	plExtraBeam.vis(1);
	Point3d arPtPlExtraBeam[] = plExtraBeam.vertexPoints(false);
	
	double dMaxLnSeg = -1;
	for( int j=0;j<(arPtPlExtraBeam.length() - 1);j++ ){
		Point3d ptFrom = arPtPlExtraBeam[j];
		Point3d ptTo = arPtPlExtraBeam[j+1];
		
		Vector3d vLnSeg(ptTo - ptFrom);
		if( vLnSeg.dotProduct(_ZW) < 0 )
			vLnSeg *= -1;
		
		double dLnSeg = vLnSeg.length();
		vLnSeg.normalize();
		if( abs(abs(vLnSeg.dotProduct(vyEl)) - 1) < dEps )
			continue;
		
		if( dLnSeg > dMaxLnSeg ){
			dMaxLnSeg = dLnSeg;
			vxExtraBeam = vLnSeg;
		}
	}
	vxExtraBeam = -vyEl;
	vzExtraBeam = -vxExtraBeam.crossProduct(vyExtraBeam);

	//Extreme points of this beam
	//Beam X
	Line lnX(bm.ptCen(), vxBm);
	Point3d arPtBm[] = bdBm.allVertices();
	Point3d arPtBmX[] = lnX.orderPoints(arPtBm);
	if( arPtBmX.length() < 2 )continue;
	Point3d ptBmMin = arPtBmX[0];
	Point3d ptBmMax = arPtBmX[arPtBmX.length() - 1];
	//World Z
	Line lnZWorld(bm.ptCen(), vzBm);
	Point3d arPtBmZ[] = lnZWorld.orderPoints(arPtBm);
	if( arPtBmZ.length() < 2 )continue;
	Point3d ptBmBottom = arPtBmZ[0];
	Point3d ptBmTop = arPtBmZ[arPtBmZ.length() - 1];

	//Create ExtraBeams
	for( int j=0;j<arBmRafter.length();j++ ){
		Beam bmRafter = arBmRafter[j];
		if( vyExtraBeam.dotProduct(bmRafter.ptCen() - ptBmMin) * vyExtraBeam.dotProduct(bmRafter.ptCen() - ptBmMax) > 0 )
			continue;
		
		//Create beam
		Beam bmExtraBeam;
		Point3d ptBottom = ptBmBottom + vyExtraBeam * vyExtraBeam.dotProduct(bmRafter.ptCen() - ptBmBottom);
		Point3d ptTop = ptBmTop + vyExtraBeam * vyExtraBeam.dotProduct(bmRafter.ptCen() - ptBmTop);
		double dBmLength = _ZW.dotProduct(ptTop - ptBottom);
		
		Point3d ptExtraBeam = bm.ptCen() + vyExtraBeam * vyExtraBeam.dotProduct(bmRafter.ptCen() - bm.ptCen()) - -vzEl * .5 * bm.dD(-vzEl);
		Body bdExtraBeam(plExtraBeam, vyExtraBeam * dWExtraBeam, 0);
		bdExtraBeam.transformBy(vyExtraBeam * vyExtraBeam.dotProduct(ptExtraBeam - bdExtraBeam.ptCen()));
		bdExtraBeam.vis(1);
		
		bmExtraBeam.dbCreate(bdExtraBeam, vxExtraBeam, vyExtraBeam, vzExtraBeam);
		bmExtraBeam.setColor(32);
		bmExtraBeam.setType(_kStud);
		bmExtraBeam.setBeamCode(sBCExtraBeam);
		bmExtraBeam.assignToElementGroup(el, true, 0, 'Z');
	}

	//Delete this beam
	bm.dbErase();
}

//Erase this tsl.
eraseInstance();













#End
#BeginThumbnail
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
-BBD`4444`%%%%`'_V1HX
`

#End
