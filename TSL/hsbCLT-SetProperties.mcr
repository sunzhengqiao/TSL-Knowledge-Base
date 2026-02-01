#Version 8
#BeginDescription
version value="1.4" date="22may17" author="thorsten.huck@hsbcad.com">
 bugfix label

DACH
/// Dieses TSL überschreibt die Eigenschaften (Material, Schnittklasse, Information, Label, Sublabel) von Panelen
/// des Auswahlsatzes, sowie aller Panele die im Auswahlsatz durch Masterpanele, Childpanele oder Frachtobjekte
/// referenziert werden.
/// Die Leereingabe einer Eigenschaft behält die existierenden Werte bei.

EN
/// This tsl sets properties (material, grade, information, label and sublabel) of all panels of the selection set
/// or being referenced by one of the selected master panels, child panels or any freight object
/// A blank property will keep the existing value.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl sets properties (material, grade, information, label and sublabel) of all panels of the selection set
/// or being referenced by one of the selected master panels, child panels or any freight object
/// A blank property will keep the existing value.
/// </summary>

/// <summary Lang=de>
/// Dieses TSL überschreibt die Eigenschaften (Material, Schnittklasse, Information, Label, Sublabel) von Panelen
/// des Auswahlsatzes, sowie aller Panele die im Auswahlsatz durch Masterpanele, Childpanele oder Frachtobjekte
/// referenziert werden.
/// Die Leereingabe einer Eigenschaft behält die existierenden Werte bei.
/// </summary>

/// History
///<version value="1.4" date="22may17" author="thorsten.huck@hsbcad.com"> bugfix label </version>
///<version value="1.2" date="15jul16" author="thorsten.huck@hsbcad.com"> '---' resets the property to blank </version>
///<version value="1.1" date="12jul16" author="thorsten.huck@hsbcad.com"> sublabel2 added </version>
///<version value="1.0" date="11jul16" author="thorsten.huck@hsbcad.com"> initial </version>

// constants
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=projectSpecial().find("debugTsl",0)>-1 || _bOnDebug;

// categories
	String sCategoryGeneral = T("|General|");

	
	String sDefaultDesc = " " + T("|Empty = unchanged|") + " " + T("|'---' = no value|");
	
	String sMaterialName=T("|Material|");	
	PropString sMaterial(nStringIndex++, "", sMaterialName);	
	sMaterial.setDescription(T("|Defines the Material.|")+sDefaultDesc);
	sMaterial.setCategory(sCategoryGeneral);

	String sGradeName=T("|Grade|");	
	PropString sGrade(nStringIndex++, "", sGradeName);	
	sGrade.setDescription(T("|Defines the Grade|")+sDefaultDesc);
	sGrade.setCategory(sCategoryGeneral);
	
	String sInformationName=T("|Information|");	
	PropString sInformation(nStringIndex++, "", sInformationName);	
	sInformation.setDescription(T("|Defines the Information.|")+sDefaultDesc);
	sInformation.setCategory(sCategoryGeneral);
	
	String sLabelName=T("|Label|");	
	PropString sLabel(nStringIndex++, "", sLabelName);	
	sLabel.setDescription(T("|Defines the Label.|")+sDefaultDesc);
	sLabel.setCategory(sCategoryGeneral);
	
	String sSublabelName=T("|Sublabel|");	
	PropString sSublabel(nStringIndex++, "", sSublabelName);	
	sSublabel.setDescription(T("|Defines the Sublabel.|")+sDefaultDesc);
	sSublabel.setCategory(sCategoryGeneral);			

	
	String sSublabel2Name=T("|Sublabel2|");	
	PropString sSublabel2(nStringIndex++, "", sSublabel2Name);	
	sSublabel2.setDescription(T("|Defines the Sublabel2.|")+sDefaultDesc);
	sSublabel2.setCategory(sCategoryGeneral);	
		
// start on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }	

	// silent/dialog
		if (_kExecuteKey.length()>0)
			setPropValuesFromCatalog(_kExecuteKey);	
		else
			showDialog();		
	
	// prompt for masterpanels
		PrEntity ssE(T("|Select panels(s) or any referenced entity (child or master panels, freight item(s), packages or trucks)|"), MasterPanel());
		ssE.addAllowedClass(TslInst());
		ssE.addAllowedClass(Sip());
		ssE.addAllowedClass(ChildPanel());
		
		Entity entsSet[0];
		if (ssE.go())
			entsSet= ssE.set();

	// collect what we have got from the selection set
		ChildPanel childs[0];
		Sip sips[0];
		TslInst tslPackages[0], tslTrucks[0], tslItems[0];
		MasterPanel masters[0];	 
		if(bDebug)reportMessage("\n"+ scriptName() + " " + entsSet.length() + " entities selected...");
		for (int i=0;i <entsSet.length();i++)
		{
			Entity ent = entsSet[i];
			if (ent.bIsKindOf(Sip ()))
				sips.append((Sip)ent);
			else if (ent.bIsKindOf(ChildPanel()))
				childs.append((ChildPanel)ent);
			else if (ent.bIsKindOf(TslInst ()))
			{
				TslInst tsl = (TslInst)entsSet[i];
				if (!tsl.bIsValid())continue;
				Map map = tsl.map();
				if(map.getInt("isTruckContainer"))
					tslTrucks.append(tsl);
				else if(map.getInt("isPackageContainer"))
					tslPackages.append(tsl);
				else if(map.getInt("isFreightItem"))
					tslItems.append(tsl);						
			}
			else if (ent.bIsKindOf(MasterPanel()))
				masters.append((MasterPanel)ent);								
		}
		

		
	// collect packages from trucks
		for (int i=0;i <tslTrucks.length();i++)
		{
			Entity ents[] = tslTrucks[i].entity();
			for (int e=0;e<ents.length();e++)
			{
				TslInst tsl = (TslInst)ents[e];
				if (!tsl.bIsValid())continue;
				Map map = tsl.map();
				if(map.getInt("isPackageContainer") && tslPackages.find(tsl)<0)
				{
					tslPackages.append(tsl);
					if (bDebug)reportMessage("\n	Package " + tsl.color() + " of truck " + i + " added.");	
				}	
			}	
		}	
		if(bDebug)reportMessage("\n	"+ tslPackages.length() + " packages");
				
	// collect items from packages
		for (int i=0;i <tslPackages.length();i++)
		{
			Entity ents[] = tslPackages[i].entity();
			for (int e=0;e<ents.length();e++)
			{
				TslInst tsl = (TslInst)ents[e];
				if (!tsl.bIsValid())continue;
				Map map = tsl.map();
				if(map.getInt("isFreightItem") && tslItems.find(tsl)<0)
				{
					tslItems.append(tsl);	
					//if (bDebug)reportMessage("\n		Item " + tsl.handle() + " of package " + i + " added.");	
				}						
			}	
		}
		if(bDebug)reportMessage("\n	"+ tslItems.length() + " items");					

	// collect panels from freight items
		for (int i=0;i<tslItems.length();i++)
		{
			TslInst tsl =tslItems[i];
			if (!tsl.bIsValid())continue;
			GenBeam gbs[] = tsl.genBeam();
			if (gbs.length()==1 && gbs[0].bIsKindOf(Sip()))
			{
				Sip sip = (Sip)gbs[0];
				if (sips.find(sip)<0)
					sips.append(sip);
			}		
		}
		if(bDebug)reportMessage("\n	"+ sips.length() + " panels by items");	

	// collect panels from masters
		for (int i=0;i<masters.length();i++)
		{
			MasterPanel master=masters[i];
			if (!master.bIsValid())continue;
			ChildPanel nestedChilds[] = master.nestedChildPanels();
			for (int j=0;j<nestedChilds.length();j++)
			{
				ChildPanel child = nestedChilds[j];
				if (childs.find(child )<0)
					childs.append(child);
			}		
		}
		if(bDebug)reportMessage("\n	"+ childs.length() + " childs in total, added childs by master");	

	// collect panels from childs
		for (int i=0;i<childs.length();i++)
		{
			ChildPanel child =childs[i];
			Sip sip = child.sipEntity();
			if (sips.find(sip)<0)
				sips.append(sip);
		}
		if(bDebug)reportMessage("\n	"+ sips.length() + " panels in total, added by childs");	

		
	// change properties
		for (int i=0;i<sips.length();i++)
		{
			Sip sip = sips[i];
			if (sMaterial.length()>0) sip.setMaterial((sMaterial=="---"?"":sMaterial));	
			if (sGrade.length()>0) sip.setGrade((sGrade=="---"?"":sGrade));
			if (sInformation.length()>0) sip.setInformation((sInformation=="---"?"":sInformation));
			if (sLabel.length()>0) sip.setLabel((sLabel=="---"?"":sLabel));
			if (sSublabel.length()>0) sip.setSubLabel((sSublabel=="---"?"":sSublabel));
			if (sSublabel2.length()>0) sip.setSubLabel2((sSublabel2=="---"?"":sSublabel2));
		}	
		

		eraseInstance();
		return;
	}
// END IF on insert__________________________________________________________



	
	
#End
#BeginThumbnail
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
$H`__V>N?
`




#End