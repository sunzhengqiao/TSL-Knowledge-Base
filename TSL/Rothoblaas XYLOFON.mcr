#Version 8
#BeginDescription
Diese TSL erzeugt Rothoblaas XYLOFON Schalldämmbänder an Panel-Kanten

This TSL creates Rothoblaas XYLOFON noise absorbers at panel edges or edges, resulting from throughout beamcuts

version value="1.1" date="20oct17" author="florian.wuermseer@hsbcad.com"> Bugfix edge stretching during insert, option for 100mm stripes (reference, opposite and centered position) added
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This TSL creates Rothoblaas XYLOFON noise absorbers at panel edges or edges, resulting from throughout beamcuts
/// </summary>

/// <insert Lang=en>
/// Select one or more panels and points on the edges, where the absorber stripes shall be appended
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>


///<version value="1.1" date="20oct17" author="florian.wuermseer@hsbcad.com"> Bugfix edge stretching during insert, option for 100mm stripes (reference, opposite and centered position) added</version> 
///<version value="1.0" date="22sept17" author="florian.wuermseer@hsbcad.com"> initial version</version> 

//TODO support for not throughout beamcuts

// constants
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));
	
// articles
	int nColors[] = {7, 2, 30, 1, 202};
	String sArticles[] = { "XYLOFON 35", "XYLOFON 50", "XYLOFON 70", "XYLOFON 80", "XYLOFON 90"};
	String sArticleNumberSmallSizes[] = { "D82411", "D82412", "D82413", "D82414", "D82415"};
	String sArticleNumberBigSizes[] = { "D82421", "D82422", "D82423", "D82424", "D82425"};
	double dThickness = U(10);
	double dWidth = U(100);
	
	String sArticleName=T("|Type|");	
	PropString sArticle(nStringIndex++, sArticles, sArticleName);	
	sArticle.setDescription(T("|Defines the XYLOFON type (the hardness))|"));
	int nArticle = sArticles.find(sArticle);
	
	String sPositions[] = { "100mm reference face", "100mm opposite face", "100mm centered", "full width"};
	String sPositionName=T("|Absorber Position|");	
	PropString sPosition(nStringIndex++, sPositions, sPositionName);	
	sPosition.setDescription(T("|Defines the Position and width of the XYLOFON absorber|"));
	int nPosition = sPositions.find(sPosition);
	
// get the data for the selected type
	String sArticleNumbers[0];
	sArticleNumbers = sArticleNumberSmallSizes;
	if (nPosition > 2)
		sArticleNumbers = sArticleNumberBigSizes;
	String sArticleNumber = sArticleNumbers[nArticle];
	int nColor = nColors[nArticle];
	
	
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
				setPropValuesFromCatalog(T("|_LastInserted|"));					
		}		
		showDialog();
		
	// prompt for panels
		Entity entSelecteds[0];
		PrEntity ssSip(T("|Select Panel(s)"), Sip());
	  	if (ssSip.go())
  			entSelecteds.append(ssSip.set());
  			
  	// prompt for point input
  		Point3d ptSelecteds[] = {_Pt0};
		PrPoint ssP(TN("|Select point(s) on edges that get the XYLOFON absorber|")); 
		while (ssP.go() == _kOk)
			ptSelecteds.append(ssP.value());
				
		if (bDebug) reportMessage("\n" + " " + ptSelecteds.length() + " " + T("|points selected|"));
				  			
	// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE;
		Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[1];
		Entity entsTsl[] = {};
		Point3d ptsTsl[1];
		int nProps[]={};
		double dProps[]={};
		String sProps[]={sArticle, sPosition};
		Map mapTsl;	
		String sScriptname = scriptName();
		
		ptsTsl = ptSelecteds;
		mapTsl.setInt("SelectEdges", 1);
		
		for (int i=0 ; i < entSelecteds.length() ; i++)
		{
		    gbsTsl[0] = (Sip) entSelecteds[i];
		    
		    tslNew.dbCreate(scriptName(), vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
				nProps, dProps, sProps,_kModelSpace, mapTsl);
		}
		
		eraseInstance();
		return;
	}	
// end on insert


	Sip sip = _Sip0;
	if (!sip.bIsValid())
	{ 
		reportMessage("\n" + T("|No valid panel selected|") + "   -->   " + T("|Tool will be deleted|"));
		eraseInstance();
		return;
	}
	
	Point3d ptPreselecteds[0];
	ptPreselecteds = _PtG;
	_PtG.setLength(0);
	
	CoordSys csSip = sip.coordSys();
	
	Vector3d vecXSip = csSip.vecX();
	Vector3d vecYSip = csSip.vecY();
	Vector3d vecZSip = csSip.vecZ();
	
	vecXSip.vis(sip.ptCenSolid(), 1);
	vecYSip.vis(sip.ptCenSolid(), 3);
	vecZSip.vis(sip.ptCenSolid(), 5);
	
	Plane pnRefSide (csSip.ptOrg() - vecZSip*.5*sip.dH(), vecZSip);
	Plane pnRef = pnRefSide;
	if (nPosition == 1)
		pnRef.transformBy(vecZSip * sip.dH());
	if (nPosition == 2)
		pnRef.transformBy(vecZSip * .5 * sip.dH());

	
// assignment
	assignToGroups(sip, 'I');
	_ThisInst.setColor(nColor);

// the solid center point
    Point3d ptCen = sip.ptCenSolid();
    _Pt0 = ptCen;
    double dZ = sip.solidHeight();
    if (nPosition < 3 && sip.solidHeight() > U(100))
    	dZ = U(100);
  	Body bdSipPlane (sip.ptCenSolid(), vecXSip, vecYSip, vecZSip, 3*sip.solidLength(), 3*sip.solidWidth(), dZ);
  	if (nPosition == 0 && sip.solidHeight() > U(100))
    	bdSipPlane.transformBy(-vecZSip * (.5 * sip.solidHeight() - U(50)));
    if (nPosition == 1 && sip.solidHeight() > U(100))
    	bdSipPlane.transformBy(vecZSip * (.5 * sip.solidHeight() - U(50)));
  	bdSipPlane.vis(4);
    
// get the CNC contour of the panel
	PLine plSip = sip.plEnvelope();
	PlaneProfile ppSip (pnRefSide);
    ppSip.joinRing(plSip, 0);

// collect the vertex points
    Point3d ptVertexs[] = plSip.vertexPoints(true);
	if (ptVertexs.length() < 1)
	{
		reportMessage("\n" + T("|Panel's' outline vertices weren't properly detected|") + "   -->   " + T("|Tool will be deleted|"));
		eraseInstance();
		return;
	}
 
// a minimal shrinked planeprofile for detecting opening edges properly	
    PlaneProfile ppTest = ppSip;
    ppTest.shrink(U(1));
    ppTest.vis(84);
	
// get the openings of the panel	
	PLine plOpenings[] = sip.plOpenings();

// display outline
    plSip.transformBy(-vecZSip * U(2000));
    plSip.vis(5);
    plSip.transformBy(vecZSip * U(2000));






//region edges
// collect all sip and beamcut edges, and store them with all relevant vectors and edge type descriptions

// collect the edges of the sip
    SipEdge edgeAll[] = sip.sipEdges();
    SipEdge edgeOpenings[0];
    SipEdge edgeOutlines[0];
    
    PLine plEdges [0];
    Vector3d vecEdges[0];
    Vector3d vecEdgeDirects[0];
    Vector3d vecEdgeNormals[0];
    Vector3d vecEdgeNormalPrevs[0];
    Vector3d vecEdgeNormalNexts[0];
	int nEdgeTypes[0];
    
    
    for (int i=0; i<edgeAll.length(); i++)
    {
    	Vector3d vecEdgeDirect = edgeAll[i].ptEnd() - edgeAll[i].ptStart();
    	vecEdgeDirect.normalize();
    	Vector3d vecEdgeNormal = edgeAll[i].vecNormal();
    	Vector3d vecEdge = vecEdgeDirect.crossProduct(vecEdgeNormal);
    	
    	Point3d ptEdgeRef = Line(edgeAll[i].ptMid(), vecEdge).intersect(pnRefSide, 0);
    	ptEdgeRef.vis(2);
		
		if (ppTest.pointInProfile(ptEdgeRef) == 0)
			edgeOpenings.append(edgeAll[i]);

		else
			edgeOutlines.append(edgeAll[i]);
    }
    
    if (edgeOutlines.length() < 1)
    { 
    	reportMessage("\n" + T("|Panel outline not properly detected|") + "   -->   " + T("|Tool will be deleted|"));
		eraseInstance();
		return;
    }
    
	for (int n = 0; n < 2; n++)
	{
		SipEdge edges[0];
		edges = edgeOutlines;
		int nEdgeType = 0;
		if (n > 0)
		{
			edges = edgeOpenings;
			nEdgeType = 1;
		}
			
		for (int e = 0; e < edges.length(); e++)
		{
			int ePrev = e - 1;
			int eNext = e + 1;
			if (e == 0)
				ePrev = edges.length() - 1;
			if (e == edges.length() - 1)
				eNext = 0;
			
			Plane pnPrev (edges[ePrev].ptMid(), edges[ePrev].vecNormal());
			Plane pnNext (edges[eNext].ptMid(), edges[eNext].vecNormal());
			
			Vector3d vecEdgeDirect = edges[e].ptEnd() - edges[e].ptStart();
	    	vecEdgeDirect.normalize();
	    	Vector3d vecEdgeNormal = edges[e].vecNormal();
	    	Vector3d vecEdge = vecEdgeDirect.crossProduct(vecEdgeNormal);
	    	
	    	Point3d ptEdgeRef = Line(edges[e].ptMid(), vecEdge).intersect(pnRef, 0);
	    	Line lnEdge (ptEdgeRef, vecEdgeDirect);
	    	PLine plEdge (lnEdge.intersect(pnPrev, 0), lnEdge.intersect(pnNext, 0));
	    	plEdge.vis(e+1);
	    	
	    	plEdges.append(plEdge);
	    	nEdgeTypes.append(nEdgeType);
	    	vecEdges.append(vecEdge);
    		vecEdgeDirects.append(vecEdgeDirect);
   			vecEdgeNormals.append(vecEdgeNormal);
   			vecEdgeNormalPrevs.append(edges[ePrev].vecNormal());
	    	vecEdgeNormalNexts.append(edges[eNext].vecNormal());
		}
	}





// collect the "edges", resulting from beamcut tools
    AnalysedTool ats[] = sip.analysedTools();
    AnalysedTool atsE[] = sip.analysedToolsFromEnvelope();
    
    AnalysedDrill adrs[0];
    AnalysedBeamCut abcs[0];
//    String sAllowedBeamCutTypes[] = {"_kABCSeatCut", "_kABCOpenSeatCut", "_kABCBirdsmouth", "_kABCClosedBirdsmouth", "_kABCReversedBirdsmouth", "_kABCHousingThroughout"};
     
    for (int i=0 ; i < ats.length() ; i++)
    {
        if (ats[i].toolType() == "AnalysedBeamCut")
        {
        	AnalysedBeamCut abc = (AnalysedBeamCut)ats[i];
        	ToolEnt tent = abc.toolEnt();
        	
        // skip beamcuts made by xylofon TSLs, to avoid interference
        	TslInst tsl = (TslInst)tent;
        	if (tsl.bIsValid() && (tsl.scriptName() == scriptName() || tsl.scriptName() == "Rothoblaas XYLOFON"))
        		continue;        	
        	
        	Quader qdrBC = abc.quader();
        	Body bdBC (qdrBC);
//        	bdBC.vis(30);
        	
        	Vector3d vecEdgeTool = qdrBC.vecD(-vecZSip);
        	
        	PlaneProfile ppBC (pnRef);
        	ppBC.unionWith(bdBC.getSlice(pnRef));
//        	ppBC.vis(6);
        	
        	Point3d ptEdges[] = ppBC.getGripVertexPoints();
        	PLine plBC (vecZSip);
        	for (int p=0; p<ptEdges.length(); p++)
        		plBC.addVertex(ptEdges[p]);
        		
        	plBC.close();
        
        // check for clockwise sequence and take reverse order if not clockwise
	        int nClockwise;
	        
	        double dFirstVertex = plBC.getDistAtPoint(ptEdges[1]);
	        double dTestDist = .5 * dFirstVertex;
	        	
	        Vector3d vecSeg = (plBC.getPointAtDist(dTestDist) - plBC.getPointAtDist(0));
	        vecSeg.normalize();

	        Vector3d vecRight = vecSeg.crossProduct(vecZSip);
	        Point3d ptTest = plBC.getPointAtDist(dTestDist) + vecRight * U(1);
	        if (ppBC.pointInProfile(ptTest) == 0)
	        	nClockwise = 1;
	        	
	        if (!nClockwise)
	        { 
	        	plBC.reverse();
	        	ptEdges = plBC.vertexPoints(true);
	        }
	        
        // store edges in the array	
        	for (int p=0 ; p < ptEdges.length() ; p++)
        	{
        	    int o = p+1;
        	    if (o == ptEdges.length())
        	    	o = 0;
        	    	
        	    PLine plEdgeTool (ptEdges[p], ptEdges[o]);
        	    
        	   	Vector3d vecEdgeDirectTool (ptEdges[o] - ptEdges[p]);
        	   	vecEdgeDirectTool.normalize();
        	   	Vector3d vecEdgeNormalTool = vecEdgeDirectTool.crossProduct(-vecEdgeTool);
        	   	vecEdgeNormalTool.normalize();
        	   	if (ppSip.pointInProfile(plEdgeTool.ptMid()) == 0)
        	   	{ 
        	   		plEdges.append(plEdgeTool);
	        	    nEdgeTypes.append(2);
	        	    vecEdges.append(vecEdgeTool);
	        	    vecEdgeDirects.append(vecEdgeDirectTool);
	        	    vecEdgeNormals.append(vecEdgeNormalTool);
	        	    vecEdgeNormalPrevs.append(vecEdgeNormalTool.crossProduct(vecEdgeTool));
	    			vecEdgeNormalNexts.append(-vecEdgeNormalTool.crossProduct(vecEdgeTool));
        	   	}
        	}
        }
    }
 
 // determine PLine in the correct plane
	for (int e = 0; e < plEdges.length(); e++)
	{
		PLine pl = plEdges[e];
		Line ln1 = Plane (pl.ptStart(), vecEdgeNormals[e]).intersect(Plane (pl.ptStart(), vecEdgeNormalPrevs[e]));
		Line ln2 = Plane (pl.ptEnd(), vecEdgeNormals[e]).intersect(Plane (pl.ptEnd(), vecEdgeNormalNexts[e]));
		Point3d pt1 = ln1.intersect(pnRef, 0);
		Point3d pt2 = ln2.intersect(pnRef, 0);
		plEdges[e] = PLine (pt1, pt2);
	}
	
// verify the results
	if (plEdges.length() != vecEdges.length() || plEdges.length() != vecEdgeNormals.length() || plEdges.length() != vecEdgeDirects.length() || plEdges.length() != nEdgeTypes.length())
	{ 
		reportMessage("\n" + T("|collection of outline and beamcuts failed|") + "   -->   " + T("|Tool will be deleted|"));
		eraseInstance();
		return;
	}

// show me the results
	Display dpDebug(6);
	if (bDebug)
	{
		for (int e = 0; e < plEdges.length(); e++)
		{
			PLine pl = plEdges[e];
			pl.vis(nEdgeTypes[e] + 1);
			vecEdges[e].vis(plEdges[e].ptMid(), 5);
			vecEdgeNormals[e].vis(plEdges[e].ptMid(), 3);
			vecEdgeDirects[e].vis(plEdges[e].ptMid(), 1);
			dpDebug.color(nEdgeTypes[e] + 1);
			dpDebug.draw(nEdgeTypes[e], plEdges[e].ptMid(), _ZW.crossProduct(vecZSip), _ZW, 1, 1);
		}
	}
//endregion edges___________________________________________________________________________________________________________________________________________________________________________________________





// add xylofon to edges
// collect the edges, that have the Xylofon added
	PLine plXyloEdges[0];
    Vector3d vecXyloEdges[0];
    Vector3d vecXyloEdgeDirects[0];
    Vector3d vecXyloEdgeNormals[0];
    Vector3d vecXyloEdgeNormalPrevs[0];
    Vector3d vecXyloEdgeNormalNexts[0];
	int nXyloEdgeTypes[0];
	
// collect the edges from the map
	Map mapEdges = _Map.getMap("mapEdges");
	int l = mapEdges.length();
	
	if (mapEdges.hasPLine("plXyloEdges")) 				for (int i = 0; i < l; i++) { PLine pl = mapEdges.getPLine(i); if (pl.length() > dEps && mapEdges.keyAt(i) == "plXyloEdges") plXyloEdges.append(pl); }
	if (mapEdges.hasVector3d("vecXyloEdges")) 			for (int i = 0; i < l; i++) { Vector3d vec = mapEdges.getVector3d(i); if (vec.length() > dEps && mapEdges.keyAt(i) == "vecXyloEdges") vecXyloEdges.append(vec); }
	if (mapEdges.hasVector3d("vecXyloEdgeDirects")) 	for (int i = 0; i < l; i++) { Vector3d vec = mapEdges.getVector3d(i); if (vec.length() > dEps && mapEdges.keyAt(i) == "vecXyloEdgeDirects") vecXyloEdgeDirects.append(vec); }
	if (mapEdges.hasVector3d("vecXyloEdgeNormals")) 	for (int i = 0; i < l; i++) { Vector3d vec = mapEdges.getVector3d(i); if (vec.length() > dEps && mapEdges.keyAt(i) == "vecXyloEdgeNormals") vecXyloEdgeNormals.append(vec); }
	if (mapEdges.hasVector3d("vecXyloEdgeNormalPrevs")) for (int i = 0; i < l; i++) { Vector3d vec = mapEdges.getVector3d(i); if (vec.length() > dEps && mapEdges.keyAt(i) == "vecXyloEdgeNormalPrevs") vecXyloEdgeNormalPrevs.append(vec); }
	if (mapEdges.hasVector3d("vecXyloEdgeNormalNexts")) for (int i = 0; i < l; i++) { Vector3d vec = mapEdges.getVector3d(i); if (vec.length() > dEps && mapEdges.keyAt(i) == "vecXyloEdgeNormalNexts") vecXyloEdgeNormalNexts.append(vec); }
	if (mapEdges.hasInt("nXyloEdgeTypes")) 				for (int i = 0; i < l; i++) { if (mapEdges.keyAt(i) == "nXyloEdgeTypes") nXyloEdgeTypes.append(mapEdges.getInt(i)); }
	



// Trigger Add Xylofon
	String sTriggerAdd = T("|Add XYLOFON|");
	addRecalcTrigger(_kContext, sTriggerAdd );
	if (ptPreselecteds.length() > 0 || (_bOnRecalc && (_kExecuteKey==sTriggerAdd || _kExecuteKey==sDoubleClick)))
	{
		Point3d ptSelecteds[0];
		ptSelecteds = ptPreselecteds;
	// prompt for point input
		PrPoint ssP(TN("|Select point(s) on edges that get the XYLOFON absorber|")); 
		while (ssP.go()==_kOk) 
			ptSelecteds.append(ssP.value());
		int nQuant;	
		for (int i=0 ; i < ptSelecteds.length() ; i++)
		{
		// find the relevant edge or beamcut edge
			for (int e=0 ; e < plEdges.length() ; e++)
		    {
				Plane pnEdge (plEdges[e].ptMid(), vecEdgeNormals[e]);
				Point3d ptClosest = pnEdge.closestPointTo(ptSelecteds[i]);
				double dDist = (ptClosest - ptSelecteds[i]).length();
				
				Line lnPoint (ptSelecteds[i], vecEdges[e]);
				Point3d ptInPlane = lnPoint.intersect(pnRef, 0);
				
				if (dDist < dEps && plEdges[e].isOn(ptInPlane))
				{					
				// check, if this edge has the xylofon attached, already
					int nContinue;
					for (int x = 0; x < plXyloEdges.length(); x++)
					{
						if (!vecXyloEdgeNormals[x].isCodirectionalTo(vecEdgeNormals[e]) || !vecXyloEdgeDirects[x].isCodirectionalTo(vecEdgeDirects[e]))
							continue;
							
						Plane pnXyloEdge (plXyloEdges[x].ptMid(), vecXyloEdgeNormals[x]);
						Point3d ptXyloClosest = pnXyloEdge.closestPointTo(ptSelecteds[i]);
						double dXyloDist = (ptXyloClosest - ptSelecteds[i]).length();
						
						Line lnXyloPoint (ptXyloClosest, vecXyloEdges[x]);
						Point3d ptInXyloPlane = lnXyloPoint.intersect(pnRef, 0);						
						
						if (dXyloDist < dThickness + dEps  && plXyloEdges[x].isOn(ptInXyloPlane))
						{
							nContinue = 1;
							break;
						}
					}
					
					if (nContinue)
					{
						reportMessage("\n" + T("|Xylofon absorber is already attached to this edge|"));
						break;
					}
						
				// attach all edge data to the xylofon edges
					plXyloEdges.append(plEdges[e]);
					vecXyloEdges.append(vecEdges[e]);
				    vecXyloEdgeDirects.append(vecEdgeDirects[e]);
				    vecXyloEdgeNormals.append(vecEdgeNormals[e]);
				    vecXyloEdgeNormalPrevs.append(vecEdgeNormalPrevs[e]);
				    vecXyloEdgeNormalNexts.append(vecEdgeNormalNexts[e]);
					nXyloEdgeTypes.append(nEdgeTypes[e]);
					
					nQuant++;	
				}
			}
		}
		ptPreselecteds.setLength(0);
		if (bDebug) reportMessage("\n" + nQuant + " " + T("|lines added|"));
		if (bDebug) reportMessage("\n" + plXyloEdges.length() + " " + T("|Xylofon edges|"));
	}

// remove xylofon from edges
// collect the edges, that have to be restored
	PLine plRestoreEdges[0];
    Vector3d vecRestoreEdges[0];
    Vector3d vecRestoreEdgeDirects[0];
    Vector3d vecRestoreEdgeNormals[0];
    Vector3d vecRestoreEdgeNormalPrevs[0];
    Vector3d vecRestoreEdgeNormalNexts[0];
	int nRestoreEdgeTypes[0];
	
// Trigger Remove Xylofon
	String sTriggerSub = T("|Remove XYLOFON|");
	addRecalcTrigger(_kContext, sTriggerSub );
	if (_bOnRecalc && _kExecuteKey==sTriggerSub)
	{
		Point3d ptSelecteds[0];
	// prompt for point input
		PrPoint ssP(TN("|Select point(s) on edges to remove XYLOFON absorber|")); 
		while (ssP.go()==_kOk) 
			ptSelecteds.append(ssP.value());
		
		if (bDebug) reportMessage("\n" + plXyloEdges.length() + " " + T("|Xylofon edges before|"));
		
		int nQuant;
		for (int i=0 ; i < ptSelecteds.length() ; i++)
		{
		// find the relevant edge that already has Xylofon added
			for (int e = plXyloEdges.length() - 1; e >= 0; e--)
		    {
				Plane pnEdge (plXyloEdges[e].ptMid(), vecXyloEdgeNormals[e]);
				Point3d ptClosest = pnEdge.closestPointTo(ptSelecteds[i]);
				double dDist = (ptClosest - ptSelecteds[i]).length();
				if (dDist < dThickness + dEps)
				{
					Line lnPoint (ptClosest, vecXyloEdges[e]);
					Point3d ptInPlane = lnPoint.intersect(pnRef, 0);
					
					if(plXyloEdges[e].isOn(ptInPlane))
					{
						plRestoreEdges.append(plXyloEdges[e]);
						vecRestoreEdges.append(vecXyloEdges[e]);
					    vecRestoreEdgeDirects.append(vecXyloEdgeDirects[e]);
					    vecRestoreEdgeNormals.append(vecXyloEdgeNormals[e]);
					    vecRestoreEdgeNormalPrevs.append(vecXyloEdgeNormalPrevs[e]);
					    vecRestoreEdgeNormalNexts.append(vecXyloEdgeNormalNexts[e]);
						nRestoreEdgeTypes.append(nXyloEdgeTypes[e]);
						
						plXyloEdges.removeAt(e);
						vecXyloEdges.removeAt(e);
					    vecXyloEdgeDirects.removeAt(e);
					    vecXyloEdgeNormals.removeAt(e);
					    vecXyloEdgeNormalPrevs.removeAt(e);
					    vecXyloEdgeNormalNexts.removeAt(e);
						nXyloEdgeTypes.removeAt(e);

						nQuant++;
					}	
				}
			}
		}
		if (bDebug) reportMessage("\n" + nQuant + " " + T("|edges removed|"));
		if (bDebug) reportMessage("\n" + plXyloEdges.length() + " " + T("|Xylofon edges|"));
	}
	
// Trigger Remove Xylofon from all edges
	int nDelete;
	String sTriggerSubAll = T("|Remove XYLOFON from all edges|");
	addRecalcTrigger(_kContext, sTriggerSubAll );
	if (_bOnRecalc && _kExecuteKey==sTriggerSubAll)
	{
		if (bDebug) reportMessage("\n" + plXyloEdges.length() + " " + T("|Xylofon edges before|"));
		
		int nQuant;
	// remove all edges and append them to the restore array
		for (int e = plXyloEdges.length() - 1; e >= 0; e--)
	    {
			plRestoreEdges.append(plXyloEdges[e]);
			vecRestoreEdges.append(vecXyloEdges[e]);
		    vecRestoreEdgeDirects.append(vecXyloEdgeDirects[e]);
		    vecRestoreEdgeNormals.append(vecXyloEdgeNormals[e]);
		    vecRestoreEdgeNormalPrevs.append(vecXyloEdgeNormalPrevs[e]);
		    vecRestoreEdgeNormalNexts.append(vecXyloEdgeNormalNexts[e]);
			nRestoreEdgeTypes.append(nXyloEdgeTypes[e]);
			
			plXyloEdges.removeAt(e);
			vecXyloEdges.removeAt(e);
		    vecXyloEdgeDirects.removeAt(e);
		    vecXyloEdgeNormals.removeAt(e);
		    vecXyloEdgeNormalPrevs.removeAt(e);
		    vecXyloEdgeNormalNexts.removeAt(e);
			nXyloEdgeTypes.removeAt(e);

			nQuant++;
		}
		nDelete = 1;
		if (bDebug) reportMessage("\n" + nQuant + " " + T("|edges removed|"));
		if (bDebug) reportMessage("\n" + plXyloEdges.length() + " " + T("|Xylofon edges|"));
	}
	
	Map mapEmpty;
	mapEdges = mapEmpty;
	
// restore edges if the xylofon absorber was removed
	for (int e = 0; e < plRestoreEdges.length(); e++)
	{
		if (nRestoreEdgeTypes[e] != 2) //only real edges (no beamcut edges)
		{
			Plane pnStretchTo (plRestoreEdges[e].ptMid(), vecRestoreEdgeNormals[e]);
			
			if (_bOnRecalc && ((_kExecuteKey == sTriggerSub) || (_kExecuteKey == sTriggerSubAll)))
				sip.stretchEdgeTo(plRestoreEdges[e].ptMid(), pnStretchTo);
		}
	}
	
// put the xylo edges to the correct base plane
	for (int e = 0; e < plXyloEdges.length(); e++)
	{
		PLine pl = plXyloEdges[e];
		Line ln1 = Plane (pl.ptStart(), vecXyloEdgeNormals[e]).intersect(Plane (pl.ptStart(), vecXyloEdgeNormalPrevs[e]));
		Line ln2 = Plane (pl.ptEnd(), vecXyloEdgeNormals[e]).intersect(Plane (pl.ptEnd(), vecXyloEdgeNormalNexts[e]));
		Point3d pt1 = ln1.intersect(pnRef, 0);
		Point3d pt2 = ln2.intersect(pnRef, 0);
		plXyloEdges[e] = PLine (pt1, pt2);
	}

// insert the xylofon absorber and modify the edges / beamcuts
	double dLengthSum;
	double dWidthMax;
	Body bdXyloDraw;

	for (int e=0 ; e < plXyloEdges.length() ; e++)
	{		
		Line lnEdge (plXyloEdges[e].ptStart(), vecXyloEdgeDirects[e]);
		
	// determine, if the neighbour edges have xylofon attached
		int nXyloEdgePrev;
		int nXyloEdgeNext;
		Point3d ptModifiedStart = plXyloEdges[e].ptStart();
		Point3d ptModifiedEnd = plXyloEdges[e].ptEnd();
		
		for (int f = 0; f < plXyloEdges.length(); f++)
		{
			if (vecXyloEdgeDirects[f].isParallelTo(vecXyloEdgeDirects[e]))
				continue;
			
			Plane pnNeighbourEdge (plXyloEdges[f].ptStart(), vecXyloEdgeNormals[f]);
			
			double dDistStart = (pnNeighbourEdge.closestPointTo(plXyloEdges[e].ptStart()) - plXyloEdges[e].ptStart()).length();
			double dDistEnd = (pnNeighbourEdge.closestPointTo(plXyloEdges[e].ptEnd()) - plXyloEdges[e].ptEnd()).length();
			
//		    if (plXyloEdges[f].isOn(plXyloEdges[e].ptStart()))  // not reliable result
			if (dDistStart < dThickness + dEps)
			{ 
				nXyloEdgePrev = 1;
				ptModifiedStart = lnEdge.intersect(pnNeighbourEdge, 0);
			}
				
			
//		    if (plXyloEdges[f].isOn(plXyloEdges[e].ptEnd()))  // not reliable result
			if (dDistEnd < dThickness + dEps)
			{
				nXyloEdgeNext = 1;
				ptModifiedEnd = lnEdge.intersect(pnNeighbourEdge, 0);
			}
		}
	// modify PLine
		plXyloEdges[e] = PLine (ptModifiedStart, ptModifiedEnd);

	// determine, if the corners to the neighbour edges are convex or concave	
		int nPrevConvex = 1;
		if (vecXyloEdgeDirects[e].dotProduct(vecXyloEdgeNormalPrevs[e]) > dEps)
			nPrevConvex = -1;
			
		int nNextConvex = 1;
		if (vecXyloEdgeDirects[e].dotProduct(vecXyloEdgeNormalNexts[e]) < -dEps)
			nNextConvex = -1;
			
		int nMoveCutPrev = abs (nPrevConvex - abs(nPrevConvex)) / (-2*nPrevConvex);
		int nMoveCutNext = abs (nNextConvex - abs(nNextConvex)) / (-2*nNextConvex);
		
		if (bDebug)
		{
			dpDebug.color(nXyloEdgeTypes[e] + 1);
			if (nXyloEdgePrev)
				dpDebug.draw("Prev", plXyloEdges[e].ptStart(), _ZW.crossProduct(vecZSip), _ZW, 1, 1);
			if (nXyloEdgeNext)
				dpDebug.draw("Next", plXyloEdges[e].ptEnd(), _ZW.crossProduct(vecZSip), _ZW, 1, 1);

			Body bdEdgeRef (plXyloEdges[e].ptStart(), plXyloEdges[e].ptEnd(), U(2));
//			plThis.transformBy(- vecXyloEdgeNormals[e] * U(20));
			bdEdgeRef.vis(nXyloEdgeTypes[e] + 1);
		}
		
	// create Xylofon Body representation and cut it to the correct size
		Body bdXylo (plXyloEdges[e].ptMid() - vecXyloEdgeNormals[e] * dThickness, vecXyloEdgeDirects[e], vecXyloEdges[e], vecXyloEdgeNormals[e], 2*plXyloEdges[e].length(), U(10000), dThickness, 0, 0, 1);
		Cut ctXyloStart (plXyloEdges[e].ptStart() - vecXyloEdgeNormalPrevs[e]*nMoveCutPrev*nXyloEdgePrev*dThickness, nPrevConvex * vecXyloEdgeNormalPrevs[e]);
		Cut ctXyloEnd (plXyloEdges[e].ptEnd() - vecXyloEdgeNormalNexts[e]*nMoveCutNext*nXyloEdgeNext*dThickness, nNextConvex * vecXyloEdgeNormalNexts[e]);
		bdXylo.addTool(ctXyloStart);
		bdXylo.addTool(ctXyloEnd);
		bdXylo.intersectWith(bdSipPlane);
		bdXylo.vis(6);
		bdXyloDraw = bdXyloDraw + bdXylo;
		
	// get dimensions
		dLengthSum = dLengthSum + bdXylo.lengthInDirection(vecXyloEdgeDirects[e]);
		double dWidth = bdXylo.lengthInDirection(vecXyloEdges[e]);
		if (dWidth > dWidthMax)
			dWidthMax = dWidth;
			
	// stretch edges / apply beamcuts	
		if (nXyloEdgeTypes[e] != 2) // only real edges (no beamcut edges)
		{			
			Plane pnStretchTo (plXyloEdges[e].ptMid(), vecXyloEdgeNormals[e]);
			pnStretchTo.transformBy(-vecXyloEdgeNormals[e] * dThickness);
			
			if (_bOnDbCreated || (_bOnRecalc && (_kExecuteKey==sTriggerAdd || _kExecuteKey==sDoubleClick)))
			{ 
				sip.stretchEdgeTo(plXyloEdges[e].ptMid(), pnStretchTo);
			}	
		}
		
		else // beamcut edges
		{	
			Vector3d vecBeamcutX = vecXyloEdges[e].crossProduct(-vecXyloEdgeNormals[e]);
			double dLength = (vecBeamcutX.dotProduct(vecXyloEdgeDirects[e]) * plXyloEdges[e].length());
			BeamCut bcXylo (plXyloEdges[e].ptMid() - vecXyloEdgeNormals[e] * dThickness, vecBeamcutX, vecXyloEdges[e], vecXyloEdgeNormals[e], dLength + dThickness*(nXyloEdgePrev + nXyloEdgeNext), U(10000), dThickness, 0, 0, 1);
			bcXylo.transformBy(vecBeamcutX * .5 * dThickness * (-nXyloEdgePrev + nXyloEdgeNext));
			sip.addTool(bcXylo);
//			bcXylo.cuttingBody().vis(2);
		}
		
	// store the edge data in the map		
		mapEdges.appendPLine("plXyloEdges", plXyloEdges[e]);
		mapEdges.appendVector3d("vecXyloEdges", vecXyloEdges[e]);
		mapEdges.appendVector3d("vecXyloEdgeDirects", vecXyloEdgeDirects[e]);
		mapEdges.appendVector3d("vecXyloEdgeNormals", vecXyloEdgeNormals[e]);
		mapEdges.appendVector3d("vecXyloEdgeNormalPrevs", vecXyloEdgeNormalPrevs[e]);
		mapEdges.appendVector3d("vecXyloEdgeNormalNexts", vecXyloEdgeNormalNexts[e]);
		mapEdges.appendInt("nXyloEdgeTypes", nXyloEdgeTypes[e]);
	}

// store the edge data in the map
	_Map.setMap("mapEdges", mapEdges);
	
// Display
	_ThisInst.setHyperlink("http://www.rothoblaas.com/products/soundproofing/soundproofing-profiles/xylofon");
	Display dp (nColor);
	if (bdXyloDraw.volume() > pow(dEps,3))
		dp.draw(bdXyloDraw);
	dp.draw("Rothoblaas" + " "+ sArticle, sip.ptCenSolid(), vecYSip, vecXSip, 0, 1, _kDevice);
	
// hardware _______________________________________________________________________________________________________________________________________________________________
	String sRecalcHardwares[] = {sArticleName, sPositionName};

	if (_bOnDbCreated || (_bOnRecalc && (_kExecuteKey==sTriggerAdd || _kExecuteKey==sTriggerSub || _kExecuteKey==sDoubleClick)) || sRecalcHardwares.find(_kNameLastChangedProp) >-1)
	{
		HardWrComp hwComps[0];	
			
		if (nPosition > 2)
			dWidth = dWidthMax;
		String sDescription = T("|Noise absorber|") + " - " + T("|Type|") + " " + sArticle;
		
	// anchor itself	
		HardWrComp hw(sArticleNumber , 1);	
		hw.setCategory(T("|Absorber|"));
		hw.setManufacturer("Rothoblaas");
		hw.setName(sArticle);
		hw.setModel(sArticle);
		hw.setMaterial(T("|Polyurethane|"));
		hw.setDescription(sDescription);
		hw.setDScaleX(dLengthSum);
		hw.setDScaleY(dWidth);
		hw.setDScaleZ(dThickness);	
		hwComps.append(hw);		

		_ThisInst.setHardWrComps(hwComps);
	}
	
// erase instance, if triggered
	if (nDelete)
	{ 
		eraseInstance();
		return;
	}
#End
#BeginThumbnail
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
=D7LL:G^&MZB@##C\-0B59);F64J<C-;E%%`'_]DX
`


#End