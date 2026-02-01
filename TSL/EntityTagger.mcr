#Version 8
#BeginDescription
This tsl numbers genbeams or tsl instances and applies painter derived property data to the selection set
Underlying painterdefinitions should be stored in a collection named 'EntityTagger'

#Versions
Version 1.3 19.04.2023 HSB-18224 new property to specify odering of seqeuntial tagging

Version 1.2 31.03.2023 HSB-18224 new properties added to support sequential indexing
Version 1.1 06.02.2023 HSB-16764 minor description enhanxcement
Version 1.0 22.12.2022 HSB-16764 initial version to tag and number items by painter definitions



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.3 19.04.2023 HSB-18224 new property to specify odering of seqeuntial tagging , Author Thorsten Huck
// 1.2 31.03.2023 HSB-18224 new properties added to support sequential indexing , Author Thorsten Huck
// 1.1 06.02.2023 HSB-16764 minor description enhancement , Author Thorsten Huck
// 1.0 22.12.2022 HSB-16764 initial version to tag and number items by painter definitions , Author Thorsten Huck

/// <insert Lang=en>
/// Select entities to be numbered and/or tagged
/// </insert>

// <summary Lang=en>
// This tsl numbers genbeams or tsl instances and applies painter derived property data to the selection set
// Underlying painterdefinitions should be stored in a collection named 'EntityTagger'
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "EntityTagger")) TSLCONTENT
//endregion


//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	String tDefault =T("|_Default|");
	String tLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
//region Color and view	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	
	int lightblue = rgb(204,204,255);
	int blue = rgb(69,84,185);	
	int darkblue = rgb(26,50,137);	
	int yellow = rgb(241,235,31);
	int darkyellow = rgb(254, 204, 102);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);	

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
//endregion 	
	
	
	String tDisabledEntry = T("<|Disabled|>");
//end Constants//endregion

//region Properties
	String sAllPainters[] = PainterDefinition().getAllEntryNames().sorted();
	
//region Painter Collections
	String sPainterParent = "EntityTagger";
	String sPainterCollection = sPainterParent+"\\";
	String sPainters[0], sGroupPainters[0];
	for (int i=0;i<sAllPainters.length();i++) 
	{ 
		PainterDefinition pd(sAllPainters[i]);
		if (!pd.bIsValid())
			continue;
	
		if (sAllPainters[i].find(sPainterCollection,0,false)==0)
		{
			String ftr = pd.format();

			String s = sAllPainters[i];
			s = s.right(s.length() - sPainterCollection.length());
			if (sPainters.findNoCase(s,-1)<0)
				sPainters.append(s);
			if (ftr.length()>0 && sGroupPainters.findNoCase(s,-1)<0)
				sGroupPainters.append(s);	
				
				
				
		}		
	}//next i
	int bFullPainterPath = sPainters.length() < 1;
	if (bFullPainterPath)
	{ 
			
		for (int i=0;i<sAllPainters.length();i++) 
		{ 
			String s = sAllPainters[i];
			PainterDefinition pd(s);
			if (!pd.bIsValid() || pd.format().find("@(",0, false)<0)
				continue;		

			String ftr = pd.format();
			if (sPainters.findNoCase(s,-1)<0)
				sPainters.append(s);
			if (ftr.length()>0 && sGroupPainters.findNoCase(s,-1)<0)
				sGroupPainters.append(s);				
		}//next i
		
		
	}
	else
		sGroupPainters.insertAt(0, sPainterParent);
	sPainters.insertAt(0, tDisabledEntry);
	sGroupPainters.insertAt(0, tDisabledEntry);
//endregion 	



//region Properties
	String sGeneralDesc = T(" |If a painter collection named 'EntityTagger' is found only painters of this collection are considered.|");
	String tAscending = T("|Ascending|"), tDescending = T("|Descending|"), sSortDirections[] ={ tAscending, tDescending};

	
category = T("|Sequence Tagging|");
	String sSubLabelName=T("|Sublabel|");	
	PropString sSubLabel(7, sGroupPainters, sSubLabelName);	
	sSubLabel.setDescription(T("|Defines sequence tagging based on the selected painter definition for the selected entities.|") +sGeneralDesc );
	sSubLabel.setCategory(category);
	int nSubLabel = sGroupPainters.find(sSubLabel);
	if (nSubLabel<0){ nSubLabel=0;sSubLabel.set(sGroupPainters[nSubLabel]);}
	String sSubLabelDef = bFullPainterPath ? sSubLabel : sPainterCollection + sSubLabel;
	
	String sSeqeuenceSortDirectionName=T("|Sort Direction|");	
	PropString sSeqeuenceSortDirection(9,sSortDirections, sSeqeuenceSortDirectionName);	
	sSeqeuenceSortDirection.setDescription(T("|Defines the Sorting Direction of the sequential tag|"));
	sSeqeuenceSortDirection.setCategory(category);
	
	String tLabel = T("|Label|"), tSub2 = T("|Sublabel| 2"), tInfo = T("|Information|");
	String sPrefixTargets[] = { tDisabledEntry, tLabel, tSub2, tInfo};
	String sPrefixTargetName=T("|Prefix Target|");	
	PropString sPrefixTarget(8, sPrefixTargets, sPrefixTargetName);	
	sPrefixTarget.setDescription(T("|In case the painter definition for the sequence tagging contains an alias definition as first entry, i.e. '@(Type:A;SequencePrefix)', you can assign the return value of this to be written to the selected property.)") + 
		T("|If no alias is defined the assignment will not be performed.|"));
	sPrefixTarget.setCategory(category);


category = T("|Property Mapping|");
	String sNameName=T("|Name|");	
	PropString sName(0, sGroupPainters, sNameName);	
	sName.setDescription(T("|Defines the painter definition to filter entities.|") +sGeneralDesc );
	sName.setCategory(category);
	int nName = sGroupPainters.find(sName);
	if (nName<0){ nName=0;sName.set(sGroupPainters[nName]);}
	String sNameDef = bFullPainterPath ? sName : sPainterCollection + sName;	

	String sLabelName=T("|Label|");	
	PropString sLabel(1, sGroupPainters, sLabelName);	
	sLabel.setDescription(T("|Defines the painter definition to filter entities.|") +sGeneralDesc );
	sLabel.setCategory(category);
	int nLabel = sGroupPainters.find(sLabel);
	if (nLabel<0){ nLabel=0;sLabel.set(sGroupPainters[nLabel]);}
	String sLabelDef = bFullPainterPath ? sLabel : sPainterCollection + sLabel;

	String sMaterialName=T("|Material|");	
	PropString sMaterial(2, sGroupPainters, sMaterialName);	
	sMaterial.setDescription(T("|Defines the painter definition to filter entities.|") +sGeneralDesc );
	sMaterial.setCategory(category);
	int nMaterial = sPainters.find(sMaterial);
	if (nMaterial<0){ nMaterial=0;sMaterial.set(sGroupPainters[nMaterial]);}
	String sMaterialDef = bFullPainterPath ? sMaterial : sPainterCollection + sMaterial;
	
	String sGradeName=T("|Grade|");	
	PropString sGrade(3, sGroupPainters, sGradeName);	
	sGrade.setDescription(T("|Defines the painter definition to filter entities.|") +sGeneralDesc );
	sGrade.setCategory(category);
	int nGrade = sGroupPainters.find(sGrade);
	if (nGrade<0){ nGrade=0;sGrade.set(sGroupPainters[nGrade]);}
	String sGradeDef = bFullPainterPath ? sGrade : sPainterCollection + sGrade;	
	
	String sInformationName=T("|Information|");	
	PropString sInformation(4, sGroupPainters, sInformationName);	
	sInformation.setDescription(T("|Defines the painter definition to filter entities.|") +sGeneralDesc );
	sInformation.setCategory(category);
	int nInformation = sGroupPainters.find(sInformation);
	if (nInformation<0){ nInformation=0;sInformation.set(sGroupPainters[nInformation]);}
	String sInformationDef = bFullPainterPath ? sInformation : sPainterCollection + sInformation;	

category = T("|Posnum|");
	String sPosNumPainterName=T("|Filter|");	
	PropString sPosNumPainter(5, sPainters, sPosNumPainterName);	
	sPosNumPainter.setDescription(T("|Defines the painter definition to filter entities.|") +sGeneralDesc );
	sPosNumPainter.setCategory(category);
	int nPosNumPainter = sPainters.find(sPosNumPainter);
	if (nPosNumPainter<0){ nPosNumPainter=0;sPosNumPainter.set(sPainters[nPosNumPainter]);}
	String sPosNumPainterDef = bFullPainterPath ? sPosNumPainter : sPainterCollection + sPosNumPainter;	
	
	String sSortDirectionName=T("|Sort Direction|");	
	PropString sSortDirection(6,sSortDirections, sSortDirectionName);	
	sSortDirection.setDescription(T("|Defines the Sorting Direction|"));
	sSortDirection.setCategory(category);

	String sStartNumberName=T("|Start Number|");	
	PropInt nStartNumber(nIntIndex++, -1, sStartNumberName);	
	nStartNumber.setDescription(T("|Defines the start number.|") + T("|<0 = erase all existing and start from scratch, absolute value will be start number|") + T(", |0 = release posnum|"));
	nStartNumber.setCategory(category);

//End Properties//endregion 

//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();
		
		
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select genebams|"), GenBeam());
		if (ssE.go())
			_Entity.append(ssE.set());

		
		if (bDebug)_Pt0 = getPoint();
		return;
	}			
//endregion 

//region Sequence Tagging
	if (sSubLabel != tDisabledEntry)
	{	
		String def = sSubLabel;
		
	// Collect painter definitions
		String defs[0];
		if (def == sPainterParent)
		{ 
			defs = sGroupPainters;
		// remove disabled and parent	
			int n = defs.findNoCase(tDisabledEntry ,- 1);
			if (n>-1)
				defs.removeAt(n);
			n = defs.findNoCase(sPainterParent ,- 1);
			if (n>-1)
				defs.removeAt(n);	
				
			n = defs.findNoCase(sPosNumPainter ,- 1);
			if (n>-1)
				defs.removeAt(n);	


		// remove any child folder
			for (int i=defs.length()-1; i>=0 ; i--) 
			{ 
				n = defs[i].find("\\" ,0,false);
				if (n>-1)
					defs.removeAt(n);				
			}//next i


		}
		else
			defs.append(def);
	
	//region Loop painter definitions
		Entity entsX[0]; // the collection of entities which have been processed by a definition, avoid ents to be processed multiple times
		for (int x=0;x<defs.length();x++) 
		{ 
			String sDefinition = defs[x];
			if (!bFullPainterPath)sDefinition = sPainterCollection + sDefinition;
			PainterDefinition pd(sDefinition); 
			
			if (!pd.bIsValid())	
			{
				continue;
			}
			
			String ftr = pd.format();
			Entity ents[] = pd.filterAcceptedEntities(_Entity);
			GenBeam gbs[0];
			for (int x = 0; x < ents.length(); x++)
			{
				GenBeam g = (GenBeam)ents[x];
				if (g.bIsValid())
				{ 
					if (entsX.find(g)<0)
					{ 
						gbs.append(g);
						entsX.append(g);	
					}
					else
					{ 
						reportMessage(TN("|Multiple appearance of genbeam in painter defintions avoided|: ") + g.handle() + "-" +g.posnum() + "-" + g.name()  );
					}					
				}					
			}
			
			
		//region Analyse the format to resolve
			String tokens[] = ftr.tokenize("@(*)");
			int numFormat;
			for (int i=0;i<tokens.length();i++) 
			{ 
				String t = "@("+tokens[i]+")";
				if (ftr.find(t,0, false)>-1)
				{
					tokens[i] = t; // append @(*)
					numFormat++; 		 
				}
			}//next i
			
		// if the first token contains an alias we assume it is to resolve the prefix
			// Strategy:
			// The groupBy value is parsed, if it finds at least two formats and the first one contains an alias 
			// separate the format for prefixing and sequencing	
			String formatPrefix, formatSequence, formatRaw;
			if (numFormat>1 && tokens[0].find(":A;",0, false)>-1)
			{ 
				formatPrefix = tokens[0];
				
			// append anything upto the next format	
				for (int i=1;i<tokens.length();i++) 
				{ 
					if (tokens[i].find("@(",0, false)>-1 || formatSequence.length()>0)
					{ 
						formatSequence += tokens[i];
					}		 
					else
					{ 
						formatPrefix += tokens[i];
						
					// get the raw prefix: used to identify unique sequences
						int n = formatPrefix.find(":A;", 0, false);
						formatRaw = formatPrefix.left(n)+")";
					}
					
				}//next i						
			}
			
		// in case no formatPrefix or sgeFormat is found in the tokens get the default
			if (formatSequence.length()<1)
			{ 
				formatPrefix = "";
				formatSequence = ftr;
			}
			
		//endregion 
		
		//region Release and reassign posnums after sublabel has been cleared if the format contains @(posnum
			int bHasPosNum = formatSequence.find("@(PosNum", 0, false) > -1;
			if (bHasPosNum)	
			{ 
				for (int i = 0; i < gbs.length(); i++)
				{ 
					gbs[i].releasePosnum(false);
					gbs[i].setSubLabel("");
				}
				for (int i = 0; i < gbs.length(); i++)
					gbs[i].assignPosnum(1, true);			
			}
		//endregion 


		
		//region Collect tags based on given format
			String tags[0], prefixes[0];
			for (int i = 0; i < gbs.length(); i++)
			{
				GenBeam g = gbs[i];
				String raw = g.formatObject(formatRaw);
				String prefix = g.formatObject(formatPrefix);
				String value = g.formatObject(ftr);
				
				String tag;
				
				// use unique ID if not collected by Alias	
				if (formatRaw.length() > 0 && formatPrefix.length() > 0 && raw == prefix)
					tag = g.uniqueId();
				else
					tag = g.formatObject(ftr);
				tags.append(tag);
				prefixes.append(prefix);
			}
	
		// order ascending or descending
			int bSeqDescending = sSeqeuenceSortDirection == tAscending;
			for (int i=0;i<tags.length();i++) 
				for (int j=0;j<tags.length()-1;j++) 
					if ((bSeqDescending && tags[j]>tags[j+1]) || (!bSeqDescending && tags[j]<tags[j+1]))
					{
						gbs.swap(j, j + 1);
						tags.swap(j, j + 1);
						prefixes.swap(j, j + 1);
					}

//		// Order by tag
//			for (int i = 0; i < tags.length(); i++)
//				for (int j = 0; j < tags.length() - 1; j++)
//					if (tags[j] > tags[j + 1])
//					{
//						gbs.swap(j, j + 1);
//						tags.swap(j, j + 1);
//						prefixes.swap(j, j + 1);
//					}
		//endregion
				
		//region Assign sublabel
			int index;
			for (int i = 0; i < tags.length(); i++)
			{
				GenBeam& g = gbs[i];
				String tag = tags[i];
				String prefix = tag==g.uniqueId()?"":prefixes[i];
				
				if (i == 0)
					index++;
				else if (prefixes[i] != prefixes[i - 1])
					index = 1;
				else if (tags[i] != tags[i - 1])
					index++;
				
			// Write index to sublabel	
				g.setSubLabel(index);

			// Write prefix to target
				if (prefix.length()>0)
				{ 
					if (sPrefixTarget==tLabel)
						g.setLabel(prefix);
					else if (sPrefixTarget==tSub2)
						g.setSubLabel2(prefix);		
					else if (sPrefixTarget==tInfo)
						g.setInformation(prefix);					
				}
				
			}//next i
			
			// assign posnum	
			if (bHasPosNum)
				for (int i = 0; i < gbs.length(); i++)
					gbs[i].assignPosnum(1, true);
			//endregion		
		}//next x			
	//endregion 
		
	}
//endregion 

//region Assign Posnums
	if (sPosNumPainter!=tDisabledEntry)
	{ 
		int bReleasePosNum = nStartNumber <= 0;
		int nStart = abs(nStartNumber);
		
		PainterDefinition pd(sPosNumPainterDef);
		String ftr = pd.formatToResolve();
		
		Entity ents[] = pd.filterAcceptedEntities(_Entity);
		
	// Collect unique keys and results	
		String uniques[0];
		String results[ents.length()];	
		for (int i=0;i<ents.length();i++) 
		{ 
			Entity& e = ents[i]; 
			GenBeam g = (GenBeam)e;
			TslInst t = (TslInst)e;
			int pos;
			if (g.bIsValid() && bReleasePosNum)
				pos=g.releasePosnum(false);
			else if (t.bIsValid() && bReleasePosNum)
				pos=t.releasePosnum();
				
			
			
			String f = e.formatObject(ftr);
			if (f == ftr)f = ""; //refuse items which do not return a filter result
			results[i]=f;
			
		// collect unique filter conditions	
			if (f.length()>0 && uniques.findNoCase(f,-1)<0)
				uniques.append(f);			
		}//next i	
		
	// order ascedning or descending
		int bDescending = sSortDirection == tAscending;
		for (int i=0;i<uniques.length();i++) 
			for (int j=0;j<uniques.length()-1;j++) 
				if ((bDescending && uniques[j]>uniques[j+1]) || (!bDescending && uniques[j]<uniques[j+1]))
					uniques.swap(j, j + 1);
		
		if (nStart>0)
		{ 
			int num;
			for (int i=0;i<uniques.length();i++) 
			{ 
				String unique = uniques[i]; 
				for (int j=0;j<ents.length();j++) 
					if (results[j]==unique)
					{
						GenBeam g = (GenBeam)ents[j];
						if (g.bIsValid())
						{ 
							//PLine(_PtW, g.ptCen()).vis(i);
							int n = g.assignPosnum(nStart,true);
							num++;
							continue;
						}
						TslInst t = (TslInst)ents[j];
						if (t.bIsValid())
						{ 
							int n = t.assignPosnum(nStart,true);
							num++;
							continue;							
						}
					}					 
			}//next i
			
			reportMessage("\n"+num + T(" |entities numbered|"));
			
		}
	}
//endregion 

//region Property Mapping
	String sDefinitions[] ={ sName, sLabel, sMaterial, sGrade, sInformation};

	for (int j=0;j<sDefinitions.length();j++) 
	{ 
		String def = sDefinitions[j];
		if (def == tDisabledEntry)
		{
			continue;
		}
		
		String err;
		if (j==1 && sSubLabel!=tDisabledEntry && sPrefixTarget==tLabel)
			err = T("|Conflicting selection of properties.|\n" + def + T(" |will not be used to assign a value for label.|"));
		else if (j==4 && sSubLabel!=tDisabledEntry && sPrefixTarget==tInfo)
			err = T("|Conflicting selection of properties.|\n" + def + T(" |will not be used to assign a value for information.|"));
		if (err.length()>0)
		{ 
			continue;
		}
		
		
		
	// Collect painter definitions
		String defs[0];
		if (def == sPainterParent)
		{ 
			defs = sGroupPainters;
		
		// remove disabled and parent	
			int n = defs.findNoCase(tDisabledEntry ,- 1);
			if (n>-1)
				defs.removeAt(n);
			n = defs.findNoCase(sPainterParent ,- 1);
			if (n>-1)
				defs.removeAt(n);	
				
			n = defs.findNoCase(sPosNumPainter ,- 1);
			if (n>-1)
				defs.removeAt(n);	
			
		// remove any child folder
			for (int i=defs.length()-1; i>=0 ; i--) 
			{ 
				n = defs[i].find("\\" ,0,false);
				if (n>-1)
					defs.removeAt(n);	
				
			}//next i
	
		}
		else
			defs.append(def);
		
		
	//region Loop mappings
		for (int i=0;i<defs.length();i++) 
		{ 
			String sDefinition = defs[i];
			if ( ! bFullPainterPath)sDefinition = sPainterCollection + sDefinition;
			PainterDefinition pd(sDefinition); 
			
			if (!pd.bIsValid())continue;
			
			Entity ents[] = pd.filterAcceptedEntities(_Entity);
			String ftr = pd.format();
			
			for (int x=0;x<ents.length();x++) 
			{ 
				Entity e = ents[x];
				GenBeam g = (GenBeam)e;
				String value = e.formatObject(ftr);
				if (ftr.find("@(UniqueId",0, false)>-1) // using uniquID to be able to assign a sequence number
					value = x+1;
				
				if (value.length()<1)
				{ 
					continue;
				}
				
				if (g.bIsValid())
				{ 
//					if (i==1)
//						PLine(_PtW, g.ptCen()).vis(i);
					if (j == 0)g.setName(value);
					else if (j == 1)g.setLabel(value);
					else if (j == 2)g.setMaterial(value);
					else if (j == 3)g.setGrade(value);
					else if (j == 4)g.setInformation(value);
				}
				else
				{ 
					Map m = e.subMapX(sPainterParent);
					if (j == 0)m.setString("Name", value);
					else if (j == 1)m.setString("Label", value);
					else if (j == 2)m.setString("Material", value);
					else if (j == 3)m.setString("Grade", value);
					else if (j == 4)m.setString("Information", value);
					e.setSubMapX(sPainterParent, m);
				} 

				
			}//next x
		}//next i			
	//endregion 	 
	}//next j


	if (!bDebug)
	{ 
		eraseInstance();
		return;
	}

//endregion 








#End
#BeginThumbnail


#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS">
        <int nm="BREAKPOINT" vl="607" />
        <int nm="BREAKPOINT" vl="615" />
        <int nm="BREAKPOINT" vl="556" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18224 new property to specify odering of seqeuntial tagging" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="4/19/2023 9:26:29 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18224 new properties added to support sequential indexing" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="3/31/2023 10:56:27 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16764 minor description enhanxcement" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="2/6/2023 10:13:12 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16764 initial version to tag and number items by painter definitions" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="12/22/2022 4:18:09 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End