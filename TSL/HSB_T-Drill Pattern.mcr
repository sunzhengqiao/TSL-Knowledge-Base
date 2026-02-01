#Version 8
#BeginDescription
Last modified by: Anno Sportel (support.nl@hsbcad.com)
28.11.2017  -  version 1.03

Description
This tsls applies a drill pattern to a beam. The drillings can alternate bewteen the front and back of the beam.
 
Insert
The tsl can be inserted to multiple beams at once. It will create an instance of the tsl per beam.
 
Remarks
The symbol is only visible in plan view.
#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsls applies a drill pattern to a beam. There are always 2 drills on the start and 2 drills at the end of the beam. The drillings in between can alternate bewteen the front and back of the beam.
/// </summary>

/// <insert>
/// The tsl can be inserted to multiple beams at once. It will create an instance of the tsl per beam.
/// </insert>

/// <remark Lang=en>
/// The symbol is only visible in plan view.
/// </remark>

/// <version  value="1.03" date="28.11.2017"></version>

/// <history>
/// AS - 1.00 - 13.11.2012 -	Pilot version
/// AS - 1.01 - 13.11.2012 -	Fix bug on first and last drill in combination with zig-zag drilling.
/// AS - 1.02 - 13.11.2012 -	Add view direction and recalc on beamlength changed.
/// AS - 1.03 - 28.11.2017 -	Add support for drills on centre line
/// </history>

double dEps = U(0.01, "mm"); //script uses mm.

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};


PropString sSeperator01(0, "", T("|Orientation|"));
sSeperator01.setReadOnly(true);
PropString sSwap(1, arSYesNo, "     "+T("|Swap side|"),1);
PropString sFlip(2, arSYesNo, "     "+T("|Flip|"),1);


PropString sSeperator02(3, "", T("|Start positions|"));
sSeperator02.setReadOnly(true);
PropDouble dyFront(0, U(30), "     "+T("Y-|offset front|"));
PropDouble dxFront(1, U(85), "     "+T("X-|offset front|"));
PropDouble dyBack(2, U(30), "     "+T("Y-|offset back|"));
PropDouble dxBack(3, U(35), "     "+T("X-|offset back|"));


PropString sSeperator03(4, "", T("|Distribution|"));
sSeperator03.setReadOnly(true);
PropDouble dMaximumSpacing(4, U(600), "     "+T("|Maximum spacing|"));
String distributionPatterns[] = 
{
	T("|Front and back|"),
	T("|Zig-zag|"),
	T("|Centre line|")
};
PropString distributionPattern(7, distributionPatterns, "     "+T("|Distribution pattern|"));

PropString sSeperator04(5, "", T("|Drill| &")+T("|sinkhole|"));
sSeperator04.setReadOnly(true);
PropDouble dDrillDiam(5, U(14), "     "+T("|Drill diamter|"));
PropDouble dDiamSinkhole(6, U(40), "     "+T("|Diamter sinkhole|"));
PropDouble dDepthSinkhole(7, U(15), "     "+T("|Depth sinkhole|"));


PropString sSeperator05(6, "", T("|Symbol|"));
sSeperator05.setReadOnly(true);
PropDouble dSymbolSize(8, U(50), "     "+T("|Symbol size|"));


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_T-Drill Pattern");
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
	PrEntity ssE(T("|Select one or more beams|"), Beam());
	if (ssE.go()) {
		Beam arSelectedBeams[] = ssE.beamSet();
		
		//insertion point
		String strScriptName = "HSB_T-Drill Pattern"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[1];
		Entity lstEntities[0];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", TRUE);
		setCatalogFromPropValues("MasterToSatellite");
		mapTsl.setInt("ExecuteMode", 1);
		mapTsl.setInt("ManualInsert", true);
		for( int i=0;i<arSelectedBeams.length();i++ ){
			Beam bm = arSelectedBeams[i];
			lstBeams[0] = bm;
			
			Entity arEnt[] = bm.eToolsConnected();
			for( int i=0;i<arEnt.length();i++ ){
				Entity ent = arEnt[i];
				TslInst tsl = (TslInst)ent;
				if( tsl.bIsValid() && tsl.scriptName() == strScriptName ){
					reportMessage(TN("|Duplicate tsls were found and removed during insert|!"));
					tsl.dbErase();
				}	
			}
					
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
			nNrOfTslsInserted++;
		}
	}
	
	reportMessage(TN("|Number of tsls inserted|: ")+nNrOfTslsInserted);
	
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

if( _Beam.length() == 0 ){
	reportMessage(T("|No valid beam selected|!"));
	eraseInstance();
	return;
}

int bSwap = arNYesNo[arSYesNo.find(sSwap,1)];
int bFlip = arNYesNo[arSYesNo.find(sFlip,1)];
int bSwapSides = distributionPatterns.find(distributionPattern) == 1;
int drillOnCentreLine = distributionPatterns.find(distributionPattern) == 2;

Beam bm = _Beam[0];
setDependencyOnBeamLength(bm);

Entity arEnt[] = bm.eToolsConnected();
for( int i=0;i<arEnt.length();i++ ){
	Entity ent = arEnt[i];
	TslInst tsl = (TslInst)ent;
	if( tsl.bIsValid() && tsl.scriptName() == _ThisInst.scriptName() && tsl.handle() != _ThisInst.handle() ){
		reportMessage(T("|Duplicate tsl found and removed|!"));
		tsl.dbErase();
	}	
}

Vector3d vxBm = bm.vecX();
Vector3d vyBm = bm.vecY();
Vector3d vzBm = bm.vecZ();

if( bSwap ){
	vyBm = vzBm;
	vzBm = bm.vecY();
}

if( bFlip ){
	vyBm *= -1;
	vzBm *= -1;
}

Point3d ptStartBm = bm.ptCenSolid() - 0.5 * vxBm * bm.solidLength() + vzBm * 0.5 * bm.dD(vzBm);
Point3d ptEndBm = bm.ptCenSolid() + 0.5 * vxBm * bm.solidLength() + vzBm * 0.5 * bm.dD(vzBm);

if (!drillOnCentreLine)
{
	ptStartBm -= vyBm * 0.5 * bm.dD(vyBm);
	ptEndBm -= vyBm * 0.5 * bm.dD(vyBm);
}
ptStartBm.vis();

ptEndBm.vis();


vxBm.vis(ptStartBm,1);
vyBm.vis(ptStartBm,3);
vzBm.vis(ptStartBm,150);

_Pt0 = ptStartBm;

Point3d ptStartFront = ptStartBm + vxBm * dxFront + vyBm * dyFront;
Point3d ptStartBack = ptStartBm + vxBm * dxBack + vyBm * (bm.dD(vyBm) - dyBack);
ptStartFront.vis(3);
ptStartBack.vis(3);

Point3d ptEndFront = ptEndBm - vxBm * dxBack + vyBm * dyFront;
Point3d ptEndBack = ptEndBm - vxBm * dxFront + vyBm * (bm.dD(vyBm) - dyBack);
ptEndFront.vis(1);
ptEndBack.vis(1);

double dDistributionLength = vxBm.dotProduct(ptEndFront - ptStartFront);
double dNrOfSpacings = dDistributionLength / dMaximumSpacing;
int nNrOfSpacings = int(dNrOfSpacings);

double dRest = dNrOfSpacings - nNrOfSpacings;
if( dRest > dEps )
	nNrOfSpacings++;
double dSpacing = dDistributionLength / nNrOfSpacings;

Drill drill(ptStartFront, ptStartFront - vzBm * bm.dD(vzBm), 0.5 * dDrillDiam);

int applySinkhole = (dDiamSinkhole * dDepthSinkhole) > 0;
Mortise sinkhole(ptStartFront, vxBm, vyBm, -vzBm, dDiamSinkhole, dDiamSinkhole, dDepthSinkhole);

for( int i=0;i<=nNrOfSpacings;i++ ){
	if( i>0 ){
		drill.transformBy(vxBm * dSpacing);
		if (applySinkhole)
		{
			sinkhole.transformBy(vxBm * dSpacing);
		}
	}
	double dPosition = i/2.0 - i/2;
	if (drillOnCentreLine)
	{
		bm.addTool(drill);
		if (applySinkhole)
		{
			bm.addTool(sinkhole);
		}
		
		continue;
	}
	else if( i == 0 || i == nNrOfSpacings || (bSwapSides && dPosition > 0) || !bSwapSides ){
		bm.addTool(drill);
		if (applySinkhole)
		{
			bm.addTool(sinkhole);
		}
	}
	
	Vector3d vFrontToBack = ptStartBack - ptStartFront;
	if( bSwapSides && i != 0 && i != nNrOfSpacings )
		vFrontToBack = vyBm * (bm.dD(vyBm) - dyBack - dyFront);
	
	
	if( i==0 || i==nNrOfSpacings || (bSwapSides && dPosition == 0) || !bSwapSides ){
		drill.transformBy(vFrontToBack);
		sinkhole.transformBy(vFrontToBack);
		
		bm.addTool(drill);
		if (applySinkhole)
		{
			bm.addTool(sinkhole);
		}
		
		drill.transformBy(-vFrontToBack);
		sinkhole.transformBy(-vFrontToBack);
	}
}

Display dpSymbol(7);
dpSymbol.addViewDirection(vzBm);
dpSymbol.addViewDirection(-vzBm);

PLine plDrill(vzBm);
plDrill.createCircle(ptStartBm - vyBm * dSymbolSize, vzBm, 0.2 * dSymbolSize);
PLine plSinkhole(vzBm);
plSinkhole.createCircle(ptStartBm - vyBm * dSymbolSize, vzBm, 0.5 * dSymbolSize);

PLine plArrow(vzBm);
Point3d ptStartArrow = ptStartBm - (vyBm - vxBm) * dSymbolSize;
plArrow.addVertex(ptStartArrow);
plArrow.addVertex(ptStartArrow + vxBm * 3 * dSymbolSize);
plArrow.addVertex(ptStartArrow + (2 * vxBm + 0.5 * vyBm) * dSymbolSize);
plArrow.addVertex(ptStartArrow + vxBm * 3 * dSymbolSize);
plArrow.addVertex(ptStartArrow + (2 * vxBm - 0.5 * vyBm) * dSymbolSize);

dpSymbol.color(1);
dpSymbol.draw(plDrill);
dpSymbol.color(7);
dpSymbol.draw(plSinkhole);
dpSymbol.draw(plArrow);

String sSpacing;
sSpacing.formatUnit(dSpacing, 2, 1);
dpSymbol.textHeight(0.33 * dSymbolSize);
dpSymbol.color(1);
dpSymbol.draw(sSpacing + " mm", ptStartArrow, vxBm, vyBm, 1, 1.1,_kDevice);


#End
#BeginThumbnail
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
<*`"BBB@`HHHH`****`"BBB@`HHHH`****`/_V8HH
`


#End