#Version 8
#BeginDescription
EN
/// This tsl defines a detail to be displayed with an element
/// Pick two points defining the diagonal of the detail area and select element(s) and entities to display
DE
/// Dieses TSL definiert einen Bereich für Details, welche mit einem Element im Papierbereich dargestellt werden.
/// Weitere Informationen finden Sie in der Dokumentation des DACH Contents
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl defines a detail to be displayed with an element
/// </summary>

/// <summary Lang=de>
/// Dieses TSL definiert einen Bereich für Details, welche mit einem Element im Papierbereich dargestellt werden.
/// </summary>


/// <insert Lang=en>
/// Pick two points defining the diagonal of the detail area and select element(s) and entities to display
/// </insert>

/// <insert Lang=de>
/// Weitere Informationen finden Sie in der Dokumentation des DACH Contents
/// </insert>

/// History
///<version  value="2.0" date="12jun12" author="th@hsbCAD.de">completely revised, additional script not required as this script executes in two different OPM modes</version>


//basics and props
	U(1,"mm");
	double dEps=U(.1);
	
	String sArProp[0];
	int nArIndex[] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20};
// bOnInsert
	if(_bOnInsert){
		if (insertCycleCount()>1) { eraseInstance(); return; }

		int nMode;
		PrEntity ssE(T("|Select elements (Enter to select a viewport)|"),Element());
		Entity ents[0];
  		if (ssE.go())
		{
			ents = ssE.set();
			for (int i = 0; i < ents.length(); i++)
			{
				if (ents[i].bIsKindOf(ElementWall()) || ents[i].bIsKindOf(ElementRoof()))
				{
					_Element.append((Element)ents[i]);
				}
			}
		}
		if(_Element.length()<1)
		{
			Viewport vp = getViewport(); // select viewport
			_Viewport.append(vp);
			nMode=1;	
		}	
	
	// declare properties by mode
		String sMsg1;
		if (nMode==0)
		{
			sMsg1 = T("|Select lower left corner|");
			sArProp.append(T("|Detail Name|"));
			PropString sDetailName(0,T("|Detail|"),sArProp[sArProp.length()-1]);		

			sArProp.append(T("|Detail Index|"));
			PropInt nIndex(0,nArIndex,sArProp[sArProp.length()-1]);	
		
			sArProp.append(T("|Dimstyle|"));
			PropString sDimStyle(1,_DimStyles,sArProp[sArProp.length()-1]);	
			
			sArProp.append(T("|Text Height|"));
			PropDouble dTxtH(0,U(150),sArProp[sArProp.length()-1]);
		
			sArProp.append(T("|Color|"));
			PropInt nColor(1,170,sArProp[sArProp.length()-1]);				
		}	
		else if (nMode==1)
		{
			setOPMKey("Layout");
			sMsg1 = T("|Pick point|");
			
			sArProp.append(T("|Detail Index|"));
			PropInt nIndex(0,nArIndex,sArProp[sArProp.length()-1]);	
			
			sArProp.append(T("|Scale Factor|"));
			PropDouble dScaleFactor(0,1,sArProp[sArProp.length()-1],_kNoUnit);
				
			sArProp.append(T("|Text Height|"));
			PropDouble dTxtH(1,U(20),sArProp[sArProp.length()-1]);
			dTxtH.setDescription(T("|Defines the Text Height|") + " " + T("|0 = do not show Detail Name|"));
		}
		
		
	
	// show the dialog
		showDialog();		
		_Pt0 = getPoint(sMsg1);

	// get base rectangle	
		if (nMode==0)	
		{		
			PrPoint ssP("\n" + T("|Select upper right corner|"),_Pt0);
			if (ssP.go()==_kOk) // do the actual query
				_PtG.append(ssP.value()); // retrieve the selected point
			_PtG.append(_Pt0+_XE*U(50));
		// no valid range
			if (_PtG.length()<2)
			{
				eraseInstance();
				return;	
			}	
				
	  		PrEntity ssEn(T("|Select a set of detail entities|"), Entity());
	  		if (ssEn.go()) {
	    		Entity ents[0]; // the PrEntity will return a list of entities, and not elements
	    		// copy the list of selected entities to a local array: for performance and readability
	    		ents = ssEn.set(); 
				_Entity.append(ents);
	  		}
		}
		_Map.setInt("mode",nMode);
		return;
	}		

// this script runs in two different modes
	// 0 = model, defines the detail entities
	// 1 = paperspace, defines the scale and zooming
	int nMode = _Map.getInt("mode");

// model
	if (nMode==0)
	{
	// redeclare properties
		sArProp.setLength(0);
		sArProp.append(T("|Detail Name|"));
		PropString sDetailName(0,T("|Detail|"),sArProp[sArProp.length()-1]);		

		sArProp.append(T("|Detail Index|"));
		PropInt nIndex(0,nArIndex,sArProp[sArProp.length()-1]);	
	
		sArProp.append(T("|Dimstyle|"));
		PropString sDimStyle(1,_DimStyles,sArProp[sArProp.length()-1]);	
		
		sArProp.append(T("|Text Height|"));
		PropDouble dTxtH(0,U(150),sArProp[sArProp.length()-1]);
	
		sArProp.append(T("|Color|"));
		PropInt nColor(1,170,sArProp[sArProp.length()-1]);				
		
		
	// declare standards
		Element el[0];
		el = _Element;
		if (el.length() <1)
		{
			eraseInstance();
			return;
		}
		
	// assigning
		for(int e=0;e<el.length();e++)
		{
			assignToElementGroup(el[e],false,0,'J');	
			Group grEl = el[e].elementGroup();
			for(int i=0;i<_Entity.length();i++)
			{
			// validate if this entity already belongs to this element group
				int bIsLinked;
				Group grAll[] = _Entity[i].groups();
				for(int g=0;g<grAll.length();g++)
					if (grAll[g].namePart(0)==grEl.namePart(0) && grAll[g].namePart(1)==grEl.namePart(1))	
					{
						bIsLinked=true;
						break;
					}
				if (el.find(_Entity[i])<0 && !bIsLinked)
					_Entity[i].assignToElementGroup(el[e],false,0,'I');	
			}
		}
		
	// validate grips
		if (_PtG.length()<1)
			_PtG.append(_Pt0 + _XE*U(500)+_YE*U(500));
		if (_PtG.length()<2)
			_PtG.append(_Pt0 + _XE*U(50));
		if (Vector3d(_Pt0-_PtG[1]).length()<U(50))
			_PtG[1] = _Pt0 + _XE*U(50);

	// detail coordSys
		Vector3d vx, vy, vz=_ZE;
		vx=_PtG[1]-_Pt0;
		vx.normalize();
		vy = vx.crossProduct(-vz);
		vx.vis(_Pt0,1);
		vy.vis(_Pt0,3);
		vz.vis(_Pt0,150);

	// store width and height in modelspace
		if (_bOnDbCreated || _bOnRecalc || _kNameLastChangedProp=="_PtG0")
		{
			double dXMs, dYMs ;
			dXMs = abs(vx.dotProduct(_PtG[0]- _Pt0));
			dYMs = abs(vy.dotProduct(_PtG[0]- _Pt0));
			_Map.setDouble("dXMs", dXMs);
			_Map.setDouble("dYMs", dXMs);
		}	
		
	// repos _PtG[0] when rotating grip 1
		if (_kNameLastChangedProp=="_PtG1")
		{
			_PtG[0] = _Pt0+vx*_Map.getDouble("dXMs")+vy*_Map.getDouble("dYMs");
		}		
		
			 	
	// validate detail name
		if (_bOnDbCreated || _bOnRecalc || _kNameLastChangedProp == sArProp[0])
		{
			Entity entDetails[] = Group().collectEntities(true,TslInst(),_kModelSpace);
			String sDetailNames[0];;
			for (int i = 0; i < entDetails.length(); i++)
				if (entDetails[i].bIsKindOf(TslInst()))
				{
					TslInst tsl = (TslInst)entDetails[i];
					if (tsl.scriptName()==scriptName() && tsl!=_ThisInst)
						sDetailNames.append(tsl.propString(0));
				}
		
			String sNewDetailName = sDetailName;
			int n, nFound;
			nFound=sDetailNames.find(sNewDetailName);
				
			while (nFound>-1 && n<1000)
			{
				sNewDetailName = sDetailName +" " + (n+1);
				sDetailNames.find(sNewDetailName);
				nFound=sDetailNames.find(sNewDetailName);
				n++;
			}
		// change detail name and inform user	
			if (sNewDetailName!=sDetailName)
			{
				reportMessage("\n" + T("|Detail Name|") + " '" + sDetailName + "' " + T("|already exists in this drawing.|") + " " + T("|Name has been changed to:|") + " '" + sNewDetailName+ "' ");
				sDetailName.set(sNewDetailName);		
			}
		}

	// Display
		Display dp(nColor);
		dp.dimStyle(sDimStyle);
		dp.textHeight(dTxtH);
		PLine plRec(vz);
		plRec.createRectangle(LineSeg(_Pt0,_PtG[0]),vx,vy);
		dp.draw(plRec);	
		dp.draw(sDetailName,_Pt0,vx,vy,1,-3);
		
	// publish coordSys
		_Map.setVector3d("vx",vx);
		_Map.setVector3d("vy",vy);
		_Map.setVector3d("vz",vz);
		
	
		
	}
// END model
// paperspace
	else if (nMode==1)
	{
		setOPMKey("Layout");	
	// redeclare properties
		sArProp.setLength(0);
		sArProp.append(T("|Scale Factor|"));
		PropDouble dScaleFactor(0,1,sArProp[sArProp.length()-1],_kNoUnit);

		sArProp.append(T("|Detail Index|"));
		PropInt nIndex(0,nArIndex,sArProp[sArProp.length()-1]);	

		sArProp.append(T("|Text Height|"));			
		PropDouble dTxtH(1,U(20),sArProp[sArProp.length()-1]);
		dTxtH.setDescription(T("|Defines the Text Height|") + " " + T("|0 = do not show Detail Name|"))	;

	// validate viewport
		if (_Viewport.length()==0) return;
		Viewport vp = _Viewport[0];
		Element el = vp.element();
	
	// check if this viewport has hsb_data
		if (!el.bIsValid()) 
		{
			reportMessage("\n"+T("|The viewport needs to have hsbData attached!|"));
			return;
		}

	// check attached tsl's and get the midpoint of details
		int bOk;
		Point3d ptMid;
		Map mapTsl;
		TslInst tsls[] = el.tslInstAttached();
		TslInst tsl;
		for (int i = 0; i < tsls.length(); i++) {
			
			String sScriptNameX= tsls[i].scriptName();
			sScriptNameX.makeUpper();
			String sScriptName= scriptName().makeUpper();
			if (sScriptNameX== sScriptName && nIndex == tsls[i].propInt(0))
			{
				tsl = tsls[i];
				ptMid = (tsl.gripPoint(0)+tsl.ptOrg())/2;
				mapTsl = tsl.map();
				bOk = TRUE;
				break;
			}
		}// next i

	
	// detail found
		CoordSys csEl = el.coordSys();
		Point3d ptCen = vp.ptCenPS();
		CoordSys csMs2Ps;
		if (bOk){
			// get the coordinate system of the element, and calculate a new ModelSpaceToPaperSpace transformation
			csMs2Ps.setToAlignCoordSys(ptMid,mapTsl.getVector3d("vx"),mapTsl.getVector3d("vy"),mapTsl.getVector3d("vz"),
				ptCen,_XW*dScaleFactor,_YW*dScaleFactor,_ZW*dScaleFactor);	
		}
		else
			csMs2Ps.setToAlignCoordSys(Point3d(0,0,U(1000000)),_XW,_YW,_ZW,ptCen,_XW,_YW,_ZW);	
		vp.setCoordSys(csMs2Ps); // finally set the transformation to the viewport

	// Display
		Display dp(-1);
		if (tsl.bIsValid())
		{
			dp.color(tsl.propInt(1));
			dp.dimStyle(tsl.propString(1));
			dp.textHeight(dTxtH);		
			dp.draw(tsl.propString(0),_Pt0,_XW,_YW,1,0);
		}
	}
// END paperspace
	

#End
#BeginThumbnail
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
*`4`%`!0`4`?_V0``
`






#End
