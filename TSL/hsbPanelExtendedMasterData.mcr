#Version 8
#BeginDescription


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
// basics and props
	U(1,"mm");
	double dEps = U(0.01);

	String sArUnit[] = {"mm", "cm", "m", "inch", "feet"};
	PropString sUnit(1,sArUnit,T("|Unit|"));
	int nArDecimals[] = {0,1,2,3,4};
	PropInt nDecimals(1,nArDecimals,T("|Decimals|"));
	
	PropString sDimStyle(0, _DimStyles, T("Dimstyle"));	
	PropInt nColor(0,3,T("|Color|"));	

// declare arrays for tsl cloning
	TslInst tslNew;
	Vector3d vUcsX = _XW;
	Vector3d vUcsY = _YW;
	Beam bmAr[0];
	Entity entAr[0];
	Point3d ptAr[0];
	int nArProps[0];
	double dArProps[0];
	String sArProps[0];
	Map mapTsl;
	String sScriptname = scriptName();
				
// on insert
	if (_bOnInsert)
	{	

		if (insertCycleCount()>1) { eraseInstance(); return; }		

		
		// show the dialog if no catalog in use
		if (_kExecuteKey == "")
			showDialog();		
		// set properties from catalog		
		else	
		{
			setPropValuesFromCatalog(_kExecuteKey);		
		}

	// properties
		sArProps.append(sDimStyle);
		sArProps.append(sUnit);		
		nArProps.append(nColor);
		nArProps.append(nDecimals);
	// selection
		Entity ents[0];
		PrEntity ssE(T("|Select other panels|"), MasterPanel());
		if (ssE.go())
			ents= ssE.set();
					
	// insert clone
		for (int i=0;i<ents.length();i++)
		{
			MasterPanel sl =(MasterPanel)ents[i];
			entAr.setLength(0);
			entAr.append(ents[i]);
			
			// find bottom left , relative to WCS
			Point3d ptShape[] = sl.plShape().vertexPoints(true);
			Point3d pt=sl.coordSys().ptOrg();
			if(ptShape.length()>0)
			{
				double dX, dY;
				ptShape = Line(ptShape[0],_XW).orderPoints(ptShape );
				dX = ptShape[0].X();
				ptShape = Line(ptShape[0],_YW).orderPoints(ptShape );
				dY = ptShape[0].Y();
				
				pt.setX(dX);
				pt.setY(dY-U(1700));
				
			}	
			ptAr.setLength(0);
			ptAr.append(pt);
			
			tslNew.dbCreate(sScriptname, vUcsX,vUcsY,bmAr, entAr, ptAr, 
				nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance			
			
		}

		eraseInstance();
		return;
		
	}	
//end on insert________________________________________________________________________________


// validate
	if (_Entity.length()<0 && !_Entity[0].bIsKindOf(MasterPanel()))
	{
		eraseInstance();
		return;	
	}
	
// standards
	Entity ent = _Entity[0];
	MasterPanel sl = (MasterPanel)ent;
	PLine plShape = sl.plShape();
	sl.updateYield();
	ChildPanel childs[] = sl.nestedChildPanels();

// query data from and set the style from the childs to the master
	String sChildStyle;
	String sQuality;
	String sArQuality[]={"BVI","VI","NVI"};
	double dAreaNet;
	for (int i = 0; i < childs.length(); i++)
	{
		Sip sip = childs[i].sipEntity();
		String s = sip.style();
		if(i==0)
			sChildStyle=s;
		else if(sChildStyle!=s)
			reportNotice("\n"+T("|Style variation in Masterpanel|")+ " " + sl.number());	

		dAreaNet += sip.plEnvelope().area();
		PLine plOpenings[] = sip.plOpenings();
		for (int o = 0; o < plOpenings.length(); o++)
			dAreaNet -= plOpenings[o].area();	

	
	// extract quality from material
		String sMat = sip.material();
		sMat =sMat.trimLeft();
		sMat = sMat.trimRight();
		int nQ = sMat.find("VI ",0);
		String sQ = sMat.left(nQ+2).right(3);
		sQ =sQ.trimLeft();
		
		nQ = sArQuality.find(sQ);
		
		if(nQ>-1)
			sQuality = sQ;	
		else
			reportNotice("\n"+T("|Unknwon Quality in Masterpanel|")+ " " + sl.number());			
		//if (sMat.getAt(nQ)!=" ")
		//	sQ = sMat.left(nQ+3);
	}

// set the style on dbCreate or on recalc
	if (_bOnDbCreated || _bOnDebug || _bOnRecalc)
		sl.setStyle(sChildStyle);

// ints
	int nUnit = sArUnit.find(sUnit);
	int nLUnit = 2;
	if (nUnit> 2)
		nLUnit = 4;	
			
// collect the required information
	String sHeight, sWidth, sLength, sPeri, sAreaBrut, sAreaNet, sYield,sQtyChilds;
	String sPosNum = sl.number();
	String sInfo = sl.information();
	sQtyChilds=childs.length();


	
// convert to string data
	sAreaNet.formatUnit(dAreaNet  / (U(1,sUnit,2) * U(1,sUnit,2)),nLUnit ,nDecimals);
	sAreaBrut.formatUnit(plShape.area()  / (U(1,sUnit,2) * U(1,sUnit,2)),nLUnit ,nDecimals);
	sPeri.formatUnit(plShape.length()/ U(1,sUnit,2),2,nDecimals);
	sHeight.format("%1." + nDecimals +"f", sl.dThickness()/ U(1,sUnit,2));
	sLength.format("%1." + nDecimals +"f", sl.dLength()/ U(1,sUnit,2));
	sWidth.format("%1." + nDecimals +"f", sl.dWidth()/ U(1,sUnit,2));
	sYield.format("%1." + 1 +"f", sl.dYield()*100);		sYield=sYield+ " %";	

// unitfication
	sAreaNet=sAreaNet+" " +sUnit+"²";
	sAreaBrut=sAreaBrut+" " +sUnit+"²";
	sPeri=sPeri+" " +sUnit;
	sHeight=sHeight+" " +sUnit;
	sWidth=sWidth+" " +sUnit;
	sLength=sLength+" " +sUnit;

	
// collect into array
	String sHeader[] = {T("|PosNum|"),T("|Style|"),T("|Quality|"),T("|Area net|"),T("|Area brut|"),T("|Perimeter|"),T("|Length|"),T("|Width|"),T("|Thickness|"), T("|Yield|"),T("|Information|"), T("|Child Panels|")};	
	String sValue[] ={sPosNum ,sl.style(),sQuality,sAreaNet,sAreaBrut, sPeri,sLength,sWidth, sHeight, sYield,sInfo, sQtyChilds};	



// output
//	dxaout("Level", sLevel);
	dxaout("Code", sl.style());
	dxaout("Width", sl.dWidth()/ U(1,"mm"));
	dxaout("Height", sl.dThickness() / U(1,"mm"));
	dxaout("Length", sl.dLength() / U(1,"mm"));
	dxaout("NetArea", dAreaNet / (U(1,"mm")* U(1,"mm")));
	dxaout("Area", plShape.area()/ (U(1,"mm")* U(1,"mm")));	
	dxaout("Perimeter", plShape.length()/ U(1,"mm"));
//	dxaout("Name", sName);
	dxaout("Sublabel", sPosNum);
	dxaout("Grade", sQuality );
//	dxaout("Volume", dInsulation/ (U(1,"mm")* U(1,"mm")* U(1,"mm")));	
	dxaout("Info", sInfo);
	

// Display
	Display dp(nColor);
	dp.dimStyle(sDimStyle);	

// show in wcs
	Vector3d  vxDp,vyDp,vzDp;
	// show in wcs
	vxDp = _XW;
	vyDp = _YW;	
	vzDp = _ZW;
	
	dp.addViewDirection(vzDp);

// display table
	// find max width
	double dMaxHeader;
	for (int i = 0; i < sHeader.length(); i++)
	{
		double dMax;
		dMax = dp.textLengthForStyle(sHeader[i], sDimStyle);
		if (dMax > dMaxHeader)
			dMaxHeader = dMax;
		}


// draw table		
	double dCrt = -3;
	for (int i = 0; i < sHeader.length(); i++)	
		if (sValue[i] != "" && sValue[i] != "0")
		{
			dp.draw(sHeader[i],_Pt0,vxDp, vyDp,1, dCrt);
			dp.draw(sValue[i],_Pt0 + vxDp * (dMaxHeader + dp.textHeightForStyle(sValue[i], sDimStyle)),vxDp, vyDp,1, dCrt);			
			dCrt -= 3;
		}			





#End
#BeginThumbnail


#End
