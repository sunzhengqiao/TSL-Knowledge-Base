#Version 7
#BeginDescription
Version 1.8   11.10.2004   th@hsb-systems.de
   - bugFix Dialog Stellbretthöhe berechnen
   - HINWEIS: die Option 'Stellbretthöhe berechnen' steht zum Zeitpunkt des Einfügens
     nur mit der Option 'in Stäbe konvertieren = Nein' zur Verfügung. Nach dem Einfügen
     kann die Option 'in Stäbe konvertieren'  in jeder Kombination verwendet werden.
Version 1.7   11.10.2004   th@hsb-systems.de
   - Übersetzung ergänzt
   - Stellbretter zwischen ungleich starken Sparren werden korrekt berechnet
Version 1.6   11.10.2004   th@hsb-systems.de
   - Einfügemodus 'Punkt' verbessert
Version 1.5   29.09.2004   th@hsb-systems.de
   - Hinweis bei fehlenden Bauteilen
Version 1.4   24.09.2004   th@hsb-systems.de
   - bugFix
Version 1.3   13.09.2004   th@hsb-systems.de
   - Übersetzung
Version 1.2   13.09.2004   th@hsb-systems.de
   - Option 'Stellbretthöhe berechnen' verfügbar
         ja: Änderung des Parameter Höhe nicht möglich
         nein: Änderung des Parameter Abstand nicht möglich
Version 1.1   30.07.2004   th@hsb-systems.de
   - Stellbretter können nun für die Übertragung zu CNC-Maschinen in hsbStäbe
     konvertiert werden. Dies kann zum Zeitpunkt des Einfügens oder zu einem
     beliebigen späteren Zeitpunkt erfolgen.
     Für die Konvertierung in hsbStäbe ist zusätzlich das hsbTSL STELLBRETT.MCR
     in der Zeichnung erforderlich
Version 1.0   29.07.2004   th@hsb-systems.de
   - erzeugt Stellbretter zwischen einem Auswahlsatz von Sparren
   - die Stellbretter können in Abhängigkeit von einer Wand, einer Polylinie,
     einer Pfette oder einem Punkt definiert werden

*********************
Blocking Distribution
   - creates blockings between a set of rafters
   - location may be dependent from wall, polyline, plate or a point
   - blocking height may be set by the user or calculated from parameters
   - uses slave tsl STELLBRETT.MCR if convert to beams is set to yes





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#MajorVersion 0
#MinorVersion 0
#KeyWords 
#BeginContents
// basics and props
	U(1,"mm");

	PropDouble dWidth(0,U(19),T("Thickness"));
	PropDouble dDepth(1,U(4),T("Depth of groove"));
	PropDouble dGapAtSide(2,U(1),T("Gap at side"));
	PropDouble dGapLength(3,U(1),T("Gap in length"));
	PropDouble dOffset(4,U(0),T("Offset"));
	PropDouble dTrauf(5,U(0),T("Thickness") + " " + T("Traufschalung"));
	PropDouble dBlockingHeight(6, U(190), T("Height of Blocking"));

	String sArMode[] = {T("Wall or Polyline"), T("Plate"), T("Point")};
	PropString sMode(0,sArMode,T("Mode"),1);
	String sArNY[] = {T("No"), T("Yes")};
	PropString sCalcBlocking(10,sArNY,T("Calculate height of blocking"),1);
	String sArOrient[] = { T("Perpendicular to RCS"), T("Perpendicular to WCS")};//, T("Angle")};
	//PropDouble dAngle(7, U(90), T("Angle") + T("(only for Orientation = Angle"));
	PropString sOrient(1,sArOrient,T("Orientation")); 
	PropString sToBeams(2,sArNY,T("Convert to beams"));

	PropString sName(3,T("Stellbrett"),T("Name"));
	PropString sMat(4,T("Dreischicht"),T("Material"));
	PropString sGrade(5,T("BC"),T("Grade"));
	PropString sInfo(6,T(""),T("Information"));
	PropString sLabel(7,T(""),T("Label"));
	PropString sSublabel(8,T(""),T("Sublabel"));
	PropString sSublabel2(9,T(""),T("Sublabel2"));

	PropInt nColor(0, 170, T("Color"));

	//setExecutionLoops(2);

//on insert
	if(_bOnInsert) {
		showDialog();
		int n;
		for (int i = 0 ; i < sArMode.length(); i++)
			if (sMode == sArMode[i])
				n = i;
		_Entity.append(getERoofPlane(T("select roofplane")));
		
		String sMsgTxt;
		sMsgTxt = "\n" + T("select rafter(s)");	
		while (1) {//
   		PrEntity ssE(sMsgTxt,Beam());
    		if (ssE.go()==_kOk) {
				Entity ents[0]; 
				ents = ssE.set();
				for (int i=0; i<ents.length(); i++)
					_Beam.append( (Beam)ents[i]);´
    		}
    		else // no proper selection
    			break; // out of infinite while
    	}
	

	//Wall or Polyline
		if (n==0) {							
			int nDone = FALSE;
			while (!nDone) {//
				sMsgTxt = "\n" + T("select wall  or polyline");	
   				PrEntity ssE(sMsgTxt,Entity());
    			if (ssE.go()==_kOk) {
					Entity ents[0]; 
					ents = ssE.set();
					for (int i=0; i<ents.length(); i++) {
						if (ents[i].typeName()  == "AcDbPolyline"){
							Point3d pGrips[0];
							PLine pl0;
							pGrips = ents[i].gripPoints();
							for (int j=0;j<pGrips.length();j++)
								pl0.addVertex(pGrips[j]);
							pl0.close();	
							_Map.setPLine("insertPoly", pl0, _kRelative);
							nDone=TRUE;}
						else if (ents[i].typeName()  == "AecDbWall"){
							_Element.append( (Element)ents[i]);
							nDone=TRUE;}
					}
    			}
    			else // no proper selection
    				break; // out of infinite while
			}
		}

	//Point
		else if (n==2) {						
			_Pt0 = getPoint();
		}

	//Plate
		if (n==1) {							
			Beam bmPlate;
			bmPlate = getBeam(T("select plate"));
			_Map.setEntity("insertPlate", bmPlate);
			_Beam.append(bmPlate);
		}
		_Map.setInt("insertMode", n);
		return;
	}
// END _bOnInsert____________________________________________________________________________________________________________________


// check for valid color
	if (nColor > 255 || nColor < 0) nColor.set(170);

//collect roofplane
	if (_Entity.length()==0 || _Beam.length() <= 0){
		Display dpErr(14);
		dpErr.textHeight(U(20));
		dpErr.draw(scriptName() + ": " + T("Missing link"),_Pt0, _XW, _YW, 0,0,_kDeviceX);
		return;
	}

	ERoofPlane roofpl;
	CoordSys csRoof;

	for (int i = 0; i < _Entity.length(); i++)
		roofpl = (ERoofPlane)_Entity[i];	
		if (roofpl.bIsValid()){
			csRoof = roofpl.coordSys();
			csRoof.vis(8);
		}

	if (!roofpl.bIsValid()) return;
	Vector3d vx,vy,vz;
	Point3d p0 = csRoof.ptOrg();
	vx = csRoof.vecX();
	vy = csRoof.vecY();
	vz = csRoof.vecZ();

// create a plane on the bottom surface of the roof
	PLine plRoof = roofpl.plEnvelope();
	Point3d pRoof[] = plRoof.vertexPoints(TRUE); 
	Plane pnRoof(pRoof[0],vz);
	pnRoof.transformBy(-vz * _Beam[0].dD(vz));

// mode can not be changed after insertion
	int nMode = _Map.getInt("insertMode");
	int n;
	for (int i = 0 ; i < sArMode.length(); i++)
		if (sMode == sArMode[i])
			n = i;
	if (nMode != n ){
		if(n != 2){
			reportNotice("\n\n" + scriptName() + ": " + T("after insertion the mode can only be changed to ") + sArMode[2]);
			sMode.set(sArMode[nMode]);
		}
		else
			nMode = n;
	}

// get insertion point
	Vector3d vxx;
	vxx = _ZW.crossProduct(vx);
	vxx.vis(p0,3);

	//Wall or Polyline
		if (nMode == 0) {
			PLine pl0;
			if (_Element.length() > 0){
				pl0 = _Element[0].plOutlineWall();
			}
			else
				if (_Map.hasPLine("insertPoly")){
					pl0 = _Map.getPLine("insertPoly");
				}
				else{
					reportMessage("No valid object found for mode");
					return;
				}
			pl0.vis(1);	
		// from the pline get the outmost point
			
			pl0.projectPointsToPlane(pnRoof, _ZW);
			Point3d pPl[] = pl0.vertexPoints(TRUE);

			pPl = Line(p0,vxx).orderPoints(pPl);
			
			_Pt0 = pPl[0];
		}
	//Plate
		else if (nMode == 1) {
			Beam bmPlate;
			if (_Map.hasEntity("insertPlate")){
				Entity ent = _Map.getEntity("insertPlate");
				bmPlate = (Beam)ent;
			}
			if (!bmPlate.bIsValid()){
				reportMessage("No valid object found for mode");
				return;
			}
			_Pt0 = bmPlate.ptCen() - vxx * 0.5 * bmPlate.dD(vxx) + _ZW * 0.5 * bmPlate.dD(_ZW);
		}
	//Point
		else if (nMode == 2) {
			Line lnZ(_Pt0,_ZW);
			//_Pt0 = lnZ.intersect(pnRoof,0);//_Pt0.projectPoint(pnRoof,0);
		}


// get roofangle
	double dRoofAngle = vxx.angleTo(vy);
	double dOffsetInRoof = dOffset/cos(dRoofAngle);
	if ( sMode == sArMode[2]) dOffsetInRoof =0;

// calculate height to roofplane
	double dRepositionOffset;

	double dHeight = abs(vz.dotProduct((_Pt0 + vxx * dOffset) - p0)) - dTrauf;

	//Perpendicular to WCS
	if (sOrient == sArOrient[1]){
		if ( sMode != sArMode[2]){// only for non point modes
			Point3d pHeight;
			pHeight = Line(_Pt0 + vxx * dOffset,_ZW).intersect(pnRoof, _Beam[0].dD(vz) - dTrauf);
			pHeight.vis(2);
			dHeight = abs(_ZW.dotProduct((_Pt0 + vxx * dOffset) - pHeight));
		}
		// get reposition offset if blocking height is given by the user
		if (sCalcBlocking == sArNY[1]){// dBlockingHeight > 0 && _kNameLastChangedProp == T("Height of Blocking")) {
			double a1 = dHeight;
			double a2 = dBlockingHeight;
			double b1 = a1/ tan(dRoofAngle);
			double b2 = (b1 * a2)/ a1;
			dRepositionOffset = b1 - b2;
			dHeight = dBlockingHeight;
			//dOffset.set(-dRepositionOffset);
		}
		else
			dBlockingHeight.set(dHeight);
			
	}
	//Perpendicular to RCS
	else{
		//calculate blocking height
		Point3d pRefRp;// horizontal projected to bottom roofplane
		pRefRp = Line(_Pt0, vxx).intersect(pnRoof, _Beam[0].dD(vz) -dTrauf - dBlockingHeight);
		pRefRp.vis(2);
	
		if (sCalcBlocking == sArNY[1]){ //( dBlockingHeight !=0){
			dHeight = abs(vz.dotProduct((_Pt0 + vxx * dOffset) - p0)) - dTrauf;
			dBlockingHeight.set(dHeight);
			
			if (_bOnDebug) reportMessage("\n" +"offset: " + dOffset + "\nheight: " + dHeight);	
		}
		
		else{
			// take user's blocking height
			dOffset.set(vxx.dotProduct(pRefRp - _Pt0));
			if (_bOnDebug) reportMessage("\n" +"blockingheight: " + dBlockingHeight);

		}
	}

// stop execution if given values are invalid
	String sMsgTxt;	
	if ( dHeight<=0)
		sMsgTxt = T("Offset") + " " + T("invalid, check properties");
	if ( dBlockingHeight<=0 && sCalcBlocking == sArNY[0]){
		if (sMsgTxt !="")
			sMsgTxt = sMsgTxt + "\n";
		sMsgTxt = sMsgTxt + T("Height of Blocking") + " " + T("invalid, check properties");
	}

	if (sMsgTxt != ""){
		reportNotice("\n" + scriptName() + ":\n" + sMsgTxt);
		Display dp(1);
		dp.textHeight(U(10));
		dp.draw(scriptName() + " " + sMsgTxt,_Pt0, _XW, _YW,0,0,_kDeviceX);
		return;
	}


// declare reference point for insertion
	Point3d pRefIns = _Pt0 + vy * dOffsetInRoof;
	pRefIns.vis(3);

//collect and sort Beams
	Beam bmRoof[0];
	for (int i = 0; i < _Beam.length(); i++) {
		LineBeamIntersect lbi(pRefIns ,vx,_Beam[i]);
		if (lbi.bHasContact() && lbi.nNumPoints() > 0){
			bmRoof.append(_Beam[i]);
			//_Beam[i].realBody().vis(3);
		} // end if
	}
	if (bmRoof.length() <=0){
		Display dpErr(12);
		dpErr.textHeight(U(10));
		dpErr.draw(scriptName() + " " + T("no interscting rafters found"),_Pt0, _XW, _YW,0,0,_kDeviceX);
		return;    
	}
	//reportMessage("\nbefore" + bmRoof.length());

//collect all ref points of valid beams
	Point3d pRef[0];
	Plane pnRef(_Pt0, vxx);
	
	for (int i = 0; i < bmRoof.length(); i++) {
		double dProject = bmRoof[i].vecD(vz).dotProduct(p0-bmRoof[i].ptCen());
		Point3d pInter = Line(bmRoof[i].ptCen() , bmRoof[i].vecX()).intersect(pnRef,dOffset );//- dProject * bmRoof[i].vecD(vz)
		pInter = pInter - _ZW * _ZW.dotProduct(pInter - _Pt0);
		pRef.append(pInter);
		pRef[pRef.length()-1].vis(i);
	}		



// now sort them
	Beam bmTmp;
	Point3d pTmp;
	for (int i=0; i<bmRoof.length(); i++) {
		for (int j=0; j<bmRoof.length()-1; j++) {
			double dDist0 = vx.dotProduct(_Pt0 - pRef[j]);
			double dDist1 = vx.dotProduct(_Pt0 - pRef[j+1]);
			if (dDist0  < dDist1 ) {
				bmTmp = bmRoof[j+1];
				pTmp=pRef[j+1];
				bmRoof[j+1] = bmRoof[j];
				pRef[j+1]=pRef[j];
				bmRoof[j] = bmTmp;
				pRef[j]=pTmp;
			}
  	 	}
	}

	//reportMessage("\n" + bmRoof.length());
	for (int i = 0; i < bmRoof.length(); i++) pRef[i].vis(i);	


// set transformation matrix
	CoordSys cs;
	if (sOrient == sArOrient[1])
		cs.setToRotation(-_ZW.angleTo(vz),vx, pRef[0]);//pRefIns - vxx * dRepositionOffset );
	CoordSys csTrans;
	//if (dBlockingHeight > 0)
	if (sCalcBlocking == sArNY[0]){
		csTrans.setToTranslation(-vxx * dRepositionOffset);	
		
	}

// now vis it
	for (int i=0; i<bmRoof.length()-1; i++) {
		Point3d pIns = (pRef[i] + bmRoof[i].dD(vx) * 0.5 * vx + pRef[i+1] - bmRoof[i+1].dD(vx) * 0.5 * vx )/2  ;//- vxx * dRepositionOffset
		pIns.vis(1);
		//continue if rafters intersect or touching
		if (vx.dotProduct(pIns - pRef[i]) <= bmRoof[i].dD(vx) * 0.5)
			continue;

		double dLength = Vector3d(pRef[i] - pRef[i+1]).length() - (bmRoof[i].dD(vx) + bmRoof[i+1].dD(vx)) * 0.5 + 2 * dDepth;
		if ( sToBeams == sArNY[0]) {
			Body mpbd(pIns, vx, vz, vy, dLength, dHeight, dWidth,0,1,1);
			mpbd.transformBy(cs);
			mpbd.transformBy(csTrans);
			BeamCut bc0(pIns, vx, vz, vy, dLength + dGapLength * 2, dHeight*10, dWidth + dGapAtSide,0,0,1);
			bc0.transformBy(cs);
			bc0.transformBy(csTrans);
			bmRoof[i].addTool(bc0);
			bmRoof[i+1].addTool(bc0);
			Display dpBd(nColor);
			dpBd.draw(mpbd);
		}
		else{
			//generate the blocking
			Beam bmBlock;
			bmBlock.dbCreate(pIns, vx, vz, vy, dLength, dHeight, dWidth,0,1,1);
			bmBlock.setName(sName);
			bmBlock.setInformation(sInfo);
			bmBlock.setGrade(sGrade);
			bmBlock.setMaterial(sMat);
			bmBlock.setLabel(sLabel);
			bmBlock.setSubLabel(sSublabel);
			bmBlock.setSubLabel2(sSublabel2);
			bmBlock.setColor(nColor);

			String strScriptName = "Stellbrett"; // name of the script
			Vector3d vecUcsX = vx;
			Vector3d vecUcsY = vy;
			Beam lstBeams[0];
			Element lstElements[0];
			Point3d lstPoints[0];
			int lstPropInt[0];
			double lstPropDouble[0];
			String lstPropString[0];

			lstBeams.append(bmRoof[i]); // will become _Beam0
			lstBeams.append(bmRoof[i+1]); // will become _Beam1
			lstBeams.append(bmBlock); // will become _Beam1
			lstPoints.append(pIns); 

			lstPropDouble.append(dWidth);
			lstPropDouble.append(dDepth);
			lstPropDouble.append(dGapAtSide);
			lstPropDouble.append(dGapLength);
			lstPropDouble.append(dHeight);

			lstPropString.append(sOrient);

			lstPropInt.append(nColor);

			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, 
				lstPropInt, lstPropDouble, lstPropString ); // create new instance

	     	Map mapTSL;
	     	mapTSL.setEntity("ER",roofpl);
          tsl.setMap(mapTSL); // transfer the map to the newly created one
	    	tsl.setPtOrg(pIns);
		}

	}

//delete the global tsl
	if ( sToBeams == sArNY[1]) eraseInstance();








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
M"`&3`6@#`1$``A$!`Q$!_]H`#`,!``(1`Q$`/P"VK!AD4`.H`*`"@`H`*`"@
M`H`*`(98L_,O7TI-#3(:DH*``&@!:`$H``?6@!>E`"$4`%`"4`312X^5NG8U
M28FB>F2%`!0`4`%`!0`4`%`",H88-`%9T*'!Z=C4EH81BD`4`)0`X'(H`*`%
M_G0`E`"$4`%`#D<H<CIW%,3+*L&&15$CJ`"@`H`J(Q0Y'XBI*+2D,`1WJB1:
M`"@`H`*`"@`H`*`"@""6/G<OXU+129%2&)0`4`+0`&@`!H`6@!*`$H`,4P)X
MI<_*W7L::9+1-3$%`!0`4`%`!0`4`%`#70.,'\Z`3*S*5.&J"QIH`*`"@8[J
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
*_N-]*`*U``#_V04`
`







#End
