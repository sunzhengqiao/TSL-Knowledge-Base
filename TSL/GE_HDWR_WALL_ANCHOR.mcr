#Version 8
#BeginDescription
#Versions
V5.20  01/16/2023 Removed duplicate code
V5.19  01/12/2023  Merged 2 versions with same numbers
V5.17__01/07/21__Will set group on hardware
V5.17 5/23/2022 Added map point for shopdrawing schedule schedule
V5.16__01_Jul_2020__<Drill Plates> now reads from GE_HDWR_WALL_HOLD_DOWN entity (if valid)
V5.15__17_Jun_2020__<Drill Plates> value can be read from _Map
V5.14__06_Apr_2020__Adapted to be consumed by KT_XPORT_ELEMENT_DXF
V5.13__Jan_03_2019__Added Modelmap support
V5.12__18 Dec 2018__Added 7/8, 1-1/8 and 1-1/2 All Thread.  Adjsuted hole size for 1 All Thread to 1-1/2  JF
V5.11__06 Dec 2018__Adjusted hole size for 5/8 All Thread to 1 1/2 JF
V5.10__05 Dec 2018__Corrected hole sizes and bug fix RL
V5.9__20Nov2018__Adjusted drill sizes for regular anchors to 1/16 tolerance
V5.8_Oct_09_2018__Fixed geometry fail on J-bolts
V5.7__26 Sep 2018__Updated Drill Hole Sizes for Automation
V5.6__26 Sep 2019__Updated to remove delete on interference and shift if interference detected.  These checks were causing all anchors placed to be moved and/or deleted even
if there were not interferences.
V5.5__14 Sep 2018__Updated to contain ATS-R and ATS-HSR bolts
V5.4__31 Aug 2018__Changed beam width checks to wall width checks to allow TSL to run correctly with automation suite
V5.3__28 Aug 2018__Added ATS-RTUD5D and ATS-RTUD6D
V5.2__22 Aug 2018__Added item name to include initial ATS Holdowns
V5.1__27 Jun 2018__Adds new groups to sidebar with Catagories of Hold-down Bolts/Anchor Bolts, also subgroups based off of Bolt type
V4.13__19 March 2018__added need 3/4 dia J-Bolts and 1/4 x 3 x 5 wash
V4.12__15 March 2018__Can be flipped when attached to hold down
V4.11__15 Mar 2018__Added 1 inch all thread anchor and drill size
V4.10__3 Mar 2018__Return after erasing this instance.
V4.9__19 Jan 2018__Added Hardware Comp for excel export
V4.8__14 Sep 2017__PBA connects to hold down properly
V4.7__14 Sep 2017__Added PAB anchors
V4.6__08 Sep 2017__Will connect to holdowns even with ellevation and lateral offsets
V4.5__07 Sep 2017__Added dim point
V4.4__07 Sep 2017__Added J-Bolts and SST16
V4.2__13 Jul 2017__Now contains a lateral offset property
V4.1__Will recalc when inserted by a hold down
V4.0__9 June 2016__Corrected insertion

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 5
#MinorVersion 20
#KeyWords Wall;TieRod;Hardware;Anchor
#BeginContents
Unit (1,"inch");
int iState = 0;
if (_Map.hasInt("State"))
{
	iState = _Map.getInt("State");
}

double DownsizeDrill = U(0);//U(0.03125)
int iThItemIndex=1;

String arIdsToIgnor[]={"84","85","95","96"};

int nInt=0,nStr=0,nDbl=0;
String arYN[]={"Yes","No"};

int lstPropInt[0];
double lstPropDouble[0];
String lstPropString[0];


PropString strEmpty1(nStr,"==================================================================","General Properties");strEmpty1.setReadOnly(1);nStr++;lstPropString.append(strEmpty1);

//if the arTypes aray changes make sure to update the list in TH_WALL_HOLD_DOWN and in KT_XPORT_ELEMENT_DXF
String arTypes[]={"1/2\" All Thread" , "5/8\" All Thread" , "3/4\" All Thread" , "1/2\" Wedge Anchor" , "5/8\" Wedge Anchor" , "3/4\" Wedge Anchor" , "1/2\" x 6\" Titen Screw Anchor", "5/8\" x 6\" Titen Screw Anchor", "3/4\" x 6\" Titen Screw Anchor","1/2\" x 6\" J-Bolt", "1/2\" x 8\" J-Bolt", "1/2\" x 10\" J-Bolt","5/8\" x 6\" J-Bolt","5/8\" x 8\" J-Bolt","5/8\" x 10\" J-Bolt", "5/8\" SSTB16", "1/2\" PAB4", "5/8\" PAB5", "3/4\" PAB6", "7/8\" PAB7", "1\" All Thread","3/4\" x 6\" J-Bolt", +
"ATS-RTUD4D", "ATS-RTUD5D", "ATS-RTUD6D", "ATUD5", "ATUD6-2","ATUD9","ATUD9-2","ATUD14","TUD10", "ATS-R3", "ATS-R4", "ATS-R5", "ATS-R6", "ATS-R7", "ATS-R8", "ATS-R9", "ATS-R10", "ATS-R11", "ATS-R12", "ATS-R14", "ATS-R16", "ATS-HSR4", "ATS-HSR5", "ATS-HSR6", "ATS-HSR7", "ATS-HSR8", "ATS-HSR9", "ATS-HSR10", "ATS-HSR11", "ATS-HSR12", "ATS-HSR14", "ATS-HSR16", "7/8\" All Thread","1 1/8\" All Thread","1 1/2\" All Thread"
};
int arHasPlateOnTieDown[]={1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1};//0 will not create a plate
int arDefaultWasherTop[]={2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,6,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2};//See array below called arWasherSize
int arHasRoundExtraWasherTop[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};//1-1/2" round washer
int arDefaultWasherBot[]={5,5,0,2,2,0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,5,6,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,5,5,5};//See array below called arWasherSize
int arExportHexNutSeparately[]={1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1};//Simple bool yes/no
int arDisplayType[]={1,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3};//0 = No display;  1 = Solid circle; 2 = Sliced circle; 3 = Solid sqare
String arSizesOut[]={"1/2\"","5/8\"","3/4\"","1/2\"","5/8\"","3/4\"","1/2\"","5/8\"","3/4\"","1/2\"","1/2\"","1/2\"","5/8\"", "5/8\"", "5/8\"", "5/8\"","1/2\"","5/8\"","3/4\"","7/8\"","1\"","3/4\"","1/2\"","5/8\"", "3/4\"","5/8\"","3/4\"","1-1/8\"","1-1/8\"","1-3/4\"","1-1/4\"", +
"3/8\"","1/2\"","5/8\"","3/4\"","7/8\"","1\"","1-1/8\"","1-1/4\"","1-3/8\"","1-1/2\"","1-3/4\"","2\"","1/2\"","5/8\"","3/4\"","7/8\"","1\"","1-1/8\"","1-1/4\"","1-3/8\"","1-1/2\"","1-3/4\"","2\"","7/8\"","1-1/8\"","1-1/2\""
};
int arNPriority[]={4,5,6,3,2,1,10,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5,5,5};//This is for clean up when next to each other, Larger number gets deleted
double arEmbedConcrete[]={U(4),U(6),U(12),U(4),U(6),U(6),U(6),U(6),U(6),U(6),U(8),U(10),U(6),U(8),U(10), U(17),U(10),U(10),U(10),U(10),U(12),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6)};
double arEmbedMasonry[]={U(8),U(12),U(12),U(8),U(12),U(12),U(12),U(6),U(6),U(6),U(8),U(10),U(6),U(8),U(10), U(17),U(12),U(12),U(12),U(12),U(12),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6),U(6)};
double arRodSize[]={U(0.5),U(0.625),U(0.75),U(0.5),U(0.625), U(0.75),    U(0.5),   U(0.625),  U(0.75),   U(0.5),       U(0.5),      U(0.5),      U(0.625),   U(0.625),   U(0.625),   U(0.625),   U(0.5),    U(0.625),   U(0.75),  U(0.875), U(1),        U(0.5),U(0.5),U(0.625),U(0.75),U(0.625),U(0.75),U(1.125),U(1.125),U(1.75),U(1.25),U(0.375),U(0.5),U(0.625),U(0.75),U(0.875),U(1),U(1.125),U(1.25),U(1.375),U(1.5),U(1.75),U(2),U(0.5),U(0.625),U(0.75),U(0.875),U(1),U(1.125),U(1.25),U(1.375),U(1.5),U(1.75),U(2),U(.875),U(1.125),U(1.5)};
double arDrillSize[]={U(1),  U(1.5),     U(1),   U(.5125),U(0.6875),U(0.7625),U(.5125),U(0.6875),U(.7625), U(0.5125),  U(.5125), U(0.5125), U(0.6875), U(0.6875), U(0.6875), U(0.6875), U(.5125), U(0.6875), U(.7625), U(.8825), U(1.5),  U(.5125), U(1), U(1), U(1), U(1), U(1), U(1.5), U(1.5), U(2), U(1.5), U(0.5), U(0.625), U(0.75), U(0.875), U(1), U(1.125), U(1.25), U(1.375), U(1.5), U(1.75), U(2), U(2.125), U(0.625), U(0.75), U(0.875), U(1), U(1.125), U(1.25), U(1.375), U(1.5), U(1.75), U(2), U(2.125),U(1.5),U(1.5),U(2)};//Rod Size + 1/8 then /2
double arJBoltJog[]={U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(1.5),U(1.5),U(1.5),U(1.5),U(1.5),U(1.5),U(0),U(0),U(0),U(0),U(0),U(0),U(2.5),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0),U(0)};
String arMatOut[]={"All Thread Rod","All Thread Rod","All Thread Rod","Wedge Anchor","Wedge Anchor","Wedge Anchor","Titen Screw Anchor","Titen Screw Anchor","Titen Screw Anchor","J-Bolt","J-Bolt","J-Bolt","J-Bolt","J-Bolt","J-Bolt","SSTB", "PAB4", "PAB5", "PAB6", "PAB7","All Thread Rod","J-Bolt","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod","All Thread Rod"};
String arShortDescriptionOut[]={"TR", "TR","TR","WA","WA","WA","TS","TS","TS","J","J","J","J","J","J", "SSTB","PAB","PAB","PAB","PAB","TR","J","ATS-RTUD4D","ATS-RTUD5D","ATS-RTUD6D","ATUD5", "ATUD6-2","ATUD9","ATUD9-2","ATUD14","TUD10","ATS-R3", "ATS-R4", "ATS-R5", "ATS-R6", "ATS-R7", "ATS-R8", "ATS-R9", "ATS-R10", "ATS-R11", "ATS-R12", "ATS-R14", "ATS-R16", "ATS-HSR4", "ATS-HSR5", "ATS-HSR6", "ATS-HSR7", "ATS-HSR8", "ATS-HSR9", "ATS-HSR10", "ATS-HSR11", "ATS-HSR12", "ATS-HSR14", "ATS-HSR16","TR","TR","TR"
};
int arBIsKindOf[]={0,0,0,1,1,1,2,2,2,3,3,3,3,3,3,1,4,4,4,4,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};//0=ATC Rod, 1=Rod Anchor, 2=Screw Anchor, 3=J-Bolt, 4 = PAB


PropString strRod(nStr,arTypes,"  Hardware Type");nStr++;lstPropString.append(strRod);

String arEmbed[]={"Concrete","Masonry"};
PropString strEmbed(nStr,arEmbed,"  Embedment");nStr++;lstPropString.append(strEmbed);

PropString strDrill(nStr,arYN,"  Drill Plates");nStr++;lstPropString.append(strDrill);

String arCoupler[]={"In floor","In Upper Wall"};
PropString strCoupler(nStr,arCoupler,"  Coupler location");nStr++;lstPropString.append(strCoupler);

PropString strCouplerAtBase(nStr,arYN,"  Force Coupler At Base",1);nStr++;lstPropString.append(strCouplerAtBase);

PropString strForceNuts(nStr,arYN,"  Force bottom plate nuts/washers",1);nStr++;lstPropString.append(strForceNuts);

String arWasherSize[]={"Default","3\"x3\"x1/8\"","2\"x2\"x1/8\"","3\"x3\"x1/4\"","None","1 1/2\" Round", "3\"x5\"x1/4\""};
double arDWashSizeX[]={U(0),U(3),U(2),U(3),U(0),U(1.5),U(3)};
double arDWashSizeY[]={U(0),U(3),U(2),U(3),U(0),U(1.5),U(5)};
double arDWasherThick[]={U(0),U(0.125),U(0.125),U(0.25),U(0),U(0.125),U(0.25)};
int arNWashRoundOrSquare[]={0,0,0,0,0,1,0};

PropString strWasherTop(nStr,arWasherSize,"  Top washer",0);nStr++;lstPropString.append(strWasherTop);

PropString strWasherBot(nStr,arWasherSize,"  Bottom washer",0);nStr++;lstPropString.append(strWasherBot);


PropString strEmpty2(nStr,"==================================================================","Placement Properties");strEmpty2.setReadOnly(1);nStr++;lstPropString.append(strEmpty2);

PropString strCanBeMoved(nStr,arYN,"  Free Placement",1);nStr++;lstPropString.append(strCanBeMoved);

PropDouble dDistFromStud(nDbl,U(2),"  Minimum distance to stud");nDbl++;lstPropDouble.append(dDistFromStud);

PropDouble dDistFromRod(nDbl,U(3),"  Minimum distance to Rod");nDbl++;lstPropDouble.append(dDistFromRod);

double dAddWidthToStuds=dDistFromStud+arRodSize[arTypes.find(strRod)]/2;

PropString strEmpty3(nStr,"==================================================================","Display Properties");strEmpty3.setReadOnly(1);nStr++;lstPropString.append(strEmpty3);
PropString strHideDisplay(nStr,arYN,"  Hide display",0);nStr++;lstPropString.append(strHideDisplay);
int nShowDonutDisplay=arYN.find(strHideDisplay,1);
PropString strFlipDisplay(nStr,arYN,"  Flip side",1);nStr++;lstPropString.append(strFlipDisplay);
int nFlipDisplay=arYN.find(strFlipDisplay,1);

PropString strEmpty4(nStr,"==================================================================","Offset Properties");strEmpty4.setReadOnly(1);nStr++;lstPropString.append(strEmpty4);
PropDouble dLateralOffset(nDbl,U(0),"  Lateral Offset");nDbl++;lstPropDouble.append(dLateralOffset);

PropString strEmpty5(nStr,"==================================================================","Automation Insert");strEmpty5.setReadOnly(1);nStr++;lstPropString.append(strEmpty5);
PropInt nAutomationInsertion(0, 0, "  Automation Insert");nAutomationInsertion.setReadOnly(1);

//Washer Simpson part number to Export
String arWasherNameFound[]={"3\"x3\"x1/8\" (1/2\" rod) Washer","3\"x3\"x1/4\" (5/8\" rod) Washer","3\"x3\"x1/8\" (1/2\" rod) Washer","3\"x3\"x1/8\" (5/8\" rod) Washer","2\"x2\"x1/8\" (1/2\" rod) Washer","2\"x2\"x1/8\" (5/8\" rod) Washer"};
String arWasherNumberOut[]={"BP1/2-3","BP5/8-3","BPS1/2-3","LBPS5/8","LBP1/2","LBP5/8"};

//Scrw anchor Simpson part numbers to export
String arScrewNameFound[]={"3/8\" x 6\" Screw Anchor", "1/2\" x 6\" Screw Anchor", "1/2\" x 12\" Screw Anchor"};
String arScrewNameOut[]={"THD37600H","THD50600H","THD501200H"};

//Bottom plate anchors
String strOutAnchor2[0];
double dLengthAnchor2[0];
String strOutAnchor8[0];
double dLengthAnchor8[0];
strOutAnchor2.append("RFB#4x4");
dLengthAnchor2.append(U(4));
strOutAnchor2.append("RFB#4x5");
dLengthAnchor2.append(U(5));
strOutAnchor2.append("RFB#4x6");
dLengthAnchor2.append(U(6));
strOutAnchor2.append("RFB#4x7");
dLengthAnchor2.append(U(7));
strOutAnchor2.append("RFB#4x10");
dLengthAnchor2.append(U(10));

strOutAnchor8.append("RFB#5x5");
dLengthAnchor8.append(U(5));
strOutAnchor8.append("RFB#5x8");
dLengthAnchor8.append(U(8));
strOutAnchor8.append("RFB#5x10");
dLengthAnchor8.append(U(10));
strOutAnchor8.append("RFB#5x16");
dLengthAnchor8.append(U(16));


if(_Map.hasString("  Hardware Type")){
	strRod.set(_Map.getString("  Hardware Type"));
	_Map.removeAt("  Hardware Type",0);
}

int bNeedRecalc = false;
if (_bOnDbCreated && iState==0)
{
	if(_Map.hasDouble("dRodInsert"))
	{
		double dd = _Map.getDouble("dRodInsert");

		if(abs(dd-U(0.5)) < U(0.125))strRod.set(arTypes[6]);
		else if(abs(dd-U(0.625)) < U(0.125))strRod.set(arTypes[7]);
		else if(abs(dd-U(0.75)) < U(0.125))strRod.set(arTypes[8]);
		else if (abs(dd - U(1)) < U(0.125))strRod.set(arTypes[20]);
		else strRod.set(arTypes[7]);
	}
	if( _Map.hasEntity("HoldDown"))
	{
		strWasherBot.set("None");
		bNeedRecalc = true;
	}
}

// bOnInsert
if (_bOnInsert){

	if (_kExecuteKey=="")
		showDialogOnce();

		_Map.setMap("mpProps", mapWithPropValues());


		PrEntity ssE("\nSelect a set of elements",Element());
		if (ssE.go())
		{
			Entity ents[0];
			ents = ssE.set();
			// turn the selected set into an array of elements
			for (int i=0; i<ents.length(); i++)
			{
				if (ents[i].bIsKindOf(Wall()))
				{
					_Element.append((Element) ents[i]);
				}
			}
		}

		Point3d arPtSelected[0];

		while(1)
		{
			PrPoint ssE2("\nSelect a set of Points");
			if (ssE2.go() == _kOk)
			{
				arPtSelected.append(ssE2.value());
			}
			else{
				break;
			}
		}

		reportMessage("\nPoints selected: " + arPtSelected.length());
		// declare tsl props
		TslInst tsl;
		String sScriptName = scriptName();

		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEnts[1];
		Point3d lstPoints[1];
		//int lstPropInt[0];
		//double lstPropDouble[0];
		//String lstPropString[0];

		//	reportWarning("\nElement length = " + _Element.length()+"\nPoint length = " + arPtSelected.length());
		for(int i=0; i<_Element.length();i++){
			Element el=_Element[i];

			lstEnts[0] = el;

			Wall w=(Wall)el;
			if(!w.bIsValid())continue;
			CoordSys csW=w.coordSys();

			for(int j=0; j<arPtSelected.length();j++){
				Point3d pt=arPtSelected[j];
				if(csW.vecX().dotProduct(pt-w.ptStart()) * csW.vecX().dotProduct(pt-w.ptEnd())<0){
					lstPoints[0]=pt;

					tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,1,_Map );
				}
			}
		}
		eraseInstance();
		return;

	}//END if (_bOnInsert)
//On insert


if(_Element.length()==0)
{
	reportMessage("\nNo Element");
	eraseInstance();
	return;
}

if (!nAutomationInsertion)
{
//__set properties from map
	if(_Map.hasMap("mpProps")){
		setPropValuesFromMap(_Map.getMap("mpProps"));
		_Map.removeAt("mpProps",0);
	}
}


//Use some values based on the type
	int nType=arTypes.find(strRod);
	int bAnchorIsKindOf=arBIsKindOf[nType];

	String strSize=arSizesOut[nType];
	String stDim = arSizesOut[nType] + " " +  arShortDescriptionOut[nType];
	double dEmbedBot=arEmbedConcrete[nType];
	if(strEmbed==arEmbed[1]) dEmbedBot=arEmbedMasonry[nType];

	double dEmbedTop=U(2);
	if(arBIsKindOf[nType]==2)dEmbedTop=U(.5);//Use this for a Bolt anchor
	double dJJog=arJBoltJog[nType];
	double dDrillRadius=(arDrillSize[nType] - DownsizeDrill) / 2;// - U(0.015625);

	int nWashT=arWasherSize.find(strWasherTop);
	int nWashB=arWasherSize.find(strWasherBot);

	String strWashTopName=arWasherSize[arDefaultWasherTop[nType]];
	double dWashTopX=arDWashSizeX[arDefaultWasherTop[nType]];
	double dWashTopY=arDWashSizeY[arDefaultWasherTop[nType]];
	double dWashTopThick=arDWasherThick[arDefaultWasherTop[nType]];
	int nWashTopShape=arNWashRoundOrSquare[arDefaultWasherTop[nType]];

	int bHasDoubleWashOnTop=arHasRoundExtraWasherTop[nType];

	String strWashBotName=arWasherSize[arDefaultWasherBot[nType]];
	double dWashBotX=arDWashSizeX[arDefaultWasherBot[nType]];
	double dWashBotY=arDWashSizeY[arDefaultWasherBot[nType]];
	double dWashBotThick=arDWasherThick[arDefaultWasherBot[nType]];
	int nWashBotShape=arNWashRoundOrSquare[arDefaultWasherBot[nType]];

	if(nWashT>0){
		strWashTopName=arWasherSize[nWashT];
		dWashTopX=arDWashSizeX[nWashT];
		dWashTopY=arDWashSizeY[nWashT];
		dWashTopThick=arDWasherThick[nWashT];
		nWashTopShape=arNWashRoundOrSquare[nWashT];
	}
	else if(arDefaultWasherTop[nType]==0)strWashTopName="None";
	if(nWashB>0 ){
		strWashBotName=arWasherSize[nWashB];
		dWashBotX=arDWashSizeX[nWashB];
		dWashBotY=arDWashSizeY[nWashB];
		dWashBotThick=arDWasherThick[nWashB];
		nWashBotShape=arNWashRoundOrSquare[nWashB];
	}
	else if(arDefaultWasherBot[nType]==0)strWashBotName="None";








if(_bOnElementListModified){
	//wall might have been split
	for(int i=_Element.length()-1;i>-1;i--){
		ElementWall elW=(ElementWall)_Element[i];
		if(! elW.bIsValid()){
			_Element.removeAt(i);
			continue;
		}
		Point3d arPt[]={elW.ptStartOutline(),elW.ptEndOutline()};

		if(elW.vecX().dotProduct(arPt[0]-_Pt0) * elW.vecX().dotProduct(arPt[1]-_Pt0) <0){
			_Element[0]=elW;
			_Element.setLength(1);
			break;
		}
	}
	if(_Element.length()!=1)
	{
		reportMessage("\nNo proper wall found (" + scriptName() + ")" );
		eraseInstance();
		return;
	}
}

String strAddSecondWall="Achor to Upper Wall";
String strRemoveWall="Remove Wall";

addRecalcTrigger(_kContext,strAddSecondWall);
addRecalcTrigger(_kContext,strRemoveWall);


if(_kExecuteKey == strAddSecondWall){

	Wall wNew=getWall("\nSelect upper floor wall");
	ElementWall elNew=(ElementWall)wNew;
	if(elNew.bIsValid()){
		_Element.append(elNew);

		//clean upper wall
		TslInst tslElUp[] = elNew.tslInstAttached();
		for ( int i = 0; i < tslElUp.length(); i++)if(tslElUp[i].scriptName()==scriptName())tslElUp[i].dbErase();

		TslInst tslElAll[] = _Element[0].tslInstAttached();
		for ( int i = 0; i < tslElAll.length(); i++){
			if(tslElAll[i].scriptName()==scriptName()){
				Map mpTSL=tslElAll[i].map();

				mpTSL.setEntity("UpperWall",wNew);

				tslElAll[i].setMap(mpTSL);
			}
		}
	}
}


//see if another wall has been added
if(_Map.hasEntity("UpperWall") && _Element.length()==1){
	Entity entWall=_Map.getEntity("UpperWall");
	Element elMap=(Element)entWall;

	if(elMap.bIsValid())_Element.append(elMap);

	_Map.removeAt("UpperWall",0);
}

TslInst tslHoldDown;

for(int i=0;i<_Entity.length();i++)
{
	Entity ent = _Entity[i];
	TslInst tsl = (TslInst)ent;
	if(!tsl.bIsValid())continue;

	String stName = tsl.scriptName();
	if(stName == "GE_HDWR_WALL_HOLD_DOWN")
	{
		setDependencyOnEntity(_Entity[i]);
		tslHoldDown = tsl;
	}
}



//see if it is attached to a Tie down
int bHasPlateAtBottom=1;
int bIsAttachedToHD=0;
int bFlipped = 0;



if(tslHoldDown.bIsValid()){
	bIsAttachedToHD=1;
	int nTypeFromHD=arTypes.find(strRod);
	if(nTypeFromHD>-1)bHasPlateAtBottom=arHasPlateOnTieDown[nTypeFromHD];

	Map mpEnt = tslHoldDown.map();

	if ( tslHoldDown.propString("Side to place connector").makeUpper().find("TOP", 0) > - 1)bFlipped = 1;

	strDrill.set(arYN[ arYN.find(tslHoldDown.propString("Drill Plates"), 1)]);

	if(mpEnt.hasPoint3d("ANCHOR_POINT"))
	{
		_Pt0=mpEnt.getPoint3d("ANCHOR_POINT");

		if(tslHoldDown.hasPropDouble("Lateral Offset"))
		{
			double dHDOff = tslHoldDown.propDouble("Lateral Offset");
			dLateralOffset.set(dHDOff);
		}
	}
}

if(_kExecuteKey == strRemoveWall){

	Wall wNew=getWall("\nSelect wall to release");
	Element elNew=(Element)wNew;
	if(elNew.bIsValid()){
		for(int i=0; i<_Element.length();i++){
			if(_Element[i].handle()==elNew.handle()){
				reportMessage("Element " + elNew.number() + " has been removed from the TSL");
				_Element.removeAt(i);
			}
		}
	}
}

//Make sure element can be used together
if(_Element.length()>1){
	//take first 2 elements;
	_Element.setLength(2);

	ElementWallSF elSF1=(ElementWallSF)_Element[0];
	if(!elSF1.bIsValid())_Element.removeAt(0);
	ElementWallSF elSF2=(ElementWallSF)_Element[1];
	if(!elSF2.bIsValid())_Element.removeAt(1);

	if(_Element.length()>1){
		if(_Element[0].ptOrg().Z()>_Element[1].ptOrg().Z())_Element.swap(0,1);

		assignToElementGroup(_Element[1],0,FALSE,'Z');

		Point3d ptCen1=elSF1.ptOrg()-elSF1.dBeamWidth()/2*elSF1.vecZ();
		Point3d ptCen2=elSF2.ptOrg()-elSF2.dBeamWidth()/2*elSF2.vecZ();

		double dDistApart=abs(elSF1.vecZ().dotProduct(ptCen1-ptCen2));

		if(dDistApart>U(2.5)){
			reportMessage("\nCannot place " + scriptName() + " in upper wall " +_Element[1].number()+". It will be removed");
			_Element.setLength(1);
		}
	}
}

Element el = _Element[0];
String strEl1=el.number(),strEl2="";
String strElGroup=el.groups();strElGroup.makeUpper();
String stLevel = el.elementGroup().namePart(0);
ElementWallSF elWSF=(ElementWallSF)el;
Wall w= (Wall)el;

String strPart1="X - Hardware",strPart2="X-Anchor Export",strPart3=strRod;;

Group gr(strPart1,strPart2,strPart3);
gr.dbCreate();
gr.setBIsDeliverableContainer(TRUE);
gr.addEntity(_ThisInst,TRUE);

if(el.bIsValid())assignToElementGroup(el,FALSE,0,'Z');


if(!elWSF.bIsValid())
{
	reportMessage("\nNo proper stickframe wall found (" + scriptName() + ")" );
	eraseInstance();
	return;
}
Display dp( 254) ;
Display dpTop( 254) ;
Display dpMod( 254) ;
Display dpModLay( 254) ;
Display dpDonut(6);
dpTop.addViewDirection( _ZW) ;
dpTop.layer(el.layerName());
dpMod.addHideDirection( _ZW ) ;
dpMod.layer(el.layerName());
dpMod.addHideDirection( _ZW ) ;
dpMod.layer(el.layerName());
dpModLay.showInDispRep("Engineering Components");
dpDonut.addViewDirection(_ZW);
dpDonut.layer(el.layerName());

Display dpTop2( 254) ;
Display dpMod2( 254) ;
Display dpMod2Lay( 254) ;
dpTop2.addViewDirection( _ZW) ;
dpMod2.addHideDirection( _ZW ) ;
dpMod2Lay.addHideDirection( _ZW ) ;
dpMod2Lay.showInDispRep("Engineering Components");

Display dpr(1);
dpr.textHeight(U(3));

Vector3d vx=el.vecX();
Vector3d vy= bFlipped?-1*el.vecY():el.vecY();
Vector3d vz=el.vecZ();

Plane pnEl(el.ptOrg()+(dLateralOffset-w.instanceWidth()/2)*el.vecZ(),el.vecZ());
Plane pnElBase(el.ptOrg() + w.baseHeight() * bFlipped * vy ,vy);

//Place Insertion Point to the center base of wall
if( ! bIsAttachedToHD)
{
	_Pt0 = _Pt0.projectPoint(pnEl,0);
	_Pt0 = _Pt0.projectPoint(pnElBase,0);
}
_Pt0.vis();
if(el.vecX().dotProduct(_Pt0-elWSF.ptStartOutline()) * el.vecX().dotProduct(_Pt0-elWSF.ptEndOutline())>0){
	dpr.draw("Out of Range. Belongs to wall " + el.number(),_Pt0,_XU,_YU,1,0,1);
	return;
}

Beam arBm[]=el.beam();
Opening arOpe[]=el.opening();
Point3d arPtStart[0];
Point3d arPtEnd[0];
arPtStart.append(elWSF.ptStartOutline());
arPtEnd.append(elWSF.ptEndOutline());

int bHasUpperWall=FALSE;

if(_Element.length()>1){
	Element el2=_Element[1];
	ElementWallSF elWSF2=(ElementWallSF)el2;
	strEl2=el2.number();
	strElGroup+=el2.groups();
	if(el2.bIsValid())assignToElementGroup(el2,FALSE,0,'Z');

	if(elWSF2.bIsValid()){
		arPtStart.append(elWSF2.ptStartOutline());
		arPtEnd.append(elWSF2.ptEndOutline());
	}
	arBm.append(el2.beam());
	arOpe.append(el2.opening());
	bHasUpperWall=TRUE;

	dpTop2.layer(el2.layerName());
	dpMod2.layer(el2.layerName());
}

Beam arBmNotVertical[0];
Body bdPlates,bdPlates2,bdPlatesBot,bdPlatesBot2;

Point3d arPtNoFrameStart[0],arPtNoFrameEnd[0],arPtNoFrameAverage[0];
double arDCen[0];
Point3d arPtDblPlateStart[0],arPtDblPlateEnd[0];

String arIdsBot[]={"31","32","30"};
String arIdsTop[]={"4","2000"};
String arIdsPlates[]={"31","32","4","30","2000","12"};
String arIdsIgnored[]={"31","32","4","30"};
int arTypesIgnored[]={ _kSFTopPlate, _kSFBottomPlate, _kSFAngledTPLeft, _kSFAngledTPRight, _kSFVeryTopPlate, _kSFVeryTopSlopedPlate, _kSFVeryTopDropInPlate, _kSFVeryBottomSlopedPlate, _kSFVeryBottomPlate };
int arTypesIgnoredPlateBd[]={ _kHeader, _kSill, _kSFTransom };


int iPlateFind = _kSFBottomPlate;
if (bFlipped) iPlateFind = _kSFTopPlate;



for(int i=0; i<arBm.length();i++){
	Beam bm=arBm[i];
	String strId=bm.hsbId();
	//Is it a flat stud
	double dBmZ=bm.dD(el.vecZ());
	if(abs(el.vecZ().dotProduct(bm.ptCen()-_Pt0)) - dBmZ/2 >= dDistFromStud)continue;

	if(!bm.vecX().isParallelTo(vy) && (arTypesIgnoredPlateBd.find(bm.type())==-1 || arIdsPlates.find(bm.hsbId())>-1)){
		arBmNotVertical.append(bm);
		String strElBm=bm.element().number();
		if(strElBm==strEl1){
			//bm.envelopeBody().vis();
			bdPlates+=bm.envelopeBody();
			if (bFlipped)
			{
				if (bm.type() == _kSFTopPlate || arIdsTop.find(strId) >- 1)bdPlatesBot += bm.envelopeBody();
			}
			else
			{
				if (bm.type() == _kSFBottomPlate || arIdsBot.find(strId) >- 1)bdPlatesBot += bm.envelopeBody();
			}
		}
		else {
			bdPlates2+=bm.envelopeBody();
			if(bm.type() == _kSFBottomPlate || arIdsBot.find(strId)>-1)bdPlatesBot2+=bm.envelopeBody();
		}
	}
	else if(bm.vecX().isParallelTo(el.vecX()))continue;

	if(arTypesIgnored.find(bm.type())>-1 || arIdsIgnored.find(strId)>-1)continue;


	Point3d ptEnds[]=bm.envelopeBody().extremeVertices(el.vecX());
	if(ptEnds.length()>0){
		arPtNoFrameStart.append(ptEnds[0]-dAddWidthToStuds*el.vecX());
		arPtNoFrameEnd.append(ptEnds[1]+dAddWidthToStuds*el.vecX());
		arPtNoFrameAverage.append(ptEnds[0]+0.5*bm.envelopeBody().lengthInDirection(el.vecX())*el.vecX());
		arDCen.append(el.vecX().dotProduct(arPtNoFrameAverage[arPtNoFrameAverage.length()-1]-el.ptOrg()));
		//bm.envelopeBody().vis(4);
	}
}

for(int i=0; i<arOpe.length();i++){

	Body bdOpe(arOpe[i].plShape(),el.vecZ()*U(12),0);
	Point3d ptEnds[]=bdOpe.extremeVertices(el.vecX());
	Point3d ptEndsUpDn[]=bdOpe.extremeVertices(vy);
	double dSill=U(0);
	if(ptEndsUpDn.length()>0)dSill=vy.dotProduct(ptEndsUpDn[0]-el.ptOrg());

	if(ptEnds.length()>0){
		arPtDblPlateStart.append(ptEnds[0]-U(16)*el.vecX());
		arPtDblPlateEnd.append(ptEnds[1]+U(16)*el.vecX());

		if(bAnchorIsKindOf == 0 || dSill<U(16)){
			arPtNoFrameStart.append(ptEnds[0]-dAddWidthToStuds*el.vecX());
			arPtNoFrameEnd.append(ptEnds[1]+dAddWidthToStuds*el.vecX());
			arPtNoFrameAverage.append(ptEnds[0]+0.5*bdOpe.lengthInDirection(el.vecX())*el.vecX());
			arDCen.append(el.vecX().dotProduct(arPtNoFrameAverage[arPtNoFrameAverage.length()-1]-el.ptOrg()));
		}
	}
}

for(int i=0; i<arPtStart.length();i++){
	Vector3d vIn(arPtStart[i]-arPtEnd[i]);
	vIn.normalize();

	arPtDblPlateStart.append(arPtStart[i]);//arPtStart[i].vis(4);
	arPtDblPlateEnd.append(arPtStart[i]-U(16)*vIn);

	arPtDblPlateStart.append(arPtEnd[i]+U(16)*vIn);
	arPtDblPlateEnd.append(arPtEnd[i]);
}


//check for double before moving and after moving
int bNeedsDoublePlates=FALSE;

if(strForceNuts==arYN[0]){
	bNeedsDoublePlates=TRUE;
}
for ( int i = 0;i<arPtDblPlateStart.length(); i++ ) {
	double d1=el.vecX().dotProduct(arPtDblPlateStart[i]-_Pt0);
	double d2=el.vecX().dotProduct(arPtDblPlateEnd[i]-_Pt0);

	if(d1*d2<0){
		bNeedsDoublePlates=TRUE;
		break;
	}
}

//set a priority
int myPriority=bNeedsDoublePlates?10:arNPriority[nType];
if(_Map.hasEntity("HoldDown"))myPriority=10;
_Map.setInt("Priority",myPriority);

//Move _Pt0 if necessary
if(strCanBeMoved==arYN[1] && !bIsAttachedToHD && ( _bOnInsert || _bOnElementConstructed || (_bOnDbCreated && iState==0) || _kExecuteKey == strAddSecondWall || _kExecuteKey == strRemoveWall || _kNameLastChangedProp == "_Pt0" ))
//if(FALSE)
{


	for ( int i = arPtNoFrameAverage.length() -1; i >=0  ; i-- ) {
		double d1=el.vecX().dotProduct(arPtNoFrameStart[i]-el.ptOrg());
		int iMax = i ;
		for ( int j = 0; j	<= i  ; j++ ) {
			double d2=el.vecX().dotProduct(arPtNoFrameStart[j]-el.ptOrg());
			if ( d1 < d2 ) {
				d1=d2;
				iMax = j ;
			}
		}
		arPtNoFrameAverage.swap(iMax, i ) ;
		arPtNoFrameEnd.swap(iMax, i ) ;
		arPtNoFrameStart.swap(iMax, i ) ;
		arDCen.swap(iMax, i ) ;
	}

	double dMUp=U(1);

	for ( int i = 0;i<arPtNoFrameAverage.length(); i++ ) {
		double dFare=el.vecX().dotProduct(arPtNoFrameEnd[i]-el.ptOrg());

		int arNDecesToRemove[0];

		for ( int j = i+1;j<arPtNoFrameAverage.length(); j++ ) {
			double dNear=el.vecX().dotProduct(arPtNoFrameStart[j]-el.ptOrg());
			if(dNear<=dFare){
				arNDecesToRemove.append(j);

				double dTempFare=el.vecX().dotProduct(arPtNoFrameEnd[j]-el.ptOrg());
				if(dTempFare>dFare){
					arPtNoFrameEnd[i]=arPtNoFrameEnd[j];
					dFare=dTempFare;
				}
			}
			else{
				break;
			}
		}
		for ( int i = arNDecesToRemove.length()-1;i>-1; i-- ) {
			arPtNoFrameEnd.removeAt( arNDecesToRemove[i]);
			arPtNoFrameStart.removeAt(arNDecesToRemove[i]);
			arPtNoFrameAverage.removeAt(arNDecesToRemove[i]);
		}
	}

	if(arPtNoFrameStart.length()>0){
		arPtNoFrameStart[0].transformBy(U(-36)*el.vecX());
		arPtNoFrameEnd[arPtNoFrameEnd.length()-1].transformBy(U(36)*el.vecX());
	}


	if(_bOnDebug){
		for ( int i = 0;i<arPtNoFrameAverage.length(); i++ ) {
			double d1=el.vecX().dotProduct(arPtNoFrameStart[i]-_Pt0);
			double d2=el.vecX().dotProduct(arPtNoFrameEnd[i]-_Pt0);

			Plane pn(_Pt0+(U(12)+dMUp)*vy,vy);
			arPtNoFrameStart[i]=arPtNoFrameStart[i].projectPoint(pn,U(0));
			arPtNoFrameEnd[i]=arPtNoFrameEnd[i].projectPoint(pn,U(0));
			LineSeg ln(arPtNoFrameStart[i],arPtNoFrameEnd[i]);
			//ln.vis(i);
			dMUp+=U(1);

			if(d1*d2<0){

			if(abs(d1)>U(10) && abs(d2)>U(10)){
				//it is removed. must be on an opening
				reportMessage("\nRemoving anchor on wall " + el.number() + " due to interferences" );
				eraseInstance();
				return;
			}


			if(abs(d1)<abs(d2))_Pt0=arPtNoFrameStart[i];
			else _Pt0=arPtNoFrameEnd[i];

			break;
		}



		}


	}

	for ( int i = 0;i<arPtNoFrameStart.length(); i++ ) {
		double d1=el.vecX().dotProduct(arPtNoFrameStart[i]-_Pt0);
		double d2=el.vecX().dotProduct(arPtNoFrameEnd[i]-_Pt0);


		//remove it if too large
		//double dTotal=abs(el.vecX().dotProduct(arPtNoFrameEnd[i]-arPtNoFrameStart[i]));



	}

	TslInst tslElAll[] = el.tslInstAttached();
	for ( int i = 0; i < tslElAll.length(); i++){
		if(tslElAll[i].scriptName()== scriptName() && tslElAll[i].handle()!=_ThisInst.handle()
			|| tslElAll[i].scriptName()=="GE_HDWR_ITW_TDS"){

			if(abs(el.vecX().dotProduct(_Pt0-tslElAll[i].ptOrg()))<dDistFromRod){
				int hisPriority;
				Map mpOther= tslElAll[i].map();
				if(mpOther.hasInt("Priority"))hisPriority=mpOther.getInt("Priority");
				else{
					String strPropType=tslElAll[i].propString("  Hardware Type");
					hisPriority=arNPriority[arTypes.find(strPropType)];
					if(mpOther.hasEntity("HoldDown"))hisPriority=10;
				}

				if(myPriority>hisPriority)tslElAll[i].dbErase();
				else{
					eraseInstance();
					return;
				}
			}
		}
	}
}

Point3d pt0Top=_Pt0;

//find the uppper an lower point
Line lnRod(_Pt0,vy);

Point3d arPtTruePoints[]=bdPlates.intersectPoints(lnRod);
Point3d arPtTruePoints2[]=bdPlates2.intersectPoints(lnRod);
Point3d arPtTruePointsBot[]=bdPlatesBot.intersectPoints(lnRod);
Point3d arPtTruePointsBot2[]=bdPlatesBot2.intersectPoints(lnRod);
if (_bOnDebug)
{ 
	Body bdVisT(bdPlates); 		bdVisT.transformBy(-el.vecX()*U(120)); bdVisT.vis(1);
	Body bdVisB(bdPlatesBot); 	bdVisB.transformBy(-el.vecX()*U(120)); bdVisB.vis(2);
}

///Use these Items to create bodies
Point3d ptRod1S,ptPlate1S,ptRod1E,ptPlate1E,ptRod2S,ptPlate2S,ptRod2E,ptPlate2E;
Point3d arPtCoups[0];
//get some defaults
ptRod1S=_Pt0-dEmbedBot*vy;
ptPlate1S=_Pt0+U(1.5)*vy;
ptRod1E=_Pt0+vy*w.baseHeight();

//Move up if attached to a hold down
if(bHasUpperWall){
	Plane pnUpper(_Element[1].ptOrg(),vy);
	Point3d pt0Top=_Pt0.projectPoint(pnUpper,U(0));

	//get some defaults
	ptRod2S=pt0Top-dEmbedBot*vy;
	ptPlate2S=pt0Top+U(1.5)*vy;
	ptRod2E=pt0Top+vy*(w.baseHeight()+dEmbedTop);
	ptPlate2E=pt0Top+vy*w.baseHeight();

	if(strCoupler==arCoupler[0]){
		double dHalf=abs(vy.dotProduct(ptRod1E-pt0Top))/2;
		ptRod1E=pt0Top-dHalf*vy;
		ptRod2S=ptRod1E;
	}
	else{
		double dCoupUp=U(12);
		ptRod1E=pt0Top+dCoupUp*vy;
		ptRod2S=ptRod1E;
	}
}

//now assign proper point location if framing is found
double dCoupUp=U(3);
int bExportExtraRod=0;

if( arPtTruePoints.length()>0){
	ptRod1S=arPtTruePoints[0]-dEmbedBot*vy;
	ptPlate1S=arPtTruePoints[0]+U(1.5)*vy;
	ptRod1E=arPtTruePoints[arPtTruePoints.length()-1]+vy*dEmbedTop;
	ptPlate1E=arPtTruePoints[arPtTruePoints.length()-1];
}
if( arPtTruePoints2.length()>0){
	ptRod2S=arPtTruePoints2[0]-dEmbedBot*vy;
	ptPlate2S=arPtTruePoints2[0]+U(1.5)*vy;
	ptRod2E=arPtTruePoints2[arPtTruePoints2.length()-1]+vy*dEmbedTop;
	ptPlate2E=arPtTruePoints2[arPtTruePoints2.length()-1];
}
else{
	bHasUpperWall=FALSE;
}
if( arPtTruePointsBot.length()>0){
	ptPlate1S=arPtTruePointsBot[arPtTruePointsBot.length()-1];
}
if(bIsAttachedToHD){//move up if attached to a hold down
	ptPlate1S = _Pt0 + U(0.25)*vy;//ptPlate1S.transformBy(_Pt0 + U(0.25)*vy);
	dEmbedTop+=U(0.25);
}
if( arPtTruePointsBot2.length()>0){
	ptPlate2S=arPtTruePointsBot2[arPtTruePointsBot2.length()-1];
}
if(bHasUpperWall){
	if(strCoupler==arCoupler[0]){
		double dHalf=abs(vy.dotProduct(ptPlate2S-ptPlate1E))/2;
		ptRod1E=ptPlate1E+dHalf*vy;
		ptRod2S=ptRod1E;//ptRod1E.vis(4);
		if(arBIsKindOf[nType]==0)arPtCoups.append(ptRod1E);
	}
	else{
		ptRod1E=ptPlate2S+dCoupUp*vy;
		ptRod2S=ptRod1E;//ptRod2S.vis();
		if(arBIsKindOf[nType]==0)arPtCoups.append(ptRod1E);
	}
}
//add a coupler at the base if needed
if(strCouplerAtBase==arYN[0]){
	if(arBIsKindOf[nType]==0)	{
		arPtCoups.append(ptPlate1S+dCoupUp*vy);
		bExportExtraRod=1;
	}
	else reportMessage ("\nCannot add a base coupler on a "+strRod+"\nMust be using an ATC Rod");
}

//Plate Points
Point3d arPtPlates[0];
int arBPlateAndNut[0];
double arPlateSizeX[0];
double arPlateSizeY[0];
double arPlateThick[0];
int arNPlateShapes[0];

String arWasherOut[0];
String arNutOut[0];
//do something for bottom plate anchors
if(arBIsKindOf[nType] > 0){
	bHasUpperWall=FALSE;
	ptRod1E=ptPlate1S+vy*dEmbedTop;

	arPtPlates.append(ptPlate1S);
	arPlateSizeX.append(dWashBotX);
	arPlateSizeY.append(dWashBotY);
	arPlateThick.append(dWashBotThick);
	arNPlateShapes.append(nWashTopShape);

	int bHasPlate=1;
	if(bIsAttachedToHD && strWashBotName=="Default")bHasPlate=bHasPlateAtBottom;
	else if(strWashBotName=="None")bHasPlate=0;
	else bHasPlate=1;

	if(bHasPlate)arWasherOut.append(strWashBotName);
	arBPlateAndNut.append(bHasPlate);

	if(arBIsKindOf[nType] != 2)arNutOut.append(strSize);

}
else if(bIsAttachedToHD)
{
	bHasUpperWall=FALSE;
	ptRod1E=_Pt0+vy*dEmbedTop;

	arPtPlates.append(_Pt0);
	arPlateSizeX.append(dWashBotX);
	arPlateSizeY.append(dWashBotY);
	arPlateThick.append(dWashBotThick);
	arNPlateShapes.append(nWashTopShape);

	int bHasPlate=1;
	if(bIsAttachedToHD && strWashBotName=="Default")bHasPlate=bHasPlateAtBottom;
	else if(strWashBotName=="None")bHasPlate=0;
	else bHasPlate=1;

	if(bHasPlate)arWasherOut.append(strWashBotName);
	arBPlateAndNut.append(bHasPlate);

	if(arBIsKindOf[nType] != 2)arNutOut.append(strSize);
}
else{//ATC Rods only
	if(!bHasUpperWall && !bIsAttachedToHD){
		arPtPlates.append(ptPlate1E);
		arPlateSizeX.append(dWashTopX);
		arPlateSizeY.append(dWashTopY);
		arPlateThick.append(dWashTopThick);
		arNPlateShapes.append(nWashTopShape);

		arWasherOut.append(strWashTopName);
		arNutOut.append(strSize);

		if(strWashTopName=="None")arBPlateAndNut.append(0);
		else {
			if(bHasDoubleWashOnTop) arBPlateAndNut.append(2);
			else arBPlateAndNut.append(1);

			if(bHasDoubleWashOnTop){
				//append a round washer
				arPtPlates.append(ptPlate1E+dWashTopThick*vy);
				arPlateSizeX.append(U(1.5));
				arPlateSizeY.append(U(1.5));
				arPlateThick.append(U(0.125));
				arNPlateShapes.append(1);

				arWasherOut.append("1 1/2\" Round");
				//arNutOut.append("None");
				arBPlateAndNut.append(1);
			}
		}
	}

	if(bIsAttachedToHD){
		arPtPlates.append(ptPlate1S);
		arPlateSizeX.append(dWashBotX);
		arPlateSizeY.append(dWashBotY);
		arPlateThick.append(dWashBotThick);
		arNPlateShapes.append(nWashBotShape);

		int bHasPlate=bHasPlateAtBottom;
		if(strWashBotName=="Default")bHasPlate=bHasPlateAtBottom;
		else if(strWashBotName=="None")bHasPlate=0;
		else bHasPlate=1;

		if(bHasPlate)arWasherOut.append(strWashBotName);
		arBPlateAndNut.append(bHasPlate);
		arNutOut.append(strSize);

	}
	else if(bNeedsDoublePlates){
		arPtPlates.append(ptPlate1S);
		arPlateSizeX.append(dWashBotX);
		arPlateSizeY.append(dWashBotY);
		arPlateThick.append(dWashBotThick);
		arNPlateShapes.append(nWashBotShape);

		if(strWashBotName=="Default")arBPlateAndNut.append(bHasPlateAtBottom);
		else if(strWashBotName=="None")arBPlateAndNut.append(0);
		else arBPlateAndNut.append(1);

		arWasherOut.append(strWashBotName);
		arNutOut.append(strSize);
	}
	//add the double Top Washer
}

//draw first Rods
//ptRod1S.vis(3);
Body bdRod1(ptRod1S, ptRod1E, arRodSize[nType] / 2);

//add jog if needed
if(dJJog>U(0)){
	Point3d ptJog=ptRod1S+arRodSize[nType]/2*el.vecZ()+arRodSize[nType]/2*vy;
	Body bdJog(ptJog,ptJog-dJJog*el.vecZ(),arRodSize[nType]/2);


	Body bdOther(ptRod1S + U(0.25) * vy, el.vecX(), el.vecZ(), vy, U(2), U(2), U(2), 0, 1, 1);
	bdOther-=bdRod1;
	bdOther.transformBy(-vy);
	bdJog-=bdOther;

	CoordSys csRo;csRo.setToRotation(90,el.vecX(),ptRod1S+arRodSize[nType]/2*vy);
	bdOther.transformBy(csRo);
	//bdRod1 -=bdOther;

	bdRod1 += bdJog; bdRod1.vis(1);
}
if(arBIsKindOf[nType]==2){
	Body bdCut(ptRod1S+U(0.09)*el.vecZ(),el.vecX(),el.vecZ(),vy,U(2),U(2),U(6),0,1,0);
	CoordSys csRo;csRo.setToRotation(bFlipped?-10:10,el.vecX(),ptRod1S+arRodSize[nType]/2*vy);
	bdCut.transformBy(csRo);


	double dRotate=0;

	while(dRotate<360){
		bdRod1-=bdCut;
		csRo.setToRotation(20,vy,ptRod1S);
		bdCut.transformBy(csRo);
		dRotate+=20;
	}

	//bdCut.vis();
}


dpMod.draw(bdRod1);
dpModLay.draw(bdRod1);

Body bdRod2;Body bdAll(bdRod1);

if(bHasUpperWall){
	bdRod2=Body(ptRod2S,ptRod2E,arRodSize[nType]/2);
	dpMod2.draw(bdRod2);
	dpMod2Lay.draw(bdRod2);
	bdAll.addPart(bdRod2);

	arPtPlates.append(ptPlate2E);
	arPlateSizeX.append(dWashTopX);
	arPlateSizeY.append(dWashTopY);
	arPlateThick.append(dWashTopThick);
	arNPlateShapes.append(nWashBotShape);
	arBPlateAndNut.append(1);

	if(bNeedsDoublePlates){
		arPtPlates.append(ptPlate2S);
		arPlateSizeX.append(dWashBotX);
		arPlateSizeY.append(dWashBotY);
		arPlateThick.append(dWashBotThick);
		arNPlateShapes.append(nWashBotShape);
		arBPlateAndNut.append(1);
	}
}

for(int c=0; c<arPtCoups.length();c++){
	PLine plNut;

	Point3d ptNutRef=arPtCoups[c];

	Vector3d vNut=el.vecZ();
	CoordSys csWasher;csWasher.setToRotation(60,vy,_Pt0);

	for(int w=0; w<6;w++){
		vNut.transformBy(csWasher);
		vNut.normalize();
		plNut.addVertex(ptNutRef+1.1*arRodSize[nType]*vNut);
	}
	plNut.close();


	double dCoupeSize=U(2.5);
	Body bdCoup(plNut,vy*dCoupeSize,0);
	if(bdCoup.hasIntersection(bdRod1))bdCoup-=bdRod1;
	if(bdCoup.hasIntersection(bdRod2))bdCoup-=bdRod2;

	bdAll.addPart(bdCoup);
	dpMod2.draw(bdCoup);
	dpMod2Lay.draw(bdCoup);
}

//change if is attached to a HD
if(bIsAttachedToHD){
	ptPlate1S.transformBy(U(0.25)*vy);
	//dPlateWidth=U(1.75);
}

int nNutCount=0;
int nWasherCount=0;


//do single nuts
for(int n=0; n<arPtPlates.length();n++){
	double dPlateThick=arPlateThick[n],dPlateWidthX=arPlateSizeX[n], dPlateWidthY=arPlateSizeY[n];
	int nDrawShape=arNPlateShapes[n];

	nNutCount++;
	PLine plNut;
	int bHasPlate=arBPlateAndNut[n];

	Point3d ptNutRef=arPtPlates[n];
	if(bHasPlate)ptNutRef+=dPlateThick*vy;
	//if(bHasRoundWasherTop)ptNutRef+=dRoundWashThick*vy;
	///dRoundWashRadius=U(0.75);
	//double dRoundWashThick=U(0.125);
	Vector3d vNut=el.vecZ();
	CoordSys csWasher;csWasher.setToRotation(60,vy,_Pt0);

	for(int w=0; w<6;w++){
		vNut.transformBy(csWasher);
		vNut.normalize();
		plNut.addVertex(ptNutRef+1.25*arRodSize[nType]*vNut);
	}
	plNut.close();

	Body bdNut(plNut,vy*U(.5),1);

	if(bAnchorIsKindOf == 4)
	{
		Body bdNutCopy = bdNut;
		bdNutCopy.transformBy(((ptRod1S - ptNutRef).length() - U(1)) * - vy);

		bdAll.addPart(bdNutCopy);
		dpMod.draw(bdNutCopy);
		dpModLay.draw(bdNutCopy);

		bdNutCopy.transformBy(U(0.625) * - vy);

		bdAll.addPart(bdNutCopy);
		dpMod.draw(bdNutCopy);
		dpModLay.draw(bdNutCopy);

		Point3d ptWasher = ptRod1S + U(1)*vy;
		//ptWasher.vis();

		Body bdW(ptWasher, ptWasher - U(.125)* vy, arRodSize[nType]/2+U(.75));
		bdAll.addPart(bdW);
		dpMod.draw(bdW);
		dpModLay.draw(bdW);
	}



	Body bdPlate;
	if(bHasPlate){
		if(nDrawShape)bdPlate=Body(arPtPlates[n],arPtPlates[n]+vy*dPlateThick,dPlateWidthX/2);
		else bdPlate=Body(arPtPlates[n],vy,el.vecX(),el.vecZ(),dPlateThick,dPlateWidthX,dPlateWidthY,1,0,0);
	}

	if(bHasPlate){
		nWasherCount++;
		bdPlate-=bdRod1;

		bdAll.addPart(bdPlate);
		dpMod.draw(bdPlate);
		dpModLay.draw(bdPlate);
	}
	if(bHasPlate==1){
		if(bdNut.hasIntersection(bdRod1)){
			bdNut-=bdRod1;

			bdAll.addPart(bdNut);
			dpMod.draw(bdNut);
			dpModLay.draw(bdNut);
		}
		else{
			bdNut-=bdRod2;

			bdAll.addPart(bdNut);
			dpMod2.draw(bdNut);
			dpMod2Lay.draw(bdNut);
			if(bHasPlate){
				nWasherCount++;
				bdPlate-=bdRod2;

				bdAll.addPart(bdPlate);
				dpMod2.draw(bdPlate);
				dpMod2Lay.draw(bdPlate);
			}

		}
	}
}

//Add drill to plates
if(strDrill==arYN[0])
{
	bdRod1+=bdRod2;
	bdRod1.vis(1);
	for ( int i = 0; i < arBmNotVertical.length(); i++){
		Body bdPlate=arBmNotVertical[i].envelopeBody();
		if(bdPlate.hasIntersection(bdRod1)){
			Point3d arPts[]=bdPlate.intersectPoints(lnRod);
			if(arPts.length()==0)continue;
			Drill dr( arPts[0]-U(0.25)*vy,arPts[arPts.length()-1]+U(0.25)*vy,dDrillRadius);
			arBmNotVertical[i].addTool(dr);
		}
	}
}


//do top view display
double dCrossSize = U(2); //if this changes make sure to update in KT_XPORT_ELEMENT_DXF
double dTextHeight = U(1);//if this changes make sure to update in KT_XPORT_ELEMENT_DXF
dpTop.textHeight(dTextHeight);

PLine plC1;
plC1.createCircle(_Pt0,vy,arDrillSize[nType]/2);
LineSeg lnX1(_Pt0-dCrossSize*.5*el.vecX(),_Pt0+dCrossSize*.5*el.vecX());
LineSeg lnZ1(_Pt0-dCrossSize*.5*el.vecZ(),_Pt0+dCrossSize*.5*el.vecZ());

dpTop.draw(plC1);
dpTop.draw(lnX1);
dpTop.draw(lnZ1);
dpTop.draw(nType+1,_Pt0+dTextHeight*el.vecX()+dTextHeight*el.vecZ(),_XW,_YW,0,0);


if(bHasUpperWall){
	PLine plC2;
	plC2.createCircle( pt0Top,vy,arDrillSize[nType]/2);

	LineSeg lnX1( pt0Top-U(1)*el.vecX(), pt0Top+U(1)*el.vecX());
	LineSeg lnZ1( pt0Top-U(1)*el.vecZ(), pt0Top+U(1)*el.vecZ());

	dpTop2.draw(plC1);
	dpTop2.draw(lnX1);
	dpTop2.draw(lnZ1);
}

//do magenta display
if(nShowDonutDisplay)
{
	//Defining side of wall
	Vector3d vSide=vz;
	if(nFlipDisplay)
	{
		vSide=-vSide;
	}
	//Getting common props for display types
	double dLineSide=U(10);
	double dDonutRadius=U(3);
	double dSquareSide=dDonutRadius*2;
	Hatch hatchSolid("SOLID",U(1));
	Point3d ptRef=pt0Top+vSide*dLineSide;

	//Exporting draw point to map. To be used on tsl for paper space
	_Map.setPoint3d("DISPLAY POINT", ptRef);

	//Defining display type
	int nDisplayType=arDisplayType[nType];
	_Map.setInt("DISPLAY TYPE", nDisplayType);

	//Displaying according type
	if(nDisplayType==1|| nDisplayType==2)//Solid circle or sliced circle
	{
		//Displaying line
		PLine plSeg(pt0Top, ptRef);
		dpDonut.draw(plSeg);
		//Displaying circle
		PLine plC2;
		plC2.createCircle( ptRef,vy,dDonutRadius);
		PlaneProfile profCircle(plC2);
		if(nDisplayType==2)//Must slice donut
		{
			//Create rectangles to be taken out
			double dTol=U(.00001);
			double dSquareSide=dDonutRadius;
			Point3d ptVertex1=ptRef+_XW*dSquareSide+_YW*dSquareSide;
			Point3d ptVertex2=ptRef-_XW*dSquareSide-_YW*dSquareSide;
			PLine plSquare1;
			plSquare1.createRectangle(LineSeg(ptRef+_XW*dTol+_YW*dTol, ptVertex1), _XW, _YW);
			PLine plSquare2;
			plSquare2.createRectangle(LineSeg(ptRef-_XW*dTol-_YW*dTol, ptVertex2), _XW, _YW);
			profCircle.joinRing(plSquare2,1);
			profCircle.joinRing(plSquare1,1);
			dpDonut.draw(plC2);
		}
		dpDonut.draw(profCircle, hatchSolid);
	}
	else if(nDisplayType==3)//Solid square
	{
		//Displaying line
		PLine plSeg(pt0Top, ptRef);
		dpDonut.draw(plSeg);
		//Displaying square
		Point3d ptVertex1=ptRef+_XW*dSquareSide*.5+_YW*dSquareSide*.5;
		Point3d ptVertex2=ptRef-_XW*dSquareSide*.5-_YW*dSquareSide*.5;
		PLine plSquare;
		plSquare.createRectangle(LineSeg(ptVertex1, ptVertex2), _XW, _YW);
		PlaneProfile profSquare(plSquare);
		dpDonut.draw(profSquare, hatchSolid);
	}
}

//output
Map mapDxaOut;
double dLengthOut=bdRod1.lengthInDirection(vy);
String strLgtOut="12\"";
String stLgtPAB = "12";

if(dLengthOut>U(12))
{
	strLgtOut="18\"";
	stLgtPAB = "18";
}
if(dLengthOut>U(18))
{
	strLgtOut="24\"";
	stLgtPAB="24";
}
if(dLengthOut>U(24))
{
	strLgtOut="30\"";
	stLgtPAB="30";
}
if(dLengthOut>U(30))
{
	strLgtOut="36\"";
	stLgtPAB="36";
}
if(dLengthOut>U(36))
{
	strLgtOut="8'-0\"";
	stLgtPAB=dLengthOut;
}
if(dLengthOut>U(96))strLgtOut="9'-0\"";
if(dLengthOut>U(108))strLgtOut="10'-0\"";

if(arBIsKindOf[nType])strLgtOut.formatUnit(dLengthOut,4,4);
if(arBIsKindOf[nType]==2)strLgtOut=dEmbedBot;//Use this for a Bolt anchor

String stPAB = arMatOut[nType] + "-" +stLgtPAB ;

exportToDxi(TRUE);

String stModelOut, stMaterialOut;

if(arBIsKindOf[nType] == 4)
{
	stModelOut = stPAB;
	stMaterialOut =stPAB;
}
else
{
	stModelOut = strRod;
	stMaterialOut = arMatOut[nType];
}


model(stModelOut);
material(stMaterialOut);

//dxaout("Rod Length",strLgtOut);
dxaout("Element",el.number());
dxaout("Element(Upper)",strEl2);
//dxaout("TH-Item_",strSize + "x"+strLgtOut + " " + arMatOut[nType]);

Map mpDim;
mpDim.setPoint3d("ptDim", _Pt0);
mpDim.setString("stModel", stDim);
_Map.setMap("mpAnchorDim", mpDim);




if(strElGroup.find("FIRST",0)>-1){
	String RodOut=strRod;
	int nFound=arScrewNameFound.find(RodOut);

	if(nFound > -1) RodOut=arScrewNameOut[nFound];
	else RodOut=strSize + "x"+strLgtOut + " " + arMatOut[nType];


	if(bAnchorIsKindOf==1){//Is a bottom plate anchor

		if(strSize=="1/2\""){
			for(int r=0;r<dLengthAnchor2.length();r++){
				if(dLengthOut<=(dLengthAnchor2[r]+U(0.01))){
					RodOut=strOutAnchor2[r];
					break;
				}
			}
		}
		else if(strSize=="5/8\""){
			for(int r=0;r<dLengthAnchor8.length();r++){
				if(dLengthOut<=(dLengthAnchor8[r]+U(0.01))){
					RodOut=strOutAnchor8[r];
					break;
				}
			}
		}
	}


	mapDxaOut.appendInt(RodOut  ,1);
	dxaout("TH-Item_"+ iThItemIndex,RodOut);
	iThItemIndex++;

	if(bExportExtraRod){//This is when we have a coupler at the base
		double dLengthExtra=dEmbedBot+U(3.5);//Embed+plate thick+2inch
		//dxaout("Rod Length",dLengthExtra);
		//mapDxaOut.appendDouble(strRod+" (ln)",formatUnit(dLengthExtra,4,4));
		mapDxaOut.appendInt(strSize + "x"+ String().formatUnit(dLengthExtra,4,4) + " " + arMatOut[nType]  ,1);
		dxaout("TH-Item_"+iThItemIndex,strSize + "x"+String().formatUnit(dLengthExtra,4,4) + " " + arMatOut[nType]);
		iThItemIndex++;
	}
}


//Coupler output
if(arPtCoups.length()>0){
	String strCoupOut="RC"+ strSize + " Coupler";
	//dxaout(strCoupOut,arPtCoups.length());

	mapDxaOut.appendInt(strCoupOut,arPtCoups.length());

	for(int c=0;c<arPtCoups.length();c++)dxaout("TH-Item_"+iThItemIndex,strCoupOut);
	iThItemIndex++;
}



//Washer and Nut count
String arHardOutType[0];
int arHardOutQty[0];
//washer
for(int w=0;w<arWasherOut.length();w++){
	if(arWasherOut[w] == "None")continue;

	String strName=arWasherOut[w] + " (" + strSize + " rod) Washer";

	int nOutWasher=arWasherNameFound.find(strName);
	if(nOutWasher > -1) strName=arWasherNumberOut[nOutWasher];

	//These next lines where commented to avoid washer to be exported separately to BOM v2.8: 2011-feb-24: David Rueda (dr@hsb-cad.com)
//	dxaout("TH-Item_"+iThItemIndex,strName);
//	iThItemIndex++;
//	mapDxaOut.appendInt(strName,1);


	//int nFind=arHardOutType.find(strName);
	//if(nFind>-1)arHardOutQty[nFind]++;
	//else{
	//	arHardOutType.append(strName);
	//	arHardOutQty.append(1);
	//}
}
//nut
for(int w=0;w<arNutOut.length();w++){
	String strName=arNutOut[w]+" Nut";

	int nExportHexNutSeparately=arExportHexNutSeparately[nType];
	if(nExportHexNutSeparately)
	{
		dxaout("TH-Item_"+iThItemIndex,strName);
		iThItemIndex++;
		mapDxaOut.appendInt(strName,1);
	}

	//int nFind=arHardOutType.find(strName);
	//if(nFind>-1)arHardOutQty[nFind]++;
	//else{
	//	arHardOutType.append(strName);
	//	arHardOutQty.append(1);
	//}
}

//Export it here
//for(int e=0;e<arHardOutType.length();e++){
//	dxaout(arHardOutType[e],arHardOutQty[e]);
//	mapDxaOut.appendInt(arHardOutType[e],arHardOutQty[e]);
//}


//Export adhisive
if(arBIsKindOf[nType]==0 || arBIsKindOf[nType]==1){
	dxaout("Acrylic Tie Adhesive",dEmbedBot);
	mapDxaOut.appendDouble("Acrylic Tie Adhesive",dEmbedBot);
}


//Second rod length
double dLengthOut2=bdRod2.lengthInDirection(vy);
if(dLengthOut2>U(0)){
	String strLgtOut2="";
	if(dLengthOut2>U(0))strLgtOut2="8'-0\"";
	if(dLengthOut2>U(96))strLgtOut2="9'-0\"";
	if(dLengthOut2>U(108))strLgtOut2="10'-0\"";

	dxaout("TH-Item_"+iThItemIndex,strSize + "x"+strLgtOut2 + " " + arMatOut[nType]);
	iThItemIndex++;
	if(strElGroup.find("SECOND",0)>-1){
		mapDxaOut.appendInt(strSize + "x"+strLgtOut2 + " " + arMatOut[nType]  ,1);
		//if(strLgtOut2.find("'",0)>-1)mapDxaOut.appendInt(strRod+" " + strLgtOut2,1);
		//else mapDxaOut.appendDouble(strRod+" (ln)",dLengthOut2);
	}
}

mapDxaOut.setEntity("entElement",el);

_Map.setMap("MapDxaOut",mapDxaOut);

_Map.setPoint3d("mpSchedule\\ptDim", bdAll.ptCen());

if(bNeedRecalc)_ThisInst.recalc();


//Add Hadrware for export
HardWrComp arHwr[0];

HardWrComp hwr;
hwr.setName("Anchor");
hwr.setBVisualize(false);
hwr.setDescription("Wall Anchor");
hwr.setManufacturer( stMaterialOut);
hwr.setArticleNumber(stModelOut);
hwr.setModel(stMaterialOut);
hwr.setQuantity(1);
hwr.setCountType("Amount");
hwr.setGroup(stLevel);

arHwr.append(hwr);

_ThisInst.setHardWrComps(arHwr);
#End
#BeginThumbnail
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
M:78Z19K::?:Q6T"X^6-<9.`,D]2<`<GDXJW1176E;8Y6[A1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5X'\;_P#D=+/_
M`+!R?^C)*]\KP/XW_P#(Z6?_`&#D_P#1DE<V+_AG1A?XAYK1117F'I!1110!
M8L_]<?\`=J]5&S_UQ_W:O4"9]84445[AXP4444`%%%%`!1110!XY\>/^9?\`
M^WC_`-I5XY7L/QVEC:70HE=3(BSLR`\JI,8!([`E6Q]#Z5X]7DXG^*SU,/\`
MPT%%%%8FP5+;?\?"_C_*HJEMO^/A?Q_E0!HU"_WS4U0O]\U$]APW&T445D:!
M11UJ18_[WY4TFQ-I#`">@J18P.O-/`P,"K>G:7?:O>+::?:RW,[8^6-<X&0,
MD]`,D<G@9K6,#.4RI6]X<\'ZQXH9CI\*K`C;7N)FVQJ<9QW)/3H#C(SC->E^
M%_A19Z<XNM=>*^G&"D"`^4A#9R2<%^`."`.2"#P:]$BBC@A2&&-8XHU"HB#"
MJ!P``.@KNI81O69QU,2EI`Y/PQ\.]'\.JDTL:W]^K%A<S)PO((VIDA2,#GDY
MSS@XKKZ**[HQ45:*..4G)W844451(4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!7@?QO_Y'2S_[!R?^C)*]\KP/
MXW_\CI9_]@Y/_1DE<V+_`(9T87^(>:T445YAZ04444`6+/\`UQ_W:O51L_\`
M7'_=J]0)GUA1117N'C!1110`44R66."%YII$CBC4L[NP"JHY))/05YUXI^+6
MGZ<KVVA!+Z\#`&5E/D+@D'G(+'CC''.<G&*SJ584U>3+A3E-VBCO=2U2PT>S
M:[U&[BMH%S\TC8R<$X`ZDX!X')Q7DOB?XP74LTMKX=C2&%6(%Y*NYW`QRJ$8
M4<$?,"2"/NFO.M7UG4-=OS>ZG=/<7!4+N8``*.@`&`!]!U)/>J->96QLI:0T
M7XGHTL)&.LM6/EEDGF>::1Y)9&+.[L2S,>223U-5W@4\KP:EHKC3:.JR*3*R
MG##%)5T@,,$9%0O!W3\JT4^Y+B05+;?\?"_C_*HR"IP1@U);?\?"_C_*K)-&
MH7^^:FJ)E+.<5,]@AN,IZQD]>!3U0+[FG4E#N-S["!0O05)%%)/,D,,;22R,
M%1$&68G@``=376>&/AWK'B)DFEC:PL&4L+F9.6X!&U,@L#D<\#&><C%>S>'?
M">D^&+?R["#,QSON90&E8$@X+`#C@<#`XSUR:ZZ6&E/R1RU,1&/FSQ&;P5?Z
M=!83ZJ!`+U69(0?WB`#^($84\@XY/K@U[SHNG6>F:3;P6-M%;Q;%8K&N-QV@
M9/J>!R>37(?$K_CXT;ZS_P`EKN;4%;.!6!!$:@@]N*]"G2C3V.*=64]R:BBB
MM#,****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"O`_C?\`\CI9_P#8.3_T9)117-B_X9T87^(>:T44
M5YAZ04444`6+/_7'_=J]110)GUA1117N'C!1110!Y3\:[NYAMM(MXKB5()_.
M\V)7(63:8RNX=#@\C/2O':**\?&_Q3U<'_""BBBN,Z@HHHH`****`(KC[@^M
M1VW_`!\+^/\`*BBMH;&<MS1HHHJB`KJ?AQ%'-X_TI98U=0TC`,,C(C8@_4$`
MCW%%%73^-$S^%GT/1117LGDC6C1V1G169#N0D9*G!&1Z'!(_$TZBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
,B@`HHHH`****`/_9
`































#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Added map point for shopdrawing schedule schedule" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="17" />
      <str nm="DATE" vl="5/23/2022 1:18:35 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End