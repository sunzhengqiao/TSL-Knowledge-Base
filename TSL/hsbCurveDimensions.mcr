#Version 8
#BeginDescription
version  value="1.1" date="16apr13" author="th@hsbCAD.de"
new property color press, press color and tag color match, additional data in schedule table

EN
/// This TSL numbers and labels all presses assigned to a curved description. It displays the lamella structure 
//// in a small schedule table

DACH
/// Dieses TSL numeriert und beschriftet alle zugeordneten Pressen einer Binderbeschreibung. Es erzeugt eine kleine
/// Bauteiltabelle, welche den Lamellenaufbau beschreibt.


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This TSL dimensions a flat spant description
/// </summary>

/// <summary Lang=de>
/// Dieses TSL bemaﬂt eine abgewickelte Binderbeschreibung.
/// </summary>

/// <insert Lang=en>
/// Enter properties, select one or multiple curved descriptions.
/// </insert>


/// History
///<version  value="1.0" date="16apr13" author="th@hsbCAD.de">initial</version>

// basics and props
	U(1,"mm");
	double dEps = U(0.1);

	// general
	// order dimstyles
	String sArDimStyles[0];
	sArDimStyles = _DimStyles;
	for (int i = 0; i < sArDimStyles.length()-1; i++)
		for (int j= 0; j< sArDimStyles.length()-1; j++)	
			if (sArDimStyles[j+1]<sArDimStyles[j])
				sArDimStyles.swap(j,j+1);
	
	PropString sDimStyle(0,sArDimStyles,T("|Dimstyle|"),0);	
	PropDouble dTxtH(0,U(40),T("|Text Height|"));	

	String sColorName=T("|Color|");
	PropInt nColor (0,1,sColorName);
	nColor.setDescription(T("|Defines the color of the schedule table|"));
	
	int nDisplayModes[]={_kDimPar, _kDimPerp,_kDimNone};
	String sDisplayModes[] = {T("|Parallel|"),T("|Perpendicular|"), T("|None|")};


	PropString sDisplayModeDelta(1,sDisplayModes,T("|Delta Dimensioning|"));
	PropString sDisplayModeChain(2,sDisplayModes,T("|Chain Dimensioning|"));	
			
				
// on insert
	if (_bOnInsert) {
		
		if (insertCycleCount()>1) { eraseInstance(); return; }
		showDialog();
	// declare arrays for tsl cloning
		TslInst tslNew;
		Vector3d vUcsX = _XW;
		Vector3d vUcsY = _YW;
		GenBeam gbAr[0];
		Entity entAr[1];
		Point3d ptAr[1];
		int nArProps[0];
		double dArProps[0];
		String sArProps[0];
		Map mapTsl;
		String sScriptname = scriptName();	

		dArProps.append(dTxtH);

		nArProps.append(nColor );
		
		sArProps.append(sDimStyle);
		sArProps.append(sDisplayModeDelta);
		sArProps.append(sDisplayModeChain);


		
	// prompt selection			
		PrEntity ssE(T("|Select curved description|"), CurvedDescription ());
		Entity ents[0];
	  	if (ssE.go())
	    	ents= ssE.set();	

	// select insertion point
		if (ents.length()==1)
		{
			_Pt0 = getPoint();	
		}

		for (int e=0;e<ents.length();e++)
		{
			CurvedDescription curve = (CurvedDescription )ents[e];
			if (ents.length()==1)
				ptAr[0]=_Pt0;
			else
				ptAr[0] = curve.coordSys().ptOrg();
			entAr[0] = ents[e];

			tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
				nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance	
							
		}	
		eraseInstance();	
		return;	
	}	
// end on insert

// validate
	if (_Entity.length()<1 || !_Entity[0].bIsKindOf(CurvedDescription ()))	
	{
		reportMessage("\n" + T("|Invalid reference|"));
		eraseInstance();
		return;	
	}
	setDependencyOnEntity(_Entity[0]);	

// on the event of dragging _Pt0
	if (_kNameLastChangedProp=="_Pt0" && _Map.hasVector3d("_PtG0") && _PtG.length()>0)
		_PtG[0] = _PtW+_Map.getVector3d("_PtG0");
	
// the curve description
	CurvedDescription curve = (CurvedDescription )_Entity[0];	
	CoordSys cs = curve.coordSys();
	Point3d ptOrg=cs.ptOrg();
	Vector3d vx=cs.vecX(),vy=cs.vecY(),vz=cs.vecZ();	
	vx.vis(ptOrg,1);
	vy.vis(ptOrg,1);
	vz.vis(ptOrg,1);

// the style	
	CurvedStyle style = curve.style();	
	String sStyleName = style.entryName();
	Point3d ptRef = style.ptRef();
	ptRef.transformBy(curve.coordSys());
	ptRef.vis(6);

	double dLamThickness = style.lamThickness();

// display	
	int nDisplayColor=nColor;
	Display dp(nDisplayColor);
	dp.dimStyle(sDimStyle);	
	double dHeightStyle = dp.textHeightForStyle("O",sDimStyle);
	double dFactor = 1;
	if (dHeightStyle>0)dFactor =dTxtH/dHeightStyle;
	dp.textHeight(dTxtH);

// collect the grips o the curve
	Point3d ptGrips[0];
	ptGrips = curve.gripPoints();	
	// remove the ref grip
	for (int i=0;i<ptGrips.length();i++)
		if (abs(vx.dotProduct(ptRef-ptGrips[i]))<dEps)
		{
			ptGrips.removeAt(i);
			break;
		}

// order lines
	Line lnY (ptRef,vy);
	Line lnX (ptRef,vx);
	
// get max dY
	ptGrips = lnY.orderPoints(ptGrips);
	Point3d ptMinMaxY[0];
	double dY;
	if (ptGrips.length()>1)
	{
		ptMinMaxY.append(ptGrips[0]);
		ptMinMaxY.append(ptGrips[ptGrips.length()-1]);
		dY = vy.dotProduct(ptMinMaxY[ptMinMaxY.length()-1]-ptMinMaxY[0])	;
	}
			
	ptGrips = lnX.orderPoints(lnX.projectPoints(ptGrips),5* dEps);
	for (int i=0;i<ptGrips.length();i++)
		ptGrips[i].vis(i);


// extreme points
	Point3d ptMinMaxX[0];
	if (ptGrips.length()>1)
	{
		ptMinMaxX.append(ptGrips[0]);
		ptMinMaxX.append(ptGrips[ptGrips.length()-1]);
	}	
	
// dim variables
	int nDisplayModeDelta=nDisplayModes[sDisplayModes.find(sDisplayModeDelta)];
	int nDisplayModeChain=nDisplayModes[sDisplayModes.find(sDisplayModeChain)];	
	
// create dimline
	Point3d ptLoc1 = ptMinMaxY[1]+ vy * 3 * dHeightStyle;
	DimLine dl1(ptLoc1,vx,vy);
	Dim dim1(dl1,ptGrips, "<>","{<>}",nDisplayModeDelta,nDisplayModeChain);	
	dp.draw(dim1);
	
	Point3d ptLoc2 = ptMinMaxY[0]- vy * 3 * dHeightStyle;
	DimLine dl2(ptLoc2,vx,vy);
	Dim dim2(dl2,ptMinMaxX, "<>","{<>}",nDisplayModeDelta,nDisplayModeChain);	
	dim2.append(ptRef);
	dp.draw(dim2);
	
	Point3d ptLoc3 = ptMinMaxY[0]- vy * 5 * dHeightStyle;
	DimLine dl3(ptLoc3,vx,vy);
	Dim dim3(dl3,ptMinMaxX, "<>","{<>}",nDisplayModeDelta,nDisplayModeChain);	
	dp.draw(dim3);
	
// collect / count beams with this style
	Entity ents[] = Group().collectEntities(true,Beam(),_kModelSpace);
	int nNumBeams;
	String sInfo, sMaterial;
	for (int e=0;e<ents.length();e++)
	{
		Beam bm = (Beam)ents[e];
		if (bm.bIsValid() && bm.curvedStyle()==sStyleName)
		{
			if (nNumBeams==0)
			{
				sInfo=bm.information();
				sMaterial = bm.material();	
			}
			nNumBeams++;
		}
	}	
	
	
	dp.draw(nNumBeams + " " + T("|pcs|")+ "    " + sStyleName + "    "  + sMaterial + "    "  +sInfo + "    Lam"  + style.lamThickness()+"mm",_Pt0, vx,vy,1,0);
	

#End
#BeginThumbnail

#End
