#Version 8
#BeginDescription

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <History>//region
/// <version value="1.0" date="13may2019" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select one or multiple masterpanels, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl assigns property data to a set of selected masterpanels.
///    Posnum: if the start number is greater 0 it applies the next free posnum to the masterpanel
///    Name: combine any format expression and text to assign the name of the masterpanel. If the given index is greater 0 and increment will be added to the name
///    Information: combine any format expression and text to assign the information of the masterpanel. If the given index is greater 0 and increment will be added to the information
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-AssignMasterpanelPosnumData")) TSLCONTENT
//endregion



//region constants 
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
//end constants//endregion


// list of supported format expressions
	String sList = TN("|Besides the properties of panels the following format expressions are supported:|\n"+
	"@(surfaceQualityBottom)" +"\n"+
	"@(surfaceQualityTop)" +"\n"+
	"@(surfaceQuality)" +"\n"+
	"@(SipComponent.Material)" +"\n"+
	"@(SipComponent.Name)" +"\n"+
	"@(SipComponent.Thickness)");

//region Properties
	category = T("|Posnum|");
	String sNumberName=T("|Start Number|");	
	PropInt nNumber(nIntIndex++, 0, sNumberName);	
	nNumber.setDescription(T("|Defines the start number of the indexing.|") + T(" |The next available number will be assigned.|") + T(" |0 = disabled|"));
	nNumber.setCategory(category);
	
	category = T("|Name|");
	String sNameName=T("|Format|");	
	PropString sName(nStringIndex++, "@(Style)", sNameName);	
	sName.setDescription(T("|Defines the name of the masterpanel.|")+ T(" |Use format expressions and/or any text|")+sList);
	sName.setCategory(category);
	
	String sNameIndexName=T("|Index|");	
	PropInt nNameIndex(nIntIndex++, 1, sNameIndexName);	
	nNameIndex.setDescription(T("|Defines the start number of an increment which is appended to the name.|") + T(" |0 = disabled|"));
	nNameIndex.setCategory(category);
	
	category = T("|Information|");
	String sInformationName=T("|Format| ");	
	PropString sInformation(nStringIndex++, "@(Style)", sInformationName);	
	sInformation.setDescription(T("|Sets the information of the masterpanel.|") + T(" |Use format expressions and/or any text|")+sList);
	sInformation.setCategory(category);
	
	String sInformationIndexName=T("|Index| ");	
	PropInt nInformationIndex(nIntIndex++, 0, sInformationIndexName);	
	nInformationIndex.setDescription(T("|Defines the start number of an increment which is appended to the information.|") + T(" |0 = disabled|"));
	nInformationIndex.setCategory(category);
//End Properties//endregion 



// bOnInsert//region
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();

		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();	
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
		else	
			showDialog();
		
	// prompt for entities
		PrEntity ssE(T("|Select entity(s)|"), MasterPanel());
		if (ssE.go())
			_Entity.append(ssE.set());
		
		
		if (bDebug)_Pt0 = getPoint();
	
	
		return;
	}	
// end on insert	__________________//endregion


// constants
	String keyComponent = "SipComponent.";
	String keyStyle = "SipStyle.";

// get settings
	int bApplyNumber = nNumber > 0;
	int nUsedNumbers[0];
	String sFormats[] ={sName, sInformation};
	
// get masters from entity
	MasterPanel masters[0];
	for (int i=0;i<_Entity.length();i++) 
	{ 
		MasterPanel _master = (MasterPanel)_Entity[i]; 
		if (_master.bIsValid())
			masters.append(_master);
	}

// get all masters in dwg
	Entity ents[] = Group().collectEntities(true,MasterPanel(),  _kModelSpace);
	MasterPanel masterOthers[0];
	for (int i=0;i<ents.length();i++) 
	{ 
		MasterPanel _master = (MasterPanel)ents[i]; 
		if (_master.bIsValid() && masters.find(_master)<0)
		{
			masterOthers.append(_master);
			int num = _master.number();
			if (num>0 && bApplyNumber)nUsedNumbers.append(num);
		}
	}
	
// loop masters
	int _nInformationIndex = nInformationIndex;
	int _nNameIndex = nNameIndex;
	int nNewNumber = nNumber;
	for (int x=0;x<masters.length();x++) 
	{ 
		MasterPanel& master = masters[x]; 		

	// find next free number
		if (nNewNumber>0)
		{ 
			while (nUsedNumbers.find(nNewNumber)>-1)
			{ 
				nNewNumber++;	
			}
			master.setNumber(nNewNumber);
			nUsedNumbers.append(nNewNumber);
			nNewNumber++;
		}


		String _sName = sName;
		String _sInformation = sInformation;
		
	// get first nested panel	
		ChildPanel childs[] = master.nestedChildPanels();
		Sip sip;
		if (childs.length() > 0)sip = childs[0].sipEntity();
		if (sip.bIsValid())
		{
			// transformation	
			CoordSys cs2Child = childs[0].sipToMeTransformation();
			Vector3d vecZ = sip.vecZ();
			vecZ.transformBy(cs2Child);
			
			// STYLE	
			SipStyle style(sip.style());
			String sqTop = sip.surfaceQualityOverrideTop();
			if (sqTop.length() < 1)sqTop = style.surfaceQualityTop();
			if (sqTop.length() < 1)sqTop = "?";
			int nQualityTop = SurfaceQualityStyle(sqTop).quality();
			
			String sqBottom = sip.surfaceQualityOverrideBottom();
			if (sqBottom.length() < 1)sqBottom = style.surfaceQualityBottom();
			if (sqBottom.length() < 1)sqBottom = "?";
			int nQualityBottom = SurfaceQualityStyle(sqBottom).quality();
			
			// COMPONENT
			SipComponent components[] = style.sipComponents();
			
			// loop formats
			for (int i = 0; i < sFormats.length(); i++)
			{
				String sFormat = sFormats[i];
				String value = sip.formatObject(sFormat);
				int left = value.find("@(", 0);
				
				if (left >- 1)
				{
					// resolve style data
					String sTokens[0];
					int nCnt;
					while (value.length() > 0 && nCnt<100)
					{
						left = value.find("@(", 0);
						int right = value.find(")", left);
						
						// key found at first location
						if (left == 0 && right > 0)
						{
							String sVariable = value.left(right + 1).makeUpper();
							if (sVariable == "@(surfaceQualityBottom)".makeUpper())
								sTokens.append(sqBottom);
							else if (sVariable == "@(surfaceQualityTop)".makeUpper())
								sTokens.append(sqTop);
							else if (sVariable == "@(SURFACEQUALITY)")
							{
								String sQualities[] ={ sqBottom, sqTop};
								if (sip.vecZ().isCodirectionalTo(_ZW))sQualities.swap(0, 1);
								String sQuality = sQualities[0] + " (" + sQualities[1] + ")";
								sTokens.append(sQuality);
							}
							else if (components.length() > 0 && sVariable == "@(SipComponent.Material)".makeUpper())
								sTokens.append(components[0].material());	
							else if (components.length() > 0 && sVariable == "@(SipComponent.Name)".makeUpper())
								sTokens.append(components[0].name());
							else if (components.length() > 0 && sVariable == "@(SipComponent.Thickness)".makeUpper())
								sTokens.append(components[0].dThickness());								
						// strip value	
							value = value.right(sFormat.length() - right - 1);
						}
						// any text inbetween two variables
						else if (left > 0 && right > 0)
						{
							sTokens.append(sFormat.left(left));
							value = value.right(value.length() - left);
						}
						// any postfix text
						else
						{
							sTokens.append(value);
							value = "";
						}
						

						nCnt++;
					}
				// append tokens
					//if (sTokens.length() > 0)value = "";
					for (int j = 0; j < sTokens.length(); j++)
						value += sTokens[j];					
					
					
				}

			// set format
				if (value.length() < 1)continue;
				if (i == 0)
				{
					_sName=value;
				}
				else if (i == 1)
				{
					_sInformation=value;
				}
				
			}//next i
		}

		if (_sName.length()>1)
		{
		// add increment
			if (nNameIndex>0)
			{
				_sName += (_nNameIndex < 10 ? "0" : "") + _nNameIndex;
				_nNameIndex++; // next master
				
			}				
			master.setName(_sName);
		}
		if (_sInformation.length()>1)
		{
		// add increment
			if (_nInformationIndex>0)
			{
				_sInformation += (_nInformationIndex < 10 ? "0" : "") + _nInformationIndex;	
				_nInformationIndex++;// next master
			}				
			master.setInformation(_sInformation);
		}		
	}//next x
	
	
	if (!bDebug)
	{
		eraseInstance();
		return;
	}
	
	
#End
#BeginThumbnail
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
L>NCA.8->P.JAAQZ>,^@%K!YZZ.$Y@_\#P>*Z[FBB.4P`````245.1*Y"8((`

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
        <int nm="BreakPoint" vl="160" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End