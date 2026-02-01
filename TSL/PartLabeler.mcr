#Version 8
#BeginDescription
Applied to or built into stickframe walls. Creates a label based on posnum or other criteria then records it to MapX for use in reporting/scheduling.

#Versions
V0.21 2/6/2024 Bugfix on building label array cc
V0.19 2/6/2024 Increased size of available labels cc
V0.17 10/4/2023 Will erase duplicates
V0.16 10/4/2023 Set critiria fields to use formatting dialog
0.15 9/26/2023 Bugfix on triggering posnum assignment cc
0.14 9/25/2023 Added ExecuteKey trigger for info assignment cc
0.12 9/25/2023 Bugfix in label indices cc





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 21
#KeyWords 
#BeginContents
/*
<>--<>--<>--<>--<>--<>--<>--<>____ Craig Colomb _____<>--<>--<>--<>--<>--<>--<>--<>



//######################################################################################
//############################ Documentation #########################################


//########################## End Documentation #########################################
//######################################################################################

                              craig.colomb@hsbcad.com
<>--<>--<>--<>--<>--<>--<>--<>_____ hsbcad.us  _____<>--<>--<>--<>--<>--<>--<>--<>

*/


String stSpecial = projectSpecial();
int bInDebug = stSpecial == "db" || stSpecial == scriptName();
if(_bOnDebug) bInDebug = true;

//set properties from map
if(_Map.hasMap("mpProps"))
{
	setPropValuesFromMap(_Map.getMap("mpProps"));
	_Map.removeAt("mpProps",0);
}

PropString psBeamCriteria(0, "@(posnum)", "Beam Criteria");
psBeamCriteria.setDescription("A comma seperated list of formats used to group like items for labeling");
psBeamCriteria.setDefinesFormatting("Beam");

PropString psSheetCriteria(1, "@(posnum)", "Sheet Criteria");
psSheetCriteria.setDescription("A comma seperated list of formats used to group like items for labeling");
psSheetCriteria.setDefinesFormatting("Sheet");

PropString psZones(2, "", "Zones to Label");

String stLabelStrategies[] = { T("|Zone|"), T("|Element|")};
PropString psLabelStrategy(3, stLabelStrategies, "Label Strategy");
psLabelStrategy.setDescription("Zone option restarts lableing with 'A' for each zone. Element option makes every label in the wall unique");
int bLabelPerZone = psLabelStrategy == stLabelStrategies[0];

String alphabet[] = { "A", "B", "C", "D", "E", "F", "G",
	"H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", 
	"T", "U", "V", "W", "X", "Y", "Z" };


if (_bOnInsert)
{ 
	showDialogOnce();
	if(insertCycleCount() > 1)
	{ 
		eraseInstance();
		return;
	}
	
	PrEntity pre("Select Elements", Element());
	
	Element elsSelected[0];
	if (pre.go() == _kOk) elsSelected = pre.elementSet();
	
	if(elsSelected.length() == 0)
	{ 
		eraseInstance();
		return;
	}
	
	
	
	//PREPARE TO CLONING
	// declare tsl props 
	TslInst tsl;
	String sScriptName = scriptName();
	
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Beam lstBeams[0];
	Entity lstEnts[1];
	Point3d lstPoints[0];
	lstPoints.append(_Pt0);
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	
	
	_Map.setMap("mpProps", mapWithPropValues());
		
	for(int i=0; i<elsSelected.length();i++){
		lstEnts[0] = elsSelected[i];
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,1,_Map );
	}
	
	eraseInstance();
	return;
}

if(_Element.length() != 1)
{ 
	eraseInstance();
	return;
}

// Assign selected element to el.
Element el = _Element[0];
if(! el.bIsValid())
{ 
	eraseInstance();
	return;
}

TslInst tsls[] = el.tslInst();
for (int i=0; i<tsls.length(); i++) {
	TslInst& otherTsl = tsls[i];
	if (otherTsl == _ThisInst || otherTsl.scriptName() != scriptName()) continue;
	otherTsl.dbErase();
}

Display dp(8);
dp.textHeight(U(.3, "inch"));
dp.draw("Labeler", el.ptOrg(), el.vecX(), - el.vecZ(), 1, 1);

//__only store data on insert or construction
int bWriteData = _bOnDbCreated || _bOnElementConstructed;
int bGeneratingConstruction = _bOnElementConstructed;

String stUpdateDataCommand = T("|Update Labels|");
addRecalcTrigger(_kContextRoot, stUpdateDataCommand);
if(_kExecuteKey == stUpdateDataCommand)
{ 
	bWriteData = true;
}

String stAssignPosnums = "bAssignPosnums";
int bAssignPosnums = _kExecuteKey == stAssignPosnums || ! bGeneratingConstruction;

if(bInDebug) reportMessage("\n_kExecuteKey = " + _kExecuteKey);


if(bWriteData || _kNameLastChangedProp != "" || bAssignPosnums)//__relabel when set to do so or when Properties have changed
{ 
	Map mpByZone[0];
	int iZones[0];
	String stZones[] = psZones.tokenize(",");
	if(stZones.length() == 0)//__nothing entered in psZones, so use all
	{ 
		for(int i=-5; i<6; i++)
		{
			iZones.append(i);
		}
	}
	else
	{
		for (int i = 0; i < stZones.length(); i++)
		{
			String stZone = stZones[i];
			if (stZone == "0")
			{
				iZones.append(0);
				continue;
			}
			
			int iZone = stZone.atoi();
			if (iZone == 0) continue; //__string was not an int
			iZones.append(iZone);
		}
	}
	
	for (int i = 0; i < iZones.length(); i++)
	{
		int iZone = iZones[i];
		Map mpZone;
		mpZone.setInt("iZone", iZone);
		GenBeam gbs[] = el.genBeam(iZone);
		if (gbs.length() == 0) continue;
		
		mpZone.setEntityArray(gbs, true, "ents", "ents", "ents");
		mpByZone.append(mpZone);
	}
	
	String beamFormats[] = psBeamCriteria.tokenize(",");
	String sheetFormats[] = psSheetCriteria.tokenize(",");
	Map mpLabelByKey;
	int iLabelIndex = 0;
	for(int i=0; i<mpByZone.length(); i++)
	{
		Map mpZone = mpByZone[i];
		if (bLabelPerZone) iLabelIndex = 0;
		Entity entsZone[] = mpZone.getEntityArray("ents", "ents", "ents");
		
		for(int k=0; k<entsZone.length(); k++)
		{
			Entity ent = entsZone[k];
			GenBeam gb = (GenBeam)ent;
			int iPosnum = gb.posnum();
			
			if(bAssignPosnums ) gb.assignPosnum(1, true);
//			
//			
			String formats[] = gb.bIsKindOf(Beam()) ? beamFormats : sheetFormats;
			
			String compareKey = "st";//__ensure compare key is not simple number, which can lead to issues when used as Map key
			for(int k=0; k<formats.length(); k++)
			{
				String st = gb.formatObject(formats[k]);
				compareKey += st;
			}
			
			String stLabel;
			if (mpLabelByKey.hasString(compareKey)) //__this type has been encountered, update existing data
			{
				stLabel = mpLabelByKey.getString(compareKey);	
			}
			else
			{ 
				if(iLabelIndex <= 25)
				{ 
					stLabel = alphabet[iLabelIndex++];			
				}
				else
				{ 
					stLabel = alphabet[(iLabelIndex - 26) /25] + alphabet[(iLabelIndex -1) % 25];
					iLabelIndex++;
				}
				
				mpLabelByKey.setString(compareKey, stLabel);
			}		
			
			Map mpLabel;
			mpLabel.setString("stLabel", stLabel);
			gb.setSubMapX("mpLabel", mpLabel);
		}
	}
	
}
	
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="203" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Bugfix on building label array" />
      <int nm="MAJORVERSION" vl="0" />
      <int nm="MINORVERSION" vl="21" />
      <str nm="DATE" vl="2/6/2024 9:32:39 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Increased size of available labels" />
      <int nm="MAJORVERSION" vl="0" />
      <int nm="MINORVERSION" vl="19" />
      <str nm="DATE" vl="2/6/2024 8:14:26 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Set critiria fields to use formatting dialog" />
      <int nm="MAJORVERSION" vl="0" />
      <int nm="MINORVERSION" vl="16" />
      <str nm="DATE" vl="10/4/2023 8:50:08 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Bugfix on triggering posnum assignment" />
      <int nm="MAJORVERSION" vl="0" />
      <int nm="MINORVERSION" vl="15" />
      <str nm="DATE" vl="9/26/2023 8:10:25 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Added ExecuteKey trigger for info assignment" />
      <int nm="MAJORVERSION" vl="0" />
      <int nm="MINORVERSION" vl="14" />
      <str nm="DATE" vl="9/25/2023 8:05:43 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Bugfix in label indices" />
      <int nm="MAJORVERSION" vl="0" />
      <int nm="MINORVERSION" vl="12" />
      <str nm="DATE" vl="9/25/2023 3:40:03 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End