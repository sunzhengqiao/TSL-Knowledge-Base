#Version 8
#BeginDescription
Create a reference line around the element, beams or floors.

Modified by: Mihai Bercuci(mihai.bercuci@hsbcad.com)
Date: 08.11.2017 - version 2.15







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 15
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT 
*  IRELAND
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.

* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 27.05.2008
* version 1.0: Release Version
*
*date 31.10.2008
*version 2.1
*
*Modify by: Alberto Jena (aj@hsb-cad.com)
*date 18.11.2008
*version 2.2
* 
*Modify by: Alberto Jena (aj@hsb-cad.com)
*date 00.06.2009
*version 2.3	Add Hatch Patterns for Externa, Internal and Other walls
*				Add the TSL to a Group that can be specify on the OPM
*				Show the Location of the Opening and a Label W=Window D=Door in the case it exist
*				Add Opening Option
*
*Modify by: Alberto Jena (aj@hsb-cad.com)
*date 19.01.2011
*version 2.6 Add the option to None Hatch
*
*Modify by: Chirag Sawjani (csawjni@itw-industry.com)
*date 25.05.2011
*version 2.7 Added the ability to move the outline to any position in all three modes.  Add/Remove Beams and Elements through Custom Commands. Added Point Loads to draw.
*
*Modify by: Chirag Sawjani (csawjni@itw-industry.com)
*date 06.01.2012
*version 2.9 Added sheets to the modes list and modified the checks for each mode (eraseinstance)
*
*Modify by: Chirag Sawjani (csawjni@itw-industry.com)
*date 16.01.2012
*version 2.10 Insert Bugfix
*
*
*Modify by: Chirag Sawjani (csawjni@itw-industry.com)
*date 17.01.2012
*version 2.11 Translation Bugfix
*
*Modify by: Chirag Sawjani (csawjni@itw-industry.com)
*date 06.02.2013
*version 2.12 Added hatch to beams and sheets
*
*Modify by: Chirag Sawjani (csawjni@itw-industry.com)
*date 29.01.2015
*version 2.14 Added more wall type filters

*Modify by: Mihai Bercuci (mihai.bercuci@hsbcad.com)
*date 08.11.2017
*version 2.15 Make draw outline have an option for specifying colours for outline and hatch separately
*/

Unit(1,"mm"); // script uses mm

String categories[] = 
{
	T("|General|"),
	T("|External Walls|"),
	T("|Party Walls|"),
	T("|Bearing Walls|"),
	T("|Internal Walls|"),
	T("|Other walls|")
};

String sArHatch[0];
sArHatch.append("None");
sArHatch.append(_HatchPatterns);

String sArYesNo[] = {T("No"), T("Yes")};

PropString sDispRep(0, "", T("Show in Disp Rep"));   		sDispRep.setCategory(categories[0]);
PropString sLineType(1, _LineTypes, T("Line Type")); 		sLineType.setCategory(categories[0]);
String sModes[]={T("Walls"), T("Beams"), T("Floors"), T("Sheets")}; 
PropString sMode(2, sModes, T("Enter the required mode")); 		sMode.setCategory(categories[0]);

PropString strDimOpCummulative (16, sArYesNo, T("Show Cummulative Opening Dimension"), 0);  		strDimOpCummulative.setCategory(categories[0]);
int nDimOpCummulative = sArYesNo.find(strDimOpCummulative, 0);


////////////////////////////
PropString psExtType(3, "A;B;",  T("Code External Walls"));				psExtType.setCategory(categories[1]);
psExtType.setDescription(T("Please type the codes of the external walls separate by ; "));		
PropString sHatchExt(4, sArHatch, T("Hatch for External Walls")); 		sHatchExt.setCategory(categories[1]);
PropInt nColorExt(0, 1, T("Color External Walls"));						nColorExt.setCategory(categories[1]);
PropInt nColorHatchExternal(15, 1, T("Select the External Walls Hatch Color"));		nColorHatchExternal.setCategory(categories[1]);
///////////////////////////


///////////////////////////
PropString psPartyType(11, "",  T("Code Party Walls"));		psPartyType.setCategory(categories[2]);
psPartyType.setDescription(T("Please type the codes of the party walls separate by ; "));
PropString sHatchParty(12, sArHatch, T("Hatch for Party Walls"));		sHatchParty.setCategory(categories[2]);
PropInt nColorParty(3, 1, T("Color Party Walls"));			nColorParty.setCategory(categories[2]);
PropInt nColorHatchParty(17, 1, T("Select the  Party Walls Hatch Color"));		nColorHatchParty.setCategory(categories[2]);
//////////////////////////

/////////////////////////
PropString psLoadBearingType(13, "A;B;",  T("Code Load bearing Walls"));		psLoadBearingType.setCategory(categories[3]);
psLoadBearingType.setDescription(T("Please type the codes of the Load bearing walls separate by ; "));		 
PropString sHatchLoadBearing(14, sArHatch, T("Hatch for Load bearing wallsWalls"));		sHatchLoadBearing.setCategory(categories[3]);
PropInt nColorLoadBearing(4, 1, T("Color Load bearing wallsWalls"));		nColorLoadBearing.setCategory(categories[3]);
PropInt nColorHatchBearing(18, 1, T("Select the Bearing Walls Hatch Color"));		nColorHatchBearing.setCategory(categories[3]);
//////////////////////////

///////////////////////////
PropString psIntType(5, "D;E;",  T("Code Internal Walls"));		psIntType.setCategory(categories[4]);
psIntType.setDescription(T("Please type the codes of the internal walls separate by ; "));		 
PropString sHatchInt(6, sArHatch, T("Hatch for Internal Walls"));		sHatchInt.setCategory(categories[4]);
PropInt nColorInt(1, 2, T("Color Internal Walls"));		nColorInt.setCategory(categories[4]);
PropInt nColorHatchInternal(19, 1, T("Select the  Internal Walls Hatch Color"));		nColorHatchInternal.setCategory(categories[4]);
///////////////////////////

////////////////////////
PropString sHatch(7, sArHatch, T("Hatch for Others"));		sHatch.setCategory(categories[5]);
PropInt nColor(2, 3, T("Color other walls"));					nColor.setCategory(categories[5]);
PropInt nColorHatch(20, 1, T("Select the Hatch Color"));		nColorHatch.setCategory(categories[5]);	
///////////////////////

PropString sDimStyle(8, _DimStyles, T("Dim style"));

PropString sGrpNm1(9, "Ground Floor", T("House Level group name"));
sGrpNm1.setDescription("");

PropString sGrpNm2(10, "Wall Layout", T("Floor Level group name"));
sGrpNm2.setDescription("");



// Load the values from the catalog
if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();
}



int nMode=sModes.find(sMode, 0);

int nHatchExt=sArHatch.find(sHatchExt);
int nHatchParty=sArHatch.find(sHatchParty);
int nHatchLoadBearing=sArHatch.find(sHatchLoadBearing);
int nHatchInt=sArHatch.find(sHatchInt);
int nHatch=sArHatch.find(sHatch);

String sArrExtCode[0];
String sExtType=psExtType;
sExtType.trimLeft();
sExtType.trimRight();
sExtType=sExtType+";";
for (int i=0; i<sExtType.length(); i++)
{
	String str=sExtType.token(i);
	str.trimLeft();
	str.trimRight();
	str.makeUpper();
	if (str.length()>0)
		sArrExtCode.append(str);
}

String sArrPartyCode[0];
String sPartyType=psPartyType;
sPartyType.trimLeft();
sPartyType.trimRight();
sPartyType=sPartyType+";";
for (int i=0; i<sPartyType.length(); i++)
{
	String str=sPartyType.token(i);
	str.trimLeft();
	str.trimRight();
	str.makeUpper();
	if (str.length()>0)
		sArrPartyCode.append(str);
}

String sArrLoadBearingCode[0];
String sLoadBearingType=psLoadBearingType;
sLoadBearingType.trimLeft();
sLoadBearingType.trimRight();
sLoadBearingType=sLoadBearingType+";";
for (int i=0; i<sLoadBearingType.length(); i++)
{
	String str=sLoadBearingType.token(i);
	str.trimLeft();
	str.trimRight();
	str.makeUpper();
	if (str.length()>0)
		sArrLoadBearingCode.append(str);
}

String sArrIntCode[0];
String sIntType=psIntType;
sIntType.trimLeft();
sIntType.trimRight();
sIntType=sIntType+";";
for (int i=0; i<sIntType.length(); i++)
{
	String str=sIntType.token(i);
	str.trimLeft();
	str.trimRight();
	str.makeUpper();
	if (str.length()>0)
		sArrIntCode.append(str);
}



if(_bOnInsert)
{
	if (nMode==0) {	//Walls
		PrEntity ssE (T("Please select Walls"),ElementWall());
		if (ssE.go())
		{
 			Entity ents[0];
 			ents = ssE.set();
		
 			for (int i = 0; i < ents.length(); i++ )
			 {
 				Element el = (Element) ents[i];
				if (el.bIsValid()) {
 					_Element.append(el);
				}	
 			 }
		}
		if (_Element.length()==0) 
		{
			reportMessage("No valid object selected");
			eraseInstance();
			return;
		}
	}
	
	if (nMode==1) { // Beams
		PrEntity ssE(T("Please select Beams"),Beam());
		if (ssE.go())
		{
	 		Entity ents[0];
	 		ents = ssE.set();
		
	 		for (int i = 0; i < ents.length(); i++ )
			 {
	 			Beam el = (Beam) ents[i];
				if (el.bIsValid()) {
		 			_Beam.append(el);
				}
	 		 }
	 	}
		if (_Beam.length()==0) 
		{
			reportMessage("No valid object selected");
			eraseInstance();
			return;
		}
	}
	

	
	
	if (nMode==2) { //Floors
		PrEntity ssE(T("Please select Floors"),ElementRoof());
		if (ssE.go())
		{
 			Entity ents[0];
 			ents = ssE.set();
		
 			for (int i = 0; i < ents.length(); i++ )
			 {
 				Element el = (Element) ents[i];
				if (el.bIsValid()) {
 					_Element.append(el);
				}	
 			 }
			if (_Element.length()==0) 
			{
				reportMessage("No valid object selected");
				eraseInstance();
				return;
			}
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
		

		lstPropInt.append(nColorExt);
		lstPropInt.append(nColorInt);
		lstPropInt.append(nColor);
		lstPropInt.append(nColorParty);
		lstPropInt.append(nColorLoadBearing);
		lstPropInt.append(nColorHatch);
		lstPropInt.append(nColorHatchExternal);	
		lstPropInt.append(nColorHatch);	
		lstPropInt.append(nColorHatch);
				
		lstPropString.append(sDispRep);
		lstPropString.append(sLineType);
		lstPropString.append(sMode);
		lstPropString.append(psExtType);
		lstPropString.append(sHatchExt);
		lstPropString.append(psIntType);
		lstPropString.append(sHatchInt);
		lstPropString.append(sHatch);
		lstPropString.append(sDimStyle);
		lstPropString.append(sGrpNm1);
		lstPropString.append(sGrpNm2);
		lstPropString.append(psPartyType);
		lstPropString.append(sHatchParty);
		lstPropString.append(psLoadBearingType);		
		lstPropString.append(sHatchLoadBearing);		
		
		for (int i=0; i<_Element.length(); i++)
		{
			lstEnts.setLength(0);
			lstEnts.append(_Element[i]);
			tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString);
		}
		
		eraseInstance();
		return;
	}
	
	if (nMode==3) { // Sheets
		PrEntity ssE(T("Please select Sheets"),Sheet());
		if (ssE.go())
		{
	 		Entity ents[0];
	 		ents = ssE.set();
		
	 		for (int i = 0; i < ents.length(); i++ )
			 {
	 			Sheet el = (Sheet) ents[i];
				if (el.bIsValid()) {
		 			_Sheet.append(el);
				}
	 		 }
	 	}
		if (_Sheet.length()==0) 
		{
			reportMessage("No valid object selected");
			eraseInstance();
			return;
		}
	}
	

	return;
}




sMode.setReadOnly(TRUE);

Plane pn(_Pt0, _ZU);

int nElWallsChanged=false;
int nBeamsChanged=false;
int nSheetsChanged=false;
Display dp(nColor);
dp.lineType(sLineType);
dp.dimStyle(sDimStyle);

if (sDispRep!="")
	dp.showInDispRep(sDispRep);

Hatch hatchExt (sHatchExt, U(5));
Hatch hatchParty (sHatchParty, U(5));
Hatch hatchLoadBearing (sHatchLoadBearing, U(5));
Hatch hatchInt (sHatchInt, U(5));
Hatch hatch (sHatch, U(5));

if (nMode==0) { //Walls
	//Add Custom Commands
	String strAddElement = T("Add Elements");
	addRecalcTrigger(_kContext, strAddElement );
	if (_bOnRecalc && _kExecuteKey==strAddElement ) 
	{
		PrEntity ssE(T("Please select Elements"),ElementWall());
		  if (ssE.go())
		 {
		   	Element ents[0];
		   	ents = ssE.elementSet();
		   	for (int i = 0; i < ents.length(); i++ )
		   	{
		    		ElementWall el = (ElementWall) ents[i];
		    		_Element.append(el);
		    	}
			nElWallsChanged=true;
		}
	}
	String strRemoveElement = T("Remove Elements");
	addRecalcTrigger(_kContext, strRemoveElement );
	if (_bOnRecalc && _kExecuteKey==strRemoveElement ) 
	{
		PrEntity ssE(T("Please select Elements"),ElementWall());
		  if (ssE.go())
		 {
		   	Element ents[0];
		   	ents = ssE.elementSet();
		   	for (int i = 0; i < ents.length(); i++ )
		   	{
		    		ElementWall el = (ElementWall) ents[i];
		    		int nFound=_Element.find(el);
				if(nFound!=-1)
				{
					_Element.removeAt(nFound);
				}
		    	}
			nElWallsChanged=true;
		}
	}

	
	//Segregate Walls
	ElementWall eWalls[0];
	for (int i=0; i<_Element.length(); i++) {
		ElementWall ewTemp=(ElementWall) _Element[i];
		if (ewTemp.bIsValid()) {
			eWalls.append(ewTemp);
		} 
	}
	if (eWalls.length()>0)
	{
		Point3d ptVertices[0];

		Vector3d vecTranslate;
		int nTranslate=false;
		//Define bottom left point as origin
		if(_Map.hasPoint3d("Origin"))
		{
			Point3d ptOrigOld=_Map.getPoint3d("Origin");
			vecTranslate=_Pt0-ptOrigOld;
			vecTranslate=vecTranslate.projectVector(pn);
			nTranslate=true;
		}

		
		for (int i=0; i<eWalls.length(); i++)
		{
			ElementWall el=eWalls[i];
			CoordSys cs=el.coordSys();
			Vector3d vx=cs.vecX();
			Vector3d vy=cs.vecY();
			Vector3d vz=cs.vecZ();
//			_Pt0=el.ptOrg();
			Plane plnY(cs.ptOrg(), vy);
			PLine plOutWall=eWalls[i].plOutlineWall();
			ptVertices.append(plOutWall.vertexPoints(1));

			PlaneProfile ppEl(plOutWall);
			Opening opAll[]=eWalls[i].opening();
			for (int o=0; o<opAll.length(); o++)
			{
				PLine plOpShape=opAll[o].plShape();
				PlaneProfile ppOp (cs);
				ppOp.joinRing(plOpShape, FALSE);
				LineSeg ls=ppOp.extentInDir(vx);
				Point3d ptS=ls.ptStart();
				Point3d ptM=ls.ptMid();
				Point3d ptE=ls.ptEnd();
				ptS=ptS.projectPoint(plnY, 0);
				ptM=ptM.projectPoint(plnY, 0);
				ptE=ptE.projectPoint(plnY, 0);
				PLine plOp(vy);
				plOp.addVertex(ptS-vz*U(300));
				plOp.addVertex(ptE-vz*U(300));
				plOp.addVertex(ptE+vz*U(300));
				plOp.addVertex(ptS+vz*U(300));
				plOp.close();
				PlaneProfile ppOpTopView (plnY);
				ppOpTopView.joinRing(plOp, FALSE);
				
				ppOpTopView.intersectWith(ppEl);
				ppEl.subtractProfile(ppOpTopView);
				if(nTranslate)
				{
					ppOpTopView.transformBy(vecTranslate);
					ptM.transformBy(vecTranslate);
				}
				//
				double da=el.dBeamWidth();
				dp.color(4);
				if (opAll[o].openingType()==_kDoor)
					dp.draw("D", ptM-vz*el.dBeamWidth()*.5, vx, -vz, 0, 0);
				else if (opAll[o].openingType()==_kWindow)
					dp.draw("W", ptM-vz*el.dBeamWidth()*.5, vx, -vz, 0, 0);
				else
					dp.draw("O", ptM-vz*el.dBeamWidth()*.5, vx, -vz, 0, 0);

				dp.draw(ppOpTopView);
				
			}
			
			//Get point load TSL
			TslInst tslElement[]=el.tslInstAttached();
			for(int t=0;t<tslElement.length();t++)
			{
				TslInst tsl=tslElement[t];
				Map mpTSL=tsl.map();
				if(mpTSL.hasMap("mpPL"))
				{
					Map mpPLine=mpTSL.getMap("mpPL");
					PLine pl=mpPLine.getPLine("plPointLoad");
					Point3d ptAllVertex[]=pl.vertexPoints(true);
					Point3d ptCenterPline;
					ptCenterPline.setToAverage(ptAllVertex);
					//Collect the extreme point to dimension top, bottom, left and right
					Point3d ptMostLeft=ptCenterPline;
					Point3d ptMostRight=ptCenterPline;
					Point3d ptMostUp=ptCenterPline;
					Point3d ptMostDown=ptCenterPline;

					for (int i=0; i<ptAllVertex.length(); i++)
					{
						 Point3d pt=ptAllVertex[i];
						 if (vx.dotProduct(ptMostLeft-pt)>0)
						  ptMostLeft=pt;
						 if (vx.dotProduct(ptMostRight-pt)<0)
						  ptMostRight=pt;
						 if (vz.dotProduct(ptMostUp-pt)<0)
						  ptMostUp=pt;
						 if (vz.dotProduct(ptMostDown-pt)>0)
						  ptMostDown=pt;
					}
					
					Line lnVX(cs.ptOrg(),vx);
					Line lnVZ(cs.ptOrg(),-vz);
					Point3d ptVZOrd[]=lnVZ.orderPoints(ptAllVertex);
					Point3d ptVXOrd[]=lnVX.orderPoints(ptVZOrd);
					
					double dPlWidth=abs((vx.dotProduct(ptMostLeft-ptMostRight)));
					double dPlHeight=abs((vz.dotProduct(ptMostUp-ptMostDown)));
					PLine plCross1;
					PLine plCross2;
					if(ptVXOrd.length()>0)
					{
						plCross1=PLine(ptVXOrd[0],ptVXOrd[0]+(vx*dPlWidth)-(vz*dPlHeight));
						plCross2=PLine(ptVXOrd[0]-(vz*dPlHeight),ptVXOrd[0]+(vx*dPlWidth));
					}
					if(nTranslate)
					{
						pl.transformBy(vecTranslate);
						plCross1.transformBy(vecTranslate);
						plCross2.transformBy(vecTranslate);
					}
					dp.color(3);
					dp.draw(pl);
					dp.draw(plCross1);
					dp.draw(plCross2);
				}
			}
			if(nTranslate)
			{
				ppEl.transformBy(vecTranslate);
			}			
			String sCode = el.code();
			sCode.makeUpper();
			
			if( sArrExtCode.find(sCode) != -1 )
			{
				dp.color(nColorHatchExternal);
				if (nHatchExt!=0)
				{
					dp.draw(ppEl, hatchExt);
					dp.color(nColorExt);
					dp.draw(ppEl);
				}
				
			}
			else if( sArrPartyCode.find(sCode) != -1 )
			{
				dp.color(nColorHatchParty);
				if (nHatchParty!=0)
				{
					dp.draw(ppEl, hatchParty);
					dp.color(nColorParty);
					dp.draw(ppEl);
				}
				
			}
			else if( sArrLoadBearingCode.find(sCode) != -1 )
			{
				dp.color(nColorHatchBearing);
				if (nHatchLoadBearing!=0)
				{
					dp.draw(ppEl, hatchLoadBearing);
					dp.color(nColorLoadBearing);
					dp.draw(ppEl);
				}
				
			}
			else if( sArrIntCode.find(sCode) != -1 )
			{
				dp.color(nColorHatchInternal);
				if (nHatchInt!=0)
				{
					dp.draw(ppEl, hatchInt);
					dp.color(nColorInt);
					dp.draw(ppEl);
				}
			}
			else
			{
				dp.color(nColorHatch);
				if (nHatch!=0)
				{
					dp.draw(ppEl, hatch);
					dp.color(nColor);
					dp.draw(ppEl);
				}
			}
			dp.draw(ppEl);
			
		}

		//Sort Vertices by XW and YW
		Line lnXW(_PtW,_XW);
		Line lnYW(_PtW,_YW);
		Point3d ptVertexYOrd[]=lnYW.orderPoints(ptVertices);
		Point3d ptVertexXCOrd[]=lnXW.orderPoints(ptVertexYOrd);
		if(ptVertexYOrd.length()>0)
		{
			if(!(_Map.hasPoint3d("Origin")))
			{
				_Pt0=ptVertexYOrd[0];
				_Map.setPoint3d("Origin",ptVertexYOrd[0],_kAbsolute);
			}
			if(nTranslate)
			{				
				_Pt0=ptVertexYOrd[0];
				_Pt0.transformBy(vecTranslate);
				//_Map.setPoint3d("Origin",_Pt0,_kAbsolute);
				_Map.setPoint3d("Origin",ptVertexYOrd[0],_kAbsolute);
			}
			if(nElWallsChanged)
			{
				_Map.setPoint3d("Origin",ptVertexYOrd[0],_kAbsolute);
			}
		}
		
	}
	else {
		reportMessage( "No walls have been selected");
	}
}

//Segregate Beams 
if (nMode==1) { //Beams
	//Add Custom Commands
	String strAddBeam = T("Add Beams");
	addRecalcTrigger(_kContext, strAddBeam );
	if (_bOnRecalc && _kExecuteKey==strAddBeam ) 
	{
		PrEntity ssE(T("Please select Beams"),Beam());
		  if (ssE.go())
		 {
		   	Entity ents[0];
		   	ents = ssE.set();
		   	for (int i = 0; i < ents.length(); i++ )
		   	{
		    		Beam bm = (Beam) ents[i];
		    		_Beam.append(bm);
		    	}
			nBeamsChanged=true;
		}
	}
	String strRemoveBeam = T("Remove Beams");
	addRecalcTrigger(_kContext, strRemoveBeam );
	if (_bOnRecalc && _kExecuteKey==strRemoveBeam ) 
	{
		PrEntity ssE(T("Please select Beams"),Beam());
		  if (ssE.go())
		 {
		   	Entity ents[0];
		   	ents = ssE.set();
		   	for (int i = 0; i < ents.length(); i++ )
		   	{
		    		Beam bm = (Beam) ents[i];
		    		int nFound=_Beam.find(bm);
				if(nFound!=-1)
				{
					_Beam.removeAt(nFound);
				}
				nBeamsChanged=true;
		    	}
		}
	}

	Point3d ptVertices[0];
	Vector3d vecTranslate;
	int nTranslate=false;
	//Define bottom left point as origin
	if(_Map.hasPoint3d("Origin"))
	{
		Point3d ptOrigOld=_Map.getPoint3d("Origin");
		vecTranslate=_Pt0-ptOrigOld;
		vecTranslate=vecTranslate.projectVector(pn);
		nTranslate=true;
	}
	

	if (_Beam.length()>0) {
		for (int i=0; i<_Beam.length(); i++) {
			Body bdBeams;
			Beam bm=_Beam[i];
			bdBeams=bm.realBody();		
			PlaneProfile ppBeams=bdBeams.shadowProfile(pn);
			PLine plRings[]=ppBeams.allRings();
			for(int r=0;r<plRings.length();r++)
			{
				ptVertices.append(plRings[r].vertexPoints(1));
			}
			if(nTranslate)
			{
				ppBeams.transformBy(vecTranslate);
			}

			if(nHatch>0)
			{
				dp.draw(ppBeams,hatch);
			}
			dp.draw(ppBeams);				
		}
		//Sort Vertices by XW and YW
		Line lnXW(_PtW,_XW);
		Line lnYW(_PtW,_YW);
		Point3d ptVertexYOrd[]=lnYW.orderPoints(ptVertices);
		Point3d ptVertexXOrd[]=lnXW.orderPoints(ptVertexYOrd);
		if(ptVertexYOrd.length()>0)
		{
			if(!(_Map.hasPoint3d("Origin")))
			{
				_Pt0=ptVertexYOrd[0];
				_Map.setPoint3d("Origin",ptVertexYOrd[0],_kAbsolute);
			}
			if(nTranslate)
			{				
				_Pt0=ptVertexYOrd[0];
				_Pt0.transformBy(vecTranslate);
				//_Map.setPoint3d("Origin",_Pt0,_kAbsolute);
				_Map.setPoint3d("Origin",ptVertexYOrd[0],_kAbsolute);
			}
			if(nBeamsChanged)
			{
				_Map.setPoint3d("Origin",ptVertexYOrd[0],_kAbsolute);
			}
		}
	}
	else {
		reportMessage ("No Beams have been selected");
	}
}

//Floor
if (nMode==2)
{
	Element el=_Element[0];
	Beam bmElement[]=el.beam();
	Sheet shElement[]=el.sheet();
	
	if(bmElement.length()==0 && shElement.length()==0) 
	{
		eraseInstance();
		return;
	}
	CoordSys cs=el.coordSys();
	
	Vector3d vecTranslate;
	int nTranslate=false;
	//Define bottom left point as origin
	if(_Map.hasPoint3d("Origin"))
	{
		Point3d ptOrigOld=_Map.getPoint3d("Origin");
		vecTranslate=_Pt0-ptOrigOld;
		nTranslate=true;
	}
	
	Body bdFloor;
	//Collect all bodies and add to bdFloor
	if (bmElement.length()>0) {
		for (int i=0; i<bmElement.length(); i++) {
			bdFloor=bdFloor+bmElement[i].realBody();
		}
	}
	if (shElement.length()>0) {
		for (int i=0; i<shElement.length(); i++) {
			bdFloor=bdFloor+shElement[i].realBody();
		}
	}
	LineSeg ls[]=bdFloor.hideDisplay(cs, FALSE, FALSE, TRUE);
	LineSeg lsTransform[0];
	if(nTranslate)
	{
		for(int l=0;l<ls.length();l++)
		{
			ls[l].transformBy(vecTranslate);
		}
	}
	dp.draw(ls);
	String sElement=el.number();
	//Find extremes of line segment
	//---//
	//Collect all points from line segments
	Point3d ptLn[0];
	if (ls.length()>0) {
		for (int i=0; i<ls.length(); i++) {
			ptLn.append(ls[i].ptStart());
			ptLn.append(ls[i].ptEnd());
		}
	}
	
	double dXMinimum;
	double dXMaximum;
	double dYMinimum;
	double dYMaximum;
	double dZMaximum;
	for (int i=0; i<ptLn.length(); i++) {
		double dCurrX=ptLn[i].X();
		double dCurrY=ptLn[i].Y();
		double dCurrZ=ptLn[i].Z();
		if (i==0) {dXMinimum=dCurrX;}
		if (dCurrX<dXMinimum) {dXMinimum=dCurrX;}
		if (i==0) {dXMaximum=dCurrX;}
		if (dCurrX>dXMaximum) {dXMaximum=dCurrX;}
		
		if (i==0) {dYMinimum=dCurrY;}
		if (dCurrY<dYMinimum) {dYMinimum=dCurrY;}
		if (i==0) {dYMaximum=dCurrY;}
		if (dCurrY>dYMaximum) {dYMaximum=dCurrY;}
		
		
		if (i==0) {dZMaximum=dCurrZ;}
		if (dCurrZ>dZMaximum) {dZMaximum=dCurrZ;}
		
	}
	
	Point3d ptTL(dXMinimum, dYMaximum, dZMaximum) ;
	Point3d ptTR(dXMaximum, dYMaximum, dZMaximum);
	Point3d ptBL(dXMinimum, dYMinimum, dZMaximum);
	Point3d ptBR(dXMaximum, dYMinimum, dZMaximum);
	
	ptTL.vis();
	ptTR.vis();
	ptBL.vis();
	ptBR.vis();
	Point3d ptArray[]={ptTL,ptTR,ptBL,ptBR};
	Point3d ptIntersection;
	
	if (_Map.getMapKey()=="") {
		ptIntersection.setToAverage(ptArray);
		_PtG.append(ptIntersection);
		dp.draw(sElement, ptIntersection, _XW, _YW, 0, 0);
		_Map.setMapKey("Ran Once");
	}
	else {
		ptIntersection=_PtG[0];
		dp.draw(sElement, ptIntersection, _XW, _YW, 0, 0);
	}
	
	if(!(_Map.hasPoint3d("Origin")))
	{
		_Pt0=ptBL;
		_Map.setPoint3d("Origin",ptBL,_kAbsolute);
	}
}


if (sGrpNm1!="" && sGrpNm2!="")
{
	Group grpSolePlate(sGrpNm1 + "\\" + sGrpNm2);
	grpSolePlate.setBIsDeliverableContainer(FALSE);
	grpSolePlate.addEntity(_ThisInst, FALSE);
}


//Segregate Sheets 
if (nMode==3) { //Sheets
	//Add Custom Commands
	String strAddBeam = T("Add Sheets");
	addRecalcTrigger(_kContext, strAddBeam );
	if (_bOnRecalc && _kExecuteKey==strAddBeam ) 
	{
		PrEntity ssE(T("Please select Sheets"),Sheet());
		  if (ssE.go())
		 {
		   	Entity ents[0];
		   	ents = ssE.set();
		   	for (int i = 0; i < ents.length(); i++ )
		   	{
		    		Sheet sh = (Sheet) ents[i];
		    		_Sheet.append(sh);
		    	}
			nSheetsChanged=true;
		}
	}
	String strRemoveBeam = T("Remove Sheets");
	addRecalcTrigger(_kContext, strRemoveBeam );
	if (_bOnRecalc && _kExecuteKey==strRemoveBeam ) 
	{
		PrEntity ssE(T("Please select Sheets"),Sheet());
		  if (ssE.go())
		 {
		   	Entity ents[0];
		   	ents = ssE.set();
		   	for (int i = 0; i < ents.length(); i++ )
		   	{
		    		Sheet sh = (Sheet) ents[i];
		    		int nFound=_Sheet.find(sh);
				if(nFound!=-1)
				{
					_Sheet.removeAt(nFound);
				}
				nSheetsChanged=true;
		    	}
		}
	}

	Point3d ptVertices[0];

	Vector3d vecTranslate;
	int nTranslate=false;
	//Define bottom left point as origin
	if(_Map.hasPoint3d("Origin"))
	{
		Point3d ptOrigOld=_Map.getPoint3d("Origin");
		vecTranslate=_Pt0-ptOrigOld;
		vecTranslate=vecTranslate.projectVector(pn);
		nTranslate=true;
	}
	

	if (_Sheet.length()>0) {
		for (int i=0; i<_Sheet.length(); i++) {
			Body bdSheets;
			Sheet sh=_Sheet[i];
			bdSheets=sh.realBody();		
			PlaneProfile ppSheets=bdSheets.shadowProfile(pn);
			PLine plRings[]=ppSheets.allRings();
			for(int r=0;r<plRings.length();r++)
			{
				ptVertices.append(plRings[r].vertexPoints(1));
			}
			if(nTranslate)
			{
				ppSheets.transformBy(vecTranslate);
			}
			
			if(nHatch>0)
			{
				dp.draw(ppSheets,hatch);
			}

			dp.draw(ppSheets);				
		}
		//Sort Vertices by XW and YW
		Line lnXW(_PtW,_XW);
		Line lnYW(_PtW,_YW);
		Point3d ptVertexYOrd[]=lnYW.orderPoints(ptVertices);
		Point3d ptVertexXOrd[]=lnXW.orderPoints(ptVertexYOrd);
		if(ptVertexYOrd.length()>0)
		{
			if(!(_Map.hasPoint3d("Origin")))
			{
				_Pt0=ptVertexYOrd[0];
				_Map.setPoint3d("Origin",ptVertexYOrd[0],_kAbsolute);
			}
			if(nTranslate)
			{
				_Pt0=ptVertexYOrd[0];
				_Pt0.transformBy(vecTranslate);
				_Map.setPoint3d("Origin",ptVertexYOrd[0],_kAbsolute);
				//_Map.setPoint3d("Origin",_Pt0,_kAbsolute);

			}
			if(nSheetsChanged)
			{

				_Map.setPoint3d("Origin",ptVertexYOrd[0],_kAbsolute);
			}
		}
	}
	else {
		reportMessage ("No Sheets have been selected");
	}
}






#End
#BeginThumbnail
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
4H`****`"BBB@`HHHH`****`/_]DH
`





















#End