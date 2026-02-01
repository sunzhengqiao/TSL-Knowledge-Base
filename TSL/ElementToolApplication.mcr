#Version 8
#BeginDescription
#Versions
Version 1.1 19.05.2025 HSB-23733 Disregarding beams that are not perpendicular to the element plane and allowing for rotated truss coordinate systems
Version 1.0 19.03.2025 HSB-23733 initial version

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.1 19.05.2025 HSB-23733 Disregarding beams that are not perpendicular to the element plane and allowing for rotated truss coordinate systems , Author Thorsten Huck
// 1.0 19.03.2025 HSB-23733 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select entities elements or individual genbeams and/pr trusses
/// </insert>

// <summary Lang=en>
// This tsl creates simple glue or nail lines
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "ElementToolApplication")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Entities|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Entities|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Create Naillines|") (_TM "|Select Tool|"))) TSLCONTENT
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

//region Dialog Service
	String sDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String sClass = "TslUtilities.TslDialogService";	
	String listSelectorMethod = "SelectFromList";
	String optionsMethod = "SelectOption";
	String simpleTextMethod = "GetText";
	String askYesNoMethod = "AskYesNo";
	String showNoticeMethod = "ShowNotice";
	String showMultilineNotice = "ShowMultilineNotice";
	String showDynamic = "ShowDynamicDialog";	

	String kRowDefinitions = "MPROWDEFINITIONS";
	String kControlTypeKey = "ControlType", kLabelType = "Label", kHeader = "Title", kIntegerBox = "IntegerBox", kTextBox = "TextBox", kDoubleBox = "DoubleBox", kComboBox = "ComboBox", kCheckBox = "CheckBox";
	String kHorizontalAlignment = "HorizontalAlignment", kLeft = "Left", kRight = "Right", kCenter = "Center", kStretch = "Stretch";	

//	String tToolTipColor = T("|Specifies the color of the override.|");
//	String tToolTipTransparency = T("|Specifies the level of transparency of the shape of the tool.|");	
//endregion 

	
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
	
	
	String sPainterCollection = "TSL\\ElementToolApplication\\";
	String tDefaultEntry = T("<|Default|>"), tDisabled = T("<|Disabled|>"), kDisabled = "Disabled";
//end Constants//endregion


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


//region Function ZoneIndexOfPainter
	// returns the zoneindex of the painter filter, 99 if invalid
	int ZoneIndexOfPainter(String name)
	{ 
		int zoneIndex=99;
		String fullName = sPainterCollection+name; 
		PainterDefinition pd(fullName);
		if (pd.bIsValid())
		{ 
			String filter = pd.filter();
			filter.replace(" ", "");
			String tokens[] = filter.tokenize("=");
			for (int i=0;i<tokens.length()-1;i++) 
			{ 
				if (tokens[i].find("ZoneIndex", 0, false) >- 1)
				{ 
					String token = tokens[i + 1];
					int x = token.find(")",0, false);
					if (x>-1)
						token = token.left(x);
					zoneIndex = token.atoi();
					break;
				}				 
				 
			}//next i
		}		
		return zoneIndex;
	}//endregion

//region Function RemovePainterByZone
	// removes painters which refer to the specified zone index
	void RemovePainterByZone(String& painters[], int zone)
	{ 
		for (int i=painters.length()-1; i>=0 ; i--) 
		{ 
			int n = ZoneIndexOfPainter(painters[i]);
			if (n==zone)
				painters.removeAt(i);
			
		}//next i
			
		return;
	}//endregion

//region Function AcceptPainterByZone
	// accpets only painters which refer to the specified zone index
	void AcceptPainterByZone(String& painters[], int zone)
	{ 
		String out[0];
		for (int i=0;i<painters.length();i++) 
		{ 
			int n = ZoneIndexOfPainter(painters[i]);
			if (n==zone)
				out.append(painters[i]);
			
		}//next i
		painters = out;	
		return;
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

//region Function RoundToStep
	// rounds to a given ceiling, a negative value rounds down, a positive rounds up, sgn will be kept
	double RoundToStep(double value, double step)
	{ 
	// step = 0: do not round	
        if (step == 0 || value == 0)
        {
        	return value;
        }
          
        int sgn = abs(value) / value;
        double quotient = abs(value / step);
        int roundedQuotient =quotient;
        
        int bRoundUp =((step > 0 ? 1 :- 1) * (value > 0 ? 1 :- 1)) > 0;//step<0;// 
        
        if (bRoundUp)
	        roundedQuotient=quotient+ 0.999999999;
		value = roundedQuotient * abs(step)*sgn;
        return value;
	
	}//endregion


//region Function EntityCoordSys
	// returns the coordSys of the given entity (genbeam, truss)
	// the coordSys will be aligned with the given face where the longest of the remaining dimension of the body expresses vecX
	CoordSys EntityCoordSys(Entity ent, Body bd, Vector3d vecZ)
	{ 
		CoordSys cs;
		GenBeam gb = (GenBeam)ent;
		TrussEntity te = (TrussEntity)ent;
		if (gb.bIsValid())
		{
			cs= gb.coordSys();
			if (cs.vecX().isParallelTo(vecZ))
			{ 
				double dA = bd.lengthInDirection(cs.vecY());
				double dB = bd.lengthInDirection(cs.vecZ());
				if (dA>=dB)
					cs = CoordSys(cs.ptOrg(), cs.vecY(), cs.vecY().crossProduct(-vecZ), vecZ);
				else
					cs = CoordSys(cs.ptOrg(), cs.vecZ(), cs.vecZ().crossProduct(-vecZ), vecZ);	
			}
		}
		else if (te.bIsValid())
		{
			Quader qdr = te.bodyExtents(); qdr.vis(4);
			cs= te.coordSys();
			
			Vector3d vecX = cs.vecX();
			Vector3d vecY = cs.vecY();
			
			double dx = qdr.dD(vecX);
			double dy = qdr.dD(vecY);
			
			if (vecX.isPerpendicularTo(vecZ) && dx<dy)
			{ 
				vecX = vecY;
			}
			else
			{ 
				reportMessage("\n"+ scriptName()+ T(" |Truss Coordinate System not aligned with element plane|"));				
			}
			vecY = vecX.crossProduct(-vecZ);
			cs = CoordSys(qdr.pointAt(0,0,0),vecX, vecY, vecZ); 
			//reportNotice("\nEntityCoordSys: dA" +dA + " /" + dB);		
		}
		else
			reportNotice("\nEntityCoordSys: warning unsupported type");
		return cs;
	}//endregion



//region Function CollectContactCandidates
	// returns entities which are candidates for contact testing
	Entity[] CollectContactCandidates(PlaneProfile shadows[], Entity ents[], PlaneProfile ppRange)
	{ 
		Entity candidates[0];
		if (shadows.length()!=ents.length())
		{ 
			reportNotice("\nCollectContactCandidates: unexpected error");
			return candidates;
		}
	// find intersecting glueable areas
		for (int i=0;i<shadows.length();i++) 
		{ 
			PlaneProfile shadow= shadows[i]; 
			if (shadow.intersectWith(ppRange))
			{ 
				candidates.append(ents[i]);
				//{Display dpx(i); dpx.draw(shadow, _kDrawFilled,20);}
			}
			 
		}//next j			

		return candidates;
	}//endregion

//region Function CreateBodyFromProfile
	// returns a body similar to sheet.dbCreate(profile, thickness)
	Body CreateBodyFromProfile(PlaneProfile pp, double dThickness, int flag)
	{ 
		Body bd;
		
		CoordSys cs = pp.coordSys();
		Vector3d vecZ = cs.vecZ();
		
	// resolve into single voids
		PLine rings[] = pp.allRings(true, false);
		PLine openings[] = pp.allRings(false, true);		

		for (int r=0;r<rings.length();r++) 
		{ 
			Body bdr(rings[r],vecZ*dThickness ,flag);
			for (int r=0;r<openings.length();r++) 
				bdr.subPart(Body(openings[r], vecZ * dThickness * 3 , 0));
			
			if (bdr.volume()>pow(dEps,3))
			{ 
				bd.addPart(bdr);
				//if (bDebug){Display dpx(cnt+r); dpx.draw(ppr, _kDrawFilled,20);}
			}				
		}//next r
		
		return bd;
	}//endregion

//region Function GetBodies
	// returns the bodies of the entities
	Body[] GetBodies(Entity& ents[], Vector3d vecFace)
	{ 
		Body bodies[ents.length()];
		for (int i=0;i<ents.length();i++) 
		{ 
			GenBeam gb = (GenBeam)ents[i];
			TrussEntity te = (TrussEntity)ents[i];
			
			Body bd;
			if (gb.bIsValid())
			{
				if(!gb.vecX().isPerpendicularTo(vecFace) || gb.vecX().isParallelTo(vecFace))
				{ 
					ents.removeAt(i);
					bodies.removeAt(i);
					continue;
				}
				else
					bd = gb.envelopeBody(false, true);
			}
			else if(te.bIsValid())
			{
				bd = te.realBody();
				if(bd.isNull())
				{ 
					ents.removeAt(i);
					bodies.removeAt(i);
					continue;
				}				
				
				
//				CoordSys cs = EntityCoordSys(te, bd, vecFace);
//				
//			// simplify
//				PlaneProfile pp = bd.shadowProfile(Plane(bd.ptCen(), cs.vecY()));
//				pp.removeAllOpeningRings();
//				Body bdSimple = CreateBodyFromProfile(pp, bd.lengthInDirection(cs.vecY()));
//				if (!bdSimple.isNull())
//					bd = bdSimple;
			}

	
			bodies[i]=bd;
			 
		}//next i
		return bodies;
	}//endregion	
	
//region Function StretchPlaneProfileInDir
	// stretches the profile in the given direction
	void StretchPlaneProfileInDir(PlaneProfile& pp, Vector3d vecDir, double dist)//, int bStretchOpenings)
	{ 
		Vector3d vecZ = pp.coordSys().vecZ();
		Point3d pts[] = pp.getGripEdgeMidPoints();
		
		for (int i=0;i<pts.length();i++) 
		{ 
			Point3d pt1 = pts[i];
			Point3d pt2 = pt1 + vecDir * dEps;
			if (pp.pointInProfile(pt2)==_kPointOutsideProfile)
			{ 
				pp.moveGripEdgeMidPointAt(i, vecDir * dist);
				//vecDir.vis(pt1, 4);
			}
		}
		return pp;
	}//endregion
	
//region Function GetSurfacesInDir
	// returns the surface planeprofiles in the given direction
	PlaneProfile[] GetSurfacesInDir(Body bd, Vector3d vecDir, int bOnlyCodirectional)
	{ 
		Map m;
		m.setBody("Body", bd);
		PlaneProfile pps[] = m.getBodyAsPlaneProfilesList("SimpleBody");
		for (int i=pps.length()-1; i>=0 ; i--) 
		{ 
			Vector3d vecZ = pps[i].coordSys().vecZ();
			if (bOnlyCodirectional && !vecZ.isCodirectionalTo(vecDir))
				pps.removeAt(i);
			else if (!bOnlyCodirectional && vecZ.dotProduct(vecDir)<0)
				pps.removeAt(i);
				
		}//next i
//		for (int i=0;i<pps.length();i++) 
//			{Display dpx(1); dpx.draw(pps[i], _kDrawFilled,20);} 
		
		return pps;
	}//endregion

//region Function IsCoplanarTo
	// returns if two planeprofiels are coplanar
	int IsCoplanarTo(PlaneProfile pp1, PlaneProfile pp2)
	{ 
		int bIsCoplanar;
		
		CoordSys cs1 = pp1.coordSys();
		CoordSys cs2 = pp2.coordSys();
		Vector3d vecZ1 = cs1.vecZ();
		Vector3d vecZ2 = cs2.vecZ();
		Point3d ptOrg1= cs1.ptOrg();
		Point3d ptOrg2= cs2.ptOrg();
		
		if (vecZ1.isParallelTo(vecZ2) && abs(vecZ1.dotProduct(ptOrg1-ptOrg2))<dEps)
			bIsCoplanar = true;
		return bIsCoplanar;
	}//endregion



//endregion 


//region JIG
	
	
//endregion 



//region Painters
	String sPainters[0],sAllPainters[] = PainterDefinition().getAllEntryNames().sorted();

	int nPainterManagementMode;
	
	for (int i=0;i<sAllPainters.length();i++) 
	{ 
		int bAdd = sAllPainters[i].find(sPainterCollection,0,false)==0;// && nPainterManagementMode>0;
		
		if (bAdd)
		{
			PainterDefinition pd(sAllPainters[i]);
			if (!pd.bIsValid())
			{ 
				continue;
			}
			
		// add painter name	
			String name = sAllPainters[i];
			if(nPainterManagementMode==0)
				name = name.right(name.length() - sPainterCollection.length());
			if (sPainters.findNoCase(name,-1)<0)
			{
				sPainters.append(name);
			}		
		}		 
	}//next i


//region Function CollectExistingZones
	// returns an array of zone indices
	int[] CollectExistingZones()
	{ 
		Entity ents[] = Group().collectEntities(true, Element(), _kModelSpace);
		int nZones[] = { };
		
		for (int i=0;i<ents.length();i++) 
		{ 
			Element el= (Element)ents[i]; 
			if (el.bIsValid())
				for (int z=-5;z<6;z++) 
					if (el.zone(z).dH()>dEps && nZones.find(z)<0)
						nZones.append(z);
						
			if (nZones.length()==11)
				break;
		}//next i
		return nZones;
	}//endregion	


	// add default painters if none exists
	int nDefaultZones[] ={ 1, 0 ,- 1};
	int nAllZones[] = CollectExistingZones();
	if (nAllZones.length()>0)
		nDefaultZones = nAllZones;
	for (int i=0;i<nDefaultZones.length();i++) 
	{ 
		int zoneIndex=nDefaultZones[i];
	// check if a painter exists referring to this zone
		int bExist;
		for (int j=0;j<sPainters.length();j++) 
		{ 
			int zoneIndexPainter = ZoneIndexOfPainter(sPainters[j]);
			if (zoneIndex==zoneIndexPainter)
			{ 
				bExist;
				break;
			}
		}//next j
		
		if (!bExist)
		{ 
			String name = T("|Zone| ") + zoneIndex;
			String fullName = sPainterCollection+name;
			PainterDefinition pd(fullName);
			if (!pd.bIsValid())
			{ 
				pd.dbCreate();
				if (zoneIndex==0)
				{
					pd.setType("Entity");
					pd.setFilter("(ZoneIndex = " + zoneIndex + ") and (DxfName = 'HSB_BEAMENT' or DxfName = 'HSBDBSETRUSS')");
				}
				else
				{
					pd.setType("GenBeam");
					pd.setFilter("ZoneIndex = " + zoneIndex);	
				}
				pd.setFormat("@(ElementNumber:D)");
				sPainters.append(name);
			}
		}

		
	}//next i

	//sPainters.insertAt(0, tDefaultEntry);		
//endregion 

//region Properties #PR
category = T("|Tool|");
	String tTTGlue = T("|Glueing|"), tTTNail = T("|Nailing|"), sToolTypes[] ={ tTTGlue, tTTNail};
	String sToolTypeName=T("|Type|");	
	PropString sToolType(nStringIndex++,sToolTypes.sorted() , sToolTypeName);	
	sToolType.setDescription(T("|Defines the ToolType|"));
	sToolType.setCategory(category);
	sToolType.setControlsOtherProperties(true);

	String sToolWidthName=T("|Width|");	
	PropDouble dToolWidth(nDoubleIndex++, U(5), sToolWidthName);	
	dToolWidth.setDescription(T("|Defines the ToolWidth|"));
	dToolWidth.setCategory(category);

	String sSpacingName=T("|Spacing|");	
	PropDouble dSpacing(nDoubleIndex++, U(200), sSpacingName);	
	dSpacing.setDescription(T("|Defines the spacing of a nailing line|"));
	dSpacing.setCategory(category);

	String sToolIndexName=T("|Tool Index|");	
	int nToolIndexs[]={1,2,3};
	PropInt nToolIndex(nIntIndex++, nToolIndexs, sToolIndexName);	
	nToolIndex.setDescription(T("|Defines the index of the tool.|"));
	nToolIndex.setCategory(category);



category = T("|Zone B|");
	String sPaintersB[0];sPaintersB = sPainters;
	RemovePainterByZone(sPaintersB, 0);
	String sFilterBName=T("|Upper Zone|");	
	PropString sFilterB(nStringIndex++, sPaintersB, sFilterBName);	
	sFilterB.setDescription(T("|Defines the upper zone of the tooling|"));
	sFilterB.setCategory(category);
	sFilterB.setControlsOtherProperties(true);

	String sMergeName=T("|Merge Value|");	
	PropDouble dMerge(nDoubleIndex++, U(0), sMergeName);	
	dMerge.setDescription(T("|The shape of the profiles to be glued will be merged if an intersection can be found with the given value|"));
	dMerge.setCategory(category);	
	
	String sOffsetBName=T("|Start/End Offset|");	
	PropDouble dOffsetB(nDoubleIndex++, U(0), sOffsetBName);	
	dOffsetB.setDescription(T("|Defines a tool's range by specifying its starting and ending offsets relative to its associated entity.|"));
	dOffsetB.setCategory(category);

category = T("|Zone A|");
	String sPaintersA[0];sPaintersA = sPainters;
	AcceptPainterByZone(sPaintersA, 0);
	//sPaintersA.insertAt(0, tDefaultEntry);
	String sFilterAName=T("|Lower Zone|");	
	PropString sFilterA(nStringIndex++, sPaintersA, sFilterAName);	
	sFilterA.setDescription(T("|Defines the lower zone of the tooling|"));
	sFilterA.setCategory(category);
	sFilterA.setControlsOtherProperties(true);

	String sOffsetAName=T("|Start/End Offset Lower|");	
	PropDouble dOffsetA(nDoubleIndex++, U(0), sOffsetAName);	
	dOffsetA.setDescription(T("|Defines a tool's range by specifying its starting and ending offsets relative to its associated entity.|"));
	dOffsetA.setCategory(category);

	if (sPaintersB.length()<1 || sPaintersA.length()<1)
	{ 
		reportNotice("\n" + T("|Unexpected error collecting required painter definitions.|"));
		eraseInstance();
		return;
	}

	
	
	

//End Properties//endregion 

//region Function setReadOnlyFlagOfProperties
	// sets the readOnlyFlag
	void setReadOnlyFlagOfProperties()
	{ 	
		dToolWidth.setReadOnly(sToolType == tTTGlue ? false: _kHidden);
		dSpacing.setReadOnly(sToolType == tTTNail ? false: _kHidden);
		if (sPaintersB.length()>0 && sPaintersB.findNoCase(sFilterB,-1)<0)
			sFilterB.set(sPaintersB[0]);
	
	// add entries which are below selected B
		int nZoneB = ZoneIndexOfPainter(sFilterB);	
		if (abs(nZoneB)>1)
		{ 
			int sgn = nZoneB / abs(nZoneB);
			for (int i=0;i<sPainters.length();i++) 
			{ 
				int nZone = ZoneIndexOfPainter(sPainters[i]);
				if (nZone!=0 && (sgn>0 && nZone<nZoneB) ||(sgn<0 && nZone>nZoneB) &&  sPaintersA.findNoCase(sPainters[i],-1)<0)
					sPaintersA.append(sPainters[i]);	 
			}//next i
			sPaintersA = sPaintersA.sorted();
			sFilterA.setEnumValues(sPaintersA);
		}
		if (sPaintersA.length()>0 && sPaintersA.findNoCase(sFilterA,-1)<0)
			sFilterA.set(sPaintersA[0]);				
		sFilterA.setReadOnly(sPaintersA.length()<2 && !bDebug?true:false);		
		
//		Property.setReadOnly(HideCondition?_kHidden:false);
		return;
	}//endregion	

//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
		{
			setPropValuesFromCatalog(tLastInserted);
			setReadOnlyFlagOfProperties();
			while (showDialog("---") == _kUpdate) // _kUpdate means a controlling property changed.	
			{ 
				setReadOnlyFlagOfProperties(); // need to set hidden state
			}						
		}
		setReadOnlyFlagOfProperties();


	// create TSL
		TslInst tslNew;
		GenBeam gbsTsl[] = {};							
		Map mapTsl;	
		mapTsl.setInt("mode", 2);// Distribution mode
		int nProps[]={nToolIndex};			
		double dProps[]={dToolWidth,dSpacing, dMerge, dOffsetB,dOffsetB};				
		String sProps[]={sToolType, sFilterB, sFilterA};
	

	// prompt for elements
		PrEntity ssE(T("|Select elements, <Enter> to select  individual genbeams and/or trusses|"), Element());
	  	if (ssE.go())
			_Element.append(ssE.elementSet());
		
	// Groups of individuals creation		
		if (_Element.length()<1)
		{ 
			ssE = PrEntity(T("|Select genbeams and/or trusses|"), GenBeam());
			ssE.addAllowedClass(TrussEntity());
			Entity entsSet[0];
		  	if (ssE.go())
				entsSet.append(ssE.set());	
				
		// Collect groups beloning to the same element
			Map maps;
			for (int i=0;i<entsSet.length();i++) 
			{ 
				Entity ent = entsSet[i];
				Element el = ent.element();
				if (!el.bIsValid())
				{ 
					continue;
				}
				else
				{ 
					String key = el.number();
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
						Entity ents[] ={ent};
						Map m;
						m.setEntity("element", el);
						m.setEntityArray(ents, true, "ent[]", "", "ent");
						maps.setMap(key, m);				
					}	
				}				 
			}//next i
			
		// Groups of individuals	
			for (int i=0;i<maps.length();i++) 
			{ 
				Map m = maps.getMap(i);
				Entity ents[] = m.getEntityArray("ent[]", "", "ent");
				Entity entEl = m.getEntity("element");
				Element el = (Element)entEl;
				
				mapTsl.setEntityArray(ents, true, "ent[]", "", "ent");
				Entity entsTsl[] = {el};
				Point3d ptsTsl[] = {el.ptOrg()};
				tslNew.dbCreate(scriptName() , el.vecX() ,el.vecY(),gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
					 
			}//next i	
			eraseInstance();
			return;				
		}

	// Element creation					
		for (int i=0;i<_Element.length();i++) 
		{ 
			Element el = _Element[i]; 
			Entity entsTsl[] = {el};
			Point3d ptsTsl[] = {el.ptOrg()};
			tslNew.dbCreate(scriptName() , el.vecX() ,el.vecY(),gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
	reportNotice("\ncreating");			 
		}//next i

		eraseInstance();
		return;
	}	
	setReadOnlyFlagOfProperties();
//endregion

//region Standards
	Element el = _Element.length() > 0? _Element[0] : Element();
	if (!el.bIsValid())
	{ 
		reportNotice("\n" + scriptName() + T(": |invalid element reference.|"));
		eraseInstance();
		return;
	}
	Vector3d vecX = el.vecX();
	Vector3d vecY = el.vecY();
	Vector3d vecZ = el.vecZ();
	Point3d ptOrg = el.ptOrg();

	// get individual set or all entities of element
	Entity ents[] = _Map.getEntityArray("ent[]", "", "ent");
	if (ents.length()<1)
	{
		ents= el.elementGroup().collectEntities(true, Entity(), _kModelSpace);
	}
	
	int nZoneB = ZoneIndexOfPainter(sFilterB);
	ElemZone zoneB = el.zone(nZoneB);

	Vector3d vecFace = zoneB.vecZ();		
	PainterDefinition pdB(sPainterCollection + sFilterB);
	setDependencyOnDictObject(pdB);
	Entity entsB[] = pdB.filterAcceptedEntities(ents);
	
	int nZoneA = ZoneIndexOfPainter(sFilterA);
	ElemZone zoneA = el.zone(nZoneA);
	
	PainterDefinition pdA(sPainterCollection + sFilterA);
	setDependencyOnDictObject(pdA);
	Entity entsA[] = pdA.filterAcceptedEntities(ents);



// Invalid set
	if (entsA.length()<1 || entsB.length()<1)
	{ 
		String msg;
		if (entsA.length() < 1 && entsB.length() < 1)
		{ 
			msg = T("|Could not find any entities in zones| ") + nZoneA + " + "+ nZoneB;
		}
		if (entsA.length() < 1)
		{
			msg = T("|Could not find any entities in zone| ")+ nZoneA;
		}
		else if (entsB.length() < 1)
			msg = T("|Could not find any entities in zone| ")+ nZoneB;

		if (bDebug)
		{
			msg += "\n" + T("|Review element| " + el.number());
			{Display dpxs(1); dpxs.textHeight(U(100));dpxs.draw(scriptName(),_Pt0, _XW,_YW,1,0,_kDevice);}
		}
		else
			msg += "\n" + T("|Tool will be erased from element| " + el.number());
		reportNotice("\n" + msg);
		if (!bDebug)
		{
			eraseInstance();
			return;
		}
	}

	PlaneProfile ppNN = el.noNailProfile(nZoneB);
	ppNN.unionWith(el.noNailProfile(nZoneA));
	//{Display dpx(1); dpx.draw(ppNN, _kDrawFilled,20);}


	Body bodiesB[] = GetBodies(entsB, -vecFace);
	Body bodiesA[] = GetBodies(entsA, -vecFace);
	


// Set beam width if not set and in nailing mode: roof elements if imported / created from IFC
	ElementRoof elr = (ElementRoof)el;
	if (nZoneA == 0 && elr.bIsValid() && elr.dBeamWidth()<=dEps && sToolType==tTTNail)
	{ 
		double max;
		for (int i=0;i<bodiesA.length();i++) 
		{ 
			double d = bodiesA[i].lengthInDirection(vecZ);
			if (d>max)
				max = d;
			 
		}//next i
		if (max > 0 )
			elr.setDBeamWidth(max);
		
	}
	
	
	
	
	setDependencyOnEntity(el);
	assignToElementGroup(el, true, nZoneB, 'E');
	addRecalcTrigger(_kGripPointDrag, "_Pt0");
	int bDrag = _bOnGripPointDrag && _kExecuteKey == "_Pt0";
	
//endregion 	

//region Trigger AddEntities
	String sTriggerAddEntities = T("|Add Entities|");
	addRecalcTrigger(_kContextRoot, sTriggerAddEntities );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddEntities)
	{
		PrEntity ssE(T("|Select genbeams and/or trusses|"), GenBeam());
		ssE.addAllowedClass(TrussEntity());
		Entity entsSet[0];
	  	if (ssE.go())
			entsSet.append(ssE.set());	
			
		for (int i = 0; i < entsSet.length(); i++)
		{
			Entity ent = entsSet[i];
			Element eli = ent.element();
			if (!eli.bIsValid() || el != eli)
			{
				continue;
			}
			if (ents.find(ent)<0)
			{ 
				ents.append(ent);
			}	
		}
		_Map.setEntityArray(ents, true, "ent[]", "", "ent");
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger RemoveEntities
	String sTriggerRemoveEntities = T("|Remove Entities|");
	addRecalcTrigger(_kContextRoot, sTriggerRemoveEntities );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveEntities)
	{
		PrEntity ssE(T("|Select genbeams and/or trusses|"), GenBeam());
		ssE.addAllowedClass(TrussEntity());
		Entity entsSet[0];
	  	if (ssE.go())
			entsSet.append(ssE.set());	
			
		for (int i = 0; i < entsSet.length(); i++)
		{
			Entity ent = entsSet[i];
			int n = ents.find(ent);
			if (n>-1)+
				ents.removeAt(n);
		}
		_Map.setEntityArray(ents, true, "ent[]", "", "ent");
		setExecutionLoops(2);
		return;
	}//endregion

//region Trigger CreateNaillines
	int bCreateNail;
	String sTriggerCreateNaillines = T("|Create Naillines|");
	if (sToolType==tTTNail)
		addRecalcTrigger(_kContextRoot, sTriggerCreateNaillines );
	if (_bOnRecalc && _kExecuteKey==sTriggerCreateNaillines)
	{
		bCreateNail = true;
	}//endregion	

//region Collect bottom face profile groups
	Map maps;
	for (int i=0;i<bodiesB.length();i++) 
	{ 
		Body bd = bodiesB[i];
		GenBeam gb = (GenBeam)entsB[i];
		if (gb.bIsValid())
		{ 
			Vector3d vecXB = gb.vecX();
			Vector3d vecYB = vecXB.crossProduct(vecFace);
			
			Point3d pt = gb.ptCen() - vecFace * .5 * gb.dD(vecFace);
			Plane pn(pt, - vecFace);
			CoordSys cs(pt, vecXB, vecYB, -vecFace);
			PlaneProfile pp (cs);
			pp.unionWith(bd.extractContactFaceInPlane(pn, dEps));
			pp.subtractProfile(ppNN);// subtract no nail zones
			//pp.vis(i);
			
			if (bDrag || bDebug)
			{
				Display dpDrag(-1);
				dpDrag.trueColor(lightblue, 60);
				dpDrag.draw(pp, _kDrawFilled);
			}	
			
			double dZDist = RoundToStep(vecZ.dotProduct(ptOrg - pt), U(1));
			String key = "Z_"+dZDist;
			
			if (maps.hasMap(key))
			{ 
				Map m = maps.getMap(key);
				Entity ents[] = m.getEntityArray("ent[]", "", "ent");
				PlaneProfile pps[] = GetPlaneProfileArray(m);
				
				ents.append(gb);
				pps.append(pp);
				m = SetPlaneProfileArray(pps);
				m.setEntityArray(ents, true, "ent[]", "", "ent");
				maps.setMap(key, m);
			}
			else
			{ 
				Entity ents[] ={ gb};
				PlaneProfile pps[]={ pp}; 
				Map m;
				m = SetPlaneProfileArray(pps);
				m.setEntityArray(ents, true, "ent[]", "", "ent");
				maps.setMap(key, m);				
			}
			

			
		}
		bodiesB[i].vis(i); 
		 
	}//next i		
//endregion 	

//region Collect Shadows
	PlaneProfile ppShadows[0];
	for (int i=0;i<bodiesA.length();i++)
	{
		Body bd = bodiesA[i];
		Entity& ent = entsA[i];
		CoordSys cs = EntityCoordSys(ent, bd, vecZ);
		
		//cs.vis(4);bd.vis(6);		cs.vecX().vis(bd.ptCen(), 1);
		PlaneProfile pp(cs);
		pp.unionWith(bd.shadowProfile(Plane(cs.ptOrg(), vecFace)));
		ppShadows.append(pp);
		//{Display dpx(1); dpx.draw(pp, _kDrawFilled,20);}
		//if (bDebug)
		//bodiesA[i].vis(i);	
	}
//endregion 

//region Collect Contact faces for each detected plane
	// this buffers all contact faces as looping through all combinations could be a performance issue
	Map mapContacts[0]; // the map array is synchronized with entsA, bodiesA etc
	for (int i=0;i<bodiesA.length();i++)
	{ 
		Body& bd = bodiesA[i];
		CoordSys cs = EntityCoordSys(entsA[i], bd, vecZ);
		
	// Collect surfaces (simplify the solid for trusses)
		Body bdSurface = bd;
		if (entsA[i].bIsKindOf(TrussEntity()))
		{ 
			PlaneProfile pp = bd.shadowProfile(Plane(bd.ptCen(), cs.vecY()));
			pp.removeAllOpeningRings();
			Body bdSimple = CreateBodyFromProfile(pp, bd.lengthInDirection(cs.vecY()),0);
			if (!bdSimple.isNull())
			{
				bdSurface = bdSimple;
						
			}
		}
		PlaneProfile ppSurfaces[] = GetSurfacesInDir(bdSurface, vecFace, true); //bOnlyCodirectional	
		
		PlaneProfile ppContacts[0];
		bd.vis(i);
		for (int j=0;j<maps.length();j++) 	
		{ 
			Map m = maps.getMap(j);
			PlaneProfile pps[] = GetPlaneProfileArray(m); 
			if (pps.length()<1){ continue;}
			
			PlaneProfile pp = pps.first();
			CoordSys csj = pp.coordSys();
			Plane pn(csj.ptOrg(), csj.vecZ());
			
			PlaneProfile ppContact(CoordSys(csj.ptOrg(), cs.vecX(), cs.vecY(), cs.vecZ()));
			for (int x=0;x<ppSurfaces.length();x++) 
			{ 
				
				int bIsCoplanar = IsCoplanarTo(ppSurfaces[x], pp);
				if (bIsCoplanar)
				{
					ppContact.unionWith(ppSurfaces[x]); 
				}
			}//next x
			
			//{Display dpx(j+1); dpx.draw(ppContact, _kDrawFilled,10);}
			//PlaneProfile ppc = bd.extractContactFaceInPlane(Plane(ppContact.coordSys().ptOrg(),ppContact.coordSys().vecZ() ), dEps);

			if (ppContact.area()>pow(dEps,2))//ppContact.intersectWith(ppc))//	
			{
				ppContacts.append(ppContact);
			
				if (bDrag || bDebug)
				{
					Display dpDrag(-1);
					dpDrag.trueColor(darkyellow, 60);
					dpDrag.draw(ppContact, _kDrawFilled);
				}
				
			}
			//{Display dpx(i+1); dpx.draw(ppContact, _kDrawFilled,80);}
		
		}
		Map m = SetPlaneProfileArray(ppContacts);
		mapContacts.append(m);
	}
	
//endregion 	

//region Loop by Z-Plane Groups and collect all possible segements
	LineSeg segs[0];
	for (int j=0;j<maps.length();j++) 
	{ 
		Map m = maps.getMap(j);
		
		Entity ents[] = m.getEntityArray("ent[]", "", "ent");
		PlaneProfile pps[] = GetPlaneProfileArray(m); 
		if (pps.length()<1){ continue;}
		
		PlaneProfile ppsX[0];
		if (dMerge>dEps)
		{ 
			CoordSys cs = pps.first().coordSys();
			PlaneProfile ppZone(cs);
			
			PLine openings[0];
			for (int i=0;i<pps.length();i++) 
			{ 
				PlaneProfile pp = pps[i];
				openings.append(pp.allRings(false, true));
				pp.shrink(-dMerge);
				ppZone.unionWith(pp);	 
			}//next i
			ppZone.shrink(dMerge);
			
			PLine rings[]=ppZone.allRings(true, false);
			for (int r=0;r<rings.length();r++) 
			{ 
				PlaneProfile pp(cs);
				pp.joinRing(rings[r],_kAdd);
				for (int o=0;o<openings.length();o++) 
					pp.joinRing(openings[o],_kSubtract);
				ppsX.append(pp);	
			}//next r
		}
		else
			ppsX = pps;


		for (int i=0;i<ppsX.length();i++) 
		{ 
			
			CoordSys cs = ppsX[i].coordSys();
			Plane pn(cs.ptOrg(), cs.vecZ());
		
			if (bDebug){Display dpx(6); dpx.draw(ppsX[i], _kDrawFilled,80);}

			Entity candits[] = CollectContactCandidates(ppShadows, entsA, ppsX[i]);
			for (int j2 = 0; j2 < candits.length(); j2++)
			{
				int n = entsA.find(candits[j2]);
				if (n < 0) { continue; }
				PlaneProfile pp = ppsX[i];
				
				Map mapContact = mapContacts[n];
				PlaneProfile ppContacts[] = GetPlaneProfileArray(mapContact);
				
				PlaneProfile ppContact;
				for (int c = 0; c < ppContacts.length(); c++)
				{ 
					CoordSys csc = ppContacts[c].coordSys();
					if (abs(vecFace.dotProduct(cs.ptOrg()-csc.ptOrg()))<dEps)
					{ 
						ppContact = ppContacts[c];
						break;
					}
				}

			// get tool area from contact
				Vector3d vecXj = ppContact.coordSys().vecX();
				Vector3d vecYj = ppContact.coordSys().vecY();
				double dX = ppContact.dX();
				double dY = dToolWidth >= dEps ?dToolWidth : dEps;
				Point3d ptm = ppContact.ptMid();
				Vector3d vec = .5 * (vecXj * (dX-2*dOffsetA) + vecYj * dY);//
				PlaneProfile ppTool; 
				ppTool.createRectangle(LineSeg(ptm - vec, ptm + vec), vecXj, vecYj);

			// shorten top pp				
				StretchPlaneProfileInDir(pp, -vecXj, -dOffsetB);
				StretchPlaneProfileInDir(pp, vecXj, -dOffsetB);


				if (!ppContact.intersectWith(pp))
				{ 
					continue;					
				}
				
				if (!ppContact.intersectWith(ppTool))
				{ 
					continue;					
				}				

				ptm = ppContact.ptMid();
				LineSeg splits[] = ppContact.splitSegments(LineSeg(ptm - vecXj * U(10e4), ptm + vecXj * U(10e4)), true);
				segs.append(splits);
//				if (dToolWidth>dEps)
//				{
//					Display dpx(nToolIndex); 
//					dpx.draw(ppContact, _kDrawFilled,10);
//				}
					
			}// next j2
		}// next i
	}//next j
		
//endregion 

//region Dispaly, write SubMapX and set Pt0
	Map mapX;
	Point3d ptsSeg[0];
	for (int i=0;i<segs.length();i++) 
		ptsSeg.append(segs[i].ptMid()); 
	if (ptsSeg.length()>0)
		_Pt0.setToAverage(ptsSeg);
	
	Display dp(nToolIndex);
	dp.showInDxa(true);
	dp.elemZone(el, nZoneA, 'E');
	dp.showDuringSnap(false);
	
	if (sToolType==tTTGlue)
	{ 
		for (int i=0;i<segs.length();i++)
		{ 
			Point3d ptStart =segs[i].ptStart();
			Point3d ptEnd =segs[i].ptEnd();
			Vector3d vecXS = ptEnd - ptStart; vecXS.normalize();
			Vector3d vecYS = vecXS.crossProduct(-vecFace);
		
			Map m;
			m.setInt("ToolIndex", nToolIndex);
			m.setInt("Zone", nZoneA);
			m.setPoint3d("ptStart", ptStart);
			m.setPoint3d("ptEnd", ptEnd);
			
			if (dToolWidth>dEps)
			{
				PLine rect; 
				rect.createRectangle(LineSeg(ptStart - vecYS * .5 * dToolWidth, ptEnd + vecYS * .5 * dToolWidth), vecXS, vecYS);
				m.setPLine("Shape", rect);
				dp.draw(PlaneProfile(rect), _kDrawFilled,40);
			}
			mapX.appendMap("Glue", m);
		}
		
		if (dToolWidth<=dEps)
			dp.draw(segs);
		
		_ThisInst.setSubMapX("Glue[]", mapX);
	}
	else if (sToolType==tTTNail)
	{ 
		if(bDebug)dp.draw(segs);
		
		_ThisInst.removeSubMapX("Glue[]");
		for (int i=0;i<segs.length();i++)
		{ 
			
			Point3d ptStart =segs[i].ptStart();
			Point3d ptEnd =segs[i].ptEnd();
			
			ElemNail enl(nZoneB, ptStart, ptEnd, dSpacing, nToolIndex);
							
			
			if (bCreateNail)
			{ 
				NailLine nl; nl.dbCreate(el, enl);
				nl.setColor(nZoneB); //set color of Nailing line				
			}
			else
				el.addTool(enl);

		}
	}
		
	if (bCreateNail || (!bDebug && segs.length()<1))
	{ 
		reportNotice("\nnothing to nail");
		//eraseInstance();
		return;
	}
	
//endregion 
	
//
//
////region Distribution Mode
//	if (_Map.getInt("mode")==2)
//	{ 
//		bDebug = true;
//		
//		{Display dpx(nToolIndex); dpx.draw(segs);}
//
//		
//		if (!bDebug)
//			eraseInstance();
//		return;
//	}
////endregion 





#End
#BeginThumbnail
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
I-$.HV^O]!%O\VT\W+TY@Z4=H+_D7K@"##K[S+:,`````245.1*Y"8((`

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
        <int nm="BreakPoint" vl="1360" />
        <int nm="BreakPoint" vl="894" />
        <int nm="BreakPoint" vl="853" />
        <int nm="BreakPoint" vl="725" />
        <int nm="BreakPoint" vl="1292" />
        <int nm="BreakPoint" vl="930" />
        <int nm="BreakPoint" vl="1324" />
        <int nm="BreakPoint" vl="1088" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23733 Disregarding beams that are not perpendicular to the element plane and allowing for rotated truss coordinate systems" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="5/19/2025 9:09:29 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23733 initial version" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="3/19/2025 3:59:21 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End