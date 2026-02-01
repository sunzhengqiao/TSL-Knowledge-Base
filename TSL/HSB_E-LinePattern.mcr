#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
26.01.2015  -  version 1.01







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl inserts a line pattern on a specified zone.
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <version  value="1.01" date="26.01.2015"></version>

/// <history>
/// AS - 1.00 - 22.01.2015 	- Pilot version
/// AS - 1.01 - 26.01.2015 	- Only swap if odd element has an element connected at the righthand side.
/// </history>

double dEps = Unit(0.01, "mm");

String arSCategory[] = {
	T("|Line pattern|"),
	T("|Style|")
};

int arNZoneIndex[] = {0,1,2,3,4,5,6,7,8,9,10};
PropInt nZoneIndex(0, arNZoneIndex, T("|Zone index|"),6);
nZoneIndex.setCategory(arSCategory[0]);

PropDouble dSpacing(0, U(122), T("|Spacing|"));
dSpacing.setCategory(arSCategory[0]);

PropInt nLineColor(1, -1, T("|Line color|"));
nLineColor.setCategory(arSCategory[1]);


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-LinePattern");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	PrEntity ssE(T("Select a set of elements"), Element());
	
	if( ssE.go() ){
		Element arSelectedElement[] = ssE.elementSet();
		
		String strScriptName = "HSB_E-LinePattern"; // name of the script
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
		mapTsl.setInt("ExecuteMode", 1);// 1 == recalc	
		for( int e=0;e<arSelectedElement.length();e++ ){
			Element el = arSelectedElement[e];
			lstElements[0] = el;
			
			TslInst arTsl[] = el.tslInst();
			for( int i=0;i<arTsl.length();i++ ){
				TslInst tsl = arTsl[i];
				if( tsl.scriptName() == strScriptName ){
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


if( _Element.length() == 0 ){
	eraseInstance();
	return;
}

Element el = _Element[0];

// Assign tsl to the default element layer.
assignToElementGroup(el, true, 0, 'E');

int nZnIndex = nZoneIndex;
if (nZnIndex > 5)
	nZnIndex = 5 - nZnIndex;

Display dp(nLineColor);
dp.elemZone(el, nZnIndex, 'I');

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
_Pt0 = ptEl;

CoordSys csSide = el.zone(nZnIndex).coordSys();
if (nZnIndex < 0 )
	csSide = el.zone(nZnIndex - 1).coordSys();
PlaneProfile ppZn(csSide);
ppZn.unionWith(el.profNetto(nZnIndex));
LineSeg lnSegZn = ppZn.extentInDir(vxEl);

lnSegZn.vis(1);

Point3d ptStartDistribution = lnSegZn.ptStart();
Point3d ptEndDistribution = lnSegZn.ptEnd();
double dDistributionWidth = vxEl.dotProduct(ptEndDistribution - ptStartDistribution);

Vector3d vxDistribution = vxEl;

double d = dDistributionWidth/dSpacing;
int n = int((dDistributionWidth + dEps)/dSpacing);
int bOddElement = (dDistributionWidth/dSpacing - int((dDistributionWidth + dEps)/dSpacing)) > dEps;

if (bOddElement) {
	int bSwapDistributionSide = false;
	
	PlaneProfile ppEl = el.profBrutto(0);
	ppEl.vis(2);
	
	Group grpEl = el.elementGroup();
	Entity arEntElRf[] = Group(grpEl.namePart(0), grpEl.namePart(1), "").collectEntities(true, ElementRoof(), _kModelSpace);
	
	for (int i=0;i<arEntElRf.length();i++) {
		ElementRoof elRf = (ElementRoof)arEntElRf[i];
		if (!elRf.bIsValid())
			continue;
		if (elRf.handle() == el.handle())
			continue;
		if (abs(vzEl.dotProduct(elRf.vecZ()) - 1) > dEps)
			continue;
		if (abs(vzEl.dotProduct(ptEl - elRf.ptOrg())) > dEps)
			continue;
		
		PlaneProfile ppElRf = elRf.profBrutto(0);
		ppElRf.shrink(-U(25));
		
		if (ppElRf.intersectWith(ppEl)) {
			ppElRf.vis(1);
			Point3d ptIntersectingArea = ppElRf.extentInDir(vxEl).ptMid();
			if (abs(vxEl.dotProduct(ptIntersectingArea - ptEl)) > U(25) )
				bSwapDistributionSide = true;

			break;
		}
	}
	
	if (bSwapDistributionSide) {
		vxDistribution = -vxEl;
		Point3d ptTmp = ptStartDistribution;
		ptStartDistribution = ptEndDistribution + vyEl * vyEl.dotProduct(ptStartDistribution - ptEndDistribution);
		ptEndDistribution = ptTmp + vyEl * vyEl.dotProduct(ptEndDistribution - ptTmp);
		
		PLine plStart(ptStartDistribution - vyEl * U(50), ptStartDistribution - vyEl * U(50) + vxDistribution * U(100));
		dp.draw(plStart);
		PLine plArrow(ptStartDistribution - vyEl * U(70) + vxDistribution * U(75), ptStartDistribution - vyEl * U(50) + vxDistribution * U(100));
		plArrow.addVertex(ptStartDistribution - vyEl * U(30) + vxDistribution * U(75));
		dp.draw(plArrow);
	}
}

Point3d ptDistribution = ptStartDistribution + vxDistribution * dSpacing;
while (vxDistribution.dotProduct(ptEndDistribution - ptDistribution) > 0) {
	LineSeg arLnSeg[] = ppZn.splitSegments(LineSeg(ptDistribution, ptDistribution + vyEl * vyEl.dotProduct(lnSegZn.ptEnd() - ptDistribution)), true);
	
	for (int j=0;j<arLnSeg.length();j++)
		dp.draw(arLnSeg[j]);
	
	ptDistribution += vxDistribution * dSpacing;
}


#End
#BeginThumbnail

#End