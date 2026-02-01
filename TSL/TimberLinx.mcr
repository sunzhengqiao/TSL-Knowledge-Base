#Version 8
#BeginDescription
Updated 1/1/2015  v1.0

V1.5__7October2014__Bugfix in Timberlinx location during perpendicular conditions
V1.4__July 15 2014__Added a text display when nothing can be done
V1.3__July 3 2014__Qty is limited to a list
V1.2__June 13 2014__Now has a QTY capability
Updated 3/1/2014  v1.0























#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents

//Qty allowed
int arIQty[]={1,2};

PropDouble dOffL(0, 0, T("Lateral offset"));
PropDouble dOffV(1, 0, T("Vertical offset"));
PropInt iQty(0,arIQty,T("Quantity"));
PropDouble dSpacing(3,U(2),T("Spacing"));
PropDouble prdAddLength (2, 0, T("Allthread length (A475, A[A/B]675)"));
int x = 0;


String strType[] = {"A095", "A135", "A155", "A175", "A475", "AA675", "AB675", "B095", "B135", "B155", "B175"};
String stLabels[] = {"A095 TIMBERLINX", "A135 TIMBERLINX", "A155 TIMBERLINX", "A175 TIMBERLINX", "A475 TIMBERLINX W/ 7/8\" ALLTHREAD", "AA675 TIMBERLINX", 
"AB675 TIMBERLINX", "B095 TIMBERLINX",  "B135 TIMBERLINX", "B155 TIMBERLINX", "B175 TIMBERLINX"};

double arC2CLen[] = {7.875, 11.75, 13.75, 15.75, 7.75,11.75, 11.75, 7.75, 11.75, 13.75, 15.75};  
double arPipeLen[] = {9.5, 13.5, 15.5, 17.5, 9.5, 13.5, 13.5, 9.5, 13.5, 15.5, 17.5};
PropString prStrType (0, strType, T("Type"), 0);

String stPartName = prStrType + " Timberlinx" ;
String stAllthread = "" ;

String strSide[] = {T("Not Flipped"), T("Flipped") /*, T("90 Degrees")*/};
PropString prStrSide (1, strSide, T("Side"), 0);

String strNoYes[] = {T("No"), T("Yes")};
PropString prStrEndT (2, strNoYes, T("As end tool"), 0);
String strDirection[] = { T("Perp Female"), T("Parallel Male"), T("Perp Male")};
PropString prStrPar2Male(3, strDirection, T("Direction"), 1);
PropString prDrThr (4, strNoYes, T("Link Drill through"), 1);
String strPDrThr[] = {T("No"),T("Male"), T("Female"), T("Both")};
PropString prPDrThr(5,strPDrThr, T("Pipe Drill through"),0);
PropString pr475Rot(6, strNoYes, T("A475, AA675 As B type?"), 0);


////////////////////////////////////////
// insert routine
if (_bOnInsert)
{
	showDialogOnce();
	_Beam.append(getBeam("Select male beam"));
	_Beam.append(getBeam("Select female beam"));
	if ((prStrType == "A475") || (prStrType == "AA675") || (prStrType == "AB675"))
	{
		PrEntity ssE(T("\nSelect Additional Beams"),Beam());
		ssE.go();
		Entity ents[0]; // the PrEntity will return a list of entities, and not beams
		ents = ssE.set(); 

      	 Beam ssBeams[0]; // array of zero length 

	    for (int i=0; i<ents.length(); i++) {
      	  Beam bm = (Beam)ents[i]; // cast the entity to a beam 
		if (!bm.bIsValid()) continue;
      	  _Beam.append(bm);
		}
	}

	return;
}

if (_Beam.length() < 2)
{
	eraseInstance();
	return;
}

// define center to center distance
int iSel = strType.find(prStrType);

if (_Beam.length() >= 3)
{
	if (_bOnDbCreated)
	{
		prdAddLength.set(_Beam1.dD(_X0));
		//prStrPar2Male.set(T("Perp Female"));
		dOffV.set(_Beam1.dD(_X0));
	}
//	arC2CLen[4] = arC2CLen[4] + prdAddLength;
//	arPipeLen[4] = arPipeLen[4]  + prdAddLength;
//	arC2CLen[5] += prdAddLength;		//added for 675
//	arPipeLen[5] +=prdAddLength;		//added for 675		
//	arC2CLen[6] += prdAddLength;		//added for 675
//	arPipeLen[6] +=prdAddLength;		//added for 675

	//reportNotice("\n" + x);
}

if ((iSel == 4) || (iSel == 5) || (iSel == 6))
{
	arC2CLen[4] = arC2CLen[4] + prdAddLength;
	arPipeLen[4] = arPipeLen[4]  + prdAddLength;
	arC2CLen[5] += prdAddLength;		//added for 675
	arPipeLen[5] +=prdAddLength;		//added for 675		
	arC2CLen[6] += prdAddLength;		//added for 675
	arPipeLen[6] +=prdAddLength;		//added for 675	
}

double dC2CenLen = arC2CLen[iSel];
double dPipeLen = arPipeLen[iSel];


if (abs(_X0.dotProduct(_Y1)) > 0.0001)
{
//	reportMessage(T("Beams must be coplanar"));
//	eraseInstance();
//	return;
	prStrPar2Male.set("Perp Female");
}

int iSide = 1;
if (prStrSide == T("Flipped"))
	iSide *= -1;
int iEndTool = TRUE;
if (prStrEndT != T("Yes"))
	iEndTool = FALSE;

int iParToMale= FALSE;
int iPerpToMale= FALSE;
if (prStrPar2Male == T("Parallel Male"))
	iParToMale= TRUE;

if (prStrPar2Male == T("Perp Male"))
{
	iPerpToMale= TRUE;
	iParToMale= TRUE;
}


	
int iDrThrough = FALSE;
if (prDrThr != T("No"))
	iDrThrough = TRUE;

// depth in female beam
double dDF = U(3.9375, "inch")+dOffV;
if ( (iSel == 5) || (iSel == 6) )			//added for 675
	dDF = U(5.9375, "inch")+dOffV;		//added for 675

double dRad = U(1.25, "inch")*0.5;
double dRadTube = U(1.25, "inch")*0.5;

double dHM = U(10, "cm");//_Beam0.dD(

// stretchmale beam to female beam
if (iEndTool)
{
	Cut endCut(_Pt0, _Z1);
	_Beam0.addTool(endCut, TRUE);
}

// define drill locations

Vector3d vecXDir = _X1;
if (vecXDir.dotProduct(_X0) > 0)
	vecXDir = -vecXDir;
Vector3d vecMz =  _Beam0.vecD(_X1);
if (vecMz.dotProduct(_Z1) > 0) {
	vecMz = -vecMz;
}
vecXDir.vis(_Pt0, 30);
_X0.vis(_Pt0, 30);


double dMh = _Beam0.dD(_X1);
double dDp =abs( _X0.dotProduct(vecXDir));
double dAngle = acos(dDp);
double dLen = (dMh);
if ((dDp != 0) && (sin(dAngle) != 0))
	dLen /= sin(dAngle);

Display dp(-1);

//Point3d ptDrF;
Point3d arPtDrF[0];
Vector3d vecConTb = _Z1; // connecting tube dir
double dAddD = U(2.5, "inch"); // additional pin depth
Plane plFace (_Pt0, _X0);

if (iParToMale)
{
	Line ln1(_Pt0+vecMz*dOffL, _X0);
	Point3d pt = ln1.intersect(_Plf,0);
//	Point3d pt = ln1.intersect(plFace,0);
	
	pt.vis(100);
	
	Point3d ptDrF = pt +_X0*(dDF);
	vecConTb = _X0;

	if (iPerpToMale)
	{
		int dLength;
		//Vector3d perpX0;		
		
		vecConTb = _Y0;
		
		
		if (abs(vecConTb.dotProduct(_X1)) < .01)
			vecConTb = _Z0;

		if (vecConTb.dotProduct(_Z1) < 0)
		{
			vecConTb = -vecConTb;
		}
		
		ptDrF = pt + vecConTb*(dDF);
		
		//dLength = sqrt( 2*(dC2CenLen*dC2CenLen));
		dLength = (_Beam0.dD(vecConTb)/sin(_X0.angleTo(_X1))) *.33;
		
		vecConTb.vis(_Pt0, 30);

		if (_X1.dotProduct(_X0) < 0)
			ptDrF = ptDrF +_X1*dLength;
		else 
			ptDrF = ptDrF -_X1*dLength;
			
		//Append a qty
		Vector3d vOff = vecXDir;
		ptDrF.transformBy(-vOff * (dSpacing * (iQty-1)/2));
		for(int q=0;q<iQty;q++)
		{
			arPtDrF.append(ptDrF);
			ptDrF.transformBy(vOff * dSpacing);
		}

		//if (vecConTb.dotProduct(_XU) < 0)
		//	vecConTb = vecConTb.rotateBy(270, _Zf);
		//else vecConTb = vecConTb.rotateBy(90, _Zf);
	}	
}
else
{
	if (vecXDir.dotProduct(vecMz) > 0) vecXDir *= -1;
	Point3d ptA = _Pt0+vecXDir*dLen*0.5;
	ptA -= _Z1*dHM;
	ptA.vis(3);

	// define second reference point

	vecMz.vis(_Pt0, 5);
	Plane plH(_Beam0.ptCen()+vecMz*dMh*0.5, vecMz);
	Line lh(ptA, _X1);
	Point3d ptB = lh.intersect(plH, 0);
	ptB.vis(4);
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
	// now two reference points are defined (ptA, ptB)
	Point3d ptMid = ptA + (ptB-ptA)*0.5;
	// project on to beam plane
	Line lnDr(ptMid, _Z1);

	Point3d ptDrF = lnDr.intersect(_Plf, dDF);
	//ptDrF = lnDr.intersect(plFace, dDF);
	ptDrF += vecXDir*dOffL;	
	
	//Append a qty
	ptDrF.transformBy(-vecXDir * (dSpacing * (iQty-1)/2));
	for(int q=0;q<iQty;q++)
	{
		arPtDrF.append(ptDrF);
		ptDrF.transformBy(vecXDir * dSpacing);
	}	
}


//__Stop here if no points are found
if(arPtDrF.length() == 0)
{
	dp.draw("TLX",_Pt0,_XW,_YW, 0, 0, _kDeviceX);
	return;
}




//__Maps for output
Map mpKeynoteData, mpHardwareData;


for(int i=0;i<arPtDrF.length();i++)
{
	
	
	Point3d ptDrF = arPtDrF[i];

	
	ptDrF.vis(1);
	// offset to side
	Point3d ptDr1 = ptDrF + _Y1*_W1*0.5*iSide;
	Point3d ptDr2 = ptDr1- _Y1*(_W1*0.5+dAddD)*iSide;
	
	//ptDr1.vis(230);
	//ptDr2.vis(230);
	
	if (!iDrThrough)
		ptDr2 = ptDr1- _Y1*(_W1*0.5+dAddD)*iSide;
	else
		ptDr2 = ptDr1- _Y1*_W1*iSide;
	
	Drill drF(ptDr1, ptDr2, dRad);
	for (int k=0; k <_Beam.length(); k++)
		_Beam[k].addTool(drF);
	Body peg(ptDr1, ptDr1- _Y1*(_W1*0.5+dAddD)*iSide, dRad*0.8);
	dp.draw(peg);
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// create holes for connector tube
	double dAddLen = U(.75, "inch");
	double dAddLen2 = (dPipeLen-dC2CenLen)*0.5;
	Point3d ptDrC1 = ptDrF+vecConTb*dAddLen2 ;
	Point3d ptDrC2 = ptDrF-vecConTb*(dC2CenLen+dAddLen2);
	
	//ptDrC1.vis(35);
	//ptDrC2.vis(35);
	//ptDrF.vis(105);
	
	Body ct(ptDrC1 , ptDrC2, dRad*0.8);
	
	Drill drCT(ptDrC1+vecConTb*dAddLen , ptDrC2-vecConTb*dAddLen, dRadTube);
	
	if ( (prPDrThr == T("Female")) || (prPDrThr == T("Both")) )
	{
		if (vecConTb.dotProduct(_Z1) >= 0)
		{
			ptDrC1 = ptDrC1 + vecConTb* U(10);
			ptDrC1.vis(35);
		}
		else
		{
			ptDrC2 = ptDrC2 - vecConTb* U(10);
			ptDrC2.vis(65);		
		}
	
		drCT = Drill (ptDrC1+vecConTb*dAddLen, ptDrC2-vecConTb*dAddLen, dRadTube);
	}
	
	if ((prPDrThr == T("Male")) || (prPDrThr == T("Both")) )
	{
		if (vecConTb.dotProduct(_Z1) >= 0)
		{
			ptDrC2 = ptDrC2 - vecConTb* U(10);
			ptDrC2.vis(65);
		}
		else
		{
			ptDrC1 = ptDrC1 + vecConTb* U(10);
			ptDrC1.vis(35);
		}
		
	
		drCT = Drill (ptDrC1+vecConTb*dAddLen , ptDrC2-vecConTb*dAddLen, dRadTube);
	}
	
	
	Point3d ptD1 = ptDrF+vecConTb*dAddLen;
	Point3d ptD2 = ptDrF-vecConTb*(dC2CenLen+dAddLen);
	ptD1.vis(5);
	ptD2.vis(4);
	double dT = (ptD1-ptD2).length();
	
	ct.addTool(drF);
	// make second peg drilling
	
	if ( (iSel == 5) || (iSel == 6) )
	{
		drF.transformBy(-vecConTb*dC2CenLen);
		peg.transformBy(-vecConTb*dC2CenLen);
		if (pr475Rot == "Yes")
		{
			CoordSys csRotate;
			csRotate = _Beam1.coordSys();
			csRotate.setToRotation(270,_Beam1.vecD(_X0),ptD2);
			peg.transformBy(csRotate);
			drF.transformBy(csRotate);
		}
	
	
		for (int k=0; k<_Beam.length(); k++)
			_Beam[k].addTool(drF);
		ct.addTool(drF);
		dp.draw(peg);
	
		if (pr475Rot == "Yes")
		{
			CoordSys csRotate;
			csRotate = _Beam1.coordSys();
			csRotate.setToRotation(270,-_Beam1.vecD(_X0),ptD2);
			peg.transformBy(csRotate);
			drF.transformBy(csRotate);
		}
		
		drF.transformBy(vecConTb*dC2CenLen);
		peg.transformBy(vecConTb*dC2CenLen);
	
	}
	
	
	if ((iSel >= 6) || ((pr475Rot == "Yes") && ((iSel == 4))  ))
	{
		//reportNotice("\n" + iSel+ ": " +prStrType);
	
		Point3d ptDr3 = ptDrF + _X1*_Beam0.dD(_X1)*0.5*iSide;
		Point3d ptDr4 = ptDr3- _X1*(_Beam0.dD(_X1)*0.5+dAddD)*iSide;
	
		if (!iDrThrough)
			ptDr4 = ptDr3- _X1*(_Beam0.dD(_X1)*0.5+dAddD)*iSide;
		else
			ptDr4 = ptDr3- _X1*_Beam0.dD(_X1)*iSide;
	
		ptDr1.vis(220);
		ptDr2.vis(220);
	
		ptDr3.vis(230);
		ptDr4.vis(230);
	
		drF = Drill(ptDr3, ptDr4, dRad);
	
		
		CoordSys csRotate;
		csRotate = _Beam1.coordSys();
		csRotate.setToRotation(270,_Beam1.vecD(_X0),ptD2);
		
	//	drF.transformBy(csRotate);
		peg.transformBy(csRotate);	
	}
	
	if ( (iSel == 5) || (iSel == 6) )
	{
		if (iSel == 6)
		{
			drF.transformBy(-vecConTb*2);
			peg.transformBy(-vecConTb*2);
		}
		else 
		{
			drF.transformBy(-vecConTb*3);
			peg.transformBy(-vecConTb*3);	
		}
	
		for (int k=0; k<_Beam.length(); k++)
			_Beam[k].addTool(drF);
		ct.addTool(drF);
		dp.draw(peg);
		
		if (pr475Rot == "Yes")
		{
			CoordSys csRotate;
			csRotate = _Beam1.coordSys();
			csRotate.setToRotation(270,_Beam1.vecD(_X0),ptD2);
			peg.transformBy(csRotate);
			drF.transformBy(csRotate);
		}
	
	
		if (iSel == 6)
		{
			drF.transformBy(-vecConTb*(dC2CenLen- 4));
			peg.transformBy(-vecConTb*(dC2CenLen- 4));
		}
		else
		{
			drF.transformBy(-vecConTb*(dC2CenLen- 6));
			peg.transformBy(-vecConTb*(dC2CenLen- 6));		
		}
	
		for (int k=0; k<_Beam.length(); k++)
			_Beam[k].addTool(drF);
		ct.addTool(drF);
		dp.draw(peg);
	}
	
	else
	{
		drF.transformBy(-vecConTb*dC2CenLen);
		peg.transformBy(-vecConTb*dC2CenLen);
	
		for (int k=0; k<_Beam.length(); k++)
			_Beam[k].addTool(drF);
		ct.addTool(drF);
		dp.draw(peg);
	}
	
	for (int k=0; k<_Beam.length(); k++)
		_Beam[k].addTool(drCT);
	dp.draw(ct);
	
	
	//__Fill BOM DATA//__Maps for output
	Map mpTool, mpPart;
	String stLabel = stLabels[ strType.find( prStrType ) ] ;
	mpTool.setString( "stToolName", stLabel ) ;
	mpTool.setString( "stMapName", "TimberLinx" ) ;
	mpTool.setPoint3d( "ptTool", ptDrF ) ;
	mpKeynoteData.appendMap( "mpTool", mpTool ) ;

	mpPart.setString( "stPartName", stPartName ) ;
	mpPart.setString( "stSortKey", "Timberlinx" ) ;
	mpHardwareData.appendMap( "mpPart", mpPart ) ;
	if( stAllthread != "" )
	{
		mpPart.setString( "stPartName", stAllthread ) ;
		mpPart.setString( "stSortKey", "Allthread" ) ;
		mpHardwareData.appendMap( "mpPart", mpPart ) ;
	}
	
}
// BOM
Hardware tmlx("Timberlinx", "Timberlinx connector", strType, dC2CenLen, dRad*2, iQty, "");


_Map.setMap( "mpKeynoteData", mpKeynoteData ) ;
_Map.setMap( "mpHardwareData", mpHardwareData ) ;











#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0```0`!``#__@`N26YT96PH4BD@2E!%1R!,:6)R87)Y
M+"!V97)S:6]N(%LQ+C4Q+C$R+C0T70#_VP!#`%`W/$8\,E!&049:55!?>,B"
M>&YN>/6ON9'(________________________________________________
M____VP!#`55:6GAI>.N"@NO_____________________________________
M____________________________________Q`&B```!!0$!`0$!`0``````
M`````0(#!`4&!P@)"@L0``(!`P,"!`,%!00$```!?0$"`P`$$042(3%!!A-1
M80<B<10R@9&A""-"L<$54M'P)#-B<H()"A87&!D:)28G*"DJ-#4V-S@Y.D-$
M149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@X2%AH>(B8J2DY25EI>8
MF9JBHZ2EIJ>HJ:JRL[2UMK>XN;K"P\3%QL?(R<K2T]35UM?8V=KAXN/DY>;G
MZ.GJ\?+S]/7V]_CY^@$``P$!`0$!`0$!`0````````$"`P0%!@<("0H+$0`"
M`0($!`,$!P4$!``!`G<``0(#$00%(3$&$D%1!V%Q$R(R@0@40I&AL<$)(S-2
M\!5B<M$*%B0TX27Q%Q@9&B8G*"DJ-38W.#DZ0T1%1D=(24I35%565UA96F-D
M969G:&EJ<W1U=G=X>7J"@X2%AH>(B8J2DY25EI>8F9JBHZ2EIJ>HJ:JRL[2U
MMK>XN;K"P\3%QL?(R<K2T]35UM?8V=KBX^3EYN?HZ>KR\_3U]O?X^?K_P``1
M"`&3`6@#`1$``A$!`Q$!_]H`#`,!``(1`Q$`/P"W0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`+0`M`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`-H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*``'%`#J`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`;0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`
M%`!0`4`%`!0`4`%`!0`4`%``#0`Z@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
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
M0`V@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`#%`!B@!<4`&*`%H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`&T`%`!0`4
M`%`!0`4`%`!0`4`%`!B@!<4`&*`%H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`;0`4`%`!0`4`%`!B@`Q0
M`N*`#%`"T`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`#:`"@`Q0`N*`#%`"T`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`)0`M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`
G4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`/_9
`

































#End
#BeginMapX

#End