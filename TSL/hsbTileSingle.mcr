#Version 7
#BeginDescription
Version 1.8   31.10.2007   th@hsbCAD.de
   - neue Option 'Auto-Update nach Änderungen' erhöht Leistung wenn deaktiviert
Version 1.7   15.10.2007   th@hsbCAD.de
DE   Modelvisualisierung inkl. Kontursubtraktionen möglich
EN   model display incl contour subtraction possible










#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#MajorVersion 1
#MinorVersion 8
#KeyWords 
#BeginContents
// ########################################################################
// Script			:  hsbTileSingle
// Description	:  calculates tile distribution
// Author			: 	th@hsbCAD.de
// Date			: 	22.08.2007
// ------------------------------------------------------------------------------------------------------------------------------------
// Changes		:	
// ---------------
// Date		Change By		Description
// ------------------------------------------------------------------------------------------------------------------------------------
// 15.10.07	th@hsbCAD.de	1.7 bugfix lath area sloped roofelements
//
// #########################################################################

//reportNotice("\nStart at" + getTickCount()/1000);
// basics and props
	U(1,"mm");
	String sArNY[] = {T("|No|"),T("|Yes|")};
	String sArDisplay[] = {T("|Tile grid + visible width|"), T("|Tile grid|"), T("|visible width|")};
	PropString sDisplay(2,sArDisplay,T("|Display|"));
	PropString sGroup(1,"",T("|Auto group tsl|"));	
	sGroup.setDescription(T("|Determines the third level group of the tsl (seperate level by '\')|"));		
	PropDouble dHipValleyExt(2, U(30), T("|Hip/Valley extension|"));
	dHipValleyExt.setDescription(T("|Determines an extension of the area where rooftiles can be located|"));	
	PropDouble dDeltaL(0, U(0), T("|Offset left|"));
	dDeltaL.setDescription(T("|Determines the offset of the lath contour to the roof outline|"));	
	PropDouble dDeltaR(1, U(0), T("|Offset right|"));	
	dDeltaR.setDescription(T("|Determines the offset of the lath contour to the roof outline|"));	
	PropString sDimStyle(0,_DimStyles,T("Dimstyle"));
	setExecutionLoops(1);
	PropInt nColor(0,252,T("|Color|"));	
	PropString sAutoUpdate(3,sArNY,T("|Auto update after changes|"));	
	sAutoUpdate.setDescription(T("|This option triggers the automatic update after modifications through the context menu. If set to NO the performace will increase but one has to fire the update or hsb_Recalc on the instance.|"));		
	double dEps = U(0.1);
	
// on insert
	if (_bOnInsert){
		showDialog();
		return;	
	}


// ints
	int nDisplay = sArDisplay.find(sDisplay);
	
// set ref point on dbCreated
	if (_bOnDbCreated)
		_Map.setPoint3d("ptRef",_Pt0,_kAbsolute);
		
// set ptEr to absolute
	Point3d ptEr[] = _Map.getPoint3dArray("ptEr");
	Point3d ptRef = _Map.getPoint3d("ptRef");
	for (int p = 0; p < ptEr.length(); p++)
		ptEr[p] = ptEr[p]- (_Pt0-ptRef);	

//Display
	Display dpPlan(1), dp(nColor);
	dpPlan.dimStyle(sDimStyle);
	dpPlan.addViewDirection(_ZW);
	dp.addHideDirection(_ZW);
		
	//dpPlan.draw(scriptName(), _Pt0, _XW,_YW,1,0);
		
// jig mode - will terminate after jig show
	if (_Map.getInt("isJig") == TRUE)
	{
		if (_Map.hasPLine("pl0"))
		{
			Hatch hatch("Net", U(10));
			PLine pl0 = _Map.getPLine("pl0");
			pl0.close();
			dpPlan.draw(pl0);
			dpPlan.draw(PlaneProfile(_Map.getPLine("pl0")),hatch);		
		}
		else
			eraseInstance();
		return;
	}


// Group
	if (sGroup != "")
	{
		Group gr();
		gr.setName(sGroup);
		String s3Group = gr.namePart(2);
		// make sure user has given 3rd level group
		if (s3Group != "")
		{
			s3Group = gr.namePart(0) + "\\" + gr.namePart(1) + "\\" + s3Group;
			gr.setName(s3Group);
			gr.addEntity(_ThisInst, TRUE);
		}
	}		


// add triggers
	String sTrigger[] = {T("|Update|"), T("|assign roofplane|"), T("|append roof laths|"),T("|append roof elements|"), "_________________",
		T("|delete tiles|"),T("|add tiles|"),T("|modify tile|"),T("|subtract contour from model|")};//,T("|move tile|")};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);

// trigger0: update
	if (_bOnRecalc && _kExecuteKey==sTrigger[0]) 
	{
	 	reportMessage("\n" + T("|Updating|" + " " + scriptName() + "..."));
	}
// trigger1: append roofplanes
	if (_bOnRecalc && _kExecuteKey==sTrigger[1]) 
	{
	 	ERoofPlane erp = getERoofPlane();
  		_Entity.append(erp);
		_Map.setEntity("er",erp);
	}
// trigger2: append laths
	if (_bOnRecalc && _kExecuteKey==sTrigger[2]) 
	{
		PrEntity ssE(T("|Select a set of laths|"), Beam());
  		if (ssE.go()) 
		{
    		Beam bm[] = ssE.beamSet();
			for(int i = 0; i < bm.length();i++)
				_GenBeam.append((GenBeam)bm[i]);
		}
	}
// trigger3: append elements
	if (_bOnRecalc && _kExecuteKey==sTrigger[3]) 
	{
		PrEntity ssE(T("|Select a set of element(s)|"), ElementRoof());
  		if (ssE.go()) 
    		_Element.append(ssE.elementSet());
	}
	
	
	
// set erp and standards
	Entity ent = _Map.getEntity("er");
	ERoofPlane er	 = (ERoofPlane)ent;
	Vector3d vx,vy,vz;
	Point3d ptOrg;
	PLine pl;

	ptOrg = er.coordSys().ptOrg();
	vx = er.coordSys().vecX();
	vy = er.coordSys().vecY();
	vz = er.coordSys().vecZ();								vz.vis(_Pt0,150);
	pl = er.plEnvelope();

// tile map
	Map mapTile = _Map.getMap("tile");
	double dY = mapTile.getMap("0").getDouble("LMax");
	double dZ = mapTile.getMap("0").getDouble("H");
	double dWMin = mapTile.getMap("0").getDouble("WMin");
	double dWMax = mapTile.getMap("0").getDouble("WMax");	
	
// get lineseg of envelope
	LineSeg lsEnv = PlaneProfile(pl).extentInDir(vx);
	
	
// get laths
	GenBeam gb[0];
	//... from element
	for (int i = 0; i < _Element.length(); i++)	
	{
		_Element[i].ptOrg().vis(i);
		gb.append(_Element[i].genBeam(5));	
		
	}

	//... from roof lathes
	for (int i = 0; i < _GenBeam.length(); i++)
		if (_GenBeam[i].type() == _kLath)
			gb.append(_GenBeam[i]);
	//bm = vy.filterBeamsPerpendicularSort(bm);

// determine the offset of the plane to the tiles
	double dTileOffset;
	
	if (gb.length() > 0)
		dTileOffset = vz.dotProduct(gb[0].ptCen()- ptOrg) + 0.5 * gb[0].dD(vz);
	Point3d ptOrgTile = ptOrg + vz * dTileOffset;

// collect the pp of all lath
	PlaneProfile ppLath(CoordSys(ptOrgTile, vx, vy, vz));
	for (int b = 0; b < gb.length(); b++)
		ppLath.unionWith(gb[b].envelopeBody().extractContactFaceInPlane(Plane(ptOrgTile,vz),U(1)));


	
// get tile contour of all laths and sort to ridge
	CoordSys csTile(ptOrgTile, vx, vy, vz);
	PlaneProfile ppTileContour(csTile);
	PLine plLath[0];
	LineSeg lsAllLath[0];
	PLine plAllRings[] = ppLath.allRings();
	int bIsOp[] = ppLath.ringIsOpening();
	for (int i = 0; i < plAllRings.length(); i++)
		if (!bIsOp[i]) plLath.append(plAllRings[i]);
	for (int i = 0; i < plLath.length(); i++)
		for (int j = 0; j < plLath.length()-1; j++)
			if (vy.dotProduct(plLath[j+1].ptMid()-ptOrg) < vy.dotProduct(plLath[j].ptMid()-ptOrg))
			{
				PLine plTmp = plLath[j];
				plLath[j] = plLath[j+1];
				plLath[j+1] = plTmp;
			}

			
// merge all lath in length
	PLine plLathMerged[0];
	for (int i = 0; i < plLath.length()-1; i++)
	{
		LineSeg lsL1, lsL2;
		lsL1 = PlaneProfile(plLath[i]).extentInDir(vx);
		lsL2 = PlaneProfile(plLath[i+1]).extentInDir(vx);
		double dDist = abs(vy.dotProduct(plLath[i].ptMid()-plLath[i+1].ptMid()));
		if (abs(vy.dotProduct(lsL1.ptMid()-lsL2.ptMid())) < U(50))
		{
			PlaneProfile 	ppTmp(csTile);
			ppTmp.joinRing(plLath[i],_kAdd);
			ppTmp.joinRing(plLath[i+1],_kAdd);	
				
			PLine plTmp(vz);
			plTmp.createRectangle(ppTmp.extentInDir(vx),vx,vy);				plTmp.vis(i);
			plLath[i+1] = plTmp;

		}
		else if(i==plLath.length()-2)
		{
			plLathMerged.append(plLath[i]);
			plLathMerged.append(plLath[i+1]);
		}
		else
		{
			plLathMerged.append(plLath[i]);
			plLath[i].vis(11);
		}
		
		if (abs(vy.dotProduct(lsL1.ptMid()-lsL2.ptMid())) < U(50) && i==plLath.length()-2)
		{
			if (i==plLath.length()-2)
				plLathMerged.append(plLath[i+1]);				
			else
				plLathMerged.append(plLath[i]);
			plLath[i].vis(3);			
		}

	}	
	if (plLath.length() == 1) plLathMerged = plLath;

// reasign merged laths to laths
	plLath = plLathMerged;


// draw warning 'no lath found'
	if (plLath.length() < 1)
	{
		PlaneProfile ppW(er.coordSys());
		ppW.joinRing(er.plEnvelope(),_kAdd);
		LineSeg lsW = ppW.extentInDir(vx);
		Point3d pt1,pt2;
		pt1 = er.plEnvelope().closestPointTo(lsW.ptEnd());
		pt2 = er.plEnvelope().closestPointTo(lsW.ptStart());		
		Vector3d vxW, vyW;
		vxW = pt1-pt2; vxW.normalize();
		vyW = _ZW.crossProduct(vxW);
		lsW = LineSeg(pt2,pt1);
		String sWTxt = T("append laths or roof elements");
		dpPlan.color(20);
		dpPlan.draw(scriptName() , lsW.ptMid(),vxW, vyW,0,1.7,_kDevice);		
		dpPlan.draw(sWTxt , lsW.ptMid(),vxW, vyW,0,-1.7,_kDevice);
		double dWarningLength = dpPlan.textLengthForStyle(sWTxt, sDimStyle);
		double dWarningHeight = dpPlan.textHeightForStyle(sWTxt, sDimStyle);
		PLine plW;
		plW.createRectangle(LineSeg(lsW.ptStart() - vyW * 0.5 * dWarningHeight,lsW.ptEnd() + vyW * 0.5 * dWarningHeight) ,vxW, vyW);		
		ppW = PlaneProfile(plW);
		plW.createRectangle(LineSeg(lsW.ptMid() - 0.6 * vxW * dWarningLength - vyW * dWarningHeight,
		 lsW.ptMid() + 0.6 * vxW * dWarningLength + vyW * dWarningHeight),vxW, vyW);
		ppW.joinRing(plW,_kSubtract);
		dpPlan.draw(ppW,_kDrawFilled);	
		return;
	}

// get the contour				
	PLine plTileContour(vz);
	for (int i = 0; i< plLath.length(); i++)
	{
		ppLath = PlaneProfile(plLath[i]);
		LineSeg lsLath = ppLath.extentInDir(vx);	
		lsAllLath.append(lsLath);	
		// first lath
		if (i == 0)
			plTileContour.addVertex(lsLath.ptStart() - vy * dY);
		else if (i< plLath.length()-2)
			plTileContour.addVertex(lsLath.ptMid() - vx * vx.dotProduct(lsLath.ptMid()-lsLath.ptStart()));			
		else
			plTileContour.addVertex(lsLath.ptStart() );
	}	
	for (int i = plLath.length()-1; i> -1; i--)
	{
		ppLath = PlaneProfile(plLath[i]);
		LineSeg lsLath = ppLath.extentInDir(vx);	
			
		// first lath
		if (i == 0)
			plTileContour.addVertex(lsLath.ptEnd() - vy * (dY -vy.dotProduct(lsLath.ptStart()-lsLath.ptEnd())));
		else if (i< plLath.length()-2)
			plTileContour.addVertex(lsLath.ptMid() + vx * vx.dotProduct(lsLath.ptEnd()-lsLath.ptMid()));
		else
			plTileContour.addVertex(lsLath.ptEnd()+ vy * vy.dotProduct(lsLath.ptStart()-lsLath.ptEnd()));
	}	
	plTileContour.close();
	ppTileContour.joinRing(plTileContour,_kAdd);	
	
	// extend size if overhang is set
	if (dDeltaL > 0)
	{
		PlaneProfile ppTmp = ppTileContour;	
		ppTmp.transformBy(-vx * dDeltaL);
		ppTileContour.unionWith(ppTmp);
	}
	if (dDeltaR > 0)
	{
		PlaneProfile ppTmp = ppTileContour;	
		ppTmp.transformBy(vx * dDeltaR);
		ppTileContour.unionWith(ppTmp);
	}			
	//ppTileContour.vis(1);
	LineSeg lsEr = ppTileContour.extentInDir(vx);
	lsEr.vis(2);		
	
// extend / limit contour by the enlarged projection of the combination of the lath contour and the erp contour	
	PlaneProfile ppTileContourEr(csTile);
	ppTileContourEr.joinRing(er.plEnvelope(),_kAdd);
	ppTileContourEr.shrink(-dHipValleyExt);
	ppTileContourEr.intersectWith(ppTileContour);
	ppTileContourEr.vis(3);


// initialize
	Point3d pt[0];
		// pt[] is the matrix of all tiles 
		// x=columnindex, y=rowindex, z= type
		// types
		// -2 = last column
		// -1 = deleted
		// 0 = standard
		// 1 = gable end left
		// 2 = gable end right
		// 3 = half tile	
	pt = _Map.getPoint3dArray("pt");

	// set to absolute
	for (int p = 0; p < pt.length(); p++)
		pt[p] = pt[p]- (_Pt0-ptRef);

// qty of rows
	int nRow = plLath.length();

// preset matrix
	if (pt.length() < 1)
		for (int i = 0; i < nRow; i++)
			for (int j = 0; j < ptEr.length(); j++)
				pt.append(Point3d(ptEr[j].X(), i, ptEr[j].Z()));

// pp array, the collection of all tiles
	PlaneProfile pp[0];	

// flag if data needs to be taken from roof shape map data or from matrix pt
	int bHasMatrix;
	if (pt.length() > 0)
		bHasMatrix = TRUE;

// declare flags for gable endings
	int bHasGERight, bHasGELeft;
	//_Map.setInt("ReverseDistribution",-1);	

// collect column width from point matrix
	Point3d ptCol[0];
		// ptCol[] is the matrix of all tile columns 
		// x=columnindex, y=column width, z= overwrite 0= no, 1 = yes
	ptCol = _Map.getPoint3dArray("ptCol");
	// set to absolute
	for (int p = 0; p < ptCol.length(); p++)
		ptCol[p] = ptCol[p]- (_Pt0-ptRef);	
			
// calculate tile distribution		
	Point3d ptTileOrg = lsEr.ptEnd();			ptTileOrg.vis(2);	
	double dW, dH, dDistrMin, dDistrMax, dDistr;
	dH = abs(vy.dotProduct(lsEr.ptStart() - lsEr.ptEnd()));
	dW = abs(vx.dotProduct(lsEr.ptStart() - lsEr.ptEnd()));	

	// net width
	double dWNet = dW;
	
// init ptCol
	int nCol;
	for (int p = 0; p < pt.length(); p++)
	{
		int x, y, z;
		x = pt[p].X();		y = pt[p].Y();		z = pt[p].Z();		

		String s = pt[p].Z();
		if (z == 2 && !bHasGERight )
		{	bHasGERight = TRUE;			nCol++;}
		else if (z == 1 && !bHasGELeft )
		{	bHasGELeft = TRUE;			nCol++;}	

		int nSetOverwrite = 0;
		if (z > 0)nSetOverwrite =1;
			
		
		// collect data on first row
		if (y==0  && x >= ptCol.length())
			ptCol.append(Point3d(x,-1,nSetOverwrite ));

	}// next p

// subtract non standards
	for (int c = 0; c < ptCol.length(); c++)
	{
		// if value is not set in the matrix use pt
		if (ptCol[c].Y() == -1)
		{
			for (int p = 0; p < pt.length(); p++)
				// it's in this column and a other type than standard
				if (pt[p].X() == c && pt[p].Z() > 0)
				{
					String s = pt[p].Z();
					if (!mapTile.hasMap(s))		s = "0";
					double dMyWidth = (mapTile.getMap(s).getDouble("WMin") + mapTile.getMap(s).getDouble("WMax"))/2;
					dWNet -= dMyWidth;
					ptCol[c].setY(dMyWidth); 
					//reportNotice ("\nc subtracting " + c + " : " + (mapTile.getMap(s).getDouble("WMin") + mapTile.getMap(s).getDouble("WMax"))/2);
					break;
				}
		}
		// it has a width set and it's flagged to be used for column width calc
		else if (ptCol[c].Z() > 0)
			dWNet -= ptCol[c].Y(); 	
	}

// calc qty of tile columns
		int nMin, nMax;
		double dDiv;
		
		dDiv = dWNet / dWMin + 0.99;
		nMin = (dDiv >0) ? dDiv +0.499999 : dDiv -0.499999;	
	
		dDiv = dWNet / dWMax;	
		nMax = (dDiv >0) ? dDiv +0.499999 : dDiv -0.499999;
		if (nMin <= 0 || nMax <=0 )
				return;
		
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

// collect column offsets and write defaults
	double dColOff[ptCol.length()];
	for (int c = 0; c < ptCol.length(); c++)
	{
		// if value is not set in the matrix use pt
		if (ptCol[c].Y() == -1)
			for (int p = 0; p < pt.length(); p++)
				// it's in this column and standard
				if (pt[p].X() == c && pt[p].Z() == 0)
				{
					//reportNotice("\nset " + dDistr + " at c " + c);
					ptCol[c].setY(dDistr); 	
					break;
				}
		if (c>0)
			dColOff[c] += dColOff[c-1] + ptCol[c-1].Y();				
	}// next c

// reposition ptTileOrg on reverse distribution
	if (_Map.getInt("ReverseDistribution") == -1)
	{
		ptTileOrg = lsEr.ptStart() +vx * (dColOff[dColOff.length()-1] + ptCol[ptCol.length()-1].Y()) - vy * dH;
		ptTileOrg.vis(1);	
		
	}

// show preview on double gable ends
	if (bHasGERight  && bHasGELeft && bNotFit )
		dpPlan.draw("Warning", _Pt0, _XW, _YW,0,-1.1);
	
// collect pp's
	int n;
	Line ln(ptTileOrg,vy);
	Map mapTileSub = mapTile.getMap("0");
	double dLength= mapTileSub.getDouble("LMax");
	for (int p = 0; p < pt.length(); p++)
	{
		int x,y,z;// column,lath index
		x= pt[p].X();
		y= pt[p].Y();		
		z= pt[p].Z();	
				
		// qty of stored lath or required columns might be changed by the user
		if (dColOff.length() <= x || lsAllLath.length()<=y)
			continue;
		ln = Line(ptTileOrg - vx * dColOff[x],vy);
		
		// get visible width of modified  type
		String s = z;
		mapTileSub = mapTile.getMap(s);
		double dNewWMin = mapTileSub.getDouble("WMin");
		double dNewWMax = mapTileSub.getDouble("WMax");
		double dNewWAverage = (dNewWMin + dNewWMin)/2;
			
		// check if prompt is required ( tile width does not fit to valid width range)
		double dX =  ptCol[x].Y();
		if ((dX< dNewWMin || dX> dNewWMax))
			dX = (mapTile.getMap(s).getDouble("WMin")+mapTile.getMap(s).getDouble("WMax"))/2;
		//double dX = dColWidth[x];
		//if (ptCol[x].Z() < 1)
		//	dX = ptCol[x].Y();
		
		Point3d ptTile = ln.intersect(Plane(lsAllLath[y].ptMid(),vy),0.5 * abs(vy.dotProduct(lsAllLath[y].ptStart()-lsAllLath[y].ptEnd())));
		PlaneProfile ppTile(CoordSys(ptTile,vx,vy,vz));
		ppTile.joinRing(PLine(ptTile, ptTile - vx * dX, ptTile - vx * dX - vy * dLength, ptTile - vy * dLength), _kAdd);
		pp.append(ppTile);
		ppTile.vis(p);
	}


// trigger5/6/7: delete / add / modify tiles
	if (_bOnRecalc && (_kExecuteKey==sTrigger[5]||_kExecuteKey==sTrigger[6]||_kExecuteKey==sTrigger[7])) 
	{
//reportNotice("\nStart delete/add/modify at" + getTickCount()/1000); 
		
		
		int nMode = _kAdd;
		int nModifiedType;
		if (_kExecuteKey==sTrigger[5])
			nMode = _kSubtract;
		else if (_kExecuteKey==sTrigger[7])
			nMode = 2;
			
		if(nMode != _kSubtract)
		{
			reportMessage("\n" + scriptName() + " ***********************");
			reportMessage("\n" + T("|Available tiles are:|"));
			for (int m = 0 ; m < mapTile.length(); m++)
			{
				Map mapSub = mapTile.getMap(m);
				reportMessage("\n" + m + ": " + mapSub.getString("art1"));
			}
			nModifiedType	 = getInt(T("|Press <F2> to see available types, enter new type index|") + ": ");
		}	
		Point3d ptPick[0];
		ptPick.append(getPoint("\n" + T("|Select a point inside a tile|")));
		// project to tile plane
		ptPick[ptPick.length()-1] = Line(ptPick[ptPick.length()-1], _ZW).intersect(Plane(ptTileOrg,vz),0);
		TslInst tsl;
		while (1) 
		{
			PrPoint ssP("\n" + T("|Select next point to select multiple tiles|"),ptPick[ptPick.length()-1]); 
			if (ssP.go()==_kOk)
			{
				ptPick.append(ssP.value());
				// project to tile plane
				ptPick[ptPick.length()-1] = Line(ptPick[ptPick.length()-1], _ZW).intersect(Plane(ptTileOrg,vz),0);	
			
			// show jig
				if (ptPick.length() > 2)
				{
					// erase the previous jig
					if (tsl.bIsValid())
						tsl.dbErase();

					Map mapTsl;
					mapTsl.setInt("isJig", TRUE);
					Vector3d vecUcsX = vx;
					Vector3d vecUcsY = vy;
					Beam lstBeams[0];
					Entity lstEnts[0];
					int lstPropInt[0];
					double lstPropDouble[0];
					String lstPropString[0];
					Point3d lstPoints[0];
		
					lstPoints.append(ptPick[0]);
					PLine pl0(vz);
					for (int p = 0; p < ptPick.length(); p++)
						pl0.addVertex(ptPick[p]);
					mapTsl.setPLine("pl0", pl0);	
					tsl.dbCreate(scriptName(), vecUcsX,vecUcsY,lstBeams, lstEnts, lstPoints, 
						lstPropInt, lstPropDouble, lstPropString,TRUE, mapTsl ); // create new instance	
				}// END jig	
			}// END ssP.go()==_kOk)
			else
				break;
			
 		}// do...

		// erase the last jig
		if (tsl.bIsValid())
			tsl.dbErase();
	
//reportNotice("\nContinue after picking" + getTickCount()/1000); 		
		// single tile
		if (ptPick.length() == 1)
		{
			for (int t = 0; t < pp.length(); t++)
			{
				if (pp[t].pointInProfile(ptPick[0]) != _kPointOutsideProfile)
				{
					// get visible width of modified  type
					mapTileSub = mapTile.getMap(nModifiedType);
					double dNewWMin = mapTileSub.getDouble("WMin");
					double dNewWMax = mapTileSub.getDouble("WMax");
					double dNewWAverage = (dNewWMin + dNewWMin)/2;
					
					// width of stored pp
					LineSeg lsW = pp[t].extentInDir(vx);	
					double dStoredWAverage = abs(vx.dotProduct(lsW.ptStart()-lsW.ptEnd()));
					
					// check if prompt is required ( tile width does not fit to valid width range)
					double dAnswer;
					if (nMode != _kSubtract && (dStoredWAverage < dNewWMin || dStoredWAverage > dNewWMax))
					{
						reportMessage("\n" + T("|Actual width of tile at grid|")+ " :" + pt[t].X() + "/" + pt[t].Y() + " = " + dStoredWAverage);
						reportMessage("\n" + T("|Change width of column to new width|")+ " " + dNewWAverage + "?");
						dAnswer = getDouble(T("|-1 = new width, 0 = No, Enter width|"));
						if (dAnswer < 0)
							dNewWAverage = dAnswer;
						else if  (dAnswer == 0)
							dNewWAverage = 0;
					}

					int c = pt[t].X();
					if (nMode == _kSubtract)
						pt[t].setZ(-1);
					else if (nMode == _kAdd)
					{
						// evaluate type of column
						
						int nColumnType;
						for (int p = 0; p < pt.length(); p++)
							if (pt[p].X() == c && pt[p].Z() > -1)
							{
								nColumnType = pt[p].Z();
								break;
							}
						pt[t].setZ(nColumnType);
					}
				// modify tile
					else if (nMode == 2 && pt[t].Z() != nModifiedType)
					{
						//change
						if (dNewWAverage != 0)
						{
							ptCol[c] = Point3d(ptCol[c].X(), dNewWAverage, 1);
							// reset the stored width of all other standard columns
							for (int p = 0; p < ptCol.length(); p++)
								if (c!=p && ptCol[p].Z()==0)
									ptCol[p].setY(-1);
							
						}
						pt[t].setZ(nModifiedType);
					}
				}// end if _kPointOutsideProfile
			}//next t
		}
		// multiple tiles
		else if (ptPick.length() >1)
		{
			PLine plPick(vz);
			if (ptPick.length() == 2)
			{
				// build a tiny pp along the line
				Vector3d vxPick, vyPick;
				vxPick = ptPick[1] - ptPick[0];	vxPick.normalize();
				vyPick = vxPick.crossProduct(vz);
				plPick.createRectangle(LineSeg(ptPick[0] - vyPick * U(1),ptPick[1] + vyPick * U(1)),vxPick,vyPick);
			}
			else
				for (int p = 0; p < ptPick.length(); p++)
					plPick.addVertex(ptPick[p]);

			for (int t = 0; t < pp.length(); t++)
			{
				PlaneProfile ppPick(plPick);
				ppPick.intersectWith(pp[t]);
				
				if (ppPick.area() > U(1)*U(1) && nMode == _kSubtract)
					pt[t].setZ(-1);
				else if (ppPick.area() > U(1)*U(1) && nMode == _kAdd)
				{
					// evaluate type of column
					int c = pt[t].X();
					int nColumnType;
					for (int p = 0; p < pt.length(); p++)
						if (pt[p].X() == c && pt[p].Z() > -1)
						{
							nColumnType = pt[p].Z();
							break;
						}
					pt[t].setZ(nColumnType);
				}
				else if (ppPick.area() > U(1)*U(1) && nMode == 2)
				{
					pt[t].setZ(nModifiedType);
				}
			}
			
		}	
//reportNotice("\nModifying array ended" + getTickCount()/1000); 		
		if (sArNY.find(sAutoUpdate) == 1)	
			setExecutionLoops(2);
	}
// END trigger5/6/7: delete / add / modify tiles

// trigger8: subtract contour from model
	if (_bOnRecalc && _kExecuteKey==sTrigger[8]) 
	{
		//get roofelement sset	
		PrEntity ssRPOp(T("Select (optional) roofplane openings, (optional) plines which describe openings"), ERoofPlaneOpening());
		ssRPOp.addAllowedClass(EntPLine());	

  		if (ssRPOp.go()){
			Entity ents[0];
    		ents = ssRPOp.set();
			int nCountERoofsOpenings = 0;

			for (int i = 0; i < ents.length(); i++)
			{
				// find next free index
				int nFree;
				for(int m = 0; m < _Map.length(); m++)
					if (_Map.keyAt(m).left(4) == "erOp")
						nFree++;
						
				// store as entity in global map			
				if(ents[i].bIsKindOf(ERoofPlaneOpening()))
					_Map.setEntity("erOp" + nFree , ents[i]);					
				else if(ents[i].bIsKindOf(EntPLine()))
					_Map.setEntity("erOp" + nFree , ents[i]);
			}
		}
	}
// trigger8: move tiles
// NOT IMPLEMENTED YET
/*	if (_bOnRecalc && _kExecuteKey==sTrigger[9]) 
	{
		Point3d ptPick[0];
		ptPick.append(getPoint("\n" + T("|Select a point inside a tile|")));
		// project to tile plane
		ptPick[ptPick.length()-1] = Line(ptPick[ptPick.length()-1], _ZW).intersect(Plane(ptTileOrg,vz),0);
		TslInst tsl;
		while (1) 
		{
			PrPoint ssP("\n" + T("|Select next point to select multiple tiles|"),ptPick[ptPick.length()-1]); 
			if (ssP.go()==_kOk)
			{
				ptPick.append(ssP.value());
				// project to tile plane
				ptPick[ptPick.length()-1] = Line(ptPick[ptPick.length()-1], _ZW).intersect(Plane(ptTileOrg,vz),0);	
			
			// show jig
				if (ptPick.length() > 2)
				{
					// erase the previous jig
					if (tsl.bIsValid())
						tsl.dbErase();

					Map mapTsl;
					mapTsl.setInt("isJig", TRUE);
					Vector3d vecUcsX = vx;
					Vector3d vecUcsY = vy;
					Beam lstBeams[0];
					Entity lstEnts[0];
					int lstPropInt[0];
					double lstPropDouble[0];
					String lstPropString[0];
					Point3d lstPoints[0];
		
					lstPoints.append(ptPick[0]);
					PLine pl0(vz);
					for (int p = 0; p < ptPick.length(); p++)
						pl0.addVertex(ptPick[p]);
					mapTsl.setPLine("pl0", pl0);	
					tsl.dbCreate(scriptName(), vecUcsX,vecUcsY,lstBeams, lstEnts, lstPoints, 
						lstPropInt, lstPropDouble, lstPropString,TRUE, mapTsl ); // create new instance	
				}// END jig	
			}// END ssP.go()==_kOk)
			else
				break;
			
 		}// do...

		// erase the last jig
		if (tsl.bIsValid())
			tsl.dbErase();
	
		
		// single tile
		if (ptPick.length() == 1)
		{
			for (int t = 0; t < pp.length(); t++)
			{
				if (pp[t].pointInProfile(ptPick[0]) != _kPointOutsideProfile)
				{
					;
				}// end if _kPointOutsideProfile
			}//next t
		}
		// multiple tiles
		else if (ptPick.length() >1)
		{
			PLine plPick(vz);
			if (ptPick.length() == 2)
			{
				// build a tiny pp along the line
				Vector3d vxPick, vyPick;
				vxPick = ptPick[1] - ptPick[0];	vxPick.normalize();
				vyPick = vxPick.crossProduct(vz);
				plPick.createRectangle(LineSeg(ptPick[0] - vyPick * U(1),ptPick[1] + vyPick * U(1)),vxPick,vyPick);
			}
			else
				for (int p = 0; p < ptPick.length(); p++)
					plPick.addVertex(ptPick[p]);

			for (int t = 0; t < pp.length(); t++)
			{
				PlaneProfile ppPick(plPick);
				ppPick.intersectWith(pp[t]);
				
				if (ppPick.area() > U(1)*U(1))
					;
			}
			
		}		
		setExecutionLoops(2);
	}
// END trigger8: move tiles
*/


//reportNotice("\nStart: Draw and count" + getTickCount()/1000); 
// draw and count tiles & collect total shape
	PlaneProfile ppAll(csTile);
	int nQty[0];
	int nTileType[0];
	for (int t = 0; t < pp.length(); t++)
	{
		// width of stored pp
		LineSeg lsW = pp[t].extentInDir(vx);	
		double dStoredWAverage = abs(vx.dotProduct(lsW.ptStart()-lsW.ptEnd()));		
		
		// check intersection
		PlaneProfile ppTest = pp[t];
		ppTest.intersectWith(ppTileContourEr);

		int x,y,z;
		x = pt[t].X();
		y = pt[t].Y();
		z = pt[t].Z();
		
		Display dp1(z+1);
		dp1.dimStyle(sDimStyle);
		dp1.addViewDirection(_ZW);

		if(y==0 && (nDisplay == 0 || nDisplay == 2))
		{
			//reportNotice("\nStart: draw sVW" + getTickCount()/1000);
			//Point3d ptVW = ptTileOrg - vx * _Map.getInt("ReverseDistribution") * (dColOff[x]+ 0.5*ptCol[x].Y());// pp[t].coordSys().ptOrg() - vx * .5* dStoredWAverage;
			Point3d ptVW = ptTileOrg - vx  * (dColOff[x]+ 0.5*ptCol[x].Y());// pp[t].coordSys().ptOrg() - vx * .5* dStoredWAverage;

			Point3d ptVWpl[] = pl.intersectPoints(Plane(ptVW, vx));
			ptVWpl = Line(ptVW, vy).orderPoints(ptVWpl);
			if (ptVWpl.length() > 0)
				ptVW = ptVWpl[0] - vy * 2 * dpPlan.textLengthForStyle("OOOO", sDimStyle);
			String sVW;
			sVW.formatUnit(ptCol[x].Y(),dp1);
			dpPlan.color(nColor);
			dpPlan.draw(sVW, ptVW, vy, vx, 0,0,_kDevice);
			//reportNotice(" Finished" + getTickCount()/1000); 
		}

		// this is the most expensive part of the tsl
		if (z > -1 && ppTest.area() > U(50)*U(50))
		{
			//reportNotice("\nStart: test area" + getTickCount()/1000);
			// find tyle type
			int nT = nTileType.find(z);
			if (nT<0)
			{
				nTileType.append(z);
				nQty.append(1);	
			}
			else
				nQty[nT]++;
		
			// append to overall pp
			if (ppAll.area() < U(10)*U(10))
				ppAll = pp[t];
			else
				ppAll.unionWith(pp[t]);
				
			if(nDisplay < 2)
				dp1.draw(pp[t]);		
			// mark special tiles
			if (z > 0 && nDisplay < 2)
				dp1.draw(pp[t].extentInDir(vx));
			//reportNotice(" Finished" + getTickCount()/1000); 	
		}
	}
//reportNotice(" Finished" + getTickCount()/1000); 


//reportNotice("\nStart: find subtract contours" + getTickCount()/1000);	
// find subtract contours
	ERoofPlaneOpening erOp[0];
	PLine plErOp[0];		
	for (int i = 0; i < _Map.length(); i++){
		Entity ent;
		if (_Map.hasEntity("erOp" + i))
		{
			ent =  _Map.getEntity("erOp" + i);
			if (_Entity.find(ent)< 0)
				_Entity.append(ent);
				
			if (ent.bIsKindOf(ERoofPlaneOpening ()))
			{
				ERoofPlaneOpening erpOp = (ERoofPlaneOpening )ent;
				if (erpOp.bIsValid())
					erOp.append(erpOp);
			}
			else if (ent.bIsKindOf(EntPLine ()))
			{
				EntPLine epl = (EntPLine)ent;
				if (epl.bIsValid())
				{
  					PLine plContourSubtract = epl.getPLine();
					plErOp.append(plContourSubtract );
				}
			}
		}
	}
//reportNotice("finished" + getTickCount()/1000);	

//reportNotice("\nStart: draw a 3d body" + getTickCount()/1000);	
// draw a 3d body
	Body bd3D;
	PLine plBd[0];
	plBd = ppAll.allRings();
	int nIsOp[] = ppAll.ringIsOpening();
	for (int i = 0; i <plErOp.length();i++)	
	{
		plBd.append(plErOp[i]);	
		nIsOp.append(TRUE);
	}
	
	for (int i = 0; i <plBd.length();i++)
	{
		if (!nIsOp[i])
			bd3D.addPart(Body (plBd[i], vz * dZ, 1));
		else
			bd3D.subPart(Body (plBd[i], vz * U(10000), 0))	;
	}	
	dp.draw(bd3D);
//reportNotice("finished" + getTickCount()/1000);	

// publish tile data
	Map mapTileData;

//reportNotice("\nStart: order data by type" + getTickCount()/1000);	
// order data by type
	for (int i = 0; i < nQty.length(); i++)
		for (int j = 0; j < nQty.length()-1; j++)
			if(nTileType[j]>nTileType[j+1])
			{
				int nTmp = nTileType[j];
				nTileType[j] = nTileType[j+1];
				nTileType[j+1] = nTmp;
				
				nTmp = nQty[j];
				nQty[j] = nQty[j+1];
				nQty[j+1] = nTmp;				
			}
//reportNotice("finished" + getTickCount()/1000);		

//reportNotice("\nStart: draw and collect qty" + getTickCount()/1000);	
// draw and collect qty
	for (int i = 0; i < nQty.length(); i++)
	{
		Point3d ptTxt = _Pt0 - _YW * (i+1) * dpPlan.textHeightForStyle("O", sDimStyle) * 1.2;
		//dpPlan.color(nTileType[i]+1);
		//dpPlan.draw("Type " + nTileType[i] + ": " + nQty[i], ptTxt, _XW, _YW, 1, -1);	
		mapTileData.setInt(nTileType[i], nQty[i]);
	}
	_Map.setMap("TileData", mapTileData);
//reportNotice("finished" + getTickCount()/1000);	

//reportNotice("\nStart: transform relative to pt0" + getTickCount()/1000);		
// transform relative to pt0
	for (int p = 0; p < pt.length(); p++)
		pt[p] = pt[p]- (ptRef-_Pt0);
	_Map.setPoint3dArray("pt",pt);	
	for (int p = 0; p < ptCol.length(); p++)
		ptCol[p] = ptCol[p]- (ptRef-_Pt0);
	_Map.setPoint3dArray("ptCol",ptCol);	
//reportNotice("finished" + getTickCount()/1000);
				
// trigger0: update completed
	if (_bOnRecalc && _kExecuteKey==sTrigger[0]) 
	{
	 	reportMessage(T("|Completed|"));
	}


//reportNotice("\nEnded at" + getTickCount()/1000 );








#End
#BeginThumbnail
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
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`
M%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
.0`4`%`!0`4`%`!0!_]D`
`


#End
