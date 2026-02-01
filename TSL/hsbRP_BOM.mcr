#Version 7
#BeginDescription
Version 1.1   08.11.2006   th@hsbCAD.de
DE  TSL wird dem Infolayer der Gruppe zugeordnet
   - neuer Kontextbefehl 'Objekt ergänzen'
   - Traufflächenauswertung ergänzt, erfordert hsbRP_EaveArea
EN TSL will be assigned to the info layer of the group
   - new context command 'add entity'
   - summary of eave areas added
Version 1.0   11.05.2006   th@hsbCAD.de
DE  erzeugt Zusammenfassung aller Dachlinien, erfordert hsbRP_Roofline
EN  creates BOM of all rooflines, requires hsbRP_Roofline

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
// basics and props
	U(1,"mm");

	
	String sArUnit[] = {"mm", "cm", "m", "inch", "feet"};
	PropString sUnit(2,sArUnit,T("Unit"),2);	
	int nArDecimals[] = {0,1,2,3,4};
	PropInt nDecimals(1,nArDecimals,T("Decimals Length"),2);	
	PropInt nDecimalsArea(2,nArDecimals,T("Decimals Area"),2);
		
	PropInt nColor (0,143,T("Color"));	
	PropString sDimStyle(0,_DimStyles,T("Dimstyle"));	
	
// on insert
	if (_bOnInsert){
		showDialog();
		_Pt0 = getPoint();
		PrEntity ssRP(T("Select rooflines and/or eave areas"), TslInst());
		if (ssRP.go())
		{
			Entity ents[0];
    		ents = ssRP.set();
			for (int i = 0; i < ents.length(); i++){
				TslInst tsl;
				tsl = (TslInst)ents[i];
				String sScript = tsl.scriptName();
				sScript.makeUpper();
				if (sScript == "HSBRP_ROOFLINE" || sScript == "HSBRP_EAVEAREA")
					_Entity.append(ents[i]);
			}//next i
		}	// end if go
		return;
	}

// restrict color index
	if (nColor > 255 || nColor < -1) nColor.set(143);

// add triggers
	String sTrigger[] = {T("Add entity")};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);

// trigger0: 
	if (_bOnRecalc && _kExecuteKey==sTrigger[0]) 
	{
		PrEntity ssRP(T("Select rooflines and/or eave areas"), TslInst());
		if (ssRP.go())
		{
			Entity ents[0];
    		ents = ssRP.set();
			for (int i = 0; i < ents.length(); i++){
				TslInst tsl;
				tsl = (TslInst)ents[i];
				String sScript = tsl.scriptName();
				sScript.makeUpper();
				if (sScript == "HSBRP_ROOFLINE" || sScript == "HSBRP_EAVEAREA")
					if (_Entity.find(ents[i]) < 0)
						_Entity.append(ents[i]);
			}//next i
		}	// end if go

	}
					
// ints
	int nUnit = sArUnit.find(sUnit);
	int nLUnit = 2;
	if (nUnit> 2)
		nLUnit = 4;	
	
// Display
	Display dp(nColor);
	dp.dimStyle(sDimStyle);
	
//	collect data
	// roofline data
	String sType[0];
	double dLength[0];
	
	// eave area data
	String sMatEaveArea[0];
	double dEaveArea[0];
	
	
	double dWidthLength = 0;
	for (int i = 0; i < _Entity.length(); i++)
	{
		if (_Entity[i].bIsKindOf(TslInst()))
		{
			setDependencyOnEntity(_Entity[i]);
			assignToGroups(_Entity[i]);
			Entity ent = _Entity[i];
			TslInst tsl =	(TslInst)ent;
			// valid, collect data
			String sScript = tsl.scriptName();
			sScript.makeUpper();
			if (sScript == "HSBRP_ROOFLINE")
			{
				int bAdd = TRUE;
				Map map;
				map = tsl.map().getMap("TSLBOM");
				String sName = tsl.propString(1)	;
				for(int n = 0; n < sType.length(); n++)
				{	
					if (sType[n] == sName)
					{
						dLength[n] +=map.getDouble("Length");
						bAdd = FALSE;
						
						String sLength;
						sLength.formatUnit(dLength[n]/U(1,sUnit,nLUnit ), nLUnit , nDecimals);
						
						if (dp.textLengthForStyle(sLength, dp) > dWidthLength )
							dWidthLength = dp.textLengthForStyle(sLength, sDimStyle);
						//break;
					}
				}// next n
				if (bAdd)
				{
					dLength.append(map.getDouble("Length"));
					sType.append(sName);
					if (sType.length() == 1)
					{
						String sLength;
						sLength.formatUnit(dLength[0]/U(1,sUnit,nLUnit ), nLUnit , nDecimals);					
						if (dp.textLengthForStyle(sLength, dp) > dWidthLength )
							dWidthLength = dp.textLengthForStyle(sLength, sDimStyle);					
					}
				}
			}// end if roofline	
			else if (sScript == "HSBRP_EAVEAREA")
			{
				int bAdd = TRUE;
				Map map;
				map = tsl.map().getMap("TSLBOM");
				String sMyMat = tsl.propString(1)	;
				for(int n = 0; n < sMatEaveArea.length(); n++)
				{	
					if (sMatEaveArea[n] == sMyMat)
					{
						dEaveArea[n] +=map.getDouble("Area");
						bAdd = FALSE;
						
						String sArea;
						sArea.formatUnit(dEaveArea[n]/U(1,sUnit,nLUnit ), nLUnit , nDecimalsArea);
						
						if (dp.textLengthForStyle(sArea, dp) > dWidthLength )
							dWidthLength = dp.textLengthForStyle(sArea, sDimStyle);
						//break;
					}
				}// next n
				if (bAdd)
				{
					dEaveArea.append(map.getDouble("Area"));
					sMatEaveArea.append(sMyMat );
					if (sMatEaveArea.length() == 1)
					{
						String sArea;
						sArea.formatUnit(dEaveArea[0]/U(1,sUnit,nLUnit ), nLUnit , nDecimalsArea);					
						if (dp.textLengthForStyle(sArea, dp) > dWidthLength )
							dWidthLength = dp.textLengthForStyle(sArea, sDimStyle);					
					}
				}	
				
			}		
		}	
	}// next i


// sort
	for (int i = 0; i < sType.length(); i++)
	{
		for (int j = 0; j < sType.length()-1; j++)
		{
			if (sType[j]> sType[j+1])
			{
				String sTmp = sType[j];
				sType[j] = sType[j+1];
				sType[j+1] = sTmp ;
			
				double dTmp= dLength[j];
				dLength[j] = dLength[j+1];
				dLength[j+1] = dTmp ;
			
			}
		}
	}
// sort areas
	for (int i = 0; i < sMatEaveArea.length(); i++)
	{
		for (int j = 0; j < sMatEaveArea.length()-1; j++)
		{
			if (sMatEaveArea[j]> sMatEaveArea[j+1])
			{
				String sTmp = sMatEaveArea[j];
				sMatEaveArea[j] = sMatEaveArea[j+1];
				sMatEaveArea[j+1] = sTmp ;
			
				double dTmp= dEaveArea[j];
				dEaveArea[j] = dEaveArea[j+1];
				dEaveArea[j+1] = dTmp ;
			
			}
		}
	}	
	
		
// output
	dp.draw(T("Length of Rooflines") + " [" + sUnit + "]", _Pt0, _XW, _YW, 1, 4);

	double dOff, dMax;
	// rooflines
	for (int i = 0; i < sType.length(); i++)
	{
		dp.draw(sType[i], _Pt0, _XW, _YW, 1, dOff);
		double dTextLength = dp.textLengthForStyle(sType[i], sDimStyle);
		if (dTextLength  > dMax)
			dMax = dTextLength ;
		dOff -= 3;	

	}
	
	// areas
	if (sMatEaveArea.length() >0)
	{
		dOff -=2;
		dp.draw(T("Eave Areas"+ " [" + sUnit + "²]"), _Pt0, _XW, _YW, 1, dOff);
		dOff -=4;
				
		for (int i = 0; i < sMatEaveArea.length(); i++)
		{
			if (sMatEaveArea[i] == "")
				sMatEaveArea[i] = T("not defined");
			dp.draw(sMatEaveArea[i], _Pt0, _XW, _YW, 1, dOff);
			double dTextLength = dp.textLengthForStyle(sMatEaveArea[i], sDimStyle);
			if (dTextLength  > dMax)
				dMax = dTextLength ;
			dOff -= 3;		
		}	
	}
	
	
	
	Point3d ptRef = _Pt0 + _XW * 1.2 * (dMax + dWidthLength);
	dMax = 0;
	dOff = 0;
	for (int i = 0; i < sType.length(); i++)
	{
		String sLength;
		sLength.formatUnit(dLength[i]/U(1,sUnit,nLUnit ), nLUnit , nDecimals);
		dp.draw(sLength, ptRef, _XW, _YW, -1, dOff);
		dOff -= 3;	

	}

	// areas
	if (sMatEaveArea.length() >0)
	{
		dOff -=6;
		for (int i = 0; i < sMatEaveArea.length(); i++)
		{
			String sArea;
			sArea.formatUnit(dEaveArea[i]/(U(1,sUnit,nLUnit )*U(1,sUnit,nLUnit )), nLUnit , nDecimalsArea);
			dp.draw(sArea, ptRef, _XW, _YW, -1, dOff);
			dOff -= 3;	

		}
	}
		
// assign to info layer
	String sMyLayer = _ThisInst.layerName();
	int nFindTLayer = sMyLayer.find("+T0~",0);
	sMyLayer.delete(nFindTLayer,4);
	assignToLayer(sMyLayer + "+I0~");

	
	
	
	
	
	


	
	
	

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
M"`"_`:8#`1$``A$!`Q$!_]H`#`,!``(1`Q$`/P"[0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`#`^9"F.@ZT"'T#"
M@`H`*`"@`H`*`"@`H`*`&[P7V]P,T`)(^Q<XSS0)CZ!A0`4`%`!0`4`-=PBY
M-`#4<L>4(&.M`DR2@9&TI#E0A.*=A7$\UO\`GF:+!<5906VL"I]Z+!<DI#"@
M`H`*`"@`H`CDDV$#&2>U`FP,I";BA'.,4[!<<Q*J2!GVI#%!R`<8H`6@`H`*
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
I4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4``_]D%
`


#End
