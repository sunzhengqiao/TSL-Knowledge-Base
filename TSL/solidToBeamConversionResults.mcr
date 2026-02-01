#Version 8
#BeginDescription
version value="1.0" date="16aug19" author="dmytro.vakulenko@hsbcad.com"
First version of a script, carrier of solid to beam conversion results


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <History>//region
/// <version value="1.0" date="16aug19" author="dmytro.vakulenko@hsbcad.com"> First version of a script, carrier of solid to beam conversion results </version>
/// </History>

/// <summary Lang=en>
/// Carrier for solid to beam conversion results: some faces of a solid model are considered to be "bad" or "unrecognized".
/// Every bad face of a solid is saved as plane profile.
/// </summary>//endregion


// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	//endregion

	if (bDebug)reportMessage("\n" + scriptName() + " " + _kExecuteKey + " " + _ThisInst.handle());

// collect bad faces & original solid
	Map mapSource = _Map.getMap("source");			
	int bHasBody = mapSource.hasBody("bodyOriginal");
	int bHasBadFaces = mapSource.hasPlaneProfile("BadFace");
	
	reportMessage("\nBad faces are " + (bHasBadFaces ?  "" : "not ") + "detected");

// displaying items
	Display dp(-1);
	double dTxtH = U(30);
	dp.textHeight(dTxtH);

// triggers to visualize orignal body & bad faces
	String sTriggerVisualizeOriginalBody = T("|Visualize original body|");
	addRecalcTrigger(_kContext, sTriggerVisualizeOriginalBody );
	String sTriggerVisualizeBadFaces = T("|Visualize bad faces|");
	addRecalcTrigger(_kContext, sTriggerVisualizeBadFaces );

	if (_bOnRecalc && _kExecuteKey==sTriggerVisualizeOriginalBody) 
	{		
		dp.color(3);
		PlaneProfile profiles[] = mapSource.getBodyAsPlaneProfilesList("bodyOriginal");
		for(int p = 0; p < profiles.length(); p++)
			dp.draw(profiles[p]);
		return;
	}

	if (_bOnRecalc && _kExecuteKey==sTriggerVisualizeBadFaces) 
	{
		dp.color(1);
		for (int i = 0; i < mapSource.length(); ++i)
		{
			String keyName = mapSource.keyAt(i);
			if (keyName == "BadFace")
			{
				PlaneProfile planeProfile = mapSource.getPlaneProfile(i);
				dp.draw(planeProfile);
			}
		}
		return;
	}

// standard display
	dp.color(1);
	dp.draw("Bad faces!", _Pt0, _XE, _YE, 0, 0);
	

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