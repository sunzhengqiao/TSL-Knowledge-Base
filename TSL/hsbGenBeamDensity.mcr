#Version 8
#BeginDescription
#Versions:
1.3 07.12.2022 HSB-17225: add support as element and beam plugin TSL
/// auto insert shopdrawings enabled


/// Wählen Sie alle Bauteile aus. Sollte die Eigenschaftssatzdefinition ungültig sein, bzw die gewählte Eigenschaft
/// nicht in diesem vorhanden sein wird ein Dialog angezeigt und nach erfolgreicher Änderung kann der Befehl erneut ausgeführt werden.





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords Density;property set;Rubner; Holzbau; propset; xml
#BeginContents
/// <summary Lang=de>
/// Dieses TSL fügt den gewählten Objekten den Eigenschaftssatz hinzu und legt die Dichte eines
/// Bauteils an Hand einer Materialtabelle fest
/// </summary>

/// <insert=de>
/// Wählen Sie alle Bauteile aus. Sollte die Eigenschaftssatzdefinition ungültig sein, bzw die gewählte Eigenschaft
/// nicht in diesem vorhanden sein wird ein Dialog angezeigt und nach erfolgreicher Änderung kann der Befehl erneut ausgeführt werden.
/// </insert>

/// <remark>
/// Benötigt die Materialtabelle <hsbCompany>\\Abbund\\hsbGenBeamDensityConfig.xml" und eine Eigenschaftssatzdefinition mit einer
/// Eigenschaft für die Dichte. Diese Eigenschaft muss der Eingabe einer reelen Zahl entsprechen.
/// </remark>

/// History
/// #Versions:
// 1.3 07.12.2022 HSB-17225: add support as element and beam plugin TSL Author: Marsel Nakuci
/// Version 1.2    th@hsbCAD.de   20.09.2011
/// auto insert shopdrawings enabled
/// Version 1.1    th@hsbCAD.de   19.08.2011
/// Vorgabe Eigenschaftsname gesetzt
/// Version 1.0    th@hsbCAD.de   19.08.2011
/// inital

//region Constants 
	U(1,"mm");
	double dEps=U(.1);
	String sConfigPath = _kPathHsbCompany + "\\Abbund\\hsbGenBeamDensityConfig.xml";
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
	
//region Properties
	PropString sPropertySet(0,"hsbDensity", T("|Property Set Name|"));
	PropString sPropertyName(1,"Density", T("|Property Name Density|"));
//End Properties//endregion	
	
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
		
		// prompt user
	  	PrEntity ssE(T("|Select entities|"), Beam());
		ssE.addAllowedClass(Sheet());
		ssE.addAllowedClass(Sip());
	
  		if (ssE.go()) {
			_Entity= ssE.set();
  		}
		return;
	}
// end on insert	__________________//endregion

//region mapIO: support property dialog input via map on element creation
	{
		int bHasPropertyMap = _Map.hasMap("PROPSTRING[]");
		if (_bOnMapIO)
		{ 
			if (bHasPropertyMap)
				setPropValuesFromMap(_Map);	
			showDialog();
			_Map = mapWithPropValues();
			return;
		}
		if (_bOnElementDeleted)
		{
			eraseInstance();
			return;
		}
		else if (_bOnElementConstructed && bHasPropertyMap)
		{ 
			setPropValuesFromMap(_Map);
			_Map = Map();
		}	
	}		
//End mapIO: support property dialog input via map on element creation//endregion 

// on insert
//	if (_bOnInsert){
//		
//	// set prop values by catalog
//		setPropValuesFromCatalog(T("|_LastInserted|"));	
//
//		// prompt user
//	  	PrEntity ssE(T("|Select entities|"), Beam());
//		ssE.addAllowedClass(Sheet());
//		ssE.addAllowedClass(Sip());
//	
//		return;
//	}
// end on insert	

	Entity ents[0];
	ents =_Entity;
//	return
	Element el;
	if (_Element.length() == 1)
	{
		el=_Element[0];
	}
	if (el.bIsValid())
	{
		ents.setLength(0);
		GenBeam gbs[]=el.genBeam();
		if(gbs.length()==0)return
		for (int i=0;i<gbs.length();i++) 
		{ 
			ents.append(gbs[i]);
		}//next i
	}
	if(_Beam.length()==1)
	{ 
		ents.setLength(0);
		ents.append(_Beam[0]);
	}
	
// see if a valid property set name and property is defined
	String sArAvailablePropSetNames[] = Beam().availablePropSetNames();
//	return
// check if property set is defined and available
	if (sArAvailablePropSetNames.find(sPropertySet)<0)
	{
		showDialog();
	// invalid property set name	
		if (sArAvailablePropSetNames.find(sPropertySet)<0)
		{
			reportNotice("\n*****" + scriptName() + " *****");
			reportNotice("\n" + T("|invalid Property Set Name|") + " " + T("|Tool will be deleted|"));
			eraseInstance();
			return;
		}
	}
		
	String sArPropertyNames[]={sPropertyName};
	
// read config file
	Map mapDensity;
	mapDensity.readFromXmlFile(sConfigPath);
	if (mapDensity.length()<1)
	{
		reportNotice("\n\n*****" + scriptName() + " *****");
		reportNotice("\n" + T("|No Density list found in|") + "\n" + sConfigPath + "\n" + T("|Tool will be deleted|"));
		reportNotice("\n************************************\n");
		eraseInstance();
		return;
	}

// try to assign property set and it's data
	int bMissingMaterials;
	for (int i=0;i<ents.length();i++)
	{
		ents[i].attachPropSet(sPropertySet);
	// validate the property name atthe first selected entity
		if (i==0)
		{
			
			Map map = ents[i].getAttachedPropSetMap(sPropertySet, sArPropertyNames);
			int bOk=false;
			for (int m=0;m<map.length();m++)
				if (map.keyAt(m)==sPropertyName)
				{
					bOk=true;
					break;
				}
			if (!bOk)
			{
				reportNotice ("\n" + T("|Enter valid property name and try again.|"));
				showDialog();
				eraseInstance();
				return;
			}
		}
		
		GenBeam gb = (GenBeam)ents[i];	
		if ( ! gb.bIsValid())continue;
	// find matching material in density list and assign value to property set
		String sMat = gb.material().makeUpper();
		double dDensity;
		int bFound;
		for (int m=0;m<mapDensity.length();m++)
			if (mapDensity.keyAt(m).makeUpper()==sMat )
			{
				dDensity = mapDensity.getDouble(m);
				bFound=true;
				break;
			}	
	// report unknown materials	
		if (!bFound)
		{
//			gb.envelopeBody().vis(3);
			bMissingMaterials= true;
			reportMessage("\n" + gb.posnum() + " " + gb.name() + " " + gb.material());	
		}
	// write property
		else
		{
			Map map = ents[i].getAttachedPropSetMap(sPropertySet);	
			map.setDouble(sPropertyName,dDensity,_kNoUnit);
			gb.setAttachedPropSetFromMap(sPropertySet, map, sArPropertyNames); 
		}				
	}
	
	if (bMissingMaterials)reportMessage("\n"+T("|not found in|") + " "+ sConfigPath + "\n" + T("|Please update density table and try again.|") + "\n");
	eraseInstance();
	return;
	
#End
#BeginThumbnail
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
<+>)(8@.$C4*/TJ:U:I&R;^[^O\BZ=.#V_$__V5K>
`




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
      <str nm="COMMENT" vl="HSB-17225: add support as element and beam plugin TSL" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="12/7/2022 11:34:29 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End