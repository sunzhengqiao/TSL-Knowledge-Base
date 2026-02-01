#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
19.06.2015  -  version 1.00
















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
/// This tsl places detail texts at a given position
/// </summary>

/// <insert>
/// Auto: Attach the tsl to element definition
/// Manual: Select elements
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="19.06.2015"></version>

/// <history>
/// AS - 1.00 - 19.06.2015 -	Pilot version
/// </history>

double dEps = Unit(0.1, "mm");


//PropString sSeperator03(5, "", T("|Detail|"));
//PropString sScriptNameDetailName(6, "HSB_E-DetailName", "     "+T("|Scriptname detail tsl|"));

String sScriptNameDetailName = "HSB_E-DetailName";
String arSCatalogNamesDetailName[] = TslInst().getListOfCatalogNames(sScriptNameDetailName);

PropString sCatDetails(0, arSCatalogNamesDetailName, T("|Catalog details|"));
sCatDetails.setDescription(T("|Sets the catalog used to set the properties of the detail tsl.|"));

if( _bOnElementDeleted ){
	eraseInstance();
	return;
}

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_S-InsertDetailNames");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	int nNrOfTslsInserted = 0;
	//Select beam(s) and insertion point
	PrEntity ssE(T("|Select one or more elements|"), Element());
	if (ssE.go()) {
		Element arSelectedElements[] = ssE.elementSet();
		
		//insertion point
		String strScriptName = "HSB_S-InsertDetailNames"; // name of the script
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
		mapTsl.setInt("ExecuteMode", 1);
		mapTsl.setInt("ManualInsert", true);
		for( int i=0;i<arSelectedElements.length();i++ ){
			Element el = arSelectedElements[i];
			lstEntities[0] = el;
			
			TslInst arTsl[] = el.tslInst();
			for( int j=0;j<arTsl.length();j++ ){
				TslInst tsl = arTsl[j];
				if( !tsl.bIsValid() || tsl.scriptName() == strScriptName )
					tsl.dbErase();
			}
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
			nNrOfTslsInserted++;
		}
	}
	
//	reportMessage(nNrOfTslsInserted + T(" |tsl(s) inserted|"));
	
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
int bManualInsert = false;
if( _Map.hasInt("ManualInsert") ){
	bManualInsert = _Map.getInt("ManualInsert");
	_Map.removeAt("ManualInsert", true);
}

if( _Element.length() == 0 ){
	reportMessage(TN("|Invalid selection|!"));
	eraseInstance();
	return;
}

Element el = _Element[0];

TslInst arTsl[] = el.tslInst();
for( int i=0;i<arTsl.length();i++ ){
	TslInst tsl = arTsl[i];
	if( !tsl.bIsValid() || tsl.scriptName() == sScriptNameDetailName )
		tsl.dbErase();
}

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
_Pt0 = ptEl - vzEl * el.zone(0).dH();

CoordSys csDetails = csEl;
csDetails.transformBy(vzEl * vzEl.dotProduct(_Pt0 - ptEl));

Plane pnEl(_Pt0, vzEl);
Point3d ptElMid = ptEl - vzEl * 0.5 * el.zone(0).dH();

Vector3d vReadDirection = -vxEl + vyEl;
vReadDirection.normalize();

Display dp(1);
dp.textHeight(U(75));

Beam arBm[] = el.beam();

//insertion point
String strScriptName = sScriptNameDetailName;
Vector3d vecUcsX(1,0,0);
Vector3d vecUcsY(0,1,0);
Beam lstBeams[0];
Entity lstEntities[] = {el};

Point3d lstPoints[1];
int lstPropInt[0];
double lstPropDouble[0];
String lstPropString[0];
Map mapTsl;

if( _bOnDebug || _bOnElementConstructed || bManualInsert ){
	Sip sips[] = el.sip();
	for (int s=0;s<sips.length();s++) {
		Sip sip = sips[s];
		SipEdge sipEdges[] = sip.sipEdges();
		for (int e=0;e<sipEdges.length();e++) {
			SipEdge sipEdge = sipEdges[e];
			String sDetailName = sipEdge.detailCode();
			if (sDetailName.length() == 0)
				continue;
			
			Point3d ptDetail = sipEdge.ptMid();
			Vector3d vxEdge(sipEdge.ptEnd() - sipEdge.ptStart());
			vxEdge.normalize();
			Vector3d vNormal = sipEdge.vecNormal(); 
			
			//Insert detail name tsl
			lstPoints[0] = ptDetail;
			mapTsl = Map();
			mapTsl.setPoint3d("Position", ptDetail);
			mapTsl.setPoint3d("Normal", ptDetail +  vxEdge * U(100));
			mapTsl.setPoint3d("Detail", ptDetail - vNormal * U(100));
					
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
			tsl.setPropValuesFromCatalog(sCatDetails);
			tsl.setPropString("     "+T("|Name|"), sDetailName );
		}
	}

	eraseInstance();
}














#End
#BeginThumbnail

#End