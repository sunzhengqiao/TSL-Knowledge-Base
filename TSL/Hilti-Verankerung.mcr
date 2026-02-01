#Version 8
#BeginDescription
This TSL defines a HILTI Stexon connection 
It can be inserted to bottom or top plate of the walls
TSL instances can be attached to a stud or not.
User can select between 2 predefined types "HCW" and "HCWL" and the type "Custom"
Two predifined types have predefined properties and conditions
like (drill diameter, min drill depth) or conditions that need to be fulfilled like (min space rom beam edge)
If the type "Custom" is selected, the user can freely define the drill diameter or depth

When using the Hilti connectors the user must also refere to the 
European Technical Assessment ETA-21/0357 of 2025/01/31
"HCW Wood conector ETA 21-0357 (31.01.2025)"
The document contains among others guidance about the 
Load-carrying capacity and requirements for min. cross sections
and edge distances

#Versions:
Version 2.17 09.07.2025 HSB-24279: Baufritz specific modification , Author: Marsel Nakuci
Version 2.16 23/05/2025 HSB-24083: Add block representation for HSW hanger bolt (stockschraube) , Author Marsel Nakuci
Version 2.15 23/05/2025 HSB-24083: Start the stud milling from the bottom of the stud; Add property offset for the stud milling , Author Marsel Nakuci
Version 2.14 08.05.2025 HSB-23993: Add width and height for the milling at stud for HCWL , Author: Marsel Nakuci
Version 2.13 20.03.2025 HSB-20098: Add options House/drill for the HCWL tooling  , Author: Marsel Nakuci
Version 2.12 06/03/2025 HSB-23567: Add milling depth at studs for HCW-L , Author Marsel Nakuci
Version 2.11 06/03/2025 HSB-23568: Remove the check for edge distance requirements; add note to user for the ETA-21/0357 , Author Marsel Nakuci
Version 2.10 04/03/2025 HSB-23612: Modifications for Baufritz , Author Marsel Nakuci
2.9 11.02.2025 HSB-19773 Fixed position of milled in fastener 
2.8 12.12.2024 HSB-19773 Added missing hanger bolt
2.7 10.12.2024 HSB-19773 Adjust Tsl to the requirements of Hilti.
2.6 03.12.2024 HSB-23098: comment out tooling for HCW-P (request from Markus Baufritz) Author: Marsel Nakuci
Version 2.5 11.10.2024 20241011: Fix tooling (House) at HCWL for Baufritz , Author Marsel Nakuci
Version 2.4 08.10.2024 HSB-19775: Change TSL image , Author Marsel Nakuci
Version 2.3 08.10.2024 HSB-22780: For Baufritz add HCWL-K , Author Marsel Nakuci
Version 2.2 22.09.2024 20240922: Fix beamcut at stud for HCW-L , Author Marsel Nakuci
2.1 10/09/2024 HSB-22652: Add option Holzdolle for Baufritz Marsel Nakuci
2.0 22/08/2024 HSB-19773: Draw block only when it is found 
1.29 20/06/2024 HSB-19773: Add Property "Marking" to mark HCWL at studs 
1.28 20/06/2024 HSB-19774: Add block representation for HCW and HCWL 
1.27 06/05/2024 HSB-21970: when changing catalog via trigger, dont change position properties if not a HCWL 
1.26 18.04.2024 BF20240418: Additional hole for HWC pushed to the other side 
1.25 08.04.2024 HSB-21790: for Baufritz ignore first plate if <=27; For reference point use stud with color 32 
1.24 12/03/2024 HSB-21590: make depth property active to set it in the catalog 
1.23 12/03/2024 HSB-21590: House tool should enter from below to control the depth of the tool 
1.22 11/03/2024 HSB-21590: Add HCW-P connector 
1.21 20.11.2023 HSB-20649: Fix entering point: Fix House for HCWL 
1.20 09.05.2023 HSB-18848: "Diameter" and "Version" modification in relation to eachother 
1.19 08.05.2023 HSB-18848: Let property "Diameter" always active for Baufritz
1.18 15.03.2023 HSB-18322: Remove commands to generate circles, fix pt0 drag in element view, change X distance when version is set to HCWL
1.17 15.02.2023 HSB-17955: Add triggers to add/remove plates for drilling/milling for Baufritz
1.16 15.02.2023 HSB-17955: Fix: change the default drill depth to 100 for Baufritz 
1.15 14.02.2023 HSB-17955: change the default drill depth to 100 for Baufritz
1.14 14.02.2023 HSB-17955: No stud milling for "Baufritz"; Stud drilling if drill center inside the stud 
1.13 14.02.2023 HSB-17955: correct position when stud dimensions are changed 
1.12 19.01.2023 20230119: remove drilling for studs for HCW
1.11 12.01.2023 HSB-17526: remove boundary constrains for Baufritz
1.10 12.01.2023 HSB-17526: Change rotation for Baufritz
1.9 12.01.2023 HSB-17526: Dont show error messages for Baufritz
1.8 30.09.2022 HSB-16670: Distinguish grouping of circle objects EG/DG
1.7 29.09.2022 HSB-16670: Show error if no plates found when TSL attached to a stud
1.6 28.09.2022 HSB-16670: Fix bug for proeprty index
1.5 12.09.2022 HSB-15091: replace Pline object with circle
1.4 24.03.2022 HSB-15004: add triggers to generate/cleanup marking pline entities
1.3 22.11.2021 HSB-13683: add property rotation
1.2 13.09.2021 HSB-12697: add ruleset check
1.1 08.09.2021 HSB-12697: add description

















































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 17
#KeyWords Hilti,Stexon,HCW,HCWL
#BeginContents
/// <History>//region
/// <summary Lang=de>
/// This TSL defines a HILTI Stexon connection 
/// It can be inserted to bottom or top plate of the walls
/// TSL instances can be attached to a stud or not.
/// User can select between 2 predefined types "HCW" and "HCWL" and the type "Custom"
/// Two predifined types have predefined properties and conditions
/// like (drill diameter, min drill depth) or conditions that need to be fulfilled like (min space rom beam edge)
///	If the type "Custom" is selected, the user can freely define the drill diameter or depth
/// 
/// When using the Hilti connectors the user must also refere to the 
/// European Technical Assessment ETA-21/0357 of 2025/01/31
/// "HCW Wood conector ETA 21-0357 (31.01.2025)"
/// The document contains among others guidance about the 
/// Load-carrying capacity and requirements for min. cross sections
/// and edge distances

/// New type HCW-S is available. The HCW-S is in comparison to the HCW
/// Connector only the Screw socket without the clamping mechanism (no withdrawal capacity).
/// Dieses TSL definiert einen Hiltiverbdinder an einem Wandständer, einer Schwelle oder an einer Schwele und einem kreuzenden Deckenbalken.
/// </summary>

/// <insert Lang=de>
/// Einen oder mehrere Wandständer wählen.
/// </insert>

/// History
// #Versions: 
// 2.17 09.07.2025 HSB-24279: Baufritz specific modification , Author: Marsel Nakuci
// 2.16 23/05/2025 HSB-24083: Add block representation for HSW hanger bolt (stockschraube) , Author Marsel Nakuci
// 2.15 23/05/2025 HSB-24083: Start the stud milling from the bottom of the stud; Add property offset for the stud milling , Author Marsel Nakuci
// 2.14 08.05.2025 HSB-23993: Add width and height for the milling at stud for HCWL , Author: Marsel Nakuci
// 2.13 20.03.2025 HSB-20098: Add options House/drill for the HCWL tooling  , Author: Marsel Nakuci
// 2.12 06/03/2025 HSB-23567: Add milling depth at studs for HCW-L , Author Marsel Nakuci
// 2.11 06/03/2025 HSB-23568: Remove the check for edge distance requirements; add note to user for the ETA-21/0357 , Author Marsel Nakuci
// 2.10 04/03/2025 HSB-23612: Modifications for Baufritz , Author Marsel Nakuci
// 2.9 11.02.2025 HSB-19773 Fixed position of milled in fastener 
// 2.8 12.12.2024 HSB-19773 Added missing hanger bolt
// 2.7 10.12.2024 HSB-19773 Adjust Tsl to the requirements of Hilti.
// 2.6 03.12.2024 HSB-23098: comment out tooling for HCW-P (request from Markus Baufritz) Author: Marsel Nakuci
// 2.5 11.10.2024 20241011: Fix tooling (House) at HCWL for Baufritz , Author Marsel Nakuci
// 2.4 08.10.2024 HSB-19775: Change TSL image , Author Marsel Nakuci
// 2.3 08.10.2024 HSB-22780: For Baufritz add HCWL-K , Author Marsel Nakuci
// 2.2 22.09.2024 20240922: Fix beamcut at stud for HCW-L , Author Marsel Nakuci
// 2.1 10/09/2024 HSB-22652: Add option Holzdolle for Baufritz Marsel Nakuci
// 2.0 22/08/2024 HSB-19773: Draw block only when it is found Marsel Nakuci
// 1.29 20/06/2024 HSB-19773: Add Property "Marking" to mark HCWL at studs Marsel Nakuci
// 1.28 20/06/2024 HSB-19774: Add block representation for HCW and HCWL Marsel Nakuci
// 1.27 06/05/2024 HSB-21970: when changing catalog via trigger, dont change position properties if not a HCWL Marsel Nakuci
// 1.26 18.04.2024 BF20240418: Additional hole for HWC pushed to the other side  Author: Markus Sailer
// 1.25 08.04.2024 HSB-21790: for Baufritz ignore first plate if <=27; For reference point use stud with color 32 Author: Marsel Nakuci
// 1.24 12/03/2024 HSB-21590: make depth property active to set it in the catalog Marsel Nakuci
// 1.23 12/03/2024 HSB-21590: House tool should enter from below to control the depth of the tool Marsel Nakuci
// 1.22 11/03/2024 HSB-21590: Add HCW-P connector; It takes the same drill as HCW but the dübel/dowel is different Marsel Nakuci
// 1.21 20.11.2023 HSB-20649: Fix entering point: Fix House for HCWL Author: Marsel Nakuci
// 1.20 09.05.2023 HSB-18848: "Diameter" and "Version" modification in relation to eachother Author: Marsel Nakuci
// 1.19 08.05.2023 HSB-18848: Let property "Diameter" always active for Baufritz Author: Marsel Nakuci
// 1.18 15.03.2023 HSB-18322: Remove commands to generate circles, fix pt0 drag in element view, change X distance when version is set to HCWL Author: Marsel Nakuci
// 1.17 15.02.2023 HSB-17955: Add triggers to add/remove plates for drilling/milling for Baufritz Author: Marsel Nakuci
// 1.16 15.02.2023 HSB-17955: Fix: change the default drill depth to 100 for Baufritz Author: Marsel Nakuci
// 1.15 14.02.2023 HSB-17955: change the default drill depth to 100 for Baufritz Author: Marsel Nakuci
// 1.14 14.02.2023 HSB-17955: No stud milling for "Baufritz"; Stud drilling if drill center inside the stud Author: Marsel Nakuci
// 1.13 14.02.2023 HSB-17955: correct position when stud dimensions are changed Author: Marsel Nakuci
// 1.12 19.01.2023 20230119: remove drilling for studs for HCW Author: Marsel Nakuci
// 1.11 12.01.2023 HSB-17526: remove boundary constrains for Baufritz Author: Marsel Nakuci
// 1.10 12.01.2023 HSB-17526: Change rotation for Baufritz Author: Marsel Nakuci
// 1.9 12.01.2023 HSB-17526: Dont show error messages for Baufritz Author: Marsel Nakuci
// 1.8 30.09.2022 HSB-16670: Distinguish grouping of circle objects EG/DG Author: Marsel Nakuci
// 1.7 29.09.2022 HSB-16670: Show error if no plates found when TSL attached to a stud Author: Marsel Nakuci
// 1.6 28.09.2022 HSB-16670: Fix bug for proeprty index Author: Marsel Nakuci
// 1.5 12.09.2022 HSB-15091: replace Pline object with circle Author: Marsel Nakuci
// 1.4 24.03.2022 HSB-15004: add triggers to generate/cleanup marking pline entities Author: Marsel Nakuci
// Version 1.3 22.11.2021 HSB-13683: add property rotation Author: Marsel Nakuci
// Version 1.2 13.09.2021 HSB-12697: add ruleset check Author: Marsel Nakuci
// Version 1.1 08.09.2021 HSB-12697: add description Author: Marsel Nakuci
// Version 3.10 29.04.2021 Dialog box image of the TSL modified Author: Marsel Nakuci
///<version value="3.9" date=20oct20" author="marsel.nakuci@hsbcad.com"> HSB-9339: collision test </version>
///<version value="3.8" date=21sep20" author="marsel.nakuci@hsbcad.com"> HSB-5432: fix wrong formatted translation keys </version>
///<version value="3.7" date=30jul19" author="thorsten.huck@hsbcad.com"> detection of tooling beams enhanced </version>
///<version value="3.6" date=26jul19" author="marsel.nakuci@hsbcad.com"> make the coordinate of _PtG[0] of text wrt vecY of wall fix </version>
///<version value="3.5" date=09jun19" author="marsel.nakuci@hsbcad.com"> create dependency with the distribution TSL BF-Stexon-Verteilung </version>
///<version value="3.4" date=18apr19" author="marsel.nakuci@hsbcad.com"> place stexon by default on the right side and fix dimensioning for stexons d=42  </version>
///<version value="3.3" date=13mar19" author="thorsten.huck@hsbcad.com"> Einzelplatzierung immer rechts, Ausnahme letzter Ständer  </version>
///<version value="3.2" date=14feb19" author="thorsten.huck@hsbcad.com"> Einzelplatzierung immer links, Ausnahme letzter Ständer, Koordinatenbemassung an jedem Stexon, Ständerbohrung nur bei Kollision mit Kerndutchmesser, Fräsung an kollidierenden Ständern </version>
///<version value="3.1" date=09jan19" author="thorsten.huck@hsbcad.com"> Direktbearbeitungsdialog ergänzt, Füllhözer werden mit zweitem Bohrungsdurchmesser gebohrt </version>
///<version value="3.0" date=08jan19" author="thorsten.huck@hsbcad.com"> Füllhözer werden mit zweitem Bohrungsdurchmesser gebohrt </version>
///<version value="2.9" date=12dec18" author="thorsten.huck@hsbcad.com"> Kataloge im Kontext verfügbar </version>
///<version value="2.8" date=12dec18" author="thorsten.huck@hsbcad.com"> beidseitiges Einfügen möglich, Duplizieren über Kontextbefehl, Koordinatenbemassung der ersten Verankerung, Farbcodierung  </version>
///<version value="2.7" date=08nov18" author="thorsten.huck@hsbcad.com"> Langloch wird als Tasche ausgeführt </version>
///<version value="2.6" date=08nov18" author="thorsten.huck@hsbcad.com"> Langloch wird wieder als Zapfen ausgeführt </version>
///<version value="2.5" date=08nov18" author="thorsten.huck@hsbcad.com"> Langloch wird als Tasche ausgeführt </version>
///<version value="2.4" date=07nov18" author="thorsten.huck@hsbcad.com"> Stexon Export hinzugefügt  </version>
///<version value="2.2" date=05may17" author="thorsten.huck@hsbcad.com"> neuer Einfügemodus Element / Deckenbalken  </version>

/// commands
// command to insert the instance
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Hilti-Verankerung")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Side|") (_TM "|Hilti wählen|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Copy + Mirror|") (_TM "|Hilti wählen|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Stütze wählen|") (_TM "|Hilti wählen|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Hilti Export|") (_TM "|Hilti wählen|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|<KATALOGEINTRAG>|") (_TM "|Hilti wählen|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Generate Marking Circle|") (_TM "|Hilti wählen|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Cleanup Marking Circle|") (_TM "|Hilti wählen|"))) TSLCONTENT
//endregion

// constants //region
	U(1,"mm");
	double dEps=U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true; break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	String sProjectSpecial=projectSpecial();
	sProjectSpecial.makeUpper();
	int bBaufritz=sProjectSpecial=="BAUFRITZ";
	// extra gap to bring the HCWL Bündig to the stud edge
	// for Baufritz this value is 8mm
	double dFlushExtraGap=U(9.1);
//	double dFlushExtraGap=U(8);
	if(bBaufritz)
	{ 
		dFlushExtraGap=U(0);
	}
//endregion


//region Functions
//region drawBlock
// this will draw the block representation of the hcwl	
Map drawBlock(Map _min)
{ 
	Display dp(7);
	if(_min.hasInt("Color"))
	{ 
		dp.color(_min.getInt("Color"));
	}
	
	String _sBlock;
	if(_min.hasString("BlockName"))
	{ 
		_sBlock=_min.getString("BlockName");
	}
	Vector3d _vx=_XW;
	Vector3d _vy=_YW;
	Vector3d _vz=_ZW;
	if(_min.hasVector3d("vx"))
	{ 
		_vx=_min.getVector3d("vx");
	}
	if(_min.hasVector3d("vy"))
	{ 
		_vy=_min.getVector3d("vy");
	}
	if(_min.hasVector3d("vz"))
	{ 
		_vz=_min.getVector3d("vz");
	}
	double _dOffsetY=U(0);
	double _dOffsetZ=U(0);
	double _dOffsetX=U(0);
	if(_min.hasDouble("OffsetY"))
	{
		_dOffsetY=_min.getDouble("OffsetY");
	}
	if(_min.hasDouble("OffsetZ"))
	{
		_dOffsetZ=_min.getDouble("OffsetZ");
	}
	if(_min.hasDouble("OffsetX"))
	{
		_dOffsetX=_min.getDouble("OffsetX");
	}
	Point3d _pts[]=_min.getPoint3dArray("pts");
	Block block(_sBlock);
	for (int p=0;p<_pts.length();p++) 
	{ 
//		Point3d _ptBlock=_pts[p]-U(22)*_vy+_vz*_dOffsetY+_dOffsetZ*_vy;
		Point3d _ptBlock=_pts[p]-U(0)*_vy+_vz*_dOffsetY+_dOffsetZ*_vy
			+_vx*_dOffsetX;
		dp.draw(block,_ptBlock,_vx,_vy,_vz);
	}//next p
}
//End drawBlock//endregion 		
//End Functions//endregion 

//region Properties
// HILTI versions
	category = T("|Version|");
	String sVersionName=T("|Version|");
	// HSB-21590
	String sVersions[] ={ T("|Custom|"), "HCW", "HCWL","HCW-P"};
	String sAuswahl,sAuswahl1;
	if(bBaufritz)
	{ 
		// HSB-22652
		sAuswahl ="Holzdolle";
		// HSB-22780
		sAuswahl1 ="HCWL+K";
		String sVersionsBf[] ={ T("|Custom|"), "HCW", "HCWL","HCW-P",sAuswahl,sAuswahl1};
		sVersions=sVersionsBf;
	}
	// 0
	PropString sVersion(nStringIndex++, sVersions, sVersionName);
	sVersion.setDescription(T("|Defines the Version|"));
	sVersion.setCategory(category);
	
// DRILL
	category = T("|Drill|");
	String sDiameterName=T("|Diameter|");	
	// 0
	PropDouble dDiameter(nDoubleIndex++, U(30), sDiameterName);	
	dDiameter.setDescription(T("|Defines the Diameter|"));
	dDiameter.setCategory(category );
	
	String sDepthName=T("|Depth|");
	double dDepthDefault=U(250);
	if(bBaufritz)dDepthDefault=U(100);
	// 1
	PropDouble dDepth(nDoubleIndex++, dDepthDefault, sDepthName);
	dDepth.setDescription(T("|Defines the Depth|"));
	dDepth.setCategory(category );
	
	// HSB-20098
	// 5
	String sToolingTypeHcwlName=T("|Tooling Type|")+" HCWL";
	String sToolingTypeHcwls[]={T("|House|"),T("|Drill|")};
	PropString sToolingTypeHcwl(5, sToolingTypeHcwls, sToolingTypeHcwlName);	
	sToolingTypeHcwl.setDescription(T("|Defines the tooling type for HCWL|"));
	sToolingTypeHcwl.setCategory(category);
		
// 2. DRILL
//	category = "2. Bohrung";
	category = T("|Second drill|");
	String sDiameterSinkName=T("|Diameter|")+" ";
	// HSB-16670:
	// 7
	PropDouble dDiameterSink(7, U(0), sDiameterSinkName);	
	dDiameterSink.setDescription("Wert > Durchmesser = Sackloch, Wert <= Durchmesser = Ständerbohrung");
	dDiameterSink.setCategory(category );
	// HSB-16670:
	String sDepthSinkName=T("|Depth|")+ " ";
	// 8
	PropDouble dDepthSink(8, U(0), sDepthSinkName);
	dDepthSink.setDescription(T("|Defines the drill depth|"));
	dDepthSink.setCategory(category );
	
// ALIGNMENT
	category = T("|Alignment|");	
	String sOffsetAxisZName=T("|Z-Offset from Axis|");
	// 2
	PropDouble dOffsetAxisZ(nDoubleIndex++, U(0), sOffsetAxisZName);
	dOffsetAxisZ.setDescription(T("|Defines the Z Offset from the axis|"));
	dOffsetAxisZ.setCategory(category );
	
//	String sEdgeOffsetXName="X-Randabstand";
	String sEdgeOffsetXName=T("|Edge offset|")+" X";
	// 3
	PropDouble dEdgeOffsetX(nDoubleIndex++, U(0), sEdgeOffsetXName);
//	dEdgeOffsetX.setDescription("Legt den Abstand von der Stabkante fest. Nur für Stützenmodus relevant.");
	dEdgeOffsetX.setDescription(T("|Defines the offset from the stud edge. Only relevant when stud is available|"));
	dEdgeOffsetX.setCategory(category );
	
	// angle to control the tooling orientation
	String sRotationName=T("|Rotation|");
	// 4
	PropDouble dRotation(nDoubleIndex++, U(0), sRotationName);
	dRotation.setDescription(T("|Defines the Rotation of the tooling|"));
	dRotation.setCategory(category);
	double _dRotation=dRotation+U(90);
	if(bBaufritz)
	{
	// HSB-17526		
		_dRotation = dRotation;
	}
	double _dRotationConnector=U(90);
//	if(bBaufritz)
//	{
//	// HSB-17526		
//		_dRotationConnector=U(0);
//	}
// MILLING
	category = T("|Milling|");
	String sWidthName=T("|Width|");
	// 5
	PropDouble dWidth(nDoubleIndex++, U(0), sWidthName);
	dWidth.setDescription(T("|Defines the width of the milling at the bottom of the plate|"));
	dWidth.setCategory(category);
	
	String sDepthName2=T("|Depth|")+"  ";
	// 6
	PropDouble dDepth2(nDoubleIndex++, U(0), sDepthName2);
//	dDepth2.setDescription("Definiert die Tiefe der Ausfräsung");
	dDepth2.setDescription(T("|Defines the depth of the milling at the bottom of the plate|"));
	dDepth2.setCategory(category);
	
	// HSB-23567: add milling depth for HCW-L at stud
	String sDepthMillingStudName=T("|Milling depth stud|");
	// HSB-23567
	// 9
	PropDouble dDepthMillingStud(9, U(0), sDepthMillingStudName);	
	dDepthMillingStud.setDescription(T("|Defines the milling depth for HCW-L at studs|"));
	dDepthMillingStud.setCategory(category);
	// 10 HSB-23993
	String sWidthMillingStudName=T("|Milling width stud|");
	PropDouble dWidthMillingStud(10, U(0), sWidthMillingStudName);	
	dWidthMillingStud.setDescription(T("|Defines the milling width for HCW-L at studs|"));
	dWidthMillingStud.setCategory(category);
	// 11 HSB-23993
	String sHeightMillingStudName=T("|Milling height stud|");
	PropDouble dHeightMillingStud(11, U(0), sHeightMillingStudName);	
	dHeightMillingStud.setDescription(T("|Defines the milling height for HCW-L at studs|"));
	dHeightMillingStud.setCategory(category);
	// HSB-24083
	String sOffsetMillingStudName=T("|Milling offset stud|");
	PropDouble dOffsetMillingStud(12, U(0), sOffsetMillingStudName);	
	dOffsetMillingStud.setDescription(T("|Defines the offset in height of the milling. The start of milling is the bottom of the stud|"));
	dOffsetMillingStud.setCategory(category);
	
// GENERAL
	category = T("|General|");
	String sTxtName=T("|Description|");
	// 1
	PropString sTxt(nStringIndex++, "", sTxtName);
	sTxt.setDescription(T("|Defines the description.|"));
	sTxt.setCategory(category );
	
//	String sZonesName = "Zonen Textdarstellung";
	String sZonesName =T("|Text description at zones|");
//	PropString sZones(1,"0",sZonesName);;
	// 2
	PropString sZones(nStringIndex++,"0",sZonesName);
//	sZones.setDescription("Definiert die Zonen der Textdarstellung"+T("|Separate multiple entries by|")+ "' ;'");
	sZones.setDescription(T("|Defines the zones where the text will be shown.|")+T("|Separate multiple entries by|")+ "' ;'");
	sZones.setCategory(category );
	
//	String sColorName=T("|Color|");	
//	PropInt nColor(nIntIndex++, 1, sColorName);	
//	nColor.setDescription(T("|Defines the Color|"));
//	nColor.setCategory(category);

	category=T("|Marking|");
	// marking at studs for HCWL
	String sMarkingName=T("|Marking|");
	String sMarkings[]={T("|None|"),T("|Mark|"),T("|Mill|")};
	// 3
	PropString sMarking(nStringIndex++,sMarkings,sMarkingName);
	sMarking.setDescription(T("|Defines the Marking at Studs for HCWL|"));
	sMarking.setCategory(category);
	int nMarking=sMarkings.find(sMarking);
	
	category = T("|Fasteners|");
	String sFastenerNames=T("|Fastener|");
	String sFasteners[]={ T("|None|"),T("|HST3 M12x165|"),T("|HST3 M12x185|"),T("|HAS-U 8.8 M12x180|"),T("|HAS-U 8.8 M12x200|"), T("|Stockschraube HSW M12x220/60 8.8|"), T("|Stockschraube HSW M12x140/60 8.8|")};
	// 4
	PropString sFastener(nStringIndex++,sFasteners,sFastenerNames);	
       sFastener.setDescription(T("|Defines the fastener for a connection to a concrete wall/floor or a wooden component.|"));
	sFastener.setCategory(category);	
	double sFastenersLength[] = { U(165), U(185), U(180), U(200), U(220), U(140)};
	String sFastenersArticles[]={ "2107687","2107687","2226626","2226626", "2316491", "216376"};
	int nFastener = sFasteners.find(sFastener);
//End Properties//endregion
	
	
	int nc = 3;
	double dTxtH = U(50);

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
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);
		}
		else
		{
			// set drill and 2. Drill as hidden
			dDiameter.setReadOnly(_kHidden);
			// HSB-21590: depth should be possible to change
//			dDepth.setReadOnly(_kHidden);
			
			dDiameterSink.setReadOnly(_kHidden);
			dDepthSink.setReadOnly(_kHidden);
			showDialog();
			int nVersion = sVersions.find(sVersion);
//			reportMessage("\n"+scriptName()+" "+T("|sVersion|")+sVersion);
//			reportMessage("\n"+scriptName()+" "+T("|nVersion|")+nVersion);
			
			if(nVersion==0)
			{ 
				// custom is selected
				sVersion.setReadOnly(true);
				// custom is selected, prepare properties for dialog
				dDiameter.setReadOnly(false);
				dDepth.setReadOnly(false);
				dDiameterSink.setReadOnly(false);
				dDepthSink.setReadOnly(false);
				// 
				showDialog("---");
			}
		}
			
	// prepare TSL creation
		TslInst tslNew; Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
		GenBeam gbsTsl[1]; Entity entsTsl[1]; Point3d ptsTsl[1];
		int nProps[]={};
		double dProps[]={dDiameter,dDepth,dOffsetAxisZ,dEdgeOffsetX,dRotation,dWidth,
			dDepth2,dDiameterSink,dDepthSink,dDepthMillingStud,dWidthMillingStud,dHeightMillingStud,
			dOffsetMillingStud};
		String sProps[]={sVersion,sTxt,sZones,sMarking,sFastener,sToolingTypeHcwl};
		Map mapTsl;
		
	// selection set
		// depending from the sset it will create instances dependent to
		// 1) stud
		// 2) plate
		// 3) a plate and a joist
		
		PrEntity ssE(T("|Select stud(s), bottom plate(s) or element(s)|"), Beam());
		ssE.addAllowedClass(ElementWallSF());
		Beam beams[0];
		Element elements[0];
		if (ssE.go()) 
		{
			elements=ssE.elementSet();
			beams=ssE.beamSet();
		}
		
	// remove elements which are referenced by a beam
		Beam bmJoists[0];
		for (int i=beams.length()-1; i>=0 ; i--)
		{ 
			Beam& bm=beams[i];
			Element el = bm.element();
			
			if (el.bIsValid())
			{ 
				int n = elements.find(el);
				if (n >- 1)elements.removeAt(n);
			} 
			else 
			{
				bmJoists.append(bm);
				//reportMessage("\n" + scriptName() + ": " +T("|Beam| ") + bm.name() + " ("+ bm.posnum()+")"+ T("|excluded because not part of an element.|") );				
				beams.removeAt(i); // not linked to an element -> remove
			}
		}//next i
		
	//region Get studs and create per stud
		Beam studs[] = _ZW.filterBeamsParallel(beams);
		int bStudMode;
		
//		reportMessage("\nlooping studs"+studs.length());
		for (int i=0;i<studs.length();i++) 
		{ 
			Beam bm=studs[i];
//			reportMessage("\nlooping stud "+bm.handle() + " with tools " + bm.eToolsConnected());
		// validate if an instance is already attached to this vertical beam
			int bAllowLR[] ={ true, true}; // by default it is allowed to add one Hilti per side
			
		// get studs of the element to find out if it is the last stud
			Element el = bm.element();
			if (el.bIsValid())
			{ 
				Beam _studs[] = el.vecX().filterBeamsPerpendicularSort(el.beam());
				// last stud cannot have Hilti on the right
				if (bm == _studs[_studs.length() - 1])
					bAllowLR[1] = false;
				// first stud cannot have Hilti on the left
				if(bm == _studs[0])
					bAllowLR[0] = false;
			}

			
			Entity entTools[] = bm.eToolsConnected();
			for (int e=0;e<entTools.length();e++)
				if (entTools[e].bIsKindOf(TslInst()))	
				{
					TslInst tsl =(TslInst)entTools[e];
					if (tsl.scriptName()==scriptName())
					{
						Map m = tsl.map();
						int bFlip = m.getInt("FlipX");
						
						if (bFlip)bAllowLR[0] = false;
						else bAllowLR[1] = false;
					}
					if (!bAllowLR[0] && !bAllowLR[1]) break;
				}					
	
		// validate alignment and dummy state
			if (bm.bIsDummy())continue;

			if (!bAllowLR[0] && !bAllowLR[1])
			{
				// neither left or right is possible for the Hilti
				reportMessage("\n" + scriptName() + T("|already attached to beam| ") + bm.name() + "(" + bm.posnum() + ")");
				continue;
			}
		
		// preset flip state, default is right side, if left is allowed set flip to true
			if (bAllowLR[1])mapTsl.setInt("FlipX", false);
			else if (bAllowLR[0])mapTsl.setInt("FlipX", true);
//			reportMessage(("\nflipx is set to ") + mapTsl.getInt("FlipX") + " of " + bAllowLR);
			
			ptsTsl[0] = bm.ptCen();
			gbsTsl[0] = bm;	
			entsTsl[0] = bm.element();
			
		// create the instance		
			tslNew.dbCreate(scriptName(),_XW,_YW,gbsTsl,entsTsl,
				ptsTsl,nProps,dProps,sProps,_kModelSpace, mapTsl);
			bStudMode = true;
		}//next i
		if (bStudMode)
		{ 
			eraseInstance();
			return;
		}			
	//endregion End get studs and create per stud

	//region Plate mode
		Beam plates[] = _ZW.filterBeamsPerpendicularSort(beams);		
	// single plate
		int bJoistMode = plates.length() > 1;
		if (plates.length()==1)
		{ 
		// prompt for point input
			while(1)
			{ 
				PrPoint ssP(TN("|Select point|")+ T(", |<Enter> to select joist(s)|")); 
				if (ssP.go() == _kOk)
				{
					Point3d pt = ssP.value();
					ptsTsl[0] = pt;
					gbsTsl[0] = plates[0];
					entsTsl[0] = plates[0].element();
					// create the instance		
					tslNew.dbCreate(scriptName(),_XW,_YW,gbsTsl,entsTsl,
						ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
					eraseInstance();
					return;
				}
				else	
				{
					bJoistMode=true;
					break;				
				}
			}			
		}			
	//endregion End Plate mode	
	
	//region Joist with plate mode
		if (bJoistMode)
		{ 
			gbsTsl.setLength(2);
			PrEntity ssE(T("|Select joist(s)|"), Beam());
			Beam joists[0];
			if (ssE.go())
				joists = _ZW.filterBeamsPerpendicularSort(ssE.beamSet());	
			
		// remove those which are in the plates collection
			for (int i=joists.length()-1; i>=0 ; i--) 
			{ 
				if (plates.find(joists[i])>-1)
				{
					reportMessage(TN("|removing joist|"));
					joists.removeAt(i); 				
				}
			}//next i
			
		// get location if one josit and one plate and if parallel
			Point3d ptsInt[0];
			if (plates.length()==1 & joists.length()==1 && joists[0].vecX().isParallelTo(plates[0].vecX()))
			{ 
			// prompt for point input
				while(1)
				{ 
					PrPoint ssP(TN("|Select point|")); 
					if (ssP.go() == _kOk)
						ptsInt.append(ssP.value());
					else	
						break;				
				}				
			}
			
		// create combinations which do intersect
			for (int i=0;i<plates.length();i++) 
			{ 
				Beam& plate= plates[i]; 
				gbsTsl[0] = plate;
				entsTsl[0] = plate.element();
				
				Vector3d vecX = plate.vecX();
				Vector3d vecZ = plate.vecD(_ZW);
				Vector3d vecY = vecX.crossProduct(-vecZ);
				Point3d pt = plate.ptCenSolid();
				PlaneProfile ppPlate = plate.envelopeBody().shadowProfile(Plane(pt, vecY));
				ppPlate.transformBy(-vecZ * plate.dD(vecZ));
				
				for (int j=0;j<joists.length();j++)
				{ 
					Beam& joist= joists[j];
					gbsTsl[1] = joist;
					Vector3d vecXJ = joist.vecX();
					if (vecX.isParallelTo(vecXJ) && ptsInt.length()<1)continue; // parallel joists not supported
					
					PlaneProfile ppJoist = joist.envelopeBody().getSlice(Plane(pt, plate.vecD(vecXJ)));
					ppJoist.intersectWith(ppPlate);
				
				// parallel locations
					if (ppJoist.area()>pow(dEps,2))
					{ 
						for (int p=0;p<ptsInt.length();p++) 
						{ 
							ptsTsl[0] = ptsInt[p]; 
							tslNew.dbCreate(scriptName(),_XW,_YW,gbsTsl,entsTsl,
								ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);						 
						}//next p		
					}
				// not parallel
					else if (ppJoist.area()>pow(dEps,2))
					{ 
						ptsTsl[0] = Line(pt,vecX).intersect(Plane(joist.ptCen(), joist.vecD(vecX)),0);
					// create the instance		
						tslNew.dbCreate(scriptName(),_XW,_YW,gbsTsl,entsTsl,
							ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);						
					}
					else
						reportMessage("\n"+ scriptName() + " no intersection");
				}//next j
			}//next i	
		// job done
			eraseInstance();
			return;
		}
	//endregion End Joist with plate mode
	
	//region Element/plate mode
	// prompt for point input
		gbsTsl.setLength(0);
		if (bmJoists.length()<1)
		{ 
			while(1 && elements.length()>0)
			{ 
				PrPoint ssP(TN("|Select point|")); 
				if (ssP.go() == _kOk)
				{
					Point3d pt = ssP.value();
					ptsTsl[0] = pt;
					
				// find relevant element: multiple elements require input in plan view
					if (elements.length()>1)
					{ 
						for (int i=0;i<elements.length();i++) 
						{ 
							Element& el = elements[i];
							PlaneProfile pp(el.plOutlineWall());
							if (pp.pointInProfile(pt)==_kPointInProfile)
							{ 
								entsTsl[0] = el;
							// create the instance		
								tslNew.dbCreate(scriptName(),_XW,_YW,gbsTsl,entsTsl,
									ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
								break;
							}
						}//next i
					}
				// with one element selected you can select the point also in element view
					else
					{ 
						Element& el = elements[0];
						pt += el.vecZ()*(el.vecZ().dotProduct(el.ptOrg()-pt)-.5*el.dBeamWidth());
						entsTsl[0] = el;
					// create the instance		
						tslNew.dbCreate(scriptName(),_XW,_YW,gbsTsl,entsTsl,
							ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
					}
				}
				else	
					break;				
			}
		}
		else if (elements.length()==1)
		{ 	
			Element el = elements[0];
			Vector3d vecY = el.vecY();
			Point3d ptRef = el.segmentMinMax().ptMid();
		// get base plates
			Beam bmPlates[0];
			bmPlates = vecY.filterBeamsPerpendicularSort(Beam().filterBeamsHalfLineIntersectSort(el.beam(), ptRef+vecY*U(10e3) ,-vecY) );
			Point3d ptBase = ptRef;
			if (bmPlates.length()>0)
				ptBase = Line(ptRef,vecY).intersect(Plane(bmPlates[0].ptCen(),vecY),-.5*bmPlates[0].dD(vecY));	
			ptBase.vis(2);
		// remove plates which are not on same base
			for (int i=bmPlates.length()-1; i>=0 ; i--) 
			{ 
				Point3d pt = bmPlates[i].ptCenSolid()-vecY*.5*bmPlates[0].dD(vecY);
				if (abs(vecY.dotProduct(ptBase-pt))>dEps)
					bmPlates.removeAt(i);
				else
					bmPlates[i].envelopeBody().vis(i);
			}//next i
			
		// loop plates and joists
			for (int i=0;i<bmPlates.length();i++) 
			{ 
				gbsTsl.setLength(2);
				gbsTsl[0]= bmPlates[i]; 
				entsTsl[0] = el;
			
				for (int j=0;j<bmJoists.length();j++) 
				{
				// create the instance
					gbsTsl[1]= bmJoists[j]; 
					tslNew.dbCreate(scriptName(),_XW,_YW,gbsTsl,entsTsl,
						ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
				}
			}//next i
		}
	//endregion End Element/plate mode

		eraseInstance(); // erase the calling instance
		return;	
	}
// end on insert	__________________//endregion

// wait in dummy mode
	if (_Map.getInt("Dummy"))
	{ 
		return;
	}

// validate element reference
	if (_Element.length()<1)
	{
		reportMessage(T("|This tool requires one element.|") + " " + T("|Tool will be deleted.|"));
		eraseInstance();
		return;
	}
	
// validate selection set
	if (_Element.length()<1 || !_Element[0].bIsKindOf(ElementWall()))		
	{
		reportMessage("\n" + scriptName() + " " + T("|could not find reference to element.|"));
		eraseInstance();
		return;				
	}	
	int nVersion = sVersions.find(sVersion);
	int nToolingTypeHcwl;// HSB-20098
	if(nVersion!=2)
	{ 
		sToolingTypeHcwl.setReadOnly(_kHidden);
	}
	else if(nVersion==2)
	{ 
		// HCWL
		nToolingTypeHcwl=sToolingTypeHcwls.find(sToolingTypeHcwl);
	}
	
	if(bBaufritz)
	{ 
		// for baufritz
		if(_kNameLastChangedProp==sVersionName)
		{ 
			if(nVersion==1 || nVersion==3)
			{ 
				// HCW-p has the same tooling as the hcw
				dDiameter.set(U(37));
			}
			else if(nVersion==2 || nVersion==5)
			{ 
				dDiameter.set(U(42));
			}
			else if(nVersion==4)
			{ 
				// HSB-22652 Holzdolle
				dDiameter.set(U(34));
			}
		}
		if(_kNameLastChangedProp==sDiameterName)
		{ 
		// diameter was changed
			if(dDiameter!=U(37) && dDiameter!=U(42) && dDiameter!=U(34))
			{ 
				// custom
				sVersion.set(sVersions[0]);
			}
			else if(dDiameter==U(37))
			{ 
				if(sVersion!=sVersions[1] && sVersion!=sVersions[3])
				{
					sVersion.set(sVersions[1]);
				}
			}
			else if(dDiameter==U(42) && nVersion==2)
			{ 
				sVersion.set(sVersions[2]);
			}
			else if(dDiameter==U(42) && nVersion==5)
			{ 
				// HSB-22780
				sVersion.set(sVersions[5]);
			}
			else if(dDiameter==U(34))
			{ 
				// HSB-22652 Holzdolle
				sVersion.set(sVersions[4]);
			}
		}
		nVersion = sVersions.find(sVersion);
		if(nVersion==1 || nVersion==3)
		{ 
			dDiameter.set(U(37));
		}
		else if(nVersion==2 || nVersion==5)
		{ 
			dDiameter.set(U(42));
		}
		else if(nVersion==4)
		{ 
			// HSB-22652 Holzdolle
			dDiameter.set(U(34));
		}
		if(dDiameter!=U(37) && dDiameter!=U(42) && dDiameter!=U(34))
		{ 
			sVersion.set(sVersions[0]);
		}
		else if(dDiameter==U(37))
		{ 
			if(sVersion!=sVersions[1] && sVersion!=sVersions[3])
			{
				sVersion.set(sVersions[1]);
			}
		}
		else if(dDiameter==U(42) && nVersion==2)
		{ 
			sVersion.set(sVersions[2]);
		}
		else if(dDiameter==U(42) && nVersion==5)
		{ 
			sVersion.set(sVersions[5]);
		}
		else if(dDiameter==U(34))
		{ 
			// HSB-22652 Holzdolle
			sVersion.set(sVersions[4]);
		}
	}
	nVersion = sVersions.find(sVersion);
	if(nVersion==1 || nVersion==3)
	{ 
		// HCW or HCW-P is selected
//		if(!bBaufritz)
		dDiameter.set(U(37));
		// minimum 70 mm depth
		if (dDepth < U(70))dDepth.set(U(70));
		if(!bBaufritz)
			dDiameter.setReadOnly(_kReadOnly);
		dDepth.setReadOnly(false);
		dDiameterSink.setReadOnly(_kHidden);
		dDepthSink.setReadOnly(_kHidden);
	}
	else if(nVersion==2 || nVersion==5)
	{ 
		// HCWL is selected, slotted hole, diameter 42
		if(!bBaufritz)
			dDiameter.set(U(42));
		if(!bBaufritz)
			dDiameter.setReadOnly(_kReadOnly);
		dDepth.setReadOnly(false);
		dDiameterSink.setReadOnly(_kHidden);
		dDepthSink.setReadOnly(_kHidden);
	}
	if(bBaufritz)
	{ 
		// for Baufritz Holzdolle
		if(nVersion==4)
		{ 
			// HSB-22652 Holzdolle is selected, slotted hole, diameter 34
			if(!bBaufritz)
				dDiameter.set(U(34));
			if(!bBaufritz)
				dDiameter.setReadOnly(_kReadOnly);
			dDepth.setReadOnly(false);
			dDiameterSink.setReadOnly(_kHidden);
			dDepthSink.setReadOnly(_kHidden);
		}
	}
//region dependency to Hilti-Verteilung
	for (int i = 0; i < _Entity.length(); i++)
	{
		TslInst _tslVerteilung = (TslInst)_Entity[i];
		if (_tslVerteilung.bIsValid())
		{
			if(_tslVerteilung.scriptName()=="Hilti-Verteilung" )
			{ 
				// set dependency
				setDependencyOnEntity(_tslVerteilung);
				_Map.setInt("iDependencyVerteilung", true);
				break;
			}
		}
	}

	int iDependencyVerteilung = _Map.getInt("iDependencyVerteilung");
	if(iDependencyVerteilung)
	{ 
		// contains the distribution, so is dependent on it
		int itslVerteilungFound = false;
		for (int i = 0; i < _Entity.length(); i++)
		{
			TslInst _tslVerteilung = (TslInst)_Entity[i];
			if (_tslVerteilung.bIsValid())
			{
				if (_tslVerteilung.scriptName() == "Hilti-Verteilung" )
				{
					// tsl found
					itslVerteilungFound = true;
					break;
				}
			}
		}
		if(!itslVerteilungFound)
		{ 
			// distribution TSL Hilti-Verteilung has been deleted
			// delete the TSL
			eraseInstance();
			return;
		}
	}

//End dependency to Hilti-Verteilung//endregion 
	
// standards
	ElementWall el = (ElementWall)_Element[0];
	CoordSys cs =el.coordSys();
	Vector3d vecX = cs.vecX();
	Vector3d vecY = cs.vecY();
	Vector3d vecZ = cs.vecZ();
	Point3d ptOrg = cs.ptOrg();
	assignToElementGroup(el, true,0,'E');
	int bExposed = el.exposed();
	
	Point3d ptRef, ptMid;
	Plane pnZ(ptOrg, vecZ);

//region assign potential stud, joist and/or plate
	Beam stud, joist, plate;
	if (_Beam.length()>0 && _Beam[0].vecX().isParallelTo(vecY)) 
	{
		stud = _Beam[0];
		if(_Entity.find(stud)<0)
			_Entity.append(stud);
		setDependencyOnEntity(stud);
	}
	else if (_Beam.length()>0 && _Beam[0].vecX().isPerpendicularTo(vecY)) 
		plate = _Beam[0];		

	
	Vector3d vecXstud=vecX,vecYstud=vecY,vecZstud=vecZ;
	if(stud.bIsValid())
	{ 
		vecXstud=stud.vecD(vecXstud);
		vecZstud=vecXstud.crossProduct(vecYstud);
		vecZstud.normalize();
	}
//	vecXstud.vis(_Pt0, 1);
//	vecYstud.vis(_Pt0, 3);
//	vecZstud.vis(_Pt0, 5);
	if (_Beam.length()>1 && plate.bIsValid() && _Beam[1].vecX().isPerpendicularTo(_ZW))
	{
		joist = _Beam[1];	
		Vector3d vecXJ = joist.vecX();
		Vector3d vecXP = plate.vecX();
		if (!vecXP.isParallelTo(vecXJ))
		{
			_Pt0 = Line(plate.ptCenSolid(), vecXP).intersect(Plane(joist.ptCenSolid(), joist.vecD(vecXP)), 0);
			_ThisInst.setAllowGripAtPt0(false);
		}
	
	// validate intersection and location
		else
		{ 
			PlaneProfile ppPlate = plate.envelopeBody().shadowProfile(Plane(_Pt0, vecY));
			PlaneProfile ppJoist = joist.envelopeBody().shadowProfile(Plane(_Pt0, vecY));
			PlaneProfile ppInt = ppJoist;
			ppInt.intersectWith(ppPlate);
			if (ppInt.pointInProfile(_Pt0)!=_kPointInProfile)
			{ 
				reportMessage("\n" + scriptName() + ": " +T("|invalid location between plate and parallel joist.|"));
				eraseInstance();
				return;	
			}	
		}
	}
	else if (!_ThisInst.allowGripAtPt0())
		_ThisInst.setAllowGripAtPt0(true);
//endregion End assign potential stud, joist and/or plate



// get segMinMax based on zone 0
	Beam beams[] = el.beam();
	PlaneProfile ppZn0(cs);
	for (int i=0;i<beams.length();i++) 
	{ 
		Beam& b= beams[i];
		if (b.bIsDummy() || b.myZoneIndex()!=0)continue;
		PlaneProfile pp = b.envelopeBody(false, true).shadowProfile(pnZ);
		if (ppZn0.area()<pow(dEps,2))
			ppZn0 = pp;
		else	
			ppZn0.unionWith(pp);
	}//next i
	ppZn0.shrink(-dEps);
	ppZn0.shrink(dEps);
	
	//ppZn0.vis(4);
	
// set segmentMinMax
	LineSeg segmentMinMax;
	if (ppZn0.area()>pow(dEps,2))
	{ 
		segmentMinMax = ppZn0.extentInDir(vecX);
	}
	else
		segmentMinMax = el.segmentMinMax();
	double dXEl = abs(vecX.dotProduct(segmentMinMax.ptStart() - segmentMinMax.ptEnd()));
	double dYEl = abs(vecY.dotProduct(segmentMinMax.ptStart() - segmentMinMax.ptEnd()));
	
	ptMid = segmentMinMax.ptMid();
	ptMid += vecY * vecY.dotProduct(ptOrg - ptMid) + vecZ * vecZ.dotProduct((ptOrg - vecZ * .5 * el.dBeamWidth()) - ptMid);
	
	
	if(stud.bIsValid())
	{ 
		Point3d ptMidStud=stud.ptCen();
		ptMid+=vecX*vecX.dotProduct(ptMidStud-ptMid);
		ptMid+=vecZ*vecZ.dotProduct(ptMidStud-ptMid);
	}
	Line lnX(ptMid + vecZ * dOffsetAxisZ, vecX);
	if(stud.bIsValid())
	{ 
		lnX=Line (ptMid + vecZstud * dOffsetAxisZ, vecXstud);
	}
	ptRef = lnX.closestPointTo(_Pt0);

// Trigger//region
// TriggerFlipSide
	int bTestLocation = _Map.getInt("TestLocation") || bDebug || _bOnDbCreated;
	int bFlipX = _Map.getInt("FlipX");
	int nSide = bFlipX?- 1:1;	
	double dEdgeOffsetXFlush=dEdgeOffsetX+dFlushExtraGap;
	if (stud.bIsValid())
	{
		// In stud mode
		int bFlipAllowed = true; // flipping only allowed if no instnace placed on oposite side
		Entity entTools[] = stud.eToolsConnected();
		for (int e=0;e<entTools.length();e++)
			if (entTools[e].bIsKindOf(TslInst()))	
			{
				TslInst tsl =(TslInst)entTools[e];
				if (tsl.scriptName()==scriptName() && tsl!=_ThisInst)
				{
					Map m = tsl.map();
					int _bFlipX = m.getInt("FlipX");
					
					if (_bFlipX != bFlipX)
					{
						bFlipAllowed = false;
						break;
					}
				}
			}		

		if (bFlipAllowed)
		{ 
			String sTriggerFlipSide = T("|Flip Side|");
			addRecalcTrigger(_kContext, sTriggerFlipSide );
			if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
			{
				bFlipX=bFlipX?false:true;
				_Map.setInt("FlipX", bFlipX);	
				nSide=bFlipX?-1:1;
				if (_PtG.length()>0)
				{ 
					double dOffsetGrip=abs(vecXstud.dotProduct(_PtG[0]-stud.ptCen()));
					_PtG[0]+=vecXstud*vecXstud.dotProduct(stud.ptCen()-_PtG[0])+nSide*vecXstud*dOffsetGrip;
					//_Pt0 += vecX * (nSide * bm.dD(vecX)+);
									
				}
//				_Pt0 = stud.ptCenSolid() + vecX * nSide *( stud.dD(vecX) + dEdgeOffsetX);
				_Pt0+=vecXstud*vecXstud.dotProduct(stud.ptCenSolid()+vecXstud*nSide*(.5*stud.dD(vecXstud)+dEdgeOffsetXFlush)-_Pt0);
				_Pt0+=vecZstud*vecZstud.dotProduct(ptMid+vecZstud*dOffsetAxisZ-_Pt0);
				//_Map.setInt("TestLocation", true); // test side of stud alignment
				setExecutionLoops(2);
				return;
			}	
			
			String sTriggerDuplicate = T("|Copy + Mirror|");
			addRecalcTrigger(_kContext, sTriggerDuplicate );
			if (_bOnRecalc && _kExecuteKey==sTriggerDuplicate)
			{
			// create TSL
				TslInst tslNew;
				GenBeam gbsTsl[]={stud}; Entity entsTsl[]={el}; Point3d ptsTsl[]={_Pt0};
				int nProps[]={}; 
				double dProps[]={dDiameter,dDepth,dOffsetAxisZ,dEdgeOffsetX,dRotation,
					dWidth,dDepth2,dDiameterSink,dDepthSink};	
				String sProps[]={sVersion,sTxt,sZones,sMarking,sFastener,sToolingTypeHcwl};
				Map mapTsl;	
				
				int _bFlipX=bFlipX?false:true;
				mapTsl.setInt("FlipX",_bFlipX);
				tslNew.dbCreate(scriptName(),vecX,vecY,gbsTsl,entsTsl,
					ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
				
//				if (tslNew.bIsValid())
//					tslNew.setPropValuesFromMap(_ThisInst.mapWithPropValues());
				setExecutionLoops(2);
				return;
			}			
		}
	}
	if(!stud.bIsValid() || (nVersion!=2 && nVersion!=5))
	{ 
		// no stud or not a HCWL
		sMarking.setReadOnly(_kHidden);
		// HSB-23567
		dDepthMillingStud.setReadOnly(_kHidden);
		dWidthMillingStud.setReadOnly(_kHidden);// HSB-23993
		dHeightMillingStud.setReadOnly(_kHidden);// HSB-23993
		dOffsetMillingStud.setReadOnly(_kHidden);// HSB-24083
	}
	
// when dragging _Pt0
//	if(_kNameLastChangedProp=="_Pt0")
//	{
//		// remove plate or stud reference
//		_Beam.setLength(0);
//		setExecutionLoops(2);
//		return;
//	}

// TriggerGetBeam

//	String sTriggerGetBeam="Stütze wählen";
	String sTriggerGetBeam=T("|Select stud|");
	addRecalcTrigger(_kContext,sTriggerGetBeam);
	if (_bOnRecalc && _kExecuteKey==sTriggerGetBeam)
	{
		Beam bm=getBeam(sTriggerGetBeam);
		if (bm.vecX().isParallelTo(vecY) && bm.element()==el)
		{			
			_Beam.setLength(0);
			_Beam.append(bm);
			
			_Pt0+=vecX*vecX.dotProduct(bm.ptCenSolid()+vecX*nSide*(.5*bm.dD(vecX)+dEdgeOffsetXFlush)-_Pt0);
			_Pt0+=vecZ*vecZ.dotProduct(ptMid+vecZ*dOffsetAxisZ-_Pt0);
			if (_PtG.length()>0)
			{ 
				double dOffsetGrip=vecX.dotProduct(_PtG[0]-_Pt0);
				_PtG[0]=bm.ptCen()+nSide*vecX*(.5*bm.dD(vecX)+dOffsetGrip)+vecY*vecY.dotProduct(_PtG[0]-bm.ptCen());
			}
			_Map.setInt("TestLocation",true); // test side of stud alignment
		}
		setExecutionLoops(2);
		return;
	}
	
// set ref point sticky to potential stud
	if (stud.bIsValid())
	{ 	
		ptRef+=vecXstud*vecXstud.dotProduct(stud.ptCenSolid()-ptRef);
		ptRef+=vecXstud*nSide*(.5*stud.dD(vecXstud)+dEdgeOffsetXFlush);
	}
	//ptRef.vis(6);
//endregion


// get base plates
	Beam bmPlates[0], bmBlockings[0];
	Beam beamsAll[]=el.beam();
	bmPlates=vecY.filterBeamsPerpendicularSort(Beam().filterBeamsHalfLineIntersectSort(el.beam(),ptRef+vecY*U(10e3),-vecY) );
	if(bmPlates.length()==0 && stud.bIsValid())
	{
		bmPlates=vecY.filterBeamsPerpendicularSort(Beam().filterBeamsHalfLineIntersectSort(el.beam(),stud.ptCenSolid()+vecY*U(10e3),-vecY));
		if(bmPlates.length()==0)
		{ 
		// HSB-16670: no plate found
			eraseInstance();
			return;
//			Display dpError(1);
//			dpError.draw("No plates found", _Pt0, _XW, _YW, 0, 0, _kDeviceX);
		}
	}
	if(bmPlates.length()==0 && plate.bIsValid())
	{
		bmPlates=vecY.filterBeamsPerpendicularSort(Beam().filterBeamsHalfLineIntersectSort(el.beam(),plate.ptCenSolid()+vecY*U(10e3),-vecY));
	}
	// HSB-21790
	if(bBaufritz)
	{ 
		if(bmPlates.length()>1)
		{ 
			if(bmPlates[0].dD(vecY)<=U(27))
			{ 
				bmPlates.removeAt(0);
			}
		}
	}
	Point3d ptBase=ptRef;
	double dHeightPlate;
	ptRef.vis(1);
	if (bmPlates.length()>0)
	{
		dHeightPlate=bmPlates[0].dD(vecY);
		ptBase=Line(ptRef,vecY).intersect(Plane(bmPlates[0].ptCen()-.5*dHeightPlate*vecY,vecY),U(0));
	}
	
// remove plates which are not on same base, add blocking beams
	for (int i=bmPlates.length()-1; i>=0;i--) 
	{ 
		Point3d pt=bmPlates[i].ptCenSolid()-vecY*.5*bmPlates[0].dD(vecY);
		if (abs(vecY.dotProduct(ptBase-pt))>dEps)
		{
			bmBlockings.append(bmPlates[i]);
			//bmPlates[i].envelopeBody().vis(4);
			bmPlates.removeAt(i);
		}
		else
			bmPlates[i].envelopeBody().vis(i);
	}//next i
	
//	if(bBaufritz)
//	{ 
//	// Baufritz: Allow pt0 dragging for all types , HCW,HCWL,custom
//		if(_kNameLastChangedProp=="_Pt0")
//		{ 
//			reportMessage("\n"+scriptName()+" "+T("|enters|"));
//			
//			// set properties
//			double _dOffsetAxisZ =vecZ.dotProduct(_Pt0-ptMid);
//	//		ptRef += vecX*vecX.dotProduct(_Pt0-ptRef);
//	//		ptRef += vecZ*vecX.dotProduct(_Pt0-ptRef);
//			dOffsetAxisZ.set(_dOffsetAxisZ);
//			reportMessage("\n"+scriptName()+" "+T("|dOffsetAxisZ|")+dOffsetAxisZ);
//			
//			if(stud.bIsValid())
//			{ 
//				double _dEdgeOffsetX = (vecX * nSide).dotProduct(_Pt0 - stud.ptCenSolid());
//				_dEdgeOffsetX -= .5*stud.dD(vecX);
//				dEdgeOffsetX.set(_dEdgeOffsetX);
//			}
//		}
//		ptBase = _Pt0;
//	}

// HSB-19774: allow for all to add remove plate
//	if(bBaufritz)
	{ 
		Entity entPlates[]=_Map.getEntityArray("plates","plates","plates");
	//region Trigger addPlateForDrilling
		String sTriggeraddPlateForDrilling=T("|Add plate for drilling|");
		addRecalcTrigger(_kContextRoot, sTriggeraddPlateForDrilling);
		if (_bOnRecalc && _kExecuteKey==sTriggeraddPlateForDrilling)
		{
		// prompt for beams
			Beam beamsSelected[0];
			PrEntity ssE(T("|Select beams|"), Beam());
			if (ssE.go())
				beamsSelected.append(ssE.beamSet());
			
			for (int ib=0;ib<beamsSelected.length();ib++) 
			{ 
				if(entPlates.find(beamsSelected[ib])<0)
				{ 
					entPlates.append(beamsSelected[ib]);
				}
			}//next ib
			_Map.setEntityArray(entPlates,false,"plates","plates","plates");
			setExecutionLoops(2);
			return;
		}//endregion
	//region Trigger removePlateForDrilling
		String sTriggerremovePlateForDrilling=T("|Remove plate for drilling|");
		addRecalcTrigger(_kContextRoot, sTriggerremovePlateForDrilling);
		if (_bOnRecalc && _kExecuteKey==sTriggerremovePlateForDrilling)
		{
		// prompt for beams
			Beam beamsSelected[0];
			PrEntity ssE(T("|Select beams|"), Beam());
			if (ssE.go())
				beamsSelected.append(ssE.beamSet());
				
			for (int ie=entPlates.length()-1; ie>=0 ; ie--)
			{ 
				Beam bmI=(Beam)entPlates[ie];
				if(beamsSelected.find(bmI)>-1)
				{ 
					entPlates.removeAt(ie);
				}
			}//next ie
			_Map.setEntityArray(entPlates,true,"plates","plates","plates");
			setExecutionLoops(2);
			return;
		}//endregion
		for (int ie=0;ie<entPlates.length();ie++) 
		{ 
			Beam bmI=(Beam)entPlates[ie];
			if(bmPlates.find(bmI)<0)
			{ 
				bmPlates.append(bmI);
			}
		}//next ie
	}

	
	if(nVersion==0 || nVersion==2 || nVersion==5 || _bOnDbCreated)
	{
		_Pt0=ptBase;
	}
	else if(nVersion==1 || nVersion==3 || (bBaufritz && nVersion==4))
	{
		_Pt0+=vecY*vecY.dotProduct(ptBase-_Pt0);
	}
	
//region check rulesets wrt beam plates
	int iErrorRuleset;
	Display dpError(1);
	dpError.textHeight(U(20));
	String sTextError=T("|Error|");
//	for (int ib=0;ib<bmPlates.length();ib++) 
	Vector3d vecXbm, vecYbm, vecZbm;
//	PlaneProfile ppBoundary;
//End check rulesets wrt beam plates//endregion 

// HSB-18322: 
if(_kNameLastChangedProp==sVersionName)
{ 
// Version was changed
	if((nVersion==2 || nVersion==5) && bBaufritz)
	{ 
	// from custom or HCW to HCWL, set the X distance to 8mm
		dEdgeOffsetX.set(U(8));
		setExecutionLoops(2);
		return;
	}
}


if(plate.bIsValid())
{ 
	//Beam bmPlateI=bmPlates[ib]; 
	Beam bmPlateI=plate; 
	vecXbm=bmPlateI.vecX();
	vecYbm=bmPlateI.vecD(vecY);
	vecZbm=vecXbm.crossProduct(vecYbm);

	// hcw is selected
	// thickness
	if(bmPlateI.dD(vecYbm)<U(45))
	{ 
		iErrorRuleset=true;
		sTextError+="\P"+T("|Beam thickness|")+" "+bmPlateI.dD(vecYbm)+" "+
		T("|smaller then minimal thickness|") + " "  + " 45 mm";
	}
	if(bmPlateI.dD(vecZbm)<U(100))
	{ 
		iErrorRuleset=true;
		sTextError+="\P"+T("|Beam width|")+" "+bmPlateI.dD(vecZbm)+" "+
		T("|smaller then minimal width|") + " "  + " 100 mm";
	}
		
	if (nVersion == 1 || nVersion == 3 || (bBaufritz && nVersion == 4))
	{
		if (bmPlateI.dL() < U(400))
		{
			iErrorRuleset = true;
			sTextError += "\P" + T("|Beam length|") + " " + bmPlateI.dL() + " " +
			T("|smaller then minimal length|") + " " + " 400 mm";
		}
	}		
		
	if ( ! bBaufritz)
	{
		if (iErrorRuleset)
		{
			dpError.draw(sTextError, _Pt0, _XW, _YW, 0, 0, _kDeviceX);
		}
	}

		
	PLine plBoundary;
	// HSB-17526:
	if(!bBaufritz)
	{ 
		plBoundary.createRectangle(LineSeg(bmPlateI.ptCen()-(.5*bmPlateI.dL()-U(200))*vecXbm-(.5*bmPlateI.dD(vecZbm)-U(40))*vecZbm,
		bmPlateI.ptCen()+(.5*bmPlateI.dL()-U(200))*vecXbm+(.5*bmPlateI.dD(vecZbm)-U(40))*vecZbm),vecXbm,vecZbm);
	}
	else
	{ 
		plBoundary.createRectangle(LineSeg(bmPlateI.ptCen()-(.5*bmPlateI.dL())*vecXbm-(.5*bmPlateI.dD(vecZbm))*vecZbm,
		bmPlateI.ptCen()+(.5*bmPlateI.dL())*vecXbm+(.5*bmPlateI.dD(vecZbm))*vecZbm),vecXbm,vecZbm);
	}
	
//	ppBoundary=PlaneProfile(Plane(_Pt0,vecYbm));
//	ppBoundary.joinRing(plBoundary,_kAdd);	
//	ppBoundary.vis(1);
	
//	if(ppBoundary.pointInProfile(_Pt0)==_kPointOutsideProfile)
//	{ 
//		_Pt0=ppBoundary.closestPointTo(_Pt0);
//	}
	
	if(_kNameLastChangedProp==sOffsetAxisZName)
	{ 
		Point3d Pt0_=ptBase;
		Point3d pt0Test = Pt0_;
//		if(ppBoundary.pointInProfile(pt0Test)==_kPointOutsideProfile)
//		{ 
//			_Pt0=ppBoundary.closestPointTo(pt0Test);
////			ptRef += vecX*vecX.dotProduct(_Pt0-ptRef);
////			ptRef += vecZ*vecX.dotProduct(_Pt0-ptRef);
//			double _dOffsetAxisZ=vecZ.dotProduct(_Pt0-ptMid);
//			if(stud.bIsValid())
//			{ 
//				_dOffsetAxisZ=vecZstud.dotProduct(_Pt0-ptMid);
//			}
//			dOffsetAxisZ.set(_dOffsetAxisZ);
//		}
//		else
		{
			_Pt0=pt0Test;
		}
	}
	else if(_kNameLastChangedProp=="_Pt0")
	{ 
	// get the view direction
		Vector3d vecView=getViewDirection();
		if(vecView.isParallelTo(vecZ))
		{ 
		// element view
			_Pt0=Plane(_Map.getPoint3d("pt0"),vecZ).closestPointTo(_Pt0);
		}
		// set properties
		double _dOffsetAxisZ=vecZ.dotProduct(_Pt0-ptMid);
		if(stud.bIsValid())
		{ 
			_dOffsetAxisZ=vecZstud.dotProduct(_Pt0-ptMid);
		}
//		ptRef += vecX*vecX.dotProduct(_Pt0-ptRef);
//		ptRef += vecZ*vecX.dotProduct(_Pt0-ptRef);
		dOffsetAxisZ.set(_dOffsetAxisZ);
	}
	ptBase=_Pt0;
// store pt0
	_Map.setPoint3d("pt0",_Pt0,_kAbsolute);

}//next ib
else if(!plate.bIsValid())
{ 

	for (int ib=0;ib<bmPlates.length();ib++) 
	{ 
		Beam bmPlateI=bmPlates[ib]; 
		vecXbm=bmPlateI.vecX();
		vecYbm=bmPlateI.vecD(vecY);
		vecZbm=vecXbm.crossProduct(vecYbm);
		if(bmPlateI.dD(vecYbm)<U(45))
		{ 
			iErrorRuleset=true;
			sTextError+="\P"+T("|Beam thickness|")+" "+bmPlateI.dD(vecYbm)+" "+
			T("|smaller then minimal thickness|") + " "  + " 45 mm";
		}
		if(bmPlateI.dD(vecZbm)<U(80))
		{ 
			iErrorRuleset=true;
			
			sTextError+="\P"+T("|Beam width|")+" "+bmPlateI.dD(vecZbm)+" "+
			T("|smaller then minimal width|") + " "  + " 100 mm";
		}
		
		if (nVersion == 1 || nVersion == 3 || (bBaufritz && nVersion == 4))
		{
			if (bmPlateI.dL() < U(400))
			{
				iErrorRuleset = true;
				sTextError += "\P" + T("|Beam length|") + " " + bmPlateI.dL() + " " +
				T("|smaller then minimal length|") + " " + " 400 mm";
			}
		}
		
		// hcw
		PLine plBoundary;
		// HSB-17526:
		if(!bBaufritz)
		{ 
			plBoundary.createRectangle(LineSeg(bmPlateI.ptCen()-(.5*bmPlateI.dL()-U(200))*vecXbm-(.5*bmPlateI.dD(vecZbm)-U(40))*vecZbm,
			bmPlateI.ptCen() + (.5*bmPlateI.dL()-U(200)) * vecXbm + (.5*bmPlateI.dD(vecZbm)-U(40))*vecZbm), vecXbm, vecZbm);
		}
		else
		{ 
			plBoundary.createRectangle(LineSeg(bmPlateI.ptCen()-(.5*bmPlateI.dL())*vecXbm-(.5*bmPlateI.dD(vecZbm))*vecZbm,
			bmPlateI.ptCen() + (.5*bmPlateI.dL()) * vecXbm + (.5*bmPlateI.dD(vecZbm))*vecZbm), vecXbm, vecZbm);
		}
//		PlaneProfile ppBoundaryI(Plane(_Pt0, vecYbm));
//		ppBoundaryI.joinRing(plBoundary, _kAdd);
//		if(ppBoundary.area()<pow(dEps,1))
//			ppBoundary.unionWith(ppBoundaryI);

	}//next ib
	if(!bBaufritz)
	{ 
		if(iErrorRuleset)
		{ 
			dpError.draw(sTextError,_Pt0,_XW,_YW,0,0,_kDeviceX);
		}
	}
	else
		iErrorRuleset=true;
	
//	if(ppBoundary.pointInProfile(_Pt0)==_kPointOutsideProfile)
//	{ 
//		_Pt0 = ppBoundary.closestPointTo(_Pt0);
////			ptBase = _Pt0;
//	}
	if((_kNameLastChangedProp==sOffsetAxisZName || 1) && _kNameLastChangedProp!="_Pt0")
	{ 
	// HSB-17955:
		Point3d Pt0_=ptBase;
		Point3d pt0Test=Pt0_;
//		if(ppBoundary.pointInProfile(pt0Test)==_kPointOutsideProfile)
//		{ 
//			_Pt0=ppBoundary.closestPointTo(pt0Test);
////			ptRef += vecX*vecX.dotProduct(_Pt0-ptRef);
////			ptRef += vecZ*vecX.dotProduct(_Pt0-ptRef);
//			double _dOffsetAxisZ=vecZ.dotProduct(_Pt0-ptMid);
//			if(stud.bIsValid())
//			{ 
//				_dOffsetAxisZ=vecZstud.dotProduct(_Pt0-ptMid);
//			}
//			dOffsetAxisZ.set(_dOffsetAxisZ);
//		}
//		else
		{
			_Pt0=pt0Test;
		}
	}
	if((_kNameLastChangedProp==sEdgeOffsetXName || 1) && _kNameLastChangedProp!="_Pt0")
	{ 
	// HSB-17955:
		Point3d Pt0_=ptBase;
		Point3d pt0Test=Pt0_;
		if(stud.bIsValid())
		{ 
//			if(ppBoundary.pointInProfile(pt0Test)==_kPointOutsideProfile)
//			{ 
//				_Pt0=ppBoundary.closestPointTo(pt0Test);
//	//			ptRef += vecX*vecX.dotProduct(_Pt0-ptRef);
//	//			ptRef += vecZ*vecX.dotProduct(_Pt0-ptRef);
//				double _dEdgeOffsetX = (vecXstud*nSide).dotProduct(_Pt0-stud.ptCenSolid());
//				_dEdgeOffsetX -= .5*stud.dD(vecXstud);
//				dEdgeOffsetX.set(_dEdgeOffsetX-dFlushExtraGap);
//			}
//			else
			{
				_Pt0 = pt0Test;
			}
		}
	}
	if(_kNameLastChangedProp=="_Pt0")
	{ 
		Vector3d vecView=getViewDirection();
		if(vecView.isParallelTo(vecZ))
		{ 
		// element view
			_Pt0=Plane(_Map.getPoint3d("pt0"),vecZ).closestPointTo(_Pt0);
		}
		// set properties
		double _dOffsetAxisZ=vecZ.dotProduct(_Pt0-ptMid);
		if(stud.bIsValid())
		{ 
			_dOffsetAxisZ=vecZstud.dotProduct(_Pt0-ptMid);
		}
//		ptRef += vecX*vecX.dotProduct(_Pt0-ptRef);
//		ptRef += vecZ*vecX.dotProduct(_Pt0-ptRef);
		dOffsetAxisZ.set(_dOffsetAxisZ);
		if(stud.bIsValid())
		{ 
			double _dEdgeOffsetX=(vecXstud*nSide).dotProduct(_Pt0-stud.ptCenSolid());
			_dEdgeOffsetX-=.5*stud.dD(vecXstud);
			dEdgeOffsetX.set(_dEdgeOffsetX-dFlushExtraGap);
		}
	}
	
	if(nMarking==2 || dDepthMillingStud>0)
	{ 
		double dDepthM=U(2);
		if(dDepthMillingStud>2 && nMarking==2)
		{ 
			dDepthM=dDepthMillingStud;
		}
		else if(nMarking!=2)
		{ 
			dDepthM=dDepthMillingStud;
		}
//		_Pt0=_Pt0-vecXstud*U(2)*nSide;
		_Pt0=_Pt0-vecXstud*dDepthM*nSide;
	}
	
	ptBase = _Pt0;
// store pt0

	_Map.setPoint3d("pt0",_Pt0,_kAbsolute);
}

	
// version value="3.7" date=30jul19" author="thorsten.huck@hsbcad.com"> detection of tooling beams enhanced 
	{ 
		double dDepthTest=dDepth;
		if (dDepthTest<dDepth2) dDepthTest=dDepth2;
		if (dDepthTest<dDepthSink) dDepthTest=dDepthSink;
		Body bdBlockingTest(ptBase,ptBase+vecY*dDepthTest,.5*(dDiameterSink+dEps));
		bdBlockingTest.vis(3);
		bmBlockings = bdBlockingTest.filterGenBeamsIntersect(bmBlockings);
	}	

//	vecX.vis(ptBase,1);
//	vecY.vis(ptBase,3);
//	vecZ.vis(ptBase,150);


// get test profile on dbCreate
//region test location
	if (bTestLocation)// && abs(dEdgeOffsetX)>dEps)
	{ 
		_ThisInst.transformBy(Vector3d(0, 0, 0));
	// get range based on segminmax	
		//LineSeg segmentMinMax = el.segmentMinMax();
		PLine plMinMax;
		plMinMax.createRectangle(el.segmentMinMax(), vecX, - vecZ);
		
//		EntPLine epl;
//		epl.dbCreate(plMinMax);
//		epl.setColor(5);
		
	// collect/override range based on lowest beams
		Beam bmHors[] = vecY.filterBeamsPerpendicularSort(el.beam());
		if (bmHors.length()>0)
		{ 
			Plane pnW(ptOrg, vecY);
			Point3d ptRef=bmHors[0].ptCenSolid()-vecY*.5*bmHors[0].dD(vecY);
			
			Point3d pts[0];
			for (int i=0;i<bmHors.length();i++) 
			{ 
				Beam& b = bmHors[i];
				Point3d _ptRef=bmHors[i].ptCenSolid()-vecY*.5*bmHors[i].dD(vecY);
//				if (abs(vecY.dotProduct(ptRef - _ptRef)) > dEps)continue;
				PlaneProfile pp=b.envelopeBody(false,true).shadowProfile(pnW);
				pts.append(pp.getGripVertexPoints());
			}//next i
			
			PLine pl;
			pl.createConvexHull(pnW,pts);
			pl.vis(4);
			if (pl.area()>pow(dEps,2))
				plMinMax=pl;
		}
		PlaneProfile ppMinMax(CoordSys(ptOrg, vecX, - vecZ, vecY));
		ppMinMax.joinRing(plMinMax, _kAdd);
		
	// subtract any opening
		Opening openings[] = el.opening();
		for (int i=0;i<openings.length();i++) 
		{ 
			Opening& o = openings[i];
			Point3d ptMid; ptMid.setToAverage(o.plShape().vertexPoints(true));
			PLine pl;
			pl.createRectangle(LineSeg(ptMid-vecX*.5*o.width()-vecZ*U(10e3),ptMid+vecX*.5*o.width()+vecZ*U(10e3)),vecX,-vecZ);
			ppMinMax.joinRing(pl, _kSubtract);
		}//next i
		
//		PLine pls[] = ppMinMax.allRings();
//		PLine pl3 = pls[0];
//		ppMinMax.vis(2);
//		EntPLine epl2;
//		epl2.dbCreate(pl3);
//		epl2.setColor(6);
		_Map.removeAt("TestLocation", true); // remove trigger which might be set
		if (ppMinMax.pointInProfile(_Pt0)==_kPointOutsideProfile)
		{ 
			if (stud.bIsValid())
			{ 
				bFlipX=bFlipX?false:true;
				_Map.setInt("FlipX", bFlipX);
			}
			else
			{
				PLine pl(segmentMinMax.ptStart(), segmentMinMax.ptEnd());
				pl.projectPointsToPlane(Plane(ptBase, vecY), vecY);
				_Pt0 = pl.closestPointTo(_Pt0);
			}
			setExecutionLoops(2);
			return;
		}
	}
//End test location//endregion 

// declare tools
	Beam bmStuds[]=vecX.filterBeamsPerpendicularSort(beams);
	PlaneProfile ppMs;
	Vector3d vecYT,vecZT,vecXT;
	Vector3d vecXTconnector,vecYTconnector,vecZTconnector;
// body for collision test
	
	Body body;
	if (dDiameter==U(42))
	{ 
		// HCWL type
		nc=1;
		vecYT=nSide*vecZ;
		vecZT=-vecY;
		vecXT=vecYT.crossProduct(vecZT);
		
		if(stud.bIsValid() && !bBaufritz)
		{ 
			// 20241011
			vecYT=nSide*vecZstud;
			vecZT=-vecYstud;
			vecXT=vecYT.crossProduct(vecZT);
		}
		
		vecXTconnector=vecXT;
		vecYTconnector=vecYT;
		vecZTconnector=vecZT;
		
		if(_dRotation!=U(0))
		{ 
			// rotate vecXT, vecYT wrt vecZT
			vecXT=vecXT.rotateBy(_dRotation, vecZT);
			vecYT=vecYT.rotateBy(_dRotation, vecZT);
		}
		if(_dRotationConnector!=U(0))
		{ 
			vecXTconnector=vecXTconnector.rotateBy(_dRotationConnector, vecZT);
			vecYTconnector=vecYTconnector.rotateBy(_dRotationConnector, vecZT);
		}
		
//		Point3d pt=ptBase-vecY*dEps-vecXT*.5*dDiameter;
		Point3d pt=ptBase-vecY*dEps;
		if(bBaufritz)
		{ 
			// 20241011
			pt=ptBase-vecY*dEps-vecXT*.5*dDiameter;
		}
		vecXT.vis(ptBase, 2);
		vecYT.vis(ptBase, 2);
		vecZT.vis(ptBase, 20);
		
		double dWidth=dDiameter;
//		double dLength = U(54);
//		pt+=dDepth*vecY;
		// HSB-20649: Fix entering point
		if(bmPlates.length()>0)
		{ 
			pt+=vecY*(bmPlates[0].dD(vecY)+dEps);
		}
		 
		// house
		double dLength = U(60);
//		House ms(pt, vecXT,vecYT, vecZT, dLength, dWidth, dDepth*2 , 1,0,0);
	// HSB-21590: tool enter from below to control te depth
		Point3d ptHouse=pt;ptHouse+=vecY*vecY.dotProduct(ptBase-pt);
		if(nToolingTypeHcwl==0)
		{
			// house
	//		House ms(ptHouse, vecXT,-vecYT, -vecZT, dLength, dWidth, dDepth*2 , 1,0,0);
			if(dDepth>0)
			{ 
				House ms(ptHouse,vecXT,-vecYT,-vecZT,dLength,dWidth,dDepth*2,0,0,0);
				if(bBaufritz)
				{ 
					// 20241011
					ms=House(ptHouse,vecXT,-vecYT,-vecZT,dLength,dWidth,dDepth*2,1,0,0);
				}
				ms.setEndType(_kFemaleSide);
				ms.setRoundType(_kRound);
		//		ms.cuttingBody().vis(5);
				ms.addMeToGenBeamsIntersect(bmPlates);
				ppMs = ms.cuttingBody().shadowProfile(Plane(_Pt0, vecY));
			}
		}
		else if(nToolingTypeHcwl==1)
		{ 
			// HSB-20098: drill
			Drill dr(ptHouse+vecZT*U(10),ptHouse-vecZT*dDepth,.5*U(42));
			dr.cuttingBody().vis(6);
			dr.addMeToGenBeamsIntersect(bmPlates);
			ppMs = dr.cuttingBody().shadowProfile(Plane(_Pt0, vecY));
		}
		// first 45mm thickness is enough this tooling
		// for beams higher/thicker then 45 the L upper part cannot enter
		// So from 45mm and higher it requires a larger opening e.g. drill 75
		
		Point3d ptDrillUpper=_Pt0;
		ptDrillUpper+=vecY*vecY.dotProduct(ptBase+vecY*U(50)-ptDrillUpper);
		Drill drUpper(ptDrillUpper,ptDrillUpper+vecY*U(200),.5*U(75));
		drUpper.addMeToGenBeams(bmPlates);
		if(stud.bIsValid() && (nMarking>0 || dDepthMillingStud>0))
		{ 
			// HSB-19773: do the marking at stud
			if(nMarking==1)
			{ 
				// Mark at stud
//				Point3d ptMark=ptBase+(U(268)+U(40))*vecY;
//				Point3d ptMark=ptBase+(U(295))*vecY;
				Point3d ptMark=ptBase+(U(293))*vecY;
				Mark mark(ptMark,-vecYT);
				stud.addTool(mark);
				
				// add left right markings
				Point3d pt1m=ptMark-vecZstud*.5*U(68);
				Point3d pt2m=pt1m-U(10)*vecY;
				
				MarkerLine ml(pt1m,pt2m,-vecYTconnector);
				stud.addTool(ml);
				pt1m=ptMark+vecZstud*.5*U(68);
				pt2m=pt1m-U(10)*vecY;
				MarkerLine mr(pt1m,pt2m,-vecYTconnector);
				stud.addTool(mr);
			}
			if(nMarking==2 || dDepthMillingStud>0)
			{ 
				// Mill 2mm at stud
//				Point3d ptHouseMarking = ptBase+U(40)*vecY;
//				Point3d ptHouseMarking = ptBase+U(174)*vecY; 
				Point3d ptHouseMarking = ptBase+U(146)*vecY; 
				Point3d ptStudSide=stud.ptCen()-.5*stud.dD(vecYTconnector)*vecYTconnector;
				ptHouseMarking+=vecYTconnector*vecYTconnector.dotProduct(ptStudSide-ptHouseMarking);
				
				ptHouseMarking+=vecY*vecY.dotProduct(stud.ptCen()-.5*stud.dL()*vecY-ptHouseMarking);
				ptHouseMarking+=vecY*dOffsetMillingStud;
				
				double dDepthM=U(2);
				if(dDepthMillingStud>2 && nMarking==2)
				{ 
					// mill
					dDepthM=dDepthMillingStud;
				}
				else if(nMarking!=2)
				{ 
					// none or mark
					dDepthM=dDepthMillingStud;
				}
				// HSB-23993
				double dWidthM=dWidthMillingStud>0?dWidthMillingStud:U(68);
				double dHeightM=dHeightMillingStud>0?dHeightMillingStud:U(292);
				if(dDepthM>dEps && dWidthM>dEps && dHeightM>dEps)
				{ 
	//				House msMarking(ptHouseMarking,vecZTconnector,vecXTconnector,vecYTconnector,1*U(268-30),U(68),U(2)*2,0,0,0);
	//				House msMarking(ptHouseMarking,vecZTconnector,vecXTconnector,vecYTconnector,1*U(292),U(68),U(2)*2,0,0,0);
//					House msMarking(ptHouseMarking,vecZTconnector,vecXTconnector,vecYTconnector,1*dHeightM,dWidthM,dDepthM*2,0,0,0);
					House msMarking(ptHouseMarking,vecZTconnector,vecXTconnector,vecYTconnector,1*dHeightM,dWidthM,dDepthM*2,-1,0,0);
					msMarking.setEndType(_kFemaleSide);
	//				msMarking.setExplicitRadius(U(21));
	//				msMarking.setRoundType(_kExplicitRadius);
					msMarking.setRoundType(_kRelief);
					msMarking.cuttingBody().vis(2);
	//				ms.addMeToGenBeamsIntersect(bmStuds);
					stud.addTool(msMarking);
				}
			}
		}
	}
	else
	{ 
		// HCW type
	// drill
		{ 
			Drill dr(ptBase-vecY*dEps, ptBase+vecY*dDepth, dDiameter/2);
			dr.cuttingBody().vis(6);
			body.addPart(dr.cuttingBody());
			Drill drMarking;
			
			for (int i=0;i<bmPlates.length();i++)
			{
				bmPlates[i].addTool(dr);
//				bmPlates[i].realBody().vis(i);
			}
			if(!bBaufritz)
			{
				dr.addMeToGenBeamsIntersect(bmStuds);
			}
			else if(bBaufritz)
			{ 
			// HSB-17955: add drill only if drill center iside the stud section
				PlaneProfile ppDrill=dr.cuttingBody().shadowProfile(Plane(ptOrg,vecY));
				for (int ib=0;ib<bmStuds.length();ib++) 
				{ 
					PlaneProfile ppStud=bmStuds[ib].envelopeBody(true,true).
						shadowProfile(Plane(ptOrg,vecY));
					// HSB-23612: changes from Markus
//					if(ppStud.pointInProfile(ptBase)==_kPointInProfile)
					if(ppStud.pointInProfile(ptBase)==_kPointInProfile && nVersion!=4)
					{ 
						bmStuds[ib].addTool(dr);
					}
				}//next ib
//				if((nVersion==3 || nVersion==1) && bBaufritz)
				// HSB-23098
//				if((nVersion==3) && bBaufritz)
//				{ 
//					// hcw or hcw-p
//					// marking drill
////					Point3d ptMarking=ptBase-vecZ*dDiameter;
//					// BF20240418: Additional hole for HWC pushed to the other side
//					double dOffsetMark=.5*bmPlates[0].solidHeight()-dOffsetAxisZ;
//					double dOffsetMark1=dOffsetMark-4;
//					//
////					Point3d ptMarking=ptBase+vecZ*dOffsetMark+vecY*0.5*bmPlates[0].solidWidth();
////					Point3d ptMarking1=ptBase+vecZ*dOffsetMark1+vecY*0.5*bmPlates[0].solidWidth();
//					
//					Point3d ptMarking=ptBase+vecZ*dOffsetMark+vecY*0.35*bmPlates[0].solidWidth();
//					Point3d ptMarking1=ptBase+vecZ*dOffsetMark1+vecY*0.35*bmPlates[0].solidWidth();
//					
//					Point3d ptMidPlate=ptMid;
////					if(plate.bIsValid())
////					{ 
////						PlaneProfile ppPlate = plate.envelopeBody().shadowProfile(Plane(_Pt0, vecY));
////						ptMidPlate=ppPlate.ptMid();
////					}
////					if(abs(vecZ.dotProduct(ptBase+vecZ*dDiameter-ptMidPlate))<
////						abs(vecZ.dotProduct(ptBase-vecZ*dDiameter-ptMidPlate)))
////						ptMarking=ptBase+vecZ*dDiameter;
//					
//					drMarking=Drill (ptMarking,ptMarking1,  U(30)/2);
//					for (int i=0;i<bmPlates.length();i++)
//					{
//						bmPlates[i].addTool(drMarking);
//		//				bmPlates[i].realBody().vis(i);
//					}
//				}
			
//				PlaneProfile ppStuds(Plane(ptOrg,vecY));
//				for (int ib=0;ib<bmStuds.length();ib++) 
//				{ 
//					ppStuds.unionWith(bmStuds[ib].envelopeBody(true,true).
//						shadowProfile(Plane(ptOrg,vecY)));
//				}//next ib
//				PlaneProfile ppDrill=dr.cuttingBody().shadowProfile(Plane(ptOrg,vecY));
//				PlaneProfile ppIntersect=ppDrill;
//				ppIntersect.intersectWith(ppStuds);
//				if(ppIntersect.area()>.5*ppDrill.area())
//				{ 
//					dr.addMeToGenBeamsIntersect(bmStuds);
//				}
			}
			if(nVersion==1 || nVersion==3 || (bBaufritz && nVersion==4))
			{ 
				// HCW is selected
				Body bdDrill = dr.cuttingBody();
				Beam bmDrillStuds[] = bdDrill.filterGenBeamsIntersect(bmStuds);
				for (int ist=0;ist<bmDrillStuds.length();ist++) 
				{ 
					Beam bmStudI = bmDrillStuds[ist]; 
					if(bmStudI.dD(vecX)<U(80) || bmStudI.dD(vecY)<U(80))
					{ 
//						iErrorRuleset = true;
//						sTextError += "\P" + T("|Stud section|")+" "+bmStudI.dD(vecX)+"x"+bmStudI.dD(vecY)+" "+
//			T("|smaller then minimal section|") + " "  + "80x80 mm";
					}
				}//next ist
				if(!bBaufritz)
				{ 
					if(iErrorRuleset)
					{ 
						dpError.draw(sTextError, _Pt0, _XW, _YW, 0, 0, _kDeviceX);
					}
				}
				else 
					iErrorRuleset=true;
			}
		}
		
	// sinkhole
		if (dDiameterSink>dDiameter && dDepthSink>dEps)
		{
			Drill drSink(ptBase-vecY*dEps, ptBase+vecY*dDepthSink, dDiameterSink/2);
			drSink.addMeToGenBeamsIntersect(bmPlates);
			drSink.addMeToGenBeamsIntersect(bmStuds);
			body.addPart(drSink.cuttingBody());
		}		
	// stud drill
		else if (dDiameterSink<=dDiameter && dDepthSink>dEps)
		{
		// drill	
			Drill dr(ptBase-vecY*dEps, ptBase+vecY*dDepthSink, dDiameterSink/2);
			
		// add drill only if the core interferes with the stud
			double dDepthTest = dDepthSink > dDepth ? dDepthSink : dDepth;
			Body bdTest(ptBase-vecY*dEps, ptBase+vecY*dDepthTest, U(6));
			bdTest.vis(2);
			Beam bmDrillStuds[] = bdTest.filterGenBeamsIntersect(bmStuds);
			dr.addMeToGenBeamsIntersect(bmDrillStuds);
			body.addPart(dr.cuttingBody());
			
		// add drills to blockings	
			for (int i=0;i<bmBlockings.length();i++)
			{	
				bmBlockings[i].addTool(dr);
				//bmBlockings[i].realBody().vis(5);
			}
		}	
	}
	_Map.setBody("body", body);
// add beamcut
	if (dDepth2 > dEps && dWidth > dEps)
	{ 
		Point3d pt = ptBase + vecZ * vecZ.dotProduct(ptMid - _Pt0);
		BeamCut bc(pt, vecX, vecY, vecZ, dWidth, dDepth2*2, U(1000), 0, 0, 0);
		bc.addMeToGenBeamsIntersect(bmPlates);
	}

//region beamcut other studs
	if (stud.bIsValid())
	{ 
		double dX = U(25);
		double dY = U(270) + dHeightPlate;
		double dZ = U(72);
		
		Beam bmBcStuds[0]; bmBcStuds = bmStuds;
//	// filter beam 
//		
//		{
//			int x = bmBcStuds.find(stud);
//			if (x >- 1)bmBcStuds.removeAt(x);
//		}
		ptBase.vis(2);
//		Point3d pt = ptBase-vecX*nSide*dEdgeOffsetX;
		// HSB-17955
		// 20240922
		Point3d pt = ptBase+vecXstud*(-nSide)*dFlushExtraGap;
		if(bBaufritz)pt = ptBase+vecXstud*dFlushExtraGap;
//		BeamCut bc(pt, vecX, vecY, vecZ, dX, dY, dZ, nSide, 1, 0);
		BeamCut bc(pt, vecXstud, vecYstud, vecZstud, dX, dY, dZ, nSide, 1, 0);
		bc.cuttingBody().vis(1);
		if(!bBaufritz)
		{
		//	bc.addMeToGenBeamsIntersect(bmBcStuds);	
		}
		// HSB-23612: changes from Markus
		if(bBaufritz && (nVersion ==2 || nVersion ==5) && (_dRotation==0||_dRotation==180))// HSB-24279
		{
			Point3d ptNew = ptBase+vecXstud*(-nSide)*dFlushExtraGap-vecXT*dEdgeOffsetX;
			BeamCut bcNew(ptNew, vecXstud, vecYstud, vecZstud, dX, dY, dZ, nSide, 1, 0);
			bcNew.addMeToGenBeamsIntersect(bmBcStuds);	
		}
	}
//End TestBody for other intersecting studs//endregion 

//region draw the body representation
	String sBlockName="";
	if(nVersion==1)sBlockName="HCW";
	else if(nVersion==2)sBlockName="HCWL";
	String sBlockPath = _kPathHsbCompany + "\\Block";
	int bBlockFound=true;
	if(sBlockName=="")bBlockFound=false;
	if(nVersion==1 || nVersion==2 || nVersion==5)
	{ 
		// blocks exist for HCW and HCWL
		if (_BlockNames.findNoCase(sBlockName ,- 1) < 0)
		{
			bBlockFound=false;
			String files[]=getFilesInFolder(sBlockPath);
			String fileName=sBlockName;
			if (files.findNoCase(fileName+".dwg",-1)>-1)
			{
				sBlockName=sBlockPath+"\\" + fileName + ".dwg";
				bBlockFound=true;
			}
		}
		if(bBlockFound)
		{ 
		// block found draw it
			Map minBlock;
			{ 
				Point3d pts[]={ptBase};
				minBlock.setPoint3dArray("pts",pts);
				
				Vector3d vzBlock=vecY;
				Vector3d vyBlock=nSide*vecZ;
				Vector3d vxBlock=(nSide*vecZ).crossProduct(vecY);
				vxBlock.normalize();
				if(dDiameter==42)
				{ 
					// HCWL
					vzBlock=-vecZTconnector;
					vyBlock=vecYTconnector;
					vxBlock=-vecXTconnector;
				}
				//
				minBlock.setVector3d("vz",vzBlock);
				minBlock.setVector3d("vy",vyBlock);
				minBlock.setVector3d("vx",vxBlock);
				
				//
				minBlock.setString("BlockName",sBlockName);
			// offsets are included in the ptBase
			// no need to include them explicit
				
	//			minBlock.setDouble("OffsetZ",dOffsetZ);
	//			minBlock.setDouble("OffsetY",dOffsetY);
	//			minBlock.setDouble("OffsetX",dOffsetX);
				minBlock.setInt("Version",nVersion);
			}
			Map mDrawBlock=drawBlock(minBlock);
		}
	}
	if(nFastener==5 || nFastener==6)
	{ 
		// HSB-24083: Block for HSW
		sBlockName="HSW M12";
		sBlockPath = _kPathHsbCompany + "\\Block";
		bBlockFound=true;
		
		if (_BlockNames.findNoCase(sBlockName ,- 1) < 0)
		{
			bBlockFound=false;
			String files[]=getFilesInFolder(sBlockPath);
			String fileName=sBlockName;
			if (files.findNoCase(fileName+".dwg",-1)>-1)
			{
				sBlockName=sBlockPath+"\\" + fileName + ".dwg";
				bBlockFound=true;
			}
		}
		if(bBlockFound)
		{ 
		// block found draw it
			Map minBlock;
			{ 
				Point3d pts[]={ptBase};
				minBlock.setPoint3dArray("pts",pts);
				
				Vector3d vzBlock=vecY;
				Vector3d vyBlock=nSide*vecZ;
				Vector3d vxBlock=(nSide*vecZ).crossProduct(vecY);
				vxBlock.normalize();
				if(dDiameter==42)
				{ 
					// HCWL
					vzBlock=-vecZTconnector;
					vyBlock=vecYTconnector;
					vxBlock=-vecXTconnector;
				}
				//
				minBlock.setVector3d("vz",vzBlock);
				minBlock.setVector3d("vy",vyBlock);
				minBlock.setVector3d("vx",vxBlock);
				
				//
				minBlock.setString("BlockName",sBlockName);
			// offsets are included in the ptBase
			// no need to include them explicit
				
	//			minBlock.setDouble("OffsetZ",dOffsetZ);
	//			minBlock.setDouble("OffsetY",dOffsetY);
	//			minBlock.setDouble("OffsetX",dOffsetX);
				minBlock.setInt("Version",nVersion);
			}
			Map mDrawBlock=drawBlock(minBlock);
		}
	}
//End draw the body representation//endregion 

//region HSB-9339: check collision with other Hiltis, erase the one closer with wall end
	Group grps[] = el.groups();
	TslInst tslHiltis[0];
	Point3d ptStart = el.segmentMinMax().ptStart();
	Point3d ptEnd = el.segmentMinMax().ptEnd();
	ptStart.vis(2);
	ptEnd.vis(2);
	if (grps.length() > 0)
	{ 
		for (int i = 0; i < grps.length(); i++)
		{
			Group grpI = grps[i];
			// collect all entities
			Entity ents[] = grpI.collectEntities(true, TslInst(), _kModelSpace);
			for (int j = 0; j < ents.length(); j++)
			{
				TslInst t = (TslInst)ents[j];
				if ( ! t.bIsValid())
				{
					// not a TslInst
					continue;
				}
				
				// its a TslInst
				if (t.scriptName() != "Hilti-Verankerung")
				{ 
					// not a klhDisplay TSL
					continue;
				}
				if (t == _ThisInst)continue;
				tslHiltis.append(t);
				Body bdOther = t.map().getBody("body");
				if (bdOther.hasIntersection(body))
				{ 
					if(_Entity.find(t)<0)
					{ 
						t.recalc();
						_Entity.append(t);
						setDependencyOnEntity(t);
					}
					else
					{ 
						setDependencyOnEntity(t);
					}
					// 
					// 
					Point3d ptMiddle = .5*(body.ptCen() + bdOther.ptCen());
					Point3d ptReference=el.segmentMinMax().ptStart();
					if(abs(el.vecX().dotProduct(ptMiddle-el.segmentMinMax().ptEnd()))<
						abs(el.vecX().dotProduct(ptMiddle-el.segmentMinMax().ptStart())))
						ptReference = el.segmentMinMax().ptEnd();
					
					// 
					if(abs(el.vecX().dotProduct(body.ptCen()-ptReference))<
						abs(el.vecX().dotProduct(bdOther.ptCen()-ptReference)))
					{ 
						eraseInstance();
						return;
					}
					else
					{ 
						t.dbErase();
					}
//					Display dp(1);
//					String sTextError = T("|Collision!!!|");
//					dp.draw(sTextError, _Pt0, _XW, _YW, 0, 0, _kDeviceX );
//					return;
				}
				else
				{ 
					if(_Entity.find(t)>-1)
					{ 
						_Entity.removeAt(_Entity.find(t));
					}
				}
			}
		}
	}
	else
	{ 
		Group grp();
		Entity ents[] = grp.collectEntities(true, TslInst(), _kModelSpace);
		for (int j = 0; j < ents.length(); j++)
		{
			TslInst t = (TslInst)ents[j];
			if ( ! t.bIsValid())
			{
				// not a TslInst
				continue;
			}
			
			// its a TslInst
			if (t.scriptName() != "Hilti-Verankerung" )
			{ 
				// not a klhDisplay TSL
				continue;
			}
			if (t == _ThisInst)continue;
			tslHiltis.append(t);
			Body bdOther = t.map().getBody("body");
			if (bdOther.hasIntersection(body))
			{ 
				if(_Entity.find(t)<0)
				{ 
					t.recalc();
					_Entity.append(t);
					setDependencyOnEntity(t);
				}
				else
				{ 
					setDependencyOnEntity(t);
				}
				// 
				// 
				Point3d ptMiddle = .5*(body.ptCen() + bdOther.ptCen());
				Point3d ptReference=el.segmentMinMax().ptStart();
				if(abs(el.vecX().dotProduct(ptMiddle-el.segmentMinMax().ptEnd()))<
					abs(el.vecX().dotProduct(ptMiddle-el.segmentMinMax().ptStart())))
					ptReference = el.segmentMinMax().ptEnd();
				
				// 
				if(abs(el.vecX().dotProduct(body.ptCen()-ptReference))<
					abs(el.vecX().dotProduct(bdOther.ptCen()-ptReference)))
				{ 
					eraseInstance();
					return;
				}
				else
				{ 
					t.dbErase();
				}
//					Display dp(1);
//					String sTextError = T("|Collision!!!|");
//					dp.draw(sTextError, _Pt0, _XW, _YW, 0, 0, _kDeviceX );
//					return;
			}
			else
			{ 
				if(_Entity.find(t)>-1)
				{ 
					_Entity.removeAt(_Entity.find(t));
				}
			}
		}
	}
//End check collision with other Hiltis//endregion 


// create grip if not found
	if (_PtG.length()<1)
	{ 
	// stud mode
		if (stud.bIsValid())
			_PtG.append(stud.ptCenSolid()-vecY*(.5 *stud.solidLength()-dTxtH)+vecX*nSide*(.5*stud.dD(vecX)+.7*dTxtH));
		else if (bmPlates.length()>0)
			_PtG.append(ptBase + vecY * (bmPlates[0].dD(vecY)+dTxtH)+vecX*nSide*(.5*stud.dD(vecX)+.7*dTxtH));			
	}

// set this as Hilti and get dX dim of first Hilti
	Map mapX;
	String sHiltiType = "Hilti-Verankerung";
	mapX.setString("Type",sHiltiType);
	String sText = sTxt;
	_ThisInst.setSubMapX("Hilti", mapX);
	if(bBaufritz)
	{ 
		// HSB-22652
		if(nVersion==1)
			sText="Hilti HCW";
		if(nVersion==2)
			sText="Hilti HCWL";
		if(nVersion==3)
			sText="Hilti HCW-P";
		if(nVersion==4)
			sText="Dolle";
		if(nVersion==5)
		{
			// HSB-22780
			sText="Hilti HCWL+K";
		}
	}
//region apply coordinate dimension to first Hilti attached to the element
	// this needs to trigger all instances to update and draw only the first instance
	//DEPRECATED version 3.2
	if (0)
	{ 
		TslInst tsls[] = el.tslInstAttached();
	
	// collect stexons
		TslInst Hiltis[0];	
		for (int i=0;i<tsls.length();i++) 
		{
			if (tsls[i].subMapX("Hilti").getString("Type")==sHiltiType)
				Hiltis.append(tsls[i]);
		}

	// order by X-position
		for (int i=0;i<Hiltis.length();i++) 
			for (int j=0;j<Hiltis.length()-1;j++) 
			{
				double d1 = vecX.dotProduct(Hiltis[j].ptOrg()-ptOrg);
				double d2 = vecX.dotProduct(Hiltis[j+1].ptOrg()-ptOrg);
				if (d1>d2)
					Hiltis.swap(j, j + 1);
			}
		
	// append coordinate dimension text
		if (bmStuds.length()>0 && (Hiltis.length()>0) && Hiltis[0]==_ThisInst)
		{ 
			Point3d ptRef=bmStuds[0].ptCenSolid()-vecX*.5*bmStuds[0].dD(vecX);
			double dX=vecX.dotProduct(_Pt0-ptRef);

			String s;
			s.formatUnit(dX,2,0);
			sText += " X: " + s;	
		}
		
	// trigger other Hiltis
		for (int i=0;i<Hiltis.length();i++) 
			if (Hiltis[i]!=_ThisInst)
				Hiltis[i].recalc();
	}	
//End apply coordinate dimension to first Hilti attached to the element//endregion 


//region add coordinate dimension
	// append coordinate dimension text
		double dPosStuds = 0;
		if(bBaufritz)
		{ 
		// HSB-21790
			for (int i=0;i<10;i++)
			{
				if(bmStuds[i].color()==32)
				{
					break;
				}
				else if(bmStuds[i].color()!=32)
				{
					dPosStuds = dPosStuds + 1;
				}
			}
		}
		if (bmStuds.length()>0)
		{ 
			Point3d ptRef=bmStuds[0].ptCenSolid()-vecX*.5*bmStuds[0].dD(vecX);
			if(bBaufritz)
			{
				ptRef=bmStuds[dPosStuds].ptCenSolid()-vecX*.5*bmStuds[dPosStuds].dD(vecX);
			}
			double dX = vecX.dotProduct(_Pt0 - ptRef);

		// slotted
			if (dDiameter==U(42))
			{ 
			// find the orientation
//				if(_Map.getInt(_Map.getInt("FlipX")))
				if(nSide==-1)
				{ 
					// left side
					dX -= (U(54.0) - dDiameter) / 2;
				}
				else if(nSide==1)
				{ 
					// right side
					dX += (U(54.0) - dDiameter) / 2;
				}
			}

			String s;
			s.formatUnit(dX, 2, 0);
			sText += " X: " + s;	
		}	
//End add coordinate dimension//endregion 


// displays
	Display dpPlan(nc), dpDxf(nc);
	dpPlan.addHideDirection(vecZ);
	dpPlan.addHideDirection(-vecZ);
	dpPlan.addHideDirection(vecX);
	dpPlan.addHideDirection(-vecX);
	
	Vector3d vxCross = vecX+vecZ;	vxCross.normalize();
	Vector3d vyCross = -vecX+vecZ;	vyCross.normalize();
	// HSB-15004: marking pline
	PLine plCircleMarking;
//	PLine plCircleMarking42;
//	Group grpMarkingCreate("Hilti Verankerungsplan\Marking");
	// HSB-18322: dont create this group anymore
	// 1.8
//	String sGrpMarkingCreate="Hilti Verankerungsplan";
//	{ 
//		if(grps.length()>0)
//		{ 
//			sGrpMarkingCreate += "\\" + grps[0].namePart(1)+" Marking";
//		}
//	}
////	Group grpMarkingCreate("Hilti Verankerungsplan\Marking");
//	Group grpMarkingCreate(sGrpMarkingCreate);
//	if(!grpMarkingCreate.bExists())
//	{ 
//		grpMarkingCreate.dbCreate();
//	}
// plan display
	PLine plPlan1(_Pt0+.5*vxCross*dDiameter,_Pt0-.5*vxCross*dDiameter);
	PLine plPlan2(_Pt0+.5*vyCross*dDiameter,_Pt0-.5*vyCross*dDiameter);
	plCircleMarking.createCircle(_Pt0, vecY, .5*dDiameter);
	if(_dRotation!=U(0))
	{ 
		CoordSys csRot;
		csRot.setToRotation(-_dRotation, vecY, _Pt0);
		plPlan1.transformBy(csRot);
		plPlan2.transformBy(csRot);
	}
//	_Pt0.vis(4);
	if (nVersion == 3)dpPlan.color(5);
	if(bBaufritz)
	{ 
		if (nVersion == 1)
		{
			dpPlan.color(5);
			nc = 5;
		}
		else if (nVersion == 3)
		{
			dpPlan.color(3);
			nc = 3;
		}
		else if (nVersion == 4)
		{
			// HSB-22652 Holzdolle
			dpPlan.color(6);
			nc = 6;
		}
		else if (nVersion == 5)
		{
			// HSB-22780
			dpPlan.color(4);
			nc = 4;
		}
	}
	dpPlan.draw(plPlan1);
	dpPlan.draw(plPlan2);
	if (dDiameter==U(42))
	{ 
		
		PLine plCirc;
		plCirc.createCircle(_Pt0, vecY, dDiameter / 2);
		dpPlan.draw(plCirc);
		PLine plRec;
		Vector3d vecXdrawing = vecX;
		Vector3d vecZdrawing = vecZ;
		vecXdrawing = vecXdrawing.rotateBy(_dRotation, -vecY);
		vecZdrawing = vecZdrawing.rotateBy(_dRotation, -vecY);
		plRec.createRectangle(LineSeg(_Pt0 + vecZdrawing * .5 * dDiameter, _Pt0 - vecZdrawing * .5 * dDiameter - nSide * vecXdrawing * dDiameter), vecXdrawing, vecZdrawing);
		ppMs.joinRing(plRec, _kSubtract);
		// get marking pline
		{
//			PLine plAllRings[] = ppMs.allRings(true, false);
//			if (plAllRings.length() > 0)plCircleMarking42 = plAllRings[0];
		}
		dpPlan.draw(ppMs);
		if (dDiameter==U(42) && nVersion == 5)
		{ 
			// HSB-22780
			String sText1 = "K";
			Display dpText(nc);
			dpText.textHeight(U(30)); 
			dpText.draw(sText1,_Pt0 + vecXdrawing * 40, vecXdrawing,vecZdrawing, 1,0);
		}
	}
	//HSB-15004
//	//region Trigger generateMarkingPline
//		int iMarkingPline = _Map.getInt("MarkingCircle");
//		String sTriggergenerateMarkingPline = T("|Generate Marking Circle|");
//		if(!iMarkingPline || !_Map.getEntity("entMarkingCircle").bIsValid())
//			addRecalcTrigger(_kContextRoot, sTriggergenerateMarkingPline );
//		if (_bOnRecalc && _kExecuteKey==sTriggergenerateMarkingPline)
//		{
//			if(_Map.hasEntity("entMarkingCircle"))
//			{ 
//				Entity ent = _Map.getEntity("entMarkingCircle");
//				ent.dbErase();
//				_Map.removeAt("entMarkingCircle", true);
////				Entity ent42 = _Map.getEntity("entMarkingPline42");
////				ent42.dbErase();
////				_Map.removeAt("entMarkingPline42", true);
//			}
//			
////			EntPLine entPline;
//			EntCircle entCircle;
////			entPline.dbCreate(plCircleMarking);
//			entCircle.dbCreate(_Pt0,vecY,.5*dDiameter);
//			entCircle.setColor(3);
//			grpMarkingCreate.addEntity(entCircle, false);
//			if (dDiameter==U(42))
//			{
////				entPline.setColor(1);
//				entCircle.setColor(1);
////				EntPLine entPline42;
////				entPline42.dbCreate(plCircleMarking42);
////				entPline42.setColor(1);
////				grpMarkingCreate.addEntity(entPline42, false);
////				
////				_Map.setEntity("entMarkingPline42",entPline42);
//			}
//			_Map.setEntity("entMarkingCircle",entCircle);
//			
//			_Map.setInt("MarkingCircle",true);
//			setExecutionLoops(2);
//			return;
//		}//endregion
//		
//	//region Trigger cleanupMarkingPline
//		String sTriggercleanupMarkingPline = T("|Cleanup Marking Circle|");
//		if(iMarkingPline || _Map.getEntity("entMarkingCircle").bIsValid())
//			addRecalcTrigger(_kContextRoot, sTriggercleanupMarkingPline );
//		if (_bOnRecalc && _kExecuteKey==sTriggercleanupMarkingPline)
//		{
//			Entity ent = _Map.getEntity("entMarkingCircle");
//			ent.dbErase();
//			_Map.removeAt("entMarkingCircle", true);
////			Entity ent42 = _Map.getEntity("entMarkingPline42");
////			ent42.dbErase();
////			_Map.removeAt("entMarkingPline42", true);
//			_Map.setInt("MarkingCircle",false);
//			setExecutionLoops(2);
//			return;
//		}//endregion	
//	
//	//region Trigger generateMarkingPlineAll
//		String sTriggergenerateMarkingPlineAll = T("|Generate Marking Circle for All Instances|");
//		addRecalcTrigger(_kContextRoot, sTriggergenerateMarkingPlineAll );
//		if (_bOnRecalc && _kExecuteKey==sTriggergenerateMarkingPlineAll)
//		{
//			// callect all tsl and call their trigger
//			Entity ents[] = Group().collectEntities(true, TslInst(), _kModelSpace);
//			Entity Hiltis[0];
//			for (int i=0;i<ents.length();i++) 
//			{ 
//				TslInst tsl= (TslInst)ents[i]; 
//				if (tsl.bIsValid())
//				{
//					String s1 = tsl.scriptName(); 	
//					if (s1==scriptName() && Hiltis.find(tsl)<0)
//					{
//						Hiltis.append(tsl); 
//						Map mapI = tsl.map();
//						if(!mapI.getEntity("entMarkingCircle").bIsValid())
//						{
//							tsl.recalcNow(sTriggergenerateMarkingPline);
//						}
//					}
//				}		
//			}//next i
//			// this instance
//			{ 
//				if(_Map.hasEntity("entMarkingCircle"))
//				{ 
//					Entity ent = _Map.getEntity("entMarkingCircle");
//					ent.dbErase();
//					_Map.removeAt("entMarkingCircle", true);
////					Entity ent42 = _Map.getEntity("entMarkingPline42");
////					ent42.dbErase();
////					_Map.removeAt("entMarkingPline42", true);
//				}
////				EntPLine entPline;
//				EntCircle entCircle;
//				entCircle.dbCreate(_Pt0,vecY,.5*dDiameter);
//				entCircle.setColor(3);
//				grpMarkingCreate.addEntity(entCircle, false);
//				if (dDiameter==U(42))
//				{
//					entCircle.setColor(1);
////					EntPLine entPline42;
////					entPline42.dbCreate(plCircleMarking42);
////					entPline42.setColor(1);
////					grpMarkingCreate.addEntity(entPline42, false);
////					_Map.setEntity("entMarkingPline42",entPline42);
//				}
//				_Map.setEntity("entMarkingCircle",entCircle);
//				
//				_Map.setInt("MarkingCircle",true);
//			}
//			
//			setExecutionLoops(2);
//			return;
//		}//endregion
//	
////	//region Trigger cleanupMarkingPlineAll
//		String sTriggercleanupMarkingPlineAll = T("|Cleanup Marking Circle for All Instances|");
//		addRecalcTrigger(_kContextRoot, sTriggercleanupMarkingPlineAll );
//		if (_bOnRecalc && _kExecuteKey==sTriggercleanupMarkingPlineAll)
//		{
//			// callect all tsl and call their trigger
//			Entity ents[] = Group().collectEntities(true, TslInst(), _kModelSpace);
//			Entity Hiltis[0];
//			for (int i=0;i<ents.length();i++) 
//			{ 
//				TslInst tsl= (TslInst)ents[i]; 
//				if (tsl.bIsValid())
//				{
//					String s1 = tsl.scriptName(); 	
//					if (s1==scriptName() && Hiltis.find(tsl)<0)
//					{
//						Hiltis.append(tsl); 
//						Map mapI = tsl.map();
//						if(mapI.getEntity("entMarkingCircle").bIsValid())
//						{
//							tsl.recalcNow(sTriggercleanupMarkingPline);
//						}
//					}
//				}		
//			}//next i
//			{ 
//				Entity ent = _Map.getEntity("entMarkingCircle");
//				ent.dbErase();
//				_Map.removeAt("entMarkingCircle", true);
////				Entity ent42 = _Map.getEntity("entMarkingPline42");
////				ent42.dbErase();
////				_Map.removeAt("entMarkingPline42", true);
//				_Map.setInt("MarkingCircle",false);
//			}
//			setExecutionLoops(2);
//			return;
//		}//endregion	
	
		
	// create dependency with entPline
	if(_Map.getEntity("entMarkingCircle").bIsValid())
	{ 
		Entity entPline = _Map.getEntity("entMarkingCircle");
		if (_Entity.find(entPline) < 0)_Entity.append(entPline);
		setDependencyOnEntity(entPline);
	}
	
// element and model display
	if (_PtG.length()>0)
	{
	// write array of zones
		int nZones[0];
		String sThis=sZones;
		sThis.trimLeft().trimRight();
		int nCnt;
		while (sThis.token(nCnt)!="")
		{
			String s=sThis.token(nCnt).trimLeft().trimRight();
			nZones.append(s.atoi());
			nCnt++;
		}			
		
	// display text per zone
		for (int i=0;i<nZones.length();i++)
		{
			int nZone = nZones[i];
			ElemZone elzo = el.zone(nZone);
			Vector3d vzZone = elzo.vecZ();
			Point3d ptOrg = elzo.ptOrg();	
			
			// HSB-5428 make the text with respect to vecY of wall fixed
			if (stud.bIsValid())
			{ 
				Point3d ptYlev = stud.ptCenSolid() - vecY * (.5 * stud.solidLength() - dTxtH) + vecX * nSide * (.5 * stud.dD(vecX) + .7 * dTxtH);
				_PtG[0] += (ptYlev - _PtG[0]).dotProduct(vecY) * vecY;
			}
			else if (bmPlates.length() > 0)
			{ 
				Point3d ptYlev = ptBase + vecY * (bmPlates[0].dD(vecY) + dTxtH) + vecX * nSide * (.5 * stud.dD(vecX) + .7 * dTxtH);
				_PtG[0] += (ptYlev - _PtG[0]).dotProduct(vecY) * vecY;
			}
			
			if (nZone==0)ptOrg = el.ptOrg();
			Point3d ptTxt = _PtG[0]+vzZone*(vzZone.dotProduct(ptOrg-_PtG[0]));
			
			Vector3d vxRead, vyRead;
			vxRead = vecY;
			vyRead=vxRead.crossProduct(-vzZone);

			Display dpModel(nc);
			dpModel.addViewDirection(vzZone);
			dpModel.textHeight(dTxtH);
			dpModel.elemZone(el, nZone, 'I');
			dpModel.draw(sText,ptTxt, vxRead,vyRead, 1,0);
		}
	}

// Trigger ExportHilti//region
	String sExportNames[] ={ "Hilti-Stockschraube", scriptName()};
	String sTriggerExportHilti = T("|Hilti Export|");
	addRecalcTrigger(_kContext, sTriggerExportHilti );
	if (_bOnRecalc && _kExecuteKey==sTriggerExportHilti)
	{
		Entity ents[] = Group().collectEntities(true, TslInst(), _kModelSpace);
		Entity Hiltis[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst tsl= (TslInst)ents[i]; 
			if (tsl.bIsValid())
			{
				String s1 = tsl.scriptName(); s1.makeLower();	
				for (int j=0;j<sExportNames.length();j++) 
				{ 
					String s2 = sExportNames[j]; s2.makeLower();
					if (s1==s2)
					{
						Hiltis.append(tsl); 
						break;
					}
				}//next j	
			}		
		}//next i

	 // set some export flags
		ModelMapComposeSettings mmFlags;
		mmFlags.addSolidInfo(TRUE); // default FALSE
		mmFlags.addAnalysedToolInfo(TRUE); // default FALSE

	// compose ModelMap
		ModelMap mm;
		mm.setEntities(Hiltis);
		mm.dbComposeMap(mmFlags);

	// get parent folder
		String sPath = _kPathDwg;
		for (int i=sPath.length()-1; i>=0 ; i--) 
		{ 
			int n = sPath.find("\\",i);
			if (n>-1)
			{ 
				sPath = sPath.left(n);
				break;
			}
		}//next i

 	// write modelmap to dxx file
		String sFileName = sPath + "\\HiltiExport.dxx";
		mm.writeToDxxFile(sFileName);
		if(bDebug)reportMessage("\n"+ scriptName() + " " + Hiltis.length() + " exported to " + sFileName);
		
		setExecutionLoops(2);
		return;
	}//endregion

//region Append Catalog entries to context commands
	// following triggers for changing cataloges are very much tailored for Baufritz
	String sEntries[] = TslInst().getListOfCatalogNames(_bOnDebug?"Hilti-Verankerung":scriptName());
	for (int i=0;i<sEntries.length();i++) 
	{ 
		String sEntry = sEntries[i];
		sEntry.makeLower();
		if (sEntry.left(2) == "_l" || sEntry == "vorgabe")continue;
		
		if (bExposed && sEntry.left(2) != "aw")continue;
		if (!bExposed && sEntry.left(2) != "zw")continue;
		
		addRecalcTrigger(_kContext, sEntries[i]);
		// if not D42 then dont change the dEdgeOffsetX and dOffsetAxisZ
		int b42=sEntry.find("D42",-1,false)>-1;
		if (_bOnRecalc && _kExecuteKey==sEntries[i])
		{ 
			double dOffsetAxisZprev=dOffsetAxisZ;
			double dEdgeOffsetXprev=dEdgeOffsetX;
			_ThisInst.setPropValuesFromCatalog(sEntries[i]);
			if(!b42)
			{ 
				// when changing catalog via trigger, dont change position properties if not a HCWL
				dOffsetAxisZ.set(dOffsetAxisZprev);
				dEdgeOffsetX.set(dEdgeOffsetXprev);
			}
			setExecutionLoops(2);
			return;
		}
	}//next i
//End Append Catalog entries to context commands//endregion 

// Hardware//region

// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 

// declare the groupname of the hardware components
	String sHWGroupName;
	// set group name
	{ 
	// element
		// try to catch the element from the parent entity
		Element elHW =el.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid())	elHW = (Element)el;
		if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
		}		
	}
if(nVersion!=0)
{ 
// add main componnent
	{ 
		String sHWArticleNumber = "2316449";
		if (nVersion == 2)sHWArticleNumber = "2316495";
		if(bBaufritz)
		{ 
			if (nVersion == 4)sHWArticleNumber = "";
			if (nVersion == 5)sHWArticleNumber = "2316495";;
		}
		HardWrComp hwc(sHWArticleNumber, 1); // the articleNumber and the quantity is mandatory
		
		String sHWManufacturer = "Hilti";
		hwc.setManufacturer(sHWManufacturer);
		String sHWModel = "Wood coupler HCW 37x45 M12";
		if(nVersion==2)sHWModel = "Wood coupler HCWL 40x295 M12";
		if(nVersion==3)sHWModel ="Wood coupler HCW-P";
		if(bBaufritz)
		{ 
			// HSB-22652
			if(nVersion==4)
			{ 
				sHWModel ="Wood coupler Holzdolle";
			}
			if(nVersion==5)
			{ 
				sHWModel ="Wood coupler Hilti HCWL+K";
			}
		}
		hwc.setModel(sHWModel);
//		hwc.setName(sHWName);
		String sHWDescription = "Faster and more efficient wood connector system for assembling prefabricated timber structures";
		hwc.setDescription(sHWDescription);
//		hwc.setMaterial(sHWMaterial);
//		hwc.setNotes(sHWNotes);
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(el);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
//		hwc.setDScaleX(dHWLength);
//		hwc.setDScaleY(dHWWidth);
//		hwc.setDScaleZ(dHWHeight);
		
	// apppend component to the list of components
		hwcs.append(hwc);
		
		if(nFastener > 0)
		{
			String _sHWManufacturer = "Hilti";
			String _sHWArticleNumber = sFastenersArticles[nFastener - 1];
			String _sHWModel = sFastener;
			double	dHWScaleX = sFastenersLength[nFastener - 1];
			double dHWScaleY = U(12);
			double dHWScaleZ = U(12);
		
			HardWrComp _hwc(_sHWArticleNumber, 1);
			_hwc.setCategory(T("|Connector|"));
			_hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			_hwc.setManufacturer(_sHWManufacturer);	
			_hwc.setModel(_sHWModel);	
			_hwc.setDScaleX(dHWScaleX);
			_hwc.setDScaleY(dHWScaleY);
			_hwc.setDScaleZ(dHWScaleZ);
			hwcs.append(_hwc);
		}
	}
}
// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);	

	//endregion




#End
#BeginThumbnail
M0DW<AP4``````#8````H````D0$``"T!```!`!@``````*:'!0`2"P``$@L`
M````````````________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________/O__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________S[_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________^^________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________OO______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________SS_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________\\________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________._______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________[W_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________^]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________O?______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________SW_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\^____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M/?__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________S[_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________\^____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________/O__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_[[_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________\]____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________O?__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________S[_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__\]________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________O?__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________[S_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________^^________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____/O______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________S[_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\\________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________OO______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____[[_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________\_OW______O____________W]_OS____\_____O_\_/_^_?__
M___]_?W_______________________________________W^_O__________
M______________W__OW5U=?)R,K*R<RBHJ>DI*>BHJ21D).!@H2#@X2"@82"
M@82#@H6#@H6!@()M;6]G:&AM;F^"@8*#@H.#@H."@82"@82"@82#@H61D92C
MHJ.CHZ6AH:7(R,K(R<S5U=C___W____]_?W_________________________
M___________]_?W________\_?W]_?O____________]_OS_____________
M_______________________________^_O__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________\^________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________OS_
M_____?W]_?W]_____/___/___/________[]__[]___]____________^OW\
M___]__[]_/S]____________^OW^^OW]T=/4R<G+H**FFYN>@H*&@H*#9V=H
M9V=H9F9G9VAH9V=H9V=H:&=G:&=G:&=G:&=G9V=G9V=H9V=H9V=H9F9G:&AH
M9F9F:&AF9F9F9VAH9F=G9V=G9V=G9V=H9V=H9VAH9V9F:&=G9V=G:&=G:&=G
M9V=F9V=G9V=G:&=H?'M\@8"#FYJ>HZ.FR<G+U-77___]________________
M__________________[]_____________?W]_________OW______/W]____
M_____?W]____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________/O______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________[^__[]____
M__W]_?W]_?_____^_?____[^__[]__W]_?____S]_?[^__[]_____^[M[LK(
MRZ2CI8F)BWM[?&=G:&=G9V=G9VAH:&9F9F9G9V=G9V9F9F=H:&AG9VAG9VAG
M9V=F9VAG:&AG:&=H:&=G:&=G9V=G9V=H:&=G:&9F9F9F9FAH:&9F9V=G9V9F
M9FAH:&=G9V=G9V9F9F=G9V=H:&=G:&=H:&=H:&AH:6=F9FAH:&AH:&AG9VAG
M:&=G:&9G9V=G9V=G:&=G9V=G9V=G9WI[>XB(BJ.CILO*S>SJ[?[]__[]____
M__[]______W]_?_^__[]__[^__K]_?S^_?____________S^_?S^_O______
M__[]_?______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________[W_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________OW]_/O________]_?W____^_?W^_O[\
M___\___[^_S^_?_]_/_]_?O*R<NBHJ6+B8MT<W9H9VEH:&EG9VAH:&EG9V=G
M9V=H:&AG9V=G9V=H:&AG9V=G9V=G9V=F9F9F9F9G9V=G9V=G9V=F9F=G:&AG
M9V=G9VAG9FAH9VAH9VAG9FAI:&EG9F=G9VAH9VAH9VAH9VAH9VAG9F=H9VAG
M9VAH9VAG9VAG9V=G9V=H:&AH9V=H:&AH9VAG9VAH9VAG9V=G:&AG:&AG9V=H
M9V=G9V=G9V5H:&9G9F=H9VAG9V=G9V=H:&ER<W6*BHVDHZ;)RL[[^_G____]
M_?W____]^_K]_/O______OW_______________________W__OW_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______^^____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________O[__O[__OW__?W]_/W]___]_O[]_____O[_____R,G,HJ*E
M@8*#9F=G9F9F9V=H9F=G9V=G9F=G9V=G9V=G9V9F:&AH9V=H9V=G9V=G:&AH
M969F:6EJ9V9G:&=H9V=H:&=H9V=H9F9G:&=H:&=H9V=H9V=G:&=G:6EI:&=G
M9V=G9V=G:&=G9V=G9V=G:&=G:&=G9V=G9V=G:&=G9V=G9V=G9V=G:&=G:&=H
M9V9H9V=H:&=G9V=G9V=G9V9F:&=G:&=H9V=H:&AI9V9G9V=H9VAH:&AI9F9G
M9V=H9V9H9V=G:&=G9V=F:&AI9V=H9VAH9V9F:6AI@8&#HZ.FRLG,________
M_/[]_/___/___________________/S_^_W^________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________/O______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________[]
M__W]_?W^_/S\_?W\_?[^_]_>WZRML(N*C&9F:&AH:6=G9VAG:&=G:&=G:&AG
M9V=F9V=G:&AG:&AH:6=F9FAG9V=F9FAG9VAG:&=G:&=G:&=G:&9G9VAH:&AH
M:&=G9V=G9V9G9VAG9V=G9V=G9V=G9VAG9V=G9VAH:&AG9V=G9VAG9VAG9VAH
M9VAG9V=G9VAG9VAH:&AG9VAG9V=G9VAG9VAG9VAH9VAG:&=G:&=H:&AH:&9F
M9F=H:&=G9V9F9VAG9VAG9VAG9VAG9V=G:&=G:&=F:&=G:&=G9V=G9V=G9VEH
M:&=G9VAG9V=G9VAG96AH:6=G:&=G9V=G96AH9F=G:(B(C:ZML.+AY/W]^___
M__S]_?K\_?S\_?_______?______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________[W_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________]_/O____]_/W6U-:B
MHJ1Z>GQG9VAG9VAG9F9H9V=H9VAH9V=H9V=G9V=H9V=G9VAH9V=H:&AG9V=G
M9F=H9VEH9V=G9V=H9V=G9VAH9VAG9VAH9VAG9F=G:&AG9VAH:&EG9VAG9VAF
M9F=G9V=G:&AG9VAG9VAF9V=H9VAH9VAH9VAH9VAG9VAG9VAG9FAG9VAH9VAH
M9VAH9VAG9VAG9VAH9VAG9VAH:&EG9F=G9FAH9VAG9F=H9VEG9VAG9VAH:&EH
M9VAH9VAH9VAH9V=G9V=G9V=H:&9F9F5H:&AF9F9F9F=G:&AG9VAG9VAH9VAH
M9VAG9F=H9V=H9V=H9V=H9V=G9V=H:&AG9V5G9V=Y>GN:FIW4U-7______O_]
M_/W^_O______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________^]____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________X>#@HZ.F<G-U9V=G9F=G9V9H:&=G:&=G
M9VAH9F9F9V=G9V=G9F9G9F=H9V=H9V=H9V=G9V=G9V=H9V=H9V=G:&=G9V=G
M:&=G9F=G9VAH9V=G9VAH9V=G9F=G9F=G9V=G9V=H:&=H9V=H9V=H9V9G9V=G
M9V=G9V=H:&AH9V=G:&=G9V=G:&=G:&=G9V9F:&=G:&=G:&=G:&=G9V=G9V=G
M9V9F:&=G:&=G9F9F9V=G:&=G:6AH:&=G:&AH:&AH9V=G9V=G9V=H9V=G9F=G
M:&=H9V9H9V9G9V9G:&=H:&=H9V=G9V9F9V=G9V=G:&=G:&=G9F=G9V=H9V=H
M9V=H9VAH9V=H9V=G9V=G9V9H:&=G9V=G:&=H<W-VHZ.FW]_@____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________OO__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________S]_?________[^__________S\_?____K[^_____[]__[^
M_^SL[;:UMWI[?F=G9V=G9V=H:&9G9V=G9VAH:&=G:&=F:&=H:&=G:&=G9V=G
M9V=G9VAG9V9F9VAG:&=G:&=G9V=G9V9G9V9G9VAH:&=F9FAG9VAG:&9F9VAG
M:&AG9V=G9VAH:&9G9V=G9VAG9V=G9V=G:'-R=(&!@H&`@X"!@Z"@H:"@HJ"@
MHZ&AHY^@HI^?HJ"@I+NZN\7$Q;&PLJ&AI*"@HZ&@HY^?HI^?HJ"?HI^?HH*!
M@H*!@H&`@7)R<V=G:&AG9VAG9VAG9V=G9V=G9V=G9VAH:&AG9VAH:&=G9VEH
M:&AG:&=G:&=G9VAH9VAH:&=G9V=F9VAG:&AH:&AG9V=G9V=G9VAG9V=G9V=G
M:&AG:&AG9VAH:&AG9V=G9VAG9V=H:&=H:'IZ>K6TM^[M[_K[_?S___S^_?O]
M_/________S\_?______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________SW_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________________^_?__
M_______]_?W___W____Z_?W[_OW[_OS\___]_?W4U-:0D)5M;6YH9V=H9V=G
M9F=G9VAH9VAH:&EH9VAH9V=H9V=H:&AF969H9VEG9VAH9VAG:&AF9F9G:&AH
M:&AH:&AH9V=G9VAG9F=G9VAF9V=G:&AF9F9G:&AF9VAK;&V`@8.)B8R?GJ&R
ML;/%Q,7.S]#Q\._R\_+R\_+S]//R\_3Q\O+R\_3U]//T\O'T\_+T\O+U]/+P
M\/'U]/7S\O/S\O'R\?#U]//T\O+T\O'S\O'T\_+T\O+R\_3T]?7Q\O/S\_+T
M\_+T\_'/T-'$Q,>RL;.@GZ*/CY&`@(%N;V]F9VAF:&=G9VAG9V=G9V=H9V=H
M9VAH9VAH:&AG9V9G9V=G:&AF9F=G9V=G9V=F9V=G:&AG9V=G9V=G9FAG9VAH
M9VAI:&EH9V=G9V=G9F9I:&AG9VEF9V>2DI35U-;]_/[^_O______________
M___]_/[\___Z_?W]_?W____]_?W_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\^____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________]_?W]_/S]_____/S_
M_?W\___]_O[___[_M+2W@8&":&AF:&AF:&AH:&AH9V=E:&=G9V=G9V9G:&=H
M9V9H:&AH:&AH9V=G9V=G9V=G:&=G9V=G:&AH9V=G9V9F:&=G9V=H:&=G9V=G
M9V=G9VAI@8&$EY::J:BKQ<7(Y.3C\_+Q]//R]/+Q]?3U\O'R\O'R]//R]?/R
M\_'P\_+Q\O+R\_/R\?'Q\_/R\O+R\O/R\O+Q\O+R\O+Q\_/R\O/T\O/T\_3T
M]/7U\O/S\O/T]/7U\?+S\O/T\O/T\O/T\O/T]?;V\O'S]?3R\_'Q]?3S]//R
M]//T\?#R\?#Q]//T]//RYN;EQ<;&J:FLF)>9@(&#9FAH:&AH9F9D:6AF9V=G
M:&=H9VAH9VAH9V=H9V9F9V9F:&AH9V=G9V=G9F9F9V=G9V=G9V=G9V9F:&AH
M:&=G9V=G9V=G9V=H9V9G:&AG>WI\M;6X___]_/___/___/___O[______OW\
M_?[\_?W]_/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________/O__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________[^__S]_?____S^_OK[^/____'O\*ZML'-S
M=&AH:6=F:&AG:&AG9VAH9V=G9V9H9V=G:&=G9V9G9V=H:&=G9VAG9VAG:&AG
M:&9G9V=G9V=H:&AH:&=G9V=G9V=G:&=F9WEZ?)>7F;*RM,[,SO;S\?3S\O3R
M\?;T\O+R\?3T\_+R\O3T\_+S\O+S\O'Q\/+R\?3S]//R\_3S]/3R\O+Q\//R
M\?7T\_3S\O/R\?7T\_/Q\?/R\?3R\O7S\O/R\?/R\?7T]?3S]/3S]/3S]/+Q
M\_3S]/7T]?/R\_/R\_/R\_/S]/7S]/+R\_7T]?+Q\_7T]?+S\O+R\O+R\O+R
M\O+S\O+S]/+S]/+S]/+R\?+R\?;T\\_-T+*RM9>7FWEY>VAH:&=G9V=G9V=G
M9VAH:6AG:&=F9VAG:&AG9V=G9V9F9F9G9V9G9VAH:6=G:&AH:&9F9FAH:&AG
M9VAG:&AH:6=F9V=G9W)S=:VMK^OM[/_]^O___O[]__[^__[^_O[^_/______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________[W_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________^_?W^_O_N[>^CHZ9M;6YH9V=H9V=I:&AH:&AG9V=G
M9VAG9FAG9VAH:&EH:&AF9V=G:&AF9F=H9VAH9VAI:&AG9V=G9FAG9F=H:6EG
M9VAY>GN8F)JZN;SGY>3V]//T\_3T\_3U]/7Q\O+Q\O/R\_/R\_3R\_3R\_3U
M]/7R\O/S\O/T\_3S\O3R\?+R\O+R\O'S\_+R\O+R\_+R\_+R\O'R\O+T\_3T
M\_3T\_3S\O3S\O/R\?/S\O/T\O+R\_3S]/3T]?7S]/3Q\O/T]?7S]/3R\_3R
M\_+S\_+R\_+R\_+R\O+T]//Q\?'R\O+S\_+Q\?#R\O+R\O+R\O'T\O'T\_+R
M\?+U]/7S\O/R\?+R\?/S\O/S]/3P\?#DY.6\N[V7EIIY>GMF9F9G9V5H9V5H
M:&AG9F=H9VAF9F=H9VAH9VAH9VAF9F=G9V=G9V=G:&AG:&AF9V=G9V=H:&AG
M9V=G9F=G9F=M;6ZCHZ;N[>_\_/W\___X^_S^_?_^_/W_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________^\____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________/[]
M_OS\\>_PI*.F;6UN9F9G9F=G:&=G9V=G9V=G9V=G9V=H9F9G9V=H:&=G9V9F
M9V9F:&=G9V9F9V9H9V=H:&=G:&AG:&=E:VQMD)"2LK&SY^3D]//T]//T\O/S
M\O/T\/'R\_3T\O/R\O/R\O/R\/'P\O+R]/3S\_3U\?+S\_3U]/3S\O/R\O+Q
M\O'P]//R\_+S\_+T\_/T\O'R]?/T\_+T\_+S]//T\O+R\O+R\O/R\O/S\O/T
M\O+R\_/R\O+R\O/R\O+R\/'P\O+R\O/R\_3S\O/R\O+Q]//T]?3U\_+T]?3U
M\_+S\O'S]?3U\_+S\_+Q]O3S\_+T\O'S]?3U]?3U]//R]//Q]//R]/+Q]/+Q
M\?'Q\_/R\O+R\_/R\O/T\_+T]//Q]//RY^7ELK*TD)"3:VQM9V=H:&=G:&AH
M9V=G:&=E:&=G:6AH9V=G9F9G9V=G:&=G9V9F:&=G9V9G9V=H9V=H9VAH:&9I
M9V=G;&UNHJ*F[NWO_________OW_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________OO__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________ZRML&UM<&=G9VAG
M:&=G9VAG9VAG:&=G:&=F9FEH9F=G9V=H:&=G:&=G9V=G9FAG:&=G9VEH:&=H
M9F9G9VUM;X^.D;N[N_+S\_'R\_+R\?'Q\?+P\/3S\O3R\?3S]/+R\?#P\/+R
M\O3S\O3S\O/R]/+Q\O/R\_+R\?+R\O/T\_+S\O'Q\?+R\O+S]/'R\_+R\O+R
M\?+R\?+S\O#Q\/+R\?3U]?+S\_#Q\O+S]/3U]?+S]//T]/+S]/+S\_+S]//R
M\_/R\_3S]/7T]?/R]//R\_7T]?/R]/+R\O#P\//S\O#Q\/3T\_'Q\/+S\O+S
M\O/R\_3S]/+Q\/7S\O/R\?/R\_3S]//S]?+S\O+R\O'Q\/'Q\?/R\_3S\_+Q
M\O/S]?'Q\?+S\_+S]/+S]?7S]//Q\?CT\;JYO)B8F7%R=&=G:&=G9V=F9FAG
M9V=G9VAG:&AG:&=F9V=G:&=G:&=G9V=G9V=G9V=G:&AG9V=F9VAG9V=G971T
M=K:UN/___?_^_?______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________SW_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________^AH:5G:&AH9V9F9V=G9VEH:&EH:&=G
M9VAG:&AF9F9G9V=G9V=H9V=H:&AH:&AF9F=G9VAL;&Z0D)*[NKSS\N_T\_3R
M\_7U\_+S\O'U]/7T\_3S\O3T\_3T\O'T\_+S\O3P\?+R\_3R\_3Q\O/Q\?'T
M]//R\O'S\O/T\_3T\_3U]/7T\_3S\O/S]/3R\_/T\_3T\_3T\_+R\?#R\O+R
M\_+R\O'P\?#T\_+V]//T\_+V]//T\_+T\_+T\_3S\O3S]/3R\_3R\_3R\_/S
M]/3R\_3R\_3R\_3S\O/S\O/T\_3T\_/S\O/T\_+U]/+T\_+T\_3T\_3T\_3S
M\O/T]//R\O+R\_+R\O+S\O'S\O/S\O3P\?+T]?7S\_+T]//R\O'S\O3T\_3R
M\O+R\_+S\_+S\_+R\?+U]/7R\?+T\_*ZNKN/CI%L;&YG9VAH9V=G9V=G9V=G
M:&AH9VAH9VAG9V=H9V=H9V=G9V=F9F9G:&AG9F=H9VAG9V=G9V=Z>G[+R<G_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________\]________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________/S]_/___O[^_________?W^________________________
M_____________/S][.WN;6UO9V=G9F=G:&=G9V=G9V9H9V=G:&=I:&=H:&=E
M:&=H:&AF:&=G9VAH@(&%L[.U\O'O\_3U\_3T\_3U\_+Q]/+Q\O/R\O+R\O+R
M\O+Q\O+R\O+R\O/R\O+R\O/R\O+R\O/R\O/R\O+R\O+R\O+R\O+Q\_/R\_/R
M\O+Q\O/R\O+Q\O+R\O+R\O/R\O/R\O+R\O/R\O+R\O+Q\O+Q\O+Q\O+R\O+R
M\O/R\O+R\O/R\O+R\O/R\O+R\O/R\O+R\O+R\O+R\O+Q\O/R\O/R\O+R\O+Q
M\O/R\O+R\O+R\O+Q\O/R\O/R\O+Q\O+R\O+R\O+R\O+Q\O/R\O/R\O/R\O+Q
M\O+R\O/R\O/R\O+R\O/R\O+Q\O+Q\O+R\O+R\O/R\O+R\O+R\_/R\O+Q\O+Q
M\O+Q\O/R]O3S\_+S\_/U]//U]/+QLK&S@8&$9V=H:&AF:&=H:6=H9V9F9V=G
M9F9F9V9G9V9E9V9F:&=G9V9F9V=H9V=G9V=H9F9F:&=HBHF,XN#C__[____^
M___________]________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________/O__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________[]__S_
M__O^_?____[]________________________________________________
M__[^_*ZML&AH:&EH:69G9V=G9VAG:&=G96=G:&AG:&=G9V9G9VML;IB8F]S:
MV_?S\?/R\?7T]?'R\_3T]?/S\O3S\O3S\O+R\O+R\O+S\O+R\O+S\O+R\O+S
M\O+R\O+R\O/S\O+R\O+R\O+R\O+R\O+R\O+R\O+R\O+R\?+R\O+R\?+R\O+S
M\O+R\O+R\?+S\O+R\?+S\O+R\O+R\?+R\O+S\O+R\O+R\O+R\O+S\O+R\O+R
M\?+S\O+R\O+R\O+R\O+R\?+S\O+R\?+R\O/S\O+R\O+R\O+R\O+R\O+S\O+S
M\O+R\O+R\?+R\?+S\O+R\O+S\O+S\O+R\O+R\O+R\O+S\O+S\O+R\O+R\O+R
M\O/S\O+R\?+S\O+R\?+R\O/S\O+R\?+S\O+R\O+R\O+R\O+R\O+R\?3T\_'Q
M\?3U]>_P\?3U]?7T\_3R\=O9VY>7F6QM;6=G9V=G:6=G9V=G:6AH:&AG:&=G
M9V=F9VEH:&9F9FAH:&=G9V=F:&AH9F9G:=_>X/____W]_?_^______W]^_W]
M_?__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________[[_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________W[_/K____^_?__
M___]_?O________________________________________^_?W___UR<G5H
M9VAH:&EH9V=G9VAG9VAG:&AG:&9F9F>"@8+HYN;P\?#R\_3S\_7Q\?/R\?/S
M]/3R\O'R\O'U\_3R\?/R\_+R\O+R\_+R\O'R\O'R\O+R\O+R\O+R\_+R\O'S
M\_+R\O+R\O'R\_+R\O'R\_+R\O+R\O'R\_+R\O+R\O+R\_+R\O+R\O+R\_+R
M\_+R\O'R\_+R\O+R\O+S\_+S\_+R\_+R\_+R\O+R\O+R\_+R\_+R\O+R\O'R
M\O+R\O'R\O+S\_+R\O+R\O+R\O'R\O+R\_+R\O+R\O+R\O+R\O+R\_+R\O+R
M\O+R\O+R\O+R\O'R\O+R\O+R\O+R\_+R\_+R\_+R\O'R\O+R\O'R\O'R\O'R
M\O+R\O'R\O+R\_+R\O'R\O'R\O'R\_+R\O+R\O'T\_3T]//R\_+R\_+S\_+P
M\?+S\_3S]/;R\O+GY>6RL;-Q<G1G9V9H:&AG9FAG9V=G9FAH9VAH9V=G9V=H
M:&AG9F=H9VEH:&:0D93___W____]_?W\_/________W_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________^\________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________?[\__[]_OW]_?W]^OO[__[]_____?S_____
M_________________________________O[_^OW^M[:Y:&=H9V=H9V=G:&=H
M9V=H9V=H:&AH:&=H969GT,[0\/'R\O/R\O/T\O/T\/'Q]?3S\_'P\O'P\O/T
M]/7U\O/R\O/R\O+R\O+R\O/R\O+Q\O/R\O+R\O+Q\O+Q\O/R\O+Q\_/R\O/R
M\O+R\O+R\O/R\O/R\O+Q\O+Q\O+Q\O/R\O+R\O/R\O/R\O/R\O+R\O+R\O+R
M\O+R\O+Q\O+R\O+R\O+R\O+R\O/R\O+R\O+R\O+R\O+Q\O+Q\O+R\O+R\O+Q
M\O/R\O+R\O+R\O+Q\O+R\O/R\O+Q\O+Q\O+R\O+R\O+R\O+R\O+R\O+R\O/R
M\O+R\O/R\O+Q\_/R\O+R\O+Q\O/R\O+R\O+R\O+R\O/R\_/R\O/R\O/R\O+Q
M\O/R\O+Q\O+R\O+R\O+Q\O/R\_'P]?3R\O'P]?3R\O+R\_3S\O+Q\O+R\_3V
M]//T]?3S]?+QLK*W<W-S9V=G9V=G:&=G9VAH9V=H:6EI:&AH9V9G9V=G;FYN
M[NSL_O[__/S]_/S]_________?W]_/S_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________//______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________?[]_?[^______S___S]_?__________________________
M______________S\_?[^__W\^_O[^H&"A6=F9F=G9V=G9VAG9F9G9V=G:6AG
M:&EH:'^`@?3S\O#Q\?#Q\//S\O/T\_/R\?3S]//R\_+S]//T]?+S\O+R\O+R
M\O+R\O+R\?+R\O+S\O+R\O+R\?+R\?+R\O+S\O+R\?+R\?+S\O+R\O+R\?+S
M\O+R\?+R\O+S\O+S\O+S\O+R\O+R\O+S\O+R\O+R\?+S\O+R\O+S\O+R\O+S
M\O+R\?+R\O+S\O/S\O+R\?+R\O+R\O+R\O+R\?+S\O+R\?+S\O+R\?/S\O+R
M\O+R\O+R\?+R\O/S\O+R\O+S\O+S\O+R\?+R\?+S\O+S\O+R\?+S\O+R\O+R
M\O+R\?+R\?+S\O+S\O+S\O+R\?+S\O+S\O+R\O+R\O+R\O+R\O+R\O+S\O+R
M\O+R\O+R\O3R\O/R\_3S]//R]/+Q\_7T]?+Q\O3R\?+R\?+Q\O+R\O+S]/+Q
M\^CEYF=G9VAH9FAG9V=G9VAH:6AH:&=G:&AH:6=G9J.CIO____S\_?S\____
M__S]_?____W]_?[]____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________S[_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________O_^
M_O_Z^_O\___[_O[^_O[]_?W\___________________________________\
M___[^_S__OWZ_/O)R<MG9VAG9V=H9V=F9V=G:&AG9V=H9V5G9V=F9VC%Q,;T
M\_+T]/7R\_3R\_3S\O3S\O3S\O/S\_+P\/#R\_+R\O'R\_+R\O'R\O+R\_+R
M\_+R\O+R\O'R\O+R\_+R\_+R\_+R\_+R\_+R\O+R\_+R\_+R\_+R\O'R\O'R
M\_+R\O'S\_+R\O'S\_+R\O'R\_+R\O+R\O+R\O'R\O'R\O+S\_+R\O+R\_+R
M\O+R\O'R\O+R\O+R\_+R\O'R\_+R\O+R\O+R\_+R\O+R\O'R\O'R\O'R\O+R
M\O'R\_+R\O+R\O+R\O+R\O'R\O+R\O+R\O+R\O+R\O+S\_+R\_+S\_+R\O+R
M\O'R\O'R\_+R\O'R\_+R\O+R\O'R\_+R\O'R\O'R\O+R\O+R\O'R\_+S]/3Q
M\O+T]/7R\_3S\O3T\_3S\O3S\O/T\_3T\_3Q\>_R]//V]/.?GZ-G:&AH9V=G
M9V=G9V=F9VAI:&AG9FAG:&AK;6WO[.W___[^_OS_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________\]________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________/S__________/____SX
MI*.FHJ*G__[]_____________________________________?W]_?S]__[]
M____B(B-:&=H9V=G9V=G9V=H:&AH9VAH:&=G:&AF>7I^]//R]//T\_/T\_+S
M\_3U\_3T\?+S]//T]//R\O+R\O+Q\O/R\O+Q\O+R\O+Q\O+Q\O+Q\O+Q\O+R
M\O+R\O+R\O+R\O/R\O/R\O+R\O/R\O/R\O/R\O+Q\O/R\_/R\O/R\O/R\O+Q
M\O/R\O/R\O+R\O+R\O/R\O/R\O+R\O+Q\O+R\O+R\O/R\O+R\O+Q\O/R\O/R
M\O/R\O+R\O+R\O+R\O+R\_/R\O/R\O+R\O+R\O+R\O+R\_/R\O/R\O/R\O/R
M\O+R\O+Q\O+Q\O/R\O+R\O/R\O/R\O+R\O+Q\O/R\O+R\O+Q\O/R\O+R\O/R
M\O+R\_/R\O/R\O+R\O+R\O+R\O/R\O+Q\O+R\O+R\O/T\O/T\O+R\?'Q\O+R
M\O/R\O+Q]/3S\O'P]//R]/7U\O/TVMC9:&AH9V=G:&=E9V=H:&=G9V=G:&=H
M:&=I9F9GM[:X______[]___]_/SZ________^_O\_____O[^____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________/?______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________O___?____[]_Y&1EF=G9VUM;^WL[O__
M_______________________________^_?_^__________S]_>'@X6AG:&=G
M:&=G9VAG9V=F9V9G:6=G9V=G9V=G9[*QM?/R]/;T\_3R\?'Q\?#Q\/+S]/3S
M]//R\_+S\O+S\O/S\O+S\O+S\O+R\O+S\O+S\O+R\?+R\O+R\O+R\O+R\O+R
M\O+S\O+S\O+R\O+S\O+R\O+R\?+R\O+R\O/S\O+S\O+R\O+R\O+S\O+R\O/S
M\O+S\O+R\O+R\?+S\O+R\O+R\?+S\O+S\O+R\O+S\O+R\?+S\O+R\O+R\O+R
M\O+S\O+S\O+R\O+R\?+R\?+S\O+S\O+R\O+R\O+S\O+R\?+S\O+R\?+R\O+R
M\O+S\O+S\O+S\O+R\O+R\O+R\O+S\O/S\O+S\O+S\O+S\O+S\O/S\O+R\?+S
M\O+S\O+S\O+S\O+S\O+R\?+R\O/R\_3S]/+S]/+S]//T]?+S]/+S]//T]/+S
M]?/S\?3S]/3S])"/DF=G:&=G:&=G:&=F9VAG9VAG96AG:6AH:'1T=O____C[
M_/[]__S\_?S\_?____S\_?____S\_?______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________[[_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________]_OS__O_____\_/W____]
M_?O__OW]_/_\_O[^_O____^1D95H9V=H9V=F9FB2DI/]_?W\___[_?S_____
M__________W^_O_\___________\___Z_?W__?J2DI1G9VAH9V=H9V=H:&AF
M9V=G:&AG:&AG9VAR<G3EY>7R\O#R\_3T\_+T\O'T]//Q\?3V]//R\O'R\O'R
M\O+R\O+R\O'R\O+R\O+R\O+R\_+R\O'R\O'R\_+R\O'R\O+R\O'R\_+R\O'R
M\O+R\O+R\_+R\O+R\O+R\O+R\_+R\_+R\O+S\_+R\_+R\O'R\O+R\O'R\_+R
M\O'R\O+R\O'R\O'R\O+R\O+R\O'R\_+R\O'R\O+R\_+R\_+R\O'R\O+R\_+R
M\O+R\O+R\O+R\O'R\O'R\_+R\O'R\O'R\O'R\O+R\O+R\O+R\O+R\_+R\O'R
M\O'R\_+R\_+S\_+S\_+R\O+R\O'R\O+R\O+S\_+R\O+R\_+R\O'R\O+R\O+R
M\_+R\O+R\O+R\_+R\_+R\_+R\_+R\_+R\_+R\O+S\_+T\_+R\O+R\O+%Q,5G
M9F9H:&9G9VAH9VAG9V=G9VAG9VAI9V=G9V>^O\#]_?W__OW_____________
M___________________\_/W\__________WL[>_________________\_?W^
M_O[____]_?W__OW____^_O______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________^\
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________O[^_________OW______?W[_____O[_
M___]D)"49F=G:&=G:&AH9V=H9VAIX>'@_?W\^?W__?S[_OW________]_OW_
M_____________?W\___]_OW_Z^KL;6UM9V=H9V=G9F9F:6AH:&=H:6EI9V=G
M9V9GGY^C]//T]/3S\O'R]//R\O+Q]?;V\O'P\O+R\O+R\O/R\O+R\O+R\_/R
M\O/R\O+R\O/R\O+Q\O/R\O+R\O/R\O+Q\O/R\O/R\O+Q\O/R\O+Q\O/R\O+R
M\O/R\O+Q\O+R\O+Q\O+Q\O+Q\O+Q\O/R\O+R\O+R\_/R\O/R\O+R\O+R\O+R
M\O+R\O+R\O+Q\O+R\O/R\O/R\O/R\O+R\O/R\O+R\O/R\O/R\O+R\O+Q\O+Q
M\O+R\_/R\O/R\O/R\O+R\O+R\O+R\O+Q\O+Q\O+Q\O+R\O+Q\O+Q\O+R\O+Q
M\O+Q\O/R\O+R\O/R\O/R\O+R\O/R\O+Q\O+Q\O/R\O+R\O+R\O+R\O/R\O/R
M\O/R\_/R\O+R\O+R\O/R\O/R\O/R]//T\O+Q]//R@(&$:6AI9V=G9V=G:&=G
M:&=H9V=H9V=G:&=E@8&$_O[______?[\____________________________
M_____/S]_O[_____K:VP>GI]_O[_^_[^___]_______^_____OW_________
M_/W]________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________/?______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________S[_?___?S\_?[^__O[^_________[]_____Y&2E6=G9VEH9F=H
M:&=G9V=H:&AG9X*#A?[]_?O]_OS\_?[]______W]_?____S[^____?____[\
M__[^_?S______Z*BIF=G:6=G9VAI9VAG9VAG9V=G9VAG9VEH:&QL;N;DY/'R
M\O/T]?7T\_'R\O+S\O;T\_+S\O+R\?+R\?/S\O+R\?+R\?+R\O+R\?+R\O+R
M\O+R\?+R\?+R\O+R\?+R\O+R\?+R\O+R\?+R\O+R\?+S\O+R\O+R\?+R\?+S
M\O+S\O+R\?+R\O+R\?+R\?+R\O+R\O+S\O+R\?+R\?+R\?/S\O+R\?+R\O+R
M\O+S\O+S\O+S\O+S\O+R\O+R\?+S\O+R\?+R\O+R\O/S\O+S\O+R\O+R\O+R
M\O+R\O+S\O+S\O+S\O+R\O+R\O+S\O+R\O+R\O+R\?+R\O+S\O+S\O+R\O+S
M\O+S\O+R\?+R\O+R\O+R\?+R\O+R\O+R\O+R\?+R\?+R\?/S\O3T\_3T\_+R
M\?+R\?+R\O+S\O3T]?3S],7$Q&=H:&=G:&=G:&=H:&=G9V=G9V=G:&=H:&9F
M9LK)S/S\__KZ_?________________________________________W]_>SL
M[FUM;FAG:)*2D_S^_OK]_O___?W]_?________[]__W]_?_^_?__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________S[_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________________^_O__
M___\_/W]_?W__OW^_O[^_O____^2D91G9VAH9V5G9F9I:&EF9F9H9V=H9VAG
M9V?*R<S]_OS\___________^_?_]_?W____^_O_____________[^_O___WM
M[>YT<W=H:&EG9V5H:&9H:&AG9FAI:&AH9V=G9V>8F)KR\?3R\O'R\?+T\_3R
M\O#R\_3R\O'R\O'R\O+R\_+R\O+R\O+R\O+R\_+S\_+R\_+R\_+R\O+R\O+R
M\O+R\O'R\_+R\_+R\O+R\_+R\_+R\O+R\O+R\_+R\O+R\O+R\O+R\O'R\_+R
M\O+R\_+R\_+R\O+R\O+R\_+S\_+R\_+R\O+R\_+S\_+R\_+R\_+R\_+R\_+R
M\O+R\O+R\O+R\_+R\_+R\O'R\O+R\O+R\_+R\O'R\O'R\_+R\_+R\O+R\_+R
M\O+R\_+R\O+R\O+R\O'R\O+R\O+R\_+R\O'R\O'R\O+R\O'R\O+R\_+R\O'R
M\_+R\O+R\_+R\O+R\O'R\_+R\O+R\O+R\O'S\_/R\O'R\_+R\_+R\O'S\_+R
M\O+T\_1R<W1H:&AG9F=H:&EF9F=H:&AG9V5G9F=E9F:3DY7]_/___?K_____
M___________________________________\_/W^_?^CHZ5I9V=I:&AH:&6C
MHZ7____]_?W]_/W____\_?W____________\________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\^____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________^_O[_____/S]_?S[
M_OW__OW\M;2V:&=F9V=G9F9G:6EJ9F9G:&=G:&=G9VAI9V=H@8&#_____/__
M_/W]____^_O[_/_______?S]_____O[^^?S^_/_____]____N;:T9F9G:&AH
M:&AG9V=H9V=H9V=H:&AH:&=G9V=GV]G:]?/T\_3T\O'P]//Q\_3T\O/R\O+Q
M\O/R\O/R\O+R\O+Q\O+R\O/R\O+R\O+R\O+R\O+R\O/R\O/R\O+R\O+Q\O+Q
M\O+R\O+Q\O+R\O/R\O/R\O/R\O+R\O+R\O+R\O+Q\O+R\O/R\O+Q\_/R\O+R
M\O+R\O+R\O/R\O+R\O/R\O/R\_/R\O+R\O+R\O+Q\O+Q\O+R\O+Q\O+R\O/R
M\O+R\O+R\O/R\O/R\O/R\O+R\_/R\O+R\O+R\O+R\O+R\O+Q\O+Q\O/R\O+Q
M\O+R\O/R\O/R\O/R\O+R\O+Q\O/R\O+Q\O+R\O/R\O/R\O+R\O/R\O+R\O+Q
M\O+Q\O+Q\O+Q\O/R\O/R\O/R\O+Q\/'P\O+R\O+Q\O+R\_/SL;"S:&AF:&=G
M:&=H9V=G:&=H9V=G:&AG9VAH9F=GW]_@_____?W]______[]____________
M_____________________/__W]_B;FYO9F9G:&AF9V9F9V9HMK6X_?S]^OO[
M^OW]_OW__?OX_____OW_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
MO/__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________W]_?W]_?S\_?[^__W\_;6UMV=H:&=G
M9VAG:&=G:69F9V=F9FAH:&AG9V=G9V=F9V=H9K:UN/W]_?____W]_?____O[
M_/____O___S___[]__[^__K\_?___=33U7MZ?F=G:&=G9VAH9V=F:&AG:&AG
M:&AG:&=G9VAH9X>(B?+Q\_+R\O7T\O+Q\//T]?+S\O+S\O+S\O+S\O+R\?+S
M\O+S\O+R\O+S\O+R\?+R\O+S\O+R\O+R\O+S\O+R\?+R\?+S\O+R\O+R\O+S
M\O+R\O+S\O+R\O+R\?+S\O+R\?+R\?+R\O+R\O+R\O+R\?+S\O+S\O+R\O/S
M\O+S\O+S\O+R\O+R\O+R\O/S\O+S\O+R\O+R\O+R\O+R\O+R\?+R\O+R\?+S
M\O+S\O+R\O+R\?+R\O+S\O+R\O+S\O+S\O+R\O+R\?+R\?+R\O+R\?+S\O+R
M\O+R\?+R\?+R\?+R\?+S\O+R\?+R\O+R\?+S\O+R\?+S\O+S\O+R\O+S\O+R
M\O+R\?+S\O+S\O+S\O+S\O+S\O/T\^;DY&QM;V=G9VAG9VAG:&AH:&9F9F=G
M:&=G9V=G:)J9G?W\_/W]^_[^__W]_?______________________________
M______S__Y.2EF=F9FAH:&9F9FAG:6AG:&AG:-34U?[^_OS\__[]_/W]^___
M__W]_?[]____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________S[_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________]_?W____\_/W^_O_[^_S6U-5M;F]H9V9H9VAG:&AH:&EF9F=I
M:&AG9F9H9V=G9V=G9F9H:&AR<W7__OWY_/K]_?W______OW\^_W\___[_?S]
M_?O_______^LJZ]M;6]F9V=G9V=G9V=H9VAH9VAH9V=H9V=H9VAG9V=G9VAG
M9VC%Q,7R\_+Q\O+T\_3T\O+R\_+R\O'R\O'R\_+R\O'R\_+R\O'R\_+R\O'R
M\_+R\O+R\O+R\_+R\_+R\O'R\_+R\O'R\_+R\O+S\_+R\O+R\O+R\O'S\_+R
M\O+R\_+R\O'R\O'R\O'R\O+R\O+R\_+R\O+S\_+R\O'R\O+R\O'R\_+R\O+R
M\_+R\_+R\O+R\_+R\O'R\_+R\O'R\O+R\O+R\O'R\O+R\O'R\_+R\O+R\O'R
M\O'R\O'R\O'R\O'R\_+R\O'R\O'S\_+R\O'R\O+R\_+R\O+R\O+R\_+R\O+R
M\_+R\O'R\_+R\_+R\O'R\_+R\O+R\O'R\O+R\O+R\_+S\_+R\O'R\_+R\O'R
M\_+R\_+S]//O[^^?GJ!G9V=G9F=H:&AG:&AH9V=I:&AG9VAH:&AM;6WQ[>S_
M___\_______________________________________________5U-5F9V=I
M:&AG9VAF9V=G9VAG9V=H9V=L;6[Q[NW_______W___________W^_O______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________^]____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M^_O[_____O[_[N[M<G-V9V=G:6=H9F=G:&AH9V9F:&=G9F9F:&AI9F=G9V=H
M9V=H9V=E9VAHH:*E_/___OW__?S]___]_OW__OW___[]_O[^[NWP@(&&:&AG
M:&=G:&=G9V9F:&=G9VAH9V=G9V=G9V=G9V=H9V=G:&AH:&=HH:&A\?+R\O/T
M\_+T\_+Q\O+R\O+Q\O+Q\O+Q\O+R\O/R\O+Q\O+Q\O/R\O+Q\O+R\O/R\O+Q
M\O+R\O/R\O+Q\O/R\_/R\O+Q\O+R\O+R\O/R\O+R\O+R\O/R\O/R\O/R\O+R
M\O/R\O+Q\O+Q\O+Q\O+Q\O+R\O+R\O+R\O+Q\O+Q\O/R\O/R\O+Q\O+R\O+R
M\O/R\O+R\O+R\O+Q\O+R\O+R\O+Q\O/R\O+Q\O+R\O/R\O+R\O+Q\O+Q\O/R
M\O+R\O+R\O/R\O+Q\O+R\O+R\O+Q\O+Q\O+R\O+R\O+R\O+R\_/R\O+R\_/R
M\O/R\O/R\O/R\O+Q\O+R\O/R\O/R\O+R\O+R\O/R\_/R\O+R]/3S[^_OYN;G
M;&QM9V=H:&AG9V=H9V=G9V=H:&=G9V=H9F=G9V=GD)"4Z^SO^___________
M__[]________________________________@H&$9F=H9V=H:&=H:&AI:&=E
M:&=G9F=H:&AF>GI^_____O[____]_?W^_O[__/[^____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________/O__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________[]__O[_/S______XR+
MCFAG9V=G:&=G9V=G9V=F9VAG:&9F9F=G9V=G:&AG:&=G9VAG:&AH:6=H:&UM
M;>_O\/K\_/________K__________\"_P6UM;VAH:&=F9F=G9V=G9VAG9V=F
M:&=G9V=G9V=G:&=G:&AG:&=G96QL;JJJK?3R\?/R\_/T]/+S\_3S]/+R\?+R
M\O+R\O+R\O+S\O+S\O+R\O+R\O+S\O+R\O+R\O+S\O+R\O+S\O+S\O+S\O+R
M\O+R\?+R\?+R\O/S\O+S\O+R\?+R\O+R\?+R\?+S\O+R\O+R\?+S\O+R\?/S
M\O+R\O+R\O+R\O+R\O+R\O+S\O+S\O+S\O+S\O+R\?+R\?+R\O+R\O+S\O+S
M\O+S\O+S\O+S\O+S\O+R\O+S\O/S\O+R\O+S\O+S\O/S\O+S\O+R\?/S\O+S
M\O+S\O+S\O+S\O+S\O+S\O+S\O+S\O+R\O+R\O+S\O+R\?+R\O/S\O+R\O+R
M\O+S\O+R\O+R\?/S]//Q\/3T]?+S\O+R\O7U]O;S\I"0D6=G9V=G9V9G9VAH
M9V=G:&=G:&=G9V=G9V=G9VAG9VAG97-S=];5UO____W]_?[]__S_________
M__[^_O[]___]^O[^_\C)S&AH:&AG9V=G9VAH:&AG9VAG9VAG9V=G9VAG9VAG
M9YJ9G?_______________?[^____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_[[_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________^_?_\_OWZ_?Z_OL)F9V=H:&=G9V=H9V=G
M9V=H9V=G9F9G9VAH:&=G9VAH9V=G:&AH:&AG9V=H9V=G9VBCHZ;^_?_]_?[_
M_______LZ^R1D)5F9F9G9V=H9VAH9V=F9V=G9V=G9VAG:&AF9F9G9V=F9V=H
M:&EG9V=Y>7W:V-;R\?#T\O/R\_3R\O'R\O+T\_+R\_+R\O+R\O+R\_+R\O+R
M\O+R\O+R\O+R\O+R\O+R\O+R\O+R\O'R\_+R\O+R\O+S\_+R\_+R\_+R\O'R
M\O'R\O+R\_+R\_+R\O+R\O+R\_+R\O+R\_+S\_+R\_+R\_+R\O+R\_+R\_+R
M\O+R\O'R\_+R\O+R\_+R\O'R\O'R\O+R\O+R\_+R\O+R\O'R\O+R\_+R\O'R
M\O+R\_+R\O+R\O+R\_+R\O+R\O+R\_+R\_+R\O+R\O+R\O'R\O+R\O'R\_+R
M\_+R\_+R\_+R\O+R\O'R\_+R\O'R\_+R\O'R\O+R\_+R\O+R\O+R\O'R\O'R
M\?#T\O'Q\O+T]//S\_/R\?/S\O&`@H9G9V=H9VAG9VAF9V=G:&AG9V=G9F=H
M9V=G9VAG9V=H9VAH9VAG9V>DHZ;__________O________W^_?___?K[_?_]
M_/YZ>GMH9V=G9V=G9V=H9V=H9V=G9F9H:&AH9V=H9V=G9VAF9VG)R,C^_OW_
M_______]_?W_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________^^____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________^OW[[^_P;6UO:&=H9V=F9F=G:&=G9V=H9F=E9V=H:&AF
M9V=H9V=G9F9F:&=I9V=G9V9F:&=G9V9H9F9FX.#C_____?SXR<C*<W1V9F=E
M9V9F:&AH9V=G9V=G9V=H:&=H9V=E9VAH9V9G:&AH9V=E9F=HH:&D\O'P]?3U
M\O/T\?+S]/3S\?'Q]//R]//T\_/R\O/R\O+Q\O/R\O/R\O/R\O/R\O+R\_/R
M\O/R\O+R\O/R\O+R\O/R\O/R\O+Q\O+Q\O+Q\O+Q\_/R\O+Q\O+R\O+R\O/R
M\_/R\O+Q\O+Q\O/R\O+R\O+R\O+R\O+Q\O+R\O+R\O+Q\O+Q\O+Q\O/R\O+R
M\O/R\O/R\O/R\O/R\O+Q\O+Q\O+R\O+R\O/R\O/R\O/R\O+R\_/R\O/R\O+R
M\O+Q\O+R\O+Q\O+R\O/R\O/R\O+R\O/R\O+Q\O+R\O+R\_/R\O+R\O+Q\O+R
M\O+Q\_/R\O+R\O/R\O+R\O/R\O+R\O/R\O+R\O/R\O/R\_+Q]/+Q\O/T\?'P
M\O+R]//T]//R]?/NH:"C9VAH:&=F9V=G9F=G9V=H:&AF:&=H:&=G9V9H9V=G
M9V=G:&=G:&=G@H*%X.#A_____/__^O[________^_OW_M;6X:&=G:&=G:&AG
M:&AH:&AH9V=G9V=G:&AH:&=G9V9F:&AH9F9G=75U[NWN_?W]__[___[]____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________/?__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__[]_9&1E6AG9V=G9VAH:&=G9VAG:&=F:&=G:&=G969F9V=G:&9G9V=G9V=G
M:&=H9FAH:6AG:&AH9VAG9Y&1E?W[]YJ:G6=G:&EH:6=F9FEH:&=G:&=G9VAH
M:&=G9F=G96=G:6=F9VAH:&=G9WEY>M#.S_'R\/3T\_'R\_'Q\O3T\_+R\?/T
M\_/R\?/R]/+S\O+R\?+R\O+R\O+S\O+R\?+S\O+R\O+S\O+R\O+R\O+S\O+R
M\O+S\O+R\O+S\O+R\O+R\O+R\O+R\O+R\O+R\?+S\O+R\O+R\?+S\O+R\O+R
M\?+R\O+R\O+R\O+R\O+R\?+R\O+R\O+R\O/S\O+R\O+S\O+S\O+R\O+S\O+R
M\O+R\O+R\O+R\O+R\O+R\O+S\O/S\O+S\O+R\O+R\O+R\?+S\O+R\O+S\O+R
M\O+S\O+S\O+R\O+S\O+R\?+R\?+R\O+R\?+R\?+R\O+R\O+S\O+S\O+R\O+R
M\?+S\O+R\O+R\?+R\?+R\?+S\O+S\O3T\_'R\_/R]//R\?3S\O/S\_+S]/+R
M\?3S\M#.SG)R=&AH:&AH:&AG:&=G:6AG9FAG96=F9F9G9V=G9VAH:&AG9V9G
M9VQL;L"_P?____[]_?_^_?____S[_W)S=&EG:&AG9VAH9VAH:&=G9V=G9V=G
M9V=G9VAG9VAH:&=G9VAG9VEH9J&AI?____S______?__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________SW_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________\___)R,MG9VAH9V=H
M:&AG9F=G9VAG9VAF9F9G9F9G:&B`@82\NKMG9V=H9VAG9VAG9V=G9FAG9VAG
M9V9H9VAG9V=Y>GYH9VEH:&9G9VAG9VAH9V=H9V=H:&EH9V=H9V=H9V=H9V=G
M9F=G9VB7EYGEY.7T\O'S]/3O[^_U\_+S\O'R\?#R\?#T\_+R\_3R\_3R\O'R
M\_+R\O+R\O+R\_+S\_+R\O+R\O'R\O'R\O+S\_+R\_+R\O+R\_+R\_+R\O+R
M\O+R\O'R\_+R\O+R\O'R\O+R\O+R\O'R\O'R\O+R\_+R\O+R\O+R\O'R\_+R
M\O'R\O+R\O+R\_+R\O+R\O+R\O'R\O'R\_+R\O+R\_+R\_+R\O+R\_+R\O'R
M\O'R\O+R\O+R\O+R\O'R\_+R\O+R\O+R\_+R\O'R\_+R\O+R\_+R\_+R\_+R
M\O+R\O'R\_+R\O+R\_+R\O'S\_+R\O'R\O+R\O+R\O'R\O'R\O'R\O+R\O+R
M\O'R\O'R\O+R\O'R\O'T]?7S\O/T\O'U]//R\O'R\_3R\_3S]/3O\/'FYN:/
MCY)G9VAG9VAH9V=F9F9G9VAI:&AG9V=F9V=G9V5G9V=G9VAH9V=F:&B)BHWO
M[>_]_?W[_/^EI:=G9V=I:&AG9V=G9V=G9V=G9V9H9V=H9V=I:&AH9V=G9V=G
M9F=I:&=G9F=G9V?AX>3Y_/W^_O__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__\]________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________[_@H*#:&=G9VAH9V=G9V9H9V9H9F=G
M9V=H:&=G;6UNY.3F\_+Q@8"#:&=G9V=H:&AH:&=G9V=H:&AH9V=H:&AH9V=F
M:&=G9V=H9F=G9VAH9V=H9F9F9V=H9V9G:&=G9V=G:6AH;6UNQ,/$\O/T\_7T
M\O/S\_+S\_+Q\O'P]//T]?/T]?/T\O'R\O/T\O/R\O/R\O/R\O+Q\O+R\O+Q
M\O+Q\O+Q\O/R\O/R\O+Q\O+R\O+Q\O+R\O+R\O/R\O/R\O+R\O+R\O+Q\O/R
M\O+R\O+Q\O+R\O/R\O+R\O+R\O+Q\O+Q\O/R\O+Q\O/R\O+R\O+Q\O/R\_/R
M\O+R\O/R\O/R\O/R\O+Q\O+Q\O+R\O+R\O+R\O+Q\O+R\O/R\_/R\O+R\O/R
M\O/R\O+Q\_/R\O+Q\O+Q\O+Q\O+Q\O+R\O+R\O+R\O+Q\O/R\O+R\O+R\O+Q
M\O+R\O/R\O+R\O+R\O+R\O+R\O/R\O/R\O+R\O+Q\O/R\O+R\O+R\O/R\O+R
M\O+R\O/T\_'P]//R]//T\_/R\O/R\/'R\O+S]/7U\/'P\_+QO+N];&QM:&=G
M9F=G9FAH9V=H:6AH:&=H9V=H9VAH9V=G9F9H9V=H9V=G='1UR,G,[NWL;6YN
M:&AG9V=G:&=G:&=G:&=G:&=G9V=G9V9F:&AG:&=G9V=G:&AI9V=G:&=H:&=G
MCY"3_____O[_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________/O__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________\K)RV=H:&=F96=H:6=G9F=G:6=G9V=G9VAH:&9G9[R[O/'R
M]/#Q]<?&Q&=G:&=F9FAG:&9G9V=G9V=F9F=F9VAH:6=G96AH:&AG9F=G:&AH
M:6=F9FAG:&AG:6AH:&=G9F=G:8:&B>CFY?+S\O+R\?+S]/3T\_3R\?/R]/+Q
M\O7T]?+Q\O/R\_/R\_3S\O3S\O+R\O+R\O+S\O+S\O+R\?+S\O+R\O+R\?+S
M\O+S\O+R\O+R\?+R\?+R\O+R\O+R\?/S\O+S\O+S\O+R\O+R\?+S\O+R\?+R
M\?+R\O+R\?+R\?+R\O+S\O+R\?+R\?+R\?+R\O+R\?+R\?+S\O+R\O+R\O+S
M\O+S\O+S\O+R\O+R\?/S\O+R\?/S\O+R\O+R\O+R\?+R\O+R\?+S\O+S\O+R
M\O+R\O+R\O/S\O/S\O+R\O+R\O+R\O+R\O+R\O+R\O+R\O+R\?+R\O+R\?+R
M\O+S\O+R\?+R\?+R\?+R\?+R\O+R\?+R\O+S\O+R\?+S\O/R\_/R]/+S\O/S
M\O#Q\O/R\_+Q\/+Q\_;T\_'Q\?'R\O+R\O+Q\-O9VH&"A&=G:&=G9F=H:&=F
M:&AG:&AH:&=G:&9F9V=G9V=G9V=G:&AG9V9G:(*#A6=G96=F9V=G:&=G9VAG
M9VAG9V=G9VAG9VAH:&AG9VAG9V=G9VAG9VAG:6AG9V=F9V=G9^#>WO______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________[W_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________^"
M@H5G9VAG9V5G9F9G9VEF9V5H:&EG9V=G9F>!@8/S\?'R\O'R\O'S\O&)B8MH
M9VAH9V=G:&AH9V5I:&AG9VAG9VAH9VAF9F=H9VAH:&AF9F9H9VEG9F9H:&9H
M9V=L;6ZQL+3T\_+Q\/'T\_3S\O3S\O'T]//Q\_+R\O'T]//P\?#T]//T\O+Q
M\._U]/7U]/7R\O'R\O+R\O+R\O'R\_+S\_+R\_+R\_+R\O+S\_+R\O'R\O+S
M\_+R\_+R\O+R\O+R\_+R\O+R\_+R\_+R\O+R\O'R\O+R\O+R\O+R\O+R\O+R
M\O+R\_+R\_+R\_+R\_+R\O+R\_+R\_+R\O+R\_+R\O+R\O'R\O'R\O+R\O+R
M\O'R\O+R\O+R\_+R\O+R\_+R\O'R\_+R\_+R\_+R\O+R\_+R\O+R\_+R\O+R
M\_+R\O+R\O+R\_+R\O+R\O+R\_+R\O+R\O+R\O'R\O'R\_+R\O'R\_+R\O+R
M\O'R\_+R\O+R\O+S\_+R\O'R\O'R\O+S\O/S\O/R\O+R\O'S]/;R\?+U\_'T
M\_+R\_+T\O'T\_+T\_3R\_3S\_+U\_&?GZ-H9VAH9V=F9V5G9V=F9V=I:&EH
M9V=G9V=G9VAG9V=H9V=G9F=H9V5G9F=H:&9G9VEH9V=G9V=H9V=G9F9H9V=M
M;&QH9V=G9V9G9F=G9V=H9V=H9V=G9V=G9VB1D9/[_?[_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________^]________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________OW\_OW_______[]_OW__/___/[]X=_?9V=F:&=H:&=G9V=G
M9V=G:&=G:&=H9V=E9V=HVMG:\O+R\_+Q]/+Q\O/RV]G:9V=H:6AH9V=H:&=H
M:&=H9V=G9F=G:&AH:6AG9V=G:&=G9V=G9V=G9F9G9VAH?W^"V]G8\O+R\O+R
M\O+R\O/R\O/R\O/R\O/R\O+R\O+R\O+R\O+Q\O+Q\O+Q\O+R\O+R\O+R\O+R
M\O+Q\O/R\O+Q\O+Q\O+Q\O+R\O/R\O/R\O/R]//R\_+T]//R]//R\_+Q]//R
M]//T\_+S\_+S\_'P]//R]O3S]//R\?#O\O/S\O/T]/7U\O/T\O+Q\O+Q\_/R
M\O/R]//R]?3R]//R]//R]?3S\_+Q\_+Q]/+Q\_3S\O/R\O+R\O/R\O/S\_3T
M]/7U\O/T]//T\_+T\_+T]//T]?/T]//T\_+T\_+T\_3T\O/T\O+R\_/R\_/R
M\O+R\_/R\O+Q\O/R\O+Q\O+Q\O/R\O+R\/'P\O+Q\O/R\O/R\O+R\O/R\O+R
M\O+R\O+R\O/R\O/R\O+Q\O+Q\O+R\O/R\O+Q\O/R\O+R\O+R\O/R\O+R\O/R
M\O/R\O+R\O+Q\O/R\O+QS\[.<W1W9F9F:&AH9F9F9VAH9V=G9V9G:&=H:&=G
M:&=G9V=G:&AG:&=H9V=H9V=H9F=G:&AH9V=G:&9G<G-VQ,7%9F9H9V=G:&=G
M:&=E9V=H:&AH9V=G:&=G9F=H[NWN_________?W]_________________O[_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____/O______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________^_?W\_O_______YF9GF=G9VAG9V=G9V9F9VAH:&=G9V=F:&AG
M9Y>7F_3S\O+S\O3S]//R\_+R\O3S\I>7FVAG96AG:&=G:&=G9VAH:&9F9F=G
M9F=G:&=G:&9G9V=F9VAG9V9F9ZJIJ_7S\O3S\O+R\?+S\O+R\O+S\O+R\?+S
M\O+S\O+R\?+S\O+S\O+R\O+S\O/S\O+R\?+R\?+R\O+R\O+R\O+R\O+R\O+S
M\O+S\O+R\?+S\O+R\?/S\O/R\?7T]?3S]//R]/7S]//R\_/R\_+Q\O/R\_3S
M]/3S]/3S]//R]/7T]?3S\O3R\?3S\O3S\O3S\O/R]/7T]?/S]//R\_3S]//R
M\_7T]?/R]//R\_+Q\_/R\_7T]?/R]/+Q\O7T]?3S\O/R\?3S\O3S\O/S\O+R
M\O+R\O+S\O+S\O+S]/+S\_+S]/3S\O/R\?7T\_+Q\/7T\O3S\O+Q\/3S\O+S
M\O+R\O+S\O+R\O/S\_/S\O'R\?+S\O+S\O+S\O+R\O+S\O+R\?+S\O+S\O+R
M\O+R\?+R\?+R\O+S\O+S\O+S\O+S\O+S\O+S\O+R\O+S\O+S\O+R\?+R\?+R
M\?+R\?3R\>7EY)"/DF=G9FAG:&AG:6=G:&=G9FAH:&9F9V=G:&=G:&AH:&AH
M9FAH:&=F9VAG:&=G9V=F:&AH:,3#P_3S\(>'BF=H:&9G9VAG9VAG:&AG9VAG
M9VAG9V=H:*RLK_____S]_?____W]_?________W]_?__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________[[_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________\_/W____]_?[^
M_?_]_/O^_O]L;6]G9VAH9V5H9VAH:&EG9V=G9F9G9VAF9FCFY.3R\_3R\O'R
M\_3R\_3R\O+R\_3GY.1L;&MH:&EG9VAF9V=G:&AG:&AG9VAH:&AG9V=F9F=H
M9V=Y>'K/S<_R\?+R\O+S]/;R\O'R\O+R\O+R\O+R\O'R\O+R\_+R\O+R\O+R
M\_+R\_+R\_+R\_+R\_+R\_+R\O+R\O+R\_+R\O+R\O'R\O'R\O+R\O+S\_+T
M\_+T\_+R\O'Q\O'R\O'Q\O/R\_3S]/3R\O#Q\>_S]//R\_+R\O+R\_/T]/7R
M\_3R\_3R\_3S]/7P\?+R\_3S]/3R\_3S]/7R\O+R\O+R\_+R\O+Q\?'R\O'R
M\O+R\O'R\_3T]?7T]?7S]/7Q\O/S]//R\_+R\O+R\_+R\O+R\_+R\_+R\O'R
M\O'P\/#S]//Q\?#S]//P\?#U]?3R\_+T\_+S\O'T\_+R\O+R\O+R\O'R\O'P
M\?#R\_+S\_+R\_+R\O+R\O+R\O+R\O'R\O+R\O'R\O'R\O'R\O+R\_+R\O'R
M\O+R\O'S\_+R\O+R\_+R\O+R\O+R\O'R\_+R\O+R\_+R\O+S\_+R\_/Q\O/T
M\O&[NKUL;&UH:&AG9V=G9VAG9VAH:&EG9VAG9VAF9F=H9VAG9V=G9F9G9V=F
M9F=H9VB`@('T\_+S\O3<V]EF9F=G9VAH:&AG9V=G9V=H9V=H9V=G9F9T<W?_
M__W^_O[________\_?W_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\^________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________?W]___________________^O[_#9V=G
M9F=G:&AF9V9F9VAH9V=G:&=G9V=GCX^3\O'R\_/T\O+P]?3U]?3U\_/Q\O/T
M\O'RH)^C9F9G9V=E9V=G9V=F:&=H:&=I9F9F9V=G9V=GF)B<]?3U\_/R]/3S
M\O/T\_+S\O+R\O/R\O+R\O/R\O/R\O+Q\O/R\O+Q\O+R\O+R\_/R\O+R\O+Q
M\O/R\O/R\O/R\O/R\O+Q\O/R\O+R\O/R\O/R\O/R\O+R]//T\_+S]/3S\O/R
M\O/R\O/R\O+Q\/#P\?+R\_3U\_3T\O/T\O/S\_/R]/3S\O+Q]?3U\_+T\_+S
M]?3R]O3S]//R\_+Q]//R]?/T\O'R]//T]//T\_/T\_+S\_+T]//T]//R]/+R
M\_+Q\O'P]O3S]//T\_+T\_+S]?3S]//T]?3U\_+T\_+S\O/T]?;V\_3T\O/T
M\O/T\O/T\/'R\O/T\O/T\?+S\O/T\O+R\O+Q\/'P]/3S]/3S\O+Q\O/R\?'Q
M\O+R\O+Q\O+Q\O+R\O+R\O+R\O+R\O/R\O/R\O+R\_/R\O+R\O+Q\O/R\O+R
M\_/R\O+R\O/R\O/R\O+Q\O+Q\O+Q\O+Q\O+Q\O+T]?7T\O/T\/'PVMG;@("#
M9V=G:&=G9V=H9F9F9V=G9V=G:&=H9V=H9V=H9V=G:&AF:&=I9F=GQ<7&\_/T
M\O'S\/'R@8*$9V=G9V=H9V=G:&AH9V=H9V=G:&=G9V=GU-34_____?W]^OO[
M_____?S[____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________OO______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________O[_/_________^_?S\_9J:G6AH9F=F9VAG9VAG9V9F
M9FAG:&=G9F9H9]#.S_+R\?#Q\O3R\O3S\O3S\O3S\O#Q\O+S\N7EY7)S<VAG
M:&=G:&AH:&=G:&=G9V=G9W1T=L7$Q?+Q\?'Q\?+S\O+S\O3S\O/R]//S\O+S
M\O+S\O+S\O+R\?+S\O+R\O+R\O+R\O+R\O+R\O+S\O+R\O+S\O+R\?+S\O+S
M\O+S\O+S\O+R\O+R\O/S\O+S\O+S\O3S]/3S]/'R\_3T]?'Q\?3T\_+R\O/S
M\O7T\_+Q\/+Q\O7T]?7S]/'P\O+Q\O/R\_+R\O+R\O+R\O#Q\/#Q\/+S]/#Q
M\O+S]/'R\_3T]?'R\_/S]/+S]//T]/'R\_+S]/+R\O+R\O+S\O3U]?'R\_+S
M]/+S]/+S]//R\_+Q\O7T]?/T]/'Q\/+S\O+S\O+R\?3S\O3R\O3S\O7T\_3S
M\O+Q\/3S\?/R\?+R\O/S\O3T\_+R\?/S\O#Q\//T\_3T\_+S\O+R\O+R\O+S
M\O+R\O+R\?+R\O+R\O+R\O+R\O+S\O+R\?+S\O+R\O+S\O+R\?+S\O+R\?+S
M\O+S\O+R\?+R\O+S\O+R\?3S]/3S]//S\?3U]?+S\_/R\Z"?H&=G:&AG9VAH
M:&AG9V=G9VAH:&AG9VAG:&=G:&AG9V=G:(^0D?/R\_/R]/+S]/#Q\KJZNVAH
M:&AH:&AG:&=H:&AH:&=G9VAG9V=H:*RLKO____?Z^_____S]_?___?W]_?__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____SW_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________________________\
M_/W\___________^_?S^_?UR<W1H9V=H9V=G9V=H:&AG9V=H:&EG9VAX>7KT
M\_+R\O+R\?/T\_3T\_+T\_+T\_3R\?/R\O+U\_&RLK-G9VAG9F=G9VAH:&9G
M9VB(B(KEY.7T\_+T]?7R\_3T\_3S\O/S\O'R\O+R\_+R\O+R\O+R\O'R\O+R
M\_+R\O+R\O+R\O+R\O+R\O'R\_+R\_+R\O'R\_+R\_+S\_+R\_+R\O+R\O'R
M\O+R\_+S\_+R\O'P\?#R\O'T\_3S\O/T\_3R\?/U]/7S\_3R\_+R\_+S]//R
M\O+O[^_T]?7S]/3T]?7S]/3T]?7S\O'V]//S\O'T\O'T\_+T\_+T\_#$Q<C"
MP\;$Q<C$Q<?#P\;$Q<C$Q<C$Q,7$Q,?#P\;&QLGEY.3R\?#U\_+T\O'U]/+V
M]//T\_+S\O3U]/7T\_3T\O/T\_3S\O'T\O'R\O'R\_3Q\O+T]?7R\_3R\_3S
M\_+Q\?'R\O'R\O+R\_+R\O'S\_+S\_+S\_+R\O+R\O'R\_+R\O'R\O+R\_+R
M\O+R\_+R\_+R\O+R\_+R\_+R\O+R\_+R\_+R\_+R\_+R\O+R\O+R\O+R\_+R
M\O'R\O+R\O+S\O'U]/7R\?+S\_+Q\?#Q\/+0SLYS<W5F9F=F9V=I:&9G9V=H
M9V=G9V=F9V=G9VAF9F;9V=GT\_3T\_3O\?#T\_+U\_%M;6YG9V=H9VEG:&AF
M9F9G9V=G9V=G:&B!@83\^_O\___]_?W______OW_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________\^________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________/___/S]____
M____X.#A:&AI9V9G9V=G:&=G:&=G9V=H9V=G9F=GH:&C\/'R\O+R]?3U\O'S
M]/+R]//R\O'R]?/T\O/R\O/S\_+T<7)T:&AF9V=F;&UNN[J\]O/Q]/7U\/'P
M\O/T]//U]?3U\O'O\O+Q\O/T\O/R\O/R\O+R\O+R\O/R\O+Q\O+Q\O+Q\O+R
M\O/R\O+R\O+R\O/R\O+R\O+Q\O+R\O+R\O/R\O/R\O+Q\O+Q\O+R\O/R\O+Q
M]/3S\O/R\O'R\_/T]?3R]//R\O'P]?/Q\_+T\>_N]//RV=G9QL;'N[J\GZ"B
MH*"BDI"2@'^"@H&">7AZ9F9H:&=H:&=H9V=H9V=G:&=G:&=G:6AH9F9F:&AH
M9V9F9V=G9V9F:6AH:&=G:&AH:&=G:&=G:&=G:&=H9F=H>7IZ@H*#@H*$AX>*
MH)^BH*"DL;&SQ,/%SLW/\_+O]?3S\_+Q\O'R\_3T]/7W\/'P\_/R\?'Q\O+Q
M\O/R\O/R\O+R]/3S\O+R\O/R\O/R\O+R\O+R\O+R\O/R\O+R\O+R\O+R\O+Q
M\O+R\O+Q\O/R\O+Q\O+R\O/R\O+R\O+R\O/R\O+R\O+R\O+R\O+Q\O/R\O/T
M\?#O\_+T\?#R]?3U\O/R\?+TYN/AF)F<9F=H9V=G:&=H:&AI9F9F:&AF9F=G
MF)B:\_+T]/+R\O+Q\O/T]//R\O+RCX^19VAH:&=G9V9G9V=G9V=H:&=G9V=H
M9F=G__[]_/___?W]_OW__?S[____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________/O______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________K]_O____[]__S\_;Z_P&9G9V=F
M:&=G9VAH9FAG9VAG:6=G96=H:,_.S_+S]/+R\?/Q\?3S\O+R\O+R\O3S\O+Q
M\/+S\O'R]//R\<?%Q6=G:(*"@^;CX_'Q\/'S]?+R\O3S]/3S\O/R[_+R\?3T
M\_+S]/3S]/+R\O+R\O+R\O+R\O+S\O+R\O+S\O+R\O/S\O+R\O+R\O+R\?+S
M\O+R\?+S\O+R\O+R\?+R\O/S\O+S\O+R\?+R\?+R\?+S\O+S\_/T]?/R\_3R
M\=G9VL7%QJ&AI)>7FX&`@71T=6=G:&=H:6=G:&AG9VAG9VAG9V=H:&=H:&=G
M9V=G9V=G9VAG9VAG9VAG9V=G9VAH:&=G9V=G9V=H:&=G9V=G9V=H:&AG:&AG
M:&AG:&=G:&EH:6AG:&=F:&AG:&=G9V=G9VAG9VAH:&=G9FAH:&=G9VAG9V=G
M9V=G9V9G:&QL;H&!A)"0DJ&@H[NYNLW/TO'Q\/3T\_3T\_#Q\?+R\?+S\O+R
M\O+S\O+R\O+R\O+R\O+S\O+R\?+R\O+R\O+S\O+R\?+R\?+R\?+R\O+S\O+R
M\?+S\O+R\?+R\?+S\O/S\O/S\O+S\O+S\O+S\O/R]/+R\?3T\_#Q\//R\_/R
M\?+Q\O+R\O+S]?/Q\;V\O&QL;6AG:&=F9F=H:&=G9VYM;>7EY?/R\?7S\O+R
M\O7T]?'R\O+R\;NZO6=G9VAG9V=G9V=H:&=G:&AG96AG9VAG9\G(R_O^_?__
M__W\_?S^_OK]_?______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________S[_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________O_____\__^CHJ1G9VAG9V=H9VAG9V=G9V=G
M9V=G9FAF9VGT\O'S\O/R\O'R\_+R\O+R\O+R\O+R\O'R\O+R\O+T]?7Q\O+R
M\_*XNK_R\O'R\O+R\_3S]/3R\O+R\O+R\_+S\_+R\O'R\_+R\O+R\O+R\O+S
M]/3T\_3T\_+T\O+T\_+S\O/S\O/R\_3R\_+T]//P\?#R\_3R\O'T\_+S\O'T
M\_3R\_3R\_3R\_/S]//T\_+T\O'.SM&JJ:N7EYF!@(-F9FAH9VAI:&AH:&AH
M9V=G9V=G9V=H:&AG9V=G9V=G9V=G9V=H9V=G9V=G9V=G9V=F9V=G9V=F9V=F
M9V=H:&=G9V=G9V=H9V=H9V=H9V=G9V=G9V=H9V=H9V=F9F9G9V=G9V=H9V=G
M9V=H:&AH:&AG9V=G9VAG9V=F9V=G9V=F9V=G9V=G9V=G9V=G9V=G9V=F9F9G
M:&AG9V=G9V=F9F9G9V=F9V=Y>7N/CY*IJ:S#Q,?S\?#T]/7T\_3U]/7R\O+R
M\O'U\_+T\O'S\O/U]/7S]/3R\_+R\_+R\O+R\_+R\_/R\O/Q\?+T\O+V]//T
M\_+V]//R\?/T\O/T\_3T\_+R\_+R\O+R\O'R\O+R\_+R\_+R\O+R\_+S\_'T
M]?7S\O3DY..`@8-G9V9H9V5H9FB>H:?Q\>_R\_+S]/3T]?7R\_3T]//R\O+F
MY>9E9F=H9VAG9FAH9V=H9VAG9F=G9VAF9F>MK*[________________^_?W_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______^\____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________/O]_____O[^DY*6969F:&AH9V9G:&=G9V=G9VAH:&AI@("!]//R
M\_+S\O+R\O/R\O+R\O+Q\O/R\O/R\O+R\O+R\O/T\O+R\?'P\O+R\O+R\O+R
M\_/R\O/T\O+R\O+Q\O/R\O+R\O+Q\O+R\O/R\O/R]//R]?3R\/#P\O+R\O/T
M\_+S\O'R]//R\O'P\O'Q\O/T\_3U\/'R\O/T\O/T\O/U\/+S\O/TY^;ENKFZ
MF)B:@H&"9VAH:&=G9F=H9V=H9F9G9V=G:&=G:&=G:&=H9V9G:&AH:&=G9V=G
M9V=G9V=G:&=G:&=G:&=G:&=G:&=G9V=G:&=G:&AH:&=G:&=G:&=G:&=G:&=G
M:&AH9V=G:&=G:&=G9V=G9V=G9V=G:&=G:&AG:&=G:&=G9V=G:&=G9V=G:&=G
M9V=G:&=G:&=G9V=G:&=G:&AH:6AH:&=G9V=G:&=G9V=G9V=G:&=G9V=G:&=G
M9V9H9V=H:&=H:&=H9F=G9V=H9V=H>GIZCY"4L;&SVMC9]O3S[_#Q]/7U[^_O
M\O+R]//R]/+Q\_+S]?3T]/3U\O/R\_3S\/#P]//R\O/T\O/T\_3T\O+Q\O+R
M]/3S\O/S\O+R\O+Q\O/R\O/R\O+Q\O+Q\O/R\O+Q]//R\O+R]//T]//T]//Q
MJJFL9FAK<G)S\?+P\O+Q\/'P\_3T\O/T\O/T]/3S\?'Q\_'Q>7E[9V=H9V=H
M:&=G:&=H:&=H9V=G:&AIHZ*C____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________/?______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________S\_?________S]
M_?___X&!A&=H:&=G9V=G9V=G9V=G9V9G9V=G:)B7F?3S\O7S]/+R\O+R\O+S
M\O+R\O+R\O+R\O+S\O+R\?/T\_+R\O+R\O+R\?/S\O'Q\?+S\O'Q\/+S\O+S
M\O+R\O+S\O+S\O+R\O+R\?+R\?3S]/3S]/3S]/7S]/7T]?3R\O+S\O/S\_+Q
M\O7T\_3S\O'P[_/R\?3S\N;EY;NZO)B7EWIZ?&9G:&=G:&AH:6=G:&AG9VAH
M:&=G9VAG9VAH:&=G9FAH:&AG9V=F9VAG:&=G9VAG9V=F9FEH:&9F9F=G9V9F
M9F9G9V=G9V=H:&=G9V=G9V=G9V=G9V=H:&=G9VAH:&YN;G)R<G)R<W-S<W)R
M<G-S<W)R<G-S<W)R<G-S<VYN;FAH:&9F9F=G9V=G9V=H:&AH:&=H:&=G9VAH
M:&=G9V=G9V=G9V=G9V=G9V=G9VAH:&EH:&AH:&=F9FAG9VAH9VAG9VAG9V=F
M9FAH:&=F9FAG9V=G9FAG9F=F9FAH:7)S=)"0D[&PL^?FY_/S]//R]/+R\_7T
M\O+R\O+R\O/T]?3R\O3S\O/T]?+S]/+R\O+S\O'Q\/+R\O'Q\O+S]/+S\O+S
M\O+S\O+R\?+S\O+R\O+R\O+S\O3S]?+Q\_'Q\/+S]/+Q\O/R],_/SL7%Q/+R
M\O'Q\//S\O'R\_/T]?+S]/+R\?/T\_'P\HB(BFAG:&AG:&AG9V=F9VAG:&=G
M9V=G:(*#AOW]_?______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________SS_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________[^_O___________^"@81G9VAF
M9V=G9V=G9V=G9VAG9V=H9VB@H:/R\O+T\_3R\O+R\O'R\O'R\O+R\O'S\_+R
M\O'R\O+R\_+R\O+R\_3R\_/Q\O/R\_3R\_+R\O'R\O+R\O+R\O+R\O+R\O+R
M\_+R\O+R\O'R\_3S]/7T\O+S\O'R\?#U]//R\O+R\O'R\O+R\O'S\O/;V=JJ
MJ:R&AXEG:&AG9V=H9VAG9V9H:&AH9V=H:&AG9V=G9V=F9V=H9VAH9V=G9F9H
M:&AH:&AG9V=H:&AH9V=F9F=H:&AG9V=G9V=R<G)R<G-]?7U^?WZ`@8",C(N.
MCHV-C8V8F):>GIR=G)N=G9N;FYJ=G9N<G)N<G)N=G9N>G9R<G)N=G9N=G)N=
MG9N<G)N=G9N<G)J<G)N=G9N<G)N<G)N-C8R-CHV-C8R`@8!_@']^?W]Q<G)R
M<G)H:&AG9V=H:&AF9F9F9F=G9V=G9V=G9V=G9V=H:&=F9V=G9V=H:&AF9V=F
M9F=G9F=H9VAH:&AG9V=H:&AG9V=G9VAZ>7J>GZ#/S\[T\_'T\_3R\?+T\_+T
M\_+R\?+R\O+R\O+R\?#T\_+T\_+R\?#T\_3S\O/R\_+R\_+R\O'R\O+S\_+R
M\_+R\O+S\_+S\_3R\?+R\_+Q\>_S\_+Q\O/R\_3R\_3R\_3R\_3Q\O/R\O'S
M\_+T]//Q\O/R\_/U]/6?GZ!G9VAG9VAG9V=G9V=H9VAG9V=G9V>"@H3]_?W_
M_______\_______^_O[_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________^\____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________/S]________________9V=I:&=H9V=G9V=G9V=G9V9G
M9V=H9V=HL;&S\O/R]?3U\O+R\_/R\O/R\O+Q\O/R\O+Q\O/R\O+R]/3S\O+Q
M\/+R\O/T\_3T\O/T\O+R\O+R\O+R\O+Q\O/R\O+Q\O+R\O+R\O+R\O+R\_3S
M\?'Q\_3U\_3T\_3T\O'R]//R]//RV]G:J:FL>'I]9F=H9V=G:&=G:&=G9V=G
M:&AI9V=H:6AH:&=G:&=G:&=G9V9F:&AI9V=H9V=H9V=H9V=H9V=H<'!P=75U
M@']_BHN*C(R+G9V;GIZ<G9V;G9V;G9V;G9V;G)R;G)V;G)R;G)V;G)V;G)V;
MG9V<G)V;G)R;G)V;G)R;G)V;G)R;FYR:G)R;G9Z<G)V;G)V;G)R;GIZ=G)V;
MG)R;G)V;G)R;G9V<G)R;G)V;FYN:G)R;G)V;G)V;FYR:G)R;G9V;GIZ<C(R+
MC8Z-?G]_>7EY<G)S9V=H:&=H:&=G9V=G:&=G9V=G:&=G9V=G:&AH9F9G9V=H
M:&=H9V9H9V=G:&=G9V=E9V=H9VAH<W-UEY>;T,_/\_'P\?+R\O+R\_3U\?+S
M\_/R\O/R\._Q]?3V\_+S]//R\O/R\O+Q\O+R\O/R\O/R\O+Q\O+R\O+R\O+R
M\_3S\O'P]O3S\O'P\/'P\O/S]/7U]/7U\O/T]/7U\O+Q\_/R\O+Q\_3T\O/T
M\_+SH)^B:&AH9V9F9VAH:&=G:&=H9V=G:&=G@8&$_________O[^_/______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________O?__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________W]_6AH:6=F9VAG9V=G9VAG9VAG:&AG9V9F9\?&Q_+R
M\?3S]/+R\O+S\O+R\O+R\O+S\O+R\O+S\O+R\?+S\O#Q\O3T]?'R\_'R\_3U
M]?/T]//S\_+R\?+R\O/S\O+R\O+R\?+R\?+R\?+S\O/S]O7T]?'Q[_#Q\/#Q
M\NCGZ+&PLGIY?&=G9V=G9V=H:&9F9VAH:&AG9V=G:&AG:6=G:&=G9V=G9V=G
M9V=G9VAG9V=G9V=G9W%S<GY_?XF*B9"0CYZ>G)J;F9Z>G9R<FYN:F9R<FYV>
MG)J;FIV=G)R<FYR<FYR=FYR=FYV=G)R<FYN<FIV=G)R=FYR=FYR<FYV=FYV=
MG)V=G)R<FYN;FIR<FYR=FYR<FYR=FYR=FYR<FYV=FYR=FYR<FYR=FYV=G)R<
MFYV=G)R=FYR<FYV=G)V>G)R<FYV=G)V=G)R<FYR<FYR<FYR<FYZ>G)R<FIV=
MFYR<FI65E(J+BG]_?W-S=&IK:V=F9VAG:&=H:&=H:&=G9VAG9VAG9VEH:&5E
M9FEH:6=G9FAH:&=G9V9F9V=G:')S=I^?H]O9VO+S\O+S\O+R\O'Q\O+S]/'R
M\_3T\_+R\O/S\O+R\?+R\?+R\?+S\O+S\O+R\O+S\O#Q\/+S\O3S\?3S]/3S
M]/7T]?3S]/3S\O+S]/+S]/+S\_/T\_+R\?'Q\?/T]?+S]/3S]*&@HV9F9FEH
M:&=G:&AG9V=G9V=G9VAG9X*"A?____W]_OS\_?S___[^_O______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________[W_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________[^_S_________
M_____O]G9V=H9VEG9V=G9V=H9V=H9VAG9V=G9V?"P</T]//S\O/S\_+R\_+R
M\_+R\_+R\O'R\_+R\O+R\_+R\_3R\_3S\_3Q\O/S]/7R\_3S]/3R\_3R\O'R
M\O'R\_+R\O'R\O+R\_+R\O'R\O'T\_+S\O/S\O'$P\6/CY)F9VAF9V=H9VAG
M9VAH:&EG9V9G9V=G9F=F9F=G:&AF9F9H9V9G9V5F9V=L;&QX>7F&AH>1D9&<
MFYN;FYJ<G9N<G9N=G9R;FYJ=G9R<G9N<G)R<G9N>GIV:FIF>GIV;FYJ=G9N<
MG)N<G9N=G9N:FIF<G9N>GIR<G9N<G9N<G9N<G9N<G9N<G)J:FYF<G9N=G9R<
MG9N<G)N<G9N;FYJ<G)N<G)N<G)N=GIR<G)N<G9N<G)N<G9N<G9N=GIR=GIR<
MG9N<G)N<G)N<G9N<G)N<G)N<G9N;FYJ;FYJ=G9R<G9N<G9N=GIR;G)J<G9N=
MG9R;G)J=G9R5E92%AH5[>WMO;W!F9V=H:&AG9V=G9V=I:&AH9V=H:&EF9F=H
M9V=I:&AF9F9H9VAH9VAG9V>`@8.QL;/S\._U\_3Q\O#S\_'Q\?'R\_7R\_+R
M\O'R\O+S\_+R\O'R\O+R\_+R\O+U]/7S\O/P\?#R\O'S\O/S\O3T\_3T\_+S
M]//T]//R\O'Q\O/S]/3T]?7Q\?#R\O+Q\O.@H*-G9V=H9V=G9VAG9V=G9V=G
M9V=H:&B!@H3____________[___\_/W___[_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________^^____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________OW_;FUN:&=H
M:&=G9VAH:&=H:&=H:&=G9V=GJZNO\O+R]//R\O/R\O+Q\O+Q\O/R\O/R\O/R
M\_/R\O+R\O/T]/7U\O/T\O/T\O/T\O/T\O/T\O/S\O+R\O/R\O+R\O+R\O+R
M\O/R\O/R\O+Q]/3SL+&S<G-U9V=G9V=G:&=H9V9F9V=E9V=G:&AG9V9G:&=H
M:&=H9V9G9F=G:FIJ=W=WAX:'DY.3G9V=FYR<G9V<G)V;G)R;G)N;G)R<FYN;
MFYN:G)V;G)V;G)R;GIV<G)R;FYR:G)R;G)R;GIZ<FYN:G)R;G)R;G)R;G9V;
MG)R;G)R;G)V;G9V<G)R;G)V;G)R;G9Z<G9V;G)V;G)V;G)V;G9V;G)R;G)R;
MG)V;G)V;G)V;FYR:G)R;G9V<G)R;G9V<G9V;G)R;G)V;G)R;G)V;G)R;G9V<
MG)V;G)R;FYR:G9V<G)R;G)V;G)R;G)R;G9R;G)R;G)V;G)V;G)R;G)R;G)R;
MG9V;G9V;G9V<EY>7A8:&>'EY;6UM9V=G:&=G9V=G:&=H9V9G9V9H9V=G:&=G
M9V=G9V=G:&AH9F=G<W1VGY^CY>3E\_/U]//T]//R\O+Q\_/R\O/R\O+Q\O+R
M\O+R\O+Q\O+R\O'R]//T\_3T\O+Q\O+R\O+R\O+R\/'R\O/R\?'Q\_3S\O/T
M\O/T\O/T\O/R\/'P\O+RGY^B9VAH:6AH9V=H9VAH9V=G9V=G9V=G@8*%____
M_?W]____^?O\_OW]_OW\________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________OO__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________O[^_____O[^____X&`@VAG:&=G:&=F96AG:&=G
M9V=G9V=F9I^?H_/S\?/R]/+R\?+R\O+S\O+R\O+R\O+R\O+R\O+R\?+S\O3T
M]?+S]?3U]?+R\?+S\O/S\O+R\?3S]/+P\/+R\?+R\?/S]/'Q\N?FY:"@HVQL
M;6AG9VAG9V=F9FAH:&=F9FAG9V=G9VAH:&AH:&AH:&=G9VUM;7Q]?(R-C)V=
MG)R<FYR<FYR<FYR=FYR<FYR<FYR<FYR<FYV=FYR<FYR=FYR=FYV=FYR<FYV=
MFYV=FYV=FYR<FYR=FYN;FIR<FYN;FIR=FYR=FYR<FYR=FYR<FYR=FYR<FYR=
MFYR<FYR<FYR<FYR<FYN;FIV=G)R<FYR=FYR<FYR<FYR<FYR=FYR=FYN<FIR<
MFYR<FYR<FYZ=G)V=FYR<FYR<FYR<FYR=FYR<FYR<FYR<FYR=FYR<FYR<FYR<
MFYR<FYR<FYR<FYR<FYV=FYV<FYV=FYR<FYR<FYR<FYN<FIR<FYR<FYR=FYR=
MFYR=FYV=G)R<FY"1D(*#@F]O;V=G9VAH:&=G9VAG9VEH:&=G9VAH:&AG96=G
M9VAG9V=G9VQL;9"0DMO9V/3S]/+S]/+R\O3R\?+Q\O+S]/+S\O+R\O3S]/3R
M\O+Q\/7T]?'Q\O3T\_+S\O+Q\?7T]?+R\?+R\O#P\/3T\_+R\O+S]/+S]/3T
M]?3R\J*AI&9F9VAH:&=G:&9G9VAH9V=F:&=H:(*"A/W]_?____[]__S___W]
M_?__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________SK_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___]_?W_______________^!@85H9VAG9V=G9F9G9VAG9V=G9V=H9V>8F)OR
M\_+S\O/R\_+R\_+R\O'R\O'R\_+R\O'R\_+R\O+U]/7R\?#T\_'S\O'T\_3U
M]/+R\O+R\_3P\?+R\_3Q\?#T]//CX^2AH:5L;&YH9VAG9V=H:&AG9V=H:&AG
M9V=F9V=G9V=G9V=G9V=L;&Q[>WN2DI&<G)N=G9N=G9R<G9N<G9N<G)N<G)N<
MG9N<G9N<G)N<G)N<G)N<G)N;G)J<G)N=G9R>GIV<G9N<G9N<G9N<G)N=G9N>
MG9R=G9R<G)N<G)N<G9N<G)N=GIR<G9N<G)N:FIF>GIV;FYJ<G9N>GIV;FYJ<
MG)N<G)N=G9N<G9N<G9N<G)N<G9N;FYJ=G9R<G)N<G)N<G)N=G9R;G)J<G)N=
MG9N<G)N;G)N;FYJ=G9N<G)N<G9N<G9N<G9N<G9N>GIV<G)N;G)J=GIR<G)J>
MGIR<G)N<G)N<G9N<G)N;FYJ=G9N<G)N<G9N<G)N<G9N=G9N<G)N<G)N<G)N=
MGIR<G)N<G)N3DY*"@H)O;V]H:&AF9F9G9V=H9V=G9VAG9VAG9VAH9VAH9V=G
M9VAF9FB/CY';V=KT\O+P\/#S\_+R\O+S\O3S\O/S]//S\O/S\O/T\_3S]/3Q
M\?'R\O+S\O'R\?+R\O'S\_+Q\?'R\O'T]//R\_3R\_3Q\O+V]/.&AXIG9VAH
M9V=G9VAG9V=G9V=H9VAG:&B$@X;________^_?_Z^_O_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\^____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________/S]
M____^OO[D9&5:&=G9V=H:&=G:&=I9V=G9V=G:&=G@("#\_'P\O+Q\O/R\O+Q
M\O/R\O/R\O+R\O/R\O/R\O/R\O'P]?3U]//T]//Q]O3S\?+S\_3T\O/R\O+Q
M\O/T]?3UJ*>J;6YM9V=E:&=G9V=G:&AH9V=G:&=G9V=G9F=G9V=G:VQK>'EX
MC8V,G)R;G9V;FYN:G9V<FYR:G)V;G)R;G9V;G)R;G)R;G9V;G)R;G)R;G)R;
MG)R;G9V;G)R;G)R;G)R;G)R;G)R;G)V;G)R;G9V<G)R;G)R;GIZ=FIN9G)R;
MG9V;G)R;G)R;G)R;G)V;GIZ<FIJ9GIZ=FYR:G)R;G9V<G)R;G)V;G)R;G)R;
MG9V;G)R;G)R;G)V;FYN:G)R;G)R;G9V;G)V;G)R;G)V;G)V;G)R;G)V;G9V<
MG)R;G)R;G)V;G)V;GIZ=G)R;FIN9GIZ=G)V;FYN:GIZ<FIN9FYN:G)R;G)R;
MG)R;G)R;G)R;G)V;G)R;G)R;G)R;G)R;G9Z<G9V<G)R;G)R;G9Z<G9V;G)V;
MG9V;FYR:DY22?'U]:FIJ9V=G9F9F9V=H:&AI9V=H9V=G9V=G:&AH9V9F;&QN
MH:"CYN7F\/'R\O+R]O3S\_+S\?+S]/7U]/3U\O/T\O'R\_+S\_+S\O+R\O+Q
M\?'P\/'P\_3S\_/R\/'P\O/S\?+S\O/T]//T>7I[:6AH9V=H:6AH:&=H:&AH
M9V=G9V=GHJ&D_____OW]_O[_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________//__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________W]^_____S\_?___Z.CIVAG
M:&9G9V=F9V=F9F9F9FAG9VAG:&9G:/3S\O+S\O+R\O+R\O+R\?+R\O+S\O+R
M\O+R\?+R\?;T\_3S\O+Q\O+S]/#Q\O+S\O3U]?/R\_3R\<;$Q7-T=6AH9FAG
M9V=F9FAH:&=G:&=G9V=F9F=H:&=G9VUN;8:&AI>7EIV>G)R<FYR=FYR<FYV>
MG)R<FYR<FYV=G)N<FIV=FYR<FYR<FYR<FYR=FYR<FYR<FYR=FYR<FYR=FYR<
MFYZ>G9R=FYR=FYZ>G)N<FIR<FYN<FIR<FYV>G)R=FYV>G)R<FYR<FYR<FYN<
MFIV>G)R<FYR=FYV=G)N<FIR<FYR<FYV=FYR<FYZ>G9Z>G9R<FIN;F9R<FIR<
MFIV=FYR<FYV=FYR;FIV=G)R=FYR=FYR=FYR=FYR=FYN;FIR<FYV>G)V=FYN<
MFIN;FIZ>G9R=FYJ;F9R<FYR<FYV=FYV=G)R=FYR=FYR<FYR<FYR<FYR<FYR<
MFIV=G)V=FYV>G)R<FYR<FYR=FYR=FYR=FYR<FYR=FYR=FYN;FIV=G)N<FIZ>
MG)R<FX>'AW-S<6=H:&=G:&AG:&AG:&AH:&=G9VAG9V=G:&=G9VQL;K&QM/7T
M]?+R\?3T\_3S]?+R\/+R\/+R\O7T]?/R\_3S]/3U]?#Q\/3T\_+R\?+R\O#P
M\/+S\O/T]/'R\_+S]/CT\V9H9V=F9FEH:6AH9V=F9VAG9V=H:&9G9ZZML/__
M______S\_?____S\_?__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________[[_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________OW\_/W________+R<QF9F=H9V=H9VAG9V=G
M9V=H9V=H9VAF9V?%Q,7R\O+R\O'R\O+R\O+R\O'R\_+R\O'R\O'R\O'R\?/R
M\_3R\O+R\O+T]?7R\_+T\_+EY>2(B(MH:&EF9V=G:&AI:&AG9FAG9FAH:&AG
M9V=H:&AR<G*-C8V=G)N<G)N<G)N=G9N<G)N<G)N<G)N;FYJ=GIR<G)N:FYF<
MG9N<G)N<G9N<G9N<G)N<G)N<G)N<G9N<G)N<G)N=G9R<G9N;FYJ=GIR=GIR<
MG)N=GIR<G)N<G9N=G9N;FYJ=G9N;FYJ<G)N<G)J8F):.CXZ,C8R.CHU^?W]^
M?WY_@']_?W]_?W]Y>7ET='1Q<7)R<G)R<G)S<G-R<G-S<W-S<W-S<W-V=G9]
M?7U_@']_?W]^?W]^?W^*BHF-C8V-C8V4E).<G)J<G)J=G9N<G)N<FYJ=G9N=
MG)N<G)N<G)N<G)N=G9N<G)N<G9N<G)N<G)N=GIR<G)N<G)N;FYJ<G9N<G9N=
MGIR=G9N<G)N;FYJ<G9N<G)N<G)N;FYJ=GIR<G9N<G)N<G)N<G)N=G9N<G)N0
MD)%Z>GMG:&AG9V=G9V=G9V=G9V=F9F5H9VEH:&AF9V>!@8/.SM#S\O/T\_3S
M]//R\_+S]//R\?#T\_3S\O3P\?+T]/7R\_+T]//P\?#R\O+O\._R\_/T]/7P
M\?*ZN;MG:&AH:&AH9VAH:&AH9VAH9V=G9V=H:&G)R<O]_?W____]_?W____\
M_/W_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________^^________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________?W[_________/S][>SK9V=I:&=H9V9H9V=H9VAH:&AH:&EI:&=G
MF)>9\_/R\O+Q\O+R\O+Q\O/R\_/R\O+R\O/R\O+Q\O/S\/'R\O+Q\O/R\._Q
M]/+QN[J[;&UO9F=E9F9G:&=G:&AH9V9G:&=I9V=H9V=G<W-SC(R+G9V;G)R;
MG)R;G)V;G9Z<G)V;G)V;G)V;G)V;G)R;G)R;FYN:G9V;G)R;FYN:G)R;G)V;
MG)V;G)V;G)R;G)R;G)R;FYR:FIN9GIZ=G9V<G)R;G9V<G)R;EY>6C(V,B8F)
M?GY^?7U]<W-S<G)R:&AH9F9G9VAH9F=G9F=G9V=G9V=G9F9F9V=G9V=G9V=G
M9V=G9F=G9V=H9V=G9V=G9V=G9V=G9V=G9VAH9V=G9V=G:&AH9V=H9F=G9V=G
M9F9F:&AH9F9F9F=G9V=H9F9F:&AH;V]O<G)S>7AY?G]_AH:&C(R+E)23G9V<
MG9V;G)V;G)R;G9V<G)R;G)R;G)R:G9Z<G9Z<GIZ=G)R;G)R;G)R;G)R;G)V;
MG9V<G)V;G9V<G9V;G)R;G9V<G)V;G)R;G9V<FYN:FYR;G)V;G)V;E963>7EY
M9F9F9V=G:&AH9V=G9V=G:&AH9V=F9V9F9F=GGY^A]?/Q\_+T\?#R]?3U\O/R
M\O/R\O/R]//T\_+T\_3T\O/T\_3T\O/T\O/T\/'P\?'Q\O+RF)>:9F9F9V=H
M9V9G9V9F9V9G:&=G9V=G9V=I___]_?W]_/W]________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________O/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________O__
M______S______WIZ?&=F9V=F9V=G9V=G9V=G9V9G9V=F9W1T=//R\?+R\?+R
M\?+S\O+S\O+R\O+R\?+R\O+R\?3S\O+R\O+R\?3S].CFYI"0E&=G:&EH:&=G
M:&=G9FAG9V=F:&AG9V=G9W)S<XV-CIV=FYN<FIZ>G9V>G)R<FYR<FYN<FIR=
MFYV>G)R<FYR<FYV=G)R=FYN<FIV=G)R<FYR=FYV=FYR<FYR<FYR<FYV=FYV=
MFYV=FYR<FIF9F(R,BW^`?WEZ>7%Q<6AH:&=G9V=G9V=G9V=G9V=G9VAG9VAG
M9VAG9VAG9VAG9VAG9VAH9VAG9V=F9FEH:&=G9VAG9V=G9VAG9VAH:&AH:&AG
M9VAG9VAG9VAG9V=G9V=G9VAH:&=G9V=G9F=G9VAG9VAG9V=G9VAG9VAG9VAG
M9VAG9V=G9V=G9FAG9V=G9V=G9V=G9V9F9FAH:69F9V=G9W)R<G9X=WY_?XN+
MBY65E)N;F9V=FYV=FYR=FYN;FIR<FYR=FYV=G)V>G)N<FIR<FYR=FYN<FIN;
MFIZ>G9R<FYN;FIV=G)R<FYV=FYR<FYN;FIZ>G9N;FIR<FI.3DWEY>F=G:&=G
M:&=H:&=G9V=G9VAH:&EH:&=H:("`@>;DY/7T\O+Q\O+S]/+R\?+R\O7T\_/R
M]/+S]/+S]/'R\O'R\_3U]?#Q\/+R\?#Q\'-S=&AH:6=G:&=G9V=G9VAH:&=G
M9V=G9WMZ?O[^_O____[]_?G\_?[^________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________S[_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________\_O[________\______^;
MFYMH9VEH9VAF9V=F9V=G9V=G9V=G9VAI:&;.SM'R\O'R\O+R\_+R\O'R\O'R
M\O'S\_+R\O+T\_+S\O3T\_39V-=Y>GMG9V=G9V=H9VAI9V=H9VEH9V=G:&AL
M;6V,C8R=G9R<G)N<G9N<G)N<G)N<G)N=G9N<G9N<G9N<G)N<G9N<G)N=G9R<
MG)N<G)N<G)N<G9N<G)N<G)N<G9N<G9N=G9N8F)>,C8Q^?W]U=G5M;6UF9V=G
M9V=H9V=G9F9H9V=G9V=H:&AG9V=G9V=G:&AG9V=H:&=G9V=G9V=G9V=F9V=G
M9V=G:&AG9V=H:&EF9F9G9V=G9V=H9V=G9V=H9V=G9V=H9V=G9V=H:&AG9F9G
M9V=G9V=G9V=F9V=H9V=G9V=H9V=G9V=F9V=G9V=G9V=G9V=G9VAG9V=F9V=G
M9VAH9V=G9V=H9V=H9V=G9V=H9V=G9V=G9V=G9V=H9V=G9V=G9V=J:FIR<G*!
M@("*BXJ7F):<G9N=G9R;G)J<G)N<G)N<G)N<G)N;G9N=G9R<G)N=G9N<G9N<
MG)N=G9R<G)N=G)R>G9V;FYN<G)R<G)R<G)R<G)R1D9!S<W-H9VAH9V=G9V=G
M:&AF9V=H9VAG9VAK;&[&Q<3U\_+R\_7R\_3R\O+S\O'U\_3T]?7P\?+R\_/R
M\_/P\?+R\_+Q\?#"Q,AG:&9G9FAG9VAG9V=G9V=H9V=H9VAG9VBEHZ/__O_]
M_?W____[_?S__O______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________\^________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________O[___[]_________?W]_O[_R<C+9V=G9V=G9V=G
M:&=H:&AH9V9H:&=G9V=GD)"1\_+T]//P\O/U\_/R\_3T\_+S]?3U\_/O\_+T
M\O+QSL[-;&QM:&AF:&=G9F=G9V=G:&AH9V=G9F=G?G]^G9V<G9V;G)R;G)R;
MG)R;G)V;G)V;G9V;FYR:G9Z<G9V<G)V;G9R;G9Z<FYR:G)R;FYR:G9Z<G)R;
MG)R;F)B6BHJ*?7Q]<'!P9V=H9V9F9V9F:&=G9V=G9F=G9V=G9V=G9V=G9F9F
M:&AH:&AG9V=G9V=G9V=G:&=G:&AH:&=G:&=G:&=G:&=G9V=G:&=G9V=G:&AH
M9V=G9V=G9F=G9V=G:&AG:6EI:&=G:&=G9V=G:&=G:6AH:&AH:&=G9V=G9V=G
M9V=G9V=G9V=G9V=G:&=G:&AH:&=G:&=G:&=G:&=G:&AH9V=G9F9F9F=G9V=G
M:&AH:&AH9V=G:&=G:&=G:&=G:&=G9V=G9F=G9V=G:&AH9F=G9F=G:&=G;6UM
M>'AXAH>&E)23G)V;G9V<G)R;GIZ=G)V;G9V<G)R;G)R;GIZ=FYN:GY^=G9V;
MG)R;G)V;G)R;G)R;G)R:G)V;G)R;G)R;B8J):6EJ9VAH:&=G:&=G9V=G9V=G
M9V=G9VAHL[*T]?3U\_+T]//S]/+Q\/'P]/+R\_+S\O'R\_+S\O+R\O/T\O'P
MD8^2:&=H9VAH9F=G:&=F9V=H:&AI:&AI:&AFT]7:_O[]________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________OO______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________^_?W]_?W]_?___?_^___]^G-T=6=H:&=G:&AG:&=H:&=G9VAH
M9V=G:&=G:-O9VO+Q\O+S\?'R\_/R[_+S]/+R\O+S]/3S]+&QLV=G9V9G9V=G
M:&9F:&AG9V=G9V=G9W)R<I24DYV<FYV=FYV>G)V>G)R<FYR<FYR=FYV=FYN;
MFIZ>G9R=FYR=FYV=G)R<FYN<FIV=G)J;F9V=G)&1D']_?V]O;V9G9V=G9V9F
M9F9F9FAG9VEH:&AG9V=G9VAG9V=G9V=G9VAG9V=G9VAH9V9F9F=G9V=G:&=H
M:&=G9V=G9VAH:&9G9V=G9V=G9VAH:'%Q<G-S<W%Q<7IZ>G^`@']_?W^`?WY_
M?X.$A(N+BHV-C(Z.C8R-C(R,C(V.C8R,BXZ.C8R,BX:'AH"!@'U^?7Y_?X"`
M@'Q\?'-S='-S<W)R<FMK:V9F9F=H:&=G:&=G9V9F9FAH:&AG9V=F9FAH:&AG
M9VAG9V=G9V=G9VAH:&=G9V=G9V=G9FEH:&AH:&AH:&=G9V=G9V=G9V=G9VQM
M;7M[>XN*B9N;FIV>G)N;FIV>G)R<FYR<FYR<FYR=FYN;FIV=G)R=FYV=G)R=
MFYN<FIR<FYR<FYR<FYR<FYF9F'5U=6=G9VAG9V=F9FAH:&EH:&=G:&=I:):6
MFO+Q\/;U\O/S\O+S\O+S]/3R\O7T]?+Q\//T]//T\]O9VF9G:&AG9VAH:69F
M9FAG:&AG:&=G9V=H:'-S=?W]_?____S\_?__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________[W_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________________________^
M_?________W^_?___OV:FYUF9V=H:&EH9V=F9V=G9V=H9V=G9VAH:&B/CY/U
M]//R\_3S\?#T\_+T]//S]/3T\_2QL;-G:&AH9V=G9V=G9VEI:&9G9V=G9VB`
M@("=G9N=G9N=G9R;G)J=G9R:FYF>GIR<G)N;FYJ>GIR;FYJ:FIF=G9R<G)N<
MG9N=G)N?GYV)BHEY>GEI:6EG9V=G9V=H:&AH:&AG9V=H:&AG9V=G9V=F9F9H
M9V=F9V=H9V=H:&AF9V=G9V=H:&AF9F9G9V=F9V=L;6UQ<G)[?'M_@(")BHF,
MC(N5E92;FYF<G)J=G9N>GIR=G9N=G9R<G)N=G9N;G)J=G9R;FYJ<G)N<G)N=
MG9N=G9N<G9N<G9N=G9R<G9N<G)N<G)N<G)N=GIR=GIR<G)J=G9N=G)N>GIR=
MG9R;FYF?GIV8F):,C(N,C(Q_@']^?7US<W-P<'!F9F9G9VAG9V=G9VAG9V=F
M9F9G:&AG9F9H9V=H9V=G9V9G9V=G9V=H9V=H:&=H9V=H9V=G9V=G9V=I:VIT
M=76'AX>7EY6=G9R=GIR;FYJ>GIV<G9N<G)N=GIR<G)J;G)J=G9R<G9N=GIR<
MG9N>GIV<G)N=G9N&A85K:VMG9V=G9V=G9V=G9V=H:&AH9V>/CY+R\_'R\O+S
M\O/S]/7R\?#V]//R\_+T]?7R\?*0D)%G9V=G9VAH9VAG9V=F9F=H9V=G9V=G
M9V>CHZ;____\_/W^_?W_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________\^________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________[]_____OW__?W]___]____
M_?W]XN+A9F=G9V=H:&=F9V=G9VAH9V=G:&=G9V=G9V=GVMG:\?'P]?3U\O/R
M\?'Q]//TLK*T9V=G:&=H9V=H:&=G:&=F:&=G;&QLCY"0G)R;G)R;FYN:G)R;
MG9Z<FYR:GIZ=FYR:G)V;G)V;FYN:G)V;G)R;G)R;G)R;B8J)>7EY:6EI9V=G
M9V=G9V=G9F=G9V=G:&=G9V=G9V=G:&AG9F9F9VAH9V=H9F9F9V=G9V=G9V=G
M;6UM=G9V?X!_B8F)D)"/G9V;G)R;GIV<G)R:G)R;G9V;G9Z<G)R;G9V<G9Z<
MG)R;G)R;G)V;FYN:G)V;GIZ=G)V;G)V;G)V;G)V;G)R;G)R;G)R;G)R;G)R;
MG)R;FYR:G)R;G)R;G)V;G)R:G)R;G)R;G9V<G)R;G)V;G)R;GIZ<G)R;G)V;
MGIZ=G)R;G)R;G)V;G9Z<FYJ9GYZ=DY.2C8V,?G]_>7EY;W!P9F9G:&AI9V=G
M9VAH9V=G:&=G9V=G9V=G:&=G9V=G9V=G9V=G9V=G9V=G9V=G:&AH9F=G=75U
MA8:%GIZ<FYJ9G)V;G)R;G)R;G)V;G)R;G)R;G)R;G)V;G9Z<G)V;G9V;G9V<
MG)R:D9&0;V]O9V=G:&AH9V=H9V=H:&AH9F9FEY>:\_+S]?3V\O/S\_+T]//P
M]/3S\/'ST,_19F=G9V=G:6AI9V=G9V=G9VAH9V=G:&=G9V=HW]_B________
M_____?W^____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________/O______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________?____S\_______^_?S____^___^_8F*C&9F
M9FEH9F=F:&=G:&=G9VAG9V=G:&AG9X"!@_3S]?+R\N_P\O+S\]#.SFQL;6AH
M9V=G:&=G9V=G9VAH:'9U=Y&1D9N;FIR<FYV>G)N<FIV=FYR=FYV>G)N<FIN<
MFYV=G)N<FIV>G)R=FY.3DGM\?&QL;&=H:&AG9VAH:&AH9V=F9F=G9V=G9V=G
M9V=G9V=G9V=G9V9G9VAH:&9F9FAI:7=W=W]_?XV.C9B8EIR<FYZ>G)R<FYR<
MFYV=G)N<FIV=FYR<FYV=G)R<FIR=FYJ;F9R<FYR=FYR<FYV>G)R<FYR<FYR<
MFYR<FYN;FIR<FYV=FYR<FYR<FYR=FYR=FYR=FYR<FYR<FYV=G)R<FYR<FYR=
MFYR<FYV>G)R<FYV=FYR=FYR<FYR<FYR<FYR<FYR<FYN;FIN<FIR<FYR<FIR=
MFYV>G)R<FYR<FYR<FYV=G)V=FYV<FYZ>G)R<FHV-C(.$A'=X>&QN;6AH:&AG
M9V=G9V9G9V=G9V=G9V=G9V=G9VAG9VAH:&=G9VAH:&=F9F9G9VEJ:GEX>9"0
MCYV=FYV=G)N;FIR=FYR<FYV=G)N<FIR<FYR<FYV>G)N<FIZ>G9V=FYB8EW!P
M<&9F9V=F9FEH:69F:&AH:&9F9K.SM?+S]/'R\O/R\_+R\O+S\_7T]8&!A&=F
M9FAH9V=G:&AG9V=F9F=G9V=F9V=F9I&1D_________________________S]
M_?__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________SS_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________\_/_^_O[(Q\IG9V=H9V=H9VEH:&AG
M9V=F9F=H9VAH9V=G9V:IJ:SR\_7T]?+DX^1L;6YH:&AG9F=G9V=G9VAI:&AU
M=G>8F)B:FYN=G9F<G)N<G)N=G9R<G9N<G)N<G)N<G)N<G9N<G)N>GIR)BHER
M<W-H:&AF9F9H:&AG9F9F9F9F9F9G9V=H9V=H9V=G9F9H:&=G9V=F9F9I:6EY
M>7F&AH:3DY*=G9R<G)J=G9N<G9N<G9N>GIV;FYJ<G)N>GIV;FYJ<G)N<G9N=
MG9N:FYF>GIV;FYJ>GYV<G)N<G)N<G)N;FYJ<G9N<G)N<G9N<G)N<G)N<G)N<
MG9N<G)N<G9N<G9N<G)N<G)N<G)N=G9R=G9N>GIV<G9N<G)N<G)N=G9N<G9N<
MG)N<G9N<G9N=G9R<G)N;G)J<G)N=G9N<G9N<G9N=G9R<G)N;FYJ=G9N<G)N>
MGIV<G)N=G9R<G9N<G)N;FYJ=G9R<G)N>GIV=G)N3E)**BXI\>WQN;FYF9F9F
M9F9H:&AH9V=H:&=G9V=H:&AH9V=I:&AF9F9F9V=G9V=F9F=O;V^&AH:8F):<
MG)J=G)N>GIR<G9N>GIR=G9N:FYF=GIR<G)N;G)J=GIR<G)IY>7IF9F9H9VAF
M9V=G9F=H9V=G9VC/SLWV]//T\_+O\/'U]/6IJ*IG9V=G9VAH9V=F9V=G9F=H
M:&AH:&AH9VEF9F?7U=?____________________]_?[_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________^]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________^_O\
M_____?W]_____?W]_____?W]____@8*%9V=G9V9G9F=G:&=G:&=G9V9G9V=H
M:&=G;6UMV]G:]?3R@("!9V=H:&AH9V=G9V=H9F9F=W=YG9V;G)R<G)R9G)R<
MG9Z<G)R;G)V;G)V;G9Z<G9Z<FYN:F)B7AX:&;FYN9V=G9V=G9F9G9F=G9V=G
M9V=G9V=G:&AH9F9F9V=G9F=G9F=G<W-S@X.#CX^.GIZ<G)R:G)R;G9Z<FYR:
MG)R;G9V;G)V;G9V<FIJ9G)R;G)V;G9V;GIZ=FYR:G)V;G)V;G)R;G)R;G)V;
MG)V;G)R;G)V;G9V<GI^=G)R;G)V;G9V<G)R;FYR:G)R;G)R;G)R;G)R;G)R;
MG9V;G)R;G)R;G)R;G)V;G)V;G)R;FYR:G9V<G)R;G)V;G9V;G9V;G)V;G)R;
MG)R;G)R;G)R;G)R;G)R;G)R;G)R;G9V;G)R;G)R;FYN:G)V;G)R;G)V;G)V;
MG)V;GIZ=G)R;G)V;FYN:G)R;G)R;G)V;G9V;G9V;E964AX>&=75V9V=G9VAH
M9V=G:&AH:&=G9V=G:&=G:&=G9V=G9V=G9V=G9F=G:6IJ?WY_F9F8G9V;G9V;
MG)V;G9V<GIZ=FYR:G9Z<FYR:G9Z<G)R;FYN:>'E[9V=G9V=G:6AI:&=G9V=H
M<G)SZ.;D]?3R]//RV]K:;6UM:&=G:&=H9V=G9V=H9F=G:6AH9V=G9F=GD9*6
M_______]_________________________/W]________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________OO______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________O[_/__
M_________?[]_]73U6AH:&AG96AG:6AG9VAG9F=G:&9G:&AG96AH:'AY>ZFI
MK&AH:6AH9F=G:6AH:&AG9W)R<YN;FYV=G9V=FYR<FYR<FYR<FYV>G)R<FYV=
MG)R=FYB8EW]_?VEJ:F=G9V=G9VAG9V=F9F=F9F=H:&9G9V=G:&AG9V9F9FAH
M:'9V=H:%A9J:F)R<FIR<FYR=FYR=FYR<FYR=FYR<FIV=G)R=FYR<FYR<FYR=
MFYV>G)V>G)R<FYR<FYR<FYR=FYR<FYR<FYR=FYR<FYR<FYR=FYR=FYR<FYR<
MFYR<FYR<FYR<FYR<FYR=FYV>G)R<FYN;FIV<FYR<FYV<FYV=FYV<FYV=FYV=
MFYV=FYV=FYR<FYV=FYR<FYR<FYR<FYV<FYR=FYR<FYR=FYR<FYR<FYR<FYR=
MFYR<FYR<FYV=FYV=FYR=FYN;FIR=FYV>G)R<FYR<FYR<FYR<FYN;FIV=G)V>
MG)R<FYN;FIV=FYN;FIR=FYR<FYR<FYR<FYR=FYR<FXF*B7AY>6EI:6AI:6=G
M9V=F9F=G9V=G9VAH:&=G9V=G9VAG9V=G9V9H9W=X>)24DYV=G)R=FYN<FYV=
MG)N;FIV=G)N<FIR=FYN;FYV=FG-S=&=F9V=F9F=G:&=G9VAG9XZ/E/3S\O3S
M]'AX>FAG9VEH:&9F9FAG9V=G:&=G96=F9VEH:&=G9>'@X?_______?______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________S[_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________W^
M_OZ;FYYH9FEH:&9F9VAH:&EH9V9G9V=G9V=F9F9G9V=I:6EG9V=G9VAG:&AG
M9VAL;6V:F9F<G)R;FYJ<G)N<G9N<G)N<G)J<G)N=G9R=G)M^?GYJ:VMG9V=G
M9V=G9V=H9V=H:&=H9V=F9F9H:&AF9V=G9V=R<W.'B(>8F)><G)N<G9N<G)N<
MG)N=GIR=G9R<G)N;G)J=G9N=G9R<G)N;FIF<G)N=G9R<G)N<G)N<G9N<G)N<
MG)N=G9N<G)N=G9R=G9R<G)N>GIV;G)J<G)N<G)N<G9N<G)N<G)N<G)N=G9R<
MG)N<G)N<G)N;FYJ=G9N<G)N=G9N>GIV<G)N=G9N<G)N<G)N=G9R<G)N=GIR=
MGIR=G9R<G)N<G9N<G)N<G)N=GIR=G9R;FYJ=G9R<G9N=G9N=G9N<G)N<G9N<
MG9N<G)N<G)N=G9N<G)N<G9N<G)N<G)N<G)N;FYJ>GIV;FYJ=G9R=G9N=GIR<
MG)N;FYJ=G9N<G9N=G9R<G)N<G9N<G)N<G9N<G9N+BXIU=79G9V=H9V=H:&AH
M9V=H9V=H:&AH9V=H9V=G9V=H9V=G9V=\?'R8F):<G)N<G)N<G)N=GIR<G)N<
MG)N<G9N;G)J7EY9M;6UG9V=H9V=H9V=G9V=G:&C'Q,20CY-G9V=G9V=H9VAG
M9FAH9VAG9V5F9V=G9V=G9F>9F9K^_O_\_____OW_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\]____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________][>SN;FYN9V=H
M:&=G9F9F:&=H9V=G9V=G9V=G9V=G9V=G9V=G9V=G9V=G9V=HEI65G9V=FYN;
MG9V<G)R;G9V<G)R;G)V;G)R;BXN*;6UM:&=G9V=G:&=G9V=H:&=G9V=G9V=G
M9V=G9V=G:FIJ>WQ[E964G9V;G9V;G)R;G)V;FIJ9G)R;G)R;G)R;G9V<FYN:
MGIZ=G)R;FIJ9G9Z<FYN:G)V;G9V;G9R;G9Z<G)R;G9V<G)R;G9V;G)V;G)R;
MG)V;G)V;G)V;G)R;G9V;G)V;G)V;G)R;G9Z<G)V;G)R;G)R;G)R;G)R;G)R;
MG)R;G)R;FYN:FIN9G9Z<G)R;G)R;G)V;G)V;GIZ<FIJ9G9V<G)R;G)R;G9V<
MFYN:G9V;FYN:FIJ9GIZ<G9V;G)R;FYN:G)R;G9V<G)R;G9Z<FYR:G9Z<G9V;
MGIZ<G)V;G9V<G)V;G)R;GIZ<G)N:G9V;G)R:G)R;G)R;G)R;G)R;G)R;G)V;
MG)R;G)V;G)R;G9V;G)R;G)R;G)R:G9V;EY>6@H.";&QL9VAH9V=G:&AH:&=G
M:&=G:&=G:&=G9V9F9F=G:FMK?X!_GIZ<FIN9G)V;G)R;G)R;G)R;G9Z<G)R;
MD)"/9V=G9V=F9V=G:&=G9V=G='1W9V=I9V=G9V=G9V9F:6AH:&=H9V=H9V=G
M:&AI<G)T[^[O_?W[_OW_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M/O__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________W]_?W\_O[^_+_`PVAG9VEH:&AH:&=F9V=G
M9V=G9V=G9V=H:&9G9V=G9V=G9V=G9WQ]?9R;FYR<G)R<G)R<FYR=FYJ;F9R<
MFI24DW%R<F=G9VAG9V=G9VAG9VAH:&=G9VAG9VAH9V=G9W-S<X:&AIN;FIZ>
MG9N;FIR<FYR<FYR=FYV=G)R<FYR=FYR<FYN;FIJ:F9V=G)R<FYV=G)Z>G9R<
MFYV=G)R<FYV=G)V>G)R<FYR<FYR<FYV>G)R<FYR<FIR<FYR<FYZ>G9J;F9V>
MG)R<FYR<FYR<FIR<FYR<FYR<FYR<FYR=FYR<FYR<FYR<FYV=FYV<FXV.C8V-
MC(N,BXV-C(Z.C8V-C(V-C(R,BXV-C9B7EIV=G)V=FYV=FYV=FYN:F9^>G9Z=
MG)N;FIR=FYR<FYN;FIR<FYV>G)V=FYR<FYV>G)J;F9Z>G)J;F9V=G)N;FIV>
MG)V=G)Z>G9R<FYR=FYR<FIR<FYR<FYR<FYR<FYR=FYR=FYR=FYR<FYR<FYR<
MFYR=FYR<FYV=G)R<FYR<FYR<FYV=G(R-C'5V=F9F9FAH:&=H:&=G9VAH:&AG
M9VAG9V9F9FAH:&QL;(Z.C9R<FIR=FYR=FYR<FYR=FYR<FYR<FW^`@&=G9V=G
M9VAG9V=H:&9G9VAH:&9G9VAG9VAG9VAG9V=G9V=G:&EH:&9F9LG)R_W]_O__
M_____?S_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________[W_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________^_O___OW[_?[^_O^1D9-H9V=H9V5G:&AG9VAG9V=G9V=F9V=G
M:&AG9V=G9V=G9V>8F)B=G9V;FYN<G9N<G)J<G9N>GIQ^?W]F9V=G9V=G9V=G
M9V=H9V=H9V=H9V=H9V=G9V=Q<7&-C8R;FYJ<G)N<G9N;FYJ=GIR<G)N<G9N;
MG)J<G)N<G)N<G)N;FYJ<G9N=G9N=G9R;FYF<G)N=G9R<G)N=G9R<G9N;G)J<
MG)N=GIR;FYJ=G9R;FYJ<G9N<G)N<G)N=G9N<G)N9F9>,C(N-CHU^?W^`@8!]
M?'UR<G)R<G)R<G)J:FIF9F9H:&EF9V=G:&AG9V=G9VAF9F9G9V=G9V=F9F=H
M:&AF9V=G9V=G:&AH:&AF9F9G9V=G9V=F9F=H:&AR<G-R<G)S<W-Z>7E_?GY_
M@(")BHF,C(N5E9.=G9N<G)N=G)N>G9R<G)N<G9N=G9N=G9R<G)N<G9N<G)N;
MFYJ=G9R=G9N<G)N<G)N<G9N<G)N=G)N<G)N=G9N=G)N;G)N>GIV;FYJ<G)N<
MG)J>GIV<G)N<G)N<G9N<G)J4E))X>7EG9V=G9V=G9V=H9V=H9V=H:&AG9F9I
M:6EG9V=X>7F8F)><G)N<G)N<G9N=G9R<G9N<G)IM;6UF9F=H9V=H9VAG9F9G
M9F9G9V=G9VAH9VAF9F=H:&AH9VAG9V:;FY[^_?_____^_?_[^_S_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________^\____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________?S[
M__[___[]____[NWO>GM[:&AH9V=G9V=G9F9F9V=H9V=H9V=G9F=G9VAH;&QL
MG)R;FYR:G9V<G)V;GIZ<E964;F]O9V=G9V=G9F9F9V=G9F9F9V=G9F=G9VAH
M<G)SC(R,GIZ<G)R:G9V;G)R;G)V;G9Z<G)R;G)R;G)V;G)V;G9V<G9V<G)V;
MG)R;G)R;FYN:G9V<G9V<FYR:G9Z<GIZ=FYN:G)V;G9V<G9V<G)R;G)R:E964
MC(V,@H*"?'U\<7)R<'!P9VAH:&AH9F=G9F=G:&AH9F9F:&=G:&=G:&AH9V=G
M9V=G9V=G:&=G9V9F9V=G:6AH965E:&AH9V9F9V=G:&AH:&=G:&=G9V=G9V9F
M:6AH:&=G9V=G:&=G:&=G:6AH:&=G:&=G:&=G:&=G9V=G9V=G9V=G9V=G9VAH
M9V=G;6UM<G)R>WQ\?X"`C(R+E)23G9V;G)R;G9V<G)R;G9V;FYN:G)R;G)V;
MG)V;G)R;G9V;GIZ=G)R;G)R;G)R;G)V;G)R;G)V;GI^=G)R;G)R;G)V;G9V<
MG)R:G)R;G)R;GIZ<E)23>7AY9VAH9V=G9V=G:&AH:&=G:&AH9V=G9V=G;&QM
MC(V,G)R:G)V;FYR:G9V<G)R;A86%:&AH9V=G:&=H9V9G:&AI:&=G:&=G9V=H
M:&AI:&=G9V=H>GI\Z^SM____^_O[___^_O[____]____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________OO__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________OS___S\_?_____^
M_=75V6QL;6AH:&=G9V=G9V=H:&=H:&9G9V=G9V=H:'%Q<9R=FYR=FYR=FYV=
MFX:'AFEJ:F=G9V=G9V=G:&=G9V=G9VAG9VAG9W-S<XR,C)R<FYR=FYR=FYR=
MFYN<FIV=G)N;FIV=FYV=G)R=FYN<FIR<FYR<FYN;FIR<FYR<FYV=G)R<FYV=
MFYR<FIV>G)N<FIR<FYR=FY&1D(>&AGU]?7)R<FIJ:FAH:&=G9V=G9V=G9V=G
M9V=G9V9F9F=G9V=G9VEI:69F9FAH:&AH:&=F9F=G9VEH:&AG9VAH:&AG9VAG
M9V=H:&9G9VAH:&9F9FAH:&=G9V=G9V=H:&=G9VAH:&AI:6=G9V9F9F=F9FAH
M:&AG9VAG9VAG9V=G9VAG9V=G9V=G9V9G9VAH:&=F9FAH9VEH:&9F9V=G9V=G
M:&9G9V=H:&AG9V9G9W)R<GAX>(*#@HV-C)V=G)V=FYR<FYR<FYR<FYR<FYR<
MFYR=FYR=FYR=FYV>G)R<FYR<FYR<FYR<FYZ=G)V=FYV=FYV=G)R<FIR<FYR=
MG)V=G)V=FY.3DG9U=F=H:&=G9V=F9FAG9VAG9VAH:&=G9V=G9W]_?YR<FIV=
MFYV=FYN;FIZ=G&EI:6EH:&=G9VAG:&9F9VAH:&AH9V=F9V=G:&AG9VUM;]34
MUO[]_/[]___^_?______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_[[_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________^_?_`O\)G9VAG
M:&AG9V=G9V=G9V=G9V=G9V=G9V=S<W.<G9N=GIR<G)I\?'QG9VAG9V=H9V=H
M9V=G9V=G:&AF9V=I:6F'AH:=G9N<G)N<G)N<G)N<G)N;FYJ=GIR;FYJ=G9R<
MG9N;FYJ<G)N<G)N<G)N<G)N<G)N;FYJ=G9N<G)J<FYJ>G9R8F):)BHE^?W]R
M<W-F9V=G9V=G9V=H9V=H9V=G9V=H9V=H:&AH9V=H9V=H9V=G9V=I:6EG9V=I
M:&AG9F9H:&=G9V=F9F9G:&AG9V=F9F=G9V=G9V=G9V=G9V=G9V=G:&AG9V=F
M9V=G9VAG9V=G9V=G9V=H:&AF9V=G9V=F9F9H:&AG9V=F9V=G9V=G9V=G9V=H
M9V=G9V=G9V=G9V=G:&AF9F9H9V=G9V9G9V=H9V=G9V9H:&AH9V=H9V=G9F9H
M:&AG9F9I:&AF9F9G9V=G9V=O;V][?'R&AX:4E).<G)N<G9N<G)N<G)N<G)N;
MFYJ<G)N<G9N<G9N<G)N<G)N<G9N=G9N<G)N<G)N=GIR;FYJ=GIR=G9R=G9N<
MG)J-C8QL;6UH:&AG9F9G9V=H9V=G9V=H9V=G:&AV=G:9F9>=G)N=G9N<G)MY
M>GEG9V=I:&=G9FAH9V=H:&=H9V=H9V=G9V=G9VC)R<G]_?W]_?W_________
M__W]_?W_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________\^____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________O[__O[__/[]___]__[__/____[]G)J<9V=G9F=G9V=G9V=G
M9F9F9V=G9V=G<G)RG)V;F)B6=G=W9VAH:&=G:6AH9V=G9V=G:&AG9V=G=G9V
MF)B6G)R;G9V<G)V;G)R;G)R;G)R;G9V;G)V;G)R;G)R;G)V;G)V;G)R;G)V;
MFYR:G)R;FYN:G9V;G)R;BHJ)?7Q\;V]O9F9F9V=G9V=G:&AH:&=G:&=G9V=G
M:&=G:&=G:&AG:&AG:&=G:&=G:&AH9V=G:&=G9V=G9V=G9F=G9VAH9V=G9V=G
M9V=H9V=G9F=G9VAH9V=G9F9F9V=G9VAH9V=G9V=G<W)R<W-S<W)S<W)R='-S
M<W)R<G)S<W-S<W-S:&AH:&=G:&=G:&=G:&=G9V=G:&=G9V=G:&=G9V=G9V=G
M:&=G:&=G:&=G:&=G:&AH9V9F:&=G9V=G:6AH9V=G9VAH9V=G9F=G:&=G:&=G
M:&=G9V=G:&=G9V=G9V=G9VAH;&QL>7IYBHJ*EY>6G)R;G)R;G)V;G)R;FYR:
MG)V;G)R;FYN:G)R;G)R;G)R;G)R:G)R;G)V;G)V;G)R;G)R;G9V;G9V;?WY^
M9V=G9V=G:&AH:6AH:&=G9F=G9F=G<'!PF)B7G)R;G)V;B8J)9F=G:&AF9V=H
M9V=G9VAH:&=H9V=E9V=EA(*&_/___?W]_OW______OW________]_O[_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________O/__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________Z.CIF=G9V=G9V=G9V=G9V=H:&=G9V=G9W)R
M<IB8EG!P<&AG9V=G9V=H:&9G9VAG9V=G9VIK:XF*B9^>G9R<FYR<FYV=FYR<
MFYR<FYV=FYR<FYR=FYR=FYR=FYR<FYN<FIR=FYR<FYR=FYR=FY24DX>&AG5U
M=6=G9VEH:&=G9V9G9V=G9VAH:&=G9VAG9VAH:&AG9VAG9V=G9V=G9V=G9VAG
M9VAH:&AG9V=G9V9F9FAH:&=G9V=G9V]O<')R<GEY>7^`?W^`?XJ*B8V-C8V-
MC)24DYV=FYV=FYV=FYR=FYR=FYR=FYR<FYR<FYR<FYR=FYR<FYR=FYR<FYR=
MFYR<FYR<FYR=FYR=FYR=FY24DHV-C(R-C(R-C'^`@'^`?WM\?')S<W)R<FAH
M:&=G9V9G9V=G9V=G9VAG9VAG9V=G9VAH:&AG9V9G9V=G9V=G9V=G9V=G9V=F
M9FAH:&=F9F9G9V=H:&=G9V=G9V]O;X*#@I"1D)V>G)R<FYN<FYV>G)R=FYR<
MFYR<FIR<FYN<FIR<FYN;FIV=G)R=FYR<FYR<FYV=G)N;FI&1D&YO;V=G9VAG
M9VAG9V=G9V=F9FAH:&EJ:I"1D)R=FY24DV=G9V=G9VAG:&=G9V=F9V=H:&=G
M9VAG:,G*S/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________[W_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________^CHZ9F9V=G9V=G9V=G9V=G9V=G9V=H:6EQ<7%O;V]F9V=F9F9H
M9V=G9V=I:&AF9F=O;W"8F)>=GIR:FIF=G9R=G9R<G)N<G9N;FYJ>GYV<G9N<
MG)N<G)N<G9N<G)N;G)J=G9N4E).!@H)O;V]G9V=G9V=G9V=G:&AF9F=H9V=H
M9V=G9V=H9V=G9V=G9V=H9V=H9V=F9F9G9V=G9V=F9F9G9V=N;FYU=79_?W^&
MAH:,C(R8F)><G)N>GIR;FYJ=G9R<G9N<G)N<G)N=G9N;FYJ<G)N<G9N<G)N=
MGIR<G9N<G)N<G9N<G9N<G9N<G)N=G9N<G)N<G9N<G9N<G9N<G9N<G9N<G9N<
MG9N<G)N<G)N<G9N<G)N=G9R;FYJ=G9R<G)N;G)J=G9R;FIF=G9R-C8R+C(M^
M?WYY>7ER<W-G9V=G9VAF9V=G9V=H9V=H9V=H9V=H9V=I:&AG9V=H9V=I:&AG
M9V=H9V=G9V=H9V=H9V=H9V=M;6U[?'R1D9"<G)N<G)N;FYJ<G)N<G)N;FYJ<
MG9N=G9R<G)N<G)N<G)N<G)N;G)J>GIV;FIF9F9AZ>7IF9F9F9F=H:&=H9V=G
M9V=G9V=I:FJ0D9"=G)MH:&AF9V=H9VAG9V=H9VAF9V=G9V=G9F?*RLS_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__\]________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________HZ.F
M9F=G9V=G9V=G9V=G9V=G9V=G9V=H:FIJ9V=G:&AH9V=G9F=G9V=G9V=F>GMZ
MFYR:G)R;G)R;G)R;G9V;FIN9G9V;G)R;G9V;G)R;GIZ=G)R;G)R;G9V<EY>6
MB(F(<7)Q9F9F:&AH:&=G9V=G:&AH9F9F9VAH9VAH:6AH:&=G:&=G:&=G9V=G
M9V=G9V=G9F=G<G-S>GM[AX>'D9*0G9V;G9V;G9V<FYN:G9V<G)V;G)R;G)R;
MG)R:G)R;GIZ=G)R;G9V<G9V;G)V;G9V<G)R;G9V;G)R;G9V;G)V;G)R;G)R;
MG)R;G9V;G)R;G)R;G)R;G)R;G)V;G)V;G)R;G)V;G)R;G)V;G9V;FYN:G)V;
MG9V<G)V;G9Z<G)V;FYN:G)R;FYN:GIZ=G)R;GIZ=FIJ9GIZ=FYN:GIZ<G9V<
ME)23BHJ*?W]_<W-S:FIJ9F=G:&=G9V=G:&AH9V=G9V=G:&=G9V=G9V=G9V=G
M9V9F9V=F9V=G9V=G9F9F;&UM@X*"E923G)V;G)V;GI^=FYN:G9V;G)R;FYR:
MG9V;G)R;G)R;FYN:GIZ=FYN9GIZ<AH:&9V=G9V=G9V=G:6AH:&=G:&AH;&UM
MF9>69V=G9V=G9V9G9F=G9V=H9V=G:&=G:&=HRLK,____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________/O__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________Z.CIFAH:&=G9V=G:&=G
M9V=G9V=G9V=G9V=H:&AG9V=F9FAH:&=G9VAH:(.#@YR<FIV=G)N;FIV=G)N<
MFIV=G)V=FYV=G)V=G)V=FYR<FYR=FYV=FXV-C'AY>6IJ:F=G:&=G9V=G9V=G
M9V=G9VAG9V=G9V=G9VAH:&=F9F=G9V=G9V=H:&QL;'9V=H*"@I&1D)N:F9N;
MFIV=G)J;F9R=FYR<FYZ>G)N<FIR<FYN;FIZ>G9R<FYR<FYV=G)R<FYN;FIV>
MG)R<FYV=G)V=FYN;FIR<FYR<FYR=FYR<FYR=FYR=FYR<FYR=FYR<FYR<FYR<
MFYR=FYR<FYR<FYR<FYR=FYR<FYV=FYR<FYR=FYV=G)J;F9V=G)R<FYV=G)R<
MFIV=G)R=FYV>G)N;FIR<FYR<FYR<FYR<FYZ>G)R<FIR<FYR=FYR=FYN;FIV<
MFYZ=G).4DH>'AWEY>6YN;F=G9V=G9V=H:&9G9VAH:&AG9V9F9F=G9V9G9V=F
M9FEH:&=G9V=H:&=G9W5V=HF)B9R<FIV>G)N;FIR<FYN;FIR<FYV=G)N<FIV=
MG)N<FIV=G)V=G)N;FHJ*B6IJ:F=G9V=F9FEI:6=G9V=G9V]O;VAG9V=G9V=F
M:&=G9VAG:&=G9VAG9V=G:,G)R___________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________[W_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________^CHZ9G9V=F9V=G9V=G9VAG9V=G9V=G9VAG
M:&AG9V=G9V=H9V=F9V>&AH6<G)N=G9R=G9R<G9N;G)J>GIV<G)N<G)N<G9N;
MFYJ=G9R<G)N%AH5O;W!G9V=G9V=F9F9I:&AG9V=G9V=G9V=H9V=H9V=H:&AG
M9V=F9F9J:FMU=G:"@H*1D9"<G)J=G9R;FYJ<G)N>GIV;FYJ<G)N<G)N<G)N<
MG)N;FYJ<G9N<G)N=GIR<G)N;G)J=GIR<G)N=G9R<G9N<G)N<G)N=GIR<G)N<
MG)N<G9N;FYJ:FYF<G9N<G)N<G)N<G9N<G9N<G)N<G)N<G)N<G)N<G9N<G)N<
MG)N<G9N<G)N<G9N<G9N<G)N=G9N=G9N=G9N;FYJ>G9R<G)N=G)N=G9N<G)N>
MGIR<G9N<G9N;FYJ=G)N<G)N=G9N<G)N;FYJ<G)N<G)N<G)N<G)N<G)N;G)J=
MG9N;FYJ4E).&AH9X>7EJ:FIG9V=G:&AH9V=H9V=H:&AG9V=H9V=G9V=G9V=G
M9V=G9V=H:&EM;6V#@X.8F):=GIR<G9N=G9R<G9N=GIR=GIR;FYJ<G)N;G)J<
MG9N<G9N1D9!I:FIG9V=G9V9G9V=G:&AG9V=H9V=G:&AH9VAG:&AG9FAG9V=G
M9V=H9VC)R<O_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\\________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________HZ.F9F=G9VAH9V=G9V=G9F=G9V=G9F=G9V=G9VAH:&=G:&=G
MB(>'G)R;FIR:GIZ=G)R;G)R;G9Z<G)R;G9Z<G)R;G9R;F)B7?G]^;&QL9V=G
M9V=G:&=G9V=G:&AH9V9F9V=G9V=G:&=G9V=G9F9F;6UM?'Q\BXN*G)R;G9R;
MGIZ=G)R;G)V;G)V;G9Z<G9V<G)R;G)R;G)R;G)R;G)V;G)V;G)R;G9V<G)R;
MG)V;G)V;G)V;GIZ=G)R;G)R;G)V;G)V;G)V;FYR;G)V;G)R;G)V;G)V;G)R;
MFYN:G)V;G)V;G)R;G)R;G)V;G9V;G)R;G)V;G)R;G)R;G)V;G)R;G)R;G)V;
MG)R;G)R;G)R;G)R;FYR:G)V;G)R;G)R;G)V;G)R;G9V<G)R;FYR:G)V;G)R;
MG)V;G)R;G)R;G)R;G)R;G9R;G)V;G)R;G)R;G)R;G)R;G9V;G)R;GIZ=G)R:
MG)R;G)R;D)"/>WQ\;V]P9V=H9F=G:&=G9V9F9V=G9V=G9V=G:&AG9V9F9V=H
M9V=G:6IJ?W]_DI*1GIV<G9R;G)R;G)R;G)R;G)V;G)R;G)V;G)V;G9R;D)"/
M:&EH:&=G:&=G:6AH9V=G:&AH9V=G9V=H9V=G9V=H9V=G9V=G:&=HR<G+____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____/O______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________Z*B
MIF=G9V=G9V=G9V=G9V=H:&=G9V=G9V=G9V=G9VAH:'M[>YV=FYJ:F9V>G)N<
MFIV>G)R<FYV=FYR<FYR<FYB8EWY_?FEI:6AH:&AG9VAH:&AH:&=G9V9F9FEH
M:&9G9V=G9V=G9VUM;7Q\?)*2D9V<FYR=FYR<FYV=G)R=FYR=FYR<FYR<FYR=
MFYR<FYR=FYV>G)R<FYR<FYV=G)R<FYN;FIR<FYR<FYR<FYR<FYR=FYR=FYR<
MFYR=FYR=FYR<FYR=FYV=G)R<FYR<FYR<FYR<FYR<FYR<FYR=FYR<FYR<FYR=
MFYR<FYR<FYR<FYR=FYR<FYR=FYR=FYR<FYR<FYR=FYR=FYR=FYR=FYV>G)R<
MFYR<FYV=G)R<FYR=FYR=FYR<FYR<FYV=FYR=FYV=G)N;FIV>G)R=FYR<FYN;
MFIV=FYZ=G)R=FYR<FYR<FYR<FYR<FYR=FYR<FYR=FYR=FYR<FYR=FYV=G)R<
MFYV=G)24DX&"@6QM;69F9FAH9VAG9VAG9VAG9VAH:&AG9V9F9V=G9V=G9VAH
M:'AX>9B8EYR<FYN<FIV=G)J;F9V>G)N;FIN<FIR<FYV=G(6%A6AH:&EH:&=G
M9V=G9VAH:&=G9V=F9V9G9VAG:&=G:&AH9VAG:,G*R___________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________S[_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________^BHJ9G:&AG9V=G:&AG
M9V=G:&AG9V=F9V=G9V=G9V=R<G*<G)N<G9N<G)N<G)N<G)N=G9R=G9R;FYJ<
MG9N&AH9L;FUG9V=I:&AG9V=G9F9H9V=G9V=H9V=G9V=G9V=H:&AX>'B)BHF<
MG)N<G9N<G)N=G9R<G)N=G9N<G)J<G)N<G)N=GIR=G9R=G)N=G9N;FYF<G)N<
MG9N<G9N<G)N<G)N<G)N<G)N;FYJ<G)N<G)N<G)J<G)N<G)N=GIR<G)N<G)N<
MG)N<G)N<G)N<G)N<G9N<G)N<G)N;G)J<G)N<G)N<G)N<G)N<G)N<G)N<G)N<
MG)N<G9N<G)N<G)J<G)N<G)N<G9N<G9N<G9N<G)N;FYJ=G9N;G)J<G)N<G)N;
MG)J;FYJ=G9N=G9N<G9N>GIV;FYJ<G9N<G9N<G)N<G)N<G9N<G)N<G)N<G9N=
MG9N<G)N<G9N<G)N=G9N<G)N<G)N=G9R<G)N<G9N=G9N=G9R<G)N<G)N=G9R;
MFYJ1D9![?'QJ:VMH:&AG9V=G9V=G9V=H9V=G9V=H9V=H9V=G9V=I:FI^?W^8
MF)><G9N<G)N=GIR=G9N<G9N<G)N<G)N=GIQ]?'UG9V=F9V=F9V=H9V=G9V=H
M9VAG9V=G9VAG9V=H9V=G9FC)R<O_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________^]________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________HJ*F9V=G9VAH9V=G:&AH9V=G9V=G9V=G
M9VAH:6IJDY.2G9V<G)V;FYN:G)R;G)V;G)R;G)R:CHV-;FYO9V=G9V=G:&=G
M9VAH9V=G9V=G:&AG:&AG9VAH;6UM@8*"F9F7G)V;G)R;G)R;G)R;G)V;G)R;
MG)V;G9V<G9V;FYR:G)V;G)R;G)R;G9V<G)V;G)R;G9V;GIZ<G)R;G)R:G9R;
MG9Z<G)R;G)R;G)R;G)R;FYN:G9V<G)R;G)V;FYN:G)R;G)V;G)R;G)R;G)V;
MG)R;G)R;G)V;G)R;G)R;G)R;GIV<G9R;G)R:G)R;G9R;G)R;G)R;G)R;G)R;
MG9V;G)R;G)R;G)R;G)V;FYR:G)R;FYN:G)R;G9V<G)V;G9V;G9Z<G)R;G)R;
MG)V;G)R;G9V;G)R;G)R;G)R;G)V;FYR:G)R;G)R;G)R;G)V;G)R;G)R;G9V;
MG9V;G9R;G)R;GIZ<G)R;G)R;G)R;G)V;G)R;G)R;G9V<G)R;G)R;G)R;G)R;
MAH>&<G)S9V=G:&AH9V=F:&AH9V9F9V=G:&AH9V=G9V=G:6IJA8:%G)R;G9V;
MG9V<G)R;G)R;G)R;G)R;G)R:<'!P9V9F9V=G9V=G9V=G:&=H9V=G:&=H9V=G
M:&=G:&=HR<K,________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________O?______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________Z*BIF=H:&=G9V=G9V=G9V=G9V=G9V=G9V9F9H*#@IZ>G)N;
MFIV>G)V=G)R=FYR<FIF9EWEY>F9G9V=G9V=G9VAH:&5F9FEH:&=G9V=G9V9G
M9W)R<HJ+BIR<FYZ>G)N<FIR=FYR=FYR<FYR<FYR<FYR<FYR=FYR<FYV=FYV<
MFYR<FYR<FYR=FYR<FYR=FYR<FYN<FIR=FYR=FYR<FYR=FYR<FYR<FYR=FYR<
MFYR<FYR<FYV=G)R=FYR=FYR=FYR<FYR<FYR;FHV.C8R,C(V-C(:&AG^`?W]_
M?X!_?W]^?GY^?G=W=W)R<G)R<G)R<W%Q<G)R<W)R<W)R<G-T='^`?WY_?G^`
M@'U^?H"`@(*#@HR,BXR,C(N,BYB7EIR<FYR<FYV<FYR<FYR=FYR<FYV=G)R<
MFYR=FYV=FYR<FYV=FYR=FYR=FYR=FYR=FYR<FYR<FYR<FYR<FYR<FYV>G)N;
MFIR<FYR=FYV=FYN<FYN<FIR=FYR<FYR=FYV=FYN;FIV=G)R=FYV=FY&1D'AY
M>6AH:6=G9VAG9VAG9VAH9V9G9V=G9V=G9V=H:')R<Y24DYN;FIR=FYV=G)N<
MFIR<FYR<FXV-C&=H:&AG9V=H:&=G9V=F:&=G9V=F:&9G9VAG9VAG:,K*S/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____[[_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________^C
MHZ9G:&AF9V=G9V=G9V=G9VAG9V=G9V=I:6F<G)N;FYJ=GIR<G)N;FYJ>G9R*
MBXIJ:FIF9V=G9V=G:&AH:&AF9V=H:&AG9F9H9V=R<W.,C(N>GIV<G9N<G)N<
MG)N<G9N>GIR<G)N<G9N<G)N<G9N<G)N<G)N<G9N=G9R=G9N=G9N<G)N;FYJ=
MG9R<G9N<G)N<G9N<G)N<G)N<G)N<G9N<G)N<G9N<G9N<G)N.C8R*B8E^?GY^
M?GYQ<7)R<G-J:FIG:&AG9V=F9V=G9V=F9V=G9V=G9V=G9V=H9V=G9F9G9V=G
M9V=G9V=G9V=H9V=G9V=H9V=H9V=H:&AG9VAF9F9G:&AF9V=H:&AG9V=H9V=G
M9V=F9F9G9V=G9V=G9V=G9V=R<G)R<W-\?7U^?W^&AX:,C(N7EY:;FYJ>G9R<
MG)J<G9N<G)N<G)N<G9N<G)N<G)N<G)N;FYJ<G)N;FYJ>GIV<G)N>GIV<G9N=
MG9N<G)N=G9R<G)N;G)J<G9N=G9R<G9N=G9N;G)J=G9N<G)N5E91X>7AG9V=G
M9V=H9V=G:&AH9V=H9V=G9V=H9V=I:6F#A(2>GIR<G)N>GIV<G9N<G)N;FYEZ
M>7IF9V=H:&AF9V=H9VAG9V=G9VAG9V=H9V=H9VC)R<O_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________\^________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________HZ.F9V=G9V=G9V=G
M9V=G9V=G9V=G9V=G;FYNG)R;G)R;FYN:G9V<G9V;>WQ\9V=G9V=G9VAH9V=G
M9V=G9V=G:&=G9V=G<7-RC8V,G9R;G)R;G)R;G)V;G)R;FYR:G9V;G)V;G)N:
MG9R;G9V;G9V;G)R;G)V;G)R;G)V;FYR:G)R;FYN:GIZ=G)R;G)V;FIN9G9V<
MG)R;EY>6C(R,@X.#?'Q\<W-S:6EJ9V=G:&=G9V=F:&=G9V=G:&AG9V=G:&AH
M9V9F:&=G:&=G:&=G:&=G9F9F:&=G:&AH:&=G:&=G9V=G9V=G:&AH:&=G9V9F
M9V=G:&AH:&=G:&=G:&=G:&AG:&=G:&=G9V9F:6AH9V=G9V9F9V=G:&=G:&AH
M9F9F:&AH:&=G:&AG:&=G:&=G9V=G9V=G:&EI:&AH<G)R>'EY@(&`C(R,F)B7
MG)R;G)R;G9R;GY^=G)V;G)V;G9V<FYN:G9V;FIN9G9V<G)R;G)R;FYR:G)V;
MGIZ=FIJ9G)V;G)V;G)R;G)R;G)R;G)R;G)R;G)R;E964>7EZ9V=G:&=G:&=G
M:&=G9V=G:&AH9V=G9F=G<G)RF9F8FYR:G9V<FYR:G9V<DY.2:&AH9V=G9V=G
M9V9G9F=G:&=H9V=G9V=G9V=HR<G+________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________N_______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________Z.BIF9G9V=G9V9G9V=G9V9G9V=G9V=H
M:'%Q<9V=FYR<FYV=FY24DV]P<&=G9VEH:&=G9V=G9FAH:&AG9VAG9VQL;(J*
MB9R<FYR<FYR=FYZ>G9R=FYR=FYV=G)R<FYR=FYV=FYR=FYR<FYR<FYR=FYN;
MFIN;FIR<FYR<FYR<FYR<FYV=G)R<FYZ>G(V-C'Y_?W5V=FUM;6=G9V9F9F9G
M9V9F9FAG9VAH:&AG9V9G9V=H:&9G9V=G9V=G9VAH:&AG9VAG9VAG9VAG9VAG
M9VAG9VEH:&EH:&=F9FAG9VAG9VAH9VAG9V=F9F=G9VEH:&=G9V=G9V=G9VAG
M9VAH9V=G9V=G9VAG9VEH:&=G9V=G9V=G9V=H:&=H:&9F9FAH:&5F9F=H:&=G
M9V=G9VAG9V9F9FEH:&9F9FAG9VAG9V=G9V=G9V=G9VAH:&IJ:G)R<X&`@(V.
MC9B8EYZ>G)V=FYZ>G9R<FYZ>G9N<FIR=FYZ>G9V>G)R<FYV=G)V>G)N<FYR<
MFYR<FIR<FYR=FYN<FIZ?G9N;FIR<FYZ>G)"0CW)R<V=G9V=G9V=H:&=G9VAG
M9V=G9VAG9VIJ:I&1D)R<FYR=FYR<FYV=G&]O;VEH:&=G9VAG:&=G9VAG:&=G
M9V=G9V=G:,K*S/______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________[W_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________^CHZ9G9V=G9VAG9V=G9V=G9V=G9V=G9V=S<G.<G)N=G9N0
MD(]J:FIF9V=G9V=H9V=H9V=I9V=G9V=F9F9_@'^=GIR:FYF<G9N<G)N<G)N:
MFIF=G9R>GIV<G)N<G)N=GIR;FYF<G)N<G9N<G)N<G)N=GIR<G)N<G)N<G9N8
MF)>*BHEZ>WMR<G-G9V=F9V=G:&AH:&AG9V=F9V=G9VAF9V=I:&AH9V=G9F9G
M9V=H:&AH9V=H:&AH9V=G9F9H9V=H:&AH9V=H:&AG9V=G9V=H:&AF9F9G:&AG
M9V=G9V=F9V=G9V=F9V=G9V=G9V=F9V=G9V=G9V=F9F9G9V=G9V=H:&AG9V=G
M9V=F9F9H9V=G9VAG9V=G9V=G9V=H9V=G9V=H:&AG9F9G9V=F9V=H:6EG9V=F
M9F9G:&AF9F9H9V=H9V=H9V=G9V=H9V=G9V=G:&AF9V=G9V=G:&AN;FYZ>7J&
MAH:8F)><G)N<G)N<G9N;G)J<G)N>GIR;FYJ=G9N<G9N<G)N<G9N;FYJ<G)N<
MG)N:FYF>GIV<G9N;FYJ=GIR=G9N&AX9K:VQH9V=H9V=H9V=G9V9F9V=H:&AG
M9V>'AX:<G)N=G9R=G9N"@H)G:&AG9V=G9FAF9V=H9VAG9V=H9V=G9VC)R<O_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______\]____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
MHZ.F9V=G9V=G9V=G9V=H9V=G9V=G9VAH<G)RG9V;AH>&:6EI:6AH9V=G:&AH
M:&=G:&=G:&=G;V]ODI*1G)R;G)R;GIZ=FYR:G)R;G)R;G9V<G)V;G)R;GIZ=
MG)V;FYN:G9V<G)R;GIZ=G)V;GIZ=G)R;CX^.?X"`<G-S9V=G9F9F9VAH9F9F
M:6AH9V=G9V=G:&AH9F=G9F=G9VAH9V=G9V=H9V=G9VAH:&=G:6AH9V9F9V=G
M:&=G:&=G9V=G9V=G9V=G9VAH<'!P<G)S<7%Q=W=W?W]_?WY^?G]_?G]^?G]^
MAH>&C8V,C8Z-C8V,CHZ-C(V,C(V,C8V,BXN*?GY^?W]_?G]^@("`?WY^>'=X
M<W-S<W)S<'!P9V=G:&AH9V=G:&AH9F9G:&AH9F9F:&AH9V=G9V=G:&=G9V=G
M9V9F9V=G:&AH9V=G:&AG:&=G:&AH9V=G:&=G:&AH9V=G9F9G9V=G;FYN?7Q\
MC8R,GIV<G)R;G)R:G)V;G)V;G)V;G)V;G)R;G)V;G)R;G9V;G)R:G)V;G9Z<
MG9Z<G)R;G)V;FYR:F)B7=75U:&EI:&AH9V=G9F9F9V=G:&AH9V=G@(&`G)R:
MG)R;C8V-9V=G9F=G9V=H9V=G9V9G9V=G:&=G:&=HR<G+________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________O?______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________Z.CIF=G9V=G9V=G
M9V=G9V=H:&9G9V=G9W-S<X:'AF=G9VAH:&=G9VAH:&AH:&AG9V=G9WM\?)R<
MFYR<FYR=FYV>G)N<FIV=G)R<FYN=FYR<FYV>G)R<FYR<FYV=G)V=FYR=FYV=
MG)N;FHJ+BG=X>&UM;F=G9VAG9VAG9VAG9VAG9VAG9V=G9V9G9V=G9V=G9V=G
M9V=G9FAG9V=G9V=G9V=G9V=G9V=G9V=G9VQM;7-S<WQ\?']_?XF*B8R,BY&1
MD)R<FYR<FYR<FYV=FYV=FYN;FIR<FYR<FYR<FYR=FYR=FYR<FYR<FYR<FYV=
MG)R<FYR<FIV=FYR=FYR<FYV>G)R<FYR=FYR=FYV>G)V=G)J;F9V=FYR<FYR<
MFYR<FY65E(R,BXJ*B7]_?WU]?7)R<G%P<&AG9V=G9V=G9VAH:&=G9V=G9V9G
M9V=G:&=G9VAG9V=G9VAG9V=F9FAG9VAH:&=G9VAG9VAG9VAG9VAI:7EZ>H6&
MA9>8EYR=FYN;FIR=FYR<FYR=FYV=G)R<FYV>G)V=FYR<FIR<FYR=FYR<FYR<
MFYR=FYR=FX6&A6EJ:F=G9VAG9VAG9VAG9VAG9V=G9WEZ>9V=G)R<FF=G9V=G
M9VAG:&=G9V=G:&=G9VAG9V=G:,G*S/______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________[W_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________^CHZ9H:&=G9V=H9V=G9V=H9V=G9V=H
M9V=N;6UG9V=H:&AH9V=G9V=I:&AG9V=J:VN)BHF<G9N<G)N=G9R<G)N=G9R<
MG)N=G)N<G)J=G9N<G)N<G)N<G)N<G)N<G)N;FYJ.CHUY>7EI:6EG9V=G9V=H
M:&AG9V=G9V=F9F=I:&AH9V=G9V=H9V=I:&AH:&AG9F9H9V=G9V=F9V=L;&UR
M<G)^?WZ)BHF.CHV=G9N<G)N=G9N<G)N<G)N<G9N<G)N<G9N=G9N<G9N<G)N<
MG9N<G)N<G9N<G)N=G9N<G)N<G9N<G)N<G)N<G9N=G9N<G)N<G)N<G)N<G9N<
MG9N=G9N<G)N<G)N<G)N<G9N<G9N<G)N<G9N<G)N<G)N<G)N<G)N<G)N<G)N<
MG)N<G9N=G9R<G)N<G9N;FYJ1D9")B8E_?GYV=79N;F]G9V=G9V=H9V=H9V=H
M9V=H9V=H9V=G9V=H:&=H9V=G9V=G9V=H:&AH9V=H:&AG9V=G9V=V=G:)BHF;
MFYJ=G9R<G)N<G9N<G9N<G)N;G)J<G)N<G)N<G9N<G9N<G)N;G)J=G9R<G9N1
MD9!L;&UH9V=G9V=G9V=H9V=H9V=G9V=^?W^?G9QF9V=G9V=G9VAG9V=H9VAF
M9V=G9V=G9FC)R<O_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________^]____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________HZ.F9V=G9V=G:&=G:&=G:&AG9V=G9V=G:&AH9V=G:&=G
M9V=G:&=G9V=G;6UMD)"/G)R;G)R:G)V<FYR:G)V;FYR:G9Z<G)R;G)R;G9V<
MG)R;G)V;FYN:E)63?W]_;6UM9V=G9V=G9V=G9V=G9V=G:6AH9V9F:&AG9V=G
M:&AH9VAH9V=G:&AH9F=G:6EI=G9W?WY_C8V-EY>6G)R;G9V;G)R;G)R;FYN:
MG9Z<G)V;G)R;G)R;G)V;G)V;G)R;G)V;G)R;G)R;G)R;G)R;G)V;G)R;G)R;
MG)V;G)V;G)R;G)V;G)V;G)R;G)V;G)R;FYN:G9V;G9V;G)R;G)R;G9V;G)R;
MG)V;G)R;G)R;G)V;G)V;G)R;G9V;G)R;G)V;G)V;G)R;G)R;G)V;G)V;G)R;
MG)V;GI^=G)V;G)R;G9R;G)R;G9V;G9V;C8Z-@X.#='5U;6YM:&AH9V=H9V=G
M9V=G9V=G9V=G:&=G:&=G:&AH9V=G9V=G9V=G9F9F9V=G:VMK>'=XD)&0G)R;
MG)V;G)R;G9Z<G)V;G)R;G)R;G)R;G9V<G)R;G)R:G9Z<G9R;F9F8;FYO9V=G
M9F9F9V=G:6AH9V=G9VAHAH:&9F=G9F=G9V9G9F=G9V9G9V=G9V=G:&=HR<G+
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________//__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_Z*BIFAG9V=G9VAG9V=G9VAG9VAG9VAG9V9F9F=G9V=G9V=G9V=G9W!P<)B8
MEYR<FYV=G)Z>G)V>G)N;FIR=FYN;FIN<FIV=FYR<FIN<FIV>G(F)B75U=6=H
M:&EH:&=G9VEI:6AG9VAG9VAH:&AG9V=G9V=G9V=G9VAG9V=G9VIJ:G5U=8*"
M@I&1D)Z=G)R;FIR<FYN<FIZ>G9R<FYR=FYR<FYR<FIV>G)R<FYR=FYR<FYR<
MFYR<FYR<FYR<FYR<FYR=FYR<FYR=FYR<FYR<FYR<FYR=FYV=FYR<FYR<FYR<
MFYR<FYR<FYR=FYR<FYR=FYR<FYR=FYR<FYR<FYV=G)R<FYR<FYR<FYR=FYR=
MFYR<FYR<FYR=FYR<FYR=FYR<FYR=FYR<FYR<FYR<FYR<FYR<FYR<FYV=FYR=
MFYR<FYN;FIV>G)R<FYR<FYR<FYV=FYR<FY24DX:&AGEY>FUM;69G9V=G9VAG
M9VAH:&9F9F=H:&9F9FAG9VAH:&=G9V=G9F=G9V=G9W!P<(>'AYR;FIV=G)N;
MFIR=FYV>G)Z>G)R<FYJ:F9V=G)N;FIV=G)N;FIV=FWAY>6=G9VAG9V=G9V=G
M9V=H:&9F9F=G9V=G9V=G:&=G9V=G:&=G9V=G9V=G:,G)R_______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________S[_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________^CHZ9G9V=H9V=H
M:&=H9V=G9V=H9V=H9V=G9V=G9V=H:&=H:&AO;V^8EY:=G)N<G)N<G)N;G)J<
MG9N<G)N=GIR=G9R<G)N=G9R=G9N&AH9L;&QG9V=H:&=H9V=H:&=G9V=F9V=H
M9V=G9V=G9F9G9V=G9V=G9V=N;V^!@("1D9"=G9N<G)N=G9N=G9R:FYF=G9N<
MG)N<G)N<G)N<G)N=G9R<G)N;FYJ<G)N=G9N<G)N<G9N<G9N<G9N<G)N<G)N<
MG9N<G)N<G)N<G)J<G)N<G9N<G9N<G)N<G)N<G9N=G9N<G)N<G)N<G9N<G9N<
MG)N<G)N<G)N=GIR<G9N<G)N<G)N<G9N<G)N<G9N=G9N<G)N<G)N<G9N<G9N<
MG9N<G)N<G)N<G)N<G9N<G)N<G9N<G)N<G)N<G)N<G9N<G9N<G9N<G)N<G)N<
MG)N=G9R<G9N<G9N<G)N<G)N>GIV<G)N>G9R4E)."@X)U=G9G:&AH:&AH9V=I
M:&AF9F9H:&=I:&AG9V=F9V=G9V=H9V=G9V=J:FI^?WZ9F9B<G)J<G)J=G9R:
MFYF>GIV:FYF>GYV=G9N=G9R;G)J=G)MX>7EG9V=H9V=H9V=G9F9G9VAG9V=G
M9V=G9VAG9V=G9FAF9V=G9V=H9VC)RLS_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________^^____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________HZ.F9V=G:&=G9V=G:6AH:6EI:&=G
M:&=G9V=G:6AH9V=G:6IJFIF8FYR:G9Z<G)R;G9V;G)V;G)R;FYR:G)R;G)V;
MF)B6?GY^:FMK9V=G:&AH9V9F:&=G:&=G:&=G9V=G:&AH9V=G9V=G:&AH=G9V
MAH>&E)23G9Z<FYN:G)R;G)V;G)V;FYN:G)R;GIZ=G)R;G)R;G9V;G)R;G)V;
MFYN:G)V;GIZ=G9R;G)R:G)R;G)V;G)V;G)R;G)R;G)R;G)R;G)R;G)R;G)R;
MG)R;G)V;G)R;G)V;G)R;G)R;G9V<G)V;G)R;G9V;G)R;G)R;G)R;G)R;G)R;
MG9V;G)R;G)R;G)R;G)R;G)V;G)R;G)R;G)R;G)V;G)R;G)V;G)V;G)V;G)V;
MG)V;G9V<G)V;G)R;G)R;G)R;G9V<FYR:G)R;G)R;FYN:GIZ=FYN:G)R;G9V;
MG)R;G)R;FYR:G)V;FYN:G9Z<FYR:FYN:F9F8AH6%>7EY:6EI:&AH9V=G9F9G
M9V=G:6AH:&=G9V=G9V=G9VAH9V=G:6IJ?W]_F9F7G)R;G9Z<FIJ9G)V;G)R;
MG)V;G)R;G)R;G)R;G9R;;V]P9F9F:&AH:&=G:&AH9V=G9V=G:&=H9V=G9V=H
M9V=G:&=G9V9GR<G+____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________/O__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________Z*BIF=G9V=G9VAG9VAG9VEI:6AG9V=G9V9F9F=G9VIK
M:Y"0CYV=FYV=FYR<FYR=FYV>G)R<FYV=G)V=FYV=FX*"@FIJ:FAH:&9F9F=G
M9V9F9FAH:&9F9FAH:&=G9VAG9V9G9V]O;XB'AY:6E9V=FYR<FYV=FYN;FIN=
MFYZ>G9J;F9V=FYV=FYR=FYR<FIR=FYR=FYR=FYR<FYV=FYR=FYR<FYR=FYV=
MFYR=FYR<FYR<FYV=FYR=FYR<FYV=FYR<FYV=FYR<FYR=FYR=FYR=FYR<FYR=
MFYR<FYR<FYR<FYR=FYR<FYR<FYR<FYR<FYR<FYV=FYR<FYR<FYR<FYR<FYR<
MFYR=FYR=FYR<FYR<FYR<FYR=FYR=FYR<FYV=FYR<FYR=FYN<FIV=FYR<FYR<
MFYV=FYN<FIR<FYR<FIR<FYR<FYR<FYN;FIZ>G)N;FIZ>G9R<FYR<FYZ>G)V=
MFYR<FYR<FYN;FIV=G)R<FYV=G)R<FY^?G8:&AG9V=F=G:&AH:&AG9VAG9VAH
M:&AH:&AG9VAH:&9F9F=G9VIJ:G^`@)>7EIZ=G)N;FIR<FYZ>G9N<FIR=FYR=
MFYR<FYF9F&UM;6AH:&AG9VAH:&=G9V=G9VAG:&=G9VAG:&=G9V=G9VAG:,G)
MR___________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________S[_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__^CHJ9H:&AH9V=H:&=H:&AG9V=H9V=G9V=H9V=G9V>"@H*>G9R=G9R;FYJ=
MGIR<G)N<G9N<G9N<FYJ*BHEM;6UF9F9H:&AG9V=G9V=F9V=H:&AF9V=G9V=F
M9V=I:6E[>WN4E).=G9N;FYF>GIV<G)N<G)N=GIR:FYF=G9R<G9N<G)N<G9N<
MG)N<G)N<G9N<G)N=G9N<G)N<G)N<G9N<G)N<G)N<G)N<G9N<G)N<G9N<G)N<
MG)N<G)N<G)N<G)N=G9N<G9N<G9N<G)N<G)N<G9N<G)N<G)N<G)N<G)N<G)N>
MGYV<G)N;FYJ=G)N=G9N=G9N<G)N<G)N;FYJ<G)N>GIV<G)N<G9N=G9N<G)N<
MG9N<G)N<G9N<G)N<G)N<G)N<G)N=G9N=GIR<G9N<G)N<G)N<G)N<G)N<G)N<
MG)N<G)N=GIR;FYJ;FYJ=GIR=G9N<G)N=G9R>GIR;FYJ=G9R;G)J<G)N>GYV:
MFYF<G)N=GIR<G)N:FYF?GYZ=G9N5E92"@8%M;6UG:&AF9F9H:&AG9V=H9V=H
M9V=G9V=G9V=G9V=J:FJ"@H*<G)N<G)N<G9N<G9N<G)N<G)N<G9N<G)N2DI%F
M9F=H9V=G9V=G:&AG9V=G9VAG9V=G9VAF9V=H9V=H9VC)R<O_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________^]____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________HJ*F:&=G:&=G
M:&AH9V=G:&=G9V=G9V=G9V=G<7)RFYN:G9V<FYR:G9V<FYR:G9V<G9V;E)23
M<7)R9V=G9V=G:&=G9V=G:&=G9V=G9V=G9V=G:&AH;V]PAH:&G)R;G)R;G)R;
MG)R;G)V;G)R;G)R;G)V;G)V;G9Z<G9V;G9V;G)R;G)R:G)R:G)V;G9V;G9V;
MG)R;G)R;FYN:G)R;G)R;G)R;G)V;FIN9G)R;G)V;G)V;G)R;G)R;G)R;G)V;
MG)R;G)V;G)R;G)R;G)V;G)V;G)R;G)R;G)V;G)R;G9Z<GIZ=EY>6C8V-C8Z-
MC8V,C(R+C8V,C8V-C8V-DY23FYN:G9V;G)R;G)V;FYN:G)R;G)R;G)V;G9V;
MG9V;G)V;G)R;G)R;G)R;G)R;G)R;G)V;G)V;G)V;G)V;FYN:G)V;G)R;G9V;
MG9Z<G)V;G)R;G)R;G)R;G)V;G)R;FIJ9G)V;G)R;G)V;GIZ=G)R;G9V;G)V;
MG)R;FIN9GIZ<FIN9G9V<G)V;BHJ)<G)R9V=G9F9F:6AH:&=G9V=G:&AH9V=G
M:&AH9V=G;&YMC8Z-G9V<G)R;G9Z<G9V;G)R;G)R;G)R;?W]_9F=G:&AH9V=G
M9V=G:&=H9V=G9V9G9V=H:&=G:&=HRLK,____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________/?__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________Z.CIF=G9V=G9V=G9V=G9V=G9V9F
M9F=G9V=G9Y24DYR=FYR<FYR=FYR<FI^>G9R<FG]_?VEJ:F9G9VAG9V=F9FAG
M9VAG9V=G9VAH:&=G9W)R<HR,BYR<FIR=FYR<FYN<FIV=G)R=FYR<FYR<FYR<
MFYV=G)V=FYV=FYR<FIV=FYN<FYR<FYR=FYR<FYR=FYR<FYR=FYR<FYV=G)N<
MFIR=FYN;FIR=FYV=FYV=FYR<FYV=G)R<FYR<FXV-C8V.C8*#@GY_?X"`@')R
M<G)R<G)R<FYM;6=F9FAG9V=G9V=H:&=G9V=G9V=G9V=G9V=G9V=H:&=G9V=G
M9V=H:&=G9V=G9V=G9V=H:&9G9V=G9VUM;7)R<G)R<G)R<GQ\?'Y_?W^`@(R,
MBXV-C)B8EYV=FYR<FYR<FIR=FYR=FYR=FYR=FYR<FYR<FYJ;F9R<FYR<FYV=
MFYR<FYR=FYR=FYR<FYZ>G9N;FIR<FYZ>G9R<FYR<FYR<FYR<FYV=FYN<FIV>
MG)R=FYR=FYR<FYR<FY24DWEZ>6=G9V=G9VAG9VAG9V9G9VAG9V=G9VAG9V=G
M9WQ\?)F9F)V<FYR<FYR<FYN<FIR<FYB8EVQM;6=G9VAG9V=G9V=G:&=G9V=G
M:&=G9VAH:&AG:,G)R___________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________[S_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________^CHZ9G9V=G9V=G9V=G9V=G9VAG9V=G9V=J:FJ<G)N;
MFYJ<G)N<G)N>G9R3DY)P<'!F9F9G9V=G9V=G9V=G9V=G9V=G9V=G:&AR<G.-
MC8R<G)J?GYV;FYJ<G9N<G)N<G)N<G)J<G)N<G)N<G)N=G9R;G)J=G9R<G9N<
MG)N;G)J=G9R<G)N<G)N<G)N<G9N=G9N;FYJ<G)N;FYJ=G9R;FYJ8F):+BXN"
M@X)^?W]R<G)S<W-F9V=G9V=G9V9H9V=H9V=H9V=F9F9G9V=G:&AG9V=G9V=G
M9V=H:&=H9V=G9V=F9V=G:&AF9F9H:&AG9V=G9V=F9F9F9F9G:&AG9V=G:&AH
M:&AG9V=F9V=G9V=G9V=G9V=H9V=H:&AH9V=H9V=H9V=H9V=G9F9H:&AF9F9O
M;W!R<W-[?'Q^?W^-CHV3DY*?GIV:FYF=GIR;FYJ=GIR;G9N;G9N=GIR<G)N=
MG9R<G)N<G)N>GIV9FIB<G9N=GIR=G9R;G)J=G9R;G)J<G)N<G)N=G9R<G9N=
MG9R<G)N=G9N5E91Y>7EG9V=G9V=F9V=G9V=H9V=H:&=G9V=G9V=L;&R.CHV=
MG9N<G9N<G9N=G9N<G)N'B(=F9F9H:&AG9V=G9VAG9V=G9VAG9V=H9V=G9VC*
MRLS_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________\^________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____HZ.F9F=G9F=G9VAH9V=G9V=G9V=G9V=G<'!QG)R;GIZ<G)R;G9R;BHJ*
M:6IJ9V=G:&AH9V=G:&AH9F9F9V=G9V=H;G!OC(R+GIV<G)V;FYR:G)V;G9V<
MG9V<G)V;G9V;G)R:G)R;G9V<G)R;FIN9GIZ<FIJ9G)V;G)R;G9V<G)R;G9Z<
MGIZ<G9V;G)R;G)R:D9&0B(>'?GY^<G)R:6IJ9F9G9VAH:&AG9V=G9V=G:&AG
M:&=G:&=G:&AH:&=G:&=G:&=G9V=G9V=G9V=H9F9F:&AH9V=G9V=G:&=G9V=G
M9V=G9F9F:FEI9V9F:&=G9V9F:&AG:&=G9V=G9V=G:&=G9V=G:&=G9V=G:&=G
M:&=G:6AH:&=G9V=G:6AH9V=G:6AH:&=G:&AH9F9F:6EI9V=G:6AH9F=G9V=H
M9V=G:&=G9V=G='1T?'M[AH>&D9&0G)R;G)R;FYN:G)V;G)V;GIZ<G)V;G)V;
MGI^=FYR:G)R;G)R;G)V;G)R;G)V;G)R;G9V<G9Z<G)R;G)R;FYN:G9Z<FYR:
MGYZ=E)23<7)R9V=G9V=G9V=G:&=G9V9F:&=G9V=G9V=G?W]_G)N:G)V;G9Z<
MG9V<G)R;:VQK9V=G9F=G9V=H9V=G:&=H9V=G:&=G9V=HR<K,____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________/?__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________Z.CIF=G9VAH
M:&=G9V=G9V9F9F9G9V=H:'-S<YR=FYJ:F9R<FGM\?&AI:69F9FAG9VAG9VAG
M9V=G9V=G9VEJ:H.$@YR<FY^?G9N;FIV=FYN<FIR=FYR<FYR=FYR=FYR=FYV>
MG)R<FYR=FYR<FYZ>G9N;FIZ>G9V=G)R=FYR<FIV=G)R<FHV-C'Y_?G-S=&IJ
M:F=G9V=G:&AG9VAH:&AG9V=G9F=G9V=G9FAH9VAH:&=H:&=G9V=G9V=H:&=G
M9V9G9V=G9VAG9V=G9V=F9FEI:6=F9FEH:&AG9VAH:&=F9F=G9VAG9VAH9VAG
M9VAG9VEH:&=F9F=F9FAH:&AH:&AG9VAH:&=G9VAH:&AG9V=G:&=H:&9G9VAI
M:69F9V=G9V=G:&AH9V=G9V=G9V9F9FAG9VAG9VAG9V=G9VAH9VAG9VAG9VAG
M9VEH:&=G9VAH:&=G9W-R<WM\>XJ*BIB8EIN;FIR<FYV=G)N;FIR<FYR<FYR<
MFYR=FYR=FYN<FIR<FYZ>G9N<FIR<FYR<FYZ>G9R<FYN;FIN;FIV=FYR<FXR-
MC&UM;6=H:&9F9FEH:&=F9F=F9FAG9VAG9W9V=I>7EIR=FYV>G)N<FG=X>&AH
M:&9G9VAG:&=G9V=F:&=G9VAH:&AG:,G)R___________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________S[_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________^CHZ9G9V=F9V=G9V=F9V=G9V=G
M9V=F9F9R<G.<G)N8F)9Y>GIG9VAH9V=H9V=H9V=H:&AG9V=G:&AU=76:F9B;
MFYJ=GIR;G)J<G)N<G9N=G9R<G)N;FYJ=G9R=G9R<G9N<G)N=G9R<G)N=G9R<
MG)N<G9N>GIR<G)J-C8R`?W]O;V]H:&AG9V=G9V=G9V=H9V=H9V=G9VAG9V=F
M9F9H:&AE9F9H:&AG9V=G9V=G9V=H9V=H9V=H:&AG9F9G9V=H9V=H9V=H9V=H
M9V=I:&AG:&AG:&AH:&AG9V=F9V=G9V=F9V=F9V=Q<7)S<W-S<W1Q<7%S<W1T
M='1P<'!J:FIG9V=G9V=G9V=G9V=G9V=G9V=G9V=H9V=G9V=H9V=I:&AH9V=H
M:&AH9V=H:&AH9V=H:&=H9V=G9V=H:&AG:&AE9F9F9V=G9V=F9F9G9V=G9V=H
M:&AG9V=G9V=G9V=G9V=P<'%\?7R)B8F8F)>=G)N<G)N<G)N<G)N<G)J>GIV;
MG)J<G9N<G9N<G)N=G9R<G)N=G9N=G9R;FYJ=G9R<G9N=G)N<G)J`@(!G9V=G
M9V=H9V=H9V=G9V=G9V=G9V=O<7"8F):;G)J>GIR)BHEG:&AG9V=G9VAG9V=H
M9VAG9V=H9V=G9VC)R<O_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________^^________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________HZ.F9F=G9V=G9V=G9V=G9V=G9VAH9V=G<W-SF)B6
M;W!P9V=G9V=G:&AH9V=G9V=G:&=G:6EIBHJ)G9V;G)R;GIZ=G9V<G)V;G)R;
MG9V;G)V;G9V<G9V<FYR:FYR:G)R;G)R;G9V<G)R;G)R;F)B7AH>&=75U:FIJ
M9V=G9F9G9VAH9VAH:&=G9V=G:&AH9V=G:&=G:&AH9F9F9V=F:&=G:&AH9V=G
M9F9G9F=G:&=G9V=G9V=G9V=G;&QL<G)S=75U?WY^?G]_AX>'C(V,C8V,C8Z-
MG)R;G9V<G)R;G)V;G)R;G)V;G)V;G)R;G)R;G)V;FYR:FYR:GIZ=G)R;G9V;
MGI^=G)V;G9V;G)R;D)&/C(V,C(V,BHF)@("`?GU^>7AY<W-S<'!P9VAH9F=G
M9V=G9V=G9V=G9V=H9V9F9V=G:&=G:&=G:&=G9V=G9F9F9V=G9VAH:&AG9V=G
M:&AG9F9F9V=H9F9F9V=H<G)S@X.#E)23GIV<G)R;FYR:GY^=FYN:G)V;GIZ<
MFYN9GIV<G)R;G)R;GIZ<FYN:G9V<G)R;G9V<G9R;D)&0;&QL9F9F:&=G:&=G
M9V=G9V=G9F9F;6UMD)&0FYN:E)239F=G9V=G9V9G9VAH:&=H9V=G:&=G9V9H
MRLK,________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________O?______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____Z.CIF=G9V=G9V9G9V=G9V=G9V=G9VAH:'%Q<7!P<&=G9V=G9VAG9VAG
M9V=H:&=G9V]O<)24DYR=FYN;FIR<FYN;FIR=FYR<FYN;FIJ;F9Z>G9N<FIR=
MFYZ>G9N<FIV=FYV=FY24DX.$@V]O;V9G9V=G9V=G:&=G9VAG9VAG9VAG9V=G
M9VEH:&=G9VAG9VEH:&AG9VAH:&EH:&AG9V=G9VAH:&QL;7-S<W]^?H:'AHV-
MC)24DYV=G)Z>G)R<FIR<FYV=G)V>G)J;F9Z>G9R<FYR=FYR=FYV>G)R<FYR<
MFYZ>G)R=FYR<FYN<FIR<FYR=FYR<FYR=FYR<FYR=FYR<FYV=FYR<FYR<FYR<
MFYR=FYV=FYV=G)R<FYJ:F9V=G)R<FYR<FYR=FYR<FYB8EXR-C(>'AW]_?W9U
M=G!O;VAG9V=G9VAH9VAG9V=G9VAH:&AG9VAG9V=G9VAG9V=G9VAG9VAG9VAG
M9VAG9V=G9V9F9FAH:&]O;WU\?9.4DYR<FYR<FYV>G)N<FIZ>G)R<FYR<FYV=
MFYN<FIV=G)R<FYV=G)R<FYV=G)V=G)B8EWI[>F=G9V9G9VAH:&AG9VAG9V=G
M9VIJ:I65E)N;FF=G9V=G9V=F9V=G9VAG:&=G9VAG9V=F:,G)R___________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________[W_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________^CHZ9G9V=F
M9V=G:&AG9V=H:&AF9V=F9V=J:FMG9V=G9V=G9V=H:&AG9V=G9V=Y>'F>G)N<
MG9N<G)N<G)N;FYJ=G9N<G9N=G9R<G9N=GIR;G)J=G9R<G)J<G)N8F)>&AH9U
M=75H:&EG9V=G9V=H9V=H9V=H9V=H9V=H9V=G9V9H9V=H9V=G9V=G9VAG9V=F
M9V=G9V=R<W-Z>WN&AX:-C8R<G)N<G)N<G9N<G)N<G)N<G)N=G9R;FYJ<G9N=
MG9R<G)N<G9N<G9N<G)N<G)N<G9N<G)N;FYJ<G9N<G9N<G)N<G)N=G9R;FYJ=
MG9R;FYJ<G)N<G)N<G)N=G9N=GIR<G)N<G)N<G)N<G9N<G9N<G9N=GIR=G9N=
MG9N<G)N<G9N;G)J<G)N<G9N=G9R<G)N=G9R;FYJ=G9N<G9N<G)N<G)N1DI&&
MAH9_@(!S<W-H9V=H9V=G9V=G9V=G:&AG9V=G9VAH9V=H9V=G9V=G9V=H:&AH
M9V=H9V=H:&=G:&AO;W""@H*8F)><G9N<G)N<G)N;FYJ<G)N=G9R;G)J=G9N<
MG9N<G)N<G)N<G)J<G)N<G)N#@H)G9V=G9V=F9F9H9V=H9V=H:&AN;V^8F)9G
M9V=G9V=G9F=G9V=H9VAG9VAG9V=G9VC*RLS_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________^]________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________HJ*F9V=G:&=G:&=G:&AG:&=G
M:&=G:&=G:&=G:&=G9V=G:&=G:&=G9V=G?X"`G)R;G)R;G)R;G)R;G)R;G)R;
MG)V;G)R;G)R;G)R;G9V;G)V;G)R;D)&/>GEZ:FIJ9V9F:&=G9V9F:6AH9V9F
M:&AG9V=G:&AH:&AH9F9F9V=G:&=G9V=G:FIJ=G9V@H.#C8V,G)N:G)V;G)V;
MG)V;G)R;G)R;G)R;G)V;G)R;G)R;G9V<G9V<G)V;G9V<G)V;G)R;G)R;G)R;
MG)V;G)R;G)R;G)V;G)R;FYN:G9V;G)R;G)V;G)V;G)V;G)V;G)R;G)V;G)R;
MG)V;G)R;G)R;G)V;G)R;G)R;G9V<G)R;G)R;G)V;G)R;GIZ=G)R;G)R;G)V;
MG)R;G)V;G)R;G)R:G)V;G)V;G)R;FYR:G)R;G9V;G)R;FYN:G)R;GIZ=FIN:
MD)&0A8:&>'EY;6UM9V=G9V=G9V=G9V=G9V=G9V9F:&=G:&AG:&=G9F=G9VAH
M9V=G9V=G9V=G=G5VB8J)G9V;G)R:G9V;G9V<GIZ=G)R;G)V;GIZ=FYR:G)R;
MG)R;G9V<G)R;AH>&:6IJ9V=G9V=G9V=G9V=G9V=G<7!P9V=G9V=G:&=H9V=G
M:&=H9V=G9V=G:&=HR<K,________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________/O______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________Z.CIFAG9V=G9VAG9V=G9VAG9V=G9V=G9VAG9VAH
M:&AH:&=F9FAH:(>&AIR<FIR<FYR<FYR<FYN;FIZ>G)R=FYN<FIV>G)R<FYN;
MFIR<FX>'AW-S<V9F9F=H:&9F9FAH:&9G9VAH:&=F9FEH:&=F9F=G:&AH:&9F
M9F=G:'9W=H&"@9&2D)V=FYV=FYN<FIR<FYV=G)R=FYR<FYR<FYR=FYR<FYR<
MFIR<FYR<FYR<FYR<FYN;FIR=FYR=FYR=FYN;FIR=FYN<FIV=G)V=FYN<FIN;
MFIV>G)V=G)R<FYN;FIV=G)Z>G9Z>G9R<FYR<FYR=FYR=FYR<FYN;FIV=G)J;
MF9V=G)Z?G9J;F9R=FYR<FIZ>G9R<FYJ;F9R<FYV>G)R=FYR<FYR=FYR=FYV>
MG)J;F9R<FYR<FYV>G)R=FYR=FYR=FYZ>G9R<FYR<FYR<FIR<FYR<FYV=FYZ>
MG)24DX6&A7EY>6MK:V9F9F=G9V=G9V=G9VAH:&=F9F=G9VAG9V=F9F=G9V=H
M:&=G9VQM;8*#@I>7EIR=FYN<FIV=G)V=G)J;F9^?GIR=FYV=FYR=FYR=FYR=
MFY&1D&IK:V=F9FAH:&=G9V=G9V=G9VAH:&=G9VAG:&=G9V=G:&=H:&AH:&=F
M9\G)R_______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________S[_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______^CHZ9H9V=H:&AH:&=H9V=H:&AH9V=H9V=G9V=H9V=G9V=G9V>'AH:=
MG9N<G)N;FYJ<G)N<G)N>GIV:FYF<G9N=G9N=G9N8F)>'AX=M;6UF9F9G9V=G
M9V=H9V=G9V=F9F9H:&AG9V=I:&AG9V=G9V=K;&QY>GJ*BXJ<FYJ;FYJ<G)N<
MG9N<G)N<G9N=G9N=G9R;FYJ<G9N<G)N<G9N<G)N<G9N<G)N<G9N<G)J<G)N<
MG9N=G9R<G)N=GIR;FYJ=G9R<G)N=G9R=GIR;FYJ<G9N<G9N<G9N<G)N;FYJ=
MG9R<G)N:FIF<G)N<G)N<G)N<G)N<G9N<G9N;G)J<G9N<G9N<G9N;FYJ<G9N<
MG9N=G9R;G)J<G9N=G9R<G)N<G)N=GIR:FYF<G9N<G)N<G)N<G9N<G9N<G)N<
MG9N<G)N<G9N<G)N<G)N<G)N<G)N<G)N<G)N<G)N<G9N;FYJ<G9N=GIR<G)N;
MFYJ2DI%[?'QL;&UG9V=G9V=F9V=F9F9H9V=H9V=H:&AG9V=H9V=F9F9G9V=J
M:FI_@'^8F)>=G9N<G)J=G9R;FYJ<G)N;FYJ=G9N;FYJ=G9R<G9N-C8QG9V=H
M9V=H:&=G9V=H9V=H9V=G:&AG9FAG9V=H9VAG9VAH9V=G9VC)RLS_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________HZ.F:&=G
M9V=G9V=G:&=G:&=G:&=G:&=G:&=G:&=G9VAH>7EYGIV<G)R;G)R;G9Z<G)R:
MG)R;G)V;G)V;G9V;G9V;?X!_:VMK9F=G9VAH:&AH9F9F:6AH9F9F:&AH9V=G
M:&=G9V=G:6IJ?7Q]CY".GIZ<G)V;FYN:G)V;FYN:GIZ<G)R;G)R;G9Z<G)V;
MFIN9G)V;G)R;G)R;G)V;G)V;G)R;G)V;G)R;G)R;G)R:GIZ<G)R;G)R;G)V;
MFYN:G)V;G)R:G)R;G)R;G)R;G)R;G)V;G9V<G9V<G)R;G)R;G9V;GIZ<G)R;
MG)R;G9Z<G)R;G)V;G9V<G)V;G)V;G9V;G)R;G)V;GIZ=FYR:G)R;G9Z<G)R;
MFYN:G)V;G)V;G)V;G)V;G9V;G)R;FIN9GIZ=G)V;G)R;FYN:G)V;G)R;G)R;
MG)R;G)R;G9V;G)V;G)V;G)V;G)V;G)R;G)V;G)R;G)V;G)V;G)R;G9V;GIZ<
MD)"/?'U\;&QL9V=G9F=G9V=G:&=G:&=G9V=G9V=G:&=G9F=G9V=H:FIJ?X"`
MF)B7G)R;G9Z<G)R;G)V;G)R;GIZ<FYR:G)R;G9V;AX:&9V=G:&AH9V=G:&AG
M9F9F9V=G9V9H9F=G:&=H9V=G:&=G9V9GR<G+________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________O/______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________Z*BIFAH:&=G9V=G9VAG9VAG
M9VAG9VAG9V=G9V=G9W)R<YZ=G)V=FYN;FIR=FYJ;F9V=G)V=G)R=FYV<FX6&
MA6QL;&=G9V=G9V=G9V9F9F=G:&AH:&AG9VAG9V9G9V=G9WEY>8J*B9V<FYZ=
MG)V=FYN<FIR<FYR=FYN;FIR<FYR<FYN<FIR<FYR<FYR<FIV<FYV<FYR=FYR<
MFYR<FYR<FYR=FYR<FYR<FYR=FYR=FYV>G)N;FIV=G)R<FY^?GIN;FIR<FYR<
MFYN<FIR=FYR=FYR<FYN<FIR<FYR=FYZ>G9N<FIR<FYR<FYR<FYR<FYR=FYR=
MFYR<FYR=FYR<FYN<FIV=FYN<FIR<FYR<FYV=FYR<FYR=FYV=G)R=FYR<FYR<
MFYR=FYV=FYR=FYR<FYV=FYR<FYV=G)R=FYV=FYR<FYR<FYV=G)V=FYR<FYR<
MFYR<FYV=FYN<FIN;FIR=FYR<FYN<FIR<FYR<FYN;FIR<FYV=FYR<FYR<FY"0
MCWAY>6MK:V9F9VAG9VEH:&=F9FAG9VAH:&9F9FAH:&=G9VEJ:GY_?IF9F)N;
MF9Z?G9N;FIR=FYN<FIR=FYN;FIR<FWQ\?&=H:&AG9V=G9V=H:&=H:&=G:&=G
M9VAG:&=G9V=G9V=F9\G*R_______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________SS_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________^BHJ9G9V=G9V=H9V=H9V=G9V=H9V=H9V=H9V=J
M:FJ4E).<G)N:FYF=GIR<G9N<G9N<G)N;FYJ.CXYM;VYG9V=G9V=G9V=H9V=H
M:&AH:&AG9V=H9V=G9V=L;6V"@H*8F)>;FYJ<G)N<G9N>GIR;G)J=GIR;G)J=
MG9N<G9N=G9N<G)N;FYJ<G)N<G)N<G)N=G9R<G9N<G)N<G9N<G9N<G)N<G)N<
MG)N<G)N<G)N<G)N;G)J>GIV<G)N=G9R<G)N;FYJ<G9N=G9R<G9N<G)N;G)J<
MG)N=G9R=G9R<G)N<G9N:FYF<G9N=G9N>GYV<G9N<G)N<G9N=GIR;G)J<G)N<
MG9N<G)N=GIR=GIR<G)N<G)N<G)N<G9N;G)J<G)N<G9N<G)N<G)N=G9R;FYJ<
MG9N<G)N>GIV:FYF<G)N<G)N=G9R<G9N;FYJ;G)J<G)N<G9N<G)J<G9N;G)J=
MG9R:FYF>GIV=G9R<G)N<G)N<G)N<G)N<G)N;FYJ=G9R<G)N=G9R7EY6&AX9N
M;F]G9V=G9V=G9F9G9V=H:&AG9F9G9V=G9VAG9V=M;6V)BHF=G9N>G9R<G9N<
MG)N<G)N<G)N<G)N=G)MP<'!G9V=H:&AF9F9G9V=G9F=G:&AH9VAG9V=H9V=G
M9F?*RLS_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\]____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________HZ*F:&=G9V=G:&AH9V=G:&=G:&=G:&AH:&=GA(2$G)N:G9V;G9V<
MFYN:FYN:GIZ<F9F8?'Q\9VAH9V=G9F9F:&AH9V=G9V=G9V=G:&=G969F<G)S
MAH:&G)V;G)R;FYN:GIZ<G9V;G9Z<FYN:G)V;G)R;G9V;G)V;G)V;G)R;G)R;
MG)R;G)R;G)R;G)R;G)R;G9V;G)R;G)R;G)R;G)R;G)V;G)R;G)R;G)V;G9V<
MG9Z<G)R;FYR:G)R;G)R;GIZ=G9V;G9V;D9&0C(R+C8Z-B(F(?X!_?G]^?X!_
M?W]_@("`?GY^=G9V<7%R<G)S<W)S<W-S<7)R<W1T?7Y]?X!_?W]_?X"`?GY^
M?G]_AH>&C8V-C(V,CHZ-FYN9GY^=FYJ9GIZ<G)R:G)R;G)R;GIV<G)V;G9V;
MG)V;G9V;G)R;G)R;G)R;G9V;G)R;G)R;G)R;G)V;G)V;G9V<FIN9G)R;FYN:
MG)V;GIZ=FYN:FYN:G9Z<G)R;G)R;FYN:G)V;G9Z<G)R;G)R;C8V,>'EX:&AH
M9V=G9V=G9V=G:&AH9V=G:&AH9V=G9V=G<G)RDY22G9R;G)V;G)R:FYR:G9V<
MG)R;C8Z-9F=G9V=G:&=G9V=G:&=H9VAH9V=H9V=G:&=G9V=HRLK,________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
MO/__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________Z.CIF=G
M9VAH:&AG9VAH:&AH:&AG9VAG9VAG9YR<FYR<FYR<FYR<FYN<FI^?G8R-C&MM
M;&=H:&=G9VAG9VEH:&AG9VAH:&AG9V9G9W%S<HV-C)V=FYR<FYR=FYV=G)R=
MFYR=FYZ>G9R<FYZ>G)R<FYR<FYV>G)N<FIR=FYN;FIR=FYR<FYR<FYV=FYV=
MFYR<FYR<FYR<FYR=FYR<FYR<FYR=FYR=FYR=FYR<FXR-C(R-C']_?W]_?W-S
M<W)R<VQL;&=G9V=G9V=G9V=H:&=G9V=G9V9G9V=G9V9G9V=H:&9G9VAH:&=G
M:&9G9V9G9V=G9V=G9VAG9V=G9VAH:&=G9VAG9V=G9VAH:&AG9VAH:&AH:&=G
M9V=G9V=G9V9F9FMK:W)R<G)S<WM\>W^`@(J*B8N,C)R<FYR<FYR<FYR<FYR=
MFYV=FYV=G)R<FYR<FYR=FYV=G)V=G)V=G)R<FYV>G)R=FYV=G)R=FYR<FYR<
MFYR=FYR=FYR<FYR=FYR=FYN;FIV=FYR<FYR<FYV=FY24DWIZ>F9F9FEH:&=G
M9V=G9V=G9VAG9VAG9V=G9VIK:X*"@IZ?G9R<FYV=G)R<FIV=FYR<FWEY>6AG
M9V=G9V=G9V=F9V=G9V=G:&=H:&=G9VAG:,G*S/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________[[_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________^BHJ9H9V=G9V=H9V=G9V=G
M9V=G:&AG9V=M;FZ<G)N<G)N<G9N<G)N<G)M\?'QG9VAG9V=F9V=G9V=G9V=H
M:&AG9V=F9F=Q<G*-CHV=G9R<G)N<G)N<G9N<G)N<G9N;FYJ;G)J<G)N<G9N<
MG)N<G)N<G9N>GIV<G9N<G9N<G)N=G9R;FYJ<G)N;G)J;G)J<G9N<G)N=G9N<
MG)N-CHV"@X)\?'QS<W-M;6UH9V=G9V=H9V=G9V=G9V=H9V=H9V=H9V=G9V=G
M:&AG:&AG9V=G:&AG9V=H9V=G9V=G9F9G9V=F9V=H:&AG9V=G9V=G9V=G9V=G
M9V=G9V=G:&AG:&AG9V=G:&AG9V=G:&AG9V=H9V=G9V=H9V=H9V=H9V=G9V=H
M9V=H:&AG9V=H9V=H9V=G9V=H:&AG9V=I:6ER<G-X>7F"@H*-CHV8F):<G)N<
MG)N<G)N<G)N=G9N<G9N<G)N<G)N;G)N<G)N<G)N<G)N=G9N;FYJ=G9N=G9N<
MG)N<G)N<G)N=G9R<G)N<G)N<G)N=G9N>GIR4E)-Y>7EG9V=H9V=G9V=G9V=H
M9V=G9V=H:&AG9V=R<G*9F9>;G)J=G9R;G)J>GYV/D(]G9V=H:&=G9VAG9VAG
M9V=H9VAG9V=G9V=H9VC)R<O_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________^]____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________HJ*F9V=G:&=G:&=G:&=G9V=G9V=G9V=G<7%Q
MG)V;G)R;G9V<F)B7;W!P9V=G9V=G:&=G9V=G:&AG:6AH9F9F;6UNBXN*G9R;
MG9V;G)R;FYR:G)R;G9V<G)R;FYR:G)R;G9V<FIN9G9V<G)R;G)R;G9V<FYN:
MGIZ<FYN:G9V<G)R;GIZ=G9V;G9V;C8V-@8&!>7EY<7!P9F9F:&=G:&=G:&=G
M:&AH9V=F9V=G:&AH9V=G9VAH9V=G9F=G9V=G9V=G9V=G9V=G9VAH9V=G:&=G
M9V=G:&=G9V=G:&=G9V9F9V=G:&AH:&=G:&=G:&=G:&=G:&AH9V=G9V=G:&=G
M:&=G9V=G9V=G9V=G9V=G9V=G9VAH9V=G9F=G9V=G9V=G9F=G9V=G9V9F:&AH
M9V=G:&AH9F9F9V=G9V=G9V=G9V=G9F=G9F9F:&AH;6UM=G9V?G]^C(R+F)>6
MG9V;G)R;G9V<G)R;G9V;G)R;G)V;FYR:G9V<G)R:G)V;G)R;G9V<FIN9G9V<
MG9V<G)R;FYN:GIZ=FIJ9G9Z<G)R;C(R,<G)S9VAH9V=F:&=G9V=G9V=G969F
M9V=G:&IID9&0G)R;GIZ<FIJ9GIZ<;V]O9V9F9V=G:&=H9F=G9V=H9V=G:&=G
M:&=HRLK,____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________OO__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________Z.CIFAG9V=G9V=G9VAG9V=G9V=G9V=G9W-S<YV>G)R<FI&1D&IJ
M:F=G9VAG9V=G9V=G9VAH:&EH:&=G9X!_?YB8EYR<FYR<FYR=FYV=FYR<FYR=
MFYN<FIV=FYV=G)R<FYR<FYV=G)R<FYR<FYV=FYJ:F9Z>G9R<FIV<FYR<FHZ.
MC7Y_?W)R<V=G9V9G9VAG9VAG9V=G9V=G9V=G9V=G9V=G9V=G9V=G9V9F9F=F
M9FAG9VAG9VAG9V=G9V=H:&9G9V=G9V=G9V=G9V=G9V=H:&=H:&=G9V=G9V9G
M9VAH:&=G9V=G9V=G9V=G9V=H:&=G9V=G:&=G9V=G9V=G9V=G9V=G9V=G9V=G
M9V=G9VAG9V=G9V=G9VAG9V=G9V=G9VAG9VAG9VEH:&AG9VAG9V9F9FAH:&=F
M9FAG9V=G9V=G9VAH:&AG9VAG9V=G9VAG9V=G9VAI:6=G9V]O<'U\?8F*B9B8
MEIN;FIV<FYR<FYV=G)R=FYN;FIR<FYV=G)V=FY^?GIR=FYR=FYN<FIV=FYR<
MFYV=G)R<FYR<FYR<FYR<FX&"@FIJ:VAH:&AG9VAH:&=G9V9G9V=G9V=G9X:'
MAIR<FYR=FYJ:F8.#@VAG9V=G9V=G:&=G9V=G:&=G9VAG9VAG:,K*S/______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_S[_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________^CHZ9H
M9V=H:&=H9V=G9V=G9V=G9V=F9V=R<G.>GIV*BXII:6EG9V=G9F9H:&AH:&AG
M9V=F9V=O;V^1D9"=G9N<G9N<G)N<G)N<G)N<G)N;FYJ<G)N<G9N<G)N<G9N=
MGIR<G)N<G)N>GIV;FYJ<G)N=G9R0D9"#@X-Q<G)I:6AG9F9I:&AG9V=I:6EH
M9V=I:&AH9V=G:&AG9V=F9V=G:&AF9F9G9V=G9V=H:&AH9V=H9V=H:&=G9V=F
M9V=G9V=G9V=G9V=G9V=N;FYR<G-Q<7)S<W-Z>WN`@(!_@']^?WY^?W]_@'^&
MAX:,C8R-C8R-C8V,C8R-C8V(B(B!@H%]?GY^?W]^?W^`@(!^?W]R<G)R<G-S
M<W-M;6UH:&AG9V=F9V=H:&AG9V=G:&AH:&AH9V=H9V=H9V=H9V=G9V=H9V=H
M9V=G9V=H9V=H9V=G9V=I:6EG9V9G9V=H:&AF9F9G:&AG:&AO;W![?'R-C8R>
MGIR;FYF>GIV:FYF=G9R<G)N;FYJ=G9R=G9N<G)N<G)N;G)J<G)N<G9N>GIV<
MG)N<G)J<G)N9F)=V=G9G9V=G9F9H9V=F9V=G9V=F9V=G9V>%AH6=G9R<G9N,
MC(MG9V=G9V=G9VAG9V=H9VAG9V=G9V=G9VC)RLS_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________^]____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________HJ*F:&=G:&AH:&=G9V=G
M9V=G9V=G9VAH<W)SAH>&9V=G:&AH:&=G9F9F:&=G9V=G9V=G?'U\FYN:G)R;
MG)R;G)R;GIZ<FYN:GIZ=G)R;G9V<FYN:G)V;G)R;FYN:G)R;G)R;G9V;G9V;
MC8V,>WQ\;&UM:&AH9F9G9V=G9V=G:&AH9V=G:6AH9V=G:&AH9V=G:&=G9V=G
M:&=G:&AH:6AH:&AH9V=G:&AH9V=G:6EI<W-S>7EY?WY_B(B(C8V,D)&0FYN:
MG9V;G)N:G9V;G9V;G9R;G)R;G)R;G)R;G9Z<G)R;G)R;G9Z<G)R;FYN:G)R;
MG9Z<FYR:G9V<G)R:G)R;G9V<G)R;G)V;G)V;G)R;G9V;G)R;FYN:GIZ<FYN:
MDI*1C(R+B8J)?G]_>WQ[<W-S;6UM9V=G9V=G9V=G9V=H9F9F9VAH:&=G:&=G
M:&AH9V9F:&AH9V=G:&=G:&AH9V9F:&AH9V=G9VAH9V=G:FIK>7EYBHJ*G9V;
MG)R;G)V;G)R;G)V;G9V<G)V;G)R;G)R;GI^=G)R;G)R;G9Z<FYN:G)R;FYN:
MG)R;@X.#:FIJ:&=G:&AH:6AH:&=G9V=G9V=G>7IZG9V;G)R;:&AH9V=G9V9G
M9V=H:&=H9V=H9V=G9V=HRLK,____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________/O__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________Z.CIF=G9VAG9VAG9VAG9V9G9V=G9V9G9VYN
M;V=G9V9G9V=F9F9F9FEH:&9G9VIJ:HJ*BIR<FYV>G)R=FYR<FYR=FYR<FYZ=
MG)N;FIR=FYJ:F9R<FYV>G)J:F9Z>G9R<FI&1D'U]?6EI:F=G9V=H:&9F9FAG
M9VAH9V=G9V9G9V9G9V=G9V=H:&AH:&=F9FAG9V=F9FAG9V=G9VMK;')R<G]_
M?X>(AXR,C)V=G)R=FYR<FIR<FYR<FYJ;F9R<FYR<FYV=FYR<FYR<FYZ>G9R<
MFYR=FYR<FYR<FYR=FYR<FYR<FYR=FYR<FYR<FYR<FYR=FYR<FYR=FYR=FYJ;
MF9R<FYR=FYR<FYR=FYR=FYR<FYR<FYV=G)R<FYR<FYV=G)R=FYV=FYR=FYN;
MFIR<FYV=G)V=FYR<FI&1D(F)B7]_?W9U=FUM;6=G9V9F9F=G9VAH:&9F9FAG
M9VAH:&=G9FAG9V=F9FAH:&9F9F9G9VEH:&=G9V=G9VEI:7AY>8F)B9V=FYV<
MFYR<FYN;FIV=G)R<FYN;FIR<FYR=FYV>G)V=FYV=G)R=FYR<FYV>G)"0CVUM
M;6EH:&=F9FAG9V=F9FAG9V=H:(>(AYR<FF=G9V=H:&=G:&=G9VAG:&=G9V=G
M9V=F:,G*R___________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________S[_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________^CHZ9H9V=H:&=G9V=H9V=G9V=G9VAF9F=H:&AG9V=G9V=H9V=G
M9V=G9V=I:FJ1D9"=G9R=G9N<G)N<G9N<G)N>GIV<G)N<G9N<G)N;FYJ>GIV<
MG)N<G)N5E9-_?W]L;&QG:&AF9V=G9V=G9V=H9V=G9V=H9V=G9V=H:&AG9V=G
M9VAF9F9F9F9G9V=J:FIR<G)_?W^)BHF8F)><G)N=G9R<G)N<G)N<GIR;G9N<
MG9N<G)N<G)N<G9N<G)N<G9N>GIR<G9N=G9R<G9N;G)J<G)N<G)N<G9N<G)N<
MG)N;FYJ<G)N<G9N<G)N<G9N<G9N=G9N<G)N<G9N<G)N<G)N=G9N<G)N<G)N<
MG)N<G)N<G)N<G)N<G)N=G9N<G)N=G9N=G9N<G)N<G)N<G9N<G)N:FYF<G9N=
MG9N;FYJ<G)N=G9N>G9R=G)N8F):-C8Q_@']U=G9J:FIG9V=F9V=G9V=F9F9H
M:&AH9V=H9V=H9V=H9V=H9V=H:&AG9VAF9F9H:&AI:6E\?'R0D(^>GIR:FYF<
MG)N=G9R=GIR=G9N;FYJ<G)N;FYJ=GIR<G)N<G)N<G)N8F)9N;V]H:&AG9VAG
M9F9H:&AH9V=F9F:'AH9G9F9G9V=G9F=G9V=G9VAG9V=H:&AG9FC)R<O_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__\^________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________HZ.F
M9V9F9V=G:&=G:&=G:&AH9VAH:&AH9F=G9V=G:&=G:&AH9V=G;V]OF9B7G9Z<
MFYR:G)R;G9V;G)V;G)R;G)R;G)R;G)R;G)R;G9V<G)R;C8V,=79V9V=G9V=G
M:&=G9V9F:&=G:&=G:&=G:&=G9V=G9V=G9V=G9V=G:&=G:VIK=G9V@X.#D9&0
MG9V;G)V;G9V<FYN:G9V<G9V;G)V;G)V;G)R;G)R:G9V;FYN:G)R;G9Z<G)R;
MG)R;FYN:G)R;G9V;G)R;G9V;G)R;G)V;G)R;G)R;G)R;G)R;G)R;FYR:G)R;
MG)V;G)V;G)V;G)R;G)R;G)R;G)V;G)R;G)V;G)R;G)V;G)V;FYR:G)R;G)V;
MG)R;G)V;G)V;G9V<G)R;G)R;G)V;GIZ=FIN9GIZ=FYN:G9V;G9V;G9V;G)V;
MFYN:G9Z<G)R;G)R;G)R;G)R;G)R;E)23AH>&>7EY;&UM:&AH:&=G9V=G:&=G
M9V=G:&=G9V=G9V=G:&=G9V=G:&AH9V9F9V=G<G)RAH>&G9R;G9V<G)R;FIN9
MG9V;FYN:G)R;FYR:GIZ=G)V;G)R;G)V;F)B7=G9V9V=G9V=G:&=G:6AH9F=G
M9VAH:&=G9V=G9V=H9V=G9V=H9V=H:&=G9V=HR<K+____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________.___________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________Z*BIFAH:&=G9VAH:&=H
M:&=H:&=G9V=G9V9G9VAG9VAH:&=G9VYO;YF9F)V=G)R<FYV>G)V=FYV>G)V=
MFYV=G)R<FYV=FYN;FIV=G(>&AFQL;&AH:&9G9V=G9V=G9V9F9F=G9VAG9VAH
M9V=G9VAG9V=G9V=G9V]P<'Y^?HR-C)R<FYZ>G)R<FYR<FYR<FYR=FYR=FYV>
MG)R<FYR<FYR<FYZ>G)V=FYV<FYV=FYR<FYV=G)R<FYR<FYR<FYR=FYR=FYR=
MFYV=FYN;FIR=FYV=FYZ>G9N<FIR=FYR<FYR<FYR=FYR<FYR=FYR<FYR<FYR<
MFYR=FYR<FYR=FYR<FYR<FYV=FYR<FYR<FYV=G)R<FYR<FYR<FYR<FYR<FYR=
MFYR<FYR=FYV=FYN<FIV=G)R<FYR=FYR<FYR<FYR<FYR<FYV=FYR=FYR<FYR<
MFYR=FYN<FIN<FYV=G)R<FYV=G)N<FI"1D(*#@G-T=&=H:&AG9VAG9V=G9V=G
M9VAG9VAG9V=G9V=H:&AG9VEH:&9G9VUM;7Y_?YB8EIR=FYR=FYR<FYV=FYR<
MFYR<FYV>G)N;FIR<FYR<FYR<FW=X>&AH:&=G9V=F9F9F9F=G9V=G9V=G9VAG
M:&=G9V=G:&=G9V=G9VAG:,K*S/__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________[[_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________^BHJ9G9V=G9V=G9V=F9V=G9VAG:&AG9V=F
M9F9H9V=H9V=I:6F:FIB;G)J;G)J=G9R;FYJ<G)N<G)N<G)N<G)N=G9R;FYJ'
MAX=L;&QG:&AG:&AG9V=H9V=G9V=H9V=H9V=G9F9G9V=G9V=G9V=P<'"#@H*4
ME).=G9N=G9N<G)N<G)N<G)N<G9N<G)N<G9N<G)N>GIV=G9N<G9N<G)N=G9R<
MG)N<G9N<G)N=G9N<G)N<G9N;FYJ<G)N=G9R;FYJ<G)N<G)N<G)N=G9N<G)N<
MG)N:FYF<G9N<G9N<G)N<G9N<G)N<G)N;FYJ>GIV<G9N<G)N<G)N<G)N=G9R<
MG9N<G9N<G)N=G9N<G)N<G)N>G9R=G9N=G9R<G)N<G)N<G)N=G9R<G)N<G)N<
MG9N=G9R<G9N;FYJ>GIV<G)N<G)N<G)N;G)J<G9N<G)N<G)N=G9R=GIR<G)N=
MGIR<G)N<G)N<G9N<G)N<G)J=G)N9F9B'AH9V=G9G9V=G9VAG9V=H9V=G9F9H
M:&AH9V=H9V=I:&AF9V=G9V=J:VM^?W^8F)><G)N;G)J=G9R<G9N<G)N<G)N=
MG9R<G)J=G9N9F9=O;V]G9F9G9V=H:&=H9V=G9V=G9V=H9VAG9VAG9F=F9V=H
M9V=H9VC)R<O_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________^]________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________HZ.F9V=G9V=G9V=G9V=G9V=G9V=G9V=G9V=H9V=G9V=GDI*1
MFYN:G9V<FYN:G9V<G)R;G)R:G9R;G)R;G9R;AH:&;6UM9F9F:&AH:6AH:&AG
M:&=G:&AH9F9F:6AH:&AH:&=G;F]O@H."E964G9R;GIZ=GI^=G)R;G9V;GIZ=
MG)R;G)R;G)R;G)R;G9Z<G)R;G)R;G)R;G)R;G)R;G9V<FIN9G)R;G9Z<G9V<
MG9V<G)R;G)R;FYN:GIZ=G)R;G9V<G)R;G)V;G9V;G)R;G9V<G)V;G)R;FYN:
MG)V;G9V;G9V<FYN:GIZ=FIJ9GIZ=G)R;G)V;G)V;G)R;G)V;G)V;G)R;G)V;
MG)V;G9V<G9V;G)R;FYN:GI^=FIJ9GIZ=G)R;G9Z<G)R;G)R;G)R;G)V;G9V<
MFIJ9G9V;G)V;G)R;G9V;G)R;G)R;G)V;G)V;G)R;G)V;G)V;G)R;G)V;G)R;
MG)V;G)R;G)V;G9V;G9V;FYN:F9F8A86%=G9V9V=G9VAH:&=G9F=G9F=G9F9F
M:6AH9V=G9V=G:&AH:6IJ?X!_F9F8G)R;G)V;G)R;G)V;G)R;G)V;G)R;FIN9
MF9F7;6UM:&=G:&=G:&=G9V=G9V=G:&=H9V=G:&=H9VAH9V=G9V=HR<K,____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____OO______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________Z.B
MIF=G9V=G9V9G9V=G9V=G9V=G9V=G9V=H:&=G9X*"@IN;FIV>G)R<FYV=G)R=
MFYV=G)Z>G9N;FHZ-C&UM;6AG9V=F9FEI:6=G9VAG9V=F9FAH:&=G9V=G9VEI
M:7M[>Y*1D)N;FIZ=G)R=FYR<FYR<FYR<FYR<FYV=G)R<FYR<FYR=FYR=FYR<
MFYJ:F9R<FYR<FYR<FYR<FYV=FYN<FIV=FYR<FYV=G)R<FYR<FYN;FIV=G)R=
MFYR<FYR<FIR<FIR<FYV=FYR<FYR<FYR<FYV>G)R<FYR=FYR=FYR<FYR<FYR<
MFYR=FYR<FYR<FYR=FYR<FYR=FYV>G)R<FYN<FIR<FYR<FYN<FIV=G)R<FYR<
MFYZ>G)N;FIR=FYR=FYV=G)R<FYR=FYV=G)J:F9Z?G9R<FYN<FIV>G)R=FYR=
MFYZ>G)V=FYV=FYV=G)R<FYV=FYV=G)R<FYR<FYR=FYR<FYR=FYR<FYR<FYR=
MFYV=FYV=G)N;FIZ>G9N:F924DX!_?VUM;69F9F=H:&=H:&=G9VAH:&=G9VAG
M9VAG9V9F9VEI:H.$@YR<FYR<FYR<FYR<FYN<FIR<FYV=FYN;FI&1D&=G9VAG
M9V=G9VAH:6=H:&=G:&=G9V=G:&=G9V=G9V=F9\G)R___________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________SW_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________^CHZ9F9V=G9V=F9V=G
M9V=G9V=G9V=G9V=G9V=R<W.=G)N>GIR:FYF=G9R<G)N=GIR>G9R4E)-R<W-G
M9V=I:6AG9V=G9F9H:&AG9V=H9V=H:&AG9VAL;&V&AX:8F)>>GYV;G)J=G)N<
MG9N<G)N<G9N<G)N<G9N<G9N<G9N<G9N<G)N<G)N<G)N<G)N<G)J>GIV<G)N<
MG)N<G9N<G)N;G)J=G9N<G)N<G9N=G9R<G)N=GIR;FYJ<G9N<G)N=G9R;G)J<
MG)N<FYJ>GIV=G9N?GIV;FYJ=G9N<G)N=G9N>GIR;FIF=G)N=G9N,C8R-C8V-
MCHV,C8R.CHV8F)>=G9R=G9N=G9R=G)N=G)N<G)N<G)N<G9N<G9N=G9N<G)N<
MG)N<G9N<G)N<G)N;FYJ=GIR;G)J<G9N>GYV:FYF=G9R=GIR;G)J;G)J<G)N<
MG)N=G9R<G)N<G9N<G)N=G9N<G)N<G)N<G)N<G)N<G)N<G9N;G)J=G9N>GYV<
MG)N=GIR<G)N=G)N<FYJ*BXIP<7%G9V=G9V=H9V=G9F9H9V=H9V=G9V=H9V=F
M9F9P<'".CHV<G)N<G9N<G)N<G9N<G)N=GYV;FYI_?GYG9V=H:&AF9F9G9V=H
M9VAG9V=G9F=F9V=G9V=G9VC)R<O_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\^________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________HZ.F9V=G9V=G9V=G9V=G9V=G9F=G9F=G
M9V=GE)23G9V;G)R;GIZ<FYN:G9V;G)R:@H*":FIJ9F=G9VAH9F=G:&AH9V=G
M9V9F:&=G9V=G<G)RBXN*GIZ<G9V;FYR:G)R;G)V;G9Z<G)R;G)V;G)R;G)R;
MG9Z<G9V<G9V;G)R;G)V;GIZ=G)R;G)R;GIZ=G)R;G)R;G9V;GIZ=FIN9GY^>
MG)R;GIZ=FYN:G)V;GIV<G)R:G9V;GIZ<D9&0C(V,AH>&?W]_@']_=75U='1T
M<7%Q='1T:&AH9F9F9V=G9F=G9F=G:&AH9V=G9VAH9F=G9V=G:&AH9F9F:&AH
M:&AH9V=G:&AH9V=G9V=H9V=G;V]O<W-S<G)R<G)R@']_?W]_@X*"BXR+CHZ-
MG)R;G)R;G)R;FYN9G)V;G9V<FYN:G)R:G9V;G9V<G)R;G9V<G)R;G)V;G9V;
MG)V;G)R;G)R;G)V;G)R;G)R;G)V;G9V<G)R;G9V;G)V;G)V;G)V;G)R;FIJ9
MG9V<G9R;GIZ<CY"/>'EY9F9F9F=G9V=G:&=G9F9F:6AH:&=G9V=G9V=G?'U\
MF)B7G)R;G)V;G)R;FIN:G9V<F)B7;&QL9V=G9V=G9VAH9V9G9V=G:&=H9V=G
M:&AG:&=HR<G+________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________/?______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________Z.CIF=G9V=G9V9G9V=H:&=G:&=G9V9G9VMK:YN;FIR=FYV>
MG)N;FIZ=G)24DW-S<V=G9VAG9V=G9V=G9V9G9V=G9V=G9V9F9G)R<HR,C)Z>
MG)R<FYR<FYN;FIR<FYR<FYR=FYR<FYR<FYR<FYR<FYR<FYR<FYR<FYV=G)R=
MFYR=FYR=FYR=FYZ>G)R<FYN<FIR=FYR=FYJ;F:"?GIR<FIN;F8V-C8>'AGY_
M?W5U=7-S<V=H:&5F9FAH:&=G:&9G9V=G9VAG9V=G9V=G9VAH:&=G9F=G9V=G
M9VAG9V=G9VEH:&AG9VAG9V=G9VAH:&AG9V=G9VEH:&AG9V=F9F=G9VEH:&AG
M9VAG9V=G9VEH:&AG9V=F9FAH:&AG9V9F9F9F9F=G:&=H:&=H:&=G9V]O<')R
M<W^`@(&!@8^/CIF9F)R;FIV=FYN;FIR<FYR=FYR<FYR<FYV=FYR=FYV=FYR=
MFYR<FYR<FYR<FYR=FYR<FYR<FYN<FIV>G)R<FYV>G)N;FIR<FYR<FYR<FYR<
MFYV=FY65E'=X>&=G9V=H:&AG9V=G9V=F9FAG9V9F9F=G9VQL;9*1D)R<FYR<
MFYR<FYR<FYN;FH>'AV9G9VAG9V=G9VAG:&=G9V=G:&=G9V=G9V=G:,G)R___
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____SW_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________^B
MHJ5G:&AG9V=G9V=G9V=G9V=F9F9H:&AP<'"<G)N=G9N<G9N=G9R)BHEI:FIF
M9V=G9V=G:&AH9V=H9V=H9V=H9V=M;FZ.CHV<G9N;FYJ;FYJ=G9R<G9N=G9N<
MG)N;FYJ=G9N=G9R<G)N<G)N<G9N<G)N<G9N<G9N=G9R<G9N=GIR<G9N=GIR<
MG)N<G)J=G9R3E).)BHF`@(!R<G)L;&QG9V=F9V=H9V=H9V=G9VAH9V=G9F9H
M9V=H9V=G9V=H:&AG9F9H:&AG9V=H9V=F9F9I:&AH:&AH:&AH9V=G9V=H9V=H
M:&AH:&AG9V=G9V=H:&AG9V=G9V=F9F9G9V=F9V=F9F9G9V=G9V=F9V=H9V=H
M9V=H9V=H9V=H9V=H9V=G9V=G9V=H9V=G9F9H:&AG9V=G9V=F9F9H:&AF9V=G
M9V=I:FIS<G-\?'R%AH62DI&=G)N=G)N=G9R<G)N<G9N<G)N<G9N<G)N<G)N<
MG)N=G9R<G9N>GIV<G)N=G9N<G)J<G9N<G)J<G)N<G)N<G9N<G)N<G)N=G9N1
MD)!S<W-G:&AG9V=H:&AG9F9H9V=G9F9H9V=G9V>"@X.<G)N<G)N=G9N<G)N7
MF)9J:FIH9V=G9V=G9FAF9V=G9VAG9V=H9V=H9VC)R<O_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________^]________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________HZ.F9V=G9V=H9V=G
M9V=G9V=G9V=G9V=G<G)SG)V;G)R;G9R;?GY^:&AH9V=G:&=G:&AH9V9F:&=G
M9V=G:FMK@8*"G9V;G9V;G)V;G9V<G)V;G9Z<G9R;G9R;FIN9G9V<G9V;G)V;
MGIZ=FIN9G9V<G)V;GIZ=FYN:G9R;G)R;G)R;G9V;C(R,@']_<W-S:VIJ:&=G
M9F9F:&AH9V=G9V=G9V=G9V=G9V=G9V=G:&=G:&=G:&AH9V=G:&=G:&=G:&AH
M9V=G:&AH:&=G9V9F:&AH9V=G9V=G9V=G:&=G:&=G:&=G:&=G9V9F9V=G:&AG
M:&AH9V=G9V=G9V=G:6EH9F9F:&AH:&=G9V9F:&=G9V=G9V=G9V=G9V=G9F=G
M9V=G9V=G9V=G9V=G9V=G9V=G9V=G9V=G9V=G9V=H9VAH:&=G:&AH9V9F:&AH
M9V=G9V=G9V=G<G)S?X!_B8J)F)B7G)R;G)V;G)R;G)R;G)R;G)V;G)R;G9V<
MG)V;G)R;G9V<G9Z<G)V;G)R;G9V<G)R;G)R;GIZ=G)V;G)V;G)V;B8F);6UN
M9F9F:&AH9V=G:&=G9V=G9F=G9V=G>7EYF)B7G9V<FYN:G)R;>'EY9V=H9V=H
M:&=H9V=G9V=H9V=G9V=G9V=HR<G+________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________//______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________Z*BIFAH:&9G9V=G9V=G9V=H:&=G9V=G
M:')R<YR<FYV<FW=X>&=G9V9G9VAH:&=G9V=G9V9F9F=G9W9V=IJ:F)R<FYV=
MFYJ:F9V>G)R<FYR=FYR=FYR<FYV=G)R<FYR=FYR=FYR<FYN;FIV=G)J;F9R=
MFYV=FYV=FXV-C(!_?W)R<V=G9V=G9V9G9V=G9V9F9FAH:&AG9V=F9FAG9VAG
M9V9F9FAH:&=G9V9G9V=G9VAH:&=F9FAG9VAG9VAG9V=G9VAG9VAH:&5F9F=G
M9V9G9V=G9V=H:&=G9V9F9F=H:&9G9V9F9F=H:'!P<'-S<W-S<W-S<W)R<FAH
M:&9F9F=G9V=G9V=G9V=G9V9G9V=G9V9G9V=H:&9G9V=G9VAH:&=G9V=G9VAG
M9VAG9V=G9VEI:&=F9FAG9VAH:&=G9V=G9V=G9VAG9VAG9V9G9VEI:69F9F=H
M:&AG9VAG9V=G9VYN;GQ]?8F*B9N<FYZ>G)N;FIV>G)R<FYR=FYV=G)R<FYR<
MFYV=FYV=FYR<FIR<FYV=G)R<FYR<FYV=G)R=FYV=FY>7EH!_?V9F9FAH:&=G
M9VAG9VAG9V=G9V=G9W!P<)>7EIZ=G)J<FHJ*BF=G9V9G9V=G:&=H:&AG:&=H
M:&AG9VAG:,G*S/______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________[S_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________^CHJ9G9V=G9V=F9V=G9V=G:&AF9F9G9V=S<W28F)=O<'!F
M9F=H9V=G9F9H9V=F9V=F9F9I:FJ)BHF>G9R<G)J<G)N;G)J=G9N<G)N=G9R<
MG9N<G)N=GIR;FYJ<G9N=GIR<G)N=G9R<G)N;FYF:FIB&AX9U=G9J:FIG9V=H
M9V=H9V=H9V=H9V=G9V=F9F9G9V=F9V=H9V=H:&AG9V=G9V=I:6EF9F9G:&AG
M9V=H:&AF9F9H:&AF9F9I:6IT='1S<W-^?GY_?W^"@X*-C8R+C(N-C8V8F)><
MG)J=G9N<G)N<G9N=G9R<G)N<G9N<G9N<G)N<G)N=GIR;FYJ<G9N=G9R<G)N<
MG9N<G)N7F)>.C8R-C8R.C8R&A86!@(!^?GYV=G9R<G)L;6UG9V=G9VAF9F9H
M9V=G9F9H9V=H9V=H9V=G9F9H9V=G9F9I:&AH9V=H9V=G9V=H9V=H:&=G9V=H
M9V=G9F9G9V=G:&AV=G:"@X.3DY*=G)N<G)N<G9N<G9N=G9N<G9N<G9N<G9N<
MG)N<G)N=G9R<G)N=G9N=G)N<G9N>GIV;FYF-C8QL;6UH:&AH9V=G9V=G9V=I
M:&AG9V=Q<'"6EY:=G9R3DY)I:&AG9VAG9VAG9VAG9F=G9V=H9V=H9VC)R<O_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______\[____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
MHZ.F9F9G9F=G9V=G9V=H9V=G9F9F:&AH<7%Q;V]O9V=G:&=G9V9F9V=G:&=G
M9F=G<'!PE964G)R;FYN:G)R;FYR:GI^=FYN:G)R;FYN:GIZ=G)R;G)R;G)R;
MG9V<FYN:G)R;F)B6AH>&=G=W9F9F9V=H9F9F:&=G:&=G9F9F9V=G:&AH9V=G
M9F9F:6AH9V=F:&=G9V=G9VAH9F=G9V=G:&AH;6UM<G)S?WY_@H."C8Z-DI.1
MGIV<G)R;G)R;FYN:G9Z<G9V;FYR:G)R;G9V<G)R;G)R;G)V;G)R;G9V<G)R;
MG)V;G)R;G)V;G)V;G)R;G)V;FIN9G9V<G)V;FYN:G)V;G)R;G)V;G)V;G)R;
MG)R;G9V<FYR:FYN:GIZ=G)V;G)V;G9R;G)R;E)23C8V,AH>&?X!_<7)R<'!P
M9F9F:&AH9V=G:6EI9V=G:6AH9V=G:&=G9F9F9VAH9F=G:&AH:&AG9V9F:&AH
M9V=F9V=G9V=G;V]P@H."E)23G)R:G9V;G9Z<G)R;G9V;G)V;G)R;G)V;G)R;
MG)R;G9R;G9V<FIN9G)R;G9V<EY>6=G9V9V=G:&=G:&=G9F9F:&=G:&AH;6UM
MEYB6G9R;9F=G9V=G9V=H9V=G:&=H9V=G:&=G9V9HR<G+________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________O/______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________Z.CIF=G9V9G9V=G
M9V=G9V=G9V=G9V=G9VMK:VAG9VAH9VAH:&AG9VAG9V9G9WEY>9B8EIR=FYR=
MFYV>G)R<FYZ>G9J:F:"@GYR<FYR<FIR=FYR=FYR<FYR<FYN:F8B(B'5U=F=H
M:&5F9FAH:&AG9VAG9VAH:&=F9F=G9V=H:&AH:&=G9V=G9FAH:&EH:&=G9VAG
M9W!Q<'AY>8&"@8V-C)R<FYN;FIR<FIR<FIR<FYR=FYR<FYR<FYN<FIV=G)R<
MFYR<FYN;FIR<FYZ>G9N;FIR<FYV=G)R<FYR=FYR<FYZ>G9V=FYN<FIR<FYR<
MFYR<FYV>G)V=G)R<FYN;FIR<FYR<FYV=FYR<FYR<FYR<FYR=FYR=FYV=G)V=
MG)R=FYR=FYR=FYV=FYN;FIZ>G9J:F9R<FYR=FY^>G9N;FIR<FXR,C(6&A7U\
M?7)R<F9F9F=G9V=G9VEH:&=F9FII:6=G9VAG9V=G:&=G9V=G9VAG9VAG9V=G
M9V9F9VAH:'!P<(*#@IB8EYR<FYV>G)N<FIR<FYV=FYV>G)R=FYR<FYN;FIV=
MG)R<FYN;FIR=FYZ>G(*"@FAH:&AH:&AH9V=G9VAG9V=G9W!O;YB8EF9G9V=G
M9VAG:&=G9V=G:&9G9V=G9V=G:,G)R_______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________SS_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________^CHZ9G9V=G:&AF9V=G9V=G9V=G9V=G
M9V=G9V=H:&AH9V=H:&AG9V=F9V=^?GZ=G9N=G9N<G)N<G9N<G9N=G9R<G)N=
MGIR<G)N=G9R<G)N:FYF=G9R1D9!Y>GIJ:FMF9F9I:&AH:&=G9V=H:&AH:&=H
M9V=H9V=H9V=H9V=H:&=G9V=G9V=J:VMV=G9^?GZ.CXZ<FYJ=G9N<G)N<G)N<
MG)N;G)J?GYZ;FYJ>GIV>G9R<G)J?GIV=G9R<G)N<G)N<G)N<G)J<G)N=G9N<
MG)N<G9N=GIR;FYJ<G)N;FYJ<G9N<G)N<G9N<G)N=GIR=G9R<G)N<G9N;FYJ<
MG)N<G)N=G9R;FYJ<G)N=G9R=G9N:FIF=G9N<G9N<G)N<G)N<G9N=GIR;G)J=
MG9N<G9N<G)N>GIV=G9N=G9R;FYJ=GIR<G)N=G9N<G)N;G)J;G)J<G)N1D9""
M@H)Y>7EM;6UF9V=H9V=H:&AG9V=G9V=H9V=G9V=H:&AG9V=G9V=H9V=G9V=G
M9V=G9V=X>7F-CHV<G)J=G9R:FYF<G9N=G9N<G)N=G9R<G)N=G9R;FYJ<G9N<
MG9N=G9N%AH5G9V9F9V=G9V=G9V=I:&AG9V=O;V]F9F9G:&AH9VAG:&AG9FAG
M9V=H9V=G9F?)R<O_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________^]____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________HZ.F9V=G9V=G9V=G9VAH9V=G9V=G9VAH9VAH:&=G9V9F
M9F=G:&AHA8:%G9V;FYR:G9V<G)R;G)V;G)R;GIZ<G)R;G9V<FYR:G)R;G9R;
MAXB'<G)S9V=G9V=G9VAH:&=G:&AG9F9F:&AH9V=G9V=G9V=G9V=G9V=G9V=G
M<G)RA(.#D9&0G)N:G)R:G9V<G)R;G)R;G)R;G)V;G)R;G)R;G)V;G)R;GIZ=
MFYN:G9Z<FYN:G)R;G)V;G)V;FYN:G)V;G)R;G9V<FYN:FYN:G)R;G)R;G)V;
MG)R;G)R:G)R;G)R;G9R;GIZ<G)R:G9R;G9V;G9R;G)R;G)R;FYN:G)R;GIZ<
MG9V<FYN:G9V;G)V;FYR:G)R;G)V;G)V;FYN:FYN:G)R;G9Z<G)R;G9Z<G)R:
MG)R;G)V;G9Z<FYR:G)R;G)R;G)R;G)V;G9V<G)R:FYR:G)V;G)R;G9V<DY22
M@H*"=G9V:FIJ:&=G9V=G9V=G:&=G:&=G:&=G:&AH9V=G9V9F:&AH9V=G9F=G
M;6YNAH:&FIJ8G)R:G)V;G9Z<G)V;G9Z<G)R;FYR:G)V;G)V;G9V<G)R;D9&0
M:6IJ9F9G9V=G:&=G9V=G9V=G:&AH9V=G9V=H9V=G9V9H9V=G:&AH:&=HR<K+
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________O/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_Z*BIFAH:&=H:&9G9V=G9V=G9V=G9V=G9V9G9VAG9V9G9V=G9X"!@9Z>G)V=
MFYR<FYR<FYR=FYR<FYR<FYR<FYV>G)R<FIV=FX:'AFUM;69G9V9G9V=G9VAG
M9V=G9F=G9V=G9V=G9V=H:&=H:&AH:&IJ:GAY>8J*BIB8EIR=FYV=FYR=FYV=
MG)R=FYV=G)N;FIR=FYR<FYR=FYR<FYR<FYR<FYR<FYR<FIV>G)R<FYR<FYV=
MG)R=FYR<FYR<FYR<FYR=FYN;FIV=G)R=FYR<FYV=G)R<FYR=FYV=FYR=FYR<
MFYR<FYR=FYR<FYR<FYR<FYR=FYR<FYR=FYR<FYV=FYR<FYR=FYR<FYR=FYR=
MFYR=FYR<FYR=FYR=FYR<FYR<FYV=FYR=FYR<FYR<FYR=FYR<FYR=FYR<FYR<
MFYR=FYR=FYR<FYR<FYR<FYR<FYV=FYR<FIR=FYR=FYN;FIZ>G)R<FYR=FXV-
MC'M\?&QL;&=G9V=G9V=G9V=G9V=H:&AH:&AG9V=G9VAH:&AG9V=G9VIJ:GY_
M?IF9F)R<FIR=FYR<FYV=G)Z>G9J;F9Z>G9R<FYR=FYR<FXF*B6AG9VAH:&AG
M9V=G9V=H:&EG9V=H:&=G:&=G9V=G:&=G9VAH:&AG:,G)R_______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________[W_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________^CHZ9G9V=F9V=G
M9V=G9V=G9V=F9V=G9V=F9V=H9V=G9V=X>'B<G)J<G)N<G)N<G)N<G)N<G)J<
MG)N<G)N<G)N=G9N%AH5M;6UH9V=G9V=F9V=I:&AH9V=G9V=H:&AG9V9H9V=F
M9V=I:VIW>'B*BXJ;FYJ<G9N<G)N<G)N<G9N<G9N<G)N=G9N<G9N<G)N<G9N=
MG9N<G)N<G9N<G)N<G)N<G)N<G)N<G9N<G)N<G)R<G)R<G)R<G)N<G)N=G9R<
MG9N<G)N<G)R<G)R<G9N=GIR<G)N=G9N<G)N=G9N<G)R;G)R;G)R<G)N<G)N<
MG)N<G)N<G9N<G)N<G9N<G)N<G9N<G)N<G9N<G9N<G)N<G)N<G)N<G)N<G9N<
MG)N<G9N<G)N<G)N<G)N<G)N<G)N<G)N=GIR<G)N<G9N<G9N<G9N<G9N<G)N<
MG)N<G9N<G)N<G9N<G9N<G9N<G)N<G)N=G9N<G9N<G)N<G)N<G)N=G9N1D9!\
M?7UL;6QH:&AG9V=G9V=H9V=H9V=H9V=G9V=G9V=G9V=F9F9J:FI_@'^7F):=
MGIR>GIR;FYF=GIR=G9N<G9N<G)N;FYJ<G9N&AX9G9V=H9V=H9V=G9V=F9V=G
M9V=H9VAG9V=H9VAG9V=G9V=H9VC)R<O_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\]____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________HZ.F9VAH9F=G9V=G9V=G9V=G9V=G
M9V=G:&AH9F=G;W!PGIZ<G)R;G9V;G)R;G)R;G)R;G)R;FYN:GY^=B(>';&QL
M9VAH9V=G9V=G:&=G9V=G:&=G9V=H9V=G9F9F:&AH=75UBHJ*FYJ9GIZ<F9F8
MG)R;G9V;G)R:G)R;G)V;G)V;G)V;G)R;G)R;G)V;G)V;G9V;G)R;G)V;G)R;
MG)V;G)R;G)R;G)R;G)R;G)V;G)V;FYN:G9Z<G9V<G)V;G9V;G)R;G9Z:G9V:
MG9V<FYN:G9V<G)R;G)V;G)R;G)R;G)R;G)V;G9V;G)R;G)V;G)R;G)R;G9V;
MG)R;G)R;G)V;G)R;G)R;G9V;FYR:G)V;G9Z<G)R;G)V;G9V<G)V;G9Z<GIZ=
MG)R<FYR<G)R<G)R<FYR:G)V;G)R;G)R;G)R;G)V;G)V;G)R:G)V;G)R;G)R;
MG)V;G)R;G)V;G)V;G)V;G)R;G)R;G)V;G)V;G)V;G)V;G9R;G)R:C8V-=WAX
M:FIJ9F9F9V=H9V=G:&=G:&=G9V9F9V=G9F=G9V=G:FIJ?G]^G9V;G)R;G9V;
MG9V<FYN:G9V;G9Z<G)R;G)N:?7U]9F9F:&AH9V9F9F=G9V=G9V9H9V=G:&=H
M9V=G9V=G9V9GRLK,____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________O?__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________Z.CIF=G9V=G9V=G9V=G9V=G9V=H:&=G9V=G9VIJ:I24
MDYR<FYR<FYR=FYV>G)J:F9Z>G)V=FY"1D')R<VAH:&=G9FAG9V=G9V=G9V=G
M9V9F9F=G9V=G9VQM;7]_?Y*2D9V=FYZ>G)V=FYJ;F9Z>G9V=G)N;FIR<FYR<
MFYR<FYR=FYR=FYR=FYR=FYR=FYR<FYR=FYR<FYR<FYR=FYR=FYR<FYV=FYR=
MFYR<FYR<G)R<G)R=G)N;FYR=G)R<FYN;FIV=FYN<G)R<G)R<G)N<G)R<G)R<
MG)R<G)R<G)R<G)R<G)R<G)R<G)R<G)R<G)N<G)N<G)V=FYR<FYR=FYN<FIR<
MFYR<FYR<FYR=FYR=FYR<FYN;FIR<FYR<FYR<G)R<G)N<G)R=F9R<FYV>G)R=
MFYR=FYR<FYR<FYR<FYR<FYR<FYR=FYR<FYR=FYR<FYR=FYR=FYR<FYR=FYR<
MFYR<FYR=FYR=FYR=FYR<FYV=G)N;FIR<FYV>G)N<FIZ>G9:6E8B(AV]O;V9G
M9VAI:6AG9VEH:&=G9VAG9V=G9V=F9F=G9VYN;HJ+BIR<FYR<FYR<FYV>G)J;
MFIR=FYR<FYR<FV]P<&=G9V=G9VAH:&=G:&AG:&=G9VAG:&=G9VAH:&=F:,G*
MR___________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________[W_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__^CHZ9G9V=G9V=G9V=F9V=G9VAG9V=F9V=F9F:"@X*=G9R<G9N<G)N;G)J;
MFYJ=G9R6EI5]?'QG9VAG9V=F9V=H:&AF9F9I:6AH9V=G9V=G9V=P<'"'AX:<
MG)J=G9R<G)N<G)N<G)N<G)N<G)N=G9R:FYF<G9N<G)N<G)N=G9N<G)N<G)N=
MG9N<G)N<G9N<G9N<G9N<G9N<G)N<G)N<G)N<G)N=G9N<G)N<G9N;G)J<G9N=
MG9R<G9N<G9N=G9R<G)N=G9N<G9N<G9N<G)N<G)N<G9N<G)N:FYN<G)R<G9N<
MG)N<G9N<G9N;FYJ<G)N<G)N<G)N<G)N=GIR;G)J=G9R=G9R=G9R<G9N<G)N;
MG)R=G9R<G)N<G9N<G)N<G)N<G)F=G9J<G9N<G)N<G9N<G)N<G)N<G)N<G)N<
MG)N<G9N<G)N<G)N<G)N<G9N<G)N<G9N<G)N<G)N<G9N<G9N<G)N<G)N<G9N=
MG9N<G)N<G)N=GIR<G)N<G)N=GIR=G9R=G9N<G)N=G9N-C8QQ<7%H:&AG9V=H
M:&=H9V=I:&AG9V=H:&AF9F9G9V=R<G*5E92<G)N=G9R<G9N;FYJ=G9N=G)N+
MC(MH:&AG9V=H9V=G9V=G9VAG9V=G9FAG9V=G9V=G9VC*RLS_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\]____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________HZ*F9V=G9V=G
M9F=G9F=G9V=G9VAH9F=G:6EIG)V;G)R;G)R;G9Z<FYN:G)R;C(R,;&UM9V=G
M9V=G:&AH9V=G9F9F:6AH:&=G:&=G<G-SC8Z-G)R:FYN:G)V;G)V;G)R;G9V<
MG)V;G)V;G)R:FYR:G9Z<G)R;G)R;G)R;G)V;G)R;G)R;G)R;G)R;G)R;G)R;
MG)V;G)V;G)R;G)V;G)R;G)R;G)V;G)R;G)R;G)R;G)V;G)R;G9Z<G)R<G)R<
MG9V=G)R<G)R<G)R<FYN;G9Z<FYN:G)V;G)R;G)R;G)R;G)V;G)R;G9V<G9Z<
MG9V;G)V;G)R;G9V=FYN;FYR;G)R<FYN;G)R;FYR:G)V;G9V;G)R;FYN;G)R<
MG)R<G)R<G)R<G)R<G)R<FYR;G)R<G)V<FYR:G9V<G)R;G)V;G)V;G)R;G)V;
MG)V;G)V;G)V;G)R;G)R;G)R;G)V;G)R;G)V;G)R;G)R;G)R;G)R;G)R;G9V<
MG)R;G9Z<G9V;G)V;G)V;G9V;G)R;FYN:GIZ<E)23>'EY9V=G9V=H9F9F9F9F
M:&=G:&=G9V=F:6AH:6IJ@X.#G)R;G)R;G)V;G)V;G9V<G9V;=WAX:&AH9V=G
M9F=G9V=H9V=H:&=H9F=G:&=G9V=HR<K,____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________OO__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________Z.CIF=H:&=G9V=G9V=G9V=G9V9G
M9V=G9VYN;IN;FIR<FYV>G)V=FYV=G'Q]?6=G9V=G9V=G:&=G9VAG9V=F9FAG
M9V=G9W%R<HR,BYR<FYR<FYV=FYV=G)R=FYR=FYR<FYR=G)R<FYR=FYR<FYR=
MFYR<FYN;FIV>G)J;F9R<FYR<FYR<FYR<FYV=FYR<FYR<FYR=FYR<FYR<FYR<
MFYR<FYR<FYR<FYR=FYR<FYR<G)V=G9V=G9V=FYR=FYV>G)R<FYV=FIR<FYR=
MFYV=FYJ;FYV=G9N;FYR<G)R<G)R=FYR=FYR<FYR<FYR<FYR<FYR=FYR<FYR<
MFYV=FYN;FIR<FYR<FYV=G)R<FYR<FYR<FYV=G)R<FYR=FYR<FYR=FYN;FIR<
MFYR=FYR<FYR=FYN<FIR=FYR=FYR<G)R<G)R<FYR=FYR=FYR=FYV=FYR<FYR<
MFYR=FYR=FYR<FYR<FYR<FYR<FYR<FYV=FYR<FYR=FYR=FYR<FYR=FYR<FYR<
MFYR<FYR<FYV=FYR=FYN;FIV>G)Z>G)24DW1U=6=H:&AH9VAH:&AH:&=H:&9F
M9F=G9V=G9W9V=IB8EYZ>G)N;FIV=FYV=FY&1D&5F9FAG9V=G9V=F9V=G9V=F
M9V=G:&=G9V=F:,G)R___________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________[[_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________^CHZ9G9V=G9V=F9V=G:&AF9V=G:&AG9V=Q<7&<G)N>
MGIV<G)J8F)9P<'!F9V=G:&AG9V=F9F9H9V=H9V=I:&AL;&V'AX><G)N<G)N=
MG9R:FIF<G)N<G9N<G)N=G9R<G)N;FYJ<G)N>GIV<G9N<G9N>GIV<G)N<G)N<
MG9N<G9N<G)N<G)N<G9N<G)N=G9N<G9N<G)N<G9N<G9N<G)N<G)N<G)N<G)N<
MG9N<G)N<G9N<G9N<G)N;G)J=G9R<G)N<G)N<G)N<G9N<G)REI:2QL*^OK["_
MOK[%Q<7#P\7$Q<C/T-';V]K<W-O;V]K;V]K<W-O:VMK<W-O;VMG;V]K:VMG<
MW-O!PL3$Q,;#Q,;$P\.UM+6PL+"OKZVAH:"<G)N>GIJ<G9F<G)R<G9N<G)N<
MG9N<G)N;G)J<G)R<G)R<G9N<G9N<G)N<G9N<G)N<G)N<G)N<G)N<G9N<G)N<
MG9N<G9N<G9N<G)N<G)N<G9N<G)N<G9N=G9N<G)N<G)N=GIR=GIR<G9N;FYJ;
MG)J<G)N=G9R<G9N>GIV<G)J-C8QO;V]G9V=F9F9G9V=F9F9G9V=H9V=H9V=L
M;&R0D(^=G)N>GYV;G)J>GIUO;W!H9V=G9V=G9VAG9V=H9VAF9V=H9V=G9VC)
MR<O_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________^]________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____HZ.F9V=G9V=G9F=G9F=G9V=G9V=G9V=G<W-SG)V;G9V;D9&0:FIJ9V=G
M:&AH9V9F:&=G9V9F:&=G9V=G>WQ\F9F7G)R:G9V<G)V;FYR;G)R;G)V;G)R;
MG)R;FYR;G)V;FYN:G9V<G9V;G)V;GI^=FIN9GIZ<FYR:G9V;G)R;G)V;G)V;
MG)V;G)R;G)V;G)R;G)R;G)V;G)R;G)R;G)R;G)R;G)V;G)R;G)R;G9V:G)R;
MH*"@L;&QO[Z^Q<7'W-S;W-S=\O/T\O+R\_/R\?'Q\_/R\_/S\O+R\_3S\_/R
M\O/R\O+Q\O/R\O+Q\_3U\_3U\O/T\O/T]/7U\_3U\O/S\O/T]/3S\O+R\O+Q
M\_+S\_+S\_+T\_+Q]//R]/+QY^?GVMO<T,_/Q,/$M+2UL+"NG9V=G9Z<G)R;
MG)V;G)V;G9V;G)R;G9V;G)R;G)V;G)R;G)V;G)R;G)V;G)R;G)R;G)R;G)V;
MG)R;G)R;FYN:G)R;G)V;G9V;G)V;G)V;G)R;G)R;G9V;GIZ<G)R;G)R;G)R;
MFYR:G9V<G)R;G)R;@H*":FIJ:&=G:&AH9V=G9V=G9VAH9V=G:VMKAH:&G)R;
MG)R;FYN:@H*":&AG9V=G:&=H9V=G9V9H9V=G9V=G:&=HR<G+____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________O?__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________Z.CIF=G9V=H
M:&=H:&9G9V=G9V=G9V=G9W-S<YV=FXV,C&EJ:FAH:&=G9VAH:&=G9VAG9V=G
M:&]P<)"0CYV=G)R=FYR<FYR<FYV<FYR=FYR=FYR=FYR=FYR<FYR<FYR=FYV=
MFYR=FYR<FYN<G)V=FYR=FYR=FYR=FYN<G)R=FYN<G)N;FYV=G9R=FYR=FYR=
MFYR<FYR<G)V=G)R=FYR<F9R<FZNJJ;FZNLC(RMK;W>KKZ_/S\_+S]//T]//T
M]//T]/+R\O+S\O+S\O+R\O+R\O+R\O+R\O+S\O+R\O+R\O+R\O+S\O+S\O+R
M\?+R\O+S\O+R\O+S\O+R\O/S\O+R\O+S\O+S\O+R\O+R\O+R\?+R\?/S\O+R
M\O+R\?/S\O/S\O+S\O3T\_+R\O+R\O+S\O+S\N?HZ-35UL/%QZ^OK:&AH)R<
MG)R<G)R<FYR<FYR<FYR=FYR<G)N<G)J;FYV=G9R<G)V=G9N<FIR=FYR=FYN;
MFYR<G)R<G)N;FYR<FYR=FYR<FYR<FYR<FYR<FYR=FYR=FYR=FYR=FYR<FYR<
MFYV=FY.3DG-T=&9F9F=G9VAG9VAG9VAG9V=G9V=G9XB'AYV=FYR=FXV-C&=G
M9V=H:&AG:&=G9V=G:&=H:&=G9V=G:,G*S/__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________S[_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________^CHZ9G9V=G9V=F9V=G9V=G9V=F
M9V=G9V=R<G.&AH9G9V=G9V=H9V=H9V=G9V=G9V=G9V=[?'R8F)><G)J=GIR<
MG)N<G9N=G9N<G)J<G)N<G9N<G)N<G)N<G9N<G)N<G)N<G9N<G)R;FYN<G9R<
MG)N=G9R<G)N<G9N<G)R<G)N;FYJ<G9N<G9N<G)N<G)R=G9N=G9N=G9ROKZW$
MQ,3<W-OM[.SU]/7R\?+S\O'R\O'T]//R\O+R\_/R\_3R\_3S]//R\_+R\O+R
M\_+R\_+R\_+R\O+R\O'R\O'R\O+R\O+R\O'R\O'R\O+R\O+S\_+R\_+R\_+R
M\O'R\_+R\O+R\_+R\O+R\O+R\O'R\O'R\O+R\O+R\_+R\O+R\O+R\_+R\O'R
M\_+R\_3S]/3T]?7R\_3R\_3R\_+R\O'S\_'S\O3T\_+HY^7/S]"_O[^KJZJ;
MG)R<G)R<G)N<G9N=G9N<G)N<G9F;FYJ=G9R<G)R<G)R=G9R=G9F;G)J<G)N<
MG)R<G)R<G)N<G9N<G)N<G)N<G)N<G)N<G)N<G)N<G)N<G)N=G9N=G9N;FYF#
M@X-G9V=G:&AH9V=I:&AH9V=H:&AG9V>'B(><G9N=G)MH:&AF9V=G9FAG9V=G
M9VAF9V=H9V=H9VC)R<O_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________^^________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________HJ*F9V=G9V=G9V=G9V=G9F=G9V=G9V=G;FYO9V=G
M9VAH9V9F:&=G:&=G:&AH:VMKA8:%G)R;G9V;G)V;FYR:G)R;G)R;FYR:G)R;
MG)R;G)R;G)V;G)R;G)R;G)V;G)R;G)V;G)V9G9V<FYR<G9V=G)V;G9Z<G)R<
MG)R<G)R<G)R<G)V;FYR8G)V;JZNJO[[`V]G9\O'Q]O3S\_+Q\O+S]//T\O+R
M\O/R\_/R\O+Q\O/R\O+Q\_/R\O/R\O+Q\O+Q\O+R\O/R\O+R\O+R\O+Q\O/R
M\O/R\O+R\O+R\O+Q\O+Q\O/R\O/R\O+R\O+R\O+R\O/R\O+R\O+R\O/R\O+Q
M\O+R\O+R\O+Q\O/R\O/R\O+Q\O/R\O+R\O+Q\O+R\O+R\O/R\O/R\O/T\O/T
M\O/T\_3T\O/S\O/T\O/T\O/T\O/T\O'Q]O3S\O'Q]//Q[N[LS]#3NKJYIJ:E
MGIZ>G9V<G)R;FYR<G)R<G)R;G)R<G)V;G)R;G)V;G9V;G)V;G9V<G)V;G)R;
MG)R;G)R;G)R;G)R;G)R;G)R;G)R;G9V<G)R;G)R;G9V<FYN9D9&0;&QL9V=G
M:&=G:&=G:&=G:&AG9F=GA8:%FYN:9V=G9V=G9V=H9VAH:&=H9VAH:&=G9V9G
MR<K+________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________/?______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____Z.CIF=G9V=G9V=H:&=G9V=G9V=G9V5F9FAH:&AG9V=G9VAG9V=G9V=H
M:&EI:I"1CYV=FYR<FYV=FYR<FYN;FIV=FYR<FYZ>G9R<FYR=FYR<FYR=FYV=
MG)R<FYR<FYR<FYR<FIR<FYV=G9N<FYR<FYR=FYR<FYN;FIV=G)V=G)N;F[2T
MM,_/S^7EY_7T]?3S]/3S\O+S]/#Q\O3T\_+R\?+S\O+R\O/T\_/S\O+S]//T
M]?/S\O+R\O+R\O+R\O+R\?+S\O+R\?+S\O+R\O/S\O+S\O+R\O+S\O+S\O+S
M\O+S\O+R\O+R\O+R\?+S\O+S\O+S\O+S\O+S\O+R\O+S\O+S\O+R\O+R\?+R
M\?+R\?+R\O+R\?+R\?+R\O+R\?+R\?+S\O/S\O+R\?+S\O+S\O+S]/+S\_+S
M]/+S\_+S\_+S]/3U]?'R\_3U]?7T\O+Q\?7T\_3S]/;T\^'AXKZ_P*JJJ9R<
MFYR<FYN<FYV=G)R=FYR=FYR<FIV=G)R<FYR=FYR<FYR<FYR=FYR=FYR<FYR<
MFYR=FYR<FYR=FYR=FYR<FYV>G)V=G)R<FYV=G)F8EV]P<&=G:&9G9VAG9V=F
M9F=G9V9G9X:'AF=G9V=G9V=F9V=H:&AG:&=G9V=G9VAG:,G*S/__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________[O_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________^BHJ9G9V=G
M9V=G:&AG9V=G9V=G9V=G9V=G9V=H:&AG9F9H9V=G9V=O;V^4E).<G)J<G9N=
MG9R;FYJ;FYJ>GYV<G)J>GIV<G9N<G)N<G9N<G)N<G)N<G)N<G)N<G)N=GIR=
MG9N<G)R<G)R;G)N<G9N;G)J<G)R<G9VSM++.S]#M[.OT\O'S\_3T\_+T\O+S
M\O'R\_3R\_3R\_3S]/3R\_/S\O3S\O3T\_+U]//R\_3R\_/R\_3R\O'T]//T
M]//Q\?'R\_3R\_+R\_+R\O'R\O+R\_+R\O+R\_+R\O+S\_+R\O'R\O+R\O'R
M\_+R\O+R\O+R\O'R\O+R\_+R\O'R\O'R\O'R\_+R\O+R\O'R\_+R\O'R\O+R
M\O'R\_+R\O'R\O+R\O+R\O+R\_+R\_+R\_+R\_+S]//R\O+R\_+U\_+T\O'S
M\O'T\O+S\O3R\?+S\O/S\_3R\_+R\O+R\_3T\_3S\O/GY^3#P\*DIJ2<G)N=
MG9V<G)R<G)N=G9N<G)N<G)R=G9Z<G)N<G9N<G)N<G9N<G9N<G9N<G9N<G9N<
MG9N<G)N;FYJ<G)N=G9N;FYJ<G9N8EY9R<G)H:&AG9F9G9F9H9V=F9F=I:6EG
M:&AG9V=G9FAG9V=H9VAG9V=H9V=H9VC)R<O_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________\^________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________HZ.F9V=G9V=G9VAH9V=G9V=G
M9V=G9VAH9F=G:6AH:&=G9V=G<'!PF9F7G9V;G)R;G)R;G)R;G)R;G)V;FYR:
MGIZ=FIN9G9V<FYN:G)R;G)R;G)R;G)R;G)V;G9V;G)V;G)R;G)R<G)V;G)R;
MFYN:I::FRLK(Z.CE]//T\_+S]//R]/+Q\_+Q\_+T\?+S]/3S\O/R\_+Q]?/R
M]//R\_+Q]?3S\_+T]//U\_+T\_3U\_3T\_3T\O+R\O/R\O+Q\O/R]/7U\O+Q
M\O/R\O+R\O+R\O/R\O+R\O+R\O+Q\O/R\O/R\O/R\O+R\O+Q\O+Q\O+R\O+R
M\O/R\O/R\O+Q\O/R\O+Q\O+R\O/R\O/R\O+R\O+R\O+R\O/R\_/R\O+R\O+R
M\O/R\O/T\O/T\_3T]/7U\O/R\O/R\O/R\_3S\_+S]?3U]//T]//T\_+S\_+S
M]//R]/+Q\O/P\_/R\O/T\O/R\O+R\/'P]_7V]//TXN'@N;JZH:*AG)R;FYR<
MG)R<G)R;FYN8G)R;G)R;G)R;G)R;G)R;G)V;G)V;G)R;G)V;G9Z<FYN:G)R;
MG)V;G)R;G9V<G)R:G)R;<G-S:&AH9V=G:&AH9F=G9V=G9V=G9V=G:&=H9VAH
M9V=H9V=G:&AG9V9GR<K,________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________O?______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________Z.CIF=G9V=G9V=G9V=H:&=H:&=G9V=G9V=G9VAG
M9V9F9FIJ:I65E)V=FYR<FYV=G)R=FYV>G)R<FYV=G)R=FYR=FYR<FYZ>G9R=
MFYR<FYR=FYR<FYR<FYV>G)R<FYR<FYR<FYR<F9N<G+J[O=K:W/3S\O/R\_'R
M\_+S\O+Q\_7T]?+S]/+S]/#Q\/3T\_+R\O+S\O3S\O3S\O3S\O3S\O3R\O+R
M\?3T\_+S\O+S]/+S\_/T]/+S]/+S]/3U]?+S]//T]/+R\O+S\O+S\O+R\?+R
M\O/S\O+R\?+R\?+R\?+R\O+S\O+R\O+R\O+R\?+S\O+R\?+R\O+R\?+R\O+S
M\O+S\O/S\O+S\O+S\O+S\O+R\O+S\O/S\O+R\O+R\O+R\O+R\O+S]/+S]/+S
M]/+S]/+S]/+S]/+S]/+S]/3S]/3S]/7T]?7T]?/R\_3S]//R]//R]/+S]?+S
M]/+S\O+R\?+R\?3T\_#Q\/3T\_;T\_3S].WL[,W-SJJKJIR<FYR<FYR<G)R<
MFYR<FYR=FYR=FYR<FYR<FYR<FYR<FYZ>G9J;F9V=G)R<FYR<FYZ>G9N;FIZ>
MG9R<FYB8EV]P<&AG9VAG9VAG9V9G9V=G9V9G9V=F9V9G9VAG:&=G9VAG9V=G
M:,G*S/______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________[W_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______^CHZ9G9V=G9V=F9V=G9V=G9V=G9V=G9V=G9V=H9V=F9V>0D(^;FYJ;
MFYJ=GIR;G)J<G9N=G)N=G9R;G)J=GIR<G)N>GYV<G)N<G9N<G)N<G)N<G)N<
MG)N<G)N<G)N<G)NAH9^_O\'IYN7T\_+T\_3R\_3R\O'R\O+R\_+R\_3R\_3R
M\O+S]/3S]/3R\_3R\_3R\O/S]/3Q\O/T]?7S]/3R\_/R\_3R\_+S\_/S]/3S
M]/3S]/3S]/7S]/7R\_3R\_3T]?7R\O'R\_+R\_+R\_+R\O'R\_+R\O+R\O+R
M\O+R\_+R\O+R\_+R\_+R\O'R\_+R\_+R\O+R\O+R\_+R\_+R\_+R\O+R\_+R
M\O+S\_+R\O'R\O+R\O+R\O+R\_+R\_+R\O+R\O+R\_+S]/3R\_3R\_3T]?7R
M\_3R\_3S]/3R\_3R\_+Q\?'R\O+R\O+R\_+T]//T\_+T\_+T\_3S\O3S\O3T
M\_+T]//R\_/R\_3S]/3R\_3U]/7T\_+<VMJUM+2<G)N=G9N<G)J<G)N<G)N<
MG)N<G)N<G)N<G)N<G)N>GYV<G)N<G)N<G9N<G9N<G)N<G9N<G9N=G9R8F)9J
M:VMH:&AH9V=G9V=H9V=G9V=G9VAG9V=G9FAF9V=H9V=H9VC)RLO_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________HZ.F9V=G
M9V=G9V=G9V=G9V=G9V=G9VAH9V=G9V=G@8*!G9V;FIJ9G)R;FYN:G9V<G9V;
MG)R<G9V<G)R;GIZ=G)R;G)V;G)V;G)V;G)R;G9V;G)R;G9V;G)R;H*"@P\/&
M[.OK\O+R\O+Q\O+Q\O+R\_/R\O/R\O/R\O+Q\O/T\O/T\O/T\O/T]/+Q]//R
M\_+S\O'R]//T]//T\O'S\O'R\_+S\_+S]//R]/+Q]//R]/+Q\_+S\_+T\_+S
M]//R]//R]?3R]//S]?/T\O+S\_+QQ,3'P\3$Q,3#H:&CGY^BH:"CH:"CH)^@
MAX>*@8&$@(&#@(""@(&#@(&#CHZ1H:"AGY^BH*&CGY^CJJJMQ<3$Q,/$S<W/
M\_+Q]?3U\O'R\_3U\_3T\O/R\O/R]/7U\_3T\_3T\O'R]//T]//T\_+T\_+T
M\_+T\_+S]?3T]//T\O/T\O/T\_+S\_+S\_/S\_3T\O/T\O/T\O'P\_+Q\O+R
M\O+Q\O+R\O/R\O+Q]/3S\?'QYN?IN;JZG)R<G)V;G)R;G)V<FYR<G)R<G)R<
MG)R;G)R<G9V=FYR:G9Z<FYN:G)R<G)R<G)V;FYR:G)R;C(R+9VAH9V=G9V=G
M9V=G9V=H:&=H9F=G:&=H9V=G:&=G9V9HR<G+________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________OO______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________Z*BIF=G9V9G9V=G9V=G9V=G
M9V=G9V9G9V=G9W%R<J"@GIN;F9V=G)J:F9Z>G)R<FYR<FYR=FYR<FYV=G9R<
MFYV=G)R=FYR=FYN<G)R<F9N<FYN<G*&AH,/"PN[M[//R\?/R[_+R\O+S\O+R
M\O+R\O+R\?+R\O+R\O+R\O/R]/7T]?/R]//T]//T\_'Q\?+R\O+R\?3S\O+Q
M\/3U]?+S]/3T\_+R\O/T\_/T]/+S]/+S]/+R\O3R\<_/T,;$QJ"@I)>7FH*!
M@7-S=&=H:&9G9V=G:&=H:&=F9VAG:6AG9V=G9V=G9VAG:&=F9VAG:&=F9V=G
M9VAG:&AG:&=G:&=G:&AH:&=F9FEH:&AH9F=F:&=G:&=G9V=G:&=G:(."@X&`
M@Z&@H:FIK,3#Q.?EY?3R\?+Q\?+R\?+R\?/T]/+R\O+R\?+S\O+S\O+S\O'Q
M\?+Q\?3S\O7T\_'P[_/R\_3S\O3R\O+R\O+S\_+S\_+R\O+S\O+R\?/S\O+S
M\O+R\O/T\_#Q\//R\.GHZ+BYNIR<FYR<FYN;FIV=G)R<FYR<FYR<FYR<FYV=
MG9R<G)R<G)R=FYR<FYR=FYR=FYR<FYR<FH!_?V9F9FAG9VAH:&=G9V=F:&=G
M:&=F:&9G9VAH:&AG:,G)R_______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________[[_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________^CHZ9G9V=G9V=G9V=G9V=G9V=F9V=G9V=H:&B4
ME).=G)N<G)N=GIR=G9R<G)J<G)N<G)N=G9R<G)R<G)R<G)N=GIR;FYN<G)R<
MG)F<G9N<G)R_P+_JZ>KU]?;T\_+U]/+S\O3R\O'R\O+T]//S]//R\O+R\O'R
M\O+R\O+R\_3R\_/Q\?#R\_3R\_3S]/7V]//T\_'R\_3S\_+T\_+R\?'U]/7S
M\O/T\_'.SL^SL[20D).!@81F9V=G9V=H:&AG9V=G9VAF9V=G9VAF9V=H:&AH
M9V5H9V=H9V=G9F9G9V5F9V=G9V=G9V=G9VAG9VAG:&AG9VAG9V=H:&AH9V=I
M:&AG9F9H:&AG9F=H:&EH9V=G9F9G9V=H9V=G9V=G9VAG9VAG:&AG9V=H9V=G
M9V=K;&V`@8*@GZ&[NKS;V=OR\O+R\_3R\?+U]/7T\_3U]/7R\O'R\O'Q\O/R
M\_3T\_3R\?+R\?+U]//R\_+R\_+R\_+R\O'R\_+R\O+R\O+Q\O'R\O+T]//R
M\_3R\_3U]/7;V]NMKJV<G)F<G9N=G9N<G9N;FYJ=G9R<G)N<G)N<G9N<G)N=
MG9R=GIR;FYJ=G9N;FYJ8F)=J:FIH:&AH9V=G9V=G9VAF9V=H9VAG9V=H9V=H
M9VC)R<O_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________^^____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________HZ.F9VAH9V=G9V=G9VAH9V=G9V=G9V=G:VMKFYN:GIZ=G)R;G)V;
MG)V;FYR:G9V<G)V;FYR<G9V<G)R<G)R<G)R;G)R<G)R<G)V;L+&OYN;D]//T
M\_/T]/3S\O/T\O/T\O+R\_/R\O/R]/3S\O+R\O+R\O+R\O/R]/3S\O+R\O+R
M\O/T\_3T\/'R]/3S\O/T\_+S\_+S\_+S]?+UT,_2GY^B@8&$;6UN9V=G:&=H
M9V9H:&=H:&=H9V=H:&=H9V9G9V9G:&=G9V=G:&=G9V9G9V=H9V=G:&=G9V=F
M:&AH9V=F9V=G:&=G:&=G9V=G:&AH:&=G9F=G9V=G9V=H9F=G9F9F9V=G9F=G
M9V=G9V9F:&AH:&AH:&=G9F9F:6AH9V=G9F9G9V9G9V=H:&=H:&AH9V=G9V=G
M:&=G9V=G<G)TD)"1LK*TVMK:]?3U\_3U\?+S\_+S]/3S\/#P\O+R\O/S\_3U
M\/'R\O/T\O/R\O+R\O/R\O+Q\O/R\O+Q\O+R\O+Q\O+Q\O/T\O/T\?'Q\_+Q
M\O'ST]/3IJ:FG)R<G)R;G)R;G)R;G)V;G)V;G9V;G9V<G)R;FYN:G9Z<FYR:
MG9V<FYN:AH:&9F9F:&AH9V=H9V=H9V=G:&=H9V=G:&AH9V=HRLK,________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M/O__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________Z.CIF=G
M9V=G9V=G:&=G9V=G9V=G:&=G9W!P<)Z>G9J;F9V=G)V=G)R=FYV>G)V=FYR<
MFYV=G)N;FYV=G)R<FYR<G)R<F:&AH-73U//S]/3S\O3T\_+R\O/S\O+S\O+S
M\O+S]?+R\O+R\O+R\?+S\O'Q\/+R\?+R\O+S\O3S]//R\?/R\//S\?+R\?/T
M]/+R\>3EYK*QLY"0DVMM;6=G9VAG96=G9VEH:&EH9V=G96AG9VAH:&=F9VAH
M:69G:&=G9V=G:&AG9V=F9FAG:&AG:&=F9V=H:&=H:&=G9VAH:6AG:&AG:&=G
M:&AG:&AG9V=G9VAG9V=G:&=G:&AG:&=G:&=F9VAG:&AH:6AG:&=G9V=G9VAG
M9VAG9VAH:&=G9VAG9VAG9V=G9V=H:&=G:&=G:&=G:&=F9VAG9VAG9V=H:&AH
M:&AG9V=H:'-S=9>6F,7$Q?7S\?3S]//R]/3T\_#Q\/+S]/'R\_+S\_+R\O+S
M\O/S\O/S\_/S\O+R\O+S\O+R\O+R\O7T]?+Q\?3T\_+R\O3R\?/R].WM[;Z_
MOYR<G)N<G)R<FYV=G)R<G)R<G)R<FYZ>FIR=FYR<FYV=G)R<FYR<FYB8EVEJ
M:F9F9F=G9VAG:&=G9V=G:&9G9VAG9V=G:,G*S/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________SW_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________^CHZ9G9V=G9V=G9V=G9V=G
M:&AF9V=G9V=R<G.<G)N>GIR<G)N<G9N>GIV;FYJ<G)N<G)N;FYJ<G)F=G9N;
MG)R<G)FTM;7LZ^ST\_+U]/7R\_3Q\?'S\_+R\_3R\_3Q\O/R\O'R\O+R\O'R
M\O'S\_+R\_+R\O+R\O+S\_/P\_3R\O+R\O+S\O3FY>>RL;2(B(IF9V5H9V=G
M9V=H:&AH:&AH9V5G9F5H9V=G9F=G:&AG9VAF9V=H9V=G9V=H9V=I:&AH9V=G
M9F=G9VAH:&AG9V=G9V=F9F9G9VAF9V=H9V=H9V=G9F=G9VAG9F=G9VAF9V=G
M:&AF9V=G9VAF9V=G9VAH:6EG9V=H9V=G9V=F9F9G9V=G9VAH:&EH:&AH9V=G
M9V=G9F9G9V=G9V5G9V9H:&9H9V=G9VAG9VAG:&AH9VAH9VAF9F=G9V=G9V=G
M9V=I:6EM;&V0D)+%P\7S\?'S\O/R\O+Q\?'S\O3S\_3R\O'R\_+R\O'S]//R
M\_+R\O'R\O+R\O+T\_+U]/7R\?/T\_+R\_3R\_3R\_+T]?7@X-^KK*Z=GIR<
MG)F<G)J<G)R<G)R<G)N<G9N=G9R<G)N<G)N<G)N<G9MX>'AG9V=G9V=H9VAG
M9V=G9VAG9V=G9V=G9F?*RLS_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________\^____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________HJ*E9V=G9F=G9V=G9V=G9V=G9VAH9VAH<W-S
MG)R;G)R;FYN:G9V<G9V;G)R;G)R;G)R;GIZ:G)R=G)R;H:.@U=74\O'R\_+T
M]//T\_/Q\O+Q\_3U\O/T\_+S\O+R]/3S\?'Q\O+R\O/R\O/R\O/R\O/R\O/R
M]/3S[^_O\O+R]/3SQ,3%D)"29F=H:&=G9V9F:6AH9V=H:&=I9V=G:&=H9V=H
M9V=H9VAI9V=H9V=G9V9F:&=H:&=H9V9G:&=H:&=G9V=H9VAH9F=G9V=H='1T
M@H*#@8&$F9B:H9^AH:&CGY^CQ,3$Q,7%P\/$Q,3%Q<;&P\3%Q<3%QL3&Q<3%
MQ<3$N[J[HJ*EGYZ@H)^ACX^1@'^"@H&#9VAH9F=G9V=G:&=H9F5F9V9G:&=H
M9V=H:&=H9F9G9V9G9V=H:&AH9F9G:&AI:&=I:&=H:&=H:&=H9V=H9V=H9V=G
M9V=G<G-TH)^AV]K;]_3V\_+S]O3S\O/R\O+Q\O/R\O+Q\O+Q\O+Q\O+R\_/R
M]//U]/+Q\_+Q]?3U\O+S\O/T\O+R\O+Q\?+U[.SJOK^^G)R<G)R;G)R;FYR<
MFYR<G9V<G9V;G9Z<FYN:GIZ=G)R;BHJ*:&AH9V=G:&=H9F=G9V=H9V=G9V=G
M:&=HR<G+____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________O?__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________Z.CIF=G9V=G:&=G9V=G9V9G9V=G9V=G9W)R<IV<FYR=FYR=FYR=
MFYR<FYR<FYN;FIN<FIN<G)R=F:NKJNGHYO3S]//R\_/T]/+S\?+S]//T]//R
M\_3S\O3S\O3S\/3R\O+S\_+R\O+R\O+S\O3T\_+S\O/S\N_P[^7FYK.RM'-S
M=F=G9VAH9FAG:6=G:&=G:&=H:&=G9V=G:&AH:69F9VAG:&AG9V=G9VAG9V=G
M:&AG9V=G9V=G9W)R<W^`@Y^?HK&QL\3$Q]K:V_3R\O/R\?3S]/+S]/+S\O+S
M\O/R\?3S\O/R\_7T]?/S]/7T]/+S]/+S]/+R\O+R\?+R\?3T]?/R\_3S]//R
M\_3S]/+S\O/S\_+Q\O+Q\_;T\\[.T,3#Q*&AHYB8FH"`@V=H:&9F9F=G9V=G
M:&=G9V=G9VAG9V=G9V=G9V=G9V=G9V9G9V=H:&=G:&AG9VAH:&AG9V=F9F=G
M:(B(BL7%Q?#Q\/+R\O+R\O+R\O+S\O+R\O+R\O+R\?+R\?3T\_+S]/7T]?+Q
M\/7T\_+R\_/T]?'Q\?+S\O+S]/3R\M74TZ&AH9V=F9R=F9V=FYR<FYR<FYR<
MFYR=FYN;FIN<FI65E&=G9V=G9VAG:&=H:&AG:&=G:&AH9VAG:,G)R_______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_S[_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________^BHJ5H
M9V=H:&AH9V=H9V=G9V=G9V=G9V=R<G*;FYN<G9F<G9N;FYR<G9N<G)F=GIR;
MG)J<G)RYNKKU\_'R\_3R\_3R\O+R\O'T]?7S\O/S\O3T\O+R\O'R\_+R\_3S
M\_3S\O3T\_+U\_3Q\O'T]//T\_+FY.2@GZ)L;&YG9V=H:&=H9VAG9VAF9V=G
M9V=H:&EH9VAF9V=G9V=G:&AF9F=G9VAG:&AG9VAL;&V(B(N@H*+$Q<7DX^/R
M\O+R\_/R\_3T\_7R\_+R\O+R\O+R\O+R\O+R\O+R\O+R\O+R\_+R\O+R\O+R
M\O+R\O'R\_+R\_+R\O'R\_+R\O+R\_+R\_+R\O'R\_+R\_+R\O+R\O+R\O'R
M\_+R\O+S\_+R\_+S\_+R\O+R\_3U]/7T\O';VMJZNKN9F)J`@(%G:&EG9FAH
M9VAG9VAG9V=G9V=H9V=G9VAG9VAG9VAG9V=H9V=G9V=G9F=G9VAG9VAS<W2Q
ML;/T\>_S\_3T\_+T]//R\_/R\_3R\O+S\_+R\_3R\_3R\_#T]/'R\O'S]/7R
M\_+T\O+R\_+R\_3Q\O7GY^>IJJN=G9N<G)N<G9N=G)R<G)R<G)N=G9N;FYJ=
MG9QG9V=G:&AG9VAF9V=G9F=G9V=H9V=G9F?)RLS_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________\^____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________HJ*F:&=G9V=G:&=G:&=G
M9V=G9V=G9V=G<W-SG)R;G9V<G)V;G)V9FYR;G9V<G)R;G)R<SL[/\O'O]//T
M\_3T\?+S\_/R]/3S\?+S\/'P\_3T]//T\O'R]?3U\O/S\O/R]/3S\O+Q\?'Q
M]?/TY.3FH*"C;&UM9F=G9V9H:&=H9F9G9V=G9V=G:&=G:&=H9V9H9V=H:&=H
M9V9G:&=G;6UNB(B*J*BJSL[0]/3S]O/R]/+Q]/+Q\O/T\O/T\O+R]//R]//R
M\O+Q\O+R\O/R\O/R\O+Q\O/R\O+R\O/R\O+R\O+R\O+Q\O/R\O+R\O/R\O/R
M\O+Q\O+R\O+R\O+R\O+R\O+Q\O/R\O+R\O+R\O+R\O+R\O+R\O+Q\O/R\O+Q
M\O+Q\O+Q\O/R\O+R\O/T\_+S]?3U\O'S]?3U]/'RQL3%H*"A>7I\9FAG9F=G
M:&=G:&=H9V=H:&AH9V9G9V9H9V=H9VAH:&AH9V=G:&AF9V=G<G)TL;&T\_+S
M\?'Q\?'P]//T]//T]?3S]//R]//T\O/T\O/T\O+R\O/R\O/R\_+S]/7U\?+P
M\_/Q]//RZ^KKM+2UG)R;G)R9G)R<FYR;G)R;G9R;G9V=G)R;9F=G9V=G:&=H
M9V=G9V=H9V=G9V=G:&=HR<K+____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________/?__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________Z.CIFAG9VAG9VAG9VAG9VAG9V=G9V=G9W-S
M<YN;FYR<FYZ>FIR=FYR<FYR<G*&AH,W.SO/R]//R\_/R\_/R\_7T\_'Q\?+S
M]//T]?+S]/+R\?3S\O/R]/+Q\O'Q\//S\O+S]//T]?/R]*BHJFUN;6=G9VAG
M:&AG9VEH9F=G:&=G:&AG9VAH:&=F:&AH:69G9V=G9W1T=)B8F;JZN_7S\O#O
M\?/T]/#Q\O3R\O/R]//R\_+S]/+S]//R\_/S]/3S\O7T\O+R\O+R\O+R\?+R
M\O+S\O+S\O+R\O+R\O+S\O+R\O+R\O+R\?+R\O+S\O+R\O+R\O+S\O+S\O+R
M\?+S\O/S\O+R\?+R\O+S\O+R\?+S\O+S\O+R\O+R\?+R\?+S\O+R\O+R\O/T
M]/+S]/+S]/+S]//T]?+R\O3T\_+R\?+S]/7T]N;EZ+*QM8B(BF=G9V=G9FAG
M9V=G9VEH:&=G9V=G9V=G9V9G9V=G9VAG9F=F9V=H:(&!@\3#Q?7T]?+Q\O/R
M\_+R\_3S\?+Q\//R\_3S]/3R\?7S\O/Q\//R\?+S]/+S\O3U\O3S]/+R]/;T
M\KBYN9V=G)R<FYR<FYV=FYV=FYN;FYR=G&=H:&=G9VAG:&=G9VAG:&=G9V=G
M9V=G:,G)R___________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________SW_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________^CHZ9G9V=H:&AH9V=H9V=H9V=G9V=G9V=S<G.<G)R>GIJ<G)R=
MG9R;G)R?H:#?W][S\O'R\_3S]/7T\_+S\O'R\?#T\_3R\_3R\_3R\O+R\O'R
M\O+R\_+R\?+S\O/T\_3S\O'$P\1Y>GMG9V=H9VAG9VAH9VAG9VAG9V=H:&9G
M:&AF9F=G9V=H:&AL;&V/CY+"P\3R\O+R\_+T\_+U]/7T\_3R\?+S\O/T\_3S
M]//R\_+R\_+R\O+S\O3S\O/T\_3T\_3R\O+R\O+R\O+R\_+R\O+R\_+R\O+R
M\O+S\_+R\_+R\O'S\_+R\O'R\O'R\O+R\_+R\_+R\O+S\_+R\O+R\_+R\O'R
M\_+R\O'S\_+R\_+R\O+R\O'R\O+R\O+R\_+R\_+V]//T\O+T\_+R\?#P\?'S
M\_/R\_+R\_+Q\O+R\O'P\?'R\O+S\O3R\?+GYN>QL;:!@8)G:&EF9V=H9VAG
M9VAH:&AG9VAG9VAG9FAH9V=G9V=H9V5G9V>0D)3EY>7T\_+U]/;S\O/T\_#T
M\_+U]/7S\O3P[_'U]/7R\O'R\O+S]/7R\_3R\?+U]/+T\_+U]/.XN;N<G9N<
MG)F<G)R<G)N>GIV;FYMG:&AG9V=H9VAG:&AH9VAG9V=H9V=H9VC)R<O_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__^]________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________HJ*F
M:&AG:&=G:&=G9V=G:&=G9V=G9V=G<W-SG)V9G)R<G9Z<FYN;HJ*BX.#>]?3U
M\O/T\O/R\/'Q]O3S\_+Q]//T\_+S\O/T\O/T]//R]//T\_3U]/3S\O+Q]//T
MY^7EEYB;9V=G9V=H:&=G:&=F9V=H9V=H:&=G:&=G9V=G9VAH9V=G>7EZL;&S
MYN7F]/+S]//R\O'R]//T\_+S\?+S]?7T\?+S\?+R\_3T\_+S]//R\_+Q]/+Q
M\_/R\O/R\O/R\O/R\O+R\O+R\O/R\O+Q\O/R\O/R\O+R\O+Q\O+R\_/R\O/R
M\O+R\O+R\_/R\O+Q\O+R\O/R\O+R\O+R\O+R\O+R\O+R\O+R\O/R\O+R\O/R
M\O+R\O+R\O/R\O/R\O/R\O/R]O3S]//R]//R]O3S]//S\_+S\_+T]//T]//R
M]//R\O/S\O+R\O+R\O+Q[_#O\_3U\_+SV-C:H:&C;6UM9V=F:&=H9V9H9V=G
M9V=H:&=H:&=G:&=F:&AI9F=G;&UON[J\\?'Q\O/T\O/S\_3S\/#P\_+S]?3U
M\O'P\O/S]?/R]/+R\O'S\_3U\?'Q\O+R\O/U\_+QNKFZFIR:G9V<G)R;G)V;
MG)V;9VAH9V=H:&=H9VAH:&=H9V=G:&=G9V9GR<K+____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________OO__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________Z.BIFAG9VAG9VAH:&=G
M9V=G9V=G9V=G9W)R<YV=FYR<FYR=FYR=F]G9V/3S\O/R]/+R\O'R\_3U]?+S
M\_3S]/7T]?/R\_+R\?+R\O+Q\_/R\_+S]//T]/3R\M#.S7AY?&=G9VAG:&=G
M9V=H:&=G9VAH9FAH9VAG:&=G9V=G:(>'BL3$Q?+S\O+S]/3S]//R]/'R\O7S
M\_3R\?+R\O+S\O'Q\?+R\?3S]//R\_7T]?/R\_3S]//R\_+R\O+R\O+R\O+R
M\O/S\O/S\O+R\O/S\O+R\?+R\?+R\O+R\O+S\O+R\?+R\O+R\?+R\?+R\O+S
M\O+R\O+R\O+S\O+S\O+R\O+R\O+R\?+R\?+R\?+R\?+S\O+R\O+S\O+S\O+R
M\?+S\O+S\O+S]//T]?+S]/+R\O3R\?/R\?/R\?3R\O+S]/'Q\?/S\?+S\/#P
M\//R\?7T\_'P[_/T]//S\O3S]//R\[*QLW)S<V=G96AG:&AH9VAG9FAG9VAG
M:6AG:&9F9F=G:&=G9XZ/D>?FY/+R\_+S]/+R\?+S]/+Q\_3S\O7S]/+Q\/;T
M\_/R\?+S]/7U]/+S]/+S\_+S]/3R\;FZNIN=FYR<G)R<G)V=F6=H:&=G9V=G
M:&=G:&=G:&=G9VAG9V=F:,K*S/__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________S[_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________^CHJ9G9V=H9V=G9V=H9V=G9V=G9V=G9V=R
M<G*=G9N<G)N:FYO.S\_V]//S\O/V]?+R\?/S]/3Q\O/T]?7P\?+Q\O/T]//R
M\O+R\_+R\_3R\O+T\_+T\O*RLK1L;6UG:&9H:&=H:&AH:&EH9VAG9VAH:&EG
M:&AG9VB0D)+:V-GV\_'U]/7R\_3Q\_3R\_+T\O'T\_+R\O'P\?#S\O'S\O/S
M\O'T\O'T\_+Q\?#S\?#T\_+U]//T\_3R\_3R\_3R\_3R\_3R\O'R\_+R\O+R
M\O+R\O+R\O+R\O+R\O+S\_+R\_+R\O'R\O'R\O+R\O+R\_+R\O'R\_+R\O+R
M\O'R\O'R\O'R\_+R\O'R\O+R\_+R\O'R\_+R\_+R\O+R\O'R\_+R\_+T]?7R
M\_3S]/3S]/3R\_3S]/3Q\O+R\_3R\_3P\?+R\_/S\O/S\O'T\_+Q\._U]/7T
M\_+R\_3R\_+P\?#T\_3U\_2RL;-S='1F9F=G9VEG9VAF9V=F9F=H:&AG9V=G
M9VAG9V=Y>7S/SL[S\O'T]?7Q\O/T\_+T\_+T\_+T\_3S\O/T\O+U]?3Q\?'S
M]/3R\_/R\O'S\O3V]/&RL[2;G)R;G)R<G)MF9VAG9V=G9VAG9V=G9FAG9V=H
M9V=G9VC*RLS_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________^\________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________HZ.F9V=G9V=G:&=G:&=G9V=G9V=G9V=G<G)RG)R;G)R;P+_!
M]/+Q\_+T]O7R\O'P\_+T\_/R\O+Q\O/T\_/S\O/R]/3S\O/T\_/T\?/Q\?+S
M\O'PGY^B9V=H9F9G:&=G9V=H9V9H:&AI:&=G9V=G9V=G@8&$QL7&]/+R]/7U
M\O/R\_/R]/+Q]//R\_+T]/+Q\O/R\_+T\_+S\_+S\_+S]?3U\_+T]O3S]//R
M]O3S\O+Q\O+R\O/R]//R]//R]/+Q]/+Q\O/R\O/R\O+Q\O+Q\O/R\O+Q\O+R
M\O/R\O+Q\O+R\O/R\O+R\O+R\O+R\O/R\O+Q\O/R\O+Q\O+Q\O+R\O+R\O+R
M\O/R\O+R\_/R\O/R\O+Q\O+Q\O/R\O+R\O+R\O/R]/+R]?3R]//R\_+S]//R
M]?3R\O+Q\_3S]//R]/+Q\_+Q]//R\_+Q\_/T\O/T\O/T\?'P\O+R\/'R\?+S
M\O+R\O/Q\O+Q\_3TLK&S;&QN9V=E9V=G:&=H:&AG9VAH9V=H:6=G:&AH;&QN
MT,_.\O'R\?+T\/'R]//R\_+T]//T]//R\O+Q\O/T]//T]//T]//R\_/R]O3S
M\?+U[NWLJZJIG)R9FYN;9V=H9V=G9V9G9V=G:&=H9V=G:&=G:&=HR<K,____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____OO______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________Z.C
MIFAG:&=G9VEH:&=G:&AG:&=G9V=G9W)R<YV=F:^OL?/R\?+S\O+R\O+R\O/R
M]/;T\_+R\O/S]?3R\?+S\O3U]?+Q\O7T]?+R\O/T]/3S\(Z.D6AH:&AG:&AG
M:69F9V=H:&=G:&=F9F=G:&QL;;.RM/+Q\_+S]?'S\O+R\O+S\O+S\O+R\O+S
M\O+S\O+S\O+S\O+S\O+R\O+S\O+R\?+R\O+R\?+R\?+R\O+R\O+R\?+S\O+R
M\O+R\O+R\?+R\O+S\O+R\O+S\O+S\O+R\O+R\?+R\O+R\O+S\O+R\?+R\O+R
M\?+S\O+S\O+S\O+R\?+S\O+R\O+R\O+R\O+R\O+R\O+S\O+S\O+R\O+S\O+R
M\O+S\O+R\O+S\O+R\O+R\?+R\?+R\?+R\O+R\O+R\?+R\?+R\?+R\O+R\O/S
M\O+R\O+S\O/S\O+R\O+R\O+R\?+S\O+R\?+S\O+R\O+S\O+R\O+R\O+R\O+R
M\O+R\>;EY9>7FV=G:&=G9V=G:&AG:&=G:&9G:&=G:&AG96UL;;*QM/#P\/+R
M\O3R\?3S]/3S\O+Q\O/S]/+S]//S\O3R\?3S]/3S\?+S]/3S\O/R\^CHZ9^A
MH)N<F6AH9V9G9V=G:&=G9VAG:&=G9VAG9V=F:,G)R___________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________[[_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________^CHZ9H:&EG9V=H9V=H
M9VEG9FAF9F9G9V=R<G.BHJ+LZ^?S\O/T]?7Q\O'R\O+T\_3S\O'R\O'S\O'S
M\O3T\_+Q\?'U\_3S\O'P\?+R\?&.CY-H:&EG9FAG9V=H9V=H:&EH9VAG9V=G
M9V>'AXKEY>;Q\O/S\_'T\_#T\_3R\O'R\_+R\O+R\O'R\O+R\O+R\O+R\O+R
M\_+R\O'S\_+R\_+R\_+R\O+R\O'R\O+R\_+R\O'R\O'R\_+R\O+R\_+R\O+R
M\_+R\O+R\O+R\_+R\O+R\O'R\O+R\O+R\_+S\_+R\_+R\_+R\_+R\O'R\_+R
M\O+R\O+R\_+S\_+R\_+R\_+R\O+R\O'R\_+R\O+R\O+R\_+R\O+R\O+R\O'R
M\O+R\O+R\O'R\O+R\_+R\_+R\O+R\O'R\O'R\_+R\_+R\_+R\O'R\O+R\O'R
M\_+R\O+R\_+R\O+S\_+R\_+R\O'R\_+R\O'R\_+R\O'R\_+S\_+S\O'R\?#'
MQL=R<W1G9V=H:&AH9V=G:&AF9V=G9VAH9VAG9V>RL;7R\?/R\_3R\O'R\O+U
M]/+T\_3R\_3R\O+T\O'T\_3S\O/R\O'S\O/U]/7T\O+3T].;G9MG9F=G9V=H
M9VAG9V=H9VAG9V=G9V=H9VC*RLS_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________^^________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________HZ.F9V=H:&=G9V=G9V=H:&=H9V=G9V=G
M<W-TT]33]?/R\_+S\_+T\_/R\_+S\_+T]?3S\O/T]/+Q\_+S]?3S\_/R[_#Q
M\O+R]O/TEY>99V=H9V=H9V=H:&=G9V=G9V=G:&AH;&UNL;&S\O'P\O/S\?3R
M\?+Q]//T]O3S\O+R\O+R\O/R\O/R\O/R\O+R\O+R\O+R\O/R\O/R\O/R\O/R
M\_/R\O/R\O+R\O+R\O/R\O+R\O+Q\O+R\O+R\O+Q\O+R\O+Q\O/R\O+Q\O+R
M\O/R\O+Q\O+R\_/R\_/R\O/R\O+Q\O+R\_/R\O+Q\O+R\O+R\O/R\O/R\O+R
M\O+Q\O+R\O+Q\O+Q\O+R\O+R\_/R\O+R\O+R\O+Q\O+Q\O/R\O+R\O+R\O+R
M\O+R\O+R\O+Q\O/R\O/R\O+R\O+Q\O/R\O+R\O+R\O+R\O+R\O+Q\O+R\O/R
M\O+R\O/R\O+Q\O+R\O+Q\_/R\O/R\O+R]?3R\/'T]?;V\O+QY^;ECX^29VAH
M9V=G9V9F9V=G9VAH9F=G:&=G;6UMS\W.\O/T\_3T\/'P\/'P\O+Q]//R]//R
M]//T\_+S]//U]/7R\O'S]/3S]//R]//TM+6U:&=G9V=G9V9G9V=G:&=H9F=G
M9V=G:&=HR<K+________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________/?______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________Z.CIFAH9VAH9VAG9V=F:&=G9V=G9V=G9W9V=_/R\?7T]?+Q
M\O3S\O3S\O/R]//R\_3S\O'R\O/T\_3S\O/R]/+R\O#R\?7T];*QLVAG96=G
M:&AG9V=G9V=G:6AG9FAH:7-S=<_/S_3S\O/R]/+R\O+S\O3T\_'R\_'R\O+R
M\O+S\O+S\O+R\O+S\O+R\O+R\O+R\?+S\O+R\O+S\O+S\O+S\O+S\O+S\O+R
M\O/S\O+R\?+R\O+R\O+R\O+R\O+S\O+R\O+S\O+R\?/S\O/S\O+S\O+S\O+R
M\O+S\O+R\O+S\O/S\O+R\?+R\?+R\O+R\?+R\O+R\?+R\O+R\O+S\O+S\O+R
M\?+R\?+R\O+R\?+R\O+S\O+S\O+R\O+R\?+R\?+S\O+R\?+R\O+R\?+S\O+R
M\?+R\O+R\?+R\O+R\?+S\O+R\O+S\O+R\O+S\O+S\O+R\?+S\O+S\O+R\O+S
M\O+S\O+R\O+R\O/S\O3S]/+R\?+S]/3U]?+S\_;S]+.RM&=H:&AG9VAG9V=G
M9V=G9V9F9VEG:&QL;-K:VO'P\?/T]//S\O'Q\?7T\O3S]/+R\_?U\_/R\_/S
M\O3S\O#Q\O7T]?/R\^SLZV=G9V=G9V=G:&=G9V=G:&=G9V=G9VAG:,G)R___
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____S[_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________^B
MHJ9H:&=G9V=H9VAH9VAH9V=G:&AG9V=^?7_R\_3S]/3T\_+T\_+T\_+T\_3U
M]/7S\O'R\_3R\_/S\O/S\O/R\?+T]//-S<]G9VAG9F9G9V=F9F9H9VEG9V5H
M:&EX>7KEY>;R\_3Q\?#T\_+Q\/+T\_7T\_+Q\?#T]?7R\_+R\O+R\O+R\O'R
M\O'R\_+R\O+R\O+R\O'R\_+R\O+R\O+R\_+R\O+R\_+R\O+R\O+R\O+R\O+R
M\_+R\O'R\O+R\O+R\O+R\O'R\O+R\_+R\O'S\_+R\O+R\_+R\O+R\_+R\O+R
M\O+R\_+R\_+R\O'R\_+R\O'R\_+R\O+R\O+R\O'R\_+R\O+R\O'R\O'R\O+R
M\O'R\_+R\O+R\O+R\_+R\O'R\O+R\O+R\O+R\O+R\O+R\O+R\O'R\O+R\_+R
M\O+R\O+R\O+R\_+R\O+R\O+R\O+R\O'R\_+S\_+R\O+R\O'R\O+R\_+R\_+R
M\_+T\O+R\O+Q\O/R\O+S\_+S\O/T\_*[N[QL;6UH9VAH:&9G9F9H9V=H9VAG
M9VEY>GKS\O'T\_3Q\O/U]O;Q\._S\O/S\O/R\O+T\O+R\_3T\_'R\_3S\O'R
M\O+Q\O-G:&AG9V=G9FAF9V=G9VAG9V=H:&AG9VC)R<O_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________^]________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________HZ.F:&=G:&AH:&=H
M9V9H:&=G9V=G9F=G@H&"\O/T\O/R\_+Q\_+Q]/+Q]?3U\_+S]//R]?3U]//R
M]//T]?/T\_+Q]O3S>'E\:&=E:&=H9V=G9VAH9F9E9V=H>7EYZ.CH\/+S\_/R
M\O/T\_+T]//R]//R\_+S]?3U]/+R\O+R\O+R\O+R\O/R\O+R\O+R\O+Q\O/R
M\O/R\O/R\O+Q\O+R\O+Q\O/R\O+R\O+R\O+R\O/R\O/R\O/R\O/R\O+R\O+R
M\_/R\O+R\O+Q\O+R\O/R\O+Q\O/R\O+R\O/R\O+R\O/R\O/R\O+R\O/R\O/R
M\O+Q\O/R\O+R\O+R\O+R\O+R\O+Q\O/R\O+R\O+R\O+R\O+Q\O+R\O+Q\_/R
M\O+Q\O+Q\O+R\O/R\O+R\O/R\O+R\O+R\O+Q\O+Q\O/R\O+Q\_/R\O+Q\O/R
M\O/R\O+R\O/R\O/R\O/R\O/R\O+R\O+Q\O+Q\O+Q\O+Q\O+R\O/R\_/T]/+Q
M]//R]/+Q[_#O]/7R\O/TS\W-;&UO9V9G:&AF:&=G:&=H:&=H9F=GH:&D\O'P
M\_3V[_#Q]O3S\_+S]//T\_/R]?/Q\O/T]//R\O/T]?3S\O/R\_3U9V=G9V=G
M9V=H9V=G9V=H9V=G:&=G9V=HR<G+________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________OO______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________Z*BIF=F9FAG9V=F:&AG:&AG9V=H:&=H
M:(*!@O7S]/3S\O+R\O'Q\?3T]?+S]/+S\O+S\_/R]/3R\?'R\_3T]?;T\Z"?
MHF=G9VEH:&=G:&=F9V=G9V=H:')S<^?EYO/R]/3U]?3S]/3S]//S\O#Q\//T
M\_+R\?3S]/+Q\O+R\O+R\?+R\O+R\?+R\O+R\O+R\O+R\?+S\O+S\O+R\O+R
M\O+S\O/S\O+R\?+S\O/S\O+R\O+S\O+R\?+R\O+R\O+S\O+R\?+S\O+R\O+R
M\O+S\O+S\O+R\?+R\?+S\O+R\O/S\O+R\O+S\O+R\O/S\O+R\?+R\O+R\?+R
M\?+R\O+R\?+R\O+S\O+R\O+R\O+R\O+R\?+S\O+S\O+R\?+R\O+S\O+S\O+S
M\O+R\O+R\O+S\O+R\?+S\O+S\O+S\O+R\O+S\O/S\O+R\?+R\O+S\O+R\O+R
M\?+R\?+R\?+R\?+S\O+R\?+S\O+R\?+R\?'R\_3S\O3S]/3S\_3R\O3T\_+S
M\_'Q\/;T\[NZO6=H:6=F9VAG9V=G:&AH:&AG:&=G:=K8UO3S]/+S]/3S\O+Q
M\/7T]/+R\O3S\O3U]?3S\O+S]/3S\O/S]//R\6=G:&9G9VAG:&=H:&=F9V=G
M9VAG9V=F:,G)R_______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________[[_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________^BHJ9G9V=H9V=H9VAH:&EG9F9G9V=G9VB"@8+S\O3V]//Q
M\O/R\_3R\_3R\O+R\_+R\_3U\_+T\_+R\O#R\_/DY.-L;&UH:&9G9VEG9VAH
M9VEG9V=L;&W/S\_Q\O7R\_/V\O'S\O/S\_+R\_+T]//Q\O+S]/7Q\O/R\_+R
M\O+R\O'R\O'R\O+R\O'R\O'R\_+R\O+R\O+R\O+R\O'R\_+R\O+R\O'R\_+R
M\O+R\O+R\_+R\_+R\O+R\O'R\_+R\O+R\O+R\O'R\O+R\_+R\_+R\O+R\O+R
M\O+R\O+R\_+R\O+R\_+R\O+R\O'R\O'R\O'R\O'R\O'R\O+R\O+R\_+R\O'R
M\O+R\O+R\O+R\_+R\_+R\O+R\_+R\O+R\O'R\O+R\O+R\O+R\O+R\O+R\O+R
M\O'R\_+R\O+R\O+R\O'R\_+R\O+R\_+R\_+R\O+S\_+R\O'R\_+R\O+R\O+R
M\O'R\O+R\O+R\_+R\O'V]?+S\O/R\_7R\O+Q\?#R\_3S\O/S\O'S\O/R\?"I
MJ:QG:&AH9V=G:&AF9F=H9V=G9V6!@H?S\O'R\_3R\_'U]/+T\_3R\_3U\_3R
M\_7T\_+R\_3U]/7S\O3T\O%G9VAG9V=G9VAG9V=H9VAG9V=H9V=H9VC)RLS_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______^^____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
MHJ*F9F=G9V=H9V=G9V=H9V9H:&=G9F=G@(&"\O+Q\O+R\O+R\O/R\_/R\O+Q
M\O/R\O/R\_+T\O/S\O+Q]?/TGYZ@9V=G9V9G:&AH9VAH9V=G:&=GLK*W\O/T
M\?'M\_+T]?3U\O+R\O+R\O+Q\O+Q\O/R\O/R\O/R\O/R\O+R\O/R\O+R\_/R
M\O/R\O+Q\O/R\O/R\O+R\O+R\O+Q\O+R\O+Q\O+R\O/R\O+R\O+Q\O+R\_/R
M\O+Q\O+R\O/R\O+R\O+Q\O+R\O+R\O+Q\O/R\O/R\O+R\O/R\O/R\O/R\O+Q
M\O/R\O+Q\O+R\O+Q\O+R\O+Q\O/R\O+R\O+Q\O+R\O+R\O+Q\O/R\O+R\O+Q
M\O+R\O/R\O+Q\O/R\O+R\O/R\O+R\O/R\O+Q\O+R\_/R\_/R\O+R\O+Q\O+Q
M\O/R\O/R\O+R\O+R\_/R\O/R\_/R\O+R\O/R\O+Q\O+R\O+Q\O+Q\O/R\O/R
M\O/R\O/R\O+R\O+R\O/R\O/R\_/R\O/R\O/R]//R\?'Q]//R@("&:&=G:&=F
M9V=E9V9H:&=G:&AFQ<3%]/7U\O'R]O3Q\O+R\_+T]//R\O/T\_+T\_/R]//T
M]//R]//T9V=G9V=G9V9G9F=G9V=H9V=G9V=G:&=HR<K+________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________OO______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________Z.CIF=G9VAG:&AG
M9V=G9V=F9VAG9V=G:(&!@O+R\?+S\O+S\O+S\O+R\?+R\O+R\O+R\?3S\?+S
M]/+R\N7CY&QL;F=G:&=G9VAG9V=G:&EH:(&`@_3S\O+S]/3S\O3S\_+R\_+R
M\?+R\O+S\O+R\O+R\O+R\O+S\O/S\O+R\O+S\O+R\O+S\O+R\O+S\O+R\?/S
M\O+S\O+R\?+S\O+R\?+S\O+R\O+R\O+S\O+R\O+R\O+R\O+R\?+R\O+S\O+R
M\?+R\O+S\O+S\O+R\O+S\O+S\O+R\O+R\O+S\O+R\?+R\?+R\O+R\O+R\O+R
M\O/S\O+R\O+R\O+S\O+S\O+S\O+R\O+R\O+R\?/S\O/S\O+S\O+R\?+S\O+R
M\O+R\?+R\?+R\?+S\O+R\O+R\O+R\?+S\O+R\O+R\O/S\O+R\?+R\O+R\O+S
M\O+S\O+S\O+R\?+S\O+S\O+R\?+S\O+R\?+R\O+S\O+R\?+S\O+R\O+R\O+S
M\O+R\O+S\O+S\O/S\O+R\?#Q\/+S]/3S\MS:V6UM;V=G:&AH9FAG:&=G9VEH
M:)"0D_#Q\?/R\?'O[_/T\_+Q\O3S\O+S]//R\_+S\O/R\_/R\?3S]&=G9V=G
M9V=F9V=G9V=F9V=G9VAH9V=F:,G)R_______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________SW_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________^CHZ9G9VAG9F=H9V=G9V=G9VAH9V=G
M9V>`@8+R\O+R\O+R\_+R\_+R\O+R\O+R\_+R\_+T\_+T]?7T\_*QL;1G9V=H
M:&EG9V=H9V=G9F=G:&C9U]CS\O/P\/#S\_7R\?+T]?7R\_+R\O+R\_+R\O'R
M\_+R\O+R\_+R\O+R\_+R\O+R\_+S\_+R\_+R\O'R\O'R\O+R\O+R\_+R\O'R
M\_+R\O+R\_+R\O'R\_+R\_+R\_+R\_+R\O+R\O+R\_+S\_+R\O'R\O+R\_+R
M\O+R\O+R\_+R\O+R\O'R\_+R\O+R\O+R\O'R\O+R\_+R\O'R\O+R\_+R\_+R
M\O+R\_+R\O'R\_+R\O+R\O+R\O'R\O'R\O'R\O+R\_+R\O'R\O'R\O+R\O+R
M\O+R\_+R\_+R\O+R\_+R\O'R\O+R\O+R\O+R\_+R\_+R\O+R\O+R\O+S\_+R
M\O+R\_+R\O+R\O'R\O+R\O+R\O+R\O+R\O+R\_+R\O'R\_+R\O'R\O+R\_+R
M\O+R\O'R\_3R\_3V]//T\_*@H*-F9V=H:&AG9VAG9V=H9VEF9V?EY>;R\?#S
M\O3Q\?#S\O/S\O'R\_3S\O/R\O'S\O/T\_+T\_1G9V=G9V=G9VAG9V=H9VAF
M9V=G9V=H9VC)R<O_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________\]____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________HJ*F9V=G:&=H:&=G9V=G:&=H:&AH9V=G@(&"\O+R\O/R
M\O+R\O+Q\O+Q\O/R\O/R\O+R\O'P\O/T]//RB(B+9V=E9V=H:&=G9V=G:&=H
MCHZ0]//T\?+S\?'Q]//U]//R\_3T\O+R\O/R\O+R\O+R\O+R\O+R\O/R\O+R
M\O+R\O+R\O+R\O+R\O+Q\O+Q\O/R\O+R\O+Q\O+R\O+Q\O/R\_/R\O+R\O+R
M\O+R\O/R\O/R\O/R\O+Q\O+R\O/R\O+R\O/R\O+R\O+Q\O/R\_/R\O+R\O/R
M\O/R\O+R\O+R\O/R\O+Q\O+R\O+R\O+Q\O+Q\O/R\O+R\O+R\O+Q\O/R\O/R
M\O/R\_/R\O+R\O/R\O+Q\O/R\O+Q\O/R\O+R\O/R\O/R\O/R\O+Q\_/R\O+R
M\O+R\O+Q\O+R\O/R\O/R\O/R\O+Q\O+Q\O/R\_/R\O+R\O+R\O+R\O+Q\O+R
M\O+Q\O+Q\O/R\O+R\O+R\O/R\O/R\O/R\O/R\O+Q\O+R\O/R\O+R\/'R\_+Q
M]//U\O+RY./D;6UN9V9G9V=G:&=G9V9G9V=FL;"T]//R\_/T\_+Q\_+S]/+Q
M\O/T\_+T\O+Q\_+S\_+Q\_+S9V=G9V=G9V9H9VAH:&=H9V=G9V=G:&=HR<K,
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________/O__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_Z*BI69G9V=G:&AG9V=H:&AG:&AG9V=H:("!@O+R\O+R\?+R\O+R\?+R\O+R
M\O+R\?+R\?+S\O#Q\/3Q\&UM;F=G9F=G:&=F9VAH:&=G9[NZO/+S]?/T]//Q
M\/3S]//R\?+R\O+S\O+R\O+R\?+R\O+R\O+S\O+R\O+S\O+R\O+R\O+R\?+S
M\O+R\O+R\?+S\O+S\O+R\O+S\O+S\O+R\O+R\O+R\O+S\O+S\O+R\O+R\O+R
M\?+R\?+R\O+R\O+S\O+S\O+S\O+S\O+R\O+S\O+S\O+R\O+S\O+R\O+S\O+R
M\?+R\?+R\O+R\?+R\O+R\O+R\?+R\O+R\O+R\O+R\O+R\O+R\?+R\?+R\O+R
M\?+R\?+R\?+R\?+R\O+R\O+R\O+R\?+S\O+S\O+S\O/S\O+R\O+S\O+R\?+S
M\O+R\?+S\O+R\O+R\?+S\O+R\?+S\O+R\O/S\O+S\O+S\O+R\O+R\?+S\O+R
M\?+R\O+R\O/S\O+S\O+S\O+R\?+R\?+R\O+R\?+S\O3S\?/R]/+R\O3S](^/
MD&=G:&=G9VAG9VAH:6=H9I"0DO+Q\O/R\_/R]/+R\?3S\O+S]//R\_+R\O/R
M\_3S\O/R\V=H:&=G9V=G:&=G9VAG:&=G:&AG9V=G:,G*S/______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________[[_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________^BHJ5G9V=G9F=H
M9V=G9V=H9VAH:&=G9V>`@8+R\_+R\O+R\_+R\_+S\_+R\O'R\O+R\O+R\O'T
M\_+.S<]G:&AG9VAG9F9G9VAH9V=M;6[V]?+S]/3T]//S\O/U\_+Q\?#R\_+R
M\O'R\O'R\O'R\O'R\_+R\O+R\O+R\O+R\O'R\O+S\_+R\O'R\O+R\O+R\O+R
M\O+R\_+R\O+R\_+R\_+R\_+R\O'R\O+R\_+R\O+R\O'R\O+R\_+R\O+R\_+S
M\_+R\O+R\_+R\O+R\O+R\O'R\O'R\O'R\_+R\O'R\O'R\O'R\O+R\_+R\O+R
M\O+R\O+S\_+S\_+R\O+R\_+R\O+R\_+R\_+R\_+R\_+R\_+R\O+R\_+R\O+R
M\_+R\_+R\O'R\_+R\_+R\_+R\_+R\_+R\_+R\O+R\O+R\_+R\O+R\O+S\_+R
M\O+R\O'R\O'R\O'R\O'R\_+R\O+R\O+R\O+R\O+R\O'R\O'R\O+R\O+R\O+R
M\O+R\O+R\O'R\_+R\O'S\_+Q\?'T\_+S]/7P\?+R\O&[NKQG9V=G9V=G9V=G
M9F=G9V=Y>7KT\_3U]/7S\O/R\_/T\_+R\_/T\_3R\_+T\_3S\O'T\_1G9V=G
M9V=H9VAG:&AH9VAF9V=G9V=H9VC*RLS_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\]____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________HZ.F9V=G9V9H9V=G9V=G9V9G:&=G
M9V=G@(""\O+Q\O/R\O+R\O/R\_/R\O+R\O/R\O+Q\/'P\_'QQ\;&9V=G9F9G
M9V=G9VAH:&=G@8&"\_'Q\O/T\O'P]?3R\O+R]/7U\O'S\O/R\O+R\O+R\O+Q
M\_/R\O+Q\O/R\_/R\O+R\_/R\O+R\O/R\O+R\O+R\O/R\O+Q\O/R\O+R\O+R
M\O+R\O+R\O+Q\O+R\O+R\O/R\O+R\O/R\O+R\O/R\O+R\O+R\O/R\O+Q\O+R
M\O+R\O/R\O+Q\O/R\O+Q\O/R\O+R\O/R\O/R\O+R\O+R\O+R\O+R\_/R\O/R
M\O+R\O+R\O/R\O+R\O+Q\O+R\O+R\_/R\O+R\O+R\O+R\O+Q\O/R\O/R\O+R
M\O/R\O+R\_/R\O/R\O/R\O/R\O/R\O+Q\O+R\O+R\O+Q\O+Q\O+Q\O+Q\O+R
M\O+Q\O+R\O+R\O/R\O+Q\O/R\O+R\_/R\O+Q\O/R\_/R\O+R\O/R\O+Q\O+R
M\O/R\O/R]/+R\_3S\_3T\O+R\O+RY>3E9F=G:&=H9V=G9VAH9V=H9V=G]?3U
M\O/T\_+Q]/7U]//R\O/T]//T\O+R]//T\_+Q\_+T9V=G9V=G:&=H9F=G9V9G
M9V=G9V=G9V=HR<G+____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________.___________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________Z*BIF=G9V=G:&AG9V=G9V=G:&=G9V=G9X&!@O+S\O/S
M\O+R\O+R\O+S\O+S\O+S\O+R\?+R\?/R\Z"@HV=G:&=F9V9G9V=H:&AG9Z&@
MHO;T\?'R]/7T]?/R\?3U]?/T]//R]/+S\O+R\O+R\O+R\?+R\O+R\O+R\?/S
M\O+R\?+R\O+S\O+R\?+R\O+R\O+R\?+R\O+R\?/S\O+S\O+R\O+S\O+R\O+R
M\?+R\O+S\O+R\O+R\O+S\O+R\?+S\O+S\O+S\O+R\?/S\O+S\O+R\O+R\O+R
M\O+S\O+R\?+R\?+R\O+S\O+R\O+R\O/S\O+R\?/S\O+R\?+R\O+R\O+R\O+S
M\O+R\O+R\?+R\O+S\O+R\?+S\O+S\O+R\O+S\O+S\O+S\O+S\O+S\O+S\O+S
M\O+R\O+S\O+R\O+R\O+R\?+S\O+S\O/S\O+R\O+S\O+R\?+S\O+R\O+R\?+R
M\O+S\O+R\?+R\O+S\O+R\?+R\?+S\O/S\O+R\O+S\O+R\O+S\O+R\?3R\?3T
M\_'R]?7S\?/R\_3S]'-T<V=G:&=G9V9G9V=G:&=G9_3S\O'R\_3S\?+S\_3S
M\O+S]//R\_/S\O3S]/3S\O/R\V=G9V=G:&=G:&=G9V=F9V=G:&AG9V=G:,G)
MR___________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________[[_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________]_?W^_?_____________^_O__
M__^CHZ5G9VAH9V=H9V=H9V=H:&=F9V=G9VB!@8+R\_+T]//S\_/R\_3R\?+S
M\O/T\O'T\O+S\O'S\O.?GZ%G:&9G9VAG:&AG9VAG9V>?GZ/T\_'R\O+T\_3R
M\?+T\O'R\O+Q\O+R\_+R\O'R\_+R\_+R\O+R\O+R\_+S\_+R\O+R\O+R\_+R
M\O'R\O+R\_+R\O+R\O'R\_+R\_+R\O+R\_+R\O+R\O'R\O'R\_+R\_+R\_+R
M\O+R\O+R\O+R\O+R\O'R\O+R\O'R\O+R\_+R\O+R\_+R\_+R\_+S\_+R\_+R
M\O'R\O'S\_+R\O+R\_+R\_+R\O+R\_+R\O'R\_+R\_+R\O'R\_+R\O+R\_+R
M\O'R\O+R\O'R\O'R\O'R\O'S\_+R\_+R\O'R\O'R\_+R\O+R\O+R\O+R\O'R
M\O+R\_+R\O'R\O'R\O+R\O+R\O+R\O+R\O'R\O+R\O'R\_+R\O'S\_+R\_+R
M\O'R\O+S\_+R\O+R\O+R\O'R\_+R\O'R\O+R\_+T\_3R\_3T\_+R\?+S\O'R
M\O*`@8-G9VAF9F=G9V=G9VAG9V?HYN7R\_7U\_+R\_3R\O+S\O/R\_3R\_+S
M\_3S]//S\O1G9V=G9F=G9VAG9V=H9V=G9VAH9VAG9VC)R<O_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\^____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________OW_______________[_____HZ.E9V=H:&=G
M9V9F:&=G:&AH9V=G9F=G@8&"\O+Q\O/R\O+Q\O/T\_+S\_+S]//R\O'P\O+R
M]//TH*"B9F=E:&=H:&=G9VAH:&=GH*"C]//R\O/T\O+Q\_/T]?3R\O/R\_3T
M\_/R\O+Q\O/R\O+Q\O/R\O+Q\O+R\O+R\O+Q\O/R\O+R\O/R\O+R\O/R\O+R
M\O+R\O/R\O/R\O/R\O/R\O+R\O+Q\O+R\O+R\O+Q\O+Q\O+R\O/R\O+R\_/R
M\O+Q\O+R\O+Q\O/R\O+Q\O+R\O+R\O/R\_/R\O+R\O+R\O/R\O+Q\O+R\O+R
M\O+R\O+R\O+Q\O+R\O+R\O/R\O/R\O+R\O+Q\O+R\O+Q\O+R\O/R\O+Q\O+Q
M\_/R\O+Q\O/R\O+R\O/R\O/R\O+R\O+Q\O+Q\O/R\O+R\O/R\O/R\O+Q\O/R
M\O/R\O+Q\O+Q\O+Q\O+Q\O/R\O+R\O+R\O/R\O+R\O/R\O+R\O+R\O/R\O/R
M\O/R\O/R\O/R\O+R\O+Q\O/R]//T\O/T\O+Q]/+Q\_+S]//T@("":&=H9VAH
M9F=G:&AI9V=GV-C:]/3V\_+Q\_3U\O/R]//T\?'Q]/3S]//T\?'Q]?3U9V=H
M9VAH9V9H9V=G:&AI9V=H9V9H:&=HR<G+____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________OO__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________S[_?[]_:2DIF9G9V=G9VAG9V=G9VAG9V=G
M9V=H:(*!@O+S]/3U]?#Q\O/S\_/R\?3S\O3S]//R]//S\O3S]*"@HVAH:&AG
M:&=F9F=G:&=G9Y^?H//R\_+S\_+R\O/R]/3S\O+R\O+S]/+R\?+S\O+R\O+R
M\O+R\?+R\O+S\O+S\O+S\O+R\?+R\O+S\O/S\O+R\O+S\O+R\O+R\?+R\O+R
M\O+R\O+S\O+S\O+R\?/S\O+R\O+R\O+R\?+S\O+R\?+R\?+R\O+S\O+S\O+R
M\O+R\O+R\O+S\O+S\O+R\O+R\O+R\O/S\O+R\O+S\O+R\O+R\O+R\?+S\O+R
M\O+R\O+S\O+R\O+R\?+R\O+R\?/S\O+R\?+S\O+S\O+R\?+R\O+R\?+R\O+R
M\O+S\O+R\O+R\?+S\O+R\?+R\?+R\O+R\?+S\O+S\O+S\O+R\?+R\?+R\?+S
M\O+R\?+R\O+R\O+S\O+R\O+R\O+R\O+S\O+R\?+S\O+S\O+R\?+R\O+S\O+S
M\O+S\O/S\O/R\_+R\O/T]/#Q\/3T]?3S]'-T=F=G9VAG9V=G9V=G:&9G9_7T
M]?+S]//Q\/+S]/+R\O7T]?+R\?+S]/+R\_3T\_+Q\&=H:&=H:&=F9V=G9V=F
M9V=G9VAG9VAG:<C(RO__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________SS_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________VBHJ5G9V=G9V=H:&AH9VAH9V=G9V=F9V>!@8+S]/3T
M]?7R\_3R\_+T\_+T\O+U]/3U]/3Q\?'U]/7%Q,1F9F9H9V=H9V=G9VAF9V>(
MB(KS\_7S]/3T]//U]/3T\_+S]/7S]/3R\_+R\O'R\O+R\O'R\O'R\_+R\O'R
M\_+R\O'R\O'R\_+R\O+R\_+R\O'R\_+R\O'R\O+R\O+R\O'R\O'R\O+R\O'R
M\O+R\O+R\O'R\O+R\O+R\_+R\O+R\O+R\O+R\O+R\_+R\O+R\O'R\O+R\O'R
M\_+R\O+S\_+R\O+R\O'R\_+R\_+R\O'R\O+R\_+R\O+R\O'R\_+R\O'R\O+R
M\O'R\_+R\O'R\_+R\O+R\_+R\O+R\O+R\O+R\_+R\O+R\O'R\O+R\O+R\O'R
M\_+R\O+R\_+R\O+R\_+R\O'R\_+S\_+R\O+R\O'R\_+R\_+R\_+R\O'R\_+R
M\O+R\O+R\_+R\O+R\O+R\O+R\O+R\_+R\O'R\O+R\O+R\O+R\O+R\_+S\O/Q
M\>_Q\O/T]//R\_3R\?!F9VAH:&AH9V=F9V=H9VAG9V?T\_3T]//T\O+T]?7R
M\O+Q\?+T]//P\?+S\O/R\_/EY>1G9VAG9V=H9VAG9V=H:&EG9V=H9V=G9VC)
MRLO_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________\]________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____HJ*F:&=G:&=G:&AG:&=H9V9F9V=G:&AI>7EZ]//T\._Q\_+T]O3S\O+Q
M\O/R\O/S\O/T\_/S\_3TSLS,9VAH9V=G9V=G9V=G:&AH<7)T]//R]/7U[_#P
M]?/T]//R\O/T]//Q\O+R\O/R\O+Q\O/R\O+R\O/R\O/R\O+R\O+R\O+R\O/R
M\O/R\_/R\O/R\O/R\O+R\O+R\O+R\O/R\O+R\O/R\O/R\O+R\O+R\O+R\O+R
M\O+Q\O/R\O/R\O+R\O+Q\O+R\O+Q\O/R\O+R\O+Q\O/R\O+R\O+Q\O+R\O+R
M\O+Q\O/R\O+R\O+R\O/R\O+Q\O+R\O+Q\O/R\O+Q\O+R\O/R\O/R\O+Q\O+Q
M\O+R\O/R\O+Q\O+R\O+Q\O/R\O+Q\O+Q\O+R\O+R\O+R\O+R\O/R\O+Q\O+Q
M\O/R\O+Q\_/R\O+R\O/R\O+Q\O/R\O+R\O+R\O+R\O+Q\O+R\O+R\O+R\O+R
M\O+R\O+R\O+R\O/R\_/R\O/R\O+R\O+Q\O+Q\O+Q\_3U\?'O]?;V\O+Q\._Q
MQ<3%:&AI:&=G:&AH9V=H9F=G>7I[\_/T\O+R]/+R\?+S]//R]?3U\O+R\O/T
M]//T\O/SQ,7&:&=I9V=G9V9H9F9F:&AI9V=G9V9F:&AIX>#A____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________O/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________S]_?____W\_O____S]_?___[2UN6AG9VEH
M:&=G9V=F9VAG9VAH:&9F9FAH:?+Q\/;T\_;T\_3S]/'R\_+S]/+S\O3T\_/R
M]/+R\O;T\V9G:6=G9FAG9VAH:&=G9V=G:-#.S?'R\_/T\_3S\O/R\_+S\O3S
M]/+S\O+S\O+R\?+S\O+R\O+R\O+R\O+S\O+R\O+R\O+R\O+R\?+S\O+S\O+R
M\?+S\O/S\O+R\O+S\O+S\O+R\?+S\O+R\?+R\O+R\?+S\O+R\O+S\O+S\O+R
M\?+R\?+R\O+R\O+R\O/S\O+S\O+R\?+R\O+S\O+R\O+R\O+S\O+R\O+S\O+R
M\O+R\?+S\O+R\?/S\O+S\O+S\O+R\?+R\?+R\?+R\O+R\O+R\?+R\O+S\O+R
M\O+S\O+R\?+R\O+R\O+R\?+S\O+S\O+S\O+R\?+S\O+S\O+R\O+R\?+R\?+R
M\O+S\O+R\?/S\O+R\O+S\O+R\O+R\?+S\O+R\?+R\O+R\?+R\O+S\O+S\O+R
M\?+R\?+R\O/S\O+R\O+R\O+R\O+S]/3S\O/T]/+R\O7T\YB8FF9G9VAG9VAG
M9V=G:&=G:(Z.D?3S]/+R\?3R\?/R\_+Q\O/R\_#Q\/3U]?7T]?'R\[R[NV=F
M9V=G9V=F9V=G9VAG:&=H:&AH:&=G:/_^_?__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________[[_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________W^_?_________[^_S)R<UG9V=H9V=H9V=G9FAH9V=G
M9V=H:&AG9VC.SM#R\?#T\_+S\O3S]/3S]/7R\_+R\O+S\O/S]//S\O.`@8-H
M9VAH:&AH9V=G9V=H9V>0D)'U]/3Q\O/V]//S]/3Q\?#R\_3R\O+R\O+R\_+R
M\_+R\O+R\O'R\O+R\_+R\O'R\O+R\_+R\O+R\O'R\O'S\_+R\O+R\_+R\O+R
M\O+R\O+S\_+R\O'R\_+S\_+R\O+R\O+R\O+R\O+R\O+R\O'R\_+R\_+R\_+R
M\O+R\O'R\O'R\O+R\_+R\_+R\O+R\O+R\O'R\_+R\O+R\_+R\O+R\O+R\_+R
M\_+R\O+R\O+R\O'R\_+R\O'R\_+R\O+R\O+R\O'R\O'S\_+R\O+S\_+R\O+R
M\O'R\O+S\_+R\O'R\_+R\O+R\_+R\O'R\_+R\_+R\_+R\O'R\_+R\O'R\O'R
M\O+R\O+R\O'R\O+R\O+R\O+R\O+R\O+R\O+R\O'R\_+R\O+R\O+R\O+R\_+R
M\_+R\O'R\O+R\_+T\_3S\_3S\_+T\_%M;6]H9V=H9VAH:&AF9V=H:&BSLK3R
M\_3R\_3S\O/T\_'S\O3S\O/T]//R\_/R\?+T]?6@GZ%H9VAG9V=G9F=H:&AG
M9VAG:&AG9VAM;6______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________^^________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________OW_____
M__[]_OW__________OW_[NSL:&=G:&=G:&=G9V9G:&=G9V=G:&=G9V9HL+&V
M]//P]//R]//T\_3T\O/T\O+R\O+Q\_+S\O+R\_+SJZFJ9V9G9V=G:&=G9V=G
M:&=G9F=HV=G;]?3U]//Q\O/T\O+R\O/T\O+R\O+R\O/R\O+R\O+Q\O/R\O+R
M\O/R\O+R\O+R\O+Q\O/R\_/R\O+R\O+Q\O+R\O+R\O+Q\O+R\O+R\O/R\O/R
M\O+R\O/R\O+Q\_/R\O+R\O+R\O/R\O+R\O+R\O+R\O/R\O/R\O/R\O/R\O/R
M\O+R\O+Q\O/R\O+Q\O/R\O/R\O+Q\O/R\O/R\O+R\O+R\O/R\O+R\O+R\O+Q
M\O+R\O+R\_/R\O+R\O/R\O/R\O+R\O+R\O+Q\O/R\_/R\O/R\O/R\O/R\O+R
M\O+Q\_/R\O/R\O+R\O+Q\O+R\O+R\O+R\O+Q\O/R\O+Q\O/R\O/R\O/R\O/R
M\O+R\O+Q\O/R\O/R\O/R\O/R\O/R\O+Q\O/R\O+R\O/R\O+Q\O+Q\O/R\O/R
M]//T\_+T]//RL+"U9V=G9V=G9V=H9V=H9V=H9V=GW-K:\O/R\O/T]?3U]//R
M]//T\_+S]/3S\?+S\_+Q\O'Q?X&#:&=G9V=H:&=H9V=G:&=H9V=G9VAH@H&"
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________/O______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________W5T=F=G9V=G9VAG:&=G:&=G9VAG9V=G:(F(BO7T\O#Q\O7T]?/R
M]/3S\O/Q\/+S]/3S]?+S\O+S].;EY6=G:&=G9VAG9V9G9VAG9VAG:(^/E/3R
M\O+S]/3S\O+Q\O+S\O3R\?+Q\?3S]/+R\?/T\_+S\O3S]/3S]/+R\O+R\O+S
M\O+R\O+R\O+S\O+R\O+R\O+S\O+R\O+R\O+S\O+R\?+R\O+R\?+R\?+R\?+R
M\O+R\?+R\O+S\O+R\O+R\O+R\O+S\O+S\O+S\O+S\O+R\?+R\O+R\O+R\O+R
M\O+S\O+S\O+R\O+S\O+S\O+S\O+R\O/S\O+R\?+S\O+R\?+R\?+R\?+R\O+R
M\O+S\O+R\?+R\O+R\O/S\O+S\O+R\O+R\?+R\O+S\O/S\O+R\O+R\O+R\O+R
M\?+S\O+R\O+R\O+S\O+R\O+R\O+R\O+R\O+R\O+S\O+S\O+R\?+S\O+R\O+S
M\O+R\O+R\?3S\O+Q\/3S\O3U]?'R\O+R\O+R\?+S\_CT]?/Q\?+S\N;EYFUM
M<&=G:&AG9V=G9V=G:&AG9XF)C/7S\O+R\O'Q\/3S]?/R\?+S]/3R\O3S]/+S
M]/+S].;DY6=G9V=G:&AG9V=G:&AG9V=G:6=G9V=G:*2BI?S_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________[W_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________^+BHUG
M9V=H9V=H9VAG9VAG:&AH9V=G9VAG9VGFY>3S]//R\_3T\O'T\O+R\?+R\O'T
M\O+R\_/R\_+S\O&/CY-F9V=H:&AH9VAG9V=H9VEG9V?%Q,7R\_+R\_3T\_'U
M\_3S\O/S\O3S\O/R\_3R\_3R\O+V]//R\?#R\_+R\_+R\O+R\O+R\O+R\O+R
M\O+R\O+R\_+R\O+R\O+R\O'R\O+R\O'R\_+R\O+S\_+R\_+R\_+R\O'R\_+R
M\_+R\_+R\_+R\_+R\O+R\O'R\O+R\O'R\O+R\O+R\_+R\O'R\O+R\_+R\_+R
M\O+R\O+R\O'R\_+R\_+R\_+R\O+S\_+R\O'R\_+R\O'R\O'R\O'R\O'R\_+R
M\_+R\O'R\_+R\O'R\_+R\_+R\O+R\O'R\O'R\_+R\O+R\_+R\O'R\O+R\_+R
M\_+R\_+R\O+R\O+R\_+R\_+R\_+R\O+S\_+R\O'R\O'R\_+R\_+R\_+T\_+S
M\O3U]/7T\_+U\_+T\_3Q\/+U]/7R\?#T\_3T\O*8F)IG9VAH9V9G9F=G9V=I
M:&AF9V?%Q,;S\O/R\_+R\_3S\O/T\_+R\O+S\O/T\_+T]//S]/2QL;-F9V=H
M:&=H9V=F9F=F9F9H:&EH:&AG9V?!P,+_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________\]________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________MK:Y9V=G:&=G:&AH9V=G
M9F=G9V=G:&=H9VAHLK*S]/3S\?+S]O3S\_+Q\O/T\O'P]//P[_#Q\_3T]?3S
MV]G;9F=H:&AG9V=H9V=I:&AF9V=G<W-TY^7E\O/R\O/T\_+T\O+R\O+R\O/T
M\_+S\_+S]?3U\?'Q\_3S\O+Q\O+R\_/R\O+R\O/R\O+R\O/R\O+Q\O+Q\O/R
M\O+R\O+R\O+R\O/R\O+R\O+Q\O+Q\O+R\O+Q\O+Q\O+R\O/R\O+R\O+R\O/R
M\O+R\O+Q\O+R\O/R\O+R\O+R\O+R\O+Q\O+R\O+R\O+R\O+R\O+R\O+Q\O+R
M\O+Q\O+Q\O/R\O+Q\O+R\O+R\O+R\O/R\O+R\O/R\O+R\O+Q\O/R\O/R\O/R
M\O+Q\O+R\O+R\O+R\O+Q\O/R\O/R\O+Q\O/R\O+Q\O+Q\O/R\O+Q\O/R\O/R
M\O+Q\O+Q\O/R\O+R\O+Q\O/R\O+Q\O+Q\O+R\O+Q]?3U\_+S\O'S\_+Q]?3R
M\O+S]?3U]//T\_/R]//TNKF[:&AH:&AF:&=H9V=E9F=H9V9F@8&$]_7T\O/T
M\O/R\O+R\O+R]//T]?/R]//T\O+Q\/'P\._Q@H*#9V=H9V=G9V=G:&AI9V=G
M9V=G9F9F9F=G[NWN____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________O?______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________]_?X6=G:&AF9FAG9V=G9V=G:&AG9VAG:&9G
M9WIZ>O/R\_+R\?+Q\_/S\_+R\?3R\?'Q\?3S\O/R]._O[_7T]9:6FFAI:6AG
M:&AG:&=G:&AH9F=G:'IZ?/3S\O'R]?3S]/#Q\/+R\O+R\?/R\?+Q\O'P\O/T
M]/+S\O+S\O/S\O+S\O+R\?+R\?+S\O/S\O+R\?+S\O+R\O+R\O+R\?+R\?+S
M\O+R\?+R\O+R\O/S\O/S\O+R\O+R\O+R\O+R\O+R\O+S\O+R\?+S\O+R\O+R
M\?+S\O+R\O+R\?+R\?+R\?+R\?+R\O+R\O+R\?+R\O+S\O+S\O+R\O+R\?+R
M\?+R\O+R\?+R\O+S\O+R\?+R\?+R\?+S\O+R\?+R\O+S\O+S\O+R\O+R\?+R
M\O+R\?+R\?+S\O+S\O+R\?+R\O+S\O+R\O+R\O+R\O+R\O+R\?+R\?+S\O+R
M\O+R\?+R\?+R\O+R\O+S\O+R\O+Q\O3R\?3R\O3S\O+Q\_7S\O/R\?3S]/+S
M]-#/T6QM;6=G:&=G9FAG:&9F9V9G9V=G:,;%QO#Q\/+S]//R\_+R\O+S\O+S
M]//R\?3U]?+R\?/T]-S:V6=G9V=F9V=G9V9G9VAG9V=G9V=G96AG9XF*C/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________SS_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________\__^"@H5I:&=H9V=G9V=G9VAH9V=G9V=G:&AF9F;%Q,7T]?7T
M\_3P\?+S\_'U\_3S\_+R\?+S\O/R\O+R\O+FY>9K;&YH:&9H:&AF9F9G:&AH
M:&AH9VB/CY+U\_+R\O+O\/'S\_/R\O+T\O'U]/+S\O/T]?7R\_3R\O'R\O+R
M\O+R\O+R\O+R\_+R\_+R\_+R\_+R\O+R\_+R\O'R\_+R\O+R\_+R\O+R\O+R
M\_+R\O+R\O'R\O+R\_+R\_+S\_+R\O+R\O'R\O'R\O+R\O+R\O'R\_+R\O+R
M\_+R\_+R\O+R\_+R\_+R\O+R\O+R\O'R\O+R\O+R\_+R\O'R\_+R\_+R\O'R
M\O+R\O+R\_+R\O'R\_+R\O+R\O+R\_+S\_+R\O+R\_+R\O'S\_+R\O'R\_+R
M\O'R\O'R\_+R\_+R\O+R\_+R\_+R\O+R\O+R\O+R\_+R\O+S\_+R\_+R\O+R
M\O+R\_+R\O'T\_3Q\._R\_+R\_/R\_/Q\O/R\O+R\O+1S]%K;&QG9VAH:&EH
M9VAH9V=H9VAH9V>&AXOT\_'S]?/R\O+S\_3T\O+R\O+R\_3S\_7P\?'S\_+R
M\?*0D))H9VAH9VAG9V=H:&EG9F9G9VAG:&AH:&BSM+C]_?O_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________^[
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________/__
MMK:X9VAH9V9F9VAH9V=G:&=G9VAH9V=H:&=H>7E[]//T\O+Q\O/T\/'P\O'S
M\_+Q\_+S]//P\?+S\O/P]//TN[J[9V=G9V=G9V=H9VAH9F=G:&AH:&AHCX^1
MYN7E\_+S\O+T]?3U\_3T\O+Q\O/R\_'P]?3U\O+Q\O+R\O/R\O/R\O/R\_/R
M\O/R\O/R\O/R\O+R\O+R\O/R\O+Q\O+Q\O/R\_/R\O+R\O/R\O+Q\O+Q\O+R
M\O+R\O/R\O+R\O+R\O+R\O/R\O+R\O+Q\O+Q\O/R\O/R\O+R\O/R\O+Q\O+Q
M\O/R\O+Q\O/R\O+R\O+R\O+R\_/R\O+Q\O+R\O+R\O+R\O/R\O/R\O+Q\O+R
M\O/R\O+Q\O+Q\_/R\O+R\O+R\O+R\O+R\O/R\O+Q\O/R\O+R\O+Q\O+R\O+Q
M\O+R\O/R\O/R\O+R\O/R\O+Q\O/R\O/R\O+Q\O+Q\O+Q\O+R\O/R\O+Q]//R
M\_+T]/7U\/+S\O/S\_3U]//RS\_.;&QN9V=G:6EI9V9G9V9G:&AF9VAH<G)T
MY^7D]//R]/3S\O/Q\_+Q\O'R]?7S\O/T]//U\_/Q\O+QS\[09V=H9V9G:&AI
M9V=H9V9G9V=G:&=H9F9F;6UO[N_P_OW\__[_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________//______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________[]_&QM;FAH:&=F
M9VAG9V9G9V=G9VAG9VAG:&AG9ZFIJ_+S\O'P\?/R\_+R\O/R\?/R\_+Q\/7T
M]?+Q\?+Q\O;T\Y>7FV=G:6=H:&=G96=G:&AG:&AG9V=G9WAY?>?EX_3R\O+Q
M\_/T]O+S\O3T\_/R\?3S]/+R\O+R\O+S\O+R\?+R\?+R\O+R\?+S\O+S\O+S
M\O+S\O+S\O+S\O+R\?+R\O+R\?+S\O+R\?+R\O+S\O+R\?+S\O+S\O+R\O+S
M\O+R\O+R\O+S\O+S\O+R\O+R\O+R\O+R\O+R\?+S\O+R\?+S\O+R\?+R\O+R
M\?+R\O+R\?+R\O+S\O+S\O+R\O+R\O+R\?+R\O+S\O+R\O+R\O+R\?+R\O+S
M\O/S\O+R\?+R\O+R\O+R\O+R\?+S\O+S\O+S\O+R\O+R\O+R\O+R\O+R\?+R
M\O+S\O+R\O+R\O+R\?+S\O+S\O+R\O+R\O+R\O+R\O/R\?/R\_/T]/+S]//R
M]/3S\L3#PVML;V=G96AG:&=G9VAG9VAH9V=G:&9G:-#.SO/T]//R\?3S]/+S
M\O+S]/7T]?'P[O/T]//R]/'Q\/;U\H"`A&=G9VAH:&9G9V=G:&AH:&=H:&AG
M:&=G9Y*2E_K]_?O^_?[]________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________SW_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________^_O^DHZ-G9V=I:&EG9V=G9VAG9V=H
M9V=H9V=G9F=L;F[8V=OU]/3R\?+S\_'T\_3V]/+U]/;S\?'S\O3T\_3U]/7T
M\O&0D))G:&AG9V=G9VAF9V=G9FAG9FAG:&9R<W;/SLST\_+R\_3R\_/S\_+T
M\O'R\?+R\O+R\_+R\O'R\O+R\O'R\_+R\_+R\_+R\_+R\O+R\_+R\O'R\O+R
M\_+R\O'R\O+R\_+R\O+R\O+R\O+S\_+R\O+R\_+R\_+R\O'R\O'R\_+S\_+R
M\_+R\O'R\_+R\O+R\O+R\O'R\_+R\_+R\_+R\_+R\_+R\O'R\_+R\O+R\O'R
M\O+R\O+R\O+S\_+R\_+R\_+R\O+R\_+R\_+R\_+R\_+R\O'R\_+R\O+R\O'R
M\O+R\O+R\O'R\O+R\O+R\O+R\_+R\_+R\O'R\O+R\O+R\_+R\O'R\O'R\_+R
M\O+R\O+R\O+R\_+R\O+R\_+R\O+S\O/R\O+R\O+Q\O/R\?&JJJQG9VEH9V=G
M9VAG9V=G:&AH:&AG9V=G9V>RLK3R\O'Q\_3R\?+S\O'R\_7R\_7S\N_T\O'R
M\_+R\_+R\_2HJ:UH:&EG9V=F9V5G9V=H9VAG9V9G:&AG9V=I:&?@X-___OWZ
M_/S\_/______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\^____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________/__[>SN;&QN:&=H:&=H:&AE9F=G9V=G:&=H:&=G:&=G
M@8&$]//Q\/'S\_3U\_+S]//R\_'P\_+Q\_+S\_+S]//T\O'PYN7D>'E[9V=H
M:&=G:&=G9F9G9V=H9V=F9V9F9VAHH*"C]/+R\O/R\O/T]//T]//R\O+Q\/'Q
M]?3U\_+S\_+Q]//T]//T\O/S]//R]?3S\_+Q\_/R\O/R\_3T]//T\O'R\O+R
M\_/R\O/R\O+R\O+R\O/R\O/R\O+Q\O/R\O+Q\O/R\O/R\O+R\O/R\O/R\O+Q
M\O+Q\O/R\O+R\O+R\O+R\O+R\O/R\O+Q\O/R\O+Q\O+R\O+R\O+R\O+Q\O/R
M\O/R\O+R\_/R\O+Q\O+Q\O/R\O+Q\O+R\O+Q\O+Q\O+Q\O+Q\O/R\O+Q\O+R
M\O/R\O+Q\_+T\_+S\_+S\?+R\/'R\_3U]//T]//T\/#Q\O/R\O+R\_/R\/#P
M]?3U\_+T]//T\O/R\O+R\O/SYN3DAX>*:&=G:&=G9V9G9VAH9VAH9VAH:&AH
M9V=HLK&T\_+S\?/R]?+P\O'S\?+S\O+R]?3U]//T]//R\_/Q\_3UV]G:;&UM
M:&AF9F9G9V=H:&AI:&=G9V=G:&=G9F=GDI&4_O[_^/K[_/S]__[]________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M/O__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________S]
M_?S\_?___:*BI&=G9VAH9FAG:F=G9V=H:&9G9V=G9VAH:&9F:)^?HO3S\/+S
M]/3T\_+R\?+S\_+S]//R\_3R\?/R\?/R\_/R\>CFYGAY>F=G96=F:&AG9VAH
M:&=G:&=F9VAG:6=G9GEY>=#/S_'Q\_/T]?#P\//R\_7T]?'R\_+R\?'Q\//S
M\O/R\_/S]?/R\_/R\_3S]//T]/+S]/+S\O/R\_7T]?+S\O+R\?+R\O+S\O+S
M\O+R\O+R\?+R\O+R\?+S\O+R\O+S\O+R\O+S\O+R\O+S\O+R\?+R\?+S\O+R
M\?+S\O+S\O+R\?+R\?+R\O+R\?/S\O+R\O+R\O+R\O+S\O+S\O+S\O+R\?+R
M\O/S\O/S\O/S\O+S\O+R\?+R\O+S\O+S\O+R\O+R\O+R\O+R\?+R\O+R\O+S
M]/'R\_+S]/+S\O+R\O+R\O3S\?+S\O'P\O/S]?/R\_/R\?3R\?'Q\/+R\O/T
M]/3S]+*QLFQL:V=G9V9G:&=G9V=G9V=F9VAG96=G9V=G:+"PL_3S\//R\//R
M\_+Q\/+S\O+S\_3S]/3S\?7S\?/T]?'R\^?EY7AY>FAI9V9F9VAG9VAH9V=G
M9V=G9VAH9VAG:&=G:.+@X/W\^_S____^_?__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________S[_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________________LZ^US
M='5H9VEH9VAG9VAG9F=H:&AG9V=G9VAG9F9H:&FRLK/S\O/R\_3T]?7R\_3Q
M\O/V]//S\O#T\_+R\?+T\_+Q\?#FY>B.CY%F9V5H:&AG9VAG9VAG9VAG9V5H
M:&AH:&EG:&B9F)KDY./U]/+T\O'S\_3Q\O/Q\O/R\_3R\O+S]//R\O'R\_3R
M\_3S]/7T\_+T\_+U]//R\_3R\_3R\O'R\O+R\O'R\O+R\O+R\_+R\O+R\O+R
M\_+R\O+R\O+R\O'R\_+R\_+R\O+R\_+R\O+R\O+R\_+R\O'R\_+S\_+S\_+R
M\_+R\O'S\_+R\_+R\O'R\O'R\O+R\O+R\O'R\O+R\_+R\_+R\O+R\_+R\O+R
M\_+R\O'R\O'R\O+R\O+R\O+R\O+R\O'R\_+R\O+R\O'Q\?'S]/3T]?7S\O/U
M]/7S\O'S\O'T\O'R\>_W]?3R\?+U]/;T\_3S]//R\O'$Q<:`@(%H:&AF9F9G
M9V=G9V=G:&AG9V=G9F9I:&AG9V>QL+3R\O+R\_3R\_3R\?+R\O+S]/7Q\._U
M]/+Q\/'S\_+P\?#S\_20D))G9V9G9V=H9VAG9V9G9F=G9VAG9V=G9FAG9V>:
MFI[________Z^_O]_OS^_O______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________\]____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________/W]^_O[____R<C+9V=G9V=G:&=H
M9V9G9V=G9VAH9V=H:&=G9V=E;&UOT,[-]//T\_+S]?/T]?/R\O'P]O3S\O'R
M]//T\O/R]/7U\/'P\_+SEY>:9V=G9V=G:&=G9V=H9VAH:&=H9V=H9F9G:&AG
M;&QNH:&DY>7E\O+Q\_'P]?3R\._Q]//T\O'S]/+Q\O+R\_/R\_3S]//R]//R
M]//T\_3T\O/T\O+R\O/R\O+R\_/R\O+R\O+Q\O+R\O+R\O/R\O+R\O+Q\O+R
M\O+Q\O+R\O/R\O+Q\O+R\O+R\O/R\O/R\O+Q\O+R\O+Q\O/R\O/R\O/R\O/R
M\O+R\O+Q\O/R\O+R\O+R\O/R\O/R\O+R\O/R\O+Q\O+Q\O/R\O/R\O+Q\O/R
M\O/R\O/R\O+Q\O+R\O+Q\O/R\O#P]?3S]//T\O'S]?3U\_+S\_+T\_+S]/+R
M]?3U\/'R\O/R\?'Q]?3TV]G:CY"49V=H9V=G:&=G:6AH9V=G9F9F9V=G:&=H
M:&=H;6UNQ<3'\_/Q\O/T]/7U\O/S\_3T\O/T]//T]O3S\O'P\_3U\/'T]?3S
MEYB;9F=G9V=G9V=I9V=H9F=G:&AI:&=H9F=G:&=G<G)T[^_Q_?S[_____/W]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________/?__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________S____^_?[]__S]_?[]_XF)C&=H9FAG9V=G9V=G9VAG:&AG
M:&EH:&=G9V9G9VQL;L_/SO+Q\//R]//R\?3S\O+S]/+S]//R\?+S\_3T\_+Q
M\/7T\_3S]+JZO&UN;F=H:&9G9V=G:&AG:&=G9VEH:&=G:&AG:&=G96QL;J"@
MH^7CX_+Q\/+R\O+R\O7T]?/S]/+S\O+S\O/S\O/R\_/R\_+Q\O/T]/+S]/+R
M\?+R\O+R\O/S\O+R\?+S\O+R\O+S\O+S\O+R\O+R\?+R\?+R\O+S\O+R\O+S
M\O/S\O+R\O+R\O/S\O/S\O+R\O+R\?+R\O+S\O+R\O+R\?+R\O+R\O+S\O+R
M\O+S\O+S\O+S\O+R\?+S\O+S\O+R\O+R\?/S\O+S\O+S\O+R\?+S\O+R\O+R
M\?+R\?+R\O3S]//R\_3S\?+S\O+R\O+R\O'Q\?3T\_'R\_+S]/+S]/3S]-'/
MSX^/D&=H:&=G:&AG9VAG:&=H:&=G9VAG9VAG:&AG:&=G9GEZ?-K9VO3R\?+S
M]/+Q\/3R\O+R\?#Q\O3S]/3S\O/Q\/+S]//T]//R]+*QLV=G9V=G9VAG:&AH
M9V=G:&=G:&AH:&AG:&=G9V=G9\G(R_K[^______________^_____?______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_[[_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________________________\
M_______\^_O^_?_\_OWM[O!S='1H:&AG9V=H9V=H:&EH9V=G9V=F9F=G9V=H
M9V5K;&W0S\WU\_/U]?;R\?+S]/7P\?+T\_+R\_3T\_3T\O+T\_+P\?'R\_/:
MV=J!@8-G:&AG:&AG9V=I:&9G9F9H9V=G9F9H9VAG9VAG9FAF9VB1D9/0SL[T
M\_+R\_3S\_+U]/7S\O3S\O/R\_/R\_3R\_3T\O'T\_+R\O'R\_+R\_+R\O'S
M\_+R\O+R\_+S\_+R\O'R\_+R\O+R\O+R\_+R\O'R\O+R\O'R\O'R\_+R\O+R
M\O+R\O'R\_+R\O+R\_+S\_+R\O'R\O'R\O+R\O+R\_+R\_+R\_+R\O'R\_+R
M\O+R\_+R\_+R\O'R\O+R\O+R\O+R\_+R\_+R\O+R\O'R\O+R\O+R\O'S]/3R
M\O'R\_+Q\?'R\_/Q\O+T]?7O\/'T]?7T\O*RLK2`@8%G9V9G:&AH9V=G9V=G
M:&9F9F=G:&AG9V=H9VAH9V=F:&B@H*/S\_'T\_#T\_7R\?#R\_3R\O'Q\?'U
M]/7S\O'S\O/R\_3T]//U\_*QL+)F9F=H9V=G9VAG9FAH:&9F9F9H9V=G9V=H
M:&IF9V69F9O________\_/W________]_?[_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________^]____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________^OK]________
M_O[_____U=769FAH9F=G:&=I9V9G:6AH9V=G:&AI9F=G:&=E9VAH;&QNT=#.
M]//R]//T\O/S\_/R\O#P\_+S]/+Q\_+S]/3S]/3S]/7U]//R]//RJJFL;&UM
M9V=G9V=H:&=G9V=G9V=I9V=G9V=G9V9G9F9G9V=G9V=G>7I[J:FLYN;F]/'O
M]O3S\_+Q\?+S\O/T\O/S]//R]//R\O+R\O/R\_/R\O+R\O+R\O/R\O+R\O+Q
M\O+Q\O+Q\O/R\O+Q\O+R\_/R\O+R\O/R\O+R\O+Q\O+Q\O+Q\O+Q\O/R\O+Q
M\O/R\O/R\O+Q\O+Q\O+Q\O+Q\O/R\O+R\O+R\O+R\O+R\O+Q\O+Q\O+R\O+R
M\O+Q\O+Q\O+Q\O+R\O+R\O/R\O+Q\O+R\O+Q\O/R\O/R]/3S\?+S\_3U\?+R
M]?/R]?'OS\[0EY>8;&UN9V=H9V9G:&=H9V=H9V9F9V=G9V=H:&AF:&=G:&=H
M9VAF>7I\T,_2\O'R]/7U\?'Q]//R\_+T\?'Q\O+Q\_+S]/+R\O'P\O+Q\_3T
M\_'PEY>99F9G:&=H9V=G9F=G:&=H:&=G9V=E:&=G9V=H9F9H>WQ^___]__[]
M_/S]_________/S]_____/S_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________O?__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________[^__K]_/___OW\_?[]_____[>V
MMV=G9V=F9VAH:69G9VAH:&=G9VEH:&=G:&=F:&=G9V9G:+"QL_/S]/+S]/#P
M\//R\_7T]?'R\?3T\?+S\O/R\_3S\O/R\_+S]/+S].3CY)"0DV9G9VAG:&=G
M:&=G9V=G9V=G9V=G9V=G9V=G:&AG:&=G9VAG9VAG9XB)C;"PLMO;V?+S\O+R
M\O/T]//R\_'P\O+R\?+S\O+R\?+S\O+R\?+R\O+R\?+R\O+S\O+R\?+R\O+R
M\?+R\?+S\O+R\?+R\O+S\O+R\O+S\O+R\?+S\O+R\O+R\O+R\?+R\?+S\O+R
M\O+S\O+R\?+R\?+R\?+R\O+S\O+S\O+R\?+R\O+S\O+S\O+R\O+R\?+R\O+R
M\O+R\?+S\O+S\O+R\?+S\O+R\O7T\_/R\_7T]?/R\='/SYB7FW-S=6=H:&AG
M9V=G9VAG9VAG9V=G9VAG9V=G:&=G:6=G:&=F9VAG9VQL;:FIK/3S\O/R\?;T
M\_/R]/+S]/+R\?+S\O+S\_3S]/7T]?+S]/+R\?+S]?7T]8^0E&9G:&=G9VAG
M9V=G:&AG9VAG:&=G:&=G:&AG:6AG96UN;.+@X_O]_________________O__
M__[]________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________SW_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________^;FYQG:&EG9V=G
M9VAH9VAH9V=G9VAH9VAH9VAG9V=G9F5F9V>8F)ST\_+P\?+Q\_+V]//R\?+S
M]/7R\O+R\_+Q\O/S]/7R\_3S\O'S\O3S\O/;VMF`@(-G:&AH9V=H9VAG:&AG
M9VAG9VAG9VAG9V=G9F9H:&AG9VAG9VAG9VAG9VAY>7NAH:3%Q,;S\?#S]/7P
M\?#R\_3R\_/S]/;R\_3U]//S\O'R\?#R\?#T\O'T\_+S\O'R\?+T\_3R\?+T
M\_3Q\?#R\O'R\O'R\O'T]//R\_+R\_+R\O+R\O+R\_+P\?#R\_+Q\?+R\_3P
M\?+R\_3R\/#T\_+R\_3R\_3R\_/R\_3R\_3S]/3T\O+S\O'S]/3P\?+R\_3R
M\?#U]/+T\O'EY>2[NKV0CY)T<W5G9V=G9V=F9F9G9V=H9VAG9V=G9V=G9V=G
M9V=H9V=G9V=G9VAG:&9K;&Z@H*+DY./P\?#S]/7R\?+T\_3R\O'S\_3S\O3T
M\_+T]//T]?7P\?/R\_7R\_?HY>-X>7IF9V=H:&AG:&AG9V=H9V=G9V=H9V=H
M9VAG9V=G9V=N;F_3T]+Z________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__\^________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________D9&39V9G:&AF9V=G:&=G:&=G
M9V=H:&=I9V9G:&AH:&=G9V=H@(&#YN7C\O'R\/+Q\_/R\/'R]?3V]?3V]?3S
M\?+P\_3V\O+R]/3S\O/R]//T\_+TQ,3'AXB+9VAG:&=G9V=H:6AI9VAH9V=G
M:&AH9F9F:&=G9V=F9V=G9F=G9V=H9V=G:&=G9VAH@("!H:&CQ,/#Y^3D\O'P
M\O'P\?'Q]/7U\O/S]/7U\_3T]/7U\O/R\O+R\O/R\O/R\/'P\/'R\?+S\?+S
M]/7U\O/T\O/T\O/T\O/T\_+S\O'R\O/T\/'R\_3U\?+S\_3U\?'P\_/R\O/R
M\O/R\O+Q\O+R\O/R\O+R]/3S\O+R\?+S\O/T]//RS<W/LK*TEY>9>7I]:&=H
M9V=H9VAH9F9F:&AH9F=G9V=G9V=G:&AH:&=G9V9H:&AI9F9F9V=H9F9F;&UM
MH*"CZ.;D]//Q\O+Q\O/R\?'Q\O/R]//T]?3U]/3S[^_O]/7U]//T\_'Q]O3R
M\_/RQ,/!:VQN9V=H:&=G9V9H:&=G:&=G:&=H9V=H9VAH9V9F:&=H9V=GM+2U
M_OW_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________/O__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________W\_Y23EF9F9VEH:&=G9V=H9F=G9V=G9V=F9F=F
M:&AG:&AH:&=G9VML;[V[O?/T\^_O[_/T]//T]?3R\?7T]?/R\_/R\?'R]?+S
M\_'Q\?+S\O/T]//R\_3S\MG8UY"0D&QM;F9F9VAH:6AG:&AH:&=G9V=H:&AG
M9VAG96AG9VAH9VEH:6=F:&=F9VAH:&AG9VAH:&=G:'%R<X&!@J"@H;*QL\7$
MQ_3S\O+Q\//R\?;T\_+Q\/3S\O7T]?+S\_/R\?+Q\?3R\?3S\O/R\?7T\O3S
M\O3S\O3S\O7T\_/R\?7T\O/R\?7T\O+Q\/3S\O+R\_7T]?+Q\O7T\O3R\O7T
M\]K8V<3$QZNJK9>7F8"`@69H:&=G9V=G9VAG:&AG:6AG9VAG9VAG9VAG9V=G
M9VAG9VAH:6=G:&AG9VAH:&=G9V=F9F=G9W-S=:FIJ^?FY?+R\_3S]/+S\_'R
M\_3U]?#Q\O7S]//R\_/R\_/S\O+R\N_P\//T]/7T]?3Q[YB8F6=H:&=H:&=G
M9V=F9VAH:&AG9VAH:&=G9V=G9V=F:&AG:&=G9;:VN/________[]________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________[W_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____OW\_O[\_/^2D95G9F=H9V5H9VAG9V=F9V5H9V=G9VAG9VAG9VAG9F9H
M:&AG9VB'B(OGY>;U]/7R\_3R\_3S]//T\_+S\_3T\O'S\O/T\_3U]//R\?'S
M]//S]/3S]/;Q\?#FY>:IJ:QS<G1H9V=H:&=G9FAF9V=G9VAG9VAE96=H9VAG
M9F=H9V=H:&AG9V=G9FAG9FAG9VAH:&AF9F9G9F9H9V=H:&EG:&AG:&B!@H*`
M@8*9F)J@H*.@H*3&Q,7#Q,?$Q,?#Q,?9V=GT\_#U]//R\?#T\_+U]/7R\?#T
M\O'$Q,?$Q,?$Q,7%Q<:ZN[VAH*.?GZ*1D91_@()X>'IF9VAH:&AG9V=G9V9G
M9VAH9VAH9VAF9F=H9VAH9V=H9V=H9VAH9VAH:&AG9V=G9V=H9VAH9VAH9VAF
M9V=G9VAG9F>)B(J[NKWS\O'T\_3S\O/R\O'T\O'T\_3V]?;Q\/'V]?;R\?#S
M\O'R\_3R\?+R\O+R\O+R\_//S\]X>7IH:&EG9F=H9VAH9VAG9VAG9VAG9V=G
M9V=G9VAH9V5H9V=G9VBUM+?__?K]_/[^_?_]_?O_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________?W]__[]
M____DI&4:&AH:&9G9VAH9V=G:&=H:&=G:&=G:&=G9V=H:&=G9V=G:&=H;&QN
MNKJ[\_+S\_3T\/#P\_3T]?/T\_+Q]//R\?#Q]?3U\O'R]//R]//R\O'P]//T
M\?'P\O/T\_3US\_0EI:8<W-T9V=H9F=G9V=G9V=G9V=G:&AF9V=G9V=G9VAH
M9V=G9F=G9F=G9V=H9F=G:&AI:&=H9V9F:&AI:&=H9V=H9V9G:&AI9V=H9V=H
M9F=G:&=G:&=G:&=G:&=G9V=G9V=H:&=H:&AI9F9F:&AH:&=G9V=G9V=G:&=G
M:&=G9V=G:&AH:&AH9F9F:&AH:&AH:&=H:&=H9V=H:&=G9V=G:&=G9V=G:&AH
M9F9F9V=G9V=G9V=G9V=G:&=H9V=H9V9G:&=G9V=G9V=G>7E[J*BJY./D\_+S
M\_+T\_'P]//R\_3T]//R\_+Q]?3R\O+S]?3S\_'Q\_+Q\?'Q]//T\_/R\O/T
MYN7EF9B99F=G:&=I9V=H:&=H:&=G9F9F:&EI9VAH:&=G9V=G:&AI9F=G9V=G
MM;2Y_____________OW__/[]____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____O?______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________[]______[]___]^O___YF9G6=H
M:&=G9V=G9VAG:&AH:69G96=G969G9V9G9VAH:&=G9VEH:&=G9X&!@\_-SO/R
M\_+S\_'R\_+S]//T]?/T]/#Q\O+R\O+R\?/R\?3T\_/Q\?3S]/#Q\O'Q\?/S
M\_3S\O3Q\,_.T)F7F7IZ>V=G:&=F9FAG:&AG:6=F:&AG9V=G:&AH:&=G9VAH
M9FAH:&9F9F=G9V=H:&AG9V=F9FAG9VAG9VAG9VAH:&AG9VAH:&=F9FEH:&=F
M9FAG:&AG:&AG:&AG:&=F9V=G:6=G:&=H:&=G:&AH:&AG9VAG9VAG9V9F9VAH
M:&AG9VAG9V=F9FAG9V=G9VAH9V=G9V=G9V=G:&=F:&AG:&EH:6AG:&AH9V9G
M9V=G9VAG9VEH:&AH:8F(BJFIJ]O:V?/Q\/7S\O;T\_+R\O'S\N_R\_3U]?3R
M\O3U]?+R\O+R\?'Q\?/T]?+S]/+S\_+S]/+S\O3S\K*RM&QM;6AG9VAG9VAG
M9V=G:&AH9VAH:&=G9V=G9VAG:6EH:&AG9FAG9FUM;];5U_W\^_[^__[^_O__
M______S\____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________[O_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________^_O________________^TM;=H:&EG9V=G9V=G
M9VAG:&AF9F9H:6EF9F9G:&AG9V=H9V=G9V=G9V=F9V>/CI'9V-GV]/+T]//R
M\_3T]?7S]/3S]/7P\/#R\O+Q\?#R\_3Q\O/T\_3W]?;R\O/S\_/R\O+R\_3S
M\O'T\_+:V-FSLK2)B(IL;&UH:&AH9V=H9V=H9V=G9V=H9VAH9VAH:&EG9F=G
M9VAG9VAH:&EG9VAH9VAG9V=G9F9H9V=H:&AH9V=G9F9H:&AH:&=G9F9H9V=H
M:&AG9V=G9V=H9V=G9V=H9V=G9V9G9VAG9VAG9VAG9VAG9F=F9F=H9V=H9V=H
M9V=I:&AH9V=G9VAG9F9G9V=H9V=G9F9H9V=H:&AH9V=G9V=Y>7J8F)FZN;OG
MY^;R\?/U]/7S\O3T\_+R\O+R\O+S\_+T]//R\?#U]/7S]/3S\?#T]//R\O'R
M\O'R\_3R\?+T\_+T\O'$Q<9X>7QG9V=I:&AI:&AF9F9H:&EG9F9H:&EG9V=H
M:&EH9VAH9V=G9V=G9VAZ>GS5U=7____^_O____W____]_?W____^_O______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________^]________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____/___O[^______[]___]_OW_____U=75='1U9V=G9V=E9V9F:&=H:&AH
M:&AH:&=G9F=G9F=G:&AI9V9G9V=G9V=G9VAHCX^1V-C<]?/R]/+R]O3S\_/R
M\O/T]?3U\_+S\O/R\?+S]/7U\/'R\O+Q]//T]//R\_+Q\O/T\O+R]/7U\O'S
M\_+S]//RV=G9L;*UEY::@(&#9V=H9V=G9V=G9V=G9V=G9V=G9V=G9VAH9V=G
M9V=G9V=G:&AH9V=G9V=G:&=G:&=G9V=G:&=G:&=G9V=G9V=G9V=G9V=G9V=G
M:&AH:&AH9V9F:&=G9F=G9V=G:&AG9V=G:&AH:&AG9V9G9V9G9V9G:&=H:&=G
M:&=G:&=G9F9F;6UN@(&#H:"CNKF\Y^;G\O'Q\?+S\O/T\O/S\O/T\O+Q\O+Q
M\O+R\O/S\O'R\_+S]?3R]O3S\O+R\O/T]//R\_+Q\O'S\O/T]//T]//QQ<3$
M@(&%:&AG9V=H9V=H9V=G9V=G:&=H:&=H9V=G9V=G9V=G9V=H9F9F9V=G9V=H
MB(F-\.WL_/____[]_OW]_OW_^OW\__[]____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________O?______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________^[M[(F)C&=G:&AH:&=G9V=H:&9G:&=G:&=G:&=G
M:&=G:&=G9V=H:&AG9V=F9VAH:&=G:)"/DMK8U_3S\N_P\?/T\_3S\O+Q\O/R
M\?3S\O+Q\O'R\_+S\O+R\?+R\?/T]//R\_3S]/3S\O/R\?7T\O3S\O3S\?/R
M\?/R]/+Q\_+Q\,[.T+N[O*"@HXB)BH"`@6UM;6=G9V=G9VAH:6AG:&AG:&=F
M9VAG:&=G9VAG9V=G9VAH:&AH:&=G9V=G9VAG9VAG9V=F9FAG9VAH:&=G9VAH
M:6=G:&AG:&AH:&AH:&=F:&=G:&=G:&=G:')R=(&!@I>7F:&AI,/"Q.7EY?+Q
M\_/R]/3R\?3S\O+R\O/T\_#Q\/7V]O/R]//R\_/R\_3S]/+S\O+R\?+S\O+S
M\O+R\O+S\O+R\O/R]._R\/+R\O/R\??T\KNZO(&!A&=G:&AH9V=G:&=G:&AG
M:&AH:&AH9VAH9F=G9V=G:&9G9VAH9VAG9VAH:&9G:*VLK____?[]________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____SO_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________^NK;!K;&QI:&AG9VAH9V=F9V=H:&9G9V=G9VAH9VAH:&AG
M9V=F9V=G9VAG:&EG9VAG9V>(AXK&Q<;S\O/Q\O/R\O'R\_7S]/7Q\_+Q\?'R
M\O'S\_3S\O/U]//R\_+S]/3R\_3R\_3Q\O+S\O/R\?/U]//S]/3S]/3T]?7Q
M\/'S\O3S\O/Q\/'U\_3Q[^_U\_+-S<_&Q,:\N[R@H*.?GZ&?GZ&`@(.`@8.!
M@82`@8.!@82`@8.`@8.`@8.`@(*`@8)_?X&!@8*!@H2`@(.)BHRAH*"?GZ&@
MH*+%Q,3#P\39V=GT\O'R\?+T\_3U]/7P[_'U]/7R\_3R\_3R\_3R\_3R\_3R
M\?/S\O/Q\O+P\?#R\_+T]//R\O+T]//U]/7S\O3R\?+R\_3T]?7R\_3T]?7S
M]/3T\_7HYN:QL;-R<W5F:&=G9V=H9V=G9V=H9V=G9V=H:&AF9F=H9VAG9F9G
M9V=G9V=G9F9G9VAH:&AY>GW7U=?______OW^_O[_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________\^________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________OW__/[]
M_/__X-_B@H&$9V9F:&=G9V=G9V=H9V=G9V=G9F9G9V=G9VAF9V=G9F9G9VAF
M:&=G:&=H9V9H9V9G<7)TJZJLY>3C]/3S\O+R\_+Q]//R\/'R\O/T\_+S\O'R
M\O+R]/3S\O+Q\O+Q]//T\_+S\_+S\_+S\O/R\O/R\O+R\_/R\_3T\O/T\_3U
M\_3T\O/S\O/T\O/T\O'R\_+T\_+T\_'P]//R]//R]//R\_+Q]/+Q]/+Q]//R
M]//R\_+Q\_+Q]//R]/+Q\O'P]//R]?3R]//R]?3U\O/T\_3T\?'R\_3U\O+Q
M\O+R\O+R\O+R\O/T\_3U\O/R\O/R]/3S\O/R\_/R]//T\_/R\O+R\_3T\_3T
M\O'R]/+Q]O3S]O3S\O+R\/'P]?3S]/+Q]/+R\_+Q]//RS<W/D(^1;&QN9VAH
M9V=H9V=H9V=G9V9F:&=I:&AG9V=H9V=G:&AH9V=G9VAH:&AI9V9H9V=H9VAH
MHJ*E_________/S]_O[_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________/O______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________S^_?S___[^_O_____^_[:U
MNFUM;V9G9VAG9V=G:&=G9V=H:&=H:&9F:&=G:&AG96=H:&AH:&AG9VEH:&=F
M9F=G:&=F9VAH:8F(B[&QL^?FYO+R]/3S]/7T\_'R\/+T\_3S]/+Q\O7T\_3R
M\?/S\O'Q\?+R\O+S]/7T]?3S]/7S]/3S\O3S\?'Q\?+S\O+R\?+R\?#Q\/3R
M\?3R\O/Q\/7T]?7S]/+Q\O+S]/+S]//T]/+S]/+S]/+S]/+S]/+S]/+R\O+R
M\O+R\O+S\O#P\/+S\_+S]/+S]/3S]/+Q\O3S]//R\_/R\_;T\_3R\?/R\?3T
M\_+R\O+S\O7S]/3S]/'Q\O7T]?/R]/3R\?3R\O7T]?+R\_7T]?/S]//R\?7T
M\_#P\/+S]/3S]/7T\MK8UZJIJW%R=&9F9V=G9VAG9VAH:&9F9FAG9VAG:&AH
M:6=G9V9G9V=H:&AG:&=F:&=G9V=G:&AG:6AH:(*"A=74UO[]__[]_/S___S_
M______S\____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________[S_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________^_O_____^_?W^_O[[_O[^_?_LZ^J<FY]G9VAG
M9V=G9V=H9VAH9VAH9VAG9F=G9F=G9V=H9V=F9V=F9F9G9V=H:&AH9V=I9V=F
M9V=I:&AG9V>)B(JRL;3FY>;U]/7T\_+R\O+R\_3R\_3Q\O/P\?+S]/7R\_3R
M\_3R\_/T\_3U]/7R\?+S\O3S\O/S\O/T\_3R\_3S]/3R\_3S\_+R\_+P\?#R
M\_+R\O+S\O/S\O/S\O/T\_3S\O/S\O/S\O/T\_3T\_+V]//R\?#S\O/S\O/T
M\_3R\?+T\_3R\O+R\_+R\_+T]//P\?+R\_3R\_3T]?7R\?+S\O/R\?+T\_3S
M\O/R\_+R\O+Q\?#R\?+S\O/T\_+S\O'R\_+R\_3R\_3Q\O3S\O'/S<^JJJQY
M>7MG9VAF9V=H:&AG9V=H9VAG9F=H9VAH:&AH9V=G9F9H9V=H:&=H9VAG9VAF
M9V=G9VAG9F=H9V=R<W2VMK?____^_?S____\_/____W___W_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______^^____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________?S______/W]_?W]_/___?[\__[]_OW]X>'CB8F.9V=G:&AF:6=G
M:&=G9F9F9V=G9F9G9V=G:&=G:&=G9F=G9F=G9V=H9V=H:&AI:&=H:&AH9F=E
M9F9F9V=H@8&%J*BKS,[.[_#N\?'Q\O/T\O/U\O'R]//R]?/Q\_/R\O+Q\O+Q
M]?3U\_+S]?3U\_+S]?3U\O/T]/7U\O/T\/'R\O/T]/7U\/'Q\O/T\O+Q\O/R
M\O+R\O+R\O/R\O+Q\O/R\O+R\?'P\O/R\_3S]/7U\O/T\O+R\_/S\O+Q\O/T
M\O/S\O/R\?'Q]/3S\_/Q\_/Q\_/Q]//T\O+R\O+Q\O+R\O+Q]/3S\O/T]/7U
M\O+Q\_3T\O/T\O'R]//RYN3DN[J\EYB;='1T9F=G9V=H9V=G9V=G9V=G9V9G
M9V9H9F9E:&AF9F9F9VAH9F=G:&=G:&=G9V=H9V=G:&AH9V=H9V=G;6UNHJ*E
M[N[P_O[^_/___/_______?W]_____?W]_______]____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________O/______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________W\_?S\
M_?____W]_?[]__S\_?________W]_?[^_\G(RX&"A&=G96=H:&AH:6=G9V=F
M9V=G:&AG:&=F9VEH:&9F9F=H:&=G:&=H9F=G9V=G:&AG:&AH:&=H:&9F9FAG
M9VAH:&UM;HB'BJFIJ\_.SO3S\?+R\O'R\O3S\O3S\O/R]/'R\_+S]//T]?/R
M]/3S\O/R]//S]//R\_7T\O3S\O/R\?3R\?3R\O/T]/+S]/+S]/+S]/+S]/+S
M]/+S]/+S]/+S]/#Q\O+S]/'R\_+S]/+S]/+S]/3U]?7S]//R\_7T]?7S]//R
M]//R\_3S]/3S]/+S]//T]/+S]//T]?+S]//R\_+Q\_/R\_/R\^3CX[N[O9>7
MF7EY>VAH:6=G:&=F9VAG9VAG9VAH:&=G9VAG9V9G9V9F9F=G9V=G9V=G:&AH
M:69G9V=G:&AG:&=F9V=G9V9G9V=G9VQL;:.CINWL[O[^__[^_O[]__[^__K[
M^____?W]_?[^___^_?W\^_[^____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________S[_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________\___________________\
M_?W^_?_^_O____W___W\_/_____+R<R"@X5H9V=H9V=G9V=G9VAG9VAG:&AG
M9VAH9VAG9FAH9V=H9VAG9F=H9V=G9V=H9VAG9VAH:&AF9V=G9VAG9FAG9V=G
M9V=G9V=F9FB!@(.8EYFRLK7/S]#T\_#U]//T\O'Q\?'T\_+T\O'R\O+R\_+R
M\_+R\_/R\_/T]/7S]/7R\_3S\O'S\O'S\O'T\O'T\_+T\O'S\O'T\O+S\O'T
M\_+S\O/S\O/T\_3T\O'T\O'T\_+U]/+T\O+T\_+T\_+S\O'S\O3S\O/T\_3T
M\O'U]//T\_3S\O3EY.7%Q,6@H**'B(MS<G)H9VEG9VAG9FAG9VAG9V=G9V=G
M:&AG9V=G9V=G9F9H9V=G9F9H9V=H9V=G9F9H9VAH9V=G9V=H9VAH9VAH9V=H
M:&AH9VAM;6ZBHJ7N[>[\_/___________OW__OW__O_____[^_S___W__OW[
M_/_]_/W___W_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________\]____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________?W]
M____^_O[___________]X>#AD)"6:&=G:&AH9V=H9V=H9F=G9V9G:&=H:&AI
M:&=H9F9G:&=H9V=H:&=H:&=G:&=G9V=G:&=H:&=H9F9G:&=H:&=G9V9F:&AH
M9V9F:&AH9V=G9VAH>7E[B(B*H*"CLK&SQ<3%V=G;]?/R\O'P\_+Q]//R\O+R
M\O/R\O+R]/+Q]O3S\_+T]//S\O'R]//T\_+T\_+S\O/S\O/T\_3T\O/T\_3T
M\O/R]/+Q]//R\O/T\_/T\O/S\_+S]O3SYN7DQ<7(NKJ\H:"AD(^1@H&":VML
M9V9H:&=H9V9G:&=H:&=G:&AH9V=G9V=G9V=G9F=G9V=G9V=G9V=G9V=H9V=H
M:&AI9V9G:&=H9V=G9V=G9V=H:&=G9V=G9V=G9V=H9V=H<W1WHZ*C[N_Q^OO[
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________/O__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________S\_?____S]_?[^
M_______^_?_]^NKL[Z&AIG-S=&EH9FAG969F9F=G:&AG9V=H:&=G9V=G9V=G
M9V=G9V=G:&=F9V=F9V=G9V=G9V=G9V9F9F9G9V9G9V=H:&=G:&=G:&AG:&AG
M9V=G:&=G:&=G:&9G9V=H:&=H:&9F9FUM;H&`@H"!@Y"0DI^?HJ&@HYZ?HZ>H
MK,3$Q,3$Q<3$Q,3$Q,/#Q,7%Q<3#Q,3#P\?&QL/"P[&QLZ&AI)^>HJ"@I)B8
MF8"`@8*!@G-S=6AH:6=H:&=H:&9G9V=G:6=G:&=G:&=G9V9F9F=G9FEH:&=G
M9FAG9VAG9VAG9VAH:&AG9V=F9VAG:&=G:&AG9VEI:&=G:&=G:&=G9V=G9V=G
M9V9F9V=G9VAG9VAG9V9F9H."@[:UN/_^_?____O[^___________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________SW_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________]_?W____]_?W\_/_^_?_]_?W_____
M___Z_/W___Z^O\**BHYH9VEH9VAG9V=H:&AG9V=G9V=G9VAH9VAG9VAH:&AE
M9V9H:&AG9V=G9VAG9F=G9FAG9FAG9F=H:&AH9V=G9V=H:&AH9V=H9V=G9F9H
M9V=H9V=H:&=G9V=G9F9G9V=I:&AE9F9H:&EF9F=G9V=G:&AF9V=G:&AF9F9H
M:&AG9V=G9V=G9V=G9V=G9V=H:&AG9V=F9V=H9V=H9V=G9F=H9VAH9V=H9V=G
M9F9I:6EH9V=H:&AG9V=G9V=G9V=H:&AF9V=H9V=G9V=H9V=G:&9G9V5G9V=G
M9VAG9VAG9FAH:&EH:&AH9VAG9V9G9V5G:&9H:&AG9VAH9V=H9V=H9VAT<W69
MF9SAX>'________]_?W_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________^\____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________/S]_?W]_________OW]_____O[__OW__OW]______[]_/W]
M^OW][>[OMK6V>WI]:&=H:6AI:&=H9V=H9F=G9VAH:&=G:&=G9V=H9V9G:&=G
M9V=G9V=G9V=G:&AH9V=G9V=F9V=G9F9F:&AI9V=H:&=H9V9G:&AI9V=H:&AI
M9F=G9V=H9F=G9V=G9F9F9VAH:&=G9V=H:6AI9V=H:&AI9V9G9V9G:&AI:&=H
M:&=H9V9H9V=H:&=H:&AI9F9G:&=G:&AI9V=H9VAH9F=G9V=H:&AI9V=H9V=H
M:&=G:&=G:&=G9V=H9V=H9V=H:6AH:&=G9V=H9V=H9V=H9V=G9V9F:&AH9V9F
M9V=G9VAH9V=H:&AI9V=G9V9F:6AH;6UOD9&3P,##__SX__[]_/S]_____O[^
M_______]_____________?W]_/W]________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________OO__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________[^
M_O____________W]^_____________________K\_?________W]_?S\_?__
M_^#@X:NLKXF)C&9G9VAG9F=G96AG9V=G:&=G9VAH9V9G9V=H:&=H:&=H:&=G
M:&9G9V9G9V=G9V9G9V9F9F9F9F=G9V=G9V=G9VAG9V=G9VAG9VAG9VAH:&AH
M:&=F9V=G:&AH:&=G9V9G9V=G9V=G9V=G9VAH:&9F9F=G9V=G9V=G9VAG9VAG
M9VAH:&=G9VEH:&AH:&AG9VAG9VAG9V=F9F=G9V=G:&=G:&AG:&AH:6=F9VEH
M:6=G:&=G:&=F9VAG9VAG9VAH:6AG:&=F:&=G:&=F9VAG9VAG9V9G9V=G9V=G
M9W1T=9.3E[^^PO____[]__K\_?W]_?[]_____________________O______
M______S\_?__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________[W_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________[^_S_____________
M__W]_OS]_?W____[_?[\___]_?W____^_O[____^_?WZ_?O____________N
M[>Z_OL&1D95S<W5G9VAG9VAG9V=G9F9H9V=H9V=I:6EG9VAH9VAG9VAG9VAH
M9VAG9F=G9F=G9V=G9V=G9V=G9VAG9VAG9VAG9FAG9F=H9VAG9VAH9VAH9VAG
M9F9G9V=H9V=H9V=H9V=G9F=H9VAG9F=H9VAG9F=H9VEH9VAH9VAH:&EF969G
M9V=G9V=G9V=G9V9H:&EH9VAH9VAH9VAG9F=H9VAH9VAH9VAG9V=G9V=I:6EH
M9V=G9F=H:&AG9V9I:&AH:&AG9V=F9V=G9VB"@H6CHZ?5U-;____^_O_\_/W_
M_____OW]_/W____^_?S[^_S^_O[\_?W____^_?______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\^____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________?W]_______________]_?W]____
M_____?W]_________/___?W]__[]___]_?W]_________?S__________?W[
MX.+DM[:WD)"3<W-U9VAH9V=G9V=G9V=H9V9H:&=G:&=H9V9G9V=H:&=H9V=H
M:&=H9V9H9V=G9F9F9V=H9V=G9F=G9F9F:&AH9VAH9F9G9V=G9VAH9V=G9F=G
M9V=G9V=G9F=G9V=G:&=G9V=F:&=H9V=H9V9G:&=H:&=H:&AH9V=G9F9F9VAH
M9V=H9F=H9VAH9V=G:&AI9V=G:&=G:&=G9V=G:&=G9V=H:&=H9VAH9V=G9FAG
M969G@H*$H:&ERLG,_OW__O[__O[^_____/___/_______/W]_O[^_?W[_O[]
M_O[______OW]_O[_^OW]_/[]____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________/?__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________^_?____[^__[]______________[]__W]_?[^_O______
M______[]__[]__[^______W]_?W]_?S___W]_?____[^_O______________
M_^WL[L"_Q*.BI8*"@W-T=&=G9V=H:&=H:&9G9V=G9V=G9VAG9V=G9V=F9VAG
M:&=F9VAG:&AG9VAH9V=G9FAH:&AG9V=G9V=G9V=G9VAG9VAG9VAG9V=G9VAG
M9VAG9V=G9V=G9V=G9V=H:&=G9V9F9F=G9V=G9V=G:&AG:&=G:&=G:&AG9VAG
M9V9G9V=G9VAG9VAG9V=G9V=G:&AG:8*!@I&1E*VLK];4U?____W\__[]____
M__O^_?____________S\_?____________________W]_?S___S___S___W]
M_?____[]____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________[[_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______N[>[*R<RKJZ^DHZ6"@H1Z>7MH:&AG9V=G:&AF9V=G9VAF9V=G9VAG
M9VAH9VAG9VAG9VAG9VAG9VAG9V=G9V=G9V=G9V=F9F9G9V=G9V=F9V=G9V=G
M9VAG9VAG:&AF9V=G9V=I:&AF9V=G9V=H:&AF9F9G9V=F9V=U=':!@8.2D92C
MHZ;)RLO5U=?_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________\^________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________^_S\_____O[^[.SNR<G,R\K,K*ROHJ*FI*.D@(&$@8*#@H*#A(*"
M=71U:&=H9F5E:&AH:&=G9F9F:&=G9V=H9V=H9VAH9VAH;6YNA(.#@X*#@X*#
M@8*$F9F;I*.EH:&EOKV_R\K-X=_B___]_OS]_________?W]____________
M_?W]________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________/?__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________S]_?____S]_?__
M__K]_OS_______________W]_?S\_?____________O\__[]____________
M__________________W]_?____S]_?____K[_/W]_?S\_?________S\_?W]
M_?________________S___O]_OS_______W]_?______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________S[_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________Z^OO____^_?W____________^
M_O[________]_?W________]_?W________\_?W____________]_?[_____
M___]_?W________\_/W____]_?W________]_?W________\_/W_________
M___________]_?W____]_?W\_/W_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________\]________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________[]___]_____________/W]_________?W[_____O[^________
M_O[^_________/W]_O[^_____________________?W]_________?W]____
M_________________________/S]_O[^_________?W^_____OW__OW_____
M_____?W]_________?W]________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________O/______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________[^__S\
M__S\_?________W]_?________[]__W\_O[^__S\__W]_?________W]_?__
M__________________________[^_O___________________OW\^__^_?_^
M_?[^_O____________[^_OS\_?_________^_?___O_^_?W]^___________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________S[_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________]_?W_________________
M_______________________]_?[________________]_?W]_?W____\_/W_
M___________________________]_?W____________[^_O_____________
M_______\_?W^_?W____\_/_^_O_\_/W________\_/W_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________^]________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________O[__OW__/W]_____/S]_____/___/______
M_O[^________________________________________________________
M_________________________________O[__O[__OW_________________
M_____________________?W]_________O[^________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________OO______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________[[_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\^
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________/?______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________SW_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________^\____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M/?__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________[O_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________^[____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________OO__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_[[_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________\^____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________O/__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________SS_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__\^________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________/?__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________S[_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\^________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____O?______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________S[_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________^]________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________OO______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____[W_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________^]________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
>____________________________________/@``












#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="Resource[]">
    <lst nm="IMAGE[]" />
  </lst>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="1700" />
        <int nm="BreakPoint" vl="1700" />
        <int nm="BreakPoint" vl="765" />
        <int nm="BreakPoint" vl="1818" />
        <int nm="BreakPoint" vl="2085" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24279: Baufritz specific modification" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="17" />
      <str nm="Date" vl="7/9/2025 9:57:46 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24083: Add block representation for HSW hanger bolt (stockschraube)" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="16" />
      <str nm="Date" vl="5/23/2025 11:56:43 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24083: Start the stud milling from the bottom of the stud; Add property offset for the stud milling" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="15" />
      <str nm="Date" vl="5/23/2025 11:18:08 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23993: Add width and height for the milling at stud for HCWL" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="14" />
      <str nm="Date" vl="5/8/2025 11:53:56 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20098: Add options House/drill for the HCWL tooling " />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="3/20/2025 3:38:26 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23567: Add milling depth at studs for HCW-L" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="3/6/2025 10:24:10 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23568: Remove the check for edge distance requirements; add note to user for the ETA-21/0357" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="3/6/2025 9:28:57 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23612: Modifications for Baufritz" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="3/4/2025 8:28:16 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19773 Fixed position of milled in fastener" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="2/11/2025 3:28:41 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl=" HSB-19773: Added missing hanger bolt" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="12/12/2024 4:20:29 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19773 Adjust Tsl to the requirements of Hilti." />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="12/10/2024 11:16:04 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23098: comment out tooling for HCW-P" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="12/3/2024 7:44:46 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="20241011: Fix tooling (House) at HCWL for Baufritz" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="10/11/2024 9:26:23 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19775: Change TSL image" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="10/8/2024 10:01:06 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22780: For Baufritz add HCWL-K" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="10/8/2024 8:20:18 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="20240922: Fix beamcut at stud for HCW-L" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="9/22/2024 5:39:53 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22652: Add option Holzdolle for Baufritz" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="9/10/2024 8:46:38 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19773: Draw block only when it is found" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="8/22/2024 8:14:44 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19773: Add Property &quot;Marking&quot; to mark HCWL at studs" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="29" />
      <str nm="Date" vl="6/20/2024 10:58:36 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19774: Add block representation for HCW and HCWL" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="28" />
      <str nm="Date" vl="6/20/2024 9:04:50 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21970: when changing catalog via trigger, dont change position properties if not a HCWL" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="27" />
      <str nm="Date" vl="5/6/2024 10:33:14 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="BF20240418: Additional hole for HWC pushed to the other side" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="26" />
      <str nm="Date" vl="4/18/2024 3:12:35 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21790: for Baufritz ignore first plate if &lt;=27; For reference point use stud with color 32" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="25" />
      <str nm="Date" vl="4/8/2024 9:16:41 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21590: make depth property active to set it in the catalog" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="24" />
      <str nm="Date" vl="3/12/2024 10:30:46 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21590: House tool should enter from below to control the depth of the tool" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="23" />
      <str nm="Date" vl="3/12/2024 9:06:43 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21590: Add HCW-P connector" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="22" />
      <str nm="Date" vl="3/11/2024 4:25:33 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20649: Fix entering point: Fix House for HCWL" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="21" />
      <str nm="Date" vl="11/20/2023 4:32:20 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18848: &quot;Diameter&quot; and &quot;Version&quot; modification in relation to eachother" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="20" />
      <str nm="Date" vl="5/9/2023 9:00:48 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18848: Let property &quot;Diameter&quot; always active for Baufritz" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="19" />
      <str nm="Date" vl="5/8/2023 10:52:49 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18322: Remove commands to generate circles, fix pt0 drag in element view, change X distance when version is set to HCWL" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="18" />
      <str nm="Date" vl="3/15/2023 3:29:01 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17955: Add triggers to add/remove plates for drilling/milling" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="17" />
      <str nm="Date" vl="2/15/2023 8:59:30 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17955: Fix: change the default drill depth to 100 for Baufritz" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="16" />
      <str nm="Date" vl="2/15/2023 8:06:41 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17955: change the default drill depth to 100 for Baufritz" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="15" />
      <str nm="Date" vl="2/14/2023 4:35:23 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17955: No stud milling for &quot;Baufritz&quot;; Stud drilling if drill center inside the stud" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="14" />
      <str nm="Date" vl="2/14/2023 3:34:39 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17955: correct position when stud dimensions are changed" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="2/14/2023 1:50:41 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="20230119: remove drilling for studs for HCW" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="1/19/2023 5:20:32 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17526: remove boundary constrains for Baufritz" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="1/12/2023 5:43:14 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17526: Change rotation for Baufritz" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="1/12/2023 10:12:16 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17526: Dont show error messages for Baufritz" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="1/12/2023 8:57:17 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16670: Distinguish grouping of circle objects EG/DG" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="9/30/2022 10:38:32 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16670: Show error if no plates found when TSL attached to a stud" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="9/29/2022 9:02:37 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16670: Fix bug for proeprty index" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="9/28/2022 11:36:23 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15091: replace Pline object with circle" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="9/12/2022 10:23:59 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15004: add triggers to generate/cleanup marking pline entities" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="3/24/2022 7:01:09 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13683: add property rotation" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="11/22/2021 2:21:30 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12697: add ruleset check" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="9/13/2021 5:29:27 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12697: add description" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="9/8/2021 11:18:48 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End