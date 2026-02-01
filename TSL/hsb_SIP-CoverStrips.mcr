#Version 8
#BeginDescription
Creating cover strips in SIP 

version value="1.1" date="18.11.2019" author="marsel.nakuci@hsbcad.com"

HSB-5915: fix bug at the color
Created by: Mihai Bercuci 
Date: 15.11.2017 
Version 1.1
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
/// <version value="1.1" date="18.11.2019" author="marsel.nakuci@hsbcad.com"> HSB-5915: fix bug at the property color </version>
/// </History>

/// <insert Lang=en>
/// Select entity, insert properties or catalog entry, select elements and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates 
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsb_SIP-CoverStrips")) TSLCONTENT
//endregion


/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2017 by
*  hsbcad
*
*  The program may be used and/or copied only with the written
*  permission from hsbcad, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved
*/

Unit (1, "mm");
PropString sheetName(0, "", T("Add Sheet Name")); 
PropString sheetMaterial(1, "", T("Add Sheet Material Type")); 
PropInt sheetColor(0, 1, T("Add sheet color"));

//String sVARIABLEName=T("|VARIABLE|");	
//int nVARIABLEs[]={1,2,3};
//PropInt nVARIABLE(nIntIndex++, nVARIABLEs, sVARIABLEName);	
//nVARIABLE.setDescription(T("|Defines the VARIABLE|"));
//nVARIABLE.setCategory(category);




if( _bOnInsert )
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey == "")
		showDialog();
	
	PrEntity ssE(T("Select one or More Elements"), Element());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	//Insert the TSL again for each Element
	TslInst tsl;
	String sScriptName = scriptName(); // name of the script
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Entity lstEnts[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	lstPropString.append(sheetName);
	lstPropString.append(sheetMaterial);
	lstPropInt.append(sheetColor);
	
	Map mpToClone;
	mpToClone.setInt("ExecutionMode",0);

	for (int i=0; i<_Element.length(); i++)
	{
		lstEnts.setLength(0);
		lstEnts.append(_Element[i]);
		tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
	}

	//_Element.append(getElement(T("Select an element")));
	_Map.setInt("ExecutionMode",0);
	eraseInstance();
	return;
}


if( _Element.length() == 0 ){
	eraseInstance();
	return;
}

for ( int e = 0; e < _Element.length(); e++)
{
	Element el = _Element[e];
	CoordSys csEl = el.coordSys();

	Vector3d vz = el.vecZ();
	
	Beam arBm[] = el.beam();//get all beams from the element
	Sheet allSheet[] = el.sheet(); //get all sheets from the element
	Sip allSip[] = el.sip(); //get all sip elements
	
	_Pt0 = el.ptOrg(); _Pt0.vis();
	vz.vis(_Pt0);
	
	Point3d ptElOrg = el.ptOrg();
	
	Sip sp;
	//Get the Sip thickness 
	Sip allSipElement[] = el.sip();
	if(allSipElement.length()>0)
	{
		sp = allSipElement[0];
	}
	else
	{
		break;
	}
	//double sipThicknes=sp.
	String  sipStyle = sp.style();
	SipStyle sipStyle_=SipStyle(sipStyle); 
	double sipTickness = sipStyle_.dThickness();  
	Point3d ptElBack = ptElOrg - sipTickness * vz; // _Pt0.projectPoint(plnElement, sipTickness, - vz);//get the point from the oposite side
	
	SipComponent sipComps[] = sipStyle_.sipComponents();// get the sip components
	SipComponent internalSheet = sipComps[0]; 
	SipComponent externalSheet = sipComps[2]; 
	
	double internalSheetThickness = internalSheet.dThickness(); 
	double externalSheetThickness = externalSheet.dThickness();
	
	Point3d ptInternalSheet = ptElOrg - internalSheetThickness * vz; //starting point for internal face sheet
	Point3d ptExternalSheet = ptElBack + externalSheetThickness * vz; //starting point for External face sheet
	
	Plane plnElement(ptElOrg, vz);  //define a plane for using to envelope the Body of the beam
	Plane plnElementSecond(ptElBack, -vz);  //define a plane for using to envelope the Body of the sheet  oposite side

	PlaneProfile planeBeamProfileFirst(plnElement);//define a planeProfile for beams
	PlaneProfile planeBeamProfileSecond(plnElementSecond);//define a planeProfile for beams other side
	
	PlaneProfile planeSheetProfileFirst(plnElement);//define a planeProfile for first sheets 
	PlaneProfile planeSheetProfileSecond(plnElementSecond);//define a planeProfile for second sheets
	
	PlaneProfile planeSipProfileFirst(plnElement);//define a planeProfile for second sheets
	PlaneProfile planeSipProfileSecond(plnElementSecond);//define a planeProfile for second sheets

	
	//reportNotice ("\n"+el.number());
	for ( int i = 0; i < allSip.length(); i++)
	{
		// get the plane profile from all sips
		Sip sip_ = allSip[i];
		
		//get the first sheet plane
		PlaneProfile ppSipFirst = sip_.envelopeBody(true, true).extractContactFaceInPlane(plnElement, U(1));  		//ppSip.vis(9);
		planeSipProfileFirst.unionWith(ppSipFirst); 	//planeSipProfile.vis();
		
		//get the second sheet plane
		PlaneProfile ppSipSecond = sip_.envelopeBody(true, true).extractContactFaceInPlane(plnElementSecond, U(1));  		
		planeSipProfileSecond.unionWith(ppSipSecond);
	}
 
	// planeSipProfileFirst.vis(0);
	// planeSipProfileSecond.vis(1);
 
	//get the sip plane profile for first side
	for ( int i = 0; i < allSheet.length(); i++)
	{
		// get the plane profile from sheets
		Sheet sheet_ = allSheet[i];
		
		//get the first sheet plane
		PlaneProfile ppSheetFirst = sheet_.envelopeBody(true, true).extractContactFaceInPlane(plnElement, U(1)); //ppSheetFirst.vis(9);
		planeSheetProfileFirst.unionWith(ppSheetFirst);//planeSheetProfileFirst.vis(11);
		
		//get the second sheet plane
		PlaneProfile ppSheetSecond = sheet_.envelopeBody(true, true).extractContactFaceInPlane(plnElementSecond,  U(1)); //ppSheetSecond.vis();
		planeSheetProfileSecond.unionWith(ppSheetSecond);
	}	
//	planeSheetProfileFirst.vis(5);
//	planeSheetProfileSecond.vis(3);
	
	for ( int i = 0; i < arBm.length(); i++)
	{
		
		// get the plane profile from beams
		Beam bm = arBm[i];
		
		PlaneProfile ppBeamFirst = bm.envelopeBody(true, true).shadowProfile(plnElement);
		planeBeamProfileFirst.unionWith(ppBeamFirst);
		
		PlaneProfile ppBeamSecond = bm.envelopeBody(true, true).shadowProfile(plnElementSecond);
		planeBeamProfileSecond.unionWith(ppBeamSecond);
		//planeBeamProfile.vis();

		
	}
	//planeBeamProfileFirst.vis();
	//planeBeamProfileSecond.vis();
	///////////////////
	//planeSipProfile.vis(3);
	PlaneProfile fullPlaneProfile = planeBeamProfileFirst;
	fullPlaneProfile.unionWith(planeSheetProfileFirst);
	fullPlaneProfile.unionWith(planeSipProfileFirst); // the full plane profile
	//fullPlaneProfile.vis(3);
	///////////////////
	
	////////////////// get the sip gaps first
	PlaneProfile sipGapsProfileFirst = fullPlaneProfile;
	sipGapsProfileFirst.subtractProfile(planeSipProfileFirst); //sipGapsProfileFirst.vis();
	sipGapsProfileFirst.subtractProfile(planeSheetProfileFirst);
	sipGapsProfileFirst.vis(2);
	////////////////
	
	//get the full profile for the other side
	PlaneProfile fullPlaneProfileSecond = planeBeamProfileSecond;
	fullPlaneProfileSecond.unionWith(planeSheetProfileSecond);
	fullPlaneProfileSecond.unionWith(planeSipProfileSecond); // the full plane profile
	//fullPlaneProfileSecond.vis(3);
	///////////////////
	
	////////////////// get the sip gaps first
	PlaneProfile sipGapsProfileSecond = fullPlaneProfileSecond ;//sipGapsProfileSecond.vis(21);
	sipGapsProfileSecond.subtractProfile(planeSipProfileSecond ); //planeSipProfileSecond.vis(6);
	sipGapsProfileSecond.subtractProfile(planeSheetProfileSecond );// planeSheetProfileSecond.vis(8);
	sipGapsProfileSecond .vis(3);
	////////////////
	
	////////////get all rings from the sip gaps add them as an array of sheets
	PLine sipGapsRings[] = sipGapsProfileFirst.allRings();
	PLine sipGapsRingsSecond[] = sipGapsProfileSecond.allRings();
	
	//line in the direction of vecX
	Line normalLine(ptElOrg, csEl.vecX());  
	//////////////////////
	
	//array use for adding the sheets
	Sheet shNewArray[0];
 
 	//GET THE sipGaps face one
	for(int i=0; i<sipGapsRings.length(); i++)
	{				
		PLine pl=sipGapsRings[i];
		CoordSys csRingNew(ptInternalSheet, csEl.vecX(), csEl.vecY(), csEl.vecZ());

		PlaneProfile pp(csRingNew);
		pp.joinRing(pl, false);
		
		//get the vertexes point
		Point3d ppVertexPoints[ ] = pl.vertexPoints(FALSE); 
		ppVertexPoints = normalLine.projectPoints(ppVertexPoints); //project the vretexes point on the normal line
		ppVertexPoints = normalLine.orderPoints(ppVertexPoints);
		
		//create the beams from vertex points
		for(int p=0;p<ppVertexPoints.length()-1; p++)
		{
	 		Point3d ptVertexStart = ppVertexPoints[p]; ptVertexStart.vis();
			Point3d ptVertexEnd = ppVertexPoints[p +1]; ptVertexEnd.vis();
						
			double rectWidth = (ptVertexStart - ptVertexEnd).length(); //get the rect between the 2 points width
			
			if(rectWidth<U(1))//if the distance is smaller then a certan value dont create any sheets
			{
				break;
			}
			
			PLine plFullProjectedArea;
			plFullProjectedArea.createRectangle(LineSeg(ptVertexStart + csEl.vecY() * U(10000), ptVertexEnd - csEl.vecY() * U(10000) ), csEl.vecX(), csEl.vecY() );  //plFullProjectedArea.vis(6);
			
			PlaneProfile ppComonArea(csRingNew);
			ppComonArea.joinRing(plFullProjectedArea, false);	 //ppComonArea.vis(5);
			
			PlaneProfile ppRingIntersection(csRingNew);
			ppRingIntersection = pp;
			ppRingIntersection.intersectWith(ppComonArea);  ppRingIntersection.vis(5);
			
			LineSeg  elementDiagonal= ppRingIntersection.extentInDir(csEl.vecX());// get the diagonal of the new created element
			Vector3d   vectorDiagonal = elementDiagonal.ptStart()-elementDiagonal.ptEnd();
			double width_= abs(vectorDiagonal.dotProduct(csEl.vecX())); 
			double length_= abs(vectorDiagonal.dotProduct(csEl.vecY()));
			
			
			if(width_>length_)//change the coordonate system
			{
				CoordSys csRingNew(ptInternalSheet, csEl.vecY() ,-csEl.vecX(), csEl.vecZ());
				PlaneProfile newPlane(csRingNew);
				newPlane.joinRing(pl, false);
				newPlane.intersectWith(ppComonArea);  ppRingIntersection.vis(5);
				Sheet tempSheet;
				tempSheet.dbCreate(newPlane, internalSheetThickness,1); /// the entitity tickness
				shNewArray.append(tempSheet);
				tempSheet.setName(sheetName);
				tempSheet.setMaterial(sheetMaterial);
				tempSheet.setColor(sheetColor);
			}
			
			else
			{
				Sheet tempSheet;
				tempSheet.dbCreate(ppRingIntersection, internalSheetThickness,1); /// the entitity tickness
				shNewArray.append(tempSheet);
				tempSheet.setName(sheetName);
				tempSheet.setMaterial(sheetMaterial);
				tempSheet.setColor(sheetColor);
				//tempSheet.realBody().vis(1);
			}			 
		}

	
	}
	
  	//GET THE sipGaps face two
	for(int i=0; i<sipGapsRingsSecond.length(); i++)
	{				
		PLine pl=sipGapsRingsSecond[i];
		CoordSys csRingNew(ptExternalSheet, csEl.vecX(), csEl.vecY(),csEl.vecZ());

		PlaneProfile pp(csRingNew);
		pp.joinRing(pl, false);	 pp.vis(5);


		//get the vertexes point
		Point3d ppVertexPoints[ ] = pl.vertexPoints(FALSE); 
		ppVertexPoints = normalLine.projectPoints(ppVertexPoints); //project the vretexes point on the normal line
		ppVertexPoints = normalLine.orderPoints(ppVertexPoints);

		//create the beams from vertex points
		for(int p=0;p<ppVertexPoints.length()-1; p++)
		{
	 		Point3d ptVertexStart = ppVertexPoints[p]; ptVertexStart.vis();
			Point3d ptVertexEnd = ppVertexPoints[p +1]; ptVertexEnd.vis();
						
			double rectWidth = (ptVertexStart - ptVertexEnd).length(); //get the rect between the 2 points width
			
			if(rectWidth<U(1))//if the distance is smaller then a certan value dont create any sheets
			{
				break;
			}
			
			PLine plFullProjectedArea;
			plFullProjectedArea.createRectangle(LineSeg(ptVertexStart + csEl.vecY() * U(10000), ptVertexEnd - csEl.vecY() * U(10000) ), csEl.vecX(), csEl.vecY() );  //move the vertex point in the oposite direction
			
			PlaneProfile ppComonArea(csRingNew);
			ppComonArea.joinRing(plFullProjectedArea, false);	 //ppComonArea.vis(5);
			
			PlaneProfile ppRingIntersection(csRingNew);
			ppRingIntersection = pp;
			ppRingIntersection.intersectWith(ppComonArea);  ppRingIntersection.vis(5);
			
			LineSeg  elementDiagonal= ppRingIntersection.extentInDir(csEl.vecX());// get the diagonal of the new created element
			Vector3d   vectorDiagonal = elementDiagonal.ptStart()-elementDiagonal.ptEnd();
			double width_= abs(vectorDiagonal.dotProduct(csEl.vecX())); 
			double length_= abs(vectorDiagonal.dotProduct(csEl.vecY()));
			
			Sheet tempSheet;				

			if(width_ >length_)//change the coordonate system
			{
				CoordSys csRingNew_(ptExternalSheet, csEl.vecY() ,-csEl.vecX(), csEl.vecZ());
				PlaneProfile newPlane(csRingNew_);
				newPlane.joinRing(pl, false);
				newPlane.intersectWith(ppComonArea);  

				tempSheet.dbCreate(newPlane, externalSheetThickness,-1); /// the entitity tickness
				shNewArray.append(tempSheet);
			}
			else
			{
			
				tempSheet.dbCreate(ppRingIntersection, externalSheetThickness, -1); /// the entitity tickness
				shNewArray.append(tempSheet);
				//tempSheet.realBody().vis(2);
			}	
			tempSheet.setName(sheetName);
			tempSheet.setMaterial(sheetMaterial);
			tempSheet.setColor(sheetColor);
		}
	}
	/////////////////////////////////////////////
	
	for(int t=0;t<shNewArray.length();t++)
	{				
		//shNewArray[t].realBody().vis(2);
		shNewArray[t].assignToElementGroup(el,true, 0, 'Z' );
	}
	
	Display dp(1);
	PLine pl1(_ZU);
	pl1.addVertex(_Pt0);
	pl1.addVertex(_Pt0 -el.vecX() * 5);
	dp.draw(pl1);
}

eraseInstance();
return;


#End
#BeginThumbnail


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