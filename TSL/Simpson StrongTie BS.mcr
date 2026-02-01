#Version 8
#BeginDescription
#Versions
Version 2.5 17.11.2022 HSB-17085 new option to mark including male posnum
Version 2.4   21.12.2021   HSB-14106 display published for hsbMake and hsbShare
Version 2.3   22.07.2021   HSB-12396: fis 3d representation fro BSDI
Version 2.2   18.03.2021   HSB-11211 only applicable to beams with a perpendicular connection plane , 

version value="2.1" date="25mar2020" author="thorsten.huck@hsbcad.com"> 
HSB-5713 Z-Alignment auto corrected on creation if not upright with _ZW

HSB-5783 property naming without '.' to support map property naming convention  i.e. with hsbViewTag 
bugfix posnum
new hardware assignment supports additional custom defined hardware items

DACH
Dieses TSL erzeugt Balkenschuhe vom Typ Simpson StrongTie BSN, BSI, BSIL, BSD, BSDIL oder GSE

EN
This tsl creates hangers of the type Simpson StrongTie  BSN, BSI, BSIL, BSD, BSDIL oder GSE











#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 5
#KeyWords Hanger;Connector;Metalapart
#BeginContents
/// <summary Lang=de>
/// Dieses TSL erzeugt Balkenschuhe vom Typ Simpson StrongTie BSN, BSI, BSIL, BSD oder BSDIL
/// </summary>

/// <summary Lang=en>
/// This tsl creates hangers of the type Simpson StrongTie  BSN, BSI, BSIL, BSD oder BSDIL
/// </summary>

/// <insert Lang=en>
/// Select 2 beams
/// </insert>

/// History
// #Versions
// 2.5 17.11.2022 HSB-17085 new option to mark including male posnum , Author Thorsten Huck
// 2.4 21.12.2021 HSB-14106 display published for hsbMake and hsbShare , Author Thorsten Huck
// Version 2.3 22.07.2021 HSB-12396: fis 3d representation fro BSDI Author: Marsel Nakuci
// 2.2 18.03.2021 HSB-11211 only applicable to beams with a perpendicular connection plane , Author Thorsten Huck
///<version value="2.1" date="18oct19" author="thorsten.huck@hsbcad.com"> HSB-5713 Z-Alignment auto corrected on creartion if not upright with _ZW </version>
///<version value="2.0" date="18oct19" author="thorsten.huck@hsbcad.com"> HSB-5783 property naming without '.' to support map property naming convention  i.e. with hsbViewTag </version>
///<version value="1.9" date="12oct19" author="thorsten.huck@hsbcad.com"> bugfix posnum, new hardware assignment supports additional custom defined hardware items </version>
///<version value="1.8" date="24jan17" author="thorsten.huck@hsbcad.com"> group assignment uses female beam as initial priority </version>
///<version value="1.7" date="15oct15" author="th@hsbCAD.de"> insert coordSys dependent from male beam </version>
///<version value="1.6" date="17apr14" author="th@hsbCAD.de"> marking property extended: dimpoints are also published for shopdrawings only, new property flush mounted will flush the item with the bottom face </version>
///<version value="1.5" date="04nov13" author="th@hsbCAD.de"> custom preset through catalog entry '_Default' added </version>
///<version value="1.4" date="15oct13" author="th@hsbCAD.de"> translation bugfix </version>
///<version value="1.3" date="14oct13" author="th@hsbCAD.de"> view dependent dimrequest added to overrule solid dimensioning, stereotype 'Assembly' hardcoded </version>
///<version value="1.2" date="27sep13" author="th@hsbCAD.de"> automatic section detection enhanced, new type GSE added, hardware added </version>
///<version value="1.1" date="24sep13" author="th@hsbCAD.de"> user will be informed about invalid section if the attempt to attach a BSx to the selected beams fails</version>
///<version value="1.0" date="19sep13" author="th@hsbCAD.de"> initial </version>
//d since 18.1.45)


// basics and prop
	U(1,"mm");
	double dEps = U(0.1);
	
// strongtie data
	// BSN	
	String sBSN_ArticlesRaw[] = {"BSN40/99-B ","BSN40/110","BSN40/140-B","BSN45/96","BSN45/105","BSN45/137","BSN45/167","BSN45/197","BSN48/95","BSN48/136","BSN48/166","BSN48/226-B","BSN51/93","BSN51/105","BSN51/135","BSN51/164","BSN51/195","BSN60/100-B","BSN60/130-B","BSN60/160-B","BSN60/190-B","BSN60/220-B","BSN64/98","BSN64/128-B","BSN70/125","BSN70/155-B","BSN73/124","BSN73/153","BSN73/183-B","BSN76/120","BSN76/152","BSN80/120-B","BSN80/150","BSN80/180-B","BSN80/210-B","BSN90/145","BSN98/141","BSN100/90","BSN100/140-B","BSN100/170-B","BSN100/200-B","BSN115/162-B","BSN115/190-B","BSN120/119-B","BSN120/160-B","BSN120/190-B","BSN127/126-B","BSN127/186-B","BSN140/139-B","BSN140/180-B","BSN150/145-B"};
	double dBSN_As[]={U(40),U(40),U(40 ),U(45 ),U(45 ),U(45 ),U(45 ),U(45 ),U(48 ),U(48 ),U(48 ),U(48 ),U(51 ),U(51 ),U(51 ),U(51 ),U(51 ),U(60 ),U(60 ),U(60 ),U(60 ),U(60 ),U(64 ),U(64 ),U(70 ),U(70 ),U(73 ),U(73 ),U(73 ),U(76 ),U(76 ),U(80 ),U(80 ),U(80 ),U(80 ),U(90 ),U(98 ),U(100 ),U(100 ),U(100 ),U(100 ),U(115 ),U(115 ),U(120 ),U(120 ),U(120 ),U(127 ),U(127 ),U(140 ),U(140 ),U(150 )};
	double dBSN_Bs[]={U(99 ),U(110 ),U(140 ),U(96 ),U(105 ),U(137 ),U(167 ),U(197 ),U(95 ),U(136 ),U(166 ),U(226 ),U(93 ),U(105 ),U(135 ),U(164 ),U(195 ),U(100 ),U(130 ),U(160 ),U(190 ),U(220 ),U(98 ),U(128 ),U(125 ),U(155 ),U(124 ),U(153 ),U(183 ),U(120 ),U(152 ),U(120 ),U(150 ),U(180 ),U(210 ),U(145 ),U(141 ),U(90 ),U(140 ),U(170 ),U(200 ),U(162 ),U(190 ),U(119 ),U(160 ),U(190 ),U(126 ),U(186 ),U(139 ),U(180 ),U(145 )};
	double dBSN_Cs[]={U(37 ),U(37 ),U(40 ),U(37 ),U(37 ),U(40 ),U(40 ),U(42 ),U(37 ),U(40 ),U(40 ),U(39 ),U(37 ),U(37 ),U(40 ),U(40 ),U(42 ),U(37 ),U(40 ),U(40 ),U(42 ),U(39 ),U(37 ),U(40 ),U(40 ),U(40 ),U(40 ),U(40 ),U(42 ),U(40 ),U(40 ),U(40 ),U(40 ),U(42 ),U(39 ),U(40 ),U(40 ),U(40 ),U(40 ),U(42 ),U(39 ),U(42 ),U(42 ),U(42 ),U(42 ),U(39 ),U(40 ),U(42 ),U(39 ),U(39 ),U(42 )};
	double dBSN_Ds[]={U(72 ),U(72 ),U(80 ),U(72 ),U(72 ),U(80 ),U(80 ),U(87 ),U(72 ),U(80 ),U(80 ),U(85 ),U(72 ),U(72 ),U(80 ),U(80 ),U(87 ),U(72 ),U(80 ),U(80 ),U(87 ),U(85 ),U(72 ),U(80 ),U(80 ),U(80 ),U(80 ),U(80 ),U(87 ),U(80 ),U(80 ),U(80 ),U(80 ),U(87 ),U(85 ),U(80 ),U(80 ),U(80 ),U(80 ),U(87 ),U(85 ),U(87 ),U(87 ),U(87 ),U(87 ),U(85 ),U(80 ),U(87 ),U(85 ),U(85 ),U(87 )};
	int nBSN_FullHTs[]={14 ,16 ,20 ,14 ,16 ,20 ,24 ,26 ,14 ,20 ,24 ,30 ,14 ,16 ,20 ,24 ,26 ,16 ,20 ,24 ,26 ,30 ,16 ,20 ,20 ,24 ,20 ,24 ,26 ,20 ,24 ,20 ,24 ,26 ,30 ,24 ,24 ,14 ,24 ,26 ,30 ,26 ,30 ,20 ,26 ,30 ,20 ,30 ,22 ,30 ,26 };
	int nBSN_PartHTs[]={8 ,8 ,10 ,8 ,8 ,10 ,12 ,14 ,8 ,10 ,12 ,16 ,8 ,8 ,10 ,12 ,14 ,8 ,10 ,12 ,14 ,16 ,8 ,10 ,10 ,12 ,10 ,12 ,14 ,10 ,12 ,10 ,12 ,14 ,16 ,12 ,12 ,8 ,12 ,14 ,16 ,14 ,16 ,10 ,14 ,16 ,10 ,16 ,12 ,16 ,14 };
	int nBSN_FullNTs[]={8 ,8 ,10 ,8 ,8 ,10 ,12 ,14 ,8 ,10 ,12 ,16 ,8 ,8 ,10 ,12 ,14 ,8 ,10 ,12 ,14 ,16 ,8 ,10 ,10 ,12 ,10 ,12 ,14 ,10 ,12 ,10 ,12 ,14 ,16 ,12 ,12 ,8 ,12 ,14 ,16 ,14 ,16 ,10 ,14 ,16 ,10 ,16 ,12 ,16 ,14 };
	int nBSN_PartNTs[]={4 ,4 ,6 ,4 ,4 ,6 ,6 ,8 ,4 ,6 ,6 ,8 ,4 ,4 ,6 ,6 ,8 ,4 ,6 ,6 ,8 ,8 ,4 ,6 ,6 ,6 ,6 ,6 ,8 ,6 ,6 ,6 ,6 ,8 ,8 ,6 ,6 ,4 ,6 ,8 ,8 ,8 ,8 ,6 ,8 ,8 ,6 ,8 ,6 ,8 ,8 };			
	double dBSN_BoltDiams[]={U(9 ),U(9 ),U(11 ),U(9 ),U(9 ),U(11 ),U(11 ),U(11 ),U(9 ),U(11 ),U(11 ),U(11 ),U(9 ),U(9 ),U(11 ),U(11 ),U(11 ),U(9 ),U(11 ),U(11 ),U(11 ),U(11 ),U(9 ),U(11 ),U(11 ),U(11 ),U(11 ),U(11 ),U(11 ),U(9 ),U(11 ),U(11 ),U(11 ),U(11 ),U(11 ),U(11 ),U(11 ),U(11 ),U(11 ),U(11 ),U(11 ),U(11 ),U(11 ),U(11 ),U(11 ),U(11 ),U(11 ),U(11 ),U(11 ),U(11 ),U(11 )};
	int nBSN_QtyBolts[] = {2,4,4,2,4,4,4,6,2,4,4,6,2,4,4,4,6,4,4,4,6,4,4,4,4,4,4,4,6,4,4,4,4,6,6,4,4,2,4,6,6,6,6,4,6,6,4,6,4,6,6};
	double dBSN_Thickness = U(2);

	// BSI
	String sBSI_ArticlesRaw[] ={"BSI40/110-B","BSI45/96","BSI48/95","BSI48/136","BSI48/166","BSI60/100-B","BSI60/160-B","BSI64/98-B","BSI64/128-B","BSI70/125-B","BSI73/124","BSI73/153-B","BSI76/120-B","BSI80/120-B","BSI80/150-B","BSI80/180-B","BSI80/210-B","BSI90/145-B","BSI100/90-B","BSI100/140-B","BSI100/170-B","BSI100/200-B","BSI115/162-B","BSI115/190-B","BSI120/119-B","BSI120/160-B","BSI120/190-B","BSI140/139-B","BSI140/180-B"};
	double dBSI_As[]={U(40),U(45),U(48),U(48),U(48),U(60),U(60),U(64),U(64),U(70),U(73),U(73),U(76),U(80),U(80),U(80),U(80),U(90),U(100),U(100),U(100),U(100),U(115),U(115),U(120),U(120),U(120),U(140),U(140)};
	double dBSI_Bs[]={U(110),U(96),U(95),U(136),U(166),U(100),U(160),U(98),U(128),U(125),U(124),U(153),U(120),U(120),U(150),U(180),U(210),U(145),U(90),U(140),U(170),U(200),U(162),U(190),U(119),U(160),U(190),U(139),U(180)};
	double dBSI_Cs[]={U(18),U(18),U(18),U(18),U(18),U(18),U(18),U(18),U(18),U(18),U(18),U(18),U(40),U(40),U(40),U(42),U(39),U(40),U(40),U(40),U(42),U(39),U(42),U(42),U(42),U(42),U(39),U(39),U(39)};
	double dBSI_Ds[]={U(72),U(72),U(72),U(80),U(80),U(72),U(80),U(72),U(80),U(80),U(80),U(80),U(80),U(80),U(80),U(87),U(85),U(80),U(80),U(80),U(87),U(85),U(87),U(87),U(87),U(87),U(85),U(85),U(85)};
	int nBSI_FullHTs[]={8,8,8,10,12,8,12,8,10,10,10,12,20,20,24,26,30,24,14,24,26,30,26,30,20,26,30,24,30};
	int nBSI_PartHTs[]={4,4,4,6,6,4,6,4,6,6,6,6,10,10,12,14,16,12,8,12,14,16,14,16,10,14,16,12,16};
	int nBSI_FullNTs[]={8,8,8,10,12,8,12,8,10,10,10,12,10,10,12,14,16,12,8,12,14,16,14,16,10,14,16,12,16	};
	int nBSI_PartNTs[]={4 ,4 ,4 ,6 ,6 ,4 ,6 ,4 ,6 ,6 ,6 ,6 ,6 ,6 ,6 ,8 ,8 ,6 ,4 ,6 ,8 ,8 ,8 ,8 ,6 ,8 ,8 ,6 ,8 };
	double dBSI_BoltDiams[0];
	int nBSI_QtyBolts[0];
	double dBSI_Thickness= U(2);
	for (int i=0;i< sBSI_ArticlesRaw.length();i++)
	{
		dBSI_BoltDiams.append(0);
		nBSI_QtyBolts.append(0);
	}
	
	// BSIL
	String sBSIL_ArticlesRaw[] ={"BSIL90/195","BSIL90/235","BSIL100/190","BSIL100/230","BSIL115/223","BSIL120/180","BSIL120/220"};
	double dBSIL_As[]={U(90),U(90),U(100),U(100),U(115),U(120),U(120)};
	double dBSIL_Bs[]={U(195),U(235),U(190),U(230),U(223),U(180),U(220)};
	double dBSIL_Cs[]={U(42),U(39),U(42),U(39),U(39),U(42),U(39)};
	double dBSIL_Ds[]={U(87),U(85),U(87),U(85),U(85),U(87),U(85)};
	int nBSIL_FullHTs[]={18,22,18,22,20,16,20};
	int nBSIL_PartHTs[]={18,22,16,20,20,16,20};
	int nBSIL_FullNTs[]={8,10,8,10,10,8,10	};
	int nBSIL_PartNTs[]={8,10,8,10,10,8,10	};
	double dBSIL_BoltDiams[0];
	int nBSIL_QtyBolts[0];	
	for (int i=0;i< sBSIL_ArticlesRaw.length();i++)
	{
		dBSIL_BoltDiams.append(0);
		nBSIL_QtyBolts.append(0);
	}
	double dBSIL_Thickness = U(2);

	// BSD
	String sBSD_ArticlesRaw[0];;
	double dBSD_As[0];
	double dBSD_Bs[]={U(100),U(120),U(140),U(160),U(180),U(200),U(220),U(240),U(260),U(280),U(300),U(320)};
	double dBSD_Cs[]={U(32),U(32),U(32),U(32),U(32),U(32),U(32),U(32),U(32),U(32),U(32),U(32)};
	double dBSD_Ds[]={U(52),U(52),U(52),U(52),U(52),U(52),U(52),U(52),U(52),U(52),U(52),U(52)};
	int nBSD_FullHTs[]={16,20,24,28,32,36,40,44,48,52,56,60};
	int nBSD_PartHTs[]={8,10,12,14,16,18,20,22,24,26,28,30	};
	int nBSD_FullNTs[]={8,10,12,14,16,18,20,22,24,26,28,30	};
	int nBSD_PartNTs[]={4 ,6 ,6 ,8 ,8 ,10 ,10 ,12 ,12 ,14 ,14 ,16};
	double dBSD_BoltDiams[0];
	int nBSD_QtyBolts[0];
	double dBSD_Thickness=U(2);

	// GSE
	String sGSE_ArticlesRaw[] ={"GSE900/120/2,5","GSE-AL900/140/2,5","GSE-AL960/140/2,5","GSE-AL1020/140/2,5","GSE-AL900/160/2,5","GSE-AL960/160/2,5","GSE-AL1020/160/2,5"};
	double dGSE_As[]={U(120),U(140),U(140),U(140),U(160),U(160),U(160)};
	double dGSE_Bs[]={U(390),U(380),U(410),U(440),U(370),U(400),U(430)};
	double dGSE_Cs[]={U(42),U(42),U(42),U(42),U(42),U(42),U(42)};
	double dGSE_Ds[]={U(110),U(110),U(110),U(110),U(110),U(110),U(110)};
	int nGSE_FullHTs[]={68,62,66,74,62,66,74};
	int nGSE_PartHTs[]={36,32,34,38,32,34,38};
	int nGSE_FullNTs[]={34,32,34,38,32,34,38};
	int nGSE_PartNTs[]={18,18,20,20,16,18,20};
	double dGSE_BoltDiams[0];
	int nGSE_QtyBolts[0];
	double dGSE_Thickness=U(2);

	
	/*
	String sBSIL_ArticlesRaw[] ={};
	double dBSIL_As[]={};
	double dBSIL_Bs[]={};
	double dBSIL_Cs[]={};
	double dBSIL_Ds[]={};
	int nBSIL_FullHTs[]={};
	int nBSIL_PartHTs[]={};
	int nBSIL_FullNTs[]={};
	int nBSIL_PartNTs[]={};
	double dBSIL_BoltDiams[]={};
	int nBSIL_QtyBolts[] ={};
	double dBSIL_Thickness;
	*/

	String sArticlesRaw[0];
	double dAs[0];
	double dBs[0];
	double dCs[0];
	double dDs[0];
	int nFullHTs[0];
	int nPartHTs[0];
	int nFullNTs[0];
	int nPartNTs[0];
	double dBoltDiams[0];
	int nQtyBolts[0];
	double dThickness;	
	
// properties
	String sArticles[]={T("|Automatic|")};
	String sArticleName = T("|Article|");
	String sFamilies[] = {"BSN", "BSI","BSIL", "BSD", "BSDI", "GSE"};
	String sFamilyName= T("|Type|");
	String sMarkings[] = {T("|None|"), T("|Front|"), T("|Back|"), T("|Bottom|"), T("|Top|"),
		T("|Front+Pos|"), T("|Back+Pos|"), T("|Bottom+Pos|"), T("|Top+Pos|"), T("|Shopdrawing|")};
	String sMarkingName= T("|Marking|");	
	String sNoYes[] = {T("|No|"), T("|Yes|")};
	String sFlushMountedName= T("|Flush mounted|");	
	
	
	PropString sFamily(0, sFamilies,sFamilyName);	
	PropDouble dGap(0, 0, T("|Gap|"));
	
	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }	

		
	// get execute key to preset family or model
		String sKey = _kExecuteKey;
		int nKeyLength = sKey.length();
		String sFamilyPreset;
		if (sKey.length()>3) sFamilyPreset = sKey.left(4).makeUpper();
		else if (sKey.length()>2) sFamilyPreset = sKey.left(3).makeUpper();
		if (sFamilyPreset.length()>0 && sFamilies.find(sFamilyPreset)>-1)
		{		
			sFamily.set(sFamilyPreset);		
		}
		else
			showDialog();

	// set opm key
		String sOpmKey = sFamily.right(sFamily.length()-2);
		setOPMKey(sOpmKey);
	
	// flag if dialog needs to be shown
		int bShowDialog = 	nKeyLength==0 || nKeyLength>4;		

	// assign family data
		int nFamily = sFamilies.find(sFamily);// 0=BSN, 1=BSI, 2=BSIL , 3 = BSD, 4=BSDI
		// BSN
		if (nFamily==0)sArticlesRaw=sBSN_ArticlesRaw;		
		// BSI
		else if (nFamily==1)sArticlesRaw=sBSI_ArticlesRaw;		
		// BSIL
		else if (nFamily==2)sArticlesRaw=sBSIL_ArticlesRaw;			
		// BSD and BSDI
		else if (nFamily==3 || nFamily==4)
		{
			// BSD and BSDI support width 80...200 every 20mm
			String s = "BSD";
			if (nFamily==4)s="BSDI";
			double dValidWidths[] = {U(80), U(100), U(120), U(140), U(160), U(180), U(200)};
			for (int i=0; i<dBSD_Bs.length();i++)
			{
				String s1, s2;
				
				s2.formatUnit(dBSD_Bs[i]/U(1,"mm"),2,0);		
				for(int j=0;j<dValidWidths.length();j++)
				{
					s1.formatUnit(dValidWidths[j]/U(1,"mm"),2,0);

					sArticlesRaw.append(s+s1+"/"+s2);							
				}	
			}		
		}
		// GSE
		else if (nFamily==5)
		{
			sArticlesRaw=sGSE_ArticlesRaw;	
			sOpmKey= sFamily;
			setOPMKey(sOpmKey);
		}
		
		sArticles.append(sArticlesRaw);
		PropString sArticle(1, sArticles,sArticleName);
		PropString sMarking(2, sMarkings,sMarkingName);
		PropString sFlushMounted(3, sNoYes,sFlushMountedName);
		PropInt nColor(0, 252,T("|Color|"));
		
		if (bShowDialog)
		{
			sFamily.setReadOnly(true);
			showDialog();
		}
		else
		{
			setPropValuesFromCatalog(T("|_Default|"));
		}
		
		sArticle.set(sArticles[0]);		
		
		
		
	// separate selection
		PrEntity ssMale(T("|Select male beam(s)|"), Beam());
		Entity entMales[0], entFemales[0];
		if (ssMale.go())
			entMales= ssMale.set();

		PrEntity ssFemale(T("|Select female beam(s|"), Beam());
		if (ssFemale.go())
		{
		// avoid females to be added to males again
			Entity ents[0];
			ents = ssFemale.set();
			for (int i=0;i<ents.length();i++)
				if(entMales.find(ents[i])<0)entFemales.append(ents[i]);		
		}

	// declare the tsl props
		TslInst tslNew;
		Vector3d vUcsX = _XU;
		Vector3d vUcsY = _YU;
		GenBeam gbAr[2];
		Entity entAr[0];
		Point3d ptAr[0];
		int nArProps[0];
		double dArProps[0];
		String sArProps[0];
		Map mapTsl;

		sArProps.append(sFamily);
		sArProps.append(sArticle);
		sArProps.append(sMarking);
		
		nArProps.append(nColor);						

		dArProps.append(dGap);			

	// loop males
		for (int i=0;i<entMales.length();i++)
		{
			Beam bmMale= (Beam)entMales[i];
			if (!bmMale.bIsValid())continue;
			gbAr[0] =bmMale;
			Vector3d vxMale = bmMale.vecX();
			vUcsX = vxMale;
			vUcsY = bmMale.vecY();
			if (vUcsX.crossProduct(vUcsY).dotProduct(_ZW)<0)
				vUcsY *=-1;

		// loop females
			for (int j=0;j<entFemales.length();j++)
			{
				
				Beam bmFemale = (Beam) entFemales[j];
				Vector3d vxFemale = bmFemale.vecX();
				if (vxMale.isParallelTo(vxFemale)){continue;}
				if (!vxMale.isParallelTo(bmFemale.vecD(vxMale))){continue;} // HSB-11211
				gbAr[1] = bmFemale;
			// create new instance	
				tslNew.dbCreate(scriptName(), vUcsX,vUcsY,gbAr, entAr, ptAr, 
					nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance				
			}// next j			
	
			
		}// next i
		
		eraseInstance();
		return;
	}
// end on insert

// family type
	int nFamily = sFamilies.find(sFamily);// 0=BSN, 1=BSI, 2=BSIL , 3 = BSD, 4=BSDI, 5 = GSE

// set OPM name 
	String sOpmKey;
	if (nFamily ==5)
		sOpmKey= sFamily;
	else
		sOpmKey= sFamily.right(sFamily.length()-2);
	setOPMKey(sOpmKey);

	
// set some variables
	Beam bm0 = _Beam[0], bm1= _Beam[1];
	double dWidthNT = 	_W0;// dA
	double dHeightNT = 	_H0;// dB
	Vector3d vx = _X0;
	Vector3d vy = _Y0;	
	Vector3d vz = _Z0;

	if(!_X0.isParallelTo(_Z1))// HSB-11211)
	{ 
		eraseInstance();
		return;
	}

//region verify alignment on dbCreated if male is not parallel to _ZW 
	if (_bOnDbCreated && !_X0.isParallelTo(_ZW) && abs(vz.dotProduct(_ZW))>0 && vz.dotProduct(_ZW)<0)
	{ 
		_ThisInst.flipAlignZ();
		setExecutionLoops(2);
		return;
	}
//End verify alignment on dbCreated if male is not parallel to _ZW //endregion 



// assign family data
	// BSN
	if (nFamily==0)
	{
		sArticlesRaw=sBSN_ArticlesRaw;
		dAs=dBSN_As;
		dBs=dBSN_Bs;
		dCs=dBSN_Cs;
		dDs=dBSN_Ds;
		nFullHTs=nBSN_FullHTs;
		nPartHTs=nBSN_PartHTs;
		nFullNTs=nBSN_FullNTs;
		nPartNTs=nBSN_PartNTs;
		dBoltDiams=dBSN_BoltDiams;
		nQtyBolts=nBSN_QtyBolts;
		dThickness=dBSN_Thickness;			
	}
	// BSI
	else if (nFamily==1)
	{
		sArticlesRaw=sBSI_ArticlesRaw;
		dAs=dBSI_As;
		dBs=dBSI_Bs;
		dCs=dBSI_Cs;
		dDs=dBSI_Ds;
		nFullHTs=nBSI_FullHTs;
		nPartHTs=nBSI_PartHTs;
		nFullNTs=nBSI_FullNTs;
		nPartNTs=nBSI_PartNTs;
		dBoltDiams=dBSI_BoltDiams;
		nQtyBolts=nBSI_QtyBolts;
		dThickness=dBSI_Thickness;			
	}	
	// BSIL
	else if (nFamily==2)
	{
		sArticlesRaw=sBSIL_ArticlesRaw;
		dAs=dBSIL_As;
		dBs=dBSIL_Bs;
		dCs=dBSIL_Cs;
		dDs=dBSIL_Ds;
		nFullHTs=nBSIL_FullHTs;
		nPartHTs=nBSIL_PartHTs;
		nFullNTs=nBSIL_FullNTs;
		nPartNTs=nBSIL_PartNTs;
		dBoltDiams=dBSIL_BoltDiams;
		nQtyBolts=nBSIL_QtyBolts;
		dThickness=dBSIL_Thickness;			
	}	
	// BSD and BSDI
	else if (nFamily==3 || nFamily==4)
	{
		// BSD and BSDI support width 80...200 every 20mm
		String s = "BSD";
		if (nFamily==4)s="BSDI";
		double dValidWidths[] = {U(80), U(100), U(120), U(140), U(160), U(180), U(200)};
		for (int i=0; i<dBSD_Bs.length();i++)
		{
			for(int j=0;j<dValidWidths.length();j++)
			{
				String s1, s2;
				s1.formatUnit(dValidWidths[j]/U(1,"mm"),2,0);
				s2.formatUnit(dBSD_Bs[i]/U(1,"mm"),2,0);
				sArticlesRaw.append(s+s1+"/"+s2);
				dAs.append(dValidWidths[j]);
				dBs.append(dBSD_Bs[i]);
				dCs.append(dBSD_Cs[i]);
				dDs.append(dBSD_Ds[i]);
				
				nFullHTs.append(nBSD_FullHTs[i]);
				nPartHTs.append(nBSD_PartHTs[i]);
				nFullNTs.append(nBSD_FullNTs[i]);
				nPartNTs.append(nBSD_PartNTs[i]);		
				
				dBoltDiams.append(0);
				nQtyBolts.append(0);									
			}	
		}
		dThickness = dBSD_Thickness;			
	}
	// GSE
	else if (nFamily==5)
	{
		sArticlesRaw=sGSE_ArticlesRaw;
		dAs=dGSE_As;
		dBs=dGSE_Bs;
		dCs=dGSE_Cs;
		dDs=dGSE_Ds;
		nFullHTs=nGSE_FullHTs;
		nPartHTs=nGSE_PartHTs;
		nFullNTs=nGSE_FullNTs;
		nPartNTs=nGSE_PartNTs;
		dBoltDiams=dGSE_BoltDiams;
		nQtyBolts=nGSE_QtyBolts;
		dThickness=dGSE_Thickness;			
	}		
// collect valid width indices
	int nValidTypes[0];
	for (int i=0; i< dAs.length();i++)
	{
		double d = abs(abs(dAs[i]-dWidthNT));
		if (d<dEps) nValidTypes.append(i);
	}
		
// get max height of this serie
	int nAutoArticle=-1;
	//for (int i=nValidTypes.length()-1;i>=0;i--)
	for (int i=0;i<nValidTypes.length();i++)
	{
		int n = nValidTypes[i];
		sArticles.append(sArticlesRaw[n]);
		double d = dBs[n]-dHeightNT;
		if (d>=-dEps && nAutoArticle<0) 
		{
			nAutoArticle=n;	
		}
	}

	
// select the first/last article as auto article if height of joist does not match one of the articles	
	if (nValidTypes.length()>0 && nAutoArticle<0)
	{
		int nLast = nValidTypes.length()-1;
		if (dBs[nLast]-dHeightNT<=0)
			nAutoArticle = nValidTypes[nLast];
		else
			nAutoArticle= nValidTypes[0];		
	}
	
// REDECLARE PROPERTIES_________________________________________________________________________________
	PropString sArticle(1, sArticles,sArticleName);
	PropString sMarking (2, sMarkings,sMarkingName);
	dGap = PropDouble(0, 0, T("|Gap|"));
	PropString sFlushMounted(3, sNoYes,sFlushMountedName);	
	PropInt nColor(0, 252,T("|Color|"));
	
// the article index, -1 means automatic detection		
	int nArticleRaw = sArticlesRaw.find(sArticle);
	int x = nAutoArticle; // preset the autonatic article
	if (nArticleRaw>-1 && nValidTypes.find(nArticleRaw)>-1)x = nArticleRaw;
	
// the marking
	int nMarking =sMarkings.find(sMarking);
	Vector3d vzM = vz;
	if (vz.isParallelTo(_X1))vzM=vy;
	Vector3d vecMarkings[]= {bm1.vecD(-vx), bm1.vecD(-vx), bm1.vecD(vx), bm1.vecD(-vzM), bm1.vecD(vzM),bm1.vecD(-vx), bm1.vecD(vx), bm1.vecD(-vzM), bm1.vecD(vzM),bm1.vecD(-vx)};
	Vector3d vecMarking =vecMarkings[nMarking];
	vecMarking.vis(_Pt0,2);
	_Y1.vis(_Pt0,23);

// flag if flush mounted
	int bFlushMounted=sNoYes.find(sFlushMounted,0);
		
// on recalc set the article
	if (_bOnRecalc && x>-1)	 sArticle.set(sArticlesRaw[x]);
	
	
// cut male
	bm0.addTool(Cut(_Pt0-_Z1*dGap, _Z1),1);
	
// erase if not perpendicular
	if (!_X0.isPerpendicularTo(_X1))
	{
		reportMessage("\n" +  T("|Any model of|") + " " + _ThisInst.opmName() +" " +  T("|requires a perpendicular connection|") + 
		"\n" + T("|Tool will be deleted.|"));
		eraseInstance();
		return;		
		
	}

// no valid type, erase invalid connection
	if (x<0)
	{
		String sSupportedSections;
		String sSep;
		double dWidths[0];
		double dHeights[0];
		for(int i=0;i<dAs.length();i++)
			if (dWidths.find(dAs[i])<0)
			{
				dWidths.append(dAs[i]);
				dHeights.append(dBs[i]);				
			}
		for(int i=0;i<dWidths.length();i++)
		{
			String s1, s2;
			s1.formatUnit(dWidths[i]/U(1,"mm"),2,0);
			s2.formatUnit(dHeights[i]/U(1,"mm"),2,0);
			sSupportedSections+=sSep+s1+"/"+s2;
			sSep=", ";
		}
		sSupportedSections+= "mm";
		reportMessage("\n" + _ThisInst.opmName() + ": " + T("|No matching model found for connection of|") + " " + bm0.posnum() + "/" + bm1.posnum() + 
		"\n" + T("|Current section|") + ": " +dWidthNT/U(1,"mm") + "/" +dHeightNT/U(1,"mm")  + "mm" + 
		"\n" + T("|Available minimal sections|") + ": " +sSupportedSections);
		eraseInstance();
		return;
	}	

// the bottom reference
	Point3d ptRef =_Pt0-	vz*.5*_H0;
	
// flush mounted
	if (bFlushMounted)
	{
		ptRef.transformBy(vz*dThickness);
		BeamCut bc(ptRef, vx,vy,vz,dDs[x]+dGap, bm0.dD(vy)*2, dThickness*2,-1,0,-1);
		//bc.cuttingBody().vis(56);
		bm0.addTool(bc);
	}

	vx.vis(ptRef,1);
	vy.vis(ptRef,3);
	vz.vis(ptRef,150);
	
	
// create the body
	Body bd(ptRef,  vx,vy,vz,dDs[x], dAs[x]+2*dThickness, dThickness, -1,0,-1);
	// side
	PLine pl(vy);
	pl.addVertex(ptRef - vx*dDs[x]);
	// HSB-12396: for BSDI has other 3d representation
	if(nFamily!=4)
		pl.addVertex(ptRef - vx*(dDs[x]-dCs[x])+vz*dCs[x]);
	if(nFamily!=4)
		pl.addVertex(ptRef - vx*(dDs[x]-dCs[x])+vz*dBs[x]);
	else
		pl.addVertex(ptRef - vx*(dDs[x])+vz*dBs[x]);
	pl.addVertex(ptRef + vz*dBs[x]);
	pl.addVertex(ptRef);
	pl.close();
	pl.vis(3);
	Body bdSide(pl, vy*dThickness,1);
	bdSide.transformBy(vy*.5*_W0);
	bd.addPart(bdSide);
	bdSide.transformBy(-vy*(_W0+dThickness));
	bd.addPart(bdSide);
	
	// front
	int nFlipI=1;
	if(sFamily.find("BSI",0)>-1 || sFamily.find("BSDI",0)>-1)nFlipI*=-1 ;
	
	pl = PLine(vx);
	ptRef.transformBy(vy*(.5*_W0+dThickness));
	pl.addVertex(ptRef);
	pl.addVertex(ptRef + (nFlipI*vy+vz) *dCs[x]);
	pl.addVertex(ptRef + nFlipI*vy *dCs[x] + vz * dBs[x]);
	pl.addVertex(ptRef + vz * dBs[x]);
	pl.close();	
	pl.vis(3);
	Body bdFront(pl, vx*dThickness,-1);	
	bd.addPart(bdFront);	
	CoordSys cs;
	cs.setToMirroring(Plane(_Pt0,vy));
	bdFront.transformBy(cs);
	bd.addPart(bdFront);	
	//bd.vis(2);

// collect potential intersecting devices on the female beam
	int bHasIntersection;
	// get tsls of female
	Group groups[] = bm1.groups();
	Entity entTsls[0];
	// collect all if not grouped
	if (groups.length()<1)
	{
		entTsls=Group().collectEntities(true,TslInst(), _kModelSpace);
	}
	else
	{
		for (int g=0;g<groups.length();g++)
			entTsls.append(groups[g].collectEntities(true,TslInst(), _kModelSpace));	
	}
	
	for (int e=0;e<entTsls.length();e++)
	{
		
		TslInst tsl = (TslInst)entTsls[e];
		if (!tsl.bIsValid()) continue;
		Beam beams[]=tsl.beam();
	// do not consider a replacement as an intersection	
		if (beams.length()==2 && beams.find(bm0)>-1 && beams.find(bm1)>-1)
			continue;
		if (beams.find(bm1)>-1 && tsl!=_ThisInst)
		{
			Body bdOther = tsl.realBody();
			if (bdOther.volume()>pow(U(1),3) && bdOther.hasIntersection(bd))
			{
				bdOther.vis(e);
				//bHasIntersection=true;
				break;
			}		
		}
	}

// add hardware part/full trigger, default is full
	int nPartFull =_Map.getInt("PartFullNailing");
	String sTriggerPartFull = T("|nail fully|");
	if (nPartFull==0)sTriggerPartFull = T("|nail partly|");

	addRecalcTrigger(_kContext,sTriggerPartFull );			
	if (_bOnRecalc && _kExecuteKey==sTriggerPartFull) 
	{	
		if (nPartFull==1)
			nPartFull=0;
		else	
			nPartFull=1;			
		_Map.setInt("PartFullNailing",nPartFull);
		setExecutionLoops(2);
	}	


// test if this instance has been created with a version prior 2.0 and erase in this case all attached all hardware components 
	int bPurgeHardware = _Map.getInt("Version")<=10009?true:false;
	_Map.setInt("Version", _ThisInst.version()); // previous versions did not support _kRTTsl

// Hardware//region
// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl || bPurgeHardware)
			hwcs.removeAt(i); 

// declare the groupname of the hardware components
	String sHWGroupName;
	// set group name
	{ 
	// element
		// try to catch the element from the parent entity
		Element elHW =bm1.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid())
			elHW = (Element)bm1;
		if (elHW.bIsValid()) 
			sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)
				sHWGroupName=groups[0].name();
		}		
	}


// add main componnent
	{
		HardWrComp hwc(sArticlesRaw[x], 1); //the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer("Simpson StrongTie");
		
		hwc.setModel(sArticlesRaw[x]);
		hwc.setDescription(sArticlesRaw[x]);
		hwc.setMaterial(T("|Steel, zincated|"));
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(bm1);
		hwc.setCategory(T("|Connectors|"));
		hwc.setRepType(_kRTTsl); //the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(dAs[x]);
		hwc.setDScaleY(dBs[x]);
		hwc.setDScaleZ(dDs[x]);
		
		// apppend component to the list of components
		hwcs.append(hwc);
	}

// add sub componnent	
	{ 
		String sArticleCNA = "CNA 4x60";
		int nQty = nFullNTs[x] + nFullHTs[x];
		if (nPartFull==1)nQty = nPartNTs[x] + nPartHTs[x];
		HardWrComp hwc(sArticleCNA  ,nQty );	
		hwc.setManufacturer("Simpson StrongTie");
		
		hwc.setModel(sArticleCNA );
		hwc.setDescription(T("|Ring-Shank Nail|"));
		hwc.setMaterial(T("|Steel, zincated|"));
		
		hwc.setCategory(T("|Connectors|"));
		hwc.setRepType(_kRTTsl);

		hwc.setDScaleX(U(60));
		hwc.setDScaleY(U(4));
		hwc.setDScaleZ(0);	
		hwcs.append(hwc);
	}



// make sure the hardware is updated
	if (_bOnDbCreated)
		setExecutionLoops(2);
				
	_ThisInst.setHardWrComps(hwcs);	
	//endregion

// get and set compareKey	
	String sCompareKey;
	for (int i=0;i<hwcs.length();i++) 
	{ 
		HardWrComp hwc = hwcs[i];
		sCompareKey+=hwc.articleNumber() + hwc.quantity();  
	}
	setCompareKey(sCompareKey);
	

// erase if intersection found
	if (bHasIntersection)
	{
		reportMessage("\n" + _ThisInst.opmName() + ": " + T("|Intersects with other item|") + " " + bm0.posnum() + "/" + bm1.posnum());
		reportMessage("\n" + _ThisInst.opmName() + ": " + T("|Tool will deleted.|") );
		
		eraseInstance();
		return;			
	}

// declare display
	// Display
	Display dp(nColor);
	dp.showInDxa(true);

// elements
	Element el0;	el0 = bm0.element();	
	Element el1;	el1 = bm1.element();
	
// assignment	
	int nAssignTo=_Map.getInt("assignTo");// 0= male, 1 = female
	
	String sAssignToTxt;
	Element elThis;	
	Beam bmThis;
	if(nAssignTo==1)// the current assignment is female, the trigger shows the command to assign to male
	{
		if (el0.bIsValid())	elThis=el0;
		else bmThis=bm0;
		
		if (el1.bIsValid())sAssignToTxt=T("|Element|") + " " +el1.number();
		else	sAssignToTxt=T("|female Beam|") + " " +bm1.posnum();	
	} 	
	else if(nAssignTo==0)// the current assignment is male, the trigger shows the command to assign to female
	{
		if (el1.bIsValid())	elThis=el1;
		else bmThis=bm1;
		
		if (el0.bIsValid())sAssignToTxt=T("|Element|") + " " +el0.number();
		else	sAssignToTxt=T("|male Beam|") + " " +bm0.posnum();	
	} 
	
// add assignment trigger	
	String sTriggerAssign =T("|Assign to|")+" " + sAssignToTxt;
	addRecalcTrigger(_kContext,sTriggerAssign);			
	if (_bOnRecalc && _kExecuteKey==sTriggerAssign) 
	{	
		if (nAssignTo==1)
			nAssignTo =0;
		else	
			nAssignTo =1;			
		_Map.setInt("assignTo",nAssignTo);
		setExecutionLoops(2);
	}

// assigning
	if (elThis.bIsValid())	
	{
		assignToElementGroup(elThis,TRUE,0, 'Z');
		//dp.elemZone(elThis, 0, 'Z');
	}
	else if (bmThis.bIsValid())
	{
		assignToGroups(bmThis,'Z');
	}		

// add no nailareas in element
	/*if (el0.bIsValid())
	{
		Vector3d vz0 = el0.vecZ();
		int nSide;
		if (vz0.isCodirectionalTo(_Z0))	
			nSide = -1;
		else if (vz0.isCodirectionalTo(-_Z0))			
			nSide = 1;
		
		
		// add no nailareas in element if shoe is parallel to z-axis
		if (abs(nSide) == 1)
		{
			PLine plNN(nSide * _Z0);
			plNN.addVertex(_Pt0 - _Y0 * (0.5 * HB + BlechD + U(10)) - _X0 * (T1 + U(10)));
			plNN.addVertex(_Pt0 + _Y0 * (0.5 * HB + BlechD + U(10)) - _X0 * (T1 + U(10)));
			plNN.addVertex(_Pt0 + _Y0 * (0.5 * HB + BlechD + U(10)) + _X0 * U(10));		
			plNN.addVertex(_Pt0 - _Y0 * (0.5 * HB + BlechD + U(10)) + _X0 * U(10));		
			plNN.close();

			plNN.vis(3);
			//loop zones
			for (int i = 0; i < 5; i++)
			{
				int nZn = (i+1) * nSide;
				if (el0.zone(nZn).dH() > 0)
				{
					ElemNoNail elNN(nZn, plNN);
					el0.addTool(elNN);
				}
			}	
		}
	}*/




		
// draw the body
	dp.draw(bd);	


// marking and dimrequest
	if (nMarking>0)
	{
	// publish dimRequest
		Vector3d vyM = bm0.vecD(_X1);
		Point3d pt1=_Pt0-vyM*.5*bm0.dD(vyM), pt2=_Pt0+vyM*.5*bm0.dD(vyM);		
		//pt1.vis(2);	pt2.vis(2);
		Point3d points[] = {pt1,pt2};
	 	Map mapRequest,mapRequests;
		mapRequest.setPoint3dArray("points", points);
		mapRequest.setVector3d("vecX", _Y0);
		mapRequest.setVector3d("vecY", _Z0);
		mapRequest.setVector3d("vecZ", -_X0);
		mapRequest.setString("Stereotype", "Assembly");
		mapRequest.setVector3d("AllowedView", -_X0);
		mapRequests.appendMap("DimRequest",mapRequest);
		_Map.setMap("Dimrequest[]", mapRequests);			
				
	// apply marking
		if (nMarking<9)
		{
			String text = bm0.posnum();
			Mark mark; 
			if (bm0.posnum()>0 && nMarking>4)
			{
				mark=Mark(pt1,pt2,vecMarking, text);
			}
			else
			{
				mark=Mark(pt1,pt2,vecMarking);				
			}
			bm1.addTool(mark);				
		}
	}
	else
		_Map.removeAt("Dimrequest[]",true);










#End
#BeginThumbnail
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
>E%5%.0"5`'Y<UTEG$UM900,06C0*2.G`JS10!__9
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
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17085 new option to mark including male posnum" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="11/17/2022 12:01:56 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14106 display published for hsbMake and hsbShare" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="12/21/2021 8:22:07 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12396: fis 3d representation fro BSDI" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="7/22/2021 2:37:02 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11211 only applicable to beams with a perpendicular connection plane" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="3/18/2021 9:41:09 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End