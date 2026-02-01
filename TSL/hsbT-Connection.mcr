#Version 8
#BeginDescription
This TSL is outdated, "T-Connection.mcr" is the replacement
This tsl creates a t-connection between a amle and a set of female beams. It may be inserted by
   - individual beam selection
   - a set of beams
   - element selection, optional with filter rules and exclude sets
Property "byBeamCode/byBeamFormat" can be used to define a beamcode string or a format String as a filter
One should use either format or beamcode
When using format user can define multiple formats separated by a ";"
When using beamcode the user should only define one string for the beamcode
Format can also be used for a certain token of the beamcode
@(BeamCode:T1) will point to the 1st token of the beamcode
for the following beamCode: ;BSH;;;;;;;;C24;;Ständer; it will refere to "BSH"

#Versions:
Version 2.22 04/03/2025 HSB-23612: Modifications for Baufritz , Author Marsel Nakuci
2.21 07.01.2025 HSB-22182: This TSL is outdated, "T-Connection.mcr" is the replacement Author: Marsel Nakuci
2.20 12.05.2023 HSB-18801: Enter wait state if no element beam found (beams without panhand state) 
2.19 05.05.2023 HSB-18893 stretch plane of male adjusted parallel to contact plane to receive proper envelopeBody
2.18 27.10.2022 HSB-16850: remove tolerance at line-plane intersection
2.17 26.09.2022 HSB-16469: Fix calculation for elements when investigating male-females; avoid duplicated instances
2.16 01.09.2022 HSB-15478: apply beamcut only when it does something to the beam
2.15 26.07.2022 HSB-11195 redundant tool on male beam end suppressed

2.14 28.10.2021 HSB-13421: better description for sBeamCodeFormat property
2.13 22.10.2021 HSB-13421: add description for sBeamCodeFormat
2.12 18.10.2021 HSB-13421: add filter byFormat/byBeamcode
2.11 12.07.2021 HSB-12395: property "rotated beam" added
2.10 12.07.2021 HSB-12394 stretch beamcut if it falls outside the boundaries of the female beam
2.9 15.03.2021 HSB-11195: supports connection of 1 male and 2 skew females
version value="2.8" date="10oct19" author="thorsten.huck@hsbcad.com"
HSB-5610 sequence number 50 added on element constructed
HSB-5610 include color filter fixed for female beams 
HSB-5558 contact symbol fixed for sloped beams

display the TSL at the middle of female beam instead of the male beambugfix inserting based on elements
bugfix inserting single connection
rule type 1: bugfix if only one horizontal beam is found












#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 22
#KeyWords T;connection;T-Connection;Format;BeamCode
#BeginContents
/// <History>
//#Versions:
// 2.22 04/03/2025 HSB-23612: Modifications for Baufritz , Author Marsel Nakuci
// 2.21 07.01.2025 HSB-22182: This TSL is outdated, "T-Connection.mcr" is the replacement Author: Marsel Nakuci
// 2.20 12.05.2023 HSB-18801: Enter wait state if no element beam found (beams without panhand state) Author: Marsel Nakuci
// 2.19 05.05.2023 HSB-18893 stretch plane of male adjusted parallel to contact plane to receive proper envelopeBody , Author Thorsten Huck
// 2.18 27.10.2022 HSB-16850: remove tolerance at line-plane intersection Author: Marsel Nakuci
// 2.17 26.09.2022 HSB-16469: Fix calculation for elements when investigating male-females; avoid duplicated instances Author: Marsel Nakuci
// 2.16 01.09.2022 HSB-15478: apply beamcut only when it does something to the beam Author: Marsel Nakuci
// 2.15 26.07.2022 HSB-15478: HSB-11195 redundant tool on male beam end suppressed , Author Thorsten Huck
// Version 2.14 28.10.2021 HSB-13421: better description for sBeamCodeFormat property Author: Marsel Nakuci
// Version 2.13 22.10.2021 HSB-13421: add description for sBeamCodeFormat Author: Marsel Nakuci
// Version 2.12 18.10.2021 HSB-13421: add filter byFormat/byBeamcode Author: Marsel Nakuci
// Version 2.11 12.07.2021 HSB-12395: property "rotated beam" added Author: Marsel Nakuci
// Version 2.10 12.07.2021 HSB-12394: stretch beamcut if it falls outside the boundaries of the female beam Author: Marsel Nakuci
// Version 2.9 15.03.2021 HSB-11195: supports connection of 1 male and 2 skew females Author: Marsel Nakuci
/// <version value="2.8" date="10oct19" author="thorsten.huck@hsbcad.com"> HSB-5610 sequence number 50 added on element constructed </version>
/// <version value="2.7" date="12sep19" author="thorsten.huck@hsbcad.com"> HSB-5610 include color filter fixed for female beams </version>
/// <version value="2.6" date="03sep19" author="thorsten.huck@hsbcad.com"> HSB-5558 contact symbol fixed for sloped beams </version>
/// <version value="2.5" date="17apr18" author="marsel.nakuci@hsbcad.com"> display the TSL at the middle of female beam instead of the male beam </version>
/// <version value="2.4" date="19sep18" author="thorsten.huck@hsbcad.com"> bugfix inserting based on elements </version>
/// <version value="2.3" date="05jul18" author="thorsten.huck@hsbcad.com"> bugfix inserting single connection </version>
/// <version value="2.2" date="05jun18" author="thorsten.huck@hsbcad.com"> rule type 1: bugfix if only one horizontal beam is found </version>
/// <version value="2.1" date="13apr18" author="thorsten.huck@hsbcad.com"> filter methods color/beamtype and width seperated for male and female beams </version>
/// <version value="2.0" date="11apr18" author="thorsten.huck@hsbcad.com"> rule type 1: horizontal extreme beams are not excluded if a vertical stud is located above or below </version>
/// <version value="1.9" date="10apr18" author="thorsten.huck@hsbcad.com"> rule type 1: angled plates are also excluded </version>
/// <version value="1.8" date="13mar18" author="thorsten.huck@hsbcad.com"> bugfix rule type 1 and multiple bottome/top beams, new filter methods color/beamtype and width added </version>
/// <version value="1.7" date="08mar18" author="thorsten.huck@hsbcad.com"> changed type from T-Type to O-Type to provide element-tsl functionality </version>
/// <version value="1.6" date="01mar18" author="thorsten.huck@hsbcad.com"> new element rule added </version>
/// <version value="1.5" date="26jan18" author="thorsten.huck@hsbcad.com"> color filter added </version>
/// <version value="1.4" date="26jan18" author="thorsten.huck@hsbcad.com"> bugfix filter </version>
/// <version value="1.3" date="21oct17" author="thorsten.huck@hsbcad.com"> supports element selection, exclude selection set, multiple femalen beams </version>
/// <version value="1.2" date="24oct17" author="thorsten.huck@hsbcad.com"> female beam will be milled over entire width </version>
/// <version value="1.1" date="09dec16" author="thorsten.huck@hsbcad.com"> debug message removed </version>
/// <version value="1.0" date="14Oct16" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select male and female bema(s), select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This TSL is outdated, "T-Connection.mcr" is the replacement
/// This tsl creates a t-connection between a male and a set of female beams. It may be inserted by
///		- individual beam selection
///		- a set of beams
///		- element selection, optional with filter rules and exclude sets
/// Property "byBeamCode/byBeamFormat" can be used to define a beamcode string or a format String as a filter
/// One should use either format or beamcode
/// When using format user can define multiple formats separated by a ";"
/// When using beamcode the user should only define one string for the beamcode
/// Format can also be used for a certain token of the beamcode
/// @(BeamCode:T1) will point to the 1st token of the beamcode
/// for the following beamCode: ;BSH;;;;;;;;C24;;Ständer; it will refere to "BSH"
/// </summary>
//

// commands
// command to create tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbT-Connection")) TSLCONTENT
// command to reset and erase connection
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Reset + Erase|") (_TM "|Select T-Connection|"))) TSLCONTENT
	
	
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
	// HSB-23612
	String sProjectSpecial=projectSpecial();
	sProjectSpecial.makeUpper();
	int bBaufritz=sProjectSpecial=="BAUFRITZ";
//endregion
	
	
// properties//region
	category = T("|Geometry|");
	String sDistanceName="(A) " + T("|Depth|")+"/"+T("|Distance|");	
	PropDouble dDistance(nDoubleIndex++, U(0), sDistanceName);	
	dDistance.setDescription(T("|Defines the depth (+) or distance (-) of the connection|"));
	dDistance.setCategory(category);
	
	String sGapName="(B) " +T("|Gap|");	
	PropDouble dGap(nDoubleIndex++, U(0), sGapName);
	dGap.setDescription(T("|Defines the Gap|"));
	dGap.setCategory(category);
	// HSB-12395: allow rotated male beams
	
	String sRotatedBeamName=T("|Rotated Beam|");
	PropString sRotatedBeam(5, sNoYes, sRotatedBeamName);
	sRotatedBeam.setDescription(T("|Flag to indicate whether the beamcut should follow the rotated beam. 
If the property is set to No the beamcut is perpendicular to the female beam. If the property is set to Yes the beamcut follows the rotated male beam|"));
	sRotatedBeam.setCategory(category);
// filter
	category = T("|Filter|");
	String sMaxLengthName="(C) " + T("|Max. Stud Length|");	
	PropDouble dMaxLength(nDoubleIndex++, U(0), sMaxLengthName);
	dMaxLength.setDescription(T("|Defines the maximal allowed length of the male beam|"));
	dMaxLength.setCategory(category);
	
	String sRules[] = { T("|Disabled|"), T("|Exclude bottom, top and angled plate|"),T("|Only studs against top plate|")};
	String sRuleName="(D) " + T("|Element| ") + T("|Rule|");
	PropString sRule(nStringIndex++,sRules, sRuleName);	
	sRule.setDescription(T("|Defines a rule to filter certain types|"));
	sRule.setCategory(category);
	
// male filter	
	category = T("|Filter Male Beams|");
	String sColorFilterName=T("(E) |byColor/Beamtype|");
	PropString sColorFilter(nStringIndex++, "", sColorFilterName);	
	sColorFilter.setDescription(T("|Defines a filter based on colors and/or beamtypes.|")  + T("|Separate multiple entries by a semicolon.| (';')") + T("|negative values are excluding beams with the corresponding color|")+ T(", |Positive values will only accept beams with the selected colors.|")+ T(" |Any negative value will disable potential positive values.|"));
	sColorFilter.setCategory(category);	
	
	String sWidthFilterName=T("(F) |byWidth|");	
	PropString sWidthFilter(nStringIndex++, "", sWidthFilterName);
	sWidthFilter.setDescription(T("|Defines a filter based on the width.|")  + T("|Separate multiple entries by a semicolon.| (';')") + T("|negative values are excluding beams with the corresponding width|")+ T(", |Positive values will only accept beams with the selected width.|")+ T(" |Any negative value will disable potential positive values.|"));
	sWidthFilter.setCategory(category);	
	//HSB-13421
	String sBeamCodeFormatName=T("|byBeamCode/byFormat|");	
	PropString sBeamCodeFormat(6, "", sBeamCodeFormatName);	
	sBeamCodeFormat.setDescription(T("|Defines a filter based on the beamcode or Format, but not both.|")+ T(" |Format can have multiple entries separated by a semicolon.| (';')")+T(" |When using beamcode the user should only define one string for the beamcode.|")+T(" |Format can also be used for a certain token of the beamcode.|")+
		T(" @(BeamCode:T1) |will point to the 1st token of the beamcode|"));
	sBeamCodeFormat.setCategory(category);
// femmale filter	
	category = T("|Filter Female Beams|");
	String sColorFemaleFilterName=T("(G) |byColor/Beamtype|");
	PropString sColorFemaleFilter(nStringIndex++, "", sColorFemaleFilterName);
	sColorFemaleFilter.setDescription(T("|Defines a filter based on colors and/or beamtypes.|")  + T("|Separate multiple entries by a semicolon.| (';')") + T("|negative values are excluding beams with the corresponding color|")+ T(", |Positive values will only accept beams with the selected colors.|")+ T(" |Any negative value will disable potential positive values.|"));
	sColorFemaleFilter.setCategory(category);
	
	String sWidthFemaleFilterName=T("(H) |byWidth|");
	PropString sWidthFemaleFilter(nStringIndex++, "", sWidthFemaleFilterName);	
	sWidthFemaleFilter.setDescription(T("|Defines a filter based on the width.|")  + T("|Separate multiple entries by a semicolon.| (';')") + T("|negative values are excluding beams with the corresponding width|")+ T(", |Positive values will only accept beams with the selected width.|")+ T(" |Any negative value will disable potential positive values.|"));
	sWidthFemaleFilter.setCategory(category);
	//HSB-13421
	String sBeamCodeFormatFemaleName=T("|byBeamCode/byFormat|");	
	PropString sBeamCodeFormatFemale(7, "", sBeamCodeFormatFemaleName);	
	sBeamCodeFormatFemale.setDescription(T("|Defines a filter based on the beamcode or Format, but not both.|")+ T(" |Format can have multiple entries separated by a semicolon.| (';')")+T(" |When using beamcode the user should only define one string for the beamcode.|")+T(" |Format can also be used for a certain token of the beamcode.|")+
		T(" @(BeamCode:T1) |will point to the 1st token of the beamcode|"));
	sBeamCodeFormatFemale.setCategory(category);
//endregion
	
	
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
			reportMessage("\nMap: " + _Map);
			setPropValuesFromMap(_Map);
			_Map = Map();
		}	
	}
	
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
			showDialog();
		
	// selection supports the selection of male beams or elements. If elements are selected there will be no prompt for female beams
	// select (multiple) beams to insert the connector
		Beam bmMales[0], bmFemales[0],bmExcludes[0];
		Element elements[0];
		
		PrEntity ssMale(T("|Select male beam(s) or element(s)|"), Beam());
		ssMale.addAllowedClass(Element());
		if (ssMale.go())
		{
			bmMales = ssMale.beamSet();
			elements = ssMale.elementSet();
		}			

		int bElementMode = elements.length() > 0;
		
	// the prompt varies whether elements have been selected or not
		String sPrompt = bElementMode ? T("|Select beam(s) to be excluded|")+T(", |<Enter> = none|"): T("|Select female beam(s)|") + ", " + T("|<Enter> = Automatic|");
		PrEntity ssFemale(sPrompt, Beam());
		if (ssFemale.go())
		{
			if (bElementMode)
			{
				bmExcludes = ssFemale.beamSet();
				for (int i=bmMales.length()-1; i>=0 ; i--) 
				{ 
					int n = bmExcludes.find(bmMales[i]);
					if (n>-1)	bmMales.removeAt(n);	
				}
			}
			else
			{
				bmFemales = ssFemale.beamSet();	
			// automatic -> all males and females are connected among each other
				if (bmFemales.length()==0)
					bmFemales = bmMales;
			}
		}
		
	// store as entity arrays
		Entity entExcludes[0];
		for (int i=0;i<bmExcludes.length();i++) 
			entExcludes.append(bmExcludes[i]); 
		Entity entMales[0];
		for (int i=0;i<bmMales.length();i++) 
			entMales.append(bmMales[i]); 
		Entity entFemales[0];
		for (int i=0;i<bmFemales.length();i++) 
			entFemales.append(bmFemales[i]); 			
		
	// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE; Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[] = {}; Entity entsTsl[] = {}; Point3d ptsTsl[] = {};
		int nProps[]={};
		double dProps[]={dDistance, dGap, dMaxLength};
		String sProps[]={sRule, sColorFilter,sWidthFilter,sColorFemaleFilter,sWidthFemaleFilter, sRotatedBeam, sBeamCodeFormat, sBeamCodeFormatFemale};
		Map mapTsl;
		String sScriptname = scriptName();
		
	// element mode	
		if (bElementMode)
		{ 
			for (int i=0;i<elements.length();i++) 
			{ 
				entsTsl.setLength(0);
				entsTsl.append(elements[i]); 
				ptsTsl.setLength(0);
				ptsTsl.append(elements[i].ptOrg()); 
				//
				if (entExcludes.length()>0)
					mapTsl.setEntityArray(entExcludes, false, "excludes", "excludes", "excludes");
				tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
						nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
		}
	// beam mode
		else
		{ 
			
			mapTsl.setEntityArray(entMales, false, "males", "males", "males");
			mapTsl.setEntityArray(entFemales, false, "females", "females", "females");
			tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
					nProps, dProps, sProps,_kModelSpace, mapTsl);			
		}
		eraseInstance();
		return;
	}
// end on insert	__________________	
	
// modes
	int nMode=-1; // 0 = beam/beam connection, 1 = element, 2 = beam set creation
	Beam bmMales[0], bmFemales[0];
// rule
	int nRule = sRules.find(sRule);
	if (nRule<0)
	{ 
		nRule = 0;
		sRule.set(sRules[nRule]);
	}
	if (_bOnElementConstructed)_ThisInst.setSequenceNumber(50);
	if (_bOnDbCreated)setExecutionLoops(2);
	
// mode 0: beam/beam connection
	if (_Beam.length()>1)
	{ 
		nMode=0;	
	}
// mode 1: element mode: create individual connections
	else if (_Element.length()>0)
	{ 
		//bDebug = true;
		
		Element el = _Element[0];
		CoordSys cs = el.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		Point3d ptOrg = cs.ptOrg();
		assignToElementGroup(el,true, 0,'E');// assign to element tool sublayer
		if (bDebug)_Pt0 = ptOrg;
	// collect beams
		Beam beams[] = el.beam();
	// HSB-18801: make sure the element has beams that are not panhand
		Beam beamsNotPanhand[0];
		for (int ib=0;ib<beams.length();ib++) 
		{ 
			if(!beams[ib].panhand().bIsValid())
			{ 
				beamsNotPanhand.append(beams[ib]);
			}
		}//next ib
		
		
	// HSB-18801: wait state
		if (beams.length()<1 || beamsNotPanhand.length()<1)
		{ 
			setExecutionLoops(2);
			Display dp(0);
			dp.textHeight(U(50));
			dp.draw(scriptName(), el.segmentMinMax().ptMid(), vecX, vecY, 0, 0);
			return;
		}
		
	// collect and remove during insert excluded beams
		Entity ents[] = _Map.getEntityArray("excludes","excludes","excludes");
		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
			int n = beams.find(ents[i]);
			if (n>-1)
				beams.removeAt(n);
		}
		bmMales = beams;
		bmFemales = bmMales;
		nMode = 1;
	}
	else
	{ 
		Entity entMales[] = _Map.getEntityArray("males","males","males");
		for (int i=0;i<entMales.length();i++) 
		{ 
			Beam bm = (Beam)entMales[i];
			if (bm.bIsValid() && !bm.bIsDummy())
				bmMales.append(bm);
			 
		}
		
		Entity entFemales[] = _Map.getEntityArray("females","females","females");
		for (int i=0;i<entFemales.length();i++) 
		{ 
			Beam bm = (Beam)entFemales[i];
			if (bm.bIsValid() && !bm.bIsDummy())
				bmFemales.append(bm);
			 
		}
		
		int nNumMale = bmMales.length();
		int nNumFemale = bmFemales.length();
		
		
		if(nNumMale==1 && nNumFemale==1)
		{ 
			_Beam.append(bmMales[0]);
			_Beam.append(bmFemales[0]);
		}	
		else if (bmMales.length()>1 || (bmFemales.length()>1 && bmMales.length()>0))
			nMode = 2;
		else
		{ 
			if (bDebug)reportMessage("\n" + scriptName() + ": " +T("|unexpected error|"));
			eraseInstance();
			return;	
		}	
	}
	
// create individual instances in mode 1 and 2
	
	if (nMode>0)
	{ 
		//bDebug = true;
		
	// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE;		Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[] = {};
		Entity entsTsl[] = {};
		Point3d ptsTsl[] = {};
		int nProps[]={};
		double dProps[]={dDistance, dGap, 0};
		String sProps[]={sRule, sColorFilter,sWidthFilter,sColorFemaleFilter,sWidthFemaleFilter,sRotatedBeam,sBeamCodeFormat,sBeamCodeFormatFemale};
		//String sProps[]={sRules[0], "",""};
		Map mapTsl;	
		String sScriptname = scriptName();
		
	//region colors and filters
		//regionMALE
		int bIsExcludeFilter,bIsExcludeBeamTypeFilter;
		String sFilters[] = sColorFilter.tokenize(";");
		int nBeamTypeFilters[0];
		int nColorFilters[0];
		for (int i=0;i<sFilters.length();i++) 
		{ 
			String sFilter = sFilters[i];
			int c = sFilter.atoi();
			
			if ((String)c==sFilters[i])
			{
				nColorFilters.append(c);
				if (c<0)bIsExcludeFilter = true;
				continue;
			}
			int bExclude = sFilters[i].left(1) == "-";
			if (bExclude)
			{
				bIsExcludeBeamTypeFilter = true;
				sFilter = sFilters[i].right(sFilters[i].length() - 1).trimLeft().trimRight();
			}
			int n = _BeamTypes.find(sFilter);
			if (n>-1)
				nBeamTypeFilters.append(n);
		}
		
	// purge potential include colors
		if (bIsExcludeFilter)
			for (int i=nColorFilters.length()-1; i>=0 ; i--) 
			{ 
				int n=nColorFilters[i];
				if (n>0)
					nColorFilters.removeAt(i);
				else
					nColorFilters[i] = abs(nColorFilters[i]);
			}
		//endregion
		
	//region FEMALE
		int bIsExcludeFemaleFilter,bIsExcludeFemaleBeamTypeFilter;
		String sFemaleFilters[] = sColorFemaleFilter.tokenize(";");
		int nBeamTypeFemaleFilters[0];;
		int nColorFemaleFilters[0];	
		for (int i=0;i<sFemaleFilters.length();i++) 
		{ 
			String sFilter = sFemaleFilters[i];
			int c = sFilter.atoi();
			
			if ((String)c==sFemaleFilters[i])
			{
				nColorFemaleFilters.append(c);
				if (c<0)bIsExcludeFemaleFilter = true;
				continue;
			}
			int bExclude = sFemaleFilters[i].left(1) == "-";
			if (bExclude)
			{
				bIsExcludeFemaleBeamTypeFilter = true;
				sFilter = sFemaleFilters[i].right(sFemaleFilters[i].length() - 1).trimLeft().trimRight();
			}
			int n = _BeamTypes.find(sFilter);
			if (n>-1)
				nBeamTypeFemaleFilters.append(n);
		}
		
	// purge potential include colors
		if (bIsExcludeFemaleFilter)
			for (int i=nColorFemaleFilters.length()-1; i>=0 ; i--) 
			{ 
				int n=nColorFemaleFilters[i];
				if (n>0)
					nColorFemaleFilters.removeAt(i);
				else
					nColorFemaleFilters[i] = abs(nColorFemaleFilters[i]);
			}
		//endregion
		
	//max length and alignment
		if (dMaxLength>0)
		{ 	
			for (int b=bmMales.length()-1; b>=0 ; b--) 
			{
				Beam& bm = bmMales[b];
				Element el = bm.element();	
				if (bm.bIsValid() && el.bIsValid() && el.vecY().isParallelTo(bm.vecX()) && bm.solidLength()-dDistance>= dMaxLength)
				{
					reportMessage("\n"+ scriptName() + ": " + bm.posnum() + " " + bm.name("type") + T(", |Length| ")+bm.solidLength()+T(" |excluded from selection set|,  ") + sMaxLengthName + "=" + dMaxLength);								
					bmMales.removeAt(b); 
				}
			}
		}
		
	// MALE exclude filter
		int nNumMaleExcluded =bmMales.length();
		int nNumFemaleExcluded =bmFemales.length() ;
		if (bIsExcludeFilter)
		{
			for (int b = bmMales.length() - 1; b >= 0; b--)
				if (nColorFilters.find(bmMales[b].color()) >- 1)
					bmMales.removeAt(b);
		}
	// include filter
		else if (nColorFilters.length() > 0)
		{
			for (int b = bmMales.length() - 1; b >= 0; b--)
				if (nColorFilters.find(bmMales[b].color()) < 0)
					bmMales.removeAt(b);
		}
	// FEMALE exclude filter
		if (bIsExcludeFemaleFilter)
		{		
			for (int b=bmFemales.length()-1; b>=0 ; b--)
				if (nColorFemaleFilters.find(bmFemales[b].color())>-1)
					bmFemales.removeAt(b);
		}
	// include filter		
		else if (nColorFemaleFilters.length()>0)
		{ 
			for (int b=bmFemales.length()-1; b>=0 ; b--)
				if (nColorFemaleFilters.find(bmFemales[b].color())<0)
					bmFemales.removeAt(b);
		}	
		
	// beamtype filter
		if (nBeamTypeFilters.length() > 0)
		{
			for (int b = bmMales.length() - 1; b >= 0; b--)
			{
				int n = nBeamTypeFilters.find(bmMales[b].type());
				if (bIsExcludeBeamTypeFilter && n >- 1)
					bmMales.removeAt(b);
				else if ( ! bIsExcludeBeamTypeFilter && n < 0)
					bmMales.removeAt(b);
			}
		}
		if (nBeamTypeFemaleFilters.length() > 0)
		{ 
			for (int b=bmFemales.length()-1; b>=0 ; b--)
			{
				int n = nBeamTypeFemaleFilters.find(bmFemales[b].type());
				if (bIsExcludeFemaleBeamTypeFilter && n>-1)
					bmFemales.removeAt(b);
				else if (!bIsExcludeFemaleBeamTypeFilter && n<0)
					bmFemales.removeAt(b);
			}
		}
		
	// MALE width filter//region
		String sWidthFilters[] = sWidthFilter.tokenize(";");
		double dWidthFilters[0];
		int bIsExcludeWidthFilter;
		for (int i=0;i<sWidthFilters.length();i++) 
		{ 
			String sFilter = sWidthFilters[i];
			double d = sFilter.atof();
			
			if ((String)d==sWidthFilters[i])
			{
				dWidthFilters.append(abs(d));
				if (d<0)bIsExcludeWidthFilter = true;
				continue;
			}
		}
		
	// width filter
		if (dWidthFilters.length()>0)
		{ 
			for (int b=bmMales.length()-1; b>=0 ; b--)
			{
				Beam& bm = bmMales[b];
				Element el = bm.element();
				Vector3d vecZ = el.bIsValid()?el.vecZ():bm.vecZ();
				double dD = bm.vecZ().isParallelTo(vecZ) ? bm.solidWidth() : bm.solidHeight();
				int n = dWidthFilters.find(dD);
				if (bIsExcludeWidthFilter && n>-1)
					bmMales.removeAt(b);
				else if (!bIsExcludeWidthFilter && n<0)
					bmMales.removeAt(b);
			}
		}//endregion
		
	// FEMALE width filter//region	
		String sWidthFemaleFilters[] = sWidthFemaleFilter.tokenize(";");
		double dWidthFemaleFilters[0];
		int bIsExcludeWidthFemaleFilter;
		for (int i=0;i<sWidthFemaleFilters.length();i++) 
		{ 
			String sFilter = sWidthFemaleFilters[i];
			double d = sFilter.atof();
			
			if ((String)d==sWidthFemaleFilters[i])
			{
				dWidthFemaleFilters.append(abs(d));
				if (d<0)bIsExcludeWidthFemaleFilter = true;
				continue;
			}
		}
		
	// width filter
		if (dWidthFemaleFilters.length()>0)
		{ 
			for (int b=bmFemales.length()-1; b>=0 ; b--)
			{
				Beam& bm = bmFemales[b];
				Element el = bm.element();
				Vector3d vecZ = el.bIsValid()?el.vecZ():bm.vecZ();
				double dD = bm.vecZ().isParallelTo(vecZ) ? bm.solidWidth() : bm.solidHeight();
				int n = dWidthFemaleFilters.find(dD);
				if (bIsExcludeWidthFemaleFilter && n>-1)
					bmFemales.removeAt(b);
				else if (!bIsExcludeWidthFemaleFilter && n<0)
					bmFemales.removeAt(b);
			}
		}//endregion
		
	//HSB-13421: MALE BeamCode / Format filter @(Width, 230);A;@(Height,240)
		String sBeamCodeFormats[] = sBeamCodeFormat.tokenize(";");
		String sFormats[0];
		String sValues[0];
		String sBeamcodes[0];
		
		// collect format-value pairs and beamcodes
		int iIndex = 0;
		while (iIndex<=sBeamCodeFormats.length()-1)
		{ 
			String sFormatI = sBeamCodeFormats[iIndex]; 
			char char0 = sFormatI.getAt(0);
			if(char0=='@' )
			{ 
				// format
				// get value
				if(sBeamCodeFormats.length()-1>=iIndex+1)
				{ 
					// 
					String sFormatI1 = sBeamCodeFormats[iIndex+1];
					char char1 = sFormatI1.getAt(0);
					if(char1=='@')
					{ 
						// no value for the given format, move to next entry
						iIndex += 1;
						continue;
					}
					else
					{ 
						// format value pair
						double dVal = sFormatI1.atof();
						sFormats.append(sFormatI);
						sValues.append(sFormatI1);
						iIndex += 2;
						continue;
					}
				}
			}
			else
			{ 
				// beamcode
				sBeamcodes.append(sFormatI);
				iIndex += 1;
			}
		}//next i
		if(sFormats.length()==0)
		{
			sBeamcodes.setLength(0);
			String sBeamCodeFormat_ = sBeamCodeFormat;
			sBeamCodeFormat_.trimLeft();
			sBeamCodeFormat_.trimRight();
			if(sBeamCodeFormat_!="")
				sBeamcodes.append(sBeamCodeFormat_);
		}
		
		for (int i=bmMales.length()-1; i>=0 ; i--) 
		{ 
			Beam bmI=bmMales[i]; 
			String sVariables[]=bmI.formatObjectVariables();
			// format-value pairs
			int iExclude;
			for (int jf=0;jf<sFormats.length();jf++) 
			{ 
	//			if(sVariables.find(sFormats[jf])<0)
	//			{ 
	//				continue;
	//			}
	//			else
				{ 
					// valid format
					String sValueI = bmI.formatObject(sFormats[jf]);
					if(sValueI!=sValues[jf])
					{ 
						iExclude = true;
						break;
					}
				}
				 
			}//next jf
			if(iExclude)
			{ 
				bmMales.removeAt(i);
				continue;
			}
			for (int jc=0;jc<sBeamcodes.length();jc++) 
			{ 
				if(sBeamcodes[jc]!=bmI.beamCode())
				{ 
					iExclude = true;
					break;
				}
			}//next jc
			if(iExclude)
			{ 
				bmMales.removeAt(i);
				continue;
			}
		}//next i
		
		//HSB-13421: FEMALE BeamCode / Format filter @(Width, 230);A;@(Height,240)
		sBeamCodeFormats.setLength(0);
		sFormats.setLength(0);
		sValues.setLength(0);
		sBeamcodes.setLength(0);
		sBeamCodeFormats = sBeamCodeFormatFemale.tokenize(";");

		
		// collect format-value pairs and beamcodes
		iIndex = 0;
		while (iIndex<=sBeamCodeFormats.length()-1)
		{ 
			String sFormatI = sBeamCodeFormats[iIndex]; 
			char char0 = sFormatI.getAt(0);
			if(char0=='@' )
			{ 
				// format
				// get value
				if(sBeamCodeFormats.length()-1>=iIndex+1)
				{ 
					// 
					String sFormatI1 = sBeamCodeFormats[iIndex+1];
					char char1 = sFormatI1.getAt(0);
					if(char1=='@')
					{ 
						// no value for the given format, move to next entry
						iIndex += 1;
						continue;
					}
					else
					{ 
						// format value pair
						double dVal = sFormatI1.atof();
						sFormats.append(sFormatI);
						sValues.append(sFormatI1);
						iIndex += 2;
						continue;
					}
				}
			}
			else
			{ 
				// beamcode
				sBeamcodes.append(sFormatI);
				iIndex += 1;
			}
		}//next i
		if(sFormats.length()==0)
		{
			sBeamcodes.setLength(0);
			String sBeamCodeFormatFemale_ = sBeamCodeFormatFemale;
			sBeamCodeFormatFemale_.trimLeft();
			sBeamCodeFormatFemale_.trimRight();
			if(sBeamCodeFormatFemale_!="")
				sBeamcodes.append(sBeamCodeFormatFemale_);
		}
		
		for (int i=bmFemales.length()-1; i>=0 ; i--) 
		{ 
			Beam bmI=bmFemales[i]; 
			String sVariables[]=bmI.formatObjectVariables();
			// format-value pairs
			int iExclude;
			for (int jf=0;jf<sFormats.length();jf++) 
			{ 
	//			if(sVariables.find(sFormats[jf])<0)
	//			{ 
	//				continue;
	//			}
	//			else
				{ 
					// valid format
					String sValueI = bmI.formatObject(sFormats[jf]);
					if(sValueI!=sValues[jf])
					{ 
						iExclude = true;
						break;
					}
				}
				 
			}//next jf
			if(iExclude)
			{ 
				bmFemales.removeAt(i);
				continue;
			}
			for (int jc=0;jc<sBeamcodes.length();jc++) 
			{ 
				if(sBeamcodes[jc]!=bmI.beamCode())
				{ 
					iExclude = true;
					break;
				}
			}//next jc
			if(iExclude)
			{ 
				bmFemales.removeAt(i);
				continue;
			}
		}//next i
		
		
		nNumMaleExcluded = nNumMaleExcluded - bmMales.length();
		nNumFemaleExcluded = nNumFemaleExcluded -bmFemales.length();
		if (nNumMaleExcluded>0 || nNumFemaleExcluded>0)
			reportMessage("\n" + scriptName() + ": " +nNumMaleExcluded +"/" + nNumFemaleExcluded + T(" |male/female beams excluded due to filtering| ") + 
				"\n"+T("|Male Color Filter|") + nColorFilters+"\n"+T("|Female Color Filter|") + nColorFemaleFilters);
		//endregion

	// HSB-16469: dont allow 2 t-connection maleb1-femaleb2 and maleb2-femaleb1
	// when T-Connection is inserted it stretches male beam and can tur it to a valid connection of female-male
		Beam bmMalesCreated[0], bmFemalesCreated[0];
	// create instances on beam by beam(s) base
	// this is loooking for potential t-connected beams and supports multiple female beams connected with a male beam
		for (int m = 0; m < bmMales.length(); m++)
		{
			Beam bmMale = bmMales[m];
			if ( ! bmMale.bIsValid())continue;
			Point3d ptCenM = bmMale.ptCenSolid();
			Vector3d vecXM = bmMale.vecX();
			Element el = bmMale.element();
			
		// rule 2: only studs against top plate
			if (nRule == 2 && el.bIsValid())
			{
				if (!vecXM.isParallelTo(el.vecY())) { continue; }
				// make sure vecX of male points upwards
				else if (vecXM.dotProduct(el.vecY()) < 0)
					vecXM *= -1;
			}
			
		// filter capsules
			Beam beamsCaps[] = bmMale.filterBeamsCapsuleIntersect(bmFemales);
			
		// remove
			for (int f = beamsCaps.length() - 1; f >= 0; f--)
			{ 
				Beam& bm = beamsCaps[f];
				int nType = bm.type();
//				reportNotice("\n" + nType + " =" + _BeamTypes[nType]);
//				bm.envelopeBody().vis(f);
			//non t-connections
				if (!bmMale.hasTConnection(beamsCaps[f], dDistance, true))
				{
					beamsCaps.removeAt(f);
				}
			//rule 1 and angled
				else if (nRule==1 && (nType==54 || nType==55))//Angled Top Plate Left/Right
				{
					if(bDebug)bm.envelopeBody().vis(1);
					beamsCaps.removeAt(f);
				}
			}
			
		// remove any connecting female plate or top header
			if (el.bIsValid() && nRule > 0)//&& _Beam[1].vecX().isParallelTo(el.vecX()))
			{
				Plane pn(el.ptOrg(), el.vecZ());
				double dZ = el.dBeamWidth();
				
				// collect all beams
				Beam beams[] = el.beam();
				
				// filter horizontal beams
				Beam bmHorizontals[] = el.vecY().filterBeamsPerpendicularSort(beams);
				Beam bmVerticals[] = el.vecX().filterBeamsPerpendicularSort(beams);
				
				
				
				// get any highest and lowest
				if (nRule == 1 && bmHorizontals.length() > 1)
				{
					PlaneProfile pp(el.coordSys());
					Vector3d vecY = el.vecY();
					Point3d ptRefBot, ptRefTop;
					ptRefBot = bmHorizontals[0].ptCenSolid() - vecY * .5 * bmHorizontals[0].dD(vecY);
					ptRefTop = bmHorizontals[bmHorizontals.length() - 1].ptCenSolid() + vecY * .5 * bmHorizontals[bmHorizontals.length() - 1].dD(vecY);
					
					for (int f=0;f<bmHorizontals.length();f++) 
					{ 
						Beam& bmH = bmHorizontals[f];
						double dD = bmH.dD(vecY);
						Point3d ptCen = bmH.ptCenSolid();
						Point3d ptBot = ptCen- vecY * .5 * dD;
						Point3d ptTop = ptCen + vecY * .5 * dD; 
						
						double d1 = abs(vecY.dotProduct(ptBot - ptRefBot));
						double d2 = abs(vecY.dotProduct(ptTop - ptRefTop));
					
					// skip any horizontal which has a vertical above or below
						int bHasBelow, bHasAbove;
						Beam bmVs[] = bmH.filterBeamsCapsuleIntersect(bmVerticals);
						//bmH.envelopeBody().vis(40);
						for (int v=0;v<bmVs.length();v++) 
						{
							double d = vecY.dotProduct(bmVs[v].ptCenSolid() - ptCen);
							if (d < 0)bHasBelow = true;
							else if (d > 0)bHasAbove = true;
							
						}

						if ((d1<dEps && !bHasBelow) || (d2<dEps&& !bHasAbove))
							pp.unionWith(bmH.envelopeBody(false, true).extractContactFaceInPlane(pn, dZ));	
					}
					//pp.vis(5);
					
				// exclude/ erase connections which are intersecting
					PlaneProfile ppFemale(el.coordSys());
					for (int f = beamsCaps.length() - 1; f >= 0; f--)
					{
						PlaneProfile ppFemale = beamsCaps[f].envelopeBody(false, true).extractContactFaceInPlane(pn, dZ);
						//ppFemale.vis(3);
						ppFemale.intersectWith(pp);
						if (ppFemale.area() > pow(U(1), 2))
						{
							reportMessage("\n" + scriptName() + ": " + beamsCaps[f].posnum() + " " + beamsCaps[f].name("type") + T(" |excluded from selection set|."));
							beamsCaps.removeAt(f);
						}
						else if((bBaufritz && nRule == 1) && (beamsCaps[f].name("type")=="rechter Stab" || beamsCaps[f].name("type")=="Linker Stab" || beamsCaps[f].name("type")=="Schwelle"))
						{ 
							// HSB-23612: rule for Baufritz
							reportMessage("\n" + scriptName() + ": " + beamsCaps[f].posnum() + " " + beamsCaps[f].name("type") + T(" |excluded from selection set|."));
							beamsCaps.removeAt(f);
						}
					}
				}
				else if (nRule == 1 && bmHorizontals.length() ==1)
				{ 
					int n = beamsCaps.find(bmHorizontals[0]);
					if (n>-1)
						beamsCaps.removeAt(n);
				}
			}
			
		/// loop positive and negative male direction
			for (int x=0;x<2;x++) 
			{ 
				ptsTsl.setLength(0);
				gbsTsl.setLength(0);
		    	gbsTsl.append(bmMale);	
				
				Vector3d vecDir = x == 0 ? vecXM :- vecXM;
				
			// collect all remaining capsules connecting on this side
				for (int f=beamsCaps.length()-1; f>=0 ; f--) 
				{
					Beam bm = beamsCaps[f];
					Point3d pt;
					int bOk = Line(ptCenM, vecDir).hasIntersection(Plane(bm.ptCenSolid(), bm.vecD(vecDir)), pt);
					if (bOk && vecDir.dotProduct(pt-ptCenM)>0)
					{ 
						if(bDebug)reportMessage("\n"+ scriptName() + " appending beam " + bm.handle() + " in direction of " + vecDir);
						
						gbsTsl.append(bm);	
						if (bDebug)
						{
							bmMale.envelopeBody().vis(3);
							bm.envelopeBody().vis(4);
						}
						if (ptsTsl.length()<1)	ptsTsl.append(pt);
					}
				}
				
			// create a new instance if there is at least one female beam available
				if (!bDebug && gbsTsl.length()>1)
				{ 
				// HSB-16469
					{ 
						Beam bmMale0=(Beam)gbsTsl[0];
						Beam bmFemale1=(Beam)gbsTsl[1];
						int nMaleCreated=bmMalesCreated.find(bmFemale1);
						int nFemaleCreated=bmFemalesCreated.find(bmMale0);
						if(nMaleCreated>-1 && nFemaleCreated>-1)
						{ 
							continue;
						}
						bmMalesCreated.append(bmMale0);
						bmFemalesCreated.append(bmFemale1);
					}
					
					tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
						nProps, dProps, sProps,_kModelSpace, mapTsl);
					if (tslNew.bIsValid())
						tslNew.recalcNow();
				}
				
				if (nRule == 2)break;// only agaist top plate
				
			}// next x
		}// next m	
		if (!bDebug)eraseInstance();
		return;
	}	
	
//	return;
// mode 0 
	sRule.setReadOnly(true);
	dMaxLength.setReadOnly(true);
	// male beam filters
	sColorFilter.setReadOnly(true);
	sWidthFilter.setReadOnly(true);
	sBeamCodeFormat.setReadOnly(true);
	// female beam filters
	sColorFemaleFilter.setReadOnly(true);
	sWidthFemaleFilter.setReadOnly(true);
	sBeamCodeFormatFemale.setReadOnly(true);
// Prerequisites
	if (_Beam.length()<2 || _Beam[0].vecX().isParallelTo(_Beam[1].vecX()))
	{ 
		//reportMessage("\n" + scriptName() + ": " +T("|invalid selection set.|"));	
		eraseInstance();
		return;
	}
	Beam bm0 = _Beam[0];
	Beam bm1 = _Beam[1];
	
	bmFemales.append(bm1);
	for (int i=0;i<_Beam.length();i++) 
	{ 
		if (bmFemales.find(_Beam[i])<0 && _Beam[i].vecX().isParallelTo(bm1.vecX()))
			bmFemales.append(_Beam[i]);
	}
	// set dependency
	if(_Entity.find(bm0)<0)
	{ 
		_Entity.append(bm0);
	}
	setDependencyOnEntity(bm0);
	if(_Entity.find(bm1)<0)
	{ 
		_Entity.append(bm1);
	}
	setDependencyOnEntity(bm1);
	Point3d ptCen0 = bm0.ptCenSolid();
	Point3d ptCen1 = bm1.ptCenSolid();
	
	Vector3d vecZ = bm1.vecD(bm0.vecX());// vector of female in direction of male beam
	if (vecZ.dotProduct(ptCen1 - ptCen0) < 0)vecZ *= -1;
	Vector3d vecX = bm1.vecD(bm1.vecX().crossProduct(vecZ));
	Vector3d vecY = vecX.crossProduct(-vecZ);
	// HSB-12395: property for rotated beams
	int iRotatedBeam = sNoYes.find(sRotatedBeam);
	if (iRotatedBeam)
	{ 
		// yes is selected
		vecX = bm0.vecD(vecX);
		vecY = vecX.crossProduct(-vecZ);
//		vecX.vis(ptRef, 1);
	}
	
	Line(ptCen0, vecZ).hasIntersection(Plane(ptCen1-vecZ*.5*bm1.dD(vecZ), vecZ), _Pt0);
	vecX.vis(_Pt0,1);
	vecY.vis(_Pt0,3);
	vecZ.vis(_Pt0,150);
	
	Vector3d vecX0 = bm0.vecX();
	if (vecX0.dotProduct(vecZ) < 0)vecX0 *= -1;

// vector normal with the plane of T-connection
	Vector3d vecNormal = bm0.vecX().crossProduct(bm1.vecX());
// displace the display to the mid of female
	Vector3d vecDisplacement = (ptCen1 - ptCen0).dotProduct(vecNormal) * vecNormal;
	
// potential element link
	Element el = _Beam[1].element();
	
// assignment
	if (el.bIsValid())
		assignToElementGroup(el, true, 0, 'T');
	else
		assignToGroups(bm1,'T');
	
// stretch male
	_Pt0.vis(5);
// 
	Vector3d vecXcut = bm0.vecX();
	if (vecZ.dotProduct(bm0.vecX()) < 0)vecXcut *= -1;
	Line lnMale(bm0.ptCen(), bm0.vecX());
	Plane pnStretch(_Pt0 + vecZ * dDistance, vecZ);
	// HSB-16850
	Point3d ptIntersect;
	int nIntersect=lnMale.hasIntersection(pnStretch, ptIntersect);
	if(!nIntersect)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|Unexpected|"));
		eraseInstance();
		return;
	}
	ptIntersect.vis(3);
	Point3d ptIntersectMax = ptIntersect;
	for (int iCorner=0;iCorner<2;iCorner++) 
	{ 
		int iIndexI = -1 + iCorner * 2;
		for (int jCorner=0;jCorner<2;jCorner++) 
		{ 
			int iIndexJ = -1 + jCorner * 2;
			int jCorner = -1 + jCorner * 2;
			Line ln(bm0.ptCen()+.5*iIndexI*bm0.vecY()*bm0.dD(bm0.vecY())
								 + .5 * iIndexJ * bm0.vecZ() * bm0.dD(bm0.vecZ()), bm0.vecX());
//			ptIntersect = ln.intersect(pnStretch, dEps);
			// HSB-16850
			nIntersect=ln.hasIntersection(pnStretch, ptIntersect);
			if(!nIntersect)
			{ 
				reportMessage("\n"+scriptName()+" "+T("|Unexpected|"));
				eraseInstance();
				return;
			}
			if (vecXcut.dotProduct(ptIntersect - ptIntersectMax) > 0)ptIntersectMax = ptIntersect;
		}//next jCorner
	}//next iCorner
	
	Cut cutStretch(ptIntersectMax, vecZ); // HSB-18893 vecXCut leads to invalid envelopBody(true, true)
	bm0.addTool(cutStretch,bDebug?0:1);
//	Cut cut(_Pt0+vecZ*dDistance, vecZ);
//	bm0.addTool(cut,1);
	
// Trigger Reset
	String sTriggerReset = T("|Reset + Erase|");
	addRecalcTrigger(_kContext, sTriggerReset );
	if (_bOnRecalc && (_kExecuteKey==sTriggerReset || _kExecuteKey==sDoubleClick))
	{
		Cut cut(_Pt0, vecZ);
		bm0.addToolStatic(cut, 1);
		eraseInstance();
		return;
	}
	
// Display
	Display dp(150);
	
// female tooling
	if (dDistance > dEps)
	{
		Body bdMale = bm0.envelopeBody(false, true);
		Body bdFemale;
		for (int i=0 ; i < bmFemales.length() ; i++)
		{ 
		    Beam bmFemale = bmFemales[i];
		    bdFemale.addPart(bmFemale.envelopeBody(false,true));
		}
		bdFemale.vis(4);
		Body bdTool = bdMale;
		bdTool.intersectWith(bdFemale);//bdTool.vis(6);
		PlaneProfile ppTool = bdTool.shadowProfile(Plane(_Pt0,vecZ));
		ppTool.shrink(-dGap);
	// tool size
		LineSeg seg = ppTool.extentInDir(vecX);
		seg.vis(1);
		seg.transformBy(vecDisplacement);
		double dX = bdFemale.lengthInDirection(vecX);//)abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
		if (iRotatedBeam)dX = bdTool.lengthInDirection(vecX);
		double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
		double dZ = dDistance;
		Point3d ptRef = seg.ptMid();
		ptRef.vis(6);
		
	// BeamCut
		if (dX>dEps && dY>dEps && dZ>dEps)
		{
			vecX.vis(ptRef, 1);
			vecY.vis(ptRef, 5);
			vecZ.vis(ptRef, 3);
			PlaneProfile ppFemale = bdFemale.shadowProfile(Plane(ptRef, vecX));
			ppFemale.vis(4);
			Body bdBc(ptRef, vecX, vecY, vecZ, dX * 2, dY, dZ * 2, 0, 0, 0);
			PlaneProfile ppBc = bdBc.shadowProfile(Plane(ptRef, vecX));
			ppBc.vis(6);
			BeamCut bc;
			bc = BeamCut (ptRef, vecX, vecY, vecZ, dX * 2, dY, dZ * 2, 0, 0, 0);
			// check if point outside and stretch the beamcut
			// get extents of profile
			LineSeg seg = ppBc.extentInDir(vecY);
			double dXseg = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
			double dYseg = abs(vecZ.dotProduct(seg.ptStart()-seg.ptEnd()));
			Point3d ptLeftTop = seg.ptMid() - vecY * .5 * dXseg + vecZ * .5 * dYseg;
			Point3d ptRightTop = seg.ptMid() + vecY * .5 * dXseg + vecZ * .5 * dYseg;
			ptLeftTop.vis(8);
			ptRightTop.vis(8);
			// HSB-12394 stretch beamcut if it falls outside the boundaries of the female beam
			if (ppFemale.pointInProfile(ptLeftTop) == _kPointOutsideProfile)
			{ 
				// stretch on the left side
				bc = BeamCut(ptRef - vecY * U(20), vecX, vecY, vecZ, 
						dX * 2, dY + U(40), dZ * 2, 0, 0, 0);
			}
			if (ppFemale.pointInProfile(ptRightTop) == _kPointOutsideProfile)
			{ 
				// stretch on the right side
				bc = BeamCut(ptRef + vecY * U(20), vecX, vecY, vecZ, 
						dX * 2, dY + U(40), dZ * 2, 0, 0, 0);
			}
			bc.cuttingBody().vis(3);
			bc.addMeToGenBeamsIntersect(bmFemales);

// HSB-15478 male beamcut deprecated, purpose unclear
			// HSB-11195
			BeamCut bcMale(ptRef+vecZ*dZ, vecX, -vecY, -vecZ, dX*5, dY*3, dZ*10, 0,0,-1);
			bcMale.cuttingBody().vis(2);
			// HSB-16190, HSB-15478
			// add the beamcut only if it does something extra to the beam
			{ 
				PlaneProfile ppBcMale=bcMale.cuttingBody().shadowProfile(Plane(ptRef, vecX));
				PlaneProfile ppBm0=bm0.envelopeBody(true,true).shadowProfile(Plane(ptRef, vecX));
				ppBcMale.shrink(U(1));
				if(ppBcMale.intersectWith(ppBm0))
					bm0.addTool(bcMale);
			}
		}
		//
		dp.draw(PLine(ptRef, ptRef+vecZ*dDistance));
		dp.color(3);
		dp.draw(PLine(ptRef-.5*vecY*dY, ptRef+.5*vecY*dY));
		dp.color(1);
		dp.draw(PLine(ptRef-.5*vecX*dX, ptRef+.5*vecX*dX));
	}
	
// bHasContact
	else
	{
		double d = bm0.dH()>bm0.dW()?bm0.dW():bm0.dH();
		d*=.8;
		PLine pl;
		Point3d pt=_Pt0;
		Line(ptCen0, vecX0).hasIntersection(Plane(_Pt0, vecZ), pt);
		pl.createCircle(pt, vecZ, d/2);
		dp.draw(pl);
		
	// contact with gap	
		if (abs(dDistance)>dEps)
		{
			dp.draw(PLine(pt, pt+vecZ*dDistance));
			pl.transformBy(vecZ*dDistance);
			dp.draw(pl);
		}
	}
	// HSB-11195
	if(_kExecutionLoopCount==0)
	{ 
		setExecutionLoops(2);
	}
	else if(_kExecutionLoopCount==1)
	{ 
		setExecutionLoops(3);
	}
	












#End
#BeginThumbnail
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
K_.NEHH`Y6XL==U,A;E$5%.5!90!^7-='9PM;64$#$%HXU4D=.!4]%`'_V6_K
`
































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
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23612: Modifications for Baufritz" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="22" />
      <str nm="DATE" vl="3/4/2025 8:45:45 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22182: This TSL is outdated, &quot;T-Connection.mcr&quot; is the replacement" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="21" />
      <str nm="DATE" vl="1/7/2025 1:09:14 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18801: Enter wait state if no element beam found (beams without panhand state)" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="20" />
      <str nm="DATE" vl="5/12/2023 10:15:28 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18893 stretch plane of male adjusted parallel to contact plane to receive proper envelopeBody" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="19" />
      <str nm="DATE" vl="5/5/2023 9:16:04 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16850: remove tolerance at line-plane intersection" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="18" />
      <str nm="DATE" vl="10/27/2022 8:51:34 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16469: Fix calculation for elements when investigating male-females; avoid duplicated instances" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="17" />
      <str nm="DATE" vl="9/26/2022 1:14:31 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15478: apply beamcut only when it does something to the beam" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="16" />
      <str nm="DATE" vl="9/1/2022 2:14:42 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11195 redundant tool on male beam end suppressed" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="15" />
      <str nm="DATE" vl="7/26/2022 4:11:24 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13421: better description for sBeamCodeFormat property" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="14" />
      <str nm="DATE" vl="10/28/2021 1:59:43 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13421: add description for sBeamCodeFormat" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="13" />
      <str nm="DATE" vl="10/22/2021 12:16:21 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13421: add filter byFormat/byBEamcode" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="12" />
      <str nm="DATE" vl="10/18/2021 11:21:44 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12395: property &quot;rotated beam&quot; added" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="11" />
      <str nm="DATE" vl="7/12/2021 11:33:36 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12394 stretch beamcut if it falls outside the boundaries of the female beam" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="10" />
      <str nm="DATE" vl="7/12/2021 10:03:21 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11195: supports connection of 1 male and 2 skew females" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="3/15/2021 8:38:05 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End