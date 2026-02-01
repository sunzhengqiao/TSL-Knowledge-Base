#Version 8
#BeginDescription
version value="1.2" date="21Nov2018" author="thorsten.huck@hsbcad.com"
new context command to select format variables
bugfix invalid selection
guide line added

This tsl creates a descriptive tag to an HVAC system and draws the flow direction
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <History>//region
/// <version value="1.2" date="21Nov2018" author="thorsten.huck@hsbcad.com"> bugfix invalid selection, new context command to select format variables </version>
/// <version value="1.1" date="20Nov2018" author="thorsten.huck@hsbcad.com"> guide line added </version>
/// <version value="1.0" date="25Oct2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select HVAC system and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a descriptive tag to an HVAC system and draws th eflow direction
/// </summary>

/// <remark Lang=en>
/// Requires settings file HVAC.xml in the <company>\tsl\settings path
/// </remark>


/// commands
// command to insert a G-connection
// ^C^C(defun c:HSB_HVACTAG() (hsb_ScriptInsert "HVAC-Tag")) HSB_HVACTAG 

//endregion



// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	//endregion

	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "@(Name)", sFormatName);	
	sFormat.setDescription(T("|Defines the format of the composed value.|")+
		TN("|Samples|")+
		TN("   @(Label)@(SubLabel)")+
		TN("   @(Label:L2) |the first two characters of Label|")+
		TN("   @(Label:T1; |the second part of Label if value is separated by blanks, i.e. 'EG AW 2' will return AW'|)")+
		TN("   @(Width:RL1) |the rounded value of width with one decimal.|")+
		TN("R |Right: Takes the specified number of characters from the right of the string.|")+
		TN("L |Left: Takes the specified number of characters from the left of the string.|")+
		TN("S |SubString: Given one number will take all characters starting at the position (zero based).|")+
		T(" |Given two numbers will start at the first number and take the second number of characters.|")+
		TN("T |​Tokeniser: Returns the member of a delimited list using the specified index (zero based). A delimiter can be specified as an optional parameter with the default delimiter being the semcolon character..|")+
		TN("# |Rounds a number. Specify the number of decimals to round to. Trailing zero's are removed.|")+
		TN("RL |​Round Local: Rounds a number using the local regional settings..|")
	);
	sFormat.setCategory(category);
	

// SETTINGS //region
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="HVAC";// _bOnDebug?"MEPDUCT":scriptName();
	Map mapSetting;

// find settings file
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound;
	if (_bOnInsert)
		bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";
	String sFile=findFile(sFullPath); 

// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() && sFile.length()>0)
	{
		mapSetting.readFromXmlFile(sFile);
		mo.dbCreate(mapSetting);
	}	
	//endregion			

// Get dispReps and properties //region 
// defaults
	String sDimStyle = _DimStyles.length() > 0 ? _DimStyles[0] : "";
	double dTextHeight = U(100);

	String sDispReps[] = _ThisInst.dispRepNames();
	String sDispRep;

// properties
	int nc=1,ncText=255, nt; // color and transparency
	double dSymbolOffset, dSymbolSize;
	int bHasOffset;
	double dRadius;// specifies the bending radius of tubular duct work
	double dDiameter, dInsulation,dGuideLineMinimalLength=5*dTextHeight; // the diameter of tubular duct work
	String sLineType;
	String sHWArticleNumber, sHWModel, sHWManufacturer, sHWDescription, sHWCategory, sHWNotes,sHWMaterial;
	// TAG	
	{
		Map m;		String k;
		m= mapSetting.getMap("Tag");
		k="TextHeight";			if (m.hasDouble(k))	dTextHeight = m.getDouble(k);
		k="DispRepName";		if (m.hasString(k) && TslInst().dispRepNames().find(m.getString(k))>-1)	sDispRep = m.getString(k);
		k="DimStyle";			if (m.hasString(k) && _DimStyles.find(m.getString(k))>-1)	sDimStyle = m.getString(k);	
		k="SymbolSize";			if (m.hasDouble(k))	dSymbolSize = m.getDouble(k);
		k="SymbolOffset";		if (m.hasDouble(k))	{dSymbolOffset = m.getDouble(k); bHasOffset=true;}
		k="Color";				if (m.hasInt(k))	nc = m.getInt(k);
		k="Transparency";		if (m.hasInt(k))	nt = m.getInt(k);
		k="GuideLineMinimalLength";		if (m.hasDouble(k))	dGuideLineMinimalLength = m.getDouble(k);

	
	}//endregion


// bOnInsert//region
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();

		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();	
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
		else	
			showDialog();
		
	
	// get an HVAC, first one taken
		Entity ents[0];
		PrEntity ssE(T("|Select an HVAC system|"), TslInst());
		if (ssE.go())
			ents.append(ssE.set());
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst hvac= (TslInst)ents[i];
			if (hvac.map().hasMap("HVAC Collection"))
			{ 
				_Entity.append(hvac);
				break;
			}
		}//next i
		if (_Entity.length()<1)
		{ 
			eraseInstance();
			return;
		}
	
	// create TSL
		TslInst tslNew;				
		GenBeam gbsTsl[] = { };		Entity entsTsl[] ={ _Entity[0]};	Point3d ptsTsl[1];
		int nProps[]={};			double dProps[]={};					String sProps[]={sFormat};
		Map mapTsl;	

	// prompt for point input
		while(1)
		{ 			
			PrPoint ssP(TN("|Select point|")); 
			if (ssP.go()==_kOk) 
			{
				ptsTsl[0]=ssP.value(); // append the selected points to the list of grip points _PtG	
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				
			}
			else
				break;
		}

		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion
	
	
	
// get 
// get HVAC from entity
	TslInst hvac;
	for (int i=0;i<_Entity.length();i++) 
	{ 
		TslInst t = (TslInst)_Entity[i]; 
		if (t.bIsValid())
		{
			hvac = t;
			setDependencyOnEntity(t);
			break;
		}
	}
	
// validate HVAC
	if (!hvac.bIsValid())
	{
		reportMessage("\n" + scriptName() + ": " +T("|no valid hvac found|"));
		eraseInstance();
		return;	
	}
	
// get maps	
	Map map = hvac.map();
	Map mapCollection = map.getMap("HVAC Collection");
	Map mapTslRef = mapCollection.getMap("TSLRef[]");
	Map mapBeamRef = mapCollection.getMap("BeamRef[]");

	Beam bmRef;
//region get stream plines
// get stream plines of hvac connectors 	
	PLine plHvacs[0];	
	Entity entRefs[0];
	for (int i=0;i<mapTslRef.length();i++) 
	{ 
		Entity ent= mapTslRef.getEntity(i);
		TslInst t = (TslInst)ent;
		if (t.bIsValid())
		{ 
			PLine pl = t.map().getPLine("plHvac");
			if (pl.length() > dEps)
			{
				entRefs.append(t);
				plHvacs.append(pl);
			}
		} 
	}//next i
	
// get stream plines of duct beams 	
	for (int i=0;i<mapBeamRef.length();i++) 
	{ 
		Entity ent= mapBeamRef.getEntity(i);
		Beam t = (Beam)ent;
		if (t.bIsValid())
		{ 
			if (!bmRef.bIsValid())bmRef = t;
			PLine pl = t.subMapX("HVAC").getPLine("plHvac");
			if (pl.length() > dEps)
			{
				entRefs.append(t);
				plHvacs.append(pl);
			}
		} 
	}//next i		
//endregion End get stream plines

// Display
	Display dp(nc);
	dp.dimStyle(sDimStyle);
	double dScale = 1;
	if (dTextHeight > 0)
	{
		double dTextHeightStyle = dp.textHeightForStyle("O", sDimStyle);	
		dp.textHeight(dTextHeight);
		if (dTextHeightStyle > 0)dScale = dTextHeight / dTextHeightStyle;
	}
	else
		dTextHeight = dp.textHeightForStyle("O", sDimStyle);;
	
// find closest
	PLine plThis;
	double dMin = U(10e6);
	Point3d ptNext = _Pt0;
	int nIndex = - 1;
	for (int i=0;i<plHvacs.length();i++) 
	{ 
		PLine& pl = plHvacs[i]; 
		//if (pl.length() < dEps)continue;
		Point3d pt1 = _Pt0;
		pt1+=_ZU * _ZU.dotProduct(pl.ptMid() - pt1);
		
		Point3d pt2 = pl.closestPointTo(pt1);pt1.vis(i);
		double d = Vector3d(pt1- pt2).length();
		if (d<dMin)
		{ 
			dMin = d;
			nIndex = i;
			ptNext = pt2;
		}
	}//next i
	
	if (nIndex>-1)
	{ 
		if (_bOnDbCreated && bHasOffset)_Pt0 = ptNext; // TODO add offset
		_Pt0 += _ZU * _ZU.dotProduct(ptNext - _Pt0);
		PLine (_Pt0, ptNext).vis(nIndex);
		
		PLine pl = plHvacs[nIndex];
		pl.vis(nIndex);
		
	// display vectors
		Vector3d vecX, vecY, vecZ, vecXRead, vecYRead;


	// declare a pline where a potential guide line could snap to
		PLine plSnap;
		


	// get type
		Beam bm;
		TslInst tsl = (TslInst)entRefs[nIndex];	
		if (tsl.bIsValid())
		{ 
			Beam beams[] = tsl.beam();
			if (beams.length()>0)
				bm = beams[0];
				
	
		// get aligned coordSys
			double d1 = pl.getDistAtPoint(ptNext);
			double dL = pl.length();
			
			double d2 = dL - d1 < 2 * dEps ? d1 - 2 * dEps : d1 + dEps;
			Point3d pt2 = pl.getPointAtDist(d2);			
			vecXRead = pt2 - ptNext; vecXRead.normalize();		
				
				
		}
		else
		{
			bm = (Beam)entRefs[nIndex];
			bm.envelopeBody().vis(4);
			vecXRead = bm.vecX();
			dp.addHideDirection(-vecXRead);
			dp.addHideDirection(vecXRead);
			dp.addHideDirection(vecXRead.crossProduct(_ZU));
		}

		if (vecXRead.dotProduct(_YU)<0)
			vecXRead *= -1;
		else if (vecXRead.dotProduct(_XU)<0)
			vecXRead *= -1;
		vecYRead = vecXRead.crossProduct(-bm.vecD(_ZU));
		
	// get tag data from format variables
		String sText = sFormat;
		double dXFlag = 1;
		Point3d ptText = _Pt0;
		if (bm.bIsValid())
		{
			sText= bm.formatObject(sFormat);
			int nDirFlow = bm.subMapX("Flow").getInt("Direction");
			nDirFlow = nDirFlow == 0 ? 1 : nDirFlow;	
			Vector3d vecX = bm.vecX()*nDirFlow;
			Vector3d vecY=vecX.crossProduct(-_ZU);
			
			ptText = _Pt0 + _ZU * (.5* bm.dD(_ZU)+dEps);
			
		// plan view: create an arrow pline
			{
				PLine plA;
				double dX =dSymbolSize;	
				Point3d pt = ptText - vecX * .5 * (dX+dTextHeight);
				
				plA=PLine(pt+vecX*.5*dX,pt+vecX*.25*dX+vecY*.1*dX,pt+vecX*.3*dX+vecY*.02*dX,pt-vecX*.3*dX+vecY*.02*dX);
				plA.addVertex(pt-vecX*.3*dX-vecY*.02*dX);
				plA.addVertex(pt+vecX*.3*dX-vecY*.02*dX);
				plA.addVertex(pt+vecX*.25*dX-vecY*.1*dX);
				plA.close();//plA.vis(2);	
				dp.draw(plA);
				if (nt>0)
					dp.draw(PlaneProfile(plA), _kDrawFilled, nt);
					
				plSnap.addVertex(pt - vecX * .3 * dX);
			}	
		// align
			dXFlag = vecXRead.isCodirectionalTo(vecX)?1:-1;
			
			
		}
		dp.draw(sText, ptText, vecXRead, vecYRead, dXFlag, 0,_kDevice);
		
		{ 
			Point3d pt = ptText;
			double dL = dp.textLengthForStyle(sText, sDimStyle) * dScale;
			pt += vecXRead * dL;
			plSnap.addVertex(pt);
		}
		
		
	// draw guide line
		Vector3d vecGuide = ptNext-_Pt0; 
		if (dGuideLineMinimalLength>.5*dTextHeight && vecGuide.length() > dGuideLineMinimalLength)
		{
			vecGuide.normalize();
			plSnap.transformBy(vecGuide * dTextHeight);
			plSnap.vis(3);
			Point3d pt1 = _Pt0 ; pt1.vis(4);
			Point3d pt2 = pl.closestPointTo(pt1);
			pt1 = plSnap.closestPointTo(pt2);
			dp.draw(PLine(pt1, pt2));
		}
		
		
	}
	
	
// Trigger SetFormat
	String sTriggerSetFormat = T("|Set Format Expression|");
	addRecalcTrigger(_kContext, sTriggerSetFormat );
	if (_bOnRecalc && _kExecuteKey==sTriggerSetFormat)
	{
	// get classes of selected entities
		Entity ents[0]; ents.append(bmRef);
		Entity entsClasses[0];
		String sClasses[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			String sClass= ents[i].typeDxfName(); 
			if (sClasses.find(sClass)<0)
			{ 
				sClasses.append(sClass);
				entsClasses.append(ents[i]);
			}	 
		}
	
	
	// the max number of characters of the property description
		int x = 25;
	
	// show available formatVariables per type
		String sAllVariables[0];
		int nNum=1;
		for (int i=0;i<sClasses.length();i++) 
		{ 
			reportNotice("\n" + T("|Variables for type| ") + sClasses[i]);
			String sVariables[] = entsClasses[i].formatObjectVariables();
			
			
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
			sAllVariables.append(sVariables);
			
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
				
				sLine += "	" + entsClasses[i].formatObject("@("+sVariables[j]+")");
				reportNotice("\n	" + sLine); 
				 
			} 
		}
		
		String sMsg = T("|Enter the index of the property which you want to add or remove|");
		reportNotice("\n" + sMsg); 
		int nSelected = getInt(sMsg)-1;

		
		if (nSelected>-1 && nSelected<sAllVariables.length())
		{ 
			String sVariable = sAllVariables[nSelected];
			String sFullVariable = "@(" + sVariable + ")";

			int bAdd = sFormat.find(sFullVariable, 0) <0;		
			
			if (bAdd)
			{
				sFormat.set(sFormat + (sFormat.length()>0?" ":"")+sFullVariable);
				reportMessage("\n"+sFormatName + T(" |set to|: ") + sFormat); 
			}
			else
			{ 
				int a=sFormat.find("@(" + sVariable,0);	
				if (a >-1)
				{
					int b=sFormat.find(")",a);	
					String left = sFormat.left(a);
					String right = sFormat.right(sFormat.length() - b-1);
					sFullVariable = left + right;
					sFormat.set(sFullVariable.trimLeft().trimRight());
				}
			}			
		}
		setExecutionLoops(2);
		return;
	}		
	
	
	
	
#End
#BeginThumbnail
MB5!.1PT*&@H````-24A$4@```9````$L"`(```!BU7*5````"7!(67,```[$
M```.Q`&5*PX;```@`$E$051XG.R=>9RD5U7W?^?<YWFJJK?IV??)S"0A)#-)
M")`(,5&$``)J``G$%Q$77`"55W'!^+Z**,$-<4-$?45$)8"RB9!`!$)"A.S+
M9)+)9"8SR2P]6R_5W=55S_/<<]X_;G5-S]Y[5W6?[Q_SZ:FJYSZWJ[M^?7[W
MGG,NJ2H,PV@1AC]Y\_`M-\_U+&:0]AMO:O^QF\[T+,_F5`S#,*9"--<3,`SC
MW*2/WIEMNU,ZUV1//C37<YE9TFUWXI.G"2%#V$5F"0VC^0E.T*^YD@;W\^"!
MN9[.'+#B"T.P",LP6H#77X2XG3J?[P[<.]=3F6-,L`RC>0E.$%).\ZK*X%Q/
M9^XQP3*,YB7;=F=]3S"?ZZDT!R98AM&D'+Z^8ZZGT'288!E&TU%W@L8I6!Z6
M830=QYV@<2*6UF`8S<7AZSOB9'&<+*D,[9KKN30=9@D-HUD(3K#:WB[>(^V=
MZ^DT(V8)#:-9"$ZPUM&1.I^E?7,]G6;$+*%A-`53WQ/<=\4-^ZZX85HF,T-T
M/?[UKL>_OJ[_R4F/8);0,.:8X`1'DJ[(UV)?F]"U2=LBGU5]5MMWQ0WE59?,
MT`RGB]JR3>6+7[JO>GEGW\[.OIT\,#S1$4RP#&.."4ZPVK&^F`Y,6+#:N]/A
M_B!8,S2]::2V?%-M^:8RL&;WESOD`"8N6&8)#6,N60A.\$R\Z!_?.-%++,(R
MC+EA6K)#6\()GHE]5]S0=?"QKI[MX[_$!,LPYH9IR0YMT=@JL.^*&]8!$Q(L
MLX2&,0?,,R=X%G/WG9_^]%0N/PF+L`QC5IE/3K!SWWV%X;YBI?\LKUGWX&?"
M%V>1U]YH44FJ)3GWAH,)EF',*O/)"7;NNW_1D=V+CCQ]EM>,1[#ZXFYD_>,1
M++.$AC%[S!LGN&K/-U;O^69A]^,3NNHLDU_WX&<:TG86+,(RC-E@M$YP292.
M1-G(Y`9I$B=8?/H[2<^3KN_(1"_L.OC8NJF%AU9+:!BS03T[M'U)GI0F/<B^
M*VXHK]XRC;.:'*4]WTD./AGU'9WHA5T]V\<31IT%B[`,8\9I.,'NPT]-;H0F
M<8)G,6ZG'H!ZIC-?7_2/;YSTMV,1EF',(.FC=PY_\N9*>UL6QY,>I$F<X%EH
MO_&F>.NU)ST8;[VV_<8SGN$\.2S",HP9)#C!D97+,%2)LVQR@S1#;'5V3GNX
M?'+IM<FEUTYOZU2+L`QCICA\?4?U\W]56+QVZ:&C;<.528RP[XH;QI-X.8>T
MWWA3..+T3*SXPM`TQED681G&]-/(#I6\EH^4)S=(\SO!V<<$RS"FGT9VJ.:I
MS]/)#=+\3G#V,<$RC&EFWF2'-B$F6(8Q;<RG.L'FQ`3+,*:-^50GV)R88!G&
M]+`PG>#P+3</WW+S638*I_ZVC,4$RS"F2MT)=BQ'.HQT,ND+:'$G./S)F^.M
MUR:7GI`[.BT&^20L#\LPIDK="78N1](^Z4&:I$YP<@S?<O.IVC0M!ODDK+V,
M84R)!>@$-][S=QV'=W<<WCW1"\LK-I57;-YWU<^?^I2UES&,F258GK38[?*J
MRZN3&Z05G6#_VA<4HK@0I;4#^\9_5;)V?;[BN>45ET[EUB98AC%)@N5)NS<F
MU?ZI"-;TSFH6Z%_[@J516HSZ)R18A;7K\Q47EU>\<"JW-L$RC,G0<((=_7LF
M-T++.<&Q[%KYXETK7WR1+BD>>+)T<.?97SRR]CDC:R_ZSM:W3/V^)EB&,3$L
M.[3!T967+RF72SB'8%7:5_:NN&Q:[FB"91@3P[)#&QQ;];QSAE<`1MI7'5MQ
M^;3<T03+,";``MP3/#NS_.V88!G&N#`GV`R88!G&N#`GV`R88!G&N3$GV"28
M8!G&V0A.<"3NC'PMELFWXIMI)WC+U[_=64BZBH7]`X-;-ZW?NFG#C-YNKC#!
M,HRS43]%HFU-"9B*8$WOK$[E4]^X>TU7Q]I%G?<^>Q"X>KX*EM42&L89:0DG
M>,O7O_VI;]S=^.^&]1L'!OH'ROV?^_U?G]'[3B]62V@8DZ=>)UA:[+*19JX3
MO.7KW][V]+-C'QD8Z(_A5R]JF]'[SA4F6(9Q&H(3S)9L!M#,=8)C8ZO`0+E_
M]:*V-=TF6(:Q,&@XP?;>"7=0"<R^$QQ+6AD9RB8ILDV."99A'*=5LD-/=8)C
MV;QAW57GS\]%=Q,LPSA.JV2'GBFV"FS>L/ZZ:Z^>Z3G,"298AE&G%?<$3Z6U
M-@<GB@F68<P3)[AEX_JMF];/Z`3F'!,LPY@G3G#KIO4WOO1[9WH.<XL)EK'0
M,2?80IA@&0N7X`2'BXOBO)KDM<D-TD).\):O?WMQ6]N2MK9=1X^V:+VA"9:Q
M<`E.L+)X0]L(IB)8TSNK4YDN)_BI;]R]>>G2\Y<M^]J.'2U:;VBUA,8"94$Y
MP3.-TSQ&TFH)#>/T!"=8*[6Y+(OR;'*#M)83/'6<CD+264RF-+^YP`3+6'#4
MSQ-<LCS!\%0$:WIG=2K3Z`1/?;"SF*Q9--48<_8QP3(6%@TGV-E[9'(CS`,G
M"*`V7"ZG`Y.9W)QB@F4L&)ZX!SONG>(8K>X$&VS>L.&J"UHOR]0$RU@P[+@7
M7_R;*8[1ZDZPP?GG;7CYM:V796J"92P(;$]P$N,T(298QCRGI>L$DS@IQ,E@
M96BZG&"KUQN:8!GSG):N$RS$25=;YV!E:+J<8*O7&YI@&?.95G>"@Y6AP<J0
M.<$&)EC&_*1>)U@JQ5F6Y/GD!IDW>X(3JS<LE1:W%7<?ZVO">D,3+&-^$IS@
M\)(E[<!4!&MZ9W4JL[,G.*%Q-BU9O'GIXO_>N;L)ZPVMEM"8A[2Z$PS,LA,\
M:9S-FR[HZ^OMZ^^='2-IM83&0J1^LGRQ.\JK<4N=)SB6\3NX3W[AUL<.')KZ
M.*?.IZ^OEWVVHJTXGLMG#1,L8UX1G&"U>V.QVC\5P9K>69W*=#FX6[YX&W5V
M4F?G%,<Y=3Y]_;TKVHHKVTOCN7S6,,$RY@^'K^_0J!VEE8O[]TQNA)9S@KQF
MS;2,<]JG#E>JARNS<;[AB_[QC>-\I0F6,1\(3I#0#?&:#4UND!9R@LTVSJ3I
M.OA85\_V\;_>!,N8#P0GZ&B32!]D<'*#M)`3;+9Q)DU7S_;QK+4WL%U"H^6Q
M/<$Y'&<JC-\)-K`(RVAA@A-4Z0+5B(XW92_4VG.7^FA<S?GFR@D6XJ00%\J5
MP2DZN.D:IT$3.L$&)EA&"U.O$]3UP`#&"%8Q[:@F0^,7K!F;8)TSU`D6NMH[
MRY7!*3JXZ1JG01,ZP09F"8U6Y?#U'91T4M(I0P<F-\+\<((Z-*3#PU_XNS^=
MS?E,A4DXP08681FM1W""E:0KAB;IY)?89]H)GIWI<G!;GW/^EG6KICY.,SO!
M!B981NM1/T^P<WU;;2!.RY,;9!:<X-F9-@=WT?GSW@DV,$MHM!@ML2=X$N]Y
MSV\=Y=(Q=SQKW/8$QT\EZAB).Y>.'(1%6$8+$9Q@VM[ETIK+FO=D^5.Y[KJ7
MW;/GX+&]/6B..L')C3-IIN@$8TF1#;;?>!-,L(P6HGZ>X,KUR=#`5`1K>F<U
M'JZ[[KJC7__VO7M[T!QU@I,;9]),T0G&DL:2MO_833!+:+0*K>@$)XTYP;&T
MWWA34"M8A&4T/\$).M<ADJJFDQMDSO<$Q\^"K1,\+>TWWA1OO;;Q7Q,LH]D)
M3C!)5@.#WD]>L*9W5C/'@JT3/"V-V"I@EM!H:LP)CF7!.L$&%F$934JKG"<X
M79RQ3C`IE(<71)W@6$YR@@U,L(PFI57.$YPN3E\GF!06M7>5AQ=$G>!83HVM
M`F8)C6;$G&!@X=0)CL2=(W'GDLJ!TSK!!A9A&<U%O4ZPV![G:9R/J]W"J;20
M$_S*G?_SU-Y]9WIVX=0)1KY6.K,3//ZR2=_`,&:"X`1'NE>@BJD(UO3.:N:X
M]<[O#&1RIF<73IW@V.S0LV"6T&@BS`F.92'L"6:E15EI45OO,V=W@@TLPC*:
M`O_H?;+MOBD.TD).T.H$`YQ5XW$XP08F6$93(-ONRS[Y4="4!FF5V`I6)SB*
MRVLNKXTGM@J8)33FGJ%?>DDV<"`;F&3C4)@3G,(X4V&&LD//@D58QESB'WM0
M'GLP&SC@JY-L'(J6<H)6)SB6\3O!!B98QEPBCSV8??IC63;YV`HMY02M3G`L
M$XJM`B98QMSQSJUIN7\XZY_T`.8$)SW.5)A])]C`!,N8`T8>O;^Z[8&DW)_6
MJI,>I-6=8!(GA3@9K`R9$QP_)EC&'%#=]D#_+?_0CLG'5FA])UB(DZZVSL'*
MD#G!\6.[A,9LL_.UWUO0GB+.F(5T3EK("7[RBU^]Y8M?X]4KSO2"A>`$*U';
M2-R^=.3(I)U@`XNPC-FFH#T1AB9]>6LYP<?V]U!'^VF?73A.,)8,V?!4G&`#
M$RQCMIE*;(46=(+4>7K!6CA.,)8LEFR*L57`!,N85:92+=A"3M#V!`'4"IVU
M0F=7^1P=8R:$"9;1&K20$_SD%VY];+_5"<+EM<+4]@1/Q03+:`U:);8"<,L7
M;J7.3NKJ.NVS"\<)1CZ-_+D[QDQLS&D<RS!F@I9S@KQV[9E>L!"<8(-I=((-
M3+",IJ:%G*#5"8YE>IU@`Q,LHZEIE=@*5B=X(M,>6P5,L`QCJMB>X%AFP@DV
M,,$RC"EA3G`L,^0$&YA@&<:4,"<XEIF+K0(F6(8Q2<YVGN#@H`X-?>$?_FR*
MXP2:V0E6DXY:H7/1X,$9=8(-3+`,8S*<W<%MO>C\+6L7R'F"*6J#,^T$C]]N
M%NYA&/./<SBXBRY8($YP)K)#SW:[V;F-8<P;;$\00-[6G;=U%X_NF1TGV,`$
MRVA2\BCQ43+7LS@9VQ,,<%:-*OVSY@0;F&`938J/DEKQ],?VS2&V)QC@K,I9
M=39CJX`)EM&D%*I#A>KD^_Q-.^8$QS++3K"!"99AG!MS@F.9?2?8P`3+,,Z-
M.<&QS$EL%;!#*(Q9Y=@O7^SWGC'$:+!HZ?IJ9:`V4L9<MY<Q)SB6N7*"#7@.
M[VTL0$JO>N=X7E:M#.19#4#2V;:X]\FI!P63XYP.[DT_</5LCC-IN@X^-@V!
MU=PYP09F"8U9I>U5OSCTM^\YY\M";`4@Z6Q?W+NS?>_#<Q)DF1,<R]S&5@&S
MA,9L\[5??=7*WKVK^IZ9T%6%U:OV7/"JO1>^:H9F=1+F!`%4DXYJTM$]U#/G
M3K"!15C&;+/YE6].[OD2[IN88.6#0YT''E\O[MF+7C%#$QLGT[67U_Q[@I%/
MB^E0,SC!!K:&9<PVY[_RQY=<<-E$K_)#0YT''U__Y%=G8DH38KH<7/,[P;I@
M_=A-R:7-(EAF"8TYH_HS6VJ5_EIEH/$(T86JQX#>LU\X:_N&[WG/;QWETC%7
M:CPR.0<W7>-,B$D[P9&X<R3N7%*9SO,$IPOWWO>^=Z[G8"Q<4I&1HP>=3\<\
M-@+DY[RP,'2DO'K+S$VL086B`P-#`+9L7/_2*[9NW;1A*N/H4'GKQO4O?>'E
MDQYG/'0=?&SY4W=,Z4A!]=UO_+5XZ[5NY7G3.+&I8Y;0F#.BZ]^I6Z[)"F//
M@NX%1LYYX;3L>8V'ZZZ[;O/FS>'KJ3BXQC@Z-+AE[<HF=X*QI*5LL*F<8`.S
MA,;<,^GSZUOHR,)98QYDAYX%B[",N6?2^U#3D@\Y;Y@WV:%GP2(LHRD8_N3-
MP[?</+EKO_/3GY[>R;0HZQ[\S-0%:\47FJA#QJF88!E-Q.!;MF2U_KPV<.Z7
MGHAYP_GM!!N8)32:B.1U[Z#+K\F[NB9ZX4+VA@O!"3:P",MH+@;^ZZ\'OOSA
MXKYS=W0XE87I#1>"$VQ@@F4T(P?^\`W\[%.\[ZF)7KC0O.&DG6!66IRW+2D=
MV]423K"!64*C&>F\YHV%Y[Z`EBV>Z(4+QQM.\3OE;"2J]+:*$VQ@$9;1I%2^
M]I&1V__6/[%K$M<N!&^XH)Q@`Q,LHZFIO/G2-.U+T_[CC_#:6,NQ#I[]POGM
M#:?B!+/2XK;>W:WE!!N8)32:FOCU;^>+KSSA$2VSULYYX7SUAE-W@O%(7\LY
MP08681G-CN64CF5A.L$&)EA&:V#UAIB"$XRC]B3N&!XYU*).L(%90J,U:+_Q
M)G[>R]-B]T0OG!_><(K?A9<TS9JK=^CDL`C+:!GZ/O\W_9__2'O?TY.XMM6]
MX0)W@@U,L(P6H_R3E^8C?7FU_]PO/9'6]88+I$YP/)@E-%J,PFO?CDNOKK6W
M3?3"5O2&"ZI.<#S8J3E&BU%X[3N&.:WMO;<P7)G0A5T]V[MZMK=6D#5OSA.<
M+LP2&JW*OIM?Z_;M=OMW3_C"%O&&DW:"M<*B6F%15_F9>>,$&UB$9;0J7=?>
MZ!_\FJ\-R-%C$[OPX&/K@&;6K"F>)^CR:F%^.<$&%F$9+<S(USXZ<OO?Y4_L
MF,2US;QO:'N"9\($RVAYFO]\PPDQ:2<HA<5:6.S*K5HG.!YLE]!H>:(?>8=>
M\KUI<CP57O78N(X+:[)]PRG.A_(1JK5PG>!XL#4LH^6)KG^G>I_M>"!)&R;H
M'+%5H-GV#:>X)TB^2KXZ7V.K@%E"8_[0TO6&EATZ'LP2&O.'%CW?T+)#QX]%
M6,:\HA5[T=B>X/@QP3+F(2UTOJ$YP0EAEM"8AR2O>P<_[QJ_J*G/-S0G.`DL
MPC+F)^4O_W7Y*Q].GFG>\PW-"4X"$RQC/O/L^Z]W^W='^R?<0FNFO>'D3Y'H
M6)IU+&WK>7)!.<$&EH=ES&>ZKKTQ?_!K>:6?^OHF=N&,U1M.L4Z0TTH\M."<
M8`.+L(QYSM!M'QF^[2.T:\)-'3`SWM"<X%0PP3(6!+UONU*&CTCE:..1/%O%
M/,3N')_\Z?6&DW:"E:BC$G4LJ_8L3"?8P'8)C05!Z4=^EK:^*&UO;SS"/$24
MGO/"SB-[UFZ_8^H3F.*>8"QI6SX?3I&8(K:&92P(2C_R<U6,9'ON28:'PR/G
MC*T"74?V=I6K^R_Y_BE.8(IU@K&DL:0+.;8*F"4T%A:3JS?L6;6R_\)7]5_X
MZLG=U+)#IPOWWO>^=Z[G8!BSC1Q^9J*7)&G6-M`3CQP!D)?&>SQBU\''EC]U
MQU2V!3&:'>I6GC>50>8'%F$9"XZIU!OV;MAR;//W']O\DG&^WO8$IQ<3+&.!
M,O26YV:U<E8K3_3"=BQNIR6HD":9%O*C^?Z37Y"OC;L7)8L7'7[V?Z8X27."
M)V&+[L8")7G=+Z;;[ZAMOV.BQX6E&('V(B(E#Y'3O(#+/DVS@0E+X4G8GN"I
M6(1E+%QZO_CGO?_Y%UV'C\SU1$Z/.<%3,<$R%CJ3/M]PVAF).ZM)U^+A_>8$
MSX0ECAH+G:YK;RP^]TI>MG2N)X+(UXIIV9S@6;`(RS"F=+[AM&-.\"R88!E&
MG>&W7II6^[)J?^.1C-:QEAVFNGQ^=FJ+.M/NKLZ]Y@3/C5E"PZ@3O_;MV'IM
M5CB>%,I:)M1F]*92[.(<2;\YP7%A:0V&42=YW3LJ0+;ST;A6#[)F.K8"H*4N
M-U*.A\L66XT'LX2&<3*3/M]P<I@3'#]F"0WC9&;3G9D3G!`681G&:9A*O>&$
ML#W!"6&"91AGI/+6YZ75WK3:.Q.#FQ.<!&8)#>.,Q*_]!;[\&BP:;S.9<T-+
M@1+,"4X6VR4TC#,2O^X7TH+@X*,8Z#_WJ\<!\3*5H]`1BZTFAUE"PS@WA_[H
MC7AV)SV[<](C5+N6U18M6_3L$^8$IX)%6(9Q;MJ_]X;J?5^I]1^*!R>9F56Z
M\`7M+WQE<>"H.<&I8()E&.>FXYH;\H%#PT_>/6G!:KOP!>VO_KGIG=4"Q"RA
M84R&<2:7F@&<7DRP#,-H&2RMP3",EL$$RS",EL$$RS",EL$$RS",EL$$RS",
MEL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$
MRS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",
MEL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$
MRS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",
MEL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$
MRS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",EL$$RS",
MEL$$RS",EL$$RS",EL$$RS",EL$$RYA7Y)(!4"^J"LT!0#UDCF=U*E[3T2\%
M`$2:<)*S0"Z9J@((_P(0$2B\5($<P.C#=4RPC'D%D0(@(A!Y(0!*!&TZ,2!R
MOOXI95559B6H^KF>UVSCV*FJJA)1>"1\08C".S/Z<!W2DQ3,,%H:426`5$&L
M!,V$(P:=^\+910%2@.I*JLH`/"&:TUG-/B+"7`^;CLN60$F):/01:816%F$9
M\PJ!$A$I$TC(*T6,9ORC3!"%`@RP*H5`T#7?/&>:H$HB)X3``FD$7"$(#5]H
MT'7#F#<0D:I7`HD2G%(.(6H^Q1)E"O95@XT50("FF^=,$X0I!%F-/RSAP1!>
M!44+3]7_,W>S-8QI1@$"5'*P0J.Z*$"HR<Q$^#2JA[J,-<Y)G8:PHKGF.>.$
M']@8/QB^&&L5C[_6(BQCGD&`",`1$#_YS+XWO>>/H-IL:@6`%`]MV_-3?_AG
MI#$(HVJU0&G$4$&M:EGUD8>W#P^/-,*IQA=-]X,TC"FA8*CX[!-?_L9E/_JV
MNQYX`$TI!'_^B2^]Z*T_MVOG`5`.@)2AO&#-#A$QASU!ZN_OO_/.._?MVT]P
M1"228W1)BX@6VJ:$,<=XJ3+%1`ZBX&`!0$"*:HS"\2TA#4^0E\PY!P#*"$\2
MH*AQM8`B%*)@!K3N+8:E?*2G\K/O^Y,[OONH1IR$/\FCOF/VR;7J4"`%.,P>
MC^_N>=.OO>_1I^Z'*ZI*?6.0"0K2)MS/G%E2U")$#`>`B!YY9-LS3^]CC?KE
MJ'=5(&&*T/@!ZH+;137F&DH`$A$F%LG!CDD!9CB%$%Q]2PA*1!`PLX(!(540
M@:%>B#C2"`2%,I'WZAP1!#E_ZK_N?O>'_G*@+V4%I^0XABJ4YDH(F`KU!`:(
MJG[X4U_^OQ_Z^\&1"E`@=2<8'%J`:^YPH(9([]^__YEGG@$XUSQQ<13"*54%
ME``%P2(L8W8A!:E2R),D<!`3T8AC#5G.Q*SPP\=P\!DYO#L[M,.O?F'GU:\$
M0W+/$9$[OD`;5F?KF8;@]_W-Q][[L7^F3-4E$/6)YCZMR^"<(:0.!%5^U?_^
MG=O^^XY('15B9!$T@C9T5(`%%UXA>&$ZKMLB0D1@$)R&-X>)ZF*N4#7!,F87
MIO"+J(-]LN_)O/^@]._+R_U1WX%:[V$,].9]![5\R`_78L<ITF/'2I5U+[_R
MQ=<)@9U3504QY81(1(A'MY)$E>F;#VXGC9P3D&K$$`$1Q@C<[$,@$!1"X#ON
M>02<Y)Q%>7;*RMH"74TF<MY[9B8BYBB*HBSU1$S*ITE@8(NPC-DE1!%^N*__
M_[Q<]VPG<EZ5!(@TSP3.,QR[A"/V3.6CT=[=#H?O\M41+G8HB8;-;HV@P2V&
MI2X'!M0[4B?LR9&HCSWE4"6HJOJY6JXE83`(#!+/GLC#0QP!HN*%%IX)/!$B
MJJ]1`B*2I1Z`JD04T8DY#/6,K=F?HK'`$<W[__87LJ<?$<29]YE/!16?(W;.
M$<?L1&LB>7E(GWHJ(HZH/QUZ\%$2D"J1!P`2$%2UL=VMJD0N!>5,+.(A[!60
M8`:9YNSW7%C5BP)0)F45(>=$V(T*Z(F*U70UCS/-:#:#!^"<"WN%JDKJ3ILB
M:H)ES"Z*X<]],/OV?X%B@8\)!1=Q5`(XAR=./%3%9<"NG0"3Y**.>[_Q5;B0
MZ4QC/]6D`)&J)U*!JB.G@/-.!6!23RJDT+E;'&(E[PB`1R[("AJI.I`0Q:=^
M^A9@%C<IJ1<BAS&I[6!E.)R2)2JG/F08,XI\Z]]'_NWW(>"((B`G+^!:GA6B
M."9VWN>2`?34MBBO<8I*S#$HW_6I?T%(L0J?:JFON*LJ@8F<*C$T3H>4H1*!
M(B&HN"!N2G,9N;`2O#`Q-*HYCEB`G"6&.IRXE*4+;]$=`/&)RU6L'MZYF$\4
M=%55]298QHR0:K7^E0("'Q3CP/YG_O[GLJP604C4:0Y*BA1UN_:R[ZOF7D0B
MCG<]&0UG#L`B75K&H4S3VM%#_??=38I0+0RIIRG0:&)`*&K1J.CS?H+W$"=>
MV2E8.6=UJ=94/=0'#S;:>PD5C$"]CGYBZD6XBERK]?1K!>K64S#:;PL*2-W+
MJ'HH,J0`5-5KHP&#!Y"B1B1$3&`7$2@71$7N2/TAQRF%"F@!(`IA<349T=$0
M4@$9[0>5:E75-Z;1^(!G/A7)(:I^5)05$`C\Z"M544]K@R+S]7F>Y$6]YJ/C
MCT&1(9<3(C^!*`2U?%B.M_0:O>_H^*/O@#:>RJ5VLN$50)`C`PF-><IIU$:E
M7"O*)S3;(2)'D0F6,2/$*$#A`9`H>29%9:CWCVZ(^X>8.44.('.)0Y))GA$Y
MYURDWKE=>PI]`\(9DU`U'XKRQ+E(50_<]B50/:?J;.F#%.>4,;.P8Q52>$0`
M(G5$3N'")S6$,DHH(A$*@1M4P5S7`M(B4<BX``B-*K_ZVA,UHB$F<E!$ZD++
M`3<:%Y`R%!%%)^4KJ*I`R)6\<#U%E@7P!`$CH83"@P(*5ZH"2*@X6@E,`LT!
MR16BSL7,$0!JU`_7!0IA<")"Z+A#`!"YJ*XC)]M/!OC4XN*0)T74>'G]NTM<
ML9$M4F^W0``05M`;M<J-*3&<ZO$RYL9(H1\61E\9WIRSQ,,F6,:,0$2AB9'"
M$SF0]G_XIV3?]IA`0K&2*!&\4.H=>7@G"B1'C^G10_`JZB5G"+LH+I(G`#V?
M_:Q"`"65LZSUD!(\1'*GN1"#*8(JP*.^@Y0:\1$(I*QA;2Q\:M2KY@IU+*HL
M"!*FJ'?"]"&T4U6(AG\AP:J"F+7Z++D``"``241!5(E(5!J3$U*""RG:#90D
MUURU!(X]B[!"634*6=QUR2`HPS>^4X5(WJC=896(0!$I"4;O%H18U8,5)-S(
M/5,<3^E0]3+:`N&DQGBC?1%&7RQ!,DD;A7[U6C^M2S>?O/`4TGVU/MKH#>L*
M%1(7CG^#(:1B$$!47ZZJ3Q[()3_3S]?2&HR9P2-D2(5<OX%/_$[MKB]!7<1%
M1JZJ4"_,X?<[\S5F*@_PGCT.1!$YJ!)(2:`<L\N@E9Z>(]^]>\55+P:=+0V4
M$!,+JP/$055]2/T292(%?-_PR.'>?B\LDG=VM)VW<ADK<O+,C/HG2U5%E6DT
M/9[JZ_H<$A*\RK:=>Y\]=*1<[J^F7MF)Y(M+75W=G6N7+3Y_W:IB(8&J,+B1
M85]_*T;CCM"^F=6Q9Y"0L@"*HP-#1_J/*1$S+^[H7+ED44@H]0+F2$0("A*,
MBA&1(ZKWP*/0S(`C0$!.%:I2+I>'AX>/"RY0+!:9H_;V4JE4:KQI&K[;,?_M
M[Q\8&AJJU;(\3_,\#S%/%'$<QQT=':52>W=W5PB,1K=!ZIT4B%R]$<7H-ZL:
M:K#J:@4@RS+O?9A,_3$:_:O@/3,SG.CI-<L$RY@1E%*B)"0NUQZZ33__5QX4
M1Y#Z9IZ0$"M[[SVJCDO52KSS"0*3>BC'&J6D*NQBI52SB.,TRX_=_N7EWW/-
MV1>FA<2Y6%1)/%%$D<LS//7,,_<\L?/;#SQR^SWW/[VO1Y4@ZAQYE8Y2]_7?
M?\5/_O!KKGOQ%4JC04`82D)XY0$0,%2K_L?7OO,?M]]Y^UUWCJ2>7*SP$!_"
M$@94"([)X8J++GSUM2^^]H677G/9EE(Q.5[(*`0)PN(CP$OL553]X[OV?^J_
MOOE/M][Z[/X>$D0<>U557;YLT6M?^7UO>-FU+[OJ>01/'"E`<")"#/'>.0?1
MX\$C$8#!P>']!P\<W-\S,C*2Y[ES3D14B!WJ7S`K/!&M7KWZ!2^X0E69.2CC
MCAT[#ASH*9?+1.1S39*DGF0P*F>-3GN%4G'CQ@T;-FPH%1.BNMR-G0;J=0A@
M9A'T]O8>.7+D\.'#Y7(YJ%5X011%W=W=RY<O7[9L2:-A@VAVID1?ZX=ES!"B
M`#SR`WL'W_,]V="@PI%3\N3`"O$$!BNJ0$2KS]^GS]WWA5M9F9DS"+,21>JA
MJF!/DJCSR=)EKWCHR6!33OL+_=*?^=5OWOL8H>J$,P<']4B2V&75FHN+N=2(
M`5%5Q^1$<G:D61HSI4Y>^N(7_=OO_<;*%<OJ_9A"L;5Z)4>0KS_PT$_][H>>
MV7>0H"HNV"[R1.HYICQ%A"@7SS$+><ISCA+1_$VON.Z3?_Q_=+1,L'CU]>G0
M$',HHE1'T447G/?B+5O^WV?_*R+.)7,:"T>J&;&H9.P2@!GRO*V7_,-[?_WR
M"S;46P<+U`41%/7UG0=5'1JJ;-^^O>?0(>:P+R%2KRK@NJ+"LXPNLI$D2?**
M5[R<ZM&-$+G;;KNM6DV9V>=*Q$IPK")"%'R?:Z1-*6)`G:,M6[9L/&_#\9]&
M*%T_WMP*AP\?V;Y]>WE@"*S,+"+U3=Y@<)6]BG-.U<=1Y+VO+VFI7G?==6UM
MQ9-^Q+:&9<P03(`?&1KZDS=FE3*11H#F&1%YAL!!`"_D(E\L+OJ-CZ__V5\7
M8H7/%!$[4B<B%*O"A<\DY5EZN.?HO7=#E<Z<(,Z.$+F,.3BIH@-5:\YY5250
M!')$84LN+#E%**1$Y/7._WGD93__GN'!2O`X#`)R)8+JWW_QJZ_^F=_LV=T3
M2:3BB!4^YSQW(7L]!QQ[1UQPK.PX5HKAV<%!3Y,#IB0@(89H_OA3S_S39V]U
M7,Q]2LP4B2(%$4G$*,(#$*_ZP+;M+W_+NV^__[%Z0'=\$9^).1P1M&_?@6]]
MZUL]!P\3.0\B)?'U/'(:;6-(''2$&DWR5`4`D885=._KYM$Y)^*=<YH3:=@<
MB,1#A:$,<DP1$:=IOFW;]J>?WC,:>-67WAN6\(DG=GSWN]\='!IR+B+E>FQ%
M85LTE#A0Q)'WGLCE>2XB>M9\-+.$QHP0_A`/?N#&VMYML2M"/?L\92VBX'TM
M1:HD%#G'I95_?%>^_L)EY\4K7_H#Q[YQ)PN)"*M&2#)?+:"MIE*3E"-./!^[
M[2O+KWJQX(RIZR10<B3JR&G"N<_@DAP^9H9&*EX5K"J:(E+/OA!UJD"9O%2>
MV/W4.S_XD7]\[Z\*-%)XBECUUN\^^J[?_V`*B6/*M5)PG;6T[))8)<I%*')$
MJCKB7+M7C1SG/G/DO1<:TZI<M7ZJ`E%H.Z"1M'GV*J0,UA11##C)1]AUB&:"
ME)@!9F&"J$_+(\,__$N_=MO?_/GW77X12,)ZOB)C38AY[S-['WSH$89KW((!
M)>KJZERZ=&E;L3V*(H'/?)J/Z$BM6JD,]PWTCG:A\J#C'5F)J*VMK;N[>^G2
MI7%2;(\+875?1&JU;&AHZ-"1GB.]1]JCSFHZ$L>)B&Q[='M75]>R9=T"SV/&
MN>>>>PX=.D)$7B1BJG<&4EW4U54JE3BBP<J@'^9:5G4N\CYW7"^WDOKN[&DP
MP3*F1.:KS(FK[[^/GG&B7)6!]-,?DL?NB!QI*MXE%*,-W;W<4XP2E\:LWE.R
M_/<^3QLN201E&=CX\^\X]LV[U"F%=2[V!4F&74]$I80*$!;"L;MNA_\=IJ2&
M-.$$C>45!01%UY;346@;V.4,SA.P`PE+*=/#!6GW*`HT=CY594WB6JG"1\$Q
M&)&4//S'/WO;K_RO-UQ^P7EE#+51">#W?_2?:U4AR@E).W4.IT>(VGR6)MR1
M41[%21Q'G'4,Y<\"734)Z]<40S.2`N(468R8*&RX`1#2N("V*HY26F(X8?9$
MI)XA+NI.<8!ID0).'7SB719+[I*ND>P(AHN_]`<??/@S?P?ENOQIDE.E_]C0
M0P]N@S+%+"+LN3TJK7G.HDV;SF\KMH<E^1!@`AA)AXJ%MB!/U6H5`,%!7:XU
MA^3YSW]^=W=WL9C45Z-`PWZX%!7#GJ.J$JVZ\/P+A@:&OG[_[9H1:3%BIRH[
MG]RU=.F5K)QI-7(.&NW<N>OPH3Y"I$K%B(?3_A7+5C[G.<]9N7)E([YCXAS5
MM*;E_H$#!P[LVW<@/!5+XE$[[>^;"98Q)1Q%3!R6:8A(X$D=$;*'[JC]^Y]Z
MK3F)*`$C)^5,AYV'8XZ(:TA7_.8_X^)K5968.KBK\YJ7M3]G\]#CNQ4I@Y6=
MJCIM<\ZI"JL7IM['=@P]^W3'QHNBL"?5V(8C`;'W.:@(SU"`F#@GS3R22")(
MUXNNOO(-/_#B#:M6Q4ET^-"QO_K7SSV\\VE0D>KK/7DHKOW*M^Z^_(+SVKC$
MX(%*[;Z''A5X*'GRZC-0H=11^I-WO?/:*[<\9]7*0GL;1$'47^WO.3;T]/Z#
M3^_>]_7[MWWQ&]]V:992[DYJR\"D$%$%8KA((*HI4>$YFS:]\NH7G+=B3:F+
M*L/9O=MV?NK6;X"K"3D?)?`Y7`'*C^U\\E^^=.N/_]`/-L(/0O300X\P<Y[G
M82NTO;WXHBNO*G1%##>ZH%Y_*13%0ENC.UBQ6*S_C5$P,X%6K5I1?^WH<5NE
MJ#@VBTQ$V''GXHZKK[SZ?^Z\%X"J*/SA(SU9EB=Q%+&#,A'M>NII50%(U>?"
M6[=NO>C"YXY=PF=F")A=6S$NKBBL6K5JQ8I5]]]_/Q'EDITIA#;!,J8$$RE$
MA`DY<T3*!&#G(Y6__'FD&G,BZM0+.RB+YERB`GQ40[[X+1_@*Z\'@52TON?M
M+OKE7[_OG3_+X-S[B"3-R461S^%<#":(1.J?^9=_NN3_O)]#?M.87J)*ZJ$0
M%R$!(91`>V:F["T_^JIWW?CZRRY<!VTD:LI;7_>*7_S`WWWXEG\'<O$">$<1
MQ'_^CKO?\[8?B^``/+YK3RW/0F=4#PARBDO?^/L_O7++%E(5J"*DG=*B8F?W
MVN[GKEVG5[WP[3?^R'`MO?O>AP_T#W`]*_6$70(/#XG9H;NC\W=_X:=?\[*K
M-JU<@5!1IQD0*_"';_^)-]UT\SV//1YJ[8`D[*!^[(NWO?DUUQ%'JDJ*0X?Z
M*I6J>-2[6$3\PJNN*+4GJFAL31R_.X6^$<=_?(W'N;Z&Y1L)4\<?#VGR3$0$
MJBO.LNX5Z]9MV/?,/JBH\THZ/#R8+%X<#O[8L_OI+,M`PA01XZ*++CS__$UC
M$QU.NF^C/S)8B6@TW>5TOV_3\#MK+&"4'%0=>6969`K*RGT'/W2#]I6)!1PK
M9R#QWDNN<%Z41/SB-[Z[](9W"ZE*'A(V644AJW_D#86.3E5'1**1LB,%L8KD
M/JLYB83CP[=_54Y3S,PAOHM<,2?U+)[%*Q5=X>/O_]W_]W__]V7GKQ=E#P%#
ME50`Q5__UMM6+NL&.^*((B<$)KK_L2=$PH=4CPP,@I0I8N=`L;!>O'']E5LN
M"1\W9O9@";$>G(1B0"(B:D_B5US[HK>\^A7!?!W/^1:M5^%$Y+UN/7_=+[WY
MAS>O7$E"X3`RH4@)1+)QP]K/_=G[DR2)I$0<1>P8(,=W/;@]]=+(1-VW[R#4
M,3LB8HHNNNCBCHZ.("XGJ570B[#L/38SJ['"'=;:3WA3PP8BA0KS8!)'Y4RU
MN[N+",0L'HXXS\/)\JJJ^_8?<A%!V4O6T=%QP06;B8Y/*?A!`*+2.'.P_G18
MF#]S[:<)EC$E*"R"4"B\B(DP]*<W\L&]L7-$!,ER.%:!<EJ-CQYUAPXE`QM^
ML/#F]PDT`H%=/7<<3$(@6OGZURLK*T.CF$D)I.(D`[,X+\C*3^P<?FQ[?>-K
MM"-6(X7'YX@(K!`@(EZ^I/-__>#W`0(F@G=@D9P4H,A#`+[JBBTA>UL]PIBJ
M5!X80M@["^9%F>JWX$/'CM5+J9D4621*!!$H/,$30*+J012%5*^Q[U4C[5O5
MJQ)8:^$1JK?!(0BI$,(NI:Q:N>C5UWX/$4%<2`?3W*=9OF/OOK!XIT1'#Q]1
M%0V'[JBN6[.>1@_R$Y&Q:A6^:$C2"6X1`.J]$!N7C[UJ3+`V^G,G8E*!"N`H
M(JI7)H4`K:^O+ZR=,?.J5:L:PXZ]69A`N&KLL\RG:]W7N'""OY^&<0(*0+U*
M#B*0II__4/K87>)Y>`2#`]&!H\G>W?'#VXOWW)L\\`AV[70'#Q3<]U]/X1SY
M4)M!`$1)/%(0+GSGKT3.>><(J8(I5):04T2D'N"(>-]G_GG,%$[X:QPUUHR8
M<E#NF$0`%A&04P)S%+KN.K"J=A1C!I'"N5B@0H#DE30-ZK*TNP1`654=5%E1
M+I??]KZ_'!FI04&(Z_GS$()3>"!7&BW)9FK$08V/.0-0#\I5"$*.F"`2"FR8
M5+F>Q\^95[#**[_GQ1D\1LU:P14(]/2^0V!5U4IEQ/N<'5Q$"K]TZ>(D"8GF
MP5C5@Y?&9N5)(55]3J.[%HV7-4(A`",CM8'!<F]_7]]`?WF@,E))0^K#Z+#B
MG",-J0\($MG?7U9X\5!X""U:M(B((&,JA,;,H=X`:\QD?![J$TZ/K6$94\.+
M)T>L$&'F[_SV'Z2U)$\+WHO3+&=63X1:R#ADYXI+%IU_PT\0ZFO`0LI"J'_`
M8N]]V[J-%[WFBO+##[B</7E-15E%,R]0U4B=%*+XZ"[4LPOKO^KAP^#A%4PD
M1,*B`HAG$'O-F1Q&BVRA``D\B#D2AD<<N9``1,Z)%\\AL*,MYV]TH_Z%2`1*
M6?SQ_[CMW_[SMDVKEL>%"!JQJ"<B19+$JY8OWGKAVA__X5=MW;P)@%+]_(G0
MN3X0[)PCIR2B!'+PGB,`0A3*@SR('`F4OO?Y%[-"X)FCS"MK3DP]Q_H@1$S#
MP\-,),JYY,R\>&EWH^*O_@Z/*1(4D1!Y$E.C>F8T@!)2'A4X'-A_:/_^_0/E
MODIUF'T,'NW/(P1`282DL]`9JBQ510EUY2(BHK#YR,Q$ZE6[N[L`C-E$1N-'
MYC5GC8CK$ZVW\8M(B<_4RM`$RY@2Y)A5"2I,R#%T+">BW`V6T%U#JAZ@&@A0
M=KZ8Z^#JE[^>2$/K/0B8R3.\YHD4E-2%-)RA@41'*&907J0VSSF!/"DT`F71
MLA5K?N^/ZW<?M1(**+S7/.)"KIDX56+-LH)ZC*Z;`%`?CH@G518'$DE<>\0.
MF2B#(Z?JU9&/%`IB7E1JO_3BBQYY["FAG!V4X%PIS8;3S.W<?Q2^YJ&`!^("
M2C6M\0Z^[:[O?.AC__[REUS]T??\RMJ574`<IGH\C*@O*!=4*@C[;J&^6@#V
M!!<"ON"^UBY=X@%0&G&GU_I9]L/5$1`!DF4UJ`-\%!7R/$N28D@35]5ZOM>8
MU2NPJGJ0:SS>4"O1W%'BO?;U'=NV;7M_7]DY1ZR`.,0>.<`BN7,Q@,SG(*\U
M&M:J&TU;5=(\3W/RL499EJF04NXT9I>52B6OXI2)CY_G3$3>^Y#%.W;?,"1M
MJ>8\^KZ=A%E"8TID&"'1T-0`$=R*9;EPA%*_'A:6Q/D(!%"F8.<[L81?MD6@
M7H5"]B>)4R12J-((0K6QJ@Y6F)F4%^NB@6@@=P+G)'9$2E'[>;]_2]OBS1G5
M1$/1B0O7L;I.UUW3P5PRR4.N`@L3"(U^Q.0:/0/@`&8>1C6E/',R>AX+LT1)
MRIE6!5#%K_SX]8AR(D(>15I*LQ[BG(E41%U$S(RVHNNLX2B1AZ3BD6GTE6_>
M^[T_\<N[]@^DVN\U)P6!XCB"*[`68U_R.!AVWI@9[(B('!-<1FGH0T]$I%1L
MZP1E,7=F<D3)>TVA6;4JX6]``<5R?B3GJHAG4!S'P8TRAW>]_C,*@0_#.4J$
M_$D[%@1V2#(=Z>\_>M\]#PX,#+B8X;QX*G#70'[88T35A[J</,\C34K4W9?W
M>-2@CNM-:8@YB37*I)KYU#G'%'GOU0,*AWH^Z=A5,^<<P^4GE@V&Y)("=YSI
M]\TB+&-*L,883195PI(KGM_SM5LC'T7*@&3$[!BY9T"]=*WPE0_?M/L+?U]:
MOK&P:F-\_H6%\[9$YUT4E3IB=0JO8"9";2#WE'`R0B,%Q`G%N:\Y#ZA;_;._
M6]AR%1BL)_;J!(@@T]=9U+F"5XG!/_&:'[SMNP__V^?^4[D0408ID+C0ZC38
M7"5DXH&2@HA)O&=B)=U[^-";?^WWOG7+!UTXX(?(>R^:*S1R,2BBT02"^L8!
M0"`'%P[:$4V9HX'*D`.ISQ$5X=.$"JF74E)W<S4OC(BDWJTJS_.3O-ZIA%V_
M1H9!XW&?X[[['JJE*>"\9(YC=NI]MKAK<5=7=Q(55%54TS2MC:2U6AIS%'&L
M`B6(%^;ZLI>CB!'.7@MI$.<X$?+$A?\Z8FM8Q@Q!%%(C%02H7W;5U0>_=KNG
MR&F!-2%2R5,`2<&M7.F+R4C6FZ;'CE7=O:S,%&=.CO9V+;GV-2MNN&'U2UZF
M"JA6!_IBIQD/QX@)D8<F&F?DNU_S8]TWO@,,B%(X6>+$W235:1,LB(]"!S_U
M__*^W[SLO,U_\2^?[ND[!F)5$@*45`E!+2B#"A0*<G"LR,&)TOW;=]WSR,YK
M+MT2<I]$)+2[R34]84W^^+L)#JM>$AK%8,^!`Q''-5$2%TZSB`B=;<4@`W&Q
MD+B$ZT>Z2ZU6"[)X<G;"V#N<X7#I'3MVIK6<B``B$)->>.&%&]:=E[0E/-H"
M;*P45D;*>_<<W/74'M7&"=[A=P!A,2M\O\1:J]7B.#ZM,.$,9S%:+:$Q4]17
M79E!('+MS]U"GC+.F2,@)XH`7KR8%B\5TIS`$8/A*&P@219+5.WWSWS^E@.?
M_?2.#>>=__9W+GO)2Q)&S?L"2CEJS+'Z-"..+KMJY;O_'(Y%0H;J";_HX3_^
M#$V4)@,3E!4:NKK\QD_=\*X?O_Y3M]_QS?L?[NL;*`]4O$)9O0A(B/3`H?Z]
MS_20"B+R"M7<1ZQ2^]+7_^>:K9>$0*,>US!+GH%=(WN@[E'#^PE6%1"%;A$/
M;W^RYG.*8M98&:)"FJU8NAP`1..$23ET<2:BH:$A`,ZYLT18C=6KL8D+"CW4
M<T1$HBC.\XS9/?_YSUNU:@T`&J-68R\L%=N+Q6)]RA#G8JH?:NL*A4*]^:IS
MHGFE4EF\>/%9WN@3<R\<`(6<*N8!$RQC2O"8!FQ$5+CP0M8:::3DP,21K%K#
M;4E*`G*1(+36(R)V(J*H5)QF*>!RSJO[]S[\V^\N+4E6+Q+G(O8^=Q%4(W*Z
M<L7&]_TK%]I$1(G#`:EZ_&->YRQ_F2<*>2*G(ARQ*`3.%3A^ZP^]_"=><QW&
M)(+6=4$41#=]]!,?^,@G@BMU[#C/5.FA';N51C<G54.BER,2CH_O6N)XQG[8
MD""PD++2MQY\G!DJ$!4E`C)`S]^P+ERTN+LC'"XKZIFYM[?WA%F=]OL:TZRJ
M\7;5:K7JR`@Q<LF)M;M[\:I5:QH)62?EH`9A8G8`O'IF=LHJ$A(O`"D6B^R@
M0B)*Y(:&*EU=76<)^L9P[B5U6W0WIHB`2>N]P[%H_<:DL]-S&Y"WM6'MNJQ0
M2$-Z:9[75,#L%"PDY)C@^P<S1<8LD;@TSXF='TY#].2=.I5$O#!M_/W/Q$M7
MJ"HQ,Y11_U-\G%!8?.;6NA.%F%'/K.31/3NI*TYHBSRV]3`32/[@Y]^R;EDW
MD4;P7I&1\\3/'.@YGAG&3*/)[N%DX],H;&B>HR#DM33[[[OOA^2C>:'D*$KB
MXB6;UH;L<T`6=7:'D=FA5AOI[>T]*47SE/%/_#:)5+5:K1*1*(5NI1T='8T&
MH:,9L_7TSL8W$OX;FCTTA"PLZG5T=-3?.&8B/G;LV-G4ZJ2N#/5SO"S3W9@I
M0C]S**`B!$HV7TBNLF9U:<6*-"*)0**:PX,B40]E!JD*!!JU95F<(59$F;B8
M8ZB4DAA$#BY7\02O6/4;?U6\^/D*UG#6"VE8_SDUBO`XXV+MA"'4ZQS5*X4.
M=HXH'"K&X!/6DL,'E4F6+UTA2AG`#!`Y%9\W/I"CK68(/D2'BI,^@(K01HR5
M08C_Z..?.G:T7XB)/0ES%`%\S167$$DX]$%5-YVW23V@ZG,5P8X=.\899I[P
M,@Z26(^>`(SJ5'V+$:.9HO4<>G@HPK<V6@5$S!PR*IAYY<J5WOOP^,&#!QLI
MJ:=[GVDTE`-A=/'K3(;0!,N8(J$<-B@%.09AQ97/V[2VUE%,8R3,'#(FF5DX
M0ZQ.8E6*P%ZSZK#X#*QYYM(26-5E642QB(@B!5"ERO(W_=+B5[\UF"YF$`F=
M=AVC7O4V?8ONH[4XO97LU_[L'[?M?@:B/JRL:Z-"18Z''HJG]QU]?,_3[`0<
MBZ\1Q.>T=LV:AK*)YO5FQ$R.(B)JK&>/GG6C4(B`1/_\XY_ZW;_Y)XV(A15Y
M0K%X#X\WO?IE$E:S1)2P>L6:B"."<\Q$=.Q8W_[]^\=OC4-P%,<Q4<A.8"(=
M&JR$13%%(V+E1J&2J@^G<J5I&LX6(Q41R;W/50@$Q:H5*T-2E:JF6?;`0_=/
MX(T?DYI_*K:&94R)#`,Q+8K$*==+Y"ZY^2]J=_WH$Q]]&S_]-.4=+AQZ@R@6
M<FCKRWI+4<FI.HH'AQG(X5R[1L>BX3:-P91X=DP*2D!++O^AI>_Z0P``<ZCD
M&65$1XHHUD]^)J@(,[=1EW)*'$.CX-K"UAWJ)_B<AF%?!HD*<2X4.8@"U,Z%
M$:J6E)62O);_]3_=\M<?^\S&]>N_[XHKUFPJ??_E+[Q\XZ;ERSH55,_^!O[U
MO[]XTP?_E=(\TBB%$B?JD<3199>O#@=30R-"!*%('5.<<@^A>._##SW_3>^X
M[#GG;UJS:O/JM5W%ML,XO'O7_MN^]<"#.W9!2,E3%!>H.*('(^K>L';%VU[W
M&@(H"FT.HVJA?-X%:_;LVB^>7)RD:?K0@]L*47OW\E+$\5CC'#;Q,LHC1!AS
M3@04[86.S%4HBR(NJG+?0.^1OF/+EBPEC7)D#M%8T\<407''?=_L[^EG)"1.
MF#T\`;'R<#[8EK2OV[#VX4>V93YSSI%W1P\./K5[Q_F;+Z1ZJ;.GL*L`>*2L
M#F`B*+S",USL"D.U/I%\['J<JI*2"98Q)2)T`0CEL4+.J8I2X9KON^R:[4>_
M^KGA3W]XZ(G[2)55G)`@:X^+["((,=5&:B$126I>BAI!?0SGBB3,$3%OO&#-
M^S]YIOLF%"/DC4HXNX5559PX%#57(2%FYSGRK-`S[>4#*%(!XHEB85*5F$C5
M#XE?+24PDR(F*%+A:/>S>_<</)#G@Q^(_HW$(8K:V]L<0T0JE4KJRR0%IYRK
MD$L8SG/JR;WA)=<2D5=U`(MX$G$:>0;:55Q-Z<''=SSRY),@D13,D<<(NTAR
MXJB@+"HYJ:]Y#VKCN.TO?_M=H7<S$#$S1$M1V]8MEQT]W#=8'A;)X]CE:?[=
M>^]9N6;IA><_IW&V33W%7!$A:FQ*'CUZ=/GRY4$4UJQ:?6C_,4"828#O?O>[
MEV[9>MZ&\UC=J%5$N3PX4"X?[CER].C1@>I`6UQ2D$!4A4;/;2W&A?!.;]I\
MWNZGG\[SC"C*?+Y]^Y,CP_G6K5L0O++ZD`SC*`H;A95*M5PNBQ(IQ.=C*[&/
MKQ6>/KHVC'%37W1@876L`!-YP#%)LOP5-RQ]Q1M'OOF%GH]]H/KD(QD3D5>N
M_V7/,];,$Y$R6(A5E(J05$1(Q1<*&W[G$]+5=L96R,K4.&FP[H`D)^^1<QPA
MRQ5*CK@0U\OYSH#3.*S#.'4>/H,0X%A"LQ<"<A$%080]Y^SA8A&H"HL?'AJ"
MSP$(@='F@`PY1P4.+>B47_R\K5=?LD4!AE-`(P@8H%P5PF""*)&*YBK*42P*
ML!,E8A:?,@,.J@PEA]+OO>,G7W7U"QIE-R`!,Q`1<.655W[[V]\>J56(*"1,
M'#IX^,"^@X5"8?'BQ6UM;7$<BXAZ5-/A6BT;&!CPWD<1O_*5KPP_P8LOWG+L
M\%WP)"(*RC/_T$.///KPMBB)"X4X2[5:K8(58/$4Q1R[_]_>U836=5SA[YR9
M>Y\E69*ER([D*#&)FQ!D)<:XP:6QVU`O"BV$E)8L"FTH[9+[:0``!LE)1$%4
MA>Q::*'IHM"?75=9MIM2R*)00C==%+HII7_0@L'%9!/:QG4<6=*392FVY?=T
M[YSS=3'W/MDQ2A=>&>ZW?)*&>5=Z1W/.?#\'\AA-1,VL85D)@D12`"XM/;NY
M=?W&YG;FCUKBY?>NO']EY?#AN4?F9GJ]@J09S>J=G9V-C<WA<%@GSX,P50UU
M'!$I,)JXL2M8'1X,1"TL5$*.UX,3@5DE"$`@$R^]<ORE5S;>?G/P]B^WU_XC
M5'$7D>T=,X.(2"H3!@5ZS/1HK8GRB1^^=>#X$O8O-7D8)`V1NK&#8]+H(0_>
M1>AN5M6">_@#'T$@E"#H04B`3D&%RAU!`8&(>"BCJ\(":LNS?S<H4JHU!(>)
MB(JDV@LM:JL17$2/'SWZUD_?D!P4"`"6O2`H@E##`PRB(8M\@,;*(9I"@H@D
MV76(>"D0B?C)MU]_X[4OY;8,B!`W>FATPSAX</R%%TY?O'CQSIT[.5\9KC'$
MNK)K*VLA-H/SE%*,,<_%4THQ'A@=7J;&IYX[L7SITCL:<E*MJFA5UTX9#H<J
MD:1``=$`DE$P/3TU'`ZKW=V@A;MG$J@[5!L^Q+D7S_[E;W_=NG'+/:E$$F:V
MMK:VOKX.<9(Y?(QD",$2,X,,F7':=J"C>P!5A71#]PX/!D%AF5*`UNG-W1&(
MQNH(-,`/O_K=)W[SSN.O_ZB</0QW=Z_J<9+N2M1"@204YAJ*HGCDM>\<//=%
MSYDS^X!D<P5.0\,5T%I@4HMGLF<$HX'N_C'B$$HA"(ID7L--U*$"AA!"-AD-
M$46$P2HW5RHCH(@AJ]XDA[`;@VL18A*-HNKQY;.?^L>O?O[4_!$0TOJ]N.W"
M$!%S@U:$J'0D:[)\/`'))+I[[;4R!"\A<N;D)_[TBS>__XTOYQK=?*0AH;%V
M:#`[.WO^_/ECQYXLRY)(&FA>0;PH`UWHXB8Q]`1!$%)*=]M.Y>O7Q<7%TZ=/
MQ:C2"K3+LJ1`-&93"2%H!J:#X^,GGU_^[&?.+IUX%H`[133_.D1U=#\(X.RG
M7WQ\\:BH0[)RFTV6O0M=5(.3R2R9):\S7T1(!<JR";5$RY_(6^U.6!T>#`:%
M@ZI4HR&$(!$.4P2-(`@=F8C/?.U[4Z]^:_OWO][XV8]O7OXPQ!ZD#E2FPB&5
M5V/"0R]__<@W?T!26UN#_9!/9,@)S>*$'&`5@!1$(33W"(@I(D<[N!\R]"9>
M6F@``\Q;LG@`,3LUMO[GWUVX>.GO_WSWCQ<N77CW7X/!CC%17#1:PU0/E3-$
MGGCZ^%<^=_:KGS__]+&C[56B,2<XP+;^\-M_7UOY[P>KEZ_UKZRNOO?^!U?7
M-J^N7=^^=1MP,@&FH2?$PN&Y,R>7SG_RY!?.G7ER<5ZRZYB+B@K:9I5[IXW,
M*5'5YY];7EY>6EU=W5B_<6UMI>$H*/.=A7M2*9)5(82)B8F%A06TU`4`(CH_
M/[^PL-#O7^_W^_U^?V=GQ]U"*+)`>V9Z=GY^?FYN=G)R,O_@8PM'UQ?ZZVL;
MK4VH@R,?KF9OITZ=?.:9IZY>75E96=G9&61OA]83&?3&QJ_7ZTU-3L[,S$Q-
M34U/3T]/3MZ=;]B\3;(+4NWP0,@W/LQSJ[8P&%-`!`%M\I/1*,M,6("TZDZZ
M,W!2X&9U&4J0%-?*XJ./005-D.F^,*.&1G4-0$!QN7ZSVJUNJ],AIE1#T2N/
MS$S>(_.]%YO;@\'N,$:IW0H$EY2@BW,S+3N]&19EMCI)@?2W/ES?W-RZ>>O6
MH*J2%4''R^+(H4/'%N8GI\8(.%V1CQA."D0,'G,OF;?2MKJM0`^W;PUV=W>3
M.\OPZ/2D*A(DHC%"!90.4<\6J^*`.EPR'RW;@39+F4.%XF(!RL%@4%6564L4
M4$;IE;TX,3&V7YO<JH7R!2R&PPI`>:#XJ*(00H<$N*.N:U4MBI!C5/=R>D8T
M""$8"=9U/1@,JBJ9&7+7JD51%.,'QT)C?K_WW-EZ>^75W%W#QY-B.W3XO\C7
M@ZX4CO[*\\RB^6)CY.`4)200!"DN!!A$V\J4$X,!(`EB)A+*/@G/`&`P]:8M
M8H[D5`BSSW*NE0":#SP)V8=L[8#`"54GLR@&C8_H?9YS1!*/%&;U3*X[#I(6
M&)D)_YF2EF.G-8R2D"$BSCQHSY>;`-HU1H7`A`$"NF=Y9DY=1A8MJX"61*-[
M3M\!HC3[;TRU<LRAT0/B??7>"1>/]\^!1O\=+)?:1B74O&>T\N:1FY7#E&'O
M>T;/IWF"&-4L9&,^F+``D$=7(\$@8=J\OK?XWOIWO=@VPM85K`X=.CPTZ(;N
K'3IT>&C0%:P.'3H\-.@*5H<.'1X:_`_9I7"WS&@\KP````!)14Y$KD)@@@``

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