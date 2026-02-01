#Version 8
#BeginDescription
#Versions:
1.3 03.06.2022 HSB-14882: Dont allow empty format Author: Marsel Nakuci
1.2 08.04.2022 HSB-14881: Add setDefinesFormat for the property Author: Marsel Nakuci
1.1 01.04.2022 HSB-14863: Satosh: Fix bug for 0 depth (all through) Author: Marsel Nakuci
version value="1.0" date="16nov20" author="marsel.nakuci@hsbcad.com"

HSB-9290: initial

This tsl creates drills at Log walls

Select wall, pick insertion point of drill, select properties or catalog entry and press OK





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <History>//region
/// #Versions:
// 1.3 03.06.2022 HSB-14882: Dont allow empty format Author: Marsel Nakuci
// 1.2 08.04.2022 HSB-14881: Add setDefinesFormat for the property Author: Marsel Nakuci
// 1.1 01.04.2022 HSB-14863: Satosh: Fix bug for 0 depth (all through) Author: Marsel Nakuci
/// <version value="1.0" date="16nov20" author="marsel.nakuci@hsbcad.com"> HSB-9290: initial </version>
/// </History>

/// <insert Lang=en>
/// Select wall, pick insertion point of drill, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates drills at Log walls
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "ScriptName")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
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
//end Constants//endregion

//region properties
	category = T("|Geometry|");
	String sDiameterName=T("|Diameter|");	
	PropDouble dDiameter(nDoubleIndex++, U(50), sDiameterName);	
	dDiameter.setDescription(T("|Defines the Diameter|"));
	dDiameter.setCategory(category);
	
	category = T("|Alignment|");
	String sOffsetAxisName=T("|Axis Offset|");	
	PropDouble dOffsetAxis(nDoubleIndex++, U(0), sOffsetAxisName);	
	dOffsetAxis.setDescription(T("|Defines the Axis Offset of the drill|"));
	dOffsetAxis.setCategory(category);
	// start height
	String sHeightStartName=T("|Start Height|");
	PropDouble dHeightStart(nDoubleIndex++, U(0), sHeightStartName);	
	dHeightStart.setDescription(T("|Defines the HeightStart|"));
	dHeightStart.setCategory(category);
	// end height
	String sHeightEndName=T("|End Height|");	
	PropDouble dHeightEnd(nDoubleIndex++, U(0), sHeightEndName);	
	dHeightEnd.setDescription(T("|Defines the HeightEnd|"));
	dHeightEnd.setCategory(category);
	
	category = T("|Display|");
	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "coordDim\P@(coordDim)", sFormatName);	
	sFormat.setDescription(T("|Defines the text and/or attributes.|") + " " + T("|Multiple lines are separated by a backslash|") 
			+ " '\'" + " " + T("|Attributes can also be added or removed by context commands.|"));
	sFormat.setCategory(category);
	// dimstyle
	String sDimStyleName=T("|DimStyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the DimStyle|"));
	sDimStyle.setCategory(category);
//End properties//endregion 
	
//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
	// standard dialog	
		else	
			showDialog();
		
		// prepare tsl cloning
		// create TSL
		TslInst tslNew;			Vector3d vecXTsl= _XW;		Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};	Entity entsTsl[1];			Point3d ptsTsl[] = {_Pt0};
		int nProps[]={};		double dProps[]={dDiameter, dOffsetAxis, dHeightStart, dHeightEnd};		
		String sProps[] ={ sFormat, sDimStyle};
		Map mapTsl;	
						
		// prompt wall selection
		int iCountWall;
		while (iCountWall < 100)
		{
			// prompt wall selection
			Element el = getElement(T("|Select ElementLog|"));
			
			ElementLog eLog = (ElementLog) el;
			if(!eLog.bIsValid())
			{ 
				// 
				reportMessage(TN("|no valid ElementLog entity|"));
				continue;
			}
			entsTsl[0] = eLog;
			int iCountPoint;
			while(iCountPoint<100)
			{ 
			// prompt for point input
				Point3d pt;
				PrPoint ssP(TN("|Select point for drill|")); 
				if (ssP.go()==_kOk) 
					pt=(ssP.value()); // append the selected points to the list of grippoints _PtG
				else
					break;
				ptsTsl[0] = pt;
				// clone tsl
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
		}
		
		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion

if(_Element.length()==0)
{ 
	reportMessage(TN("|unexpected at least one wall needed|"));
	eraseInstance();
	return;
}

ElementLog eLog = (ElementLog)_Element[0];
if ( ! eLog.bIsValid())
{ 
	// 
	reportMessage(TN("|ElementLog is needed|"));
	eraseInstance();
	return;
}
assignToElementGroup(eLog, true, 0, 'E');
Point3d ptOrg = eLog.ptOrg();
Vector3d vecX = eLog.vecX();
Vector3d vecY = eLog.vecY();
Vector3d vecZ = eLog.vecZ();
vecX.vis(ptOrg, 1);
vecY.vis(ptOrg, 2);
vecZ.vis(ptOrg, 3);
// get zone 0
ElemZone eZone0 = eLog.zone(0);
Point3d ptMid = .5*(eZone0.ptOrg() + eZone0.ptOrg() + eZone0.vecZ() * eZone0.dH());
ptMid.vis(6);

Plane pn0(ptOrg, vecZ);
GenBeam gbs[] = eLog.genBeam();
PlaneProfile ppEnvelopeAll(eLog.coordSys());
for (int i=0;i<gbs.length();i++) 
{ 
	gbs[i].envelopeBody().vis(1);
	ppEnvelopeAll.unionWith(gbs[i].envelopeBody().shadowProfile(pn0));
}//next i

ppEnvelopeAll.vis(2);
ptOrg.vis(2);

PlaneProfile ppEnvelope(eLog.coordSys());
ppEnvelope.joinRing(eLog.plEnvelope(), _kAdd);
ppEnvelope.vis(4);
//_Pt0 = ptOrg;

// most bottom point
Point3d ptBottom;
Point3d ptTop;
{ 
// get extents of profile
	LineSeg seg = ppEnvelopeAll.extentInDir(vecX);
	ptBottom = seg.ptStart();
	ptTop = seg.ptEnd();
	if (vecY.dotProduct(ptBottom - seg.ptEnd()) > 0)
	{
		ptBottom = seg.ptEnd();
		ptTop = seg.ptStart();
	}
}
ptBottom.vis(4);

Plane pnDrill(ptMid + vecZ * dOffsetAxis, vecZ);
Line lnHor(ptMid + vecZ * dOffsetAxis, vecX);
_Pt0 = pnDrill.closestPointTo(_Pt0);
//_Pt0 = lnHor.closestPointTo(_Pt0);
//if(_kNameLastChangedProp=="_Pt0")
//{ 
//	_Pt0 = Line(.5 * (_PtG[0] + _PtG[1]), vecX).closestPointTo(_Pt0);
////	_ThisInst.recalc();
//	setExecutionLoops(2);
//	return;
//}
//if(_PtG.length()>1)
//{ 
//	_Pt0 = Line(.5 * (_PtG[0] + _PtG[1]), vecX).closestPointTo(_Pt0);
//}
//_ThisInst.setAllowGripAtPt0(false);
//

Point3d ptStart = ptBottom + vecX * vecX.dotProduct(_Pt0 - ptBottom);
ptStart += vecY * dHeightStart;
if(dHeightStart==0)
{
	ptStart += vecY * vecY.dotProduct((ptBottom - vecY * dEps) - ptStart);
}
ptStart = pnDrill.closestPointTo(ptStart);
Point3d ptEnd = ptBottom + vecX * vecX.dotProduct(_Pt0 - ptBottom);
ptEnd += vecY * dHeightEnd;

if(dHeightEnd==0)
{
	// Satoshi:HSB-14863
	ptEnd += vecY * vecY.dotProduct((ptTop + vecY * dEps) - ptEnd);
}
ptEnd = pnDrill.closestPointTo(ptEnd);

//
if(_kNameLastChangedProp=="_Pt0")
{ 
	_PtG[0] = ptStart;
	_PtG[1] = ptEnd;
}

//
Line lnDrill(ptStart, vecY);
if (_PtG.length() == 0)_PtG.append(ptStart);
if (_PtG.length() < 2)_PtG.append(ptEnd);
// 
_PtG[0] = lnDrill.closestPointTo(_PtG[0]);
_PtG[1] = lnDrill.closestPointTo(_PtG[1]);

if (_kNameLastChangedProp == sHeightStartName || _kNameLastChangedProp == sHeightEndName)
{ 
	//set ptg[0] and ptg[1]
	_PtG[0] = ptStart;
	_PtG[1] = ptEnd;
}
if(_kNameLastChangedProp=="_PtG0" || _kNameLastChangedProp=="_PtG1")
{ 
	
	ptStart += vecY * vecY.dotProduct(_PtG[0] - ptStart);
	ptEnd += vecY * vecY.dotProduct(_PtG[1] - ptEnd);
	dHeightStart.set(vecY.dotProduct(ptStart - ptBottom));
	dHeightEnd.set(vecY.dotProduct(ptEnd - ptBottom));
}

// get the genbeam where the point is located
int iPtSartFixed, iPtEndFixed;
for (int i=0;i<gbs.length();i++) 
{ 
	PlaneProfile pp(pnDrill);
	pp.unionWith(gbs[i].envelopeBody().shadowProfile(pnDrill));
	
	if((pp.pointInProfile(ptStart)==_kPointInProfile || pp.pointInProfile(ptStart)==_kPointOnRing) && !iPtSartFixed)
	{ 
		// genBeam found
	// get extents of profile
		LineSeg segBeam = pp.extentInDir(vecX);
		Point3d ptBottBeam = segBeam.ptStart();
		if (vecY.dotProduct(ptBottBeam - segBeam.ptEnd()) > 0)ptBottBeam = segBeam.ptEnd();
		ptStart += vecY * vecY.dotProduct(ptBottBeam - ptStart);
		iPtSartFixed = true;
	}
	if((pp.pointInProfile(ptEnd)==_kPointInProfile || pp.pointInProfile(ptEnd)==_kPointOnRing)&& !iPtEndFixed)
	{ 
		// genBeam found
	// get extents of profile
		LineSeg segBeam = pp.extentInDir(vecX);
		Point3d ptTopBeam = segBeam.ptStart();
		if (vecY.dotProduct(ptTopBeam - segBeam.ptEnd()) < 0)ptTopBeam = segBeam.ptEnd();
		ptEnd += vecY * vecY.dotProduct(ptTopBeam - ptEnd);
		iPtEndFixed = true;
	}
	if (iPtSartFixed && iPtEndFixed) break;
}//next i

// add Drill
Drill dr(ptStart, ptEnd, dDiameter / 2);
dr.cuttingBody().vis(4);
dr.addMeToGenBeams(gbs);

ptStart.vis(5);
ptEnd.vis(5);

String sCoordDim = "coordDim";
double dCoordDim = vecX.dotProduct(ptStart - ptBottom);
String sObjectVariables[] = _ThisInst.formatObjectVariables();

// additional map for coordDim
Map mAdd;
mAdd.setDouble("coordDim", dCoordDim);
sFormat.setDefinesFormatting(_ThisInst, mAdd);

//region Add custom variables for format resolving
	// adding custom variables or variables which are currently not supported by core
	String sCustomVariables[] ={ sCoordDim};
	String sCustomValues[] ={ dCoordDim};
	
	for (int i = 0; i < sCustomVariables.length(); i++)
	{ 
		String k = sCustomVariables[i];
		if (sObjectVariables.find(k) < 0)
			sObjectVariables.append(k);
	}	
	
// get translated list of variables
	String sTranslatedVariables[0];
	for (int i = 0; i < sObjectVariables.length(); i++)
		sTranslatedVariables.append(T("|" + sObjectVariables[i] + "|"));
	
// order both arrays alphabetically
	for (int i = 0; i < sTranslatedVariables.length(); i++)
		for (int j = 0; j < sTranslatedVariables.length() - 1; j++)
			if (sTranslatedVariables[j] > sTranslatedVariables[j + 1])
			{
				sObjectVariables.swap(j, j + 1);
				sTranslatedVariables.swap(j, j + 1);
			}
//End add custom variables//endregion 
	Entity ents[0];
	ents.append(eLog);

////region Trigger AddRemoveFormat
//	String sTriggerAddRemoveFormat = T("|Add/Remove Format|");
//	addRecalcTrigger(_kContext, "../"+sTriggerAddRemoveFormat );
//	if (_bOnRecalc && (_kExecuteKey=="../"+sTriggerAddRemoveFormat || _kExecuteKey==sTriggerAddRemoveFormat))
//	{
//		String sPrompt;
////		if (bHasSDV && entsDefineSet.length()<1)
////			sPrompt += "\n" + T("|NOTE: During a block setup only limited properties are accesable, but you can enter \nany valid format expression or use custom catalog entries.|");
//		sPrompt+="\n"+ T("|Select a property by index to add or to remove|") + T(" ,|-1 = Exit|");
//		reportNotice(sPrompt);
//		
//		for (int s=0;s<sObjectVariables.length();s++) 
//		{ 
//			String key = sObjectVariables[s]; 
//			String keyT = sTranslatedVariables[s];
//			String sValue;
//			for (int j=0;j<ents.length();j++) 
//			{ 
//				String _value = ents[j].formatObject("@(" + key + ")");
//				if (_value.length()>0)
//				{ 
//					sValue = _value;
//					break;
//				}
//			}//next j
//
//			//String sSelection= sFormat.find(key,0, false)<0?"" : T(", |is selected|");
//			String sAddRemove = sFormat.find(key,0, false)<0?"   " : "√";
//			int x = s + 1;
//			String sIndex = ((x<10)?"    " + x:"  " + x)+ "  "+sAddRemove+"   ";//
//			
//			reportNotice("\n"+sIndex+keyT + "........: "+ sValue);
//			
//		}//next i
//		int nRetVal = getInt(sPrompt)-1;
//				
//	// select property	
//		while (nRetVal>-1)
//		{ 
//			if (nRetVal>-1 && nRetVal<=sObjectVariables.length())
//			{ 
//				String newAttrribute = sFormat;
//	
//			// get variable	and append if not already in list	
//				String variable ="@(" + sObjectVariables[nRetVal] + ")";
//				int x = sFormat.find(variable, 0);
//				if (x>-1)
//				{
//					int y = sFormat.find(")", x);
//					String left = sFormat.left(x);
//					String right= sFormat.right(sFormat.length()-y-1);
//					newAttrribute = left + right;
//					reportMessage("\n" + sObjectVariables[nRetVal] + " new: " + newAttrribute);				
//				}
//				else
//				{ 
//					newAttrribute+="@(" +sObjectVariables[nRetVal]+")";
//								
//				}
//				sFormat.set(newAttrribute);
//				reportMessage("\n" + sFormatName + " " + T("|set to|")+" " +sFormat);	
//			}
//			nRetVal = getInt(sPrompt)-1;
//		}
//	
//		setExecutionLoops(2);
//		return;
//	}	
////endregion 

//region Resolve format by entity
	String text;// = "R" + dDiameter * .5;
	if (sFormat.length()>0)
	{ 
		String sLines[0];// store the resolved variables by line (if \P was found)	
		String sValues[0];	
		String sValue=  _ThisInst.formatObject(sFormat, mAdd);
	
	// parse for any \P (new line)
		int left= sValue.find("\\P",0);
		while(left>-1)
		{
			sValues.append(sValue.left(left));
			sValue = sValue.right(sValue.length() - 2-left);
			left= sValue.find("\\P",0);
		}
		sValues.append(sValue);	
	
	// resolve unknown variables
		for (int v= 0; v < sValues.length(); v++)
		{
			String& value = sValues[v];
			int left = value.find("@(", 0);
			
		// get formatVariables and prefixes
			if (left>-1)
			{ 
				// tokenize does not work for strings like '(@(KEY))'
				String sTokens[0];
				while (value.length() > 0)
				{
					left = value.find("@(", 0);
					int right = value.find(")", left);
					
				// key found at first location	
					if (left == 0 && right > 0)
					{
						String sVariable = value.left(right + 1);
						
						//"Radius", "Diameter", "Length", "Area"
						String s;
						if (sVariable.find("@("+sCustomVariables[0]+")",0,false)>-1)
						{
							s.formatUnit(dCoordDim*.5,_kLength);
							sTokens.append(s);
						}
						value = value.right(value.length() - right - 1);
					}
				// any text inbetween two variables	
					else if (left > 0 && right > 0)
					{
						sTokens.append(value.left(left));
						value = value.right(value.length() - left);
					}
				// any postfix text
					else
					{
						sTokens.append(value);
						value = "";
					}
				}
//	
				for (int j=0;j<sTokens.length();j++) 
					value+= sTokens[j]; 
			}
//			//sAppendix += value;
			sLines.append(value);
		}	
//		
	// text out
		for (int j=0;j<sLines.length();j++) 
		{ 
			text += sLines[j];
			if (j < sLines.length() - 1)text += "\\P";
		}//next j
	}
//		
//End Resolve format by entity//endregion 

Display dp(7);
dp.dimStyle(sDimStyle);
double textHeight = dp.textHeightForStyle("O", sDimStyle);
dp.textHeightForStyle("O",sDimStyle);
//dp.color(7);
dp.textHeight(textHeight);
Vector3d vxText, vyText;
if (text.length() > 0)
{ 
	if(_bOnDbCreated)
	{ 
		Point3d ptText = ptBottom - vecY * textHeight + vecX * vecX.dotProduct(ptStart - ptBottom);
		_Pt0 = ptText;
	}
	vxText = vecY;
	vyText = -vecX;
	dp.draw(text, _Pt0, vxText, vyText, -1, 0);
}
else
{
	// HSB-14882
	sFormat.set("D @(Diameter)");
	setExecutionLoops(2);
	return;
//	_PtG.setLength(0);
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
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14882: Dont allow empty format" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="6/3/2022 2:36:41 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14881: Add setDefinesFormat for the property" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="4/8/2022 3:51:56 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14863: Satosh: Fix bug for 0 depth (all through)" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="4/1/2022 2:33:28 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End