#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
26.04.2017  -  version 1.03

























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Tsl to create a sanitary object
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.03" date="26.04.2017"></version>

/// <history>
/// AS - 1.00 - 05.03.2014 - 	Pilot version
/// AS - 1.01 - 19.03.2014 - 	Correct text position
/// AS - 1.02 - 25.03.2014 - 	Assign outline to a specific layer and zone.
/// AS - 1.03 - 26.04.2017 -	Add option for height beamcut.
/// </hsitory>

double dEps(Unit(0.1,"mm"));

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};
String arSSingleDouble[] = {T("|Single|"), T("|Double|")};
int arNSingleDouble[] = {_kNo, _kYes};
String arSSide[] = {T("|Front|"), T("|Back|")};
int arNSide[] = {1, -1};
String arSLayer[] = {T("|Info|"), T("|Tooling|"), T("|Zone|")};
char arChLayer[] = {'I', 'T', 'Z'};
int arNZoneIndex[] = {0,1,2,3,4,5,6,7,8,9,10};

// Sanitary
PropString sSeperator01(0, "", T("|Size and position|"));
sSeperator01.setReadOnly(true);
PropDouble dHSanitary(0, U(1100), "     "+T("|Height|"));
PropString sDoubleSanitary(2, arSSingleDouble, "     "+T("|Single/double|"));


// Restrictions
PropString sSeperator04(8, "", T("|Restrictions|"));
sSeperator04.setReadOnly(true);
PropDouble dMinimumDistanceBetweenSanitary(1, U(750), "     "+T("|Minimum distance between objects|"));
PropDouble dMinimumDistanceToStudCenter(2, U(110), "     "+T("|Minimum distance to stud center|"));
PropString sDimStyleWarning(3, _DimStyles, "     "+T("|Text style warning|"));


//Trimmer
PropString sSeperator05(9, "", T("|Trimmer|"));
sSeperator05.setReadOnly(true);
PropString sSide(1, arSSide, "     "+T("|Side trimmer|"));
PropDouble dTrimmerWidth(6, U(0), "     "+T("|Width trimmer|"));
dTrimmerWidth.setDescription(T("|The width of the trimmer|.") + TN("|Zero means that it will use the default sizes|."));
PropDouble dTrimmerHeight(7, U(0), "     "+T("|Height trimmer|"));
dTrimmerHeight.setDescription(T("|The height of the trimmer|.") + TN("|Zero means that it will use the default sizes|."));
PropInt nColorTrimmer(1, 3, "     "+T("|Color trimmer|"));


//Connecting studs
PropString sSeperator03(6, "", T("|Connecting studs|"));
sSeperator03.setReadOnly(true);
PropString sChangeConnectingStuds(7, arSYesNo, "     "+T("|Change width of connecting studs|"));
PropDouble dWConnectingStuds(5, U(60), "     "+T("|Width connecting studs|"));
PropInt nColorConnectingStuds(0, 3, "     "+T("|Color connecting studs|"));


//Beamcut
PropString sSeperator02(4, "", T("|Milling bottomplate|"));
sSeperator02.setReadOnly(true);
PropString sApplyMillingBottomPlate(5, arSYesNo, "     "+T("|Apply milling|"));
PropDouble dWidthMillingBP(3, U(70), "     "+T("|Width  milling|"));
PropDouble dDepthMillingBP(4, U(50), "     "+T("|Depth  milling|"));
PropDouble dHeightMillingBP(8, U(100), "     "+T("|Height milling|"));


//Description
PropString sSeperator06(10, "", T("|Description|"));
sSeperator06.setReadOnly(true);
PropString sDescriptionPlan(11, "Trimmer H:@(Height)cm from floor", "     "+T("|Description plan|"));
PropString sDescriptionElevation(12, "Trimmer H:@(Height)cm from floor", "     "+T("|Description elevation|"));
PropInt nColorDescription(2, 3, "     "+T("|Color description|"));
PropString sDimStyleDescription(13, _DimStyles, "     "+T("|Text style description|"));


//Outline
PropString sSeperator07(14, "", T("|Outline|"));
sSeperator07.setReadOnly(true);
PropString sShowOutline(15, arSYesNo, "     "+T("|Show outline|"));
PropInt nColorOutline(3, 3, "     "+T("|Color outline|"));
PropString sLayerOutline(16, arSLayer, "     "+T("|Layer|"));
PropInt nZoneIndexOutline(4, arNZoneIndex, "     "+T("|Zone index|"));

// set props from execute key
if (_bOnDbCreated && _kExecuteKey != "" )
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" )
		showDialog();
}

int bDoubleSanitary = arNSingleDouble[arSSingleDouble.find(sDoubleSanitary,0)];
int nSide = arNSide[arSSide.find(sSide,0)];
int bApplyMillingBP = arNYesNo[arSYesNo.find(sApplyMillingBottomPlate,0)];
int bChangeStudWidth = arNYesNo[arSYesNo.find(sChangeConnectingStuds,0)];
int bShowOutline = arNYesNo[arSYesNo.find(sShowOutline,0)];
char chLayerOutline = arChLayer[arSLayer.find(sLayerOutline,0)];
int nZnIndexOutline = nZoneIndexOutline;
if( nZnIndexOutline > 5 )
	nZnIndexOutline = 5 - nZnIndexOutline;

if( _bOnInsert ){	
	_Element.append(getElement(T("|Select an element|")));
	
	_Pt0 = getPoint(T("|Select a position between two studs|"));
	if( bDoubleSanitary )
		_PtG.append(getPoint(T("|Select a position for second sanitary object|")));
	
	return;
}

if( _Element.length() == 0 ){
	eraseInstance();
	return;
}

Element el = _Element[0];
assignToElementGroup(el, true, 0, 'E');

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

CoordSys csZn = el.zone(nSide).coordSys();
Point3d ptZn = csZn.ptOrg();

double dTZone = el.zone(nSide).dH();

Line lnX(ptZn, vxEl);

_Pt0 = lnX.closestPointTo(_Pt0);

if( bDoubleSanitary && _PtG.length() == 0 ){
	_PtG.append(_Pt0 + vxEl * dMinimumDistanceBetweenSanitary);
}
else if( !bDoubleSanitary ){
	_PtG.setLength(0);
}
else{
	if( vxEl.dotProduct(_PtG[0] - _Pt0) < dMinimumDistanceBetweenSanitary ){
		_PtG[0] = _Pt0 + vxEl * dMinimumDistanceBetweenSanitary;
	}
	_PtG[0] = lnX.closestPointTo(_PtG[0]);
}

Display dpOutline(nColorOutline);
dpOutline.addHideDirection(_ZW);
dpOutline.addHideDirection(-_ZW);
dpOutline.elemZone(el, nZnIndexOutline, chLayerOutline);

Display dpDescriptionPlan(nColorDescription);
dpDescriptionPlan.dimStyle(sDimStyleDescription);
dpDescriptionPlan.addViewDirection(_ZW);
dpDescriptionPlan.addViewDirection(-_ZW);
Display dpDescriptionElevation(nColorDescription);
dpDescriptionElevation.dimStyle(sDimStyleDescription);
dpDescriptionElevation.addHideDirection(_ZW);
dpDescriptionElevation.addHideDirection(-_ZW);

Display dpWarningPlan(1);
dpWarningPlan.dimStyle(sDimStyleWarning);
dpWarningPlan.addViewDirection(_ZW);
dpWarningPlan.addViewDirection(-_ZW);
Display dpWarningModel(1);
dpWarningModel.dimStyle(sDimStyleWarning);
dpWarningModel.addHideDirection(_ZW);
dpWarningModel.addHideDirection(-_ZW);

if( _Map.hasMap("BeamLeft") ){
	Map mapBmLeft = _Map.getMap("BeamLeft");
	Entity entLeft = mapBmLeft.getEntity("Beam");
	Beam bmL = (Beam)entLeft;
	if( bmL.bIsValid() ){
		bmL.setD(vxEl, mapBmLeft.getDouble("Width"));
		bmL.setColor(mapBmLeft.getInt("Color"));
	}
	_Map.removeAt("BeamLeft", true);
}
if( _Map.hasMap("BeamRight") ){
	Map mapBmRight = _Map.getMap("BeamRight");
	Entity entRight = mapBmRight.getEntity("Beam");
	Beam bmR = (Beam)entRight;
	if( bmR.bIsValid() ){
		bmR.setD(vxEl, mapBmRight.getDouble("Width"));
		bmR.setColor(mapBmRight.getInt("Color"));
	}
	_Map.removeAt("BeamRight", true);
}

for( int i=0;i<_Map.length();i++ ){
	if( _Map.hasEntity(i) && _Map.keyAt(i) == "Beam" ){
		Entity ent = _Map.getEntity(i);
		ent.dbErase();
		_Map.removeAt(i, true);
		i--;
	}
}

Beam arBm[] = el.beam();
Beam arBmVertSorted[] = vxEl.filterBeamsPerpendicularSort(arBm);

Beam bmLeft01 = arBmVertSorted[0];
Beam bmRight01 = arBmVertSorted[arBmVertSorted.length() - 1];

int nIndexRight = 1;
for( int i=0;i<arBmVertSorted.length();i++ ){
	Beam bm = arBmVertSorted[i];
	if( vxEl.dotProduct(_Pt0 - bm.ptCen()) < 0 ){
		bmRight01 = bm;
		nIndexRight = i;
		break;
	}
	bmLeft01 = bm;
}

Beam bmLeft = bmLeft01;
Beam bmRight = bmRight01;

//Double
Beam bmLeft02 = bmRight01;
Beam bmRight02 = arBmVertSorted[arBmVertSorted.length() - 1];
if( bDoubleSanitary ){
	for( int i=(nIndexRight + 1);i<arBmVertSorted.length();i++ ){
		Beam bm = arBmVertSorted[i];
		if( vxEl.dotProduct(_PtG[0] - bm.ptCen()) < 0 ){
			bmRight02 = bm;
			break;
		}
		bmLeft02 = bm;
	}
	
	bmRight = bmRight02;
}

if( vxEl.dotProduct(_Pt0 - bmLeft01.ptCen()) < dMinimumDistanceToStudCenter )
	_Pt0 += vxEl * vxEl.dotProduct((bmLeft01.ptCen() + vxEl * dMinimumDistanceToStudCenter) - _Pt0);
if( vxEl.dotProduct(bmRight01.ptCen() - _Pt0) < dMinimumDistanceToStudCenter )
	_Pt0 += vxEl * vxEl.dotProduct((bmRight01.ptCen() - vxEl * dMinimumDistanceToStudCenter) - _Pt0);

// Double
if( bDoubleSanitary ){
	if( vxEl.dotProduct(_PtG[0] - bmLeft02.ptCen()) < dMinimumDistanceToStudCenter )
		_PtG[0] += vxEl * vxEl.dotProduct((bmLeft02.ptCen() + vxEl * dMinimumDistanceToStudCenter) - _PtG[0]);
	if( vxEl.dotProduct(bmRight02.ptCen() - _PtG[0]) < dMinimumDistanceToStudCenter )
		_PtG[0] += vxEl * vxEl.dotProduct((bmRight02.ptCen() - vxEl * dMinimumDistanceToStudCenter) - _PtG[0]);
}

Point3d ptBL = _Pt0 + vxEl * vxEl.dotProduct(bmLeft01.ptCen() - _Pt0);
Point3d ptBR = _Pt0 + vxEl * vxEl.dotProduct(bmRight01.ptCen() - _Pt0);
Point3d ptTR = _Pt0 + vxEl * vxEl.dotProduct(bmRight01.ptCen() - _Pt0) + vyEl * dHSanitary;
Point3d ptTL = _Pt0 + vxEl * vxEl.dotProduct(bmLeft01.ptCen() - _Pt0) + vyEl * dHSanitary;

Point3d ptCenter = (ptBL + ptBR + ptTR + ptTL)/4;

// Double
if( bDoubleSanitary ){
	ptBR = _Pt0 + vxEl * vxEl.dotProduct(bmRight02.ptCen() - _Pt0);
	ptTR = _Pt0 + vxEl * vxEl.dotProduct(bmRight02.ptCen() - _Pt0) + vyEl * dHSanitary;
	
	ptCenter = (ptBL + ptBR + ptTR + ptTL)/4;
	double dDistBetweenSanitary = vxEl.dotProduct(_PtG[0] - _Pt0);
	if( dDistBetweenSanitary < dMinimumDistanceBetweenSanitary ){
		dpWarningModel.draw("< 750 mm", ptCenter, vxEl, vyEl, 0, 0);
		dpWarningPlan.draw("< 750 mm", ptCenter, vxEl, -vzEl, 0, -3);
	}
}

PLine plSanitary(ptBL, ptBR, ptTR, ptTL);
plSanitary.close();
PLine plBL2TR(ptBL, ptTR);
PLine plBR2TL(ptBR, ptTL);


// Increase stud width
if( bChangeStudWidth ){
//	if( bmLeft.dD(vxEl) < dWConnectingStuds){
		Map mapBmLeft;
		mapBmLeft.setEntity("Beam", bmLeft);
		mapBmLeft.setDouble("Width", bmLeft.dD(vxEl));
		mapBmLeft.setInt("Color", bmLeft.color());
		_Map.setMap("BeamLeft", mapBmLeft);
		
		bmLeft.setD(vxEl, dWConnectingStuds);
		bmLeft.setColor(nColorConnectingStuds);
//	}
//	if( bmRight.dD(vxEl) < dWConnectingStuds){
		Map mapBmRight;
		mapBmRight.setEntity("Beam", bmRight);
		mapBmRight.setDouble("Width", bmRight.dD(vxEl));
		mapBmRight.setInt("Color", bmRight.color());
		_Map.setMap("BeamRight", mapBmRight);
		
		bmRight.setD(vxEl, dWConnectingStuds);
		bmRight.setColor(nColorConnectingStuds);
//	}
}

// Beamcuts
if( bApplyMillingBP ){
	Point3d arPtBmCut[] = {_Pt0};
	if( bDoubleSanitary )
		arPtBmCut.append(_PtG[0]);
	
	for( int i=0;i<arPtBmCut.length();i++ ){
		Point3d ptBmCut = arPtBmCut[i];
		
		ptBmCut += vzEl * vzEl.dotProduct((ptZn - vzEl * nSide * dDepthMillingBP) - ptBmCut);
		BeamCut bmCut(ptBmCut, vyEl, -vxEl, vzEl, 2 * dHeightMillingBP, dWidthMillingBP, 2*dDepthMillingBP, 0, 0, nSide);
		int nNrOfBeamsMilled = bmCut.addMeToGenBeamsIntersect(arBm);
	}
}

// Create extra stud and trimmers
// Extra stud is only created if it is a double sanitary and if they are next to each other.
if( bDoubleSanitary && bmRight01 == bmLeft02 ){
	int nFlagBmY;
	if( vxEl.dotProduct(bmRight01.ptCen() - _Pt0) < vxEl.dotProduct(_Pt0 - bmLeft01.ptCen()) )
		nFlagBmY = 1;
	else
		nFlagBmY = -1;
	
	Point3d ptExtraStud = bmRight01.ptCen() + 
		vyEl * vyEl.dotProduct(ptTL - bmRight01.ptCen()) + 
		vxEl * nFlagBmY * 0.5 * bmRight01.dD(vxEl);
	
	
	
	Beam bmExtraStud;
	bmExtraStud.dbCreate(ptExtraStud, -vyEl, vxEl, vzEl, dWConnectingStuds, dWConnectingStuds, el.dBeamWidth(), 0, nFlagBmY, 0);
	_Map.appendEntity("Beam", bmExtraStud);
	bmExtraStud.assignToElementGroup(el, true, 0, 'Z');
	bmExtraStud.setColor(3);
	if( nFlagBmY == 1 )
		bmLeft02 = bmExtraStud;
	else
		bmRight01 = bmExtraStud;
	
	Beam arBmBottom[] = Beam().filterBeamsHalfLineIntersectSort(
		arBm, ptExtraStud + vxEl * nFlagBmY * 0.5 * dWConnectingStuds, -vyEl
	);
	if( arBmBottom.length() > 0 ){
		Beam bmBottom = arBmBottom[0];
		bmExtraStud.stretchStaticTo(bmBottom, _kStretchOnInsert);
	}
	
	arBm.append(bmExtraStud);
}

double dWTrimmer = dTrimmerWidth;
double dHTrimmer = dTrimmerHeight;

if( dWTrimmer <= 0 )
	dWTrimmer = el.dBeamHeight();
if( dHTrimmer <= 0 )
	dHTrimmer = el.dBeamWidth();

Point3d ptSide = el.ptOrg();
if( nSide == -1 )
	ptSide = el.zone(-1).coordSys().ptOrg();
Plane pnSide(ptSide, vzEl * nSide);

if( bDoubleSanitary ){
	Point3d ptTrimmer = bmRight02.ptCen() + 
		vyEl * vyEl.dotProduct(ptTL - bmRight02.ptCen()) - 
		vxEl * 0.5 * bmRight02.dD(vxEl);
	ptTrimmer = pnSide.closestPointTo(ptTrimmer);

	Beam bmTrimmer;
	bmTrimmer.dbCreate(ptTrimmer, vxEl, vyEl, vzEl, U(10), dWTrimmer, dHTrimmer, -1, 0, -nSide);
	_Map.appendEntity("Beam", bmTrimmer);
	bmTrimmer.assignToElementGroup(el, true, 0, 'Z');
	bmTrimmer.stretchStaticTo(bmRight02, _kStretchOnInsert);
	bmTrimmer.stretchStaticTo(bmLeft02, _kStretchOnInsert);
	bmTrimmer.setColor(nColorTrimmer);
}

Point3d ptTrimmer = bmRight01.ptCen() + 
	vyEl * vyEl.dotProduct(ptTL - bmRight01.ptCen()) - 
	vxEl * 0.5 * bmRight02.dD(vxEl);
ptTrimmer = pnSide.closestPointTo(ptTrimmer);

Beam bmTrimmer;
bmTrimmer.dbCreate(ptTrimmer, vxEl, vyEl, vzEl, U(10), dWTrimmer, dHTrimmer, -1, 0, -nSide);
_Map.appendEntity("Beam", bmTrimmer);
bmTrimmer.assignToElementGroup(el, true, 0, 'Z');
bmTrimmer.stretchStaticTo(bmRight01, _kStretchOnInsert);
bmTrimmer.stretchStaticTo(bmLeft01, _kStretchOnInsert);
bmTrimmer.setColor(nColorTrimmer);


if( bShowOutline )
	dpOutline.draw(plSanitary);

String arSDescriptionElevation[0];
String sList = sDescriptionElevation + "~";
int nTokenIndex = 0; 
int nCharacterIndex = 0;
while(nCharacterIndex < sList.length()-1){
	String sListItem = sList.token(nTokenIndex,"~");
	nTokenIndex++;
	if(sListItem.length()==0){
		nCharacterIndex++;
		continue;
	}
	nCharacterIndex = sList.find(sListItem,0);
	sListItem.trimLeft();
	sListItem.trimRight();
	arSDescriptionElevation.append(sListItem);
}

for( int i=0;i<arSDescriptionElevation.length();i++ ){
	String sText = arSDescriptionElevation[i];
	
	String sFormat = "@(Height)";
	int nIndexSubstring = sText.find(sFormat,0);
	if( nIndexSubstring != -1 ){
		String sStart = sText.left(nIndexSubstring);
		String sEnd = sText.right(sText.length() - nIndexSubstring - sFormat.length());
		
		if( sFormat == "@(Height)" )
			sText = sStart + dHSanitary + sEnd;
		else
			sText = sText;
	}
	dpDescriptionElevation.draw(sText, ptCenter, vxEl, vyEl, 0, -i*3, _kDevice);
}


String arSDescriptionPlan[0];
sList = sDescriptionPlan + "~";
nTokenIndex = 0; 
nCharacterIndex = 0;
while(nCharacterIndex < sList.length()-1){
	String sListItem = sList.token(nTokenIndex,"~");
	nTokenIndex++;
	if(sListItem.length()==0){
		nCharacterIndex++;
		continue;
	}
	nCharacterIndex = sList.find(sListItem,0);
	sListItem.trimLeft();
	sListItem.trimRight();
	arSDescriptionPlan.append(sListItem);
}

for( int i=0;i<arSDescriptionPlan.length();i++ ){
	String sText = arSDescriptionPlan[i];
	
	String sFormat = "@(Height)";
	int nIndexSubstring = sText.find(sFormat,0);
	if( nIndexSubstring != -1 ){
		String sStart = sText.left(nIndexSubstring);
		String sEnd = sText.right(sText.length() - nIndexSubstring - sFormat.length());
		
		if( sFormat == "@(Height)" )
			sText = sStart + dHSanitary + sEnd;
		else
			sText = sText;
	}
	
	Point3d ptText = pnSide.closestPointTo(ptCenter);
	ptText += vzEl * nSide * dpDescriptionPlan.textHeightForStyle("ABC", sDimStyleDescription);
	dpDescriptionPlan.draw(sText, ptText, vxEl * nSide, vzEl * -nSide, 0, -(i*3 + 1));
}



#End
#BeginThumbnail
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
M`J6BBM"`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#
ME:***_/CK"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HIZQ2.,JCL.F5
M4FK*:7<-G(5,?WFZ_E6U/"UJGP1;$VEN4Z*U4T@9S)(3QT48Y^M68]/MTP?+
MW$=V.<_ATKOIY1B)_%9>O_`(=1'/R6_VN)K;?L\X&/=C.,\9Q^-1V_@*PC6,
MSSSS.IRVTA%;GTP2./?\JZQ(TC&$4*/0#%/KVL%E\</%J3NV2ZTMHZ&5;^'-
M'MHRB:=`PSG]XGF'\VR:U:**]!12V1FVWN+1115""BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#E:***_
M/CK"BBB@`HHHH`***>L4CC*H[#IE5)JE"4G9(0RBKB:7<MU"IC^\W7\JLII"
M]99">.BC'/UKLIY;B:FT;>NA+G%&52@%B``23P`*W(]/MTP?+W$?WCG/X=*L
MI&D:X154>@&*[J>25'\<DO37_(EU5T,!+*XDSB)AC^]Q_.K2:3*?OR(H]LG_
M``K8HKNIY/AX_%=DNHS/32H`06+MCJ">#5E+2"/&V)..02,G\ZL4E=U/"4*?
MPQ2(<FQ<4445TV$%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!RM%%:NGVT,
MEJDKQAG.<YZ=^W2OA\+AWB)<J=NITRE97,L`L0`"2>`!4R65Q)G$3#'][C^=
M;R1H@PB*H]`,4^O9I9+%J\Y?<9NH^AD)I,Q^_(B_[N3_`(5932H%P6+MCJ">
M#5^BO0IY;AH?9OZDN<F0):01XVQ+QR"1D_G4]%+79"$(JT58BX44458!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
I%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'_]D4
`


#End