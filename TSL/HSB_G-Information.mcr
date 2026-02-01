#Version 8
#BeginDescription
Last modified by: Anno Sportel (support.nl@hsbcad.com)
31.10.2019 - version 2.29
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 29
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl displays the amount of an element which is filled in at the element definition. Its displayed at the layout.
/// </summary>

/// <insert>
/// Select a viewport
/// </insert>

/// <remark Lang=en>
/// 'Tsl instance': It searches for tsls with the specified name. The found tsls are queried for a property (int) with the name 'Quantity'
/// </remark>

/// <version  value="2.29" date="31.10.2019"></version>

/// <history>
/// AS - 1.00 - 25.10.2009 -	Pilot version
/// AS - 1.01 - 24.08.2010 -	Add property to select what info has to be shown
/// AS - 1.02 - 24.08.2010 -	Extend info-list
/// AS - 1.03 - 21.09.2010 -	Only show name of floorgroup. Hide domain
/// AS - 1.04 - 22.03.2011 -	Add square meters
/// AS - 1.05 - 28.04.2011 -	Add square meters without opening
/// AS - 1.06 - 22.09.2011 -	Add post- and prefix
/// AS - 1.07 - 22.09.2011 -	Add information
/// AS - 1.08 - 26.09.2011 -	Add 'Tsl instance'
/// AS - 1.09 - 02.11.2011 -	Projectnumber and element type + number added.
/// AS - 1.10 - 03.02.2012 -	Improve calculation of square meters.
/// AS - 1.11 - 03.02.2012 -	Use realBody io envelopeBody
/// AS - 1.12 - 23.02.2012 -	Change names of groups
/// AS - 2.00 - 08.03.2012 -	Prepare for localizer
/// AS - 2.01 - 27.04.2012 -	Use plEnvelope for element area
/// AS - 2.02 - 21.05.2012 -	Update elementname discriptions
/// AS - 2.03 - 22.05.2012 -	Add option to show the main beam section of the element
/// AS - 2.04 - 08.06.2012 -	Dont draw info if sInfo is empty
/// AS - 2.05 - 19.06.2012 -	Add filter. Calculate log area based on beams
/// AS - 2.06 - 13.11.2012 -	Add tile/counter lath distribution
/// AS - 2.07 - 28.01.2013 -	Add nail spacing.
/// AS - 2.08 - 05.04.2013 -	Add weight.
/// AS - 2.09 - 14.05.2013 -	Add option to rotate text.
/// AS - 2.10 - 31.05.2013 -	Extent filter options
/// AS - 2.11 - 26.03.2014 -	Show length for tilelaths.
/// AS - 2.12 - 31.03.2014 -	Use profile of beams for element outline.
/// AS - 2.13 - 23.04.2014 -	Ignore all filters if they are all empty.
/// AS - 2.14 - 07.05.2014 -	Add option to show projectnumber/elementnumber, show area with precision
/// AS - 2.15 - 20.06.2014 -	Base element area on profbrutto.
/// AS - 2.16 - 10.12.2014 -	Add area and volume for specified zone.
/// AS - 2.17 - 22.04.2015 -	Add area and volume as precentage to the element (openings subtracted) (FogBugzId 587).
/// AS - 2.18 - 17.09.2015 -	Correct volume as percentage (FogBugzId 587).
/// AS - 2.19 - 14.09.2016 -	Only use entities from element for element area calculation if the area of profBRutto(0) is zero.
/// RP - 2.20 - 20.12.2016 -	Add Description (defenition) as info option.
/// RP - 2.21 - 27.06.2017 -	Add Replicator Amount.
/// RP - 2.22 - 27.06.2017 -	Added 1 to Replicator Amount.
/// RP - 2.23 - 06.11.2017 -	Do area percentage check on filtered genbeams instead of all
/// RP - 2.24 - 14.11.2017 -	Name Filter not working.
/// DR - 2.25 - 14.12.2017	- "Area as percentage" value fixed
/// RP - 2.26 - 26.02.2018	- Added custom property with contenformat tsl
/// AS - 2.27 - 30.07.2018	- Always take beams into account for area calculation.
/// RP - 2.28 - 01.10.2019	- Replicator amount corrected
/// AS - 2.29 - 31/10/2019	- Added name by zone
/// </history>

/// - Filter -
///
int arBExclude[] = {_kNo, _kYes};
String arSFilterType[] = {T("|Include|"), T("|Exclude|")};

PropString sSeperator01(8, "", T("|Filter|"));
sSeperator01.setReadOnly(true);
PropString sFilterType(9, arSFilterType, "     "+T("|Filter type|"));
PropString sFilterBC(10,"","     "+T("|Filter beams with beamcode|"));
PropString sFilterName(11,"","     "+T("|Filter beams and sheets with name|"));
PropString sFilterLabel(12,"","     "+T("|Filter beams and sheets with label|"));
PropString sFilterMaterial(13,"","     "+T("|Filter beams and sheets with material|"));
PropString sFilterHsbID(14,"","     "+T("|Filter beams and sheets with hsbID|"));
PropString sFilterZone(15, "", "     "+"Filter zones");


PropString sSeperator02(0, "", T("|Information to display|"));
sSeperator02.setReadOnly(true);

String arSInfo[] = {
	T("|Number|"),			//0
	T("|Code|"),			//1
	T("|Information|"),		//2
	T("|Sub type|"),		//3
	T("|Quantity|"),			//4
	T("|Number & Quantity|"),			//5
	T("|Floor group|"),		//6
	T("|Top group|"),		//7
	T("|Extrusion profile|"),//8
	T("|Element area|"),	//9
	T("|Element area openings subtracted|"),	//10
	T("|Material from zone|"), //11
	T("|Tsl instance|"), //12
	T("|Project number|"), //13
	T("|Element type & number|"), //14
	T("|Main beamsection|"), // 15
	T("|Tile lath distribution|"), //16
	T("|Counter batten distribution|"), //17
	T("|Nail spacing|"), //18
	T("|Weight|"), //19
	T("|Project number|/")+T("|Element number|"), //20
	T("|Area|"), //21
	T("|Volume|"), //22
	T("|Area as percentage|"), //23
	T("|Volume as percentage|"), //24
	T("|Description|"), //25
	T("|Replicator amount|"), //26
	T("|Name from Zone|") //27
};	

PropString sShow(1, arSInfo, "     "+T("|Show|"));
PropString sPrefix(2, "", "     "+T("|Prefix|"));
PropString sPostfix(3, "", "     "+T("|Postfix|"));
PropString propCustom(16, "",  "     "+T("|Custom Property|"));
propCustom.setDescription(T("|Specify a custom property e.g. @(Material) or @(PropertySet.Property)|"));
PropInt nToken(0, 0, "     "+T("|Token index|"));
PropString sToken(4, ";", "     "+T("|Token|"));

int arNZone[] = {0,1,2,3,4,5,6,7,8,9,10};
PropInt nZone(1, arNZone, "     "+T("|Zone index|"));

PropString sTslName(7, "", "     "+T("|Name tsl instance|"));
PropInt nPrec(2, 2, "     "+T("|Precision|"));

PropString sSeperator03(5, "", T("|Presentation|"));
sSeperator03.setReadOnly(true);
PropString sDimStyle(6,_DimStyles, "     "+T("Dimension style"));
PropDouble dTxtHeight(0, U(100), "     "+T("|Textheight|"));

String arSTypeCode[0];		String arSTypeName[0];
arSTypeCode.append("09");	arSTypeName.append("Wand");
arSTypeCode.append("12");	arSTypeName.append("Wand");
arSTypeCode.append("26");	arSTypeName.append("Knieschot");
arSTypeCode.append("20");	arSTypeName.append("Zijwang");
arSTypeCode.append("06");	arSTypeName.append("Vloer");
arSTypeCode.append("24");	arSTypeName.append("Platdak");
arSTypeCode.append("19");	arSTypeName.append("Dak dakkapel");
arSTypeCode.append("16");	arSTypeName.append("Element");
arSTypeCode.append("28");	arSTypeName.append("Goot");
arSTypeCode.append("31");	arSTypeName.append("Rekwerk");

PropDouble dRotation(1, 0, "     "+T("|Rotation|"));
dRotation.setFormat(_kAngle);

if( _bOnInsert ){
	_Viewport.append(getViewport(T("Select a viewport")));
	_Pt0 = getPoint(T("Select a point"));
	showDialog();
	return;
}

if( _Viewport.length() == 0 ){eraseInstance(); return; }

Viewport vp = _Viewport[0];

// check if the viewport has hsb data
if (!vp.element().bIsValid()) return;
CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert();


Element el = vp.element();
CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Plane pnElZ(ptEl, vzEl);

double dHEl = vzEl.dotProduct(el.zone(10).coordSys().ptOrg() - el.zone(-10).coordSys().ptOrg());

Display dp(-1);
dp.dimStyle(sDimStyle);
dp.textHeight(dTxtHeight);

int nZn = nZone;
if( nZn > 5 )
	nZn = 5 - nZn;

int nInfo = arSInfo.find(sShow);

int bAllFiltersEmpty = true;

String sFBC = sFilterBC + ";";
sFBC.makeUpper();
String arSExcludeBC[0];
int nIndexBC = 0; 
int sIndexBC = 0;
while(sIndexBC < sFBC.length()-1){
	String sTokenBC = sFBC.token(nIndexBC);
	nIndexBC++;
	if(sTokenBC.length()==0){
		sIndexBC++;
		continue;
	}
	sIndexBC = sFBC.find(sTokenBC,0);
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSExcludeBC.append(sTokenBC);
}
if( arSExcludeBC.length() > 0 )
	bAllFiltersEmpty = false;

String sFName = sFilterName + ";";
sFName.makeUpper();
String arSExcludeName[0];
int nIndexName = 0; 
int sIndexName = 0;
while(sIndexName < sFName.length()-1){
	String sTokenName = sFName.token(nIndexName);
	nIndexName++;
	if(sTokenName.length()==0){
		sIndexName++;
		continue;
	}
	sIndexName = sFName.find(sTokenName,0);

	arSExcludeName.append(sTokenName);
}
if( arSExcludeName.length() > 0 )
	bAllFiltersEmpty = false;
	
String sFLabel = sFilterLabel + ";";
sFLabel.makeUpper();
String arSExcludeLbl[0];
int nIndexLabel = 0; 
int sIndexLabel = 0;
while(sIndexLabel < sFLabel.length()-1){
	String sTokenLabel = sFLabel.token(nIndexLabel);
	nIndexLabel++;
	if(sTokenLabel.length()==0){
		sIndexLabel++;
		continue;
	}
	sIndexLabel = sFLabel.find(sTokenLabel,0);

	arSExcludeLbl.append(sTokenLabel);
}
if( arSExcludeLbl.length() > 0 )
	bAllFiltersEmpty = false;

String sFMaterial = sFilterMaterial + ";";
sFMaterial.makeUpper();
String arSExcludeMat[0];
int nIndexMaterial = 0; 
int sIndexMaterial = 0;
while(sIndexMaterial < sFMaterial.length()-1){
	String sTokenMaterial = sFMaterial.token(nIndexMaterial);
	nIndexMaterial++;
	if(sTokenMaterial.length()==0){
		sIndexMaterial++;
		continue;
	}
	sIndexMaterial = sFMaterial.find(sTokenMaterial,0);

	arSExcludeMat.append(sTokenMaterial);
}
if( arSExcludeMat.length() > 0 )
	bAllFiltersEmpty = false;
	
String sFHsbId = sFilterHsbID + ";";
sFHsbId.makeUpper();
String arSExcludeHsbId[0];
int nIndexHsbId = 0; 
int sIndexHsbId = 0;
while(sIndexHsbId < sFHsbId.length()-1){
	String sTokenHsbId = sFHsbId.token(nIndexHsbId);
	nIndexHsbId++;
	if(sTokenHsbId.length()==0){
		sIndexHsbId++;
		continue;
	}
	sIndexHsbId = sFHsbId.find(sTokenHsbId,0);

	arSExcludeHsbId.append(sTokenHsbId);
}
if( arSExcludeHsbId.length() > 0 )
	bAllFiltersEmpty = false;

int arNFilterZone[0];
int nIndex = 0;
String sZones = sFilterZone + ";";
int nTokenIndex = 0;
String sZn = sZones.token(nTokenIndex);
while( sZn != "" ){
	int nZn = sZn.atoi();
	if( nZn == 0 && sZn != "0" ){
		nTokenIndex++;
		sZn = sZones.token(nTokenIndex);
		continue;
	}
	if( nZn > 5 )
		nZn = 5 - nZn;	
	arNFilterZone.append(nZn);
	
	nTokenIndex++;
	sZn = sZones.token(nTokenIndex);
}
if( arNFilterZone.length() > 0 )
	bAllFiltersEmpty = false;

int bExlude = arBExclude[arSFilterType.find(sFilterType,1)];

//Beam arBmAll[] = el.beam();
GenBeam arGBmAll[] = el.genBeam();
GenBeam arGBm[0];
Beam arBm[0];
Sheet arSh[0];
for(int i=0;i<arGBmAll.length();i++){
	GenBeam gBm = arGBmAll[i];
	int bIsFiltered = false;
	
	//Exclude dummies
	if( gBm.bIsDummy() )
		continue;
	
	if( !bIsFiltered ){
		//Exlude zones
		int nZnIndex = gBm.myZoneIndex();
		if( arNFilterZone.find(nZnIndex) != -1 )
			bIsFiltered = true;
	}
	
	if( !bIsFiltered ){
		//Exclude name
		String sName = gBm.name().makeUpper();
		sName.trimLeft();
		sName.trimRight();
		if( arSExcludeMat.find(sName)!= -1 ){
			bIsFiltered = true;
		}
		else{
			for( int j=0;j<arSExcludeName.length();j++ ){
				String sExclName = arSExcludeName[j];
				String sExclNameTrimmed = sExclName;
				sExclNameTrimmed.trimLeft("*");
				sExclNameTrimmed.trimRight("*");
				if( sExclNameTrimmed == "" )
					continue;
				if (sExclNameTrimmed == sName)
					bIsFiltered = true;
				else if( sExclName.left(1) == "*" && sExclName.right(1) == "*" && sName.find(sExclNameTrimmed, 0) != -1 )
					bIsFiltered = true;
				else if( sExclName.left(1) == "*" && sName.right(sExclName.length() - 1) == sExclNameTrimmed )
					bIsFiltered = true;
				else if( sExclName.right(1) == "*" && sName.left(sExclName.length() - 1) == sExclNameTrimmed )
					bIsFiltered = true;
			}
		}
	}

	if( !bIsFiltered ){
		//Exclude labels
		String sLabel = gBm.label().makeUpper();
		sLabel.trimLeft();
		sLabel.trimRight();
		if( arSExcludeLbl.find(sLabel)!= -1 ){
			bIsFiltered = true;
		}
		else{
			for( int j=0;j<arSExcludeLbl.length();j++ ){
				String sExclLbl = arSExcludeLbl[j];
				String sExclLblTrimmed = sExclLbl;
				sExclLblTrimmed.trimLeft("*");
				sExclLblTrimmed.trimRight("*");
				if( sExclLblTrimmed == "" )
					continue;
				if( sExclLbl.left(1) == "*" && sExclLbl.right(1) == "*" && sLabel.find(sExclLblTrimmed, 0) != -1 )
					bIsFiltered = true;
				else if( sExclLbl.left(1) == "*" && sLabel.right(sExclLbl.length() - 1) == sExclLblTrimmed )
					bIsFiltered = true;
				else if( sExclLbl.right(1) == "*" && sLabel.left(sExclLbl.length() - 1) == sExclLblTrimmed )
					bIsFiltered = true;
			}
		}
	}
	
	if( !bIsFiltered ){
		//Exclude material
		String sMaterial = gBm.material().makeUpper();
		sMaterial.trimLeft();
		sMaterial.trimRight();
		if( arSExcludeMat.find(sMaterial)!= -1 ){
			bIsFiltered = true;
		}
		else{
			for( int j=0;j<arSExcludeMat.length();j++ ){
				String sExclMat = arSExcludeMat[j];
				String sExclMatTrimmed = sExclMat;
				sExclMatTrimmed.trimLeft("*");
				sExclMatTrimmed.trimRight("*");
				if( sExclMatTrimmed == "" )
					continue;
				if( sExclMat.left(1) == "*" && sExclMat.right(1) == "*" && sMaterial.find(sExclMatTrimmed, 0) != -1 )
					bIsFiltered = true;
				else if( sExclMat.left(1) == "*" && sMaterial.right(sExclMat.length() - 1) == sExclMatTrimmed )
					bIsFiltered = true;
				else if( sExclMat.right(1) == "*" && sMaterial.left(sExclMat.length() - 1) == sExclMatTrimmed )
					bIsFiltered = true;
			}
		}
	}
	
	if( !bIsFiltered ){
		//Exclude hsbId
		String sHsbId = gBm.hsbId().makeUpper();
		sHsbId.trimLeft();
		sHsbId.trimRight();
		if( arSExcludeHsbId.find(sHsbId)!= -1 ){
			bIsFiltered = true;
		}
		else{
			for( int j=0;j<arSExcludeHsbId.length();j++ ){
				String sExclHsbId = arSExcludeHsbId[j];
				String sExclHsbIdTrimmed = sExclHsbId;
				sExclHsbIdTrimmed.trimLeft("*");
				sExclHsbIdTrimmed.trimRight("*");
				if( sExclHsbIdTrimmed == "" )
					continue;
				if( sExclHsbId.left(1) == "*" && sExclHsbId.right(1) == "*" && sHsbId.find(sExclHsbIdTrimmed, 0) != -1 )
					bIsFiltered = true;
				else if( sExclHsbId.left(1) == "*" && sHsbId.right(sExclHsbId.length() - 1) == sExclHsbIdTrimmed )
					bIsFiltered = true;
				else if( sExclHsbId.right(1) == "*" && sHsbId.left(sExclHsbId.length() - 1) == sExclHsbIdTrimmed )
					bIsFiltered = true;
			}
		}
	}

	if( !bIsFiltered ){
		//Exclude beamcodes
		String sBmCode = gBm.beamCode().token(0).makeUpper();
		sBmCode.trimLeft();
		sBmCode.trimRight();
		
		if( arSExcludeBC.find(sBmCode)!= -1 ){
			bIsFiltered = true;
		}
		else{
			for( int j=0;j<arSExcludeBC.length();j++ ){
				String sExclBC = arSExcludeBC[j];
				String sExclBCTrimmed = sExclBC;
				sExclBCTrimmed.trimLeft("*");
				sExclBCTrimmed.trimRight("*");
				if( sExclBCTrimmed == "" )
					continue;
				if( sExclBC.left(1) == "*" && sExclBC.right(1) == "*" && sBmCode.find(sExclBCTrimmed, 0) != -1 )
					bIsFiltered = true;
				else if( sExclBC.left(1) == "*" && sBmCode.right(sExclBC.length() - 1) == sExclBCTrimmed )
					bIsFiltered = true;
				else if( sExclBC.right(1) == "*" && sBmCode.left(sExclBC.length() - 1) == sExclBCTrimmed )
					bIsFiltered = true;
			}
		}
	}
	
	if( !bAllFiltersEmpty && (bIsFiltered && bExlude) )
		continue;
	
	if( !bAllFiltersEmpty && (!bIsFiltered && !bExlude) )
		continue;
	
	arGBm.append(gBm);
	
	Beam bm = (Beam)gBm;	
	if(bm.bIsValid() )
		arBm.append(bm);
	
	Sheet sh = (Sheet)gBm;	
	if(sh.bIsValid() )
		arSh.append(sh);
}

String sInfo;
if( nInfo == 0 ){
	sInfo = el.number();
}
if( nInfo == 1 ){
	sInfo = el.code();
}
if( nInfo == 2 ){
	sInfo = el.information();
}
if( nInfo == 3 ){
	sInfo = el.subType();
}
if( nInfo == 4 ){
	sInfo = el.quantity();
}
if( nInfo == 25 ){
	sInfo = el.definition();
}
if( nInfo == 5 ){
	sInfo = el.number() + " - " + el.quantity();
}
if( nInfo == 6 ){
	Group grpEl = el.elementGroup();
	sInfo = grpEl.namePart(1);
}
if( nInfo == 7 ){
	Group grpEl = el.elementGroup();
	sInfo = grpEl.namePart(0);
}
if( nInfo == 8 ){
	int arNValidTypes[] = {
		_kStud,
		_kSFStudLeft,
		_kSFStudRight,
		_kDakCenterJoist,
		_kDakLeftEdge,
		_kDakRightEdge
	};
//	Beam arBm[] = el.beam();
	for( int i=0;i<arBm.length();i++ ){
		Beam bm = arBm[i];
		if( arNValidTypes.find(bm.type()) != -1 ){
			sInfo = bm.extrProfile();
			break;
		}
	}
}
double dElementAreaForPercentage;
if( nInfo == 9 || nInfo == 10 || nInfo == 23 || nInfo == 24){
	double dArea;// = el.plEnvelope().area();
	PlaneProfile ppEl = el.profBrutto(0);
	
	for( int i=0;i<arBm.length();i++ ){
		Beam bm = arBm[i];
		PlaneProfile ppThisBm = bm.envelopeBody().shadowProfile(Plane(ptEl, bm.vecD(vzEl)));
		ppThisBm.shrink(-U(5));
		ppEl.unionWith(ppThisBm);			
	}
	ppEl.shrink(U(5));
	PlaneProfile ppElPs = ppEl;
	ppElPs.transformBy(ms2ps);
	ppElPs.vis(3);
	
	PLine arPlEl[] = ppEl.allRings();
	PLine plElOutline;
	int arBRingIsOpening[] = ppEl.ringIsOpening();
	for( int i=0;i<arPlEl.length();i++ ){
		if( arBRingIsOpening[i] )
			continue;
		
		PLine pl = arPlEl[i];
		if( pl.area() > plElOutline.area() )
			plElOutline = pl;
	}
	PLine q = plElOutline;
	q.transformBy(ms2ps);
	q.vis(1);
	dArea = plElOutline.area();

	ElementLog elLog = (ElementLog)el;
	if( elLog.bIsValid() && (nInfo == 10 || nInfo == 23 || nInfo == 24) ){
		PlaneProfile ppBm(csEl);
		for( int i=0;i<arBm.length();i++ ){
			Beam bm = arBm[i];
			ppBm.unionWith(bm.envelopeBody(true,true).getSlice(Plane(bm.ptCen(),vzEl)));
		}
		ppBm.shrink(-U(5));
		ppBm.shrink(U(5));
		
		dArea = ppBm.area();
	}
	else if( nInfo == 10 || nInfo == 23 || nInfo == 24){
		Opening arOp[] = el.opening();
		for( int i=0;i<arOp.length();i++ ){
			Opening op = arOp[i];
			
			PLine pl = op.plShape();
			dArea -= pl.area();
			pl.transformBy(ms2ps);
			pl.vis();
			
			OpeningLog opLog = (OpeningLog)op;
			if( !opLog.bIsValid() )
				continue;
			
			dArea -= opLog.dGapLeft() * opLog.height();
			dArea -= opLog.dGapRight() * opLog.height();
			dArea -= opLog.dGapTop() * opLog.width();
//			dArea -= opLog.dGapBottom() * opLog.width();


		}
	}

/*		
	GenBeam arGBm[] = el.genBeam();
	
	PlaneProfile ppEl = el.profBrutto(0);
	if( nInfo == 9 )
		ppEl = el.profNetto(0);
		
	ppEl.vis(2);	
	for( int i=0;i<arGBm.length();i++ ){
		GenBeam gBm = arGBm[i];
		ppEl.unionWith(gBm.realBody().shadowProfile(pnElZ));
		//ppEl.vis(3);	
	}
	double d = ppEl.area();
	ppEl.shrink(U(-50));
	ppEl.shrink(U(50));
	ppEl.vis(1);

	double dArea = ppEl.area();
*/
//	if (nInfo == 23 || nInfo == 24) {
//		dElementAreaForPercentage = dArea;
//	}
	if (nInfo == 23)
	{
		dElementAreaForPercentage = el.plEnvelope().area();
	}
	else if (nInfo == 24)
	{
		
		dElementAreaForPercentage = dArea;
	}
	else{	
		dArea /= 1000000;
		sInfo.formatUnit(dArea, 2, nPrec);
	}
	//sInfo += "m²";
}
if( nInfo == 11 ){
	GenBeam arGBm[] = el.genBeam(nZn);
	
	String arSMaterial[0];
	for( int i=0;i<arGBm.length();i++ ){
		GenBeam gBm = arGBm[i];
		String sMaterial = gBm.material();
		
		if( arSMaterial.find(sMaterial) == -1 )
			arSMaterial.append(sMaterial);
	}
	
	for( int i=0;i<arSMaterial.length();i++ ){
		String sMaterial = arSMaterial[i];
		if( sInfo.length() == 0 )
			sInfo += sMaterial;
		else
			sInfo += (" - "+sMaterial);
	}
}
if( nInfo == 27 ){
	GenBeam arGBm[] = el.genBeam(nZn);
	
	String arSName[0];
	for( int i=0;i<arGBm.length();i++ ){
		GenBeam gBm = arGBm[i];
		String sNamez = gBm.name();
		
		if( arSName.find(sNamez) == -1 )
			arSName.append(sNamez);
	}
	
	for( int i=0;i<arSName.length();i++ ){
		String sNamez = arSName[i];
		if( sInfo.length() == 0 )
			sInfo = sNamez;
		else
			sInfo = (" - "+sNamez);
	}
}

if( nInfo == 12 ){
	int nQty = 0;
	TslInst arTsl[] = el.tslInst();
	for( int i=0;i<arTsl.length();i++ ){
		TslInst tsl = arTsl[i];
		if( tsl.scriptName() == sTslName ){
			if( tsl.hasPropInt(T("|Quantity|")) )
				nQty += tsl.propInt(T("|Quantity|"));
			else
				nQty++;
		}
	}
	
	if( nQty == 0 )
		return;
	
	sInfo = nQty;
}
if( nInfo == 13 ){
	sInfo = projectNumber();
}
if( nInfo == 14 ){
	String sNumber = el.number();
	String sElemType = sNumber.token(1, "-");
	String sElType = sElemType.left(2);
	String sElName = sElemType.token(1, "_");
	int nTypeIndex = arSTypeCode.find(sElType);
	
	if( nTypeIndex > -1 )
		sInfo = arSTypeName[nTypeIndex] + " " + sElName;
}
if( nInfo == 15 ){
	sInfo = el.dBeamHeight() + "x" + el.dBeamWidth();
}
if( nInfo == 16 ){
	ElementRoof elRf = (ElementRoof)el;
	if( !elRf.bIsValid() )
		return;
	sInfo = elRf.tileLathDistribution();
}
if( nInfo == 17 ){
	ElementRoof elRf = (ElementRoof)el;
	if( !elRf.bIsValid() )
		return;
	sInfo = elRf.counterLathDistribution();
}
if( nInfo == 18 ){
	NailLine arNailLine[] = el.nailLine(nZn);
	String arSSpacing[0];
	for( int i=0;i<arNailLine.length();i++ ){
		NailLine nl = arNailLine[i];
		double dSpacing = nl.spacing();
		String sSpacing;
		sSpacing.formatUnit(dSpacing, 2, 0);
		if( arSSpacing.find(sSpacing) == -1 )
			arSSpacing.append(sSpacing);
	}
	
	for( int i=0;i<arSSpacing.length();i++ ){
		String sSpacing = arSSpacing[i];
		if( i>0 )
			sSpacing = " - "+sSpacing;
		sInfo += sSpacing;
	}
}
if( nInfo == 19 ){
	Map mapIO;
	Map mapEntities;
	for (int e=0;e<arGBm.length();e++)
	    mapEntities.appendEntity("Entity", arGBm[e]);
	mapIO.setMap("Entity[]",mapEntities);
	TslInst().callMapIO("hsbCenterOfGravity", mapIO);
	double dWeight = mapIO.getDouble("Weight");
	
	sInfo.formatUnit(dWeight, 2, nPrec);
}
if( nInfo == 20 ){
	String sProjectNumber = projectNumber();
	String sElementNumber = el.number();
	
	while( sElementNumber.length() < 3 )
		sElementNumber = "0" + sElementNumber;
	
	sInfo = sProjectNumber + "/" + sElementNumber;
}
if( nInfo == 26 ){
	if (el.subMapXKeys().find("Hsb_production") != -1 && el.subMapX("Hsb_production").hasMap("Hsb_replicator"))
	{
		Map replicaMap = el.subMapX("Hsb_production").getMap("Hsb_replicator").getMap("Replica[]");
		int amount = 1;
		int amountMirrored = 0;
		for (int m = 0; m < replicaMap.length(); m++)
		{
			Map replica = replicaMap.getMap(m);
			int isMirrored = replica.getInt("IsMirrored");
			isMirrored ? amountMirrored ++: amount ++;
		}
		
		sInfo = T("|Amount|: ") + amount + T(" |Amount mirrored|: ") + amountMirrored;
	}
	else if (el.subMapXKeys().find("Hsb_Production") != -1 || el.subMapX("Hsb_Production").hasString("OriginalNumber"))
		sInfo = T("|Amount|: ") + 0 + T(" |Main element|: " + el.subMapX("Hsb_Production").getString("OriginalNumber"));
	else
		sInfo = T("|Amount|: ") + el.quantity();
}
if (nInfo == 21 || nInfo == 22 || nInfo == 23 || nInfo == 24) {
	int nZoneForArea = nZn;
	if (nZn == -5)
		nZoneForArea = 0;
	
	PlaneProfile ppGBm(csEl);
	for( int i=0;i<arGBm.length();i++ ){
		GenBeam gBm = arGBm[i];
		if (gBm.myZoneIndex() != nZoneForArea)
			continue;
			
		if (_bOnDebug)
		{
			Body b = gBm.envelopeBody();
			b.transformBy(ms2ps);
			b.vis(1);
		}
		
		PlaneProfile ppThisBm = gBm.envelopeBody(true, true).getSlice(Plane(gBm.ptCen(), vzEl));
		
		// Blow up and rotate this profile before joining it. This to avoid issues while joining the profiles.
		CoordSys csRotate;
		csRotate.setToRotation(1, vzEl, _PtW);
		ppThisBm.transformBy(csRotate);
		ppThisBm.shrink(-U(1));

		ppGBm.unionWith(ppThisBm);			
	}
	
	// Invert blow up and rotation.
	CoordSys csRotate;
	csRotate.setToRotation(-1, vzEl, _PtW);
	ppGBm.transformBy(csRotate);
	ppGBm.shrink(U(1));
	
	PlaneProfile p = ppGBm;
	p.transformBy(ms2ps);
	p.vis();
	
	// Calculate the area for the insulation if it is zone -5
	double dArea;
	if (nZn == -5) {
		// Get the biggest ring
		PLine arPlGBm[] = ppGBm.allRings();
		int arBRingIsOpening[] = ppGBm.ringIsOpening();
		
		double dAreaBiggestRing = -1;
		PLine plBiggestRing;
		for (int i=0;i<arPlGBm.length();i++) {
			if (arBRingIsOpening[i])
				continue;
			
			PLine pl = arPlGBm[i];
			double dThisArea = pl.area();
			
			if (dThisArea > dAreaBiggestRing) {
				dAreaBiggestRing = dThisArea;
				plBiggestRing = pl;
			}
		}
		
		PlaneProfile ppZone(csEl);
		if (dAreaBiggestRing < 0)
			ppZone = el.profBrutto(0);
		else
			ppZone.joinRing(plBiggestRing, _kAdd);
		
		Opening arOp[] = el.opening();
		for (int i=0;i<arOp.length();i++) {
			Opening op = arOp[i];
			if (ppZone.pointInProfile(Body(op.plShape(), vzEl).ptCen()) == _kPointInProfile)
				ppZone.joinRing(op.plShape(), _kSubtract);
		}
				
		dArea = ppZone.area() - ppGBm.area();
	}
	else{
		dArea = ppGBm.area();
	}
	
	double dVolume = dArea * el.zone(nZoneForArea).dH();
	double dInfo = dArea/1000000;
	if (nInfo == 22) 
		dInfo = dVolume/1000000000;
	else if (nInfo == 23) 	
		dInfo = dArea/dElementAreaForPercentage * 100; //%
	else if (nInfo == 24)
		dInfo = dVolume/(dElementAreaForPercentage * dHEl) * 100; //%

	sInfo.formatUnit(dInfo, 2, nPrec);
}

if (propCustom.length() > 0)
 { 
 	Map contentFormatMap;
	Entity ent = (Entity)el;
	contentFormatMap.setString("FormatContent", propCustom);
	contentFormatMap.setEntity("FormatEntity", ent);
	int succeeded = TslInst().callMapIO("HSB_G-ContentFormat", "", contentFormatMap);
	if (!succeeded)
		reportNotice(T("|Please make sure the tsl HSB_G-ContentFormat is loaded in the drawing|"));
	
	sInfo = contentFormatMap.getString("FormatContent");
}


if( sToken.length() > 0 )
	sInfo = sInfo.token(nToken, sToken);

Vector3d vxInfo = _XW.rotateBy(dRotation, _ZW);
Vector3d vyInfo = _YW.rotateBy(dRotation, _ZW);
if( sInfo != "" )
	dp.draw( sPrefix + sInfo + sPostfix, _Pt0, vxInfo, vyInfo, 1, 1);
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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End