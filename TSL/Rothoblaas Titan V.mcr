#Version 8
#BeginDescription
version value="1.01" date=24.oct.2018" author="david.rueda@hsbcad.com

EN
Rothoblaas TITAN V angle bracket for panels.
When insertion is not possible, tool will inform with red/green colors if plate(s) are or not in proper contact with panels, or if minimal edge offset is not accomplished.

DACH
Rothoblaas TITAN V Scheerwinkel für BSP.
Die korrekte Position des Winkels bezüglich Randabstand und Ausrichtung wird mittels Farbcode (rot/grün) dargestellt.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
//region History
/// <History>
///<version value="1.01" date=24.oct.2018" author="david.rueda@hsbcad.com"> Thimbnail updated  </version>
/// <version value="1.0" date="22oct2018" author="david.rueda@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// Rothoblaas TITAN V angle bracket for panels.
/// </summary>
//endregion

//region constants and OPM
U(1, "mm");
double dEps = U(.1);
int nDoubleIndex, nStringIndex, nIntIndex;
String sDoubleClick = "TslDoubleClick";
int bDebug = _bOnDebug;
// read a potential mapObject defined by hsbDebugController
{
	MapObject mo("hsbTSLDev" , "hsbTSLDebugController");
		if (mo.bIsValid()) { Map m = mo.map(); for (int i = 0; i < m.length(); i++) if (m.getString(i) == scriptName()) { bDebug = true; 	break; }}
	if (bDebug)reportMessage("\n" + scriptName() + " starting " + _ThisInst.handle());
}
String sDefault = T("|_Default|");
String sLastInserted = T("|_LastInserted|");
String category = T("|General|");
String sNoYes[] = { T("|No|"), T("|Yes|")};
String sError2PanelsNeeded = "\n" + scriptName() + ": " + T("|2 panels are needed|\n");
double dLength = U(240), dThickness = U(4), dBaseHeight = U(83), dVerticalHeight = U(120);
String sNailsAnker4x60 = T("Anker |nails| Ø4x60"), sScrewsVGS11x150 = T("VGS |screws| Ø11X150"), sScrewsVGS11x200 = T("VGS |screws| Ø11X200");

String sTypes[0], sScrewTypesFemale[0], sNailTypesFemale[0], sNailTypesMale[0];
int nScrewSetsFemale [0], nNailSetsFemale[0], nNailSetsMale[0];
double dScrewLengths[] = { U(200), U(150), U(200), U(150)};

sTypes.append(T("F1-|Full nailing|"));
sScrewTypesFemale.append(sScrewsVGS11x200); sNailTypesFemale.append(sNailsAnker4x60); sNailTypesMale.append(sNailsAnker4x60);
nScrewSetsFemale.append(5); nNailSetsFemale.append(30); nNailSetsMale.append(36);
sTypes.append(T("F1-|Partial nailing|"));
sScrewTypesFemale.append(sScrewsVGS11x150); sNailTypesFemale.append(sNailsAnker4x60); sNailTypesMale.append(sNailsAnker4x60);
nScrewSetsFemale.append(5); nNailSetsFemale.append(24); nNailSetsMale.append(24);

sTypes.append(T("F2/3-|Full nailing|"));
sScrewTypesFemale.append(sScrewsVGS11x200); sNailTypesFemale.append(sNailsAnker4x60); sNailTypesMale.append(sNailsAnker4x60);
nScrewSetsFemale.append(2); nNailSetsFemale.append(30); nNailSetsMale.append(36);

sTypes.append(T("F2/3-|Partial nailing|"));
sScrewTypesFemale.append(sScrewsVGS11x150); sNailTypesFemale.append(sNailsAnker4x60); sNailTypesMale.append(sNailsAnker4x60);
nScrewSetsFemale.append(2); nNailSetsFemale.append(24); nNailSetsMale.append(24);

String sTypeName = T("|Type|");
PropString sType(nStringIndex++, sTypes, sTypeName);
sType.setDescription(sTypes[0] + ": 36 Anker nails Ø4x60 (vertical plate) + 5 VGS screws Ø11x200 + 30 Anker nails Ø4x60 (base plate)" +
"\nF1-" + T("|Partial nailing|") + ": 24 Anker nails Ø4x60 (vertical plate) + 5 VGS screws Ø11x200 + 24 Anker nails Ø4x60 (base plate)" +
"\nF2/3" + T("|Full nailing|") + ": 36 Anker nails Ø4x60 (vertical plate) + 2 VGS screws Ø11x200 + 30 Anker nails Ø4x60 (base plate)" +
"\nF2/3-" + T("|Partial nailing|") + ": 24 Anker nails Ø4x60 (vertical plate) + 2 VGS screws Ø11x200 + 24 Anker nails Ø4x60 (base plate)");
sType.setCategory(category);

String dOffsetName = T("|Offset|");
PropDouble dOffset(nDoubleIndex++, U(50), dOffsetName);
dOffset.setDescription(T("|Minimal distance from edge to metal part|."));
dOffset.setCategory(category);

category = T("|Display|");
String sDisplays[] = { T("|No nail info|"), T("|Text|"), T("|Graphical|"), T("|Realistic|")};
String sDisplayName = T("|Display|");
PropString sDisplay(nStringIndex++, sDisplays, sDisplayName, 1);
sDisplay.setDescription(T("|Defines the Display|"));
sDisplay.setCategory(category);

// order dimstyles
String sDimStyles[0];sDimStyles = _DimStyles;
for (int i = 0; i < sDimStyles.length(); i++)
	for (int j = 0; j < sDimStyles.length() - 1; j++)
	{
		String s1 = sDimStyles[j];
		String s2 = sDimStyles[j + 1];
		if (s1.makeLower() > s2.makeLower())
			sDimStyles.swap(j, j + 1);
	}
String sDimStyleName = T("|Dimstyle|");
PropString sDimStyle(nStringIndex++, sDimStyles, sDimStyleName);
sDimStyle.setCategory(category);

String sScaleName = T("|Scale|");
PropDouble dScale(nDoubleIndex++, 1, sScaleName);
dScale.setDescription(T("|Defines the Height Scale| ")+T("(|height is defined by metal part dimensions|)."));
dScale.setCategory(category);
//endregion

//region on insert
if (_bOnInsert)
{
	if (insertCycleCount() > 1)
	{
		eraseInstance(); return;
	}
	
	// silent/dialog
	String sKey = _kExecuteKey;
	sKey.makeUpper();
	
	if (sKey.length() > 0)
	{
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for (int i = 0; i < sEntries.length(); i++)
			sEntries[i] = sEntries[i].makeUpper();
		if (sEntries.find(sKey) >- 1)
			setPropValuesFromCatalog(sKey);
		else
			setPropValuesFromCatalog(sLastInserted);
	}
	else
		showDialogOnce();
	
	// get selection set
	//PrEntity ssE(T("|Select 1 or 2 panels for insertion at specified point|")+T(", |or more for automatic distribution|"), Sip());
	PrEntity ssE(T("|Select 2 panels for insertion at specified point|\n"), Sip());
	if (ssE.go())
		_Entity.append(ssE.set());
	
	for (int i = 0; i < _Entity.length(); i++)
	{
		Sip sip = (Sip)_Entity[i];
		if ( ! sip.bIsValid())
			continue;
		
		_Sip.append(sip);
	}
	
	// clonning settings
	TslInst tslNew;
	Vector3d vecXTsl = _XE;
	Vector3d vecYTsl = _YE;
	GenBeam gbsTsl[0];//= { };
	Entity entsTsl[] = { };
	Point3d ptsTsl[1];//= { };
	int nProps[] ={ };
	double dProps[] ={ dOffset};
	String sProps[] ={ sType};
	Map mapTsl;
	String sScriptname = scriptName();
	
	int nSips = _Sip.length();
	if (nSips == 0)
	{
		eraseInstance();
		return;
	}
	else if (nSips <= 2)
	{
		gbsTsl.append(_Sip[0]);//single female panel
		
		if (nSips == 2)//female and male panel
		{
			gbsTsl.append(_Sip[1]);
		}
		else
		{
			reportMessage(sError2PanelsNeeded);
			eraseInstance();
			return;
		}
		
		ptsTsl[0] = getPoint();
		
		tslNew.dbCreate(sScriptname , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		if (tslNew.bIsValid())
			tslNew.setPropValuesFromCatalog(sLastInserted);
	}//next i
	
	else //automatic walls to floors distribution
	{
		//TODO
		reportMessage(sError2PanelsNeeded);
		eraseInstance();
		return;
	}
	
	eraseInstance();
	return;
}
//endregion

//region validations
if (_Sip.length() < 1)
{
	reportMessage("\n" + scriptName() + ": " + T("|Invalid reference|\n"));
	eraseInstance();
	return;
}
else if (_Sip.length() == 1)
{
	//TODO: enhance for single panel mode
	reportMessage(sError2PanelsNeeded);
	eraseInstance();
	return;
}
else if (_Sip.length() != 2)
{
	reportMessage(sError2PanelsNeeded);
	eraseInstance();
	return;
}
//endregion

//region resolve porperties
int nType = sTypes.find(sType, 0);
int nNailsFemale = nNailSetsFemale[nType];
int nNailsMale = nNailSetsMale[nType];
int nScrewsFemale = nScrewSetsFemale[nType];
int nDisplay = sDisplays.find(sDisplay, 0);
//endregion

//region declare panel standards and local variables
Sip sip = _Sip[0];
Vector3d vecX = sip.vecX();
Vector3d vecY = sip.vecY();
Vector3d vecZ = sip.vecZ();
Point3d ptCen = sip.ptCenSolid();

int bDrawMetalPart = true; //will be false if metal part can't be succesfuly inserted
double dSearchValue = U(1);
PLine plFemalePlate, plMalePlate;
Vector3d vecNormalFemalePlate, vecNormalMalePlate;

//error display
int nColorBasePlate = 3, nColorVerticalPlate = 3;
Display dpError(-1);
Point3d ptLimits[0];
//endregion

//region work with female panel only//TODO
if (_Sip.length() == 1)
{
	eraseInstance();
	return;
}
//endregion

//region work with female and male panels
else if (_Sip.length() == 2)
{
	//region other panel basics and perpendicularity validation
	Sip sipOther = _Sip[1];
	Vector3d vecXOther = sipOther.vecX();
	Vector3d vecYOther = sipOther.vecY();
	Vector3d vecZOther = sipOther.vecZ();
	Point3d ptCenOther = sipOther.ptCenSolid();
	double dZOther = sip.dH();
	
	if ( ! vecZ.isPerpendicularTo(vecZOther)) //panels are not perpendicular
	{
		reportMessage("\n" + scriptName() + ": " + T("|Panels are not perpendicular|\n"));
		eraseInstance();
		return;
	}
	//endregion
	
	//region define male and female panels
	Plane plane0(ptCen, vecZ);
	Line ln0(ptCenOther, vecZ);
	Point3d ptAxisIntersection = ln0.intersect(plane0, 0);
	
	Vector3d vecNormal = vecZ.crossProduct(vecZOther);
	PlaneProfile ppSip = sip.realBody().shadowProfile(Plane(ptAxisIntersection, vecNormal));
	PlaneProfile ppSipOther = sipOther.realBody().shadowProfile(Plane(ptAxisIntersection, vecNormal));
	
	Sip sipMale, sipFemale;
	int bPointIsInSip = false, bPointIsInSipOther = false;
	if (ppSip.pointInProfile(ptAxisIntersection) == _kPointInProfile)
	{
		bPointIsInSip = true;
	}
	if (ppSipOther.pointInProfile(ptAxisIntersection) == _kPointInProfile)
	{
		bPointIsInSipOther = true;
	}
	
	if (bPointIsInSip && bPointIsInSipOther)//point is inside both plane profiles, clashing materials
	{
		reportMessage("\n" + scriptName() + ": " + T("|Possible clashing materials|. ") + T("|Please contact hsbcad support|\n"));
		eraseInstance();
		return;
	}
	else if ( ! bPointIsInSip && !bPointIsInSipOther) //point is not inside any plane profile, semi connection
	{
		//try to define male and female based on vertical/horizontal placement
		if (abs(_ZW.dotProduct(vecZOther)) < dEps)//sip1 is vertical and set as sipMale
		{
			sipMale = _Sip[1];
			sipFemale = _Sip[0];
			ppSip.vis(2); ppSipOther.vis(1);
		}
		else//sip0 is sipMale
		{
			sipMale = _Sip[0];
			sipFemale = _Sip[1];
			ppSip.vis(1); ppSipOther.vis(2);
		}
	}
	else if (bPointIsInSip)//point is inside sip0
	{
		sipFemale = sip;
		sipMale = sipOther;
		ppSip.vis(2); ppSipOther.vis(1);
	}
	else //point is sipOther
	{
		sipFemale = sipOther;
		sipMale = sip;
		ppSip.vis(1); ppSipOther.vis(2);
	}
	//endregion
	
	//region define reference Z vectors, realign _Pt0
	Point3d ptCenMale = sipMale.ptCenSolid();//breakpoint
	Vector3d vecXMale = sipMale.vecX();
	Vector3d vecYMale = sipMale.vecY();
	Vector3d vecZMale = sipMale.vecZ();
	Vector3d vecZMaleRef = vecZMale;
	if (vecZMaleRef.dotProduct(_Pt0 - ptCenMale) < 0)
		vecZMaleRef *= -1;
	Point3d ptOnFaceMale = ptCenMale + vecZMaleRef * sipMale.dD(vecZMaleRef) * .5;
	
	Point3d ptCenFemale = sipFemale.ptCenSolid();
	Vector3d vecZFemaleRef = sipFemale.vecZ();
	if (vecZFemaleRef.dotProduct(ptCenMale - ptCenFemale) < 0)
		vecZFemaleRef *= -1;
	Point3d ptOnFaceFemale = ptCenFemale + vecZFemaleRef * sipFemale.dD(vecZFemaleRef) * .5;
	
	_Pt0 += vecZMaleRef * vecZMaleRef.dotProduct(ptOnFaceMale - _Pt0) + vecZFemaleRef * vecZFemaleRef.dotProduct(ptOnFaceFemale - _Pt0);
	
	vecNormalFemalePlate = vecZFemaleRef;
	vecNormalMalePlate = vecZMaleRef;
	//endregion
	
	//region check if panels can hold metalpart (available and regular contact area)
	plFemalePlate.createRectangle(LineSeg(_Pt0 - vecNormal * dLength * .5, _Pt0 + vecNormal * dLength * .5 + vecZMaleRef * dBaseHeight), vecNormal, vecZMaleRef);
	plMalePlate.createRectangle(LineSeg(_Pt0 - vecNormal * dLength * .5, _Pt0 + vecNormal * dLength * .5 + vecZFemaleRef * dVerticalHeight), vecNormal, vecZFemaleRef);
	if (bDebug) { vecZMaleRef.vis(_Pt0); vecZFemaleRef.vis(_Pt0); vecNormal.vis(_Pt0); }
	
	//on female panel
	PlaneProfile ppPlateOnFemalePanel(plFemalePlate);
	double dPlateOnFemaleArea = ppPlateOnFemalePanel.area();
	Body bdFemale = sipFemale.realBody();
	PlaneProfile ppFemalePanel = bdFemale.getSlice(Plane(_Pt0 - vecZFemaleRef * dSearchValue, vecZFemaleRef));
	ppFemalePanel.transformBy(vecZFemaleRef * dSearchValue);
	
	PlaneProfile ppIntersectingOnFemale = ppPlateOnFemalePanel;
	if ( ! ppIntersectingOnFemale.intersectWith(ppFemalePanel) || abs(dPlateOnFemaleArea - ppIntersectingOnFemale.area()) > dEps)
	{
		bDrawMetalPart = false;
		nColorBasePlate = 1;
		reportMessage("\n" + scriptName() + ": " + T("|Not possible connection to female panel|\n"));
	}
	
	//on male panel
	PlaneProfile ppPlateOnMalePanel(plMalePlate);
	double dPlateOnMaleArea = ppPlateOnMalePanel.area();
	Body bdMale = sipMale.realBody();
	PlaneProfile ppMalePanel = bdMale.getSlice(Plane(_Pt0 - vecZMaleRef * dSearchValue, vecZMaleRef));
	ppMalePanel.transformBy(-vecZFemaleRef * dSearchValue);
	PlaneProfile ppIntersectingOnMale = ppPlateOnMalePanel;
	if ( ! ppIntersectingOnMale.intersectWith(ppMalePanel) || abs(dPlateOnMaleArea - ppIntersectingOnMale.area()) > dEps)
	{
		bDrawMetalPart = false;
		nColorVerticalPlate = 1;
		reportMessage("\n" + scriptName() + ": " + T("|Not possible connection to male panel|\n"));
	}
	//endregion
	
	//region verify distance from panels edges
	if (bDrawMetalPart)//needed only if passed code before
	{
		Point3d ptMetalPartLeft = _Pt0 - vecNormal * dLength * .5;
		Point3d ptMetalPartRight = _Pt0 + vecNormal * dLength * .5;
		Point3d ptMinLeft = ptMetalPartLeft - vecNormal * dOffset;
		Point3d ptMinRight = ptMetalPartRight + vecNormal * dOffset;
		
		//check space needed on female
		PLine plNeededOnFemale;
		plNeededOnFemale.createRectangle(LineSeg(ptMinLeft, ptMinRight + vecZMaleRef), vecNormal, vecZMaleRef);
		PlaneProfile ppNeededOnFemale(plNeededOnFemale);
		PlaneProfile ppAvailableOnFemale = ppNeededOnFemale;
		ppAvailableOnFemale.intersectWith(ppFemalePanel);
		
		//check space needed on male
		PLine plNeededOnMale;
		plNeededOnMale.createRectangle(LineSeg(ptMinLeft, ptMinRight + vecZFemaleRef), vecNormal, vecZFemaleRef);
		PlaneProfile ppNeededOnMale(plNeededOnMale);
		PlaneProfile ppAvailableOnMale = ppNeededOnMale;
		ppAvailableOnMale.intersectWith(ppMalePanel);
		
		//not enough space to hold metalpart, don't draw metal part, instead draw error PLines
		if (abs(ppNeededOnFemale.area() - ppAvailableOnFemale.area()) > dEps || abs(ppNeededOnMale.area() - ppAvailableOnMale.area()) > dEps)
		{
			bDrawMetalPart = false;
			dpError.color(3);
			dpError.draw(ppAvailableOnFemale);
			dpError.draw(ppAvailableOnMale);
			dpError.color(1);
			dpError.draw(ppNeededOnFemale);
			dpError.draw(ppNeededOnMale);
			ptLimits.append(ptMinLeft);
			ptLimits.append(ptMinRight);
		}
		
		//metal part is completely out from both, male and female panels; delete it
		Point3d ptExtremsFemale [] = bdFemale.extremeVertices(vecNormal);
		Point3d ptExtremsMale [] = bdMale.extremeVertices(vecNormal);
		if (ptExtremsFemale.length() == 0 || ptExtremsMale.length() == 0)
		{
			eraseInstance();
			return;
		}
		
		Point3d ptFemaleLeft = ptExtremsFemale[0], ptFemaleRight = ptExtremsFemale.last();
		Point3d ptMaleLeft = ptExtremsMale[0], ptMaleRight = ptExtremsMale.last();
		if (vecNormal.dotProduct(ptMetalPartRight - ptFemaleLeft) < 0 && vecNormal.dotProduct(ptMetalPartRight - ptMaleLeft) < 0 ||
			(vecNormal.dotProduct(ptMetalPartLeft - ptFemaleRight) > 0 && vecNormal.dotProduct(ptMetalPartLeft - ptMaleRight) > 0))
			{
				eraseInstance();
				return;
			}
	}
	//endregion
}
//endregion

//region display and hardward component
if (bDrawMetalPart)
{
	//region display
	//metal plates
	MetalPart mpFemalePlate(plFemalePlate, vecNormalFemalePlate * dThickness, 1);
	MetalPart mpMalePlate(plMalePlate, vecNormalMalePlate * dThickness, 1);
	//maker name
	Display dpText(252);
	dpText.dimStyle(sDimStyle);
	dpText.textHeight(dVerticalHeight * .05);
	double dLineSpacing = 1.5;
	Point3d ptMaker = _Pt0 + vecNormalFemalePlate * dVerticalHeight * .15 + vecNormalMalePlate * (dThickness + dEps * .5);
	Vector3d vecXtxt = vecNormalFemalePlate.crossProduct(vecNormalMalePlate);
	Vector3d vecYtxt = vecNormalFemalePlate;
	dpText.draw("rothoblass", ptMaker, vecXtxt, vecYtxt, 0, dLineSpacing);
	dpText.draw("TITAN TTV240", ptMaker, vecXtxt, vecYtxt, 0, - dLineSpacing);

	//display screws and nailing pattern
	if (nDisplay == 1)//text
	{
		dpText.textHeight(dVerticalHeight * .1 * dScale);
		dLineSpacing = 2;
		//female plate
		vecXtxt = vecNormalFemalePlate.crossProduct(vecNormalMalePlate);
		vecYtxt = - vecNormalMalePlate;
		Point3d ptTxt; ptTxt.setToAverage(plFemalePlate.vertexPoints(1));
		ptTxt += vecNormalFemalePlate * (dThickness + dEps * .5);
		
		String sText = nNailsFemale + "x" + sNailTypesFemale[nType];
		dpText.draw(sText, ptTxt, vecXtxt, vecYtxt, 0, - dLineSpacing);
		sText = nScrewsFemale + "x" + sScrewTypesFemale[nType];
		dpText.draw(sText, ptTxt, vecXtxt, vecYtxt, 0, dLineSpacing);
		
		//male plate
		vecYtxt = vecNormalFemalePlate;
		ptTxt.setToAverage(plMalePlate.vertexPoints(1));
		ptTxt += vecNormalMalePlate * (dThickness + dEps * .5);
		
		sText = nNailsMale + "x" + sNailTypesMale[nType];
		dpText.draw(sText, ptTxt, vecXtxt, vecYtxt, 0, 0);
	}
	else if (nDisplay > 1)//graphical || realistic
	{
		Display dpDrills(3);
		
		//region female plate
		//draw screw holes
		Point3d ptStart = _Pt0 + vecNormalMalePlate * U(13) + vecNormalFemalePlate * (dThickness + dEps * .5);
		Vector3d vDistribution = vecNormalFemalePlate.crossProduct(vecNormalMalePlate);
		int nQuantity = 5;
		double dSpacing = 50;
		double dHoleRadius = U(6);
		Point3d ptNew = ptStart + vDistribution * .5 * dSpacing * (1 - (nQuantity % 2));
		for ( int n = 0; n < nQuantity; n++)
		{
			dpDrills.color(3);
			if ((nType == 2 || nType == 3)//type F2 / 3
				 && n != nQuantity - 1 && n != nQuantity - 2 )//extreme holes
			dpDrills.color(1);
			
			int nSign;
			if (n % 2 == 0)
				ptNew += vDistribution * dSpacing * n;
			else
				ptNew -= vDistribution * dSpacing * n;
			
			if (nDisplay == 2 )//graphical
			{
				double dc = U(6);
				Vector3d vxd = vecNormalFemalePlate.crossProduct(vecNormalMalePlate);
				Vector3d vyd = vecNormalMalePlate;
				PLine pl;
				Point3d ptStart = ptNew;
				
				PLine plDrill;
				plDrill.createCircle(ptStart, vecNormalFemalePlate, dHoleRadius);
				dpDrills.draw(plDrill);
				
				Point3d pt = ptStart;
				pl.addVertex(pt);
				pt = ptStart + vxd * dc * .5;
				pl.addVertex(pt);
				pt = ptStart - vxd * dc * .5;
				pl.addVertex(pt);
				pt = ptStart;
				pl.addVertex(pt);
				pt = ptStart + vyd * dc * .5;
				pl.addVertex(pt);
				pt = ptStart - vyd * dc * .5;
				pl.addVertex(pt);
				dpDrills.draw(pl);
			}
			else if (nDisplay == 3)//realistic
			{
				Drill drill(ptNew + vecNormalFemalePlate * dThickness, ptNew - vecNormalFemalePlate * dThickness * 1.5, dHoleRadius);
				mpFemalePlate.addTool(drill);
			}
		}
		
		//draw nail holes
		ptStart = _Pt0 + vecNormalMalePlate * U(33) + vecNormalFemalePlate * (dThickness + dEps * .5);
		nQuantity = 6;
		dSpacing = 40;
		int nRows = 5;
		double dRowSpacing = U(10);
		double dRowOffset = U(10);
		dHoleRadius = U(2.5);
		for (int r = 0; r < nRows; r++)
		{
			ptNew = ptStart + vDistribution * .5 * dSpacing * (1 - (nQuantity % 2)) + vecNormalMalePlate * dRowSpacing * r;
			if (r % 2 == 0)
				ptNew -= vDistribution * dRowOffset;
			else
				ptNew += vDistribution * dRowOffset;
			
			for ( int n = 0; n < nQuantity; n++)
			{
				int nSign;
				if (n % 2 == 0)
					ptNew += vDistribution * dSpacing * n;
				else
					ptNew -= vDistribution * dSpacing * n;
				
				if (nDisplay == 2 )//graphical
				{
					double dc = U(6);
					Vector3d vxd = vecNormalFemalePlate.crossProduct(vecNormalMalePlate);
					Vector3d vyd = vecNormalMalePlate;
					PLine pl;
					Point3d ptStart = ptNew;
					dpDrills.color(3);
					if ((nType == 1 || nType == 3)//partial nailing pattern
						 && r == nRows - 1)//last row
						{
							dpDrills.color(1);
						}
					
					PLine plDrill;
					plDrill.createCircle(ptStart, vecNormalFemalePlate, dHoleRadius);
					dpDrills.draw(plDrill);
					
					Point3d pt = ptStart;
					pl.addVertex(pt);
					pt = ptStart + vxd * dc * .5;
					pl.addVertex(pt);
					pt = ptStart - vxd * dc * .5;
					pl.addVertex(pt);
					pt = ptStart;
					pl.addVertex(pt);
					pt = ptStart + vyd * dc * .5;
					pl.addVertex(pt);
					pt = ptStart - vyd * dc * .5;
					pl.addVertex(pt);
					dpDrills.draw(pl);
				}
				else if (nDisplay == 3)//realistic
				{
					Drill drill(ptNew + vecNormalFemalePlate * dThickness, ptNew - vecNormalFemalePlate * dThickness * 1.5, dHoleRadius);
					mpFemalePlate.addTool(drill);
				}
			}
		}//next r
		//endregion
		
		//region male plate
		//draw nail holes
		ptStart = _Pt0 + vecNormalFemalePlate * U(60) + vecNormalMalePlate * (dThickness + dEps * .5);
		nQuantity = 6;
		dSpacing = 40;
		nRows = 6;
		dRowSpacing = U(10);
		dRowOffset = U(10);
		dHoleRadius = U(2.5);
		for (int r = 0; r < nRows; r++)
		{
			ptNew = ptStart + vDistribution * .5 * dSpacing * (1 - (nQuantity % 2)) + vecNormalFemalePlate * dRowSpacing * r;
			if (r % 2 == 0)
				ptNew -= vDistribution * dRowOffset;
			else
				ptNew += vDistribution * dRowOffset;
			
			for ( int n = 0; n < nQuantity; n++)
			{
				int nSign;
				if (n % 2 == 0)
					ptNew += vDistribution * dSpacing * n;
				else
					ptNew -= vDistribution * dSpacing * n;
				
				if (nDisplay == 2 )//graphical
				{
					double dc = U(6);
					Vector3d vxd = vecNormalFemalePlate.crossProduct(vecNormalMalePlate);
					Vector3d vyd = vecNormalFemalePlate;
					PLine pl;
					Point3d ptStart = ptNew;
					dpDrills.color(3);
					if ((nType == 1 || nType == 3)//partial nailing pattern
						 && r > 3)
						{
							dpDrills.color(1);
						}
					
					PLine plDrill;
					plDrill.createCircle(ptStart, vecNormalMalePlate, dHoleRadius);
					dpDrills.draw(plDrill);
					
					Point3d pt = ptStart;
					pl.addVertex(pt);
					pt = ptStart + vxd * dc * .5;
					pl.addVertex(pt);
					pt = ptStart - vxd * dc * .5;
					pl.addVertex(pt);
					pt = ptStart;
					pl.addVertex(pt);
					pt = ptStart + vyd * dc * .5;
					pl.addVertex(pt);
					pt = ptStart - vyd * dc * .5;
					pl.addVertex(pt);
					dpDrills.draw(pl);
				}
				else if (nDisplay == 3)//realistic
				{
					Drill drill(ptNew + vecNormalMalePlate * dThickness, ptNew - vecNormalMalePlate * dThickness * 1.5, dHoleRadius);
					mpMalePlate.addTool(drill);
				}
			}
		}//next r		//endregion
	}
	//endregion
	
	//region Hardware
	// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
	// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i = hwcs.length() - 1; i >= 0; i--)
	{
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i);
	}
	
	// declare the groupname of the hardware components
	String sHWGroupName;
	// set group name
	{
		// element
		// try to catch the element from the parent entity
		Element elHW = sip.element();
		// check if the parent entity is an element
		if ( ! elHW.bIsValid())
			elHW = (Element)sip;
		if (elHW.bIsValid())
			sHWGroupName = elHW.elementGroup().name();
			// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length() > 0)
				sHWGroupName = groups[0].name();
		}
	}
	
	// add main componnent
	String sArticleNumber = "TTV240";
	HardWrComp hwc(sArticleNumber, 1); //the articleNumber and the quantity is mandatory
	
	hwc.setManufacturer("Rothoblaas");
	
	hwc.setModel("Titan V");
	hwc.setName(sArticleNumber);
	hwc.setDescription(sType);
	
	hwc.setGroup(sHWGroupName);
	hwc.setLinkedEntity(_Sip[0]);
	hwc.setCategory(T("|Connector|"));
	hwc.setRepType(_kRTTsl); //the repType is used to distinguish between predefined and custom components
	
	hwc.setDScaleX(dLength);
	hwc.setDScaleY(dBaseHeight);
	hwc.setDScaleZ(dVerticalHeight);
	
	// apppend component to the list of components
	hwcs.append(hwc);
	
	//nails
	// add sub componnent
	{
		HardWrComp hwc("LBA 460", nNailsFemale + nNailsFemale); //the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer("Rothoblaas");
		hwc.setDescription("Kammnägel");
		hwc.setMaterial(T("|Steel, zincated|"));
		hwc.setLinkedEntity(_Sip0);
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); //the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(U(60));
		hwc.setDScaleY(U(4));
		hwc.setDScaleZ(0);
		
		
		// apppend component to the list of components
		hwcs.append(hwc);
	}
	
	//screws
	// add sub componnent
	{
		HardWrComp hwc(sScrewTypesFemale[nType], nScrewsFemale); //the articleNumber and the quantity is mandatory
		
		hwc.setLinkedEntity(_Sip0);
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); //the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(dScrewLengths[nType]);
		hwc.setDScaleY(U(11));
		hwc.setDScaleZ(0);
		
		// apppend component to the list of components
		hwcs.append(hwc);
	}
	
	
	// make sure the hardware is updated
	if (_bOnDbCreated)
		setExecutionLoops(2);
	
	_ThisInst.setHardWrComps(hwcs);
	//endregion
	
	return;
}

//draw plates with error colors
dpError.color(nColorVerticalPlate);
dpError.draw(plMalePlate);
dpError.color(nColorBasePlate);
dpError.draw(plFemalePlate);
//draw limit points
dpError.color(2);
for (int p = 0; p < ptLimits.length(); p++)
{
	Point3d ptLimit = ptLimits[p];
	double dc = U(25);
	Vector3d vxd = _XW;
	Vector3d vyd = _YW;
	Vector3d vzd = _ZW;
	PLine pl;
	Point3d ptStart = ptLimit;
	Point3d pt = ptStart;
	pl.addVertex(pt);
	pt = ptStart + vxd * dc * .5;
	pl.addVertex(pt);
	pt = ptStart - vxd * dc * .5;
	pl.addVertex(pt);
	pt = ptStart;
	pl.addVertex(pt);
	pt = ptStart + vyd * dc * .5;
	pl.addVertex(pt);
	pt = ptStart - vyd * dc * .5;
	pl.addVertex(pt);
	dpError.draw(pl);
	pl = PLine();
	pt = ptStart - vzd * dc * .5;
	pl.addVertex(pt);
	pt = ptStart + vzd * dc * .5;
	pl.addVertex(pt);
	dpError.draw(pl);
	
	
}//next p
//endregion
#End
#BeginThumbnail
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
,5W*H!P?2MJB@#__9

#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End