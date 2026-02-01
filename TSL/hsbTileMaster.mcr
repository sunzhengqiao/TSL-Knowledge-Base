#Version 8
#BeginDescription
/// Version 2.5   25.05.2009   th@hsbCAD.de























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 5
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Dieses Tsl erzeugt eine Vorverteilung von frei definierbaren Dachziegeltypen und bereitet
/// die dachflächenbezogene Auswertung vor. Nach erfolgter Berechnung listet dieses TSL all Ziegeltypen
/// grafisch auf
/// </summary>

/// <insert>
/// To insert this tsl select a set of roofplanes and pick an insertion point. Modify optional the roofplanes due to
/// the distribution limitations of the tiles selected. Afterwards use the context commands to generate the distribution.
/// </insert>

/// <remark Lang=de>
/// benötigt XML-Bibliothek und weitere TSL's
/// <hsbCompany>\abbund\hsbTileCatalog.xml
/// hsbTileSingle, hsbTileEdge
/// </remark>

/// <remark Lang=en>
///requires XML-library and additional TSL's
/// <hsbCompany>\abbund\hsbTileCatalog.xml
/// hsbTileSingle, hsbTileEdge
/// </remark>

/// <version  value="2.5" date="25mai09"></version>

/// <History Lang=de>
/// Version 2.5   25.05.2009   th@hsbCAD.de
/// Translation issue fixed
/// Version 2.4   24.03.2009   th@hsbCAD.de
/// bugfix orientation
/// DE   bugFix Dachelementkontur
/// EN   bugFix contour detection of complex roof elements
/// Version 2.2   31.10.2007   th@hsbCAD.de
///    - neue Option 'Auto-Update nach Änderungen' erhöht Leistung wenn deaktiviert
///    - Gruppenindex der einzelnen Dachflächen beginnt mit 1
/// Version 2.1   15.10.2007   th@hsbCAD.de
/// 29.08.07	th@hsbCAD.de	detection of laths which are closed to the ridge with a large offset to the roofplane enhanced
/// 11.10.07	th@hsbCAD.de	roofelements which are parallel but not in the same plane do not mix up lath assignment anymore
/// 15.10.07	th@hsbCAD.de	2.1 project name and number dispalyed in header
/// 31.10.07	th@hsbCAD.de	2.1 setExecutionLoops on add/delete/modify optional 1 or 2
///								Autogrouping starts with index 1
/// 30.11.07	th@hsbCAD.de bugFix contour detection of complex roof elements
/// </History>


// basics and props
	U(1,"mm");
	String sPath = _kPathHsbCompany+ "\\Abbund\\hsbTileCatalog.xml";	
	String sArNY[] = {T("|No|"),T("|Yes|")};
	// read articles from xml database
	Map mapX;
	mapX.readFromXmlFile(sPath);
	String sProducts[0];
	Point3d ptMapIndex[0];
	for (int m = 0; m < mapX.length();m++)
		if (mapX.hasMap(m))
		{
			Map mapXType = mapX.getMap(m);
			if (mapXType.hasMap("Area"))
			{
				int n = mapXType.indexAt("Area");
			mapXType = mapXType.getMap("Area");	
				for (int o = 0; o < mapXType.length();o++)	
					if(mapXType.hasMap(o))	
					{	
						sProducts.append(mapX.keyAt(m) + ";" + mapXType.keyAt(o));
						ptMapIndex.append(Point3d(m,n,o))	;
					}
			}
		}	
	PropString sTileProduct(2,sProducts,T("Supplier / Product"));
	PropString sGroup(1,"",T("|Auto group analysis BOM (seperate Level by '\')|"));	
	sGroup.setDescription(T("|Determines the second level group of the tsl (seperate level by '\')|"));	
	PropDouble dDeltaL(0, U(0), T("|Offset left|"));
	dDeltaL.setDescription(T("|Determines the offset of the lath contour to the roof outline|"));	
	PropDouble dDeltaR(1, U(0), T("|Offset right|"));	
	dDeltaR.setDescription(T("|Determines the offset of the lath contour to the roof outline|"));		
	PropString sDimStyle(0,_DimStyles,T("Dimstyle"));
	
	PropString sAutoUpdate(3,sArNY,T("|Auto update after changes|"));	
	sAutoUpdate.setDescription(T("|This option triggers the automatic update after modifications through the context menu. If set to NO the performace will increase but one has to fire the update or hsb_Recalc on the instance.|"));		
	
	PropInt nColor(0,252,T("|Color|"));

	// structuring not implemented yet
	//PropString sHideStructure(3,"",T("Hide structure"));
	//sHideStructure.setDescription(T("|Enter the levels to be hidden. 0 = Roofplanes, 1 = Sum, sepeperate entries by|") + " ';'");
	//PropString sHideColumn(4,"",T("Hide column"));
	//sHideColumn.setDescription(T("|Enter the columns to be hidden. 0 = Roof, 2 = Qty, 3 = Article #, 4 = Desc, 5 = Info|") + " ';'");
		
	setExecutionLoops(1);

	Map mapTileArea, mapTileRidge;	
	
// on insert
	if (_bOnInsert){
		if (insertCycleCount()>1) { eraseInstance(); return; }
		showDialog();		

	

	//get roofelement sset	
		PrEntity ssRP(T("Select roofplanes and (optional) tsl instances to delete"), ERoofPlane());
		ssRP.addAllowedClass(TslInst());
		ERoofPlane er0[0];
  		if (ssRP.go()){
			Entity ents[0];
    		ents = ssRP.set();
			int nCountERoofs = 0;
			for (int i = 0; i < ents.length(); i++){
				if (ents[i].bIsKindOf(ERoofPlane()))
				{
					// store as entity in global map
					_Map.setEntity("er" + nCountERoofs , ents[i]);
					nCountERoofs++;
				}
				else if(ents[i].bIsKindOf(TslInst()))
				{
					// check tsl name
					TslInst tslDelete;
					tslDelete = (TslInst)ents[i];
					String sScriptName = tslDelete.scriptName();
					sScriptName.makeUpper();
					if (sScriptName == "HSBTILEMASTER" || sScriptName == "HSBTILESINGLE" || sScriptName == "HSBTILEEDGE")	
						tslDelete.dbErase();
					
				}
			}
		}
		_Pt0 = getPoint(T("Insertion point of table"));
		_Map.setPoint3d("ptRef",_Pt0,_kAbsolute);
		return;
	}
// end on insert

// add triggers
	String sTrigger[] = {T("|Update|"), T("|append roofplanes|"), T("|create Tiles|"), "_________________",
		T("|Delete tiles|"),T("|Add tiles|"),T("|Modify tile|"), "________________",T("|append roof edge|"),T("|read catalog|")};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);	

// supplier and product information, set val readonly
	String sSupplier, sProduct;
	sSupplier = sTileProduct.token(0);
	sProduct = sTileProduct.token(1);

	// store selected tile product in map
	if (!_Map.hasMap("TileArea") ||(_bOnRecalc && _kExecuteKey==sTrigger[9]))
	{
		mapTileArea = mapX.getMap(sSupplier).getMap("Area").getMap(sProduct);	
		mapTileRidge = mapX.getMap(sSupplier).getMap("RidgeHip").getMap(sProduct);		
		_Map.setMap("TileArea", mapTileArea);
		_Map.setMap("TileRidge", mapTileRidge);	
	}
	else
	{
		mapTileArea = _Map.getMap("TileArea");	
		mapTileRidge 	 = _Map.getMap("TileRidge");
	}
	sTileProduct.setReadOnly(TRUE);

// Group
	int bAutoGroup = FALSE;
	if (sGroup != "")
	{
		Group gr();
		gr.setName(sGroup);
		String s2Group = gr.namePart(1);
		// make sure user has given 2nd level group
		if (s2Group != "")
		{
			s2Group = gr.namePart(0) + "\\" + s2Group;
			sGroup.set(s2Group);// limit to 2nd level
			gr.setName(s2Group);
			gr.addEntity(_ThisInst, TRUE);
			bAutoGroup = TRUE;
		}
	}
	


// trigger0: update
	if (_bOnRecalc && _kExecuteKey==sTrigger[0]) 
	{
	 	reportMessage("\n" + T("|Updating|" + " " + scriptName() + "..."));
	}

// trigger1: append roofplanes
	if (_bOnRecalc && _kExecuteKey==sTrigger[1]) 
	{
		// validate all map entries
		int n = _Map.length();
		int m = 0;
		for (int i = 0; i < n; i++)
		{
			String sKey = _Map.keyAt(m);
			if (sKey.left(2) == "er")
			{
				Entity ent;
				ent = _Map.getEntity(m);
				if (!ent.bIsValid())
					_Map.removeAt(m,FALSE);
				else
					m++;
			}		
		}
		
		//get roofelement sset	
		PrEntity ssRP(T("Select roofplanes"), ERoofPlane());
		if (ssRP.go())
		{
			Entity ents[0];
    		ents = ssRP.set();
			for (int i = 0; i < ents.length(); i++)
			{
				// find next free index
				int nFree;
				for (int m = 0; m < _Map.length(); m++)
					if (_Map.keyAt(m) == "er"+nFree)
						nFree++;
				_Map.setEntity( "er"+nFree, ents[i]);
			}
		}	
	}

// find valid roofplane
	ERoofPlane er[0];

	for (int i = 0; i < _Map.length(); i++){
		Entity ent;
		if (_Map.hasEntity("er" + i))
		{
			ent =  _Map.getEntity("er" + i);
			if (_Entity.find(ent)< 0)
				_Entity.append(ent);
			ERoofPlane erp = (ERoofPlane)ent;
			if (erp.bIsValid())
				er.append(erp);
		}
	}// END find valid roofplane

// declare standards and collect plines
	CoordSys cs[0];
	Vector3d vx[0],vy[0],vz[0];
	Point3d ptOrg[0], ptMidPl[0];
	PLine pl[0];

	for (int i = 0; i < er.length(); i++){
		cs.append(er[i].coordSys()); 
		ptOrg.append(cs[i].ptOrg());
		vx.append(cs[i].vecX());
		vy.append(cs[i].vecY());
		vz.append(cs[i].vecZ());
		//vx[i].vis(_Pt0,1);
		//vy[i].vis(_Pt0,3);
		pl.append(er[i].plEnvelope());
		Point3d ptTmp;
		ptTmp.setToAverage(pl[i].vertexPoints(TRUE));
		ptMidPl.append(ptTmp);								vz[i].vis(ptMidPl[i],150);
		if (_bOnDebug)
		{
			Display dpDebug(i);
			dpDebug.dimStyle(sDimStyle);
			dpDebug.draw(er[i].handle(),ptMidPl[i],_XW,_YW,0,0,_kDeviceX);		
		}
	}



// get tile product data
	mapTileArea = _Map.getMap("TileArea");
	mapTileRidge = _Map.getMap("TileRidge");	

// set temp map for tile type
	double dWMin = mapTileArea.getMap("0").getDouble("WMin");
	double dWMax = mapTileArea.getMap("0").getDouble("WMax");
	
	
// invalid xml
	if(dWMin <= 0 || dWMax <= 0)
	{
		Display dpErr(1);
		dpErr.draw(T("|Note|") + ": " + scriptName(),_Pt0,_XW,_YW,1,0);	
		dpErr.draw(sPath + " " +  T("contains invalid values."),_Pt0,_XW,_YW,1,-3);	
		dpErr.draw(T("|Please verify the parameters stored in this file.|"),_Pt0,_XW,_YW,1,-6);
		return;					
	}	
	
// declare list of segments and its linked eroofs
	LineSeg ls[0];
	int nType[0];
	ERoofPlane er0[0];		
	ERoofPlane er1[0];	
	double dEps = U(0.1);	

// analyze rps on dbCreate or on update or after appending roofplanes // 
if (_bOnDbCreated ){//|| (_bOnRecalc && _kExecuteKey==sTrigger[0]) || (_bOnRecalc && _kExecuteKey==sTrigger[1]) ){
	ERoofPlane erCopy[0];
	erCopy= er;
	Map mapRoofSet;
	for (int i = 0; i < er.length(); i++)
	{
		Map mapEr;
		mapEr.setEntity("er",er[i]);
		PlaneProfile ppEr(CoordSys(ptOrg[i], vx[i], vy[i], vz[i]));
		ppEr.joinRing(pl[i],_kAdd);
		LineSeg lsEr = ppEr.extentInDir(vx[i]);//		lsEr.vis(2);		lsEr.ptStart().vis(222);
		
		Point3d pts[] = pl[i].vertexPoints(FALSE);
		for (int p = 0; p < pts.length()-1; p++)
		{
			Map mapSeg;
			mapSeg.setPLine("seg", PLine(pts[p], pts[p+1]),_kAbsolute);
			LineSeg lsTmp = LineSeg(pts[p], pts[p+1]);
						
			// the coordSys of the segment
			Vector3d vxRL = pts[p+1]-pts[p];
			vxRL.normalize();
			// swap if pointing downwards
			if (vxRL.dotProduct(_ZW) < 0)
				vxRL *=-1;										//vxRL.vis(lsTmp.ptMid(),i);
			Vector3d  vyRL = vz[i].crossProduct(vxRL);		//vyRL.vis(lsTmp.ptMid(),i);
			Vector3d  vzRL = vxRL.crossProduct(vyRL);		//vzRL.vis(lsTmp.ptMid(),1);			
			
			// the loaction of the segment		
			double dLocX, dLocY;
			dLocX = vx[i].dotProduct(lsTmp.ptMid()- ptMidPl[i]);
			dLocY = vy[i].dotProduct(lsTmp.ptMid()- ptMidPl[i]);
			
			// identify potential other roofplane
			ERoofPlane erCouple[0];
			
			erCouple.append(er[i]);
			for (int e = 0; e < erCopy.length(); e++)
			{
				Vector3d vxCopy, vyCopy, vzCopy;
				vxCopy = erCopy[e].coordSys().vecX();
				vyCopy = erCopy[e].coordSys().vecY();
				vzCopy = erCopy[e].coordSys().vecZ();				
				Point3d ptOrgCopy = erCopy[e].coordSys().ptOrg();
				// check if segment is in same plane
				if (i!=e && (abs(vzCopy.dotProduct(ptOrgCopy - lsTmp.ptMid())) < U(0.1)))
				{	
					// build a tiny pp at segment and check intersection with pp of erp
					PlaneProfile ppTest(CoordSys(ptOrgCopy, vxCopy, vyCopy, vzCopy));
					Vector3d vyE = vxRL.crossProduct(vzCopy);
					PLine plTest(vzCopy);
					plTest.createRectangle(LineSeg(lsTmp.ptStart() +vxRL*U(10) - vyE * U(10), lsTmp.ptEnd() -vxRL*U(10) + vyE * U(10)), vxRL, vyE);
					ppTest.joinRing(plTest,_kAdd);
					ppTest.intersectWith(PlaneProfile(erCopy[e].plEnvelope()));		ppTest.vis(i);
					if (ppTest.area() > U(10)*U(10))
					{
						erCouple.append(erCopy[e]);
						break;
					}					
				}
			}// next e

			// cases
			String sEdgeHandle = er[i].handle();
			String s;
			if (vx[i].isParallelTo(vxRL) && dLocY < 0)
				s = "eave";
			else if (vx[i].isParallelTo(vxRL) && dLocY > 0 && erCouple.length() < 2)
				s = "pult";
			else if (erCouple.length() == 2)
			{
			// sort erps
				PlaneProfile ppTest(erCouple[0].plEnvelope());
				// check mitre
				Vector3d vCheck = erCouple[0].coordSys().vecZ().crossProduct(erCouple[1].coordSys().vecZ());
				vCheck.normalize();
				if (ppTest.pointInProfile(lsTmp.ptMid() + erCouple[0].coordSys().vecX() * U(1)) != _kPointOutsideProfile)	// swap
					vCheck *=-1;
				sEdgeHandle += "_" + erCouple[1].handle();
				mapSeg.setEntity("neighbour",erCouple[1]);				

				if (_ZW.isPerpendicularTo(vCheck))
					s = "ridge";
				else if (_ZW.dotProduct(vCheck) < 0)
					s = "valley";
				else
					s = "hip";
			}				
			else if (vx[i].isPerpendicularTo(vxRL))
			{
				if (abs(vx[i].dotProduct(lsTmp.ptMid() - lsEr.ptStart())) < dEps && dLocX < 0)
				{
					s = "GableEndLeft";
					mapEr.setInt("hasGableEndLeft",TRUE);	
				}
				else if (abs(vx[i].dotProduct(lsTmp.ptMid() - lsEr.ptEnd())) < dEps && dLocX > 0)
				{
					s = "GableEndRight";
					mapEr.setInt("hasGableEndRight",TRUE);	
				}	
				else
					s = "perpendicular edge";
			}	
			else if (dLocY < 0)
				s = "rising eave";
			else
				s = "sloped edge";
			mapSeg.setString("Type", s);
			mapSeg.setVector3d("vxRL", vxRL);			
			mapSeg.setVector3d("vyRL", vyRL);	
			mapSeg.setVector3d("vzRL", vzRL);	
									
			lsTmp.ptMid().vis(3);
			mapEr.setMap("Edge"+p, mapSeg);
		}//next p

		mapRoofSet.setMap(er[i].handle(),mapEr);	
		//mapEr.writeToXmlFile("c:\\temp\\roof" + i + ".xml");
	}// next i
	_Map.setMap("Roofs", mapRoofSet);


// get all edges
	Map mapEdge, mapEdgeSet;
	for (int i = 0; i < er.length(); i++)
	{
		
		Map mapEr = _Map.getMap("Roofs").getMap(er[i].handle());
		//reportNotice("\nRoof_" + er[i].handle() + " "  + mapEr.length()+ "edges");
		for (int j = 0; j < mapEr.length(); j++)
		{
			if (!mapEr.hasMap("Edge" + j)) continue;
			String s = mapEr.getMap("Edge" + j).getString("Type");
			if (s == "ridge" || s == "valley" || s == "hip")
			{
				mapEdge.setEntity("erA", mapEr.getEntity("er"));
				mapEdge.setEntity("erB", mapEr.getMap("Edge" + j).getEntity("neighbour"));
				mapEdge.setString("Type", s);
				Point3d ptSegA[0];
				ptSegA = mapEr.getMap("Edge" + j).getPLine("seg").vertexPoints(TRUE);
				mapEdge.setPLine("seg", mapEr.getMap("Edge" + j).getPLine("seg"));	
				
				// check for edge entry, use longer one
				String sA = mapEdge.getEntity("erA").handle(), sB = mapEdge.getEntity("erB").handle();
				int bDo = TRUE;
				Point3d ptSegB[0];
				if (mapEdgeSet.hasMap(sA + "_" + sB) || mapEdgeSet.hasMap(sB + "_" + sA))
				{
					String sMapName;
					if (mapEdgeSet.hasMap(sA + "_" + sB))
						sMapName  = sA + "_" + sB;
					else
						sMapName  = sB + "_" + sA;									
	
					ptSegB = mapEdgeSet.getMap(sMapName).getPLine("seg").vertexPoints(TRUE);							
					if (Vector3d(ptSegB[0]-ptSegB[1]).length()>Vector3d(ptSegA[0]-ptSegA[1]).length())
						mapEdgeSet.setMap(sMapName,mapEdge);						
				}	
				else			
					mapEdgeSet.setMap(sA + "_" + sB,mapEdge);
			}
		}
	}
	_Map.setMap("Edges",mapEdgeSet);
	//_Map.writeToXmlFile("c:\\temp\\aaMasterTile2.xml");
}
// initialize
	Point3d pt[0];
		// pt[] is the matrix of all tiles 
		// x=columnindex, y=roofindex, z= type
		// types
		// -1 = deleted
		// 0 = standard
		// 1 = gable end left
		// 2 = gable end right
		// 3 = half tile	
	pt = _Map.getPoint3dArray("pt");

	// set to absolute
	Point3d ptRef = _Map.getPoint3d("ptRef");
	for (int p = 0; p < pt.length(); p++)
		pt[p] = pt[p]- (_Pt0-ptRef);
		

//Display
	Display dp(-1);	
	dp.dimStyle(sDimStyle);
	//dp.draw(scriptName(), _Pt0, _XW,_YW,1,0);
	
	
// pp array
	PlaneProfile pp[0];	

// flag if data needs to be taken from roof shape map data or from matrix pt
	int bHasMatrix;
	if (pt.length() > 0)
		bHasMatrix = TRUE;
		
// map of all roofs		
	Map mapRoofs = _Map.getMap("Roofs");	
		
// calculate tile distribution
	for (int i = 0; i < er.length(); i++)
	{
		Map mapEr = mapRoofs.getMap(er[i].handle());
		PlaneProfile ppEr(Plane(ptOrg[i],vz[i]));
		ppEr.joinRing(pl[i],_kAdd);
		LineSeg lsEr = ppEr.extentInDir(vx[i]);
		lsEr.vis(3);
		Point3d ptArTileOrg[] ={ lsEr.ptStart(),lsEr.ptEnd()};
		ptArTileOrg = Line(ptOrg[i],-vx[i]).orderPoints(ptArTileOrg);
		ptArTileOrg = Line(ptArTileOrg[0],vy[i]).projectPoints(ptArTileOrg);
		ptArTileOrg = Line(ptArTileOrg[0],vy[i]).orderPoints(ptArTileOrg);
		Point3d ptTileOrg = ptArTileOrg[0];//lsEr.ptEnd();			
				
		ptTileOrg.vis(2);
		
		double dW, dH, dDistrMin, dDistrMax, dDistr;
		dH = abs(vy[i].dotProduct(lsEr.ptStart() - lsEr.ptEnd()));
		dW = abs(vx[i].dotProduct(lsEr.ptStart() - lsEr.ptEnd()));
		
		// net width
		double dWNet = dW;
		
	// declare flags for gable endings
		int bHasGERight, bHasGELeft;
		// init with shape map data
		
		int nCol;// qty of cols
	


		double dWGableEndLeft, dWGableEndRight;
		
	// not matrix
		if (!bHasMatrix)
		{
			bHasGELeft = mapEr.hasInt("hasGableEndLeft");
			bHasGERight = mapEr.hasInt("hasGableEndRight");
			// subtract gable end left from total width
			if (bHasGELeft && mapTileArea.hasMap("1"))
			{
				Map mapTileSub = mapTileArea.getMap("1");
				dWGableEndLeft = (mapTileSub.getDouble("WMin")+mapTileSub.getDouble("WMax"))/2;
				dWNet -= dWGableEndLeft;
				nCol++;		
			}
			// subtract gable end right from total width
			if (bHasGERight  && mapTileArea.hasMap("2"))
			{
				Map mapTileSub = mapTileArea.getMap("2");
				dWGableEndRight = (mapTileSub.getDouble("WMin")+mapTileSub.getDouble("WMax"))/2;
				dWNet -= dWGableEndRight;
				nCol++;			
			}
		}// END no matrix
	// has matrix
		else
		{
			// subtract non standards
			for (int p = 0; p < pt.length(); p++)
			{
				// check if this point belongs to this erp or if it is the last of it
				if (p == pt.length()-1)
				{
					if (pt[p].Z() == 1)
						bHasGELeft = TRUE;
				}
				else if (pt[p].Y() == i)
				{
					if (pt[p].Y() != pt[p+1].Y())
					{
						if (pt[p].Z() == 1)
						{
							bHasGELeft = TRUE;
						}
						else
						{
							//reportNotice ("\nbreaking at " + pt[p].Y() + "/" + pt[p+1].Y());
							break;
						}
					}
					else if (pt[p].Z() == 2)
						bHasGERight = TRUE;	
				}
					
				// belongs to this erp and is not standard
				if (pt[p].Y() == i && pt[p].Z() != 0)
				{
					String s = pt[p].Z();	
					if (!mapTileArea.hasMap(s))
						s = "0";
					if (mapTileArea.hasMap(s))
					{
						Map mapTileSub = mapTileArea.getMap(s);
						dWNet -= (mapTileSub.getDouble("WMin")+mapTileSub.getDouble("WMax"))/2;
						nCol++;
					}	
				}
				
				if (bHasGELeft)
					break;
			}// next p
		}
	// END has matrix
		
	// calc qty of tile columns
		int nMin, nMax;
		double dDiv;
		
		dDiv = dWNet / dWMin + 0.99;
		nMin = (dDiv >0) ? dDiv +0.499999 : dDiv -0.499999;	
		
		dDiv = dWNet / dWMax;	
		nMax = (dDiv >0) ? dDiv +0.499999 : dDiv -0.499999;
		if (nMin <= 0 || nMax <=0 )
				continue;
		
		// min/max distribution
		dDistrMin= dWNet / nMin;		
		dDistrMax= dWNet / nMax;		
		
		int bNotFit = FALSE;
		int nFit;
		// set distr
		if (dWMax == dWMin){
			dDistr = dWMax;
			dDiv =  dWNet / dDistr;
			nFit = (dDiv >0) ? dDiv +0.499999 : dDiv -0.499999;
		}
		else
		{
			if (dDistrMax <= dWMax + dEps && dDistrMax >= dWMax - dEps)
				dDistr = dWMax;
			else if (dDistrMin <= dWMin + dEps && dDistrMin >= dWMin - dEps)
				dDistr = dWMin;
			else if (dDistrMax > dWMin && dDistrMax < dWMax)
				dDistr = dDistrMax;
			else if ((dDistrMax+dDistrMin)/2 > dWMin && (dDistrMax+dDistrMin)/2 < dWMax)	
				dDistr = (dDistrMax+dDistrMin)/2;	
			else if (dDistrMin > dWMin && dDistrMin < dWMax)
				dDistr = dDistrMin;			
			else
				dDistr = (dDistrMax+dDistrMin)/2;	
				
			dDiv =  dWNet / dDistr;				
			nFit = (dDiv >0) ? dDiv +0.499999 : dDiv -0.499999;
			dDistr = dWNet /nFit ;
		}	
		if (!(dDistrMax <= dWMax + dEps && dDistrMax >= dWMax - dEps) && 
			 !(dDistrMin <= dWMin + dEps && dDistrMin >= dWMin - dEps))
		{
			dDistr = (dWMax+dWMin)/2;	
			bNotFit = TRUE;	
		}
		if (nFit * dDistr < dWNet - dEps || nFit * dDistr > dWNet + dEps)
			bNotFit = TRUE;
		nCol += nFit ;			

	// count columns from qty of points per side
	// due to later user modifications the nCol could be different from pt.length()
		if (bHasMatrix)
		{
			int nColNew;
			for (int p = 0; p < pt.length(); p++)
				if (pt[p].Y() == i)
					nColNew++;
			nCol = nColNew;		
		}
	
	
		// show preview on double gable ends
		Entity entSingle = mapEr.getEntity("SingleTile");
		// do only report if two gable ends and no singleTile exists and does'nt fit
		if (bHasGERight  && bHasGELeft && (bNotFit && !entSingle.bIsValid()))
		{
			Map mapTileSub = mapTileArea.getMap("1");
			dWGableEndLeft = (mapTileSub.getDouble("WMin")+mapTileSub.getDouble("WMax"))/2;
			mapTileSub = mapTileArea.getMap("2");
			dWGableEndRight = (mapTileSub.getDouble("WMin")+mapTileSub.getDouble("WMax"))/2;			
			
			double dOffMin[0], dOffMax[0];
			dOffMin.append(nMin * dWMin + dWGableEndLeft + dWGableEndRight - dW);
			dOffMax.append(nMax * dWMax + dWGableEndLeft + dWGableEndRight - dW);
			dOffMin.append((1+nMin) * dWMin + dWGableEndLeft + dWGableEndRight - dW);
			dOffMax.append((1+nMax) * dWMax + dWGableEndLeft + dWGableEndRight - dW);
			for (int m = 0; m < mapEr.length(); m++)
				if (mapEr.hasMap("Edge"+m))
				{
					Map mapEdge = mapEr.getMap("Edge"+m);
					PLine plEdge(vz[i]);
					int nSide = 1;
					if(mapEdge.getString("Type") == "GableEndLeft")
						nSide = -1;
					if (mapEdge.getString("Type") == "GableEndRight" || mapEdge.getString("Type") == "GableEndLeft")
					{
						dp.lineType("HIDDEN");
						// show min grid
						plEdge = mapEdge.getPLine("seg");
						/*
						// stretch a bit
						Point3d ptEdge[] = plEdge.vertexPoints(TRUE);
						if (ptEdge.length()==2)
						{
							double dStretch = U(150);
							plEdge = PLine(ptEdge[0] - mapEdge.getVector3d("vxRL") * dStretch ,ptEdge[0], ptEdge[1], ptEdge[1] + mapEdge.getVector3d("vxRL")* dStretch );	
							
						}*/
						for (int x = 0; x <2; x++)
						{
							String sOffTxt;
							sOffTxt.formatUnit(0.5 * dOffMin[x],dp);
							plEdge.transformBy(nSide * vx[i] * 0.5 * dOffMin[x]);
							Point3d pts[] = plEdge.vertexPoints(TRUE);
							dp.color(240);
							dp.draw(plEdge);
							dp.draw(sOffTxt, (pts[0] + pts[1])/2, pts[1] - pts[0], _ZW.crossProduct(pts[1] - pts[0]),(x+1)*2.2,nSide * 1.2,_kDevice);

							// show max grid
							sOffTxt.formatUnit(0.5 * dOffMax[x],dp);
							plEdge.transformBy((vx[i] * 0.5 * nSide)  * (dOffMax[x]-dOffMin[x]));
							pts = plEdge.vertexPoints(TRUE);
							dp.color(150);
							dp.draw(plEdge);	
							dp.draw(sOffTxt, (pts[0] + pts[1])/2, pts[1] - pts[0], _ZW.crossProduct(pts[1] - pts[0]),(x+1)*-2.2,-nSide * 1.2,_kDevice);
						}
					}
				}
				String sMsg = "\n" + T("|Adjustment needed on roof|") + " " + (i+1);
				if (_bOnDbCreated)
					reportNotice (sMsg);
				else
					reportMessage (sMsg);				
				//dDistr = (dDistrMin+dDistrMin)/2;
		}
//		else
//		{
//			int nAverage = (nMin+nMax)/2;
//			dDistr = dWNet / nAverage ; 	
//		}

	// collect pp tile columns
		for (int c = 0; c < nCol;c++)
		{
			Map mapTileSub;
			double dX;
			if (bHasMatrix)
			{
				for (int p = 0; p < pt.length(); p++)
					if (pt[p].Y() == i && c == pt[p].X()) 
					{
						if (pt[p].Z() > 0)
						{
							String s = pt[p].Z();	
							if (!mapTileArea.hasMap(s))
								s = "0";
							if (mapTileArea.hasMap(s))
							{
								Map mapTileSub = mapTileArea.getMap(s);
								dX = (mapTileSub.getDouble("WMin")+mapTileSub.getDouble("WMax"))/2;
								break;
							}
						}
						else
						{					
							dX = dDistr;
							break;	
						}
					}
			}
			else
			{		
				if (c == 0 &&  bHasGERight)
				{
					mapTileSub = mapTileArea.getMap("2");
					dX = (mapTileSub.getDouble("WMin")+mapTileSub.getDouble("WMax"))/2;
					pt.append(Point3d(c,i,2));
					//if (c == 39)		reportNotice("\n.... GERight appending c/i " + c + "/" + i + "/2");					
				}
				else if (c == nCol-1 &&  bHasGELeft)
				{
					mapTileSub = mapTileArea.getMap("1");
					dX = (mapTileSub.getDouble("WMin")+mapTileSub.getDouble("WMax"))/2;
					pt.append(Point3d(c,i,1));
					//if (c == 39)		reportNotice("\n.... GELeft appending c/i " + c + "/" + i + "/1");
				}
				else
				{
					dX = dDistr;
					pt.append(Point3d(c,i,0));	
					//if (c == 39)		reportNotice("\n.... Standard appending c/i " + c + "/" + i + "/0");
				}
			}
			// store pt matrix in map
			if (!bHasMatrix)
				_Map.setPoint3dArray("pt",pt);
			
			PLine plCol(vz[i]);
			plCol.createRectangle(LineSeg(ptTileOrg, ptTileOrg - vx[i] * dX + vy[i] * dH), vx[i], vy[i]);

			ptTileOrg.transformBy(-vx[i] * dX);
			PlaneProfile ppCol(CoordSys(er[i].coordSys().ptOrg(), vx[i], vy[i], vz[i]));
			ppCol.joinRing(plCol, _kAdd);

			//if (!(!bHasGERight  && bHasGELeft))
				// 	seems to fail on some occasions
			//	ppCol.intersectWith(PlaneProfile(er[i].plEnvelope()));

			pp.append(ppCol);
	
		}//next c		
		
	// relocate all tile columns if the roofplane has only a left gable end
		if (!bHasGERight  && bHasGELeft)
			for (int c = 0; c < pp.length();c++)
				if (pt[c].Y() == i)
					pp[c].transformBy(-vx[i] * vx[i].dotProduct(ptTileOrg - lsEr.ptStart()));


	}// next i	



// create satellite_____________________________________________create satellite__________________________create satellite_
	// trigger1: create tiles
	if (_bOnRecalc && _kExecuteKey==sTrigger[2]) 
	{
		// selection of element(s) or lathes		
		ElementRoof  el[0];
		Beam bm[0];
		PrEntity ssE(T("|Select roof element(s) or roof lathes|"), ElementRoof());
		ssE.addAllowedClass(Beam());
  		if (ssE.go())
		{
			Entity ents[0];
    		ents = ssE.set();
			for (int i = 0; i < ents.length(); i++)
			{
				if (ents[i].bIsKindOf(ElementRoof()))
					el.append((ElementRoof)ents[i]);
				else if(ents[i].bIsKindOf(Beam()))
				{
					// check beamtype
					Beam bm0 = (Beam)ents[i];
					if (bm0.type() == _kLath)
						bm.append(bm0);
				}
			}
		}	
		
		mapRoofs = _Map.getMap("Roofs");
		Map mapEdges = _Map.getMap("Edges");
	// singleTile creation	
		for (int i = 0; i < er.length();i++)
		{
			Map mapEr = mapRoofs.getMap(er[i].handle());
			// pass tile map to singleTile
			mapEr.setMap("tile",mapTileArea);

			// append all matrix entries of this erp
			Point3d ptEr[0];
			for (int p = 0; p < pt.length();p++)
				if (pt[p].Y() == i)
					ptEr.append(pt[p]);
					
			// flag reverse calculation (from left to right)
			// as default distribution is calculated from right to left of each roofplane
			int nReverse = 1;
			if (mapEr.getInt("hasGableEndLeft")&& !mapEr.getInt("hasGableEndRight"))
				nReverse 	= -1;
			mapEr.setInt("ReverseDistribution", nReverse);
			mapEr.setPoint3dArray("ptEr", ptEr);					

			// declare tsl props
			TslInst tsl;
			Vector3d vecUcsX = vx[i];
			Vector3d vecUcsY = vy[i];
			Beam lstBeams[0];
			Entity lstEnts[0];
			int lstPropInt[0];
			double lstPropDouble[0];
			String lstPropString[0];
			Point3d lstPoints[0];
		
			// get right most point of roofplane envelope
			PlaneProfile ppEr(Plane(ptOrg[i],vz[i]));
			ppEr.joinRing(pl[i],_kAdd);
			LineSeg lsEr = ppEr.extentInDir(-vx[i]);
			lstPoints.append(lsEr.ptEnd());
			lstEnts.append(er[i]);
			lstPropString.append(sDimStyle);
			lstPropInt.append(nColor);
			lstPropDouble.append(dDeltaL);
			lstPropDouble.append(dDeltaR);		
			
			// vars for enlargeing the ppEr to the projected ridge line
			double dLathOffset;
			int bIsEnlarged;

			// append elements or lathes
			//elements
			for (int e = 0; e < el.length(); e++)
			{
				// check orientation
				Point3d ptOrgEl;
				Vector3d vxEl,vyEl,vzEl;
				ptOrgEl = el[e].ptOrg();	
				vxEl=el[e].vecX();
				vyEl=el[e].vecY();
				vzEl=el[e].vecZ();
				
				// compare distances from lath to ptOrg	// th 11.10.2007
				double dOffsetLathElem = vzEl.dotProduct(el[e].zone(5).ptOrg()-el[e].zone(1).ptOrg());
				double dOffsetLathErp = vzEl.dotProduct(el[e].zone(5).ptOrg()-ptOrg[i]);
				
				if (vx[i].isParallelTo(vxEl) && vy[i].isParallelTo(vyEl) && vz[i].isParallelTo(vzEl) &&
					(dOffsetLathElem - dEps <= dOffsetLathErp && dOffsetLathElem + dEps >= dOffsetLathErp))
				{
					
					if (!bIsEnlarged)
					{
						// enlarge ppEr to projected ridgeline
						dLathOffset = abs(vz[i].dotProduct(ptOrg[i] - el[e].zone(5).ptOrg())) + 0.5 * el[e].zone(5).dH();	
						double dRoofAngle = 90 - vy[i].angleTo(_ZW);
						dLathOffset = dLathOffset /(tan(dRoofAngle));
						PlaneProfile ppTmp = ppEr;
						ppTmp.transformBy(vy[i] * dLathOffset);
						ppEr.unionWith(ppTmp);
						bIsEnlarged= TRUE;
					}
					// calc the midpoint from all vertices  th 30.11.2007
					Point3d ptEnv[] =el[e].plEnvelope().vertexPoints(true);
					Point3d ptMid;//el[e].plEnvelope().ptMid()
					ptMid.setToAverage(ptEnv);
					
					if(	ppEr.pointInProfile(ptMid) != _kPointOutsideProfile)
						lstEnts.append(el[e]);	
				}
			}
			// laths
			// handle not used yet

			for (int b = 0; b < bm.length();b++)
			{
				if (vx[i].isParallelTo(bm[b].vecX()) && vy[i].isParallelTo(bm[b].vecD(vy[i])) && vz[i].isParallelTo(bm[b].vecD(vz[i])))
				{
					if (!bIsEnlarged)
					{
							// enlarge ppEr to projected ridgeline
						dLathOffset = abs(vz[i].dotProduct(ptOrg[i] - bm[b].ptCen())) + 0.5 * bm[b].dD(vz[i]);	
						double dRoofAngle = 90 - vy[i].angleTo(_ZW);
						dLathOffset = dLathOffset /(tan(dRoofAngle));
						PlaneProfile ppTmp = ppEr;
						ppTmp.transformBy(vy[i] * dLathOffset);
						ppEr.unionWith(ppTmp);
						bIsEnlarged= TRUE;
					}
					if (ppEr.pointInProfile(bm[b].ptCen()) != _kPointOutsideProfile)
						lstBeams.append(bm[b]);	
				}
				
			}
			// group singleTile tsl's
			if (bAutoGroup)
			{
				String sNum = i+1;
				sNum.format(T("%02i"), i);
				lstPropString.append(sGroup + "\\" + T("|Roof|" + " " + sNum));
			}
			else
				lstPropString.append("");

			lstPropString.append(T("|Tile grid + visible width|"));
			lstPropString.append(sAutoUpdate);
			
			// continue / do not create a single if there is already a singleTile tsl
			Entity entSingle = mapEr.getEntity("SingleTile");
			if (entSingle.bIsValid()) continue;
			tsl.dbCreate("hsbTileSingle", vecUcsX,vecUcsY,lstBeams, lstEnts, lstPoints, 
				lstPropInt, lstPropDouble, lstPropString, TRUE, mapEr); // create new instance
			mapEr.removeAt("tile", TRUE);	
			mapEr.setEntity("SingleTile", tsl);// add to map of roof
			
			mapRoofs.setMap(er[i].handle(), mapEr);
			_Map.setMap("Roofs", mapRoofs);	
		}// next i			
			
	// create hip/ridge lines_____________________________________________________________________________________		
		
		for (int m = 0; m < mapEdges.length();m++)
		{
			Map mapEdgeTsl;
			mapEdgeTsl.setMap("Tile", mapTileRidge);
			
			// get the edgeline
			if (!mapEdges.hasMap(m)) continue;
			String sMapName = mapEdges.keyAt(m);
			Map mapEdgeLine = mapEdges.getMap(sMapName); 

			// continue if edgeTsl is a valid entity
			if (mapEdgeLine.getEntity("EdgeTile").bIsValid()) continue;
			
			// get coordinate system from erps
			Vector3d  vxAB[0], vyAB[0], vzAB[0];
			Point3d ptOrgAB[0];
			ERoofPlane erAB[0];
			Entity ent;
			ent = mapEdgeLine.getEntity("erA");
			erAB.append((ERoofPlane)ent);
			ent = mapEdgeLine.getEntity("erB");
			erAB.append((ERoofPlane)ent);
			for (int e = 0; e < erAB.length(); e++)
			{
				vxAB.append(erAB[e].coordSys().vecX());	
				vyAB.append(erAB[e].coordSys().vecY());	
				vzAB.append(erAB[e].coordSys().vecZ());	
				ptOrgAB.append(erAB[e].coordSys().ptOrg());									
			}
			

				
			// declare tsl props
			TslInst tsl;
			Vector3d vecUcsX = mapEdgeLine.getVector3d("vxRL");
			Vector3d vecUcsY = mapEdgeLine.getVector3d("vyRL");
			Beam lstBeams[0];
			Entity lstEnts[0];
			int lstPropInt[0];
			double lstPropDouble[0];
			String lstPropString[0];
			Point3d lstPoints[0];
			
			lstEnts.append(mapEdgeLine.getEntity("erA"));
			lstEnts.append(mapEdgeLine.getEntity("erB"));
			lstPoints.append(mapEdgeLine.getPLine("seg").vertexPoints(TRUE));
			if (lstPoints.length() < 2) continue;
			mapEdgeTsl.setPoint3d("pt0", lstPoints[0]);
			mapEdgeTsl.setPoint3d("pt1", lstPoints[1]);			
			lstPropString.append(sDimStyle);
			
			// append elements and/or lathes
			for (int i = 0; i < erAB.length(); i++)
			{
				//elements
				PlaneProfile ppEr(Plane(ptOrgAB[i],vzAB[i]));
				ppEr.joinRing(erAB[i].plEnvelope(),_kAdd);
				for (int e = 0; e < el.length(); e++)
				{
					// check orientation
					Point3d ptOrgEl;
					Vector3d vxEl,vyEl,vzEl;
					ptOrgEl = el[e].ptOrg();	
					vxEl=el[e].vecX();
					vyEl=el[e].vecY();
					vzEl=el[e].vecZ();
					if (vxAB[i].isParallelTo(vxEl) && vyAB[i].isParallelTo(vyEl) && vzAB[i].isParallelTo(vzEl) &&
						ppEr.pointInProfile(el[e].plEnvelope().ptMid()) != _kPointOutsideProfile)
						lstEnts.append(el[e]);	
				}
				
				// laths
				// handle not used yet
				for (int b = 0; b < bm.length();b++)
					if (vxAB[i].isParallelTo(bm[b].vecX()) && vyAB[i].isParallelTo(bm[b].vecD(vyAB[i])) && vzAB[i].isParallelTo(bm[b].vecD(vzAB[i])) &&
						ppEr.pointInProfile(bm[b].ptCen()) != _kPointOutsideProfile)
						lstBeams.append(bm[b]);
			}// next i
			
			// group edges
			if (bAutoGroup)
				lstPropString.append(sGroup + "\\" + T("|Roof edges|"));
			else
				lstPropString.append("");
			
				
			tsl.dbCreate("hsbTileEdge", vecUcsX,vecUcsY,lstBeams, lstEnts, lstPoints, 
							lstPropInt, lstPropDouble, lstPropString, TRUE, mapEdgeTsl); // create new instance
			mapEdgeLine.setEntity("EdgeTile", tsl);
			mapEdges.setMap(sMapName, mapEdgeLine);			
		}// next m
		_Map.setMap("Edges",mapEdges);
	}// end trigger 1

// trigger4: delete tiles
	if (_bOnRecalc && _kExecuteKey==sTrigger[4]) 
	{
		Point3d ptPick =getPoint("\n" + T("|Select a point inside a tile column|"));
		int f;
		for (int i = 0; i < pl.length();i++)
		{
			ptPick.projectPoint(Plane(_PtW,_ZW),0);
			pl[i].projectPointsToPlane(Plane(_PtW,_ZW),_ZW);
			PlaneProfile ppPick(pl[i]);
			if (ppPick.pointInProfile(ptPick) != _kPointOutsideProfile)
			{
				f = i;
				break;	
			}
		}
		// project to tile plane
		ptPick= Line(ptPick, _ZW).intersect(Plane(ptOrg[f],vz[f]),0);
		
		for (int t = 0; t < pp.length(); t++)
		{
			if (pp[t].pointInProfile(ptPick) != _kPointOutsideProfile && pt[t].Y() == f)
			{
				for (int p = t; p < pt.length(); p++)
					if (pt[p].Y() == f)
						pt[p].setX(pt[p].X()-1);
				if(pt[t].Y() == f)
				{
					pt.removeAt(t);
					pp.removeAt(t);
					break;
				}
			}
		}
		
		// transform relative to pt0
		for (int p = 0; p < pt.length(); p++)
			pt[p] = pt[p]- (ptRef-_Pt0);
		_Map.setPoint3dArray("pt",pt);
		setExecutionLoops(2);	
	}

	
// trigger5: add tiles______________________________________________________________________________________add tiles
	if (_bOnRecalc && _kExecuteKey==sTrigger[5]) 
	{
		Point3d ptPick =getPoint("\n" + T("|Select a point inside a tile column|"));
		int f;
		for (int i = 0; i < pl.length();i++)
		{
			ptPick.projectPoint(Plane(_PtW,_ZW),0);
			pl[i].projectPointsToPlane(Plane(_PtW,_ZW),_ZW);
			PlaneProfile ppPick(pl[i]);
			if (ppPick.pointInProfile(ptPick) != _kPointOutsideProfile)
			{
				f = i;	
				break;	
			}
		}
		
		// project to tile plane
		ptPick= Line(ptPick, _ZW).intersect(Plane(ptOrg[f],vz[f]),0);
				
		int nModifiedType;
		reportMessage("\n" + scriptName() + " ***********************");
		reportMessage("\n" + T("|Available tiles are:|"));
		for (int m = 0 ; m < mapTileArea.length(); m++)
		{
			Map mapSub = mapTileArea.getMap(m);
			reportMessage("\n" + m + ": " + mapSub.getString("art1"));
		}
		nModifiedType	 = getInt(T("|Press <F2> to see available types, enter new type index|") + ": ");

		for (int t = 0; t < pp.length(); t++)
		{
			if (pp[t].pointInProfile(ptPick) != _kPointOutsideProfile && pt[t].Y() == f)
			{
				// shift all x after the new entry
				for (int p = t+1; p < pt.length(); p++)
				{
					if(pt[p].Y() == f)
						pt[p].setX(pt[p].X()+1);
				}
				
				if(pt[t].Y() == f)
				{
					pt.insertAt(t+1, Point3d(pt[t].X()+1,f,nModifiedType));
					break;
				}
			}
		}// next t
		
		// transform relative to pt0
		for (int p = 0; p < pt.length(); p++)
			pt[p] = pt[p]- (ptRef-_Pt0);
		_Map.setPoint3dArray("pt",pt);
		setExecutionLoops(2);		
	}
	
	
// trigger6: modify tiles______________________________________________________________________________________modify tiles
	if (_bOnRecalc && _kExecuteKey==sTrigger[6]) 
	{
		Point3d ptPick =getPoint("\n" + T("|Select a point inside a tile column|"));
		int f;
		for (int i = 0; i < pl.length();i++)
		{
			ptPick.projectPoint(Plane(_PtW,_ZW),0);
			pl[i].projectPointsToPlane(Plane(_PtW,_ZW),_ZW);
			PlaneProfile ppPick(pl[i]);
			if (ppPick.pointInProfile(ptPick) != _kPointOutsideProfile)
			{
				f = i;
				break;	
			}
		}
		// project to tile plane
		ptPick= Line(ptPick, _ZW).intersect(Plane(ptOrg[f],vz[f]),0);
				
		int nModifiedType;

		reportMessage("\n" + scriptName() + " ***********************");
		reportMessage("\n" + T("|Available tiles are:|"));
		for (int m = 0 ; m < mapTileArea.length(); m++)
		{
			Map mapSub = mapTileArea.getMap(m);
			reportMessage("\n" + m + ": " + mapSub.getString("art1"));
		}
		nModifiedType	 = getInt(T("|Press <F2> to see available types, enter new type index|") + ": ");

		for (int t = 0; t < pp.length(); t++)
		{
			if (pp[t].pointInProfile(ptPick) != _kPointOutsideProfile && pt[t].Y() == f)
			{
				pt[t].setZ(nModifiedType);
				break;
			}
		}// next t
		
		// transform relative to pt0
		for (int p = 0; p < pt.length(); p++)
			pt[p] = pt[p]- (ptRef-_Pt0);
		_Map.setPoint3dArray("pt",pt);
		setExecutionLoops(2);
	}	
	
// trigger8: append edge line
	if (_bOnRecalc && _kExecuteKey==sTrigger[8]) 
	{
		Map mapTileEdges = _Map.getMap("TileEdges");
		//get tile edges	
		TslInst tslEdges[0];
		PrEntity ssE(T("|Select instances of tsl hsbTileEdge|"), TslInst());
  		if (ssE.go()){
			Entity ents[0];
    		ents = ssE.set();
			for (int i = 0; i < ents.length(); i++){
				if(ents[i].bIsKindOf(TslInst()))
				{
					// check tsl name
					TslInst tslAdd;
					tslAdd = (TslInst)ents[i];
					String sScriptName = tslAdd.scriptName();
					sScriptName.makeUpper();
					if (sScriptName == "HSBTILEEDGE")	
						tslEdges.append(tslAdd);
				}
			}// next i
		}	
		
		for (int i = 0; i < tslEdges.length(); i++)
		{
			// find next free index
			int nFree;
			for (int m = 0; m < mapTileEdges .length(); m++)
				if (mapTileEdges .keyAt(m) == "TileEdge"+nFree)
					nFree++;
			mapTileEdges.setEntity( "TileEdge"+nFree, tslEdges[i]);
		}	
		_Map.setMap("TileEdges", mapTileEdges);
	}//END trigger8: append edge line	


// draw tiles
	mapRoofs = _Map.getMap("Roofs");
	for (int t = 0; t < pp.length(); t++)
	{
		pp[t].vis(3);
		LineSeg ls = pp[t].extentInDir(pp[t].coordSys().vecX());
		//ls.vis(8);
		if (_bOnDebug)
			dp.draw(t+1,ls.ptMid(),pp[t].coordSys().vecX(),pp[t].coordSys().vecY(),0,-1);

		int n;
		if (t<pt.length())
			n = pt[t].Z();

		// check if master has valid single
		// get erp from index
		String sErHandle;
		if (pt[t].Y() < er.length())
			sErHandle = er[pt[t].Y()].handle();		
		//Map mapEr = mapRoofs.getMap(sErHandle);
		Entity entSingle = mapRoofs.getMap(sErHandle).getEntity("SingleTile");

		if (n > -1 && !entSingle.bIsValid())
		{
			Display dp1(n+1);
			dp1.draw(pp[t]);	
			// mark special tiles
			if (n > 0)
				dp1.draw(ls);
		}
	}


// note
	if (er.length() < 1)
	{
		dp.color(1);
		dp.draw(T("|No roofplanes assigned|"), _Pt0, _XW,_YW,1,-5);	
		
	}
	//else
	//	dp.draw(scriptName(), _Pt0, _XW,_YW,1,1);	


// START schedule data_______________________________________________________________________START schedule data
	Point3d ptSched[0];
		// matrix to define location in schedule table
		// x = row
		// y = column
		// z = index of array
	Point3d ptFlag[0];
		// matrix to define extended flags for schedule table
		// array has always same length as ptSched
		// x = color
		// y = do scaling
		// z = draw horizontal pline -1 = before, 0 = not , 1 = after
	int nSumTypes[0],nSumTypesRidge[0];
	int nSumQty[0],nSumQtyRidge[0];	
		
	String s0[0], s1[0], s2[0], s3[0], s4[0];// data
	double dAllW[5];// width
	int nAlign[] = {_kCenter,_kRight,_kLeft,_kLeft,_kCenter};;// alignment
	PLine plSketch[0];
	
	double dTxtH = dp.textHeightForStyle("O", sDimStyle);	
	double dTxtW = dp.textLengthForStyle("OO", sDimStyle);
	double dLineFeed = 2;
	
	PlaneProfile ppTotalRoof(CoordSys(_Pt0,_XW,_YW,_ZW));	
	CoordSys csProj;
	csProj.setToProjection(Plane(_Pt0,_ZW),_ZW);
			
	// assign data
	s0.append(T("|Roof|"));							ptSched.append(Point3d(0,0,s0.length()-1)); 	ptFlag.append(Point3d(nColor,0,1));
	s1.append(T("|Qty|"));							ptSched.append(Point3d(0,1,s1.length()-1)); 	ptFlag.append(Point3d(nColor,0,0));
	s2.append(T("|Article #|"));					ptSched.append(Point3d(0,2,s2.length()-1)); 	ptFlag.append(Point3d(nColor,0,0));
	s3.append(T("|Desc|"));							ptSched.append(Point3d(0,3,s3.length()-1)); 	ptFlag.append(Point3d(nColor,0,0));
	s4.append(T("|Info|"));							ptSched.append(Point3d(0,4,s4.length()-1)); 	ptFlag.append(Point3d(nColor,0,0));

	// projected total roof
	for (int i = 0; i < er.length(); i++)
	{
		PLine plEr = er[i].plEnvelope();
		plEr.transformBy(csProj);
		ppTotalRoof.joinRing(plEr,_kAdd);		
	}
	LineSeg lsTotalRoof = ppTotalRoof.extentInDir(_XW);
	
	
	int nRowCnt;
	for (int i = 0; i < er.length(); i++)
	{
		nRowCnt++;
		// append roof index
		s0.append(i+1);								ptSched.append(Point3d(nRowCnt,0,s0.length()-1));	 	ptFlag.append(Point3d(nColor,0,0));
				
		// collect single roof shape
		s4.append("");
		plSketch.append(er[i].plEnvelope());		ptSched.append(Point3d(nRowCnt,4,plSketch.length()-1));	 	ptFlag.append(Point3d(20,TRUE,0));
		plSketch[plSketch.length()-1].transformBy(csProj);
		
		//collect data from single
		Map mapEr = mapRoofs.getMap(er[i].handle());
		if (mapEr.hasEntity("SingleTile"))
		{
			Entity ent = 	mapEr.getEntity("SingleTile");
			TslInst tslSingle = (TslInst)ent;
			if (tslSingle.bIsValid())
			{
				Map mapSingle = tslSingle.map();
				Map mapTileData = mapSingle.getMap("TileData");
				// loop the tile data map of the singleTile
				for (int m = 0; m < mapTileData.length(); m++)
				{
					// get tile data from map
					String s = mapTileData.keyAt(m);
					int t = s.atoi();
					if (mapTileArea.hasMap(s))
					{
						nRowCnt++;
						// find entry in sum array
						int f = nSumTypes.find(t);
						if (f<0)
						{
							nSumTypes.append(t);
							nSumQty.append(mapTileData.getInt(m));
							f = nSumTypes.find(t);
						}
						else
							nSumQty[f] += mapTileData.getInt(m);
						
						// get qty and art # and append type bar for sketch
						Map mapTileSub = mapTileArea.getMap(s);
						s1.append(mapTileData.getInt(m));		ptSched.append(Point3d(nRowCnt,1, s1.length()-1));	 	ptFlag.append(Point3d(nColor,0,1));
						s2.append(mapTileSub.getString("art2"));	ptSched.append(Point3d(nRowCnt,2,s2.length()-1));	ptFlag.append(Point3d(nColor,0,0));
						s3.append(mapTileSub.getString("art1"));ptSched.append(Point3d(nRowCnt,3,s3.length()-1)); 	ptFlag.append(Point3d(nColor,0,0));
							
						PLine plRec(_ZW);
						plRec.createRectangle(LineSeg(lsTotalRoof.ptMid() - _XW * 0.5 * dTxtW - _YW * .2 * dTxtH,
											   				lsTotalRoof.ptMid() + _XW * 0.5 * dTxtW + _YW * .2 * dTxtH),_XW,_YW);
						plSketch.append(plRec);		ptSched.append(Point3d(nRowCnt,4,plSketch.length()-1));	 	ptFlag.append(Point3d(s.atoi()+1,0,0));
						s4.append("");
					}	
				}//next m
			}// valid tsl
		}// has ent
	}// next i erp
	
// collect edgeline data
	Map mapEdges = _Map.getMap("Edges");	
	for (int i = 0; i < mapEdges.length();i++)
	{
		Map mapEdgeTsl;
		
		// get the edgeline
		if (!mapEdges.hasMap(i)) continue;
		String sMapName = mapEdges.keyAt(i);
		Map mapEdgeLine = mapEdges.getMap(sMapName);
		
		// retrieve roof number combination from handle
		String sRoofNo;
		for (int i = 0; i < er.length();i++)
			if (er[i].handle() == mapEdgeLine.getEntity("erA").handle())
				sRoofNo = i+1;
		if (sRoofNo.length() > 0) sRoofNo +="/";	
		for (int i = 0; i < er.length();i++)
			if (er[i].handle() == mapEdgeLine.getEntity("erB").handle())
				sRoofNo = sRoofNo + (i+1);

						
		// get the stored tsl
		Entity ent = 	mapEdgeLine.getEntity("EdgeTile");
		TslInst tslEdge = (TslInst)ent;
		if (tslEdge.bIsValid())
		{
			nRowCnt++;
			// append roof index
			s0.append(sRoofNo);								ptSched.append(Point3d(nRowCnt,0,s0.length()-1));	 	ptFlag.append(Point3d(nColor,0,-1));		
			// collect edgeLineShape
			Point3d ptEdgeShape[0];
			ptEdgeShape.append(tslEdge.ptOrg());
			ptEdgeShape.append(tslEdge.gripPoint(0));
			PLine plEdgeShape(ptEdgeShape[0], ptEdgeShape[1], ptEdgeShape[1] + tslEdge.coordSys().vecY() * dTxtH, ptEdgeShape[0] + tslEdge.coordSys().vecY() * dTxtH);
			s4.append("");
			plSketch.append(plEdgeShape);		ptSched.append(Point3d(nRowCnt,4,plSketch.length()-1));	 	ptFlag.append(Point3d(150,TRUE,0));
			plSketch[plSketch.length()-1].transformBy(csProj);			
			
			Map mapTileData = tslEdge.map().getMap("TileData");

			for (int m = 0; m < mapTileData.length(); m++)
			{
					// get tile data from map
					String s = mapTileData.keyAt(m);
					int t = s.atoi();
					if (mapTileRidge.hasMap(s))
					{
						nRowCnt++;
						// find entry in sum array
						int f = nSumTypesRidge.find(t);
						if (f<0)
						{
							nSumTypesRidge.append(t);
							nSumQtyRidge.append(mapTileData.getInt(m));
							f = nSumTypesRidge.find(t);
						}
						else
							nSumQtyRidge[f] += mapTileData.getInt(m);
						
						// get qty and art # and append type bar for sketch
						Map mapTileSub = mapTileRidge.getMap(s);
						
						s1.append(mapTileData.getInt(m));			ptSched.append(Point3d(nRowCnt,1, s1.length()-1));	ptFlag.append(Point3d(nColor,0,0));
						s2.append(mapTileSub.getString("art2"));	ptSched.append(Point3d(nRowCnt,2,s2.length()-1));	ptFlag.append(Point3d(nColor,0,0));
						s3.append(mapTileSub.getString("art1"));ptSched.append(Point3d(nRowCnt,3,s3.length()-1)); 	ptFlag.append(Point3d(nColor,0,0));
							
						PLine plRec(_ZW);
						plRec.createRectangle(LineSeg(lsTotalRoof.ptMid() - _XW * 0.5 * dTxtW - _YW * .2 * dTxtH,
											   				lsTotalRoof.ptMid() + _XW * 0.5 * dTxtW + _YW * .2 * dTxtH),_XW,_YW);
						plSketch.append(plRec);		ptSched.append(Point3d(nRowCnt,4,plSketch.length()-1));	 	ptFlag.append(Point3d(s.atoi()+151,0,0));
						s4.append("");
					}	
				}//next m			
		}		
	}// END collect edgeline data	
	
// summarize
	if (nSumTypes.length() > 0 || nSumTypesRidge.length() > 0)
	{
		nRowCnt++;
		s0.append(T("|Sum|"));		ptSched.append(Point3d(nRowCnt,0,s0.length()-1)); 	ptFlag.append(Point3d(nColor,0,-1));
	}	
// order data by type
	for (int i = 0; i < nSumTypes.length(); i++)
		for (int j = 0; j < nSumTypes.length()-1; j++)
			if(nSumTypes[j]>nSumTypes[j+1])
			{
				int nTmp = nSumTypes[j];
				nSumTypes[j] = nSumTypes[j+1];
				nSumTypes[j+1] = nTmp;
				
				nTmp = nSumQty[j];
				nSumQty[j] = nSumQty[j+1];
				nSumQty[j+1] = nTmp;				
			}	
// order ridge data by type
	for (int i = 0; i < nSumTypesRidge.length(); i++)
		for (int j = 0; j < nSumTypesRidge.length()-1; j++)
			if(nSumTypesRidge[j]>nSumTypesRidge[j+1])
			{
				int nTmp = nSumTypesRidge[j];
				nSumTypesRidge[j] = nSumTypesRidge[j+1];
				nSumTypesRidge[j+1] = nTmp;
				
				nTmp = nSumQtyRidge[j];
				nSumQtyRidge[j] = nSumQtyRidge[j+1];
				nSumQtyRidge[j+1] = nTmp;				
			}				
			
// collect sum data	
	for (int i = 0; i < nSumTypes.length(); i++)
	{
		nRowCnt++;
		String s = nSumTypes[i];
		Map mapTileSub = mapTileArea.getMap(s);
		
		// add waste
		nSumQty[i] += mapTileSub.getInt("waste");
		s1.append(nSumQty[i]);							ptSched.append(Point3d(nRowCnt,1,s1.length()-1)); 	ptFlag.append(Point3d(nColor,0,1));
		s2.append(mapTileSub.getString("art2"));		ptSched.append(Point3d(nRowCnt,2,s2.length()-1));	ptFlag.append(Point3d(nColor,0,0));
		s3.append(mapTileSub.getString("art1"));		ptSched.append(Point3d(nRowCnt,3,s3.length()-1));	ptFlag.append(Point3d(nColor,0,0));
		s4.append("+ " + mapTileSub.getInt("waste") + " " + T("|pcs|"));		ptSched.append(Point3d(nRowCnt,4,s4.length()-1));	ptFlag.append(Point3d(nColor,0,0));
	}
// collect sum data	ridge/hip
	for (int i = 0; i < nSumTypesRidge.length(); i++)
	{
		nRowCnt++;
		String s = nSumTypesRidge[i];
		Map mapTileSub = mapTileRidge.getMap(s);
		
		// add waste
		nSumQtyRidge[i] += mapTileSub.getInt("waste");
		s1.append(nSumQtyRidge[i]);					ptSched.append(Point3d(nRowCnt,1,s1.length()-1)); 	ptFlag.append(Point3d(nColor,0,1));
		s2.append(mapTileSub.getString("art2"));		ptSched.append(Point3d(nRowCnt,2,s2.length()-1));	ptFlag.append(Point3d(nColor,0,0));
		s3.append(mapTileSub.getString("art1"));		ptSched.append(Point3d(nRowCnt,3,s3.length()-1));	ptFlag.append(Point3d(nColor,0,0));
		s4.append("+ " + mapTileSub.getInt("waste") + " " + T("|pcs|"));		ptSched.append(Point3d(nRowCnt,4,s4.length()-1));	ptFlag.append(Point3d(nColor,0,0));
	}
	
		
	// width col 0
	for (int i = 0; i < s0.length(); i++)
	{
		double dTmp = dp.textLengthForStyle(s0[i], sDimStyle) + dTxtW;
		if (dTmp > dAllW[0]) dAllW[0] = dTmp;	
	}	
	// width col 1
	for (int i = 0; i < s1.length(); i++)
	{
		double dTmp = dp.textLengthForStyle(s1[i], sDimStyle) + dTxtW;
		if (dTmp > dAllW[1]) dAllW[1] = dTmp;	
	}
	// width col 2
	for (int i = 0; i < s2.length(); i++)
	{
		double dTmp = dp.textLengthForStyle(s2[i], sDimStyle) + dTxtW;
		if (dTmp > dAllW[2]) dAllW[2] = dTmp;	
	}
	// width col 3
	for (int i = 0; i < s3.length(); i++)
	{
		double dTmp = dp.textLengthForStyle(s3[i], sDimStyle) + dTxtW;
		if (dTmp > dAllW[3]) dAllW[3] = dTmp;	
	}	
	// width col 4
	for (int i = 0; i < s4.length(); i++)
	{
		double dTmp = dp.textLengthForStyle(s4[i], sDimStyle) + dTxtW;
		if (dTmp > dAllW[4]) dAllW[4] = dTmp;	
	}	
	
	// get scale factor to total roof
	double dXTotal, dYTotal;

	dXTotal = abs(_XW.dotProduct(lsTotalRoof.ptStart()-lsTotalRoof.ptEnd())); 
	dYTotal = abs(_YW.dotProduct(lsTotalRoof.ptStart()-lsTotalRoof.ptEnd())); 
	double dScaleX = 1;
	if (dXTotal != 0)
		dScaleX = dAllW[4] / dXTotal;
	double dScaleY = 1;
	if (dYTotal!= 0)
		dScaleY =dLineFeed * dTxtH / dYTotal;
	double dScale = dScaleX;
	if (dScale > dScaleY)
		dScale = dScaleY;	
	dScale *= .85;
			
// collect column offset	
	double dAllOff[dAllW.length()];
	for (int i = 1; i < dAllW.length();i++)
		dAllOff[i] += dAllOff[i-1]+dAllW[i-1];
	double dSchedWidth = dAllOff[dAllOff.length()-1] + dAllW[dAllW.length()-1];

// draw schedule data
	dp.color(nColor);
	dp.draw(T("|BV|") + ": " + projectName() + ", " + projectNumber(), _Pt0 + _YW  * dLineFeed  * dTxtH, _XW,_YW,1,4);
	dp.draw(sSupplier + ", " + sProduct, _Pt0 + _YW  * dLineFeed  * dTxtH, _XW,_YW,1,1);
	String sTxt[0];
	Point3d ptLast = _Pt0;
	for (int p = 0; p < ptSched.length();p++)
	{
		int nMyColor = ptFlag[p].X();
		dp.color(nMyColor);
		int x,y,z;
		x = ptSched[p].X();
		y = ptSched[p].Y();
		z = ptSched[p].Z();				

		if (y==0)	sTxt = s0;
		else if (y==1)	sTxt = s1;
		else if (y==2)	sTxt = s2;
		else if (y==3)	sTxt = s3;
		else if (y==4)	sTxt = s4;	
		
		if(z< sTxt.length())
		{
			// get location in schedule table
			Point3d ptTxt;
			
			if (x==0)
			{
				ptTxt = _Pt0 - _YW * x * dLineFeed  * dTxtH + _XW * (0.5 * dAllW[y] +dAllOff[y]);
				dp.draw(sTxt[z], ptTxt, _XW,_YW,_kCenter,-1);
			}
			else
			{
				ptTxt = _Pt0 - _YW * x * dLineFeed  * dTxtH + _XW * ((nAlign[y]+1) * 0.5 * dAllW[y] + dAllOff[y]);
				if (y==4 && z < plSketch.length())// sketch
				{
					ptTxt.transformBy(-_YW * 0.5 * dTxtH);
					CoordSys csTrans;
					PlaneProfile ppSketch(CoordSys(_Pt0,_XW,_YW,_ZW));	
					
					if (ptFlag[p].Y() == 1)
						csTrans.setToAlignCoordSys(lsTotalRoof.ptMid(), _XW, _YW, _ZW, ptTxt, _XW * dScale,_YW* dScale,_ZW* dScale);
					else
						csTrans.setToAlignCoordSys(lsTotalRoof.ptMid(), _XW, _YW, _ZW, ptTxt, _XW,_YW,_ZW);
					
					plSketch[z].transformBy(csTrans);
					ppSketch.joinRing(plSketch[z],_kAdd);
					dp.draw(ppSketch, _kDrawFilled);
					ppSketch = ppTotalRoof;
					ppSketch.transformBy(csTrans);
					dp.color(252);
					if (ptFlag[p].Y() == 1)
						dp.draw(ppSketch);						
				}					
				else if(z < sTxt.length())
					dp.draw(sTxt[z], ptTxt - _XW * nAlign[y] * 0.5 * dTxtW , _XW,_YW,-nAlign[y],-1);
				
							
			}
			//ptTxt.vis(3);
			ptLast = ptTxt;
		// draw horizontal pline if flagged in ptFlag[].Z()	
			int nDrawHorPLine = ptFlag[p].Z();
			if(abs(nDrawHorPLine) == 1)
			{
				
				Point3d ptHor = ptTxt - _XW * _XW.dotProduct(ptTxt-_Pt0)+ _YW * 0.5 * dTxtH * (dLineFeed - 0.99); 
				if (nDrawHorPLine==1)
					ptHor = ptTxt - _XW * _XW.dotProduct(ptTxt-_Pt0) - _YW * dTxtH * (1+(dLineFeed -0.99)/2); 
				ptHor.vis(nDrawHorPLine);	
				PLine plHor(ptHor , ptHor + _XW * dSchedWidth);
				dp.draw(plHor);		
			}
		}
			
	}//next p

	//_Map.writeToXmlFile("c:\\temp\\aaMasterTile2.xml");


// trigger0: update completed
	if (_bOnRecalc && _kExecuteKey==sTrigger[0]) 
	{
	 	reportMessage(T("|Completed|"));
	}



















#End
#BeginThumbnail
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
;#HUHMJG*'(G[JESW2WM[K2M':-EI%+=ZG__9
`












#End
