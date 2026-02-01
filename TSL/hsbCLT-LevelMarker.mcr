#Version 8
#BeginDescription
version  value="1.1" date="03jul14" author="th@hsbCAD.de"> 
bugfix special detection

/// Dieses TSL erzeugt eine Höhenkote an einem oder meherern Panelen. Die Panele dürfen in der XY-Welt-Ebene oder senkrecht zu Z-Welt gezeichnet sein.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords CLT;Höhenkote;Symbol
#BeginContents
/// <summary Lang=en>
/// Dieses TSL erzeugt eine Höhenkote an einem oder meherern Panelen. Die Panele dürfen in der XY-Welt-Ebene oder senkrecht zu Z-Welt gezeichnet sein.
/// </summary>

/// History
///<version  value="1.1" date="03jul14" author="th@hsbCAD.de"> bugfix special detection </version>
///<version  value="1.0" date="03jul14" author="th@hsbCAD.de"> initial </version>



// basics and props
	U(1,"mm");
	double dEps = U(0.1);
	int nDoubleIndex, nStringIndex;
	
	String sElevationName= T("|Elevation|");
	PropDouble dElevation (nDoubleIndex++, U(500),sElevationName);

	String sSizeName= T("|Size|");
	PropDouble dSize (nDoubleIndex++, U(50),sSizeName);
	
	String sStyleName= T("|Style|");
	String sStyles[] = {T("|Finished Face|"), T("|Raw Face|")};
	PropString sStyle(nStringIndex++, sStyles,sStyleName);
	
	String sTypeName= T("|Type|");
	String sTypes[] = {T("|Floor|"), T("|Ceiling|")};
	PropString sType(nStringIndex++, sTypes,sTypeName);

	String sDimStyleName= T("|Dimstyle|");
	String sDimStyles[0];sDimStyles = _DimStyles;
	// order
	for (int i=0; i<sDimStyles.length();i++)
		for (int j=0; j<sDimStyles.length()-1;j++)
			if (sDimStyles[j]>sDimStyles[j+1])
				sDimStyles.swap(j,j+1);
				
	PropString sDimStyle(nStringIndex++, sDimStyles,sDimStyleName);
		
	PropInt nColor(0,211,T("|Color|"));

	String sSpecials[] = {"KLH"}; // declare a list of supported specials. specials might change behaviour and available properties
	int nSpecial = sSpecials.find(projectSpecial().makeUpper());

	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
	
	// set properties from catalog
		if (_kExecuteKey!="")
			setPropValuesFromCatalog(_kExecuteKey);			
		else
			showDialog();
		
		PrEntity ssE(T("|Select CLT panels|"), Sip());
		Entity ents[0];
		if (ssE.go()) 
			ents= ssE.set();
	
	// cast to sip
		Sip sips[0];
		for (int e =0;e<ents.length();e++)
			sips.append((Sip)ents[e]);
		if (sips.length()<1)
		{
			eraseInstance();
			return;
		}	
		_Pt0 =getPoint();	
		
		
	// get ref coordsys from first selected sip
		Vector3d vecZ =sips[0].vecZ();
		int bIs3D= vecZ.isPerpendicularTo(_ZW);
		int bIs2D= vecZ.isParallelTo(_ZW);
		Vector3d vecNormal = _ZW;
		if (bIs2D)vecNormal = _YW;

		Plane pn(_Pt0,vecNormal );			
	// filter out any sip which does not match one of these criterias
	//		3D
	//			aligned as a wall in 3D
	//			level is intersecting the panel
	//		2D
	//			panel has wall association
	//			level is intersecting the panel		
		for (int e=0;e<sips.length();e++)
		{
			Sip sip = sips[e];
			
		// test special conditions
			if (nSpecial==0 && (sip.label().left(1)!="W" && sip.label().find("*W",0)<0))
				continue;	
			
			
		// not proper aligned
			if ((bIs3D && !sip.vecZ().isPerpendicularTo(_ZW)) ||
				(bIs2D && !sip.vecZ().isParallelTo(_ZW)))
			{
				continue;
			}		
	
		// does not intersect
			PLine pl = sip.plEnvelope();
			Point3d pts[] = pl.intersectPoints(pn);
			if (pts.length()<1)
			{
				continue;
			}
			_Sip.append(sip);
		}
		_Map.setVector3d("normal",vecNormal);		
		return;
	}
// end on insert

// validate sset
	if (_Sip.length()<1)
	{
		eraseInstance();
		return;
	}	
	Sip sip = _Sip[0];
	assignToGroups(sip);
	
	
// delete childs	
	String sDeleteTrigger = T("|Delete Childs|");
	addRecalcTrigger(_kContext, sDeleteTrigger );
	if (_bOnRecalc && _kExecuteKey==sDeleteTrigger)
	{
		for (int e=_Entity.length()-1;e>=0;e--)
		{
			Entity ent = _Entity[e];
			TslInst tsl =(TslInst)ent;
			if (tsl.bIsValid() && tsl.scriptName()==scriptName())
			{
				_Entity.removeAt(e);
				ent.dbErase();	
			}
		}
	}	

	
	
// the alignment of the reference plane is static and set on insert 
	Vector3d vecNormal = _ZW;
	if (_Map.hasVector3d("normal"))
		vecNormal=_Map.getVector3d("normal");
	Plane pn(_Pt0,vecNormal);
		
// get child mode
	Entity entParent = _Map.getEntity("parent");
	int bIsChild = entParent.bIsValid();
	
	// 0 = parent level marker
	// 1 = child level marker	
	// the parent level marker is the one which is created on insert, based on the first selected panel
	// the childs are dependent from the parent, unless released to become a parent on their own

// lock location and properties of childs
	if (bIsChild)
	{
		//if (_kNameLastChangedProp=="_Pt0")
			setExecutionLoops(2);
		
		_Entity.append(entParent);	
		setDependencyOnEntity(entParent);
		dElevation.setReadOnly(true);
		dSize.setReadOnly(true);
		sStyle.setReadOnly(true);
		sType.setReadOnly(true);
		
		TslInst tslParent =(TslInst)entParent ;
		if (tslParent.bIsValid())
		{
			Point3d ptOrg = tslParent.ptOrg();
			double d=vecNormal.dotProduct(ptOrg-_Pt0);
			if (abs(d)>dEps)
			{
				_Pt0.transformBy(vecNormal*d);
			}
			if (tslParent.propDouble(0)!=dElevation)dElevation.set(tslParent.propDouble(0));
			if (tslParent.propDouble(1)!=dSize)dSize.set(tslParent.propDouble(1));
			if (tslParent.propString(0)!=sStyle)sStyle.set(tslParent.propString(0));
			if (tslParent.propString(1)!=sType)sType.set(tslParent.propString(1));	
		}			
	}


// the coordSys of the level marker
	//vecNormal.vis(_Pt0,150);
	Vector3d vecX, vecY, vecZ;
	vecY=vecNormal;					 vecY.vis(_Pt0,3);
	vecZ = sip.vecZ();				 vecZ.vis(_Pt0,150);
	vecX = vecY.crossProduct(vecZ);vecX.vis(_Pt0,1);
	_Pt0.transformBy(vecZ*vecZ.dotProduct(sip.ptCenSolid()-_Pt0));	


// the type and style
	int nType = sTypes.find(sType,0);
	int nStyle = sStyles.find(sStyle,0);	
	
// get ref location
	PLine pl = sip.plEnvelope();
	Point3d ptsInt[] = Line(_Pt0,-vecX).orderPoints(pl.intersectPoints(pn));	

	Point3d ptRef = sip.ptCen()+vecX*.5*sip.dD(vecX);
	ptRef.transformBy(vecNormal*vecNormal.dotProduct(_Pt0-ptRef));
	if (ptsInt.length()>0)
		ptRef = ptsInt[0];
	ptRef.transformBy(vecZ*vecZ.dotProduct(sip.ptCenSolid()-ptRef));	
	ptRef.vis(6);


// declare the tsl props
	TslInst tslNew;
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	GenBeam gbs[1];
	Entity ents[0];
	Point3d pts[1];
	int nProps[]={nColor};
	double dProps[]={dElevation,dSize};
	String sProps[]={sStyle, sType, sDimStyle};
	Map mapTsl;
	String sScriptname = scriptName();

	mapTsl.setVector3d("normal", vecNormal);
	mapTsl.setEntity("parent", _ThisInst);



// creation flag
	int bCreate=_bOnDbCreated;



// add childs	
	Sip sips2Clone[0];
	String sAddTrigger = T("|Add Childs|");
	addRecalcTrigger(_kContext, sAddTrigger );
	if (_bOnRecalc && _kExecuteKey==sAddTrigger )
	{
		PrEntity ssE(T("|Select CLT panels|"), Sip());
		Entity entsNew[0];
		if (ssE.go()) 
			entsNew= ssE.set();
	
		for (int e=entsNew.length()-1;e>=0;e--)
		{
			int n = _Sip.find(entsNew[e]);	
			if (n>=0)
			{
				Entity entsTool[] =_Sip[n].eToolsConnected();
				for (int t=0;t<entsTool.length();t++)
				{
					TslInst tsl = (TslInst)entsTool[t];
					if (tsl.bIsValid() && tsl.scriptName() == scriptName() && tsl!=_ThisInst)
					{
						entsNew.removeAt(e);
						break;// t
					}
				}
			}
		}
		
		for (int e=entsNew.length()-1;e>=0;e--)
		{
			Sip sipNew = (Sip)entsNew[e];
			if (sipNew.bIsValid())
			{
			// test special conditions
				if (nSpecial==0 && (sip.label().left(1)!="W" && sip.label().find("*W",0)<0))
					continue;
				sips2Clone.append(sipNew);
			}
		}
		bCreate=true;
	}	
	else
	{	
		sips2Clone = _Sip;
		sips2Clone.removeAt(0);	
	}


// create childs
	if (bCreate)
	{
		for (int i=0;i<sips2Clone.length();i++)
		{
			Sip sipThis = sips2Clone[i];
			PLine pl = sipThis.plEnvelope();
			Vector3d vecXThis = vecNormal.crossProduct(sipThis.vecZ());
			Point3d ptsInt[] = Line(_Pt0,-vecXThis ).orderPoints(pl.intersectPoints(pn));	
		
			Point3d ptRef = sipThis.ptCen()+vecXThis *.5*sipThis.dD(vecXThis );
			ptRef.transformBy(vecNormal*vecNormal.dotProduct(_Pt0-ptRef));
			if (ptsInt.length()>0)
				ptRef = ptsInt[0];			
				
			pts[0]=ptRef;
			gbs[0] = sips2Clone[i];
			tslNew.dbCreate(sScriptname, vecUcsX,vecUcsY,gbs, ents, pts, nProps, dProps, sProps,_kModelSpace, mapTsl); // create new instance
			if (tslNew.bIsValid())
			{
				tslNew.transformBy(Vector3d(0,0,0));
				_Entity.append(tslNew);
			}
		}
	}// END IF create childs



// symbol
	int nDir =1;
	if (nType==1) nDir*=-1;
	PLine plTriangle(vecZ);
	double dH = sqrt(pow(dSize,2)-(pow(dSize,2)/4));
	
	plTriangle.addVertex(_Pt0);
	plTriangle.addVertex(_Pt0+nDir*vecY*dH-vecX*.5*dSize);
	plTriangle.addVertex(_Pt0+nDir*vecY*dH+vecX*.5*dSize);	
	plTriangle.close();
	//plTriangle.vis(6);

	PLine plBase(_Pt0-vecX*dSize,_Pt0,_Pt0+vecX*dSize);
	//plBase.vis(211);

// Display
	Display dp(nColor);
	dp.textHeight(dSize);

// Text
	String sText = dElevation;
	if (dElevation==0)
		sText="±"+sText;


// declare dim request map
	Map mapRequest,mapRequests;
	mapRequest.setInt("Color", nColor);
	mapRequest.setVector3d("AllowedView", vecZ);


// draw
	Point3d ptTxt = _Pt0+nDir*vecY*1.5*dH;
	dp.draw(sText, ptTxt, vecX, vecY, 0,nDir);
	mapRequest.setPLine("pline", plTriangle);	
	if (nStyle==0)
		dp.draw(plTriangle);
	else
	{
		dp.draw(PlaneProfile(plTriangle),_kDrawFilled);	
		mapRequest.setInt("DrawFilled", _kDrawFilled);
	}
	mapRequests.appendMap("DimRequest",mapRequest);
	mapRequest.removeAt("DrawFilled",true);
		
	// draw base line in parent color in model view to distinguish visualizion of parents and childs 
	int nColorParent = 1;
	if (nColor==1) nColorParent=3;
	if (!bIsChild)dp.color(nColorParent);
		
	dp.draw(plBase);
	mapRequest.setPLine("pline", plBase);	
	//mapRequest.setString("lineType", sLineType);	
	mapRequests.appendMap("DimRequest",mapRequest);		
	
	
	if (ptsInt.length()>0)
	{
		plBase.transformBy(ptRef-_Pt0);
		dp.draw(plBase);
		mapRequest.setPLine("pline", plBase);	
		mapRequests.appendMap("DimRequest",mapRequest);		
	}

	Map mapRequestTxt;
	mapRequestTxt.setPoint3d("ptScale", ptTxt);		
	//mapRequestTxt.setInt("deviceMode", _kDevice);		
	//mapRequestTxt.setString("dimStyle", sDimStyle);	
	mapRequestTxt.setInt("Color", nColor);
	mapRequestTxt.setVector3d("AllowedView", vecZ);				
	mapRequestTxt.setPoint3d("ptLocation",ptTxt);		
	mapRequestTxt.setVector3d("vecX", vecX);
	mapRequestTxt.setVector3d("vecY", vecY);
	mapRequestTxt.setDouble("textHeight", dSize);
	mapRequestTxt.setDouble("dXFlag", 0);
	mapRequestTxt.setDouble("dYFlag", nDir);			
	mapRequestTxt.setString("text", sText);	
	mapRequests.appendMap("DimRequest",mapRequestTxt);

	
// publish
	_Map.setMap("DimRequest[]", mapRequests);	

		
#End
#BeginThumbnail
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
G'/YFO3;&U@MX$@MXDAB`X2-0H_2HK5JD;)O[OZ_R*ITX/5?B?__9
`


#End