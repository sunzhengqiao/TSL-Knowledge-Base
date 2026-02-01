#Version 8
#BeginDescription
#Versions:
Version 2.3 22.11.2024 HSB-22998: Display objects enabled for showing in hsbView , Author Marsel Nakuci
2.2 08.03.2023 HSB-16519: for maprequestdim use direction vectors algned with the edge
2.1 11.01.2023 HSB-16519: Write maprequest for DimRequestPoint of _Pt0
version value="2.0" date="20oct2020" author="thorsten.huck@hsbcad.com"
HSB-9338 internal naming bugfix

HSB-7718 image updated, ribbon command added
HSB-7957 performance increased and depth taken from grip if created with end grip
HSB-7540 spelling fixed 

This tsl creates a free drill in a panel in relation to one of the main faces or to an edge face. It may connect multiple panels.



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 3
#KeyWords CLT;Drill;Rule;Free;Bevel;Angle
#BeginContents

//region Part 1

//region//History
/// <History>
/// #Versions:
// 2.3 22.11.2024 HSB-22998: Display objects enabled for showing in hsbView , Author Marsel Nakuci
// 2.2 08.03.2023 HSB-16519: for maprequestdim use direction vectors algned with the edge Author: Marsel Nakuci
/// 2.1 11.01.2023 HSB-16519: Write maprequest for DimRequestPoint of _Pt0 author: Marsel Nakuci
/// <version value="2.0" date="20oct2020" author="thorsten.huck@hsbcad.com"> HSB-9338 internal naming bugfix </version>
/// <version value="1.9" date="07oct2020" author="thorsten.huck@hsbcad.com"> HSB-7718 image updated, ribbon command added </version>
/// <version value="1.8" date="19jun2020" author="thorsten.huck@hsbcad.com"> HSB-7957 performance increased and depth taken from grip if created with end grip</version>
/// <version value="1.7" date="05jun2020" author="thorsten.huck@hsbcad.com"> HSB-7540 spelling fixed </version>
/// <version value="1.6" date="13may2020" author="thorsten.huck@hsbcad.com"> HSB-7552 setting depth by grip added, HSB-6972 rotation and bevel relation fixed </version>
/// <version value="1.5" date="11may2020" author="thorsten.huck@hsbcad.com"> HSB-7540 setting bevel and/or rotation by grip corrected </version>
/// <version value="1.4" date="11may2020" author="thorsten.huck@hsbcad.com"> HSB-7358 settings extended to support isActive toggle for each tool definition </version>
/// <version value="1.3" date="04may2020" author="thorsten.huck@hsbcad.com"> HSB-7477 settings extended to support mismatch colors by face type and diameter </version>
/// <version value="1.2" date="29apr2020" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select properties or catalog entry, the select panels and insertion points
/// </insert>

/// <summary Lang=en>
/// This tsl creates a free drill in a panel in relation to one of the main faces or to an edge face. It may connect multiple panels.
/// </summary>

/// commands
// commands to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-Drill")) TSLCONTENT
// insert to default the reference face
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-Drill" "_kRef")) TSLCONTENT
// insert to default the top face
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-Drill" "_kTop")) TSLCONTENT
// insert to default the edge face
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-Drill" "_kEdge")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Flip Side|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Set Bevel|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Set Rotation|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Add Panels|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Remove Panels|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Purge Panels|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Add/Remove Format|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Activate Tool Rules|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Disable Tool Rules|") (_TM "|Select Tool|"))) TSLCONTENT
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

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="hsbCLT-Drill";
	Map mapSetting;

// find settings file
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound;
	if (_bOnInsert)
		bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";
	String sFile=findFile(sFullPath); 
	// if no settings file could be found in company try to find it in the installation path
	if (sFile.length()<1)sFile=findFile(_kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\"+sFileName+".xml");


// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() && sFile.length()>0)
	{
		mapSetting.readFromXmlFile(sFile);
		mo.dbCreate(mapSetting);
	}		
//End Settings//endregion

//region Properties
	category = T("|Drill|");
	String sDiameterName=T("|Diameter|");	
	//#0
	PropDouble dDiameter(nDoubleIndex++, U(12), sDiameterName);	
	dDiameter.setDescription(T("|Defines the Diameter|"));
	dDiameter.setCategory(category);
	
	String sDepthName=T("|Depth|");	
	//#1
	PropDouble dDepth(nDoubleIndex++, U(0), sDepthName);	
	dDepth.setDescription(T("|Defines the Depth|")+ T(", |0 = complete through|"));
	dDepth.setCategory(category);
	
	String sFaceName=T("|Face|");
	String sFaces[] = { T("|Reference Face|"), T("|Top Face|"), T("|Edge|")};
	String sInsertFaces[] = { "_kRef", "_kTop", "_kEdge"};
	//#0
	PropString sFace(nStringIndex++, sFaces, sFaceName);	
	sFace.setDescription(T("|Defines the Face|"));
	sFace.setCategory(category);
	
	category = T("|Alignment|");
	String sBevelName=T("|Bevel|");	
	//#2
	PropDouble dBevel(nDoubleIndex++, U(0), sBevelName);	
	dBevel.setDescription(T("|Defines the angle of the drill axis in relation to the selected face.|") +"-90° <"+ sBevelName+" < 90°");
	dBevel.setCategory(category);
	
	String sRotationName=T("|Rotation|");	
	//#3
	PropDouble dRotation(nDoubleIndex++, U(0), sRotationName);	
	dRotation.setDescription(T("|Defines the rotation of the drill axis perpendicular to the selected face.| ")+"-90° <"+ sRotationName+" < 90°");
	dRotation.setCategory(category);
	
	category = T("|Alignment Edge|");
	String sAxisOffsetName=T("|Axis Offset|");	
	//#4
	PropDouble dAxisOffset(nDoubleIndex++, 0, sAxisOffsetName);	
	dAxisOffset.setDescription(T("|Defines the axis offset of the insertion point.|") + T(" |Empty to pick a point in space.|")+ T(" |Only applicable in face mode 'edge'|"));
	dAxisOffset.setCategory(category);

	String sSnapAxisName=T("|Snap to Axis|");	
	PropString sSnapAxis(nStringIndex++, sNoYes, sSnapAxisName);	
	sSnapAxis.setDescription(T("|Defines if the insertion point will snaop to the axis with the given axis offset|"));
	sSnapAxis.setCategory(category);
	
	category = T("|Sinkholes|");
	String sDiameterSinkStartName=T("|Diameter Start|");	
	//#5
	PropDouble dDiameterSinkStart(nDoubleIndex++, U(0), sDiameterSinkStartName);	
	dDiameterSinkStart.setDescription(T("|Defines the diameter of the sinkhole|"));
	dDiameterSinkStart.setCategory(category);
	
	String sDepthSinkStartName=T("|Depth Start|");	
	//#6
	PropDouble dDepthSinkStart(nDoubleIndex++, U(0), sDepthSinkStartName);	
	dDepthSinkStart.setDescription(T("|Defines the depth of the sinkhole|"));
	dDepthSinkStart.setCategory(category);	

	String sDiameterSinkEndName=T("|Diameter End|");	
	//#7
	PropDouble dDiameterSinkEnd(nDoubleIndex++, U(0), sDiameterSinkEndName);	
	dDiameterSinkEnd.setDescription(T("|Defines the diameter of the sinkhole|"));
	dDiameterSinkEnd.setCategory(category);
	
	String sDepthSinkEndName=T("|Depth End|");	
	//#8
	PropDouble dDepthSinkEnd(nDoubleIndex++, U(0), sDepthSinkEndName);	
	dDepthSinkEnd.setDescription(T("|Defines the depth of the sinkhole|"));
	dDepthSinkEnd.setCategory(category);


	category = T("|Display|");
	String sFormatName=T("|Format|");	
	//#2
	PropString sFormat(nStringIndex++, "@(Radius)", sFormatName);	
	sFormat.setDescription(T("|Defines the format of the description|"));
	sFormat.setCategory(category);

	String sTextHeightName=T("|Text Height|");	
	//#9
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the Text Height|") + T(" |0 = byStyle|"));
	dTextHeight.setCategory(category);


//End Properties//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
		
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1 && _kExecuteKey.left(2)!="_k")			
				setPropValuesFromCatalog(_kExecuteKey);
			else
			{ 
			// mimic the _LastInserted for each of the potential faces	
				int n = sInsertFaces.findNoCase(_kExecuteKey ,- 1);
				if (n>-1)
				{ 
					String entry = sInsertFaces[n];
					if (sEntries.findNoCase(entry,-1)>-1)
						setPropValuesFromCatalog(entry);
					else
					{ 
						sFace.set(sFaces[n]);
						setCatalogFromPropValues(entry);	
					}
					showDialog(entry);
					setCatalogFromPropValues(entry);
				}
			// standard dialog	
				else
					showDialog();
			}
									
		}		
		else	
			showDialog();
		
		
	// create TSL
		TslInst tslNew;				Vector3d vecXTsl= _XU;			Vector3d vecYTsl= _YU;
		GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {};
		Map mapTsl;	
		
		
		int nFace = sFaces.find(sFace, 0);
		// 0 = refernce
		// 1 = top face
		// 2 = edge face
		int bSnapAxis = nFace==2 && sNoYes.find(sSnapAxis); 

	// selection set
		Entity ents[0];
		PrEntity ssE(T("|Select panels|"), Sip());	
		if (ssE.go())
			ents= ssE.set();

	// collect sips
		for(int i = 0;i <ents.length();i++)
		{
			Sip sip = (Sip)ents[i];	
			if (sip.bIsValid())
				gbsTsl.append(sip);	
		}
		if (gbsTsl.length()<1)
		{ 
			eraseInstance();
			return;
		}
		Sip sip = (Sip)gbsTsl.first();
		Vector3d vecX = sip.vecX();
		Vector3d vecZ = sip.vecZ();
		Point3d ptCen = sip.ptCen();

	// prompt insertion point			
		while (1) 
		{
			ptsTsl.setLength(0);
			PrPoint ssP("\n" + T("|Select point|")); 
			if (ssP.go()==_kOk && gbsTsl.length()>0) 
			{ 
			// do the actual query
				Point3d ptStart = ssP.value();
				
			// in edge face	mode with snapAxis transform to axis offset
				if (bSnapAxis)
					ptStart += vecZ * (vecZ.dotProduct(ptCen - ptStart) + dAxisOffset);
				
				ptsTsl.append(ptStart);
				
				if (bDebug)
				{ 
					ptsTsl.append(getPoint(T("|Pick end point|")));
				}
				else if (dBevel>0 && dRotation==0 && nFace!=2)
				{ 
				// prompt for point input
					PrPoint ssPRot(TN("|Specifiy direction, <Enter> to align with X-Axis|"), ptStart); 
					if (ssPRot.go()==_kOk) 
					{
						Point3d pt = ssPRot.value();
						pt += vecZ * vecZ.dotProduct(ptStart-pt);
						Vector3d vecDir = pt - ptStart;
						if (!vecDir.bIsZeroLength())
						{ 
							
							vecDir.normalize();
							
							double _dRotation = vecX.angleTo(vecDir);
							
							dRotation.set(_dRotation);
							reportMessage(TN("|Rotation|") + _dRotation + "   "+vecX + "  " + vecDir);
							setCatalogFromPropValues(sLastInserted);							
						}
					}
						
				}

				tslNew.dbCreate(scriptName(), vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, sLastInserted, true, mapTsl, "_FilterSipIntersect", "OnDbCreated");
			}
			else 
			{ // no proper selection
				break; // out of infinite while
			}
		}
		
		eraseInstance();	
		return;
	}	
// end on insert	__________________//endregion

//region Standards
	setEraseAndCopyWithBeams(_kBeam0);
	Sip sips[0];
	sips = _Sip;
	if (sips.length()<1)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|requires at least one panel|"));		
		eraseInstance();
		return;
	}
	
	if (dDiameter<=0)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|diameter must be > 0|"));		
		eraseInstance();
		return;		
	}
	
	Sip sip = sips.first();
	Vector3d vecX = sip.vecX(); 
	Vector3d vecY = sip.vecY();
	Vector3d vecZ = sip.vecZ();
	Point3d ptCen = sip.ptCenSolid();vecX.vis(ptCen, 1);
	Plane pnZ(ptCen, vecZ);
	
	double dX = sip.solidLength();
	double dY = sip.solidWidth();
	double dZ = sip.solidHeight();
	PLine plEnvelope = sip.plEnvelope();

	assignToGroups(sip, 'T');	
	
	int nFace = sFaces.find(sFace, 0);
	// 0 = reference
	// 1 = top face
	// 2 = edge face
	int bIsRefFace = nFace == 0;
	int bIsTopFace = nFace == 1;
	int bIsEdgeFace = nFace == 2;
	
	sSnapAxis.set(bIsEdgeFace?sNoYes[1]:sNoYes[0]);
	sSnapAxis.setReadOnly(true);
	
	Plane pnFace, pnOppFace;
	
	int nc = nFace == 0 ? 3 : (nFace == 1 ? 152 : 72);
	int nt = 80;// default transparency
	int ncMismatch = 1;// default mismatch color
	int ntMismatch = 50;// default mismatch transparency
	String sDimStyle = _DimStyles.first();;
	double textHeight = dTextHeight;
	
	Quader qdr(ptCen, vecX, vecY, vecZ, dX, dY, dZ, 0, 0, 0);

//region make sure rotation in face mode 2 (edge) is between -90>value>90
	if (_kNameLastChangedProp==sRotationName && nFace == 2 && abs(dRotation)>=90)// 
	{ 
		double d = dRotation;
		int nd = d / 90;
		int n360 = d / 360;
		d -= n360 * 360;
		if (nd*(double(90))==d)		
		{
			d = 0;
			reportMessage("\n" + scriptName() + ": " +T("|the rotation angle must be in the range of -90° < x < 90°|"));
			
		}
		else if (abs(d) > 270)		d = (360 - abs(d))*abs(d)/d;
		else if (abs(d) >= 90)		d -= 180 * abs(d) / d;
		
		dRotation.set(d);
		//setExecutionLoops(2);
		//return;	
	}
//End on the event of changing rotation//endregion 
//region make sure rotation in face mode 2 (edge) is between -90>value>90
	if (_kNameLastChangedProp==sBevelName && nFace == 2 && abs(dBevel)>=90)//_kNameLastChangedProp==sRotationName &&  
	{ 
		double d = dBevel;
		int nd = d / 90;
		int n360 = d / 360;
		d -= n360 * 360;
		if (nd*(double(90))==d)		
		{
			d = 0;
			reportMessage("\n" + scriptName() + ": " +T("|the bevel angle must be in the range of -90° < x < 90°|"));
			
		}
		else if (abs(d) > 270)		d = (360 - abs(d))*abs(d)/d;
		else if (abs(d) >= 90)		d -= 180 * abs(d) / d;
		
		dBevel.set(d);
		//setExecutionLoops(2);
		//return;	
	}
//End on the event of changing rotation//endregion 
	
	int bIsThrough = dDepth <= 0;
	int bHasToolSetting, bToolFound;
	int bIsInclinable; // a flag if the tool is inclinable, affects only display if defined
	int bIsInclined = (nFace == 2 && (dBevel != 0 || dRotation != 0)) || (nFace != 2 && dBevel != 0); // a flag if the properties request an inclined tool
	double dThisDepth = bIsThrough? dZ : dDepth;
	double dRadius = dDiameter*.5;
	double dMaxLength; //0 = unlimited
	// sink on main face
	int bHasSinkStart = dDiameterSinkStart > dDiameter && (dDepthSinkStart > 0 || abs(dBevel)>0 || abs(dRotation)>0);
	
	// sink on opposite face
	int bHasSinkEnd = dDiameterSinkEnd > dDiameter  && bIsThrough && (dDepthSinkEnd > 0 || abs(dBevel)>0  || abs(dRotation)>0);
	dDiameterSinkEnd.setReadOnly(!bIsThrough);
	dDepthSinkEnd.setReadOnly(!bIsThrough);
	
	Body bodies[0];
	for (int i=0;i<sips.length();i++) 
	{
		bodies.append(sips[i].envelopeBody(true, false));
		//bodies[bodies.length() - 1].vis(i);
	}	
//End Standards//endregion 
	
//region Read Settings
	int bDisableToolRule = _Map.getInt("DisableToolRule"); // a flag if the isActive flag of a tool shall be overriden
	Map mapTools;
	{
		String k;
		Map m;
		Map mapDisplays= mapSetting.getMap("Display[]");
		
	// get default display	
		m = mapDisplays;
		k = "Color";	if (m.hasInt(k)) nc = m.getInt(k);
		k = "Transparency";	if (m.hasInt(k)) nt = m.getInt(k);
		k = "ColorMismatch";	if (m.hasInt(k)) ncMismatch = m.getInt(k);
		k = "TransparencyMismatch";	if (m.hasInt(k)) ntMismatch = m.getInt(k);
		k = "DimStyle";	if (m.hasString(k)) sDimStyle = m.getString(k);
		k = "TextHeight"; if (m.hasDouble(k) && textHeight<=0)textHeight = m.getDouble(k);
		
	// get face override display
		for (int i=0;i<mapDisplays.length();i++) 
		{ 
			m = mapDisplays.getMap(i);
			k = "Face";	if (m.getInt(k) != nFace) continue;
			k = "Color";	if (m.hasInt(k)) nc = m.getInt(k);
			k = "Transparency";	if (m.hasInt(k)) nt = m.getInt(k);
			k = "DimStyle";	if (m.hasString(k)) sDimStyle = m.getString(k);		
		}//next i	
		
	// Get Tools
		mapTools= mapSetting.getMap("Tool[]");
		bHasToolSetting = mapTools.length() > 0; // flag if any tool setting is specified
		// the user can override the default behaviour on instance base
		if (bHasToolSetting && _Map.hasInt("DisableToolRule")) 
			bHasToolSetting = !bDisableToolRule;
		else
		{ 
			k = "isActive";				if (mapTools.hasInt(k)) bHasToolSetting = mapTools.getInt(k);	
		}
		
		if (bHasToolSetting)
		for (int i=0;i<mapTools.length();i++)
		{ 
			m = mapTools.getMap(i);
			if (bDebug)reportMessage("\ni: " + i + " map: "+m);
			
		//region Test face
			k = "isActive";	if (!bDisableToolRule && m.hasInt(k) && !m.getInt(k)) {continue;}
			k = "Face";	if (m.hasInt(k) && m.getInt(k) != nFace) {continue;}
			k = "Face[]";	
			if (m.hasMap(k)) 
			{
				Map m2 = m.getMap(k);
				int bOk;
				for (int j=0;j<m2.length();j++)
				{ 
					k = "Face";	if (m2.keyAt(j)==k && m2.hasInt(j) && m2.getInt(j) == nFace) 
					{
						bOk = true;
						break;
					}
				}
				if (!bOk)
				{
					if (bDebug)reportMessage("\ni: " + i + " has face definitions, but no mapping with face " + nFace);
					continue;
				}
			}				
		//End //Test face//endregion 
		
		//region Test diameters
		// test diameter	
			k = "Diameter";	if (m.hasDouble(k) && m.getDouble(k) != dDiameter) { continue;}
			if (m.hasMap(k+"[]")) // test for list of diameters
			{
				Map m2 = m.getMap(k+"[]");
				int bOk;
				for (int j=0;j<m2.length();j++)
				{ 
					String s = m2.keyAt(j);
					double d = m2.getDouble(j);
					if (m2.keyAt(j)==k && m2.hasDouble(j) && m2.getDouble(j) == dDiameter) 
					{
						bOk = true;
						break;
					}
				}
				if (!bOk)
				{
					if (bDebug)reportMessage("\ni: " + i + " has diameter definitions, but no mapping with diameter " + dDiameter);
					continue;
				}
			}
		//End Test diameters//endregion 

		// test inclination	
			k = "IsInclinable";	if (m.hasInt(k)) bIsInclinable = m.getInt(k);
			if (bIsInclined && bIsInclined != bIsInclinable)
			{
				if (bDebug)reportMessage("\ni: " + i + " refused inclination " + bIsInclinable);
				continue;
			}

			k = "MaxLength"; if (m.hasDouble(k))dMaxLength = m.getDouble(k);
			
		//region Get optional display override
			k = "Color";	if (m.hasInt(k)) nc = m.getInt(k);
			k = "Transparency";	if (m.hasInt(k)) nt = m.getInt(k);
			k = "ColorMismatch";	if (m.hasInt(k)) ncMismatch = m.getInt(k);
			k = "TransparencyMismatch";	if (m.hasInt(k)) ntMismatch = m.getInt(k);
			
			k = "DimStyle";	if (m.hasString(k)) sDimStyle = m.getString(k);
			
			k = "Display[]";
			if (m.hasMap(k))
			{ 
				mapDisplays = m.getMap(k);
			// get face override display
				for (int j=0;j<mapDisplays.length();j++)
				{ 
					m = mapDisplays.getMap(j);
					k = "Face";	if (m.getInt(k) != nFace) continue;
					k = "Color";	if (m.hasInt(k)) nc = m.getInt(k);
					k = "Transparency";	if (m.hasInt(k)) nt = m.getInt(k);
					k = "DimStyle";	if (m.hasString(k)) sDimStyle = m.getString(k);
				}//next i
			}
		//End optional display override//endregion
		
		// entry has been found and variables are set
			bToolFound = true;
			break;
		}
		
	
	}
	
// settings defined but no tool found	
	if (bHasToolSetting && !bToolFound)
	{ 
		nc = ncMismatch;
		nt = ntMismatch;
	}
	
//End Read Settings//endregion 

 

//region Get common in-plane range
	PlaneProfile ppCommon(sip.coordSys());
	PLine plOpenings[0];
	for (int i=0;i<sips.length();i++) 
	{ 
		Sip& _sip= sips[i];
		if (_sip.vecZ().isParallelTo(vecZ))
		{ 
			PlaneProfile pp = bodies[i].shadowProfile(pnZ);
			PLine rings[] = pp.allRings(true,false);
			for (int r=0;r<rings.length();r++) 
				ppCommon.joinRing(rings[r], _kAdd);
			rings= pp.allRings(false,true);
			for (int r=0;r<rings.length();r++) 
				plOpenings.append(rings[r]);			
		} 
	}//next i
	
// subracting openings would allow drills from within openings
	if (nFace!=2)
		for (int i=0;i<plOpenings.length();i++) 
			ppCommon.joinRing(plOpenings[i],_kSubtract); 

	ppCommon.vis(3);
//End Get common in-plane range//endregion 

//region Get start and end points by face mode
	Vector3d vecXF, vecYF, vecZF,  vecAxisBevel, vecFaceEnd, vecRefRotation;
	int nFlipBevel=nFace==1?-1:1;

	//region Bottom or Top Face
	if (nFace == 0 || nFace == 1)
	{
		_Pt0 += vecZ * (vecZ.dotProduct(ptCen - _Pt0) + (nFace == 0 ?- 1 : 1) * .5 * dZ);;

		vecXF = vecX;
		vecZF = nFace == 0 ? vecZ :- vecZ;
		vecYF= vecXF.crossProduct(-vecZF);
		
		pnFace = Plane(_Pt0, vecZF);
		vecFaceEnd = -vecZF;
		pnOppFace = Plane(_Pt0+vecZF*dZ, vecFaceEnd);

		vecAxisBevel = vecY;
		vecRefRotation = vecXF;
	}			
	//End Bottom or Top Face//endregion 
	
	//region Edge Face
	else if (nFace == 2)
	{ 		
		vecYF = vecZ;
		vecZF = vecX;
		
		Point3d ptNext = _Pt0;
		ptNext+=vecZ*(vecZ.dotProduct(ptCen-ptNext));
		ptNext=ppCommon.closestPointTo(ptNext);
		ptNext.vis(2);

	// get normal on this
		PLine rings[] = ppCommon.allRings();
		PLine pl;
		for (int r=0;r<rings.length();r++) 
		{ 
			if (rings[r].isOn(ptNext))
			{ 
				pl = rings[r];
				break;
			}
		}//next r		
		if (pl.length()>0)
			vecZF = pl.getTangentAtPoint(ptNext).crossProduct(vecZ);
		
		
		if (ppCommon.pointInProfile(ptNext + vecZF * dEps) != _kPointInProfile)vecZF *= -1;
		vecXF= vecYF.crossProduct(vecZF);
		vecZF.vis(ptNext, 2);

		_Pt0 += vecZF * vecZF.dotProduct(ptNext - _Pt0);	
		
		
	// _Pt0 dragged
		if (_kNameLastChangedProp=="_Pt0")
			dAxisOffset.set(vecZ.dotProduct(_Pt0 - ptCen));
	// axis offset changed		
		else if (_kNameLastChangedProp==sAxisOffsetName || _kNameLastChangedProp==sFaceName)
		{
			_Pt0 += vecZ * (vecZ.dotProduct(ptCen - _Pt0) + dAxisOffset);
			setExecutionLoops(2);
			return;
		}

		vecAxisBevel = -vecXF;
		vecRefRotation = vecZF;
	}
				
	//End Edge Face//endregion 
//End Get start and end points by face mode//endregion 
//End Part 1//endregion
	
//region Set Bevel and Rotation
	vecXF.vis(_Pt0, 1);	vecYF.vis(_Pt0, 3);	vecZF.vis(_Pt0, 150);
	
	Vector3d vecXT = vecXF;
	Vector3d vecZT = vecZF;
	CoordSys csBevel;
	//vecAxisBevel.vis(_Pt0, 2);
	csBevel.setToRotation(dBevel,nFlipBevel*vecAxisBevel,_Pt0);//
	vecXT.transformBy(csBevel);
	vecZT.transformBy(csBevel);
	CoordSys csRot;
	csRot.setToRotation(dRotation,vecZ,_Pt0);
	vecXT.transformBy(csRot);
	vecZT.transformBy(csRot);
	Vector3d vecYT = vecXT.crossProduct(-vecZT);	
	vecZT.vis(_Pt0, 4);
	
	if (_kNameLastChangedProp=="_PtG0" || (_bOnDbCreated && _PtG.length()>0 && bDebug))//(_bOnDbCreated && _PtG.length()>0) || bDebug)//1.8
	{ 
		vecZT = _PtG[0] - _Pt0;
		vecZT.normalize();			

		Vector3d vecXFRot = vecZT.crossProduct(vecZ).crossProduct(-vecZ);
		vecXFRot.normalize();									
		
		Vector3d vecYFRot = vecXFRot.crossProduct(-vecZ);		
		//vecYFRot.vis(_Pt0, 40);vecXFRot.vis(_Pt0, 12);vecZT.vis(_Pt0, 2);
		
		double rotation = vecRefRotation.angleTo(vecXFRot, vecZ);//
		double bevel = vecZF.angleTo(vecZT, vecYFRot);
		if (nFace==2)
		{
			bevel = vecXFRot.angleTo(vecZT, vecYFRot);
			if (vecZT.dotProduct(vecZ) < 0)bevel *= -1;
		}
		
	// make sure values within valid range
		// -90° < bevel < 90°
		// -90° < rotation < 90° if in edge mode
		double values[] ={ rotation, bevel};
		for (int i=0;i<values.length();i++) 
		{ 	
			double d = values[i];
			if (d == 0)continue;
			if (i==0 && nFace != 2)continue;
			
			int nd = d / 90;
			int n360 = d / 360;
			int sgn = abs(d) / d;
			d -= n360 * 360;
			if (i==0 && d>180)continue;
			
			if (nd*(double(90))==d)		d = 0;
			else if (abs(d) > 270)		d = (360 - abs(d))*sgn;
			else if (abs(d) >= 90)		d -= 180 * sgn;	

			if (i == 0)					rotation = d;
			else if (i == 1)			bevel = d;
		}//next i
		
		if (!bDebug)
		{
			dBevel.set(bevel);
			dRotation.set(rotation);			
		}
		
		setExecutionLoops(2);
		return;
	}
	//End Set Bevel and Rotation//endregion 
	
//region Flip Side, only available for main faces
// TriggerFlipSide
	if (nFace!=2 && _PtG.length()>0)
	{ 
		int bFlip = _Map.getInt("flip");
		String sTriggerFlipSide = T("../|Flip Side|");
		addRecalcTrigger(_kContext, sTriggerFlipSide );
		if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
		{
			int face = nFace == 0 ? 1 : 0;
			sFace.set(sFaces[face]);
			
			double _dRotation = dRotation;
			_dRotation += 180;
			int n = _dRotation / 360;
			_dRotation -= n * 360;
			dRotation.set(_dRotation);
			
			if (bIsThrough && Line(_Pt0,vecZT).hasIntersection(pnOppFace,_Pt0))
				;//_Pt0 has been set
			else
				_Pt0 = _PtG[0];
			setExecutionLoops(2);
			return;
		}		
	}
	//End Flip Side, only available for main faces//endregion 

//region Get drill extreme points
	Body bdTest(_Pt0 - vecZT * U(10e4), _Pt0 + vecZT * U(10e4), dRadius);	
	Point3d pt1_SinkStart, pt2_SinkStart;
	if (bHasSinkStart)
	{ 
		Body bdX(_Pt0-vecZT*U(10e4),_Pt0+vecZT*U(10e4),dDiameterSinkStart*.5 );
		Body bdX2 = bdX;
		bdX.addTool(Cut(_Pt0,vecZF), 0);
		Point3d pts[] = bdX.extremeVertices(vecZT);
		bdX2.addTool(Cut(_Pt0,-vecZF), 0);
	// auto depth	
		if (dDepthSinkStart==0 && pts.length()>0)
		{ 
			bdX2.addTool(Cut(pts.last(), vecZT), 0);			//bdX2.vis(2);
			pts = Line(_Pt0,vecZT).projectPoints(bdX2.extremeVertices(vecZT));			
		}
		// fixed depth no bevel or rotation
		else if (dBevel==0 && dRotation==0)
		{ 
			pts.setLength(0);
			pts.append(_Pt0);
			pts.append(_Pt0+vecZT*dDepthSinkStart);
			
		}
		// fixed depth with bevel
		else if(pts.length()>0)
		{ 
			bdX2.addTool(Cut(pts.last(), vecZT), 0);
			pts = Line(_Pt0,vecZT).projectPoints(bdX2.extremeVertices(vecZT));	
			pts.last() = pts.first() + vecZT * dDepthSinkStart;
		}
		pts = Line(_Pt0,vecZT).projectPoints(pts);
		
		if (pts.length()>0)
		{
			pt1_SinkStart = pts.first() - vecZT * dEps;	pt1_SinkStart.vis(2);
			pt2_SinkStart = pts.last();					pt2_SinkStart.vis(2);
		}		
	}

	//bdTest.vis(2);
	Point3d ptExtremes[0];
	for (int i=0;i<bodies.length();i++) 
	{ 
		Body bd=bodies[i]; 
		bd.intersectWith(bdTest);
		ptExtremes.append(bd.extremeVertices(vecZT));							bd.vis(i);
	}//next i
	ptExtremes = Line(_Pt0, vecZT).orderPoints(ptExtremes);		
	//End Get drill extreme points//endregion 

//region Get Start and End point
	Point3d ptStart=_Pt0;
	Sip sipEnd=sip; // the panel at the end of the tool if through drill, default is main panel
	if (ptExtremes.length()>0)
	{ 
		ptStart += vecZT * vecZT.dotProduct(ptExtremes.first() - ptStart);
		if (bIsThrough)
		{
			dThisDepth = vecZT.dotProduct(ptExtremes.last() -ptExtremes.first());
			if (dMaxLength>0 && dThisDepth > dMaxLength)
			{
				bIsThrough = false;
				dThisDepth = dMaxLength; // limit drill depth if specified
				
			// set color to mismatch
				nc = ncMismatch;
				nt = ntMismatch;
			}
			else if (sips.length()>1)
			{
				Body bdX(ptExtremes.last(), vecXT, vecYT, vecZT, U(1), U(1), U(1), 0, 0, 0);
				for (int i=0;i<bodies.length();i++) 
				{ 
					if (bodies[i].hasIntersection(bdX))
					{ 
						sipEnd = sips[i];
						break;
					}
				}//next i
				sipEnd.envelopeBody().vis(211);
			}
		}
	}
	else
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|no intersection found with panels|"));
		
		eraseInstance();
		return;
	}
	
// set end point by depth or by grip	
	Point3d ptEnd;
	if (_bOnDbCreated && _PtG.length()>0)
	{ 
		ptEnd = _PtG[0];
		dThisDepth=vecZT.dotProduct(ptEnd - ptStart);
		//reportNotice("\n " + scriptName() + " depth " + dDepth + " vs new " + dThisDepth);
		dDepth.set(dThisDepth);
	}
	else
		ptEnd=ptStart+vecZT*dThisDepth;
	//ptStart.vis(1);	_Pt0.vis(6);	ptEnd.vis(2);		
	//End Get Start and End point//endregion 	
	ptExtremes.last().vis(4);
	
	Point3d pt1_SinkEnd, pt2_SinkEnd;
	if (bHasSinkEnd && ptExtremes.length()>0)
	{ 
		Point3d ptX = ptExtremes.last();
		
	// identify normal to face of last panel
		{ 
			Point3d ptCenE = sipEnd.ptCenSolid();
			Vector3d vecXE = sipEnd.vecX();
			Vector3d vecYE = sipEnd.vecY();
			Vector3d vecZE = sipEnd.vecZ();
			
			double dX = vecXE.dotProduct(ptX - ptCenE);
			double dY = vecYE.dotProduct(ptX - ptCenE);
			double dZ = vecZE.dotProduct(ptX - ptCenE);
			
			double dXS = .5 * sipEnd.solidLength();
			double dYS = .5 * sipEnd.solidWidth();
			double dZS = .5 * sipEnd.solidHeight();
			
			if (abs(abs(dX)-.5*sipEnd.solidLength())<dEps)
				vecFaceEnd = -vecXE*abs(dX)/dX;	
			else if (abs(abs(dY)-.5*sipEnd.solidWidth())<dEps)
				vecFaceEnd = -vecYE*abs(dY)/dY;
			else if (abs(abs(dZ)-.5*sipEnd.solidHeight())<dEps)
				vecFaceEnd =-vecZE*abs(dZ)/dZ;
			Line(_Pt0,vecZT).hasIntersection(Plane(ptX,vecFaceEnd), ptX);	
		}

		vecFaceEnd.vis(ptX, 1);
		Body bdX(_Pt0-vecZT*U(10e4),_Pt0+vecZT*U(10e4),dDiameterSinkEnd*.5 );
		Body bdX2 = bdX;
		bdX.addTool(Cut(ptX, vecFaceEnd), 0);
		Point3d pts[] = bdX.extremeVertices(vecZT);

	// auto depth	
		if (dDepthSinkEnd==0 && pts.length()>0)
		{ 
			bdX2.addTool(Cut(ptX, vecFaceEnd), 0);		//bdX2.vis(20);
			pts = bdX2.extremeVertices(vecZT);
			bdX.addTool(Cut(pts.first(), - vecZT), 0);
			pts = bdX.extremeVertices(-vecZT);			//bdX.vis(3);
		}
		else if (dBevel==0 && dRotation==0)
		{ 
			pts.setLength(2);
			if (Line(_Pt0, vecZT).hasIntersection(Plane(ptX,vecZT), pts.first()))
				pts.last() = pts.first() - vecZT * dDepthSinkEnd;
		}
	// fixed depth	
		else if(pts.length()>0)
		{ 
			pts.first()=pts.last();
			pts.last()=pts.first()-vecZT*dDepthSinkEnd;
			vecFaceEnd.vis(pts.last(), 2);
		}
		pts=Line(_Pt0,vecZT).projectPoints(pts);
		
		if (pts.length()>0)
		{
			//bdX.vis(2);
			pt1_SinkEnd=pts.first()+vecZT*dEps;	pt1_SinkEnd.vis(2);
			pt2_SinkEnd=pts.last(); pt2_SinkEnd.vis(2);
		}
	}
	
//region Grip 0 to modify depth, bevel and rotation

// Trigger BevelByPoint or RotateByPoint//region
	String sTriggerBevelByPoint = T("../|Set Bevel|");
	addRecalcTrigger(_kContext, sTriggerBevelByPoint );
	String sTriggerRotateByPoint = T("../|Set Rotation|");
	addRecalcTrigger(_kContext, sTriggerRotateByPoint );
	String sEventsBy[] ={sTriggerBevelByPoint,sTriggerRotateByPoint};
	int nEventBy = sEventsBy.find(_kExecuteKey);
	if (_bOnRecalc && nEventBy>-1)
	{
	// prompt for point input	
		PrPoint ssP(TN("|Pick point|"),_Pt0); 
		if (ssP.go()==_kOk) 
		{
			Point3d pt=ssP.value();
			vecZT = pt - _Pt0;
			vecZT.normalize();	
			
			Vector3d vecXFRot = vecZT.crossProduct(vecZ).crossProduct(-vecZ);
			vecXFRot.normalize();									
			
			Vector3d vecYFRot = vecXFRot.crossProduct(-vecZ);		
			//vecYFRot.vis(_Pt0, 40);vecXFRot.vis(_Pt0, 12);vecZT.vis(_Pt0, 2);
			
			double rotation = vecRefRotation.angleTo(vecXFRot, vecZ);//
			double bevel = vecZF.angleTo(vecZT, vecYFRot);
			if (nFace==2)
			{
				bevel = vecXFRot.angleTo(vecZT, vecYFRot);
				if (vecZT.dotProduct(vecZ) < 0)bevel *= -1;
			}
			
		// make sure values within valid range
			// -90° < bevel < 90°
			// -90° < rotation < 90° if in edge mode
			double values[] ={ rotation, bevel};
			for (int i=0;i<values.length();i++) 
			{ 	
				
				double d = values[i];
				if (i==0 && nFace != 2)continue;
				
				int nd = d / 90;
				int n360 = d / 360;
				int sgn = abs(d) / d;
				d -= n360 * 360;
				if (i==0 && d>180)continue;
				
				if (nd*(double(90))==d)		d = 0;
				else if (abs(d) > 270)		d = (360 - abs(d))*sgn;
				else if (abs(d) >= 90)		d -= 180 * sgn;	
	
				if (i == 0)					rotation = d;
				else if (i == 1)			bevel = d;
			}//next i
			
			if (nEventBy==0)		dBevel.set(bevel);					
			else if (nEventBy==1) 	dRotation.set(rotation);
			setExecutionLoops(2);
			return;				
		}
	}//endregion

// Trigger SetDepth//region
	String sTriggerSetDepth = T("../|Set Depth|");
	addRecalcTrigger(_kContext, sTriggerSetDepth );
	if (_bOnRecalc && _kExecuteKey==sTriggerSetDepth)
	{
		PrPoint ssP(TN("|Pick point|"),_Pt0); 
		if (ssP.go() == _kOk)
		{
			Point3d pt = ssP.value();
			double d = vecZT.dotProduct(pt - _Pt0);
			dDepth.set(d);
			setExecutionLoops(2);
			return;
		}
	}//endregion	
	
// add grip
	if (_PtG.length()<1)
		_PtG.append(ptEnd);
// set grip	
	else
		_PtG[0] = ptEnd;
//End Grip 0 to modify depth, anglke and rotation//endregion 	
	
//region//Triggers Add or Remove Panels
	String sTriggerAddPanels = T("../|Add Panels|");
	addRecalcTrigger(_kContext, sTriggerAddPanels );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddPanels)
	{
	// prompt for sips
		Entity ents[0];
		PrEntity ssE(T("|Select panel(s)|"), Sip());
		if (ssE.go())
			ents.append(ssE.set());
		
		for (int i=0;i<ents.length();i++)
			if (_Sip.find(ents[i])<0)
				_Sip.append((Sip)ents[i]); 
		
		setExecutionLoops(2);
		return;
	}
	
// Trigger RemovePanels
	if (sips.length()>1)
	{
		String sTriggerRemovePanels = T("../|Remove Panels|");
		addRecalcTrigger(_kContext, sTriggerRemovePanels);
		if (_bOnRecalc && _kExecuteKey==sTriggerRemovePanels)
		{
		// prompt for sips
			Entity ents[0];
			PrEntity ssE(T("|Select panel(s)|"), Sip());
			if (ssE.go())
				ents.append(ssE.set());
			
			for (int i=0;i<ents.length();i++) 
			{
				int n = _Sip.find(ents[i]);
				if (n>-1 && _Sip.length()>1)
					_Sip.removeAt(n);
			}
			
			setExecutionLoops(2);
			return;
		}
	}
	//Triggers Add or Rwemove Panels//endregion	
	
//region Tools
	Drill dr(ptStart, ptEnd, dRadius);
	for (int i=0;i<sips.length();i++) 
	{ 
		sips[i].addTool(dr); 
	}//next i
	
	//dr.addMeToGenBeamsIntersect(sips);	
	Body bdTool(ptStart, ptEnd, dRadius);// = dr.cuttingBody();	
	
	if (bHasSinkStart && vecZT.dotProduct(pt2_SinkStart-pt1_SinkStart)>0)
	{ 
		Drill drSink(pt1_SinkStart, pt2_SinkStart, dDiameterSinkStart*.5);
		drSink.addMeToGenBeamsIntersect(sips);	
		bdTool.addPart(drSink.cuttingBody());			
	}
	if (bHasSinkEnd && (-vecZT).dotProduct(pt2_SinkEnd-pt1_SinkEnd)>0)
	{ 
		Drill drSink(pt1_SinkEnd, pt2_SinkEnd, dDiameterSinkEnd*.5);
		drSink.addMeToGenBeamsIntersect(sips);	
		bdTool.addPart(drSink.cuttingBody());			
	}	
//End Tool//endregion 	

//region//Trigger PurgePanels
	String sTriggerPurgePanels = T("../|Purge Panels|");
	addRecalcTrigger(_kContext, sTriggerPurgePanels );
	if (_bOnRecalc && _kExecuteKey==sTriggerPurgePanels)
	{
		int nNum;
		for (int i=bodies.length()-1; i>=0 ; i--) 
		{ 
			if (!bodies[i].hasIntersection(bdTool))
			{
				nNum++;
				_Sip.removeAt(i);
				bodies.removeAt(i);
			}
			
		}//next i
		reportMessage("\n" + scriptName() + ": " +nNum + (nNum==1?T(" |panel purged from tool.|"):T(" |panels purged from tool.|")));		
		setExecutionLoops(2);
		return;
	}//endregion 

//region Display
	
	Display dp(nc);
	// HSB-22998
	dp.showInDxa(true);
	if (_DimStyles.findNoCase(sDimStyle ,- 1) >- 1)dp.dimStyle(sDimStyle);
	else sDimStyle = _DimStyles.first();
	
	
	if(textHeight>0)
		dp.textHeight(textHeight);
	else 
		textHeight = dp.textHeightForStyle("O", sDimStyle);
	
	PLine plCircle;
	plCircle.createCircle(ptStart, vecZT, dRadius);	
	
// main faces	
	if (nFace!=2)
	{
		PlaneProfile pp = bdTool.getSlice(Plane(_Pt0, vecZF));
		dp.draw(pp, _kDrawFilled, 90);
		dp.draw(pp);
		Point3d pt=_Pt0;
		pnOppFace = Plane(ptExtremes.last(), vecFaceEnd);
		Line(_Pt0, vecZT).hasIntersection(pnOppFace, pt);
	// is through	
		if(bIsThrough)
		{ 
			pp = bdTool.getSlice(pnOppFace);
			dp.draw(pp);							
		}
	// not through	
		else
		{
			pt = ptEnd;
			plCircle.transformBy(vecZT * dThisDepth);
			dp.draw(plCircle);				
		}
		dp.draw(PLine(_Pt0, pt));
	}
// edge face	
	else
	{
		dp.draw(plCircle);
		dp.draw(PLine(ptStart, ptEnd));		
		plCircle.transformBy(vecZT * dThisDepth);
		dp.draw(plCircle);		
	}
	//bdTool.vis(6);
//End Display//endregion
	
//region // HSB-16519: Publish mapRequest for dimension point of _Pt0
	Map mapRequests;
	Point3d ptsNodes[0]; ptsNodes.append(_Pt0);
	_Pt0.vis(6);
// HSB-16519: get 2 vectors aligned with the edge and normal with edge
	Vector3d vecAligned, vecNormalDim;
	double dDistMin=U(10e9);
	{ 
		PLine plEnvelope=sip.plEnvelope();
		Point3d pts[]=plEnvelope.vertexPoints(false);
		for (int ipt=0;ipt<pts.length()-1;ipt++) 
		{ 
			Vector3d vecI=pts[ipt+1]-pts[ipt];vecI.normalize();
			Point3d ptMidI=.5*(pts[ipt+1]+pts[ipt]);
			double dDistI=(_Pt0-Line(ptMidI,vecI).closestPointTo(_Pt0)).length();
			
			if(dDistI<dDistMin)
			{ 
				dDistMin = dDistI;
				vecAligned=vecI;
				vecNormalDim=vecZ.crossProduct(vecAligned);vecNormalDim.normalize();
			}
		}//next ipt
	}
//	ptsNodes.append(_Pt0+vecX*U(200));
	Map mapRequestDim;
	mapRequestDim.setString("DimRequestPoint","DimRequestPoint");
//	mapRequestDim.setString("DimRequestChain","DimRequestChain");
//	mapRequestDim.setDouble("MinimumOffsetFromDimLine",500);
	mapRequestDim.setString("stereotype", "hsbCLT-Drill");
	mapRequestDim.setInt("setIsChainDimReferencePoint",true);
	// Z
	mapRequestDim.setVector3d("AllowedView",vecZ);
	mapRequestDim.setInt("AlsoReverseDirection",false);
	mapRequestDim.setPoint3d("ptRef", _Pt0);
	mapRequestDim.setPoint3dArray("Node[]",ptsNodes);
	mapRequestDim.setVector3d("vecDimLineDir", vecAligned);
	mapRequestDim.setVector3d("vecPerpDimLineDir", vecNormalDim);
	mapRequests.appendMap("DimRequest",mapRequestDim);
	// -Z
	mapRequestDim.setVector3d("AllowedView",-vecZ);
//	mapRequestDim.setVector3d("vecDimLineDir", -vecAligned);
	mapRequestDim.setVector3d("vecPerpDimLineDir", -vecNormalDim);
	mapRequests.appendMap("DimRequest",mapRequestDim);
	
	if(mapRequests.length()>0)
		_Map.setMap("DimRequest[]", mapRequests);
	else
		_Map.removeAt("DimRequest[]",true);
//End // HSB-16519: Publish mapRequest for dimension point of _Pt0//endregion 

//region Parse text and display if found
//region Collect list of available object variables and append properties which are unsupported by formatObject (yet)
	String sObjectVariables[] = _ThisInst.formatObjectVariables();

//Add custom variables for format resolving
	// adding custom variables or variables which are currently not supported by core
	String sCustomVariables[] ={ "Radius"};
	for (int i=0;i<sCustomVariables.length();i++)
	{ 
		String k = sCustomVariables[i];
		if (sObjectVariables.find(k) < 0)
			sObjectVariables.append(k);
	}	
	
// get translated list of variables
	String sTranslatedVariables[0];
	for (int i=0;i<sObjectVariables.length();i++) 
		sTranslatedVariables.append(T("|"+sObjectVariables[i]+"|")); 
	
// order both arrays alphabetically
	for (int i=0;i<sTranslatedVariables.length();i++) 
		for (int j=0;j<sTranslatedVariables.length()-1;j++) 
			if (sTranslatedVariables[j]>sTranslatedVariables[j+1])
			{
				sObjectVariables.swap(j, j + 1);
				sTranslatedVariables.swap(j, j + 1);
			}			
//End add custom variables
//End get list of available object variables//endregion 


// Trigger ToolRuleOverride
	if (mapTools.length()>0)
	{ 
		if ( ! _Map.hasInt("DisableToolRule") && !bHasToolSetting) bDisableToolRule = true;
		String sTrigger =bDisableToolRule?T("../|Activate Tool Rules|"):T("../|Disable Tool Rules|");
		addRecalcTrigger(_kContext, sTrigger);
		if (_bOnRecalc && _kExecuteKey==sTrigger)
		{
			bDisableToolRule = bDisableToolRule ? false : true;
			_Map.setInt("DisableToolRule", bDisableToolRule);		
			setExecutionLoops(2);
			return;
		}		
	}
	else if (_Map.hasInt("DisableToolRule"))
		_Map.removeAt("DisableToolRule", true);
	

//region Trigger AddRemoveFormat
	Entity ents[] ={ _ThisInst};
	String sTriggerAddRemoveFormat = T("|Add/Remove Format|");
	addRecalcTrigger(_kContext, "../"+sTriggerAddRemoveFormat );
	if (_bOnRecalc && (_kExecuteKey=="../"+sTriggerAddRemoveFormat || _kExecuteKey==sTriggerAddRemoveFormat))
	{
		String sPrompt;
//		if (bHasSDV && entsDefineSet.length()<1)
//			sPrompt += "\n" + T("|NOTE: During a block setup only limited properties are accesable, but you can enter \nany valid format expression or use custom catalog entries.|");
		sPrompt+="\n"+ T("|Select a property by index to add or to remove|") + T(" ,|-1 = Exit|");
		reportNotice(sPrompt);
		
		for (int s=0;s<sObjectVariables.length();s++) 
		{ 
			String key = sObjectVariables[s]; 
			String keyT = sTranslatedVariables[s];
			String sValue;
			for (int j=0;j<ents.length();j++) 
			{ 
				String _value = ents[j].formatObject("@(" + key + ")");
				if (_value.length()>0)
				{ 
					sValue = _value;
					break;
				}
			}//next j

			//String sSelection= sFormat.find(key,0, false)<0?"" : T(", |is selected|");
			String sAddRemove = sFormat.find(key,0, false)<0?"   " : "√";
			int x = s + 1;
			String sIndex = ((x<10)?"    " + x:"  " + x)+ "  "+sAddRemove+"   ";//
			
			reportNotice("\n"+sIndex+keyT + "........: "+ sValue);
			
		}//next i
		int nRetVal = getInt(sPrompt)-1;
				
	// select property	
		while (nRetVal>-1)
		{ 
			if (nRetVal>-1 && nRetVal<=sObjectVariables.length())
			{ 
				String newAttrribute = sFormat;
	
			// get variable	and append if not already in list	
				String variable ="@(" + sObjectVariables[nRetVal] + ")";
				int x = sFormat.find(variable, 0);
				if (x>-1)
				{
					int y = sFormat.find(")", x);
					String left = sFormat.left(x);
					String right= sFormat.right(sFormat.length()-y-1);
					newAttrribute = left + right;
					reportMessage("\n" + sObjectVariables[nRetVal] + " new: " + newAttrribute);				
				}
				else
				{ 
					newAttrribute+="@(" +sObjectVariables[nRetVal]+")";
								
				}
				sFormat.set(newAttrribute);
				reportMessage("\n" + sFormatName + " " + T("|set to|")+" " +sFormat);	
			}
			nRetVal = getInt(sPrompt)-1;
		}
	
		setExecutionLoops(2);
		return;
	}	
	
	
//endregion 

//region Resolve format by entity
	String text;// = "R" + dDiameter * .5;
	if (sFormat.length()>0)
	{ 
		String sLines[0];// store the resolved variables by line (if \P was found)	
		String sValues[0];	
		String sValue=  _ThisInst.formatObject(sFormat);
	
	// parse for any \P (new line)
		int left= sValue.find("\\P",0);
		while(left>-1)
		{
			sValues.append(sValue.left(left));
			sValue = sValue.right(sValue.length() - 2-left);
			left= sValue.find("\\P",0);
		}
		sValues.append(sValue);	
	
	// resolve unknown variables
		for (int v= 0; v < sValues.length(); v++)
		{
			String& value = sValues[v];
			int left = value.find("@(", 0);
			
		// get formatVariables and prefixes
			if (left>-1)
			{ 
				// tokenize does not work for strings like '(@(KEY))'
				String sTokens[0];
				while (value.length() > 0)
				{
					left = value.find("@(", 0);
					int right = value.find(")", left);
					
				// key found at first location	
					if (left == 0 && right > 0)
					{
						String sVariable = value.left(right + 1);
						
						//"Radius"
						String s;
						if (sVariable.find("@("+sCustomVariables[0]+")",0,false)>-1)
						{
							s.formatUnit(dRadius,_kLength);
							sTokens.append(s);
						}
						value = value.right(value.length() - right - 1);
					}
				// any text inbetween two variables	
					else if (left > 0 && right > 0)
					{
						sTokens.append(value.left(left));
						value = value.right(value.length() - left);
					}
				// any postfix text
					else
					{
						sTokens.append(value);
						value = "";
					}
				}
//	
				for (int j=0;j<sTokens.length();j++) 
					value+= sTokens[j]; 
			}
//			//sAppendix += value;
			sLines.append(value);
		}	
//		
	// text out
		for (int j=0;j<sLines.length();j++) 
		{ 
			text += sLines[j];
			if (j < sLines.length() - 1)text += "\\P";		 
		}//next j
	}
//		
//End Resolve format by entity//endregion 

// find outside location and draw text
	if (text.length()>0)
	{ 
		if (_PtG.length() < 2)_PtG.append(_Pt0+(vecX+vecY)*(dRadius + .6*dTextHeight));
		Point3d pt = _PtG.length()<2?_Pt0:_PtG[1];
		double dXFlag = vecX.dotProduct(pt - _Pt0) < 0 ?- 1 : 1;
		double dYFlag = vecY.dotProduct(pt - _Pt0) < 0 ?- 1 : 1;

		dp.draw(text, pt, vecX, vecY, dXFlag, dYFlag,_kDevice);
	}
	else if(_PtG.length()>1)
		_PtG.removeAt(1);
	
//End Parse text and display if found//endregion 


#End
#BeginThumbnail
M_]C_X``02D9)1@`!`@``9`!D``#_[``11'5C:WD``0`$````9```_^X`#D%D
M;V)E`&3``````?_;`(0``0$!`0$!`0$!`0$!`0$!`0$!`0$!`0$!`0$!`0$!
M`0$!`0$!`0$!`0$!`0("`@("`@("`@("`P,#`P,#`P,#`P$!`0$!`0$"`0$"
M`@(!`@(#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#
M`P,#`P,#`P,#_\``$0@!+`&0`P$1``(1`0,1`?_$`+D``0`"`@,!`0$`````
M```````'"`8)!`4*`P$"`0$``@,!`0$`````````````!`8#!0<"`0@0```&
M`@$"`@0)"0<$`P`````!`@,$!08'$1(((1,Q011X42)S%39WMSBX83(C,[,T
MM'46@4)2)+8W"7%B<A>1H501``(!`@,#"`D!!@8"`P`````!`@,$$2$%,8$2
M05%A<9$R$P:AL<$B4G)S-#710F*"DK(S\.'Q([,4HB320U/_V@`,`P$``A$#
M$0`_`/?P````````````````````````````````````````````````````
M````````````````````````````````````````````````````````JQF_
M<Y"3?6VOM&8LO>&R::?-I\B.ON"Q[4FM[BM<;:L:W:NVRK+VOI+ZO<=0A['J
M6#D&6-+>:<>JF82G)K.MU#5K/3H_[\L:O)%9R>[D72\"=9Z==7LO]J.%/ED\
MDOUZD8+'>[N\9Z\CC;-U7M6VFDJ5=:SRS")NK\&:D)Y9AU>M,_Q-[-\UP"K1
M'-+DQ[(Z_84F9*0I3'L#+B6&:S2\W3\9^/17@-Y<+]Y+IQRE_P")O:GER/AK
MPJC\;#/%9/LS7I,UK>[C`ZAQ-=O"DR/MSM2>C1/G/::*UG5EG+D-I0R=%NVB
MGVNKR3:3TN,UT"XL:7(YG02E53)N(0=FL]6L+[!4*B\1_LO*78]N[$T-SIUY
M:9U8/@YUFNWDWX%JD+0XA+C:DK0M*5H6A1*0M"B)25)4DS)25$?)&7@9#9$(
M_H``````````````````````````````````````````````````````````
M``````````````````>>/LWWUF>N.WC0U'#16VF,PM1:Y3'HY<1J,B(AW$JA
M][V&9!0S(86Z\XI9^9YR.I2CZ.3,QP*YO:\+VKQ/B7BRV[>\^7:=<H6U)VU/
MA7#[D=G4N0V0X7W,:[RCR8UL^]B%FX9(\BX4E=:M9D1_H;EE)1D-ES^=(3&\
M2]'H&:G>T9Y2]V73L[3Q.VJ1S6:)_2N'91.I"HT^!-8,NI)M2HDN,\@TJ+DC
M<9?8=;49'Z4J(Q,3Y48&N1D%0]!5N"*]KT!EV2=O\A$AJ5_3&$^PV6G;$V%F
M^JOLM*9%'L<"IZ^WD\'92\88QK(9B.2*T:5TK3N[+S!J5GA'C\2DN2>?8]J[
M<.@U5UH]E<XRX>"ISQR[5L]&/2937[YW'KXB8W=J;^KZ*,I27MK=NL6WRA@H
MJ%GS;9-H.T=G;5QY3RG6VF:[%9>QY*C);KJV&R/HMEEYGL+C"-QC1J=.<?YE
M[4BNW6@W='WJ.%2'1D^S]&RPVN=L:UVY5S;C6N;X[F4.JGN5%ZW2V++]GC-Z
MP7,O',MI5FW<XED]<KE$JLLF(L^*X1H>90M)I*Q0G"I%3IM2@]C3Q3WHTTHR
MA)QFFI+D>3)"'H\@````````````````````````````````````````````
M```````````````````````````>77M__P!AM)?5%K;_`$;2C\[WOWE;ZLOZ
MF=DMOMJ?R1]2)<$4SF9XGL/,\'>)W&,@GUJ#7UN0B64BM?4?'4;];*2]"=69
M>'4:.LO49&,M.M4I/&#:]78>)TX3[RQ+887W<-+\F'GM";*OBH5=8_RML_[O
MF2:F4Z;B"+P-:FGE\^/2V7@0GTM0Y*JWK]"+.UY8/M+6XOG.(YI'.3B]_7VZ
M4H2MUAA[HFQTK_-.77OI:G1.KU>8VGDR$^G5IU5C!ID64)PRDL#%LYTIK/8E
MK`R7(<;]FS6HB.5]+L7$[:[P/9]%7/NH?DU=)LO![+'LZJJ>:\VE4F$Q8(B2
M^DB>;<(N!/M;Z[LI<5K4E!\RV/K3R>]$6O:6]TN&O",O6NI[5VG60;#N>UDI
MLJG*L;[C<29ZU/4^RV:W6FX8[)-.//*J]BX'C[>M,L<:-E,>OJY^)T"W%.]<
MV_/I-9VJR\VO*%_3_BA[8OV/<5^Z\NK.5I/^&7L:]JWDE8=W3ZMR&[I\,RT\
M@TOLB]?C0*K76YZV+AUU>7$E"7"HL)R6/8W&L]JV\=M:3?:Q"^ORC]1$XI)G
MP+5:W]G>QXK:I&71L:ZT\UV%>N+.YM7A7@X]/)N:R+("81@`````````````
M```````````````````````````````````````````````````````\NO;_
M`/[#:2^J+6W^C:4?G>]^\K?5E_4SLEM]M3^2/J1+@BF<```.3$F2Z^2U,@2I
M,*6PLG&)41]V-)967H6T^RI#K:R^$C(Q]3:>*R9\:36#V%B\+[H,_P`<-F-?
M^SYA6HZ4F5@?LMNALO4U;1VU>:H^>35(:?4?HZB(3*5]6AE/WH^GM_4CSMH2
MSCDRVN%]PVMLP\J.Y:?TW:.<)^;\A-N$A;AF2>F/9$M=:]UK/A"3<0ZOG\SU
M#84KRC4RQX9=/Z["+.WJ0Y,5T$KY#CF-YG0V6-9714F5XQ?0EP;C'\AJX%[0
MW->^1>9#LJJR8E5]C">(BZFW6UH47I(2XRE"2G!M26QK:1Y1C)<,DG%\C(@K
MM0Y7K5*5]ONU;[75?&CML1-8YM'E[;T@A#;JDM-0,1O+NJSG!H%?7N*8@5V)
M91CM)%Z6U+@2$M^6JPV7F;4+;"-9JM3_`'N]NE^J9I[K0K.OC*EC3GT;.S],
M#+X?<UD^$-N-=P.HL@Q"%%;ZG=EZG*WW3K!XB-)-N6,&@H(6WL.<..AR3->L
M,75CU2T@TNW;O"7%VRR\PZ==X1E+PJKY)Y+=+9VM/H*[=:->VV,E'Q*?/'/M
M6WUKI+,8?FN&["H(>5X#EN,YQB]@I],#),/OJK):"<J,\N/)3#N*67-KI*H[
M[:D+)#BNA:3(^#(R&\336*V&I::>#VF3#Z``````````````````````````
M``````````````````````````````````````\NO;__`+#:2^J+6W^C:4?G
M>]^\K?5E_4SLEM]M3^2/J1+@BF<````````)%P[:^>X(I"<?R"6W!1Z:B:?M
M]2I)F2E)3!E>8W&-9EXK9\IS_N&:G7JTNX\N;D,<Z5.?>69;3"^[:CG>5$SF
MF>I)!F25VU.EV?5F9F7+CT%9KLXC9%SX-G+4?'Y?#84M0B\JJP?.MGZ^LBSM
M9+.#Q+2T&3X[E4/V_'+JNN8OQ26Y`E-/J94HN2;DM)5YT5WC^XXE*OR"="I"
MHL8--$6491>$E@R-,CT)@%QD4_.\=;N=6[-LELO3]G:FM7,%S"ZDPV&H]8YF
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
MOY1-]1UK?4DCH6H^5M8T[&;I^+07[5/&672N\NG+#I+99:]IU[A%3\.J_P!F
M>78]C[<>@[-*DK2E:%$I*B)25),E)4E1<DI)ER1D9'X&*X;H_0``````````
M````31IS]YOOD*_]I+&>CM9BJ;$3!3_>'[1?KKS?\*G<F+CY/_-1^G/U%<\R
M?C'\\3;,.M'/````````````````````````````````````````````````
M````````````#YO,M2&G6'VFWV'VULO,O(2XT\TXDT.-.MK)2'&W$*,E),C(
MR/@P!0+87_''HJY)^QTVNW[;<AX4ZU'U2W7,ZPFR$_IFVKO2UM&EZ]9A3)9$
MJPD4$;'KV:@U)^<VU=+B-+J/E_2M4QE<TDJS_;C[LNU;?XDS9V>KZA8X*C4;
MIK]F6<>SDW-%%]A=N?<]IOSY&2:]9W+B,4UG_7^@X=G:72(C)&;MCDNB;5^;
ML"I>D*<0B/`Q:;GSZ^E:W5LD22.AZCY%O:&-33IJM3^%^[/_`.+[8]1;++S7
M;5<(7D73GSK./ZKT]9"^.9=C.7,SG<;NX%LJIFJJ[J)'>Z;.@MVVFGGZ7(JE
MXFK/'[R*V\@WH4UEB4SU$2VTGX"E7%M<6E1T;J$Z=5<DDT_3R=)9Z->C<0\2
MA*,X<Z>)D8P&4``````````FC3G[S??(5_[26,]':S%4V(F"G^\/VB_77F_X
M5.Y,7'R?^:C].?J*YYD_&/YXFV8=:.>`````````````````````````````
M````````````````````````````````````%?MR]K.A=^/,66S->5MCE4&$
MFMJ=AT$RVPC:-)6I==D?-5-L["I^/YW74CLA]2WZ]NP*!*,S)]EU)F1Q[FTM
MKRGX5U3A4I\TDGV8['TK,S4+BO;3\2WG*$^=/#_4U[;`[!=YX.IV?J#85+NO
M'D&;J\1VPBNP/9D9@E>=)*FV#A="UK_*Y1M$;,"NGX]CB.OI.5<F2E.)I.H^
M1+2KC4TVHZ4_AEC*/;WEOXBSV7FNXIX0O8*I'XHY2[.Z_P#Q*;VN0OXCD5?A
M6T,8RO3N=6KST6KQ'9U4W02+Z9'6M,F)A>3Q)=IK_93D5M*7'EXQ<7++"'4>
M8M!J(A0]1T'5-+Q=U2?A+]N/O1[5L_BP?06RSU:POLJ%1>)\+REV/;NQ1D@T
MYL@``````)HTY^\WWR%?^TEC/1VLQ5-B)@I_O#]HOUUYO^%3N3%Q\G_FH_3G
MZBN>9/QC^>)MF'6CG@``````````````````````````````````````````
M``````````````````````````8YEV'8CL#&KC#,\Q;',VP_(8AP+_%,NI*S
M),:O(*EH<5"N**YBS:NSB*<;2HVWFEH-22/CDB#;DP:]MA_\;F(FN1:=O>Q<
MBTQ/<=D23PG(6INV=-R'WV?)),;%<@O:W-\+BQ&VFD0H.-9+3T,(DJ5\V/*6
MKFM:CY3T?4,9J'@UW^U3R[8]U].2?2;NR\P:C9X1<O$I<T\^Q[5VX=!178.M
M]\Z3\US<.H;=O'X_LQ.;.U$Y9[=UD12.I2W;555156S,*AU4=!NV=C?8S78]
M`1R?SH\A*G!0M1\EZK9XSM<+BBOARGATP>W^%R9;;+S-87.$*^-&I^]G'^;]
M4C$:*_HLHJ85_C-U4Y%16;1OUUU16,.WJ;!E+BV5/0K&O>D0Y;276U)-3:U$
M2DF7I(Q4ITYTING4BXU%M36#76F6&,XSBIP:<'L:S7:=L/!Z``FC3G[S??(5
M_P"TEC/1VLQ5-B)@I_O#]HOUUYO^%3N3%Q\G_FH_3GZBN>9/QC^>)MF'6CG@
M````````````````````````````````````````````````````````````
M`````````````5%V]V/]OFW;2SRUS&9FM=EVCJY<O:>HIS>"YE8V*C,DV.6Q
MXT29ANSWF&UK2RUEM1?Q6#<4MMI+G"R@7VEZ?J4."]I0GTM8275)826YDNUO
M[RREQ6U24.CD?6GD^PH#L+LR[G=7^?-Q1./=RF(L$M3;="NJUCNF,P1FU%8>
MQG)[=G5F<26VT>=.L8]_BQJ-1IB4RS)+9T74?(3SJ:75_@J>R278FNN1:[+S
M9LA?T_XH>V+]CW%8H&84LN^F8A,^=,9SFMCG,L]>YO176"["K8!.)91:3,'R
MZ!39.W22G%I]FL"BJ@3$*2N.\ZVI*CHM]IE_IL^"]I3IYY-KW7U26,7N9:K6
M^M+V/%;5(SZ.5=:>:WHL?IS]YOOD*_\`:2Q'H[69JFQ$FZAG2MN]P^E+'6E+
M;9=A>F=DYO?[,V9`899UQ0R5Z0V]K:-B55E,U^-$SC-#RO.8[,R!0E9_,J8T
M@K5<%[V9F3T/RAI-]"[6HU8<%MP-+')RQYEMPZ7@GR8E/\QZA:RMW90EQ5^)
M-X9I8<[Y^A8].!MY'2"D@```````````````````````````````````````
M`````````````````````````````````````1IM'3>JMV4+6,[9U]BFP*>+
M).?6,9+3Q+"316GE+9:O,:LG&RM,9R&*A9G'L*]Z--CJX4TZA1$9>*E.G5@Z
M=6*E3>U-)I]:>1ZA.=.2G3;C-;&G@UO*AU?_`!QZDKKUYF5L3=>0ZC?4V\_H
MK),VBV^(3WH[A.18609T[2HWAF.,(6:SD5-UE5C"LT.KC6"9<`_8RTU+RWHM
M"Z_[=*A%5.;-Q3YU%Y)[L%M2QS-G4UO4ZM#_`*\ZK<.?)2:YG)9^WG>!?.DH
MZ7&:>KQW'*BKQ_'Z.OB5-)14E?$JJ>GJJ]A$6!65=9`:8A5]?"C-);9990AM
MMM))21$1$-X:H[0`````````````````````````````````````````````
M````````````````````````````````````````````````````````````
#`?_9




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
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22998: Display objects enabled for showing in hsbView" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="11/22/2024 1:31:36 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16519: for maprequestdim use direction vectors algned with the edge" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="3/8/2023 4:29:45 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16519: Write maprequest for DimRequestPoint of _Pt0" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="1/11/2023 8:49:10 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End