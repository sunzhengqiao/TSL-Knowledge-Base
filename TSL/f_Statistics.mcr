#Version 8
#BeginDescription
#Versions:
1.2 17.03.2023 HSB-18360: include massElements in the weight calculation 
version value="1.1" date="15aug2018" author="thorsten.huck@hsbcad.com"
translation fixed

Select entities and press OK. The cumulated weight will be displayed in the command line


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords Stacking,statistic,weight
#BeginContents
/// <History>//region
/// #Versions:
/// 1.2 17.03.2023 HSB-18360: include massElements in the weight calculation Author: Marsel Nakuci
/// <version value="1.1" date="15aug2018" author="thorsten.huck@hsbcad.com"> translation fixed </version>
/// <version value="1.0" date="30jan2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entities and press OK. The cumulated weight will be displayed in the command line
/// </insert>

/// <summary Lang=en>
/// This tsl creates 
/// </summary>//endregion

// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	//endregion
	
// READ SETTINGS//region
// settings are stored in external files but they are only updated upon request or if no settings are found in the dictionary of the dwg
	String sDictEntry = "f_Stacking";
	String sDictionary = "hsbTSL";
	MapObject mo(sDictionary ,sDictEntry);
	int nKlh=projectSpecial().makeUpper()=="KLH";
	
// get/set the map
	Map mapSetting;
	if (mo.bIsValid()) 
		mapSetting = mo.map();
		
// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
//	// silent/dialog
//		String sKey = _kExecuteKey;
//		sKey.makeUpper();
//
//		if (sKey.length()>0)
//		{
//			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
//			for(int i=0;i<sEntries.length();i++)
//				sEntries[i] = sEntries[i].makeUpper();	
//			if (sEntries.find(sKey)>-1)
//				setPropValuesFromCatalog(sKey);
//			else
//				setPropValuesFromCatalog(sLastInserted);
//		}
//		else
//			showDialog();
		
	// get items
		PrEntity ssE(T("|Select item(s)|"), TslInst());
		ssE.addAllowedClass(GenBeam());
		ssE.addAllowedClass(MassElement());
		ssE.addAllowedClass(MassGroup());
		ssE.addAllowedClass(ChildPanel());
		
	  	if (ssE.go())
			_Entity.append(ssE.set());
			
		if (bDebug)
			_Pt0 = getPoint();	
		return;
	}	
// end on insert	__________________	


// declare values to output
	double dSumWeight, dSumVolume;
	int nQty, nSubQty;
	
// identify where the weight property should be taken from
	Map m = mapSetting.getMap("Truck");
	String sWeightPropertyTokens[] = m.getString("WeightProperty").tokenize(".");// weight property path 
// loop items and collect entities
	Entity entsCollected[0];
	for (int i=0;i<_Entity.length();i++) 
	{ 

	// cases
		Element element;
		Sip sip;
		GenBeam genBeam;
		TslInst tslInst;
		MassElement massElement;
		MassGroup massGroup;
		ChildPanel child;
		Entity entRef=_Entity[i];
		
	// item		
		TslInst tsl = (TslInst)_Entity[i]; 
		if (tsl.bIsValid() && tsl.subMapXKeys().find("Hsb_Item")>-1)
		{ 
//			Map map = tsl.map();
//			if (map.getInt("isTruck") || map.getInt("isLayer")) { continue;};
//			
			Entity _ents[]=tsl.entity();
			
		// append anything unique
			for (int j=0;j<_ents.length();j++) 
			{ 
				entRef = _ents[j];
				break;
			}		
			String s = tsl.scriptName();
		}

		String sPropertySetName, sPropertyName;
		String sPropertySetNames[0];
		Entity ents[0];
		int nMass;
		if (entRef.bIsKindOf(Element()))
		{
			sPropertySetNames = Element().availablePropSetNames();
			element = (Element)entRef;
			
			GenBeam genbeams[] = element.genBeam();
			nSubQty += genbeams.length();
			nQty++;
			for (int g=0;g<genbeams.length();g++)
			{ 
				ents.append(genbeams[g]); 
			}
		}
		else if (entRef.bIsKindOf(ChildPanel()))
		{
			child = (ChildPanel)entRef;
			sip = child.sipEntity();
			sPropertySetNames = Sip().availablePropSetNames();
			entRef = sip;
			ents.append(entRef);
		}		
		else if (entRef.bIsKindOf(Sip()))
		{
			sPropertySetNames = Sip().availablePropSetNames();
			sip = (Sip)entRef;
			ents.append(entRef);
		}
		else if (entRef.bIsKindOf(GenBeam()))
		{
			sPropertySetNames = GenBeam().availablePropSetNames();
			genBeam = (GenBeam)entRef;
			ents.append(entRef);
		}
//		else if (entRef.bIsKindOf(TslInst()))
//		{
//			sPropertySetNames = TslInst().availablePropSetNames();
//			tslInst = (TslInst)entRef;
//			ents.append(entRef);
//		}
		else if (entRef.bIsKindOf(MassElement()))
		{
			sPropertySetNames = MassElement().availablePropSetNames();
			massElement = (MassElement)entRef;
			ents.append(entRef);
			nMass=true;
		}
		else if (entRef.bIsKindOf(MassGroup()))
		{
			sPropertySetNames = MassGroup().availablePropSetNames();
			massGroup = (MassGroup)entRef;
			ents.append(entRef);
			nMass=true;
		}
		else
		{
			//reportMessage(TN("|The entity type|") + " " + entRef.typeDxfName() + T("|is not supported.|"));
			continue;
		}
		
	// loop all collected entities
		for (int e=0;e<ents.length();e++) 
		{ 
			Entity ent = ents[e]; 
		// avoid duplicates
			if (entsCollected.find(ent)<0)
				entsCollected.append(ent);
			else
				{ continue;}
			double dWeight;
			if(nMass && nKlh)
			{ 
				int n = sPropertySetNames.find("MassElement");
				if (n>-1)
				{
					sPropertySetName = sPropertySetNames[n];
					Map map = ent.getAttachedPropSetMap(sPropertySetName);
					
					String sPropertyName = "Weight";
					if (map.hasDouble(sPropertyName))
						dWeight = map.getDouble(sPropertyName);
					else if (map.hasString(sPropertyName))
						dWeight = map.getString(sPropertyName).atof();
					//reportMessage("\nWeight found in " + sPropertySetName + " " + dWeight);
				}
			}
			else
			{ 
				if (sWeightPropertyTokens.length()>0)
				{ 
					int n = sPropertySetNames.find(sWeightPropertyTokens[0]);
					if (n>-1)
					{
						sPropertySetName = sPropertySetNames[n];
						Map map = ent.getAttachedPropSetMap(sPropertySetName);
						
						String sPropertyName = sWeightPropertyTokens[1];
						if (map.hasDouble(sPropertyName))
							dWeight = map.getDouble(sPropertyName);
						else if (map.hasString(sPropertyName))
							dWeight = map.getString(sPropertyName).atof();
						//reportMessage("\nWeight found in " + sPropertySetName + " " + dWeight);
					}
				}
			}
		// fall back to mapIO
			if (dWeight<=0)
			{ 
				//reportMessage("\nWeight not found in propset");
				Map mapIO;
				Map mapEntities;
				mapEntities.appendEntity("Entity", ent); // append entities of calculation
				mapIO.setMap("Entity[]",mapEntities);
				TslInst().callMapIO("hsbCenterOfGravity", mapIO);
				Point3d ptCen = mapIO.getPoint3d("ptCen");// returning the center of gravity
				dWeight= mapIO.getDouble("Weight");// 	
			}
			
			if (dWeight<=dEps)
			{
				reportMessage("\n	" + ent.typeDxfName() +T(": |could not collect weight|"));
			}
			dSumWeight += dWeight;
			dSumVolume += entRef.realBody().volume();
			nQty++;
		}
	}
	
// output
	nQty -= nSubQty;
	reportMessage("\n" + scriptName() + ": " +nQty + " " + (nQty>1?T("|items|"):T("|item|"))+ " " + (nSubQty>0?"("+nSubQty+ " " + T("|child items|")+") ":"") + dSumWeight + "kg");
	eraseInstance();
	return;
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="168" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18360: include massElements in the weight calculation" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="3/17/2023 1:28:43 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End