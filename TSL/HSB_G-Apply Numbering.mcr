#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
16.11.2012  -  version 1.00

Only works for beams and sheets which are attached to an element.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Apply numbering
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// Only works for beams and sheets which are attached to an element.
/// </remark>

/// <version  value="1.00" date="16.11.2012"></version>

/// <history>
/// AS - 1.00 - 16.11.2012 - 	Pilot version
/// </hsitory>

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

String arSInsertType[] = {
	T("|Select all elements in drawing|"),
	T("|Select floor level in floor level list|"),
	T("|Select current floor level|"),
	T("|Select elements in drawing|")
};

PropString sSeperator01(0, "", T("|Selection|"));
sSeperator01.setReadOnly(true);
PropString sInsertType(1, arSInsertType, "     "+T("|Elements to export|"),3);

// Get the available catalog names.
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_G-Apply Numbering");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

// Insert to show the dialog and select the insert type.
if( _bOnInsert ){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
}

// Set the selected insert type.
int nInsertType = arSInsertType.find(sInsertType, 3);
sInsertType.setReadOnly(true);

// List of available floorgroups
String arSNameFloorGroup[] = {""};
Group arFloorGroup[0];
Group arAllGroups[] = Group().allExistingGroups();
for( int i=0;i<arAllGroups.length();i++ ){
	Group grp = arAllGroups[i];
	if( grp.namePart(2) == "" && grp.namePart(1) != ""){
		arSNameFloorGroup.append(grp.name());
		arFloorGroup.append(grp);
	}
}
PropString sNameFloorGroup(2, arSNameFloorGroup, "     "+"|Floorgroup|",0);
if( nInsertType != 1 )
	sNameFloorGroup.setReadOnly(true);

PropString sSeperator02(3, "", T("|Numbering|"));
sSeperator02.setReadOnly(true);\
PropString sKeepExisting(4, arSYesNo, "     "+T("|Keep existing numbers|"));

PropString sLabel01(5, "", "     "+T("|Label| 01"));
PropInt nStartAt01(0, 0, "     "+T("|Start at| 01"));

PropString sLabel02(6, "", "     "+T("|Label| 02"));
PropInt nStartAt02(1, 0, "     "+T("|Start at| 02"));

// Ask the user to perform the choosen type of selection.
if( _bOnInsert ){
	if( (_kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1) )
		showDialog(); 
	
	Entity arEntSelected[0];
	if( nInsertType == 0 ){//Select all elements
		arEntSelected.append(Group().collectEntities(true, Element(), _kModelSpace));
	}
	else if( nInsertType == 1 ){//Select floor level in floor level list
		Group grpFloor = arFloorGroup[arSNameFloorGroup.find(sNameFloorGroup,1) - 1];
		arEntSelected.append(grpFloor.collectEntities(true, Element(), _kModelSpace));
	}
	else if( nInsertType == 2 ){//Select current group
		Group grpCurrent = _kCurrentGroup;
		if( grpCurrent.namePart(2) == "" && grpCurrent.namePart(1) != "" )
			arEntSelected.append(grpCurrent.collectEntities(true, Element(), _kModelSpace)); 
	}
	else{
		PrEntity ssE(T("|Select one or more elements|"), Element());
		if( ssE.go() )
			arEntSelected.append(ssE.set());
	}
	for( int i=0;i<arEntSelected.length();i++ ){
		Entity ent = arEntSelected[i];
		Element el = (Element)ent;
		
		if( el.bIsValid() )
			_Entity.append(el);
	}
	
	return;
}
reportMessage (T("\n|Number of elements selected:| ") + _Entity.length()+"\n");


// Resolve properties
int bKeepExisting = arNYesNo[arSYesNo.find(sKeepExisting,0)];

String arSLabel01[0];
String sList = sLabel01 + ";";
sList.makeUpper();
int nIndexList = 0; 
int sIndexList = 0;
while(sIndexList < sList.length()-1){
	String sToken = sList.token(nIndexList);
	nIndexList++;
	if(sToken.length()==0){
		sIndexList++;
		continue;
	}
	sIndexList = sList.find(sToken,0);

	arSLabel01.append(sToken);
}

String arSLabel02[0];
sList = sLabel02 + ";";
sList.makeUpper();
nIndexList = 0; 
sIndexList = 0;
while(sIndexList < sList.length()-1){
	String sToken = sList.token(nIndexList);
	nIndexList++;
	if(sToken.length()==0){
		sIndexList++;
		continue;
	}
	sIndexList = sList.find(sToken,0);

	arSLabel02.append(sToken);
}

// Start numbering

for( int e=0;e<_Entity.length();e++ ){
	Entity ent = _Entity[e];
	Element el = (Element)ent;
	
	GenBeam arGBm[] = el.genBeam();
	for( int i=0;i<arGBm.length();i++ ){
		GenBeam gBm = arGBm[i];
		String sLabel = gBm.label();
		sLabel.trimLeft();
		sLabel.trimRight();
		
		if( !bKeepExisting )
			gBm.releasePosnum(true);
		
		int bGBmFound = false;
		for( int j=0;j<arSLabel01.length();j++ ){
			String sLbl = arSLabel01[j];
			String sLblTrimmed = sLbl;
			sLblTrimmed.trimLeft("*");
			sLblTrimmed.trimRight("*");
			if( sLblTrimmed == "" )
				continue;
			if( sLbl.left(1) == "*" && sLbl.right(1) == "*" && sLabel.find(sLblTrimmed, 0) != -1 )
				bGBmFound = true;
			else if( sLbl.left(1) == "*" && sLabel.right(sLbl.length() - 1) == sLblTrimmed )
				bGBmFound = true;
			else if( sLbl.right(1) == "*" && sLabel.left(sLbl.length() - 1) == sLblTrimmed )
				bGBmFound = true;
		}		
		if( bGBmFound ){
			gBm.releasePosnum(true);
			gBm.assignPosnum(nStartAt01);
			continue;
		}
		
		for( int j=0;j<arSLabel02.length();j++ ){
			String sLbl = arSLabel02[j];
			String sLblTrimmed = sLbl;
			sLblTrimmed.trimLeft("*");
			sLblTrimmed.trimRight("*");
			if( sLblTrimmed == "" )
				continue;
			if( sLbl.left(1) == "*" && sLbl.right(1) == "*" && sLabel.find(sLblTrimmed, 0) != -1 )
				bGBmFound = true;
			else if( sLbl.left(1) == "*" && sLabel.right(sLbl.length() - 1) == sLblTrimmed )
				bGBmFound = true;
			else if( sLbl.right(1) == "*" && sLabel.left(sLbl.length() - 1) == sLblTrimmed )
				bGBmFound = true;
		}		
		if( bGBmFound ){
			gBm.releasePosnum(true);
			gBm.assignPosnum(nStartAt02);
			continue;
		}
		
		gBm.assignPosnum(0);
	}
}
#End
#BeginThumbnail

#End
