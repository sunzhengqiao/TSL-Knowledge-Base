#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
18.02.2014  -  version 1.03








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
/// 
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.03" date="18.02.2014"></version>

/// <history>
/// AS - 1.00 - 25.02.2013 -	First revision
/// AS - 1.01 - 26.03.2013 -	Add opening dim
/// AS - 1.02 - 18.11.2014 -	Only dimension points at the side of the dimline.
/// AS - 1.03 - 18.11.2014 -	Keep number at bottom of child element
/// </history>

double dEps = Unit(0.01, "mm");

String arSDimStylesSorted[0];
arSDimStylesSorted.append(_DimStyles);
for(int s1=1;s1<arSDimStylesSorted.length();s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		String sA = arSDimStylesSorted[s11];
		sA.makeUpper();
		String sB = arSDimStylesSorted[s2];
		sB.makeUpper();
		if( sA < sB ){
			arSDimStylesSorted.swap(s2, s11);
			s11=s2;
		}
	}
}

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};


/// - Dimension object -
/// 
PropString sSeperator01(0, "", T("|Dimension Object|"));
sSeperator01.setReadOnly(true);
String arSObject[]={
	T("|Single elements|"),
	T("|Single elementnumbers|"),
	T("|Openings|")
};
PropString sObject(1,arSObject,"     "+T("|Dimension object|"));


/// - Positioning -
/// 
PropString sSeperator02(2, "", T("|Positioning|"));
sSeperator02.setReadOnly(true);
PropString sUsePSUnits(3, arSYesNo, "     "+T("|Offset in paperspace units|"),0);
//Used to set the distance to the element.
PropDouble dDimOff(0, U(15),"     "+T("|Offset dimension line|"));
PropDouble dTextOff(1, U(2),"     "+T("|Offset description|"));
//Used to set the dimension line to specific side of the element.
String arSPosition[] = {
	T("|Horizontal Bottom|"),
	T("|Horizontal Top|")
};
PropString sPosition(4, arSPosition,"     "+T("|Position|"));


/// - Style -
/// 
PropString sSeperator03(5, "", T("|Style|"));
sSeperator03.setReadOnly(true);
//Used to set the dimensioning layout.
PropString sDimStyle(6, arSDimStylesSorted,"     "+T("|Dimension style|"),1);
PropInt nColorDimension(0, 1, "     "+T("|Color|"));
PropString sDescription(7, "", "     "+T("|Description|"));

/// - Name and description -
/// 
PropString sSeperator04(8, "", T("|Name and description|"));
sSeperator04.setReadOnly(true);

PropInt nColorName(1, -1, "     "+T("|Default name color|"));
PropString sDimStyleName(9, arSDimStylesSorted, "     "+T("|Dimension style name|"));
PropString sInstanceDescription(10, "", "     "+T("|Extra description|"));


if( _bOnInsert ){
	  showDialogOnce();
	
	Viewport vp = getViewport(T("|Select a viewport|")); // select viewport
	_Viewport.append(vp);
	_Pt0 = getPoint(T("|Select a position|"));
	
	  return;
}

// do something for the last appended viewport only
if( _Viewport.length()==0 ){
	eraseInstance();
	return;
}


// Draw name
String sInstanceNameAndDescription = _ThisInst.scriptName();
if( sInstanceDescription.length() > 0 )
	sInstanceNameAndDescription += (" - "+sInstanceDescription);

Display dpName(nColorName);
dpName.dimStyle(sDimStyleName);
dpName.draw(sInstanceNameAndDescription, _Pt0, _XW, _YW, 1, 2);


Viewport vp = _Viewport[0];
CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
double dVpScale = ps2ms.scale();

Element el = vp.element();
// check if the viewport has hsb data
if( !el.bIsValid() )
	return;
	
ElementMulti elMulti = (ElementMulti)el;
if( !elMulti.bIsValid() )
	return;


int nObject = arSObject.find(sObject,0);
int bUsePSUnits = arNYesNo[arSYesNo.find(sUsePSUnits,1)];
double dOffsetDim = dDimOff;
if( bUsePSUnits )
	dOffsetDim *= dVpScale;
double dOffsetText = dTextOff;
if( bUsePSUnits )
	dOffsetText *= dVpScale;
int nPosition = arSPosition.find(sPosition, 0);


CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Vector3d vxps = _XW;
Vector3d vyps = _YW;
Vector3d vzps = _ZW;
Vector3d vx = vxps;
vx.transformBy(ps2ms);
vx.normalize();
Vector3d vy = vyps;
vy.transformBy(ps2ms);
vy.normalize();
Vector3d vz = vzps;
vz.transformBy(ps2ms);
vz.normalize();

Line lnX(ptEl, vx);
Line lnY(ptEl, vy);

LineSeg lnSegME = elMulti.segmentMinMax();
Point3d arPtLnSegMultiEl[] = {
	lnSegME.ptStart(),
	lnSegME.ptEnd()
};
Point3d arPtLnSegMultiElX[] = lnX.orderPoints(arPtLnSegMultiEl);
Point3d arPtLnSegMultiElY[] = lnY.orderPoints(arPtLnSegMultiEl);
if( arPtLnSegMultiElX.length() * arPtLnSegMultiElY.length() == 0 )
	return;
Point3d ptLeft = arPtLnSegMultiElX[0];
Point3d ptRight = arPtLnSegMultiElX[arPtLnSegMultiElX.length() - 1];
Point3d ptBottom = arPtLnSegMultiElY[0];
Point3d ptTop = arPtLnSegMultiElY[arPtLnSegMultiElY.length() - 1];

Point3d ptBL = ptLeft + vy * vy.dotProduct(ptBottom - ptLeft);
Point3d ptBR = ptRight + vy * vy.dotProduct(ptBottom - ptRight);
Point3d ptTR = ptRight + vy * vy.dotProduct(ptTop - ptRight);
Point3d ptTL = ptLeft + vy * vy.dotProduct(ptTop - ptLeft);

Display dp(nColorDimension);
dp.dimStyle(sDimStyle, dVpScale);


Point3d ptRef = ptBL;
Point3d ptOffsettedRef = ptBL - vy * dOffsetDim;
if( nPosition == 1 ) {
	ptRef = ptTL;
	ptOffsettedRef = ptTL + vy * dOffsetDim;
}

Point3d ptDescription = ptOffsettedRef - vx * dOffsetText;

PlaneProfile ppMultiElement(csEl);
Opening arOp[0];
Point3d arPtDim[0];
SingleElementRef arSingleElementRefs[] = elMulti.singleElementRefs();
for( int i=0;i<arSingleElementRefs.length();i++ ){
	SingleElementRef singleElementRef = arSingleElementRefs[i];
	
	// Find openings.
	Entity arEnt[] = singleElementRef.entitiesFromMultiElementBuild();
	for( int j=0;j<arEnt.length();j++ ){
		Opening op = (Opening)arEnt[j];
		if( op.bIsValid() )
			arOp.append(op);			
	}
	
	LineSeg lnSegSERef = singleElementRef.segmentMinMax();
		
	Point3d ptElMid = (lnSegSERef.ptStart() + lnSegSERef.ptEnd())/2;
	
	if( nObject == 0 ){
		PlaneProfile ppEl = el.profNetto(0);
		PlaneProfile p = ppEl;
		p.transformBy(ms2ps);
		p.vis(1);
		
		PLine arPlEl[] = ppEl.allRings();
		int arBRingIsOpening[] = ppEl.ringIsOpening();
		for (int j=0;j<arPlEl.length();j++) {
			if (arBRingIsOpening[j])
				continue;
				
			PLine pl = arPlEl[j];
			Point3d arPtPl[] = pl.vertexPoints(true);
			
			for (int k=0;k<arPtPl.length();k++) {
				Point3d pt = arPtPl[k];
				
				if (abs(vyEl.dotProduct(ptRef - pt)) < U(500))
					arPtDim.append(pt);
			}
		}
		
		if (arPtDim.length() == 0) {
			arPtDim.append(lnSegSERef.ptStart());
			arPtDim.append(lnSegSERef.ptEnd());
		}
	}
	if( nObject == 1 ){
		int bKeepNumberAtBottomOfChildElement = true;
		if (bKeepNumberAtBottomOfChildElement)
			ptOffsettedRef = singleElementRef.coordSys().ptOrg() - singleElementRef.coordSys().vecY() * dOffsetDim;
		
		Point3d ptSingleElNumber = ptElMid + vyEl * vyEl.dotProduct(ptOffsettedRef - ptElMid);
		
		ptSingleElNumber.transformBy(ms2ps);
		dp.draw(singleElementRef.number(), ptSingleElNumber, _XW, _YW, 0, 0);
	}
}

PlaneProfile p = ppMultiElement;
p.transformBy(ms2ps);
p.vis();

if( nObject == 2 ){// Openings
	for( int i=0;i<arOp.length();i++ )
		arPtDim.append(arOp[i].plShape().vertexPoints(true));
}

if( nPosition == 0 )
	arPtDim = Line(ptBottom, vx).projectPoints(arPtDim);
else
	arPtDim = Line(ptTop, vx).projectPoints(arPtDim);
	
if( arPtDim.length() > 0 ){
	DimLine dimLine(ptOffsettedRef, vx, vy);
	Dim dim(dimLine, arPtDim, "<>", "<>", _kDimPar, _kDimNone);
	dim.setDeltaOnTop(true);
	dim.transformBy(ms2ps);
	dp.draw(dim);
}

//Draw description
if( nObject == 1 || arPtDim.length() > 0 ){
	ptDescription.transformBy(ms2ps);
	dp.draw(sDescription, ptDescription, _XW, _YW, -1, 0);
}








#End
#BeginThumbnail



#End