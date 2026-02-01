#Version 8
#BeginDescription
version value="1.0" date="14dec2018" author="thorsten.huck@hsbcad.com"> initial
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <History>//region
/// <version value="1.0" date="14dec2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry, pick location and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl place text on a panel and exports it as marker without marking line
/// </summary>

/// commands
// command to insertan instance
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-PrintText")) TSLCONTENT

//endregion



//region constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end constants//endregion

	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "@(Posnum) @(SolidLength)", sFormatName);	
	sFormat.setDescription(T("|Defines the format of the composed value.|")+
		TN("|Samples|")+
		TN("   |We love CLT|")+ T(" |any text with not variables|")+
		TN("   @(Label)@(SubLabel)")+
		TN("   @(Label:L2) |the first two characters of Label|")+
		TN("   @(Label:T1; |the second part of Label if value is separated by blanks, i.e. 'EG AW 2' will return AW'|)")+
		TN("   @(Width:RL1) |the rounded value of width with one decimal.|")+
		TN("R |Right: Takes the specified number of characters from the right of the string.|")+
		TN("L |Left: Takes the specified number of characters from the left of the string.|")+
		TN("S |SubString: Given one number will take all characters starting at the position (zero based).|")+
		T(" |Given two numbers will start at the first number and take the second number of characters.|")+
		TN("T |​Tokeniser: Returns the member of a delimited list using the specified index (zero based). A delimiter can be specified as an optional parameter with the default delimiter being the semcolon character..|")+
		TN("# |Rounds a number. Specify the number of decimals to round to. Trailing zero's are removed.|")+
		TN("RL |​Round Local: Rounds a number using the local regional settings..|")
	);
	sFormat.setCategory(category);
	
	category = T("|Alignment|");
	String sAlignments[] = { T("|Reference Side|"), T("|Opposite Side|")};
	String sAlignmentName=T("|Alignment|");	
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the Alignment|"));
	sAlignment.setCategory(category);
	
	int nXPosTexts[] = { _kLeft,_kCenter,_kRight,_kLeft,_kCenter,_kRight,_kLeft,_kCenter,_kRight};
	int nYPosTexts[] = { _kBottom,_kBottom,_kBottom,_kCenter,_kCenter,_kCenter,_kTop, _kTop,_kTop};
	String sTextPositions[] = { T("|bottom|")+T(" |left|"), T("|bottom|")+T(" |center|"), T("|bottom|")+T(" |right|"),
		T("|center|")+T(" |left|"), T("|center|")+T(" |center|"), T("|center|")+T(" |right|"),
		T("|top|")+T(" |left|"), T("|top|")+T(" |center|"), T("|top|")+T(" |right|")};
	String sTextPositionName=T("|Text Position|");	
	PropString sTextPosition(nStringIndex++, sTextPositions, sTextPositionName);	
	sTextPosition.setDescription(T("|Defines the TextPosition|"));
	sTextPosition.setCategory(category);
	
	String sTextOrientations[] = { T("|Positive X-Axis|"),T("|Positive Y-Axis|"), T("|Negative X-Axis|"), T("|Negative Y-Axis|")};
	String sTextOrientationName=T("|Text Orientation|");	
	PropString sTextOrientation(nStringIndex++, sTextOrientations, sTextOrientationName);	
	sTextOrientation.setDescription(T("|Defines the TextOrientation|"));
	sTextOrientation.setCategory(category);

	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(50), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the TextHeight|"));
	dTextHeight.setCategory(category);
	
	
	
	

// bOnInsert//region
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
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
				setPropValuesFromCatalog(sLastInserted);					
		}	
		else	
			showDialog();
		
		_Sip.append(getSip());
		_Pt0 = getPoint();
		return;
	}	
// end on insert	__________________//endregion

// declare panel standards
	if (_Sip.length()<1)
	{
		reportMessage("\n" + scriptName() + ": " +T("|Invalid reference.|") + " " + T("|Tool will be deleted|"));
		eraseInstance();
		return;
	}

	Sip sip = _Sip[0];
	Vector3d vecX = sip.vecX();
	Vector3d vecY = sip.vecY();
	Vector3d vecZ = sip.vecZ();
	Point3d ptCen = sip.ptCenSolid();
	double dZ = sip.dH();
	vecX.vis(ptCen,1);vecY.vis(ptCen,3);vecZ.vis(ptCen,150);
	
	setEraseAndCopyWithBeams(_kBeam0);
	assignToGroups(sip, 'I');

//region ints and doubles
	int nTextPosition = sTextPositions.find(sTextPosition);
	int nTextOrientation = sTextOrientations.find(sTextOrientation);
	int nXPosText = (nTextPosition>-1 && nXPosTexts.length()>nTextPosition)?nXPosTexts[nTextPosition]:_kCenter;
	int nYPosText = (nTextPosition>-1 && nYPosTexts.length()>nTextPosition)?nYPosTexts[nTextPosition]:_kCenter;
	int nAlignment = sAlignments.find(sAlignment);	
	
	double dTextHeightDisplay = dTextHeight > 0 ? dTextHeight : U(50);
	double dTextHeightMark = dTextHeight > 0 ? dTextHeight : 0;
	
//End ints//endregion 


// TriggerFlipSide
	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContext, sTriggerFlipSide );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
	{
		nAlignment = nAlignment == 0 ? 1 : 0;
		sAlignment.set(sAlignments[nAlignment]);
		setExecutionLoops(2);
		return;
	}

// location of text
	Vector3d vecFace = nAlignment==0?-vecZ:vecZ;
	Point3d ptFace = ptCen + vecFace * .5 * dZ;
	_Pt0 = Line(ptCen + vecFace * .5 * dZ, vecX).closestPointTo(_Pt0);
	vecFace.vis(_Pt0, 2);

// get shape
	PlaneProfile pp = sip.realBody().extractContactFaceInPlane(Plane(ptFace, vecFace), dEps);
	pp.shrink(dTextHeightMark);
	LineSeg segs[] = pp.splitSegments(LineSeg(_Pt0 - vecX * U(10e3), _Pt0 + vecX * U(10e3)), true);
	
	double dMin = U(10e3);
	Point3d ptX=_Pt0;
	for (int i=0;i<segs.length();i++) 
	{ 
		Point3d pt = segs[i].closestPointTo(_Pt0);
		double d = (pt - _Pt0).length();
		if (d<dMin)
		{ 
			dMin = d;
			ptX = pt;
			
		}
		 
	}//next i
	_Pt0 = ptX;

	
// resolve format
	String sText = sip.formatObject(sFormat);

// add mark
	Mark mrk(_Pt0,vecFace, sText);
	if (dTextHeightMark>0)mrk.setTextHeight(dTextHeightMark);
	mrk.setTextPosition(nXPosText,nYPosText,nTextOrientation);
	mrk.suppressLine();
	sip.addTool(mrk);

// draw
	Vector3d vecXRead=vecX, vecYRead=vecY;
	if (nAlignment==0)
		vecXRead *= -1;	
	if (nTextOrientation==1 || nTextOrientation==3 )
	{ 
		Vector3d vec = vecXRead;
		vecXRead = vecYRead;
		vecYRead = -vec;
	}
	else if (nTextOrientation==2 || nTextOrientation==3)
		vecXRead *= -1;
		
	Display dp(-1);
	dp.textHeight(dTextHeightDisplay);
	dp.draw(sText,_Pt0,vecXRead,vecYRead,nXPosText,nYPosText);
	
	
		
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="139" />
        <int nm="BreakPoint" vl="213" />
        <int nm="BreakPoint" vl="70" />
        <int nm="BreakPoint" vl="200" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End