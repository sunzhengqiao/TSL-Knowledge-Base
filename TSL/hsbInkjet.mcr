#Version 8
#BeginDescription
version value="1.3" date="30apr18" author="thorsten.huck@hsbcad.com"
element insertion and format variables supported
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Dieses TSL beschriftet einen Stab
/// </summary>


/// History
///<version value="1.3" date="30apr18" author="thorsten.huck@hsbcad.com"> element insertion and format variables supported </version>
///<version value="1.2" date="10apr18" author="thorsten.huck@hsbcad.com"> maximum allowed text length validated </version>
///<version value="1.1" date="04aug15" author="thorsten.huck@hsbcad.com"> Dialog added </version>
///<version value="1.0" date="04aug15" author="thorsten.huck@hsbcad.com"> initial </version>

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


	
	

// Content	
	String sAttributeName=T("|Format|");	
	PropString sAttribute(nStringIndex++, "", sAttributeName);	
	sAttribute.setDescription(T("|Defines the text and/or attributes.|")  + T(" |Attributes can also be added or removed by context commands.|"));
	sAttribute.setCategory(category);

// Alignment	
	String sCategoryAlignment = T("|Text Alignment|");
	
	String sHAlignments[]= {T("|Left|"),T("|Center|"), T("|Right|")};	
	String sHAlignmentName = T("|Horizontal|");
	PropString sHAlignment(nStringIndex++, sHAlignments,sHAlignmentName ,1 );
	sHAlignment.setDescription(T("|Defines on which beam the tool should operate.|"));	
	sHAlignment.setCategory(sCategoryAlignment);	
	
	String sVAlignments[]= {T("|Bottom|"),T("|Center|"), T("|Top|")};	
	String sVAlignmentName = T("|Vertical|");
	PropString sVAlignment(nStringIndex++, sVAlignments,sVAlignmentName ,1 );
	sVAlignment.setDescription(T("|Defines on which beam the tool should operate.|"));	
	sVAlignment.setCategory(sCategoryAlignment);
	
	String sOrientations[]= {T("|X-Axis|"),T("|Y-Axis|"), "-" + T("|X-Axis|"),"-" + T("|Y-Axis|"), T("|Perpendicular|"), "-" + T("|Perpendicular|")};	

	String sOrientationName = T("|Orientation|");
	PropString sOrientation(nStringIndex++, sOrientations,sOrientationName ,1 );
	sOrientation.setDescription(T("|Defines on which beam the tool should operate.|"));	
	sOrientation.setCategory(sCategoryAlignment);	
	
	String sHeightName=T("|Text Height|");
	PropDouble dHeight(nDoubleIndex++,U(60), sHeightName);
	dHeight.setDescription(T("|Specifies the text height. The default value of 0 will use the machine default one.|"));	

// general
	category = T("|General|");
	String sFaces[] = {T("|Top|"), T("|Left|"), T("|Bottom|"), T("|Right|")};
	String sFaceName=T("|Face|");	
	PropString sFace(nStringIndex++, sFaces, sFaceName);	
	sFace.setDescription(T("|Defines the Face of the marking|") + T(" |If the beam is associated with an element the orientation is relative to the element coordinate system.|")+ 
	T("|If the beam is not associated with an element the orientation is relative to the most aligned coordinate system at the time of insertion.|"));
	sFace.setCategory(category);
	
	String sLocationOffsetName=T("|Location Offset|");	
	PropDouble dLocationOffset(nDoubleIndex++, U(0), sLocationOffsetName);	
	dLocationOffset.setDescription(T("|Defines the Location Offset.|") + T("|A negative value defines the offset from the start of the beam (negative X-Axis), 0 = at center.|"));
	dLocationOffset.setCategory(category);

// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }	

	// a potential catalog entry name and all available entries
		String sEntry = _kExecuteKey;
		String sEntryUpper = sEntry; sEntryUpper.makeUpper();
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for (int i=0;i<sEntries.length();i++)
			sEntries[i].makeUpper();
		int nEntry = sEntries.find(sEntryUpper);
							
	// silent/dialog
		if (nEntry>-1)
			setPropValuesFromCatalog(sEntry);	
		else
			showDialog();
		
	// err
		if (sAttribute.length()<1)
			sAttribute.set("@(Posnum)");	
		
	// allow beams or elements
		Entity ents[0];
		PrEntity ssE(T("|Select beam(s) or element(s)|"), Beam());
		ssE.addAllowedClass(Element());
		if (ssE.go())
			ents.append(ssE.set());
			
			
	// get elements
		Element elements[] = ssE.elementSet();
		Beam beams[] = ssE.beamSet();
		
	// add beams of selected elements
		for (int e=0;e<elements.length();e++) 
		{ 
			Beam _beams[]=elements[e].beam();
			for (int i=0;i<_beams.length();i++) 
				if(beams.find(_beams[i])<0)
					beams.append(_beams[i]); 
		}



	// prepare tsl cloning
		TslInst tslNew;
		GenBeam gbsTsl[1];		Entity entsTsl[] = {};		Point3d ptsTsl[1];
		int nProps[]={};		double dProps[]={dHeight,dLocationOffset	};		String sProps[]={sAttribute,sHAlignment,sVAlignment,sOrientation,sFace};
		Map mapTsl;	

		for (int i=0;i<beams.length();i++) 
		{
			gbsTsl[0] = beams[i];
			tslNew.dbCreate(scriptName() , beams[i].vecX() ,beams[i].vecY(),gbsTsl, entsTsl, ptsTsl,
				nProps, dProps, sProps,_kModelSpace, mapTsl);
		}

		eraseInstance();
		return;
	}
	
// on mapIO: support property dialog input via map on element creation

	{
		int bHasPropertyMap = _Map.hasMap("PROPSTRING[]")  && _Map.hasMap("PROPDOUBLE[]");
		if (_bOnMapIO)
		{ 
			if (bHasPropertyMap)
				setPropValuesFromMap(_Map);	
			showDialog();
			_Map = mapWithPropValues();
			return;
		}
		if (_bOnElementDeleted)
		{
			eraseInstance();
			return;
		}
		else if (_bOnElementConstructed && bHasPropertyMap)
		{
			setPropValuesFromMap(_Map);
			_Map = Map();
		}
	}
	if (_Element.length()>0)	
	{ 
	// get beams of element	
		Beam beams[] = _Element[0].beam();
		if (beams.length()>0)
		{ 
			reportMessage(TN("|creating|"));
		// prepare tsl cloning
			TslInst tslNew;
			GenBeam gbsTsl[1];		Entity entsTsl[] = {};		Point3d ptsTsl[1];
			int nProps[]={};		double dProps[]={dHeight,dLocationOffset	};		String sProps[]={sAttribute,sHAlignment,sVAlignment,sOrientation,sFace};
			Map mapTsl;	
	
			for (int i=0;i<beams.length();i++) 
			{
				gbsTsl[0] = beams[i];
				tslNew.dbCreate(scriptName() , _Element[0].vecX() ,_Element[0].vecY(),gbsTsl, entsTsl, ptsTsl,
					nProps, dProps, sProps,_kModelSpace, mapTsl);
			}	
			eraseInstance();
			return;
		}
		else
		{ 
			reportMessage(TN("|waiting|" + _Element));
			
			setExecutionLoops(2);
		}
		return;
	}		
	
	
	

// the beam
	if (_Beam.length()<1)
	{ 
		eraseInstance();
		return;
	}
	Beam bm = _Beam[0];
	_Entity.append(bm);
	setDependencyOnEntity(bm);

// test element ref
	Element el = bm.element();
	
// set coordSys
	Vector3d vecX = bm.vecX();
	vecX.vis(bm.ptCen(), 2);
	Vector3d vecZ = bm.vecD(_ZU);
		
// valid element
	if (el.bIsValid())
	{ 
		Vector3d vecXEl = el.vecX();
		Vector3d vecYEl = el.vecY();
		Vector3d vecZEl = el.vecZ();
		
		if (!vecX.isParallelTo(vecZEl))
			vecZ = vecZEl;

		if (vecX.isParallelTo(vecXEl))
			vecX = vecXEl;
		else if (vecX.isParallelTo(vecYEl))
			vecX = vecYEl;
		else if (vecX.dotProduct(vecXEl)<0)
			vecX*=-1;

	}
	Vector3d vecY = vecX.crossProduct(-vecZ);
	vecX.vis(_Pt0, 1);
	vecY.vis(_Pt0, 3);
	vecZ.vis(_Pt0, 150);
	
	
	
	
	String sVariables[] = bm.formatObjectVariables();



// Trigger SetFormat
	String sTriggerSetFormat = T("|Set Format Expression|");
	addRecalcTrigger(_kContext, sTriggerSetFormat );
	if (_bOnRecalc && _kExecuteKey==sTriggerSetFormat)
	{
	
	// the max number of characters of the property description
		int x = 25;
	
	// show available formatVariables
		int nNum=1;

		
		
		
//		// translate and order	
		String sTVariables[0];
		for (int v=0;v<sVariables.length();v++)
			sTVariables.append(T("|"+sVariables[v]+ "|"));
		for (int v=0;v<sTVariables.length();v++)
			for (int j=0;j<sTVariables.length()-1;j++)
				if(sTVariables[j]>sTVariables[j+1])
				{ 
					sTVariables.swap(j, j + 1);
					sVariables.swap(j, j + 1);	
				}
			
	// show numbered list of variables
		for (int j=0;j<sVariables.length();j++) 
		{ 
			int n = nNum;
			nNum++;// increment over multiple classes
			String sLine = n < 10 ? "  "+n : (n < 100 ? " "+n :n);
			sLine = sLine + " " + sTVariables[j];
			
		// trim line to x characters
			int nNumChars = sLine.length();
			if (nNumChars>x-4)
			{
				sLine = sLine.left(x)+"... ";
				nNumChars = sLine.length();
			}
				
		// append blanks to align preview property	
			for (int k=0;k<x-nNumChars+4;k++) sLine += " ";
			
			sLine += ": " + bm.formatObject("@("+sVariables[j]+")");
			reportMessage("\n	" + sLine); 
			 
		} 
	
		
		int nSelected = getInt(T("|Enter the index of the property which you want to add or remove|"))-1;

		
		if (nSelected>-1 && nSelected<sVariables.length())
		{ 
			String sVariable = sVariables[nSelected];
			String sFormat = "@(" + sVariable + ")";

			int bAdd = sAttribute.find(sFormat, 0) <0;		
			
			if (bAdd)
			{
				sAttribute.set(sAttribute + (sAttribute.length()>0?" ":"")+sFormat);
				reportMessage("\n"+sAttributeName + T(" |set to|: ") + sAttribute); 
			}
			else
			{ 
				int a=sAttribute.find("@(" + sVariable,0);	
				if (a >-1)
				{
					int b=sAttribute.find(")",a);	
					String left = sAttribute.left(a);
					String right = sAttribute.right(sAttribute.length() - b-1);
					sFormat = left + right;
					sAttribute.set(sFormat.trimLeft().trimRight());
				}
			}			
		}
		setExecutionLoops(2);
		return;
	}	

// get formatVariables and prefixes
	String sArguments[] = sAttribute.tokenize("@(*)");

// collect text lines
	String sText;
	for (int j=0;j<sArguments.length();j++) 
	{ 
		String sArg= sArguments[j]; 
		int n = sVariables.find(sArg);
		if (n>-1)
		{ 
			String s = bm.formatObject("@(" + sArg + ")");
			
		// test string if formatting is applicable
			int n = s.atoi();
			double d = s.atof();
			if ((d!=0 && ((String)d).length()==s.length()) || 
				(n!=0 && ((String)n).length()==s.length()))s.formatUnit(d, 2, 0);
			sText = sText + s;
			continue;
			
		}

		String sTokens[] = sArg.tokenize(";");
		int nInd = sArg.find(";", 0);
		if (sTokens.length()>1 || nInd>-1)
		{ 
			if (nInd==0)
				sText = "";
			for (int t=0;t<sTokens.length();t++) 
				sText += sTokens[t]; 
			sText = "";
		}
		else
			sText += sArg;
	}
	
	

// validate text
	if (sText.length()>32)
	{ 
		String s = sText.left(32);
		String sBeamInfo = bm.posnum() >- 1 ? bm.posnum():"";
		sBeamInfo = sBeamInfo.length()>0 ? sBeamInfo+"-":"";
		sBeamInfo += bm.name();
		sBeamInfo = sBeamInfo.length()>0 ? sBeamInfo+"-":"";
		sBeamInfo += bm.label();	
		sBeamInfo = sBeamInfo.length()>0 ? sBeamInfo+"-":"";
		sBeamInfo += T("|Coordinates|: ") + bm.ptCenSolid();			
		reportMessage("\n" + scriptName() +"\n"+sBeamInfo +   "\n" +T("|The inkjet supports only 32 characters.|") + T("|The marking text has been trimmed to|:\n") + s );		
	}

// properties by index
	int nFace = sFaces.find(sFace);
	Vector3d vecFaces[] ={ vecZ, vecY ,- vecZ, - vecY};
	Vector3d vecFace = vecFaces[nFace];
	int nHAlignment = sHAlignments.find(sHAlignment)-1;
	int nVAlignment = sVAlignments.find(sVAlignment)-1;

// orientation
	Vector3d vecOrientations[]= {vecX,vecY, vecX,vecY,vecX,vecX};	
	int nOrientations[]= {0,2,1,4,3,5};		
	int nOrientation= sOrientations.find(sOrientation);
	
	if (el.bIsValid())
	{
		int n = -1;
		if (nOrientation==1 && vecX.isCodirectionalTo(-bm.vecX()))n = 3;
		else if (nOrientation==3 && vecX.isCodirectionalTo(-bm.vecX()))n = 1;
		else if (nOrientation==0 && vecX.isCodirectionalTo(-bm.vecX()))n = 2;
		else if (nOrientation==2 && vecX.isCodirectionalTo(-bm.vecX()))n = 0;
		else if (nOrientation==4 && vecX.isCodirectionalTo(-bm.vecX()))n = 5;
		else if (nOrientation==5 && vecX.isCodirectionalTo(-bm.vecX()))n = 4;

		if (n>-1)
		{ 
			nOrientation = n;	nHAlignment *= -1;	nVAlignment *= -1;	
		}
		
	}
	int nTextOrientation = nOrientations[nOrientation];

// get location
	Point3d ptCen = bm.ptCenSolid();
	double dX = bm.solidLength();
	int nDir = dLocationOffset==0?0:abs(dLocationOffset) / dLocationOffset;
	if (_bOnDbCreated || _kNameLastChangedProp==sLocationOffsetName)
	{ 	
		_Pt0 = ptCen +vecX * nDir * (.5 * dX - abs(dLocationOffset));
	}
	
	//else if (_kNameLastChangedProp=="_Pt0")
	if (!_bOnDbCreated && _kNameLastChangedProp!=sLocationOffsetName)
	{ 
		double d = vecX.dotProduct(_Pt0 - ptCen);
		
	// limit to beam extents
		if (abs(d)>.5*dX)
			d = abs(d) / d * (.5*dX-U(1));
		
		double dNewLocationOffset;
		
		if (abs(d)>dEps)
		{ 
			int nNewDir = abs(d) / d;
			dNewLocationOffset=nNewDir * (.5 * dX - abs(d));
		}
//		
//		reportMessage("\ndNewLocationOffset=" + dNewLocationOffset + "vs" + dLocationOffset);
		if (abs(dNewLocationOffset-dLocationOffset)>dEps)
			dLocationOffset.set(dNewLocationOffset);
		if (_kNameLastChangedProp=="_Pt0")
		{
			int nNewDir = abs(d) / d;
			reportMessage("\nnNewDir=" + nNewDir);
			_Pt0 = ptCen +vecX * nNewDir * (.5 * dX - abs(dLocationOffset));
		}			
			
	}	


// add inkjet marking	
	if (sText.length()>0)
	{ 
		Mark mrk(_Pt0,vecFace,sText);
		mrk.setTextPosition(nVAlignment ,nHAlignment ,nTextOrientation);
		mrk.suppressLine();
		mrk.setTextHeight(dHeight);
		bm.addTool(mrk);		
	}



// Display
	Display dp(3);
	Point3d pt = _Pt0 + .5*vecFace*bm.dD(vecFace);
	double dSize = U(10);
	PLine pl1(pt-vecX*dSize ,pt+vecX*dSize );
	dp.draw(pl1);
	PLine pl2(pt-vecY*dSize ,pt+vecY*dSize );
	dp.draw(pl2);		
			
#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#:NA>WR*D4
MGV2//S;3EC^/:I(M-B15W%Y6`Y:0Y)J\H5?O'\`*D4<'`K%6-FR)+?Y0%VJ!
M[4\*$&`<MGJ14BJ<="3]:>`!][FF.Y!L;L`/6GB,9'K4I"'[M"J`<]Z5Q#`"
MJ\\FG`-CD`5('QP`*#MZDT"&9QS@T\$XSBHWE"`\_0=:B,SD@`;`>[?X47`L
M#"GD4+@D8/%0F$.N2[,PZ'.*5&.P`TK@3\@D#FD8'TYI@<A>2<]@!1N<C)R#
M]*&PL.V8`R!0,U'AB>6/XT8;/4TKCL2D;OXL?2F,%0%F?BFDOV7)^M0S0SS#
M`V*/Q-)MC21FW.YY,@XYS49@R-Y^[WK1^P39R9.>W%/^Q2%=IF('^[6/)(V4
MXHQW5EXS\OI1"'8,W8]*TVTPL>9F^H`IZZ:H7_6.1^%3[-W*=56,U4(YSS4Z
M9/.:OIIB8R2Q_&G?V>B<8SG_`&JU5-[F;JH@C.Y<<4R0'H"/K5Q;2->@'YT-
M;(1T7\:;CH2IJY4A!:3!(.T<8J>9EC78,!SS4<"`2LPZ9Q5P1H_S,`3CN*<5
MH)O4JP/'Y6<HQZ$@4_S8Q_"/RJQMB`Z#\!308B?_`*U'*+F*ID3^X3^%/C?@
M[8S^57`(SVIP6,#A:%`.?R*9+'&%(^E&S/)1B?3-7,K_`'::<?W:KD$YE9%P
M>8<?5J=AS]U$'U-6,<9Q326SP*.47,0>7-W*#/I3EC?'1"!ZBIANZ\4N>,9I
M<I7,0%'[*H^@I@64G!('T%622.XH_$4<J$F5RDQ'#DTFQAU9\^F:EP<Y#BCI
MP6S2<4.]R/R5/)S^)I?(0GI^M2_*1UIN^->I-*R"[&^0G]U1^%'D(!R%Q]*:
M9TYXX]ZB:Y#<*./6G:(]2=?(!X4$_2D+)G"K^E0#)/!Q3NWWN:JZ%8<47=DJ
M"1TSS2,X3L:3%(2<],T-C6HH4+[?6GAP.>32JA?DL*-H4_?&:1(BLS$D;Q^-
M+M<9SN.?>A1S]XT\D[L9/Y4`)Y3$8Y_.FE"#CD_C4BX)()-.\M1SM-.UQ7*_
MD$'.13_+SW%2NB[<A?UJ,*P&0H.*EZ%;@(EV]0#GK08T'4G/KFG*FX#*<_6I
M`A7L#57$1!5'2GJJ@9S3MH)[<4I'':A`-RN>*7Y1S@TW..A&*`P/.XT7$*77
M/"9_"G;LCA3^(IN[!ZFC=^%-,`W/V4"D+2]MM.##N#2Y7'W:8B/?)T)6G`N1
MC<M+D$]!2%\9.%Q2&-(;/WA^5&[#8+TOF_+G(/TI"X'I^5)@297J'H(4_P`1
M/XU$)0`?\*=YIQPIIW`7:!V-1S=,;>.M.\QF8=![9JO<S'&".>U)O0:0V'[I
M.T\FIPW'$1ID*G8`.M39/?\`*IB-C07S_JEQ3F8@#Y1^%-8OC`(%(0Q&#_*J
MN(D#';G@4XL>Q%0[/EQ_2CYL8QTHN%B7=CO2?*1DL:K>9SCO4@QU.?I4\P6)
M?E_O&D^3/)/YTW(4'J:-RCM5)BL/RO0"DW`#E:;QU-*3Q@#Z9I@'F+Z&D9A_
M=ZTG(_A%)O.>5%3<=A0O/W,4CR%.O)]*:[N1M`P,\FF&%G/+G!Z\4AH;Y[=_
MPJ)V9CD-SZ"K/V:-5&XFG*J#[I%)EW16V<<G)/:E5"HXX6K).TCIS[TUN>I_
M*@7,0$'U&*3S%4\#\:F5$7.&))]139>1A?Y4F.X)(&.T$;O0U+Y1(RQ5?QJB
M8&E=E;Y3CJ#S3&LY,;7DE:,?W3C%+G?8;BMS1:2$_>`_.G+(BCY42HA`5Y")
MGUQ4@5@?F`K1&0[SAC)P*3SU)X84N?0*?PJ0`'J!T]*=Q$`?YLJ3^5+OD[_I
M4H"DTH50<XI)#(AYC#HV*58G[Y/XU,`,=32$#U-.P:B`8X`_6@J3U_G3&95_
MBQZ<4T3(6P-YQ_%BBZ%J*WRMCFDW''/%.(W'J:C")NZG/N:E^12LQ/,P<<_E
M2E@#P,&C:F<9'YTX*G7C\Z6H-#=C-R6/THPP(YX]*=N"_P`50O)SD.2*>P)-
MDH<9Q@U*".FS\:I"=>F['.!3O-;L2?I24V/E+&PYXQ^=+@$8(&.]4F9A_?\`
M:CS),?*A/U-+F'R%O<B\#&*=\A'6J@+-]Z,Y^M2H'QPGYFJ3$XDV4/`I0R@@
M$Y-0YFQA0HII2<\YPU/F\A<I.^#GY<>AJBQWS`CDBGR?:0#ND/2H(=R\Y)J)
M.Y458OQD+@E>M3`YJJBOQNR">>35A0Q&0W%5%DR6H\A1QS32WUH*\\M^M-V<
M]<U=Q6&/N)X+5`S2AL8;ZYJR5'?I2&,9R"*B2;*BR,?(,G`_K4B[>#D4QT!Y
MW#VYIA''\.?K26@-7)V=.Q!I#*@/?\JK%R@/W3C_`&J5)`PR%SD>N:?,'*61
M(&.!_*D+D=%J']XH!"=?:G?,0!LS^-*X<H&1NR-1YA'7(I-A&?EQZ4C*NS/.
M3Z4G<:2!I.,G^=('XR0P]JCWH#R2/PIZN-NW:<_2E=CL@Y//4480'@<_2G8Q
M3MW/2@-",ACD`XH`D!P,_E4P<9SMIP?I@=>M4E<3=B,I(<8S2>2V,9:IPZ$D
M`@D=J9)*R*65"WL*KE1-V5FRMSG'0<U,L@SD\4BMOY:-E8_WJ22-CRHJ=@;+
M&_FC@FD#(?NG)]Z02J&QA<CKS5W$.QSP*0LP/2G>:/44C2@^A`]J3:!#59R>
M@J0;@.E8&L>)8M-LR\(WW!;"(XVCW-<P?'FJ8/[JU7!P0`:TC!M71,I),]&^
M?OG\J:4D8?>(KFO#OB5]7:1+E1'(HX"D\UOI,LA9$W;EZDBD]'9C330YH7SN
MR:>(FQR3GZU1N9F@WDLPSTJO+>A$),CO@=`*AN*+5V:HB.<DY_&E\D9R6`_&
MJ5G<M/"&V[,_WNM5]6U*/1K<3R1F3<V`<TU9[$NZW-7RD'(;/O3=L7<\_6N2
M;QS&T9Q9-M7C[U=%87\-Y91W,)SO&>>U.46MQ*5]BYY48Y.:CVPD]#FG%C+D
M$X%.1(XQG+$U!5V-\J+&XIS]:3=$%YC.?:FMR3M&,TW+*K;"H8=&89Q^%*X[
M,?YJ#:`A`/J.E0"\E61E%FQ(Z;3G-<;>^+[Z*Y>,&(A&(!5/O8J*/QI>K/YC
M1J`!D#%:>RD]2%-':B^N3P;&1`#U8=:?!<W$C,TD!C3^$8YJ+3]4GU/3X;H/
M;KO[8/%7OM$HXS$?H#6=M=2T[E1[B\,RB.U(C[L>M6(I)&BWR?*2>!CH*;*]
MRQQN5%/7"YIC!W&-WRBD58KW1DFF55D*Q@9)_O'TJ?*1I]UCGTJOL\MR%'RE
MLFN9U7Q?/!.$MHXR`<$MSFG&#GL*4E'<ZX/&1G#[O0FGM-N&`,`=ZQ-`U:75
M[<R-'&I4D-M)K:VCJ<9I.+3L.Z9`8RSYWLW'KBGHLF<;V`J3YOI0"/NC)/M0
MD%QNS!Y<G\:'3`XW$URFI>,9++4I[:&R618FV[R>N*U/#VMRZU!--/$(1&P4
M!3G=FM/9M*Y',F[&L$('S8&:-K8(R/;`J3*GHN?K4%S?16D1EN95B3WJ;7V*
M'JI!'RCWS4BY4DA@3CT%<U=>+K7#BV02%1D,W&:S1XTNP<?9("3W.:M4Y=B)
M3CW.T:61SD$^V!5B(2!2SO\`@17#+XQOI.%@B4^H/-+'XONU;-Q"2OJK8I^S
ME>Y/M$=R\AQM7!8]L4W;Y:8*Y)[`U@Z9XFT^ZPC3R02L>CX(_.M^/:B[_.WY
M'#%<U+6NI5P")&`Q0?C3DDB<`C')J'8MPQ_T@CV"TOD*K*WG-P,8P*E>0_4G
MPAXH6)#ZU'A#U9LXZXKG=1U_3[*]>(O<.Z<,0X`%4DV]A-V.E:)0.M,V':3D
MX_N]ZY>/QA8*VW]_R<Y/-2#QI8[3_KL#]:OD?8CGCW.A7"].&/:G>9@X-<XW
MC+3FP"LWX=J1?&NGJ"2LK8X&1UJ>28<\3IO-7-/5E)-96F:W9ZOO$*$2)R5/
M!QZUI*GID4FFM"KI[$`M7QM+L:ECMR@P&J&&7HK2MNQTJ??M'^LZ^M0DBW=#
MO)/]XTV5=B%F8[0.::LZ.Q59\GN!7.>+M3:WMTLTE<-*,MM/1:M)-V)<K')Z
MQ?MJ5]+(>4#$(#V`JC%9R30RS)'B)3@G;[U&MNT\RJ@=W8\*#S7HUAH<4&AB
MUD4[V0@KN[GUKJ;4%8PUDS@[2>73+F.>(L71@2!W'>O5+.XCO;:.>"9BK+G!
M[>U>874/V>XDADXD7@#/-=%X/O%A,EO(QVD;AD]_:HJ*ZNAP;3.S,0?[[DT>
M0GJ:@^TVN2I;!]*E1HY#A23BN?1F^J'B%?7I63XDLXYM&E\P%@I#8[BMCRT`
MSD?G5:X2*6)HRI=6&"`*I:$L\H(A8X4OM]*[#P=<F73Y;?\`YY2$J/8UR]^D
M,5Y-$(&0J^T+N]ZV?"4RQZA)"OR[P#G&<UM45XF4=)6.W4<X+8%"@'K)WHVY
M&,YI%5,<`<5S(Z'9DV]`N?O8KG_$^L_8+-8H,+++D<]A6VY"QDGH.I]*\V\1
M:DM]J<FV/S50;4(/:M*<>9ZD3?*M#/@B^UW"QV\;[W;`/O3KB'[-<&&YB<-&
MVU^>OO71>#K0/<RW<D6P*N(R3GGZ54\60B#5I)!%N$H#`YZ^M;\^MC+ETN:O
MA"_BEAELUP!&2R`^E=5L;^\?PKSC0+^*UU.$K&%WG:QKT7D]3D>PKGJ1LS:#
MNB7=\N*:S84X('I2`<84'\:@F(3C@L1R,U#+O8S-8U$:?:-D_/*"%([#N?UK
MSYI+9"\LH+AN`,\BMSQ/>)=78CW#RXAM//`]:K:196^IWZ`PQ&-#N8YXKIA[
MD;G/)\TK'6>&;/[%I*.,+YIW`'KS6X@)&YB3].E1K+"J!(D#!1@`"DDDN"OR
M18]F:N9RN[FT4T388-PE4=7OWL-.GG!7>!M0`=S5J(R@?O(\GV!KE?$NM1S2
M?9TC)1#S\O\`%5PLV*;>QR<5J]Q(S2`&65\`9ZDUZ/H6D_V5I<<&P%C\SGW-
M<]X8MX[F[6Y>%-D7(.,DM7;F<!<E&V^N*NK.^B(@NIA>(=8DTVU`MP#<2'"C
M'"CUKSFZOI99VEN7=Y">2W/Y5V6K07=[J#N]HY`X3W%0Z9HTOV^,W%A^['.&
M6B+BEJ#3;*.B>&;G58UN90(H2>%/4BNR@\-Z9##Y7V<LO^US5T2E$`4)&/[H
M'2E\RX/W5X/?%9NJV4H(SV\+Z23\MJRG_9:LR\\&(^XVK&/N-QKI4:<`[F48
MIOFSG<?X!WQUHYV'*CRO4;.>PN&AN$PZ]#Z^]:&C:K/92QAIIC;N<2!CP/I6
MAXMFD6^AYC,FSY@0#Q7.K-,TRQ-(I5S\JD?I6SUC<S32D>F1&0HCL2<\^U6/
M.N.@4%CT&*2T>3:L+P<(HPXZ&K84*V>]<JBT=#:N5;B7[-:R7%P1N120B]/Q
MKS":87$Q+)NE8YSV%=GXNNVBBA@$@7S"2PSR17.Z1:K>7R1MM(SGI7737+&Y
MS3=Y&II_A**]LXYC,59QD@"KR^"+0#+3O],5TT$2PPHB@``8``I96$0R3^M3
MSR*Y4<S_`,(59`9,SYJ,>#[+/WW(]*Z=)(W^9F''K4FZ'HK+4.<NY2@CF[70
MX-.D+0[LG@DGM5[RY\82=T';`K381'NOYTW$9Z,OYUE*\GN:)I*UBCY3K)M7
M)J;[.B)F3DXZ9JR3@D)@-4:Q*V[>2[@\D]!6D8(F4B$B*T@:7C:!D\UY]?R2
MWMW)+<DJ2<\'MZ5K>)=2CBN&M$"L!RVWC%8$,D-Y/'&J,7!P..M;0C97,6W(
MZ/PKHRR7_P!LE0E8P0I/0FNW:)".<`_6JMG;)!:1PJ/E50.*E$,:Y`7\2<U$
MG=EQ5CC?%MC;VUVMR",R*>GJ*YR"YEM[R*2-1\K?,2>HKT+6M.CN[!UV[F4%
ME]J\SD<"9NHSQC;TK6&JL1+1W/2;6V:Y`NRXVR*&4"KL=NB,6W$L?>N?\(ZK
M#<V0M)"0Z="W&173>9#$2I8$XS@5S2CRLV4KH4;$6DWCI@_E2+*L@W`#'M4T
M;*Q(/!QDYI+4#S;Q3:+:ZQ)(%;]YANIJGHLGV?4[:0_*2^#SQUKJ?&5D3;)>
M`;S&<-C@`=JXB"\B$RR&-N&!X-=*U@82=IGK6[&.](7/0`CZTEI*+J!)HY?E
M8<8[5-Y2JVYSFN;E=SH3,3Q'=FTT2;$B^;*-B@]>:\V2W.Y3M);ZUTGBG5;>
M\OC%&"4A&W..IJ/PO;0W^H^8(&_=<G/2NB*Y8W,9>]([31]+33[")0JHS*&<
M9[UF>+;&&XT\3F3]Y$>![5NLLO4]#V)K+U9/-LIU90,#MU)K./Q%M:'GMMM2
M174J`IW<]\5ZE!-/<VL<B%,,H/6O)I946Y9F&6!(*YKO_">II>V7E*#')%U4
M'M5UHZ7)I25[&^/-)`9@,=ZQ]4>.#[1()"Q$8!;/?VK9?+(`,`^IKBO$\\D-
MU'#DE6&YE'%80CS.QI.5E<QI(HV#$L,LV6W'K79>%X,6!EDCC7>?EPN.*Y"T
M0WFI16ZQ'E@O`R*]/A@2.%$C&U0,``5O5VL94^XF_'"J./:CS@%^8@?45.(N
M1DX'I4;[4/7.>F*PY#7F,^]U,VT)DP.!QOKSV<W-VY\QXUW,<!1SDUTGBC4E
M1H[=R!D;B!^E9GAQ%O\`5E!A)2,%RQ%=,8\L;F,I-NQV>A:?'IVDPH$`D*Y8
M]R35\L!["D$;N`#@#TIZQ!3_`(UAN:;$!R7W)'R?XB*<(6<8=N#V%3G+\<\5
M&7&[9&,MZGH*7(/F`0QQC@<TLCJ@RQQ4>=AP6WN>F*C*E,O*PX_B/04@"0/*
M@(`'INK.O-4DTZS;[0T9P#M"@Y:JVH^+[6T#16ZO-*IP,#BN>N+V2_+SW:E<
MCH3R/I6D8/J*4T9E[>RW,SW!(8O@88=/:M+PWITNHZ@LDD12.$[F8CK5BPT]
M[R4+#"NTD;G/1?K7<6MJEI"L*CIUR.<^IK2<K:&<5=W)57:H`[4N%498\T[H
M<#DCO574&>/3IWB4N^PX`ZDFLE'6QHW9'#Z[??;=3E9!E8_D7BFZ-?):7GG3
M@[57/RCK5>>&]+[S:L.,$8[U-8Z?<7:DO%Y<><9.1TKJ]U1U.=7D]#5F\6W<
MC;+6+;GIQS6<VIW]Q<2?:+C.!R5(X^E=!8:)"JYD3<OITS]:M'2+'<S"U4[C
M@XKG=2'0WY)''_;KI<`7$F.V3FK<7B&>*0"4+)&.N.M='<:-82)M\@H2,`K7
M*:KX?O=/C,\6R:$GJ!@@4U[.>XGSP.LT^\@U"'?$X)!Y3/S"M`0Q\?+SWQ7E
M]MJ$UE<I-"1YB'MW]17H^FWPU.Q29%"9X<9R<U$Z7+J4JG,7V56'/4C@@5DZ
MWJ2:1IDDLK'KM0`<L:T(IT?[L@(]C7%>*]1CO+G[.)$,4)[G^*G!<ST%-V1S
M,S&:9KVZ.W><D$]:NZ#J\-C++<BT\TDA5Z#:*H0:>EW,L4C%PY^0YS6Y!X2G
M>,[)@JCH",5T>ZE9F&K9L-XX@B7BUDQWHB\<1S-Q:-CU+5D1^$[N>+]Y,L9[
M+[5)#X.E:Y5$N0/[V!TJ;0+O,U)/&@Y5+4>^3FN(UJ]_M"]:9%\C<.53BNU7
MP-Y89FO.<<?+6/+X'F59'^TAL`L`!UIQ<$]!/F9RNGS/:ZC#-&S[PPP"U>O6
MJ17EC'(TN21N&W^5>76MK!'?(LD@ZG(`[UW_`(=O[>.#[%YN6)R@/7%*K%28
MX-HZ0)LB4``4%]G'>EF;"^F*8IC<Y#AC_LUSNVQNBIJ-N+NPGMV^;S$(&?7%
M>5O"!'M*MO5N<<8`KV%D&P\`<=37FVM6\-KJEP@<YSN"#IBMJ,K:&52+9T_@
MVZA.FR6X?,L1Y![`U=UV\:RTJXG)QN`1`.O-<KX4D,-_<,G(D4?GFIO$FI&X
MECMRP=8R2P'KVJ6TYV']FYS26P=B(8VDD(R6=L`$UVOAY6TNT*3`//)RPC&<
M>V:P-!M/.N4FEE0X.2AYXKKU;<Q5.!W(&!65>J[\J-*5/[3'J]W<S!5(5.IR
M<D5+<6['[S#)/:BW:,?QD^RU9!9C\D>*RAM<N5NAYKXCTI;36I!QM<!ACWJ;
MPM<0VFMJ&+`2KLX/\ZZ/Q3I?G+'=R,4V<,V.H]*Y`6EI!<1RI=,F&!.W.?>N
MV/OPU.67NRT/43)B-FP=JC);':O--:NDO-4GN?F92=H^;L/:N[UG4H+30AB3
M:)5"`CK@BN'$=M-*B1RL2_`&.I)I4H*.HZDG(U?!%I!)?S7621%\BJ3U)[UZ
M`3CD#%8^FZ#!9PP[(]DB#EAU.?6M;8JCYCCZFIE*[N5'1";]QQ@FJUVKB%Y2
M-JHIS],59+)C"G)]JY7Q=XBCL[4V:RE'F'4=<5*5W8'(XF^NX9;IYK@NY<Y!
M[@5V_A&$0V?$;;W^8GT'85QVAZ1#KE\L3R2L`<N#Z5Z;%BTMT@C(=@,#`K2J
MU:Q$$[W)I;GR^._84R-99&\V9RJ#H,TZ.)8U$D_S2&G$,XWS?*HZ+_C6"3-M
M+6%):883Y8QU)ZFF>:.881TZMBE9ODW2N(XE'KBN>O\`Q/#&S0VTRJHXR@SG
MZ5:BV2Y)&I>ZS8Z2FV5G:3T5<DUQM_J]YJK9D0K`&X4-@#_&FRWL3$F5GW29
M(4CDUK:;X;DOXA)<>;''QA6^7]*U45$ARN8R"-[A8K6+?=#A1U`]ZZ"Q\,3S
MYDOR$#'.T')K>L='T[33NM[=5D`Y<\M^=6MS3#Y00G=ZESOL.*L-MK:.TMQ#
M;IA5[XJ;(S@`^](&"XC4D+WQWJ0,![#M4-%7&DJ.N1]*0,I/&>*<64KG(JI?
MWL-E8R7#'A.N!S4L!\MRB#&,GV%9SP"9Q(VX,.@!QBL__A)-/8])BQ]JUXPT
MD2N&RKC(/J*RFI]36'+T(TRI^25@?KQ4RRN#\Q)/TIPB1!D*,^M/`)/`I*+*
M;3&>82_8#OQ36<N"KH&4]1GK4I'^SGWQ4+X1"QX4<DGBJU)/.-9MXH-3F7`"
MD\*IX%;_`(-N64W48SLPI`]*P=5FCGOKAB@^]\K@=JZ'P9`?LMS,RD!G`5L=
M0!754;5,YXJ\BUJ.[1;%Y!*SW$IV`MP/J*X1B0[E_G8DDY[_`(UN^*+];Z\\
MH/A81@#/!K-TJP_M*\C@RRH.6.<C`ITTHJXIMR=C<\(:4#:/>S`[I"0BG^%:
MZF!<+P/E[5639;0K;0D!`,'/6II/,E`559%''`K&=34UA#0<[#CYAGTSS4MG
M%B>1PIY'-84T,CG[QR.F1R*FTWSHKA]]RX#C'M62JZZFLJ>AO3,^SD\=*J22
M8GVCLN#3V7RL!G9LG)R:JOF.0R8)W#.*T;ZD<IR.HZ<MKJDLW*PERP;'0>@J
MDFH"VU*&XA5W56&YCZ9KK-5L9;W2)&`PP.X<<?2N1MR%#0D;1SU'-:PE=&<X
MV9ZC)(DL(*G<KC(J"&1PF$4(!W-8/A*_\RSEM9,YB;Y><\5O`JL?/3L37-4T
MD;05T$@:0?,V?Y5QWB6S,EU'+U&W!"]./>NEEF+G!/R=E%9VLVHO=-D&T;TY
M7/;%53=I!..AR-I*;6]CD5\(?O8[5#=NDCR.Q7<S%@,\XJ)_D^4MD-U./Y4Z
M*W.H7:VZN02<DD\XKI=D^8P3;T+.FW4VGQ"ZD7]T[88#LM=QIGE7T;2>82`>
M,&L2^T<3Z6+>%<*!@&LFUT;5K!L07C(AYQCBN&24I<QV)6C8])ACMH^/EX[9
MJ5[E$P%&?85QVF)?Q.S7<YE)'"JN`*OFYN3Q\JBJ4K$<EV:6K!+[3Y8I%&",
M\FO/)[-R^54<'TKL_+DFX9B<\<UR6JV<EK.Z&1CS710FWH85H6>A+K-RMZEG
M`'($48#CU;%:/A733-?+,8\Q0G.3W-8,5N/,W+AF?&,UZ-HMNMAIL<9_UC?,
MWI5R=E8A(TGG$>03R>@`JNJM(<EN".2>@IVTS$]0,\FF3L[MY*+@=S66IJDA
ML\JK&8DZ=SW->8ZVLNI:U)<.G[K[J<]`*[_6F^P:-*RY:60A!@>M<9;6<UU/
M'`D9W.V,E.!6M.V[,Y]D;_A#3WM+.24)^]F/!]%%=2L:6R94;YCVID"+;1);
M6P!VC!;M4J,$)5/FD/4]A4-W=R[65@VB/]Y)\TAZ*#2E/,^>8A=O0=A]::AC
M5RQ;+GJ:R=?N;M;94MHV=6SN*]J2=V)Z&)XEO9;LK!&Z+'N^;:W)KGX;+S+N
M%;:(R2@G(+<'WJ=[6\EPQMV;<<G(QFH9(VC8E4VG.#C.:Z(V1DSM-*\/V5OM
MN+YXI[L\_>&U/0"M_P"T0@8\U,?[PKR=/-S_`*N1NP(4T_RYB,%),^NTU#C?
M=CYK+0]4+PNN#*@'^\.:!<18VK(@4'D;A7F2QNY(V3*P]C@?2IOLTQ/^JF!Q
MU`.*7LT'.STC[3#NP73V^84_SHFZ.A]<&O-?L<X5=T,@W<`XZ^]=7HND/;1+
M-,?WAY`]*4DHH<6V]389O,^4'"U!=645W;2VSM@2H5R.U2R*L:%LM^6:2.-B
MJL00,\9ZUC=W-6DT>:W5@]A</!*7^3@$\;AZUUWAC5DG@-E,50Q+^[8G[P]*
MU=3T>VUJW$=Q&59"=LG<5R4O@V_CD*K<)L'W)/7_``K=N,U9F:3B]#NBH_.F
M[0HP*XI;K4=)'E&Y9R@YZL*:=?U-AS+C_@-1[,OG.V+@#/``]3BN:\1ZROV*
M6WMF#.?O$'MWK&:]O;W"YEEYZ`'%7;+PW?7+#SE$$??=R30H*.K$W?1'.Z?9
M2W]W'#&I82-@GKM'K7IFGVD-A:);QC"KU]S2:?IUOIUOY,2<Y)+$<FK13YLC
MM2J5+[!&/*8YT:T:X,BVL39Z_)QG\:L6UC;"3"Q1Q@`Y"`"K,T[I$6;"J/UJ
MO;+A]TK;=X)'TJ+MNQ:26I96*WB^ZBYJ.0,W"8%3$VZCD[O?-.#"/!"``]Z+
M!S%(618XVD>Y-36]@@F^8!L=.*M;@W.<TGFA.<XQWI6C<;DV07:C><#&!CBL
M^[<@8P>@6K$DN]LDY+'K56[/R\GCK3EM<(HT+60QVZ;TS&1R<=*CFLK&0-*(
MH<$?,=M16MZHM0/)?('<56<M/<%V0C'0#O6=W;0KE3>I86&"ULC+:P1J[GCC
M&:@W%_O."1V[5:G4^5''G`_E34M.=P/UIM78UH0QQLS`G/7M5D6P<%2B[3Q5
MA(0J#CGUIXX.,\5:1+D<Q<>#;*2<R;G"GHJG@5-8:!'8$M"F]^FX]0*Z!I%4
MX)Y-.W*!3:N2G8IQV;!<-2&RR>`*N%\C-("Q]/QI<J'=E1K9%';/H*B6W,C9
M*X`J^$0M\TR`GMN%3"*%>2P/U-+E0^9E0(J+@8'TZU0O=&_M&1<QA%'4GJ:V
M?M-JAP98Q[=:&NX5&=X_(U>G0B[ZF'!X4M+2Z2Y+R,4Y"D\9K9C7=A5^Z*4N
M9RH!^3N:E0J#L0CCJ:+WW$/4*.!VILFX#*J3DX-/5<9(;DT$/G[P_*F[6%9E
M%T\UA&V%0'DFI/+3A8<(H^\P')IS6S.Q$CDH3T7@_G4BQ+$FU1VQDFH5RM!B
M@$;(5V(.K=S4T:A>F`._O2``#`Q3B">XIB&R,#WQ3<,R\=/>CR\'<3D^M'?&
M_%``%10/Z4&.,](AP>I'6G!B!@,":.3U8FJNQ6!8TQPB_@!2[?FY4?E2@'KB
MD()'(Q^-',PL*6;;@!<?2E`'J<]Z9G'<4FX?W_P%*['9$C1(Q!9%)'J*-H["
MH]P8XW$GVI#M[!C^-*X61,,#KBD:5<')YJ`Y[(?SI5!_NTN8+#S*I[TT/ANA
M/X4C*W48^E"[\\XI-EI"G#\F)3]0*8T<9X,,?T(J3FD"*3DYS]:+BL1*IC.$
M1%7_`&13R&`^\*/)!/4_G3MK=.U)Z[CN,V$G)D-2!=O\1-*`.AIV5`H0C+O/
M+N%,IW''W1GC\JB=SO5?5>OITI)-_E]<XZU"[,TZK_LYJ'+4T4=!LU]&EP(C
M'*[*0#L7@?C6MYHD6L^.2,<%@6SSCFD\U\G;A5]^OZ4<S#E+>]XCR1MID]SA
M#MP3[53#,Y^8GCUIX#<8R5)Y-&H6)%!.T^G.*K,?,D5#TS5J1RL9^7!SBHH8
MVDGX7-7*^R%'N6!%N3;D_05(J%>`.GM4\:B./#8S2[PS!5X&,T[:$MME*9DR
MI=@I/;-6(\-M(Z#]:BEC1I4+(&P.O859B19(MSD@#L.!2CN.0.XSRP^E1>8&
M/K2LR,^U4P!TI<#O3<@2&9^<':.*<`1\P&2:7(`XI!)@]0:5V%B.3S#@;MH/
MH.:0VR,,,S-]33V(<`Y%+D=1VJ6588EM'&05C&<8YIQB!;.,9IVZG`^M,0T1
MQIG@8^E&"^.,#L*<%+GBI]O8'!QRU,3*_FJ&V[@BYQ@GDU,L8R&"C=ZYJN0D
M9'E*"V[EL<T]I`!R&/X47%8MAFSSM&*:9&SG>M5/.7M&Y_"GC!',9!]Z+L:1
M9W$\[J3;D'YZB3!YZ4]B<\MBA,5A5&WJY-!QG.6)IN['5J"X`ZDU5T*PO'<$
M_4TW(_AC%/4C&0":"Q!P%'YT7`178=%%*6;UQ2Y?/`44A+G^(?E1<!,-CJ3F
MD"D<'./>C:Y/^L/TI&7C)!;\:5P'#:.II0R`<$"DXQ]T"FLV%R",T7`=YBYS
MC\0*/,'8'\JB$P`Y(IIN!G`R3]*CF*Y2?S".B&CSC_=_.JS38X.3^%-#DGA2
M?K0Y#Y46O.;G[OYU$9G<C!%`#D9V_A0%DZD8J=;CT2)-S=-WZ4!6.27-"JQ[
MBE97]15V)!0,_>-+@>I/XU%C.<N*:L1Z>90%D6`JXZFC:O.0:K%2O60X]J;C
MG.]OQI<P<I2DND\ID0%B.N!5><G[4G4#9R`:=-N\I@@S[FGI!Y[*[9R!BLU!
M]37F2(U^Z1&J@^PI8T8-SGD_PUH):J,`\>U6%MHP/FQ@=JU4'8AU.Q2BM\\D
M4^;;$J_7.*MO(JKM451NE+1EB3@#I5M$)MLAW[XT`ZLYJ]%B(<=35>UA)V@C
M[JYJSY)');\J-1NPC%F?(.!0L?S,V>V*<J,QZ_+3]H'`_.E:0N9$`A)D`)RF
M.12N[,Y`/`&..E/E<(J@'YFZ4U8AC/)/TI;#3N("!QCF@98GY0!]:D"[5X4_
MEBFL<<G@GU:D,;@A>AR>E1X$8P,EC4VT=RE((E#9W+^%*S'<8`V.:<JCK4F5
MQC?^E*I5CPY_*BP#*>J,/F;H>@J<1JHR"Q/O2,>.13L2Y$995SP23T`[5!,L
MLXV*VP+][G!J?8>O(%5)KZT\U@;A0Q`!YZ4V):CXTD*_*RX'I4A63&?,Q^%0
MVLD?EXA<.OL:F))%(L$#KR9,_A3P"QZFH6=UX5:`9\XVCGWI7"Q,8_F!Y-.P
M,_=S^-0CS>06`'?BF[R.K$_4TP)V;GI3?.4_A46Z,KD\TJNNX;8B<]\4@)/-
MSP#GZ"G!SC@$TSG^YBE5M_W6!^@IB=AVZ4M@+T]Z8RSD_*X7VI^RX,G#;4[Y
MZFI,8/S.`/04[$MD*QRJV2Q)/ITIQW`X^8^H'-2_(#W)H\Q@,*N*+(+D01FY
M*$?5J1HSCG`%*\N.K@>M-,O&0K-^%+0HB\D$[MWZ5(J8X8_B!3@TC?=A'XFG
M;)C]XHOT%*R"[(G!`RJL30(VQ\QVGZU*8<\M,?Y4GEP!SO?=_O&CE#F(]RH>
M9#^%*I#'@R&IU,('&/P%-,AZ(AIV)Y@V/V4CZFD\F1FZX'L:>'DQSL7US3?,
MYP90/H*>@M13;HGWB<^]1-L'0X-*S)G.2^:C!8G"QU,F7%`VQEVA6)]J=#"_
M.\+CMFFK'<,VXG;FGM$`P#3')[5*NALJM:@(PY)Q4EG'M@4GJ3G%3[DSA1F@
MJ6.20JUO9&=[B%E)YSGMFC]X_3CZT1M%C*_-[TYI0JY(-,!`@`R:AN<%`H'4
M@4F^9SE!M7U)ZTWD_+N)/K4L!ZD+D#Z4Y7W-@_A3-FWD\FC!(],=S0@>Q:QQ
MUZ4S.]\#^&JSR9^7>#["IX`%C/')JFQ)#9$QL8MC'M3@SM_$V/88I\O#+R1Q
MT`IA;`Y+UFRDA=I_VC]349MLMDH#]6J0#(SM;\Z!'ZH?SI%#?+VDDB/VIPQC
M)9!^%."C'^KS^-+R2`$6@!F03CS!SZ+4Z@(N,\GUI&981U0'O[5#)(C$-O%4
MB6V62V!D5"7YY_.EW$@;?QIQ)X"QEB:HDB:=E("1AAW-5?*@!8^6/F/0BM)1
M*JG<$4]L<TT1C.YL$^I%2XW*4K;%*WTY$<R#Y0W\*U=\I`.!TIV#C(.*".,Y
M^M-)(EMLC:)2?3'6D$:Y!!.*E`SR>@I1R<+T]:=@N0M&N=O4F@6R$DD9)[U.
M4'`]^:>,`=*+!=E=;>-.HI_"C@`8IS<X_E497=]_A>U%D%V-E5I1M!"J>IJ-
M(%AX5ZGV(#Q2XYX3]*7*',,W)UWL2*,@XPF?K4A#'&$`_&F%9`"2XZT,$/`?
M_94?2F^4.K.330PQ\SGZ"@.N.$)^M(=AK+#MX7<1W%,#.QVB,@>]3+YAZ*%H
M,;M]Y\?2AH+C0LP7G8!32&QS-^0I_E#'S$FDV1*#A118"`QQ=7D9F^M2+M_A
MBS]:<')Y"`"D=F88WX^E*X"G?V4+49,V>6`'M4@*_=Y-*8BW04G?H4F1I`K\
MER?6I?L\0.0N:$1U/84YL[<EL8]*$A-C9"JH,+T[8J(OCGH:E55<<DG\:0JH
M/2DU<:9$97;&!0T3R$';@^M2$JO\0I&G&/E.:7+W'<0;5&`/QH)#+C%-W$CB
MC'&2V*W,QFTC[O`]!2A3WI=V!QR::%E/)(Q0.X,T:#G-*O[P_*H^M*(D/4Y%
M.4;2=O`I`*(0!N=NG6HWD1QM5"%]2.M.(+<'('>D4.S^6!C/\7M0`RWA1G)1
M549YP*LD!<A1]*<JI"F%IF-[9#<^W:F2,W$L>>G%!+'JQH,3*3SG-)DUFS1#
M@3D'<:#^/YTSG/7%'S8^]2&+R>!G\Z7RPO4\G]*5%?/`'U/:I7C4IUY]33%<
MB58@>$W$]^N:D^5!PBK35C8+\S!1[4;(\\\T:B%60'JRX]A3]X(R"<>I[TU1
MQ@*`/I3=CD\GY::$2XW<\X%,<DG@]*>,`9I!ECZU1(F>@IZ@`98TA48]&_E0
M$/'S9H`4@O["EP%P!FE8'U/':H3<!2-XQZ4V[;@6#T%,9B?N<T9WC@]:=M93
M@`8HN`P1GJW-1E"`<?K4VXT#&.:3&BNLLF<84>XJ16=C_K1GTI=JG/%-*CKG
M-3<9)L)ZN32^4N.:C#$=S^-/&",EOP%5=":8>6GH*#@9YHVC/?\`&DV@]A^-
M&@E<;G'<F@ERO"_B33\#&,TWY5'6E89'ST+_`)4T@9_B-*\ZKQ^=,+[ERM2R
MDB01J?X?UI1L!X`J`[O6FQB1F`)ZTAV+)*9Z4IG1>IJ#RSN.03CWI&@0\DE:
M:N+0D-TO.`31YK.G"_G48&,!1^)J0#'WCBF(C#2`\L/PI<2'JWZT_='Z9/M3
M0#G('YFE8+B",$YQ3U`':E`ZC=^`IKJ,CDGVH2L-LI74\=M"TCR;5'<U6L[Z
M*[CWP2E_9ABM#4[&.^LS;LHP3DBH5B2,+&L:KL4#@=A5-B5QZ-)A@Z=.I%/,
MF%'ZU!YP?)W[54\)GJ:E3&W<_(I)C:'+.<D;1[4\.<9V4D<:R/O*X6I/)#G&
M2,]`*:N*XW?[8S1"Q)+$^V*CFLW1AY<I+=P>U/B3RU(W%F]31=AN3,FX\T]4
M"BHM^SEJ:]P_15X/>G="L2O(J]3R:@P7&!Q2A-IW-SZ"I5SGYN_84MQK0:D'
M8G/O3RH`"J*<&'04FY5XZL:+(3=P.1QUS37(R%SCWIV<]Z!L#=.?6@`&1P.?
M<T;L'IS2]3@4O3ZTP$QSN8_@*<&R/2HU382S$L3^E/`RN3P.OUH0@`W'BFDX
M;"=>]/+`XQPM.50.0*87(U&#DG)J0-GL*1\=ZC,@';`HO85KCVD"`XR321H'
M.YAGZTY2F,@4K?-TX^E)NXTAY5=O%-VMU#?G48W@<<TN\CAJ5QCBVT\C/O1O
MR.,4@.>,TNP8Z4("-F&<$4<8X-.P<=<U&QP.F*3&##CAOK2A!MR2:3K@C]:7
M#4@N&U@<AS2.)#_'^&*=DCKB@L/6@"LQ*=213#DD8)Z^M6L;@<@5$]ON.Y3C
M%`R/(_6F/=A7V8Y/2IEC/4\TPH-P9D&X=#04FF()-U+DYW`XIC*"W`Z]Z=@8
MR:>H]"=)]^5.`P'3UI9/EPS*/SK/N4W;2O#@\&II'W@>9C`]*ERL)Q)C*H'+
M@>PH0J3D*S'W/%1!HU&<TOVI`W&/SIIW):L6<M[+]!2;!GDL:A:\7'`)^E1?
M;B>=A'UJKB+'"'`[TA9SSBJS7GS'Y1]:>TF4!3[W?FI;T&M2Y9>'_$\[.][I
MXM^?E19HR<?4,:G/A?6L,PM?WAX&94X_6O1J*V=-,CVC/-5\'ZH,%K,%NI/F
M)U_.ICX8U=BJFSP@_P"FJ?XUZ)11[*(G4;.";P[JP4!+3_R(G^-*GA_5U3BT
M(8]3YB?XUWE%/V:%S'!?\([JW>T//_35?\::?#NKC[MGGW\Q/\:[^BE[-#YV
M>?-X;U@D?Z)GU_>I_C3CX<U<+_QZ9QV\Q?\`&N_HH]E$.=G!1Z!K!0%K$(V>
MAE0\?G4I\/ZF!Q:Y^DB_XUW%%/D0N9G"?\([JN?^/7_R(O\`C4,OA[60<Q66
MX]R94Q_.O0:*3IH.8X:/P]J8&39X/?\`>+_C36\.ZHSC%M@=_P!XO^-=W13Y
M$',SAAX>U-3Q;<?]=%_QI?\`A']4_P"?;_R(O^-=Q11R(.9G#GP_J@Y^S9/_
M`%T7_&D&@:L>6M?P\Q?\:[FBGR(.9G$C0-3[VOX>8O\`C2_V%J8&?LI)]/,7
M_&NUHHY4*YP_]@ZJ3DVH_P"_B_XTG]@ZK_SZ`_\`;1?\:[FBER(?,</_`&!J
M9'-ICZ2+_C0/#^J@?\>W_D1?\:[BBCV:#F9Q(T/5.]I_Y$7_`!H_L#4C_P`N
MW_D1?\:[:BCD0<S.(_X1_4O^?;_R(O\`C1_8&JCI;_\`D1?\:[>BCV:#F9Q!
MT'5<?\>O_D1?\:!H&IG[UM_Y$7_&NWHI>S0<S.(_X1_4L?\`'K_Y$7_&D;P]
MJ>,"W/\`W\7_`!KN**/9H.9G#CP_J9X:T_\`(B_XT?\`".ZEVM?_`"(O^-=Q
M11[-!S,X8^'M4[6W_D1?\:3_`(1_5A_R[?\`D1?\:[JBCV:#F9PW_"/ZK_SZ
M8_[:+_C0?#VID8-KG_MHO^-=S11[-!S,X,^&+_.1:X/_`%T7_&HV\,ZL.%ML
MCU\Q?\:]`HI\B#G9YXWAC5R.;3/_`&T3_&HF\*:P6.+0@>OFI_C7I%%)THLK
MVDCS4^$]7VD&R)]O.3_&F+X5UM5V_P!G#KU\Y/\`XJO3:*%32$YMGF7_``BN
MO9^6RP/^NJ?_`!51MX3\1L.+7'MYJ?\`Q5>HT57(A<S/*O\`A$O$1(#6.??S
MD_\`BJMV_A/60<RVF!Z>:G^->E44G!,.=A1115DA1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%5)M2
MLK>_MK":YC2[NMWDPEOF?:"20/0`=:MT`%%%%`!1110`4454L=2LM329[&YC
MN$AE,,C1G(#C!(S[9%`%NBBB@`HHHH`****`"BBB@`HHHH`**:S*B%G8*H&2
M2>!21R)+&LD9W(PRI]10`^BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBN,\<>*O[*MCI]E)_ILH^=A_RR4_U/;\_
M2LJU:-&#G(WP^'GB*BIPW9%KWQ#CTW49+.QMDN?+X>0O@;NX'KBN=O?BGJD,
M#2"VLXU'3Y6)_G7*VEK/>W4=M;1M)-(V%4=ZYK6?M$>ISVMRAC>WD:,H>Q!P
M:\*&*Q-:3=[1_K0^NIY9@Z:4'%.7G^9]#>"/$#^)?#$%_/L^T;WCF"#`#`\?
M^.E3^-:FMW,MEH&HW<!"S06LLB$C(#*I(_E7E'P7U?RM0O\`1W;Y9D$\0/\`
M>7AA^((_[YKU'Q-_R*FL?]>,W_H!KW</+G@FSY;,:'L,1**VW7S/GSX7:C>:
MK\7-/O+^YDN+F03%Y)&R3^Z?]/:OIBOD?P'X@M?"WB^SU>\BFE@MUD#)"`6.
MY&48R0.I'>O3+G]H)%G(M?#K-%V:6[VL?P"G'YUVU8.4M$>11J1C'WF>V45P
M_@CXG:5XTF:S2&2RU!5W_9Y&#!P.NUN,X],`UJ^+O&ND^#+!+C479I9<B&WB
M&7DQU^@'<FL>5WL=//&W-?0Z.BO"[C]H*X,I^S^'HECSQYER2?T45?TGX]PW
M-W%!J&A21"1@HDMYP_)./ND#^=5[*?8A5X=RQ\=M<U+3-,TJQLKMX(+XS"X$
M?!<+LP,]<?,<CO6C\"_^1`E_Z_I/_04KGOVA/N^'?K<_^TJP_`WQ1L?!7@UM
M/^P37E\]T\NP.(T52%`RW)SP>@K11;II(R<U&LVSZ)HKQ?3_`-H&VDN%34=!
MDAA/62"X$A'_``$J/YUZWI>JV6M:;#J&GW"SVLRY1U_D?0CN*QE"4=S>-2,M
MF7:*SM1UBUTW"R$O*1D1KU_'TK*'B>YDYAT\LOKN)_I4EG345D:5K3:A<O!)
M;&%E3=G=GN!TQ[U%J.O26E\]I#9F5TQD[O49Z`>]`&Y17,MXCOXANETXJGJ0
MP_6M33-9M]3RB@QRJ,E&/\O6@#2HJM>WUO80>;.^`>@'5OI6&WBS+$16+,H]
M7P?Y&@"7Q8Q%A"`3@R<C/7BM72_^039_]<5_E7+:OK4>IVL<8A:-T?<03D=*
MZG2_^05:?]<5_E0!;HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@#"\6>(X?#&A/?2??=Q%"""07()&?;`)_"O![SQ#'
M<7,EQ*\DTTC%F;'4U[#\4['[9X#NV5=SV\D<R@#_`&@I_1C7A-O88PTWX+7C
MYBDYKG>G8^KR*$%1<TM;V9[WX#\/Q:=H\&HRQ_Z;=Q!SNZQH>0H_#!/_`-:N
M!^+WA\P:_;ZI;(-MZFV0`_QI@9_$%?R-9`\<^(]+A7R-4E;&%59<.,>GS`TN
MM>-+OQ=:V:WEM%%+:%\O$3A]VWL>F-OKWH=>DL-RP5K%4<%BH8WVTY)IWOZ=
M/T,GPE/>:3XLTV[BA=BLZJRH,EE;Y6`'K@FOH3Q-QX4UC_KQF_\`0#7)?#SP
MA]BB36K^/%S(O^CQL/\`5J?XC[D?D/K76^)O^14UC_KQF_\`0#7;@8S4+SZG
MD9UB*=6M:'V5:_\`78^7/`6@6WB;QG8:3>/(EO,7:0QG#$*A;&>V<8KZ)?X7
M^#6TUK(:)`JE=HE4GS1[[R<YKPSX._\`)3M+_P!V;_T4]?45>E6DU+0\##QB
MXW:/DCPA)+I7Q&T@0N=T>HQPD^JE]C?F":ZOX[^=_P`)U;;\^7]@3R_3[[Y_
M6N2T3_DI&G?]A>/_`-'"OI'QCX,T3QE#!:ZDQBNHPS6\L3@2*.,\'JO3(Q^5
M7.2C)-F5.+E!I'G_`(3UKX46?AJPCO8+`7HA47/VRQ:5_,Q\WS%3QG.,'I6]
M::5\+/%MTD6F1Z=]K1MZ+;9MWR.<A>-WY&L(_L^VF?E\0S`=@;4'_P!FKRGQ
M-HL_@OQ=<:=#>^9-9NCQW$7R'D!E/7@C([U*49/W66Y2@O>BK'J'[0GW?#OU
MN?\`VE3?A#X%\.Z[X9DU75-/%W<BZ>)?,=MH4!3]T''<]:I_&N\?4-`\&WL@
MVO<6\LS#'0LL)_K77_`O_D0)/^OZ3_T%*&VJ0))UG<P?BW\/-$TSPR=;T>R6
MSFMY4698B=CHQV].Q!(Y'O3?@#J<OD:UIKN3#'Y=Q&O]TG(;\\+^5;_QNUJW
MLO!)TLRK]JOI4"Q9^;8K;BV/3*@?C7,_`&Q=Y-=NR"(]D4"GU)W$_EQ^=)7=
M+4;2596/0=&MQJVL2W%R-RC]X5/0G/`^G^%=B`%4```#H!7(^&I!:ZI-;2_*
MS*5`/]X'I_.NOK`ZA*JW.H6=D?W\R(S<XZD_@.:M$X4GT%<7I%LNL:I-)=LS
M<;R`<9Y_E0!T'_"1:6>#<''O&W^%8-BT/_"4JUJ?W+.VW'`P0:Z'^P=,VX^R
M+C_>;_&N?M8([;Q8L,0VQI(0HSGM3`EU$'4O%*6KD^6A"X'H!N/]:ZJ*&."(
M1Q(J(.BJ,5RLS"S\8B20@*SC!/3#+BNMI`<YXLC06L$@1=YDP6QSC'K6QI?_
M`""K3_KBO\JRO%G_`!XP?]=/Z&M72_\`D%6G_7%?Y4`6Z***`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`0@,""`01@@UQ
MNO?#C2M4#36(%A<GG]VO[MC[KV_"NSHK.I2A45IJYM1Q%6A+FINS/`=5^&WB
ML7'E0:<L\:=)(YT"M]-Q!_2NA\!_#>^MKXW7B"U$,4+!HX"ZOYC=B<$C`].]
M>NT5A'!4HV/0J9SB:D'#17ZK?\PK/UVWEN_#VI6UNF^::TECC7(&YBA`'/O6
MA176>2SP/X:_#WQ3H7CS3]1U/26@M(A*'D,T;8S&P'`8GJ17OE%%5.3D[LB$
M%!61\Y:5\-/&%MXWL=0ET9EM8]2CF>3SXN$$@).-V>E>A_%CP3K?BS^RKC16
MA\RQ\W<KR[&.[9C:<8_A/4BO2J*IU&VF2J,5%Q[GS<OAGXN6:^3&^M(@X"QZ
MEE1],/BK7A_X+^(M5U);CQ"PL[8OOFW3"2:3N<8)&3ZD_@:^AZ*?MGT)^KQZ
ML\T^*?@'4_%MKH\>C?946P$JF.5RG#!-H7@CC:>N.U>7I\+OB)ICG[%9RKZM
M;7T:Y_\`'P:^FZ*4:KBK#E1C)W/F^Q^#?C/6+P2:LT=H"?GFN;@2OCV"DY/L
M2*]W\,>&['PIH4.E6"GRT^9Y&^](YZL??^@`K9HI2J.6C*A2C#5&%JV@&ZG^
MU6CB.;J0>`2.^>QJJK^)81LV>8!T)VG]:Z>BH-#(TK^V&N7;4,"'9\J_+UR/
M3\:SI]"OK*\:XTMQ@GA<@$>W/!%=110!S(@\27/R22B%?7<H_P#0>:2UT&YL
M=8MI0?-A'+OD#!P>U=/10!DZSHRZDBO&P2X084GH1Z&LZ(^([1!$(A(J\*6V
MMQ]<_P`ZZ>B@#D[BQUW5-JW*HJ*<@$J`/RYKI;*%K:Q@@<@M'&%)'3@5/10!
"_]E<
`



#End
#BeginMapX

#End