#Version 8
#BeginDescription
version value="1.0" date="21Sep2017" author="thorsten.huck@hsbcad.com"
initial

This tsl swaps / replaces the selected properties of a set of genbeams
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
/// <version value="1.0" date="21Sep2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select genbeam(s), select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl swaps / replaces the selected properties of a set of genbeams
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
	//endregion


// list of supported properties
	// Source
	String sSourceProperties[] =
	{
		T("|Posnum|"),
		T("|Name|"),
		T("|Material|"),
		T("|Information|"),
		T("|Label|"),
		T("|Grade|"),
		T("|Sublabel|"),
		T("|Sublabel2|")
	};
	int nSourceIndices[0];
	for (int i=0;i<sSourceProperties.length();i++) 
		nSourceIndices.append(i); 
	
	// target	
	String sTargetProperties[] =
	{
		T("|Name|"),
		T("|Material|"),
		T("|Information|"),
		T("|Label|"),
		T("|Grade|"),
		T("|Sublabel|"),
		T("|Sublabel2|")
	};
	int nTargetIndices[0];
	for (int i=0;i<sTargetProperties.length();i++) 
		nTargetIndices.append(i);
	
	// order arrays
	for (int i=0;i<sSourceProperties.length();i++) 
	{ 
		for (int j=0;j<sSourceProperties.length()-1;j++) 
		{ 
			if(sSourceProperties[j]>sSourceProperties[j+1])
			{
				sSourceProperties.swap(j,j+1);
				nSourceIndices.swap(j,j+1);
			}
			 
		} 
	}
	
	// order arrays
	for (int i=0;i<sTargetProperties.length();i++) 
	{ 
		for (int j=0;j<sTargetProperties.length()-1;j++) 
		{ 
			if(sTargetProperties[j]>sTargetProperties[j+1])
			{
				sTargetProperties.swap(j,j+1);
				nTargetIndices.swap(j,j+1);
			}
			 
		} 
	}

	String sSourceName=T("|Source|");	
	PropString sSource(nStringIndex++, sSourceProperties, sSourceName);	
	sSource.setDescription(T("|Defines the Source|"));
	sSource.setCategory(category);
	
	String sTargetName=T("|Target|");	
	PropString sTarget(nStringIndex++, sTargetProperties, sTargetName);	
	sTarget.setDescription(T("|Defines the Target|"));
	sTarget.setCategory(category);
	
	String sPrefixName=T("|Prefix|");	
	PropString sPrefix(nStringIndex++, "", sPrefixName);	
	sPrefix.setDescription(T("|Defines the Prefix|"));
	sPrefix.setCategory(category);

	String sModes[] ={ T("|Overwrite|"), T("|Overwrite and clear source|"),T("|Swap Values|")};
	String sModeName=T("|Mode|");	
	PropString sMode(nStringIndex++, sModes, sModeName);	
	sMode.setDescription(T("|Defines whether the source is kept, cleared or whether source and target are swapped.|"));
	sMode.setCategory(category);





// bOnInsert
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
		{
			if (sSource==sTarget)
			{ 
				int nTarget = sTargetProperties.find(sTarget, 0);
				nTarget = nTarget < sTargetProperties.length() - 1 ? nTarget + 1 : 0;
				sTarget.set(sTargetProperties[nTarget]);
			}
			showDialog();
		}
	
	// done if same property selected
		if (sSource==sTarget)
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|Please select different properties of source and target.|"));
			
			eraseInstance();
			return;
		}
	
	// get mode and indices of properties
		int nMode = sModes.find(sMode, 0);
		int nSource = nSourceIndices[sSourceProperties.find(sSource, 0)];
		int nTarget = nTargetIndices[sTargetProperties.find(sTarget, 0)];
		
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select genbeam(s)"), GenBeam());
	  	if (ssE.go())
			ents.append(ssE.set());
		
	// loop entities
		for (int i=0;i<ents.length();i++) 
		{ 
			GenBeam gb= (GenBeam)ents[i];
			if (!gb.bIsValid())continue;
			
			String sSourceText, sTargetText;;
			

			if (nSource == 0)sSourceText = gb.posnum();
			else if (nSource == 1)sSourceText = gb.name();
			else if (nSource == 2)sSourceText = gb.material();
			else if (nSource == 3)sSourceText = gb.information();
			else if (nSource == 4)sSourceText = gb.label();
			else if (nSource == 5)sSourceText = gb.grade();
			else if (nSource == 6)sSourceText = gb.subLabel();
			else if (nSource == 7)sSourceText = gb.subLabel2();
			
			String sText = sPrefix+sSourceText ;
			//reportMessage(TN("|text =| ") + sText + " of source " + nSource);
			
			if (nMode==2)
			{
				if (nTarget == 0)sTargetText = gb.name();
				else if (nTarget == 1)sTargetText = gb.material();
				else if (nTarget == 2)sTargetText = gb.information();
				else if (nTarget == 3)sTargetText = gb.label();
				else if (nTarget == 4)sTargetText = gb.grade();
				else if (nTarget == 5)sTargetText = gb.subLabel();
				else if (nTarget == 6)sTargetText = gb.subLabel2();
			}
			
		// write to target
			if (nTarget == 0)gb.setName(sText);
			else if (nTarget == 1) gb.setMaterial(sText);
			else if (nTarget == 2) gb.setInformation(sText);
			else if (nTarget == 3) gb.setLabel(sText);
			else if (nTarget == 4) gb.setGrade(sText);
			else if (nTarget == 5) gb.setSubLabel(sText);
			else if (nTarget == 6) gb.setSubLabel2(sText);
			
		// write to source	
			//reportMessage(TN("|target text =| ") + sTargetText + " of target " + nTarget);
			if (nMode>0)
			{ 
				if (nSource == 1)gb.setName(sTargetText);
				else if (nTarget == 2) gb.setMaterial(sTargetText);
				else if (nTarget == 3) gb.setInformation(sTargetText);
				else if (nTarget == 4) gb.setLabel(sTargetText);
				else if (nTarget == 5) gb.setGrade(sTargetText);
				else if (nTarget == 6) gb.setSubLabel(sTargetText);
				else if (nTarget == 7) gb.setSubLabel2(sTargetText);				
			}
			
		}
		
	
		eraseInstance();
		return;
	}	
// end on insert	__________________
	
	;
#End
#BeginThumbnail
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
+CC"DCIP*GHH`_]F/
`

#End