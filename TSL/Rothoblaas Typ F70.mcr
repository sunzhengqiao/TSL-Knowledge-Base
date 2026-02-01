#Version 8
#BeginDescription
version value="1.0" date="15sept17" author="florian.wuermseer@hsbcad.com">
initial version


D >>> Dieses TSL erstellt einen Pfostenträger Rothoblaas Typ F70 an einem oder mehreren Stäben.

E >>> This TSL creates Rothoblaas post bases type F70 on one or multiple beams.

TSL can be inserted in different ways:
Without point selection (just press enter) the TSL will be inserted on the bottom point of vertical beams, only. 
It is always pointing downwards, then. The bottom point of the original beam will be the bottom of the post base.

With point selection, the selected point will be projected to the x-axis of each beam. This projected point will become the bottom point of the post base.
Sloped beams are possible with this method, but no horizontal ones.
With the point selection it's even possible to insert the post base upside down on top of a post.
#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This TSL creates Rothoblaas post bases type F70 on one or multiple beams.
/// </summary>

/// <insert Lang=en>
/// At least one beam is necessary. Multiple beam selection is possible.
/// Optional you can also select a point, that defines the position, where the post base is inserted (in X-Direction of each beam)
/// </insert>

/// <remark Lang=en>
/// TSL can be inserted in different ways:
/// Without point selection (just press enter) the TSL will be inserted on the bottom point of vertical beams, only. 
/// It is always pointing downwards, then. The bottom point of the original beam will be the bottom of the post base.
///
/// With point selection, the selected point will be projected to the x-axis of each beam. This projected point will become the bottom point of the post base.
/// Sloped beams are possible with this method, but no horizontal ones.
/// With the point selection it's even possible to insert the post base upside down on top of a post.
/// </remark>


/// <version value="1.0" date="15sept17" author="florian.wuermseer@hsbcad.com"> initial version</version>

// constants
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=1;//projectSpecial().find("debugTsl",0)>-1;
	
		
	
// post base's properties collection
	
	String sArticlePostBases[] = {"F70_1", "F70_2", "F70_3"};
	String sArticleNumberPostBases[] = {"TYPF700808", "TYPF701010", "TYPF701414"};
	double dHeight = U(30);

	double dTopPlateThicks[] = {U(6), U(6), U(8)};
	double dTopPlateLengths[] = {U(146), U(194), U(292)};
	double dBottomPlateLengths[] = {U(80), U(100), U(140)};
	double dBottomPlateWidths[] = {U(80), U(100), U(140)};
	double dBottomPlateThicks[] = {U(6), U(6), U(8)};	
	double dThreadDias[] = {U(8), U(8), U(11.5)};
		
// required hardware (mounting on ground)	
	double dScrewDiaBottoms[] = {U(6), U(6), U(8)};
	int nScrewQuantBottom = 4;



// properties category
	String sCatMount = T("|Mounting|");
	
	String sSizeName = "A - " + T("|Size|");
	PropString sSize (nStringIndex++, sArticlePostBases, sSizeName);
	sSize.setCategory(sCatMount);
	int nSize = sArticlePostBases.find(sSize);
	
	String sCuttingHeightName = "B - " + T("|Cutting height|");
	PropDouble dCuttingHeight (nDoubleIndex++, U(30), sCuttingHeightName);
	dCuttingHeight.setDescription(T("|Defines the starting height of the post over the bottom plate of the post base|"));
	dCuttingHeight.setCategory (sCatMount);	

// properties tooling	
	String sCatTool = T("|Tooling|");
	
	String sSlotExtraWidthName = "C - " + T("|Slot extra width|");
	PropDouble dSlotExtraWidth (nDoubleIndex++, U(1), sSlotExtraWidthName);
	dSlotExtraWidth.setDescription(T("|Extra width of the slot|"));
	dSlotExtraWidth.setCategory (sCatTool);	
	
	String sSlotExtraDepthName = "D - " + T("|Slot extra depth|");
	PropDouble dSlotExtraDepth (nDoubleIndex++, U(1), sSlotExtraDepthName);
	dSlotExtraDepth.setDescription(T("|Extra depth of the slot|"));
	dSlotExtraDepth.setCategory (sCatTool);	
	
	

	

// get values, depending on selected mounting type
	String sArticlePostBase = sArticlePostBases[nSize];
	String sArticleNumberPostBase = sArticleNumberPostBases[nSize];

	double dTopPlateThick = dTopPlateThicks[nSize];
	double dTopPlateLength = dTopPlateLengths[nSize];
	double dBottomPlateLength = dBottomPlateLengths[nSize];
	double dBottomPlateWidth = dBottomPlateWidths[nSize];
	double dBottomPlateThick = dBottomPlateThicks[nSize];
	double dThreadDia = dThreadDias[nSize];
			
// get values depending from from selected anchoring method	
	double dScrewDiaBottom = dScrewDiaBottoms[nSize];
	String sScrewLengthBottom = T("|Length depending on static requirements|");
	
	
// correct cutting height if necessary
	if (dCuttingHeight > .5*dTopPlateLength)
	{ 
		reportMessage("\n" + T("|Cutting height out of range (> Sword length / 2)|") + "   -->   " + T("|Value corrected to|") + " " + .5*dTopPlateLength + "mm");
		dCuttingHeight.set(.5 * dTopPlateLength);
	}
	
// bOn Insert ________________________________________________________________________________________________________________________________________________________________
if (_bOnInsert)
{
	if (insertCycleCount() > 1) {eraseInstance(); return;}
	
// silent/dialog
	String sKey = _kExecuteKey;
	sKey.makeUpper();

	if (sKey.length()>0)
	{
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for(int i=0;i<sEntries.length();i++)
			sEntries[i] = sEntries[i].makeUpper();	
		if (sEntries.find(sKey)>-1)
			setPropValuesFromCatalog(sKey);
		else
			showDialog();
	}		
	else
		showDialog();

// select (multiple) beams to insert the post base
	Entity entPosts[0];
	PrEntity ssBeam(T("|Select Beam(s)|"), Beam());
	if (ssBeam.go())
		entPosts = ssBeam.set();

// select insert point	
	int nNoPoint = 0;
	Point3d ptSelect;	
	PrPoint ssPoint(T("|Select Point|") + " " + T("|or <Enter> to put post base on bottom end of the beam|"));
	if (ssPoint.go() == _kOk)
	{
		ptSelect = ssPoint.value();
	}

// if no point is selected, set flag "noPoint" --> lowest point in _ZW is selected		
	else
	{	
		nNoPoint = 1;
	}
		
// declare TSL props
	TslInst tslNew;
	Vector3d vUcsX = _XW;
	Vector3d vUcsY = _YW;
	GenBeam gbAr[1];
	Entity entAr[0];
	Point3d ptAr[1];
	int nArProps[0];
	double dArProps[] = {dCuttingHeight, dSlotExtraWidth, dSlotExtraDepth};
	String sArProps[] = {sSize};
	Map mapTsl;
	
// if no point is selected, accept only vertical beams
	if (nNoPoint == 1)
	{
		int n=0;
		for (int i=entPosts.length()-1; i>=0; i--)
		{
			Beam bmInsert = (Beam)entPosts[i];
			if (!bmInsert.vecX().isParallelTo(_ZW))
			{
				entPosts.removeAt(i);
				n++;
			}
		}	
		if (n>0) reportMessage("\n" + T("|Only vertical beams possible|") + " --> " + n + " " + T("|Beams filtered out|"));
	}

// if point is selected, exclude only horizontal beams 
	int n=0;
	for (int i=entPosts.length()-1; i>=0; i--)
	{
		Beam bmInsert = (Beam)entPosts[i];
		if (bmInsert.vecX().isPerpendicularTo(_ZW))
		{
			entPosts.removeAt(i);
			n++;
		}
	}	
	if (n>0) reportMessage("\n" + T("|Horizontal beams not possible|") + " --> " + n + " " + T("|Beams filtered out|"));
		
// loop over all selected beams
	for (int i=0; i<entPosts.length(); i++)
	{
		gbAr[0] = (Beam)entPosts[i];
		Point3d ptInsert;
		
		if (nNoPoint == 0)
			ptInsert = (gbAr[0].ptCen() - gbAr[0].vecX() * (gbAr[0].vecX().dotProduct(gbAr[0].ptCen()-ptSelect)));
		
		else
		{
			ptInsert = (gbAr[0].ptCen() - _ZW * 0.5 * gbAr[0].dL());
		}
		
		ptAr[0] = ptInsert;
		
		
	// create new instance	
		tslNew.dbCreate(scriptName(), vUcsX, vUcsY, gbAr, entAr, ptAr, nArProps, dArProps, sArProps, _kModelSpace, mapTsl); // create new instance on each beam
	}
	
	eraseInstance();
	return;
} // end on insert _________________________________________________________________________________________________________________________________________________________________________

// some declarations ________________________________________________________________________________________________________________________________________________________________
	Beam bm0 = _Beam0;
	assignToGroups(bm0, 'Z');
	
	Vector3d vecX =_X0;// _Pt0-bm0.ptCen();
	vecX.normalize();
	Vector3d vecY = _Y0; //bm0.vecY();
	Vector3d vecZ = _Z0; //vecX.crossProduct(vecY);

	if(bDebug)	
	{
		vecX.vis(_Pt0, 1);
		vecY.vis(_Pt0, 3);
		vecZ.vis(_Pt0, 5);
	}
	
	
// tools ________________________________________________________________________________________________________________________________________________________________
	Point3d ptCut = _Pt0 - vecX*(dCuttingHeight + dBottomPlateThick);

// cut the beam
	Cut ctPostBase (ptCut, vecX);
	bm0.addTool(ctPostBase, _kStretchOnToolChange);
	
// slots for mounting
	double dSlotW = dTopPlateThick + dSlotExtraWidth;
	Slot slt (_Pt0, vecZ, vecY, -vecX, U(1000), dSlotW, dTopPlateLength + dBottomPlateThick + dSlotExtraDepth, 0, 0, 1);
	bm0.addTool(slt);

	
// body to represent the post base
	Body bdPostBase;
	Body bdBottomPlate;
	Body bdSword;
	
	CoordSys csRotate;
	csRotate.setToRotation(90, vecX, _Pt0);
	
	
// bottom plate
	PLine plBottomPlate;
	plBottomPlate.addVertex(_Pt0 + vecY*dBottomPlateLength*.5 + vecZ*dBottomPlateWidth*.5);
	plBottomPlate.addVertex(_Pt0 + vecY*dBottomPlateLength*.5 - vecZ*dBottomPlateWidth*.5);
	plBottomPlate.addVertex(_Pt0 - vecY*dBottomPlateLength*.5 - vecZ*dBottomPlateWidth*.5);
	plBottomPlate.addVertex(_Pt0 - vecY*dBottomPlateLength*.5 + vecZ*dBottomPlateWidth*.5);
	plBottomPlate.close();
	bdBottomPlate = Body (plBottomPlate, -vecX*dBottomPlateThick);
	
// sword	
	PLine plSword (vecY);
	Point3d ptSwordRef = _Pt0 - vecX*dBottomPlateThick;
	plSword.addVertex(ptSwordRef - vecZ*dBottomPlateWidth*.5);
	plSword.addVertex(ptSwordRef - vecX*dTopPlateLength - vecZ*dBottomPlateWidth*.5);
	plSword.addVertex(ptSwordRef - vecX*dTopPlateLength - vecZ*(dBottomPlateWidth*.5-U(10)));
	plSword.addVertex(ptSwordRef - vecX*dTopPlateLength + vecZ*(dBottomPlateWidth*.5-U(10)));
	plSword.addVertex(ptSwordRef - vecX*dTopPlateLength + vecZ*dBottomPlateWidth*.5);
	plSword.addVertex(ptSwordRef + vecZ*dBottomPlateWidth*.5);
	plSword.close();
	plSword.vis(1);
	bdSword= Body (plSword, vecY*dTopPlateThick, 0);

// join all parts to one body	
	bdPostBase = bdBottomPlate + bdSword;


// display
	_ThisInst.setHyperlink("http://www.rothoblaas.com/products/fastening/brackets-and-plates/pillar-bases/typ-f");
	Display dp(9);
	dp.draw(bdPostBase);
	
// hardware
	if (_bOnDbCreated || _kNameLastChangedProp == sSizeName)
	{
		HardWrComp hwComps[0];	
		
		String sModel = sArticlePostBase;
		String sDescription = T("|Post base|") + " - " + T("|Type|") + " " + sArticlePostBase;

	// post base itself	
		HardWrComp hw(sArticleNumberPostBase , 1);
		hw.setName(sArticlePostBase);
		hw.setCategory(T("|Post base|"));
		hw.setManufacturer("Rothoblaas");
		hw.setModel(sModel);
		hw.setMaterial(T("|Steel|"));
		hw.setDescription(sDescription);
		hw.setDScaleX(dBottomPlateLength);
		hw.setDScaleY(dBottomPlateWidth);
		hw.setDScaleZ(dBottomPlateThick + dTopPlateLength);	
		hwComps.append(hw);
			
	// screws bottom		
		HardWrComp hwScrewBottom("---", nScrewQuantBottom);	
		hwScrewBottom.setName(T("|Fastening screw|"));
		hwScrewBottom.setCategory(T("|Post base|"));
		hwScrewBottom.setManufacturer("Rothoblaas");
		hwScrewBottom.setModel("d" + dScrewDiaBottom);
		hwScrewBottom.setMaterial(T("|Steel|"));		
		hwScrewBottom.setDescription(T("|Fastening screw|") + " d" + dScrewDiaBottom + " (" + sScrewLengthBottom + ")");
		hwScrewBottom.setDScaleX(0);
		hwScrewBottom.setDScaleY(dScrewDiaBottom);
		hwScrewBottom.setDScaleZ(0);	
		hwComps.append(hwScrewBottom);	
		

		_ThisInst.setHardWrComps(hwComps);
	}
#End
#BeginThumbnail
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
%BB@#_]F)
`

#End