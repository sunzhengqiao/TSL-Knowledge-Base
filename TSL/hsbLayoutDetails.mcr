#Version 8
#BeginDescription
Version 1.1  19.11.2009   th@hsb-systems.de
   - bugfix metric units

   - bugFix: no detail tsl found
Version 1.02   10.02.2005   th@hsb-systems.de
   - keine Anzeige bei Elementen ohne Details
   - Setup Grafik ergänzt

  - nothing will be displayed if you set an element in layout which
    does not have linked detail to this viewport
   - option 'show setup graphics' added
Version 1.01   02.02.2005   th@hsb-systems.de
   - stellt ein gewähltes Ansichtsfenster gemäß
     zugeordneter Details ein
   - das Ansichtsfenster muss ein hsbAnsichtsfenster
     sein, es müssen die Layer 'Info' und 'Bemassung'
     der Layergruppe Stab aktiviert sein.
   - die Zuordnung erfolgt im Modellbereich
     über das TSL 'hsbElementDetails'
   - für die Detailzeichnung dürfen alle AutoCAD-Objekte
     gewählt werden. Blöcke und xRefs müssen auf dem 
     Layer '0' gezeichnet werden

    The tsl group hsbElementDetails and hsbLayoutDetails
    are extending the layout funcionalitity to draw scaled
    details, texts, blocks etc. linked to one or more elements.
    See documentation for further information




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents

/*
*  COPYRIGHT
*  ---------
*  Copyright (C) 2005 by
*  thorsten huck
*  hsb SYSTEMS gmbh
*  Germany
*
*  The program may be used and/or copied only with the written
*  permission from hsb SYSTEMS gmbh, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*/


Unit(1,"mm"); // script uses mm

// Props
	double dArScale[] = {10,8,4,2,1,0.5,0.2,0.1,0.05,0.02,0.01};
	double dArScaleCM[] = {100,80,40,20,10,5,2,1,.5,.2,.1};
	double dArScaleM[] = {10000,8000,4000,2000,1000,500,200,100,50,20,10};
	if (U(1000) == U(1,"m"))
		dArScale = dArScaleM;
	else if (U(10) == U(1,"cm"))
		dArScale = dArScaleCM;
				
	String sArScale[] = {"10:1", "8:1", "4:1", "2:1", "1:1","1:2","1:5","1:10","1:20","1:50","1:100"}; 
	PropString sScale(0,sArScale,T("Scale"));
	sScale.setDescription(T("Scale of the selected viewport"));
	PropString sDimStyle(1,_DimStyles,T("Dimstyle"));	
	sDimStyle.setDescription(T("The appearance of all written information is dependent from the dimstyle"));
	String sArNY[] = {T("No"),T("Yes")};
	PropInt nDetailNo (1,0,T("Detail Number"));
	nDetailNo.setDescription("Numbers the detail when more than one will be used in the same layout");
	PropInt nColor (0,251,T("Color"));
	nColor.setDescription(T("Sets the color of the detail information"));
	PropString sShowForSetup(2,sArNY,T("Show setup graphics"));
	sShowForSetup.setDescription(T("Shows a rectangle of 100 drawing units to setup the tsl.") + " " + T("Should be turned off after setup."));

// on insert
	if (_bOnInsert) {
		showDialog();
		_Pt0 = getPoint(); // select point
		Viewport vp = getViewport(); // select viewport
		_Viewport.append(vp);
		return;
	}

// restrict color index
	if (nColor > 255 || nColor < -1) nColor.set(251);

// find selected scale
	int f;
	for (int i = 0; i <dArScale.length(); i++)
		if (sArScale[i] == sScale)
			f=i;
	double dScale = dArScale[f];

// Vectors
	Vector3d vx, vy;

// set the diameter of the 3 circles, shown during dragging
	setMarbleDiameter(U(4));



// check running conditions
	if (_Viewport.length()==0) return;
	Viewport vp = _Viewport[0];
	Element el = vp.element();

// check if this viewport has hsb_data
	if (!el.bIsValid()) return;


// check attached tsl's and get the midpoint of details
	int nDetFound;
	Point3d ptMid, ptRef[0];
	double dWMS;
	TslInst tslList[] = el.tslInstAttached();
	for (int i = 0; i < tslList.length(); i++) {
		String sTSLName = tslList[i].scriptName();
		sTSLName.makeUpper();
		String sTSLNameToCheck = "hsbElementDetails";
		sTSLNameToCheck.makeUpper();
		if (sTSLName == sTSLNameToCheck){
			if (tslList[i].map().hasInt("nDetNo")){
				if (nDetailNo == tslList[i].map().getInt("nDetNo")){
					ptRef.append(tslList[i].gripPoint(0));
					ptRef.append(tslList[i].gripPoint(1));
					if (tslList[i].map().hasPoint3d("ptMid"))
						ptMid = tslList[i].map().getPoint3d("ptMid");
					nDetFound = TRUE;
				}
			}
		}
	}// next i

// detail found
	CoordSys csEl = el.coordSys();
	Point3d ptCen = vp.ptCenPS();
	CoordSys csMs2Ps;

	if (nDetFound){
		// get the coordinate system of the element, and calculate a new ModelSpaceToPaperSpace transformation
		csMs2Ps.setToAlignCoordSys(ptMid,_XW,_YW,_ZW,ptCen,_XW*dScale,_YW*dScale,_ZW*dScale);	
	}
	else
		csMs2Ps.setToAlignCoordSys(Point3d(0,0,U(100000)),_XW,_YW,_ZW,ptCen,_XW,_YW,_ZW);	
	vp.setCoordSys(csMs2Ps); // finally set the transformation to the viewport


// Display
	String sDetTxt;
	Display dp(nColor);
	if (nDetFound){
		if (nDetailNo > 0)
			sDetTxt = T("Detail") + " " + T("No.") + nDetailNo + "  ";	
		dp.dimStyle(sDimStyle);
		if (nDetFound || sShowForSetup == sArNY[1])	
			dp.draw(sDetTxt + T("Scale") + ": " + sScale ,_Pt0,_XW,_YW,1,1);
	
	ptMid.vis(1);
	ptCen.vis(2);
	}

// Display Setup
	if (sShowForSetup == sArNY[1]){
		double dDwgU = U(50);
		Display dpSetup(1);
		dpSetup.dimStyle(sDimStyle);
		PLine plSetup(_ZW);
		plSetup.addVertex(ptCen - _XW * dDwgU * dScale - _YW * dDwgU * dScale);
		plSetup.addVertex(ptCen - _XW * dDwgU * dScale + _YW * dDwgU * dScale);
		plSetup.addVertex(ptCen + _XW * dDwgU * dScale + _YW * dDwgU * dScale);
		plSetup.addVertex(ptCen + _XW * dDwgU * dScale - _YW * dDwgU * dScale);
		plSetup.close();
		dpSetup.draw(plSetup);
		dpSetup.draw((dDwgU*2) + " " + T("drawing units"),ptCen - _YW * dDwgU * dScale, _XW,_YW, 0,-1.2);
		dpSetup.draw(T("Show setup graphics") + "=" + T("Yes") ,ptCen + _YW * dDwgU * dScale, _XW,_YW, 0,1.2);
		dpSetup.draw(scriptName() ,ptCen, _XW,_YW, 0,0);
	}






#End
#BeginThumbnail
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
'`"@`H`__V0``
`





#End
