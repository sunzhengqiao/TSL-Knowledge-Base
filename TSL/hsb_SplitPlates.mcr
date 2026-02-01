#Version 8
#BeginDescription
This tsl places splits the headbinder, the top- and the bottomplate.

Splitted beams are labelled from left to right A, B, .. F...

		--------------------------------------------------------------------------------
			Version: 	1.10
			Date: 	14.12.2017 
			Author: 	mihai.bercuci@hsbcad.com
		--------------------------------------------------------------------------------




















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 10
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------
*  Copyright (C) 2007 by
*  hsbSOFT N.V.
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT N.V., or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
*
* REVISION HISTORY
* ----------------
*
* Revised: Anno Sportel 050415 (v1.0)
* Change: First revision
*
* Revised: Anno Sportel 070316 (v1.1)
* Change: label splitted beams
*			Make a diffrence between small modules and big ones.
*
* Revised: Anno Sportel 070327 (v1.2)
* Change: Join platess first
*
* Revised: Alberto Jena 070820 (v1.3)
* Change: Dont join very top plate
*			Label from right to left
*
* Revised: Alberto Jena 070823 (v1.4)
* Change: very top plate is split when it have
*			a stud bellow
*
* Revised: Alberto Jena 100831 (v1.5)
* Change: split the plates after they are name.
*
* Revised: Alberto Jena 101109 (v1.6)
* Change: Add the option to create Splice Blocks
*
* Revised: Alberto Jena 110128 (v1.7)
* Change: Exclude the beams with beam code H
*
* Revised: Alberto Jena 110923 (v1.8)
* Change: Allow the TSL to run from the details
*
* Revised: Mihai Bercuci 07.11.2017 (v1.9)
* Change: Fix the defect when the TSL was removing one beam
*/

Unit (1,"mm");
double dEps = U(0.1);


//---------------------------------------------------------------------------------------------------------------------
//                                                                     Properties

String sArYesNo[] = {T("No"), T("Yes")};

PropDouble dMaxLength(0, U(4800), T("Maximum length"));

PropDouble dSizeOpeningModule(1, U(605), T("Opening module dimensions greater than"));
PropDouble dDistOpeningModule(2, U(269), T("Split distance to opening mudule"));
PropDouble dDistSmallModule(3, U(119), T("Split distance to small mudule"));
PropDouble dDistStud(4, U(119), T("Split distance to stud"));

String arSYesNo[] = {T("Yes"),T("No")};
int arNYesNo[] = {_kYes, _kNo};
PropString sResetSplittedStatus(0,arSYesNo,T("Reset 'wall splitted' status"),1);


PropString sSpliceBlocks (2, sArYesNo,T("Create splice blocks"),0);
sSpliceBlocks.setDescription("Will Create Splice blocks in the location of the splits");


//---------------------------------------------------------------------------------------------------------------------
//                                                                       Insert

_ThisInst.setSequenceNumber(110);

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

int bResetSplittedStatus = arNYesNo[arSYesNo.find(sResetSplittedStatus,1)];
int nSpliceBlocks = sArYesNo.find(sSpliceBlocks, 0);

if( _bOnInsert ){

	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}

	if (_kExecuteKey=="")
		showDialogOnce();
	
	PrEntity ssE(T("Select a set of elements"), Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	return;
}

if( _Element.length() == 0 ){
	eraseInstance();
	return;
}


//---------------------------------------------------------------------------------------------------------------------
//                                              Define usefull set of vectors and array's, ...
Opening arOp[0];
for( int e=0;e<_Element.length();e++ ){
	Element el = _Element[e];
	arOp.append(el.opening());
}

//Check opening sizes.
double dMinimumSplitLength;
for( int i=0;i<arOp.length();i++ ){
	double dWidth = arOp[i].width();
	if( (dWidth - dMinimumSplitLength) > dEps ){
		dMinimumSplitLength = dWidth;
	}
}

if( ((dMinimumSplitLength + 2 * (dDistOpeningModule + dDistStud)) - dMaxLength) > dEps ){
	String sLMax;
	String sLOp;
	sLMax.formatUnit(dMinimumSplitLength + 2 * (dDistOpeningModule + dDistStud), 2, 0);
	sLOp.formatUnit(dMinimumSplitLength,2,0);
	reportWarning(T("Increase maximum split length to ")+sLMax+T("mm.\nLargest opening is ")+ sLOp);
	eraseInstance();
	return;
}

String sSplit = ("Plates are split");
String sBeamLabels[]={"A", "B", "C", "D", "E", "F", "G", "H"}; 

if( bResetSplittedStatus ){
	for( int e=0;e<_Element.length();e++ ){
		Element el = _Element[e];
		ElemText arElTxt[] = el.elemTexts();
		ElemText arElTxtNew[0];
		for( int i=0;i<arElTxt.length();i++ ){
			if( arElTxt[i].text() != sSplit ){
				arElTxtNew.append(arElTxt[i]);
			}
		}
		el.setElemTexts(arElTxtNew);
	}
	reportMessage(T("\nSplitted status is reset!"));
	eraseInstance();
	return;
}

int nErase=false;

for( int e=0;e<_Element.length();e++ )
{
	Element el = _Element[e];
	int bElIsSplit = FALSE;
	ElemText arElTxt[] = el.elemTexts();
	for( int i=0;i<arElTxt.length();i++ ){
		if( arElTxt[i].text() == sSplit ){
			bElIsSplit = TRUE;
			break;
		}
	}
	if( bElIsSplit ){
		reportMessage(T("\nWall ")+el.code()+el.number()+T(" is already split"));
		//continue; AJ
	}
	
	Vector3d vx = el.vecX();
	Vector3d vy = el.vecY();
	Vector3d vz = el.vecZ();

	_Pt0 = el.ptOrg();

	Beam arBm[] = el.beam();
	if( arBm.length() == 0 )return;
	
	Beam bmVer[]=vx.filterBeamsPerpendicularSort(arBm);

	//---------------------------------------------------------------------------------------------------------------------
	//                                                           Find beams to split

	int arNBmTypeToSplitTop[] = {
		_kSFTopPlate,
		_kSFVeryTopPlate
	};
	int arNBmTypeToSplitBottom[] = {
		_kSFBottomPlate,
		_kSFVeryBottomPlate

	};
	Beam bmVTP;//Very top plate
	Beam bmTP;//Top plate
	Beam bmBP;//Bottom plate
	Beam bmVBP;//very Bottom plate

	Beam arBmTop[0];
	
	Beam arBmVTP[0];
	Beam arBmTP[0];
	Beam arBmBP[0];
	Beam arBmVBP[0];
	
	Beam arBmBT[0];
	
	for( int i=0;i<arBm.length();i++ ){
		Beam bm = arBm[i];
//		if( (dMaxLength - bm.solidLength()) > dEps )continue;
		
		if( arNBmTypeToSplitTop.find(bm.type()) != -1 )
		{
			if (bm.beamCode().token(0)!="H")
			{
				arBmTop.append(bm);
			}
		}
			
		if( arNBmTypeToSplitBottom.find(bm.type()) != -1 ){
			arBmBT.append(bm);
		}
	}
	
	if( arBmTop.length() > 0 ){
		arBmTop = vy.filterBeamsPerpendicularSort(arBmTop);
		Beam bmTop = arBmTop[0];
		arBmTP.append(bmTop);
		for( int i=1;i<arBmTop.length();i++ ){
			Beam bm = arBmTop[i];
			if( vy.dotProduct(bm.ptCen() - bmTop.ptCen()) > U(1) ){
				arBmVTP.append(bm);
			}
			else{
				arBmTP.append(bm);
			}
		}
//		if( arBmBP.length() > 1 ){
//			arBmVBP.append(arBmBP[0]);
//			bmVBP = arBmVBP[0];
//		}
	}

		if( arBmBT.length() > 0 ){
			arBmBT = vy.filterBeamsPerpendicularSort(arBmBT);
			Beam bmBottom= arBmBT[0];
			arBmVBP.append(bmBottom);
			for( int i=1;i<arBmBT.length();i++ ){
				Beam bm = arBmBT[i];
				if( vy.dotProduct(bm.ptCen() - bmBottom.ptCen()) > U(1) ){
					arBmBP.append(bm);
				}
				else{
					arBmVBP.append(bm);
				}
			}
	}
	
	//Sort beams in Plate arrays from right to left  //AJ
	Beam bmSort;
	for(int s1=1;s1<arBmBP.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--){
			int bSort = vx.dotProduct(arBmBP[s2].ptCen() - arBmBP[s11].ptCen()) < dEps;
			if( bSort ){
				bmSort = arBmBP[s2];		arBmBP[s2] = arBmBP[s11];		arBmBP[s11] = bmSort;
	
				s11=s2;
			}
		}
	}

	for(int s1=1;s1<arBmTP.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--){
			int bSort = vx.dotProduct(arBmTP[s2].ptCen() - arBmTP[s11].ptCen()) < dEps;
			if( bSort ){
				bmSort = arBmTP[s2];		arBmTP[s2] = arBmTP[s11];		arBmTP[s11] = bmSort;
	
				s11=s2;
			}
		}
	}

	for(int s1=1;s1<arBmVTP.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--){
			int bSort = vx.dotProduct(arBmVTP[s2].ptCen() - arBmVTP[s11].ptCen()) < dEps;
			if( bSort ){
				bmSort = arBmVTP[s2];		arBmVTP[s2] = arBmVTP[s11];		arBmVTP[s11] = bmSort;
	
				s11=s2;
			}
		}
	}
	
		for(int s1=1;s1<arBmVBP.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--){
			int bSort = vx.dotProduct(arBmVBP[s2].ptCen() - arBmVBP[s11].ptCen()) < dEps;
			if( bSort ){
				bmSort = arBmVBP[s2];		arBmVBP[s2] = arBmVBP[s11];		arBmVBP[s11] = bmSort;
	
				s11=s2;
			}
		}
	}

	
	//Join plates
		 if( arBmBP.length() > 0 ){
		 	bmBP = arBmBP[0];
		 }
		 
		 if( arBmTP.length() > 0 ){
		 	bmTP = arBmTP[0];
		 }
		 if( arBmVTP.length() > 0 ){
			bmVTP = arBmVTP[0];
		 }
			 
		if ( arBmVBP.length() > 0 ) {
			bmVBP = arBmVBP[0];
		}

		for( int i=1;i<arBmBP.length();i++ ){
			bmBP.dbJoin(arBmBP[i]);
		}
		
		 for( int i=1;i<arBmTP.length();i++ ){
		 	bmTP.dbJoin(arBmTP[i]);
		 }
	
		for( int i=1;i<arBmVTP.length();i++ ){
			bmVTP.dbJoin(arBmVTP[i]);
		}
		
		for( int i=1;i<arBmVBP.length();i++ ){
			bmVBP.dbJoin(arBmVBP[i]);
		}
	
	//---------------------------------------------------------------------------------------------------------------------
	//                          Find start and end of modules and fill an array with studs

	Beam arBmModule[0];
	int arNModuleIndex[0];
	String arSModule[0];
	
	Beam arBmStud[0];
	for( int i=0;i<arBm.length();i++ ){
		Beam bm = arBm[i];
		
		String sModule = bm.name("module");
		if( bm.type() == _kStud ){
			arBmStud.append(bm);
		}
		if( sModule != "" ){
			arBmModule.append(bm);
			
			if( arSModule.find(sModule) == -1 ){
				arSModule.append(sModule);
			}
			
			arNModuleIndex.append( arSModule.find(sModule) );
		}
	}
	
	double arDMinModule[arSModule.length()];
	double arDMaxModule[arSModule.length()];
	int arBMinMaxSet[arSModule.length()];
	for( int i=0;i<arBMinMaxSet.length();i++ ){
		arBMinMaxSet[i] = FALSE;
	}
	for( int i=0;i<arBmModule.length();i++ ){
		Beam bm = arBmModule[i];
		int nIndex = arNModuleIndex[i];
	
		Point3d arPtBm[] = bm.realBody().allVertices();
		Plane pn(el.ptOrg() , vy);
		arPtBm = pn.projectPoints(arPtBm);
	
		for( int i=0;i<arPtBm.length();i++ ){
			Point3d pt = arPtBm[i];
			double dDist = vx.dotProduct( pt - el.ptOrg() );
			
			if( !arBMinMaxSet[nIndex] ){
				arBMinMaxSet[nIndex] = TRUE;
				arDMinModule[nIndex] = dDist;
				arDMaxModule[nIndex] = dDist;			
			}
			else{
				if( (arDMinModule[nIndex] - dDist) > dEps ){
					arDMinModule[nIndex] = dDist;
				}
				if( (dDist - arDMaxModule[nIndex]) > dEps ){
					arDMaxModule[nIndex] = dDist;
				}
			}
		}
	}
	Point3d arPtMinModule[0];
	Point3d arPtMaxModule[0];
	for( int i=0;i<arSModule.length();i++ ){
		if( (arDMaxModule[i] - arDMinModule[i]) > dSizeOpeningModule ){
			arPtMinModule.append(el.ptOrg() + vx * (arDMinModule[i] - dDistOpeningModule));
			arPtMaxModule.append(el.ptOrg() + vx * (arDMaxModule[i] + dDistOpeningModule));
		}
		else{
			arPtMinModule.append(el.ptOrg() + vx * (arDMinModule[i] - dDistSmallModule));
			arPtMaxModule.append(el.ptOrg() + vx * (arDMaxModule[i] + dDistSmallModule));
		}
	}

	for( int i=0;i<arPtMinModule.length(); i++ ){
		arPtMinModule[i].vis(i);
		arPtMaxModule[i].vis(i);
	}


	//---------------------------------------------------------------------------------------------------------------------
	//                                                      Find start and end of studs
	
	Point3d arPtMinStud[0];
	Point3d arPtMaxStud[0];
	for( int i=0;i<arBmStud.length();i++ ){
		Beam bm = arBmStud[i];
	
		arPtMinStud.append( bm.ptCen() - vx * dDistStud );
		arPtMaxStud.append( bm.ptCen() + vx * dDistStud );
	}


	//---------------------------------------------------------------------------------------------------------------------
	//                 Combine array's with min and max points and sort them from left to right

	Point3d arPtMin[0];
	Point3d arPtMax[0];
	arPtMin.append(arPtMinModule);
	arPtMin.append(arPtMinStud);
	arPtMax.append(arPtMaxModule);
	arPtMax.append(arPtMaxStud);

	Point3d ptSort;
	for(int s1=1;s1<arPtMin.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--){
			if( vx.dotProduct( arPtMin[s11] - el.ptOrg() ) < vx.dotProduct( arPtMin[s2] - el.ptOrg() ) ){
				ptSort = arPtMin[s2];			arPtMin[s2] = arPtMin[s11];				arPtMin[s11] = ptSort;
				ptSort = arPtMax[s2];		arPtMax[s2] = arPtMax[s11];		arPtMax[s11] = ptSort;

				s11=s2;
			}
		}
	}


	//---------------------------------------------------------------------------------------------------------------------
	//                                                Find split locations bottomplate

	Point3d arPtSplitBP[0];
	if( bmBP.bIsValid() ){
		double dLBP = bmBP.solidLength();
		Point3d ptMinBP = bmBP.ptRef() + bmBP.vecX() * bmBP.dLMin();
		Point3d ptMaxBP = bmBP.ptRef() + bmBP.vecX() * bmBP.dLMax();

		if (vx.dotProduct(bmBP.vecX())<0){
			Point3d ptAux=ptMinBP;			ptMinBP=ptMaxBP;			ptMaxBP=ptAux;}

		ptMinBP.vis(2);
		ptMaxBP.vis(3);
		Point3d ptSplitBP = ptMinBP + vx * dMaxLength;
		
		while( vx.dotProduct(ptMaxBP - ptSplitBP) > 0 ){
			for( int i=(arPtMin.length()-1);i>0;i-- ){
				double dDist = vx.dotProduct(arPtMin[i] - ptSplitBP);
				if( dDist < 0 ){
					if( vx.dotProduct(arPtMax[i] - ptSplitBP) > 0 ){
						ptSplitBP = ptSplitBP + vx * dDist;
					}
				}
			}
			ptSplitBP.vis(4);
			arPtSplitBP.append(ptSplitBP);
			if( arPtSplitBP.length() > 1){
				if( abs(Vector3d(arPtSplitBP[arPtSplitBP.length() - 2] - ptSplitBP).length()) < dEps ){
					reportWarning("Increase maximum split length! (BP)");
					eraseInstance();
					return;
				}
			}
			ptSplitBP.vis(210);
			ptSplitBP = ptSplitBP + vx * dMaxLength;
		}
	}

	
	//---------------------------------------------------------------------------------------------------------------------
	//                  Add split locations of BP to array's ptMin & ptMax and sort those array's
	
//	for( int i=0;i<arPtSplitBP.length();i++ ){
//		for( int j=0;j<arPtMin.length();j++ ){
//			double dDist = vx.dotProduct(arPtSplitBP[i] - arPtMin[j]);
//			if( dDist < 0 || abs(dDist) < dEps){
//				arPtMax.append(arPtMin[j] + vx* U(1));
//				if( j==0 ){
//					arPtMin.append(el.ptOrg() + vx* U(1));
//				}
//				else{
//					arPtMin.append(arPtMax[j-1] - vx* U(1));
//				}
//				
//				break;
//			}
//		}
//	}

	for(int s1=1;s1<arPtMin.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--){
			if( vx.dotProduct( arPtMin[s11] - el.ptOrg() ) < vx.dotProduct( arPtMin[s2] - el.ptOrg() ) ){
				ptSort = arPtMin[s2];			arPtMin[s2] = arPtMin[s11];		arPtMin[s11] = ptSort;
				ptSort = arPtMax[s2];		arPtMax[s2] = arPtMax[s11];		arPtMax[s11] = ptSort;

				s11=s2;
			}
		}
	}
	
		//---------------------------------------------------------------------------------------------------------------------
	//                                                 Find split locations very bottomplate
	Beam arBmSplittedVBP[0];
	arBmStud = vx.filterBeamsPerpendicularSort(arBmStud);
	
	//veryTop vs Vertical Beam T Connection  
	for(int v=0;v<arBmVBP.length();v++)
	{	
		Point3d ptVTCut[0];    //split points in the VTop p beam selected
		Point3d ptIntersectVeryBottom[0];  // intersection points with vertical beams

		//X direction beam selected
		Vector3d BmvecX=arBmVBP[v].vecX();
		if(BmvecX.dotProduct(vx)<0)
		{
			BmvecX=-BmvecX;
		}
		double dVtopL=arBmVBP[v].dL();       //very top length
		Point3d ptBmVtOrg=arBmVBP[v].ptCen()-BmvecX*dVtopL*.5;
		ptBmVtOrg.vis(3);		
		Line lnVT(arBmVBP[v].ptCen(),arBmVBP[v].vecX());  //very top central line
				
		for(int p=0;p<arBmStud.length();p++)
		{
			if(arBmStud[p].hasTConnection(arBmVBP[v],U(40),1)==1)
			{
				Line lnPerpAux(arBmStud[p].ptCen(),arBmStud[p].vecX()); // central line  Vertical beam
				ptIntersectVeryBottom.append(lnVT.closestPointTo(lnPerpAux));  // intersection point Very top  vs  Vertical beam
			}																         // append array points intersection
		}
		
		for (int h=0;h<ptIntersectVeryBottom.length();h++)
		{
			ptIntersectVeryBottom[h].vis(h);      //visualize the  intesection  points with vertical beams
		}
		
		Point3d ptOrAux=ptBmVtOrg;  //the 
		for(int pv=0;pv<ptIntersectVeryBottom.length();pv++)
		{
			if(  (ptIntersectVeryBottom[pv]-ptOrAux).length()<dMaxLength)  // finding the intersection point with the vertical beams that
			{															// will be the closer at the max length in the OPM
					continue;
			}
			else
			{
				ptVTCut.append(ptIntersectVeryBottom[pv-1]);  //obtain the closest at the left side
				ptOrAux=ptIntersectVeryBottom[pv-1];              //this will be the next ptOrg for the new beam
				ptIntersectVeryBottom.removeAt(pv-1);
				ptOrAux.vis(0);
			}
		}
		/////SPLITING BEAM
		if(ptVTCut.length()>0)
		{
			Beam bmRes=arBmVBP[v];
			arBmSplittedVBP.append(bmRes);
			for(int nSV=0;nSV<ptVTCut.length();nSV++)  // points will be the origin and end point
			{
				
				Beam bmSpVt=bmRes.dbSplit(ptVTCut[nSV],ptVTCut[nSV]);
				bmRes=bmSpVt;
				arBmSplittedVBP.append(bmRes);
			      bmRes.assignToElementGroup(el,TRUE,0,'E');
				nErase=true;
			}
		}
	}
	
	Point3d arPtSplitVBP[0];

	
	//---------------------------------------------------------------------------------------------------------------------
	//                                                      Find split locations topplate

	Point3d arPtSplitTP[0];
	
	if( bmTP.bIsValid() ){
		double dLTP = bmTP.solidLength();
		Point3d ptMinTP = bmTP.ptRef() + bmTP.vecX() * bmTP.dLMin();
		Point3d ptMaxTP = bmTP.ptRef() + bmTP.vecX() * bmTP.dLMax();

		if (vx.dotProduct(bmTP.vecX())<0){
			Point3d ptAux=ptMinTP;			ptMinTP=ptMaxTP;			ptMaxTP=ptAux;}
	
		Point3d ptSplitTP = ptMinTP + vx * dMaxLength;
		while( vx.dotProduct(ptMaxTP - ptSplitTP) > 0 ){
			for( int i=(arPtMin.length()-1);i>0;i-- ){
				double dDist = vx.dotProduct(arPtMin[i] - ptSplitTP);
				if( dDist < 0 ){
					double dDistMax = vx.dotProduct(arPtMax[i] - ptSplitTP);
					if( vx.dotProduct(arPtMax[i] - ptSplitTP) > 0 ){
						ptSplitTP = ptSplitTP + vx * dDist;
					}
				}
			}
			arPtSplitTP.append(ptSplitTP);
			if( arPtSplitTP.length() > 1){
				if( abs(Vector3d(arPtSplitTP[arPtSplitTP.length() - 2] - ptSplitTP).length()) < dEps ){
					reportWarning("Increase maximum split length! (TP)");
					//eraseInstance();
					return;
				}
			}
			ptSplitTP.vis(130);
			ptSplitTP = ptSplitTP + vx * dMaxLength;
		}
	}

	//---------------------------------------------------------------------------------------------------------------------
	//                                                 Find split locations very topplate
	Beam arBmSplittedVTP[0];
	arBmStud = vx.filterBeamsPerpendicularSort(arBmStud);
	
	//veryTop vs Vertical Beam T Connection  
	for(int v=0;v<arBmVTP.length();v++)
	{	
		Point3d ptVTCut[0];    //split points in the VTop p beam selected
		Point3d ptIntersectVeryTop[0];  // intersection points with vertical beams

		//X direction beam selected
		Vector3d BmvecX=arBmVTP[v].vecX();
		if(BmvecX.dotProduct(vx)<0)
		{
			BmvecX=-BmvecX;
		}
		double dVtopL=arBmVTP[v].dL();       //very top length
		Point3d ptBmVtOrg=arBmVTP[v].ptCen()-BmvecX*dVtopL*.5;
		ptBmVtOrg.vis(3);		
		Line lnVT(arBmVTP[v].ptCen(),arBmVTP[v].vecX());  //very top central line
				
		for(int p=0;p<arBmStud.length();p++)
		{
			if(arBmStud[p].hasTConnection(arBmVTP[v],U(40),1)==1)
			{
				Line lnPerpAux(arBmStud[p].ptCen(),arBmStud[p].vecX()); // central line  Vertical beam
				ptIntersectVeryTop.append(lnVT.closestPointTo(lnPerpAux));  // intersection point Very top  vs  Vertical beam
			}																         // append array points intersection
		}
		
		for (int h=0;h<ptIntersectVeryTop.length();h++)
		{
			ptIntersectVeryTop[h].vis(h);      //visualize the  intesection  points with vertical beams
		}
		
		Point3d ptOrAux=ptBmVtOrg;  //the 
		for(int pv=0;pv<ptIntersectVeryTop.length();pv++)
		{
			if(  (ptIntersectVeryTop[pv]-ptOrAux).length()<dMaxLength)  // finding the intersection point with the vertical beams that
			{															// will be the closer at the max length in the OPM
					continue;
			}
			else
			{
				ptVTCut.append(ptIntersectVeryTop[pv-1]);  //obtain the closest at the left side
				ptOrAux=ptIntersectVeryTop[pv-1];              //this will be the next ptOrg for the new beam
				ptIntersectVeryTop.removeAt(pv-1);
				ptOrAux.vis(0);
			}
		}
		/////SPLITING BEAM
		if(ptVTCut.length()>0)
		{
			Beam bmRes=arBmVTP[v];
			arBmSplittedVTP.append(bmRes);
			for(int nSV=0;nSV<ptVTCut.length();nSV++)  // points will be the origin and end point
			{
				
				Beam bmSpVt=bmRes.dbSplit(ptVTCut[nSV],ptVTCut[nSV]);
				bmRes=bmSpVt;
				arBmSplittedVTP.append(bmRes);
			      bmRes.assignToElementGroup(el,TRUE,0,'E');
				nErase=true;
			}
		}
	}
	
	Point3d arPtSplitVTP[0];
	
	/*
	if( bmVTP.bIsValid() ){
		double dLVTP = bmVTP.solidLength();
		Point3d ptMinVTP = bmVTP.ptRef() + bmVTP.vecX() * bmVTP.dLMin();
		Point3d ptMaxVTP = bmVTP.ptRef() + bmVTP.vecX() * bmVTP.dLMax();

		if (vx.dotProduct(bmVTP.vecX())<0){
			Point3d ptAux=ptMinVTP;			ptMinVTP=ptMaxVTP;			ptMaxVTP=ptAux;}


		Point3d ptSplitVTP = ptMinVTP + vx * dMaxLength;
		while( vx.dotProduct(ptMaxVTP - ptSplitVTP) > 0 ){
			for( int i=arBmStud.length()-1;i>0;i-- ){
				Beam bm = arBmStud[i];
		
				double dDist = vx.dotProduct(bm.ptCen() - ptSplitVTP);
				if( dDist < 0 ){
					ptSplitVTP = ptSplitVTP + vx * dDist;
					break;
				}
			}
			arPtSplitVTP.append(ptSplitVTP);
			if( arPtSplitVTP.length() > 1){
				if( abs(Vector3d(arPtSplitVTP[arPtSplitVTP.length() - 2] - ptSplitVTP).length()) < dEps ){
					reportWarning("Increase maximum split length! (VTP)");
					eraseInstance();
					return;
				}
			}
			ptSplitVTP.vis(50);
			ptSplitVTP = ptSplitVTP + vx * dMaxLength;
		}
	}*/	
	
	//---------------------------------------------------------------------------------------------------------------------
	//                                                               Create splits

	int bSplit = FALSE;
	int nSplitIndex = 1;
	//Bottomplate
	Beam arBmSplittedBP[0];
	if( bmBP.bIsValid() ){
		arBmSplittedBP.append(bmBP);
		for( int i=0;i<arPtSplitBP.length();i++ ){
			Point3d pt = arPtSplitBP[i];
			bmBP = bmBP.dbSplit(pt, pt);
			nErase=true;

			arBmSplittedBP.append(bmBP);
			
			if (nSpliceBlocks)
			{
				Line ln(bmBP.ptCen(), bmBP.vecX());
				Point3d ptCreateBm=ln.closestPointTo(pt);
				double dBmWidth=bmBP.dD(vy);
				double dBmHeight=bmBP.dD(vz);
				ptCreateBm.transformBy(vy*dBmWidth);
				Beam bmSplice;
				bmSplice.dbCreate(ptCreateBm, bmBP.vecX(), bmBP.vecY(), bmBP.vecZ(), U(50, 4), bmBP.dW(), bmBP.dH(), 0, 0, 0);
				bmSplice.setColor(bmBP.color());
				bmSplice.setMaterial(bmBP.material());
				bmSplice.setGrade(bmBP.grade());
				bmSplice.setName("SPLICE BLOCK");
				bmSplice.setType(_kBlocking);
				bmSplice.assignToElementGroup(el, true, 0, 'E');
				
				
				Beam bmAux[0];
				bmAux=Beam().filterBeamsHalfLineIntersectSort(bmVer, ptCreateBm, bmBP.vecX());
				if (bmAux.length()>0)
					bmSplice.stretchStaticTo(bmAux[0], TRUE);
					
				bmAux.setLength(0);
				bmAux=Beam().filterBeamsHalfLineIntersectSort(bmVer, ptCreateBm, -bmBP.vecX());
				if (bmAux.length()>0)
					bmSplice.stretchStaticTo(bmAux[0], TRUE);
			}
			
			bSplit = TRUE;
		}
	}

	//sort beams
	for(int s1=1;s1<arBmSplittedBP.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--){
			int bSort = vx.dotProduct(arBmSplittedBP[s11].ptCen() - arBmSplittedBP[s2].ptCen()) < 0;
			if( bSort ){
				bmSort = arBmSplittedBP[s2];		arBmSplittedBP[s2] = arBmSplittedBP[s11];			arBmSplittedBP[s11] = bmSort;
				
				s11=s2;
			}
		}
	}
	
	//Label beams
	for( int i=0;i<arBmSplittedBP.length();i++ ){
		Beam bm = arBmSplittedBP[i];
		bm.setLabel(sBeamLabels[i]);
	}

	
	//Topplate
	Beam arBmSplittedTP[0];
	if( bmTP.bIsValid() ){
		arBmSplittedTP.append(bmTP);
		for( int i=0;i<arPtSplitTP.length();i++ ){
			Point3d pt = arPtSplitTP[i];
			bmTP = bmTP.dbSplit(pt, pt);
			nErase=true;
			
			arBmSplittedTP.append(bmTP);
			
			if (nSpliceBlocks)
			{
				Line ln(bmTP.ptCen(), bmTP.vecX());
				Point3d ptCreateBm=ln.closestPointTo(pt);
				double dBmWidth=bmTP.dD(vy);
				double dBmHeight=bmTP.dD(vz);
				ptCreateBm.transformBy(-vy*dBmWidth);
				Beam bmSplice;
				bmSplice.dbCreate(ptCreateBm, bmTP.vecX(), bmTP.vecY(), bmTP.vecZ(), U(50, 4), bmTP.dW(), bmTP.dH(), 0, 0, 0);
				bmSplice.setColor(bmTP.color());
				bmSplice.setMaterial(bmTP.material());
				bmSplice.setGrade(bmTP.grade());
				bmSplice.setName("SPLICE BLOCK");
				bmSplice.setType(_kBlocking);
				bmSplice.assignToElementGroup(el, true, 0, 'E');
				
				
				Beam bmAux[0];
				bmAux=Beam().filterBeamsHalfLineIntersectSort(bmVer, ptCreateBm, bmTP.vecX());
				if (bmAux.length()>0)
					bmSplice.stretchStaticTo(bmAux[0], TRUE);
					
				bmAux.setLength(0);
				bmAux=Beam().filterBeamsHalfLineIntersectSort(bmVer, ptCreateBm, -bmTP.vecX());
				if (bmAux.length()>0)
					bmSplice.stretchStaticTo(bmAux[0], TRUE);
			}

			
			bSplit = TRUE;
		}
	}
	
	//sort beams
	for(int s1=1;s1<arBmSplittedTP.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--){
			int bSort = vx.dotProduct(arBmSplittedTP[s11].ptCen() - arBmSplittedTP[s2].ptCen()) < 0;
			if( bSort ){
				bmSort = arBmSplittedTP[s2];		arBmSplittedTP[s2] = arBmSplittedTP[s11];			arBmSplittedTP[s11] = bmSort;
				
				s11=s2;
			}
		}
	}


	//Label beams
	for( int i=0;i<arBmSplittedTP.length();i++ ){
		Beam bm = arBmSplittedTP[i];
		bm.setLabel(sBeamLabels[i]);
	}


	//Very topplate
	/* AJ
	Beam arBmSplittedVTP[0];
	if( bmVTP.bIsValid() ){
		for( int i=0;i<arPtSplitVTP.length();i++ ){
			Point3d pt = arPtSplitVTP[i];
			bmVTP = bmVTP.dbSplit(pt, pt);
			bSplit = TRUE;
		}
	}*/
	
     //Very bottompalte

	//Beam arBmSplittedVBP[0];
	//if( bmVBP.bIsValid() ){
	//	for( int i=0;i<arPtSplitVBP.length();i++ ){
	//		Point3d pt = arPtSplitVBP[i];
	//		bmVBP = bmVBP.dbSplit(pt, pt);
	//		bSplit = TRUE;
	//	}
	//}

	//sort beams
	for(int s1=1;s1<arBmSplittedVTP.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--){
			int bSort = vx.dotProduct(arBmSplittedVTP[s11].ptCen() - arBmSplittedVTP[s2].ptCen()) < 0;
			if( bSort ){
				bmSort = arBmSplittedVTP[s2];		arBmSplittedVTP[s2] = arBmSplittedVTP[s11];			arBmSplittedVTP[s11] = bmSort;
				
				s11=s2;
			}
		}
	}
	
	//Label beams
	for( int i=0;i<arBmSplittedVTP.length();i++ ){
		Beam bm = arBmSplittedVTP[i];
		bm.setLabel(sBeamLabels[i]);
	}

	//---------------------------------------------------------------------------------------------------------------------
	//                                                            Debug information
	
	if( _bOnDebug ){
		Display dpDebug(-1);
		for( int i=0;i<arBm.length();i++ ){
			Beam bm = arBm[i];
			dpDebug.color(bm.color());
			dpDebug.draw(bm.realBody());
		}
	}
	
	if( bSplit )
	{
		ElemText arElTxt[] = el.elemTexts();
		ElemText elTxt(el.ptOrg(), el.vecX(), sSplit);
		arElTxt.append(elTxt);
		el.setElemTexts(arElTxt);
		reportMessage(T("\nPlates are split!")); 
	}
}

//---------------------------------------------------------------------------------------------------------------------
//                                                       Erase tsl. Beams are split.

if (_bOnElementConstructed || nErase)
{
	eraseInstance();
	return;
}
#End
#BeginThumbnail























#End