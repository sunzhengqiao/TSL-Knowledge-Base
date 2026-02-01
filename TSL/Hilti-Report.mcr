#Version 8
#BeginDescription
#Versions:
1.4 10/09/2024 HSB-22652: Support "Holzdolle" for Baufritz (merged from Markus) Marsel Nakuci
1.0 08.09.2021 HSB-12697: add description Author: Marsel Nakuci

This tsl creates a table with nr of "Hilti" instances used for each element (wal or floor)
User can select the TSL instances. TSL will only consider the following TSLs
HiltiDecke-Unten, HiltiDecke-Oben, Hilti-Verankerung, Hilti-Stockschraube

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords Hilti,Stexon,Report,HCW,HCWL,HSW
#BeginContents
/// <History>//region
// #Versions:
// 1.4 10/09/2024 HSB-22652: Support "Holzdolle" for Baufritz (merged from Markus) Marsel Nakuci
/// <version value="1.3" date="21.sep.2020" author="marsel.nakuci@hsbcad.com"> HSB-5432: fix wrong formatted translation keys </version>
/// <version value="1.2" date="26.jun.2019" author="marsel.nakuci@hsbcad.com"> add user defined command to add TSL(s) and differentiate BF-Stexon-Verankerung between d37 and d42 </version>
/// <version value="1.1" date="25.jun.2019" author="marsel.nakuci@hsbcad.com"> Include other TSL types as well </version>
/// <version value="1.0" date="25.jun.2019" author="marsel.nakuci@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select all where sTslAllowed TSL are located and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a table with nr of "Hilti" instances used for each element (wal or floor)
/// User can select the TSL instances. TSL will only consider the following TSLs
/// HiltiDecke-Unten, HiltiDecke-Oben, Hilti-Verankerung, Hilti-Stockschraube
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Hilti-Report")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion
	
	
//region constants 
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
	String sSpezial=projectSpecial();
	int bBaufritz=sSpezial.makeLower()=="baufritz";
//end constants//endregion
	
	
//region some global variables
// allowed TSL for selection
//	String sTslAllowed[] ={ "HiltiDecke", "BF-Dollen-Verbinder", "Hilti-Stockchraube", "Hilti-Verankerung"};	
	String sTslAllowed[] ={ "Hilti-Decke", "Hilti-Stockschraube", "Hilti-Verankerung"};	
	
//End some global variables//endregion 
	
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
//		else	
//			showDialog();

		// prompt for the selection of the TSLs
			Entity ents[0];
			PrEntity ssE(T("|Select tsl(s)|"), TslInst());
		  	if (ssE.go())
				ents.append(ssE.set());
			
		// prompt the insertion point of the table
			_Pt0 = getPoint(TN("|Pick insertion Point of the table|"));
			
		// include only the allowed TSL HiltiDecke TSL
		// loop tsls
		
			for (int i = ents.length() - 1; i >= 0; i--)
			{ 
				// it is one of the TSL in sTslAllowed
				TslInst tsl = (TslInst)ents[i];
				if (tsl.bIsValid())
				{ 
					if (sTslAllowed.find(tsl.scriptName()) >- 1)
					{ 
						// append it, collect the TSL
						_Entity.append(tsl);
//						reportMessage(TN("|tsl.scriptName(): |") + tsl.scriptName());
					}
				}
			}
			
		return;
	}
	
// end on insert	__________________//endregion
	
	
//region validate
	if (_Entity.length() < 1)
	{ 
		// no TSL found
		reportMessage("\n"+scriptName()+" "+T("|no TSL found|"));
		eraseInstance();
		return;
	}

//End validate//endregion
	
//region user defined command for adding new TSL
			
// Trigger addTSL//region
	String sTriggeraddTSL = T("|add other TSL(s)|");
	addRecalcTrigger(_kContext, sTriggeraddTSL );
	if (_bOnRecalc && (_kExecuteKey == sTriggeraddTSL))
	{
		// prompt for selection of the new TSL
		
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select TSL(s)|"), TslInst());
		if (ssE.go())
			ents.append(ssE.set());
			
		
	// add to the _Entity
	
		for (int i = ents.length() - 1; i >= 0; i--)
		{ 
			// it is one of the TSL in sTslAllowed
			TslInst tsl = (TslInst)ents[i];
			if (tsl.bIsValid())
			{ 
				if (sTslAllowed.find(tsl.scriptName()) >- 1)
				{ 
					if (_Entity.find(tsl) < 0)
					{ 
						// new TSL, append it
						_Entity.append(tsl);
					}
				}
			}
		}
		
		setExecutionLoops(2);
		return;
	}//endregion
	
//End user defined command for adding new TSL//endregion 
	
	
//region collect all TSL
	String sTslName = "HiltiDecke";
	TslInst tslHiltiDecke[0];
	// Array with all allowed TSL
	TslInst tslAllAllowed[0];
	
	for (int i=0;i<_Entity.length();i++) 
	{ 
		TslInst tsl=(TslInst)_Entity[i];
		if (sTslAllowed.find(tsl.scriptName()) >- 1)
		{ 
			// append it
			tslHiltiDecke.append(tsl);
			tslAllAllowed.append(tsl);
		}
	}//next i
	
	if (tslHiltiDecke.length() < 1)
	{ 
		// no HiltiDecke TSL found
		eraseInstance();
		return;
	}
	if (tslAllAllowed.length() < 1)
	{ 
		// no HiltiDecke TSL found
		eraseInstance();
		return;
	}
	
//End collect all TSL//endregion
//	return;
	
//region first collect all elements
	// contains numbers for all elements
	String sElNumbers[0];
	
	for (int i = 0; i < tslAllAllowed.length(); i++)
	{
//		TslInst tsl = tslHiltiDecke[i];
		TslInst tsl = tslAllAllowed[i];
		
		// get the element fro this TSL
		Entity ents[] = tsl.entity();
		Element el[0];
		ElementRoof eRoofs[0];
		for (int j = 0; j < ents.length(); j++)
		{
			Element e = (Element)ents[j];
			ElementRoof eR = (ElementRoof)ents[j];
			if (eR.bIsValid()&& eRoofs.find(eR)<0)
			{
				// collect all elements in the TSL
				eRoofs.append(eR);
			}
		}//next j
		
		if (eRoofs.length() > 1)
		{
			// more then 1 element found in the TSL, not allowed
			// a TSL must only be connected to one element
			reportMessage("\n"+scriptName()+" "+T("|unexpected error|"));
			reportMessage("\n"+scriptName()+" "+T("|TSL attached to more than one element|"));
			eraseInstance();
			return;
		}
		if (eRoofs.length() == 1)
		{
//			String sElNumber = el[0].number();
			String sElNumber = eRoofs[0].number();
			if (sElNumbers.find(sElNumber) < 0)
			{
				// Append to all element numbers
				sElNumbers.append(sElNumber);
				continue;
			}
		}
		if (eRoofs.length() < 1)
		{
			// no element in the TSL
			// TSL contains beams, so get the beam and from the beam get the element
			Beam beams[] = tsl.beam();
			if (beams.length() < 1)
			{ 
				reportMessage("\n"+scriptName()+" "+T("|TSL contains no element or beams|"));
				reportMessage("\n"+scriptName()+" "+T("|This TSL will be ignored and not be counted|"));
				// go to the next TSL
				continue;
//				eraseInstance();
//				return;
			}
			int iElementFound = false;
//			reportMessage(TN("|beams.length() |")+beams.length());
			
			for (int j = 0; j < beams.length(); j++)
			{ 
				Beam bm = beams[j];
				Element e = bm.element();
//				reportMessage(TN("|bm.element() |")+bm.element());
				
				if (e.bIsValid())
				{ 
					// element found
					String sElNumber = e.number();
					iElementFound = true;
					if (sElNumbers.find(sElNumber) < 0)
					{
						// Append to all element numbers
						sElNumbers.append(sElNumber);
//						reportMessage(TN("|sElNumber |")+sElNumber);
						// break the "j" loop
						break;
					}
				}
			}//next j
			if ( ! iElementFound)
			{ 
				reportMessage("\n"+scriptName()+" "+T("|no element attached to any of the beams in the TSL|"));
				reportMessage("\n"+scriptName()+" "+T("|This TSL will be ignored and not be counted|"));
				continue;
//				eraseInstance();
//				return;
			}
		}
	}

//End first collect all elements//endregion 
	
	
//region create the array of numbers "top" and numbers "bottom" corresponding to each element in the array
	// for each element there will be a number of HiltiDecke-Oben and a number of HiltiDecke-Unten
// array for nr of HiltiDecke-Oben
	int iNumbersTop[sElNumbers.length()];
// array for nr of HiltiDecke-Oben-Dolle
	int iNumbersTopDolle[sElNumbers.length()];	
// array for nr of HiltiDecke-Unten
	int iNumbersBottom[sElNumbers.length()];
	
// array for nr of BF-Dollen-Verbinder
	int iNumbersDollenVerbinder[sElNumbers.length()];
// array for nr of Hilti-Setzschraube
	int iNumbersStexonSetzschraube[sElNumbers.length()];
// array for nr of BF-Stexon-Verankerung diameter 37
	int iNumbersStexonVerankerung37[sElNumbers.length()];
// array for nr of BF-Stexon-Verankerung diameter 42
	int iNumbersStexonVerankerung42[sElNumbers.length()];
	
// initialize arrays with zeros
	for (int i = 0; i < sElNumbers.length(); i++)
	{ 
		iNumbersTop[i] = 0;
		iNumbersTopDolle[i] = 0;
		iNumbersBottom[i] = 0;
		iNumbersDollenVerbinder[i] = 0;
		iNumbersStexonSetzschraube[i] = 0;
		iNumbersStexonVerankerung37[i] = 0;
		iNumbersStexonVerankerung42[i] = 0;
	}//next i
	
	// 
	// will show the number of the TSL that are not considered because they were not attached to any element
	int iNrTslNotconsidered = 0;
	for (int i = 0; i < tslAllAllowed.length(); i++)
	{
		
		TslInst tsl = tslAllAllowed[i];
	// "BF-StexonDecke"
		if (tsl.scriptName() == "Hilti-Decke")
		{
			// opmName
			String sOpmName = tsl.opmName();
			//		reportMessage(TN("|sOpmName: |") + sOpmName);
			// HiltiDecke-Oben HiltiDecke-Unten
			
			// remove/le the first part "HiltiDecke", what remains is "Oben" or "Unten"
			sOpmName.trimLeft("Hilti-Decke-");
			//		reportMessage(TN("|sOpmName: |") + sOpmName);
			
			if (sOpmName != "Oben" && sOpmName != "Unten")
			{
				// tsl should have the opmkey either "Oben" or "Unten"
				reportMessage("\n"+scriptName()+" "+T("|unexpected error|") + " sOpmName: " + sOpmName);
				eraseInstance();
				return;
			}
			
			// get the element of this tsl to match it in the array of elements
			Entity ents[] = tsl.entity();
			Element el;
			
			for (int j = 0; j < ents.length(); j++)
			{
				Element e = (Element)ents[j];
				if (e.bIsValid())
				{
					// valid element
					el = e;
					// element found
					break;
				}
			}//next j
			if ( ! el.bIsValid())
			{ 
				
				reportMessage("\n"+scriptName()+" "+T("|unexpected error 1001|"));
			}
			
			// get nr of instances from the mapX
			Map mapX = tsl.subMapX("Public_Data");
			int iNr = mapX.getInt("nR");
			
			String sElNumber = el.number();
			// get the index of the element at the array sElNumbers
			int iElIndex = sElNumbers.find(sElNumber);
			if (iElIndex < 0)
			{
				reportMessage("\n"+scriptName()+" "+T("|unexpected error|") + " iElIndex: " + iElIndex);
				eraseInstance();
				return;
			}
			
			if (sOpmName == "Oben")
			{
				if(!bBaufritz)
				{
					iNumbersTop[iElIndex] += iNr;
				}
				else if(bBaufritz)
				{ 
					String sAuswahl = tsl.propString(T("|Reference Top|"));
					if (sOpmName == "Oben" && sAuswahl!="Holzdolle")
					{
						iNumbersTop[iElIndex] += iNr;
					}
					else if (sOpmName == "Oben" && sAuswahl=="Holzdolle")
					{
						iNumbersTopDolle[iElIndex] += iNr;
					}
					else if (sOpmName == "Unten")
					{
						iNumbersBottom[iElIndex] += iNr;
					}
				}
			}
			else if (sOpmName == "Unten")
			{
				if(!bBaufritz)
				{
					iNumbersBottom[iElIndex] += iNr;
				}
				else if(bBaufritz)
				{ 
					if (sOpmName == "Oben")
					{
						iNumbersTop[iElIndex] += iNr;
					}
					else if (sOpmName == "Unten")
					{
						iNumbersBottom[iElIndex] += iNr;
					}
				}
			}
		}
		else if (tsl.scriptName() == "Hilti-Verankerung")
		{ 
		// split with respect to the diameter of the stexons
		// it can have diameter d37 or d42
			Entity ents[] = tsl.entity();
			Element el;
			
			for (int j = 0; j < ents.length(); j++)
			{
				Element e = (Element)ents[j];
				if (e.bIsValid())
				{
					// valid element
					el = e;
					// element found
					break;
				}
			}//next j
			if ( ! el.bIsValid())
			{ 
				int iElementFound = false;
				// no element was found, get it from beams
				Beam beams[] = tsl.beam();
				if (beams.length() < 1)
				{ 
					reportMessage("\n"+scriptName()+" "+T("|TSL contains no element or beams|"));
					continue;
//					eraseInstance();
//					return;
				}
				for (int j = 0; j < beams.length(); j++)
				{ 
					Beam bm = beams[j];
					Element e = bm.element();
					if (e.bIsValid())
					{ 
						// element found
						el = e;
						iElementFound = true;
						break;
					}
				}//next j
				if ( ! iElementFound)
				{ 
					// count the TSL that are not attached to any element
					iNrTslNotconsidered += 1;
					continue;
	//				eraseInstance();
	//				return;
				}
			}
			
			String sElNumber = el.number();
			// get the index of the element at the array sElNumbers
			int iElIndex = sElNumbers.find(sElNumber);
			if (iElIndex < 0)
			{
				reportMessage("\n"+scriptName()+" "+T("|unexpected error|") + " iElIndex: " + iElIndex);
				eraseInstance();
				return;
			}
			
		// get the diameter
			double dDiameter = tsl.propDouble(T("|Diameter|"));
			if (abs(dDiameter - 37.0) < dEps)
			{ 
				// tsl of diameter 37, append to 37
				iNumbersStexonVerankerung37[iElIndex] += 1;
			}
			else if (abs(dDiameter - 42.0) < dEps)
			{ 
				// tsl of diameter 42, append to 42
				iNumbersStexonVerankerung42[iElIndex] += 1;
			}
			else
			{ 
				// other diameters are excluded
				reportMessage("\n"+scriptName()+" "+"Hilti-Decke " + T("|with diameter|")+dDiameter + " is excluded");
			}
		}
		else
		{ 
		// one of the rest TSL
		// get the element of this tsl to match it in the array of elements
			Entity ents[] = tsl.entity();
			Element el;
			
			for (int j = 0; j < ents.length(); j++)
			{
				Element e = (Element)ents[j];
				if (e.bIsValid())
				{
					// valid element
					el = e;
					// element found
					break;
				}
			}//next j
			if ( ! el.bIsValid())
			{ 
				int iElementFound = false;
				// no element was found, get it from beams
				Beam beams[] = tsl.beam();
				if (beams.length() < 1)
				{ 
					reportMessage("\n"+scriptName()+" "+T("|TSL contains no element or beams|"));
					continue;
//					eraseInstance();
//					return;
				}
				for (int j = 0; j < beams.length(); j++)
				{ 
					Beam bm = beams[j];
					Element e = bm.element();
					if (e.bIsValid())
					{ 
						// element found
						el = e;
						iElementFound = true;
						break;
					}
				}//next j
				if ( ! iElementFound)
				{ 
					iNrTslNotconsidered += 1;
					continue;
	//				eraseInstance();
	//				return;
				}
			}
			
			String sElNumber = el.number();
			// get the index of the element at the array sElNumbers
			int iElIndex = sElNumbers.find(sElNumber);
			if (iElIndex < 0)
			{
				reportMessage("\n"+scriptName()+" "+T("|unexpected error|") + " iElIndex: " + iElIndex);
				eraseInstance();
				return;
			}
			
			// see which TSL it is
			if (tsl.scriptName() == "BF-Dollen-Verbinder")
			{ 
				iNumbersDollenVerbinder[iElIndex] += 1;
			}
			else if (tsl.scriptName() == "Hilti-Stockschraube")
			{ 
				iNumbersStexonSetzschraube[iElIndex] += 1;
			}
			else
			{ 
			// normally is imposible
				reportMessage("\n"+scriptName()+" "+T("|unexpected error|") + "tsl.scriptName(): " + tsl.scriptName());
				eraseInstance();
				return;
			}
		}
	}//next i
	
	if (iNrTslNotconsidered > 0)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|There were| ")+iNrTslNotconsidered + T(" |TSL not considered because not belonging to any element| "));
	}
	
//End create the array of numbers "top" and numbers "below" corresponding to each element in the array//endregion 
	
	
//region Display, create table with the Data
// Each HiltiDecke TSL has one element
// there is a one to one correspondence
	int iNrElements = sElNumbers.length();
// nr columns the table will have
	int iNrColums = 0;
// for visualisation
	double dTextHeight = U(100);
	Display dp(7);

// with the arrays sElNumbers, iNumbersTop, iNumbersBottom create the table
// summ for iNumbersTop, iNumbersBottom
	int iSummNumbersTop = 0;
	int iSummNumbersTopDolle = 0;
	int iSummNumbersBottom = 0;
	
	int iSummNumbersDollenVerbinder = 0;
	int iSummNumbersStexonSetzschraube = 0;
	int iSummNumbersStexonVerankerung37 = 0;
	int iSummNumbersStexonVerankerung42 = 0;
	
	for (int i = 0; i < iNrElements; i++)
	{ 
		iSummNumbersTop += iNumbersTop[i];
		if(bBaufritz)
		{
			iSummNumbersTopDolle += iNumbersTopDolle[i];
		}
		iSummNumbersBottom += iNumbersBottom[i];
		
		iSummNumbersDollenVerbinder += iNumbersDollenVerbinder[i];
		iSummNumbersStexonSetzschraube += iNumbersStexonSetzschraube[i];
		iSummNumbersStexonVerankerung37 += iNumbersStexonVerankerung37[i];
		iSummNumbersStexonVerankerung42 += iNumbersStexonVerankerung42[i];
	}//next i
	
	int iSummTotal = iSummNumbersTop + iSummNumbersBottom + iSummNumbersDollenVerbinder
	 	 + iSummNumbersStexonSetzschraube + iSummNumbersStexonVerankerung37 + iSummNumbersStexonVerankerung42;
	 	
	if(!bBaufritz) 
	{ 
		if (iSummTotal < 1)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|No TSL to be counted|"));
			eraseInstance();
			return;
		}
	}
// draw lines of the table
// width of first column as iColWidth1*dTextHeight

	int iColWidth1 = 6;
	double iColWidth2 = 9.5;
	int iColWidthTot = 2 * iColWidth2 + iColWidth1;
	
// column lines
	Point3d pt1 = _Pt0;
	Point3d pt2 = _Pt0 - _YW * (iNrElements + 2) * dTextHeight;
	
	LineSeg lSeg(pt1, pt2);
	dp.draw(lSeg);

// column Element
	lSeg.transformBy(_XW * dTextHeight * iColWidth1);
	dp.draw(lSeg);

// column description
	Point3d ptText;
	String sText;
	Point3d ptTextTop = _Pt0;
	// move it a little bit from the corner
	ptTextTop += 0.2 * dTextHeight * _XW - 0.5 * dTextHeight * _YW;
	ptText = ptTextTop;
	
	sText = "Element Nr.";
	dp.draw(sText, ptText, _XW, _YW, 1, 0);
	// elements
	for (int i = 0; i < iNrElements; i++)
	{ 
		ptText.transformBy(-_YW * dTextHeight);
		String sText = sElNumbers[i];
		dp.draw(sText, ptText, _XW, _YW, 1, 0);
	}
	// Summe
	ptText.transformBy(-_YW * dTextHeight);
	sText = "Summe";
	dp.draw(sText, ptText, _XW, _YW, 1, 0);
	
//  position ptTextTop
	ptTextTop += (iColWidth1 - iColWidth2) * _XW * dTextHeight;
	if (iSummNumbersTop > 0)
	{ 
		// count nr of columns
		iNrColums += 1;
		// column line
		lSeg.transformBy(_XW * dTextHeight * iColWidth2);
		dp.draw(lSeg);
		// column description Oben
		ptTextTop += iColWidth2 * dTextHeight * _XW;
		ptText = ptTextTop;
		sText = "Decke-Oben";
		dp.draw(sText, ptText, _XW, _YW, 1, 0);
		// data for each element
		
		ptText.transformBy(_XW * iColWidth2 * 0.9 * dTextHeight);
		for (int i = 0; i < iNrElements; i++)
		{ 
			ptText.transformBy(-_YW * dTextHeight);
			String sText = iNumbersTop[i];
			dp.draw(sText, ptText, _XW, _YW, -1, 0);
		}
		// Summe
		ptText.transformBy(-_YW * dTextHeight);
		String sText = iSummNumbersTop;
		dp.draw(sText, ptText, _XW, _YW, -1, 0);
	}
	if(bBaufritz)
	{ 
		if (iSummNumbersTopDolle > 0)
		{ 
			// count nr of columns
			iNrColums += 1;
			// column line
			lSeg.transformBy(_XW * dTextHeight * iColWidth2);
			dp.draw(lSeg);
			// column description Oben
			ptTextTop += iColWidth2 * dTextHeight * _XW;
			ptText = ptTextTop;
			sText = "Decke-Oben-Dollen";
			dp.draw(sText, ptText, _XW, _YW, 1, 0);
			// data for each element
			
			ptText.transformBy(_XW * iColWidth2 * 0.9 * dTextHeight);
			for (int i = 0; i < iNrElements; i++)
			{ 
				ptText.transformBy(-_YW * dTextHeight);
				String sText = iNumbersTopDolle[i];
				dp.draw(sText, ptText, _XW, _YW, -1, 0);
			}
			// Summe
			ptText.transformBy(-_YW * dTextHeight);
			String sText = iSummNumbersTopDolle;
			dp.draw(sText, ptText, _XW, _YW, -1, 0);
		}
	}
	if (iSummNumbersBottom > 0)
	{ 
		// count nr of columns
		iNrColums += 1;
		// column line
		lSeg.transformBy(_XW * dTextHeight * iColWidth2);
		dp.draw(lSeg);
		// column description Oben
		ptTextTop += iColWidth2 * dTextHeight * _XW;
		ptText = ptTextTop;
		sText = "Decke-Unten";
		dp.draw(sText, ptText, _XW, _YW, 1, 0);
		// data for each element
		
		ptText.transformBy(_XW * iColWidth2 * 0.9 * dTextHeight);
		for (int i = 0; i < iNrElements; i++)
		{ 
			ptText.transformBy(-_YW * dTextHeight);
			String sText = iNumbersBottom[i];
			dp.draw(sText, ptText, _XW, _YW, -1, 0);
		}
		// Summe
		ptText.transformBy(-_YW * dTextHeight);
		String sText = iSummNumbersBottom;
		dp.draw(sText, ptText, _XW, _YW, -1, 0);
	}
	if (iSummNumbersDollenVerbinder > 0)
	{ 
		// count nr of columns
		iNrColums += 1;
		// column line
		lSeg.transformBy(_XW * dTextHeight * iColWidth2);
		dp.draw(lSeg);
		// column description Oben
		ptTextTop += iColWidth2 * dTextHeight * _XW;
		ptText = ptTextTop;
//		sText = "Dollen-Verbinder";
		sText = "Wandverbinder";
		
		dp.draw(sText, ptText, _XW, _YW, 1, 0);
		// data for each element
		
		ptText.transformBy(_XW * iColWidth2 * 0.9 * dTextHeight);
		for (int i = 0; i < iNrElements; i++)
		{ 
			ptText.transformBy(-_YW * dTextHeight);
			String sText = iNumbersDollenVerbinder[i];
			dp.draw(sText, ptText, _XW, _YW, -1, 0);
		}
		// Summe
		ptText.transformBy(-_YW * dTextHeight);
		String sText = iSummNumbersDollenVerbinder;
		dp.draw(sText, ptText, _XW, _YW, -1, 0);
	}
	if (iSummNumbersStexonSetzschraube > 0)
	{ 
		// count nr of columns
		iNrColums += 1;
		// column line
		lSeg.transformBy(_XW * dTextHeight * iColWidth2);
		dp.draw(lSeg);
		// column description Oben
		ptTextTop += iColWidth2 * dTextHeight * _XW;
		ptText = ptTextTop;
//		sText = "Stexon-Setzschraube";
//		sText = "Setzschraube";
		sText = "Hanger bolt HSW";
		
		dp.draw(sText, ptText, _XW, _YW, 1, 0);
		// data for each element
		
		ptText.transformBy(_XW * iColWidth2 * 0.9 * dTextHeight);
		for (int i = 0; i < iNrElements; i++)
		{ 
			ptText.transformBy(-_YW * dTextHeight);
			String sText = iNumbersStexonSetzschraube[i];
			dp.draw(sText, ptText, _XW, _YW, -1, 0);
		}
		// Summe
		ptText.transformBy(-_YW * dTextHeight);
		String sText = iSummNumbersStexonSetzschraube;
		dp.draw(sText, ptText, _XW, _YW, -1, 0);
	}
	if (iSummNumbersStexonVerankerung37 > 0)
	{ 
		// count nr of columns
		iNrColums += 1;
		// column line
		lSeg.transformBy(_XW * dTextHeight * iColWidth2);
		dp.draw(lSeg);
		// column description Oben
		ptTextTop += iColWidth2 * dTextHeight * _XW;
		ptText = ptTextTop;
//		sText = "Stexon-Verankerung";
//		sText = "Verankerung d37";
		sText = "Wood coupler HCW";
		
		dp.draw(sText, ptText, _XW, _YW, 1, 0);
		// data for each element
		
		ptText.transformBy(_XW * iColWidth2 * 0.9 * dTextHeight);
		for (int i = 0; i < iNrElements; i++)
		{ 
			ptText.transformBy(-_YW * dTextHeight);
			String sText = iNumbersStexonVerankerung37[i];
			dp.draw(sText, ptText, _XW, _YW, -1, 0);
		}
		// Summe
		ptText.transformBy(-_YW * dTextHeight);
		String sText = iSummNumbersStexonVerankerung37;
		dp.draw(sText, ptText, _XW, _YW, -1, 0);
	}
	if (iSummNumbersStexonVerankerung42 > 0)
	{ 
		// count nr of columns
		iNrColums += 1;
		// column line
		lSeg.transformBy(_XW * dTextHeight * iColWidth2);
		dp.draw(lSeg);
		// column description Oben
		ptTextTop += iColWidth2 * dTextHeight * _XW;
		ptText = ptTextTop;
//		sText = "Stexon-Verankerung";
//		sText = "Verankerung d42";
		sText = "Wood coupler HCWL";
		
		dp.draw(sText, ptText, _XW, _YW, 1, 0);
		// data for each element
		
		ptText.transformBy(_XW * iColWidth2 * 0.9 * dTextHeight);
		for (int i = 0; i < iNrElements; i++)
		{ 
			ptText.transformBy(-_YW * dTextHeight);
			String sText = iNumbersStexonVerankerung42[i];
			dp.draw(sText, ptText, _XW, _YW, -1, 0);
		}
		// Summe
		ptText.transformBy(-_YW * dTextHeight);
		String sText = iSummNumbersStexonVerankerung42;
		dp.draw(sText, ptText, _XW, _YW, -1, 0);
	}
	
// draw lines of rows
	LineSeg lSegRow(_Pt0, _Pt0 + _XW * (iColWidth1 + iColWidth2*iNrColums) * dTextHeight);
	dp.draw(lSegRow);
	
	lSegRow.transformBy(-_YW * dTextHeight);
	dp.draw(lSegRow);
	
	for (int i = 0; i < iNrElements; i++)
	{ 
		lSegRow.transformBy(-_YW * dTextHeight);
		dp.draw(lSegRow);
	}//next i
	
	lSegRow.transformBy(-_YW * dTextHeight);
	dp.draw(lSegRow);
//End Display, create table with the Data//endregion 

#End
#BeginThumbnail






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
      <str nm="Comment" vl="HSB-22652: Support &quot;Holzdolle&quot; for Baufritz" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="9/10/2024 9:56:53 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12697: add description" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="9/8/2021 11:29:38 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End