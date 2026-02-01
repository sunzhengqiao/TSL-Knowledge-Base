#Version 7
#BeginDescription
Version 2.1   25.05.2007   th@hsbCAD.de
DE  Ausgabefeld Gruppe' ergänzt
EN  field 'Group'added
Version 2.0   23.03.2007   th@hsbCAD.de
DE  neue Option 'Kantenlängen zeigen an/aus'), Vorgabe = aus
EN  new context option 'Show edge description on/off' <default = off>

Version 1.9   22.03.2007   th@hsbCAD.de
DE  Brutto/Nettoflächendarstellung im Modus 'Dachfläche'
EN  brut/net area will be diplayed in mode 'roofplane'
Version 1.8   02.03.2007   th@hsbCAD de
   - bugFix
Version 1.7   26.02.2007   th@hsbCAD de
DE  neue Eigenschaft zur Ausgabe des Flächentyps (Dachfläche oder Trauffläche)
   für Excel und hsbRP_Analysis)
EN  new property to determine type of area (roof area or eave area)
   to output with MS Excel und hsbRP_Analysis
Version 1.6   16.01.2007   dt@hsb-cad.com
DE dxi Export ergänzt
EN dxi export supported
Version 1.5   04.12.2006   th@hsbCAD de
DE Erläuterung zur Gruppentrennung korrigiert - es wird nur ein einfacher
     Backslash benötigt um die Ebenen zu trennen
EN Explanation for grouping structure corrected - you need only to enter 
     a single backslash to seperate the levels
Version 1.4   08.11.2006   th@hsbCAD de
DE - unterstützt Datenausgabe über hsbRP_BOM
EN - supports data output to hsbRP_BOM
Version 1.3   06.11.2006   th@hsbCAD de
DE Schraffur ergänzt
   - neue Kontextbefehle Punkt hinzufügen/löschen ermöglichen
     die freie Bearbeitung der Traufflächen
EN hatch pattern added
   - new context commands add/remove point to manipulate shape of eave area


Version 1.2   04.07.2006   th@hsbCAD de
DE Excel Export wird unterstützt
EN supports excel BOM
Version 1.1   12.05.2006   th@hsbCAD de
DE
    - Gruppenzuordnung ergänzt
EN
   - group assignment added
Version 1.0   28.04.2005   th@hsbCAD de
   - definiert einen Traufbereich an einer Dachfläche
   - Datenausgabe optional zusätzlich in MS Excel (TSL hsbRP_Roofline)
   - kann über das TSL hsbRP_Analysis automatisch eingefügt werden

   - defines the overhang area at the eave of a roofplane
   - data evaluation optional to MS Excel possible (requires hsbExcel.dvb)
   - autoinsert can be done by the tsl hsbRP_Analysis  








#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#MajorVersion 2
#MinorVersion 1
#KeyWords 
#BeginContents
// // ########################################################################
// Script			:  hsbRP_EaveArea
// Description	:  creates area descriptions from a pline. satellite of hsbRP_Analysis
// Author		: 	th@hsbCAD.de
// Date			: 02.03.2007
// ------------------------------------------------------------------------------------------------------------------------------------
// Changes:
// ---------------
// Date		Change By		Description
// ------------------------------------------------------------------------------------------------------------------------------------
// 22.03.07	th@hsbCAD.de	brut/net area will be diplayed in mode 'roofplane'
// 23.03.07	th@hsbCAD.de new context option 'Show edge description on/off
//
// COPYRIGHT
//  ---------
//  Copyright (C) 2007 by
//  hsb SYSTEMS gmbh
//  Germany
//
//  The program may be used and/or copied only with the written
//  permission from hsb SYSTEMS gmbh., or in accordance with
//  the terms and conditions stipulated in the agreement/contract
//  under which the program has been supplied.
//
//  All rights reserved.
// #########################################################################

// basics and props
	U(1,"mm");
	PropString sRoof(4,"",T("Roof Name"));
	String sArAreaType[] = {T("|Roof area|"),T("|Eave area|")};
	PropString sAreaType(6,sArAreaType,T("Type of area"));
	PropString sMat(1,"",T("Material"));
	String sArUnit[] = {"mm", "cm", "m", "inch", "feet"};
	PropString sUnit(2,sArUnit,T("Unit"));
	int nArDecimals[] = {0,1,2,3,4};
	PropInt nDecimals(0,nArDecimals,T("Decimals"));		
	PropString sGroup(3,"",T("Group") + " " + T("(seperate Level by '\\')"));
	// hatch pattern
	String sArHatch[0];
	sArHatch.append(T("None"));
	sArHatch.append(_HatchPatterns);	
	PropString sHatch(5,sArHatch,T("Hatch pattern"));	
	PropDouble dHatchScale(0,U(30),T("Hatch scale"));	
	PropString sDimStyle(0,_DimStyles,T("Dimstyle"));	
	PropInt nColor (1,93,T("Color"));
		
// on insert
	if (_bOnInsert){
		showDialog();
		_Map.setEntity("er", getERoofPlane());
		_PtG.append(_Pt0);
		// select points
		while (1) {
			PrPoint ssP2("\n" + T("select points")); 
		   if (ssP2.go()==_kOk)  // do the actual query
				_PtG.append(ssP2.value()); // append the selected points to the list of grippoints _PtG
			else // no proper selection
		   		break; // out of infinite while
		}
		
		_Pt0.setToAverage(_PtG);
		_PtG.append(_Pt0  - _XW * U(300));	
	}

// restrict color index
	if (nColor > 255 || nColor < -1) nColor.set(93);
	sAreaType.setReadOnly(TRUE);

// hatch index
	int nHatch = sArHatch.find(sHatch);

// add triggers
	String sTrigger[] = {T("Add Point"), T("Remove Point"), T("Select polyline"),T("|Show edge description on/off|")};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);


			
// find valid roofplane
	ERoofPlane er;
	if (_Map.hasEntity("er")) {
		Entity ent;
		ent =  _Map.getEntity("er");
		er = (ERoofPlane)ent;
	}
	else
	{
		reportNotice(TN("No valid roofplane found.") + " " + T("TSL will be deleted."));
		eraseInstance();
		return;	
	}

// declare standards
	CoordSys cs;
	Vector3d vx,vy,vz;
	Point3d ptOrg;

	cs = er.coordSys(); 
	ptOrg = cs.ptOrg();
	vx = cs.vecX();
	vy = cs.vecY();
	vz = cs.vecZ();
	
	_Pt0.vis(20);

// project all PtG to roofplane
	for (int i = 0; i < _PtG.length(); i++)
		if (i == 0)// project perp to roofplane
			_PtG[i] = _PtG[i] - vz * vz.dotProduct(_PtG[i] - _Pt0);
		else// project perp to plan
			_PtG[i] = _PtG[i] - _ZW * _ZW.dotProduct(_PtG[i] - _Pt0);
	
// Group
	if (sGroup != "")
	{
		Group grRL();
		grRL.setName(sGroup);
		grRL.addEntity(_ThisInst, TRUE);
	} 
		
// declare Pline
	PLine pl(vz);
	for (int i = 1; i < _PtG.length(); i++){
		pl.addVertex(_PtG[i]);
	}
	pl.close();
	pl.projectPointsToPlane(Plane(ptOrg, vz), _ZW);


// trigger0: add  point
	if (_bOnRecalc && _kExecuteKey==sTrigger[0]) 
	{
		Point3d ptToAdd[0];
		while (1)
		{
			PrPoint ssP2("\n" + T("Select point")); 
			if (ssP2.go()==_kOk) // do the actual query
				ptToAdd.append(ssP2.value()); // retrieve the selected point	
			else // no proper selection
				break; // out of infinite while	
		}
				
		// store add new points to pline
		for (int i = 0; i < ptToAdd.length(); i++)
		{
			// get closest point on pline
			Point3d ptOnPline;
			pl.vis(6);
			ptOnPline = pl.closestPointTo(ptToAdd[i]);
			
			// find segment where grip should be added
			Point3d ptPl[] = pl.vertexPoints(FALSE);
			for (int p = 0; p < ptPl.length()-1; p++)
			{
				PLine plSeg(ptPl[p], ptPl[p+1]);
				if (plSeg.isOn(ptOnPline))
				{
					// project to plane
					ptToAdd[i] = ptToAdd[i].projectPoint(Plane(ptOrg, vz),0);
					ptPl.insertAt(p+1,ptToAdd[i]);
					_PtG.append(ptToAdd[i]);
					pl = PLine();
					for (int q = 0; q < ptPl.length()-1; q++)
					{
						pl.addVertex(ptPl[q]);
					}// next q
					pl.close();
					break;
				}	// endif
			}// next p
		}// next i

	}

// trigger1: remove point
	if (_bOnRecalc && _kExecuteKey==sTrigger[1]) 
	{
		// collect points to be removed
		Point3d ptRemove[0];
		while (1)
		{
			PrPoint ssP2("\n" + T("Select point")); 
			if (ssP2.go()==_kOk) // do the actual query
				ptRemove.append(ssP2.value()); // retrieve the selected point	
			else // no proper selection
				break; // out of infinite while	
		}
		
		//loop all grips to find closest point
		int nRemove[0];
		for (int i = 0; i < ptRemove.length(); i++)	
		{	
			double dDist = U(100000);
			int nRemoveIndex = -1;
			for (int p = 1; p < _PtG.length(); p++)
			{
				double dRemoveDist = Vector3d (ptRemove[i]- _PtG[p]).length();
				if (_bOnDebug)
					reportNotice("\nremove dist " +p + ": " + dRemoveDist );
				if (dRemoveDist  < dDist)
				{
					dDist = dRemoveDist; 
					nRemoveIndex = p;
				}
			}
			if (nRemoveIndex>-1)
			{
				nRemove.append(nRemoveIndex);
				if (_bOnDebug)
					reportNotice("\nremove index " + nRemoveIndex);
			}
		}// next p

		// remove grips
		for (int p = 0; p < nRemove.length(); p++)	
			_PtG.removeAt(nRemove[p]);

		
		// error trap
		if (_PtG.length() < 4)		
		{
			reportNotice("\n*****************************************************************\n" + 
						scriptName() + ": " + T("Incorrect user input.") + "\n" + 
						 T("ErrMsg") + "\n" + 
						 T("ErrMsg") + "\n" +
						"*****************************************************************");
			eraseInstance();
			return;	
		}
		// redefine pline
		pl = PLine();
		for (int i = 1; i < _PtG.length(); i++)
			pl.addVertex(_PtG[i]);
		pl.close();
		setExecutionLoops(2);
			
	}

// trigger0: select pline
	if (_bOnRecalc && _kExecuteKey==sTrigger[2]) 
	{
		EntPLine epl = getEntPLine(T("Select closed pline"));
		PLine plPlan = epl.getPLine();
		plPlan.projectPointsToPlane(Plane(ptOrg,vz),_ZW);
		PlaneProfile ppEr(er.plEnvelope()); 
		ppEr.subtractProfile(PlaneProfile(plPlan ));
		PLine plAllRings[] = ppEr.allRings();
		if (plAllRings.length() > 0){
			pl = plAllRings[0];
			Point3d ptVertices[] = pl.vertexPoints(FALSE);
			_PtG.setLength(ptVertices.length());	
		}	
	}

// trigger3: show visibility
	if (_bOnRecalc && _kExecuteKey==sTrigger[3]) 
	{
		if (_Map.getInt("showEdge") == 1)
			_Map.setInt("showEdge",0);
		else
			_Map.setInt("showEdge",1);	
	}
			
// relocate grips
	Point3d ptGrips[] = pl.vertexPoints(TRUE);
	for (int i = 0; i < ptGrips.length(); i++)
	{
		//ptGrips[i].vis(i);
		_PtG[i+1] = ptGrips[i];
	
	}
	
	

				
//Display
	Display dp(nColor);
	dp.dimStyle(sDimStyle);
	dp.draw(pl);
	//dp.draw(PlaneProfile(pl),_kDrawFilled);
	//dp.color(6);
	//dp.draw(PlaneProfile(er.plEnvelope()),_kDrawFilled);
	
// area calculation
	PlaneProfile ppArea(cs);
	ppArea.joinRing(pl, _kAdd);
	
// subtract openings from area
	for (int i = 0; i< _Map.length(); i++)
	{
		String sToken = _Map.keyAt(i);
		if (sToken.left(5) == "plSub")
			ppArea.subtractProfile(PlaneProfile(_Map.getPLine(i)));
	}

// area
	double dBrutArea, dNetArea, dOpArea;
	PLine plArea[0];
	plArea = ppArea.allRings();
	int nIsOp[] = ppArea.ringIsOpening();
	
	// find biggest ring = brutarea
	for (int i = 0; i < plArea.length();i++)
	{
		if (!nIsOp[i])
			dBrutArea += plArea[i].area();		
		else
			dOpArea+= plArea[i].area();			
	}
	dNetArea = dBrutArea - dOpArea;

//Area
	String sArea;
	sArea.formatUnit(dBrutArea / (U(1,sUnit,2) * U(1,sUnit,2)),2,nDecimals);

// Text
	//dp.draw(sArea + sUnit + "2", _PtG[0], vx, vy, 0, 1.5, _kDeviceX);
	double dTxtOffset = 0;
	if (sMat != "" || dBrutArea != dNetArea)
		dTxtOffset = 1.5;

	String sTxt1, sTxt2;
	sTxt1 = sArea +  sUnit + "² " + T("|brut|");
	if (dBrutArea != dNetArea && sAreaType== sArAreaType[0])// roof type
	{
		dTxtOffset = 1.5;
		sTxt2.formatUnit(dNetArea / (U(1,sUnit,2) * U(1,sUnit,2)),2,nDecimals);	
		sTxt2 = sTxt2 +  sUnit + "² " + T("|net|")	;
	}
	else if (sMat != "" && sAreaType== sArAreaType[1])
	{// eave type
		dTxtOffset = 1.5;
		sTxt2 = sMat;
	}
	dp.draw(sTxt1, _PtG[0], vx, vy, 0, dTxtOffset, _kDevice );//
	dp.draw(sTxt2, _PtG[0], vx, vy, 0, -dTxtOffset, _kDevice );//
	
// hatch area
	PlaneProfile  ppHatch = ppArea;
	double dHeightNoHatch = dp.textHeightForStyle(sArea + sUnit, sDimStyle) * (dTxtOffset +2);
	double dWidthNoHatch = dp.textLengthForStyle(sTxt1, sDimStyle) * 1.5;	
	double dWidthNoHatch2 = dp.textLengthForStyle(sTxt2, sDimStyle) * 1.5;
	if (dWidthNoHatch2 > dWidthNoHatch)
		dWidthNoHatch = dWidthNoHatch2;	
	PLine plNoHatch(vz);
	plNoHatch.createRectangle(LineSeg(_PtG[0] - 0.5 * (vx * dWidthNoHatch + vy * dHeightNoHatch),
	 _PtG[0] + 0.5 * (vx * dWidthNoHatch + vy * dHeightNoHatch)), vx, vy);
	plNoHatch.vis(2);
	if (ppHatch.pointInProfile(_PtG[0]) == _kPointInProfile)
		dp.draw(plNoHatch);
	
	ppHatch.subtractProfile(PlaneProfile(plNoHatch));
	


	double dPeri;
	//Length
	for (int i = 1; i < _PtG.length(); i++){
		_PtG[i].vis(i);
		int n = i+1;
		if (n == _PtG.length())	
			n = 1;
		Point3d ptMid = (_PtG[i] + _PtG[n])/2;
		Vector3d vxL, vyL, vzL;
		vxL = _PtG[n] - _PtG[i];
		
		dPeri = dPeri + vxL.length();	
		dxaout("hsbEaveLength"+i, vxL.length());	
		String sLength;
		sLength.formatUnit(vxL.length() / U(1,sUnit,2),2,nDecimals);
		
		vxL.normalize();
		vxL.vis(_PtG[i],i);
		vyL = vz.crossProduct(vxL);
		vyL.vis(_PtG[i],i);
		
		// Text
		if (_Map.getInt("showEdge") == TRUE)
			dp.draw(sLength + sUnit, ptMid, vxL, vyL, 0, 1, _kDevice);
		
	}	
	
// Hatch
	if (nHatch > 0)
	{
		Hatch hatch(sArHatch[nHatch],dHatchScale);		
		dp.draw(ppHatch, hatch);
	}	


	

	
// output
	setCompareKey(scriptName() + er.handle() + String(pl.area()) + sMat);
	dxaout("Name", sRoof);	
	dxaout("NetArea", dNetArea/( U(1,"mm")* U(1,"mm")));			
	dxaout("BrutArea", dBrutArea/( U(1,"mm")* U(1,"mm")));	
	dxaout("Area", dBrutArea/( U(1,"mm")* U(1,"mm")));	
	dxaout("Type", sAreaType);	
	dxaout("Perimeter", dPeri/ U(1,"mm"));	
	dxaout("ParentEntity", er.handle());	
	dxaout("Group", sGroup);	

// set map
	Map mapSub;
	mapSub.setString("Mat", sMat);
	mapSub.setDouble("Area", dBrutArea/( U(1,"mm")* U(1,"mm")));
	mapSub.setDouble("AreaNet", dNetArea/( U(1,"mm")* U(1,"mm")));
	pl.projectPointsToPlane(Plane(_PtW,_ZW),_ZW);
	mapSub.setPLine("pl", pl);
	_Map.setMap("TSLBOM", mapSub);





#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0```0`!``#__@`N26YT96PH4BD@2E!%1R!,:6)R87)Y
M+"!V97)S:6]N(%LQ+C4Q+C$R+C0T70#_VP!#`%`W/$8\,E!&049:55!?>,B"
M>&YN>/6ON9'(________________________________________________
M____VP!#`55:6GAI>.N"@NO_____________________________________
M____________________________________Q`&B```!!0$!`0$!`0``````
M`````0(#!`4&!P@)"@L0``(!`P,"!`,%!00$```!?0$"`P`$$042(3%!!A-1
M80<B<10R@9&A""-"L<$54M'P)#-B<H()"A87&!D:)28G*"DJ-#4V-S@Y.D-$
M149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@X2%AH>(B8J2DY25EI>8
MF9JBHZ2EIJ>HJ:JRL[2UMK>XN;K"P\3%QL?(R<K2T]35UM?8V=KAXN/DY>;G
MZ.GJ\?+S]/7V]_CY^@$``P$!`0$!`0$!`0````````$"`P0%!@<("0H+$0`"
M`0($!`,$!P4$!``!`G<``0(#$00%(3$&$D%1!V%Q$R(R@0@40I&AL<$)(S-2
M\!5B<M$*%B0TX27Q%Q@9&B8G*"DJ-38W.#DZ0T1%1D=(24I35%565UA96F-D
M969G:&EJ<W1U=G=X>7J"@X2%AH>(B8J2DY25EI>8F9JBHZ2EIJ>HJ:JRL[2U
MMK>XN;K"P\3%QL?(R<K2T]35UM?8V=KBX^3EYN?HZ>KR\_3U]O?X^?K_P``1
M"`$R`98#`1$``A$!`Q$!_]H`#`,!``(1`Q$`/P":@"/_`)>?^`?UH`DI"#-%
MPN%`#?X6_P!\?TI,9*>E("M`^(E&UC]!5@/\S_8?_OF@`\S_`&'_`.^:`#S/
M]A_^^:`#S/\`8?\`[YH`/,_V'_[YH`/,_P!A_P#OF@`\S_8?_OF@`\S_`&'_
M`.^:`#S/]A_^^:`#S/\`8?\`[YH`/,_V'_[YH`/,_P!A_P#OF@`\S_8?_OF@
M`\S_`&'_`.^:`#S/]A_^^:`#S/\`8?\`[YH`/,_V'_[YH`/,_P!A_P#OF@`\
MS_8?_OF@`\S_`&'_`.^:`#S/]A_^^:`#S/\`8?\`[YH`/,_V'_[YH`/,_P!A
M_P#OF@`\S_8?_OF@`\S_`&'_`.^:`#S/]A_^^:`#S/\`8?\`[YH`/,]4?_OF
M@!]`!0`4`%`!0`4`%`!0`4`%`K(*`L@H"R"@+(*`:N%`QKHK,-R@\4@Z#?)C
M_NB@0>5'_=%`!Y,?]T4`,:).?E'W@/Y4#'^3'_<%,!L*0F)2P7/N:0#_`"X/
M1/SI`'EP>B?G0`>7!Z)^=`!Y<'HGYT`'EP>B?G0`>7!Z)^=`!Y<'HGYT`'EP
M>B?G0`>7!Z)^=`!Y<'HGYT`'EP>B?G0`>7!Z)^=`!Y<'HGYT`'EP>B?G0`>7
M!Z)^=`!Y<'HGYT`'EP>B?G0`>7!Z)^=`!Y<'HGYT`'EP>B?G0`>7!Z)^=`!Y
M<'HGYT`'EP>B?G0`>7!Z)^=`!Y<'HGYT`'EP>B?G0`>7!Z)^=`!Y<'HGYT`-
M>.'8V`N<<<TP'>3'_<%,`\F/^X*`$\J+^Z*!V8>5%_=%`68>5%_=%`68>5%_
M=%`68>5%_=%`6%\F/^X*!!Y,?]P4`'DQ_P!P4`'DQ_W!0`>3'_<%`!Y,?]P4
M`'DQ_P!P4`/H`0]12#H+0(*`"@"-N_\`O#^E`QYZ4P(H(T:)25!-`#_)C_NB
M@`\F/^Z*`#R8_P"Z*`#R8_[HH`/)C_NB@`\F/^Z*`#R8_P"Z*`#R8_[HH`/)
MC_NB@`\F/^Z*`#R8_P"Z*`#R8_[HH`/)C_NB@`\F/^Z*`#R8_P"Z*`#R8_[H
MH`/)C_NB@`\F/^Z*`#R8_P"Z*`#R8_[HH`/)C_NB@`\F/^Z*`#R8_P"Z*`#R
M8_[HH`/)C_NB@`\F/^Z*`#R8_P"Z*`#R8_[HH`C"+]F)VC.3SCWI=0)Z8!0`
MF=J`_04#>X?-_='YTKB#YO[H_.BX`2PZKQ]:+@!^\*8^@M`@H`*`"@`H`*`"
M@`H`0]12#H+0(*`"@"-N_P#O#^E`QYZ4P&6_^H6@"2@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@"+_EU;ZG^=+J!+
M3`*`&M]Q?JO\Q2Z#>Y)2$%`#7Z#ZBA`(?O"J'T%H$%`!0`4`%`!0`4`%`"'J
M*0=`H$+0`E`#&[_[P_I0,>>E,!EO_J%H`DH`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`B_P"75OJ?YTNH$M,`H`:W
MW%^J_P`Q2Z#>Y)2$%`#7Z#ZBA`(?O"J'T%H$%`!0`4`%`!0`4`%`"'J*0=!:
M!"4`+0!&W?\`WA_2@8\]*8#+?_4+0!)0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0!#_RZ-]3_`#I=0),R?\\Q_P!]
M47`,R?\`/,?]]47`:2S+C:/KNHN4T[C<2?WF_P"^Q_A1H*S#$G]YO^^Q_A1H
M%F*`^1DD^Q<?X47068[<Q(^49_WJ+CMH+F3_`)YC_OJBY(9D_P">8_[ZHN`9
MD_YYC_OJBX!F3_GF/^^J+@&9/^>8_P"^J+@&9/\`GF/^^J+@&9/^>8_[ZHN`
MZF`AZBD'06@0E`!0`QOXO]X?TH&//2F`RW_U"_C_`#H`DH`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`A_Y=&^I_G2
MZ@/\L_\`/23\Z8!Y9_YZ2?G0`>6?^>DGYT`'EG_GI)^=`!Y9_P">DGYT`'EG
M_GI)^=`!Y9_YZ2?G0`>6?^>DGYT`'EG_`)Z2?G0`>6?^>DGYT`'EG_GI)^=`
M!Y9_YZ2?G0`>6?\`GI)^=`!Y9_YZ2?G0`^@!#U%(.@M`@H`*`(V[_P"\/Z4#
M'GI3`9;?ZA?Q_G0!)0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0!%_RZM]3_.EU`EI@%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`AZBD'06@0E`"T`1MW_`-X?TH&//2F`RV_U"_C_`#H`DH`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`B_
MY=6^I_G2Z@2TP"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`0]12#H%`@H`6@"
M-N_^\/Z4#'GI3`9;?ZA?Q_G0!)0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0!%_P`NK?4_SI=0):8!0`4`%`!0`4`%
M`!0`4`%`!0`4`->18\;CC-`#@01D<B@!>*`$/44@Z!0(*`"@"-N_^\/Z4#'G
MI3`9;?ZA?Q_G0!)0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0!%_RZM]3_`#I=0):8!0`4`%`!0`4`%`!0`4`%`!0`
MUFP=J\M_*@!CH%"]R6&2:`%*M&?W8!!_AZ8H`DH`0]12#H%`A:`$H`8W?_>'
M]*!CSTI@,MO]0OX_SH`DH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`B_Y=6^I_G2Z@2TP"@`H`*`"@`H`*`"@`H`*
M`&LQSM7KW/I0`JJ%'OW/K0`V7HO^\*`'T`%`"'J*0=`H$+0`4`1M_%_O#^E`
MQYZ4P&6W^H7\?YT`24`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`1?\NK?4_SI=0):8!0`4`%`!0`4`%`!0`4`-+%N
M$_%O2@!54*,`4`+0`R7HO^\*`'T`%`"'J*0=!:!!0`4`1MW_`-X?TH&//2F`
MRV_U"_C_`#H`DH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`B_Y=6^I_G2Z@2TP"@`H`*`"@`H`,U+9+?8!Q32&E89
MDR<*<+Z^OT_QIC'@`#`X%`!0`4`,EZ+_`+PH`?0`4`(>HI!T"@0M`!0!&W?_
M`'A_2@8\]*8#+;_4+^/\Z`)*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`(O\`EU;ZG^=+J!+3`*`"@`H`*`#-3<F^
MH=.35#&<R=L)_/\`^M0,?0`4`%`!0`R7HO\`O"@!]`!0`AZBD'06@04`%`$;
M=#_O#^E`(>>E,8RV_P!0OX_SH`DH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`KX_<$Y/4]_>@"Q0`4`%`!0`F<FIO
M<AN[T`D*,DX%-(I*PW!D.6X7L/7Z_P"%,8^@`H`*`"@`H`9+T7_>%`#Z`"@!
M#U%(.@M`@H`2@!C=#_O#^E"!#STIC&6W^H7\?YT`24`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`0?\NY^I_G0!/0`
M4`%`"=:G<CX@)"#)_P#UTTK%)6$523N?KV'I_P#7IC'4`%`!0`4`%`!0`R7H
MO^\*`'T`%`"'J*0=!:!!0`4`1M_%_O#^E`QYZ4P&6_\`J%_'^=`$E`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`$'_
M`"[GZG^=`$]`!0)NPG4U&[)M=@S!![GH/6K*2L(JG.YN6_04#'4`%`!0`4`%
M`!0`4`,EZ+_O"@!]`!0`AZBDPZ"T"$H`6@"-N_\`O#^E`QYZ4P&6_P#J%H`D
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`@_Y=S]3_.@">@!.M3N2M09MO`&6/0510BKCECECWH`=0`4`%`!0`4`%
M`!0`4`,EZ+_O"@!]`!0`AZBDPZ!0(*`%H`C;O_O#^E`QYZ4P&6_^H6@"2@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@"#_`)=S]3_.@">E835QK-SM7EOT%,8JJ%]R>I-`"T`%`!0`4`%`!0`4`%`!
M3)>XR7HO^\*10^@`H`0]12#H%`A:`"@"-N_^\/Z4#'GI3`9;_P"H6@"2@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M"#_EW/U/\Z`)2Q)VH>>Y]/\`Z]`"JH48%`"T`%`!0`4`%`!0`4`%`!0`4R&M
M1DO1?]X4BQ]`!0`AZBD'06@04`)0`QN_^\/Z4#'GI3`9;_ZA:`)*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`*_S&
M!@!P"<G\>U("P`%&`,"F`4`%`!0`4`%`!0`4`%`!0`4`%,EIC)>B_P"\*10^
M@`H`0]12#H+0(*`"@"-N_P#O#^E`QYZ4P&6_^H6@"2@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`.E`#,E^G"^OK2`&_X]
M6_SWI=0'U0!0`4`%`!0`4`%`!0`4`%`!0`4R6V,EZ+_O"D4/H`*`$/44@Z"T
M""@`H`C;O_O#^E`QYZ4P&6_^H6@"2@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`)Q0`SE^6&%[#UI"'=Z`&M_P`>K?Y[TNHQ
M]4`4`%`!0`4`%`!0`4`%`!0`4`%,A[C)>B_[PI%CZ`"@!#U%(.@4"%H`*`(V
M[_[P_I0,>>E,!EO_`*A:`)*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`&(49/2@!@RW+<#L*0A]`"=Z`&M_P`>K?Y[TNHQ]4`4
M`%`!0`4`%`!0`4`%`!0`4`%,E[C)>B_[PI%#Z`"@!#U%(.@M`@H`2@!C=_\`
M>']*!CSTI@,M_P#4+0!)0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`!.!G&:`&A23N;KV'I2$+0`M`"=Z`Z#6_P"/5O\`/>EU&/J@
M"@`H`*`"@`H`*`"@`H`*`"@`IDVU&2]%_P!X4BA]`!0`AZBD'06@04`%`$;=
M_P#>']*!CSTI@,M_]0M`$E`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`'I0`E(0M`!0`G>@.@UO\`CU;_`#WI=1H?5`%`!0`4`%`!
M0`4`%`!0`4`%`!0`R7HO^\*`'T`%`"'J*0=!:!!0`4`1MW_WA_2@8\]*8#+?
M_4+0!)0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`!
MZ4`%(04`%`"=Z`Z#6_X]6_SWI=1CZH`H`*`"@`H`*`"@`H`*`"@`H`*`&2]%
M_P!X4`/H`*`$/44@Z"T""@`H`C;O_O#^E`QYZ4P&6_\`J%H`DH`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*``]*&`E(0M`!0`G>@!K
M?\>K?Y[TNHQ]4`4`%`!0`4`%`!0`4`%`!0`4`%`#)>B_[PH`?0`4`(>HI!T%
MH$%`!0!&W?\`WA_2@8\]*8#+?_4+0!)0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`!Z4`)2$+0`4`)WH`:W_'JW^>]+J,?5`%`!0`
M4`%`!0`4`%`!0`4`%`!0`R7HO^\*`'T`%`"'J*0=!:!!0`E`#-BLS$COZT##
MRD]/U-,`$2#H/UH`7RD]#^9H`/*3T/YF@`\I/0_F:`#RD]#^9H`/*3T/YF@`
M\I/0_F:`#RD]#^9H`/*3T/YF@`\I/0_F:`#RD]#^9H`/*3T/YF@`\I/0_F:`
M#RD]#^9H`/*3T/YF@`\I/0_F:`#RD]#^9H`/*3T/YF@`\I/0_F:`#RD]#^9H
M`/*3T/YF@`\I/0_F:`#RD]#^9H`/*3T/YF@`\M1R`?SI`&T4"%VB@!-H_P`F
M@`CC5HU)!Y'/-(!_D1D<J?S-%QAY$?H?^^C_`(T7`/(C]#^9HN`>1'_=/YFB
MX!Y$?]T_F:+@'D1_W3^9HN`>1'_=/YFBX!Y$?]T_F:+@'D1_W3^9HN`>1'Z'
M_OHT7`/(C]#_`-]'_&BX!Y$?H?\`OH_XT7`/(C]#_P!]'_&BX$<T**JD`_>`
MZFF@#RD]#^9I@24`(>HI!T%H$%`"4`,)PQY8?1<T`&[_`&F_[Y_^M0,-W^TW
M_?/_`-:F`;O]IO\`OG_ZU`!N_P!IO^^?_K4@#=_M-_WS_P#6I@&[_:;_`+Y_
M^M0`;O\`:;_OG_ZU`!N_VF_[Y_\`K4@#=_M-_P!\_P#UJ8!G_:;_`+Y_^M2`
M-W^TW_?/_P!:@`W?[3?]\_\`UJ`#=_M-_P!\_P#UJ`#=_M-_WS_]:@`W>[?]
M\_\`UJ`#=_M-_P!\_P#UJ`#=_M-_WS_]:@`W?[3?]\__`%J`#=_M-_WS_P#6
MI@&[_:;_`+Y_^M0`9_VF_P"^?_K4@#=[M_WS_P#6I@&[_:;_`+Y_^M2`-W^T
MW_?/_P!:@`S_`+3?]\__`%J`#/NW_?/_`-:@!<^Y_*@09]S^5`!GW/Y4`"-A
M`"6!`Z;?_K4@';Q_?;_OC_ZU`PWC^^W_`'Q_]:@!=X_OM_WQ_P#6H`3>/[[_
M`/?'_P!:@!=X_OM_WS_]:@!-X_OO_P!\?_6H`-_HS?\`?/\`]:@+AY@_OO\`
M]\?_`%J`#>/[[?\`?'_UJ`#>/[[?]\?_`%J`#S!_??\`[X_^M0`;Q_?;_OC_
M`.M0`>8/[[_]\'_"@!DS9`&YC\P_A_\`K4T`9_VF_P"^?_K4P)*`$/44@Z!0
M(6@`H`*`"@!*`%H`2@!:`$H`*`"@!:`"@!*`"@!:`"@`H`2@!:`"@`H`*`$H
M`*`%H`*`"@!#TH`*0@H`*`#O0,6F`4`)0`M`"4`%`"T`%`!0`4`%`!0`4`1R
M]%_WA0`^@!:8Q#U%(.@M`A*`%H`*`"@`H`2@!:`"@!*`"@`H`6@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`0]*`"D(*`"@`[T#"F`M`!0`E`!0`M`!
M0`E`"T`%`!0`4`%`#).@_P!X4`.H$+3*$/44@Z!0(*`%H`*`"@!*`"@!:`"@
M!*`"@!:`$H`*`%H`2@`H`6@`H`*`$H`6@`H`*`$H`*`%H`*`"@!#TH`*0@H`
M*`#O0`4QBT`%`"4`%`!0`M`!0`4`%`!0`4`%`$<O1?\`>%`#Z`%IC$/44@Z"
MT""@`H`*`$H`6@`H`2@!:`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@!
M*`%H`*`"@!*`#%`!B@`Q0`8YH&A<"F`8%`!@4`&!0`8%`!@46`,"@`P*`#`H
M`,"@`P*`#`H`,"@!"H(P10`FQ?3]:`'4`(>HI!T#/L:`L'X&@+!GV-`6#\Z`
ML'X&@+!GV-`6#\#0%@S[&@+!GV-`6#\#0%@S[&@+!^!H"P?@:`L&?8T!8/P-
M`6#/L:`L&?8T"L'X&@+!GV-`[!GV-`6#\#0%@S[&@+!^!H"P9]C0%@S[&@+!
M^!H"P9]C0%@S[&@+!^!H"P9]C0%@S[&@+!^!H"P9]C0%@'6@!:8!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
3`%`!0`4`%`!0`4`%`!0`4`#_V0%`
`





#End
