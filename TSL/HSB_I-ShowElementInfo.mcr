#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
13.03.2019 - version 1.04

Displays element's basic info + custom text
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
//region History and versioning
/// <summary Lang=en>
/// Displays element's basic info
/// </summary>

/// <insert>
/// Select element(s)
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <history>
/// DR - 1.00 - 15.05.2017	- Pilot version
/// DR - 1.01 - 18.05.2017	- Added several props.
/// DR - 1.02 - 18.05.2017	- Element's basic measures valid for roof elements
/// DR - 1.03 - 13.06.2017	- Added visibility on top view yes/no. Added new lines for tokens at custom text prop.
/// DR - 1.04 - 13.03.2019	- Element's type, code and number now can be turn on/off individually
/// </history>
//endregion

Unit (1,"mm");

String sNoYes[]= {T("|No|"),T("|Yes|")};
String sAlignments[]= { T("|Centered|"),T("|Right|"),T("|Left|")};

String sCategory_Info= T("|Information|");
PropString sShowType( 7, sNoYes, T("|Element type|"),1);
sShowType.setCategory(sCategory_Info);
PropString sShowCode( 9, sNoYes, T("|Element code|"),1);
sShowCode.setCategory(sCategory_Info);
PropString sShowNumber( 10, sNoYes, T("|Element number|"),1);
sShowNumber.setCategory(sCategory_Info);
PropString sCustomText(4,"", T("|Custom text|"));
sCustomText.setCategory(sCategory_Info);
sCustomText.setDescription(T("|Text separated by semicolon will be displayed on a new line|"));
PropString sShowDefinition(2, sNoYes, T("|Definition|"),1);
sShowDefinition.setCategory(sCategory_Info);
PropString sShowQuantity(8, sNoYes, T("|Quantity|"),0);
sShowQuantity.setCategory(sCategory_Info);
PropString sShowEnvelopeLines(1, sNoYes, T("|Element box|"),0);
sShowEnvelopeLines.setCategory(sCategory_Info);
PropString sShowPointer(6, sNoYes, T("|Pointer|"),0);
sShowPointer.setCategory(sCategory_Info);

String sCategory_DisplaySettings= T("|Display settings|");
PropString sVisibleOnTopViewOnly(11, sNoYes, T("|Visible on top view only|"),0);
sVisibleOnTopViewOnly.setCategory(sCategory_DisplaySettings);
PropString sInvertOrder(3, sNoYes, T("|Invert text order|"), 0);
sInvertOrder.setCategory(sCategory_DisplaySettings);
PropString sAlignment(5, sAlignments, T("|Alignment|"),0);
sAlignment.setCategory(sCategory_DisplaySettings);
PropString dimStyle(0, _DimStyles, T("|Dimension style|"));
dimStyle.setCategory(sCategory_DisplaySettings);
PropDouble textSize(0, U(100), T("|Text size|"));
textSize.setCategory(sCategory_DisplaySettings);
PropInt textColor(0, 0, T("|Text color|"));
textColor.setCategory(sCategory_DisplaySettings);

// Set properties if inserted with an execute key
String sCatalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( sCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) 
{
	if (insertCycleCount() > 1) 
	{
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || sCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();

	setCatalogFromPropValues(T("_LastInserted"));

	String strScriptName = scriptName();
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Beam lstBeams[0];
	Entity lstEntities[1];
	Map mapTsl;
	mapTsl.setInt("ManualInserted", true);
	
	//region Select element(s), clone instance per each one
	Element  selectedElements[0];
	PrEntity ssE(T("|Select elements|"), Element());
	if (ssE.go())
		selectedElements.append(ssE.elementSet());
	
	for (int e=0;e<selectedElements.length();e++)
	{
		Element selectedElement = selectedElements[e];
		if (!selectedElement.bIsValid())
			continue;
		
		lstEntities[0] = selectedElement;
		
		TslInst tslNew;
		tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	}
	//endregion
	
	eraseInstance();
	return;
}

//region set properties from master, set manualInserted=true if case
int manualInserted = false;
if (_Map.hasInt("ManualInserted")) 
{
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

// set properties from catalog
if (_bOnDbCreated && manualInserted)
	setPropValuesFromCatalog(T("|_LastInserted|"));
//endregion

//region Resolve properties
int showType= sNoYes.find(sShowType);
int showCode=sNoYes.find(sShowCode);
int showNumber=sNoYes.find(sShowNumber);
int showDefinition= sNoYes.find(sShowDefinition);
int showQty= sNoYes.find(sShowQuantity);
int showEnvelopeLines= sNoYes.find(sShowEnvelopeLines);
int showPointer= sNoYes.find(sShowPointer);
int inverOrder= sNoYes.find(sInvertOrder);
int alignment= sAlignments.find(sAlignment);
int bVisibleOnTopViewOnly= sNoYes.find(sVisibleOnTopViewOnly,0);
//endregion

//region Element validation and basic info
if( _Element.length() != 1 )
{
 	eraseInstance();
 	return;
}

Element el = _Element[0];
if (!el.bIsValid())
{
	eraseInstance();
	return;
}

CoordSys csEl = el.coordSys();
Point3d ptElOrg = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

LineSeg ls=el.segmentMinMax();
double dElLength=abs(vxEl.dotProduct(ls.ptStart()-ls.ptEnd()));
double dElHeight= abs(vyEl.dotProduct(ls.ptStart()-ls.ptEnd()));
double dElWidth=abs(vzEl.dotProduct(ls.ptStart()-ls.ptEnd()));

Point3d ptElBackTopRight= ptElOrg+vxEl*dElLength+vyEl*dElHeight-vzEl*dElWidth;
Point3d ptElCenter= ptElOrg+vxEl*dElLength*.5+vyEl*dElHeight*.5-vzEl*dElWidth*.5; // 3D center of whole body

Line lnX(ptElOrg, vxEl);
Line lnY(ptElOrg, vyEl);
Line lnZ(ptElOrg, vzEl);

assignToElementGroup(el, 1, 0, 'I');
setDependencyOnEntity(el);
//endregion

if(_bOnDbCreated || manualInserted)
{
	_Pt0=ptElCenter;
}

if(_PtG.length()==0)
{
	_PtG.append(ptElCenter- vzEl*dElWidth*2);
}
_Pt0+=vyEl*vyEl.dotProduct(ptElOrg-_Pt0);
_PtG[0]+=vyEl*vyEl.dotProduct(ptElOrg-_PtG[0]);
assignToElementGroup(el, true, 0, 'T');

Display display(textColor);
display.dimStyle(dimStyle);
if (textSize > 0)
	display.textHeight(textSize);
if(bVisibleOnTopViewOnly)
	display.addViewDirection(vzEl);

Point3d ptTextLocation= _PtG[0];
Vector3d vTextDirection = vzEl;
Vector3d vTextUpDirection = vyEl;
int dTextSpacing=3;
if(inverOrder)
	dTextSpacing= -dTextSpacing;
int nLineNumber=0;

String text;
if(showType)
{ 
	text = T("|Element|"); // default to be replaced
	
	ElementWall elementWall = (ElementWall )el;
	ElementRoof elementRoof = (ElementRoof)el;
	
	if(elementWall.bIsValid())
		text = T("|Wall|");
	else if(elementRoof.bIsValid())
	{ 
		if(elementRoof.bIsAFloor())
			text = T("|Floor|");
		else
			text = T("|Roof|");
	}
}
if(showCode)
{ 
	if(showType)
		text += "-";
		
	text += el.code();
}
if(showNumber)
{ 
	if(showType || showCode)
		text += "-";
		
	text += el.number();
}

if(showType || showCode || showNumber)
	display.draw(text, ptTextLocation, vTextDirection, vTextUpDirection, alignment, dTextSpacing*nLineNumber, 2); nLineNumber++;

//aa
if(sCustomText != "")
{
	String tokens[0];
	String list = (sCustomText + ";");
	int caseSensitive = false;
	if (!caseSensitive)
		list.makeUpper();
	int tokenIndex = 0; 
	int characterIndex = 0;
	while(characterIndex < list.length()-1){
		String listItem = list.token(tokenIndex,";");
		tokenIndex++;
		if(listItem.length()==0){
			characterIndex++;
			continue;
		}
		characterIndex = list.find(listItem,0);
		listItem.trimLeft();
		listItem.trimRight();
		tokens.append(listItem);
	}
	
	for (int s=0;s<tokens.length();s++) 
	{ 
		text= tokens[s];
		display.draw(text, ptTextLocation, vTextDirection, vTextUpDirection, alignment, dTextSpacing*nLineNumber, 2); nLineNumber++;			 
	}
	
}
if(showDefinition)
{
	text= T("|Definition:| ") +el.definition();
	display.draw(text, ptTextLocation, vTextDirection, vTextUpDirection, alignment, dTextSpacing*nLineNumber, 2); nLineNumber++;	
}
if(showQty)
{
	text= T("|Quantity:| ") +el.quantity();
	display.draw(text, ptTextLocation, vTextDirection, vTextUpDirection, alignment, dTextSpacing*nLineNumber, 2); nLineNumber++;	
}
if(showPointer)
{ 
	PLine plPointer(_Pt0, ptTextLocation);
	display.draw(plPointer);
}
if(showEnvelopeLines)
{ 
	PLine plEl= el.plEnvelope();
	display.draw(plEl);
	PLine plElOutline= el.plOutlineWall();
	display.draw(plElOutline);
}

// Never get this 2 at same location
if((_Pt0-_PtG[0]).length()<U(1))
{
	_PtG[0]=_Pt0+(_Pt0-_PtG[0])*U(50);
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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End