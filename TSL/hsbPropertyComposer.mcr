#Version 8
#BeginDescription
#Versions
Version 1.4 04.06.2024 HSB-22203 debug bugfix
Version 1.3 04.06.2024 HSB-22203 replacement strings added
Version 1.2 08.05.2024 HSB-22051 accepting definitions without replacements
Version 1.1 26.04.2022 HSB-15331 bugfix replacing values

This tsl composes a target property by given source properties 


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/// <History>//region
// #Versions
// 1.4 05.06.2024 HSB-22203 debug bugfix , Author Thorsten Huck
// 1.3 04.06.2024 HSB-22203 replacement strings added , Author Thorsten Huck
// 1.2 08.05.2024 HSB-22051 accepting definitions without replacements , Author Thorsten Huck
// 1.1 26.04.2022 HSB-15331 bugfix replacing values , Author Thorsten Huck

/// <version value="1.0" date="01Oct2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select genbeam(s), select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl composes a target property by given source properties 
/// </summary>//endregion

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

	category = T("|Source|");
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
	sFormat.setDefinesFormatting("GenBeam");

	
	sFormat.setCategory(category);


	String sModes[] ={ T("|Erase|"),T("|Keep|")};
	String sModeName=T("|Property(s)|");	
	PropString sMode(nStringIndex++, sModes, sModeName,1);	
	sMode.setDescription(T("|Defines whether the source properties are kept or cleared.|"));
	sMode.setCategory(category);

	category = T("|Target|");
	// target	
	String sProperties[] =
	{
		T("|Name|"),
		T("|Material|"),
		T("|Information|"),
		T("|Label|"),
		T("|Grade|"),
		T("|Sublabel|"),
		T("|Sublabel2|")
	};

	String sPropertyName=T("|Property|");	
	PropString sProperty(nStringIndex++, sProperties, sPropertyName);	
	sProperty.setDescription(T("|Defines the property to be modified.|"));
	sProperty.setCategory(category);
	
	String sReplaceName=T("|Replace|");	
	PropString sReplace(nStringIndex++, "", sReplaceName);	
	sReplace.setDescription(T("|Defines the replacement of characters.|") + T(" |Empty = no replacement|") + T(" |Separate source and target by a semicolon.|"));
	sReplace.setCategory(category);





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
		
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select entity(s)|")+ T(" |<Enter> to insert setup instance|"), GenBeam());
		if (ssE.go())
			ents.append(ssE.set());
		for (int i=0;i<ents.length();i++) 
			_GenBeam.append((GenBeam)ents[i]); 
		
	// nothing selected, go for setup
		if (_GenBeam.length()<1)
		{ 
			_Pt0 = getPoint();
			_GenBeam.append(getGenBeam());
			_Map.setInt("setup", 1);
		}
	
		return;
	}	
// end on insert	__________________//endregion	


// get mode
	int bSetup= _Map.getInt("setup");

// target
	int nTarget = sProperties.find(sProperty);
	
// clear mode
	int nMode = sModes.find(sMode);
	
// loop genbeams
	for (int g=0;g<_GenBeam.length();g++) 
	{ 
		GenBeam& gb = _GenBeam[g]; 			
		String sValue = gb.formatObject(sFormat);
		String source = gb.formatObject(sFormat);
		
		String sTokens[] = sReplace.tokenize(";");
		int bModify = sTokens.length()<2 && nMode==1;
		for (int i=0;i<sTokens.length();i=i+2) 
		{ 
			String s1 = sTokens[i]; 
			String s2;
			if (sTokens.length()>i+1)
				s2 = sTokens[i + 1];
			int numReplace = s1.length();
			
		// replace character by character
			int nCnt = sValue.length();
			int nFound = sValue.find(s1, 0);
			while (nCnt>0 && nFound>-1)
			{ 
				int numChar = sValue.length();
				String sLeft = sValue.left(nFound);
				String sRight= sValue.right(numChar-nFound-numReplace);
				sValue = sLeft + s2 + sRight;
				nFound = sValue.find(s1, 0);
				nCnt--;
				bModify = true;
			}
		}//next i
		
	// setup mode
		if (bSetup)
		{ 
		// Display
			Display dp(-1);
			dp.textHeight(U(60));
			Point3d ptTxt = _Pt0;
			double dYFlag;	
			
			if (bModify)
				dp.draw(source + " -> " + sValue, ptTxt, _XU, _YU, 1, 3, _kDevice);
			else
				dp.draw(source + T("|<No Match>|"), ptTxt, _XU, _YU, 1, 3, _kDevice);
			dp.textHeight(U(40));
			dp.draw(sFormatName+": " + sFormat, ptTxt, _XU, _YU, 1, 0, _kDevice);
			dp.draw(sPropertyName+": " + sProperty, ptTxt, _XU, _YU, 1, -3, _kDevice);				
				
		}
	// write to target	
		else
		{ 	

		// clear source if standard property can be found in format string
			if (nMode==0)
			{
				for (int i=0;i<sProperties.length();i++) 
				{ 
					int n=sFormat.find(sProperties[i],0,false); 
					if (n < 0)continue;
					if ( i == 0)gb.setName("");
					else if ( i == 1) gb.setMaterial("");
					else if ( i == 2) gb.setInformation("");
					else if ( i == 3) gb.setLabel("");
					else if ( i == 4) gb.setGrade("");
					else if ( i == 5) gb.setSubLabel("");
					else if ( i == 6) gb.setSubLabel2("");	 
				}//next i	
			}
		
		// write to target property
			if (bModify)
			{ 
				if (nTarget == 0)gb.setName(sValue);
				else if (nTarget == 1) gb.setMaterial(sValue);
				else if (nTarget == 2) gb.setInformation(sValue);
				else if (nTarget == 3) gb.setLabel(sValue);
				else if (nTarget == 4) gb.setGrade(sValue);
				else if (nTarget == 5) gb.setSubLabel(sValue);
				else if (nTarget == 6) gb.setSubLabel2(sValue);					
			}


		}
	}//next g		


	if (!bDebug && !bSetup)
	{ 
		eraseInstance();
		return;
	}

	



#End
#BeginThumbnail
M_]C_X``02D9)1@`!``$`8`!@``#__@`?3$5!1"!496-H;F]L;V=I97,@26YC
M+B!6,2XP,0#_VP"$``("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("
M`@("`@,#`@(#`@("`P0#`P,#!`0$`@,$!`0$!`,$!`,!`@("`@("`@("`@,"
M`@(#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#
M`P,#`P,#`__$`:(```$%`0$!`0$!```````````!`@,$!08'"`D*"P$``P$!
M`0$!`0$!`0````````$"`P0%!@<("0H+$``"`0,#`@0#!04$!````7T!`@,`
M!!$%$B$Q008346$'(G$4,H&1H0@C0K'!%5+1\"0S8G*""0H6%Q@9&B4F)R@I
M*C0U-C<X.3I#1$5&1TA)2E-455976%E:8V1E9F=H:6IS='5V=WAY>H.$A8:'
MB(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4U=;7
MV-G:X>+CY.7FY^CIZO'R\_3U]O?X^?H1``(!`@0$`P0'!00$``$"=P`!`@,1
M!`4A,08205$'87$3(C*!"!1"D:&QP0DC,U+P%6)RT0H6)#3A)?$7&!D:)B<H
M*2HU-C<X.3I#1$5&1TA)2E-455976%E:8V1E9F=H:6IS='5V=WAY>H*#A(6&
MAXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&Q\C)RM+3U-76
MU]C9VN+CY.7FY^CIZO+S]/7V]_CY^O_``!$(`2P!D`,!$0`"$0$#$0'_V@`,
M`P$``A$#$0`_`/W\H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
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
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
70`4`%`!0`4`%`!0`4`%`!0`4`%`'_]D`




#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="203" />
        <int nm="BreakPoint" vl="217" />
        <int nm="BreakPoint" vl="176" />
        <int nm="BreakPoint" vl="164" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
     <lst nm="Version">
      <str nm="Comment" vl="HSB-22203 debug bugfix" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="6/5/2024 2:43:55 PM" />
    </lst> 
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22203 replacement strings added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="6/4/2024 2:43:55 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22051 accepting definitions without replacements" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="5/8/2024 4:55:44 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15331 bugfix replacing values" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="4/26/2022 11:52:33 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End