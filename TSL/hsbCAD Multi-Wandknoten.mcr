#Version 7
#BeginDescription
Version 1.4   07.07.2005   th@hsbCAD.de
   - bugFix
Version 1.3   05.07.2005   schneider_h.@gmx.de
   -keine Fehlermeldung mehr, wenn die Elemente vor dem Einsatz des TSL's nicht berechnet werden
   -richtiges Verschneiden der W‰nde der Hauptecken (egal ob Innen- oder Aussenecke)
   -die Hauptecke, die man erstellt, muss eine geschlossene Ecke sein!
Version 1.2   28.06.2005   schneider_h.@gmx.de
   -Verschneiden der Platten und Balken der Elemente 3 und 4 an dem jeweiligen Element an dem diese anstoﬂen.
Version 1.1   21.06.2005   schneider_h.@gmx.de
   -Schneiden der Platten und Balken der Elemente der Hauptecke bei einer Gehrung
Version 1.0   17.06.2005   schneider_h.@gmx.de
   -verbindet zwei W‰nde zu einer Eckverbindung und weiﬂt den  W‰nden Details zu (Details aus der Bibliothek oder durch Eingabe)

    



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#MajorVersion 0
#MinorVersion 0
#KeyWords 
#BeginContents
// basics and props
	U(1,"mm");
	
	PropString sDet0(1,"",T("Detail Element") + " 1");
	PropString sDet1(2,"",T("Detail Element") + " 2");
	PropString sDet2(3,"",T("Detail Element") + " 3");
	PropString sDet3(4,"",T("Detail Element") + " 4");		
	PropString sDimStyle(0,_DimStyles,T("Dimstyle"));
	PropInt nColor (0,171,T("Color"));

// bOnInsert
	if (_bOnInsert){
//		_Pt0 = getPoint();
  		PrEntity ssE(T("select two elements"), Element());
  		if (ssE.go() && _Element.length()<3) {
			_Element.append(ssE.elementSet());
		}
		_Element.setLength(2);
		
// Es kˆnnen so viele Elemente wie man will gew‰hlt werden; im Prompt wird nach zwei Elementen zur Auswahl gefragt; 
// die gew‰hlten Entities gehˆren zur Gruppe Elemente
// bei ssE.go kˆnnen so lange Elemente ausgew‰hlt werden, bis return gew‰hlt wird; 
// mit _Element.append werden die gew‰hlten Elemente aus dem Set ssE dem Array _Elemente zugeordnet;
// mit _Element.setLength(2); wird der Array auf 2 Elemente begrenzt, falls der Anwender mehr als 2 Elemente ausgew‰hlt hat*/

  		PrEntity ssE1(T("select additional elements (optional)"), Element());
  		if (ssE1.go() ) {
 			_Element.append(ssE1.elementSet());
		}
		//reportNotice (T("\nNumber of chosen elements") + _Element.length() );
		showDialog();
		return;
	}

// Es sollen beliebig viele Elemente gew‰hlt werden kˆnnen; im Prompt wird nach weiteren Elementen gefragt;
// der Rest analog oben
// mit ReportNotice wird das in der Klammer geschriebene ausgegeben
// showDialog ˆffnet eine Dialogbox, die die ganzen PropStrings und PropIntegers und PropDoubles zeigt
// jedes Skript wird zweimal ausgef¸hrt, mit dem return leite ich das erste Wiederholen her, 
// ohne das restliche Skript auszuf¸hren; bei der zweiten Ausf¸hrung des Skripts wird bOnInsert nicht mehr ausgef¸hrt

// restrict color index
	if (nColor > 255 || nColor < -1) nColor.set(171);

// declare standards
	Element el[0];
	el = _Element;
	if (el.length() < 2) 
		return;

	CoordSys cs[0];
	Point3d ptOrg[0];
	Vector3d vx[0],vy[0],vz[0];
	PLine plOL[0];
	
	for(int i = 0; i < el.length(); i++){
		cs.append(el[i].coordSys());
		ptOrg.append(cs[i].ptOrg());
		vx.append(cs[i].vecX());
		vy.append(cs[i].vecY());
		vz.append(cs[i].vecZ());
		vx[i].vis(ptOrg[i],1);
		vy[i].vis(ptOrg[i],3);
		vz[i].vis(ptOrg[i],150);
		plOL.append(el[i].plOutlineWall());			
	}

// jedem Element wird eine Koordinatensystem mit dem Ursprung ptOrg und den Koordinatenachsen x,y,z zugewiesen.
// ptOrg liegt auf der Seite der Wand, auf der das Icon liegt, links unten an der Ecke des Stabes.
// weiterhin werden die Achsen mit vx[i].vis() sichtbar gemacht
// mit plOL.append(el[i].plOutlineWall()); werden die Umrisse der Grundrisse der einzelnen W‰nde dargestellt 

// definieren der Verbindungstypen

// Eckpunkte der Wandumrisslinien
	Point3d pt0[0];
	pt0.append(plOL[0].vertexPoints(TRUE));
	Point3d pt1[0];
	pt1.append(plOL[1].vertexPoints(TRUE));
	
// Punkte von element0 auf den Polylinien von element1	
	Point3d ptCom0[0];
	for(int i = 0; i < pt0.length(); i++){
		if(plOL[1].isOn(pt0[i])) ptCom0.append(pt0[i]);
	}

// Punkte von element1 auf den Polylinien von element0	
	Point3d ptCom1[0];
	for(int i = 0; i < pt1.length(); i++){
		if(plOL[0].isOn(pt1[i])) ptCom1.append(pt1[i]);
	}
// Anzahl der Punkte auf der Polylinie 0
	int nNum0 = ptCom0.length();
	
// Anzahl der Punkte auf der Polylinie 1
	int nNum1 = ptCom1.length();

	int nType;
	
// Festlegen von Typ0(rechtwinklige Ecke)
	if(nNum0 == 1 && nNum1 == 2){ 
		el.swap(0,1);
		vx.swap(0,1);
		vy.swap(0,1);
		vz.swap(0,1);
		ptOrg.swap(0,1);
		plOL.swap(0,1);
		nType = 0;
	}

// Festlegen von Typ0 (rechtwinklige Ecke)	
	if(nNum0 == 2 && vx[0].isPerpendicularTo(vx[1])) 
		nType = 0;
	
// Festlegen von Typ1(rechtwinklige Ecke, verschoben)
	if(nNum0 == 1 && nNum1 == 1 && vx[0].isPerpendicularTo(vx[1])) 
		nType = 1;	

// Festlegen von Typ2(Gehrung)
	if(nNum0 == 2 && nNum1 == 2 &! vx[0].isParallelTo(vx[1])) 
		nType = 2;	

// Festlegen von Typ3(l‰ngs hintereinander)
	if(nNum0 == 2 && nNum1 == 2 && vx[0].isParallelTo(vx[1])) 
		nType = 3;	
	
// Festlegen von Typ4(kein Kontakt)
	if(nNum0 == 0) 
		nType = 4;

// anzeigen der Elementumrisse
	for(int i = 0; i < el.length(); i++)	
		plOL[i].vis(i);	
		
// ermitteln von Schnittpunkt _PtO von Element0 und Element1 durch Schneiden einer Linie und einer Ebene	

// definieren der Linie mit Richtung vx[0] durch ptOrg[0]
	Line ln(ptOrg[0], vx[0]);
	
// definieren der Ebene mit Normalenvektor vz[1] durch ptOrg[1]
	Plane pn(ptOrg[1], vz[1]);
	
// Schnittpunkt ermitteln
	if(nType == 3)
		_Pt0 = ptCom0[0];
	else
		_Pt0 = ln.intersect(pn, U(0));
	
// Mittelpunkt der Umrisse ermitteln ptMid;
// Vektoren ermitteln 
	Point3d ptMid[el.length()];
	Vector3d vxC[el.length()];
	
	for(int i = 0; i < el.length(); i++){	
		ptMid[i].setToAverage(plOL[i].vertexPoints(TRUE));
		ptMid[i].vis(i);
		vxC[i] = vx[i];
		if(vx[i].dotProduct(ptMid[i]-_Pt0) > 0)
			vxC[i] = -vx[i];
		vxC[i].vis(ptMid[i], i);			 
	}

// linke Seite der Elemente definieren
	int bIsLeft[el.length()];
	
	for(int i = 0; i < el.length(); i++){
		if(vx[i].isCodirectionalTo(vxC[i]))
			bIsLeft[i] = FALSE;
		else
			bIsLeft[i] = TRUE;
	}

// in ElementWallSF (StickFrame) umdeklarieren, um Details einf¸gen zu kˆnnen
	ElementWallSF elWallSF[el.length()];
	
	for(int i = 0; i < el.length(); i++){	
		ElementWallSF elWallSF = (ElementWallSF) el[i];
		if (!elWallSF.bIsValid()) 
			return;
	}

	String sCode[el.length()]; 
	String sDetN[el.length()];
	String sDetail[el.length()];
	
// definieren eines int der Aussage dar¸ber trifft, ob bIsLeft von den beiden betrachteten Elementen
// unterschiedlich sind (TRUE) oder nicht (FALSE)
	int bGU[el.length()];

// Position des ptMid von z.B. el1 gesehen auf el0
	int bNY[el.length()];

	if(vz[0].dotProduct(vxC[1]) < 0)
			bNY[0] = TRUE;
		else
			bNY[0] = FALSE;
			
// Art der Eckverbindung f¸r nType0 definieren	
	if(nType == 0){
		if(vz[0].dotProduct(vxC[1]) < 0)
			bNY[0] = TRUE;
		else
			bNY[0] = FALSE;
		if(bIsLeft[0] && !bIsLeft[1])
			bGU[0] = TRUE;
		if(!bIsLeft[0] && bIsLeft[1])
			bGU[0] = TRUE;				 
		if(bIsLeft[0] && bIsLeft[1])
			bGU[0] = FALSE;
		if(!bIsLeft[0] == FALSE && !bIsLeft[1])
			bGU[0] = FALSE;
		if(bNY[0] && bGU[0])
			sDetN[0] = "H1";
		if(!bNY[0] && bGU[0])
			sDetN[0] = "H2";
		if(bNY[0] && !bGU[0])
			sDetN[0] = "H3";
		if(!bNY[0] && !bGU[0])
			sDetN[0] = "H4";
		if (_bOnDebug)
			reportNotice("\n" + T("chosen corner connection: ") + sDetN[0]);
			
// Namen des Details f¸r nType0 auflisten
		if(sDet0 == ""){
			sCode[0] = el[0].code();
			sCode[1] = el[1].code();
			sDetail[0] = sCode[0] + sDetN[0] + "B" + sCode[1];
		}
		else
			sDetail[0] = sDet0;
		if(sDet1 == ""){
			sCode[0] = el[0].code();
			sCode[1] = el[1].code();
			sDetail[1] = sCode[0] + sDetN[0] + "A" + sCode[1];
		}
		else
			sDetail[1] = sDet1;
		//TH
		if (_bOnDebug){
			reportNotice("\n" + T("Detail for female wall: ") + sDetail[0]);
			reportNotice("\n" + T("Detail for male wall: ") + sDetail[1]);	
		}	
	}			

	
			
// Art der Eckverbindung f¸r nType1 definieren			
	if(nType == 1){
		if(sDet0 == ""){
			sCode[0] = el[0].code();
			sDetail[0] = sCode[0] + "O0";
		}
		else
			sDetail[0] = sDet0;
		if(sDet1 == ""){
			sCode[1] = el[1].code();	
			sDetail[1] = sCode[1] + "O0";
		}	
		else	
			sDetail[1] = sDet1;
		//TH
		if (_bOnDebug){
			reportNotice("\n" + T("Detail for female wall: ") + sDetail[0]);
			reportNotice("\n" + T("Detail for male wall: ") + sDetail[1]);	
		}
	}

// Art der Eckverbindung f¸r nType2 definieren
	if(nType == 2){
		if(sDet0 == ""){
			sCode[0] = el[0].code();
			sDetail[0] = sCode[0] + "O0";
		}
		else
			sDetail[0] = sDet0;
		if(sDet1 == ""){
			sCode[1] = el[1].code();	
			sDetail[1] = sCode[1] + "O0";
		}	
		else	
			sDetail[1] = sDet1;
		if (_bOnDebug){
			reportNotice("\n" + T("Detail for female wall: ") + sDetail[0]);
			reportNotice("\n" + T("Detail for male wall: ") + sDetail[1]);
		}	
	}

// Art der Eckverbindung f¸r nType3 definieren
	if(nType == 3){
		Display dpLength(3);
		dpLength.draw(PLine(ptCom0[0], ptCom0[1]));
		if(sDet0 == ""){
			sCode[0] = el[0].code();
			sDetail[0] = sCode[0] + "E1M";
		}
		else
			sDetail[0] = sDet0;
		if(sDet1 == ""){
			sCode[1] = el[1].code();	
			sDetail[1] = sCode[1] + "E1P";
		}	
		else	
			sDetail[1] = sDet1;
		//TH
		if (_bOnDebug){
			reportNotice("\n" + T("Detail for female wall: ") + sDetail[0]);
			reportNotice("\n" + T("Detail for male wall: ") + sDetail[1]);	
		}
	}

// Art der Eckverbindung f¸r nType4 definieren
	if(nType == 4){
		if(sDet0 == ""){
			sCode[0] = el[0].code();
			sDetail[0] = sCode[0] + "O0";
		}
		else
			sDetail[0] = sDet0;
		if(sDet1 == ""){
			sCode[1] = el[1].code();	
			sDetail[1] = sCode[1] + "O0";
		}	
		else	
			sDetail[1] = sDet1;
	//TH
		if(_bOnDebug){
			reportNotice("\n" + T("No contact between main corner"));
			reportNotice("\n" + T("detail for female wall: ") + sDetail[0]);
			reportNotice("\n" + T("detail for male wall: ") + sDetail[1]);
		}
	}
		
	


// collect all genbeams
	//TH
	GenBeam gb0[0], gb1[0];
	gb0 = el[0].genBeam();
	gb1 = el[1].genBeam();

// Vornehmen eines Schnittes durch Platten und Balken, falls bei 
// einer Gehrungsverbindung kein Detail eingegeben wird.
	Vector3d vyC[el.length()];
	if (nType == 2 && sDet0 == ""){	
		Display dpMitre(1);
		dpMitre.draw(PLine(ptCom0[0], ptCom0[1]));
		
		Vector3d vD = (ptCom0[0] - ptCom0[1]);
		if(bNY[0])
			vD = -vD;
		Vector3d vC = vD.crossProduct(vy[0]);
		vC.normalize();
		Vector3d vxC0 = -vxC[0];
		Vector3d vxC1 = -vxC[1];
	
		//TH
		Cut ct0;
		Cut ct1;
		if(bIsLeft[0] == FALSE){
			ct0 = Cut(_Pt0, -vC);
			ct1 = Cut(_Pt0, vC);
		}
		else{
			ct0 = Cut(_Pt0, vC);
			ct1 = Cut(_Pt0, -vC);
		}	
		for (int i = 0; i< gb0.length();i++)
			gb0[i].addTool(ct0);
		for (int i = 0; i< gb1.length();i++)
			gb1[i].addTool(ct1);			
	}


	// definieren der Linie mit Richtung vx[0] durch ptOrg[0]
	Line ln0(ptOrg[0], vx[0]);

	// definieren der Linie mit Richtung vx[1] durch ptOrg[1]
	Line ln1(ptOrg[1], vx[1]);
	
	//Schnittfl‰che definieren (zum Schneiden von el2)
	//und Schnitt anbringen
	Vector3d vzC[el.length()];	
	
		
	if(el.length() > 2){
		// Art der Verbindung der dritten Wand
		
	// definieren der Ebene mit Normalenvektor vz[2] durch ptOrg[2]
	Plane pn2(ptOrg[2], vz[2]);

	// definieren der Ebene mit Normalenvektor vx[2] durch ptOrg[2]
	Plane pn20(ptOrg[2], vx[2]);
	
		if(sDet2 == ""){
			sCode[2] = el[2].code();
			sDetail[2] = sCode[2] + "O0";
		}
		else
			sDetail[2] = sDet2;

		// Feststellen, auf welcher Wand die dritte Wand auftrifft
		Point3d pt2[0];
		pt2.append(plOL[2].vertexPoints(TRUE));
	
		// Punkte von element2 auf den Polylinien von element1	
		Point3d ptCom21[0];
		for(int i = 0; i < pt2.length(); i++)
			if(plOL[1].isOn(pt2[i])) ptCom21.append(pt2[i]);

		// Punkte von element2 auf den Polylinien von element0	
		Point3d ptCom20[0];
		for(int i = 0; i < pt2.length(); i++)
			if(plOL[0].isOn(pt2[i])) ptCom20.append(pt2[i]);
	
		// Anzahl der Punkte von el2 auf pl0
		int nNum20 = ptCom20.length();
	
		// Anzahl der Punkte von el2 auf pl1
		int nNum21 = ptCom21.length();
	
		// Festlegen an welchem Element das jeweilige Detail geschnitten wird
		int nT2;
		if(nNum20 == 1 && nNum21 == 0)
			nT2 = 20;						//el2 mit einem Punkt auf el0 und keinem auf el1
		else if(nNum21 == 1 && nNum20 == 0)
			nT2 = 21;						//el2 mit einem Punkt auf el1 und keinem auf el0
		else if(nNum20 == 2 && nNum21 == 0)
			nT2 = 20;						//el2 mit zwei Punkten auf el0 und keinem auf el1
		else if(nNum21 == 2 && nNum20 == 0)
			nT2 = 21;						//el2 mit zwei Punkten auf el1 und keinem auf el0
		else if(nNum21 == 1 && nNum20 == 2)
			nT2 = 20;						//el2 mit einem Punkt auf el1 und zwei auf el0
		else if(nNum20 == 1 && nNum21 == 2)
			nT2 = 21;						//el2 mit einem Punkt auf el0 und zwei auf el1
		else if(nNum20 == 0 && nNum21 == 0)
			nT2 = 22;						//el2 mit keinem Punkt auf el0 und auf el1

		//Schnittpunkte des Elements2 mit el0 oder el1
		Point3d _Pt20,_Pt21;
		
		// ermitteln von Schnittpunkt _Pt20 von Element2 mit el0 durch Schneiden einer Linie und einer Ebene
		if(vx[0].isParallelTo(vx[2]))
			_Pt20 = ln0.intersect(pn20, U(0));
		else
			_Pt20 = ln0.intersect(pn2, U(0));

		// ermitteln von Schnittpunkt _Pt21 von Element2 mit el1 durch Schneiden einer Linie und einer Ebene
		if(vx[1].isParallelTo(vx[2]))
			_Pt21 = ln1.intersect(pn20, U(0));
		else
			_Pt21 = ln1.intersect(pn2, U(0));


		Vector3d vxC2 = -vxC[2];
		//TH using genbeams compresses code
		GenBeam gb2[0];
		gb2 = el[2].genBeam();
		if(nT2 == 20){
			vzC[0] = vz[0];
			if(vz[0].dotProduct(ptMid[0]-ptCom20[0]) > 0)
				vzC[0] = -vz[0];
			vzC[0].vis(ptMid[0], 2);
			Cut ct20(ptCom20[0], -vzC[0]);
			for(int i = 0; i < gb2.length(); i++)
				gb2[i].addTool(ct20);
		}
		
		if(nT2 == 21){
			vzC[1] = vz[1];
			if(vz[1].dotProduct(ptMid[1]-ptCom21[0]) > 0)
				vzC[1] = -vz[1];
			vzC[1].vis(ptMid[1], 2);
			Cut ct21(ptCom21[0], -vzC[1]);
			for(int i = 0; i < gb2.length(); i++)
				gb2[i].addTool(ct21);
		}
	
		//TH
		//strings to be translated should not contain '\n' but be concatenated by '+' 
		//if they are apear to be too long. multiple occurences should use the same base
		//string since it reduces translation work
		//Notices should be short but descriptive
		//reportNotice(T("\n there is no contact between the \n third wall and the walls of the main corner!"));
	
		//TH
		if(_bOnDebug){
			if(nT2 == 22)
				reportNotice("\n" + T("No contact between main corner and element") + " 3"); 
			if(nT2 == 32){
				reportNotice("\n" + T("No contact between main corner and element") + " 4");
				return;
			}
		}
	}//end 3 elements 333333333333333333333333333333333333333333333333333333333333
	
	
	if(el.length() > 3){
		// Art der Verbindung der vierten Wand
		if(sDet3 == ""){
			sCode[3] = el[3].code();
			sDetail[3] = sCode[3] + "O0";
		}
		else
			sDetail[3] = sDet3;
		//TH
		if(_bOnDebug)
			reportNotice("\n" + T("Detail fourth wall: ") + sDetail[3]);

		// Feststellen, auf welcher Wand die vierte Wand auftrifft
		Point3d pt3[0];
		pt3.append(plOL[3].vertexPoints(TRUE));

		// Punkte von element3 auf den Polylinien von element1	
		Point3d ptCom31[0];
		for(int i = 0; i < pt3.length(); i++)
			if(plOL[1].isOn(pt3[i])) ptCom31.append(pt3[i]);


		// Punkte von element3 auf den Polylinien von element0	
		Point3d ptCom30[0];
		for(int i = 0; i < pt3.length(); i++)
			if(plOL[0].isOn(pt3[i])) ptCom30.append(pt3[i]);

	
		// Anzahl der Punkte von el3 auf pl0
		int nNum30 = ptCom30.length();

		// Anzahl der Punkte von el3 auf pl1
		int nNum31 = ptCom31.length();	

		// Festlegen an welchem Element das jeweilige Detail geschnitten wird
		int nT3;
		if(nNum30 == 1 && nNum31 == 0)
			nT3 = 30;						//el3 mit einem Punkt auf el0 und keinem auf el1
		else if(nNum31 == 1 && nNum30 == 0)
			nT3 = 31;						//el3 mit einem Punkt auf el1 und keinem auf el0
		else if(nNum30 == 2 && nNum31 == 0)
			nT3 = 30;						//el3 mit zwei Punkten auf el0 und keinem auf el1
		else if(nNum31 == 2 && nNum30 == 0)
			nT3 = 31;						//el3 mit zwei Punkten auf el1 und keinem auf el0
		else if(nNum31 == 1 && nNum30 == 2)
			nT3 = 30;						//el3 mit einem Punkt auf el1 und zwei auf el0
		else if(nNum30 == 1 && nNum31 == 2)
			nT3 = 31;						//el3 mit einem Punkt auf el0 und zwei auf el1
		else if(nNum30 == 0 && nNum31 == 0)
			nT3 = 32;						//el3 mit keinem Punkt auf el0 und el1	
	
		// definieren der Ebene mit Normalenvektor vz[3] durch ptOrg[3]
		Plane pn3(ptOrg[3], vz[3]);
	
		// definieren der Ebene mit Normalenvektor vx[3] durch ptOrg[3]
		Plane pn30(ptOrg[3], vx[3]);
	
		Point3d _Pt30,	_Pt31;

		// ermitteln von Schnittpunkt _Pt30 von Element3 mit el0 durch Schneiden einer Linie und einer Ebene
		if(vx[0].isParallelTo(vx[3]))
			_Pt30 = ln0.intersect(pn30, U(0));
		else
			_Pt30 = ln0.intersect(pn3, U(0));
	
		// ermitteln von Schnittpunkt _Pt31 von Element3 mit el1 durch Schneiden einer Linie und einer Ebene
		if(vx[1].isParallelTo(vx[3]))
			_Pt31 = ln1.intersect(pn30, U(0));
		else
			_Pt31 = ln1.intersect(pn3, U(0));
	
		//Schnittfl‰che definieren (zum Schneiden von el3) und Schnitt anbringen
		Vector3d vxC3 = -vxC[3];
		//TH using genbeams compresses code
		GenBeam gb3[0];
		gb3 = el[3].genBeam();
		if(nT3 == 30){
			vzC[0] = vz[0];
			if(vz[0].dotProduct(ptMid[0]-ptCom30[0]) > 0)
				vzC[0] = -vz[0];
			vzC[0].vis(ptMid[0], 3);
			Cut ct30(ptCom30[0], -vzC[0]);
			for(int i = 0; i < gb3.length(); i++)
				gb3[i].addTool(ct30);
		}
		if(nT3 == 31){
			vzC[1] = vz[1];
			if(vz[1].dotProduct(ptMid[1]-ptCom31[0]) > 0)
				vzC[1] = -vz[1];
			vzC[1].vis(ptMid[1], 3);
			Cut ct31(ptCom31[0], -vzC[1]);
			for(int i = 0; i < gb3.length(); i++)
				gb3[i].addTool(ct31);
		}
		
		if(nT3 == 32)
			//TH	
		reportNotice("\n" + T("No contact between the fourth wall and main corner found!"));
	}// end 4 4444444444444444444444444444444444444
	

	
	// Einf¸gen der Details f¸r alle Elemente 
	for (int i = 0; i < el.length(); i++){
		ElementWallSF elWallSF = (ElementWallSF) el[i];
		if (!elWallSF.bIsValid()) 
			return;
		if(bIsLeft[i])
			elWallSF.setConstrDetailLeft(sDetail[i]);
		if(!bIsLeft[i])
			elWallSF.setConstrDetailRight(sDetail[i]);
	}
	

//	eraseInstance();



#End
#BeginThumbnail



#End
