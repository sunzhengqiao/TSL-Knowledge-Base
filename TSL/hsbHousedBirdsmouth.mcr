#Version 8
#BeginDescription
version value="1.2" date="22feb2021" author="nils.gregor@hsbcad.com"> 
HSB-10134 Added property for end cut and image

 This tsl creates a housed birdsmouth between a rafter an d purlin. 
 The angle of the beams has to be bigger than 1° and less than 89°. 
#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents

/// <History>//region
/// <version value="1.2" date="22feb2021" author="nils.gregor@hsbcad.com"> HSB-10134 Added property for end cut and image </version>
/// <version value="1.1" date="28jan2021" author="nils.gregor@hsbcad.com"> HSB-10134 Changed behavior of property (C), renamed properties </version>
/// <version value="1.0" date="26jan2021" author="nils.gregor@hsbcad.com"> HSB-10134 initial version </version>
/// </History>

/// <insert Lang=en>
/// Select male beams and or roofplane, select female beams and define properties.
/// </insert>

/// <summary Lang=en>
/// This tsl creates a housed birdsmouth between a rafter an d purlin. 
/// The angle of the beams has to be bigger than 1° and less than 89°. 
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbHousedBirdsmouth")) TSLCONTENT
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

	String sHouseDepthTopName=T("|Vertical Depth| (A)");	
	PropDouble dHouseDepthTop(nDoubleIndex++, U(20), sHouseDepthTopName);	
	dHouseDepthTop.setDescription(T("|Defines the depth of the house at the top of the purlin|"));
	dHouseDepthTop.setCategory(category);
	
	String sHouseDepthSideName=T("|Horizontal Depth| (B)");	
	PropDouble dHouseDepthSide(nDoubleIndex++, U(20), sHouseDepthSideName);	
	dHouseDepthSide.setDescription(T("|Defines the depth of the house at the side of the purlin|"));
	dHouseDepthSide.setCategory(category);
	
	String sVertOffsetHouseName=T("|Offset Horizontal Cut| (C)");	
	PropDouble dVertOffsetHouse(nDoubleIndex++, U(5), sVertOffsetHouseName);	
	dVertOffsetHouse.setDescription(T("|Defines the horizontal distance to the edge where the bottom cut starts|"));
	dVertOffsetHouse.setCategory(category);
	
	category = T("|Gaps|");
	String sGapAtSideName=T("|Side| (D)");	
	PropDouble dGapAtSide(nDoubleIndex++, U(0.5), sGapAtSideName);	
	dGapAtSide.setDescription(T("|Defines the gap for the housing at the sides in the purlin. The value is taken at each side|"));
	dGapAtSide.setCategory(category);
	
	String sGapAtBottomName=T("|Bottom| (E)");	
	PropDouble dGapAtBottom(nDoubleIndex++, U(0), sGapAtBottomName);	
	dGapAtBottom.setDescription(T("|Defines the gap at the bottom of the housing at the side|"));
	dGapAtBottom.setCategory(category);
	
	category = T("|End cut|");	
	String sCutMaleBeamName=T("|Cut male beam|");	
	PropString sCutMaleBeam(nStringIndex++, sNoYes, sCutMaleBeamName,1);	
	sCutMaleBeam.setDescription(T("|Defines an end cut at the male beam at the opposite side of the female beam|"));
	sCutMaleBeam.setCategory(category);
	

// bOnInsert
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
		
		Beam bmMales[0], bmFemales[0];
		
	// collect male beams or roofplanes to insert on every connection
		Entity ents[0];
		PrEntity ssE(T("|Select roofplane or beams|"), Beam());
		ssE.addAllowedClass(ERoofPlane());
		if (ssE.go())
			ents=ssE.set();
			
		Entity entFems[0];
		PrEntity ssB(T("|Select female beams as purlin|"), Beam());
		if (ssB.go())
			entFems=ssB.set();

	// Selected male beams
		for (int i= ents.length()-1; i > -1 ; i--)
		{ 
			if (ents[i].bIsKindOf(Beam()))
			{
				Beam bm = (Beam)ents[i];
				if(bm.bIsDummy())
				{
					bmMales.removeAt(i);
					continue;
				}
				bmMales.append(bm);
				ents.removeAt(i);
			}
		}
		if(bDebug)reportMessage("\n"+bmMales.length() + " bmMales collected");
		
	// Check for selected roofplanes
		for (int i=0 ; i < ents.length() ; i++) 
		{ 
			Entity ent = ents[i]; 
			Beam beams[0];

		    	if(ent.bIsKindOf(ERoofPlane()))
		    	{
		    		ToolEnt tent = (ToolEnt)ent;
		    		beams = tent.beam();
		    		
		   	// remove any selected beam if part of element
		    		for (int j=bmMales.length()-1; j>=0 ; j--) 
		    		{ 
		    			if (beams.find(bmMales[j])>-1)
		    				bmMales.removeAt(j); 
		    		}
		    		bmMales.append(beams);
		    	}	
		}
		
	// Check selected female beams	
		for(int i=0; i < entFems.length();i++)
		{
			if(entFems[i].bIsKindOf(Beam()))
			{
				Beam bm = (Beam)entFems[i];
				if(!bm.bIsDummy())
					bmFemales.append(bm);		
			}
		}
		
	// Filter out paralell beams to Female beams
		for(int i= bmMales.length()-1; i > -1; i--)
		{
			Vector3d vecMale = bmMales[i].vecX();
			Beam bm = bmMales[i];
			
			for(int j=0; j < bmFemales.length();j++)
			{
				if(vecMale.isParallelTo(bmFemales[j].vecX()))
				{
					bmMales.removeAt(i);
					continue;
				}				
			}
			
			Body bdMale(bm.ptCen(), bm.vecX(), bm.vecY(), bm.vecZ(), bm.dL() + dEps, bm.dW() + dEps, bm.dH() + dEps);
			Beam bms[] = bdMale.filterGenBeamsIntersect(bmFemales);
			
			if(bms.length() < 1)
				bmMales.removeAt(i);			
		}
		
	// Create for each connection a separate Instance
		for(int i=0; i < bmMales.length();i++)
		{
			for(int j=0; j < bmFemales.length();j++)
			{
				// create TSL
					TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
					GenBeam gbsTsl[] = {bmMales[i], bmFemales[j]};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
					int nProps[]={};			double dProps[]={dHouseDepthTop, dHouseDepthSide, dVertOffsetHouse, dGapAtSide, dGapAtBottom};				
					String sProps[]={sCutMaleBeam};	Map mapTsl;	
								
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
			}
		}
		
		eraseInstance();
		return;
	}// END IF on insert_________________________________________________	
	
	
	_ThisInst.setAllowGripAtPt0(false);	
	if(_Beam.length() != 2 || !_Beam[0].bIsValid() || !_Beam[0].bIsValid() )
	{
		reportMessage(TN("|Beams are invalid. Instace deleted|"));
		eraseInstance();
		return;
	}
	
// Basic information of both beams
	Beam bm0 = _Beam[0];
	Beam bm1 = _Beam[1];
	Point3d pt0Cen = bm0.ptCen();
	Point3d pt1Cen = bm1.ptCen();
	setDependencyOnBeamLength(bm0);
	setDependencyOnBeamLength(bm1);
	
// Check connection. If lost delete instance
	{
		Beam bm1s[] = { bm1};
		Body bdMale(bm0.ptCen(), bm0.vecX(), bm0.vecY(), bm0.vecZ(), bm0.dL() + dEps, bm0.dW() + dEps, bm0.dH() + dEps);
		Beam bms[] = bdMale.filterGenBeamsIntersect(bm1s);
		if(bms.length() < 1)
		{
			reportMessage(TN("|Lost connection. Instance deleted|"));
			eraseInstance();
			return;		
		}
	}

	
// Vectors of bm1. vecZB1 is pointing upwards, vecYB1 is pointing to the oposite direction of bm0
	Vector3d vecXB0 = _X0, vecZB0, vecYB0;
	Vector3d vecXB1 = _X1, vecYB1, vecZB1;
	
//Check angle of bm0 to _WXY plane.
	Plane pnW(_PtW, _ZW);
	Vector3d vecX0W = vecXB0.projectVector(pnW);
	double dAngleB0 = (vecX0W.length() < dEps)? 90 : vecXB0.angleTo(vecX0W);
	vecX0W.normalize();
		
// Connection only allowed between 1° - 89°. Else tool is deleted
	if((dAngleB0 > 1 || dAngleB0) <179 && (dAngleB0 < 89 || dAngleB0 > 91))
	{
	// Declare vectors of bm0
		vecZB0 = bm0.vecD(_ZW);
		vecZB0.normalize();
		vecYB0 = vecXB0.crossProduct(vecZB0);
		vecYB0.normalize();
		
	// Declare vectors of bm1
		vecZB1 = bm1.vecD(_ZW);
		vecZB1.normalize();
		vecYB1 = vecXB1.crossProduct(vecZB1);
		
		Line ln(pt1Cen, vecXB1);
		Vector3d vecTowardsBm1(ln.closestPointTo(bm0.ptCen()) - bm0.ptCen());
		if(vecTowardsBm1.dotProduct(vecYB1) < 0)
			vecYB1 *= -1;
		vecYB1.normalize();
				
	// Define the dimension of bm0
		double dBm0Width = bm0.dD(vecYB0);
		double dBm0Height = bm0.dD(vecZB0);
		
	// Define the dimension of bm1
		double dBm1Width = bm1.dD(vecYB1);
		double dBm1Height = bm1.dD(vecZB1);
		
	// Center point of bm1 at the middle of bm0
		Point3d pt0 = Line(_Pt0, vecX0W).intersect(Plane(pt1Cen, vecYB1),0);
		Point3d ptBCCen = pt1Cen + vecXB1 * vecXB1.dotProduct(pt0 - pt1Cen);
		
	// Check angle between bm0 and bm1 in topview. If angle != 90° set dHouseDepthSide to 0.
	// Otherwise the connection cannot created at CNC machines
		double dHorAngleBm0Bm1 = (vecYB1.projectVector(pnW)).angleTo(vecX0W);
		if(abs(dHorAngleBm0Bm1) > dEps)
		{
			reportMessage(TN("|The housing at the side cannot be created for this connection. The value is set to 0|"));
			dHouseDepthSide.set(0);			
		}
			
	// Check angle, if top beamcut can be created
		Plane pnB1Side(ptBCCen - vecYB1 * 0.5 * dBm1Width, - vecYB1);
		Plane pnB0(pt0Cen, vecX0W);
		double dVertAngleBm0Bm1 = (vecZB1.projectVector(pnB0)). angleTo(vecZB0.projectVector(pnB0));
		if(abs(dVertAngleBm0Bm1) > dEps)
		{
			reportMessage(TN("|The housing at the top cannot be created for this connection. The value is set to 0|"));
			dHouseDepthTop.set(0);			
		}		
		
	//region Tools for male beam bm0
		// Cut bm0 to the outside of bm1
		Cut ct(pt1Cen + 0.5 * vecYB1 * dBm1Width, vecYB1);
		if(sNoYes.find(sCutMaleBeam,-1) == 1)
		{
			bm0.addTool(ct, _kStretchOnInsert);			
		}
	
	// Calculate length of beamcut
		Point3d ptBC =  ptBCCen- 0.5 * vecYB1 * dBm1Width + 0.5 * vecZB1 * dBm1Height;
		ptBC += vecYB1 * dHouseDepthSide - vecZB1 * dHouseDepthTop; 
		double dAngleB0Sin = vecXB1.angleTo(vecX0W);
		double dBCLength =  (dBm0Width + 0.5* dBm1Width) / sin(dAngleB0Sin);
			
	// Cut is oversized to prevent leftover pieces at oposite side
		BeamCut bc(ptBC, vecXB1, vecYB1, vecZB1, dBCLength + dEps, U(10000), U(10000),0,1,-1);
		bm0.addTool(bc);
			
	//region Get the point for the horizontal cut of bm0
		Line lnBottomBm0(pt0Cen - vecZB0 * 0.5 * dBm0Height, vecXB0);
		Point3d ptBottomCut = lnBottomBm0.intersect(pnB1Side,0); 		ptBottomCut.vis(3);	
		ptBottomCut += vecZB1 * dVertOffsetHouse;		
	//End Get the point for the horizontal cut of bm0//endregion 	
		
	//End Tools for male beam bm0//endregion 	

	// Add the bottom cut to bm0
		Cut ctBottom(ptBottomCut, - vecZB1);
		bm0.addTool(ctBottom);
		
	//region Tools for female beam bm1
		if(dHouseDepthTop > dEps)
		{
			Point3d ptTopBC = ptBCCen + vecZB1 * (0.5 * dBm1Height - dHouseDepthTop);ptTopBC.vis(4);
			double dBCL = (dBm1Width + 0.5*dBm0Width + dEps) / cos(dHorAngleBm0Bm1);
			BeamCut bcTopB1(ptTopBC, vecYB0, vecX0W, vecZB1, dBm0Width + 2 * dGapAtSide, dBCL, dHouseDepthTop + U(500), 0, 0, 1);
			bm1.addTool(bcTopB1);			
		}
		
		if(dHouseDepthSide > dEps)
		{
			Point3d ptSideBC = ptBottomCut - vecZB1 * dGapAtBottom;
			ptSideBC = pnB1Side.closestPointTo(ptSideBC);
			BeamCut bcSideB1(ptSideBC - vecYB1*dEps, vecZB1, vecYB0, vecYB1, dBm1Height, dBm0Width + 2 * dGapAtSide, dHouseDepthSide + dEps, 1, 0, 1);
			bm1.addTool(bcSideB1);			
		}
			
	//End Tools for female beam bm1//endregion 
	
	// Draw symbol
		Display dp(-1);
		Point3d ptPl = ptBCCen + vecZB1 * 0.5 * dBm1Height + vecYB1 * 0.5 * dBm1Width;
		PLine plSymbol (ptPl, ptPl - vecYB1 * dBm1Width, ptPl - vecYB1 * dBm1Width - vecZB1 * dHouseDepthTop);
		plSymbol.close();
		dp.draw(plSymbol);
	}
	else // Angle between tools is not supported
	{
		reportMessage(TN("|Beams should be in an angle of 1°-89°. Tool will be deleted|"));
		eraseInstance();		
	}
	

	
	
	
	
	
	
		
		
	
	
	
	
	
	
	
	
	
	



	
	
#End
#BeginThumbnail
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
MO[I.>AS7M?6N5\5^%M/\7Z%+INIIP?FBF4?-"_9A_AW'%<;\//&=_P"'==_X
M0'QNY2YA81Z=>.?EG3HBY[Y_A/\`P$\@"NNG/F1SSC8]<HHHK0@****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`KQ?X\_\A_PO_UZW_\`Z%:U[17B_P`>?^0_X7_Z];__`-"M
M:`/:****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`KC/B1\/[3QQH94!8]1MP6MI\<Y_NGV-=G12>H'S]X
M.\2W#7,GASQ"&AU:R)C'F=9@OUZMCGW'/K78U+\5OAXVO6ZZ]H`,.MV0WJ8^
M#,!SCZCM7+>#O%2^(K%XKI?)U*U^6XA(QGMN`_F.Q_#/'5IVU1U4YWT9TE%%
M%<YJ%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`%O3
MK]]/NA(O*'AU]1_C78P3QW,*RPMN1AD&N#K1TC4SI\Q63)@<_,/3W%5%V$T=
M?12(ZR('0AE89!'<4M:$!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%<KX\\#VOC31Q'D6^HV^7L[H<
M%&]">NT_IU[5U5%--IW0-7.%^&'Q`NM5FE\*^+$:W\1:>"I\S@W"KW]-P')]
M1\PSSCTJO-/B/X&EUV&/6_#Q-MXBT_#V\L;;3,`<["?7T)[\'@\:GPT^(,?C
M32Y+>^3[+K=C\EY;%=N>V]0>V1@C^$\>A/7"7,CFE'E9V]%%%62%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!7B_QY_Y#_A?_KUO_P#T*UKVBO%_CS_R'_"__7K?_P#H5K0![111
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!7C/Q4\"7FF:B/&GA!-EQ"=UY;HOWQW;`ZCU'^%>S4C
M*&4JP!4C!![TFKC3L>-^'/$%MXCTB.\MB%?&)HLY,;]Q_@>]:M<GX[\)WOPY
M\2'Q1X<C:31KEP+RU7I'D\CZ=P>Q]CBNBTW4K75M/BO;&020RC*GN/4'T(K@
MJ0Y6=4)<R+5%%%9&@4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`;.B:M]E86UP?W+'Y6/\!_PKIZ\_KHM#U;?ML[D_-TC<]_8U<7T
M):-ZBBBK)"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`*\T^(?A*_L-2C\;^"@8M7LSNNH8QQ<QXY.W^
M(XX([CW`SZ7151DXNZ$TFK&7X%\:67CCPY'J-GB*=?DN;8MEH7]/H>H/<>^0
M.DKQ7QAHNI?#OQ-_PF_@Z(-9/QJE@O"D$\MC^Z?_`!T\\@D#U;PYXAL/%.@V
MVK:5)O@G7)4XW1MW1AV8?YXKKC)25T<S33L:E%%%4(****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*\7^//
M_(?\+_\`7K?_`/H5K7M%>+_'G_D/^%_^O6__`/0K6@#VBBBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@""]LK?4K&:SOH5FMYT*21N,A@>U?/NKZ3=?"#Q45/F3^&]2?Y&Y
M)B;_`!`_,#VKZ)K,\0:!8>)M$GTO581+!,N/=#V8'L14RBI(J+LSS^&:.X@2
M:!UDBD4,CJ<A@>A%/KA+*:^^''BEO"OB%F?3Y&S8W;#Y<$\<^F>#Z'V.:[NO
M/G%Q=CKC+F04445!04444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4H)!!!P1T-)10!U6BZK]LC\F<_OT'7^^/7ZUK5P,<CQ2+)&Q5U.01VK
MK]*U)=0M_FPLR<.O]1[5I%DM%^BBBJ)"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`:Z++&T<BJZ,"&5
MAD$'L17C]_%J'P8\6MK&E127/A/49`+FT3DV[>V>X_A/<?*>QKV*H+ZQMM2L
M9K*_A2>VG0I)&XR&!JXR<63*/,B_87]KJFGP7VGSI<6TZ!XI4.0P-6*\/T?4
M+_X->+QI&K2//X2U*4FVN6R?LK'U^G`8=Q\P[BO;HY$EC62)E='`964Y#`]"
M#76FFKHYVK#J***8@HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"O%_CS_R'_"__`%ZW_P#Z%:U[17B_QY_Y#_A?
M_KUO_P#T*UH`]HHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`.;\<^"['QMX?DL+Q
M0DZ@M;3XYB?M^'J*\>\*:S?Z3JLOA+Q4IAU"U.V!W/\`K5[#/?CH>X]QS]"U
MP?Q0^'J>,](6YT[$&M6?SV\PX,@'.PG^1[&LYP4D7&3BS+HKEO!OB>34XY-+
MU@&'6+,E)HW&TN`<;L>OK^?>NIK@E%Q=F=:::N@HHHJ1A1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!4MM<R6DZS0MAE_7V-144P.WL;V.
M^M5ECX/1ES]T^E6:XFPOI+"Z$L?*]'7^\*[*WN([F!986W(PXK1.Y#1)1113
M$%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110!F^(-!L?$VAW&EZI'O@G7`88W1MV=3V(_SQ7GG@7Q'J/P
M^\2#P-XRF#6,A_XE=^W"X)X7)_A/_CIXY!!'JM<]XU\'V7C3P])I]WB.9?GM
MK@+EH7]?H>A'<>^"-(3Y61.-SL:*\L^&?C2^L]0?P/XV8Q:Q:';:32'BYC`X
M&[N<<@]Q[@Y]3KK.<****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`KQ?X\_\`(?\`"_\`UZW_`/Z%:U[17B_QY_Y#
M_A?_`*];_P#]"M:`/:****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`\I^*WP
M\GO9U\6^%5,6LVF'FCC'_'PJ]\=V`X]QQ63X4\3VWB?2Q-'B.YCPL\.?N'U'
ML>W_`-:O;*\0^)?@NY\(:R?&_A.']PS'^T;11\H!/+8_ND]?0X/TQJ4^9&D)
M\K-^BJ&BZQ:Z]I45_8MF.08*GJC#JI]Q5^N%JVAU[A1112`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*T-)U)M/N,/DPO]]?3WK/HI@=
M^CK)&KQL&5AD$=Z6N6T35OLC?9[@_N6/#'^`_P"%=3UK1.Y`4444Q!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`<9\1?`:>,--CN+&3[-K5C\]G<*VW)Z["1VR,@]CSZ@N^&/C^3Q#;
M2:'XB'V?Q'I^4N(G7:9@#C>!Z_W@._(X.!V->>?$?P-=ZC<0^*/"CM;>(=/P
MRF+@W"KV]"P'`]1\ISQC:G.VC,YQOJCU.BN2^'WCRT\<:+Y@`M]2ML)>6AZH
MW]X#KM/Z=.U=;728!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`5XO\>?^0_X7_Z];_\`]"M:]HKQ?X\_\A_PO_UZW_\`
MZ%:T`>T4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4V6))H7BF17C=2K*P
MR&!Z@BG44`?/OB[0+OX4>*/[5TF*2;PUJ#XEA4Y\AO[OM_LGOR#ZUUMK=0WM
MK'<VLBRPRJ&1U/!%>EZGIMIK&FSZ?J4"SVMPA22-AP1_C[U\_P`EI??"?Q6=
M'U61YO#]ZQ:TNF'W#[^A'1A]"*YJM.^J-J<[:,[JBD5@RAE(((R"#UI:XSI"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`KH-"U;[
MMG<GVC8_RKGZ*:=A'H%%9&BZO]K46]PW[]1\I/\`&/\`&M>M4[DA1110(***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@#RSQUX4U#PUKX\>^"5*74+%]0M$'RSIU=L=\_Q#_@0Y&:]'\(
M^+=.\9Z!%JFEOP?EFA8_-"_=3_CW'-7*\AUW1[WX4>*O^$M\+PM)H5PP74M/
MCX5`3U`[#)RI_A/'0XKHISZ,QG'JCVZBJ&BZU8^(='M]3TF<3VMPNY&'4>H(
M[$'@BK];F04444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`5XO\>?^0_X7_Z];_\`]"M:]HKQ?X\_\A_PO_UZW_\`Z%:T`>T4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%8WBOPOI_B_P_/I.J)\D@S'(
MOWHG'1E]Q^HR*V:*`/G?0KV_\&>('\&^*FPR'_0;DGY70_=`/H<<>AR/2NXK
MHOB)X!L_'>@F!]L.H0`M:7)'W&_NG_9/?\^U>7>$O$=T;R;PWXD5H-9LF,>)
M.#,%_F<<^XY]:Y*U/[2.BG/HSKZ***Y3<****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`'([12*\;%64Y!':NNTG4UU"##869/OKZ^X
MKCZEM[B2UG66%MKK^OM5)V$T=W1573[Z._M1*G#='7/W35JM"0HHHH$%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!4=Q;PW=K+;74230S(4DC<95U(P01W&*DHH`\>C:Z^"/BPR+YMSX0U:4
M!ER6:UD_Q`'_``)1ZK7MEI=P7UG%=6<R3V\R!XY$.5=2,@@UD:OI-EKNDSZ;
MJD"SVMPNUT/Z$>A!Y![&O+_#.LW?PA\3CPMXDG:7P]?2&33[YSQ"2>0?09(W
M#L3NZ$UU4YWT9A.-M4>V44`AE!4Y!Y!'>BM3,****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`KQ?X\_\`(?\`"_\`UZW_`/Z%:U[17B_Q
MY_Y#_A?_`*];_P#]"M:`/:****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`KSGXJ?#Q_$EHFMZ`/)\06`#1,AVF=1SM)_O#L?PZ'CT:B@#PSP?
MXH7Q#8/'=+Y&HVIV7$)&#GIN`]/;L>/2NCK/^*O@6[LK[_A-_"";+V#+W]NB
M\3+W?'?C[P[CGJ.8O#NOVOB/2([RU(5L8EBSDQOW'^![UPU:?*[K8ZJ<^969
MJT445@:A1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M!9L;V6PN!+%R.C+V85V5M<1W5NLT+95A^7M7"5?TK4FT^XY),+'YU_J/>J3L
M)H[&BFQR++&KQL&5AD$=Z=6A`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!6-XI\,:?XNT*73-33*M\
MT<H'S0OV9??^8R*V:*>P'F/P^\7WOA/71\/_`!HX62'":9>-PLJ'[B9/8]%/
MJ-O4`5Z]7#>/?`UEXWT0V\VV&]A!:UN<<QMZ'U4]Q^/:LSX9^/[F]NY?"/B_
M,'B&Q)C5I./M2J.N>[8Y_P!H?,.]=4)\R.>4>5GIE%%%:$!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`5XO\>?\`D/\`A?\`Z];_`/\`0K6O
M:*\7^//_`"'_``O_`->M_P#^A6M`'M%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%>$^//"5U\._$3>+/#<3/HMR^+^S3I$2>WHI)X
M/\)XZ'%>[5%=6L%]9RVMY$DT$R&.2-QE74C!!%)I-68T[,\JT[4;;5M/BO;&
M0202KE2.WL?0BK5<5K6D7/P@\5?+YL_AC4WS&_+&!O0_[0'_`'TH]1QV4,T=
MQ"DT#K)'(H9'4Y#`\@@UY]2#@SKA+F0^BBBLRPHHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`UM%U7['+Y,[?N&/!/\!]?I75`Y&1R
M*\_K>T+5MFVTN6XSB-CV]JN+Z$M'144459(4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7#?$7P*WB&
MWCUC0V-MXAT\>9:S1G:9=O(0GUST)Z'V)KN:*:;3N@:NK,Y7X:?$./QEI\EE
MJ2_9=>L1MN[9AM+8."X!]^"/X3]17=5Y-\0_"%];7Z>-?!FZ'6[+YYXHAG[2
M@X/'<XZC^(<=<9['P%XYL/'6@"]M,17<.$N[4G+0N?YJ<'![X/<$#LC)25SF
ME%Q9U%%%%42%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%>+_'G_D/
M^%_^O6__`/0K6O:*\7^//_(?\+_]>M__`.A6M`'M%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`&?KNAV'B/1;C2]6A$UM<+AA
MW4]F![$'D&O![5[_`.&_BH^%O$+M)ILS9T^]884J3Q]!G@C^$^QS7T17.^-O
M!UCXV\.2Z;?`)*`6MKC;EH),<'W'8CN/P(F45)6949.+NCD:*XSPOJVH:/J\
MWA'Q8/*U"U.VWD8\3+V`/?CD'N/<<]G7GRBXNS.N,E)704445!04444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`=/HFK?:4%M<-^^4?
M*Q/WQ_C6S7`*S(X9#AE.01V-==I.J+?P[7P)T'S#U'J*TBR6C1HHHJB0HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"O)_&>AZCX!\1#QSX,BS`Q/]JV*\*RD\M@=CW_`+IP>F<>L4CH
MLB,CJ&5A@J1D$>E5&3B[BE&ZL1>&/$FG^+/#]OJ^E.6AF&&1N&B<=48=B/UX
M(X(K6KP[5+>_^#?BS^W-$ADN/"VH.%O+13GR&SV]/]D_53C@U[/IFI6FL:7;
MZCILRSVMS&)(I%[@^W8^H/(/%=B::NCF::=BU1113$%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`5XO\>?^0_X7_P"O6_\`_0K6O:*\7^//_(?\+_\`7K?_
M`/H5K0![11110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`</\3?A]'XUT=)K$K!K5E\]I.#MW=_+8^A/(/8\^N?/_!_B674
MDETK6E,&M6),<\3KM+X.-V/7U]_K7O%>7?%3X>3ZE*OBSPJICURR`>1(QS=(
MH].[`<8_B''I6=2"FBX2<6+16'X5\3VWB?2Q/%B.XCPL\.>4;U^A['_"MRO/
M::=F=:=U=!1112&%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%203R6TZRPMM=3P:CHI@=KIVH1ZA;[TX=>'3^Z?\`"K=</97LMC<"6(^S
M+V8>E=E:W4=Y;+-"<JW8]0?2M$[D-$U%%%,04444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`$%[9V^HV4U
MG?0I/;SH4DC<9#`]J\FTZ_OO@QXO&FWQEN/"&IRY@F)W&U8]<^X[CN/F'((K
MV"L_7-#L/$6CSZ9JL(EMYEP?53V93V(]:N$^5DRCS(WHY$FB26%UDC=0RNIR
M&!Z$'N*=7B_@GQ%J7PX\3)X(\82^9ILS'^S-0;A5!/`.>BD\8_A;V.1[176G
M<YM@HHHI@%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7B_QY_P"0_P"%_P#KUO\`
M_P!"M:]HKQ?X\_\`(?\`"_\`UZW_`/Z%:T`>T4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!XK\3/!MUX3U9O&_
MA*+]TS9U.S0?*0>LF/0GKZ'YNF<6]%UBUUW2HK^Q;,<@Y4]48=5/N*]==%EC
M9)%5T8$,K#((/8BO!/%WAZY^%7BC^U](B>3PQJ$@$\(.?LSGM_53WY4]B<*M
M/F5UN:TY\KLSK:*BMKF&]M8[FUD66&50R.IX(J6N(Z@HHHI`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%7=,U)]/N,\M$WWT]?<>]4J*
M8'?1R)+&LD;!D89!'>G5RFC:J;*80S']PYYS_`?6NK!!`(.0>A%:)W(84444
MQ!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`8'C+PE8^,O#\NG7H"28+6]QMRT,F.&'J/4=Q^=<Q\-/&
M>H:;JK^!?&[>7J=KA;*X=LBY3LN3U./NGN.#R.?1JX_XB>!8_&.D(]HXMM7L
MSYEG<C@Y'.PGK@GOV.#Z@ZTY\NC(G&^IZ!17G?PP\?3Z]%-X?\3#[-XCTXE)
M4?@W"C^/']X=P/J.#@>B5U'.%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7B_P`>
M?^0_X7_Z];__`-"M:]6USQ#I/AK3VO=<OH;.`<`R-RY]%7JQ]@":^=?'GQ%M
M_'WC&P33[-X+/3[:Y$4LK?/-O:')*_P_<X&3_2@#Z<HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`JMJ.GVFK:=
M/8:C`EQ:W"%)8W'#`_YZ]JLT4`?/$UE>_"?Q5_9.IRO/X=OF+6=VP_U9ST/H
M1_$/HPQR*[96#*&4@@C(([UW/BKPQI_B_P`/SZ3JT>Z*3YHY`/FA<='4]B,_
MB"0>":\2T6[OO!?B!O!GBE@&0C[#=$_+*A/R@$]CC`]""O:N:M3O[R-Z<^C.
MUHHHKC.@****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"MW0M6\LBTN6^0_ZMCV]JPJ*:=A'H%%8NAZMYZ"UN6_>J/D8_Q#T^M;5:IW
M)"BBB@04444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`'GWQ(\#W6JO!XD\+NUMXAT[YT:/`-PH_A_WAVSP
M02#VQT'PX\>P>-M#S.%M]7M?DO;7D;6Z;@#SM/Z'([9/0UY;X_\`">I:%K@\
M>>""8[^#YKZU496=.[;>^0/F'?[PP1D[TYVT9E./5'L5%8/@[Q?IWC3P_%J>
MFM@_=G@8_-"_=3_0]Q6]708A1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`445P'C;XO\`A_P@9+2%_P"T
M]348^S0-\L9_VWZ#Z#)]J`.\GGBMH'FN94ABC&YY)&"JH]23TKR/Q=\<X([@
MZ7X#M6U:_=MBW!C9HP?1%'S.?T[\BN:31?'WQ<N4NM?N&TG0RVY(2"B[?]B/
MJY_VG]>#VKU+PKX%T+P?;;-)M!Y[#$EU+\TLGX]A[#`K.511+C!L\XT;X4Z_
MXNOUUKXE:E<;FY%H'!D(]"1\L8_V5&?H:B^+&C:=H-_X6L='LX[2V2UOL)&.
MOS6W)/4GW.37MU>/_&[_`)#_`(:_Z];[_P!"MJRC)RFKFDHI1T/<****Z3`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHKYZ_:KUG4]+A\+Q:9J-W9QSF[,R6\[1B0KY.W<`1G&XX
MSTR?6@#Z%HKX^\%?`3Q!\1/"5GXC;Q#;0P7?F>4DXDDD&V1D.>PR4SP35S6?
M@M\3_A]:/JOAW69+N"V&]O[+NI$E51W\LXR,=@3WXH`^M:*\"^!OQTO?%&JQ
M^%O&#I)?R*?L=\JA?.*C)1P.-V`2",9QCKU]]H`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"N3^(7@.S\=Z`;:7;#?09:TN2/\`5MZ'_9.!D?0]JZRB
M@#P+PCXBO'NYO#GB6)[?6K'*,LG64#OGH3CG(ZCD9KK:N_%+X>OXELTUK0!Y
M/B&P`:%T.TSJ.=A/K_=/X'@Y'(>$/$X\0V#QW2>1J5J=ES`1@Y'&X#KCV['C
MTSQ5J?+[R.FG.^C.BHHHKG-@HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`56*L&4D$'(([5UNCZH+Z'RY#B=!\W^T/6N1I\,SP3++
M$VUT.0:I.PF=[15/3=0CU"WWK\LB\.GH?\*N5H2%%%%`@HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`/
M(?$FC:A\+_%1\9>%(VDTBX<?VIIZ_=4$\D#L.<@_PG_9.*]>T/7+#Q'HUOJF
MDSB:VG7*GNI[J1V(/!%,EBCGA>&=%DCD4JZ,,A@>""/2O(`EY\%/%QNH/.N?
M!^IR;98P2QM7/0_4#H?XAP>0#733G?1F,XVU1[E14-G>6^H64-W93)/;SH'C
ME0Y5E/0BIJV,@HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`***J:GJMAHM@][JUW#9VT?WI9G"CZ>Y]NIH`MUS_BOQOH7@VR\
M_6[P)(REH[:/#32_[J_U.![UYAXC^-.J:_?G1?AKITTTLG'VQHMSD="53HH'
M'S-^0ZT[PO\`!8RW?]K>/KU]2O)"':W\UF!/_320G+GV''N:F4E'<I1;V,R]
M\:>.?BO<RZ?X1MFTG20VR6<2%>/]N4<\C^%1WYR*Z_P9\(-#\,".ZU!5U745
M.1+,G[N,]MJ'(R/4Y/<8KO+6UM[*UCMK."."")=J11*%51Z`#@5+7-*HY&T8
M)!1116985X_\;O\`D/\`AK_KUOO_`$*VKV"O'_C=_P`A_P`-?]>M]_Z%;5I3
M^)$S^$]PHHHKK.8****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`KYN_:Y_P"91_[??_:%?2-?-W[7/_,H
M_P#;[_[0H`](_9\_Y(3X>_[>?_2F6O22<=:^//`O[0VI^!O!=CX=M="M+N*S
M\S;-),RLV^1GY`]VQ^%5O&7[1'C#Q;ITVFP?9='LIU*2BS5O,=3U4N23@_[(
M'I0!0\*0IJ'[2MI_PC>/LG_"1/-!Y0R/LZS%SC';RP?PK[;KPO\`9U\(>#=.
MLI=8TG7;;7-=DCV3%%*&T0XRJQMAN3_&0,]!CG/NE`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%>0_%7P+>6FH?\`";^$%V7UN-U];(O$Z#J^
M!U./O#N!D8(Y]>HHW`\;\/Z]:>(M*2]LS@])(R>8V[@_X]ZU*YKQ[X3N/AUX
MA;Q=X<B9M%N9,:A9J>(BQZCT4D\>A..AQ6YIVH6VJZ?%>V,@E@E7*L/Y'T(]
M*X*E/D?D=<)\R+-%%%8F@4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`3V=W)97*S1=1P0?XAZ5V5G=Q7MNLT)X/!'=3Z&N&J[INHR
M:?<;AEHV^^GK_P#7JD[":.SHID,J3PK+$VY&&0:?6A`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!53
M5=+L];TJXT[4X%GM;A-LD;=_0CT(."#V(!JW10!Y%X<U2\^#WBC_`(1[Q!-)
M-X9OW+6-Z_2W;/.?3J-PZ?Q#J<^V*P=0R$,K#((.017,^)_#.G^+-"FTO5(]
MT;_-'(!\T3CHZGU&?Q!(Z&N&\`>*KWP5KR^`/&<@`7']EWK'Y9$).U,GL<$+
MZ$;?2NNG/F5F<\XV/8****T("BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`*1F5$+.P55&22<`"N/\9_$_P]X+1HKN?[7J&,K96YR_\`P(]$
M'UY]`:\K9_B#\8I?WI_L?P^QX`!6-AV_VI3_`..Y':DVEN-)O8['QE\<=)TA
MFL/"J+K6HD[%D3)@5NW(Y?Z+Q[UREA\.O%GQ$OX]8^(6H3VEOUCML`2JI[*G
M2/MU!/'([UZ'X0^&^@>#E$EE`;F^QAKRX^9_^`CHH^G/J3765A*KV-8T^YF:
M#X<TGPS8"ST6RCM8^-Q49:0^K-U)^M:=%%8&H4444`%%%%`!7C_QN_Y#_AK_
M`*];[_T*VKV"O'_C=_R'_#7_`%ZWW_H5M6E/XD3/X3W"BBBNLY@HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"OF[]KG_F4?^WW_`-H5](U\W?M<_P#,H_\`;[_[0H`](_9\_P"2$^'O
M^WG_`-*9:ZWQ#X*\-^*K5X/$&BV=Z'!'F21#S%SW5Q\RGW!KDOV?/^2$^'O^
MWG_TIEKT:66."%Y9Y%CC12SN[8"@=22>@H`^)_&6CZE\$/B^/^$?O9`(-EU9
M2N>9(6)^1P.HR&4^N,\=OLO0-7BU_P`-Z;K%NNV*_M8[E%)SM#J&Q]1G%?&_
MQN\66_Q!^*[2>'\W=O!%'I]H\:Y-P0S'*COEW8#U&/6OK[P=HS^'O!&BZ/-S
M+8V,,$A!SEU0!OUS0!M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110!%=6T%[:2VMW$DT$R%)(W&5=2,$$>E>`ZWI-Q\(?%`"^9/X7U.0F-L
M%C;OZ$^H'_?2CU!KZ#JAKFB6'B+1KC2]6A$UK<+M9>X/9@>Q!Y!I2BI*S&FT
M[H\[BECGA2:%UDCD4,CJ<A@>00:?7$69U#X<^*3X5\0L7TZ9BVG7K?=*D\9/
M;T(_A/L<UV]>?.#@[,[(R4E<****S*"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@#3T?538S".4Y@<\_[)]:ZT$,H*G(/(([UY_6W
MH>K>2RVERW[MC\C$_=/I]*N+Z$M'2T4459(4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%->18UW.P4>]`#
MJY7Q_P"#M.\8Z";:\98+N'+6ESC)C;T]U.!D?0]0*V9]2)R(!C_:-46=G;<Y
M)/J:7-9Z#M?<R_@MXKO_`!1X);^U3YL^GS?9A.6):50H(+>K<XSWQGK7H=>2
M?L]H(O"^LQKDA-2*C/LBUZW7H'&%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%0W=Y;:?9R75]/';V\2[I)97"JH]237C_BGXY/=7W]C?#RQ>_O)&\M+M
MXR03_P!,X^K=^6P..A'-`'I_B/Q5HWA33_MFNWT=M&>$7[SR'T51R?Z=\5XW
MJOQ*\8?$:]?2OA]83V%EG$EUD"3:>[/TC]<*=W'!/2IM!^#^IZ]J(UKXD:C-
M<S2<FT$I9SZ!G_A`Y^5?P(Z5ZWIVFV6D6*6>F6L-I;1_=BA0*H]^._OWK&55
M+8TC3;W///"'P7TG22M[XF*ZQJ#?,RODP*QZ\'[_`-6_(5Z8JA5"J``!@`#I
M2T5@Y-[FR26P4445(PHHHH`****`"BBB@`KQ_P"-W_(?\-?]>M]_Z%;5[!7C
M_P`;O^0_X:_Z];[_`-"MJTI_$B9_">X4445UG,%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5XS^T'\
M-O$?Q!CT!O#%O#.=/^T><LDRQGY_*VXSP?N&O9J*`/D[2/`GQ_\`#6G)IFA+
M=V]C"3Y<46I6VQ<DL=H9^,DD_C5F[^#OQH\8L(?%&M[;<G)2]U,O&.^0D>X9
M_#M7U110!Y)\,?@#HO@.^CU?4KDZQK$8_=2-'LBMSZHO)+?[1/T`KUNBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`Y[QMX.L?
M&WAR;3;X!)<%K:XVY:"3'##U'J.X_.O'_#&K:AH^K3>$?%@\K4;4[;>1CD3I
MVP>_'(/<>XY^@:X?XF_#V/QMI*3V3"WUJQ!:TG!V[N^QCZ$C@]CSW.8G!35F
M5&3B[F/17,^$?$LFII+I>L(UOK-B3'<12#:SXX+8]?4?XUTU>?*+B[,[$TU=
M!1114C"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#
MI-"U;S5%K<M\X_U;'^(>GUK<K@`2K`J2"#D$=JZS1M4%[#Y4Q_?H.?\`:'K6
MD7T):-.BBBJ)"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHH)`&2<#U-`!2,P126(`'<U3GU%$R(1O/J>E4)9I)FS(Q/MZ4KCL7
M9]2`X@&?]HU0DD>5MTC%C[TVBI&%%%%`SEOV?_\`D7=<_P"PFW_H"UZS7DW[
M/_\`R+^N?]A-O_0%KUFO2.$****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBN8\7?$'P_
MX+@/]K7@:Z*Y2SAPTS^GR_PCW.!0!T]>;^-OC1H/A?S+32RNKZDORF.%_P!U
M&?\`:<9Y'H,GL<5PEUKWCSXP326FCP?V1H#$H[Y*HZ]P\G5S_LKQZCO7=^#/
MA5H7A'9<,G]HZDN#]JG480_["]%^O)]ZB4U$N,&SA+?PGXX^*UU'J'C&\?3-
M+#;HK<QE>/\`8B/3(_B;GZBO6/#7@_1/"5IY&BV:Q,PQ).WS2R?[S=?PZ>U;
M=%<TIN1M&*04445!04444`%%%%`!1110`4444`%%%%`!7C_QN_Y#_AK_`*];
M[_T*VKV"O'_C=_R'_#7_`%ZWW_H5M6E/XD3/X3W"BBBNLY@HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***;)(D,;22NJ(HRS,<`
M?C0`ZBL:[\4Z?;DK"SW+#(_=#Y1_P(\$>XS7*?V]\0O$<TL>@:3I6C6JOM^U
M7USY[D>JJG3Z,*E2BW9,?*TKGHE9FI>)-$T;/]K:O969'\,]PJM^1.37(#X:
MZMJV6\7^-M6OPQR;>RQ:Q?0A<Y_2M33/A9X+TK!@T"VF?J7NLSDGU^<D50BG
M<_&3P9%+Y-I?SZA-_P`\[.UD<GZ'`!_.H/\`A:%[=MC1_`GB2Y!&0\]MY"'_
M`($<BN[MK.VLHO*L[>*WC_N1(%'Y"IJ`.`_X2SXA77_'I\/4@7LUSJL?\L`T
M?VG\5)?]7H&@0>TMT[?^@FN_HH`\]DNOBXL9:/3_``JQ'\&^;)_\>`JI)JOQ
ME3[N@>'9/]V1OZRBO3:*`/+D\0?&-'_?>#M(E7OY=RJ_SF-/F^)/C6P(CO\`
MX97\CCAGM;DRJ?IMC;^=>G44`>8R?''2]/*Q>(/#NO:5<'[R36HPOXE@3^5;
M>G_%OP/J4J1PZ_!$[#.+E'A"^Q9P%_6NSK$U'P7X9U82_P!HZ!ITSR_?E-LH
MD/\`P,#</SH`T['4;+4[;[1IMY;WD&<>;;RK(N?3(.*L5YQ>_`[PI)<)<:.^
MH:+<1CY'LKH\-V;Y]Q_(BJO_``BOQ.\-[6T#Q=!KL"9=K?58R'<_W0QW'_Q]
M:`/4:*\M/Q6UWPYA/B!X,O;)%`#WM@1+"6/0==HX_P!LGVKLO#WCOPUXIVKH
MFKV\\S9Q;L?+EX&3\C88@>H&*`.@HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`/+OBK\/IK]QXN\+*8M<L0))4C'-TBCT'5@.,?Q#CGBL7PMXFMO
M$^EBXAPEQ'A9X<\HW^!['_"O:Z\6^)G@^Z\)ZLWC?PE"?*9LZG9H/E(/63'H
M3U]#SZXRJ4^=>9I"?*S9HJCHVKVNNZ5#?V+9CD'*G[R,.JGW%7JX'H=84444
M@"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"GQ2O#*LD3%
M74Y!':F44`=IINHIJ%ON&%D7AT]/?Z5<KAK2ZDL[E9HCRO4=B/0UV5G>17UN
M)83QT([J?2M$[D-$]%%%4(****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HJM/?10Y`.]O0?XUGS7<L_WCA?[HI7'8O3ZA''Q'^\;VZ5GS7$DY^=N
M/0=*BHJ;C"BBB@84444`%%%%`'*_`#_D`:[_`-A-O_017K5>2_`#_D`Z]_V$
MV_\`017K5>D<(4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!113)98X(7EGD6.-!N9W.`H]23TH`?5#6
M==TSP]ISWVM7L5G;)U>0]?8`<L?8`FO,O%WQTLK:8Z9X)MFU>_9BBS["8@W3
MY0.9#],#T)K`TCX6^)/&>H+K/Q)U*=5/*VH<>9CTP/EC7V'/L#4RDH[C2;V)
MM=^+WB+QAJ#:-\--.G16R&NV0&4CU&?EC7KRW/(^Z:O^%O@I;0W`U/QK=-JU
M^YWM"78QAO\`:8\N?K@>H->C:-H6E^'K`6>BV45G`.2L:\L<8RQZL?<DFM"N
M>51O8VC32W&111P0K%!&L<:#"HBX"CT`'2GT45D:!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`5X_P#&[_D/^&O^O6^_]"MJ]@KQ_P"-W_(?\-?]>M]_
MZ%;5I3^)$S^$]PHHHKK.8****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHJ&ZNX+*`S74JQH.Y[]\`=SQT%`$U5[S4+6PC#W<ZQ`]`>2WT`Y/7M7
M,ZCXLFE)CTY/)3_GJX!8_0=!^.>O:N?=WED,DKL[MU9R23]2:YYUTM(FT:3>
MYT5[XOE?*Z?`(EZ>9+RWX`<#]?I6!<W5Q>2![N9YF!R-YSCZ#H/PJ*BN:524
MMS>,5'8*FM;J:SG$UM(4<=QW]C4-%1L4=KI/B2"]VQ76(9^G)^5S[>GTK;KR
M^MW2?$DUGMAO-TT'9B<LG^(KJIU^DCGE2ZQ.SHJ*VN8;N!9K:02(W<5+748!
M7,V_B>YF^)MWX;:&(6T-@+E91G>6W*"#SC&&].U)XFU7Q;97\47AGP[#J-N8
M]SSR72IALGY=I(/`&<\YS[5YS;:MXR7XKWEU'X=MVUAM."269N5VK%N3Y]V[
M&<@<9[UWX?#<\9-M;=T<5?$<DDDGOV9[;17GW_"0_$O_`*$RS_\``U/_`(NC
M_A(?B7_T)EG_`.!J?_%UE]5E_-'_`,"7^9I]9C_*_P#P%_Y'7>)-5DT3PSJ&
MIPQK+):P-(J.>"0.,TOAW4WUKPWI^I2QK')=6Z2LBG(!(R<>U><^*];\?3^$
M]2BU3PK:VMF]NPFF6[1BB]R`'.:D\)ZWX]A\,Z5#I_A6UN+%;>-8IWO$4NF.
M&(W9''M^%;_5/W-[J]^Z[>IC]:_?6L[6[/N>J4445YQWA1110`5QOB'X4>$/
M$09Y]+2RN".+BP_<N#G.<#Y2?=@37944`>5GPY\2?!0!\,ZU'XFT]?\`EQU(
M8E4=,*Q/(``_B`S_``UHZ+\8M&N;[^S?%%I<^&=3&-T&H*0G/3YR!CC!RP4<
M]37H=9FN>'-'\2V7V37=/@O8AG;YB_,F>I5ARIXZ@B@#1CD2:)9(G5XW`964
MY#`]"#3J\HD^'WBOP-*UU\-=8:ZL]VY]&U%@4;IG:QP/_03@?>-;/AGXL:9J
MEZ-)\1V\OAW6U(5K2^!17)Y&UB!U&#AL9R,;NM`'?4444`%%%%`!1110`444
M4`%%%%`!1110`4CHLD;)(H=&!#*PR"/0BEHH`\"\6^'KOX5^*3JVE1-+X7U"
M0":%<G[*Q[?S*GN/E/0$]1;7,-Y:QW%K(LL,JAD=3PPKTS4=/M=6TV>PU&!9
M[:X0I)&XX8'_`#U[5X%)97GPH\4'2-4DDG\/WSEK*[;I&?1O0\C(^C#J:YZU
M/F]Y;FU.=M&=M12`AE!4@@C(([TM<1TA1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`5;TZ_?3[KS%^9&X=?4?XU4HI@=Y!/'<0K+"
MVY&&0:DKD=(U0V$VR3)@<_,/[I]:ZU65T#(0RL,@CN*T3N0T+1113$%%%%`!
M1110`4444`%%%%`!1110`45%-<Q0#YVY_NCK6=/?R2Y"?(OMUI7&7Y[N*#AC
MEO[HK/GO99N,[%]!5:BE<=@HHHI#"BBB@`HHHH`****`"BBB@#E?@!_R`]>_
M[";?^@BO6J\E^`/_`"!-?_[";?\`H(KUJO2.$****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BL+Q/XRT/P?9^
M?KE\D+,,QP+\TLO^ZO4_7H.YKQV^\>>-_BC>2:;X,LY-+TS)62X#$''^W+CY
M<@@[5YZ]:+V#<]$\;?%K0/!N^V#_`-HZFN1]DMW'R'_IHW1?IR?:O-?[.\??
M&*1+C59_[(T%CNC3!$;#L5CSF0]/F8@>A[5V/@WX.Z)X;\NZU0+JVH+R'E3]
MU&?]E#W'J?KQ7HE82J_RFT:?<YKPGX!T'P="/[+M0]T5P]Y-AI6]>?X1[#`K
MI:**P;;W-=@HHHI`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5
MX_\`&[_D/^&O^O6^_P#0K:O8*\?^-W_(?\-?]>M]_P"A6U:4_B1,_A/<****
MZSF"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HJ.XN(K6W>:X<1QH,LQ
MKC=8\1S7^Z"UW0VQX/\`>D^OH/8?CUQ43FH+4J,7+8V=6\3PV9:&Q"W$XX+9
M^1#[^I]A[\BN2N;J>]G,UU*TLG3+=AZ`=!^%0T5Q3J2F=48*(4445D6%%%%`
M!1110`4444`6;*_N-/F\VUDVGN.H8>A%=EI.OV^I`1OB&X_N$\-]#_2N$I02
M""#@CH16L*C@1*"D>GUY]8_\G`:E_P!@8?\`H4=:>D^*'@VPZCF2/H)1RP^O
MK_/ZUDZ9+'/\?-0DA<.C:,I#*<@_/'7KX2:FIV_E?Z'F8J+BX7_F7ZGHE%%%
M8&YSOC__`))[K?\`UZ/_`"I_@3_D0-#_`.O*/_T$4SQ__P`D]UO_`*]'_E3_
M``)_R(&A_P#7E'_Z"*ZO^87_`+>_0YO^8G_MW]3?HHHKE.D****`"BBB@`HH
MHH`*P_$_@[0_&%C]FUVR28J"(IU^66(GNK#D>N.0<<@UN44`>1E?&OPH^96E
M\5>%8^JG)N;.,#_T$#ZKA?X,UZ'X9\6:/XOTP7NAW:SJ`/-B/$D)/\+KV/!]
MCC@FMFO./%/PP==1;Q%\/[K^P]<09,46%@N?4,O0$X'8J2.1DEJ`/1Z*X+P?
M\2TU74I/#_BRU&B>(X&"-;2'$<Y]8R<_@,G(((+<X[V@`HHHH`****`"BBB@
M`HHHH`****`"L;Q5X7T[Q?X?FTG58]T<GS1R`?-"XZ.I]1G\02.AK9HH`^>]
M$O+[P9X@;P9XH8!XR/L-T3\LJ$_*,GL>@]"-O85VE=)\0?`=GXYT+R'*P:A;
MY>SNL<QMZ'_9.!G\#VKR[PCXBNY;J;P]XDB>WUJQRKK)UE`[^Y_F.1GFN2M3
MM[R.BG/HSK:***Y3<****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"MK1-6^SLMK<M^Z8X1C_"?\*Q:*:=@/0**PM"U;S-MI<M\P'[M
MSW]JW:T3N0%%%%,04444`%%%%`!139)4B7=(P4>]4)]2)R(!M']X]:+C+LL\
M<*YD8#T'<UGSZB[Y$0V+Z]ZJ,Q9LL22>I-)4W'8"<G)Y-%%%(84444`%%%%`
M!1110`4444`%%%%`!1110!ROP!_Y`NO_`/83/_H(KUJO)?@%_P`@?Q!_V$S_
M`.@BO6J](X0HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BD)"J68@`#))[5Y?XU^-VD:&TEAX;5=8U/.P%,F"-O=A]_Z+],
M@T`>CZCJ=CH]C)>ZI=PVEM']Z69PJCVR>_MWKQWQ)\:]0UJ^_L;X::?+<SR?
M+]L:$LQ'JB'H/]I^!Z=ZS+'P%XQ^)%ZFJ^/]0GLK+.Z*VP%?:?[L?2/TRPW>
MH/6O6?#WA?1_"UA]DT2R2W0\N_WGD/JS'D_T[5E*HEL:1@WN>:^&O@Q-?7O]
MM?$*]EO;V8B1[42;LGTDD[_1>..I%>M6EG;:?:1VMC!';P1#:D42A54>P%34
M5SRDY;FRBEL%%%%2,****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"O'_C=_P`A_P`-?]>M]_Z%;5[!7C_QN_Y#_AK_`*];[_T*VK2G
M\2)G\)[A11176<P4444`%%%%`!1110`4444`%%%%`!1110`55U#4K?3+?S;E
MCSPJ+RSGT`INJ:E'I=D9Y%+DG:B#^)O3/8<=?_U5P5Y>3W]RT]T^YVZ8Z*/0
M#L*QJ5%#3J:0AS$NI:I<:I/YEP=J*?DB4_*G^)]_Y=*IT45Q-MN[.I))6044
M45(PHHHH`****`"BBB@`HHHH`****`"L+1M0FTWXL74\&"?[/"LI'##<G%;M
M<Q;_`/)3;O\`Z\!_Z$M=^#;2J-?RO\T<>*U=/_$OU/9M+UJVU-,1GRY@,M$Q
MY'T]:T:\Q1VC</&Q5@<@@X(KIM)\4_=AU/Z"8#_T+_&HIUD])%RI6U1-X_\`
M^2>ZW_UZ/_*G^!/^1`T/_KRC_P#014?CQUD^'6M/&P96LW(93D$8J3P)_P`B
M!H?_`%Y1_P#H(KT_^87_`+>_0X/^8G_MW]3?HHHKE.D****`"BBB@`HHHH`*
M***`"BBB@#F?&G@32/&VFF'4(_*O(U_T:^C'[R`]1]5SU4\?0X(Y+0?&^L^"
M]8@\,?$PC9)\ECKF?W<X'`$C>O0%CR,@MUW5ZG67XB\.Z;XIT672]9MQ-;R<
M@]&C;LZGLPSU^H.02*`-2BO(M)U_5_A1J\'AWQC,]YX=F.S3M6()\D=D?V`[
M=ATR.GK:2)+&LD3*Z,`RLIR"#T(-`#J***`"BBB@`HHHH`****`"BBB@`KSK
MXJ?#Z3Q):1ZWX>`A\0:?\T;+P;A!_!G^]Z$_0\'(]%HH`\/\(^)U\0Z>RW"B
M#4;8[+F`C!!'&X`]CZ=CQ7051^*G@6]L]1_X3?P@NV]@&Z^MD7B91U?`ZG'W
MAW`R,$<Q:!KUIXBTI+VS.,\21D_-&W<'_/-<-6GRNZV.JG/F5F:=%%%8&H44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`*"000<$="
M*ZK1=5^VQ>3.1YZ#_OL>OUKE*='(\,BR1L5=3D$=J:=A,[ZBJ.EZDNH6V3A9
MEX=1_,>U7JU)"BD+!5)8@`=2:ISZBJY$(W'^\>E`%QW5%W.0H]35&?4NH@'_
M``(U1DE>5MTC%C_*F5-QV'.[2-N=BQ]33:**0PHHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`.5^`7_((\0?]A,_^@BO6J\E^`7_()\0_]A(_^@UZ
MU7I'"%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%9>O^
M)=(\+Z>;W7+Z*TAYV[C\TA]%4<L?I0!J5R/C+XE^'_!43)?W'VB^QE+*W(:0
M^A;LH]S^`->9ZK\4O%?Q!O9-'^'FGSV5N1B2Z)`F"GN6'$7?H2>.#VK:\(?!
M;3=+D%_XJD76-09MYC8$PJQZY!YD.<\MQ[=ZB4U'<J,6SFIKOX@?&*8K"/[&
M\/L<$;BL;#OD_>E/M]W([5Z+X0^&7A_P@J36\'VS4%ZWEP`6!_V!T3J>G/J3
M77JJH@1%"JHP%`P`*6N>51R-XP2"BBBLR@HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`KQ_P"-W_(?\-?]>M]_Z%;5
M[!7C_P`;O^0_X:_Z];[_`-"MJTI_$B9_">X4445UG,%%%%`!1110`4444`%%
M%%`!1110`53U/4X=+M#-+\S'A(P>7/\`A[U->7<5C:/<7!PB#MU)[`>]>?ZC
MJ$VIWC7$_'9$!X1?3_$]_P!*RJ5.1>9I"',R.[NYKZZ:XN7W2-^2CL`.P_SU
MJ&BBN!MMW9U;!1112&%%%%`!1110`4444`%%%%`!1110`4444`%<Q;_\E-N_
M^O`?^A+73US%O_R4V[_Z\!_Z$M=V$VJ_X7^:./%;T_\`$OU.GHHHKA.PJZ]J
M5S;^#=5ME?,,MLZE#T&1U'I7:?#V]@N?`ND112`R16D:NG<<?RK@?$W_`"+&
MH?\`7!JD\+2R0>'],EA<HZP(0RGD<5Z<*CC@_P#M[]#@E!2Q7_;OZGL%%<[I
M/BB.?;#J.(I.TO13]?3^5=$#D9'(HC)25T5*+B]0HHHJB0HHHH`****`"BBB
M@`HHHH`****`*&MZ)8>(=(GTS5[=;BUG7#*>H/8@]B.QKS'P]J]]\*O$4?A3
MQ7<M+X?NF/\`96J2?=AY_P!6Y[#GG^[G/W3QZ[67XC\.:;XJT.?2M8A\VWE'
M!'#1MV=3V8?_`%CD$B@#4HKRSP+K]]X/\1GX?^,+G>4'_$GOI!@7$?18\]CV
M`)X(*Y^[GU.@`HHHH`****`"BBB@`HHHH`****`"O"?'7A.;X;:\WBKPW#NT
M.Y<+?62<+`2>"!V4D\>A..AQ7NU175K!?6<MK>1)-!,A22-QE74C!!%)I-68
MT[.Z/*]/U"VU33XKVQD$L$RY5A_(^A'3%6:XO6=+N?A#XJ\L"6?PMJ3[HI,;
MC;OW4^X`'^\O3)!QV4<B2QK)$P='`964Y!!Z$5P5(.#.N$N9#J***R+"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@"6VN9;2X6:%L
M,OY'V-=4FKQ2VRR0J2S#D'^$UR%:^G_\>:_4U28B[+/),V9&)]!V%1T44P"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBD9@JEF(``R2
M3TH`Y;X!_P#(*\0_]A,_^@UZU7DGP!97TGQ"R$,K:D2"#D$;:];KTCA"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*BNKJWLK62YO9X[>")=TDL
MKA50>I)X%<!XU^,OA_PKYEK8NNK:DN5,-N_[N,_[;]!@]AD^N*\_A\->.OBU
M=QWOBRX;2](5M\4/E[1_VSB)ST_B?L>,TFTMQI-['0>+/CF&NO[)^']DVIWL
MA*+<F-F7/I'&!ESUYX'L169HOPBU?Q-J`UOXD:G-)-)@_94?+D=0K-T0=?E7
MUZBO2?"_@O1/"%IY.C6@60KB2YDPTLOU;^@P/:MZN>55O8VC32W*FF:78Z-8
MI9:5:16ELGW8XEP/K[GWZU;HHK$T"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*\?\`C=_R'_#7_7K?
M?^A6U>P5X_\`&[_D/^&O^O6^_P#0K:M*?Q(F?PGN%%%%=9S!1110`4444`%%
M%%`!1110`4C,%4LQ``&23VI:YCQ5JVT'3K=L$C,Y!['HOX]3[8ZYJ9245=E1
MBY.QE:[JYU2\Q&6%M$?W:GC<?[Q'\O;TR:RZ**\Z4G)W9V))*R"BBBI&%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!7,6_\`R4V[_P"O`?\`H2UT]<Q;
M_P#)3;O_`*\!_P"A+7=A-JO^%_FCCQ6]/_$OU.GHHHKA.PR_$W_(L:A_UP:E
M\.?\BSIW_7NG\J3Q-_R+&H?]<&I?#G_(LZ=_U[I_*N[_`)@O^WOT./\`YB_^
MW?U-.M;2=?N--(C?,UO_`'">5^A_I6317'&3B[HZVDU9GI%E?V^H0>;:R!AW
M'0K]15BO-+:ZFLYA-;2&-QW%=?I/B2&]VQ7>(9^@.?E<^WI]*[*=92T>YS3I
MM:HW****W,@HHHH`****`"BBB@`HHHH`****`.8\?>"[;QMX=>S?;#?0GS+*
MZ/6&3ZCG:<8(^AZ@5F?#7QE=:Y;W6A>(XQ;^(M'/E74;,,S*.!*/7MDC(R01
MPP%=U7FOQ/\`#EW9W-MX\\+1HFL:1\]R@!_TJ`=0P'7`SZ$J3SPM`'I5%9/A
MCQ%9>*O#MKJ^FN#%.F63/,3_`,2'W!X]^HX(K6H`****`"BBB@`HHHH`****
M`"BBB@#/UW0[#Q'HMQI>K0B:VN%PP[J>S`]B#R#7A-DVH?#OQ2?"GB)B^GRL
M3IUZ?NE2>!GMZ$?PGV.:^AJYSQQX-LO&_AN73;S$4P^>VN0N6AD['W!Z$=QZ
M'!$RBI*S*C)Q=T<E17'^&-6O])U27PEXK!BU.T.V"1CQ.G;![\<@]Q[BNPKS
MY1<79G7&2DKH****@H****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`*U]/\`^/-?J:R*U]/_`./-?J::`LT4450@HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BN=\2^.=$\+H5OKGS+K&5M8?FD/U_NCZUSEKI
M7Q`^)8#,/^$7T*3NP/FRK].&;_QQ2#WK2-.4B)3436\2_$G1O#\IM("VI:CG
M:MK;<X8]`S=!SQ@9/M6?9>"?&_Q$83^++EO#^CL<K8Q#$LB^Z]1_P/\`[YKT
M3PA\-_#O@R-6TVT$MYC#7MQAI3ZX/11[#'XUU==,:<8G/*;9C>&/"FD>$-+^
MP:';>3$6W2,S%GD;^\Q/4_I6S116I`4444`%%%%`!1110`4444`%%%%`!111
M0`452U;6=.T+3WOM8O(;.V3K)*V,GT'<GV'->-:_\8M<\5WS:+\,].N-S'!O
M&0&0CU`/RH/]IN>?X30!Z=XM\>Z!X+M?,UF['GL,QVD(WRR?1>P]S@>]>17?
MBCQY\6[EK/PY;OI&AEMLDH8J"/\`;DZL?]E/7D'K6QX6^"L8N?[5\=7;:K?R
M-O:#S69,^KN?F<_I]17JMO;P6EM';VD,<$,:A4BB4*J`=@!P!6,JJ6QK&GW.
M(\&_"70O"ACNIU_M+4EY^T3K\J'_`&$Z#ZG)]Z[NBBN=MO<V22V"BBBD`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!114<L\<"YD;'H.YH&25X[\;75O$7AM5()6UOL@=OFMJ]-GOY
M)<B/Y%]NIKR3XM?\A_P__P!>MY_Z%;U=-^^B)KW3Z`HHHKL.8****`"BBB@`
MHHHH`****`*6K:BNF:>\[8+_`'8U/\3'H/IW/L#7GSNTDC/(Q9W)9F/<GJ:T
M_$.I_P!H:B5C.8("43'<]V_''Y`'O657#6GS2LCJIQLKA1116!J%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`5S%O\`\E-N_P#KP'_H2UT]<Q;_
M`/)3;O\`Z\!_Z$M=V$VJ_P"%_FCCQ6]/_$OU.GHHHKA.PR_$W_(L:A_UP:E\
M.?\`(LZ=_P!>Z?RI/$W_`"+&H?\`7!J7PY_R+.G?]>Z?RKN_Y@O^WOT./_F+
M_P"W?U-.BBBN$[`HHHH`W-)\23V6V&[S-!ZGEE^GJ/:NOMKJ&\@$UM()$/<=
MJ\TJQ97]QI\WFVLA0]QV8>A%=%.LXZ/8RG33U1Z1163I7B"WU'$<F(;C^X3P
MWT/]*UJ[(R4E=',TT[,****8@HHHH`****`"BBB@`HHHH`\CM/\`BT_Q.^PL
MWE^%?$DA:WR_R6EQQD8[#D#M\I7D[#7KE<]XX\*6_C/PE=Z3/A96'F6TIX\J
M8`[6Z'CG!]B:R/A5XKN/$7AJ2QUC>NM:/)]DODDSO)&0KG/<[2#[JU`'<444
M4`%%%%`!1110`4444`%%%%`!1110!PWQ-^'J>-=*CN+%OL^MV(+6DX.W=WV,
M?3/(/8_4YX'PAXG?5HY=-U53!K-B3'<Q.,%BIP6QZYX([&O=Z\M^*GP_GNY!
MXO\`"J^7K=B-\L<:Y-T@&.G=@.,?Q#CTK.I!31<)<K'45B>%O$UMXFTH7$.$
MGCPL\.>8V_P/8_X&MNO/::=F=:=U=!1112&%%%:8LXY[6,_=?:.1WI@9E%33
M6TD!^<?+V8=*AH`****0!1110`4444`%%%%`!1110`4444`%:^G_`/'FOU-9
M%:^G_P#'FOU--`6:***H04444`%%%%`!1110`4444`%%%%`!1110`451U;6]
M-T*S-UJUY%:Q=BYY8^BCJQ]A7#CQ5XJ\=W#V7P^TQ[:U#;9-4N@`J_3.0/PW
M-["KC"4MB924=SK]?\4Z1X:M_-U>\2)B,I"OS2/]%Z_CTKD+>]\<_$E]GABU
M.A:*W!OY_E=QWVGK_P!\#KU:NL\*_!?2-*N1J?B:>37]5)WM)<DF)6_W3DL?
M=B>@X%>DJH10J@*H&``.`*Z8TE'<YY5&]CA?!_PD\/\`A1Q=SJ=6U/.YKR[4
M':W<HO(7UR<GWKNZ**V,PHHHH`****`"BBB@`HHHH`****`"BBB@`HHKB/&O
MQ6\/^#%D@>47^IJ.+*W<94^CMR$_'GV-`':O(D4;22LJ(H+,S'``'4DUY1XQ
M^.FGZ=,VF^$(/[8OV(19QDPJQX`7',ASV&!SU/2N3^S^/OC)()+^3^Q_#Y8,
MJ["L;#J"J]93TY)VYZ8Z5Z;X1^'NA>#80=.M_.O""'O)P&E.>H!Q\H]A^.:S
ME442XP;/.]-^&7BCQUJ2:S\1=2FAB)RMIG,FW^Z%^[$.G3)]0#S7K>B>']+\
M.6`L]%LHK2$=0@Y<^K-U8^YK1HKGE-RW-U%+8****@84444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4C.J*6<A0.YJK/J"1Y$7SMZ]A6=+-),V9&SZ#TI7'8N3ZC_#`/^!$509B
M[%F))/4FDHJ1A7E_Q:_Y#_A__KUO/_0K>O4*\O\`BU_R'_#_`/UZWG_H5O6E
M+XT14^%GT!1117<<H4444`%%%%`!1110`5E>(M1^P:6PC;;/-^[CP>1ZM^`[
M^I%:M<'XBOC>ZQ(`?W4'[I![C[Q_/]`*RJRY8EPCS2,L#`P.!1117GG8%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%<Q;_P#)3;O_`*\!
M_P"A+73US%O_`,E-N_\`KP'_`*$M=V$VJ_X7^:./%;T_\2_4Z>BBBN$[#+\3
M?\BQJ'_7!J7PY_R+.G?]>Z?RI/$W_(L:A_UP:E\.?\BSIW_7NG\J[O\`F"_[
M>_0X_P#F+_[=_4TZ***X3L"BBB@`HHHH`4$@Y'!KH=)\420;8=1S)'T$@Y9?
MKZ_S^M<[15QDXNZ)E%26IZ;#-'<1++`ZR(W1E.13Z\[T_5+G39=UN_RD_-&?
MNM79Z7K5MJ:@(?+F`RT3'G\/6NRG54M.IS2IN)HT445L9A1110`4444`%%%%
M`!7E'C%1\/OBCIOC.$;-*U8_8=5`'",>DG<]%#<#/[L\_-7J]8WB[P[#XK\)
MW^C3X7[3$1&Y_@D'*-^#`?AF@#9HK@OA!XAFU?P;_9FI`IJ>B2&QN8WX8!>$
M)';@;?<H:[V@`HHHH`****`"BBB@`HHHH`****`"BBB@#R[Q9\'VO-8GUSP9
MJC:/J,QWR0$8AE;N>/NY/)X(]JXR?Q'XF\'SBU\=Z',(@0%U"V4%']\CY2>^
M`01Z5]"4R:&*XA>&XC26)QAD=0RL/0@]:B4(RW*C)QV/(M*UW3-;BWZ9>1SX
M&60'#+]5/(K0J3Q+\$-!U.8WOAV:7P_J`.Y7MLF+/^YD;?3Y2![&N+U`>//`
M>3X@TX:UI<?6^M>2J^K$#C`_O`?6N:5!KX3>-5=3L*V[;_CUB_W17$:)XPT;
M7PJV5T$G/_+";Y7_`"[_`(9KH-5\5:/X:TZ*35KQ(F*`I"OS2/\`11S^/2L>
M5WM8TNK7-P@$8(R/0UROBGQ#H7AJ,M?7BI<$96UC^>1_HO;IU.![UBV^J^./
MB&WE^$K`Z-I3'!U&ZX9A_LG_`.)!^HKLO"OP;\/Z%(+S5PVNZDQW//>#<@;U
M"'(_%LFMXT6_B,I5;;'/Z-X@TW7K?S=,NEEP/GC/#I]5ZCZ]*TJ7Q5\%M.OI
MVU/P=/\`V#JB_,JQ$K`Y]"H^Y_P'C_9-<4?$VN>$;Y=-^(.FR0$G$=_"FY)!
MZ\<'\.1W%*=!K6(XU4]SM**@L[VVU"U6XL9X[B%^CQL&!J>N<V"BBBD`4444
M`%%%%`!1110`5KZ?_P`>:_4UD5KZ?_QYK]330%FBBBJ$%%%%`!1110`4444`
M%%%%`!13)98X(6EGD6.-!EG=L!1ZDFN#U/XFB[O_`.R?`^G3:YJ+9`=$/E+V
MSQRP'<\+CG-5&+EL2Y);G;WU_::;:/=:A<Q6T"?>DE<*!^)[UP=Q\0M3\2Z@
MVE?#G2I;^;.'O98R(XP?XL'H.#RV/H:T]'^$&J>(KF/5/B9J<EP_WETRWDPD
M?^R67@?\!_[Z->K:9I=AHUBEEI5I#9VT?W8H4"K]>.I]^IKIC12W,)5&]CS3
MP_\`!:*:]75OB!J#ZWJ!P?(#$0IZ`G@L!Z<+[&O4;:U@LK6.VLX([>")=L<4
M2!50>@`X`J6BMS(****`"BBB@`HHHH`****`"BBB@`HHHH`***KWU_::9927
M>HW,5K;Q#+RRN%51]30!8K$\2^+]#\(V7VC7;^.WW`F.$?-)+_NH.3]>@[D5
MYAXF^-UUJEX='^&UA-=W,GRK>-"2?JD9'ZN,#TJ#P]\&[O5KW^V/B-?S7EU+
M\S6BS%C]'D!_1>!V-3*2CN4HM[%+4OB'XU^)EY)IG@6QFT[3L[9+@':^#UWR
M]$XYVK\W7D]*Z;P;\&=%\/%+O6-NK7XP1YB_N8S_`+*]S[G\`*]!LK&UTVSC
MM-/MXK:WC&$BB0*J_@*GKGE4;V-HP2`#`P.E%%%9%A1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!13)9DA7=(P`_G6=/J#R?+%E%]>YHN,NSW<<'#'+?W16;/=R3\$[5_NBH.O
M6BIN.P4444AA1110`5Y?\6O^0_X?_P"O6\_]"MZ]0KR_XM?\A_P__P!>MY_Z
M%;UI2^-&=3X6?0%%%%=QRA1110`4444`%%%%`%'6+TZ?I,TZG$F-L?3[QX!Q
MWQU^@KST#``'05TGC"[WW$%FI^5!YK<=SP/Q`S_WU7-UQ5Y7E;L=5)6C<***
M*YS4****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*YBW_P"2
MFW?_`%X#_P!"6NGKS_7='OM8\=7%OINI26$HMED,J,PRHP-O!''(/X5WX/55
M/\+_`#1QXK>G_B7ZGH%%<UX6\.ZKHMQ<2:IK4VHK(@5$=F(4YZ_,34GBK0-3
MUS[)_9>KR:;Y._?L9AYF=N/ND=,'\ZX[*]KG5=VO8N^)O^18U#_K@U+X<_Y%
MG3O^O=/Y5S*>'=5T3P_K$FJ:U+J*R6Q5$=F(4^OS$U+/H&IZYX:T3^R]7DTW
MR;?Y]C,/,R%Q]TCI@_G7=9?5+7^U^AQW?UJ]OL_J=I17->%O#NJZ)<7$FJ:U
M+J*R*%1'9B%.>OS$T_Q5H&IZX;7^R]7DTWR=^_8S#S,XQ]TCI@_G7#97M<[+
MNU['145S?A;P[JFB3W#ZIK4NHK(H5$=F(0@\GYB:=XJT#4]<-J=+U>33O)W[
M]C,-^<8^Z1TP?SHLKVN%W:]CHJ*YOPMX=U31)[A]4UJ745D4*B.S$(0>3\Q-
M.\5:!J>N&U.EZO)IWD[]X1F&_.,?=(Z8/YT65[7"[M>QT5%<WX6\.ZIHD]P^
MJ:U+J*R*%1'9B$(/)^8FG>*M`U/7&M3I>KR:=Y(?>$9AOSC'W2.F#^=%E>UP
MN[7L=%2JQ1@R$JRG((."#7->%O#VJ:)/</JFLRZBLB@(KLQ"8)R?F)IWBK0-
M3UQK4Z7J\FG>2'WA&8;\XQ]TCI@_G19<UKA=VO8]*TGQ3]V'4_H)@/\`T+_&
MNG1UD0/&P96&0RG(->&>%O#VJ:)/</JFLRZBLB@(KLQ"8)R?F)JQXFTS7-56
MU71?$%UI20[]ZPRNH?.,?=(]#^==$*MG9LQE3NKH]LHKE?ASI][IOA-8=3UB
M?5[@S.S3SEBR@XPN6))`Z_C755TIIJZ,'H%%%%,`HHHH`****`/++S/@CX\6
MURI$6E^+(O)D4<*+E<`':.Y)7D_\]6]Z]3K@_C'H3ZQ\/;FZM,B\TEQ?0.I`
M*[/O\_[I8\=U%=-X5UR/Q+X3TW6(BG^EP*[A,X5^CJ,^C!A^%`&M1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`<1XJ^$GA;Q3OFDL_L%ZW/VFSPA
M)_VE^ZWY9]ZS?"WP3T'1+H7VM32:_?ALB2Z7$:XZ'R\G)Q_>+#@8`KTFB@!%
M4(H5`%51@`#``I:**`"JNI:98ZQ8R66J6D-W;2?>BF0,I]\'O[]JM44`>-:]
M\'=3T"Y?4_AK?M'SNDTRXDRKCT5CP?HW_?58NF>.XTO#IGBNU?1=2C.UQ,I6
M,GUR?NCZ\>]>_P!8GB7P?H?BZS^SZ[81W&T$1S`;9(O]UQR/IT/<&LYTXSW+
MC-QV.)5@RAE(((R".]+7,:IX"\8_#]FN/"\S:]HJ\M:2#,T8[_*.OU7\5J;0
M/&NE:\P@5S:7N<-:SG#9]!_>_G[5R3I2B=$:BD=#1116)H%%%%`!1110`5KZ
M?_QYK]3616OI_P#QYK]330%FBBBJ$%%%%`!1110`445RGB7XAZ+X=<VWF&^O
M\[1:6QW,&]&/1?IU]J:3;LA-I;G5D@`D\`=37$Z_\3=/T^Z&G:#!)K>IN=J0
MVOS*&]"1DD^R@].U5;3P?X[^(V)?$EQ_PCFB.<BSC4B65?0KUZ?WSP>0M>H^
M%_!&@^#[7RM$L4CD(P]P_P`TLGU;^@P/:NB-'^8QE5['FNG?#3Q7XWG2\^(>
MH-I]CD,FEVC`'\>H7ZDLWTKU70?#>D>&+`6>A6$5I%QNV#YG/JS'EC[FM2BN
MA)+1&+=PHHHIB"BBB@`HHHH`****`"BBB@`HHHH`****`"@G`R>E<IXR^(_A
M_P`$PD:E<>=>D`I96Y#2G/0D9PH]S^&>E>2SZIX^^,DABL4_L;P^S$,0Y6-A
MT(9NLI]@`N>H'6DVEN-*YW'C;XVZ)X;,EGHNW5]1&0?+;]S$?]IQU/LOXD5Q
M=GX(\:_$V]CU/QU?S6&GYW16Q&U@#TV1=%XXW-\W3KUKOO!OPOT'P@L<Z1"^
MU%1S>3J,J?\`87D)^'/N:[.L)5?Y36-/N8WASPGHOA2S^SZ)8QP;@!)*?FDD
M_P!YCR?IT'8"MFBBL=S4****0!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%59[Z.+(3YV]N@H&66
M8*I+$`#J35&?40,K`,_[1JE-/).V9&^@["HZFX[#G=I&W.Q8^IIM%%(84444
M`%%%%`!1110`5Y?\6O\`D/\`A_\`Z];S_P!"MZ]0KR_XM?\`(?\`#_\`UZWG
M_H5O6E+XT9U/A9]`4445W'*%%%%`!1110`4451UFZ^QZ-<S!F5@FU67JK-\H
M/YD4F[*X;G#:C=?;=2N+D$,LCDJ1W4<+^@%5J**\QN[N=R5E8****0PHHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`KB'O)8OBXD28"S1^2
M_'5?*+_S45V]<>EC'-\59)F9PT%MYR@$8+;1'@^V&/XUWX/:K_A?Z''BMZ?^
M)?J=A1117`=AE^)O^18U#_K@U+X<_P"19T[_`*]T_E2>)O\`D6-0_P"N#4OA
MS_D6=._Z]T_E7=_S!?\`;WZ''_S%_P#;OZFG1117"=@4444`%%%%`!1110`4
M444`%%%%`':^$_\`D"G_`*ZM_2MNL3PG_P`@4_\`75OZ5MUZ-/X$<<_B8444
M5H0%%%%`!1110`V6*.>%XIT62.12KHXR&!X(([BO,_@U-+I8\0^#[J1W?1+]
MO):0XW0N3C"]AE2W_;2O3J\OU`?\(W^T5I]X%V6WB.P:WEDD/!E0<!??"1#_
M`(%[T`>H4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`5QGC'X6^'O&&ZXF@^PZD>1?6H"N3ZN.C]!UY]"*[.B@#Y]OX
M?&GPW?;K]N=;T53A;ZWRS(.VX]1]&X[!JZ#1O$&FZ];^;IETLN!\\9X=/JO4
M?7I7L+*KH5=0RL,$$9!%>8^*_@MIU].VI^#I_P"P=47YE6(E8'/H5'W/^`\?
M[)K"=&,M4:QJ-;B45Q9\3:YX1O5TWX@Z;)!DXCOX4W)(/7C@_AR.ZUUMG>VV
MH6JW%C/'<0MT>-@0:Y)0E'<Z(R4MB>BBBH*"M?3_`/CS7ZFLBM?3_P#CS7ZF
MF@+-%%%4(***RM=\3:1X;MO.U>]C@R,I'U>3_=4<GZ]!WH2;V%L:M8'B3QKH
MOA:,_P!HW0:XQE;6+YI&]..P]S@5S%OJWC3XD%HO!]DVCZ0Q*MJ5P=K,.AVD
M=_9<D>HKM_"/P?\`#WAJ1;V^4ZSJF[>UU=C*JW7*IR`<\Y.3GO71&BW\1E*K
MV.+MK'Q]\2R#;!O#&@O_`,M7SYLJ^HZ,WX;5(/4UZ)X.^&/ASP8HEL+8W-]C
M#7MSAI/^`]E'T&?4FNOHKI45%61@VWN%%%%,04444`%%%%`!1110`4444`%%
M%%`!1110`45'<W,%G;27%W-'!!$I:265PJH!U))X`KR/Q;\<X4N#I7@*T;5;
M]VV+<&)FCSZ(@^9S[]._(H`].UWQ%I/AK3S>ZY?16<`^Z7/S.?15ZL?85XUK
M'Q8\3^.-1?1OAQITUO"3M:\(S+M_O$_=B'7KD],$'BDT;X4:[XLOUUKXE:E<
M%V.1:!P9"/0D?*B_[*C//8UZYI6D:?HE@EEI-I%:6Z=(XEQD^I]3[GFL954M
MC2--O<\X\)?!2PL)AJ/BV?\`M>_8EVA.3"&/)+9YD.>YP.>AZUZBB+%&J1JJ
M(H`55&``.P%.HK!R<MS9)+8****D84444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1139)$B7=(P4>]`#
MJBFN8X!\Y^;LHZU2GU%F^6'Y1_>/6J1))R>32N.Q//>R3Y'W$]!5>BBI*"BB
MB@`HHHH`****`"BBB@`HHHH`*\O^+7_(?\/_`/7K>?\`H5O7J%>7_%K_`)#_
M`(?_`.O6\_\`0K>M*7QHSJ?"SZ`HHHKN.4****`"BBB@`KG?&%QLL;>W#$-)
M(6('1E4<_JRUT5<=XOF9M4AA.-D<.X>Q).?_`$$5E5=H,NFKR1@4445YYV!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5Q(NYA\7
M#%$5"-'Y4F1U7RM_Y[L5VU<A!91M\5;B8EMRVPF`SQG:J?E@_G7?@]JO^%_F
MCCQ6]/\`Q+]3KZ***X#L,OQ-_P`BQJ'_`%P:E\.?\BSIW_7NG\J3Q-_R+&H?
M]<&I?#G_`"+.G?\`7NG\J[O^8+_M[]#C_P"8O_MW]33HHHKA.P****`"BBB@
M`HHHH`****`"BBB@#M?"?_(%/_75OZ5MUB>$_P#D"G_KJW]*VZ]&G\"..?Q,
M****T("BBB@`HHHH`*\Q^-T9L=(T+Q+!$9+C1M4CD']T(>3GZLB#\:].KE/B
M?IW]J?##7K<-MVVIGR>_E$28_'9B@#JD=7171@RL,@@Y!%+7-?#K45U7X;Z#
M=(2?]"2)B>I:,;&/YJ:Z6@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`JZCIECK%C)9:I:0W=M)]Z*9`RGWP
M>_OVKR37O@[J>@W+ZG\-;]HN=TFF7$F5<>BL>#]&_P"^J]EHI-)[AL>`:;X[
M2.].F>*[5]%U*,[7$RE8R?7)^Z/KQ[UURL&4,I!!&01WKMO$O@_0_%UG]GUV
MPCN-H(CF`VR1?[KCD?3H>X->2:KX!\8_#]VN/"\S:]HJ\M:2#,T8[_*.OU7\
M5KGG0ZQ-XU>YTU:^G_\`'FOU-</H'C72M>80*YM+W.&M9_E;/H#_`!?S]J[*
M*\M[#2C<WL\=O#'DM)(P51^)KFY6G9F]TU=%^J>J:OI^B637>JW<=K"O\3GK
M[`=2?8<UQ%Y\1-0U[4'TGX=Z1-JET.&NG3$:>_.`![L5&1T-;6@?!E[V[75?
MB-J+ZO>YR+5'(A3T!/&?H`!]:VC1;W,I5$MC!/C/Q)XUNWL/AUI,ODAMDFIW
M*@+'[\_*O7.#EB.BUU7ACX+:78W?]J>+9V\0:HYW.9\F$'_=/W_3YN/85Z/:
M6EO86D=K8P1V]O$NV.*)`JH/0`<"IJZHQ4=C!R<MQ$18T5(U"JHPJJ,`#TI:
M**HD****`"BBB@`HHHH`****`"BBB@`HHHH`***Y_P`5^.-"\&V?G:W>!9&7
M,=M'AII?]U?ZG`]Z`.@KS_QM\8/#_A$R6D#_`-IZFHQ]F@;Y8S_MOT'T&3["
MO/;WQCXZ^+-U)8^$X'TG1PQ2642;0?\`KI*!GI_"G8\YKL_!WPAT'PQY=S>H
MNJZBN#YTZ?)&?]A.G7N<GTQ42FHE1BV<4FA^/OBW=)=^(KAM)T,MN2$J47;_
M`+$?5C_M/Z\$]*]3\*^!M"\'VVS2+0>>PQ)=2G=+)]3V'L,#VKH:*YI3<C>,
M4@HHHJ"@HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`H)`&2<#U-5I[V.'('SOZ#M6=-<R3GYS\
MO91TI7'8N3ZBJY6#YC_>/2L^21Y6W2,6/O3:*FXPHHHH&%%%%`!1110`4444
M`%%%%`!1110`4444`%>7_%K_`)#_`(?_`.O6\_\`0K>O4*\O^+7_`"'_``__
M`->MY_Z%;UI2^-&=3X6?0%%%%=QRA1110`4444`%<#XA??X@NR&W+N4#VPH!
M'YYKOJ\WU#/]JWF3G_2),?3<<5SXA^Z;4=RO1117$=(4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%<9;W4B_%FZB^4JT(BY'0>6K
M_P`Q79UR5O9I_P`+3N926S]E$H],X5/RQ^M=^#VJ_P"%_FCCQ6]/_$OU.MHH
MHK@.PR_$W_(L:A_UP:E\.?\`(LZ=_P!>Z?RI/$W_`"+&H?\`7!JL>&K.Z;PO
MIK+;3%3;(01&>>*[O^8+_M[]#C_YB_\`MW]2Y14_V&[_`.?6;_OV:/L-W_SZ
MS?\`?LUQ'8045/\`8;O_`)]9O^_9H^PW?_/K-_W[-`$%%3_8;O\`Y]9O^_9H
M^PW?_/K-_P!^S0!!14_V&[_Y]9O^_9H^PW?_`#ZS?]^S0!!14_V&[_Y]9O\`
MOV:/L-W_`,^LW_?LT`045/\`8;O_`)]9O^_9H^PW?_/K-_W[-`'7>$_^0*?^
MNK?TK;K'\,120Z/MEC9&\QCAA@]JV*]&G\"..?Q,****L@****`"BBB@`J"]
MM(M0T^XL[D$PW$312`=U88/Z&IZ*`/-_@1?/=?#&.V<8^P7<UN/Q(D_G)7I%
M>9?!^1+74_&NBPC$-CK<C1CN`Q91^D0KTV@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#C/&/
MPM\/>,-UQ-!]AU(\B^M0%<GU<='Z#KSZ$5QVD_`_4+R\4^.?$,FHV5JQ6WM8
M'?YU[%F;[I]0,G_:KV2B@"EI6CZ=H=@EEI%G#9VR=(XDP,^I]3[GFKM%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!112.ZQHSNP55&2Q.`!ZT`+535-6L-
M$T][[5KN&SMH_O2S-M&?3W/L.:\T\9_'+3-)D.G^$XTUK4&;8)%),"-VP1S(
M<XX7CW[5R]A\./%?Q"OX]8^(>HSVD!&8[;`$JJ>RI]V(=.H)XY'>DY);C2;V
M+_B'XSZMXCU`Z)\--.EDE<$?;'CRY'<JAX4?[3?D*?X7^"OF7?\`:WCV]?4[
MV0AVM_-9AGUDD)RYZ<=/<UZ3H7AW2O#6GBST6RCM8N-Q4?,Y]6;J3]:TZYY5
M6]C:--+<BMK:"RMH[:SAC@@B7:D42!54>@`X%2T45B:!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!137=8UW.0H]35"?42<K`,#^\:+C+LUQ'`N9&Y[`=36;/?22\)\B^@ZFJ
MQ8LQ+$DGJ325-QV"BBBD,****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`KR_XM?\`(?\`#_\`UZWG_H5O7J%>7_%K_D/^'_\`KUO/_0K>M*7QHSJ?
M"SZ`HHHKN.4****`"BBB@`KR_P`PR_O#R7^8_C7J%>60_P"H3_='\JY<1LC>
MCU'T445R'0%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!7(VOB+4)/B?>:([H;*.(,J[!D'8IZ_4FNNK&A\,64/BJ;7UEG-U,FUD+
M+L`V@<#&>@'>KBTKW)=]+&S1114%`1D8/(KOHP!&H`P`!@5P-=^G^K7Z"KB2
MQ:***LD****`"BBB@`HHHH`****`"BBB@"W;_P"I'UJ6HK?_`%(^M2UVQ^%'
M-+=A1115$A1110`4444`%%%%`'F7PVA^R_$_XAPMPS7D,H'LQE;_`-F%>FUY
MKX8?9^T!XTB7@-:VKD>XCC_^*KTJ@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"LOQ1SX0UC_KQG_]%FM2LSQ+SX3U
M?_KQF_\`0#0!X3\%#:V5G=ZB]E#-<K<>6)77+HNT'"GMUKV^SU&WOES`_P`W
M=&X(KPOX1_\`(O7O_7U_[(M=^KLC!D8JPZ$'!%<%234V=<%[J._HKG+#Q$Z8
MCO@77_GHHY'U'>M^"XBN8A)`X=3W%).X[$E%%%,04444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%03WD<&03
MN?\`NB@9/TZU3GU!$^6'YV]>PJE/=23\,<+_`'14%3<=A\LKS-ND;)_E3***
M0PHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*\O\`
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
M5MAO;^\>@_QK*EFDF?=*Q8^]9RJ);%J#>Y>N=6=\K;C8O]X]3_A6>2222<D]
M2:2BL')O<U22V"BBBD,****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBL#Q+XTT7PM"?[2N0UP1E+6+YI&]..P]S@4)-Z(3=MS?KA_%?Q2T?P_OM[
M`KJ5\O!CB?\`=H?]I^>1Z#)]<5S,=QXY^+,[6VC6ITW0V8I),25C*]]S]7/;
M:H[C([UZCX)^$7A_P>([F1/[3U-<'[5<*,(?]A.B_7D^]=,*/61C*KV/-],\
M!^-?B?<17_BJX;2=*W;HXFC*DC_8B/J/XF]>,BO9?"G@C0O!MF(-$LPDA7$E
MS)AII?\`>;^@P/:N@HKH22T1C>X4444Q!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!7B_QY_Y#_A?_KUO
M_P#T*UKVBO%_CS_R'_"__7K?_P#H5K0![1117GOC?XQ:#X2\RTM&&J:FO'D0
MM\D9_P!M^@^@R?I0!WEW>6VGV<EU?3QV]O$NZ265@JJ/4DUX]XI^-MQJ%Z=%
M^&]E+>WDA*+>&+=SZQIW^K8'L1S6-:^$O'/Q:NHM1\87;Z5I(;?%!Y97C_IG
M$>F1_&QSSW%>N^&/!VB>$+/[/HEDD3,,23M\TLO^\W4_3H.PJ7*PTCS7PW\%
M[S5[TZS\2KZ6[N93N-HLY8GV=QT_W4.!QSVKU^RLK73K..TL+>.VMXAM2*)0
MJJ/8"IZ*ANY=K!1112&%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%13W,5LN96P>RCJ:R+K4
MY9\K'^[3T!Y/XU,I*(U%LT;G48;?*@[W_NCM]361<7DUR?WC87LHZ"H**PE-
MR-E%(****@H****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
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
!V0``

#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End