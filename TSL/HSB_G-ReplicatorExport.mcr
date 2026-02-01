#Version 8
#BeginDescription
#Versions:
3.4 08.02.2023 HSB-17874: dont break loop when removing element for reassignment. It can be found in many copies 
3.3 31/08/2022 Make sure an element can only be included once in a single export Author: Robert Pol
3.2 03/08/2022 Do not set dim style on elementinfo tsl Author: Robert Pol

Export elements with correct amount
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 4
#KeyWords 
#BeginContents
// constants //region
/// <summary Lang=en>
/// Export elements with correct amount
/// </summary>

/// <insert>
/// select elements
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="3.01" date="02-04-18"></version>

/// <history>
/// RP - 1.00 - 10-03-17 -  Pilot version.
/// RP - 1.01 - 13-03-17 -  Set Map correctly.
/// RP - 1.02 - 15-03-17 -  Wrong propertie index and set calalogue.
/// RP - 1.03 - 18-03-17 -  Do not add all groups and sort exports on alphabeth
/// RP - 1.04 - 21-03-17 -  Collect all entities from group instead of only genbeam
/// RP - 1.05 - 09-05-17 -  Get the elements from mapX instead of subType and repeat insert
/// RP - 1.06 - 12-07-17 -  Use the already stored project X map
/// RP - 1.07 - 28-07-17 -  Mapx for mainelement was not set witch resulted in wrong quantity, do more clear map structure
/// RP - 1.08 - 28-07-17 -  Use map from exportinformation to export 
/// RP - 1.09 - 31-07-17 -  Set amount according to current delivery
/// RP - 1.10 - 31-07-17 -  Also set the rest of the amounts to 0, recalc the information tsl
/// RP - 1.11 - 31-07-17 -  Set the properties according to the replicator export if new export is created
/// RP - 1.12 - 02-08-17 -  Small change for display of exportinformation tsl
/// RP - 1.13 - 14-08-17 -  Set string for exportgroup in _bOnInsert
/// RP - 1.14 - 13-09-17 -  Allow repeat on insert and get the correct map.
/// RP - 2.01 - 11-10-17 -  Make option to select entities
/// RP - 3.00 - 10-01-18 -  Change MapX values because of rework to replicator tsl
/// RP - 3.01 - 02-04-18 -  Add amount lock as custom action
// #Versions
// 3.4 08.02.2023 HSB-17874: dont break loop when removing element for reassignment. It can be found in many copies Author: Marsel Nakuci
//3.3 31/08/2022 Make sure an element can only be included once in a single export Author: Robert Pol
//3.2 03/08/2022 Do not set dim style on elementinfo tsl Author: Robert Pol
/// </history>
//endregion

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
//endregion

String categories[] = 
{
	T("|Delivery|"),
	T("|Export|")
};

String arGroups[] = ModelMap().exporterGroups();
  
for(int s1=1;s1<arGroups.length();s1++){
 int s11 = s1;
 for(int s2=s1-1;s2>=0;s2--){
  if( arGroups[s11] < arGroups[s2] ){
   arGroups.swap(s2, s11);     
   s11=s2;
  }
 }
}
arGroups.insertAt(0, ""); // add empty string
PropString pGroup(0,arGroups,T("|Exporter group|"));
pGroup.setCategory(categories[1]);
pGroup.setDescription(T("|Select the group that needs to be exported. If empty the single export is used|"));

String arShortcuts[] = ModelMap().exporterShortcuts();
for(int s1=1;s1<arShortcuts.length();s1++){
 int s11 = s1;
 for(int s2=s1-1;s2>=0;s2--){
  if( arShortcuts[s11] < arShortcuts[s2] ){
   arShortcuts.swap(s2, s11);     
   s11=s2;
  }
 }
}
arShortcuts.insertAt(0, ""); // add empty string
PropString pShortcut(1,arShortcuts,T("|Single export|"));
pShortcut.setCategory(categories[1]);
pShortcut.setDescription(T("|Select the single export that needs to be exported. If empty the group export is used|"));

PropString deliveryName(2, T("|New delivery|"), (T("|Delivery name|")));
deliveryName.setCategory(categories[0]);
deliveryName.setDescription(T("|Sets the delivery name|"));

PropString deliveryDescription(3, T("|New description|"), (T("|Description name|")));
deliveryDescription.setCategory(categories[0]);
deliveryDescription.setDescription(T("|Sets the delivery description|"));

PropString onlySelection(4, sNoYes, (T("|Use unique elements|")));
onlySelection.setCategory(categories[1]);
onlySelection.setDescription(T("|If this is set to no, the replicated elements are checked. If set to no, or not set, the selected elements are exported|"));

PropString export(5, sNoYes, (T("|Export|")));
export.setCategory(categories[1]);
export.setDescription(T("|If this is set to no, the exporter will not run, only the delivery is created|"));
			  
// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_G-ReplicatorExport");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);
else
{
	setPropValuesFromCatalog(sLastInserted);
}

if(insertCycleCount() != 1 && export == T("|No|") && !_Map.hasMap("Element[]"))
{ 
	eraseInstance();
	return;
}

if (_bOnInsert || _bOnDebug || _Map.hasMap("Element[]") || _Map.hasMap("Entity[]"))
{
	Element elementsToUse[0];
	Entity entitiesToExport[0];
	// mapX on project
	Map subMapProjectX;
	int selectionAreElements = true;
	String strDestinationFolder = _kPathDwg;
	String strExportGroup;	
									
	if((insertCycleCount() == 1 && !_Map.hasMap("Element[]")) || (onlySelection == T("|Yes|")) && !_Map.hasMap("Element[]") )
	{
		Entity selection[0];
		
		PrEntity ssE(T("|Select a set of elements|") + T(" |or <ENTER> to select entities|"), Element());
		if (ssE.go()) 
		{
			if(ssE.set().length() ==0)
			{
				PrEntity ssEBm(T("|Select entities|"), Entity());
				if (ssEBm.go()) {
					selectionAreElements = false;
					selection.append(ssEBm.set());
				}
			}
			else
			{
				selection.append(ssE.set());
			}
		}

		if (selection.length() < 1)
		{
			eraseInstance();
			return;
		}

		if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
			showDialog();
		setCatalogFromPropValues(T("|_LastInserted|"));
		
		strExportGroup = pGroup;
		if (strExportGroup == "")
	  		strExportGroup = pShortcut; 
	  	
	  	Map projectMapX = subMapXProject("Delivery[]");
		
		Entity allEntElements[] = Group().collectEntities(TRUE, Element(), _kModelSpace);
		for( int i=0;i<allEntElements.length();i++ ){
			Element el = (Element)allEntElements[i];
			Map productionMap = el.subMapX("Hsb_production");
			Map replicatorMap = productionMap.getMap("Hsb_replicator");
			int amountLocked = replicatorMap.getInt("AmountLocked");
			if( el.bIsValid() && ! amountLocked){
				el.setQuantity(0);
			}
		}

		for(int q=0;q<selection.length();q++)
		{
			Element thisEl = (Element)selection[q];
			Entity thisEnt = selection[q];
			
			for (int i = 0; i < projectMapX.length(); i++)
			{
				Map thisMap = projectMapX.getMap(i);
				String mapDeliveryName = thisMap.getString("DeliveryName");
				String mapDeliveryDescription = thisMap.getString("DeliveryDescription");
				String deliveryDate = thisMap.getString("DeliveryDate");
				String deliveryExportGroup = thisMap.getString("DeliveryExportGroup");
				String deliveryUser = thisMap.getString("DeliveryUser");
				String deliveryOnlySelection = thisMap.getString("DeliveryOnlySelection");
				String exported = thisMap.getString("Exported");
				int breakOut;
				for (int m = 0; m < thisMap.length(); m++)
				{
//					if (breakOut) break;
					Map elementMap = thisMap.getMap(m);
					if(thisEl.bIsValid())
					{ 
					
					// HSB-17874: element is selected
					// delete the whole element element map if same number 
						Map numbersMap = elementMap.getMap("Number");
						String elementNumber = numbersMap.getString("Number");
						if(elementNumber==thisEl.number())
						{ 
							thisMap.removeAt(m,false);
							projectMapX.setMap(thisMap.getMapName(), thisMap);
							continue;
						}
					}
					
					Map entitiesMap = elementMap.getMap("Entity[]");
					Map quantitiesMap = elementMap.getMap("Quantity");
					Map numbersMap = elementMap.getMap("Number");
					int quantity = quantitiesMap.getInt("Quantity");
					for (int e = 0; e < entitiesMap.length(); e++)
					{
						Entity entity = entitiesMap.getEntity(e);					
						if (entity != thisEnt) continue;
						thisMap.removeAt(m, true);
						// HSB-17874: dont break bc it might already be found in more then 1 group
						// make sure to cleanup everywhere
//						breakOut = true;
						projectMapX.setMap(thisMap.getMapName(), thisMap);
//						break;
					}
				}
				// // HSB-17874: dont break;
//				if (breakOut)
//				{
//					break;
//				}
			}
			
			if (thisEl.bIsValid())
			{
				_Element.append(thisEl);			
			}
			else if(thisEnt.bIsValid())
			{
				_Entity.append(thisEnt);
			}
		}
		
		setSubMapXProject("Delivery[]", projectMapX);	
		
		Element mainElements[0];
		int quantities[0];
		// export all elements if onlyselection propertie is true
		if (onlySelection == T("|No|"))
		{	
			for (int a=0;a<_Element.length();a++)
			{
				int replicatorType = 0;
				Element el = _Element[a];
				TslInst tsls[]= el.tslInst();
				for (int index=0;index<tsls.length();index++) 
				{ 
					TslInst tsl=tsls[index]; 
					if (tsl.scriptName()=="HSB_E-Replicator")
					{
						replicatorType=1;
						break;
					}
					else if (tsl.scriptName() == "HSB_E-Replica")
					{
						replicatorType=2;
						break;
					}
				}
				
				if (el.subMapXKeys().find("Hsb_Production") != -1 && el.subMapX("Hsb_Production").hasMap("Hsb_replicator") && replicatorType == 0)
				{
					Map productionMap = el.subMapX("Hsb_Production");
					productionMap.removeAt("Hsb_Replicator", true);
					el.setSubMapX("Hsb_Production", productionMap);
				}
				
				if (el.subMapX("Hsb_Production").getMap("Hsb_replicator").getInt("IsReplicator"))
				{
					if (mainElements.find(el) != -1)
					{
						int mappedQuantity =_Map.getInt(el.handle()) +1;
						Map productionMap = el.subMapX("Hsb_production");
						Map replicatorMap = productionMap.getMap("Hsb_replicator");
						int amountLocked = replicatorMap.getInt("AmountLocked");
						if ( ! amountLocked)
						{
							el.setQuantity(mappedQuantity);
						}
						
						_Map.setInt(el.handle(), el.quantity());
					}
					else
					{
						mainElements.append(el);	
						int mappedQuantity =_Map.getInt(el.handle());
						Map productionMap = el.subMapX("Hsb_production");
						Map replicatorMap = productionMap.getMap("Hsb_replicator");
						int amountLocked = replicatorMap.getInt("AmountLocked");
						if ( ! amountLocked)
						{
							el.setQuantity(mappedQuantity);
						}
						_Map.setInt(el.handle(), el.quantity());
					}
					
					continue;	
				}
				
				if (el.subMapX("Hsb_Production").getMap("Hsb_replicator").hasInt("IsReplicator") && !el.subMapX("Hsb_Production").getMap("Hsb_replicator").getInt("IsReplicator") && !el.subMapX("Hsb_Production").getMap("Hsb_replicator").getInt("IsMirrored"))
				{
					Map subMapX = el.subMapX("Hsb_Production");
					Entity replicator = subMapX.getMap("Hsb_replicator").getEntity("ReplicatorElement");
					Element replicatorElement = (Element)replicator;
						
					if (mainElements.find(replicatorElement) != -1 && replicatorElement.bIsValid())
					{
						int mappedQuantity =_Map.getInt(replicatorElement.handle()) +1;
						Map productionMap = replicatorElement.subMapX("Hsb_production");
						Map replicatorMap = productionMap.getMap("Hsb_replicator");
						int amountLocked = replicatorMap.getInt("AmountLocked");
						if (! amountLocked)
						{
							replicatorElement.setQuantity(mappedQuantity);
						}
						_Map.setInt(replicatorElement.handle(), replicatorElement.quantity());
					}
					else if (replicatorElement.bIsValid())
					{
						mainElements.append(replicatorElement);
						int mappedQuantity =_Map.getInt(replicatorElement.handle());
						Map productionMap = replicatorElement.subMapX("Hsb_production");
						Map replicatorMap = productionMap.getMap("Hsb_replicator");
						int amountLocked = replicatorMap.getInt("AmountLocked");
						if (! amountLocked)
						{
							replicatorElement.setQuantity(mappedQuantity);
						}
						_Map.setInt(replicatorElement.handle(), replicatorElement.quantity());
					}
	
				}
				else
				{
						int mappedQuantity =_Map.getInt(el.handle());
						Map productionMap = el.subMapX("Hsb_production");
						Map replicatorMap = productionMap.getMap("Hsb_replicator");
						int amountLocked = replicatorMap.getInt("AmountLocked");
						if (! amountLocked)
						{
							el.setQuantity(mappedQuantity);
						}
						_Map.setInt(el.handle(), el.quantity());
						elementsToUse.append(el);
				}
			}
		}
		// check if replicated elements
		else
	{
		for (int el = 0; el < _Element.length(); el++)
		{
//			if (usedElements.find(_Element[el]) != -1)
//			{
//				reportNotice(TN("|Element|: ") + _Element[el].number() + T(" |was already used in a delivery|") );
//			}
			elementsToUse.append(_Element[el]);
			int mappedQuantity = _Map.getInt(_Element[el].handle());
			Map productionMap = _Element[el].subMapX("Hsb_production");
			Map replicatorMap = productionMap.getMap("Hsb_replicator");
			int amountLocked = replicatorMap.getInt("AmountLocked");
			if ( ! amountLocked)
			{
				_Element[el].setQuantity(mappedQuantity);
			}
			_Map.setInt(_Element[el].handle(), _Element[el].quantity());
		}
		
	}
	
		for (int m=0;m<mainElements.length();m++)
			elementsToUse.append(mainElements[m]);

		for (int q=0;q<elementsToUse.length();q++)
		{
			Element elToUse = elementsToUse[q];
			int mappedQuantity =_Map.getInt(elToUse.handle()) +1;
			Map productionMap = elToUse.subMapX("Hsb_production");
			Map replicatorMap = productionMap.getMap("Hsb_replicator");
			int amountLocked = replicatorMap.getInt("AmountLocked");
			if (! amountLocked)
			{
				elToUse.setQuantity(mappedQuantity);
			}
			entitiesToExport.append(elToUse);
			Entity allElementEntities[] = elToUse.elementGroup().collectEntities(false, (Entity()), _kModelSpace, false);
			allElementEntities.append(elToUse);
			Map elementMap;
			Map entitiesMap;
			Map numberMap;
			Map quantityMap;
			quantityMap.setInt("Quantity", elToUse.quantity());
			numberMap.setString("Number", elToUse.number());
			entitiesMap.appendEntity("Element", elToUse);
			
			for (int i=0;i<allElementEntities.length();i++)
			{
				entitiesToExport.append(allElementEntities[i]);
				entitiesMap.appendEntity("Entity", allElementEntities[i]);
			}
			
			elementMap.appendMap("Quantity", quantityMap);
			elementMap.appendMap("Number", numberMap);
			elementMap.appendMap("Entity[]", entitiesMap);
			subMapProjectX.appendMap("Element", elementMap);	
		}
		
		Map looseEntitiesMap;
		
		// get entities if selection is entities
		if (selectionAreElements == false)
		{
			 for (int d=0;d<_Entity.length();d++)
			{
				Entity ent = _Entity[d];
				if (! ent.bIsKindOf(Element()) && _Element.find(ent.element()) == -1)
				{
					entitiesToExport.append(ent);
					looseEntitiesMap.appendEntity("LooseEntity", ent);
				}
			}
			subMapProjectX.setMap("LooseEntity[]", looseEntitiesMap);
		}
		
		String date = String().formatTime("%d-%m-%Y,%H.%M.%S");
		
		projectMapX.setMapName("Delivery[]");
		
		subMapProjectX.setString("DeliveryName", deliveryName);
		subMapProjectX.setString("DeliveryDescription", deliveryDescription);
		subMapProjectX.setString("DeliveryDate", date);
		subMapProjectX.setString("DeliveryExportGroup", strExportGroup);
		subMapProjectX.setString("DeliveryUser", hsbOEVersion());
		subMapProjectX.setString("DeliveryOnlySelection", onlySelection);
		subMapProjectX.setString("Exported", export);
	
		projectMapX.setMap(deliveryName, subMapProjectX);
	
		setSubMapXProject("Delivery[]", projectMapX);
		
	
		Map projectMapXDelivery = subMapXProject("Hsb_Delivery");
		projectMapXDelivery.setString("DELIVERYDESCRIPTION", deliveryDescription);
		projectMapXDelivery.setString("DELIVERY", deliveryName);
		setSubMapXProject("Hsb_Delivery", projectMapXDelivery);
	}
	else
	{
		if((_kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1) && !_Map.hasMap("Element[]"))
			showDialog();
		else if (_Map.hasMap("Element[]"))
			setPropValuesFromMap(_Map.getMap("Properties"));	
		setCatalogFromPropValues(T("|_LastInserted|"));
		
		strExportGroup = pGroup;
		 if (strExportGroup == "")
			  strExportGroup = pShortcut;
		
		Entity allEntElements[] = Group().collectEntities(TRUE, Element(), _kModelSpace);
		for( int i=0;i<allEntElements.length();i++ ){
			Element el = (Element)allEntElements[i];
			Map productionMap = el.subMapX("Hsb_production");
			Map replicatorMap = productionMap.getMap("Hsb_replicator");
			int amountLocked = replicatorMap.getInt("AmountLocked");

			if( el.bIsValid() && ! amountLocked)
			{
				el.setQuantity(0);
			}
		}
		
		Map projectStoredExports;
		Map projectStoredElements;
		if (_Map.hasMap("Element[]"))
		{
			projectStoredElements = _Map.getMap("Element[]");
		}
		else
		{
			projectStoredExports = subMapXProject("Delivery[]");
			projectStoredElements = projectStoredExports.getMap(deliveryName);
		}
		
		for (int e=0;e<projectStoredElements.length();e++)
		{
			Map elementMap = projectStoredElements.getMap(e);
			Map entitiesMap = elementMap.getMap("Entity[]");
			Map quantitiesMap = elementMap.getMap("Quantity");
			Map numbersMap = elementMap.getMap("Number");
			int quantity = quantitiesMap.getInt("Quantity");
			
			Entity storedEntitieElement = entitiesMap.getEntity("Element");
			Element storedElement = (Element)storedEntitieElement;
			Map productionMap = storedElement.subMapX("Hsb_production");
			Map replicatorMap = productionMap.getMap("Hsb_replicator");
			int amountLocked = replicatorMap.getInt("AmountLocked");
			if (storedElement.bIsValid() && ! amountLocked)
			{
				storedElement.setQuantity(quantity);
				_Element.append(storedElement);
				elementsToUse.append(storedElement);
				entitiesToExport.append(storedElement);
			}
			else
			{
				continue;
			}
			
			if (_Map.hasMap("Element[]"))
			{
				entitiesToExport.append(storedElement.elementGroup().collectEntities(false, (Entity()), _kModelSpace, false));
			}
			else
			{
				for (int m=0;m<entitiesMap.length();m++)
				{
					Entity entity = entitiesMap.getEntity(m);
					if (!entity.bIsKindOf(Element()))
						entitiesToExport.append(entity);
				}				
			}
			
			if (elementMap.length() > 0)
				subMapProjectX.appendMap("Element", elementMap);
				
		}

		Map projectStoredLooseEntities;
		if (_Map.hasMap("LooseEntity[]"))
		{
			_Map.getMap("LooseEntity[]");
		}
		else
		{
			projectStoredExports = subMapXProject("Delivery[]");
			projectStoredLooseEntities = projectStoredExports.getMap(deliveryName).getMap("LooseEntity[]");		
		}
		
		for (int index=0;index<projectStoredLooseEntities.length();index++) 
		{ 
			Entity ent = projectStoredLooseEntities.getEntity(index); 
			if (ent.bIsValid() && !ent.bIsKindOf(Element())) 
				entitiesToExport.append(ent);
		}
		
		if (projectStoredLooseEntities.length() > 0)
			subMapProjectX.setMap("LooseEntity[]", projectStoredLooseEntities);
			
		String date = String().formatTime("%d-%m-%Y,%H.%M.%S");
		Map projectMapX = subMapXProject("Delivery[]");
		projectMapX.setMapName("Delivery[]");
		
		subMapProjectX.setString("DeliveryName", deliveryName);
		subMapProjectX.setString("DeliveryDescription", deliveryDescription);
		subMapProjectX.setString("DeliveryDate", date);
		subMapProjectX.setString("DeliveryExportGroup", strExportGroup);
		subMapProjectX.setString("DeliveryUser", hsbOEVersion());
		subMapProjectX.setString("DeliveryOnlySelection", onlySelection);
		subMapProjectX.setString("Exported", export);
	
		projectMapX.setMap(deliveryName, subMapProjectX);
	
		setSubMapXProject("Delivery[]", projectMapX);
		
		Map projectMapXDelivery = subMapXProject("Hsb_Delivery");
		projectMapXDelivery.setString("DELIVERYDESCRIPTION", deliveryDescription);
		projectMapXDelivery.setString("DELIVERY", deliveryName);
		setSubMapXProject("Hsb_Delivery", projectMapXDelivery);
	}
		
	if (export == T("|Yes|"))
	{	 
		 // set some export flags
		ModelMapComposeSettings mmFlags;		
		 mmFlags.addSolidInfo(true); // default FALSE
		 mmFlags.addAnalysedToolInfo(true); // default FALSE		
		 mmFlags.addElemToolInfo(true); // default FALSE		
		 mmFlags.addConstructionToolInfo(true); // default FALSE		
		 mmFlags.addHardwareInfo(true); // default FALSE		
		 mmFlags.addRoofplanesAboveWallsAndRoofSectionsForRoofs(true); // default FALSE		
		 mmFlags.addCollectionAndBlockDefinitions(true); // default FALSE		 
		 mmFlags.addAllGroups(false);		
		 // Map that contains the keys that need to be overwritten in the ProjectInfo 
		
		 Map mpProjectInfoOverwrite;
		 
	//	mpProjectInfoOverwrite.appendString("ProjectInfo\\DELIVERY", deliveryName);
	//	mpProjectInfoOverwrite.appendString("ProjectInfo\\DELIVERYDESCRIPTION", deliveryDescription);
	//	mpProjectInfoOverwrite.appendString("ProjectInfo\\DELIVERYDATE", String().formatTime("%d-%m-%Y, %H:%M"));
	//	mpProjectInfoOverwrite.appendString("ProjectInfo\\DELIVERED", "yes");
	//	
	//	mpProjectInfoOverwrite.appendString("ProjectInfo\\ProjectRevision", projectRevision());
	//	mpProjectInfoOverwrite.appendString("ProjectInfo\\PathDwg", _kPathDwg);

		 // call the exporter	
		 int bOk = ModelMap().callExporter(mmFlags, mpProjectInfoOverwrite,entitiesToExport, strExportGroup, strDestinationFolder);
		
		 if (!bOk)
		         reportMessage("\nTsl::callExporter failed.");
	}
	 
	         
	 for (int u=0;u<elementsToUse.length();u++)
	{
		Element elToUse = elementsToUse[u];
	}

}

if (!_Map.hasMap("Element[]"))
{ 
	Map propValues = mapWithPropValues();
	Entity arEntTsl[] = Group().collectEntities(TRUE, TslInst(), _kAllSpaces);
	for( int i=0;i<arEntTsl.length();i++ ){
		TslInst tsl = (TslInst)arEntTsl[i];
		if( !tsl.bIsValid() )
			continue;
		
		if (tsl.scriptName() == "HSB_G-ExportInformation")
		{
			String dimensionStyle = tsl.propString(T("|Dimension style|"));
			_Entity.append(tsl);
			tsl.setPropValuesFromMap(propValues);
			tsl.setPropString(T("|Dimension style|"), dimensionStyle);
			tsl.setCatalogFromPropValues(T("|_LastInserted|"));
			tsl.recalc();
		}
	}
}
if (_bOnDbCreated)
{
	eraseInstance();
	return;
}




#End
#BeginThumbnail



























#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17874: dont break loop when removing element for reassignment. It can be found in many copies" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="2/8/2023 3:18:53 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Make sure an element can only be included once in a single export" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="8/31/2022 3:04:13 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Do not set dim style on elementinfo tsl" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="8/3/2022 11:06:28 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End