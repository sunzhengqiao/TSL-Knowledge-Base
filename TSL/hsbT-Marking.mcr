#Version 8
#BeginDescription
#Versions
Version 2.3 25.10.2024 HSB-22873: Fix when getting contacts with the male beam 
Version 2.2 28.07.2023 HSB-19669 painter collection folders are not case sensitive anymore
Version 2.1 03.06.2022 HSB-15457 formatting helper enabled for hsbDesign24 and higher
Version 2.0 03.06.2022 HSB-15457 formatting helper disabled for hsbDesign23
Version 1.9 01.06.2022 HSB-15457 new marking sides for twin walls, painter support, supports TSL-Filter -> Painterdefinition migration

Version 1.8 12.05.2022 HSB-15457 excluded blockings of twinwalls to be marked on element selection
version value="1.7" date="22.mar2017" author="thorsten.huck@hsbcad.com" new visualization in element view






#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 3
#KeyWords Marking;Mark;Inscription
#BeginContents
/// <History>//region
//#Versions
// 2.3 25.10.2024 HSB-22873: Fix when getting contacts with the male beam , Author Marsel Nakuci
// 2.2 28.07.2023 HSB-19669 painter collection folders are not case sensitive anymore  , Author Thorsten Huck
// 2.1 03.06.2022 HSB-15457 formatting helper enabled for hsbDesign24 and higher , Author Thorsten Huck
// 2.0 03.06.2022 HSB-15457 formatting helper disabled for hsbDesign23 , Author Thorsten Huck
// 1.9 01.06.2022 HSB-15457 new marking sides for twin walls, painter support, supports TSL-Filter -> Painterdefinition migration , Author Thorsten Huck
// 1.8 12.05.2022 HSB-15457 excluded blockings of twinwalls to be marked on element selection , Author Thorsten Huck
/// <version value="1.7" date="22.mar2017" author="thorsten.huck@hsbcad.com"> new visualization in element view </version>
/// <version value="1.6" date="23.feb2017" author="thorsten.huck@hsbcad.com"> tool removal on edge beams honours contact option </version>
/// <version value="1.5" date="23.feb2017" author="thorsten.huck@hsbcad.com"> new option to stretch male beam dynamic, tool cleanup enhanced </version>
/// <version value="1.4" date="22.feb2017" author="thorsten.huck@hsbcad.com"> element view rule added </version>
/// <version value="1.3" date="22.feb2017" author="thorsten.huck@hsbcad.com"> duplicates will be removed, silent catalog entry based insert supported </version>
/// <version value="1.2" date="21.feb2017" author="thorsten.huck@hsbcad.com"> bugfix using the gap property </version>
/// <version value="1.1" date="09.nov2016" author="thorsten.huck@hsbcad.com"> bugfix single markings out of range but marking text to be placed </version>
/// <version value="1.0" date="08.nov2016" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entities, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates markings at t-connections of 2 beams. It can be inserted by element or by beam selection set
/// If the beams are dependent from an element the distinction of what is seen as left and right is based 
/// on the the element view. If no element dependency exists the male connection direction sets the sides
/// </summary>//endregion

//region Constant
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	String sDefault =T("|_Default|");
	String kLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
	String tInside = T("|Inside|"),tOutside = T("|Outside|"), tRefSide =  T("|Z-axis|"), tOppSide =  T("-|Z-axis|");
	String tParallelX = T("|X-Parallel|");
	String tParallelY = T("|Y-Parallel|");
	String tNonOrtho = T("|Non Orthogonal|");
	String tDefault =T("|<Default>|");
	
	String kScript = bDebug ? "hsbT-Marking" : scriptName();
	String kBeam = "Beam";
	String kPainterCollection = kScript;
	String sMaleDefaultFilters[] = {tDefault, tParallelX,tParallelY,tNonOrtho};
	String sFemaleDefaultFilters[] = {tDefault, tParallelX,tParallelY,tNonOrtho};
	
	String sPainters[] = PainterDefinition().getAllEntryNames().sorted();
	// if a collection was found consider only those of the collection, else take all
	int bHasPainterCollection; 
	for (int i=0;i<sPainters.length();i++) 	{if (sPainters[i].find(kPainterCollection,0,false)>-1){bHasPainterCollection=true;break;}}//next i
	if (bHasPainterCollection)
		for (int i=sPainters.length()-1; i>=0 ; i--) 
			if (sPainters[i].find(kPainterCollection,0,false)<0)
				sPainters.removeAt(i);	
	sPainters = sPainters.sorted();

	int nMode = _Map.getInt("mode");
//end Constants//endregion

//region Functions
			
//End Functions//endregion 

//region Create Painter by Property
	// creates painter definitions if the corresponoding property contains a stream of it
	String sPainterStreamName=T("|Painter Definition Male|");	
	PropString sPainterStreamMale(9, "", sPainterStreamName);	
	sPainterStreamMale.setDescription(T("|Stores the data of the male painter definition|"));
	sPainterStreamMale.setCategory(category);
	sPainterStreamMale.setReadOnly(bDebug?false:_kHidden);

	if (_bOnDbCreated)
	{
		String _stream = sPainterStreamMale;
		if (_stream.length() > 0)
		{
			// get painter definition from property string	
			Map m;
			m.setDxContent(_stream, true);
			String name = m.getString("Name");
			String type = m.getString("Type").makeUpper();
			String filter = m.getString("Filter");
			String format = m.getString("Format");
			
			// create definition if not present	
			if (m.hasString("Name") && m.hasString("Type") && sPainters.findNoCase(name ,- 1) < 0)//name.find(sPainterCollection, 0, false) >- 1 &&
			{
				PainterDefinition pd(name);
				pd.dbCreate();
				pd.setType(type);
				pd.setFilter(filter);
				pd.setFormat(format);
				
				if (pd.bIsValid())
				{
					sPainters.append(name);
					
				}
			}
		}
	}
	
	String sPainterStreamFemaleName=T("|Painter Definition Female|");	
	PropString sPainterStreamFemale(10, "", sPainterStreamFemaleName);	
	sPainterStreamFemale.setDescription(T("|Stores the data of the female painter definition|"));
	sPainterStreamFemale.setCategory(category);
	sPainterStreamFemale.setReadOnly(bDebug?false:_kHidden);
	
	if (_bOnDbCreated)
	{
		String _stream = sPainterStreamFemale;
		if (_stream.length() > 0)
		{
			// get painter definition from property string	
			Map m;
			m.setDxContent(_stream, true);
			String name = m.getString("Name");
			String type = m.getString("Type").makeUpper();
			String filter = m.getString("Filter");
			String format = m.getString("Format");
			
			// create definition if not present	
			if (m.hasString("Name") && m.hasString("Type") && sPainters.findNoCase(name ,- 1) < 0)//name.find(sPainterCollection, 0, false) >- 1 &&
			{
				PainterDefinition pd(name);
				pd.dbCreate();
				pd.setType(type);
				pd.setFilter(filter);
				pd.setFormat(format);
				
				if (pd.bIsValid())
				{
					sPainters.append(name);
					
				}
			}
		}
	}
	
//End Create Painter by Property//endregion

//region Painter Filter Definition
	// collect the names of potential painters to support male and female filtering
	String sMaleFilters[0];		sMaleFilters = sMaleDefaultFilters;
	String sFemaleFilters[0];	sFemaleFilters = sFemaleDefaultFilters;
	for (int i=0;i<sPainters.length();i++) 
	{ 
		PainterDefinition pd(sPainters[i]);
		String type = pd.type();
		
		int bValidMaleType = type.find(kBeam,0,false)==0;
		int bValidFemaleType = type.find(kBeam,0,false)==0;
		
		String painter = sPainters[i];
		int n = painter.find("\\", 0, false);
	
	// append collection painters without the collection name	
		if (painter.find(kPainterCollection,0,false)>-1) 
		{ 
			String s = painter.right(painter.length() - n - 1);
			if (sMaleFilters.findNoCase(s,-1)<0 && bValidMaleType)
				sMaleFilters.append(s);
			if (sFemaleFilters.findNoCase(s,-1)<0 && bValidFemaleType)
				sFemaleFilters.append(s);				
		}
	// ignore other collections	
		else if (!bHasPainterCollection && n <0) 
		{
			if (bValidMaleType)sMaleFilters.append(painter); 
			if (bValidFemaleType)sFemaleFilters.append(painter); 			
		}
	}//next i		
//endregion 

//region Legacy support of HSB_G-FilterGenBeams
	// Previously the tsl HSB_G-FilterGenBeams was used to define genbeam filters: show these filters upon first use, if filter is used convert to painter and show potential remaining filters in context menu
	String sFilterScript = "HSB_G-FilterGenBeams";
	String sFilterCatalogEntries[] = TslInst().getListOfCatalogNames(sFilterScript).sorted();
	String sFilterDefinitions[sFilterCatalogEntries.length()];
	
	// append as filter if no painter collection of this script has been found
	if (!bHasPainterCollection)
	{ 
		for (int i=0;i<sFilterCatalogEntries.length();i++) 
		{ 
			String def = sFilterCatalogEntries[i];
			if (def == kLastInserted || def == kLastInserted)continue;
			if (sMaleFilters.findNoCase(def,-1)<0)
				sMaleFilters.append(def); 
			if (sFemaleFilters.findNoCase(def,-1)<0)
				sFemaleFilters.append(def); 				 
		}//next i	
	}
	
	//region Collect filterdefinitions from catalog entry
	for (int x=0;x<sFilterCatalogEntries.length();x++) 
	{ 
		String entry = sFilterCatalogEntries[x];
		if (entry == tDefault || entry == kLastInserted)continue;
		
		String operations[] = {	T("|Exclude|"),	T("|Include|")};
		String operators[] = { T("|All|"), T("|Any|")};
		Map map =TslInst(). mapWithPropValuesFromCatalog(sFilterScript,entry).getMap("propString[]");	
		
		//Collect properties
		String props[0];
		for (int i=0;i<map.length();i++) 
		{ 
			props.append(map.getMap(i).getString("strValue"));
		}//next i
		if (props.length()!=10)
			return;
			
		props.swap(7, 8); // swap value and name to persist loop syntax	
		int bInclude = props[0]!=operations.first();
		int bExclusive = props[9] == operators.first();
	
		String properties[] ={ "BeamCode", "Material", "Label", "hsbID", "Zoneindex", "Name", "PropertyValue"};
		String logicals[] ={ "or", "and"};
		if (bInclude)logicals.swap(0, 1);
		String logical = logicals[bExclusive];
		String filterMode = "Contains";//"Equals"; // beamcode defaulted to Contains as defined by semicolon separated list
	
		String filter;
		for (int j=0;j<7;j++) 
		{ 
			String values[] = props[j+1].tokenize(";");
			for (int i=values.length()-1; i>=0 ; i--) 
			{ 
				values[i] = values[i].trimLeft().trimRight();
				if (values.length()<1)
					values.removeAt(i);			
			}//next i
			String propNames[0];
			if (j==6)
			{ 
				propNames = props[8].tokenize(";");
				for (int i=propNames.length()-1; i>=0 ; i--) 
				{ 
					propNames[i] = propNames[i].trimLeft().trimRight();
					if (propNames.length()<1)
						propNames.removeAt(i);			
				}//next i	
				
				// names and values of propertysets must have same length
				if (propNames.length()!=values.length())
				{ 
					continue;
				}
				
			}	
	
			String sub;
			for (int i=0;i<values.length();i++) 
			{ 
				if (sub.length() >0) sub+=logical;
				
				if (j==6)
					properties[6] = propNames[i];
				
			// include
				if (bInclude && j==4)
					sub+="(" + filterMode+"(" +properties[j]+ ","+values[i].atoi()+")"; 		
				else if (bInclude)
					sub+="(" + filterMode+"(" +properties[j]+ ",'"+values[i]+"'))"; 	
	
					
				else if (j==0)// exclude beamcode
					sub+="(!" + filterMode+"(" +properties[j]+ ",'"+values[i]+"'))"; 
				else if (j==4)// exclude zone
					sub+="(" +properties[j]+ " !="+values[i].atoi()+")"; 				
				else // exclude
					sub+="(" +properties[j]+ " !='"+values[i]+"')"; 	
			}//next i
			
			if (sub.length()>0)
			{ 
				if (filter.length() >0) filter+=logical;
				filter += sub;			
			}
			filterMode = "Equals"; 
		}//next j
		
		sFilterDefinitions[x] = filter;		
	}
	//endregion 

	
//endregion 

//region Properties

category = T("|Filter|");
	String sFilterDescription = T("|The filtering supports certain defaults which can also be defined by painter definitions.|") + 
		T("|The painter definition may be stored in a collection named 'ElementBeamSplit' in which case it will only collect definitions within this collection.|") +
		T("|If no such collection is found all painters matching the supported types will be collected.|");

	String sMaleFilterName=T("|Marking Beams|");	
	PropString sMaleFilter(7, sMaleFilters, sMaleFilterName,1);	
	sMaleFilter.setDescription(T("|Defines the filter mode for the male entities.| ") + sFilterDescription);
	sMaleFilter.setCategory(category);
	if (sMaleFilters.find(sMaleFilter) <- 1)sMaleFilter.set(tDefault);
	sMaleFilter.setReadOnly(_bOnInsert || nMode==1 || bDebug ? false : _kHidden);
	
	String sFemaleFilterName=T("|Beams to be marked|");	
	PropString sFemaleFilter(8, sFemaleFilters, sFemaleFilterName,0);	
	sFemaleFilter.setDescription(T("|Defines the Filter mode for the female entities.| ")+sFilterDescription);
	sFemaleFilter.setCategory(category);	
	if (sFemaleFilters.find(sFemaleFilter) <- 1)sFemaleFilter.set(tDefault);
	sFemaleFilter.setReadOnly(_bOnInsert ||nMode==1 || bDebug ? false : _kHidden);

// Marking	
category = T("|Marking|");
	String sSides[] = {T("|Contact face|"), T("|Opposite contact face|"), tRefSide ,tOppSide};
	String sSideDescription = T("|Defines the marking side.|");
	if (_bOnInsert || nMode==1)
	{ 
		sSides.append(tInside);
		sSides.append(tOutside);
		sSideDescription += T(" |Inside and outside are only applicable to twin elements where beams do not span the entire width of the zone|");
	}
	String sSideName=T("|Side|");	
	PropString sSide(0, sSides, sSideName);	
	sSide.setDescription(sSideDescription);
	sSide.setCategory(category);
	int nSide = sSides.find(sSide);


	String sAlignments[] = {T("|Left|"), T("|Center|"), T("|Right|"), T("|Left|") +"+"+ T("|Right|")};
	String sAlignmentName=T("|Alignment|");	
	PropString sAlignment(1, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the location of the marking|"));
	sAlignment.setCategory(category);
	int nAlignment = sAlignments.find(sAlignment)-1;

// CNC Inscription
category = T("|Inscription|");

	String sFormatName=T("|Format|");	
	PropString sFormat(2, "@(PosNum)", sFormatName);	
	sFormat.setDescription(T("|Specifies the text.|") + " " + T("|You can define format instructions @(<KEY>) which will be replaced by its value.|"));
	sFormat.setCategory(category);
	sFormat.setDefinesFormatting("Beam");

	String sHAlignments[]= {T("|Left|"),T("|Center|"), T("|Right|")};	
	String sHAlignmentName =T("|Horizontal|");
	PropString sHAlignment(3, sHAlignments,sHAlignmentName ,1 );
	sHAlignment.setDescription(T("|Defines the text orienation.|"));	
	sHAlignment.setCategory(category);	
	
	String sVAlignments[]= {T("|Bottom|"),T("|Center|"), T("|Top|")};	
	String sVAlignmentName = T("|Vertical|");
	PropString sVAlignment(4, sVAlignments,sVAlignmentName ,1 );
	sVAlignment.setDescription(T("|Defines the text orienation.|"));
	sVAlignment.setCategory(category);

	String sOrientations[]= {T("|Alongside|"),T("|Across|"), "-" + T("|Alongside|"),"-" + T("|Across|"), T("|Perpendicular|"), "-" + T("|Perpendicular|")};		
	int nOrientations[]= {0,2,1,4,3,5};	
	String sOrientationName = T("|Alignment|");
	PropString sOrientation(5, sOrientations,sOrientationName ,1 );
	sOrientation.setDescription(T("|Specifies the orientation of the inscription.|"));	
	sOrientation.setCategory(category);

	String sTextHeightName= T("|Text Height|") + " " +T("|CNC|");
	PropDouble dTextHeight(1,U(20), sTextHeightName,_kLength);
	dTextHeight.setDescription(T("|Specifies the text height of the CNC operation. The default value of 0 will use the machine default one.|"));	
	dTextHeight.setCategory(category);


category = T("|Geometry|");
	String sGapName=T("|Gap|");
	PropDouble dGap(0,0, sGapName,_kLength);
	dGap.setDescription(T("|Specifies wether the marking is allowed on non touching beams|"));	
	dGap.setCategory(category);


	String sContactName=T("|Contact|");	
	PropString sContact(6, sNoYes, sContactName,0);	
	sContact.setDescription(T("|Defines wether the tool should stretch the male beam|"));
	sContact.setCategory(category);
	int bContact = sNoYes.find(sContact,0);
	
//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(kLastInserted);					
		}	
	// standard dialog	
		else	
			showDialog();

		Beam males[0], females[0];
		Element elements[0];
		
	// collect male beams or elements to insert on every connection
		PrEntity ssE(T("|Select elements and/or beams|"), Beam());
		ssE.addAllowedClass(Element());
		if (ssE.go())
			_Entity=ssE.set();
	
	// find at least 2 beams to keep the distribution instance alive (T-Tpye)
		for (int i=0;i<_Entity.length();i++) 
		{ 
			Entity ent = _Entity[i];
			Beam bm = (Beam) ent;
			Element el = (Element)ent;
			if (bm.bIsValid() && _Beam.find(bm)<0 && (_Beam.length()==0 || (_Beam.length()>0 && !bm.vecX().isParallelTo(_Beam[0].vecX()))))
			{
				_Beam.append(bm);
			}
			else if (el.bIsValid())
			{ 
				Beam beams[] = el.beam();
				for (int j=0;j<beams.length();j++) 
				{ 
					bm = beams[j]; 
					if (bm.bIsValid() && _Beam.find(bm)<0 && (_Beam.length()==0 || (_Beam.length()>0 && !bm.vecX().isParallelTo(_Beam[0].vecX()))))
					{
						_Beam.append(bm);
						if (_Beam.length() == 2)break;
					}
				}//next j				
			}
			if (_Beam.length() == 2)break;
		}//next i

		_Map.setInt("mode", 1);
		if (_Beam.length() < 2)eraseInstance();
		return;
	}	
// end on insert	__________________//endregion

//region Update catalog entries if painters are used but stream is not stored in catalog entry
	if ((sPainterStreamMale.length()==0 && sMaleDefaultFilters.findNoCase(sMaleFilter,-1)<0) || 
		(sPainterStreamFemale.length()==0 && sFemaleDefaultFilters.findNoCase(sFemaleFilter,-1)<0))
	{ 
		String streamMale, streamFemale;
		for (int i=0;i<2;i++) 
		{ 
			String filter = i == 0 ? sMaleFilter : sFemaleFilter;
			if (i==0 && (filter == tParallelX || filter == tParallelY)) { continue;}
			else if (i==1 && (filter == tDefault)) { continue;}
			
			PainterDefinition pd;
			if (bHasPainterCollection && sPainters.findNoCase(kPainterCollection +"\\"+filter,-1)>-1)
				pd = PainterDefinition(kPainterCollection + "\\"+filter);
			else if (sPainters.findNoCase(filter,-1)>-1)
				pd = PainterDefinition(filter);
			
		// Set stream
			if (pd.bIsValid())
			{ 
				Map m;
				m.setString("Name", pd.name());
				m.setString("Type",pd.type());
				m.setString("Filter",pd.filter());
				m.setString("Format",pd.format());
				
				if (i==0)streamMale=m.getDxContent(true);
				else if (i==1)streamFemale=m.getDxContent(true);
			}
		}//next i
		
		String entries[] = TslInst().getListOfCatalogNames(kScript);
		
		for (int i=0;i<entries.length();i++) 
		{ 
			String entry = entries[i]; 
			Map map = TslInst().mapWithPropValuesFromCatalog(kScript, entry);
			
			Map mapProp = map.getMap("PropString[]");
			
			String val0, val1, val2, val3;
			for (int j=0;j<mapProp.length();j++) 
			{ 
				Map m = mapProp.getMap(j);
				int index = m.getInt("nIndex");
				String value= m.getString("strValue");
				
				if (index == 7) val0 = value;		// index male filter property
				else if (index == 8) val1 = value;	// index female filter property
				else if (index == 9) val2 = value;	// index male stream
				else if (index == 10) val3 = value;	// index female stream
			}//next j 
			
			int bWrite;
			if (val0 == sMaleFilter && val2!= streamMale)
			{ 
				sPainterStreamMale.set(streamMale);
				bWrite = true;
			}
			if (val1 == sFemaleFilter && val3!= streamFemale)
			{ 
				sPainterStreamFemale.set(streamFemale);
				bWrite = true;
			}
			
			if (bWrite)
				setCatalogFromPropValues(entry);
			
		}//next i 
	}
//endregion 
//return;
//region Distribution Mode
	// 
	if (nMode==1)
	{ 

	//region Create Painterdefinition if legacy filter has been selected
		int x;
		x= sFilterCatalogEntries.findNoCase(sMaleFilter ,- 1);
		if (x>-1 && !bHasPainterCollection)
		{ 	
			String sCollection = scriptName();//"CollectionName";
			String sPainterName = sMaleFilter; 
			String sPainterType = "Beam";//Beam, Sheet, Panel,GenBeam
			String filter = sFilterDefinitions[x];
			
			PainterDefinition pd(sCollection + "\\" + sPainterName);
		
		// create painter
			if (filter.length()>0 && !pd.bIsValid())
			{ 
				pd.dbCreate();
				pd.setType(sPainterType);
				pd.setFilter(filter);				
			}
		}
		
		x = sFilterCatalogEntries.findNoCase(sFemaleFilter ,- 1);
		if (x>-1 && !bHasPainterCollection)
		{ 	
			String sCollection = kPainterCollection;//"CollectionName";
			String sPainterName = sFemaleFilter; 
			String sPainterType = "Beam";//Beam, Sheet, Panel,GenBeam
			String filter = sFilterDefinitions[x];
			
			PainterDefinition pd(kPainterCollection + "\\" + sPainterName);
		
		// create painter
			if (filter.length()>0 && !pd.bIsValid())
			{ 
				pd.dbCreate();
				pd.setType(sPainterType);
				pd.setFilter(filter);				
			}
		}		
	//endregion 
				
	// reset marking filter to default if male and female filters are identical
		int bIsMaleDefaultFilter = sMaleDefaultFilters.findNoCase(sMaleFilter ,- 1) >- 1;
		int bIsFemaleDefaultFilter = sFemaleDefaultFilters.findNoCase(sFemaleFilter ,- 1) >- 1;
		
		if (sMaleFilter==sFemaleFilter && bIsMaleDefaultFilter)
			sMaleFilter.set(tDefault);
		
	// Prerequisites to create TSL
		TslInst tslNew;
		GenBeam gbsTsl[2];			Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
		int nProps[]={};			
		double dProps[]={dGap,dTextHeight};				
		String sProps[]={sSide,sAlignment,sFormat,sHAlignment,sVAlignment,sOrientation, sContact, tDefault, tDefault,sPainterStreamMale,sPainterStreamFemale};
		Map mapTsl;	

		Beam males[0], females[0], beams[0];
		Element elements[0];
		
	// get elements and beams from sset	
		for (int i = 0; i < _Entity.length(); i++)
		{
			Entity ent = _Entity[i];
			Beam bm = (Beam) ent;
			Element el = (Element)ent;
			
			if (bm.bIsValid())
				beams.append(bm);
			else if (el.bIsValid() && elements.find(el)<0)
				elements.append(el);
		}
	
	// append beams if element found in sset
		for (int i=0;i<elements.length();i++) 
		{ 
			Element el= elements[i]; 
			Beam beamsE[] = el.beam();
			for (int j=0;j<beamsE.length();j++) 
			{ 
				Beam bm = beamsE[j];
				if (beams.find(bm)<0)
					beams.append(bm); 		 
			}//next j	 
		}//next i

	//region Collect male beams
		PainterDefinition pdMale;
		int nMalePainterDef = sPainters.findNoCase(kPainterCollection + "\\" + sMaleFilter ,- 1);
		// CollectionPainter
		if (bHasPainterCollection && nMalePainterDef>-1)
			pdMale = PainterDefinition(sPainters[nMalePainterDef]);
		// Default Painter
		else if (sPainters.findNoCase(sMaleFilter,-1)>-1)
			pdMale = PainterDefinition(sMaleFilter);	
		
		// Painter
		if (pdMale.bIsValid())
		{
			males = pdMale.filterAcceptedEntities(beams);
		}
		//Painterless
		else
		{
			for (int i=0;i<beams.length();i++) 
			{ 
				Beam bm = beams[i]; 
				Element el = bm.element();
				Vector3d vecXB = bm.vecX();
				
				if (el.bIsValid())
				{ 
				// exclude beams parallel to vecZ of element if in default 
					if (bIsMaleDefaultFilter && vecXB.isParallelTo(el.vecZ())){continue;}
				// exclude beams Xparallel
					if (sMaleFilter==tParallelX  && !vecXB.isParallelTo(el.vecX())){continue;}
				// exclude beams Xparallel
					if (sMaleFilter==tParallelY  && !vecXB.isParallelTo(el.vecY())){continue;}	
				// exclude beams non orthogonal
					if (sMaleFilter==tNonOrtho  && (vecXB.isParallelTo(el.vecX()) || vecXB.isParallelTo(el.vecY()))){continue;}				
				}
			
				if (males.find(bm)<0)
					males.append(bm);			
			}//next i			
		}
	//endregion 		

		
	//region Collect female beams
		PainterDefinition pdFemale;
		int nFemalePainterDef = sPainters.findNoCase(kPainterCollection + "\\" + sFemaleFilter ,- 1);
		// CollectionPainterl
		if (bHasPainterCollection && nFemalePainterDef>-1)
			pdFemale = PainterDefinition(sPainters[nFemalePainterDef]);
		// Default Painter
		else if (sPainters.findNoCase(sFemaleFilter,-1)>-1)
			pdFemale = PainterDefinition(sFemaleFilter);	
	
		// Painter
		if (pdFemale.bIsValid())
		{
			females = pdFemale.filterAcceptedEntities(beams);
		}
		//Painterless
		else
		{
			for (int i=0;i<beams.length();i++) 
			{ 
				Beam bm = beams[i]; 
				Element el = bm.element();
				Vector3d vecXB = bm.vecX();
				
				if (el.bIsValid())
				{ 
				// exclude beams parallel to vecZ of element if in default 
					if (bIsFemaleDefaultFilter && vecXB.isParallelTo(el.vecZ())){continue;}
				// exclude beams Xparallel
					if (sFemaleFilter==tParallelX  && !vecXB.isParallelTo(el.vecX())){continue;}
				// exclude beams Yparallel
					if (sFemaleFilter==tParallelY  && !vecXB.isParallelTo(el.vecY())){continue;}	
				// exclude beams non orthogonal
					if (sFemaleFilter==tNonOrtho  && (vecXB.isParallelTo(el.vecX()) || vecXB.isParallelTo(el.vecY()))){continue;}	
				}
			
				if (females.find(bm)<0)
					females.append(bm);			
			}//next i				
		}
			
	//endregion 
//		for (int b=0;b<males.length();b++) 
//		{ 
//			males[b].envelopeBody().vis(6);
//		}//next b
		
		for (int i=0; i<males.length(); i++)
		{ 
			Beam male = males[i];
			Vector3d vecX0 = male.vecX();
			Vector3d vecY0 = male.vecY();
			Vector3d vecZ0 = male.vecZ();
			Point3d ptCen = male.ptCen();
			male.envelopeBody().vis(6);
			Beam contacts[0];
			// HSB-22873: use gap as argument to getting contacts
//			contacts = male.filterBeamsCapsuleIntersect(females);
			contacts = Beam().filterBeamsCapsuleIntersect(females,LineSeg(ptCen-vecX0*.5*male.dL(),
				ptCen+vecX0*.5*male.dL()),dGap);
			
			if(contacts.length()==0)
			{ 
				continue;
			}
		// refine contact beams as capsule intersect might also collect beams without a contact	
			Body bdMale(ptCen,vecX0,vecY0,vecZ0,male.solidLength()+2*(dEps+dGap), male.solidWidth(), male.solidHeight(), 0,0,0);
			for (int j=contacts.length()-1; j>=0 ; j--) 
			{ 
				Beam& b = contacts[j];
				Body bd =  contacts[j].envelopeBody(false, true);
				if(!bd.hasIntersection(bdMale) || vecX0.isParallelTo(b.vecX()))
					contacts.removeAt(j);
			}


			gbsTsl[0] = male;
		

		// create for each contact found
			for (int j=contacts.length()-1;j>=0; j--)
			{
				Vector3d vecDir = vecX0;
				Beam& b = contacts[j];
				Element e = b.element();
				
				LineBeamIntersect lbi(ptCen,vecDir , b);
				if (lbi.nNumPoints()<1){continue;}
				Point3d pt = lbi.pt1();
				
				Vector3d vecZ =b.vecD(vecDir.crossProduct(b.vecX()));
				if (vecDir.dotProduct(lbi.vecNrm1())<0)
					vecDir *= -1;
				
			// align by property element vecZ	
				if (e.bIsValid() && e.vecZ().isParallelTo(vecZ))
				{
					double d = e.vecZ().dotProduct(b.ptCen() - (e.ptOrg() - .5 * e.vecZ() * e.dBeamWidth()));
					if (sSide==tInside)
					{
						vecZ = d < 0 ? e.vecZ() :- e.vecZ();
						sProps[0] = d < 0 ? tRefSide:tOppSide;
					}
					else if (sSide==tOutside)
					{
						vecZ = d > 0 ? e.vecZ() :- e.vecZ();
						sProps[0] = d > 0 ? tRefSide:tOppSide;
					}
					else
					{
						vecZ = e.vecZ();
						sProps[0] = sSide;
					}
				}
				else if (!e.bIsValid())
				{ 
					if (sSide == tInside)sProps[0] =tRefSide;
					else if (sSide == tOutside)sProps[0] =tOppSide;
					
				}
				
				//pt += b.vecD(vecZ) * vecZ.dotProduct(b.ptCen() - pt);
				vecDir.vis(pt, j);
				vecZ.vis(pt, 150);
				gbsTsl[1]=b;
				ptsTsl[0] = pt;
				if (!bDebug)
					tslNew.dbCreate(scriptName() ,vecX0 ,vecY0,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
			}

		}

		if (!bDebug)eraseInstance();
		return;
	}
//endregion 	
	

	
// initial color
	if (_bOnDbCreated)
		_ThisInst.setColor(10);
	_ThisInst.setAllowGripAtPt0(false);

	
// TriggerFlipSide
	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContextRoot, sTriggerFlipSide);
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide|| _kExecuteKey==sDoubleClick))
	{
		if (nSide==0)nSide=1;
		else if (nSide==1)nSide=0;
		else if (nSide==2)nSide=3;
		else if (nSide==3)nSide=2;

		sSide.set(sSides[nSide]);
		setExecutionLoops(2);
		return;
	}


	int nOrientation= sOrientations.find(sOrientation);
	int nTextOrientation= nOrientation>-1?nOrientations[nOrientation]:0;
	int nHAlignment = (sHAlignments.find(sHAlignment)-1);
	int nVAlignment = sVAlignments.find(sVAlignment)-1;


// standard T
	Vector3d vecX = _Z1;
	Vector3d vecY = _X1;
	Vector3d vecZ = _Y1;
	Beam bm0 = _Beam[0];
	Beam bm1 = _Beam[1];
	setDependencyOnBeamLength(bm0);
	setDependencyOnBeamLength(bm1);


// erase duplicates of t-connections
	Entity tents[] = bm1.eToolsConnected();
	for (int i=0;i<tents.length();i++) 
	{ 
		TslInst tsl = (TslInst)tents[i];
		if (tsl.bIsValid() && tsl.scriptName() == scriptName() && tsl!=_ThisInst && 
			tsl.propString(0) == sSide &&
			tsl.propString(1) == sAlignment)
		{
			Beam beams[] = tsl.beam();
			if (beams.find(bm0)>-1 && beams.find(bm1)>-1)
			{
				//reportMessage("\n" + scriptName() + ": " +T("|duplicate will be purged.|"));
				eraseInstance();
				break;
			}
		}
	}


// test t-Connection
	int bHasTConnection = bm0.hasTConnection(bm1, dEps+dGap, true);

// do not accept any dummy connection
	if(bm0.bIsDummy() || bm1.bIsDummy() || (!bHasTConnection && !bContact))
	{
		//reportMessage("\n" + scriptName() + ": " +T("|Invalid connection.|"));		
		eraseInstance();
		return;
	}

	Body bd0, bd1=bm1.realBody();

// add contact cut
	Cut cut(_Pt0-vecX*dGap, vecX);
	if (bContact)
	{
		bm0.addTool(cut, _kStretchOnToolChange);
	}
// on the event of changing the contact state
	else if (_kNameLastChangedProp == sContactName && !bContact)
	{
		bm0.addToolStatic(cut, 1);
	}



	Plane pnRef(_Pt0,vecX);	
	if(nSide==1)pnRef = Plane(_Pt0+vecX*bm1.dD(vecX), vecX);

// set side direction reference vector (what's left and what's right?)
	Vector3d vecDir = vecY;
	
// adjust vecZ if linked to an element
	Element el=bm1.element();
	if (el.bIsValid())
	{
	// the default view direction is positive X on horizontal connections...
		if (vecX.isParallelTo(el.vecX()))
			vecDir = -el.vecY();
	// ...and vecY on all other connections
		else
			vecDir = el.vecX();
			
		if (vecZ.isParallelTo(el.vecZ()))
		{
			vecZ = el.vecZ();	
			vecY = vecX.crossProduct(-vecZ);
		}
		assignToElementGroup(el,true,0,'T');
	}
	Vector3d vecSides[]= {-vecX,vecX,vecZ,-vecZ};
	Vector3d vecSide = nSide>-1?vecSides[nSide]:-vecX;
	
	Point3d ptRef = _Pt0+vecZ*vecZ.dotProduct(bm1.ptCenSolid()-_Pt0);
	vecX.vis(ptRef,1);	vecY.vis(ptRef,3);	vecZ.vis(ptRef,150);

// get locations
	Point3d pts[0];
	Vector3d vecN =vecDir.dotProduct(vecY)>0?vecY:-vecY;
	if (abs(nAlignment)==1)
		vecN*=nAlignment;
	
	// if beams are not perpendicular run extended contact test
	if (!bm0.vecX().isPerpendicularTo(bm1.vecX()))
	{
		bd0 = bm0.realBody();
		PlaneProfile pp0 = bd0.extractContactFaceInPlane(Plane(_Pt0,_Z1), dGap+dEps);
		pp0.vis(2);
		LineSeg seg0 = pp0.extentInDir(vecZ);
		Point3d pts0[]= { seg0.ptStart(), seg0.ptEnd()};
		Line ln(_Pt0,vecN);
		pts0 = ln.orderPoints(ln.projectPoints(pts0));	
		
		if (pts0.length()<2)
		{
			reportMessage("\n"+ scriptName() + " " + T("|No location found.|"));
			eraseInstance();
			return;
		}
		
	// project locations to opposite face
		if(nSide==1)
		{
			pts0[0] = Line(pts0[0],_X0).intersect(pnRef,0);
			pts0[1] = Line(pts0[1],_X0).intersect(pnRef,0);			
		}

	// append to collector
		if (nAlignment==0)
			pts.append((pts0[0]+pts0[1])/2);
		else
		{ 
			if (nAlignment!=0 && nAlignment!=1)
			{
				pts.append(pts0[0]);
			}
			if (nAlignment>0)
			{
				pts.append(pts0[1]);
			}
		}
	}
	else if (nAlignment==0)
		pts.append(_Pt0);
	else
	{ 
	// left or right
		{
			Line ln(ptRef,_X0);
			ln.transformBy(bm0.vecD(vecN)*.5*bm0.dD(vecN));
			pts.append(ln.intersect(pnRef,0));
		}
	// left and right	
		if (nAlignment==2)
		{
			Line ln(ptRef,_X0);
			ln.transformBy(bm0.vecD(-vecN)*.5*bm0.dD(vecN));
			pts.append(ln.intersect(pnRef,0));
		}

	}
	Point3d ptsLocs[0];
	ptsLocs=pts;
	
// get contact face to validate locations
	PlaneProfile ppFace = bd1.extractContactFaceInPlane(pnRef, dEps);
//	ppFace.shrink(-U(3.1));
//	ppFace.shrink(U(3.1));
	PLine plRings[] = ppFace.allRings();
	int bIsOp[] = ppFace.ringIsOpening();
	ppFace.removeAllRings();
	for (int r=0;r<plRings.length();r++)
		if (!bIsOp[r])
			ppFace.joinRing(plRings[r],_kAdd);		
	
	
	ppFace.vis(6);
	LineSeg segFace = ppFace.extentInDir(vecZ);
	Point3d ptsFace[]= { segFace.ptStart(), segFace.ptEnd()};
	for (int i=ptsLocs.length()-1; i>=0 ; i--) 
	{ 
		Point3d pt= ptsLocs[i]; 
		int bRemove=ppFace.pointInProfile(pt)==_kPointOutsideProfile;
		if(!bRemove)
		for (int j=0 ; j<ptsFace.length() ; j++) 
		{ 
		    Point3d ptFace = ptsFace[j]; 
		    if (abs(vecY.dotProduct(ptFace-pt))<dEps)
		    {
		    	bRemove=true;
		    	break;
		    }
		}

		if(bRemove)
			ptsLocs.removeAt(i);
	}

//region Tool and Display
	String sMarkingText = bm0.formatObject(sFormat);
	int bHasText = sMarkingText.length()>0;

// remove if no point found	
	if (!bContact && ptsLocs.length()<1 && !bHasText)
	{
		reportMessage("\n" + scriptName() + ": " +T("|could not find any valid marking location.|") + " " + T("|Tool will be deleted.|"));
		eraseInstance();
		return;
	}
	
// Display
	Display dp(_ThisInst.color());
	dp.addHideDirection(vecZ);
	dp.addHideDirection(vecZ);
	Display dpElement(_ThisInst.color());
	dpElement.addViewDirection(vecZ);
	dpElement.addViewDirection(-vecZ);
	
// mark
	int nNumLocs = ptsLocs.length();
	int nNumPts = pts.length();
	
	if(nNumLocs>0)
	{ 
		Mark mrk;
		if (bHasText && nNumLocs==1 && nNumLocs<nNumPts)	
		{
		// place text centered to the theoretical locations
			mrk = Mark( (pts[0]+pts[1])/2, vecSide,sMarkingText);
			mrk.suppressLine();
			
		// add second mark which will just do the markers	
			Mark mrk2(ptsLocs[0], vecSide);
			bm1.addTool(mrk2);
			
		}
		// marking location out of range, but text requested   // version 1.1
		else if (bHasText && nNumLocs==0)	
		{
			Point3d pt; 
			pt.setToAverage(pts);
			
		// text location is also invalid -> move by half bm0 width	
			for (int j=0 ; j<ptsFace.length() ; j++) 
			{ 
			    Point3d ptFace = ptsFace[j]; 
			    if (abs(vecY.dotProduct(ptFace-pt))<dEps)
			    {
			    	Vector3d vec = vecY;
			    	if (vec.dotProduct(segFace.ptMid()-pt)<0)
			    		vec*=-1;
					pt.transformBy(vec*.5*bm0.dD(vec));	
					pt.vis(6);
					
					PLine plCirc;
				    plCirc.createCircle(pt, vecX, U(3));
				    dp.draw(plCirc);
					
			    	break;
			    }
			}		
			mrk = Mark( pt, vecSide,sMarkingText);
			mrk.suppressLine();
		}
		else if (bHasText && nNumLocs==2)	
			mrk = Mark( ptsLocs[0], ptsLocs[1], vecSide, sMarkingText);
		else if (bHasText && nNumLocs==1)	
			mrk = Mark( ptsLocs[0], vecSide, sMarkingText);
		else if (nNumLocs==2 && pts.length()==2)	
			mrk = Mark( ptsLocs[0], ptsLocs[1], vecSide);
		else if (nNumLocs==1)	
			mrk = Mark( ptsLocs[0], vecSide);		
		if (bHasText)
		{
			mrk.setTextPosition(nVAlignment ,nHAlignment ,nTextOrientation);
			mrk.setTextHeight(dTextHeight);
		}
		bm1.addTool(mrk);
	}
	
// draw
	for (int i=0 ; i < ptsLocs.length() ; i++) 
	{ 
	    Point3d pt1 = ptsLocs[i]; 
	    PLine pl;
	    if (nSide>1)
	    {
	    	pt1.transformBy(vecSide*.5*bm1.dD(vecSide));
	    	Point3d pt2 = pt1+bm1.vecD(_X0)*bm1.dD(_X0);
	    	pl = PLine(pt1,pt2);
	    }
	    else
	    	pl = PLine(pt1-vecZ*.5*bm1.dD(vecZ),pt1+vecZ*.5*bm1.dD(vecZ));
	    
	    dp.draw(pl);
	    PLine plCirc;
	    plCirc.createCircle(pl.ptMid(), vecX, U(2));
	    dp.draw(plCirc);
	    vecSide.vis(pt1,i);
	    
	    plCirc.createCircle(pl.ptMid(), vecZ, U(2));
	    dpElement.draw(plCirc);
	    
	     
	}	
	
// draw contact symbol
	if (bContact)
	{
		double dDiam = bm0.dW()<bm0.dH()?bm0.dW():bm0.dH();
		PLine plCirc;
		plCirc.createCircle(_Pt0, vecX, dDiam*.25);
		dp.draw(plCirc);
	
		if(dGap>dEps)
		{
			Point3d pt = _L0.intersect(pnRef, -dGap);
			plCirc.transformBy(pt-_Pt0);
			dp.draw(plCirc);	
			dp.draw(PLine(pt,_Pt0));
		}	
	}		
//endregion 

//region Legacy Filter Import
	// Multiple filters might be stored in catalog, but only some could apply to this tsl: allow the user to decide which legacy filters to be migrated topainter definitions
	String sTriggerMigrateAll =T("|Migrate Filters -> Painters|");
	if (sFilterCatalogEntries.length()>0)
		addRecalcTrigger(_kContext, sTriggerMigrateAll );
	for (int i=0;i<sFilterCatalogEntries.length();i++) 
	{ 
		String sPainterName = sFilterCatalogEntries[i]; 
		String sPainterType = "Beam";//Beam, Sheet, Panel,GenBeam
		String filter = sFilterDefinitions[i];
			
		PainterDefinition pd(kPainterCollection + "\\" + sPainterName);
		
	// create painter
		if (filter.length()>0 && !pd.bIsValid())
		{ 
			String sTriggerMigrate = "   "+sPainterName;
			addRecalcTrigger(_kContext, sTriggerMigrate );
			if (_bOnRecalc && (_kExecuteKey==sTriggerMigrate || _kExecuteKey==sTriggerMigrateAll))
			{
				pd.dbCreate();
				pd.setType(sPainterType);
				pd.setFilter(filter);	
				
				if (_kExecuteKey==sTriggerMigrate)
				{
					setExecutionLoops(2);
					return;
				}	
			}				
		}
	}//next i
	if(_kExecuteKey==sTriggerMigrateAll)
	{ 
		setExecutionLoops(2);
		return;		
	}
//endregion 







#End
#BeginThumbnail
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
E9/\`PC8C8^1>S1J?X16]10!AQ>&H5E62:YEE93GFMRBB@#__V;(6
`







#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.001" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="770" />
        <int nm="BreakPoint" vl="753" />
        <int nm="BreakPoint" vl="610" />
        <int nm="BreakPoint" vl="522" />
        <int nm="BreakPoint" vl="700" />
        <int nm="BreakPoint" vl="708" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22873: Fix when getting contacts with the male beam" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="10/25/2024 2:00:10 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19669 painter collection folders are not case sensitive anymore " />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="7/28/2023 9:34:24 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15457 formatting helper enabled for hsbDesign24 and higher" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="6/3/2022 2:02:01 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15457 formatting helper disabled for hsbDesign23" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="6/3/2022 1:59:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15457 new marking sides for twin walls, painter support, supports TSL-Filter -&gt; Painterdefinition migration" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="6/1/2022 8:50:35 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15457 excluded blockings of twinwalls to be marked on element selection" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="5/12/2022 10:19:54 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="meter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End