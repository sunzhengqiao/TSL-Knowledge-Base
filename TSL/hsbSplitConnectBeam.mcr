#Version 8
#BeginDescription
version value="1.1" date="10sept2019" author="thorsten.huck@hsbcad.com"
new properties introduced to enable staggered split locations and to align cut perpendicular, plumb or horizonztal

This tsl creates splits beams or connects colinear beams
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
/// <version value="1.1" date="10sept2019" author="thorsten.huck@hsbcad.com"> new properties introduced to enable staggered split locations and to align cut perpendicular, plumb or horizonztal </version>
/// <version value="1.0" date="19jun2017" author="thorsten.huck@hsbcad.com"> initial</version>
/// </History>

/// <insert Lang=en>
/// select properties or catalog entry, select one or multiple beams and/or optional split point location, and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates 
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbSplitConnectBeam")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Join beams|") (_TM "|Select tool|"))) TSLCONTENT
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

// declare properties
	String sGapName=T("(A) |Gap|");	
	PropDouble dGap(nDoubleIndex++, U(0), sGapName);	
	dGap.setDescription(T("|Defines the Gap|"));
	dGap.setCategory(category);

	String sStaggerOffsetName=T("(B) |Stagger Offset|");	
	PropDouble dStaggerOffset(nDoubleIndex++, U(0), sStaggerOffsetName);	
	dStaggerOffset.setDescription(T("|Defines the offset to create a staggered spliiting distribution.|")+ T(" |Ever second split location will be offseted by the given value.|"));
	dStaggerOffset.setCategory(category);

	String sOrientationName=T("(C) |Orientation|");	
	String sOrientations[] ={ T("|Perpendicular|"), T("|Plumb|"), T("|Horizontal|")};
	PropString sOrientation(nStringIndex++, sOrientations, sOrientationName);	
	sOrientation.setDescription(T("|Defines the orientation relative to WCS|"));
	sOrientation.setCategory(category);

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
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();	
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
		else	
			showDialog();
		
		int bIsStaggered = abs(dStaggerOffset) > 0;
		
		
		
	// request one or multiple (parallel) beams
		Beam beams[0];
		PrEntity ssE(T("|Select beam(s)|"), Beam());
		if (ssE.go())
			beams=ssE.beamSet();
			
	// exit if no beam has been selected
		if (beams.length()<1)
		{ 
			eraseInstance();
			return;
		}
		else
			_Beam.append(beams[0]);
			
	// use the first beam as reference for potential other beams		
		Vector3d vecX = beams[0].vecX();
		Vector3d vecZ = beams[0].vecD(_ZU);//beams[0].vecZ();
		Vector3d vecY = vecX.crossProduct(-vecZ);//beams[0].vecY();
		Point3d ptCen = beams[0].ptCenSolid();
		double dL = beams[0].solidLength();
//
		for (int i=1;i<beams.length();i++) 
		{ 
			Beam bm1 = beams[i]; 
			Vector3d vecX2 = bm1.vecX();
			Vector3d vecY2 = bm1.vecY();
			Vector3d vecZ2 = bm1.vecZ();				
			Point3d ptCen2 = bm1.ptCenSolid();
			double dL2 = bm1.solidLength();
			double dY = abs(vecY.dotProduct(ptCen-ptCen2));
			double dZ = abs(vecZ.dotProduct(ptCen-ptCen2));
		
		// consider the beam to be valid if:
			// X-Axises are parallel
			// beams are not tilted 
			// axis offsets are smaller than the tolerance value
			if (bm1.vecX().isParallelTo(vecX) && (bm1.vecZ().isParallelTo(vecY) || bm1.vecZ().isParallelTo(vecZ)) && dY<dEps && dZ<dEps)
			{ 
				_Beam.append(bm1);
				
			// set tool location
				Vector3d vecDir = vecX;
				if (vecDir.dotProduct(ptCen2-ptCen)<0)
					vecDir*=-1;
				Point3d pt1= ptCen+vecDir*.5*dL;
				Point3d pt2= ptCen2-vecDir*.5*dL2;
				
				_Pt0 = Line(ptCen, vecX).closestPointTo((pt1+pt2)/2);
				break; // only one additional beam allowed
			} 
		}
		
		

		


	// request split point if only one beam has been selected or no connection could be found
		if (_Beam.length()==1)
		{ 
			
		// order beams
			Vector3d vecXOrder = vecX;
			if (vecXOrder.dotProduct(_ZW) < 0)vecXOrder *= -1;
			Vector3d vecYOrder = vecXOrder.crossProduct(_ZW);
			_Beam = vecYOrder.filterBeamsPerpendicularSort(beams);
			
		// color beams on debug to see order sequence	
			if (bDebug)
				for (int i=0;i<_Beam.length();i++) 
					_Beam[i].setColor(i+1); 
				
		// prompt for point input
			Point3d pts[0];
			PrPoint ssP(TN("|Select split point|"), ptCen); 
			if (ssP.go()==_kOk) 
			{
				Point3d pt1 = ssP.value();
				_Pt0=pt1;
				if (_ZU.isParallelTo(_ZW))
				{ 
					Line(_Pt0,_ZU).hasIntersection(Plane(ptCen, vecZ), _Pt0) ;	
				}
				else
				{ 
					PrPoint ssP2(TN("|Select second point|"), pt1);
					if (ssP2.go()==_kOk)
					{ 
						Point3d pt2 = ssP2.value();
						pt2 += _ZU * _ZU.dotProduct(pt1 - pt2);	
						Vector3d vecDir = pt2 - pt1;
						vecDir.normalize();
						Line(_Pt0,vecDir).hasIntersection(Plane(ptCen, vecY), _Pt0) ;
					}
				}
				
				//_Pt0 = Line(ptCen, vecX).closestPointTo(pt);
				
				
			// prepare tsl cloning
				TslInst tslNew;
				Vector3d vecXTsl= _XE;
				Vector3d vecYTsl= _YE;
				GenBeam gbsTsl[2];// = {};
				Entity entsTsl[] = {};
				Point3d ptsTsl[1];// = {};
				int nProps[]={};
				double dProps[]={};
				String sProps[]={};
				Map mapTsl;	
				String sScriptname = scriptName();				
			
			// split beam if only one selected
				for (int i=0;i<_Beam.length();i++) 
				{ 
					Point3d ptSplit = _Pt0;

					Beam bm=_Beam[i]; 
					gbsTsl[0]=bm;
					vecX = bm.vecX();
					
					if (i % 2 == 1)ptSplit += vecX*dStaggerOffset;
					
					dL = bm.solidLength();
					Point3d ptCen0 = bm.ptCenSolid();
					if (abs(vecX.dotProduct(ptSplit-ptCen0))<.5*dL)
					{ 
						Beam bm1 = bm.dbSplit(ptSplit+vecX*.5*dGap,ptSplit-vecX*.5*dGap);
						if (bm1.bIsValid())
							gbsTsl[1]=bm1;	

						ptsTsl[0]=Line(ptCen0, vecX).closestPointTo(ptSplit);
					
						tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
								nProps, dProps, sProps,_kModelSpace, mapTsl);	
							
						if(tslNew.bIsValid())
							tslNew.setPropValuesFromCatalog(sLastInserted);
						
					}					
				}
				
			// erase caller 
				eraseInstance();
				return;					

			}
		// exit if invalid
			else
			{ 
				reportMessage("\n"+ scriptName() + ": "+T("|Tool will be deleted.|"));
				eraseInstance();
				return;	
			}
		}

		return;
	}	
// end on insert	__________________


// validate connection
	if (_Beam.length()<2)
	{ 
		eraseInstance();
		return;
	}

// use the first beam as reference for potential other beams	
	Beam bm0 = _Beam[0];
	Vector3d vecX = bm0.vecX();
	Vector3d vecY = bm0.vecY();
	Vector3d vecZ = bm0.vecZ();
	Point3d ptCen = bm0.ptCenSolid();
	double dL = bm0.solidLength();


	Beam bm1 = _Beam[1];
	Vector3d vecX1 = bm1.vecX();
	Vector3d vecY1 = bm1.vecY();
	Vector3d vecZ1 = bm1.vecZ();
	Point3d ptCen1 = bm1.ptCenSolid();
	double dL1 = bm1.solidLength();

	double dY = abs(vecY.dotProduct(ptCen-ptCen1));
	double dZ = abs(vecZ.dotProduct(ptCen-ptCen1));

	Point3d ptMid = (ptCen-vecX*.5*dL+ptCen1+vecX*.5*dL1)/2;
	Vector3d vecDir = vecX;
	if (vecDir.dotProduct(ptCen1-ptCen)<0)
		vecDir*=-1;
	
// use the stagger property to offset the tool, then reset to 0
	if (_kNameLastChangedProp == sStaggerOffsetName)
		_Pt0 += vecDir * dStaggerOffset;

	int nOrientation = sOrientations.find(sOrientation,0);
	Vector3d vecDirN = vecDir.crossProduct(_ZW).crossProduct(-_ZW);
	vecDirN.normalize();
	Vector3d vecDirs[] ={ vecDir, vecDirN, _ZW};
	vecDir = nOrientation>-1 && nOrientation<vecDirs.length()?vecDirs[nOrientation]:vecDir;
	
	ptMid.vis(3);
	vecDir.vis(ptMid,1);

	int bRangeTest = abs(vecX.dotProduct(ptMid-_Pt0))<(dL+dL1-dGap)/2;
	
// validate connection
	// X-Axises are parallel
	// beams are not tilted 
	// axis offsets are smaller than the tolerance value
	// _Pt0 is within range of both beams
	int bStretch = bm1.vecX().isParallelTo(vecX) && (bm1.vecZ().isParallelTo(vecY) || bm1.vecZ().isParallelTo(vecZ)) && dY < dEps && dZ < dEps && bRangeTest;
	
	
// Trigger Join//region
	String sTriggerJoin = T("../|Join beams|");
	addRecalcTrigger(_kContext, sTriggerJoin );
	if (_bOnRecalc && (_kExecuteKey==sTriggerJoin || _kExecuteKey==sDoubleClick))
	{
		bStretch = false;
	}//endregion	
	
	
// stretch	
	if (bStretch)
	{ 
		_Pt0 = Line(ptCen, vecX).closestPointTo(_Pt0);
	
	// stretch beams to _Pt0 on certain events
		String sEvents[]={"_Pt0", sGapName};
		//if ((sEvents.find(_kNameLastChangedProp)>-1 || _bOnDbCreated)&& !bDebug)
		{
			bm0.addTool(Cut(_Pt0-vecDir*.5*dGap,vecDir),_kStretchOnToolChange);
			bm1.addTool(Cut(_Pt0+vecDir*.5*dGap,-vecDir),_kStretchOnToolChange);
		}
		
	// Display
		Display dp(_ThisInst.color());
		PLine plCirc;
		plCirc.createCircle(_Pt0, vecDir, _W0<_H0?.5*_W0:.5*_H0);
		dp.draw(plCirc);
		dp.draw(PLine(_Pt0-vecDir*dGap,_Pt0+vecDir*.5*dGap));
		
	} 
	else
	{ 
		bm0.dbJoin(bm1);
		if (bDebug)reportMessage("\n"+ scriptName() + ": "+T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}

// reset stagger value
	if (abs(dStaggerOffset)>0)
	{ 
		dStaggerOffset.set(0);
		setExecutionLoops(2);
		return;
	}
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