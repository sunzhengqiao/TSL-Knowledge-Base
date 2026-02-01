#Version 8
#BeginDescription
/// Version 1.5   21.02.09   th@hsbCAD.de
/// new property to highlight the element contour











#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This Tsl creates Symbol to visualize the active element in 
/// a mini domain
/// </summary>

/// <insert Lang=en>
/// Select the viewport where you want to display the symbol
/// </insert>

/// <property name="max. Length" Lang=en>
/// Shows a warning if the element length exceeds the value given 
///</ property >

/// <property name="Check wall number" Lang=en>
/// Shows a warning if the element name does not have a least 3 characters 
///</ property >

/// <property name="Highlight Element" Lang=en>
/// This Tsl shows a scalable arrow as default display. If this option is enabled
/// it will also show the outline of the current element.
///</ property >

/// <version  value=”1.5” date=”21february09”></version>

/// History
/// Version 1.5   23.02.09   th@hsbCAD.de
/// new property to highlight the element contour
/// Version 1.4   17.05.08   th@hsbCAD.de
///    - translation
/// Version 1.3   18.07.07   th@hsbCAD.de
///    - Prüfung der Maximallänge verbessert
///    - check on max element length enhanced
/// Version 1.2   31.01.05   th@hsb-systems.de
///    - Anwendung nun auch bei Dachelementen möglich
///    - Dachelemente und Multiwände werden durch ein
///      skalierbares Dreieck im Ursprung markiert
/// 
///    - now also applicable for roofelements and
///      multiwalls
///    - roofelements and multiwalls will be marked
///      by a triangle in the elments origin
///    - language independent version
/// 
/// Version 1.1   23.06.04   th@hsb-systems.de
///    - Anwendung bei Multiwänden führt nicht zu Fehlermeldung
/// 
/// Version 1.0   03.12.03   Author TH
///    - erzeugt skalierbaren Ansichtspfeil für Minidomain
/// 
///    - creates Symbol to visualize the active element in 
///      a mini domain


Unit(1,"mm"); // script uses mm

// props
	PropDouble d0 (0, 2, T("|Scale|"));
	String sArNY[] = {T("|No|"), T("|Yes|")};
	PropDouble d1 (1, 0, T("|max. Length|"));
	PropString s0(0,sArNY,T("|Check wall number|"),0);
	PropString sHighlightElement(1,sArNY,T("|Highlight Element|"));
	
// on insert
	if (_bOnInsert) {
  		showDialog();
  		Viewport vp = getViewport(T("|Select a viewport|")); // select viewport
  	 	_Pt0 = vp.ptCenPS(); // select point
  		_Viewport.append(vp);
  		return;
	}

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(4));

// ints
	int nHighlight = sArNY.find(sHighlightElement,0);


// do something for the last appended viewport only
	if (_Viewport.length()==0) return; // _Viewport array has some elements
	Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
	_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
	if (!vp.element().bIsValid()) return;

// cordsys
	CoordSys ms2ps = vp.coordSys();
	CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps

// declare standards
	Element el = vp.element();
	int nZoneIndex = vp.activeZoneIndex();
	CoordSys cs = el.coordSys();
	Vector3d  vx = cs.vecX();
	Vector3d  vy = cs.vecY();
	Vector3d  vz = cs.vecZ();
	Point3d pX = cs.ptOrg();

// declare PS standards
	Vector3d vxps = vx;
	vxps.transformBy(ms2ps);
	Vector3d vyps = vy;
	vyps.transformBy(ms2ps);
	Vector3d vzps = vz;
	vzps.transformBy(ms2ps);

	pX.transformBy(ms2ps);

// Display
	Display dp(0); 
	dp.color(1);
	//dp.draw(scriptName(),_Pt0,_XW, _YW,0,0);
	PLine plA(_ZW);

// detect element type
	ElementWall elWall = (ElementWall) el;
	// wall elemenet
	if (elWall.bIsValid()) { 
		Point3d pOl[] = el.plOutlineWall().vertexPoints(TRUE);
		if (pOl.length() <= 0) return;
			double  dElLength = (pOl[0] - pOl[1]).length();
		
			pX = pX + vxps * 0.5 * dElLength;
			plA.addVertex(pX + vxps * U(50) * d0 + vzps * d0 * U(100));
			plA.addVertex(pX);
			plA.addVertex(pX - vxps * U(50) * d0 + vzps * d0 * U(100));
			plA.addVertex(pX - vxps * U(5) * d0 + vzps * d0 * U(100));
			plA.addVertex(pX - vxps * U(5)* d0 + vzps * d0 * U(200));
			plA.addVertex(pX + vxps * U(5)* d0 + vzps * d0 * U(200));
			plA.addVertex(pX + vxps * U(5)* d0 + vzps * d0 * U(100));
			plA.addVertex(pX + vxps * U(50)* d0 + vzps * d0 * U(100));

			dp.draw(plA);

			if (d1 > 0) {
				LineSeg lsMinMax = el.segmentMinMax();
				double dElL = abs(vx.dotProduct( lsMinMax.ptStart()-lsMinMax.ptEnd()));
				if ( dElL > d1)
				reportNotice("\n\n" + T("NOTE") + " ********************************\n" 
					+ "Element" + " " + el.number() + " " + 
					T("does not match max. length conventions") + ".\n" + 
					T("An element length of") + "\n           " + dElL + "\n" +  
					T("exceeds the maximal length of") + " " + d1);
			}
			if ( s0 == sArNY[1] && el.number().length() <= 2) {
				reportNotice("\n\n" + T("NOTE") + "! " + "Element" + " " + el.number() + " " + 
				T("does not match name conventions") + ".\n" + 
				T("Please check element number") + "!");
			}
			
			if(nHighlight)
			{
          	PLine plWall(el.plOutlineWall());
          	plWall.transformBy(ms2ps);
          	dp.draw(plWall);
			}
			
			
	} // end wallelement
	else{
		double dAngle;
		dAngle = 90 - vy.angleTo(_ZW);
		plA.addVertex(pX);
		plA.addVertex(pX + vxps * U(200) * d0);
		plA.addVertex(pX + vyps * U(200) * d0);
		plA.close();
		CoordSys csRot;
		csRot.setToRotation(-dAngle, vxps, pX);
		plA.transformBy(csRot);
		//if (_bOnDebug) plA.transformBy(_ZW * U(100));
		PlaneProfile ppA(plA);
		dp.draw(ppA,_kDrawFilled);
		
		if(nHighlight)
		{
          PLine pl(el.plEnvelope());
          pl.transformBy(ms2ps);
          dp.draw(pl);
		}		
	}
	
	if (_bOnDebug){
		for (int k = 0; k < 2; k++){
			Display dpDebug(-1);
			Beam bmDebug[0];
			bmDebug = el.beam();
			Sheet shDebug[0];
			shDebug = el.sheet(-1);

			dpDebug.color(40+k);
			for (int i = 0; i < shDebug .length(); i++){
				Body bdDebug = shDebug [i].realBody();
				bdDebug.transformBy(ms2ps);
				dpDebug.draw(bdDebug);
			}
			dpDebug.color(32);
			for (int i = 0; i < bmDebug .length(); i++) {
				Body bdDebug = bmDebug [i].realBody();
				bdDebug.transformBy(ms2ps);
				dpDebug.draw(bdDebug);
			}
		}
	}






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
M"`&3`6@#`1$``A$!`Q$!_]H`#`,!``(1`Q$`/P"E0`4`%`!0`4`%`!0`4`%`
M!0`4`%`#XO\`6"E+8:W'S?<_&ICN5+8AJR`H`DA^\?I4RV*B+-T7\:40D159
M(4`%`!0`4`66Z-]#62-&5JU,PH`*`"@`H`L1_P"K6LWN6MB%_OM]:M;$O<;3
M$%`!0`4`2P]&_"HD5$2;[P^E..P2(ZHD*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`'Q?ZP4I;#6X^;[GXU,=RI;$-60%`$D/WC]*F6Q419NB_
MC2B$B*K)"@`H`*`"@"RW1OH:R1HRM6IF%`!0`4`%`%B/_5K6;W+6Q"_WV^M6
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
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
F`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*``_]D"
`




#End
