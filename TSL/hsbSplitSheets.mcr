#Version 8
#BeginDescription
version value="1.8" date=19nov2018" author="thorsten.huck@hsbcad.com"
minor bugfix

default value of width considers potential gap value in dialog preset
properties categorized, splitted conversion results will create individual items, double click supported for conversion 

EN   creates a sheeting distribution along a set splitting points
   - the distribution will be generated starting from a base point in all 4 directions
   - additional split points can be added in preview mode
   - the distribution can be derived from the zone contour (no generation process
     required)
     or from existing sheets
   - existing sheets can merged to create an entire new distribution
   - alternatively the sheets can be converted to beams
   - use the context commands to access the generation or to add a split point
DE   erzeugt eine Plattenverteilung einer Zone entlang frei wählbaren Teilungs-
      punkten
   - die Verteilungwird ausgehend von einem Startpunkt in alle 4 Richtungen
     vorgenommen
   - zusätzliche Teilungspunkte können im Vorschaumodus hinzugefügt werden
   - die Verteilung kann von der Kontur der Zone oder von bereits generierten Platten
     abgeleitet werden
   - bereits existierende PLatten können vereinigt werden um eine neue Verteilung
     zu erzeugen
   - alternativ kann die Auswahl in Stäbe konvertiert werden
   - die Konvertierung / Aufteilung ist ebenso wie das Hinzufügen weiterer Teilungs-
     punkte über das  Kontextmenü zugänglich








#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 8
#KeyWords 
#BeginContents
/// History
///<version value="1.8" date=19nov2018" author="thorsten.huck@hsbcad.com"> minor bugfix </version>
///<version value="1.7" date=30may17" author="thorsten.huck@hsbcad.com"> default value of width considers potential gap value in dialog preset </version>
///<version  value="1.6" date="09dec15" author="th@hsbCAD.de"> properties categorized, splitted conversion results will create individual items, double click supported for conversion </version>
///<version  value="1.5" date="25feb13" author="th@hsbCAD.de"> selection object changed to sheet, main property values taken from zone object, distribution from existing sheets enhanced</version>
///Version 1.4   29.10.2010   th@hsbCAD.de
///EN bugfix gap
///Version 1.3   04.08.2009   th@hsbCAD.de
///EN catalog based insertion enabled
///Version 1.2   18.06.2008   th@hsbCAD.de
///EN   tolerance added to avoid very small conversions
///DE   Toleranz ergänzt um sehr kleine Konvertierungsresulatate zu vermeiden
///Version 1.1   19.05.2008   th@hsbCAD.de
///EN   the base point will be projected to the element level if the UCS-Z
///    is parallel to the WCS-Z
///DE   der Basispunkt wird auf die Höhe der Eementgrundriss-Linie projiziert, wenn
///   die Z-Achse des aktuellen BKS parallel mit Z-Welt ist
///Version 1.0   17.05.2008   th@hsbCAD.de

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


// Rule
	String sCategoryRule = T("|Compose Rule|");
	String sComposeTypes[] = {  T("|Zone contour|"), T("|Generated sheets|")};
	PropString sComposeType(nStringIndex++, sComposeTypes, T("|Source|"),0);
	sComposeType.setCategory(sCategoryRule);	
	PropDouble dMergeGap(nDoubleIndex++, U(10), T("|Merge Gap|"));
	dMergeGap.setCategory(sCategoryRule);	

// Geo
	String sCategoryGeo = T("|Geometry|");	
	PropDouble dWidth(nDoubleIndex++, U(1250), T("|Width|"));	
	dWidth.setCategory(sCategoryGeo);	
	PropDouble dLength(nDoubleIndex++, U(3000), T("|Length|"));		
	dLength.setCategory(sCategoryGeo);
	PropDouble dThick(nDoubleIndex++, U(10), T("|Thickness|"));	
	dThick.setCategory(sCategoryGeo);
	PropDouble dGap(nDoubleIndex++, U(10), T("|Gap|"));		
	dGap.setCategory(sCategoryGeo);

// Properties
	String sCategoryProps = T("|Properties|");	
	PropString sMat(nStringIndex++, "", T("|Material|"));
	sMat.setCategory(sCategoryProps );
	PropString sLab(nStringIndex++, "", T("|Label|"));
	sLab.setCategory(sCategoryProps );
	PropString sSub(nStringIndex++, "", T("|Subabel|"));
	sSub.setCategory(sCategoryProps );
	PropString sGrade(nStringIndex++, "", T("|Grade|"));
	sGrade.setCategory(sCategoryProps );
			
	String sConvertTypes[] = {  T("|Beams|"), T("|Sheets|")};
	PropString sConvertType(nStringIndex++, sConvertTypes, T("|Target Object|"));	
	sConvertType.setCategory(sCategoryRule);	
	
	int nZones[] = {-5,-4,-3,-2,-1,1,2,3,4,5};
	PropInt nZone(nIntIndex++, nZones, T("|Zone|"));
	nZone.setCategory(sCategoryRule);
		
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

		// show the dialog if no catalog in use
		if (_kExecuteKey == "")
 			setPropValuesFromCatalog(sLastInserted);		
		// set properties from catalog		
		else	
			setPropValuesFromCatalog(_kExecuteKey);	
			
	
		Sheet sh = getSheet(T("|Select a sheet of desired zone|"));
		Element el = sh.element();
		if (!el.bIsValid())
		{
			reportMessage(TN("|Sheet must belong to an element.|") + " " + T("|Tool will be deleted.|"));
			eraseInstance();
			return;	
		}
		_Element.append(el);
		_Pt0 = getPoint(T("|Select first distribution point|"));
		if (_ZU.isParallelTo(_ZW))_Pt0 = _Pt0 - _ZW * _ZW.dotProduct(_Pt0-_Element[0].ptOrg());
		while (1) 
		{
			PrPoint ssP("\n" + T("|Select additional distribution point (optional)")); 
			if (ssP.go()==_kOk) // do the actual query
				_PtG.append(ssP.value()); // retrieve the selected point	
			else // no proper selection
				break; // out of infinite while	
		}	
		
		nZone.set(sh.myZoneIndex());
		ElemZone elzo = el.zone(nZone);
		dThick.set(elzo.dH());
		
		
		if (elzo.hasVar("width")) dWidth.set(elzo.dVar("width"));
		if (elzo.hasVar("height sheet")) dLength.set(elzo.dVar("height sheet"));
		if (elzo.hasVar("gap"))
		{
			dGap.set(elzo.dVar("gap"));
			if (elzo.hasVar("width")) 
				dWidth.set(elzo.dVar("width")-dGap);
		}

		
		sMat.set(elzo.material());
		
		setCatalogFromPropValues(sLastInserted);
		showDialog(sLastInserted);	

	
	}	
//end on insert________________________________________________________________________________


// declare standards
	if (_Element.length() < 1)
	{
		eraseInstance();
		return;
	}
	
	Element el = _Element[0];
	Point3d ptOrg;
	Vector3d vx,vy,vz;
	ptOrg = el.ptOrg();	
	vx=el.vecX();
	vy=el.vecY();
	vz=el.vecZ();
	
	vx.vis(ptOrg, 1);
	vy.vis(ptOrg, 3);
	vz.vis(ptOrg, 150);
	
	assignToElementGroup(el, TRUE,0, 'E');

// on creation set properties from execute key if applicable
	// set properties from catalog
	if (_kExecuteKey != "")
		setPropValuesFromCatalog(_kExecuteKey);
		
// add triggers
	String sTriggerCreate = T("|Create|")+" " + sConvertType;
	addRecalcTrigger(_kContext, sTriggerCreate);
	
		
// trigger: add split points
	String sTriggerAddPoints = T("|Add Split Points|");
	addRecalcTrigger(_kContext, sTriggerCreate);	
	if (_bOnRecalc && _kExecuteKey==sTriggerAddPoints) 	
	{
		while (1) 
		{
			PrPoint ssP("\n" + T("|Select Split Point|")); 
			if (ssP.go()==_kOk)
				_PtG.append(ssP.value()); // retrieve the selected point
			else
				break;
		}
	}
		
// relocate _Pt0 and all grips
	_Pt0 = _Pt0 - vz * vz.dotProduct(_Pt0-el.zone(nZone).ptOrg());
	for (int i = 0; i < _PtG.length(); i++)
		_PtG[i] = _PtG[i] - vz * vz.dotProduct(_PtG[i]-el.zone(nZone).ptOrg());


//ints
	int nComposeFrom = sComposeTypes.find(sComposeType);
	int nConvertType = sConvertTypes.find(sConvertType);
	
	ElemZone elzo = el.zone(nZone);

	
// collect sheet profile from zone
	PlaneProfile pp(elzo.coordSys());
	// compoise from Generated sheets
	if (nComposeFrom)
	{
		Sheet sh[0];
		sh = el.sheet(nZone);
		
		for (int i = 0; i < sh.length(); i++)
		{
			pp.joinRing(sh[i].plEnvelope(),_kAdd);
			pp.shrink(-abs(dMergeGap)/2);
			pp.shrink(abs(dMergeGap)/2);
			
			PLine plOp[0];
			plOp = sh[i].plOpenings();
			for (int o = 0; o < plOp.length(); o++)
				pp.joinRing(plOp[o],_kSubtract);	
		}// next o
	}// next i
	// compose from zone contour
	else
		pp = el.profNetto(nZone);
		
	pp.vis(6);
	
// element zone length
	LineSeg lsMinMax = pp.extentInDir(vx);
	double dElLength = abs(vx.dotProduct(lsMinMax.ptStart()-lsMinMax.ptEnd()));
	double dElHeight = abs(vy.dotProduct(lsMinMax.ptStart()-lsMinMax.ptEnd()));
	Point3d ptMinMax[] = {lsMinMax.ptStart(),lsMinMax.ptEnd()};	
	ptMinMax= Line(_Pt0,vx).orderPoints(ptMinMax);	
	if (ptMinMax.length()>1)//version value="1.8" date=19nov2018" author="thorsten.huck@hsbcad.com"> minor bugfix
	{
		ptMinMax[0].vis(3);
		ptMinMax[1].vis(4);
	}
	
		
// store and order distribution points
	Point3d pt[0];
	for (int i = 0; i < pt.length(); i++)
		pt[i].vis(i);

// the standard contour
	PlaneProfile ppSh[0];
	PLine plSh(el.zone(nZone).coordSys().vecZ());
	


// distribute to left
	Point3d ptStart, ptEnd;
	ptStart = _Pt0-vx * dGap;

	
	int nCnt;// limit looping to 1000
	
	Vector3d  vxDistr = -vx;
	ptEnd = ptOrg;
	
		
	if (nComposeFrom==1)
		ptEnd.transformBy(vxDistr *vxDistr.dotProduct(ptMinMax[0]-ptOrg));
	
	pt.append(ptEnd);
	pt.append(_PtG);		

ptStart.vis(1);
ptEnd.vis(2);

	for (int d = 0; d < 2; d++)
	{
		// swap direction
		if (d==1)
		{
			vxDistr = vx;	
			ptEnd = ptOrg + vxDistr*dElLength;
			if (ptMinMax.length()>1)
				ptEnd = ptMinMax[1];
			ptStart = _Pt0;
			pt = _PtG;
			pt.append(ptEnd);
		}
		pt = Line(_Pt0,vxDistr ).orderPoints(pt);
		
		for (int i = 0; i < pt.length(); i++)	
		{	
			while (vxDistr.dotProduct(ptEnd - ptStart)>0 && nCnt < 10)
			{		
				if (vxDistr.dotProduct(pt[i] - ptStart) >= dWidth)
				{
					plSh.createRectangle(LineSeg(ptStart , ptStart  + vxDistr * dWidth + vy * dLength), vxDistr, vy);
					plSh.vis(1);					
					//plSh.transformBy(ptStart - plSh.coordSys().ptOrg());
					ptStart = ptStart + vxDistr * (dWidth + dGap);
					PlaneProfile ppX(el.zone(nZone).coordSys());
					ppX.joinRing(plSh,_kAdd);	
					ppSh.append(ppX);
				}
				else if (vxDistr.dotProduct(pt[i] - ptStart) >= 0)
				{
					plSh.createRectangle(LineSeg(ptStart , ptStart  + vxDistr * vxDistr.dotProduct(pt[i]-ptStart) + vy * dLength), vxDistr, vy);
					plSh.vis(2);
					
					PlaneProfile ppX(el.zone(nZone).coordSys());
					ppX.joinRing(plSh,_kAdd);
					ppSh.append(ppX);
					ptStart = ptStart + vxDistr * (vxDistr.dotProduct(pt[i]-ptStart)+dGap);	
					break;
				}
				nCnt++;
			}	
			nCnt = 0;	
		}// next i
	}// next d

// copy ppSh's vertical
	PlaneProfile ppSh0[0],ppSh1[0];
	ppSh0 = ppSh;
	ppSh1 = ppSh;
	ptStart = _Pt0;
	ptEnd = ptOrg;
	if (nComposeFrom==1)
		ptEnd.transformBy(vxDistr *vxDistr.dotProduct(ptMinMax[0]-ptOrg));	
	
	
	nCnt = 0;
	while (vy.dotProduct(ptEnd - ptStart)<0 && nCnt < 100)
	{
		for (int i = 0; i < ppSh0.length(); i++)
		{
			ppSh0[i].transformBy(-vy * (dLength + dGap));	
			ppSh.append(ppSh0[i]);
		}
		ptStart = ptStart - vy * (dLength+dGap);
		nCnt++;
	}
		
	//ppShBackUp.transformBy(vy* (vy.dotProduct(_Pt0 - ptStart) - dLength));
	ptStart = _Pt0;
	ptEnd = ptOrg + vy * dElHeight;
	if (nComposeFrom==1)
		ptEnd.transformBy(vxDistr *vxDistr.dotProduct(ptMinMax[0]-ptOrg));	
	nCnt = 0;	

	while (vy.dotProduct(ptEnd - ptStart)>0 && nCnt < 100)
	{
		for (int i = 0; i < ppSh1.length(); i++)
		{
			ppSh1[i].transformBy(vy * (dLength + dGap));	
			ppSh.append(ppSh1[i]);
		}
		ptStart = ptStart + vy * (dLength+dGap);
		nCnt++;
	}

// Display
	Display dp(1);
	//dp.draw(scriptName(),_Pt0, _XW,_YW,0,0,_kDeviceX);		
	PLine plCirc0(vz),plCirc1(vz);
	plCirc0.createCircle(_Pt0,vz, U(50) );
	plCirc1.createCircle(_Pt0,vz, U(45) );		
	PlaneProfile ppCirc(plCirc0);
	ppCirc.joinRing(plCirc1,_kSubtract);
	dp.draw(ppCirc,_kDrawFilled);
	
	PLine plCr(vz);
	plCr.addVertex(_Pt0 - (vx+vy) * U(2.5));
	plCr.addVertex(_Pt0 - (vx-vy) * U(60));	
	plCr.addVertex(_Pt0 + (vx+vy) * U(2.5));
	plCr.addVertex(_Pt0 + (vx-vy) * U(60));
	plCr.close();	
	dp.draw(PlaneProfile(plCr),_kDrawFilled);
	CoordSys csRot;
	csRot.setToRotation(90,vz,_Pt0);
	plCr.transformBy(csRot);
	dp.draw(PlaneProfile(plCr),_kDrawFilled);

	Display dpPlan(1);
	dpPlan.addViewDirection(vy);
	CoordSys csTrans;
	csTrans.setToAlignCoordSys(_Pt0, vx, vy, vz, _Pt0, vx, -vz, vy);
	plCr.transformBy(csTrans);
	dpPlan.draw(PlaneProfile(plCr),_kDrawFilled);
	csRot.setToRotation(90,vy,_Pt0);
	plCr.transformBy(csRot);
	dpPlan.draw(PlaneProfile(plCr),_kDrawFilled);
			
// calc valid ppSh
	dp.color(253);
	for (int i = 0; i < ppSh.length(); i++)
	{	
		ppSh[i].intersectWith(pp);		
		PLine pl[] = ppSh[i].allRings();
		int nIsOp[] = ppSh[i].ringIsOpening();

		Body bd;
		for (int r = 0; r < pl.length(); r++)
			if (!nIsOp[r])
				bd.addPart(Body(pl[r], el.zone(nZone).coordSys().vecZ() * dThick, 1));	
		for (int r = 0; r < pl.length(); r++)
			if (nIsOp[r])
				bd.subPart(Body(pl[r], el.zone(nZone).coordSys().vecZ() * dThick, 1));
		dp.draw(bd);
	}
	
	
// convert
	// trigger0: 
	if ((_bOnRecalc && (_kExecuteKey==sTriggerCreate) || (_kExecuteKey==sDoubleClick)) ||_bOnDebug) 
	{
		if (!_bOnDebug)
		{
			Sheet sh[0];
			sh = el.sheet(nZone);
		// erase all existing sheets
			for (int i = 0; i < sh.length(); i++)
				sh[i].dbErase();
		}

		// loop all ppSh's
		for (int i = 0; i < ppSh.length(); i++)
		{
		// get all rings
			PLine plRings[0];
			plRings= ppSh[i].allRings();
			int bIsOp[] = ppSh[i].ringIsOpening();	
			
		// build a planeprofile per outline ring
			for (int r = 0; r < plRings.length(); r++) 
			{
				if (!bIsOp[r])
				{
					if (nConvertType==1)// sheets
					{		
						PlaneProfile ppSheet(elzo.coordSys());
						ppSheet.joinRing(plRings[r],_kAdd);
						for (int p= 0; p< plRings.length(); p++) if (bIsOp[p])ppSheet.joinRing(plRings[p],_kSubtract);
						if (ppSheet.area()< pow(U(1),2)) continue;
						
						if (!_bOnDebug)
						{
							Sheet shNew;
							shNew.dbCreate(ppSheet, dThick,1);
							shNew.assignToElementGroup(el, TRUE, nZone, 'Z');
							shNew.setMaterial(sMat);
							shNew.setLabel(sLab);
							shNew.setSubLabel(sSub);							
							shNew.setGrade(sGrade);			
							shNew.setColor(el.zone(nZone).color());
						}
						else
						{
							ppSheet.vis(i);
							ppSheet.extentInDir(vx).vis(r);
						}
					}
					else // beams
					{
						
						Body bd(plRings[r], el.zone(nZone).coordSys().vecZ() * dThick, 1);
						for (int p=0; p<plRings.length();p++)if (bIsOp[p])	bd.subPart(Body(plRings[p], elzo.coordSys().vecZ() * dThick, 1));				
						if (bd.volume()< pow(U(1),3)) continue;
						
						if (!_bOnDebug)
						{
							Beam bmNew;
							bmNew.dbCreate(bd, vy, -vx, vz);
							bmNew.assignToElementGroup(el, TRUE, nZone, 'Z');
							bmNew.setMaterial(sMat);
							bmNew.setLabel(sLab);
							bmNew.setSubLabel(sSub);							
							bmNew.setGrade(sGrade);			
							bmNew.setColor(el.zone(nZone).color());
						}
					}										
				}// END IF bIsOp[r]
			}// next r
		}
		if (!_bOnDebug)
			eraseInstance();
		return;
	}		









#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`<P!S``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`.:!)H#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
MJR7MK$VR2XC1O0L,U:KROQ:!'XJD*_[)KBQ^*>&IJ:5];'=@,&L54<&[:7/4
MQTXI:@MCFUB)_N#^53UV)W5SB:L[!1113$%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!17/>*=;GT6T@D@56:1]N&^E3^'-4FU?2
MA=3HJL7*@+[5SK$TW6]@OB.AX6HJ*K_9O8VJ***Z#G"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*\H
M\0L;CQ=,C<`3*GX<5ZO7D^I'[9XQD"<;K@`?G7C9UK3A'NSV\DTJ3EVB>J1J
M(XE0?P@"I*0#``]*6O96QX@4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`'(^/HM^BQ2?W)?YTO@&7=HLL?\`<E_G4_CD@>&W
MSU\U<51^'F?L%YZ>:/Y5XLM,T5NL?\_\CVX^]E+OTE_E_F=I1117M'B!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%>3+^Y\:?/VNN?SKUFO)A_I?C/G^*Z_D:\7./^75M[GMY-_P`O
M;[<IZS1117M'B!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`5S_BZZFLM">6WD:.3S%`9>HKH*YOQ
MN0/#<N?^>BUS8UM8>;79G5@DGB8)]T5O!%_=W]I<O=W#RE'`7=VXKK:XGX>`
M_8[T]O,'\J[:LLMDY86#D[O_`()KF<5'%S4=O^`%%%%=QP!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110!R'C^39I-NF?O2_R%2>`XPNA,W]Z0_I4OC>W27P\[MUC<%36=
M\/I6:UNXB?E5@1[5XK]W-$WU1[<?>RIVZ2U.WHHHKVCQ`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`$
M)P"?2O*-%'F>,H2>?])8_J:]5?B)OH:\L\.<^,(L_P#/5OZUXN::U:*\_P#(
M]O*=*-=_W?\`,]6HHHKVCQ`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*P/&*J?#=QN[$$?6M^L/
MQ9%YWANZ`_A7=^5<^+5Z$UY,Z<&[8B#?=&#\/"VV]7^'(/XUW5<!\/)OW]Y!
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
M10`4444`%%%%`!1110`4444`%>4:[(=1\62(.1YHB'TKU>O*O%<7V'Q1)(O&
M2LHKQLZ3]C%]+ZGM9&U[:2ZVT/4(HQ%$D8Z*H'Y5+5>UE$UK%+_?0']*L5[$
M;65CQG>[N%%%%,04444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4AZ4M%`'B_BNW^Q>*YHF;"S\YYS_G@UH6J[+:-?04?$<%
M/$=H1C!`)QUY./Z4ZW8-`I'3%<-323.B.Q)1114%!1110`4444`%%%%`!111
M0`4444`%%%%`!1110!0U3_5Q_6I-.(^R`>YIU^NZU8^G-5]+;B1?QKS'[F/7
MFOZ_(]A>_ENGV7_7YFC114\5I--$TJIB)>KL0JCVR>,\CBO42OHCQR"BDE\R
M*;REA:5L`Y3!4`_[72GQZ=K-P&$5DJL.@9QD_P!*?)+L+F0VH9[N&V!WM\W]
MT=35>5=41S%*GD2#J"F"/SKJ/"WA4QL;[4XF,F?D23KGU(_E3C!R=@;LKF+!
M;ZC<<I8.B$$JSG`-+)I>O^8OE6:.C<94YP??.,=*].6-$&%4`>E/KH]A$Q]H
MSSF/P=K%T`TT\**1RA8C'MTKJ=*\+Z;I<6!"LLI7#NXSGCG`[#GI6[151I1C
ML)S;*?\`9=@/^7*V_P"_2_X58BBCAC$<2*B#HJC`%245=D2%%%%,`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"O+O&CF;Q(R=`JJHKU&LB[\.Z
M;>W9NIX-TIQDYK@S##3Q-)0AW/0RW%0PU9U)KH7;&,16-O&.BQJ/TJU354(H
M4<`#`IU=L59)'!)W;844450@HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`\K^(<'G>($4YP(E/TY/-4-&G\ZR4_US
M4VH7CZGKD]Q/G.&VC/`'8?K5#0V_>3IT"L>/3-<$G>39TI65C:HHHJ1A1110
M`4444`%%%%`!1110`44Y59W5$4LS'``&236G#X=U*64H81&`<%G88'&>W7\*
M:BWL)M+<RJ*VIO#&I1;=BQS9Z['QC\\4VST"XEE8W9%M"C?.7.&('7;_`(]/
MK5>SE>UA<R,E59W5$4LS'``&236BN@:HZJPM"`1D9=0?R)K>M(M%TL&YCG#D
M='9]Q&>PQ_GDTQM5U'47\O3X/*A.1YLGWO3IVZ'_`.M6L:'\Q#J=CD];TJ_L
M-/,MQ!L0L%SN!_D:JZ!$DIE'EM))QL4'`/U/I_CU&*W_`!)I<MOHDUU=7#RR
M,P(#'.TGL/:E^'T2F.[E*Y(8`&O+G32S*"WT_P`SV*<F\KF_/_(M+:ZBZK"-
M,M(1@`2>2&(X[Y_^O5]-`:8QF[D9D4?ZO/`]@.E=#17N62V/"N4;?2[2V4;8
M@2HP"1SCTJXJJH`4``4ZBF`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'D.N6,F
MEZV$?YE4,5<#AAW_`!JCHV&EF9,!2V?K77>.X8A,KR#YV4E#NQ@@8'\ZYG18
M?*L4]<5Q5(<KT-X2NC2HHHK,L****`"BK"V<S0K-A%C8D*7D5<X],FJUVWV+
MB49.,_(0^/Q'`JN5[V%=;"T5534(78*%DR>@VYS^5=%8MIMA%')<V\MU<.?N
M"(XCX]#U_P`_6G"#D]!2DD,T[0;J^(=E,$)&?,8=?3`[]>O2M@>%K*&$M<74
MOR@EW!"K^H/\Z<VI:G?_`/'E"(8ST9QDC_\`73O[$N;U0U_<,S=<9X!Z9`Z=
M*Z8THK<R<VRC;SZ3I5VQM$GN9BGR.V-OX''?UYJT=9U:X0?9K!$;.<.Q)QCI
MBMFUTZVM(1''$H``&,<<5;``Z"M$DMB&[G.B;Q!-$%/EPOGJ(^OYYI8?#SSD
M2WT[2R=<-S^%=%13`S(]"LHD"(A"CMVJ_##'`@2-0JCL*DHH`YCQRK-X=8@\
M+*I(JE\/7!L+M,<B0']*U/&(SX;N/8BL;X>']W>#W%>+5TS.'FO\SVZ6N53\
MG_D=S1117M'B!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'`?$[":9`W`9
MFV@XY`ZUCVP'E;E7:&.0,8Q71_$/2Y]1T6-K=`7A?.2?7T_3K7.Z5X:UK4XH
MO.S%""4+$@``<'CJ>E<]9.322-8-)7&RW<$/#R#/H.35;^T]W^K@8^N37>6W
M@C1X$`>%IF[EF(S^53R>$M,=@8UDA`&,(W7\\U'L9#]HCSR*?4;F98X;9<L0
MJC/))K8B\-:[<,J3>5"C?>VYSCT^M=I8:)9Z=)YD2L\O.'<Y('MV_P#UUJUI
M"BOM"E4['/6OAJ$(GVIS*54+\W/`''^?:M"'1+&%LK$"?>M&BMS(K"Q@`P$/
M_?1IWV6#<#Y8R/6IZ*`&JBHNU5`'H*=110`4444`%%%%`!1110!S_C+(\-W&
M!W%8OP\QLO>><BNC\21^;X>O5[^7D5R?P^DVW]U%V,8/ZUXN(]W,:;[K_,]O
M#^]EE5+H_P#(]#HHHKVCQ`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@!I`
M8$$`CT-``4``8`["G44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10!A^+)/+\.7>#C<NVN<^'L0\^\F[A0M=%XNC\SPW=?[(#5S_P`/)?WE[%[!
MJ\7$?\C*G?M_F>WA_P#D65+=_P#([VBBBO:/$"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`,S7(I)]$NXH8R\C1D*H[UR_@G2[VQO[E[NW>$>6`-PZ\UW=%<E3"1J5HUF]
M8G72Q<J="=!+204445UG(%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
?`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'_V444
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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End