#Version 8
#BeginDescription
Dieses TSL erzeugt eine CNC Fräs- oder Sägelinie bzw eine Sperrfläche einer Zone an einem Element
This TSL creates a saw or milling line or a no nail area of a zone of an element

#Versions
8.6 10/09/2024 HSB-22653: Add property "Clear tool diameter" Marsel Nakuci
Version 8.5 09.02.2023 HSB-17910 bugfixes on arced segments and if defining polyline is within plane of zone , Author Thorsten Huck
Version 8.4 10.01.2023 HSB-17081 circle tests improved

Version 8.3 26.10.2022 HSB-16660 contour test improved (accepting multiple self interscting rings)
Version 8.2 19.10.2022 HSB-16822: Fix intersection point failing when line parallel with plane
Version 8.1 01.07.2022 HSB-15660: add description for zone explaining meaning of 99 and -99
Version 8.0 20.09.2021 HSB-13220 TSL selection as defining entity supported if defining contour published




















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 8
#MinorVersion 6
#KeyWords Element;CNC;Saw;Mill;Mark;Marker;NoNail
#BeginContents
//region Part #1
//region History
/// History
// #Versions
// 8.6 10/09/2024 HSB-22653: Add property "Clear tool diameter" Marsel Nakuci
// 8.5 09.02.2023 HSB-17910 bugfixes on arced segments and if defining polyline is within plane of zone , Author Thorsten Huck
// 8.4 10.01.2023 HSB-17081 circle tests improved , Author Thorsten Huck
// 8.3 26.10.2022 HSB-16660 contour test improved (accepting multiple self interscting rings) , Author Thorsten Huck
// 8.2 19.10.2022 HSB-16822: Fix intersection point failing when line parallel with plane Author: Marsel Nakuci
// 8.1 01.07.2022 HSB-15660: add description for zone explaining meaning of 99 and -99 Author: Marsel Nakuci
// 8.0 20.09.2021 HSB-13220 TSL selection as defining entity supported if defining contour published , Author Thorsten Huck
// 7.9 10.02.2021 HSB-10705 defining polylines or circles are projected to the zone if not parallel with zone. Projected arcs will be approximated. , Author Thorsten Huck
///<version value="7.8" date="21jan2020" author="nils.gregor@hsbcad.com"> HSB-10185 Add selection of circle </version>
///<version value="7.7" date="26may2020" author="thorsten.huck@hsbcad.com"> HSB-7745 sawline segments which are colinear with neighbouring sheets are excluded </version>
///<version  value="7.6" date="22jan20" author="marsel.nakuci@hsbcad.com"> HSB-6409: add display dpZone to indicate color of zone </version>
///<version  value="7.5" date="18jun2019" author="thorsten.huck@hsbcad.com"> HSBCAD-294 new custom command to swap direction, custom commands in top level </version>
///<version  value="7.4" date="05jun19" author="marsel.nakuci@hsbcad.com"> fix side of ElemSaw </version>
///<version  value="7.3" date="05jun19" author="marsel.nakuci@hsbcad.com"> previous change in v7.2 to be applied for each segment </version>
///<version  value="7.2" date="05jun19" author="marsel.nakuci@hsbcad.com"> if the length of the ElemSaw < 230 and material of the zone =="UD-Platte 60 mm", the depth of ElemSaw=10mm </version>
///<version  value="7.1" date="20sep18" author="thorsten.huck@hsbcad.com"> purging of tool segments which are on any sheeting edge prepared </version>
///<version  value="7.0" date="13Jul18" author="thorsten.huck@hsbcad.com"> debug controller added </version>
///<version  value="6.9" date="03Jul18" author="thorsten.huck@hsbcad.com"> beam mode supports context command to alter the body type (realBody, envelopeBody etc) </version>
///<version  value="6.8" date="06Jun18" author="thorsten.huck@hsbcad.com"> new solid operation option includes no nail area on a solid operation, text location fixed for sheet as defining entity</version>
///<version  value="6.7" date="14Mar18" author="thorsten.huck@hsbcad.com"> sheet supported as defining entity </version>
///<version  value="6.6" date="28jul17" author="thorsten.huck@hsbcad.com"> error trap for invalid instances improved </version>
///<version  value="6.5" date="19apr17" author="thorsten.huck@hsbcad.com"> contour test excluded for pline based circles </version>
///<version  value="6.4" date="16feb17" author="thorsten.huck@hsbcad.com"> sheets with a normal not parallel with element z-axis contribute projected contour </version>
///<version  value="6.3" date="13oct16" author="thorsten.huck@hsbcad.com"> bugfix solid subtract contour for non grip based contours </version>
///<version  value="6.2" date="15sep16" author="thorsten.huck@hsbcad.com"> bugfix solid subtract contour </version>
///<version  value="6.1" date="05sep16" author="florian.wuermseer@hsbcad.com"> bugfix - centerd alignment of cnc tools </version>
///<version  value="6.0" date="24jun16" author="thorsten.huck@hsbcad.com"> UI / image enhanced </version>
///<version  value="5.9" date="19may16" author="thorsten.huck@hsbcad.com"> base point of no nail areas set to center of tool contour </version>
///<version  value="5.8" date="17may16" author="thorsten.huck@hsbcad.com"> no nail areas support multiple rings based on intersection of zone with defining tool contour </version>
///<version  value="5.7" date="12may16" author="thorsten.huck@hsbcad.com"> clearing supports 'automatic' side </version>
///<version  value="5.6" date="12may16" author="thorsten.huck@hsbcad.com"> availability of clearing of milling tools dependent from closed defining contour </version>
///<version  value="5.5" date="11may16" author="thorsten.huck@hsbcad.com"> tsl  dependent mode (plCNC) enhanced, segment detection further enhanced </version>
///<version  value="5.4" date="21apr16" author="thorsten.huck@hsbcad.com"> read only of side mode deactivated for defining entities. Use side mode 'Automatic' instead </version>
///<version  value="5.3" date="18apr16" author="thorsten.huck@hsbcad.com"> side modes extended witrh properties 'Center' and 'Automatic'. Multiple tool lines supported, multiple no nail areas suppoerted </version>
///<version  value="5.2" date="05apr16" author="thorsten.huck@hsbcad.com"> side test added for map based pline definitions during creation </version>
///<version  value="5.1" date="04apr16" author="thorsten.huck@hsbcad.com"> contour test added for map based pline definitions </version>
///<version  value="5.0" date="07mar16" author="thorsten.huck@hsbcad.com"> polygonal no nail areas are only supported for more than 3 defining vertices </version>
///<version  value="4.9" date="02mar16" author="thorsten.huck@hsbcad.com"> bugfix beam dependency </version>
///<version  value="4.8" date="29feb16" author="thorsten.huck@hsbcad.com"> translation corrected </version>
///<version  value="4.7" date="29feb16" author="thorsten.huck@hsbcad.com"> bugfix automatic tool side when dependent from beam, opening or closed polyline </version>
///<version  value="4.6" date="26feb16" author="thorsten.huck@hsbcad.com"> smoothening of zone contour tolerances (gable walls) </version>
///<version  value="4.5" date="25feb16" author="thorsten.huck@hsbcad.com"> new variable @(Name) supported to display the name of a potential beam link </version>
///<version  value="4.4" date="25feb16" author="thorsten.huck@hsbcad.com"> new context commands to change dependency </version>
///<version  value="4.3" date="24feb16" author="thorsten.huck@hsbcad.com"> supports intersecting beam as defining object, new properties to define gaps to defining contour if object based, new variable @(Cross Section) supported to display the size of a potential beam link </version>
///<version  value="4.2" date="24nov15" author="thorsten.huck@hsbcad.com"> supports polygonal no nail areas </version>
///<version  value="4.1" date="19oct15" author="thorsten.huck@hsbcad.com"> 'clear tooling' only available if depth < zone thickness </version>
///<version  value="4.0" date="05oct15" author="thorsten.huck@hsbcad.com"> new context command 'clear tooling' for millings which are defined by closed contour. This option will offset the contour by a given offset until the entire area is covered </version>
///<version  value="3.9" date="22jun15" author="thorsten.huck@hsbcad.com"> transformation in X and or Y direction of the element transforms tsl based parent entity accordingly </version>
///<version  value="3.8" date="10feb15" author="thorsten.huck@hsbcad.com"> dependency to replicator entity fixed </version>
///<version  value="3.7" date="26jan15" author="thorsten.huck@hsbcad.com"> bugfix coordSys of defining polyline set to selected zone if dependent from tsl (introduced 2.6) </version>
///<version  value="3.6" date="21jan15" author="thorsten.huck@hsbcad.com"> bugfix solid operations also done on zones below the selected if depth exceeds current zone thickness </version>
///<version  value="3.5" date="21jan15" author="thorsten.huck@hsbcad.com"> solid operations also done on zones below the selected if depth exceeds current zone thickness </version>
///<version  value="3.4" date="21jan15" author="thorsten.huck@hsbcad.com"> bugfix solid operation on polygonal shapes  </version>
///<version  value="3.3" date="19jan15" author="thorsten.huck@hsbcad.com"> rectangular subtraction shapes are more tolerant to slightly intersecting sheets  </version>
///<version  value="3.2" date="27nov14" author="thorsten.huck@hsbcad.com"> bugfix snap to edge </version>
///<version  value="3.1" date="13nov14" author="thorsten.huck@hsbcad.com"> outmost zones (-99 and 99) supported </version>
///<version  value="3.0" date="12nov14" author="thorsten.huck@hsbcad.com"> contour detection of sheets more tolerant </version>
///<version  value="2.9" date="24oct14" author="thorsten.huck@hsbcad.com"> bugfix catalog based insertion </version>
///<version  value="2.8" date="24oct14" author="thorsten.huck@hsbcad.com"> double click event added to toggle left and right side of saw or milling lines </version>
///<version  value="2.7" date="22oct14" author="thorsten.huck@hsbcad.com"> validates a potential catalog entry if the tool is inserted with an executeKey </version>
///<version  value="2.6" date="21oct14" author="thorsten.huck@hsbcad.com"> supports also tsl's which are publishing it's coordinate system and a describing polyine named 'plCNC'</version>
///<version  value="2.5" date="17oct14" author="thorsten.huck@hsbcad.com"> negative values of depth are taken as an additional tool depth of selected zone thickness , new tool type 'Marker' supported, catalog entry based insertion supported if execution key carries tool, i.e. <Entry>?<Tool>, Tool may take the (translatable) values of the tool property, new optional text, property 'Auto NoNail' changed to 'Solid operation' with new options</version>
///<version  value="2.4" date="07aug13" author="thorsten.huck@hsbcad.com"> bugfix snap to edge </version>
///<version  value="2.3" date="09jul13" author="thorsten.huck@hsbcad.com"> insertion can be sheet or element based, new property to add a no nail area to the closed contour of saw and/or milling lines</version>
///<version  value="2.2" date="05jun13" author="thorsten.huck@hsbcad.com"> bugfix if replicated defining entity is erased, new zone relation 'exclusive' added. When a zone relation is set to exclusive the tool will only be applied if the current zone mmatches </version>
///<version  value="2.1" date="04jun13" author="thorsten.huck@hsbcad.com"> bugfixes </version>
///<version  value="2.0" date="07may13" author="thorsten.huck@hsbcad.com"> bugfixes </version>
///<version  value="1.9" date="07may13" author="thorsten.huck@hsbcad.com"> new option to define the zone relative to the parent object</version>
///<version  value="1.8" date="05may13" author="thorsten.huck@hsbcad.com"> debug version</version>
///<version  value="1.7" date="29apr13" author="thorsten.huck@hsbcad.com"> replicator functionality added</version>
///<version  value="1.6" date="24apr13" author="thorsten.huck@hsbcad.com"> renamed to hsbCNC, derived from hsbCNC-Line, new tool option no nail area, optional dependency to polyline or openings added</version>
///<version  value="1.5" date="23apr13" author="thorsten.huck@hsbcad.com"> new custom command to disable default 'snap to edge beahviour', CNC Lines inserted by grip points will not be removed on generate/delete construction </version>
///<version  value="1.4" date="23apr13" author="thorsten.huck@hsbcad.com"> new custom commands to add or to remove points, new rectangular closing of L-Shape or valid polygonal contours</version>
///<version  value="1.3" date="22apr13" author="thorsten.huck@hsbcad.com"> selection object changed to sheet, new mode for block replication introduced</version>
///<version  value="1.2" date="01mar13" author="thorsten.huck@hsbcad.com"> tolerances increased</version>
///<version  value="1.1" date="24aug12" author="thorsten.huck@hsbcad.com"> bugfix</version>
///<version  value="1.0" date="24aug12" author="thorsten.huck@hsbcad.com"> initial</version>

/// <summary Lang=de>
/// Dieses TSL erzeugt eine CNC Fräs- oder Sägelinie bzw eine Sperrfläche einer Zone an einem Element
/// </summary>
/// <insert Lang=de>
/// This TSL creates a saw or milling line or a no nail area of a zone of an element
/// </insert>		
//End History//endregion 

// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));
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
	//endregion


//region Functions #func
//	void drawPLine(PLine pl, double offset,  int color, int fillTransparent)
//	{ 
//		Display dp(color);
//		pl.transformBy(pl.coordSys().vecZ() * offset);
//		if (fillTransparent>0)
//			dp.draw(PlaneProfile(pl), _kDrawFilled, fillTransparent);
//		else
//			dp.draw(pl);
//	}
//endregion 

//region Properties
	String sPromptDefiningObjects = T("|(Beam, Polyline, Circle, Window, Door or Opening)|");
	String sVariables[] = {T("|Width|"), T("|Height|"),T("|Cross Section|"), T("|Name|")};
	String sTypeNames [] = { "CIRCLE", "ELLIPSE"};

	
	int nZones[0];
	if (_Element.length()>0)
	{
		Element el = _Element[0];
		nZones.append(-99);
		for (int i=-5;i<6;i++)	
			if (el.zone(i).dH()>dEps && i!=0)
				nZones.append(i);
		nZones.append(99);		
	}
	else
	{
		int n[] = {-99,-5,-4,-3,-2,-1,1,2,3,4,5,99};	
		nZones=n;
	}
	
	// categories
	String sCatToolProps = T("|Machining|");
	String sCatTool = T("|Tool|");
	String sCatDesc = T("|Description|");
	String sCatRelation = T("|Relation|");

	String sSides[]= {T("|Left|"),T("|Right|"),T("|Center|"), T("|Automatic|")};
	int nSides[]={_kLeft, _kRight,_kCenter, 2};
	PropString sSide(nStringIndex++,sSides,"(F)   " +T("|Side|"));
	int nSide = nSides[sSides.find(sSide,0)];
	sSide.setCategory(sCatToolProps);
	
	String sTurningDirections[]= {T("|Against course|"),T("|With course|")};
	int nTurningDirections[]={_kTurnAgainstCourse, _kTurnWithCourse};
	PropString sTurningDirection(nStringIndex++,sTurningDirections,"(G)   " +T("|Turning direction|"));
	int nTurn = nTurningDirections[sTurningDirections.find(sTurningDirection,0)];	
	sTurningDirection.setCategory(sCatToolProps);

	int nArShoot[]={_kNo, _kYes};
	PropString sShoot(nStringIndex++,sNoYes,"(H)   " +T("|Overshoot|"));
	int nShoot = nArShoot[sNoYes.find(sShoot,0)];	
	sShoot.setCategory(sCatToolProps);
	
	int nToolColors[] = {4,3,252,222};
	String sTools[]= {T("|Saw|"),T("|Milling|"), T("|No Nailing Zone|"), T("|Marker|")};
	PropString sTool(nStringIndex++,sTools,"(A)   " + T("|Tool|"));		
	sTool.setCategory(sCatTool);
			
	PropInt nZone(0,nZones,"(B)   " +T("|Zone|"));
	nZone.setDescription(T("|Defines the zone.|")+" "
		+T("|99 will indicate the outmost positive zone, -99 will indicate the outmost negative zone.|"));
	nZone.setCategory(sCatTool);
		
	String sZoneRelations[]= {T("|Standard|"),T("|Relative|"),T("|Exclusive|")};
	PropString sZoneRelation(nStringIndex++,sZoneRelations,"(E)   " +T("|Relation|"));
	sZoneRelation.setCategory(sCatRelation);

	String sSolidOperations[] = {T("|no Operation|"), T("|no Operation|")+T(" |with Nonail area|"), T("|Solid Operation|"), T("|Solid Operation|")+T(" |with Nonail area|")};
	PropString sSolidOperation(nStringIndex++,sSolidOperations,"(C)   " +T("|Solid Operation|"));
	sSolidOperation.setDescription(T("|Defines solid operation|") + "+ " + T("|Adds a boxed no nail area to the tool contour|") + " (" + T("|Saw|") +" " + T("|or|") + " " + T("|Milling|") + ")");	
	sSolidOperation.setCategory(sCatTool);
	//0
	String sDepthName = "(D)   " +T("|Depth|");
	PropDouble dDepth(0,U(0),sDepthName);
	dDepth.setDescription(T("|The Depth of the CNC Operation, 0 = byZone, negative value = byZone + additional absolute value|"));
	dDepth.setCategory(sCatTool);
	
	PropInt nToolingIndex(1,0,"(I)   " +T("|Tooling index|"));
	nToolingIndex.setCategory(sCatToolProps);
	//1
	PropDouble dAngle(1,0,"(J)   " +T("|Angle|"));
	dAngle.setDescription(T("|Sets the angle of the saw.|"));	
	dAngle.setCategory(sCatToolProps);

// offsets
	//3
	String sOffsetCategory= T("|Offsets|");
	nDoubleIndex++; // increment to keep sequence of prior versions
	String sOffsetX1Name= "(K)   " +"-" + T("|X-Axis|");
	PropDouble dOffsetX1(3,U(0),sOffsetX1Name);
	dOffsetX1.setDescription(T("|Defines an offset in the specified direction|"));
	dOffsetX1.setCategory(sOffsetCategory);	
	//4
	String sOffsetX2Name= "(L)   " +T("|X-Axis|");
	PropDouble dOffsetX2(4,U(0),sOffsetX2Name);
	dOffsetX2.setDescription(T("|Defines an offset in the specified direction|"));
	dOffsetX2.setCategory(sOffsetCategory);
	//5
	String sOffsetY1Name= "(M)   " +"-" + T("|Y-Axis|");
	PropDouble dOffsetY1(5,U(0),sOffsetY1Name);
	dOffsetY1.setDescription(T("|Defines an offset in the specified direction|"));
	dOffsetY1.setCategory(sOffsetCategory);
	//6
	String sOffsetY2Name= "(N)   " +T("|Y-Axis|");
	PropDouble dOffsetY2(6,U(0),sOffsetY2Name);
	dOffsetY2.setDescription(T("|Defines an offset in the specified direction|"));
	dOffsetY2.setCategory(sOffsetCategory);	


// text
	String sTxtName = "(O)   " +T("|Text|");
	PropString sTxt(nStringIndex++,"",sTxtName );
	String sTxtDesc = T("|Defines an optional text|") + " "+ T("|The following variables are supported|") + ": ";
	for (int i = 0; i<sVariables.length();i++)
	{
		sTxtDesc +="@(" + sVariables[i] + ")";
		if (i!=sVariables.length()-1)
			sTxtDesc +=", ";	
	}
	sTxt.setDescription(sTxtDesc);
	sTxt.setCategory(sCatDesc);
	//2
	String sTxtHName ="(P)   " + T("|Text Height|");
	nDoubleIndex=2;// reset increment to keep sequence of prior versions
	PropDouble dTxtH(2,U(0),sTxtHName);
	dTxtH.setDescription(T("|Defines the text height of an optional text|"));
	dTxtH.setCategory(sCatDesc);
	//7
	// HSB-22653: Clearing diameter
	String sDiameterClearingName="(D1)   " +T("|Clear tool diameter|");
	PropDouble dDiameterClearing(7, U(0), sDiameterClearingName);
	dDiameterClearing.setDescription(T("|Defines the milling diameter for clear tooling. This option is only relevant for the tool milling and when a closed contour is defined. The clearing will happen only for diameter >0.|"));
	dDiameterClearing.setCategory(sCatTool);
//End Properties//endregion 

//region bOnInsert
	if (_bOnInsert)
	{
		int bBlockDefMode;
		if (_kExecuteKey.find("BlockDefMode",0)>-1)bBlockDefMode=true;
		if (insertCycleCount()>1) { eraseInstance(); return; }	
	
		Vector3d vz=_ZU;
		int nToolColor = 3;
	//  model mode	
		if(!bBlockDefMode)
		{
		// analyse a potential execute key for a given tool type
		// the key should be given as <CatalogEntryName>?<ToolType>
			int nToken = _kExecuteKey.find("?",0);
			int bIsValidEntry; // a flag which indicates that the given catalog entry exists
			if (nToken>-1)
			{
			// get tokens
				String sEntry =  _kExecuteKey.left(nToken).trimLeft().trimRight();
				// translate if required
				if (sEntry.find("|",0)>-1)
					sEntry = T(sEntry);
				String sPresetTool = T(_kExecuteKey.right(_kExecuteKey.length()-nToken-1).trimLeft().trimRight());

			// set opmKey and optional preset tool	
				String sOpmName = scriptName() + "-" + sTool;
				if (sTools.find(sPresetTool,0)>-1)
				{	
					sOpmName = scriptName() + "-" + sPresetTool;		
					sTool.set(sPresetTool);
					setOPMKey(sPresetTool);
				}
				
			// query potential catalog entry names
				if (bDebug)reportMessage("\nOpmName: " + sOpmName + "\nEntries: " + TslInst().getListOfCatalogNames(scriptName() + "-" + sTool) + " vs " + T(sEntry));
				String sEntries[] = TslInst().getListOfCatalogNames(sOpmName);		
				// loop entries to ignore case sensitive writing instead of using if (sEntries.find(sEntry)>-1)
				for (int i=0;i<sEntries.length();i++)
				{
					String s1 = sEntries[i];
					String s2 = T(sEntry);
					if (s1.makeUpper()==s2.makeUpper())
					{
						bIsValidEntry=true;
						setPropValuesFromCatalog(sEntry);
						if (bDebug)reportMessage("\nproperties set of : " +sEntry + " map " + mapWithPropValues());						
					}
				}			
			}

			PrEntity ssE(T("|Select a sheet of the desired zone or an element|") , Sheet());
			ssE.addAllowedClass(ElementWall());
			ssE.addAllowedClass(ElementRoof());
			Entity ents[0];
			if (ssE.go())
				ents = ssE.set();
			
		// the main entities	
			Sheet sh;
			Element el;
		// take the first sheet or element in the array	
			for (int e=0;e<ents.length();e++)
			{
				if (ents[e].bIsKindOf(Sheet()))
				{
					sh = (Sheet)ents[e];	
					break;
				}
				else if (ents[e].bIsKindOf(Element()))
				{
					el = (Element)ents[e];	
					break;
				}
			}
		// preset dialog values by the selected sheet and its properties
			if (sh.bIsValid())
			{
				el = sh.element();
				if (!el.bIsValid())
				{
					reportMessage(TN("|Sheet must belong to an element.|") + " " + T("|Tool will be deleted.|"));
					eraseInstance();
					return;	
				}
				_Element.append(el);
				nZone.set(sh.myZoneIndex());
				ElemZone elzo = el.zone(nZone);
				
			// set depth if catalog entry is not used
				if (!bIsValidEntry)
				{
					dDepth.set(elzo.dH());
					setCatalogFromPropValues(sLastInserted);
					if (bDebug)reportMessage("\n	depth set to zone thickness " + dDepth);
				}
				vz = _Element[0].zone(nZone).vecZ();
			}

			//setCatalogFromPropValues(sLastEntry);
			
		// show dialog if catalog entry used
			if (nToken<0 || !bIsValidEntry)	
				showDialog(sLastInserted);		
			
		// if the element is valid but the sheet isn't, set the element	
			if (!sh.bIsValid() && el.bIsValid())
			{
				_Element.append(el);
				ElemZone elzo = el.zone(nZone);	
				vz = _Element[0].zone(nZone).vecZ();
			}			
			if (!sh.bIsValid() && !el.bIsValid())
			{	
				reportMessage(TN("|Sheet or element required.|") + " " + T("|Tool will be deleted.|"));
				eraseInstance();
				return;	
			}
			nToolColor = el.zone(nZone).color(); // use zone color as preview color		
		} 
	// block def mode	
		else
		{
			setOPMKey("Replicator");
			_Map.setInt("isBlockDef",bBlockDefMode);// 1 means block definition mode
			showDialog(T("|_LastInserted|"));	
			int nTool=sTools.find(sTool);
			nToolColor = nToolColors[nTool];
						
		}
		
	
		Point3d ptLast;
		EntPLine epl;	
		while (1) 
		{
			PrPoint ssP2;
			if (_PtG.length()<1)
				ssP2=PrPoint ("\n" + T("|Pick start point|") + " " + T("|<Enter> to select defining entity|")); 			
			else
				ssP2=PrPoint ("\n" + T("|Select next point|"),ptLast); 
			if (ssP2.go()==_kOk) 
			{
			// delete a poential jig	
				if (epl.bIsValid())epl.dbErase(); 
			// do the actual query
				ptLast = ssP2.value(); // retrieve the selected point
				_PtG.append(ptLast); // append the selected points to the list of grippoints _PtG
				
				PLine pl(vz);
				for (int i=0;i<_PtG.length();i++)
					pl.addVertex(_PtG[i]);
				epl.dbCreate(pl);
				epl.setColor(nToolColor);
			}
			// no proper selection
			else 
			{ 
			// delete a poential jig	
				if (epl.bIsValid())epl.dbErase();			
				break; // out of infinite while
			}
		}
		
	// if no points have been picked allow certain entities to define the contour
		if (_PtG.length()<2)
		{
			// HSB-10185# Changed argument for eraseInstance
			int bDelete;

			PrEntity ssE(T("|Select a defining Entity|") + " " + sPromptDefiningObjects , EntPLine());
			ssE.addAllowedClass(Opening());
			ssE.addAllowedClass(Beam());
			ssE.addAllowedClass(Sheet());
			ssE.addAllowedClass(Entity());
			ssE.addAllowedClass(TslInst());
				
			Entity ents[0];
			if (ssE.go())
				ents = ssE.set();
			if (ents.length()>0)
			{				
				if (ents[0].bIsKindOf(EntPLine()))
					_Pt0.setToAverage(((EntPLine)ents[0]).getPLine().vertexPoints(true));
				else if (ents[0].bIsKindOf(Opening()))	
					_Pt0.setToAverage(((Opening)ents[0]).plShape().vertexPoints(true));				
				else if (ents[0].bIsKindOf(Beam()) && _Element.length()>0)	
				{
					Beam bm = (Beam)ents[0];
				// HSB-16822
					if(abs(_Element[0].vecZ().dotProduct(bm.vecX()))>dEps)
					{
					// not parallel
						_Pt0=Line(bm.ptCen(), bm.vecX()).intersect(Plane(_Element[0].ptOrg(), _Element[0].vecZ()),0);
					}
					else 
					{ 
					// parallel
						_Pt0=Line(bm.ptCen(), bm.vecD(_Element[0].vecZ())).intersect(Plane(_Element[0].ptOrg(), _Element[0].vecZ()),0);
					}
					
				}
				else if (ents[0].bIsKindOf(Sheet()) && _Element.length()>0)	
				{
					Sheet sheet= (Sheet)ents[0];
					_Pt0=sheet.ptCenSolid();					
				}
				else if (ents[0].bIsKindOf(TslInst()) && _Element.length()>0)	// HSB-13320
				{
					TslInst t= (TslInst)ents[0];
					if (!t.map().hasPLine("plCNC"))
						bDelete = true;

				}		
				else // HSB-10185# Add selection of circle
				{
					if(ents[0].typeDxfName() == "CIRCLE")
					{
						_Pt0.setToAverage(((EntPLine)ents[0]).getPLine().vertexPoints(true));	
						PLine pl = ents[0].getPLine();
						if(pl.length() > dEps)
						{
							EntPLine epl();
							epl.dbCreate(pl);
							ents[0] = epl;							
						}
						else
							bDelete = true;
					}
					else
						bDelete = true;
				}
				_Entity.append(ents[0]);
			}
			
			if(ents.length() < 1 || bDelete)
			{
				reportMessage("\n" +  sPromptDefiningObjects  + " " + T("|not found.|") + " " + T("|Tool will be deleted.|"));
				eraseInstance();
				return;
			}
		}
		else
		{
			_Pt0.setToAverage(_PtG);

		// store absolute vecs in map	
			for (int i=0;i<_PtG.length();i++)
				_Map.setVector3d("vec"+i, _PtG[i]-_PtW);
		}
			
	// flag this cnc line not to be deleted on bOnElementDeleted	
		_Map.setInt("customInsert", true);	
		return;			
	}
// end on insert	__________________//endregion

// erase
	int bCustomInsert = _Map.getInt("customInsert");
	if (_bOnElementDeleted && !_Map.getInt("customInsert"))
	{
		if(bDebug)reportMessage("\n" + scriptName() + "bOnElementDeleted");
		eraseInstance();
		return;	
	}

	if (_PtG.length()<2 && _Entity.length()<1 && !_Map.hasPLine("pline"))
	{
		reportMessage("\n" +  T("|No valid dependency found.|") + " " + T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}

// validate defining entity if tool is dependent from a replication block
	if (_Map.hasEntity("DefiningEntity") && !_Map.getEntity("DefiningEntity").bIsValid())
	{
		reportMessage(TN("|The defining entity is invalid.|"));
		eraseInstance();
		return;	
	}	

		
//End Part #1//endregion 
	
// define flag wether the tool contour should be tested against the contour. applies for beam and opening dependencies and for closed plines
	int bApplyContourTest; 

// Display
	Display dpZone(2);
// project special
	String sProjectSpecial = projectSpecial();
	int bIsSpecialRubner = sProjectSpecial.makeUpper() == "RUB";

// get the defining entity if set
	EntPLine epl;
	Opening opening;
	TslInst tslBlockRef, tslModelRep, tslDefine ;
	Beam beam;
	Sheet sheetDef;
	Map mapReplicator;
	CoordSys csDefine(_Pt0, _XE,_YE,_ZE);
	for (int i=0;i<_Entity.length();i++)
	{
		Entity ent = _Entity[i];
		if (ent.bIsKindOf(EntPLine()))
		{
			setDependencyOnEntity(ent);
			epl = (EntPLine)ent;	
			//reportMessage("\nepl " + epl.bIsValid());
		}	
		else if (ent.bIsKindOf(Opening()))
		{
			setDependencyOnEntity(ent);
			opening= (Opening)ent;	
			//reportMessage("\nopening " + opening.bIsValid());
		}		
		else if (ent.bIsKindOf(Beam()))
		{
			setDependencyOnEntity(ent);
			beam= (Beam)ent;	
			//reportMessage("\nopening " + opening.bIsValid());
		}	
		else if (ent.bIsKindOf(Sheet()))
		{
			setDependencyOnEntity(ent);
			sheetDef= (Sheet)ent;	
			//reportMessage("\nopening " + opening.bIsValid());
		}
	// the defining entity is of type tsl	
		else if (ent.bIsKindOf(TslInst()))
		{
			TslInst tsl = (TslInst) ent;
			Map map = tsl.map();
			int bIsBlockDef = map.getInt("isBlockDef");
			String s =  scriptName();
			if (s=="__HSB__PREVIEW")s="hsbCNC";
		// the tsl is a block definition tsl and is of same name
			if (tsl.scriptName() == s && bIsBlockDef)
			{
				if(bDebug)reportMessage("\n" + tsl.handle() + " is  a block definition " + tsl.scriptName());
				setDependencyOnEntity(ent);
				tslBlockRef= tsl;
				
				if (map.hasMap("Replicator"))
				{
					mapReplicator  = map.getMap("Replicator");
					_Map.setPLine("pline",mapReplicator.getPLine("pline"));
				}
		// the tsl is not a block definition and has a defining polyline		
			}	
			else if (map.hasPLine("plCNC"))
			{
				PLine pl = map.getPLine("plCNC");
				if (map.hasPoint3d("ptOrg") && map.hasVector3d("vx") && map.hasVector3d("vy")&& map.hasVector3d("vz"))
					csDefine = CoordSys(map.getPoint3d("ptOrg"), map.getVector3d("vx"), map.getVector3d("vy"), map.getVector3d("vz"));
				
				if (!pl.coordSys().vecZ().isCodirectionalTo(csDefine.vecZ()))
					pl.flipNormal();
				//pl.vis(12);
				
				String ss = tsl.scriptName();
					
			
		// test against zone contour	// version 5.1
				Point3d pts[] = pl.vertexPoints(false);
				if(pts.length()>2 && (pts[0]-pts[pts.length()-1]).length()<dEps)
					bApplyContourTest=true;		
				
				_Map.setPLine("plCNC",pl);
				tslDefine = tsl;
				setDependencyOnEntity(tsl);
			}


			else if (!bIsBlockDef)
			{
				if(bDebug)reportMessage("\n" + tsl.handle() + " is model instance of " + tsl.scriptName());
				setDependencyOnEntity(ent);
				tslModelRep= tsl;
				csDefine = CoordSys(map.getPoint3d("ptOrg"), map.getVector3d("vx"), map.getVector3d("vy"), map.getVector3d("vz"));
			// store this entity in map to validate it when defining entity is erased
				_Map.setEntity("DefiningEntity", ent);					
			}
		}
	}

// mode
	// 0 = model cnc line
	// 1 = replicator defining cnc line
	int bIsBlockDef = _Map.getInt("isBlockDef");

// declare standards
	Vector3d vx,vy,vz;
	CoordSys cs;
	Point3d ptOrg;
		
// tool type an other ints
	// support previous versions were this property could be set to no/yes to define noNail area
	if (sNoYes.find(sSolidOperation)>-1)
	{
		int n=sNoYes.find(sSolidOperation);
		if(n>-1)sSolidOperation.set(n);
	}
	int nSolidOperation=sSolidOperations.find(sSolidOperation,0);	
	int nTool=sTools.find(sTool);
	int nSgn = nZone/abs(nZone);
	int nZoneRelation = sZoneRelations.find(sZoneRelation);
	//csDefine.vis(nSgn);	
	
// collect offsets
	double dOffsets[]={dOffsetX1,dOffsetY1,dOffsetX2,dOffsetY2};// left, bottom. right, top
	int bHasOffset;	
	for (int i=0;i<dOffsets.length();i++)
		if (abs(dOffsets[i])>dEps)
		{
			bHasOffset=true;
			break;	
		}

	
// angle only allowed for sawlines
	if (nTool!=0 && dAngle!=0)
	{
		dAngle.set(0);	
	}
	
// description overrides for certain tools
	String sMsgNotAvailable = T("|This option does not apply to the tool|") + " " + sTool;
	if (nTool==1)// milling
	{
		dAngle.setDescription(sMsgNotAvailable);	
		dAngle.setReadOnly(true);
	}	
	else if (nTool==2)// no nail
	{
		sSide.setDescription(sMsgNotAvailable);
		sTurningDirection.setDescription(sMsgNotAvailable);
		sShoot.setDescription(sMsgNotAvailable);		
		dDepth.setDescription(sMsgNotAvailable);	
		dAngle.setDescription(sMsgNotAvailable);	

		sSide.setReadOnly(true);
		sTurningDirection.setReadOnly(true);
		sShoot.setReadOnly(true);		
		dDepth.setReadOnly(true);	
		dAngle.setReadOnly(true);	
	}		
	else if (nTool==3)// marking line
	{
		sSide.setDescription(sMsgNotAvailable);
		sTurningDirection.setDescription(sMsgNotAvailable);
		sShoot.setDescription(sMsgNotAvailable);		
		dDepth.setDescription(sMsgNotAvailable);	
		dAngle.setDescription(sMsgNotAvailable);	

		sSide.setReadOnly(true);
		sTurningDirection.setReadOnly(true);
		sShoot.setReadOnly(true);		
		dDepth.setReadOnly(true);	
		dAngle.setReadOnly(true);	
	}		
	

// Grip Point Mode
	if (_PtG.length()>1)
	{	
	// disable offsets
		dOffsetX1.setReadOnly(true);
		dOffsetX2.setReadOnly(true);
		dOffsetY1.setReadOnly(true);
		dOffsetY2.setReadOnly(true);
		// HSB-22653
		dDiameterClearing.setReadOnly(false);
		if (dOffsetX1!=0)dOffsetX1.set(0);
		if (dOffsetX2!=0)dOffsetX2.set(0);
		if (dOffsetY1!=0)dOffsetY1.set(0);
		if (dOffsetY2!=0)dOffsetY2.set(0);
					
	// add dimpoint trigger
		String sTriggerAdd= T("../|Add points|");
		addRecalcTrigger(_kContext, sTriggerAdd);
		if (_bOnRecalc && _kExecuteKey==sTriggerAdd) 
		{
			int nStartGrip = _PtG.length();
			while (1) 
			{
				PrPoint ssP("\n" + T("|Pick new point|")); 
				if (ssP.go()==_kOk) // do the actual query
					_PtG.append(ssP.value()); // retrieve the selected point	
				else // no proper selection
					break; // out of infinite while
			}
		// store all grips in map
			for (int i = nStartGrip; i < _PtG.length(); i++)
				_Map.setVector3d("vec" + i, _PtG[i] - _PtW);	
		}
	
	
	// remove dimpoint trigger
		String sTriggerRemove= T("../|Delete points|");
		addRecalcTrigger(_kContext, sTriggerRemove);
		if (_bOnRecalc && _kExecuteKey==sTriggerRemove) 
		{
			Point3d ptDelete[0];
			while (1) {
				PrPoint ssP("\n" + T("|Select point to be deleted|"));  	
				if (ssP.go()==_kOk) // do the actual query
				{
					Point3d ptRef = ssP.value();
					int n;
					double dDist = U(100000);
					for (int i = 0; i < _PtG.length(); i++)
					{
						ptRef.transformBy(vz*vz.dotProduct(_PtG[i]-ptRef));
						double d = (_PtG[i]-ptRef ).length();
						if (d< dDist )
						{
							n=i;
							dDist = d;
						}
					}	
					if (dDist < U(1000))
					{
						_Map.removeAt("vec"+n, TRUE);
						_PtG.removeAt(n);
					}
				}
				else
					break;
			}
		}
		
		_ThisInst.setAllowGripAtPt0(false);
	}

	
	
// repos grips when _Pt0 is moved
	if (_kNameLastChangedProp=="_Pt0")
	{
		for (int i=0;i<_PtG.length();i++)
			if (_Map.hasVector3d("vec"+i))
				_PtG[i] = _PtW+_Map.getVector3d("vec"+i);		
	}	
	if(_kNameLastChangedProp==sDiameterClearingName)
	{ 
		// HSB-22653 for existing tsls
		_Map.setDouble("ToolDiameter", dDiameterClearing);
	}


// trigger flip side for saw and milling
	if (nTool<2 && !beam.bIsValid())
	{
		String sFlipSideTrigger = T("../|Flip Side|");
		addRecalcTrigger(_kContext, sFlipSideTrigger );
		if (_bOnRecalc && (_kExecuteKey==sFlipSideTrigger || _kExecuteKey==sDoubleClick) ) 
		{
			int n = sSides.find(sSide);
			if (n==0)
				n = 1;
			else
				n = 0;
			sSide.set(sSides[n]);
			nSide = nSides[sSides.find(sSide,0)];
			setExecutionLoops(2);
		}
	}
	
// Trigger SwapDirection//region
	String sTriggerSwapDirection = T("../|Swap Direction|");
	int bSwapDirection = _Map.getInt("SwapDirection");
	addRecalcTrigger(_kContext, sTriggerSwapDirection );
	if (_bOnRecalc &&_kExecuteKey==sTriggerSwapDirection)
	{
		bSwapDirection = bSwapDirection ? false : true;
		_Map.setInt("SwapDirection",bSwapDirection);
		setExecutionLoops(2);
		return;
	}//endregion	


// map based trigger settings
	int bSnap=_Map.getInt("snapToEdge");


// add autoSnap trigger if not noNail and grip mode is active
	if (nTool!=2 && _PtG.length()>0)
	{
		String sTriggerSnap= T("../|Snap to edge|");
		if (bSnap) sTriggerSnap= T("|Do not snap to edge|");
		addRecalcTrigger(_kContext, sTriggerSnap);
		if (_bOnRecalc && _kExecuteKey==sTriggerSnap) 
		{
			if (bSnap)bSnap=false;
			else bSnap=true;
			_Map.setInt("snapToEdge", bSnap);
			setExecutionLoops(2);
		}
	}
	else
	{
		bSnap=false;
		_Map.setInt("snapToEdge", bSnap);
	}
	
// model mode
	if (bIsBlockDef<1)
	{	
		if (_Element.length()<1) 
		{
			reportMessage("\n" +scriptName() + " has no valid element");		
			eraseInstance();				
			return;
		}
		setOPMKey(sTool);
		Element el = _Element[0];

		cs = el.coordSys();
		ptOrg = cs.ptOrg();
		vx=cs.vecX();
		vy=cs.vecY();
		vz=cs.vecZ();
		vx.vis(ptOrg,1);
		vy.vis(ptOrg,3);
		vz.vis(ptOrg,150);
	
	// declare a variable for the zone in respect of the option that the zone could be relational to the location of the parent object
		int nThisZone = nZone;
	// find outmost zone
		if (abs(nThisZone)==99)
		{
			int nSgnThis = nThisZone /abs(nThisZone);
			int x = 5;
			for (int i=x;i>0;i--)
			{
				nThisZone = i*nSgnThis;
				ElemZone elzo = el.zone(nThisZone);	
				if (elzo.dH()>dEps)break;	
			}			
		}		
		ElemZone elzo = el.zone(nThisZone);
	// check zone relations	
		if(nZoneRelation==1 && !vz.isCodirectionalTo(csDefine.vecZ()))
		{
			nThisZone *=-1;
		// validate this zone	
			int nSgnThis = nThisZone /abs(nThisZone);
			int x = abs(nThisZone);
			for (int i=x;i>0;i--)
			{
				nThisZone = i*nSgnThis;
				elzo = el.zone(nThisZone);	
				if (elzo.dH()>dEps)break;	
			}	
		}
	// exclusive zone relation: the tool is only allowed on the specified zone. if this does not match the current alignment the tool will be deleted	
		else if(nZoneRelation==2)
		{
			int nSgnZone = nZone /abs(nZone);
			int nSgnThis =1;
			if (!vz.isCodirectionalTo(csDefine.vecZ()))nSgnThis *=-1;
			if (nSgnThis!=nSgnZone)
			{
				reportMessage("\n" + T("|CNC Tool will be removed due to exclusive zone relation.|"));
				eraseInstance();
				return;	
			}
		} 		

	// project all grips to zone
		for (int i=0;i<_PtG.length();i++)
			_PtG[i].transformBy(vz*vz.dotProduct(elzo.ptOrg()-_PtG[i]));

		if (_bOnDbCreated)
		{
			if (_PtG.length()>0)	_Pt0.setToAverage(_PtG);
			else if(!bCustomInsert) _Pt0 = elzo.ptOrg();// 5.4
		}
		else
		{
			_Pt0.transformBy(vz*vz.dotProduct(elzo.ptOrg()-_Pt0));

		// if _Pt0 is moved transform parent tsl if available
			if (_kNameLastChangedProp=="_Pt0" && tslDefine.bIsValid())
			{
				Point3d ptEntRef = tslDefine.ptOrg();	
				
			// calculate transformation in vecY of the element
				Vector3d vecTrans = vx*vx.dotProduct(_Pt0-ptEntRef) + vy*vy.dotProduct(_Pt0-ptEntRef);
				tslDefine.transformBy(vecTrans);
				tslDefine.recalcNow();
				setExecutionLoops(2);
				return;			
			}			
		}
		
		
	// assigning
		assignToElementGroup(el,TRUE, nThisZone,'E');	

	// the depth of the cnc operation
		double dZoneThickness = elzo.dH();
		double dThisDepth = dDepth;
		if (dDepth==0)
			dThisDepth = dZoneThickness ;
		else if (dDepth<0)
			dThisDepth = dZoneThickness +abs(dDepth);
			
	// the zone plane and tool
		Plane pnZone(elzo.ptOrg()+elzo.vecZ()*dZoneThickness,elzo.vecZ());
		PLine plTool(elzo.vecZ()), plDefine(elzo.vecZ());
		Point3d ptGrips[0]; 
		int bIsCircle;
		
	// collector of all sheet envelopes
		PLine plSheetEnvelopes[0];
		
	// get genbeams and profile of zone
		GenBeam gb[] = el.genBeam(nThisZone);
		double dMerge = U(5);
		if (elzo.hasVar("gap"))dMerge =elzo.dVar("gap")+dEps;

		PlaneProfile ppZone(CoordSys(pnZone.ptOrg(),vy.crossProduct(elzo.vecZ()), vy, elzo.vecZ()));
		Sheet sheets[0];
		for (int i=0;i<gb.length();i++)
		{
			PlaneProfile pp;
			if (gb[i].bIsKindOf(Sheet()) && gb[i].vecZ().isParallelTo(elzo.vecZ()))
			{
				Sheet sheet = (Sheet)gb[i];
				if (sheet == sheetDef)continue;// skip defining sheet
				sheets.append(sheet);
				//if (bDebug)sheet.envelopeBody().vis(i);
				plSheetEnvelopes.append(sheet.plEnvelope());
				pp = sheet.profShape();
			}
			else
				pp = gb[i].realBody().shadowProfile(pnZone);
			pp.shrink(-dMerge);
			if (ppZone.area()<pow(dEps,2))
				ppZone=pp;
			else
				ppZone.unionWith(pp);
		}	
		ppZone.shrink(dMerge);
		

	// get plines of zone
		PLine plRings[] = ppZone.allRings();
		int bIsOp[] = ppZone.ringIsOpening();	

	// smoothen the zones profile
	// especially gable walls could have sloped segments with a slight deviation, but being basically on one line
		{
			plRings = ppZone.allRings();
			bIsOp=ppZone.ringIsOpening();
			//ppZone.removeAllRings();
			ppZone=PlaneProfile (CoordSys(pnZone.ptOrg(),vy.crossProduct(elzo.vecZ()), vy, elzo.vecZ()));
		
		// sort opening and contour plines
			for (int r=0;r<plRings.length();r++)
				for (int q=0;q<plRings.length()-1;q++)
					if (bIsOp[q]>bIsOp[q+1])// version 5.5
					{
						plRings.swap(q,q+1);
						bIsOp.swap(q,q+1);
					}	
		
		// rebuild the zone profile		
			for (int r=0;r<plRings.length();r++)
			{
				PLine plNew(elzo.vecZ());
			// get vertices of each ring			
				PLine pl=plRings[r];
				pl.convertToLineApprox(dEps);
				Point3d pts[] = pl.vertexPoints(false);
			
			// smoothing
				Point3d pts2[0];
				for (int p=0;p<pts.length();p++)
				{
					if (p==0)
						pts2.append(pts[p]);
					else
					{
						Point3d ptA = pts2[pts2.length()-1];
						int b=p+1;
						if (b>=pts.length())	b=b-pts.length();
						PLine plSeg(ptA, pts[b]);
						Point3d ptNext = plSeg.closestPointTo(pts[p]);
						double dDeviation = (pts[p]-ptNext).length();
						if (dDeviation>dEps)	pts2.append(pts[p]);	
					}
				}
				for (int p=0;p<pts2.length();p++)	plNew.addVertex(pts2[p]);
				plNew.close();
				//plNew.projectPointsToPlane(pnZone,elzo.vecZ());
				if (!bIsOp[r])
					ppZone.joinRing(plNew, _kAdd);
				else
				{
					//plNew.vis(6);
					ppZone.joinRing(plNew, _kSubtract);	
				}
			}
			//ppZone.vis(6);					
		}
		//if(1){ppZone.transformBy(vz*U(100));ppZone.vis(72);ppZone.transformBy(-vz*U(100));}
		
	// in case the depth exceeds zone thickness collect genbeams of intersecting below zones
		GenBeam gbsUnder[0];
		if (dThisDepth>dZoneThickness+dEps)
		{
			double dCumulatedZoneThickness= dZoneThickness;
			for (int i=abs(nThisZone)-1;i>0;i--)
			{
				int z = i*nSgn;
				double dH2=el.zone(i).dH();
				gbsUnder.append(el.genBeam(z));
				dCumulatedZoneThickness+=dH2;
				if (dCumulatedZoneThickness>=dThisDepth) 
					break;
			}
		}

		

	// report dpendencies
		if (bDebug)reportMessage(TN("|Dependency list: \n") + 
			"	Grips: " + _PtG.length() + "\n" +
			"	epl: " + epl.bIsValid() + "\n" +
			"	opening: " + opening.bIsValid() + "\n" +
			"	beam: " + beam.bIsValid() + "\n" +
			"	mapRep/tslModelRep: " + mapReplicator.length() + " / " +tslModelRep.bIsValid() + "\n" +
			"	plCNC: " + _Map.hasPLine("plCNC") + "\nEND");

	// grip point definition
		if (_PtG.length()>1)
		{		
			ptGrips=_PtG;
			
		// test against zone contour			
			if(ptGrips.length()>2 && (ptGrips[0]-ptGrips[ptGrips.length()-1]).length()<dEps)
			{
				bApplyContourTest=true;
			}
			
		}
	// collect tool pline from entity or map
		else if (epl.bIsValid())
		{
			plTool = epl.getPLine();
			//drawPLine(plTool, U(50), bIsCircle,80); // #func
		// circle test HSB-17081 circle tests improved
			Vector3d vecZT = plTool.coordSys().vecZ();	
			if (vecZT.isParallelTo(vz))
			{
				PlaneProfile ppc(plTool);
				PLine c;
				c.createCircle(ppc.ptMid(), vecZT, ppc.dX()*.5);
				
				double d1 = c.area()/dEps;
				double d2 = plTool.area()/dEps;
				double d3 = abs(d1 - d2);
				if (d3<pow(U(1),2))
					bIsCircle = true;
				//drawPLine(c, U(50), 3,80); // #func	
			}
			else
			{ 
				plTool.convertToLineApprox(U(5));
				plTool.projectPointsToPlane(pnZone, vecZT);
			}
			
			if (bIsCircle)
			{
					;// do nothing
			}	
		// test against zone contour	
			else if (plTool.isClosed())
				bApplyContourTest=true;			
		}	
	// collect tool pline from entity or map
		else if (_Map.hasPLine("plCNC"))
		{
			plTool = _Map.getPLine("plCNC");
		// ensure base point is always within tool contour for noNails	
			if (nTool==2 && _PtG.length()<1)
			{
				_Pt0.setToAverage(plTool.vertexPoints(true));
				_Pt0.transformBy(vz*vz.dotProduct(elzo.ptOrg()-_Pt0));
			}
			
		// arc test Version 6.5
			Point3d pts[] =plTool.vertexPoints(false);
			PLine plCirc(plTool.coordSys().vecZ());
			if (pts.length()==3)
			{
				
				plCirc.addVertex(pts[0]);
				plCirc.addVertex(pts[1], plTool.getPointAtDist(plTool.getDistAtPoint(pts[0])+dEps));
				plCirc.addVertex(pts[2], plTool.getPointAtDist(plTool.getDistAtPoint(pts[1])+dEps));
				if ((plCirc.ptStart()-plCirc.ptEnd()).length()<dEps)
					plCirc.close();
			}			
			if (abs(plTool.area()-plCirc.area())<pow(U(1),2))
			{
					;// do nothing
			}	
			
		// test against zone contour	
			else if ((plTool.ptStart()-plTool.ptEnd()).length()<dEps)
				bApplyContourTest=true;			
		}		
			
		else if (opening.bIsValid())
		{
			bApplyContourTest=true;// test against zone contour
			plTool = opening.plShape(); plTool.vis(2);
			plTool.convertToLineApprox(dEps);
			Point3d pts[] =plTool.vertexPoints(true);
			if (_bOnDbCreated)_Pt0.setToAverage(pts);
			
		// on insert auto correct selected tool side
			if (_bOnDbCreated && pts.length()>1)
			{
				Vector3d vxSeg	= pts[1]-pts[0];
				vxSeg.normalize();
				Vector3d vySeg = vxSeg.crossProduct(-plTool.coordSys().vecZ());
				Point3d ptMid =  (pts[1]+pts[0])/2;
				if (PlaneProfile(plTool).pointInProfile(ptMid+vySeg*dEps)==_kPointOutsideProfile)
				{
					nSide=1;
					sSide.set(sSides[nSide]);
				}	
				else
				{
					nSide=0;
					sSide.set(sSides[nSide]);
				}	
				
			}	
		}
	// beam 
		else if (beam.bIsValid())	
		{
			
		// refuse any beam which is parallel to current zone
			Vector3d vecXBm = beam.vecX();
			if (vecXBm.isPerpendicularTo(vz))
			{
				reportMessage("\n" + T("|Beams which are perpendicular aligned to the Z-axis are not supported.|") + " " + T("|Tool will be deleted.|"));
				eraseInstance();
				return;
			}
			Body bdBeam;
			
		// Trigger ChangeBodyMode
			int nBodyMode = _Map.getInt("BodyMode");//default = envelopeBody with cuts
			if (nBodyMode < 0 || nBodyMode > 3)nBodyMode = 0;
			
			String sTriggerChangeBodyMode = T("|Change Body Mode|");
			addRecalcTrigger(_kContext, sTriggerChangeBodyMode );
			if (_bOnRecalc && (_kExecuteKey==sTriggerChangeBodyMode || _kExecuteKey==sDoubleClick))
			{
				int nRet = getInt(TN("|0 = envelopeBody with cuts|")+
				TN("|1 = extrusion profile envelope body with cuts|")+
				TN("|2 = envelope body|")+
				TN("|3 = real body|")+
				 + TN("|Enter body index| (")+nBodyMode+")");
				if (nRet >= 0 && nRet <=3)
					_Map.setInt("BodyMode", nRet);
				setExecutionLoops(2);
				return;
			}	

			
			
			// 0 = envelopeBody with cuts
			// 1 = envelopeBody + extrProf with cuts 
			// 2 = envelopeBody
			// 3 = realbody
			if (nBodyMode==2)
				bdBeam= beam.envelopeBody();
			else if (nBodyMode==1)
				bdBeam= beam.envelopeBody(true, true);		
			else if (nBodyMode==3)
				bdBeam= beam.realBody();
			else
				bdBeam= beam.envelopeBody(false, true);	
		// validate if the beam is intersecting the 	
			Body bdZone;
			for (int r=0;r<plRings.length();r++)
				if (!bIsOp[r])
					bdZone.addPart(Body(plRings[r],elzo.vecZ()*dThisDepth, -1));
			for (int r=0;r<plRings.length();r++)
				if (bIsOp[r])
					bdZone.subPart(Body(plRings[r],elzo.vecZ()*dThisDepth, -1));	
			//ppZone.vis(3);bdZone.vis(2);
			if (!bdZone.hasIntersection(bdBeam))
			{
				reportMessage("\n" + T("|Beam is not intersecting zone.|") + " " + T("|Tool will be deleted.|"));
				eraseInstance();
				return;				
			}	
			bApplyContourTest=true;// test against zone contour
		// get intersecting contour
			PlaneProfile ppIntersect = bdBeam.getSlice(pnZone);		
			ppIntersect.intersectWith(ppZone);	
			_Pt0=ppIntersect.extentInDir(vx).ptMid();						
			//ppIntersect.vis(1);
			plTool.createConvexHull(pnZone,ppIntersect.getGripVertexPoints());
			//plTool.vis(36);
		}
		else if (sheetDef.bIsValid())
		{
			bApplyContourTest=true;// test against zone contour
			plTool = sheetDef.plEnvelope();
			if (_bOnDbCreated)_Pt0=sheetDef.ptCenSolid();
		}
	// pline map definition	
		else if (mapReplicator.length()>0 && tslModelRep.bIsValid())
		{			
			plTool = mapReplicator.getPLine("pline");	
			CoordSys cs2ms;
			Map mapModelRep = tslModelRep.map();
			cs2ms.setToAlignCoordSys(_PtW,_XW,_YW,_ZW,mapModelRep.getPoint3d("ptOrg"), mapModelRep.getVector3d("vx"),mapModelRep.getVector3d("vy"),mapModelRep.getVector3d("vz"));	
			plTool.transformBy(cs2ms);
			plTool.projectPointsToPlane(Plane(elzo.ptOrg()+elzo.vecZ()*elzo.dH(), elzo.vecZ()),elzo.vecZ());
			//plTool.transformBy(vz*U(10));
			plTool.vis(6);
		
		// test against zone contour	
			if ((plTool.ptStart()-plTool.ptEnd()).length()<dEps)
				bApplyContourTest=true;
			
		}
	// if no valid defining entity could be found and the tsl has been executed twice alert user and eraseINstance
		else if(_Map.getInt("invalidCounter")>1)
		{
			if(bDebug)reportMessage("\n" + scriptName() + ": " +(_Element.length()>0?T("|Element|")+" "+ _Element[0].number():"") + T(" |no valid definition object or path found.|") + " "+T("|Tool will be deleted.|"));
			eraseInstance();
			return;	
		}	
				
	// potentially an invalid definition, execute twice to make sure that no tslModelRef could be found
		else
		{
			_Map.setInt("invalidCounter",_Map.getInt("invalidCounter")+1);
			setExecutionLoops(3);
			return;	
		}			


		
	// if not in grip mode offset tooling contour
		if (ptGrips.length()<1 && bHasOffset && plTool.area()>pow(dEps,2) && (plTool.ptStart()-plTool.ptEnd()).length()<dEps)
		{
		// get mid vertices
			PlaneProfile pp(plTool);
			Point3d pts[] = pp.getGripEdgeMidPoints();
		
		// loop grips and take the offset of the most aligned direction
			Vector3d vecs[] = {-vx, -vy,vx,vy};
			for (int i=0;i<pts.length();i++)
			{
			// get segment vecX
				Point3d pt = pts[i];
				Point3d ptNext = plTool.getPointAtDist(plTool.getDistAtPoint(pt)+dEps);
				Vector3d vecXSeg =ptNext -pt;
				vecXSeg.normalize();
				Vector3d vecYSeg = vecXSeg.crossProduct(elzo.vecZ());
				vecYSeg.normalize();
				if (pp.pointInProfile(pt+vecYSeg*dEps)==_kPointInProfile)
					vecYSeg*=-1;
				//vecYSeg.vis(pt,3);	
				
				double dThisOffset;
				for (int v=0;v<vecs.length();v++)
				{
					double d=vecs[v].dotProduct(vecYSeg);
					if (d>0.707)
					{
						dThisOffset=dOffsets[v];
						break;
					}
				}
			
			// stretch
				if (abs(dThisOffset)>dEps)
					pp.moveGripEdgeMidPointAt(i, vecYSeg*dThisOffset);	
			}
			
			if(pp.area()>pow(dEps,2))
			{
				//pp.vis(8);
				plTool.createConvexHull(pnZone, pp.getGripVertexPoints());	
			}
			//plTool.vis(20);	
		}// end tool offset modifier	

	// relocate grips and rebuild a pline from vertices
		for (int i=0;i<ptGrips.length();i++)
			ptGrips[i].transformBy(vz*vz.dotProduct(elzo.ptOrg()+elzo.vecZ()*elzo.dH()-ptGrips[i]));
		
		for (int i=0;i<ptGrips.length();i++)
		{
			ptGrips[i].vis(i);
			
			if (_PtG.length()==ptGrips.length())_Map.setVector3d("vec"+i, _PtG[i]-_PtW);
		
		// add every grip but not the first and last	
			if ((i!=0 && i!=ptGrips.length()-1) || !bSnap)
			{
				plTool.addVertex(ptGrips[i]);	
			}
		// snap to closest point of the contour lines		
			else
			{
				Vector3d vxSeg;
				if (i==0)vxSeg = ptGrips[i+1]-ptGrips[i];
				else vxSeg = ptGrips[i]-ptGrips[i-1];
				vxSeg.normalize();
				vxSeg.vis(ptGrips[i],i);
				
				Point3d ptNext = ptGrips[i];
				double dDist=U(20000);
				for (int r=0;r<plRings.length();r++)
				{
					PLine pl;
					pl.createConvexHull(Plane(plRings[r].ptStart(),vz),plRings[r].vertexPoints(true));//pl.vis(1);
					Point3d ptInt[] = pl.intersectPoints(Line(ptNext,vxSeg));
					for (int p=0;p<ptInt.length();p++)
					{
						double d=(ptInt[p]-ptGrips[i]).length();
						if (d<dDist)
						{
							ptNext = ptInt[p];
							ptNext.transformBy(vz*vz.dotProduct(ptGrips[i]-ptNext));
							dDist = d;
						}	
					}
				}
				ptNext.vis(2);
				plTool.addVertex(ptNext);	
			}			
		}	
		if(0)
		{
			plTool.transformBy(vz*U(300));
			plTool.vis(211);
			plTool.transformBy(vz*-U(300));
		}
	

	
	
	// get the defining contour and flag if it is closed
		plDefine = plTool;
		plDefine.vis(2);
		int bIsClosed = plDefine.isClosed();
				
	// add a solid subtract or beamcut if pline embraces a valid area
		if ((nSolidOperation==2 || nSolidOperation==3)&& plTool.area()>pow(dEps,2) &&  nTool<2)
		{
			GenBeam gbsSolidOperation[0];
			gbsSolidOperation.append(gb);
			gbsSolidOperation.append(gbsUnder);	
			PLine plSolid = plTool;
			plSolid.close();
			plSolid.vis(222);
			PlaneProfile ppTool(plSolid);
			LineSeg segTool=ppTool.extentInDir(vx);
			Vector3d vecZT = plTool.coordSys().vecZ();
			{
				PLine c;
				c.createCircle(ppTool.ptMid(), vecZT, ppTool.dX()*.5);
				if (abs(c.area()-plTool.area())<pow(U(1),2))
					bIsCircle = true;
			}

		// test if the shape can be defined by a rectangle
			int bIsRectangle;
			// an L-shape pline
			if (ptGrips.length()==3)
			{
				Vector3d vxSeg1 = ptGrips[1]-ptGrips[0];
				Vector3d vxSeg2 = ptGrips[2]-ptGrips[1];
				bIsRectangle=vxSeg1.isPerpendicularTo(vxSeg2);		
			}
			else if (!bIsCircle)
			{
				PLine plRec;
				plRec.createRectangle(segTool,vx,vy);
				double d1 = plRec.area();
				double d2 = plSolid.area();
				bIsRectangle = abs(d1-d2)<pow(dEps,2);
			}

		
		// define beamcut or solidsubtract dimensions
			double dX = abs(vx.dotProduct(segTool.ptStart()-segTool.ptEnd()));
			double dY = abs(vy.dotProduct(segTool.ptStart()-segTool.ptEnd()));
			double dZ = dThisDepth;
			if (abs(dZ-elzo.dH())<dEps)
				dZ+=dEps;
			if (dZ<dEps) dZ = elzo.dH()+dEps;			
			
		// test inside/outside
			Point3d ptTest;
			if (ptGrips.length()>0 && nSide!=2)
			{
				ptTest = (ptGrips[1]+ptGrips[0])/2;	
				Vector3d vxSeg = ptGrips[1]-ptGrips[0];
				vxSeg.normalize();
				vxSeg.vis(ptTest,1);
				Vector3d vySeg = vxSeg.crossProduct(-elzo.vecZ());
				vySeg.vis(ptTest,3);
				ptTest.transformBy(-vySeg*dEps*nSide);//*-nSgn*-nSide
			}
			else // version 6.3: test point set to average of solid contour if no ptGrips defined
				ptTest.setToAverage(plSolid.vertexPoints(true));
		
			if (bIsRectangle && dX>dEps && dY>dEps && dZ>dEps)
			{
				Point3d ptBc = segTool.ptMid();
				Line(ptBc, vz).hasIntersection(pnZone, ptBc); // HSB-17910
			// enlarge beamcut slightly in free directions, version 3.3
				Vector3d vecs[] = {vx,vy,-vx, -vy};
				Quader qdr(ptBc,vx,vy,vz,dX,dY,dZ*2,0,0,0);
				for (int f=0;f<vecs.length(); f++)
				{
					Vector3d vec=vecs[f];
					Point3d ptTest = ptBc+vec*(.5*qdr.dD(vec)+dEps);
					if (ppZone.pointInProfile(ptTest)==_kPointOutsideProfile)
					{
						ptTest.vis(3);
						if (f==0 || f==2)
							dX+=dEps;
						else
							dY+=dEps;
						ptBc.transformBy(vec*.5*dEps);
						qdr=Quader(ptBc,vx,vy,vz,dX,dY,dZ*2,0,0,0);
					}
				}
				
				BeamCut bc(ptBc,vx,vy,vz,dX,dY,dZ*2,0,0,0);
				bc.cuttingBody().vis(2);
				bc.addMeToGenBeamsIntersect(gbsSolidOperation);
				
			}
			// version 6.2: bugfix solid subtract contour 
			else if (PlaneProfile(plSolid).pointInProfile(ptTest)==_kPointInProfile && dZ>dEps && plSolid.area()>pow(dEps,2))
			{
				plSolid.projectPointsToPlane(pnZone, vz);//HSB-17081
				//drawPLine(plSolid, 0, 4, 80);//#func
				Body bd (plSolid, elzo.vecZ()*dZ*2,0);
				
			// enlarge the body if the grip based hull is bigger than the tool
				if (_PtG.length()>2)
				{
					PLine plHull;
					plHull.createConvexHull(Plane(segTool.ptMid(),elzo.vecZ() ), _PtG);
					plHull.vis(6);
					if (plHull.area()>plSolid.area())
						bd.addPart(Body(plHull, elzo.vecZ()*dZ*2,0));
				}
				bd.vis(2);
				SolidSubtract sosu(bd, _kSubtract);
				for (int i=0;i<gbsSolidOperation.length();i++)
					gbsSolidOperation[i].addTool(sosu);		
			}
		}
		
	// remove parts of the tool path which are outside of the zone contour	
		PLine plTools[0];	
		if(bApplyContourTest)
		{

			PlaneProfile ppTool(CoordSys(pnZone.ptOrg(), vx, vy, vz));
			ppTool.joinRing(plTool,_kAdd);
			PlaneProfile ppNet = ppZone;
			ppNet.joinRing(plTool,_kSubtract);

		//region find neighbour sheets // HSB-7745
			PlaneProfile ppSub(ppTool.coordSys()); // HSB-16660 suggested bRepairSelfIntersecting does not solve the issue. subtracting a separate profile which respects self intersections by a grow factor solves the issue
			for (int i=0;i<plSheetEnvelopes.length();i++) 
			{ 
				PlaneProfile pp(plSheetEnvelopes[i]);
				//pp.shrink(dEps);
				pp.intersectWith(ppTool);

				plSheetEnvelopes[i].vis(6);
				if (pp.area()<pow(dEps,2))
				{ 
					PlaneProfile ppx(ppTool.coordSys());
					ppx.joinRing(plSheetEnvelopes[i], _kAdd);
					ppx.shrink(-dEps);
					ppSub.unionWith(ppx);
//					int bOk = ppNet.joinRing(plSheetEnvelopes[i],_kSubtract); // prior HSB-16660 

				} 
			}//next i
			
			if (ppSub.area()>pow(dEps,2)) // HSB-16660 
			{ 
				ppSub.shrink(-dEps);
				ppSub.shrink(dEps);		ppSub.vis(2);	
				ppNet.subtractProfile(ppSub);
			}
			
			if (bDebug && 0)// HSB-16660 debug
			{ 
				PlaneProfile pp = ppNet;
				pp.transformBy(-vz * U(200));
				pp.vis(41);
			}
	
		//End find neighbour sheets//endregion 

			plRings = ppNet.allRings();
			bIsOp=ppNet.ringIsOpening();
			ppNet.transformBy(vz*U(200));	ppNet.vis(1);
			for (int r=0;r<plRings.length();r++)
			{
				PLine plNewTool(elzo.vecZ());
			// get vertices of each ring			
				PLine pl=plRings[r];
				
				//drawPLine(pl, U(200)*(r+1), r, 50); //#func
				//pl.vis(r);
				//pl.convertToLineApprox(dEps);
				Point3d pts[] = pl.vertexPoints(true);
			
			//	get starting vertex
				int x;
				for (int p=0;p<pts.length();p++)
				{
					//pts[p].vis(p);
					if ((pts[p]-ppTool.closestPointTo(pts[p])).length()>dEps)
					{
						x=p;
						break;	
					}
				}
			
			// collect vertices being on the tool contour
				for (int p=0;p<pts.length();p++)	
				{
					int a=p+x;
					if (a>=pts.length())a=a-pts.length();	
					int b=a+1;
					if (b>=pts.length())b=b-pts.length();			
					
				// add segment by segment
					Point3d ptA2 = ppTool.closestPointTo(pts[a]);
					Point3d ptB2 = ppTool.closestPointTo(pts[b]);
					
				// skip segment if midpoint is not in zone	
					Point3d ptC2 = (ptA2 +ptB2 )/2;;
					if (ppZone.pointInProfile(ptC2)==_kPointOutsideProfile)continue;					
					//LineSeg seg (ptA2 ,ptB2 ); seg.transformBy(vz*(r+1)*U(100));seg.vis(p);
					
					double d1 =(ptA2-pts[a]).length();
					double d2 =(ptB2-pts[b]).length();
					if (d1<dEps && d2<dEps)
					{
					// first vertex
						if (plNewTool.length()<dEps)
							plNewTool.addVertex(pts[a]);
					// if first vertex is not matching last of new tool, append previous and start a new one
						else if (Vector3d(plNewTool.ptEnd()-pts[a]).length()>dEps) // Version 5.5
						{
							plTools.append(plNewTool);
							plNewTool=PLine((elzo.vecZ()));
							plNewTool.addVertex(pts[a]);
						}							
							
					// second vertex (straight or arc) HSB-17910
						Point3d ptm = (pts[b] + pts[a]) * .5; ptm.vis(3);
						Point3d ptmx = pl.closestPointTo(ptm);						
						if (Vector3d(ptm-ptmx).length()>dEps)
						{
							ptmx = pl.getPointAtDist(pl.getDistAtPoint(pts[a]) + dEps);
							plNewTool.addVertex(pts[b], ptmx);
						}
						else
							plNewTool.addVertex(pts[b]);
						//LineSeg seg (ptA2 ,ptB2 ); seg.transformBy(vz*(r+1)*U(120));seg.vis(p);
					}	
				}
	
				if (plNewTool.length()>dEps)				
				{
					plTools.append(plNewTool);
					//drawPLine(plNewTool, U(200)*(r+1), r, 50); //#func
				}
			}
			
		// multiple tool lines are supported, but TODO: edit in place for beam/opening etc need to be tested
			if (plTools.length()>0)
				plTool = plTools[0];
		}// END IF (bApplyContourTest)
		else
			plTools.append(plTool);
		
	// add context trigger to change entity dependency into grip mode
		int bAddEditInPlace;
		if (beam.bIsValid() || opening.bIsValid() || epl.bIsValid() && _PtG.length()<1)
		{
			String sTriggerEditInPlace= T("../|Edit in place|");
			addRecalcTrigger(_kContext, sTriggerEditInPlace);
			if (_bOnRecalc && _kExecuteKey==sTriggerEditInPlace) 
			{			
				Point3d pts[] = plTool.vertexPoints(false);
				for (int p=0;p<pts.length();p++)	
					_PtG.append(pts[p]);
				int b,o,e;
				b = _Entity.find(beam);
				if (b>-1)_Entity.removeAt(b);
				o = _Entity.find(opening);
				if (o>-1)_Entity.removeAt(o);				
				e = _Entity.find(epl);
				if (e>-1)_Entity.removeAt(e);					
				setExecutionLoops(2);
				return;
			}
		}
		
	// add context trigger to change dependency
		String sTriggerAssignDefiningObject= T("|Assign defining object|");
		addRecalcTrigger(_kContextRoot, sTriggerAssignDefiningObject);
		if (_bOnRecalc && _kExecuteKey==sTriggerAssignDefiningObject) 
		{	
			PrEntity ssE(T("|Select a defining Entity|") + " " + sPromptDefiningObjects , EntPLine());
			ssE.addAllowedClass(Opening());
			ssE.addAllowedClass(Beam());
			ssE.addAllowedClass(Sheet());
			ssE.addAllowedClass(TslInst());
			
			Entity ents[0];
			if (ssE.go())
				ents = ssE.set();
				
		// remove any tsl which does not have a plCNC defined / // HSB-13320
			for (int i=ents.length()-1; i>=0 ; i--) 
			{ 
				TslInst t =(TslInst)ents[i];
				if (t.bIsValid())
				{ 
					if (!t.map().hasPLine("plCNC"))
					{
						ents.removeAt(i);
						continue;
					}
				}			
			}//next i
	
			if (ents.length()>0)
			{
				_Entity.setLength(0);
				_Entity.append(el);
				_Entity.append(ents[0]);
				_PtG.setLength(0);
				setExecutionLoops(2);
				return;
			}						
						
		}	


	// 
	// set tool side to read only and adjust to inside of referenced object
	// test first segment for side
		if (beam.bIsValid() || sheetDef.bIsValid() ||opening.bIsValid() || (plTool.ptEnd()-plTool.ptStart()).length()<dEps && !bCustomInsert && _bOnDbCreated )
		{
			// 5.4
			sSide.set(sSides[3]);
			nSide = nSides[sSides.find(sSide,0)];	
			
			// prior version 5.4:
			////plTool.transformBy(elzo.vecZ()*U(100));
			////plTool.vis(3);
			//Point3d pts[] = plTool.vertexPoints(false);
			//PlaneProfile pp(plTool);
			//if (pts.length()>1)
			//{
				//Point3d ptMid = (pts[1]+pts[0])/2;
				//Vector3d vecXSeg = pts[1]-pts[0];vecXSeg.normalize();
				//Vector3d vecYSeg = vecXSeg.crossProduct(elzo.vecZ());	
				////vecYSeg .vis(ptMid,3);
				//sSide.set(sSides[pp.pointInProfile(ptMid+vecYSeg*dEps)==_kPointInProfile]);
				//nSide = nSides[sSides.find(sSide,0)];	
				//sSide.setReadOnly(true);
			//}
		}

	// loop tool plines, might be multiple if defining contour splits zone rings
		Point3d ptsNN[0]; // deprecated version 5.8
		for(int t=0;t<plTools.length();t++)
		{
			PLine plTool = plTools[t];
		// declare a flag if tool can be cleared (milled completely)
			int bClearArea;

		// set automatic tool side 
			int nThisSide = nSide;
			if (nThisSide==2)
			{
				
				if (nTool==0)plTool.convertToLineApprox(U(1));
				Point3d pts[] = plTool.vertexPoints(false);
			// on insert auto correct selected tool side
				if (pts.length()>1)
				{
					Vector3d vecXSeg	= pts[1]-pts[0];
					vecXSeg.normalize();
					Vector3d vecYSeg=vecXSeg.crossProduct(-plTool.coordSys().vecZ());
					Point3d ptMid =  (pts[1]+pts[0])/2;
					if (PlaneProfile(plDefine).pointInProfile(ptMid+vecYSeg*dEps)==_kPointOutsideProfile)
						nThisSide=_kRight;
					else
						nThisSide=_kLeft;
				}	
			}

		// swap direction
			if (bSwapDirection)
			{
				plTool.reverse();
				if(nThisSide==_kRight)nThisSide=_kLeft ;
				else if(nThisSide==_kLeft)nThisSide=_kRight ;	
			}


		// the saw
			if (nTool==0)
			{
				plTool.convertToLineApprox(U(1));

			// special modifications		
				if (bIsSpecialRubner)
				{ 
				// for length of ElemSaw<230mm and material of the zone=="UD-Platte 60 mm"
				// the depth must be modified to 10mm
					int bHasDepth10;
					String sMaterial;
					// get all points of the polyline (first point only once=false)
					Point3d pts[] = plTool.vertexPoints(false);
					if(sheets.length()>0)
					{ 
						sMaterial = sheets[0].material().makeUpper();
						// get all points of the polyline
						Point3d pts[] = plTool.vertexPoints(false);
						for (int j=0;j<pts.length()-1;j++) 
						{ 
							double dLengthSeg = (pts[j + 1] - pts[j]).length();
							if(dLengthSeg<U(230) && sMaterial=="UD-PLATTE 60 MM")
							{ 
								bHasDepth10 = true;
								break;
							}
						}//next j
					}
					if(bHasDepth10)
					{ 
						for (int j=0;j<pts.length()-1;j++) 
						{ 
							
							pts[j].vis(2);
							double dThisDepthJ = dThisDepth;
							double dLengthSeg = (pts[j + 1] - pts[j]).length();
							if(dLengthSeg<U(230) && sMaterial=="UD-PLATTE 60 MM")
							{ 
								dThisDepthJ = U(10);
							}
							PLine plJ;
							plJ.addVertex(pts[j]);
							plJ.addVertex(pts[j + 1]);
							plJ.setNormal(-el.vecZ());
							
							ElemSaw saw(nThisZone, plJ,dThisDepthJ,nToolingIndex,nThisSide,nTurn,nShoot);
							if (nSide == 0) saw.setSideToCenter();
							saw.setAngle(dAngle);
							el.addTool(saw);
							// HSB-6409
							if (sProjectSpecial.makeUpper() == "RUB")
							{ 
								// 
			//					elzo
								int iColor = elzo.color();
								PLine plToolZone = plJ;
			//					Point3d ptPlane = elzo.ptOrg() + 3*elzo.vecZ() * nThisSide * elzo.dH();
								Point3d ptPlane = elzo.ptOrg();
								ptPlane = elzo.ptOrg() + elzo.vecZ() * (elzo.dH()+dEps);
								
								plToolZone.projectPointsToPlane(Plane (ptPlane, elzo.vecZ()), elzo.vecZ());
								
								// first and last point
								Point3d ptAll[] = plToolZone.vertexPoints(true);
								Point3d ptStart = ptAll.first();ptStart.vis(3);
								Point3d ptEnd = ptAll.last();ptEnd.vis(3);
								
								plToolZone.vis(4);
								
								PLine plToolZoneClosed = plToolZone;
								plToolZoneClosed.close();
								PlaneProfile ppToolZoneClosed(plToolZoneClosed);
								PlaneProfile _ppToolZoneClosed = ppToolZoneClosed;
								_ppToolZoneClosed.shrink(-U(3));
								_ppToolZoneClosed.subtractProfile(ppToolZoneClosed);
								{ 
									// remove the line between first and last
									if ((ptEnd - ptStart).length() > U(2) && (nSolidOperation==0 || nSolidOperation==1))
									{ 
										Vector3d vDir = (ptEnd - ptStart);
										vDir.normalize();
										Vector3d vDirY = vDir.crossProduct(elzo.vecZ());
										LineSeg ls(ptStart-vDirY*U(4), ptEnd+vDirY*U(4));
										PLine pl;
										pl.createRectangle(ls, vDir, vDirY);
										PlaneProfile pp(pl);
			//							pp.vis(5);
										_ppToolZoneClosed.subtractProfile(pp);
									}
									
								}
			//					dpZone.elemZone(el, nThisZone, 'I');
								dpZone.color(elzo.color());
			//					dpZone.draw(plToolZone);
								dpZone.draw(_ppToolZoneClosed, _kDrawFilled);
							}
						}//next j
					}		
					else
					{ 
						ElemSaw saw(nThisZone, plTool,dThisDepth,nToolingIndex,nThisSide,nTurn,nShoot);
						if (nSide == 0) saw.setSideToCenter();
						saw.setAngle(dAngle);
						el.addTool(saw);
						// HSB-6409
						if (sProjectSpecial.makeUpper() == "RUB")
						{ 
							// 
		//					elzo
							int iColor = elzo.color();
							PLine plToolZone = plTool;
		//					Point3d ptPlane = elzo.ptOrg() + 3*elzo.vecZ() * nThisSide * elzo.dH();
							Point3d ptPlane = elzo.ptOrg();
							ptPlane = elzo.ptOrg() + elzo.vecZ() * (elzo.dH()+dEps);
							
							plToolZone.projectPointsToPlane(Plane (ptPlane, elzo.vecZ()), elzo.vecZ());
							
							// first and last point
							Point3d ptAll[] = plToolZone.vertexPoints(true);
							Point3d ptStart = ptAll.first();ptStart.vis(3);
							Point3d ptEnd = ptAll.last();ptEnd.vis(3);
							
							plToolZone.vis(4);
							
							PLine plToolZoneClosed = plToolZone;
							plToolZoneClosed.close();
							PlaneProfile ppToolZoneClosed(plToolZoneClosed);
							PlaneProfile _ppToolZoneClosed = ppToolZoneClosed;
							_ppToolZoneClosed.shrink(-U(3));
							_ppToolZoneClosed.subtractProfile(ppToolZoneClosed);
							{ 
								// remove the line between first and last
								if ((ptEnd - ptStart).length() > U(2) && (nSolidOperation==0 || nSolidOperation==1))
								{ 
									Vector3d vDir = (ptEnd - ptStart);
									vDir.normalize();
									Vector3d vDirY = vDir.crossProduct(elzo.vecZ());
									LineSeg ls(ptStart-vDirY*U(4), ptEnd+vDirY*U(4));
									PLine pl;
									pl.createRectangle(ls, vDir, vDirY);
									PlaneProfile pp(pl);
		//							pp.vis(5);
									_ppToolZoneClosed.subtractProfile(pp);
								}
								
							}
		//					dpZone.elemZone(el, nThisZone, 'I');
							dpZone.color(elzo.color());
		//					dpZone.draw(plToolZone);
							dpZone.draw(_ppToolZoneClosed, _kDrawFilled);
						}
					}	
				}

			// standard
				else
				{ 
					ElemSaw saw(nThisZone, plTool,dThisDepth,nToolingIndex,nThisSide,nTurn,nShoot);
					if (nSide == 0) saw.setSideToCenter();
					saw.setAngle(dAngle);
					el.addTool(saw);
				}
			}
		//the milling
			else if (nTool==1)
			{
				ElemMill mill(nThisZone, plTool,dThisDepth,nToolingIndex,nThisSide,nTurn,nShoot);
				if (nSide == 0) mill.setSideToCenter();
				el.addTool(mill);		
				if (dZoneThickness>dThisDepth)bClearArea=true;	
				// HSB-6409
				if (bIsSpecialRubner)
				{ 
					// 
//					elzo
					int iColor = elzo.color();
					PLine plToolZone = plTool;
//					Point3d ptPlane = elzo.ptOrg() + 3*elzo.vecZ() * nThisSide * elzo.dH();
					Point3d ptPlane = elzo.ptOrg();
					ptPlane = elzo.ptOrg() + elzo.vecZ() * (elzo.dH()+dEps);
					
					plToolZone.projectPointsToPlane(Plane (ptPlane, elzo.vecZ()), elzo.vecZ());
					
					// first and last point
					Point3d ptAll[] = plToolZone.vertexPoints(true);
					Point3d ptStart = ptAll.first();ptStart.vis(3);
					Point3d ptEnd = ptAll.last();ptEnd.vis(3);
					
					plToolZone.vis(4);
					
					PLine plToolZoneClosed = plToolZone;
					plToolZoneClosed.close();
					PlaneProfile ppToolZoneClosed(plToolZoneClosed);
					PlaneProfile _ppToolZoneClosed = ppToolZoneClosed;
					_ppToolZoneClosed.shrink(-U(3));
					_ppToolZoneClosed.subtractProfile(ppToolZoneClosed);
					{ 
						// remove the line between first and last
						if ((ptEnd - ptStart).length() > U(2) && (nSolidOperation==0 || nSolidOperation==1))
						{ 
							Vector3d vDir = (ptEnd - ptStart);
							vDir.normalize();
							Vector3d vDirY = vDir.crossProduct(elzo.vecZ());
							LineSeg ls(ptStart-vDirY*U(4), ptEnd+vDirY*U(4));
							PLine pl;
							pl.createRectangle(ls, vDir, vDirY);
							PlaneProfile pp(pl);
//							pp.vis(5);
							_ppToolZoneClosed.subtractProfile(pp);
						}
						
					}
//					dpZone.elemZone(el, nThisZone, 'I');
					dpZone.color(elzo.color());
//					dpZone.draw(plToolZone);
					dpZone.draw(_ppToolZoneClosed, _kDrawFilled);
				}
			}
		// noNail Area
			else if (nTool==2)
				;//do nothing
		// marking line
			else if (nTool==3)
			{
				ElemMarker tool(nThisZone, plTool,nToolingIndex);
				el.addTool(tool);
				if (bIsSpecialRubner)
				{ 
					// 
//					elzo
					int iColor = elzo.color();
					PLine plToolZone = plTool;
//					Point3d ptPlane = elzo.ptOrg() + 3*elzo.vecZ() * nThisSide * elzo.dH();
					Point3d ptPlane = elzo.ptOrg();
					ptPlane = elzo.ptOrg() + elzo.vecZ() * (elzo.dH()+dEps);
					
					plToolZone.projectPointsToPlane(Plane (ptPlane, elzo.vecZ()), elzo.vecZ());
					
					// first and last point
					Point3d ptAll[] = plToolZone.vertexPoints(true);
					Point3d ptStart = ptAll.first();ptStart.vis(3);
					Point3d ptEnd = ptAll.last();ptEnd.vis(3);
					
					plToolZone.vis(4);
					
					PLine plToolZoneClosed = plToolZone;
					plToolZoneClosed.close();
					PlaneProfile ppToolZoneClosed(plToolZoneClosed);
					PlaneProfile _ppToolZoneClosed = ppToolZoneClosed;
					_ppToolZoneClosed.shrink(-U(3));
					_ppToolZoneClosed.subtractProfile(ppToolZoneClosed);
					{ 
						// remove the line between first and last
//						if ((ptEnd - ptStart).length() > U(2) && (nSolidOperation==0 || nSolidOperation==1))
						if ((ptEnd - ptStart).length() > U(2))
						{ 
							Vector3d vDir = (ptEnd - ptStart);
							vDir.normalize();
							Vector3d vDirY = vDir.crossProduct(elzo.vecZ());
							LineSeg ls(ptStart-vDirY*U(4), ptEnd+vDirY*U(4));
							PLine pl;
							pl.createRectangle(ls, vDir, vDirY);
							PlaneProfile pp(pl);
//							pp.vis(5);
							_ppToolZoneClosed.subtractProfile(pp);
						}
						
					}
//					dpZone.elemZone(el, nThisZone, 'I');
					dpZone.color(elzo.color());
//					dpZone.draw(plToolZone);
					dpZone.draw(_ppToolZoneClosed, _kDrawFilled);
				}
			}
		// this should not happen
			else
			{
				reportMessage("\n" +T("|Tool|") + " " + sTool + " " + T("|not supported|"));
				eraseInstance();
				return;	
			}	
		
		//// add an auto nonail if requested // deprecated version 5.8
			//if (nTool<2 && nSolidOperation==1)
			//{
				//// Version 5.3: create noNail from all segments
				////PLine plNN=plTool;
				////plNN.convertToLineApprox(U(10));
				////if (plNN.vertexPoints(true).length()<4)
					////plNN.createRectangle(PlaneProfile(plNN).extentInDir(vx),vx,vy);
				////if (plNN.area()>pow(dEps,2))
				////{
					////ElemNoNail nn(nThisZone,plNN);
					////el.addTool(nn);
				////}
				//ptsNN.append(plTool.vertexPoints(true)); // 5.3 append vertices of NN
			//}	
		
		// add clear area
			if (bClearArea || dDiameterClearing>U(5))
			{
			// validate clearance definition: pline must be closed
				Point3d pts[] = plTool.vertexPoints(false);			
				if (bIsClosed)
				//if (pts.length()>1 && Vector3d(pts[0]-pts[pts.length()-1]).length()<dEps)
				{
				// get potentially defines clearance tooling width
					double dCurrentDiameter = _Map.getDouble("ToolDiameter");	
					if(dCurrentDiameter>dEps)
					{
						// for existing tsls 
						dDiameterClearing.set(dCurrentDiameter);
					}
					else if(dDiameterClearing>dEps)
					{ 
						dCurrentDiameter=dDiameterClearing;
					}
				// define trigger
					String sTriggerClear = T("|Clear tooling|") + " (" +dCurrentDiameter +")" ;
					addRecalcTrigger(_kContext, sTriggerClear);
					if (_bOnRecalc && _kExecuteKey==sTriggerClear) 
					{
						double dNewDiameter = getDouble(TN("|Enter tool diameter|") + " <" +dCurrentDiameter+">" + " " + T("|(0 = no clearing)|") );
						_Map.setDouble("ToolDiameter", dNewDiameter);
						dDiameterClearing.set(dNewDiameter);
						setExecutionLoops(2);
						return;
					}
					
				// add clearing tools until nothing left
					if (dCurrentDiameter>dEps)
					{	
						PLine plClear = plTool;	
						plClear.setNormal(vz);//elzo.vecZ());
						PlaneProfile ppClear(plClear);
						ppClear.shrink(dCurrentDiameter);
						
						int nCnt;
						while (ppClear.area()> pow(dEps,2) && nCnt<100)
						{
							//ppClear.vis(nCnt);	
						// collect plines
							PLine plines[] = ppClear.allRings();
							for (int r=0;r<plines.length();r++)
							{
								PLine pl = plines[r];
								pl.reverse();
								//pl.coordSys().vecZ().vis(pl.ptStart(),nCnt);
								ElemMill mill(nThisZone, pl,dThisDepth,nToolingIndex,nThisSide,nTurn,nShoot);
								if (nSide == 0) mill.setSideToCenter();
								el.addTool(mill);
							}	
							nCnt++;	
							ppClear.shrink(dCurrentDiameter);
						}
					}			
				}
				else if(!bIsClosed)
				{ 
					reportMessage("\n"+scriptName()+" "+T("|Not a closed pline, clear tool not supported.|"));
					dDiameterClearing.set(U(0));
				}
			}// END IF bClearArea
		}// next t
		
	// create NoNail
		if (nTool==2 || (nTool<2 && (nSolidOperation==1||nSolidOperation==3)))
		{
			PlaneProfile pp(plDefine);
			Point3d ptsDefine[]=plDefine.vertexPoints(true);
		// test defining contour against zone if not closed
			if (!bIsClosed)
			{
				int nClosedToEdge;
				for(int i=0;i<ptsDefine.length();i++)
				{
					Point3d ptNext = ppZone.closestPointTo(ptsDefine[i]);
					ptNext.transformBy(vz*vz.dotProduct(ptsDefine[i]-ptNext));
					if (Vector3d(ptNext-ptsDefine[i]).length()<dEps)
						nClosedToEdge++;
				}	
				
			// make the defining profile rectangular
				if (nClosedToEdge>1 || ptsDefine.length()==3)	
				{
					LineSeg seg = pp.extentInDir(vx);
					PLine plRect ; plRect.createRectangle(seg,vx,vy);
					pp = PlaneProfile(plRect);		
				}
			}	
			
			
			
			pp.intersectWith(ppZone);
		
		// merge: close little gaps of multi ring nonail areas
			double dNNMerge = U(50);
			pp.shrink(-dNNMerge );
			pp.shrink(dNNMerge );
				
			
			pp.vis(6);
			if(1){ppZone.transformBy(vz*U(100));ppZone.vis(72);ppZone.transformBy(-vz*U(100));}

			PLine plRings[] = pp.allRings();
			int bIsOp[] = pp.ringIsOpening();
			for (int r=0;r<plRings.length();r++)
				if (!bIsOp[r] && plRings[r].area()>pow(dEps,2))
				{
					ElemNoNail nn(nThisZone,plRings[r]);
					el.addTool(nn);
					// HSB-6409
					if (sProjectSpecial.makeUpper() == "RUB")
					{ 
						// 
	//					elzo
						int iColor = elzo.color();
						PLine plToolZone = plRings[r];
	//					Point3d ptPlane = elzo.ptOrg() + 3*elzo.vecZ() * nThisSide * elzo.dH();
						Point3d ptPlane = elzo.ptOrg();
						ptPlane = elzo.ptOrg() + elzo.vecZ() * (elzo.dH()+dEps);
						
						plToolZone.projectPointsToPlane(Plane (ptPlane, elzo.vecZ()), elzo.vecZ());
						
						// first and last point
						Point3d ptAll[] = plToolZone.vertexPoints(true);
						Point3d ptStart = ptAll.first();ptStart.vis(3);
						Point3d ptEnd = ptAll.last();ptEnd.vis(3);
						
						plToolZone.vis(4);
						
						PLine plToolZoneClosed = plToolZone;
						plToolZoneClosed.close();
						PlaneProfile ppToolZoneClosed(plToolZoneClosed);
						PlaneProfile _ppToolZoneClosed = ppToolZoneClosed;
						_ppToolZoneClosed.shrink(-U(3));
						_ppToolZoneClosed.subtractProfile(ppToolZoneClosed);
						{ 
							// remove the line between first and last
							if ((ptEnd - ptStart).length() > U(2) && (nSolidOperation==0 || nSolidOperation==1))
							{ 
								Vector3d vDir = (ptEnd - ptStart);
								vDir.normalize();
								Vector3d vDirY = vDir.crossProduct(elzo.vecZ());
								LineSeg ls(ptStart-vDirY*U(4), ptEnd+vDirY*U(4));
								PLine pl;
								pl.createRectangle(ls, vDir, vDirY);
								PlaneProfile pp(pl);
	//							pp.vis(5);
								_ppToolZoneClosed.subtractProfile(pp);
							}
							
						}
	//					dpZone.elemZone(el, nThisZone, 'I');
						dpZone.color(elzo.color());
	//					dpZone.draw(plToolZone);
						dpZone.draw(_ppToolZoneClosed, _kDrawFilled);
					}
				}			
		
		// deprecated version 5.8
			//plNN.createConvexHull(Plane(elzo.ptOrg(),elzo.vecZ()), ptsNN);
			////plNN.vis(5);
			//if (ptsNN.length()==3 && plNN.area()>pow(dEps,2))
			//{
				//plNN.createRectangle(PlaneProfile(plNN).extentInDir(vx),vx,vy);
			//}
		//// if all points are on a line create a small boxed NN
			//else if (ptsNN.length()>1 && plNN.area()<pow(dEps,2))
			//{
				//Vector3d vecXSeg = ptsNN[ptsNN.length()-1]-ptsNN[0];
				//vecXSeg.normalize();
				//Vector3d vecYSeg = vecXSeg.crossProduct(-elzo.vecZ());
				//plNN.createRectangle(LineSeg(ptsNN[0]-vecYSeg *U(5),ptsNN[ptsNN.length()-1]+vecYSeg *U(5)),vecXSeg ,vecYSeg );
			//}	
		
		//// the convexe hull might introduce invalid areas
			//PlaneProfile pp(plNN);
			//if (bIsClosed)
				//pp.intersectWith(PlaneProfile(plDefine));
			//PLine plRings[] = pp.allRings();
			//int bIsOp[] = pp.ringIsOpening();
			//for (int r=0;r<plRings.length();r++)
				//if (!bIsOp[r] && plRings[r].area()>pow(dEps,2))
				//{
					//ElemNoNail nn(nThisZone,plRings[r]);
					//el.addTool(nn);
				//}	
		}
		
			
	// text display
		//Display dp(elzo.color());
		Display dp(nToolColors[nTool]);		
		if (sTxt.length()>0)
		{
		// get sizes
			PlaneProfile ppTool(plTool);
			LineSeg segTool = ppTool.extentInDir(vx);
			double dX = abs(vx.dotProduct(segTool.ptStart()-segTool.ptEnd()));
			double dY = abs(vy.dotProduct(segTool.ptStart()-segTool.ptEnd()));		
		
		// try to resolve variables		
			String sTxtIn=sTxt;
			String sOut = sTxt;
			int n1 = sTxtIn.find("@(",0);
			String sLeft;
			int n2 = sTxtIn.find(")",0);
			String sRight;
			
			int nCnt = sTxt.length();
			while (n1>-1 && nCnt>-1)
			{
				sLeft = sTxtIn.left(n1);
				sRight = sTxtIn.right(sTxtIn.length()-n2-1);
				String sVariable = sTxtIn.right(sTxtIn.length()-n1-2);
				n2 = sVariable.find(")",0);
				sVariable = sVariable .left(n2).trimLeft().trimRight();
				String sVariableRaw = sVariable;
				sVariable = T(sVariable);
				int nVariable = sVariables.find(sVariable);
				if (nVariable>-1)
				{
					if(nVariable==0) sVariable.formatUnit(dX,2,0);
					else if(nVariable==1) sVariable .formatUnit(dY,2,0);
					
					if(beam.bIsValid())
					{
					// draw beam cross section	
						if(nVariable==2)
						{
							String s; s.formatUnit(beam.dD(vx),2,0);
							sVariable.formatUnit(beam.dD(vy),2,0);
							sVariable = s+"x"+sVariable;
						}
					// draw beam name
						else if(nVariable==3)
							sVariable = beam.name();
					}
					
					sLeft = sLeft + sVariable;
					sTxtIn=sLeft+sRight;
					n1 = sTxtIn.find("@(",0);
					n2 = sTxtIn.find(")",0);
					sOut = sTxtIn;
				}
				else
				{
					sOut +=sLeft + sVariable + sRight;
				}
				nCnt--;// make sure it's not infinite
			}
		
			//dp.addViewDirection(elzo.vecZ());
			dp.textHeight(dTxtH);
			dp.draw(sOut, _Pt0,elzo.vecZ().crossProduct(-vy), vy,0,0);
		}	
		if (_bOnDebug)dp.draw(scriptName(),_Pt0,_XW,_YW,0,0,_kDeviceX);
	}// end if model mode
	


// block definition mode
	else
	{
		setOPMKey("Replicator" + " " +sTool);


		
	// the coordSys		
		vx = _XU;
		vy = _YU;
		vz = _ZU;
		
	// the tool pline
		PLine plTool(vz);

			
	// relocate grips and rebuild a pline from vertices
		Point3d ptGrips[0]; 
		for (int i=0;i<_PtG.length();i++)
		{
			_PtG[i].transformBy(vz*vz.dotProduct(_Pt0-_PtG[i]));
			_Map.setVector3d("vec"+i, _PtG[i]-_PtW);
			ptGrips.append(_PtG[i]);
			plTool.addVertex(_PtG[i]);	
		}		
	
		if (ptGrips.length()<2 && epl.bIsValid())
		{
			plTool = epl.getPLine();
			ptGrips = plTool.vertexPoints(true);	
			_Pt0.setToAverage(ptGrips);
		}
		else if (ptGrips.length()<2)
		{
			reportMessage("\n"+ "repDef mode requires at least 2 grips");
			eraseInstance();
			return;	
		}



	// the tool symbol
		PLine plSymbol(vz);
		double dXSymbol = U(200);	
		double dMinX = dXSymbol; // scale it if pline is relativly short
		if (ptGrips.length()>0)
			dMinX=plTool.length()/(ptGrips.length()+1);
		if (dMinX<dXSymbol)dXSymbol = dMinX;
		
		plSymbol.addVertex(_PtW);
		plSymbol.addVertex(_PtW+_XW*.8*dXSymbol);
		plSymbol.addVertex(_PtW+_XW*.8*dXSymbol-nSide*_YW*.1*dXSymbol);
		plSymbol.addVertex(_PtW+_XW*dXSymbol);		
		plSymbol.addVertex(_PtW+_XW*.8*dXSymbol+nSide*_YW*.1*dXSymbol);
		plSymbol.addVertex(_PtW+_XW*.8*dXSymbol);	
		
		if (nTool==0)
		{	
			plSymbol.addVertex(_PtW+_XW*.6*dXSymbol);
			plSymbol.addVertex(_PtW+_XW*.2*dXSymbol,-.5);
		}
		else
		{	
			plSymbol.addVertex(_PtW+_XW*.6*dXSymbol);
			plSymbol.addVertex(_PtW+_XW*.2*dXSymbol,1);
			plSymbol.addVertex(_PtW+_XW*.6*dXSymbol,1);
		}
		//plSymbol.vis(2);

	// display			
		Display dp(nToolColors[nTool]);
			
	// make rectangle for no nail 
		if (nTool==2)
		{
			PlaneProfile pp(CoordSys(_Pt0,vx,vy,vz));
			pp.joinRing(plTool,_kAdd);
			plTool.createRectangle(pp.extentInDir(vx),vx,vy);	
			pp.joinRing(plTool,_kAdd);
			dp.draw(plTool);
			Hatch hatch("NET", U(20));
			hatch.setAngle(45);
			dp.draw(pp, hatch);
		}	
		else
		{
			dp.draw(plTool);	
		}
		

		if (nTool<2)
		{		
		// transform tool symbol to segments saw/mill
			plSymbol.transformBy(-_XW*.5*dXSymbol+nSide*-_YW*.1*(nTool+1)*dXSymbol);
			for (int i=0;i<ptGrips.length()-1;i++)	
			{
				Point3d ptNext =ptGrips[i+1];
				if (epl.bIsValid())
					ptNext = plTool.getPointAtDist(plTool.getDistAtPoint(ptGrips[i])+dEps);
				Vector3d vxSeg = ptNext-ptGrips[i];
				double dX = vxSeg.length();
				vxSeg.normalize();
				Vector3d vySeg = vxSeg.crossProduct(-vz);
				Point3d ptMid = (ptNext+ptGrips[i])/2;
				CoordSys csSym;
				csSym.setToAlignCoordSys(_PtW,_XW,_YW,_ZW, ptMid,vxSeg,vySeg,vz);
				PLine pl = plSymbol;
				pl.transformBy(csSym);
				dp.draw(pl);
				
				PLine plRec;
				plRec.createRectangle(LineSeg(ptGrips[i], ptGrips[i+1]-vz*dDepth),vxSeg,vz);
			// angle only supported for saw lines
				if (nTool==0)
				{	
					CoordSys csRot;
					csRot.setToRotation(dAngle,vxSeg,ptMid);
					plRec.transformBy(csRot);
				}
				dp.draw(plRec);
			}	
		}
		
	// publish to map
		Map mapReplicator;
		mapReplicator.setPLine("pline", plTool);
		_Map.setMap("Replicator", mapReplicator);
	}	




















#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`98#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBJMW<F
M)HH8MAGF;"*S@';_`!,!WP#G%`%DLJXR0,G`R>M0_;+4J&%S#@@,#O'0G`/X
MGBH8=+MT"/<#[5<`JS33*"2ZKMW`=%./[H`Y-2_8;0+M%K!@`*!Y8Z`Y`_`\
MTQ:CC=VPSFXB&-V<N.-OWOR[^E+]IM]VWSX]VX+C>,Y(R!]<<TTV5J<YMH3G
M=G]V.=WWOS[^M+]DMMV[[/%NW!L[!U`P#]<<4@U$^V6I4,+F'!`8'>.A.`?Q
M/%*;NV&<W$0QNSEQQM^]^7?TIOV&T"[1:P8`"@>6.@.0/P/-4-=NM.T/1;S4
M[FUA:."-FV;!ERW\/3JQP*-`U-+[3;[MOGQ[MP7&\9R1D#ZXYIOVRU*AA<PX
M(#`[QT)P#^)XK&\,:I:^(=,:[;34L[N&=HKBV8!FAE3C&<#/RD8/H:V/L-H%
MVBU@P`%`\L=`<@?@>:;5G9@G=70XW=L,YN(AC=G+CC;][\N_I2_:;?=M\^/=
MN"XWC.2,@?7'---E:G.;:$YW9_=CG=][\^_K2_9+;=N^SQ;MP;.P=0,`_7'%
M(-1/MEJ5#"YAP0&!WCH3@'\3Q4P96SM(.#@X/>H/L-H%VBU@P`%`\L=`<@?@
M>:BETJT<,8HQ;3$/MF@`5U+X+$<8R2`>0>E/0-2[156TN'DDF@G"B>)LD(&P
M4).PY(`)P.<9P<U:I#"BBB@`HHHH`****`"BBB@`K@K_`,<:I!JM[;6]C9M%
M;SM$&DD;<V._`KO:\@O_`/D/:O\`]?LG]*YL74E3A>)VX"C"M5Y9K2QZ=H.I
M/K&A6>H21K&\\8=D4Y`/M6C6!X)_Y$S2O^N/]36_71%W2..2LV@HHHIB"BBB
M@`HHHH`*Q]9\3:=HI\J:0RW1&5MH1N<^Y[*/<X%;%>>>,](^P:J-4A7]Q>L%
MGP/NR@8!^C`8^H'K65:<H0<HHWPU.%2JH3=DSM]*U*#5],@OK?(25<E6ZH>A
M4^X.1^%7*\X\'ZM_9FK_`&&5L6M\WR9/"3=O^^AQ]0/6O1Z*-15(*08BBZ-1
MP8454L[]+N:Z@V-'-;2['1O0C*L/8C^H[&K=:F`5!'>0RWL]HC$S0(CN,=`V
M<<_\!-%Q>VEHT:W-S#"TIVQB20*7/H,]:S+'_D;=8_Z]K7^<M.PKFU17/>+M
M3O-+L]-DLYO*:;4K>"0[0V49L,.0>H[]:Z&ETN/K8****`"BBB@`HHHH`***
M*`"J;ASK$)_>;%MW_N[<EE_X%GCZ<U<JBP']NQMM7=]F8;O*.?O+_'TQ_L_C
M0)EZBBB@844$X&36;<^(-'LV=;C4K:-HV5&!D&0S9VCZG!P*`-*N"\<7NH77
MB#1](TK3&U.2V8:E<VPN%A!5#B/+-_M\X[XKMK:^M+PR"UNH9S$VV012!MA]
M#CH:5+6WCN9;E+>);B4!9)50!G`Z`GJ<9.*:T=Q/56//_#VH:O8_$*X75]$.
MD0ZY%NBC^TI.&GB')RO`RIYR.PKT:H)[.UNGA>XMH9F@?S(FDC#&-O[RYZ'W
M%3T-W$E8***Y[_A)2=1\I(4-L94A5\G<S,>WY9^E(JQT-%%%`%(L!K:KN&6M
MB=OG<\,.=GX_>_"KM5#O_M=#B39Y#<[5V9W#O][/MTJW0)!15;4-0M=+L9;V
M]E\JWB`+OM+8R<#@9)Y(Z5C?\)QH7_/6]_\`!;<__&Z!G145SO\`PG&A?\];
MW_P6W/\`\;H_X3C0O^>M[_X+;G_XW0!T5%<[_P`)QH7_`#UO?_!;<_\`QNC_
M`(3C0O\`GK>_^"VY_P#C=`'145SO_"<:%_SUO?\`P6W/_P`;H_X3C0O^>M[_
M`."VY_\`C=`#_%'BE/#,=GFRGO);N4QQQQ$#&!DDD\``5Y-J.KWZ7NHWSZ5L
M@EG>;<UT@VJ?6NI\:>)])U*?2H[>>4-&\LC>?;2P@*$Y.74#BN8@1]3F2[G5
MDMD.ZWA88W'M(P_D#TZGG&/-QE1\W(]CV<NHKD]HG[VQV/@GQ<T>GZ-H]UI-
MQ!)(/*$C2*<'!89'7M7HM>(0:W;V/BC2C)N\F"[7SY51GV$HV%`4$ECGH!P.
M3U&?2F\>^'D.'N+M3[Z?<#_VG75AIRJ0NSAQM*%*KRQ.EHKCM0^)WAG3X%E>
M:\D#.$PME*N,]\NJCCZY]`:M_P#"P/#?_/W=?^"^X_\`B*Z>5G'S(Z:BN<'C
MG02`1->D'H1IUQ_\;I?^$XT+_GK>_P#@MN?_`(W2&=%17._\)QH7_/6]_P#!
M;<__`!NC_A.-"_YZWO\`X+;G_P"-T`=%574;"#5-.GLKD$Q3+M..H]"/<'!'
MN*Q_^$XT+_GK>_\`@MN?_C=9?B3Q'H^M^'-0TR#4-1M)KF%D2>/3[D%&[=$Z
M>H[C-#&MSS[4+J6WENM-6,SWMLYCED1MD<97H^_MV8`98>E:^E^+M>EAT_6[
M^[>1A&LLMK$-D9C*_,NW^]CG))Y'8<5SU[<12>%7CM%,7G`6:IC#1NS",@CL
M02<_2K6N9BT&>"'Y&E5;:/'\)<A!^6ZO%524':&FI])*E&HKU-;(]5U.\C@M
M[?Q3IX-U;K`#,(2,SV[#<&&2!E2=PR1P6]:R-.C\=ZGX@GN;Z2/2=)ECVQQ0
MO'-+'@\$$AER>YY[<<5G>%_%&G^'X/[%U-Y%MI,FR"0/+D=7CPH)X^\/8GTK
M3T;QGH]@LFF2S7AC@/\`HC&PN"6A[`C9GY<[<^@'J:]FE44X<R/G*]&5*HX2
MZ%K5OAWI&N^1_:=UJ5T8I-Y,EVQW\8QC[JC_`'0#3]!TJR\/ZSK5KI-BL<26
MMNZPQG[[?O>Y[G`&35C_`(3C0O\`GK>_^"VY_P#C=95IXQT5/$VJ3F6[\N2"
MW5<6$Y.09,Y&S(ZCK5W;5C/E2:=BC?ZOJ?C"?2=.@\,ZM8-!?0W5U-?0^7%&
ML9R0K9^<YZ<#/7Z>BUSO_"<:%_SUO?\`P6W/_P`;H_X3C0O^>M[_`."VY_\`
MC=)M=!I/JSHJ*YW_`(3C0O\`GK>_^"VY_P#C='_"<:%_SUO?_!;<_P#QND,Z
M*BN=_P"$XT+_`)ZWO_@MN?\`XW2'QUX?09>YNHUR`6DL+A5'U)3`_&@#HZ**
M*`"BBB@`JBQ']NQKN7=]F8[?-.?O+_!TQ_M?A5ZJAW_VNA_>>7Y#?W=F=P_X
M%G]*`9;HHJ&[=X[.=XX_,=8V*IG&XXX&:`/$OBK\2YUOKCP]I4IC15>WO&*D
M,"=I!4_3(_/VKS$R)=,T\\GFRR$,[R-N9B!@$DUF:L\SZM=F<7(D$K*5NFS(
MH!P%;W``'X5ZG\'_``/HWB;2+Z\U-WF>.41K"CE=@QG<<<\]OH:`.&L_$=]X
M=NX;C3;EU\N0RB'S&\IV/<J",U](>`O&$'C#0$N@X-U&`MP%B**'P,XR3D?C
M7S'XNTV'1_%VI:=;3^?#!,51\_H?<=/PKTGX!W-P-8U"W_TPVYC!R&S"K>XQ
MPQQP<]J`/?:***`,S7+S[)IS!6Q)*=BGT]3^5<[I=KYNO6-N`0MM&;N4?[;?
M*@/N!FJ6MZQ/J&ML;9(VL+8;6=FQDY^;_"MSP@&NX[[5Y%PUY-\@]$7@#]#4
M[LNUD=-1115$%$A?[=0[4W_9F&?+;=C</XNF/;KWJ]5(L/[;1=PS]F8[?.Y^
M\.?+_P#9OPJ[0)'/>./^12NO^NL'_HY*T*S_`!Q_R*5U_P!=8/\`T<E:%`PH
MHHH`****`"BBB@#SSXCV\=SKGAI91N16N6VGH2%0C/X\U@7=S++/]ALVQ,1F
M67&1`I[^A8]A^)XX.[\2S<?VQX<6UVB5S<J';D)\J9;'?'IW..E8?^CZ/8_Q
MN2WUDFD/\V)_#Z`5Y6,_BGO9;_`^80PP66K>';>/Y1_:<>,G)8X8DD]22>2?
M>O8:\8M;64>(="N[L@W+ZC$H53E8EPQVK^F3W(]``/9ZZL%_#^9PYE_&^1D>
M(P#86N1_S$+3_P!'I5/Q%XDOM(U/3]/T[1_[2N;U9&5/M2PX"8)Y8$=#[=*N
M>(O^/"V_Z_[3_P!'I6)XDO+6P\?>&KB\N8;:%8;H&2:0(HRJXY/%=L5=I>OY
M'F2=DVO+\R[I?BN:;5(M*UK1[C2;^<,T"O(LL4H`R0LB\;L=1C^==+7"ZWJE
MCXE\1Z#INC7$5[-:WBWD\T!WI#&H/5AQDYQC-=U0UI?8(O5J]PHHHJ2PHHHH
M`\O\=:$UCXFT_5(L+IUY<AKI>RW`1E0^P?C_`($@[M6/J?[_`%32K3G'FM<.
M!_=1<#_QYTKUS5M,MM9TJYTZ[4F&=-K$=5/4,/0@X(/8@5X_917:^)+Z'4%`
MNM/B2T<CHS$EBX]F7RV'_P!:O-QE*S]HCV<OK\T?9/?]`U?[3-JNEPV4WDW4
M#O>QOZ-&-JY_V2SC([@$5Z1#?_\`"0:#9ZY81$7ML2WD9^8,/EEA/UP0.V0I
M]*\\M<3^(K^;'%O'';`^C<NWZ,GY5I>$M<?2_&-[;.`NF7DT=NQ[)=;`5;Z,
M&5#[A/>E@ZO++D>P\QH<\/:+>_X?TCU"UN8KRUBN8'WQ2H'1O4&LVS_Y&K5O
M^O>V_G+1:_\`$KUA[(\6MX6FMO19.LB?C]\?5_2BS_Y&K5O^O>V_G+7JGAWV
M->BBBI*"BBB@`K"\9_\`(GZE_P!<OZBMVL+QG_R)^I?]<OZB@#KJ***`"BBB
M@`JBP7^W8VVIN^S,,^4=V-R_Q],>W7O5ZJ3,/[<C7<N?LS';YQS]Y>=G3_@7
MX4"9=ILB++&T;J&1P58'H0:=10,^3?B%X5D\+^*IK<1P16URQ>V2.;>=O&<Y
MY')Z&J>DS7NE(S65W+;M(,.8W*DCTX/2OJO7=`T_Q'ILMAJ$;-%(NTE&VL![
M$<BO,[WX'(T[M8:T\$32KMC:/<(HP.1DDEF/')([_2@#PO4+<QR-,6SNY8U[
MY\%/"4NCZ5-K%W#LN+Q`(G60D/$0K#([$$?S]JTO#GPBTG1K^._N[B6]N(9W
MDAW'"JIX52!P<#G.!S7H444<$*0Q($C10JJHP`!T`H`?6)XLU,Z5X>N)4.)9
M!Y4?U/\`@,FMNN9\::7=ZEI\#6:&22!R^S.,_*?\_C2>PXVOJ<0_EV6@JIA;
MS'7+%CP/<UZ5X>M9;+0+."8J9%C&=HXYKS+2++7-;U.UL]5TV6.UC92PS_">
M<GZ]*]?`"J%`P`,"E%%3=Q:***H@J'?_`&NAQ)L\AN=J[,[AW^]GVZ5;JB0O
M]NH=J;_LS#/EMNQN'\73'MU[U>H$CGO''_(I77_76#_T<E:%9_CC_D4KK_KK
M!_Z.2M"@84444`%%%%`!1110!YY\2KF*TU?P]-,Q"+]IZ#))*H``.Y)XQ6!:
M6TLL_P!NO%Q,1B*+.1`I[>['N?P'`R?3M:\.:1XA6!=5LEN?(8M$2S*4)&#@
MJ0:R6^&_A-E*MI601@C[3+_\57)7PSJ2YD['H87&JC#E:N<##=O>^)-":#`L
MX]3C7S,?ZUL-G;_LCU[GITY]HKG;#P+X:TR\AN[32U2:`[HF,KL%.,9`+$5I
MWNC6&HS"6ZM_,D"[0=[#C\#[UM0I>RCRG/BJ_MI\]BMXE=4T^U+,%']H6G4X
M_P"6Z5<OM)TW4RAU#3[2[,>=GVB%9-N>N,CBLC4?`OA_4X$AN+-]JN'&V9P<
MC\:M_P#"+Z,!_P`>?_D5_P#&M]#EUN:%G86>G0>18VD%K#G=Y<$81<^N!WJQ
M4<,,=O`D,2[8T4*HSG`J2I*04444`%%%%`!7$>.],,#P^(H%/[A1#?*/XH">
M'_X`23_NLWI7;TV2..:)XI45XW4JZ,,A@>H([BIG!3BXLNG4=.:G'='B7AN6
MXU*&1=+M)+Z\N9WG?8=L<2LQV>9(>%^0+QR3C@&NX\._#NWT^7[;K%R;^[:<
MW`A&5MXG)R,+_&1P`6]`0`:Z^QL;33;..TL;:*VMHQA(HD"JOX"K%94\/"#O
MNS>MC*E5<NR*>IV1O[)HT<1SH1)!+C.R1>5/TSU'<$CO4-C:7":C<W\X1&N8
M(5,2MG8R[]PSW'S=?:M*BNBYR6UN%%%%(84444`%87C/_D3]2_ZY?U%;M87C
M/_D3]2_ZY?U%`'74444`%%%%`!51M_\`:\?^LV>0W9=F=R]_O9_2K=46"_V[
M&VU-WV9AGRCNQN7^/ICVZ]Z`9>H)`&2<`45C^+?^1,UW/_0/N/\`T6U`&A]O
ML_\`G[@_[^"C[?9_\_<'_?P5XVF@Z;H\L5\VF13^#9)%:>9K5&D@?`Y5_O&#
M=U].QQ6==:7I,FI3MIMIYG@5KH?:M0BM$=XF/5(I<[_)SU8`[>@.*`/=?M]G
M_P`_<'_?P4^.ZMYFVQ3Q.V,X5P37G%SX>T$2S_V9I5H^B@K]KG2T20P_WO*8
M\XQC=C.WG'LZPTS2;'XCZ2^@VT"6#)<!WCA`'F;!\J/U(QU'(!/!ZB@#TJBB
MB@`J,7$)G,`FC,P&3'N&X#Z5D:IK.VX.G64B_;&7+/U\L>ON?Y=_0\?J$TNC
M&.)VDGNY6S;M']YW]?\`>Y_']*SE.VRN:TZ7/N['I=%0637#6%NUTH6X,:F5
M5Z!L<_K4]:&12)']MHNX9^S,=OG?[0Y\O_V;\*NU4(?^UU.)-GD'G:NW.X=_
MO9]NE6Z!(RO$>ES:SH-S8V\L<4TA1D:0$J"KJPSCG'RXK,^R^+_[VA_^1:W=
M3U*VTC3IK^\9E@B`W;$+L<D```<DDD"L?_A,[+_H&ZW_`."N;_XF@9%]E\7_
M`-[0_P#R+1]E\7_WM#_\BU+_`,)G9?\`0-UO_P`%<W_Q-'_"9V7_`$#=;_\`
M!7-_\30!%]E\7_WM#_\`(M'V7Q?_`'M#_P#(M2_\)G9?]`W6_P#P5S?_`!-'
M_"9V7_0-UO\`\%<W_P`30!%]E\7_`-[0_P#R+1]E\7_WM#_\BU+_`,)G9?\`
M0-UO_P`%<W_Q-'_"9V7_`$#=;_\`!7-_\30!%]E\7_WM#_\`(M'V7Q?_`'M#
M_P#(M2_\)G9?]`W6_P#P5S?_`!-'_"9V7_0-UO\`\%<W_P`30!%]E\7_`-[0
M_P#R+1]E\7_WM#_\BU+_`,)G9?\`0-UO_P`%<W_Q-'_"9V7_`$#=;_\`!7-_
M\30!%]E\7_WM#_\`(M'V7Q?_`'M#_P#(M2_\)G9?]`W6_P#P5S?_`!-'_"9V
M7_0-UO\`\%<W_P`30!%]E\7_`-[0_P#R+1]E\7_WM#_\BU+_`,)G9?\`0-UO
M_P`%<W_Q-'_"9V7_`$#=;_\`!7-_\30!%]E\7_WM#_\`(M'V7Q?_`'M#_P#(
MM2_\)G9?]`W6_P#P5S?_`!-'_"9V7_0-UO\`\%<W_P`30!%]E\7_`-[0_P#R
M+1]E\7_WM#_\BU+_`,)G9?\`0-UO_P`%<W_Q-'_"9V7_`$#=;_\`!7-_\30!
M%]E\7_WM#_\`(M'V7Q?_`'M#_P#(M2_\)G9?]`W6_P#P5S?_`!-'_"9V7_0-
MUO\`\%<W_P`30!%]E\7_`-[0_P#R+1]E\7_WM#_\BU+_`,)G9?\`0-UO_P`%
M<W_Q-'_"9V7_`$#=;_\`!7-_\30!%]E\7_WM#_\`(M'V7Q?_`'M#_P#(M2_\
M)G9?]`W6_P#P5S?_`!-'_"9V7_0-UO\`\%<W_P`30!%]E\7_`-[0_P#R+1]E
M\7_WM#_\BU+_`,)G9?\`0-UO_P`%<W_Q-'_"9V7_`$#=;_\`!7-_\30!%]E\
M7_WM#_\`(M'V7Q?_`'M#_P#(M2_\)G9?]`W6_P#P5S?_`!-'_"9V7_0-UO\`
M\%<W_P`30!%]E\7_`-[0_P#R+534]$\5:MITUA/-HT<,P"N\8E+`9!XSWK0_
MX3.R_P"@;K?_`(*YO_B:;)XXTR!/,GL]7AB!&Z2739E5<G&2=O`H`Z6BBB@`
MHHHH`*I,P_MR-=RY^S,=OG'/WEYV=/\`@7X5=JE=.;?4+:=W80%6A;E0BLQ7
M:23SU&T`=VZ4T)EVL;Q;C_A#-=ST_L^XS_W[:MFLSQ);2WOA?5[6",R33V4T
M<:#JS,A`'YFD,\X2\N-:BBTBTNKF/P?&RQ76H+P2<#,"/G/EYX+XX^[GO4LD
MDOA"XFL=.FNF\%AU2>XC^=M.8GYD1B<F/IEN=F?RJ,=8,-KX9MM%U^T\+H@$
M[I:XFVXYA0[L["<Y;KCCGK6FEY?62IX>L/#VM1^'&C*E_LN984[PJ">5/]X\
MCISUH`U9)/($T6C33_\`"/@K]JE@^;R?[WE-G.,8W8SMY(]LZSOM/;XEZ7IN
MC2O-I]LDY?;\T4,I0?(C=\CDCM^.*S;6;5M!OCI&DZ-XA'A>?!V_9LS6?JD9
M+9*'UZKV]M;2+5U\<:<FF:'J5CI$*3S2_:;<1QQRNH'RG.3NZD>OUX`/1:P?
M%&M/I-G&L*L9IB1N49V*/O-^%;U<QJ>AZQJ/B1YQ>6T6F?9A$J&,M)NR23Z#
MKCOTJ9IN+2+@TI)LY&]NTB6&.W62:_E;-NB']X7/<^GOFNO\.>')K60:IK#K
M<:M(.H'R0C^Z@_K5K1?"FF:'.]S!&7NI!AII#D_@.@_"MRL,/AW26KN=&)Q"
MJM<JL%%%%=)R%$A?[=0X3?\`9F&?+;=C</XNF/;K5ZJ$#K<ZM<2QN'C@0096
M8D;\DLI7H"!LYSW(XQ5^AB1SWCC_`)%*Z_ZZP?\`HY*T*S_''_(I77_76#_T
M<E:%`PHHHH`****`"BBB@`HJ.>406\LQ&1&A;'K@9IEE<_;+&WN@NP31+)MS
MG&1G%`$%OK.GW5G<7D5TOV>V=XYI'!0(R<-G..GKTJ33M1MM5L8[RS9WMY!E
M&>)H]P]0&`./?O7E=C)F=XM<1E\,G5KDNZ<HT_F_*)S_``Q],=B<9/IZZNT*
M`N-N.,=,535DGW(C)MV%HJIIUZ-0M#.(R@$TL6"<_<D9,_CMS^-6ZDL****`
M"BBB@`HHHH`****`"BBJ6K7KZ=IKW*(KLK(N&Z?,X7^M`-V+M4]/U2SU6.:2
MRF\U89F@D.TKAU^\.0/SZ5<KD?A__P`@_6/^PQ<_^A"FE>Y,G9HZZBHKF4P6
MLTP`)C1F`/?`S3-/N&N]-M;EE"M-"DA`Z`D`TBBQ1110`5A>,_\`D3]2_P"N
M7]16[6%XS_Y$_4O^N7]10!UU%%%`!1110`4V2-)4*2(KH>JL,@TZJMY/+'Y4
M-N/WTS85FC9D4#EBV,8XR!R.2*`*SFXTZ''VZW>,;%3[62K9+8.Y\\Y!``VY
MR.2<U`^MA5D;[9I`"K.V6O<`",XR>.`/X_[OO6A;:=;6H!5/,EVA6FE.^1P"
M2,L>3@DX'0=L5:IBLS)&K_Z0(_M.E_ZY8]HN_FYCW$8Q][N!_=YJ%=<W0H_V
MS1B6BB?(O<J=[[00<?=/13W/%;E%&@69BOK859&^V:0`JSMEKW``C.,GC@#^
M/^[[U(-7_P!($?VG2_\`7+'M%W\W,>XC&/O=P/[O-:U<EKGBW5+#Q,FAZ3X>
M_M2X-K]J8_;5@VKNVG[PQUQW[T+5V$[I7-%=<W0H_P!LT8EHHGR+W*G>^T$'
M'W3T4]SQ3GUL*LC?;-(`59VRU[@`1G&3QP!_'_=]ZI^'_%DVJ:K<:/JND3:3
MJL,?G>0\@E22/@;E=>#R<'^O..FIM6!:F2-7_P!($?VG2_\`7+'M%W\W,>XC
M&/O=P/[O-0KKFZ%'^V:,2T43Y%[E3O?:"#C[IZ*>YXK<HI:#LS%?6PJNWVS2
M`%$[$M>8`$9QD\=CP_\`=]ZL(\]^TD8O+941E$BVS;GP4Y!;C:<D$'&<8K2J
MM<V%M=%6DB7S4):.4`;XV*E=RGL<'&:-`LR:&)8((X4SLC4*NYBQP!CDGD_4
MT^J=E.WF2V4T@>>!5.=V6>,Y"NW``)*MD#CBKE(9SWCC_D4KK_KK!_Z.2M"L
M_P`<?\BE=?\`76#_`-')6A0`4444`%%%%`!1110!1UJYBLM#O[F=ML4=N[,<
M9XVFL70O%>BOH&GD7G2W12/*?@A0".GJ*WM24-I=VK`%3"X((X/RFHM#4+X?
MTU5``%K%@`?[(JM+$N_,8-G/X7M--O-/-T\]M=RRRRI-&QR9#EAPHX]*ET;4
M]"T/2X["+5;B>"'(C-PC,R+V4$*.!VS74447#E.=\$ZG::KX?>>SD+QB\N<D
MJ1]Z5G'7_993^-=%6-X81(]&94557[9=<`8_Y;R5LTGN$=D%%%%(H****`"B
MBB@`HHHH`*YOQUJ4>E^%IKB2*61?-B&(ER?OJ?Z?GBNDK(\3_P#(`F_ZZ1?^
MC%IQW)E\+&KXCMV16_L_5AD9P;"7_"N0_P"$?T])[B6VU+QK:+<3/.\5LDD:
M;F.3@".O2**:=M@<;[G+WWB&WL?#UPIL]8E$-J5WRV<FYL+C+,0!GU)K2\+W
M:WOA;2[A$=%>V3"N,'@8_I5W4/\`D&W7_7%_Y&HM$_Y`.G?]>L7_`*"*&[H2
M33+U%%%26%87C/\`Y$_4O^N7]16[6%XS_P"1/U+_`*Y?U%`'74444`%%%%`!
M5%RAUV$$Q[UMGP-[;L%DSQ]W'`Y//IWJ]51BW]L(,OL^SL<>8NW.Y?X>N??I
M^=`F6Z***!A1110`5YQKEEJE_P#%E(M)U?\`LNX&C[FG^S+/E?-Y7:W'7!S[
M5Z/7,:YX)M=;UE-5_M;5]/NE@\C=87`BRF<X)VD]??L*J+L[BEK%K^MSG]+M
M]1\/?$N"+6KY-8N=5M&C@O=GE/"$^9D\L':%/'([CZUZ/7)>&-#\.:;K-U+9
MZP^JZUY>V::ZOA/.D>1@$#HN1UQ^-=;1)WL3%-7"BBBI+"BBB@"F6/\`;2KN
M;!MR=OG#'WASLZ_\"_"KE4R&_ME&PVW[.PSY0VYW#^/KG_9_'M5R@2.>\<?\
MBE=?]=8/_1R5H5G^./\`D4KK_KK!_P"CDK0H&%%%%`!1110`5%-<PVYB$KA3
M+((TSW8@D#]#4M<1X\AUF>\T<:;;ETBG#AO,5<R_PCDCL#STYJ9R<8W1M0I*
MK44&['6ZE>)I^F7-VZ&188RY0?Q>U<I!XUU*:!)+?PI=O"1\C1LQ4CVPE;OB
M0LWA2_9D*,;<DJ3G!QTIOA'_`)%33_\`KG_4US5'4E64(RLK7V7?S.JC&E##
MNK.',^:V[72_0R/^$QUC_H4;_P#-_P#XW1_PF.L?]"C?_F__`,;KL:*?L:W_
M`#\?W+_(GZQA_P#GROOE_F>>Z)XKU:#3F2/PO>RK]IN&W*6QDS.2/N=B<?A6
MC_PF.L?]"C?_`)O_`/&ZVO#7_((;_K\NO_2B2M>JE2JN3M4?W+_(B&(PZBDZ
M*^^7^9QW_"8ZQ_T*-_\`F_\`\;H_X3'6/^A1O_S?_P"-UV-%3[&M_P`_']R_
MR+^L8?\`Y\K[Y?YG'?\`"8ZQ_P!"C?\`YO\`_&Z/^$QUC_H4;_\`-_\`XW78
MT4>QK?\`/Q_<O\@^L8?_`)\K[Y?YG'?\)CK'_0HW_P";_P#QNC_A,=8_Z%&_
M_-__`(W78T4>QK?\_']R_P`@^L8?_GROOE_F<=_PF.L?]"C?_F__`,;H_P"$
MQUC_`*%&_P#S?_XW78T4>QK?\_']R_R#ZQA_^?*^^7^9QW_"8ZQ_T*-_^;__
M`!NL[7/%6JW&DR12>%[V%2\>78M@8=3_`'/PKT*LCQ/_`,@";_KI%_Z,6JC1
MJW7[Q_<O\B9XC#N+M17WR_S,7_A,=8_Z%&__`#?_`.-T?\)CK'_0HW_YO_\`
M&Z[&BI]C6_Y^/[E_D5]8P_\`SY7WR_S.+F\:ZI#"\D_A2\2)1EF=F"@>Y*5O
MVNKM<:%:ZA:Z;<3^<H_T>!HPR=>[LHP,>OIQ2>*/^17U+_K@U1^$?^14T_\`
MZY_U-*FZD:W)*5U:^R[^15949X;VL(<KYK;M]+]1EWK^H6UG/.OAC5&,<;.%
M,EOS@9QQ*3^0)]C4.E^);_4=+MKP^&-37SHP^%EM\8/IND4X^H%;MW_QYS_]
M<V_E7FNIVEY>:CX)CT^Y-M>IICR02?P[UC0@,.ZG&#]:[E9Z?UM<\N5UK?\`
MJZ1Z/97,UU$SS6-Q9L&P$G:,DCU^1F&/QSQ67XS_`.1/U+_KE_45S5YK*ZWJ
M?@^X:(P7,=_)%<V[=890GS*?YCV(KI?&?_(GZE_UR_J*35BHRN==1114E!11
M10`539?^)U&VT_\`'NPW>3_M+QO[?[OX]JN518I_;L8S'O\`LS<;VW8W+V^[
MCWZTT)EZFR2)#&TDKJB*,LS'``^M.KE?%%I;7OB+P_#=VT-Q$/M,@CFC#KN$
M?!P>,BD,N/XST+S&CM;PZA*#@QZ=$]T0?0^6&"_CBL.Z^(Z^<UO9:?'YX_Y9
MW5VOF?410"63\"JURQMA<:':S73?:ECT6TU"Y^V*]UYCS%EV1PM(L*#*]2I'
M/3BG&VUCSYM+BAO'>W8+);VYD*1L5#!66W6WA!VLIVM*W!&:`-+4?%?B``&Z
MO4TR-_NEHX;+\-UPSN3](16+>;KJ#S]2DFN8#U:XCEFB/TDNVBM\>ZQ'^E:^
MG>"=>R6B@ATT/]XB9+=OQ%LN\GZSFMJS^&\$<XN+O46,_=[2W2)C_P!M'\R;
M_P`B4`<%/;17MC,;9IU#P-`MY!)+((E;N!"L%L"#@C+D9`-=)H_CW7/M3JUL
M-9@DN$`-IB26%#@-Q`KQ<')^:7VR<UVL'@_0(95F?38[JX7D3WK-<R`^S2%B
M/P-;1*0Q98JD:#DG@`4`4=%U>+6].^V103P`2RPM%<*`ZM&[(P."1U4]ZT*X
M7PUXLT6TL+Z`7;75P-3OF,-E"]RX!N)""1&&P""#DX&#GI27/Q)B:<V^GZ=Y
MDX_@GN%+_7RH!++^:"@#NZ*X73OB59K)#:>(;632KQXI9"92H0[&`P%SYF2&
M!P4'?T-=K!<0W4$<T$@>.1%D1AW4C(/XT`5FV?V]'_J]_P!E;^]OQN7_`(#C
M]:O53)/]LHNYMOV=CM\T8^\/X.I/^U^'>KE,2.>\<?\`(I77_76#_P!')6A6
M?XX_Y%*Z_P"NL'_HY*T*0PHHHH`****`*6HW,D*PP0$"XN9/*C)&0O!8L?H`
M?J<#O61JVAZ?OTXSVZ74CW:+)+<J)&<;6R"3V]A@>U:6J'R+BQOF_P!3;R,)
MC_=1E(W?@=N?09--UC_6:9_U^I_Z"U1+6]SII-QY>7K<R?$]N=*T"\,#M]BE
MC,;PLV1&QX4KGD`G@CIR",<YT/"/_(J:?_US_J:J>-Y@?#ES9IAII4WX_NHI
M!9C[=!]2*M^$?^14T_\`ZY_U-<Z_WK_MW]3HE=X&[_F_0VJ***ZSSC&M-0T7
M2HGM#J]F&6:5V$EP@8,[LY!&>Q8BI_\`A(=%_P"@QI__`($I_C7(>!_#.AZE
MX<^U7NE6EQ.US.&DEB#,<2,!S72?\(7X8_Z`.G_]^%JVHIF<7)JZ+?\`PD.B
M_P#08T__`,"4_P`:/^$AT7_H,:?_`.!*?XU4_P"$+\,?]`'3_P#OPM'_``A?
MAC_H`Z?_`-^%I>Z5[Q;_`.$AT7_H,:?_`.!*?XT?\)#HO_08T_\`\"4_QJI_
MPA?AC_H`Z?\`]^%H_P"$+\,?]`'3_P#OPM'NA[Q;_P"$AT7_`*#&G_\`@2G^
M-'_"0Z+_`-!C3_\`P)3_`!JI_P`(7X8_Z`.G_P#?A:/^$+\,?]`'3_\`OPM'
MNA[Q;_X2'1?^@QI__@2G^-'_``D.B_\`08T__P`"4_QJI_PA?AC_`*`.G_\`
M?A:/^$+\,?\`0!T__OPM'NA[Q;_X2'1?^@QI_P#X$I_C5>]U'1-4M39G6++]
MXR$;+E"20P(`Y]13/^$+\,?]`'3_`/OPM<Q\0/#&AZ=X-N[JRTFSM[A)(=LD
M<05AF10>?H::46R9.23;/07ECBQYDBIGIN.*9]KMO^?B+_OL4R[T^RO]GVRS
MM[C9G;YT2OMSUQD<=*K?\(_HO_0'T_\`\!D_PJ="]2KXGNK<^&=1`GB),)`&
M\5'X2NK<>%=/!GB!$9!!<>IJ'Q)H6D1>&]0DCTJQ1UA8JRVZ`@_E4?A70])F
M\,6$DNEV3NT?+-;H2>3WQ7-[OUG_`+=_4[?>^I>7-^ANWM[:1V%P[W4*JL3$
ML9``!BN6TNS6^N/">L0WMH;:RT]HY`9?F):-0,=N"#G)%=#+X:T*>%XI-'L"
MCJ5;%NH.#[@9'X4VV\+:!9VT=O#H]D(XQA=\*N?Q)R3^)KJ32_KY'`TWO_6M
MS'U+PD+[QGI?B'3[B%5ADS=Q[CB0A2%88R-P!QSVQ6EXS_Y$_4O^N7]16M:V
M5I8QF.TM8;=&.2L480$^O%9/C/\`Y$_4O^N7]12OI8I+6YUU%%%(84444`%5
M"7_M=!F39Y#<>8NW.X?P]<^_3\ZMU2*_\3I&V_\`+NPW>3_M#C?_`.R_C0)E
MVN:U_P#Y&?0?]R[_`/18KI:YK7_^1GT'_<N__18H&<1%_P`BQ_W*^C_^C)*[
MSP]_R'/%G_853_TBM:X.+_D6/^Y7T?\`]&25C^(?&'B72O'WB;3M(D$5J;J*
M>1H8T:<G[/"IV^8"I`"KQC//?.*F<U"/-(NG3E4ERQW/=*XS5?&MY!<30Z=I
MB2JEV;))99'9I90F\A(XD<G`SRQ4<'FO*/[5379&AOM6U"[G(R]M>3NN/^V7
M"_B%Q76>`XHX(M%BAC2.-?$5T%1%P`/L4G05A2Q4:LW!)KU.JO@I4::J2:=W
M;0?=>+M?O+AK9M26&8'#6UJ(TD'_`&SC%S+^B$^U8]ZFZ=1JDN9B<H+]T#D_
M[(N7FDS_`+L"X["NBLK>*?2]"MI59K7[!J5T\"R,B2R))'M+A2-V-S<'UK9\
M->"M/?1+.ZEN;L?:K=)7AM76SCRRAB,0!"1S_$3[YKI.(X:\")`@U#_4$807
MJ-Y?_`?MCQQX_P!R`Y[5;MK/4=0@$-I97MS".B!9GB/_``'_`$6W_(,![UZG
MIWA[1M)<R:?I=I;RG[TL<*AV]RW4GZFM.@#S*Q\#ZX\#08M]/MG&&B$WEKCT
M,5JL61[&5L]Z-2\#)X6\-ZUK%CJMS;WD=@QQ8QI;1DQAF3(`+M@D]7/'%>FU
MS_CG_D1-<7^]92+^:XH`U"#_`&RC;6V_9V&[RAC[P_CZ@_[/X]JN51;9_;T?
M^KW_`&5O[V_&Y?\`@./UJ]3$CGO''_(I77_76#_T<E:%9_CC_D4KK_KK!_Z.
M2M"D,****`"BBCH,F@#-UBXE6&.RM6Q=WC>5&<`[%Q\[X_V1Z\9*CO6;JND0
MP-IZ6\]S!&UXH$<<GRI\K?=!SM_#BKND_P"GW4VLORDH\JT]H0?O?\#(W?0)
MZ5H7-I'=&`R%AY,HE7![@$?UI3C=6+HU'&5S#\0VEMIOA/59$#%V@.^61B[N
M>P+'GOP.@J7P7()?!^FN/^>9!^H8@U2\;7%O=^'=0LD^T2O&H>3[.!M0@Y`<
MG@=CCK47@.>"S\-V5M(+B)YR70S@;&)[(PX[9P>>M<_N^W^7ZG=RRE@KO?F_
M0["BBBND\XY/X<_\BBG_`%]7'_HUJZRN3^'/_(HI_P!?5Q_Z-:NLJI?$R8?"
M@HHHJ2@HHHH`****`"BBB@`KD?B;_P`B'??]=(?_`$:E==7(_$W_`)$.^_ZZ
M0_\`HU*J/Q(F?PLZZBBBI*,GQ1_R*^I?]<&J/PC_`,BII_\`US_J:D\4?\BO
MJ7_7!JC\(_\`(J:?_P!<_P"IKE_YBO\`MW]3N_Y@?^WOT-JBBBNHX0K"\9_\
MB?J7_7+^HK=K"\9_\B?J7_7+^HH`ZZBBB@`HHHH`*HL4_MV,9CW_`&9N-[;L
M;E_AZ8]^M7JJ$O\`VN@S)L^SMQO7;G</X>N??I0)ENN:U_\`Y&?0?]R[_P#1
M8KI:Y3Q7=+8:UHEW+#=20H+E6^SVTDQ!:/`X0$T#..B_Y%C_`+E?1_\`T9)7
M.>,E:/QGXAOHU)EM;]'P.K(;>'>OY<_4"MZUN(;CPQ)Y,J2&/PSHZ.%8':WF
M2<'T/M69XEFCM_&/BB:5ML:7B$G'_3O#7'CFU2T[GHY8DZ]GV9C:H+.YLXQ-
M;QW;2'%NA_B8C((/;CG(Z"NG^&J21Z=H4<LAD=/$EZA<DG.+64=22>W<UQVB
M0M%<S1W*,DT8S;HQSY<#'(4>X(P?HOM7:_#W_CWT?_L9[_\`])IJYLO]V<HG
M7FKYJ<9M6U-73?\`CST/_L#ZK_Z-AKN?#?\`R*VD?]>4/_H`KAM-_P"//0_^
MP/JO_HV&NY\-_P#(K:1_UY0_^@"O5/#-2BBB@`KG_'/_`"(VM?\`7H_\JZ"N
M?\<_\B/K`[FV8#ZG@4`:A)_ME%W-M^SL=OFC'WA_!U)_VOP[U<JF0?[91MK;
M?L[#=Y0Q]X?Q]0?]G\>U7*!'/>./^12NO^NL'_HY*T*S_''_`"*5U_UU@_\`
M1R5H4#"BBB@#S+Q=J5C#XYDMM7\2ZOI-F+&-XA8S.H9RS9R%5NWM6M_:&GV_
MAG3K.VU74KZTU.1Q]MN!)+*8ADN,A<@D#:.,C)/:MB#3;M/'EYJ318LY-/CA
M63<.7#L2,9ST([5LW5K#>V[03IN1L'K@@CD$$<@@\@CI5J244OZW,N5N3?\`
M6R,Q?$6GHBHEMJ@51A0NDW.`/;]W45YXB46%T\%I?1S)$S(T]HZ(#CC)88JY
M;W4UG<)9:@^\N<076,"7_9;'`?\`0]1W`NW$$=U;2V\HS'*A1QGJ",&I>VAK
M!^\FS&UZUCL_!=_;QYVI;MR3DL>I)]23DGZU'X7MHKOP/8V\PS')!@X.".3R
M#V(]:K^(+Z2U\+W]GJ`<2B!E2XVY2;T.1PK>H..>F14?A:_DG\)6%IIZLUQY
M6UIBA\N'D\DGAB/[HS[X'-<MU[?Y?J>CRR^J?]O;_+<Z#1[B6ZT>UEG.Z8Q@
M2,/XF'!/XD9J]4-I;Q6=I#:PY\N%!&N3DX`[^]35T+;4X)M.3:V.3^'/_(HI
M_P!?5Q_Z-:MC7=>M/#]@+JZ661GD$4,$*[I)7/15'<UC_#G_`)%%/^OJX_\`
M1K4SQJ_]GW^@ZW-&[V-A=,;DJN[RU==H?'H#5RUG;S,HNT+^0QO&>JZ=LN/$
M'A:XT[3V8*UU'=)<",D\%U4`JOO^'>NQ5E=0RL&5AD$'((KCO%/BS0IO#=Y:
M6E_;:A=7L36\%M:R+*[NXP.!G'7O_.M*?3)1X&33)K#^T94LXXGM1/Y7FD``
MC?VZ=:;6E[6"+UM>YT%96N7^K6$,3:5HO]J.S$.GVI(-@]<MUK@=+\*^1JUG
M-_PK;[+Y<Z-]H_MW?Y6&'S;<_-CKCO7J1Z&E-**N@C)R_K_@'(^&?%NM>(FM
MY_\`A&/L^FS%@;O[>C[=N1]S`8\C%=&NKZ8^H'3UU&T:]!P;<3J9!QG[N<]*
MY+P0;D?"W-EG[4$N?)Q_?WOM_7%<-I=G-J&CV,,%UX+M[HNC)+)+)'?B4-GY
MB>=^[V(].,5?*G-K:Q#DXJ^^_P"![9%>6T\\T$5Q#)-`0)8T<%H\\C<.HS[U
MA77C+2[76+*T:[L_L=U#)(+TW2B,%"!MST)Y]>U<]XWCEN]95=%%PVHP6I_M
M/[*P!:U/\&2/OGDKCGK[4V_D\-S>(?#-Q.+$Z%)I\R0&Z5?*!&W`^;@$>_.:
MF,4[/^MG_2*E-JZ]/S7^>O\`5O0H9HKF!)H)4EBD&Y'1@RL/4$=17*_$W_D0
M[[_KI#_Z-2NFL6LVL83IY@-GM`B-N1Y>W_9QQCZ5S/Q-_P"1#OO^ND/_`*-2
ME'XD.7P/T.NHHHJ2S)\4?\BOJ7_7!JC\(_\`(J:?_P!<_P"IJ3Q1_P`BOJ7_
M`%P:H_"/_(J:?_US_J:Y?^8K_MW]3N_Y@?\`M[]#:HHHKJ.$*PO&?_(GZE_U
MR_J*W:PO&?\`R)^I?]<OZB@#KJ***`"BBB@`JD5_XG2-M_Y=V&[R?]H<;_\`
MV7\:NU18I_;L8S'O^S-QO;=C<O\`#TQ[]:!,=J5M>7-KLL;\V4X8,)/*60'_
M`&64]OH0>.M5],EUDR20:M:6F%7*W-K(=DGL4;E3^)'O60]UK$GQ"AT^'4U:
MPBMVNKJ!;91M4_+&A<Y.2=S=N%]ZZ#4=2M=)M#=7C2+$"%S'$\AR?903^E5;
MH).^ISFL_#_3;^&?^SF.ES/"D2K;`I`=CEU+QH5W8+'C/>O,/%6B:YIGBO4M
M0UE3+8R3+<1WJ0%8&;RD7+!2VS:5P`Q'KSQ7H_B;PY9^.=)34]#U(P7RKB"[
M@D*J^#]Q\>_X@_E2>$+3Q'X8\/Q1:O#/J32,9962Y,LT)/\`#M8X(&,_*V<D
M\&LZM&-6'*V;8?$RHU5-*YY)?*XC@U-)PX@R7,0X:(XW8/.<8!_X#77?#K'V
M31MIR/\`A)[[!SG/^C35T>L:)X%U*UGU#[0FDRHRK/+;GR'1F(`\V)AC))'+
MIGWJEHGP]UKPG#I:Z3J=KJEO:W\MVL%PAMAB2%X\F0>83C<.@&>:YL-A946[
MNYV8S'1Q,5968NF_\>>A_P#8'U7_`-&PUW/AO_D5M(_Z\H?_`$`5YK!JJZ0N
ME6VMPR:8\.E:E$9+K$:32-)$=L>3N;\N>V>:[[2M6TW2O"&CS:CJ%K9QFQAP
M]Q,L8^X/4UUGGG045S__``E]G<<:98ZGJ9[&UM&5#]))-D9_[ZK*UOQ1K^F1
M0RSZ9::;;S/L$T\C7+H?]J./:OY2'-)M+5DSG&$>:3LCM:YSQW+''X,U(.ZK
MOC"KN.,G<.![UD6EY8ZOS>^.9G'>&WVV*?@<>9_X_6_8^%O#]K+'>6^G6\TX
MY2ZF)GE^HD<EOUH33V%"I":O!W]"ZVS^WH_]7O\`LK?WM^-R_P#`<?K5ZJ9+
M?VRHW/M^SDX\T;<[A_!US[].W>KE44CGO''_`"*5U_UU@_\`1R5H5G^./^12
MNO\`KK!_Z.2M"D,****`"BBB@"*XMX;NW>">,21.,,IJA#<3:;,EI?2-)"Y"
MP73=23T1_1O0_P`73KUU*9-#%<0O#-&LD3J5=&&0P/8BF)HR_%/_`"*VI_\`
M7!JB\'G'A#32>,1?U-4?$3SZ9X>O[:=GFLWB*PSMRT9/1']1Z-^!YY9/#%S<
MW'A^QM+$HGEQ?OIW&[8220JCNV.>>!D=<XKE;MB/^W?U.^*YL$_\7Z%#P9XE
M_M7Q+K4#/E)G\^`?[*X3^6W\C7=5SFG6=^E]J[0ZG))(EVH*SQH4?]Q$>=J@
M@\XX/8<$YSM65W]KB;<GE31L4EB)SL8>_<$8(/<$5K3NE9F>*Y93YH*RLOR]
M$<Y\.?\`D44_Z^KC_P!&M76$`C!&0>HKD_AS_P`BBG_7U<?^C6KK*VG\3..'
MPHH6>AZ1ITYGL=+LK68C:9(+=$;'ID"K]%%3<JU@HHHH`AMK6WLH%@M+>*"%
M22(XD"J,G)X''6JLNA:/->_;9=*L9+K<&\][="^1T.[&<C`K0HHN]Q61#%:V
M\$LTL-O%'),VZ5T0`R'IEB.I^M5I-#TB6U^RR:58O;B0R>4UNA3>>K8QC/O5
M^B@=B.WMX+2W2"VACAA082.-0JJ/8#@5ROQ-_P"1#OO^ND/_`*-2NNKD?B;_
M`,B'??\`72'_`-&I51^)$3^!G74445)9D^*/^17U+_K@U1^$?^14T_\`ZY_U
M-2>*/^17U+_K@U1^$?\`D5-/_P"N?]37+_S%?]N_J=W_`#`_]O?H;5%%%=1P
MA6%XS_Y$_4O^N7]16[6%XS_Y$_4O^N7]10!UU%%%`!1110`54)?^UT&9-GV=
MN-Z[<[A_#US[]*MU2*_\3I&V_P#+NPW>3_M#C?\`^R_C0)F*_D^$DU/5+N1[
MV]U*]'EQQ(`\F<+%$HSSM']3Q4E[XFFDUB;1=$LDN]0@16G:>8110;AD;CRS
M'V4'ZBNB**Q4LH)4Y4D=#C&1^!-9^IZ%IFK[#?6B221\QS*2DD?^ZZX9?P-5
M==1-/H0>'-%DT6QN%GN%GNKNYDN[AT38GF/C(5<G```'Z]ZIWFMW^F>(+.WG
M-C<V-_<_9H5@W+/$VTL2P)(8#')&W&1UJ1?^$CMTU*\\J"Y=IU%I8&4*%A7@
MG?C[[\G!X''O61I]NL/BZ[\2W>DIHEG]D$4\EVT0:68N,/E20`!D9R-VX>E/
MU)>EDC0\9^"K7QG:6\%Q<O;&!]X>.-2QXQC)YQ[5)X1\-W_ABR-A-K3:A9H,
M0)+!M>+V#;CE?;''KVJ#7?%)MM6?1[6>VLYDB\Z:[O>$1,9/EKP96QSP<#OZ
M59\$G4I?#$%WJEU-/<7;-<+YP4,D;'*+\H`^[@_4FC7E!<KEIN5O$GBRRTJ[
MATZY@,<MQ/'"LUW&5MVC;'F,).G"Y&"0<X[5IZ5X:T#2Q'-IFEV43;1MGCC!
M<C''S]2,>]9D^L^'KGQ1Y=V\HN+;=8QM-$?LSN^PLH;&W?\`=7!(/48KJ(XT
MBC6.-%2-`%55&`H'0`>E)E1;;8ZH+NTM[^UDM;J)989!AD8<&IZ*D;2:LSA)
M?!FJ*'LH)-*EL=P\J>ZM]]PB_P!W.,''U_+I69:^%-7\+ZG'?+#/J$","18S
M>6W!'WDQ\P]A^=>G45FZ4;W.*67TFU)736QB:5JD&LWJW=M'.B+$\;"6VVE6
M##(+^O\`L]/RK;JB=G]O)_J]_P!E;NV_&X?\!Q^M7JT.R-TM=SGO''_(I77_
M`%U@_P#1R5H5G^./^12NO^NL'_HY*T*"@HHHH`****`"BBB@#(\4@'PMJ0(R
M#`V0:SO`#)_PBT2#_6)(V_\`$Y'_`(Z16EXH_P"17U+_`*X-6;X;LI'\-Z?=
M6DP@N?)VDLNY)`&.`PX/&3@@@C/X5RN_UG_MW]3T(6^I._\`-^AJZ7_R$-:_
MZ_5_])X:6T.[7M29/]6$A1O^N@#$_P#CK)6=IZ:O+?ZN@EM(`;M?,D16=@?(
MB^Z#@#C')SSG@UNVMK':0"*('&2S,3DLQ.22>Y)K=:G-4M'KNE^AS/PY_P"1
M13_KZN/_`$:U=97FOA7Q;9>']&;3K^SU);B.YF+!+1V',C$<_C6W_P`+'T;_
M`)]=5_\``)ZVE%MLY(3BHI7.OHKD/^%CZ-_SZZK_`.`3T?\`"Q]&_P"?75?_
M``">ER2[%<\>YU]%<A_PL?1O^?75?_`)Z/\`A8^C?\^NJ_\`@$]')+L'/'N=
M?17(?\+'T;_GUU7_`,`GH_X6/HW_`#ZZK_X!/1R2[!SQ[G7T5R'_``L?1O\`
MGUU7_P``GH_X6/HW_/KJO_@$]')+L'/'N=?7(_$W_D0[[_KI#_Z-2D_X6/HW
M_/KJO_@$]8/C+Q=9>(/#%QIEA9ZDUS-)%L#V;@'$BD\_04XQ=T3.<7%ZGIM%
M4[[4X-/\OSX[M]^<?9[26;&/78IQU[U3_P"$EL/^>&J_^"FZ_P#C=39EW0[Q
M1_R*^I?]<&J/PC_R*FG_`/7/^IK.\1^(+*;PY?QK!J09H6`+Z9<J/Q)C`'XU
M'X7\06<'AFQB>'4BRQX)33+AQU/0B,@_A7-RR^LWM]G]3MYX_4K7^U^AU]%<
MYJ?C;2]*T^2]GM]4,<>,_P#$MF3J<?>=54=>Y%68_%&GRQ)(L&JX90P_XE5R
M>OTCQ73RLX>9=S:K"\9_\B?J7_7+^HK7M;F.\MUGB654;.!-"\3<''*L`1^(
MK(\9_P#(GZE_UR_J*11UU%%%`!1110`50N2(-6LYVV!)$>`L6;.XE64`#Y?X
M6Y/L!UJ_3)H4N()(9-VR12C;6*G!&#@CD'W%`,?16=+_`&E:+F)K6XA#$DW$
MC1&-.,?,`V[`W')QGCW-(;V]RRI#IY;+JH-Z1DXS&/\`5_Q#D^G;=3L*YI52
MU'2K35?LPO%:2.WF$RQ[B%9ATW#^(`\X/<"HQ?W!8';8>460[A>'.PC&[&SK
MO^4#.".<@\4S[?>B/+0Z<'"98?;FP&#?O!GR^BCG..O!"]:+,+H9XDT&'Q)I
M#:;<,JPO)&SDH&)56!(']TD`C/;-4;#7[.PTV[EDM9;31K&86MO</O<NHX9B
M",J@;(W$D<9XK3-[>Y94AT\MEU4&](R<9C'^K_B')].VZE%_<%@2NG^464[O
MMA_U9&-V-G7?\H&<$<Y!XIZVL)[W1S?A.YMH/$-]HVDWZ:EI"PB[65763R)7
MD)*&0?>SRW.2/6NUK'AGGMH2([32H25W.J7A"[PV)/\`EGT5<'..3P0.M3&]
MO<LJ0Z>6RZJ#>D9.,QC_`%?\0Y/IVW4/5A'1&E16<+^X+`[;#RBR'<+PYV$8
MW8V==_R@9P1SD'BF?;[T1Y:'3@X3+#[<V`P;]X,^7T4<YQUX(7K2L.Z-2BLT
MWM[DJD.GELNH!O2,G&8Q_J^K#D_W>VZG_P"GW('S6T$)(W-&[2,ZE3G!PH4A
MNA^;('09X+!<6&3S]6G9'+101K$2LP*^822P*#D,!LY/9JO5'!`EO"L29PHQ
MECEF]R>Y]ZDI#.>\<?\`(I77_76#_P!')6A6?XX_Y%*Z_P"NL'_HY*T*`"BB
MB@`)`&2<"BHKCROL\AF8+$%)8DX`%>>6-_J-U>R21SW+>&FN=GG<!NF.,=$S
MP:SG4Y&E;<Z:.'=6+:=K?U]_D>C@@]"#]*6HX8HX8E2)0J#H!4E:',9/BC_D
M5]2_ZX-4?A'_`)%33_\`KG_4U)XH_P"17U+_`*X-4?A'_D5-/_ZY_P!37+_S
M%?\`;OZG=_S`_P#;WZ%ZSM7M[K4)7*E;FX$J8[`11IS[Y0_I5RBBNI'$VV[L
M****!!1110`4444`%%%%`!1110`4444`%%%%`&3XH_Y%?4O^N#5'X1_Y%33_
M`/KG_4U)XH_Y%?4O^N#5'X1_Y%33_P#KG_4UR_\`,5_V[^IW?\P/_;WZ#_%/
M_(LW_P#US_J*YG6=7U"P^(+7"7<G]F65I#]KM]QV%9)&4OCU7@YQT!KIO%/_
M`"+-_P#]<_ZBJ$.AS3^)_$,U]!FPOK:&",[A\X"L'&`<CKWKL3MKZGG25[KT
M_,R/&.KWXUNR2PNY(+33[NV^V>6Q'FM*V`AQU`7DCG[PKH/&?_(GZE_UR_J*
MQ-2\(WEMX'FTVRD:_P!0>YCN'E(6,R$.ISR<#"J!U[5M^,_^1/U+_KE_44.W
M+9=_\@C?FN^W^9UU%%%26%%%%`!56^FFCA$=L#]HF)2-MFY8S@G<PR,J.^#W
M`[U:JBZJVN0,54M';2;28CD99,X?H.@XZG\*$)CDTNUW>9-$MQ*2YWS?.5W8
MW!=V=JG`^4<5+]CM0VX6T.00P/ECJ!@'\!Q4]%`[%?[!9[=OV2#;@+CRQT!R
M!],\TIL;0YS:P'.[/[L<[OO?GW]:GHHN%B#[':AMPMH<@A@?+'4#`/X#BN6\
M0ZP+/4[?P_H.CVE[K$\>[;*H6&VB!X>3'.,]%'\\`]A7$17L&D_%:_COW$7]
MJ6</V260@*S(2&C!]22#BG'5V)EHKE_1+;Q']NDC\0Z;H+6[QLR3:>'^5B1N
M5E<9.X'J/[O/45T/V.U#;A;0Y!#`^6.H&`?P'%2&6,2K$742,"RH3R0,9('M
MD?G3Z&[C2L5_L%GMV_9(-N`N/+'0'('TSS2FQM#G-K`<[L_NQSN^]^??UJ>B
ME<=B`6=J&#"VA#`A@?+&<@8!^H'%0G2K+<&B@6"0!5$D`\MMH;<%R/X<YXZ<
MGUJ[11<5D5K.6=Q)%<K^^B8*TBQE$DR`<KDGCG'7J#5FJ.U%UX,!&'>UPQV-
MN(#<?-]W'S'CKS5Z@$<]XX_Y%*Z_ZZP?^CDK0K/\<?\`(I77_76#_P!')6A0
M,****`(+VTCOK*:UE_U<R%&^AJ*STRVL])CTU$#6Z1^7@CJ.]7**5E>Y7/)1
MY;Z;F%K/A2PULVYN9;E/(38OEN!D>^0:R_\`A6VC_P#/S?\`_?Q/_B:L3>)(
M]/\`'-S8:CJ=M:V(L(Y8EG=(P9"[`X8X)X`XS3M(\0?VKXRU*UM=0@NM.AM(
MGC\AD=0Y+;OF'T'&:RE@Z51\THWN;0S&O2CR1FTE^O\`PYCZSX#TO3M&N[R&
MXO&DAC+J'=2"1Z_+3-"\"Z7J>B6M[-/>+),FY@CJ`.3TRM=9XH_Y%?4O^N#5
M'X1_Y%33_P#KG_4UQ_5:/UCEY=+?J>C]?Q/U3GYW?FM^!D?\*VT?_GYO_P#O
MXG_Q-'_"MM'_`.?F_P#^_B?_`!-=C171]2P_\J.3^TL7_P`_&<=_PK;1_P#G
MYO\`_OXG_P`31_PK;1_^?F__`._B?_$UV-%'U+#_`,J#^TL7_P`_&<#J?@KP
M]I-H;FZN=3\L=3&`_P#)./QKG=)MO"^K:C+;I_:\4*1[A(Q5V8Y`QM5#CZYK
MV"J9M=/L99M1^SP0R",^;,J`$J.3DCKTJ98*C?2*-J>:5E%J<FWTU_X!P_\`
MPBWA;_G[U?\`[\-_\:H_X1;PM_S]ZO\`]^&_^-5+X</BG6-3N;Y[BXL=*N)#
M(H8)OQC"A0ZMQC&>@/:NNAGN;.ZBM;V59DFR(;@+M)8#.U@.,XR01C.#P.\Q
MPM"2OR?A_P`$UJXO$4Y<OM&WY/\`X!R%OX.\-74ZPQ7>JEVZ;HBH_,QXJ_\`
M\*VT?_GYO_\`OXG_`,378UB^(?$<6A);Q):S7M_=L4M;2`?-(0,DD]E'<]JT
M6"H?RHY99GB=U-K^O0R/^%;:/_S\W_\`W\3_`.)KF=?TWPKH$A@EDU>6X[(H
M51_WTR`8^F:[;2-:UZ[U%;;5?#$FG0LC,LZWB3KD8X.T<9S6[/;P741BN(8Y
MHSU210P/X&E/`T;:115'-:_-><FU]WZ'FNG:!X9O=.@N9)M5B>5`Q14+A?;<
M(L&K7_"+>%O^?O5_^_#?_&JZZ-9'+6.EE+2TMOW;2J@8Y_NH#QQW)SZ8ZXY7
M79/%&BZY:7\D\][H]O+N;:%W!2,-O"*O8G'!`K-X6C%:P7]?,ZH8NO5FTJC7
M97^Y;?J1_P#"+>%O^?O5_P#OPW_QJKEKX!T&\B\V&ZU(IG'SX0_DR`UVR.LB
M*Z,&5AE2.A%.K18*A_*CDEF6)Z3?W_\``.._X5MH_P#S\W__`'\3_P")KH%T
M6T72H-.5KE((<;3%<R1.>O5D(/?ITK1HK:G0ITG>"L<];%5JZY:LKHYS4_!.
MEZKI\EG/<:J(Y,9_XF4S]#G[KLRGIW!JS'X7L(XE07&JX4`#_B:W(Z?23%;5
M%;<S.7E78AM;:.SMU@B:5D7.#+*TK=<\LQ)/XFLCQG_R)^I?]<OZBMVL+QG_
M`,B?J7_7+^HI%'74444`%%%%`!5%B/[=C7<N[[,QV^:<_>7^#IC_`&OPJ]50
M[_[83_6;/L[?W=F=P_X%G]*`9;HK&\2ZI=Z996WV%8#<W-U';(TZED3=GYB`
M03C'3(K-.DZO=_\`(1\27A4]8K&-+9#^/S2#_ON@#IKBZM[.%IKJ>*")>KRN
M%4?B:PV\;:(YVV$TVIMV_LZ!YU_[[4;!^+"J\'A70X9EG.G1W%PO2>[+7$H_
MX'(6;]:U))8K>/?+(D:#^)F``H!:F<=<\07?%EX?2U4_\M-2NU5A[[(@^?H6
M6J5M:OXFO=5T3Q5!IVH16\<$T1AMVBV>9Y@(!+LV1L'S`CJ:VK6_M+Y7:TN8
MIPAVL8W#8/X52T3GQEK[>D%HO_HT_P!:2::NAM-.S)]"\%>'O#5U)=:3IJV\
M\B;&<RNYVYS@;B<=NE;]<SJFHZQ/XCET?3+BTM(X;.*YDGFMS,[;WD4!1N4#
M'E]3GKTJ%O#SW7_(3UO5KW/5/M'V=/IMA"9'L<U3;>Y*26QNZCK>E:0H;4M2
MM+,'[OGS*A;Z9//X5EMXQMIN-,TS5=1)Z-%:F)#]'FV*1]":=I^A:3I3E[#3
M;6WD;[TD<0#M[ENI/U-3W6H6=BNZZNH8!_TT<+G\ZEM)792BY.R*37_BJ\_U
M-GI>FH>CW$KW+_BB[`/^^S6CX8U&XU;POIFH7>S[1<6Z22>6NU=Q'.!DX_.G
MQR)-$LL3J\;@,K*<@@]Q5'P+_P`B+HO_`%Z)_*F+8U"W_$Z1=W_+NQV^=_M#
MG9_[-^%7:J$/_:Z'$FS[.W.Q=N=P_BZY]NE6Z!(Y[QQ_R*5U_P!=8/\`T<E:
M%9_C=7;PC>;(Y)"KPN5C0NV!*A.`.3P#TJG_`,)=I'K??^"ZX_\`C=`S<HK#
M_P"$NTCUOO\`P77'_P`;H_X2[2/6^_\`!=<?_&Z`-RBL/_A+M(];[_P77'_Q
MNC_A+M(];[_P77'_`,;H`S9=#@U'XAW<^HZ5'=6@TZ)8Y+BW#Q[][9`+#&<4
M[1M'CTSQYJC6FG+:6+V4(0PP>7&S;FSC`P3TS6A_PEVD>M]_X+KC_P"-T?\`
M"7:1ZWW_`(+KC_XW5*31+@F7M9LWU#1;RTC95>6)E4MT!]ZS_#\UO8>&+='N
MX)%MDVR2(V5!ZD?K2MXLT=E*M]N((P1_9UQ_\17!7=E8OJ7EVUU?)ILC!G4Z
M?<9'7C[G/7]:YJD6I\\5=[$8C$XB%)4Z4>97O\]E\NYZ#H>OKK4MR$MWC2(C
M:Y.=P/\`(ULUS-AX@T+3[5;>W6^2-?\`J'7&2?4_N^M6O^$NTCUOO_!=<?\`
MQNM8J27O;E4U-12F[LW**P_^$NTCUOO_``77'_QNC_A+M(];[_P77'_QNJ+-
MRD95=2K*&4]01D5B?\)=I'K??^"ZX_\`C='_``EVD>M]_P""ZX_^-T`;E9FJ
M_OKBPM8S^]-PLQQU5$.6/TZ+_P`"K%DU?1#*TEO=ZQ:ER6=8+&X"L3U.#&0"
M?48J>TU_0;/>T?\`:+2/]^62PN7=O3)*9Q[=!4N[T-$XQ]Y,Z:N,\0746A^.
M]*UB_P`II\MJ]F;@C*PR%@P+'L#TS6O_`,)=I'K??^"ZX_\`C=1S>)]#N8'@
MGCNY89%*O')IEPRL#U!!CY%4G9W,FKJQ"?%MM<^*]*TO3+RPO+>YCF:=H91(
MR%5!7E3@9YZBNFKD[/4?".GS^?9:7]FFQM\R'19D;'ID1UH?\)=I'K??^"ZX
M_P#C=-VTL*-];EC1OW(O+1^)H[F60CNRR.SJWTP<?\!([5J5S%WKV@WA5W.I
M1S)]R:*PN4=1Z9"=/8\5'#K.BI*DLUUK%TZ'*>?8W&%/KM$8&?<BH5UH;2<9
M/F;.J50JA5`"@8``X%+6'_PEVD>M]_X+KC_XW1_PEVD>M]_X+KC_`.-U1F;E
M%8?_``EVD>M]_P""ZX_^-T?\)=I'K??^"ZX_^-T`;E%8?_"7:1ZWW_@NN/\`
MXW1_PEVD>M]_X+KC_P"-T`;E87C/_D3]2_ZY?U%+_P`)=I'K??\`@NN/_C=9
M/B7Q!8ZEX=O+*T2_EN)D"1I_9\XR<CN4Q0!Z'1110`4444`%46`_MV-MJ[OL
MS#=Y1S]Y?X^F/]G\:O529A_;D:[ES]F8[?..?O+SLZ?\"_"@3,CQA_JM&_["
ML'_LU1>)]8ET/1FO(8DDDWA%#YQSWXJ7QA_JM&_["L'_`+-61\0O^17/_7=/
MZUCB).-*4H[I'5@X1J8B$9*Z;146S\::LH>;4+>PA<`[8OO8/IC)_P#'JEB^
M']K)()=3U&[O9>Y+8!_/)_6NJM/^/*#_`*YK_*IJSCA*;5YWEZLVECZT6U3M
M%>22_'<XKP'%';W^O0PC$4=P$09SP"X%=!H7_(X>(/\`KE:_RDK!\#?\A/Q!
M_P!?0_F];VA<^+O$)[".U'X[7/\`44\'_!7S_-BS)MXF5_+\D,/_`"4/4/\`
ML$VG_HVXK/\`$&N:M!KMKHNCV\+W%Q%Y@>4]/O9QR!P%)YK0/_)0]0_[!-I_
MZ-N*RKK_`)*SHW_7HW_H,M&*E)12B[7:7WBP,8N<G)7M%O7R1%!X?\0ZR[B^
M\3I"5^_#:\X'OC;[^M5=7\&:)IWA_4;J*YFO+R"/)=Y.%;(&<#\>"33]7M)_
M%OB>YBT%C9+IJM'/=AW59W.,Q@*1QQR>OZ5LZU+;GX;W@AMQ;A(Q&\(_@<,`
M1^?>N5T:;A)R5[)ZMMGHJO5A.FHRM=J\4DK7[V[_`/#EKPO_`,BOIO\`UP6I
MO`O_`"(>AG^]91L/H5S47AG_`)%G3?\`KW7^52^!/^1`\/\`_8/@_P#0!7?1
M_AQ]$>/B/XT_5_F:;!/[=C.(]_V9N=C;L;E_BZ8]NM7JI%O^)TB[O^7=CCSO
M]H?\L_\`V;\.]7:T,$%%%%`PHHHH`****`"BBB@`HHHH`****`"BBJ.K:I;Z
M1ITMY<,`J#@?WCV%*4E%7>Q48RG)1BKMCKW5;#3O^/R[A@R,@.X!-94WC?P]
M;KN?48\>J@G^5>2ZOJMWKVI-<SY9CPB+SM'H*Y#4[MIIFA`*K&Q!![FO'695
M*DVJ:T/IJ60TU%>UD[^1]4HZR(KH0589!'<5PGQ%^(T7@JWCMX;<SZA<*3$&
MX10.Y/X]*UO`&K#6/!MC,3F2)?)D^J\?RQ7DOQ]_Y#^F?]<7_FM>W0M4LSY;
M%QE1<H]4['MGAR]FU+PWI][<$&:>!9'(&!DBM2O-=#^)GA/1?"FEV]WJJ&:.
MV172)"Y4XZ'`XKJ/#_CGP[XGE:+2M1268#/E,I1\>N#S0XOL3&<6DKG145G:
MSKVF>'[/[7JEY';0YP"YY)]`.]<:WQJ\&B3:+NX*_P!X6[_X4*+>PW.*W9Z$
MS!$9FZ*,FO,-)^*,GB/XBV^B:?;^5IZ>8)))!\\A4=O05U^C^+]#\4V=R=(O
M5G,<9+J5*LHQW!YKY^^'VHV>E?$TWE]<1V]O&TY:21L`=:N$=[F52IJK/0^H
MJ*X:/XO^"I+D0#564DXW-`X7\R,8]Z[*TO+>_M8[FTF2:"0921#D$5FTUN:J
M47LR>BJUUJ%K9#-Q,J$]!W/X51'B73LX\Q\>NPTBC7HJL]_;I9B[:3$)&0V*
MSSXFL,\&0CUV4`;-%5+/4K6^SY$H8CJIX/Y5/-/%;QF2:144=V-`$E92:G)+
MKQL0H6-`<GN3BE_X2'3=VWSS_P!\'%9EA+'/XLEDB8,C`D$=^*`.GHHHH`*J
M-O\`[7C_`-9L\ANR[,[E[_>S^E6ZHR`+KENY5<O;R(&$1+<,IP7Z`=>#U_"@
M3,GQA_JM&_["L'_LU9'Q"_Y%<_\`79/ZUJ^-)8X;72)976.-=4@+,QP`/FZF
MJD_B;0;^-K:$G6%)PT=E;-=ID'H2H*CG^\16=:'M*<H+JC?#551K1J/H[F8O
MCZS6&*WL;&[O)U0+M5<`\8]SU]J/[3\9:EG[)I<-C&>C3_>'Y_\`Q-:UO+KD
MD8CTSPS%8P]C?W*1`#U"1!_R.W\*L#0=>N^;[Q$+=3_RSTVT6,_0M+YA/U`6
ML51J/XY_=I_FSH>)H1=Z=)?-M_AHBEX7T*XT..]FOKF*6>Y<22%.%&,G.2!Z
MGM5CPO=6]YXE\1S6L\4\0>W3?$X9=PCY&1W&1Q5I/!.A%@][:OJ3@YW:C,]R
M,^H5R57\`*W88(K>)8H(DBC7A410H'T`K>G3C3BHQV.6M5E6FYSW9S1_Y*'J
M'_8)M/\`T;<5SVO:E;Z/\1],O[K<((K0[MHR>?,`_4BM?4-4T_2O'VH3:A?6
MUI&=*M<-/*J`_O;CIDTV;6-,U.5'M-#O-8D4822.QPN/]F67:GY-6=>E*I%*
M+LTT_N-L+6C1FW-7337WE*'QNFZ9?#WAZZN&F8NSOP-Q[D#/'XBHKRW\8^(;
M6:VN8;'3[:<@R*.KXQU^\>P]*WE7Q5=@"&QTS3(^@:YF:X<?6-`J_E)4@\+W
MESSJ?B+4)@>L5H%M8_P*CS!_WW6?U:4E:<W;RT1M]=A!WI4TGW=V_P#+\!UM
M]ET#1+:&\O(8H[>)4::5PBG`Z\FG^!?^1`\/_P#8/@_]`%36?A+0+&83Q:5;
MO<+TN)QYTO\`W\?+?K6U74DHJR."4G)N3W94(;^V%.)-GV<C/EKMSN'\77/M
MTJW5`;'UYR%3?%;*&.QMP#,<`-]W'R'CKT]15^F2@HHHH&%%%%`!1110`444
M4`%%%%`!1110`V1UBB>1ONHI8\=A7A7B_P`<0:YJ)\N1OLD1Q$H!Y]S7NSKO
M1E]1BOF;6/#]QI>M7<-S"T2+,_E@C&Y<G!^F*\[,=8)-Z'O9#&FZLI/XEM^I
MZO\`#C0()-.CUR="7FSY*MV7U_.N`^)OA[^RO%DDMLG[F[7S@!V;O_C^-48_
M%6M:/;1I9:C/$B8")G*@#M@U;?5M6\=:A9QRQ(]T!Y2^6,`]\GTKD52FJ"C3
MCJ>I##XBGBW7J23B[_)=#J/@Q>7$<NH:=)&WE%1*I(X!Z$5SGQ]_Y#^F?]<7
M_FM>S>&?#MOX<TI;:(;IF^::3NS?X5XS\??^0_IG_7%_YK7MX*,HQ2EN?)9O
M6A6JRG#9G0>#O@[X>N_#EI?ZFUQ<SW40D(5]BIGL*\WOK'_A"?BLMKITLFRU
MNT\IF/.UL<'\R*^C/!G_`")FC_\`7JG\J^?_`(A?\EBF_P"OF'_V6NF$FY-,
M\^K",8)HU/CG-._C:S@G9Q9I;J4`[9)W8]^!6[9:=\'3IT*R7,+2%!N:29@^
M<=^PKMO'FE>#]9:UL_$EU':W#`FWD,@1\=\$]?I7"ZG\*_!-KI5Q=1^(60I&
M65FF0C...*2DG%(<H-2;5F=MX.\+^&='BO\`4?#5Z;B"YB*,!*)%7'/!%>$^
M$_#UKXG^()TN\>1())968QD`\$FN@^"5Y=1^)KVTC9C;2VCF1>V0.#6;\.[Z
MTT[XHK<WMQ';PB28&21L`9SWJTFFR&U)1T/0?%_P<T"T\,7EWI/VB*[MHS(N
M^3<'QV/%9WP&UN?&JZ3(Y:&*,7$8)^Z<X(%=GX_\=:'8^$;Z.#4;>>ZN(C'%
M'$X8DGOQVKAO@+I4SS:QJ)0B%H1`K'NQ.>/RJ+MP?,7:*JKE/3-&M%U:\GO+
MKYPK<*?>NB^P6>W;]EAQ_N"L'PW.MK<7%E,=KEOESWQ73U@=17EAM5M?+E1!
M`O.&Z"L]M1T1#L_<>G$8(_E53Q3(VVVBW$1LV6QWK0M])TT6R8AC<;0=Q/6@
M#"\RV3Q';O8,/*9AD+T]ZLWB'5?$?V1V(AB'(!_$U7N8[6+Q);):A0@9<A3G
MFK+.+#Q8SR\)-T)Z<BF!MC2[$)L%K%C_`':PK"&.W\5RQ1+M10<#TXKJ`<C(
MKF[7_D<)OH?Y4@.DHHHH`*@N[874(7=MD1@\;Y/RN.A(!&1ZC//2IZ*`,JZ=
M7@\C5=--T@D4`K!YJ.>/GV<E1DGKTQU[U/\`VC#&I5;:["H),!;5_P"#TX[]
MO7M5ZB@6I4&HQF0)Y-UDN$S]G?'*[LYQT[$]CQ3!JL10/]GO<%%?!M9,_,V,
M8QU'4CL.:O44!J4FU.)0W[B\.WS.ELYSLZXX[]O7M3AJ,9D">3=9+A,_9WQR
MN[.<=.Q/8\5;HH#4RC<:?).E\^G3FX6)=LK6+>8JLQ&W.W(P<DCL#FK#:G$H
M;]Q>';YG2V<YV=<<=^WKVJ[10&I4&HQF0)Y-UDN$S]G?'*[LYQT[$]CQ3!JL
M10/]GO<%%?!M9,_,V,8QU'4CL.:O44!J4CJ42Y_<7?'F=+9S]SKV[]O[W;-#
M7LLAV6UK,6)`,DB;%3*[@2"02!P"!SD^QJ[10!7L[8VT3;W+S2-OE;+;2^`#
MM!)VCC@9XJQ110,****`"BBB@`HHHH`****`"BBB@`HHHH`*J7^FV6J6Y@O;
M:.:,]G'3Z>E6Z*32:LQJ3B[H\VU3X/V%[<[[749K>+M&4#8^AK?\'^!K/PFD
MK),;FXD/^M=`"H]!7545E'#THNZ1UU,?B:D/9SG=!7!>._AI%XWO[6Z?4GM#
M`A3:L0;.<>X]*[VBMTVG='#**DK,I:/IPTG1[33Q(9!;1+&'(QNQWQ7!:_\`
M".'7?%SZ^VK20LTB/Y(A!'RX[Y]J]*HIJ33N@<(R5F<=XY^'ECXX^S/<W<UM
M-;*RHT8##!QG(/TKA!^S[%YG.OOL_P"O?G^=>V44U.25D3*E"3NT<IX1\`:1
MX.M)H[,/+<3KMEN)/O,/0>@KC[_X#:3=7,LT.KW4)D8M@QJ^"3GVKUNBDIR3
MO<;IP:LT>/V?P`TN*8-=:S<SQ@_<6()G\<FO4=(T>QT+38[#3H%AMX^BCN?4
M^IJ_10YREN$:<8[(S-0T2VOY/-),<O=E[U3_`.$=GZ'4YMOX_P"-;]%264)-
M*@GT^.TF+.$'#]\^M9X\,X^7[?-Y?]T#_P"O6_10!CKX=M8I[>6%F5HFR<\[
MJMZAIEOJ,8$H(9?NN.HJ[10!@#P].HV+J<P3L.?\:M:?H<5C<_:/.DDDP1DU
*JT4`%%%%`'__V9?N
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
        <int nm="BreakPoint" vl="1101" />
        <int nm="BreakPoint" vl="1098" />
        <int nm="BreakPoint" vl="1114" />
        <int nm="BreakPoint" vl="1523" />
        <int nm="BreakPoint" vl="1577" />
        <int nm="BreakPoint" vl="2084" />
        <int nm="BreakPoint" vl="677" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22653: Add property &quot;Clear tool diameter&quot;" />
      <int nm="MAJORVERSION" vl="8" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="9/10/2024 10:51:38 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17910 bugfixes on arced segments and if defining polyline is within plane of zone" />
      <int nm="MAJORVERSION" vl="8" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="2/9/2023 1:30:59 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17081 circle tests improved" />
      <int nm="MAJORVERSION" vl="8" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="1/10/2023 2:37:56 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16660 contour test improved (accepting multiple self interscting rings)" />
      <int nm="MAJORVERSION" vl="8" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="10/26/2022 3:42:27 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16822: Fix intersection point failing when line parallel with plane" />
      <int nm="MAJORVERSION" vl="8" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="10/19/2022 3:11:13 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15660: add description for zone explaining meaning of 99 and -99" />
      <int nm="MAJORVERSION" vl="8" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="7/1/2022 8:51:44 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13220 TSL selection as defining entity supported if defining contour published" />
      <int nm="MAJORVERSION" vl="8" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="9/20/2021 4:08:51 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-10705 defining polylines or circles are projected to the zone if not parallel with zone. Projected arcs will be approximated." />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="2/10/2021 3:22:06 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End