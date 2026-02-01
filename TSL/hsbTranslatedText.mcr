#Version 8
#BeginDescription
version value="1.2" date="11sep17" author="thorsten.huck@hsbCAD.com"
supports multiple custom languages, requires hsbMultiLanguage

 
EN
/// This TSL translates the given string into the current language if the text in embraced with vertikal pipes'||'.
/// Sample: |Beam| 
/// 	English: 'Beam'
/// 	German: 'Stab'
///	...

DACH
/// Dieses TSL übersetzt den eingegebenen Text in die aktuelle Sprache, wenn der Text mit vertikalen Strichen '||' eingeschlossen wurde.
/// Beispiel: der übersetzte Text von |Beam| lautet 'Stab'



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Dieses TSL übersetzt den eingegebenen Text in die aktuelle Sprache, wenn der Text mit vertikalen Strichen '||' eingeschlossen wurde.
/// Beispiel: der übersetzte Text von |Beam| lautet 'Stab'
/// </summary>

/// <summary Lang=en>
/// This TSL translates the given string into the current language if the text in embraced with vertikal pipes'||'.
/// Sample: |Beam| 
/// 	English: 'Beam'
/// 	German: 'Stab'
///	...
/// </summary>


/// <insert Lang>
/// Pick insertion point and enter properties
/// </insert>

/// History
///<version value="1.2" date="11sep17" author="thorsten.huck@hsbCAD.com"> supports multiple custom languages, requires hsbMultiLanguage </version>
///<version value="1.1" date="02jun15" author="thorsten.huck@hsbCAD.com"> new alignment properties </version>
///<version value="1.0" date="09jan12" author="th@hsbCAD.de"> initial </version>

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

// general	
	PropString sTxt(0,"",T("|Text|") +" " +  T("(Embrace with|") + " " + "||" + " " + T("to translate)"));	
	sTxt.setCategory(category);
	PropString sPrefix(1,"",T("|Prefix|"));
	sPrefix.setCategory(category);
	PropString sSuffix(2,"",T("|Suffix|"));	
	sSuffix.setCategory(category);

// alignment
	category= T("|Alignment|");
	String sHorAlignments[] = {T("|Left|"),T("|Center|"),T("|Right|")};
	PropString sHorAlignment(3,sHorAlignments,T("|Alignment|"));			
	sHorAlignment.setCategory(category);
	
	String sArOrient[] = {T("|Horizontal|"),T("|Vertical|")};
	PropString sOrient(4,sArOrient,T("|XY-Orientation|"));
	sOrient.setCategory(category);
	
	String sVerAlignments[] = {T("|Bottom|"),T("|Center|"),T("|Top|")};
	PropString sVerAlignment(6,sVerAlignments,T("|Vertical|"),1);
	sVerAlignment.setCategory(category);

// language mode
	category= T("|Language|");
	String sLanguageModeName=category;	
	String sLanguageModes[] =
	{
		T("|Current|"),
		T("|Custom|") + " 1",
		T("|Custom|") + " 2",
		T("|Custom|") + " 1+2"
	};
	PropString sLanguageMode(7, sLanguageModes, sLanguageModeName);	
	sLanguageMode.setDescription(T("|Defines the Language Mode|") + " " + T("|You can specify additional or alternative languages by using hsbMultiLanguage.mcr.|"));
	sLanguageMode.setCategory(category);
	
	
	
	
	
// display
	category= T("|Display|");
// order dimstyles
	String sDimStyles[0];sDimStyles = _DimStyles;
	for (int i=0;i<sDimStyles.length();i++)
		for (int j=0;j<sDimStyles.length()-1;j++)
			if (sDimStyles[j]>sDimStyles[j+1])
				sDimStyles.swap(j,j+1);
	PropString sDimStyle(5,sDimStyles,T("|Dimstyle|"));
	sDimStyle.setCategory(category);

	PropDouble dTxtH(0,U(20),T("|Text Height|"));
	dTxtH.setCategory(category);	
	
	PropInt nColor(0, 251, T("|Color|"));		
	nColor.setCategory(category);


// collect custom languages in mapObject
	String sDictionary = "hsbTSL";
	MapObject mo(sDictionary , "Languages");
	String sLanguages[0];
	if (mo.bIsValid())
	{ 
		setDependencyOnDictObject(mo);
		Map m= mo.map();
		for (int i=0;i<m.length();i++) 
		{ 
			String sLanguage = m.getString(i);
			sLanguages.append(sLanguage); 
		}
	}


// on insert
	if(_bOnInsert) 
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		showDialog();
		_Pt0 = getPoint(); // select point
		_XE=_XU;
		_YE = _YU;
		return;
	}
//end on insert________________________________________________________________________________

// ints
	int nOrient= sArOrient.find(sOrient,0);
	int nLanguageMode = sLanguageModes.find(sLanguageMode);
	
// alignment flags
	double dXFlag = sHorAlignments.find(sHorAlignment)-1;
	double dYFlag = sVerAlignments.find(sVerAlignment)-1;


// the display	
	Display dp(nColor);
	dp.dimStyle(sDimStyle);
	dp.textHeight(dTxtH);
	
// text orientation	
	Vector3d vxTxt=_XE,vyTxt=_YE;
	if (nOrient==1)
	{
		vxTxt = _YE;
		vyTxt = -_XE;	
	}
		
// draw	
	String sLangTxt;
	if (nLanguageMode==1 && sLanguages.length()>0) // custom language 1
		sLangTxt= T(sTxt, sLanguages[0]);
	else if (nLanguageMode==2 && sLanguages.length()>1) // custom language 2
		sLangTxt= T(sTxt, sLanguages[1]);
	else if (nLanguageMode==3 && sLanguages.length()>1) // custom language 1+2
		sLangTxt= T(sTxt, sLanguages[0]) + "/" + T(sTxt, sLanguages[1]);
	else
		sLangTxt= T(sTxt); // current language
	
	if (sPrefix.length()>0) sLangTxt = sPrefix + sLangTxt;
	if (sSuffix.length()>0) sLangTxt = sLangTxt  + sSuffix;
	
	dp.draw(sLangTxt,_Pt0,vxTxt ,vyTxt ,dXFlag ,dYFlag );





#End
#BeginThumbnail
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
'<"IZ*`/_V3ZY
`

#End