#Version 8
#BeginDescription
version value="1.0" date="22nov2017" author="thorsten.huck@hsbcad.com"
initial

This tsl draws the numbers of the referenced single elements of a multi element in layout
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
/// <History>//region
/// <version value="1.0" date="22nov2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select viewport and insertion point, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl draws the numbers of the referenced single elements of a multi element in layout
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
	ElementMulti em = (ElementMulti)el;
	
// Display
	Display dp(0);	
	if (!em.bIsValid())return;// only proceed for multi elements	
	
	double dHeight = dTextHeight;
	dp.dimStyle(sDimStyle);
	if (dTextHeight>0)
		dp.textHeight(dTextHeight);
	else
		dHeight = dp.textHeightForStyle("O", sDimStyle);		
	
	
// coordSys	
	CoordSys cs=el.coordSys();
	cs.transformBy(ms2ps);
	Point3d ptOrg= cs.ptOrg();
	Vector3d vecX=_XW,vecY=_YW,vecZ=_ZW;

	
// transform _Pt0 to base line
	_Pt0 += vecX * vecX.dotProduct(ptOrg - _Pt0);
	_Pt0.setZ(0);
	vecX.vis(_Pt0, 1);
	vecY.vis(_Pt0, 3);
	vecZ.vis(_Pt0, 150);
	
	
// collect all single refs
	SingleElementRef sers[] = em.singleElementRefs();
	
// collect extents and display number
	for (int i=0;i<sers.length();i++) 
	{ 
		LineSeg seg = sers[i].segmentMinMax();
		seg.transformBy(ms2ps);
		seg.vis(3);
		
		Point3d pt = seg.ptMid() + vecY * vecY.dotProduct(_Pt0 - seg.ptMid());
		
		dp.draw(sers[i].number(), pt, vecX, vecY, 0, 1);
		
	}
	
	
	
	
#End
#BeginThumbnail

#End