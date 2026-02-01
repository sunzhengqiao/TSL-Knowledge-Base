#Version 8
#BeginDescription
Sets connection on 3 walls T configuration
v1.4: 22.mar.2013: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/*
  COPYRIGHT
  ---------------
  Copyright (C) 2011 by
  hsbSOFT 

  The program may be used and/or copied only with the written
  permission from hsbSOFT, or in accordance with
  the terms and conditions stipulated in the agreement/contract
  under which the program has been supplied.

  All rights reserved.

 REVISION HISTORY
 -------------------------
 v1.4: 22.mar.2013: David Rueda (dr@hsb-cad.com)
	- Renamed from GE_3_WALL_CONNECTION to GE_WALLS_TRIPLE_T_CONNECTION
 v1.3: 15.ago.2012: David Rueda (dr@hsb-cad.com)
	- Thumbnail updated
 v1.2: 13.jul.2012: David Rueda (dr@hsb-cad.com)
	- Thumbnail added
	- Description added
 v1.1: 10-feb-2012: David Rueda (dr@hsb-cad.com)
	- Added functionality for very top plates
 v1.0: 14-apr-2011: David Rueda (dr@hsb-cad.com)
	- Release
*/

double dTol=U(0.01,0.0001);

if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	PrEntity ssE("\n"+T("|Select walls for T connection|"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}

	_Map.setInt("ExecutionMode",0);
			
	return;
}

if( _Element.length()!=3){
	reportMessage ( "\n" + T("|ERROR: 3 walls are needed|"));
	eraseInstance();
	return;
}

//Defining elemets
ElementWall el1 = (ElementWall) _Element[0];
if (!el1.bIsValid())
{
	eraseInstance();
	return;
}
ElementWall el2 = (ElementWall) _Element[1];
if (!el2.bIsValid())
{
	eraseInstance();
	return;
}
ElementWall el3 = (ElementWall) _Element[2];
if (!el3.bIsValid())
{
	eraseInstance();
	return;
}

int nHasExecutionMode=_Map.hasInt("ExecutionMode");
if(!nHasExecutionMode)
{
	reportMessage ( "\n" + T("|UNEXPECTED ERROR, please report to hsbCAD team|"));
	eraseInstance();
	return;
}

int nExecutionMode=_Map.getInt("ExecutionMode");
if(!nExecutionMode || _bOnElementConstructed)
{
	// Checking connections: 2 must be connected, 1 should have not connections
	// Wall 1
	int b1and2, b1and3, b2and3; // (Boolean) Connected
	int nConnectionsOn1, nConnectionsOn2, nConnectionsOn3; // Number of connections per element
	b1and2=b1and3=b2and3=nConnectionsOn1=nConnectionsOn2=nConnectionsOn3=false;
	
	Element elAllConnectedTo1[]=el1.getConnectedElements();
	for(int e=0;e<elAllConnectedTo1.length();e++)
	{
		Element elTmp=elAllConnectedTo1[e];																								
		if(elTmp==el2)
		{
			b1and2=true;
			nConnectionsOn1++;
		}
		if(elTmp==el3)
		{
			b1and3=true;
			nConnectionsOn1++;
		}
	}
	
	// Wall 2
	Element elAllConnectedTo2[]=el2.getConnectedElements();
	for(int e=0;e<elAllConnectedTo2.length();e++)
	{
		Element elTmp=elAllConnectedTo2[e];																								
		if(elTmp==el1)
		{
			b1and2=true;
			nConnectionsOn2++;
		}
		if(elTmp==el3)
		{
			b2and3=true;
			nConnectionsOn2++;
		}
	}
	
	// Wall 3
	Element elAllConnectedTo3[]=el3.getConnectedElements();
	for(int e=0;e<elAllConnectedTo3.length();e++)
	{
		Element elTmp=elAllConnectedTo3[e];																								
		if(elTmp==el1)
		{
			b1and3=true;
			nConnectionsOn3++;
		}
		if(elTmp==el2)
		{
			b2and3=true;
			nConnectionsOn3++;
		}
	}
	
	if( nConnectionsOn1==2 || nConnectionsOn2==2 || nConnectionsOn3==2 || ( b1and2 && b1and3 && b2and3 ) ) // 3 walls are connected
	{
		reportMessage ( "\n" + T("|ERROR: 3 walls are connected, cannot place T3 connection|") + "\n" +T("|2 walls must form corner and the 3th must be offset half inch max|"+"\n"));
		eraseInstance();
		return;
	}
	
	// Find elements in corner and isolated
	ElementWall el1OnCorner, el2OnCorner, elSingle;
	//Wall 1
	if( !b1and2 && !b1and3 && b2and3) // el1 is the single
	{
			elSingle=el1;
			el1OnCorner=el2;
			el2OnCorner=el3;
	}
	else if( !b1and2 && !b2and3 && b1and3 ) // el2 is the single
	{
			elSingle=el2;
			el1OnCorner=el1;
			el2OnCorner=el3;
	}
	else if( !b1and3  && !b2and3 && b1and2 ) // el3 is the single
	{
			elSingle=el3;
			el1OnCorner=el1;
			el2OnCorner=el2;
	}
	else
	{
		reportMessage ( "\n" + T("|ERROR: Undefined type of connection on TSL|") + "\n" +T("|2 walls must form corner and the 3th must be offset half inch max|"+"\n"));
		eraseInstance();
		return;
	}
	
	// Check: both walls at corner must be perpendicular
	if ( !el1OnCorner.vecX().isPerpendicularTo(el2OnCorner.vecX() ) )
	{
		reportMessage("\n"+T("|ERROR: 2 walls at corner MUST be perpendicular|")+"\n");
		eraseInstance();
		return;
	}
	
	// Find male and female wall in corner
	PLine plEl1=el1OnCorner.plOutlineWall();
	PLine plEl2=el2OnCorner.plOutlineWall();
	
	/*Checking if there is a CORNER connection between el1OnCorner and el2OnCorner; these are the conditions to be accomplished: 
		-	2 points must result when 2 outlines of walls intersect. If it's only one point resulting then is one of this situations: 
				T connection with only one contact point (open angle). User must use "stretch to wall(s) or roof(s)" tool.
				End to end wall connection (open angle). Depending on angle (obtuse or acute) user must select another tsl for 
				angled wall connection 
		- 	One element must have 1 coincident vertex with any of the 2 resulting points on intersection of both element's outlines, 
			while other element must have 2 coincident vertexes.
		-	Both elements must have exactly 1 coincident point between
	*/
	
	// Checking first condition: 2 points must result when 2 outlines of walls intersect
	Point3d ptAllInt[]=plEl1.intersectPLine(plEl2);
	if(ptAllInt.length()!=2)
	{
		reportMessage("\n"+T("|ERROR: check proper connection at corner|")+"\n");
		eraseInstance();
		return;
	}
	// Checking second condition: One element must have 1 coincident vertex with any of the 2 resulting points on intersection of both element's outlines, while other element must have 2 coincident vertexes.
	Point3d ptCon1=ptAllInt[0];
	Point3d ptCon2=ptAllInt[1];
	int nEl1HasCon1, nEl1HasCon2, nEl2HasCon1, nEl2HasCon2; 
	nEl1HasCon1=nEl1HasCon2=nEl2HasCon1=nEl2HasCon2=false;
	//Checking cioncident vertex
	Point3d ptAllEl1[]=plEl1.vertexPoints(1);
	Point3d ptAllEl2[]=plEl2.vertexPoints(1);
	//Element 1
	for(int p=0;p<ptAllEl1.length();p++)
	{
		if((ptAllEl1[p]-ptCon1).length()<dTol)
		{
				nEl1HasCon1=true;
		}
		if((ptAllEl1[p]-ptCon2).length()<dTol)
		{
				nEl1HasCon2=true;
		}
	}
	//Element 2
	for(int p=0;p<ptAllEl2.length();p++)
	{
		if((ptAllEl2[p]-ptCon1).length()<dTol)
		{
				nEl2HasCon1=true;
		}
		if((ptAllEl2[p]-ptCon2).length()<dTol)
		{
				nEl2HasCon2=true;
		}
	}
	
	int nEl1IsMale,nEl2IsMale;
	nEl1IsMale=nEl2IsMale=false;
	if(nEl1HasCon1&&nEl1HasCon2)//el1 has 2 coincident vertexes 
	{
		nEl1IsMale=true;
	}
	if(nEl2HasCon1&&nEl2HasCon2) //el2 has 2 coincident vertexes 
	{
		nEl2IsMale=true;
	}
	
	ElementWall elMaleOnCorner, elFemale;
	if(nEl1IsMale&&nEl2IsMale)//It's not a T connection, but a miter to miter connection
	{
			reportMessage("\n"+T("|ERROR: check proper connection at corner|")+"\n");
			eraseInstance();
			return;
	}
	else if(nEl1IsMale)
	{
		elMaleOnCorner=el1OnCorner;
		elFemale=el2OnCorner;
	}
	else if(nEl2IsMale)
	{
		elMaleOnCorner=el2OnCorner;
		elFemale=el1OnCorner;
		
	}
	else //None of elements has 2 coinident points
	{
			reportMessage("\n"+T("|ERROR: check proper connection at corner|")+"\n");
			eraseInstance();
			return;
	}
	
	// Checking 3th condition: Both elements must have exactly 1 coincident point between
	// Previous declarations:
	// 			PLine plEl1=el1OnCorner.plOutlineWall();
	// 			PLine plEl2=el2OnCorner.plOutlineWall();
	// 			Point3d ptAllEl1[]=plEl1.vertexPoints(1); 
	// 			Point3d ptAllEl2[]=plEl2.vertexPoints(1);
	int nCommonPoints=0;
	Point3d ptCommon;
	for(int p=0;p<ptAllEl1.length();p++)
	{
		for(int q=0;q<ptAllEl2.length();q++)
		{
			if( ( ptAllEl1[p]-ptAllEl2[q] ).length() <dTol)
			{
				nCommonPoints++;
				ptCommon=ptAllEl1[p];
			}
		}
	}
	
	if(nCommonPoints!=1)
	{
			reportMessage("\n"+T("|ERROR: check proper connection at corner|")+"\n");
			eraseInstance();
			return;
	}
	
	// READY TO WORK WITH 3 WALLS:
	//	elSingle
	//	elMaleOnCorner
	//	elFemale
	
	//Getting Info from elSingle
	CoordSys csElSingle=elSingle.coordSys();
	Point3d ptElSingleOrg=csElSingle.ptOrg();
	Vector3d vxElSingle=csElSingle.vecX();
	Vector3d vyElSingle=csElSingle.vecY();
	Vector3d vzElSingle=csElSingle.vecZ();
	PlaneProfile ppElSingle(elSingle.plOutlineWall());
	LineSeg lsElSingle=ppElSingle.extentInDir(vxElSingle);
	double dElSingleLength=abs(vxElSingle.dotProduct(lsElSingle.ptStart()-lsElSingle.ptEnd()));
	double dElSingleWidth=elSingle.dBeamWidth();
	Point3d ptElSingleStart=csElSingle.ptOrg();
	Point3d ptElSingleEnd=ptElSingleStart+vxElSingle*dElSingleLength;
	Point3d ptElSingleMid=ptElSingleStart+vxElSingle*dElSingleLength*.5-vzElSingle*dElSingleWidth*.5;	
	
	//Getting Info from elFemale
	CoordSys csElFemale=elFemale.coordSys();
	Point3d ptElFemaleOrg=csElFemale.ptOrg();
	Vector3d vxElFemale=csElFemale.vecX();
	Vector3d vyElFemale=csElFemale.vecY();
	Vector3d vzElFemale=csElFemale.vecZ();
	PlaneProfile ppElFemale(elFemale.plOutlineWall());
	LineSeg lsElFemale=ppElFemale.extentInDir(vxElFemale);
	double dElFemaleLength=abs(vxElFemale.dotProduct(lsElFemale.ptStart()-lsElFemale.ptEnd()));
	double dElFemaleWidth=elFemale.dBeamWidth();
	Point3d ptElFemaleStart=csElFemale.ptOrg();
	Point3d ptElFemaleEnd=ptElFemaleStart+vxElFemale*dElFemaleLength;
	Point3d ptElFemaleMid=ptElFemaleStart+vxElFemale*dElFemaleLength*.5-vzElFemale*dElFemaleWidth*.5;	
	Point3d ptElFemaleFront=ptElFemaleOrg;
	Point3d ptElFemaleBack=ptElFemaleFront-vzElFemale*dElFemaleWidth;
	
	//Getting Info from elMaleOnCorner
	CoordSys csElMaleOnCorner=elMaleOnCorner.coordSys();
	Point3d ptElMaleOnCornerOrg=csElMaleOnCorner.ptOrg();
	Vector3d vxElMaleOnCorner=csElMaleOnCorner.vecX();
	Vector3d vyElMaleOnCorner=csElMaleOnCorner.vecY();
	Vector3d vzElMaleOnCorner=csElMaleOnCorner.vecZ();
	PlaneProfile ppElMaleOnCorner(elMaleOnCorner.plOutlineWall());
	LineSeg lsElMaleOnCorner=ppElMaleOnCorner.extentInDir(vxElMaleOnCorner);
	double dElMaleOnCornerLength=abs(vxElMaleOnCorner.dotProduct(lsElMaleOnCorner.ptStart()-lsElMaleOnCorner.ptEnd()));
	double dElMaleOnCornerWidth=elMaleOnCorner.dBeamWidth();
	Point3d ptElMaleOnCornerStart=csElMaleOnCorner.ptOrg();
	Point3d ptElMaleOnCornerEnd=ptElMaleOnCornerStart+vxElMaleOnCorner*dElMaleOnCornerLength;
	Point3d ptElMaleOnCornerMid=ptElMaleOnCornerStart+vxElMaleOnCorner*dElMaleOnCornerLength*.5-vzElMaleOnCorner*dElMaleOnCornerWidth*.5;	
	Point3d ptElMaleOnCornerFront=ptElMaleOnCornerOrg;
	Point3d ptElMaleOnCornerBack=ptElMaleOnCornerFront-vzElMaleOnCorner*dElMaleOnCornerWidth;
	
	// Define which wall on the corner is the one to be modyfied
	ElementWall elPerpendicularToElSingle; // Changes will be done to this element 
	Point3d ptElPerpendicularToElSingleMid;
	if(vxElSingle.isPerpendicularTo(vxElFemale))
	{	
		elPerpendicularToElSingle=elFemale;
		ptElPerpendicularToElSingleMid=ptElFemaleMid;
	}
	else if (vxElSingle.isPerpendicularTo(vxElMaleOnCorner))
	{	
		elPerpendicularToElSingle=elMaleOnCorner;
		ptElPerpendicularToElSingleMid=ptElMaleOnCornerMid;
	}
	else
	{
		reportMessage("\n"+T("|ERROR: check elements alignment|")+"\n");
		eraseInstance();
		return;
	}	

	Vector3d vOutZelSingle=vzElSingle; // Vector in Z direction of elSingle, always pointing outside 3 wall connection
	if(vOutZelSingle.dotProduct(ptElSingleMid-ptElPerpendicularToElSingleMid)<0)
	{	
		vOutZelSingle=-vOutZelSingle;
	}

	Vector3d vOutXelSingle=vxElSingle; // Vector in X direction of elSingle, always pointing outside 3 wall connection
	if(vOutXelSingle.dotProduct(ptElSingleMid-ptElPerpendicularToElSingleMid)<0)
	{	
		vOutXelSingle=-vOutXelSingle;
	}
		
	// Getting closest point to elSingle on corner ( Point where elSingle will be to stretched to)
	// Previous declarations:
	// 	PLine plEl1=el1OnCorner.plOutlineWall();
	// 	PLine plEl2=el2OnCorner.plOutlineWall();
	// 	Point3d ptAllEl1[]=plEl1.vertexPoints(1); 
	// 	Point3d ptAllEl2[]=plEl2.vertexPoints(1);
	Point3d ptStretchSingle;
	Point3d ptAll1and2[0];
	ptAll1and2.append(ptAllEl1);
	ptAll1and2.append(ptAllEl2);
	double dTmp=U(50000, 2000);
	for(int p=0;p<ptAll1and2.length();p++)
	{
		Point3d ptTmp=ptAll1and2[p];
		double dDist=abs(vxElSingle.dotProduct(ptElSingleMid-ptTmp));
		if(dTmp>dDist)
		{
			dTmp=dDist;
			ptStretchSingle=ptAll1and2[p];
		}
	}
	ptStretchSingle+=vzElSingle*vzElSingle.dotProduct(ptElSingleMid-ptStretchSingle); // Always aligned to ptElSingleMid
	
	// Getting closest point to corner on elSingle
	Point3d ptElSingleCloser=ptElSingleStart;
	if(abs(vxElSingle.dotProduct(ptStretchSingle-ptElSingleEnd))<abs(vxElSingle.dotProduct(ptStretchSingle-ptElSingleStart)))
	{
		ptElSingleCloser=ptElSingleEnd;
	}
	ptElSingleCloser+=vzElSingle*vzElSingle.dotProduct(ptElSingleMid-ptElSingleCloser);
	ptElSingleCloser+=-vOutZelSingle*dElSingleWidth*.5; // Always aligned to internal face of elSingle
	
	
	// Verify offset for elSingle is no more than permitted
	double dSingleOff=U(15,.5); // Offset permitted
	double dDist=abs( vxElSingle.dotProduct(ptElSingleCloser-ptStretchSingle));
	if(dDist>dSingleOff+dTol)
	{
		reportMessage("\n"+T("|ERROR: offset for lose element cannot be greater than| ")+ dSingleOff+"\n");
		eraseInstance();
		return;
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////	STRETCHING elSingle	/////////////////////////////////////////////////////////////////////////////////////////////////
	// Create body that any component of elSingle and elPerpendicularToElSingle which has contact with it will be streched/moved/cut
	double dbdStSingleL = U(50,2);	//Body length
	double dbdStSingleW = U(250,10);;	//Body width
	double dbdStSingleH = U(5000,200);	//Body height
	Body bdFilterSingle(ptStretchSingle, vxElSingle, vyElSingle, vzElSingle, dbdStSingleL, dbdStSingleH, dbdStSingleW, 0, 1, 0);
	
	//////////////////////////////////////////////	STRETCHING elSingle: PLATES	//////////////////////////////////////////////
	//Finding top, very top, and bottom plates on elSingle
	Beam bmAllMale[]=elSingle.beam();// The only male to be modyfied
	Beam bmAllMaleHorizontal[0], bmAllMaleVTP[0], bmAllMaleTP[0], bmAllMaleBtm[0];
	bmAllMaleHorizontal=vxElSingle.filterBeamsParallel(bmAllMale);
	Beam bmAllMaleHorizontalNonPlates[0];
	for(int b=0;b<bmAllMaleHorizontal.length();b++)
	{
		Beam bm=bmAllMaleHorizontal[b];																										
		if(bm.type()==_kSFTopPlate || bm.type()==_kTopPlate || bm.type()==_kSFBottomPlate || bm.type() == _kSFVeryTopPlate)//Bottom, Top and Very Top Plates
		{		
			//Must be closer enough to point to be splitted
			if(bm.envelopeBody().intersectWith(bdFilterSingle))
			{
				//Clasifying, top and very top
				if(bm.beamCode().token(0).makeUpper()=="V" || bm.type() == _kSFVeryTopPlate)//VTP
				{
					bmAllMaleVTP.append(bm);
				}
				else if(bm.type()==_kSFTopPlate || bm.type()==_kTopPlate)//TP
				{
					bmAllMaleTP.append(bm);
				}
				else if(bm.type()==_kSFBottomPlate)//Bottom Plates
				{
					bmAllMaleBtm.append(bm);
				}
			}
		}
		else
		{
			bmAllMaleHorizontalNonPlates.append(bm);
		}
	}
	
	//Stretching all TP's, VTP's and Bottoms
	Vector3d vCutSingle=vxElSingle;
	if((ptStretchSingle-ptElSingleCloser).dotProduct(vCutSingle)<0)
	{
		vCutSingle=-vCutSingle;
	}
	
	Cut ct1(ptStretchSingle,vCutSingle);
	
	//VTP's
	for(int b=0;b<bmAllMaleVTP.length();b++)
	{
		Beam bm=bmAllMaleVTP[b];
		bm.addToolStatic(ct1, 1);
	}
	//TP's
	for(int b=0;b<bmAllMaleTP.length();b++)
	{
		Beam bm=bmAllMaleTP[b];
		bm.addToolStatic(ct1, 1);
	}
	//Bottoms
	for(int b=0;b<bmAllMaleBtm.length();b++)
	{
		Beam bm=bmAllMaleBtm[b];
		bm.addToolStatic(ct1, 1);
	}
	
	//////////////////////////////////////////////	MOVING elSingle: VERTICAL BEAMS	//////////////////////////////////////////////
	Beam bmAllMaleVertical[]=vyElSingle.filterBeamsParallel(bmAllMale);
	for(int b=0;b<bmAllMaleVertical.length();b++)
	{
		Beam bm=bmAllMaleVertical[b];																									
		//Must be closer enough to point to be splitted
		if(bm.envelopeBody().intersectWith(bdFilterSingle))
		{
			// Colecting al horizontal beams in contact with this beam
			Beam bmAllInContact[0];
			bmAllInContact.append(bm.filterBeamsContactCut(bmAllMaleHorizontalNonPlates));
			// Must be displaced offset to male wall
			bm.transformBy(vxElSingle*vxElSingle.dotProduct(ptStretchSingle-ptElSingleCloser));
			// Strech all beams that were in contact
			for(int c=0; c<bmAllInContact.length(); c++)
			{
				Beam bmC=bmAllInContact[c];
				bmC.stretchDynamicTo(bm);	
			}		
		}
	}
	
	//////////////////////////////////////////////	CREATING elSingle: SHEETING on external side 	//////////////////////////////////////////////
	// Previous declarations:
	//	Vector3d vOutZelSingle=vzElSingle; // Vector normal to elSingle, always pointing outside 3 wall connection
	//	if(vOutZelSingle.dotProduct(ptElSingleMid-ptElPerpendicularToElSingleMid)<0)
	//	{	
	//		vOutZelSingle=-vOutZelSingle;
	//	}
	// Vector3d vCutSingle=vxElSingle;
	// if((ptStretchSingle-ptElSingleCloser).dotProduct(vCutSingle)<0)
	// {
	// 	vCutSingle=-vCutSingle;
	// }
	
	// WARNING bdFilterSingle will be displaced to one side of elSingle in order to find sheetings on appropiate side only. MUST BE RELOCATED BACK
	bdFilterSingle.transformBy(vOutZelSingle*dbdStSingleW*.5);
	
	// Making copy of existing (if needed) and cutting it
	Sheet shAllSingle[]=elSingle.sheet();
	for(int s=0;s<shAllSingle.length();s++)
	{
		Sheet sh=shAllSingle[s];
		Body bdSh=sh.envelopeBody();
		if(bdSh.hasIntersection(bdFilterSingle))//Sheeting is in contact with corner
		{
			// Make copy of it
			Sheet shNew=sh.dbCopy();
			// Move this copy to edge of corner
			shNew.transformBy(vxElSingle*vxElSingle.dotProduct(ptStretchSingle-ptElSingleCloser));
			//Cutting this new piece
			Cut ct(ptElSingleCloser, -vCutSingle);
			shNew.addToolStatic(ct); 
 		}
	}
	// Returning bdFilterSingle to its original position
	bdFilterSingle.transformBy(-vOutZelSingle*dbdStSingleW*.5);

	//////////////////////////////////////////////	CUTTING elSingle: SHEETING on internal side		//////////////////////////////////////////////
	//Find point to cut (must be most external of sheetings along vzElFemale, ON THE SAME SAIDE OF elSingle)
	//Define what side of elPerpendicularToElSingle has the reference point to cut shetting on elPerpendicularToElSingle
	int nSide=0;
	if(vOutXelSingle.dotProduct(ptElSingleCloser-ptElPerpendicularToElSingleMid)<0)//Male wall is at icon side of female wall
	{
		nSide=1;
	}
	else
	{
		nSide=-1;
	}
	// Finding cut point
	ElemZone elZn=elPerpendicularToElSingle.zone(nSide*5);
	Point3d ptMax=elZn.ptOrg()+nSide*vOutXelSingle*elZn.dH();
	
	// WARNING bdFilterSingle will be displaced to one side of elSingle in order to find sheetings on appropiate side only. MUST BE RELOCATED BACK
	bdFilterSingle.transformBy(-vOutZelSingle*dbdStSingleW*.5);
	// Cutting sheeting
	for(int s=0;s<shAllSingle.length();s++)
	{
		Sheet sh=shAllSingle[s];
		Body bdSh=sh.envelopeBody();
		if(bdSh.hasIntersection(bdFilterSingle))//Sheeting is in contact with corner
		{
			//Cutting this piece
			Cut ct(ptMax, -vOutXelSingle);
			sh.addToolStatic(ct); 
		}
	}
	// Returning bdFilterSingle to its original position
	bdFilterSingle.transformBy(vOutZelSingle*dbdStSingleW*.5);

	/////////////////////////////////////////////////////////////////////////////////////////////////	END STRETCHING elSingle	/////////////////////////////////////////////////////////////////////////////////////////////////
	
	/////////////////////////////////////////////////////////////////////////////////////////////////	CUTTING sheeting on elPerpendicularToElSingle	/////////////////////////////////////////////////////////////////////////////////////////////////
	// WARNING bdFilterSingle will be displaced to one side of elPerpendicularToSingle in order to find sheetings on appropiate side only. MUST BE RELOCATED BACK
	bdFilterSingle.transformBy(vOutXelSingle*dbdStSingleL*.5);
	
	Point3d ptCut=ptElSingleCloser;
	// Cutting sheeting
	Sheet shAllPerp[]=elPerpendicularToElSingle.sheet();
	for(int s=0;s<shAllPerp.length();s++)
	{
		Sheet sh=shAllPerp[s];
		Body bdSh=sh.envelopeBody();
		if(bdSh.hasIntersection(bdFilterSingle))//Sheeting is in contact with corner
		{
			//Cutting this piece
			Cut ct(ptCut, vOutZelSingle);
			sh.addToolStatic(ct); 
		}
	}
	
	// Returning bdFilterSingle to its original position
	bdFilterSingle.transformBy(-vOutXelSingle*dbdStSingleL*.5);

	// Setting display 
	Point3d ptDisplay=ptElSingleMid+vOutXelSingle*vOutXelSingle.dotProduct(ptElPerpendicularToElSingleMid-ptElSingleMid);
	ptDisplay+=vOutZelSingle*dElSingleWidth*.5;
	_Map.setPoint3d("DISPLAY START", ptDisplay);
	_Map.setVector3d("OUT X SINGLE", vOutXelSingle);
	_Map.setVector3d("OUT Z SINGLE", vOutZelSingle);
	
	_Map.setInt("ExecutionMode",1);
	//ptStretchSingle.vis();ptElSingleCloser.vis();ptMax.vis();
}

//Display
double dOff=U(25,2);
double dL=U(25,2);
Vector3d vOutXelSingle=_Map.getVector3d("OUT X SINGLE");
Vector3d vOutZelSingle=_Map.getVector3d("OUT Z SINGLE");
PLine plDisp(_ZW);
Point3d ptDisp=_Map.getPoint3d("DISPLAY START");
ptDisp+=vOutZelSingle*dOff;
plDisp.addVertex(ptDisp);
ptDisp+=vOutZelSingle*dL;
plDisp.addVertex(ptDisp);
ptDisp+=-vOutXelSingle*dL;
plDisp.addVertex(ptDisp);
PLine plDisp2(_ZW);
ptDisp+=vOutXelSingle*(dL+dOff*.2);
plDisp2.addVertex(ptDisp);
ptDisp+=vOutXelSingle*(dL);
plDisp2.addVertex(ptDisp);

Display dp(-1);
dp.draw(plDisp);
dp.draw(plDisp2);
_Pt0=ptDisp;
return;




#End
#BeginThumbnail
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
M<N?:VZ?]?-BY>Y@_\(S_`-/?_D/_`.O1_P`(S_T]_P#D/_Z];]%=?]BX'^3\
M7_F/E17LK7['9QV^_?LS\V,9R2?ZU8HHKT:<(TX*$=EHB@HHHJP"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`.=M/^1C;_`*ZR?UKHJYVT_P"1C;_KK)_6
MNBK6MNO0YL+\+]3G=?\`^/Y/^N0_F:Z*N=U__C^3_KD/YFNBHJ?#$*/\2?R"
MBBBLCI"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@#G;3_`)&-O^NLG]:Z*N=M/^1C;_KK)_6NBK6MNO0YL+\+]3G=?_X_D_ZY
M#^9KHJYW7_\`C^3_`*Y#^9KHJ*GPQ"C_`!)_(****R.D****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`.=M/^1C;_KK)_6NBKG;
M3_D8V_ZZR?UKHJUK;KT.;"_"_4YW7_\`C^3_`*Y#^9KHJYW7_P#C^3_KD/YF
MNBHJ?#$*/\2?R"BBBLCI"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@#G;3_D8V_ZZR?UKHJYB6*]BU*::&&4'S&*L(R>I/M4O
MVO6?[LW_`'Y_^M71.'-9IG#2JJFFFGN&O_\`'\G_`%R'\S715REQ'J%U('F@
MF9@,`^41Q^`KJZFJK12-,.^:<Y6W"BBBL3J"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
)**`"BBB@#__9
`


#End
