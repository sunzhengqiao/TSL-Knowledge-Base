#Version 8
#BeginDescription
Last modified by: Robert Pol (support.nl@hsbcad.com)
18.10.2018  -  version 1.04























1.5 28/03/2025 Change sequence number Author: Robert Pol
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl allows a beam to be cut at the shortest or longest point.
/// The catalog from this tsl can be set from DSP. The argument which is passed should be "DspToTsl; <catalog-name>"
/// </summary>

/// <insert>
/// Auto: Attach the tsl to a DSP detail
/// Manual: Only possible with nLog = 4
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.04" date="18.10.2018"></version>

/// <history>
/// AS - 1.00 - 15.12.2014 -	Pilot version, based on HSB-CutPerpendicular
/// AS - 1.01 - 16.12.2014 -	Ignore parallel cuts
/// AS - 1.02 - 15.06.2016 -	Find and remove the cuts from the list of cuts for that specific side. Do not remove invalid beams since they indicate a failure.
/// RP - 1.03 - 18.10.2018 -	Make new list of cuts for the other side after stretching the first side
/// RP - 1.04 - 18.10.2018 -	Still not working, refactoring code
/// </history>

_ThisInst.setSequenceNumber(-200);

//Script uses mm
double dEps = U(.001,"mm");

PropString sSeparator01(0, "", T("|Perpendicular cut|"));
sSeparator01.setReadOnly(true);
String arSCutType[] = {T("|Shortest point|"), T("|Longest point|"), T("|No cut|")};

PropString sCutBL(1, arSCutType, "     "+T("|Cut-type bottom/left|"));
PropString sCutTR(2, arSCutType, "     "+T("|Cut-type top/right|"));

PropString sBmCodeToCut(3, "", "     "+T("|Beamcode to cut|"));

if( _Map.hasString("DspToTsl") ){
	String sCatalogName = _Map.getString("DspToTsl");
	setPropValuesFromCatalog(sCatalogName);
	
	_Map.removeAt("DspToTsl", true);
}

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-CutPerpendicular");
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
		String strScriptName = "HSB_E-CutPerpendicular"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Entity lstEntities[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", true);
		setCatalogFromPropValues("MasterToSatellite");
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

if( sBmCodeToCut == "" ){
	eraseInstance();
	return;
}

// get selected element
Element el = _Element[0];
if( !el.bIsValid() ){
	eraseInstance();
	return;
}

String sList = sBmCodeToCut + ";";
sList.makeUpper();
String arSBCToCut[0];
int nTokenIndex = 0; 
int nCharacterIndex = 0;
while(nCharacterIndex < sList.length()-1){
	String sToken = sList.token(nTokenIndex);
	nTokenIndex++;
	if(sToken.length()==0){
		nCharacterIndex++;
		continue;
	}
	nCharacterIndex = sList.find(sToken,0);

	arSBCToCut.append(sToken);
}

if( _bOnDebug || _bOnElementConstructed || bManualInsert ){
	int nCutBL = arSCutType.find(sCutBL,0);
	int nCutTR = arSCutType.find(sCutTR,0);
	
	// coordinate system of this element
	CoordSys csEl = el.coordSys();
	Point3d ptEl = csEl.ptOrg();
	Vector3d vxEl = csEl.vecX();
	Vector3d vyEl = csEl.vecY();
	Vector3d vzEl = csEl.vecZ();

	// beams
	Beam arBm[] = el.beam();
	Beam arBmToCut[0];
	for( int i=0;i<arBm.length();i++ ){
		Beam bm = arBm[i];
		
		//Exclude beamcodes
		String sBmCode = bm.beamCode().token(0).makeUpper();
		sBmCode.trimLeft();
		sBmCode.trimRight();
		
		int bCutBeam = false;
		if( arSBCToCut.find(sBmCode)!= -1 ){
			bCutBeam = true;
		}
		else{
			for( int j=0;j<arSBCToCut.length();j++ ){
				String sBCToCut = arSBCToCut[j];
				String sBCToCutTrimmed = sBCToCut;
				sBCToCutTrimmed.trimLeft("*");
				sBCToCutTrimmed.trimRight("*");
				if( sBCToCutTrimmed == "" ){
					if( sBCToCut == "*" && sBmCode != "" )
						bCutBeam = true;
					else
						continue;
				}
				else{
					if( sBCToCut.left(1) == "*" && sBCToCut.right(1) == "*" && sBmCode.find(sBCToCutTrimmed, 0) != -1 )
						bCutBeam = true;
					else if( sBCToCut.left(1) == "*" && sBmCode.right(sBCToCut.length() - 1) == sBCToCutTrimmed )
						bCutBeam = true;
					else if( sBCToCut.right(1) == "*" && sBmCode.left(sBCToCut.length() - 1) == sBCToCutTrimmed )
						bCutBeam = true;
				}
			}
		}
		if( !bCutBeam )
			continue;

		arBmToCut.append(bm);
	}

	for( int i=0;i<arBmToCut.length();i++ )
	{
		Beam bmToCut = arBmToCut[i];
		Vector3d vxBm = bmToCut.vecX();
		
		if( vxBm.dotProduct(vxEl + vyEl) < 0 )
		{
			vxBm *= -1;
		}
		
		Line lnX(bmToCut.ptCen(), vxBm);
	
		Point3d arPtBm[] = bmToCut.envelopeBody(false, true).allVertices();
		Point3d arPtBmX[] = lnX.orderPoints(arPtBm);
		if( arPtBmX.length() < 2 ) continue;
		
		Point3d ptMin = arPtBmX[0];
		Point3d ptMax = arPtBmX[arPtBmX.length() - 1];

		AnalysedTool tools[] = bmToCut.analysedTools();
		AnalysedCut cuts[] = AnalysedCut().filterToolsOfToolType(tools);
		AnalysedCut cutsToUse[0];
		for( int j=0;j<cuts.length();j++ ){
			AnalysedCut aCut = cuts[j];
			Point3d arPtCut[] = aCut.bodyPointsInPlane();
			PLine plCut;
			//aCut.ptOrg().vis(j);
			
			plCut.createConvexHull(Plane(aCut.ptOrg(), aCut.normal()), arPtCut);
			double dArea = plCut.area();
			double dxCut = vxBm.dotProduct(aCut.normal());
			if (dArea < U(50)) {
				continue;
			}
			else if (abs(dxCut) < dEps) {
				continue;
			}
			else
			{
				cutsToUse.append(aCut);
			}
		}
		AnalysedCut finalCuts[0];		 
		int nIndCutClosestMin = AnalysedCut().findClosest(cutsToUse, ptMin);
		int nIndCutClosestMax = AnalysedCut().findClosest(cutsToUse, ptMax);
		
		int shortestLongest[0];
		

		if ( nIndCutClosestMax >= 0 && nCutTR != 2)
		{
			finalCuts.append(cutsToUse[nIndCutClosestMax]);
			shortestLongest.append(nCutTR);
		}
		if ( nIndCutClosestMin >= 0 && nCutBL != 2)
		{
			finalCuts.append(cutsToUse[nIndCutClosestMin]);
			shortestLongest.append(nCutBL);
		}
		
		Point3d finalPoints[0];
		for (int index=0;index<finalCuts.length();index++) 
		{ 
			AnalysedCut cut = finalCuts[index];
			Point3d ptOrgClosest = cut.ptOrg();
			
			Line xLine(bmToCut.ptCen(), vxBm * sign(vxBm.dotProduct(ptOrgClosest - bmToCut.ptCen())));
			Point3d arPtCut[] = cut.bodyPointsInPlane();			
			Point3d arPtCutX[] = xLine.orderPoints(arPtCut);
			if( arPtCutX.length() > 1 )
			{
				Point3d pointToUse = arPtCutX[0]; // shortest
				if (shortestLongest[index] == 1)
				{
					pointToUse = arPtCutX[arPtCutX.length() -1];
				}
				finalPoints.append(pointToUse);
			} 
		}
		Line realX(bmToCut.ptCen(), bmToCut.vecX());
		finalPoints = realX.orderPoints(finalPoints);
		for (int p=0;p<finalPoints.length();p++) 
		{ 
			Point3d finalPoint = finalPoints[p];
			finalPoint.vis(p);
			Vector3d xVector = vxBm * sign(vxBm.dotProduct(finalPoint - bmToCut.ptCen()));
			xVector.vis(finalPoint, p);
			 Cut cut(finalPoint, xVector);
			bmToCut.addToolStatic(cut, _kStretchOnInsert);
		}
		
	}
	
	eraseInstance();
}





#End
#BeginThumbnail









#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Change sequence number" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="3/28/2025 10:15:15 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End