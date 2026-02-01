#Version 8
#BeginDescription
#Versions:
1.11 14/07/2025 Store state in dwg Author: Robert Pol
1.10 08.02.2023 HSB-17874: add trigger to remove element from current group; add property textheight 
1.9 31/08/2022 Add recalc option to display the current delivery Author: Robert Pol


Show exported deliveries





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 11
#KeyWords 
#BeginContents
// constants //region
	/// <summary Lang=en>
	/// Description
	/// </summary>

	/// <insert>
	/// Specify insert
	/// </insert>

	/// <remark Lang=en>
	/// 
	/// </remark>

	/// <version  value="1.08" date="03-08-2017"></version>

	/// <history>
	/// RP - 1.00 - 17-03-2017 -  Pilot version.
	/// RP - 1.01 - 28-07-2017 -  Trigger export tsl with execute key.
	/// RP - 1.02 - 31-07-2017 -  Make upper to execute key caused issues, not use map key for recalctriggers.
	/// RP - 1.03 - 31-07-2017 -  Change content of visualisation.
	/// RP - 1.04 - 31-07-2017 -  Visualize current delivery.
	/// RP - 1.05 - 31-07-2017 -  Add ";".between element and amount
	/// RP - 1.06 - 02-08-2017 -  Add Dimension Style and reset how map is given to Export tsl
	/// RP - 1.07 - 03-08-2017 -  Wrong text height
	/// RP - 1.08 - 03-08-2017 -  Wrong text offset because of height
	// #Versions:
//1.11 14/07/2025 Store state in dwg Author: Robert Pol
// 1.10 08.02.2023 HSB-17874: add trigger to remove element from current group; add property textheight Author: Marsel Nakuci
//1.9 31/08/2022 Add recalc option to display the current delivery Author: Robert Pol
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
	T("|Export|"),
	T("|Display|")
};

String arGroups[] = ModelMap().exporterGroups();
     
for(int s1=1;s1<arGroups.length();s1++)
{
	int s11 = s1;
 	for(int s2=s1-1;s2>=0;s2--)
 	{
  		if( arGroups[s11] < arGroups[s2] )
  		{
   			arGroups.swap(s2, s11);     
   			s11=s2;
  		}
 	}
}
arGroups.insertAt(0, ""); // add empty string
PropString pGroup(0,arGroups,T("|Exporter group|"));
pGroup.setCategory(categories[1]);
pGroup.setDescription(T("|Select the group that needs to be exported. If empty the single export is used|"));
pGroup.setReadOnly(false);

String arShortcuts[] = ModelMap().exporterShortcuts();
for (int s1 = 1; s1 < arShortcuts.length(); s1++) {
	int s11 = s1;
	for (int s2 = s1 - 1; s2 >= 0; s2--) {
		if ( arShortcuts[s11] < arShortcuts[s2] ) {
			arShortcuts.swap(s2, s11);
			s11 = s2;
		}
	}
}
arShortcuts.insertAt(0, ""); // add empty string
PropString pShortcut(1,arShortcuts,T("|Single export|"));
pShortcut.setCategory(categories[1]);
pShortcut.setDescription(T("|Select the single export that needs to be exported. If empty the group export is used|"));
pShortcut.setReadOnly(false);

PropString deliveryName(2, T("|New delivery|"), (T("|Delivery name|")));
deliveryName.setCategory(categories[0]);
deliveryName.setDescription(T("|Sets the delivery name|"));
if (_kExecuteKey != T("|Delete|"))
	deliveryName.setReadOnly(true);


PropString deliveryDescription(3, T("|New description|"), (T("|Description name|")));
deliveryDescription.setCategory(categories[0]);
deliveryDescription.setDescription(T("|Sets the delivery description|"));
deliveryDescription.setReadOnly(true);

PropString onlySelection(4, sNoYes, (T("|Use unique elements|")));
onlySelection.setCategory(categories[1]);
onlySelection.setDescription(T("|If this is set to no, the replicated elements are checked. If set to no, or not set, the selected elements are exported|"));
onlySelection.setReadOnly(true);

PropString export(5, sNoYes, (T("|Export|")));
export.setCategory(categories[1]);
export.setDescription(T("|If this is set to no, the exporter will not run, only the delivery is created|"));
export.setReadOnly(false);

PropString dimStyle(6, _DimStyles, T("Dimension style"));
dimStyle.setCategory(categories[2]);
dimStyle.setDescription(T("|Sets the dimension style for the content that is displayed|"));
dimStyle.setReadOnly(false);

String sTextHeightName=T("|Text Height|");	
PropDouble dTextHeight(nDoubleIndex++, U(100), sTextHeightName);	
dTextHeight.setDescription(T("|Defines the Text Height|"));
dTextHeight.setCategory(category);

 
if (_bOnInsert) 
{
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	_Pt0 = getPoint();
}

String executeKey = _kExecuteKey;

Display dp(-1);
dp.dimStyle(dimStyle);
dp.textHeight(dTextHeight);

Map mapTsl;
Map projectMapX = subMapXProject("Delivery[]");
int lineNumber= 1;
int lineNumberPrev=-3;

addRecalcTrigger(_kContext, T("|Show current delivery|"));
if (_kExecuteKey == T("|Show current delivery|"))
{
	Group allGroups[] = Group().allExistingGroups();
	for (int g=0;g<allGroups.length();g++)
	{
		Group group = allGroups[g];
		group.turnGroupVisibilityOff(false);
	}
	pushCommandOnCommandStack("Regen"); 
}

//region Trigger HideElements
String sTriggerHideElements = T("|Hide delivery elements|");
addRecalcTrigger(_kContext, sTriggerHideElements );
//if (_bOnRecalc && _kExecuteKey==sTriggerHideElements)
//{
//			
////	setExecutionLoops(2);
////	return;
//}
//endregion	

//region Trigger RemoveElementFromCurrentGroup
	String sTriggerRemoveElementFromCurrentGroup = T("|Remove Element From Current Group|");
	addRecalcTrigger(_kContext, sTriggerRemoveElementFromCurrentGroup );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveElementFromCurrentGroup)
	{
	// prompt for elements
		Element els[0];
		PrEntity ssE(T("|Select elements|"), Element());
	  	if (ssE.go())
			els.append(ssE.elementSet());
		if(els.length()==0)
		{ 
			setExecutionLoops(2);
			return;
		}
		String sNumbers[0];
		for (int iel=0;iel<els.length();iel++) 
		{ 
			sNumbers.append(els[iel].number());
		}//next iel
		
		for (int i = 0; i < projectMapX.length(); i++)
		{ 
			Map thisMap = projectMapX.getMap(i);
			String sKeyThisMap = projectMapX.keyAt(i);
			String mapDeliveryName = thisMap.getString("DeliveryName");
			if(deliveryName != mapDeliveryName)continue;
			int nModifiedThis;
			for (int m = 0; m < thisMap.length(); m++)
			{
				Map elementMap = thisMap.getMap(m);
				
				Map numbersMap = elementMap.getMap("Number");
				String elementNumber = numbersMap.getString("Number");
				if(sNumbers.find(elementNumber)>-1)
				{ 
					thisMap.removeAt(m,false);
					nModifiedThis=true;
					continue;
				}
				String sKeyElementMap = thisMap.keyAt(m);
				Map entitiesMap = elementMap.getMap("Entity[]");
				int nModified;
				for (int e=entitiesMap.length()-1; e>=0 ; e--) 
				{ 
					Entity entity = entitiesMap.getEntity(e);
					Element element = (Element)entity;
					
					if (!element.bIsValid()) continue;
					int nIndexEl=els.find(element);
					if(nIndexEl>-1)
					{ 
						nModified=true;
						nModifiedThis = true;
						entitiesMap.removeAt(e, false);
//						els.removeAt(nIndexEl);
					}
//					if(els.length()==0)break;
				}//next e
				if(nModified)
				{ 
					elementMap.setMap("Entity[]",entitiesMap);
					thisMap.removeAt(m,false);
					thisMap.appendMap(sKeyElementMap,elementMap);
				}
//				if(els.length()==0)break;
			}
			if(nModifiedThis)
			{ 
				projectMapX.removeAt(i,false);
				projectMapX.appendMap(sKeyThisMap,thisMap);
			}
//			if(els.length()==0)break;
		}
		setSubMapXProject("Delivery[]", projectMapX);
		_ThisInst.recalc();
		setExecutionLoops(2);
		return;
	}//endregion	


////region Trigger AddElementToCurrentGroupExclusively
//	String sTriggerAddElementToCurrentGroupExclusively = T("|Add Element To Current Group Exclusively|");
//	addRecalcTrigger(_kContext, sTriggerAddElementToCurrentGroupExclusively );
//	if (_bOnRecalc && _kExecuteKey==sTriggerAddElementToCurrentGroupExclusively)
//	{
//		// prompt for elements
//		Element els[0];
//		PrEntity ssE(T("|Select elements|"), Element());
//	  	if (ssE.go())
//			els.append(ssE.elementSet());
//		if(els.length()==0)
//		{ 
//			setExecutionLoops(2);
//			return;
//		}
//		
//	// first remove averywhere then add only to current
//		for (int i = 0; i < projectMapX.length(); i++)
//		{ 
//			Map thisMap = projectMapX.getMap(i);
//			String sKeyThisMap = projectMapX.keyAt(i);
//			String mapDeliveryName = thisMap.getString("DeliveryName");
//			int nModifiedThis;
//			for (int m = 0; m < thisMap.length(); m++)
//			{
//				Map elementMap = thisMap.getMap(m);
//				String sKeyElementMap = thisMap.keyAt(m);
//				Map entitiesMap = elementMap.getMap("Entity[]");
//				int nModified;
//				for (int e=entitiesMap.length()-1; e>=0 ; e--) 
//				{ 
//					Entity entity = entitiesMap.getEntity(e);
//					Element element = (Element)entity;
//					
//					if (!element.bIsValid()) continue;
//					int nIndexEl=els.find(element);
//					if(nIndexEl>-1)
//					{ 
//						nModified=true;
//						nModifiedThis = true;
//						reportMessage("\n"+scriptName()+" "+T("|entitiesMap|")+entitiesMap.length());
//						entitiesMap.removeAt(e, false);
//						reportMessage("\n"+scriptName()+" "+T("|entitiesMap|")+entitiesMap.length());
////						els.removeAt(nIndexEl);
//					}
////					if(els.length()==0)break;
//				}//next e
//				if(nModified)
//				{ 
//					reportMessage("\n"+scriptName()+" "+T("|enters|"));
//					
//					elementMap.setMap("Entity[]",entitiesMap);
//					thisMap.removeAt(m,false);
//					thisMap.appendMap(sKeyElementMap,elementMap);
//				}
////				if(els.length()==0)break;
//			}
//			if(nModifiedThis)
//			{ 
//				reportMessage("\n"+scriptName()+" "+T("|enters2|"));
//				
//				projectMapX.removeAt(i,false);
//				projectMapX.appendMap(sKeyThisMap,thisMap);
//			}
////			if(els.length()==0)break;
//		}
//		
//	// add to current
//		for (int i = 0; i < projectMapX.length(); i++)
//		{ 
//			Map thisMap = projectMapX.getMap(i);
//			String sKeyThisMap = projectMapX.keyAt(i);
//			String mapDeliveryName = thisMap.getString("DeliveryName");
//			if(deliveryName != mapDeliveryName)continue;
////			int nModifiedThis;
//			for (int m = 0; m < thisMap.length(); m++)
//			{
//				Map elementMap = thisMap.getMap(m);
//				String sKeyElementMap = thisMap.keyAt(m);
//				Map entitiesMap = elementMap.getMap("Entity[]");
//				for (int iel=0;iel<els.length();iel++) 
//				{ 
//					entitiesMap.appendEntity("ENTITY",els[iel]); 
//					 
//				}//next iel
//				
////				int nModified;
////				for (int e=entitiesMap.length()-1; e>=0 ; e--) 
////				{ 
////					Entity entity = entitiesMap.getEntity(e);
////					Element element = (Element)entity;
////					
////					if (!element.bIsValid()) continue;
////					int nIndexEl=els.find(element);
////					if(nIndexEl>-1)
////					{ 
////						nModified=true;
////						nModifiedThis = true;
////						reportMessage("\n"+scriptName()+" "+T("|entitiesMap|")+entitiesMap.length());
////						entitiesMap.removeAt(e, false);
////						reportMessage("\n"+scriptName()+" "+T("|entitiesMap|")+entitiesMap.length());
//////						els.removeAt(nIndexEl);
////					}
//////					if(els.length()==0)break;
////				}//next e
////				if(nModified)
//				{ 
//					reportMessage("\n"+scriptName()+" "+T("|enters|"));
//					
//					elementMap.setMap("Entity[]",entitiesMap);
//					thisMap.removeAt(m,false);
//					thisMap.appendMap(sKeyElementMap,elementMap);
//				}
////				if(els.length()==0)break;
//			}
////			if(nModifiedThis)
//			{ 
//				reportMessage("\n"+scriptName()+" "+T("|enters2|"));
//				
//				projectMapX.removeAt(i,false);
//				projectMapX.appendMap(sKeyThisMap,thisMap);
//			}
////			if(els.length()==0)break;
//		}
//		setSubMapXProject("Delivery[]", projectMapX);
//		_ThisInst.recalc();
//		setExecutionLoops(2);
//		return;
//	}//endregion	


addRecalcTrigger(_kContext, T("|Delete|"));
if (_kExecuteKey == T("|Delete|"))
{
	setPropValuesFromCatalog(T("|_LastInserted|"));
	showDialog();
	setCatalogFromPropValues(T("|_LastInserted|"));
}

String allNumbers[0];
String allQuantities[0];
String headerString[0];

String longestStringNumber;
int stringLengthNumber;

String longestStringQuantity;
int stringLengthQuantity;

String longestStringHeader;
int stringLengthHeader;


for (int i = 0; i < projectMapX.length(); i++)
{
	Map thisMap = projectMapX.getMap(i);
	String mapDeliveryName = thisMap.getString("DeliveryName");
	String mapDeliveryDescription = thisMap.getString("DeliveryDescription");
	headerString.append(mapDeliveryDescription);
	String deliveryDate = thisMap.getString("DeliveryDate");
	headerString.append(deliveryDate);
	String deliveryExportGroup = thisMap.getString("DeliveryExportGroup");
	headerString.append(deliveryExportGroup);
	String deliveryUser = thisMap.getString("DeliveryUser");
//	headerString.append(deliveryUser);
	String deliveryOnlySelection = thisMap.getString("DeliveryOnlySelection");
//	headerString.append(deliveryOnlySelection);
	String exported = thisMap.getString("Exported");
	headerString.append(exported);
	
	for (int n = 0; n < allNumbers.length(); n++)
	{
		String thisNumber = allNumbers[0];
		int thisStringLength = thisNumber.length();
		if (thisStringLength > stringLengthNumber)
		{
			longestStringNumber = thisNumber;
			stringLengthNumber = thisStringLength;
		}
	}
	
	for (int m = 0; m < thisMap.length(); m++)
	{
		Map elementMap = thisMap.getMap(m);
		Map entitiesMap = elementMap.getMap("Entity[]");
		Map quantitiesMap = elementMap.getMap("Quantity");
		Map numbersMap = elementMap.getMap("Number");
		int quantity = quantitiesMap.getInt("Quantity");
		
		if (quantitiesMap.hasInt("Quantity"))
		{
			String elementNumber = numbersMap.getString("Number");
			allNumbers.append(elementNumber);
			int elementAmount = quantity;
			allQuantities.append(quantity);
		}
	}
	
	for (int n = 0; n < allNumbers.length(); n++)
	{
		String thisNumber = allNumbers[n];
		int thisStringLength = thisNumber.length();
		if (thisStringLength > stringLengthNumber)
		{
			longestStringNumber = thisNumber;
			stringLengthNumber = thisStringLength;
		}
	}
	
	for (int n = 0; n < allQuantities.length(); n++)
	{
		String thisQuantity = allQuantities[n];
		int thisQuantityLength = thisQuantity.length();
		if (thisQuantityLength > stringLengthQuantity)
		{
			longestStringQuantity = thisQuantity;
			stringLengthQuantity = thisQuantityLength;
		}
	}
	
	for (int n = 0; n < headerString.length(); n++)
	{
		String thisHeader = headerString[n];
		int thisHeaderLength = thisHeader.length();
		if (thisHeaderLength > stringLengthHeader)
		{
			longestStringHeader = thisHeader;
			stringLengthHeader = thisHeaderLength;
		}
	}
}

Map mapWithPropValues;

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
	
	if (_kExecuteKey == T("|Delete|") && deliveryName == mapDeliveryName)
	{ 
		removeSubMapXProject("Delivery[]");
		projectMapX.removeAt(i, true);
		setSubMapXProject("Delivery[]", projectMapX);
		_ThisInst.recalc();
		continue;
	}

	if (executeKey == mapDeliveryName)
	{
		_ThisInst.setPropString(2, mapDeliveryName);
		_ThisInst.setPropString(3, mapDeliveryDescription);
		_ThisInst.setPropString(4, deliveryOnlySelection);
		_ThisInst.setPropString(5, export);
		setCatalogFromPropValues(T("|_LastInserted|"));
		showDialog();
		setCatalogFromPropValues(T("|_LastInserted|"));
		Map mapWithPropValues= mapWithPropValues();	
		mapTsl.setMap("Element[]", thisMap);	
		String strScriptName = "HSB_G-ReplicatorExport";	
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		
		Element lstElements[0];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		
		mapTsl.setMap("Properties", mapWithPropValues);
		TslInst tslNew;
		tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		_ThisInst.recalc();
		return;
	}

	addRecalcTrigger(_kContext, mapDeliveryName);
	 
 	String deliveryString = mapDeliveryName + ", " + mapDeliveryDescription;

	double textHeightOffset = 1.4*dp.textHeightForStyle(deliveryString, dimStyle,dTextHeight);
	double dUnderlineSpace=0.2*dp.textHeightForStyle(deliveryString, dimStyle,dTextHeight);
	double textLengthOffsetNumber = dp.textLengthForStyle(longestStringNumber, dimStyle,dTextHeight) + dp.textLengthForStyle("...", dimStyle,dTextHeight);
	double pLineOffsetNumber = dp.textLengthForStyle(longestStringNumber, dimStyle,dTextHeight) + dp.textLengthForStyle("...", dimStyle,dTextHeight);
	double pLineOffsetQuantity = dp.textLengthForStyle(longestStringNumber, dimStyle,dTextHeight) + dp.textLengthForStyle(longestStringQuantity, dimStyle,dTextHeight) 
		+ dp.textLengthForStyle("...", dimStyle,dTextHeight) + dp.textLengthForStyle("......", dimStyle,dTextHeight) 
			+ dp.textLengthForStyle("...", dimStyle,dTextHeight);
	double extraInfo = pLineOffsetQuantity + dp.textLengthForStyle("...", dimStyle,dTextHeight) + textHeightOffset;
	// 
	if(lineNumber-lineNumberPrev<4)
	{ 
		lineNumber = lineNumberPrev +5;
	}
	lineNumberPrev=lineNumber;
	Point3d beginPointElementPline = _Pt0 - _YW * textHeightOffset * (lineNumber) + _XW * textHeightOffset;
	dp.draw(deliveryString, _Pt0-_YW*(textHeightOffset*(lineNumber)-dUnderlineSpace),_XW,_YW,1,1);
	dp.draw(T("|Date|") + ":"+"        "+deliveryDate,_Pt0-_YW*textHeightOffset*(lineNumber+1)+_XW*extraInfo,_XW,_YW,1,1);
	dp.draw(T("|Export|") + ":"+"     "+deliveryExportGroup,_Pt0-_YW*textHeightOffset*(lineNumber+2)+_XW*extraInfo,_XW,_YW,1,1);
	dp.draw(T("|Exported|") + ":"+" "+exported,_Pt0-_YW*textHeightOffset*(lineNumber +3)+_XW*extraInfo,_XW,_YW,1,1);
	Point3d ptTxtTotal=_Pt0-_YW*textHeightOffset*(lineNumber +4)+_XW*extraInfo;
	// nr elements in this group
	int NrTotalQuantityGroup;
	
	PLine deliveryPline(_Pt0-_YW*textHeightOffset*(lineNumber),_Pt0-_YW*textHeightOffset*(lineNumber)+_XW*(dp.textLengthForStyle(longestStringHeader+T("|Exported|")+":"+".",dimStyle,dTextHeight)+extraInfo));
	
	dp.draw(deliveryPline);
	lineNumber += 1;
	for (int m=0;m<thisMap.length();m++)
	{		
		Map elementMap = thisMap.getMap(m);
		Map entitiesMap = elementMap.getMap("Entity[]");
		Map quantitiesMap = elementMap.getMap("Quantity");
		Map numbersMap = elementMap.getMap("Number");
		int quantity = quantitiesMap.getInt("Quantity");
		
		if (quantitiesMap.hasInt("Quantity"))
		{
			String elementNumber = numbersMap.getString("Number");
			allNumbers.append(elementNumber);
			int elementAmount = quantity;
			NrTotalQuantityGroup+=elementAmount;
			allQuantities.append(quantity);
			dp.draw(elementNumber,_Pt0-_YW*(textHeightOffset*(lineNumber)-dUnderlineSpace)+_XW*(textHeightOffset),_XW,_YW,1,1);
//			dp.draw(elementAmount, _Pt0-_YW*textHeightOffset*(lineNumber)+_XW*(textHeightOffset+textLengthOffsetNumber),_XW,_YW,1,1);
			dp.draw(elementAmount, _Pt0-_YW*(textHeightOffset*(lineNumber)-dUnderlineSpace)+_XW*(textHeightOffset+pLineOffsetNumber + dp.textLengthForStyle("...", dimStyle,dTextHeight)),_XW,_YW,1,1);
			PLine elementPline(_Pt0-_YW*textHeightOffset*(lineNumber)+_XW*textHeightOffset,_Pt0-_YW*textHeightOffset*(lineNumber)+_XW*(pLineOffsetQuantity+textHeightOffset));
//			PLine elementPline(_Pt0-_YW*textHeightOffset*(lineNumber),_Pt0-_YW*textHeightOffset*(lineNumber)+_XW*(pLineOffsetQuantity+textHeightOffset));
			dp.draw(elementPline);
			lineNumber += 1;	
		}	
		
		if (_kExecuteKey == T("|Show current delivery|") && deliveryName == mapDeliveryName)
		{ 
		// turn on elements from current delivery group
			for (int e=0;e<entitiesMap.length();e++)
			{
				Entity entity = entitiesMap.getEntity(e);
				Element element = (Element)entity;
				if (!element.bIsValid()) continue;
				
				element.elementGroup().turnGroupVisibilityOn(false);
				break;
			}
		}
		if(_kExecuteKey==sTriggerHideElements)
		{ 
			for (int e=0;e<entitiesMap.length();e++)
			{
				Entity entity = entitiesMap.getEntity(e);
				Element element = (Element)entity;
				if (!element.bIsValid()) continue;
				element.elementGroup().turnGroupVisibilityOff(false);
			}
		}
	}
	if(_kExecuteKey==sTriggerHideElements)
	{ 
		pushCommandOnCommandStack("Regen"); 
	}
	dp.draw(T("|Quantity|") + ":"+" "+NrTotalQuantityGroup,ptTxtTotal,_XW,_YW,1,1);
	
	Point3d endPointElementPline = _Pt0 - _YW * textHeightOffset * (lineNumber -1) + _XW * textHeightOffset;
	PLine elementPline(beginPointElementPline, endPointElementPline);
	PLine elementPline2 = elementPline;
	elementPline2.transformBy(_XW * (pLineOffsetQuantity));
	PLine elementPline3 = elementPline;
	elementPline3.transformBy(_XW * (pLineOffsetNumber + dp.textLengthForStyle("...", dimStyle,dTextHeight)));
	dp.draw(elementPline);
	dp.draw(elementPline2);
	dp.draw(elementPline3);
	lineNumber += 1;
}	

Map projectMapXDelivery = subMapXProject("Hsb_Delivery");
String currentDelivery = projectMapXDelivery.getString("DELIVERY");

String header = T("|Current Delivery|") + ": " + currentDelivery;
dp.draw(header, _Pt0 + _YW * (1.2 * dp.textHeightForStyle(header, dimStyle)), _XW, _YW, 1, 1);
PLine headerPline(_Pt0 + _YW * (1.2 * dp.textHeightForStyle(header, dimStyle)), _Pt0 + _XW * U(dp.textLengthForStyle(header, dimStyle)) + _YW * (1.2 * dp.textHeightForStyle(header, dimStyle)));
dp.draw(headerPline);



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
        <int nm="BreakPoint" vl="561" />
        <int nm="BreakPoint" vl="548" />
        <int nm="BreakPoint" vl="614" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Store state in dwg" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="7/14/2025 10:02:27 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17874: add trigger to remove element from current group; add property textheight" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="2/8/2023 11:21:45 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add recalc option to display the current delivery" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="8/31/2022 3:02:21 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End