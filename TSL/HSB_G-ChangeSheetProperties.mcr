#Version 8
#BeginDescription
Last modified by: Robert Pol (robert.pol@hsbcad.com)
11.12.2017  -  version 1.02















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl changes the position, thickness and material of the selected sheets
/// </summary>

/// <insert>
/// Select sheets
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <version  value="1.02" date="11.12.2017"></version>

/// <history>
/// AS - 1.00 - 02.06.2015 	- Pilot version
/// RP - 1.01 - 08.12.2017 	- Add Color
/// RP - 1.02 - 11.12.2017 	- Add Color change to int 
/// </history>

double dEps = Unit(0.1, "");

PropString sSeperator01(0, "", T("|Change sheeting|"));
sSeperator01.setReadOnly(true);
PropDouble dNewThickness(0, U(12.5), "     "+T("|Thickness|"));
PropString sNewMaterial(1, "Groen gips", "     "+T("|Material|"));
PropInt sNewColor(2, -1, "     "+T("|Color|"));

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_G-ChangeSheetProperties");
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
	PrEntity ssE(T("|Select one or more sheets|"), Sheet());
	if (ssE.go()) {
		Entity arEntSheet[] = ssE.set();
		for( int i=0;i<arEntSheet.length();i++ ){
			Sheet sh = (Sheet)arEntSheet[i];
			if( sh.bIsValid() )
				_Sheet.append(sh);
		}
	}
			
	return;
}

if( _Sheet.length() == 0 ){
	reportMessage(TN("|Invalid selection|!"));
	eraseInstance();
	return;
}

for( int i=0;i<_Sheet.length();i++ ){
	Sheet sh = _Sheet[i];
	Element el = sh.element();
	if( !el.bIsValid() )
		continue;
	
	CoordSys csEl = el.coordSys();
	Point3d ptEl = csEl.ptOrg();
	Vector3d vxEl = csEl.vecX();
	Vector3d vyEl = csEl.vecY();
	Vector3d vzEl = csEl.vecZ();
	
	double dWSh = sh.dD(vzEl);
	int nZnIndex = sh.myZoneIndex();
	int nSide = 1;
	if( nZnIndex < 0 )
		nSide *= -1;
	
	sh.setDH(dNewThickness);
	sh.setMaterial(sNewMaterial);
	if (sNewColor > 0)
		sh.setColor(sNewColor);
	sh.transformBy(-vzEl * nSide * (dWSh - dNewThickness));
}

eraseInstance();
return;
#End
#BeginThumbnail


#End