#Version 8
#BeginDescription
Last modified by: Anno Sportel (annosportel@hsbcad.com)
18.04.2018  -  version 2.13


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 13
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl creates and maintains deliveries. 
/// The information of those deliveries can be used on production drawings and as input for the database.
/// </summary>

/// <insert>
/// Select an insertion point
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <version  value="2.13" date="18.04.2018"></version>

/// <history>
/// AS - 1.00 - 14.09.2009 	- Pilot version
/// AS - 1.01 - 16.09.2009 	- Fix issues with link to database app.
/// AS - 1.02 - 16.09.2009 	- Add trigger for delivery items when name of delivery changes
/// AS - 1.03 - 17.09.2009 	- Add description as read-only property
/// AS - 1.04 - 18.09.2009	- Add Edit function to custom menu
/// AS - 1.05 - 12.01.2010	- Set quantity of elements, add option to hide element when amount is 0
/// GJB - 1.06 - 15.04.2016 - Change the location to custom and made a seperate dll for it.
/// AS - 2.00 - 12.05.2016 - Create delivery for entire project.
/// ETH - 2.01 - 25.05.2016 - Cleaned up useless information whitch not can be used in the delivery
/// AS - 2.02 - 27.05.2016 - Add delivery as mapX data to project.
/// AS - 2.03 - 08.07.2016 - Ignore replicated elements.
/// AS - 2.04 - 11.07.2016 - Recalculate quantity tsls.
/// AS - 2.05 - 12.07.2016 - Recalculate quantity tsls after the tsl is finished.
/// AS - 2.06 - 12.09.2016 - Order items by name.
/// AS - 2.07 - 24.01.2017 - Also recalculate this tsl when name is changed.
/// AS - 2.08 - 15.03.2017 - Change assembly path from custom\delivery to utilities\database.
/// RP - 2.09 - 12.12.2017 - Do not remove replicators with the new replicator tsl
/// RP - 2.10 - 10.04.2018 - Add recalc triggers for cleaning up element list and removing submapxproject data
/// RP - 2.11 - 17.04.2018 - Declare array in the loop, otherwise wrong projectdelivery was appended & add remove delivery custom action
/// RP - 2.12 - 17.04.2018 - Small cleanup and delete tsl if last delivery is deleted
/// RP - 2.13 - 18.04.2018 - Set amount to 1 for all elements if tsl is deleted.
/// </history>

//Used for logging
int nLogLevel = 0;

String arSTrigger[] = {
	T("Create a new delivery"),
	T("Edit the current delivery"),
	T("Recalculate element list"),
	T("Remove current project delivery data"),
	T("Remove current delivery")
};
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );

// data needed for the delivery program
String strAssemblyPath = _kPathHsbInstall + "\\Utilities\\hsbDatabase\\hsbTslDelivery.dll";
//String strAssemblyPath = _kPathHsbInstall + "\\Custom\\CDDelivery\\hsbTslDelivery.dll";
String strType = "hsbTslDelivery.LoadTsl";
String strFunction = "LoadFromTsl";


// delivery item information on layout
//String sScriptnameDeliveryItem = ;
String tslsToRecalculate[] = {
	"HSB-DeliveryItem",
	"HSB_I-ShowElementQuantity"
};

//Dimension style
PropString sDimStyle(0, _DimStyles, T("Dimension style"));

PropInt nColorTable(0, -1, T("|Color table|"));
PropInt nColorContent(1, 5, T("|Color content|"));

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};
PropString sHideWhenZero(3, arSYesNo, T("|Hide when amount is '0'|"));

int nDefaultAmount = 1;
String sTableHeader = "HSB_G-Delivery";

//insert or new delivery
if( _bOnInsert || _kExecuteKey == arSTrigger[0] ){
	if( _bOnInsert && insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	Group floorGroups[0];
	Group groups[] = Group().allExistingGroups();
	for (int g=0;g<groups.length();g++) {
		Group group = groups[g];
		if (!group.bIsDeliverableContainer())
			continue;
		
		if (group.namePart(1) != "" && group.namePart(2) == "")
			floorGroups.append(group);
	}
		
	// name of the new delivery
	PropString sNewDeliveryName(1, "new delivery", T("|Delivery name|"));
	PropString sNewDeliveryDescription(2, "new description", T("|Delivery description|"));
	
	// show dialog
	showDialog();
	
	// delivery infomartion
	Map mapDelivery;
	mapDelivery.setString("NAME", sNewDeliveryName);
	mapDelivery.setString("DESCRIPTION", sNewDeliveryDescription);
	mapDelivery.setString("DELIVERYDATE", "");
	mapDelivery.setString("DELIVERED", "False");
	
	for (int f=0;f<floorGroups.length();f++) {
		Group floorGroup = floorGroups[f];
		
		// group infromation
		Map mapDeliveryGroup;
		mapDeliveryGroup.setString("NAME", floorGroup.name());
		mapDeliveryGroup.setInt("AMOUNT", nDefaultAmount);
		mapDeliveryGroup.setString("DELIVERED", "False");
		
		// item information
		Map mapDeliveryItem;
		mapDeliveryItem.setString("NAME", floorGroup.name());
		mapDeliveryItem.setInt("AMOUNT", nDefaultAmount);
		mapDeliveryItem.setString("DELIVERED", "False");
		mapDeliveryItem.setString("PRODUCED", "False");
		mapDeliveryItem.setString("TYPE", "Floor");
		mapDeliveryGroup.appendMap("DELIVERYITEM", mapDeliveryItem);
		
		// add all elements
		Entity arEnt[] = floorGroup.collectEntities(TRUE, Element(), _kModelSpace);
		for( int i=0;i<arEnt.length();i++ ){
			Element el = (Element)arEnt[i];
			if( !el.bIsValid() )
				continue;
			
			int isReplicatedElement = false;
			TslInst tsls[] = el.tslInst();
			for (int t=0;t<tsls.length();t++) {
				TslInst tsl = tsls[t];
				if ((tsl.scriptName() == "HSB_E-Replicator" && tsl.version() < 20000) || tsl.scriptName() == "HSB_E-Replica") {
					isReplicatedElement = true;
					break;
				}
			}
			
			if (isReplicatedElement)
				continue;
			
			// item information
			Map mapDeliveryItem;
			mapDeliveryItem.setString("NAME", el.number());
			mapDeliveryItem.setInt("AMOUNT", nDefaultAmount);
			mapDeliveryItem.setString("DELIVERED", "False");
			mapDeliveryItem.setString("PRODUCED", "False");
			mapDeliveryItem.setString("TYPE", "Element");
			mapDeliveryGroup.appendMap("DELIVERYITEM", mapDeliveryItem);
		}
		mapDelivery.appendMap("DELIVERYGROUP", mapDeliveryGroup);
	}
	
	// check if there are not other delivery tsls attached to this floor group
	if( _bOnInsert ){
		_Pt0 = getPoint(T("|Select a point|"));
		
		//Make this tsl 'The one and only!'..
		Entity arEntTslInst[] = Group().collectEntities(TRUE, TslInst(), _kModelSpace);
		for( int i=0;i<arEntTslInst.length();i++ ){
			TslInst tsl = (TslInst)arEntTslInst[i];
			if( !tsl.bIsValid() )
				continue;
			
			//check if there is already a tsl with this name. Keep that one and erase this one
			if( tsl.scriptName() == "HSB_G-Delivery" ){
				reportWarning(TN("|There is already a delivery tsl attached to this floorgroup!|"));
				eraseInstance();
				return;
			}
		}
		//This tsl is 'The one and only!'
	}
	
	// load delivery
	Map mapIn = mapDelivery;
	// debug
	mapIn.writeToDxxFile("C:\\temp\\delivery.dxx");
	// get the delivery information
	Map mapOut = callDotNetFunction2(strAssemblyPath, strType, strFunction, mapIn);	
	mapOut.writeToDxxFile("C:\\temp\\deliveryOut.dxx");
	
	//Store the delivery information
	_Map.appendMap("DELIVERY", mapOut);

	// end insert
	if( _bOnInsert )
		return;
}

if (_kExecuteKey == arSTrigger[2])
{
	Group floorGroups[0];
	String floorGroupNames[0];
	Group groups[] = Group().allExistingGroups();
	for (int g=0;g<groups.length();g++) {
		Group group = groups[g];
		if (!group.bIsDeliverableContainer())
			continue;
		
		if (group.namePart(1) != "" && group.namePart(2) == "")
		{
			floorGroups.append(group);
			floorGroupNames.append(group.name());
		}
	}
	
	for( int i=0;i<_Map.length();i++ )
	{
		if( _Map.hasMap(i) && _Map.keyAt(i) == "DELIVERY" )
		{
			Map mapDelivery = _Map.getMap(i);
			String storedFloorGroupNames[0];
			
			for (int f=0;f<mapDelivery.length();f++) 
			{
				Map mapDeliveryGroup = mapDelivery.getMap(f);	
				storedFloorGroupNames.append(mapDeliveryGroup.getString("NAME"));
			}
			
			for (int g=0;g<floorGroups.length();g++) 
			{
				Group floorGroup = floorGroups[g];
				Map mapDeliveryGroup;
				if (storedFloorGroupNames.find(floorGroup.name()) != -1)
				{
					mapDeliveryGroup = mapDelivery.getMap(storedFloorGroupNames.find(floorGroup.name()));
					
					String storedElementNames[0];
					for (int m=0;m<mapDeliveryGroup.length();m++) 
					{
						Map mapDeliveryItem = mapDeliveryGroup.getMap(m);	
						storedElementNames.append(mapDeliveryItem.getString("NAME"));
					}
					
					// add all elements
					Entity arEnt[] = floorGroup.collectEntities(TRUE, Element(), _kModelSpace);
					for( int i=0;i<arEnt.length();i++ ){
						Element el = (Element)arEnt[i];
						if( !el.bIsValid() )
							continue;
						
						int isReplicatedElement = false;
						TslInst tsls[] = el.tslInst();
						for (int t=0;t<tsls.length();t++) {
							TslInst tsl = tsls[t];
							if ((tsl.scriptName() == "HSB_E-Replicator" && tsl.version() < 20000) || tsl.scriptName() == "HSB_E-Replica") {
								isReplicatedElement = true;
								break;
							}
						}
						
						if (isReplicatedElement)
							continue;
							
						Map mapDeliveryItem;
						if (storedElementNames.find(el.number()) != -1)
						{
							mapDeliveryItem = mapDeliveryGroup.getMap(storedElementNames.find(el.number()));
						}
						else
						{
							mapDeliveryItem.setString("NAME", el.number());
							mapDeliveryItem.setInt("AMOUNT", nDefaultAmount);
							mapDeliveryItem.setString("DELIVERED", "False");
							mapDeliveryItem.setString("PRODUCED", "False");
							mapDeliveryItem.setString("TYPE", "Element");
							mapDeliveryGroup.appendMap("DELIVERYITEM", mapDeliveryItem);	
						}
					}
					mapDelivery.appendMap("DELIVERYGROUP", mapDeliveryGroup);
					mapDelivery.swapLastWith(storedFloorGroupNames.find(floorGroup.name()));
					mapDelivery.removeAt(mapDelivery.length() -1, true);
				}
				else
				{
					mapDeliveryGroup.setString("NAME", floorGroup.name());
					mapDeliveryGroup.setInt("AMOUNT", nDefaultAmount);
					mapDeliveryGroup.setString("DELIVERED", "False");
					
					// item information
					Map mapDeliveryItem;
					mapDeliveryItem.setString("NAME", floorGroup.name());
					mapDeliveryItem.setInt("AMOUNT", nDefaultAmount);
					mapDeliveryItem.setString("DELIVERED", "False");
					mapDeliveryItem.setString("PRODUCED", "False");
					mapDeliveryItem.setString("TYPE", "Floor");
					mapDeliveryGroup.appendMap("DELIVERYITEM", mapDeliveryItem);
					
					String storedElementNames[0];
					for (int m=0;m<mapDeliveryGroup.length();m++) 
					{
						Map mapDeliveryItem = mapDeliveryGroup.getMap(m);	
						storedElementNames.append(mapDeliveryItem.getString("NAME"));
					}
					
					// add all elements
					Entity arEnt[] = floorGroup.collectEntities(TRUE, Element(), _kModelSpace);
					for( int i=0;i<arEnt.length();i++ ){
						Element el = (Element)arEnt[i];
						if( !el.bIsValid() )
							continue;
						
						int isReplicatedElement = false;
						TslInst tsls[] = el.tslInst();
						for (int t=0;t<tsls.length();t++) {
							TslInst tsl = tsls[t];
							if ((tsl.scriptName() == "HSB_E-Replicator" && tsl.version() < 20000) || tsl.scriptName() == "HSB_E-Replica") {
								isReplicatedElement = true;
								break;
							}
						}
						
						if (isReplicatedElement)
							continue;
							
						Map mapDeliveryItem;
						if (storedElementNames.find(el.number()) != -1)
						{
							mapDeliveryItem = mapDeliveryGroup.getMap(storedElementNames.find(el.number()));
						}
						else
						{
							mapDeliveryItem.setString("NAME", el.number());
							mapDeliveryItem.setInt("AMOUNT", nDefaultAmount);
							mapDeliveryItem.setString("DELIVERED", "False");
							mapDeliveryItem.setString("PRODUCED", "False");
							mapDeliveryItem.setString("TYPE", "Element");
							mapDeliveryGroup.appendMap("DELIVERYITEM", mapDeliveryItem);	
						}
					}
				}

			}
			
			_Map.appendMap("DELIVERY", mapDelivery);
			_Map.swapLastWith(i);
			_Map.removeAt(_Map.length() -1, true);
		}
	}
} 

int bHideWhenAmountIsZero = arNYesNo[arSYesNo.find(sHideWhenZero,0)];

_Map.writeToDxxFile("C:\\temp\\mapOutNOTWorking.dxx");

Entity allEntElements[] = Group().collectEntities(TRUE, Element(), _kModelSpace);
String allElementNames[0];
Element allElements[0];
for( int i=0;i<allEntElements.length();i++ ){
	Element el = (Element)allEntElements[i];
	if( el.bIsValid() ){
		el.setQuantity(0);
		allElements.append(el);
		allElementNames.append(el.number());
	}
}

// all deliveries
String arSDeliveryName[0];
String arSDeliveryDescription[0];
String arSDeliveryDate[0];
String arSDeliveryStatus[0];
Map arMapDelivery[0];
int arNIndexInMap[0];
for( int i=0;i<_Map.length();i++ ){
	if( _Map.hasMap(i) && _Map.keyAt(i) == "DELIVERY" ){
		Map mapDelivery = _Map.getMap(i);
		arNIndexInMap.append(i);
		arMapDelivery.append(mapDelivery);
		arSDeliveryName.append(mapDelivery.getString("NAME"));
		arSDeliveryDescription.append(mapDelivery.getString("DESCRIPTION"));
		arSDeliveryDate.append(mapDelivery.getString("DELIVERYDATE"));
		arSDeliveryStatus.append(mapDelivery.getString("DELIVERED"));
	}
}

PropString sDeliveryName(1, arSDeliveryName, T("|Delivery name|"));
int nDeliveryIndex = arSDeliveryName.find(sDeliveryName,0);
PropString sDeliveryDescription(2, "", T("|Delivery description|"));
sDeliveryDescription.setReadOnly(TRUE);


if (_kExecuteKey == arSTrigger[3])
{
	removeSubMapXProject("Hsb_Delivery");
}
else if(_kExecuteKey == arSTrigger[4])
{
	for( int i=0;i<_Map.length();i++ )
	{
		if( _Map.hasMap(i) && _Map.keyAt(i) == "DELIVERY" ){
			Map mapDelivery = _Map.getMap(i);
			String name = mapDelivery.getString("NAME");
			if (name == sDeliveryName)
			{
				_Map.removeAt(i, true);
				sDeliveryName.set(arSDeliveryName[0]);
				removeSubMapXProject("Hsb_Delivery");
				_ThisInst.recalc();
				return;
			} 
		}
	}
}
else
{
	Map mapXDelivery;
	mapXDelivery.setString("Delivery", sDeliveryName);
	mapXDelivery.setString("DeliveryDescription", sDeliveryDescription);
	setSubMapXProject("Hsb_Delivery", mapXDelivery);
}

if (arNIndexInMap.length() < 1)
{
	reportWarning(TN("|Last delivery deleted, tsl will be deleted|"));
	for( int i=0;i<allEntElements.length();i++ )
	{
		Element el = (Element)allEntElements[i];
		if ( el.bIsValid() )
		{
			el.setQuantity(1);
		}
	}
	eraseInstance();
	return;
}

// the current delivery
Map mapDelivery = arMapDelivery[nDeliveryIndex];
int nIndexInMap = arNIndexInMap[nDeliveryIndex];

// check if the delivery is changed... if changed -> trigger the delivery items on the layout
int bNameChanged = FALSE;
if( _Map.hasString("PreviousDeliveryName") ){
	String sPreviousDeliveryName = _Map.getString("PreviousDeliveryName");
	if( sPreviousDeliveryName != sDeliveryName )
		bNameChanged = TRUE;
}
else{
	bNameChanged = TRUE;
}

// edit the current delivery
if( _kExecuteKey == arSTrigger[1] ){
	// edit current delivery
	Map mapIn = mapDelivery;
	// debug
	mapIn.writeToDxxFile("C:\\temp\\delivery.dxx");
	// get the delivery information
	Map mapOut = callDotNetFunction2(strAssemblyPath, strType, strFunction, mapIn);
	mapDelivery = mapOut;
	
	// store the delivery information
	_Map.appendMap("DELIVERY", mapOut);
	
	// remove the old one
	_Map.removeAt(nIndexInMap, FALSE);
	
	// trigger the delivery items
	bNameChanged = TRUE;
}

if( bNameChanged ){
	// update map first
	_Map.setString("PreviousDeliveryName", sDeliveryName);
	
	reportMessage(TN("|Recalculating the delivery items on the layouts|..."));
	
	Entity arEntTsl[] = Group().collectEntities(TRUE, TslInst(), _kAllSpaces);
	for( int i=0;i<arEntTsl.length();i++ ){
		TslInst tsl = (TslInst)arEntTsl[i];
		if( !tsl.bIsValid() )
			continue;
		
		if (tslsToRecalculate.find(tsl.scriptName()) != -1)
			tsl.recalc();
	}
	
	_ThisInst.recalc();
}


// information of this delivery
String sDeliveryDescr = arSDeliveryDescription[nDeliveryIndex];
sDeliveryDescription.set(sDeliveryDescr);

String sDeliveryDate = arSDeliveryDate[nDeliveryIndex];
String sDeliveryStatus = arSDeliveryStatus[nDeliveryIndex];
if( sDeliveryStatus == "False" )
	sDeliveryStatus = "";
else
	sDeliveryStatus = "Delivered";
//array used for displaying this information
String arSDeliveryInfo[] = {
	"Name;"+sDeliveryName,
	"Description;"+sDeliveryDescription
//	"Date;"+sDeliveryDate,
//	"K;"
};
int nrOfInfoItems = arSDeliveryInfo.length();

// display
Display dpTable(nColorTable);
Display dpContent(nColorContent);
dpContent.dimStyle(sDimStyle);

// row-height and column-width
double dRowHeight = 2.4 * dpContent.textHeightForStyle("DESCRIPTION", sDimStyle);
double dColumnWidth = 2.5 * dpContent.textLengthForStyle("DESCRIPTION", sDimStyle);

// table size
int nNrOfColumns = 3;
double dTableWidth = dColumnWidth * nNrOfColumns;

// header
Point3d ptReferenceTable = _Pt0;
PLine plRow(ptReferenceTable, ptReferenceTable + _XW *dTableWidth);
dpTable.draw(plRow);

// reference point for the content of this table
Point3d ptReferenceContent = _Pt0 + dRowHeight * .5 * (_XW-_YW);
dpContent.draw(sTableHeader, ptReferenceContent, _XW, _YW, 1, 0);
// draw double line under header
plRow.transformBy(-_YW * 0.90 * dRowHeight);
dpTable.draw(plRow);
plRow.transformBy(-_YW * 0.10 * dRowHeight);
dpTable.draw(plRow);

// move to next text position
ptReferenceContent -= _YW * dRowHeight;

// display delivery info
for( int i=0;i<nrOfInfoItems ;i++ ){
	String sDeliveryInfo = arSDeliveryInfo[i];
	Point3d ptText = ptReferenceContent;
	
	for( int j=0;j<2;j++ ){
		dpContent.draw(sDeliveryInfo.token(j), ptText, _XW, _YW, 1, 0);
		ptText += _XW * dColumnWidth;
	}
	
	ptReferenceContent -= _YW * dRowHeight;
}
// draw double line under delivery information
plRow.transformBy(-_YW * (nrOfInfoItems - 0.1) * dRowHeight);
dpTable.draw(plRow);
plRow.transformBy(-_YW * 0.10 * dRowHeight);
dpTable.draw(plRow);

Point3d ptGroupTable = ptReferenceTable - _YW * (nrOfInfoItems + 1) * dRowHeight;
Point3d ptContentTable;

PLine plColumn(ptReferenceTable, ptGroupTable);
dpTable.draw(plColumn);
plColumn.transformBy(_XW * dTableWidth);
dpTable.draw(plColumn);

// informtion of this group
int groupCount = 0;
for (int d=0;d<mapDelivery.length();d++) {
	if (!mapDelivery.hasMap(d) || mapDelivery.keyAt(d) != "DELIVERYGROUP")
		continue;
	
	Map mapDeliveryGroup = mapDelivery.getMap(d);
	String sDeliveryGroupName = mapDeliveryGroup.getString("NAME");
	int nDeliveryGroupAmount = mapDeliveryGroup.getInt("AMOUNT");
	String sDeliveryGroupStatus = mapDeliveryGroup.getString("DELIVERED");
	if( sDeliveryGroupStatus == "False" )
		sDeliveryGroupStatus = "Not delivered";
	else
		sDeliveryGroupStatus = "Delivered";
	// array used for displaying this information
	String arSGroupInfo[] = {
		"Group;" + sDeliveryGroupName,
		//"Status;" + sDeliveryGroupStatus,
		"Amount;"+ nDeliveryGroupAmount
	};
	int nrOfGroupInfoItems = arSGroupInfo.length();
	
	// information of the delivery items
	String arSDeliveryItemInfo[] = {
		"NAME;TYPE;AMOUNT"
	};
	for( int i=0;i<mapDeliveryGroup.length();i++ ){
		if( mapDeliveryGroup.hasMap(i) && mapDeliveryGroup.keyAt(i) == "DELIVERYITEM" ){
			Map mapDeliveryItem = mapDeliveryGroup.getMap(i);
			String sName = mapDeliveryItem.getString("NAME");
			String sProduced = mapDeliveryItem.getString("PRODUCED");
			if( sProduced == "False" )
				sProduced = "No";
			else
				sProduced = "Yes";
			String sDelivered = mapDeliveryItem.getString("DELIVERED");
			if( sDelivered == "False" )
				sDelivered = "No";
			else
				sDelivered = "Yes";
			String sType = mapDeliveryItem.getString("TYPE");
			int nAmount = mapDeliveryItem.getInt("AMOUNT");
			
			int nElementIndex = allElementNames.find(sName);
			if( nElementIndex == -1 )
				continue;
			
			Element el = allElements[nElementIndex];
			el.setQuantity(nAmount * nDeliveryGroupAmount);
			
			if( bHideWhenAmountIsZero && (nAmount * nDeliveryGroupAmount) == 0 )
				continue;
			
			arSDeliveryItemInfo.append(
				sName + ";" +
				//sProduced + ";" +
				//sDelivered + ";" +
				sType + ";" +
				nAmount
			);
		}
	}
	if (arSDeliveryItemInfo.length() == 1)
		continue;
	
	groupCount++;
	
	// display group information	
	for( int i=0;i<nrOfGroupInfoItems;i++ ){
		String sGroupInfo = arSGroupInfo[i];
		Point3d ptText = ptReferenceContent;
		
		for( int j=0;j<2;j++ ){
			dpContent.draw(sGroupInfo.token(j), ptText, _XW, _YW, 1, 0);
			ptText += _XW * dColumnWidth;
		}
		
		ptReferenceContent -= _YW *dRowHeight;
	}
	
	// draw double line above group information
	plRow.transformBy(-_YW * 0.1 * dRowHeight);
	if (groupCount > 0)
		dpTable.draw(plRow);
	plRow.transformBy(-_YW * (nrOfGroupInfoItems - 0.1) * dRowHeight);
	
	ptContentTable = ptGroupTable -_YW * nrOfGroupInfoItems * dRowHeight;
	plColumn = PLine(ptGroupTable, ptContentTable);
	dpTable.draw(plColumn);
	plColumn.transformBy(_XW * dTableWidth);
	dpTable.draw(plColumn);
	
	// Sort items by name
	for(int s1=1;s1<arSDeliveryItemInfo.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--){
			if( arSDeliveryItemInfo[s11].token(0) < arSDeliveryItemInfo[s2].token(0) ){
				arSDeliveryItemInfo.swap(s2, s11);
				s11=s2;
			}
		}
	}

	// display delivery item information
	for( int i=0;i<arSDeliveryItemInfo.length();i++ ){
		String sDeliveryItemInfo = arSDeliveryItemInfo[i];
		Point3d ptText = ptReferenceContent;
		
		Point3d nextRowPosition = ptContentTable - _YW * dRowHeight;
		plColumn = PLine(ptContentTable, nextRowPosition);
		ptContentTable = nextRowPosition;
		
		dpTable.draw(plColumn);
		
		// fill row
		for( int j=0;j<3;j++ ){
			dpContent.draw(sDeliveryItemInfo.token(j), ptText, _XW, _YW, 1, 0);
			ptText += _XW * dColumnWidth;
			
			plColumn.transformBy(_XW * dColumnWidth);
			dpTable.draw(plColumn);
		}
		plColumn.transformBy(-_XW * dTableWidth - _YW * dRowHeight);
		
		ptReferenceContent -= _YW * dRowHeight;
		
		// draw row
		if( i==0 ){
			plRow.transformBy(_YW * 0.1 * dRowHeight);
			dpTable.draw(plRow);
			plRow.transformBy(-_YW * 0.1 * dRowHeight);
			dpTable.draw(plRow);
		}
		else{
			dpTable.draw(plRow);
		}
		
		plRow.transformBy(-_YW *dRowHeight);
	}
	dpTable.draw(plRow);

	ptGroupTable = ptContentTable;
}


#End
#BeginThumbnail


















#End
#BeginMapX

#End