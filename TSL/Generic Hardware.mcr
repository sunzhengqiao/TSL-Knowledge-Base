#Version 8
#BeginDescription


0.12 6/6/2023 Added display options cc
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 12
#KeyWords 
#BeginContents
/*
<>--<>--<>--<>--<>--<>--<>--<>____ Craig Colomb _____<>--<>--<>--<>--<>--<>--<>--<>



//######################################################################################
//############################ Documentation #########################################

Purpose & Function

Map Descriptions

Requirements


//########################## End Documentation #########################################
//######################################################################################

                              craig.colomb@hsbcad.com
<>--<>--<>--<>--<>--<>--<>--<>_____ hsbcad.us  _____<>--<>--<>--<>--<>--<>--<>--<>

*/

//constants
int bIsMetricDwg = U(1, "mm") == 1;//__script units are inches
double dUnitConversion = bIsMetricDwg ? 1 : 1 / 25.4; //__mm to .dwg units
double dAreaConversion = pow(dUnitConversion, 2);
double dVolumeConversion = pow(dUnitConversion, 3);
double dEquivalientTolerance = .01;		
String stYN[] = { "No", "Yes"};
String stSpecial = projectSpecial();
int bInDebug = stSpecial == "db" || stSpecial == scriptName();
if(_bOnDebug) bInDebug = true;

String stDisplayModes[] = { "Series", "Cylinder", "Single Insert", "Box"};

PropString psDisplayMode(0, stDisplayModes, "Display Mode");
int bLineDisplay = psDisplayMode == stDisplayModes[0];
int bCylinderDisplay = psDisplayMode == stDisplayModes[1];
int bPointDisplay = psDisplayMode == stDisplayModes[2];
int bBoxDisplay = psDisplayMode == stDisplayModes[3];
String hardwareCategory = "Hardware Data";

PropString psArticleNumber(1, "", "Article Number");
psArticleNumber.setCategory(hardwareCategory);
PropString psDescription(2, "", "Description");
psDescription.setCategory(hardwareCategory);
PropString psManufacturer(3, "", "Manufacturer");
psManufacturer.setCategory(hardwareCategory);
PropString psModel(4, "", "Model");
psModel.setCategory(hardwareCategory);
PropString psMaterial(5, "", "Material");
psMaterial.setCategory(hardwareCategory);
PropString psCategory(6, "", "Category");
psCategory.setCategory(hardwareCategory);
PropString psGroup(7, "", "Group");
psGroup.setCategory(hardwareCategory);
PropString psNotes(8, "", "Notes");
psNotes.setCategory(hardwareCategory);

PropInt piQuantity(0, 0, "Quantity");
PropDouble pdSpacing(0, 0, "Spacing");
pdSpacing.setDescription("When Spacing > 0, Quantity is set automatically");
piQuantity.setDescription("When Spacing > 0, Quantity is set automatically");

piQuantity.setReadOnly(pdSpacing > 0);

PropDouble pdLength(1, U(12, "inch"), "Length");
pdLength.setCategory(hardwareCategory);
PropDouble pdWidth(2, U(1, "inch"), "Width/Diameter");
pdWidth.setCategory(hardwareCategory);
PropDouble pdHeight(3, U(1.5, "inch"), "Height/Thickness");
pdHeight.setCategory(hardwareCategory);

String displayCategory = "Display";
PropString psDimStyle(9, _DimStyles, "DimStyle");
psDimStyle.setDescription(displayCategory);
PropDouble pdTextH(4, 0, "Text Height");
pdTextH.setDescription(displayCategory);
PropInt piColor(1, 0, "Color");
piColor.setDescription(displayCategory);
PropDouble pdDisplayScale(5, 1, "Display Scale");
pdDisplayScale.setDescription(displayCategory);

Display dp(piColor);
dp.dimStyle(psDimStyle);
if (pdTextH > 0) dp.textHeight(pdTextH);

if(_bOnInsert)
{ 
	showDialogOnce();
	
	String stBlockPrompt = T("|Select Display Block ? |") + "[" + T("|Yes|") + "/" + T("|No|") + "]";
	String reply = getString(stBlockPrompt);
	if(reply == "") 
	{ 
		eraseInstance();
		return;
	}
	if (reply == "Y") _Map.setInt("doBlockSelection", 1);
	
	Point3d ptStartGrip = getPoint("Select Location");
	Point3d ptEndGrip;
	PrPoint prp("Select point to determine orientation/distribution", ptStartGrip);
	
	if (prp.go()) 
	{
		ptEndGrip = prp.value();
		Vector3d vGrip = ptEndGrip - ptStartGrip;
		_Map.setVector3d("vGrips", vGrip);
		
		_Pt0 = ptStartGrip + vGrip / 2;
		_PtG.append(ptStartGrip);
		_PtG.append(ptEndGrip);
	}
	else
	{ 
		eraseInstance();
		return;
	}
	
	
	Element el = getElement("Select Element (optional)");
	if (el.bIsValid()) _Element.append(el);
}



//region  Enable Block Display
//######################################################################################		
//######################################################################################	


		

int doBlockSelection = _Map.getInt("doBlockSelection");
String displayBlock = _Map.getString("displayBlock");

String stSelectBlockCommand = T("|Select Display Block|");
addRecalcTrigger(_kContextRoot, stSelectBlockCommand);

if(_kExecuteKey == stSelectBlockCommand || doBlockSelection)
{ 
	_Map.removeAt("doBlockSelection", 0);
	
	Map mpIn, mpItems;
	mpIn.setString("Title", "Select Block for Display");
			
	for (int i = 0; i < _BlockNames.length(); i++) 
	{	
		String stBlock = _BlockNames[i];
		if (stBlock.left(1) == "*") continue; //__skip anonymous blocks
		int isSelected = stBlock == displayBlock;
		mpItems.appendInt(stBlock, isSelected);
	}
	mpIn.setMap("Items[]", mpItems);
			
	String stDialogDllPath = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String stClass = "TslUtilities.DialogService";
	String stMethod = "SelectFromList";
	Map mpReturned = callDotNetFunction2(stDialogDllPath, stClass, stMethod, mpIn);
			
	String stSelectedBlock = mpReturned.getString("Selection");
	if (stSelectedBlock != "")//__user made selection, will be blank in case of cancel
	{
		_Map.setString("displayBlock", stSelectedBlock);
		displayBlock = stSelectedBlock;
	}
	
}




//######################################################################################
//######################################################################################	
//endregion End Enable Block Display 	

//region  Grip Management
//######################################################################################		
//######################################################################################	

Point3d& ptEndGrip = _PtG[1];
Point3d& ptStartGrip = _PtG[0];

Vector3d vGrips = ptEndGrip - ptStartGrip;
Vector3d vX = vGrips;
if(vX.length() < U(.1, "inch"))
{ 
	vGrips = _Map.getVector3d("vGrips");
	vGrips.normalize();
	ptEndGrip = _Pt0 + vGrips / 2;
	ptStartGrip  = _Pt0 - vGrips / 2;
}
vX.normalize();
Vector3d vZ = _ZE;
Vector3d vY = vZ.crossProduct(vX);
double dRunLength = vGrips.length();

String propLastChanged = _kNameLastChangedProp;
if(propLastChanged == "Length")
{ 
	if(pdLength > 0)
	{ 
		vGrips = vX * pdLength / 2;
		ptStartGrip = _Pt0 + vGrips;
		ptEndGrip = _Pt0 - vGrips;
	}
}

if(propLastChanged.left(4) == "_PtG")
{ 
	_Pt0 = ptStartGrip + vGrips / 2;
	pdLength.set(dRunLength);
}

//######################################################################################
//######################################################################################	
//endregion End Grip Management 			


//region  Display
//######################################################################################		
//######################################################################################	

double dArrowL = U(.75, "inch");
double dArrowW = U(.5, "inch");

LineSeg ls(ptStartGrip, ptEndGrip);
dp.draw(ls);
PLine plBase;
plBase.createCircle(_Pt0, vZ, dArrowW / 2);
dp.draw(plBase);

if(bLineDisplay)
{ 
	Vector3d vArrowR = - vX.rotateBy(30, vZ)*dArrowL;
	Vector3d vArrowL = - vX.rotateBy(-30, vZ)*dArrowL;
	
	PLine plArrowHead (ptEndGrip + vArrowL, ptEndGrip, ptEndGrip + vArrowR);
	dp.draw(plArrowHead);
	PLine plArrowTail (ptEndGrip + vArrowL*.8, ptEndGrip, ptEndGrip + vArrowR*.8);
	plArrowTail.transformBy(-vX * (dRunLength - dArrowW));
	dp.draw(plArrowTail);
	plArrowTail.transformBy(vX * dArrowW);
	dp.draw(plArrowTail);
}

if(bCylinderDisplay)//__cylinder
{ 
	Body bd (ptStartGrip, ptEndGrip, pdWidth / 2);
	dp.draw(bd);
	pdSpacing.set(0);
	piQuantity.set(1);
}

if(bPointDisplay)
{ 
	//__figure out quantities
	int iSpaceCount = 1;
	if(pdSpacing > 0)
	{ 
		iSpaceCount = dRunLength / pdSpacing;
		if (iSpaceCount == 0) iSpaceCount = 1;
	}
	
	int iHardwareCount = iSpaceCount <= 2 ? 1 : iSpaceCount - 1;
	piQuantity.set(iHardwareCount);
	
	Point3d ptsDisplay[0];
	
	if(iSpaceCount == 1)
	{ 
		ptsDisplay.append(_Pt0);
	}
	else
	{ 
		double dActualSpacing = dRunLength / iSpaceCount;
		for(int i=1; i<=iHardwareCount; i++)
		{
			Point3d pt = ptStartGrip + vX * dActualSpacing * i;
			ptsDisplay.append(pt);
		}
	}
	
	for(int i=0; i<ptsDisplay.length(); i++)
	{
		Point3d pt = ptsDisplay[i];
		if(bLineDisplay && displayBlock == "")
		{ 
			PLine pl;
			pl.createCircle(pt, vZ, pdWidth / 2);
			dp.draw(pl);
		}
		
		if(displayBlock != "")
		{ 
			Block bk(displayBlock);
			dp.draw(bk, pt, vX, vY, vZ);
		}
	}
}

if(bBoxDisplay)
{ 
	Point3d ptBoxMid = ls.ptMid();
	Body bdBox (ptBoxMid, vX, vY, vZ, pdWidth, pdLength, pdHeight);
	dp.draw(bdBox);
}


//######################################################################################
//######################################################################################	
//endregion End Display 			


//region  Record Hardware
//######################################################################################		
//######################################################################################	

HardWrComp hwcList[] = _ThisInst.hardWrComps();

HardWrComp hwc (_ThisInst.handle(), piQuantity);
psArticleNumber.set(_ThisInst.handle());
psArticleNumber.setReadOnly(true);

hwc.setDescription(psDescription);
hwc.setManufacturer(psManufacturer);
hwc.setModel(psModel);
hwc.setMaterial(psMaterial);
hwc.setCategory(psCategory);
hwc.setGroup(psGroup);
hwc.setNotes(psNotes);
hwc.setDScaleX(pdLength);
hwc.setDScaleY(pdWidth);
hwc.setDScaleZ(pdHeight);

if(hwcList.length() == 0)
{ 
	hwcList.append(hwc);
}
else
{ 
	hwcList[0] = hwc;
}

_ThisInst.setHardWrComps(hwcList);

//######################################################################################
//######################################################################################	
//endregion End Record Hardware 			

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
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Added display options" />
      <int nm="MAJORVERSION" vl="0" />
      <int nm="MINORVERSION" vl="12" />
      <str nm="DATE" vl="6/6/2023 3:59:14 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End