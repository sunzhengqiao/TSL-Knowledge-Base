#Version 8
#BeginDescription
version value="1.6" date="12dec2019" author="thorsten.huck@hsbcad.com"
HSB-6199 xref panels are collected if childpanels refer to xref

This TSL runs exports.




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords Export;Exporter;MPN;Multi Project Nesting
#BeginContents
/// <History>//region
/// <version value="1.6" date="12dec2019" author="thorsten.huck@hsbcad.com"> HSB-6199 xref panels are collected if childpanels refer to xref </version>
///<version value="1.5" date="21jun17" author="thorsten.huck@hsbcad.com"> exporter groups ordered </version>
///<version value="1.4" date="03may17" author="thorsten.huck@hsbcad.com"> completely revised, properties combined </version>
///<version value="1.3" date="12apr17" author="thorsten.huck@hsbcad.com"> catalog naming issue fixed </version>
///<version value="1.2" date="12apr17" author="thorsten.huck@hsbcad.com"> minor translation issues fixed, properties categorized </version>
/// DT - 1.10 - 01.07.2013 -       Added option to select Elements along with associated entities.
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// Tsl to run exports.
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsb_ExportRunner")) TSLCONTENT
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

//region Properties
	String sFloorGroupNames[] = {};
	Group grFloorGroups[0];
	Group grAllGroups[] = Group().allExistingGroups();
	for( int i=0;i<grAllGroups.length();i++ ){
		Group grp = grAllGroups[i];
		if( grp.namePart(2) == "" && grp.namePart(1) != ""){
			sFloorGroupNames.append(grp.namePart(0) + " - "  + grp.namePart(1));
			grFloorGroups.append(grp);
		}
	}	
// order	
	for (int i=0;i<sFloorGroupNames.length();i++) 
	{ 
		for (int j=0;j<sFloorGroupNames.length()-1;j++)
		{
			if (sFloorGroupNames[j]>sFloorGroupNames[j+1])
			{
				sFloorGroupNames.swap(j,j+1);
				grFloorGroups.swap(j,j+1);	
			}
		}	 
	}	
	
	String sInsertTypes[] = 
	{
		T("|Project|"),
		T("|Current floor level|"),
		T("|Elements|"),
		T("|Entities|"),
		T("|Beams|"),
		T("|Sheets|"),
		T("|Panels|")
		
	};	
	sInsertTypes.append(sFloorGroupNames);
	String sInsertTypeName=T("|Entity Selection Mode|");	
	PropString sInsertType(nStringIndex++, sInsertTypes, sInsertTypeName);	
	sInsertType.setDescription(T("|Defines the type of selection|"));
	sInsertType.setCategory(category);	
	
	
	String sExporterGroups[0];
	sExporterGroups=ModelMap().exporterGroups();
	for (int i=0;i<sExporterGroups.length();i++) 
		for (int j=0;j<sExporterGroups.length()-1;j++) 
		{
			String s1=sExporterGroups[j];
			String s2=sExporterGroups[j+1];
			if (s1.makeUpper()>s2.makeUpper())
				sExporterGroups.swap(j,j+1);
		}
				

	String sExporterGroupName=T("|Exporter Group|");	
	PropString sExporterGroup(nStringIndex++, sExporterGroups, sExporterGroupName);	
	sExporterGroup.setDescription(T("|Defines the Exporter Group|"));
	sExporterGroup.setCategory(category);	
	
	
	String sAllowXRefName=T("|Allow XRef Selection|");	
	PropString sAllowXRef(nStringIndex++, sNoYes, sAllowXRefName);	
	sAllowXRef.setDescription(T("|Specifies wether the seection of XRef entities is allowed.|"));
	sAllowXRef.setCategory(category);

//End Properties//endregion 



//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			if (sEntries.findNoCase(sKey,-1)>-1)			
				setPropValuesFromCatalog(sKey);
			else
				showDialog();					
		}		
		else	
			showDialog();
		
		int nInsertType=sInsertTypes.find(sInsertType,0);
		int nFloorGroupName=sFloorGroupNames.find(sInsertType);
		int bAllowXRef = sNoYes.find(sAllowXRef, 0);
		String groupNames[0];
		
		Entity ents[0];
		
	//Select entire project	
		if( nInsertType == 0 )
		{
			// Do nothing. Empty list of floorgroups means export entire drawing.
		}
	//Select current group	
		else if( nInsertType == 1 )
		{
			Group grpCurrent = _kCurrentGroup;
			if( grpCurrent.namePart(2) == "" && grpCurrent.namePart(1) != "")
				groupNames.append(grpCurrent.name());
		}
	//Select elements	
		else if( nInsertType == 2 )
		{
			PrEntity ssE(T("|Select one or more elements to export|"), Element());
			ssE.allowNested(bAllowXRef);
			if( ssE.go())
				ents.append(ssE.set());
				
			for( int i=0;i<ents.length();i++ )
			{
				Entity ent = ents[i];
				Element el = (Element)ent;
				
				Group grpElement = el.elementGroup();
				
				// Element entities need to be collected unless we are selecting entities in which case
				// if only an element is selected then that is what we will export.
				if( el.bIsValid() && nInsertType < 4 )
				{
					Entity entsEl[] = grpElement.collectEntities(true, Entity(), _kModelSpace);
					_Entity.append(entsEl);
				}
				else
				{
					_Entity.append(ent);
				}
			}
		}		
	// Select entities	
		else if(nInsertType>=3 && nInsertType<=6)
		{
			PrEntity ssE;
			if (nInsertType==3)
				ssE = PrEntity(T("|Select entities to export|"), Entity());
			else if (nInsertType==4)
				ssE = PrEntity(T("|Select beams to export|"), Beam());
			else if (nInsertType==5)
				ssE = PrEntity(T("|Select sheets to export|"), Sheet());
			else if (nInsertType==6)
				ssE = PrEntity(T("|Select panels to export|"), Sip());			
			ssE.allowNested(bAllowXRef);
			if( ssE.go())
				ents.append(ssE.set());
				
				
		// get sips from potential xrefs
			if (bAllowXRef)
			{ 
				ChildPanel childs[0];
				MasterPanel masters[0];
				for (int i=0;i<ents.length();i++) 
				{ 
					if (ents[i].bIsKindOf(MasterPanel()))
						masters.append((MasterPanel)ents[i]);
					else if (ents[i].bIsKindOf(ChildPanel()))
						childs.append((ChildPanel)ents[i]);				 
				}//next i
				
			// get childs from masters
				for (int i=0;i<masters.length();i++) 
				{ 
					ChildPanel _childs[]= masters[i].nestedChildPanels();
					for (int j=0;j<_childs.length();j++) 
						if (childs.find(_childs[j])<0)
							childs.append(_childs[j]); 
				}//next i
				
			// append xref sips	
				for (int i = 0; i < childs.length(); i++)
				{		
					Sip sip = childs[i].sipEntity();
					String xrefName = sip.xrefName();
					if (xrefName!="" && ents.find(sip)<0)
						ents.append(sip);
				}				
			}
		
		}
	//Select floor level in floor level list	
		else if( nInsertType >6 && nFloorGroupName>-1)
		{
			Group grpFloor = grFloorGroups[nFloorGroupName];
			groupNames.append(grpFloor.name());
		}
		
	// set some export flags
		ModelMapComposeSettings mmFlags;
		mmFlags.addSolidInfo(TRUE); // default FALSE
		mmFlags.addAnalysedToolInfo(TRUE); // default FALSE
		mmFlags.addElemToolInfo(TRUE); // default FALSE
		mmFlags.addConstructionToolInfo(TRUE); // default FALSE
		mmFlags.addHardwareInfo(TRUE); // default FALSE
		mmFlags.addRoofplanesAboveWallsAndRoofSectionsForRoofs(TRUE); // default FALSE
		mmFlags.addCollectionDefinitions(TRUE); // default FALSE
		
		String strDestinationFolder = _kPathDwg;
		
		Map mpProjectInfoOverwrite;
		int bOk = false;
		if( ents.length() > 0 ){
			bOk = ModelMap().callExporter(mmFlags, mpProjectInfoOverwrite, ents, sExporterGroup, strDestinationFolder);
		}
		else if( groupNames.length() > 0 || nInsertType >6){ // export floor groups.
			bOk = ModelMap().callExporter(mmFlags, mpProjectInfoOverwrite, groupNames, sExporterGroup, strDestinationFolder);
		}
		
		if (!bOk)
			reportMessage("\n" + scriptName() + " " + T("|We apologize, but the call of the exporter has failed.|"));
		
		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion
	




#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BJDVI65O?VUA-<QI=W6[R82WS/M
M!)('H`.M6Z`"BBB@`HHHH`***J6.I66II,]C<QW"0RF&1HSD!QC(S[9%`%NB
MBB@`HHHH`****`"BBB@`HHHH`**:S*B%G8*H&22<`4D<B2QK)&=R,,J?44`/
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHKC/''BK^RK8Z?92?Z;*/G8?\LE/]3V_/TK*M6C1@YR-\/AYXBHJ<-V
M0Z]\0X]-U&2SL;9+GR^'D+X&[N!ZXKGKWXIZI#`T@MK.-1T^5B?YURMI:SWM
MU';6T;232-A5'4US6L_:(]3GM+A#&]O(T90]B#@UX4,5B:TF[V7]:'UU/+,'
M32@XIR\_S/H;P1X@?Q+X8@OY]GVC>\<P08`8'C_QTJ?QK4UNZELM`U&[@(6:
M"UED0D9`95)'\J\H^"^K^5J%_H[M\LR">('^\O##\01_WS7J/B;_`)%36/\`
MKQF_]`->[AY<\$SY;,:'L,1**VW7S/GSX7:C>:K\7-/O+^YDN;F03%Y)&R3^
MZ?\`3VKZ8KY&\!^(+7PMXOL]8O(II8(%D#)"`6.Y&48R0.I'>O3;G]H)!,1:
M^'6:+LTMWM8_@%./SKMJP<I:(\BC4C&/O,]LHKA_!'Q.TKQI,UFD,EEJ"KO^
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
G`<G<6.NZIM6Y5%13D`E0!^7-=+9PM;6,$#D%HXPI(Z<"IZ*`/__9
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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End