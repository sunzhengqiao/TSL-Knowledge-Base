#Version 8
#BeginDescription
Last modified by: Anno Sportel (support.nl@hsbcad.com)
11.01.2018  -  version 1.02


#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl adds a drill to a beam
/// </summary>

/// <insert>
/// Select a set of beams. The tsl is reinserted for each beam.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.02" date="11.01.2018"></version>

/// <history>
/// AS - 1.00 - 18.02.2013 -	Pilot version
/// AS - 1.01 - 18.02.2013 -	Remove preview mode. Keep tsl in dwg.
/// AS - 1.02 - 11.01.2018 -	Only make it a circle if the width and length are the same and the corners are rounded.
/// </history>

double dEps = Unit(0.01, "mm");

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

PropString sSeperator01(0, "", T("|Position|"));
sSeperator01.setReadOnly(true);
PropDouble dxOffset(0, U(0), "     "+T("|Offset X|"));
PropDouble dyOffset(1, U(0), "     "+T("|Offset Y|"));

PropString sSeperator02(1, "", T("|Size|"));
sSeperator02.setReadOnly(true);
PropDouble dToolDpth(2, U(10), "     "+T("|Depth|"));
dToolDpth.setDescription(T("|Drill depth, zero means completely through|"));
PropDouble dToolWidth(3, U(20), "     "+T("|Diamter|/")+T("|width|"));
PropDouble dToolLngth(4, U(100), "     "+T("|Length|"));
int arNShape[]={_kNotRound,_kRound};
String arSShape[] = {T("|Square|"),T("|Rounded|")};
PropString sShape(2, arSShape, "     "+T("|Corners for slotted hole|"),1);

PropString sSeperator04(3, "", T("|Rotation|"));
sSeperator04.setReadOnly(true);
PropDouble dRotAngle(5, 0, "     "+T("|Angle|"));
dRotAngle.setFormat(_kAngle);


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_T-Drill");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);


if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	PrEntity ssBm(T("|Select a set of beams|"), Beam());
	if( ssBm.go() ){
		_Pt0 = getPoint(T("|Select a position|"));
		
		
		Beam arBm[] = ssBm.beamSet();
		
		String strScriptName = "HSB_T-Drill"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[1];
		Entity lstEntities[0];
		
		Point3d lstPoints[] = {_Pt0};
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", TRUE);
		setCatalogFromPropValues("MasterToSatellite");
		for( int i=0;i<arBm.length();i++ ){
			Beam bm = arBm[i];
			lstBeams[0] = bm;
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}
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

Display dp(-1);

Beam bm = _Beam[0];
Element el = bm.element();
if( el.bIsValid() ){
	_ThisInst.assignToElementGroup(el, true, 0, 'E');
	dp.elemZone(el, 0, 'T');
}

Vector3d vxTool = -_X0;
Vector3d vyTool = _Y0;
Vector3d vzTool = -_Z0;

if( dRotAngle != 0 ){
	CoordSys csRot;
	csRot.setToRotation(dRotAngle,vzTool,_Pt0 );
	vxTool.transformBy(csRot);
	vyTool.transformBy(csRot);
}
vxTool.normalize();
vzTool.normalize();

Point3d ptTool = _Pt0 - vzTool * 0.5 * bm.dD(vzTool) + vxTool * dxOffset + vyTool * dyOffset;

vxTool.vis(ptTool, 1);
vyTool.vis(ptTool, 3);
vzTool.vis(ptTool, 150);

// Resolve properties
double dToolDepth = dToolDpth;
if( dToolDepth <= 0 )
	dToolDepth = bm.dD(vzTool);
double dToolLength = dToolLngth;
if( dToolLength == 0 )
	dToolLength = dToolWidth;
if( dToolWidth == 0 ){
	reportError(T("|Invalid toolsize found|!")+scriptName() + TN(" |is removed|."));
	eraseInstance();
	return;
}
int nShape = arNShape[arSShape.find(sShape,1)];

Drill drill(ptTool, vzTool, dToolDepth, 0.5 * dToolWidth);

Mortise mortise(ptTool, vxTool, vyTool, vzTool, dToolLength, dToolWidth, 2 * dToolDepth, 0, 0, 0);
mortise.setEndType(_kFemaleSide);
mortise.setRoundType(nShape);

if( dToolWidth == dToolLength && nShape == _kRound){
	PLine plStart(vzTool);
	plStart.createCircle(ptTool, vzTool, 0.4 * dToolWidth);
	dp.color(1);
	dp.draw(plStart);
	PLine plEnd(vzTool);
	plEnd.createCircle(ptTool + vzTool * dToolDepth, vzTool, 0.4 * dToolWidth);
	dp.draw(plEnd);
	PLine plDepth(ptTool, ptTool + vzTool * dToolDepth);
	dp.color(7);
	dp.draw(plDepth);
	
	_Beam0.addTool(drill);
}
else{
	dp.color(1);
	
	Point3d ptToolA = ptTool - vxTool * 0.5 * (dToolLength - dToolWidth);
	Point3d ptToolB = ptTool + vxTool * 0.5 * (dToolLength - dToolWidth);
	if( nShape == _kRound ){
		PLine plStart(vzTool);
		plStart.addVertex(ptToolA + vyTool * 0.4 * dToolWidth);
		plStart.addVertex(ptToolA - vyTool * 0.4 * dToolWidth, 1);
		plStart.addVertex(ptToolB - vyTool * 0.4 * dToolWidth);
		plStart.addVertex(ptToolB + vyTool * 0.4 * dToolWidth, 1);
		plStart.close();
		dp.draw(plStart);
		plStart.transformBy(vzTool * dToolDepth);
		dp.draw(plStart);
		PLine plDepthA(ptToolA, ptToolA + vzTool * dToolDepth);
		PLine plDepthB(ptToolB, ptToolB + vzTool * dToolDepth);
		dp.color(7);
		dp.draw(plDepthA);
		dp.draw(plDepthB);
	}
	else{
		PLine plStart(vzTool);
		plStart.addVertex(ptToolA - (vxTool + vyTool) * 0.4 * dToolWidth);
		plStart.addVertex(ptToolA - (vxTool - vyTool) * 0.4 * dToolWidth);
		plStart.addVertex(ptToolB + (vxTool + vyTool) * 0.4 * dToolWidth);
		plStart.addVertex(ptToolB + (vxTool - vyTool) * 0.4 * dToolWidth);
		plStart.close();
		dp.draw(plStart);
		plStart.transformBy(vzTool * dToolDepth);
		dp.draw(plStart);
		PLine plDepthA1(ptToolA - (vxTool + vyTool) * 0.4 * dToolWidth, ptToolA - (vxTool + vyTool) * 0.4 * dToolWidth + vzTool * dToolDepth);
		PLine plDepthA2(ptToolA - (vxTool - vyTool) * 0.4 * dToolWidth, ptToolA - (vxTool - vyTool) * 0.4 * dToolWidth + vzTool * dToolDepth);
		PLine plDepthB1(ptToolB + (vxTool + vyTool) * 0.4 * dToolWidth, ptToolB + (vxTool + vyTool) * 0.4 * dToolWidth + vzTool * dToolDepth);
		PLine plDepthB2(ptToolB + (vxTool - vyTool) * 0.4 * dToolWidth, ptToolB + (vxTool - vyTool) * 0.4 * dToolWidth + vzTool * dToolDepth);
		dp.color(7);
		dp.draw(plDepthA1);
		dp.draw(plDepthA2);
		dp.draw(plDepthB1);
		dp.draw(plDepthB2);
	}

	
	_Beam0.addTool(mortise);
}



#End
#BeginThumbnail
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
0`++@D'Z54*+YD3*M&Q__V=3_
`

#End
