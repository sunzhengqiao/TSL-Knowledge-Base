#Version 8
#BeginDescription
version  value="2.4" date="20apr14" author="th"
text alignment adjusted on creation 

///    - berechnet die Länge einer Dachkante und beschreibt diese
///    - kann über das TSL hsbRP_Analysis automatisch eingefügt werden
///    - calculates the length of an edge of a roofplane
///    - autoinsert can be done by the tsl hsbRP_Analysis












#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 4
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// calculates the length of an edge of a roofplane
/// autoinsert can be done by the tsl hsbRP_Analysis
/// </summary>

/// <summary Lang=de>
/// berechnet die Länge einer Dachkante und beschreibt diese
/// kann über das TSL hsbRP_Analysis automatisch eingefügt werden
/// </summary>

/// History
///<version  value="2.4" date="20apr14" author="th"> text alignment adjusted on creation </version>
/// Version 2.3   03.02.2011   th@hsbCAD de
/// language independency added
/// Version 2.2   04.11.2010   th@hsbCAD de
/// DE  bugfix
/// EN  new predefined type 'wall connection'
/// Version 2.0   06.09.2007   th@hsbCAD de
/// DE  neuer vordefinierter Type 'Wandanschluß'
/// EN  new predefined type 'wall connection'
/// Version 1.9   25.05.2007   th@hsbCAD de
/// DE  Ausgabefeld Gruppe' ergänzt
/// EN  field 'Group'added
/// Version 1.8   27.03.2007   th@hsbCAD de
/// DE  Ausgabefeld 'Name' ergänzt
/// EN  field 'Name' added
/// Version 1.7   23.03.2007   th@hsbCAD de
///    - bugFix
/// Version 1.6   20.03.2007   th@hsbCAD de
/// DE  neue vordefinierte Typen
///    - neuer Kontextbefehl, um die Beschriftungsseite zu wechseln
/// EN  new predefined types
///    - new context command to swap side of text display
/// Version 1.5   20.02.2007   th@hsbCAD de
/// DE automatische Erkennung von Kehl/Gratsparren
///   zur Einzelteilzeichnung-Erzeugung ergänzt
///    - Datenübergabe Winkel Kehl/Grat
///    - 
/// Version 1.4   04.12.2006   th@hsbCAD de
/// DE Erläuterung zur Gruppentrennung korrigiert - es wird nur ein einfacher
///      Backslash benötigt um die Ebenen zu trennen
/// EN Explanation for grouping structure corrected - you need only to enter 
///      a single backslash to seperate the levels
/// Version 1.3   06.07.2006   th@hsbCAD de
/// DE Typeüberschreibung ergänzt
/// EN Type overwriting added
/// Version 1.2   04.07.2006   th@hsbCAD de
/// DE Excel Export wird unterstützt
///    - Beschreibungstext kann über Griff verschoben werden
/// EN supports excel BOM
///    - text can be moved via grip
/// Version 1.1   11.05.2006   th@hsbCAD de
/// DE  Daten für Listenzusammenfassung veröffentlicht (hsbRP_BOM)
///     - Gruppenzuordnung ergänzt
/// EN  data published for BOM  (hsbRP_BOM)
///    - group assignment added
/// Version 1.0   28.04.2005   th@hsbCAD de
///    - berechnet die Länge einer Dachkante und beschreibt diese
///    - Datenausgabe optional zusätzlich in MS Excel (benötigt hsbExcel.dvb)
///    - kann über das TSL hsbRP_Analysis automatisch eingefügt werden
/// 
///    - calculates the length of an edge of a roofplane
///    - data evaluation optional to MS Excel possible (requires hsbExcel.dvb)
///    - autoinsert can be done by the tsl hsbRP_Analysis


// basics and props
	U(1,"mm");
	double dEps=U(.1);
	String sArNY[] = { T("No"), T("Yes")};
	String sArType[] = {T("|Eave|"), T("|Gable End|"), T("|Hip|"), T("|Valley|"), T("|Ridge|"), T("|Rising Eave|"), 
		T("Verfallgrat"),T("|Opening top|"),T("|Opening bottom|"),T("|Opening left|"),T("|Opening right|"),
		T("|Opening left sloped|"),T("|Opening right sloped|"),T("|Wall connection|")};
	String sPropStringName0 = T("|Type|");
	PropString sType(1,sArType,sPropStringName0);
	PropString sOverwriteType(4,"",T("|Type overwriting|"));
	String sArUnit[] = {"mm", "cm", "m", "inch", "feet"};
	PropString sUnit(2,sArUnit,T("|Unit|"));
	int nArDecimals[] = {0,1,2,3,4};
	PropInt nDecimals(0,nArDecimals,T("|Decimals|"));		
	PropString sGroup(3,"",T("|Group|") + " (" + T("|seperate Level by|") +"'\\')");		
	PropString sShowPos(5, sArNY, T("|Show PosNum|"));
	PropString sDimStyle(0,_DimStyles,T("|Dimstyle|"));	
	
// on insert
	if (_bOnInsert){
		showDialog();
		//get roofelement sset	
		PrEntity ssRP(T("|Select roofplanes|"), ERoofPlane());
		ERoofPlane er0[0];
  		if (ssRP.go()){
			Entity ents[0];
    		ents = ssRP.set();
			for (int i = 0; i < ents.length(); i++)
				// store as entity in global map
				_Map.setEntity("er" + i, ents[i]);
		}			
		_Pt0 = getPoint(T("|Select Startpoint|"));	
		_PtG.append(getPoint(T("|Select Endpoint|")));	
		return;
	}
	
// make sure we have got a grip
	if (_PtG.length()<1 || Vector3d(_Pt0-_PtG[0]).length()<dEps)
	{
		eraseInstance();
		return;	
	}	

// type overwrite
	if (sOverwriteType!="")
		sType.set(sOverwriteType);	

// remove type overwriteing
	if (_kNameLastChangedProp == sPropStringName0)
		sOverwriteType.set("");
			
// add triggers
	String sTrigger[0];
	sTrigger  = sArType;
	sTrigger.append("---");
	sTrigger.append(T("|Swap description side|"));
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);


// trigger:
	for (int i = 0; i < sTrigger.length()-2; i++)
		if (_bOnRecalc && _kExecuteKey==sTrigger[i]) 
		{
			sType.set(sTrigger[i]);
			sOverwriteType.set("");
		}



//Type
	int nType = sArType.find(sType);
		
// swap description side
	int nSwapSide = 1;	
	if (_Map.hasInt("swapDesc"))	nSwapSide = _Map.getInt("swapDesc");


// trigger swap text side
	if(_kExecuteKey==sTrigger[sTrigger.length()-1]) 
	{
		if (_Map.hasInt("swapDesc"))
			nSwapSide = _Map.getInt("swapDesc");
		nSwapSide *= -1;
		_Map.setInt("swapDesc",nSwapSide);
	}
// Group
	if (sGroup != "")
	{
		Group grRL();
		grRL.setName(sGroup);
		grRL.addEntity(_ThisInst, TRUE);
	}
				
// find valid roofplane
	ERoofPlane erps[0];
	for (int i = 0; i < _Map.length(); i++)
	{
		if (_Map.hasEntity("er" + i)) 
		{
			Entity ent;
			ent =  _Map.getEntity("er" + i);
			ERoofPlane erp = (ERoofPlane)ent;
			//erp.plEnvelope().vis(i);
			if (erp.bIsValid())	erps.append(erp);
		}
	}
	
	for (int i = 0; i < erps.length(); i++){	
		if(!erps[i].bIsValid()){
			eraseInstance();
			return;
		}
		else
			setDependencyOnEntity(erps[i]);
	}



			
//Display
	Display dp(nType);
	dp.dimStyle(sDimStyle);
	
	// Pline or Tube
	//PLine pl(_Pt0, _PtG[0]);
	Body bd(_Pt0, _PtG[0], U(0.5));
	dp.draw(bd);
	
	//Length
	double dLength = Vector3d(_Pt0 - _PtG[0]).length();
	String sLength;
	sLength.formatUnit(dLength / U(1,sUnit,2),2,nDecimals);
	
	// Location & Direction
	if (_PtG.length() < 2)
		_PtG.append((_Pt0 + _PtG[0])/2);
	Point3d ptMid = (_Pt0 + _PtG[0])/2;
	if (_PtG.length() > 1)
		ptMid = _PtG[1];
	
	
	// if pointing downwards swap
	if (_ZW.dotProduct(_PtG[0] - _Pt0)<0)
	{
		Point3d pt0 = _Pt0,ptG0 = _PtG[0];
		_PtG[0] = pt0;
		_Pt0 = ptG0;	
	}
	
	Vector3d vx = _PtG[0] - _Pt0;
	vx.normalize();
	Vector3d vy = _ZW.crossProduct(vx);								vy.vis(_Pt0,3);	
	Vector3d vz = vx.crossProduct(vy);								vz.vis(_Pt0,150);	
	Vector3d vxN = vx.crossProduct(_ZW).crossProduct(-_ZW);		vxN.vis(_Pt0,6);


// on creation swap valley descriptions
	if (_bOnDbCreated && erps.length()>0)
	{
		PlaneProfile pp1 (erps[0].plEnvelope());
		
		if (pp1.pointInProfile(ptMid+vy*U(1))!=_kPointInProfile)
		{
			nSwapSide*=-1;
			_Map.setInt("swapDesc",nSwapSide);
			setExecutionLoops(2);
			return;
		}
	}


// collect hip/valleys if applicable from roofplanes
	Beam bm[0];
	for (int i = 0; i < erps.length(); i++)
	{
		// cast to toolEntity
		ToolEnt tent = (ToolEnt)erps[i];
		bm = tent.beam();	
		for (int b = 0; b < bm.length(); b++)
			if (bm[b].vecX().isParallelTo(vx) && bd.intersectWith(bm[b].realBody()))
				_Beam.append(bm[b]);
	}



// angle calculations
	String sAngle,sAngleHip;
	double dAngle,dAngleHip;
	if (nType ==  2 || nType == 3)
	{
	// hip/valley angle
		Vector3d vxAngle[0];
		for (int i = 0; i < erps.length();i++)
		{
			Vector3d  vzAngle;
			vzAngle = erps[i].coordSys().vecZ();						//vzAngle.vis(_Pt0,i);
			vxAngle.append(vx);
			double dRot = 90;
			if (vzAngle.dotProduct(vy)< 0)
				dRot *= -1;
			vxAngle[i] = vxAngle[i].rotateBy(dRot,vzAngle);		vxAngle[i].vis(_Pt0,i);		
		}
		if (vxAngle.length() > 1)
		{
			dAngleHip = vxAngle[0].angleTo(vxAngle[1]);
			sAngleHip.formatUnit(dAngleHip,2,1);
		}	
		
	// base angle
		if (nType ==  2 || nType == 3)
		{
			dAngle = vx.angleTo(vxN);
			sAngle.formatUnit(dAngle,2,1);
			sAngle = ", " + sAngle + "°";
		}	
	}	
// end angle calculation


// Text
	if (sShowPos == sArNY[1])
		dp.draw(_ThisInst.posnum() + ": " + sType + " " + sLength + sUnit + sAngle, ptMid, vx, vy, 0, nSwapSide  * 4, _kDevice);
	else
		dp.draw(sType + " " + sLength + sUnit+ sAngle, ptMid, vx, vy, 0, nSwapSide * 4,_kDevice);

// output
	exportToDxi(TRUE);
	setCompareKey(String(_ThisInst.posnum()) + sType + String(dLength));
	dxaout("Type", sType);	
	dxaout("Name", sType);			
	dxaout("Length", dLength / U(1,"mm"));
	dxaout("Info", sType);	
	dxaout("Group", sGroup);
		
	Map mapSub;
	mapSub.setString("Name", sType);
	mapSub.setDouble("Length", dLength);
	mapSub.setDouble("Angle", dAngle);
	mapSub.setDouble("AngleHip", dAngleHip);	
	
	if (_Beam.length() > 0)
		mapSub.setInt("BeamPosnum", _Beam[0].posnum());

	if (erps.length() > 0)	
		mapSub.setString("Info", erps[0].handle());
	if (erps.length() > 1)
		mapSub.setString("Label", erps[1].handle());
	_Map.setMap("TSLBOM", mapSub);
	
		
	if (erps.length() > 0)
		dxaout("hsbRooflineRoof0", erps[0].handle());

	if (erps.length() > 1)
		dxaout("hsbRooflineRoof1", erps[1].handle());	

	String sCompare;
	sCompare = sType + " " + sLength + sUnit+ sAngle + _Beam.length();
	setCompareKey(sCompare);














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
M"`$R`98#`1$``A$!`Q$!_]H`#`,!``(1`Q$`/P">@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@!"<4F[";MN-#<\U"GKJ9JIKJ/K0U"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`0G%)NPF[;C"<UBW<PE*X8XK
M3V=E=D7%5L?2IC*QI&5M&/K4W"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
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
"_]D"
`












#End