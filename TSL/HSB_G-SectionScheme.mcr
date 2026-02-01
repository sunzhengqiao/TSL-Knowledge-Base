#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
11.11.2013  -  version 1.04



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl draws a section
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.04" date="11.11.2013"></version>

/// <history>
/// AS - 1.00 - 28.10.2013 -	First revision
/// AS - 1.01 - 07.11.2013 -	Send map through memory.
/// AS - 1.02 - 07.11.2013 -	Show recalc warning if points are moved.
/// AS - 1.03 - 11.11.2013 -	Project plines to plane before adding them to the plane profile.
/// AS - 1.04 - 11.11.2013 -	Only move to grip if transform is set to 'yes'.
/// </history>



double vectorTolerance = Unit(0.01, "mm");


String arSNoYes[] = {T("|No|"), T("|Yes|")};

PropString seperator01(0, "", T("|Scheme|"));
seperator01.setReadOnly(true);
PropDouble nameTextHeight(0, U(150), "     "+T("|Text height|"));
PropDouble nameOffset(1, U(500), "     "+T("|Offset name|"));
PropString sectionName(3, "A-A", "     "+T("|Section name|"));
PropString transformSection(4, arSNoYes, "     "+T("|Transform section|"));
PropString showMilling(5, arSNoYes, "     "+T("|Show milling|"));


PropString seperator02(1, "", T("|Dimension|"));
seperator02.setReadOnly(true);
PropString defaultDimensionStyle(2, _DimStyles, "     "+T("|Default dimension style|"));

String arSRecalcProperties[] = {
	"     "+T("|Transform section|"),
	"     "+T("|Show milling|")
};

String arSTrigger[] = {
	T("|Reload Section Scheme|")
};
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );

if (_bOnDebug || _bOnInsert || _kExecuteKey == arSTrigger[0] || arSRecalcProperties.find(_kNameLastChangedProp) != -1) {
	if (_bOnInsert){
		showDialog();
		
		_Pt0 = getPoint(T("|Select start point of section|"));
		while (true){
			PrPoint ssPtEnd(T("|Select end point of section|"), _Pt0);
			if (ssPtEnd.go())
				_PtG.append(ssPtEnd.value());
			
			break;
		}
		
		_PtG.append(getPoint(T("|Select a position|")));
	}
	// Project points to Z-world plane
	Plane worldZPlane(_PtW, _ZW);
	_Pt0 = worldZPlane.closestPointTo(_Pt0);
	_PtG = worldZPlane.projectPoints(_PtG);
	
	_Map.setPoint3d("StartPointSection", _Pt0, _kAbsolute);
	_Map.setPoint3d("EndPointSection", _PtG[0], _kAbsolute);
	
	// Verify grip points. Add points if there are not enough points. A message is shown too.
	if (_PtG.length() < 2){
		reportMessage(T("|Required points are created by tsl|")+TN("|Please verify those points|."));
		if (_PtG.length() == 0)
			_PtG.append(_Pt0 - _YW * U(100));
		
		_PtG.append(_Pt0 + (_YW - _XW) * U(1000));
	}	
	
	// Collect the entities.
	Entity arEntRoofPlane[] = Group().collectEntities(true, ERoofPlane(), _kModelSpace);
	Entity arEntElementRoof[] = Group().collectEntities(true, ElementRoof(), _kModelSpace);
	
	// Create a small rectangle to check for instersection
	Vector3d vxSection(_PtG[0] - _Pt0);
	vxSection.normalize();
	Vector3d vySection = _ZW.crossProduct(vxSection);
	CoordSys csSection(_Pt0, vxSection, vySection, _ZW);
	Plane sectionPlane(csSection.ptOrg(), csSection.vecZ());
	
	PLine sectionRectangle(_ZW);
	sectionRectangle.createRectangle(LineSeg(_Pt0 - vySection, _PtG[0] + vySection), vxSection, vySection);
	PlaneProfile sectionProfile(csSection);
	sectionProfile.joinRing(sectionRectangle, _kAdd);
	sectionProfile.vis(3);
	
	// Only collect roofplanes with intersection with this section.
	_Entity.setLength(0);
	for (int i=0;i<arEntElementRoof.length();i++) {
		ElementRoof roofElement = (ElementRoof)arEntElementRoof[i];
		if (!roofElement.bIsValid())
			continue;
		
		PLine roofElementEnvelope = roofElement.plEnvelope();
		roofElementEnvelope.projectPointsToPlane(sectionPlane, csSection.vecZ());
		
		PlaneProfile roofElementProfile(csSection);
		roofElementProfile.joinRing(roofElementEnvelope, _kAdd);
		roofElementProfile.vis(1);
		if (roofElementProfile.intersectWith(sectionProfile)){
			_Entity.append(roofElement);
			roofElementProfile.vis(i);
		}
	}
	
	// Only collect roofplanes with intersection with this section.
	for (int i=0;i<arEntRoofPlane.length();i++) {
		ERoofPlane roofPlane = (ERoofPlane)arEntRoofPlane[i];
		if (!roofPlane.bIsValid())
			continue;
		
		PLine roofPlaneEnvelope = roofPlane.plEnvelope();
		roofPlaneEnvelope.projectPointsToPlane(sectionPlane, csSection.vecZ());
		
		PlaneProfile roofPlaneProfile(csSection);
		roofPlaneProfile.joinRing(roofPlaneEnvelope, _kAdd);
		
		if (roofPlaneProfile.intersectWith(sectionProfile)){
			_Entity.append(roofPlane);
			roofPlaneProfile.vis(i);
		}
	}
		
	ModelMapComposeSettings mmComposeFlags;
	mmComposeFlags.addSolidInfo(true); // default FALSE
	mmComposeFlags.addAnalysedToolInfo(true); // default FALSE
	mmComposeFlags.addElemToolInfo(true); // default FALSE
	mmComposeFlags.addConstructionToolInfo(true); // default FALSE
	mmComposeFlags.addHardwareInfo(true); // default FALSE
	mmComposeFlags.addRoofplanesAboveWallsAndRoofSectionsForRoofs(true); // default FALSE
	mmComposeFlags.addCollectionAndBlockDefinitions(true); // default FALSE
	
	
	// set some import flags
	ModelMapInterpretSettings mmInterpretFlags;
	mmInterpretFlags.resolveEntitiesByHandle(true); // default FALSE
	mmInterpretFlags.resolveElementsByNumber(true); // default FALSE
	mmInterpretFlags.setBeamTypeNameAndColorFromHsbId(true); // default FALSE
	
	// Compose modelmap data from the selected entities.
	ModelMap mm;
	mm.setEntities(_Entity);
	mm.dbComposeMap(mmComposeFlags);
	
	// Create a map from it.
	Map mapIn = mm.map();
	// Add section specific information
	Map sectionMap;
	sectionMap.setString("Name", sectionName);
	sectionMap.setPoint3d("PtOrg", _Pt0);
	sectionMap.setVector3d("VecX", vxSection);
	sectionMap.setVector3d("VecY", vySection);
	sectionMap.setInt("Transform", arSNoYes.find(transformSection,0));
	sectionMap.setInt("ShowMilling", arSNoYes.find(showMilling,0));
	mapIn.setMap("Section", sectionMap);
	
	//Data for function to get the section details (before version 19, we need to use the Spaw functie
	String strAssemblyPath = _kPathHsbInstall + "\\Utilities\\HsbDog\\HsbDogExe.exe";
	String strType = "hsbSoft.Construct.Hsb2dDog"; //Calldotnet.
	String strFunction = "TslCreateSection"; //Calldotnet.

	String sExtension = ".dxx";
	int useCallDotNet = false;
	if (hsbOEVersion().mid(6,2).atoi() > 18) {
		sExtension = ".hmm";
		useCallDotNet = true;
	}

	// Write map in for debugging.
	String sMapName = _kPathPersonalTemp +  "\\Section_in" + sExtension;
	mapIn.writeToDxxFile(sMapName);
	
	Map mapOut ;
	//change the assembly Path for using the Calldotnetfunction2.
	if (useCallDotNet) {
		sExtension = ".hmm";
		strAssemblyPath = _kPathHsbInstall + "\\Utilities\\HsbDog\\HsbDog.dll";
		
		// Call method to calculate the section data
		mapOut = callDotNetFunction2(strAssemblyPath, strType, strFunction, mapIn); 
		sMapName = _kPathPersonalTemp + "\\" + projectNumber() + "_out" + sExtension;
		mapOut.writeToDxxFile(sMapName);	
	}
	else{
		// Call method to calculate the section data
		//reportMessage("Loose materials written to: "+sFile);
		String sMapOutName = _kPathPersonalTemp +  "\\Section_Out" + sExtension;
		spawn("", strAssemblyPath , "\""+ sMapName +"\"", "");
		mapOut.readFromDxxFile(sMapOutName );
	}
	
	_Map.setMap("SectionScheme", mapOut);//mm.map());
	_Map.setPoint3d("SectionLocation", _PtW, _kAbsolute);

	if (_bOnInsert)
		return;
}

// Display's used for drawing things.
Display display(-1);
display.textHeight(nameTextHeight);
Display dpWarning(1);
dpWarning.textHeight(0.25 * nameTextHeight);

Display detailDisplay(-1);
Display dimensionDisplay(-1);
dimensionDisplay.dimStyle(defaultDimensionStyle);
Display blockdisplay(-1);
Display textdisplay(-1);
textdisplay.dimStyle(defaultDimensionStyle);

// Project points to Z-world plane
Plane worldZPlane(_PtW, _ZW);
_Pt0 = worldZPlane.closestPointTo(_Pt0);
_PtG = worldZPlane.projectPoints(_PtG);

int recalcRequired = false;
if (_Map.hasPoint3d("StartPointSection")) {
	Point3d startPointSection = _Map.getPoint3d("StartPointSection");
	if ((startPointSection - _Pt0).length() > vectorTolerance)
		recalcRequired = true;
}
if (_Map.hasPoint3d("EndPointSection")) {
	Point3d endPointSection = _Map.getPoint3d("EndPointSection");
	if ((endPointSection - _PtG[0]).length() > vectorTolerance)
		recalcRequired = true;
}

// Verify grip points. Add points if there are not enough points. A message is shown too.
if (_PtG.length() < 2){
	reportMessage(T("|Required points are created by tsl|")+TN("|Please verify those points|."));
	if (_PtG.length() == 0)
		_PtG.append(_Pt0 - _YW * U(100));
	
	_PtG.append(_Pt0 + (_YW - _XW) * U(1000));
}

if (!_Map.hasPoint3d("Origin")) 
	_Map.setPoint3d("Origin", _Pt0, _kAbsolute);
Point3d originPoint = _Map.getPoint3d("Origin");
if ((originPoint - _Pt0).length() > vectorTolerance) {
	_PtG[1].transformBy(originPoint - _Pt0);
	_Map.transformBy(originPoint - _Pt0);
	_Map.setPoint3d("Origin", _Pt0, _kAbsolute);
}

// Move map to section location.
if (arSNoYes.find(transformSection,0)) {
	if (!_Map.hasPoint3d("SectionLocation"))
		_Map.setPoint3d("SectionLocation", _PtW, _kAbsolute);
	Point3d previousSectionLocation = _Map.getPoint3d("SectionLocation");
	_Map.transformBy(_PtG[1] - previousSectionLocation);
	_Map.setPoint3d("SectionLocation", _PtG[1], _kAbsolute);
}

Vector3d vxSection(_PtG[0] - _Pt0);
vxSection.normalize();
Vector3d vzSection = _ZW;
Vector3d vySection = vzSection.crossProduct(vxSection);
CoordSys csSection(_Pt0, vxSection, vySection, vzSection);

// Draw section symbol
PLine sectionSymbol(vzSection);
sectionSymbol.addVertex(_Pt0 + vySection * U(100));
sectionSymbol.addVertex(_Pt0);
sectionSymbol.addVertex(_PtG[0]);
sectionSymbol.addVertex(_PtG[0] + vySection * U(100));
display.draw(sectionSymbol);

Vector3d vyName = -vySection;
if (abs(vyName.dotProduct(_YW)) > vectorTolerance){
	if (vyName.dotProduct(_YW) < 0)
		vyName *= -1;
}
Vector3d vxName = vyName.crossProduct(_ZW);

display.draw(sectionName, _Pt0 - vxSection * nameOffset, vxName, vyName, -1, 0);
if (recalcRequired)
	dpWarning.draw(T("|Recalculate is required|"), _Pt0 - vxSection * nameOffset, vxName, vyName, -1, -6);

// Horizontal and vertical line. These lines are used for sorting.
Line horizontalLine(_Pt0, _XW);
Line verticalLine(_Pt0, _YW);

// This tsl is part of layer 0.
_ThisInst.assignToLayer("0");

Point3d verticesFromAllSchemes[0];
Map sectionSchemeMap = _Map.getMap("SectionScheme");
for (int i=0;i<sectionSchemeMap.length();i++) {
	if (!sectionSchemeMap.hasMap(i))
		continue;
	if (sectionSchemeMap.keyAt(i) != "Scheme")
		continue;
	
	// Get the map that describes this scheme.
	Map schemeMap = sectionSchemeMap.getMap(i);
	
	// The name of this scheme
	String schemeName = schemeMap.getString("Name");
	
	// Draw the plines for this scheme.
	if (schemeMap.hasMap("PLine")) {
		Map pLineMap = schemeMap.getMap("PLine");
		
		//Set layer
		if	(pLineMap.hasString("Layer"))
			display.layer(pLineMap.getString("Layer"));
		
		
		PLine schemePLine = pLineMap.getPLine("Pline");
		display.draw(schemePLine);
		
		// Find the origin points and draw the name of the section. 
		// NOTE: The location might be forced by the ModelMap in the future.
		Point3d schemeVertices[] = schemePLine.vertexPoints(true);
		verticesFromAllSchemes.append(schemeVertices);
		schemeVertices = horizontalLine.orderPoints(schemeVertices);
		if (schemeVertices.length() > 0)
			display.draw(schemeName, schemeVertices[0] - _XW * nameOffset, _XW, _YW, -1, 1);
	}
	
	
	for (int j=0;j<schemeMap.length();j++) {
		if (!schemeMap.hasMap(j))
			continue;
		
		// Draw the dimension lines for this scheme.
		if (schemeMap.keyAt(j) == "Dimension"){		
			Map dimensionMap = schemeMap.getMap(j);
			
			// Set dimension style and layer, if specified.
			if (dimensionMap.hasString("DimensionStyle"))
				dimensionDisplay.dimStyle(dimensionMap.getString("DimensionStyle"));
			if	(dimensionMap.hasString("Layer")){
				String dimensionLayer = dimensionMap.getString("Layer").makeUpper();
				dimensionDisplay.layer(dimensionLayer);
			}
	
			// Get dimlines.
			for (int k=0;k<dimensionMap.length();k++) {
				if (!dimensionMap.hasMap(k))
					continue;
				if (dimensionMap.keyAt(k) != "DimLine")
					continue;
				
				// Create the dimlines.
				Map dimLineMap = dimensionMap.getMap(k);
				DimLine dimLine(dimLineMap.getPoint3d("PtOrg"), dimLineMap.getVector3d("VecX"), dimLineMap.getVector3d("VecY"));
				Dim dim(dimLine, dimLineMap.getPoint3dArray("DimPoints"), "<>", "<>", _kDimPar, _kDimNone);
				// Draw the dimension line.
				dimensionDisplay.draw(dim);
			}//Dimline
		}//Dimension
		else if (schemeMap.keyAt(j) == "Details" || schemeMap.keyAt(j) == "Section"  ){ // Draw the details for this scheme.
			Map detailsMap = schemeMap.getMap(j);
			for (int k=0;k<detailsMap.length();k++) {
				if (!detailsMap.hasMap(k))
					continue;
					
					// Draw the dimension lines for this scheme.
								
				if (detailsMap .keyAt(k) == "Detail"){		
					Map dimensionMap = schemeMap.getMap(k);
							
				
					Map detailMap = detailsMap.getMap(k);
					for (int l=0;l<detailMap.length();l++) {
						if (!detailMap.hasMap(l))
							continue;
							
						if (detailMap .keyAt(l) == "PLine"){		
							
							Map plineMap = detailMap.getMap(l);
							
							if (plineMap.hasString("Layer"))
								detailDisplay.layer(plineMap.getString("Layer").makeUpper());
								
							detailDisplay.draw(plineMap.getPLine("Pline"));
				            }//Pline
				
						if (detailMap .keyAt(l) == "Dimension"){		
							Map dimensionMap = detailMap.getMap(l);
							
							// Set dimension style and layer, if specified.
							if (dimensionMap.hasString("DimensionStyle"))
								dimensionDisplay.dimStyle(dimensionMap.getString("DimensionStyle"));
							if	(dimensionMap.hasString("Layer")){
								String dimensionLayer = dimensionMap.getString("Layer").makeUpper();
								dimensionDisplay.layer(dimensionLayer);
							}//Layer
					
							// Get dimlines.
							for (int d=0;d<dimensionMap.length();d++) {
								if (!dimensionMap.hasMap(d))
									continue;
								if (dimensionMap.keyAt(d) != "DimLine")
									continue;
								
								// Create the dimlines.
								Map dimLineMap = dimensionMap.getMap(d);
								DimLine dimLine(dimLineMap.getPoint3d("PtOrg"), dimLineMap.getVector3d("VecX"), dimLineMap.getVector3d("VecY"));
								Dim dim(dimLine, dimLineMap.getPoint3dArray("DimPoints"), "<>", "<>", _kDimPar, _kDimNone);
								// Draw the dimension line.
								dimensionDisplay.draw(dim);
							}//DimLine
						}//Dimension
				
						if (detailMap .keyAt(l) == "Block[]"){ //GJB  Draw the Blocks for this scheme.
							Map BlocksMap = detailMap.getMap(l);
							
							//block will be set on a layer 
							if	(BlocksMap .hasString("Layer")){
								String dimensionLayer = BlocksMap .getString("Layer").makeUpper();
								blockdisplay.layer(dimensionLayer);
						      }
							
							for (int b=0;b<BlocksMap .length();b++) {
								if (!BlocksMap.hasMap(b))
									continue;
								if (BlocksMap.keyAt(b) != "Block")
									continue;
							
								Map blockMap = BlocksMap .getMap(b);
			   		     			
								Block blck(blockMap.getString("BlockName").makeUpper());
			 					
								blockdisplay.draw(blck, blockMap.getPoint3d("PtInsert"), blockMap.getVector3d("VecX"), blockMap.getVector3d("VecY") , blockMap.getVector3d("VecZ") );
							}
						}//Blocks 
						if (detailMap .keyAt(l) == "Text"){ //GJB  Draw the Text for this scheme.
							Map textMap = detailMap .getMap(l);

							
							//block will be set on a layer 
							if	(textMap.hasString("Layer")){
								String dimensionLayer = textMap.getString("Layer").makeUpper();
								textdisplay.layer(dimensionLayer);
						      }
															
							if (textMap .hasString("DimensionStyle"))
						      	textdisplay.dimStyle(textMap .getString("DimensionStyle"));
			
			
					    		String sText = textMap .getString("Text");
			 					
			                         textdisplay.draw(sText , textMap .getPoint3d("PtInsert"), textMap .getVector3d("VecX"), textMap .getVector3d("VecY") , textMap .getDouble("DxFlag"), textMap .getDouble("DyFlag") );
							
						}//Texten.
					}	
				}
			}//End Detail.
		 
		}//End Details / Section
		
		/*
		else if (schemeMap.keyAt(j) == "Section" ){ // Draw the details for this scheme.
			Map detailsMap = schemeMap.getMap(j);
			for (int s=0;s<detailsMap.length();s++) {
				if (!detailsMap.hasMap(s))
					continue;
				if (detailsMap.keyAt(s) != "Detail")
					continue;
				
				Map detailMap = detailsMap.getMap(s);
				for (int sc=0;sc<detailMap.length();sc++) {
					if (!detailMap.hasMap(sc))
						continue;
					if (detailMap.keyAt(sc) != "PLine")
						continue;
					
					Map plineMap = detailMap.getMap(sc);
					
					if (plineMap.hasString("Layer"))
						detailDisplay.layer(plineMap.getString("Layer").makeUpper());
						
					detailDisplay.draw(plineMap.getPLine("Pline"));
				}
			}
		}
            */

		else if (schemeMap.keyAt(j) == "Blocks"){ //GJB  Draw the Blocks for this scheme.
			Map BlocksMap = schemeMap.getMap(j);
			
			//block will be set on a layer 
			if	(BlocksMap .hasString("Layer")){
				String dimensionLayer = BlocksMap .getString("Layer").makeUpper();
				blockdisplay.layer(dimensionLayer);
		      }
			
			for (int b=0;b<BlocksMap .length();b++) {
				if (!BlocksMap.hasMap(b))
					continue;
				if (BlocksMap.keyAt(b) != "Block")
					continue;
			
				Map blockMap = BlocksMap .getMap(b);
   		     			
				Block blck(blockMap.getString("BlockName").makeUpper());
 					
				blockdisplay.draw(blck, blockMap.getPoint3d("PtInsert"), blockMap.getVector3d("VecX"), blockMap.getVector3d("VecY") , blockMap.getVector3d("VecZ") );
			}//Single Blocks.
		
		
		}//Blocks
		else if (schemeMap.keyAt(j) == "Texten"){ //GJB  Draw the Text for this scheme.
			Map TextsMap = schemeMap.getMap(j);
			
			//block will be set on a layer 
			if	(TextsMap .hasString("Layer")){
				String dimensionLayer = TextsMap .getString("Layer").makeUpper();
				textdisplay.layer(dimensionLayer);
		      }
			
			for (int t=0;t<TextsMap .length();t++) {
				if (!TextsMap .hasMap(t))
					continue;
					
				if (TextsMap .keyAt(t) != "Text")
					continue;
			
				Map textMap = TextsMap .getMap(t);
   		     			
				if (textMap .hasString("DimensionStyle"))
			      	textdisplay.dimStyle(textMap .getString("DimensionStyle"));


	     			String sText = textMap .getString("Text");
 					
				textdisplay.draw(sText , textMap .getPoint3d("PtInsert"), textMap .getVector3d("VecX"), textMap .getVector3d("VecY") , textMap .getDouble("DxFlag"), textMap .getDouble("DyFlag") );
			}// Single Text.
		
		}// Texten.

	}//SchemaMap.

}

//Point3d verticesFromAllSchemesX[] = horizontalLine.orderPoints(verticesFromAllSchemes);
//Point3d verticesFromAllSchemesY[] = verticalLine.orderPoints(verticesFromAllSchemes);
//if (verticesFromAllSchemesX.length() * verticesFromAllSchemesY.length() > 0){
//	_Pt0 = verticesFromAllSchemesX[0] - _XW * nameOffset;
//	_Pt0 += _YW * _YW.dotProduct(verticesFromAllSchemesY[0] - _YW * nameOffset - _Pt0);
//}
	


#End
#BeginThumbnail




#End
