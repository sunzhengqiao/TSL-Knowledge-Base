#Version 8
#BeginDescription
#Versions
Version 3.1 25.02.2021 HSB-10891 tolerance issue fixed , Author Thorsten Huck
version value="3.0" date="24jul17" author="thorsten.huck@hsbcad.com"> 
preview image supports new properties
new properties 'Rounding Type' for pockets 
new properties 'Length' toggle between sinkholes and pockets
exclusive panel assignment supports a selection set with multiple drill instances

supports hsbCLT-EdgeDrill instances

insertion method extended: it is now possible to select multiple panels
and insertion points, the drills created will only be linked to the interfering panels.
Flip side as doubleclick action added (requires content DACH or appropriate CUIX)
New custom command to assign tool exclusivly 






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 3
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Dieses TSL erzeugt eine Bohrung in der Fläche eines CLT Panels.
/// </summary>

/// <summary Lang=en>
/// This tsl creates a drill on a sip/clt panel
/// </summary>

/// <insert Lang=en>
/// Select one or multiple sips to attach this tsl.
/// </insert>

/// <remark Lang=en>
/// Customize command 'Add panel(s) exclusively' by this execution key
/// ^C^C(defun c:lastContent() (Hsb_RecalcTslWithKey (_TM "|Add panel(s) exclusively|") (_TM "|Select drill instance|"))) lastContent
/// </remark>


/// History
// #Versions
// 3.1 25.02.2021 HSB-10891 tolerance issue fixed , Author Thorsten Huck
///<version value="3.0" date="24jul17" author="thorsten.huck@hsbcad.com"> preview image supports new properties </version>
///<version value="2.9" date="24jul17" author="thorsten.huck@hsbcad.com"> new properties 'Rounding Type' for pockets </version>
///<version value="2.8" date="21jul17" author="thorsten.huck@hsbcad.com"> new properties 'Length' toggle between sinkholes and pockets </version>
///<version value="2.7" date="10jul17" author="thorsten.huck@hsbcad.com"> exclusive panel assignment supports a selection set with multiple drill instances </version>
///<version value="2.6" date="15apr16" author="thorsten.huck@hsbcad.com"> dialog enhanced </version>
///<version value="2.5" date="15apr16" author="thorsten.huck@hsbcad.com"> diameter can be modified by grips, properties categorized </version>
///<version value="2.4" date="15may15" author="th@hsbCAD.de"> model export with element relation supported </version>
///<version value="2.3" date="02dec14" author="th@hsbCAD.de"> model export supported </version>
///<version value="2.2" date="06nov14" author="th@hsbCAD.de"> Add description </version>
///<version value="2.1" date="14oct14" author="th@hsbCAD.de"> supports hsbCLT-CoreDrill instances </version>
///<version value="2.0" date="03sep14" author="th@hsbCAD.de"> insertion method extended: it is now possible to select multiple panels and insertion points, the drills created will only be linked to the interfering panels. Flip side as doubleclick action added (requires content DACH or appropriate CUIX), new custom command to assign tool exclusivly </version>
///<version value="1.9" date="08jan13" author="th@hsbCAD.de"> sinkhole depth tolerance corrected</version>
///<version value="1.8" date="08jan13" author="th@hsbCAD.de"> new properties for sinkholes</version>
///<version value="1.7" date="11dec12" author="th@hsbCAD.de">multiple insert appended</version>
///<version value="1.6" date="14jun12" author="th@hsbCAD.de">depth = 0 creates a complete through drilling</version>
///<version  value="1.5" date="12jan12" author="th@hsbCAD.de">preparation for a better panel split behaviour, requires 17.2.2 or higher </version>
/// Version 1.4   th@hsbCAD.de   19.09.2010
/// numbering disabled
/// Version 1.3   th@hsbCAD.de   31.01.2010
/// bugfix copy
/// note: the array of dependent entities has changed to _Sip. This
/// could require changes to tsl's which insert this tsl
/// bugfix insert
/// Version 1.2   th@hsbCAD.de   14.05.2010
/// bugfix insert
/// Version 1.1   th@hsbCAD.de   11.05.2010
/// bugfix multiple CNC drills


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

	String sArSide[] = {T("|Bottom|"),T("|Top|")};	
	
	int nRoundTypes[] = { _kNotRound, _kRoundSmall, _kRound, _kRounded, _kReliefSmall, _kRelief };
	String sRoundTypes[] = { T("|not rounded|"), T("|rounded|") + " (" + T("|small radius|") + ")", T("|rounded|"), T("|Rounded|"), T("|Relief|")+ " (" + T("|small radius|") + ")", T("|Relief|")};

// cat drill
	category = T("|Drill|");
	String sDiameterName="(A)  "+T("|Diameter|");
	PropDouble dDiameter(0, U(68), sDiameterName);	
	dDiameter.setCategory(category);
	
	String sDepthName = T("|Depth|");
	PropDouble dDepth(1, U(68), "(B)  "+sDepthName);
	dDepth.setDescription(T("|0 = complete through|"));
	dDepth.setCategory(category);

	PropString sSide(0,sArSide,"(C)  "+T("|Side|"));
	sSide.setCategory(category);
	
// sink top
	category = T("|Sinkhole|")+ " / " +T("|Pocket|")+" "+ sArSide[1];
	String sDiameterSinkName=T("|Diameter|") + "/" + T("|dX|");
	String sWidthName=T("|Width|");
	String sWidthDescription=T("|Specifies the dimension of a pocket in X-direction.|") + " " + T("|A value <=0 will create a sinkhole.|");
	PropDouble dDiameterSinkTop(2, 0, "(D)  "+sDiameterSinkName);	
	dDiameterSinkTop.setCategory(category);
	
	PropDouble dDepthSinkTop(3, 0, "(E)  "+sDepthName);
	dDepthSinkTop.setCategory(category);

	PropDouble dWidthTop(6, 0, "(F)  "+sWidthName);	
	dWidthTop.setDescription(sWidthDescription);
	dWidthTop.setCategory(category);
	
	String sRoundTypeName=T("|Rounding Type|");	
	PropString sRoundTypeTop(3, sRoundTypes, "(G)  "+sRoundTypeName);	
	sRoundTypeTop.setDescription(T("|Defines the rounding type of the pocket|"));
	sRoundTypeTop.setCategory(category);

// sink bot
	category = T("|Sinkhole|")+ " / " +T("|Pocket|")+" " + sArSide[0];	
	PropDouble dDiameterSinkBottom(4, 0, "(H)  "+sDiameterSinkName);	
	dDiameterSinkBottom.setCategory(category );
			
	PropDouble dDepthSinkBottom(5, 0, "(I)  "+sDepthName);
	dDepthSinkBottom.setCategory(category );
	
	PropDouble dWidthBottom(7, 0, "(J)  "+sWidthName);	
	dWidthBottom.setDescription(sWidthDescription);
	dWidthBottom.setCategory(category);
	
	
	PropString sRoundTypeBottom(4, sRoundTypes, "(K)  "+sRoundTypeName);	
	sRoundTypeBottom.setDescription(T("|Defines the rounding type of the pocket|"));
	sRoundTypeBottom.setCategory(category);


// display
	category = T("|Display|");	
	PropString sDescription(1, "", "(L)  "+T("|Description|"));
	sDescription.setCategory(category );


// order dimstyles
	PropString sDimStyle(2, _DimStyles, "(M)  "+T("|Dimension style|"));
	sDimStyle.setCategory(category);
	
	String sAddExclusiveTrigger = T("|Add panel(s) exclusively|");

// this map entry flags this instance to be a valid reference of a hsbCLT-EdgeDrill instance
	_Map.setInt("AllowsEdgeDrill", true);// the map entry which determines if a tsl is supported

	
// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		// show the dialog if no catalog in use
		if (_kExecuteKey == "")
			showDialog();			
		else
			// set properties from catalog
			setPropValuesFromCatalog(_kExecuteKey);

	// declare arrays for tsl cloning
		TslInst tslNew;
		Vector3d vUcsX = _XW;
		Vector3d vUcsY = _YW;
		GenBeam gbAr[1];
		Entity entAr[0];
		Point3d ptAr[1];
		int nArProps[0];
		double dArProps[0];
		String sArProps[0];
		Map mapTsl;
		String sScriptname = scriptName();
		
		dArProps.append(dDiameter);
		dArProps.append(dDepth);

		dArProps.append(dDiameterSinkTop);
		dArProps.append(dDepthSinkTop);
		
		dArProps.append(dDiameterSinkBottom);
		dArProps.append(dDepthSinkBottom);
		
		dArProps.append(dWidthTop);
		dArProps.append(dWidthBottom);

		sArProps.append(sSide);
		sArProps.append(sDescription);
		sArProps.append(sDimStyle);	
		
		sArProps.append(sRoundTypeTop);	
		sArProps.append(sRoundTypeBottom);	
				
		

	// selection set
		Entity ents[0];
		PrEntity ssE(T("|Select panel(s)|"), Sip());	
		if (ssE.go())
			ents= ssE.set();

	// collect sips
		Sip sips[0];
		for(int i = 0;i <ents.length();i++)
		{
			if(ents[i].bIsKindOf(Sip()))
			{
				Sip sip = (Sip)ents[i];	
				sips.append(sip);	
			}
		}

	// prompt insertion point			
		while (1) 
		{
			PrPoint ssP("\n" + T("|Select point|")); 
			if (ssP.go()==_kOk) 
			{ 
			// do the actual query
				ptAr[0]= ssP.value();
				
			// find corresponding panel
				for(int i = 0;i <sips.length();i++)	
				{
					PlaneProfile ppShadow(sips[i].plShadow());
					ppShadow.shrink(-(dDiameter/2));
					if (ppShadow.pointInProfile(ptAr[0])==_kPointInProfile)
					{
						gbAr[0]=sips[i];
						tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
							nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance	
						
					}
				}// next i
			}
			else 
			{ // no proper selection
				break; // out of infinite while
			}
		}
		
		eraseInstance();	
		return;
	}
	setEraseAndCopyWithBeams(_kBeam0);



// get sips remotely if set
	if (_Map.indexAt("Sip[]")>-1)
	{ 
		Entity ents[] = _Map.getEntityArray("Sip[]", "", "Sip");
		Sip sips[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			Sip sip = (Sip)ents[i]; 
			if (sip.bIsValid())
				sips.append(sip);
		}
	
	// valid new set of sips
		if (sips.length()>0)
		{ 
			_Sip = sips;
			_Map.removeAt("Sip[]", true);
		// reset custom command key	
			if (sAddExclusiveTrigger==_kExecuteKey)
				_kExecuteKey="";
			setExecutionLoops(2);
			return;
		}
		
	}
	
// the sip
	Sip sip;
	if (_Sip.length()>0)
		sip = _Sip[0];
	
// on creation
	if (_bOnDbCreated)
		setExecutionLoops(2);
			
// declare the sip
	Vector3d vx,vy,vz;
	vx=sip .vecX();
	vy=sip .vecY();
	vz=sip .vecZ();	
	
	Point3d ptOrg = sip .ptCen();
	vx.vis(ptOrg, 1);
	vy.vis(ptOrg, 3);
	vz.vis(ptOrg, 150);	
	
// declare a potential element ref
	Element el=sip.element();
	if (el.bIsValid())
	{
		assignToElementGroup(el,true,0,'T');
		_Element.append(el);	
	}
	
// ints
	Vector3d vxDrill[] = {-vz,vz};
	int nSide = sArSide.find(sSide,0);
	int nRoundTypeTop = sRoundTypes.find(sRoundTypeTop,0);
	nRoundTypeTop = nRoundTypeTop>-1?nRoundTypes[nRoundTypeTop]:_kNotRound;
	int nRoundTypeBottom = sRoundTypes.find(sRoundTypeBottom,0);
	nRoundTypeBottom = nRoundTypeBottom>-1?nRoundTypes[nRoundTypeBottom]:_kNotRound;
	

// trigger0: flip side
	String sFlipSideTrigger = T("|Flip Side|");
	addRecalcTrigger(_kContext, sFlipSideTrigger );
	if (_bOnRecalc && (_kExecuteKey==sFlipSideTrigger || _kExecuteKey==sDoubleClick) ) 
	{
		if (nSide==0)
			sSide.set(sArSide[1]);
		else
			sSide.set(sArSide[0]);			
		setExecutionLoops(2);					
	}
		
// trigger1: add panel
	String sAddPanelTrigger = T("|Add Panel|");

	addRecalcTrigger(_kContext, sAddPanelTrigger );
	if (_bOnRecalc && _kExecuteKey==sAddPanelTrigger ) 
	{
		Entity ents[0];
		PrEntity ssE(T("|Select panels|"), Sip());
		if (ssE.go())
			ents= ssE.set();
		for (int i=0; i<ents.length();i++)	
		{
			Sip sipThis = (Sip)ents[i];
			if (_Sip.find(sipThis)<0)
				_Sip.append(sipThis);	
		}
		setExecutionLoops(2);					
	}

// trigger: add panel exclusively
	addRecalcTrigger(_kContext, sAddExclusiveTrigger );
	if (_bOnRecalc && _kExecuteKey==sAddExclusiveTrigger ) 
	{
		
		
	// collect other instances to be assigned	
		Entity tents[0];
		TslInst tslOthers[0];
		PrEntity ssE(T("|Select additional drill(s) (optional)|"), TslInst());
		if (ssE.go())
			tents= ssE.set();
		for (int i=0; i<tents.length();i++)	
		{
			TslInst tsl = (TslInst)tents[i];
			if (_ThisInst!=tsl && tsl.scriptName()==scriptName())
				tslOthers.append(tsl);	
		}
		
	// collect panels to be assigned to	
		Entity ents[0];
		ssE=PrEntity(T("|Select panel(s)|"), Sip());
		if (ssE.go())
			ents= ssE.set();
		_Sip.setLength(0);
		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
			Sip sipThis = (Sip)ents[i];
			if (_Sip.find(sipThis)<0)
				_Sip.append(sipThis);	
			else	
				ents.removeAt(i);
		}

		
	// set sip array of others through map	
		for (int i=0; i<tslOthers.length();i++)
		{ 
			Map map = tslOthers[i].map();		
			map.setEntityArray(ents, false, "Sip[]", "", "Sip");
			tslOthers[i].setMap(map);
		}
		setExecutionLoops(2);	
		return;
	}

// trigger: remove panel
	if (_Sip.length()>1) 
	{
		String sRemoveTrigger = T("|Remove Panel|");
		addRecalcTrigger(_kContext, sRemoveTrigger );
		if (_bOnRecalc && _kExecuteKey==sRemoveTrigger) 
		{
			Entity ents[0];
			PrEntity ssE(T("|Select panels|"), Sip());
			if (ssE.go())
				ents= ssE.set();
			for (int i=0; i<ents.length();i++)		
			{
				Sip sipThis = (Sip)ents[i];
				int s = _Sip.find(sipThis);
				if (s>-1 && _Sip.length()>1)
				{
					_Sip.removeAt(s);
					break;	
				}
			}	
			setExecutionLoops(2);	
		}
	}




// the depth
	double dThisDepth = dDepth;
	if (dThisDepth<dEps)
		dThisDepth =sip.dD(vz)+dEps;
	
// the drill
	double dZ = sip.dD(vz);
	Point3d ptRef = _Pt0 - vz*vz.dotProduct(_Pt0-ptOrg);
	Point3d ptTop = ptRef +vz*.5*dZ;
	Point3d ptBot = ptRef -vz*.5*dZ;
	Point3d ptDrill = ptRef +vxDrill[nSide]*.5*dZ;

// diameter grip
	if (_PtG.length()<1)
		_PtG.append(ptRef+vx*dDiameter/2);

// relocate grips
	for(int i=0;i<_PtG.length();i++)
	{
		_PtG[i].transformBy(vz*vz.dotProduct(ptRef-_PtG[i]));
	}
	
// on the event of changing the diameter
	if (_kNameLastChangedProp == sDiameterName && _PtG.length()>0)
	{
		_PtG[0] = ptRef+vx*.5*dDiameter;
		setExecutionLoops(2);
		return;
	}

// on the event of changing the diameter
	if (_kNameLastChangedProp == "_PtG0")
	{
		double r = (_PtG[0]-ptRef).length();
		if (r>dEps)
			dDiameter.set(r*2);
		setExecutionLoops(2);
		return;
	}



	
// the dispaly
	Display dp(3);
	if (nSide==0 && dDepth>dEps)dp.color(6);
	dp.dimStyle(sDimStyle);
	
	if (sDescription != "") {
		Vector3d vxTxt = -vy;
		Vector3d vyTxt = vx;
		
		dp.draw(sDescription, ptDrill + (vxTxt  + vyTxt) * dDiameter/2, vxTxt, vyTxt, 1, 1);
	}
	
	PLine plCirc(vz);
	plCirc.createCircle(ptDrill ,vxDrill[nSide],dDiameter/2);
	dp.draw(plCirc);	
	plCirc.transformBy(-vxDrill[nSide]*dThisDepth);
	dp.draw(plCirc);	

// the drill	
	Drill dr(ptDrill+vxDrill[nSide]*dEps ,ptDrill -vxDrill[nSide]*dThisDepth, dDiameter/2); // HSB-10891 tolerance issue
	dr.addMeToGenBeamsIntersect(_Sip);

// top sink
	if (dDiameterSinkTop>dEps && dDepthSinkTop>dEps && dDiameter<dDiameterSinkTop && dWidthTop<dEps)
	{
		Point3d pt = ptTop;
		pt.vis(3);
		
		Drill dr(pt+vz*dEps ,pt-vz*dDepthSinkTop, dDiameterSinkTop/2);
		dr.addMeToGenBeamsIntersect(_Sip);	

		dp.color(12);
		plCirc.createCircle(pt ,-vz,dDiameterSinkTop/2);
		dp.draw(plCirc);				
	}
// top pocket	
	else if (dDiameterSinkTop>dEps && dDepthSinkTop>dEps  && dDiameter<dDiameterSinkTop && dWidthTop>0)
	{
		Point3d pt = ptTop;
		House hs(pt, vx, vy, -vz, dDiameterSinkTop, dWidthTop, dDepthSinkTop*2, 0,0,0);
		hs.setEndType(_kFemaleSide);
		hs.setRoundType(nRoundTypeTop);
		hs.addMeToGenBeamsIntersect(_Sip);
		dp.color(12);
		PLine pl;
		pl.createRectangle(LineSeg(pt-.5*(vx*dDiameterSinkTop+vy*dWidthTop),pt+.5*(vx*dDiameterSinkTop+vy*dWidthTop)), vx, vy);
		dp.draw(pl);			
	}	

// bottom sink
	if (dDiameterSinkBottom>dEps && dDepthSinkBottom>dEps  && dDiameter<dDiameterSinkBottom && dWidthBottom<dEps)
	{
		Point3d pt = ptBot;
		Drill dr(pt-vz*dEps ,pt+vz*dDepthSinkBottom, dDiameterSinkBottom/2);
		dr.addMeToGenBeamsIntersect(_Sip);		
		
		dp.color(4);
		plCirc.createCircle(pt ,vz,dDiameterSinkBottom/2);
		dp.draw(plCirc);	
	}
// bottom pocket	
	else if (dDiameterSinkBottom>dEps && dDepthSinkBottom>dEps  && dDiameter<dDiameterSinkBottom && dWidthBottom>0)
	{
		Point3d pt = ptBot;
		House hs(pt, vx, vy, vz, dDiameterSinkBottom, dWidthBottom, dDepthSinkBottom*2, 0,0,0);
		hs.setEndType(_kFemaleSide);
		hs.setRoundType(nRoundTypeBottom);
		hs.addMeToGenBeamsIntersect(_Sip);
		dp.color(4);
		PLine pl;
		pl.createRectangle(LineSeg(pt-.5*(vx*dDiameterSinkBottom+vy*dWidthBottom),pt+.5*(vx*dDiameterSinkBottom+vy*dWidthBottom)), vx, vy);
		dp.draw(pl);			
	}
	
	String sDrawCirclesTrigger = T("|Draw Circles|");
	addRecalcTrigger(_kContext, sDrawCirclesTrigger );
	if (_bOnRecalc && _kExecuteKey==sDrawCirclesTrigger) 
	{
		EntPLine epl;
		epl.dbCreate(plCirc);
		epl.setColor(1);
		epl.assignToGroups(sip);
	}	
	
	


			









#End
#BeginThumbnail
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
AHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`/__9
`


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
      <str nm="Comment" vl="HSB-10891 tolerance issue fixed" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="2/25/2021 5:29:02 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End