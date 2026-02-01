#Version 8
#BeginDescription
#Versions:
3.6 09/07/2025 Make sure it is working for purlin roofs Author: Robert Pol
3.5 10.11.2021 HSB-13424: use envelope bodies Author: Marsel Nakuci
Last modified by: Rognvald Cooper (support.uk@hsbcad.com)
16.12.2020 - version 3.04



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 6
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl creates blocking from a beam. The beam is split
/// </summary>

/// <insert>
/// Select a set of elements. The tsl is reinserted for each element.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>
/// #Versions:
//3.6 09/07/2025 Make sure it is working for purlin roofs Author: Robert Pol
// Version 3.5 10.11.2021 HSB-13424: use envelope bodies Author: Marsel Nakuci
/// <version  value="3.04" date="16.12.2020"></version>

/// <history>
/// AS - 1.00 - 04.04.2011 -	Pilot version
/// AS - 1.01 - 04.04.2011 -	Check splitted block again
/// AS - 1.02 - 04.04.2011 -	Swap vxTool if not aligned with vxBlocking
/// AS - 1.03 - 05.04.2011 -	Apply a stretchnot cut if the blocking is at the end.
/// AS - 1.04 - 11.04.2011 -	Add option to split at beamcode
/// AS - 1.05 - 02.05.2013 -	Add logging
/// AS - 1.06 - 19.06.2013 -	Cut at cover sheets
/// AS - 2.00 - 12.05.2015 -	Rename from HSB-BeamToBlocking to HSB_E-BeamToBlocking (FogBugzId 1273).
/// AS - 2.01 - 12.05.2015 -	Add support for walls (FogBugzId 1273).
/// AS - 2.02 - 12.05.2015 -	Add left and right stud as beams to split at (FogBugzId 1273).
/// DR - 2.03 - 19.04.2018 - 	<Gap> property added
/// DR - 2.04 - 01.05.2018 - 	Bug not splitting all parts solved
/// FA - 2.05 - 12.06.2018 -	Added a filter for the beamcodes, you are now able to enter multiple beamcodes with the separator.
/// FA - 3.00 - 13.07.2018 - Check if rafter is one of some beamtypes. Added Include and Exclude property.
/// HM - 3.01 - 30.07.2019 - 	Added Beamtypes
/// RP - 3.02 - 07.09.2020 - Change sequencenumber, should be executed after the ladder tsl
/// RP - 3.03 - 18.11.2020 - Add cantilever block as type
/// RP - 3.04 - 16.12.2020 - Add beam type: _kDakFrontEdge, _kLath
/// </history>

//Script uses mm
double dEps = U(.001,"mm");
int nLog = 0;

String incExcl[] = { T("|Include|"), T("|Exclude|")};

PropString sSeparator01(0, "", T("|Blocking|"));
sSeparator01.setReadOnly(true);
PropString sBmCodeBlocking(1, "KLO-01", "     "+T("|Beamcode blocking|"));
PropDouble dMinimalBlockingLength(0, U(100), "     "+T("|Minimal length blocking|"));
PropDouble dGap(1, 0, "     "+T("|Gap|"));

PropString sSeperator02(2, "", T("|Split beams|"));
sSeperator02.setReadOnly(true);

// filter beams with beamcode
PropString sBCRafter(3,"","     "+T("|Filter Beamcodes|"));
PropString sInclExcl(4, incExcl,"     "+ T("|Filter type|"), 1);
sInclExcl.setDescription(T("|Include: Only beams with the entered beamcode will be used.|") + TN("|Exclude: Beams with the entered beamcode won't be used.|"));

if( _Map.hasString("DspToTsl") ){
	String sCatalogName = _Map.getString("DspToTsl");
	setPropValuesFromCatalog(sCatalogName);
	
	_Map.removeAt("DspToTsl", true);
}

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-BeamToBlocking");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);


if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	// show the dialog if no catalog in use
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 ){
		if( _kExecuteKey != "" )
			reportMessage("\n"+scriptName() + TN("|Catalog key| ") + _kExecuteKey + T(" |not found|!"));
		showDialog();
	}
	else{
		setPropValuesFromCatalog(_kExecuteKey);
	}
	
	Element arSelectedElement[0];
	PrEntity ssEl(T("Select a set of elements"), Element());
	if( ssEl.go() ){
		arSelectedElement.append(ssEl.elementSet());
	}
	
	String strScriptName = "HSB_E-BeamToBlocking"; // name of the script
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Element lstElements[1];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	mapTsl.setInt("MasterToSatellite", true);
	setCatalogFromPropValues("MasterToSatellite");
	
	for( int e=0;e<arSelectedElement.length();e++ ){
		Element el = arSelectedElement[e];
		lstElements[0] = el;

		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	}
	
	eraseInstance();
	return;
}

int bOnManualInsert = false;
if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", true);
	}
	
	bOnManualInsert = true;
}
//return;
// Set the sequence number
_ThisInst.setSequenceNumber(1100);

if( _Element.length() == 0 ){
	reportNotice("\n" + scriptName() + TN("|No element selected|!"));
	eraseInstance();
	return;
}

Element el = _Element[0];
if( !el.bIsValid() ){
	reportNotice("\n" + scriptName() + TN("|Invalid element found|!"));
	eraseInstance();
	return;
}

int inclExclIndex = incExcl.find(sInclExcl);

// coordinate system of this element
CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
_Pt0 = ptEl;
// HSB-13424: include sheeting at rafter beamtypes
int arNBmTypeFrame[] = {
	_kDakCenterJoist,
	_kStud,
	_kSFStudLeft,
	_kSFStudRight,
	_kSFSupportingBeam,
	_kKingPost,
	_kKingStud,
	_kSFJackOverOpening,
	_kSFJackUnderOpening,
	_kDakLeftEdge,
	_kDakRightEdge,
	_kCantileverBlock,
	_kDakBackEdge,
	_kDakFrontEdge,
	_kLath,
	_kSheeting,
	_kBeam
};

Beam arBm[] = el.beam();
Beam arBmBlocking[0];
Beam arBmRafter[0];

//region filter
Entity entities[0];
for (int b=0;b<arBm.length();b++)
{		
	entities.append(arBm[b]);
}

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
//return;
if (sBmCodeBlocking.length() != 0)
{
	//Filter blockings
	Map filterBlockingsMap;
	filterBlockingsMap.setEntityArray(entities, false, "GenBeams", "GenBeams", "GenBeam");
	filterBlockingsMap.setString("BeamCode[]", sBmCodeBlocking);
	filterBlockingsMap.setInt("Exclude", 0);
	int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, "", filterBlockingsMap);
	if ( ! successfullyFiltered) {
		reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
		eraseInstance();
		return;
	}
	
	Entity filteredGenBeamEntities[] = filterBlockingsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
	for (int e = 0; e < filteredGenBeamEntities.length(); e++)
	{
		Beam bm = (Beam)filteredGenBeamEntities[e];
		if ( ! bm.bIsValid()) { continue; }
		
		arBmBlocking.append(bm);
	}
}

Map filterRaftersMap;
//Filter the rafters
filterRaftersMap.setEntityArray(entities, false, "GenBeams", "GenBeams", "GenBeam");
filterRaftersMap.setString("BeamCode[]", sBCRafter);
filterRaftersMap.setInt("Exclude", inclExclIndex);
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, "", filterRaftersMap);
if ( ! successfullyFiltered) {
	reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
}

Entity filteredGenBeamEntities[] = filterRaftersMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
for (int e = 0; e < filteredGenBeamEntities.length(); e++)
{
	Beam bm = (Beam)filteredGenBeamEntities[e];
	if ( ! bm.bIsValid()) { continue; }
	
	if (arNBmTypeFrame.find(bm.type()) != -1)
	{
		arBmRafter.append(bm);	
	}
}

//endregion

// order beams
for(int s1=1;s1<arBmRafter.length();s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		if( vxEl.dotProduct(arBmRafter[s11].ptCen() - arBmRafter[s2].ptCen()) < 0 ){
			arBmRafter.swap(s2, s11);
			s11=s2;
		}
	}
}

Sheet arShAll[] = el.sheet();
Sheet arShVert[0];
for (int i=0;i<arShAll.length();i++) {
	Sheet sh = arShAll[i];
	Vector3d vzSh = sh.vecZ();
	if (abs(abs(vzSh.dotProduct(vxEl)) - 1) > dEps )
		continue;
		
	arShVert.append(sh);
}

Beam arBmBlockingFromSplit[0];
for( int i=0;i<arBmBlocking.length();i++ ){
	Beam bmBlocking = arBmBlocking[i];
	
	Point3d ptBlocking = bmBlocking.ptCen();
	Vector3d vxBlocking = bmBlocking.vecX();
	Vector3d vzBlocking = vzEl;
	Vector3d vyBlocking = vzBlocking.crossProduct(vxBlocking);
	Plane pnBlockingY(ptBlocking, vyBlocking);
	
//	Body bdBlocking = bmBlocking.realBody(); 
	// HSB-13424
	Body bdBlocking = bmBlocking.envelopeBody(true,true); 
	bdBlocking.vis(4);//checkpoint
	
	int nRafterIndex = 0;//checkpoint
	
	for( int j=nRafterIndex;j<arBmRafter.length();j++ ){
		Beam bmRafter = arBmRafter[j];
		Body bdRafter = bmRafter.envelopeBody(false, false); 
		bdRafter.vis(3);//checkpoint
		
		if( bdRafter.hasIntersection(bdBlocking) )
		{
			bdRafter.vis(2);//checkpoint
			bdRafter.intersectWith(bdBlocking);
			if( bdRafter.volume() == 0 ){
				Body bdTmp = bdBlocking;
				bdTmp.intersectWith(bdRafter);
				bdRafter = bdTmp;
			}
			
			
			Line lnRafterX(bmRafter.ptCen(), bmRafter.vecX());
			
			if (!lnRafterX.hasIntersection(pnBlockingY))continue;
			Point3d ptTool = lnRafterX.intersect(pnBlockingY, 0);
			ptTool.vis(4);
			Vector3d vzTool = vzEl;
			Vector3d vyTool = bmRafter.vecX();
			Vector3d vxTool = vyTool.crossProduct(vzTool);
			if( vxTool.dotProduct(vxBlocking) < 0 ){
				vxTool *= -1;
				vyTool *= -1;
			}				
			
			ptTool.vis(6);
			vxTool.vis(ptTool, 1);
			vyTool.vis(ptTool, 3);
			vzTool.vis(ptTool, 150);//checkpoint
			
			Line lnX(bmRafter.ptCen(), vxTool);
			
			Point3d arPtBdRafter[] = bdRafter.allVertices();
			Point3d arPtBdRafterX[] = lnX.orderPoints(arPtBdRafter);

			if( arPtBdRafterX.length() < 1 ){
				if( nLog == 1 )
					reportMessage("\n"+i+T(": |Invalid body found in element| ")+el.number()+".");
				continue;
			}

			double dxTool = abs(vxTool.dotProduct(arPtBdRafterX[0] - arPtBdRafterX[arPtBdRafterX.length() - 1]));
//			double dxTool = bdRafter.lengthInDirection(vxTool);
//			dxTool = bdRafter.lengthInDirection(vxTool);
			if( dxTool < U(1) )
				continue;

			Point3d arPtBlocking[] = bmBlocking.envelopeBody(false, true).allVertices();
			Point3d arPtBlockingX[] = lnX.orderPoints(arPtBlocking);
			if( arPtBlockingX.length() < 1 ){
				if( nLog == 1 )
					reportMessage("\n"+i+T(": |Invalid body found in element| ")+el.number()+".");
				continue;
			}
			Point3d ptBlockingMin = arPtBlockingX[0];
			Point3d ptBlockingMax = arPtBlockingX[arPtBlockingX.length() - 1];
			ptBlockingMin.vis(1);ptBlockingMax.vis(3);
			
			//beam won't need to be split
			if( abs(vxTool.dotProduct(ptTool - ptBlockingMin)) < (.5 * bmRafter.dD(vxTool) + dMinimalBlockingLength) )
			{
				// check if also other side closer then allowed beam 
				if( abs(vxTool.dotProduct(ptTool - ptBlockingMax)) < (.5 * bmRafter.dD(vxTool) + dMinimalBlockingLength) )
				{ 
					// HSB-13424 delete beam
					bmBlocking.dbErase();
					continue;
				}
				Point3d ptCut = ptTool + vxTool * .5 * bmRafter.dD(vxTool);
				Body bdBm = bmBlocking.envelopeBody(true, true);
				for (int k=0;k<arShVert.length();k++) {
					Sheet sh = arShVert[k];
					Body bdSh = sh.envelopeBody();
					if (bdSh.hasIntersection(bdBm)) {
						if (abs(vxTool.dotProduct(ptCut - sh.ptCen())) < sh.dD(vxTool)) 
							ptCut += vxTool * vxTool.dotProduct((sh.ptCen() + vxTool * 0.5 * sh.dD(vxTool)) - ptCut);
					}
				}
				
				//add offset
				ptCut += vxTool * dGap * .5;
				ptCut.vis(6);
	
				Cut cut(ptCut, - vxTool);
				bmBlocking.addToolStatic(cut, _kStretchNot);
				bdRafter.vis(32);//checkpoint								
				continue;
			}
			if( abs(vxTool.dotProduct(ptTool - ptBlockingMax)) < (.5 * bmRafter.dD(vxTool) + dMinimalBlockingLength) )
			{
				if( abs(vxTool.dotProduct(ptTool - ptBlockingMin)) < (.5 * bmRafter.dD(vxTool) + dMinimalBlockingLength) )
				{ 
					// HSB-13424 delete beam
					bmBlocking.dbErase();
					continue;
				}
				Point3d ptCut = ptTool - vxTool * .5 * bmRafter.dD(vxTool);
				Body bdBm = bmBlocking.envelopeBody(true, true);
				for (int k=0;k<arShVert.length();k++) {
					Sheet sh = arShVert[k];
					Body bdSh = sh.envelopeBody();
					if (bdSh.hasIntersection(bdBm)) {
						if (abs(vxTool.dotProduct(ptCut - sh.ptCen())) < sh.dD(vxTool)) 
							ptCut += vxTool * vxTool.dotProduct((sh.ptCen() - vxTool * 0.5 * sh.dD(vxTool)) - ptCut);
					}
				}
				
				//add offset
				ptCut -= vxTool * dGap * .5;
				ptCut.vis(6);
				
				Cut cut(ptCut, vxTool);
				bmBlocking.addToolStatic(cut, _kStretchNot);
				bdRafter.vis(32);//checkpoint				
				continue;
			}
			
			//beam need to be split
			bmRafter.envelopeBody().vis(1);//checkpoint
			double rafterWidth = bmRafter.dD(vxTool);
			Beam bmNewBlock = bmBlocking.dbSplit(ptTool + vxTool * rafterWidth *.5, ptTool - vxTool * rafterWidth *.5);//aa
			arBmBlocking.append(bmNewBlock);
			arBmBlockingFromSplit.append(bmBlocking);
			arBmBlockingFromSplit.append(bmNewBlock);
				
			i--;
			nRafterIndex = j+1;
			break;
		}
		else
		{
			bdRafter.vis(1);//checkpoint
		}		
	}
	
//	bmBlocking.envelopeBody().vis(1);//checkpoint
	
	if( i > 100 )
	{
		reportError(T("|Error: safety lock.|"));
		eraseInstance();
		return;
	}
}
// HSB-13424 cleanup beams if dberased
for (int i=arBmBlocking.length()-1; i>=0 ; i--) 
{ 
	if(!arBmBlocking[i].bIsValid())
	{ 
		arBmBlocking.removeAt(i);
	}
}//next i
for (int i=arBmBlockingFromSplit.length()-1; i>=0 ; i--) 
{ 
	if(!arBmBlockingFromSplit[i].bIsValid())
	{ 
		arBmBlockingFromSplit.removeAt(i);
	}
}//next i

//work with blocking resulting from splits
//remove duplicateds or too small
for ( int i = 0; i < arBmBlockingFromSplit.length(); i++) 
{
	Beam currentBlocking = arBmBlockingFromSplit[i];
	if( currentBlocking.solidLength() < dMinimalBlockingLength + dGap )//blocking is too short
	{
		currentBlocking.dbErase();
		arBmBlockingFromSplit.removeAt(i);
		i--;
		continue;
	}
	
	for ( int j = i+1; j < arBmBlockingFromSplit.length(); j++) 
	{
		Beam nextBlocking = arBmBlockingFromSplit[j];
		if(currentBlocking==nextBlocking)//duplicated
		{ 
			arBmBlockingFromSplit.removeAt(j);
			j--;
		}
	}
}

//adding offset
for ( int i = 0; i < arBmBlockingFromSplit.length(); i++) {
	Beam bmBlocking = arBmBlockingFromSplit[i];
	Point3d blockingCenter = bmBlocking.ptCen();
	Vector3d vxBm = bmBlocking.vecX();
	
	Point3d ptCutLeft;
	int applyLeftCut = false;
	Beam beamsAtLeft[] = Beam().filterBeamsHalfLineIntersectSort(arBmRafter, blockingCenter, -vxBm);
	if(beamsAtLeft.length() > 0 )
	{ 
		Beam beamAtLeft = beamsAtLeft[0];
		Vector3d leftBeamVecD = beamAtLeft.vecD(vxBm);
		ptCutLeft = blockingCenter + vxBm * (vxBm.dotProduct(beamAtLeft.ptCen() - blockingCenter) + beamAtLeft.dD(vxBm) * .5 + dGap *.5);
		applyLeftCut = true;
	}
	
	Point3d ptCutRight;
	int applyRightCut = false;
	Beam beamsAtRight[] = Beam().filterBeamsHalfLineIntersectSort(arBmRafter, blockingCenter, vxBm);
	if(beamsAtRight.length() > 0)
	{ 
		Beam beamAtRight = beamsAtRight[0];
		Vector3d rightBeamVecD = beamAtRight.vecD(-vxBm);
		ptCutRight = blockingCenter + vxBm * (vxBm.dotProduct(beamAtRight.ptCen() - blockingCenter) - beamAtRight.dD(vxBm) * .5 - dGap *.5);
		applyRightCut = true;
	}
	
	//add cut if sheeting is found
	Body beamBody = bmBlocking.envelopeBody(true, true);
	for (int k=0;k<arShVert.length();k++)
	{
		Sheet sheet = arShVert[k];
		Point3d sheetCenter = sheet.ptCen();
		Body bodySheet = sheet.envelopeBody();
		if (bodySheet.hasIntersection(beamBody))
		{
			Vector3d sheetVecD = sheet.vecD(sheetCenter - blockingCenter);
			Point3d sheetSide = sheetCenter - sheetVecD * sheet.dD(sheetVecD) * .5;
			int sheetIsAtRight;
			(sheetVecD.dotProduct(vxBm) < 0) ? (sheetIsAtRight = true) : (sheetIsAtRight = false);
			
			if(sheetIsAtRight)
			{
				if(applyRightCut)
				{ 
					if (sheetVecD.dotProduct(ptCutRight - sheetSide) > 0)
						ptCutRight = sheetSide - sheetVecD * dGap * .5;
				}
				else
				{ 
					ptCutRight = sheetSide - sheetVecD * dGap * .5;
					applyRightCut = true;
				}
			}
			else
			{ 
				if(applyLeftCut)
				{ 
					if (sheetVecD.dotProduct(ptCutLeft - sheetSide) > 0)
						ptCutLeft = sheetSide - sheetVecD * dGap * .5;
				}
				else
				{
					ptCutLeft = sheetSide - sheetVecD * dGap * .5;
					applyLeftCut = true;
				}
			}
		}
	}
	
	if(applyLeftCut)
	{ 
		Cut cutLeft(ptCutLeft, - vxBm);
		bmBlocking.addToolStatic(cutLeft, true);
	}
	if(applyRightCut)
	{ 
		Cut cutRight(ptCutRight, vxBm);
		bmBlocking.addToolStatic(cutRight, true);
	}
	bmBlocking.envelopeBody().vis(2);
}

if (_bOnElementConstructed || bOnManualInsert || _bOnRecalc) {
	eraseInstance();
	return;
}


#End
#BeginThumbnail
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
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`*L1WUQ&@CW[XQT20!U'T!Z?A5>BAI,:=BWY]I+_K;=HF_O0MD?7:W^(J
M00^8NV"YBF7M'(0I'X-QGZ$U0HK*5&+V-%5DB_\`\>LR"XMGB(7&!D$J<C.#
MU_\`K5H,@FUBVOT</]I53(I&"21M?`[\[N,UCPWEQ`FR.5A'G)C/*GZJ>#4\
MFJ3/;K"J118!!>-<,0>HZ\#KP,=363P[OHS15UU1/<S)9R.&9)[D''!W(A]S
MT;Z=/KTK-EEDFD,DCEG/4FF45O3IQ@K(RG4<WJ%%%%69A1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
L0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`?_]E1
`



















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="294" />
        <int nm="BreakPoint" vl="295" />
        <int nm="BreakPoint" vl="466" />
        <int nm="BreakPoint" vl="261" />
        <int nm="BreakPoint" vl="225" />
        <int nm="BreakPoint" vl="239" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Make sure it is working for purlin roofs" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="7/9/2025 2:44:59 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13424: use envelope bodies" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="11/10/2021 5:07:09 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End