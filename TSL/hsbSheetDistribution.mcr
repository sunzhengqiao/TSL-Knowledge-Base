#Version 8
#BeginDescription
#Versions:
Version 1.15 02/09/2025 HSB-24508: Fix bug when zone defined by sheet selection , Author Marsel Nakuci
1.14 22.12.2023 HSB-20644: Extend description of properties 
1.13 23.06.2022 HSB-15669: fix when creating sheet with opening 
1.12 17.12.2021 HSB-12619: use rayIntersection with the body when working with single SIP/Sheet and not with elements 
1.11 17.12.2021 HSB-13511: set the string properties from map or mapX only when part of the defined list 
1.10 24.11.2021 HSB-13475: add hidden property to store selected painterdefinition; support jigging in isometry 
1.9 09.11.2021 HSB-13754: Support splitting of sheets/sips that are not part of an element 
1.8 06.09.2021 HSB-12619: save for each zone the corresponding mapX; use cataloges in mapio when inserting different TSLs for each zone 
1.7 23.07.2021 HSB-12619: support SIPs 
1.6 12.07.2021 Deifne explicitely textSize in jig modus 
1.5 26.04.2021 HSB-11037: Split sheet when intersected with T junction 

HSB-9900: fix bug
HSB-9900: Multiple Enhancements, apply wise jig
HSB-9900: Add modus Custom aside from Element and Sheet
HSB-9900: initial

This tsl creates a new sheet distribution at elements.
TSL can be inserted at roof elements (ElementRoof) and wall elements (ElementWall) entities.
TSL can be inserted for each zone at the element definition and must be defined with a catalog
point of distribution is defined if tsli is inserted at least once at the element. Otherwise the left bottom point will be used as distribution point









#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 15
#KeyWords floor,sheet,distribution,Element
#BeginContents
/// <History>//region
// #Versions:
// 1.15 02/09/2025 HSB-24508: Fix bug when zone defined by sheet selection , Author Marsel Nakuci
// 1.14 22.12.2023 HSB-20644: Extend description of properties Author: Marsel Nakuci
// 1.13 23.06.2022 HSB-15669: fix when creating sheet with opening Author: Marsel Nakuci
// Version 1.12 17.12.2021 HSB-12619: use rayIntersection with the body when working with single SIP/Sheet and not with elements Author: Marsel Nakuci
// Version 1.11 17.12.2021 HSB-13511: set the string properties from map or mapX only when part of the defined list Author: Marsel Nakuci
// Version 1.10 24.11.2021 HSB-13475: add hidden property to store selected painterdefinition; support jigging in isometry Author: Marsel Nakuci
// Version 1.9 09.11.2021 HSB-13754: Support splitting of sheets/sips that are not part of an element Author: Marsel Nakuci
// Version 1.8 06.09.2021 HSB-12619: save for each zone the corresponding mapX; use cataloges in mapio when inserting different TSLs for each zone Author: Marsel Nakuci
// Version 1.7 23.07.2021 HSB-12619: support SIPs Author: Marsel Nakuci
// Version 1.6 12.07.2021 Deifne explicitely textSize in jig modus Author: Marsel Nakuci
// Version 1.5 26.04.2021 HSB-11037: Split sheet when intersected with T junction Author: Marsel Nakuci
/// <version value="1.4" date="12feb21" author="marsel.nakuci@hsbcad.com"> HSB-9900: fix bug at zone assignment </version>
/// <version value="1.3" date="05jan21" author="marsel.nakuci@hsbcad.com"> HSB-9900: Multiple Enhancements, apply wise jig </version>
/// <version value="1.2" date="21dec20" author="marsel.nakuci@hsbcad.com"> HSB-9900: Add modus Custom aside from Element and Sheet </version>
/// <version value="1.1" date="17dec20" author="marsel.nakuci@hsbcad.com"> HSB-9900: initial </version>
/// <version value="1.0" date="08dec20" author="marsel.nakuci@hsbcad.com"> HSB-9900: initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a new sheet distribution at elements.
/// TSL can be inserted at roof elements (ElementRoof) and wall elements (ElementWall) entities.
/// User inserts TSL then select a shhet or an element, then the dialog box appears.
/// if Sheet is selected then the zone is defined by the zone where the selected sheet belongs
/// In modus user select Element, Sheet, Reference axis X, Reference axis Y
/// In property alignment user picks one often that defines alignment for Element and Sheet modus
/// In Element modus alignment referes to the element. E.g. Right-Top means the distribution begins at right top position of element
/// In Sheet modus Right-Top means the cursor is positiones at the right top position of the sheet. On insert the user defines then the position point
/// In Reference axis X/Y modus the starting distribution in reference direction is given in 5 options
/// 5 options are shown at the property Position reference axis. One of 5 positions can be choosen on insert by clicking point closest to one of the positions
/// In Painter user selects a painter definition for constrining beams
/// When constraining beams are present they will define the direction of the reference direction
///
/// TSL can be attached at an element and be triggered on element calculation
/// The last inserted TSL at the element will write the properties and the distribution point at the mapX of the Element
/// That state will define the TSL state each time the Element calculation is triggered
/// TSL can be inserted in element definition for each zone and must be inserted with a catalog
/// each zone will have its corresponding map with properties and grip point in the mapx
/// 
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbSheetDistribution")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|Select hsbFloorSheetDistribution TSL|"))) TSLCONTENT
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
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true; break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());
	}
	String sDefault=T("|_Default|");
	String sLastInserted=T("|_LastInserted|");
	String category=T("|General|");
	String sNoYes[]={T("|No|"), T("|Yes|")};
	// beams parallel to element Y
	String sDefaultStrategy ="BeamGridY";
	String sDefaultFilter ="(Equals(ZoneIndex,0))and(Equals(IsParallelToElementY,'true'))and(Equals(IsDummy,'false'))";	
//end Constants//endregion
	
//region painter definitions
	String sPainters[]=PainterDefinition().getAllEntryNames();
	String sPainterCollection="hsbSheetDistribution";
	String sAllowedPainterTypes[]={"Beam", "GenBeam"};
	
	int bPainterCollectionFound;
	for (int i=0;i<sPainters.length();i++)
	{ 
		if (sPainters.findNoCase(sPainterCollection,-1)==0)
		{ 
			bPainterCollectionFound=true;
			break;
		}
	}
	String painter=sPainterCollection+"\\"+ T("|"+sDefaultStrategy+"|");
	if(sPainters.findNoCase(painter,-1)<0)
	{ 
		// default should always be there
		PainterDefinition p(painter);p.dbCreate(); p.setType("Beam"); p.setFilter(sDefaultFilter);
		sPainters.append(painter);
	}
	for (int i=sPainters.length()-1;i>=0;i--)
	{ 
		String sPainter=sPainters[i];
		if (sPainter.find(sPainterCollection,0,false)<0)
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
	// 
//	String sPainters[0];
//	for (int i = 0; i < sAllPainters.length(); i++)
//	{
//		String s = sAllPainters[i];
//		if (s.find(sPainterCollection ,0,false) < 0)continue; // ignore non collection painters
//		s = s.right(s.length() - sPainterCollection.length() - 1);
//		if (sPainters.findNoCase(s ,- 1) < 0)sPainters.append(s);
//	}
//End painter definitions//endregion 

	// painter stream to store painter definition in the properties
	String sPainterBeamStreamName=T("|Painter Definition|");	
	PropString sPainterBeamStream(7, "", sPainterBeamStreamName);	
	sPainterBeamStream.setDescription(T("|Stores the data of the used painter definition to copy the definition via catalog|"));
	sPainterBeamStream.setCategory(category);
	sPainterBeamStream.setReadOnly(bDebug?0:_kHidden);

// on insert read catalogs to copy / create painters based on catalog entries
	if (_bOnInsert || _bOnElementConstructed || _bOnDbCreated)
	{ 
	// collect streams	
		String streams[0];
		String sScriptOpmName = bDebug?"hsbSheetDistribution":scriptName();
		String entries[] = TslInst().getListOfCatalogNames(sScriptOpmName);
		int iStreamIndices[] ={ 7};
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
				if(iStreamIndices.find(index)>-1 && streams.findNoCase(stream,-1)<0)
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
					if(!pd.bIsValid())
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
	
	String sReferences[0];
	for (int i=0;i<sPainters.length();i++) 
	{ 
		String entry=sPainters[i];
		entry=entry.right(entry.length()-sPainterCollection.length()-1);	
		if (sReferences.findNoCase(entry,-1)<0)
			sReferences.append(entry);
	}//next i
	String sDisabled=T("<|Disabled|>");
	sReferences.insertAt(0, sDisabled);
//region properties
	category = T("|Alignment|");
	String sModusName=T("|Modus|");
	String sModuses[]={"Element","Sheet/SIP","Reference Axis X","Reference Axis Y"};
	PropString sModus(nStringIndex++, sModuses, sModusName);
	sModus.setDescription(T("|Defines the insertion Modus.|")+" "
	+T("|Element Modus will use as positioning point the center of the sheet and place it at the selected alignment option that referes to the element.|")+" "
	+T("|Sheet/SIP Modus will use the alignment option that referes to the sheet and the position is picked by point.|")+" "
	+T("|Reference Axis X/Y has predefined alignment options like left edge of sheet aligned to left edge of element etc.|")+" "+
	T("|Predifined alignment position closest with the point will be displayed.|"));
	sModus.setCategory(category);
	
	String sAlignments[]={T("|Left|")+" "+T("|Top|"),T("|Left|")+" "+T("|Middle|"), T("|Left|")+" "+T("|Bottom|"),
					T("|Middle|")+" "+T("|Top|"),T("|Middle|")+" "+T("|Middle|"), T("|Middle|")+" "+T("|Bottom|"),
					T("|Right|")+" "+T("|Top|"),T("|Right|")+" "+T("|Middle|"), T("|Right|")+" "+T("|Bottom|")};
	String sAlignmentName=T("|Alignment|");
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);
	sAlignment.setDescription(T("|Defines the Alignment when Element or Sheet modus is selected.|")+" "
	+T("|When Element Modus is selected, the alignment referes to the element.|")+" "
	+T("|E.g. Center of the sheet is placed at the left/top position of element.|")+" "
	+T("|When Sheet/SIP is selected the alignment referes to the sheet.|")+" "
	+T("|E.g. Reference point is positioned at the left/top point of the sheet and then it is placed by picking point.|"));
	sAlignment.setCategory(category);
	
	// staggering offset
	String sStaggeringOffsetName=T("|Staggering Offset|");	
	PropDouble dStaggeringOffset(nDoubleIndex++, U(0), sStaggeringOffsetName);	
	dStaggeringOffset.setDescription(T("|Defines the staggering offset between sheets/sips|"));
	dStaggeringOffset.setCategory(category);
	
	String sStaggeringDirectionName=T("|Staggering Direction|");
	String sStaggeringDirections[] ={ "X", "Y"};
	PropString sStaggeringDirection(nStringIndex++, sStaggeringDirections, sStaggeringDirectionName);	
	sStaggeringDirection.setDescription(T("|Defines the Staggering Direction between sheets. Direction is given with respect to element coordinate system.|"));
	sStaggeringDirection.setCategory(category);
	
	// offset from axis when reference axis X or reference axis Y is selected
//	String sAxisRefOffsetName=T("|Reference Offset|");	
//	PropDouble dAxisRefOffset(nDoubleIndex++, U(0), sAxisRefOffsetName);	
//	dAxisRefOffset.setDescription(T("|Defines the Offset from the reference axis in the middle of the element. Reference axis is defined from the beams axis in the painter definition or from the choosen Reference axis X or Reference axis Y|"));
//	dAxisRefOffset.setCategory(category);
	
	// HSB-16695: add two additional options to have the middle of sheeting at the Left or Rigth of Element
	// position in direction of reference axis. this is relevant when modus reference axis X or reference axis Y is selected
	String sAxisRefPositionName=T("|Position Reference Axis|");
	String sAxisRefPositions[] ={T("|Left Sheet Left Element|"),T("|Right Sheet Middle Element|"),T("|Middle Sheet Middle Element|"),
						T("|Left Sheet Middle Element|"), T("|Right Sheet Right Element|"),
						T("|Middle Sheet Left Element|"),T("|Middle Sheet Right Element|")};
	PropString sAxisRefPosition(nStringIndex++, sAxisRefPositions, sAxisRefPositionName);
	sAxisRefPosition.setDescription(T("|Defines the starting position of sheeting with respect to reference axis.|")+" "
	+T("|This is not meant to be used when inserted manually.|")+" "+T("|This is to have the possibility to save the position in a catalog.|"));
	sAxisRefPosition.setCategory(category);
	
	category = T("|Zone|");
	String sZoneName=T("|Zone|");	
	int nZones[] ={ -5,- 4,- 3,- 2,- 1, 0,1, 2, 3, 4, 5};
	PropInt nZone(nIntIndex++, nZones, sZoneName);	
	nZone.setDescription(T("|Defines the Zone of the sheets/sips|"));
	nZone.setCategory(category);
	//  
	category = T("|Sheet|");
	String sSheetLengthName=T("|Length|");	
	PropDouble dSheetLength(nDoubleIndex++, U(0), sSheetLengthName);	
	dSheetLength.setDescription(T("|Defines the Sheet/SIP Length. If 0 then the existing Length is used|"));
	dSheetLength.setCategory(category);
	
	String sSheetWidthName=T("|Width|");	
	PropDouble dSheetWidth(nDoubleIndex++, U(0), sSheetWidthName);	
	dSheetWidth.setDescription(T("|Defines the Sheet/SIP Width. If 0 then the existing Width is used|"));
	dSheetWidth.setCategory(category);
	
	String sSheetThicknessName=T("|Thickness|");
	PropDouble dSheetThickness(nDoubleIndex++, U(0), sSheetThicknessName);
	dSheetThickness.setDescription(T("|Defines the Sheet/SIP Thickness.  If 0 then the existing Thickness is used|"));
	dSheetThickness.setCategory(category);
	
	String sSheetNameName=T("|Name|");	
	PropString sSheetName(nStringIndex++, "", sSheetNameName);	
	sSheetName.setDescription(T("|Defines the Sheet/SIP Name. If empty then the existing Name is used|"));
	sSheetName.setCategory(category);
	
	String sSheetMaterialName=T("|Material|");	
	PropString sSheetMaterial(nStringIndex++, "", sSheetMaterialName);	
	sSheetMaterial.setDescription(T("|Defines the Sheet/SIP Material. If empty then the existing Material is used|"));
	sSheetMaterial.setCategory(category);
	// gapx between sheets
	String sGapXName = T("|Gap|") + " X";
	PropDouble dGapX(nDoubleIndex++, U(0), sGapXName);	
	dGapX.setDescription(T("|Defines the Gap X between sheets/sips|"));
	dGapX.setCategory(category);
	
	String sGapYName = T("|Gap|") + " Y";
	PropDouble dGapY(nDoubleIndex++, U(0), sGapYName);	
	dGapY.setDescription(T("|Defines the Gap Y between sheets/sips|"));
	dGapY.setCategory(category);
	// constraining beams by painter definition
	category=T("|constraining beams|");
	String sPainterBeamName=T("|Painter|");	
	String sPainterBeams[0]; 
//	sPainterBeams = sPainters.sorted();
//	sPainterBeams.insertAt(0, sDisabled);
	sPainterBeams.append(sReferences);
	PropString sPainterBeam(nStringIndex++, sPainterBeams, sPainterBeamName);	
	sPainterBeam.setDescription(T("|Defines the Painter definition of constraining Beams. Constraining beams will define the reference direction. If beams are not present, the reference direction will be defined by the choosen modus Reference X or Reference Y|")+" "
	+T("|Constraining beams will define the position where the sheets will be cutted.|"));
	sPainterBeam.setCategory(category);
	//
	// HSB-16695: First end beam on axis
	// if sheet at first and last beam should be cut on beam axis or not
	String sSheetOnFirstLastBeamAxisName=T("|Sheet on first/last Beam axis|");	
	PropString sSheetOnFirstLastBeamAxis(8, sNoYes, sSheetOnFirstLastBeamAxisName);	
	sSheetOnFirstLastBeamAxis.setDescription(T("|Defines if the sheet will end at axis of first/last beam.|")+" "+
	T("|If no then sheet will not be cut at axis of first/last beam.|")+" "+T("|Sheet edge will be aligned with the edge of first/end stud.|"));
	sSheetOnFirstLastBeamAxis.setCategory(category);
//End properties//endregion
	
	String strJigAction1="strJigAction1";
	if (_bOnJig && _kExecuteKey==strJigAction1) 
	{
	    //Point3d ptBase = _Map.getPoint3d("ptBase");
	    Point3d ptBase=_Map.getPoint3d("_PtBase"); // set by second argument in PrPoint
	    Point3d ptJig=_Map.getPoint3d("_PtJig"); // running point
	    
//	    _ThisInst.setDebug(TRUE); // sets the debug state on the jig only, if you want to see the effect of vis methods
//	    ptJig.vis(1);
	    
	    PlaneProfile ppSheet=_Map.getPlaneProfile("sheet");
	    // project point to the plane
	    Plane pnSheet(ppSheet.coordSys().ptOrg(), ppSheet.coordSys().vecZ());
        Vector3d vecView=getViewDirection();
        Line lnView(ptJig, vecView);
//        Point3d ptIntersect = lnView.intersect(pnSheet, U(0));
//        ptJig = ptIntersect;
		// HSB-12619
		int iRayIntersect;
		Body bdRepresentation;
		if(_Map.hasBody("bdRepresentation"))
		{ 
			// it is a SIP or Sheet
			// take the body to work with the rayIntersection
			bdRepresentation=_Map.getBody("bdRepresentation");
			// calculate the rayIntersection with the body
			Point3d ptRayIntersect;
			// try intersection from -vecView direction
			iRayIntersect=bdRepresentation.rayIntersection(ptJig, -vecView, ptRayIntersect);
			if(!iRayIntersect)
			{ 
				iRayIntersect=bdRepresentation.rayIntersection(ptJig, vecView, ptRayIntersect);
			}
			
			if(iRayIntersect)
			{ 
				// intersection succasseful
				ptJig=ptRayIntersect;
			}
		}
	    CoordSys cs=ppSheet.coordSys();
//	    String sH = _Map.getString("horizontal");
//	    String sV = _Map.getString("vertical");
	    String sAlignmentMap=_Map.getString("alignment");
	    String sAlignmentTokens[]=sAlignmentMap.tokenize(" ");
	    if(sAlignmentTokens.length()!=2)
	    { 
	    	eraseInstance();
	    	return;
	    }
	    String sSheetOnFirstLastBeamAxisMap=_Map.getString("sSheetOnFirstLastBeamAxis");
	    String sH=sAlignmentTokens[0];
	    String sV=sAlignmentTokens[1];
	    String sM=_Map.getString("modus");
	    
	    double dWidth=_Map.getDouble("width");
	    double dLength=_Map.getDouble("length");
	    Vector3d vecX=_Map.getVector3d("vecX");
	    Vector3d vecY=_Map.getVector3d("vecY");
//	    vecX.vis(ptJig, 1);
//	    vecY.vis(ptJig, 3);
	    PlaneProfile ppEnvelope(ppSheet.coordSys());
	    
	    PlaneProfile ppXlarge(cs),ppBeamLarge(cs);
	    PlaneProfile ppYlarge(cs),ppBeamNormalLarge(cs);
	    { 
	    	// get extents of profile
	    	LineSeg seg=ppSheet.extentInDir(vecX);
    		double dX=abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
    		double dY=abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
	    	PLine plXlarge(cs.vecZ());
	    	PLine plYlarge(cs.vecZ());
	    	plXlarge.createRectangle(LineSeg(seg.ptMid()-U(10e4)*vecX -.5*dY*vecY, 
	    				seg.ptMid()+U(10e4)*vecX +.5*dY*vecY),vecX,vecY);
	    	plYlarge.createRectangle(LineSeg(seg.ptMid()-U(10e4)*vecY-.5*dX*vecX, 
	    				seg.ptMid()+U(10e4)*vecY+.5*dX*vecX),vecX,vecY);
	    	ppXlarge.joinRing(plXlarge,_kAdd);
	    	ppYlarge.joinRing(plYlarge,_kAdd);
	    }
	    
	    String sHors[]={T("|Left|"),T("|Middle|"),T("|Right|")};
	    String sVers[]={T("|Top|"),T("|Middle|"),T("|Bottom|")};
	    
	    Point3d ptSheetCenter=ptJig;
	    if(sH==T("|Left|"))
	    	ptSheetCenter+=vecX*.5*dWidth;
	    else if(sH==T("|Right|"))
	    	ptSheetCenter-=vecX*.5*dWidth;
	    
	    if(sV==T("|Top|"))
	    	ptSheetCenter-=vecY*.5*dLength;
	    else if(sV==T("|Bottom|"))
	    	ptSheetCenter+=vecY*.5*dLength;

		Beam beams[0];
	    Entity entsBeam[]=_Map.getEntityArray("beams", "", "");
	    for (int i=0;i<entsBeam.length();i++) 
	    { 
	    	Beam bmI=(Beam)entsBeam[i];
	    	if(bmI.bIsValid())
	    		beams.append(bmI);
	    }//next i
	    
	    int nModus=sModuses.find(sM);
		if(nModus==0)
	    { 
	    	// element modus
		// get extents of profile
			LineSeg seg=ppSheet.extentInDir(vecX);
			ptJig=seg.ptMid();
			double dX=abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
			double dY=abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
    		
		    if(sH==T("|Left|"))
		    	ptJig+=-vecX*.5*dX;
		    else if(sH==T("|Right|"))
		    	ptJig-=-vecX*.5*dX;
		    
		    if(sV==T("|Top|"))
		    	ptJig-=-vecY*.5*dY;
		    else if(sV==T("|Bottom|"))
		    	ptJig+=-vecY*.5*dY;
		    	
		    ptSheetCenter=ptJig;
	    }
	    int nSheetOnFirstLastBeamAxis=sNoYes.find(sSheetOnFirstLastBeamAxisMap);
//		if(!nSheetOnFirstLastBeamAxis)
//    	{ 
//    		beams.removeAt(beams.length()-1);
//    		beams.removeAt(0);
//    	}
		if(nModus==2 || nModus==3)
		{ 
			// Reference Axis X, Reference Axis Y
			// custom modus
			// 5 possibilitite
			// 1- left, 
			// 2- right sheet in middle element, 
			// 3- middle sheet in middle element, 
			// 4- left sheet at middle element, 
			// 5- right
			double dAxisRefOffset_=_Map.getDouble("customOffset");
			String sAxisRef_=_Map.getString("customAxisRef");
			sAxisRef_="X";
			if(nModus==3)sAxisRef_="Y";
			String sAxisRefPosition_=_Map.getString("customPosition");
			Vector3d vecRef=vecX;
			Vector3d vecRefNormal=vecY;
			double dWidthNormal=dWidth;
			double dLengthNormal=dLength;
			if(sAxisRef_=="Y")
			{ 
				vecRef=vecY;
				vecRefNormal=vecX;
				dWidthNormal=dLength;
				dLengthNormal=dWidth;
			}
			if(beams.length()>0)
			{ 
				vecRef=beams[0].vecX();
				vecRefNormal=vecX;
				dWidthNormal=dLength;
				dLengthNormal=dWidth;
				if (vecRef.isParallelTo(vecX))
    			{
    				vecRefNormal=vecY;
    				dWidthNormal=dWidth;
					dLengthNormal=dLength;
    			}
			}
			
			Point3d ptJigNew;
			LineSeg seg=ppSheet.extentInDir(vecRef);
			double dX=abs(vecRef.dotProduct(seg.ptStart()-seg.ptEnd()));
			double dY=abs(vecRefNormal.dotProduct(seg.ptStart()-seg.ptEnd()));
			
			// middle of sheet for 5 positions
			Point3d pts[7];
			Point3d ptMidSheet=seg.ptMid()+vecRefNormal*(dAxisRefOffset_+.5*dLengthNormal);
			pts[0]=ptMidSheet-vecRef*(.5*dX-.5*dWidthNormal);
			pts[1]=ptMidSheet-vecRef*.5*dWidthNormal;
			pts[2]=ptMidSheet;
			pts[3]=ptMidSheet+vecRef*.5*dWidthNormal;
			pts[4]=ptMidSheet+vecRef*(.5*dX-.5*dWidthNormal);
			//
			pts[5]=ptMidSheet-vecRef*(.5*dX);
			pts[6]=ptMidSheet+vecRef*(.5*dX);
			ptJigNew=pts[0];
			double dMin=abs(vecRef.dotProduct(pts[0]-ptJig));
			for (int iOption=0;iOption<pts.length();iOption++) 
			{ 
				if(abs(vecRef.dotProduct(pts[iOption]-ptJig))<dMin)
				{ 
					dMin=abs(vecRef.dotProduct(pts[iOption]-ptJig));
					ptJigNew=pts[iOption];
				}
			}//next iOption
			ptJig+=vecRef*vecRef.dotProduct(ptJigNew-ptJig);
//			ptJig = ptJigNew;
			ptSheetCenter=ptJig;
		}
		Display dpp(1);
//		dpp.draw("point", ptSheetCenter,_XW,_YW,0,0);
	    Vector3d vecStaggeringDir=vecX;
	    if(_Map.getString("sVecDir")=="Y")
	    	vecStaggeringDir=vecY;
	    double dStaggeringOffset=_Map.getDouble("staggeringOffset");
	    double dGapX=_Map.getDouble("dGapX");
	    double dGapY=_Map.getDouble("dGapY");
	    PlaneProfile ppSheetMuster(ppSheet.coordSys());
	    { 
	    	PLine plSheetMuster(cs.vecZ());
	    	LineSeg lSeg(ptSheetCenter-.5*vecX*dWidth-.5*vecY*dLength,
	    				 ptSheetCenter+.5*vecX*dWidth+.5*vecY*dLength);
	    	plSheetMuster.createRectangle(lSeg,vecX,vecY);
	    	ppSheetMuster.joinRing(plSheetMuster,_kAdd);
	    }
	    
	    Display dpJ(1);
	    Display dpJ2(2);
	    Point3d ptStart=ptJig;
	    dpJ.textHeight(U(80));
//	    LineSeg lSegX(ptSheetCenter+vecX*U(50)+vecY*U(50), ptSheetCenter + vecX * U(500)+vecX*U(50)+vecY*U(50));
//	    LineSeg lSegY(ptSheetCenter+vecX*U(50)+vecY*U(50), ptSheetCenter + vecY * U(500)+vecX*U(50)+vecY*U(50));
//	    dpJ.draw(lSegX);
//	    dpJ.color(3);
//	    dpJ.draw(lSegY);
	    
	    PlaneProfile ppAxisX(ppSheet.coordSys()),ppAxisY(ppSheet.coordSys());
	    PLine plAxisX(cs.vecZ()),plAxisY(cs.vecZ());
	    LineSeg lSegXProf(ptJig+vecX*U(50)+vecY*U(50),ptJig+vecX*U(50)+vecY*U(50)+vecX*U(500)+vecY*U(30));
	    plAxisX.createRectangle(lSegXProf,vecX,vecY);
	    ppAxisX=PlaneProfile(plAxisX);
	    
	    LineSeg lSegYProf(ptJig+vecX*U(50)+vecY*U(50),ptJig+vecX*U(50)+vecY*U(50)+vecY*U(500)+vecX*U(30));
	    plAxisY.createRectangle(lSegYProf,vecX,vecY);
	    ppAxisY=PlaneProfile(plAxisY);
	    
	    dpJ.color(1);
	    dpJ.draw(ppAxisX,_kDrawFilled);
	    dpJ.color(3);
	    dpJ.draw(ppAxisY,_kDrawFilled);
	    
	    dpJ.color(3);
	    // dont draw for Reference axis X or Reference axis Y
	    if(nModus!=2 && nModus!=3)
	    {
	    	dpJ.draw(sM+"\\P"+sH+"\\P"+sV,ptJig,_XW,_YW,0,0,_kDeviceX);
	    }
//	    dpJ.draw(sH, ptJig, _XW, _YW, 0, -1, _kDeviceX);
//	    dpJ.draw(sV, ptJig, _XW, _YW, 0, -3, _kDeviceX);
	    
	    if(beams.length()==0)
	    { 
	    // No painter is selected, no constraining beams
		    for (int iRowSide=0;iRowSide<2;iRowSide++) 
		    { 
		    	Vector3d vecRowDir=-vecY;
		    	if (iRowSide==1)vecRowDir=vecY;
		    	int iBreakRow;
		    	int iBreakRowIndex;
		    	for (int iRow=0;iRow<100;iRow++) 
		    	{ 
		    		if (iRow==0 && iRowSide==1)continue;
		    		for (int iColSide=0;iColSide<2;iColSide++) 
		    		{ 
		    			Vector3d vecColDir=-vecX;
		    			if (iColSide==1)vecColDir=vecX;
		    			int iBreakCol;
		    			int iBreakColIndex;
		    			for (int iCol=0;iCol<100;iCol++) 
		    			{ 
		    				if (iCol==0 && iColSide==1)continue;
		    				Point3d pt=ptStart+vecRowDir*(dLength+dGapY)*iRow+vecColDir*(dWidth+dGapX)*iCol;
		    				PlaneProfile pp=ppSheetMuster;
		    				pp.transformBy(pt-ptStart);
		    				if( dStaggeringOffset!=0 && _Map.getString("sVecDir")=="X")
		    				{ 
		    				 	// staggering in X direction
		    				 	double dRowHalf=iRow;dRowHalf/=2;
		    				 	int iRowHalf=iRow/2;
		    				 	if(abs(dRowHalf)>abs(iRowHalf))
		    				 	{ 
		    				 		// 1,3,5
		    				 		pp.transformBy(vecStaggeringDir*dStaggeringOffset);
		    				 	}
		    				}
		    				if( dStaggeringOffset!=0 && _Map.getString("sVecDir")=="Y")
		 					{ 
		    					// staggering in X direction
		    					double dColHalf=iCol;dColHalf/=2;
		    				 	int iColHalf=iCol/2;
		    				 	if(abs(dColHalf)>abs(iColHalf))
		    				 	{ 
		    				 		// 1,3,5
		    				 		pp.transformBy(vecStaggeringDir*dStaggeringOffset);
		    				 	}
		    				}
		    				 
		    				PlaneProfile ppIntersect=pp;
		    				if(!ppIntersect.intersectWith(ppYlarge))
	    					{
	    						if (iBreakCol)
	    						{ 
	    							if(iBreakColIndex==iCol) 
	    							{
	    								break;
	    							}
	    							else 
	    							{
	    								continue;
	    							}
	    						}
	    						else
    				 			{
    				 				iBreakCol=true;
    				 				iBreakColIndex=iCol+1;
    				 				continue;
    				 			}
//	    						break;
	    					}
	    					else
	    						iBreakCol=false;
		    				 
		    				ppIntersect=pp;
		    				if(!ppIntersect.intersectWith(ppXlarge))
	    				 	{
	    				 		if (iBreakRow)
	    						{ 
	    							if(iBreakRowIndex==iRow) 
	    							{
	    								// break column loop and break row loop later
	    								break;
	    							}
	    							else 
	    							{
	    								continue;
	    							}
	    						}
	    						else
    				 			{
    				 				iBreakRow=true;
    				 				iBreakRowIndex=iRow+1;
    				 				continue;
    				 			}
	    				 	}
	    				 	else
	    				 		iBreakRow = false;
		    				 	
		    				pp.intersectWith(ppSheet);
		    				dpJ.draw(pp);
		    			}//next iCol
		    		}//next iColSide
		    		if(iBreakRow && iBreakRowIndex==iRow)
		    			break;
		    	}//next iRow
		    }//next iRowSide
	    }
	    else if(beams.length()>0)
	    { 
	    // Painter is selected for constraining beams
	    	Vector3d vecBeam=beams[0].vecX();
	    	Vector3d vecBeamNormal=vecX;
	    	double dGapNormal=dGapX;
	    	double dGapBeam=dGapY;
	    	double dLengthDir=dWidth;
	    	double dWidthDir=dLength;
	    	String sStaggeringDir="vecBeam";
	    	if(!vecBeam.isParallelTo(vecStaggeringDir))
	    			sStaggeringDir="vecBeamNormal";
	    	if (vecBeam.isParallelTo(vecX))
	    	{
	    		vecBeamNormal=vecY;
	    		dGapNormal=dGapY;
	    		dGapBeam=dGapX;
	    		dLengthDir=dLength;
	    		dWidthDir=dWidth;
	    	}
	    	vecBeam.vis(_Pt0,1);
	    	vecBeamNormal.vis(_Pt0,3);
	    	{ 
		    	// get extents of profile
		    	LineSeg seg=ppSheet.extentInDir(vecBeam);
	    		double dX=abs(vecBeam.dotProduct(seg.ptStart()-seg.ptEnd()));
	    		double dY=abs(vecBeamNormal.dotProduct(seg.ptStart()-seg.ptEnd()));
		    	PLine plBeamLarge(cs.vecZ());
		    	PLine plBeamNormalLarge(cs.vecZ());
		    	plBeamLarge.createRectangle(LineSeg(seg.ptMid()-U(10e4)*vecBeam-.5*dY*vecBeamNormal, 
		    				seg.ptMid()+U(10e4)*vecBeam+.5*dY*vecBeamNormal),vecBeam,vecBeamNormal);
		    	plBeamNormalLarge.createRectangle(LineSeg(seg.ptMid()-U(10e4)*vecBeamNormal-.5*dX*vecBeam, 
		    				seg.ptMid()+U(10e4)*vecBeamNormal+.5*dX*vecBeam),vecBeam,vecBeamNormal);
		    	ppBeamLarge.joinRing(plBeamLarge, _kAdd);
		    	ppBeamNormalLarge.joinRing(plBeamNormalLarge, _kAdd);
		    }
		    
	    	// sort beams in direction of vecBeamNormal
    		for (int i=0;i<beams.length();i++) 
    			for (int j=0;j<beams.length()-1;j++) 
    				if (vecBeamNormal.dotProduct(beams[j].ptCen())>vecBeamNormal.dotProduct(beams[j+1].ptCen()))
    					beams.swap(j, j+1);
	    	Plane pn(ppSheet.coordSys().ptOrg(), ppSheet.coordSys().vecZ());
	    	PlaneProfile ppBeams[beams.length()];
	    	for (int iB=0;iB<beams.length();iB++) 
	    	{ 
	    		ppBeams[iB]=beams[iB].envelopeBody().shadowProfile(pn); 
	    	}//next iB
	    	
//	    	beams[0].ptCen().vis(5);
//			for (int iB=0;iB<beams.length();iB++) 
//			{
//				beams[iB].envelopeBody().vis(iB);
//				Display dpp(iB);
//				dpp.draw(beams[iB].envelopeBody());
//				// draw text
//				dpp.draw("X", beams[iB].ptCen(),_XW, _YW, 0, 0, _kDeviceX);
//			}
			ptJig.vis(9);
//			ppSheetMuster.vis(10);
	    	Line lns[0];
	    	for (int i=0;i<beams.length();i++) 
	    		lns.append(Line(beams[i].ptCen(),vecBeam));
	    	//
//	    	ppSheet.vis(2);
	    	PlaneProfile ppSheetProgresive(ppSheet.coordSys());
	    	PlaneProfile _ppSheetProgresive(ppSheet.coordSys());
	    	Point3d ptMoving, ptFirst;
	    	PlaneProfile ppMoving,ppFirst, ppFirstCut, ppRow;
	    	PlaneProfile ppRowFirst, ppRowSecond;
	    	for (int iRowSide=0;iRowSide<2;iRowSide++)
		    { 
		    	Vector3d vecRowDir=-vecBeamNormal;
		    	if (iRowSide==1)vecRowDir=vecBeamNormal;
		    	int iBreakRow;
		    	int iBreakRowIndex;
		    	for (int iRow=0;iRow<10;iRow++) 
		    	{ 
		    		if (iRow==0 && iRowSide==1)continue;
//		    		int iBreakRow;
		    		for (int iColSide=0;iColSide<2;iColSide++) 
		    		{ 
		    			Vector3d vecColDir=-vecBeam;
		    			if (iColSide==1)vecColDir=vecBeam;
		    			int iBreakCol;
		    			int iBreakColIndex;
		    			for (int iCol=0;iCol<10;iCol++) 
		    			{ 
		    				if (iCol==0 && iColSide==1)continue;
		    				Point3d pt=ptStart+vecRowDir*(dLengthDir+dGapNormal)*iRow+vecColDir*(dWidthDir+dGapBeam)*iCol;
		    				PlaneProfile pp(cs);
//		    				pp= ppSheetMuster;
//		    				pp.transformBy(pt - ptStart);
		    				if(iRow==0 && iCol==0)
		    				{ 
		    					// first sheet
		    					// see if sheet touches any beam from abov
		    					pp=ppSheetMuster;
		    					ppFirst=pp;
		    					ppFirstCut=pp;
		    					ppRowFirst=pp;
		    					Beam bmTouchAbove, bmTouchBottom;
		    					int iTouchAbove, iTouchBelow;
		    					// get extents of profile
								LineSeg seg=pp.extentInDir(vecBeamNormal);
								// top Kante Edge
								Point3d ptTop=seg.ptEnd();
								Point3d ptBottom=seg.ptStart();
	    						if (vecBeamNormal.dotProduct(seg.ptStart()-seg.ptEnd())>0)
								{
									ptTop=seg.ptStart();
									ptBottom=seg.ptEnd();
								}
								// find which beam is closer bmAbove (right) or bmBelow (left)
								double dAbove=U(10e8),dBelow=U(10e8);
								// see above
								for (int iB=beams.length()-1;iB>=0;iB--) 
		    					{ 
		    						PlaneProfile ppIntersect=pp;
		    						if(ppIntersect.intersectWith(ppBeams[iB]))
		    						{ 
		    							if(!nSheetOnFirstLastBeamAxis)
		    								if(iB==0 || iB==beams.length()-1)break;
		    							bmTouchAbove=beams[iB];
		    							iTouchAbove=true;
	    								dAbove=(vecBeamNormal.dotProduct(
	    									(bmTouchAbove.ptCen()-vecBeamNormal*.5*dGapNormal-ptTop)));
		    							break;
		    						}
		    					}//next iB
								// see below
								for (int iB=0;iB<beams.length();iB++) 
		    					{ 
		    						PlaneProfile ppIntersect=pp;
		    						if(ppIntersect.intersectWith(ppBeams[iB]))
		    						{ 
		    							if(!nSheetOnFirstLastBeamAxis)
		    								if(iB==0 || iB==beams.length()-1)break;
		    							bmTouchBottom=beams[iB];
		    							iTouchBelow=true;
		    							dBelow=(vecBeamNormal.dotProduct(
	    									(bmTouchBottom.ptCen()+vecBeamNormal*.5*dGapNormal-ptBottom)));
		    							break;
		    						}
		    					}//next iB
								
								if(abs(dAbove)<abs(dBelow) && abs(dAbove)<U(10e8))
								{ 
									// beam touches above
									// displace the planeprofile
    								Vector3d vecTransform=vecBeamNormal*dAbove;
    								pp.transformBy(vecTransform);
    								ppFirst.transformBy(vecTransform);
    								ppFirstCut.transformBy(vecTransform);
    								ppRowFirst.transformBy(vecTransform);
    								// see below
    								// find the touching beam at bottom side
		    						for (int iB=0;iB<beams.length();iB++) 
			    					{ 
			    						PlaneProfile ppIntersect = pp;
			    						if(ppIntersect.intersectWith(ppBeams[iB]))
			    						{ 
			    							if(!nSheetOnFirstLastBeamAxis)
		    									if(iB==0 || iB==beams.length()-1)break;
			    							bmTouchBottom = beams[iB];
			    							if(bmTouchBottom==bmTouchAbove)
		    									break;
			    							iTouchBelow = true;
		    								// cut the planeprofile
		    								PlaneProfile ppCut(pp.coordSys());
		    								PLine plCut(pp.coordSys().vecZ());
		    								LineSeg lSegCut(bmTouchBottom.ptCen()+vecBeamNormal*.5*dGapNormal-vecBeam*U(10e4),
		    										bmTouchBottom.ptCen()-vecBeamNormal * U(10e4)+vecBeam*U(10e4));
		    								plCut.createRectangle(lSegCut,vecBeam,vecBeamNormal);
		    								ppCut.joinRing(plCut,_kAdd);
		    								pp.subtractProfile(ppCut);
		    								ppFirstCut.subtractProfile(ppCut);
			    							break;
			    						}
			    					}//next iB
								}
								else if (abs(dBelow)<abs(dAbove) && abs(dBelow)<U(10e8))
								{ 
									Vector3d vecTransform = vecBeamNormal * dBelow;
    								pp.transformBy(vecTransform);
    								ppFirst.transformBy(vecTransform);
    								ppFirstCut.transformBy(vecTransform);
    								ppRowFirst.transformBy(vecTransform);
    								// find touching beam above and cut
    								for (int iB=beams.length()-1; iB>=0 ; iB--) 
			    					{ 
			    						PlaneProfile ppIntersect = pp;
			    						if(ppIntersect.intersectWith(ppBeams[iB]))
			    						{ 
			    							if(!nSheetOnFirstLastBeamAxis)
		    									if(iB==0 || iB==beams.length()-1)break;
			    							bmTouchAbove = beams[iB];
			    							if(bmTouchAbove==bmTouchBottom)
			    								break;
			    							iTouchAbove = true;
		    								// cut the planeprofile
		    								PlaneProfile ppCut(pp.coordSys());
		    								PLine plCut(pp.coordSys().vecZ());
		    								LineSeg lSegCut(bmTouchAbove.ptCen()-vecBeamNormal*.5*dGapNormal-vecBeam*U(10e4),
		    										bmTouchAbove.ptCen()+vecBeamNormal*U(10e4)+vecBeam*U(10e4));
		    								plCut.createRectangle(lSegCut,vecBeam,vecBeamNormal);
		    								ppCut.joinRing(plCut,_kAdd);
		    								pp.subtractProfile(ppCut);
		    								ppFirstCut.subtractProfile(ppCut);
			    							break;
			    						}
			    					}//next iB
								}
								else 
								{ 
									// no touch from above or below, move to next beam 
									// dont touch any beam, move to next beam bottom if found
									int iBeamAboveFound;
		    						for (int iB=0;iB<beams.length();iB++) 
		    						{ 
		    							if(vecBeamNormal.dotProduct(beams[iB].ptCen()-ptTop)>0)
		    							{ 
		    								if(!nSheetOnFirstLastBeamAxis)
		    									if(iB==0 || iB==beams.length()-1)break;
		    								// displace the planeprofile
		    								Vector3d vecTransform=vecBeamNormal*vecBeamNormal.dotProduct(
	    										(beams[iB].ptCen()-vecBeamNormal*.5*dGapNormal-ptTop));
	    									pp.transformBy(vecTransform);
	    									ppFirst.transformBy(vecTransform);
	    									ppFirstCut.transformBy(vecTransform);
	    									ppRowFirst.transformBy(vecTransform);
	    									iBeamAboveFound = true;
		    								break;
		    							}
		    						}//next iB
		    						// find the touching beam at bottom side
		    						for (int iB=0;iB<beams.length();iB++) 
			    					{ 
			    						PlaneProfile ppIntersect = pp;
			    						if(ppIntersect.intersectWith(ppBeams[iB]))
			    						{ 
			    							if(!nSheetOnFirstLastBeamAxis)
		    									if(iB==0 || iB==beams.length()-1)break;
			    							bmTouchBottom=beams[iB];
			    							iTouchBelow=true;
		    								
		    								// cut the planeprofile
		    								PlaneProfile ppCut(pp.coordSys());
		    								PLine plCut(pp.coordSys().vecZ());
		    								LineSeg lSegCut(bmTouchBottom.ptCen()+vecBeamNormal*.5*dGapNormal-vecBeam*U(10e4),
		    										bmTouchBottom.ptCen()-vecBeamNormal*U(10e4)+vecBeam*U(10e4));
		    								plCut.createRectangle(lSegCut,vecBeam,vecBeamNormal);
		    								ppCut.joinRing(plCut,_kAdd);
	//	    								ppCut.vis(2);
		    								pp.subtractProfile(ppCut);
		    								ppFirstCut.subtractProfile(ppCut);
			    							break;
			    						}
			    					}//next iB
								}
//		    					pp.vis(3);
//		    					ppFirst.vis(1);
		    					{ 
	    						// get extents of profile
	    							LineSeg seg=pp.extentInDir(vecBeam);
	    							LineSeg segFirst=ppFirst.extentInDir(vecBeam);
	    							ptMoving=seg.ptMid();
	    							ptFirst=segFirst.ptMid();
		    					}
		    					ppMoving=pp;
		    					ppRowFirst=pp;
//		    					ppFirst = pp;
		    					ppSheetProgresive.unionWith(pp);
		    				}
		    				// first sheet is set
		    				if(sStaggeringDir=="vecBeamNormal")
		    				{ 
		    					// stagerring vector in normal of beams
		    					// set first row
		    					if(iRow==0 && iCol!=0)
			    				{ 
			    					// first row 
									if(iCol==1)
									{ 
										pp = ppFirst;
				    					pp.transformBy((dWidthDir+dGapBeam)*vecColDir*iCol);
				    					double dColHalf=iCol;dColHalf/=2;
				    				 	int iColHalf=iCol/2;
				    				 	if(abs(dColHalf)>abs(iColHalf))
				    					{
				    						pp.transformBy(dStaggeringOffset*vecStaggeringDir);
				    					}
				    					// modify with bounding beams
				    					{ 
					    					// see if sheet touches any beam from abov
					    					Plane pn(ppSheet.coordSys().ptOrg(),ppSheet.coordSys().vecZ());
					    					Beam bmTouchAbove, bmTouchBottom;
					    					int iTouchAbove,iTouchBottom;
					    					// get extents of profile
											LineSeg seg=pp.extentInDir(vecBeamNormal);
											// top Kante Edge
											Point3d ptTop=seg.ptEnd();
				    						if (vecBeamNormal.dotProduct(seg.ptStart()-seg.ptEnd())>0)
				    								ptTop=seg.ptStart();
					    					for (int iB=beams.length()-1;iB>=0;iB--) 
					    					{ 
					    						PlaneProfile ppIntersect=pp;
					    						if(ppIntersect.intersectWith(ppBeams[iB]))
					    						{ 
					    							if(!nSheetOnFirstLastBeamAxis)
		    											if(iB==0 || iB==beams.length()-1)break;
					    							bmTouchAbove=beams[iB];
					    							iTouchAbove=true;
				    								// displace the planeprofile
				    								pp.transformBy(vecBeamNormal*vecBeamNormal.dotProduct(
				    									(bmTouchAbove.ptCen()-vecBeamNormal*.5*dGapNormal-ptTop)));
					    							break;
					    						}
					    					}//next iB
					    					if(!iTouchAbove)
					    					{ 
					    						int iBeamAboveFound;
					    						// dont touch any beam, move to next beam if found
					    						for (int iB=beams.length()-1;iB>=0;iB--)
					    						{ 
					    							if(vecBeamNormal.dotProduct(beams[iB].ptCen()-ptTop)>0)
					    							{ 
					    								if(!nSheetOnFirstLastBeamAxis)
		    												if(iB==0 || iB==beams.length()-1)break;
					    								// displace the planeprofile
				    									pp.transformBy(vecBeamNormal*vecBeamNormal.dotProduct(
				    										(beams[iB].ptCen()-vecBeamNormal*.5*dGapNormal-ptTop)));
				    									iBeamAboveFound=true;
					    								break;
					    							}
					    						}//next iB
					    					}
					    					// if not touching beam and no beamabove found then pp will stay as it is
					    					// bottom edge
					    					seg = pp.extentInDir(vecBeamNormal);
					    					Point3d ptBottom = seg.ptStart();
				    						if (vecBeamNormal.dotProduct(seg.ptStart()-seg.ptEnd()) > 0)
				    							ptBottom = seg.ptEnd();
				    								
				    						// find the touching beam at bottom side
				    						for (int iB=0;iB<beams.length();iB++) 
					    					{ 
					    						PlaneProfile ppIntersect = pp;
					    						if(ppIntersect.intersectWith(ppBeams[iB]))
					    						{ 
					    							if(!nSheetOnFirstLastBeamAxis)
		    											if(iB==0 || iB==beams.length()-1)break;
					    							bmTouchBottom = beams[iB];
					    							iTouchBottom = true;
				    								
				    								// cut the planeprofile
				    								PlaneProfile ppCut(pp.coordSys());
				    								PLine plCut(pp.coordSys().vecZ());
				    								LineSeg lSegCut(bmTouchBottom.ptCen()+vecBeamNormal*.5*dGapNormal-vecBeam*U(10e4),
				    										bmTouchBottom.ptCen()-vecBeamNormal*U(10e4)+vecBeam*U(10e4));
				    								plCut.createRectangle(lSegCut,vecBeam,vecBeamNormal);
				    								ppCut.joinRing(plCut, _kAdd);
				    								pp.subtractProfile(ppCut);
					    							break;
					    						}
					    					}//next iB
					    					{ 
				    						// get extents of profile
				    							LineSeg seg = pp.extentInDir(vecBeam);
				    							ptMoving = seg.ptMid();
					    					}
					    					ppMoving = pp;
					    					ppSheetProgresive.unionWith(pp);
					    					ppRowSecond = pp;
					    				}
				    				}
				    				else if(iCol!=0 && iCol!=1)
				    				{ 
				    					double dColHalf=iCol;dColHalf/=2;
				    				 	int iColHalf=iCol/2;
				    				 	if(abs(dColHalf)>abs(iColHalf))
				    					{
				    						pp=ppRowSecond;
				    						pp.transformBy((dWidthDir+dGapBeam)*vecColDir*(iCol-1));
				    					}
				    					else
				    					{ 
				    						pp=ppRowFirst;
				    						pp.transformBy((dWidthDir+dGapBeam)*vecColDir*(iCol));
				    					}
				    				}
			    				}
			    				else if(iRow!=0)
			    				{ 
			    					// other rows
			    					Point3d pt=ptFirst+vecColDir*(dGapBeam+dWidthDir)*iCol;
			    					if(iCol==0 || iCol==1)
			    					{ 
			    						// cut from bottom
			    						pp = ppFirst;
//			    						pp.vis(1);
			    						pp.transformBy((dWidthDir+dGapBeam)*vecColDir*iCol);
			    						// planeprofile pointing downward
			    						PlaneProfile ppDownwardUpward(pp.coordSys());
			    						{ 
			    							PLine plDownward(pp.coordSys().vecZ());
			    							LineSeg lSegDownward(pt-vecBeam*.5*dWidthDir-vecRowDir*U(10e4),
			    									pt+vecBeam*.5*dWidthDir+vecRowDir*U(10e4));
			    							plDownward.createRectangle(lSegDownward, vecBeam,vecBeamNormal);
			    							ppDownwardUpward.joinRing(plDownward,_kAdd);
			    							
			    							PlaneProfile ppIntersect=ppSheetProgresive;
			    							int iInter=ppIntersect.intersectWith(ppDownwardUpward);
			    							if (!iInter)break;
			    							
			    							{ 
			    								// get extents of profile
			    								LineSeg seg=ppIntersect.extentInDir(vecBeam);
			    								Point3d ptBottom=seg.ptStart();
			    								if(vecRowDir.dotProduct(seg.ptStart()-seg.ptEnd())<0)
			    									ptBottom=seg.ptEnd();
			    								
												ptBottom+=vecRowDir*dGapNormal;
			    								ptBottom+=(seg.ptMid()-ptBottom).dotProduct(vecBeam)*vecBeam;
			    								pp=ppFirst;
			    								pp.transformBy(ptBottom-ptFirst);
			    								{ 
			    									// get extents of profile
		    										LineSeg seg=pp.extentInDir(vecRowDir);
		    										double dX=abs(vecRowDir.dotProduct(seg.ptStart()-seg.ptEnd()));
		    										pp.transformBy(vecRowDir*.5*dX);
			    								}
			    							}
			    							Point3d ptBottom, ptTop;
			    							{ 
			    							// get extents of profile
			    								LineSeg seg=pp.extentInDir(vecBeam);
			    								ptBottom=seg.ptStart();
			    								ptTop=seg.ptEnd();
			    								if(vecBeamNormal.dotProduct(ptBottom-ptTop)>0)
			    								{ 
			    									ptBottom=seg.ptEnd();
			    									ptTop=seg.ptStart();
			    								}
			    							}
			    							// cut from bottom
			    							// find the touching beam at bottom side
			    							if(iRowSide==0)
			    							{ 
			    								Beam bmTouchBottom;
					    						for (int iB=0;iB<beams.length();iB++) 
						    					{ 
						    						PlaneProfile ppIntersect=pp;
						    						if(ppIntersect.intersectWith(ppBeams[iB]))
						    						{ 
						    							if(!nSheetOnFirstLastBeamAxis)
		    												if(iB==0 || iB==beams.length()-1)break;
						    							bmTouchBottom=beams[iB];
	//					    							iTouchAbove = true;
														if(iB==0)
					    								{ 
					    									// get extents of profile
				    										LineSeg seg=ppBeams[iB].extentInDir(vecBeam);
					    									if(abs(abs(vecRowDir.dotProduct(ptTop-seg.ptStart()))+
					    										   abs(vecRowDir.dotProduct(ptTop-seg.ptEnd()))-
					    										   abs(vecRowDir.dotProduct(seg.ptStart()-seg.ptEnd())))<dEps)
					    										break;
					    								}
					    								// cut the planeprofile
					    								PlaneProfile ppCut(pp.coordSys());
					    								PLine plCut(pp.coordSys().vecZ());
					    								LineSeg lSegCut(bmTouchBottom.ptCen()+vecBeamNormal*.5*dGapNormal-vecBeam*U(10e4),
					    										bmTouchBottom.ptCen()-vecBeamNormal*U(10e4)+vecBeam*U(10e4));
					    								plCut.createRectangle(lSegCut,vecBeam,vecBeamNormal);
					    								ppCut.joinRing(plCut,_kAdd);
					    								pp.subtractProfile(ppCut);
					    								ppSheetProgresive.unionWith(pp);
						    							break;
						    						}
						    					}//next iB
			    							}
			    							else if(iRowSide==1)
			    							{ 
			    								// cut from top
			    								Beam bmTouchAbove;
			    								for (int iB=beams.length()-1; iB>=0 ; iB--) 
						    					{ 
						    						PlaneProfile ppIntersect=pp;
						    						if(ppIntersect.intersectWith(ppBeams[iB]))
						    						{ 
						    							if(!nSheetOnFirstLastBeamAxis)
		    												if(iB==0 || iB==beams.length()-1)break;
						    							bmTouchAbove=beams[iB];
						    							if(iB=beams.length()-1)
						    							{ 
					    									// get extents of profile
				    										LineSeg seg=ppBeams[iB].extentInDir(vecBeam);
					    									if(abs(abs(vecRowDir.dotProduct(ptBottom-seg.ptStart()))+
					    										   abs(vecRowDir.dotProduct(ptBottom-seg.ptEnd()))-
					    										   abs(vecRowDir.dotProduct(seg.ptStart()-seg.ptEnd())))<dEps)
					    										break;
					    								}
//						    							iTouchAbove = true;
					    								// cut the planeprofile
					    								PlaneProfile ppCut(pp.coordSys());
					    								PLine plCut(pp.coordSys().vecZ());
					    								LineSeg lSegCut(bmTouchAbove.ptCen()-vecBeamNormal*.5*dGapNormal-vecBeam*U(10e4),
					    										bmTouchAbove.ptCen()+vecBeamNormal*U(10e4)+vecBeam*U(10e4));
					    								plCut.createRectangle(lSegCut,vecBeam,vecBeamNormal);
					    								ppCut.joinRing(plCut,_kAdd);
					    								pp.subtractProfile(ppCut);
					    								ppSheetProgresive.unionWith(pp);
						    							break;
						    						}
						    					}//next iB
			    							}
			    						}
			    						if(iCol==0)
			    						{ 
			    							ppRowFirst = pp;
			    						}
			    						else if(iCol==1)
			    						{ 
			    							ppRowSecond = pp;
			    						}
			    					}
			    					else if(iCol!=0 && iCol!=1)
			    					{ 
			    						double dColHalf=iCol;dColHalf/=2;
				    				 	int iColHalf=iCol/2;
				    				 	if(abs(dColHalf)>abs(iColHalf))
				    					{
				    						pp = ppRowSecond;
				    						pp.transformBy((dWidthDir+dGapBeam)*vecColDir*(iCol-1));
//				    						pp.transformBy(dStaggeringOffset * vecStaggeringDir);
				    					}
				    					else
				    					{ 
				    						pp = ppRowFirst;
				    						pp.transformBy((dWidthDir+dGapBeam)*vecColDir*(iCol));
				    					}
			    					}
			    				}
		    				}
		    				else if(sStaggeringDir=="vecBeam")
		    				{ 
		    					//
		    					if(iRow==0 && iCol!=0)
			    				{ 
			    					// first row 
									pp = ppFirst;
									pp = ppFirstCut;
			    					pp.transformBy((dWidthDir+dGapBeam)*vecColDir*iCol);
			    					ppSheetProgresive.unionWith(pp);
			    				}
			    				else if(iRow!=0)
			    				{ 
			    					// planeprofile for all rows
			    					if(iCol==0)
			    					{ 
			    						pt = ptFirst;
			    						// first profile
			    						PlaneProfile ppDownwardUpward(pp.coordSys());
			    						{ 
			    							PLine plDownward(pp.coordSys().vecZ());
			    							LineSeg lSegDownward(pt-vecBeam*.5*dWidthDir-vecRowDir*U(10e4),
			    									pt+vecBeam*.5*dWidthDir+vecRowDir*U(10e4));
			    							plDownward.createRectangle(lSegDownward, vecBeam, vecBeamNormal);
			    							ppDownwardUpward.joinRing(plDownward, _kAdd);
			    							
			    							
			    							PlaneProfile ppIntersect=ppSheetProgresive;
			    							int iInter = ppIntersect.intersectWith(ppDownwardUpward);
			    							if ( ! iInter)break;
			    							
			    							{ 
			    								// get extents of profile
			    								LineSeg seg = ppIntersect.extentInDir(vecBeam);
			    								Point3d ptBottom = seg.ptStart();
			    								if(vecRowDir.dotProduct(seg.ptStart()-seg.ptEnd())<0)
			    									ptBottom = seg.ptEnd();
			    								
												ptBottom += vecRowDir * dGapNormal;
			    								ptBottom += (seg.ptMid() - ptBottom).dotProduct(vecBeam) * vecBeam;
			    								pp = ppFirst;
//			    								pp = ppFirstCut;
			    								pp.transformBy(ptBottom - ptFirst);
			    								{ 
			    									// get extents of profile
		    										LineSeg seg = pp.extentInDir(vecRowDir);
		    										double dX = abs(vecRowDir.dotProduct(seg.ptStart()-seg.ptEnd()));
		    										pp.transformBy(vecRowDir * .5 * dX);
			    								}
			    								ppRow = pp;
			    							}
			    							Point3d ptBottom, ptTop;
			    							{ 
			    							// get extents of profile
			    								LineSeg seg = pp.extentInDir(vecBeam);
			    								ptBottom = seg.ptStart();
			    								ptTop = seg.ptEnd();
			    								if(vecBeamNormal.dotProduct(ptBottom-ptTop)>0)
			    								{ 
			    									ptBottom = seg.ptEnd();
			    									ptTop = seg.ptStart();
			    								}
			    							}
			    							// cut from bottom
			    							// find the touching beam at bottom side
			    							if(iRowSide==0)
			    							{ 
			    								Beam bmTouchBottom;
					    						for (int iB=0;iB<beams.length();iB++) 
						    					{ 
						    						
						    						PlaneProfile ppIntersect = pp;
						    						if(ppIntersect.intersectWith(ppBeams[iB]))
						    						{ 
						    							if(!nSheetOnFirstLastBeamAxis)
		    												if(iB==0 || iB==beams.length()-1)break;
						    							bmTouchBottom = beams[iB];
	//					    							iTouchAbove = true;
					    								if(iB==0)
					    								{ 
					    									// get extents of profile
				    										LineSeg seg = ppBeams[iB].extentInDir(vecBeam);
					    									if(abs(abs(vecRowDir.dotProduct(ptTop-seg.ptStart()))+
					    										   abs(vecRowDir.dotProduct(ptTop-seg.ptEnd()))-
					    										   abs(vecRowDir.dotProduct(seg.ptStart()-seg.ptEnd())))<dEps)
					    										break;
					    								}
					    								// cut the planeprofile
					    								PlaneProfile ppCut(pp.coordSys());
					    								PLine plCut(pp.coordSys().vecZ());
					    								LineSeg lSegCut(bmTouchBottom.ptCen()+vecBeamNormal*.5*dGapNormal-vecBeam*U(10e4),
					    										bmTouchBottom.ptCen() - vecBeamNormal * U(10e4) + vecBeam * U(10e4));
					    								plCut.createRectangle(lSegCut, vecBeam, vecBeamNormal);
					    								ppCut.joinRing(plCut, _kAdd);
					    								pp.subtractProfile(ppCut);
					    								ppSheetProgresive.unionWith(pp);
						    							break;
						    						}
						    					}//next iB
						    					ppRow = pp;
			    							}
			    							else if(iRowSide==1)
			    							{ 
			    								// cut from top
			    								Beam bmTouchAbove;
			    								for (int iB=beams.length()-1; iB>=0 ; iB--) 
						    					{ 
						    						PlaneProfile ppIntersect = pp;
						    						if(ppIntersect.intersectWith(ppBeams[iB]))
						    						{ 
						    							if(!nSheetOnFirstLastBeamAxis)
		    												if(iB==0 || iB==beams.length()-1)break;
						    							bmTouchAbove = beams[iB];
						    							if(iB=beams.length()-1)
						    							{ 
					    									// get extents of profile
				    										LineSeg seg = ppBeams[iB].extentInDir(vecBeam);
					    									if(abs(abs(vecRowDir.dotProduct(ptBottom-seg.ptStart()))+
					    										   abs(vecRowDir.dotProduct(ptBottom-seg.ptEnd()))-
					    										   abs(vecRowDir.dotProduct(seg.ptStart()-seg.ptEnd())))<dEps)
					    										break;
					    								}
//						    							iTouchAbove = true;
					    								// cut the planeprofile
					    								PlaneProfile ppCut(pp.coordSys());
					    								PLine plCut(pp.coordSys().vecZ());
					    								LineSeg lSegCut(bmTouchAbove.ptCen()-vecBeamNormal*.5*dGapNormal-vecBeam*U(10e4),
					    										bmTouchAbove.ptCen() + vecBeamNormal * U(10e4) + vecBeam * U(10e4));
					    								plCut.createRectangle(lSegCut, vecBeam, vecBeamNormal);
					    								ppCut.joinRing(plCut, _kAdd);
					    								pp.subtractProfile(ppCut);
						    							break;
						    						}
						    					}//next iB
						    					ppRow = pp;
			    							}
			    						}
			    						double dRowHalf = iRow;dRowHalf /= 2;
										int iRowHalf = iRow / 2;
										if (abs(dRowHalf) > abs(iRowHalf))
										{
											// 1,3,5
											ppRow.transformBy(vecStaggeringDir * dStaggeringOffset);
										}
			    						ppSheetProgresive.unionWith(ppRow);
			    						pp = ppRow;
			    					}
			    					else
									{
//										dpJ.draw(ppRow);
										pp = ppRow;
										pp.transformBy((dWidthDir + dGapBeam) * vecColDir * iCol);
										ppSheetProgresive.unionWith(pp);
//										dpJ2.draw(ppRow);
									}
			    				}
		    				}
		    				PlaneProfile ppIntersect = pp;
//		    				ppBeamLarge.vis(5);
		    				if(!ppIntersect.intersectWith(ppBeamNormalLarge))
		    				{ 
		    					if (iBreakCol)
	    						{ 
	    							if(iBreakColIndex==iCol) 
	    							{
	    								break;
	    							}
	    							else 
	    							{
	    								continue;
	    							}
	    						}
	    						else
    				 			{
    				 				iBreakCol = true;
    				 				iBreakColIndex = iCol + 1;
    				 				continue;
    				 			}
		    				}
		    				else
	    						iBreakCol = false;
		    				
		    				ppIntersect = pp;
		    				if(!ppIntersect.intersectWith(ppBeamLarge))
	    				 	{
	    				 		if (iBreakRow)
	    						{ 
	    							if(iBreakRowIndex==iRow) 
	    							{
	    								// break column loop and break row loop later
	    								break;
	    							}
	    							else 
	    							{
	    								continue;
	    							}
	    						}
	    						else
    				 			{
    				 				iBreakRow = true;
    				 				iBreakRowIndex = iRow + 1;
    				 				continue;
    				 			}
	    				 	}
		    				else
	    				 		iBreakRow = false;
		    					
//		    				ppSheet.vis(5);
		    				pp.intersectWith(ppSheet);
		    				pp.subtractProfile(_ppSheetProgresive);
		    				if(pp.area()<pow(dEps,2))continue;
		    				_ppSheetProgresive.unionWith(pp);
		    				pp.vis(3);
		    				dpJ.draw(pp);
//		    				dpJ2.draw(ppSheetMuster);
//							if(iBreakCol && iBreakColIndex==iRow)
//		    					break;
		    			}//next iCol
		    		}//next iColSide
		    		if(iBreakRow && iBreakRowIndex==iRow)
		    			break;
		    	}//next iRow
		    }//next iRowSide
	    }
	    return;
	}
	
//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
	// prompt element or sheet selection
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select Wall, Roof Element or a Sheet/SIP from the Element|"), ElementRoof());
		ssE.addAllowedClass(ElementWall());
		ssE.addAllowedClass(Sheet());
		ssE.addAllowedClass(Sip());
		if (ssE.go())
			ents.append(ssE.set());
		
		if(ents.length()==0)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|no entity selected|"));
			eraseInstance();
			return;
		}
		Sheet shSelected = (Sheet)ents[0];
		Sip sipSelected = (Sip)ents[0];
		Element elSelected = (Element)ents[0];
		// valid zones of selected element
		int nZonesValid[0];
		int bSheetSelected;
		int bSipSelected;
		int nSheetSelectedZone;
		int nSipSelectedZone;
		int bHasElement;
		if(shSelected.bIsValid())
		{ 
			elSelected = shSelected.element();
			ElementWall eW = (ElementWall) elSelected;
			ElementRoof eR = (ElementRoof)elSelected;
			// HSB-24508
			if (eW.bIsValid() || eR.bIsValid() || elSelected.bIsValid())bHasElement = true;
//			if(!elSelected.bIsValid())
//			{ 
//				reportMessage(TN("|selected sheet has no valid element|"));
//				eraseInstance();
//				return;
//			}
			int nSheetZone = shSelected.myZoneIndex();
			int nZoneSelected;
			if(bHasElement)
			{ 
				nSheetSelectedZone = nSheetZone;
				for (int iZ=0;iZ<nZones.length();iZ++) 
				{ 
					if(elSelected.zone(nZones[iZ]).dH()>0)
					{ 
						Sheet sheetsZoneI[] = elSelected.sheet(nZones[iZ]);
						if (sheetsZoneI.length() == 0)continue;
						// valid zone
						nZonesValid.append(nZones[iZ]);
					}
				}//next iZ
				nZoneSelected = nZonesValid.find(nSheetZone);
				if(nZoneSelected<0)
				{ 
					reportMessage("\n"+scriptName()+" "+T("|unexpected zone index|"));
					eraseInstance();
					return;
				}
			}
			else if(!bHasElement)
			{ 
				nZonesValid.append(nSheetZone);
				nZoneSelected = 0;
			}
			nZone = PropInt (0, nZonesValid, sZoneName, nZoneSelected);
			nZone.set(nZonesValid[nZoneSelected]);
			bSheetSelected = true;
//			nZone.setReadOnly(true);
		}
		else if(sipSelected.bIsValid())
		{ 
			elSelected = sipSelected.element();
			ElementWall eW = (ElementWall) elSelected;
			ElementRoof eR = (ElementRoof)elSelected;
			if (eW.bIsValid() || eR.bIsValid())bHasElement = true;
//			if(!elSelected.bIsValid())
//			{ 
//				reportMessage(TN("|selected sip has no valid element|"));
//				eraseInstance();
//				return;
//			}
			int nSipZone = sipSelected.myZoneIndex();
			int nZoneSelected;
			if(bHasElement)
			{ 
				nSipSelectedZone = nSipZone;
				Sip sipsAll[] = elSelected.sip();
				for (int iS=0;iS<sipsAll.length();iS++) 
				{ 
					int nZoneIs = sipsAll[iS].myZoneIndex();
					if (nZonesValid.find(nZoneIs) < 0)nZonesValid.append(nZoneIs);
				}//next iS
				
				nZoneSelected = nZonesValid.find(nSipZone);
				
				if(nZoneSelected<0)
				{ 
					reportMessage("\n"+scriptName()+" "+T("|unexpected zone index|"));
					eraseInstance();
					return;
				}
			}
			else
			{ 
				nZonesValid.append(nSipZone);
				nZoneSelected = 0;
			}
			nZone = PropInt (0, nZonesValid, sZoneName, nZoneSelected);
			nZone.set(nZonesValid[nZoneSelected]);
			bSipSelected = true;
		}
		else if(elSelected.bIsValid())
		{ 
			bHasElement = true;
			// get valid zones
			Sheet sheetsEl[] = elSelected.sheet();
			Sip sipsEl[] = elSelected.sip();
			if(sheetsEl.length()>0)
			{ 
				// element has sheets
				for (int iZ=0;iZ<nZones.length();iZ++) 
				{ 
					if(elSelected.zone(nZones[iZ]).dH()>0)
					{ 
						// valid zone
						nZonesValid.append(nZones[iZ]);
					}
				}//next iZ
			}
			else if(sipsEl.length()>0)
			{ 
				for (int iS=0;iS<sipsEl.length();iS++) 
				{ 
					int nZoneIs = sipsEl[iS].myZoneIndex();
					if (nZonesValid.find(nZoneIs) < 0)nZonesValid.append(nZoneIs);
				}//next iS
			}
			nZone = PropInt (0, nZonesValid, sZoneName);
		}
		
		if(bHasElement)
			_Element.append(elSelected);
		
		
		if(bSheetSelected)
		{ 
			int nZoneSelected = nZonesValid.find(nSheetSelectedZone);
			nZone.set(nZonesValid[nZoneSelected]);
		}
		// element related data
		Map mapXprops;
		Map mapXel;
		String sZoneNrName;
		if(bHasElement)
		if(bHasElement && (sipSelected.bIsValid() || shSelected.bIsValid()))
		{ 
			mapXel = elSelected.subMapX("hsbSheetDistribution");
			
			String sZoneNr = nZone;
			sZoneNrName = "zone"+sZoneNr;
			if(mapXel.hasMap(sZoneNrName))
			{ 
				mapXprops = mapXel.getMap(sZoneNrName);
			}
		}
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
		{
			// load from mapX
//			elSelected.removeSubMapX("hsbSheetDistribution");
			if(mapXprops.hasMap("PropString[]") && mapXprops.hasMap("PropDouble[]") && mapXprops.hasMap("PropInt[]"))
			{ 
				
				Map mapPropsString = mapXprops.getMap("PropString[]");
				Map mapPropsDouble = mapXprops.getMap("PropDouble[]");
				Map mapPropsInt = mapXprops.getMap("PropInt[]");
				String sPropStrings[9];
				double dPropDoubles[6];
				int iPropInts[1];
				for (int i=0;i<mapPropsString.length();i++) 
					sPropStrings[i] = mapPropsString.getMap(i).getString("strValue");
				for (int i=0;i<mapPropsDouble.length();i++) 
					dPropDoubles[i] = mapPropsDouble.getMap(i).getDouble("dValue");
				for (int i=0;i<mapPropsInt.length();i++) 
					iPropInts[i] = mapPropsInt.getMap(i).getInt("iValue");
				// HSB-13511
				String ssProp;
				ssProp = sPropStrings[0];
				if(sModuses.find(T(ssProp))>-1)
					sModus.set(T(ssProp));
				ssProp = sPropStrings[1];
				if(sAlignments.find(T(ssProp))>-1)
					sAlignment.set(T(ssProp));
				ssProp = sPropStrings[2];
				if(sStaggeringDirections.find(T(ssProp))>-1)
					sStaggeringDirection.set(T(ssProp));
				ssProp = sPropStrings[3];
				if(sAxisRefPositions.find(T(ssProp))>-1)
					sAxisRefPosition.set(T(ssProp));
				
				sSheetName.set(sPropStrings[4]);
				sSheetMaterial.set(sPropStrings[5]);
				ssProp = sPropStrings[6];
				if(sPainterBeams.find(T(ssProp))>-1)
					sPainterBeam.set(T(ssProp));
				sPainterBeamStream.set(sPropStrings[7]);
				
				ssProp = sPropStrings[8];
				if(sNoYes.find(T(ssProp))>-1)
					sSheetOnFirstLastBeamAxis.set(sPropStrings[8]);
				//
				dStaggeringOffset.set(dPropDoubles[0]);
//				dAxisRefOffset.set(dPropDoubles[1]);
				dSheetLength.set(dPropDoubles[1]);
				dSheetWidth.set(dPropDoubles[2]);
				dSheetThickness.set(dPropDoubles[3]);
				dGapX.set(dPropDoubles[4]);
				dGapY.set(dPropDoubles[5]);
				
				nZone.set(iPropInts[0]);
			}
			else
			{ 
				// load remaining values except zone from the last inserted catalog
				Map map = TslInst().mapWithPropValuesFromCatalog(scriptName(), T("|_LastInserted|"));
				if(map.hasMap("PropString[]") && map.hasMap("PropDouble[]") && map.hasMap("PropInt[]"))
				{ 
					Map mapPropsString = map.getMap("PropString[]");
					Map mapPropsDouble = map.getMap("PropDouble[]");
					Map mapPropsInt = map.getMap("PropInt[]");
					String sPropStrings[9];
					double dPropDoubles[6];
					int iPropInts[1];
					for (int i=0;i<mapPropsString.length();i++) 
						sPropStrings[i] = mapPropsString.getMap(i).getString("strValue");
					for (int i=0;i<mapPropsDouble.length();i++) 
						dPropDoubles[i] = mapPropsDouble.getMap(i).getDouble("dValue");
					for (int i=0;i<mapPropsInt.length();i++) 
						iPropInts[i] = mapPropsInt.getMap(i).getInt("lValue");
					// HSB-13511
					String ssProp;
					ssProp = sPropStrings[0];
					if(sModuses.find(T(ssProp))>-1)
						sModus.set(T(ssProp));
					ssProp = sPropStrings[1];
					if(sAlignments.find(T(ssProp))>-1)
						sAlignment.set(T(ssProp));
					ssProp = sPropStrings[2];
					if(sStaggeringDirections.find(T(ssProp))>-1)
						sStaggeringDirection.set(T(ssProp));
					ssProp = sPropStrings[3];
					if(sAxisRefPositions.find(T(ssProp))>-1)
						sAxisRefPosition.set(T(ssProp));
					//
					sSheetName.set(sPropStrings[4]);
					sSheetMaterial.set(sPropStrings[5]);
					ssProp = sPropStrings[6];
					if(sPainterBeams.find(T(ssProp))>-1)
						sPainterBeam.set(T(ssProp));
					sPainterBeamStream.set(sPropStrings[7]);
					
					if(sNoYes.find(sPropStrings[8])>-1)
						sSheetOnFirstLastBeamAxis.set(sPropStrings[8]);
					//
					dStaggeringOffset.set(dPropDoubles[0]);
//					dAxisRefOffset.set(dPropDoubles[1]);
					dSheetLength.set(dPropDoubles[1]);
					dSheetWidth.set(dPropDoubles[2]);
					dSheetThickness.set(dPropDoubles[3]);
					dGapX.set(dPropDoubles[4]);
					dGapY.set(dPropDoubles[5]);
					//
					nZone.set(iPropInts[0]);
					
					if(bSheetSelected)
					{ 
						int nZoneSelected = nZonesValid.find(nSheetSelectedZone);
						nZone.set(nZonesValid[nZoneSelected]);
					}
					else if(bSipSelected)
					{ 
						int nZoneSelected = nZonesValid.find(nSipSelectedZone);
						nZone.set(nZonesValid[nZoneSelected]);
					}
				}
			}
			// 
			showDialog("---");
		}
		
		// element related data
//		Map mapXprops;
//		Map mapXel;
//		String sZoneNrName;
		if(bHasElement)
		{ 
			mapXel = elSelected.subMapX("hsbSheetDistribution");
			
			String sZoneNr = nZone;
			sZoneNrName = "zone"+sZoneNr;
			if(mapXel.hasMap(sZoneNrName))
			{ 
				mapXprops = mapXel.getMap(sZoneNrName);
			}
		}
		
//			showDialog();
		
	// prompt element
//		_Element.append(getElement(T("|Select Wall or Roof Element|")));
		
		
//		if(_Element.length()==0)
//		{ 
//			reportMessage(TN("|one Element needed|"));
//			eraseInstance();
//			return;
//		}
		
		// representation body when working with SIP, Sheet
		// body is needed to take the rayintersection of the jigpoint with the body
		// With elements one should always work with Element view
		Body bdRepresentation;
		Sheet sheets[0];
		Sip sips[0];
		Plane pnZone;
		CoordSys csZone;
		Element el;
		Point3d ptOrg;
		Vector3d vecX;
		Vector3d vecY;
		Vector3d vecZ;
		ElemZone ez;
		if(bHasElement)
		{ 
			el = _Element[0];
			ElementRoof er = (ElementRoof)el;
			ElementWall ew = (ElementWall)(el);
			if(!er.bIsValid() && !ew.bIsValid() && !el.bIsValid())
			{ 
				reportMessage("\n"+scriptName()+" "+T("|no element wall or element roof or multi element|"));
				eraseInstance();
				return;
			}
			
			ptOrg = el.ptOrg();
			vecX = el.vecX();
			vecY = el.vecY();
			vecZ = el.vecZ();
			
			ez = el.zone(nZone);
			csZone = ez.coordSys();
			
			
	//		if (ez.dH() == 0)
	//		{ 
	//			reportMessage(TN("|Invalid Zone|"));
	//			eraseInstance();
	//			return;
	//		}
			sheets.append(el.sheet(nZone));
			
			Sip sipsAll[] = el.sip();
			for (int iS=0;iS<sipsAll.length();iS++) 
			{ 
				if (sipsAll[iS].myZoneIndex() == nZone)
				{ 
					if(sips.find(sipsAll[iS])<0)
						sips.append(sipsAll[iS]);
				}
			}//next iS
		}
		else if(!bHasElement)
		{ 
			if(shSelected.bIsValid())
			{ 
				sheets.append(shSelected);
				csZone = shSelected.coordSys();
				ptOrg = csZone.ptOrg();
				vecX = csZone.vecX();
				vecY = csZone.vecY();
				vecZ = csZone.vecZ();
				_GenBeam.append(shSelected);
				bdRepresentation = shSelected.realBody();
			}
			else if(sipSelected.bIsValid())
			{ 
				sips.append(sipSelected);
				csZone = sipSelected.coordSys();
				ptOrg = csZone.ptOrg();
				vecX = csZone.vecX();
				vecY = csZone.vecY();
				vecZ = csZone.vecZ();
				_GenBeam.append(sipSelected);
				bdRepresentation = sipSelected.realBody();
			}
		}
		pnZone = Plane(csZone.ptOrg(), csZone.vecZ());
		PlaneProfile ppSheet(pnZone);
		// element contains sheets
		int iElementSheet;
		
		if(sheets.length()>0)
		{ 
			// sheets contained at the zone
			iElementSheet = true;
			for (int i=0;i<sheets.length();i++) 
			{ 
				PlaneProfile ppI(pnZone);
				PlaneProfile ppSheetI = sheets[i].profShape();
				PLine plsNoOp[] = ppSheetI.allRings(true, false);
				// HSB-11037
				for (int ii=0;ii<plsNoOp.length();ii++) 
				{ 
					ppI.joinRing(plsNoOp[ii], _kAdd);
				}//next ii
				
	//			ppI.joinRing(sheets[i].plEnvelope(), _kAdd);
				ppI.shrink(-U(20));
				ppSheet.unionWith(ppI);
	//			ppSheet.joinRing(sheets[i].plEnvelope(), _kAdd);
			}//next i
			ppSheet.shrink(U(20));
			for (int i=0;i<sheets.length();i++) 
			{ 
				// HSB-11037
				PlaneProfile ppSheetI = sheets[i].profShape();
				PLine plsOp[] = ppSheetI.allRings(false, true);
				for (int ii=0;ii<plsOp.length();ii++) 
				{ 
					ppSheet.joinRing(plsOp[ii], _kSubtract);
				}//next ii
				
	//			PLine plOp[] = sheets[i].plOpenings();
	//			for (int o = 0; o < plOp.length(); o++)
	//			{
	//				ppSheet.joinRing(plOp[o], _kSubtract);
	//			}
			}//next i
		}
		else if (sips.length() > 0)
		{ 
			// sips contained at the zone
			iElementSheet = false;
			csZone = sips[0].coordSys();
			pnZone = Plane(csZone.ptOrg(), csZone.vecZ());
			ppSheet=PlaneProfile (pnZone);
			for (int i=0;i<sips.length();i++) 
			{ 
				PlaneProfile ppI(pnZone);
				PlaneProfile ppSheetI = ppI;
				ppSheetI.joinRing(sips[i].plEnvelope(), _kAdd);
				
				PLine plOpsI[] = sips[i].plOpenings();
				for (int iO=0;iO<plOpsI.length();iO++) 
				{ 
					ppSheetI.joinRing(plOpsI[iO], _kSubtract);
				}//next iO
				
//				PlaneProfile ppSheetI = sheets[i].profShape();
				PLine plsNoOp[] = ppSheetI.allRings(true, false);
				// HSB-11037
				for (int ii=0;ii<plsNoOp.length();ii++) 
				{ 
					ppI.joinRing(plsNoOp[ii], _kAdd);
				}//next ii
				
	//			ppI.joinRing(sheets[i].plEnvelope(), _kAdd);
				ppI.shrink(-U(20));
				ppSheet.unionWith(ppI);
	//			ppSheet.joinRing(sheets[i].plEnvelope(), _kAdd);
			}//next i
			ppSheet.shrink(U(20));
			for (int i=0;i<sips.length();i++) 
			{ 
				PLine plsOp[] = sips[i].plOpenings();
				for (int ii=0;ii<plsOp.length();ii++) 
				{ 
					ppSheet.joinRing(plsOp[ii], _kSubtract);
				}//next ii
				// HSB-11037
//				PlaneProfile ppSheetI = sheets[i].profShape();
//				PLine plsOp[] = ppSheetI.allRings(false, true);
//				for (int ii=0;ii<plsOp.length();ii++) 
//				{ 
//					ppSheet.joinRing(plsOp[ii], _kSubtract);
//				}//next ii
				
	//			PLine plOp[] = sheets[i].plOpenings();
	//			for (int o = 0; o < plOp.length(); o++)
	//			{
	//				ppSheet.joinRing(plOp[o], _kSubtract);
	//			}
			}//next i
		}
		
		if(sheets.length()==0 && sips.length()==0)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|no sheet or sip at selected zone found|"));
			return;
		}
		// selected painter
		int iPainterBeam = sPainterBeams.find(sPainterBeam, 0);
		PainterDefinition painterBeam;
		
		Beam beamsConstrain[0];
		if(sPainterBeam!=sDisabled)
		{
			painterBeam = PainterDefinition(sPainterCollection + "\\" + sPainterBeam);
			String sPainterFilter = painterBeam.filter();
			if(sPainterFilter.find("IsParallelToElementY" ,- 1) > 0 
				|| sPainterFilter.find("IsParallelToElementX" ,- 1) > 0)
			// get beams
			{
				Beam beamsAll[0];
				if(bHasElement)
			 	{
			 		beamsAll.append(el.beam());
			 	}
			 	if(painterBeam.bIsValid())
			 	{
			 		beamsConstrain = painterBeam.filterAcceptedEntities(beamsAll);
			 	}
			 	if(beamsConstrain.length()>0)
			 	{ 
			 		Vector3d vecBeam = beamsConstrain[0].vecX();
			 		if(vecBeam.isParallelTo(vecX) || vecBeam.isParallelTo(vecY))
			 		{ 
			 			for (int iB=beamsConstrain.length()-1; iB>=0 ; iB--) 
				 		{ 
				 			if(!vecBeam.isParallelTo(beamsConstrain[iB].vecX()))
				 				beamsConstrain.removeAt(iB);
				 		}//next iB
			 		}
			 		else
			 			beamsConstrain.setLength(0);
			 	}
			}
		}
		if (painterBeam.bIsValid())
		{ 
			Map m;
			m.setString("Name", painterBeam.name());
			m.setString("Type",painterBeam.type());
			m.setString("Filter",painterBeam.filter());
			m.setString("Format",painterBeam.format());
			sPainterBeamStream.set(m.getDxContent(true));
		}
		_ThisInst.setCatalogFromPropValues(sLastInserted);
		_Pt0 = ptOrg;
   		Point3d ptLast = _Pt0;
   		String sStringStart = "|Select reference point [";
   		
   		String sElementSheetOptions[] ={"leFTtop","lefTMiddle","lefTBottom","middlETop","middlEMiddle","middlEBottom","rightTOp","rightMIddle","rightBOttom"};
   		String sElementSheetOption = "[leFTtop/lefTMiddle/lefTBottom/middlETop/middlEMiddle/middlEBottom/rightTOp/rightMIddle/rightBOttom/";
   		
   		String sStringModuses[] ={"ELementmodus", "SHeetmodus", "referenceaxisX", "referenceaxisY"};
   		String sStringModuse = "ELementmodus/SHeetmodus/referenceaxisX/referenceaxisY/";
   		
		String sStringStaggerings[] ={"staggerinGX", "staggerinGY", "staggeriNG", "gaPX", "gaPY","LEngth","WIdth"};
   		String sStringStaggering = "staggerinGX/staggerinGY/staggeriNG/gaPX/gaPY/LEngth/WIdth]|";
   		
		String sStringPrompt=T(sStringStart+sElementSheetOption+sStringModuse+sStringStaggering);
		
		if(sModuses.find(sModus)==0)
		{ 
			sStringModuse = "SHeetmodus/referenceaxisX/referenceaxisY/";
			sElementSheetOption = "";
			for (int iOption=0;iOption<sElementSheetOptions.length();iOption++) 
			{ 
				if(sAlignments.find(sAlignment)==iOption)
				{continue;}
				else
				{sElementSheetOption += sElementSheetOptions[iOption] + "/";}
			}//next iOption
		}
		else if(sModuses.find(sModus)==1)
		{ 
			sStringModuse = "ELementmodus/referenceaxisX/referenceaxisY/";
			sElementSheetOption = "";
			for (int iOption=0;iOption<sElementSheetOptions.length();iOption++) 
			{ 
				if(sAlignments.find(sAlignment)==iOption)
				{continue;}
				else
				{sElementSheetOption += sElementSheetOptions[iOption] + "/";}
			}//next iOption
		}
		else if(sModuses.find(sModus)==2)
		{ 
			sElementSheetOption = "";
			sStringModuse = "ELementmodus/SHeetmodus/referenceaxisY/";
		}
		else if(sModuses.find(sModus)==3)
		{ 
			sElementSheetOption = "";
			sStringModuse = "ELementmodus/SHeetmodus/referenceaxisX/";
		}
		if(sStaggeringDirections.find(sStaggeringDirection)==0)
			sStringStaggering = "staggerinGY/staggeriNG/gaPX/gaPY/LEngth/WIdth]|";
		else if(sStaggeringDirections.find(sStaggeringDirection)==1)
			sStringStaggering = "staggerinGX/staggeriNG/gaPX/gaPY/LEngth/WIdth]|";
		
		sStringPrompt=T(sStringStart+sElementSheetOption+sStringModuse+sStringStaggering);
		
		PrPoint ssP2(sStringPrompt, ptLast); 
		ssP2.setSnapMode(true, _kOsModeEnd | _kOsModeMid);
		Map mapArgs;
    	mapArgs.setPoint3d("ptBase", _Pt0); 
		// initialize
		mapArgs.setString("modus", sModus);
//		mapArgs.setString("horizontal", sAlignmentHorizontal);
//	    mapArgs.setString("vertical", sAlignmentVertical);
	    mapArgs.setString("alignment", sAlignment);
	    mapArgs.setString("sSheetOnFirstLastBeamAxis", sSheetOnFirstLastBeamAxis);
	    if(!bHasElement)
	    { 
	    	// Sheet or SIP
	    	// work with the bdReference
	    	mapArgs.setBody("bdRepresentation", bdRepresentation);
	    }
	    double dLengthMax, dWidthMax, dThicknessMax;
	    
	    if(iElementSheet)
	    { 
	    	for (int iSh=0;iSh<sheets.length();iSh++) 
		    { 
		    	if (sheets[iSh].dL() > dLengthMax)dLengthMax = sheets[iSh].dL();
		    	if (sheets[iSh].dW() > dWidthMax)dWidthMax = sheets[iSh].dW();
		    	if (sheets[iSh].dH() > dThicknessMax)dThicknessMax = sheets[iSh].dH();
		    }//next iSh
	    }
	    else if(!iElementSheet)
	    { 
	    	for (int iS=0;iS<sips.length();iS++) 
		    { 
		    	if (sips[iS].dL() > dLengthMax)dLengthMax = sips[iS].dL();
		    	if (sips[iS].dW() > dWidthMax)dWidthMax = sips[iS].dW();
		    	if (sips[iS].dH() > dThicknessMax)dThicknessMax = sips[iS].dH();
		    }//next iS
	    }
	    
	    // sip specific properties
	    String sSipStyle;
	    Vector3d vecWoodGrainDirection;
	    Vector3d vecXsip;
	    GenBeam gbUsed;
	    if(iElementSheet)
	    {
	    	gbUsed= sheets[0];
	    }
	    else if (!iElementSheet)
	    {
	    	gbUsed = sips[0];
	    	sSipStyle = sips[0].style();
	    	vecWoodGrainDirection = sips[0].woodGrainDirection();
	    	vecXsip = sips[0].vecX();
	    }
	    
	    { 
	    	Quader qd;
		    qd=Quader(gbUsed.ptCen(), gbUsed.vecX(),gbUsed.vecY(),gbUsed.vecZ(),
		    			dLengthMax, dWidthMax, dThicknessMax);
			// width
	    	if(ez.hasVar("width") && ez.dVar("width")>dEps)
		    {
		    	mapArgs.setDouble("width", ez.dVar("width"));
		    }
		    else
		    {
		    	// 
		    	mapArgs.setDouble("width", qd.dD(vecX));
		    }
	    	if(dSheetWidth>0)
    		{
    			mapArgs.setDouble("width", dSheetWidth);
    		}
	    	// length
	    	if(ez.hasVar("height sheet") && ez.dVar("height sheet")>dEps)
	    		mapArgs.setDouble("length", ez.dVar("height sheet"));
	    	else
	    	{
	    		mapArgs.setDouble("length", qd.dD(vecY));
	    	}
	    	if(dSheetLength>0)
	    	{
	    		mapArgs.setDouble("length", dSheetLength);
	    	}
	    	
	    	if(ez.hasVar("material"))
	    	{
	    		mapArgs.setString("material", ez.dVar("material"));
	    	}
	    	else if(!ez.hasVar("material"))
	    	{ 
	    		mapArgs.setString("material", gbUsed.name("material"));
	    	}
	    	if(sSheetMaterial!="")
	    		mapArgs.setString("material", sSheetMaterial);
			
	    	mapArgs.setString("label", gbUsed.label());
	    	mapArgs.setString("subLabel", gbUsed.subLabel());
	    	mapArgs.setString("subLabel2", gbUsed.subLabel2());
	    	mapArgs.setString("information", gbUsed.information());
	    	mapArgs.setString("grade", gbUsed.grade());
	    	mapArgs.setInt("color", gbUsed.color());
	    }
	    mapArgs.setPlaneProfile("sheet", ppSheet);
	    mapArgs.setVector3d("vecX", vecX);
	    mapArgs.setVector3d("vecY", vecY);
	    mapArgs.setDouble("staggeringOffset", dStaggeringOffset);
	    mapArgs.setString("sVecDir", sStaggeringDirection);
	    mapArgs.setDouble("dGapX", dGapX);
	    mapArgs.setDouble("dGapY", dGapY);
	    // properties relevant for custom modus
//	    mapArgs.setDouble("customOffset", dAxisRefOffset);
	    mapArgs.setDouble("customOffset", 0);
//	    mapArgs.setString("customAxisRef", sAxisRef);
	    mapArgs.setString("customPosition", sAxisRefPosition);
	    mapArgs.setString("sipStyle", sSipStyle);
	    mapArgs.setVector3d("woodGrainDirection", vecWoodGrainDirection);
	    mapArgs.setVector3d("vecXsip", vecXsip);
	    
	    
	    if(beamsConstrain.length()>0)
	    {
	    // store beams
		    Vector3d vecBeamNormal = vecZ.crossProduct(beamsConstrain[0].vecX());
	    	for (int i=0;i<beamsConstrain.length();i++) 
				for (int j=0;j<beamsConstrain.length()-1;j++) 
					if (vecBeamNormal.dotProduct(beamsConstrain[j].ptCen())>vecBeamNormal.dotProduct(beamsConstrain[j+1].ptCen()))
						beamsConstrain.swap(j, j + 1);
			int nSheetOnFirstLastBeamAxis=sNoYes.find(sSheetOnFirstLastBeamAxis);
//			if(!nSheetOnFirstLastBeamAxis)
//			{
//				beamsConstrain.removeAt(beamsConstrain.length()-1);
//    			beamsConstrain.removeAt(0);
//			}
	    // save in map
	    	mapArgs.setEntityArray(beamsConstrain, false, "beams", "","");
	    }
		int nGoJig = -1;
	    
	    while (nGoJig != _kOk && nGoJig!= _kNone)
	    {
	        nGoJig = ssP2.goJig(strJigAction1, mapArgs); 
	        String sHorizontals[] ={ T("|Left|"), T("|Left|"), T("|Left|"), T("|Middle|"), T("|Middle|"), T("|Middle|"),
	        			T("|Right|"), T("|Right|"), T("|Right|")};
	        String sVerticals[] ={ T("|Top|"), T("|Middle|"), T("|Bottom|"), T("|Top|"), T("|Middle|"), T("|Bottom|"),
	        			T("|Top|"), T("|Middle|"), T("|Bottom|")};
//	        sAlignmentHorizontal
			
	        if (nGoJig == _kOk)
	        {
	            ptLast = ssP2.value(); //retrieve the selected point
	            
	            // project point to plane with the viewdirection
	            Plane pnSheet(ppSheet.coordSys().ptOrg(), ppSheet.coordSys().vecZ());
	            Vector3d vecView = getViewDirection();
	            Line lnView(ptLast, vecView);
//	            Point3d ptIntersect = lnView.intersect(pnSheet, U(0));
//	            ptLast = ptIntersect;
				// HSB-12619
				int iRayIntersect;
				Point3d ptRayIntersect;
				iRayIntersect=bdRepresentation.rayIntersection(ptLast, -vecView, ptRayIntersect);
				if(!iRayIntersect)
				{ 
					iRayIntersect = bdRepresentation.rayIntersection(ptLast, vecView, ptRayIntersect);
				}
				if(iRayIntersect)
				{ 
					// intersection succasseful
					ptLast = ptRayIntersect;
				}
	           _PtG.append(ptLast); //append the selected points to the list of grippoints _PtG
	           _Map.setMap("mapJig", mapArgs );
	           // save ptjig in mapX
	           if(bHasElement)
	           { 
		           mapXprops.setPoint3d("PointJig", ptLast);
		           mapXel.setMap(sZoneNrName, mapXprops);
		           el.setSubMapX("hsbSheetDistribution", mapXel);
	           }
	        }
	        else if (nGoJig == _kKeyWord)
	        {
	            if (ssP2.keywordIndex() >= 0)
	            {
	            	// get modus and alignment from previous selection
					String sAlignmentMap = mapArgs.getString("alignment");
					String sAlignmentMapNew = sAlignmentMap;
					String sModusMap = mapArgs.getString("modus");
					String sModusMapNew = sModusMap;
					// those contained in selection
					String sElementSheetOptionsThis[0], sElementSheetOptionsNew[0];
					String sStringModusesThis[0], sStringModusesNew[0];
					String sAllThis[0], sAllNew[0];
					// build existing prompt
					if(sModuses.find(sModusMap)==0)
					{ 
						// element modus selected, contains alignment options
						sStringModuse = "SHeetmodus/referenceaxisX/referenceaxisY/";
						sStringModusesThis.append("SHeetmodus");
						sStringModusesThis.append("referenceaxisX");
						sStringModusesThis.append("referenceaxisY");
						sElementSheetOption = "";
						for (int iOption=0;iOption<sElementSheetOptions.length();iOption++) 
						{ 
							if(sAlignments.find(sAlignmentMap)==iOption)
								{continue;}
							else
							{
								sElementSheetOption += sElementSheetOptions[iOption] + "/";
								sElementSheetOptionsThis.append(sElementSheetOptions[iOption]);
							}
						}//next iOption
					}
					else if(sModuses.find(sModusMap)==1)
					{ 
						// sheet modus selected, contains alignment options
						sStringModuse = "ELementmodus/referenceaxisX/referenceaxisY/";
						sStringModusesThis.append("ELementmodus");
						sStringModusesThis.append("referenceaxisX");
						sStringModusesThis.append("referenceaxisY");
						sElementSheetOption = "";
						for (int iOption=0;iOption<sElementSheetOptions.length();iOption++) 
						{ 
							if(sAlignments.find(sAlignmentMap)==iOption)
								{continue;}
							else
							{
								sElementSheetOption += sElementSheetOptions[iOption] + "/";
								sElementSheetOptionsThis.append(sElementSheetOptions[iOption]);
							}
						}//next iOption
					}
					else if(sModuses.find(sModusMap)==2)
					{ 
						// referenceaxisX selected, no alignment options
						sElementSheetOption = "";
						sStringModuse = "ELementmodus/SHeetmodus/referenceaxisY/";
						sStringModusesThis.append("ELementmodus");
						sStringModusesThis.append("SHeetmodus");
						sStringModusesThis.append("referenceaxisY");
					}
					else if(sModuses.find(sModusMap)==3)
					{ 
						// referenceaxisY selected, no alignment options
						sElementSheetOption = "";
						sStringModuse = "ELementmodus/SHeetmodus/referenceaxisX/";
						sStringModusesThis.append("ELementmodus");
						sStringModusesThis.append("SHeetmodus");
						sStringModusesThis.append("referenceaxisX");
					}
					String sStringStaggeringsThis[0];
					if(sStaggeringDirections.find(sStaggeringDirection)==0)
					{
						// x is selected, show Y
						sStringStaggering = "staggerinGY/staggeriNG/gaPX/gaPY/LEngth/WIdth]|";
						sStringStaggeringsThis.append("staggerinGY");
						sStringStaggeringsThis.append("staggeriNG");
						sStringStaggeringsThis.append("gaPX");
						sStringStaggeringsThis.append("gaPY");
						sStringStaggeringsThis.append("LEngth");
						sStringStaggeringsThis.append("WIdth");
					}
					else if(sStaggeringDirections.find(sStaggeringDirection)==1)
					{
						sStringStaggering = "staggerinGX/staggeriNG/gaPX/gaPY/LEngth/WIdth]|";
						sStringStaggeringsThis.append("staggerinGX");
						sStringStaggeringsThis.append("staggeriNG");
						sStringStaggeringsThis.append("gaPX");
						sStringStaggeringsThis.append("gaPY");
						sStringStaggeringsThis.append("LEngth");
						sStringStaggeringsThis.append("WIdth");
					}
					
//					sStringPrompt=T(sStringStart+sElementSheetOption+sStringModuse);
					// all current options
					sAllThis.append(sElementSheetOptionsThis);
					sAllThis.append(sStringModusesThis);
					sAllThis.append(sStringStaggeringsThis);
					
					// get the selected element from the index
					String sSelected = sAllThis[ssP2.keywordIndex()];
					
					if(sStringModuses.find(sSelected)>-1)
						sModusMapNew = sModuses[sStringModuses.find(sSelected)];
					if(sElementSheetOptions.find(sSelected)>-1)
						sAlignmentMapNew = sAlignments[sElementSheetOptions.find(sSelected)];
					String sStringStaggeringNew;
					if(sStringStaggeringsThis.find(sSelected)>-1)
					{ 
						if(sStringStaggerings.find(sSelected)==0)
						{
							sStaggeringDirection.set(sStaggeringDirections[0]);
							mapArgs.setString("sVecDir", "X");
							sStringStaggeringNew = "X";
						}
						else if(sStringStaggerings.find(sSelected)==1)
						{
							sStaggeringDirection.set(sStaggeringDirections[1]);
							mapArgs.setString("sVecDir", "Y");
							sStringStaggeringNew = "Y";
						}
						else if(sStringStaggerings.find(sSelected)==2)
						{
							// prompt enter staggering value
//							"staggeringOffset"
							String sEnter = getString(TN("|Enter Staggering Value, current value:|")+" "+mapArgs.getDouble("staggeringOffset"));
							mapArgs.setDouble("staggeringOffset", sEnter.atof());
							dStaggeringOffset.set(sEnter.atof());
						}
						else if(sStringStaggerings.find(sSelected)==3)
						{ 
							// prompt gapx value
//							dGapX
							String sEnter = getString(TN("|Enter Gap X Value|")+" "+mapArgs.getDouble("dGapX"));
							mapArgs.setDouble("dGapX", sEnter.atof());
							dGapX.set(sEnter.atof());
						}
						else if(sStringStaggerings.find(sSelected)==4)
						{ 
							// prompt gapy value
							// dGapY
							String sEnter = getString(TN("|Enter Gap Y Value|")+" "+mapArgs.getDouble("dGapY"));
							mapArgs.setDouble("dGapY", sEnter.atof());
							dGapY.set(sEnter.atof());
						}
						else if(sStringStaggerings.find(sSelected)==5)
						{ 
							// prompt length value
							// dLength
							String sEnter = getString(TN("|Enter Sheet Length Value|")+" "+mapArgs.getDouble("length"));
							mapArgs.setDouble("length", sEnter.atof());
							dSheetLength.set(sEnter.atof());
						}
						else if(sStringStaggerings.find(sSelected)==6)
						{ 
							// prompt length value
							// dLength
							String sEnter = getString(TN("|Enter Sheet Width Value|")+" "+mapArgs.getDouble("width"));
							mapArgs.setDouble("width", sEnter.atof());
							dSheetWidth.set(sEnter.atof());
						}
					}
					// save new modus and alignment from last selected option
					mapArgs.setString("modus", sModusMapNew);
	    			mapArgs.setString("alignment", sAlignmentMapNew);
	    			// save the properties
	            	sAlignment.set(sAlignmentMapNew);
	            	sModus.set(sModusMapNew);
					// build the new prompt
					if (sModuses.find(sModusMapNew) == 0)
					{ 
						sStringModuse = "SHeetmodus/referenceaxisX/referenceaxisY/";
						sStringModusesThis.append("SHeetmodus");
						sStringModusesThis.append("referenceaxisX");
						sStringModusesThis.append("referenceaxisY");
						sElementSheetOption = "";
						for (int iOption=0;iOption<sElementSheetOptions.length();iOption++) 
						{ 
							if(sAlignments.find(sAlignmentMapNew)==iOption)
								{continue;}
							else
							{
								sElementSheetOption += sElementSheetOptions[iOption] + "/";
								sElementSheetOptionsNew.append(sElementSheetOptions[iOption]);
							}
						}//next iOption
					}
					else if(sModuses.find(sModusMapNew)==1)
					{ 
						sStringModuse = "ELementmodus/referenceaxisX/referenceaxisY/";
						sStringModusesNew.append("ELementmodus");
						sStringModusesNew.append("referenceaxisX");
						sStringModusesNew.append("referenceaxisY");
						sElementSheetOption = "";
						for (int iOption=0;iOption<sElementSheetOptions.length();iOption++) 
						{ 
							if(sAlignments.find(sAlignmentMapNew)==iOption)
								{continue;}
							else
							{
								sElementSheetOption += sElementSheetOptions[iOption] + "/";
								sElementSheetOptionsNew.append(sElementSheetOptions[iOption]);
							}
						}//next iOption
					}
					else if(sModuses.find(sModusMapNew)==2)
					{ 
						sElementSheetOption = "";
						sStringModuse = "ELementmodus/SHeetmodus/referenceaxisY/";
						sStringModusesNew.append("ELementmodus");
						sStringModusesNew.append("SHeetmodus");
						sStringModusesNew.append("referenceaxisY");
					}
					else if(sModuses.find(sModusMapNew)==3)
					{ 
						sElementSheetOption = "";
						sStringModuse = "ELementmodus/SHeetmodus/referenceaxisX/";
						sStringModusesNew.append("ELementmodus");
						sStringModusesNew.append("SHeetmodus");
						sStringModusesNew.append("referenceaxisX");
					}
					
					if(sStringStaggeringNew=="X")
					{ 
						sStringStaggering = "staggerinGY/staggeriNG/gaPX/gaPY/LEngth/WIdth]|";
					}
					else if(sStringStaggeringNew=="Y")
					{ 
						sStringStaggering = "staggerinGX/staggeriNG/gaPX/gaPY/LEngth/WIdth]|";
					}
					// new prompt
					sStringPrompt=T(sStringStart+sElementSheetOption+sStringModuse+sStringStaggering);
	            	
	            	ssP2 = PrPoint(sStringPrompt, ptLast);
	            	ssP2.setSnapMode(true, _kOsModeEnd | _kOsModeMid);
	            }
	        }
	        else if (nGoJig == _kCancel)
	        { 
	            eraseInstance(); // do not insert this instance
	            return; 
	        }
	    }
	    //
//	    eraseInstance();
		return;
	}
// end on insert	__________________//endregion
	
	if(sPainterBeams.find(sPainterBeam)<0)
		sPainterBeam.set(sPainterBeams[0]);

//region mapIO: support property dialog input via map on element creation
	{
		int bHasPropertyMap = _Map.hasMap("PROPSTRING[]") && _Map.hasMap("PROPINT[]") && _Map.hasMap("PROPDOUBLE[]");
		if (_bOnMapIO)
		{ 
			if (bHasPropertyMap)
				setPropValuesFromMap(_Map);	
			showDialog();
			_Map = mapWithPropValues();
			// write properties in mapX 
//			{ 
//				String sPropStrings[7];
//				double dPropDoubles[6];
//				int iPropInts[1];
//				sPropStrings[0] = sModus;
//		//		sPropStrings[1] = sAlignmentHorizontal;
//		//		sPropStrings[2] = sAlignmentVertical;
//				sPropStrings[1] = sAlignment;
//				sPropStrings[2] = sStaggeringDirection;
//		//		sPropStrings[3] = sAxisRef;
//				sPropStrings[3] = sAxisRefPosition;
//				sPropStrings[4] = sSheetName;
//				sPropStrings[5] = sSheetMaterial;
//				sPropStrings[6] = sPainterBeam;
//				//
//				dPropDoubles[0] = dStaggeringOffset;
//		//		dPropDoubles[1] = dAxisRefOffset;
//				dPropDoubles[1] = dSheetLength;
//				dPropDoubles[2] = dSheetWidth;
//				dPropDoubles[3] = dSheetThickness;
//				dPropDoubles[4] = dGapX;
//				dPropDoubles[5] = dGapY;
//				//
//				iPropInts[0] = nZone;
//				
//				Map mapPropStrings;
//				for (int i=0;i<sPropStrings.length();i++) 
//				{ 
//					Map map;
//					map.setString("strValue", sPropStrings[i]);
//					mapPropStrings.appendMap("PropString", map);
//				}//next i
//				Map mapPropDoubles;
//				for (int i=0;i<dPropDoubles.length();i++) 
//				{ 
//					Map map;
//					map.setDouble("dValue", dPropDoubles[i]);
//					mapPropDoubles.appendMap("PropDouble", map);
//				}//next i
//				Map mapPropInts;
//				for (int i=0;i<iPropInts.length();i++) 
//				{ 
//					Map map;
//					map.setInt("iValue", iPropInts[i]);
//					mapPropInts.appendMap("PropInt", map);
//				}//next i
//				Map mapXprops;
//				mapXprops.appendMap("PropString[]", mapPropStrings );
//				mapXprops.appendMap("PropDouble[]", mapPropDoubles );
//				mapXprops.appendMap("PropInt[]", mapPropInts );
//				if(_PtG.length()>0)
//					mapXprops.setPoint3d("PointJig", _PtG[0]);
//				
//				el.setSubMapX("hsbSheetDistribution", mapXprops);
//			}
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
			
//			Map mapXel = _Element[0].subMapX("hsbSheetDistribution");
//			Map mapXprops;
//			String sZoneNr = nZone;
//			String sZoneNrName = "zone"+sZoneNr;
//			if(mapXel.hasMap(sZoneNrName))
//			{ 
//				mapXprops = mapXel.getMap(sZoneNrName);
//			}
////			Map mapXprops = _Element[0].subMapX("hsbSheetDistribution");
//			if(mapXprops.hasMap("PropString[]") && mapXprops.hasMap("PropDouble[]") && mapXprops.hasMap("PropInt[]"))
//			{ 
//				Map mapPropsString = mapXprops.getMap("PropString[]");
//				Map mapPropsDouble = mapXprops.getMap("PropDouble[]");
//				Map mapPropsInt = mapXprops.getMap("PropInt[]");
//				String sPropStrings[7];
//				double dPropDoubles[6];
//				int iPropInts[1];
//				for (int i=0;i<mapPropsString.length();i++) 
//					sPropStrings[i] = mapPropsString.getMap(i).getString("strValue");
//				for (int i=0;i<mapPropsDouble.length();i++) 
//					dPropDoubles[i] = mapPropsDouble.getMap(i).getDouble("dValue");
//				for (int i=0;i<mapPropsInt.length();i++) 
//					iPropInts[i] = mapPropsInt.getMap(i).getInt("iValue");
//				sModus.set(sPropStrings[0]);
//				sAlignment.set(sPropStrings[1]);
////				sAlignmentHorizontal.set(sPropStrings[1]);
////				sAlignmentVertical.set(sPropStrings[2]);
//				sStaggeringDirection.set(sPropStrings[2]);
//				//
////				sAxisRef.set(sPropStrings[4]);
//				sAxisRefPosition.set(sPropStrings[3]);
//				
//				sSheetName.set(sPropStrings[4]);
//				sSheetMaterial.set(sPropStrings[5]);
//				sPainterBeam.set(sPropStrings[6]);
//				//
//				dStaggeringOffset.set(dPropDoubles[0]);
////				dAxisRefOffset.set(dPropDoubles[1]);
//				dSheetLength.set(dPropDoubles[1]);
//				dSheetWidth.set(dPropDoubles[2]);
//				dSheetThickness.set(dPropDoubles[3]);
//				dGapX.set(dPropDoubles[4]);
//				dGapY.set(dPropDoubles[5]);
//				
//				nZone.set(iPropInts[0]);
//			}
//			_Map = mapWithPropValues();
		}
	}
	//End mapIO: support property dialog input via map on element creation//endregion 	

//	return;
//	if(_Element.length()!=1)
//	{ 
//		reportMessage(TN("|1 Element needed|"));
//		eraseInstance();
//		return;
//	}
//	return;
	int bHasElement;
	Element el;
	Point3d ptOrg;
	Vector3d vecX;
	Vector3d vecY;
	Vector3d vecZ;
	Sheet sheets[0];
	Sip sips[0];
	CoordSys csZone;
	ElemZone ez;
	if(_Element.length()==1)
	{ 
		// element
		bHasElement = true;
		el = _Element[0];
		ez = el.zone(nZone);
		csZone = ez.coordSys();
		ptOrg = el.ptOrg();
		vecX = el.vecX();
		vecY = el.vecY();
		vecZ = el.vecZ();
		sheets.append(el.sheet(nZone));
		Sip sipsAll[] = el.sip();
		for (int iS=0;iS<sipsAll.length();iS++) 
		{ 
			if (sipsAll[iS].myZoneIndex() == nZone)
			{ 
				if(sips.find(sipsAll[iS])<0)
					sips.append(sipsAll[iS]);
			}
		}//next iS
	}
	else if(!bHasElement)
	{ 
		// no element
		if(_Sheet.length()>0)
		{ 
			sheets.append(_Sheet);
			csZone = _Sheet[0].coordSys();
			ptOrg = csZone.ptOrg();
			vecX = csZone.vecX();
			vecY = csZone.vecY();
			vecZ = csZone.vecZ();
		}
		else if(_Sip.length()>0)
		{ 
			sips.append(_Sip);
			csZone = _Sip[0].coordSys();
			ptOrg = csZone.ptOrg();
			vecX = csZone.vecX();
			vecY = csZone.vecY();
			vecZ = csZone.vecZ();
		}
	}
	
	if(bHasElement && sheets.length()==0 && sips.length()==0)
	{ 
		// wait for element calculation
		return;
	}
	int iElementSheet;
	if(sheets.length()>0)
	{ 
		iElementSheet=true;
	}
	else if(sips.length()>0)
	{ 
		iElementSheet=false;
	}
	Display dpJ(3);
	Map mapJig;
	// load ptg from mapx if available
	Map mapXel;
	Map mapXprops;
	String sZoneNrName;
	if(bHasElement)
	{
		mapXel=el.subMapX("hsbSheetDistribution");
		String sZoneNr=nZone;
		sZoneNrName="zone"+sZoneNr;
		if(mapXel.hasMap(sZoneNrName))
		{ 
			mapXprops=mapXel.getMap(sZoneNrName);
		}
	}
//	Map mapXprops = el.subMapX("hsbSheetDistribution");
	if (mapXprops.hasPoint3d("PointJig"))
	{
		if(_PtG.length()==0)
		{
			_PtG.append(mapXprops.getPoint3d("PointJig"));
		}
		else if(_PtG.length()==1)
		{ 
//			_PtG[0].vis(3);
			_PtG[0]=mapXprops.getPoint3d("PointJig");
//			Point3d ptg = mapXprops.getPoint3d("PointJig");
//			reportMessage("\n"+scriptName()+" "+T("|ptgx|")+ptg.X());
			
		}
	}
//	_PtG[0].vis(1);
//return;
	// 
	if(_Map.hasMap("mapJig"))
	{
		mapJig= _Map.getMap("mapJig");
//		Map mp = mapWithPropValues();
//		
//		int uu;
//		_Map = mapWithPropValues();
		// write properties in mapX 
		{ 
			String sPropStrings[9];
			double dPropDoubles[6];
			int iPropInts[1];
			sPropStrings[0] = sModus;
	//		sPropStrings[1] = sAlignmentHorizontal;
	//		sPropStrings[2] = sAlignmentVertical;
			sPropStrings[1] = sAlignment;
			sPropStrings[2] = sStaggeringDirection;
	//		sPropStrings[3] = sAxisRef;
			sPropStrings[3] = sAxisRefPosition;
			sPropStrings[4] = sSheetName;
			sPropStrings[5] = sSheetMaterial;
			sPropStrings[6] = sPainterBeam;
			sPropStrings[7] = sPainterBeamStream;
			sPropStrings[8] = sSheetOnFirstLastBeamAxis;
			
			//
			dPropDoubles[0] = dStaggeringOffset;
	//		dPropDoubles[1] = dAxisRefOffset;
			dPropDoubles[1] = dSheetLength;
			dPropDoubles[2] = dSheetWidth;
			dPropDoubles[3] = dSheetThickness;
			dPropDoubles[4] = dGapX;
			dPropDoubles[5] = dGapY;
			//
			iPropInts[0] = nZone;
			
			Map mapPropStrings;
			for (int i=0;i<sPropStrings.length();i++) 
			{ 
				Map map;
				map.setString("strValue", sPropStrings[i]);
				mapPropStrings.appendMap("PropString", map);
			}//next i
			Map mapPropDoubles;
			for (int i=0;i<dPropDoubles.length();i++) 
			{ 
				Map map;
				map.setDouble("dValue", dPropDoubles[i]);
				mapPropDoubles.appendMap("PropDouble", map);
			}//next i
			Map mapPropInts;
			for (int i=0;i<iPropInts.length();i++) 
			{ 
				Map map;
				map.setInt("iValue", iPropInts[i]);
				mapPropInts.appendMap("PropInt", map);
			}//next i
//			Map mapXprops;
//			String sZoneNr = nZone;
//			String sZoneNrName = "zone"+sZoneNr;
//			if(mapXel.hasMap(sZoneNrName))
//			{
//				mapXprops = mapXel.getMap(sZoneNrName);
//			}
			if(bHasElement)
			{ 
				mapXprops.setMap("PropString[]", mapPropStrings );
				mapXprops.setMap("PropDouble[]", mapPropDoubles );
				mapXprops.setMap("PropInt[]", mapPropInts );
				if(_PtG.length()>0)
					mapXprops.setPoint3d("PointJig", _PtG[0]);
				mapXel.setMap(sZoneNrName, mapXprops);
				el.setSubMapX("hsbSheetDistribution", mapXel);
			}
		}
	}
	else
	{ 
//		if(mapXprops.hasMap("PropString[]") && mapXprops.hasMap("PropDouble[]") && mapXprops.hasMap("PropInt[]"))
//		{ 
//			Map mapPropsString = mapXprops.getMap("PropString[]");
//			Map mapPropsDouble = mapXprops.getMap("PropDouble[]");
//			Map mapPropsInt = mapXprops.getMap("PropInt[]");
//			String sPropStrings[7];
//			double dPropDoubles[6];
//			int iPropInts[1];
//			for (int i=0;i<mapPropsString.length();i++) 
//				sPropStrings[i] = mapPropsString.getMap(i).getString("strValue");
//			for (int i=0;i<mapPropsDouble.length();i++) 
//				dPropDoubles[i] = mapPropsDouble.getMap(i).getDouble("dValue");
//			for (int i=0;i<mapPropsInt.length();i++) 
//				iPropInts[i] = mapPropsInt.getMap(i).getInt("iValue");
//			sModus.set(sPropStrings[0]);
//			sAlignment.set(sPropStrings[1]);
////				sAlignmentHorizontal.set(sPropStrings[1]);
////				sAlignmentVertical.set(sPropStrings[2]);
//			sStaggeringDirection.set(sPropStrings[2]);
//			//
////				sAxisRef.set(sPropStrings[4]);
//			sAxisRefPosition.set(sPropStrings[3]);
//			
//			sSheetName.set(sPropStrings[4]);
//			sSheetMaterial.set(sPropStrings[5]);
//			sPainterBeam.set(sPropStrings[6]);
//			//
//			dStaggeringOffset.set(dPropDoubles[0]);
////				dAxisRefOffset.set(dPropDoubles[1]);
//			dSheetLength.set(dPropDoubles[1]);
//			dSheetWidth.set(dPropDoubles[2]);
//			dSheetThickness.set(dPropDoubles[3]);
//			dGapX.set(dPropDoubles[4]);
//			dGapY.set(dPropDoubles[5]);
//			
//			nZone.set(iPropInts[0]);
//		}
		_Map = mapWithPropValues();
//		_Map = mapWithPropValues();
		// prepare mapJig from properties
//		CoordSys csZone = ez.coordSys();
		Plane pnZone(csZone.ptOrg(), csZone.vecZ());
		PlaneProfile ppSheet(pnZone);
		if(iElementSheet)
		{ 
		// zone contains sheets
			for (int i=0;i<sheets.length();i++) 
			{ 
				PlaneProfile ppI(pnZone);
				PlaneProfile ppSheetI = sheets[i].profShape();
				PLine plsNoOp[] = ppSheetI.allRings(true, false);
				PLine plsOp[] = ppSheetI.allRings(false, true);
				// HSB-11037
				for (int ii=0;ii<plsNoOp.length();ii++) 
				{ 
					ppI.joinRing(plsNoOp[ii], _kAdd);
				}//next ii
	//			ppI.joinRing(sheets[i].plEnvelope(), _kAdd);
				ppI.shrink(-U(20));
				ppSheet.unionWith(ppI);
	//			ppSheet.joinRing(sheets[i].plEnvelope(), _kAdd);
			}//next i
			ppSheet.shrink(U(20));
			for (int i=0;i<sheets.length();i++) 
			{ 
				// HSB-11037
				PlaneProfile ppSheetI = sheets[i].profShape();
				PLine plsOp[] = ppSheetI.allRings(false, true);
				for (int ii=0;ii<plsOp.length();ii++) 
				{ 
					ppSheet.joinRing(plsOp[ii], _kSubtract);
				}//next ii
	//			PLine plOp[] = sheets[i].plOpenings();
	//			for (int o = 0; o < plOp.length(); o++)
	//			{
	//				ppSheet.joinRing(plOp[o], _kSubtract);
	//			}
			}//next i
		}
		else if(!iElementSheet)
		{ 
		// zone contains sips
			mapJig.setString("sipStyle", sips[0].style());
			csZone = sips[0].coordSys();
			pnZone = Plane(csZone.ptOrg(), csZone.vecZ());
			ppSheet=PlaneProfile (pnZone);
			for (int i=0;i<sips.length();i++) 
			{ 
				PlaneProfile ppI(pnZone);
				PlaneProfile ppSheetI = ppI;
				ppSheetI.joinRing(sips[i].plEnvelope(), _kAdd);
				
				PLine plOpsI[] = sips[i].plOpenings();
				for (int iO=0;iO<plOpsI.length();iO++) 
				{ 
					ppSheetI.joinRing(plOpsI[iO], _kSubtract);
				}//next iO
				
//				PlaneProfile ppSheetI = sheets[i].profShape();
				PLine plsNoOp[] = ppSheetI.allRings(true, false);
				// HSB-11037
				for (int ii=0;ii<plsNoOp.length();ii++) 
				{ 
					ppI.joinRing(plsNoOp[ii], _kAdd);
				}//next ii
				
	//			ppI.joinRing(sheets[i].plEnvelope(), _kAdd);
				ppI.shrink(-U(20));
				ppSheet.unionWith(ppI);
	//			ppSheet.joinRing(sheets[i].plEnvelope(), _kAdd);
			}//next i
			ppSheet.shrink(U(20));
			for (int i=0;i<sips.length();i++) 
			{ 
				PLine plsOp[] = sips[i].plOpenings();
				for (int ii=0;ii<plsOp.length();ii++) 
				{ 
					ppSheet.joinRing(plsOp[ii], _kSubtract);
				}//next ii
				// HSB-11037
//				PlaneProfile ppSheetI = sheets[i].profShape();
//				PLine plsOp[] = ppSheetI.allRings(false, true);
//				for (int ii=0;ii<plsOp.length();ii++) 
//				{ 
//					ppSheet.joinRing(plsOp[ii], _kSubtract);
//				}//next ii
				
	//			PLine plOp[] = sheets[i].plOpenings();
	//			for (int o = 0; o < plOp.length(); o++)
	//			{
	//				ppSheet.joinRing(plOp[o], _kSubtract);
	//			}
			}//next i
		}
		// selected painter
		int iPainterBeam = sPainterBeams.find(sPainterBeam, 0);
		PainterDefinition painterBeam;
		Beam beamsConstrain[0];
		if(sPainterBeam!=sDisabled)
		{
			painterBeam = PainterDefinition(sPainterCollection + "\\" + sPainterBeam);
			String sPainterFilter = painterBeam.filter();
			if(sPainterFilter.find("IsParallelToElementY" ,- 1) > 0 
				|| sPainterFilter.find("IsParallelToElementX" ,- 1) > 0)
			// get beams
			{
			 	Beam beamsAll[]=el.beam();
			 	if(painterBeam.bIsValid())
			 	{
			 		beamsConstrain = painterBeam.filterAcceptedEntities(beamsAll);
			 	}
			 	if(beamsConstrain.length()>0)
			 	{ 
			 		Vector3d vecBeam = beamsConstrain[0].vecX();
			 		if(vecBeam.isParallelTo(vecX) || vecBeam.isParallelTo(vecY))
			 		{ 
			 			for (int iB=beamsConstrain.length()-1; iB>=0 ; iB--) 
				 		{ 
				 			if(!vecBeam.isParallelTo(beamsConstrain[iB].vecX()))
				 				beamsConstrain.removeAt(iB);
				 		}//next iB
			 		}
			 		else
			 			beamsConstrain.setLength(0);
			 	}
			}
		}
		if (painterBeam.bIsValid())
		{ 
			Map m;
			m.setString("Name", painterBeam.name());
			m.setString("Type",painterBeam.type());
			m.setString("Filter",painterBeam.filter());
			m.setString("Format",painterBeam.format());
			sPainterBeamStream.set(m.getDxContent(true));
		}
		_ThisInst.setCatalogFromPropValues(sLastInserted);
		mapJig.setString("modus", sModus);
//		mapJig.setString("horizontal", sAlignmentHorizontal);
//	    mapJig.setString("vertical", sAlignmentVertical);
	    mapJig.setString("alignment", sAlignment);
		// sheet properties
		double dLengthMax, dWidthMax, dThicknessMax;
		if(iElementSheet)
		{ 
			// 
		    for (int iSh=0;iSh<sheets.length();iSh++) 
		    { 
		    	if (sheets[iSh].dL() > dLengthMax)dLengthMax = sheets[iSh].dL();
		    	if (sheets[iSh].dW() > dWidthMax)dWidthMax = sheets[iSh].dW();
		    	if (sheets[iSh].dH() > dThicknessMax)dThicknessMax = sheets[iSh].dH();
		    }//next iSh
	    }
	    else if ( ! iElementSheet)
	    { 
	    	for (int iS=0;iS<sips.length();iS++) 
		    { 
		    	if (sips[iS].dL() > dLengthMax)dLengthMax = sips[iS].dL();
		    	if (sips[iS].dW() > dWidthMax)dWidthMax = sips[iS].dW();
		    	if (sips[iS].dH() > dThicknessMax)dThicknessMax = sips[iS].dH();
		    }//next iS
	    }
	    
	    GenBeam gbUsed;
	    if(iElementSheet)
	    	gbUsed= sheets[0];
	    else if ( ! iElementSheet)
	    {
	    	gbUsed = sips[0];
	    }
	    
	    { 
	    	Quader qd(gbUsed.ptCen(), gbUsed.vecX(),gbUsed.vecY(),gbUsed.vecZ(),
	    			dLengthMax, dWidthMax, dThicknessMax);
	    	if(ez.hasVar("width") && ez.dVar("width")>dEps)
		    	mapJig.setDouble("width", ez.dVar("width"));
		    else
		    {
		    	mapJig.setDouble("width", qd.dD(vecX));
		    }
	    	if(dSheetWidth>0)
    		{
    			mapJig.setDouble("width", dSheetWidth);
    		}
	    	
	    	if(ez.hasVar("height sheet") && ez.dVar("height sheet")>dEps)
	    		mapJig.setDouble("length", ez.dVar("height sheet"));
	    	else
	    	{
	    		mapJig.setDouble("length", qd.dD(vecY));
	    	}
	    	if(dSheetLength>0)
	    		mapJig.setDouble("length", dSheetLength);
	    		
	    	if(ez.hasVar("material"))
	    		mapJig.setString("material", ez.dVar("material"));
	    	else if(!ez.hasVar("material"))
	    	{ 
	    		mapJig.setString("material", gbUsed.name("material"));
	    	}
	    	if(sSheetMaterial!="")
	    		mapJig.setString("material", sSheetMaterial);
	    		
	    	mapJig.setString("label", gbUsed.label());
	    	mapJig.setString("subLabel", gbUsed.subLabel());
	    	mapJig.setString("subLabel2", gbUsed.subLabel2());
	    	mapJig.setString("information", gbUsed.information());
	    	mapJig.setString("grade", gbUsed.grade());
	    	mapJig.setInt("color", gbUsed.color());
	    }
	    //
	    mapJig.setPlaneProfile("sheet", ppSheet);
	    mapJig.setVector3d("vecX", vecX);
	    mapJig.setVector3d("vecY", vecY);
	    mapJig.setDouble("staggeringOffset", dStaggeringOffset);
	    mapJig.setString("sVecDir", sStaggeringDirection);
	    mapJig.setDouble("dGapX", dGapX);
	    mapJig.setDouble("dGapY", dGapY);
	    // properties relevant for custom modus
//	    mapJig.setDouble("customOffset", dAxisRefOffset);
	    mapJig.setDouble("customOffset", 0);
//	    mapJig.setString("customAxisRef", sAxisRef);
	    mapJig.setString("customPosition", sAxisRefPosition);
	    if(beamsConstrain.length()>0)
	    	mapJig.setEntityArray(beamsConstrain, false, "beams", "","");
	    String sAxisRef="X";
	    if (sModuses.find(sModus)==3)sAxisRef="Y";
	    // load ptg from mapx
//	    if (mapXprops.hasPoint3d("PointJig"))
//		{
//			if(_PtG.length()==0)
//			{
//				_PtG.append(mapXprops.getPoint3d("PointJig"));
//			}
//			else if(_PtG.length()==1)
//			{ 
//				_PtG[0] = mapXprops.getPoint3d("PointJig");
//			}
//		}
	    if((sModuses.find(sModus)==2 || sModuses.find(sModus)==3)&& _PtG.length()==0)
	    { 
	    	//
	    	Vector3d vecRef = vecX;
			Vector3d vecRefNormal = vecY;
			double dWidthNormal = mapJig.getDouble("width");
			double dLengthNormal = mapJig.getDouble("length");
			if(sAxisRef=="Y")
			{ 
				vecRef = vecY;
				vecRefNormal = vecX;
				dWidthNormal = mapJig.getDouble("length");
				dLengthNormal = mapJig.getDouble("width");;
			}
//			if(beamsConstrain.length()>0)
//			{ 
//				vecRef = beamsConstrain[0].vecX();
//				vecRefNormal = vecX;
//				dWidthNormal = mapJig.getDouble("length");
//				dLengthNormal = mapJig.getDouble("width");
//				if (vecRef.isParallelTo(vecX))
//    			{
//    				vecRef = vecX;
//    				vecRefNormal = vecY;
//    				dWidthNormal = mapJig.getDouble("width");
//					dLengthNormal = mapJig.getDouble("length");
//    			}
//    			else
//    			{ 
//    				vecRef = vecY;
//    			}
//			}
	    	// if ptg is given, calc sAxisRefPosition from ptg[0]
	    	// otherwise calculate ptg0 here from reference offset
//	    	Map mapXprops = el.subMapX("hsbSheetDistribution");
	    	if (mapXprops.hasPoint3d("PointJig"))
    		{
    			_PtG.append(mapXprops.getPoint3d("PointJig"));
    		}
    		else
    		{
    			LineSeg seg = ppSheet.extentInDir(vecRef);
    		// sheeting countour
				double dX=abs(vecRef.dotProduct(seg.ptStart()-seg.ptEnd()));
				double dY=abs(vecRefNormal.dotProduct(seg.ptStart()-seg.ptEnd()));
				Point3d pts[7];
//				Point3d ptMidSheet = seg.ptMid() + vecRefNormal * (dAxisRefOffset + .5*dLengthNormal);
//				Point3d ptMidSheet=seg.ptMid()+vecRefNormal*(0+.5*dLengthNormal);
				Point3d ptMidSheet=seg.ptMid();
				ptMidSheet.vis(3);
			// Left Sheet Left Element
				pts[0]=ptMidSheet-vecRef*(.5*dX-.5*dWidthNormal);
			// Right Sheet Middle Element
				pts[1]=ptMidSheet-vecRef*.5*dWidthNormal;
			// Middle Sheet Middle Element
				pts[2]=ptMidSheet;
			// Left Sheet Middle Element
				pts[3]=ptMidSheet+vecRef*.5*dWidthNormal;
			// Right Sheet Right Element
				pts[4]=ptMidSheet+vecRef*(.5*dX-.5*dWidthNormal);
			// Middle Sheet Left Element
				pts[5]=ptMidSheet-vecRef*(.5*dX);
			// Middle Sheet Right Element
				pts[6]=ptMidSheet+vecRef*(.5*dX);
				int nnn=sAxisRefPositions.find(sAxisRefPosition);
//				pts[0].vis(1);
				_PtG.append(pts[sAxisRefPositions.find(sAxisRefPosition)]);
//				_PtG[0].vis(6);
    		}
	    }
	}
	// calculation
	{ 
		int nSheetOnFirstLastBeamAxis=sNoYes.find(sSheetOnFirstLastBeamAxis);
		int nPtGdefined=true;
		if (_PtG.length()<1)
		{
			reportMessage("\n"+scriptName()+" "+T("|unexpected no grip point found|"));
			_PtG.append(_Pt0);
			nPtGdefined=false;
		}
    	Point3d ptJig=_PtG[0];
//    	ptJig.vis(3);
    	PlaneProfile ppSheet = mapJig.getPlaneProfile("sheet");
	    CoordSys cs = ppSheet.coordSys();
//	    String sH = mapJig.getString("horizontal");
//	    sAlignmentHorizontal.set(sAlignmentHorizontals[sAlignmentHorizontals.find(sH)]);
//	    String sV = mapJig.getString("vertical");
//	    sAlignmentVertical.set(sAlignmentVerticals[sAlignmentVerticals.find(sV)]);

	    String sAlignmentMap = mapJig.getString("alignment");
	    sAlignment.set(sAlignments[sAlignments.find(sAlignmentMap)]);
	    String sM = mapJig.getString("modus");
	    sModus.set(sModuses[sModuses.find(sM)]);
	    double dWidth = mapJig.getDouble("width");
	    double dLength = mapJig.getDouble("length");
	    Vector3d vecX = mapJig.getVector3d("vecX");
	    Vector3d vecY = mapJig.getVector3d("vecY");
	    PlaneProfile ppXlarge(cs), ppBeamLarge(cs);
    	PlaneProfile ppYlarge(cs), ppBeamNormalLarge(cs);
    	{ 
	    	// get extents of profile
	    	LineSeg seg = ppSheet.extentInDir(vecX);
    		double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
    		double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
	    	PLine plXlarge(cs.vecZ());
	    	PLine plYlarge(cs.vecZ());
	    	plXlarge.createRectangle(LineSeg(seg.ptMid() - U(10e4) * vecX - .5 * dY * vecY, 
	    				seg.ptMid() + U(10e4) * vecX + .5 * dY * vecY), vecX, vecY);
	    	plYlarge.createRectangle(LineSeg(seg.ptMid() - U(10e4) * vecY - .5 * dX * vecX, 
	    				seg.ptMid() + U(10e4) * vecY + .5 * dX * vecX), vecX, vecY);
	    	ppXlarge.joinRing(plXlarge, _kAdd);
	    	ppYlarge.joinRing(plYlarge, _kAdd);
	    }
	    String sHors[] ={ T("|Left|"), T("|Middle|"), T("|Right|")};
	    String sVers[] ={ T("|Top|"), T("|Middle|"), T("|Bottom|")};
	    Point3d ptSheetCenter = ptJig;
	    
	    String sAlignmentTokens[] = sAlignmentMap.tokenize(" ");
	    if(sAlignmentTokens.length()!=2)
	    { 
	    	eraseInstance();
	    	return;
	    }
	    String sH = sAlignmentTokens[0];
	    String sV = sAlignmentTokens[1];
	    if(sH==T("|Left|"))
	    	ptSheetCenter += vecX * .5 * dWidth;
//	    if(sAlignments.find(sAlignmentMap)==0 || sAlignments.find(sAlignmentMap)==1 || sAlignments.find(sAlignmentMap)==2)
//	    	ptSheetCenter += vecX * .5 * dWidth;
	    else if(sH==T("|Right|"))
	    	ptSheetCenter -= vecX * .5 * dWidth;
//	    else if(sAlignments.find(sAlignmentMap)==6 || sAlignments.find(sAlignmentMap)==7 || sAlignments.find(sAlignmentMap)==8)
//	    	ptSheetCenter -= vecX * .5 * dWidth;
	    if(sV==T("|Top|"))
	    	ptSheetCenter -= vecY * .5*dLength;
//	    if(sAlignments.find(sAlignmentMap)==0 || sAlignments.find(sAlignmentMap)==3 || sAlignments.find(sAlignmentMap)==6)
//	    	ptSheetCenter -= vecY * .5*dLength;
	    else if(sV==T("|Bottom|"))
	    	ptSheetCenter += vecY * .5*dLength;
//		else if(sAlignments.find(sAlignmentMap)==2 || sAlignments.find(sAlignmentMap)==5 || sAlignments.find(sAlignmentMap)==8)
//	    	ptSheetCenter += vecY * .5*dLength;
		
		Beam beams[0];
//	    Entity entsBeam[] = mapJig.getEntityArray("beams", "", "");
//	    for (int i=0;i<entsBeam.length();i++) 
//	    { 
//	    	Beam bmI = (Beam)entsBeam[i];
//	    	if(bmI.bIsValid())
//	    		beams.append(bmI);
//	    }//next i
		int iPainterBeam = sPainterBeams.find(sPainterBeam, 0);
		PainterDefinition painterBeam;
		Beam beamsConstrain[0];
		if(sPainterBeam!=sDisabled)
		{
			painterBeam = PainterDefinition(sPainterCollection + "\\" + sPainterBeam);
			String sPainterFilter = painterBeam.filter();
			if(sPainterFilter.find("IsParallelToElementY" ,- 1) > 0 
				|| sPainterFilter.find("IsParallelToElementX" ,- 1) > 0)
			// get beams
			{
				Beam beamsAll[0];
				if(bHasElement)
			 	{
			 		beamsAll.append(el.beam());
			 	}
			 	if(painterBeam.bIsValid())
			 	{
			 		beamsConstrain = painterBeam.filterAcceptedEntities(beamsAll);
			 	}
			 	if(beamsConstrain.length()>0)
			 	{ 
			 		Vector3d vecBeam = beamsConstrain[0].vecX();
			 		if(vecBeam.isParallelTo(vecX) || vecBeam.isParallelTo(vecY))
			 		{ 
			 			for (int iB=beamsConstrain.length()-1; iB>=0 ; iB--) 
				 		{ 
				 			if(!vecBeam.isParallelTo(beamsConstrain[iB].vecX()))
				 				beamsConstrain.removeAt(iB);
				 		}//next iB
			 		}
			 		else
			 			beamsConstrain.setLength(0);
			 	}
			}
		}
	    beams.append(beamsConstrain);
		if(sModuses.find(sM)==0)
	    { 
	    	// element modus
			LineSeg seg = ppSheet.extentInDir(vecX);
			ptJig = seg.ptMid();
			double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
			double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
    		
		    if(sH==T("|Left|"))
		    	ptJig += -vecX * .5 * dX;
		    else if(sH==T("|Right|"))
		    	ptJig -= -vecX * .5 * dX;
		    
		    if(sV==T("|Top|"))
		    	ptJig -= -vecY * .5*dY;
		    else if(sV==T("|Bottom|"))
		    	ptJig += -vecY * .5*dY;
		    ptSheetCenter = ptJig;
	    }
		if(sModuses.find(sM)==2 ||  sModuses.find(sM)==3)
		{ 
//			return;
			// custom modus
			// 5 possibilities
			// 1- left, 
			// 2- right sheet in middle element, 
			// 3- middle sheet in middle element, 
			// 4- left sheet at middle element, 
			// 5- right
			double dAxisRefOffset_=mapJig.getDouble("customOffset");
			String sAxisRef_=mapJig.getString("customAxisRef");
			sAxisRef_="X";
			if(sModuses.find(sM)==3)sAxisRef_="Y";
			String sAxisRefPosition_=mapJig.getString("customPosition");
			Vector3d vecRef=vecX;
			Vector3d vecRefNormal=vecY;
			double dWidthNormal=dWidth;
			double dLengthNormal=dLength;
			if(sAxisRef_=="Y")
			{ 
				vecRef=vecY;
				vecRefNormal=vecX;
				dWidthNormal=dLength;
				dLengthNormal=dWidth;
			}
//			if(beams.length()>0)
//			{ 
//				vecRef=beams[0].vecX();
//				vecRefNormal=vecX;
//				dWidthNormal=dLength;
//				dLengthNormal=dWidth;
//				if (vecRef.isParallelTo(vecX))
//    			{
//    				vecRef=vecX;
//    				vecRefNormal=vecY;
//    				dWidthNormal=dWidth;
//					dLengthNormal=dLength;
//    			}
//    			else
//    			{ 
//    				vecRef=vecY;
//    			}
//			}
//			vecRef.vis(_Pt0);
//			vecRefNormal.vis(_Pt0);
//			ptJig.vis(2);
			Point3d ptJigNew;
			LineSeg seg=ppSheet.extentInDir(vecRef);
			double dX=abs(vecRef.dotProduct(seg.ptStart()-seg.ptEnd()));
			double dY=abs(vecRefNormal.dotProduct(seg.ptStart()-seg.ptEnd()));
//			return;
			// middle of sheet for 5 positions
			Point3d pts[7];
//			Point3d ptMidSheet=seg.ptMid()+vecRefNormal*(dAxisRefOffset_+.5*dLengthNormal);
			Point3d ptMidSheet=seg.ptMid();
			pts[0]=ptMidSheet-vecRef*(.5*dX-.5*dWidthNormal);
pts[0].vis(1);
			pts[1]=ptMidSheet-vecRef*.5*dWidthNormal;
//pts[1].vis(1);
			pts[2]=ptMidSheet;
//pts[2].vis(1);
			pts[3]=ptMidSheet+vecRef*.5*dWidthNormal;
//pts[3].vis(1);
			pts[4]=ptMidSheet+vecRef*(.5*dX-.5*dWidthNormal);
//pts[4].vis(1);
			pts[5]=ptMidSheet-vecRef*(.5*dX);
			pts[6]=ptMidSheet+vecRef*(.5*dX);
			// 
			ptJigNew=pts[0];
			double dMin=abs(vecRef.dotProduct(pts[0]-ptJig));
			int iOptionFound;
			if(nPtGdefined)
			{ 
				for (int iOption=0;iOption<pts.length();iOption++) 
				{ 
					if(abs(vecRef.dotProduct(pts[iOption]-ptJig))<dMin)
					{ 
						dMin=abs(vecRef.dotProduct(pts[iOption]-ptJig));
						ptJigNew=pts[iOption];
						iOptionFound=iOption;
					}
				}//next iOption
			}
			else
			{ 
				int nAxisRefPosition=sAxisRefPositions.find(sAxisRefPosition);
				ptJigNew=pts[nAxisRefPosition];
			}
			ptJigNew.vis(5);
			ptJig+=vecRef*vecRef.dotProduct(ptJigNew-ptJig);
			ptJig.vis(1);
//			ptJig = ptJigNew;
			ptSheetCenter=ptJig;
			sAxisRefPosition.set(sAxisRefPositions[iOptionFound]);
		}
	    Vector3d vecStaggeringDir=vecX;
	    if(mapJig.getString("sVecDir")=="Y")
	    	vecStaggeringDir=vecY;
	    double dStaggeringOffset=mapJig.getDouble("staggeringOffset");
	    double dGapX=mapJig.getDouble("dGapX");
	    double dGapY=mapJig.getDouble("dGapY");
	    PlaneProfile ppSheetMuster(ppSheet.coordSys());
	    { 
	    	PLine plSheetMuster(cs.vecZ());
	    	LineSeg lSeg(ptSheetCenter-.5*vecX*dWidth-.5*vecY*dLength,
	    				 ptSheetCenter+.5*vecX*dWidth+.5*vecY*dLength);
	    	plSheetMuster.createRectangle(lSeg,vecX,vecY);
	    	ppSheetMuster.joinRing(plSheetMuster,_kAdd);
	    }
	    
//	    if(!_bOnDebug)
//	    { 
//	    	if(iElementSheet)
//	    	{ 
//	    		// delete sheets
//		    	for (int iSh=0;iSh<sheets.length();iSh++) 
//		    		sheets[iSh].dbErase();
//	    	}
//	    	else if(!iElementSheet)
//	    	{ 
//	    		// delete sips
//	    		for (int iS=0;iS<sips.length();iS++) 
//		    		sips[iS].dbErase();
//	    	}
//	    }
	    
	    Point3d ptStart = ptJig;
	    if(beams.length()==0)
	    { 
	    	for (int iRowSide=0;iRowSide<2;iRowSide++) 
		    { 
		    	Vector3d vecRowDir = -vecY;
		    	if (iRowSide == 1)vecRowDir = vecY;
		    	int iBreakRow;
		    	int iBreakRowIndex;
		    	for (int iRow=0;iRow<100;iRow++) 
		    	{ 
		    		if (iRow == 0 && iRowSide == 1)continue;
		    		for (int iColSide=0;iColSide<2;iColSide++) 
		    		{ 
		    			Vector3d vecColDir = -vecX;
		    			if (iColSide == 1)vecColDir = vecX;
		    			int iBreakCol;
		    			int iBreakColIndex;
		    			for (int iCol=0;iCol<100;iCol++) 
		    			{ 
		    				if (iCol == 0 && iColSide == 1)continue;
		    				
		    				Point3d pt = ptStart + vecRowDir * (dLength+dGapY) * iRow+vecColDir*(dWidth+dGapX)*iCol;
		    				PlaneProfile pp = ppSheetMuster;
		    				pp.transformBy(pt - ptStart);
		    				if( dStaggeringOffset!=0 && mapJig.getString("sVecDir")=="X")
		    				{ 
		    				 	// staggering in X direction
		    				 	double dRowHalf = iRow;dRowHalf /= 2;
		    				 	int iRowHalf = iRow / 2;
		    				 	if(abs(dRowHalf)>abs(iRowHalf))
		    				 	{ 
		    				 		// 1,3,5
		    				 		pp.transformBy(vecStaggeringDir * dStaggeringOffset);
		    				 	}
		    				}
		    				if( dStaggeringOffset!=0 && mapJig.getString("sVecDir")=="Y")
		 					{ 
		    					// staggering in X direction
		    					double dColHalf = iCol;dColHalf /= 2;
		    				 	int iColHalf = iCol / 2;
		    				 	if(abs(dColHalf)>abs(iColHalf))
		    				 	{ 
		    				 		// 1,3,5
		    				 		pp.transformBy(vecStaggeringDir * dStaggeringOffset);
		    				 	}
		    				}
		    				
		    				PlaneProfile ppIntersect = pp;
		    				if(!ppIntersect.intersectWith(ppYlarge))
	    					{
	    						if (iBreakCol)
	    						{ 
	    							if(iBreakColIndex==iCol) 
	    							{
	    								break;
	    							}
	    							else 
	    							{
	    								continue;
	    							}
	    						}
	    						else
    				 			{
    				 				iBreakCol = true;
    				 				iBreakColIndex = iCol + 1;
    				 				continue;
    				 			}
//	    						break;
	    					}
	    					else
	    						iBreakCol = false;
		    				
		    				ppIntersect = pp;
		    				if(!ppIntersect.intersectWith(ppXlarge))
	    				 	{
	    				 		if (iBreakRow)
	    						{ 
	    							if(iBreakRowIndex==iRow) 
	    							{
	    								// break column loop and break row loop later
	    								break;
	    							}
	    							else 
	    							{
	    								continue;
	    							}
	    						}
	    						else
    				 			{
    				 				iBreakRow = true;
    				 				iBreakRowIndex = iRow + 1;
    				 				continue;
    				 			}
	    				 	}
	    				 	else
	    				 		iBreakRow = false;
		    				
		    				pp.intersectWith(ppSheet);
//		    				pp.vis(3);
		    				if (!_bOnDebug)
							{
								// HSB-11037 sheet planeprofile can have more then 1 ring
								PLine plsNoOp[] = pp.allRings(true, false);
								PLine plsOp[] = pp.allRings(false, true);
								for (int iPl=0;iPl<plsNoOp.length();iPl++) 
								{ 
									PlaneProfile ppI(pp.coordSys());
									ppI.joinRing(plsNoOp[iPl], _kAdd);
									for (int jPl=0;jPl<plsOp.length();jPl++) 
									{ 
									// HSB-15669
										ppI.joinRing(plsOp[iPl], _kSubtract);
									}//next jPl
									PlaneProfile _pp = ppI;
									if(iElementSheet)
									{ 
										// create sheet
										Sheet shNew;
										double dThick = ez.dH();
										if (dSheetThickness != 0)dThick = dSheetThickness;
										shNew.dbCreate(_pp, dThick,1);
										if(bHasElement)
										{
											shNew.assignToElementGroup(el, TRUE, nZone, 'Z');
										}
										else
										{ 
											shNew.assignToGroups(sheets[0]);
										}
										shNew.setMaterial(sSheetMaterial);
										shNew.setName(sSheetName);
			//							shNew.setLabel(sLab);
			//							shNew.setSubLabel(sSub);							
			//							shNew.setGrade(sGrade);			
		//								shNew.setColor(ez.color());
		
										shNew.setLabel(mapJig.getString("label"));
										shNew.setSubLabel(mapJig.getString("subLabel"));
										shNew.setSubLabel2(mapJig.getString("subLabel2"));
										shNew.setInformation(mapJig.getString("information"));
										shNew.setGrade(mapJig.getString("grade"));
										shNew.setColor(mapJig.getInt("color"));
									}
									else if(!iElementSheet)
									{ 
										// create sip
										Sip sipNew;
										PLine plsNoOps[] = _pp.allRings(true, false);
										PLine plsOps[] = _pp.allRings(false, true);
										
										sipNew.dbCreate(plsNoOp[iPl], mapJig.getString("sipStyle"),0);
										for (int iO=0;iO<plsOp.length();iO++) 
										{ 
											sipNew.addOpening(plsOp[iO], false);
										}//next iO
										sipNew.setXAxisDirectionInXYPlane(mapJig.getVector3d("vecXsip"));
										sipNew.setWoodGrainDirection(mapJig.getVector3d("woodGrainDirection"));
										if(bHasElement)
										{
											sipNew.assignToElementGroup(el, TRUE, nZone, 'Z');
										}
										else
										{ 
											sipNew.assignToGroups(sips[0]);
										}
										sipNew.setMaterial(sSheetMaterial);
										sipNew.setName(sSheetName);
										
										sipNew.setLabel(mapJig.getString("label"));
										sipNew.setSubLabel(mapJig.getString("subLabel"));
										sipNew.setSubLabel2(mapJig.getString("subLabel2"));
										sipNew.setInformation(mapJig.getString("information"));
										sipNew.setGrade(mapJig.getString("grade"));
										sipNew.setColor(mapJig.getInt("color"));
									}
								}//next iPl
							}
							else
							{ 
								pp.vis(3);
							}
//							if(iBreakCol && iBreakColIndex==iCol)
//		    					break;
		    			}//next iCol
		    		}//next iColSide
		    		if(iBreakRow && iBreakRowIndex==iRow)
		    			break;
		    	}//next iRow
		    }//next iRowSide
	    }
	    else if(beams.length()>0)
	    { 
	    	//
	    	Vector3d vecBeam = beams[0].vecX();
	    	
	    	Vector3d vecBeamNormal=vecX;
	    	double dGapNormal=dGapX;
	    	double dGapBeam=dGapY;
	    	double dLengthDir=dWidth;
	    	double dWidthDir=dLength;
	    	String sStaggeringDir="vecBeam";
	    	if(!vecBeam.isParallelTo(vecStaggeringDir))
	    			sStaggeringDir="vecBeamNormal";
	    	if (vecBeam.isParallelTo(vecX))
	    	{
	    		vecBeamNormal=vecY;
	    		dGapNormal=dGapY;
	    		dGapBeam=dGapX;
	    		dLengthDir=dLength;
	    		dWidthDir=dWidth;
	    	}
	    	vecBeam.vis(_Pt0,1);
	    	vecBeamNormal.vis(_Pt0,3);
	    	{ 
		    	// get extents of profile
		    	LineSeg seg = ppSheet.extentInDir(vecBeam);
	    		double dX = abs(vecBeam.dotProduct(seg.ptStart()-seg.ptEnd()));
	    		double dY = abs(vecBeamNormal.dotProduct(seg.ptStart()-seg.ptEnd()));
		    	PLine plBeamLarge(cs.vecZ());
		    	PLine plBeamNormalLarge(cs.vecZ());
		    	plBeamLarge.createRectangle(LineSeg(seg.ptMid()-U(10e4)*vecBeam-.5*dY*vecBeamNormal, 
		    				seg.ptMid()+U(10e4)*vecBeam+.5*dY*vecBeamNormal),vecBeam,vecBeamNormal);
		    	plBeamNormalLarge.createRectangle(LineSeg(seg.ptMid()-U(10e4)*vecBeamNormal-.5*dX*vecBeam, 
		    				seg.ptMid()+U(10e4)*vecBeamNormal+.5*dX*vecBeam),vecBeam,vecBeamNormal);
		    	ppBeamLarge.joinRing(plBeamLarge, _kAdd);
		    	ppBeamNormalLarge.joinRing(plBeamNormalLarge, _kAdd);
		    }
		    
//	    	ppBeamLarge.vis(4);
	    	// sort beams in direction of vecBeamNormal
    		for (int i=0;i<beams.length();i++) 
    			for (int j=0;j<beams.length()-1;j++) 
    				if (vecBeamNormal.dotProduct(beams[j].ptCen())>vecBeamNormal.dotProduct(beams[j+1].ptCen()))
    					beams.swap(j, j + 1);
//	    	if(!nSheetOnFirstLastBeamAxis)
//	    	{ 
//	    		beams.removeAt(beams.length()-1);
//	    		beams.removeAt(0);
//	    	}
//	    	beams[0].ptCen().vis(5);
			for (int iB=0;iB<beams.length();iB++) 
				beams[iB].envelopeBody().vis(iB);
			Plane pn(ppSheet.coordSys().ptOrg(), ppSheet.coordSys().vecZ());
			PlaneProfile ppBeams[beams.length()];
	    	for (int iB=0;iB<beams.length();iB++) 
	    	{ 
	    		ppBeams[iB]=beams[iB].envelopeBody().shadowProfile(pn); 
	    	}//next iB
			ptJig.vis(9);
//			ppSheetMuster.vis(10);
	    	Line lns[0];
	    	for (int i=0;i<beams.length();i++) 
	    		lns.append(Line(beams[i].ptCen(), vecBeam));
	    	//
//	    	ppSheet.vis(2);
	    	PlaneProfile ppSheetProgresive(ppSheet.coordSys());
	    	PlaneProfile _ppSheetProgresive(ppSheet.coordSys());
	    	Point3d ptMoving, ptFirst;
	    	PlaneProfile ppMoving,ppFirst, ppFirstCut, ppRow;
	    	PlaneProfile ppRowFirst, ppRowSecond;
	    	for (int iRowSide=0;iRowSide<2;iRowSide++)
		    { 
		    	Vector3d vecRowDir=-vecBeamNormal;
		    	if (iRowSide == 1)vecRowDir=vecBeamNormal;
		    	int iBreakRow;
		    	int iBreakRowIndex;
		    	for (int iRow=0;iRow<10;iRow++) 
		    	{ 
		    		if (iRow == 0 && iRowSide == 1)continue;
//		    		int iBreakRow;
		    		for (int iColSide=0;iColSide<2;iColSide++) 
		    		{ 
		    			Vector3d vecColDir = -vecBeam;
		    			if (iColSide == 1)vecColDir=vecBeam;
		    			int iBreakCol;
		    			int iBreakColIndex;
		    			for (int iCol=0;iCol<10;iCol++) 
		    			{ 
		    				if (iCol==0 && iColSide==1)continue;
		    				Point3d pt=ptStart+vecRowDir*(dLengthDir+dGapNormal)*iRow+vecColDir*(dWidthDir+dGapBeam)*iCol;
		    				PlaneProfile pp(cs);
//		    				pp= ppSheetMuster;
//		    				pp.transformBy(pt - ptStart);
		    				
		    				if(iRow==0 && iCol==0)
		    				{ 
		    					// first sheet
		    					// see if sheet touches any beam from abov
		    					pp = ppSheetMuster;
		    					ppFirst = pp;
		    					ppFirstCut = pp;
		    					ppRowFirst = pp;
		    					Beam bmTouchAbove, bmTouchBottom;
		    					int iTouchAbove, iTouchBelow;
		    					// get extents of profile
								LineSeg seg = pp.extentInDir(vecBeamNormal);
								// top Kante Edge
								Point3d ptTop = seg.ptEnd();
								Point3d ptBottom = seg.ptStart();
	    						if (vecBeamNormal.dotProduct(seg.ptStart()-seg.ptEnd())>0)
								{
									ptTop=seg.ptStart();
									ptBottom=seg.ptEnd();
								}
//	    						ptTop.vis(9);
								// find which beam is closer bmAbove or bmBelow
								double dAbove=U(10e8), dBelow = U(10e8);
								// see above
								for (int iB=beams.length()-1;iB>=0;iB--) 
		    					{ 
		    						PlaneProfile ppIntersect = pp;
		    						if(ppIntersect.intersectWith(ppBeams[iB]))
		    						{ 
		    							if(!nSheetOnFirstLastBeamAxis)
		    								if(iB==0 || iB==beams.length()-1)break;
		    							bmTouchAbove=beams[iB];
		    							iTouchAbove=true;
	    								dAbove=(vecBeamNormal.dotProduct(
	    									(bmTouchAbove.ptCen()-vecBeamNormal*.5*dGapNormal-ptTop)));
		    							break;
		    						}
		    					}//next iB
								// see below
								for (int iB=0;iB<beams.length();iB++) 
		    					{ 
		    						PlaneProfile ppIntersect=pp;
		    						if(ppIntersect.intersectWith(ppBeams[iB]))
		    						{ 
		    							if(!nSheetOnFirstLastBeamAxis)
		    								if(iB==0 || iB==beams.length()-1)break;
		    							bmTouchBottom=beams[iB];
		    							iTouchBelow=true;
		    							dBelow=(vecBeamNormal.dotProduct(
	    									(bmTouchBottom.ptCen()+vecBeamNormal*.5*dGapNormal-ptBottom)));
		    							break;
		    						}
		    					}//next iB
								
								if(abs(dAbove)<abs(dBelow) && abs(dAbove)<U(10e8))
								{ 
									// beam touches above
									// displace the planeprofile
    								Vector3d vecTransform=vecBeamNormal*dAbove;
    								pp.transformBy(vecTransform);
    								ppFirst.transformBy(vecTransform);
    								ppFirstCut.transformBy(vecTransform);
    								ppRowFirst.transformBy(vecTransform);
    								// see below
    								// find the touching beam at bottom side
		    						for (int iB=0;iB<beams.length();iB++) 
			    					{ 
			    						PlaneProfile ppIntersect = pp;
			    						if(ppIntersect.intersectWith(ppBeams[iB]))
			    						{ 
			    							if(!nSheetOnFirstLastBeamAxis)
		    									if(iB==0 || iB==beams.length()-1)break;
			    							bmTouchBottom = beams[iB];
			    							if(bmTouchBottom==bmTouchAbove)
		    									break;
			    							iTouchBelow = true;
		    								// cut the planeprofile
		    								PlaneProfile ppCut(pp.coordSys());
		    								PLine plCut(pp.coordSys().vecZ());
		    								LineSeg lSegCut(bmTouchBottom.ptCen()+vecBeamNormal*.5*dGapNormal-vecBeam*U(10e4),
		    										bmTouchBottom.ptCen()-vecBeamNormal*U(10e4)+vecBeam*U(10e4));
		    								plCut.createRectangle(lSegCut,vecBeam,vecBeamNormal);
		    								ppCut.joinRing(plCut, _kAdd);
		    								pp.subtractProfile(ppCut);
		    								ppFirstCut.subtractProfile(ppCut);
			    							break;
			    						}
			    					}//next iB
								}
								else if (abs(dBelow)<abs(dAbove) && abs(dBelow)<U(10e8))
								{ 
									Vector3d vecTransform = vecBeamNormal * dBelow;
    								pp.transformBy(vecTransform);
    								ppFirst.transformBy(vecTransform);
    								ppFirstCut.transformBy(vecTransform);
    								ppRowFirst.transformBy(vecTransform);
    								// find touching beam above and cut
    								for (int iB=beams.length()-1; iB>=0 ; iB--) 
			    					{ 
			    						PlaneProfile ppIntersect = pp;
			    						if(ppIntersect.intersectWith(ppBeams[iB]))
			    						{ 
			    							if(!nSheetOnFirstLastBeamAxis)
		    									if(iB==0 || iB==beams.length()-1)break;
			    							bmTouchAbove = beams[iB];
			    							if(bmTouchAbove==bmTouchBottom)
			    								break;
			    							iTouchAbove = true;
		    								// cut the planeprofile
		    								PlaneProfile ppCut(pp.coordSys());
		    								PLine plCut(pp.coordSys().vecZ());
		    								LineSeg lSegCut(bmTouchAbove.ptCen()-vecBeamNormal*.5*dGapNormal-vecBeam*U(10e4),
		    										bmTouchAbove.ptCen() + vecBeamNormal * U(10e4) + vecBeam * U(10e4));
		    								plCut.createRectangle(lSegCut, vecBeam, vecBeamNormal);
		    								ppCut.joinRing(plCut, _kAdd);
		    								pp.subtractProfile(ppCut);
		    								ppFirstCut.subtractProfile(ppCut);
			    							break;
			    						}
			    					}//next iB
								}
								else 
								{ 
									// no touch from above or below, move to next beam 
									// dont touch any beam, move to next beam if found
									int iBeamAboveFound;
		    						for (int iB=0;iB<beams.length();iB++) 
		    						{ 
		    							if(vecBeamNormal.dotProduct(beams[iB].ptCen()-ptTop)>0)
		    							{ 
		    								if(!nSheetOnFirstLastBeamAxis)
		    									if(iB==0 || iB==beams.length()-1)break;
		    								// displace the planeprofile
		    								Vector3d vecTransform=vecBeamNormal*vecBeamNormal.dotProduct(
	    										(beams[iB].ptCen()-vecBeamNormal*.5*dGapNormal-ptTop));
	    									pp.transformBy(vecTransform);
	    									ppFirst.transformBy(vecTransform);
	    									ppFirstCut.transformBy(vecTransform);
	    									ppRowFirst.transformBy(vecTransform);
	    									iBeamAboveFound = true;
		    								break;
		    							}
		    						}//next iB
		    						// find the touching beam at bottom side
		    						for (int iB=0;iB<beams.length();iB++) 
			    					{ 
			    						PlaneProfile ppIntersect = pp;
			    						if(ppIntersect.intersectWith(ppBeams[iB]))
			    						{ 
			    							if(!nSheetOnFirstLastBeamAxis)
		    									if(iB==0 || iB==beams.length()-1)break;
			    							bmTouchBottom=beams[iB];
			    							iTouchBelow=true;
		    								
		    								// cut the planeprofile
		    								PlaneProfile ppCut(pp.coordSys());
		    								PLine plCut(pp.coordSys().vecZ());
		    								LineSeg lSegCut(bmTouchBottom.ptCen()+vecBeamNormal*.5*dGapNormal-vecBeam*U(10e4),
		    										bmTouchBottom.ptCen()-vecBeamNormal*U(10e4)+vecBeam*U(10e4));
		    								plCut.createRectangle(lSegCut,vecBeam,vecBeamNormal);
		    								ppCut.joinRing(plCut, _kAdd);
	//	    								ppCut.vis(2);
		    								pp.subtractProfile(ppCut);
		    								ppFirstCut.subtractProfile(ppCut);
			    							break;
			    						}
			    					}//next iB
								}
	    						
//		    					pp.vis(3);
		    					{ 
	    						// get extents of profile
	    							LineSeg seg = pp.extentInDir(vecBeam);
	    							LineSeg segFirst = ppFirst.extentInDir(vecBeam);
	    							ptMoving = seg.ptMid();
	    							ptFirst = segFirst.ptMid();
		    					}
		    					ppMoving = pp;
		    					ppRowFirst = pp;
//		    					ppFirst = pp;
		    					ppSheetProgresive.unionWith(pp);
		    				}
		    				
		    				// first sheet is set
		    				if(sStaggeringDir=="vecBeamNormal")
		    				{ 
		    					// stagerring vector in normal of beams
		    					// set first row
		    					if(iRow==0 && iCol!=0)
			    				{ 
			    					// first row 
									if(iCol==1)
									{ 
										pp = ppFirst;
				    					pp.transformBy((dWidthDir + dGapBeam) * vecColDir*iCol);
				    					double dColHalf = iCol;dColHalf /= 2;
				    				 	int iColHalf = iCol / 2;
				    				 	if(abs(dColHalf)>abs(iColHalf))
				    					{
				    						pp.transformBy(dStaggeringOffset * vecStaggeringDir);
				    					}
	//			    					dpJ2.draw(pp);
				    					// modify with bounding beams
				    					{ 
					    					// see if sheet touches any beam from abov
					    					Plane pn(ppSheet.coordSys().ptOrg(), ppSheet.coordSys().vecZ());
					    					Beam bmTouchAbove, bmTouchBottom;
					    					int iTouchAbove, iTouchBottom;
					    					// get extents of profile
											LineSeg seg = pp.extentInDir(vecBeamNormal);
											// top Kante Edge
											Point3d ptTop = seg.ptEnd();
				    						if (vecBeamNormal.dotProduct(seg.ptStart() - seg.ptEnd()) > 0)
				    								ptTop = seg.ptStart();
					    					for (int iB=beams.length()-1; iB>=0 ; iB--) 
					    					{ 
					    						PlaneProfile ppIntersect = pp;
					    						if(ppIntersect.intersectWith(ppBeams[iB]))
					    						{ 
					    							if(!nSheetOnFirstLastBeamAxis)
		    											if(iB==0 || iB==beams.length()-1)break;
					    							bmTouchAbove = beams[iB];
					    							iTouchAbove = true;
				    								// displace the planeprofile
				    								pp.transformBy(vecBeamNormal*vecBeamNormal.dotProduct(
				    									(bmTouchAbove.ptCen() - vecBeamNormal * .5 * dGapNormal - ptTop)));
					    							break;
					    						}
					    					}//next iB
					    					if(!iTouchAbove)
					    					{ 
					    						int iBeamAboveFound;
					    						// dont touch any beam, move to next beam if found
					    						for (int iB=beams.length()-1; iB>=0 ; iB--)
					    						{ 
					    							if(vecBeamNormal.dotProduct(beams[iB].ptCen()-ptTop)>0)
					    							{ 
					    								if(!nSheetOnFirstLastBeamAxis)
		    												if(iB==0 || iB==beams.length()-1)break;
					    								// displace the planeprofile
				    									pp.transformBy(vecBeamNormal*vecBeamNormal.dotProduct(
				    										(beams[iB].ptCen() - vecBeamNormal * .5 * dGapNormal - ptTop)));
				    									iBeamAboveFound = true;
					    								break;
					    							}
					    						}//next iB
					    					}
					    					// if not touching beam and no beamabove found then pp will stay as it is
					    					// bottom edge
					    					seg = pp.extentInDir(vecBeamNormal);
					    					Point3d ptBottom = seg.ptStart();
				    						if (vecBeamNormal.dotProduct(seg.ptStart() - seg.ptEnd()) > 0)
				    							ptBottom = seg.ptEnd();
				    								
				    						// find the touching beam at bottom side
				    						for (int iB=0;iB<beams.length();iB++) 
					    					{ 
					    						PlaneProfile ppIntersect = pp;
					    						if(ppIntersect.intersectWith(ppBeams[iB]))
					    						{ 
					    							if(!nSheetOnFirstLastBeamAxis)
		    											if(iB==0 || iB==beams.length()-1)break;
					    							bmTouchBottom = beams[iB];
					    							iTouchBottom = true;
				    								
				    								// cut the planeprofile
				    								PlaneProfile ppCut(pp.coordSys());
				    								PLine plCut(pp.coordSys().vecZ());
				    								LineSeg lSegCut(bmTouchBottom.ptCen()+vecBeamNormal*.5*dGapNormal-vecBeam*U(10e4),
				    										bmTouchBottom.ptCen() - vecBeamNormal * U(10e4) + vecBeam * U(10e4));
				    								plCut.createRectangle(lSegCut, vecBeam, vecBeamNormal);
				    								ppCut.joinRing(plCut, _kAdd);
				    								pp.subtractProfile(ppCut);
					    							break;
					    						}
					    					}//next iB
					    					{ 
				    						// get extents of profile
				    							LineSeg seg = pp.extentInDir(vecBeam);
				    							ptMoving = seg.ptMid();
					    					}
					    					ppMoving = pp;
					    					ppSheetProgresive.unionWith(pp);
					    					ppRowSecond = pp;
					    				}
				    				}
				    				else if(iCol!=0 && iCol!=1)
				    				{ 
				    					double dColHalf = iCol;dColHalf /= 2;
				    				 	int iColHalf = iCol / 2;
				    				 	if(abs(dColHalf)>abs(iColHalf))
				    					{
				    						pp = ppRowSecond;
				    						pp.transformBy((dWidthDir + dGapBeam) * vecColDir*(iCol-1));
//				    						pp.transformBy(dStaggeringOffset * vecStaggeringDir);
				    					}
				    					else
				    					{ 
				    						pp = ppRowFirst;
				    						pp.transformBy((dWidthDir + dGapBeam) * vecColDir*(iCol));
				    					}
				    				}
			    				}
			    				else if(iRow!=0)
			    				{ 
			    					// other rows
			    					Point3d pt = ptFirst + vecColDir * (dGapBeam + dWidthDir) * iCol;
			    					if(iCol==0 || iCol==1)
			    					{ 
			    						// cut from bottom
			    						pp=ppFirst;
//			    						pp.vis(1);
			    						pp.transformBy((dWidthDir+dGapBeam)*vecColDir*iCol);
			    						// planeprofile pointing downward
			    						PlaneProfile ppDownwardUpward(pp.coordSys());
			    						{ 
			    							PLine plDownward(pp.coordSys().vecZ());
			    							LineSeg lSegDownward(pt-vecBeam*.5*dWidthDir-vecRowDir*U(10e4),
			    									pt+vecBeam*.5*dWidthDir+vecRowDir*U(10e4));
			    							plDownward.createRectangle(lSegDownward, vecBeam, vecBeamNormal);
			    							ppDownwardUpward.joinRing(plDownward, _kAdd);
			    							
			    							
			    							PlaneProfile ppIntersect=ppSheetProgresive;
			    							int iInter=ppIntersect.intersectWith(ppDownwardUpward);
			    							if (!iInter)break;
			    							
			    							{ 
			    								// get extents of profile
			    								LineSeg seg = ppIntersect.extentInDir(vecBeam);
			    								Point3d ptBottom = seg.ptStart();
			    								if(vecRowDir.dotProduct(seg.ptStart()-seg.ptEnd())<0)
			    									ptBottom = seg.ptEnd();
			    								
												ptBottom += vecRowDir * dGapNormal;
			    								ptBottom += (seg.ptMid() - ptBottom).dotProduct(vecBeam) * vecBeam;
			    								pp = ppFirst;
			    								pp.transformBy(ptBottom - ptFirst);
			    								{ 
			    									// get extents of profile
		    										LineSeg seg = pp.extentInDir(vecRowDir);
		    										double dX = abs(vecRowDir.dotProduct(seg.ptStart()-seg.ptEnd()));
		    										pp.transformBy(vecRowDir * .5 * dX);
			    								}
			    							}
			    							Point3d ptBottom, ptTop;
			    							{ 
			    							// get extents of profile
			    								LineSeg seg = pp.extentInDir(vecBeam);
			    								ptBottom = seg.ptStart();
			    								ptTop = seg.ptEnd();
			    								if(vecBeamNormal.dotProduct(ptBottom-ptTop)>0)
			    								{ 
			    									ptBottom = seg.ptEnd();
			    									ptTop = seg.ptStart();
			    								}
			    							}
			    							// cut from bottom
			    							// find the touching beam at bottom side
			    							if(iRowSide==0)
			    							{ 
			    								Beam bmTouchBottom;
					    						for (int iB=0;iB<beams.length();iB++) 
						    					{ 
						    						
						    						PlaneProfile ppIntersect = pp;
						    						if(ppIntersect.intersectWith(ppBeams[iB]))
						    						{ 
						    							if(!nSheetOnFirstLastBeamAxis)
		    												if(iB==0 || iB==beams.length()-1)break;
						    							bmTouchBottom = beams[iB];
	//					    							iTouchAbove = true;
														if(iB==0)
					    								{ 
					    									// get extents of profile
				    										LineSeg seg = ppBeams[iB].extentInDir(vecBeam);
					    									if(abs(abs(vecRowDir.dotProduct(ptTop-seg.ptStart()))+
					    										   abs(vecRowDir.dotProduct(ptTop-seg.ptEnd()))-
					    										   abs(vecRowDir.dotProduct(seg.ptStart()-seg.ptEnd())))<dEps)
					    										break;
					    								}
					    								
					    								// cut the planeprofile
					    								PlaneProfile ppCut(pp.coordSys());
					    								PLine plCut(pp.coordSys().vecZ());
					    								LineSeg lSegCut(bmTouchBottom.ptCen()+vecBeamNormal*.5*dGapNormal-vecBeam*U(10e4),
					    										bmTouchBottom.ptCen() - vecBeamNormal * U(10e4) + vecBeam * U(10e4));
					    								plCut.createRectangle(lSegCut, vecBeam, vecBeamNormal);
					    								ppCut.joinRing(plCut, _kAdd);
					    								pp.subtractProfile(ppCut);
					    								ppSheetProgresive.unionWith(pp);
						    							break;
						    						}
						    					}//next iB
			    							}
			    							else if(iRowSide==1)
			    							{ 
			    								// cut from top
			    								Beam bmTouchAbove;
			    								for (int iB=beams.length()-1; iB>=0 ; iB--) 
						    					{ 
						    						PlaneProfile ppIntersect = pp;
						    						if(ppIntersect.intersectWith(ppBeams[iB]))
						    						{ 
						    							if(!nSheetOnFirstLastBeamAxis)
		    												if(iB==0 || iB==beams.length()-1)break;
						    							bmTouchAbove = beams[iB];
						    							if(iB=beams.length()-1)
						    							{ 
					    									// get extents of profile
				    										LineSeg seg = ppBeams[iB].extentInDir(vecBeam);
					    									if(abs(abs(vecRowDir.dotProduct(ptBottom-seg.ptStart()))+
					    										   abs(vecRowDir.dotProduct(ptBottom-seg.ptEnd()))-
					    										   abs(vecRowDir.dotProduct(seg.ptStart()-seg.ptEnd())))<dEps)
					    										break;
					    								}
//						    							iTouchAbove = true;
					    								// cut the planeprofile
					    								PlaneProfile ppCut(pp.coordSys());
					    								PLine plCut(pp.coordSys().vecZ());
					    								LineSeg lSegCut(bmTouchAbove.ptCen()-vecBeamNormal*.5*dGapNormal-vecBeam*U(10e4),
					    										bmTouchAbove.ptCen() + vecBeamNormal * U(10e4) + vecBeam * U(10e4));
					    								plCut.createRectangle(lSegCut, vecBeam, vecBeamNormal);
					    								ppCut.joinRing(plCut, _kAdd);
					    								pp.subtractProfile(ppCut);
					    								ppSheetProgresive.unionWith(pp);
						    							break;
						    						}
						    					}//next iB
			    							}
			    						}
			    						if(iCol==0)
			    						{ 
			    							ppRowFirst = pp;
			    						}
			    						else if(iCol==1)
			    						{ 
			    							ppRowSecond = pp;
			    						}
			    					}
			    					else if(iCol!=0 && iCol!=1)
			    					{ 
			    						double dColHalf = iCol;dColHalf /= 2;
				    				 	int iColHalf = iCol / 2;
				    				 	if(abs(dColHalf)>abs(iColHalf))
				    					{
				    						pp = ppRowSecond;
				    						pp.transformBy((dWidthDir + dGapBeam) * vecColDir*(iCol-1));
//				    						pp.transformBy(dStaggeringOffset * vecStaggeringDir);
				    					}
				    					else
				    					{ 
				    						pp = ppRowFirst;
				    						pp.transformBy((dWidthDir + dGapBeam) * vecColDir*(iCol));
//				    						if(iRow==2)
				    						{
				    							pp.vis(1);
				    						}
				    					}
			    					}
			    				}
		    				}
		    				else if(sStaggeringDir=="vecBeam")
		    				{ 
		    					//
		    					if(iRow==0 && iCol!=0)
			    				{ 
			    					// first row 
//			    					Point3d pt=ptFirst+
									pp = ppFirst;
									pp = ppFirstCut;
			    					pp.transformBy((dWidthDir + dGapBeam) * vecColDir*iCol);
			    					ppSheetProgresive.unionWith(pp);
			    				}
			    				else if(iRow!=0)
			    				{ 
			    					// planeprofile for all rows
			    					if(iCol==0)
			    					{ 
			    						pt = ptFirst;
			    						// first profile
			    						PlaneProfile ppDownwardUpward(pp.coordSys());
			    						{ 
			    							PLine plDownward(pp.coordSys().vecZ());
			    							LineSeg lSegDownward(pt-vecBeam*.5*dWidthDir-vecRowDir*U(10e4),
			    									pt + vecBeam * .5 * dWidthDir + vecRowDir * U(10e4));
			    							plDownward.createRectangle(lSegDownward, vecBeam, vecBeamNormal);
			    							ppDownwardUpward.joinRing(plDownward, _kAdd);
			    							
			    							
			    							PlaneProfile ppIntersect = ppSheetProgresive;
			    							int iInter = ppIntersect.intersectWith(ppDownwardUpward);
			    							if ( ! iInter)break;
			    							{ 
			    								// get extents of profile
			    								LineSeg seg = ppIntersect.extentInDir(vecBeam);
			    								Point3d ptBottom = seg.ptStart();
			    								if(vecRowDir.dotProduct(seg.ptStart()-seg.ptEnd())<0)
			    									ptBottom = seg.ptEnd();
			    								
												ptBottom += vecRowDir * dGapNormal;
			    								ptBottom += (seg.ptMid() - ptBottom).dotProduct(vecBeam) * vecBeam;
			    								pp = ppFirst;
//			    								pp = ppFirstCut;
			    								pp.transformBy(ptBottom - ptFirst);
			    								{ 
			    									// get extents of profile
		    										LineSeg seg = pp.extentInDir(vecRowDir);
		    										double dX = abs(vecRowDir.dotProduct(seg.ptStart()-seg.ptEnd()));
		    										pp.transformBy(vecRowDir * .5 * dX);
			    								}
			    								ppRow = pp;
			    							}
			    							Point3d ptBottom, ptTop;
			    							{ 
			    							// get extents of profile
			    								LineSeg seg = pp.extentInDir(vecBeam);
			    								ptBottom = seg.ptStart();
			    								ptTop = seg.ptEnd();
			    								if(vecBeamNormal.dotProduct(ptBottom-ptTop)>0)
			    								{ 
			    									ptBottom = seg.ptEnd();
			    									ptTop = seg.ptStart();
			    								}
			    							}
			    							// cut from bottom
			    							// find the touching beam at bottom side
			    							if(iRowSide==0)
			    							{ 
			    								Beam bmTouchBottom;
					    						for (int iB=0;iB<beams.length();iB++) 
						    					{ 
						    						
						    						PlaneProfile ppIntersect = pp;
						    						if(ppIntersect.intersectWith(ppBeams[iB]))
						    						{ 
						    							if(!nSheetOnFirstLastBeamAxis)
		    												if(iB==0 || iB==beams.length()-1)break;
						    							bmTouchBottom = beams[iB];
	//					    							iTouchAbove = true;
					    								if(iB==0)
					    								{ 
					    									// get extents of profile
				    										LineSeg seg = ppBeams[iB].extentInDir(vecBeam);
					    									if(abs(abs(vecRowDir.dotProduct(ptTop-seg.ptStart()))+
					    										   abs(vecRowDir.dotProduct(ptTop-seg.ptEnd()))-
					    										   abs(vecRowDir.dotProduct(seg.ptStart()-seg.ptEnd())))<dEps)
					    										break;
					    								}
					    								// cut the planeprofile
					    								PlaneProfile ppCut(pp.coordSys());
					    								PLine plCut(pp.coordSys().vecZ());
					    								LineSeg lSegCut(bmTouchBottom.ptCen()+vecBeamNormal*.5*dGapNormal-vecBeam*U(10e4),
					    										bmTouchBottom.ptCen() - vecBeamNormal * U(10e4) + vecBeam * U(10e4));
					    								plCut.createRectangle(lSegCut, vecBeam, vecBeamNormal);
					    								ppCut.joinRing(plCut, _kAdd);
					    								pp.subtractProfile(ppCut);
//					    								ppSheetProgresive.unionWith(pp);
						    							break;
						    						}
						    					}//next iB
						    					ppRow = pp;
			    							}
			    							else if(iRowSide==1)
			    							{ 
			    								// cut from top
			    								Beam bmTouchAbove;
			    								for (int iB=beams.length()-1; iB>=0 ; iB--) 
						    					{ 
						    						PlaneProfile ppIntersect = pp;
						    						if(ppIntersect.intersectWith(ppBeams[iB]))
						    						{ 
						    							if(!nSheetOnFirstLastBeamAxis)
		    												if(iB==0 || iB==beams.length()-1)break;
						    							bmTouchAbove = beams[iB];
						    							if(iB=beams.length()-1)
						    							{ 
					    									// get extents of profile
				    										LineSeg seg = ppBeams[iB].extentInDir(vecBeam);
					    									if(abs(abs(vecRowDir.dotProduct(ptBottom-seg.ptStart()))+
					    										   abs(vecRowDir.dotProduct(ptBottom-seg.ptEnd()))-
					    										   abs(vecRowDir.dotProduct(seg.ptStart()-seg.ptEnd())))<dEps)
					    										break;
					    								}
//						    							iTouchAbove = true;
					    								// cut the planeprofile
					    								PlaneProfile ppCut(pp.coordSys());
					    								PLine plCut(pp.coordSys().vecZ());
					    								LineSeg lSegCut(bmTouchAbove.ptCen()-vecBeamNormal*.5*dGapNormal-vecBeam*U(10e4),
					    										bmTouchAbove.ptCen() + vecBeamNormal * U(10e4) + vecBeam * U(10e4));
					    								plCut.createRectangle(lSegCut, vecBeam, vecBeamNormal);
					    								ppCut.joinRing(plCut, _kAdd);
					    								pp.subtractProfile(ppCut);
						    							break;
						    						}
						    					}//next iB
						    					ppRow = pp;
			    							}
			    						}
			    						double dRowHalf = iRow;dRowHalf /= 2;
										int iRowHalf = iRow / 2;
										if (abs(dRowHalf) > abs(iRowHalf))
										{
											// 1,3,5
											ppRow.transformBy(vecStaggeringDir * dStaggeringOffset);
										}
			    						ppSheetProgresive.unionWith(ppRow);
			    						pp = ppRow;
			    					}
			    					else
									{
//										dpJ.draw(ppRow);
										pp = ppRow;
										pp.transformBy((dWidthDir + dGapBeam) * vecColDir * iCol);
										ppSheetProgresive.unionWith(pp);
									}
			    				}
		    				}
		    				PlaneProfile ppIntersect = pp;
//		    				ppBeamLarge.vis(5);
							if(!ppIntersect.intersectWith(ppBeamNormalLarge))
		    				{ 
		    					if (iBreakCol)
	    						{ 
	    							if(iBreakColIndex==iCol) 
	    							{
	    								break;
	    							}
	    							else 
	    							{
	    								continue;
	    							}
	    						}
	    						else
    				 			{
    				 				iBreakCol = true;
    				 				iBreakColIndex = iCol + 1;
    				 				continue;
    				 			}
		    				}
		    				else
	    						iBreakCol = false;
	    						
							ppIntersect = pp;
		    				if(!ppIntersect.intersectWith(ppBeamLarge))
	    				 	{
	    				 		if (iBreakRow)
	    						{ 
	    							if(iBreakRowIndex==iRow) 
	    							{
	    								// break column loop and break row loop later
	    								break;
	    							}
	    							else 
	    							{
	    								continue;
	    							}
	    						}
	    						else
    				 			{
    				 				iBreakRow = true;
    				 				iBreakRowIndex = iRow + 1;
    				 				continue;
    				 			}
	    				 	}
		    				else
	    				 		iBreakRow = false;
		    				
		    				
//		    				ppSheet.vis(5);
		    				pp.intersectWith(ppSheet);
		    				pp.subtractProfile(_ppSheetProgresive);
		    				if(pp.area()<pow(dEps,2))continue;
		    				_ppSheetProgresive.unionWith(pp);
		    				pp.vis(1);
		    				if (!_bOnDebug)
							{
								PLine plsNoOp[] = pp.allRings(true, false);
								PLine plsOp[] = pp.allRings(false, true);
								for (int iPl = 0; iPl < plsNoOp.length(); iPl++)
								{
									PlaneProfile ppI(pp.coordSys());
									ppI.joinRing(plsNoOp[iPl], _kAdd);
									for (int jPl = 0; jPl < plsOp.length(); jPl++)
									{
										ppI.joinRing(plsNoOp[iPl], _kSubtract);
									}//next jPl
									PlaneProfile _pp = ppI;
									if (iElementSheet)
									{
										Sheet shNew;
										double dThick = ez.dH();
										if (dSheetThickness != 0)dThick = dSheetThickness;
										shNew.dbCreate(_pp, dThick,1);
										if(bHasElement)
										{
											shNew.assignToElementGroup(el, TRUE, nZone, 'Z');
										}
										else
										{ 
											shNew.assignToGroups(sheets[0]);
										}
										shNew.setMaterial(sSheetMaterial);
										shNew.setName(sSheetName);
			//							shNew.setLabel(sLab);
			//							shNew.setSubLabel(sSub);							
			//							shNew.setGrade(sGrade);			
		//								shNew.setColor(ez.color());
										
										shNew.setLabel(mapJig.getString("label"));
										shNew.setSubLabel(mapJig.getString("subLabel"));
										shNew.setSubLabel2(mapJig.getString("subLabel2"));
										shNew.setInformation(mapJig.getString("information"));
										shNew.setGrade(mapJig.getString("grade"));
										shNew.setColor(mapJig.getInt("color"));
									}
									else if(!iElementSheet)
									{ 
										// create sip
										Sip sipNew;
										PLine plsNoOps[] = _pp.allRings(true, false);
										PLine plsOps[] = _pp.allRings(false, true);
										
										sipNew.dbCreate(plsNoOp[iPl], mapJig.getString("sipStyle"),0);
										for (int iO=0;iO<plsOp.length();iO++) 
										{ 
											sipNew.addOpening(plsOp[iO], false);
										}//next iO
										sipNew.setXAxisDirectionInXYPlane(mapJig.getVector3d("vecXsip"));
										sipNew.setWoodGrainDirection(mapJig.getVector3d("woodGrainDirection"));
										if(bHasElement)
										{
											sipNew.assignToElementGroup(el, TRUE, nZone, 'Z');
										}
										else
										{ 
											sipNew.assignToGroups(sips[0]);
										}
										sipNew.setMaterial(sSheetMaterial);
										sipNew.setName(sSheetName);
										
										sipNew.setLabel(mapJig.getString("label"));
										sipNew.setSubLabel(mapJig.getString("subLabel"));
										sipNew.setSubLabel2(mapJig.getString("subLabel2"));
										sipNew.setInformation(mapJig.getString("information"));
										sipNew.setGrade(mapJig.getString("grade"));
										sipNew.setColor(mapJig.getInt("color"));
									}
								}
							}
							else
							{ 
//								pp.transformBy(vecZ * U(300));
								pp.vis(6);
//								pp.transformBy(vecZ * U(-300));
								
							}
//		    				if(iBreakCol && iBreakColIndex==iRow)
//		    					break;
//		    				dpJ.draw(pp);
		    			}//next iCol
		    		}//next iColSide
		    		if(iBreakRow && iBreakRowIndex==iRow)
		    			break;
		    	}//next iRow
		    }//next iRowSide
	    }
	    
	    if(!_bOnDebug)
	    { 
	    	if(iElementSheet)
	    	{ 
	    		// delete sheets
		    	for (int iSh=0;iSh<sheets.length();iSh++) 
		    		sheets[iSh].dbErase();
	    	}
	    	else if(!iElementSheet)
	    	{ 
	    		// delete sips
	    		for (int iS=0;iS<sips.length();iS++) 
		    		sips[iS].dbErase();
	    	}
	    }
    }
	// write properties in mapX 
	{ 
		String sPropStrings[9];
		double dPropDoubles[6];
		int iPropInts[1];
		sPropStrings[0] = sModus;
//		sPropStrings[1] = sAlignmentHorizontal;
//		sPropStrings[2] = sAlignmentVertical;
		sPropStrings[1] = sAlignment;
		sPropStrings[2] = sStaggeringDirection;
//		sPropStrings[3] = sAxisRef;
		sPropStrings[3] = sAxisRefPosition;
		sPropStrings[4] = sSheetName;
		sPropStrings[5] = sSheetMaterial;
		sPropStrings[6] = sPainterBeam;
		sPropStrings[7] = sPainterBeamStream;
		sPropStrings[8] = sSheetOnFirstLastBeamAxis;
		//
		dPropDoubles[0] = dStaggeringOffset;
//		dPropDoubles[1] = dAxisRefOffset;
		dPropDoubles[1] = dSheetLength;
		dPropDoubles[2] = dSheetWidth;
		dPropDoubles[3] = dSheetThickness;
		dPropDoubles[4] = dGapX;
		dPropDoubles[5] = dGapY;
		//
		iPropInts[0] = nZone;
		
		// get existing mapX if exists
		Map mapXel = el.subMapX("hsbSheetDistribution");
		
		Map mapPropStrings;
		for (int i=0;i<sPropStrings.length();i++) 
		{ 
			Map map;
			map.setString("strValue", sPropStrings[i]);
			mapPropStrings.appendMap("PropString", map);
		}//next i
		Map mapPropDoubles;
		for (int i=0;i<dPropDoubles.length();i++) 
		{ 
			Map map;
			map.setDouble("dValue", dPropDoubles[i]);
			mapPropDoubles.appendMap("PropDouble", map);
		}//next i
		Map mapPropInts;
		for (int i=0;i<iPropInts.length();i++) 
		{ 
			Map map;
			map.setInt("iValue", iPropInts[i]);
			mapPropInts.appendMap("PropInt", map);
		}//next i
		Map mapXprops;
		String sZoneNr = nZone;
		String sZoneNrName = "zone"+sZoneNr;
		if(mapXel.hasMap(sZoneNrName))
		{
			mapXprops = mapXel.getMap(sZoneNrName);
		}
		mapXprops.setMap("PropString[]", mapPropStrings );
		mapXprops.setMap("PropDouble[]", mapPropDoubles );
		mapXprops.setMap("PropInt[]", mapPropInts );
		if(_PtG.length()>0)
			mapXprops.setPoint3d("PointJig", _PtG[0]);
		
		
		mapXprops.setString("zoneNr", sZoneNrName);
		mapXel.setMap(sZoneNrName, mapXprops);
		
		el.setSubMapX("hsbSheetDistribution", mapXel);
	}
//	return;
	eraseInstance();
	return;


#End
#BeginThumbnail

























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
        <int nm="BreakPoint" vl="3617" />
        <int nm="BreakPoint" vl="4389" />
        <int nm="BreakPoint" vl="4171" />
        <int nm="BreakPoint" vl="4167" />
        <int nm="BreakPoint" vl="4468" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-24508: Fix bug when zone defined by sheet selection" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="15" />
      <str nm="DATE" vl="9/2/2025 3:50:19 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20644: Extend description of properties" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="14" />
      <str nm="DATE" vl="12/22/2023 10:02:31 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15669: fix when creating sheet with opening" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="13" />
      <str nm="DATE" vl="6/23/2022 5:08:38 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12619: use rayIntersection with the body when working with single SIP/Sheet and not with elements" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="12" />
      <str nm="DATE" vl="12/17/2021 1:53:41 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13511: set the string properties from map or mapX only when part of the defined list" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="11" />
      <str nm="DATE" vl="12/17/2021 11:05:51 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13475: add hidden property to store selected painterdefinition; support jigging in isometry" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="10" />
      <str nm="DATE" vl="11/24/2021 9:51:44 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13754: Support splitting of sheets/sips that are not part of an element" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="11/9/2021 5:57:13 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12619: save for each zone the corresponding mapX; use cataloges in mapio when inserting different TSLs for each zone" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="9/6/2021 5:46:13 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12619: support SIPs" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="7/23/2021 4:32:59 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Deifne explicitely textSize in jig modus" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="7/12/2021 1:29:00 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11037: Split sheet when intersected with T junction" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="4/26/2021 2:08:16 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End