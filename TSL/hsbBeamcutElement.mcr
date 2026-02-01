#Version 8
#BeginDescription
#Versions
Version 1.3 15.11.2021 HSB-13777 when splitting the tooling beam redundant tools will be purged, tool drawn on T-Layer, partial beamcuts show X-dimension , Author Thorsten Huck
version value="1.2" date="29apr2020" author="thorsten.huck@hsbcad.com"
HSB-5923 splitting of tool beam supported and will clone tool 
HSB-5926 Image updated


This tsl creates a beamcut based on the selected beam and assigns it to all intersecting beams which are filtered from the element by the given orientation property 

#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords Beamcut;Element
#BeginContents
/// <History>//region
// #Versions
// 1.3 15.11.2021 HSB-13777 when splitting the tooling beam redundant tools will be purged, tool drawn on T-Layer, partial beamcuts show X-dimension , Author Thorsten Huck
/// <version value="1.2" date="29apr2020" author="thorsten.huck@hsbcad.com"> HSB-5923 splitting of tool beam supported and will clone tool, HSB-5926 Image updated </version>
/// <version value="1.1" date="19.nov2019" author="thorsten.huck@hsbcad.com"> HSB-5907 selection improved, bySelection now also supports loose beams </version>
/// <version value="1.0" date="14.nov2019" author="thorsten.huck@hsbcad.com"> HSB-5907 initial </version>
/// </History>

/// <insert Lang=en>
/// Select the tooling beam, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a beamcut based on the selected beam and assigns it to all intersecting beams which are filtered from the element by the given orientation property 
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbBeamcutElement")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Add Beams|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Remove Beams|") (_TM "|Select tool|"))) TSLCONTENT
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
	String sOrientationName=T("|Orientation|");	
	String sOrientations[] ={T("|All|"), T("|bySelection|"),T("|Not parallel|"), T("|Parallel|"), T("|Not perpendicular|"), T("|perpendicular|")};
	PropString sOrientation(nStringIndex++, sOrientations, sOrientationName);	
	sOrientation.setDescription(T("|Specifies the orientation of the beams which will be manipulated.|"));
	sOrientation.setCategory(category);
	
	String sGapName=T("|Gap|");	
	PropDouble dGap(nDoubleIndex++, U(2), sGapName);	
	dGap.setDescription(T("|Defines an additional gap of the beamcut in all directions|"));
	dGap.setCategory(category);	
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
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();	
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
		else	
			showDialog();
		
	// prompt for tooling beams
		Beam beams[0];
		PrEntity ssE(T("|Select tooling beams|"), Beam());
		if (ssE.go())
			beams.append(ssE.beamSet());


	// check if any of the tooling beams has a element reference
		int bHasElement;
		for (int i=0;i<beams.length();i++)
		{ 
			Beam b= beams[i]; 
			Element el = b.element();
			if (el.bIsValid())
			{ 
				bHasElement = true;
				break;
			}
		}


	// declare TSL
		TslInst tslNew;				
		GenBeam gbsTsl[0];		Entity entsTsl[0];			Point3d ptsTsl[1];// = {};
		int nProps[]={};		double dProps[]={dGap};		String sProps[]={sOrientation};
		Map mapTsl;	

	// prompt for beams to be tooled
		int nOrientation = sOrientations.find(sOrientation, 0);
		Beam beamsBySelection[0]; 
		Element el;
		if (nOrientation==1)
		{ 
			PrEntity ssE2(T("|Select beams to be milled|"), Beam());
			if (ssE2.go())
				beamsBySelection.append(ssE2.beamSet());	
				
			if (beamsBySelection.length()<1)
			{
				reportMessage(TN("|Invalid selection, will use all intersecting beams of the element.|"));
				sProps[0] = sOrientations[0];
			}				
		}
		
	// prompt for element selection if tooling beams do not have an element reference
		if (!bHasElement && beamsBySelection.length()<1)
		{
			PrEntity ssE2(T("|Select element or beams to be milled|"), Beam());
			ssE2.addAllowedClass(Element());
			Element elements[0];
			if (ssE2.go())
			{
				beamsBySelection.append(ssE2.beamSet());
				elements.append(ssE2.elementSet());
			}


			if (beamsBySelection.length()<1 && elements.length()>0)
			{ 
				el = elements.first();
			}
		}

	// create by beam
		for (int i=0;i<beams.length();i++) 
		{ 
			Beam b= beams[i]; 
			gbsTsl.setLength(0);
			gbsTsl.append(b);

		// get the element of the tooling beam	
			Element _el = b.element();
			if (_el.bIsValid())
				el = _el;
		
		// add the element to the tsl references
			if (el.bIsValid())
			{
				entsTsl.setLength(0);
				entsTsl.append(el);					
				
			}
			else if(beamsBySelection.length()<1)
			{ 
				reportNotice(TN("|No Element reference and no beam selection found.|"));
				continue;
			}
			ptsTsl[0] = b.ptCen();
			
			
			for (int i=0;i<beamsBySelection.length();i++) 
				gbsTsl.append(beamsBySelection[i]); 


			tslNew.dbCreate(scriptName() , b.vecX(), b.vecY(),gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);				

		}//next i
			
		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion
		
//region Validate

	int nOrientation = sOrientations.find(sOrientation, 0);
	// 0 = all
	// 1 = bySelection
	// 2 = Not parallel
	// 3 = Parallel
	// 4 = Not perpendicular
	// 5 = perpendicular


// validate and declare element variables
	Element el;
	if (_Element.length()>0)
	{ 
		el = _Element[0];
		assignToElementGroup(el,true, 0,'E');// assign to element tool sublayer		
	}
	else if (_Beam.length()>1)
	{ 
		//sOrientation.setReadOnly(true);
		assignToGroups(_Beam[1], 'T');
	}
	else
	{
		reportMessage(TN("|Element reference not found.|"));
		eraseInstance();
		return;	
	}
//	
//	Element 
//	CoordSys cs = el.coordSys();
//	Vector3d vecX = cs.vecX();
//	Vector3d vecY = cs.vecY();
//	Vector3d vecZ = cs.vecZ();
//	Point3d ptOrg = cs.ptOrg();
	
	_ThisInst.setAllowGripAtPt0(false);
	setCloneDuringBeamSplit(_kBeam0);
	// TODO HSB-5923 the behaviour on split of the tooling beam needs to be implemented
	//setEraseAndCopyWithBeams(_kBeam0);
	//setKeepReferenceToGenBeamDuringCopy(_kAllBeams);
	
	Beam bmTool;
	if (_Beam.length()<1)
	{ 
		reportMessage("\n"+ scriptName() + ": "+ T("|Requires at least one beam.| ")+ T("|Tool will be deleted.|"));
		eraseInstance();
		return;		
	}
	else
		bmTool = _Beam[0];
//	for (int i=0;i<_Entity.length();i++) 
//	{ 
//		bmTool = (Beam)_Entity[i]; 
//		if (bmTool.bIsValid())
//		{ 
//			setDependencyOnEntity(bmTool);
//			//_Beam.append(bmTool);
//			break;
//		}
//		 
//	}//next i
	if (!bmTool.bIsValid())
	{ 
		reportMessage("\n"+ scriptName() + ": "+ T("|Requires at least one beam.| ")+ T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}
	Vector3d vecXB = bmTool.vecX();
	Vector3d vecYB = bmTool.vecY();
	Vector3d vecZB = bmTool.vecZ();	
//End Validate//endregion 	
	
//region Beams
	Beam beams[0];

	if ((nOrientation == 1 || !el.bIsValid()) && _Beam.length()>1)
	{
		beams = _Beam;	
		
	// Trigger AddBeam//region
		String sTriggerAddBeam = T("../|Add Beams|");
		addRecalcTrigger(_kContext, sTriggerAddBeam );
		if (_bOnRecalc && (_kExecuteKey==sTriggerAddBeam|| _kExecuteKey==sDoubleClick))
		{
			Beam _beams[0];
			PrEntity ssE(T("|Select beams to be milled|"), Beam());
			if (ssE.go())
				_Beam.append(ssE.beamSet());						
			setExecutionLoops(2);
			return;
		}//endregion
		
	// Trigger RemoveBeam//region
		String sTriggerRemoveBeam = T("../|Remove Beams|");
		addRecalcTrigger(_kContext, sTriggerRemoveBeam );
		if (_bOnRecalc && _kExecuteKey==sTriggerRemoveBeam)
		{
			Beam _beams[0];
			PrEntity ssE(T("|Select beams not to be milled|"), Beam());
			if (ssE.go())
				_beams.append(ssE.beamSet());	
				
			for (int i=_beams.length()-1; i>=0 ; i--) 
			{ 
				int n = _Beam.find(_beams[i]);
				if (n>-1 && _Beam[n]!=bmTool)
					_Beam.removeAt(n);
				
			}//next i	
			setExecutionLoops(2);
			return;
		}//endregion			
	}
	else if (el.bIsValid())
	{ 
		beams =el.beam();
	}

//region collect beams to be milled
	Beam _beams[0];;
	for (int j=0;j<beams.length();j++) 
	{ 
		Beam& b = beams[j];
		if (b == bmTool)continue;
		
		Vector3d vecXBB = b.vecX();
		if (nOrientation==2 && vecXB.isParallelTo(vecXBB)) {continue;}// not parallel to tool beam
		else if (nOrientation==3 && !vecXB.isParallelTo(vecXBB))  {continue;}// parallel to tool beam
		else if (nOrientation==4 && vecXB.isPerpendicularTo(vecXBB))  {continue;}// perpedicular to tool beam
		else if (nOrientation==5 && !vecXB.isPerpendicularTo(vecXBB))  {continue;}// perpedicular to tool beam

		_beams.append(b);
		//b.realBody().vis(nOrientation);
	}//next j 			
//End collect beams to be milled//endregion 

//region Tool
	double dX = bmTool.solidLength()+dGap*2;
	double dY = bmTool.solidWidth()+dGap*2;
	double dZ = bmTool.solidHeight()+dGap*2;
	
	if (dX<=dEps || dY<=dEps || dZ <= dEps)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|Invalid tool geometry|"));
		eraseInstance();
		return;	
	}
	Point3d ptCen = bmTool.ptCen();
	BeamCut bc(ptCen, bmTool.vecX(), bmTool.vecY(), bmTool.vecZ(), dX, dY, dZ, 0, 0, 0);
	_beams = bc.cuttingBody().filterGenBeamsIntersect(_beams);
	bc.addMeToGenBeamsIntersect(_beams);
	
	// HSB-13777 purge beams when no intersection found
	if (_beams.length()<1)
	{ 
		if (bDebug)reportMessage("\n" + scriptName() + ": " +T("|no beams to be milled found at location| ") + ptCen);
		eraseInstance();
		return;
	}
	
	if (bDebug)bc.cuttingBody().vis(6);		
//End Tool//endregion 	
	
//region Get intersecting range to display only the tooling range
	Point3d ptStart = ptCen - vecXB * .5 * dX;ptStart.vis(1);
	Point3d ptEnd = ptCen + vecXB * .5 * dX;ptEnd.vis(4);
	
	Point3d pts[0];
	for (int i=0;i<_beams.length();i++) 
	{ 
		Beam b = _beams[i];
		Quader qdr(b.ptCen(), b.vecX(), b.vecY(), b.vecZ(), b.solidLength(), b.solidWidth(), b.solidHeight(), 0, 0, 0);
	
	
		Point3d _pts[0];
		for (int k=0;k<2;k++) 
		{ 
			Point3d pt = b.ptCen() + (k==0?-1:1)* qdr.vecD(vecXB) * .5 * qdr.dD(vecXB);
			double d1 = vecXB.dotProduct(pt - ptStart);
			double d2 = vecXB.dotProduct(pt - ptEnd);
			if (d1>=0 && d2<=0)
			{
				pt.vis(3);
				pts.append(pt);
				_pts.append(pt);
			}			 
		}//next k
		
	// HSB-13777 if the beamcut intersects only partial over the section of the beam	
		if (_pts.length()==1)
		{ 
			Body bd(b.ptCen(), b.vecX(), b.vecY(), b.vecZ(), b.solidLength(), b.solidWidth(), b.solidHeight(), 0, 0, 0);
			PlaneProfile pp = bd.shadowProfile(Plane(b.ptCen(), vecZB));pp.vis(2);
			if (pp.pointInProfile(ptStart) != _kPointOutsideProfile)pts.append(ptStart);
			else if (pp.pointInProfile(ptEnd) != _kPointOutsideProfile)pts.append(ptEnd);		
		}
	}//next i
	
	Line lnX(ptCen, vecXB);
	pts = lnX.projectPoints(lnX.orderPoints(pts, dEps));
	if (pts.length()>1)
	{ 		
		ptStart = lnX.closestPointTo(pts.first());
		ptEnd = lnX.closestPointTo(pts.last());

		ptCen = (ptStart+ptEnd) * .5;
		_Pt0 = ptCen;
		dX = abs(vecXB.dotProduct(ptEnd- ptStart));
	}

	vecXB.vis(ptStart,2);
	vecZB.vis(ptStart,150);
//End get intersecting range to display only the tooling range//endregion 

//End//endregion 

//region Display coordinate axises
	double dAxisMin = U(20);
	Point3d ptAxis=ptCen;
	double dXAxis = .5*dX;	if(dX > dAxisMin*2) dXAxis = dAxisMin*2;
	double dYAxis = .5*dY;	if(dY < dAxisMin) dYAxis = dAxisMin ;
	double dZAxis = .5*dZ;	if(dZ < dAxisMin) dZAxis = dAxisMin ;
	
	PLine plReference (ptCen - vecXB * .5 * dX, ptCen + vecXB * .5 * dX);
	PLine plXPos (ptAxis, ptAxis+vecXB*dXAxis);
	PLine plXNeg (ptAxis, ptAxis-vecXB*dXAxis);
	PLine plYPos (ptAxis, ptAxis+vecYB*dYAxis);
	PLine plYNeg (ptAxis, ptAxis-vecYB*dYAxis);
	PLine plZPos (ptAxis, ptAxis+vecZB*dZAxis);
	PLine plZNeg (ptAxis, ptAxis-vecZB*dZAxis);

	Display dpAxis(_beams.length()<1?1:7);
	if (el.bIsValid())// HSB-13777 draw on tool layer
		dpAxis.elemZone(el, 0, 'T');
	dpAxis.draw(plReference);
	
	dpAxis.color(1);		dpAxis.draw(plXPos);
	dpAxis.color(14);		dpAxis.draw(plXNeg);
	dpAxis.color(3);		dpAxis.draw(plYPos);
	dpAxis.color(96);		dpAxis.draw(plYNeg);
	dpAxis.color(150);	dpAxis.draw(plZPos);
	dpAxis.color(154);	dpAxis.draw(plZNeg);		
//End display coordinate axises//endregion 

	
	
	

#End
#BeginThumbnail
M_]C_X``02D9)1@`!`@``9`!D``#_[``11'5C:WD``0`$````9```_^X`#D%D
M;V)E`&3``````?_;`(0``0$!`0$!`0$!`0$!`0$!`0$!`0$!`0$!`0$!`0$!
M`0$!`0$!`0$!`0$!`0("`@("`@("`@("`P,#`P,#`P,#`P$!`0$!`0$"`0$"
M`@(!`@(#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#
M`P,#`P,#`P,#_\``$0@!+`&0`P$1``(1`0,1`?_$`-8``0`#`0$``P$`````
M```````("0H'!@($!0,!`0`#`0$``P$````````````&!P@%!`$"`PD0```&
M`@$!!`0("@<%!`L```$"`P0%!@`'"!$2$S@)(11VMA4U=[?7&'BX,;$B='46
M%S>76$$CU5:65YAA,B24U%%SM3E"4C.S-+0E)C8H"A$``0($`@0)"`@#!04)
M`0```0`"$0,$!2$&,4&Q$E%A<8%R$W,U!R(R0E*R,W0VD:'!T6+"(S3P%'6"
M0\,5%N%38R0(DJ*#H[/4)956%__:``P#`0`"$0,1`#\`W\81,(F$3")A$PB8
M1,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")
MA$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(
MF$3")A$PB81,(F$3")A$PB81,(F$3"+SMMM]4H-;E[C>;-`TZI0#47TY9K1+
ML(*`AV8*$2]9DI:37:L&2(JJE(!E%"@)S`4/2(!@D`1.A`(X#2HER6ZMM[C,
M+'1L`XU=KY<J(K[SVK6'B%HFFAW0HO$]2:2FR1<RBN=JDN"%@N98UFT<>K.&
M\%86"YC%C-RS+2TL95)";/X?0'/Z7(/I"[M%8JBHA,J(RY7_`'CS:N?Z%S>:
MT'KVDM'NP"[2VA1MK*`W4F.1/Z_K/-G6-=LH=RA&6AM8&<QKZZ5-%9=V:-I[
MRO.JI"J/G!H6*CU3E.6)?ZCN4F>:I\W#6T^9#@#=7*/*/"5(O\DH9DH2&R\>
M$>=RQ^PX<2[!Q+W]:MTM]GP5Q2KK^7U9:XJO(W6KQTI6XN^1,Y7V=@CYM2CR
M\C87E+D6OK*C-=J$Q*I..X*[*=MZP+%K/+)=6WBB_FVM+(/+2.,`8CB,=>*B
M-TMYMM5_+EV]Y(<.0QP/'@I?9UUSDPB81,(F$3")A$PB81,(F$3")A$PB81,
M(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$
MPB811&LW*(+(_E*CQKK37<]EC7KB(FKXO*JP>@J/*,WGJ4HSG=E-64J:[62&
M40=)+053:S3MK)M?49A:#!8KHG)N%ZHK<"V8[>G^HW$\^H<^/`"NC16RJK3%
M@W97K'1S</-SD+R$9IX'L_';)WE<G&XM@5]RM+0+^;8(UW66MG0BX4!QJW5J
M3^2@JFYCD'2R*$Y).9NW`S5.W7FUV_1,L"N5\K+A%KSN4_JC1SG2>?#B4NHK
M52T<'-&].]8Z>8:MO&O$;(Y1URO]_&4=)&T2Y>VF:3.8Y:\T4`!`#)J)F(M+
MF*8/P)"FB8!Z@J/X,C$ZN8SR97E.X=7^U=R73.=B_`?6H,6NZ6>[R(REGF'4
MJY_*!$JI@(U9IFZ=46+)("-6:0]`Z@F0O:'TFZB(CG+F3'S7;SS$KW-8U@@T
M04Q_+@^,>2GMIK[W`9Y;F1NY3V[MC57>:N\QV3=KE9_DR4:3")A$PB81,(F$
M3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB8
M1,(F$3")A$PB81,(F$7`MH\BJ5K>93I$<PL&SMM.V*,E'ZCUNV8S%P)&NCJ)
MM)RU.I&0B:IK:K.SMU00E;+(Q+!XJ@H@T4<.@*W-Y:NMI:&7UE4\-;JX3R#2
M5Z*>EGU;]R0TN/U#E.@+@\GKW9.[!47Y&V./0IRYG)$N.^KY271UFX8G62!%
M#:UV=LH&Y;N57;)*IN8Y5M`4YTT>G:/8&1.@D_4@URS/4U,95%&5)X?3//Z/
M-CQJ5T5BD2(3*J$R;P>B/OY\.)?;NNY-<:BC&U:BT6*[R&8-XN)IU81:-&,,
MSCT"M&,<J#5,L=`,62")$R-RD[Q)("@1'L@'2'3ZN7+)WCO3/XTG^"I)*D.>
M,!!G\:%!+8>Y;KL=51*4?>H0O;`R-?C#*(1Q0*(B0SK\H5I!<OX>TL8P`/I(
M4GX,Y,ZIFSO.,&\`T+WRY+)>C3PKE&>=?JOT(Z*D)986\<T6=*E*)S]V7\A(
M@=>JBRIA*FB3T?A,(!USY`)T+X)`TJ;_`)<'QCR4]M-?>X#/+?R-W*>W=L:J
MZS5WF.R;M<K/\F2C281,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(
MF$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3"+G&S=N:YT[!MI_8UH
M:5]I)/R0\#'D:R,W9[;/*H+.6]9HU,KS*5M][M;QNV4.WBH9B^D7!4S"FB?L
MCT^DR9+E,,R:X-EC228`<Z^S&/F.#)8+GG0!B5&&4L>_-Z%,@3X8XQZI=IN4
MEVS9S"R7(^Y,5TR(E*O+L%IVE:*BW)2K=0CU;!9UVKE%5)[6I%N=+(A<LTM;
M&5;A%WKD8?V1KY3#D*DE%E]SH3*TP'JC3SG5R#Z0O[HDTWQRK3AG&LXRK-I)
MZZG'S=N=Q*VZZ6!T"9)"QV"4D'#VS72TRJB1/79B5<N7;E3H=RY$>IL@]76N
M>\SJMY=,/#B>;B^H*5T],UC1*IVAK!P8#^/K41MD\E[9;O6(RL@K4H!3M)B9
MNMUG7R/7I_Q,@GT!B10``13;=DP=1*950HYQ)U;,F>2SR6?6NC+IFLQ=B[ZE
M&D1$PB8PB(B(B(B/41$?2(B(^D1$<\2]*_,F)F(K\<YF)V4CX:*9@F+N2E':
M#%BW[Y9-L@"SIRHFB0R[A8B9`$>IU#E*'4P@`_>7+F37B7*:73'&``$23Q`+
MZO>R6TOF$-8-).`"[[J?BQO#=HM)-PR?Z,UNLLB=6TW:!4+L^PQX+&3>)TK6
M,P1LO4E52$4*C*VQ)([=8A%2P4FT5(J,]L^1YTZ$^[$RY7J-\X](XAO((GD*
MB5RS3*EQE6\;[_7/FCD&D\N`Y5^CI=BM':JB6+J3?SCQ@:S1;F>EBQQ9F;-#
MV*:B49.8-$L(J.4DG+=D0510;((]KKV$R$Z%".761*IKC/IY#=V2R8X`<`!P
MTX_2NU;YLR?1RITTQF.8"3QE=S\N#XQY*>VFOO<!GEAY&[E/;NV-4.S5WF.R
M;M<K/\F2C281,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$
MPB81,(F$3")A$PB81,(F$3")A$PB81,(ORYN<A:S#2MBLDO%U^OP4>[EIN=F
MY!I%0T/%1Z!W3^3E9-^LW91\>R;)&4666.1--,HF,(``CA%#^3Y`;%VZ"K#C
M;`LH:GN$U4_K%;0AI(:L[*9,W=N]1ZN!W`6K:"!SEZ)S$BZKU<4261>QSB=0
M[:!H[<<QT=%&7(_5J!J!\D<KOL$>`P7:HK)4U4'S?TY/'I/(/M/UKZ=>UG0-
M6/)/9=IG92W;!>,#,+'NC:DJRF;P^8+"R47A(UV@QB:_1ZL]>QZ3D*W5XZ%K
MP/NTNC'D754.>!W"Z55:[K*M_D#0-#1R#[3$\:EU'04](-RG;Y1TG2X\I_@+
MA>R>5AS^L1.MVPIE_+2-9Y)`!./HZ=Y%1BQ1*3H/I*HY*/\`W0?AR/3J_P!&
M3])^P?>NO+I=<SZ%#64E9.;?+R<P_=R<@Z/VW#Q\X4<N%3?T=I54QC=DH>@H
M?@*'H``#.<YSG'><8E>L`-$!@%^?GU7RO;:MU3LW>RP%U9!H*5OO00>;3LOK
M+'6[``<$0=&A7:!?A#8\FS*1P'JD(55F1XT,SD)"+4.50)59\IW&YPG31U%&
M?2<,2/PMTGE,!K!.A<"XYAHZ&,N6>MJ!J!P!_$[[!$\,%:#I3AOJ_4SV/MLV
M"NT-GLC^LM;S;V;4S>LNCD7*H37-33[Z#HJ"0/7"*;Q,'5@69*@W?2CTB9!+
M:-KL=NM#(4C/U88O=B\\^H<38#B4$K[I67%T:AWZ>IHP:.;7RF)XU+?.NN<J
M7=6?N])^F+[[ZV7*0OG>]3VS]I5I6KNZ1V;=B['Y<'QCR4]M-?>X#/)[D;N4
M]N[8U1+-7>8[)NURL_R9*-)A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3
M")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A%%6Y\GX\\W+4'0]8-O
M38T,]7B;"I&S1:_J'74LU.)'D?M#;H1L[&Q4XP/V2+U^"8V*UMS+MU7$4@R5
M,]3YEPNU%;F_KNC-U-&+CS:AQF'%%>ZCMU56G])L)>MQP'^WD"YRAII];YAA
M=N15O3W%98:09SM<K)HD:UH_7,K&I=EI*4C5JLG-H.[`Q.!ETI^S/[#/,W"J
M_P`'NX]HKZDG`[E?ZROBP'JZ;U0=(_$=?U#B4NHK134<'D;\_A.KD&KZSQKS
MVR>3E6JP+QE0*A;)PG:3%RFH/ZO,E`ZAU5>I&`\F8H]![#8>[,'7JL40Z9%9
MU=+9Y,ORG?5_M7?ETSG8OP;]:@E<;[:[Z_\`A"SR[B0.03>K->H(QS$H^CL,
MF"79;-^I0`#&`O>'Z=3F,/ISE3)LR:8O,5[62V,$&A>/S\U]US"P[:K,"[4:
M-F=CM`1UBB*M:9&I03N;K]#F9])0\(PO=G2!.NUB4E5`2*VC5W02S@C@BZ;4
M[8JRZ4JRUDZ]9IK9=';VM8V8Z`F3"6LX28@$F`!)W0=$-,`HYF'-%JRW0S*V
MN<YW5-B6,`<_@`@2`(D@>41ICH4!^?NU+<&F;3&PDH[K\5,4S82,BWC5Q0<O
MT$*TH*:+I\F!'/<CWQ@.FF8B:A3=#@<,VMX9^"N4\NT-;<KE+;<;Y)I7.9,F
MM'5RG;C\94HDM!!`(>_?>TC>86:%C7Q*\8LTWVOH+=;9CJ"RSJMK7RY3B'S&
M[[,)LT0<002"QFZQP.Z\/TK;BBBDW2200230003(BBBB0J:2*290(FDDF0"D
M333(4`*4````.@92*T$OZ81,(J7=6?N])^F+[[ZV7*0OG>]3VS]I5I6KNZ1V
M;=B['Y<'QCR4]M-?>X#/)[D;N4]N[8U1+-7>8[)NURL_R9*-)A$PB81,(F$3
M")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81
M,(F$7$=J<@=?:H?,JT_4E[ALJ:8ED:UJ'7S!*S;,L+!5=RR0ER00.V3.M5,\
MBT.U5L4\[B:VT<]E-U((&,4!\]35T]'+ZVI>&,X]?$!I)X@OVD4\ZI?U<AI<
M[BU<IT#G4?9&K[@W>(+[OL(4"@J+$71T-J2QRK=.79]A4`9;CVXU1@[/=$%Q
M[I1>#@4H""$!782)[$Q/VSPBY9HG3HRJ`&7+]8^<>34WZSQA2JBL$J5"95G?
M?ZH\T<O#]0XBO[V396JM%UZ,I\%'0\:WKT8TB*WKVE1\=%QT'%L42MHZ,;1T
M<DVB*U$LD"%(FB4A.[2``22,``&0RHK&,)=,)=-/'$D\94FE4[G`!@`8/HYE
M!W8V\+KL8RK1VZ^!Z^8WY%?BSJ)M5"E'J3X1<#V7$FH'H$04$$0,4#%3*.<B
M=539V!P9P#^,5[Y<EDO$8NX5QS/,OV7GI:RLHV3AJXU:RUDN=G.X1J5"J<8Z
ML=WMCAKW`.BP5<C2*OEV<>+I(SY\J"4;&(G[]ZX;-RG5+[J"W5MRG=112W/?
MKX!QN.@#EYEY:NMIJ*7UM2\-;JX3Q`:2IF:BX!;$V-ZK8.2\X\UQ45!*NAHO
M65G.E<91'H"B26U=S5MTDO#]04#OX:DN$!0<M@']99!FLLS&S;/DJCHX3[D1
M/J/5_NQS'%W/A^'6H/<LS5%3&511E2>'TSS^CS8\:]QYBE#I.LN'56H^NJC6
MZ+38#<.HVL)5JE"Q]?@(M`]L[]0C&*BV[5DW[Y=4RB@E(!E%#F.81,81&V\G
M`-S'2-:`&ASH#^PY5CG(DY;JR<26M]MJS%\\OW1RWL?L?W9S5EB[LN?PCO8F
M+)&8N]+5\8WVY:W?YB];<3")A%1KQTFW5ET13;&^3;I/K!'STV\2:$43:I.I
M6P33]PFV(LJNL1N19<0(!SG,!0#J81].4A?.]ZGMG[2K2M7=TCLV[%(ORX/C
M'DI[::^]P&>3W(W<I[=VQJB6:N\QV3=KE9_DR4:3")A$PB81,(F$3")A$PB8
M1,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB\+L39M!U-
M7#6S8UJB:G!"_8P[1S)K&]9F)Z55%O#5FN1;8B\M9K7/.P!".BH]!S(R#@Q4
M6Z*JIBD'ZN>UC2]Y`8!B3@!RE?+6N>X-8"7'0!B5%J0V!OC=I^[IK:5XVZK5
M,`A;;%$1$ER$NC(1[U%Q6J3-M9FH:6AGJ94C%<61O-V59NNNV<0<`]12=#$[
MEFF5*C*MX#W^L?-'(-)^H<JD5#8)DR$RL.ZSU1I/*=6WD7PBX73?'"NOCLDT
M($TTY^$9R9E9.6M>P]A3:*!&_P`,6VVV%[,WG8-C%`"(F?RCQXNFB!"&5(D0
MH%@M;7S)SS/K)A<\\.P#4.(8*64U)+E-$JF8&L'!]I^]17V3R>LUF]8BZ:1:
MJPIA,F+X%"C87J0]0ZF<)"9**(</_00$R@"'_MA`1#.'.KGO\F7Y+?K_`-BZ
M4NF:W%^+OJ47E%#JG.JJ<ZBBAS****&$YU#G$3'.<YA$QCF,/41'TB.>)>I?
MR.<B9#**'*F0A1,<YS`4A2@'43&,80`I0#\(CGWE29M1-;(D-<^<\@-:T$N)
M.@`#$DZ@,5^<V;*D2W3ISFLDM!)<X@``:22<`!K)7Y6@8MQR^W';],:RV"WH
MD/KJLLK%LK8B$`2?LJ2<O..J^QK>LXF<1"KDL`FC7JZDW+I2<;'*((%"*E2.
M%?5;='A%?K+34EQS=+--*K&N?*D[PZTM;NXS(1ZL.WA!L>LT[P80(UC3^*5A
MOU566_*TW^9F43VLFS=TB4'NWL)9,#,+=PQ=#<T;I>"87GZ/XV:>X\QTBWUK
M52-)RP@U-<;Y./'=EV+>'#+OC-5K;=IE5W.RC5@HZ5]18`JG%Q*2HH1[5JV`
MB)932TE-121(I6-ER1J`ASGA/"3B=:YD^HG5,PS:ASGS#K)_B`XA@%W;/0OQ
M5;_FF>&.-^6G4/O03)+D_P"9*7IN]ARC.<?EJKZ#?;:LL'/+]T<M['[']V<U
M78N[+G\([V)BR3F+O2U?&-]N6MW^8O6W$PB814.\4_#3K#V7=_\`B<IE(7SO
M>I[9^TJTK5W=([-NQ2C\N#XQY*>VFOO<!GD]R-W*>W=L:HEFKO,=DW:Y6?Y,
ME&DPB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,
M(F$3")A$PB^J^?,HQD\DI)XUCXZ/:N'S]^^<)-&3%DT2.X=/'CIP=-!LU;()
MF.HH<Q2$(41$0`,(H>2O).T;2[47Q;@HV=A5C*HK\B+ZQDBZ99%26414<Z[@
M6CZ"M._5C@4BC9S%.8JHNVZHJ(V)59$S,_!N68*.@C+8>MJ/5!P'2.KD$3Q!
M=>BL]35P>[].3PG2>0?:8!?D5_550HTNMM?85GD]B;.0BW$<]V_L][&+2T/$
MO%>]>PE*C&3.)INKJV_$B)'+"NQ\8G*"U;JR`O7:?K)H%<;O5UYWJI\)(T-&
M#1]YXS$J74=NIJ,0D-C,/I'%Q^[D$`N.;)Y6((]_$ZV;`X5#MI'L\DW$&Y/1
MT[R)C%@`ZY@$>H*.2E(`EZ=R<!`<CDZO'FR?I/V#[UV9=+KF?0H6S4Y,6*07
MEIV2>2TBX'^M=OESKK"4!$2IE$XB"2*?7H0A0`A`]!0`,YKG.>=YQ)*]C6AH
M@T0"_'44313.JJ<B221#****&*1--,A1,<YSF$"D(0H"(B(]`#/C3@%\K^NN
MJIMK?Q"?5YHB=OA'!B$_:];G[NGZ,:)B<`4=1MS+&2TMLLQ$TUR)DJ,=--2O
MD/5'[R,$_?DE=JRA<[@1,GCJ*4ZW#RB/PLP/.Z`UB*C]PS%0T8+)1ZV?P-.`
MY7:.81/#!<"V36=@ZSVOMO45]V$SV&^H%JK#$DW"U).B0*B=AU)K2]K-(NL_
M#=G?M8]A*6QP1$7TK)NQ*'4RXAV2$UCX3Y3L=GM3J^FD-=<S-<TSG`.F;NZW
M`'T!B8AH$=<5E[Q5S)>+C=FT$^<X6X2FN$II@S>WG8D>D<!`NC#5!=,\DKQ3
M\NO82G_.+?,F/CCYEE^%F?X2A_@-[R^_%R]LY:7<H-:&3"*M_P`TSPQQORTZ
MA]Z"9)<G_,E+TW>PY1G./RU5]!OMM66#GE^Z.6]C]C^[.:KL7=ES^$=[$Q9)
MS%WI:OC&^W+6[_,7K;B81,(J'>*?AIUA[+N__$Y3*0OG>]3VS]I5I6KNZ1V;
M=BE'Y<'QCR4]M-?>X#/)[D;N4]N[8U1+-7>8[)NURL_R9*-)A$PB81,(F$3"
M)A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3"*,M^Y-0$
M18)776IZ^]W?MF(5,RFJS59!NPIVOI$4V9R);CVBN@]K6NE44I-JY5B"$D[@
MO'+>ML(-^B0XASZZYT=N9O5#O+U-&+CR#[3`<:]E)05-:Z$EODZW'`#G^P1*
MY&MIZ?VBZ0G^3=G9;-,BZ:R<5I^'8N(?C[3W3-TC(1YS4UZX=OML6&(>-&JQ
M)FVK/TD9)F1_$1D"=0S<L$N68JRMC+E?I4_`#B>5WV"`X8J6T5EIJ6#YGZD[
MA.@<@^TX\B^CLGDI4:?W\;712ML^3MIF*T7#X%8JAZ/^+D4^T5R<AOPI-^WZ
M0$ICICD2G5LN7Y+/*?\`4I#+IWOQ=@U0.N^Q[?L)Z#NS2JKI-,XG:1J'5O%,
M>H"7_A&)#"F4_8'H*ANVJ8/]XXYRILZ9.,7GFU+W,ELEB#0O"F,4A3'.8"E*
M`F,8P@4I2E#J)C"/0```#TCGY+[KS6O'-\W]**0?&:A.-N`@N#>3V0YDS5/0
MM;/V^R<97;"L;,(V1<@IK)F:52/LKU!TD*3I%J'50O?MF7;A<IFZUI8P:21B
M.480X8.()&+0Y<BNO-)1,WB=YVJ&@\AU\$0"`<"0K)]+^6]3H99"U<F;43D?
M<2JH.VE/>U]*L\?*DX0.*B(06I#OYPUR>HJD16!_<I&QJMWK<KJ,2BA,*(6C
M:,M6^U0F!H?5#TG8D'BX.4`8:0H)<;W65\6%V[(/HC`'EX>0DJRLA")D*FF4
MI"$*4A"$*!2$(4`*4I2E``*4H!T``]`!DB7&6:+EYXR>4GMWKC[MFB\N_P`/
M.X7?$/\`98J,\1?F`?#L]IZ^7DE>*?EU["4_YQ;YGM\<?,LOPLS_``ES/`;W
ME]^+E[9RTNY0:T,F$5;_`)IGACC?EIU#[T$R2Y/^9*7IN]ARC.<?EJKZ#?;:
MLL'/+]T<M['[']V<U78N[+G\([V)BR3F+O2U?&-]N6MW^8O6W%PC;_)O0VA7
MD-&;9V7!5*8GTP=QD$9.2FK">'*[*Q=6AW7ZZPEYJ,I46\4*F^G'2",/'F,'
MK+E+J'7VT5NN%Q<YEOD39[F-+G"6QS]UHUG=!@.5>*MN5NMK6/N,^3(:]P:T
MS'M8'..H;Q$3R+KU=L=>M\##VJI3T-:*Q88YI,0%CKLHQFX&<B'Z)'+"4AYB
M,7<Q\G'/6ZA5$5T5#I*$,!BF$!ZYXR"#`Z5[001$:%1MQ3\-.L/9=W_XG*91
M]\[WJ>V?M*M*U=W2.S;L4H_+@^,>2GMIK[W`9Y/<C=RGMW;&J)9J[S'9-VN5
MG^3)1I,(F$3")A$PBX1RFM=AH?&/D;>:E)JPMKIFA]O6NL3""3==:)L-=U]8
M9B%DT47B+AHLJPDF:2I2JIJ)F$G0Q3%Z@)%7EY,_(W=7)316TK7O"^2%_L$#
MMI2O1,E(1\)'*LH8M.K,D#$B4%%Q3<Z8/7RJG:.0Q^I^G:Z```17"81,(F$5
M`6H>7/(NQ><3>N.$UL^4?Z3BI_9;2/H2D56TX]LWA->O)B*2+((0J4X8&<DF
M54!,Z$3"'0PB7T817^X1,(F$3")A$PB81,(F$3")A$PB81,(F$3")A%QW:^]
MM=Z=)&LK-(O92Y6-N_6I.L*?'.+3LZ^'C3LT'H52F1G>2;J-CW4DU)(2S@&T
M'"D<$7DWK)KVER_C/J)%++,VH<&2QK/\8GB&*_65)FSWB7):7/.H*.<M'[NW
MHJ<VR9F1TAJU7O.XU'K.TK(;,LS10Q3MQVMN:MN&SFLAW79[Z"H[A`$'"9BJ
M6269*F;Y"[EFF8^,JW#=;ZYT\PT#E,3Q!2BBL#&0F5IWG>J-'.=?(,.5?WF+
MIJ#CY66%0@8J"KC")07^`M>T>*C8M!F1VY6?+&2B8U-I&PZ#Q\Z57444!,5E
M#J*`"B@FZPFIK`UQ?.<73CPF)/*3]JE$FG):&RFALL<P'(H3[(WU==ABNQ[\
M:_7%!$H0<6LH'K*77J`2K_HFO(B/]).B:'H`>[[0=1X\ZKFSL-#.`?;PKWRY
M#)>.EW"N(9Y5^Z\C:+]2J2K#-[;:8.ONK$^1C(!E)R#=L_FWR[Z.C"-XIB8_
MKD@8CZ7:I*"D0Q4C.$^V)0,`CT;9:;E>:IM%:Y,R?5.(`:T1T\)T#E)`7AN%
MRH+53.K+C-9)IF`DN<88#ZSR`$J%/.?=LS6]`[$:4XJ#?X=J%SA'DH];`NN1
MBYI\X=Q\'ME![E%50$^SWBI5!`HCT(4W0P:L\-_^GND+)]USM,+ZBGIGS64T
MIT&![1%O6S!BZ!QW)9:(@1>YL0<O^(OCU5RGTULR:P,DU%6R4^HFMBXL<?*Z
MJ6<&Q&&],#C`F#&N@1L?AH6'KD6RA("+CX6'C4"-8^+BF:#"/9-TPZ$1;-&R
M:2"*9?\`L*4/3D0E2I4B6)4EK62FZ`!`#F"L:9,F37F9-<7/.DDQ*_3S]%]$
MPBS0<O/&3RD]N]<?=LT7EW^'G<+OB'^RQ49XB_,`^'9[3U\O)*\4_+KV$I_S
MBWS/;XX^99?A9G^$N9X#>\OOQ<O;.6EW*#6ADPBK?\TSPQQORTZA]Z"9)<G_
M`#)2]-WL.49SC\M5?0;[;5ELYQ1[^7UDXBHIB\DY23K=^CXV-CVRSU_(/WM?
M(V9L6+-L15P[>.W"I4TDDRF.H<P%*`B(!FK<OL=,M]R8P$O-*0`,226O@`-9
M*R/F5[9=RM;WD-8VK!).``#I<23J`5[/)/S/;3,,7[#39SZ3U_WAVYMM7>*:
M+[1M3<R0G(IKW7$NU?LJ2@X`Z9TW-@:OYHR??(JP<<J1-UE.Y2\'*^X.;59B
M+I,@XB2PCK"/QNQ;+'%B[4=PJZ,X>--OMS74N7`V?/T&<\$2VG\#<'3#QX-U
MC?"HQN_(9^[=S@T@LHV>V%\K(6:_6B1>V/8%ND3E!$9.9L$TZDY9X[*W*5))
M9VY<N$FY$TTS(D3(F72-ERU:[)2MI*&2R5(;Z+1I/"X^<]W"7$GE68[YFFZW
MVK=5UTZ9-J'>DXX@<#6CR6-X`T`<`"T8>4[-W>-\KC5%AHE49[$N#J[<CY>%
MK\S;2TYE9D)[F%N1VM**V]>&L9&Z2T)(J2**_JK@'O0A2F`%@5#&'B%,DS<Z
MW)].YKI)J70+2"-`!@1AIC'CBMN^',N?*R-;&5+7MG"E;$.!#M)(B#CHA#B@
MH"<8]@\F4..^N$8[C?3I!@2MNBMWRO(!HQ5<)_",D(J&9CK%R*`@81#L]X;\
M'X?3F:+U*I#=:DOFN#NM=$;D88\.]BM`6Q]0*"2&RP6]6WTH:N122\OO9'*I
MG(<AA@N,%)FS+6^B&?@YY',X<&*I*,T(@DD)M4OO7"K(_EB;HGV!_)Z#^')Q
MDMLIMG(DN+V=<[$C=U-U1*BN9G3'7$&8T-=U;<(QUG7`*R']JW,K^4+7_P#J
MH8_0SDM4>3]JW,K^4+7_`/JH8_0SA$_:MS*_E"U__JH8_0SA$_:MS*_E"U__
M`*J&/T,X1/VK<ROY0M?_`.JAC]#.$7<M6V/:5EAY!UM;64+JZ90DA;QT1";$
M1V0WD(SU5NH$DK*HU6IE8K"Z.HEZN**@]E,#]O\`*[($7-.:G@WY:?9FWQ\U
MEJPBHJ\HK:6QM/<$.0]WU9IV>W=;H_>*I&E1@7K5HHV2/KNJ&4FWZ`F5FI5A
M'&(43,XQLZ?.#&`I2ID$ZZ4Z\.LLY?S;FF19LS7>19K5,/E3YK7.!,1"6TX2
MV.?C"9.>R6R!)+C!CH%XDYHS%E#*D^]Y7L\^]W:7YLB4YK2!`QF.&,Q[60$9
M<ECYCR0`&B+VV0\7^8?+7:VD:E?I3A_9-AOYZ0N_?VJJ;(TS0J^Y^"[_`&F&
M3BHZIW:\,K9%$K",<6+/Z^05UU69EA.H"@*&N#Q*\)?"S*^<ZJQ4N;*>@D2)
M=-"3/I+A4S1OTLF87OGT],Z0\SB\SAU1W6MF!@#=W=%->&/B_P"+&:LDTE^J
MLH5-PGSYE3&?(K+?2RCN54^6&,D5-2V>SJ0P23UHWG.EEY+M[>/?OV_\I?Y"
M=B_QWXX?2%D$_P!">&?_`.YM_P#];=O_`&JGO^OO%#_\'<?_`+.T?^[4<-3<
MT^5-KYB;!T79N*D^A0XA]3R2#AG.59U-:63F:)6)M=:VW.)F7NN+:QE#/C22
M#)L]1E4T'@II^LJI`U"P\T^#WAC:_"2@SM;LSR'7R:R?NATN<V7<#+J9TL"1
M3OEMJY#F;HDNF/END%TO>=U;7&::ZRIXS^*5U\7[AD:Y96J&V*2^GWRV9(=,
MMPF4LF83/J&3'4D]K]XSFRV3&SPV9NMZQS!*%:6A_P#S]]E>T^X/FKD,RZM5
M+47A$PB81,(F$3")A$PB81,(F$3")A$PB81>0O=_I&L*O)W78EK@*54X<B9I
M&P623:1,8W,NJ1NU;^LNU$RK/7SI0B+=NGVEW*YRII$.H8I1^"0T;SC`!?(!
M)@,25%24VIN_=`K,M5Q4IH'7"BRB"FU]AUAN?<ED9`5,!=ZRTY:6+B/U\BX*
MX$6\M?6BS]NY:J)+U%5NLB]R+7',]/3QE4($V;ZWH#[7<T!QKOT5AG3H3*HF
M7+X/2/W<\3Q+Z\-5M1<?8V9GCK>J3-C.BXM=ZMDQ)V[9FP7[$BH,SV.VSKF4
MMMJ4CDES),6IECM(QJ)6[-%LU332)!*ZXSJA_7ULPN=JCJX@-7,%+:6CE2&]
M53,`&WC)U\ZC)LGE)/SHKQ=$26K<4;MIFEU>P:?=D_!VD!()T(@A@_\`4%1<
M/0(*$](9PIU<]_DRO);PZ_\`8NI+IFMQ?B?J44UUUG*RKARLJX<+J'56774.
MJLLJH83**JJJ"8ZBAS"(B81$1'/`228G2O5HT+\&?L4!5(IS.V:9C("&9BB5
MS)R[UO'L43N5TVK5(SATHFEW[MTL1)),!$ZJIRD(`F,`#]Y4J;/F"5):Y\UQ
M@``23R`+Z3)DN4PS)K@U@TDF`'.5VW4G%[D#OWU*6-'R7'C5+E0IU;??JZ8F
MYK/'#W?>'H6I)U`GZB%<$44(C*79%)XU<H=H:T^:*I.#3^T9'FS(3[N[<9_N
MVGRCTG:!R")XP5$;CFEC(RK<-YWKG1S#2>4P'$5U/FMQCTYQWX-[')KNLF&S
M36R.)C>V[(L[YS:=F74S3E?H\R8V:Z2YEY5:.3="=9M%-C-82,,J<C!DU1$$
M@N;)='2T5\HY%(QLN4)HP`XCB=9/&8E57G*HGU5AK)M0]SYADG$\HT<`XA@L
M[W.S]PMG_0UM]S)_-8V3]M</@)NQ9&S!^YMW]0E;5NHS&ZVFF$3"+-!R\\9/
M*3V[UQ]VS1>7?X>=PN^(?[+%1GB+\P#X=GM/7R\DKQ3\NO82G_.+?,]OCCYE
ME^%F?X2YG@-[R^_%R]LY:7<H-:&3"*D#S".7>FMPU)GI'4TV.PEX+9-=L=^V
M9`*,AU%2&]`E%'DG"'OCEVC'7"U.)%`[$S2OA*(Q3INX2E5X]9--):SO#K)]
M[NEWD75DITNU2W.)F.$`[R2(2QI>8G2/)$""X'!5;XD9SL5IL]1:GSFS+M,:
M`);3$M\H&,PZ&"`T$[QB(-(Q5"F[]G5Z;F:R6G.U9!6J22LC\)J-^S'JO`49
MJ()MN\$BKI-)5GU,82%3,`AV1,`]<UC9+(;8Z:XN)ES6M$#I$(QQ&&,>99"O
M]_%U$EH:!,E.<8C08PA@<<(8\*\?KO76^^6>Q'%2U;4K1MN[(E04F56G=M*M
M2F;P04;.;E;'PM:E0XY=+MK-FZZR3M^FDJ#!JZ5(*><_,V=LMY-D0N$T?S9;
M%LF7!TUW`81\D'UGD#@)."]^5LBYHSO41MTH_P`H'0=/F1;*;PB,/*(]5@<>
M$`8K0UQ0\E;4^NS1=SY3247OF\MEDWS?7S5N[;Z+KSA-05$$7L'(I-Y3;#AN
M`B116>31AW`=@X0J"R95<S!G#Q6S#FC?I)#C1V@Q'5RR=YX_XDS`NCK:`UAU
MM.E:JR9X1Y;RIN5E0T5MY$#ULQHW6'_A2\0V!T.)<\:G#0KNF[=NS;H-&B"+
M5JU12;MFS=(B#=NW0(5)%!!%(I4T444R@4I2@!2E```.F5>K65#W$)(2<0.-
M;M199R[G./>I[3)N5S$%5S-6_7\':)QR()D333*XF)=<Y2%*!2%,!0#H`92%
M][WJ>V?M5I6KNZ1V;=BE1Y<'QCR4]M-?>X#/)[D;N4]N[8U1+-7>8[)NURL_
MR9*-)A$PB81,(F$49N:G@WY:?9FWQ\UEJPBJG_\`Y]/#3NCY<U?<&G817W)I
M)I%$J29$BB=542ID*0HJ+*'664$"@`"=590QS#^$QC"(^D<^7.<XQ<23`#'@
M`@!S``#@&"^K6M8(-``B3APDQ)Y222>$XKYY\+[+X$233,J8B9"&6."JQB$*
M4RJ@)IH@HJ(``J'!%(A.H]1[)0#\`!GR7.<`'$D`0'$(DP'!B2>4DKZAK6DE
MH`+C$\9@!$\)@`.0`++OH?\`\_?97M/N#YJY#/A?9:B\(F$3")A$PB81,(F$
M3")A$PB81,(OB<Y$R&44,4A"%,<YSF`I"$*`F,8QC"`%*4`ZB(^@`PBAY,\G
MW]_75@N+=>C=F@"RS.2W=/N7<?Q^K)O5@'UF"G6(%EM[RS5PN7HPJ8FAA6:N
MF4C8(9XF5,_%N-]HK?%A/65'JMU=(Z!MXEU**TU59!P&Y)]8_8->SC7G(74L
M/#SB&V=P6YSM79T,DZ6:;`O"<=&0&OD'S=1K(,=54QN):MJZ(6;.3ME'+<%I
M^19]VE*RLD9,B@0*Y7FLN$>O=NT_JC!O/PGEYH*745LIJ/W3=Z;ZQQ/-P<W.
MN7;)Y51[`7$3KIL25=AVTCV-^DH6,0-T$HFC6)^[7?G(8?0HKW:("7J!52#U
MR-3J\#R9.)X=7,NW+I2<9F`X%"6P62=M4BK+6*5>2\@MZ#.'BHG$A.HF!%!,
M.RBV;D$1[*:92)EZ^@`SF/>^8[>>22O8UK6B#1`+\3/HOLD56-@;%O=/U1K$
ME6:7"[EGG!;%>5Y0M8J,#7XLKV5L;J(A$33%N?M5';8&L,DXBB2(G,4\DQ*'
M?!W;!93>ZPTY?N2V-WG&$21$"`X\=)T<!7*N]S%KIA.W=Y[G0`U1@3$_0K7-
M!\'-4Z9EHV_V1=]N7=##UA1GLZ_-61PJ"KY%P@]9ZFI;4GZKZOCC-GBS3UED
MDM8GT>*:$K+2?=$4"X;99K?:9>Y1L`>1BXXN/*>#7`0'`%7%=<JNX/WJAQ+=
M31@T<@^TX\:FEG47@5>_FE>"J^?*EQ7^]CI#)!E7YAI.U&PJ/9K^7:OL3M"R
MO\[/W"V?]#6WW,G\U19/VUP^`F[%DW,'[FW?U"5M6ZC,;K::81,(LT'+SQD\
MI/;O7'W;-%Y=_AYW"[XA_LL5&>(OS`/AV>T]?+R2O%/RZ]A*?\XM\SV^./F6
M7X69_A+F>`WO+[\7+VSE=1R-YI:5XVG+`6%]*7?:3V/+)0NFM=(,9W83YDL*
MA&LI,(NY"+K]#K;M1%0J,M8G\3'.%$CHMUEG(%0-3EER_=\PU/\`*VF0^:_#
M>.AC`=;W'R6CE,3H`)P5V7O,-GR[2_S=WGLE2\=T'%[R-3&#RG'D$!I)`Q6>
M;EGSZV/N;X1@=G3[&,IZX(E+QKU+,O3TLXH=L3M]R;-<1\/8MK@NHHH1Q%BS
MB*XNV%-)U`N%4@?*:1R?X-VZW;E;?2VJK!`[I'Z+3Q-.,SE>`T^I%9ESIXV7
M&X;]#80ZDH\1O`_K.'&\82N1A+AZ\%6)9MFS^PI^`I2K]BU6DQ(VJM#AS(QT
M>BU9F;,DSMHTJA0*Q8'<H(BY7'N4#K)I]L@J)D&WZBNLUC$N55SI4E\R(8UQ
M`<_=$2&-&)@-(:(!4O3T-\S`Z9-HY,V<R7!SRT$M9O&`+W'`1)P+C$XP7Y'(
M37<OJS4TY-JS`%L#JIW1TC\&]M,L.XBZ^HZ:*MWHB559VDNH!NV4I"D,7\GM
M?[V<W_/Q<:.N-(',;)IGEKHP<3NO@0!HA"(QCR+JG+AME;;VUKFS'3ZEC7,`
MBT-WF1!)\Z,8'`#ETK?%K+5>M],4Z+U]JBCUG7M+ABJ?!]<JD0TAXTBZX@=Y
M(.$FB9#/Y:27ZK.WC@RKMXN8RJRBBAC&'!LZ?.J9KJBH>Z9/>8N<XESG$Z22
M8DD\)7]`I$B12R6T],QDNG8(-:T!K6@:`&B``'`!!>^S\E^J814/<1O!SQ5^
MRSH'YG:AE(7WO>I[9VU6E:N[I'9MV*47EP?&/)3VTU][@,\GN1NY3V[MC5$L
MU=YCLF[7*S_)DHTF$3")A$PB81?1E(N,G(R1A9J.8R\-+L7<7+1,HT;R$9*1
MD@W4:/XZ18.TU6KUB]:JG2615(9-1,PE,`@(AA%YZG:^H6NV+J,U_2*A18U\
M[]?>QU.K4-6&+Q\**3<7KII",F+=P[]71(3O#E$_8(4O7H`!A%Z_")A$PB\$
MTU5J^/MZ^PF&MZ$ROSI1RJYO#2GUYM;W"KUN+1XHO948XDTLH[:F%)43+B*B
M8]DW4/1A%[W")A$PB81,(F$3")A$PB81,(F$3"*.7,1)-;B-RF163(JBKQRW
M>DJDJ0JB:J:FL[.0Z:A#@)3D.41`0$!`0'/SFX2G=$[%]Y>,QH/K#:HSDV[,
M46MNU5&2,TSBV9$V#1946AVX`9)LV2*Y325$6B';#\@2"/9#LE,4.G2AA5/E
MM)=Y7+]ZMKJ&O,!@H<7S:%RV*[[^QR9S,TU.VTAF7;;0[(0`P`9%F!S]ZL`&
M$.]6,HMT'IV^ST`/!-GS)QB\X<&I>IDIDL>2,>%<]S\5^B_"82LI:;<IK?65
M5L&U=F)-F[MU2J6@U75@&3P4Q:RE[LLFZCJ?KF(<H',L@O./V)GY$E",2.W`
M%0-V+78KC=W?\JR$F.+W8,'/K/$T$KFU]UHK<W]=WZD,&C%QYM7*8!=QI^G]
MCZ[VS:*ANJ1H<U*HZNU3L"+KM'8S*\#37=PMNZ(&4A5[5/J,WVPG!4:"S4"0
M/$02("82$8%$HK*]6^V"19&R&->Z9.>'%Q.`B-V$!J&.LD[%X;3=IMT,UY:&
M2VD!H&)QCI/#R`+W^D@`O.C7Q2@``%1VN```=```KM3````]```9T<B]ZS^P
M_,U>'-?["5VOY2KF\M10),(J]_-*\%5\^5+BO]['2&2#*OS#2=J-A4>S7\NU
M?8G:%E?YV?N%L_Z&MON9/YJBR?MKA\!-V+)N8/W-N_J$K:MU&8W6TTPB819H
M.7@#]<CE)Z/P7O7'7_9_^MFB\N_P\!-@<0-%0_8Q47XBD#,#03B:=FUZK?TA
MN>\:%NF_;'4=M%UDQOJ"-+L?ZO5MM)[1DV458K-+H(T*PR3YQ%5#UD9%1!Z]
M-%.7J9#D,R>1KDI'(7'F/(5)G&9;*BO>_P#E*:G(+&X;Y>)9Q?I:T;N(:-XQ
MP<V"I/+/B#5Y*EW6GH&,_FZJI!#W8[@89@.ZS0YQWL"X[HABUT5Q>Z;O=>K2
MC6O=NG0LY+^N34DO*/YB[WBQ3"J#(TK<+C*.7EEMMLL3HR9%%EUW$@_7.4BB
MK@X@(R^DMMBRM;8@2*6W21$DP8QO&2=)/K.))/&H;6W7,&;+G`F?57&<Z``W
MGS'<0`T`:FM`:!Q*??$ORA>1'(;X,M^YU)CC'I]V5%VBC)1;)?D#<&"G9,'P
M'2)YH]AM3MW*"G;3>VEL\E454C)+5T"*$<A2^</'"5*WJ'*#`^9B#43&^2..
M7+.+N)TP`?@<,5=V3/`:=-W*_.3RR7@132W>4>*;,&#>-LLD_C:<%:+R_P"*
M6@N)_#9I3]%:\BJ>VDMVZ<=6:P**O)R\7:11L_1*4N]XG7$A:;4\;$5,FV!X
MZ518-NRV:)H-DTT24S8+G<+OF^GKKG.F3ZM[W1<\DGS'8#@`U-$`!@``KOO]
MKMUFR=46^U29=/1L8V#&-#1Y[,3#2XZW&+B<225GGYY?NCEO8_8_NSFG;%W9
M<_A'>Q,66,Q=Z6KXQOMRUN_S%ZVXF$3"*A[B-X.>*OV6=`_,[4,I"^][U/;.
MVJTK5W=([-NQ2B\N#XQY*>VFOO<!GD]R-W*>W=L:HEFKO,=DW:Y6?Y,E&DPB
M81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A%'7E_X2^47V
M==V?-I9L_.=[IW1.Q?>5[UO2&U0)O_\`^(3?_<(?_.-LS[,\PJX&><%"V=MD
M-7WD+$.3OY&RVAPY95&F5N)E+3>+B^9(`Z?,JC3*ZTDK+9'$>S'UAT#-JJ5F
MU*9=<4T"'4*HJ"LN$WJ*.6Z9,XM`XR=`'&2$J:NGHY?6U+PQG'KY!I/,I>:C
MX);>VD9C8-^RS[2%#4/WPZ@I,W'O]O6-H`H]EK?]I5]Z_KVMVCHG?I.(ZH+R
M<KW8H.6]E8K=ZT)9-GR134\)]U(FSO4'F#E.EWU#405";CFB?.C*H!U<OUCY
MQY-3?K/&%:OK/5FN=-5&/H>K:;`4:I1IE%D8>OL4V:3E\X`@OYF6<_EOIRQ2
MZQ.^?R3U5P_?N#&6<+*JF,<9VQC);!+E@-8!``"``X@%%'.<]Q>\DN.DG$E0
M,WEXM+O]G70/SE\H<KO/7O:;HOVM4RRI[J=TF["N+Z4\=.O_`&2VO[O5//#D
M7O6?V'YFKTYK_82NU_*5<UEJ*!)A%7OYI7@JOGRI<5_O8Z0R095^8:3M1L*C
MV:_EVK[$[0LK_.S]PMG_`$-;?<R?S5%D_;7#X";L63<P?N;=_4)6U;J,QNMI
MK\>PV*OU&"E[1:YV'K%9K\>[EYZQ6&390L%"1+!$[A])R\O)+MH^-CV;<ACJ
MK+*$33(`F,8`#KA-"IXY%^:BV+'2,9QB9PXPY""B[Y%[3CI)C06X&5$ISZNU
M\NK!VC:#I9%!4K:2>*PM?/W[9\P4GVPJ-S6GE/PIOE_+:FX!U';CCY3?U7C\
M+##=!'I/AJ(:X*I\W>+5AR\U]-;RVLN+<#NN_28?Q3!'>(]5D=8+FE4+;#Y/
M3LI+6J2AIZQ7*W7.95G;GM6^'9N;%9IHT>PAB/FD*PCXJNP;-I#Q#1JS:-&#
M*/9M&Z:+=B@0@!FHLN9/M67+>+?1,A(B203O.<3I+W'23P"#1J`"REF;.MVS
M)<3<*Q\:B``(&ZUK1H#&Z@(Z22XZR2O*\8^+.Y^:6TY77>JW%9B7$3&-+9L'
M8M[>J#`4Z$F9A2-2?)UZ*5_66[V=^NDZ69QC?U!FY%HH1W*1H*(J*<7/_B!2
MY$I9,IDATZOGM=U3<&RVAFZ"7G3`;P@UHQT1;I7:\//#NK\0*N=.?4-D4$AS
M>M=`NF.+]X@,;HB=TQ<YWDZ8.T+4[Q`\L?C?Q'7C[BRC'6U]W-V[A-3<^QT&
M+Z=A_7@-Z\QUQ7FR)*UK*(.10S?M1J'PN\9E32DI&1,D57,EYESA?\V5'7WB
M>72P8LEM\F4SHLT1U;SMYY&EQ6P<KY+R[E"F_E[+(#)C@`^:[RILR'K/(C#7
MNM#6`Q(:(JQ7(PI4JW_-,\,<;\M.H?>@F27)_P`R4O3=[#E&<X_+57T&^VU9
M8.>7[HY;V/V/[LYJNQ=V7/X1WL3%DG,7>EJ^,;[<M;A=7N'#S6>NW;M=9TZ=
M46HN'+EPJ==PX<+P$>JLNNLJ8RBRRRAA,8QA$QC"(B/7,7K;B]UA$PBH>XC>
M#GBK]EG0/S.U#*0OO>]3VSMJM*U=W2.S;L4HO+@^,>2GMIK[W`9Y/<C=RGMW
M;&J)9J[S'9-VN5G^3)1I,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,
M(F$3")A$PB811_Y9>%CDO]G_`'+\W5CPB@AL1$%X&TD$W9[*;M;J`=>HMG'K
M`%Z=0_WQ2Z?[.N9^JO/?TCM5P2/-;R#8NL>6K0:6RT8YVNA68C]IM]V7O^$M
M^P%VB;JX3M?HG(O:]2I=9=V%UWTH6K52OPC="/BTU21[004431*JLL=2XLL2
MI4NQTYEM#2YD3`0B>$\)5;7V8]]TG!Y)#70$=0X`K%\[ZY"815F[R\6EW^SK
MH'YR^4.5SGKWM-T7[6J:94]U.Z3=A7%]*>.G7_LEM?W>J>>'(O>L_L/S-7IS
M7^PE=K^4JYK+44"3"*O?S2O!5?/E2XK_`'L=(9(,J_,-)VHV%1[-?R[5]B=H
M65_G9^X6S_H:V^YD_FJ+)^VN'P$W8LFY@_<V[^H2MJU,<BO,:U3J)_-T75[`
MN^MNPJSEA,P%;G&\1KK7\DT`PNFNV-L"RF8BKR#'H4%X:,:3MH0%9!56+29J
M&=IYCRUDJ_9IF#_+Y6[1Q@Z<^+98X0#"+W?A8"1K@,5J3,^=[!E24?\`,9N]
M60BV2R#IAX"1&#&_B>0#JB<%GDY)<S;EN"<2DMH7)MM^:B)!*2K--A6"U:X_
M:[DVBI5F,C7:662E'%KLL>HF11*9FGTQ)MEC*^HO&*"AFA=.Y/\`"JRY=W:J
M>W^8N0@>LF`1:?\`ALQ#.(G>?^*&"RQG/Q;O>8]ZDIW?R]M,1U<LF#A_Q'X&
M9QM&ZS\,1%1&K$'OCE5L0:/K*H6_=&P$B(.'-<JR+-&&ID<_(X4:R-MG9-W$
MT?6T(]2CUO5W,P]8_"2K<R+473OLHGE&9,Y9:R93QN4T"I(BV2R#IS^#R8^2
M#J<\M;JC'!1/+.2LT9XJ86R232@P=.?%DEG#Y4/*(UM8'/UD0Q4G(;BK.:0V
M%L.@;K"FV/8FO;'`1S@M0<R\K2V"5@UO0]@-4&;J?C81]8'C$+D*"CM=@S3.
M9(!3;)]GMG@%O\0[AFJA?4R&"EINN<P-:27EH#8;S\,3''=`X(E6-7^&UMRE
M7RZ:HF&KJNI:\N<T!@<2Z.ZS'`0P+B>&`T#M?D^Z)EK=R@Y8H-.0&_Z3ZM4*
MP[[VE6.CL%7!'.PKP0C%P,MKV;(9BT['5(I2E.43#U,;^BO_`!HIG4XM#G39
MLW?IIA\L@[ONL&P:V`QUQT!6%X'U3:EUY:V3)E;E5+'D!PWO>XNBYT3AJ@,3
M@M#OU3['_.'S`_QKJOZ&\HU7TGU3['_.'S`_QKJOZ&\(J^_,MXT3T%QRCWRW
M*?E+8"&V_JIMZA8+=K=RP*9Q9"$*Z*FQU3'+>M-A_*3'O!*!OPE-^#)#E1AF
M9AIF!SFDN=BV$1Y#M$0=BCF;7B7EVJ>6M<`UN#HP/EMTP(/UK,_S;U%)16JY
M1PIN?<LN4M4V"IZM+SE36;&!&N=L4C%:TIFIW:X?DG`#`(E_`(#Z<TY9;:]]
MNN+OYJJ&[2N,`YD#Y+\#Y&CZ%EN_W.6RY6QII*5V]5M$2U\1Y<O$?J#'EBME
M6K^*MA<:SUVN7E[RZ;%7HM26!NWNFKBMT`4@(\X(H%4T\JH5%(#=DH&,80*`
M=1$?3F0EL=>Z^J?8_P"</F!_C75?T-X1/JGV/^</F!_C75?T-X14F<5^/4U(
M<2^,LB3DIR2C2/\`C1HU\2,CK1K]*-CR.]351P6/CTG&LW+A)@S*IW2)3JJ'
M*D4`,<P]3#35ZJ6LNM2WJI1A-=B0Z)QU^4K+MD@NH))ZR8(RVX`B&CD4DO+[
MXUSLS(<A@2Y2<HH/U*WT1,YH2VZY;F?"M1FBH*OO7-5O@451`>P02`F`$]`@
M(^G)QDN8)MG+@UK/UG8-C#0WA)45S,PR[B&ESG?IMQ.G2>`!60_5+F%?ZI_R
MXY@/V9_R73+]HU&B?6D1]"B'PG7-70L\P[POH[UF[;."?A(H4>@Y+5'D^IM7
M/\_.8'^J#:G]LX1/J;5S_/SF!_J@VI_;.$3ZFU<_S\Y@?ZH-J?VSA$^IM7/\
M_.8'^J#:G]LX1/J;5S_/SF!_J@VI_;.$3ZFU<_S\Y@?ZH-J?VSA$^IM7/\_.
M8'^J#:G]LX1/J;5S_/SF!_J@VI_;.$3ZFU<_S\Y@?ZH-J?VSA$^IM7/\_.8'
M^J#:G]LX1<'Y)Z+=:2U2XV;1]_<J/UEK>P-+$9I6'D)L&RP;MK.[IU]6YF/E
MH&8DG49*1\E"3#ANJDLF8IB*#_3T'"*SC")A$PB81,(F$3")A$PB81,(F$3"
M*/\`RR\+')?[/^Y?FZL>$4%[[\2VO\TE/Q*YGZI\^9TCM5P2/-;R#8I`>6_X
M3*U\KO*K[UV[,N;+?<5-V0VE5G>N]9_3^Y3HSMKEIA%6;O+Q:7?[.N@?G+Y0
MY7.>O>TW1?M:IIE3W4[I-V%<7TIXZ=?^R6U_=ZIYX<B]ZS^P_,U>G-?["5VO
MY2KFLM10),(J]_-*\%5\^5+BO]['2&2#*OS#2=J-A4>S7\NU?8G:%F7Y/MV;
MNG0K619MY&/<SXMWT>[336:/V:T7()NF;I%4BB2K=T@8Q#E,4Q3%,("`AZ,U
MOD^6R;5SY4P!TMT@@@X@@N`((U@A8]SM,?)HZ>;+);,;4`@@P((:2"#J(.@J
M.LQL"V7M[6-95&"<I(R1V\!0-.:MK;Y\\DB-.Y1;Q=>IM68N9>;)%MC$,H5!
MN9LR0(*PD01*<Q956UV7\IV\5-QFR::C8(-C`:/1EL:(F`T-8TF&J"A]#0YC
MSA<32VV5.JJQYBZ$3I/G3'N,`"=+GN`CKB5;WQ0\DO8=_",N7,&>>:KJ2@IN
MBZ.U_.,G6RIQL8"B++8.S85R]AJ$U6)WB:[&KJOY0Z:B:R$['+IG1'/6;O&^
MX5V]1958:6E,09SP#.</P-Q;+''Y3]!!85H[)O@1;J#<KLVO%558$2&$B2T_
MC=@Z:1A@-UFD$/!6C+46F-4:$I3'76F=?U;6U*8+N'J<!5(IO&-G4H][L9*=
MEUDBB\G;'+J)%4?23U1P_?+=5%UE%!$PT1/GSZF<ZHJ7OF5#R2YSB7.<3I)<
M8DDZR3%:`D4\BEDMIJ5C)=.QH#6M`:UH&@-:```-0`@L]O+SQD\I/;O7'W;-
M%Y=7AYW"[XA_LL5(^(OS`/AV>T]?+R2O%/RZ]A*?\XM\SV^./F67X69_A+F>
M`WO+[\7+VSEI=R@UH9,(JW_-,\,<;\M.H?>@F27)_P`R4O3=[#E&<X_+57T&
M^VU98.>7[HY;V/V/[LYJNQ=V7/X1WL3%DG,7>EJ^,;[<M;?]3?NKUI\G]-]W
M(W,7K;BZ!A$PBH8X?-T6G#'B<U;)E1;MN*?'QN@D3T$211TU3DTDR]>H]DA"
M@`?[`RD+[WO4]L[:K2M7=TCLV[%*CRX/C'DI[::^]P&>3W(W<I[=VQJB6:N\
MQV3=KE9_DR4:3")A$PB81,(F$3")A$PB810_YW^&:T?*!H#[PNK,(I@81,(F
M$3")A$PB81,(F$3")A$PB811_P"67A8Y+_9_W+\W5CPB@O??B6U_FDI^)7,_
M5/GS.D=JN"1YK>0;%(#RW_"96OE=Y5?>NW9ES9;[BINR&TJL[UWK/Z?W*=&=
MM<M,(JS=Y>+2[_9UT#\Y?*'*YSU[VFZ+]K5-,J>ZG=)NPKB^E/'3K_V2VO[O
M5//#D7O6?V'YFKTYK_82NU_*5<UEJ*!)A%7OYI7@JOGRI<5_O8Z0R095^8:3
MM1L*CV:_EVK[$[0LN/-.5>06G).<CCD3D(9O/RK%11,JJ9'D=5IIVU.=(X"1
M0A5T2B)1]`AZ!S5V7)TRF;6U$K";+HWN&O%N(^L+(^:)$NJ-#33L94RMEM=J
MP=$''D*UV\7^%O';B#`.8K2]$;1T],MFJ%OV38%C6/9]Y.U(D)36BZR!#22D
M:#HAG"$2S]3@H]993U%DU(<29D2[7JZWVL=7W>?,GU3M;CH'`T>:UO`UH`'`
MMB6>QVG+]&VWV:GET]*W4T:3PN<8N<[A<XD\:E3G,753"+-!R\\9/*3V[UQ]
MVS1>7?X>=PN^(?L8J,\1?F!OP[-KU\O)*\4_+KV$I_SBWS/;XX^99?A9G^$N
M9X#>\OOQ<O;.6EW*#6ADPBK?\TSPQQORTZA]Z"9)<G_,E+TW>PY1G./RU5]!
MOMM66#GE^Z.6]C]C^[.:KL7=ES^$=[$Q9)S%WI:OC&^W+6W_`%-^ZO6GR?TW
MW<C<Q>MN+H&$3"*A[B-X.>*OV6=`_,[4,I"^][U/;.VJTK5W=([-NQ2B\N#X
MQY*>VFOO<!GD]R-W*>W=L:HEFKO,=DW:Y6?Y,E&DPB81,(F$3")A$PB81,(F
M$4/^=_AFM'R@:`^\+JS"*8&$3")A$PB81,(F$3")A$PB81,(F$4?^67A8Y+_
M`&?]R_-U8\(H+WWXEM?YI*?B5S/U3Y\SI':K@D>:WD&Q2`\M_P`)E:^5WE5]
MZ[=F7-EON*F[(;2JSO7>L_I_<IT9VURTPBK-WEXM+O\`9UT#\Y?*'*YSU[VF
MZ+]K5-,J>ZG=)NPKB^E/'3K_`-DMK^[U3SPY%[UG]A^9J].:_P!A*[7\I5S6
M6HH$F$5>_FE>"J^?*EQ7^]CI#)!E7YAI.U&PJ/9K^7:OL3M"RO\`.S]PMG_0
MUM]S)_-463]M</@)NQ9-S!^YMW]0E;5NHS&ZVFOQ+)9:Y3:_,VRWS\)5:M7(
MQY-6&RV258P=?@8>.0.ZD):9F91=K'1<8Q;)F467743223*)C&``$<:4T8E4
MZ<BO-21%C(17&9E'-()(5FTAR)VK$/V-/!([4!(MJ373M>&L^Q'IEQ.FC)RG
MP1!]02=L2S[4XI&M;*?A1?+\YM1<@ZCMYQQ'ZKQ^%A\T'UGPAI#7!5+F[Q<L
M.7VOIK:6UEQ$1@[])A_$\><1ZK(QT%S2J%K_`,F)V1D[1(0L]9;?;;E*$FKK
MM:_N4']GM4XG"Q->"30B6K2/KD`@G$0;5!NS8,6,8S01*FU8MB%`H:?R[D^T
MY=H!044N$C28G><\F$2]QTDPT"#1J`&"RIF7.UWS)<#<*R9&?H:0-UK`-`8T
M:(1TF+CK).*L6\B)PL[Y!<F73E4ZSASJ?7#APLH/:4566NUT455.;^DZAS"(
MC_VCE(>/[6LJK6Q@`8),X`#4`94`KU_Z=WNF4MV>\DO=.D$DZ22)L2M/.9Y6
MD$PBK7\U)VT;\:8!LX=-T'$EO'4S..066326D':$RYE5FK)(YBG=.$8N-<.3
M$3`QBH-U%!#L$,(2;)P)S+2@")WG>PY1C.9#<LU9<0!NM^N8T+,9S`@TK/48
MJMKKJ-4+"SM<&LY1*4ZK=*6C&K!1=(A_R#*(D<"8H#Z!$/3FJK%W9<_A'>Q,
M62LQ=Z6KXQOMRULQXV3+RQ\==!6&0!$K^>TKJR9?`W(9-N#R4HT$^<@@F8ZA
MDT067-V2B8P@7H'4?PYB];<7:L(F$5#W$;P<\5?LLZ!^9VH92%][WJ>V=M5I
M6KNZ1V;=BE%Y<'QCR4]M-?>X#/)[D;N4]N[8U1+-7>8[)NURL_R9*-)A$PB8
M1,(F$3")A$PB81,(H?\`._PS6CY0-`?>%U9A%,#")A$PB81,(F$3")A$PB81
M,(F$3"*/_++PL<E_L_[E^;JQX107OOQ+:_S24_$KF?JGSYG2.U7!(\UO(-BD
M!Y;_`(3*U\KO*K[UV[,N;+?<5-V0VE5G>N]9_3^Y3HSMKEIA%6;O+Q:7?[.N
M@?G+Y0Y7.>O>TW1?M:IIE3W4[I-V%<7TIXZ=?^R6U_=ZIYX<B]ZS^P_,U>G-
M?["5VOY2KFLM10),(J]_-*\%5\^5+BO]['2&2#*OS#2=J-A4>S7\NU?8G:%E
M?YV?N%L_Z&MON9/YJBR?MKA\!-V+)N8/W-N_J$K:M2'(KS'M5ZG?3U&U.R;[
MWVQ`N'D=/14'.IP^L]=R;`RB;]KM':I8^9B865C54A(XA(IM,V)NH9,7+!LV
M4%T3,N6LD7[-,P?R$K<HXXSGQ;+'#`PB\\30>.`Q6H\SYYR_E24?\PF[];"(
MDL@Z8>`D1@QOXGD<43@L\W)#F1;MO3R$KL^Y$W+8(60^$*W5XYBO5^/VO))!
M5,[-_4]?)2<I^L-AC3H]MO.33Z;FVQEURM)-LU5%F73N4/"NR9<W:J:WK[D/
M[V8!$'_ALQ;+Y3O/TC>@8+*^<_%J^9DWZ22[J+:<.JEDP(_XC\'3.3R6:#NQ
M$5$>`U;NWG+<'VL*/0IO>$X95FE88Y$R$;0:"V,+>88N[]:G:C2K4&/[M(CI
M!%90963(D/J#1^N'=&[.<,X92RO1NI+NYLVH>`13L@Z8Z$'-+A$;C8@$.>0#
MZ,807#R;DS..;*UM99VNE4["0:E\6RFQBUP:8'?=`D%K`2/2W=*Z>V\M;5^C
MMB;*UIN.G:SO5XH,_7(QTZJT?/(TYJG9M7:^V$,<Q)./"OY]6'<W15G\).&S
M`'I&Y%BL&9C&3"K[5F"1FBA?5RZ.12R>N<UK6;Q=N@-(WGDXG''=#1Q*V+KE
MR=E6O923*V?5SNH:YSG[H;O$N!W6`8##`.<\\:EKY.7$[CA=N3'*F(M6HJC.
M1\-2*BXC63UNY,DR47O]X:G52*F[()141;%)U'KZ"9'/&>@HZ%MG_E);6%],
M\NAK/Z6)^M2/P1N%;7OO7\Y,=,#*I@;'4/U8@?0%HE^H%PU_EZU__P`F^_Z_
M*.5\KQ^P>(7`/55)M&QMA:9UE5Z538=Y/62>?LI4Z$?&L4Q45.5NT<N'S]VL
M;HDW:MDEG3MP<B**:BIR$-]F,?->)<L%TQQ```B23@``,22<`!I7TF3&2F.F
MS7!LMH)))@`!B22<``,23H6>'8VH]*;PV!*[*F-%U>B4Y)0S;56J3$<=BD5I
MN1XV):+=W<@HSD-K7%HZ47D52]I""9K%AV9U2HO9"5U'D3PYH[-0"KO4ILV\
M3A$@XB4T^@(&!=Z[N'R1@(NRIG[Q)K;U<#262:^599)@",#.</3=$1#?4:=7
ME'$P;7'NC7/'JQV-K%5+6%60B(-=5$TH@BZZR[M4R)%U$BBY[`,4.Y[*1@#J
MH/:/U[(ERPJK*=DI;35U`II;9QIIFB.$&.(PC"*K:GSA?:N\4=,:J8Z0VJEC
M$C&+V@XPC#^`M>W%[@EQ"EN-''>5DM!T-Y(R>B]22#]VLT>BJZ>O:!7W+IPJ
M(/@`5%UU#&-T`/2.886]UW3Z@7#7^7K7_P#R;[_K\(GU`N&O\O6O_P#DWW_7
MX14F<5^'_&:7XE\99B2TU3GDI*\:-&RDB]6;.Q6=R#_4U4>/':H@[`!5<.EC
M',(``=1RFKU6U<NZU+&3'!HFN@.=67;*6G?027.8"XRV[%)+R^^%7%6R2'(8
ML[H^DR98VWT1%@#EJ\,#5)Q1FCA<B79>EZ%46'M#_MR<9+G39]G+YSBY_7.$
M3R-45S-+ERKB&2P`WJV[2K(?J!<-?Y>M?_\`)OO^OR6J/)]0+AK_`"]:_P#^
M3??]?A%]W@/(2$OP5X62TL^>2<I)\3..4A)24@Y6>R$A(/=/4YR\?/GCDZKA
MV\=N%3**JJ&,=0YA,81$1'"*6>$3")A$PB81,(F$7C;]L.D:MJ\A=-AVB'J%
M7C.Z*ZEYIV1J@+ARH"+*/:)_E.)&5D7!BHM6;<BKITN8J:*9U#%*)%"G=\ON
MOE'K&4HNI=#RU=@)>PZ\GXW8&^[.CJ5C*MJ1L>J7KO(^CQL%L#:3!O+(UKN"
M?#,)#N4N_!3N#@7L&(NQNMI<G:P51];^+U=LD2@D"ZY-$[[97ZQD1*)Q7%*!
MVOK7CXV>KH)D$_<MWJJJH"!4BG4'L81=4UCN77VW6TL:G2ZXS%;=(Q]OIT_%
MR=7O=*DUTS*)1MOIE@:QUA@5UR$,9!19`&[Q,O>ME%D1*H)%U'")A$PB81,(
MF$3")A$PB81,(H^\M`,/%7DR!!*4X\?=S`0QRB<I3?LYLG9$Q`.F)R@/X0`Q
M1$/Z0PB@S??B6U_FDI^)7,_5/GS.D=JN"1YK>0;%(#RW_"96OE=Y5?>NW9ES
M9;[BINR&TJL[UWK/Z?W*=&=M<M,(JS=Y>+2[_9UT#\Y?*'*YSU[VFZ+]K5-,
MJ>ZG=)NPKB^E/'3K_P!DMK^[U3SPY%[UG]A^9J].:_V$KM?RE7-9:B@2815-
M^9]O35LKJ.;XS05J9V3=L[?-"6%U1ZX1::=TZNTK>&M=G3,WL208D5B-?M7-
M2JCQ6,2EG#1W-*D[N/1<F!3L37(=DN=VO\B;12GNII4R,R9#R&"!\YVB/`WS
MCJ!4'S]?;7:,OU$JNG,;4S91$N7'RWF(\UNF'"X^2-9"SJ\E;)3IF.CJDB[C
MK,HA*'5G8ON4WT8=B9DZ9NHV0.H1=@X!T#@4U$1[S\@3`H4/P#KVQ6&913IC
MYQ:^FF22P@C3$B(+3$%I$=.G1!8VS#F&57R)3)`<RJE3@\%IT0!@0X0(<##1
MHTQ7%9.\W/8\M6-6TNO/G"TMTB=?Z6U977;Y])(1::("S@:A76JTA*-85J8B
MKE0$O4XYN`KJ>KH%,8OMN%RR]E&WBIN4V534K!!L81,/1EL:(F'JL:8#3ABN
M?;K;F3.=Q-+;)4ZIJGF+H1($?2FS'&#03Z3W")T8X*X_B;Y)%QMX1MUYE3[F
MB5Y4K=VAH/7%A2-<WQ.VH*C/9VUH%RLRKR2Z)@(K&U%=5TF8I54K`7JHV#.V
M;_&RYW+>HLKM=1T1P,UT#/</PZ6R@>+>?H(>W0M)9,\"[5;-RNS4YM97#$26
MQ$AI_%&#II''NLT@L<,5HIUAJG6NE:7$Z[U+1:OKJD0:9BQM9J,.SA8M%17H
M9T]619I)B]E)!4.]=/%Q4=.US&56444,8PT;-FS9\QTZ>YSYSB2YSB223I))
MQ).LE7W*E2I$ILF0UK)+``UK0`T`:``,`!J`P6>#EYXR>4GMWKC[MFB\NOP\
M[A=\0_V6*D/$7Y@'P[/:>O2^1A^_KS!/T-Q@]\^7V?KXW_N;1\!]K5YO`G]M
M>?ZA]CEHP?/F48R>24D\:Q\='M7#Y^_?.$FC)BR:)'<.GCQTX.F@V:MD$S'4
M4.8I"$*(B(`&46K\6<7E+R7=\P;O&KPRKAKQKU[-*2.L814I"!MZUQSGNF.\
M+4V435$]<C3MS*T-@!RE(W<#./2'?K1J$)HWPOR#_(L9F2\L_P"=<(R);A[M
MIT3'`C!Y'F#T6F)\H^3FOQ4\0?YZ8_+-E?\`\DPPGS&GWCAIEM(/F-/GGTW"
M`\D>56/OO<"CY9QKJGK'6[Q7U&P/F?511TX,<430#+L%$Q@[SH5P8@]3F_J@
M]`'`V@:2G:QO\Q.@&@1$=0X3_'&LZ5M4Z8[^5D1+B8&&L^J/XXEQ>ZZV4H==
MJ#N3,(S\X^>J/T2G`48]!%)@9NP+V3&(JNF98PJJ!Z!,/9+U`O:-PYUY%TI+
ME+D_M95(\-.MQ+'Q=Q#`0'.=,!W95C=:*NUS)_[R;5L+AJ:`^7!O&1$Q/#@,
M!$[9.)OA8XT?9_TU\W5<S!J_H$I`81?S662;I*KKJIH(()G6666.5-)%),HG
M4554.)2)IID*(F,(@``'4<(J(N(W@YXJ_99T#\SM0RD+[WO4]L[:K2M7=TCL
MV[%*+RX/C'DI[::^]P&>3W(W<I[=VQJB6:N\QV3=KE9_DR4:3"*('E[>`7@]
M]D#C3\S%*PBE_A$PB81,(F$3"+ZC]^RBF+V3DG;=A'1S1R_D'SQ9-NT9,F:)
MW#IVZ<*F*D@W;()F.<YA`I2E$1'H&$4.])U!;>=BA^6&SF;MP21;JO.-VOY<
MJ@1>K];R13_`U^<P;@H))[>V=#JE?O7JQ`>0\6Z0BDNZ,F],Y(IFE.0XG*4Y
M3&3,!%`*8!%,XD*H!3@`B)3"0X#T'T]!`?Z<(OEA%'/>>E'=T/';.UBZCZAR
M%U^T55H%S524(QGV2:H/7FK=CD9G07L&LKD9,6[I!03J1BRI9!EW;Q!,XD70
M=/;,CMP:XK&PHZ.>PAIIL[;S-;E!*,M4K7!23ROW&G3'8*0@R]2M44\CG(E`
M"&6;&$OY(@.$72\(F$3")A$PB81,(F$3")A%'_EEX6.2_P!G_<OS=6/"*"]]
M^);7^:2GXE<S]4^?,Z1VJX)'FMY!L4@/+?\`"96OE=Y5?>NW9ES9;[BINR&T
MJL[UWK/Z?W*=&=M<M,(JS=Y>+2[_`&==`_.7RARN<]>]INB_:U33*GNIW2;L
M*XOI3QTZ_P#9+:_N]4\\.1>]9_8?F:O3FO\`82NU_*59CN[D-IWCI6V]GV]=
MF%6;22SAG789-N_G+A<I-JB5PO#T>D5]I)VVYRZ#<W>JMXUFY410`5E0(D4Q
MRV]1T59<:EM)0RGSJEY@&L!<3S#4-9T`8G!5Q6UU';J9U97S62:5@B7/(:!S
MG6=0TDX#%4/<JO,XV==F[R%@9"7XU:W=%.FC"5V4C)/DS>60@9,WPM:()\_K
M>EXE\0ZI!2K[M_,AW:#E"Q,%168EOO*'@M,FEM9F=V&GJ&'`<4R8-/&V7_V]
M(6?,Y>.$J0'4>5VXZ.O>W$\<N6='$Z9_V-:ICLFV)>59J5JHQZ%*JSARY7/#
MP8G^$)A[(+G7?R$]+@4K^9E9=VL=5VJ<>V[54$ZPJJ")S:)MUHM]IIFT])+E
MRY#!@&@-:WD`PXR=.N*S9<[U<KQ4NJ*N9,F3YAQ+G%SG<I.)X`!A#""Y7M6J
MW2@ZILM\=-`AED(&><0B;TI#/P?,H"3E&KI:.4(<$D$E60=2+@4QA$/R!*/7
M/+4WNF?)JF4#]ZIDTTQ^\!%H+1ACH=C#1$<:]5+8:N7/I)EPEEE-/J9<O=)@
MXASL<-+<(C&!X!K6YCC)PUX\<1*\YAM*4)G$2\PBBG;=@S:RECV9=SHJJN4Q
MM=XE.^F7L>W>.%56D6B=O#1@K'(P9M41!,,&W6\72^5CJ^[SYE15N])YC`:8
M-&AK1J:T!HU`+^@5HLMJL-&VWV>GET](WT6"$3HBXXN<XPQ<XEQUDJ46<U=1
M,(LT'+SQD\I/;O7'W;-%Y=_AYW"[XA_LL5&>(OS`/AV>T]>E\C#]_7F"?H;C
M![Y\OL_7QO\`W-H^`^UJ\W@3^VO/]0^QRZ=SIY4K<@[%.\?-;2`AH.H2Z\/N
M*S,SK$_;5=:]+&2D-51#M)1`?V44N8C.YLYR=ZC:I`#PR@A%M95O+^7PPR#_
M`)E,9F.\L_\`CV.C)EN'O7`^>X?[MI&`.#SI\D0=[?%/Q!_RR4_+=E?_`/(O
M;"=,:?=-(\QI_P!XX'$C%C='E&+:F-_[I3JS1W4:X](E-K-C_#<JFJ4A8%@H
MD85$2+=H`1DUD1[0GZ@+=(>T'0YBB74%)3!WZTW"6,<>+6>(+*E;5EG_`"\G
M&:<,-4=0XROIZWX=WVN:DT?S&V(XG*I$[%W"UK&GM<J%]16L=`F=*[ELRFV+
MRD8YG)F]G=P+!6L12A4?5F*0R3H%5WK-*,HR\^)#LQYMEV.RS"+#*$S><##^
M8>&.QXY33Y@T./EF/D[M\V+PR;EK*$R_7R6#F"<9>XUPC_+L+VX8Z)KAYYTM
M'D"'E[WG^3/_`,-2?TA*_P#NXW)Q8N[+G\([V)B@F8N]+5\8WVY:U_\`$WPL
M<:/L_P"FOFZKF8P6W%(#"+E&]I^!J^E]J3EFFXBNPC*@6HKR8G9)G$1;0SR&
M=L6A7,A(+-VB`NGKE-%,#'#MJJ%(7J8P`/P2`(G0OD`DP&E5?:KC'L+IG5<-
M)1[J(D8C4>NXN0B7S19@]BWT?1H1F\CGC%PFDNR=L7")DE$3D*=(Y1*8`$!#
M*/O3V3+I4/ED.89KB",01'4K3MC7,H)+'@APEMB#I&"ZSY<'QCR4]M-?>X#/
M)_D;N4]N[8U1#-7>8[)NURL_R9*-)A%5YQ)W3LC3O%3C+J.Z<-^6B%QU9Q\T
MQKBV(QU5U2_CT;-2-<5NLSR3%\GN(A'K-.4C%026*``H0`,`!UPBD'];"Q_R
M><P/\%:K^F3")];"Q_R><P/\%:K^F3")];"Q_P`GG,#_``5JOZ9,(GUL+'_)
MYS`_P5JOZ9,(GUL+'_)YS`_P5JOZ9,(GUL+'_)YS`_P5JOZ9,(N%\D^0]AON
MF+9KI7C?R;UZRV>[J&K)>Y7"KT"-KD'`;.N]<H-A7DGL)M&8E4`7@[$X12%%
MLH85E2!U*`B<I%9<W;MV;=!HT01:M6J*3=LV;I$0;MVZ!"I(H((I%*FBBBF4
M"E*4`*4H``!TPBH/\WBX[[XC;&U!R^X]W.6J[>SD'5>U((0-(4FRR4&1Y8**
MM:JTY44BI1U(0RLLT!T*:3QNBR3*BN01`2D4@/+_`/-3BN7QFU*N>H[Q3-CM
M^PU=SU-JMHNFII-V5)`QC*6"+CY!W0EU>\%04)@?4T4NS_\`4%#G`N$5NV$4
M8-"(EAMF<M:JTZ$AF&](BSQC8I0(1@XO^E=56BS-TBE_)$DA<'4A)G-T`QG$
MBKUZ].HD4G\(F$3")A$PB81,(F$3")A%'_EEX6.2_P!G_<OS=6/"*"]]^);7
M^:2GXE<S]4^?,Z1VJX)'FMY!L4@/+?\`"96OE=Y5?>NW9ES9;[BINR&TJL[U
MWK/Z?W*=&=M<M,(JS=Y>+2[_`&==`_.7RARN<]>]INB_:U33*GNIW2;L*KGW
MQM&^:.V=&[8U_::-39.'2L]8>6"\0S^R!%QUMKT:FN_K%<9R,4A,VM#X+[+(
MCM91H@JH#A9J^31,R7E/@3D\YSS94T!FF5)E4G6/($7%O62VP;'`$EWG&('`
M="A_C7G,9)RO(N(E";/FU/5L#C!H=U;W1=#$@!OFM@3HB-*JGV-R.G['9)NS
ML9NSVR\V!$&EBW#L5^G.7^::%5.X^#(I,J"$'2JLD]446:PT0U80[(ZIC-&+
M03"&?T1RWDNR9:INHM\EK20-YVE[X:WO.+N&`@T:@`OY[YGSS?,T5/77"<YS
M03NMT,9'4Q@P;P1,7'625_#C?Q*Y+<SY@7NF:4XF*FN]($[O.^/W=>U&R.=P
MHF]]2MRC.2D]BS38&JY#LZTSF#-7A$T9)6.*L1;(YFOQ7RSE@.I:5PK;HT0Z
MN41N-/!,FXM;QM:'O!TM&E23*/A#FG-1;5U;30VIQB9LX'?<.&7*,'.CI#G%
MC"-#CH5JN\O*HTYQ(XE6':UAL\]N??\`#;+XW)1FP94CFI5*G$L')K3U?FVV
MO=9Q4P_BHL)&"D5VAWTR[GIHJ#EPDB]1;.%6XT)__0<RYMS)2LN$[J[?UT1(
MEQ;+&!AO",7D<+RZ!T`:%H1OASE?)^6JI]ODB9<>H@9\R#IAT1W3"$L'@8&Q
M$-XNA%55\[/W"V?]#6WW,G\O*R?MKA\!-V*B,P?N;=_4)6U;J,QNMIIA$PBS
M0<O/&3RD]N]<?=LT7EW^'G<+OB'^RQ49XB_,`^'9[3U`?BWL?;U'MW,.DZ\%
MY48+>2.GH&W[8BY=-A9*_6]?V;D,ZLE/I`-U/A2*MMW2V"R;?#28$/$18/5&
MBJ$H=@Z;69FK)7^JKQ::JLPL]-1#K!&!F.B")8U@'2\X>3@#$Q%5Y1SQ_I.S
M7>EHL;U4UQZLD1$ML"#,.HD:&-Q\K$B`@?0[7V3"ZCK,=3::TC6$JE$M8N`A
MXYLW;1E5@F38C%B9)@W!-!H@T:HE29-RE!,`)UZ=@G9-9-!1,W&RV-#*66`T
M`"```@&@#``###0,`JSN-P>'.>]Q?5S"7$DQ,28EQ)Q))QQTG$KKWE@^7T[Y
M97%OR%WG$*O.-U/L+AQ7J_.)JJDY%7^(<K%<'E$G:`A):;I<V7M/1(H)++.-
M3,%A-&M))K)41XN^(X=UF4;"\=6/)J9C3IX9#3P#^\(U_IZ`\&^_!OPS+>KS
MEF%AZP^52RG#1K$]X.L_W0.K]326$7)>:VV57U)HM5/N^PSY'L'*_;,8INZ-
MHK?3,.Y`J9P.IW[LG4#"0.QVAZ]0`HT_D=P;F60/6;,'_EN/V*Z<]M+LL5!'
MHNEG_P`QH^U9V.0,2]GGVM(.,3*M)35B7B8]$ZA$2*O9%:(9M$S*JF*FD4ZZ
MQ0$QA`I0'J(],U'8N[+G\([V)BREF+O2U?&-]N6M:G"J;;V7AMQ+L;1)9!K8
M.,VAIML@X['K"+>5U957Z*2_='43[Y--<`-V3&+V@'H(AF+UMQ?4L7(XU@>O
M:SQ]@&>U9ID_5B9N]NY):'TI3';<PIOR/[NU9R"M]GXQ1)=$\-6$))1"2;^I
M2SN$[P').1<;W16X%KSOU'J-T\YT-Y\>`%=*BM=56^4T;LGUCHYM9YL.,+Q+
M;7#-.3;[)W3;_P!I5SA#JR+"=LB#:"U_KY990%#CK2@"\>0-+(T,<R+>4=KR
MEH,T/ZN[F'9,@-RO=97QZUVY3>J,!SG7SX<`"E]%:J:C@98WIWK'$\W!S8\:
MBAO7D5J.O*/)E!PFTB45BHSMJDI!*'A5W4@L1@R0CD'Z??/7[Z1<)(HE`4A<
MK'*FD10ZA!R+/<*F<)-(QSYKC"`!))XAI*[K1U$LS*AS6RQPF$.4KMGEUTN]
M0L!MZ[VVC6JB0^Q[;69&DL[O&?JY9IB!@ZBQB5IYY4'JP6>J-7D@"A$&DTTC
M902I"HHT33.D=2VLJVZJMEJZBL`;.=,+H1C`$``&&$<-1*KN_P!9(KJ_K:8D
MRPP-C"$2"='%BK'<DBXJ81,(F$3")A$PB81,(N(\D:/.;%T;LJJU4"FN*U=/
M-T<JAP32/?*B[:VZC$65,8@)('ML$S`Y^H"0@B(>D,(O8:LV-7MNZZIFS*JH
MJ:"ND`PG&:+D@I/XY1TD`/H65;&`JC*:@I`BK)\W.!5&SM!1(X%.00`BXMS1
MXUQ_+3CEL#2;ITTC).?0C9*K3CQ$54X.TU^3:RT0^[1"*+().#-CM'!TRF/Z
MHZ5``-U$HD57.K.%7)'@YSU@W'%",_6?B7NI#O\`8\'9IQ1"(HL3#G0)*M)6
M351>O#S\&YDQ=UE9))1R^2558K?U:;ER)%?6<Y$B'44.5--,ICJ*',!"$(0!
M,8YS&$"E*4H=1$?0`8114XHKFN,3M?>P=\,7R`VS*WBDF7`Y.^UA6*Q5=4:Y
MEFR0_DDC;G7M?%LC4?\`?.A-E,?H8>P0BE;A$PB81,(F$3")A$PB81,(H_\`
M++PL<E_L_P"Y?FZL>$4%[[\2VO\`-)3\2N9^J?/F=([5<$CS6\@V*0'EO^$R
MM?*[RJ^]=NS+FRWW%3=D-I59WKO6?T_N4Z,[:Y:815F[R\6EW^SKH'YR^4.5
MSGKWM-T7[6J:94]U.Z3=A53W,K4.TM^7.G:DTQ4T[CL&R7-5XSCWDY%5F$BH
M:*K!_AFSV2>EUB$85Z#!ZB9SZH@_DU"J`5HR=*]$AGW_`$\9OMN3,RW.Y7%L
MQ^_;MQC&")<_KI1A$P:T0!)).C0"<%6_C]DVZ9VR_;;9;'2V;EPWYCWF#6,$
MF8V,!%SC$@``:=)`B1,SBQY).GZ`>+N7*J99\A[JW4]<2UTDQ7B^/T$J<GY#
M.1J;TRDIN!9F591%5:R'^`WP`FN6!9N"%,%J9L\5,RYH+J:6_P#D[4?[J42"
MX<$R9@Y_&!NL.MD<5`<G^$F5\J;M3,9_.W80/6S0"&GAER\6LXB=]XU/A@KN
MXZ.CXB/8Q,2Q9Q<7%LVT=&QL<V191\='LD2-F;%BS;$2;M&;1ND5-)),I2)D
M*!2@```96:M)0#\TKP57SY4N*_WL=(9(,J_,-)VHV%1[-?R[5]B=H65_G9^X
M6S_H:V^YD_FJ+)^VN'P$W8LFY@_<V[^H2MJW49C=;33")A%F,Y23458.7G*F
M1A'S>4CD=H56#-(,C=^P/+U?0^FZS98]!X0!;.7-?LL0\C7I4S&]5D&:[93L
MK(JD)>?A_)G2\NB:]CA+?/>6D@@.`#1@=!Q!&&L%4/XA3Y,S,9E,>UTUE.P.
M`():27$1&D8$''40JUJELYAK4NWG0E3=SLC;E$8.,.)@(LLF[F06=NA)T,1D
MR!4IC]!`RAA*0!#M"8NF)$@SZ2F&A@DMB?[+5ER?4MIJNK.EYGN@/[3OJ"ZE
MP8X773S`-PS$A:WTS':&HT\W_;G?&;ES'2MHFEHYI+L]+4:89+MG$3996*D&
M3J9?->BL!7W"0("W>R$<X1JCQ5\1&Y=ICERQOA>IC/+>TXR&.&H@X37@@MUM
M:=_`EA5M>$GAL_,U4,S7]A-CEOC+8X?N)C3K!$#)800[4YPW,0'A;+JS6:Y2
MJY`T^GP,/5JG5H>-KU:K5>C6D/`U^!AVB,?$PT-$QZ+=C&Q<:Q;D1001(1))
M(@%*```!F3"23$Z5L```0&`"KD\T_P#<WJ#[0$7\SVZ,E.2?F>F_\3_TIBBF
M>/E>J_\`#_\`6EK/IL4X)['T$<W7LDV;"''I^'H6=K@CT_V]`S4EE>)=INCW
M>:VC<3S,F+*.8&E]WM+!I-:T?2^6K^^/_'C9D7QTT'ICD;<(69AM2:4U-JQ_
MJ/6#F8:ZNGG6NJ3!U-^\OECDFL/;=NQ\ZK$J&4BWC6'K*[%QZJ\AGITO6U/Y
MVW+,U34QE4<94CA],\_H\V/&OZ'4-BD2(3*F$R;P>B.;7SX<2Z3?-^4'6C,E
M=K3=G-246V2C64%!=PT@X1!FD5LV9KN6R8M&B#)-,$RMFY#F(!0(()AT$(;/
MK9<LD#RIG\:2I+*IW.`U,_C0H+Q$]R'YIR8EU!'LYJEI.$RK;;L:CR&X^UP#
MBLFJ:IJ,#*2^Z;"P[*I1;P7?LB.$CLY*;B51)UZ]LRO=+N1.K"9%'QCRCT6_
MF=RB*YE=?J&W`RJ>$VIXC@.5WV#G@K%M!\']6:9E(R^65P\W'N=AWZK39UZ9
M,1"HK/VQFT@SU/36I35W6,6JBLJW[]H5Q8'C(Q4).6DN[(<++MEFM]IE[E&P
M!Q&+CBYW*?L$!Q*$5URK+@_>J71;J:,&CD'VF)XU-#.HO`F$3")A$PB81,(F
M$3")A$PBAW.5N]\<[E9=@:MJ<MLC3>P)UW:=H:CK?<J76BW*3,12<V?J*+<*
M-VMECK.N`NK'62JHNUWXJ24:*[Q=RR=D7:-9[YT_N%);]G=_K\_),E#H3%8%
MR:*NU;>I%$ZT;:Z+-)QUPJLJ@4.JC619-ER!Z1+T$!PB])?-FZYU9#*6'95[
MJ%!@T@,(REOL437F1S``B"*"TJZ:E<N%.G0B2?:4.;H4I1$0#"*+TY*W#ET1
M:F5F'MNO>-+SM-[[L2P1\A3[GNN',/\`Q%%UC79-%I9('7EB;&!.6LS]!FL_
MCU#MHE$Y5QDFQ%,V.CV$1'L8J+9M8Z,C&;:/CH]D@FV9L6#)$C9FS:-D2D2;
MM6K=(I$R%`"D(4````,(ON81,(F$3")A$PB81,(F$3"*/_++PL<E_L_[E^;J
MQX107OOQ+:_S24_$KF?JGSYG2.U7!(\UO(-BD!Y;_A,K7RN\JOO7;LRYLM]Q
M4W9#:56=Z[UG]/[E.C.VN6F$59N\O%I=_LZZ!^<OE#E<YZ][3=%^UJFF5/=3
MNDW85Q?2GCIU_P"R6U_=ZIYX<B]ZS^P_,U>G-?["5VOY2KFLM10),(J]_-*\
M%5\^5+BO]['2&2#*OS#2=J-A4>S7\NU?8G:%E?YV?N%L_P"AK;[F3^:HLG[:
MX?`3=BR;F#]S;OZA*VK=1F-UM-,(JLN>_,62IJCSC?HR=49;<FHQ%79FPHI1
MNK^PBF3#,JK<D>N8CIL.[K@P=)JP+%9(Z<1'*#-OB]CX*93$^R'DJHS9<-^<
M',LTEPZU^C>.GJV'UCK/HMQ.):#7V?\`/%/E&W;D@M?>YS3U3#CNC1UKQZH,
M8#TW8#`.(HWO=QJVE:4QBHIBU(LDS^#:M7B',H4>Y3$`>/155,[5:(*#VW"Q
MSF675-Z3BH<3AKRBM=,9#*"5+8VAEM#0T`;H:,``-&C1]*QQ7W:I;/?7SICW
M5\QQ<7$G><XF)<3ITZ?H48>,7&79W-S>(:IHCQ:`0%,EOW!M(D<W>,-4TB5?
M/D2S*35VBI$O[M;)%DY9UF+6`Y7;I!RZ42481LAV(WXBYYI\CVAM-1`.O,YA
M;)8<0QH$#-=&,0W`-:?/=AH#B)%X:Y"J,^7E]57$MLDAX=/>,"]SCO"4R$(%
M^)<X>8W'`EH.V/2^FM<\?=85#3VIZZC5Z%2(T8Z$BR.'3YR<R[E=_)RTO*OU
MG,E.6">EG:[Z1?NE57;YZX576.=10QAQA4U,^LJ'U=4]TRIF.+G.<8ESB8DD
M\)*V_2TU/14[*2D8V72RF!K&M$`UK1``#4`%^_?=A4?5M7D+KL6UP5+JL8=H
MB[G+#(MXUB#N1=HQ\5&MSKG*=[+S,FY2:LF:`*.GKM9-!!-150A#>=SFM!<X
M@-&DE>@`N,!B2JRN6)=O<MJ#$I:^UI(4RA4:XM;W#/=BM7D+MO9#Z-9S-9`M
M;UD[6CSZ_J<E6;2\7]8M"B5F4.F=J->8JF0?A]LL9OLEOS13.JINY2-+PZ;`
MEC26.:!@"2"2`70@`8Q@,/)FG+%WN&6*F52RM^J<&;LN(#B&O:XG$@1`$0(Q
M,(0U&B'<Z#ZN[!TXE*QL@T?P^Q&9WT4Y:+-9)%5G+0*JK51FY(DLBYZ$Z=@X
M%$!_#FP+15TTW+5VK),QCZ4V^8X/:X%I;U<S$.!@1QQ@L<WZFJ968[1239;V
MU(N#&EA:0X'K)6!:1$'BA%6\WKDOLS=%N=ZFT[5;%;[/W3=1[K_7IVPNH:-?
MD%1I*[6ODDYBZOKZ#>-"JK(A*/&`R:22B3!O(NBD1/\`S0H;;=;Z_=I&;E-'
M%YP:.?6>)H/'PK^D-774%K;&H=O3X8-&)^C5RE2(U%Y<[!^=I9N5TY#[.?%5
M;/6FD:J,BEH>"530]+2UFDVL98M^.$EUURG//-8VM.D@;G_5I!XW!T>Q[/E6
MW6J$UXZZL'IN&`/X6X@<IB[@(T*%W*_UE?&6T]73'T0<3TCI/)@.)6=M&C5@
MU;,6+9NR8LFZ+1FS:(IMFK1JV3*BW;-FZ)2(H-T$2`0A"`!2E`````,DZX2^
MQA$PB81,(F$3")A$PB81,(F$3")A%`;S$=8:VM_'N<GK5K^EV.>CKMH]C'3T
MY5X24G(UG*[SUS#R3:.F'C):18(OXF1<-E@15("B"ZB9NI3F`2*1=,XT\=]=
MRR=AHVC-256R)&*<MGA->U5C:!.105$CJ65*+"<6,B8?ZL3N#"F4`*7H4``"
M+MV$3")A$PB81,(F$3")A$PB81,(H_\`++PL<E_L_P"Y?FZL>$4%[[\2VO\`
M-)3\2N9^J?/F=([5<$CS6\@V*0'EO^$RM?*[RJ^]=NS+FRWW%3=D-I59WKO6
M?T_N4Z,[:Y:815F[R\6EW^SKH'YR^4.5SGKWM-T7[6J:94]U.Z3=A7%]*>.G
M7_LEM?W>J>>'(O>L_L/S-7IS7^PE=K^4JYK+44"3"*O?S2O!5?/E2XK_`'L=
M(9(,J_,-)VHV%1[-?R[5]B=H65_G9^X6S_H:V^YD_FJ+)^VN'P$W8LFY@_<V
M[^H2MJW49C=;34$>;_+SZN]984?77P1-\A]D1TB-!AY5`\C`T>#;#ZG*;?V'
M'MGT:[<5"M/%DT6<:DX;O+'+*)LD%&[8LC)1LFRIE>NS7=&T%)Y,EOE39A$1
M+9PZHN.AK=9X`"1%\VYJH,I6IUPJ_*GN\F5+!@9C^#7!HTN=#`<)(!S>[1WA
MKSC['.G^P;':YRV6MQ+6A[,2,-9K79]A6R0<`>7G+!.04`\8%E9%X8!4`2MT
M&C8A$FK=)JB@@37=NIK1ENCDVBE#I5,QN$&/>3PN<6-,7..))A$\`6.[E5WC
M,M9.O-6YLVJ>[&+V,`]5K0]P@UHP`$8#3$Z8`0>YZ5N2[.K%<)^SIQ"*X%?J
M--=;,<)((I=E=M7(L&U3<^J]$G!1'M"!B)G%0PF.<.WZKIG&T6RD,JD<YU6<
M`#+F"'XG18.8:SAHT>&TY*O-WK!.K&L;1#%Q$V48P]!L'GG.H1.F$;8?)5Y3
MZ)USN7G.O.S5IC(B1K_&MO#"PU-M^;[*,):N5AW1'+>#H<FO&(MFLFV[!G()
M`KU,!.T*2G9S_P",]QDW&KMDV4YSG"C.\2US3O%P)\YK8\HB%HCP1MLZVTEU
ME36M:TUPW0US'#=#2!YCG0Y#`JVNW^:_IFSGCH;C8:>OB,Y$-)<N\K%IS?"F
MB:]'21ETFSN)4K]!_67<4^B5/U@D5"F8Q2Q"&1=S\6N9,#T#6W212-(9"9/]
M4.:,?Q$G#ZSQ+0-+;YM2X%T62O6()^@`8_4.->`BN1_$FL3K3:FW]L;'VAM-
MJ5R1AL+8FC=UMF-1,^;*)/XC4-):ZO;U+5\6Y9#ZJH$4W^&I5H@B$O(2KA+U
MDT$N5;<Z\_\`,.:V1'!H>T-]K$\L>*"EM%34%&/T073=;BTD[,!R<\5QO:WF
MVZ5.Y0K&O9>[LWTPG+DA2IZ6W),7RVJ0T4[F91E1:;'Z^?2LK(MXA@NX[EJ@
M[?&2()BII&+US@BCNE6_J:&5O.X0YA/!'SL!QGZEU354%.WK*I^Z.,.'V8GB
M"Y#K<FOMXSC2_P#(NX[+TW7R*N3MZ=`:5W=.;^L[%Z1NF]1N&SXS6LQ!:G82
M8(JI+-*RYEYU9J=!=&=AG1%F@6!9+#<*2W/M]RJY[[?->U[Z9LQXD.>V.ZY[
M8@/<(\`$=.]`%0NZW&WU-P9<:.ED-N$ICF,J'2V&<UKH;P8Z!+`80TQAP1(5
MLNLN3?"'3518T35S>RTFJ,%7#I.)A..O(1`KJ1>G!62FI=XIJY60G;#+N`%9
M](O57#Y\N8RJZJBAC&&5,8R4P2Y8#98$``(`#@`&A<1SW/<7O)+SI)Q)YU[_
M`.O?QF_O1L#^`'(7Z+,^R^J?7OXS?WHV!_`#D+]%F$3Z]_&;^]&P/X`<A?HL
MPB?7OXS?WHV!_`#D+]%F$3Z]_&;^]&P/X`<A?HLPB?7OXS?WHV!_`#D+]%F$
M3Z]_&;^]&P/X`<A?HLPB?7OXS?WHV!_`#D+]%F$3Z]_&;^]&P/X`<A?HLPB?
M7OXS?WHV!_`#D+]%F$3Z]_&;^]&P/X`<A?HLPB?7OXS?WHV!_`#D+]%F$3Z]
M_&;^]&P/X`<A?HLPB?7OXS?WHV!_`#D+]%F$3Z]_&;^]&P/X`<A?HLPBCKRI
MY4Z:VUIIWKS7CO8UDN-DV-HI&&AD=%;U8F=&8[UUO*OE57TKK=C&L6K&-8K.
M%EG"R2*2*1CG,!0$<(K2L(F$3")A$PB81,(F$3")A$PB81,(H_\`++PL<E_L
M_P"Y?FZL>$4%[[\2VO\`-)3\2N9^J?/F=([5<$CS6\@V*0'EO^$RM?*[RJ^]
M=NS+FRWW%3=D-I59WKO6?T_N4Z,[:Y:815F[R\6EW^SKH'YR^4.5SGKWM-T7
M[6J:94]U.Z3=A7%]*>.G7_LEM?W>J>>'(O>L_L/S-7IS7^PE=K^4JYK+44"3
M"*O?S2O!5?/E2XK_`'L=(9(,J_,-)VHV%1[-?R[5]B=H65_G9^X6S_H:V^YD
M_FJ+)^VN'P$W8LFY@_<V[^H2MJV&<K.3E8XO:V/:'S`+7?;(NXKVIM:-Y#X-
M?[`NQF:KELQ<21&4F>NU"'2)ZY/31FKDD5&IG4(@Z=&:LW.3++9J^_W&7;+<
MS>J9A_LM;K>XXP:W6>81)`.O;W>K?E^VS+I<G[E-+']ISM3&C"+G:ASF`!(S
MD6RW2+5U=]Q;?M0VF_6]XG,7BW'8IQX2#A`@LZ_5:O"HJKD@ZA6&)B1\+&$4
M5%%`IEW2[I\X?/G.Q\J96H\M6UEKH!O3"8S)A$'3'ZW'@`T-;Z+1#$Q)Q=F[
M-=;F:Y/NUQ.[*`A+E@Q;+9J:.$G2YT(N=C@(`0OH5`W+SMW]!ZIUHT(WDY("
MO).;?M7K^G:9UND[*E,7BU*,TTP=.A(0Z<7'BHV7L4SW30BK5J5R\8_IGC.5
M#D2S]8-V9=YP(DRSZ3M;WZQ+9K]8P:""2X>;(F2J_P`0;WU9WI5FDD&=,'HM
MU,9'`S'P@/5$7D$`-,U;?Q]UWQ<W-O+26KV;Q&L5"WZ_!22EG";VPVFP2G'?
M2,I9KE:'Z*#5![8[5.NUWKLR*+=JDHKW39!NU3103IG)E?672VSKA7S'3:R=
M5S'/<=))#.8#4`(`"```"O'.EOHK3<I-MM\MLJBDTDMK&C0`"_AQ).DDDDDD
MDDDE>U\KK2VO-E7SE_*;#3DYJNMG^K6D]1W]AD6NL[<WC)O=SZ)4V-3T'+:#
MOD?7U))X=LPF2/(DJKD7"C4[ENT6;1K_`*G)\VCHLO3*=Q8Z=35#7D&$6RQ3
M%HCJQF.C#3A'0NO_`-,K&55;F*3/:',DU-.YH.ITPU(<>/"6V$=&/"K8]M\M
M:)KJ&D_U<=0BK6!8+K2-GEG;>(HU<8,$Q%5TL^65:(.&3)!(1,<JB#0B8`8%
M3``AF,IE9%_5TX+YI,!#''BUD\BV$VG@W?FD-E@?5]BC'3=:\G>8,DWLT>5Y
MKC6KL.VGN3:D$_2>2\8N)3]K3&G%U(27E6#I-,W<S4T,'"F(HW?L$[`U.8@R
M:UY-K*UPJ;PXRI6G<'GGEU,'TNU$`KA5^9::F!DVX!\SUCYHY-;OJ'&5:#H3
MBEIWCN1Y(TV'>3M_FFBC*T[<O+EM8MH6AHLY0?*Q;RQE8L6\'5@?MB.$8"%:
MQ==9K@*C9@B8QA&QZ*@I+?)$BCEMER^+2>,G23QDDJ%5-745DSK:EY>_CU<@
MT`<04D<]:\Z81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A
M$PB81,(F$3")A$PBC_RR\+')?[/^Y?FZL>$4%[[\2VO\TE/Q*YGZI\^9TCM5
MP2/-;R#8I`>6_P"$RM?*[RJ^]=NS+FRWW%3=D-I59WKO6?T_N4Z,[:Y:815F
M[R\6EW^SKH'YR^4.5SGKWM-T7[6J:94]U.Z3=A7%]*>.G7_LEM?W>J>>'(O>
ML_L/S-7IS7^PE=K^4JYK+44"3"*O?S2O!5?/E2XK_>QTAD@RK\PTG:C85'LU
M_+M7V)VA9<>:<1(V#3DE`Q#?UN6FT)^(BVG>H-_6I&2JTTS9-^_=*HMD>^<K
M%+VU#D(7KU,8`ZCFK<O2IE0RMD2A&:^BF-:,!$G`")PT\."R1F:=+IWT$^<8
M2F5TMSCB8`8DP$28`:L5.S96RK7M2^67D%NUZP961W&N8R$@T79G=8TYK<CM
M)XSU]4EE2@===XJU;N[%*`4KBR3A`5["+)M%1T?YLB9*I\J4`80)EXG`=:\?
M5+8=(8W_`+Q\HZ@WU9^SQ49LN!F1,NRR">J8?KF/&@O=_P!T>2-9=5GN?;L_
MLVV5VMUB%GIY[8)]O6-;T6OP=BLT[-RSXW9<3#F`IL+9+.^;1C!-5_(&8Q[]
MPQC4%>X076Z)KR[,V9;1D2Q3+U=WM$,&MB`9CSYK&Q^DG4T%QT04)RSEN\9^
MOTNR6AA(.+G0);+E@C>F/A]#1K<0T:8K2'PQXI;/TAIX-?UAR?08V\8F:W+M
MHK*J6#D_N.SH-Q!TDQ(+B[ZPX_:V@E3.&-=ADG5ZDT()\=8743/J/'Z_\],Y
M^)-?F:ZS;D\[]1,,`<0QC!'=9+:3$-;$PT&,7&)))_H?D[P]MV5K1*M5,W<I
MY8B=!>]YAO/F.`@7N@(Z1`!H@``/*\D>/6CZHX?/=>3\BQV#(ND'EFBI&6F;
MW(6F33:-8Q6P7B\664EK<\MAXQ@W14>RK^2>KH-D$NR5,A3E].2?&`96EBTW
MF5U]N+W.WY8`FL+C$D@D->.*+7`:R`&KGYU\*?\`4TTW2TS>IN(8&[DPDRGA
MH@`"`7,/'!S2=0)+E!OAQJ/>LY8-PU[3];_7H]SMT<6SRI9]>!TU1E*O.VI`
M[78>S&["8B92UQHS2W:KM>:V&?8*&2,]:,T'`.4Y9XRYHM_BN^T4F7!.9:K;
M*FA]1-86-G.G-I\)4MT)C@SJ2"YX8"288")B7@UE"Y^&(N]9F$R77&Y3I19(
MEO#W2FR75&,V8V+`7]:"&L+R`,<3`7BZ+X`Z]H$E!W[<4L&^=M0SM"6AY.>B
M$XC65`F&RXKLGNL=5B]EXV)EXTP%,A.3+J=LJ"HJ^K2#9LKZHG";38+=:&QI
MF1J(8O=BX\,/5'$(<<58MPN];<70G.A*U-&#?]IXSS04_,[2YB81,(F$3")A
M$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(H
M_P#++PL<E_L_[E^;JQX107OOQ+:_S24_$KF?JGSYG2.U7!(\UO(-BD!Y;_A,
MK7RN\JOO7;LRYLM]Q4W9#:56=Z[UG]/[E.C.VN6F$59N\O%I=_LZZ!^<OE#E
M<YZ][3=%^UJFF5/=3NDW85Q?2GCIU_[);7]WJGGAR+WK/[#\S5Z<U_L)7:_E
M*N:RU%`DPBKW\TKP57SY4N*_WL=(9(,J_,-)VHV%1[-?R[5]B=H6:;D48I(&
MIG.8I"$MK0QC&$"E*4K-X)C&,/0`*`!U$1S7.3/WT[L?S-6.\\_L)';_`)7+
MP6Q+I:MZW6'U?K*,DIU&1F$(N$B(M(QWUKFCJ"FFX,0#@0L<@("=+O!(FDF4
MRZHE`/ZN7SZF@L-NFW>[362*23++YCWF#6-&GGU0$23!K02<83*DU]^N,JT6
MB4^=53I@9+8T1<]QT<VN)@`(N<0!AH?XL<>M6\$=6E<6^3B7FUK6V2<W2PMR
M@\D7JI2D43J=21%%&0_5B)6('4YB$!RY$5UQ('<IH_S?\7O%2J\0KYU\72<O
M4Q<VFDG3`Z9LP`D&:^`C`P8T!@])SOZ,^$?A=2>'=CZD[LW,-2&NJ9PT1&B5
M+)`(E,B81$7N)><-UK?%;/Y;6ZYV-'66JX&SRUJF6A'45KO7C1.<V=-1:ZSA
MFG,RR_K3*(HM15?-S(*3,H[BH1JXZ).)$HG`HU+24MSO,WJ;?+/5QQ=H`Y7:
M!R#$Z@5:]344-M9UE8\;^INDGD&OE.'(NGZD\O&>MYF]CY7V%LO%J"1RAQ^U
MI-2B%14(8>V#?;.R$T86T;(,82$%:'C$X.O&*HX8R!)]H<JHV%9\GT%OA.JX
M3ZL8XCR&GB;KY71X0`H;<LQU=9&53QE4_%YQY3JY!SDJTVO5VOU&"B*O5(*'
MK%9K\>UB(&NUZ,90L%"13%$K=C&1$1&H-H^-CV;<A2)(HID33(`%*4`#IDP4
M<7[&$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")
MA$PB81,(F$3")A$PBC_RR\+')?[/^Y?FZL>$4%[[\2VO\TE/Q*YGZI\^9TCM
M5P2/-;R#8I`>6_X3*U\KO*K[UV[,N;+?<5-V0VE5G>N]9_3^Y3HSMKEIA%6;
MO+Q:7?[.N@?G+Y0Y7.>O>TW1?M:IIE3W4[I-V%<7TIXZ=?\`LEM?W>J>>'(O
M>L_L/S-7IS7^PE=K^4JYK+44"3"*LSS![E#;?U-;^,>I1=;+W4I>-%V.=J5,
M;C+H4.#H6[M9[1G7>Q[(4R=8HCYS4*NZ6BXR2>-Y>;/V21[5S^6)/59KY:[3
M?J6;<)K9<D31O..(;I$3")A'`P!A&+H#%>&^6>XW2PU4FAE.F3G2CNM&EQP,
M!'#1HC".@1."SI\J8R2BH*)BI-@]CI-G:0;.HY\V6:OFS@L:^`4%VJY"+I*@
M(_[IB@/IS961:FGJ:B954\QCZ9TC>#VN!:1O#$.!@1QQ6+/$"GJ*>EETT]CV
M5+:B!8X$.!W78%IQ!XH*67%B(K7$>G'V186K)'<]O*C!,9F69_"SNH(S)P1C
MZ3KVMLB23VS7^T*@5,X-T5WCE0X,&C53^L.YQOXW^,M7XA77_2N4B]V69$S2
MT&-5,;_>$0!ZIG]VUV']Z[$M#-<>"/@]3Y!MG^ILT!@S/42]#H0I9;O[L&)'
M6N_O'-Q'NVX!Q?8#KGBGR-Y&R(6[:<K8M`:^D%$7'?2R49-<B;PP5:F7049P
MDPC,U32<28RC?L?#3>9L!D/66BT-!N$T765;:<D[Q%3>G%SM/5M/M.&QL.EJ
M5N7#-$`9-L$&^N1[+3M=]"M0TWHC4V@:TK5=34R/JS%ZNB]G9(5W\U;+A+(-
M4F*<]>[O8'<I<+W8_4D$T1D)=\]>=PF1/O.[(0I;!DR)-/*$FG:UDIN@-``'
M,%#YDV9.>9DUQ=,.DDQ)77,_5?1,(F$3")A$PB81,(F$3")A$PB81,(F$3")
MA$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PBC_P`LO"QR7^S_`+E^
M;JQX107OOQ+:_P`TE/Q*YGZI\^9TCM5P2/-;R#8I`>6_X3*U\KO*K[UV[,N;
M+?<5-V0VE5G>N]9_3^Y3HSMKEIA%6;O+Q:7?[.N@?G+Y0Y7.>O>TW1?M:IIE
M3W4[I-V%<7TIXZ=?^R6U_=ZIYX<B]ZS^P_,U>G-?["5VOY2K+MJ\@=<:C>QE
M<FWLC8MB6-FX>U#4]&CE+3LNV((&41%['UMF<@1%=*^3!LO/2ZT978]90GKL
M@V*/;RS*FJIZ.69M0X-9QZ^0:^90B13SJE_5R6ESOXT\"CU+QN]-Y)NR[0L3
MK1FL78JE2U3J*UOVNS)V*,5)1`=F;YA%(N4JKA4@CZQ$408]5BX2$H6>59JG
M2&$7+,\V=&71#<E^L=)YN#EYPI516&7*@^J.\_@&CZ?NYBN>V+=6G="5?]2M
M55^K,HZOHR"B436FD?7J+7146<2$F]>+QZ3=FJJJ\75=.A1`165,H=98BAC&
M&$U%?%Y@3,G'G^O7R!2B32P;H#)8YE#.$IF[.<=GC;O1:M71K#1STC>0^RH!
MPAK.*;=@@`[U#5F:T5:=U+-T'1#-GD>ZBZV[3[\A;*5VBHW-,K%0YLG4$VAG
M5E31V*IAUDEKW-ZT<!E@P`.O?&.!+70$(I>)N617RJ\4E-57FF)ZN:YC7&6>
M$/(C$:BW1B`YL3&TC0'##4.A7Z-Q33E=E[?%FX9N]Q;&,PE;<U;/4@1?Q=+8
M,6,=5]9UYXW*1)=E7V,>5^1%-20.]=`=R>9V^UT-KE=512PT'2=+G<KCB>30
M-0"CU97U5?,ZRI>7<`U#D&@;>$J6^=!>-,(F$3")A$PB81,(F$3")A$PB81,
M(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(H_\LO"Q
MR7^S_N7YNK'A%!>^_$MK_-)3\2N9^J?/F=([5<$CS6\@V*0'EO\`A,K7RN\J
MOO7;LRYLM]Q4W9#:56=Z[UG]/[E.C.VN6F$59N\O%I=_LZZ!^<OE#E<YZ][3
M=%^UJFF5/=3NDW85'JJ:XMMXY'MY:H;1E]5.ZE!6=:4EZ[6ZY.V22A9UI6HI
MW%P#VVMIBO5M^HN*)C/7$5*F!L"J:22*YTG2$6L-RFVRKFS)`!F/EPB=`Q:8
MPUKO76AEUU/+9-)#&OCAKP.$=2EAZ]I#C+$R4?"-!_6*<60E)]0\G(V_9=ZE
MTFB3!M8-B7FSR,K;;5+@P;IH!)3L@Y=>JHD23,8B1$P_2NN3YLPS:MY?.X/N
M&@#Z`OBEHF2F=73L#9?\:3I)4,+/OO<'(NV2FKM*U22N\TP72:SM9JKX(NE4
M4'B*2[-?=FTW2)X:K)G;.DG`1O1U//F7;<1D(_[E0"K?:+M?3&2WJZ..+W1#
M>;6X\0PX2%]:RY6^U"$T[]3ZHQ//J:.7'@BI6Z=\NRK-5F5KY,S$?NVSHK"\
M8:Y0CUF&@ZF?OT';)(U,?J.'6UIR)4;I=):T&<-!=-R/8Z(AE3&3RR;1EFVV
M@"8UO6U8]-PQ!_"-#>;'A)4)N-\K;B2QQW*?U&Z/[1TNV<05E.2)<9,(F$3"
M)A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,
M(F$3")A$PB81,(F$3"*/_++PL<E_L_[E^;JQX107OOQ+:_S24_$KF?JGSYG2
M.U7!(\UO(-BD!Y;_`(3*U\KO*K[UV[,N;+?<5-V0VE5G>N]9_3^Y3H_!Z1]`
M!G;T8G0N6HH6SE;759Z:H.CJY([YV'`NSQ4^G5W:$9K"ARY%%6RS/9&WGJ2U
M5AI")=E)\(PD3\.6YHW5(N6&52$!'@W"^TU&V$LATSAU<P&+N*$&G1O@KKT=
MHGU)C,!:SZ^>.`^MVO=(4>)>DV..D;3NK?FS*F78=K@ZS6"0E5AW<30*U5*9
M(W*<KU3KB4BXE;E;[`U?W^1^$)M46Y93HDHC$QA"F1&N;U7NN#A-GN(W8PCQ
MPP`&@8"`$3PEVE32V4;:,%DIOG0C#BCI)TG'$X#@`T*%\[N9:G7]RG2'TT_N
M>PF9X6KU2FP<A9MAV9J"L":3"LU:)9OIPZ$6Z*W&0D2HD9Q+8QG#MPV;E.N7
MB4%'7U]29=N8Y\PC$C0!PDG!NC23R8KIU=324DD/K'!K1H!TD\0TGF4A-4\#
MMG[340L_)J;D=;55ZH=XKI6AVHRVQ)PJBRBA";4W-6)$2UXZZ:@>MQ-+=G53
M<I`8EF=MU%6PV/:,E4M*1/N9$^HT[OH`\<<7\\!^%0JXYGJ*@&50@RI/#Z1^
MQO-$\:M5HU"I.L:K#T;753KU(IT`W,UAJS5HEE"0L:B=4ZZP-H^/10;D4<N5
M3JK'[/;66.90XF.8QAF[6M:T-:`&@8`:%%R2X[SC%Q7K<^5\)A$PB81,(F$3
M")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81
M,(F$3")A$PB81,(H_P#++PL<E_L_[E^;JQX107OOQ+:_S24_$KF?JGSYG2.U
M7!(\UO(-B^IPFY(UFH\:6%`H]>L6Y=N1.V.4(/\`7E`3:&2J[B1Y.[DEHO\`
M:=?)AQ'T/5R+V)?(OTF\L_3F9"..*\9'R)NRD>U[3<J2WV"E=4/`=U0@W2XX
MG5IAQZ%7UPH:FLN\]LEI(W\3J&`UKNE@H6PMM-PEN2]^915,;%,]=:+U1.35
M<U05L).TLPVCL%Z2!O6[&3<#J(KHN$:O591F?NW]<5,';&/W+,=351;*_3I_
MK^X?7`X@A=FALLBG@Z9Y<[ZOX^B.N*X_LOE9K+3E0&'U\A4JO4JG'M8U&;=I
M1U3U[58U(48]@RAV`?!C)-LBJHF@W(!6[8#B0J950,`9$9E9,GS>JI@Z9/<>
M`DD\0TDJ0MD,E2]^<0R4T<0`''J`7'*%HKDWRNE$;5/K6'2FMG9DSK;`V/7S
M$VU9XU0W51#6&HYY%!.AMC$,?N96W,T`;+D(9.NR318%PE=JR545!%3>G%K?
M]V#Y1Z1T-'$(GC!4?N&9Y4D&3;&ASO7(PYAI/*<.4*T?17&?3_'6+>-=<5H2
M6&=;L$KGL6QNUK+LR_+1QG2S1>XW:3[V7DFK)S(.3L8U,R$/$$<'0C6;-KV4
M"V+2TE-121(I&-ER1J`ASGA/"3B=:AD^HGU4PS:ASGS#K/\`&`XA@N]YZ%^*
M81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3"
M)A$PB81,(F$3")A$PB81,(F$3")A$PBC_P`LO"QR7^S_`+E^;JQX104O"A58
M"SJDZ]A1C)*%ZAT'LG*H8O4/Z!Z#F?)[@XO<-!)*N&4"T-!T@!?HZ]WG3M8:
M<K$0@W^%K3_]PN585@4K9%NN\LTTY3<3#WNQ30.Y34*IT*55<Y3`(E`#`;/U
ME5;)-.UNF9CASG2OH^0Z9.)T-PV*.K*W<@N9<TO':<AVUDJS&2482>QI=XZK
MG'VFND4UA73:3+5)]*;8LT<HDHB9A7TI/U9^7U.4D(8%`5+W;9EFZWDB=4QD
M41QB1B1^%NGD+H#@BN377R@ML9<G]6IX`<!RNT<PB>&"L%T+P4UAJ26AM@7E
M\YW=N>*`KEA?[E'-FL!2Y)1L9%VKJ#6Z2[^NZW)U<.4D9$5).UF8N#-'DV]1
M`H!9=KLENM#-VD9^H1B\XO/*=0XA`<2@]=<ZRXOC4.\@:&C!HYOM,3QJ;^=9
M<],(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3"
M)A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$7E;U3H?8E(N.O["#H:_>:K8
M:=.`Q7!J]&'LT0\A9,&;D4U0;NO4GI^[/V3=@_0>@].F$56&RM)\I]<,Y&KQ
M5.<<G*],!\&U2\4Z1U]1-@QQ%132*UW#4;A8*123'!'TFL-8==P\744[5?B$
M42&7KFYY)F%\;6\=4XXM>?-XP0#$#@A'E4TH<T,#85[3O@:6CSN(C"!YX<B]
M5J/RYR394+#RUG(B^"J03)Z$I+F3)I-@FHF*2C2^S,@SAK1O<ZR2BR:S>2:0
MU5<MEP1<0#A9`CX_<L^4[=;(3IPZ^L'I.'D@_A;B!RF)X"-"Y5RS#65T9<L]
M53G4#B1^(_8(#ABK0XZ.CXB/8Q,2Q9Q<7%LVT=&QL<V191\='LD2-F;%BS;$
M2;M&;1ND5-)),I2)D*!2@```9*EP%]S")A$PB81,(F$3")A$PB81,(F$3")A
M$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F
M$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB
F81,(F$3")A$PB81,(F$3")A$PB81,(F$3")A$PB81,(F$3"+_]D`


#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS">
        <int nm="BREAKPOINT" vl="372" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13777 when splitting the tooling beam redundant tools will be purged, tool drawn on T-Layer, partial beamcuts show X-dimension" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="11/15/2021 8:52:48 AM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End