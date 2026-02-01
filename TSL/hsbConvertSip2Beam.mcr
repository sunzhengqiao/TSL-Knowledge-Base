#Version 8
#BeginDescription
Converts and copies sips into beams

version  value="1.3" date="23mar12" author="th@hsbCAD.de">
new option to keep or delete the original panel after conversion
X-Axis of panel always matches X-Axis of beam
properties will be copied, posnum will be applied if possible


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// converts and copies panels into beams
/// </summary>

/// <insert Lang=en>
/// Select the panels you wish to convert. If the increment of the posnum is greater 0 
/// the tool will try to assign a posnum with the value of panel.posnum + increment.
/// if this posnum is not available a warning will be shown in the command line
/// </insert>

///<version  value="1.3" date="23mar12" author="th@hsbCAD.de">new option to keep or delete the original panel after conversion</version>
///<version  value="1.2" date="23mar12" author="th@hsbCAD.de">X-Axis of panel always matches X-Axis of beam</version>
///<version  value="1.1" date="05dec11" author="th@hsbCAD.de">properties will be copied, posnum will be applied if possible</version>

// standards
	U(1,"mm");
	String propS[0],propD[0],propN[0];
	String sArNY[] = { T("No"), T("Yes")};
	
	propN.append(T("|Increment PosNum|") + " " + T("(< 1 = no automatic posnum)"));
	PropInt nIncr(0,10000,propN[propN.length()-1]);	
	PropString sDeleteSource(0,sArNY,T("|Delete origin body|"));	



// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		// show the dialog if no catalog in use
		if (_kExecuteKey == "")
			showDialog();			
		else
			// set properties from catalog
			setPropValuesFromCatalog(_kExecuteKey);	
		
		int bDeleteSource = sArNY.find(sDeleteSource,0);
		PrEntity ssE(T("Select sips"), Sip());
		Sip sp[0];
  		if (ssE.go())
		{
			Entity ents[0];
    		ents = ssE.set();
			for (int i = 0; i < ents.length(); i++)
				if (ents[i].bIsKindOf(Sip()))
					sp.append((Sip)ents[i]);
		}
		
		for (int i = sp.length()-1; i>=0; i--)
		{
			Element el = sp[i].element();
			Body bd = sp[i].realBody();
			Beam bmNew;
			bmNew.dbCreate(bd, sp[i].vecX(), sp[i].vecY(), sp[i].vecZ());
			if (el.bIsValid())
				bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
			bmNew.setMaterial(sp[i].style());
			bmNew.setName(sp[i].name());
			bmNew.setGrade(sp[i].grade());
			bmNew.setLabel(sp[i].label());
			bmNew.setSubLabel(sp[i].subLabel());
			bmNew.setInformation(sp[i].information());
			if (nIncr>0)
			{
				bmNew.assignPosnum(sp[i].posnum()+nIncr);
				if (bmNew.posnum()-nIncr>sp[i].posnum())
					reportMessage("\n" + T("|Required posnum could not be assigned to conversion result of panel:|") +sp[i].posnum() + " " + T("|Please check posnums|"));	
			}
			bmNew.setColor(sp[i].color());	
			if(bDeleteSource)
				sp[i].dbErase();
		}
		eraseInstance();
		return;
		
	}
//end on insert________________________________________________________________________________

		



#End
#BeginThumbnail
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
CZ;8VL%O`D%O$D,0'"1J%'Z5%:M4C9-_=_7^1=.G!ZK\3_]FU
`

#End
