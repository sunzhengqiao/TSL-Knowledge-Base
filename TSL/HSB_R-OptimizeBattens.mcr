#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
05.11.2015  -  version 1.07

This tsl optimizes counter battens. The dimensions of angled battens are corrected. 
The battens are squared off and cut at standarized lengths.









#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl optimizes counter battens. The dimensions of angled battens are corrected. 
/// They are squared off and cut at standarized lengths.
/// </summary>

/// <insert>
///
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.07" date="05.11.2015"></version>

/// <history>
/// 1.00 - 19.09.2012 - 	Pilot version
/// 1.01 - 08.10.2012 - 	Set the right material
/// 1.02 - 09.10.2012 - 	Square off through dbSplit and dbErase the part which is splitted off.
/// 1.03 - 03.07.2013 - 	Check if the remaining length stil exceeds the optimized length.
/// 1.04 - 26.02.2015 - 	Add support for usage of catalogs from toolpalette (TeamLeader 35036)
/// 1.05 - 11.06.2015 - 	Add gap
/// 1.06 - 17.07.2015 - 	Add tolerance to square off.
/// 1.07 - 05.11.2015 - 	Change defaults.
/// </hsitory>

double dEps = Unit(0.001, "mm");

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

PropString sSeperator01(0, "", T("|Oriëntation|"));
sSeperator01.setReadOnly(true);
PropString sCorrectOrientation(1, arSYesNo, "     "+T("|Correct oriëntation|"));

PropString sSeperator02(2, "", T("|Square off|"));
sSeperator02.setReadOnly(true);
PropString sSquareOff(3, arSYesNo, "     "+T("|Make battens squared|"));

PropString sSeperator03(4, "", T("|Optimize length|"));
sSeperator03.setReadOnly(true);
PropString sOptimizeLength(5, arSYesNo, "     "+T("|Optimize length|"),1);
PropDouble dOptimizedLength(0, U(10000), "     "+T("|Optimized length|"));
PropDouble dGap(1, U(0), "     "+T("|Gap|"));

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_R-OptimizeBattens");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
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
		String strScriptName = "HSB_R-OptimizeBattens"; // name of the script
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
	
	reportMessage(nNrOfTslsInserted + T(" |tsl(s) inserted|"));
	
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

int bCorrectOrientation = arNYesNo[arSYesNo.find(sCorrectOrientation,0)];
int bSquareOff = arNYesNo[arSYesNo.find(sSquareOff,0)];
int bOptimizeLength = arNYesNo[arSYesNo.find(sOptimizeLength,0)];

if( _bOnElementConstructed || bManualInsert ){
	if( el.bIsKindOf(ERoofPlane()) ){
		eraseInstance();
		return;
	}
	
	CoordSys csEl = el.coordSys();
	Point3d ptEl = csEl.ptOrg();
	Vector3d vxEl = csEl.vecX();
	Vector3d vyEl = csEl.vecY();
	Vector3d vzEl = csEl.vecZ();
	Line lnX(ptEl, vxEl);
	
	Sheet arShZn04[] = el.sheet(4);
	for( int i=0;i<arShZn04.length();i++ ){
		Sheet sh = arShZn04[i];
		
		PlaneProfile ppSh = sh.profShape();
		PLine arPlSh[] = ppSh.allRings();
		int arBRingIsOpening[] = ppSh.ringIsOpening();

		int bOutlineFound = false;
		PLine plSh(vzEl);
		for( int j=0;j<arPlSh.length();j++ ){
			if( arBRingIsOpening[j] )
				continue;
			plSh = arPlSh[j];

			bOutlineFound = true;
			break;
		}
		
		if( !bOutlineFound )
			continue;
		
		Point3d arPtSh[] = plSh.vertexPoints(false);
		
		CoordSys csSh = sh.coordSys();
		Vector3d vxSh = csSh.vecX();
		Vector3d vySh = csSh.vecY();
		Vector3d vzSh = csSh.vecZ();
		
		Vector3d vxNew = vxSh;
		double dLongestLnSeg = U(0);
		LineSeg arLnSeg[0];
		for( int j=0;j<(arPtSh.length() - 1);j++ ){
			Point3d ptFrom = arPtSh[j];
			Point3d ptTo = arPtSh[j+1];
			arLnSeg.append(LineSeg(ptFrom, ptTo));
			
			Vector3d vLnSeg(ptTo - ptFrom);
			double dLLnSeg = vLnSeg.length();
			vLnSeg.normalize();
			
			if( dLLnSeg > dLongestLnSeg ){
				dLongestLnSeg = dLLnSeg;
				vxNew = vLnSeg;
			}
		}
		Line lnVxNew(sh.ptCen(), vxNew);
		Line lnVyNew(sh.ptCen(), vzEl.crossProduct(vxNew));
		
		if( bCorrectOrientation && abs(abs(vxNew.dotProduct(vxSh)) - 1) > dEps ){
			//Better orientation found
			Vector3d vyNew = vzEl.crossProduct(vxNew);
			Vector3d vzNew = vzEl;
			
			PlaneProfile ppShNew(CoordSys(csSh.ptOrg(), -vyNew, vxNew, vzNew));
			ppShNew.unionWith(ppSh);
			Sheet shNew;
			shNew.dbCreate(ppShNew, sh.solidHeight(), 1);
			shNew.assignToElementGroup(el, true, 4, 'Z');
			shNew.setColor(6);
			shNew.setMaterial(sh.material());
			
			sh.dbErase();
			
			sh = shNew;
			vxSh = vxNew;
			vySh = vyNew;
			vzSh = vzNew;
		}
		
		Cut arCut[0];
		Point3d arPtCut[0];
		if( bSquareOff  ){
			Point3d arPtStart[0];
			Point3d arPtEnd[0];
			for( int j=0;j<arLnSeg.length();j++ ){
				LineSeg lnSeg = arLnSeg[j];
				Point3d ptFrom = lnSeg.ptStart();
				Point3d ptTo = lnSeg.ptEnd();
				
				Vector3d vLnSeg(ptTo - ptFrom);
				vLnSeg.normalize();
				
				if( !vLnSeg.isParallelTo(vxNew) )
					continue;
				
				if( vLnSeg.dotProduct(vxNew) > 0 ){
					arPtStart.append(ptFrom);
					arPtEnd.append(ptTo);
				}
				else{
					arPtStart.append(ptTo);
					arPtEnd.append(ptFrom);
				}
			}
			
			Point3d arPtStartX[] = lnVxNew.orderPoints(arPtStart);
			Point3d arPtEndX[] = lnVxNew.orderPoints(arPtEnd);
			if( arPtStartX.length() == 0  || arPtEndX.length() == 0 )
				continue;
			
			Sheet arShSplittedStart[] = sh.dbSplit(Plane(arPtStartX[arPtStartX.length() - 1], vxNew), U(0.001));
			if( arShSplittedStart.length() == 2 ){
				Sheet shA = arShSplittedStart[0];
				Sheet shB = arShSplittedStart[1];
				if( vxNew.dotProduct(shB.ptCenSolid() - shA.ptCenSolid()) < 0 ){
					shB.dbErase();
					sh = shA;
				}
				else{
					shA.dbErase();
					sh = shB;
				}
			}
			else if( arShSplittedStart.length() == 1 ){
				Sheet shA = arShSplittedStart[0];
				if( vxNew.dotProduct(sh.ptCenSolid() - shA.ptCenSolid()) < 0 ) {
					sh.dbErase();
					sh = shA;
				}
				else{
					shA.dbErase();
				}
			}
			
			Sheet arShSplittedEnd[] = sh.dbSplit(Plane(arPtEndX[0], vxNew), U(0.001));
			if( arShSplittedEnd.length() == 2 ){
				Sheet shA = arShSplittedEnd[0];
				Sheet shB = arShSplittedEnd[1];
				if( vxNew.dotProduct(shA.ptCenSolid() - shB.ptCenSolid()) < 0 ){
					shB.dbErase();
					sh = shA;
				}
				else{
					shA.dbErase();
					sh = shB;
				}
			}
			else if( arShSplittedEnd.length() == 1 ){
				Sheet shA = arShSplittedEnd[0];
				if( vxNew.dotProduct(shA.ptCenSolid() - sh.ptCenSolid()) < 0 ) {
					sh.dbErase();
					sh = shA;
				}
				else{
					shA.dbErase();
				}
			}
		}
	
		if( bOptimizeLength ){		
			Point3d arPtSh[] = sh.profShape().getGripVertexPoints();				
			arPtSh = lnVxNew.orderPoints(arPtSh);
			if( arPtSh.length() < 2 )
				continue;
			
			double dShL = vxNew.dotProduct(arPtSh[arPtSh.length() - 1] - arPtSh[0]);
			Point3d ptSplit = arPtSh[0] + vxNew * dOptimizedLength;
			int nNrOfLoops = 0;
			while( dShL > (dOptimizedLength + dEps) ){
				Sheet arShSplit[] = sh.dbSplit(Plane(ptSplit + vxNew * 0.5 * dGap, vxNew), dGap);
				arShSplit.append(sh);
				if( arShSplit.length() == 0 )
					break;
				
				double dLMax = 0;
				for( int j=0;j<arShSplit.length();j++ ){
					Sheet shSplitted = arShSplit[j];
			
					Point3d arPtSh[] = shSplitted.profShape().getGripVertexPoints();				
					arPtSh = lnVxNew.orderPoints(arPtSh);
					if( arPtSh.length() < 2 )
						continue;
					
					double dShL = vxNew.dotProduct(arPtSh[arPtSh.length() - 1] - arPtSh[0]);
					if( dShL > dLMax ){
						sh = shSplitted;
						dLMax = dShL;
						ptSplit = arPtSh[0] + vxNew * dOptimizedLength;
					}
				}
				
				if( nNrOfLoops > 5 )
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
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
J.SA5>FP'\Q4]>A1C:!Y]1\TKA1116A`4444`%%%%`!1110`4444`?__9
`


#End