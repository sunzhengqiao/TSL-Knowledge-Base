#Version 8
#BeginDescription
This tsl creates a freedrill on a set of genbeams

#Versions
Version 1.0 02.06.2023 HSB-19105 initial version of free drill tool , Author Thorsten Huck
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.0 02.06.2023 HSB-19105 initial version of free drill tool , Author Thorsten Huck

/// <insert Lang=en>
/// Select entities genbeams and start and end point
/// </insert>

// <summary Lang=en>
// This tsl creates a freedrill on a set of genbeams
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "FreeDrill")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Genbeams|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Genbeams|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Adjust closest grip|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Adjust grip 1|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Adjust grip 2|") (_TM "|Select Tool|"))) TSLCONTENT
//endregion


//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	String tDefault =T("|_Default|");
	String tLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
//region Color and view	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	
	int lightblue = rgb(204,204,255);
	int blue = rgb(69,84,185);	
	int darkblue = rgb(26,50,137);	
	int yellow = rgb(241,235,31);
	int darkyellow = rgb(254, 204, 102);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);	

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
//endregion 	
	
//end Constants//endregion

//region Properties
	String sDiameterName=T("|Diameter|");	
	PropDouble dDiameter(nDoubleIndex++, U(10), sDiameterName);	
	dDiameter.setDescription(T("|Defines the Diameter|"));
	dDiameter.setCategory(category);

category = T("|Sinkhole| 1");
	String sDiameter1Name=T("|Diameter| ");	
	PropDouble dDiameter1(nDoubleIndex++, U(0), sDiameter1Name);	
	dDiameter1.setDescription(T("|Defines the diameter of a sinkhole at start|"));
	dDiameter1.setCategory(category);
	
	String sDepth1Name=T("|Depth|");	
	PropDouble dDepth1(nDoubleIndex++, U(0), sDepth1Name);	
	dDepth1.setDescription(T("|Defines the depth of a sinkhole at start|"));
	dDepth1.setCategory(category);
	
category = T("|Sinkhole| 2");
	String sDiameter2Name=T("|Diameter|  ");	
	PropDouble dDiameter2(nDoubleIndex++, U(0), sDiameter2Name);	
	dDiameter2.setDescription(T("|Defines the diameter of a sinkhole at end|"));
	dDiameter2.setCategory(category);
	
	String sDepth2Name=T("|Depth| ");	
	PropDouble dDepth2(nDoubleIndex++, U(0), sDepth2Name);	
	dDepth2.setDescription(T("|Defines the depth of a sinkhole at end|"));
	dDepth2.setCategory(category);	
		
//End Properties//endregion 




//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();


	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select genbeams|"), GenBeam());
		if (ssE.go())
			ents.append(ssE.set());
		
		for (int i=0;i<ents.length();i++) 
			_GenBeam.append((GenBeam)ents[i]); 


		Point3d pt2, pt1 = getPoint();
		
	// prompt for second point input
		PrPoint ssP(TN("|Select point|"),pt1); 
		if (ssP.go()==_kOk) 
			pt2 = ssP.value(); // append the selected points to the list of grippoints _PtG
			
		
		_Pt0 = (pt2 + pt1) * .5;
		_PtG.append(pt1);
		_PtG.append(pt2);

		return;
	}			
//endregion


//region Standards
	if (_GenBeam.length()<1 || dDiameter<dEps)
	{ 
		eraseInstance();
		return;
	}
	
	GenBeam gb = _GenBeam[0];
	Element el = gb.element();
	
	setKeepReferenceToGenBeamDuringCopy(true);
	
	if (el.bIsValid())
	{ 
		assignToElementGroup(el, true, gb.myZoneIndex(), 'T');
	}
	else
		assignToGroups(gb, 'T');
	if (_kNameLastChangedProp!="_Pt0")
		_Pt0.setToAverage(_PtG);
	
	Point3d pt1 = _PtG[0];
	Point3d pt2 = _PtG[1];
	Vector3d vecX = pt2 - pt1;
	vecX.normalize();
	
	vecX.vis(_Pt0, 1);
	Line lnX(_Pt0, vecX);
	
//endregion 

//region Check if drill doesn't start and end within solid
	int bIsInside;
	for (int i=0;i<_GenBeam.length();i++) 
	{ 
		//GenBeam& b = _GenBeam[i]; 
		Body bd = _GenBeam[i].envelopeBody(false, true);
		Point3d ptsX[] = lnX.orderPoints(bd.intersectPoints(lnX), dEps);
		
		if (ptsX.length()>1)
		{ 
			double d1 = vecX.dotProduct(_PtG[0]-ptsX.first());
			double d2 = vecX.dotProduct(ptsX.last()-_PtG[1]);
			
			if (d1>dEps && d2>dEps)
			{
				ptsX.first().vis(2);_PtG[0].vis(1);
				ptsX.last().vis(4);;_PtG[1].vis(3);
				bIsInside = true;
				break;
			}	
		}		
	}//next i

//endregion 

//region tooling
	int bHasSink1 = dDepth1 > dEps && dDiameter1 > dEps && dDiameter < dDiameter1;
	int bHasSink2 = dDepth2 > dEps && dDiameter2 > dEps && dDiameter < dDiameter2;
	
	
	Display dp(9);
	dp.textHeight(dDiameter*.5);
	if (bIsInside)
	{ 
		dp.trueColor(red,10);
		_ThisInst.setColor(1);
		//dp.draw(T("|Invalid Start or End Point|"), _Pt0, _XW, _YW, 0, 0, _kDevice);
	}
	else
	{ 
		Drill dr(pt1,pt2, dDiameter*.5);
		if (_ThisInst.color()==1)
			_ThisInst.setColor(-1);	
		dr.addMeToGenBeamsIntersect(_GenBeam);	
		
	// Sink 1
		if (bHasSink1)
		{ 
			Drill sink(_PtG[0], _PtG[0] + vecX * dDepth1, dDiameter1 * .5);
			sink.addMeToGenBeamsIntersect(_GenBeam);
		}
	// Sink 2
		if (bHasSink2)
		{ 
			Drill sink(_PtG[1], _PtG[1] - vecX * dDepth2, dDiameter2 * .5);
			sink.addMeToGenBeamsIntersect(_GenBeam);
		}		
	}
	
	PLine c; c.createCircle(pt1, vecX, (bHasSink1?dDiameter1:dDiameter) * .5);
	c.convertToLineApprox(dEps);
	PlaneProfile ppc(c);
	dp.draw(ppc);
	if (bIsInside)dp.draw(ppc,_kDrawFilled);
	dp.draw(PLine(pt1, pt2));
	
	c.createCircle(pt2, vecX, (bHasSink2?dDiameter2:dDiameter) * .5);
	c.convertToLineApprox(dEps);
	ppc = PlaneProfile(c);
	dp.draw(ppc);
	if (bIsInside)
	{
		dp.draw(ppc,_kDrawFilled);
		dp.color(255);
		dp.draw("1", _PtG[0], _XW, _YW, 0, 0, _kDeviceX);
		dp.draw("2", _PtG[1], _XW, _YW, 0, 0, _kDeviceX);
		
	}
	
//endregion 


//region Trigger AddBeams
	String sTriggerAddBeams = T("|Add Genbeams|");
	addRecalcTrigger(_kContextRoot, sTriggerAddBeams );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddBeams)
	{
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select genbeams|"), GenBeam());
		if (ssE.go())
			ents.append(ssE.set());
		
		for (int i=0;i<ents.length();i++) 
			_GenBeam.append((GenBeam)ents[i]); 


		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger RemoveBeams
	String sTriggerRemoveBeams = T("|Remove Genbeams|");
	addRecalcTrigger(_kContextRoot, sTriggerRemoveBeams );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveBeams)
	{
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select genbeams|"), GenBeam());
		if (ssE.go())
			ents.append(ssE.set());
		
		for (int i=_GenBeam.length()-1; i>=0 ; i--) 
		{ 
			int n = ents.find(_GenBeam[i]);
			if (n>-1)
				_GenBeam.removeAt(n);
	
		}//next i
		
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger AutoAdjust
	String sTriggerAutoAdjust = T("|Adjust closest grip|");
	if (bIsInside)addRecalcTrigger(_kContextRoot, sTriggerAutoAdjust );
	if (_bOnRecalc && _kExecuteKey==sTriggerAutoAdjust)
	{
		Point3d ptsX[0];
		for (int i=0;i<_GenBeam.length();i++) 
		{ 
			Body bd = _GenBeam[i].envelopeBody(false, true);
			ptsX.append(lnX.orderPoints(bd.intersectPoints(lnX), dEps));		
		}//next i


		if (ptsX.length()>1)
		{ 
			double d1 = vecX.dotProduct(_PtG[0]-ptsX.first());
			double d2 = vecX.dotProduct(ptsX.last()-_PtG[1]);
			
			if (d1<d2)
				_PtG[0] -= vecX * d1;
			else
				_PtG[1] += vecX * d2;				
		}
		setExecutionLoops(2);
		return;
	}
	
	String sTriggerAdjust1 = T("|Adjust grip 1|");
	if (bIsInside)addRecalcTrigger(_kContextRoot, sTriggerAdjust1 );
	if (_bOnRecalc && _kExecuteKey==sTriggerAdjust1)
	{
		Point3d ptsX[0];
		for (int i=0;i<_GenBeam.length();i++) 
		{ 
			Body bd = _GenBeam[i].envelopeBody(false, true);
			ptsX.append(lnX.orderPoints(bd.intersectPoints(lnX), dEps));		
		}//next i


		if (ptsX.length()>1)
		{ 
			double d = vecX.dotProduct(_PtG[0]-ptsX.first());
			_PtG[0] -= vecX * d;				
		}
		setExecutionLoops(2);
		return;
	}

	String sTriggerAdjust2 = T("|Adjust grip 2|");
	if (bIsInside)addRecalcTrigger(_kContextRoot, sTriggerAdjust2 );
	if (_bOnRecalc && _kExecuteKey==sTriggerAdjust2)
	{
		Point3d ptsX[0];
		for (int i=0;i<_GenBeam.length();i++) 
		{ 
			Body bd = _GenBeam[i].envelopeBody(false, true);
			ptsX.append(lnX.orderPoints(bd.intersectPoints(lnX), dEps));		
		}//next i


		if (ptsX.length()>1)
		{ 
			double d = vecX.dotProduct(ptsX.last() - _PtG[1]);
			_PtG[1] += vecX * d;				
		}
		setExecutionLoops(2);
		return;
	}

//endregion	


#End
#BeginThumbnail
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
;#!815<;_![_:$K#EXM1B`````$E%3D2N0F""

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
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-19105 initial version of free drill tool" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="6/2/2023 10:12:43 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End