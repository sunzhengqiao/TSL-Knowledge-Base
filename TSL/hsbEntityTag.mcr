#Version 8
#BeginDescription
This tsl displays the specified properties of an entity as tag or as text

#Versions
Version 7.7 02/09/2025 HSB-24506: erase tag if no entities found in filter , Author Marsel Nakuci
Version 7.6 02/09/2025 HSB-24506: Show painter filter when TSL inserted on MultiPage in model space , Author Marsel Nakuci
Version 7.5 18.06.2025 HSB-24186 blockspace detection improved
Version 7.4 17.06.2025 HSB-24189 multi leaders can be selected in blockspace
Version 7.3 10.06.2025 HSB-24142 Performance of metal parts in sections and across multiple pages has been improved
Version 7.2 06.06.2025 HSB-24142 qty count fixed on multipages
Version 7.1 06.06.2025 HSB-24141 xRef/Block selection property visible on insert if xRefs or Blocks found, new option to modify text height during insert
Version 7.0 03.06.2025 HSB-23923 accepting multipages without a defineSet if showSet is valid
Version 6.9 28.05.2025 HSB-23923 accepting roofplanes and tsl instances with showset creation
Version 6.8 28.05.2025 HSB-23923 new value 'Visible Set of Entities' in context of shopdrawings. defining entity will be used by default if no other filter has been set
Version 6.7 09.05.2025 HSB-23923 minor property naming improvement
Version 6.6 09.05.2025 HSB-23923 Supports bulk creation within the showset of a multipage. Identical items can be grouped using the 'equality format' property. Grouping only considers items that are within a certain range of each other, based on a multiple of the specified text height
Version 6.5 23.04.2025 HSB-23918 default placement sections ignores section range
Version 6.4 22.04.2025 HSB-23918 new property 'placement' sets location strategy during insert
Version 6.3 02.04.2025 HSB-23804 tag placement on sections avoids overlapping with section graphics, qty on genbeams fixed, duplicate leaders suppressed
Version 6.2 19.03.2025 HSB-23734 bugfix when inserting with invalid dimstyle by catalog
Version 6.1 13.03.2025 HSB-23657: Merging Version 5.10: Fix when constructing body of elements casted from roofplane
Version 6.0 10.03.2025 HSB-23666 quantity count fixed (introduced HSB-23456) 
Version 5.9 28.02.2025 HSB-23422 the tag now draws at the highest z-location of the entity and its references to display also in visual styles
Version 5.8 20.02.2025 HSB-23546 multileader support added genbeams, metalparts
Version 5.7 19.02.2025 HSB-23546 sections: quantity fixed
Version 5.6 19.02.2025 HSB-23546 new leader styles 'multi' show multiple leaders if corresponding siblings have been found
Version 5.5 18.02.2025 HSB-23546 bugfix section creation
Version 5.4 18.02.2025 HSB-23546 supporting fastener assemblies as model reference, with sections is also supports fasteners as sub component of a metalparts. new property to display guideline as leader with arrow, dot or straight
Version 5.3 03.12.2024 HSB-23097 MetalParts: style data and counting via equality format of xRef entities supported
Version 5.2 02.12.2024 HSB-23097 supports content of xrefs when when referenced by a section
Version 5.1 19.11.2024 HSB-22560 new shape 'Triangle', consumes sequential colors if provided by parent entity, supports tsl modelDescription
Version 5.0 18.10.2024 HSB-22779 tags attached to a section will be purged on recalc if the section has been deleted
Version 4.9 17.10.2024 HSB-22779 performance and insert location on sections improved
Version 4.8 10.10.2024 HSB-22779 supports roof/floor elements
Version 4.7 08.10.2024 HSB-22779 supports sections and filtering by painter definitions during insert
Version 4.6 01.10.2024 HSB-22741 supports child panels and references the panel
Version 4.5 11.09.2024 HSB-22633 supports hsbMake and hsbShare display, plain text supported
Version 4.4 18/06/2024 HSB-22250: Remove the change in 4.3; not needed
Version 4.3 14/06/2024 HSB-22250: modify for the format @(DATALINK.f_Package.InternalMapx.TOPPANEL)
Version 4.2 21.12.2023 HSB-21005 surfaceQualityStyles will swap to closest corresponding face when applied to shopdrawings in non front views
Version 4.1 02.11.2023 HSB-20902 version conflict resolved ( HSB-19490 / HSB-20543) supports XRefName if the defining entity is nested in a XRef. XRef-Path purged as prefix from result, i.e. ElementNumber
Version 4.0 27.11.2023 HSB-20739 leader points towards corresponding face when using SurfaceQualityBottomStyle or SurfaceQualityTopStyle . Color = -1 uses color of quality and can be mapped to specific color using Alias 'SQ'
Version 3.9 20.07.2023 HSB-19490 supports the virtual format 'Quantity' if the tsl has been numbered, the variable will resolve as '0' if it is not numbered
Version 3.8 01.06.2023 HSB-19085 supports the virtual format 'Quantity' if the genbeam has been numbered, the variable will resolve as '0' if it is not numbered. Dimstyles which are associated to non linear dimensions are not shown anymore
Version 3.7 23.05.2023 HSB-19014 assignment to shopdrawviewport in blockspace corrected
Version 3.6 15.05.2023 HSB-18972 nested selection accesible for block and external references, empty resolving does not show value if variable exists
Version 3.5 05.05.2023 HSB-18903 hidden xref property will not select nested items of block references. auto format added for blockrefs and massgroups,  if the tag is linked to a blockreference the tag will become a static text if the blockreference is exploded
Version 3.4 04.05.2023 HSB-18776 assignment to layer 0 (no group assignment) only active during creation or on property change
Version 3.3 04.05.2023 TRU-285 TrussEntity: TrussMark added as default format
Version 3.2 03.05.2023 HSB-18776 bugfix aligned orientations respect entity alignment
Version 3.1 03.05.2023 HSB-18776 cloning supports xref entities
Version 3.0 02.05.2023 HSB-18776 new properties to select xref content and and to control layer assignment, new placement when multiple entities are selected
Version 2.9 20.04.2023 HSB-18736 visible entity can be assigned during insert, multiple insert improved
Version 2.8 19.04.2023 HSB-18695 catching zero solids when dragging
Version 2.7 18.04.2023 HSB-18695 new context commands to clone tag and to assign visible reference / layer override
Version 2.6 17.04.2023 HSB-18681 outline drawn at correct page location on creation
Version 2.5 05.04.2023 HSB-18357 revision cloud display improved on short texts
Version 2.4 17.03.2023 HSB-18357 leader and revision cloud display improved
Version 2.3 15.02.2023 HSB-19972 boundings improved, new property transparency can create filled opaque background
Version 2.2 15.12.2022 HSB-17353 new revision cloud style
Version 2.1 15.12.2022 HSB-17353 MetalPartCollectionEntity: Performance imroved, new property for equality distinction, new formats to calculate and display equality based 'Quantity' and 'TotalWeight'
Version 2.0 12.12.2022 HSB-17297 Alignments and Scale Properties added
Version 1.9 24.06.2022 HSB-15792 new property leader linetype, supports auto reation in modelspace if defined in blockspace with a shopdraw viewport
Version 1.8 16.11.2021 HSB-13819  guidelline will be suppressed if location is inside of shape
Version 1.7 22.09.2021 HSB-13249 guidelline will be suppressed if linked entity is opening and location is inside of opening
Version 1.6 01.07.2021 HSB-12441 - new context command with additional properties to control redrawing of outline of the entity 
Version 1.5 30.06.2021 HSB-12441 enhanced display, full format variable support 































































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 7
#MinorVersion 7
#KeyWords 
#BeginContents
//region Part #1

//region <History>
//#Versions
// 7.7 02/09/2025 HSB-24506: erase tag if no entities found in filter , Author Marsel Nakuci
// 7.6 02/09/2025 HSB-24506: Show painter filter when TSL inserted on MultiPage in model space , Author Marsel Nakuci
// 7.5 18.06.2025 HSB-24186 blockspace detection improved , Author Thorsten Huck
// 7.4 17.06.2025 HSB-24189 multi leaders can be selected in blockspace , Author Thorsten Huck
// 7.3 10.06.2025 HSB-24142 Performance of metal parts in sections and across multiple pages has been improved. , Author Thorsten Huck
// 7.2 06.06.2025 HSB-24142 qty count fixed on multipages , Author Thorsten Huck
// 7.1 06.06.2025 HSB-24141 xRef/Block selection property visible on insert if xRefs or Blocks found, new option to modify text height during insert , Author Thorsten Huck
// 7.0 03.06.2025 HSB-23923 accepting multipages without a defineSet if showSet is valid , Author Thorsten Huck
// 6.9 28.05.2025 HSB-23923 accepting roofplanes and tsl instances with showset creation , Author Thorsten Huck
// 6.8 28.05.2025 HSB-23923 new value 'Visible Set of Entities' in context of shopdrawings. defining entity will be used by default if no other filter has been set , Author Thorsten Huck
// 6.7 09.05.2025 HSB-23923 minor property naming improvement , Author Thorsten Huck
// 6.6 09.05.2025 HSB-23923 Supports bulk creation within the showset of a multipage. Identical items can be grouped using the 'equality format' property. Grouping only considers items that are within a certain range of each other, based on a multiple of the specified text height , Author Thorsten Huck
// 6.5 23.04.2025 HSB-23918 default placement sections ignores section range , Author Thorsten Huck
// 6.4 22.04.2025 HSB-23918 new property 'placement' sets location strategy during insert , Author Thorsten Huck
// 6.3 02.04.2025 HSB-23804 tag placement on sections avoids overlapping with section graphics, qty on genbeams fixed, duplicate leaders suppressed , Author Thorsten Huck
// 6.2 19.03.2025 HSB-23734 bugfix when inserting with invalid dimstyle by catalog , Author Thorsten Huck
// 6.1 13.03.2025 HSB-23657: Merging Version 5.10: Fix when constructing body of elements casted from roofplane , Author Thorsten Huck
// 6.0 10.03.2025 HSB-23666 quantity count fixed (introduced HSB-23456) , Author Thorsten Huck
// 5.9 28.02.2025 HSB-23422 the tag now draws at the highest z-location of the entity and its references to display also in visual styles , Author Thorsten Huck
// 5.8 20.02.2025 HSB-23546 multileader support added genbeams, metalparts , Author Thorsten Huck
// 5.7 19.02.2025 HSB-23546 sections: quantity fixed , Author Thorsten Huck
// 5.6 19.02.2025 HSB-23546 new leader styles 'multi' show multiple leaders if corresponding siblings have been found , Author Thorsten Huck
// 5.5 18.02.2025 HSB-23546 bugfix section creation , Author Thorsten Huck
// 5.4 18.02.2025 HSB-23546 supporting fastener assemblies as model reference, with sections is also supports fasteners as sub component of a metalparts. new property to display guideline as leader with arrow, dot or straight
// 5.3 03.12.2024 HSB-23097 MetalParts: style data and counting via equality format of xRef entities supported , Author Thorsten Huck
// 5.2 02.12.2024 HSB-23097 supports content of xrefs when when referenced by a section , Author Thorsten Huck
// 5.1 19.11.2024 HSB-22560 new shape 'Triangle', consumes sequential colors if provided by parent entity, supports tsl modelDescription , Author Thorsten Huck
// 5.0 18.10.2024 HSB-22779 tags attached to a section will be purged on recalc if the section has been deleted , Author Thorsten Huck
// 4.9 17.10.2024 HSB-22779 performance and insert location on sections improved , Author Thorsten Huck
// 4.8 10.10.2024 HSB-22779 supports roof/floor elements , Author Thorsten Huck
// 4.7 08.10.2024 HSB-22779 supports sections and filtering by painter definitions during insert , Author Thorsten Huck
// 4.6 01.10.2024 HSB-22741 supports child panels and references the panel , Author Thorsten Huck
// 4.5 11.09.2024 HSB-22633 supports hsbMake and hsbShare display, plain text supported, Author Thorsten Huck
// 4.4 18/06/2024 HSB-22250 Remove the change in 4.3; not needed Marsel Nakuci
// 4.3 14/06/2024 HSB-22250 modify for the format @(DATALINK.f_Package.InternalMapx.TOPPANEL) Marsel Nakuci
// 4.2 21.12.2023 HSB-21005 surfaceQualityStyles will swap to closest corresponding face when applied to shopdrawings in non front views , Author Thorsten Huck
// 4.1 02.11.2023 HSB-20902 version conflict resolved ( HSBdimst-19490 / HSB-20543) supports XRefName if the defining entity is nested in a XRef. XRef-Path purged as prefix from result, i.e. ElementNumber
// 4.0 27.11.2023 HSB-20739 leader points towards corresponding face when using SurfaceQualityBottomStyle or SurfaceQualityTopStyle . Color = -1 uses color of quality and can be mapped to specific color using Alias 'SQ' , Author Thorsten Huck
// 3.9 20.07.2023 HSB-19490 supports the virtual format 'Quantity' if the tsl has been numbered, the variable will resolve as '0' if it is not numbered. , Author Thorsten Huck
// 3.8 01.06.2023 HSB-19085 supports the virtual format 'Quantity' if the genbeam has been numbered, the variable will resolve as '0' if it is not numbered. Dimstyles which are associated to non linear dimensions are not shown anymore , Author Thorsten Huck
// 3.7 23.05.2023 HSB-19014 assignment to shopdrawviewport in blockspace corrected , Author Thorsten Huck
// 3.6 15.05.2023 HSB-18972 nested selection accesible for block and external references, empty resolving does not show value if variable exists , Author Thorsten Huck
// 3.5 05.05.2023 HSB-18903 hidden xref property will not select nested items of block references. auto format added for blockrefs and massgroups,  if the tag is linked to a blockreference the tag will become a static text if the blockreference is exploded
// 3.4 04.05.2023 HSB-18776 assignment to layer 0 (no group assignment) only active during creation or on property change , Author Thorsten Huck
// 3.3 04.05.2023 TRU-285 TrussEntity: TrussMark added as default format , Author Thorsten Huck
// 3.2 03.05.2023 HSB-18776 bugfix aligned orientations respect entity alignment , Author Thorsten Huck
// 3.1 03.05.2023 HSB-18776 cloning supports xref entities , Author Thorsten Huck
// 3.0 02.05.2023 HSB-18776 new properties to select xref content and and to control layer assignment, new placement when multiple entities are selected , Author Thorsten Huck
// 2.9 20.04.2023 HSB-18736 visible entity can be assigned during insert, multiple insert improved , Author Thorsten Huck
// 2.8 19.04.2023 HSB-18695 catching zero solids when dragging , Author Thorsten Huck
// 2.7 18.04.2023 HSB-18695 new context commands to clone tag and to assign visible reference / layer override , Author Thorsten Huck
// 2.6 17.04.2023 HSB-18681 outline drawn at correct page location on creation , Author Thorsten Huck
// 2.5 05.04.2023 HSB-18357 revision cloud display improved on short texts , Author Thorsten Huck
// 2.4 17.03.2023 HSB-18357 leader and revision cloud display improved , Author Thorsten Huck
// 2.3 15.02.2023 HSB-19972 boundings improved, new property transparency can create filled opaque background , Author Thorsten Huck
// 2.2 15.12.2022 HSB-17353 new revision cloud style , Author Thorsten Huck
// 2.1 15.12.2022 HSB-17353 MetalPartCollectionEntity: Performance imroved, new property for equality distinction, new formats to calculate and display equality based 'Quantity' and 'TotalWeight' , Author Thorsten Huck
// 2.0 12.12.2022 HSB-17297 Alignments and Scale Properties added , Author Thorsten Huck
// 1.9 24.06.2022 HSB-15792 new property leader linetype, supports auto creation in modelspace if defined in blockspace with a shopdraw viewport , Author Thorsten Huck
// 1.8 16.11.2021 HSB-13819  guidelline will be suppressed if location is inside of shape , Author Thorsten Huck
// 1.7 22.09.2021 HSB-13249 guidelline will be suppressed if linked entity is opening and location is inside of opening , Author Thorsten Huck
// 1.6 01.07.2021 HSB-12441 - new context command with additional properties to control redrawing of outline of the entity , Author Thorsten Huck
// 1.5 30.06.2021 HSB-12441 enhanced display, full format variable support , Author Thorsten Huck
/// <version value="1.4" date="29Sep2017" author="thorsten.huck@hsbcad.com"> empty format expresses posnum, format takes multiple arguments </version>
/// <version value="1.2" date="21jun2017" author="thorsten.huck@hsbcad.com"> checking and avoiding duplicates </version>
/// <version value="1.1" date="21jun2017" author="thorsten.huck@hsbcad.com"> posnum will be assigned if not present </version>
/// <version value="1.0" date="21jun2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// <insert Lang=en>
/// Select entities, select properties or catalog entry and press OK
/// </insert>

// <summary Lang=en>
// This tsl displays the specified properties of an entity as tag. 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "ScriptName")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Select Tag|") (_TM "|Assign Visible Entity|"))) TSLCONTENT
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
	String tYes = T("|Yes|"), tNo = T("|No|");
	String sNoYes[] = { tNo, tYes};

	String sDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String sClass = "TslUtilities.TslDialogService";	
	String listSelectorMethod = "SelectFromList";
	String optionsMethod = "SelectOption";
	String simpleTextMethod = "GetText";
	String askYesNoMethod = "AskYesNo";
	String showNoticeMethod = "ShowNotice";
	String showMultilineNotice = "ShowMultilineNotice";
	String showDynamic = "ShowDynamicDialog";
	
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

	String k;
	String kAllowedView = "vecAllowedView", tDisabled = T("<|Disabled|>"), kLocation = "RelativeLocation", kContinuous="Continuous",
	kBlockCreationMode = "BlockCreationMode", 
	tHorizontal = T("|Horizontal|"), tVertical=T("|Vertical|"),tAlignedX = T("|X-Aligned|"), tAlignedY = T("|Y-Aligned|"),
	tDefaultEntry = T("<|Default|>"), tNoGroupAssignment =T("|Off|"),
	kQuantity = "Quantity",
	kIndexView = "IndexView";
	
	String tSText=T("|Text|"), tSBox=T("|Box|"), tSRevision=T("|Revision Cloud|"), tSTriangle=T("|Triangle|");

//end Constants//endregion


//End Part #1 //endregion

//region Functions #FU

	//region ArrayToMapFunctions

//region Function GetDoubleArray
	// returns an array of doubles stored in map
	double[] GetDoubleArray(Map mapIn, int bSorted)
	{ 
		double values[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasDouble(i))
				values.append(mapIn.getDouble(i));
				
		if (bSorted)
			values.sorted();		
				
		return values;
	}//endregion

	//region Function SetDoubleArray
	// sets an array of doubles in map
	Map SetDoubleArray(double values[], String key)
	{ 
		key = key.length() < 1 ? "value" : key;
		Map mapOut;
		for (int i=0;i<values.length();i++) 
			mapOut.appendDouble(key, values[i]);	
		return mapOut;
	}//endregion

	//region Function GetStringArray
	// returns an array of doubles stored in map
	String[] GetStringArray(Map mapIn, int bSorted)
	{ 
		String values[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasString(i))
				values.append(mapIn.getString(i));
				
		if (bSorted)
			values.sorted();		
				
		return values;
	}//endregion

	//region Function SetStringArray
	// sets an array of strings in map
	Map SetStringArray(String values[], String key)
	{ 
		key = key.length() < 1 ? "value" : key;
		Map mapOut;
		for (int i=0;i<values.length();i++) 
			mapOut.appendString(key, values[i]);	
		return mapOut;
	}//endregion

	//region Function GetIntArray
	// returns an array of doubles stored in map
	int[] GetIntArray(Map mapIn, int bSorted)
	{ 
		int values[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasInt(i))
				values.append(mapIn.getInt(i));
				
		if (bSorted)
			values.sorted();		
				
		return values;
	}//endregion

	//region Function SetIntArray
	// sets an array of ints in map
	Map SetIntArray(int values[], String key)
	{ 
		key = key.length() < 1 ? "value" : key;
		Map mapOut;
		for (int i=0;i<values.length();i++) 
			mapOut.appendInt(key, values[i]);	
		return mapOut;
	}//endregion

	//region Function GetBodyArray
	// returns an array of bodies stored in map
	Body[] GetBodyArray(Map mapIn)
	{ 
		Body bodies[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasBody(i))
				bodies.append(mapIn.getBody(i));
	
		return bodies;
	}//endregion

	//region Function SetBodyArray
	// sets an array of bodies in map
	Map SetBodyArray(Body bodies[])
	{ 
		Map mapOut;
		for (int i=0;i<bodies.length();i++) 
			mapOut.appendBody("bd", bodies[i]);	
		return mapOut;
	}//endregion

	//region Function GetPlaneProfileArray
	// returns an array of PlaneProfiles stored in map
	PlaneProfile[] GetPlaneProfileArray(Map mapIn)
	{ 
		PlaneProfile pps[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasPlaneProfile(i))
				pps.append(mapIn.getPlaneProfile(i));
	
		return pps;
	}//endregion

	//region Function SetPlaneProfileArray
	// sets an array of PlaneProfiles in map
	Map SetPlaneProfileArray(PlaneProfile pps[])
	{ 
		Map mapOut;
		for (int i=0;i<pps.length();i++) 
			mapOut.appendPlaneProfile("pp", pps[i]);	
		return mapOut;
	}//endregion

//End ArrayToMapFunctions //endregion 	 	

	//region General
	
	//region Function Equals
		// returns true if two strings are equal ignoring any case sensitivity
		int Equals(String str1, String str2)
		{ 
			str1 = str1.makeUpper();
			str2 = str2.makeUpper();		
			return str1==str2;
		}//endregion
		
	
	//endregion 


	//region PLaneProfile Functions

//region Function ClosestMidVertex
	// sets given point to the closest midvertex
	void ClosestMidVertex(PlaneProfile pp, Point3d& pt)
	{ 
		Point3d pts[] = pp.getGripEdgeMidPoints();
		double dmin = U(10e10);
		int n = -1;
		for (int i=0;i<pts.length();i++) 
		{ 
			double d = (pt-pts[i]).length(); 
			if (d<dmin)
			{ 
				n = i;
				dmin = d;
			}
		}//next i
		
		if (n>-1)
			pt = pts[n];
		return;
	}//endregion


	//endregion 

	//region Body
		
//region Function GetSimpleBody
	// returns true if a simple body of the entiy can be returned, if an entity does not provide a solid a small pseudo body will be created if possible
	int GetSimpleBody(Entity ent, Body& bd)
	{ 
		
		//int tick = getTickCount();
		
		MetalPartCollectionEnt ce = (MetalPartCollectionEnt)ent;
		GenBeam gb = (GenBeam)ent;
//		Sip sip = (Sip)entDefine;;
		TslInst tsl = (TslInst)ent;
//		Element el = (Element)entDefine;
//		ERoofPlane erp = (ERoofPlane)entDefine;									
//		ElementRoof elr = (ElementRoof)entDefine;
		Opening opening = (Opening)ent;
//		EntPLine epl= (EntPLine)entDefine;
//		TrussEntity truss = (TrussEntity)entDefine;
//		BlockRef bref = (BlockRef)entDefine;
//		MassGroup mg= (MassGroup)entDefine;
		MasterPanel master= (MasterPanel)ent;
//		FastenerAssemblyEnt fae = (FastenerAssemblyEnt)ent;
//		ChildPanel child = (ChildPanel)entDefine;
//		Section2d section = (Section2d)entDefine;		
		ERoofPlane erp = (ERoofPlane)ent;	
		
		if (erp.bIsValid())
		{ 
			PLine plEnvelope = erp.plEnvelope();
			//plEnvelope.transformBy(_XW*U(10));)plEnvelope.vis(4);			
			if (plEnvelope.area()>pow(dEps,2))
				bd = Body(plEnvelope, erp.coordSys().vecZ(), U(1));	
		}
		else if (gb.bIsValid())
		{
			bd=gb.envelopeBody(true, true);
		}
		else if (tsl.bIsValid())
		{ 
			CoordSys cst = tsl.coordSys();
			bd = ent.realBody();
		// get some kind of solid to get a profile to snap to	
			if (bd.isNull() && !tsl.map().hasPLine("plRoute"))
			{ 
				Point3d pts[] = tsl.gripPoints();
				if (pts.length()>1)
					for (int i=0;i<pts.length()-1;i++) 
					{ 
						Body bdx(pts[i], pts[i + 1], U(1));
						bd.addPart(bdx);
					}//next i
				
				if (bd.isNull())
					bd = Body(tsl.ptOrg(), cst.vecX(), cst.vecY(), cst.vecZ(), U(1), U(1), U(1), 0, 0, 0); 
			}			
		}
		else if (master.bIsValid())
		{ 
			double dZ = master.dThickness();
			bd = Body(master.plShape(), _ZW * (dZ<dEps?dEps:dZ), - 1);
		}
		else if (opening.bIsValid())
		{ 
			Opening o = opening;
			CoordSys cso = o.coordSys();
			Vector3d vecXO= cso.vecX(), vecYO =cso.vecY(), vecZO=cso.vecZ();

			PLine pl = o.plShape();//pl.vis(3);
			Element el = o.element();
			
			Quader q = o.bodyExtents();
			Vector3d vecQ = q.pointAt(1, 1, 1) - q.pointAt(-1, -1, -1);
			if (!vecQ.bIsZeroLength())
				bd=Body(q.pointAt(0, 0, 0), vecXO, vecYO, vecZO, q.dD(vecXO), q.dD(vecYO), q.dD(vecZO), 0, 0, 0);
			else
				bd = Body(pl, el.vecZ() * U(10), 0);
			//bd.vis(2);
			if (bd.isNull())
				bd = Body(cso.ptOrg(), cso.vecX(), cso.vecY(), cso.vecZ(), U(1), U(1), U(1), 0, 0, 0); 
		}
		else if (ce.bIsValid())
		{ 
			MetalPartCollectionDef cd = ce.definitionObject();
			CoordSys cse = ce.coordSys();
			
			Body bdCE;

			GenBeam gbs[] = cd.genBeam();
			for (int i=0;i<gbs.length();i++) 
				bdCE.combine(gb.envelopeBody(true, true));
			
			Entity ents[] = cd.entity();
			for (int i=0;i<ents.length();i++) 
			{ 
				Body bdi;
				if (GetSimpleBody(ents[i], bdi))
					bdCE.combine(bdi);
			}
			
			if (!bdCE.isNull())
			{
				bdCE.transformBy(cse);
				bd = bdCE;
			}
			else
			{ 	
				Quader q = ce.bodyExtents();
				if (Vector3d(q.pointAt(-1,-1,-1)-q.pointAt(1,1,1)).bIsZeroLength())
				{ 
					bd = ent.realBody();
				}
				bd = Body(q.pointAt(0, 0, 0), cse.vecX(), cse.vecY(), cse.vecZ(), q.dX(), q.dY(), q.dZ(), 0, 0, 0);					
			}
	
	
		}		
		
		else
		{ 
			bd = ent.realBody();
		}
		int ok = !bd.isNull();
		
//		int ellapsed = (getTickCount() - tick);
//		if (ellapsed>10)
//			reportNotice("\n" + ent.formatObject("@(TypeName) @(Definition:D)@(scriptName:D) @(Handle) ") + ellapsed+"ms");
		return ok;
	}//endregion
	
	//endregion 

	//region Filter and MetalPart Functions

//region Function FilterTslsByName
	// returns all tsl instances with the given scriptname
	// ents: the array to search, if empty all tsls in modelspace are taken
	// name: the name of the tsl to be returned, all if empty
	TslInst[] FilterTslsByName(Entity ents[], String name)
	{ 
		TslInst out[0];
		
		String names[0];
		if (name.length()>0)
			names.append(name);
			
		int bAll = names.length() < 1;
		
		if (ents.length()<1)
			ents = Group().collectEntities(true, TslInst(),  _kModelSpace);
		
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t= (TslInst)ents[i]; 
			//reportNotice("\ngetTslsByName: " + t.scriptName() +" "+names);
			if (t.bIsValid())
			{
				if (!bAll && names.findNoCase(t.scriptName(),-1)>-1)
					out.append(t);	
				else if (bAll)
					out.append(t);									
			}
		}//next i

		return out;
	}//endregion
	
//region Function FilterTslsByNames
	// returns all tsl instances with a certain scriptname
	// ents: the array to search, if empty all tsls in modelspace are taken
	// names: the names of the tsls to be returned, all if empty
	TslInst[] FilterTslsByNames(Entity ents[], String names[])
	{ 
		TslInst out[0];
		int bAll = names.length() < 1;
		
		if (ents.length()<1)
			ents = Group().collectEntities(true, TslInst(),  _kModelSpace);
		
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t= (TslInst)ents[i]; 
			//reportNotice("\ngetTslsByName: " + t.scriptName() +" "+names);
			if (t.bIsValid())
			{
				if (!bAll && names.findNoCase(t.scriptName(),-1)>-1)
					out.append(t);	
				else if (bAll)
					out.append(t);									
			}
		}//next i

		return out;
	}//endregion

//region Function CollectShopdrawViews
	// returns the shopdrawViews out of the entity array, if empty it takes all model instances
	ShopDrawView[] CollectShopdrawViews(Entity ents[])
	{ 
		ShopDrawView out[0];		
		if (ents.length()<1)
			ents = Group().collectEntities(true, ShopDrawView(), _kModelSpace);
		for (int i=0;i<ents.length();i++) 
		{ 
			ShopDrawView ent= (ShopDrawView)ents[i]; 
			if (ent.bIsValid() && out.find(ent)<0)
				out.append(ent); 
		}//next i		
		return out;
	}//endregion

//region Function CollectMultipages
	// returns the multipages out of the entity array, if empty it takes all model instances
	MultiPage[] CollectMultipages(Entity ents[])
	{ 
		MultiPage out[0];		
		if (ents.length()<1)
			ents = Group().collectEntities(true, MultiPage(), _kModelSpace);
		for (int i=0;i<ents.length();i++) 
		{ 
			MultiPage ent= (MultiPage)ents[i]; 
			if (ent.bIsValid() && out.find(ent)<0)
				out.append(ent);			 
		}//next i		
		return out;
	}//endregion

//region Function FilterMetalParts
	// returns the accepted entities based on a dummy painter
	MetalPartCollectionEnt[] FilterMetalParts(Entity ents[])
	{ 
		MetalPartCollectionEnt out[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			MetalPartCollectionEnt mpce = (MetalPartCollectionEnt)ents[i]; 
			if (mpce.bIsValid())
				out.append(mpce);
			 
		}//next i
		
		return out;
	}//endregion

//region Function GetMetalPartChildEntities
	// returns the entities of a metalpartCollectionEnt
	Entity[] GetMetalPartChildEntities(MetalPartCollectionEnt ce, PainterDefinition pd)
	{ 
		Entity ents[0];
		
		MetalPartCollectionDef cd = ce.bIsValid()?ce.definitionObject():MetalPartCollectionDef();
		if (cd.bIsValid())
			ents.append(cd.entity());
			
		if (pd.bIsValid())
			ents = pd.filterAcceptedEntities(ents);
			
		return ents;
	}//endregion

//region Function SetSequenceColor
	// returns the sequential color if defined, else original color is used
	void SetSequenceColor(int& color, Map mapColors)
	{ 
		if (color < 0)return;
		
		int colors[] = GetIntArray(mapColors, false);
		if (colors.length()>0)
		{ 
			int n=color;
			while(n>colors.length()-1)
				n-=colors.length();
			color=colors[n];			
		}				
		return;
	}//endregion

//region Function AppendEntities
	// appends entities to an array of entities avoiding duplicates
	void AppendEntities(Entity& ents[], Entity entsAdd[])
	{ 
		for (int i=0;i<entsAdd.length();i++) 
			if(ents.find(entsAdd[i])<0)
				ents.append(entsAdd[i]); 
		return;
	}//endregion

//region Function AppendMultipage2Entities
	// appends entities to an array of entities avoiding duplicates
	void AppendMultipage2Entities(Entity& ents[], MultiPage entsAdd[])
	{ 
		for (int i=0;i<entsAdd.length();i++) 
			if(ents.find(entsAdd[i])<0)
				ents.append(entsAdd[i]); 
		return;
	}//endregion

//region Function AppendMetalParts
	// appends entities to an array of entities avoiding duplicates
	void AppendMetalParts(MetalPartCollectionEnt& ents[], MetalPartCollectionEnt entsAdd[])
	{ 
		for (int i=0;i<entsAdd.length();i++) 
			if(ents.find(entsAdd[i])<0)
				ents.append(entsAdd[i]); 
		return;
	}//endregion

	
	//endregion 

	//region Miscelaneous Functions

//region Function AppendXRefEntities
	// searches for xrefs and appends content of xref entities to an array of entities avoiding duplicates
	void AppendXRefEntities(Entity& ents[], Entity entsAdd[])
	{ 
	// Find BlockRefs and append its entities
		for (int i=0;i<entsAdd.length();i++) 
		{ 
			//reportNotice("\n" + entsAdd[i].formatObject("@(Definition:D)@(ScriptName:D)@(Posnum:D) @(DxfName)"));
			BlockRef bref = (BlockRef)entsAdd[i];
			MetalPartCollectionEnt ce= (MetalPartCollectionEnt)entsAdd[i];
			if (bref.bIsValid())
			{
				Block block(bref.definition());
				Entity entRefs[] = block.entity();
				
			// Append entities which are part of an xref
				for (int i=0;i<entRefs.length();i++) 
					if(ents.find(entRefs[i])<0 && entRefs[i].xrefName().length()>0)
					{
						ents.append(entRefs[i]); 
					}
			}
			
//			else if (ce.bIsValid())//TODO XXXX to verify
//			{ 
//				CollectionDefinition cd = ce.definitionObject();
//				Entity entRefs[] = cd.entity();
//				AppendEntities(ents, entRefs);
//			}
		}//next i	
		

		return;
	}//endregion

//region Function CollectFastenerMaps
	// returns a map with n submaps carrying an array of fasteners and an optional metalpart
	void CollectFastenerMaps(Map& maps, Entity entFasteners[], MetalPartCollectionEnt ce)
	{ 
	
		MetalPartCollectionDef cd = ce.bIsValid()?ce.definitionObject():MetalPartCollectionDef();
		String def = cd.entryName();
		
		for (int i=0;i<entFasteners.length();i++) 
		{ 
			FastenerAssemblyEnt fae = (FastenerAssemblyEnt)entFasteners[i];
			if (fae.bIsValid())
			{ 
				Map m;
				Entity ents[] ={ fae};
				String key = def + (def.length() > 0 ? "_" : "");
				key+= fae.articleNumber();
				if (maps.hasMap(key))
				{ 
					m = maps.getMap(key);
					ents = m.getEntityArray("ent[]", "", "ent");
					ents.append(fae);
				}
				else
				{ 
					ents.append(fae);
										
				}
				if (ce.bIsValid())m.setEntity("parent", ce );
				m.setEntityArray(ents, true, "ent[]", "", "ent");
				maps.setMap(key, m);	
			}	 
		}//next i		
		
		return;
	}//endregion

//region Function FastenerDataMap
	// returns the component and article data of a fastenerAssemblyEntity
	Map fastenerDataMap(FastenerAssemblyEnt fae)
	{ 
		Map m;

		FastenerAssemblyDef fadef(fae.definition());
		if (!fadef.bIsValid())return m;
		FastenerSimpleComponent fsc = fadef.mainComponent(fae.articleNumber());
		FastenerComponentData fcd = fsc.componentData();
		
		m.setString("Name", fcd.name());
		m.setString("Type", fcd.type());
		m.setString("SubType", fcd.subType());
		m.setString("Manufacturer", fcd.manufacturer());
		m.setString("Material", fcd.material());
		m.setString("Coating", fcd.coating());
		m.setString("Category", fcd.category());
		m.setString("Norm", fcd.norm());
		m.setString("Grade", fcd.grade());
		
		m.setDouble("Diameter", fcd.mainDiameter());
		m.setDouble("StackThickness", fcd.stackThickness());
		m.setDouble("SinkDiameter", fcd.sinkDiameter());
		
		FastenerArticleData fad = fsc.articleData();
		m.setString("Description", fad.description());
		m.setString("Notes", fad.notes());
		m.setDouble("ThreadLength", fad.threadLength());
		m.setDouble("FastenerLength", fad.fastenerLength());

		return m;
	}//endregion	

//region Function ContainsSection
	// returns true if an array of entities contains a section
	int ContainsSection(Entity ents)
	{ 
		int out;
		for (int i=0;i<ents.length();i++) 
		{ 
			Section2d section = (Section2d)ents[i]; 
			if (section.bIsValid())
			{
				out = true;
				break;
			}

		}//next i
		
		return out;
	}//endregion

//region Function GetBodyFromQuader
	// returns the body of a quader
	Body GetBodyFromQuader(Quader qdr)
	{ 
		CoordSys cs = qdr.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		
		Body bd;
		if (qdr.dX()>dEps && qdr.dY()>dEps && qdr.dZ()>dEps)
		{ 
			bd = Body (qdr.pointAt(0, 0, 0), vecX, vecY, vecZ, qdr.dX(), qdr.dY(), qdr.dZ(), 0, 0, 0);	
		}
			
		return bd;
	}//endregion

//region Function GetBodies
	// returns the bodies, respectivly pseudo bodies, may modify array ents
	// ents: the list of entities to return the body of, zero body entities will be removed
	Body[] GetBodies(Entity& ents[], Entity& parents[])
	{ 
		Body out[0];
		Entity entsOut[0], entParentsOut[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			Entity e = ents[i]; 
			Entity parent = parents[i]; 
			//if (bDebug)reportNotice("\nGetBody: "+ e.typeDxfName()); 


		// Default (not all types implemented yet)
			Body bd;
			int accepted = GetSimpleBody(e, bd);
			if (accepted)
			{
//				if (parent.bIsValid())
//				{ 
//					MetalPartCollectionEnt ce = (MetalPartCollectionEnt)parent;
//					if (ce.bIsValid())
//					{
//						bd.transformBy(ce.coordSys());
//						reportNotice("\nGetBody: transformed solid of "+ e.typeDxfName() + " by " + parent.formatObject("@(TypeName)@(definition:D)")); 
//					}
//				}

				out.append(bd);
				entsOut.append(e);
				entParentsOut.append(parent);
				continue;
			}

			CoordSys cse;
			GenBeam g = (GenBeam)e;
			if (g.bIsValid())
			{ 
				Body bd = g.envelopeBody(false, true); 	//bd.vis(2);
				out.append(bd);
				entsOut.append(g);
				entParentsOut.append(parent);
				continue;
			}


			Element el = (Element)e;
			if (el.bIsValid())
			{ 
				Vector3d vecZE = el.vecZ();
				LineSeg seg = el.segmentMinMax();
				double dZ = abs(vecZE.dotProduct(seg.ptEnd() - seg.ptStart()));
				if (dZ <= dEps) 
					dZ =el.dBeamWidth()<dEps?U(1):el.dBeamWidth();

				PLine plEnvelope = el.plEnvelope();
				plEnvelope.projectPointsToPlane(Plane((seg.length()>dEps?seg.ptMid():el.ptOrg()), vecZE), vecZE);
				Body bd;
				if (plEnvelope.area()>pow(dEps,2))
					bd = Body(plEnvelope, vecZE * dZ ,0);
				else
				{ 
					Quader q = el.bodyExtents();
					bd = GetBodyFromQuader(q);
				}
				
				// catching undefined elements
				if (bd.isNull())
				{ 
					bd = Body(el.ptOrg(), el.vecZ() * U(1), U(1));
				}
				if (bd.isNull())
				{ 
					out.append(bd);	//bd.vis(2);	
					entsOut.append(el);
					entParentsOut.append(parent);					
				}
				continue;
			}
			
			MetalPartCollectionEnt ce = (MetalPartCollectionEnt)e;
			if (ce.bIsValid()) 
			{
				CoordSys cse = ce.coordSys();
				Quader q = ce.bodyExtents();
				if (Vector3d(q.pointAt(-1,-1,-1)-q.pointAt(1,1,1)).bIsZeroLength())
				{ 
					continue;
				}
				Body bd(q.pointAt(0, 0, 0), cse.vecX(), cse.vecY(), cse.vecZ(), q.dX(), q.dY(), q.dZ(), 0, 0, 0);
				out.append(bd);
				entsOut.append(ce);
				entParentsOut.append(parent);
				continue;
			}

			// HSB-22775
			bd = e.realBody();
			if (!bd.isNull())
			{
				MetalPartCollectionEnt ceParent = (MetalPartCollectionEnt)parent;
				if (ceParent.bIsValid())
				{
					bd.transformBy(ceParent.coordSys());	
					reportNotice("\nGetBody: collecting solid of "+ e.typeDxfName() + " " + ceParent.definitionObject().entryName()); 
				}
	
//				if (bDebug)reportNotice("\nGetBody: collecting solid of "+ e.typeDxfName() ); 
					
				out.append(bd);
				entsOut.append(e);
				entParentsOut.append(parent);
				continue;
			}
			
//			if (bDebug)
//				reportMessage("\nGetBody: undefined "+ e.typeDxfName()); 
			
		}//next i
		ents = entsOut;
		parents = entParentsOut;
		return out;
	}//endregion

//region Function GetPlaneProfiles
	// returns the shadow profiles of the given bodies
	// bodies: an array of bodies
	// pn: the plane to project the planeprofile to
	// transformTo: transformation matrix to transform i.e. to the section
	PlaneProfile[] GetPlaneProfiles(Body bodies[], Plane pn, CoordSys transformTo, PlaneProfile ppClip)
	{ 
		//{Display dpx(252); dpx.draw(ppClip, _kDrawFilled,20);}
		CoordSys cs(pn.ptOrg(), pn.vecX(), pn.vecY(), pn.vecZ());
		PlaneProfile pps[0];
		for (int i=0;i<bodies.length();i++) 
		{ 
			PlaneProfile pp(cs);
			pp.unionWith(bodies[i].shadowProfile(pn));
			pp.transformBy(transformTo);
			pp.intersectWith(ppClip);
			//{Display dpx(i+1); dpx.draw(pp, _kDrawFilled,40);}
			pps.append(pp);			 
		}//next i
		
		return pps;
	}//endregion

//region Function OrderByVisibility
	// orders the arrays by the visible area
	void OrderByVisibility(Entity& ents[], Body& bodies[], PlaneProfile& pps[])
	{ 
		if (ents.length()<2)
		{ 
			return;
		}
		if (ents.length()!=bodies.length() || bodies.length()!=pps.length())
		{ 
			reportMessage("\nOrderByVisibility: unexpected error");
			return;
		}
		
		CoordSys cs = pps.first().coordSys();
		Vector3d vecX = cs.vecX();
		
		double areas[0];
		CoordSys css[0];
		for (int i=0;i<pps.length();i++)
		{
			areas.append(pps[i].area());
			css.append(pps[i].coordSys());
		}

	// order byVecX
		for (int i=0;i<ents.length();i++) 
			for (int j=0;j<ents.length()-1;j++) 
			{
				double d1 = vecX.dotProduct(_PtW - css[j].ptOrg());
				double d2 = vecX.dotProduct(_PtW - css[j+1].ptOrg());
				
				if (d1>d2)
				{	
					ents.swap(j, j + 1);
					bodies.swap(j, j + 1);
					pps.swap(j, j + 1);
					areas.swap(j, j + 1);
					css.swap(j, j + 1);					
				}				
			}

	// order byArea
		for (int i=0;i<ents.length();i++) 
			for (int j=0;j<ents.length()-1;j++) 
				if (areas[j]>areas[j+1])
				{	
					ents.swap(j, j + 1);
					bodies.swap(j, j + 1);
					pps.swap(j, j + 1);
					areas.swap(j, j + 1);
					css.swap(j, j + 1);	
				}

		return;
	}//endregion

//region Function ReplaceString
	// returns
	void ReplaceString(String& text, String sFind, String sReplace)
	{ 
		int x = text.find(sFind,0,false);
		if (x>-1)
		{ 
			String left = text.left(x);
			String right = text.right(text.length()-sFind.length()-x);
			text = left + sReplace + right;
			
		}
		
		return;
	}//endregion	
		
//region Function AppendExtremePoints
	// appends extreme vertices of sub entities
	void AppendExtremePoints(Point3d& ptsX[], Entity ent, CoordSys csx, Vector3d vecView)
	{ 
		
		TslInst t = (TslInst)ent;
		if (t.bIsValid())
		{ 
			GenBeam gbs[] = t.genBeam();
			for (int i=0;i<gbs.length();i++) 
			{ 
				Body bd = gbs[i].envelopeBody(); //.vis(3); 
				bd.transformBy(csx);
				ptsX.append(bd.extremeVertices(vecView)); 
			}//next i
			
		}
		
		return;
	}//endregion


	//endregion

	//region Equality Functions
	
//region Function BuildGroupsOfEquality
	// returns a map with submaps of entity arrays which match in their equality format
	Map BuildGroupsOfEquality(String equalityFormat, Entity entsIn[])
	{ 
		Map maps;
		
		String format = equalityFormat.length()<1?"@(Handle)":equalityFormat;
		
		for (int i=0;i<entsIn.length();i++) 
		{ 
			Entity& ent = entsIn[i];
			String key = ent.formatObject(format); 
			if (maps.hasMap(key))
			{ 
				Map m = maps.getMap(key);
				Entity ents[] = m.getEntityArray("ent[]", "", "ent");
				ents.append(ent);
				m.setEntityArray(ents, true, "ent[]", "", "ent");
				maps.setMap(key, m);
			}
			else
			{ 
				Entity ents[] ={ ent};
				Map m; 
				m.setEntityArray(ents, true, "ent[]", "", "ent");
				maps.setMap(key, m);
			}			 
		}//next i		
		
		
		return maps;
	}//endregion	
		
//region Function GetCommonLocation
	// returns the transformed location in the given plane
	Point3d GetCommonLocation(Plane pn, CoordSys cs, Entity ents[])
	{ 
		Point3d pt = cs.ptOrg();
		
		Entity ents1[] = ents;
		Entity ents2[] = ents;
		Body bodies[] = GetBodies(ents1, ents2);
		
		Point3d pts[0];
		for (int i=0;i<bodies.length();i++) 
		{ 
			Body& bd= bodies[i];
			bd.transformBy(cs);
			//if (bDebug)bd.vis(6);
			Point3d ptCen = bd.ptCen();	//ptCen.vis(3);
			pts.append(ptCen);
		}//next i
		
		pt.setToAverage(pts);
		Line(pt, pn.vecZ()).hasIntersection(pn, pt);
		if (bDebug)pt.vis(2);
		return pt;
	}//endregion
//region Function GetCommonLocation2
	// returns the transformed location in the given plane
	Point3d GetCommonLocation2(Plane pn, CoordSys cs, Body bodies[])
	{ 
		Point3d pt = cs.ptOrg();
		
		Point3d pts[0];
		for (int i=0;i<bodies.length();i++) 
		{ 
			Body& bd= bodies[i];
			bd.transformBy(cs);
			//if (bDebug)bd.vis(6);
			Point3d ptCen = bd.ptCen();	//ptCen.vis(3);
			pts.append(ptCen);
		}//next i
		
		pt.setToAverage(pts);
		Line(pt, pn.vecZ()).hasIntersection(pn, pt);
		if (bDebug)pt.vis(2);
		return pt;
	}//endregion	
	
//region Function GetPlaneProfile
	// returns the projected planeprofiles and modifies the common planeprofile
	PlaneProfile[] GetCommonPlaneProfile(PlaneProfile& ppCommon, CoordSys cs, Entity ents[], double blowUp)
	{ 
		Entity ents1[] = ents;
		Entity ents2[] = ents;
		Body bodies[] = GetBodies(ents1, ents2);	
		
		CoordSys csp = ppCommon.coordSys();
		Plane pn(csp.ptOrg(), csp.vecZ());
		
		PlaneProfile pps[0], ppX = ppCommon;
		for (int i=0;i<bodies.length();i++) 
		{ 
			Body& bd= bodies[i];
			bd.transformBy(cs);
			//if (bDebug)bd.vis(6);
			PlaneProfile pp = bd.shadowProfile(pn);
			pps.append(pp);	
			//{Display dpx(2); dpx.draw(pp, _kDrawFilled,50);}
			pp.shrink(-blowUp);
			
			ppX.unionWith(pp);
			if (ppX.area()<pow(dEps,2)) // catch failures (i.e. triangles touching other triangles)
			{ 
				pp.shrink(-dEps);
				ppX = ppCommon;
				ppX.unionWith(pp);
			}
			if (ppX.area()>pow(dEps,2))
				ppCommon = ppX;
			
		}//next i		
	
		return pps;
	}//endregion	

//region Function GetPlaneProfile2
	// returns the projected planeprofiles and modifies the common planeprofile
	PlaneProfile[] GetCommonPlaneProfile2(PlaneProfile& ppCommon, CoordSys cs, Body bodies[], double blowUp)
	{ 
		CoordSys csp = ppCommon.coordSys();
		Plane pn(csp.ptOrg(), csp.vecZ());
		
		PlaneProfile pps[0], ppX = ppCommon;
		for (int i=0;i<bodies.length();i++) 
		{ 
			Body& bd= bodies[i];
			bd.transformBy(cs);
			//if (bDebug)bd.vis(6);
			PlaneProfile pp = bd.shadowProfile(pn);
			pps.append(pp);	
			//{Display dpx(2); dpx.draw(pp, _kDrawFilled,50);}
			pp.shrink(-blowUp);
			
			ppX.unionWith(pp);
			if (ppX.area()<pow(dEps,2)) // catch failures (i.e. triangles touching other triangles)
			{ 
				pp.shrink(-dEps);
				ppX = ppCommon;
				ppX.unionWith(pp);
			}
			if (ppX.area()>pow(dEps,2))
				ppCommon = ppX;
			
		}//next i		
	
		return pps;
	}//endregion


//region Function SplitEqualityGroups
	// splits each equality group into multiple if projections do mot overlap and stores the common range
	void SplitEqualityGroups(Map& mapsIn, CoordSys cs2ps, double blowUp)
	{ 
		Map mapsOut;
		double dBlowUp = blowUp;
		for (int i=0;i<mapsIn.length();i++) 
		{ 
			String key = mapsIn.keyAt(i);
			Map m= mapsIn.getMap(i);				
			Entity ents[]=m.getEntityArray("ent[]", "", "ent");

			PlaneProfile ppCommon(CoordSys());				
			PlaneProfile pps[] = GetCommonPlaneProfile(ppCommon, cs2ps, ents, dBlowUp);
			
			//{Display dpx(3); dpx.draw(ppCommon, _kDrawFilled,50);}
			
			PLine rings[] = ppCommon.allRings(true, false);
			if (rings.length()>1 && ents.length()>1)
			{ 
				for (int r=0;r<rings.length();r++) 
				{ 
					PlaneProfile ppX(CoordSys());
					ppX.joinRing(rings[r], _kAdd);
					
					//if(bDebug){Display dpx(r+1); dpx.draw(ppX, _kDrawFilled,90);}
					
					Entity entsR[0];
					PlaneProfile ppsR[0];
					for (int j=pps.length()-1; j>=0 ; j--) 
					{ 
						PlaneProfile ppj= pps[j];
						if (ppj.intersectWith(ppX))
						{
							entsR.append(ents[j]);
							ppsR.append(pps[j]);
							pps.removeAt(j);
							ents.removeAt(j);
						}
					}						
					
					if (entsR.length()>0)
					{ 
						String keyR = mapsIn.keyAt(i)+"_"+r;
						Map mapR; 
						mapR.setEntityArray(entsR, true, "ent[]", "", "ent");
						
						Map profiles = SetPlaneProfileArray(ppsR);
						mapR.setMap("pps", profiles);
						mapR.setPlaneProfile("ppCommon", ppX);
						mapsOut.setMap(keyR, mapR);	
					}	
				}//next r
				
				//mapsIn.removeAt(key, true);	
			}
			else // update single ring assignment profiles
			{ 
				Map profiles = SetPlaneProfileArray(pps);
				m.setMap("pps", profiles);
				m.setPlaneProfile("ppCommon", ppCommon);
				mapsOut.setMap(key, m);
			}
		}// next i		
		mapsIn = mapsOut;
		return;
	}//endregion	

//region Function SplitEqualityGroups2
	// splits each equality group into multiple if projections do mot overlap and stores the common range
	void SplitEqualityGroups2(Map& mapsIn, CoordSys cs2ps, double blowUp, Body bodies[], String handles[])
	{ 
		Map mapsOut;
		double dBlowUp = blowUp;
		for (int i=0;i<mapsIn.length();i++) 
		{ 
			String key = mapsIn.keyAt(i);
			Map m= mapsIn.getMap(i);				
			Entity ents[]=m.getEntityArray("ent[]", "", "ent");

			Body bdEnts[0];
			for (int j=0;j<ents.length();j++) 
			{ 
				int n = handles.findNoCase(ents[j].handle(),-1);
				if (n>-1)
				{
					bdEnts.append(bodies[n]);
				}
				else // should not happen
				{ 
					Body bdEnt;
					if(GetSimpleBody(ents[j], bdEnt))
						bdEnts.append(bdEnt);
				}	
				 
			}//next j

			PlaneProfile ppCommon(CoordSys());				
			PlaneProfile pps[] = GetCommonPlaneProfile2(ppCommon, cs2ps, bdEnts, dBlowUp);
			
			//{Display dpx(3); dpx.draw(ppCommon, _kDrawFilled,50);}
			
			PLine rings[] = ppCommon.allRings(true, false);
			if (rings.length()>1 && ents.length()>1)
			{ 
				for (int r=0;r<rings.length();r++) 
				{ 
					PlaneProfile ppX(CoordSys());
					ppX.joinRing(rings[r], _kAdd);
					
					//if(bDebug){Display dpx(r+1); dpx.draw(ppX, _kDrawFilled,90);}
					
					Entity entsR[0];
					PlaneProfile ppsR[0];
					for (int j=pps.length()-1; j>=0 ; j--) 
					{ 
						PlaneProfile ppj= pps[j];
						if (ppj.intersectWith(ppX))
						{
							entsR.append(ents[j]);
							ppsR.append(pps[j]);
							pps.removeAt(j);
							ents.removeAt(j);
						}
					}						
					
					if (entsR.length()>0)
					{ 
						String keyR = mapsIn.keyAt(i)+"_"+r;
						Map mapR; 
						mapR.setEntityArray(entsR, true, "ent[]", "", "ent");
						
						Map profiles = SetPlaneProfileArray(ppsR);
						mapR.setMap("pps", profiles);
						mapR.setPlaneProfile("ppCommon", ppX);
						mapsOut.setMap(keyR, mapR);	
					}	
				}//next r
				
				//mapsIn.removeAt(key, true);	
			}
			else // update single ring assignment profiles
			{ 
				Map profiles = SetPlaneProfileArray(pps);
				m.setMap("pps", profiles);
				m.setPlaneProfile("ppCommon", ppCommon);
				mapsOut.setMap(key, m);
			}
		}// next i		
		mapsIn = mapsOut;
		return;
	}//endregion


	//endregion 

	//region Tag and Format Functions

//region Function GetTagShape
	// returns the polyline of the tag shape and a potential second shape
	// Map map: a map used to carry additional data for the triangle shape of hanger tags
	// PlaneProfile ppX: carries ptOrg, dX, dY
	PLine GetTagShape(PlaneProfile ppRef, PlaneProfile& shape2, Map map)
	{ 
		Vector3d vecXRead=map.getVector3d("vecXRead");
		Vector3d vecYRead=map.getVector3d("vecYRead");
		String dimStyle=map.getString("dimStyle");
		double textHeight=map.getDouble("textHeight");
		String text=map.getString("text");
		int flagX=map.getInt("flagX");
		int flagY=map.getInt("flagY");		
		String sStyle=map.getString("style");
		double dX=map.getDouble("dX");
		double dY=map.getDouble("dY");
		
		CoordSys csDef = ppRef.coordSys();
		Point3d ptRef = csDef.ptOrg();
		Vector3d vecZ = map.getVector3d("vecZ");
		
		Entity entTsl = map.getEntity("tsl");
		TslInst tsl = entTsl.bIsValid() ? (TslInst)entTsl : TslInst();

		Vector3d vec = .5*(vecXRead*dX+vecYRead*dY);
		Point3d pt = csDef.ptOrg()+ .5 * (flagX * vecXRead * dX + flagY * vecYRead * dY);

		PLine plShape;
		plShape.createRectangle(LineSeg(pt-vec, pt+vec), vecXRead, vecYRead);
		plShape.offset(-.25*textHeight, true);


		if (sStyle==tSRevision)
		{ 
			plShape.vis(3);
			
			double revOffset = dX > dY ? dY : dX;
			revOffset *= .3;
			if (revOffset < textHeight)
				revOffset = textHeight * .75;
			
			PLine plOut;plOut.createRectangle(LineSeg(pt-vec, pt+vec), vecXRead, vecYRead);
			plOut.offset(-revOffset, true);			plOut.vis(12);
			
			PLine plx(vecZ);			
			double dL = plShape.length();
			double dDist = dL / textHeight*2.4;//*8.5;
			if (dDist < revOffset)
				dDist = revOffset*2.4;
			
			int num = dL / dDist + .999;
			if (num < 6)
			{ 
				num = 6;
				dDist = dL / num;
				
			}
			double d1 = .25*textHeight;
			Point3d ptA1 = plShape.getPointAtDist(d1);
			Point3d pt1 = ptA1;
			Point3d	pt2 = plShape.getPointAtDist(dDist);//dL*.15);
			//pt1.vis(3);		pt2.vis(6);
			
			plx.addVertex(pt1);
			double bulge = tan(22.5);
			for (int i=0;i<num;i++) 
			{ 
				double d1 = plShape.getDistAtPoint(pt1);
				double d2 = plShape.getDistAtPoint(pt2);
				if (d2<=dEps && d1>0)
					d2 = plShape.length();
				double d3 = (d1 + d2) * .5;
				Point3d pt3 =plShape.getPointAtDist(d3);// (pt1 + pt2) * .5;
								
				pt3 = plShape.closestPointTo(pt3);		//pt3.vis(252);
				pt3 = plOut.closestPointTo(pt3);		//pt3.vis(1);
				plx.addVertex(pt2, pt3);

				pt1 = pt2;
				d1 = plShape.getDistAtPoint(pt2);
				d2 = plShape.getDistAtPoint(pt2) + dDist;// * .15;
				if (d2 > dL && abs(dL-d1)>dEps)
				{
					plx.addVertex(ptA1, tan(44));//pt3);
					break;
				}
				else
				{ 
					pt2 = plShape.getPointAtDist(d2);
				}
	
				plx.vis(i);
			}//next i
			plx.vis(2);
			plx.close();
			plShape = plx;

			
		}
	
		else if (sStyle==tSTriangle)
		{ 
			Vector3d vecXT = vecXRead;
			Vector3d vecYT = vecYRead;

		// GenericHanger: align triangle by coordSys of defining entity
			if (tsl.bIsValid() && "GenericHanger".find(tsl.scriptName(),0,false)==0)
			{ 
				vecXT = -csDef.vecX();
				vecYT = csDef.vecZ();
				vecXT.vis(ptRef, 1);
				vecYT.vis(ptRef, 4);
				
				if (vecXT.crossProduct(vecYT).dotProduct(vecZ) < 0)
					vecYT*=-1;
				
				pt = ptRef + .5 * (flagX * vecXRead * dX + flagY * vecYT * dY);
				flagY *= vecYRead.dotProduct(vecYT) < 0 ?- 1 : 1;
			}
			
			

			double r = (dX > dY ? dX : dY) * .5 + .25*textHeight;
			PLine circle; circle.createCircle(pt, vecZ, r-dEps);
			circle.convertToLineApprox(dEps);
			circle.vis(3);
			
			double a = r*2*sqrt(3);
			double h = sqrt(3) / 2 * a;
		
			Point3d pt1 = pt + vecYT * r; pt1.vis(1);
			Point3d pt2 = pt1 + vecXT * .5*a;
			pt1-=vecXT * .5*a;
			Point3d pt3 = pt - vecYT *(h-r);
			
			PLine plx(pt1, pt2, pt3);
			plx.close();
			plx.vis(2);
			
						
			shape2.joinRing(plx, _kAdd);
			shape2.joinRing(circle, _kSubtract);
			plShape = circle;
		}


		return plShape;
	}//endregion
										
//region Function LocateTag
	// tries to find a collsion free placement and modifies the given overall range
	void LocateTag(PlaneProfile& ppRange, Point3d& ptLoc, PLine& plShape, Vector3d vecDir, Map params)
	{ 
		double dStep = params.getDouble("textheight") * .5;
		if (dStep < 0)dStep = U(50);
		
		Vector3d vecX = params.getVector3d("vecXRead");	if(vecX.bIsZeroLength())vecX=_XW;
		Vector3d vecY = params.getVector3d("vecYRead");	if(vecY.bIsZeroLength())vecX=_YW;
		Vector3d vecZ = vecX.crossProduct(vecY);
		
		
		PlaneProfile ppx(CoordSys(ptLoc, vecX, vecY, vecZ));
		ppx.joinRing(plShape,_kAdd);
		double dX = ppx.dX();
		double dY = ppx.dY();
		
		int cnt;			
		while(cnt<10 && ppx.intersectWith(ppRange))
		{ 
		// try by moving by moving in offset direction	
			//plShape.vis(cnt);
			Vector3d vecMove = vecDir * dStep;
			plShape.transformBy(vecMove);
			ptLoc.transformBy(vecMove);
			
		// direction offset has failed: try again in horizontal direction
			ppx = PlaneProfile(plShape);				
			if(ppx.intersectWith(ppRange))
			{ 
				Vector3d vec = vecX; if(vecX.dotProduct(vecDir) < 0) vec *= -1;
				vecMove = vec * .5 * dX;
				plShape.transformBy(vecMove);
				//plShape.vis(1);
				
			// horizontal offset has failed: try again in vertical direction	
				ppx = PlaneProfile(plShape);
				if(ppx.intersectWith(ppRange))
				{ 
					plShape.transformBy(-vecMove);
					Vector3d vec = vecY; if(vecY.dotProduct(vecDir) < 0) vec *= -1;
					vecMove = vec * dStep;
					plShape.transformBy(vecMove);
					ppx = PlaneProfile(plShape);
					//plShape.vis(3);
					if(ppx.intersectWith(ppRange))
					{ 
						plShape.transformBy(-vecMove);
						ppx = PlaneProfile(plShape);
					}
				// accepted
					else
					{ 
						ptLoc.transformBy(vecMove);
					}
				}
			// accepted	
				else
				{ 
					ptLoc.transformBy(vecMove);
				}	
			}
		// don't go wild	
			cnt++;
		}	
		ppRange.joinRing(plShape, _kAdd);
		
		return;
	}//endregion

//region Function GetAutoFormat
	// returns the default format of the specified entity type
	String GetAutoFormat(Entity ent, String format)
	{ 
		String sThisFormat = format;
		if (sThisFormat.length()>0)
		{ 
			return sThisFormat;
		}
		
		GenBeam gb = (GenBeam)ent;
		Element el = (Element)ent;
		TslInst tsl = (TslInst)ent;
		Opening op = (Opening)ent;
		MetalPartCollectionEnt ce = (MetalPartCollectionEnt)ent;
		TrussEntity te = (TrussEntity)ent;
		EntPLine epl = (EntPLine)ent;
		BlockRef bref = (BlockRef)ent;
		MasterPanel master = (MasterPanel)ent;
		FastenerAssemblyEnt fae= (FastenerAssemblyEnt)ent;
		MassGroup mg= (MassGroup)ent;
		
		if (gb.bIsValid())
			sThisFormat = "@(PosNum)";
		else if (el.bIsValid())
			sThisFormat = "@(ElementNumber)";
		else if (tsl.bIsValid())
			sThisFormat = "@(ScriptName)";
		else if (op.bIsValid())
			sThisFormat = "@(Width:RL0)x@(Height:RL0)";
		else if (ce.bIsValid())
			sThisFormat = "@(Definition)";
		else if (te.bIsValid())
			sThisFormat = "@(TrussMark:D)";			
		else if (epl.bIsValid())
			sThisFormat = epl.getPLine().isClosed()?T("|Area|: ")+"@(Area)":T("|Length|: ")+"@(Length)";
		else if (bref.bIsValid())
			sThisFormat = "@(BlockName:D)";			
		else if (master.bIsValid())
			sThisFormat = "@(Number)";
		else if (fae.bIsValid())
			sThisFormat = "@(ArticleNumber)";
		else if (mg.bIsValid())
		{ 
			Map m= ent.getAutoPropertyMap();	
			if (m.hasString(T("|Description|")))
				sThisFormat = m.getString(T("@(|Description|)"));	
			else
				sThisFormat = T("|Massgroup| ")+"@(Handle:D)";			
		}

		else
			sThisFormat = "@(TypeName)";
			
		return sThisFormat;
	}//endregion

//region Function SetReadDirection
	// returns the reading vector and modifies the read coordSys
	Vector3d SetReadDirection(Quader qdr, String direction, Vector3d& vecX, Vector3d& vecY, Vector3d& vecZ)
	{ 
	// validate quader	
		Vector3d vecQdr = qdr.pointAt(1, 1, 1) - qdr.pointAt(-1, - 1 ,- 1);	
		if (!vecQdr.bIsZeroLength())//
		{ 	
			if (direction==tAlignedX || direction==tAlignedY)
			{ 
				if (!qdr.vecX().isParallelTo(_ZU))
					vecX = direction==tAlignedX?qdr.vecX():qdr.vecY();		
				else
					vecX = direction==tAlignedX?qdr.vecD(vecX):qdr.vecD(vecY);			
			}	
		}
		if(vecX.isCodirectionalTo(-_YU) || vecX.dotProduct(_XU)<-1e-5)
			vecX *= -1;
		vecY = vecX.crossProduct(-_ZU);		vecY.normalize();
		vecZ = vecY.crossProduct(vecY);
		if (vecZ.isParallelTo(_ZW) && vecX.dotProduct(_XW)<0)
		{ 
			vecX *= -1;
			vecY*= -1;
		}

		Vector3d vecRead = - vecX + 3 * vecY;	vecRead.normalize();		
		
		return vecRead;
	}//endregion

	//endregion 

//endregion 

//region Part #2

//region JIG
	int nc = -1;
	Display dpJig(-1),dpWhite(-1), dp(nc);
	dpWhite.showInDxa(true);
	dpWhite.showDuringSnap(false);
	dp.showInDxa(true);
	dp.showDuringSnap(false);

//region Jig Insert
	String kJigInsert = "JigInsert";
	if (_bOnJig && _kExecuteKey==kJigInsert) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
		
		int x = - 1;
	    PlaneProfile pp = _Map.getPlaneProfile("pp");
	    PLine pl = _Map.getPLine("pl");
	    
	    PlaneProfile pps[0];
	    PLine plines[0];

		Vector3d vecXRead=_Map.getVector3d("vecXRead");
		Vector3d vecYRead=_Map.getVector3d("vecYRead");
		String dimStyle=_Map.getString("dimStyle");
		double textHeight=_Map.getDouble("textHeight");
		String text=_Map.getString("text");
		int flagX=_Map.getInt("flagX");
		int flagY=_Map.getInt("flagY");

	    CoordSys cs (ptJig, _XU, _YU, _ZU);
	    if (pp.area()>pow(dEps,2))
	    {
	    	cs = pp.coordSys();
	    	pps.append(pp);
	    	x = 0;
	    }
	    else if (pl.length()>dEps)
	    {
	    	cs = pl.coordSys();
	    	plines.append(pl);
	    	x = 1;
	    }

	    ptJig.setZ(cs.ptOrg().Z());
    
	    PLine plGuide;
	    plGuide.addVertex(ptJig); 
	    PLine plGuide2 = plGuide;
	    
	    if (x==0)
	    	plGuide.addVertex(pp.closestPointTo(ptJig)); 
	    else if (x==1)
	    	plGuide.addVertex(pl.closestPointTo(ptJig));     
	   
		if (_Map.hasPlaneProfile("ppv"))
		{
			PlaneProfile ppv = _Map.getPlaneProfile("ppv");
			pps.append(ppv);
			plGuide2.addVertex(ppv.closestPointTo(ptJig)); 
		}
		else if (_Map.hasPLine("plv"))
		{
			PLine plv = _Map.getPLine("plv");
			plines.append(plv);	
			plGuide2.addVertex(plv.closestPointTo(ptJig)); 
		}
	   

	    dpJig.trueColor(darkyellow);
	    
	    
	    dpJig.dimStyle(dimStyle);
	    dpJig.textHeight(textHeight);

		dpJig.draw(plGuide);

		if (plGuide2.length()>0)
	    {
	    	dpJig.trueColor(lightblue);
	    	dpJig.draw(plGuide2);
	    }

	    for (int i=0;i<pps.length();i++)
	    { 
	    	dpJig.trueColor(i==0?darkyellow:lightblue, 80);
	    	dpJig.draw(pps[i], _kDrawFilled);
	    }
	    for (int i=0;i<plines.length();i++)
	    { 
	    	dpJig.trueColor(i==0?darkyellow:lightblue);
	    	dpJig.draw(plines[i]);
	    }	    

		dpJig.trueColor(darkyellow,0);
	    dpJig.draw(text, ptJig+_ZU*U(50), vecXRead, vecYRead, flagX, flagY);
	    
	    return;
	}//endregion 
	
// Viewport
	String kJigViewport = "JigViewport";
	if (_bOnJig && _kExecuteKey==kJigViewport) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
		
	    PlaneProfile pps[0];
	    for (int i=0;i<_Map.length();i++) 
	    	if (_Map.hasPlaneProfile(i))
	    		pps.append(_Map.getPlaneProfile(i));
		if (pps.length()>0)
			ptJig.setZ(pps[0].coordSys().ptOrg().Z());

	    
	    Display dp(-1);
	    dp.trueColor(lightblue, 50);

	    double dMin = U(10e6);
	    int n;
	    for (int i=0;i<pps.length();i++) 
	    { 
	    	double d = (pps[i].closestPointTo(ptJig)-ptJig).length();
	    	if (d<dMin)
	    	{ 
	    		dMin = d;
	    		n = i;
	    	}	    	 
	    }//next i
	    for (int i=0;i<pps.length();i++)
	    { 
	    	dp.trueColor(n==i?darkyellow:lightblue, n==i?0:50);
	    	dp.draw(pps[i], _kDrawFilled);
	    }  
	    return;
	}	
	
//endregion 

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1)
		{
			setOPMKey("SetDisplay");
			
			
			String sZoneName = T("|Zone|");
			
			Map mapZones = _Map.getMap("Zone[]");
			int nZones[0];
			for (int i=0;i<mapZones.length();i++) 
			{ 
				int zone =mapZones.getInt(i);
				nZones.append(zone);
				 
			}//next i
			int nReadOnly;
			if (nZones.length()<1)
			{
				nZones.append(0);
				nReadOnly = _kHidden;
			}
			
			
			PropInt nZone(nIntIndex++, nZones, sZoneName);
			nZone.setDescription(T("|Defines the Zone|"));
			nZone.setCategory(category);
			nZone.setReadOnly(nReadOnly);
			
			String sDrawOutlineName = T("|Draw Outline|");
			PropString sDrawOutline(nStringIndex++, sNoYes, sDrawOutlineName);
			sDrawOutline.setDescription(T("|Defines if the outline will be drawn|"));
			sDrawOutline.setCategory(category);
			
			category = T("|Display|");
			String sColorName = T("|Color|");
			PropInt nColor(nIntIndex++, 0, sColorName);
			nColor.setDescription(T("|Defines the Color|"));
			nColor.setCategory(category);
			
			String sTransparencyName = T("|Transparency|");
			PropInt nTransparency(nIntIndex++, 0, sTransparencyName);
			nTransparency.setDescription(T("|Defines the Transparency|"));
			nTransparency.setCategory(category);
			
			String sFillColorName = T("|Fill Color|");
			PropInt nFillColor(nIntIndex++, 0, sColorName);
			nFillColor.setDescription(T("|Defines the fill color if transparency is in the range 0 < value < 100|"));
			nFillColor.setCategory(category);
		}

		return;		
	}
//End DialogMode//endregion

//region Grouping
	String sGroupings[] = { tDefaultEntry, tNoGroupAssignment};
	
	// custom grouping HSB-18776
	{ 
		String parentGroup = "07 BEMASSUNG & BESCHRIFTUNG".makeUpper();//
		if (Group(parentGroup).bExists())
		{ 
			Group groups[] = Group().allExistingGroups();
			for (int i=0;i<groups.length();i++) 
			{ 
				String s1 = groups[i].namePart(0); 
				String s2 = groups[i].namePart(1);
				String s3 = s1+"\\"+s2;
				s1.makeUpper();
				if (s1==parentGroup && s2.length()>0)
					sGroupings.append(s3);		
			}//next i			
		}
	}	
	
	
//endregion 

//region Determine mode and space

	// determine the current space
	int bInLayoutTab = Viewport().inLayoutTab();
	int bInPaperSpace = Viewport().inPaperSpace();
	int bInBlockSpace = (getVarInt("BLOCKEDITOR") == 1) || (getVarString("REFEDITNAME") != "");
	int bHasSDV,nMode = _Map.getInt("mode");

	ShopDrawView sdvs[0];
	MultiPage pages[0];
	if (_bOnInsert)
	{
	// find out if we are block space and have some shopdraw viewports
		if (!bInLayoutTab)
		{
			Entity ents[0]; // empty = search with group.collectEnts
			sdvs = CollectShopdrawViews(ents);
			pages = CollectMultipages(ents);
	
			// shopdraw viewports found and no genbeams or multipages are found
			if (sdvs.length() > 0)
				bHasSDV = true;
		}
	}
	else
	{ 
		sdvs = CollectShopdrawViews(_Entity);
		pages = CollectMultipages(_Entity);
	}
//endregion 

//region Properties #1
	String sFormatName=T("|Format|");	
	PropString sFormat(0, "", sFormatName);	
	sFormat.setDescription(T("|Defines format expression to be displayed|"));
	sFormat.setCategory(category);

category = T("|Reference|");
	String sAllowNestedName=T("|Allow selection in XRef|");	
	PropString sAllowNested(8, sNoYes, sAllowNestedName,0);	
	sAllowNested.setDescription(T("|Defines whether the selection of entities also allows entities within block references or XRefs|"));
	sAllowNested.setCategory(category);	
	// legacy
	{ 
		String tXrefNested = T("|Entities inside Reference|"), tXref =T("|XRef/Block|") ;
		if (sAllowNested==tXref) sAllowNested.set(tNo);	
		else if (sAllowNested==tXrefNested) sAllowNested.set(tYes);		
		else if (sNoYes.findNoCase(sAllowNested ,- 1) < 0) sAllowNested.set(tNo);			
	}
	int bAllowNested = sAllowNested == tYes;
	
	String sAllPainters[] = PainterDefinition().getAllEntryNames().sorted();
	String tFilterShowSet=T("<|Visible Set of Entities|>"), tFilterDefineSet = T("|Defining Entity|");
	String sPainterFilters[] = { tDefaultEntry};//tFilterShowSet, tFilterDefineSet;

	// Append showset if shopdraw type	
	if (sdvs.length()>0 || pages.length()>0 )
		sPainterFilters.append(tFilterShowSet);
	
	// append painter definitions
	for (int i=0;i<sPainterFilters.length();i++) 
	{ 
		int n = sAllPainters.findNoCase(sPainterFilters[i] ,- 1);
		if (n>-1)
		{
			reportMessage(TN("|Painter with reserved filter name ignored|: ") + sPainterFilters[i]);
			sAllPainters.removeAt(n);
		}	 
	}//next i
	sPainterFilters.append(sAllPainters);		

	String sPainterFilterName=T("|Filter|");	
	PropString sPainterFilter(6, sPainterFilters, sPainterFilterName);	
	sPainterFilter.setDescription(T("|Defines a filter for object references.| ") + 
		T("|This can be a painter definition (default = selected object).| ") + 
		TN("|In the context of shopdrawings, the definition object (default), all visible entities ('Showset'), or the filter result of a painter definition from the 'ShowSet' is used.| ")+
		TN("|For each filtered object, an instance is created in the model.|"));
	sPainterFilter.setCategory(category);
	sPainterFilter.setControlsOtherProperties(true);


	String sGroupAssignmentName=T("|Group Assignment|");	
	PropString sGroupAssignment(9, sGroupings, sGroupAssignmentName);	
	sGroupAssignment.setDescription(T("|Defines to layer to assign the instance|, ") + tDefaultEntry + T(" = |byEntity|"));
	sGroupAssignment.setCategory(category);

	String sEqualityFormatName=T("|Equal Parts Format|");	
	PropString sEqualityFormat(7, "", sEqualityFormatName);	
	sEqualityFormat.setDescription(T("|Sets the rules for evaluating property equality to include items in the count.|"));
	sEqualityFormat.setCategory(category);
	//sEqualityFormat.setReadOnly(bDebug?false:_kHidden); // only available for certain types

// Alignment
category = T("|Alignment|");
	String sDirections[] = { tHorizontal, tVertical, tAlignedX, tAlignedY};
	String sDirectionName=T("|Direction|");	
	PropString sDirection(2, sDirections, sDirectionName);	
	sDirection.setDescription(T("|Defines the direction of the tag|"));
	sDirection.setCategory(category);
	
	String tTopLeft= T("|Top-Left|"), tTopCenter = T("|Top-Center|"), tTopRight = T("|Top-Right|"),
		tMidLeft = T("|Mid-Left|"), tMidCenter = T("|Mid-Center|"), tMidRight = T("|Mid-Right|"),
		tBottomLeft = T("|Bottom-Left|"), tBottomCenter = T("|Bottom-Center|"), tBottomRight = T("|Bottom-Right|");
	String sAlignments[] ={ tTopLeft, tTopCenter, tTopRight, tMidLeft, tMidCenter, tMidRight, tBottomLeft, tBottomCenter, tBottomRight};
	String sAlignmentName=T("|Alignment|");	
	PropString sAlignment(5, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the Alignment|"));
	sAlignment.setCategory(category);
	
	String tPDefault = T("<|Default|>"), tPOutside = T("|Outside Range|"), sPlacements[] = {tPDefault,tPOutside };
	String sPlacementName=T("|Placement|");	
	PropString sPlacement(11, sPlacements, sPlacementName);	
	sPlacement.setDescription(T("|This property defines how the tag is positioned in relation to the selected object.|") +
		"\n"+tPDefault + ": " +T("|In the geometric center|")+
		"\n"+tPOutside + ": " + T("|Outside the display area of the selected object.|"));
	sPlacement.setCategory(category);
	if (sPlacements.findNoCase(sPlacement ,- 1) < 0)sPlacement.set(tPDefault);

// Display
category=T("|Display|");

	String sStyles[] = { tSText,tSBox,tSRevision,tSTriangle};
	String sStyleName=T("|Style|");	
	PropString sStyle(3, sStyles, sStyleName,1);	
	sStyle.setDescription(T("|Defines the Style|"));
	sStyle.setCategory(category);
	if (sStyles.findNoCase(sStyle ,- 1) < 0)sStyle.set(tSText);

//region Function GetGroupedDimstyles
	// returns 2 arrays of same length (translated and source) of dimstyles which match the filter criteria
	// type: 0 = linear, 1 = undefined, 2 = angular, 3= diameter, 4 = Radial, 6 = coordinates, 7= leader and tolerances
	String[] GetGroupedDimstyles(int type, String& dimStyles[])
	{ 
		String dimStylesUI[0];
		dimStyles.setLength(0);

	// some types are not supported, fall back to linear
		if (type<0 || type>4)
			type = 0;

	// append potential linear overrides	
		String sOverrides[0];
		for (int i=0;i<_DimStyles.length();i++) 
		{ 
			String dimStyle = _DimStyles[i]; 
			int n = dimStyle.find("$"+type, 0, false);	// indicating it is an override of the dimstyle
			if (n>-1 && dimStyles.find(dimStyle,-1)<0)
			{
				dimStylesUI.append(dimStyle.left(n)); // trim the appendix
				dimStyles.append(dimStyle);
			}
		}//next i

	// append all non overrides	
		for (int i = 0; i < _DimStyles.length(); i++)
		{
			String dimStyle = _DimStyles[i]; 
			int n = dimStyle.find("$", 0, false);	// <0 it is not any override of a dimstyle

			if (n<0 && dimStyles.findNoCase(dimStyle)<0 && dimStylesUI.findNoCase(dimStyle)<0) // do not append any parent of a grouped one
			{ 
				dimStylesUI.append(dimStyle);
				dimStyles.append(dimStyle);				
			}
		}
	
	// nothing found
		if (dimStylesUI.length()<1)
		{ 
			dimStylesUI = _DimStyles;
			dimStyles = _DimStyles;	
		}

	// order alphabetically
		for (int i=0;i<dimStylesUI.length();i++) 
			for (int j=0;j<dimStylesUI.length()-1;j++) 
				if (dimStylesUI[j]>dimStylesUI[j+1])
				{
					dimStylesUI.swap(j, j + 1);
					dimStyles.swap(j, j + 1);
				}
		
		return dimStylesUI;
	}//endregion

	String sDimStyles[] = _DimStyles, sDimStylesUI[] = GetGroupedDimstyles(0, sDimStyles); // type: 0 = linear, 1 = undefined, 2 = angular, 3= diameter, 4 = Radial, 6 = coordinates, 7= leader and tolerances
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyleUI(1, sDimStylesUI, sDimStyleName);	
	sDimStyleUI.setDescription(T("|Defines the dimension style.|"));
	sDimStyleUI.setCategory(category);
	if (sDimStylesUI.length()>0 && sDimStylesUI.findNoCase(sDimStyleUI ,- 1) < 0)sDimStyleUI.set(sDimStylesUI.first());	
	String sDimStyle = sDimStyles[sDimStylesUI.findNoCase(sDimStyleUI, 0)];

	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the text height, 0 = byDimstyle|"));
	dTextHeight.setCategory(category);
	double textHeight;if (dTextHeight>0)textHeight=dTextHeight;else{ Display dp(0); textHeight=dp.textHeightForStyle("G", sDimStyle);}
	
	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, 0, sColorName);	
	nColor.setDescription(T("|Defines the Color|")+ " " + T("|(0 = by Instance, -1 = by Entity)|") +
		TN("|The color can also be defined by the quality of a surface quality style of a panel. In order to map certain colors set the color to - 1 and create an alias definition named 'SQ' mapping each quality with a color.|"));
	nColor.setCategory(category);	

	String sTransparencyName = T("|Transparency|");
	PropInt nTransparency(nIntIndex++, 0, sTransparencyName);
	nTransparency.setDescription(T("|Defines the Transparency of the background|") + 
		TN("|A value between 1 and 99 fills the background of the tag with the specified transparency using white.|") +
		TN("|AA value between -1 and -99 fills the background with the specified transparency using the selected text color.|"));
	nTransparency.setCategory(category);


	String sLineTypes[0]; sLineTypes=_LineTypes.sorted();
	sLineTypes.insertAt(0, tDisabled);
	String sLeaderLineTypeName=T("|Leader Linetype|");	
	PropString sLeaderLineType(4, sLineTypes, sLeaderLineTypeName, sLineTypes.length()>1?1:0);	
	sLeaderLineType.setDescription(T("|Defines the linetype of the leader or not to show any leader.|"));
	sLeaderLineType.setCategory(category);	
	//if (!_bOnInsert)
	sLeaderLineType.setControlsOtherProperties(true);
	
	if (sLineTypes.find(sLeaderLineType,-1)<0) // auto correct upper/lower case
	{
		int n = sLineTypes.findNoCase(sLeaderLineType ,- 1);
		if (n>-1)
			sLeaderLineType.set(sLineTypes[n]);		
		else
			sLeaderLineType.set(tDisabled);
	}

	String tLSStraight= T("|Straight|"), tLSLeader= T("|Leader|"), tLSArrow= T("|Arrow|"), tLSDot= T("|Dot|"), tLSMulti= T("|Multi Straight|"),tLSLeaderMulti= T("|Multi Leader|"), tLSArrowMulti= T("|Multi Arrow|"), tLSDotMulti= T("|Multi Dot|");
	String sLeaderStyles[] ={tDisabled, tLSStraight, tLSLeader, tLSArrow, tLSDot,tLSMulti,tLSLeaderMulti,tLSArrowMulti,tLSDotMulti};
	String sLeaderStyleName=T("|Leader Style|");	
	PropString sLeaderStyle(10, sLeaderStyles, sLeaderStyleName);	
	sLeaderStyle.setDescription(T("|Defines the LeaderStyle|"));
	sLeaderStyle.setCategory(category);
	sLeaderStyle.setControlsOtherProperties(true);
	
	
	
//region Function setProperties
	// sets the readOnlyFlags
	void setProperties()
	{ 		
		
	// store last used leader style and linetype
		if (sLeaderLineType!=tDisabled)_Map.setString("lineType", sLeaderLineType); // store the last leader linetype
		if (sLeaderStyle!=tDisabled)_Map.setString("leaderStyle", sLeaderStyle); // store the last leader style
		
	// toggle linetype and leader style simulatenously
		if (_kNameLastChangedProp == sLeaderLineTypeName)
			 sLeaderStyle.set( sLeaderLineType == tDisabled?tDisabled: (_Map.hasString("leaderStyle")?_Map.getString("leaderStyle"):tLSStraight));
		if (_kNameLastChangedProp == sLeaderStyleName)
			sLeaderLineType.set(sLeaderStyle == tDisabled ? tDisabled: (_Map.hasString("lineType")?_Map.getString("lineType"):sLineTypes.last()));
	
		if (sLeaderLineType.find(sLeaderLineType ,- 1) < 0) 
			sLeaderLineType.set(tDisabled);
		if (sLeaderStyles.find(sLeaderStyle ,- 1) < 0) 
			sLeaderStyle.set(sLeaderLineType == tDisabled?tDisabled:tLSStraight);

		sLeaderLineType.setReadOnly(sLeaderStyle==tDisabled && !_bOnInsert?_kHidden:false);		

		if (dTextHeight>0)
			textHeight=dTextHeight;
		else{ Display dp(0); textHeight=dp.textHeightForStyle("G", sDimStyle);}
		
		if (_bOnInsert && !bInBlockSpace)
		{ 
		// show xref property	
			Entity entBrefs[]= Group().collectEntities(true, BlockRef(), _kModelSpace);
			AcadDatabase dbs[] = _kCurrentDatabase.xrefDatabases();
			if (!bInBlockSpace && (dbs.length()>0 || entBrefs.length()>0))
			{
				sAllowNested.setReadOnly(false);
				//sXRefMode.setReadOnly(false);
			}
		}
		else	
			sAllowNested.setReadOnly(bDebug?false:_kHidden);
		bAllowNested = sAllowNested == tYes;	
	
	// Filter
		if (sPainterFilter == tFilterDefineSet || sPainterFilters.findNoCase(sPainterFilter,-1)<0)
			sPainterFilter.set(tDefaultEntry);// HSB-22779 legacy: tFilterDefineSet = T("|Defining Entity|") is now considered as tDefault
		
		// HSB-24506
		sPainterFilter.setReadOnly(bDebug || _bOnInsert ||sdvs.length()>0 || pages.length()>0?false:_kHidden);
		sEqualityFormat.setReadOnly(bDebug || _bOnInsert ||sdvs.length()>0 || pages.length()>0?false:_kHidden);
	
	// Placement	
		int bShowPlacement = bDebug || ((_bOnInsert || sdvs.length()>0) && sPainterFilter!=tDefaultEntry);
		sPlacement.setReadOnly(bShowPlacement?false:_kHidden);
		
		return;
	}//endregion	

	
//End Properties//endregion 

//region bOnInsert #1
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
	
	//region Dialog
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
		{
			setPropValuesFromCatalog(_kExecuteKey);	
			setProperties();
		}
	// standard dialog	
		else	
		{
			setPropValuesFromCatalog(tLastInserted);
			setProperties();
			while (showDialog("---") == _kUpdate) // _kUpdate means a controlling property changed.	
			{ 
				setProperties(); // need to set hidden state
			}						
		}	
	//endregion 		
		
	//region Prompt for entities
		int bAllowNested = sAllowNested==tYes;//sXRefMode == tXrefNested;
		Entity ents[0];
		PrEntity ssE;
		if (bInBlockSpace)
		{ 
			ssE = PrEntity(T("|Select shopdraw viewports|"), ShopDrawView());
			nMode = 5;
		}
		else if (bHasSDV)
		{ 
			ssE = PrEntity(T("|Select references (multipages or model entities|"), ShopDrawView());
			ssE.addAllowedClass(Entity());
			nMode = 5;
			
		}		
		else
		{
			ssE = PrEntity(T("|Select entities|"), Entity());	
			ssE.allowNested(bAllowNested);
		}

		if (ssE.go())
			ents.append(ssE.set());
	//endregion 


	//region ShopDrawView Selection
		sdvs = CollectShopdrawViews(ents);
		if (sdvs.length()>0)
		{ 
		// Prerquisites TSL creation
			TslInst tslNew;				
			Map mapTsl;
			mapTsl.setInt("mode",5);
			int bForceModelSpace = true;	
			String sExecuteKey,sCatalogName = tLastInserted;
			String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
			GenBeam gbsTsl[] = {};				

		// clone per sdv
			for (int i=0;i<sdvs.length();i++) 
			{ 
				ShopDrawView& sdv = sdvs[i]; 
				Entity entsTsl[] = {sdv};	
				Point3d ptsTsl[] = {sdv.coordSys().ptOrg()};
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent);

			}//next i

			eraseInstance();
			return;
		}//end ShopDrawView Selection //endregion 

		
	// Remove entities of hsbEntityTag
		if (nMode!=5)
		{ 
			for (int i=ents.length()-1; i>=0 ; i--) 
			{ 
				int bErase;
				TslInst t=(TslInst)ents[i]; 
				BlockRef bref=(BlockRef)ents[i]; 
				if (t.bIsValid() && t.scriptName()==scriptName())
					bErase = true;
				else if (!bref.bIsValid())
				{ 
					Quader q = ents[i].bodyExtents();		
					if (ents[i].getPLine().length()<dEps && (q.pointAt(1,1,1)-q.pointAt(-1,-1,-1)).bIsZeroLength())
						bErase = true;			
				}
					
				if(bErase)
				{
					ents.removeAt(i);
				}	
			}//next i			
		}

		PainterDefinition pd(sPainterFilter);


	//region Section based Creation
	// accept a set of sections to autocreate instances of the included set
	// other entities within the selection set are accepted as well
		
	// Collect sections in selection set
		Section2d sections[0];
		pages = CollectMultipages(ents);
		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
			Section2d section = (Section2d)ents[i];
			if (section.bIsValid())
			{ 		
			// create TSL
				TslInst tslNew;
				GenBeam gbsTsl[] = { };		
				Entity entsTsl[] ={ section}; 
				Point3d ptsTsl[] = {section.coordSys().ptOrg()};
				int nProps[]={nColor,nTransparency};
				double dProps[]={dTextHeight};
				String sProps[]={sFormat,sDimStyle,sDirection,sStyle,sLeaderLineType,sAlignment,sPainterFilter, sEqualityFormat,sAllowNested,sGroupAssignment,sLeaderStyle, sPlacement};
				Map mapTsl;				
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);				
				
				sections.append(section);
				ents.removeAt(i);
			}	
		}//next i	
	//endregion 


		if (pd.bIsValid())
		{ 
			_Entity.append(pd.filterAcceptedEntities(ents));
			AppendMultipage2Entities(_Entity, pages);			
		}
		else
			_Entity = ents;
		
		if (_Entity.length()<1)
		{ 
			if (sections.length()<1)
			{
				String msg;
				if (sPainterFilter!=tDisabled)
					msg = T("|The selection set does not contain any items which match the filter|:\n    ") + sPainterFilter;
				else
					msg=T("|No valid entities found in selection set|");				
				
				msg += TN("\n|Make sure the correct items are selected, and change the filter if the desired data isn't visible.|");
				
				Map mapIn;
				mapIn.setString("Title", T("hsbEntityTag: |Invalid input|"));
				mapIn.setString("Notice", msg);
				Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, "ShowNotice", mapIn);
			}
			eraseInstance();
			return;
		}
		
		if (!_ZU.isParallelTo(vecZView))
		{ 
			reportNotice("\n*** " + scriptName() + " ***" + 
			TN("|The current view direction is parallel to the current Z-Axis of the UCS.|") + 
			TN("|The instance will only be visible in the view direction of the Z-Axis of the UCS at time of insertion.|"));
		}
		
		//reportNotice("\nOnInsert #1 has entities "+ _Entity.length() + " in nMode " + nMode);//XX
	}
	setProperties();
//endregion 

//end Part #2 //endregion 

//region Part #3: collect entity type and data
	
//region Get show and define set
	
	if (_bOnDbCreated)setExecutionLoops(2);
	int bIsBlockCreationMode = _Map.getInt(kBlockCreationMode);
	if (_Entity.length()<1 && bIsBlockCreationMode) 
	{ 
		if (bDebug)		reportNotice("\nbIsBlockCreationMode no entity yet");
		return;
	}
	else if (_Entity.length()>0 && _Map.hasInt(kBlockCreationMode)) 
	{
		if (bDebug)reportNotice("\nbIsBlockCreationMode entity found " + _ThisInst.handle() + " " + _Entity[0].handle());
	
	}

	String sBlockName;
	int bIsBlock;
	Entity defineSet[0],showSet[0],entDefine;
	if (_Entity.length()>0)
	{
		entDefine= _Entity[0];
		
		if (_Map.getInt("isPageDependant") && !entDefine.bIsKindOf(MultiPage())) // autopurge if multipage has been deleted
		{ 
			//reportNotice("\nauto purge isPageDependant " );//XX
			eraseInstance();
			return;
		}
		
	}
	else if (_BlockNames.findNoCase(_Map.getString("BlockName"))>-1)
	{ 
		sBlockName =_Map.getString("BlockName") ;// has a valid block name instead
		bIsBlock = true;
		sFormat.set(_Map.hasString("Text")?_Map.getString("Text"):sBlockName);
	}
	else if (!_bOnInsert)
	{
		eraseInstance();
		return;
	}			
//END showset //endregion 

//region CoordSys and alignment
	addRecalcTrigger(_kGripPointDrag, "_Pt0");
	int bDrag = _bOnGripPointDrag && _kExecuteKey == "_Pt0";
	
	CoordSys ms2ps, ps2ms,cs;
	double scale = 1;		
	Point3d ptRef = _Pt0;

	Map mapAdditional;

	Vector3d vecX = _XU;
	Vector3d vecY = _YU;
	Vector3d vecZ = _ZU;	
	Vector3d vecXRead = vecX;
	Vector3d vecYRead = vecY;
	

	Body bd;
	Quader qdr;	
	int flagX, flagY;
	int nAlignment = sAlignments.findNoCase(sAlignment);
	int bPlaceOutside = sPlacement == tPOutside; // flag to force locaton outside of visible range

	// vertical
	if (nAlignment >= 0 && nAlignment < 3)flagY = -1;
	else if (nAlignment >= 3 && nAlignment < 6)flagY = 0;
	else if (nAlignment >= 5 && nAlignment < 9)flagY = 1;
	
	//horizontal
	if (nAlignment ==0 || nAlignment==3 || nAlignment==6)flagX = 1;
	else if (nAlignment ==1 || nAlignment==4 || nAlignment==7)flagX = 0;
	else if (nAlignment ==2 || nAlignment==5 || nAlignment==8)flagX = -1;		
	
	// vertical Direction
	if (sDirection == tVertical)// vertical
	{ 
		vecXRead = vecY;
		vecYRead = -vecX;
	}		
//endregion 	

//region Display	
	dpWhite.trueColor(rgb(255, 255, 254));
	dp.showInDxa(true);	
	
	if (!bDebug)
	{ 
		dp.addViewDirection(_ZU);
		dp.addViewDirection(-_ZU);
	
		dpWhite.addViewDirection(_ZU);
		dpWhite.addViewDirection(-_ZU);		
	}

	dp.trueColor(grey);
	dp.dimStyle(sDimStyle);
//	double textHeight = dTextHeight;
	if (textHeight<=0)
		textHeight = dp.textHeightForStyle("O", sDimStyle);
	else
		dp.textHeight(textHeight);	
		
		
	Map mapParams;
	mapParams.setVector3d("vecXRead", vecXRead);
	mapParams.setVector3d("vecYRead", vecYRead);
	mapParams.setVector3d("vecZ", vecZ);
	mapParams.setString("dimStyle",sDimStyle);
	mapParams.setDouble("textHeight", textHeight);	
	mapParams.setInt("flagX", flagX);
	mapParams.setInt("flagY", flagY);		
	mapParams.setString("style", sStyle);
	
//	mapParams.setString("text", text);
//	mapParams.setDouble("dX",dX);
//	mapParams.setDouble("dY",dY);		
		
		
		
		
		
//endregion 

//region Shopdrawings: Multipage or Shopdrawview

//region MultiPage #MP
	MultiPage page = (MultiPage)entDefine;
	PlaneProfile ppViewports[0];
	
	int nIndexView = _Map.hasInt(kIndexView)?_Map.getInt(kIndexView):-1;
	
	MultiPageView mpvs[0], mpv;
	Vector3d vecAllowedView = _Map.getVector3d(kAllowedView);
	int bHasPage;
	
	if (page.bIsValid())
	{
	// keep relative location to multipage 
		Point3d ptOrg = page.coordSys().ptOrg();
		if (_Map.hasVector3d("vecOrg") && _kNameLastChangedProp!="_Pt0")// && !_bOnDbCreated)
		{
			_Pt0 = ptOrg + _Map.getVector3d("vecOrg");	
			_Pt0.setZ(0);
			ptRef = _Pt0; // HSB-18681 
		}

	// get show and define set	
		defineSet= page.defineSet();	
		showSet= page.showSet();	
		if (defineSet.length()<1 && showSet.length()<1)
		{
			reportMessage("\n"+ scriptName() + T("|no define set found|"));
			eraseInstance();
			return;
		}
		
	// make it dependent from the multipage	
		setDependencyOnEntity(page);
		_Map.setInt("isPageDependant", true); // add a flag to autoerase the instance if page is purged
//	// add dependency to referenced entity	
//		{ 
//			Entity e = defineSet.first();
//			_Entity.append(e);
//			setDependencyOnEntity(e);
//		}

	
	// Get views
		mpvs = page.views();
		if (mpvs.length()<1)
		{ 
			reportMessage("\n"+ scriptName() + T("|Invalid multipage with no views| ")+T("|Tool will be deleted.|"));
			eraseInstance();
			return;
		}
		bHasPage = true;
		
	//region OnInsert of multipage mode
		if (_bOnInsert)
		{ 
		//region Collect all viewport profiles and the associated multipage view
			Map mapArgs;
			PlaneProfile ppVPs[0];
			MultiPageView mpvs[] = page.views();
			for (int j=0;j<mpvs.length();j++) 
			{ 
				MultiPageView& mpv = mpvs[j];				
//				ms2ps = mpv.modelToView();
//				ps2ms = ms2ps;
//				ps2ms.invert();						

				PlaneProfile pp(cs);
				pp.joinRing(mpv.plShape(), _kAdd);
				
				ppVPs.append(pp);
				mapArgs.appendPlaneProfile("pp", pp);
			}//next j			
		//endregion	
		
		//region Select a viewport of the multipage
			if (ppVPs.length() >1)
			{
				Point3d pt;
				
				PrPoint ssP(T("|Select viewport|")); //second argument will set _PtBase in map
				ssP.setSnapMode(TRUE, 0); // turn off all snaps
				int nGoJig = - 1;
				while (nGoJig != _kOk && nGoJig != _kNone)
				{
					nGoJig = ssP.goJig(kJigViewport, mapArgs);
					if (nGoJig == _kOk)
					{
						pt = ssP.value(); //retrieve the selected point
						pt.setZ(0);
						
						// get the inde of the closest viewport
						double dMin = U(10e6);
						
						for (int i = 0; i < ppVPs.length(); i++)
						{
							double d = (ppVPs[i].closestPointTo(pt) - pt).length();
							if (d < dMin)
							{
								dMin = d;

								MultiPageView view = mpvs[i];
								ms2ps = view.modelToView();
								ps2ms = ms2ps;
								ps2ms.invert();
							}
						}//next i
					}
					else if (nGoJig == _kCancel)
					{
						eraseInstance(); //do not insert this instance
						return;
					}
				}
				ssP.setSnapMode(false,0); // turn off all snaps
			}
		//endregion 		
		
		// store model view	
			vecAllowedView = _ZW;
			vecAllowedView.transformBy(ps2ms);
			vecAllowedView.normalize();
			_Map.setVector3d(kAllowedView, vecAllowedView);	
			//_Pt0 += _ZW * _ZW.dotProduct(ptOrg - _Pt0);		
		}//End OnInsert of multipage mode //endregion 	

		
	// Collect bounds of viewports and distinguish selected if has been set
		// reset view index if invalid
		if (nIndexView>-1 && nIndexView>mpvs.length())
		{ 
			_Map.removeAt(kIndexView, true);
			nIndexView = -1;
		}
		for (int i=0;i<mpvs.length();i++) 
		{ 
			mpv = mpvs[i];
			PlaneProfile pp(cs);
			pp.joinRing(mpv.plShape(), _kAdd);	//pp.extentInDir(_XW).vis(i);
			ppViewports.append(pp);
			
			ms2ps = mpv.modelToView();
			ps2ms = ms2ps;	
			ps2ms.invert();

			if (!vecAllowedView.bIsZeroLength() && ps2ms.vecZ().isParallelTo(vecAllowedView))
			{	
				nIndexView = i;	
				//reportMessage(("\nView ") + nIndexView + " detected " + vecAllowedView);				
				break;					
			}
		}		

	// Select closest if nothing selected	
		if (nIndexView<0)
		{ 
			double dist = U(10e5);
			for (int i=0;i<ppViewports.length();i++) 
			{ 
				//ppViewports[i].extentInDir(_XW).vis(i);
				double d = Vector3d(ppViewports[i].extentInDir(_XW).ptMid() - _Pt0).length();
				if (d<dist)
				{ 
					nIndexView = i;
					dist = d;
				}				 
			}//next i
			if (!_Map.hasInt(kIndexView))
			{
				_Map.setInt(kIndexView, nIndexView);
			}
		}

		if (nIndexView <0)
		{
			reportMessage("\n"+ scriptName() + T("|Unexpected error| ")+T("|Tool will be deleted.|"));
			eraseInstance();
			return;
		}
		
		
		mpv = mpvs[nIndexView];
		scale = mpv.viewScale();
		ms2ps = mpv.modelToView();
		ps2ms = ms2ps;	
		ps2ms.invert();
			
		Entity fullShowSet[] = mpv.showSet();
		showSet = fullShowSet;	
		PainterDefinition pd(sPainterFilter);
		if(pd.bIsValid())	
		{
			showSet = pd.filterAcceptedEntities(showSet);	
		// on insert tag the instance to be in distribution mode
			if ((_bOnInsert || bIsBlockCreationMode) && showSet.length()>1)
				_Map.setInt("DistributionMode", true);
		}
		else if (sPainterFilter == tFilterShowSet)
		{ 
		// on insert tag the instance to be in distribution mode
			if ((_bOnInsert || bIsBlockCreationMode) && showSet.length()>1)
				_Map.setInt("DistributionMode", true);			
		}
		// use define set if no painter selected
		else if (defineSet.length()==1 && showSet.length()>0)
		{
			showSet = defineSet;
		}

	//region Distribute instances based on the showSet //#PA Distribution
		if (_Map.getInt("DistributionMode"))//|| bDebug  )// || bDebug)// 
		{ 
			if (bDebug){Display dpxs(1); dpxs.textHeight(U(100));dpxs.draw(scriptName(),_Pt0, _XW,_YW,1,0,_kDevice);}
			
			//reportNotice("\nrunning distribution..."  );
			double blowUp = textHeight * 5;

		// Cache bodies
			Body bodies[0];
			String handles[0];
			for (int i=0;i<fullShowSet.length();i++) 
			{ 
				Body bd;
				if (GetSimpleBody(fullShowSet[i], bd))
				{
					bodies.append(bd); 
					handles.append(fullShowSet[i].handle()); 					
				}
			}//next i
	
		//region Get visible range of full showSet if it varies from showSet and requires location outside of full range
			PlaneProfile ppFullRange(CoordSys());	
			if (bPlaceOutside)//fullShowSet.length()!=showSet.length() && 
			{ 				
				PlaneProfile pps[] = GetCommonPlaneProfile2(ppFullRange, ms2ps, bodies, blowUp);
				//PlaneProfile pps[] = GetCommonPlaneProfile(ppFullRange, ms2ps, fullShowSet, blowUp);
				ppFullRange.shrink(blowUp);
				//{Display dpx(2); dpx.draw(ppFullRange, _kDrawFilled,40);}
			}
		//endregion 	

		//region Tsl Cloning Prerequisites
			setCatalogFromPropValues(tLastInserted);
			TslInst tslNew;				
			Map mapTsl;
			mapTsl.setInt(kIndexView, nIndexView);
			int bForceModelSpace = true;	
			String sExecuteKey,sCatalogName = tLastInserted;

			String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
			GenBeam gbsTsl[] = {};	
		//endregion 
		

		//Build groups of equality and split each equality group into multiple if projections do mot overlap			
			Map maps = BuildGroupsOfEquality(sEqualityFormat, showSet);
			//if (bDebug)reportNotice("\n" + maps.length() + " groups collected based on " + sEqualityFormat + "("+showSet.length()+")");
			SplitEqualityGroups2(maps,ms2ps, blowUp, bodies, handles);

		// Distribute by group
			Plane pnW(_PtW, _ZW);
			for (int i=0;i<maps.length();i++) 
			{ 
				Map m= maps.getMap(i);
				
				Entity ents[]=m.getEntityArray("ent[]", "", "ent");
				if (ents.length()<1){ continue;}
				Entity ent = ents.first();
				
			//Get cached bodies	
				Body bdEnts[0];	
				for (int j=0;j<ents.length();j++) 
				{ 
					int n = handles.findNoCase(ents[j].handle(),-1);
					if (n>-1)
						bdEnts.append(bodies[n]);
					 
				}//next j
				
				
				
				
			// Get reading direction by main ref entity	
				Quader qdr = ent.bodyExtents();
				qdr.transformBy(ms2ps);
				Vector3d vecZRead = vecXRead.crossProduct(vecYRead);
				Vector3d vecRead =SetReadDirection(qdr, sDirection, vecXRead, vecYRead, vecZRead);				
				mapParams.setVector3d("vecXRead", vecXRead);
				mapParams.setVector3d("vecYRead", vecYRead);
				mapParams.setVector3d("vecZ", _ZW);
				
				String sThisFormat = GetAutoFormat(ent, sFormat);
				String text= ent.formatObject(sThisFormat, mapAdditional);
				double dX = dp.textLengthForStyle(text, sDimStyle, textHeight);
				double dY = dp.textHeightForStyle(text, sDimStyle, textHeight);	
				mapParams.setDouble("dX",dX);
				mapParams.setDouble("dY",dY);
				mapParams.setString("text", text);				

				Point3d pt = _Pt0;
				PlaneProfile ppCommon;
				if (m.hasPlaneProfile("ppCommon"))
				{
					ppCommon= m.getPlaneProfile("ppCommon");					
					pt = ppCommon.ptMid();
				}
				else
				{
					pt=GetCommonLocation2(pnW,ms2ps, bdEnts);
					//pt=GetCommonLocation(pnW,ms2ps, ents);
				}
				// prefer placement on top side
				pt+=_YU*dEps;	

				
				PlaneProfile ppShape2(CoordSys(pt, vecX, vecY, vecZ)); //placeholder for triangle
			//region Find Location Ouside of common if leader is enabled
				if (!bPlaceOutside && sLeaderStyle!=tDisabled)
				{ 
					ppCommon.shrink(blowUp-textHeight);
					//ppFullRange.unionWith(ppCommon);
					//{Display dpx(1); dpx.draw(ppCommon, _kDrawFilled,20);}
					Point3d ptNext = ppCommon.closestPointTo(pt);
					Vector3d vecNext = ptNext - pt;		
					pt.transformBy(vecNext);
					vecNext.normalize();	//vecNext.vis(pt, 4);
													
					PlaneProfile ppRef(CoordSys(pt, vecXRead,vecYRead,vecXRead.crossProduct(vecYRead)));
					PLine plShape = GetTagShape(ppRef, ppShape2, mapParams);			
					//if (bDebug){Display dpx(4); dpx.draw(PlaneProfile(plShape), _kDrawFilled,20);}
					
				// Locate the tag and append the tag profile to the full range profile
					LocateTag(ppFullRange, pt, plShape, vecNext,mapParams);
					if (bDebug){Display dpx(3); dpx.draw(PlaneProfile(plShape), _kDrawFilled,20);}
					//{Display dpx(2); dpx.draw(ppFullRange, _kDrawFilled,50);}
				}//endregion
				
			//region Find Location Ouside of range
				else if (bPlaceOutside)
				{ 
					Point3d ptNext = ppFullRange.closestPointTo(pt);
					Vector3d vecNext = ptNext - pt;		
					pt.transformBy(vecNext);
					vecNext.normalize();	//vecNext.vis(pt, 4);

					PlaneProfile ppRef(CoordSys(pt, vecXRead,vecYRead,vecXRead.crossProduct(vecYRead)));
					PLine plShape = GetTagShape(ppRef, ppShape2, mapParams);			

				// Locate the tag and append the tag profile to the full range profile
					LocateTag(ppFullRange, pt, plShape, vecNext,mapParams);
					//if (bDebug){Display dpx(3); dpx.draw(PlaneProfile(plShape), _kDrawFilled,20);}
				}
			//endregion 
			
				PLine (ptOrg,pt).vis(i + 1);
				
				Point3d ptsTsl[] = {pt};
				Entity entsTsl[] = {page};
				entsTsl.append(ents);
				if (!bDebug)
				{
					//reportNotice("\ncreate instance with ents " +  "("+entsTsl.length()+")");
					tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 	
				}
			
				 
			}//next i

			if (!bDebug)
				eraseInstance();
			return;
		}//End Distribute instances //endregion 

	// Collect a potential dedicated showSet
		Entity dedicatedShowSetEnts[0];
		for (int i=0;i<_Entity.length();i++) 
			if (_Entity[i]!=page && showSet.find(_Entity[i])>-1)
				dedicatedShowSetEnts.append(_Entity[i]); 

		if (dedicatedShowSetEnts.length()>0)
		{ 
			entDefine = dedicatedShowSetEnts.first();
			showSet = dedicatedShowSetEnts;
		}
		else if (showSet.length()>0)
			entDefine = showSet.first();		
		else
			entDefine = defineSet.first();

		
		Vector3d vecA(1, 0, 0);
		Vector3d vecB=vecA;
		vecB.transformBy(ms2ps);
		double scale = vecA.length() / vecB.length();
		if (_Map.hasDouble("PlotScale"))
			scale*=_Map.getDouble("PlotScale");
			
		
		mapAdditional.setDouble("ScaleFactor", scale);

	
	// populate additional properties to formatting	
		Map mapData = page.subMapX("AssemblyData");
		for (int i=0;i<mapData.length();i++) 
		{ 
			if (mapData.hasInt(i))
				mapAdditional.setInt(mapData.keyAt(i),mapData.getInt(i)); 
			else if (mapData.hasDouble(i))
				mapAdditional.setDouble(mapData.keyAt(i),mapData.getDouble(i)); 
			else if (mapData.hasString(i))
				mapAdditional.setString(mapData.keyAt(i),mapData.getString(i)); 
		}//next i
		
		if (!_bOnInsert)
			_Map.setVector3d("vecOrg", _Pt0 - ptOrg);
		
	}

//	if (bIsBlockCreationMode)
//	{ 
//		{Display dpxs(1); dpxs.textHeight(U(100));dpxs.draw(scriptName(),_Pt0, _XW,_YW,1,0,_kDevice);}
//		
//		return;
//	}
		
		
		
//endregion 	

//region ShopDrawView #SD
	ShopDrawView sdv= (ShopDrawView)entDefine; 
	bHasSDV = sdv.bIsValid();	
	PlaneProfile ppSDV(cs);
	if (bHasSDV)
	{
		PLine pl;
		pl.createConvexHull(Plane(_PtW, _ZW), sdv.gripPoints());
		PlaneProfile pp(pl);
		pp.createRectangle(pp.extentInDir(_XW), _XW, _YW);
		ppSDV.unionWith(pp);
	}
//	ShopDrawView sdvs[0];
	if (nMode==5 || bHasSDV)//|| sdv.bIsValid(
	{ 
		//if(bDebug)reportNotice("\nentering mode 5 " );//XX
		sEqualityFormat.setReadOnly(false);
//
//		for (int i=0;i<_Entity.length();i++) 
//		{ 
//			ShopDrawView _sdv= (ShopDrawView)_Entity[i]; 
//			if (_sdv.bIsValid() && sdvs.find(_sdv)<0)
//				sdvs.append(_sdv);			 
//		}//next i	

		if (sdvs.length()<1)
		{ 
			reportMessage(TN("|No view detected|"));
			eraseInstance();
			return;
		}
		
		double dPlotScale = _Map.getDouble("PlotScale");
		if (dPlotScale <= 0)dPlotScale = 25.0;

	//region On Generate ShopDrawing
		if(_bOnGenerateShopDrawing)
		{ 
			
		// Get multipage from _Map
			Entity entCollector = _Map.getEntity(_kOnGenerateShopDrawing +"\\entCollector");
			Map mapTslCreatedFlags = entCollector.subMapX("mpTslCreatedFlags");
			String uid = _Map.getString("UID"); // get the UID from map as instance does not exist onGenerateShopDrawing
			int bIsCreated = mapTslCreatedFlags.hasInt(uid);		
			
			ViewData viewDatas[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets, 0);
			int nIndFound = ViewData().findDataForViewport(viewDatas, sdv);//find the viewData for my view
			if (!bIsCreated && entCollector.bIsValid() && nIndFound>-1)
			{ 						
				ViewData viewData = viewDatas[nIndFound];
			
			// Transformations
				CoordSys ms2ps = viewData.coordSys();
				CoordSys ps2ms = ms2ps;
				ps2ms.invert();
				
				Vector3d vecAllowedView = _ZW;
				vecAllowedView.transformBy(ps2ms);
				vecAllowedView.normalize();
				
				Vector3d vecDir = _Map.getVector3d("vecDir");
				if (vecDir.bIsZeroLength())vecDir = _XW;


			// create TSL
				TslInst tslNew;
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {entCollector};			Point3d ptsTsl[] = {_Pt0};
				int nProps[]={nColor,nTransparency};
				double dProps[]={dTextHeight};
				String sProps[]={sFormat,sDimStyle,sDirection,sStyle,sLeaderLineType,sAlignment,sPainterFilter, sEqualityFormat,sAllowNested,sGroupAssignment, sLeaderStyle, sPlacement};
				Map mapTsl;	

				if (sFormat.find("ScaleFactor",0, false)>-1)
					mapTsl.setDouble("PlotScale", dPlotScale);						
				mapTsl.setInt(kBlockCreationMode, true);
				mapTsl.setVector3d("vecOrg", _Pt0 - _PtW); // relocate to multipage
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
				if (tslNew.bIsValid())
				{
					//tslNew.setPropValuesFromMap(_Map.getMap("properties"));
					tslNew.transformBy(Vector3d(0, 0, 0));
					
				// flag entCollector such that on regenaration no additional instances will be created	
					if (!bIsCreated)
					{
						bIsCreated=true;
						mapTslCreatedFlags.setInt(uid, true);
						entCollector.setSubMapX("mpTslCreatedFlags",mapTslCreatedFlags);
					}
				}		
			}
			return;			
		}
				
	//endregion 

	//region Draw Setup of Blockspace
		else
		{ 
			
		//region Append most default variables as we don't know the entity type
			String vars[] = _ThisInst.formatObjectVariables("GenBeam");
			for (int j=0;j<3;j++) 
			{ 
				String _vars[] = _ThisInst.formatObjectVariables(j==0?"Sheet":(j==1?"Panel":"MetalPartCollectionEntity")); 
				for (int i=0;i<_vars.length();i++) 
					if (vars.findNoCase(_vars[i],-1)<0)
						vars.append(_vars[i]); 
		 
			}//next j
			String sDoubleVars[] = { "Width", "Height", "Length", "SolidWidth", "SolidHeight", "SolidLength", "SizeX", "SizeY", "SizeZ", "GroupFloorHeight", "GroupHeight"};
			String sIntVars[] = { "ColorIndex", "Posnum"};
			
			Map mapAdd;
			for (int i=0;i<vars.length();i++) 
			{ 
				String key = vars[i];
				if (sDoubleVars.findNoCase(key,-1)>-1)
					mapAdd.appendDouble(key,U(500)+ i*U(1), _kLength); 
				else if (sIntVars.findNoCase(key,-1)>-1)
					mapAdd.appendDouble(key,i+1);
				else
					mapAdd.appendString(vars[i],vars[i]); 
				 
			}//next i
			
			mapAdd.setDouble("ScaleFactor",25.0,_kNoUnit);	
			sFormat.setDefinesFormatting(_ThisInst, mapAdd);				
		//endregion 


		//region Trigger Set Plot ScaleFactor
			if (sFormat.find("ScaleFactor",0, false)>-1)
			{ 
				String sTriggerSetPlotScaleFactor = T("|Set Plot Scale Factor|");
				addRecalcTrigger(_kContextRoot, sTriggerSetPlotScaleFactor );
				if (_bOnRecalc && (_kExecuteKey==sTriggerSetPlotScaleFactor || _kExecuteKey==sDoubleClick))
				{
					double d = getDouble(T("|Enter Plot Scale Factor| (" + dPlotScale + ")"));
					if (d>0)
						_Map.setDouble("PlotScale", d, _kNoUnit);
					setExecutionLoops(2);
					return;
				}				
			}
			//endregion	


		// Store
			_Map.setString("UID", _ThisInst.uniqueId()); // store UID to have access during _kOnGenerateShopDrawing
//			Display dp(-1);
//			dp.trueColor(grey);
//			dp.dimStyle(dimStyle);
//			double textHeight = dTextHeight;
//			if (textHeight<=0)
//				textHeight = dp.textHeightForStyle("O", sDimStyle);
//			else
//				dp.textHeight(textHeight);	
//			
//			dp.draw(sFormat, _Pt0, _XW, _YW, flagX, flagY);
			//return;
		}
	//endregion 		
	}
		

//endregion 		

//end Shopdrawings //endregion 

//region Cast Object
	// Display Color depends on showset
	nc = nColor >- 1 || bIsBlock ? nColor : entDefine.color(); // color may be overwritten by facecolor	

	//if (bDebug)reportNotice("\nThe defining ent is of " + entDefine.typeDxfName());
	Entity entFormat = entDefine;
	String sThisFormat = sFormat; // allow default formatting	
	
	int bIsXref;
	String sXRefName = entDefine.xrefName();
	if (sXRefName.length()>0)
	{ 
		bIsXref = true;
		if (!mapAdditional.hasString("XRefName"))
			mapAdditional.setString("XRefName", sXRefName);		
	}		 
	MetalPartCollectionEnt ce = (MetalPartCollectionEnt)entDefine;
	GenBeam gb = (GenBeam)entDefine;
	Sip sip = (Sip)entDefine;;
	TslInst tsl = (TslInst)entDefine;
	Element el = (Element)entDefine;
	ERoofPlane erp = (ERoofPlane)entDefine;									
	ElementRoof elr = (ElementRoof)entDefine;
	Opening opening = (Opening)entDefine;
	EntPLine epl= (EntPLine)entDefine;
	TrussEntity truss = (TrussEntity)entDefine;
	BlockRef bref = (BlockRef)entDefine;
	MassGroup mg= (MassGroup)entDefine;
	MasterPanel master= (MasterPanel)entDefine;
	FastenerAssemblyEnt fae = (FastenerAssemblyEnt)entDefine;
	ChildPanel child = (ChildPanel)entDefine;
	Section2d section = (Section2d)entDefine;


	//String sDefineTxt = entDefine.formatObject("@(TypeName)@(Definition:D)@(ScriptName:D)");

	CoordSys csDef(_Pt0, _XU,_YU,_ZU);
	CoordSys csParent; // transformation of an optional parent entity such as fastener - metalPart relation

	Entity entSection;
	if (_Map.hasEntity("Section"))
	{ 
		entSection = _Map.getEntity("Section");
	}
	// hide property if not multipage or section related
	if (!page.bIsValid() && sdvs.length()<1 && !section.bIsValid() && !entSection.bIsValid())
	{
		sPainterFilter.set(tFilterDefineSet);
		sPainterFilter.setReadOnly(bDebug?false:_kHidden);
	}
	PainterDefinition pd(sPainterFilter);

//endregion 

//region Collect counting siblings from section and/or parent mertalpart
	int bHasQtyFormat = sThisFormat.find("@(" + kQuantity, 0, false) >- 1;
	int bCountBySibling; // flag if quantity shall be counted by the siblings found
	// when inserted on a section the EqualityFormat or painter format groups entities
	Entity entParent=_Map.getEntity("Parent"), entXSiblings[0];
	if (bHasQtyFormat)
	{ 
		if (entParent.bIsValid())
		{ 
			MetalPartCollectionEnt ce = (MetalPartCollectionEnt)entParent; 
			if (ce.bIsValid() && bHasQtyFormat)
			{
				bCountBySibling = true;
				entXSiblings = GetMetalPartChildEntities(ce, pd);
			}
	
		// Filter by EqualityFormat	
			String format = sEqualityFormat.length()>0?sEqualityFormat:pd.format();
			if (format.length()>0)
			{ 
				String refFormat = entDefine.formatObject(format);
				for (int i=entXSiblings.length()-1; i>=0 ; i--) 
				{ 
					String formatI= entXSiblings[i].formatObject(format);
					if (formatI!=refFormat)
						entXSiblings.removeAt(i);
					
				}//next i
				// filterAccepted doesn't seem to work here
				//entXSiblings = Entity_Pt().filterAcceptedEntities(entXSiblings, format);			
			}
		}
		else if (entSection.bIsValid())
		{ 
			bCountBySibling = bHasQtyFormat;
			Section2d _section = (Section2d)entSection;
			ClipVolume clip = _section.clipVolume();	
	
		// Get referenced entities	
			entXSiblings = clip.includedEntities();
			if (sAllowNested==tYes)
				AppendXRefEntities(entXSiblings, entXSiblings);
	
//		// append metalpart childs
//			if (pd.bIsValid())
//			{
//				MetalPartCollectionEnt ces[] = FilterMetalParts(entXSiblings);
//				for (int i=0;i<ces.length();i++) 
//				{ 
//					Entity childs[] = GetMetalPartChildEntities(ces[i], pd);					
//					AppendEntities(entXSiblings, childs); 
//				}//next i							
//			}

		// Filter by EqualityFormat	
			String format = sEqualityFormat.length()>0?sEqualityFormat:pd.format();
			if (format.length()>0)
			{ 
				String refFormat = entDefine.formatObject(format);
				for (int i=entXSiblings.length()-1; i>=0 ; i--) 
				{ 
					String formatI= entXSiblings[i].formatObject(format);
					if (formatI!=refFormat)
					{
						//reportNotice("\nremoving "+entXSiblings[i].typeName() + " "+ formatI + " vs " + refFormat);
						entXSiblings.removeAt(i);
					}
					
				}//next i
				
				// filterAccepted doesn't seem to work here
				//entXSiblings = Entity_Pt().filterAcceptedEntities(entXSiblings, format);			
			}	
		}
		else if (bHasPage && pd.bIsValid()) // HSB-24142 qty count fails if set to count by sibling and no valid painter
		{ 
			entXSiblings = showSet;
			bCountBySibling = bHasQtyFormat;
		}
	}

//endregion 

//region Get Format and additional map

	if (child.bIsValid())
	{ 
		sip = child.sipEntity();
		gb = sip;
		entFormat = sip;
		ms2ps = child.sipToMeTransformation();
	}

	int nFaceColor=-1, nFaceQuality; // 0 by default, Sip: -1 = bottom, 1 = top

	sThisFormat = GetAutoFormat(entDefine, sFormat);




	if(gb.bIsValid())
	{ 
		if (sip.bIsValid())
		{ 
			Vector3d vecz = sip.vecZ();
			vecz.transformBy(ms2ps); vecz.normalize();		
	
			int bIsBottomStyleFormat = sThisFormat.find("SurfaceQualityBottomStyle", 0, false) >- 1;
			int bIsTopStyleFormat = sThisFormat.find("SurfaceQualityTopStyle", 0, false) >- 1;
			int bAllowAutoSwitch = bHasPage && sThisFormat.find("SurfaceQuality", 0, false) >- 1 && !vecz.isParallelTo(_ZW) && bIsBottomStyleFormat!=bIsTopStyleFormat;

			//adaAdditional.copyMembersFrom(sip.subMapX("HSB_SequenceChild"));
			
		// auto replace surface quality format if not in front view to achieve surface quality which is most aligned with closest ppoint of tag
			if (bAllowAutoSwitch)
			{ 
				
				bd=Body(sip.plEnvelope(), sip.vecZ()*sip.dH(),1);//.envelopeBody(true, true);

				Body bdx = bd;
				bdx.transformBy(ms2ps);
				
				
				Plane pn(_Pt0, _ZW);
			
				PlaneProfile pp(CoordSys());
				pp.unionWith(bdx.shadowProfile(pn));	//pp.vis(1);	
				PLine rings[] = pp.allRings(true, false);
				if(rings.length()>0)
				{ 
					bdx = Body(rings[0], _ZW * bdx.lengthInDirection(vecz), 0);
					
				}
				bdx.vis(3);
				
				
				Point3d ptx = pp.closestPointTo(_Pt0);
	
				Line lnz(ptx, vecz);
				Point3d pts[] = lnz.orderPoints(bdx.intersectPoints(lnz),dEps);

				int nFace;
				if (pts.length()>1)
				{ 
					double d0 = (pts.first() - ptx).length();
					double d1 = (pts.last() - ptx).length();
					nFace = d0 < d1 ?- 1 : 1;

					if (nFace==1 && bIsBottomStyleFormat)
					{ 
						ReplaceString(sThisFormat, "SurfaceQualityBottomStyle", "SurfaceQualityTopStyle");
					}
					else if (nFace==-1 && bIsTopStyleFormat)
					{ 
						ReplaceString(sThisFormat, "SurfaceQualityTopStyle","SurfaceQualityBottomStyle");
					}	
					bIsBottomStyleFormat = sThisFormat.find("SurfaceQualityBottomStyle", 0, false) >- 1;
					bIsTopStyleFormat = sThisFormat.find("SurfaceQualityTopStyle", 0, false) >- 1;
					
					if (sFormat!=sThisFormat)
						sFormat.set(sThisFormat);
				}
				ptx.vis(nFace==-1?1:2);				
				vecz.vis(ptx, 150);

			
			}

			if (bIsBottomStyleFormat)
			{
				nFaceQuality = -1;
				nFaceColor = sip.formatObject("@(SurfaceQualityBottomStyle.Quality:A;SQ)").atoi();
			}
			else if (bIsTopStyleFormat)
			{ 
				nFaceQuality = 1;
				nFaceColor = sip.formatObject("@(SurfaceQualityTopStyle.Quality:A;SQ)").atoi();
			}				
		}

		bd=gb.envelopeBody(true, true);
		qdr = gb.quader(true);	
		
	// append quantity if this genbeam has been numbered and format has been requested
		int pos = gb.posnum();
		if (sThisFormat.find("@("+ kQuantity, 0, false)>-1)
		{ 	
			int qty = 1;
			if (bCountBySibling)
				qty=entXSiblings.length();
			else if (bHasQtyFormat)
			{ 
				Entity ents[0];
				if (entDefine.bIsKindOf(Beam()))
					ents = Group().collectEntities(true, Beam(), _kModelSpace);
				else if (entDefine.bIsKindOf(Sheet()))
					ents = Group().collectEntities(true, Sheet(), _kModelSpace);			
				else if (entDefine.bIsKindOf(Sip()))
					ents = Group().collectEntities(true, Sip(), _kModelSpace);			
				
				for (int i=0;i<ents.length();i++) 
				{ 
					GenBeam g= (GenBeam)ents[i]; 
					if (g.bIsValid() && g.posnum()== pos)
						qty++;	 
				}//next i				
			}
			mapAdditional.setInt("Quantity", qty);
		}
		else 
			mapAdditional.setInt("Quantity", 0);
	}
	else if (erp.bIsValid())
	{ 
		int ok = GetSimpleBody(entDefine, bd);
	}
	else if (el.bIsValid())
	{ 	
		qdr = el.bodyExtents();
		Vector3d vecQ = qdr.pointAt(1, 1, 1) - qdr.pointAt(-1, -1, -1);
		if (vecQ.bIsZeroLength())
		{ 			 
			PLine plEnvelope = el.plEnvelope();

			
			if (plEnvelope.length()<dEps)
			{ 
				plEnvelope.createConvexHull(Plane(el.ptOrg(), el.vecZ()), plEnvelope.vertexPoints(true));
			}
			PlaneProfile pp(el.coordSys());
			pp.joinRing(plEnvelope,_kAdd);
			double dX = pp.dX();
			double dY = pp.dY();
			
			Vector3d vecZE = el.vecZ();			
			LineSeg seg = el.segmentMinMax();
			plEnvelope.projectPointsToPlane(Plane(seg.ptMid(), vecZE), vecZE);
			double dZ = abs(vecZE.dotProduct(seg.ptEnd() - seg.ptStart()));
			dZ = dZ < dEps ? el.dBeamWidth() : dZ;
			dZ = dZ < dEps ? U(1) : dZ;
			qdr = Quader(seg.ptMid(), el.vecX(), el.vecY(), el.vecZ(), dX, dY, dZ, 0, 0, 0);
			//plEnvelope.vis(4);seg.vis(6);qdr.vis(5);
			
		}
		//qdr.vis(6);
		// HSB-23657: 
		if(qdr.dX()>dEps && qdr.dY()>dEps && qdr.dZ()>dEps)
		{ 
			bd = Body(qdr.pointAt(0, 0, 0), qdr.vecX(), qdr.vecY(), qdr.vecZ(), qdr.dX(), qdr.dY(), qdr.dZ(), 0, 0, 0);
		}
		else
		{
			if (erp.bIsValid())
			{
				// Elements casted from roofplane have no quader
				bd = Body(erp.plEnvelope(), erp.coordSys().vecZ(), U(10));
			}
			else
			{
				bd = Body(qdr.pointAt(0, 0, 0), qdr.vecX(), qdr.vecY(), qdr.vecZ(), qdr.dX(), qdr.dY(), qdr.dZ(), 0, 0, 0);
			}
		}
		mapAdditional.setString("subType", el.subType());
	}
	else if (tsl.bIsValid())
	{ 
		CoordSys cst = tsl.coordSys();
		csDef = cst;
		bd = entDefine.realBody();

		//String script = tsl.scriptName();

	// HSB-19490 append quantity if this tsl has been numbered and format has been requested
		int pos = tsl.posnum();
		if (pos>-1 && bHasQtyFormat)
		{ 	
			int qty;
			Entity ents[] = Group().collectEntities(true, TslInst(), _kModelSpace);			
			
			for (int i=0;i<ents.length();i++) 
			{ 
				TslInst t= (TslInst)ents[i]; 
				if (t.bIsValid() && t.posnum()== pos)
					qty++;	 
			}//next i
	
			mapAdditional.setInt("Quantity", qty);
		}
		else 
			mapAdditional.setInt("Quantity", 0);	
	
		if (tsl.formatObjectVariables().findNoCase("posnum",-1)<0)
			mapAdditional.setInt("posnum", pos);
		
		mapAdditional.setString("ModelDescription", tsl.modelDescription());

	// get some kind of solid to get a profile to snap to	
		if (bd.isNull() && !tsl.map().hasPLine("plRoute"))
		{ 
			Point3d pts[] = tsl.gripPoints();
			if (pts.length()>1)
				for (int i=0;i<pts.length()-1;i++) 
				{ 
					Body bdx(pts[i], pts[i + 1], U(1));
					bd.addPart(bdx);
				}//next i
			
			if (bd.isNull())
				bd = Body(tsl.ptOrg(), cst.vecX(), cst.vecY(), cst.vecZ(), U(1), U(1), U(1), 0, 0, 0); 
		}
		qdr = Quader(bd.ptCen(),cst.vecX(), cst.vecY(), cst.vecZ(), 
			bd.lengthInDirection(cst.vecX()), bd.lengthInDirection(cst.vecY()), bd.lengthInDirection(cst.vecZ()));
		bd.vis(2);
	}
	else if (opening.bIsValid())
	{ 
		Opening& o = opening;
		CoordSys cso = o.coordSys();
		Vector3d vecXO= cso.vecX(), vecYO =cso.vecY(), vecZO=cso.vecZ();
		
		PLine pl = o.plShape();pl.vis(3);
		el = o.element();
		Quader q = o.bodyExtents();
		qdr = q;
		Vector3d vecQ = qdr.pointAt(1, 1, 1) - qdr.pointAt(-1, -1, -1);
		if (!vecQ.bIsZeroLength())
			bd=Body(q.pointAt(0, 0, 0), vecXO, vecYO, vecZO, q.dD(vecXO), q.dD(vecYO), q.dD(vecZO), 0, 0, 0);
		else
			bd = Body(pl, el.vecZ() * U(10), 0);
		//bd.vis(2);
	}
	else if (ce.bIsValid())
	{ 
		if (!bAllowNested)
		{ 
			sEqualityFormat.setReadOnly(false);
			sEqualityFormat.setDefinesFormatting(ce, mapAdditional);			
		}

		
		String def = ce.formatObject("@(Definition)");
		MetalPartCollectionDef cd = ce.definitionObject();
		
		qdr = ce.bodyExtents();
		Vector3d vecQ = qdr.pointAt(1, 1, 1) - qdr.pointAt(-1, -1, -1);
		if (!vecQ.bIsZeroLength())
			bd = Body(qdr.pointAt(0, 0, 0), qdr.vecX(), qdr.vecY(), qdr.vecZ(), qdr.dX(), qdr.dY(), qdr.dZ(), 0, 0, 0);
	
	// rebuild simlified solid for the sake of performance	
		if (bd.isNull())
		{ 
			GenBeam gbs[] = cd.genBeam();
			Entity ents[] = cd.entity();
			for (int i=0;i<gbs.length();i++) 
				bd.combine(gbs[i].envelopeBody(true, true)); 
			for (int i=0;i<ents.length();i++) 
			{ 
				if (gbs.find(ents[i])>-1){ continue;}
				Body b = ents[i].realBody();
				if (!b.isNull())
					bd.combine(b); 			 
			}//next i
			bd.transformBy(ce.coordSys());			
		}

		String keys[] = cd.subMapXKeys();
		for (int i=0;i<keys.length();i++) 
		{ 
			Map m = cd.subMapX(keys[i]);
			for (int j=0;j<m.length();j++) 
			{ 
				if (m.hasDouble(j))
					mapAdditional.setDouble(keys[i]+"_"+m.keyAt(j), m.getDouble(j));
				else if (m.hasInt(j))
					mapAdditional.setInt(keys[i]+"_"+m.keyAt(j), m.getInt(j));
				else if (m.hasString(j))
					mapAdditional.setString(keys[i]+"_"+m.keyAt(j), m.getString(j));	
				 
			}//next j	 
		}//next i
		
	//region Quantity
		int qty=1;
		if (bCountBySibling)
		{
			qty = entXSiblings.length();
			mapAdditional.setInt("Quantity", entXSiblings.length());
		}
		else if (bHasQtyFormat)
		{ 
		// Collect Metalparts in current and all xrefs
			Entity entsCE[] = Group().collectEntities(true, MetalPartCollectionEnt(), _kModelSpace);		
			AcadDatabase dbs[] = _kCurrentDatabase.xrefDatabases();
			for (int i=0;i<dbs.length();i++) 
			{ 
				Entity entsAdd[] = Group(dbs[i], "").collectEntities( true, MetalPartCollectionEnt(), _kModelSpace);
				AppendEntities(entsCE, entsAdd);
			}//next i
	
		// count ces based on equality format
			String sEQ1 = ce.formatObject(sEqualityFormat, mapAdditional).makeUpper();
			
			int qty;
			for (int i=0;i<entsCE.length();i++) 
			{ 
				MetalPartCollectionEnt ce2= (MetalPartCollectionEnt)entsCE[i];
				String def2 = ce2.formatObject("@(Definition)");
				if (!ce2.bIsValid() || def!=def2){ continue;}
				
				if (sEQ1==ce2.formatObject(sEqualityFormat, mapAdditional).makeUpper()) 
					qty++;
			}//next i
			mapAdditional.setInt("Quantity", qty);			
		}			
	//endregion 	

		
		

		if (mapAdditional.hasDouble("MetalStyleData_WEIGHT"))
			mapAdditional.setDouble("TotalWeight", qty*mapAdditional.getDouble("MetalStyleData_Weight"));
		
		//bd.vis(6);
	}
	else if (truss.bIsValid())
	{ 
		qdr = entDefine.bodyExtents();
	}
	else if (epl.bIsValid())
	{ 
		PLine pl = epl.getPLine();
		CoordSys csp = pl.coordSys();
		int isClosed = pl.isClosed();
		if (isClosed)
		{ 
			PlaneProfile pp(csp);
			pp.joinRing(pl, _kAdd);
			qdr = Quader(pp.ptMid(), csp.vecX(), csp.vecY(), csp.vecZ(), pp.dX(), pp.dY(), U(1), 0, 0, 0 );
		}
		else if (pl.length()>dEps)
		{ 
			qdr = Quader(pl.ptMid(), csp.vecX(), csp.vecY(), csp.vecZ(), U(10), U(10), U(1), 0, 0, 0 );
		}
		else
		{ 
			reportMessage("\n" + scriptName() + T(" |Polyline cannot be tagged|"));			
			eraseInstance();
			return;
		}
		mapAdditional.setDouble("Length", pl.length(), _kLength);
		mapAdditional.setDouble("Area", pl.area(), _kArea);
		
	}
	else if (bref.bIsValid())
	{ 
		qdr = entDefine.bodyExtents();
		if (entXSiblings.length()>0)
			mapAdditional.setInt("Quantity", entXSiblings.length());		
	}
	else if (mg.bIsValid())
	{ 
		mapAdditional= entDefine.getAutoPropertyMap();

		if (mapAdditional.hasString(T("|Description|")))
			sThisFormat = sThisFormat.length() < 1 ?mapAdditional.hasString(T("@(|Description|)")): sThisFormat;	
		else
			sThisFormat = sThisFormat.length() < 1 ? (T("|Massgroup| ")+"@(Handle:D)"): sThisFormat;			

	}
	else if (master.bIsValid())
	{ 
		bd = Body(master.plShape(), _ZW * master.dThickness(), - 1);	//bd.vis(6);
	}	
	else if (fae.bIsValid())
	{ 
		//bDebug = true;// TODO XXXX
		
		bd = fae.realBody();
		
		if (entParent.bIsValid())
		{ 
			MetalPartCollectionEnt ce = (MetalPartCollectionEnt)entParent;
			if (ce.bIsValid())
			{
				csParent = ce.coordSys();
				//ce.bodyExtents().vis(4);
				bd.transformBy(csParent);
				
			}
		}
		if (bCountBySibling)
			mapAdditional.setInt("Quantity", entXSiblings.length());
		else if (bHasQtyFormat)
		{ 
			int qty;
			Entity ents[] = Group().collectEntities(true, FastenerAssemblyEnt(), _kModelSpace);
			
			for (int i=0;i<ents.length();i++) 
			{ 
				FastenerAssemblyEnt faei= (FastenerAssemblyEnt)ents[i]; 
				if (faei.bIsValid() && faei.articleNumber()== fae.articleNumber())
					qty++;	 
			}//next i	
			mapAdditional.setInt("Quantity", qty);
		}
	
		Map map = fastenerDataMap(fae);
		mapAdditional.copyMembersFrom(map);

		if (bDebug)bd.vis(6);
	}		
	else if (bHasSDV)
	{ 
		;//reportNotice("\nshopdraw view" );//XX
	}
	else if (section.bIsValid())//#SE
	{ 
		//bDebug = true;//#debugsection
		
		ClipVolume clip = section.clipVolume();	
		if (!bDebug && (!clip.bIsValid() || _kExecutionLoopCount==1))
		{ 
			//reportMessage(TN("|purging due to invalid clip body|"));
			eraseInstance();
			return;
		}

	// Secton and its transformations
		CoordSys csSection = section.coordSys();	//csSection.vis(150);
		CoordSys ms2ps = section.modelToSection();
		CoordSys ps2ms = ms2ps; ps2ms.invert();
		Vector3d vecX = csSection.vecX();
		Vector3d vecY = csSection.vecY();

	// The clip Volume
		Body bdClip = clip.clippingBody();	//bdClip.vis(150);
		CoordSys csClip = clip.coordSys();	//csClip.vis(6);
		Vector3d vecFromView = clip.viewFromDir();
		vecFromView.vis(csClip.ptOrg(), 1);
		int bIsPlanView = vecFromView.isParallelTo(_ZW);// horizontal section

		CoordSys csView = csSection; csView.transformBy(ps2ms);
		Plane pnClip(csClip.ptOrg(), clip.viewFromDir() );	pnClip.vis(2);

		PlaneProfile ppClip(csView);
		ppClip.unionWith(bdClip.shadowProfile(pnClip));		
		ppClip.transformBy(ms2ps);	
		//{Display dpx(6); dpx.draw(ppClip, _kDrawFilled,50);}

	// Get referenced entities	
		Entity includedEntities[] = clip.includedEntities();
		if (sAllowNested==tYes)
			AppendXRefEntities(includedEntities, includedEntities);



	//region Function SectionShadow
		// returns the planeprofile of the section
		PlaneProfile SectionShadow(PlaneProfile ppClip, Entity ents[], CoordSys matrix, int bRemoveOpenings)
		{ 
			CoordSys cs = ppClip.coordSys();
			Plane pn(cs.ptOrg(), cs.vecZ());
			PlaneProfile ppSection(cs);

			Entity ents1[] = ents;
			Entity ents2[] = ents;
			Body bodies[] = GetBodies(ents1, ents2);		
			int bRemoveOpenings = true;	

						
			for (int i=0;i<bodies.length();i++) 
			{ 
				Body bd = bodies[i];
				bd.transformBy(matrix);
				PlaneProfile pp = bd.shadowProfile(pn);
				//{Display dpx(i); dpx.draw(pp, _kDrawFilled,20);}
				pp.shrink(-dEps);
				ppSection.unionWith(pp); 
			}//next i
			ppSection.shrink(dEps);
			ppSection.intersectWith(ppClip);			
			if (bRemoveOpenings)
				ppSection.removeAllOpeningRings();
			return ppSection;
		}//endregion


	// Get Section PlaneProfile			
		int bRemoveOpenings = true;
		PlaneProfile ppSection= SectionShadow(ppClip, includedEntities, ms2ps, bRemoveOpenings);
		ppSection.shrink(-textHeight);
		{Display dpx(161); dpx.draw(ppSection, _kDrawFilled,80);}


	//region Fasteners defined in Collecton Entities
		Map mapSet;
		if (pd.bIsValid() && pd.type() == "FastenerAssembly")
		{ 
		// collect fasteners which are within the section	
			Entity entsF[] = pd.filterAcceptedEntities(includedEntities);
			CollectFastenerMaps(mapSet, entsF, MetalPartCollectionEnt()); // collect without parent metalpart

		// Collect fasteners which are defined within a metalPartCollection. store parent alongside
			for (int i=0;i<includedEntities.length();i++) 
			{ 	
				MetalPartCollectionEnt ce = (MetalPartCollectionEnt)includedEntities[i]; 
				Entity entsF[] = GetMetalPartChildEntities(ce, pd);
				CollectFastenerMaps(mapSet, entsF, ce); // collect with parent metalpart								 
			}//next i
			
			for (int i=0;i<mapSet.length();i++) 
			{ 
				Map m = mapSet.getMap(i);
				Entity ents[] = m.getEntityArray("ent[]", "", "ent");
				FastenerAssemblyEnt fae = (FastenerAssemblyEnt)ents.first();
				//reportNotice("\nmap " + i + " returns " + fae.articleNumber() + " parent " + m.getEntity("parent").handle()); 
			}//next i
			
			//reportNotice("\nPainter " + pd.name() + " returns maps " + mapSet.length());
		}
	//endregion 	
		else
		{ 
			String format = sEqualityFormat.trimLeft().trimRight();
			if (pd.bIsValid())	
			{
				includedEntities = pd.filterAcceptedEntities(includedEntities);
				if (format.length()<1)
					format = pd.format();
			}
			if (format.length()<1)
				format = "@(DxfName:D)@(PosNum:D)@(Definition:D)@(ScriptName:D)@(ElementNumber:D)@(Height:D)@(Width:D)@(Length:D)";
				
			for (int i=0;i<includedEntities.length();i++) 
			{ 
				Entity& e = includedEntities[i];
				//String dxf = e.typeDxfName();
				String key = e.handle();
				if (format.length()>0)
					key = e.formatObject(format);

				Map m;
				Entity ents[0];
				if (mapSet.hasMap(key))
				{ 
					m = mapSet.getMap(key);
					ents = m.getEntityArray("ent[]", "", "ent");
					ents.append(e);
				}
				else
				{ 
					ents.append(e);
										
				}
				//if (ce.bIsValid())m.setEntity("parent", ce );
				m.setEntityArray(ents, true, "ent[]", "", "ent");
				mapSet.setMap(key, m);		 
			}//next i		
		}
		
		//reportNotice("\nelse" + pd.name() + " returns maps " + mapSet.length());
	
	// Collect sets from maps
		Entity entRefs[0],entParents[0];
		for (int i=0;i<mapSet.length();i++) 
		{ 
			Map m = mapSet.getMap(i);
			Entity ents[] = m.getEntityArray("ent[]", "", "ent");
			Entity parent = m.getEntity("parent");
			
			if (ents.length()>0)
			{ 
				entRefs.append(ents.first());				
				entParents.append(parent);				
			}	
		}//next i

	 //Remove any tag which has a reference to this section, avoids duplicates
		Entity entTags[0];
		TslInst siblings[] = FilterTslsByName(entTags, bDebug?"hsbEntityTag":scriptName());
		
		for (int i=0;i<siblings.length();i++) 
		{ 
			TslInst t= siblings[i]; 
			Map m = t.map();
			Entity _entSection = m.getEntity("Section");
			Entity ents[] = t.entity();
			if (_entSection .bIsValid() && _entSection  == section && ents.length()>0)
			{ 
				int n = entRefs.find(ents[0]);
				if (n>-1 && !bDebug)
				{
					entRefs.removeAt(n);
					entParents.removeAt(n);					
				}
				if(bDebug)
					reportNotice("\nremove tag " + t.handle());	
			}
		}//next i		
		
		if (bDebug)		reportNotice("\nCollected " + entRefs.length());

		Body bodies[] = GetBodies(entRefs, entParents);
//		Body bodies[] = GetBodies(includedEntities);
		PlaneProfile pps[]= GetPlaneProfiles(bodies, pnClip, ms2ps, ppClip);
		OrderByVisibility(entRefs, bodies, pps);

		PlaneProfile ppShape2(CoordSys(ptRef, vecX, vecY, vecZ));
		

	// Clone Tags for each entity //23804
		TslInst tslNew;
		GenBeam gbsTsl[] = {};			

		int nProps[]={nColor,nTransparency};			
		double dProps[]={dTextHeight};				
		String sProps[]={sFormat,sDimStyle ,sDirection,sStyle,sLeaderLineType,sAlignment,sPainterFilter,sEqualityFormat,sAllowNested,sGroupAssignment,sLeaderStyle, sPlacement};
					
		Map mapTsl;	
		mapTsl.setEntity("Section", section);			
		for (int i=0;i<pps.length();i++) 
		{ 
			//if (bDebug)
				reportNotice("\n" + _ThisInst.handle() + " creating " + entRefs[i].formatObject("@(TypeName) @(Definition:D) @(ScriptName:D)"));
			mapTsl.setEntity("parent", entParents[i]);
			
			Point3d pt = pps[i].ptMid();
			Point3d ptNext = ppSection.closestPointTo(pt);
			Vector3d vecNext = ptNext - pt;
			if (bPlaceOutside)pt.transformBy(vecNext);//HSB-23918
			vecNext.normalize();	//vecNext.vis(pt, 4);				

			String text= entRefs[i].formatObject(sThisFormat, mapAdditional);
			double dX = dp.textLengthForStyle(text, sDimStyle, textHeight);
			double dY = dp.textHeightForStyle(text, sDimStyle, textHeight);	
			mapParams.setDouble("dX",dX);
			mapParams.setDouble("dY",dY);
			mapParams.setString("text", text);
			PLine plShape = GetTagShape((PlaneProfile(CoordSys(pt, csDef.vecX(), csDef.vecY(), csDef.vecZ()))), ppShape2, mapParams);			
			
//			Vector3d vecNext2 = ppx.ptMid() - pps[i].ptMid();
//			vecNext2.normalize();
//			if (vecNext.dotProduct(vecNext2)>0)
//			{
//				vecNext = vecNext2;
//				vecNext2.vis(pt, 93);
//			}

		//region Try collision free placement HSB-23918
			if (bPlaceOutside)
			{	
				PlaneProfile ppx(plShape);
				int cnt;			
				while(cnt<10 && ppx.intersectWith(ppSection))
				{ 
				// try by moving by moving in offset direction	
					//plShape.vis(cnt);
					Vector3d vecMove = vecNext * .5 * textHeight;
					plShape.transformBy(vecMove);
					pt.transformBy(vecMove);
					
				// direction offset has failed: try again in horizontal direction
					ppx = PlaneProfile(plShape);				
					if(ppx.intersectWith(ppSection))
					{ 
						Vector3d vec = vecXView; if(vecXView.dotProduct(vecNext) < 0) vec *= -1;
						vecMove = vec * .5 * dX;
						plShape.transformBy(vecMove);
						//plShape.vis(1);
						
					// horizontal offset has failed: try again in vertical direction	
						ppx = PlaneProfile(plShape);
						if(ppx.intersectWith(ppSection))
						{ 
							plShape.transformBy(-vecMove);
							Vector3d vec = vecYView; if(vecYView.dotProduct(vecNext) < 0) vec *= -1;
							vecMove = vec * .5 * textHeight;
							plShape.transformBy(vecMove);
							ppx = PlaneProfile(plShape);
							//plShape.vis(3);
							if(ppx.intersectWith(ppSection))
							{ 
								plShape.transformBy(-vecMove);
								ppx = PlaneProfile(plShape);
							}
						// accepted
							else
							{ 
								pt.transformBy(vecMove);
							}
						}
					// accepted	
						else
						{ 
							pt.transformBy(vecMove);
						}	
					}
				// don't go wild	
					cnt++;
				}
				ppSection.joinRing(plShape, _kAdd);
			}			
			if (bDebug)plShape.vis(2+i);			
		//endregion 
	
			if (bDebug)
			{
				PlaneProfile pp = pps[i];
				entRefs[i].realBody().vis(6);
				//ptNext.vis(i+1);
				PLine(_PtW,_Pt0,pt).vis(3);
				{Display dpx(i+1); dpx.draw(pp, _kDrawFilled,20);}
			}
			else
			{ 
				Entity entsTsl[] = {entRefs[i]};
				Point3d ptsTsl[] = {pt};
				tslNew.dbCreate(scriptName() , vecX ,vecY,
					gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
					
				//reportNotice("\n" + entRefs[i].formatObject("@(TypeName) @(Definition:D) @(ScriptName:D)") + (tslNew.bIsValid()?"succeeded":"failed"));	
					
			}
		}

		if (bDebug)
		{
			dp.draw(scriptName() + " " + bodies.length(), _Pt0, _XW, _YW, 1, 0);
		}
		else
		{
			eraseInstance();
		}
		return;
	
	}
	
	else if (entDefine.bIsValid())
	{		
		qdr = entDefine.bodyExtents();
		if ((qdr.pointAt(-1,-1,-1)-qdr.pointAt(1,1,1)).length()>dEps)
			bd=Body (qdr.pointAt(0, 0, 0), qdr.vecX(), qdr.vecY(), qdr.vecZ(), qdr.dX(), qdr.dY(), qdr.dZ(), 0, 0, 0);
		else if (!_bOnInsert)
		{ 
			reportMessage("\n" + scriptName() + " "+ entDefine.typeDxfName() + T(" |not supported|"));			
			eraseInstance();
			return;
		}
	}

	if (!el.bIsValid())
		el = entDefine.element();
		
	//end Get Format and additional map //endregion 

//region Get potential section reference #SEction
	int bHasSection;
	PlaneProfile ppClip;
	Body bdClip;
	if (entSection.bIsValid())
	{ 
		section = (Section2d)entSection;

		MetalPartCollectionEnt ce = (MetalPartCollectionEnt)entParent;

		ClipVolume clip;
		if (section.bIsValid())
		{ 		
			ms2ps = section.modelToSection();
			ps2ms = ms2ps; ps2ms.invert();
			clip = section.clipVolume();
			bHasSection = true;
		}
		else
		{ 
			reportMessage("\n"+ scriptName() + " erasing");
			eraseInstance();
			return;
		}
		if (clip.bIsValid())
		{ 

		// verify if entity is within section	
			Entity includedEntities[] = clip.includedEntities();
			if (sAllowNested==tYes)
				AppendXRefEntities(includedEntities, includedEntities);

			if (ce.bIsValid())
			{ 
				Entity ents[]=GetMetalPartChildEntities(ce, pd);
				MetalPartCollectionDef cd = ce.definitionObject();
				if (cd.bIsValid())
				{
					includedEntities.append(cd.entity());
				}
			}
			
		// append metalpart childs
			if (!bDrag && pd.bIsValid())
			{
				MetalPartCollectionEnt ces[] = FilterMetalParts(includedEntities);
				for (int i=0;i<ces.length();i++) 
				{ 
					Entity childs[] = GetMetalPartChildEntities(ces[i], pd);					
					AppendEntities(includedEntities, childs); 
				}//next i							
			}	

			
			if (includedEntities.find(entDefine)<0)
			{ 
				if (bDebug)
				{
					dp.draw(scriptName(), _Pt0, _XW, _YW, 1, 0);
					reportNotice("\n"+entDefine.formatObject("@(TypeName) @(Definition:D)@(scriptName:D)")+ " not in clip");
				}
				else	
				{
					reportMessage(TN("|purging| ") + entDefine.typeDxfName());				
					eraseInstance();
				}
				return;		
			}			
			
			CoordSys csSection = section.coordSys();
			CoordSys csView = csSection; csView.transformBy(ps2ms);
			
			Vector3d vecFromView = clip.viewFromDir();
			bdClip = clip.clippingBody();			//bdClip.vis(1);

			CoordSys csClip = clip.coordSys();
			Plane pnClip(csClip.ptOrg(), vecFromView );	//pnClip.vis(2);
			ppClip=PlaneProfile(csView);
			ppClip.unionWith(bdClip.shadowProfile(pnClip));		
			ppClip.transformBy(ms2ps);					//ppClip.vis(4);						
			bdClip.transformBy(ms2ps);
			//dp.draw(scriptName(), _Pt0, _XW, _YW, 1, 0);
			

		}	
	}

// transform to paperspace if multipage dependent
	if (bHasPage || child.bIsValid() || section.bIsValid())
	{ 
		bd.transformBy(ms2ps);
		qdr.transformBy(ms2ps);
		csDef.transformBy(ms2ps);
		csParent.transformBy(ms2ps);
		
		//bd.vis(2);
	}	
	//end section reference //endregion 

	Vector3d vecZRead = vecXRead.crossProduct(vecYRead);
	Vector3d vecRead =SetReadDirection(qdr, sDirection, vecXRead, vecYRead, vecZRead);
	vecRead.vis(_Pt0, 4);
	
	
//endregion 
		
//end Part #3 //endregion 

//region bOnInsert #2
	if(_bOnInsert)
	{
		Entity ents[0];
		ents = _Entity;

		int nAlignment = sAlignments.findNoCase(sAlignment);
		// vertical
		if (nAlignment >= 0 && nAlignment < 3)flagY = -1;
		else if (nAlignment >= 3 && nAlignment < 6)flagY = 0;
		else if (nAlignment >= 5 && nAlignment < 9)flagY = 1;
		
		//horizontal
		if (nAlignment ==0 || nAlignment==3 || nAlignment==6)flagX = 1;
		else if (nAlignment ==1 || nAlignment==4 || nAlignment==7)flagX = 0;
		else if (nAlignment ==2 || nAlignment==5 || nAlignment==8)flagX = -1;	



	//region Single instance
		Point3d pt;
		if (ents.length()==1)
		{ 
			Entity e = ents[0];
			Map mapArgs;
			mapArgs.setVector3d("vecXRead", vecXRead);
			mapArgs.setVector3d("vecYRead", vecYRead);
			mapArgs.setString("dimStyle", sDimStyle);
			mapArgs.setDouble("textHeight", textHeight);
			mapArgs.setInt("flagX", flagX);
			mapArgs.setInt("flagY", flagY);
			mapArgs.setString("text", e.formatObject(sThisFormat,mapAdditional));
			
			Point3d ptRef = _PtW;
			CoordSys cs;
		
		// Get snap shape
			PlaneProfile pp;
			
		// try viewport	
			if (bHasPage)
			{ 
				pp = ppViewports[nIndexView];
			}

		// try quader	
			if (pp.area()<pow(U(1),2))
			{ 
				Quader q = e.bodyExtents();
				if (q.dX()>dEps && q.dY()>dEps && q.dZ()>dEps) // HSB-18695 catching zero bodies (i.e. tool tsls)
				{ 
					ptRef = q.pointAt(0, 0, 0);
					Body bd(ptRef, q.vecX(), q.vecY(), q.vecZ(), q.dX(), q.dY(), q.dZ(), 0, 0, 0);
					pp = bd.shadowProfile(Plane(ptRef, _ZU));
					cs = CoordSys(ptRef, _XU, _YU, _ZU);
					mapArgs.setPlaneProfile("pp", pp);
				}				
			}

		// try polyline	
			if (pp.area()<pow(U(1),2))
			{ 
				PLine pl = e.getPLine();
				if (pl.isClosed() && !pl.coordSys().vecZ().isPerpendicularTo(_ZU))
				{
					pp.joinRing(pl, _kAdd);	
					mapArgs.setPlaneProfile("pp", pp);
				}
				else if (pl.length()>0)
				{ 
					mapArgs.setPLine("pl", pl);
				}
				else
				{ 
					Point3d pts[] = e.gripPoints();
					if (pts.length()>0)
					{
						pl.createConvexHull(Plane(pts.first(), _ZU),pts);
						mapArgs.setPLine("pl", pl);
					}
				}
			}


		//region Show Jig
			String prompt = (bHasPage || bHasSDV)?T("|Select point|") :T("|Select point [Assign Visible Entity/Textheight]|");
			PrPoint ssP(prompt); // second argument will set _PtBase in map
		    int nGoJig = -1;
		    while (nGoJig != _kOk && nGoJig != _kNone)
		    {
		        nGoJig = ssP.goJig(kJigInsert, mapArgs); 
		        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
		        
		        if (nGoJig == _kOk)
		        {
		            pt = ssP.value(); //retrieve the selected point
		        }
		        else if (nGoJig == _kKeyWord)
		        { 
		            if (ssP.keywordIndex() == 0)
		           	{ 
		           		
		           	// prompt for entities
		           		Entity entsV[0];
		           		PrEntity ssEV(T("|Select additional entity as visible reference|") + T(", |<Empty> removes existing|"), Entity());
		           		if (ssEV.go())
		           			entsV.append(ssEV.set());

						if (entsV.length()>0 && entsV.first() != e)
						{
							Entity ev = entsV.first();
							_Map.setEntity("VisibleEntity", ev);

						// try quader
							PlaneProfile ppv;
							Quader q = ev.bodyExtents();
							if (q.dX()>dEps && q.dY()>dEps && q.dZ()>dEps) 
							{ 
								Body bd(q.pointAt(0, 0, 0), q.vecX(), q.vecY(), q.vecZ(), q.dX(), q.dY(), q.dZ(), 0, 0, 0);
								ppv = bd.shadowProfile(Plane(ptRef, _ZU));
								mapArgs.setPlaneProfile("ppv", ppv);
							}
							
						// try polyline	
							if (ppv.area()<pow(U(1),2))
							{ 
								PLine plv = ev.getPLine();
								if (plv.isClosed() && !plv.coordSys().vecZ().isPerpendicularTo(_ZU))
								{
									ppv.joinRing(plv, _kAdd);	
									mapArgs.setPlaneProfile("ppv", ppv);
								}
								else if (plv.length()>0)
								{ 
									mapArgs.setPLine("plv", plv);
								}
								else
								{ 
									Point3d pts[] = ev.gripPoints();
									if (pts.length()>0)
									{
										plv.createConvexHull(Plane(pts.first(), _ZU),pts);
										mapArgs.setPLine("plv", plv);
									}
								}
							}								
						}
						else // remove visible
						{ 
							_Map.removeAt("VisibleEntity", true);
							mapArgs.removeAt("ppv", true);
							mapArgs.removeAt("plv", true);
						}
		           	}
		       		else if (ssP.keywordIndex() == 1)
		       		{ 
		       			double newTextHeight = getDouble(TN("|New text height| (") + textHeight+ ")");
		       			
		       			if (newTextHeight==0)
		       			{ 
		       				Display dp(0); 
		       				textHeight=dp.textHeightForStyle("G", sDimStyle);
		       				dTextHeight.set(newTextHeight);
		       				mapArgs.setDouble("textHeight", textHeight);
		       			}
		       			else if (newTextHeight>=0)
		       			{ 
		       				textHeight = newTextHeight;
		       				dTextHeight.set(newTextHeight);		       				
		       				mapArgs.setDouble("textHeight", textHeight);
		       			}		       			
		       		}
		        }
		        else if (nGoJig == _kCancel)
		        { 
		            eraseInstance(); // do not insert this instance
		            return; 
		        }
		    }			
		//End Show Jig//endregion 

//			_Entity.append(e);
			_Pt0 = pt;
			return;
		}			
	//endregion 

	//region Multiple instances
		else if (ents.length()>1)
		{ 
		// create TSL
			TslInst tslNew;				Map mapTsl;
			int bForceModelSpace = true;	
			String sExecuteKey,sCatalogName = tLastInserted;
			String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
			GenBeam gbsTsl[] = {};			
	
// HSB-22560			
//			if (sAlignment == tTopLeft)sAlignment.set(tBottomLeft);
//			else if (sAlignment == tTopCenter)sAlignment.set(tBottomCenter);
//			else if (sAlignment == tTopRight)sAlignment.set(tBottomRight);
//
//			else if (sAlignment == tBottomLeft)sAlignment.set(tTopLeft);
//			else if (sAlignment == tBottomCenter)sAlignment.set(tTopCenter);
//			else if (sAlignment == tBottomRight)sAlignment.set(tTopRight);	
	

			int nProps[]={nColor,nTransparency};			
			double dProps[]={dTextHeight};				
			String sProps[]={sFormat,sDimStyle ,sDirection,sStyle,sLeaderLineType,sAlignment,sPainterFilter,sEqualityFormat,sAllowNested,sGroupAssignment,sLeaderStyle, sPlacement};
			if (nMode > 0)mapTsl.setInt("mode", nMode);
		
		
		
			for (int i=0;i<ents.length();i++) 
			{ 
				Entity& e = ents[i];
				TslInst t = (TslInst)e;
				Entity entsTsl[] = {};
				Point3d ptsTsl[] = {pt};
	
				Quader q = e.bodyExtents();
				Vector3d vecSeg = q.pointAt(1, 1, 1) - q.pointAt(-1, - 1 ,- 1);
				PLine pl = ents[i].getPLine();
				Point3d pts[] = e.gripPoints();
				
				Vector3d vecXLoc  = _XU, vecYLoc= _YU;
				if (vecSeg.length()>dEps)
				{ 
					pt=q.pointAt(0,0,0);
					vecXLoc = q.vecD(_XU);//#q
					if ((sDirection==tAlignedX ||sDirection==tAlignedY) && !q.vecX().isParallelTo(_ZU))
						vecXLoc = q.vecX();	

					vecYLoc = vecXLoc.crossProduct(-_ZU);	vecYLoc.normalize();
					vecXLoc = vecYLoc.crossProduct(-_ZU);
					if (vecXLoc.dotProduct(_XU) < 0)
						vecXLoc *= -1;		
					vecYLoc = vecXLoc.crossProduct(-_ZU);					

				// no offset for GenericHangers in triangle mode
					if (t.bIsValid()  && sStyle==tSTriangle && "GenericHanger".find(t.scriptName(),0,false)==0)
					{ 
						pt = t.ptOrg();
					}
					else
					{ 
	
						PlaneProfile ppQdr(CoordSys(pt, vecXLoc, vecYLoc, _ZU));
						Body bd(q.pointAt(0, 0, 0), q.vecX(), q.vecY(), q.vecZ(), q.dX(), q.dY(), q.dZ(), 0, 0, 0);
						ppQdr.unionWith(bd.shadowProfile(Plane(pt, _ZU)));
						double dX = ppQdr.dX();
						double dY = ppQdr.dY();		
						
						pt = ppQdr.ptMid();
						pt -= vecXLoc *flagX *(.5 *dX + textHeight)+vecYLoc *flagY*( .5 * dY + textHeight);						
					}

					ptsTsl[0] = pt;
				}					
				else if (pl.length()>dEps)
					ptsTsl[0] = pl.ptStart();
				else if (pts.length()>0)
					ptsTsl[0].setToAverage(pts);	
				else
				{ 
					reportMessage("\n" + ents[i].typeDxfName() +  T(": |Could not determine insertion point, try with single selection|"));
					continue;
					
				}
				entsTsl.append(ents[i]);
				
				tslNew.dbCreate(scriptName() , _XU ,_YU,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
				
				
				//tslNew.dbCreate(scriptName() , vecXView ,vecYView,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent);  
			}//next i
		}
			
	//endregion 	

		eraseInstance();
		return;
	}	
	setProperties();
// end on insert	__________________//endregion

//region General
	_ThisInst.setDrawOrderToFront(true);
	setDependencyOnEntity(entDefine);
	addRecalcTrigger(_kGripPointDrag, "_Pt0");	
	sFormat.setDefinesFormatting(entFormat, mapAdditional);
	

	Entity entVisible = _Map.getEntity("VisibleEntity");
	Point3d ptExtremes[] = bd.extremeVertices(_ZU);
	
	if (sGroupAssignment==tDefaultEntry && (entVisible.bIsValid() ||entDefine.bIsValid()))
	{ 
		if (entVisible.bIsValid()) // HSB-18695
		{ 
			Group groups[] = entVisible.groups();
			if (groups.length()<1)
				assignToLayer("0");
			else
				assignToGroups(entVisible, 'I');
		}
		else if (el.bIsValid())
		{ 
			assignToElementGroup(el, true, 0, 'E');
			dp.elemZone(el, entDefine.myZoneIndex(), 'E');
			LineSeg seg = el.segmentMinMax();
			ptExtremes.append(seg.ptStart());
			ptExtremes.append(seg.ptEnd());
			
			// add unknown HSB-13819 is supported by @(ElementInformation)
			// k = "Information"; if (sVariables.findNoCase(k,-1)<0){mapAdditional.setString(k, el.information());sVariables.append(k);	}
		}
		else
			_ThisInst.assignToGroups(entDefine, 'I');		
	}
	else if (sGroupAssignment==tNoGroupAssignment && (_bOnDbCreated || _kNameLastChangedProp==sGroupAssignmentName))
	{ 
		assignToLayer("0");	
	}	
	else if (_bOnDbCreated || _kNameLastChangedProp==sGroupAssignmentName)
	{ 
		Group gr;
		gr.setName(sGroupAssignment);
		if (gr.bExists())
		{ 
			gr.addEntity(_ThisInst, true, 0, 'I');
		}
	}

		
	
	
	// Append extremepoint s of nested / referenced items	
	if (tsl.bIsValid())
		AppendExtremePoints(ptExtremes, tsl, ms2ps, vecZ);
	ptExtremes = Line(ptRef, vecZ).orderPoints(ptExtremes, dEps);
	if (ptExtremes.length()>0 && !bHasPage)
		ptRef += vecZ* (vecZ.dotProduct(ptExtremes.last()-ptRef)+U(1));
	ptRef.vis(2);
	if (!bHasPage && !bHasSDV && !bHasSection && vecZ.dotProduct(ptRef-_Pt0)>dEps)
		_Pt0 = ptRef;
	
	
	
	
	Plane pn(bd.ptCen(), vecZ);//pn.vis(3);
	if (bHasPage)
	{
		pn=Plane(page.coordSys().ptOrg(), vecZ);
		_Pt0.setZ(0);
	}
		
// on drag	
	if (_bOnGripPointDrag &&  _kExecuteKey=="_Pt0")
	{ 
		Entity ents[] = {entDefine};
		if (entVisible.bIsValid())ents.append(entVisible);

		dpJig.trueColor(darkyellow, 70);

		for (int i=0;i<ents.length();i++) 
		{ 
			Entity e = ents[i]; 
			PLine pl = e.getPLine();
			
			PlaneProfile pp;
			if (pl.isClosed())
			{ 
				pp.joinRing(pl, _kAdd);
			}
			else
			{
				Quader q = e.bodyExtents();
				if (q.dX()>dEps && q.dY()>dEps && q.dZ()>dEps) // HSB-18695 catching zero bodies (i.e. tool tsls)
				{ 
					Body bd(q.pointAt(0, 0, 0), q.vecX(), q.vecY(), q.vecZ(), q.dX(), q.dY(), q.dZ(), 0, 0, 0);
					pp = bd.shadowProfile(pn);
				}	
			}

			dpJig.draw(pp, _kDrawFilled);	
			dpJig.trueColor(lightblue, 70);
		}//next i

	}
	
	
	
	
//endregion 

//region Trigger CloneTag // HSB-18695
	String sTriggerCloneTag = T("|Clone Tag|"); 
	if (!bIsBlock && !bHasSDV && !bHasSection)
		addRecalcTrigger(_kContextRoot, sTriggerCloneTag );
	if (_bOnRecalc && _kExecuteKey==sTriggerCloneTag)
	{	
	// prompt for entities	
		PrEntity ssE;
		if (entDefine.bIsKindOf(MetalPartCollectionEnt()))
			ssE = PrEntity(T("|Select metalpart|"), MetalPartCollectionEnt());
		else if (entDefine.bIsKindOf(Beam()))
			ssE = PrEntity(T("|Select beam|"), Beam());
		else if (entDefine.bIsKindOf(Sheet()))
			ssE = PrEntity(T("|Select sheet|"), Sheet());			
		else if (entDefine.bIsKindOf(Sip()))
			ssE = PrEntity(T("|Select panel|"), Sip());			
		else if (entDefine.bIsKindOf(TslInst()))
			ssE = PrEntity(T("|Select TSL|"), TslInst());			
		else if (entDefine.bIsKindOf(MasterPanel()))
			ssE = PrEntity(T("|Select masterpanel|"), MasterPanel());			
		else if (entDefine.bIsKindOf(ElementRoof()))
			ssE = PrEntity(T("|Select roof element|"), ElementRoof());	
		else if (entDefine.bIsKindOf(ElementWallSF()))
			ssE = PrEntity(T("|Select element|"), ElementWallSF());	
		else if (entDefine.bIsKindOf(Wall()))
			ssE = PrEntity(T("|Select wall|"), Wall());				
		else if (entDefine.bIsKindOf(Element()))
			ssE = PrEntity(T("|Select element|"), Element());			
		else if (entDefine.bIsKindOf(Opening()))
			ssE = PrEntity(T("|Select opening|"), Opening());						
		else if (entDefine.bIsKindOf(TrussEntity()))
			ssE = PrEntity(T("|Select truss|"), TrussEntity());	
			
		int bAllowNested = sAllowNested==tYes;//sXRefMode == tXrefNested;
		
		ssE.allowNested(bAllowNested);
		
		
		int nProps[]={nColor,nTransparency};			
		double dProps[]={dTextHeight};				
		String sProps[]={sFormat,sDimStyle ,sDirection,sStyle,sLeaderLineType,sAlignment,sPainterFilter,sEqualityFormat,sAllowNested,sGroupAssignment,sLeaderStyle, sPlacement};
	
		while(ssE.go())
		{ 
			Entity ents[0];
			ents.append(ssE.set());
			
			for (int i=0;i<ents.length();i++) 
			{ 
				Entity e = ents[i]; 
				
			// prompt for point input
				PrPoint ssP(TN("|Select point|")); 
				if (ssP.go() == _kOk)
				{
					Point3d pt = ssP.value();
					
				// create TSL
					TslInst tslNew;
					GenBeam gbsTsl[] = {};		Entity entsTsl[] = {e};			Point3d ptsTsl[] = {pt};					
					Map mapTsl=_Map;	
								
					tslNew.dbCreate(scriptName() , _XU ,_YU,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);				
				}
				 
			}//next i

			if (ents.length()<1)
				break;
		}

		
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger AssignVisibleEntity // HSB-18695
	String sTriggerAssignVisibleEntity = T("|Assign Visible Entity|");
	if (!bHasSDV && !bHasSection)
		addRecalcTrigger(_kContextRoot, sTriggerAssignVisibleEntity );
	if (_bOnRecalc && _kExecuteKey==sTriggerAssignVisibleEntity)
	{
		Entity ent = getEntity(T("|Select new entity as visible reference|"));
		if (ent == entDefine)
			return;
			
		PrPoint ssP(TN("|Select point|") + T(", |<Enter> = current location|"), _Pt0); 
		if (ssP.go()==_kOk) 
			_Pt0 = ssP.value();
		
		_Map.setEntity("VisibleEntity", ent);
		setExecutionLoops(2);
		return;
	}
	

	String sTriggerResetVisibleEntity = T("|Release Visible Entity|");
	if (entVisible.bIsValid())
		addRecalcTrigger(_kContextRoot, sTriggerResetVisibleEntity );
	if (_bOnRecalc && _kExecuteKey==sTriggerResetVisibleEntity)
	{
		PrPoint ssP(TN("|Select point|") + T(", |<Enter> = current location|"), _Pt0); 
		if (ssP.go()==_kOk) 
			_Pt0 = ssP.value();		

		_Map.removeAt("VisibleEntity", true);
		setExecutionLoops(2);
		return;
	}
//endregion	

//region Trigger DrawOutline
	// this map is used to define a potential drawing of the outline of the tagged entity
	// it allows drawing the outline drawing on another zone than the entity zoneindex
	Map mapOutline = _Map.getMap("DrawOutline");
	int bDrawOutline = mapOutline.getInt("Draw");
	String sTriggerDrawOutline =T("|Redraw Draw Outline|");	
	if (!page.bIsValid() && !bHasSDV && !bHasSection)
	{ 
		addRecalcTrigger(_kContextRoot, sTriggerDrawOutline);
		if (_bOnRecalc && _kExecuteKey==sTriggerDrawOutline)
		{
			// create TSL
			TslInst tslDialog;			Map mapTsl;						
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {ptRef};
			int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };		
		
			if (el.bIsValid())
			{ 
				Map mapZones;
				for (int i=-5;i<6;i++) 
				{ 
					ElemZone zone = el.zone(i);
					if(zone.dH()>dEps)
						mapZones.appendInt("Zone", i);
					 
				}//next i
				mapTsl.setMap("Zone[]",mapZones);
			}
		
		
		
			mapTsl.setInt("DialogMode",1);
			
			int zone = mapOutline.hasInt("Zone")?mapOutline.getInt("Zone"):entDefine.myZoneIndex();
			String sDrawOutline = bDrawOutline ? tYes: tNo;
			int color = mapOutline.hasInt("Color")?mapOutline.getInt("Color"):nColor;
			int transparency = mapOutline.hasInt("transparency")?mapOutline.getInt("transparency"):0;
			int fillColor = mapOutline.hasInt("FillColor")?mapOutline.getInt("FillColor"):nColor;
	
			sProps.append(sDrawOutline);
	
			nProps.append(zone);
			nProps.append(color);
			nProps.append(transparency);
			nProps.append(fillColor);
			
			tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
			if (tslDialog.bIsValid())
			{
				int bOk = tslDialog.showDialog();
				if (bOk)
				{ 
	
					sDrawOutline = tslDialog.propString(0);
					zone = tslDialog.propInt(0);
					color = tslDialog.propInt(1);
					transparency = tslDialog.propInt(2);
					fillColor = tslDialog.propInt(3);
		
					mapOutline.setInt("Draw", sNoYes.find(sDrawOutline));
					mapOutline.setInt("Zone",zone );
					mapOutline.setInt("Color",color );
					mapOutline.setInt("transparency",transparency );
					mapOutline.setInt("FillColor",fillColor );
					_Map.setMap("DrawOutline",mapOutline);
				}
				tslDialog.dbErase();
			}
			setExecutionLoops(2);
			return;
		}
	}
//endregion 

//region Display
	Entity entFormatObject = child.bIsValid() ? sip : entDefine;
	
	if(pd.bIsValid())
	{ 	
//		if(!entFormatObject.acceptObject(pd))
		if(bCountBySibling && bHasQtyFormat && entXSiblings.length()==0)
		{ 
			// HSB-24506: erase tag if no entities found in filter
//			reportMessage("\n" + scriptName() + ": " +T("|Formatting entity not part of the filter|"));
//			reportMessage("\n" + scriptName() + ": " +T("|No entities found for filter|"));
			
			String msg;
			if (sPainterFilter!=tDisabled)
				msg = T("|The selection set does not contain any items which match the filter|:\n    ") + sPainterFilter;
			else
				msg=T("|No valid entities found in selection set|");				
			
			msg += TN("\n|Make sure the correct items are selected, and change the filter if the desired data isn't visible.|");
			
			reportNotice("\n" + scriptName() + ": " +msg);
			
			
//			Map mapIn;
//			mapIn.setString("Title", T("hsbEntityTag: |Invalid input|"));
//			mapIn.setString("Notice", msg);
//			Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, "ShowNotice", mapIn);
			
			eraseInstance();
			return;
		}
	}
	
	String text;
	if (bIsBlock)
		text = sFormat;
	else
	{	
		text= entFormatObject.formatObject(sThisFormat, mapAdditional);
		
		// remove xRefPath prefix
		if (bIsXref)
		{ 
			int cnt = text.length();
			String arg = sXRefName + "|";
			int x = arg.length();
			int n = text.find(arg, 0, false);
			while(n>-1 && cnt>0)
			{ 
				
				String left = text.left(n);
				String right = text.right(text.length()-n-x);
				text = left + right;
				n = text.find(arg, 0, false);
				cnt--;
			}
		}					  
		if (bref.bIsValid())
		{ 
			_Map.setString("BlockName", bref.definition());
			_Map.setString("Text", text);
		}
		
	}
	
//region Sequential Color Assignment
	//dpWhite.showDuringSnap(false);
	if (nColor==-2)	
	{ 
		if (sFormat.find("ModelDescription",0,false)>-1)
		{ 
			String tag = entFormatObject.formatObject("@(modelDescription:D)", mapAdditional).makeUpper();
			if(tag.length()==1 )
			{ 
				int n = tag.getAt(0) - 'A';
				nc = n >- 1 ? n : nc;
			}
		}
		
	// Try getting sequential color definition by scriptName entry in dictionary	
		if (tsl.bIsValid())
		{ 
			String kTagSeqColor="Tag\\SequentialColor[]";
			String entry = bDebug?"GenericHanger":tsl.scriptName();
			MapObject mo("hsbTSL" ,entry);
			Map map = mo.map();
			Map mapColors = map.getMap(kTagSeqColor);
			SetSequenceColor(nc, mapColors);	// zero based, keep current if not found
		}
	}//endregion 
	
	int bIsPlainText = text.length() > 0 && text == sFormat && sFormat.find("@(", 0, false) < 0;
	int bIsNotResolved = text.length()<1 || (text == sFormat && !bHasSDV);
	
	if (bIsNotResolved && !bIsNotResolved)
	{ 
		
	// Collect available variables	
		String vars[] = entFormatObject.formatObjectVariables();
		for (int i=0;i<mapAdditional.length();i++) 
		{ 
			String var = mapAdditional.keyAt(i); 
			if (vars.findNoCase(var,-1)<0)
				vars.append(var);
		}//next i
	
	// Collect variables of format, if any can be resolved do not show in setup mode
		int bOk = sThisFormat.length()==0;
		if (!bOk)
		{ 
			String sIn = sThisFormat;
			int n = sIn.length();
			while (n>3)
			{ 
				int x1 = sIn.find("@(",0,false);
				int x2 = sIn.find(")",x1,false);
				
				String var;
				if (x1>-1 && x2>x1)
				{ 
					sIn = sIn.right(sIn.length() - x1);
					
					x1 = 0;
					x2 = sIn.find(")",x1,false);
					String sOut = sIn.right(sIn.length()-x2-1);
					int x3 = sIn.find(":",x1,false);
					
					var = sIn.left(x3>-1?x3:x2);
					var = var.right(var.length()-2);
					
				// the variable used in format coudl be found	
					if (vars.findNoCase(var,-1)>-1)
					{ 
						bOk = true;
						break;
					}

					sIn = sOut;
					if (sIn.length()<n)
						n = sIn.length();
				}
				
				n--;
			}			
		}

		
	// if the text cannot be resolved dump instance on tool layer
		if (!bOk)
		{ 
			dp.transparency(80);
			if (entDefine.groups().length()>0 && sGroupAssignment!=tNoGroupAssignment)
				assignToGroups(entDefine, 'T');
			dp.draw(sThisFormat, _Pt0, vecXRead, vecYRead, flagX, flagY,_kDevice);
			return;
		}
	
	}


//region Box and guideline
	Point3d ptText = ptRef;
	PlaneProfile pp(CoordSys(ptRef, vecXRead, vecYRead, vecXRead.crossProduct(vecYRead)));
	PLine plDef;
	
	
	if (bHasPage && showSet.length()>1)
	{ 
		String key = entDefine.handle();
		Map mapX = page.subMapX(key);
		if (mapX.hasPlaneProfile("ppCommon") && bDrag)
		{ 
			pp = mapX.getPlaneProfile("ppCommon");
		}
		else
		{ 
			double blow = 5*textHeight;
			Map maps = BuildGroupsOfEquality(sEqualityFormat, showSet);
			SplitEqualityGroups(maps,ms2ps, blow);
		
		// expected to be one set, clone if multiple
			if (maps.length()==1)
			{ 
				Map m= maps.getMap(0);
				entXSiblings = m.getEntityArray("ent[]", "", "ent");
				if (m.hasPlaneProfile("ppCommon"))
				{
					pp = m.getPlaneProfile("ppCommon");
					pp.shrink(blow);
				}
				mapX.setPlaneProfile("ppCommon", pp);
				page.setSubMapX(key, mapX);
				//{Display dpx(1); dpx.draw(pp, _kDrawFilled,20);}
			}
			else
			{ 
				;//TODO;
			}			
		}
		
	
	}	
	
	if (pp.area()<pow(dEps,2))
	{ 
		if (ppSDV.area()>pow(dEps,2))
		{
			pp = ppSDV;
			dp.draw(ppSDV);
		}
		else if (!bd.isNull() && nFaceQuality!=0 && sip.bIsValid())
		{
			CoordSys csp = pp.coordSys();
			Plane pnFace(sip.ptCen() + sip.vecZ() * nFaceQuality * 0.5 * sip.dH(), sip.vecZ());
			pnFace.transformBy(ms2ps);
			PlaneProfile ppf = bd.extractContactFaceInPlane(pnFace, dEps);
	
			Vector3d vecZS = sip.vecZ();
			vecZS.transformBy(ms2ps);
			if (vecZ.isPerpendicularTo(vecZS))
			{
				CoordSys cs = sip.coordSys(); cs.transformBy(ms2ps);
				LineSeg seg = ppf.extentInDir(cs.vecX());
				plDef = PLine(seg.ptStart(), seg.ptEnd());
				plDef.projectPointsToPlane(pn, vecZ);
				//plDef.vis(6);
			}
			else
				ppf.project(Plane(csp.ptOrg(), csp.vecZ()), vecZ, dEps);		
			pp.unionWith(ppf);
			//Display dp(4); dp.draw(ppf, _kDrawFilled, 50);
		}
		else if (bHasSection)
		{
			Body bdx = bd;
			bdx.intersectWith(bdClip);
			pp.unionWith(bdx.shadowProfile(pn));
	
	
		 	if (bDebug)
		 		{ Display dpx(1); dpx.draw(pp, _kDrawFilled, 20);}//dpx.draw(ppClip, _kDrawFilled, 20);
			
			
		// outside clipping range	
			pp.intersectWith(ppClip);
			if (pp.area()<pow(dEps,2))
			{ 
				
				reportMessage("\noutside clip range");
				if (!bDebug)eraseInstance();
				return;
			}
	
	
		}
		else if (!bd.isNull())
			pp.unionWith(bd.shadowProfile(pn));
		else
		{ 
			plDef = entDefine.getPLine();
			if (plDef.isClosed())
				pp.joinRing(plDef, _kAdd);
		}	
				
	}

	//if (bDebug){Display dpx(6); dpx.draw(pp, _kDrawFilled,60);}
	
//endregion 

	Point3d ptCen = pp.ptMid();
	if (pp.area()<pow(dEps,2) && plDef.length()>0)
	{ 
		ptCen = plDef.ptStart();
	}
	//pp.vis(1);
	
	double dX = dp.textLengthForStyle(text, sDimStyle, textHeight);
	double dY = dp.textHeightForStyle(text, sDimStyle, textHeight);	
	PlaneProfile ppShape2(CoordSys(ptRef, vecX, vecY, vecZ));

	mapParams.setString("text", text);
	mapParams.setDouble("dX",dX);
	mapParams.setDouble("dY",dY);

	PLine plShape = GetTagShape((PlaneProfile(CoordSys(ptRef, csDef.vecX(), csDef.vecY(), csDef.vecZ()))), ppShape2, mapParams);
	//{Display dpx(4); dpx.draw(PlaneProfile(plShape), _kDrawFilled,20);}

	Point3d ptA = ptRef - vecYRead * .5 * dY + vecXRead* .25 * textHeight;
	Point3d ptB = ptRef + vecYRead * .5 * dY + vecXRead * (dX+.25*textHeight);
	Point3d ptm = (ptA + ptB) * .5;
	ptText = _Pt0;//ptm;
	//ptText +=vecXRead*.125*textHeight;

	vecXRead.vis(ptText, 1);
	vecYRead.vis(ptText, 3);

// draw box or revision cloud
	PlaneProfile ppBox(plShape);
	if (nFaceColor > 0 && nColor < 0)nc = nFaceColor;
	dp.color(nc);
	if (sStyle!=tSText)
	{
		dp.draw(ppBox);
		
		int n = abs(nTransparency);
		if (!bDebug &&  n>0 && n<100)
		{ 
			if (nTransparency<0)
			{
				dp.draw(ppBox, _kDrawFilled,abs(nTransparency));			
			}
			else
			{
				dpWhite.draw(ppBox, _kDrawFilled,nTransparency);
				if (sStyle==tSTriangle)
					dp.draw(ppShape2, _kDrawFilled,abs(nTransparency));	
			}
		
		}
		else if (sStyle==tSTriangle)
			dp.draw(ppShape2);	
	}
	
	// publish
	Map mapX;
	mapX.setPlaneProfile("TextArea", ppBox);
	_ThisInst.setSubMapX("Sequencing", mapX);
	
// Leader
	int bDrawLeader = sLeaderLineType != tDisabled;

	int bStraightMulti = sLeaderStyle == tLSMulti;
	int bLeaderMulti = sLeaderStyle == tLSLeaderMulti;
	int bArrowMulti = sLeaderStyle == tLSArrowMulti;
	int bDotMulti = sLeaderStyle == tLSDotMulti;
	int bMulti =bStraightMulti ||bLeaderMulti || bArrowMulti || bDotMulti; 

	// change leader type from multi to single if no multiples found
	if (entXSiblings.length()<2 && bMulti && !bHasSDV)
	{ 
		if (bStraightMulti)
		{
			sLeaderStyle.set(tLSStraight);
			bStraightMulti = false;
		}
		else if (bLeaderMulti)
		{
			sLeaderStyle.set(tLSLeader);
			bLeaderMulti = false;			
		}
		else if (bArrowMulti)
		{
			sLeaderStyle.set(tLSArrow);
			bArrowMulti = false;			
		}
		else if (bDotMulti)
		{
			sLeaderStyle.set(tLSDot);
			bDotMulti = false;			
		}
		bMulti =bStraightMulti ||bLeaderMulti || bArrowMulti || bDotMulti; 
	}


	int bStraight = sLeaderStyle == tLSStraight;
	int bLeader = sLeaderStyle == tLSLeader;
	int bArrow = sLeaderStyle == tLSArrow;
	int bDot = sLeaderStyle == tLSDot; 
	
	int bDrawAsLeaderArrow = (bLeader || bLeaderMulti) && sStyle == tSText;
	int bDrawArrow = bLeader || bArrow ||  bArrowMulti || bLeaderMulti;
	int bDrawDot = bDot || bDotMulti;


	if (bDrawLeader)
	{ 
		if (bHasPage)
			pp.project(pn, _ZW, dEps);
		PlaneProfile ppBound = pp;
		ppBound.removeAllOpeningRings();
		Point3d ptNext = ppBound.closestPointTo(ptm);
	
		//Display dp(4); dp.draw(ppBound, _kDrawFilled, 50);
		//Display dp(4); dp.draw(ppBox, _kDrawFilled, 50);
		//Display dp(2); dp.draw(pp, _kDrawFilled, 50);
	
	// no solid or closed pline
		int bHasBound = ppBound.area() > pow(dEps, 2);
		if (!bHasBound && plDef.length()>0)
			ptNext = plDef.closestPointTo(ptm);
		
		Vector3d vecXG = vecXRead;
		Vector3d vecYG = vecYRead;
		if (vecXG.dotProduct(ptm - ptCen) > 0)vecXG *= -1;
		if (vecYG.dotProduct(ptm - ptCen) > 0)vecYG *= -1;
		
		Point3d pt1 = plShape.closestPointTo(ptm + vecXG * .5 * dX);		
		Point3d pt2 = pt1 + vecXG * textHeight;
		Point3d pt3 = ppBound.closestPointTo(pt2+vecXG*textHeight);	
		if (!bHasBound && plDef.length()>0)
			pt3 = plDef.closestPointTo(pt2+vecXG*textHeight);
	
		if (tsl.bIsValid() && pp.area()<pow(dEps,2))
		{ 
			PLine pl = tsl.map().getPLine("plRoute");
			if (pl.length()>dEps)pt3 = pl.closestPointTo(pt2 + vecXG * textHeight);
		}
		
		//plShape.vis(20);		
		Vector3d vecNear = pt1 - pt3;vecNear.normalize();
		
		if (vecXG.dotProduct(pt3-pt1)>textHeight)
		{
			pt1 = plShape.closestPointTo(ppBox.ptMid() + vecXG * .5 * dX);	pt1.vis(2);
			pt2 = pt1 + vecXG * textHeight;									pt2.vis(2);
			if (bDrawAsLeaderArrow && abs(vecYG.dotProduct(pt2-pt1))<dEps) // in line, ignore pt2
				pt2 = pt1;
			vecX.vis(pt1,4);
			vecY.vis(pt2,5);
			vecXG.vis(pt2,3);
		}
		else
		{ 
			pt1 = plShape.closestPointTo(pt3);
			pt1 += vecXG * textHeight;
			
			// HSB-23918 set pt1 to mid of tag if on left or right extreme
			double d1 = vecXRead.dotProduct(ppBox.ptMid() - pt1);
			double d2 = ppBox.dX() * .5;
			if (abs(d1-d2)>dEps)
			{ 
				pt1 = ppBox.ptMid() + vecXG * d2;
			}				

			
			pt1 = plShape.closestPointTo(pt1);
			pt2 = pt1 - vecNear * textHeight;
			vecX.vis(pt1,1);
			vecY.vis(pt2,2);

			
		}

		if (bDrawAsLeaderArrow)
		{
			Vector3d vecYOffset;
			 if (sDirection == tVertical)
			 { 
			 	vecYOffset = vecYRead * vecYRead.dotProduct(ptRef-pt1)+vecYRead*(.5*dY-1.25*textHeight);
			 }
			 else
			 { 
			 	pt1.vis(40);
			 	vecYOffset = vecYRead * (.5 * dY - 1.25 * textHeight);
			 }		 
			pt1 += vecYOffset;pt1.vis(4);
			pt2 += vecYOffset;			
		}

		Point3d pt4 = plShape.closestPointTo(pt3);		//pt4.vis(4);		

		if ((pt3 - pt4).length()<dTextHeight)
			bDrawLeader = false;
			
		if (bDrawLeader && bHasBound)
		{
			pt3 = ppBound.closestPointTo(pt2);
			pt3.vis(3);
		}
		
		double d13 = (pt1 - pt3).length();
		vecXG.vis(pt1,1);
		
		Point3d pts[] = { pt1, pt2, pt3};
		if (bDrawAsLeaderArrow)
			pts.insertAt(0, pt1 - vecXG * (dX + .25 * textHeight));
		
		PLine plLeader(pt1, pt2, pt3);
		if (plLeader.length()<dTextHeight)
			bDrawLeader = false;
		else if (ppBound.pointInProfile(pt1)!=_kPointOutsideProfile || 
			ppBound.pointInProfile(pt2)!=_kPointOutsideProfile)
			bDrawLeader = false;
		
		//ppBound.vis(2);	plShape.vis(6);
		if (bDrawLeader && !bMulti)
		{
		// Leader Arrow
			if (bDrawAsLeaderArrow || bDrawArrow)
			{ 
				Vector3d vecXT = pt3 - pt2; 
				double dXLast = vecXT.length();
				vecXT.normalize();
				double dXA = dXLast < textHeight ? .9*dXLast : textHeight;
				double dYA = dXA / 6;
				Vector3d vecYT = vecXT.crossProduct(-vecZ);
				PLine pl (pt3, pt3 - vecXT * dXA - vecYT * dYA, pt3 - vecXT * dXA + vecYT * dYA);
				pl.close();
				dp.draw(PlaneProfile(pl), _kDrawFilled);				
				pts.last() -= vecXT * dXA;
				
			}
		// Leader Dot
			if (bDrawDot)
			{ 
				Vector3d vecXT = pt3 - pt2; 
				double dXLast = vecXT.length();
				vecXT.normalize();
				double dXA = (dXLast < textHeight ? .9*dXLast : textHeight)*.125;
				PLine pl;
				pl.createCircle(pt3, vecZ, dXA);
				pl.convertToLineApprox(dEps);
				dp.draw(PlaneProfile(pl), _kDrawFilled);				
				pts.last() -= vecXT * dXA;
				
			}			
		
			plLeader = PLine(vecZ);
			for (int i=0;i<pts.length();i++) 
				plLeader.addVertex(pts[i]); 

		
			dp.draw(plLeader);	
			
			if (nFaceQuality!=0)
			{ 
				PLine c;
				c.createCircle(pt3, vecZ, dTextHeight * .1);
				c.convertToLineApprox(dEps);
				dp.draw(c);
				dp.color(mapOutline.getInt("fillColor"));
				dp.draw(PlaneProfile(c), _kDrawFilled, mapOutline.getInt("transparency"));
				dp.color(nc);
			}	
		}


		else if (bMulti && entXSiblings.length()>0 && pts.length()>1)
		{ 
			Point3d pta = pts[1];
			
			// collect and filter the siblings which are in same projection
			Entity entMultis[0];
			CoordSys csMultis[0];
			
			for (int i=0;i<entXSiblings.length();i++) 
			{ 
				Entity& e = entXSiblings[i]; 
				FastenerAssemblyEnt fae = (FastenerAssemblyEnt)e;
				GenBeam gb= (GenBeam)e;
				MetalPartCollectionEnt ce= (MetalPartCollectionEnt)e;
				MasterPanel master= (MasterPanel)e;
				Element el= (Element)e;
							
				int bAccept = true;
				CoordSys cs1;
				if (fae.bIsValid())					cs1 = fae.coordSys();
				else if (gb.bIsValid())				cs1 = gb.coordSys();
				else if (ce.bIsValid())				cs1 = ce.coordSys();
				else if (master.bIsValid())			cs1 = master.coordSys();
				else if (el.bIsValid())				cs1 = el.coordSys();
				else
				{
					bAccept = false;
					reportMessage("\n" + scriptName() + e.formatObject(" @(DxfName)") + T(" |multileader not supported|"));
				}
				cs1.transformBy(csParent);	
				Point3d pt1 = cs1.ptOrg();
				Vector3d vecX1 = cs1.vecX();
				
				
				for (int j=0;j<csMultis.length();j++) 
				{ 
					CoordSys cs2 = csMultis[j];
					Vector3d vecX2 = cs2.vecX();
					Point3d pt2 = cs2.ptOrg();
					pt2 += vecZ * vecZ.dotProduct(pt1 - pt2);
					if ((pt1-pt2).length()<dEps && vecX1.isParallelTo(vecX2))
					{ 
						bAccept =false;
						//cs1.vis(1);
						break;
					}
				}//next j
				if (bAccept)
				{ 
					cs1.vis(3);
					csMultis.append(cs1);// store tansformed
					entMultis.append(e);
				}				

			}//next i
			for (int i=0;i<entMultis.length();i++) 
			{ 
				Entity& e = entMultis[i]; 
//				if (e==entDefine)
//				{ 
//					continue;
//				}
				GenBeam gb = (GenBeam)e;
				Body bd;
				if (gb.bIsValid())
				{
					bd = gb.envelopeBody(true, true);
				}
				else
				{ 
					Quader q = e.bodyExtents();
					bd= bDrag?GetBodyFromQuader(q):e.realBodyTry();
				}
				
				Point3d ptb = csMultis[i].ptOrg();
				if (!bd.isNull())
				{ 
					bd.transformBy(csParent);
					PlaneProfile pp = bd.shadowProfile(pn);
					ptb = pp.closestPointTo(pts[1]);
					
					// avoid snapping to the corner
					Point3d ptb2 = ptb;
					ClosestMidVertex(pp, ptb2);
					ptb = pp.closestPointTo(((3*ptb+ptb2)*.25));

				}

				ptb.vis(4);
				Vector3d vecXT = ptb - pta; 
				double dXLast = vecXT.length();
				vecXT.normalize();
				
			// Leader Arrow
				if (bLeaderMulti)
				{ 					
					double dXA = dXLast < textHeight ? .9*dXLast : textHeight;
					double dYA = dXA / 6;
					Vector3d vecYT = vecXT.crossProduct(-vecZ);
					
					PLine pl (ptb, ptb - vecXT * dXA - vecYT * dYA, ptb - vecXT * dXA + vecYT * dYA);
					pl.close();
					dp.draw(PlaneProfile(pl), _kDrawFilled);				
					ptb -= vecXT * dXA;
				}
			// Leader Dot
				else if (bDotMulti)
				{ 
					double dXA = (dXLast < textHeight ? .9*dXLast : textHeight)*.125;
					PLine pl;
					pl.createCircle(ptb, vecZ, dXA);
					pl.convertToLineApprox(dEps);
					dp.draw(PlaneProfile(pl), _kDrawFilled);				
					ptb -= vecXT * dXA;
					
				}

			// draw the leader line
				if (i==0 && bLeaderMulti && pts.length()>0)
					dp.draw(PLine(ptb, pta,pts.first()));				
				else
					dp.draw(PLine(ptb, pta));				
	
				
			}
		}
	}
	
// text	
	if (!bHasPage && !bHasSDV && !bHasSection)
		ptText += vecZ * dEps;
	dp.transparency(0);
	dp.draw(text, ptText, vecXRead, vecYRead, flagX, flagY,_kDevice);

// outline
	if (bDrawOutline)
	{
		int transparency = mapOutline.getInt("transparency");
		int color = mapOutline.getInt("color");
		
	// draw on zone override
		if (el.bIsValid())
		{ 
			int zone = mapOutline.getInt("zone");
			dp.elemZone(el, zone, 'I');			
		}

	// draw filled	
		if (transparency>0 && transparency< 100)
		{ 
			int fillColor = mapOutline.getInt("fillColor");	
			dp.color(fillColor);
			dp.draw(pp,_kDrawFilled, transparency);
		}
		dp.color(color);
		dp.draw(pp);
	}
		
//End Display//endregion 

	if (bIsBlockCreationMode)
	{
		_Map.removeAt(kBlockCreationMode, true);
	}
	_Map.setBody("Body", bd);
	
	





























































#End
#BeginThumbnail
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
94`?ES7264+6UC!`Q!:.,*2.G`JQ10!__V=<_
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="4618" />
        <int nm="BreakPoint" vl="4768" />
        <int nm="BreakPoint" vl="3427" />
        <int nm="BreakPoint" vl="4336" />
        <int nm="BreakPoint" vl="3938" />
        <int nm="BreakPoint" vl="5243" />
        <int nm="BreakPoint" vl="3575" />
        <int nm="BreakPoint" vl="4613" />
        <int nm="BreakPoint" vl="4763" />
        <int nm="BreakPoint" vl="3427" />
        <int nm="BreakPoint" vl="4331" />
        <int nm="BreakPoint" vl="3933" />
        <int nm="BreakPoint" vl="3575" />
        <int nm="BreakPoint" vl="5237" />
        <int nm="BreakPoint" vl="3788" />
        <int nm="BreakPoint" vl="3830" />
        <int nm="BreakPoint" vl="3652" />
        <int nm="BreakPoint" vl="5098" />
        <int nm="BreakPoint" vl="5093" />
        <int nm="BreakPoint" vl="3838" />
        <int nm="BreakPoint" vl="5021" />
        <int nm="BreakPoint" vl="5184" />
        <int nm="BreakPoint" vl="5133" />
        <int nm="BreakPoint" vl="2832" />
        <int nm="BreakPoint" vl="2988" />
        <int nm="BreakPoint" vl="2587" />
        <int nm="BreakPoint" vl="2814" />
        <int nm="BreakPoint" vl="2775" />
        <int nm="BreakPoint" vl="2759" />
        <int nm="BreakPoint" vl="2714" />
        <int nm="BreakPoint" vl="1173" />
        <int nm="BreakPoint" vl="1101" />
        <int nm="BreakPoint" vl="3423" />
        <int nm="BreakPoint" vl="3386" />
        <int nm="BreakPoint" vl="3953" />
        <int nm="BreakPoint" vl="3335" />
        <int nm="BreakPoint" vl="3501" />
        <int nm="BreakPoint" vl="3922" />
        <int nm="BreakPoint" vl="3824" />
        <int nm="BreakPoint" vl="3469" />
        <int nm="BreakPoint" vl="3511" />
        <int nm="BreakPoint" vl="3453" />
        <int nm="BreakPoint" vl="4993" />
        <int nm="BreakPoint" vl="2726" />
        <int nm="BreakPoint" vl="2295" />
        <int nm="BreakPoint" vl="3719" />
        <int nm="BreakPoint" vl="3125" />
        <int nm="BreakPoint" vl="3982" />
        <int nm="BreakPoint" vl="2657" />
        <int nm="BreakPoint" vl="5130" />
        <int nm="BreakPoint" vl="3111" />
        <int nm="BreakPoint" vl="2333" />
        <int nm="BreakPoint" vl="1869" />
        <int nm="BreakPoint" vl="3122" />
        <int nm="BreakPoint" vl="3953" />
        <int nm="BreakPoint" vl="3980" />
        <int nm="BreakPoint" vl="4375" />
        <int nm="BreakPoint" vl="4669" />
        <int nm="BreakPoint" vl="3929" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-24506: erase tag if no entities found in filter" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="9/2/2025 9:18:45 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-24506: Show painter filter when TSL inserted on MultiPage in model space" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="9/2/2025 8:55:02 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-24186 blockspace detection improved" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="6/18/2025 9:43:58 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-24189 multi leaders can be selected in blockspace" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="6/17/2025 5:07:13 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-24142 Performance of metal parts in sections and across multiple pages has been improved." />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="6/10/2025 4:00:00 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-24142 qty count fixed on multipages" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="6/6/2025 4:33:42 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-24141 xRef/Block selection property visible on insert if xRefs or Blocks found, new option to modify text height during insert" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="6/6/2025 10:33:06 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23923 accepting multipages without a defineSet if showSet is valid" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="6/3/2025 8:52:58 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23923 accepting roofplanes and tsl instances with showset creation" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="5/28/2025 3:37:02 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23923 new value 'Visible Set of Entities' in context of shopdrawings. defining entity will be used by default if no other filter has been set" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="5/28/2025 12:02:45 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23923 minor property naming improvement" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="5/9/2025 3:07:37 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23923 Supports bulk creation within the showset of a multipage. Identical items can be grouped using the 'equality format' property. Grouping only considers items that are within a certain range of each other, based on a multiple of the specified text height" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="5/9/2025 9:31:30 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23918 default placement sections ignores section range" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="4/23/2025 11:36:15 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23918 new property 'placement' sets location strategy during insert" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="4/22/2025 9:57:57 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23804 tag placement on sections avoids overlapping with section graphics, qty on genbeams fixed, duplicate leaders suppressed" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="4/2/2025 9:50:59 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23734 bugfix when inserting with invalid dimstyle by catalog" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="3/19/2025 4:44:50 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23657: Merging Version 5.10: Fix when constructing body of elements casted from roofplane" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="3/13/2025 10:06:35 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23666 quantity count fixed (introduced HSB-23456)" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="3/10/2025 10:23:53 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23422 the tag now draws at the highest z-location of the entity and its references to display also in visual styles" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="2/28/2025 1:37:55 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23546 multileader support added genbeams, metalparts" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="2/20/2025 9:46:44 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23546 sections: quantity fixed" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="2/19/2025 3:13:31 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23546 new leader styles 'multi' show multiple leaders if corresponding siblings have been found" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="2/19/2025 10:48:13 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23546 bugfix section creation" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="2/18/2025 5:49:11 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23546 supporting fastener assemblies as model reference, with sections is also supports fasteners as sub component of a metalparts. new property to display guideline as leader with arrow, dot or straight" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="2/18/2025 11:05:58 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23097 MetalParts: style data and counting via equality format of xRef entities supported" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="12/3/2024 9:53:43 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23097 supports content of xrefs when when referenced by a section" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="12/2/2024 5:23:48 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22560 new shape 'Triangle', consumes sequential colors if provided by parent entity, supports tsl modelDescription" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="11/19/2024 4:00:38 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22779 tags attached to a section will be purged on recalc if the section has been deleted" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="10/18/2024 8:59:15 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22779 performance and insert location on sections improved" />
      <int nm="MAJORVERSION" vl="4" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="10/17/2024 2:20:27 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22779 supports roof/floor elements" />
      <int nm="MAJORVERSION" vl="4" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="10/10/2024 9:59:51 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22779 supports sections and iltering by painter definitions during insert" />
      <int nm="MAJORVERSION" vl="4" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="10/8/2024 1:40:53 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22741 supports child panels and references the panel" />
      <int nm="MAJORVERSION" vl="4" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="10/1/2024 9:56:35 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22633 supports hsbMake and hsbShare display, plain text supported" />
      <int nm="MAJORVERSION" vl="4" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="9/11/2024 4:49:23 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22250: Remove the change in 4.3; not needed" />
      <int nm="MAJORVERSION" vl="4" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="6/18/2024 9:56:53 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22250: modify for the format @(DATALINK.f_Package.InternalMapx.TOPPANEL)" />
      <int nm="MAJORVERSION" vl="4" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="6/14/2024 2:30:14 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-21005 surfaceQualityStyles will swap to closest corresponding face when applied to shopdrawings in non front views" />
      <int nm="MAJORVERSION" vl="4" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="12/21/2023 3:28:41 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20902 version conflict resolved ( HSB-19490 / HSB-20543) supports XRefName if the defining entity is nested in a XRef. XRef-Path purged as prefix from result, i.e. ElementNumber" />
      <int nm="MAJORVERSION" vl="4" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="12/12/2023 9:59:27 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20739 leader points towards corresponding face when using SurfaceQualityBottomStyle or SurfaceQualityTopStyle . Color = -1 uses color of quality and can be mapped to specific color using Alias 'SQ'" />
      <int nm="MAJORVERSION" vl="4" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="11/27/2023 11:43:27 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-19490 supports the virtual format 'Quantity' if the tsl has been numbered, the variable will resolve as '0' if it is not numbered." />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="7/20/2023 10:19:58 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-19085 supports the virtual format 'Quantity' if the genbeam has been numbered, the variable will resolve as '0' if it is not numbered. Dimstyles which are associated to non linear dimensions are not shown anymore" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="6/1/2023 9:29:50 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-19014 assignment to shopdrawviewport in blockspace corrected" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="5/23/2023 10:31:38 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18972 nested selection accesible for block and external references, empty resolving does not show value if variable exists" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="5/15/2023 10:34:04 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18903 hidden xref property will not select nested items of block references. auto format added for blockrefs and massgroups" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="5/5/2023 10:35:29 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18776 assignment to layer 0 (no group assignment) only active during creation or on property change" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="5/4/2023 9:42:37 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="TRU-285 TrussEntity: TrussMark added as default format" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="5/4/2023 8:11:08 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18776 bugfix aligned orientations respect entity alignment" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="5/3/2023 2:43:32 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18776 cloning supports xref entities" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="5/3/2023 1:05:40 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18776 new properties to select xref content and and to control layer assignment, new placement when multiple entities are selected" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="5/2/2023 5:35:41 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18736 visible entity can be assigned during insert, multiple insert improved" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="4/20/2023 11:05:34 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18695 catching zero solids when dragging" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="4/19/2023 4:05:19 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18695 new context commands to clone tag and to assign visible reference / layer override" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="4/18/2023 4:18:58 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18681 outline drawn at correct page location on creation" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="4/17/2023 1:58:55 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18357 revision cloud display improved on short texts" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="4/5/2023 2:13:05 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18357 leader and revision cloud display improved" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="3/17/2023 10:35:43 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-19972 boundings improved, new property transparency can create filled opaque background" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="2/15/2023 10:40:26 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17353 new revision cloud style" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="12/15/2022 3:20:46 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17353 MetalPartCollectionEntity: Performance imroved, new property for equality distinction, new formats to calculate and display equality based 'Quantity' and 'TotalWeight'" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="12/15/2022 11:49:56 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17297 Alignments and Scale Properties added" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="12/12/2022 9:57:33 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15792 new property leader linetype, supports auto reation in modelspace if defined in blockspace with a shopdraw viewport" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="6/24/2022 1:14:36 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13819  guidelline will be suppressed if location is inside of shape" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="11/16/2021 9:28:00 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13249 guidelline will be suppressed if linked entity is opening and location is inside of opening" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="9/22/2021 1:54:08 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12441 - new context command with additional properties to control redrawing of outline of the entity" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="7/1/2021 10:39:22 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12441 enhanced display, full format variable support" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="6/30/2021 10:48:06 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End