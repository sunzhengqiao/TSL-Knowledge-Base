#Version 8
#BeginDescription
This tsl creates a stack of masterpanel clones 

#Versions
Version 1.0 09.11.2022 HSB-17005 initial version
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
//region <History>
// #Versions
// 1.0 09.11.2022 HSB-17005 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select insertion point and append items
/// </insert>

// <summary Lang=en>
// This tsl creates a stack of masterpanel clones 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "MasterPanelStorage")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Item|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Item|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Stack Items|") (_TM "|Select Tool|"))) TSLCONTENT
//endregion



//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	String tDefault =T("|_Default|");
	String tLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
//region Color and view	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	
	int lightblue = rgb(204,204,255);
	int blue = rgb(69,84,185);	
	int darkblue = rgb(26,50,137);	
	int yellow = rgb(241,235,31);
	int darkyellow = rgb(254, 204, 102);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);	

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
//endregion 	
	
//end Constants//endregion

//region properties
	String sStorageIDName=T("|Storage ID|");	
	PropString sStorageID(nStringIndex++, "001", sStorageIDName);	
	sStorageID.setDescription(T("|Defines the StorageID|"));
	sStorageID.setCategory(category);

	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "@(Number)", sFormatName);	
	sFormat.setDescription(T("|Defines the format to display properties|"));
	sFormat.setCategory(category);

	String sSolidColorName=T("|Color|");	
	PropInt nSolidColor(nIntIndex++, 7, sSolidColorName);	
	nSolidColor.setDescription(T("|Defines the Color of the solid|"));
	nSolidColor.setCategory(category);	

// Stacking
category = T("|Stacking|");
	String sBattenHeightName=T("|Batten Height|");	
	PropDouble dBattenHeight(nDoubleIndex++, U(0), sBattenHeightName, _kLength);	
	dBattenHeight.setDescription(T("|Defines a uniform batten height between each stack|"));
	dBattenHeight.setCategory(category);
	if (dBattenHeight < 0)dBattenHeight.set(0);
	
	
	String tSMDisabled = T("<|Disabled|>"), tSMOnce = T("|Only Once|"), tSMAlways = T("|Always|");
	String sStackModes[] = {tSMDisabled,tSMOnce,tSMAlways };
	String sStackModeName=T("|Stack Mode|");	
	PropString sStackMode(nStringIndex++, sStackModes, sStackModeName);	
	sStackMode.setDescription(T("|Defines the StackMode|"));
	sStackMode.setCategory(category);

// Display
category = T("|Display|");

	
	String sColorName=T("|Text Color|");	
	PropInt nColor(nIntIndex++, 7, sColorName);	
	nColor.setDescription(T("|Defines the Color|"));
	nColor.setCategory(category);
	
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(300), sTextHeightName, _kLength);	
	dTextHeight.setDescription(T("|Defines the text height of the dimension|") + T(", |0 = byDimstyle|"));
	dTextHeight.setCategory(category);
	
	String sDimStyleName=T("|DimStyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the DimStyle|"));
	sDimStyle.setCategory(category);
	
	
	

//endregion 

	Vector3d vecX = _XW;
	Vector3d vecY = _YW;
	Vector3d vecZ = _ZW;
	Line lnZ(_Pt0, vecZ);
	CoordSys cs(_Pt0, vecX, vecY, vecZ);

//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }


		Map mapAdd;
		mapAdd.setString(sStorageIDName, sStorageID);
		mapAdd.setDouble(sBattenHeightName, dBattenHeight,_kLength);
		
		sFormat.setDefinesFormatting("TslInstance", mapAdd);

	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();
	
//	// prompt for entities // TODO
//		Entity ents[0];
//		PrEntity ssE(T("|Select masterpanel clones|"), TslInst());
//		if (ssE.go())
//			ents.append(ssE.set());
//		
//		for (int i=0;i<ents.length();i++) 
//		{  
//			TslInst t = (TslInst)ents[i]; 
//			if (t.bIsValid() && t.scriptName().find("MasterPanelClone", 0, false)>-1)
//				_Entity.append(t);
//		}//next i
		_Pt0 = getPoint();
		
//		Point3d ptMax =  _Pt0;
//		for (int i=0;i<ents.length();i++) 
//		{ 
//			Entity ent = ents[i]; 
//			
//			Body bd = ent.realBody();
//			
//			if (_Entity.find(ent)>-1 || bd.volume()<pow(dEps,3))
//			{ 
//				continue;
//			}	
//			
//			Map mapX;
//			mapX.setEntity("parent", _ThisInst);
//			ent.setSubMapX("MasterStorage", mapX);
//			
//
//			Point3d pts[]=bd.extremeVertices(_ZW);
//			double dZ = bd.lengthInDirection(_ZW);
//			
//			PlaneProfile pp(cs);
//			pp.unionWith(bd.shadowProfile(Plane(pts.first(), vecZ)));
//			
//			Point3d ptFrom = pp.ptMid() - .5 * vecX * pp.dX();
//			Point3d ptTo = _Pt0 + vecZ * vecZ.dotProduct(ptMax - _Pt0);
//			
//			Vector3d vec = ptTo - ptFrom;
//			ent.transformBy(vec);
//			ptMax += vecZ * dZ;
//			_Entity.append(ent);
//		}//next i		

		return;
	}			
//endregion 


//region Storage defaults
	
	Plane pnZ(_Pt0, vecZ);
	//addRecalcTrigger(_kGripPointDrag, "_Pt0");
	setExecutionLoops(2);
	
	double dVolume;
//endregion 

 



//region Collect Storage Items
	Entity items[0];
	Body bodies[0];
	Point3d ptOrgs[0];
	
	Point3d ptsZ[0];
	for (int i=_Entity.length()-1; i>=0 ; i--) 
	{ 
		Entity ent=_Entity[i];
		
		Body bd = ent.realBody();
		Point3d pts[] = bd.extremeVertices(_ZW);
		if (bd.volume()<pow(dEps,3) || pts.length()<2)
		{ 
			continue;
		}
		
	// get/set storage parent
		Map mapX = ent.subMapX("MasterStorage");
		Entity p = mapX.getEntity("parent");
		if (p.bIsValid() && p!=_ThisInst) // not my parent
		{ 
			_Entity.removeAt(i);
			continue;
		}
		else
		{ 
			p = _ThisInst;
			mapX.setEntity("parent", p);
			ent.setSubMapX("MasterStorage", mapX);
		}		

		bodies.append(bd);
		items.append(ent);	
		ptOrgs.append(pts.first());
		setDependencyOnEntity(ent);
		ptsZ.append(pts);
		
		dVolume += bd.volume();
	}//next i	
//endregion

//region on the event of dragging the origin
	if (_kNameLastChangedProp == "_Pt0")// || Vector3d(_Pt0-ptPrev).length()>dEps)
	{ 
		Vector3d vecMove = _Pt0 - (_PtW + _Map.getVector3d("vecOrg"));
	// move item if _Pt0 gets dragged	
		if (!vecMove.bIsZeroLength())
			for (int i=0;i<bodies.length();i++) 
				items[i].transformBy(vecMove);
		
		setExecutionLoops(2);
		return;
	}
//endregion

//region Stack vertically
	int bOrderStack = sStackMode != tSMDisabled;

	if (bOrderStack && items.length()>0)
	{ 
	// order alphabetically
		for (int i=0;i<bodies.length();i++) 
			for (int j=0;j<bodies.length()-1;j++) 
			{
				double d1 = vecZ.dotProduct(ptOrgs[j]-_Pt0);
				double d2 = vecZ.dotProduct(ptOrgs[j+1]-_Pt0);
				
				if (d2<d1)
				{ 
					bodies.swap(j, j + 1);
					items.swap(j, j + 1);
					ptOrgs.swap(j, j + 1);
				}
			}

		Body bdComps[0];
		for (int i = 0; i < bodies.length(); i++)
		{
			Body bd = bodies[i];
			Point3d ptOrg = ptOrgs[i];
			Vector3d vecMove = vecZ * vecZ.dotProduct(_Pt0 - ptOrg);
			bd.transformBy(vecMove);
			ptOrg.transformBy(vecMove);
			//bd.vis(2);
			
			
			for (int j = 0; j < bdComps.length(); j++)
			{
				Body bdc = bdComps[j];
				bdc.vis(j);
				bdc.intersectWith(bd);
				if (bdc.volume() > pow(dEps, 3))
				{
					Point3d pts[] = bdc.extremeVertices(vecZ);
					if (pts.length() > 0)
					{
						vecMove = vecZ * (vecZ.dotProduct(pts.last() - ptOrg)+dBattenHeight);
						ptOrg.transformBy(vecMove);
						bd.transformBy(vecMove);
					}
				}
			}//next j
			bdComps.append(bd);
			//bd.vis(i + 20);
			
			vecMove = vecZ * vecZ.dotProduct(ptOrg - ptOrgs[i]);
			items[i].transformBy(vecMove);
		}

		if (sStackMode == tSMOnce)
			sStackMode.set(tSMDisabled);
	}

//endregion 





//region Draw Default Storage Outline
	double dX = U(12000), dY = U(3000);
	
	PlaneProfile ppBase(cs);
	ppBase.createRectangle(LineSeg(_Pt0 - .5 * vecY * dY, _Pt0 + vecX * dX + .5 * vecY * dY), vecX, vecY );	
	ptsZ = lnZ.orderPoints(ptsZ, dEps);
//endregion 

//region TRIGGER

//region Trigger AddItem
	String sTriggerAddItem = T("|Add Item|");
	addRecalcTrigger(_kContextRoot, sTriggerAddItem );
	if (_bOnRecalc && (_kExecuteKey==sTriggerAddItem || _kExecuteKey==sDoubleClick))
	{
	
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select entities|"), Entity());
		if (ssE.go())
			ents.append(ssE.set());
		
		Point3d ptMax = ptsZ.length() > 0 ? ptsZ.last() : _Pt0;
		for (int i=0;i<ents.length();i++) 
		{ 
			Entity ent = ents[i]; 
			
			Body bd = ent.realBody();
			
			if (_Entity.find(ent)>-1 || bd.volume()<pow(dEps,3))
			{ 
				continue;
			}	
			
			Map mapX;
			mapX.setEntity("parent", _ThisInst);
			ent.setSubMapX("MasterStorage", mapX);
			

			Point3d pts[]=bd.extremeVertices(_ZW);
			double dZ = bd.lengthInDirection(_ZW);
			
			PlaneProfile pp(cs);
			pp.unionWith(bd.shadowProfile(Plane(pts.first(), vecZ)));
			
			Point3d ptFrom = pp.ptMid() - .5 * vecX * pp.dX();
			Point3d ptTo = _Pt0 + vecZ * vecZ.dotProduct(ptMax - _Pt0);
			
			Vector3d vec = ptTo - ptFrom;
			ent.transformBy(vec);
			ptMax += vecZ * dZ;
			_Entity.append(ent);
		}//next i
		setExecutionLoops(2);
		return;
	}//endregion

//region Trigger RemoveItem
	String sTriggerRemoveItem = T("|Remove Item|");
	addRecalcTrigger(_kContextRoot, sTriggerRemoveItem );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveItem)
	{
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select entities|"), Entity());
		if (ssE.go())
			ents.append(ssE.set());
		
	// prompt for point input
		PrPoint ssP(TN("|Select new location|"),_Pt0); 
		Point3d ptTo = _Pt0;
		if (ssP.go()==_kOk) 
			ptTo=ssP.value();
		Vector3d vec = ptTo-_Pt0;	
				
		for (int i=0;i<ents.length();i++) 
		{ 
			int n = _Entity.find(ents[i]);
			if (n>-1)
			{
				ents[i].removeSubMapX("MasterStorage");
				ents[i].transformBy(vec);
				_Entity.removeAt(i);
			}			
		}//next i
		
			
		setExecutionLoops(2);
		return;
	}//endregion	
	
//region Trigger Stack Items
	if (sStackMode == tSMDisabled)
	{ 
		String sTriggerStackItems = T("|Stack Items|");
		addRecalcTrigger(_kContextRoot, sTriggerStackItems );
		if (_bOnRecalc && _kExecuteKey==sTriggerStackItems)
		{
			sStackMode.set(tSMOnce);		
			setExecutionLoops(2);
			return;
		}		
	}
//endregion	

	
	
	
//endregion 




//region Display
	String text = _ThisInst.formatObject(sFormat);
	
	Display dp(nColor), dpFreight(nSolidColor);
// draw freight display
	String sDispRepName="Freight";
	if (_ThisInst.dispRepNames().find(sDispRepName)>-1)
		dpFreight.showInDispRep(sDispRepName); 			
	int bUseTextHeight; // to be used for dimensions
	double textHeight = dTextHeight;
	if (dTextHeight<= 0) 
		textHeight = dp.textHeightForStyle("O", sDimStyle);
	else 
	{
		bUseTextHeight = true;
		dp.textHeight(textHeight);
	}
	
	Point3d ptText = _Pt0 -vecX*textHeight;
	dp.draw(text, ptText, vecY, -vecX, 0, 1);
	
	dp.color(nSolidColor);	
	
	PlaneProfile ppShadow(cs), ppBottom(cs);
	for (int i=0;i<bodies.length();i++) 
	{ 
		Body bd = bodies[i];

		dpFreight.draw(bd);
		PlaneProfile pp = bd.shadowProfile(pnZ);
		ppShadow.unionWith(pp); 
		
		pp = bd.extractContactFaceInPlane(pnZ, dEps);
		if (pp.area()>pow(dEps,2))
			ppBottom.unionWith(pp);	
	}//next i

// items found
	PlaneProfile ppOverall(cs);
	if (ppShadow.area() > pow(dEps, 2))
	{
		ppOverall = ppShadow;
		dp.draw(ppShadow);
		if (ppBottom.area() > pow(dEps, 2))
		{
			PlaneProfile pp = ppBottom; pp.shrink(U(20));
			ppBottom.subtractProfile(pp);
			dp.draw(ppBottom,_kDrawFilled,80);		
		}		
	}
	else
	{
		ppOverall = ppBase;
		dp.draw(ppBase);
	}
	
//endregion 


//region Store location and data
	_Map.setVector3d("vecOrg", _Pt0-_PtW);	
	_Map.setInt("isPackageContainer", true); // flag to be recognized by shopdraw showset extender
	
	
// write extended package data
	Map mapData;
//	if (dArea>pow(dEps,2))
//		mapData.setDouble("Area", dArea);
	mapData.setDouble("Weight", dVolume * U(10e-10)/U(1,"mm")*500);
	mapData.setDouble("Volume", dVolume * U(10e-10)/U(1,"mm")); 
//	mapData.setInt("isVisible", isVisible);
//	mapData.setInt("hasLiftingStrap", bLiftingDeviceTypes[0]);//0 = Hebe, 1=Rampa, 2=Würth, 3=Stahl
//	mapData.setInt("hasLiftingSleeve", bLiftingDeviceTypes[1]);//0 = Hebe, 1=Rampa, 2=Würth, 3=Stahl
//	mapData.setInt("hasLiftingWuerth", bLiftingDeviceTypes[2]);//0 = Hebe, 1=Rampa, 2=Würth, 3=Stahl
//	mapData.setInt("hasLiftingSteel", bLiftingDeviceTypes[3]);//0 = Hebe, 1=Rampa, 2=Würth, 3=Stahl
	mapData.setInt("QuantityItems", items.length());
	mapData.setDouble("SizeX", ppOverall.dX());
	mapData.setDouble("SizeY", ppOverall.dY());
	double dDimensionZ;
	if (ptsZ.length()>1)
		dDimensionZ = vecZ.dotProduct(ptsZ.last() - ptsZ.first());
	mapData.setDouble("SizeZ", dDimensionZ);
//	if (elements.length()>0)
//		mapData.setEntityArray(elements, true, "Element[]", "", "Element");

//// add collected lifting systems as string for package based header content
//	String sLiftingType,sLiftingTypes[] = {"H", "R", "W", "S"}, sSep;
//	for(int i=0;i<bLiftingDeviceTypes.length();i++)
//	{
//		if(bLiftingDeviceTypes[i])
//			sLiftingType+=sSep+sLiftingTypes[i];
//		sSep=", ";
//	}
//	mapData.setString("LiftingTypes", sLiftingType);
//	mapData.setDouble("BaseLayerThickness", dBaseThickness);
//	mapData.setDouble("TopLayerThickness", dTopThickness);
	String sOrderIDs[0];
	Map mapOrders;
	for (int i=0;i<sOrderIDs.length();i++)
		mapOrders.appendString("OrderID", sOrderIDs[i]);
	mapData.setMap("OrderID[]", mapOrders);

// write package parent data		
	Map mapX;
	mapX.setString("MyUid", _ThisInst.handle());
	mapX.setPoint3d("ptOrg", _Pt0, _kRelative);
	mapX.setVector3d("vecX", vecX*ppOverall.dX(), _kScalable); // coordsys carries size
	mapX.setVector3d("vecY", vecY*ppOverall.dY(), _kScalable);
	mapX.setVector3d("vecZ", vecZ*dDimensionZ, _kScalable);
	
	mapX.setDouble("dOneUnit", 1); // add the lenght of 1 inch,mm,m whatever units the drawing is in, to allow to make the vecX, vecY and vecZ unitless 
	
	mapX.setMap("PackageData", mapData);	
	_ThisInst.setSubMapX("Hsb_PackageParent",mapX);
	
	sFormat.setDefinesFormatting(_ThisInst, mapData);
	
//endregion 
#End
#BeginThumbnail

#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17005 initial version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="11/9/2022 12:09:49 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End