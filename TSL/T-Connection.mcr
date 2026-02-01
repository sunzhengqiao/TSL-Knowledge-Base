#Version 8
#BeginDescription
#Versions
1.5 30.08.2023 HSB-19830: Make hasTConnection test only if male axis intersects female beam 
1.4 15.05.2023 HSB-18973 property value renamed, debug improved

1.3 12.05.2023 HSB-18801: Enter wait state if no element beam found (beams without panhand state) 
1.2 18.04.2023 HSB-18551: Support copying of beam with TSL instance 
1.1 21.02.2023 HSB-18059: use quader to get the envelope of female beam 
1.0 22.12.2022 HSB-17255: Initial 


This tsl creates a T-Connection between male and female beams
TSL will try to create beampacks from the selected male beams
It will create one TSL instance for each beampack





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords T,T-connection,beampack,pack
#BeginContents
//region <History>
// #Versions
// 1.5 30.08.2023 HSB-19830: Make hasTConnection test only if male axis intersects female beam Author: Marsel Nakuci
// 1.4 15.05.2023 HSB-18973 property value renamed, debug improved , Author Thorsten Huck
// 1.3 12.05.2023 HSB-18801: Enter wait state if no element beam found (beams without panhand state) Author: Marsel Nakuci
// 1.2 18.04.2023 HSB-18551: Support copying of beam with TSL instance Author: Marsel Nakuci
// 1.1 21.02.2023 HSB-18059: use quader to get the envelope of female beam Author: Marsel Nakuci
// 1.0 22.12.2022 HSB-17255: Initial Author: Marsel Nakuci

/// <insert Lang=en>
/// Insert properties in the dialog box
/// Select male beams, select female beams
/// 
/// </insert>

// <summary Lang=en>
// This tsl creates a T-Connection between male and female beams
// TSL will try to create beampacks from the selected male beams
// It will create one TSL instance for each beampack
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "T-Connection")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion
	
//region Constants 
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
//end Constants//endregion
	
//region Properties
	// painter stream for storing painter definition in the catalog
	String sPainterMaleStreamName=T("|PainterMaleStream|");	
	PropString sPainterMaleStream(nStringIndex++, "", sPainterMaleStreamName);
	sPainterMaleStream.setDescription(T("|Defines the PainterMaleStream|"));
	sPainterMaleStream.setCategory(category);
	sPainterMaleStream.setReadOnly(bDebug?0:_kHidden);
	
	String sPainterFemaleStreamName=T("|PainterFemaleStream|");	
	PropString sPainterFemaleStream(nStringIndex++, "", sPainterFemaleStreamName);
	sPainterFemaleStream.setDescription(T("|Defines the PainterFemaleStream|"));
	sPainterFemaleStream.setCategory(category);
	sPainterFemaleStream.setReadOnly(bDebug?0:_kHidden);
	
	// list of painters
	String sPainters[] = PainterDefinition().getAllEntryNames().sorted();
    String sPainterDefault = T("<|Disabled|>");
    sPainters.insertAt(0, sPainterDefault);
    
	// on insert read catalogs to copy / create painters based on catalog entries
	if (_bOnInsert || _bOnElementConstructed || _bOnDbCreated)
	{
		// HSB-15906: collect streams	
		String streams[0];
		String sScriptOpmName = bDebug ? "T-Connection" : scriptName();
		String entries[] = TslInst().getListOfCatalogNames(sScriptOpmName);
		int iStreamIndices[] ={ 0, 1};//index 0 and 1 of the stream property
		for (int i = 0; i < entries.length(); i++)
		{
			String& entry = entries[i];
			Map map = TslInst().mapWithPropValuesFromCatalog(sScriptOpmName, entry);
			Map mapProp = map.getMap("PropString[]");
			
			for (int j = 0; j < mapProp.length(); j++)
			{
				Map m = mapProp.getMap(j);
				int index = m.getInt("nIndex");
				String stream = m.getString("strValue");
				if (iStreamIndices.find(index) >- 1 && streams.findNoCase(stream ,- 1) < 0)
				{
					streams.append(stream);
				}
			}//next j
		}//next i
		
		for (int i = 0; i < streams.length(); i++)
		{
			String& stream = streams[i];
			String _painters[0];
			_painters = sPainters;
			if (stream.length() > 0)
			{
				// get painter definition from property string	
				Map m;
				m.setDxContent(stream , true);
				String name = m.getString("Name");
				String type = m.getString("Type").makeUpper();
				String filter = m.getString("Filter");
				String format = m.getString("Format");
				// create definition if not present	
				//				if (m.hasString("Name") && m.hasString("Type") && name.find(sPainterCollection,0,false)>-1 &&
				//					_painters.findNoCase(name,-1)<0)
				if (m.hasString("Name") && m.hasString("Type") && _painters.findNoCase(name,- 1) < 0)
				{
					PainterDefinition pd(name);
					if ( ! pd.bIsValid())
					{
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
	}
	
	// painter for male beams
	category=T("|Painter|");
	String sPainterMaleName=T("|Male beams|");
	PropString sPainterMale(nStringIndex++,sPainters,sPainterMaleName);	
	sPainterMale.setDescription(T("|Defines the PainterMale|"));
	sPainterMale.setCategory(category);
	
	String sPainterFemaleName=T("|Female beams|");
	PropString sPainterFemale(nStringIndex++,sPainters,sPainterFemaleName);	
	sPainterFemale.setDescription(T("|Defines the PainterFemale|"));
	sPainterFemale.setCategory(category);
	
	String sDistanceName=T("|Depth|")+"/"+T("|Distance|");	
	PropDouble dDistance(nDoubleIndex++, U(0), sDistanceName);	
	dDistance.setDescription(T("|Defines the Distance|"));
	dDistance.setCategory(category);
	
	String sGapName=T("|Side Gap|");	
	PropDouble dGap(nDoubleIndex++, U(0), sGapName);
	dGap.setDescription(T("|Defines the Gap|"));
	dGap.setCategory(category);
	
	String sToolAlignmentName=T("|Tool Alignment|");
	String sToolAlignments[]={T("|Female beam|"),T("|Male beam|")};
	PropString sToolAlignment(nStringIndex++,sToolAlignments,sToolAlignmentName);	
	sToolAlignment.setDescription(T("|Defines if the tool aligns with the coordinate systems of the female or male beam|"));
	sToolAlignment.setCategory(category);
//End Properties//endregion
	
//region mapIO: support property dialog input via map on element creation
	{
		int bHasPropertyMap=_Map.hasMap("PROPSTRING[]") 
			&& _Map.hasMap("PROPDOUBLE[]");
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
			setPropValuesFromMap(_Map);
			_Map = Map();
		}
	}
//End mapIO: support property dialog input via map on element creation//endregion 
	
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
				setPropValuesFromCatalog(sLastInserted);
		}
	// standard dialog
		else
			showDialog();
		
	// prompt selection of male, female beams
	// prompt for beams
		Beam beamsMale[0];
		Entity entMales[0];
		Element elements[0];
		PrEntity ssMale(T("|Select male beam(s) or element(s)|"), Beam());
		ssMale.addAllowedClass(Element());
		if (ssMale.go())
		{
//			entMales.append(ssMale.set());
			beamsMale=ssMale.beamSet();
			elements=ssMale.elementSet();
			for (int i=0;i<beamsMale.length();i++)
			{ 
				entMales.append(beamsMale[i]);
			}//next i
		}
		
		int bElementMode=elements.length()>0;
		
	// prompt for beams
		Beam beamsFemale[0];
		Entity entFemales[0];
		
		if(!bElementMode)
		{ 
			PrEntity ssFemale(T("|Select female beams|"), Beam());
			if (ssFemale.go())
				entFemales.append(ssFemale.set());
		}
		if(sPainterMale!=sPainterDefault)
		{ 
			PainterDefinition pDm(sPainterMale);
			entMales=pDm.filterAcceptedEntities(entMales);
		}
		if(sPainterFemale!=sPainterDefault)
		{ 
			PainterDefinition pDm(sPainterFemale);
			entFemales=pDm.filterAcceptedEntities(entFemales);
		}
		
	// create TSL
		TslInst tslNew; Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
		GenBeam gbsTsl[]={}; Entity entsTsl[]={}; Point3d ptsTsl[]={_Pt0};
		int nProps[]={};
		double dProps[]={dDistance,dGap};
		String sProps[]={sPainterMaleStream,sPainterFemaleStream,
			sPainterMale,sPainterFemale,sToolAlignment};
		Map mapTsl;
		
		if(bElementMode)
		{ 
		// Element mode
			for (int i=0;i<elements.length();i++)
			{ 
				entsTsl.setLength(0);
				entsTsl.append(elements[i]);
				ptsTsl.setLength(0);
				ptsTsl.append(elements[i].ptOrg());
				tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
					ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
			}//next i
		}
		else
		{ 
		// Beam mode
			mapTsl.setEntityArray(entMales, false, "males", "males", "males");
			mapTsl.setEntityArray(entFemales, false, "females", "females", "females");
			tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,ptsTsl, 
					nProps,dProps,sProps,_kModelSpace,mapTsl);
		}
		eraseInstance();
		return;
	}
// end on insert	__________________//endregion
//	return;
	
int nMode=-1;
Beam bmMales[0], bmFemales[0];
if(_Beam.length()>1)
{ 
// beam mode
	nMode=0;
// continue calculation below in mode=0
}
else if(_Element.length()>0)
{ 
// element mode mode 1
	// basic information
	Element el=_Element[0];
	CoordSys cs=el.coordSys();
	Point3d ptOrg=el.ptOrg();
	Vector3d vecX=el.vecX();
	Vector3d vecY=el.vecY();
	Vector3d vecZ=el.vecZ();
	assignToElementGroup(el,true, 0,'E');// assign to element tool sublayer
	
	Beam beams[] = el.beam();
// HSB-18801:make sure the element has beams that are not panhand
	Beam beamsNotPanhand[0];
	for (int ib=0;ib<beams.length();ib++) 
	{ 
		if(!beams[ib].panhand().bIsValid())
		{ 
			beamsNotPanhand.append(beams[ib]);
		}
	}//next ib
// HSB-18801:Wait state
	if (beams.length()<1 || beamsNotPanhand.length()<1)
	{ 
		setExecutionLoops(2);
		Display dp(0);
		dp.textHeight(U(50));
		dp.draw(scriptName(), el.segmentMinMax().ptMid(), vecX, vecY, 0, 0);
		return;
	}
	
	bmMales = beams;
	bmFemales = bmMales;
	nMode = 1;
	// do the distribution below in mode>0
}
else
{ 
// beams are provided in the _Map
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
	
	int nNumMale=bmMales.length();
	int nNumFemale=bmFemales.length();
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
	// for mode=2 do the distribution below in mode>0
}
//return;
// create individual instances in mode 1 and 2
if (nMode>0)
{
	//bDebug = true;
	// prepare tsl cloning
	TslInst tslNew;
	Vector3d vecXTsl=_XE; Vector3d vecYTsl=_YE;
	GenBeam gbsTsl[]={};
	Entity entsTsl[]={};
	Point3d ptsTsl[]={};
	int nProps[]={};
	double dProps[]={dDistance,dGap};
	String sProps[]={sPainterMaleStream,sPainterFemaleStream,
	sPainterMale,sPainterFemale};
	//String sProps[]={sRules[0], "",""};
	Map mapTsl;
	String sScriptname=scriptName();
	
	Entity entMales[0], entFemales[0];
	if(sPainterMale!=sPainterDefault)
	{ 
		PainterDefinition pDm(sPainterMale);
		entMales=pDm.filterAcceptedEntities(entMales);
	}
	if(sPainterFemale!=sPainterDefault)
	{ 
		PainterDefinition pDm(sPainterFemale);
		entFemales=pDm.filterAcceptedEntities(entFemales);
	}
	
	for (int i=0;i<bmMales.length();i++) 
	{ 
		entMales.append(bmMales[i]);
	}//next i
	for (int i=0;i<bmFemales.length();i++) 
	{ 
		entFemales.append(bmFemales[i]);
	}//next i
	
	if(sPainterMale!=sPainterDefault)
	{ 
		PainterDefinition pDm(sPainterMale);
		entMales=pDm.filterAcceptedEntities(entMales);
	}
	if(sPainterFemale!=sPainterDefault)
	{ 
		PainterDefinition pDm(sPainterFemale);
		entFemales=pDm.filterAcceptedEntities(entFemales);
	}
	bmMales.setLength(0);
	bmFemales.setLength(0);
	for (int i=0;i<entMales.length();i++) 
	{ 
		Beam bmI=(Beam)entMales[i];
		if(bmMales.find(bmI)<0)
			bmMales.append(bmI);
	}//next i
	for (int i=0;i<entFemales.length();i++) 
	{ 
		Beam bmI=(Beam)entFemales[i];
		if(bmFemales.find(bmI)<0)
			bmFemales.append(bmI);
	}//next i
	
	// create all possible beam packs of male beams
	String strDifferentiators[0];
	for (int i=0;i<bmMales.length();i++) 
	{ 
	// no particular differentiator used
		strDifferentiators.append("");
	}//next i
	EntityCollection bmPacks[]=Beam().composeBeamPacks(bmMales,strDifferentiators);
	
//	return;
// distribute according to bmPacks
	for (int i=0;i<bmPacks.length();i++) 
	{ 
	// consider connection on both sides of the beam pack
		EntityCollection bmPackI=bmPacks[i];
		Beam bmFemalesThis[0];
		Beam beamMaleThis[]=bmPackI.beam();
		for (int ib=0;ib<beamMaleThis.length();ib++) 
		{ 
		// possible female beams that can create a T-connection
			Beam beamsCaps[]=beamMaleThis[ib].filterBeamsCapsuleIntersect(bmFemales);
			for (int f=beamsCaps.length()-1;f>=0;f--)
			{
				Beam& bm=beamsCaps[f];
				// HSB-19830 make the hasTConnection test only if the axis of male beam intersects the body of female beam
				Point3d ptInter;
				if(!bm.envelopeBody().rayIntersection(beamMaleThis[ib].ptCen(),beamMaleThis[ib].vecX(),ptInter))
				{ 
					continue;
				}
				//non t-connections
				if (!beamMaleThis[ib].hasTConnection(beamsCaps[f],dDistance,true))
				{
					beamsCaps.removeAt(f);
				}
			}
			
			for (int ib=beamsCaps.length()-1;ib>=0;ib--) 
			{ 
				if(bmFemalesThis.find(beamsCaps[ib])<0)
				{ 
				// collect all female beams for this pack of beams
					bmFemalesThis.append(beamsCaps[ib]);
				}
//				int nIndF=bmFemales.find(beamsCaps[ib]);
//				if(nIndF>-1)
//				{ 
//				// remove it from list of all female beams
//					bmFemales.removeAt(nIndF);
//				}
			}//next ib
		// remove from bmMales
			int nBm=bmMales.find(beamMaleThis[ib]);
			if(nBm>-1)
				bmMales.removeAt(nBm);
		}//next ib
	// create TSL
//		TslInst tslNew; Vector3d vecXTsl=_XW; Vector3d vecYTsl= _YW;
//		GenBeam gbsTsl[]={}; Entity entsTsl[]={}; Point3d ptsTsl[]={_Pt0};
//		int nProps[]={}; double dProps[]={}; String sProps[]={};
//		Map mapTsl;
		
		Beam beamsPack[]=bmPacks[i].beam();
		
		gbsTsl.setLength(0);
		Entity entsPack[0];
		Entity entsFemale[0];
		for (int jb=0;jb<beamsPack.length();jb++) 
		{ 
			gbsTsl.append(beamsPack[jb]);
			entsPack.append(beamsPack[jb]);
		}//next jb
		for (int jb=0;jb<bmFemalesThis.length();jb++) 
		{ 
			gbsTsl.append(bmFemalesThis[jb]);
			entsFemale.append(bmFemalesThis[jb]);
		}//next jb
		mapTsl.setInt("Pack",true);
		mapTsl.setEntityArray(beamsPack,true,"entsPack","entsPack","entsPack");
		mapTsl.setEntityArray(bmFemalesThis,true,"entsFemales","entsFemales","entsFemales");
	// pack TSLs
		tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
				ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
	}//next i
	mapTsl.setInt("Pack",false);
	// create the remaining connections of male-female
// HSB-16469: dont allow 2 t-connection maleb1-femaleb2 and maleb2-femaleb1
// when T-Connection is inserted it stretches male beam and can tur it to a valid connection of female-male
	Beam bmMalesCreated[0], bmFemalesCreated[0];
// create instances on beam by beam(s) base
// this is loooking for potential t-connected beams and supports multiple female beams connected with a male beam
	for (int m=0; m<bmMales.length(); m++)
	{
		Beam bmMale=bmMales[m];
		if (!bmMale.bIsValid())continue;
		Point3d ptCenM=bmMale.ptCenSolid();
		Vector3d vecXM=bmMale.vecX();
		Element el=bmMale.element();
		
	// filter capsules
		Beam beamsCaps[] = bmMale.filterBeamsCapsuleIntersect(bmFemales);
		
	// remove
		for (int f=beamsCaps.length()-1; f>= 0; f--)
		{
			Beam& bm=beamsCaps[f];
			int nType=bm.type();
			//				reportNotice("\n" + nType + " =" + _BeamTypes[nType]);
			//				bm.envelopeBody().vis(f);
			//non t-connections
			if (!bmMale.hasTConnection(beamsCaps[f],dDistance,true))
			{
				beamsCaps.removeAt(f);
			}
		}
		
	/// loop positive and negative male direction
		for (int x=0; x<2; x++)
		{
			ptsTsl.setLength(0);
			gbsTsl.setLength(0);
	    	gbsTsl.append(bmMale);
	    	
	    	Vector3d vecDir=x==0?vecXM:-vecXM;
	    	
	    // collect all remaining capsules connecting on this side
			for (int f=beamsCaps.length()-1; f>=0 ; f--)  
			{
				Beam bm=beamsCaps[f];
				Point3d pt;
				int bOk=Line(ptCenM,vecDir).hasIntersection(Plane(bm.ptCenSolid(),bm.vecD(vecDir)),pt);
				if (bOk && vecDir.dotProduct(pt-ptCenM)>0)
				{ 
					if(bDebug)reportMessage("\n"+ scriptName() + " appending beam " + bm.handle() + " in direction of " + vecDir);
					
					gbsTsl.append(bm);
					if (bDebug)
					{
						bmMale.envelopeBody().vis(3);
						bm.envelopeBody().vis(4);
					}
					if (ptsTsl.length()<1)ptsTsl.append(pt);
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
		}
	}
	if (!bDebug)eraseInstance();
	return;
}

// calculation mode
sPainterMale.setReadOnly(_kHidden);
sPainterFemale.setReadOnly(_kHidden);
// HSB-18551
setKeepReferenceToGenBeamDuringCopy(_kAllBeams);
_ThisInst.setAllowGripAtPt0(false);
int nPack=_Map.getInt("Pack");
if(nPack)
{ 
// calculation for nPack
	Entity entsPack[]=_Map.getEntityArray("entsPack","entsPack","entsPack");
	Entity entsFemales[]=_Map.getEntityArray("entsFemales","entsFemales","entsFemales");
	
	bmMales.setLength(0);
	bmFemales.setLength(0);
	for (int i=0;i<entsPack.length();i++) 
	{ 
		Beam bm=(Beam) entsPack[i];
		if(bm.bIsValid() && bmMales.find(bm)<0)
			bmMales.append(bm);
	}//next i
	for (int i=0;i<entsFemales.length();i++) 
	{ 
		Beam bm=(Beam) entsFemales[i];
		if(bm.bIsValid() && bmFemales.find(bm)<0)
			bmFemales.append(bm);
	}//next i
	
// check that the beams are part of the beammpack	
	
// do the tooling
	for (int i=0;i<bmMales.length();i++) 
	{ 
		Beam bm0=bmMales[i];
		// set dependency
		if(_Entity.find(bm0)<0)
		{ 
			_Entity.append(bm0);
		}
		setDependencyOnEntity(bm0);
		for (int j=0;j<bmFemales.length();j++) 
		{ 
			Beam bm1=bmFemales[j];
			if(_Entity.find(bm1)<0)
			{ 
				_Entity.append(bm1);
			}
			setDependencyOnEntity(bm1);
		// 
			Point3d ptCen0=bm0.ptCenSolid();
			Point3d ptCen1=bm1.ptCenSolid();
			// vecZ is the plane of female bm1 where bm0 will touch
			Vector3d vecZ=bm1.vecD(bm0.vecX());// vector of female in direction of male beam
			if (vecZ.dotProduct(ptCen1-ptCen0)<0)vecZ*=-1;// vecZ pointing toward the female beam
			Vector3d vecX=bm1.vecD(bm1.vecX().crossProduct(vecZ));// vector normal with the plane of 2 beams
			// right hand side vectors
			Vector3d vecY=vecX.crossProduct(-vecZ);
			
			int nToolAlignment=sToolAlignments.find(sToolAlignment);
			if (nToolAlignment==1)
			{ 
			// alignment follows the male beam
				Vector3d vecX_=bm0.vecD(vecX);
				Vector3d vecOther=vecX_.crossProduct(bm0.vecX());
			// must vecX be at intersection of 2 planes vecZ and vecOther
				vecX = vecZ.crossProduct(vecOther);
				if(vecX.dotProduct(vecX_)<0)vecX*=-1;
				
			//	// project vecX to the plane of vecZ
			//	vecX=vecZ.crossProduct(vecX.crossProduct(vecZ));
				vecY=vecX.crossProduct(-vecZ);
			////vecX.vis(ptRef, 1);
			}
			vecX.normalize();
			vecY.normalize();
			vecZ.normalize();
			Line(ptCen0,vecZ).hasIntersection(Plane(ptCen1-vecZ*.5*bm1.dD(vecZ),vecZ),_Pt0);
			vecX.vis(_Pt0,1);
			vecY.vis(_Pt0,3);
			vecZ.vis(_Pt0,150);
			
			Vector3d vecX0=bm0.vecX();
			if (vecX0.dotProduct(vecZ)<0)vecX0*=-1;
			
			// vector normal with the plane of T-connection
			Vector3d vecNormal=bm0.vecX().crossProduct(bm1.vecX());
			// displace the display to the mid of female
			Vector3d vecDisplacement=(ptCen1-ptCen0).dotProduct(vecNormal)*vecNormal;
			
			// potential element link
			Element el=_Beam[1].element();
			
			// assignment
			if (el.bIsValid())
				assignToElementGroup(el,true,0,'T');
			else
				assignToGroups(bm1,'T');
			
			// stretch male
			_Pt0.vis(5);
			// 
			Vector3d vecXcut=bm0.vecX();
			if (vecZ.dotProduct(bm0.vecX())<0)vecXcut *=-1;
			Line lnMale(bm0.ptCen(),bm0.vecX());
			// plane of stretch of male beam
			Plane pnStretch(_Pt0+vecZ*dDistance,vecZ);
			// HSB-16850
			Point3d ptIntersect;
			int nIntersect=lnMale.hasIntersection(pnStretch, ptIntersect);
			if(!nIntersect)
			{ 
				reportMessage("\n"+scriptName()+" "+T("|Unexpected|"));
				eraseInstance();
				return;
			}
			
			//ptIntersect.vis(3);
			// check all for corner points of the male beam that fall in the stretching plane
			Point3d ptIntersectMax=ptIntersect;
			for (int iCorner=0;iCorner<2;iCorner++) 
			{ 
				int iIndexI=-1+iCorner*2;
				for (int jCorner=0;jCorner<2;jCorner++) 
				{ 
					int iIndexJ=-1+jCorner * 2;
					int jCorner=-1+jCorner * 2;
					Line ln(bm0.ptCen()+.5*iIndexI*bm0.vecY()*bm0.dD(bm0.vecY())
									+.5*iIndexJ*bm0.vecZ()*bm0.dD(bm0.vecZ()), bm0.vecX());
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
			ptIntersectMax.vis(2);
			vecXcut.vis(ptIntersectMax);
			//Body bd0 = bm0.envelopeBody(false,true);
			//bd0.transformBy(vecX * U(50));
			//bd0.vis(6);
			//bd0.transformBy(-vecX * U(50));
			//Body bd0 = bm0.envelopeBody();
			vecXcut=vecZ;
			Cut cutStretch(ptIntersectMax, vecXcut);
			
			if(!bDebug)
			{
			// stretch on insert
				bm0.addTool(cutStretch,bDebug?0:1);
			}
			
			// Trigger Reset
//			String sTriggerReset = T("|Reset + Erase|");
//			addRecalcTrigger(_kContext, sTriggerReset );
//			if (_bOnRecalc && (_kExecuteKey==sTriggerReset || _kExecuteKey==sDoubleClick))
//			{
//				Cut cut(_Pt0, vecZ);
//				bm0.addToolStatic(cut, 1);
//				eraseInstance();
//				return;
//			}
			
			// Display
			Display dp(150);
			
			// female tooling
			if (dDistance>dEps)
			{
				Body bdMale=bm0.envelopeBody(false,true);
				Body bdFemale;
				for (int i=0;i<bmFemales.length();i++)
				{ 
				    Beam bmFemale=bmFemales[i];
				    bdFemale.addPart(bmFemale.envelopeBody(false,true));
				}
				bdFemale.vis(4);
				Body bdTool=bdMale;
				bdTool.intersectWith(bdFemale);
				Body bdSubtract(_Pt0+vecZ*dDistance,vecX,vecY,vecZ,U(10e3),U(10e3),U(10e3),0,0,1);
			//	bdSubtract.vis(2);
				bdTool.subPart(bdSubtract);
				bdTool.vis(6);
				PlaneProfile ppStretch=bdTool.shadowProfile(pnStretch);
			//	PlaneProfile pp0=bdTool.shadowProfile(Plane(_Pt0,vecZ));
			//	PlaneProfile ppTool=pp0;
			//	ppTool.unionWith(ppStretch);
			//	ppTool.vis(2);
				PlaneProfile ppTool=bdTool.shadowProfile(Plane(_Pt0,vecZ));
				ppTool.shrink(-dGap);
			// tool size
				LineSeg seg=ppTool.extentInDir(vecX);
				seg.vis(1);
			//	seg.transformBy(vecDisplacement);
				double dX = bdFemale.lengthInDirection(vecX);//)abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
				if (nToolAlignment==1)
				{
			//		dX=bdTool.lengthInDirection(vecX);
					dX=abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
				}
				double dY=abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
				if (nToolAlignment==1)
				{
			//		dY=bdTool.lengthInDirection(vecY);
					dY=abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
				}
				double dZ=dDistance;
				Point3d ptRef=seg.ptMid();
				ptRef.vis(6);
				
			// BeamCut
				if (dX>dEps && dY>dEps && dZ>dEps)
				{
					vecX.vis(ptRef, 1);
					vecY.vis(ptRef, 5);
					vecZ.vis(ptRef, 3);
					PlaneProfile ppFemale = bdFemale.shadowProfile(Plane(ptRef, vecX));
			//		ppFemale.vis(4);
					Body bdBc(ptRef, vecX, vecY, vecZ, dX*2, dY, dZ*2, 0, 0, 0);
					PlaneProfile ppBc = bdBc.shadowProfile(Plane(ptRef, vecX));
					ppBc.vis(6);
					BeamCut bc;
					bc = BeamCut (ptRef, vecX, vecY, vecZ, dX*2,dY,dZ*2, 0, 0, 0);
					bc.cuttingBody().vis(3);
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
//					bc.addMeToGenBeamsIntersect(bmFemales);
					bm1.addTool(bc);
			
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
//				Body bdIntersect=bdTool;
//				if(!bdIntersect.hasIntersection(bdFemale))continue;
				
				dp.draw(PLine(ptRef, ptRef+vecZ*dDistance));
				dp.color(3);
				dp.draw(PLine(ptRef-.5*vecY*dY, ptRef+.5*vecY*dY));
				dp.color(1);
				dp.draw(PLine(ptRef-.5*vecX*dX, ptRef+.5*vecX*dX));
			}
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
			
		}//next j
	}//next i
	
	
// 
//region Trigger AddBeamsInPack
	String sTriggerAddBeamsInPack = T("|Add Beams In Pack|");
	addRecalcTrigger(_kContextRoot, sTriggerAddBeamsInPack );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddBeamsInPack)
	{
	// prompt for beams
		Beam beamsNew[0];
		PrEntity ssE(T("|Select new beams|"), Beam());
		if (ssE.go())
			beamsNew.append(ssE.beamSet());
			
		Beam bmPackNewPossible[0];
		bmPackNewPossible.append(bmMales);
		bmPackNewPossible.append(beamsNew);
		
	// check new pack
//		String strDifferentiators[0];
//		for (int ib=0;ib<bmPackNewPossible.length();ib++) 
//		{ 
//			strDifferentiators.append(""); 
//		}//next ib
		
//		EntityCollection _bmPacks[]=Beam().composeBeamPacks(bmPackNewPossible,strDifferentiators);
//		if(_bmPacks.length()>1)
//		{ 
//			reportMessage("\n"+scriptName()+" "+T("|Insertion failed, packing not possible|"));
//		}
//		else
//		{ 
//			Entity entsPackNew[0];
//			Beam beamsPack[]=_bmPacks[0].beam();
//			for (int ib=0;ib<beamsPack.length();ib++) 
//			{ 
//				entsPackNew.append(beamsPack[ib]);
//			}//next ib
//			_Map.setEntityArray(beamsPack,true,"entsPack","entsPack","entsPack");
//		}
		Entity entsPackNew[0];
		for (int ib=0;ib<bmMales.length();ib++) 
		{ 
			entsPackNew.append(bmMales[ib]);
		}//next ib
		for (int ib=0;ib<beamsNew.length();ib++) 
		{ 
			entsPackNew.append(beamsNew[ib]);
		}//next ib
		_Map.setEntityArray(entsPackNew,true,"entsPack","entsPack","entsPack");
		
		setExecutionLoops(2);
		return;
	}//endregion
	
//region Trigger AddFemaleBeams
	String sTriggerAddFemaleBeams = T("|Add Female Beams|");
	addRecalcTrigger(_kContextRoot, sTriggerAddFemaleBeams);
	if (_bOnRecalc && _kExecuteKey==sTriggerAddFemaleBeams)
	{
	// prompt for beams
		Beam beamsNew[0];
		PrEntity ssE(T("|Select new beams|"), Beam());
		if (ssE.go())
			beamsNew.append(ssE.beamSet());
		
		Entity entsFemalesNew[0];
		for (int ib=0;ib<bmFemales.length();ib++) 
		{ 
			entsFemalesNew.append(bmFemales[ib]);
		}//next ib
		for (int ib=0;ib<beamsNew.length();ib++) 
		{ 
			entsFemalesNew.append(beamsNew[ib]);
		}//next ib
		_Map.setEntityArray(entsFemalesNew,true,"entsFemales","entsFemales","entsFemales");
		
		setExecutionLoops(2);
		return;
	}//endregion
	
	return;
}

// Prerequisites
if (_Beam.length()<2 || _Beam[0].vecX().isParallelTo(_Beam[1].vecX()))
{ 
	//reportMessage("\n" + scriptName() + ": " +T("|invalid selection set.|"));	
	eraseInstance();
	return;
}
Beam bm0=_Beam[0];
Beam bm1=_Beam[1];

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
Point3d ptCen0=bm0.ptCenSolid();
Point3d ptCen1=bm1.ptCenSolid();

// vecZ is the plane of female bm1 where bm0 will touch
Vector3d vecZ=bm1.vecD(bm0.vecX());// vector of female in direction of male beam
if (vecZ.dotProduct(ptCen1-ptCen0)<0)vecZ*=-1;// vecZ pointing toward the female beam
Vector3d vecX=bm1.vecD(bm1.vecX().crossProduct(vecZ));// vector normal with the plane of 2 beams
// right hand side vectors
Vector3d vecY=vecX.crossProduct(-vecZ);

int nToolAlignment=sToolAlignments.find(sToolAlignment);
if (nToolAlignment==1)
{ 
// alignment follows the male beam
	Vector3d vecX_=bm0.vecD(vecX);
	Vector3d vecOther=vecX_.crossProduct(bm0.vecX());
// must vecX be at intersection of 2 planes vecZ and vecOther
	vecX = vecZ.crossProduct(vecOther);
	if(vecX.dotProduct(vecX_)<0)vecX*=-1;
	
//	// project vecX to the plane of vecZ
//	vecX=vecZ.crossProduct(vecX.crossProduct(vecZ));
	vecY=vecX.crossProduct(-vecZ);
////vecX.vis(ptRef, 1);
}
vecX.normalize();
vecY.normalize();
vecZ.normalize();
Line(ptCen0,vecZ).hasIntersection(Plane(ptCen1-vecZ*.5*bm1.dD(vecZ),vecZ),_Pt0);
vecX.vis(_Pt0,1);
vecY.vis(_Pt0,3);
vecZ.vis(_Pt0,150);

Vector3d vecX0=bm0.vecX();
if (vecX0.dotProduct(vecZ)<0)vecX0*=-1;

// vector normal with the plane of T-connection
Vector3d vecNormal=bm0.vecX().crossProduct(bm1.vecX());
// displace the display to the mid of female
Vector3d vecDisplacement=(ptCen1-ptCen0).dotProduct(vecNormal)*vecNormal;

// potential element link
Element el=_Beam[1].element();

// assignment
if (el.bIsValid())
	assignToElementGroup(el,true,0,'T');
else
	assignToGroups(bm1,'T');

// stretch male
_Pt0.vis(5);
// 
Vector3d vecXcut=bm0.vecX();
if (vecZ.dotProduct(bm0.vecX())<0)vecXcut *=-1;
Line lnMale(bm0.ptCen(),bm0.vecX());
// plane of stretch of male beam
Plane pnStretch(_Pt0+vecZ*dDistance,vecZ);
// HSB-16850
Point3d ptIntersect;
int nIntersect=lnMale.hasIntersection(pnStretch, ptIntersect);
if(!nIntersect)
{ 
	reportMessage("\n"+scriptName()+" "+T("|Unexpected|"));
	eraseInstance();
	return;
}

//ptIntersect.vis(3);
// check all for corner points of the male beam that fall in the stretching plane
Point3d ptIntersectMax=ptIntersect;
for (int iCorner=0;iCorner<2;iCorner++) 
{ 
	int iIndexI=-1+iCorner*2;
	for (int jCorner=0;jCorner<2;jCorner++) 
	{ 
		int iIndexJ=-1+jCorner * 2;
		int jCorner=-1+jCorner * 2;
		Line ln(bm0.ptCen()+.5*iIndexI*bm0.vecY()*bm0.dD(bm0.vecY())
						+.5*iIndexJ*bm0.vecZ()*bm0.dD(bm0.vecZ()), bm0.vecX());
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
ptIntersectMax.vis(2);
vecXcut.vis(ptIntersectMax);
//Body bd0 = bm0.envelopeBody(false,true);
//bd0.transformBy(vecX * U(50));
//bd0.vis(6);
//bd0.transformBy(-vecX * U(50));
//Body bd0 = bm0.envelopeBody();
vecXcut=vecZ;
Cut cutStretch(ptIntersectMax, vecXcut);


// stretch on insert
	bm0.addTool(cutStretch,bDebug?0:1);

// Trigger Reset
String sTriggerReset = T("|Reset + Erase|");
addRecalcTrigger(_kContextRoot, sTriggerReset );
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
if (dDistance>dEps)
{
	
	Body bdMale=bm0.envelopeBody(false,true);
	Body bdFemale;
	for (int i=0;i<bmFemales.length();i++)
	{ 
	    Beam bmFemale=bmFemales[i];
//	    Body bdFemaleEnv=bmFemale.envelopeBody(false,true);
		// HSB-18059:
	    Body bdFemaleEnv=Body(bmFemale.quader());
	    bdFemale.addPart(bdFemaleEnv);
	}
	bdFemale.vis(4);
	Body bdTool=bdMale;
	bdTool.intersectWith(bdFemale);
	Body bdSubtract(_Pt0+vecZ*dDistance,vecX,vecY,vecZ,U(10e3),U(10e3),U(10e3),0,0,1);
//	bdSubtract.vis(2);
	bdTool.subPart(bdSubtract);
	bdTool.vis(6);
	PlaneProfile ppStretch=bdTool.shadowProfile(pnStretch);
//	PlaneProfile pp0=bdTool.shadowProfile(Plane(_Pt0,vecZ));
//	PlaneProfile ppTool=pp0;
//	ppTool.unionWith(ppStretch);
//	ppTool.vis(2);
	PlaneProfile ppTool=bdTool.shadowProfile(Plane(_Pt0,vecZ));
	ppTool.shrink(-dGap);
// tool size
	LineSeg seg=ppTool.extentInDir(vecX);
	seg.vis(1);
//	seg.transformBy(vecDisplacement);
	double dX = bdFemale.lengthInDirection(vecX);//)abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
	if (nToolAlignment==1)
	{
//		dX=bdTool.lengthInDirection(vecX);
		dX=abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
	}
	double dY=abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
	if (nToolAlignment==1)
	{
//		dY=bdTool.lengthInDirection(vecY);
		dY=abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
	}
	double dZ=dDistance;
	Point3d ptRef=seg.ptMid();
	ptRef.vis(6);
	
// BeamCut
	if (dX>dEps && dY>dEps && dZ>dEps)
	{
		vecX.vis(ptRef, 1);
		vecY.vis(ptRef, 5);
		vecZ.vis(ptRef, 3);
		PlaneProfile ppFemale = bdFemale.shadowProfile(Plane(ptRef, vecX));
//		ppFemale.vis(4);
		Body bdBc(ptRef, vecX, vecY, vecZ, dX*2, dY, dZ*2, 0, 0, 0);
		PlaneProfile ppBc = bdBc.shadowProfile(Plane(ptRef, vecX));
		ppBc.vis(6);
		BeamCut bc;
		bc = BeamCut (ptRef, vecX, vecY, vecZ, dX*2,dY,dZ*2, 0, 0, 0);
		bc.cuttingBody().vis(3);
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
;#!815<;_![_:$K#EXM1B`````$E%3D2N0F""


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
        <int nm="BreakPoint" vl="445" />
        <int nm="BreakPoint" vl="1137" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19830: Make hasTConnection test only if male axis intersects female beam" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="8/30/2023 9:05:03 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18973 property value renamed, debug improved" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="5/15/2023 2:37:10 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18801: Enter wait state if no element beam found (beams without panhand state)" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="5/12/2023 10:19:19 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18551: Support copying of beam with TSL instance" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="4/18/2023 8:59:39 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18059: use quader to get the envelope of female beam" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="2/21/2023 3:51:47 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17255: Initial" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="12/22/2022 4:08:39 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End