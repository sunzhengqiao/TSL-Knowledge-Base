#Version 8
#BeginDescription
Show other beams in the shopdrawing of a primary selected beam.
KR: 9 Dec 04: Added global property for turning the shopdraw generation off.
KR: 9 Dec 04: Remove the other TSL's with the same name that are attached to the primary beam automatically.
KR: 9 Dec 04: Initial version.



Version 1.1 23.03.2023 HSB-18119 versioning added , Author Thorsten Huck
#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
//#Versions
//Version 1.1 23.03.2023 HSB-18119 versioning added , Author Thorsten Huck

Unit(1,"mm");

String arYesNo[] = { T("Yes"), T("No") };

PropString pTop(0,arYesNo,T("Show in Top"));
PropString pBottom(1,arYesNo,T("Show in Bottom"));
PropString pFront(2,arYesNo,T("Show in Front"));
PropString pBack(3,arYesNo,T("Show in Back"));
PropString pLeft(4,arYesNo,T("Show in Left"));
PropString pRight(5,arYesNo,T("Show in Right"));
PropString pIso(6,arYesNo,T("Show in Isometric"));

PropString pDim(7,arYesNo,T("Turn on dimensioning"),1);
int nDim = FALSE;
if (pDim==T("Yes")) nDim = TRUE;

PropString pTurnOff(8,arYesNo,T("Turn off"),1);

/////////////////////////////////////////////////////////////////////////

if (_bOnInsert) {

  // select beam
  _Beam.append(getBeam(T("Select the primary beam for the shopdrawing")));

  // position this TSL on the axis of the beam
  _Pt0 = _Beam[0].ptCen()+0.2*_Beam[0].dL()*_Beam[0].vecX();

  showDialogOnce();

  // select other beams
  PrEntity ssE(T("Select a set of additional beams to be shown in the shopdrawing of the primary"),Beam());

  if (ssE.go()) { // let the prompt class do its job, only one run
    Beam bSet[] = ssE.beamSet();
    for (int b=0; b<bSet.length(); b++) {
      if (bSet[b]!=_Beam[0]) 
        _Beam.append(bSet[b]);
    } 
  }

  reportMessage("\nNo beams selected to be shown is " + (_Beam.length()-1) );

  // find the TSL's with the same name that are attached to this primary beam
  if (_Beam.length()>1) { // at least 2, so this instance will be added

    int nErased = 0;
    Entity arETools[] = _Beam[0].eToolsConnected();
    for (int e=0; e<arETools.length(); e++) {
      TslInst tsl = (TslInst)arETools[e];

      // if the etool is a tsl and the tsl's scriptname is the same as this one, erase the other
      if (tsl.bIsValid() && (tsl.scriptName()==scriptName()) ) {
        // there can be only one
        nErased++;
        tsl.dbErase();
      }
    }
    reportMessage("\nNo other tsls erased is " + nErased );
  }

  return;
}

/////////////////////////////////////////////////////////////////////////

// The first beam appended is _Beam0.
// _Beam0 will become invalid if the beam is erased.
if ( (!_Beam0.bIsValid()) || (_Beam.length()<1) ) {
  eraseInstance();
  return;
}

Beam bm0 = _Beam0;
Vector3d X0 = bm0.vecX();

// collecting the view directions from the properties
Vector3d arVecView[0]; // used view directions
int arShowDim[0]; // allowdimensioning in this view
if (pTop==T("Yes")) { arVecView.append(bm0.vecZ()); arShowDim.append(TRUE); }
if (pBottom==T("Yes")) { arVecView.append(-bm0.vecZ()); arShowDim.append(TRUE); }
if (pFront==T("Yes")) { arVecView.append(-bm0.vecY()); arShowDim.append(TRUE); }
if (pBack==T("Yes")) { arVecView.append(bm0.vecY()); arShowDim.append(TRUE); }
if (pLeft==T("Yes")) { arVecView.append(-bm0.vecX()); arShowDim.append(FALSE); }
if (pRight==T("Yes")) { arVecView.append(bm0.vecX()); arShowDim.append(FALSE); }
if (pIso==T("Yes")) {
  arVecView.append(bm0.vecZ()-bm0.vecX()-bm0.vecY());
  arShowDim.append(FALSE);
}


// define some special dimensioning points and information to be shown in the dimensioning
//DimTool dt(_Pt0,bm0.vecY()); // construct the tool with at least one point and one view direction
//bm0.addTool(dt); // add the tool as a normal tool to the beam


// define my representation in model space
double dL1 = 0.3*_H0;
double dL2 = 0.3*_W0;
double dL3 = dL1+dL2;
Vector3d vecL1 = _Z0;
Vector3d vecL2 = _Y0;
Vector3d vecL3 = _X0;
PLine pl1(_Pt0-dL3*vecL3, _Pt0, _Pt0+dL1*vecL1);
PLine pl2(_Pt0+dL1*vecL1, _Pt0+dL2*vecL2, _Pt0);

Display dpTsl(-1);
dpTsl.draw(pl1);
dpTsl.draw(pl2);


// if TSL is turned off, do nothing further
if (pTurnOff==T("Yes")) {
  return; // end execution here
}

// loop over all viewdirections, and display for shopdrawing
for (int v=0; v<arVecView.length(); v++) {

  Vector3d vecView = arVecView[v];
  int nShowDim = arShowDim[v];

  vecView.vis(_Pt0);

  Display dp(-1);
  dp.showInTslInst(FALSE); // do not show in normal model
  dp.showInShopDraw(bm0); // do show in shopdraw of beam bm0
  dp.addViewDirection(vecView); // appear for a particular view

  // loop over additional beams
  for (int b=1; b<_Beam.length(); b++) {
    Body bd = _Beam[b].realBody();
    dp.color(_Beam[b].color());
    dp.draw(bd); // draw body of beam

    if (nDim && nShowDim) {
      Point3d pnts[] = bd.extremeVertices(X0);
      for (int p=0; p<pnts.length(); p++) {
        DimTool dt(pnts[p],vecView);
        bm0.addTool(dt);
      }
    }

  }
}






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
M"`&3`6@#`1$``A$!`Q$!_]H`#`,!``(1`Q$`/P"E0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`
M%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
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
I0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0``_]D4
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
      <str nm="Comment" vl="HSB-18119 versioning added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="3/23/2023 9:01:41 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End