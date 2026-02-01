#Version 8
#BeginDescription
version value="1.4" date="21jun2019" author="marsel.nakuci@hsbcad.com"

report message if no element viewport+fix bug at-> if(iIndex==1)
report message if no element viewport
typo of property name fixed

Select viewport, select properties or catalog entry and press OK,
pick insertion point of the TSL

This tsl assigns posnums to genbeams in a viewport that contains 
elements (wall element, floor element or a roof element)
in the property "StartPosNum" it is enters the starting PosNum
custom command -"select viewport" to select a new viewport
custom command -"release posnum" to delete the existing posnums
each time the "StartPosNum" is changed, the calculation will 
run with the new "StartPosNum"
TSL can not be entered twice in _kMySpace
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords posnum, layout, genBeam, TSL
#BeginContents
/// <History>//region
/// <version value="1.4" date="21jun2019" author="marsel.nakuci@hsbcad.com"> report message if no element viewport+fix bug at-> if(iIndex==1)</version>
/// <version value="1.3" date="28mar2019" author="thorsten.huck@hsbcad.com"> typo of property name fixed </version>
/// <version value="1.2" date="26mar2019" author="marsel.nakuci@hsbcad.com"> add for TSL and extend properties </version>
/// <version value="1.1" date="26mar2019" author="marsel.nakuci@hsbcad.com"> suggestions in HSBCAD-627 </version>
/// <version value="1.0" date="26mar2019" author="marsel.nakuci@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select viewport, select properties or catalog entry and press OK,
/// pick insertion point of the TSL
/// </insert>

/// <summary Lang=en>
/// This tsl assigns posnums to genbeams or/and TSL instances
/// in a viewport that contains elements (wall element, floor or a roof)
/// in the property "check for posnum numbering:" it is decided whether the 
/// category will be considered for numbering or not
/// in the property "Start number" it is entered the start number for the PosNum numbering
/// in the property "Text Height" it is entered the height of text for the display
/// custom command  "select viewport" to select a new viewport
/// each time the "Start number" is changed, the calculation will 
/// run with the new "Start number"
/// TSL can not be entered twice in _kMySpace
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbLayout-AssignPosnum")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Select View Port|") (_TM "|Select a viewport|"))) TSLCONTENT
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

//region properties
// GebBeam
	category = T("|GenBeam|");
	// YesNo
	String sNoYesGenBeamName=T("|Numbering|");	
	PropString sNoYesGenBeam(nStringIndex++, sNoYes, sNoYesGenBeamName,1);	
	sNoYesGenBeam.setDescription(T("|Defines whether genBeams should be checked for numbering or not|"));
	sNoYesGenBeam.setCategory(category);
	// Start number
	String sStartPosNumGenBeamName=T("|Start number|");	
	PropInt nStartPosNumGenBeam(nIntIndex++, 1, sStartPosNumGenBeamName);	
	nStartPosNumGenBeam.setDescription(T("|Defines the Start number|"));
	nStartPosNumGenBeam.setCategory(category);
	// Zone
	String sZones ="";
	String sZoneName=T("|Zone|");	
	PropString sZone(nStringIndex++, sZones, sZoneName);	
	sZone.setDescription(T("|Defines the Zone|"));
	sZone.setCategory(category);
	
// TSL
	category = T("|TSL|");
	// YesNo
	String sNoYesTSLName=T("|Numbering| ");	
	PropString sNoYesTSL(nStringIndex++, sNoYes, sNoYesTSLName, 1);
	sNoYesTSL.setDescription(T("|Defines whether TSL should be checked for numbering or not|"));
	sNoYesTSL.setCategory(category);
	// startposnum
	String sStartPosNumTSLName=T("|Start number| ");	
	PropInt nStartPosNumTSL(nIntIndex++, 1, sStartPosNumTSLName);	
	nStartPosNumTSL.setDescription(T("|Defines the Start number|"));
	nStartPosNumTSL.setCategory(category);
	
// Display
	category = T("|Display|");
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(10), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the Text Height|"));
	dTextHeight.setCategory(category);
//End property//endregion 


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
			// select viewport
			Viewport vp = getViewport(T("|Select a viewport|")); // select viewport
			_Viewport.append(vp);
			// prompt for insertion point
			_Pt0 = getPoint(T("|Pick a point outside of paperspace|"));
		
		return;
	}	
// end on insert	__________________//endregion
	
//region make sure no previous TSL "hsbLayout-AssignPosnum" is attached to this viewport
	
	Group grp;
	Entity arEnt[] = grp.collectEntities(true, TslInst(), _kMySpace);
	
// guard from dublicated TSLs
// delete previously inserted TSLs
	TslInst tsl;
	String sTslName = "hsbLayout-AssignPosnum";
	for (int i = arEnt.length() - 1; i >= 0; i--)
	{ 
		TslInst t = (TslInst)arEnt[i];
		if(t.scriptName() !=sTslName || t==_ThisInst)
		{ 
			continue;
		}
		// in debug mode the _ThisInst.scriptName() is called _HSB_PREVIEW
		// so in debug mode t!=_ThisInst and it will be deleted
		
		// delete
		if(!bDebug)
			arEnt[i].dbErase();
	}//next i
	
//End make sure no previous TSL "hsbLayout-AssignPosnum" is attached to this viewport//endregion
	

// make sure this tsl is executed before each TSL
	_ThisInst.setSequenceNumber(1);
	
//region Display of the TSL
	
	Display dp(1);
	if(_Viewport.length()==0)
	{ 
		dp.textHeight(dTextHeight);
		dp.draw(scriptName() + T(":|Add a viewport|"),_Pt0, _XW, _YW, 1, 0);
	}
	
//End Display of the TSL//endregion
	
// Trigger SelectViewPort//region
	String sTriggerSelectViewPort = T("|Select View Port|");
	addRecalcTrigger(_kContext, sTriggerSelectViewPort );
	if (_bOnRecalc && (_kExecuteKey==sTriggerSelectViewPort || _kExecuteKey==sDoubleClick))
	{
		_Viewport[0] = getViewport(T("|Select a viewport|"));
		setExecutionLoops(2);
		return;
	}//endregion
		
//region validate selected viewport
	
	Viewport vp = _Viewport[0];
	if(!vp.element().bIsValid())
	{ 
		// no element in viewport
		reportMessage(TN("|no valid elements in the viewport|"));
		eraseInstance();
		return;
	}
	
// get elements in the viewport 
	Element el = vp.element();
	if(!el.bIsValid())
	{ 
		reportMessage(TN("|no element found in the viewport|"));
		eraseInstance();
		return;
	}
	
//End validate selected viewport//endregion
	
	
//region calculation/numbering for genBeam
	
	// check if calculation/numbering of genbeams is prompted at the properties 
	int iIndex = sNoYes.find(sNoYesGenBeam);
	
	if(iIndex==1)
	{ 
		// From "No" "Yes", the "Yes" is selected
		// From GenBeam are derived ->Beam, Sheet, SIP
		GenBeam genBeam[] = el.genBeam();
		if(genBeam.length()<1)
		{ 
			reportMessage(TN("|no genBeam (beam, sheet or panel) found|"));
			return;
		}
		
		// get all zones
		int iZones[0];
		String sZoneTrim = sZone;
		// trim starting and ending whitespace characters from the string
		sZoneTrim.trimLeft();
		sZoneTrim.trimRight();
		if(sZoneTrim!="")
		{ 
			String sZoneI = "";
			for (int i=0;i<sZoneTrim.length();i++) 
			{ 
				char charI = sZoneTrim.getAt(i);
				String si = "" + charI;
				if(si!=";")
				{ 
					sZoneI += charI;
				}
				else
				{ 
					iZones.append(sZoneI.atoi());
					sZoneI = "";
				}
			}//next i
			if(sZoneI!="")
			{ 
				iZones.append(sZoneI.atoi());
			}
		}
		else
		{ 
			// if empty, then get all zones in consideration
			int _iZones[] ={ -5 ,- 4 ,- 3 ,- 2 ,- 1, 0, 1, 2, 3, 4, 5};
			iZones = _iZones;
		}
		
		// fix according to -5,-4,-3,-2,-1,0,1,2,3,4,5 from 10,9,8,7,6,5,4,3,2,1,0
		for (int i=iZones.length()-1; i>=0 ; i--) 
		{ 
			if(iZones[i]>5 && iZones[i]<11)
			{ 
				iZones[i] = -(iZones[i] - 5);
			}
			else if(abs(iZones[i])<6)
			{ 
				//-5;5
				continue;
			}
			else
			{ 
				// not allowed
				iZones.removeAt(i);
			}
		}//next i
		
		GenBeam genBeamZone[0];
		for (int i=0;i<iZones.length();i++) 
		{ 
			// get genBeams from each zone
			genBeamZone.append(el.genBeam(iZones[i])); 
		}//next i
		
	// loop all genBeamZone[] and assign posnum
		for (int i=0;i<genBeamZone.length();i++)
		{ 
			if(genBeamZone[i].posnum()>0)
			{ 
				// genbeam has a number, dont number it again
				continue;
			}
			//bLookForEqual=true
			int iAssignPosNum = genBeamZone[i].assignPosnum(nStartPosNumGenBeam, true);
			if (bDebug)reportMessage("\n" + scriptName() + " iAssignPosNum " + iAssignPosNum);
			
		}//next i
	}
	
//End calculation/numbering for genBeam//endregion
	
	
//region calculation/numbering of the TSL
	 
// chaeck if calculation is prompted in the properties
	iIndex = sNoYes.find(sNoYesTSL);
	
	if(iIndex==1)
	{ 
		// yes is selected
		// get all TSL of element
		TslInst tslInst[] = el.tslInst();
		for (int i=0;i<tslInst.length();i++) 
		{ 
			 if(tslInst[i].posnum()>0)
			{ 
				continue;
			}
			//bLookForEqual=true
			int iAssignPosNum = tslInst[i].assignPosnum(nStartPosNumTSL, true);
		}//next i
	}
	
//End calculation/numbering of the TSL//endregion


//region Display of the TSL
		
	dp.textHeight(dTextHeight);
	dp.draw(scriptName() + T(":|| "),_Pt0, _XW, _YW, 1, 0);

//End Display of the TSL//endregion 
 	
#End
#BeginThumbnail
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
;0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`?__9




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