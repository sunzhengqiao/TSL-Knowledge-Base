#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
18.07.2017  -  version 2.10












#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 10
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl draws production details in paperspace
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <version  value="2.10" date="18.07.2017"></version>

/// <history>
/// AS - 1.00 - 06.07.2007 -	Pilot version
/// AS - 1.01 - 25.10.2007 -	Alphabetic order
/// AS - 1.02 - 31.10.2007 -	Spacing between vp, Don't draw outside vp
/// AS - 1.03 - 31.10.2007 -	Filter dumies, place posnum's
/// AS - 1.04 - 31.10.2007 - Add description under detail name
/// AS - 1.05 - 31.10.2007 - Place posnum in center of section of beam
/// AS - 1.06 - 27.11.2009 - Avoid overlapping text
/// AS - 1.07 - 08.12.2009 - Change layer from tooling to info
/// AS - 1.08 - 14.01.2010 - Add depth
/// AS - 1.09 - 13.10.2010 - Change transformation
/// AS - 1.10 - 13.10.2010 - Change orientation
/// AS - 1.11 - 14.10.2010 - Add dimensions
/// AS - 1.12 - 15.10.2010 - Change representation of position numbers
/// AS - 1.13 - 14.01.2011 - Replace realbody with envelopebody(true, true)
/// AS - 1.14 - 24.12.2012 - Add opening information
/// AS - 1.15 - 02.04.2013 - Add support for HSB_E-DetailName
/// AS - 1.16 - 05.04.2013 - Bufix on description.
/// AS - 2.00 - 24.06.2014 - Redesign tsl.
/// AS - 2.01 - 10.07.2014 - Add options to draw as block. Group properties.
/// AS - 2.02 - 15.07.2014 - Draw body as realbody
/// AS - 2.03 - 15.07.2014 - Search for blocknames to upper.
/// AS - 2.04 - 25.03.2015 - Add alignment property for blocks (FogBugzId 1028).
/// AS - 2.05 - 25.03.2015 - Add option to draw viewports on a specified layer (FogBugzId 1028).
/// AS - 2.06 - 07.04.2015 - Search for tsls is no longer case sensetive (FogBugzId 1090).
/// AS - 2.07 - 07.04.2015 - Only accept tsl if it contains detail info (FogBugzId 1090).
/// RP - 2.08 - 29.08.2016 - Add layer propertie for detailname.
/// RP - 2.09 - 30.08.2016 - Change default layer propertie for detailname.
/// AS - 2.10 - 18.07.2017 - Also get vSection if it was stored with a reference point.
/// </history>

//--------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                                   Properties
//

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};


String arSRepresentationType[] = {
	T("|As drawn|"),
	T("|As block, if available|"),
	T("|As block|"),
	T("|As block, browse if not available|")
};

String arSHorizontalAlignment[] = {
	T("|Left|"),
	T("|Center|"),
	T("|Right|")
};
String arSVerticalAlignment[] = {
	T("|Bottom|"),
	T("|Center|"),
	T("|Top|")
};
int arNAlignment[] = {
	1,
	0,
	-1
};

PropString sSeparatorFilter(5, "", T("|Filter|"));
sSeparatorFilter.setReadOnly(true);
PropString sShowOnlyThoseDetails(1,"", "     "+T("|Show only those details| (; ") + T("|seperated list|)"));
PropString sHideThoseDetails(2,"", "     "+T("|Hide those details| (; ")+T("|seperated list|)"));
PropString sFilterBCForSection(8,"", "     "+T("|Filter beams with beamcode for section|"));


PropString sSeparatorMatrix(6, "", T("|Matrix|"));
sSeparatorMatrix.setReadOnly(true);
PropDouble dBetweenDetH(1,U(100),"     "+T("|Distance to next detail| (")+T("|horizontal|)"));
PropDouble dBetweenDetV(2,U(100),"     "+T("|Distance to next detail| (")+T("|vertical|)")); 
PropDouble dBetweenVpH(3,U(10),"     "+T("|Distance to next viewport| (")+T("|horizontal|)"));
PropDouble dBetweenVpV(4,U(10),"     "+T("|Distance to next viewport| (")+T("|vertical|)")); 
PropInt nNrOfColumns(0, 3, "     "+T("|Number of columns|"));
PropInt nNrOfRows(1, 3, "     "+T("|Number of rows|"));


PropString sSeparatoStyle(7, "", T("|Style|"));
sSeparatoStyle.setReadOnly(true);
PropString sRepresentationType(9, arSRepresentationType, "     "+T("|Representation type|"));
PropString sBlockNamePrefix (10, "Detail-", "     "+T("|Prefix blockname|"));
PropString sHorizontalAlignment(11, arSHorizontalAlignment, "     "+T("|Horizontal alignment block|"));
PropString sVerticalAlignment(12, arSVerticalAlignment, "     "+T("|Vertical alignment block|"));
PropString sDimStyle(0, _DimStyles, "     "+T("|Dimension style|"));
PropString sDimStylePosnum(4, _DimStyles, "     "+T("|Dimension style position number|"));
PropDouble dScaleFactor(0, 1, "     "+T("|Scale|"));
PropString sShowPosnum(3, arSYesNo, "     "+T("|Show position number|"));
PropString sViewportLayer(13, "Defpoints", "     "+T("|Viewport layer|"));
PropString detailNameLayer(14, "", "     "+T("|Detailname layer|"));

double dOffsetFront = U(20);
double dOffsetBack = U(20);
double dBetweenLines = U(10);
/*
PropDouble dOffsetFront(5, U(20), T("|Offset to first dim-line at the front|"));
PropDouble dOffsetBack(6, U(20), T("|Offset to first dim-line at the back|"));
PropDouble dBetweenLines(7, U(10), T("|Distance between dim-lines|"));

PropString sDimZn1(5, arSYesNo, T("|Dimension zone 1|"));
PropString sDimZn2(6, arSYesNo, T("|Dimension zone 2|"));
PropString sDimZn3(7, arSYesNo, T("|Dimension zone 3|"));
PropString sDimZn4(8, arSYesNo, T("|Dimension zone 4|"));
PropString sDimZn5(9, arSYesNo, T("|Dimension zone 5|"));
PropString sDimZn6(10, arSYesNo, T("|Dimension zone 6|"));
PropString sDimZn7(11, arSYesNo, T("|Dimension zone 7|"));
PropString sDimZn8(12, arSYesNo, T("|Dimension zone 8|"));
PropString sDimZn9(13, arSYesNo, T("|Dimension zone 9|"));
PropString sDimZn10(14, arSYesNo, T("|Dimension zone 10|"));

// filter beams with beamcode
PropString sFilterBCForDim(15,"",T("Filter beams with beamcode for dimension"));
*/



//--------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                                     Insert
if( _bOnInsert ){
	_Viewport.append(getViewport(T("Select a viewport")));
	_Pt0 = getPoint(T("Select a point for first detail"));
	
	showDialogOnce("_Default");
	return;
}

if( _Viewport.length()==0 ){eraseInstance();return;}
Viewport vp = _Viewport[0];

// check if the viewport has hsb data
if (!vp.element().bIsValid())
	return;

// resolve properties
String sOnlyThoseDet = sShowOnlyThoseDetails+";";
String arSShowOnlyThoseDetails[0];
int nIndex = 0;
int nPositionInString = 0;
while( nPositionInString < sOnlyThoseDet.length() ){
	String sTokenDetail = sOnlyThoseDet.token(nIndex);
	nIndex++;
	
	if( sTokenDetail.length() == 0 ){
		nPositionInString++;
		continue;
	}
	nPositionInString = sOnlyThoseDet.find(sTokenDetail,0);
	
	arSShowOnlyThoseDetails.append(sTokenDetail);
}

String sHideThoseDet = sHideThoseDetails+";";
String arSHideThoseDetails[0];
nIndex = 0;
nPositionInString = 0;
while( nPositionInString < sHideThoseDet.length() ){
	String sTokenDetail = sHideThoseDet.token(nIndex);
	nIndex++;
	
	if( sTokenDetail.length() == 0 ){
		nPositionInString++;
		continue;
	}
	nPositionInString = sHideThoseDet.find(sTokenDetail,0);
	
	arSHideThoseDetails.append(sTokenDetail);
}

int nRepresentationType = arSRepresentationType.find(sRepresentationType,0);
int bShowPosnum = arNYesNo[arSYesNo.find(sShowPosnum,0)];

int nHorizontalAlignment = arNAlignment[arSHorizontalAlignment.find(sHorizontalAlignment,0)];
int nVerticalAlignment = arNAlignment[arSVerticalAlignment.find(sVerticalAlignment,0)];


int bDimZn1 = false;//arNYesNo[arSYesNo.find(sDimZn1,0)];
int bDimZn2 = false;//arNYesNo[arSYesNo.find(sDimZn2,0)];
int bDimZn3 = false;//arNYesNo[arSYesNo.find(sDimZn3,0)];
int bDimZn4 = false;//arNYesNo[arSYesNo.find(sDimZn4,0)];
int bDimZn5 = false;//arNYesNo[arSYesNo.find(sDimZn5,0)];
int bDimZn6 = false;//arNYesNo[arSYesNo.find(sDimZn6,0)];
int bDimZn7 = false;//arNYesNo[arSYesNo.find(sDimZn7,0)];
int bDimZn8 = false;//arNYesNo[arSYesNo.find(sDimZn8,0)];
int bDimZn9 = false;//arNYesNo[arSYesNo.find(sDimZn9,0)];
int bDimZn10 = false;//arNYesNo[arSYesNo.find(sDimZn10,0)];

/*
String sFBCDim = sFilterBCForDim + ";";
sFBCDim.makeUpper();
String arSFBCDim[0];
int nIndexBC = 0; 
int sIndexBC = 0;
while(sIndexBC < sFBCDim.length()-1){
	String sTokenBC = sFBCDim.token(nIndexBC);
	nIndexBC++;
	if(sTokenBC.length()==0){
		sIndexBC++;
		continue;
	}
	sIndexBC = sFBCDim.find(sTokenBC,0);
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSFBCDim.append(sTokenBC);
}
*/

String sFBCSection = sFilterBCForSection + ";";
sFBCSection.makeUpper();
String arSFBCSection[0];
int nIndexBC = 0; 
int sIndexBC = 0;
while(sIndexBC < sFBCSection.length()-1){
	String sTokenBC = sFBCSection.token(nIndexBC);
	nIndexBC++;
	if(sTokenBC.length()==0){
		sIndexBC++;
		continue;
	}
	sIndexBC = sFBCSection.find(sTokenBC,0);
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSFBCSection.append(sTokenBC);
}

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert();

//if( arSHideThoseDetails.length() > 0 && arSShowOnlyThoseDetails.length() > 0 ){
//	reportWarning(T("Only one of those filters can be used!"));
//}

Element el = vp.element();

GenBeam arGBm[] = el.genBeam();

// assign to info layer
assignToElementGroup(el, TRUE, 0, 'I');

double dHEl;
for( int i=-5;i<6;i++ ){
	dHEl += el.zone(i).dH();
}

Display dp(7);
dp.dimStyle(sDimStylePosnum, dScaleFactor);

Display dpDetailName(7);
dpDetailName = dp;
if (detailNameLayer != "");
	dpDetailName.layer(detailNameLayer);

Display dpViewport(7);
dpViewport.layer(sViewportLayer);

Display dpDim(-1);
dpDim.dimStyle(sDimStyle, dScaleFactor);

Display dpBox(255);
dpBox.lineType("Dot");

Display dpSection(-1);
dpSection.dimStyle(sDimStylePosnum, dScaleFactor);

Vector3d vNormal;
Point3d ptSection;
int bIsOpening;
double dSectionDepth = U(1);

String arSDrawnDetails[0];

TslInst arTslInst[] = el.tslInst();
TslInst arValidTslInst[0];
String arSDetailName[0];
String arSDetailDescription[0];

String arSScriptNameDetail[] = {
	"HSB-PRODUCTION DETAILS (MS)",
	"HSB_E-DETAILNAME",
	"HSB-DETAILINFO"
};

String arSBlockNamesToUpper[0];
for( int i=0;i<_BlockNames.length();i++ )
	arSBlockNamesToUpper.append(_BlockNames[i].makeUpper());

for( int i=0;i<arTslInst.length();i++ ){
	TslInst tsl = arTslInst[i];
	String sScriptName = tsl.scriptName().makeUpper();
	if( arSScriptNameDetail.find(sScriptName) != -1 ){
		
		if( sScriptName == arSScriptNameDetail[1] ){
			Map mapDetail = tsl.map();			
			String sDetName = mapDetail.getString("DetailName");
			arSDetailName.append(sDetName);
			arSDetailDescription.append(tsl.propString(2));
		}
		else if (sScriptName == arSScriptNameDetail[2]) {
			Map mapDetail = tsl.map();
			if (!mapDetail.hasString("DetailName"))
				continue;

			String sDetName = mapDetail.getString("DetailName");
			arSDetailName.append(sDetName);
			String sDescription = mapDetail.getString("Description");
			arSDetailDescription.append(sDescription);
		}
		else {
			arSDetailName.append(tsl.propString(0));
			arSDetailDescription.append(tsl.propString(1));
		}
		
		arValidTslInst.append(tsl);
	}
}

//Time to sort
for(int s1=1;s1<arSDetailName.length();s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		int bSort = arSDetailName[s11] < arSDetailName[s2];
		if( bSort ){
			arSDetailName.swap(s2, s11);
			arSDetailDescription.swap(s2, s11);
			arValidTslInst.swap(s2, s11);

			s11=s2;
		}
	}
}

for( int i=0;i<arValidTslInst.length();i++ ){
	TslInst tsl = arValidTslInst[i];

	String sDetailName = arSDetailName[i];
	String sDetailDescription = arSDetailDescription[i];
	if( arSHideThoseDetails.find(sDetailName) != -1 ){
		//Skip this detail
		continue;
	}
	
	if( arSShowOnlyThoseDetails.length() > 0 ){
		if( arSShowOnlyThoseDetails.find(sDetailName) == -1 ){
			//Skip this detail
			continue;
		}
	}
		
	double dSizeSection = tsl.propDouble(0);
	double dSectionDepth = tsl.propDouble(1);
	if( dSectionDepth < 1 )
		dSectionDepth = 1;
	
	if( arSDrawnDetails.find(sDetailName) ==  -1 ){
		Map mapTsl = tsl.map();
		if( mapTsl.hasVector3d("vSection") ){
			vNormal = mapTsl.getVector3d("vSection");
			ptSection = tsl.ptOrg();
			bIsOpening = mapTsl.getInt("IsOpening");
		}
		else if (mapTsl.hasPoint3d("vSection"))
		{
			Point3d ptNormal = mapTsl.getPoint3d("vSection");
			Point3d ptPosition = mapTsl.getPoint3d("Reference");
			vNormal = Vector3d(ptNormal - ptPosition);
			bIsOpening = mapTsl.getInt("IsOpening");
		}
		else if( mapTsl.hasPoint3d("Normal") ){
			Point3d ptNormal = mapTsl.getPoint3d("Normal");
			Point3d ptPosition = mapTsl.getPoint3d("Position");
			vNormal = Vector3d(ptNormal - ptPosition);
		}
		else{
			reportWarning(T("No vector set"));
			return;
		}
		ptSection = tsl.ptOrg();
		bIsOpening = mapTsl.getInt("IsOpening");
		vNormal.normalize();
			
		int nNrOfDetailsDrawn = arSDrawnDetails.length();
		int nIndexRow = int(nNrOfDetailsDrawn/nNrOfColumns);
		if( nIndexRow >= nNrOfRows ){
			reportWarning(T("\nNot all details are placed! Increase the amount of rows and/or columns!"));
			return;
		}
		int nIndexColumn = nNrOfDetailsDrawn;
		if( nNrOfDetailsDrawn >= nNrOfColumns ){
			double dIndex = ((1.0*nNrOfDetailsDrawn)/(1.0*nNrOfColumns) - int(nNrOfDetailsDrawn/nNrOfColumns));
			nIndexColumn = dIndex*nNrOfColumns + U(0.0001);
		}
		
		Point3d ptThisDetail = _Pt0 + _XW * nIndexColumn * (dBetweenDetH + dBetweenVpH) - _YW * nIndexRow * (dBetweenDetV + dBetweenVpV);
		double dTextHeight = dpDetailName.textHeightForStyle(sDetailName, sDimStyle);
		dpDetailName.draw( sDetailName, ptThisDetail + (_XW - _YW) * .25 * dTextHeight, _XW, _YW, 1, -1);
		dpDetailName.draw( sDetailDescription, ptThisDetail + (_XW - _YW) * .25 * dTextHeight, _XW, _YW, 1, -3.5);
		PLine plRect(_ZW);
		plRect.addVertex(ptThisDetail);
		plRect.addVertex(ptThisDetail - _YW * dBetweenDetV);
		plRect.addVertex(ptThisDetail - _YW * dBetweenDetV + _XW * dBetweenDetH);
		plRect.addVertex(ptThisDetail + _XW * dBetweenDetH);
		plRect.close();
		dpViewport.draw(plRect);
		
		int bShowAsDrawn = nRepresentationType == 0;
		int bShowAsBlock = nRepresentationType >= 2;

		String sBlockName = sBlockNamePrefix + sDetailName;
		String sBlockNameToUpper = sBlockName;
		sBlockNameToUpper.makeUpper();
		
		if (nRepresentationType == 1 ) { // Draw block. Show as drawn if the block is not loaded in the drawing
			if (arSBlockNamesToUpper.find(sBlockNameToUpper) != -1) {
				bShowAsDrawn = false;
				bShowAsBlock = true;
			}
			else {
				bShowAsDrawn = true;
				bShowAsBlock = false;
			}
		}
		
		if (bShowAsBlock) { // Draw block. Prompt user if its not loaded in this drawing
			bShowAsDrawn = false;
			
			Point3d ptCenter = ptThisDetail + .5 * (_XW * dBetweenDetH - _YW * dBetweenDetV);
			if( arSBlockNamesToUpper.find(sBlockNameToUpper) != -1 || nRepresentationType == 3){
				Block block(sBlockName);
				Point3d ptBlock = ptCenter - _XW * 0.4 * nHorizontalAlignment * dBetweenDetH - _YW * 0.4 * nVerticalAlignment * dBetweenDetV;
				dpSection.draw(block, ptBlock, _XW/dScaleFactor, _YW/dScaleFactor, _ZW/dScaleFactor);
			}
			else{
				dpSection.draw(sBlockName + T(" |not found|!"), ptCenter - _XW * 0.4 * dBetweenDetH - _YW * 0.4 * dBetweenDetV, _XW, _YW, 1, 1);
			}			
		}
		
		if (bShowAsDrawn) {				
			Body bdOutsideSection(ptSection, vNormal, el.vecZ().crossProduct(vNormal), el.vecZ(), U(25000), U(25000), U(25000));
			double dSectionY = dSizeSection;
			double dSectionZ = 2 * dHEl;
			if( (dBetweenDetH * dScaleFactor) < dSectionY ){
				dSectionY = dBetweenDetH * dScaleFactor;
			}
			if( (dBetweenDetV * dScaleFactor) < dSectionZ ){
				dSectionZ = dBetweenDetV * dScaleFactor;
			}
			//Body bdSection(ptSection, vNormal, el.vecZ().crossProduct(vNormal), el.vecZ(), dSectionDepth, dSectionY, dSectionZ);
				
			Point3d ptCenter = ptThisDetail + .5 * (_XW * dBetweenDetH - _YW * dBetweenDetV);
			
			CoordSys csEl = el.coordSys();
			
			int nSide = 1;
			if( vNormal.dotProduct(el.vecX() + el.vecY()) < 0 )
				nSide *= -1;
			if( bIsOpening )
				vNormal *= -1;
			
			Vector3d vyW = _ZW.crossProduct(el.vecX());
			vyW.normalize();
			Vector3d vzMS = _ZW;
			vzMS = vzMS.projectVector(Plane(ptSection, vyW));
			vzMS = vzMS.projectVector(Plane(ptSection, vNormal));
			vzMS.normalize();
			
			Vector3d vxPS = _XW * nSide;
			Vector3d vzPS = _ZW * nSide;
			Vector3d vyPS = vzPS.crossProduct(vxPS);
			
			CoordSys csMs2Ps;
			csMs2Ps.setToAlignCoordSys(
				ptSection, vzMS.crossProduct(vNormal), vzMS, vNormal, 
				ptCenter, vxPS/dScaleFactor, vyPS/dScaleFactor, vzPS/dScaleFactor
			);
			
			CoordSys csPs2Ms = csMs2Ps;
			csPs2Ms.invert();
			plRect.transformBy(csPs2Ms);
			Body bdSection(plRect, vNormal * dSectionDepth, 0);
			int bOnlyObjectsInSectionArea = false;
			if (bOnlyObjectsInSectionArea)
				bdSection = Body(ptSection, vNormal, el.vecZ().crossProduct(vNormal), el.vecZ(), dSectionDepth, dSectionY, dSectionZ);
			bdOutsideSection.subPart(bdSection);
			
			Line lnSection(ptSection, -el.vecZ().crossProduct(vNormal));
			//csMs2Ps = ms2ps;
			
			Point3d arPtZn0[0];
			Point3d arPtZn1[0];
			Point3d arPtZn2[0];
			Point3d arPtZn3[0];
			Point3d arPtZn4[0];
			Point3d arPtZn5[0];
			Point3d arPtZn6[0];
			Point3d arPtZn7[0];
			Point3d arPtZn8[0];
			Point3d arPtZn9[0];
			Point3d arPtZn10[0];
			
			PlaneProfile ppPosnum(CoordSys(_PtW, _XW, _YW, _ZW));
			for( int j=0;j<arGBm.length();j++ ){
				GenBeam gBm = arGBm[j];
				String sBmCode = gBm.beamCode().token(0);
				if( arSFBCSection.find(sBmCode) != -1 )
					continue;
				
				if( gBm.bIsDummy() )continue;
				
				int nZoneIndex = gBm.myZoneIndex();
				
				Body bdGBm = gBm.envelopeBody(true, true);
				bdGBm.subPart(bdOutsideSection);
				
				if( bdGBm.volume() == 0 )
					continue;
		//		PlaneProfile ppSection = bdGBm.getSlice(Plane(ptSection, vSection));
				
		//		PLine arPlSection[] = ppSection.allRings();
		//		int arBPlIsOpening[] = ppSection.ringIsOpening();
				
		//		Body bdSection;
		//		for( int k=0;k<arPlSection.length();k++ ){
		//			PLine pl = arPlSection[k];
		//			if( !arBPlIsOpening[k] ){
		//				bdSection.addPart(Body(pl, vSection));
		//				break;
		//			}
		//		}
				
				if( nZoneIndex == 0 ){
	//				if( arSFBCDim.find(sBmCode) == -1 )	
						arPtZn0.append(bdGBm.allVertices());
				}
				if( nZoneIndex == 1 )
					arPtZn1.append(bdGBm.allVertices());
				if( nZoneIndex == 2 )
					arPtZn2.append(bdGBm.allVertices());
				if( nZoneIndex == 3 )
					arPtZn3.append(bdGBm.allVertices());
				if( nZoneIndex == 4 )
					arPtZn4.append(bdGBm.allVertices());
				if( nZoneIndex == 5 )
					arPtZn5.append(bdGBm.allVertices());
				if( nZoneIndex == -1 )
					arPtZn6.append(bdGBm.allVertices());
				if( nZoneIndex == -2 )
					arPtZn7.append(bdGBm.allVertices());
				if( nZoneIndex == -3 )
					arPtZn8.append(bdGBm.allVertices());
				if( nZoneIndex == -4 )
					arPtZn9.append(bdGBm.allVertices());
				if( nZoneIndex == -5 )
					arPtZn10.append(bdGBm.allVertices());
				
				bdGBm.transformBy(csMs2Ps);
				
				if( bShowPosnum && ((Beam)gBm).bIsValid() ){
					Point3d ptCenterBody = gBm.envelopeBody().ptCen();//bdSection.ptCen();
					ptCenterBody.transformBy(csMs2Ps);
					if( ppPosnum.pointInProfile(ptCenterBody) == _kPointInProfile )
						ptCenterBody = ppPosnum.closestPointTo(ptCenterBody);
					
					String sText = gBm.posnum();
					double dLText = 1.5 * dp.textLengthForStyle(sText, sDimStyle);
					double dHText = 1.5 * dp.textHeightForStyle(sText, sDimStyle);
					Point3d ptBL = ptCenterBody - _XW * .5 * dLText - _YW * .5 * dHText;
					Point3d ptBR = ptCenterBody + _XW * .5 * dLText - _YW * .5 * dHText;
					Point3d ptTR = ptCenterBody + _XW * .5 * dLText + _YW * .5 * dHText;
					Point3d ptTL = ptCenterBody - _XW * .5 * dLText + _YW * .5 * dHText;
					PLine plText(ptBL, ptBR, ptTR, ptTL);
					plText.close();
					PlaneProfile ppThisPosnum(plText);
					ppPosnum.unionWith(	ppThisPosnum);
	//				ppPosnum.joinRing(plText, _kAdd);
					
					dpBox.draw(ppThisPosnum);
					dp.draw(sText, ptCenterBody, _XW, _YW, 0, 0);
				}
				
				dpSection.color(gBm.color());
				dpSection.draw(bdGBm);//, nDrawMode);				
			}
			
			Point3d ptDimFront = el.ptOrg() + el.vecZ() * dOffsetFront;
			Point3d arPtZn0X[] = lnSection.orderPoints(arPtZn0);
			if( bDimZn1 ){
				Point3d arPtZn1X[] = lnSection.orderPoints(arPtZn1);
				
				if( arPtZn1X.length() > 1 ){		
					Point3d arPtDim[] = {arPtZn0X[0], arPtZn1X[0]};
					Vector3d vxDim = -el.vecZ().crossProduct(vNormal);
					if( vxDim.dotProduct(-el.vecX() + el.vecY()) > 0 )
						vxDim *= -1;
					if( bIsOpening )
						vxDim *= -1;
					Vector3d vyDim = -el.vecZ();
					DimLine dimLine(ptDimFront, vxDim, vyDim);
					Dim dim( dimLine, arPtDim, "<>", "<>", _kDimPar, _kDimNone);
					dim.setDeltaOnTop(false);
					dim.transformBy(csMs2Ps);
					dim.setReadDirection(-_XW + _YW);
					dpDim.draw(dim);
					
					ptDimFront += el.vecZ() * dBetweenLines;
				}
			}
			if( bDimZn2 ){
				Point3d arPtZn2X[] = lnSection.orderPoints(arPtZn2);
				if( arPtZn2X.length() > 1 ){		
					Point3d arPtDim[] = {arPtZn0X[0], arPtZn2X[0]};
					Vector3d vxDim = -el.vecZ().crossProduct(vNormal);
					if( vxDim.dotProduct(-el.vecX() + el.vecY()) > 0 )
						vxDim *= -1;
					if( bIsOpening )
						vxDim *= -1;
					Vector3d vyDim = -el.vecZ();
					DimLine dimLine(ptDimFront, vxDim, vyDim);
					Dim dim( dimLine, arPtDim, "<>", "<>", _kDimPar, _kDimNone);
					dim.setDeltaOnTop(false);
					dim.transformBy(csMs2Ps);
					dim.setReadDirection(-_XW + _YW);
					dpDim.draw(dim);
					
					ptDimFront += el.vecZ() * dBetweenLines;
				}
			}
			if( bDimZn3 ){
				Point3d arPtZn3X[] = lnSection.orderPoints(arPtZn3);
				if( arPtZn3X.length() > 1 ){		
					Point3d arPtDim[] = {arPtZn0X[0], arPtZn3X[0]};
					Vector3d vxDim = -el.vecZ().crossProduct(vNormal);
					if( vxDim.dotProduct(-el.vecX() + el.vecY()) > 0 )
						vxDim *= -1;
					if( bIsOpening )
						vxDim *= -1;
					Vector3d vyDim = -el.vecZ();
					DimLine dimLine(ptDimFront, vxDim, vyDim);
					Dim dim( dimLine, arPtDim, "<>", "<>", _kDimPar, _kDimNone);
					dim.setDeltaOnTop(false);
					dim.transformBy(csMs2Ps);
					dim.setReadDirection(-_XW + _YW);
					dpDim.draw(dim);
					
					ptDimFront += el.vecZ() * dBetweenLines;
				}
			}
			if( bDimZn4 ){
				Point3d arPtZn4X[] = lnSection.orderPoints(arPtZn4);
				if( arPtZn4X.length() > 1 ){		
					Point3d arPtDim[] = {arPtZn0X[0], arPtZn4X[0]};
					Vector3d vxDim = -el.vecZ().crossProduct(vNormal);
					if( vxDim.dotProduct(-el.vecX() + el.vecY()) > 0 )
						vxDim *= -1;
					if( bIsOpening )
						vxDim *= -1;
					Vector3d vyDim = -el.vecZ();
					DimLine dimLine(ptDimFront, vxDim, vyDim);
					Dim dim( dimLine, arPtDim, "<>", "<>", _kDimPar, _kDimNone);
					dim.setDeltaOnTop(false);
					dim.transformBy(csMs2Ps);
					dim.setReadDirection(-_XW + _YW);
					dpDim.draw(dim);
					
					ptDimFront += el.vecZ() * dBetweenLines;
				}
			}
			if( bDimZn5 ){
				Point3d arPtZn5X[] = lnSection.orderPoints(arPtZn5);
				if( arPtZn5X.length() > 1 ){		
					Point3d arPtDim[] = {arPtZn0X[0], arPtZn5X[0]};
					Vector3d vxDim = -el.vecZ().crossProduct(vNormal);
					if( vxDim.dotProduct(-el.vecX() + el.vecY()) > 0 )
						vxDim *= -1;
					if( bIsOpening )
						vxDim *= -1;
					Vector3d vyDim = -el.vecZ();
					DimLine dimLine(ptDimFront, vxDim, vyDim);
					Dim dim( dimLine, arPtDim, "<>", "<>", _kDimPar, _kDimNone);
					dim.setDeltaOnTop(false);
					dim.transformBy(csMs2Ps);
					dim.setReadDirection(-_XW + _YW);
					dpDim.draw(dim);
					
					ptDimFront += el.vecZ() * dBetweenLines;
				}
			}
			
			Point3d ptDimBack = el.zone(-1).coordSys().ptOrg() - el.vecZ() * dOffsetFront;
			if( bDimZn6 ){
				Point3d arPtZn6X[] = lnSection.orderPoints(arPtZn6);
				if( arPtZn6X.length() > 1 ){		
					Point3d arPtDim[] = {arPtZn0X[0], arPtZn6X[0]};
					Vector3d vxDim = -el.vecZ().crossProduct(vNormal);
					if( vxDim.dotProduct(-el.vecX() + el.vecY()) > 0 )
						vxDim *= -1;
					if( bIsOpening )
						vxDim *= -1;
					Vector3d vyDim = -el.vecZ();
					DimLine dimLine(ptDimBack, vxDim, vyDim);
					Dim dim( dimLine, arPtDim, "<>", "<>", _kDimPar, _kDimNone);
					dim.setDeltaOnTop(true);
					dim.transformBy(csMs2Ps);
					dim.setReadDirection(-_XW + _YW);
					dpDim.draw(dim);
					
					ptDimBack -= el.vecZ() * dBetweenLines;
				}
			}
			if( bDimZn7 ){
				Point3d arPtZn7X[] = lnSection.orderPoints(arPtZn7);
				if( arPtZn7X.length() > 1 ){		
					Point3d arPtDim[] = {arPtZn0X[0], arPtZn7X[0]};
					Vector3d vxDim = -el.vecZ().crossProduct(vNormal);
					if( vxDim.dotProduct(-el.vecX() + el.vecY()) > 0 )
						vxDim *= -1;
					if( bIsOpening )
						vxDim *= -1;
					Vector3d vyDim = -el.vecZ();
					DimLine dimLine(ptDimBack, vxDim, vyDim);
					Dim dim( dimLine, arPtDim, "<>", "<>", _kDimPar, _kDimNone);
					dim.setDeltaOnTop(true);
					dim.transformBy(csMs2Ps);
					dim.setReadDirection(-_XW + _YW);
					dpDim.draw(dim);
					
					ptDimBack -= el.vecZ() * dBetweenLines;
				}
			}
			if( bDimZn8 ){
				Point3d arPtZn8X[] = lnSection.orderPoints(arPtZn8);
				if( arPtZn8X.length() > 1 ){		
					Point3d arPtDim[] = {arPtZn0X[0], arPtZn8X[0]};
					Vector3d vxDim = -el.vecZ().crossProduct(vNormal);
					if( vxDim.dotProduct(-el.vecX() + el.vecY()) > 0 )
						vxDim *= -1;
					if( bIsOpening )
						vxDim *= -1;
					Vector3d vyDim = -el.vecZ();
					DimLine dimLine(ptDimBack, vxDim, vyDim);
					Dim dim( dimLine, arPtDim, "<>", "<>", _kDimPar, _kDimNone);
					dim.setDeltaOnTop(true);
					dim.transformBy(csMs2Ps);
					dim.setReadDirection(-_XW + _YW);
					dpDim.draw(dim);
					
					ptDimBack -= el.vecZ() * dBetweenLines;
				}
			}
			if( bDimZn9 ){
				Point3d arPtZn9X[] = lnSection.orderPoints(arPtZn9);
				if( arPtZn9X.length() > 1 ){		
					Point3d arPtDim[] = {arPtZn0X[0], arPtZn9X[0]};
					Vector3d vxDim = -el.vecZ().crossProduct(vNormal);
					if( vxDim.dotProduct(-el.vecX() + el.vecY()) > 0 )
						vxDim *= -1;
					if( bIsOpening )
						vxDim *= -1;
					Vector3d vyDim = -el.vecZ();
					DimLine dimLine(ptDimBack, vxDim, vyDim);
					Dim dim( dimLine, arPtDim, "<>", "<>", _kDimPar, _kDimNone);
					dim.setDeltaOnTop(true);
					dim.transformBy(csMs2Ps);
					dim.setReadDirection(-_XW + _YW);
					dpDim.draw(dim);
					
					ptDimBack -= el.vecZ() * dBetweenLines;
				}
			}
			if( bDimZn10 ){
				Point3d arPtZn10X[] = lnSection.orderPoints(arPtZn10);
				if( arPtZn10X.length() > 1 ){		
					Point3d arPtDim[] = {arPtZn0X[0], arPtZn10X[0]};
					Vector3d vxDim = -el.vecZ().crossProduct(vNormal);
					if( vxDim.dotProduct(-el.vecX() + el.vecY()) > 0 )
						vxDim *= -1;
					if( bIsOpening )
						vxDim *= -1;
					Vector3d vyDim = -el.vecZ();
					
					DimLine dimLine(ptDimBack, vxDim, vyDim);
					Dim dim( dimLine, arPtDim, "<>", "<>", _kDimPar, _kDimNone);
					dim.setDeltaOnTop(true);
					dim.transformBy(csMs2Ps);
					dim.setReadDirection(-_XW + _YW);
					dpDim.draw(dim);
					
					ptDimBack -= el.vecZ() * dBetweenLines;
				}
			}
		}				
		//Add detail to list of drawn details.
		arSDrawnDetails.append(sDetailName);
	}
}
			












#End
#BeginThumbnail
















#End