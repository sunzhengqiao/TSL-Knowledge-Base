#Version 8
#BeginDescription
DE   stellt Elementdaten (optional) in Welt/Elementansicht dar
    und stellt Exportdaten für die Excelausgabe zur Verfügung
EN   shows (optional) element data in wcs or ecs view and 
    publishs elementdata for the output to excel

version  value="3.0" date="07jul14" author="th"
bugfix: if studs were fully outside of the wall outline the insulation calculation could have failed. this is now fixed 


















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 3
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl creates analyzes an element in respect of it's maximum dimensions as well as the
/// approximation of insulation
/// The resulting data can be displayed in element or WCS view or be invisible (default)
/// </summary>

/// <insert>
/// To insert this tsl select the beams to be connected
/// </insert>

/// <property name="Length/Width/Height taken from">
/// These properties determine the entities from which the dimensions are to be taken. 
///</ property >

/// <property name="Net Area: ignore Openings < DU²" Lang=en>
/// Openings with an area smaller than the given value in drawing units will not be taken
/// to calculate the net area of the element
///</ property >

/// <property name="Property Set Name" Lang=en>
/// If the chosen property set contains properties with the following names values will be set by this tsl.
/// Please note that the type must be set to a real number and not to text
/// - Height
/// - Width
/// - Length
/// - Perimeter
/// - AreaNet
/// - AreaGros
/// - Insulation
/// The values will be set in the unit which is set as property of this tsl
///</ property >

/// <remark>
/// To enable the export to excel the tsl must be numbered and part of the selection set which
/// will be exported to excel
/// </remark>

/// History
///<version  value="3.0" date="07jul14" author="th"> bugfix: if studs were fully outside of the wall outline the insulation calculation could have failed. this is now fixed </version>
///<version  value="2.9" date="01oct12" author="th"> tsl is tolerant against genbeams with one of the X-, Y-, or Z-dimensions being zero </version>
///<version  value="2.8" date="07mar12" author="th"> bugfix property set selection all element types, openings defined by a tsl with an map pline entry 'tslOpening' supported for insulation calculation</version>
///<version  value="2.7" date="03feb12" author="th"> insulation calculation tolerates small opening offsets</version>
///<version  value="2.6" date="01feb12" author="th"> description enhanced</version>
///<version  value="2.5" date="19oct11" author="th"> validation if genbeams are within zone 0 to detect insulation volume</version>
///<version  value="2.4" date="19oct11" author="th"> tolerance issue element width fixed</version>
///<version  value="2.3" date="18oct11" author="th"> supports export of data via property set, for wall elements visualisation now at arrow location</version>
/// <Version 2.2  07.06.2011   th@hsbCAD.de Lang=de>
/// bugfix Dämmvolumen
/// <Version 2.1  30.11.2009   th@hsbCAD.de Lang=de>
/// Content Standardisierung
/// <Version 2.0   th@hsbCAD.de   12.05.2009 Lang=en>
/// Calculation of insulation is simplified to the inverted shadow of the farme (without openings)
/// <Version 2.0   th@hsbCAD.de   12.05.2009 Lang=de>
/// Berechnung des Dämmvolumens vereinfacht (Schattenprofil des Rahmens ohne Öffnungen)
/// <Version 1.9 Lang=de>
/// Toleranzen bei komplexen Bauteilen verbessert
/// <Version 1.9 Lang=en>
/// Tolerances for complex solids enhanced
/// <Version 1.8 Lang=de>
/// Einfügeverhalten bei kopierten Elementen verbessert
/// <Version 1.8 Lang=en>
/// bugfix insertion on element copies
/// <Version 1.7 Lang=de>
/// 1.7 neue Option um die Übermessungsfläche für Öffnungen zu definieren (in Zeichnungseinheiten)
/// <Version Lang=en>
/// 1.7 new options to define a minimal opening area which need to exceed the opening area to be
/// effective for the net area (to be defined in drawing units)
/// <Version Lang=de>
/// 1.6 neue Optionen zur Ausgabe der Breite: es kann sich nun auf die gesamte
/// Elementkontur, auf die Kontur der Zone 0 oder auf die Kontur einer Wandgrundrißlinie bezogen werden
/// <Version Lang=en>
/// 1.6 new options to calculate width
/// <Version Lang=de>
/// 1.5 neue Option Info exportiert die Elementbeschreibung
/// <Version Lang=en>
/// 1.5 new option info exports element definition
/// <Version Lang=de>
/// 1.4 neue Optionen zur Ausgabe von Länge und Höhe: es kann sich nun auf die gesamte
/// Elementkontur, auf die Kontur der Zone 0 oder auf die Kontur des Hüllkörpers bezogen werden
/// <Version Lang=en>
/// 1.4 new options to calculate length and height: you can now select whether the length or width is taken
/// from the maximum element extends, the zone 0 or of the element contour
/// <Version Lang=de>
/// 1.3 Ausgabe Dämmvolumen ergänzt. Das Dämmvolumen entspricht dem Volumen der Zone 0 abzüglich aller
/// Öffnungen, Platten und Stäbe innerhalb dieser Zone.
/// <Version Lang=en>
/// 1.3 Output of insulation volume added. The volume is calculated by the voluem of zone 0 subtracted by all
/// openings, beams and sheets interfereing with this zone
/// <Version Lang=de>
/// 1.2 neue Option um Elementbreite vom gesametn Element oder der Zone 0 abzuleiten
/// <Version Lang=en>
/// 1.2 new option to determine width from entire element or zone 0



// basics and props
	U(1,"mm");
	double dEps = U(.1);
	String sArNY[] = { T("|No|"), T("|Yes|")};
	String sArUnit[] = {"mm", "cm", "m", "inch", "feet"};
	PropString sUnit(1,sArUnit,T("|Unit|"));
	int nArDecimals[] = {0,1,2,3,4};
	PropInt nDecimals(1,nArDecimals,T("|Decimals|"));		
	String sArLengthSource[] = {T("|entire Element|"),T("|Zone 0|"),T("|Element Outline|") };
	PropString sLengthSource(4,sArLengthSource,T("|Length taken from|"));	
	PropString sHeightSource(5,sArLengthSource,T("|Height taken from|"));	
	String sArWidthSource[] = {T("|entire Element|"),T("|Zone 0|"),T("|Wall Outline|") };
	PropString sWidthSource(3,sArWidthSource,T("|Width taken from|"));
	PropDouble dMinArea(0,0,T("|Net Area: ignore Openings < DU²|"));
	PropInt nColor (0,222,T("|Color|"));	
	PropString sDimStyle(0,_DimStyles,T("|Dimstyle|"));
	String sArShowTable[] = {T("|No|"),T("|WCS|"),T("|ECS|") + " " +  T("|(Element coordinate system)|")};
	PropString sShowTable(2,sArShowTable,T("|Show table|"));
	String sArPropSetName[] = Element().availablePropSetNames() ;	
	PropString sPropSetName(6,sArPropSetName,T("|Property Set Name|"));

// on insert
	if (_bOnInsert){
		// set properties from catalog
		setPropValuesFromCatalog(_kExecuteKey);		
		showDialog();
		// selection of element		
		PrEntity ssEl(T("Select Element"), Element());
		Element el[0];
  		if (ssEl.go())
    		el = ssEl.elementSet();

		// declare TSL Props
		TslInst tsl;
		Vector3d vUcsX = _XW;
		Vector3d vUcsY = _YW;
		Beam lstBeams[0];	
		Element lstEnts[1];		// will append per element
		Point3d lstPoints[1];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];

		lstPropInt.append(nColor);	
		lstPropInt.append(nDecimals);				
		lstPropString.append(sDimStyle);
		lstPropString.append(sUnit);
		lstPropString.append(sShowTable);
		lstPropString.append(sWidthSource);
		lstPropString.append(sLengthSource);
		lstPropString.append(sHeightSource);		
		lstPropString.append(sPropSetName);	

				
		for (int i = 0; i < el.length(); i++)
		{
			lstEnts[0] = el[i];
			lstPoints[0] = el[i].ptOrg();
			
			// check if this script is already attached to the element
			TslInst tslList[] = el[i].tslInst();
			int bOk = true;
			String sScriptName, sInstName;
			sScriptName = scriptName();
			sScriptName.makeUpper();
			for (int t = 0; t < tslList.length(); t++)
			{
				sInstName = tslList[t].scriptName();
				sInstName.makeUpper();
				if (sInstName == sScriptName && tslList[t].bIsValid())
				bOk = false;
			}// next t
			
			if (bOk)
			{
				tsl.dbCreate(scriptName(), vUcsX,vUcsY,lstBeams, lstEnts, lstPoints, 
					lstPropInt, lstPropDouble, lstPropString );
					reportMessage("\n" + T("Element")+ " " + el[i].number() + ": " + T("|data successfully appended.|"));
			}		
			else
				reportMessage("\n" + T("Element")+ " " + el[i].number() + ": " + T("|has aleady extended data attached. no data appended.|"));
		}// next i		
		
		eraseInstance();
		return;
	}	
//end on insert________________________________________________________________________________


// declare standards
	if (_bOnDbCreated)
		setExecutionLoops(2);
	if (_Element.length() < 1)
	{
		eraseInstance();
		return;
	}

	Element el = _Element[0];
	if (!el.bIsValid()) return;

	CoordSys cs;
	Point3d ptOrg;
	Vector3d vx,vy,vz;

	cs = el.coordSys();
	ptOrg = cs.ptOrg();	
	vx=cs.vecX();
	vy=cs.vecY();
	vz=cs.vecZ();
	
	vx.vis(ptOrg, 1);
	vy.vis(ptOrg, 3);
	vz.vis(ptOrg, 150);

	assignToElementGroup(el, TRUE,0, 'E');	

// ints
	int nUnit = sArUnit.find(sUnit);
	int nLUnit = 2;
	if (nUnit> 2)
		nLUnit = 4;	
	
	int nShowTable = sArShowTable.find(sShowTable);	
	int nLengthSource = sArLengthSource.find(sLengthSource);
	int nHeightSource= sArLengthSource.find(sHeightSource);
	int nWidthSource= sArWidthSource.find(sWidthSource);

// openings
	Opening op[] = el.opening();
		
	GenBeam gb[0];
	gb = el.genBeam();	

	Body bdSub;
	PlaneProfile ppShadowLength(CoordSys(ptOrg,vx,vy,vz));
	PlaneProfile ppShadowHeight(CoordSys(ptOrg,vx,vy,vz));
	PlaneProfile ppShadowWidth(CoordSys(ptOrg,vx,-vz,vy));
	PlaneProfile ppShadowAll(CoordSys(ptOrg,vx,vy,vz));

	PLine plZn0;
	plZn0.createRectangle(LineSeg(ptOrg-vx*U(25000),ptOrg+vx*U(25000)-vz*el.dBeamWidth()), vx,vz);
	PlaneProfile ppZn0(plZn0);

	//ppZn0.vis(40);	
	for (int i = 0; i < gb.length(); i++)
	{
	// catch invalid genBeams (such as sheets with zero length or width)
		if (gb[i].solidLength()<dEps || gb[i].solidHeight()<dEps || gb[i].solidWidth()<dEps)continue;
		Body bd = gb[i].realBody();
		
		PlaneProfile ppShadowY = bd.shadowProfile(Plane(ptOrg+vy*U(300),vy));
		ppShadowY.shrink(-dEps);
		PlaneProfile ppShadowZ = bd.shadowProfile(Plane(ptOrg,vz));
		ppShadowZ.shrink(-dEps);

		//insulation
		if(gb[i].myZoneIndex() == 0)
		{
		// test if it intersects the projection of zone 0
			PlaneProfile pp=ppZn0;
			pp.intersectWith(ppShadowY);
			if (pp.area()<pow(dEps,2))
			{
				bd.vis(12);
				continue;	
			}
			
			
			//bd.vis(i);
			//ppShadowZ.vis(3);
			if (ppShadowAll.area() < pow(dEps,2))
				ppShadowAll= ppShadowZ;
			else
				ppShadowAll.unionWith(ppShadowZ);				
		}
				
		if (nLengthSource == 0 || (nLengthSource == 1 && gb[i].myZoneIndex() == 0))
		{
			if (ppShadowLength.area() < pow(dEps,2))
				ppShadowLength = ppShadowZ;
			else
				ppShadowLength.unionWith(ppShadowZ);
		}
		if (nHeightSource== 0 || (nHeightSource== 1 && gb[i].myZoneIndex() == 0))
		{
			if (ppShadowHeight.area() < pow(dEps,2))
				ppShadowHeight= ppShadowZ;
			else
				ppShadowHeight.unionWith(ppShadowZ);
		}
		if (nWidthSource== 0 || (nWidthSource== 1 && gb[i].myZoneIndex() == 0))
		{
			if (ppShadowWidth.area() < pow(dEps,2))
				ppShadowWidth= ppShadowY;
			else
				ppShadowWidth.unionWith(ppShadowY);
		}
	}
	ppShadowWidth.shrink(dEps);
	ppShadowHeight.shrink(dEps);
	
	//ppShadowAll.vis(6);
	// merge gaps
	ppShadowAll.shrink(-dEps);
	ppShadowAll.shrink(dEps);


	// get biggest ring
	PLine plRings[]=ppShadowAll.allRings();
	int bIsOp[] = ppShadowAll.ringIsOpening();
	PLine plMax;
	for (int r=0;r<plRings.length();r++)
		if (plMax.area()<plRings[r].area() && !bIsOp[r])
			plMax = plRings[r];
	//plMax.transformBy(vz*U(1000));
	//plMax.vis(1);
	
	CoordSys csInsul(ptOrg,vx,vy,vz);
	PlaneProfile ppInsulation(csInsul);//(plMax);
	for (int r=0;r<plRings.length();r++)
	{
		PlaneProfile ppThis(csInsul);
		ppThis.joinRing(plRings[r],_kAdd);
		if (plMax.area()!=plRings[r].area()&& bIsOp[r])
		{
			if (ppInsulation.area() < pow(dEps,2))
				ppInsulation = ppThis ;
			else
				ppInsulation.joinRing(plRings[r],_kAdd);		
		}
	}


// collect potential tsl defined openings
	TslInst tslList[] = el.tslInst();
	PLine plTslOpening[0];
	for (int t = 0; t < tslList.length(); t++)
	{
		Map map = tslList[t].map();
		if (map.hasPLine("tslOpening"))
			plTslOpening.append(map.getPLine("tslOpening"))	;
	}// next t
		

// calculate the insulation per single ring pp. it appeared that the joinRing method failed on slightly smaller openings
	Display dpX(2);
	double dInsulation;
	plRings=ppInsulation.allRings();
	ppInsulation = PlaneProfile(csInsul);
	for (int r=0;r<plRings.length();r++)
	{
		PlaneProfile pp(plRings[r]);	
		for (int i = 0; i < op.length(); i++)
			pp.joinRing(op[i].plShape(),_kSubtract);
		for (int i = 0; i < plTslOpening.length(); i++)
			pp.joinRing(plTslOpening[i],_kSubtract);
			
		if (pp.area()>pow(dEps,2))	
		{
			pp.vis(r);
			dInsulation+=pp.area();
			if (_bOnDebug)dpX.draw(pp,_kDrawFilled);
		}
	}

// insulation volume			
	dInsulation*=el.dBeamWidth();
	
	LineSeg lsShadowLength= ppShadowLength.extentInDir(vx);
	if (nLengthSource == 2)// element outline
		lsShadowLength = PlaneProfile(el.plEnvelope()).extentInDir(vx);
	LineSeg lsShadowHeight= ppShadowHeight.extentInDir(vx);
	if (nHeightSource == 2)// element outline
		lsShadowHeight= PlaneProfile(el.plEnvelope()).extentInDir(vx);
	LineSeg lsShadowWidth= ppShadowWidth.extentInDir(vz);
	if (nWidthSource == 2 && el.bIsKindOf(ElementWall()))// element outline
		lsShadowWidth= PlaneProfile(el.plOutlineWall()).extentInDir(vz);

// geometrical data
	double dAreaBrut = el.plEnvelope().area();
	double dAreaNet = dAreaBrut ;

	// net area
	for (int i = 0; i < op.length(); i++)
		if (op[i].plShape().area()>dMinArea)
				dAreaNet = dAreaNet  - op[i].plShape().area();
				
	// perimeter
	double dPeri;
	Point3d pt[0];
	pt = el.plEnvelope().vertexPoints(FALSE);
	for (int i = 0; i < pt.length()-1; i++)	
	dPeri = dPeri + Vector3d(pt[i] - pt[i+1]).length();
	
	// max dim
	double dLength, dHeight, dWidth;
	dLength = abs(vx.dotProduct(lsShadowLength .ptStart() - lsShadowLength .ptEnd()));		
	dHeight=  abs(vy.dotProduct(lsShadowHeight .ptStart() - lsShadowHeight .ptEnd()));	
	dWidth =  abs(vz.dotProduct(lsShadowWidth .ptStart() - lsShadowWidth .ptEnd()));
		
	
// collect data
	String sName = el.number();
	String sCode = el.code();
	String sDef = el.definition();
	String sLevel = el.elementGroup().namePart(1);
	String sHeight, sWidth, sLength, sPeri, sAreaBrut, sAreaNet, sVolume, sInfo;
	
// convert to string data
	sAreaNet.formatUnit(dAreaNet  / (U(1,sUnit,2) * U(1,sUnit,2)),nLUnit ,nDecimals);
	sAreaBrut.formatUnit(dAreaBrut  / (U(1,sUnit,2) * U(1,sUnit,2)),nLUnit ,nDecimals);	
	sPeri.formatUnit(dPeri / U(1,sUnit,2),2,nDecimals);
	sHeight.format("%1." + nDecimals +"f", dHeight/ U(1,sUnit,2));
	sLength.format("%1." + nDecimals +"f", dLength/ U(1,sUnit,2));
	sWidth.format("%1." + nDecimals +"f", dWidth/ U(1,sUnit,2));
	sVolume.format("%1." + nDecimals +"f", dInsulation/ (U(1,sUnit,2)*U(1,sUnit,2)*U(1,sUnit,2)));
// append units
	sAreaNet = sAreaNet + sUnit + "²";
	sAreaBrut= sAreaBrut+ sUnit + "²";
	sLength = sLength + sUnit;
	sWidth= sWidth+ sUnit;
	sHeight= sHeight+ sUnit;
	sPeri= sPeri+ sUnit;	
	sVolume= sVolume+ sUnit + "3";
	sInfo = el.definition();				 	
// collect into array
	String sHeader[] = {T("|Level|"),T("|Code|"),T("|PosNum|"),T("|Area net|"),T("|Area brut|"),T("|Length|"),T("|Width|"),T("|Height|"), T("|Insulation|"), T("|Information|")};	
	String sValue[] ={sLevel ,sCode,sName,sAreaNet, sAreaBrut,sLength, sWidth, sHeight, sVolume,sInfo};	

// output
	dxaout("Level", sLevel);
	dxaout("Code", sCode );
	dxaout("Width", dWidth / U(1,"mm"));
	dxaout("Height", dHeight / U(1,"mm"));
	dxaout("Length", dLength / U(1,"mm"));
	dxaout("NetArea", dAreaNet / (U(1,"mm")* U(1,"mm")));
	dxaout("Area", dAreaBrut / (U(1,"mm")* U(1,"mm")));	
	dxaout("Perimeter", dPeri/ U(1,"mm"));
	dxaout("Name", sName);
	dxaout("Sublabel", sCode );
	dxaout("Volume", dInsulation/ (U(1,"mm")* U(1,"mm")* U(1,"mm")));	
	dxaout("Info", sInfo);


// query property set
	if (sPropSetName!="")
	{
		el.attachPropSet(sPropSetName);
		// get a map of properties
		Map map = el.getAttachedPropSetMap(sPropSetName) ;
		
	// fill map with data
		if (map.hasDouble("Height"))	map.setDouble("Height", dHeight / pow(U(1,sUnit,2),1),_kNoUnit);
		if (map.hasDouble("Width"))	map.setDouble("Width", dWidth/ pow(U(1,sUnit,2),1),_kNoUnit);	
		if (map.hasDouble("Length"))	map.setDouble("Length", dLength/ pow(U(1,sUnit,2),1),_kNoUnit);	

		if (map.hasDouble("Insulation"))	map.setDouble("Insulation", dInsulation/ pow(U(1,sUnit,2),3),_kNoUnit);		
		if (map.hasDouble("AreaNet"))	map.setDouble("AreaNet", dAreaNet / pow(U(1,sUnit,2),2),_kNoUnit);
		if (map.hasDouble("AreaGros"))	map.setDouble("AreaGros", dAreaBrut / pow(U(1,sUnit,2),2),_kNoUnit);	
		if (map.hasDouble("Perimeter"))	map.setDouble("Perimeter", dPeri/ pow(U(1,sUnit,2),1),_kNoUnit);	
		
	// write data to propset of entity
		el.setAttachedPropSetFromMap(sPropSetName, map);		
	}
	
// redefine units
	U(1,"mm");	



				
// Display
	Display dp(nColor),dp2(nColor);
	dp.dimStyle(sDimStyle);	

	Point3d ptRef = _Pt0;
	if (el.bIsKindOf(ElementWall()))
	{
		ElementWall elWall = (ElementWall)el;
		ptRef = elWall.ptArrow();
		double dDiam=U(10);
		PLine plCirc(vy);
		plCirc.createCircle(ptRef+vz*4*dDiam, vy,dDiam/2);
		dp.draw(PlaneProfile(plCirc),_kDrawFilled);
		ptRef.transformBy(vz * U(330));
		
	}	
	else
		dp2.draw(PLine(ptRef, ptRef + vx * U(20)));		
	
	
	
	if (nShowTable >0)
	{		
		// show in ecs
		Vector3d  vxDp = vx, vyDp = vy, vzDp = vz;
		// show in wcs
		if (nShowTable == 1)
		{
			vxDp = _XW;
			vyDp = _YW;	
			vzDp = _ZW;
		}
		
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
				dp.draw(sHeader[i],ptRef,vxDp, vyDp,1, dCrt);
				dp.draw(sValue[i],ptRef + vxDp * (dMaxHeader + dp.textHeightForStyle(sValue[i], sDimStyle)),vxDp, vyDp,1, dCrt);			
				dCrt -= 3;
			}			
	}

















#End
#BeginThumbnail
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
##__9
`









#End