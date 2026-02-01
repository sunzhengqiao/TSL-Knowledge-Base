#Version 8
#BeginDescription

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 0
#KeyWords 
#BeginContents
// basics and props
	U(1,"mm");
	double dEps = U(.01);
	String sArNY[] = {T("|No|"),T("|Yes|")};
	PropInt nColor(0,164, T("|Color|") + " " + T("|-1 = byBlock|"));
	PropString sDimStyle(0,_DimStyles, T("|Dimstyle|"));
		
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		_Entity.append(getShopDrawView());
		_Pt0 = getPoint();
		showDialog();
		return;
	}	
//end on insert________________________________________________________________________________
	
	
	// the view		
		ShopDrawView sdv;
		for (int i=0; i<_Entity.length(); i++)
		{
			if (_Entity[i].bIsKindOf(ShopDrawView()))
			{
				sdv = (ShopDrawView)_Entity[i];
				break;	
			}
		}
		
	// get view data		
	int bError = 0; // 0 means FALSE = no error
	CoordSys ms2ps, ps2ms;
	if (!bError && !sdv.bIsValid()) bError = 1;
   
// interprete the list of ViewData in my _Map
	ViewData arViewData[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
	int nIndFound = ViewData().findDataForViewport(arViewData, sdv);// find the viewData for my view
	if (!bError && nIndFound<0) bError = 2; // no viewData found

	Entity ents[0];
	if (!bError)
	{
		ViewData vwData = arViewData[nIndFound];
		ms2ps = vwData.coordSys(); // transformation to view

		// collect the entities of the view
			ents = vwData.showSetDefineEntities();
	}	
	
// display 
	Display dp(nColor);	
	dp.dimStyle(sDimStyle);
	


	
// loop entities to collect potential symbol definitions and tool entities
	String sTxt;
	for (int e=0;e<ents.length();e++)
	{	
		if (ents[e].bIsKindOf(MetalPartCollectionEnt()))
		{
			MetalPartCollectionEnt mce = (MetalPartCollectionEnt)ents[e];
			MetalPartCollectionDef mcd = mce.definition();
			sTxt = mcd.handle() + " " + mcd.entryName();
			break;
		}
	}
		
// draw info in layout
	if (ents.length()<1)
	{
		dp.draw("HANX",_Pt0,_XW,_YW,1,0);
	}
	else
	{
		dp.draw(sTxt,_Pt0,_XW,_YW,1,0);		
	}
	
	
#End
#BeginThumbnail

#End
