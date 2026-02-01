#Version 8
#BeginDescription
Exports ElemItem with information of the stickframe weight to the database
1.19 07/02/2023 Fix issue with TSL in Layouts AJ
1.18 23/01/2023 Add support to Wall Split AJ

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 23.10.2019  -  version 1.17



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 19
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT IRELAND
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 20.04.2012
* version 1.0: First version
*
* date: 30.04.2012
* version 1.1: Add default weight and improve the report notice
*
* date: 01.05.2012
* version 1.2: Bugfix
*
* date: 01.06.2012
* version 1.4: Add a report notice in case it can not find the materials.xml
*
* date: 08.06.2012
* version 1.5: Check if the material has a first token of "-" and use the the prefix to that token as the material for SIPs.  Also added sips to the calculation.
*
* date: 26.02.2013
* version 1.7: Change the Element array so it wont be populated when the viewport option is selected.
*
* date: 13.03.2013
* version 1.8: Improved accuracy of SIP weight by extracting each component and working out the weight of the panel
*
* date: 10.09.2015
* version 1.10: Ignored dummy beams, sheets and sips
*
* date: 08.08.2018
* version 1.13: Add support for weight in lb

* date: 22.11.2018
* version 1.16: Change no material found from reportnotice to reportmessage (RP)
*/

//double dUnit = U(1,"mm",3);
//
//Unit (1, "mm");

int bIsMetricDwg = U(1, "mm") == 1;
double dVolumeConversionFactor =  bIsMetricDwg ? .000000001 : .000016387;

String posFix = T("kg");

if (!bIsMetricDwg) //mm
{ 
	posFix = T("lb");
}

String sModes[]={"Model", "Viewport"};

PropString sMode (0, sModes,"Insert in:");

PropString sDimStyle(1, _DimStyles, T("Dim Style"));

PropInt nRotation(0, 0, T("Rotation"));

PropDouble dMaxWeight(0, 100, T("Max weight")+ " (" + posFix + ")");
dMaxWeight.setFormat(_kNoUnit);

PropString sPrefix(2, "", T("Prefix:"));

_ThisInst.setSequenceNumber(110);

if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert )
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	
	if (_kExecuteKey=="")
		showDialogOnce();
}

int nMode=sModes.find(sMode, -1);

if( _bOnInsert )
{
	if (nMode==0)
	{
		PrEntity ssE("\nSelect a set of elements",Element());
		if(ssE.go()){
			_Element.append(ssE.elementSet());
		}
		// declare tsl props
		TslInst tsl;
		String strScriptName=scriptName();
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Element lstElements[0];
		Beam lstBeams[0];
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		lstPropString.append(sMode);
		lstPropString.append(sDimStyle);
		lstPropString.append(sPrefix);
		
		lstPropInt.append(nRotation);
		
		lstPropDouble.append(dMaxWeight);
		
		for( int e=0; e<_Element.length(); e++ )
		{
			lstElements.setLength(0);
			lstPoints.setLength(0);
			lstElements.append(_Element[e]);
			//lstPoints.append(_Element[e].ptOrg()+_Element[e].vecZ()*U(100));
		
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY, lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString);
			tsl.setPtOrg(_Element[e].ptOrg() + _Element[e].vecZ() * U(100));
			//tsl.transformBy(_XW * U(0));
		}
		eraseInstance();
	}
	else if (nMode==1)
	{
		_Pt0=getPoint("Pick a Point");
		_Viewport.append(getViewport(T("Select a viewport")));
	}
	return;
}


if (_Element.length() == 0 && nMode == 0)
{
	reportMessage(T("No selected walls. TSL will be deleted"));
	eraseInstance();
	return;
}
//return

// The _bOnElementListModified will be TRUE after wall-splitting-in-length, or integrate tsl as tooling to element.

if (_bOnElementListModified && (_Element.length() > 1)) //at least 2 items in _Element array
{
	Element elNew = _Element[0];
	_Element.setLength(0);
	_Element.append (elNew); //overwrite 0 entry will replace the existing reference to elem0
}

Element elToWork;

if (nMode==1)
{
	if( _Viewport.length()==0 ){eraseInstance(); return;}

	Viewport vp = _Viewport[0];

	if (!vp.element().bIsValid()) return;

	CoordSys ms2ps = vp.coordSys();
	Element el = vp.element();
	if (el.bIsValid())
	{
		_Element.setLength(0);
		elToWork=el;
	}
}
else
{
	//_Pt0 = _Element[0].ptOrg() + _Element[0].vecZ() * U(100);
}

if (nMode==0)
{
	if (_Element.length()<1)
	{
		eraseInstance();
		return;
	}
	elToWork=_Element[0];
}
else if (nMode==1)
{
	if (!elToWork.bIsValid())
	{
		return;
	}
}


String sPath= _kPathHsbCompany+"\\Abbund\\Materials.xml";

String sFind=findFile(sPath);

if (sFind=="")
{
	reportNotice("\nhsbMaterial Table not found, please set the right company folder");
	if (nMode==0)
	{
		eraseInstance();
	}
	return;
}

Map mp;
mp.readFromXmlFile(sPath);

String sMaterial[0];
double dDensity[0];

if (mp.hasMap("MATERIAL[]"))
{
	Map mpMaterials=mp.getMap("MATERIAL[]");
	for(int i=0; i<mpMaterials.length(); i++)
	{
		Map mpMaterial=mpMaterials.getMap(i);
		String sThisMaterial = mpMaterial.getString("MATERIAL");
		sThisMaterial.trimLeft();
		sThisMaterial.trimRight();
		sThisMaterial.makeUpper();
		sMaterial.append(sThisMaterial);
		dDensity.append(mpMaterial.getDouble("DENSITY"));
	}
}

if (sMaterial.length()==0)
{
	eraseInstance();
	return;
}

Element el=elToWork;

if (!el.bIsValid())
{
	eraseInstance();
	return;
}

CoordSys csEl = el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();
Point3d ptEl = csEl.ptOrg();
//ptEl.vis(2);

//Erase any other TSL with the same name
TslInst tlsAll[]=el.tslInstAttached();
for (int i=0; i<tlsAll.length(); i++)
{
	String sName = tlsAll[i].scriptName();
	if (sName == scriptName() && tlsAll[i].handle()!= _ThisInst.handle())
	{
		tlsAll[i].dbErase();
		reportNotice("yes");
	}
}

Vector3d vXTxt = vx;
Vector3d vYTxt = -vz;

if (nMode==1)
{
	vXTxt=_XW;
	vYTxt=_YW;
}

CoordSys cs3;
cs3.setToRotation(nRotation, _ZW, _Pt0);

vXTxt.transformBy(cs3);
vYTxt=_ZW.crossProduct(vXTxt);
vYTxt.normalize();


double dWeight=0;
double dWeightSheets=0;
double dWeightBeams=0;
double dWeightSips=0;
double dWeightOpenings=0;


Beam bmAll[]=el.beam();
Sheet shAll[]=el.sheet();
Sip spAll[]=el.sip();
Opening opAll[]=el.opening();
TslInst tslAll[0];

//collect the individual entities inside a truss definition.
TrussEntity entTruss[0];

Group grpElement=el.elementGroup();
Entity entElement[]=grpElement.collectEntities(false,TrussEntity(),_kModelSpace);
for(int e=0;e<entElement.length();e++)
{
	//Get the truss entity
	TrussEntity truss=(TrussEntity)entElement[e];
	if(!truss.bIsValid()) continue;
	entTruss.append(truss);
}

for (int i = 0; i < entTruss.length(); i++)
{
	TrussEntity truss = entTruss[i];
	String sDefinition = truss.definition();
	CoordSys csTruss = truss.coordSys();
	
	//Get all the beams in the definition
	TrussDefinition trussDef(sDefinition);
	if (trussDef.bIsValid())
	{
		bmAll.append( trussDef.beam());
		shAll.append( trussDef.sheet());
		spAll.append(trussDef.sip());
		tslAll.append(trussDef.tslInst());
	}
}



int nDefDensity=sMaterial.find("DEFAULT", -1);
//TODO - Get all the plates and calculate the weight
//for (int i=0; i<tslAll.length(); i++)
//{ 
//	TslInst tsl = tslAll[i];
//	if (tsl.scriptName().find("truss", 0, false) != -1)
//	{
//		String sA = tsl.scriptName();
//		double dTSL=tsl.cuttingBody().volume();
//		Map mpThisTSL = tsl.map();
//	}
//}

for (int i=0; i<shAll.length(); i++)
{
	Sheet sh=shAll[i];
	if(sh.bIsDummy())
	{
		continue;
	}
	
	String sMat=sh.material();
	sMat.makeUpper();
	sMat.trimLeft();
	sMat.trimRight();
	int nLocation=sMaterial.find(sMat, -1);
	
	if (sh.dH()<U(0.5) || sh.dW()<U(0.5) || sh.dL()<U(0.5) )
		continue;
	
	Body bdSheet=sh.realBody();
	if (nLocation!=-1)
	{
		dWeightSheets=dWeightSheets+(bdSheet.volume() * dDensity[nLocation]);
	}
	else
	{
		reportMessage("\nMaterial: " + sMat + " Not Available in Material to calculate weight, please check hsbMaterial Table");
		reportMessage("\nDefaut material is been use to calculate this weight");
		if (nDefDensity!=-1)
		{
			dWeightSheets=dWeightSheets+(bdSheet.volume() * dDensity[nDefDensity]);
		}
		else
		{
			reportNotice("\nDefault density not available, please check hsbMaterial Table");			
		}

	}
}

dWeightSheets=dWeightSheets*dVolumeConversionFactor;

for (int i=0; i<bmAll.length(); i++)
{
	Beam bm=bmAll[i];
	if(bm.bIsDummy())
	{
		continue;
	}
	
	String sMat=bm.material();
	sMat.makeUpper();
	sMat.trimLeft();
	sMat.trimRight();
	
	if (bm.dH()<U(0.5) || bm.dW()<U(0.5) || bm.dL()<U(0.5))
		continue;
	
	//Check if the material has a - as a token in the firt postition.  if so use the first part of that as the material
	String sMaterialToken=sMat.token(0,"-");
	if(sMaterialToken!="") sMat=sMaterialToken;
	
	int nLocation=sMaterial.find(sMat, -1);
	Body bdBeam=bm.realBody();
	if (nLocation!=-1)
	{
		
		dWeightBeams=dWeightBeams+(bdBeam.volume() * dDensity[nLocation]);
	}
	else
	{
		reportMessage("\nMaterial: " + sMat + " Not Available in Material to calculate weight, please check hsbMaterial Table");
		reportMessage("\nDefaut material is been use to calculate this weight");	
		if (nDefDensity!=-1)
		{
			dWeightBeams=dWeightBeams+(bdBeam.volume() * dDensity[nDefDensity]);
		}
		else
		{
			reportNotice("\nDefault density not available, please check hsbMaterial Table");			
		}
	}
}

dWeightBeams=dWeightBeams*dVolumeConversionFactor;

for (int i=0; i<spAll.length(); i++)
{
	Sip sp=spAll[i];
//	Body bdSip=spAll[i].realBody(); <==Deprecated
	if(sp.bIsDummy())
	{
		continue;
	}
	
	String sStyle=sp.style();
	if(sStyle!="")
	{
		//Collect the style of the sip and get the material and volume of each component
		SipStyle sipStyle(sStyle);
		int nComponents=sipStyle.numSipComponents();
	
		for(int c=0;c<nComponents;c++)
		{
			String sMat=sipStyle.sipComponentAt(c).material();
			sMat.makeUpper();
			sMat.trimLeft();
			sMat.trimRight();
	
			int nLocation=sMaterial.find(sMat, -1);
			double dComponentVolume=sp.realBodyOfComponentAt(c).volume();
			if (nLocation!=-1)
			{
				
				dWeightSips=dWeightSips+(dComponentVolume * dDensity[nLocation]);
			}
			else
			{
				reportNotice("\nMaterial: " + sMat + " Not Available in Material to calculate weight, please check hsbMaterial Table");
				reportNotice("\nDefaut material is been use to calculate this weight");	
				if (nDefDensity!=-1)
				{
					dWeightSips=dWeightBeams+(dComponentVolume * dDensity[nDefDensity]);
				}
				else
				{
					reportNotice("\nDefault density not available, please check hsbMaterial Table");			
				}
			}
		}
	}
}

dWeightSips=dWeightSips*dVolumeConversionFactor;

for (int i=0; i<opAll.length(); i++)
{
	Opening op=opAll[i];
	
	Map mp=op.subMapX("hsb_OpeningInfo");
	
	if (mp.hasDouble("TotalWeight"))
	{
		double dWeight=mp.getDouble("TotalWeight");
		
		if (mp.hasInt("FactoryFitted"))
		{
			int nFitted=mp.getInt("FactoryFitted");
			
			if(nFitted)
			{
				dWeightOpenings+=dWeight;
			}
		}
		
		
	}
}

dWeight=dWeightSheets+dWeightBeams+dWeightSips+dWeightOpenings;

if (!bIsMetricDwg) //mm
{ 
	dWeight = dWeight * 2.2046;
}


//{ 
//	//__density is stored in kg/m^3, .dwg is mm or inch. calculate conversion factor around this 
//	//__ kg/m^3 * 2.2046 = lb/m^3
//	//__1 m^3  = 1,000,000,000 mm^3
//	int bIsMetricDwg = U(1, "mm") == 1;
//	double dVolumeConversionFactor =  bIsMetricDwg ? .000000001 : .000016387;
//	double dLengthConversionFactor = bIsMetricDwg ? 1 : 25.4;
//}


String strWeight;
strWeight.formatUnit(dWeight,2,0);


int nColor=-1;

if (dWeight>dMaxWeight)
	nColor=1;
	
Display dp(nColor);
dp.dimStyle(sDimStyle);

sPrefix.trimLeft();
sPrefix.trimRight();

String sText=sPrefix+" "+strWeight +" " + posFix;;

dp.draw(sText, _Pt0, vXTxt, vYTxt, 1, -1);

if (dWeight>0)
{
	Map mpWeight;
	
	String sWeight;
	sWeight.formatUnit(dWeight, 2, 2);
	mpWeight.setDouble("TotalWeight", dWeight);
	
	el.setSubMapX("HSB_ElementInfo", mpWeight);
}

if (nMode==0)
{
	String sCompareKey = el.code()+" "+el.number();
	
	setCompareKey(sCompareKey);
	
	//export dxa
	Map itemMap= Map();
	itemMap.setString("DESCRIPTION", "WEIGHT");
	itemMap.setString("QUANTITY", dWeight);
	ElemItem item(1, T("PANELWEIGHT"), el.ptOrg(), el.vecZ(), itemMap);
	item.setShow(_kNo);
	el.addTool(item);
}

if (nMode==0)
{
	assignToElementGroup(el, TRUE, 0, 'E');
}










#End
#BeginThumbnail

















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Fix issue with TSL in Layouts" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="19" />
      <str nm="DATE" vl="2/7/2023 3:44:29 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add support to Wall Split" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="18" />
      <str nm="DATE" vl="1/23/2023 10:20:15 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End