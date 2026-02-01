#Version 8
#BeginDescription
#Versions
Version 3.7 25.09.2024 20240925: Fix for "Free form" type , Author Marsel Nakuci
3.7 09/09/2024 Make sure one deep point ptDeeps is defined for tapered insulation Marsel Nakuci
3.6 08.03.2023 HSB-17501: Fix translation
3.5 12.01.2023 HSB-17535: Add property "max height" to limit max height
3.4 10.01.2023 HSB-17320: Dont draw volume twice 
3.3 20.12.2022 HSB-17321:Add command "subtract polylines"
3.2 15.12.2022 HSB-17321:automatic labeling of section cuts
3.1 15.12.2022 HSB-17321:improve section cuts; add trigger to change height of low points
3.0 12.12.2022 HSB-17321: Initial
2.14 09.06.2022 HSB-15668: set properties readonly when tsl is controlled by Stellfüße 
2.13 08.06.2022 HSB-15668: fix initialization of grip points 
2.12 01.06.2022 HSB-15602: Smart command "Align Faces"; only shown if possible 
2.11 31.05.2022 HSB-15602: Align only faces at edges that match bottom edges 
2.10 30.05.2022 HSB-15602: Add command "Align faces" Author:
2.9 30.05.2022 HSB-15602; Apply simple rigid body alignment, dont modify volume
2.8 29.04.2022 Fix reference plane for horizontal insulations 
2.7 14.04.2022 HSB-15208: Switch for hatches yes/no
2.6 13.04.2022 HSB-15208: Expose XML properties 
2.5 13.04.2022 HSB-15208: Property for hazch yes/no 
2.4 12.04.2022 HSB-15208: hide properties "Edge" and "Slope" on insert 
2.3 01.04.2022 HSB-15066: some improvements 
2.2 30.03.2022 HSB-15066: support alignmend between entities, add properties for slope and edge
2.1 29.03.2022 HSB-15066: New properties for legend visibility and styles 
Version 2.0 20.01.2022 HSB-14427: Working Version for flat surfac: 
Version 1.1 20.01.2022 HSB-14427: support xml: 

This tsl creates a visual representation of an insulation volume defined by a polyline
The height/thickness of the insulation is defined in the properties






















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 7
#KeyWords Rubner,Raum,insulation,Dämmung
#BeginContents
//region <History>
// #Versions:
// 3.7 25.09.2024 20240925: Fix for "Free form" type , Author Marsel Nakuci
// 3.6 08.03.2023 HSB-17501: Fix translation Author: Marsel Nakuci
// 3.5 12.01.2023 HSB-17535: Add property "max height" to limit max height Author: Marsel Nakuci
// 3.4 10.01.2023 HSB-17320: Dont draw volume twice Author: Marsel Nakuci
// 3.3 20.12.2022 HSB-17321:Add command "subtract polylines" Author: Marsel Nakuci
// 3.2 15.12.2022 HSB-17321:automatic labeling of section cuts Author: Marsel Nakuci
// 3.1 15.12.2022 HSB-17321:improve section cuts; add trigger to change height of low points Author: Marsel Nakuci
// 3.0 12.12.2022 HSB-17321: Initial Author: Marsel Nakuci
// 2.14 09.06.2022 HSB-15668: set properties readonly when tsl is controlled by RUB-Stellfüße Author: Marsel Nakuci
// 2.13 08.06.2022 HSB-15668: fix initialization of grip points Author: Marsel Nakuci
// 2.12 01.06.2022 HSB-15602: Smart command "Align Faces"; only shown if possible Author: Marsel Nakuci
// 2.11 31.05.2022 HSB-15602: Align only faces at edges that match bottom edges Author: Marsel Nakuci
// 2.10 30.05.2022 HSB-15602: Add command "Align faces" Author: Marsel Nakuci
// 2.9 30.05.2022 HSB-15602; Apply simple rigid body alignment, dont modify volume Author: Marsel Nakuci
// 2.8 29.04.2022 20220429: Fix reference plane for horizontal insulations Author: Marsel Nakuci
// 2.7 14.04.2022 HSB-15208: Switch for hatches yes/no Author: Marsel Nakuci
// 2.6 13.04.2022 HSB-15208: Expose XML properties Author: Marsel Nakuci
// 2.5 13.04.2022 HSB-15208: Property for hazch yes/no Author: Marsel Nakuci
// 2.4 12.04.2022 HSB-15208: hide properties "Edge" and "Slope" on insert Author: Marsel Nakuci
// 2.3 01.04.2022 HSB-15066: some improvements Author: Marsel Nakuci
// 2.2 30.03.2022 HSB-15066: support alignmend between entities, add properties for slope and edge Author: Marsel Nakuci
// 2.1 29.03.2022 HSB-15066: New properties for legend visibility and styles Author: Marsel Nakuci
// Version 2.0 20.01.2022 HSB-14427: Working Version for flat surfac: Marsel Nakuci
// Version 1.1 20.01.2022 HSB-14427: support xml: Marsel Nakuci
/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl creates a visual representation of an insulation volume defined by a polyline
// The height/thickness of the insulation is defined in the properties
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "TaperedInsulation")) TSLCONTENT
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
	
//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="TaperedInsulation";
	Map mapSetting;
	
// compose settings file location
	String sFolders[]=getFoldersInFolder(sPath);
	int bPathFound = _bOnInsert ? sFolders.find(sFolder) >- 1 ? true : makeFolder(sPath + "\\" + sFolder) : false;
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";
	
// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid())
	{
		String sFile=findFile(sFullPath);
	// if no settings file could be found in company try to find it in the installation path
		if (sFile.length()<1) sFile=findFile(sPathGeneral+sFileName+".xml");
		if (sFile.length()>0)
		{ 
			mapSetting.readFromXmlFile(sFile);
			mo.dbCreate(mapSetting);
		}
	}
	// validate version when creating a new instance
	if(_bOnDbCreated)
	{ 
		int nVersion = mapSetting.getInt("GeneralMapObject\\Version");
		String sFile = findFile(sPathGeneral + sFileName + ".xml");		// set default xml path
		if (sFile.length()<1) sFile=findFile(sFullPath);				// set custom xml path if no default found
		Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);	// read the xml from installation directory
		int nVersionInstall = mapSettingInstall.getMap("GeneralMapObject").getInt("Version");
		if(sFile.length()>0 && nVersion!=nVersionInstall)
			reportNotice(TN("|A different Version of the settings has been found for|") + scriptName()+
			TN("|Current Version| ")+nVersion + "	" + _kPathDwg + TN("|Other Version| ") +nVersionInstall + "	" + sFile);
	}
//End Settings//endregion
	
//region Properties
	category=T("|Type|");
	String sTypeName=T("|Type|");
//	String sTypes[]={T("|Free Definition|"),"Dachform","Gefälledämmung"};
	// HSB-17501
	String sTypes[]={T("|Free definition|"),T("|Roof shape|"),T("|Gradient insulation|")};
	PropString sType(nStringIndex++,sTypes,sTypeName);
	sType.setDescription(T("|Defines the type of the tapered insulation.|"));
	sType.setCategory(category);
	
	category = T("|Position|");
	String sZheightName=T("|Elevation|");
//	String sZheightName="Erhebung";
	PropDouble dZheight(nDoubleIndex++, U(0), sZheightName);	
	dZheight.setDescription(T("|Defines the elevation.|"));
	dZheight.setCategory(category);
	
	String sHeightName=T("|Thickness|");
//	String sHeightName="Dicke";
	PropDouble dHeight(nDoubleIndex++, U(30), sHeightName);	
	dHeight.setDescription(T("|Defines the height/thickness of insulation.|"));
	dHeight.setCategory(category);	
	
	String sSlopeName=T("|Slope|")+" %";	
	PropDouble dSlope(nDoubleIndex++, U(0), sSlopeName);	
	dSlope.setDescription(T("|Defines the slope of the insulation in %.|"));
	dSlope.setCategory(category);
	
	String sSlopeGradName=T("|Slope|")+" °";
	PropDouble dSlopeGrad(nDoubleIndex++, U(0), sSlopeGradName);
	dSlopeGrad.setDescription(T("|Defines the slope of the insulation in degree.|"));
	dSlopeGrad.setCategory(category);
	
	String sHeightMaxName=T("|Max|")+" "+T("|Height|");
	PropDouble dHeightMax(nDoubleIndex++, U(0), sHeightMaxName);
	dHeightMax.setDescription(T("|Defines the maximum height of the insulation.|")+" "+
	T("|Insulation will be cut horizontally if it exceeds this value.|"));
	dHeightMax.setCategory(category);
	
//	String sEdgeIndexName=T("|Edge|");	
//	int nEdgeIndexs[]={1,2,3};
//	PropInt nEdgeIndex(nIntIndex++, 0, sEdgeIndexName);	
//	nEdgeIndex.setDescription(T("|Defines the Edge Index|"));
//	nEdgeIndex.setReadOnly(_kHidden);
//	nEdgeIndex.setCategory(category);
	
	category = T("|Display|");
	// display style
	String sDisplayStyles[0];
	Map mapDisplayStyles=mapSetting.getMap("Darstellungsstil[]");
	for (int i=0;i<mapDisplayStyles.length();i++)
	{ 
		Map mapDisplayStyleI = mapDisplayStyles.getMap(i);
		if(mapDisplayStyleI.hasString("Name") && mapDisplayStyles.keyAt(i).makeLower() == "darstellungsstil")
		{ 
			if(!mapDisplayStyleI.hasInt("isActive"))continue;
			if(!mapDisplayStyleI.getInt("isActive"))continue;
			String sDisplayStyleName=mapDisplayStyleI.getString("Name");
			if(sDisplayStyles.find(sDisplayStyleName)<0)
			{ 
				sDisplayStyles.append(sDisplayStyleName);
			}
		}
	}//next i
	String sDisplayStyleName=T("|Style|");
	PropString sDisplayStyle(nStringIndex++, sDisplayStyles, sDisplayStyleName);
	sDisplayStyle.setDescription(T("|Defines the display style from the available styles in xml.|"));
	sDisplayStyle.setCategory(category);
	
	// legend display
	String sLegendName=T("|Legend|");	
	PropString sLegend(nStringIndex++, sNoYes, sLegendName);	
	sLegend.setDescription(T("|Defines the legend visibility.|"));
	sLegend.setCategory(category);
	
	String sNumberName=T("|Number|");	
	PropString sNumber(nStringIndex++, "", sNumberName);	
	sNumber.setDescription(T("|Defines the number of the volume.|"));
	sNumber.setCategory(category);
	
	String sNameName=T("|Name|");	
	PropString sName(nStringIndex++, "", sNameName);	
	sName.setDescription(T("|Defines the name of the volume.|"));
	sName.setCategory(category);
	
	String sMaterial1Name=T("|Material1|");	
	PropString sMaterial1(nStringIndex++, "", sMaterial1Name);	
	sMaterial1.setDescription(T("|Defines name of material 1|"));
	sMaterial1.setCategory(category);
	
	String sMaterial2Name=T("|Material2|");	
	PropString sMaterial2(nStringIndex++, "", sMaterial2Name);	
	sMaterial2.setDescription(T("|Defines name of material 2|"));
	sMaterial2.setCategory(category);
	
	category = T("|Contour|");
	String sLineTypeName=T("|Type|");
	String sLineTypes[0];
	sLineTypes.append(_LineTypes);
//	sLineTypes.insertAt(0,T("|Disabled|"));
	PropString sLineType(nStringIndex++, sLineTypes, sLineTypeName);	
	sLineType.setDescription(T("|Defines the line type.|"));
	sLineType.setCategory(category);
	
	String sLineThicknessName=T("|LineThickness|");	
	PropDouble dLineThickness(nDoubleIndex++, U(0), sLineThicknessName);	
	dLineThickness.setDescription(T("|Defines the line thickness|"));
	dLineThickness.setCategory(category);
	
	String sLineScaleName=T("|Scale|");	
	PropDouble dLineScale(nDoubleIndex++, U(1), sLineScaleName);	
	dLineScale.setDescription(T("|Defines the line scale.|"));
	dLineScale.setCategory(category);
	
	String sLineColorName=T("|Color|");	
	int nLineColors[]={1,2,3};
	PropInt nLineColor(nIntIndex++, 1, sLineColorName);	
	nLineColor.setDescription(T("|Defines the line color. -1 indicates byLayer, -2 indicates byEntity.|"));
	nLineColor.setCategory(category);
	
	category = T("|Solid Hatch|");
//	String sHatchName=T("|Hatch|");
//	PropString sHatch(nStringIndex++, sNoYes, sHatchName);
//	sHatch.setDescription(T("|Switch for the Hatch|"));
//	sHatch.setCategory(category);
	
//	String sHatchSolidName=T("|Compact|");	
//	String sHatchSolids[0];
//	sHatchSolids.append(sNoYes);
////	sHatchSolids.insertAt(0,T("|Disabled|"));
//	PropString sHatchSolid(nStringIndex++, sHatchSolids, sHatchSolidName);	
//	sHatchSolid.setDescription(T("|Switch for the solid hatch|"));
//	sHatchSolid.setCategory(category);
	
	String sHatchSolidVisibilityName=T("|Visibility|");	
	PropString sHatchSolidVisibility(nStringIndex++, sNoYes, sHatchSolidVisibilityName);	
	sHatchSolidVisibility.setDescription(T("|Defines the visibility for the solid hatch.|"));
	sHatchSolidVisibility.setCategory(category);
	
	String sHatchSolidColorName=T("|Solid Color|");	
	int nHatchSolidColors[]={1,2,3};
	PropInt nHatchSolidColor(nIntIndex++, -3, sHatchSolidColorName);	
	nHatchSolidColor.setDescription(T("|Defines the color for the solid hatch. -3 will use the XML definitions.|"));
	nHatchSolidColor.setCategory(category);
	
	String sHatchSolidTransparencyName=T("|Solid Transparency|");	
	int nHatchSolidTransparencys[]={1,2,3};
	PropInt nHatchSolidTransparency(nIntIndex++, 0, sHatchSolidTransparencyName);	
	nHatchSolidTransparency.setDescription(T("|Defines the transparency for the solid hatch.|"));
	nHatchSolidTransparency.setCategory(category);
	
	category = T("|Pattern Hatch|");
	String sHatchPatternVisibilityName=T("|Visibility|");	
	PropString sHatchPatternVisibility(nStringIndex++, sNoYes, sHatchPatternVisibilityName);	
	sHatchPatternVisibility.setDescription(T("|Defines the visibility for the pattern hatch.|"));
	sHatchPatternVisibility.setCategory(category);
	
	String sHatchPatternName=T("|Pattern|");	
	String sHatchPatterns[0];
	sHatchPatterns.append(_HatchPatterns);
//	sHatchPatterns.insertAt(0,T("|Disabled|"));
	PropString sHatchPattern(nStringIndex++, sHatchPatterns, sHatchPatternName);	
	sHatchPattern.setDescription(T("|Defines the hatch pattern.|"));
	sHatchPattern.setCategory(category);
	
	String sLineWeightName=T("|LineWeight|");
	int nLineWeights[]={ -1, -2, -3, 0, 5, 9, 13, 15, 18, 20, 25, 30, 35, 40, 50, 53, 60, 70, 80, 90, 100, 106, 120, 140, 158, 200, 211};
	String sLineWeights[]={ T("|ByLayer|"), T("|ByBlock|"), T("|Default|"), "0.00 mm","0.05 mm","0.09 mm","0.13 mm","0.15 mm","0.18 mm",
		"0.20 mm","0.25 mm","0.30 mm","0.35 mm","0.40 mm","0.50 mm","0.53 mm","0.60 mm","0.70 mm","0.80 mm","0.90 mm","1.00 mm","1.06 mm",
		"1.20 mm","1.40 mm","1.58 mm","2.00 mm","2.11 mm"};
//	sLineWeights.insertAt(0,T("|Disabled|"));
	PropString sLineWeight(nStringIndex++, sLineWeights, sLineWeightName);	
	sLineWeight.setDescription(T("|Defines the LineWeight.|"));
	sLineWeight.setCategory(category);
	
	String sHatchPatternColorName=T("|Color|");	
	int nHatchPatternColors[]={1,2,3};
	PropInt nHatchPatternColor(nIntIndex++, 1, sHatchPatternColorName);
	nHatchPatternColor.setDescription(T("|Defines the Color for Pattern Hatch. -1 indicates byLayer, -2 indicates byEntity.|"));
	nHatchPatternColor.setCategory(category);
	
	String sHatchPatternAngleName=T("|Angle|");	
	PropDouble dHatchPatternAngle(nDoubleIndex++, U(0), sHatchPatternAngleName);	
	dHatchPatternAngle.setDescription(T("|Defines the rotation angle for the pattern hatch.|"));
	dHatchPatternAngle.setCategory(category);
	
	String sHatchPatternScaleName=T("|Scale|");	
	PropDouble dHatchPatternScale(nDoubleIndex++, U(1), sHatchPatternScaleName);	
	dHatchPatternScale.setDescription(T("|Defines the scale for the pattern hatch.|"));
	dHatchPatternScale.setCategory(category);
	
	String sHatchPatternTransparencyName=T("|Pattern Transparency|");	
	int nHatchPatternTransparencys[]={1,2,3};
	PropInt nHatchPatternTransparency(nIntIndex++, 0, sHatchPatternTransparencyName);	
	nHatchPatternTransparency.setDescription(T("|Defines the transparency for the pattern hatch.|"));
	nHatchPatternTransparency.setCategory(category);
	
// category for section
	category=T("|Display Section|");
	String sLineTypeSectionName=T("|Line Type|");
	String sLineTypeSections[0];sLineTypeSections.append(_LineTypes);
	PropString sLineTypeSection(nStringIndex++,sLineTypeSections, sLineTypeSectionName);	
	sLineTypeSection.setDescription(T("|Defines the LineTypeSection|"));
	sLineTypeSection.setCategory(category);
	sLineTypeSection.setReadOnly(_kHidden);
	sLineTypeSection.setReadOnly(_kHidden);
	
	String sLineThicknessSectionName=T("|Line Thickness|");	
	PropDouble dLineThicknessSection(nDoubleIndex++, U(0), sLineThicknessSectionName);	
	dLineThicknessSection.setDescription(T("|Defines the LineThickness Section|"));
	dLineThicknessSection.setCategory(category);
	dLineThicknessSection.setReadOnly(_kHidden);
	dLineThicknessSection.setReadOnly(_kHidden);
	
	String sLineScaleSectionName=T("|Line Scale|");	
	PropDouble dLineScaleSection(nDoubleIndex++, U(1), sLineScaleSectionName);	
	dLineScaleSection.setDescription(T("|Defines the LineScale Section|"));
	dLineScaleSection.setCategory(category);
	dLineScaleSection.setReadOnly(_kHidden);
	dLineScaleSection.setReadOnly(_kHidden);
	
	String sLineColorSectionName=T("|Line Color|");	
	int nLineColorSections[]={1,2,3};
	PropInt nLineColorSection(nIntIndex++, 6, sLineColorSectionName);	
	nLineColorSection.setDescription(T("|Defines the LineColor Section|"));
	nLineColorSection.setCategory(category);
	nLineColorSection.setReadOnly(_kHidden);
	
	String sLabelSectionName=T("|Label Section|");
	PropString sLabelSection(nStringIndex++, "A", sLabelSectionName);	
	sLabelSection.setDescription(T("|Defines the Label Section|"));
	sLabelSection.setCategory(category);
	sLabelSection.setReadOnly(_kHidden);
	
	// will be visible on insert
	String sDimStyleSectionName=T("|DimStyleSection|");	
//	int nBfDim=_DimStyles
	PropString sDimStyleSection(nStringIndex++, _DimStyles, sDimStyleSectionName);	
	sDimStyleSection.setDescription(T("|Defines the DimStyle Section|"));
	sDimStyleSection.setCategory(category);
	sDimStyleSection.setReadOnly(_kHidden);
	
//	{ 
//	String sVertexIndexName=T("|Vertex|");	
//	int nVertexIndexs[]={1,2,3};
//	PropInt nVertexIndex(nIntIndex++, 0, sVertexIndexName);	
//	nVertexIndex.setDescription(T("|Defines the Vertex Index|"));
//	nVertexIndex.setCategory(category);
//	}
//	category = T("|Display|");
//	
//	String sTextShowName=T("|Show Text|");	
//	PropString sTextShow(nStringIndex++, sNoYes, sTextShowName);	
//	sTextShow.setDescription(T("|Defines the TextShow|"));
//	sTextShow.setCategory(category);
//
//	String sTextHeightName=T("|Text Height|");	
//	PropDouble dTextHeight(nDoubleIndex++, U(100), sTextHeightName);	
//	dTextHeight.setDescription(T("|Defines the TextHeight|"));
//	dTextHeight.setCategory(category);
	
//	String sDimStyleName=T("|Dim Style|");
//	String sDimStyles[0];
//	sDimStyles.append(_DimStyles);
//	sDimStyles.sorted();
//	PropString sDimStyle(nStringIndex++, sDimStyles, sDimStyleName);	
//	sDimStyle.setDescription(T("|Defines the DimStyle|"));
//	sDimStyle.setCategory(category);
//End Properties//endregion 
	
//region jig
// jig on insert
	String strJigAction1 = "strJigAction1";
	if (_bOnJig && _kExecuteKey == strJigAction1)
	{
		Vector3d vecView = getViewDirection();
		Point3d ptRef;
		ptRef.setZ(dZheight);
		Display dpjig(1);
		Point3d pts[] = _Map.getPoint3dArray("pts");
		Point3d ptJig = _Map.getPoint3d("_PtJig"); 
		ptJig = Line(ptJig, vecView).intersect(Plane(ptRef, _ZW), U(0));
		PLine pl;
		for (int ipt=0;ipt<pts.length();ipt++) 
		{ 
			pl.addVertex(pts[ipt]);
		}//next ipt
		if(pts.length()>=2)
		{ 
		// there are at least 2 points, create countour
			
			pl.addVertex(ptJig);
			pl.close();
			PlaneProfile pp(Plane(ptRef, _ZW));
			pp.joinRing(pl, _kAdd);
			dpjig.draw(pp);
		}
		else if(pts.length()==1)
		{ 
		// only one point draw segment
			pl.addVertex(ptJig);
			dpjig.draw(pl);
		}
		else if(pts.length()==0)
		{ 
			
		}
		
		return;
	}
// jig to delete a vertex
	String strJigAction2 = "strJigAction2";
	if (_bOnJig && _kExecuteKey == strJigAction2)
	{
		Vector3d vecView = getViewDirection();
		Point3d ptRef;
		ptRef.setZ(dZheight);
		Display dpjig(3);
		Display dpRemove(1);
		Point3d pts[] = _Map.getPoint3dArray("pts");
		Point3d ptJig = _Map.getPoint3d("_PtJig"); 
		Plane pn;
		if(_Map.hasPoint3d("ptPlane") && _Map.hasVector3d("vecPlane"))
		{ 
			pn=Plane(_Map.getPoint3d("ptPlane"), _Map.getVector3d("vecPlane"));
		}
		else
		{
			Point3d ptRef;
			ptRef.setZ(dZheight);
			pn=Plane(ptRef, _ZW);
		}
		ptJig=Line(ptJig,vecView).intersect(pn, U(0));
//		ptJig = Line(ptJig, vecView).intersect(Plane(ptRef, _ZW), U(0)); 
		PLine pl;
		for (int ipt=0;ipt<pts.length();ipt++) 
		{ 
			pl.addVertex(pts[ipt]);
		}//next ipt
		if(pts.length()>=2)
		{ 
		// there are at least 2 points, create countour
			
//			pl.addVertex(ptJig);
			pl.close();
//			PlaneProfile pp(Plane(ptRef, _ZW));
			PlaneProfile pp(pn);
			pp.joinRing(pl, _kAdd);
			dpjig.draw(pp);
		}
		else if(pts.length()==1)
		{ 
		// only one point draw segment
//			pl.addVertex(ptJig);
			dpjig.draw(pl);
		}
		else if(pts.length()==0)
		{ 
			
		}
		
		// get index of closest point with the jig point
		int iIndex = -1;
		double dDist = U(10e6);
		for (int ipt=0;ipt<pts.length();ipt++) 
		{ 
			if((pts[ipt]-ptJig).length()<dDist)
			{ 
				dDist = (pts[ipt] - ptJig).length();
				iIndex = ipt;
			}
		}//next ipt
		
		
		for (int ipt=0;ipt<pts.length();ipt++) 
		{ 
			PLine plI;
			plI.createCircle(pts[ipt], _ZW, U(1000));
//			PlaneProfile pp(Plane(ptRef, _ZW));
			PlaneProfile pp(pn);
			pp.joinRing(plI, _kAdd);
			if(ipt!=iIndex)
			{ 
				dpjig.draw(pp, _kDrawFilled);
			}
			else
			{ 
				dpRemove.draw(pp, _kDrawFilled);
			}
			 
		}//next ipt
		
		
		return;
	}
// jig to insert a vertex point
	String strJigAction3 = "strJigAction3";
	if (_bOnJig && _kExecuteKey == strJigAction3)
	{
		Vector3d vecView = getViewDirection();
		Point3d ptRef;
		ptRef.setZ(dZheight);
		Display dpjig(3);
		Display dpEdge(5);
		Display dpNew(4);
		
		Point3d pts[] = _Map.getPoint3dArray("pts");
		Point3d ptJig = _Map.getPoint3d("_PtJig"); 
		ptJig = Line(ptJig, vecView).intersect(Plane(ptRef, _ZW), U(0));
		 
		PLine pl;
		for (int ipt=0;ipt<pts.length();ipt++) 
		{ 
			pl.addVertex(pts[ipt]);
		}//next ipt
		if(pts.length()>=2)
		{ 
		// there are at least 2 points, create countour
//			pl.addVertex(ptJig);
			pl.close();
			PlaneProfile pp(Plane(ptRef, _ZW));
			pp.joinRing(pl, _kAdd);
//			dpjig.draw(pp,_kDrawFilled);
			dpjig.draw(pp);
		}
		else if(pts.length()==1)
		{ 
		// only one point draw segment
//			pl.addVertex(ptJig);
			dpjig.draw(pl);
		}
		else if(pts.length()==0)
		{ 
			
		}
		// draw text
		
		int jigMode = _Map.getInt("jigMode");
//		dpjig.draw(pts.length(), ptJig, _XW, _YW, 0, 0, _kDeviceX);
		if(jigMode==0)
		{ 
			// edge mode
			// get closest edge and highlight
			if(pts.length()>=2)
			{ 
				pts.append(pts[0]);
				int iEdge = -1;
				double dDist = U(10e6);
				for (int ipt=0;ipt<pts.length()-1;ipt++) 
				{ 
					Point3d pt1 = pts[ipt];
					Point3d pt2 = pts[ipt+1];
					Vector3d vecI = pt2 - pt1;vecI.normalize();
					Line lnI(pt1, vecI);
					double dDistI = (lnI.closestPointTo(ptJig) - ptJig).length();
					if(dDistI<dDist)
					{ 
						iEdge = ipt;
						dDist = dDistI;
					}
				}//next ipt
				
				if(iEdge>-1)
				{ 
					
					Vector3d vec = pts[iEdge + 1] - pts[iEdge];
					vec.normalize();
					Vector3d vecNorm = _ZW.crossProduct(vec);
					vecNorm.normalize();
					LineSeg lSeg(pts[iEdge] - vecNorm * U(300), pts[iEdge + 1] + vecNorm * U(300));
					PLine plEdge;
					plEdge.createRectangle(lSeg, vec, vecNorm);
					PlaneProfile pp(Plane(ptRef, _ZW));
					pp.joinRing(plEdge, _kAdd);
					dpEdge.draw(pp, _kDrawFilled);
				}
			}
		}
		else if(jigMode==1)
		{ 
			// point mode
			// add new point
			int iEdge = _Map.getInt("iEdge");
			PLine plNew;
			Point3d ptsNew[0];
			for (int ipt=0;ipt<pts.length();ipt++) 
			{ 
				ptsNew.append(pts[ipt]);
				plNew.addVertex(pts[ipt]);
				if(ipt==iEdge)
				{ 
					ptsNew.append(ptJig);
					plNew.addVertex(ptJig);
				}
			}//next ipt
			plNew.close();
			PlaneProfile pp(Plane(ptRef, _ZW));
			pp.joinRing(plNew, _kAdd);
//			dpNew.draw(pp,_kDrawFilled);
			dpNew.draw(plNew);
		}
		
		return;
	}
// jig for slope definition
	String strJigAction5 = "strJigAction5";
	if (_bOnJig && _kExecuteKey == strJigAction5)
	{
		Vector3d vecView = getViewDirection();
		Point3d ptRef;
		ptRef.setZ(dZheight);
		Display dpjig(3);
		Display dpEdge(5);
		Display dpNew(4);
		
		Point3d pts[] = _Map.getPoint3dArray("pts");
		Point3d ptJig = _Map.getPoint3d("_PtJig"); 
		Plane pn;
		if(_Map.hasPoint3d("ptPlane") && _Map.hasVector3d("vecPlane"))
		{ 
			pn=Plane(_Map.getPoint3d("ptPlane"), _Map.getVector3d("vecPlane"));
		}
		else
		{
			pn=Plane(ptRef, _ZW);
		}
		ptJig=Line(ptJig,vecView).intersect(pn, U(0));
		
		 // draw text
		PLine pl;
		for (int ipt=0;ipt<pts.length();ipt++) 
		{ 
			pl.addVertex(pts[ipt]);
		}//next ipt
		if(pts.length()>=2)
		{ 
		// there are at least 2 points, create countour
//			pl.addVertex(ptJig);
			pl.close();
			PlaneProfile pp(Plane(ptRef, _ZW));
			pp.joinRing(pl, _kAdd);
//			dpjig.draw(pp,_kDrawFilled);
//			dpjig.draw(pp);
			dpjig.draw(pl);
		}
		else if(pts.length()==1)
		{ 
		// only one point draw segment
//			pl.addVertex(ptJig);
			dpjig.draw(pl);
		}
		else if(pts.length()==0)
		{ 
			
		}
		// draw text
		
//		dpjig.draw(pts.length(), ptJig, _XW, _YW, 0, 0, _kDeviceX);
		{ 
			// edge mode
			// get closest edge and highlight
			if(pts.length()>=2)
			{ 
				pts.append(pts[0]);
				int iEdge = -1;
				double dDist = U(10e6);
				for (int ipt=0;ipt<pts.length()-1;ipt++) 
				{ 
					Point3d pt1 = pts[ipt];
					Point3d pt2 = pts[ipt+1];
					Vector3d vecI = pt2 - pt1;vecI.normalize();
					Line lnI(pt1, vecI);
					double dDistI = (lnI.closestPointTo(ptJig) - ptJig).length();
					if(dDistI<dDist)
					{ 
						iEdge = ipt;
						dDist = dDistI;
					}
				}//next ipt
				if(iEdge>-1)
				{ 
					
					Vector3d vec = pts[iEdge + 1] - pts[iEdge];
					vec.normalize();
					Vector3d vecNorm = pn.vecZ().crossProduct(vec);
					vecNorm.normalize();
					LineSeg lSeg(pts[iEdge] - vecNorm * U(300), pts[iEdge + 1] + vecNorm * U(300));
					PLine plEdge;
					plEdge.createRectangle(lSeg, vec, vecNorm);
//					PlaneProfile pp(Plane(ptRef, _ZW));
					PlaneProfile pp(pn);
					pp.joinRing(plEdge, _kAdd);
					dpEdge.draw(pp, _kDrawFilled);
				}
			}
		}
		
		
		return;
	}

// jig to do alignment
	String strJigAction4 = "strJigAction4";
	if (_bOnJig && _kExecuteKey == strJigAction4)
	{
		Vector3d vecView = getViewDirection();
		Point3d ptRef;
		ptRef.setZ(dZheight);
		Display dpjig(3);
		Display dpjigDestination(4);
		
		Point3d pts[] = _Map.getPoint3dArray("pts");
		Point3d ptJig = _Map.getPoint3d("_PtJig"); 
//		ptJig = Line(ptJig, vecView).intersect(Plane(ptRef, _ZW), U(0));
		
		PLine plOrigin, plDestination;
		if(pts.length()<=3)
		{ 
			for (int ipt=0;ipt<pts.length();ipt++) 
			{ 
				plOrigin.addVertex(pts[ipt]);
			}//next ipt
		}
		else if(pts.length()>3)
		{ 
			for (int ipt=0;ipt<3;ipt++) 
			{ 
				plOrigin.addVertex(pts[ipt]);
			}//next ipt
			for (int ipt=3;ipt<pts.length();ipt++) 
			{ 
				plDestination.addVertex(pts[ipt]);
				 
			}//next ipt
			
		}
		if(pts.length()==1 )
		{ 
		// there are at least 2 points, create countour
			plOrigin.addVertex(ptJig);
			dpjig.draw(plOrigin);
		}
		else if(pts.length()==2)
		{ 
		// only one point draw segment
			plOrigin.addVertex(ptJig);
			plOrigin.close();
			dpjig.draw(plOrigin);
		}
		else if(pts.length()>=3)
		{ 
			plOrigin.close();
			dpjig.draw(plOrigin);
		}
		
		if(pts.length()==5)
		{ 
			plDestination.addVertex(ptJig);
			dpjigDestination.draw(plOrigin);
		}
		else if(pts.length()==5)
		{ 
		// only one point draw segment
			plDestination.addVertex(ptJig);
			plDestination.close();
			dpjigDestination.draw(plDestination);
		}

//		
		return;
	}
	
// jig for slope at vertex point for triangles
	String strJigAction6 = "strJigAction6";
	if (_bOnJig && _kExecuteKey == strJigAction6)
	{ 
		Display dpjig(3);
		Display dpRemove(1);
		Vector3d vecView = getViewDirection();
		Point3d pts[] = _Map.getPoint3dArray("pts");
		Point3d ptJig = _Map.getPoint3d("_PtJig"); 
		Plane pn;
		if(_Map.hasPoint3d("ptPlane") && _Map.hasVector3d("vecPlane"))
		{ 
			pn=Plane(_Map.getPoint3d("ptPlane"), _Map.getVector3d("vecPlane"));
		}
		else
		{
			Point3d ptRef;
			ptRef.setZ(dZheight);
			pn=Plane(ptRef, _ZW);
		}
		ptJig=Line(ptJig,vecView).intersect(pn, U(0));
		PLine pl;
		for (int ipt=0;ipt<pts.length();ipt++) 
		{ 
			pl.addVertex(pts[ipt]);
		}//next ipt
		pl.close();
		// get index of closest point with the jig point
		int iIndex = -1;
		double dDist = U(10e6);
		for (int ipt=0;ipt<pts.length();ipt++) 
		{ 
			if((pts[ipt]-ptJig).length()<dDist)
			{ 
				dDist = (pts[ipt] - ptJig).length();
				iIndex = ipt;
			}
		}//next ipt
		
		for (int ipt=0;ipt<pts.length();ipt++) 
		{ 
			PLine plI;
			plI.createCircle(pts[ipt], pn.vecZ(), U(1000));
			PlaneProfile pp(pn);
			pp.joinRing(plI, _kAdd);
			if(ipt!=iIndex)
			{ 
				dpjig.draw(pp, _kDrawFilled);
			}
			else
			{ 
				dpRemove.draw(pp, _kDrawFilled);
			}
			 
		}//next ipt
		
		
		return;
	}
	
// jig to change height for a tiefpunkt at nType=2
	String strJigAction7 = "strJigAction7";
	if (_bOnJig && _kExecuteKey == strJigAction7)
	{
		Vector3d vecView = getViewDirection();
		Point3d ptRef;
		ptRef.setZ(dZheight);
		Display dpjig(1);
		Display dpRemove(1);
		Point3d pts[] = _Map.getPoint3dArray("pts");
		Point3d ptJig = _Map.getPoint3d("_PtJig"); 
		Plane pn;
		if(_Map.hasPoint3d("ptPlane") && _Map.hasVector3d("vecPlane"))
		{ 
			pn=Plane(_Map.getPoint3d("ptPlane"), _Map.getVector3d("vecPlane"));
		}
		else
		{
			Point3d ptRef;
			ptRef.setZ(dZheight);
			pn=Plane(ptRef, _ZW);
		}
		ptJig=Line(ptJig,vecView).intersect(pn, U(0));
//		ptJig = Line(ptJig, vecView).intersect(Plane(ptRef, _ZW), U(0)); 
		PLine pl;
		for (int ipt=0;ipt<pts.length();ipt++) 
		{ 
			pl.addVertex(pts[ipt]);
		}//next ipt
		if(pts.length()>=2)
		{ 
		// there are at least 2 points, create countour
			
//			pl.addVertex(ptJig);
			pl.close();
//			PlaneProfile pp(Plane(ptRef, _ZW));
			PlaneProfile pp(pn);
			pp.joinRing(pl, _kAdd);
			dpjig.draw(pp);
		}
		else if(pts.length()==1)
		{ 
		// only one point draw segment
//			pl.addVertex(ptJig);
			dpjig.draw(pl);
		}
		else if(pts.length()==0)
		{ 
			
		}
		
		// get index of closest point with the jig point
		int iIndex = -1;
		double dDist = U(10e6);
		for (int ipt=0;ipt<pts.length();ipt++) 
		{ 
			if((pts[ipt]-ptJig).length()<dDist)
			{ 
				dDist = (pts[ipt] - ptJig).length();
				iIndex = ipt;
			}
		}//next ipt
		
		
		for (int ipt=0;ipt<pts.length();ipt++) 
		{ 
			PLine plI;
			plI.createCircle(pts[ipt], _ZW, U(100));
//			PlaneProfile pp(Plane(ptRef, _ZW));
			PlaneProfile pp(pn);
			pp.joinRing(plI, _kAdd);
			if(ipt!=iIndex)
			{ 
//				dpjig.draw(pp, _kDrawFilled);
				dpjig.draw(pp);
			}
			else
			{ 
				dpRemove.draw(pp);
				dpRemove.draw(pp, _kDrawFilled);
			}
			 
		}//next ipt
		
		
		return;
	}
//End jig//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
//		dSlope.setReadOnly(_kHidden);
//		nEdgeIndex.setReadOnly(_kHidden);
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
		
	// prompt for polylines
		Entity ents[0];
		PrEntity ssEpl(T("|Select polyline or <Enter> to define the contour|"), EntPLine());
	  	if (ssEpl.go())
			ents.append(ssEpl.set());
		
		int nType=sTypes.find(sType);
		if(nType!=0)
		{ 
			
		
		
			PLine pl;
			if(ents.length()>0)
			{ 
				// select a pline
				EntPLine ePl = (EntPLine)ents[0];
				if (ePl.bIsValid())
				{
					pl = ePl.getPLine();
					Point3d pts[] = pl.vertexPoints(true);
					if(pts.length()==0)
					{ 
						reportMessage("\n"+scriptName()+" "+T("|unexpected|"));
						eraseInstance();
						return;
					}
					_Pt0 = pts[0];
					Point3d ptRef;
					ptRef.setZ(dZheight);
					_Pt0.setZ(dZheight);
					pl.transformBy(_ZW * _ZW.dotProduct(ptRef - pts[0]));
					PlaneProfile ppPl(Plane(_Pt0, _ZW));
					ppPl.joinRing(pl, _kAdd);
					// get extents of profile
					LineSeg seg = ppPl.extentInDir(_XW);
					
	//				_PtG.append(pl.vertexPoints(true));
					_PtG.append(seg.ptMid());
					
	//				_Entity.append(ePl);
				}
	//			ePl.dbErase();
	//			_Map.setEntity("entPline",ePl);
				_Entity.append(ePl);
				
			}
			else if(ents.length()==0)
			{ 
				// jigging
				{ 
					_Pt0.setZ(dZheight);
					String sStringStart = "|Select first point|";
					String sStringStart2 = "|Select point or [";
					String sStringOption = "Start/Prev/Close]";
					String sStringPrompt = T(sStringStart);
					PrPoint ssP(sStringPrompt);
					ssP.setSnapMode(true, _kOsModeEnd | _kOsModeMid);
					Map mapArgs;
					int nGoJig = -1;
					while(nGoJig!= _kNone)
					{ 
						nGoJig = ssP.goJig(strJigAction1, mapArgs); 
						if(nGoJig==_kOk)
						{ 
							
							Point3d ptLast = ssP.value();
							Vector3d vecView = getViewDirection();
							ptLast=Line(ptLast, vecView).intersect(Plane(_Pt0, _ZW), U(0));
							// add point to the list of polygonal points
							Point3d pts[0];
							if(mapArgs.hasPoint3dArray("pts"))
							{
								pts = mapArgs.getPoint3dArray("pts");
								pts.append(ptLast);
								mapArgs.setPoint3dArray("pts", pts);
								if(pts.length()>=1)
								{ 
									sStringPrompt = sStringStart2 + sStringOption;
									ssP = PrPoint(sStringPrompt, pts.last());
								}
							}
							else
							{ 
								pts.append(ptLast);
								mapArgs.setPoint3dArray("pts", pts);
								if(pts.length()>=1)
								{ 
									sStringPrompt = sStringStart2 + sStringOption;
									ssP = PrPoint(sStringPrompt, pts.last());
								}
							}
						}
						else if (nGoJig == _kKeyWord)
						{ 
						 	if (ssP.keywordIndex() >= 0)
						 	{ 
						 		if(ssP.keywordIndex()==0)
						 		{ 
						 			// Start is selected
						 			Point3d pts[0];
						 			mapArgs.setPoint3dArray("pts", pts);
						 			sStringPrompt = sStringStart;
						 			ssP = PrPoint(sStringPrompt);
						 		}
						 		else if(ssP.keywordIndex()==1)
						 		{ 
						 			// prev
						 			Point3d pts[0];
						 			pts = mapArgs.getPoint3dArray("pts");
						 			pts.removeAt(pts.length() - 1);
						 			mapArgs.setPoint3dArray("pts", pts);
						 			if(pts.length()==0)
						 			{ 
						 				sStringPrompt = sStringStart;
						 				ssP = PrPoint(sStringPrompt);
						 			}
						 			else
						 			{ 
						 				sStringPrompt = sStringStart2 + sStringOption;
										ssP = PrPoint(sStringPrompt, pts.last());
						 			}
						 		}
						 		else if(ssP.keywordIndex()==2)
						 		{ 
						 			//close
						 			nGoJig = _kNone;
						 			// save everything
						        	Point3d pts[0];
								 	pts = mapArgs.getPoint3dArray("pts");
		//						 	_PtG.append(pts);
								 	_Pt0.setZ(dZheight);
								 	Plane pn(_Pt0, _ZW);
								 	for (int ip=0;ip<pts.length();ip++) 
									{ 
										Line lnI(pts[ip], _ZW);
										Point3d ptPn = lnI.intersect(pn, U(0));
										pl.addVertex(ptPn);
									}//next ip
									PlaneProfile ppPl(Plane(_Pt0, _ZW));
									ppPl.joinRing(pl, _kAdd);
									// get extents of profile
									LineSeg seg = ppPl.extentInDir(_XW);
									
									_PtG.append(pl.vertexPoints(true));
									_PtG.append(seg.ptMid());
						 		}
						 	}
						}
						else if (nGoJig == _kCancel)
				        { 
				            eraseInstance(); // do not insert this instance
				            return; 
				        }
				        else if(nGoJig==_kNone)
				        { 
				        	// save everything
				        	Point3d pts[0];
						 	pts = mapArgs.getPoint3dArray("pts");
		//				 	_PtG.append(pts);
						 	_Pt0.setZ(dZheight);
						 	Plane pn(_Pt0, _ZW);
						 	for (int ipt=0;ipt<_PtG.length();ipt++) 
						 	{ 
						 		_PtG[ipt] = pn.closestPointTo(_PtG[ipt]);
						 		 
						 	}//next ipt
						 	
						 	for (int ip=0;ip<pts.length();ip++) 
							{ 
								Line lnI(pts[ip], _ZW);
								Point3d ptPn = lnI.intersect(pn, U(0));
								pl.addVertex(ptPn);
							}//next ip
							PlaneProfile ppPl(Plane(_Pt0, _ZW));
							ppPl.joinRing(pl, _kAdd);
							// get extents of profile
							LineSeg seg = ppPl.extentInDir(_XW);
							
							_PtG.append(pl.vertexPoints(true));
							_PtG.append(seg.ptMid());
				        }
					}
				}
	//			
				// no jig
	//			{ 
	//				// prompt selection of points, similar to plie definition, support jig
	//				Point3d pts[0];
	//				String sPromptStart = T("|Click start point|");
	//				_Pt0 = getPoint(sPromptStart);
	//				pts.append(_Pt0);
	//				int iNextPoint = true;
	//				String sPrompt = T("|Click next Point of Polygon|");
	//				int iCount = 0;
	//				while (iNextPoint && iCount < 20)
	//				{ 
	//					Point3d ptI;
	//					PrPoint ssP(sPrompt, pts[pts.length()-1]);
	//					if(ssP.go()==_kOk)
	//					{ 
	//						pts.append(ssP.value());
	//					}
	//					else
	//					{ 
	//						break;
	//					}
	//					iCount++;
	//				}
	//				// create pline in the plane of pt0 and _ZW
	//				_Pt0.setZ(dZheight);
	//				Plane pn(_Pt0, _ZW);
	//				for (int ip=0;ip<pts.length();ip++) 
	//				{ 
	//					Line lnI(pts[ip], _ZW);
	//					Point3d ptPn = lnI.intersect(pn, U(0));
	//					pl.addVertex(ptPn);
	//					 
	//				}//next ip
	//				PlaneProfile ppPl(Plane(_Pt0, _ZW));
	//				ppPl.joinRing(pl, _kAdd);
	//				// get extents of profile
	//				LineSeg seg = ppPl.extentInDir(_XW);
	//				
	//				_PtG.append(pl.vertexPoints(true));
	//				_PtG.append(seg.ptMid());
	//			}
			}
			
			_Map.setPLine("Pline", pl);
			
		// 
			int nType=sTypes.find(sType);
			if(nType==2)
			{ 
			// reverse roof geometry
				// prompt points
				// prompt for point input
				int nContinue=true;
				Point3d ptDeeps[0];
				while(nContinue)
				{ 
					PrPoint ssP(TN("|Select point|"));
					
					if (ssP.go()==_kOk) 
						ptDeeps.append(ssP.value()); // append the selected points to the list of grippoints _PtG
					else
					{ 
						nContinue=false;
					}
				}		
				_Map.setPoint3dArray("ptDeeps",ptDeeps);
			}
		}
		else if(nType==0)
		{ 
			PLine pl;
			if(ents.length()>0)
			{ 
				// select a pline
				EntPLine ePl = (EntPLine)ents[0];
				if (ePl.bIsValid())
				{
					pl = ePl.getPLine();
					Point3d pts[] = pl.vertexPoints(true);
					if(pts.length()==0)
					{ 
						reportMessage("\n"+scriptName()+" "+T("|unexpected|"));
						eraseInstance();
						return;
					}
					_Pt0 = pts[0];
					Point3d ptRef;
					ptRef.setZ(dZheight);
					_Pt0.setZ(dZheight);
					pl.transformBy(_ZW * _ZW.dotProduct(ptRef - pts[0]));
					PlaneProfile ppPl(Plane(_Pt0, _ZW));
					ppPl.joinRing(pl, _kAdd);
					// get extents of profile
					LineSeg seg = ppPl.extentInDir(_XW);
					
					_PtG.append(pl.vertexPoints(true));
					_PtG.append(seg.ptMid());
					
	//				_Entity.append(ePl);
				}
				ePl.dbErase();
			}
			else if(ents.length()==0)
			{ 
				// jigging
				{ 
					_Pt0.setZ(dZheight);
					String sStringStart = "|Select first point|";
					String sStringStart2 = "|Select point or [";
					String sStringOption = "Start/Prev/Close]";
					String sStringPrompt = T(sStringStart);
					PrPoint ssP(sStringPrompt);
					ssP.setSnapMode(true, _kOsModeEnd | _kOsModeMid);
					Map mapArgs;
					int nGoJig = -1;
					while(nGoJig!= _kNone)
					{ 
						nGoJig = ssP.goJig(strJigAction1, mapArgs); 
						if(nGoJig==_kOk)
						{ 
							
							Point3d ptLast = ssP.value();
							Vector3d vecView = getViewDirection();
							ptLast=Line(ptLast, vecView).intersect(Plane(_Pt0, _ZW), U(0));
							// add point to the list of polygonal points
							Point3d pts[0];
							if(mapArgs.hasPoint3dArray("pts"))
							{
								pts = mapArgs.getPoint3dArray("pts");
								pts.append(ptLast);
								mapArgs.setPoint3dArray("pts", pts);
								if(pts.length()>=1)
								{ 
									sStringPrompt = sStringStart2 + sStringOption;
									ssP = PrPoint(sStringPrompt, pts.last());
								}
							}
							else
							{ 
								pts.append(ptLast);
								mapArgs.setPoint3dArray("pts", pts);
								if(pts.length()>=1)
								{ 
									sStringPrompt = sStringStart2 + sStringOption;
									ssP = PrPoint(sStringPrompt, pts.last());
								}
							}
						}
						else if (nGoJig == _kKeyWord)
						{ 
						 	if (ssP.keywordIndex() >= 0)
						 	{ 
						 		if(ssP.keywordIndex()==0)
						 		{ 
						 			// Start is selected
						 			Point3d pts[0];
						 			mapArgs.setPoint3dArray("pts", pts);
						 			sStringPrompt = sStringStart;
						 			ssP = PrPoint(sStringPrompt);
						 		}
						 		else if(ssP.keywordIndex()==1)
						 		{ 
						 			// prev
						 			Point3d pts[0];
						 			pts = mapArgs.getPoint3dArray("pts");
						 			pts.removeAt(pts.length() - 1);
						 			mapArgs.setPoint3dArray("pts", pts);
						 			if(pts.length()==0)
						 			{ 
						 				sStringPrompt = sStringStart;
						 				ssP = PrPoint(sStringPrompt);
						 			}
						 			else
						 			{ 
						 				sStringPrompt = sStringStart2 + sStringOption;
										ssP = PrPoint(sStringPrompt, pts.last());
						 			}
						 		}
						 		else if(ssP.keywordIndex()==2)
						 		{ 
						 			//close
						 			nGoJig = _kNone;
						 			// save everything
						        	Point3d pts[0];
								 	pts = mapArgs.getPoint3dArray("pts");
		//						 	_PtG.append(pts);
								 	_Pt0.setZ(dZheight);
								 	Plane pn(_Pt0, _ZW);
								 	for (int ip=0;ip<pts.length();ip++) 
									{ 
										Line lnI(pts[ip], _ZW);
										Point3d ptPn = lnI.intersect(pn, U(0));
										pl.addVertex(ptPn);
									}//next ip
									PlaneProfile ppPl(Plane(_Pt0, _ZW));
									ppPl.joinRing(pl, _kAdd);
									// get extents of profile
									LineSeg seg = ppPl.extentInDir(_XW);
									
									_PtG.append(pl.vertexPoints(true));
									_PtG.append(seg.ptMid());
						 		}
						 	}
						}
						else if (nGoJig == _kCancel)
				        { 
				            eraseInstance(); // do not insert this instance
				            return; 
				        }
				        else if(nGoJig==_kNone)
				        { 
				        	// save everything
				        	Point3d pts[0];
						 	pts = mapArgs.getPoint3dArray("pts");
		//				 	_PtG.append(pts);
						 	_Pt0.setZ(dZheight);
						 	Plane pn(_Pt0, _ZW);
						 	for (int ipt=0;ipt<_PtG.length();ipt++) 
						 	{ 
						 		_PtG[ipt] = pn.closestPointTo(_PtG[ipt]);
						 		 
						 	}//next ipt
						 	
						 	for (int ip=0;ip<pts.length();ip++) 
							{ 
								Line lnI(pts[ip], _ZW);
								Point3d ptPn = lnI.intersect(pn, U(0));
								pl.addVertex(ptPn);
							}//next ip
							PlaneProfile ppPl(Plane(_Pt0, _ZW));
							ppPl.joinRing(pl, _kAdd);
							// get extents of profile
							LineSeg seg = ppPl.extentInDir(_XW);
							
							_PtG.append(pl.vertexPoints(true));
							_PtG.append(seg.ptMid());
				        }
					}
				}
	//			
	
				
				// no jig
	//			{ 
	//				// prompt selection of points, similar to plie definition, support jig
	//				Point3d pts[0];
	//				String sPromptStart = T("|Click start point|");
	//				_Pt0 = getPoint(sPromptStart);
	//				pts.append(_Pt0);
	//				int iNextPoint = true;
	//				String sPrompt = T("|Click next Point of Polygon|");
	//				int iCount = 0;
	//				while (iNextPoint && iCount < 20)
	//				{ 
	//					Point3d ptI;
	//					PrPoint ssP(sPrompt, pts[pts.length()-1]);
	//					if(ssP.go()==_kOk)
	//					{ 
	//						pts.append(ssP.value());
	//					}
	//					else
	//					{ 
	//						break;
	//					}
	//					iCount++;
	//				}
	//				// create pline in the plane of pt0 and _ZW
	//				_Pt0.setZ(dZheight);
	//				Plane pn(_Pt0, _ZW);
	//				for (int ip=0;ip<pts.length();ip++) 
	//				{ 
	//					Line lnI(pts[ip], _ZW);
	//					Point3d ptPn = lnI.intersect(pn, U(0));
	//					pl.addVertex(ptPn);
	//					 
	//				}//next ip
	//				PlaneProfile ppPl(Plane(_Pt0, _ZW));
	//				ppPl.joinRing(pl, _kAdd);
	//				// get extents of profile
	//				LineSeg seg = ppPl.extentInDir(_XW);
	//				
	//				_PtG.append(pl.vertexPoints(true));
	//				_PtG.append(seg.ptMid());
	//			}
			}
			
			_Map.setPLine("Pline", pl);
		}
		return;
	}	
// end on insert	__________________//endregion

//if(_Map.getInt("isDummy"))
//{ 
//	eraseInstance();
//	return;
//}

//if(_Map.getInt("iCleanupDummy"))
//{ 
//	Entity entsTsl[]=Group().collectEntities(true, TslInst(), _kModelSpace);
//	for (int itsl=entsTsl.length()-1; itsl>=0 ; itsl--) 
//	{ 
//		TslInst tsl = (TslInst)entsTsl[itsl];
//		if(tsl.map().getInt("isDummy"))
//		{ 
//			tsl.dbErase();
//		}
//	}//next itsl
//}

int nType=sTypes.find(sType);
if(nType!=0)
{ 
		
	
	int nMode=_Map.getInt("Mode");
	if(nMode==1)
	{ 
	// section mode
		Map mapDisplayStyles=mapSetting.getMap("Darstellungsstil[]");
		
		Map mapDisplayStyle;
		for (int i=0;i<mapDisplayStyles.length();i++) 
		{ 
			Map mapDisplayStyleI = mapDisplayStyles.getMap(i);
			if(mapDisplayStyleI.hasString("Name") && mapDisplayStyles.keyAt(i).makeLower() == "darstellungsstil")
			{ 
				String sDisplayStyleName=mapDisplayStyleI.getString("Name");
				if(sDisplayStyleName==sDisplayStyle)
				{ 
					mapDisplayStyle = mapDisplayStyleI;
					break;
				}
			}
		}//next i
		Map mapSectionStyle=mapDisplayStyle.getMap("Section");
		String s="LineType";
		if(mapSectionStyle.hasString(s))
		{ 
			sLineTypeSection.set(mapSectionStyle.getString(s));
		}
		s="LineScale";
		if(mapSectionStyle.hasDouble(s))
		{ 
			dLineScaleSection.set(mapSectionStyle.getDouble(s));
		}
		s="Color";
		if(mapSectionStyle.hasInt(s))
		{ 
			nLineColorSection.set(mapSectionStyle.getInt(s));
		}
		s="DimStyle";
		if(mapSectionStyle.hasString(s))
		{ 
			sDimStyleSection.set(mapSectionStyle.getString(s));
		}
		// get xml file
	
	//	sLineTypeSection.setReadOnly(false);
		dLineThicknessSection.setReadOnly(_kHidden);
	//	dLineScaleSection.setReadOnly(false);
	//	nLineColorSection.setReadOnly(false);
	//	sLabelSection.setReadOnly(false);
	//	sDimStyleSection.setReadOnly(false);
		TslInst tslRef;
		if(_Entity.length()==1)
		{ 
			TslInst tsl=(TslInst)_Entity[0];
			if(tsl.bIsValid())
				tslRef=tsl;
		}
		if(!tslRef.bIsValid())
		{ 
			reportMessage("\n"+scriptName()+" "+T("|No reference TSL found|"));
			eraseInstance();
			return;
		}
		setDependencyOnEntity(_Entity[0]);
		Body bd=tslRef.map().getBody("bd");
		if(bd.volume()<pow(dEps,3))
		{ 
			reportMessage("\n"+scriptName()+" "+T("|No volume found|"));
			eraseInstance();
			return;
		}
		
		if(_PtG.length()!=2)
		{ 
		// 
			reportMessage("\n"+scriptName()+" "+T("|2 Grip points needed for the definition of the section cut|"));
			eraseInstance();
			return;
		}
		sType.setReadOnly(_kHidden);
		dZheight.setReadOnly(_kHidden);
		dHeight.setReadOnly(_kHidden);
		dSlope.setReadOnly(_kHidden);
		dSlopeGrad.setReadOnly(_kHidden);
		sDisplayStyle.setReadOnly(_kHidden);
		sLegend.setReadOnly(_kHidden);
		sNumber.setReadOnly(_kHidden);
		sName.setReadOnly(_kHidden);
		sMaterial1.setReadOnly(_kHidden);
		sMaterial2.setReadOnly(_kHidden);
		sLineType.setReadOnly(_kHidden);
		dLineThickness.setReadOnly(_kHidden);
		dLineScale.setReadOnly(_kHidden);
		nLineColor.setReadOnly(_kHidden);
		sHatchSolidVisibility.setReadOnly(_kHidden);
		nHatchSolidColor.setReadOnly(_kHidden);
		nHatchSolidTransparency.setReadOnly(_kHidden);
		sHatchPatternVisibility.setReadOnly(_kHidden);
		sHatchPattern.setReadOnly(_kHidden);
	//	sLineWeight.setReadOnly(_kHidden);
		nHatchPatternColor.setReadOnly(_kHidden);
		dHatchPatternAngle.setReadOnly(_kHidden);
		dHatchPatternScale.setReadOnly(_kHidden);
		nHatchPatternTransparency.setReadOnly(_kHidden);
		if(_kNameLastChangedProp=="_PtG0" || _kNameLastChangedProp=="_PtG1")
		{ 
			_Map.setPoint3d("pt1",_PtG[0],_kAbsolute);
			_Map.setPoint3d("pt2",_PtG[1],_kAbsolute);
		}
		if(_kNameLastChangedProp=="_Pt0")
		{ 
			_PtG[0]=_Map.getPoint3d("pt1");
			_PtG[1]=_Map.getPoint3d("pt2");
		}
		_Map.setPoint3d("pt1",_PtG[0],_kAbsolute);
		_Map.setPoint3d("pt2",_PtG[1],_kAbsolute);
		Vector3d vecDir=_PtG[1]-_PtG[0];vecDir.normalize();
		Vector3d vecNorm=-_ZW.crossProduct(vecDir);vecNorm.normalize();
		Plane pnCut(_PtG[0],vecNorm);
		PlaneProfile pp = bd.getSlice(pnCut);
		LineSeg lSeg(_PtG[0],_PtG[1]);
		Display dpSection(3);
		
		String _sLineType;
		int iLineType = sLineTypes.find(sLineTypeSection);
		if (iLineType > -1)
		{
			_sLineType = sLineTypeSection;
		}
		
		int iLineWeight = sLineWeights.find(sLineWeight);
		int _iLineWeight = -1;
		if(iLineWeight>0)
		{ 
			_iLineWeight=nLineWeights[iLineWeight];
		}
		
		_ThisInst.setLineWeight(_iLineWeight);
		
		//int _iContourColor = mapContour.getInt("Color");
		int _iSectionColor = 0;
		if(nLineColorSection>-3)
		{
			_iSectionColor=nLineColorSection;
		}
		
		Display dpSectionCutLine(nLineColorSection);
		dpSectionCutLine.color(_iSectionColor);
		if(_LineTypes.find(sLineTypeSection)>-1 && sLineTypeSection!="Continuous")
		{ 
		//	double _dLineScale = mapContour.getDouble("LineScale");
			double _dLineScaleSection=1;
			if(dLineScaleSection>0)
			{ 
				_dLineScaleSection= dLineScaleSection;
			}
			if(_dLineScaleSection>0)
			{
				dpSectionCutLine.lineType(sLineTypeSection,dLineScaleSection);
			}
			else
			{
				dpSectionCutLine.lineType(sLineTypeSection);
			}
		//	dpPlane.draw(ppPlane);
		}
		
	// cretate dependency to all section tsls attached to same insulation
	// but only the first section will set the label
	//	String sLabelSections[]={ "A","B","C","D","E","F","G","H","I","J","K",
	//		"L","M","N","O","P","Q","R","S","T","U"};
	//	
	//	TslInst tslSections[0];
	//	Entity entsTsl[]=Group().collectEntities(true,TslInst(),_kModelSpace);
	//	for (int i=0;i<entsTsl.length();i++) 
	//	{ 
	//		TslInst tslI=(TslInst) entsTsl[i];
	//		if (!tslI.bIsValid())continue;
	//		if(tslI.scriptName()!="TaperedInsulation")continue;
	//		if(tslI.map().getInt("Mode")!=1)continue;
	//		Entity entsTslI[]=tslI.entity();
	//		if (entsTslI.length() != 1)continue;
	//		if(_Entity[0]!=entsTslI[0])continue;
	//		
	//		if(tslSections.find(tslI)<0)
	//			tslSections.append(tslI);
	//	}//next i
	//	
	//	
	//// order alphabetically
	//	for (int i=0;i<tslSections.length();i++) 
	//		for (int j=0;j<tslSections.length()-1;j++) 
	//			if (tslSections[j].handle()>tslSections[j+1].handle())
	//				tslSections.swap(j, j + 1);
	//		
	//	if()
		
		dpSection.color(_iSectionColor);
		dpSectionCutLine.draw(lSeg);
		
		// draw text
		
		Display dpError(1);
		dpError.textHeight(U(100));
		Vector3d vecXsec=_PtG[1]-_PtG[0];vecXsec.normalize();
		Vector3d vecYsec=_ZW.crossProduct(vecXsec);vecYsec.normalize();
		Vector3d vecZsec=_ZW;
		_Pt0 = Line(pp.ptMid(), vecYsec).closestPointTo(_Pt0);
		if(pp.area()<pow(dEps,2))
		{ 
			// draw text
			dpError.draw("No Section found",_Pt0,_XW,_YW,0,0,_kDeviceX);
			return;
		}
		
		CoordSys csTransform;
		csTransform.setToAlignCoordSys(pp.ptMid(),pp.coordSys().vecX(),pp.coordSys().vecY(),pp.coordSys().vecZ(),
		_Pt0,vecXsec,vecYsec,vecZsec);
		pp.transformBy(csTransform);
	//	dpSection.color(3);
		dpSection.draw(pp);
		// draw Label
		dpSectionCutLine.textHeight(U(300));
		s="TextHeight";
		if(mapSectionStyle.hasDouble(s))
		{ 
			dpSectionCutLine.textHeight(mapSectionStyle.getDouble(s));
		}
		dpSectionCutLine.draw(sLabelSection,_PtG[0],vecXsec,vecYsec,-1,0);
	// draw a triangle that shows the direction of cut
		PLine plTriangle;
		plTriangle.addVertex(_PtG[0]);
		double dWidthTriang=U(200);
		double dHeightTriang=U(400);
		s="Pfeile";
		if(mapSectionStyle.hasDouble(s))
		{ 
			dHeightTriang=mapSectionStyle.getDouble(s);
			dWidthTriang = .5 * dHeightTriang;
		}
		
		plTriangle.addVertex(_PtG[0]+_XW*dWidthTriang-_YW*dHeightTriang);
		plTriangle.addVertex(_PtG[0]-_XW*dWidthTriang-_YW*dHeightTriang);
		plTriangle.close();
		
		CoordSys csTransformTriang;
		csTransformTriang.setToAlignCoordSys(_PtG[0],_XW,_YW,_ZW,
		_PtG[0]+vecDir*U(200)-vecYsec*U(100),vecXsec,vecYsec,vecZsec);
		plTriangle.transformBy(csTransformTriang);
		dpSectionCutLine.lineType("Continuous");
		dpSectionCutLine.draw(plTriangle);
		// label at section
		{ 
		// get extents of profile
			LineSeg seg = pp.extentInDir(vecXsec);
			double dX = abs(vecXsec.dotProduct(seg.ptStart()-seg.ptEnd()));
			double dY = abs(vecYsec.dotProduct(seg.ptStart()-seg.ptEnd()));
			Point3d ptTxt=seg.ptMid()+.5*dY*vecYsec;
			dpSectionCutLine.draw(sLabelSection,ptTxt,vecXsec,vecYsec,0,1.5);
		}
	// create dimensions
		Display dpDim(7);
	//	String sStyle = "BF 2.0";
	//	int nStyle=_DimStyles.find(sStyle);
		int nStyle=_DimStyles.find(sDimStyleSection);
		if(nStyle>-1)
			dpDim.dimStyle(_DimStyles[nStyle]);
	// get extents of profile
		LineSeg seg = pp.extentInDir(vecXsec);
		DimLine dl(seg.ptStart()-vecYsec*U(300),vecXsec,vecYsec);
		Dim dim(dl,seg.ptStart(),seg.ptEnd());
		dpDim.draw(dim);
		
		// get lowest point
		Point3d ptLow,ptLow2;ptLow+=vecYsec*U(10e8);ptLow2=ptLow;
		PLine pls[] = pp.allRings(true, false);
		for (int ipl=0;ipl<pls.length();ipl++) 
		{ 
			PLine plI= pls[ipl];
			Point3d ptsi[]=plI.vertexPoints(true);
			for (int ipt=0;ipt<ptsi.length();ipt++) 
			{ 
				if(vecYsec.dotProduct(ptsi[ipt]-ptLow)<0)
					ptLow=ptsi[ipt];
			}//next ipt
			for (int ipt=0;ipt<ptsi.length();ipt++) 
			{ 
				if(vecYsec.dotProduct(ptsi[ipt]-ptLow2)<0
				&& (ptsi[ipt]-ptLow).length()>dEps 
				&& vecYsec.dotProduct(ptsi[ipt]-ptLow)>dEps)
					ptLow2=ptsi[ipt];
			}//next ipt
			 
		}//next ipl
		DimLine dl1(seg.ptStart()-vecXsec*U(300),vecYsec,-vecXsec);
		Dim dim1(dl1,ptLow,ptLow2);
		dpDim.draw(dim1);
		
		// largest
		DimLine dl2(seg.ptStart()-vecXsec*U(700),vecYsec,-vecXsec);
		Dim dim2(dl2,seg.ptStart(),seg.ptEnd());
		dpDim.draw(dim2);
		return;
	}
	else if(nMode==2)
	{ 
	// create table, with area and volume
	// section mode
		TslInst tslRef;
		if(_Entity.length()==1)
		{ 
			TslInst tsl=(TslInst)_Entity[0];
			if(tsl.bIsValid())
				tslRef=tsl;
		}
		if(!tslRef.bIsValid())
		{ 
			reportMessage("\n"+scriptName()+" "+T("|No reference TSL found|"));
			eraseInstance();
			return;
		}
		setDependencyOnEntity(_Entity[0]);
		Body bd=tslRef.map().getBody("bd");
		if(bd.volume()<pow(dEps,3))
		{ 
			reportMessage("\n"+scriptName()+" "+T("|No volume found|"));
			eraseInstance();
			return;
		}
		sType.setReadOnly(_kHidden);
		dZheight.setReadOnly(_kHidden);
		dHeight.setReadOnly(_kHidden);
		dSlope.setReadOnly(_kHidden);
		dSlopeGrad.setReadOnly(_kHidden);
		sDisplayStyle.setReadOnly(_kHidden);
		sLegend.setReadOnly(_kHidden);
		sNumber.setReadOnly(_kHidden);
		sName.setReadOnly(_kHidden);
		sMaterial1.setReadOnly(_kHidden);
		sMaterial2.setReadOnly(_kHidden);
		sLineType.setReadOnly(_kHidden);
		dLineThickness.setReadOnly(_kHidden);
		dLineScale.setReadOnly(_kHidden);
		nLineColor.setReadOnly(_kHidden);
		sHatchSolidVisibility.setReadOnly(_kHidden);
		nHatchSolidColor.setReadOnly(_kHidden);
		nHatchSolidTransparency.setReadOnly(_kHidden);
		sHatchPatternVisibility.setReadOnly(_kHidden);
		sHatchPattern.setReadOnly(_kHidden);
		sLineWeight.setReadOnly(_kHidden);
		nHatchPatternColor.setReadOnly(_kHidden);
		dHatchPatternAngle.setReadOnly(_kHidden);
		dHatchPatternScale.setReadOnly(_kHidden);
		nHatchPatternTransparency.setReadOnly(_kHidden);
		
		PlaneProfile pp=bd.shadowProfile(Plane(_Pt0,_ZW));
		double dArea=pp.area()/10e5;
		String sArea;sArea.format("%.2f", dArea);
		double dVol=bd.volume()/10e8;// in m
		String sVol;sVol.format("%.2f", dVol);
		
		PLine pls[]=pp.allRings(true,false);
		PLine plInsulation;
		if(pls.length()>0)
		{ 
			plInsulation=pls[0];
		}
		double dLength = plInsulation.length()/1000;
		String sLength;
		sLength.format("%.2f", dLength);
		
		String sCols[]={ "Typ","Grundfläche [m2]","Volumen [m3]","Umfang [m]"};
		String sVals[]={ sType,sArea,sVol,sLength};
		double dLengthMaxes[]={0,0,0,0};
		double dHeightMaxes[]={0,0,0,0};
		Display dp(2);
		String sStyle = "BF 2.0";
		int nStyle=_DimStyles.find(sStyle);
		if(nStyle>-1)
			dp.dimStyle(sStyle,U(40));
		else
		{
			sStyle=_DimStyles[0];
			dp.dimStyle(sStyle,U(40));
		}
		
	//	dLengthMaxes[0]=dp.textLengthForStyle(sCols[0], sStyle);
	//	dHeightMaxes[0]=dp.textHeightForStyle(sCols[0], sStyle);
	//	dLengthMaxes[1]=dp.textLengthForStyle(sCols[1], sStyle);
	//	dHeightMaxes[1]=dp.textHeightForStyle(sCols[1], sStyle);
	//	dLengthMaxes[2]=dp.textLengthForStyle(sCols[2], sStyle);
	//	dHeightMaxes[2]=dp.textHeightForStyle(sCols[2], sStyle);
		for (int i=0;i<sCols.length();i++) 
		{ 
			dLengthMaxes[i]=dp.textLengthForStyle(sCols[i],sStyle);
			dHeightMaxes[i]=dp.textHeightForStyle(sCols[i],sStyle);
		}//next i
		
		
		for (int i=0;i<sVals.length();i++) 
		{ 
			double dLengthMaxI=dp.textLengthForStyle(sVals[i],sStyle);
			if(dLengthMaxI>dLengthMaxes[i])
				dLengthMaxes[i]=dLengthMaxI;
			double dHeightMaxI=dp.textHeightForStyle(sVals[i],sStyle);
			if(dHeightMaxI>dHeightMaxes[i])
				dHeightMaxes[i]=dHeightMaxI;
		}//next i
		
		double dLengthMaxTot;
		for (int i=0;i<dLengthMaxes.length();i++) 
		{ 
			dLengthMaxTot+= dLengthMaxes[i]; 
		}//next i
		
		double dHeightMax;
		int nDefinitions=1;
		for (int i=0;i<dHeightMaxes.length();i++) 
		{ 
			if(dHeightMaxes[i]>dHeightMax)
				dHeightMax=dHeightMaxes[i];
		}//next i
		
		double dTextGapFactor=1.8;
		Point3d ptGripDefault=_Pt0+_XW*(dLengthMaxTot+4*dHeightMax)
			-_YW*dTextGapFactor*(nDefinitions+1)*dHeightMax;
		Point3d	ptGripDefaultMap;
		if(_Map.hasDouble("TextScale"))
		{ 
			double dScaleMap=_Map.getDouble("TextScale");
			ptGripDefaultMap=_Pt0+_XW*(dLengthMaxTot+4*dHeightMax)*dScaleMap
				-_YW*dTextGapFactor*(nDefinitions+1)*dHeightMax*dScaleMap;
		}
		Vector3d vecLine=ptGripDefault-_Pt0;
		Vector3d vecDefault = vecLine;
		vecLine.normalize();
		Line lnGrip(_Pt0,vecLine);
	
		if(_PtG.length()==0)
		{ 
			_PtG.append(ptGripDefault);
		}
		if(_kNameLastChangedProp=="_PtG0")
		{
			_PtG[0]=lnGrip.closestPointTo(_PtG[0]);
		}
		else if(_Map.hasDouble("TextScale"))
		{ 
			_PtG[0]=ptGripDefaultMap;
		}
		double dScale=vecLine.dotProduct(_PtG[0]-_Pt0)/(vecDefault.length());
		double dLengthCol=(dLengthMaxes[0]+dHeightMax)*dScale;
		double dLengthCol1=(dLengthMaxes[1]+dHeightMax)*dScale;
		double dLengthCol2=(dLengthMaxes[2]+dHeightMax)*dScale;
		double dLengthCol3=(dLengthMaxes[3]+dHeightMax)*dScale;
		
		double dTextGapX=.5*(dHeightMax*dScale);
		double dTextGapX1=.5*(dHeightMax*dScale);
		double dTextGapX2=.5*(dHeightMax*dScale);
		double dTextGapX3=.5*(dHeightMax*dScale);
		
		dp.textHeight(dHeightMax*dScale);
		_Map.setDouble("TextScale",dScale);
		double dHeightRow = dTextGapFactor*dHeightMax * dScale;
		
		LineSeg lSeg(_Pt0,_Pt0+_XW*(dLengthCol+dLengthCol1+dLengthCol2+dLengthCol3));
		dp.draw(lSeg);
		lSeg=LineSeg(_Pt0,_Pt0-_YW*dHeightRow*(nDefinitions+1));
		dp.draw(lSeg);
		
		lSeg=LineSeg(_Pt0+_XW*dLengthCol,_Pt0+_XW*dLengthCol-_YW*dHeightRow*(nDefinitions+1));
		dp.draw(lSeg);
		lSeg=LineSeg(_Pt0+_XW*(dLengthCol+dLengthCol1),
			_Pt0+_XW*(dLengthCol+dLengthCol1)-_YW*dHeightRow*(nDefinitions+1));
		
		lSeg=LineSeg(_Pt0+_XW*(dLengthCol+dLengthCol1),_Pt0+_XW*(dLengthCol+dLengthCol1)-_YW*dHeightRow*(nDefinitions+1));
		dp.draw(lSeg);
		lSeg=LineSeg(_Pt0+_XW*(dLengthCol+dLengthCol1+dLengthCol2),
			_Pt0+_XW*(dLengthCol+dLengthCol1+dLengthCol2)-_YW*dHeightRow*(nDefinitions+1));
		dp.draw(lSeg);
		
		lSeg=LineSeg(_Pt0+_XW*(dLengthCol+dLengthCol1+dLengthCol2),_Pt0+_XW*(dLengthCol+dLengthCol1+dLengthCol2)-_YW*dHeightRow*(nDefinitions+1));
		dp.draw(lSeg);
		lSeg=LineSeg(_Pt0+_XW*(dLengthCol+dLengthCol1+dLengthCol2+dLengthCol3),
			_Pt0+_XW*(dLengthCol+dLengthCol1+dLengthCol2+dLengthCol3)-_YW*dHeightRow*(nDefinitions+1));
		dp.draw(lSeg);
		
		Point3d ptText=_Pt0-_YW*.5*dHeightRow;
		dp.draw(sCols[0], ptText+_XW*dTextGapX, _XW, _YW, 1, 0);
		
		Point3d ptText1=_Pt0+_XW*(dLengthCol)-_YW*.5*dHeightRow;
		dp.draw(sCols[1], ptText1+_XW*dTextGapX1, _XW, _YW, 1, 0);
		
		Point3d ptText2=_Pt0+_XW*(dLengthCol+dLengthCol1)-_YW*.5*dHeightRow;
		dp.draw(sCols[2], ptText2+_XW*dTextGapX2, _XW, _YW, 1, 0);
		
		Point3d ptText3=_Pt0+_XW*(dLengthCol+dLengthCol1+dLengthCol2)-_YW*.5*dHeightRow;
		dp.draw(sCols[3], ptText3+_XW*dTextGapX3, _XW, _YW, 1, 0);
		
		LineSeg _lSeg = LineSeg(_Pt0,_Pt0+_XW*(dLengthCol+dLengthCol1+dLengthCol2+dLengthCol3));
		_lSeg.transformBy(-_YW*dHeightRow);
		dp.draw(_lSeg);
		
		ptText1+=_XW*.5*dLengthCol1;
		ptText2+=_XW*.5*dLengthCol2;
		ptText3+=_XW*.5*dLengthCol3;
		
		ptText -= _YW * dHeightRow;
		ptText.vis(1);
		sType.set(tslRef.propString(0));
		dp.draw(sType, ptText+_XW*dTextGapX, _XW, _YW, 1, 0);
		ptText1 -= _YW * dHeightRow;
		dp.draw(sArea, ptText1, _XW, _YW, 0, 0); 
		
		ptText2 -= _YW * dHeightRow;
		dp.draw(sVol, ptText2, _XW, _YW, 0, 0); 
		
		ptText3 -= _YW * dHeightRow;
		dp.draw(sLength, ptText3, _XW, _YW, 0, 0); 
		
		_lSeg.transformBy(-_YW*dHeightRow);
		dp.draw(_lSeg);
		return;
	}
	
	// free definition; roof type; reverse roof type
	int nType=sTypes.find(sType);
	//nEdgeIndex.setReadOnly(_kHidden);
	int iLegend = sNoYes.find(sLegend);
	//int iDisplayStyle = sDisplayStyles.find(sDisplayStyle);
	//if(iDisplayStyle<0 && sDisplayStyles.length()>0)
	//	sDisplayStyle.set(sDisplayStyles[0]);
	//region validation
		if(!_Map.hasPLine("Pline"))	
		{ 
			reportMessage("\n"+scriptName()+" "+T("|one pline is needed|"));
			eraseInstance();
			return;
		}
	//End validation//endregion 
	
	if(_kNameLastChangedProp==sZheightName)
	{ 
		// pt0 modified, update zheight
		_Pt0.setZ(dZheight);
	}
	Plane pn(_Pt0, _ZW);
	Plane pnHor(_Pt0, _ZW);
	int iAligned, iAlignedEntity;
	
	EntPLine ePl;
	int nFoundFirst;
	if (_Entity.length()>=1)
	{ 
		for (int i=0;i<_Entity.length();i++) 
		{ 
			EntPLine epl=(EntPLine)_Entity[i];
			if(epl.bIsValid() && !nFoundFirst)
			{ 
			// first fund pline is the contour Pline
				ePl=epl;
				nFoundFirst=true;
			}
			if(ePl.bIsValid())
				setDependencyOnEntity(_Entity[i]);
		}//next i
		
		
		EntPLine epl=(EntPLine)_Entity[0];
		if(epl.bIsValid())
		{ 
			ePl=epl;
		}
		if(ePl.bIsValid())
			setDependencyOnEntity(_Entity[0]);
	}
	
	if(_Map.hasPoint3d("ptPlane") && _Map.hasVector3d("vecPlane"))
	{ 
		iAligned = true;
		pn=Plane(_Map.getPoint3d("ptPlane"), _Map.getVector3d("vecPlane"));
		dZheight.setReadOnly(_kReadOnly);
	}
	if(_Map.hasEntity("TslAlign") && _Map.getEntity("TslAlign").bIsValid())
	{ 
	//	if(_Map.hasInt("isDummy"))
	//	{ 
	//		reportMessage("\n"+scriptName()+" "+T("|Dummy|"));
	//		reportMessage("\n"+scriptName()+" "+T("|enters|"));
	//		
	//		
	//	}
		iAlignedEntity = true;
		Entity entTsl = _Map.getEntity("TslAlign");
		TslInst tsl = (TslInst)entTsl;
		if(_Entity.find(tsl)<0)
		{ 
			_Entity.append(tsl);
		}
		setDependencyOnEntity(tsl);
		pn=Plane(tsl.map().getPoint3d("ptPlaneTop"), tsl.map().getVector3d("vecPlaneTop"));
		dZheight.setReadOnly(_kReadOnly);
	}
	else
	{ 
		dZheight.setReadOnly(false);
		if(_bOnDbCreated)
		{ 
			// ondbcreated zheight has priority
			_Pt0.setZ(dZheight);
			pn=Plane(_Pt0, _ZW);
		}
	}
	
	// HSB-15668: check if this instance is controlled by RUB-Stellfüße
	if(_Map.hasInt("StellfüßeFlag") && _Map.hasEntity("Stellfüße"))
	{ 
		if(_Map.getInt("StellfüßeFlag") && _Map.getEntity("Stellfüße").bIsValid())
		{ 
		// 
			dZheight.setReadOnly(_kReadOnly);
			dHeight.setReadOnly(_kReadOnly);
			dSlope.setReadOnly(_kReadOnly);
		// 
			Entity entTsl = _Map.getEntity("Stellfüße");
			if(_Entity.find(entTsl)<0)
			{ 
				_Entity.append(entTsl);
			}
			setDependencyOnEntity(entTsl);
		}
		else if(!_Map.getEntity("Stellfüße").bIsValid())
		{ 
			eraseInstance();
			return;
		}
	}
	
	PLine pl = _Map.getPLine("Pline");
	
	if(ePl.bIsValid())
	{ 
		pl=ePl.getPLine();
		
	}
	//initialize grippoints
	if(!ePl.bIsValid())
	{ 
		if(_PtG.length()==0)
		{ 
		// only once
			Point3d pts[] = pl.vertexPoints(true);
			for (int ip=0;ip<pts.length();ip++) 
			{ 
				_PtG.append(pts[ip]);
			}//next ip
			Point3d ptTxt;
			ptTxt.setToAverage(_PtG);
			_PtG.append(ptTxt);
		}
	}
	// Cleanup grippoints at the same location
	if(!ePl.bIsValid())
	{ 
		Point3d ptUniqs[0];
		for (int ipt=0;ipt<_PtG.length()-1;ipt++) 
		{ 
			Point3d ptgI=_PtG[ipt];
			int iUnique=true;
			for (int jpt=0;jpt<ptUniqs.length();jpt++) 
			{ 
				Point3d ptJ = ptUniqs[jpt]; 
				
				if((ptgI-ptJ).length()<dEps)
				{ 
					iUnique = false;
					break;
				}
			}//next jpt
			if (iUnique)ptUniqs.append(ptgI);
		}//next ipt
		Point3d ptText=_PtG[_PtG.length()-1];
		_PtG.setLength(0);
		_PtG.append(ptUniqs);
		_PtG.append(ptText);
	}
	
	if(_PtG.length()>1 && !ePl.bIsValid())
	{ 
		pl = PLine();
		for (int i=0;i<_PtG.length()-1;i++) 
		{ 
	//		_PtG[i]=pn.closestPointTo(_PtG[i]); 
			_PtG[i] = Line(_PtG[i], _ZW).intersect(pn, U(0));
			pl.addVertex(_PtG[i]);
		}//next i
	//	_PtG[_PtG.length() - 1] = pn.closestPointTo(_PtG[_PtG.length() - 1]);
		_PtG[_PtG.length() - 1] = Line(_PtG[_PtG.length() - 1], _ZW).intersect(pn, U(0));
	}
	
	
	Point3d pts[] = pl.vertexPoints(true);
	if(pts.length()<3)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|Polyline must be a closed Polygone|"));
		eraseInstance();
		return;
	}
	
	//nEdgeIndexs.setLength(0);
	//for (int i=0;i<pts.length();i++) 
	//{ 
	//	nEdgeIndexs.append(i + 1);
	//}//next i
	//int iIndexEdgeIndex = nEdgeIndexs.find(nEdgeIndex);
	//if(iIndexEdgeIndex>-1)
	//{
	//	nEdgeIndex=PropInt (0, nEdgeIndexs, sEdgeIndexName,iIndexEdgeIndex);
	//}
	//else
	//{ 
	//	nEdgeIndex=PropInt (0, nEdgeIndexs, sEdgeIndexName,0);
	//	nEdgeIndex.set(nEdgeIndexs[0]);
	//}
	
	//pl.transformBy(_ZW *_ZW.dotProduct(_Pt0-pts[0]));
	pl.projectPointsToPlane(pn, _ZW);
	_Pt0.vis(3);
	Display dpSpacePlane(3);
	Display dpSpaceVolume(3);
	//Display dpSpaceVolumeHidden(7);
	//dpSpaceVolumeHidden.transparency(100);
	// dont hide volume in top view
	//dpSpaceVolume.addHideDirection(_ZW);
	//dpSpaceVolume.addHideDirection(-_ZW);
	Display dpText(2);
	if(!pl.isClosed())
		pl.close();
	//Plane pn(_Pt0, _ZW);
	PlaneProfile ppSpace(pn);
	ppSpace.joinRing(pl,_kAdd);
	
	PlaneProfile ppSpaceHor(pnHor),ppSpaceHorReal(pnHor);
	pl.vis(5);
	PLine plReal;
	Body bdSpace;
	int iAlignFaces = _Map.getInt("AlignFaces");
	//return;
	if(_bOnDbCreated)
	{ 
	// check on dbcreated the slope property
		if(dSlopeGrad==0)
		{ 
		// dSlope has been inserted in %
			dSlopeGrad.set(atan(0.01*dSlope));
		}
		else if(dSlope==0)
		{ 
		// dSlopeGrad has been inserted in grad
			dSlope.set(100*tan(dSlopeGrad));
		}
		else if(dSlope!=0 && dSlopeGrad!=0)
		{ 
		// bot defined not Ok
			reportMessage("\n"+scriptName()+" "+T("|the value from % slope will be used|"));
			dSlopeGrad.set(atan(0.01*dSlope));
		}
	}
	
	if(_kNameLastChangedProp==sSlopeName)
	{ 
	// in % was modified
		// calc in degree
		dSlopeGrad.set(atan(0.01*dSlope));
	}
	else if(_kNameLastChangedProp==sSlopeGradName)
	{ 
		dSlope.set(100*tan(dSlopeGrad));
	}
	
	if(nType==0)
	{
	// free definition of the insulation
		if(!_Map.hasInt("indexEdgeSlope"))
		{
			if(dHeight==0)
			{ 
				dHeight.set(U(5));
				reportMessage("\n"+scriptName()+" "+T("|body generation was not possible|"));
				reportMessage("\n"+scriptName()+" "+T("|Thickness was set to 5mm|"));
			}
			
			if(!iAlignedEntity)
			{ 
				// not aligned
				bdSpace=Body (pl,_ZW*dHeight);
				// 20220429
				Point3d ptPlaneTop=pn.ptOrg()+_ZW*dHeight;
				Vector3d vecPlaneTop=pn.vecZ();
				_Map.setPoint3d("ptPlaneTop",ptPlaneTop,_kAbsolute);
				_Map.setVector3d("vecPlaneTop",_ZW,_kFixedSize);
				// store Body
				_Map.setBody("bd",bdSpace);
			}
			else if(iAlignedEntity)
			{ 
				// aligned to entity
				Vector3d vecNormalPn = pn.vecZ();
				vecNormalPn.normalize();
				if(!iAlignFaces)
				{
					bdSpace=Body(pl,vecNormalPn*dHeight);
					_Map.setVector3d("vecUnderneath", vecNormalPn);
					_Map.setPoint3d("ptUnderneath", pn.ptOrg());
					// store Body
					_Map.setBody("bd", bdSpace);
				}
				else if(iAlignFaces)
				{ 
					// 
					Entity entTsl=_Map.getEntity("TslAlign");
					TslInst tsl=(TslInst)entTsl;
					Vector3d vecNormalUnderneath=tsl.map().getVector3d("vecUnderneath");
		//			bdSpace=Body(pl, vecNormalUnderneath*U(10e3));
					bdSpace=Body(pl, vecNormalPn*U(10e3));
					
					// create a large planeprofile and then clear the faces
					PlaneProfile ppLarge(pl);
					ppLarge.shrink(-U(300));
					
					PLine plLarges[]=ppLarge.allRings(true,false);
					PLine plLarge=plLarges[0];
					bdSpace=Body(plLarge, vecNormalUnderneath*U(10e3));
					bdSpace.vis(3);
					
					// check all edges if they align with the underlying edges 
					// and cleanup the faces with the vecNormalUnderneath
					Point3d ptVertices[]=pl.vertexPoints(false);
					Body bdUnderneath = tsl.map().getBody("bd");
		//			bdUnderneath.transformBy(U(50) * _ZW);
		//			bdUnderneath.vis(6);
					PlaneProfile ppUnderneath = bdUnderneath.extractContactFaceInPlane(pn, dEps);
		//			ppUnderneath.vis(6);
					PLine plsUnderneath[]=ppUnderneath.allRings(true,false);
					PLine plUnderneath=plsUnderneath[0];
					plUnderneath.vis(6);
					Point3d ptVerticesUnderneath[] = plUnderneath.vertexPoints(false);
					int iFaceAlignedAtAll;
					for (int ipt=0;ipt<ptVertices.length()-1;ipt++)
					{ 
						Point3d pt1=ptVertices[ipt];
						Point3d pt2=ptVertices[ipt+1];
						Point3d ptMid=.5*(pt1+pt2);
						Vector3d vec1 = pt2 - pt1;vec1.normalize();
						int iFaceAligned;
						for (int jpt=0;jpt<ptVerticesUnderneath.length()-1;jpt++)
						{ 
							Point3d _pt1=ptVerticesUnderneath[jpt];
							Point3d _pt2=ptVerticesUnderneath[jpt+1];
							Vector3d _vec1 = _pt2 - _pt1; _vec1.normalize();
							
							if(abs(abs(vec1.dotProduct(_vec1))-1.0)<dEps)
							{ 
								// parallel, check distance
								double dDist1=(pt1-Line(_pt1,_vec1).closestPointTo(pt1)).length();
								double dDist2=(pt2-Line(_pt1,_vec1).closestPointTo(pt2)).length();
								if(dDist1<dEps && dDist2<dEps)
								{ 
									iFaceAligned = true;
									iFaceAlignedAtAll=true;
									break;
								}
							}
						}//next jpt
						// 
						if(iFaceAligned)
						{ 
							Vector3d vecXsubtract = vec1;
							Vector3d vecZsubtract = vecNormalUnderneath;
							vecXsubtract=vecZsubtract.crossProduct(vecXsubtract.crossProduct(vecZsubtract));
							vecXsubtract.normalize();
							Vector3d vecYsubtract=vecZsubtract.crossProduct(vecXsubtract);
							vecYsubtract.normalize();
							Point3d ptTest = ptMid + dEps * vecYsubtract;
							PlaneProfile ppTest(pl);
							if(ppTest.pointInProfile(ptTest)==_kPointInProfile)
							{ 
								vecXsubtract*=-1;
								vecYsubtract*=-1;
							}
							Body bdSubFace(ptMid,vecXsubtract,vecYsubtract,vecZsubtract,
								U(10e6), U(10e6), U(10e6), 0, 1, 0);
							bdSpace.subPart(bdSubFace);
						}
						else if(!iFaceAligned)
						{ 
							Vector3d vecXsubtract = vec1;
							Vector3d vecZsubtract = vecNormalPn;
							vecXsubtract=vecZsubtract.crossProduct(vecXsubtract.crossProduct(vecZsubtract));
							vecXsubtract.normalize();
							Vector3d vecYsubtract=vecZsubtract.crossProduct(vecXsubtract);
							vecYsubtract.normalize();
							Point3d ptTest = ptMid + dEps * vecYsubtract;
							PlaneProfile ppTest(pl);
							if(ppTest.pointInProfile(ptTest)==_kPointInProfile)
							{ 
								vecXsubtract*=-1;
								vecYsubtract*=-1;
							}
							Body bdSubFace(ptMid,vecXsubtract,vecYsubtract,vecZsubtract,
							U(10e6), U(10e6), U(10e6), 0, 1, 0);
							bdSpace.subPart(bdSubFace);
						}
					}//next ipt
					
					if(!iFaceAlignedAtAll)
					{ 
						_Map.setInt("AlignFaces",false);
					}
					
					Body bdSubtract;
					Vector3d vecXsubtract=_PtG[1]-_PtG[0];
					vecXsubtract.normalize();
					Point3d ptSubtract = _PtG[0];
					ptSubtract += vecNormalPn * dHeight;
					vecXsubtract=vecNormalPn.crossProduct(vecXsubtract.crossProduct(vecNormalPn));
					Vector3d vecZsubtract = vecNormalPn;
					Vector3d vecYsubtract = vecZsubtract.crossProduct(vecXsubtract);
					vecYsubtract.normalize();
					ptSubtract.vis(1);
					bdSubtract=Body(ptSubtract,vecXsubtract,vecYsubtract,vecZsubtract,
						U(10e6), U(10e6), U(10e6), 0, 0, 1);
					bdSpace.subPart(bdSubtract);
					_Map.setVector3d("vecUnderneath", tsl.map().getVector3d("vecUnderneath"));
					_Map.setPoint3d("ptUnderneath",tsl.map().getPoint3d("ptUnderneath"));
					// store Body
					_Map.setBody("bd", bdSpace);
				}
				// 20220429
				Point3d ptPlaneTop = pn.ptOrg()+vecNormalPn*dHeight;
				Vector3d vecPlaneTop = pn.vecZ();
				_Map.setPoint3d("ptPlaneTop",ptPlaneTop,_kAbsolute);
				_Map.setVector3d("vecPlaneTop",vecNormalPn,_kFixedSize);
			}
		}
		else
		{ 
			int iEdgeSlope = _Map.getInt("indexEdgeSlope");
		//	int iEdgeSlope = nEdgeIndex-1;
		//	double dSlope = _Map.getDouble("Slope");
			double _dSlope = dSlope;
			
			Point3d _pts[0];
			_pts.append(_PtG);
			_pts.removeAt(_pts.length() - 1);
			_pts.append(_pts[0]);
			
			Point3d ptEdgeStart=_pts[iEdgeSlope], ptEdgeEnd=_pts[iEdgeSlope+1];
			ptEdgeStart.vis(3);
			ptEdgeEnd.vis(3);
			
			// build firs in the horizontal plane then rotate to the gradient/skew plane
			Plane pnHorEdgeStart(ptEdgeStart, _ZW);
			pl.vis(6);
			PLine plHorEdgeStart = pl;
		//	plHorEdgeStart.vis(1);
			Vector3d vecXorig, vecYorig, vecZorig;
			int iPointInside=-1;
			
			Vector3d vecEdge = ptEdgeEnd - ptEdgeStart;vecEdge.normalize();
			Vector3d vecEdgePn = ptEdgeEnd - ptEdgeStart;vecEdgePn.normalize();
		//	Vector3d vecNormal = pn.vecZ();
			Vector3d vecNormal = pnHorEdgeStart.vecZ();
			vecNormal.normalize();
			vecEdge=vecEdge.crossProduct(vecNormal);
			vecEdge.normalize();
			vecEdge=vecNormal.crossProduct(vecEdge);
			vecEdge.normalize();
			
			Vector3d vecEdgeNormal = vecNormal.crossProduct(vecEdge);
			vecEdgeNormal.normalize();
			vecEdge.vis(ptEdgeStart);
			vecEdgeNormal.vis(ptEdgeStart);
			vecNormal.vis(ptEdgeStart);
			
			vecXorig = vecEdge;
			vecZorig = _ZW;
			vecYorig = vecZorig.crossProduct(vecXorig);
			
			ppSpace.vis(3);
			Point3d ptTest=.5*(ptEdgeStart+ptEdgeEnd)+1000*dEps*vecEdgeNormal;
			ptTest.vis(4);
			if (ppSpace.pointInProfile(ptTest) == _kPointInProfile)iPointInside = 1;
			
			Vector3d vecEdgeNormalHor = _ZW.crossProduct(vecEdgeNormal);vecEdgeNormalHor.normalize();
			vecEdgeNormalHor = vecEdgeNormalHor.crossProduct(_ZW);vecEdgeNormalHor.normalize();
		//	vecEdgeNormalHor.vis(ptEdgeStart);
		//	Vector3d vecSlope = iPointInside*vecEdgeNormal + 0.01 * _dSlope * vecNormal;
			Vector3d vecSlope = iPointInside*vecEdgeNormalHor + 0.01 * _dSlope * _ZW;
			vecSlope.vis(ptEdgeStart);
			Vector3d vecSlopeNormal = (vecEdge.crossProduct(vecSlope));
			if(vecSlopeNormal.dotProduct(_ZW)<0)
				vecSlopeNormal *= -1;
				
		//	if(vecSlopeNormal.dotProduct(_ZW)<0 && dSlope>0)
		//	{ 
		//		vecSlopeNormal *= -1;
		//	}
		//	if(vecSlopeNormal.dotProduct(_ZW)>0 && dSlope<0)
		//	{ 
		//		vecSlopeNormal *= -1;
		//	}
			Vector3d vecNormalPn = pn.vecZ();
			vecNormalPn.normalize();
			vecSlopeNormal.vis(ptEdgeStart);
			Point3d ptEdgeStart_ = ptEdgeStart;
			if(dHeight>0)
			{
				ptEdgeStart += dHeight * _ZW;
		//		ptEdgeStart += dHeight * vecNormalPn;
			}
			ptEdgeStart.vis(1);
			Body bdSubtract(ptEdgeStart,vecEdge,vecSlope,vecSlopeNormal,
				U(10e4),U(10e4),U(10e4),0,0,1);
		//	bdSubtract.vis(1);
			
			Vector3d vecXnew = vecEdgePn;
			Vector3d vecZnew = vecNormalPn;
			Vector3d vecYnew = vecZnew.crossProduct(vecXnew);
			vecYnew.normalize();
			CoordSys csTransform;
			vecXorig.vis(ptEdgeEnd);
			vecYorig.vis(ptEdgeEnd);
			vecZorig.vis(ptEdgeEnd);
			
			vecXnew.vis(ptEdgeEnd,1);
			vecYnew.vis(ptEdgeEnd,1);
			vecZnew.vis(ptEdgeEnd,1);
			csTransform.setToAlignCoordSys(ptEdgeStart_,vecXorig,vecYorig,vecZorig,
				ptEdgeStart_,vecXnew,vecYnew,vecZnew);
			CoordSys csTransformInv = csTransform;
			csTransformInv.invert();
			plHorEdgeStart.transformBy(csTransformInv);
		//	plHorEdgeStart.vis(1);
			
		//	bdSpace = Body (pl, _ZW * U(10e3));
			
			if(!iAlignFaces)
			{ 
				bdSpace = Body (plHorEdgeStart, _ZW * U(10e3));
			//	bdSpace.vis(1);
				bdSpace.subPart(bdSubtract);
			//	bdSpace.vis(1);
				// transform
				PLine pltTransform = plHorEdgeStart;
				pltTransform.transformBy(csTransform);
				pltTransform.vis(6);
				bdSpace.transformBy(csTransform);
				vecSlopeNormal.transformBy(csTransform);
				// Edge alignment vector for the tsl that will be aligned with this one
				_Map.setVector3d("vecUnderneath", vecNormalPn);
				_Map.setPoint3d("ptUnderneath", pn.ptOrg());
			}
			else if(iAlignFaces)
			{ 
				pl.vis(6);
				// get the plane of the underneath entity
				vecSlopeNormal.transformBy(csTransform);
				Plane pnUnderneath(ptEdgeStart, vecSlopeNormal);
				Entity entTsl = _Map.getEntity("TslAlign");
				TslInst tsl = (TslInst)entTsl;
				{ 
					
					pnUnderneath=Plane(tsl.map().getPoint3d("ptUnderneath"),
						tsl.map().getVector3d("vecUnderneath"));
					_Map.setVector3d("vecUnderneath", tsl.map().getVector3d("vecUnderneath"));
					_Map.setPoint3d("ptUnderneath",tsl.map().getPoint3d("ptUnderneath"));
		//			Entity entTslUnderneath=tsl.map().getEntity("TslAlign");
		//			TslInst tslUnderneath = (TslInst)entTslUnderneath;
		//			if(tslUnderneath.bIsValid())
		//			{ 
		//				pnUnderneath = Plane(tslUnderneath.map().getPoint3d("ptPlaneTop"), 
		//					tslUnderneath.map().getVector3d("vecPlaneTop"));
		//			}
		//			else
		//			{ 
		//				pnUnderneath=Plane(tsl.ptOrg(),_ZW);
		//			}
					tsl.map().getVector3d("vecUnderneath").vis(_Pt0);
				}
		//		bdSpace = Body (plHorEdgeStart, _ZW * U(10e3));
				Vector3d vecNormalUnderneath = pnUnderneath.vecZ();
				vecNormalUnderneath.vis(_Pt0);
				vecNormalUnderneath.normalize();
				pl.vis(3);
				
				vecNormalUnderneath.vis(_Pt0);
		//		bdSpace = Body (pl, vecNormalUnderneath * U(10e3));
				PlaneProfile ppLarge(pl);
				ppLarge.shrink(-U(300));
				
				PLine plLarges[]=ppLarge.allRings(true,false);
				PLine plLarge=plLarges[0];
				bdSpace=Body(plLarge, vecNormalUnderneath*U(10e3));
				
				
				bdSubtract.transformBy(csTransform);
		//		bdSpace.vis(1);
		//		bdSubtract.vis(1);
				bdSpace.subPart(bdSubtract);
		//		bdSpace.vis(1);
				// transform
				PLine pltTransform = plHorEdgeStart;
				pltTransform.transformBy(csTransform);
				pltTransform.vis(6);
		//		bdSpace.transformBy(csTransform);
		//		vecSlopeNormal.transformBy(csTransform);
		
				// check all edges if they align with the underlying edges 
				// and cleanup the faces with the vecNormalUnderneath
				Point3d ptVertices[]=pl.vertexPoints(false);
				Body bdUnderneath = tsl.map().getBody("bd");
		//			bdUnderneath.transformBy(U(50) * _ZW);
		//			bdUnderneath.vis(6);
				PlaneProfile ppUnderneath = bdUnderneath.extractContactFaceInPlane(pn, dEps);
		//			ppUnderneath.vis(6);
				PLine plsUnderneath[]=ppUnderneath.allRings(true,false);
				PLine plUnderneath=plsUnderneath[0];
				plUnderneath.vis(6);
				Point3d ptVerticesUnderneath[] = plUnderneath.vertexPoints(false);
				for (int ipt=0;ipt<ptVertices.length()-1;ipt++)
				{ 
					Point3d pt1=ptVertices[ipt];
					Point3d pt2=ptVertices[ipt+1];
					Point3d ptMid=.5*(pt1+pt2);
					Vector3d vec1 = pt2 - pt1;vec1.normalize();
					int iFaceAligned;
					for (int jpt=0;jpt<ptVerticesUnderneath.length()-1;jpt++)
					{ 
						Point3d _pt1=ptVerticesUnderneath[jpt];
						Point3d _pt2=ptVerticesUnderneath[jpt+1];
						Vector3d _vec1 = _pt2 - _pt1; _vec1.normalize();
						
						if(abs(abs(vec1.dotProduct(_vec1))-1.0)<dEps)
						{ 
							// parallel, check distance
							double dDist1=(pt1-Line(_pt1,_vec1).closestPointTo(pt1)).length();
							double dDist2=(pt2-Line(_pt1,_vec1).closestPointTo(pt2)).length();
							if(dDist1<dEps && dDist2<dEps)
							{ 
								iFaceAligned = true;
								break;
							}
						}
					}//next jpt
					// 
					if(iFaceAligned)
					{ 
						Vector3d vecXsubtract = vec1;
						Vector3d vecZsubtract = vecNormalUnderneath;
						vecXsubtract=vecZsubtract.crossProduct(vecXsubtract.crossProduct(vecZsubtract));
						vecXsubtract.normalize();
						Vector3d vecYsubtract=vecZsubtract.crossProduct(vecXsubtract);
						vecYsubtract.normalize();
						Point3d ptTest = ptMid + dEps * vecYsubtract;
						PlaneProfile ppTest(pl);
						if(ppTest.pointInProfile(ptTest)==_kPointInProfile)
						{ 
							vecXsubtract*=-1;
							vecYsubtract*=-1;
						}
						Body bdSubFace(ptMid,vecXsubtract,vecYsubtract,vecZsubtract,
							U(10e6), U(10e6), U(10e6), 0, 1, 0);
						bdSpace.subPart(bdSubFace);
					}
					else if(!iFaceAligned)
					{ 
						Vector3d vecXsubtract = vec1;
						Vector3d vecZsubtract = vecNormalPn;
						vecXsubtract=vecZsubtract.crossProduct(vecXsubtract.crossProduct(vecZsubtract));
						vecXsubtract.normalize();
						Vector3d vecYsubtract=vecZsubtract.crossProduct(vecXsubtract);
						vecYsubtract.normalize();
						Point3d ptTest = ptMid + dEps * vecYsubtract;
						PlaneProfile ppTest(pl);
						if(ppTest.pointInProfile(ptTest)==_kPointInProfile)
						{ 
							vecXsubtract*=-1;
							vecYsubtract*=-1;
						}
						Body bdSubFace(ptMid,vecXsubtract,vecYsubtract,vecZsubtract,
						U(10e6), U(10e6), U(10e6), 0, 1, 0);
						bdSpace.subPart(bdSubFace);
					}
				}//next ipt
			}
			if(dHeightMax>0)
			{ 
			// limit height
	//			if(dHeight>0)
	//			{ 
	//				pl.transformBy(-dHeight*_ZW);
	//			}
				pl.transformBy(dHeightMax*_ZW);
				Body bdSubtractMax(pl, _ZW * U(10e3));
				bdSpace.subPart(bdSubtractMax);
			}
			bdSpace.vis(1);
			if(dHeight>0)
			{
				ptEdgeStart_ += dHeight * vecNormalPn;
			}
			{ 
		//		PlaneProfile ppVer = bdSpace.shadowProfile(Plane(ptEdgeStart, _XW));
		//		// get extents of profile
		//		LineSeg seg = ppVer.extentInDir(_XW);
		//		Point3d ptPlaneTop = seg.ptEnd();
		//		ptPlaneTop.vis(1);
		//		if(_ZW.dotProduct(seg.ptStart()-seg.ptEnd())>0)ptPlaneTop = seg.ptStart();
				
				_Map.setPoint3d("ptPlaneTop",ptEdgeStart_,_kAbsolute);
				_Map.setVector3d("vecPlaneTop",vecSlopeNormal,_kFixedSize);
				// store Body
				_Map.setBody("bd", bdSpace);
			}
		}
	}
	else if (nType==1)
	{
		// roof type definition of the insulation
	//	return;
		// build a solid body from the closed pline
		Body bdClosed(pl, _ZW * U(10e3));
		if(dHeight>0)
		{ 
			pl.transformBy(dHeight*_ZW);
		}
		bdClosed.vis(1);
		// build a cutting body for all edges
		Point3d ptsAll[] = pl.vertexPoints(false);
		
		for (int ii=0;ii<ptsAll.length();ii++) 
		{ 
			ptsAll[ii].vis(ii); 
		}//next ii
		
		
		ptsAll.append(ptsAll[1]);
		ptsAll.insertAt(0,ptsAll[ptsAll.length()-2]);
		for (int i=1;i<ptsAll.length()-2;i++) 
		{ 
			Point3d pt1=ptsAll[i];
			Point3d pt2=ptsAll[i+1];
			Point3d ptMid=.5*(pt1+pt2);
			Vector3d vecDir=pt2-pt1;vecDir.normalize();
			Vector3d vecNor=vecDir.crossProduct(_ZW);vecNor.normalize();
			Point3d ptTest=ptMid+vecNor*U(1);
			if(ppSpace.pointInProfile(ptTest)==_kPointOutsideProfile)
				vecNor*=-1;
			Vector3d vecInPlane=vecNor+0.01*dSlope*_ZW;vecInPlane.normalize();
			Vector3d vecPlane=vecDir.crossProduct(vecInPlane);vecPlane.normalize();
			if(vecPlane.dotProduct(_ZW)<0)
				vecPlane*=-1;
			
			
			Vector3d vec1L=ptsAll[i-1]-ptsAll[i];vec1L.normalize();
			Vector3d vec1R=ptsAll[i+1]-ptsAll[i];vec1R.normalize();
			Vector3d vec2L=ptsAll[i]-ptsAll[i+1];vec2L.normalize();
			Vector3d vec2R=ptsAll[i+2]-ptsAll[i+1];vec2R.normalize();
		// get the vector at two points, it is the vector that splits in half
		// the angle at the corner
			Vector3d vec1=.5*(vec1L+vec1R);vec1.normalize();
			Vector3d vec2=.5*(vec2L+vec2R);vec2.normalize();
			
		// 	vectors must point at the inside
			Point3d ptTest1=pt1+vec1*U(1);
			if(ppSpace.pointInProfile(ptTest1)==_kPointOutsideProfile)
			{ 
				vec1*=-1;
			}
			Point3d ptTest2=pt2+vec2*U(1);
			if(ppSpace.pointInProfile(ptTest2)==_kPointOutsideProfile)
			{ 
				vec2*=-1;
			}
			
			vec1.vis(pt1);
			vec2.vis(pt2);
			if(abs(abs(vec1.dotProduct(vec2))-1.0)>0.01*dEps)
			{ 
			// not parallel, find intersection point
				Point3d pt12;
				Vector3d vecPn2=vec2.crossProduct(_ZW);vecPn2.normalize();
				Line(pt1,vec1).hasIntersection(Plane(pt2,vecPn2),pt12);
				pt12.vis(3);
				// vecNor points inside the area
				Vector3d vec12Mid=pt12-ptMid;vec12Mid.normalize();
				
				Point3d pt12Ln=Line(ptMid,vecDir).closestPointTo(pt12);
				double dDist12Ln=(pt12-pt12Ln).length();
				pt12Ln.vis(6);
				
				Point3d pt12Pn=pt12+_ZW*dDist12Ln*.01*dSlope;
				if(vec12Mid.dotProduct(vecNor)>0)
				{ 
				// points inside the area
					pt12Pn.vis(6);
					PLine plI(vecPlane);
					plI.addVertex(pt1);
					plI.addVertex(pt2);
					plI.addVertex(pt12Pn);
		//			Body bdI(plI,vecPlane*U(10e6));
					Body bdI(plI,_ZW*U(10e6));
					bdI.vis(2);
					bdClosed.subPart(bdI);
				}
				else
				{ 
				// points outside the are
					Point3d pt1Far=pt1+vec1*U(10e3);
					Point3d pt1FarLn=Line(ptMid,vecDir).closestPointTo(pt1Far);
					double dDist1Ln=(pt1Far-pt1FarLn).length();
					
					Point3d pt2Far=pt2+vec2*U(10e3);
					Point3d pt2FarLn=Line(ptMid,vecDir).closestPointTo(pt2Far);
					double dDist2Ln=(pt2Far-pt2FarLn).length();
					
					Point3d pt1FarPn=pt1Far+_ZW*dDist1Ln*.01*dSlope;
					Point3d pt2FarPn=pt2Far+_ZW*dDist2Ln*.01*dSlope;
					PLine plI(vecPlane);
					plI.addVertex(pt1);
					plI.addVertex(pt1FarPn);
					plI.addVertex(pt2FarPn);
					plI.addVertex(pt2);
					plI.vis(6);
					Body bdI(plI,_ZW*U(10e6));
					bdI.vis(2);
					bdClosed.subPart(bdI);
				}
			}
			else
			{ 
			// parallel vectors, build a large area
				Point3d pt1Far=pt1+vec1*U(10e3);
				Point3d pt1FarLn=Line(ptMid,vecDir).closestPointTo(pt1Far);
				double dDist1Ln=(pt1Far-pt1FarLn).length();
				
				Point3d pt2Far=pt2+vec2*U(10e3);
				Point3d pt2FarLn=Line(ptMid,vecDir).closestPointTo(pt2Far);
				double dDist2Ln=(pt2Far-pt2FarLn).length();
				
				Point3d pt1FarPn=pt1Far+_ZW*dDist1Ln*.01*dSlope;
				Point3d pt2FarPn=pt2Far+_ZW*dDist2Ln*.01*dSlope;
				
				PLine plI(vecPlane);
				plI.addVertex(pt1);
				plI.addVertex(pt1FarPn);
				plI.addVertex(pt2FarPn);
				plI.addVertex(pt2);
				plI.vis(6);
				Body bdI(plI,_ZW*U(10e6));
				bdI.vis(2);
				bdClosed.subPart(bdI);
			}
		}//next i
		bdClosed.vis(3);
		// remove subtract plines
		Entity entSubtracts[]=_Map.getEntityArray("entSubtracts","entSubtracts","entSubtracts");
		for (int i=0;i<entSubtracts.length();i++) 
		{ 
			EntPLine ePli=(EntPLine) entSubtracts[i];
			EntCircle eCircI=(EntCircle)entSubtracts[i];
			if(!ePli.bIsValid() && !eCircI.bIsValid())continue;
			if(ePli.bIsValid())
			{ 
				PLine pli=ePli.getPLine();
				Body bdsubi=Body(pli,_ZW * U(10e3));
				bdClosed.subPart(bdsubi);
			}
			else if(eCircI.bIsValid())
			{ 
				PLine pli;
				pli.createCircle(eCircI.ptCen(),eCircI.normal(),eCircI.radius());
				Body bdsubi=Body(pli,_ZW * U(10e3));
				bdClosed.subPart(bdsubi);
			}
			
		}//next i
		bdSpace = bdClosed;
		if(dHeightMax>0)
		{ 
			if(dHeight>0)
			{ 
				pl.transformBy(-dHeight*_ZW);
			}
			pl.transformBy(dHeightMax*_ZW);
			Body bdSubtractMax(pl, _ZW * U(10e3));
			bdSpace.subPart(bdSubtractMax);
		}
		_Map.setBody("bd", bdSpace);
	}
	else if(nType==2)
	{ 
	// reverse roof
		Point3d ptDeeps[]=_Map.getPoint3dArray("ptDeeps");
		
	//	if(ptDeeps.length()==0)
	//	{ 
	//	// 
	//		reportMessage("\n"+scriptName()+" "+T("|One deep point is needed|"));
	//		eraseInstance();
	//		return;
	//	}
	//	return;
		
		Map mapPtHeights=_Map.getMap("PtHeights");
		if(!_Map.hasMap("PtHeights") || mapPtHeights.length()!=ptDeeps.length())
		{ 
		// initialise
			mapPtHeights=Map();
			for (int i=0;i<ptDeeps.length();i++) 
			{ 
				mapPtHeights.appendDouble(i,dHeight);
			}//next i
			_Map.setMap("PtHeights",mapPtHeights);
		}
		mapPtHeights=_Map.getMap("PtHeights");
		for (int i=0;i<mapPtHeights.length();i++) 
		{ 
			double dHi=mapPtHeights.getDouble(i);
		}//next i
		
		pl.vis(1);
	// plane of the base
		Plane pnBase(pl.coordSys().ptOrg(),_ZW);
		Body bdClosed(pl, _ZW * U(10e3));
		if(dHeight>0)
		{ 
			pl.transformBy(dHeight*_ZW);
		}
		Plane pnDeep(pl.coordSys().ptOrg(),_ZW);
		
	// create for each point the for subtracting bodies
		Vector3d v1=_XW+_YW;v1.normalize();
		Vector3d v2=_XW-_YW;v2.normalize();
		Vector3d v3=-_XW-_YW;v3.normalize();
		Vector3d v4=-_XW+_YW;v4.normalize();
		Vector3d vecs[]={v1,v2,v3,v4,v1};
		
		//	bdClosed.vis(4);
	//	Display dpDeepPoints(3);
		for (int i=0;i<ptDeeps.length();i++) 
		{ 
			Point3d ptI=pn.closestPointTo(ptDeeps[i]);
	//		mapPtHeights.getDouble("PtHeight");
			ptI+=_ZW*mapPtHeights.getDouble(i);
	//		PLine plCircle(_ZW);
	//		plCircle.createCircle(ptI,_ZW,U(100));
	//		PlaneProfile ppCircle(pn);
	//		ppCircle.joinRing(plCircle,_kAdd);
	//		dpDeepPoints.draw(ppCircle,_kDrawFilled,70);
	//		ptI=pnDeep.closestPointTo(ptDeeps[i]);
			for (int iv=0;iv<vecs.length()-1;iv++) 
			{ 
				Vector3d _v1= vecs[iv];
				Vector3d _v2= vecs[iv+1];
				Point3d pt1=ptI+_v1*U(10e4);
				Point3d pt2=ptI+_v2*U(10e4);
				Vector3d vecLn=pt2-pt1;vecLn.normalize();
				Point3d ptIln=Line(pt1,vecLn).closestPointTo(ptI);
				double dDistLn=(ptIln-ptI).length();
				Point3d pt1Pn=pt1+_ZW*(dDistLn*0.01*dSlope);
				Point3d pt2Pn=pt2+_ZW*(dDistLn*0.01*dSlope);
				
				PLine plI;
				plI.addVertex(ptI);
				plI.addVertex(pt1Pn);
				plI.addVertex(pt2Pn);
				plI.close();
				plI.vis(1);
				Body bdI(plI,_ZW*U(10e6));
	//			bdI.vis(2);
				bdClosed.subPart(bdI);
	//			 bdClosed.vis(2);
			}//next iv
			
		}//next i
		bdClosed.vis(3);
	// remove subtract plines
		Entity entSubtracts[]=_Map.getEntityArray("entSubtracts","entSubtracts","entSubtracts");
		for (int i=0;i<entSubtracts.length();i++) 
		{ 
			EntPLine ePli=(EntPLine) entSubtracts[i];
			EntCircle eCircI=(EntCircle)entSubtracts[i];
			if(!ePli.bIsValid() && !eCircI.bIsValid())continue;
			if(ePli.bIsValid())
			{ 
				PLine pli=ePli.getPLine();
				Body bdsubi=Body(pli,_ZW * U(10e3));
				bdClosed.subPart(bdsubi);
			}
			else if(eCircI.bIsValid())
			{ 
				PLine pli;
				pli.createCircle(eCircI.ptCen(),eCircI.normal(),eCircI.radius());
				Body bdsubi=Body(pli,_ZW * U(10e3));
				bdClosed.subPart(bdsubi);
			}
			
		}//next i
		
		bdSpace = bdClosed;
		if(dHeightMax>0)
		{ 
			if(dHeight>0)
			{ 
				pl.transformBy(-dHeight*_ZW);
			}
			pl.transformBy(dHeightMax*_ZW);
			Body bdSubtractMax(pl, _ZW * U(10e3));
			bdSpace.subPart(bdSubtractMax);
		}
		_Map.setBody("bd", bdSpace);
		
	//region Trigger ChangeHeight
		String sTriggerChangeHeight = "Höhe für den Tiefpunkt eingeben";
		addRecalcTrigger(_kContextRoot, sTriggerChangeHeight );
		if (_bOnRecalc && _kExecuteKey==sTriggerChangeHeight)
		{
			String sStringStart="Tiefpunkt wählen";
			String sStringPrompt=sStringStart;
			PrPoint ssP(sStringPrompt);
			Map mapArgs;
			int nGoJig=-1;
			Point3d _pts[0];
			_pts.append(ptDeeps);
			mapArgs.setPoint3dArray("pts",_pts);
			
			while (nGoJig!=_kNone)
			{
				nGoJig=ssP.goJig(strJigAction7,mapArgs);
				if (nGoJig == _kOk)
				{
					// point is clicked
					Point3d ptLast=ssP.value();
					Vector3d vecView=getViewDirection();
					ptLast=Line(ptLast,vecView).intersect(Plane(_Pt0,_ZW),U(0));
					int iIndex =0;
					if (mapArgs.hasPoint3dArray("pts"))
					{
						Point3d _pts[] = mapArgs.getPoint3dArray("pts");
						// get index of closest point with the jig point
						
						double dDist=(_pts[0]-ptLast).length();
						for (int ipt=0;ipt<_pts.length();ipt++) 
						{ 
							if((_pts[ipt]-ptLast).length()<dDist)
							{ 
								dDist = (_pts[ipt] - ptLast).length();
								iIndex = ipt;
							}
						}//next ipt
					}
					double dCurrentHeight;
					for (int ii=0;ii<mapPtHeights.length();ii++) 
					{ 
						if(ii==iIndex)
						{ 
							dCurrentHeight=mapPtHeights.getDouble(ii);
							break;
						}
					}//next ii
					
					String sNewHeight=getString("Höhe eingeben, bestehende Höhe: "+dCurrentHeight);
					double dNewHeight = sNewHeight.atof();
					Map mapPtHeightsNew;
					for (int ii=0;ii<mapPtHeights.length();ii++) 
					{ 
						if(ii!=iIndex)
						{ 
							mapPtHeightsNew.appendDouble(ii,mapPtHeights.getDouble(ii));
						}
						else
						{ 
						// set new height
							mapPtHeightsNew.appendDouble(ii,dNewHeight);
						}
					}//next ii
					_Map.setMap("PtHeights",mapPtHeightsNew);
					nGoJig = _kNone;
				}
				else if(nGoJig==_kCancel)
				{ 
					nGoJig = _kNone;
				}
			}
			setExecutionLoops(2);
			return;
		}
	//endregion	
		
	}
	bdSpace.vis(6);
	
	if(nType==1 || nType==2)
	{ 
	// trigger to generate section
	
	//region Trigger AddSectionCut
		String sTriggerAddSectionCut = "Schnitt hinzufügen";
		addRecalcTrigger(_kContextRoot, sTriggerAddSectionCut );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddSectionCut)
		{
			// prompt for point input
			Point3d pt1,pt2,ptInsertion;
			PrPoint ssP(TN("|Select first point|")); 
			if (ssP.go()==_kOk) 
				pt1=(ssP.value()); // append the selected points to the list of grippoints _PtG
				
			PrPoint ssP2(TN("|Select second point|"),pt1); 
			if (ssP2.go()==_kOk) 
				pt2=(ssP2.value());
			
			PrPoint ssP3(TN("|Select insertion point|")); 
			if (ssP3.go()==_kOk) 
				ptInsertion=(ssP3.value());
				
		// create TSL
			TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {}; Entity entsTsl[] = {_ThisInst}; 
			Point3d ptsTsl[] = {ptInsertion,pt1,pt2};
			int nProps[]={}; double dProps[]={}; 
			String sProps[]={sType};
			Map mapTsl;	
			// section mode
			mapTsl.setInt("Mode", 1);
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
				ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			if(_Entity.find(tslNew)<0)
			{ 
			//
				_Entity.append(tslNew);
			}
			setExecutionLoops(2);
			return;
		}//endregion
		
	//region Trigger AddTable
		String sTriggerAddTable ="Tabelle hinzufügen";
		addRecalcTrigger(_kContextRoot, sTriggerAddTable );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddTable)
		{
			Point3d ptInsertion;
			PrPoint ssP(TN("|Select insertion point|")); 
			if (ssP.go()==_kOk) 
				ptInsertion=(ssP.value());
			
		// create TSL
			TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {}; Entity entsTsl[] = {_ThisInst}; 
			Point3d ptsTsl[] = {ptInsertion};
			int nProps[]={}; double dProps[]={}; 
			String sProps[]={sType,sDisplayStyle,sLegend,sNumber,sName};
			Map mapTsl;	
			// section mode
			mapTsl.setInt("Mode", 2);
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
				ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				
			setExecutionLoops(2);
			return;
		}//endregion
	//
	
	//region Trigger SubtractPline
		String sTriggerSubtractPline ="Polylinien abziehen";
		addRecalcTrigger(_kContextRoot, sTriggerSubtractPline );
		if (_bOnRecalc && _kExecuteKey==sTriggerSubtractPline)
		{
			
		// get Pline
		// prompt for polylines
			Entity entsSelected[0];
			PrEntity ssEpl(T("|Select polylines|"), EntPLine());
			ssEpl.addAllowedClass(EntCircle());
		  	if (ssEpl.go())
				entsSelected.append(ssEpl.set());
				
	//		EntPLine ePlSubtracts[0];
	//		for (int i=0;i<entsSelected.length();i++) 
	//		{ 
	//			EntPLine ePli=(EntPLine) entsSelected[i];
	//			if(ePli.bIsValid())
	//				ePlSubtracts.append(ePli);
	//		}//next i
			
		// create the planeprofile
			PlaneProfile pp(pn);
			pp.joinRing(pl, _kAdd);
		// subtract plines
			
			Entity entSubtracts[]=_Map.getEntityArray("entSubtracts","entSubtracts","entSubtracts");
			for (int i=entSubtracts.length()-1; i>=0 ; i--) 
			{ 
				if(!entSubtracts[i].bIsValid())
					entSubtracts.removeAt(i);
			}//next i
			entSubtracts.append(entsSelected);
			
			for (int i=0;i<entSubtracts.length();i++) 
			{ 
				EntPLine ePlI=(EntPLine) entSubtracts[i];
				EntCircle eCircI=(EntCircle)entSubtracts[i];
				if(ePlI.bIsValid())
				{
					PLine pli=ePlI.getPLine();
					pp.joinRing(pli,_kSubtract);
					if(_Entity.find(entSubtracts[i])<0)
						_Entity.append(entSubtracts[i]);
				}
				else if(eCircI.bIsValid())
				{
					PLine pli;
					pli.createCircle(eCircI.ptCen(),eCircI.normal(),eCircI.radius());
					pp.joinRing(pli,_kSubtract);
					if(_Entity.find(entSubtracts[i])<0)
						_Entity.append(entSubtracts[i]);
				}
			}//next i
			for (int i=_Entity.length()-1; i>=0 ; i--) 
			{ 
				if(!_Entity[i].bIsValid())
					_Entity.removeAt(i);
			}//next i
			
			PLine plsIns[]=pp.allRings(true,false);
	//		PLine plsOps[]=pp.allRings(false,true);
			
			if(plsIns.length()!=1)
			{ 
				reportMessage("\n"+scriptName()+" "+T("|More thatn one ring found|"));
				return;
			}
			ePl.setPLine(plsIns[0]);
			
			_Map.setEntityArray(entSubtracts,true,
				"entSubtracts","entSubtracts","entSubtracts");
			setExecutionLoops(2);
			return;
		}//endregion	
		
	
	
		for (int i=0;i<_Entity.length();i++)
		{ 
			setDependencyOnEntity(_Entity[i]);
		}//next i
		
		TslInst tslSections[0];
		for (int i=_Entity.length()-1; i>=0 ; i--) 
		{ 
			if(!_Entity[i].bIsValid())_Entity.removeAt(i);
		}//next i
		
		for (int i=0;i<_Entity.length();i++) 
		{ 
			TslInst tslI=(TslInst)_Entity[i];
			if(tslI.map().getInt("Mode")==1)
			{ 
				tslSections.append(tslI);
			}
		}//next i
		String sLabelSections[]={ "A","B","C","D","E","F","G","H","I","J","K",
			"L","M","N","O","P","Q","R","S","T","U"};
		// order alphabetically
		for (int i=0;i<tslSections.length();i++) 
			for (int j=0;j<tslSections.length()-1;j++) 
				if (tslSections[j].handle()>tslSections[j+1].handle())
					tslSections.swap(j, j + 1);
		for (int i=0;i<tslSections.length();i++) 
		{ 
			tslSections[i].setPropString(sLabelSectionName,sLabelSections[i]);
		}//next i
	}
	
	
	ppSpaceHorReal = bdSpace.shadowProfile(pnHor);
	PLine plReals[] = ppSpaceHorReal.allRings(true, false);
	if(plReals.length()>0)
		plReal = plReals[0];
	else
	{ 
		reportMessage("\n"+scriptName()+" "+T("|Possibly no volume detected|"));
	//	return;
	}
	
	//dpSpacePlane.draw(ppSpace, _kDrawFilled);
	
	Map mapDisplayStyle;
	for (int i=0;i<mapDisplayStyles.length();i++) 
	{ 
		Map mapDisplayStyleI = mapDisplayStyles.getMap(i);
		if(mapDisplayStyleI.hasString("Name") && mapDisplayStyles.keyAt(i).makeLower() == "darstellungsstil")
		{ 
			String sDisplayStyleName=mapDisplayStyleI.getString("Name");
			if(sDisplayStyleName==sDisplayStyle)
			{ 
				mapDisplayStyle = mapDisplayStyleI;
				break;
			}
		}
	}//next i
	
	//Map mapContour = mapDisplayStyle.getMap("Contour");
	//Map mapHatch=mapDisplayStyle.getMap("Hatch");
	// contour from top
	Display dpPlane(3);
	Display dpHatch(3);
	//String _sLineType = mapContour.getString("LineType");
	String _sLineType;
	int iLineType = sLineTypes.find(sLineType);
	if (iLineType > -1)
	{
		_sLineType = sLineType;
	}
	
	int iLineWeight = sLineWeights.find(sLineWeight);
	int _iLineWeight = -1;
	if(iLineWeight>0)
	{ 
		_iLineWeight=nLineWeights[iLineWeight];
	}
	
	_ThisInst.setLineWeight(_iLineWeight);
	
	//int _iContourColor = mapContour.getInt("Color");
	int _iContourColor = 0;
	if(nLineColor>-3)
	{
		_iContourColor=nLineColor;
	}
	
	dpPlane.addViewDirection(_ZW);
	dpHatch.addViewDirection(_ZW);
	dpPlane.color(_iContourColor);
	dpSpaceVolume.color(_iContourColor);
	
	PlaneProfile ppPlane(pn);
	ppPlane.joinRing(pl,_kAdd);
	ppSpaceHorReal.vis(1);
	if(_LineTypes.find(sLineType)>-1 && sLineType!="Continuous")
	{ 
	//	double _dLineScale = mapContour.getDouble("LineScale");
		double _dLineScale=1;
		if(dLineScale>0)
		{ 
			_dLineScale = dLineScale;
		}
		if(_dLineScale>0)
		{
			dpPlane.lineType(sLineType,dLineScale);
			dpSpaceVolume.lineType(sLineType,dLineScale);
		}
		else
		{
			dpPlane.lineType(sLineType);
			dpSpaceVolume.lineType(sLineType);
		}
	//	dpPlane.draw(ppPlane);
		dpPlane.draw(ppSpaceHorReal);
	}
	else
	{ 
	//	double dContourThickness = mapContour.getDouble("Thickness");
		double dContourThickness;
		dContourThickness = dLineThickness;
	//	PLine plsPlane[] = ppPlane.allRings();
		PLine plsPlane[] = ppSpaceHorReal.allRings();
		for (int ipl=0;ipl<plsPlane.length();ipl++) 
		{ 
	//		PlaneProfile ppI(ppPlane.coordSys());
			PlaneProfile ppI(ppSpaceHorReal.coordSys());
			ppI.joinRing(plsPlane[ipl], _kAdd);
			if(dContourThickness>0)
			{ 
				ppI.shrink(-.5 * dContourThickness);
				PlaneProfile ppContour = ppI;
				ppI.shrink(dContourThickness);
				ppContour.subtractProfile(ppI);
				dpPlane.draw(ppContour, _kDrawFilled);
			}
		}//next ipl
	}
	
	dpSpaceVolume.draw(bdSpace);
	//dpSpaceVolumeHidden.draw(bdSpace);
	// hatch area
	//int iHatch = sNoYes.find(sHatch);
	int iHatch = true;
	
	int iSolidHatch=0;
	int iSolidTransparency = 0;
	int iSolidColor = 0;
	int iHasSolidColor = 0;
	//int isActive=mapHatch.getInt("isActive");
	
	String sPattern = "ANSI31";// hatch pattern
	int iColor = 1;// color index
	int iTransparency = 0;// transparency
	double dAngle = 0;// hatch angle
	double dScale = 10.0;// hatch scale
	double dScaleMin = 25;// dScaleMin
	int iStatic = 0;// by default make dynamic
	//if(isActive && iHatch)
	int iHatchSolid=sNoYes.find(sHatchSolidVisibility);
	int iHatchPattern=sNoYes.find(sHatchPatternVisibility);
	if(iHatch)
	{ 
	//	Map m = mapHatch;
	//	String ss;
	//	// ---
	//	ss = "SolidHatch"; if(m.hasInt(ss)) 
	//	{
	//		iSolidHatch = m.getInt(ss);
	//		if(iSolidHatch<=0)
	//			iSolidHatch = 0;
	//		else
	//			iSolidHatch = 1;
	//	}
	//	ss = "SolidTransparency"; if(m.hasInt(ss)) iSolidTransparency = m.getInt(ss);
	//	ss = "SolidColor"; if(m.hasInt(ss)) iSolidColor = m.getInt(ss);
	//	ss = "SolidColor"; iHasSolidColor= m.hasInt(ss);
	//	// ---
	//	ss = "Pattern"; if(m.hasString(ss)) sPattern = m.getString(ss);
	//	ss = "Color"; if(m.hasInt(ss)) iColor = m.getInt(ss);
	//	ss = "Transparency"; if(m.hasInt(ss)) iTransparency = m.getInt(ss);
	//	ss = "Angle"; if(m.hasDouble(ss)) dAngle = m.getDouble(ss);
	//	ss = "Scale"; if(m.hasDouble(ss)) dScale = m.getDouble(ss);
	//	ss = "ScaleMin"; if(m.hasDouble(ss)) dScaleMin = m.getDouble(ss);
	//	ss = "Static"; if(m.hasInt(ss)) 
	//	{
	//		iStatic = m.getInt(ss);
	//		if(iStatic<=0)
	//			iStatic = 0;
	//		else
	//			iStatic = 1;
	//	}
	//	LineSeg seg = ppSpaceHorReal.extentInDir(_XW);
	//	double dX = abs(_XW.dotProduct(seg.ptStart() - seg.ptEnd()));
	//	double dY = abs(_YW.dotProduct(seg.ptStart() - seg.ptEnd()));
	//	double dMin = dX < dY ? dX : dY;
		double dScaleFac = dScale;
		if (dScaleFac < 0.01)dScaleFac = 1;
	//	double dScale0 = dScaleMin;
	//	if (iStatic)
	//	{
	//		// static, not adapted to the size, get the factor defined in dScale
	//		dScale0 = dScaleFac;
	//		if (dScale0 < dScaleMin)
	//		{ 
	//			dScale0 = dScaleMin;
	//		}
	//	}
	//	else
	//	{ 
	//		// dynamic, adapted to the minimum dimension
	//		// should not be smaller then dScaleMin
	//		dScale0 = dScaleFac * dMin;
	//		if (dScale0 < dScaleMin)
	//		{ 
	//			dScale0 = dScaleMin;
	//		}
	//	}
		double dGlobalScaling = 1;
	//	dScale0 *= dGlobalScaling;
		double dScale0=1;
		if(dHatchPatternScale>0)
		{ 
			dScale0 = dHatchPatternScale;
		}
		if(nHatchPatternColor>-3)
		{ 
			iColor = nHatchPatternColor;
		}
		if (iColor < 1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (iColor == -2)
			{ 
				// get color from entity (beam) and use this for the hatch
				iColor = _ThisInst.color();
			}
			else if (iColor <- 2)
			{ 
				//iColor <- 2; -3,-4,-5 etc then take by entity
				iColor = - 2;
			}
		}
		if(nHatchSolidColor>-3)
		{ 
			iSolidColor = nHatchSolidColor;
		}
		if (iSolidColor < 1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (iSolidColor == -2)
			{ 
				// get color from entity (beam) and use this for the hatch
				iSolidColor = _ThisInst.color();
			}
			else if (iSolidColor <- 2)
			{ 
				//iColor <- 2; -3,-4,-5 etc then take by entity
				iSolidColor = - 2;
			}
		}
		dAngle = dHatchPatternAngle;
		sPattern = sHatchPattern;
		int nPattern = _HatchPatterns.findNoCase(sPattern, 0);
		sPattern = nPattern >- 1 ? _HatchPatterns[nPattern] : _HatchPatterns[0];
		Hatch hatch(sPattern, dScale0);
		double dRotation = 0;
		double dRotationTotal = dAngle + dRotation;
		hatch.setAngle(dRotationTotal);
		dpHatch.color(iColor);
		
		
		int _iTransparency=iTransparency;
		
		int _iSolidTransparency=iSolidTransparency;
		if(nHatchSolidTransparency>100)
			nHatchSolidTransparency.set(100);
		if(nHatchSolidTransparency<1)
			nHatchSolidTransparency.set(-1);
		_iSolidTransparency = nHatchSolidTransparency;
		
		if(nHatchPatternTransparency>100)
			nHatchPatternTransparency.set(100);
		if(nHatchPatternTransparency<1)
			nHatchPatternTransparency.set(-1);
		_iTransparency = nHatchPatternTransparency;
		
	//	double dGlobalTransparency=1;
	//	if(dGlobalTransparency<=0)
	//	{ 
	//		_iTransparency = 0;
	//		_iSolidTransparency = 0;
	//	}
	//	else if(dGlobalTransparency>0 && dGlobalTransparency<1)
	//	{ 
	//		_iTransparency = iTransparency * dGlobalTransparency;
	//		_iSolidTransparency=iSolidTransparency* dGlobalTransparency;
	//	}
	//	else if(dGlobalTransparency>1 && dGlobalTransparency<100)
	//	{ 
	////				_iTransparency = 100 - ((100 - iTransparency) / dGlobalTransparency);
	////				_iSolidTransparency = 100 - ((100 - iSolidTransparency) / dGlobalTransparency);
	//		_iTransparency = iTransparency+dGlobalTransparency*((100 - iTransparency) / 99);
	//		_iSolidTransparency = iSolidTransparency+dGlobalTransparency*((100 - iSolidTransparency) / 99);
	//	}
	//	else if(dGlobalTransparency>=100)
	//	{ 
	//		_iTransparency = 100;
	//		_iSolidTransparency = 100;
	//	}
		dpHatch.transparency(_iTransparency);
		if(iHatchPattern)
			dpHatch.draw(ppSpaceHorReal, hatch);
		
		dpHatch.color(iSolidColor);
		if(iHatchSolid)
			dpHatch.draw(ppSpaceHorReal, _kDrawFilled, _iSolidTransparency);
		
	}
	int iMoved;
	if(!_Map.hasPoint3d("Position"))
	{ 
		_Map.setPoint3d("Position", _Pt0, _kAbsolute);
	}
	else if (_Map.hasPoint3d("Position") && !iAlignedEntity)
	{
		if((_Pt0-_Map.getPoint3d("Position")).length()>dEps)
		{ 
			iMoved = true;
		}
		if(iMoved)
		{ 
			_Map.setPoint3d("Position", _Pt0, _kAbsolute);
			dZheight.set(_Pt0.Z());
		}
	}
	//if(_PtG.length()==0)
	//{ 
	//	// at ptg for text
	//	Point3d ptTextInit;
	//	ptTextInit.setToAverage(pts);
	//	_PtG.append(ptTextInit);
	//}
	
	_ThisInst.setAllowGripAtPt0(false);
	//double dTextHeightStyle = dpText.textHeightForStyle("Area", sDimStyle);
	//double dScale = dTextHeight / dTextHeightStyle;
	//dpText.dimStyle(sDimStyle, 50);;
	//dpText.textHeight(dTextHeight);
	dpText.textHeight(U(200));
	dpText.addViewDirection(_ZW);
	//if(_DimStyles.find("hsb050")>-1)
	//{ 
	//	dpText.dimStyle("hsb050");;
	//	
	//}
	//_PtG[0] = pn.closestPointTo(_PtG[0]);
	Point3d ptText = _PtG[_PtG.length()-1];
	_Pt0+=_XW*_XW.dotProduct(ptText-_Pt0);
	_Pt0+=_YW*_YW.dotProduct(ptText-_Pt0);
	//_Pt0 = ptText;
	Map mapTexts = mapDisplayStyle.getMap("Text[]");
	Map mapNumber, mapName, mapVolume, mapArea, mapPerimeter;
	
	String sText;
	double dTextY = 0;
	double dTextHeight;
	double dTextHeightPrev;
	double dTextGapExtra = U(80);
	//double dArea = ppSpace.area()/1000000;
	double dArea = ppSpaceHorReal.area()/1000000;
	String sArea;
	sArea.format("%.3f", dArea);
	
	//double dVolume = dArea * dHeight / 1000;
	double dVolume = bdSpace.volume()/(1e9);
	String sVolume;
	sVolume.format("%.3f", dVolume);
	
	//double dLength = pl.length()/1000;
	double dLength = plReal.length()/1000;
	String sLength;
	sLength.format("%.3f", dLength);
	
	if(iLegend)
	{ 
		for (int imap=0;imap<mapTexts.length();imap++) 
		{ 
			Map mapI = mapTexts.getMap(imap);
			if(mapI.getInt("isVisible"))
			{ 
				dpText = Display(2);
				dpText.textHeight(U(200));
				dpText.addViewDirection(_ZW);
				dTextHeight = mapI.getDouble("TextHeight");
				dpText.textHeight(dTextHeight);
				String sTitle = mapI.getString("Title");
				dpText.color(mapI.getInt("TextColor"));
				String sDimStyle;
				if(_DimStyles.find(mapI.getString("DimStyle")))
					sDimStyle = mapI.getString("DimStyle");
				if(sDimStyle!="")
				{
					dpText.dimStyle(sDimStyle);
					dpText.textHeight(dTextHeight);
	//				dTextHeight = dpText.textHeightForStyle("123ABcde",sDimStyle, dTextHeight);
				}
	//			dTextHeightPrev = dTextHeight;
				if(mapI.getString("Name")=="SpaceNumber" && sNumber.length()>0)
				{ 
					if(dTextHeightPrev>0)
						ptText -= _YW * (.5*(dTextHeight+dTextHeightPrev)+dTextGapExtra);
					sText = "";
					if(sTitle!="")
						sText = sTitle;
					dpText.draw(sText, ptText, _XW, _YW, -1, 0);
					sText =" "+sNumber;
					dpText.draw(sText, ptText, _XW, _YW, 1, 0);
					dTextY -= 2.5;
					dTextHeightPrev = dTextHeight;
				}
				else if(mapI.getString("Name")=="SpaceName" && sName.length()>0)
				{ 
					if(dTextHeightPrev>0)
						ptText -= _YW * (.5*(dTextHeight+dTextHeightPrev)+dTextGapExtra);
					sText = "";
					if(sTitle!="")
						sText = sTitle;
					dpText.draw(sText, ptText, _XW, _YW, -1, 0);
					sText =" "+sName;
					dpText.draw(sText, ptText, _XW, _YW, 1, 0);
					dTextY -= 2.5;
					dTextHeightPrev = dTextHeight;
				}
				else if(mapI.getString("Name")=="Fläche")
				{ 
					if(dTextHeightPrev>0)
						ptText -= _YW * (.5*(dTextHeight+dTextHeightPrev)+dTextGapExtra);
					sText = "";
					if(sTitle!="")
						sText = sTitle;
					dpText.draw(sText, ptText, _XW, _YW, -1, 0);
					sText =" "+sArea;
					dpText.draw(sText, ptText, _XW, _YW, 1, 0);
					dTextY -= 2.5;
					
					dTextHeightPrev = dTextHeight;
				}
				else if(mapI.getString("Name")=="Volumen")
				{ 
					if(dTextHeightPrev>0)
						ptText -= _YW * (.5*(dTextHeight+dTextHeightPrev)+dTextGapExtra);
		
					sText = "";
					if(sTitle!="")
						sText = sTitle;
					dpText.draw(sText, ptText, _XW, _YW, -1, 0);
					sText = " "+sVolume;
					dpText.draw(sText, ptText, _XW, _YW, 1, 0);
					dTextY -= 2.5;
					
					dTextHeightPrev = dTextHeight;
					
				}
				else if(mapI.getString("Name")=="Umfang")
				{ 
					if(dTextHeightPrev>0)
						ptText -= _YW * (.5*(dTextHeight+dTextHeightPrev)+dTextGapExtra);
					sText = "";
					if(sTitle!="")
						sText = sTitle;
					dpText.draw(sText, ptText, _XW, _YW, -1, 0);
					sText = " "+sLength;
					dpText.draw(sText, ptText, _XW, _YW, 1, 0);
					dTextY -= 2.5;
					
					dTextHeightPrev = dTextHeight;
				}
				else if(mapI.getString("Name")=="Material1" && sMaterial1.length()>0)
				{ 
					if(dTextHeightPrev>0)
						ptText -= _YW * (.5*(dTextHeight+dTextHeightPrev)+dTextGapExtra);
					sText = "";
					if(sTitle!="")
						sText = sTitle;
					dpText.draw(sText, ptText, _XW, _YW, -1, 0);
					sText =" "+sMaterial1;
					dpText.draw(sText, ptText, _XW, _YW, 1, 0);
					dTextY -= 2.5;
					dTextHeightPrev = dTextHeight;
				}
				else if(mapI.getString("Name")=="Material2" && sMaterial2.length()>0)
				{ 
					if(dTextHeightPrev>0)
						ptText -= _YW * (.5*(dTextHeight+dTextHeightPrev)+dTextGapExtra);
					sText = "";
					if(sTitle!="")
						sText = sTitle;
					dpText.draw(sText, ptText, _XW, _YW, -1, 0);
					sText =" "+sMaterial2;
					dpText.draw(sText, ptText, _XW, _YW, 1, 0);
					dTextY -= 2.5;
					dTextHeightPrev = dTextHeight;
				}
			}
		}//next imap
	}
		
	if(_kNameLastChangedProp=="_Pt0")
	{ 
		// pt0 modified, update zheight
		dZheight.set(_Pt0.Z());
	}
	
	//
	// trigger with jigging
	{ 
	//region Trigger AddVertex
		String sTriggerAddVertex = T("|Add Point|");
		if(nType==0)
			addRecalcTrigger(_kContextRoot, sTriggerAddVertex );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddVertex)
		{
			String sStringStart = "|Select new point|";
			String sStringStart2 = "|Select new point or [";
			String sStringOption = "Undo/Finish]";
			String sStringEdge = "|Select Edge for point|";
			String sStringEdge2 = "|Select Edge for point|";
			String sStringOptionEdge = "Undo/Finish/Edge]";
			
			
			String sStringPrompt = T(sStringEdge);
			
			PrPoint ssP(sStringPrompt);
			Map mapArgs;
			int nGoJig = -1;
			
			Point3d _pts[0];
			_pts.append(_PtG);
			_pts.removeAt(_pts.length() - 1);
			Point3d ptsAll[0];
			ptsAll.append(_pts);
			
			mapArgs.setPoint3dArray("pts", _pts);
			mapArgs.setInt("jigMode", 0);// edge mode
			
			Point3d ptsInserted[0];
			int iIndexInserted[0];
			
			while (nGoJig != _kNone)
			{
				nGoJig = ssP.goJig(strJigAction3, mapArgs);
				if(nGoJig==_kOk)
				{ 
					Point3d ptLast = ssP.value();
					Vector3d vecView = getViewDirection();
					ptLast=Line(ptLast, vecView).intersect(Plane(_Pt0, _ZW), U(0));
					// point is clicked
					if(mapArgs.getInt("jigMode")==0)
					{ 
						// edge mode, set edge index
						if (mapArgs.hasPoint3dArray("pts"))
						{
							Point3d _pts[] = mapArgs.getPoint3dArray("pts");
							_pts.append(_pts[0]);
							int iEdge = -1;
							double dDist = U(10e6);
							for (int ipt=0;ipt<_pts.length()-1;ipt++) 
							{ 
								Point3d pt1 = _pts[ipt];
								Point3d pt2 = _pts[ipt+1];
								Vector3d vecI = pt2 - pt1;vecI.normalize();
								Line lnI(pt1, vecI);
								double dDistI = (lnI.closestPointTo(ptLast)-ptLast).length();
								if(dDistI<dDist)
								{ 
									iEdge = ipt;
									dDist = dDistI;
								}
							}//next ipt
							if(iEdge>-1)
								mapArgs.setInt("iEdge", iEdge);
						}
						
						// go to vertex mode
						mapArgs.setInt("jigMode", 1);
	//					String sStringPrompt = sStringStart2+sStringOption;
						String sStringPrompt = sStringStart;
						ssP = PrPoint(sStringPrompt);
					}
					else if(mapArgs.getInt("jigMode")==1)
					{ 
						// vertex mode
						int iEdge = mapArgs.getInt("iEdge");
						PLine plNew;
						Point3d ptsNew[0];
						Point3d _pts[] = mapArgs.getPoint3dArray("pts");
						for (int ipt=0;ipt<_pts.length();ipt++) 
						{ 
							ptsNew.append(_pts[ipt]);
							plNew.addVertex(_pts[ipt]);
							if(ipt==iEdge)
							{ 
								ptsNew.append(ptLast);
								plNew.addVertex(ptLast);
							}
						}//next ipt
						mapArgs.setPoint3dArray("pts", ptsNew);
						
						ptsInserted.append(ptLast);
						// go to edge mode
						mapArgs.setInt("jigMode", 0);
						String sStringPrompt = T(sStringEdge);
						ssP = PrPoint(sStringPrompt);
					}
				}
				else if(nGoJig==_kKeyWord)
				{ 
					if (ssP.keywordIndex() >= 0)
					{
						if (ssP.keywordIndex() == 0 )
						{
						// undo is selected
							Point3d _pts[]=mapArgs.getPoint3dArray("pts");
							for (int ipt=0;ipt<_pts.length();ipt++) 
							{ 
								if((_pts[ipt]-ptsInserted[ptsInserted.length()-1]).length()<dEps)
								{ 
									_pts.removeAt(ipt);
									ptsInserted.removeAt(ptsInserted.length()-1);
									break;
								}
							}//next ipt
							if(ptsInserted.length()==0)
							{ 
							// no extra point
								// go to edge mode
								mapArgs.setInt("jigMode", 0);
								String sStringPrompt = T(sStringEdge);
								ssP = PrPoint(sStringPrompt);
							}
						}
					}
				}
				else if(nGoJig==_kNone)
				{ 
					Point3d _pts[] = mapArgs.getPoint3dArray("pts");
					Point3d ptTxt = _PtG[_PtG.length() - 1];
					_PtG.setLength(0);
					_PtG.append(_pts);
					_PtG.append(ptText);
				}
			}
			
			setExecutionLoops(2);
			return;
		}//endregion	
	
	//region Trigger RemoveVertex
		String sTriggerRemoveVertex = T("|Remove Point|");
		if(nType==0)
			addRecalcTrigger(_kContextRoot, sTriggerRemoveVertex );
		if (_bOnRecalc && _kExecuteKey==sTriggerRemoveVertex)
		{
			String sStringStart = "|Select point to delete|";
			String sStringStart2 = "|Select point or [";
			String sStringOption = "Undo/Finish]";
	//		String sStringOption = "Finish]";
			String sStringPrompt = T(sStringStart);
			
			PrPoint ssP(sStringPrompt);
			Map mapArgs;
			int nGoJig = -1;
			Point3d _pts[0];
			_pts.append(_PtG);
			_pts.removeAt(_pts.length() - 1);
			Point3d ptsAll[0];
			ptsAll.append(_pts);
			mapArgs.setPoint3dArray("pts", _pts);
			if(iAligned)
			{ 
				mapArgs.setPoint3d("ptPlane",_Map.getPoint3d("ptPlane"));
				mapArgs.setVector3d("vecPlane",_Map.getVector3d("vecPlane"));
			}
			else if(iAlignedEntity)
			{ 
				Entity entTsl = _Map.getEntity("TslAlign");
				TslInst tsl = (TslInst)entTsl;
				mapArgs.setPoint3d("ptPlane",tsl.map().getPoint3d("ptPlaneTop"));
				mapArgs.setVector3d("vecPlane",tsl.map().getVector3d("vecPlaneTop"));
			}
			Point3d ptsDeleted[0];
			int iIndexDeleted[0];
			while (nGoJig != _kNone)
			{
				nGoJig = ssP.goJig(strJigAction2, mapArgs); 
				if(nGoJig==_kOk)
				{ 
					// point is clicked
					Point3d ptLast = ssP.value();
					Vector3d vecView = getViewDirection();
					ptLast=Line(ptLast, vecView).intersect(Plane(_Pt0, _ZW), U(0));
					if (mapArgs.hasPoint3dArray("pts"))
					{
						Point3d _pts[] = mapArgs.getPoint3dArray("pts");
						// get index of closest point with the jig point
						int iIndex = -1;
						double dDist = U(10e6);
						for (int ipt=0;ipt<_pts.length();ipt++) 
						{ 
							if((_pts[ipt]-ptLast).length()<dDist)
							{ 
								dDist = (_pts[ipt] - ptLast).length();
								iIndex = ipt;
							}
						}//next ipt
						int iIndexAll = -1;
						double dDistAll = U(10e6);
						for (int ipt=0;ipt<ptsAll.length();ipt++) 
						{ 
							if((ptsAll[ipt]-ptLast).length()<dDistAll)
							{ 
								dDistAll = (ptsAll[ipt] - ptLast).length();
								iIndexAll = ipt;
							}
						}//next ipt
						ptsDeleted.append(_pts[iIndex]);
						iIndexDeleted.append(iIndexAll);
						_pts.removeAt(iIndex);
						mapArgs.setPoint3dArray("pts", _pts);
					}
					if(ptsDeleted.length()>0)
					{ 
						sStringPrompt = sStringStart2 + sStringOption;
						ssP = PrPoint(sStringPrompt);
					}
				}
				else if(nGoJig==_kKeyWord)
				{ 
					if (ssP.keywordIndex() >= 0)
					{ 
						if(ssP.keywordIndex()==0 )
						{ 
							// undo is selected
							Point3d _pts[0];
	//						_pts= mapArgs.getPoint3dArray("pts");
	//						_pts.append(ptsDeleted[ptsDeleted.length() - 1]);
							int iIndexAll = iIndexDeleted[iIndexDeleted.length() - 1];
							ptsDeleted.removeAt(ptsDeleted.length() - 1);
							iIndexDeleted.removeAt(iIndexDeleted.length() - 1);
							for (int ipt=0;ipt<ptsAll.length();ipt++) 
							{ 
								if(iIndexDeleted.find(ipt)>-1)
								{ 
									continue;
								}
								_pts.append(ptsAll[ipt]);
							}//next ipt
							mapArgs.setPoint3dArray("pts", _pts);
							if(ptsDeleted.length()==0)
							{ 
								sStringPrompt = sStringStart;
								ssP = PrPoint(sStringPrompt);
							}
						}
						else if(ssP.keywordIndex()==1)
						{ 
							// finish is selected
							Point3d _pts[] = mapArgs.getPoint3dArray("pts");
							Point3d ptTxt = _PtG[_PtG.length() - 1];
							_PtG.setLength(0);
							_PtG.append(_pts);
							_PtG.append(ptText);
							nGoJig = _kNone;
						}
					}
				}
				else if(nGoJig==_kNone)
				{ 
					Point3d _pts[] = mapArgs.getPoint3dArray("pts");
					Point3d ptTxt = _PtG[_PtG.length() - 1];
					_PtG.setLength(0);
					_PtG.append(_pts);
					_PtG.append(ptText);
				}
			}
			
			setExecutionLoops(2);
			return;
		}//endregion	
	
	// trigger to add slope neigung at an edge
	//region Trigger AddSlopeAtEdge
		String sTriggerAddSlopeAtEdge = T("|Add Slope At Edge|");
		if(nType==0)
			addRecalcTrigger(_kContextRoot, sTriggerAddSlopeAtEdge );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddSlopeAtEdge)
		{
			String sStringEdge = "|Select Edge for slope|";
			String sStringPrompt = T(sStringEdge);
			PrPoint ssP(sStringPrompt);
			Map mapArgs;
			int nGoJig = -1;
			Point3d _pts[0];
			_pts.append(_PtG);
			_pts.removeAt(_pts.length() - 1);
	//		_pts.append(_pts[0]);
			Point3d ptsAll[0];
			ptsAll.append(_pts);
			mapArgs.setPoint3dArray("pts", _pts);
	//		if(_Map.hasPoint3d("ptPlane") && _Map.hasVector3d("vecPlane"))
			if(iAligned)
			{ 
				mapArgs.setPoint3d("ptPlane",_Map.getPoint3d("ptPlane"));
				mapArgs.setVector3d("vecPlane",_Map.getVector3d("vecPlane"));
			}
			else if(iAlignedEntity)
			{ 
				Entity entTsl = _Map.getEntity("TslAlign");
				TslInst tsl = (TslInst)entTsl;
				mapArgs.setPoint3d("ptPlane",tsl.map().getPoint3d("ptPlaneTop"));
				mapArgs.setVector3d("vecPlane",tsl.map().getVector3d("vecPlaneTop"));
			}
			while (nGoJig != _kNone)
			{
				nGoJig = ssP.goJig(strJigAction5, mapArgs);
				if (nGoJig == _kOk)
				{
					Point3d ptLast = ssP.value();
					Vector3d vecView = getViewDirection();
					ptLast = Line(ptLast,vecView).intersect(pn, U(0));
					if (mapArgs.hasPoint3dArray("pts"))
					{
						Point3d _pts[] = mapArgs.getPoint3dArray("pts");
						_pts.append(_pts[0]);
						int iEdge = -1;
						double dDist = U(10e6);
						for (int ipt=0;ipt<_pts.length()-1;ipt++) 
						{ 
							Point3d pt1 = _pts[ipt];
							Point3d pt2 = _pts[ipt+1];
							Vector3d vecI = pt2 - pt1;vecI.normalize();
							Line lnI(pt1, vecI);
							double dDistI = (lnI.closestPointTo(ptLast)-ptLast).length();
							if(dDistI<dDist)
							{ 
								iEdge = ipt;
								dDist = dDistI;
							}
						}//next ipt
						if(iEdge>-1)
						{
							mapArgs.setInt("iEdge", iEdge);
	//						nEdgeIndex.set(iEdge + 1);
						}
						_Map.setInt("indexEdgeSlope", iEdge);
						_Map.setInt("VertexSlope", false);
					}
					// prompt slope
					double _dSlope;
					String sSlope = getString(T("|Enter Slope in|")+" % "+T("|Or|")+ " ["+T("|Degree|")+" ]");
					if(sSlope=="D")
					{ 
						String sSlopeDegree = getString(T("|Enter Slope in Degree|"));
						double dSlopeDegree = sSlopeDegree.atof();
						_dSlope = tan(dSlopeDegree)*100;
					}
					else
					{
						_dSlope = sSlope.atof();
					}
					_Map.setDouble("Slope", _dSlope);
					dSlope.set(_dSlope);
					nGoJig = _kNone;
				}
			}
			setExecutionLoops(2);
			return;
		}//endregion	
		
	// trigger to set back to horizontal plane
	//region Trigger SetToHorizontalPlane
		String sTriggerSetToHorizontalPlane = T("|Set To Horizontal Plane|");
		if(nType==0)
		if(iAligned || iAlignedEntity)
			addRecalcTrigger(_kContextRoot, sTriggerSetToHorizontalPlane );
		if (_bOnRecalc && _kExecuteKey==sTriggerSetToHorizontalPlane)
		{
			
			_Map.removeAt("ptPlane", true);
			_Map.removeAt("vecPlane", true);
			if(iAlignedEntity)
			{ 
				Entity entTsl = _Map.getEntity("TslAlign");
				TslInst tsl = (TslInst)entTsl;
				if(_Entity.find(tsl)>-1)
				{ 
					_Entity.removeAt(_Entity.find(tsl));
				}
				_Map.removeAt("TslAlign",true);
			}
			_Map.setInt("AlignFaces",false);
			setExecutionLoops(2);
			return;
		}//endregion	
	
	
	////region Trigger Align
	//	String sTriggerAlign = T("|Align|");
	//	addRecalcTrigger(_kContextRoot, sTriggerAlign );
	//	if (_bOnRecalc && _kExecuteKey==sTriggerAlign)
	//	{
	//		_Map.setInt("iCleanupDummy", true);
	//		String sPromptOrigin1="Basispunkt angeben";
	//		String sPromptOrigin2="Zweiten Punkt angeben";
	//		String sPromptOrigin3="Dritten Punkt angeben";
	//		
	//		String sPromptDestination1="Ersten Zielpunkt angeben";
	//		String sPromptDestination2="Zweiten Zielpunkt angeben";
	//		String sPromptDestination3="Dritten Zielpunkt angeben";
	//		
	//		// create a copy of the tsl to serve for the preview
	//	// create TSL
	//		TslInst tslNew;	Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
	//		GenBeam gbsTsl[] = {}; Entity entsTsl[] = {}; 
	//		Point3d ptsTsl[] = {_Pt0};
	//		ptsTsl.append(pl.vertexPoints(true));
	//		ptsTsl.append(_Pt0);
	//		int nProps[]={nEdgeIndex}; 
	//		double dProps[]={dZheight,dHeight,dSlope}; 
	//		String sProps[]={sNumber,sName,sLegend,sDisplayStyle};
	//		Map mapTsl;	
	//		mapTsl = _Map;
	//		mapTsl.setInt("isDummy", true);
	//		tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
	//			ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
	//		_Map.setEntity("Dummy", tslNew);
	//		
	//		PrPoint ssP(sPromptOrigin1);
	//		// origin
	//		Point3d ptOrigin1,ptOrigin2, ptOrigin3;
	//		int iOrigin1,iOrigin2, iOrigin3;
	//		// destination
	//		Point3d ptDestination1,ptDestination2,ptDestination3;
	//		Map mapArgs;
	//		int nGoJig = -1;
	//		Point3d _pts[0];
	//		while (nGoJig != _kNone)
	//		{
	//			nGoJig = ssP.goJig(strJigAction4, mapArgs);
	//			if(nGoJig==_kOk)
	//			{ 
	//				Point3d ptLast = ssP.value();
	//				if(mapArgs.hasPoint3dArray("pts"))
	//				{
	//					_pts = mapArgs.getPoint3dArray("pts");
	//					
	//					if(_pts.length()==1)
	//					{ 
	//						String sStringPrompt = sPromptOrigin3;
	//						ssP = PrPoint(sStringPrompt);
	//						ptOrigin2 = ptLast;
	//					}
	//					if(_pts.length()==2)
	//					{ 
	//						String sStringPrompt = sPromptDestination1;
	//						ssP = PrPoint(sStringPrompt);
	//						ptOrigin3 = ptLast;
	//					}
	//					else if(_pts.length()==3)
	//					{ 
	//						String sStringPrompt = sPromptDestination2;
	//						ssP = PrPoint(sStringPrompt);
	//						ptDestination1 = ptLast;
	//					}
	//					else if(_pts.length()==4)
	//					{ 
	//						String sStringPrompt = sPromptDestination3;
	//						ssP = PrPoint(sStringPrompt);
	//						ptDestination2= ptLast;
	//					}
	//					else if(_pts.length()==5)
	//					{ 
	//						nGoJig = _kNone;
	//						ptDestination3= ptLast;
	//					}
	//					_pts.append(ptLast);
	//					mapArgs.setPoint3dArray("pts", _pts);
	//				}
	//				else
	//				{
	//					_pts.setLength(0);
	//					_pts.append(ptLast);
	//					ptOrigin1 = ptLast;
	//					mapArgs.setPoint3dArray("pts", _pts);
	//					String sStringPrompt = sPromptOrigin2;
	//					ssP = PrPoint(sStringPrompt);
	//				}
	//				
	//			}
	//			else if(nGoJig==_kNone)
	//			{ 
	//				tslNew.dbErase();
	//			}
	//			
	//		}
	//		// origin
	//		// delete the dummy tsl
	//		tslNew.dbErase();
	//		_Map.removeAt("Dummy", true);
	//		
	//		if(_pts.length()<6)
	//		{ 
	//			setExecutionLoops(2);
	//			return;
	//		}
	//		// check that 3 points define a plane
	//		if((ptOrigin2-ptOrigin1).length()<dEps)
	//		{ 
	//			
	//		}
	//		// 
	//		Vector3d vecX1 = ptOrigin2 - ptOrigin1;vecX1.normalize();
	//		Vector3d vec2=ptOrigin3 - ptOrigin1;vecX1.normalize();
	//		Vector3d vecNormal = vecX1.crossProduct(vec2);
	//		vecNormal.normalize();
	//		if(vecNormal.dotProduct(_ZW)<0)vecNormal*=-1;
	//		Vector3d vecY1 = vecNormal.crossProduct(vecX1);
	//		
	//		// destination
	//		Vector3d _vecX1=ptDestination2 - ptDestination1;_vecX1.normalize();
	//		Vector3d _vec2=ptDestination3 - ptDestination1;_vec2.normalize();
	//		Vector3d _vecNormal = _vecX1.crossProduct(_vec2);
	//		_vecNormal.normalize();
	//		if(_vecNormal.dotProduct(_ZW)<0)_vecNormal*=-1;
	//		Vector3d _vecY1 = _vecNormal.crossProduct(_vecX1);
	//		
	//		_Map.setPoint3d("ptOrig", ptOrigin1);
	//		_Map.setVector3d("vecX1", vecX1);
	//		_Map.setVector3d("vecY1", vecY1);
	//		_Map.setVector3d("vecNormal", vecNormal);
	//		
	//		_Map.setPoint3d("ptDestination", ptDestination1);
	//		_Map.setVector3d("_vecX1", _vecX1);
	//		_Map.setVector3d("_vecY1", _vecY1);
	//		_Map.setVector3d("_vecNormal", _vecNormal);
	//		
	//		
	//		// save the plane by point and normal
	//		_Map.setPoint3d("ptPlane",ptDestination1,_kAbsolute);
	//		_Map.setVector3d("vecPlane", _vecNormal,_kFixedSize);
	//		
	//		// transform pline and grip points
	//		CoordSys csAlign;
	//		csAlign.setToAlignCoordSys(ptOrigin1,vecX1,vecY1,vecNormal,
	//		ptDestination1,_vecX1,_vecY1,_vecNormal);
	//		PLine plAlign = pl;
	//		plAlign.transformBy(csAlign);
	//		_Map.setPLine("Pline", plAlign);
	//		for (int i=0;i<_PtG.length();i++) 
	//		{ 
	//			_PtG[i].transformBy(csAlign); 
	//		}//next i
	//		_Pt0.transformBy(csAlign); 
	//		
	//		setExecutionLoops(2);
	//		return;
	//	}//endregion	
		
	//region Trigger AlignToEntity
		String sTriggerAlignToEntity = T("|Align To Entity|");
		if(nType==0)
			addRecalcTrigger(_kContextRoot, sTriggerAlignToEntity );
		if (_bOnRecalc && _kExecuteKey==sTriggerAlignToEntity)
		{
			TslInst tsl = getTslInst(T("|Select Entity|"));
			
			if(tsl.bIsValid())
			{ 
				_Map.setEntity("TslAlign", tsl);
				_Map.removeAt("ptPlane", true);
				_Map.removeAt("vecPlane", true);
			}
			
			setExecutionLoops(2);
			return;
		}//endregion
		
		
	//region Trigger AddSlopeAtVertex
		// supported only for triangles
		String sTriggerAddSlopeAtVertex = T("|Add Slope At Vertex|");
	//	if(_PtG.length()==4)
	//	{
	//		addRecalcTrigger(_kContextRoot, sTriggerAddSlopeAtVertex );
	//		nVertexIndex.setReadOnly(false);
	//	}
	//	else
	//	{ 
	//		nVertexIndex.setReadOnly(true);
	//	}
	//	if (_bOnRecalc && _kExecuteKey==sTriggerAddSlopeAtVertex)
	//	{
	//		String sStringStart = "|Select vertex point|";
	//		String sStringPrompt = T(sStringStart);
	//		
	//		PrPoint ssP(sStringPrompt);
	//		Map mapArgs;
	//		int nGoJig = -1;
	//		
	//		Point3d _pts[0];
	//		_pts.append(_PtG);
	//		_pts.removeAt(_pts.length() - 1);
	//		
	//		mapArgs.setPoint3dArray("pts", _pts);
	//		if(iAligned)
	//		{ 
	//			mapArgs.setPoint3d("ptPlane",_Map.getPoint3d("ptPlane"));
	//			mapArgs.setVector3d("vecPlane",_Map.getVector3d("vecPlane"));
	//		}
	//		else if(iAlignedEntity)
	//		{ 
	//			Entity entTsl = _Map.getEntity("TslAlign");
	//			TslInst tsl = (TslInst)entTsl;
	//			mapArgs.setPoint3d("ptPlane",tsl.map().getPoint3d("ptPlaneTop"));
	//			mapArgs.setVector3d("vecPlane",tsl.map().getVector3d("vecPlaneTop"));
	//		}
	//		
	//		while (nGoJig != _kNone)
	//		{
	//			nGoJig = ssP.goJig(strJigAction6, mapArgs);
	//			if (nGoJig == _kOk)
	//			{
	//				Point3d ptLast = ssP.value();
	//				Vector3d vecView = getViewDirection();
	//				ptLast = Line(ptLast, vecView).intersect(Plane(_Pt0, _ZW), U(0));
	//				
	//				int iIndex = - 1;
	//				double dDist = U(10e6);
	//				for (int ipt = 0; ipt < _pts.length(); ipt++)
	//				{
	//					if ((_pts[ipt] - ptLast).length() < dDist)
	//					{
	//						dDist = (_pts[ipt] - ptLast).length();
	//						iIndex = ipt;
	//					}
	//				}//next ipt
	//				if (iIndex >- 1)
	//				{
	//					nVertexIndex.set(iIndex + 1);
	//					_Map.setInt("VertexSlope", true);
	//				}
	//				nGoJig = _kNone;
	//			}
	//		}
	//		setExecutionLoops(2);
	//		return;
	//	}//endregion	
	
	
	//region Trigger AlignFaces
		if(iAlignedEntity)
		{ 
			// see if any edge match and if the command can be reasonable
			int iAlignFacePossible;
			Entity entTsl=_Map.getEntity("TslAlign");
			TslInst tsl=(TslInst)entTsl;
			Vector3d vecNormalUnderneath=tsl.map().getVector3d("vecUnderneath");
			
			Point3d ptVertices[]=pl.vertexPoints(false);
			Body bdUnderneath = tsl.map().getBody("bd");
			PlaneProfile ppUnderneath = bdUnderneath.extractContactFaceInPlane(pn, dEps);
	//			ppUnderneath.vis(6);
			PLine plsUnderneath[]=ppUnderneath.allRings(true,false);
			PLine plUnderneath=plsUnderneath[0];
			Point3d ptVerticesUnderneath[] = plUnderneath.vertexPoints(false);
			// add command "Cut Edges/Do not cut Edges"
			String sTriggerAlignFaces = T("|Align Faces|");
			if(iAlignFaces)
			{ 
				sTriggerAlignFaces = T("|Do not align Faces|");
			}
			int iFaceAlignedAtAll;
			for (int ipt=0;ipt<ptVertices.length()-1;ipt++)
			{ 
				Point3d pt1=ptVertices[ipt];
				Point3d pt2=ptVertices[ipt+1];
				Point3d ptMid=.5*(pt1+pt2);
				Vector3d vec1 = pt2 - pt1;vec1.normalize();
				for (int jpt=0;jpt<ptVerticesUnderneath.length()-1;jpt++)
				{ 
					Point3d _pt1=ptVerticesUnderneath[jpt];
					Point3d _pt2=ptVerticesUnderneath[jpt+1];
					Vector3d _vec1 = _pt2 - _pt1; _vec1.normalize();
					if(abs(abs(vec1.dotProduct(_vec1))-1.0)<dEps)
					{ 
						// parallel, check distance
						double dDist1=(pt1-Line(_pt1,_vec1).closestPointTo(pt1)).length();
						double dDist2=(pt2-Line(_pt1,_vec1).closestPointTo(pt2)).length();
						if(dDist1<dEps && dDist2<dEps)
						{ 
							iFaceAlignedAtAll = true;
							break;
						}
					}
				}//next jpt
				if (iFaceAlignedAtAll)break;
			}
			if(iFaceAlignedAtAll)
			{ 
				addRecalcTrigger(_kContextRoot, sTriggerAlignFaces );
				if (_bOnRecalc && _kExecuteKey==sTriggerAlignFaces)
				{
					if(!iAlignFaces)
					{ 
						_Map.setInt("AlignFaces",!iAlignFaces);
					}
					else if(iAlignFaces)
					{ 
						_Map.setInt("AlignFaces",!iAlignFaces);
					}
					
					setExecutionLoops(2);
					return;
				}//endregion
			}
		}
	}
}
else if(nType==0)
{ 
	int iLegend = sNoYes.find(sLegend);
//int iDisplayStyle = sDisplayStyles.find(sDisplayStyle);
//if(iDisplayStyle<0 && sDisplayStyles.length()>0)
//	sDisplayStyle.set(sDisplayStyles[0]);
//region validation
	if(!_Map.hasPLine("Pline"))	
	{ 
		reportMessage("\n"+scriptName()+" "+T("|one pline is needed|"));
		eraseInstance();
		return;
	}
//End validation//endregion 

	if(_kNameLastChangedProp==sZheightName)
	{ 
		// pt0 modified, update zheight
		_Pt0.setZ(dZheight);
	}
	Plane pn(_Pt0, _ZW);
	Plane pnHor(_Pt0, _ZW);
	int iAligned, iAlignedEntity;
	
	if(_Map.hasPoint3d("ptPlane") && _Map.hasVector3d("vecPlane"))
	{ 
		iAligned = true;
		pn=Plane(_Map.getPoint3d("ptPlane"), _Map.getVector3d("vecPlane"));
		dZheight.setReadOnly(_kReadOnly);
	}
	if(_Map.hasEntity("TslAlign") && _Map.getEntity("TslAlign").bIsValid())
	{ 
	//	if(_Map.hasInt("isDummy"))
	//	{ 
	//		reportMessage("\n"+scriptName()+" "+T("|Dummy|"));
	//		reportMessage("\n"+scriptName()+" "+T("|enters|"));
	//		
	//		
	//	}
		iAlignedEntity = true;
		Entity entTsl = _Map.getEntity("TslAlign");
		TslInst tsl = (TslInst)entTsl;
		Slab slab = (Slab)entTsl;
		if(tsl.bIsValid())
		{ 
			if(_Entity.find(tsl)<0)
			{ 
				_Entity.append(tsl);
			}
			setDependencyOnEntity(tsl);
			pn=Plane(tsl.map().getPoint3d("ptPlaneTop"), tsl.map().getVector3d("vecPlaneTop"));
		}
		else if(slab.bIsValid())
		{ 
			if(_Entity.find(slab)<0)
			{ 
				_Entity.append(slab);
			}
			setDependencyOnEntity(slab);
			
	//		Vector3d vecPlaneTop=slab.pl
			Point3d pts[]=slab.realBody().extremeVertices(-slab.coordSys().vecY());
			pn=Plane(pts[0],slab.coordSys().vecY());
		}
		dZheight.setReadOnly(_kReadOnly);
	}
	else
	{ 
		dZheight.setReadOnly(false);
		if(_bOnDbCreated)
		{ 
			// ondbcreated zheight has priority
			_Pt0.setZ(dZheight);
			pn=Plane(_Pt0, _ZW);
		}
	}
	
	// HSB-15668: check if this instance is controlled by RUB-Stellfüße
	if(_Map.hasInt("RUB-StellfüßeFlag") && _Map.hasEntity("RUB-Stellfüße"))
	{ 
		if(_Map.getInt("RUB-StellfüßeFlag") && _Map.getEntity("RUB-Stellfüße").bIsValid())
		{ 
		// 
			dZheight.setReadOnly(_kReadOnly);
			dHeight.setReadOnly(_kReadOnly);
			dSlope.setReadOnly(_kReadOnly);
		// 
			Entity entTsl = _Map.getEntity("RUB-Stellfüße");
			if(_Entity.find(entTsl)<0)
			{ 
				_Entity.append(entTsl);
			}
			setDependencyOnEntity(entTsl);
		}
		else if(!_Map.getEntity("RUB-Stellfüße").bIsValid())
		{ 
			eraseInstance();
			return;
		}
	}
	
	PLine pl = _Map.getPLine("Pline");
	//initialize grippoints
	if(_PtG.length()==0)
	{ 
	// only once
		Point3d pts[] = pl.vertexPoints(true);
		for (int ip=0;ip<pts.length();ip++) 
		{ 
			_PtG.append(pts[ip]);
		}//next ip
		Point3d ptTxt;
		ptTxt.setToAverage(_PtG);
		_PtG.append(ptTxt);
	}
	
	// Cleanup grippoints at the same location
	{ 
		Point3d ptUniqs[0];
		for (int ipt=0;ipt<_PtG.length()-1;ipt++) 
		{ 
			Point3d ptgI=_PtG[ipt];
			int iUnique=true;
			for (int jpt=0;jpt<ptUniqs.length();jpt++) 
			{ 
				Point3d ptJ = ptUniqs[jpt]; 
				
				if((ptgI-ptJ).length()<dEps)
				{ 
					iUnique = false;
					break;
				}
			}//next jpt
			if (iUnique)ptUniqs.append(ptgI);
		}//next ipt
		Point3d ptText=_PtG[_PtG.length()-1];
		_PtG.setLength(0);
		_PtG.append(ptUniqs);
		_PtG.append(ptText);
	}
	
	if(_PtG.length()>1)
	{ 
		pl = PLine();
		for (int i=0;i<_PtG.length()-1;i++) 
		{ 
	//		_PtG[i]=pn.closestPointTo(_PtG[i]); 
			_PtG[i] = Line(_PtG[i], _ZW).intersect(pn, U(0));
			pl.addVertex(_PtG[i]);
		}//next i
	//	_PtG[_PtG.length() - 1] = pn.closestPointTo(_PtG[_PtG.length() - 1]);
		_PtG[_PtG.length() - 1] = Line(_PtG[_PtG.length() - 1], _ZW).intersect(pn, U(0));
	}
	
	
	
	
	
	Point3d pts[] = pl.vertexPoints(true);
	if(pts.length()<3)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|Polyline must be a closed Polygone|"));
		eraseInstance();
		return;
	}
	
	//nEdgeIndexs.setLength(0);
	//for (int i=0;i<pts.length();i++) 
	//{ 
	//	nEdgeIndexs.append(i + 1);
	//}//next i
	//int iIndexEdgeIndex = nEdgeIndexs.find(nEdgeIndex);
	//if(iIndexEdgeIndex>-1)
	//{
	//	nEdgeIndex=PropInt (0, nEdgeIndexs, sEdgeIndexName,iIndexEdgeIndex);
	//}
	//else
	//{ 
	//	nEdgeIndex=PropInt (0, nEdgeIndexs, sEdgeIndexName,0);
	//	nEdgeIndex.set(nEdgeIndexs[0]);
	//}
	
	//pl.transformBy(_ZW *_ZW.dotProduct(_Pt0-pts[0]));
	pl.projectPointsToPlane(pn, _ZW);
	_Pt0.vis(3);
	Display dpSpacePlane(3);
	Display dpSpaceVolume(3);
	Display dpSpaceVolumeHidden(7);
	dpSpaceVolumeHidden.transparency(100);
	dpSpaceVolume.addHideDirection(_ZW);
	dpSpaceVolume.addHideDirection(-_ZW);
	Display dpText(2);
	pl.close();
	//Plane pn(_Pt0, _ZW);
	PlaneProfile ppSpace(pn);
	ppSpace.joinRing(pl,_kAdd);
	
	PlaneProfile ppSpaceHor(pnHor),ppSpaceHorReal(pnHor);
	pl.vis(5);
	PLine plReal;
	Body bdSpace;
	int iAlignFaces = _Map.getInt("AlignFaces");
	if(!_Map.hasInt("indexEdgeSlope"))
	{
		if(dHeight==0)
		{ 
			dHeight.set(U(5));
			reportMessage("\n"+scriptName()+" "+T("|body generation was not possible|"));
			reportMessage("\n"+scriptName()+" "+T("|Thickness was set to 5mm|"));
		}
		
		if(!iAlignedEntity)
		{ 
			// not aligned
			bdSpace=Body (pl, _ZW * dHeight);
			// 20220429
			Point3d ptPlaneTop = pn.ptOrg()+_ZW*dHeight;
			Vector3d vecPlaneTop = pn.vecZ();
			_Map.setPoint3d("ptPlaneTop",ptPlaneTop,_kAbsolute);
			_Map.setVector3d("vecPlaneTop",_ZW,_kFixedSize);
			// store Body
			_Map.setBody("bd", bdSpace);
		}
		else if(iAlignedEntity)
		{ 
			// aligned to entity
			Vector3d vecNormalPn = pn.vecZ();
			vecNormalPn.normalize();
			if(!iAlignFaces)
			{
				bdSpace=Body (pl, vecNormalPn * dHeight);
				_Map.setVector3d("vecUnderneath", vecNormalPn);
				_Map.setPoint3d("ptUnderneath", pn.ptOrg());
				// store Body
				_Map.setBody("bd", bdSpace);
			}
			else if(iAlignFaces)
			{ 
				// 
				Entity entTsl=_Map.getEntity("TslAlign");
				TslInst tsl=(TslInst)entTsl;
				if(tsl.bIsValid())
				{ 
					Vector3d vecNormalUnderneath=tsl.map().getVector3d("vecUnderneath");
		//			bdSpace=Body(pl, vecNormalUnderneath*U(10e3));
					bdSpace=Body(pl, vecNormalPn*U(10e3));
					
					// create a large planeprofile and then clear the faces
					PlaneProfile ppLarge(pl);
					ppLarge.shrink(-U(300));
					
					PLine plLarges[]=ppLarge.allRings(true,false);
					PLine plLarge=plLarges[0];
					bdSpace=Body(plLarge, vecNormalUnderneath*U(10e3));
					bdSpace.vis(3);
					
					// check all edges if they align with the underlying edges 
					// and cleanup the faces with the vecNormalUnderneath
					Point3d ptVertices[]=pl.vertexPoints(false);
					Body bdUnderneath = tsl.map().getBody("bd");
		//			bdUnderneath.transformBy(U(50) * _ZW);
		//			bdUnderneath.vis(6);
					PlaneProfile ppUnderneath = bdUnderneath.extractContactFaceInPlane(pn, dEps);
		//			ppUnderneath.vis(6);
					PLine plsUnderneath[]=ppUnderneath.allRings(true,false);
					PLine plUnderneath=plsUnderneath[0];
					plUnderneath.vis(6);
					Point3d ptVerticesUnderneath[] = plUnderneath.vertexPoints(false);
					int iFaceAlignedAtAll;
					for (int ipt=0;ipt<ptVertices.length()-1;ipt++)
					{ 
						Point3d pt1=ptVertices[ipt];
						Point3d pt2=ptVertices[ipt+1];
						Point3d ptMid=.5*(pt1+pt2);
						Vector3d vec1 = pt2 - pt1;vec1.normalize();
						int iFaceAligned;
						for (int jpt=0;jpt<ptVerticesUnderneath.length()-1;jpt++)
						{ 
							Point3d _pt1=ptVerticesUnderneath[jpt];
							Point3d _pt2=ptVerticesUnderneath[jpt+1];
							Vector3d _vec1 = _pt2 - _pt1; _vec1.normalize();
							
							if(abs(abs(vec1.dotProduct(_vec1))-1.0)<dEps)
							{ 
								// parallel, check distance
								double dDist1=(pt1-Line(_pt1,_vec1).closestPointTo(pt1)).length();
								double dDist2=(pt2-Line(_pt1,_vec1).closestPointTo(pt2)).length();
								if(dDist1<dEps && dDist2<dEps)
								{ 
									iFaceAligned = true;
									iFaceAlignedAtAll=true;
									break;
								}
							}
						}//next jpt
						// 
						if(iFaceAligned)
						{ 
							Vector3d vecXsubtract = vec1;
							Vector3d vecZsubtract = vecNormalUnderneath;
							vecXsubtract=vecZsubtract.crossProduct(vecXsubtract.crossProduct(vecZsubtract));
							vecXsubtract.normalize();
							Vector3d vecYsubtract=vecZsubtract.crossProduct(vecXsubtract);
							vecYsubtract.normalize();
							Point3d ptTest = ptMid + dEps * vecYsubtract;
							PlaneProfile ppTest(pl);
							if(ppTest.pointInProfile(ptTest)==_kPointInProfile)
							{ 
								vecXsubtract*=-1;
								vecYsubtract*=-1;
							}
							Body bdSubFace(ptMid,vecXsubtract,vecYsubtract,vecZsubtract,
								U(10e6), U(10e6), U(10e6), 0, 1, 0);
							bdSpace.subPart(bdSubFace);
						}
						else if(!iFaceAligned)
						{ 
							Vector3d vecXsubtract = vec1;
							Vector3d vecZsubtract = vecNormalPn;
							vecXsubtract=vecZsubtract.crossProduct(vecXsubtract.crossProduct(vecZsubtract));
							vecXsubtract.normalize();
							Vector3d vecYsubtract=vecZsubtract.crossProduct(vecXsubtract);
							vecYsubtract.normalize();
							Point3d ptTest = ptMid + dEps * vecYsubtract;
							PlaneProfile ppTest(pl);
							if(ppTest.pointInProfile(ptTest)==_kPointInProfile)
							{ 
								vecXsubtract*=-1;
								vecYsubtract*=-1;
							}
							Body bdSubFace(ptMid,vecXsubtract,vecYsubtract,vecZsubtract,
							U(10e6), U(10e6), U(10e6), 0, 1, 0);
							bdSpace.subPart(bdSubFace);
						}
					}//next ipt
					
					if(!iFaceAlignedAtAll)
					{ 
						_Map.setInt("AlignFaces",false);
					}
					
					Body bdSubtract;
					Vector3d vecXsubtract=_PtG[1]-_PtG[0];
					vecXsubtract.normalize();
					Point3d ptSubtract = _PtG[0];
					ptSubtract += vecNormalPn * dHeight;
					vecXsubtract=vecNormalPn.crossProduct(vecXsubtract.crossProduct(vecNormalPn));
					Vector3d vecZsubtract = vecNormalPn;
					Vector3d vecYsubtract = vecZsubtract.crossProduct(vecXsubtract);
					vecYsubtract.normalize();
					ptSubtract.vis(1);
					bdSubtract=Body(ptSubtract,vecXsubtract,vecYsubtract,vecZsubtract,
						U(10e6), U(10e6), U(10e6), 0, 0, 1);
					bdSpace.subPart(bdSubtract);
					_Map.setVector3d("vecUnderneath", tsl.map().getVector3d("vecUnderneath"));
					_Map.setPoint3d("ptUnderneath",tsl.map().getPoint3d("ptUnderneath"));
					// store Body
					_Map.setBody("bd", bdSpace);
				}
			}
			// 20220429
			Point3d ptPlaneTop = pn.ptOrg()+vecNormalPn*dHeight;
			Vector3d vecPlaneTop = pn.vecZ();
			_Map.setPoint3d("ptPlaneTop",ptPlaneTop,_kAbsolute);
			_Map.setVector3d("vecPlaneTop",vecNormalPn,_kFixedSize);
		}
	}
	else
	{ 
		int iEdgeSlope = _Map.getInt("indexEdgeSlope");
	//	int iEdgeSlope = nEdgeIndex-1;
	//	double dSlope = _Map.getDouble("Slope");
		double _dSlope = dSlope;
		Point3d _pts[0];
		_pts.append(_PtG);
		_pts.removeAt(_pts.length() - 1);
		_pts.append(_pts[0]);
		
		Point3d ptEdgeStart=_pts[iEdgeSlope], ptEdgeEnd=_pts[iEdgeSlope+1];
		ptEdgeStart.vis(3);
		ptEdgeEnd.vis(3);
		
		// build firs in the horizontal plane then rotate to the gradient/skew plane
		Plane pnHorEdgeStart(ptEdgeStart, _ZW);
		pl.vis(6);
		PLine plHorEdgeStart = pl;
	//	plHorEdgeStart.vis(1);
		Vector3d vecXorig, vecYorig, vecZorig;
		int iPointInside=-1;
		
		Vector3d vecEdge = ptEdgeEnd - ptEdgeStart;vecEdge.normalize();
		Vector3d vecEdgePn = ptEdgeEnd - ptEdgeStart;vecEdgePn.normalize();
	//	Vector3d vecNormal = pn.vecZ();
		Vector3d vecNormal = pnHorEdgeStart.vecZ();
		vecNormal.normalize();
		vecEdge=vecEdge.crossProduct(vecNormal);
		vecEdge.normalize();
		vecEdge=vecNormal.crossProduct(vecEdge);
		vecEdge.normalize();
		
		Vector3d vecEdgeNormal = vecNormal.crossProduct(vecEdge);
		vecEdgeNormal.normalize();
		vecEdge.vis(ptEdgeStart);
		vecEdgeNormal.vis(ptEdgeStart);
		vecNormal.vis(ptEdgeStart);
		
		vecXorig = vecEdge;
		vecZorig = _ZW;
		vecYorig = vecZorig.crossProduct(vecXorig);
		
		ppSpace.vis(3);
		Point3d ptTest=.5*(ptEdgeStart+ptEdgeEnd)+1000*dEps*vecEdgeNormal;
		ptTest.vis(4);
		if (ppSpace.pointInProfile(ptTest) == _kPointInProfile)iPointInside = 1;
		
		Vector3d vecEdgeNormalHor = _ZW.crossProduct(vecEdgeNormal);vecEdgeNormalHor.normalize();
		vecEdgeNormalHor = vecEdgeNormalHor.crossProduct(_ZW);vecEdgeNormalHor.normalize();
	//	vecEdgeNormalHor.vis(ptEdgeStart);
	//	Vector3d vecSlope = iPointInside*vecEdgeNormal + 0.01 * _dSlope * vecNormal;
		Vector3d vecSlope = iPointInside*vecEdgeNormalHor + 0.01 * _dSlope * _ZW;
		vecSlope.vis(ptEdgeStart);
		Vector3d vecSlopeNormal = (vecEdge.crossProduct(vecSlope));
		if(vecSlopeNormal.dotProduct(_ZW)<0)
			vecSlopeNormal *= -1;
			
	//	if(vecSlopeNormal.dotProduct(_ZW)<0 && dSlope>0)
	//	{ 
	//		vecSlopeNormal *= -1;
	//	}
	//	if(vecSlopeNormal.dotProduct(_ZW)>0 && dSlope<0)
	//	{ 
	//		vecSlopeNormal *= -1;
	//	}
		Vector3d vecNormalPn = pn.vecZ();
		vecNormalPn.normalize();
		vecSlopeNormal.vis(ptEdgeStart);
		Point3d ptEdgeStart_ = ptEdgeStart;
		if(dHeight>0)
		{
			ptEdgeStart += dHeight * _ZW;
	//		ptEdgeStart += dHeight * vecNormalPn;
		}
		ptEdgeStart.vis(1);
		Body bdSubtract(ptEdgeStart,vecEdge,vecSlope,vecSlopeNormal,
			U(10e4),U(10e4),U(10e4),0,0,1);
	//	bdSubtract.vis(1);
		
		Vector3d vecXnew = vecEdgePn;
		Vector3d vecZnew = vecNormalPn;
		Vector3d vecYnew = vecZnew.crossProduct(vecXnew);
		vecYnew.normalize();
		CoordSys csTransform;
		vecXorig.vis(ptEdgeEnd);
		vecYorig.vis(ptEdgeEnd);
		vecZorig.vis(ptEdgeEnd);
		
		vecXnew.vis(ptEdgeEnd,1);
		vecYnew.vis(ptEdgeEnd,1);
		vecZnew.vis(ptEdgeEnd,1);
		csTransform.setToAlignCoordSys(ptEdgeStart_,vecXorig,vecYorig,vecZorig,
			ptEdgeStart_,vecXnew,vecYnew,vecZnew);
		CoordSys csTransformInv = csTransform;
		csTransformInv.invert();
		plHorEdgeStart.transformBy(csTransformInv);
	//	plHorEdgeStart.vis(1);
		
	//	bdSpace = Body (pl, _ZW * U(10e3));
		
		if(!iAlignFaces)
		{ 
			bdSpace = Body (plHorEdgeStart, _ZW * U(10e3));
		//	bdSpace.vis(1);
			bdSpace.subPart(bdSubtract);
		//	bdSpace.vis(1);
			// transform
			PLine pltTransform = plHorEdgeStart;
			pltTransform.transformBy(csTransform);
			pltTransform.vis(6);
			bdSpace.transformBy(csTransform);
			vecSlopeNormal.transformBy(csTransform);
			// Edge alignment vector for the tsl that will be aligned with this one
			_Map.setVector3d("vecUnderneath", vecNormalPn);
			_Map.setPoint3d("ptUnderneath", pn.ptOrg());
		}
		else if(iAlignFaces)
		{ 
			pl.vis(6);
			// get the plane of the underneath entity
			vecSlopeNormal.transformBy(csTransform);
			Plane pnUnderneath(ptEdgeStart, vecSlopeNormal);
			Entity entTsl=_Map.getEntity("TslAlign");
			TslInst tsl=(TslInst)entTsl;
			Slab slab=(Slab)entTsl;
			if(tsl.bIsValid())
			{ 
				
				pnUnderneath=Plane(tsl.map().getPoint3d("ptUnderneath"),
					tsl.map().getVector3d("vecUnderneath"));
				_Map.setVector3d("vecUnderneath", tsl.map().getVector3d("vecUnderneath"));
				_Map.setPoint3d("ptUnderneath",tsl.map().getPoint3d("ptUnderneath"));
	//			Entity entTslUnderneath=tsl.map().getEntity("TslAlign");
	//			TslInst tslUnderneath = (TslInst)entTslUnderneath;
	//			if(tslUnderneath.bIsValid())
	//			{ 
	//				pnUnderneath = Plane(tslUnderneath.map().getPoint3d("ptPlaneTop"), 
	//					tslUnderneath.map().getVector3d("vecPlaneTop"));
	//			}
	//			else
	//			{ 
	//				pnUnderneath=Plane(tsl.ptOrg(),_ZW);
	//			}
				tsl.map().getVector3d("vecUnderneath").vis(_Pt0);
			}
			
	//		bdSpace = Body (plHorEdgeStart, _ZW * U(10e3));
			Vector3d vecNormalUnderneath = pnUnderneath.vecZ();
			vecNormalUnderneath.vis(_Pt0);
			vecNormalUnderneath.normalize();
			pl.vis(3);
			
			vecNormalUnderneath.vis(_Pt0);
	//		bdSpace = Body (pl, vecNormalUnderneath * U(10e3));
			PlaneProfile ppLarge(pl);
			ppLarge.shrink(-U(300));
			
			PLine plLarges[]=ppLarge.allRings(true,false);
			PLine plLarge=plLarges[0];
			bdSpace=Body(plLarge, vecNormalUnderneath*U(10e3));
			
			
			bdSubtract.transformBy(csTransform);
	//		bdSpace.vis(1);
	//		bdSubtract.vis(1);
			bdSpace.subPart(bdSubtract);
	//		bdSpace.vis(1);
			// transform
			PLine pltTransform = plHorEdgeStart;
			pltTransform.transformBy(csTransform);
			pltTransform.vis(6);
	//		bdSpace.transformBy(csTransform);
	//		vecSlopeNormal.transformBy(csTransform);
	
			// check all edges if they align with the underlying edges 
			// and cleanup the faces with the vecNormalUnderneath
			Point3d ptVertices[]=pl.vertexPoints(false);
			Body bdUnderneath = tsl.map().getBody("bd");
	//			bdUnderneath.transformBy(U(50) * _ZW);
	//			bdUnderneath.vis(6);
			PlaneProfile ppUnderneath = bdUnderneath.extractContactFaceInPlane(pn, dEps);
	//			ppUnderneath.vis(6);
			PLine plsUnderneath[]=ppUnderneath.allRings(true,false);
			PLine plUnderneath=plsUnderneath[0];
			plUnderneath.vis(6);
			Point3d ptVerticesUnderneath[] = plUnderneath.vertexPoints(false);
			for (int ipt=0;ipt<ptVertices.length()-1;ipt++)
			{ 
				Point3d pt1=ptVertices[ipt];
				Point3d pt2=ptVertices[ipt+1];
				Point3d ptMid=.5*(pt1+pt2);
				Vector3d vec1 = pt2 - pt1;vec1.normalize();
				int iFaceAligned;
				for (int jpt=0;jpt<ptVerticesUnderneath.length()-1;jpt++)
				{ 
					Point3d _pt1=ptVerticesUnderneath[jpt];
					Point3d _pt2=ptVerticesUnderneath[jpt+1];
					Vector3d _vec1 = _pt2 - _pt1; _vec1.normalize();
					
					if(abs(abs(vec1.dotProduct(_vec1))-1.0)<dEps)
					{ 
						// parallel, check distance
						double dDist1=(pt1-Line(_pt1,_vec1).closestPointTo(pt1)).length();
						double dDist2=(pt2-Line(_pt1,_vec1).closestPointTo(pt2)).length();
						if(dDist1<dEps && dDist2<dEps)
						{ 
							iFaceAligned = true;
							break;
						}
					}
				}//next jpt
				// 
				if(iFaceAligned)
				{ 
					Vector3d vecXsubtract = vec1;
					Vector3d vecZsubtract = vecNormalUnderneath;
					vecXsubtract=vecZsubtract.crossProduct(vecXsubtract.crossProduct(vecZsubtract));
					vecXsubtract.normalize();
					Vector3d vecYsubtract=vecZsubtract.crossProduct(vecXsubtract);
					vecYsubtract.normalize();
					Point3d ptTest = ptMid + dEps * vecYsubtract;
					PlaneProfile ppTest(pl);
					if(ppTest.pointInProfile(ptTest)==_kPointInProfile)
					{ 
						vecXsubtract*=-1;
						vecYsubtract*=-1;
					}
					Body bdSubFace(ptMid,vecXsubtract,vecYsubtract,vecZsubtract,
						U(10e6), U(10e6), U(10e6), 0, 1, 0);
					bdSpace.subPart(bdSubFace);
				}
				else if(!iFaceAligned)
				{ 
					Vector3d vecXsubtract = vec1;
					Vector3d vecZsubtract = vecNormalPn;
					vecXsubtract=vecZsubtract.crossProduct(vecXsubtract.crossProduct(vecZsubtract));
					vecXsubtract.normalize();
					Vector3d vecYsubtract=vecZsubtract.crossProduct(vecXsubtract);
					vecYsubtract.normalize();
					Point3d ptTest = ptMid + dEps * vecYsubtract;
					PlaneProfile ppTest(pl);
					if(ppTest.pointInProfile(ptTest)==_kPointInProfile)
					{ 
						vecXsubtract*=-1;
						vecYsubtract*=-1;
					}
					Body bdSubFace(ptMid,vecXsubtract,vecYsubtract,vecZsubtract,
					U(10e6), U(10e6), U(10e6), 0, 1, 0);
					bdSpace.subPart(bdSubFace);
				}
			}//next ipt
		}
		bdSpace.vis(1);
		if(dHeight>0)
		{
			ptEdgeStart_ += dHeight * vecNormalPn;
		}
		{ 
	//		PlaneProfile ppVer = bdSpace.shadowProfile(Plane(ptEdgeStart, _XW));
	//		// get extents of profile
	//		LineSeg seg = ppVer.extentInDir(_XW);
	//		Point3d ptPlaneTop = seg.ptEnd();
	//		ptPlaneTop.vis(1);
	//		if(_ZW.dotProduct(seg.ptStart()-seg.ptEnd())>0)ptPlaneTop = seg.ptStart();
			
			_Map.setPoint3d("ptPlaneTop",ptEdgeStart_,_kAbsolute);
			_Map.setVector3d("vecPlaneTop",vecSlopeNormal,_kFixedSize);
			// store Body
			_Map.setBody("bd", bdSpace);
		}
	}
	
	ppSpaceHorReal = bdSpace.shadowProfile(pnHor);
	PLine plReals[] = ppSpaceHorReal.allRings(true, false);
	if(plReals.length()>0)
		plReal = plReals[0];
	else
	{ 
		reportMessage("\n"+scriptName()+" "+T("|Possibly no volume detected|"));
	//	return;
	}
	
	//dpSpacePlane.draw(ppSpace, _kDrawFilled);
	
	Map mapDisplayStyle;
	for (int i=0;i<mapDisplayStyles.length();i++) 
	{ 
		Map mapDisplayStyleI = mapDisplayStyles.getMap(i);
		if(mapDisplayStyleI.hasString("Name") && mapDisplayStyles.keyAt(i).makeLower() == "darstellungsstil")
		{ 
			String sDisplayStyleName=mapDisplayStyleI.getString("Name");
			if(sDisplayStyleName==sDisplayStyle)
			{ 
				mapDisplayStyle = mapDisplayStyleI;
				break;
			}
		}
	}//next i
	
	//Map mapContour = mapDisplayStyle.getMap("Contour");
	//Map mapHatch=mapDisplayStyle.getMap("Hatch");
	// contour from top
	Display dpPlane(3);
	Display dpHatch(3);
	//String _sLineType = mapContour.getString("LineType");
	String _sLineType;
	int iLineType = sLineTypes.find(sLineType);
	if (iLineType > -1)
	{
		_sLineType = sLineType;
	}
	
	int iLineWeight = sLineWeights.find(sLineWeight);
	int _iLineWeight = -1;
	if(iLineWeight>0)
	{ 
		_iLineWeight=nLineWeights[iLineWeight];
	}
	
	_ThisInst.setLineWeight(_iLineWeight);
	
	//int _iContourColor = mapContour.getInt("Color");
	int _iContourColor = 0;
	if(nLineColor>-3)
	{
		_iContourColor=nLineColor;
	}
	
	dpPlane.addViewDirection(_ZW);
	dpHatch.addViewDirection(_ZW);
	dpPlane.color(_iContourColor);
	dpSpaceVolume.color(_iContourColor);
	
	PlaneProfile ppPlane(pn);
	ppPlane.joinRing(pl,_kAdd);
	ppSpaceHorReal.vis(1);
	if(_LineTypes.find(sLineType)>-1 && sLineType!="Continuous")
	{ 
	//	double _dLineScale = mapContour.getDouble("LineScale");
		double _dLineScale=1;
		if(dLineScale>0)
		{ 
			_dLineScale = dLineScale;
		}
		if(_dLineScale>0)
		{
			dpPlane.lineType(sLineType,dLineScale);
			dpSpaceVolume.lineType(sLineType,dLineScale);
		}
		else
		{
			dpPlane.lineType(sLineType);
			dpSpaceVolume.lineType(sLineType);
		}
	//	dpPlane.draw(ppPlane);
		dpPlane.draw(ppSpaceHorReal);
	}
	else
	{ 
	//	double dContourThickness = mapContour.getDouble("Thickness");
		double dContourThickness;
		dContourThickness = dLineThickness;
	//	PLine plsPlane[] = ppPlane.allRings();
		PLine plsPlane[] = ppSpaceHorReal.allRings();
		for (int ipl=0;ipl<plsPlane.length();ipl++) 
		{ 
	//		PlaneProfile ppI(ppPlane.coordSys());
			PlaneProfile ppI(ppSpaceHorReal.coordSys());
			ppI.joinRing(plsPlane[ipl], _kAdd);
			if(dContourThickness>0)
			{ 
				ppI.shrink(-.5 * dContourThickness);
				PlaneProfile ppContour = ppI;
				ppI.shrink(dContourThickness);
				ppContour.subtractProfile(ppI);
				dpPlane.draw(ppContour, _kDrawFilled);
			}
		}//next ipl
	}
	
	dpSpaceVolume.draw(bdSpace);
	dpSpaceVolumeHidden.draw(bdSpace);
	// hatch area
	//int iHatch = sNoYes.find(sHatch);
	int iHatch = true;
	
	int iSolidHatch=0;
	int iSolidTransparency = 0;
	int iSolidColor = 0;
	int iHasSolidColor = 0;
	//int isActive=mapHatch.getInt("isActive");
	
	String sPattern = "ANSI31";// hatch pattern
	int iColor = 1;// color index
	int iTransparency = 0;// transparency
	double dAngle = 0;// hatch angle
	double dScale = 10.0;// hatch scale
	double dScaleMin = 25;// dScaleMin
	int iStatic = 0;// by default make dynamic
	//if(isActive && iHatch)
	int iHatchSolid=sNoYes.find(sHatchSolidVisibility);
	int iHatchPattern=sNoYes.find(sHatchPatternVisibility);
	if(iHatch)
	{ 
	//	Map m = mapHatch;
	//	String ss;
	//	// ---
	//	ss = "SolidHatch"; if(m.hasInt(ss)) 
	//	{
	//		iSolidHatch = m.getInt(ss);
	//		if(iSolidHatch<=0)
	//			iSolidHatch = 0;
	//		else
	//			iSolidHatch = 1;
	//	}
	//	ss = "SolidTransparency"; if(m.hasInt(ss)) iSolidTransparency = m.getInt(ss);
	//	ss = "SolidColor"; if(m.hasInt(ss)) iSolidColor = m.getInt(ss);
	//	ss = "SolidColor"; iHasSolidColor= m.hasInt(ss);
	//	// ---
	//	ss = "Pattern"; if(m.hasString(ss)) sPattern = m.getString(ss);
	//	ss = "Color"; if(m.hasInt(ss)) iColor = m.getInt(ss);
	//	ss = "Transparency"; if(m.hasInt(ss)) iTransparency = m.getInt(ss);
	//	ss = "Angle"; if(m.hasDouble(ss)) dAngle = m.getDouble(ss);
	//	ss = "Scale"; if(m.hasDouble(ss)) dScale = m.getDouble(ss);
	//	ss = "ScaleMin"; if(m.hasDouble(ss)) dScaleMin = m.getDouble(ss);
	//	ss = "Static"; if(m.hasInt(ss)) 
	//	{
	//		iStatic = m.getInt(ss);
	//		if(iStatic<=0)
	//			iStatic = 0;
	//		else
	//			iStatic = 1;
	//	}
	//	LineSeg seg = ppSpaceHorReal.extentInDir(_XW);
	//	double dX = abs(_XW.dotProduct(seg.ptStart() - seg.ptEnd()));
	//	double dY = abs(_YW.dotProduct(seg.ptStart() - seg.ptEnd()));
	//	double dMin = dX < dY ? dX : dY;
		double dScaleFac = dScale;
		if (dScaleFac < 0.01)dScaleFac = 1;
	//	double dScale0 = dScaleMin;
	//	if (iStatic)
	//	{
	//		// static, not adapted to the size, get the factor defined in dScale
	//		dScale0 = dScaleFac;
	//		if (dScale0 < dScaleMin)
	//		{ 
	//			dScale0 = dScaleMin;
	//		}
	//	}
	//	else
	//	{ 
	//		// dynamic, adapted to the minimum dimension
	//		// should not be smaller then dScaleMin
	//		dScale0 = dScaleFac * dMin;
	//		if (dScale0 < dScaleMin)
	//		{ 
	//			dScale0 = dScaleMin;
	//		}
	//	}
		double dGlobalScaling = 1;
	//	dScale0 *= dGlobalScaling;
		double dScale0=1;
		if(dHatchPatternScale>0)
		{ 
			dScale0 = dHatchPatternScale;
		}
		if(nHatchPatternColor>-3)
		{ 
			iColor = nHatchPatternColor;
		}
		if (iColor < 1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (iColor == -2)
			{ 
				// get color from entity (beam) and use this for the hatch
				iColor = _ThisInst.color();
			}
			else if (iColor <- 2)
			{ 
				//iColor <- 2; -3,-4,-5 etc then take by entity
				iColor = - 2;
			}
		}
		if(nHatchSolidColor>-3)
		{ 
			iSolidColor = nHatchSolidColor;
		}
		if (iSolidColor < 1)
		{ 
			// -2 by entity, -1 by layer, 0 by entity
			if (iSolidColor == -2)
			{ 
				// get color from entity (beam) and use this for the hatch
				iSolidColor = _ThisInst.color();
			}
			else if (iSolidColor <- 2)
			{ 
				//iColor <- 2; -3,-4,-5 etc then take by entity
				iSolidColor = - 2;
			}
		}
		dAngle = dHatchPatternAngle;
		sPattern = sHatchPattern;
		int nPattern = _HatchPatterns.findNoCase(sPattern, 0);
		sPattern = nPattern >- 1 ? _HatchPatterns[nPattern] : _HatchPatterns[0];
		Hatch hatch(sPattern, dScale0);
		double dRotation = 0;
		double dRotationTotal = dAngle + dRotation;
		hatch.setAngle(dRotationTotal);
		dpHatch.color(iColor);
		
		
		int _iTransparency=iTransparency;
		
		int _iSolidTransparency=iSolidTransparency;
		if(nHatchSolidTransparency>100)
			nHatchSolidTransparency.set(100);
		if(nHatchSolidTransparency<1)
			nHatchSolidTransparency.set(-1);
		_iSolidTransparency = nHatchSolidTransparency;
		
		if(nHatchPatternTransparency>100)
			nHatchPatternTransparency.set(100);
		if(nHatchPatternTransparency<1)
			nHatchPatternTransparency.set(-1);
		_iTransparency = nHatchPatternTransparency;
		
	//	double dGlobalTransparency=1;
	//	if(dGlobalTransparency<=0)
	//	{ 
	//		_iTransparency = 0;
	//		_iSolidTransparency = 0;
	//	}
	//	else if(dGlobalTransparency>0 && dGlobalTransparency<1)
	//	{ 
	//		_iTransparency = iTransparency * dGlobalTransparency;
	//		_iSolidTransparency=iSolidTransparency* dGlobalTransparency;
	//	}
	//	else if(dGlobalTransparency>1 && dGlobalTransparency<100)
	//	{ 
	////				_iTransparency = 100 - ((100 - iTransparency) / dGlobalTransparency);
	////				_iSolidTransparency = 100 - ((100 - iSolidTransparency) / dGlobalTransparency);
	//		_iTransparency = iTransparency+dGlobalTransparency*((100 - iTransparency) / 99);
	//		_iSolidTransparency = iSolidTransparency+dGlobalTransparency*((100 - iSolidTransparency) / 99);
	//	}
	//	else if(dGlobalTransparency>=100)
	//	{ 
	//		_iTransparency = 100;
	//		_iSolidTransparency = 100;
	//	}
		dpHatch.transparency(_iTransparency);
		if(iHatchPattern)
			dpHatch.draw(ppSpaceHorReal, hatch);
		
		dpHatch.color(iSolidColor);
		if(iHatchSolid)
			dpHatch.draw(ppSpaceHorReal, _kDrawFilled, _iSolidTransparency);
		
	}
	int iMoved;
	if(!_Map.hasPoint3d("Position"))
	{ 
		_Map.setPoint3d("Position", _Pt0, _kAbsolute);
	}
	else if (_Map.hasPoint3d("Position") && !iAlignedEntity)
	{
		if((_Pt0-_Map.getPoint3d("Position")).length()>dEps)
		{ 
			iMoved = true;
		}
		if(iMoved)
		{ 
			_Map.setPoint3d("Position", _Pt0, _kAbsolute);
			dZheight.set(_Pt0.Z());
		}
	}
	//if(_PtG.length()==0)
	//{ 
	//	// at ptg for text
	//	Point3d ptTextInit;
	//	ptTextInit.setToAverage(pts);
	//	_PtG.append(ptTextInit);
	//}
	
	_ThisInst.setAllowGripAtPt0(false);
	//double dTextHeightStyle = dpText.textHeightForStyle("Area", sDimStyle);
	//double dScale = dTextHeight / dTextHeightStyle;
	//dpText.dimStyle(sDimStyle, 50);;
	//dpText.textHeight(dTextHeight);
	dpText.textHeight(U(200));
	dpText.addViewDirection(_ZW);
	//if(_DimStyles.find("hsb050")>-1)
	//{ 
	//	dpText.dimStyle("hsb050");;
	//	
	//}
	//_PtG[0] = pn.closestPointTo(_PtG[0]);
	Point3d ptText = _PtG[_PtG.length()-1];
	_Pt0+=_XW*_XW.dotProduct(ptText-_Pt0);
	_Pt0+=_YW*_YW.dotProduct(ptText-_Pt0);
	//_Pt0 = ptText;
	Map mapTexts = mapDisplayStyle.getMap("Text[]");
	Map mapNumber, mapName, mapVolume, mapArea, mapPerimeter;
	
	String sText;
	double dTextY = 0;
	double dTextHeight;
	double dTextHeightPrev;
	double dTextGapExtra = U(80);
	//double dArea = ppSpace.area()/1000000;
	double dArea = ppSpaceHorReal.area()/1000000;
	String sArea;
	sArea.format("%.3f", dArea);
	
	//double dVolume = dArea * dHeight / 1000;
	double dVolume = bdSpace.volume()/(1e9);
	String sVolume;
	sVolume.format("%.3f", dVolume);
	
	//double dLength = pl.length()/1000;
	double dLength = plReal.length()/1000;
	String sLength;
	sLength.format("%.3f", dLength);
	
	if(iLegend)
	{ 
		for (int imap=0;imap<mapTexts.length();imap++) 
		{ 
			Map mapI = mapTexts.getMap(imap);
			if(mapI.getInt("isVisible"))
			{ 
				dpText = Display(2);
				dpText.textHeight(U(200));
				dpText.addViewDirection(_ZW);
				dTextHeight = mapI.getDouble("TextHeight");
				dpText.textHeight(dTextHeight);
				String sTitle = mapI.getString("Title");
				dpText.color(mapI.getInt("TextColor"));
				String sDimStyle;
				if(_DimStyles.find(mapI.getString("DimStyle")))
					sDimStyle = mapI.getString("DimStyle");
				if(sDimStyle!="")
				{
					dpText.dimStyle(sDimStyle);
					dpText.textHeight(dTextHeight);
					dTextHeight = dpText.textHeightForStyle("123ABcde",sDimStyle, dTextHeight);
				}
				if(mapI.getString("Name")=="SpaceNumber" && sNumber.length()>0)
				{ 
					if(dTextHeightPrev>0)
						ptText -= _YW * (.5*(dTextHeight+dTextHeightPrev)+dTextGapExtra);
					sText = "";
					if(sTitle!="")
						sText = sTitle;
					dpText.draw(sText, ptText, _XW, _YW, -1, 0);
					sText =" "+sNumber;
					dpText.draw(sText, ptText, _XW, _YW, 1, 0);
					dTextY -= 2.5;
					dTextHeightPrev = dTextHeight;
				}
				else if(mapI.getString("Name")=="SpaceName" && sName.length()>0)
				{ 
					if(dTextHeightPrev>0)
						ptText -= _YW * (.5*(dTextHeight+dTextHeightPrev)+dTextGapExtra);
					sText = "";
					if(sTitle!="")
						sText = sTitle;
					dpText.draw(sText, ptText, _XW, _YW, -1, 0);
					sText =" "+sName;
					dpText.draw(sText, ptText, _XW, _YW, 1, 0);
					dTextY -= 2.5;
					dTextHeightPrev = dTextHeight;
				}
				else if(mapI.getString("Name")=="Area")
				{ 
					if(dTextHeightPrev>0)
						ptText -= _YW * (.5*(dTextHeight+dTextHeightPrev)+dTextGapExtra);
					sText = "";
					if(sTitle!="")
						sText = sTitle;
					dpText.draw(sText, ptText, _XW, _YW, -1, 0);
					sText =" "+sArea;
					dpText.draw(sText, ptText, _XW, _YW, 1, 0);
					dTextY -= 2.5;
					
					dTextHeightPrev = dTextHeight;
				}
				else if(mapI.getString("Name")=="Volume")
				{ 
					if(dTextHeightPrev>0)
						ptText -= _YW * (.5*(dTextHeight+dTextHeightPrev)+dTextGapExtra);
		
					sText = "";
					if(sTitle!="")
						sText = sTitle;
					dpText.draw(sText, ptText, _XW, _YW, -1, 0);
					sText = " "+sVolume;
					dpText.draw(sText, ptText, _XW, _YW, 1, 0);
					dTextY -= 2.5;
					
					dTextHeightPrev = dTextHeight;
					
				}
				else if(mapI.getString("Name")=="Perimeter")
				{ 
					if(dTextHeightPrev>0)
						ptText -= _YW * (.5*(dTextHeight+dTextHeightPrev)+dTextGapExtra);
					sText = "";
					if(sTitle!="")
						sText = sTitle;
					dpText.draw(sText, ptText, _XW, _YW, -1, 0);
					sText = " "+sLength;
					dpText.draw(sText, ptText, _XW, _YW, 1, 0);
					dTextY -= 2.5;
					
					dTextHeightPrev = dTextHeight;
				}
				else if(mapI.getString("Name")=="Material1" && sMaterial1.length()>0)
				{ 
					if(dTextHeightPrev>0)
						ptText -= _YW * (.5*(dTextHeight+dTextHeightPrev)+dTextGapExtra);
					sText = "";
					if(sTitle!="")
						sText = sTitle;
					dpText.draw(sText, ptText, _XW, _YW, -1, 0);
					sText =" "+sMaterial1;
					dpText.draw(sText, ptText, _XW, _YW, 1, 0);
					dTextY -= 2.5;
					dTextHeightPrev = dTextHeight;
				}
				else if(mapI.getString("Name")=="Material2" && sMaterial2.length()>0)
				{ 
					if(dTextHeightPrev>0)
						ptText -= _YW * (.5*(dTextHeight+dTextHeightPrev)+dTextGapExtra);
					sText = "";
					if(sTitle!="")
						sText = sTitle;
					dpText.draw(sText, ptText, _XW, _YW, -1, 0);
					sText =" "+sMaterial2;
					dpText.draw(sText, ptText, _XW, _YW, 1, 0);
					dTextY -= 2.5;
					dTextHeightPrev = dTextHeight;
				}
			}
		}//next imap
	}
		
	if(_kNameLastChangedProp=="_Pt0")
	{ 
		// pt0 modified, update zheight
		dZheight.set(_Pt0.Z());
	}
	
	//
	// trigger with jigging
	{ 
	//region Trigger AddVertex
		String sTriggerAddVertex = T("|Add Point|");
		addRecalcTrigger(_kContextRoot, sTriggerAddVertex );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddVertex)
		{
			String sStringStart = "|Select new point|";
			String sStringStart2 = "|Select new point or [";
			String sStringOption = "Undo/Finish]";
			String sStringEdge = "|Select Edge for point|";
			String sStringEdge2 = "|Select Edge for point|";
			String sStringOptionEdge = "Undo/Finish/Edge]";
			
			
			String sStringPrompt = T(sStringEdge);
			
			PrPoint ssP(sStringPrompt);
			Map mapArgs;
			int nGoJig = -1;
			
			Point3d _pts[0];
			_pts.append(_PtG);
			_pts.removeAt(_pts.length() - 1);
			Point3d ptsAll[0];
			ptsAll.append(_pts);
			
			mapArgs.setPoint3dArray("pts", _pts);
			mapArgs.setInt("jigMode", 0);// edge mode
			
			Point3d ptsInserted[0];
			int iIndexInserted[0];
			
			while (nGoJig != _kNone)
			{
				nGoJig = ssP.goJig(strJigAction3, mapArgs);
				if(nGoJig==_kOk)
				{ 
					Point3d ptLast = ssP.value();
					Vector3d vecView = getViewDirection();
					ptLast=Line(ptLast, vecView).intersect(Plane(_Pt0, _ZW), U(0));
					// point is clicked
					if(mapArgs.getInt("jigMode")==0)
					{ 
						// edge mode, set edge index
						if (mapArgs.hasPoint3dArray("pts"))
						{
							Point3d _pts[] = mapArgs.getPoint3dArray("pts");
							_pts.append(_pts[0]);
							int iEdge = -1;
							double dDist = U(10e6);
							for (int ipt=0;ipt<_pts.length()-1;ipt++) 
							{ 
								Point3d pt1 = _pts[ipt];
								Point3d pt2 = _pts[ipt+1];
								Vector3d vecI = pt2 - pt1;vecI.normalize();
								Line lnI(pt1, vecI);
								double dDistI = (lnI.closestPointTo(ptLast)-ptLast).length();
								if(dDistI<dDist)
								{ 
									iEdge = ipt;
									dDist = dDistI;
								}
							}//next ipt
							if(iEdge>-1)
								mapArgs.setInt("iEdge", iEdge);
						}
						
						// go to vertex mode
						mapArgs.setInt("jigMode", 1);
	//					String sStringPrompt = sStringStart2+sStringOption;
						String sStringPrompt = sStringStart;
						ssP = PrPoint(sStringPrompt);
					}
					else if(mapArgs.getInt("jigMode")==1)
					{ 
						// vertex mode
						int iEdge = mapArgs.getInt("iEdge");
						PLine plNew;
						Point3d ptsNew[0];
						Point3d _pts[] = mapArgs.getPoint3dArray("pts");
						for (int ipt=0;ipt<_pts.length();ipt++) 
						{ 
							ptsNew.append(_pts[ipt]);
							plNew.addVertex(_pts[ipt]);
							if(ipt==iEdge)
							{ 
								ptsNew.append(ptLast);
								plNew.addVertex(ptLast);
							}
						}//next ipt
						mapArgs.setPoint3dArray("pts", ptsNew);
						
						ptsInserted.append(ptLast);
						// go to edge mode
						mapArgs.setInt("jigMode", 0);
						String sStringPrompt = T(sStringEdge);
						ssP = PrPoint(sStringPrompt);
					}
				}
				else if(nGoJig==_kKeyWord)
				{ 
					if (ssP.keywordIndex() >= 0)
					{
						if (ssP.keywordIndex() == 0 )
						{
						// undo is selected
							Point3d _pts[]=mapArgs.getPoint3dArray("pts");
							for (int ipt=0;ipt<_pts.length();ipt++) 
							{ 
								if((_pts[ipt]-ptsInserted[ptsInserted.length()-1]).length()<dEps)
								{ 
									_pts.removeAt(ipt);
									ptsInserted.removeAt(ptsInserted.length()-1);
									break;
								}
							}//next ipt
							if(ptsInserted.length()==0)
							{ 
							// no extra point
								// go to edge mode
								mapArgs.setInt("jigMode", 0);
								String sStringPrompt = T(sStringEdge);
								ssP = PrPoint(sStringPrompt);
							}
						}
					}
				}
				else if(nGoJig==_kNone)
				{ 
					Point3d _pts[] = mapArgs.getPoint3dArray("pts");
					Point3d ptTxt = _PtG[_PtG.length() - 1];
					_PtG.setLength(0);
					_PtG.append(_pts);
					_PtG.append(ptText);
				}
			}
			
			setExecutionLoops(2);
			return;
		}//endregion	
	
	//region Trigger RemoveVertex
		String sTriggerRemoveVertex = T("|Remove Point|");
		addRecalcTrigger(_kContextRoot, sTriggerRemoveVertex );
		if (_bOnRecalc && _kExecuteKey==sTriggerRemoveVertex)
		{
			String sStringStart = "|Select point to delete|";
			String sStringStart2 = "|Select point or [";
			String sStringOption = "Undo/Finish]";
	//		String sStringOption = "Finish]";
			String sStringPrompt = T(sStringStart);
			
			PrPoint ssP(sStringPrompt);
			Map mapArgs;
			int nGoJig = -1;
			Point3d _pts[0];
			_pts.append(_PtG);
			_pts.removeAt(_pts.length() - 1);
			Point3d ptsAll[0];
			ptsAll.append(_pts);
			mapArgs.setPoint3dArray("pts", _pts);
			if(iAligned)
			{ 
				mapArgs.setPoint3d("ptPlane",_Map.getPoint3d("ptPlane"));
				mapArgs.setVector3d("vecPlane",_Map.getVector3d("vecPlane"));
			}
			else if(iAlignedEntity)
			{ 
				Entity entTsl = _Map.getEntity("TslAlign");
				TslInst tsl = (TslInst)entTsl;
				Slab slab = (Slab)entTsl;
				if(tsl.bIsValid())
				{ 
					mapArgs.setPoint3d("ptPlane",tsl.map().getPoint3d("ptPlaneTop"));
					mapArgs.setVector3d("vecPlane",tsl.map().getVector3d("vecPlaneTop"));
				}
				else if(slab.bIsValid())
				{ 
					Point3d pts[]=slab.realBody().extremeVertices(-slab.coordSys().vecY());
					mapArgs.setPoint3d("ptPlane",pts[0]);
					mapArgs.setVector3d("vecPlane",slab.coordSys().vecY());
				}
			}
			Point3d ptsDeleted[0];
			int iIndexDeleted[0];
			while (nGoJig != _kNone)
			{
				nGoJig = ssP.goJig(strJigAction2, mapArgs); 
				if(nGoJig==_kOk)
				{ 
					// point is clicked
					Point3d ptLast = ssP.value();
					Vector3d vecView = getViewDirection();
					ptLast=Line(ptLast, vecView).intersect(Plane(_Pt0, _ZW), U(0));
					if (mapArgs.hasPoint3dArray("pts"))
					{
						Point3d _pts[] = mapArgs.getPoint3dArray("pts");
						// get index of closest point with the jig point
						int iIndex = -1;
						double dDist = U(10e6);
						for (int ipt=0;ipt<_pts.length();ipt++) 
						{ 
							if((_pts[ipt]-ptLast).length()<dDist)
							{ 
								dDist = (_pts[ipt] - ptLast).length();
								iIndex = ipt;
							}
						}//next ipt
						int iIndexAll = -1;
						double dDistAll = U(10e6);
						for (int ipt=0;ipt<ptsAll.length();ipt++) 
						{ 
							if((ptsAll[ipt]-ptLast).length()<dDistAll)
							{ 
								dDistAll = (ptsAll[ipt] - ptLast).length();
								iIndexAll = ipt;
							}
						}//next ipt
						ptsDeleted.append(_pts[iIndex]);
						iIndexDeleted.append(iIndexAll);
						_pts.removeAt(iIndex);
						mapArgs.setPoint3dArray("pts", _pts);
					}
					if(ptsDeleted.length()>0)
					{ 
						sStringPrompt = sStringStart2 + sStringOption;
						ssP = PrPoint(sStringPrompt);
					}
				}
				else if(nGoJig==_kKeyWord)
				{ 
					if (ssP.keywordIndex() >= 0)
					{ 
						if(ssP.keywordIndex()==0 )
						{ 
							// undo is selected
							Point3d _pts[0];
	//						_pts= mapArgs.getPoint3dArray("pts");
	//						_pts.append(ptsDeleted[ptsDeleted.length() - 1]);
							int iIndexAll = iIndexDeleted[iIndexDeleted.length() - 1];
							ptsDeleted.removeAt(ptsDeleted.length() - 1);
							iIndexDeleted.removeAt(iIndexDeleted.length() - 1);
							for (int ipt=0;ipt<ptsAll.length();ipt++) 
							{ 
								if(iIndexDeleted.find(ipt)>-1)
								{ 
									continue;
								}
								_pts.append(ptsAll[ipt]);
							}//next ipt
							mapArgs.setPoint3dArray("pts", _pts);
							if(ptsDeleted.length()==0)
							{ 
								sStringPrompt = sStringStart;
								ssP = PrPoint(sStringPrompt);
							}
						}
						else if(ssP.keywordIndex()==1)
						{ 
							// finish is selected
							Point3d _pts[] = mapArgs.getPoint3dArray("pts");
							Point3d ptTxt = _PtG[_PtG.length() - 1];
							_PtG.setLength(0);
							_PtG.append(_pts);
							_PtG.append(ptText);
							nGoJig = _kNone;
						}
					}
				}
				else if(nGoJig==_kNone)
				{ 
					Point3d _pts[] = mapArgs.getPoint3dArray("pts");
					Point3d ptTxt = _PtG[_PtG.length() - 1];
					_PtG.setLength(0);
					_PtG.append(_pts);
					_PtG.append(ptText);
				}
			}
			
			setExecutionLoops(2);
			return;
		}//endregion	
	
	// trigger to add slope neigung at an edge
	//region Trigger AddSlopeAtEdge
		String sTriggerAddSlopeAtEdge = T("|Add Slope At Edge|");
		addRecalcTrigger(_kContextRoot, sTriggerAddSlopeAtEdge );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddSlopeAtEdge)
		{
			String sStringEdge = "|Select Edge for slope|";
			String sStringPrompt = T(sStringEdge);
			PrPoint ssP(sStringPrompt);
			Map mapArgs;
			int nGoJig = -1;
			Point3d _pts[0];
			_pts.append(_PtG);
			_pts.removeAt(_pts.length() - 1);
	//		_pts.append(_pts[0]);
			Point3d ptsAll[0];
			ptsAll.append(_pts);
			mapArgs.setPoint3dArray("pts", _pts);
	//		if(_Map.hasPoint3d("ptPlane") && _Map.hasVector3d("vecPlane"))
			if(iAligned)
			{ 
				mapArgs.setPoint3d("ptPlane",_Map.getPoint3d("ptPlane"));
				mapArgs.setVector3d("vecPlane",_Map.getVector3d("vecPlane"));
			}
			else if(iAlignedEntity)
			{ 
				Entity entTsl = _Map.getEntity("TslAlign");
				TslInst tsl = (TslInst)entTsl;
				mapArgs.setPoint3d("ptPlane",tsl.map().getPoint3d("ptPlaneTop"));
				mapArgs.setVector3d("vecPlane",tsl.map().getVector3d("vecPlaneTop"));
			}
			while (nGoJig != _kNone)
			{
				nGoJig = ssP.goJig(strJigAction5, mapArgs);
				if (nGoJig == _kOk)
				{
					Point3d ptLast = ssP.value();
					Vector3d vecView = getViewDirection();
					ptLast = Line(ptLast,vecView).intersect(pn, U(0));
					if (mapArgs.hasPoint3dArray("pts"))
					{
						Point3d _pts[] = mapArgs.getPoint3dArray("pts");
						_pts.append(_pts[0]);
						int iEdge = -1;
						double dDist = U(10e6);
						for (int ipt=0;ipt<_pts.length()-1;ipt++) 
						{ 
							Point3d pt1 = _pts[ipt];
							Point3d pt2 = _pts[ipt+1];
							Vector3d vecI = pt2 - pt1;vecI.normalize();
							Line lnI(pt1, vecI);
							double dDistI = (lnI.closestPointTo(ptLast)-ptLast).length();
							if(dDistI<dDist)
							{ 
								iEdge = ipt;
								dDist = dDistI;
							}
						}//next ipt
						if(iEdge>-1)
						{
							mapArgs.setInt("iEdge", iEdge);
	//						nEdgeIndex.set(iEdge + 1);
						}
						_Map.setInt("indexEdgeSlope", iEdge);
						_Map.setInt("VertexSlope", false);
					}
					// prompt slope
					double _dSlope;
					String sSlope = getString(T("|Enter Slope in|")+" % "+T("|Or|")+ " ["+T("|Degree|")+" ]");
					if(sSlope=="D")
					{ 
						String sSlopeDegree = getString(T("|Enter Slope in Degree|"));
						double dSlopeDegree = sSlopeDegree.atof();
						_dSlope = tan(dSlopeDegree)*100;
					}
					else
					{
						_dSlope = sSlope.atof();
					}
					_Map.setDouble("Slope", _dSlope);
					dSlope.set(_dSlope);
					nGoJig = _kNone;
				}
			}
			setExecutionLoops(2);
			return;
		}//endregion	
		
	// trigger to set back to horizontal plane
	//region Trigger SetToHorizontalPlane
		String sTriggerSetToHorizontalPlane = T("|Set To Horizontal Plane|");
		if(iAligned || iAlignedEntity)
			addRecalcTrigger(_kContextRoot, sTriggerSetToHorizontalPlane );
		if (_bOnRecalc && _kExecuteKey==sTriggerSetToHorizontalPlane)
		{
			
			_Map.removeAt("ptPlane", true);
			_Map.removeAt("vecPlane", true);
			if(iAlignedEntity)
			{ 
				Entity entTsl = _Map.getEntity("TslAlign");
				TslInst tsl = (TslInst)entTsl;
				Slab slab=(Slab)entTsl;
				if(tsl.bIsValid())
				{ 
					if(_Entity.find(tsl)>-1)
					{ 
						_Entity.removeAt(_Entity.find(tsl));
					}
				}
				else if(slab.bIsValid())
				{ 
					if(_Entity.find(slab)>-1)
					{ 
						_Entity.removeAt(_Entity.find(slab));
					}
				}
				_Map.removeAt("TslAlign",true);
			}
			_Map.setInt("AlignFaces",false);
			setExecutionLoops(2);
			return;
		}//endregion	
	
	
	////region Trigger Align
	//	String sTriggerAlign = T("|Align|");
	//	addRecalcTrigger(_kContextRoot, sTriggerAlign );
	//	if (_bOnRecalc && _kExecuteKey==sTriggerAlign)
	//	{
	//		_Map.setInt("iCleanupDummy", true);
	//		String sPromptOrigin1="Basispunkt angeben";
	//		String sPromptOrigin2="Zweiten Punkt angeben";
	//		String sPromptOrigin3="Dritten Punkt angeben";
	//		
	//		String sPromptDestination1="Ersten Zielpunkt angeben";
	//		String sPromptDestination2="Zweiten Zielpunkt angeben";
	//		String sPromptDestination3="Dritten Zielpunkt angeben";
	//		
	//		// create a copy of the tsl to serve for the preview
	//	// create TSL
	//		TslInst tslNew;	Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
	//		GenBeam gbsTsl[] = {}; Entity entsTsl[] = {}; 
	//		Point3d ptsTsl[] = {_Pt0};
	//		ptsTsl.append(pl.vertexPoints(true));
	//		ptsTsl.append(_Pt0);
	//		int nProps[]={nEdgeIndex}; 
	//		double dProps[]={dZheight,dHeight,dSlope}; 
	//		String sProps[]={sNumber,sName,sLegend,sDisplayStyle};
	//		Map mapTsl;	
	//		mapTsl = _Map;
	//		mapTsl.setInt("isDummy", true);
	//		tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
	//			ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
	//		_Map.setEntity("Dummy", tslNew);
	//		
	//		PrPoint ssP(sPromptOrigin1);
	//		// origin
	//		Point3d ptOrigin1,ptOrigin2, ptOrigin3;
	//		int iOrigin1,iOrigin2, iOrigin3;
	//		// destination
	//		Point3d ptDestination1,ptDestination2,ptDestination3;
	//		Map mapArgs;
	//		int nGoJig = -1;
	//		Point3d _pts[0];
	//		while (nGoJig != _kNone)
	//		{
	//			nGoJig = ssP.goJig(strJigAction4, mapArgs);
	//			if(nGoJig==_kOk)
	//			{ 
	//				Point3d ptLast = ssP.value();
	//				if(mapArgs.hasPoint3dArray("pts"))
	//				{
	//					_pts = mapArgs.getPoint3dArray("pts");
	//					
	//					if(_pts.length()==1)
	//					{ 
	//						String sStringPrompt = sPromptOrigin3;
	//						ssP = PrPoint(sStringPrompt);
	//						ptOrigin2 = ptLast;
	//					}
	//					if(_pts.length()==2)
	//					{ 
	//						String sStringPrompt = sPromptDestination1;
	//						ssP = PrPoint(sStringPrompt);
	//						ptOrigin3 = ptLast;
	//					}
	//					else if(_pts.length()==3)
	//					{ 
	//						String sStringPrompt = sPromptDestination2;
	//						ssP = PrPoint(sStringPrompt);
	//						ptDestination1 = ptLast;
	//					}
	//					else if(_pts.length()==4)
	//					{ 
	//						String sStringPrompt = sPromptDestination3;
	//						ssP = PrPoint(sStringPrompt);
	//						ptDestination2= ptLast;
	//					}
	//					else if(_pts.length()==5)
	//					{ 
	//						nGoJig = _kNone;
	//						ptDestination3= ptLast;
	//					}
	//					_pts.append(ptLast);
	//					mapArgs.setPoint3dArray("pts", _pts);
	//				}
	//				else
	//				{
	//					_pts.setLength(0);
	//					_pts.append(ptLast);
	//					ptOrigin1 = ptLast;
	//					mapArgs.setPoint3dArray("pts", _pts);
	//					String sStringPrompt = sPromptOrigin2;
	//					ssP = PrPoint(sStringPrompt);
	//				}
	//				
	//			}
	//			else if(nGoJig==_kNone)
	//			{ 
	//				tslNew.dbErase();
	//			}
	//			
	//		}
	//		// origin
	//		// delete the dummy tsl
	//		tslNew.dbErase();
	//		_Map.removeAt("Dummy", true);
	//		
	//		if(_pts.length()<6)
	//		{ 
	//			setExecutionLoops(2);
	//			return;
	//		}
	//		// check that 3 points define a plane
	//		if((ptOrigin2-ptOrigin1).length()<dEps)
	//		{ 
	//			
	//		}
	//		// 
	//		Vector3d vecX1 = ptOrigin2 - ptOrigin1;vecX1.normalize();
	//		Vector3d vec2=ptOrigin3 - ptOrigin1;vecX1.normalize();
	//		Vector3d vecNormal = vecX1.crossProduct(vec2);
	//		vecNormal.normalize();
	//		if(vecNormal.dotProduct(_ZW)<0)vecNormal*=-1;
	//		Vector3d vecY1 = vecNormal.crossProduct(vecX1);
	//		
	//		// destination
	//		Vector3d _vecX1=ptDestination2 - ptDestination1;_vecX1.normalize();
	//		Vector3d _vec2=ptDestination3 - ptDestination1;_vec2.normalize();
	//		Vector3d _vecNormal = _vecX1.crossProduct(_vec2);
	//		_vecNormal.normalize();
	//		if(_vecNormal.dotProduct(_ZW)<0)_vecNormal*=-1;
	//		Vector3d _vecY1 = _vecNormal.crossProduct(_vecX1);
	//		
	//		_Map.setPoint3d("ptOrig", ptOrigin1);
	//		_Map.setVector3d("vecX1", vecX1);
	//		_Map.setVector3d("vecY1", vecY1);
	//		_Map.setVector3d("vecNormal", vecNormal);
	//		
	//		_Map.setPoint3d("ptDestination", ptDestination1);
	//		_Map.setVector3d("_vecX1", _vecX1);
	//		_Map.setVector3d("_vecY1", _vecY1);
	//		_Map.setVector3d("_vecNormal", _vecNormal);
	//		
	//		
	//		// save the plane by point and normal
	//		_Map.setPoint3d("ptPlane",ptDestination1,_kAbsolute);
	//		_Map.setVector3d("vecPlane", _vecNormal,_kFixedSize);
	//		
	//		// transform pline and grip points
	//		CoordSys csAlign;
	//		csAlign.setToAlignCoordSys(ptOrigin1,vecX1,vecY1,vecNormal,
	//		ptDestination1,_vecX1,_vecY1,_vecNormal);
	//		PLine plAlign = pl;
	//		plAlign.transformBy(csAlign);
	//		_Map.setPLine("Pline", plAlign);
	//		for (int i=0;i<_PtG.length();i++) 
	//		{ 
	//			_PtG[i].transformBy(csAlign); 
	//		}//next i
	//		_Pt0.transformBy(csAlign); 
	//		
	//		setExecutionLoops(2);
	//		return;
	//	}//endregion	
		
	//region Trigger AlignToEntity
		String sTriggerAlignToEntity = T("|Align To Entity|");
		addRecalcTrigger(_kContextRoot, sTriggerAlignToEntity );
		if (_bOnRecalc && _kExecuteKey==sTriggerAlignToEntity)
		{
	//		TslInst tsl = getTslInst(T("|Select Entity|"));
			Entity ent=getEntity(T("|Select Entity|"));
			TslInst tsl=(TslInst)ent;
			Slab slab=(Slab)ent;
			if(!tsl.bIsValid() && ! slab.bIsValid())
			{ 
				reportMessage("\n"+scriptName()+" "+T("|A slab or a tsl RUB-Raum is needed|"));
				setExecutionLoops(2);
				return;
			}
			if(tsl.bIsValid())
			{ 
				_Map.setEntity("TslAlign", tsl);
				_Map.removeAt("ptPlane", true);
				_Map.removeAt("vecPlane", true);
			}
			else if(slab.bIsValid())
			{ 
				_Map.setEntity("TslAlign", slab);
				_Map.removeAt("ptPlane", true);
				_Map.removeAt("vecPlane", true);
			}
			
			setExecutionLoops(2);
			return;
		}//endregion
		
		
	//region Trigger AddSlopeAtVertex
		// supported only for triangles
		String sTriggerAddSlopeAtVertex = T("|Add Slope At Vertex|");
	//	if(_PtG.length()==4)
	//	{
	//		addRecalcTrigger(_kContextRoot, sTriggerAddSlopeAtVertex );
	//		nVertexIndex.setReadOnly(false);
	//	}
	//	else
	//	{ 
	//		nVertexIndex.setReadOnly(true);
	//	}
	//	if (_bOnRecalc && _kExecuteKey==sTriggerAddSlopeAtVertex)
	//	{
	//		String sStringStart = "|Select vertex point|";
	//		String sStringPrompt = T(sStringStart);
	//		
	//		PrPoint ssP(sStringPrompt);
	//		Map mapArgs;
	//		int nGoJig = -1;
	//		
	//		Point3d _pts[0];
	//		_pts.append(_PtG);
	//		_pts.removeAt(_pts.length() - 1);
	//		
	//		mapArgs.setPoint3dArray("pts", _pts);
	//		if(iAligned)
	//		{ 
	//			mapArgs.setPoint3d("ptPlane",_Map.getPoint3d("ptPlane"));
	//			mapArgs.setVector3d("vecPlane",_Map.getVector3d("vecPlane"));
	//		}
	//		else if(iAlignedEntity)
	//		{ 
	//			Entity entTsl = _Map.getEntity("TslAlign");
	//			TslInst tsl = (TslInst)entTsl;
	//			mapArgs.setPoint3d("ptPlane",tsl.map().getPoint3d("ptPlaneTop"));
	//			mapArgs.setVector3d("vecPlane",tsl.map().getVector3d("vecPlaneTop"));
	//		}
	//		
	//		while (nGoJig != _kNone)
	//		{
	//			nGoJig = ssP.goJig(strJigAction6, mapArgs);
	//			if (nGoJig == _kOk)
	//			{
	//				Point3d ptLast = ssP.value();
	//				Vector3d vecView = getViewDirection();
	//				ptLast = Line(ptLast, vecView).intersect(Plane(_Pt0, _ZW), U(0));
	//				
	//				int iIndex = - 1;
	//				double dDist = U(10e6);
	//				for (int ipt = 0; ipt < _pts.length(); ipt++)
	//				{
	//					if ((_pts[ipt] - ptLast).length() < dDist)
	//					{
	//						dDist = (_pts[ipt] - ptLast).length();
	//						iIndex = ipt;
	//					}
	//				}//next ipt
	//				if (iIndex >- 1)
	//				{
	//					nVertexIndex.set(iIndex + 1);
	//					_Map.setInt("VertexSlope", true);
	//				}
	//				nGoJig = _kNone;
	//			}
	//		}
	//		setExecutionLoops(2);
	//		return;
	//	}//endregion	
		
		
	//region Trigger AlignFaces
		if(iAlignedEntity)
		{ 
			// see if any edge match and if the command can be reasonable
			int iAlignFacePossible;
			Entity entTsl=_Map.getEntity("TslAlign");
			TslInst tsl=(TslInst)entTsl;
			Slab slab=(Slab)entTsl;
			Vector3d vecNormalUnderneath;
			Body bdUnderneath;
			if(tsl.bIsValid())
			{ 
				vecNormalUnderneath=tsl.map().getVector3d("vecUnderneath");
				bdUnderneath = tsl.map().getBody("bd");
			}
			else if(slab.bIsValid())
			{ 
				vecNormalUnderneath=slab.coordSys().vecZ();
				bdUnderneath =slab.realBody();
			}
			Point3d ptVertices[]=pl.vertexPoints(false);
			
			PlaneProfile ppUnderneath=bdUnderneath.extractContactFaceInPlane(pn,dEps);
	//			ppUnderneath.vis(6);
			PLine plsUnderneath[]=ppUnderneath.allRings(true,false);
			PLine plUnderneath=plsUnderneath[0];
			Point3d ptVerticesUnderneath[] = plUnderneath.vertexPoints(false);
			// add command "Cut Edges/Do not cut Edges"
			String sTriggerAlignFaces = T("|Align Faces|");
			if(iAlignFaces)
			{ 
				sTriggerAlignFaces = T("|Do not align Faces|");
			}
			int iFaceAlignedAtAll;
			for (int ipt=0;ipt<ptVertices.length()-1;ipt++)
			{ 
				Point3d pt1=ptVertices[ipt];
				Point3d pt2=ptVertices[ipt+1];
				Point3d ptMid=.5*(pt1+pt2);
				Vector3d vec1 = pt2 - pt1;vec1.normalize();
				for (int jpt=0;jpt<ptVerticesUnderneath.length()-1;jpt++)
				{ 
					Point3d _pt1=ptVerticesUnderneath[jpt];
					Point3d _pt2=ptVerticesUnderneath[jpt+1];
					Vector3d _vec1 = _pt2 - _pt1; _vec1.normalize();
					if(abs(abs(vec1.dotProduct(_vec1))-1.0)<dEps)
					{ 
						// parallel, check distance
						double dDist1=(pt1-Line(_pt1,_vec1).closestPointTo(pt1)).length();
						double dDist2=(pt2-Line(_pt1,_vec1).closestPointTo(pt2)).length();
						if(dDist1<dEps && dDist2<dEps)
						{ 
							iFaceAlignedAtAll = true;
							break;
						}
					}
				}//next jpt
				if (iFaceAlignedAtAll)break;
			}
			if(iFaceAlignedAtAll)
			{ 
				addRecalcTrigger(_kContextRoot, sTriggerAlignFaces );
				if (_bOnRecalc && _kExecuteKey==sTriggerAlignFaces)
				{
					if(!iAlignFaces)
					{ 
						_Map.setInt("AlignFaces",!iAlignFaces);
					}
					else if(iAlignFaces)
					{ 
						_Map.setInt("AlignFaces",!iAlignFaces);
					}
					
					setExecutionLoops(2);
					return;
				}//endregion
			}
		}
	}
}





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
        <int nm="BreakPoint" vl="3502" />
        <int nm="BreakPoint" vl="3505" />
        <int nm="BreakPoint" vl="3502" />
        <int nm="BreakPoint" vl="3505" />
        <int nm="BreakPoint" vl="2252" />
        <int nm="BreakPoint" vl="2314" />
        <int nm="BreakPoint" vl="2315" />
        <int nm="BreakPoint" vl="3677" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="20240925: Fix for &quot;Free form&quot; type" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="9/25/2024 3:18:50 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17501: Fix translation" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="3/8/2023 11:20:57 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17535: Add property &quot;max height&quot; to limit max height" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="1/12/2023 1:53:19 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17320: Dont draw volume twice" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="1/10/2023 11:50:13 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17321:Add command &quot;subtract polylines&quot;" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="12/20/2022 10:33:42 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17321:automatic labeling of section cuts" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="12/15/2022 6:44:57 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17321:improve section cuts; add trigger to change height of low points" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="12/15/2022 9:53:37 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17321: Initial" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="12/12/2022 4:55:36 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15668: set properties readonly when tsl is controlled by RUB-Stellfüße" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="14" />
      <str nm="Date" vl="6/9/2022 9:48:26 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15668: fix initialization of grip points" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="6/8/2022 5:27:56 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15602: Smart command &quot;Align Faces&quot;; only shown if possible" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="6/1/2022 11:26:52 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15602: Align only faces at edges that match bottom edges" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="5/31/2022 1:38:16 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15602: Add command &quot;Align faces&quot;" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="5/30/2022 5:40:23 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15602; Apply simple rigid body alignment, dont modify volume" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="5/30/2022 10:40:22 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Fix reference plane for horizontal insulations" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="4/29/2022 11:17:53 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15208: Switch for hatches yes/no" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="4/14/2022 4:07:40 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15208: Expose XML properties" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="4/13/2022 1:58:08 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15208: Property for hazch yes/no" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="4/13/2022 10:11:18 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15208: hide properties &quot;Edge&quot; and &quot;Slope&quot; on insert" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="4/12/2022 4:20:23 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15066: some improvements" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="4/1/2022 3:03:43 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15066: support alignmend between entities, add properties for slope and edge" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="3/30/2022 5:28:48 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15066: New properties for legend visibility and styles" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="3/29/2022 4:01:13 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End