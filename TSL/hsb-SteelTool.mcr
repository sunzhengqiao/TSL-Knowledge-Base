#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
13.01.2016  -  version 1.30
































#End
#Type X
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 30
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Inserts a steeltool to a beam, beam <optional> connection
/// </summary>

/// <insert>
/// Insert is done through the FFB-Connections tsl. This tsl can also be inserted as a single instance
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.30" date="13.01.2016"></version>

/// <history>
/// AS - 1.00 - 20.04.2011	- Pilot version - redesign of the HSB-SteelTool (2009)
/// AS - 1.01 - 26.04.2011	- Angled connections are supported
/// AS - 1.02 - 27.04.2011	- Subtract dEps (= 0.01 mm) from width of beamcut
/// AS - 1.03 - 02.05.2011	- Add webnotch and lipcut for angled connections
/// AS - 1.04 - 03.05.2011	- Remove tool size for drill tools
/// AS - 1.05 - 04.05.2011	- Angle must be 180 - angle if its over 90 degrees.
/// AS - 1.06 - 05.05.2011	- Write size as double
/// AS - 1.07 - 19.05.2011	- Support Angled G-type connections, reduce gap for lipnotch
/// AS - 1.08 - 23.05.2011	- Check for T & G-Connections 5 mm outside beam.
/// AS - 1.09 - 01.07.2011	- Aslo report the beamnumber when web points are not found.
/// AS - 1.10 - 06.04.2012	- Calculate gap automatically
/// AS - 1.11 - 21.05.2012	- Add extra offset if connection is angled.
/// AS - 1.12 - 25.05.2012	- Recalc gap for G-Connection
/// AS - 1.13 - 08.06.2012	- Add option to make connection squared
/// AS - 1.14 - 14.02.2014	- Add option to make only male or female squared
/// AS - 1.15 - 03.03.2014	- Change default connection
/// AS - 1.16 - 08.05.2014	- Add a warning if a flag is set wrong
/// AS - 1.17 - 11.09.2014	- Swage is applied with flag if its positioned at the end of the beam.
/// AS - 1.18 - 30.09.2014	- Correct flag for swage at beam end.
/// AS - 1.19 - 30.09.2014	- Swage at beam end: use female vector for female beam.
/// AS - 1.20 - 20.10.2014	- Swage at beam end: Place it at beam end.
/// AS - 1.21 - 30.10.2014	- Also place notch and lipcut at end of beam at the end of the beam with a flag and reset the toolsize.
/// AS - 1.22 - 16.06.2015	- Add margin to flags on tools for angled connections.
/// CS - 1.23 - 07.12.2015	- Added new tool for end chamfers/end truss connections.
/// AS - 1.24 - 14.12.2015	- Tools created outside beam are now disabled.
/// CS - 1.25 - 14.12.2015	- Repositioned tool to end of the cut for the end truss tool.
/// AS - 1.26 - 16.12.2015	- Remove tools created outside beams for angled connections. Flags are not used anymore.
/// CS - 1.27 - 05.01.2016	- Implemented end chamfer tool on female side.
/// AS - 1.28 - 06.01.2016	- Properties are no longer set by this tsl.
/// AS - 1.29 - 07.01.2016	- Add chamfer tools as static tools. Change default for chamfer tool. 
/// AS - 1.30 - 13.01.2016	- Correct position of swage at angled connections.
/// </history>

double dEps = Unit(0.01, "mm");

String arSMakeSquared[] = {
	T("|Do not make square|"), 			// 0
	T("|Only male|"),						// 1
	T("|Only female|"),						// 2
	T("|Make both square|")				// 3
};

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

PropString sSeperator01(0, "", T("|Properties|"));
sSeperator01.setReadOnly(true);

String arSCatalogEntries[] = {T("|Manual|")};
//arSCatalogEntries.append(TslInst().getListOfCatalogNames("hsb-SteelTool"));
PropString sCatName(1, arSCatalogEntries, "     "+T("|Use properties from catalog|"));

PropString sSeperator02(2, "", T("|Tooling|"));
sSeperator02.setReadOnly(true);
String arSApplyTo[] = {T("Male"), T("Female"), T("Both"), T("None")};

PropString sServiceHole (3, arSApplyTo, "     "+T("|Service hole|"), 3);
PropString sWebNotch (4, arSApplyTo, "     "+T("|Web notch|"), 3);
double dGapWebNotch = U(1);
PropString sLipNotch (5, arSApplyTo, "     "+T("|Lip notch|"), 3);
double dGapLipCut = U(1);
PropString sWebHole (6, arSApplyTo, "     "+T("|Web hole|"), 3);
PropString sDimple (7, arSApplyTo, "     "+T("|Dimple|"), 3);
PropString sSwage (8, arSApplyTo, "     "+T("|Swage|"), 3);

PropString sEndChamfer (13, arSApplyTo, "     "+T("|End Chamfer|"), 3);
double dGapSwage = U(0);

PropString sSeperator03(9, "", T("|No nail areas|"));
sSeperator03.setReadOnly(true);
PropString sZoneNoNail(10, "1;6", "     "+T("|Zones for applying no nail areas|"));
PropDouble dSizeNoNail(0, U(50), "     "+T("|Size of no nail areas|"));

PropString sSeperator04(11, "", T("|Visualization|"));
sSeperator04.setReadOnly(true);
PropDouble dTxtHeight(1, U(20), "     "+T("|Text size|"));

PropString sSeperator05(11, "", T("|Chamfer|"));
sSeperator05.setReadOnly(true);
PropDouble dFlatEndLength(2, U(20), "     "+T("|Flat end length|"));

// set props from execute key
if( _bOnDbCreated && _kExecuteKey != "" )
	setPropValuesFromCatalog(_kExecuteKey);

//Insert
if( _bOnInsert ){
	Beam bmMale = getBeam(T("|Select the male beam|"));
	_Beam.append(bmMale);
	Beam bmFemale = getBeam(T("|Select the famale beam|"));
	_Beam.append(bmFemale);
	
	Element el = bmMale.element();
	if( !el.bIsValid() ){
		reportMessage(TN("|No valid element found during insert|"));
		eraseInstance();
		return;
	}
	TslInst arTsl[] = el.tslInst();
	for( int i=0;i<arTsl.length();i++ ){
		TslInst tsl = arTsl[i];
		if( tsl.scriptName() == "hsb-SteelTool" && tsl.handle() != _ThisInst.handle() ){
			Beam arBm[] = tsl.beam();
			int bMaleFound = false;
			int bFemaleFound = false;
			for( int j=0;j<arBm.length();j++ ){
				if( !bMaleFound && arBm[j].handle() == bmMale.handle() )
					bMaleFound = true;
				if( !bFemaleFound && arBm[j].handle() == bmFemale.handle() )
					bFemaleFound = true;
				
				if( bFemaleFound && bMaleFound ){
					tsl.dbErase();
					break;
				}
			}
		}
	}
	
	if( _kExecuteKey == "" )
		showDialog();
	
	return;
}

Display dp(1);
dp.textHeight(dTxtHeight);
//if( arSCatalogEntries.find(sCatName,0) > 0 ){
	//_ThisInst.setPropValuesFromCatalog(sCatName);
	//dp.draw(sCatName, _Pt0, _XW, _YW, 0, 0, _kDeviceX);
//}

if( _Beam.length() != 2 ){
	reportMessage(TN("|Two beams are required!|"));
	eraseInstance();
	return;
}
Beam bmMale = _Beam0;
Beam bmFemale = _Beam1;
Body bdBmMale = bmMale.envelopeBody(true, false);
Body bdBmFemale = bmFemale.envelopeBody(true, false);
bmMale.vecX().vis(bmMale.ptCen(), 1);
Element el = bmMale.element();
if (!el.bIsValid()){
	reportMessage(TN("|Invalid element found!|"));
	eraseInstance();
	return;
}
_ThisInst.assignToElementGroup(el, true, 0, 'T');

CoordSys csEl=el.coordSys();
Point3d ptEl=csEl.ptOrg();
Vector3d vxEl=csEl.vecX();
Vector3d vyEl=csEl.vecY();
Vector3d vzEl=csEl.vecZ();

// resolve properties
int arNZoneNoNailArea[0];
int nIndex = 0;
String sZoneNoNailArea = sZoneNoNail + ";";
int nToken = 0;
String sToken = sZoneNoNailArea.token(nToken);
while( sToken != "" ){
	int nZn = sToken.atoi();
	if( nZn == 0 && sToken != "0" ){
		nToken++;
		sToken = sZoneNoNailArea.token(nToken);
		continue;
	}
	
	if( nZn > 5 )
		nZn = 5 - nZn;
		
	arNZoneNoNailArea.append(nZn);
	
	nToken++;
	sToken = sZoneNoNailArea.token(nToken);
}

String arSToolCode[] = {"SERVICE_HOLE", "NOTCH", "LIP_CUT", "WEB", "DIMPLE", "SWAGE", "BOLT_HOLE", "CRUCIFORM","END_TRUSS", "none"};
double arDRadius[] = {U(34.1), 0, 0, U(3.5), U(3), 0, 0, 0, 0, 0};
int nLocation[] = {0, 0, 0, 3, 3, 0, 0, 0};

int arNToolCodeMale[0];//0=ServiceHole  1=WebNotch  2=LipNotch  3=WebHole  4=Dimple  5=Swage 6=End Chamfer
int arNToolCodeFemale[0];//0=ServiceHole  1=WebNotch  2=LipNotch  3=WebHole  4=Dimple  5=Swage 6=End Chamfer

int nApplyTool0To = arSApplyTo.find(sServiceHole, -1);
if (nApplyTool0To!=-1 && nApplyTool0To !=3)
{
	if (nApplyTool0To==0)
		arNToolCodeMale.append(0);
	else if (nApplyTool0To==1)
		arNToolCodeFemale.append(0);
	else if (nApplyTool0To==2)
	{
		arNToolCodeMale.append(0);
		arNToolCodeFemale.append(0);
	}
}

int nApplyTool1To = arSApplyTo.find(sWebNotch, -1);
if (nApplyTool1To!=-1 && nApplyTool1To!=3)
{
	if (nApplyTool1To==0)
		arNToolCodeMale.append(1);
	else if (nApplyTool1To==1)
		arNToolCodeFemale.append(1);
	else if (nApplyTool1To==2)
	{
		arNToolCodeMale.append(1);
		arNToolCodeFemale.append(1);
	}
}

int nApplyTool2To = arSApplyTo.find(sLipNotch, -1);
if (nApplyTool2To!=-1 && nApplyTool2To!=3)
{
	if (nApplyTool2To==0)
		arNToolCodeMale.append(2);
	else if (nApplyTool2To==1)
		arNToolCodeFemale.append(2);
	else if (nApplyTool2To==2)
	{
		arNToolCodeMale.append(2);
		arNToolCodeFemale.append(2);
	}
}
int nApplyTool3To = arSApplyTo.find(sWebHole, -1);
if (nApplyTool3To!=-1 && nApplyTool3To!=3)
{
	if (nApplyTool3To==0)
		arNToolCodeMale.append(3);
	else if (nApplyTool3To==1)
		arNToolCodeFemale.append(3);
	else if (nApplyTool3To==2)
	{
		arNToolCodeMale.append(3);
		arNToolCodeFemale.append(3);
	}
}

int nApplyTool4To = arSApplyTo.find(sDimple, -1);
if (nApplyTool4To!=-1 && nApplyTool4To!=3)
{
	if (nApplyTool4To==0)
		arNToolCodeMale.append(4);
	else if (nApplyTool4To==1)
		arNToolCodeFemale.append(4);
	else if (nApplyTool4To==2)
	{
		arNToolCodeMale.append(4);
		arNToolCodeFemale.append(4);
	}
}

int nApplyTool5To = arSApplyTo.find(sSwage, -1);
if (nApplyTool5To!=-1 && nApplyTool5To!=3)
{
	if (nApplyTool5To==0)
		arNToolCodeMale.append(5);
	else if (nApplyTool5To==1)
		arNToolCodeFemale.append(5);
	else if (nApplyTool5To==2)
	{
		arNToolCodeMale.append(5);
		arNToolCodeFemale.append(5);
	}
}

int nApplyTool6To = arSApplyTo.find(sEndChamfer, -1);
if (nApplyTool6To!=-1 && nApplyTool6To!=3)
{
	if (nApplyTool6To==0)
		arNToolCodeMale.append(8);
	else if (nApplyTool6To==1)
		arNToolCodeFemale.append(8);
	else if (nApplyTool6To==2)
	{
		arNToolCodeMale.append(8);
		arNToolCodeFemale.append(8);
	}
}

if( _Beam.length()>1 ){
	if( !(_Beam[0].envelopeBody(false, true).hasIntersection(_Beam[1].envelopeBody(false, true))) ){
		reportNotice(T("|The two beams don't have intersection|"));
		eraseInstance();
		return;
	}
}

String sExtrProfileBmMale = bmMale.extrProfile();
String sTMaterialMale = sExtrProfileBmMale.right(2);
double dTMaterialMale = sTMaterialMale.atof();
if( dTMaterialMale > 0 ){
	dTMaterialMale /= 10.0;
}
else{
	reportMessage(TN("|Thickness not found!|"));
}
String sExtrProfileBmFemale = bmFemale.extrProfile();
String sTMaterialFemale = sExtrProfileBmFemale.right(2);
double dTMaterialFemale = sTMaterialFemale.atof();
if( dTMaterialFemale > 0 ){
	dTMaterialFemale /= 10.0;
}
else{
	sTMaterialFemale = sExtrProfileBmFemale.right(1);
	dTMaterialFemale = sTMaterialFemale.atof();
	if( dTMaterialFemale == 0 )
		reportMessage(TN("|Thickness not found!|"));
}

Point3d ptTool = _Pt0;
Vector3d vxM = _X0;
Vector3d vyM = _Y0;
Vector3d vzM = _Z0;
Point3d arPtMaleX[] =  bmMale.envelopeBody(true, true).allVertices();
arPtMaleX = Line(ptTool, vxM).orderPoints(arPtMaleX);
Point3d arPtMaleY[] = bdBmMale.intersectPoints(Line(ptTool, vyM));
if( arPtMaleY.length() == 0 ){
	reportWarning(TN("|Web-side of male beam| (")+bmMale.posnum()+T(") |cannot be found!|"));
	eraseInstance();
	return;
}
if( vyM.dotProduct(arPtMaleY[0] - ptTool) > 0 ){
	vyM *= -1;
	vzM *= -1;
}
Point3d arPtMaleZ[] = bdBmMale.intersectPoints(Line(ptTool, vzM));
if( arPtMaleZ.length() == 0 ){
	reportWarning(TN("|Flange-side of male beam| (")+bmMale.posnum()+T(") |cannot be found!|"));
	eraseInstance();
	return;
}
double dHInsideMale = abs(vzM.dotProduct(arPtMaleZ[1]-arPtMaleZ[2])) - dEps;

Vector3d vxF = _X1;
Vector3d vyF = _Y1;
Vector3d vzF = _Z1;
if( vxF.dotProduct(_Pt0 - bmFemale.ptCen()) < 0 ){
	vxF *= -1;
}
Point3d arPtFemaleX[] =  bmFemale.envelopeBody(true, true).allVertices();
arPtFemaleX = Line(ptTool, vxF).orderPoints(arPtFemaleX);
Point3d arPtFemaleY[] = bdBmFemale.intersectPoints(Line(ptTool, vyF));
if( arPtFemaleY.length() == 0 ){
	reportWarning(TN("|Web-side of female beam| (")+bmFemale.posnum()+T(") |cannot be found!|"));
	eraseInstance();
	return;
}
if( vyF.dotProduct(arPtFemaleY[0] - ptTool) > 0 ){
	vyF *= -1;
	vzF *= -1;
}
vxM.vis(_Pt0);
vyM.vis(_Pt0,1);
vxF.vis(_Pt0);

Point3d arPtFemaleZ[] = bdBmFemale.intersectPoints(Line(ptTool, vzF));
if( arPtFemaleZ.length() == 0 ){
	reportWarning(TN("|Flange-side of female beam| (")+bmFemale.posnum()+T(") |cannot be found!|"));
	eraseInstance();
	return;
}
double dHInsideFemale = abs(vzF.dotProduct(arPtFemaleZ[1]-arPtFemaleZ[2])) - dEps;

Plane pnMLip(ptTool + vyM * .5 * bmMale.dW(), vyM);
Plane pnMWeb(ptTool - vyM * .5 * bmMale.dW(), vyM);
Line lnMx(ptTool, vxM);

Plane pnFLip(ptTool + vyF * .5 * bmFemale.dW(), vyF);
Plane pnFWeb(ptTool - vyF * .5 * bmFemale.dW(), vyF);
Line lnFx(ptTool, vxF);

Point3d ptMLip = lnFx.intersect(pnMLip,0);
Point3d ptMWeb = lnFx.intersect(pnMWeb,0);

Point3d ptFLip = lnMx.intersect(pnFLip,0);
Point3d ptFWeb = lnMx.intersect(pnFWeb,0);

ptTool.vis(1);
ptMLip.vis(3);
ptMWeb.vis(3);
ptFLip.vis(4);
ptFWeb.vis(4);

double dSymbolSize = U(5);
int nColorMale = 3;
int nColorFemale = 4;

Display dpMale(nColorMale);
Display dpFemale(nColorFemale);

PLine plMale(ptTool - vxM * dSymbolSize, ptTool);
dpMale.draw(plMale);

PLine plFemale(ptTool - vxF * .5 * dSymbolSize, ptTool + vxF * .5 * dSymbolSize);
dpFemale.draw(plFemale);
Vector3d vSortYFemale = vyF;
if( vyF.dotProduct(vxM) < 0 )
	vSortYFemale *= -1;
Point3d arPtMaleYFemale[] = Line(ptTool, vSortYFemale).orderPoints(arPtMaleX);
arPtMaleYFemale[arPtMaleYFemale.length() - 1].vis(3);
double dGap = abs(vyF.dotProduct((ptTool - vyF * .5 * bmFemale.dW()) - arPtMaleYFemale[arPtMaleYFemale.length() - 1]));
dGap -= dTMaterialFemale;

double dAng = vxM.angleTo(vxF);
if( dAng > 90.1 )
	dAng = 180 - dAng;

int bIsAngled = false;
if( abs(dAng-90) > dEps )
	bIsAngled = true;

int bIsTConnection = false;
Body bdBmMaleBoxWithCut = bmMale.envelopeBody(false, true);
Plane pnFWebForT = pnFWeb;
pnFWebForT.transformBy(U(5) * -vyF);
Plane pnFLipForT = pnFLip;
pnFLipForT.transformBy(U(5) * vyF);
if( bdBmMaleBoxWithCut.getSlice(pnFWebForT).area() == 0 || bdBmMaleBoxWithCut.getSlice(pnFLipForT).area() == 0 )
	bIsTConnection = true;

int bIsGConnection = false;
Body bdBmFemaleBoxWithCut = bmFemale.envelopeBody(false, true);
Plane pnMWebForT = pnMWeb;
pnMWebForT.transformBy(U(5) * -vyM);
Plane pnMLipForT = pnMLip;
pnMLipForT.transformBy(U(5) * vyM);
if( bdBmFemaleBoxWithCut.getSlice(pnMWebForT).area() == 0 || bdBmFemaleBoxWithCut.getSlice(pnMLipForT).area() == 0 )
	bIsGConnection = true;

for( int i=0;i<arNToolCodeMale.length();i++ ){
	int nToolCode = arNToolCodeMale[i];
	String sToolCode = arSToolCode[nToolCode];
	Point3d ptToolPosition = ptTool;
	double dToolSize;
	int nFlag = 0;
	
	double dFromStart = abs(vxM.dotProduct(ptToolPosition - arPtMaleX[0]));
	double dFromEnd = abs(vxM.dotProduct(ptToolPosition - arPtMaleX[arPtMaleX.length() - 1]));
	
	if( nToolCode == 0 ){ // Service hole
		ptToolPosition = ptMWeb;
//		dToolSize = dRadiusServiceHole;
		Drill drill(ptToolPosition - vyM * U(25), ptToolPosition + vyM * U(25), dToolSize);
		drill.excludeMachineForCNC(_kAnyMachine);
		bmMale.addTool(drill);
	}
	else if( nToolCode == 1 ){ // Web notch
		ptToolPosition = ptMWeb;
		if( abs(dAng - 90) > U(0.1) )
			dGapWebNotch *= 3;
		dToolSize = (bmFemale.dW() + 2 * dGapWebNotch) / sin(dAng);
		
		BeamCut bmCut(ptToolPosition, bmMale.vecX(), vyM, vzM, dToolSize, U(25), dHInsideMale, nFlag, 0, 0);
		bmCut.excludeMachineForCNC(_kAnyMachine);
		bmMale.addTool(bmCut);
	}
	else if( nToolCode == 2 ){ // Lip notch
		ptToolPosition = ptMLip;
		if( abs(dAng - 90) > U(0.1) )
			dGapLipCut *= 3;
		dToolSize = (bmFemale.dW() + 2 * dGapLipCut) / sin(dAng);
		
		BeamCut bmCut(ptToolPosition, bmMale.vecX(), vyM, vzM, dToolSize, U(25), dHInsideMale, nFlag, 0, 0);
		bmCut.excludeMachineForCNC(_kAnyMachine);
		bmMale.addTool(bmCut);
	}
	else if( nToolCode == 3 ){ // Web hole
		ptToolPosition = ptMWeb;
//		dToolSize = dRadiusWebHole;
		Drill drill(ptToolPosition - vyM * U(25), ptToolPosition + vyM * U(25), dToolSize);
		drill.excludeMachineForCNC(_kAnyMachine);
		bmMale.addTool(drill);
	}
	else if( nToolCode == 4 ){ // Dimple
//		dToolSize = dRadiusDimple;
		Drill drill(ptToolPosition - vzM * U(250), ptToolPosition + vzM * U(250), dToolSize);
		drill.excludeMachineForCNC(_kAnyMachine);
		bmMale.addTool(drill);
	}
	else if( nToolCode == 5 ){ // Swage
		dToolSize = bmFemale.dW() / sin(dAng) + bmMale.dW() / tan(dAng);
		ptToolPosition -= vxM * 0.5 * (bmMale.dW() / tan(dAng));
	}
	else if (nToolCode==8)
	{
		double dAngleBetweenBeams = vxM.angleTo(vxF);
		Vector3d vecMForIntersection;
		Point3d ptEndIntersect;
		Point3d ptOtherEndIntersect;
		Point3d ptEndCut;
		Point3d ptEndIntersectReference;
		int bShallowAngle = false;
		if(dAngleBetweenBeams < 45)
		{
			vecMForIntersection =vyM.dotProduct(vxF) < 0 ? vyM : - vyM;
			bShallowAngle = true;
		}
		else if(dAngleBetweenBeams > 135)
		{
			vecMForIntersection = vyM.dotProduct(vxF) < 0 ? -vyM :vyM;
			bShallowAngle = true;
		}
		else if(dAngleBetweenBeams < 90)
		{
			vecMForIntersection = vyM.dotProduct(vxF) < 0 ? vyM :- vyM;
		}
		else
		{
			vecMForIntersection = vyM.dotProduct(vxF) < 0 ? -vyM :vyM;
		}
		
		if(bShallowAngle)
		{
			Point3d ptHalfWidthMale = ptTool + vecMForIntersection  * bmMale.dW() * 0.5;
			ptEndIntersect = Line(ptHalfWidthMale, vxM).intersect(pnFWeb, dTMaterialFemale + dGap);

			ptOtherEndIntersect = ptEndIntersect-vecMForIntersection * bmMale.dW();
			double dEdgeToHalfWidthOfEndChamfer = (bmMale.dW() * 0.5) - (dFlatEndLength * 0.5);
			ptEndCut = ptEndIntersect - (vecMForIntersection * dEdgeToHalfWidthOfEndChamfer) + vxM * abs(dEdgeToHalfWidthOfEndChamfer * tan(45));
		}
		else
		{
			Point3d ptHalfWidthOfEndChamfer = ptTool + vecMForIntersection  * dFlatEndLength * 0.5;
			ptEndIntersect = Line(ptHalfWidthOfEndChamfer, vxM).intersect(pnFWeb, dTMaterialFemale + dGap);

			ptOtherEndIntersect = ptEndIntersect-vecMForIntersection * dFlatEndLength;
			ptEndCut = ptEndIntersect;
		}
		
		Vector3d vecEndIntersectCut = vxM.rotateBy(45, vxM.crossProduct(vecMForIntersection));
		vecEndIntersectCut.vis(ptEndIntersect);
		
		Vector3d vecOtherEndIntersectCut = vxM.rotateBy(-45, vxM.crossProduct(vecMForIntersection));
		vecOtherEndIntersectCut.vis(ptOtherEndIntersect);
		
		ptEndIntersect .vis();
		Plane plEndCut(ptEndCut, vxM);
		Cut endCut(ptEndCut, vxM);
		Cut angleCut(ptEndIntersect, vecEndIntersectCut);
		Cut angleOtherCut(ptOtherEndIntersect, vecOtherEndIntersectCut);
		bmMale.addToolStatic(endCut, _kStretchOnInsert);
		bmMale.addToolStatic(angleCut);
		bmMale.addToolStatic(angleOtherCut);
		ptToolPosition = ptTool.projectPoint(plEndCut, 0);
	}
	else {
		reportNotice(TN("|Unknowm tool found!|"));
	}
	
	Map mapCncExportSteelTool;
		ptToolPosition.vis();
	mapCncExportSteelTool.setPoint3d("POSITION",ptToolPosition);
	mapCncExportSteelTool.setString("TOOLCODE", sToolCode);
	mapCncExportSteelTool.setDouble("SIZE", dToolSize);
	mapCncExportSteelTool.setInt("FLAG", nFlag);
	CncExport cncExportSteelTool("STEELTOOL", mapCncExportSteelTool);
	bmMale.addTool(cncExportSteelTool);
}


for( int i=0;i<arNToolCodeFemale.length();i++ ){
	int nToolCode = arNToolCodeFemale[i];
	String sToolCode = arSToolCode[nToolCode];
	Point3d ptToolPosition = ptTool;
	double dToolSize;
	int nFlag = 0;
	
	double dFromStart = abs(vxF.dotProduct(ptToolPosition - arPtFemaleX[0]));
	double dFromEnd = abs(vxF.dotProduct(ptToolPosition - arPtFemaleX[arPtFemaleX.length() - 1]));
	
	if( nToolCode == 0 ){ // Service hole
		ptToolPosition = ptFWeb;
//		dToolSize = dRadiusServiceHole;
		Drill drill(ptToolPosition - vyF * U(25), ptToolPosition + vyF * U(25), dToolSize);
		drill.excludeMachineForCNC(_kAnyMachine);
		bmFemale.addTool(drill);
	}
	else if( nToolCode == 1 ){ // Web notch
		ptToolPosition = ptFWeb;
		if( abs(dAng - 90) > U(0.1) )
			dGapWebNotch *= 3;
		dToolSize = (bmMale.dW() + 2 * dGapWebNotch) / sin(dAng);
		
		BeamCut bmCut(ptToolPosition, bmFemale.vecX(), vyF, vzF, dToolSize, U(25), dHInsideFemale, nFlag, 0, 0);
		bmCut.excludeMachineForCNC(_kAnyMachine);
		bmFemale.addTool(bmCut);
	}
	else if( nToolCode == 2 ){ // Lip notch
		ptToolPosition = ptFLip;
		ptToolPosition.vis(3);
		if( abs(dAng - 90) > U(0.1) )
			dGapLipCut *= 3;
		dToolSize = (bmMale.dW() + 2 * dGapLipCut) / sin(dAng);
				
		BeamCut bmCut(ptToolPosition, bmFemale.vecX(), vyF, vzF, dToolSize, U(25), dHInsideFemale, nFlag, 0, 0);
		bmCut.excludeMachineForCNC(_kAnyMachine);
		bmFemale.addTool(bmCut);
		ptToolPosition.vis(1);
	}
	else if( nToolCode == 3 ){ // Web hole
		ptToolPosition = ptFWeb;
//		dToolSize = dRadiusWebHole;
		Drill drill(ptToolPosition - vyF * U(25), ptToolPosition + vyF * U(25), dToolSize);
		drill.excludeMachineForCNC(_kAnyMachine);
		bmFemale.addTool(drill);
	}
	else if( nToolCode == 4 ){ // Dimple
//		dToolSize = dRadiusDimple;
		Drill drill(ptToolPosition - vzF * U(250), ptToolPosition + vzF * U(250), dToolSize);
		drill.excludeMachineForCNC(_kAnyMachine);
		bmFemale.addTool(drill);
	}
	else if( nToolCode == 5 ){ // Swage
		dToolSize = bmMale.dW() / sin(dAng) + bmFemale.dW() / tan(dAng);
	}
	else if (nToolCode==8)
	{
		double dAngleBetweenBeams = vxM.angleTo(vxF);
		Vector3d vecMForIntersection;
		Vector3d vecFForOffset;
		Point3d ptEndIntersect;
		Point3d ptOtherEndIntersect;
		Point3d ptEndCut;
		Point3d ptEndIntersectReference;
		int bShallowAngle = true;
		int rotationFactor = 1;
		
		if(dAngleBetweenBeams < 45)
		{
			vecMForIntersection = vyM.dotProduct(vxF) < 0 ? -vyM :vyM;
			vecFForOffset = vxM.dotProduct(vyF) < 0 ? vyF : -vyF;
			bShallowAngle = false;
			rotationFactor = -1;
		}
		else if(dAngleBetweenBeams > 135)
		{
			vecMForIntersection = vyM.dotProduct(vxF) < 0 ? -vyM :vyM;
			vecFForOffset = vxM.dotProduct(vyF) < 0 ? -vyF : vyF;
			bShallowAngle = false;
		}
		else if(dAngleBetweenBeams < 90)
		{
			vecMForIntersection = vyM.dotProduct(vxF) < 0 ? -vyM :vyM;
			vecFForOffset = vxM.dotProduct(vyF) < 0 ? vyF : -vyF;
			rotationFactor = -1;
		}
		else
		{
			vecMForIntersection = vyM.dotProduct(vxF) < 0 ? -vyM :vyM;
			vecFForOffset = vxM.dotProduct(vyF) < 0 ? -vyF : vyF;
		}
		
		if(!bShallowAngle)
		{
			Point3d ptHalfWidthMale = ptTool + vecMForIntersection  * bmMale.dW() * 0.5;
			Plane plMaleEdge(ptHalfWidthMale, vyM);
			
			double dHalfWidthOfChamfer = dFlatEndLength * 0.5;
			ptEndIntersect = Line(ptTool + vecFForOffset * bmFemale.dW() * 0.5 , vxF).intersect(plMaleEdge, 0);
			ptOtherEndIntersect = ptEndIntersect-vecFForOffset*bmFemale.dW();

			double dEdgeToHalfWidthOfEndChamfer = (bmFemale.dW() * 0.5) - (dFlatEndLength * 0.5);
			ptEndCut = ptEndIntersect - (vecFForOffset * dEdgeToHalfWidthOfEndChamfer) + vxF * abs(dEdgeToHalfWidthOfEndChamfer * tan(45));
		}
		else
		{
			Point3d ptHalfWidthMale = ptTool + vecMForIntersection  * bmMale.dW() * 0.5;
			Plane plMaleEdge(ptHalfWidthMale, vyM);
			
			double dHalfWidthOfChamfer = dFlatEndLength * 0.5;
			ptEndIntersect = Line(ptTool + vecFForOffset * dHalfWidthOfChamfer , vxF).intersect(plMaleEdge, 0);
			ptOtherEndIntersect = ptEndIntersect-vecFForOffset*dFlatEndLength;

			ptEndCut = ptEndIntersect - vecFForOffset * dHalfWidthOfChamfer;
		}
		
		Vector3d vecEndIntersectCut = vxF.rotateBy(-45 * rotationFactor, vxM.crossProduct(vecMForIntersection));
		vecEndIntersectCut.vis(ptEndIntersect);
		
		Vector3d vecOtherEndIntersectCut = vxF.rotateBy(45 * rotationFactor, vxM.crossProduct(vecMForIntersection));
		vecOtherEndIntersectCut.vis(ptOtherEndIntersect);
		
		ptEndIntersect .vis();
		ptOtherEndIntersect.vis();
		ptEndCut.vis();
		
		Plane plEndCut(ptEndCut, vxF);
		Cut endCut(ptEndCut, vxF);
		Cut angleCut(ptEndIntersect, vecEndIntersectCut);
		Cut angleOtherCut(ptOtherEndIntersect, vecOtherEndIntersectCut);
		bmFemale.addToolStatic(endCut, _kStretchOnInsert);
		bmFemale.addToolStatic(angleCut);
		bmFemale.addToolStatic(angleOtherCut);
		ptToolPosition = ptTool.projectPoint(plEndCut, 0);
	}
	else {
		reportNotice(TN("|Unknowm tool found!|"));
	}
	
	Map mapCncExportSteelTool;
	mapCncExportSteelTool.setPoint3d("POSITION",ptToolPosition);
	mapCncExportSteelTool.setString("TOOLCODE", sToolCode);
	mapCncExportSteelTool.setDouble("SIZE", dToolSize);
	mapCncExportSteelTool.setInt("FLAG", nFlag);
	CncExport cncExportSteelTool("STEELTOOL", mapCncExportSteelTool);
	bmFemale.addTool(cncExportSteelTool);
}























#End
#BeginThumbnail
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
:BBB@`HHHH`****`"BBB@`HHHH`****`/_]EB
`



































#End