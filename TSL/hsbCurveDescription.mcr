#Version 8
#BeginDescription
version  value="1.4" date="11jul13" author="th@hsbCAD.de"
offset press / base curve corrected. the first press found will set the displayed offset
layout of schedule table enhanced (pline)

terminology 'Zulage' in schedule table corrected
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
#MinorVersion 4
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This TSL numbers and labels all presses assigned to a curved description. It displays the lamella structure 
//// in a small schedule table
/// </summary>

/// <summary Lang=de>
/// Dieses TSL numeriert und beschriftet alle zugeordneten Pressen einer Binderbeschreibung. Es erzeugt eine kleine
/// Bauteiltabelle, welche den Lamellenaufbau beschreibt.
/// </summary>

/// <insert Lang=en>
/// Enter properties, select one or multiple curved descriptions.
/// </insert>

/// <summary Lang=de>
/// Diese TSL erzeugt eine Elementbemassung im Papierbereich. Es werden aus den 
/// gewählten Zonen (Mehrfachauswahl möglich) Zonenrück- oder Vorsprünge vermaßt. 
/// Rücksprünge werden negativ dargstellt, die Lage der Bemassung kann entlang der betreffenden Kante verschoben werden
/// </summary>

/// <command Lang=en>
/// THe context command 'number presses' forces the presses to be renumbered
/// </command>

/// History
///<version  value="1.4" date="11jul13" author="th@hsbCAD.de"> offset press / base curve corrected. the first press found will set the displayed offset </version>
///<version  value="1.3" date="10jul13" author="th@hsbCAD.de"> layout of schedule table enhanced (pline) </version>
///<version  value="1.2" date="27jun13" author="th@hsbCAD.de">terminology 'Zulage' in schedule table corrected</version>
///<version  value="1.1" date="16apr13" author="th@hsbCAD.de">new property color press, press color and tag color match, additional data in schedule table</version>
///<version  value="1.0" date="21nov12" author="th@hsbCAD.de">initial</version>

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
	PropDouble dTxtHPress(1,U(40),T("|Text Height|") + " " + T("|Press Label|"));	
	dTxtH.setDescription(T("|Overrides the text size of the selected dimstyle for the schedule table.|"));	
	dTxtHPress.setDescription(T("|Overrides the text size of the selected dimstyle for the press labels.|"));	
	
	String sColorName=T("|Color|");
	PropInt nColor (0,1,sColorName);
	nColor.setDescription(T("|Defines the color of the schedule table|"));
	
	String sColorPressName=T("|Color|")+ " " + T("|Press|");			
	PropInt nColorPress (2,252,sColorPressName);
	nColorPress .setDescription(T("|-1 = byPress|"));	

	String sColorRefName=T("|Color|")+ " " + T("|Reference Press|");	
	PropInt nColorRef (1,4,sColorRefName);
	nColorRef.setDescription(T("|-1 = byPress|"));	
			
				
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
		dArProps.append(dTxtHPress);
		nArProps.append(nColor );
		nArProps.append(nColorRef );
		nArProps.append(nColorPress);		
		
		sArProps.append(sDimStyle);
		
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
	Point3d ptRef = style.ptRef();
	ptRef.transformBy(curve.coordSys());
	double dLamThickness = style.lamThickness();
	
// the presses assigned to it
	PressEnt presses[] = curve.presses();
	int numPresses = presses.length();	

// on the event of creation and recalc assign an index to all presses
	int bAlterPress =_bOnDbCreated || _bOnRecalc || _bOnDebug;
	
// add trigger to renumber presses	
// trigger: renumber presses	
	if(numPresses>0)
	{
		String sTriggerNumber =T("|Number Presses|");
		addRecalcTrigger(_kContext,sTriggerNumber );			
		if (_bOnRecalc && _kExecuteKey==sTriggerNumber) 
		{	
			presses[0].setLabel("");
			bAlterPress=true;
		}	
	}
		
	
// alter presses	
	if (bAlterPress)
	{
	// order presses along curve x
		Point3d ptInserts[0];
		for (int i=0;i<presses.length();i++)
			ptInserts.append(presses[i].ptInsert());
		for (int i=0;i<presses.length();i++)
		{
			
			for (int j=0;j<presses.length()-1;j++)	
			{
				double d1 = cs.vecX().dotProduct(ptInserts[j]-ptOrg);
				double d2 = cs.vecX().dotProduct(ptInserts[j+1]-ptOrg);
				if (d1>d2)
				{
					ptInserts.swap(j,j+1);
					presses.swap(j,j+1);	
				}	
			}
		}
	// if the first press does not contain a value for it's label renumber all presses			
		if (presses.length()>0 && presses[0].label()=="")
			for (int i=0;i<presses.length();i++)
				presses[i].setLabel(i+1);
	}	



// display
	int nDisplayColor=nColor;
	Display dp(nDisplayColor);
	dp.dimStyle(sDimStyle);
	double dHeightStyle = dp.textHeightForStyle("O",sDimStyle);
	double dFactor = 1;
	if (dHeightStyle>0)dFactor =dTxtH/dHeightStyle;
	dp.textHeight(dTxtHPress);


// add a grip for the label location, default it to 2*dTxtH + press.size()/2
	double dLabelOffset;

	if (numPresses>0)
	{
		PressEnt press = presses[0];
		Point3d ptInsert = press.ptInsert();
		Vector3d vyPress=press.ptTop()-press.ptBottom();
		vyPress.normalize();	vyPress.vis(ptInsert , 3);
		Vector3d vxPress=vyPress.crossProduct(vz);					vxPress.vis(ptInsert , 1);		
		if (_PtG.length()<1)
			_PtG.append(ptInsert -vyPress* (2*dTxtH + press.size()/2));	
		if (_PtG.length()>0)
		{
		// snap to line
			_PtG[0] = Line(ptInsert ,vyPress).closestPointTo(_PtG[0]);			
			dLabelOffset = vyPress.dotProduct(ptInsert-_PtG[0]);		
		}
		_Map.setVector3d("_PtG0", _PtG[0]-_PtW);	
	}

// change color events
	int bChangeColor = _bOnDbCreated;
	int bChangeColorRef = _bOnDbCreated;
	int bChangeColorPress = _bOnDbCreated;
	if (_kNameLastChangedProp == sColorName)	bChangeColor =true;
	if (_kNameLastChangedProp == sColorRefName)	bChangeColorRef =true;
	if (_kNameLastChangedProp == sColorPressName)	bChangeColorPress =true;
	
	
	
	
// draw press labels
	int nIndexRefPress=-1;
	double dOffsetPressBaseCurve;
	for (int i=0;i<numPresses;i++)
	{
		PressEnt press = presses[i];
		if (i==0)dOffsetPressBaseCurve=press.offset();
		
		Point3d ptInsert = press.ptInsert();
		ptInsert .vis(i);
		Vector3d vyPress=press.ptTop()-press.ptBottom();
		vyPress.normalize();	vyPress.vis(ptInsert , 3);
		Vector3d vxPress=vyPress.crossProduct(vz);					vxPress.vis(ptInsert , 1);
		Point3d ptLabel = ptInsert -vyPress* dLabelOffset;	

		int bRefPress = (ptRef-ptInsert).length()<press.size()/2;
		if (bRefPress)
		{
			nIndexRefPress=i+1;
			nDisplayColor = nColorRef;
			if (nColorRef>-1 && bChangeColorRef)press.setColor(nDisplayColor);	
			else nDisplayColor=press.color();
		}
		else
		{
			nDisplayColor = nColorPress;
			if (nColorPress>-1 && bChangeColorPress )press.setColor(nDisplayColor);	
			else nDisplayColor=press.color();						
		}
		dp.color(nDisplayColor);
		dp.draw(press.label(), ptLabel ,vxPress,vyPress,0,-1);	
	}
	
// collect data for schedule table of lamellas
	dp.textHeight(dTxtH);
	dp.color(nColor);

	String lamGroups = style.lamGroups();
	String lamGrading = style.lamGrading();
	String lamWoodClass = style.woodClass();
	String lamWoodKindGrade = style.woodKind();
	
	Point3d ptTxt = _Pt0;

	CurvedStyle styles[] = CurvedStyle().getAllEntries();
	String sNames[] = CurvedStyle().getAllEntryNames();
	int nStyle = styles.find(style);
	String sName;
	if (nStyle>-1)sName = sNames[nStyle];
	
	dp.draw(sName, ptTxt, _XW,_YW, 1,-3);
	ptTxt.transformBy(-_YW*dTxtH*1.5);
	//dp.draw(T("|Lamella Structure|"), ptTxt, _XW,_YW, 1,-3);
	
	int nIndex;
	String sQuantities[0];double dMax1;
	String sQualities[0];double dMax2;
	String sThicknesses[0];double dMax3;
	double dColWidth[0];
	while (lamWoodClass .token(nIndex)!="")
	{

		String s = lamWoodClass.token(nIndex);	
		
	// count the , tokens, i fless then 3 assume quantity 1
		int nNumTokens;
		while (s .token(nNumTokens,",")!="")
			nNumTokens++;
		
		double d;	

		String sQuantity = "1 " + T("|pcs|");
		int nTokenIndex;
		if (nNumTokens>2) 
		{
			sQuantity = s.token(nTokenIndex++,",")+ " "+  T("|pcs|");
		}
		
		sQuantities.append(sQuantity);
		d= dp.textLengthForStyle(sQuantities[sQuantities.length()-1], sDimStyle);
		if (dMax1<d)dMax1=d;

		sQualities.append( s.token(nTokenIndex++,","));
		d= dp.textLengthForStyle(sQualities[sQualities.length()-1], sDimStyle);
		if (dMax2<d)dMax2=d;
		
		sThicknesses.append(dLamThickness+ " mm");// s.token(nTokenIndex++,","));
		d= dp.textLengthForStyle(sThicknesses[sThicknesses.length()-1], sDimStyle);
		if (dMax3<d)dMax3=d;		

		nIndex++;
	}

// draw schedule table
	for (int i=sQuantities.length()-1;i>=0;i--)
	{
		ptTxt.transformBy(-_YW*dTxtH*1.5);
		Point3d pt=ptTxt+dMax1*dFactor*_XW;
		dp.draw(sQuantities[i], pt, _XW,_YW, -1,-3);
		
		pt.transformBy(dTxtH*_XW);
		dp.draw(sQualities[i], pt, _XW,_YW, 1,-3);
		
		pt.transformBy((dTxtH+(dMax2+dMax3)*dFactor)*_XW);
		dp.draw(sThicknesses[i], pt, _XW,_YW, -1,-3);						
	}
	
	ptTxt.transformBy(-_YW*dTxtH*2);	
	Point3d pt1=ptTxt-_YW*.3*dTxtH;
	Point3d pt2=ptTxt+(7*dTxtH+(dMax2+dMax3)*dFactor)*_XW-_YW*.3*dTxtH;
	dp.draw(PLine(pt1, pt2) );
	
// draw press collection
	if (numPresses>0)
	{
	
		dp.draw(style.numLams() +" "+T("|pcs|")+" "  + T("|Lams in total|"), ptTxt, _XW,_YW, 1,-3);	
		ptTxt.transformBy(-_YW*dTxtH*2.5);		
		dp.draw(style.dryJointLamIndex() +". " + T("|Dry Joint|"), ptTxt, _XW,_YW, 1,-3);
		ptTxt.transformBy(-_YW*dTxtH*1.5);			
		dp.draw(T("|Zulage|") + " " + dOffsetPressBaseCurve + "mm", ptTxt, _XW,_YW, 1,-3);	

		ptTxt.transformBy(-_YW*dTxtH*2.5);		
		dp.draw(numPresses +" " + T("|pcs|")+" "+T("|Presses|"), ptTxt, _XW,_YW, 1,-3);

		if (nIndexRefPress>-1)
		{
			ptTxt.transformBy(-_YW*dTxtH*1.5);	
			dp.draw(nIndexRefPress+"=" + T("|Reference Press|"), ptTxt, _XW,_YW, 1,-3);
		}		
	}	
	
	

	
	
	
	
	
	
	
	
	


#End
#BeginThumbnail
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
0:U6I!*[W[%4J<);+[S__V;<;
`



#End
