#Version 8
#BeginDescription
version value="1.1" date="10apr14" author="th@hsbCAD.de"
bugfix of published orientation

/// This TSL specifies a detail section. A Detail will always be seen towards the outer grip of the section.
/// If both grips are not outside the panel the grip which is closer to the panel profile will determine the direction

/// Select a panel amd two points on the section line.

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This TSL specifies a detail section. A Detail will always be seen towards the outer grip of the section.
/// If both grips are not outside the panel the grip which is closer to the panel profile will determine the direction
/// </summary>

/// <insert Lang=en>
/// Select a panel amd two points on the section line.
/// </insert>

/// History
///<version value="1.1" date="10apr14" author="th@hsbCAD.de"> bugfix of published orientation</version>
///<version value="1.0" date="04apr14" author="th@hsbCAD.de"> initial</version>

// basics and props
	U(1,"mm");	
	double dEps =U(.1);
	String sArNY[] = {T("|No|"), T("|Yes|")};
	String sViewNumberName = T("|View Number|");
	PropString sViewNumber(1, "A", sViewNumberName);	
	sViewNumber.setDescription(T("|Defines the view number. Enter a character for alphanumeric or a number to create numeric detail numbers|"));
	PropString sFullRange(3,sArNY,T("|Section Full Range|"));
	sFullRange.setDescription(T("|Defines if the detail view is based on an infinte intersection with the panel or if it will take only the range between the grips.|"));
	PropDouble dTxtH(6,1,T("|Text Height|"));
	dTxtH.setDescription(T("|Defines the text height and scaling of the symbol|"));
	PropString sDimStyle(0,_DimStyles,T("|Dimstyle|"));
	PropString sLineType(2, _LineTypes, T("|Line Type|"));	
	sLineType.setDescription(T("|Defines the linetype of the section line|"));		
	PropInt nColor (0,145,T("Color"));
				
// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		// show the dialog if no catalog in use
		if (_kExecuteKey == "")
			showDialog();			
		else
			// set properties from catalog
			setPropValuesFromCatalog(_kExecuteKey);
		
		_Sip.append(getSip());
			
		_PtG.append(getPoint(T("|Select first point of section line|")));	
		PrPoint ssP("\n" + T("|Select second point of section line|"),_PtG[0]); 
		Point3d pts[0];
		if (ssP.go()==_kOk) 
			_PtG.append(ssP.value()); // retrieve the selected point

		_Pt0.setToAverage(_PtG);
		return;
	}
	
// the sip and declare standard vectors
	if (_Sip.length()<1)
	{
		eraseInstance();
		return;	
	}	

	Sip sip;
	Vector3d vx,vy,vz;

	sip = _Sip[0];
	//assignToGroups(sip);
	vx=sip .vecX();
	vy=sip .vecY();
	vz=sip .vecZ();		
	Point3d ptCen = sip.ptCen();
	setEraseAndCopyWithBeams(_kBeam0);		

// limit detail number to one digit
	if (sViewNumber.length()>1)
	{
		sViewNumber.set(sViewNumber.left(1));
		reportMessage("\n"+ scriptName() +": " + T("|The view number may have only one character.|"));	
	}

// ints
	int bFullRange=sArNY.find(sFullRange);

// on event dragging grips relocate _Pt0
	for (int i=0;i<_PtG.length();i++)
		if (_kNameLastChangedProp == "_PtG" + i)
		{
			_Pt0.setToAverage(_PtG);
			_ThisInst.recalc();	
		}
	
// realign	
	_Pt0 = _Pt0-vz*vz.dotProduct(_Pt0-ptCen);
	for (int i=0;i<_PtG.length();i++)
		_PtG[i].transformBy(vz*vz.dotProduct(ptCen-_PtG[i]));

// on creation and the event of changing the view number loop potential other instances to verify view number
	if (_bOnDbCreated || _kNameLastChangedProp==sViewNumberName)
	{
	// collect all attached tsl's
		TslInst tsls[0];
		Group groups[] = sip.groups();
		int nGroupLoop = groups.length();
		if (nGroupLoop<1)nGroupLoop=1;
		// always loop at least once
		for ( int i = 0; i < nGroupLoop; i++)
		{
			Entity entTsl[0];
		// if the sip is assigned to a group limit the search to the sip groups	
			if (groups.length()>0) entTsl= groups[i].collectEntities( 0, TslInst(), _kModelSpace);
		// else search entire dwg	
			else entTsl= Group().collectEntities( 0, TslInst(), _kModelSpace);
			for ( int j= 0; j< entTsl.length(); j++)
			{
				TslInst tsl= (TslInst)entTsl[j];
				String s = tsl.scriptName();
				if ((scriptName()=="__HSB__PREVIEW" && tsl.scriptName()!="hsbCLT-Detail") || (tsl==_ThisInst || tsl.scriptName()!=scriptName() && scriptName()!="__HSB__PREVIEW"))
				{
					 continue;
				}
				if (groups.length()<1 && tsl.genBeam().find(sip)<0)continue;
				tsls.append(tsl);
			}
		}
	
	// check if view number is numeric
		int bIsNumeric = sViewNumber.atoi()!=0;
		
		String sNumbers[] = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
		if (bIsNumeric)
		{
			sNumbers.setLength(0);
			for (int i=0;i<26;i++)
				sNumbers.append((i+1));		
		}
		String sViewNumbers[0];
		for ( int i = 0; i < tsls.length(); i++)
			sViewNumbers.append(tsls[i].propString(1));
			
	// assign a new view number		
		if (sViewNumbers.find(sViewNumber)>-1)
		{
			for ( int i = 0; i < sNumbers.length(); i++)
			{
				String sNewNumber = sNumbers[i];
				if (sViewNumbers.find(sNewNumber)<0)
				{
					sViewNumber.set(sNumbers[i]);
					reportMessage("\n" + T("|The view number has been changed to|")+ " " +sViewNumber);
					break;
				}	
			}		
		}

	}// view number approval

// the section coordSys
	Vector3d vxS,vyS,vzS;
	vyS = _PtG[1]-_PtG[0];
	vyS.normalize();
	vxS = -vz;
	vzS=vxS.crossProduct(vyS);

// add flip sidetrigger
	int bFlip = _Map.getInt("flip");
	String sTriggerFlip=T("|Flip Direction|");
	addRecalcTrigger(_kContext, sTriggerFlip);
	if (_bOnRecalc && _kExecuteKey==sTriggerFlip) 
	{
		if (bFlip)bFlip=false;
		else bFlip=true;
		_Map.setInt("flip",bFlip);
	}
	if (bFlip)
	{
		vxS*=-1;
		vzS*=-1;	
	}
	
// get sip profile
	PlaneProfile ppSip(CoordSys(ptCen, vx,vy,vz));
	ppSip.joinRing(sip.plEnvelope(),_kAdd);
	PLine plOpenings[] = sip.plOpenings();
	for(int i=0;i<plOpenings.length();i++)
		ppSip.joinRing(plOpenings[i],_kSubtract);
		

// collect grips inside profile
	int bOutsides[]={ppSip.pointInProfile(_PtG[0])==_kPointOutsideProfile,ppSip.pointInProfile(_PtG[1])==_kPointOutsideProfile};


// use the grip location to identify the vecDir (upper direction of the detail
	Point3d ptDir[0];
	ptDir = _PtG;
	// if one is in and the other is out swap
	if (bOutsides[0] && !bOutsides[1])
	{
		ptDir.swap(0,1);
	}
	else if (bOutsides[1] && !bOutsides[0])
	{
		;
	}
	// else tak ethe closest to the profile
	else
	{
		double dG1 = Vector3d(_PtG[0]-ppSip.closestPointTo(_PtG[0])).length();
		double dG2 = Vector3d(_PtG[1]-ppSip.closestPointTo(_PtG[1])).length();
		if (dG1>dG2)ptDir.swap(0,1);		
	}
	Vector3d vecDir = ptDir[1]-ptDir[0]; vecDir.normalize();	
	vecDir.vis(_PtG[1],5);
	if (vyS.dotProduct(vecDir)<0)
	{
		vyS*=-1;
		vxS*=-1;	
	}

	
	
// publish the section coordSys
	Vector3d vxShop=vxS, vyShop=vyS, vzShop=vzS;
	if (0 && ppSip.pointInProfile(_PtG[0])==_kPointOutsideProfile)
	{
		vxShop*=-1;
		vyShop*=-1;
		
	}
	_Map.setVector3d("vxS",vxShop);
	_Map.setVector3d("vyS",vyShop);
	_Map.setVector3d("vzS",vzShop);
	_Map.setPoint3d("ptOrg",_PtG[0]);
		
		
// the display
	Display dp(nColor);
	dp.dimStyle(sDimStyle);
	dp.textHeight(dTxtH);
	//dp.draw(scriptName(),_Pt0,vx,vy,1,0);	


	// section debug body
	vxS.vis(_Pt0,1);
	vyS.vis(_Pt0,2);
	vzS.vis(_Pt0,150);	

	vy.vis(_Pt0,20);
	
	_ThisInst.coordSys().vecX().vis(_PtG[0],1);
	//_ThisInst.coordSys().vecY().vis(_PtG[0],3);
	//_ThisInst.coordSys().vecZ().vis(_PtG[0],150);	
	
// reading vectors seen in sip view
	Vector3d vxRead = vyS;
	Vector3d vyRead = vzS;

	/*
	// plan
	if (vz.isPerpendicularTo(_ZW))
	{
		if (vxRead.dotProduct(_ZW)<0) 
		{
			vxRead*=-1;
			vyRead*=-1;
		}
		else if (vyRead.dotProduct(_ZW)<0) 
		{
			vxRead*=-1;
			vyRead*=-1;
		}

	}
	else if (vxS.dotProduct(vz)<0)
	{
		//vxRead*=-1;
		vyRead*=-1;
	}
	*/


// display section body in detail display 
	double dL =Vector3d(_PtG[1]-_PtG[0]).length();
	if (bFullRange)dL = U(50000);
	Body bd(_Pt0,vxS,vyS,vzS, U(1000), dL, U(100), 0,0,-1);
	bd.intersectWith(sip.realBody());
	Display dpDetail(1);
	dpDetail.showInDispRep("Detail");
	dpDetail.draw(bd);	
	bd.vis(2);
	//dp.draw(bd);

		
// symbol	
	double dTxtL=  dTxtH;//dp.textLengthForStyle(sViewNumber ,sDimStyle)*2;
	double dW = sqrt(2*pow(dTxtL*1.05,2));
	Point3d pt = _PtG[0]+vzS*dW;//pt.vis(2);
	// createposnum mask
	PLine plPosNum(vyS);
	plPosNum.createCircle(pt,vxS,dTxtL);

	PLine plArrow(vxS);		
	plArrow.addVertex(pt - vyS*dW); 	
	plArrow.addVertex(pt - vzS*dW); 
	plArrow.addVertex(pt + vyS*dW); 
	plArrow.addVertex(pt + vyS*(dTxtL));
	plArrow.addVertex(pt - vyS*(dTxtL),pt-vzS*(dTxtL));				
	plArrow.close();		

// second grip transformation
	Vector3d vxTrans = _PtG[1]-_PtG[0];

// declare dim request map
	Map mapRequest,mapRequests;
	mapRequest.setInt("Color", nColor);
	mapRequest.setVector3d("AllowedView", vxS);

// section line
	dp.lineType(sLineType);
	PLine plSection(_PtG[0],_PtG[1]);
	dp.draw(plSection);	
	mapRequest.setPLine("pline", plSection);	
	mapRequest.setString("lineType", sLineType);	
	mapRequests.appendMap("DimRequest",mapRequest);	
	mapRequest.removeAt("lineType",true);

// circle
	dp.draw(plPosNum);		
	mapRequest.setPoint3d("ptScale", _PtG[0]);	
	mapRequest.setPLine("pline", plPosNum);
	mapRequests.appendMap("DimRequest",mapRequest);	
	
	plPosNum.transformBy(vxTrans);	
	dp.draw(plPosNum);		
	mapRequest.setPoint3d("ptScale", _PtG[1]);	
	mapRequest.setPLine("pline", plPosNum);	
	mapRequests.appendMap("DimRequest",mapRequest);	

	
// arrow	
	dp.draw(PlaneProfile(plArrow),_kDrawFilled);
	mapRequest.setPoint3d("ptScale", _PtG[0]);	
	mapRequest.setPLine("pline", plArrow);
	mapRequest.setInt("DrawFilled", _kDrawFilled);
	mapRequests.appendMap("DimRequest",mapRequest);
	
	plArrow.transformBy(vxTrans );
	dp.draw(PlaneProfile(plArrow),_kDrawFilled);
	mapRequest.setPoint3d("ptScale", _PtG[1]);	
	mapRequest.setPLine("pline", plArrow);
	mapRequest.setInt("DrawFilled", _kDrawFilled);
	mapRequests.appendMap("DimRequest",mapRequest);	
		




// text
	Map mapRequestTxt;
	mapRequestTxt.setPoint3d("ptScale", _PtG[0]);		
	mapRequestTxt.setInt("deviceMode", _kDevice);		
	mapRequestTxt.setString("dimStyle", sDimStyle);	
	mapRequestTxt.setInt("Color", nColor);
	mapRequestTxt.setVector3d("AllowedView", vxS);				
	mapRequestTxt.setPoint3d("ptLocation",pt );		
	mapRequestTxt.setVector3d("vecX", vyS);
	mapRequestTxt.setVector3d("vecY", vzS);
	mapRequestTxt.setDouble("textHeight", dTxtH);
	mapRequestTxt.setDouble("dXFlag", 0);
	mapRequestTxt.setDouble("dYFlag", 0);			
	mapRequestTxt.setString("text", sViewNumber);	
	mapRequests.appendMap("DimRequest",mapRequestTxt);	
	dp.draw(sViewNumber,pt,vxRead,vyRead,0,0,_kDevice);
	
	pt.transformBy(vxTrans);	
	mapRequestTxt.setPoint3d("ptScale", _PtG[1]);		
	mapRequestTxt.setPoint3d("ptLocation",pt );		
	mapRequests.appendMap("DimRequest",mapRequestTxt);		
			
	dp.draw(sViewNumber,pt,vxRead,vyRead,0,0,_kDevice);
	
// publish
	_Map.setMap("DimRequest[]", mapRequests);		


#End
#BeginThumbnail
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
12IK5:D$KO?L52IPELOO/_]DM
`


#End
