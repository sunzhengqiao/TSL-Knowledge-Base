#Version 8
#BeginDescription
version value="1.1" date="19dec2017" author="thorsten.huck@hsbcad.com"
deactivated for multiwalls
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords Layout;Element
#BeginContents
/// <History>//region
/// <version value="1.1" date="19dec2017" author="thorsten.huck@hsbcad.com"> deactivated for multiwalls </version>
/// <version value="1.0" date="22nov2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select viewport and pick reference point, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a level marker 
/// </summary>//endregion




// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	//endregion

//Display
	category = T("|Display|");
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles, sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);
	
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the Text Height|") + " " + T("|0 = byDimstyle|"));
	dTextHeight.setCategory(category);

	String sUnits[] = {"mm", "cm", "m", "in", "ft"};
	String sUnitName=T("|Units|");	
	PropString sUnit(nStringIndex++, sUnits, sUnitName,2);	
	sUnit.setDescription(T("|Defines the Unit|"));
	sUnit.setCategory(category);

	String sDecimalName=T("|Decimals|");	
	PropInt nDecimal(nIntIndex++, 3, sDecimalName);	
	nDecimal.setDescription(T("|Defines the Decimals|"));
	nDecimal.setCategory(category);

	String sStyleName= T("|Style|");
	String sStyles[] = {T("|Finished Floor|"), T("|Unfinished Floor|")};
	PropString sStyle(nStringIndex++, sStyles,sStyleName);
	sStyle.setDescription(T("|Defines the symbol style|"));
	sStyle.setCategory(category);




// bOnInsert
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
		
		Viewport vp = getViewport(T("|Select a viewport|")); // select viewport
		_Pt0 = getPoint(); // select point
  		_Viewport.append(vp);
  		
  		
		return;
	}	
// end on insert	__________________
	

// do something for the last appended viewport only
	if (_Viewport.length()==0) return; // _Viewport array has some elements
	Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
	_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
	if (!vp.element().bIsValid()) return;

	CoordSys ms2ps = vp.coordSys();
	CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
	Element el = vp.element();	

	CoordSys cs=el.coordSys();
	cs.transformBy(ms2ps);
	Point3d ptOrg= cs.ptOrg();
	Vector3d vecX=cs.vecX(),vecY=cs.vecY(),vecZ=cs.vecZ();
	vecX.normalize();
	vecY.normalize();
	vecZ.normalize();
	
// transform _Pt0 to base line
	_Pt0 += vecY * vecY.dotProduct(ptOrg - _Pt0);
	_Pt0.setZ(0);
	vecX.vis(_Pt0, 1);
	vecY.vis(_Pt0, 3);
	vecZ.vis(_Pt0, 150);

// ints
	int nUnit = sUnits.find(sUnit, 2);
	int nStyle = sStyles.find(sStyle,0);

	Point3d ptOrgMS = el.coordSys().ptOrg();

// Display
	Display dp(0);
	double dHeight = dTextHeight;
	dp.dimStyle(sDimStyle);
	if (dTextHeight>0)
		dp.textHeight(dTextHeight);
	else
		dHeight = dp.textHeightForStyle("O", sDimStyle);


// do not show anything for multiwalls
	if (el.bIsKindOf(ElementMulti()))
		return;


// get reference points by transformed outline
	PLine pl = el.plOutlineWall();
	pl.transformBy(ms2ps);
	Point3d pts[] = pl.vertexPoints(true);
	
// side	
	int nSide = 1;
	Point3d ptMid;ptMid.setToAverage(pts);ptMid.vis(4);
	if (vecZ.dotProduct(_Pt0-ptMid)<0)
		nSide *= -1;
	
	pts = Line(_Pt0, -vecZ * nSide).orderPoints(pts);
	Point3d ptRef;
	if (pts.length()>0)
		ptRef = pts[0];
	ptRef.setZ(0);	
	ptRef.vis(6);


		
	
// draw	
	// guide line
	double dX = abs(_XW.dotProduct(_Pt0 - ptRef));
	if (dX>1.2*dHeight)
		dp.draw(PLine(_Pt0-_XW * nSide*dHeight, ptRef));
	
	// base line
	dp.draw(PLine(_Pt0+_XW*.75*dHeight, _Pt0-_XW*.75*dHeight));
	
	PLine plTriangle(_Pt0, _Pt0 + (_YW + .75*_XW) * dHeight , _Pt0 + (_YW - .75*_XW) * dHeight, _Pt0);
	
	// finished
	if (nStyle==0)
		dp.draw(plTriangle);
	// raw
	else if (nStyle==1)
		dp.draw(PlaneProfile(plTriangle), _kDrawFilled);

// get value and format unit


	double dZ = (_ZW.dotProduct(ptOrgMS - _PtW)) ;
	if (nUnit==1)
		dZ/= U(1,"cm");
	else if (nUnit==2)
		dZ/= U(1,"m");
	else if (nUnit==3)
		dZ/= U(1,"in");				
	else if (nUnit==4)
		dZ/= U(1,"ft");
		
// string builder
	String sText;
	if (nUnit<3)
	{ 
		sText.formatUnit(dZ, 2, nDecimal);
		if (nDecimal>0 && sText=="0")
			sText += ".";
			
		int n = nDecimal-(sText.length()-sText.find(".",0)-1);
		for (int i=0;i<n;i++) 
		{ 
			sText += "0";
		}		
	}
	else
		sText.formatUnit(dZ, 4, nDecimal);

	if (abs(dZ)<dEps)
		sText = "±" + sText;
	else if (dZ>dEps)	
		sText = "+" + sText;
	dp.draw(sText,_Pt0 + _YW * dHeight,  _XW, _YW, 0, 1.2);
#End
#BeginThumbnail


#End