#Version 8
#BeginDescription
version value="1.5" date="28oct2020" author="thorsten.huck@hsbcad.com"
HSB-8967 supports left side of container design

HSB-8560 new property height to specify bedding sizes
HSB-8456 new property distribution mode supports distribution by center of gravity, stack extents or truck extents 
HSB-8384 new property width visualizes the bedding location with width, grip positioniing supported

This tsl creates a bedding grid
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords Stacking;Bedding;Unterleger;LKW
#BeginContents
/// <History>//region
/// <version value="1.5" date="28oct2020" author="thorsten.huck@hsbcad.com"> HSB-8967 supports left side of container design  </version>
/// <version value="1.4" date="18aug2020" author="thorsten.huck@hsbcad.com"> HSB-8560 new property height to specify bedding sizes </version>
/// <version value="1.3" date="12aug2020" author="thorsten.huck@hsbcad.com"> HSB-8456 new property distribution mode supports distribution by center of gravity, stack extents or truck extents </version>
/// <version value="1.2" date="24jul2020" author="thorsten.huck@hsbcad.com"> HSB-8384 new property width visualizes the bedding location with width, grip positioniing supported </version>
/// <version value="1.1" date="25jul2017" author="thorsten.huck@hsbcad.com"> dim offset added </version>
/// <version value="1.0" date="12may2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select elect properties or catalog entry, press OK and select trucks
/// </insert>

/// <summary Lang=en>
/// This tsl creates a bedding grid
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "f_Grid")) TSLCONTENT

//endregion



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


	int nGridSizes[0];
	String sGridSizes[0];
	for (int i=2;i<14;i++) 
	{ 
		nGridSizes.append(i);
		sGridSizes.append(i + "x " +T("|Grid|"));
	}
	category = T("|Alignment|");
	String sGridSizeName=T("|Grid Size|");	
	PropString sGridSize(nStringIndex++, sGridSizes, sGridSizeName);	
	sGridSize.setDescription(T("|Defines the Grid Size|"));
	sGridSize.setCategory(category);
	
	String sModeName=T("|Mode|");	
	String sModes[] ={ T("|Center of Gravity|"), T("|Stack Extents|"), T("|Truck Extents|")};
	PropString sMode(nStringIndex++, sModes, sModeName);	
	sMode.setDescription(T("|Defines the distribution mode of hte bedding grid.|"));
	sMode.setCategory(category);

	String sEdgeOffsetName=T("|Edge Offset|");	
	PropDouble dEdgeOffset(nDoubleIndex++, U(300), sEdgeOffsetName);	
	dEdgeOffset.setDescription(T("|Defines the Edge Offset|"));
	dEdgeOffset.setCategory(category);

	category = T("|Geometry|");
	String sWidthName=T("|Width|");	
	PropDouble dWidth(nDoubleIndex++, U(60), sWidthName);	
	dWidth.setDescription(T("|Defines the width of the bedding|") + T(", |0 = show only axis location|"));
	dWidth.setCategory(category);

	String sHeightName=T("|Height|");	
	PropDouble dHeight(nDoubleIndex++, U(80), sHeightName);	
	dHeight.setDescription(T("|Defines the height of the bedding|"));
	dHeight.setCategory(category);
	
	
	

// defaults
	int nColor = 3;
	double dExtension = U(200);
	String sDimStyle=_DimStyles.length()>0?_DimStyles[0]:"";
	String sLinetype;
	double dLinetypeScale=1;
	double dTextHeight = U(80);
	double dDimOffset = U(200);
	
// settings
	String sDictEntries[] = {"f_Stacking"};
	Map mapSetting;
	String sDictionary = "hsbTSL";
	for(int i=0;i<sDictEntries.length();i++)
	{
		String sDictEntry = sDictEntries[i];		
		MapObject mo(sDictionary ,sDictEntry);
	// get the map
		if (mo.bIsValid()) 
		{
			mapSetting = mo.map();
			break;
		}
	}// next i

// read settings
	if (mapSetting.length()>0)
	{
		Map m = mapSetting.getMap("Truck").getMap("BeddingGrid");
		String k;
		// general
		k="Color";				if (m.hasInt(k))	nColor = m.getInt(k);
		k="DimStyle";			if (m.hasString(k))	sDimStyle = m.getString(k);
		k="Extension";			if (m.hasDouble(k))	dExtension = m.getDouble(k);
		k="DimOffset";			if (m.hasDouble(k))	dDimOffset = m.getDouble(k);
		k="LinetypeScale";		if (m.hasDouble(k))	dLinetypeScale = m.getDouble(k);
		k="Linetype";			if (m.hasString(k))	sLinetype = m.getString(k);
		k="TextHeight";			if (m.hasDouble(k))	dTextHeight = m.getDouble(k);	
	}

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
		
	// get items
		PrEntity ssE(T("|Select item(s)|"), TslInst());
	  	if (ssE.go())
			_Entity.append(ssE.set());

	// remove non truck grids
		Point3d pts[0];
		for (int i=_Entity.length()-1; i>=0 ; i--) 
		{
			Entity ent= _Entity[i];
			TslInst tsl = (TslInst)ent;
			if (tsl.bIsValid() && !tsl.map().getInt("isGrid"))
				_Entity.removeAt(i);	
			else
				pts.append(tsl.ptOrg());
		}

	// create TSL
		TslInst tslNew;	
		GenBeam gbsTsl[] = {};		Entity entsTsl[1];			Point3d ptsTsl[1];
		int nProps[]={};			double dProps[]={dEdgeOffset,dWidth,dHeight};				String sProps[]={sGridSize};
		Map mapTsl;	

	// insert one on one
		for (int i=0;i<_Entity.length();i++) 
		{ 
			entsTsl[0]= _Entity[i]; 
			ptsTsl[0]=pts[i];
			tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, 
				nProps, dProps, sProps,_kModelSpace, mapTsl);
			if (tslNew.bIsValid())
				tslNew.setColor(nColor);
		}

		eraseInstance();
		return;
	}	
// end on insert	__________________
	
// get parent truck grid
	if (_Entity.length()<1)
	{
		if(bDebug)reportMessage("\n"+ scriptName() + " invalid entity reference");
		eraseInstance();
		return;
	}
	
// get the potential link to the truck grid
	TslInst tslTruckGrid;
	for (int i=0;i<_Entity.length();i++) 
	{ 
		Entity e= _Entity[i]; 
		TslInst tsl = (TslInst)e;
		if (tsl.bIsValid() && tsl.map().getInt("isGrid"))
		{
			tslTruckGrid=tsl;
			setDependencyOnEntity(e);
			_ThisInst.assignToGroups(e,'I');
		}
	 
	}
	
// validate parent truck grid
	if (!tslTruckGrid.bIsValid())
	{
		if(bDebug)reportMessage("\n"+ scriptName() + " invalid entity reference");
		eraseInstance();
		return;
	}	

// standards
	Vector3d vecX = _XW;
	Vector3d vecY = _YW;
	Vector3d vecZ = _ZW;
	Point3d ptOrg = tslTruckGrid.ptOrg();	ptOrg.vis(6);
	_Pt0 = ptOrg;
	CoordSys cs(ptOrg, vecX, vecY, vecZ);
	//assignToElementGroup(el,true, 0,'E');// assign to element tool sublayer

// get potential spaces during creation
	if (_bOnDbCreated && _Map.hasInt("GridSpaces"))
	{
		int n = nGridSizes.find(_Map.getInt("GridSpaces"));
		if (n>-1)
		{
			sGridSize.set(sGridSizes[n]);
			setExecutionLoops(2);
		}
	}

// get the truck grid profile and potential Grid COG
	Map map = tslTruckGrid.map(), mapContacts;
	String k;
	PlaneProfile ppTruckGrid;
	Point3d ptCogGrids[0],ptXExtremes[0];
	int nAlignment = 1;
	k = "Grid"; 		if (map.hasPlaneProfile(k))		ppTruckGrid=map.getPlaneProfile(k);
	k = "CogGrid[]"; 	if (map.hasPoint3dArray(k)) 	ptCogGrids=map.getPoint3dArray(k);
	k = "ptXExtreme[]";	if (map.hasPoint3dArray(k)) 	ptXExtremes=Line(_Pt0, vecX).orderPoints(map.getPoint3dArray(k), dEps);
	k = "alignment";	if (map.hasInt(k)) 				nAlignment=map.getInt(k);
	Vector3d vecXDir = vecX * nAlignment;
	
	ppTruckGrid.vis(2);		
	//ptCogGrids.first().vis(40);

// get extents of profile
	LineSeg seg = ppTruckGrid.extentInDir(vecX);		//seg.vis(2);
	double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()))-2*dEdgeOffset;
	double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));

// get bounding pp
	PlaneProfile ppBound= ppTruckGrid;
	ppBound.shrink(-dExtension);
	ppTruckGrid.shrink(-dEps);
	ppBound.subtractProfile(ppTruckGrid);
	ppBound.vis(5);

// get distribution mode
	int nMode = sModes.find(sMode, 0);

// collector of dimpoints
	Point3d ptsDim[] = {_Pt0};

// get extents of bounds
	LineSeg segB = ppTruckGrid.extentInDir(vecX);
	
// if X-extremes are found reset the x-bounds to it
	int bHasX = ptXExtremes.length() > 1 && nMode!=2;
	if (bHasX)
	{ 
		Point3d ptStart = segB.ptStart();
		Point3d ptEnd = segB.ptEnd();
		ptStart += vecX * vecX.dotProduct(ptXExtremes.first() - ptStart);
		ptEnd += vecX * vecX.dotProduct(ptXExtremes.last() - ptEnd);
		segB = LineSeg(ptStart, ptEnd);	
	}
	segB.vis(3);
	double dXB = abs(vecX.dotProduct(segB.ptStart()-segB.ptEnd()));
	double dYB = abs(vecY.dotProduct(segB.ptStart()-segB.ptEnd()));


// Display
	Display dp(_ThisInst.color());	
	if (_DimStyles.find(sDimStyle)>-1)
		dp.dimStyle(sDimStyle);
	if (_LineTypes.find(sLinetype)>-1)
		dp.lineType(sLinetype,dLinetypeScale>0?dLinetypeScale:1);
	if (dTextHeight>0)
		dp.textHeight(dTextHeight);	

// reset grips
	if (_kNameLastChangedProp==sEdgeOffsetName || _kNameLastChangedProp==sModeName)
		_PtG.setLength(0);
		
	Point3d ptGripRef = segB.ptMid() + .5 * vecY * dYB;	ptGripRef.vis(2);
	Point3d pt= ptOrg+ vecXDir*dEdgeOffset;
	pt += vecY * (vecY.dotProduct(ptGripRef- pt) );
	
// move relative to first COG found
	double dXRange = (bHasX ? dXB : dX)-2*dEdgeOffset;
	if (ptCogGrids.length()>0 && nMode==0)
	{ 
		double dDeltaX = vecX.dotProduct(ptCogGrids.first() - segB.ptMid());
		dXRange -= 2*abs(dDeltaX);
		pt += vecX *vecX.dotProduct(ptCogGrids.first()-pt);
		pt += vecXDir * (-.5*dXRange);
	}pt.vis(2);

// get spaces
	int _nGridSize = sGridSizes.find(sGridSize);
	int nGridSize = _nGridSize>-1?nGridSizes[_nGridSize]:nGridSizes[0];
	double dInterdistance = dXRange/nGridSize;
	int nNumField = nGridSize + 1;	

	if (_PtG.length()!=nNumField || bDebug)
	{ 
		if (!bDebug)_PtG.setLength(0);
		for (int i=0;i<nNumField;i++)
		{ 
			pt.vis(i);
			if (!bDebug)_PtG.append(pt);
			pt.transformBy(vecXDir*dInterdistance);
		}
	}
	_PtG = Line(_Pt0, vecXDir).orderPoints(_PtG);

// distribute and draw
	int bHasEvenDistance=true;
	double dLastWidth;
	for (int i=0;i<_PtG.length();i++) 
	{ 
		
	// make sure they do not overlap	
		if (i>0)
		{
			double dXPrev=vecXDir.dotProduct(_PtG[i]-_PtG[i-1]);
			if(dXPrev<dWidth)
				_PtG[i].transformBy(vecXDir * (dWidth - dXPrev) * dXPrev / abs(dXPrev));
			
		// validate if the distribution has an even distance. on even distances only the first space is diemnsioned	
			if (dLastWidth>0 && abs(dLastWidth-dXPrev)>dEps)
				bHasEvenDistance = false;
			dLastWidth= dXPrev;	
		}
		_PtG[i] += vecY * (vecY.dotProduct(ptGripRef- _PtG[i]) );	
		
		
		Point3d pt = _PtG[i]+vecY*vecY.dotProduct(_Pt0-_PtG[i]);
		if (ptsDim.length()<3 || !bHasEvenDistance)
			ptsDim.append(pt);
		//pt.vis(i);
		
	// collect split segments
		LineSeg segBase(pt-vecY*dY, pt+vecY*dY);
		segBase.transformBy(-vecY*vecY.dotProduct(ptOrg-seg.ptMid()));//		segBase.vis(2);
		LineSeg segs[] = ppBound.splitSegments(segBase, true);
		
		if (dWidth<=0)
		{
			dp.draw(segs);
		}
		else
		{ 
			for (int j=0;j<segs.length();j++) 
			{ 
				LineSeg s = segs[j];
				Point3d pt1 = s.ptStart() - vecX * .5 * dWidth;
				Point3d pt2 = s.ptEnd() - vecX * .5 * dWidth;
				Point3d pt3 = s.ptEnd() + vecX * .5 * dWidth;
				Point3d pt4 = s.ptStart() + vecX * .5 * dWidth;
				
				s.vis(j);
				
				PLine pl;
				if (j%2==0)
					pl = PLine(pt3, pt4, pt1, pt2);
				else
					pl = PLine(pt1, pt2, pt3, pt4);
				dp.draw(pl);
				 
			}//next j
			
		}
		//pt.transformBy(vecX*dInterdistance);	 
	}
	
//region Add COG
	if(ptCogGrids.length()>0)
	{ 
		dp.color(1);
		Point3d pt = ptCogGrids.first();
		double radius = U(60);
		Point3d pts[] ={ pt + vecX * radius, pt + vecY * radius, pt - vecX * radius, pt - vecY * radius};
		
		PLine pl1(pts[0],pts[1],pts[2],pts[3]);
		pl1.close();

		PLine pl2 = PLine(pt, pts[0], pts[1]);	
		pl2.close();
		
		PLine pl3 = PLine(pt, pts[2], pts[3]);	
		pl3.close();

		for (int i=0;i<ptCogGrids.length();i++) 
		{ 
			pt = ptCogGrids[i]; pt.vis(3);
			
			pl1.transformBy((pt - pl1.ptStart())+vecX*radius);
			pl2.transformBy(pt - pl2.ptStart());
			pl3.transformBy(pt - pl3.ptStart());
			
			dp.draw(PlaneProfile(pl1));
			dp.draw(PlaneProfile(pl2), _kDrawFilled, 70);
			dp.draw(PlaneProfile(pl3), _kDrawFilled, 70);
		}//next i
	}

		
//End Add COG//endregion 	
	
	
	
// add dimline
	Point3d ptDimRef = segB.ptMid() - vecXDir * .5 * dXB + vecY * (.5 * dYB);ptDimRef.vis(4);
	ptsDim= Line(ptDimRef,vecXDir).projectPoints(ptsDim);
	DimLine dl(ptDimRef+vecY*dDimOffset, vecX, vecY);
	
	Point3d ptsA[] ={ ptsDim[0]};
	if (bHasEvenDistance && ptsDim.length()>1)
	{
		ptsA.append(ptsDim[1]);
		
		Point3d ptsB[]={ ptsDim[1],ptsDim[2]};
		Dim dimB(dl,ptsB, nGridSize+"x " +"<>", "<>", _kDimClassic, _kDimCumm);
		dp.draw(dimB);			
	}
	else
	{ 
		ptsA.append(_PtG);
	}
	Dim dimA(dl,ptsA, "<>", "<>", _kDimClassic, _kDimCumm);
	dp.draw(dimA);
	

	
	

#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
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
76:W]&T<Z7YC-,)&D`!`7`&*U:*`/_]ET
`




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
        <int nm="BreakPoint" vl="423" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End