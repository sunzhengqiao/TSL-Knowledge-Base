#Version 8
#BeginDescription

#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
// basics and props
	U(1,"mm");
	double dEps = U(0.001);
	
	int bReportViews = false;
	int bReportOptions = false;	

// on insert
	if (_bOnInsert) {
		
		_Beam.append(getBeam());
		_Pt0 = getPoint("Select point near tool");
		return;
	}
//end on insert________________________________________________________________________________


// the parent entity
	Beam bm= _Beam0; // would be valid if added to a beam in the drawing
	if (!bm.bIsValid() && _Entity.length()>0)
		bm= (Beam)_Entity[0]; // when the shopdraw engine calls this Tsl, the _Entity array contains the Beam

	if (!bm.bIsValid()) {
		reportMessage("\n"+scriptName() +": " + T("|No beam found. !Instance erased.|"));
		eraseInstance();
		return;
	}
	Body bdBm = bm.realBody();
	
// all entities to be displayed
	Entity entTools[] = bm.eToolsConnected();
	Entity entArThis[0];
	entArThis.append(bm);
	for (int e=0; e< entTools.length();e++)	
	{
		if (entTools[e].bIsKindOf(MetalPartCollectionEnt()))
			entArThis.append(entTools[e]);
		else if (entTools[e].bIsKindOf(TslInst()))
		{
			TslInst tsl = (TslInst)entTools[e];
			if (tsl.realBody().volume()>pow(dEps,3))
				entArThis.append(entTools[e]);			
		}
		else
			continue;
		entTools[e].realBody().vis(3);
	}

	
	
	

// The parent key which is used in definition of a DimRequest is used to group all DimRequests.
	String strParentKey = String("Dim "+scriptName());
	//reportMessage("\n"+scriptName() +": " + T("|DimRequests with key|") + ": "+strParentKey);

// declare a map for the multipage and store values throughout this script to it
	Map mapMultipage;
	Point3d ptMin, ptMax;

// declare the views
	Vector3d vxArView[0],vyArView[0];
	vxArView.append(bm.vecX());	vyArView.append(-bm.vecY());	//Front View
	vxArView.append(bm.vecY());	vyArView.append(bm.vecZ());	//Left View
	vxArView.append(bm.vecZ());	vyArView.append(bm.vecX());	//Top View

	for (int v=0; v< vxArView.length();v++)
	{
		Vector3d vxView,vyView,vzView;
		vxView = vxArView[v];
		vyView = vyArView[v];
		vzView = vxArView[v].crossProduct(vyArView[v]);
		if(v==1)vzView.vis(_Pt0,150);
		Vector3d vyArDim[] = {vxView,vyView,-vxView,-vyView};

		Vector3d vxDimline = vxView;
		Vector3d vyDimline = vxDimline.crossProduct(-vzView);
		Vector3d vzDimline = vzView;

		
		// collect the extreme points in the given view
		Point3d ptExtr[0], ptAll[0], ptExtrBeam[0], ptAllBeam[0];
		ptAllBeam.append(bdBm.extremeVertices(vxView));	
		ptAllBeam.append(bdBm.extremeVertices(vyView));		
		for (int e=0; e<entArThis.length();e++)
		{
			Body bdThis = entArThis[e].realBody();
			ptExtr.append(bdThis.extremeVertices(vxView));	
			ptExtr.append(bdThis.extremeVertices(vyView));
			
		}		
		Map mapExtr;
		
		ptExtr = Line(_Pt0, vxView).orderPoints(ptExtr);

	// store extremes in x direction (support previous releases of some sd tsl's
		if (v==0 && ptExtr.length()>0)
		{
			ptMin = 	ptExtr[0];
			ptMax = 	ptExtr[ptExtr.length()-1];		
		}
		ptAll = ptExtr;


	// add extreme dimpoints to view
	// x-dim	
		vxDimline = vxView;
		vyDimline = vxDimline.crossProduct(-vzView);	
		Point3d ptDim[0];	
		for (int xy=0;xy<2;xy++)
		{
			ptExtr = Line(_Pt0,vxDimline).orderPoints(ptAll);	
			ptExtrBeam = Line(_Pt0,vxDimline).orderPoints(ptAllBeam);	
			ptDim.setLength(0);
			if (ptExtr.length()>1)
			{				
				ptDim.append(ptExtr[0]);	
				ptDim.append(ptExtr[ptExtr.length()-1]);
			}	
			if (ptExtrBeam.length()>1)
			{				
				ptDim.append(ptExtrBeam [0]);	
				ptDim.append(ptExtrBeam [ptExtrBeam .length()-1]);
			}	
			ptDim= Line(_Pt0,vxDimline).orderPoints(ptDim);
			
			for (int p = 0; p < ptDim.length();p++)
			{
				DimRequestPoint dr(strParentKey , ptDim[p], vxDimline, vyDimline);//
				dr.setStereotype("Extremes");//
				
				String s = "<>";
				if (p==0) s=" ";
				dr.setNodeTextCumm(s);
				dr.addAllowedView(vzDimline, true);//bAlsoReverseDirection); //vecView
				if (v==0)dr.vis(5); // visualize for debugging 
				addDimRequest(dr); // append to shop draw engine collector
			}	
			// y-dim
			vxDimline = vyView;
			vyDimline = vxDimline.crossProduct(-vzView);				
		}// next xy		
	}// next view v



// save some shared information to multipage
	// get multipage entity
	Map mapGenerator = _Map.getMap("Generation");
	Entity entCollector = mapGenerator.getEntity("entCollector");
	if (entCollector.bIsValid()) 
	{
		// extreme points
		mapMultipage.setPoint3d("ptMin", ptMin ) ;
		mapMultipage.setPoint3d("ptMax", ptMax ) ;
		entCollector.setSubMap("mapMultipage",mapMultipage);
	}
#End
#BeginThumbnail

#End
