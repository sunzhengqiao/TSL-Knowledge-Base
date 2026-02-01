#Version 8
#BeginDescription
#Versions
Version 1.1 13.09.2023 HSB-20054 new option on insert to keep zone assignment over multiple elements

This tsl allows the user to assign one or more entities to a specific element.

Select an element
Select one or more entities
Specify the zone index, zone character and decide if it is an exclusive assignment or not.
The entities are assigned to the specified zone (index + character) The tsl will be erased from the drawing after execution.


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.1 13.09.2023 HSB-20054 new option on insert to keep zone assignment over multiple elements , Author Thorsten Huck

/// <insert Lang=en>
/// Select element (optional) and entities to assign
/// </insert>

// <summary Lang=en>
// This tsl assigns entities to a selected zone
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "HSB-AssignENtities")) TSLCONTENT

//endregion



int arNTrueFalse[] = {TRUE, FALSE};
String arSYesNo[] = {T("Yes"), T("No")};
PropString sExclusive(0, arSYesNo, T("Add exclusive"));
int bExclusive = arNTrueFalse[arSYesNo.find(sExclusive,0)];

int arNZoneIndex[] = {0,1,2,3,4,5,6,7,8,9,10};
PropInt nZnIndex(0,arNZoneIndex,T("Zone index"),0);

String arSZoneCharacter[] = {
	"'E' for element tools",
	"'Z' for general items",
	"'T' for beam tools",
	"'I' for information",
	"'C' for construction",
	"'D' for dimension"
};
char arCZoneCharacter[] = {
	'E',
	'Z',
	'T',
	'I',
	'C',
	'D'
};
PropString sZoneCharacter(1,arSZoneCharacter,T("Zone character"));
char cZoneCharacter = arCZoneCharacter[arSZoneCharacter.find(sZoneCharacter,0)];

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB-AssignEntitiesToZone");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if (insertCycleCount() > 1){
		eraseInstance();
		return;
	}

	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();

// prompt for elements
	PrEntity ssEL(T("|Select the element to assign entities to|") + T(", <|Enter|> to keep current element association"), Element());
  	if (ssEL.go())
		_Element.append(ssEL.elementSet());

	PrEntity ssE(T("|Select entities|"),Entity());	
	if( ssE.go() )
		_Entity.append(ssE.set());
	
	return;
}

// Get Zone and element
	int nZoneIndex = nZnIndex;
	if( nZoneIndex > 5 )
		nZoneIndex = 5 - nZoneIndex;

// Loop entities
	for( int i=0;i<_Entity.length();i++ )
	{
		Entity ent = _Entity[i];
		Element el = ent.element();
		if( ent == el){continue;}
		
		if (_Element.length()>0)
			el = _Element[0];
		
		if (el.bIsValid())
			ent.assignToElementGroup(el, bExclusive, nZoneIndex, cZoneCharacter);
	}

eraseInstance();


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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20054 new option on insert to keep zone assignment over multiple elements" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="9/13/2023 3:19:30 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End