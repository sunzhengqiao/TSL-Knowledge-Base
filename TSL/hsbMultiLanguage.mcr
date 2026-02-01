#Version 8
#BeginDescription
version value="1.1" date="11Sep2017" author="thorsten.huck@hsbcad.com"> l
anguages alphabetically ordered

This tsl stores up to 2 alternative languages in the autocad database to be used for special shopdrawings etc.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <History>//region
/// <version value="1.1" date="11Sep2017" author="thorsten.huck@hsbcad.com"> languages alphabetically ordered </version>
/// <version value="1.0" date="18Aug2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl stores up to 2 alternative languages in the autocad database to be used for special shopdrawings etc.
/// </summary>//endregion


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
	String sDisabled = T(" |Disabled|");	
	//endregion

// Languages
	String sLanguages[] ={sDisabled,T("|Bulgarian|"),T("|Croatian|"),T("|Czech|"),T("|Danish|"),T("|Dutch|"),
		T("|English|"),T("|Estonian|"),T("|Finish|"),T("|Frensch|"),T("|German|"),
		T("|Greek|"), T("|Hungarian|"), T("|Italian|"), T("|Japanese|"),T("|Korean|"),
		T("|Lithuanian|"),T("|Norwegian|"),T("|Polish|"),T("|Portuguese|"),T("|Romanian|"),
		T("|Russsian|"),T("|Slovak|"),T("|Slovenian|"),T("|Spanish|"),T("|Swedish|"),
		T("|Turkish|"),	T("|Ukranian|"),T("|Manadarin|")};
	String sLangShorts[] ={"","BG","HR","CS","DA","NL",
		"EN", "ET", "FI", "FR", "DE",
		"EL", "HU", "IT", "JA", "KO",
		"LT", "NO", "PL", "PT", "RO",
		"RU", "SK", "SL", "ES", "SV", 
		"TR", "UK", "ZH-CHS"};

// order alphabetically
	if (sLanguages.length()!=sLangShorts.length())
	{ 
		reportMessage(TN("|Language definitions are not valid!|"));
		eraseInstance();
		return;
		
	}
	for (int i=1;i<sLanguages.length();i++) 
	{ 
		for (int j=1;j<sLanguages.length()-1;j++)
			if (sLanguages[j]>sLanguages[j+1])
			{ 
				sLanguages.swap(j, j + 1);
				sLangShorts.swap(j, j + 1);
			}
	}
	

// Properties
	category = T("|Languages|");
	String sLanguage1Name=T("|Primary Language|");	
	PropString sLanguage1(nStringIndex++, sLanguages, sLanguage1Name);	
	sLanguage1.setDescription(T("|Defines the primary Language|"));
	sLanguage1.setCategory(category);

	String sLanguage2Name=T("|Secondary Language|");	
	PropString sLanguage2(nStringIndex++, sLanguages, sLanguage2Name);	
	sLanguage2.setDescription(T("|Defines the primary Language|"));
	sLanguage2.setCategory(category);


// bOnInsert
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1) { eraseInstance(); return; }
		
		// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		
		if (sKey.length() > 0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for (int i = 0; i < sEntries.length(); i++)
				sEntries[i] = sEntries[i].makeUpper();
			if (sEntries.find(sKey) >- 1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);
		}
		else
			showDialog();

		// ints
		int nLanguage1 = sLanguages.find(sLanguage1);
		int nLanguage2 = sLanguages.find(sLanguage2);
		
		// the language mapObject
		String sDictionary = "hsbTSL";
		MapObject mo(sDictionary , "Languages");
		
		// erase setting if both languages are disabled
		int bErase = nLanguage1 < 1 && nLanguage2 < 1;
		if (bErase && mo.bIsValid())
		{
			mo.dbErase();
			eraseInstance();
			return;
		}
		String sShortLang1 = nLanguage1 >- 1 ? sLangShorts[nLanguage1] : "";
		String sShortLang2 = nLanguage2 >- 1 ? sLangShorts[nLanguage2] : "";
		if (sShortLang1 == "")
		{
			sShortLang1 = sShortLang2;
			sShortLang2 = "";
		}
		
	// Output languages
		Map mapLanguage;
		if (sShortLang1.length()>0) mapLanguage.appendString("Language", sShortLang1);
		if (sShortLang2.length()>0) mapLanguage.appendString("Language", sShortLang2);
		if (mapLanguage.length()>0)
		{
			if (mo.bIsValid())
				mo.setMap(mapLanguage);
			else
				mo.dbCreate(mapLanguage);	
		}
		else if (mo.bIsValid())
		{
			mo.dbErase();
		}

		eraseInstance();
		return;
	}	
// end on insert	__________________
#End
#BeginThumbnail
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
FY.XL==U3:MRJ*BG(!90!^7-=)90M;6,$#$%HXPI(Z<"K%%`'_]GU
`


#End