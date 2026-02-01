#Version 8
#BeginDescription
#Versions
1.12 22.07.2021 HSB-12590: find upward orientation if panel vertical Author: Marsel Nakuci
1.11 16.07.2021 HSB-12590: if panel belongs to an element take orientation vectors from the element Author: Marsel Nakuci
1.10 15.07.2021 HSB-12604: remove small gap .1 mm Author: Marsel Nakuci
1.9 14.07.2021 HSB-12590: Use element vectors when panel is part of an element Author: Marsel Nakuci
1.8 19.06.2021 HSB-12162: write properties at dbcreated sips
1.7 11.06.2021 HSB-12162: add painter filter; tsl can be attached to an element definition Author: Marsel Nakuci
Version 1.6    08.03.2021 
HSB-10568 new properties to specify additional gaps around the opening , Author Thorsten Huck

INBOX-852 add header gap property
INBOX-852 issue fixed
translation issue fixed
Completely revised, FogBugz Case 4451
Requires hsbcad 21.0.108 or 22.0.15 or higher

/// Various insertion methods are provided
/// 1) insert per opening
/// 2) insert on every opening per element
/// 3) insert on every opening per panel (circular openings excluded)
/// 4) insert per existing header





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 12
#KeyWords panel, opening, split, SIP, gap, header, sill
#BeginContents
/// <History>//region
// #Versions
// Version 1.12 22.07.2021 HSB-12590: find upward orientation if panel vertical Author: Marsel Nakuci
// Version 1.11 16.07.2021 HSB-12590: if panel belongs to an element take orientation vectors from the element Author: Marsel Nakuci
// Version 1.10 15.07.2021 HSB-12604: remove small gap .1 mm Author: Marsel Nakuci
// Version 1.9 14.07.2021 HSB-12590: Use element vectors when panel is part of an element Author: Marsel Nakuci
// Version 1.8 19.06.2021 HSB-12162: write properties at dbcreated sips Author: Marsel Nakuci
// Version 1.7 11.06.2021 HSB-12162: add painter filter; tsl can be attached to an element definition Author: Marsel Nakuci
// 1.6 08.03.2021 HSB-10568 new properties to specify additional gaps around the opening , Author Thorsten Huck
///<version value="1.5" date="12mar2019" author="marsel.nakuci@hsbcad.com"> INBOX-852 add header gap property </version>
///<version value="1.4" date="11mar2019" author="marsel.nakuci@hsbcad.com"> INBOX-852 issue fixed </version>
///<version value="1.3" date="17Apr2018" author="thorsten.huck@hsbcad.com"> translation issue fixed </version>
///<version value="1.2" date="29may17" author="thorsten.huck@hsbcad.com"> FogBugz Case 4451: completely revised </version>
///<version value="1.1" date="22jan16" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Various insertion methods are provided
/// 1) insert per opening
///	2) insert on every opening per element
/// 3) insert on every opening per panel (circular openings excluded)
/// 4) insert per existing header
/// Choose options by selection set and prompt options.
/// </insert>

/// <summary Lang=en>
/// This tsl creates header splittings on openings, headers or opeings of panels
/// </summary>

/// <remark Lang=en>
/// Requires hsbcad 21.0.108 or 22.0.15 or higher
/// </remark>
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
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true; break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end constants//endregion
	
//region Properties
category = T("|Header|");
	String sHeaderXName=T("|Extension|");	
	PropDouble dHeaderX(nDoubleIndex++, U(0), sHeaderXName);	
	dHeaderX.setDescription(T("|Defines the Header Extension in X-Direction|"));
	dHeaderX.setCategory(category);
	
	String sHeaderGapName=T("|Horizontal Gap|");	
	PropDouble dHeaderGap(nDoubleIndex++, U(0), sHeaderGapName);	
	dHeaderGap.setDescription(T("|Defines the horizontal gap to the header|"));
	dHeaderGap.setCategory(category);
	
category = T("|Sill|");
	String sSillXName=T("|Extension|")+ " ";	
	PropDouble dSillX(nDoubleIndex++, U(0), sSillXName);	
	dSillX.setDescription(T("|Defines the Sill Extension in X-Direction|"));
	dSillX.setCategory(category);
	
	String sSplitSillName=T("|Split Sill|");	
	PropString sSplitSill(nStringIndex++, sNoYes, sSplitSillName);	
	sSplitSill.setDescription(T("|Defines wether potential sill panels are to be splitted.|"));
	sSplitSill.setCategory(category);
	
category = T("|Opening|");
	String sGapTopName=T("|Top|");	
	PropDouble dGapTop(nDoubleIndex++, U(0), sGapTopName);	
	dGapTop.setDescription(T("|Defines the gap on top of to the opening|"));
	dGapTop.setCategory(category);
	
	String sGapBottomName=T("|Bottom| ");	
	PropDouble dGapBottom(nDoubleIndex++, U(0), sGapBottomName);	
	dGapBottom.setDescription(T("|Defines the gap on the bottom side of the opening|"));
	dGapBottom.setCategory(category);
	
	String sGapLeftName=T("|Left| ");	
	PropDouble dGapLeft(nDoubleIndex++, U(0), sGapLeftName);	
	dGapLeft.setDescription(T("|Defines the gap on the left side of the opening|"));
	dGapLeft.setCategory(category);
	
	String sGapRightName=T("|Right| ");	
	PropDouble dGapRight(nDoubleIndex++, U(0), sGapRightName);	
	dGapRight.setDescription(T("|Defines the gap on the right side of the opening|"));
	dGapRight.setCategory(category);
	
// HSB-12162
category = T("|Painter|");
	String sPainterCollection = "hsbCLT-OpeningSplit";
	String sAllowedPainterTypes[] = { "Panel", "Sip"};
	String sBySelection = T("|bySelection|");
	// Collect painters
	String sPainters[] = PainterDefinition().getAllEntryNames().sorted();	
	for (int i=sPainters.length()-1; i>=0 ; i--) 
	{ 
		String sPainter = sPainters[i];
		if (sPainter.find(sPainterCollection,0,false)<0 || sPainter.find(sBySelection,0,false)>-1)
		{ 
			sPainters.removeAt(i);
			continue;
		}
		PainterDefinition pd(sPainter);
		if (sAllowedPainterTypes.findNoCase(pd.type())<0)
		{ 
			sPainters.removeAt(i);
			continue;
		}		
	}//next i
	sPainters = sPainters.sorted();
//End Properties//endregion 

//region painter stream
	String sPainterStreamName=T("|Painter Definition|");	
	PropString sPainterStream(4, "", sPainterStreamName);	
	sPainterStream.setDescription(T("|Stores the data of the used painter definition to copy the definition via catalog|"));
	sPainterStream.setCategory(category);
	sPainterStream.setReadOnly(bDebug?0:_kHidden);
	
	// on insert read catalogs to copy / create painters based on catalog entries
	if (_bOnInsert || _bOnElementConstructed)
	{ 
	// collect streams	
		String streams[0];
		String sScriptOpmName = bDebug?"hsbCLT-OpeningSplit":scriptName();
		String entries[] = TslInst().getListOfCatalogNames(sScriptOpmName);
		for (int i=0;i<entries.length();i++) 
		{ 
			String& entry = entries[i]; 
			Map map = TslInst().mapWithPropValuesFromCatalog(sScriptOpmName, entry);
			Map mapProp = map.getMap("PropString[]");
			
			for (int j=0;j<mapProp.length();j++) 
			{ 
				Map m = mapProp.getMap(j);
				int index = m.getInt("nIndex");
				String stream = m.getString("strValue");
				if (index== 4 && streams.findNoCase(stream,-1)<0)
				{ 
					streams.append(stream);
				}
			}//next j 
		}//next i
		
	// process streams
		for (int i=0;i<streams.length();i++) 
		{ 	
			String& stream = streams[i];
			String _painters[0];
			_painters = sPainters;
			if (stream.length()>0)
			{ 
			// get painter definition from property string	
				Map m;
				m.setDxContent(stream , true);
				String name = m.getString("Name");
				String type = m.getString("Type").makeUpper();
				String filter = m.getString("Filter");
				String format = m.getString("Format");
				
			// create definition if not present	
				if (m.hasString("Name") && m.hasString("Type") && name.find(sPainterCollection,0,false)>-1 &&
					_painters.findNoCase(name,-1)<0)
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
	}
	
	String sReferences[0];
	for (int i=0;i<sPainters.length();i++) 
	{ 
		String entry = sPainters[i];
		entry = entry.right(entry.length() - sPainterCollection.length()-1);	
		if (sReferences.findNoCase(entry,-1)<0)
			sReferences.append(entry);
	}//next i
	sReferences.insertAt(0, sBySelection);
	String sReferenceName=T("|Reference|");	
	PropString sReference(nStringIndex++, sReferences, sReferenceName);	
	sReference.setDescription(T("|Defines the Reference|"));
	sReference.setCategory(category);
	if (sReferences.findNoCase(sReference,-1)<0)
		sReference.set(sBySelection);
	
////region mapIO: support property dialog input via map on element creation
//	{
//		int bHasPropertyMap = _Map.hasMap("PROPSTRING[]") && _Map.hasMap("PROPDOUBLE[]");
//		if (_bOnMapIO)
//		{ 
//			if (bHasPropertyMap)
//				setPropValuesFromMap(_Map);	
//			showDialog();
//			_Map = mapWithPropValues();
//			return;
//		}
//		if (_bOnElementDeleted)
//		{
//			eraseInstance();
//			return;
//		}
//		else if (_bOnElementConstructed && bHasPropertyMap)
//		{ 
//			setPropValuesFromMap(_Map);
//			_Map = Map();
//		}	
//	}		
////End mapIO: support property dialog input via map on element creation//endregion 
	
// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();


	// the user can choose various insertion methods
	//	1) insert per opening
	//	2) insert every opening per element
	//	3) insert every opening per panel
	//	4) insert per existing header

	// prompt for openings or elements
		Entity ents[0];
		PrEntity ssE(T("|Select opening(s), element(s) or panel(s) with openings|") + " " + T("|<Enter> to select existing header(s)|"), Opening());
		ssE.addAllowedClass(Element());
		ssE.addAllowedClass(Sip());
	  	if (ssE.go())
			ents.append(ssE.set());

	// collect openings
		Opening openings[0];
		for(int i=0;i<ents.length();i++)
		{
			Opening opening = (Opening)ents[i];
			if (opening.bIsValid())
				openings.append(opening);	
		}
		
	// append openings of elements of which no opening has been appended yet and/or collect sips with openings
		Sip sips[0];
		for(int i=0;i<ents.length();i++)
		{
			Element el= (Element)ents[i];
			
			if (el.bIsValid())
			{
				Opening _openings[]=el.opening();
				for(int o=0;o<_openings.length();o++)
				{
					Opening opening = _openings[o];
					if (openings.find(opening)<0)
						openings.append(opening);	
				}
				continue;
			}		
			Sip sip= (Sip)ents[i];
			if (sip.bIsValid() && sip.plOpenings().length()>0)
				sips.append(sip);
		}
		
	// reset individual sips if openings are found
		if (openings.length()>0)
			sips.setLength(0);
		
	// HEADER: get headers
		GenBeam gbHeaders[0];
		PrEntity ssHeader(T("|Select header item(s)|"), GenBeam());
	  	if (ents.length()<1 && ssHeader.go())
	  	{
	  		Element elements[0];
	  		Sip sips[0];
	  		Entity entsHeaders[]=ssHeader.set();
	  		for (int i=0;i<entsHeaders.length();i++) 
	  		{
	  			GenBeam gb = (GenBeam)entsHeaders[i];
	  			Element el = gb.element();
				if (el.bIsValid())
				{
					Sip _sips[]=el.sip();
					if (_sips.length()>0)
						sips.append(_sips);
					else	
						elements.append(el);
				}	
	  			gbHeaders.append(gb); 
	  		}
	  		
  		// append elements and sips
  			for (int i=0;i<sips.length();i++) 
  				ents.append(sips[i]); 
  			for (int i=0;i<elements.length();i++) 
  				ents.append(elements[i]); 
 		
	 	// prompt for sips or elements if nothing found by header reference
			if (entsHeaders.length()>0 && ents.length()<1)
			{
				PrEntity ssE2(T("|Select element(s) or panel(s)|"), Element());
				ssE2.addAllowedClass(Sip());
			  	if (ssE2.go())
					ents.append(ssE2.set());					
			}
			
			
		// exit if invalid selection
			if (entsHeaders.length()<1)
			{
				reportMessage("\n" + scriptName() + ": " +T("|Invalid selection.|"));	
				eraseInstance();
				return;
			}
	  	}
	// test catalog entry
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
//		else if (gbHeaders.length()<1)	
		else
			showDialog();// always show dialog
		
	// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE;
		Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[] = {};
		
		Point3d ptsTsl[1];
		int nProps[]={};
		
		Map mapTsl;	
		String sScriptname = scriptName();
        
	// insert in opening / element mode
		if (gbHeaders.length()<1)
		{
			Entity entsTsl[1];
			double dProps[] ={ dHeaderX, dHeaderGap, dSillX, dGapTop, dGapBottom, dGapLeft, dGapRight};
			String sProps[]={sSplitSill, sReference, "","",sPainterStream};
			
		// insert per opening
			for(int i=0;i<openings.length();i++)
			{
				if(bDebug)reportMessage("\n"+ scriptName() + "openings.length() "+openings.length());
				Opening opening = openings[i];
				entsTsl[0]= opening;	
				ptsTsl[0]=opening.coordSys().ptOrg();
				// 
				tslNew.dbCreate(scriptName(), vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
						nProps, dProps, sProps,_kModelSpace, mapTsl);	
				
				if(bDebug && tslNew.bIsValid())reportMessage("\n"+ scriptName() + " created for opening " +opening.element().number());
			}
			
		// insert per single sip
			entsTsl.setLength(0);
			gbsTsl.setLength(1);
		// insert per opening of sip
			for(int i=0;i<sips.length();i++)
			{
				if(bDebug)reportMessage("\n"+ scriptName() + "sips.length() "+sips.length());
								
				gbsTsl[0]= sips[i];	
				ptsTsl[0]=sips[i].ptCenSolid();
				mapTsl = Map();
				PLine plShapes[] = sips[i].plOpenings();
				
				if(bDebug)reportMessage("\n"+ scriptName() + "plShapes.length() "+plShapes.length());
				for (int o=0;o<plShapes.length();o++) 
				{ 
					// enteres hier....
					if(bDebug)reportMessage(TN("|enters ...|"));
					
					// create a tsl for each polyline
					mapTsl.setPLine("plShape",plShapes[o]);
					tslNew.dbCreate(scriptName(), vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
						nProps, dProps, sProps,_kModelSpace, mapTsl);
					
				}
				if(bDebug && tslNew.bIsValid())reportMessage("\n"+ scriptName() + " created for sip " +sips[i].handle());
			}			
		}
		else
		{
			Entity entsTsl[0];
			// pass only the gap, whe header is defined from selection
			double dProps[] ={ 0, dHeaderGap, 0, 0,0,0,0};
			String sProps[]={sNoYes[0]};
			gbsTsl.setLength(1);
			
		// insert per header
			for(int i=0;i<gbHeaders.length();i++)
			{
				// gbHeaders
				if(bDebug)reportMessage("\n"+ scriptName() + "gbHeaders.length() "+gbHeaders.length());
				
				entsTsl.setLength(0);
				gbsTsl[0] = gbHeaders[i];
				ptsTsl[0] = gbsTsl[0].ptCenSolid();
				entsTsl.append(ents);
				tslNew.dbCreate(scriptName(), vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
						nProps, dProps, sProps,_kModelSpace, mapTsl);	
				
				if(bDebug && tslNew.bIsValid())reportMessage("\n"+ scriptName() + " created for " +gbHeaders[i].handle());
			}			
		}
		eraseInstance();
		return;
	}
// end on insert	__________________

//return
// 
	if (bDebug)reportMessage("\nStarting " + scriptName() + " " + _ThisInst.handle() + " during loop " + _kExecutionLoopCount);
//	if ( ! bDebug)return;

// get references
	Opening opening; 
	Element el;
	Sip sips[0];
	GenBeam gbHeader;

// vectors and other variables
	Vector3d vecX, vecY, vecZ;
	Point3d ptOrg;
	PLine plShape = _Map.getPLine("plShape"); // might be overwritten by opening	
	CoordSys cs;

	int bSplitSill = sNoYes.find(sSplitSill,1);
	int bBySelection = sReference == sBySelection;
//	return;
	// HSB-12162
	if(_Element.length()==1  && _Opening.length()==0)
	{ 
		if(_bOnElementConstructed)
		{ 
			// wall tsl
			// get openings and redestribute for opening
		// create TSL
			TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {}; Entity entsTsl[1]; Point3d ptsTsl[] = {_Pt0};
			int nProps[]={}; 
			double dProps[]={dHeaderX, dHeaderGap, dSillX, dGapTop, dGapBottom, dGapLeft, dGapRight};	
			String sProps[]={sSplitSill, sReference, "","",sPainterStream};
			Map mapTsl;	
			
			Element el = _Element[0];
			Opening openings[] = el.opening();
			
			for(int i=0;i<openings.length();i++)
			{
				Opening opening = openings[i];
				entsTsl[0]= opening;	
				ptsTsl[0]=opening.coordSys().ptOrg();
				// 
				tslNew.dbCreate(scriptName(), vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
						nProps, dProps, sProps,_kModelSpace, mapTsl);	
				tslNew.recalc();
				if(bDebug && tslNew.bIsValid())reportMessage("\n"+ scriptName() + " created for opening " +opening.element().number());
			}
			eraseInstance();
			return;
		}
		else 
		{ 
			return;
		}
	}
//	return;
// opening ref	
	if (_Opening.length()>0)
	{
		opening = _Opening[0];
		el = opening.element();
		
		_Entity.append(opening);
		
	// get opening shape	
		plShape = opening.plShape();
	}
// header ref	
	else if (_GenBeam.length()>0 && !_Map.hasPLine("plShape"))
	{
		gbHeader=_GenBeam[0];
		
	// get element or sips ref
		for (int i=0;i<_Entity.length();i++) 
		{ 
			Element _el = (Element)_Entity[i]; 
			if (_el.bIsValid())
			{
				el=_el;
				break;
			}
		}

		if (!el.bIsValid())
		{
			Sip _sips[0];
			for (int i=0;i<_Entity.length();i++) 
			{ 
				Sip sip = (Sip)_Entity[i]; 
				if (sip.bIsValid())
				{
					_sips.append(sip);
				}
			}
			sips=_sips;
		}
	}
// valid element ref
	if (el.bIsValid())
	{
		_Entity.append(el);
		sips= el.sip();
		cs = el.coordSys();
		vecX=el.vecX();
		vecY=el.vecY();
		vecZ=el.vecZ();
		ptOrg = el.ptOrg();
		assignToElementGroup(el, true, 0, 'C');
		setDependencyOnEntity(el);
		setDependencyOnEntity(opening);				
	}
// sip entity ref	
	else if (sips.length()>0)
	{
		Sip sip = sips[0];
		cs = sip.coordSys();
		vecX = cs.vecX();
		vecY = cs.vecY();
		vecZ = cs.vecZ();
		ptOrg = sip.ptCenSolid()-vecZ*.5*sip.dH();
	}
// individual sip ref	
	else if (_Sip.length()>0)
	{
		sips=_Sip;
		Sip sip = _Sip[0];
		cs = sip.coordSys();
		vecX = cs.vecX();
		vecY = cs.vecY();
		vecZ = cs.vecZ();
		ptOrg = sip.ptCenSolid()+vecZ*.5*sip.dH();	
		
	// guess wall orientation
		// as wall in model
		if (vecZ.isPerpendicularTo(_ZW) && vecX.isParallelTo(_ZW))
		{
			vecY=_ZW;
			vecX=vecY.crossProduct(vecZ);
		}
		// as wall in flat XY-World
		else if (vecZ.isParallelTo(_ZW) && (vecX.isParallelTo(_XW) || vecX.isParallelTo(_YW)))
		{
			vecX=_XW;
			vecY=_YW;
			vecZ=vecX.crossProduct(vecY);
		}
		cs=CoordSys(ptOrg, vecX, vecY, vecZ);
		
	// test shape, round shapes to be ignored
		Point3d pts[] = Line(ptOrg,vecY).orderPoints(plShape.vertexPoints(true));
		if ((pts.length()==3 && abs(vecY.dotProduct(pts[pts.length()-1]-pts[0]))<dEps) ||
			pts.length()<3)
			{
				reportMessage("\n" + scriptName() + ": " +T("|invalid opening shape purged.|"));
				eraseInstance();
				return;
			}
	}
	
//region filter entities
	// HSB-12162
	PainterDefinition pd;
	if(!bBySelection)
	{ 
		pd=PainterDefinition(sPainterCollection+"\\" + sReference);
		if (pd.bIsValid())
		{ 
			sips=pd.filterAcceptedEntities(sips);
		}
	}
//	return
	if (sips.length()>0)
	{
		Sip sip = sips[0];
		cs = sip.coordSys();
		vecX = cs.vecX();
		vecY = cs.vecY();
		vecZ = cs.vecZ();
		ptOrg = sip.ptCenSolid()-vecZ*.5*sip.dH();
		
		if(_Sip.length()>0)
		{ 
		// individual selection
			// guess wall orientation
			// as wall in model
			if (vecZ.isPerpendicularTo(_ZW) && vecX.isParallelTo(_ZW))
			{
				vecY=_ZW;
				vecX=vecY.crossProduct(vecZ);
			}
			else if(vecZ.isPerpendicularTo(_ZW))
			{ 
				vecY=_ZW;
				vecX=vecY.crossProduct(vecZ);
			}
			// as wall in flat XY-World
			else if (vecZ.isParallelTo(_ZW) && (vecX.isParallelTo(_XW) || vecX.isParallelTo(_YW)))
			{
				vecX=_XW;
				vecY=_YW;
				vecZ=vecX.crossProduct(vecY);
			}
			cs=CoordSys(ptOrg, vecX, vecY, vecZ);
		}
		if (el.bIsValid())
		{ 
		// HSB-12590:
			vecY =el.vecY();
			vecX = el.vecX();
			vecZ = el.vecZ();
			cs = CoordSys(sip.coordSys().ptOrg(), vecX, vecY, vecZ);
		}
		else
		{ 
			// if sip belongs to an element but element is not included in selection
			// take vectors from element
			Element elSip = sip.element();
			if(elSip.bIsValid())
			{ 
			// HSB-12590:
				vecY =elSip.vecY();
				vecX = elSip.vecX();
				vecZ = elSip.vecZ();
				cs = CoordSys(sip.coordSys().ptOrg(), vecX, vecY, vecZ);
			}
		}
	}
	vecX.vis(ptOrg,1);
	vecY.vis(ptOrg,3);
	vecZ.vis(ptOrg,150);
//End filter entities//endregion 
// get raw contour
	PlaneProfile ppRaw(cs);
	PlaneProfile ppOpening(cs); // HSB-10568
	
	if (sips.length()<1)
	{
		ppRaw.joinRing(el.plEnvelope(),_kAdd);	
		Opening openings[]=el.opening();
		for (int o=0;o<openings.length();o++) 
		{
			//ppRaw.joinRing(openings[o].plShape(),_kSubtract);	
			ppOpening.joinRing(openings[o].plShape(),_kAdd);
		}
	}
	else
	{
		for (int i=0;i<sips.length();i++) 
		{ 
			Sip sip = sips[i]; 
			ppRaw.joinRing(sip.plEnvelope(),_kAdd); 
			PLine plOpenings[]=sip.plOpenings();
			for (int o=0;o<plOpenings.length();o++) 
			{
				//ppRaw.joinRing(plOpenings[o],_kSubtract);	
				ppOpening.joinRing(plOpenings[o],_kAdd);
			}
		}
	}
	cs.vis(4);
	//ppRaw.transformBy(vecZ*U(200));
	//ppRaw.vis(2);

//region Apply gaps to opening rings
	{ 
		PLine rings[0];
		if (opening.bIsValid()) 
			rings.append(plShape);
		else 
			rings = ppOpening.allRings(true, false);
		ppOpening.removeAllRings();
		for (int r=0;r<rings.length();r++) 
		{ 
			PlaneProfile pp(cs);
			pp.joinRing(rings[r],_kAdd);
			
			Point3d pt = pp.ptMid()+vecX*.5*(dGapRight-dGapLeft)+vecY*.5*(dGapTop-dGapBottom);
			double dX = pp.dX() + dGapLeft + dGapRight;
			double dY = pp.dY() + dGapBottom + dGapTop;
			
			rings[r].createRectangle(LineSeg(pt - .5 * (vecX * dX + vecY * dY), pt + .5 * (vecX * dX + vecY * dY)), vecX, vecY);
			//rings[r].vis(2);
			ppOpening.joinRing(rings[r],_kAdd);
		}//next r
	}
	ppRaw.subtractProfile(ppOpening);
	ppRaw.vis(2);
//End Apply gaps to opening rings//endregion 
	
// header sill profiles
//	PlaneProfile ppHeader(cs);
	PlaneProfile ppHeader(Plane(ptOrg, vecZ));
	PlaneProfile ppHeaderAdd(Plane(ptOrg, vecZ));// needed for the Gap at header
	PlaneProfile ppSill(Plane(ptOrg, vecZ));
	PlaneProfile ppSillRemove(Plane(ptOrg, vecZ));// needed when sill continues same as opening, dSillX=0
	Point3d ptMid;
	
// get shape of header
	PLine plHeader;
	if (gbHeader.bIsValid())
	{
		ptMid=gbHeader.ptCenSolid();
		PlaneProfile pp=gbHeader.realBody().shadowProfile(Plane(ptOrg, vecZ));
		PLine plRings[] = pp.allRings();
		int bIsOp[] = pp.ringIsOpening();
		for (int r=0;r<plRings.length();r++)
			if (!bIsOp[r] && plRings[r].area()>plShape.area())
				plHeader=plRings[r];
		ppHeader.joinRing(plHeader,_kAdd);
		ppHeaderAdd = ppHeader;
		// modify ppHeaderAdd
		// define vecX same as header vecX
		Vector3d vecXHeader = gbHeader.vecX();
		Vector3d vecYHeader = gbHeader.vecY();
		if(abs(abs(gbHeader.vecZ().dotProduct(vecZ))-(gbHeader.vecZ().length()*vecZ.length()))>dEps)
		{ 
			// not parallel with vecZ of panel, valid vector
			vecYHeader = gbHeader.vecZ();
		}
		LineSeg lSeg = ppHeader.extentInDir(vecXHeader);
		Point3d pt1 = lSeg.ptStart() - dHeaderGap * vecXHeader;
		Point3d pt2 = lSeg.ptEnd() + dHeaderGap * vecXHeader;
		LineSeg lSegAdd(pt1, pt2);
		PLine rect;
		rect.createRectangle(lSegAdd, vecXHeader, vecYHeader);
		PlaneProfile ppAdd(rect);
//		ppHeader = ppAdd;
		ppHeader = PlaneProfile(cs);
		ppHeader.joinRing(rect, _kAdd);
		ppHeader.vis(2);
		ppHeaderAdd.vis(3);
	}
	
// opening driven
	else
	{
	// the opening shape
		PlaneProfile ppOpening(plShape);
		LineSeg seg = ppOpening.extentInDir(vecX); 
		seg.vis(3);
		double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
		double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
		ptMid = seg.ptMid();
		
	// split points
		Point3d pts[] = {seg.ptStart(), seg.ptEnd()};
		pts = Line(ptOrg,vecY).orderPoints(pts);
		if (pts.length()<2)
		{
			reportMessage("\n"+scriptName()+" "+T("|Unexpected error|"));
			eraseInstance();
			return;
		}	
		
	// get header contour
		if (dHeaderX>-.5*dX)
		{
			plHeader.createRectangle(LineSeg(ptMid-vecX*(.5*dX+dHeaderX),ptMid+vecX*(.5*dX+dHeaderX)+vecY*U(10e4)), vecX, vecY);
			plHeader.transformBy(vecY*vecY.dotProduct(pts[1]-ptMid));
			plHeader.transformBy(vecY*dGapTop);//HSB-10568
			
			ppHeader.joinRing(plHeader,_kAdd);
			ppHeader.intersectWith(ppRaw);
			ppHeader.vis(132);
			ppHeaderAdd = ppHeader;
			// modify ppHeaderAdd considering the Gap
			// get segment
			LineSeg lSeg = ppHeader.extentInDir(vecX);
			Point3d pt1 = lSeg.ptStart() - dHeaderGap * vecX;
			Point3d pt2 = lSeg.ptEnd() + dHeaderGap * vecX;
			LineSeg lSegAdd(pt1, pt2);
			lSegAdd.vis(5);
			PLine rect;
			rect.createRectangle(lSegAdd, vecX, vecY);
			PlaneProfile ppAdd(rect);
//			ppHeader = ppAdd;
			ppHeader = PlaneProfile(cs);
			ppHeader.joinRing(rect, _kAdd);
		}


	// get sill contour	
		PLine plSill;
		if (dSillX>-.5*dX && abs(dSillX)>dEps)
		{
			// rectangle below the opening
			plSill.createRectangle(LineSeg(ptMid-vecX*(.5*dX+dSillX),ptMid+vecX*(.5*dX+dSillX)-vecY*U(10e4)), vecX, vecY);
			plSill.transformBy(vecY*vecY.dotProduct(pts[0]-ptMid));
			plSill.transformBy(-vecY*dGapBottom);//HSB-10568
			ppSill.joinRing(plSill,_kAdd);
			ppSill.intersectWith(ppRaw);
			ppSillRemove = ppSill;
		}
		else if(abs(dSillX)<dEps)
		{ 
			// modify the planeprofile of the opening and take pline from this
			if(bDebug)reportMessage("\n"+ scriptName() + " enters OK...");
			// get the bottom segment of opening
			int nInd = -1;
			PlaneProfile ppOpeningCopy = ppOpening;
			
			Point3d ptsGripSeg[] = ppOpeningCopy.getGripEdgeMidPoints();
			double dMax = U(10e4);
			// loop all planeprofile segments
			for (int i=0;i<ptsGripSeg.length();i++) 
			{ 
				Point3d pt = ptsGripSeg[i];
				double d = vecY.dotProduct(pt);
				if(d<dMax)
				{ 
					dMax = d;
					nInd = i;
				}
			}//next i
			if(nInd<0)
			{ 
				reportMessage("\n"+scriptName()+" "+T("|Unexpected error|"));
				eraseInstance();
				return;
			}
			// modify ppOpening
			ppOpeningCopy.moveGripEdgeMidPointAt(nInd, - vecY * U(10e4));
//			ppOpeningCopy.vis(5);
			PLine pls[] = ppOpeningCopy.allRings();
			PLine pl = pls[0];
			plSill = pl;
			ppSill.joinRing(plSill,_kAdd);
			ppSillRemove.joinRing(plSill, _kAdd);
//			ppSillRemove.vis(1);
			PlaneProfile ppRawNoOpening(cs);
			PLine plPpRaws[] = ppRaw.allRings(true, false);
			int iIsOpening[] = ppRaw.ringIsOpening();
			
			for (int i=0;i<plPpRaws.length();i++) 
				ppRawNoOpening.joinRing(plPpRaws[i], _kAdd);
			
			ppSill.transformBy(-vecY * dGapBottom);//HSB-10568
			ppSill.intersectWith(ppRaw);
			ppSillRemove.intersectWith(ppRawNoOpening);
		}
		ppSill.vis(132);
	}
//return;

//region Write painter data to properties
//	if ((_kNameLastChangedProp==sReferenceName || sPainterStream.length()==0)&& pd.bIsValid())
	if (pd.bIsValid())
	{ 
		Map m;
		m.setString("Name", pd.name());
		m.setString("Type",pd.type());
		m.setString("Filter",pd.filter());
		m.setString("Format",pd.format());
		sPainterStream.set(m.getDxContent(true));
		_ThisInst.setCatalogFromPropValues(sLastInserted);
	}	
//End Write painter data to properties//endregion 


// display something in model mode with no sips present
	if (sips.length()<1)
	{
		Display dp(4);
		dp.draw(ppHeader);
		dp.draw(ppHeader, _kDrawFilled, 90);
		if (bSplitSill)
		{
			dp.draw(ppSill);
			dp.draw(ppSill, _kDrawFilled, 90);	
		}
	}
	else
	{
		// get the zone index of panels
		int iZoneSame = true;
		int iZonePanel = sips[0].myZoneIndex();
		for (int i=0;i<sips.length();i++) 
		{ 
			if(iZonePanel!=sips[i].myZoneIndex())
			{ 
				iZoneSame = false;
				break;
			}
		}//next i

		
	// get panels to be splitted
		Sip sips2split[0];
		Plane pn(ptMid, vecX);
		for (int i=0;i<sips.length();i++) 
		{ 
			PLine pl= sips[i].plEnvelope();
			if (pl.intersectPoints(pn).length()>0)
				sips2split.append(sips[i]);
		}
		if(bDebug)reportMessage("\n"+ scriptName() + " collected " + sips2split.length() + " sips to be split.");
		
	// split panels at center line and get style
		String sStyle;	
		Sip _sips[0], sipsSplit[0];
		_sips.append(sips2split);
		for (int i=0;i<sips2split.length();i++)
		{
			Sip sip = sips2split[i];
			if (sStyle.length()<1)
				sStyle=sip.style();
			
		// split if not in header mode
			if (!gbHeader.bIsValid())
			{
				sipsSplit= sip.dbSplit(pn,0);
				_sips.append(sipsSplit);
				
				if(bDebug)reportMessage("\n"+ scriptName() + " split in 2 ...");
				if (bDebug)reportMessage("\n" + scriptName() + "_sips.length() " + _sips.length());
			}
		}
		if(bDebug)reportMessage("\n"+ scriptName() + " " + _sips.length() + " sips as split result, style " + sStyle);
	
	//region subtract offseted opening contour
		if (abs(dGapBottom)+abs(dGapTop)+abs(dGapLeft)+ abs(dGapRight)>dEps)
		{ 
			PLine rings[] = ppOpening.allRings(true, false);
			for (int i=0;i<_sips.length();i++) 
				for (int r=0;r<rings.length();r++) 
					_sips[i].addOpening(rings[r], false); 
		}
	//End subtract offseted opening contour//endregion 
	
	// cut out header and create fillings
		PLine plRings[] = ppHeader.allRings();// all rings from ppheader
		PLine plRingsAdd[] = ppHeaderAdd.allRings();
		int bIsOp[] = ppHeader.ringIsOpening();
		for (int r=0;r<plRings.length();r++)
		{
			if(bIsOp[r] || plRings[r].area()<pow(dEps,2)) continue; // should not happen anyway	
		
		// cut out
			Sip sipsHeader[0];
			for (int i=0;i<_sips.length();i++)
				sipsHeader.append(_sips[i].addOpening(plRings[r], false));// apply opening of header to each panel
			
		// append result to the list of _sips
			for (int i=0;i<sipsHeader.length();i++)
				if (_sips.find(sipsHeader[i])<0)
					_sips.append(sipsHeader[i]);
			
		// do not create filling if header has been selected
			if (gbHeader.bIsValid())continue;		
			
		// create filling , set X and woodGrainDirection by element or source
			Sip sipNew;
			sipNew.dbCreate(plRingsAdd[r], sStyle,1);
			if (el.bIsValid())
			{
				sipNew.assignToElementGroup(el,true,0,'Z');
				if(iZoneSame)sipNew.assignToElementGroup(el,true,iZonePanel,'Z');
				sipNew.setXAxisDirectionInXYPlane(vecX);
				sipNew.setWoodGrainDirection(vecX);	
				if(sips.length()>0)
				{ 
					sipNew.setColor(sips[0].color());
					sipNew.setName(sips[0].name());
					sipNew.setMaterial(sips[0].material());
					sipNew.setGrade(sips[0].grade());
					sipNew.setInformation(sips[0].information());
					sipNew.setLabel(sips[0].label());
					sipNew.setSubLabel(sips[0].subLabel());
				}
			}
			else if (sipsHeader.length()>0)
			{
				sipNew.assignToGroups(sipsHeader[0],'Z');
				sipNew.setXAxisDirectionInXYPlane(sipsHeader[0].vecX());
				sipNew.setWoodGrainDirection(sipsHeader[0].woodGrainDirection());
				
				sipNew.setColor(sipsHeader[0].color());
				sipNew.setName(sipsHeader[0].name());
				sipNew.setMaterial(sipsHeader[0].material());
				sipNew.setGrade(sipsHeader[0].grade());
				sipNew.setInformation(sipsHeader[0].information());
				sipNew.setLabel(sipsHeader[0].label());
				sipNew.setSubLabel(sipsHeader[0].subLabel());
			}
		}
		if(bDebug)reportMessage("\n"+ scriptName() + " " + _sips.length() + " sips as split header result, style " + sStyle);

	// manipulate sill and optionally create fillings
		ppSillRemove.shrink(-dEps);
		// HSB-12604
		ppSillRemove.shrink(dEps);
		PlaneProfile ppSillShrink = ppSill;
		ppSillShrink.shrink(dEps);
		ppSillRemove.vis(1);
		plRings = ppSill.allRings();// array of all plines of ppSill
		PLine plRingsRemove[] = ppSillRemove.allRings();
		bIsOp = ppSill.ringIsOpening();// array all openings of ppSill
		
		if(bDebug)reportMessage("\n"+ scriptName() + "plRings.length() "+plRings.length());
		
		
		for (int r=0;r<plRings.length();r++)
		{
			if(bIsOp[r] || plRings[r].area()<pow(dEps,2)) continue; // should not happen anyway	
		
		// cut out
			if (bSplitSill)
			{
				Sip sipsSill[0];
				for (int i=0;i<_sips.length();i++)
					sipsSill.append(_sips[i].addOpening(plRingsRemove[r], false));
				if (sipsSill.length()<1)
					sipsSill.append(_sips);
				if(bDebug)reportMessage("\n"+ scriptName() + " " + sipsSill.length() + " sips of opening add sill result, style " + sStyle);
				
				
			// create filling, set X and woodGrainDirection by source
				if (sipsSill.length()>0)
				{
					Sip sipNew;
					sipNew.dbCreate(plRings[r], sStyle,1);
					if (el.bIsValid())
						sipNew.assignToElementGroup(el,true,0,'Z');
					if(iZoneSame)sipNew.assignToElementGroup(el,true,iZonePanel,'Z');
					sipNew.setXAxisDirectionInXYPlane(sipsSill[0].vecX());
					sipNew.setWoodGrainDirection(sipsSill[0].woodGrainDirection());
					
					sipNew.setColor(sipsSill[0].color());
					sipNew.setName(sipsSill[0].name());
					sipNew.setMaterial(sipsSill[0].material());
					sipNew.setGrade(sipsSill[0].grade());
					sipNew.setInformation(sipsSill[0].information());
					sipNew.setLabel(sipsSill[0].label());
					sipNew.setSubLabel(sipsSill[0].subLabel());
				}				
			}
			
		// re-join overlapping
			else
			{
				Sip sipJoin;
				//if(bDebug)reportMessage("\n"+ scriptName() + " " + _sips.length() + " sips to be joined");
				for (int i=0;i<_sips.length();i++)
				{
					Sip sip = _sips[i];
					if (!sip.bIsValid())continue;
					double d = sip.solidLength();
					PlaneProfile pp(sip.plEnvelope());
//					pp.intersectWith(ppSill);
					pp.intersectWith(ppSillShrink);
					if (pp.area()>pow(dEps,2))
					{
						if (!sipJoin.bIsValid())
							sipJoin=sip;
						else	
							sipJoin.dbJoin(sip);
					}	
				}				
			}
		}
		
	// job done
		eraseInstance();
		return;

	}
	
#End
#BeginThumbnail
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
+)9$.0#6[110!_]FU
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
      <str nm="COMMENT" vl="HSB-12590: find upward orientation if panel vertical" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="12" />
      <str nm="DATE" vl="7/22/2021 5:21:28 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12590: if panel belongs to an element take orientation vectors from the element" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="11" />
      <str nm="DATE" vl="7/16/2021 4:23:33 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12590: Use element vectors when panel is part of an element" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="7/14/2021 9:00:56 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12162: add painter filter; tsl can be attached to an element definition" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="6/11/2021 2:27:20 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End