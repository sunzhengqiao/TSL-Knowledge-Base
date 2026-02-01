#Version 8
#BeginDescription
version value="1.3" date="05dec2017" author="thorsten.huck@hsbcad.com"
grips transform with multipage transformation
orientation and default location changed

This tsl creates a pitch symbol in modelspace in dependency of a multipage
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords Multipage, Shopdrawing
#BeginContents
/// <History>//region
/// <version value="1.3" date="05dec2017" author="thorsten.huck@hsbcad.com"> grips transform with multipage transformation </version>
/// <version value="1.2" date="05dec2017" author="thorsten.huck@hsbcad.com"> orientation and default location changed </version>
/// <version value="1.1" date="14nov2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select multipage with active viewDataExporter, select properties or catalog entry and press OK.
/// </insert>

/// <summary Lang=en>
/// This tsl creates a pitch symbol in modelspace in dependency of a multipage
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

	category = T("|Display|");
	
	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, 7, sColorName);	
	nColor.setDescription(T("|Defines the Color|"));
	nColor.setCategory(category);

	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Overrides the textheight of the dimstyle|"));
	dTextHeight.setCategory(category);
	
	String sDimstyleName=T("|Dimstyle|");	
	PropString sDimstyle(nStringIndex++, _DimStyles, sDimstyleName);	
	sDimstyle.setDescription(T("|Defines the Dimstyle|"));
	sDimstyle.setCategory(category);


	category = T("|General|");	
	String sBaseLengthName=T("|Base Length|");	
	PropDouble dBaseLength(nDoubleIndex++, 2, sBaseLengthName);	
	dBaseLength.setDescription(T("|Defines the Base Length|"));
	dBaseLength.setCategory(category);

	String sScaleName=T("|Scale Factor|");	
	PropDouble dScale(nDoubleIndex++, 100, sScaleName,_kNoUnit);	
	dScale.setDescription(T("|Defines the Base Length|"));
	dScale.setCategory(category);	



// bOnInsert, manual insertion
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


	// SelectMultipage
		Entity ent = getEntity(T("|Select multipage|"));

		
	// get potential multipage as the entCollector
		
		if (ent.bIsValid() && ent.typeDxfName()=="HSBCAD_MULTIPAGE")
			_Entity.append(ent);
		else
		{
			reportMessage(ent.typeDxfName());
			eraseInstance();
		}
		_Map.setInt("CustomInsert", true);
		return;
	}	
// end on insert	__________________
	

// Viewport Data: declare the view data, later passed in through the entCollector
	ViewData viewDatas[0];
// trigger update on creation	
	if (_Entity.length()<1)
	{
		if (bDebug)reportMessage("\n" + scriptName() + ": " +T("|trigger update on creation|") + " " + _ThisInst.handle());
		_ThisInst.transformBy(Vector3d(0,0,0));
		return;
	}


// validate
	Entity entCollector;
	if (_Entity.length()<1 || _Entity[0].typeDxfName()!="HSBCAD_MULTIPAGE")
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|could not get multipage.|") + ":  " + _Entity);
		eraseInstance();
		return;
	}
	else
	{
		entCollector = _Entity[0];
		setDependencyOnEntity(entCollector);
		if(bDebug)reportMessage("\n"+ scriptName() + " entCollector _Pt0 " + entCollector.coordSys().ptOrg());
	}

// get coordSys from entCollector
	CoordSys csEntCollector = entCollector.coordSys(); //csEntCollector.vis(6);
	_Pt0 = csEntCollector.ptOrg();_Pt0.vis(4);
	Map mpShopdrawData = entCollector.subMapX("mpShopdrawData");
	viewDatas = ViewData().convertFromSubMap( mpShopdrawData, _kOnGenerateShopDrawing + "\\" + _kViewDataSets, 2); 
	Map mpViewDatas = mpShopdrawData.getMap(_kOnGenerateShopDrawing + "\\ViewData[]");


// update grips if multipage was moved
	Point3d ptPrev = _Pt0;
	if (_Map.hasVector3d("vecOrg"))
		ptPrev = _PtW+_Map.getVector3d("vecOrg");
	if (Vector3d(ptPrev-_Pt0).length()>dEps)
	{ 
		if (bDebug)reportMessage("\n updating grip locations" + entCollector.typeDxfName());
		for (int i=0;i<_Map.length();i++) 
		{ 
			if (_Map.hasVector3d("vec"+i) && _PtG.length()>i)
			{ 
				_PtG[i]=_Pt0+_Map.getVector3d("vec"+i);	
				if (bDebug)reportMessage("\n updating grip " + i + " " + _PtG[i]);
			}
		}
	}



/// validate settings
	if (dScale <= dEps) dScale.set(1);
	if (dBaseLength <= dEps) dBaseLength.set(U(10));
	


/// declare a display
	Display dp(nColor);
	dp.dimStyle(sDimstyle);
	if (dTextHeight>0)
		dp.textHeight(dTextHeight);


// grip indices
	int nIndex;

// loop the views
	for(int i=0; i<viewDatas.length(); i++)
	{ 
		ViewData vd = viewDatas[i];
		CoordSys cs = vd.coordSys();
		cs.transformBy(csEntCollector);
		
	// get the defining entities from this view
		Entity ents[] = vd.showSetDefineEntities();
		
	// look for a defining genbeam
		GenBeam gb;
		for (int j=0;j<ents.length();j++) 
		{ 
			if (gb.bIsValid())break;// take the first
			GenBeam _gb = (GenBeam)ents[j]; 
			if (_gb.bIsValid())
				gb = _gb;
		}
		if ( ! gb.bIsValid())continue;
		
	// get the coordSys and transform to model
		CoordSys csGb = gb.coordSys();
		csGb.transformBy(cs);// using cs transforms from block space to model	

	// get view port profile
		Map mpViewData = mpViewDatas.getMap(i);
		PlaneProfile ppShopdrawView = mpViewData.getPlaneProfile("ppShopdrawView");
		ppShopdrawView.vis(i+1);

	// find relevant vecs
		Vector3d vecX=csGb.vecX(), vecY=csGb.vecY(), vecZ=csGb.vecZ();
		vecX.normalize();
		vecY.normalize();
		vecZ.normalize();
		
		Vector3d vecsX[] ={ vecX, vecY, vecZ};
		Vector3d vecsMirr[] ={ vecY, vecZ, vecX};
		Vector3d vecsZ[] ={ vecZ, vecX, vecY};
		
		double dMax;
//		vecX.vis(pt,2);
//		vecY.vis(pt,4);
		for (int j=0;j<vecsZ.length();j++) 
		{ 
			double d = abs(_ZW.dotProduct(vecsZ[j])); 
			if (d>dMax)
			{ 
				vecX = vecsX[j];
				vecY = vecsMirr[j];
				vecZ = vecsZ[j];
				dMax = d;
			}
		}
		
	// align with X
		if (abs(vecX.dotProduct(_YW))>abs(vecX.dotProduct(_XW)))
		{ 
			Vector3d vec = vecY;
			vecY = vecX;
			vecX = vec;
		}
		
	// positive X
		if (vecX.dotProduct(_XW)<0)
		{ 
			vecX *= -1;
			vecY *= -1;
		}
	
	// positive coordSys
		vecY = vecX.crossProduct(-vecZ);
		
	// skip parallel
		if (vecX.isParallelTo(_XW) || vecY.isParallelTo(_YW))
		{
			continue;
		}

	
	// flag if triangle and location to be mirrored
		int bMirror = vecX.dotProduct(_YW) > 0;

	//  default location
		LineSeg seg = ppShopdrawView.extentInDir(_XW); seg.vis(i);
		double dX = abs(_XW.dotProduct(seg.ptStart()-seg.ptEnd()));
		double dY = abs(_YW.dotProduct(seg.ptStart()-seg.ptEnd()));
		Point3d pt = seg.ptMid() - .5 * ((bMirror?1:-1)*_XW * dX - _YW * dY);pt.vis(1);
		nIndex++;
		if (dX>dEps)
		{
		// create a new grip if not found
			if (_PtG.length()<nIndex)
			{ 
				if(!_Map.getInt("CustomInsert"))
				{
					pt.transformBy(csEntCollector);
					
				}
				_PtG.append(pt);

			}
		// grip has been found
			else
			{ 
			// if this instance is created by a multipage the grip needs to be updated. afterwards it will be treated as if inserted in modelspace
				if(!_Map.getInt("CustomInsert"))
				{
					_PtG[nIndex - 1] = pt;
					_Map.setInt("CustomInsert", true);
				}
			// 
				else
					pt = _PtG[nIndex-1];
			}	
		}
		_Map.setVector3d("vec"+(nIndex-1),pt-_Pt0);	
		if (bDebug)reportMessage("\n set grip " + (nIndex-1) + " " + pt);
		
		Vector3d vecXM = -_XW;
		if (!bMirror)
		{ 
			vecXM *= -1;
			
		}
		else
		{ 
			vecX*= -1;
			vecY*= -1;
			pt -= vecXM * dScale * dBaseLength;
		}
		
		
	// get the angle
		double dAngle = vecX.angleTo(vecXM);
	
	// collect triangle vertices
		Point3d pts[] = { pt};
		pts.append(pt + vecXM * dScale * dBaseLength);
		pts.append(Line(pt,vecX).intersect(Plane(pts[pts.length()-1], vecXM),0));
		
	// draw pitch
		PLine plTriangle(_ZW);
		for (int i=0;i<pts.length();i++) 
		{
			pts[i].vis(i);
			plTriangle.addVertex(pts[i]);
		}
		plTriangle.close();
		plTriangle.vis(2);
		dp.draw(plTriangle);

		vecX.vis(pts[0],1);
		vecXM.vis(pts[0],3);


		PLine plArc(_ZW);
		plArc.addVertex(pt + vecXM * dScale * dBaseLength * .3);
		plArc.addVertex(pt + vecX * dScale * dBaseLength * .3, tan((bMirror?1:-1)*.25*dAngle));
		//if (bMirror)plArc.transformBy(csMirr);
		dp.draw(plArc);
		
	// text
		
		dp.draw(dBaseLength, (pts[0] + pts[1]) / 2, _XW, _YW, 0, 1.5);
		String s; s.formatUnit((pts[1]-pts[2]).length()/dScale, sDimstyle);
		dp.draw(s, (pts[1] + pts[2]) / 2, _XW, _YW, (bMirror?-1.5:1.5), 0);
		
		s.formatUnit(dAngle, sDimstyle);
		dp.draw(s+"°", pts[0], _XW, _YW, 0, 2.5);
		
		
	}
	
// store the current location 
	if(bDebug)reportMessage("\n"+ scriptName() + " _Pt0 " + _Pt0);
	
	_Map.setVector3d("vecOrg",_Pt0-_PtW);	
	
	
	
#End
#BeginThumbnail
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
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%5)]3LK:_M;":ZC2[NMWD0EOG?:"20/0`'FK=`!1110`4444`%%%5;'4
MK+4TF>QN8[A(93#(T9R`XQD9]LB@"U1110`4444`%%%%`!1110`4444`%%(S
M*B%F8*H&22>!21R)+&LD;;D894^HH`=1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!117&^.?%0TJV.GV<G^FRCYV'_
M`"R4_P!3V_/TK*M6C1@YSV-\-AYXBHJ<-V0Z_P#$./3-1>SL;9+GR^'E:3"[
MNX'KBN=O?BIJD,#2"VLXP.GRL6_]"KE;2TGOKJ.UMHFEFD;"JO.37,ZU]ICU
M.>TN4,;VTC1E/0@X->!#%XFM)RO:/]:'V%/*\'32@XIR\_S/HCP/XA?Q-X7@
MU"?8+G>\<RH.`P/'_CI4_C6GK=U+8Z!J5W`0)8+665"1G#*I(_45Y/\`!;6/
M*U"_T=V^69!/$"?XEX;\P1_WS7J7B;_D5-8_Z\9O_0#7OX>?/!-GRF94/88B
M45MNOF?/7PMU*]U7XNZ?>W]S)<W,HF+R2-DG]T_Z>U?35?(G@+Q#:^%O&%GK
M%[%-);P+(&6$`L=R,HQD@=2.]>G7/[0B"<BU\.,\0/#2W>UC^`0X_.NVK!R>
MAY%&I&,?>9[;17#^!_B?I/C29K-(9++457?]GE8,'`Z[6XSCTP#^M:OB_P`;
M:1X+L$N-1=WEE)$-O$`7DQU^@'<FL>5WL=//&W-?0Z.BO"KC]H.X\T_9_#T2
MQ]O,NB3^BBK^D?'V"YNXH-0T&2(2,%$EO.'Y)Q]T@?SJO93[$>WAW+/QXUW4
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
-@M'&JDCID"IZ*`/_V9_.
`


#End