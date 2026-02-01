#Version 8
#BeginDescription
Last modified by: Anno Sportel (annosportel@hsbcad.com)
27.05.2016  -  version 2.02


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 2
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

/// <version  value="2.02" date="27.05.2016"></version>

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
/// </history>

//Used for logging
int nLogLevel = 0;

String arSTrigger[] = {
	T("Create a new delivery"),
	T("Edit the current delivery")
};
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );

// data needed for the delivery program
String strAssemblyPath = _kPathHsbInstall + "\\Custom\\CDDelivery\\hsbTslDelivery.dll";
String strType = "hsbTslDelivery.LoadTsl";
String strFunction = "LoadFromTsl";


// delivery item information on layout
String sScriptnameDeliveryItem = "HSB-DeliveryItem";

//Dimension style
PropString sDimStyle(0, _DimStyles, T("Dimension style"));

PropInt nColorTable(0, -1, T("|Color table|"));
PropInt nColorContent(1, 5, T("|Color content|"));

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};
PropString sHideWhenZero(3, arSYesNo, T("|Hide when amount is '0'|"));

int nDefaultAmount = 1;
String sTableHeader = "HSB-HsbDelivery";

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
			if( tsl.scriptName() == "HSB-HsbDelivery" ){
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

Map mapXDelivery;
mapXDelivery.setString("Delivery", sDeliveryName);
mapXDelivery.setString("DeliveryDescription", sDeliveryDescription);
setSubMapXProject("Hsb_Delivery", mapXDelivery);

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
	
	reportMessage(TN("|Trigger delivery items on layout|"));
	
	Entity arEntTsl[] = Group().collectEntities(TRUE, TslInst(), _kAllSpaces);
	for( int i=0;i<arEntTsl.length();i++ ){
		TslInst tsl = (TslInst)arEntTsl[i];
		if( !tsl.bIsValid() )
			continue;
		
		if( tsl.scriptName() == sScriptnameDeliveryItem )
			tsl.transformBy(_XW *0);
	}
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