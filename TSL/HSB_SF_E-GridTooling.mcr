#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
29.09.2017 - version 1.01
Applies Service/Trumpet holes based on a grid on Steel Frame Elements. (Can be hidden turning off 'Tooling' layer group)
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
//region History and versioning
/// <summary Lang=en>
/// Applies Service/Trumpet holes based on a grid on Steel Frame Elements. (Can be hidden turning off 'Tooling' layer group)
/// </summary>

/// <insert>
/// Select element(s)
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <history>
/// DR - 1.00 - 20.09.2017	- Release
/// DR - 1.01 - 29.09.2017	- All default scenarios defined. Added contextual menus to add/remove positions (vertical/horizontal) and also to erase instance and tubes
/// </history>
//endregion

//region main variables
Unit(1, "mm");
String sTab="     ", sKeyName_Points="Points", sKeyName_HorizontalPositions="HorizontalPositions", sKeyName_VerticalPositions="VerticalPositions";
String sTubeScriptName = "HSB_SF_E-InstallationTube";
int arBExclude[] = {_kNo, _kYes};
String arSFilterType[] = {T("|Include|"), T("|Exclude|")};
int onDebug=false;
int eraseInstance=false; 
String eraseMessage="";
//endregion

//region OPM
int indexString=0, indexDouble=0, indexInt=0;
String sCategory_VerticalPositions= T("|Vertical positions|");

PropDouble dVerticalSpacing(indexDouble, U(600), T("|Distance between vertical tubes|"));indexDouble++;
dVerticalSpacing.setCategory(sCategory_VerticalPositions);	

String sVerticalOp0=T("|Spacing|"), sVerticalOp1=T("|Between studs|"), sVerticalOp2=T("|Manual input|"), sVerticalOp3=T("|None|");
String sDefaultVerticalOptions[]={ sVerticalOp0, sVerticalOp1, sVerticalOp2, sVerticalOp3};
PropString sDefaultVerticalOption(indexString, sDefaultVerticalOptions, T("|Default distribution|"),0);indexString++;
sDefaultVerticalOption.setCategory(sCategory_VerticalPositions);

PropString separatorVerticalOp0Settings(indexString, "", sTab+sVerticalOp0+" "+T("|settings|"));indexString++;
separatorVerticalOp0Settings.setCategory(sCategory_VerticalPositions);separatorVerticalOp0Settings.setReadOnly(true);
	PropDouble dEndOffsetLeft(indexDouble, U(160.25), sTab+sTab+T("|Left offset|"));indexDouble++;
	dEndOffsetLeft.setCategory(sCategory_VerticalPositions);
	PropDouble dEndOffsetRight(indexDouble, U(160.25), sTab+sTab+T("|Right offset|"));indexDouble++;
	dEndOffsetRight.setCategory(sCategory_VerticalPositions);

PropString separatorVerticalOp1Settings(indexString, "", sTab+sVerticalOp1+" "+T("|settings|"));indexString++;
separatorVerticalOp1Settings.setCategory(sCategory_VerticalPositions);separatorVerticalOp1Settings.setReadOnly(true);
	PropDouble dMinDistanceBetweenStuds(indexDouble, U(100), sTab+sTab+T("|Minimal distance between studs|"));indexDouble++;
	dMinDistanceBetweenStuds.setCategory(sCategory_VerticalPositions);

PropString separatorVerticalOp2Settings(indexString, "", sTab+sVerticalOp2+" "+T("|settings|"));indexString++;
separatorVerticalOp2Settings.setCategory(sCategory_VerticalPositions);separatorVerticalOp2Settings.setReadOnly(true);
	PropString sVerticalPlanePositions(indexString, "100;500;1000", sTab+sTab+T("|Positions|"));indexString++;
	sVerticalPlanePositions.setCategory(sCategory_VerticalPositions);


String sCategory_HorizontalPositions= T("|Horizontal Positions|");
PropDouble dHorizontalSpacing(indexDouble, U(200), T("|Distance between horizontal tubes|")+" ");indexDouble++;
dHorizontalSpacing.setCategory(sCategory_HorizontalPositions);

String sHorizontalOp0=T("|Spacing|"), sHorizontalOp1=T("|Top-Bottom-Center|"), sHorizontalOp2=T("|Manual input|"), sHorizontalOp3=T("|None|");
String sDefaultHorizontalOptions[]={ sHorizontalOp0, sHorizontalOp1, sHorizontalOp2, sHorizontalOp3};
PropString sDefaultHorizontalOption(indexString, sDefaultHorizontalOptions, T("|Default distribution|")+" ",1);indexString++;
sDefaultHorizontalOption.setCategory(sCategory_HorizontalPositions);

PropString separatorHorizontalOp0Settings(indexString, "", sTab+sHorizontalOp0+" "+T("|settings|")+" ");indexString++;
separatorHorizontalOp0Settings.setCategory(sCategory_HorizontalPositions);separatorHorizontalOp0Settings.setReadOnly(true);
	PropDouble dEndOffsetBottom(indexDouble, U(200), sTab+sTab+T("|Bottom offset|"));indexDouble++;
	dEndOffsetBottom.setCategory(sCategory_HorizontalPositions);
	PropDouble dEndOffsetTop(indexDouble, U(200), sTab+sTab+T("|Top offset|"));indexDouble++;
	dEndOffsetTop.setCategory(sCategory_HorizontalPositions);

PropString separatorHorizontalOp1Settings(indexString, "", sTab+sHorizontalOp1+" "+T("|settings|"));indexString++;
separatorHorizontalOp1Settings.setCategory(sCategory_HorizontalPositions);separatorHorizontalOp1Settings.setReadOnly(true);
	PropInt nBottomHorizontalPositions(indexInt, 3, sTab+sTab+T("|Bottom positions|"));indexInt++;
	nBottomHorizontalPositions.setCategory(sCategory_HorizontalPositions);
	PropDouble dBottomEndOffset(indexDouble, U(200), sTab+sTab+sTab+T("|Offset|"));indexDouble++;
	dBottomEndOffset.setCategory(sCategory_HorizontalPositions);
	PropInt nTopHorizontalPositions(indexInt, 3, sTab+sTab+T("|Top positions|"));indexInt++;
	nTopHorizontalPositions.setCategory(sCategory_HorizontalPositions);
	PropDouble dTopEndOffset(indexDouble, U(200), sTab+sTab+sTab+T("|Offset|")+" ");indexDouble++;
	dTopEndOffset.setCategory(sCategory_HorizontalPositions);

PropString separatorHorizontalOp2Settings(indexString, "", sTab+sHorizontalOp2+" "+T("|settings|")+" ");indexString++;
separatorHorizontalOp2Settings.setCategory(sCategory_HorizontalPositions);separatorHorizontalOp2Settings.setReadOnly(true);
	PropString sHorizontalPlanePositions(indexString, "200;500;700", sTab+sTab+T("|Positions|")+" ");indexString++;
	sHorizontalPlanePositions.setCategory(sCategory_HorizontalPositions);

String sCategory_Tooling= T("|Tooling|");
String tubeCatalogNames[] = TslInst().getListOfCatalogNames(sTubeScriptName);
PropString sTubeCatalog(indexString, tubeCatalogNames, T("|Tube catalog|"), 0);indexString++;
sTubeCatalog.setCategory(sCategory_Tooling);
PropDouble dMinimalDistance(indexDouble, U(150), T("|Minimal distance between tubes|"));indexDouble++;
dMinimalDistance.setCategory(sCategory_Tooling);

String sCategory_Selection= T("|Selection|");
PropString sFilterType(indexString, arSFilterType, T("|Filter type|"));indexString++;
sFilterType.setCategory(sCategory_Selection);
PropString sFilterBC(indexString, "", T("|Filter beams with beamcode|"));indexString++;
sFilterBC.setCategory(sCategory_Selection);

String sCategory_Visualization= T("|Visualization|");
PropInt nColor(indexInt, 1, T("|Color|"));indexInt++;
nColor.setCategory(sCategory_Visualization);
PropDouble dSymbolSize(indexDouble, U(40), T("|Symbol size|"));indexDouble++;
dSymbolSize.setCategory(sCategory_Visualization);
PropDouble dGripOffset(indexDouble, U(400), T("|Grip offset|"));indexDouble++;
dGripOffset.setCategory(sCategory_Visualization);

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames("HSB_E-GridTooling");
if( _kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);
//endregion

//region onInsert
if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	String catalog=T("_LastInserted");
	if(onDebug) catalog=(T("_Default"));
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
		showDialog(catalog);

	setCatalogFromPropValues(T("_LastInserted"));
	
	// Selection
	Map points;
	Point3d verticalPositions[0], horizontalPositions[0];
	Element selectedElements[0];
	PrEntity ssE(TN("|\nSelect several walls to use default distributions or one single wall to customize (you have the option to use default distributions on single selection too.)|"), Element());
	if( ssE.go() )
		selectedElements.append(ssE.elementSet());
		
	if(selectedElements.length()==1)
	{		
		// Collect vertical distribution points
		while(true)
		{
			String sTxt = sTab+T("|VERTICAL POSITIONS|: Select first point or hit ENTER to use default values|");
			if( verticalPositions.length() > 0 )
				sTxt = TN("|Select next point or hit ENTER to finish selection|")+". ("+T("|Selected vertical positions|")+" : "+verticalPositions.length()+")";
			PrPoint prPt(sTxt);
			if( prPt.go() == _kOk )
				verticalPositions.append(prPt.value());
			else
				break;
		}
	
		// Collect horizontal distribution points
		while(true)
		{
			String sTxt = sTab+T("|HORIZONTAL POSITIONS|: Select first point or hit ENTER to use default values|");
			if( horizontalPositions.length() > 0 )
				sTxt = TN("|Select next point or hit ENTER to finish selection|")+". ("+T("|Selected horizontal positions|")+" : "+horizontalPositions.length()+")";
			PrPoint prPt(sTxt);
			if( prPt.go() == _kOk )
				horizontalPositions.append(prPt.value());
			else
				break;
		}
	}
	
	if(onDebug)
	{ 
		reportMessage(TN("|Insertion:|"));
		reportMessage(TN("|selectedElements.length()|: ")+selectedElements.length());
		reportMessage(TN("|verticalPositions|: ")+verticalPositions.length());
		reportMessage(TN("|horizontalPositions|: ")+horizontalPositions.length());
	}
	
	// Store positions on map
	Map mapTsl;	
	Map submapVerticalPositions; 
	for (int p=0;p<verticalPositions.length();p++) 
	{ 
		submapVerticalPositions.appendPoint3d(p, verticalPositions[p]);		 
	}
	mapTsl.appendMap(sKeyName_VerticalPositions, submapVerticalPositions);
	
	Map submapHorizontalPositions;
	for (int p=0;p<horizontalPositions.length();p++) 
	{ 
		submapHorizontalPositions.appendPoint3d(p, horizontalPositions[p]);		 
	}
	mapTsl.appendMap(sKeyName_VerticalPositions, submapHorizontalPositions);

	String strScriptName = scriptName();
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Element lstElements[1];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	
	for (int e=0;e<selectedElements.length();e++) {
		Element selectedElement = selectedElements[e];
		lstElements[0] = selectedElement;
		
		// There can only be one of these tsl's attached to the element.
		TslInst arTsl[] = selectedElement.tslInst();
		for( int i=0;i<arTsl.length();i++ ){
			TslInst tsl = arTsl[i];
			if( tsl.scriptName() == strScriptName ){
				tsl.dbErase();
			}
		}
		
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		if (tsl.bIsValid())
			tsl.setPropValuesFromCatalog(T("|_LastInserted|"));
	}
	
	eraseInstance();
	return;
}
//endregion

//region set properties from catalog
if (_bOnDbCreated)
	setPropValuesFromCatalog(T("|_LastInserted|"));
//endregion
	
//region element info and validation
if( _Element.length() == 0 ){
	eraseInstance();
	return;
}

Element el = _Element[0];
CoordSys csEl = el.coordSys();
Point3d ptElOrg = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
LineSeg ls=el.segmentMinMax();
double dElLength=abs(vxEl.dotProduct(ls.ptStart()-ls.ptEnd()));
double dElHeight= abs(vyEl.dotProduct(ls.ptStart()-ls.ptEnd()));
Point3d ptElEnd= ptElOrg+vxEl*dElLength;
Point3d ptElTop= ptElOrg+vyEl*dElHeight;
_Pt0 = ptElOrg;

assignToElementGroup(el, true, 0, 'T');
//endregion

//region selection
int bAllFiltersEmpty = true;
int bExclude = arBExclude[arSFilterType.find(sFilterType,1)];

String arSFilterBmCode[0];
String sList = sFilterBC + ";";
int nTokenIndex = 0; 
int nCharacterIndex = 0;
while(nCharacterIndex < sList.length()-1){
	String sListItem = sList.token(nTokenIndex,";");
	nTokenIndex++;
	if(sListItem.length()==0){
		nCharacterIndex++;
		continue;
	}
	nCharacterIndex = sList.find(sListItem,0);
	sListItem.trimLeft();
	sListItem.trimRight();
	arSFilterBmCode.append(sListItem);
}
if( arSFilterBmCode.length() > 0 )
	bAllFiltersEmpty = false;
	
Beam arBm[0];
Point3d arPtBm[0];
GenBeam arGBmAll[] = el.genBeam();
for(int i=0;i<arGBmAll.length();i++){
	GenBeam gBm = arGBmAll[i];
	int bFilterGenBeam = false;
	
	//Filter dummies
	if( gBm.bIsDummy() )
		continue;
	
	//Filter beamcodes
	if( !bFilterGenBeam ){
		String sBmCode = gBm.beamCode().token(0).makeUpper();
		sBmCode.trimLeft();
		sBmCode.trimRight();
		
		if( arSFilterBmCode.find(sBmCode)!= -1 ){
			bFilterGenBeam = true;
		}
		else{
			for( int j=0;j<arSFilterBmCode.length();j++ ){
				String sFltrBC = arSFilterBmCode[j];
				String sFltrBCTrimmed = sFltrBC;
				sFltrBCTrimmed.trimLeft("*");
				sFltrBCTrimmed.trimRight("*");
				if( sFltrBCTrimmed == "" ){
					if( sFltrBC == "*" && sBmCode != "" )
						bFilterGenBeam = true;
					else
						continue;
				}
				else{
					if( sFltrBC.left(1) == "*" && sFltrBC.right(1) == "*" && sBmCode.find(sFltrBCTrimmed, 0) != -1 )
						bFilterGenBeam = true;
					else if( sFltrBC.left(1) == "*" && sBmCode.right(sFltrBC.length() - 1) == sFltrBCTrimmed )
						bFilterGenBeam = true;
					else if( sFltrBC.right(1) == "*" && sBmCode.left(sFltrBC.length() - 1) == sFltrBCTrimmed )
						bFilterGenBeam = true;
				}
			}
		}
	}
	
	if( !bAllFiltersEmpty && ((bFilterGenBeam && bExclude) || (!bFilterGenBeam && !bExclude)) )
		continue;
	
	Beam bm = (Beam)gBm;
	if( bm.bIsValid() )
		arBm.append(bm);
		
	arPtBm.append(bm.envelopeBody(false, true).allVertices());
}
//endregion

//region Positions
//region set defaults (if no points are provided)
//region vertical default positions
Map submapVerticalPositions= _Map.getMap(sKeyName_VerticalPositions);
if(submapVerticalPositions.length()==0)
{
	int nDefaultDistribution=sDefaultVerticalOptions.find(sDefaultVerticalOption, 0);
	if(nDefaultDistribution==0)//spacing
	{ 
		double dAvailable=dElLength-dEndOffsetLeft-dEndOffsetRight;
		int nPositions=0;
		while(dAvailable>dMinimalDistance && nPositions<20 )
		{
			dAvailable-=dVerticalSpacing;
			nPositions++;
		}
		
		Point3d ptPosition= ptElOrg;
		for (int i=0;i<nPositions;i++) 
		{ 
			if(i==0)
				ptPosition+=vxEl*dEndOffsetLeft;
			else
				ptPosition+=vxEl*dVerticalSpacing;
	
			submapVerticalPositions.appendPoint3d(i, ptPosition);	
		}
		
		submapVerticalPositions.appendPoint3d(nPositions, ptElEnd- vxEl*dEndOffsetRight);	

		if(onDebug) reportMessage(TN("|Loaded default vertical positions:| ")+sVerticalOp0);
	}
	else if(nDefaultDistribution==1)//between studs
	{
		Beam verticalBeams[]= vxEl.filterBeamsPerpendicularSort(arBm);
		for (int b=0;b<verticalBeams.length()-1;b++) 
		{ 
			Beam current= verticalBeams[b]; 
			Beam next= verticalBeams[b+1];

			Point3d ptLeft= current.ptCen()+vxEl*current.dD(vxEl)*.5;
			Point3d ptRight= next.ptCen()-vxEl*next.dD(vxEl)*.5;
			double distance= vxEl.dotProduct(ptRight-ptLeft);
			if(distance<dMinDistanceBetweenStuds)
				continue;
				
			Point3d ptMid= ptLeft+vxEl*distance*.5;
			submapVerticalPositions.appendPoint3d(b, ptMid);	
			
			if(onDebug){ ptLeft.vis(1); ptRight.vis(2); ptMid.vis(3);}
		}
		
		if(onDebug) reportMessage(TN("|Loaded default vertical positions:| ")+sVerticalOp1);
	}
	else if(nDefaultDistribution==2)//manual input
	{ 
		double arDVerticalPositions[0];
		sList = sVerticalPlanePositions + ";";
		sList.makeUpper();
		nTokenIndex = 0; 
		nCharacterIndex = 0;
		while(nCharacterIndex < sList.length()-1)
		{
			String sListItem = sList.token(nTokenIndex);
			nTokenIndex++;
			if(sListItem.length()==0)
			{
				nCharacterIndex++;
				continue;
			}
			nCharacterIndex = sList.find(sListItem,0);
			sListItem.trimLeft();
			sListItem.trimRight();
			arDVerticalPositions.append(sListItem.atof());
		}
		
		for(int i=0; i<arDVerticalPositions.length();i++)
		{
			submapVerticalPositions.appendPoint3d(i, ptElOrg + vxEl* arDVerticalPositions[i]);	
		}

		if(onDebug) reportMessage(TN("|Loaded default vertical positions:| ")+sVerticalOp2);
	}
	else//none or default
	{
		submapVerticalPositions.appendPoint3d(0, ptElOrg - vxEl* U(100));//setting value out of scope so will be filtered out

		if(onDebug) reportMessage(TN("|Loaded default vertical positions:| ")+sVerticalOp3);
	}
	
	_Map.appendMap(sKeyName_VerticalPositions, submapVerticalPositions);
}
//endregion
//region horizontal default positions
Map submapHorizontalPositions= _Map.getMap(sKeyName_HorizontalPositions);
if(submapHorizontalPositions.length()==0)
{
	int nDefaultDistribution=sDefaultHorizontalOptions.find(sDefaultHorizontalOption, 0);
	if(nDefaultDistribution==0)//spacing
	{ 
		double dAvailable=dElHeight-dEndOffsetBottom-dEndOffsetTop;
		int nPositions=0;
		while(dAvailable> dMinimalDistance && nPositions < 20)
		{
			dAvailable-=dHorizontalSpacing;
			nPositions++;
		}
		
		Point3d ptPosition= ptElOrg;
		for (int i=0;i<nPositions;i++) 
		{
			if(i==0)
				ptPosition+=vyEl*dEndOffsetBottom;
			else
				ptPosition+=vyEl*dHorizontalSpacing;
			
			submapHorizontalPositions.appendPoint3d(i, ptPosition);
		}
		
		submapHorizontalPositions.appendPoint3d(nPositions, ptElTop-vyEl*dEndOffsetTop);
		
		if(onDebug) reportMessage(TN("|Loaded default horizontal positions:| "+sHorizontalOp0));
	}
	else if(nDefaultDistribution==1)//Top-Bottom-Center
	{
		Point3d positions[0];
		//bottom
		Point3d position= ptElOrg+ vyEl*dBottomEndOffset;
		for (int i=0;i<nBottomHorizontalPositions;i++) 
		{ 
			positions.append(position);
			position+=vyEl*dHorizontalSpacing;
		}
		//top
		position=ptElTop-vyEl*dTopEndOffset;
		for(int i=0; i< nTopHorizontalPositions;i++)
		{
			positions.append(position);
			position-=vyEl*dHorizontalSpacing;
		}
		//center
		positions.append(ptElOrg + vyEl * dElHeight * .5 );
		
		for (int p=0;p<positions.length();p++) 
		{ 
			Point3d position= positions[p]; 
			submapHorizontalPositions.appendPoint3d(p, position); 
		}

		if(onDebug) reportMessage(TN("|Loaded default horizontal positions:| "+sHorizontalOp1));
	}
	else if(nDefaultDistribution==2)//manual input
	{ 
		double arDHorizontalPositions[0];
		sList = sHorizontalPlanePositions + ";";
		sList.makeUpper();
		nTokenIndex = 0; 
		nCharacterIndex = 0;
		while(nCharacterIndex < sList.length()-1){
			String sListItem = sList.token(nTokenIndex);
			nTokenIndex++;
			if(sListItem.length()==0){
				nCharacterIndex++;
				continue;
			}
			nCharacterIndex = sList.find(sListItem,0);
			sListItem.trimLeft();
			sListItem.trimRight();
			arDHorizontalPositions.append(sListItem.atof());
		}
		
		for (int i=0;i<arDHorizontalPositions.length();i++) 
		{ 
			submapHorizontalPositions.appendPoint3d(i, ptElOrg + vyEl * arDHorizontalPositions[i]);
		}
		
		if(onDebug) reportMessage(TN("|Loaded default horizontal positions:| "+sHorizontalOp2));
	}
	else//none or default
	{
		submapHorizontalPositions.appendPoint3d(0, ptElOrg - vyEl * U(100));
		
		if(onDebug) reportMessage(TN("|Loaded default horizontal positions:| "+sHorizontalOp3));//setting value out of scope so will be filtered out	
	}
	
	_Map.appendMap(sKeyName_HorizontalPositions, submapHorizontalPositions);
}
//endregion
//endregion
//region read values
//region control if there are valid points
if(submapVerticalPositions.length()==0 && submapHorizontalPositions.length()==0)
{
	eraseInstance=true;
	eraseMessage=T("|ERROR: no points could be defined, TSL will be erased.|");
}
//endregion

//region add points
String sOutOfScope=TN("|Invalid point: out of element.|"), sAlreadyExisting=TN("|Invalid point: there is already a tube in this position.|");
double dMinClose=U(1);
//region add vertical position
String strAddVerticalPosition = T("|Add vertical position|");
addRecalcTrigger(_kContext, strAddVerticalPosition );
if (_bOnRecalc && _kExecuteKey==strAddVerticalPosition)
{
	Map submapNewVerticalPositions=_Map.getMap(sKeyName_VerticalPositions);
	int appendPoint=true;
	Point3d ptNew= getPoint(T("|Select new vertical position|"));
	
	//check if point is out of element
	if( vxEl.dotProduct(ptElOrg-ptNew)>=0 || vxEl.dotProduct(ptNew-ptElEnd)>0)
	{
		reportMessage(sOutOfScope);
		appendPoint=false;
	}
	
	//check if point is too close to other point
	for(int p=0; p< submapNewVerticalPositions.length(); p++)
	{
		Point3d pt= submapNewVerticalPositions.getPoint3d(p);
		if(abs(vxEl.dotProduct(pt-ptNew)) < dMinClose)
		{
			reportMessage(sAlreadyExisting);
			appendPoint=false;
			break;
		}
	}
	
	if(appendPoint)
	{ 
		submapNewVerticalPositions.appendPoint3d(submapNewVerticalPositions.length(), ptNew);
		submapVerticalPositions=submapNewVerticalPositions;
		_Map.setMap(sKeyName_VerticalPositions, submapNewVerticalPositions);
	}
}
//endregion
//region add horizontal position
String strAddHorizontalPosition = T("|Add horizontal position|");
addRecalcTrigger(_kContext, strAddHorizontalPosition);
if (_bOnRecalc && _kExecuteKey==strAddHorizontalPosition)
{
	Map submapNewHorizontalPositions=_Map.getMap(sKeyName_HorizontalPositions);
	int appendPoint=true;
	Point3d ptNew= getPoint(T("|Select new horizontal position|"));
	
	//check if point is out of element
	if( vyEl.dotProduct(ptElOrg-ptNew)>=0 || vyEl.dotProduct(ptNew-ptElTop)>0)
	{
		reportMessage(sOutOfScope);
		appendPoint=false;
	}
	
	//check if point is too close to other point
	for(int p=0; p< submapNewHorizontalPositions.length(); p++)
	{
		Point3d pt= submapNewHorizontalPositions.getPoint3d(p);
		if(abs(vyEl.dotProduct(pt-ptNew)) < dMinClose)
		{
			reportMessage(sAlreadyExisting);
			appendPoint=false;
			break;
		}
	}
	
	if(appendPoint)
	{ 
		submapNewHorizontalPositions.appendPoint3d(submapNewHorizontalPositions.length(), ptNew);
		submapHorizontalPositions=submapNewHorizontalPositions;
		_Map.setMap(sKeyName_HorizontalPositions, submapNewHorizontalPositions);
	}
}
//endregion
//endregion

//region remove points
String sNoTubeFound=TN("|No tube found at this position.|");
double dSelectionTolerance=(10);
//region remove vertical position
String strRemoveVerticalPosition = T("|Remove vertical position|");
addRecalcTrigger(_kContext, strRemoveVerticalPosition );
if (_bOnRecalc && _kExecuteKey==strRemoveVerticalPosition)
{
	Map submapNewVerticalPositions=_Map.getMap(sKeyName_VerticalPositions);
	int pointFound=false;
	Point3d ptNew= getPoint(T("|Select vertical position|"));
	//check if point is valid position
	for(int p=0; p< submapNewVerticalPositions.length(); p++)
	{
		Point3d pt= submapNewVerticalPositions.getPoint3d(p);
		if(abs(vxEl.dotProduct(pt-ptNew)) < dSelectionTolerance)
		{
			submapNewVerticalPositions.removeAt(p, false);
			submapVerticalPositions=submapNewVerticalPositions;
			_Map.setMap(sKeyName_VerticalPositions, submapNewVerticalPositions);
			pointFound=true;
			break;
		}
	}
	
	if(!pointFound)
		reportMessage(sNoTubeFound);
}
//endregion
//region remove horizontal position
String strRemovehorizontalPosition = T("|Remove horizontal position|");
addRecalcTrigger(_kContext, strRemovehorizontalPosition );
if (_bOnRecalc && _kExecuteKey==strRemovehorizontalPosition)
{
	Map submapNewHorizontalPositions=_Map.getMap(sKeyName_HorizontalPositions);
	int pointFound=false;
	Point3d ptNew= getPoint(T("|Select horizontal position|"));
	//check if point is valid position
	for(int p=0; p< submapNewHorizontalPositions.length(); p++)
	{
		Point3d pt= submapNewHorizontalPositions.getPoint3d(p);
		if(abs(vyEl.dotProduct(pt-ptNew)) < dSelectionTolerance)
		{
			submapNewHorizontalPositions.removeAt(p, false);
			submapHorizontalPositions=submapNewHorizontalPositions;
			_Map.setMap(sKeyName_HorizontalPositions, submapNewHorizontalPositions);
			pointFound=true;
			break;
		}
	}
	
	if(!pointFound)
		reportMessage(sNoTubeFound);
}
//endregion
//endregion

//region read vertical positions
double arDVerticalPositions[0];
for(int p=0; p<submapVerticalPositions.length(); p++)
{
	Point3d position= submapVerticalPositions.getPoint3d(p);
	if(vxEl.dotProduct(position-ptElOrg)<0 || vxEl.dotProduct(position-ptElEnd)>0) //position is out of element
		continue;
	
	arDVerticalPositions.append(vxEl.dotProduct(position-ptElOrg));
}
if(onDebug) reportMessage(TN("|vertical positions read|: ")+submapVerticalPositions.length());
//endregion

//region read horizontal positions
double arDHorizontalPositions[0];
for (int p=0;p<submapHorizontalPositions.length();p++) 
{ 
	Point3d position= submapHorizontalPositions.getPoint3d(p);
	arDHorizontalPositions.append(vyEl.dotProduct(position-ptElOrg));
}
if(onDebug) reportMessage(TN("|horizontal positions read|: ")+submapHorizontalPositions.length());
//endregion

//endregion
//endregion

//region keep grips at element's offsetted edges
// Reference points
Line lnElX(ptElOrg, vxEl);
Line lnElY(ptElOrg, vyEl);
// Ordered along x and y axis of element.
Point3d arPtBmX[] = lnElX.orderPoints(arPtBm);
Point3d arPtBmY[] = lnElY.orderPoints(arPtBm);
if( (arPtBmX.length() * arPtBmY.length()) == 0 )
	return;
Point3d ptBL = arPtBmX[0];
ptBL += vyEl * vyEl.dotProduct(arPtBmY[0] - ptBL);
Point3d ptTR = arPtBmX[arPtBmX.length() - 1];
ptTR += vyEl * vyEl.dotProduct(arPtBmY[arPtBmY.length() - 1] - ptTR);	

Point3d ptReference = ptBL;

if( _kNameLastChangedProp.left(4) == "_PtG" ){
	int nGripIndex = _kNameLastChangedProp.right(_kNameLastChangedProp.length() - 4).atoi();
	
	if( arDHorizontalPositions.length() > 0 && nGripIndex < arDHorizontalPositions.length() ){
		// Update horizontal list, property will be updated at the end of the tsl.
		arDHorizontalPositions[nGripIndex] = vyEl.dotProduct(_PtG[nGripIndex] - ptReference);
	}
	else{
		// Update vertical list.
		arDVerticalPositions[nGripIndex - arDHorizontalPositions.length()] = vxEl.dotProduct(_PtG[nGripIndex] - ptReference);
	}
}

// Get the stored planes; refresh stored points in map if grip points are relocated
Vector3d arVNormal[0];
_PtG.setLength(0);
int arBIsHorizontalPn[0];
Map submapNewHorizontalPositions;
// Horizontal planes.
for( int i=0;i<arDHorizontalPositions.length();i++ ){
	double dHorizontalPosition = arDHorizontalPositions[i];
	Point3d pt=ptReference + vyEl * dHorizontalPosition;
	_PtG.append(pt);
	submapNewHorizontalPositions.setPoint3d(i, pt);
	arVNormal.append(vyEl);
	arBIsHorizontalPn.append(true);
}
_Map.setMap(sKeyName_HorizontalPositions, submapNewHorizontalPositions);

// Vertical planes.
Map submapNewVerticalPositions;
for( int i=0;i<arDVerticalPositions.length();i++ ){
	double dVerticalPosition = arDVerticalPositions[i];
	Point3d pt=ptReference + vxEl * dVerticalPosition;
	_PtG.append(pt);
	submapNewVerticalPositions.setPoint3d(i, pt);
	arVNormal.append(vxEl);
	arBIsHorizontalPn.append(false);
}
_Map.setMap(sKeyName_VerticalPositions, submapNewVerticalPositions);
//endregion

//region creating tubes and draw the grid
Display dpGrid(nColor);
dpGrid.elemZone(el, 0, 'T');

// Delete all prevoius instances of tubes
TslInst tsls[]=el.tslInstAttached();
for( int t=0; t<tsls.length(); t++)
{
	TslInst tsl= tsls[t];
	// Erase all previous versions of this TSL
	if ( tsl.scriptName() == sTubeScriptName)
		tsl.dbErase();
}

//clonning TSL
TslInst tslNew;
Vector3d vecUcsX = _XW;
Vector3d vecUcsY = _YW;
Entity lstEnts[1]; lstEnts[0]=el;
GenBeam lstGenBeams[0];
Point3d lstPoints[2];
int lstPropInt[0];
double lstPropDouble[0];
String lstPropString[0];
Map mapTsl;

Plane arPnIntersect[0];
for( int i=0;i<_PtG.length();i++ ){
	int bIsHorizontalPn = arBIsHorizontalPn[i];
	
	Vector3d vLnSeg;
	if( bIsHorizontalPn ){
		_PtG[i] += vxEl * vxEl.dotProduct((ptReference - vxEl * dGripOffset) - _PtG[i]);
		vLnSeg = vxEl;
	}
	else{
		_PtG[i] += vyEl * vyEl.dotProduct((ptReference - vyEl * dGripOffset) - _PtG[i]);
		vLnSeg = vyEl;
	}

	arPnIntersect.append(Plane(_PtG[i], arVNormal[i]));
	
	// Draw reference lines
	LineSeg lnSegGrid(_PtG[i], _PtG[i] + vLnSeg * vLnSeg.dotProduct((ptTR + vLnSeg * dGripOffset) - _PtG[i]));
	dpGrid.draw(lnSegGrid);

	// Create tubes
	Point3d ptStart= _PtG[i] + vLnSeg * dGripOffset;
	Point3d ptEnd= _PtG[i] + vLnSeg * vLnSeg.dotProduct((ptTR + vLnSeg * dGripOffset*0) - _PtG[i]);
	lstPoints[0]= ptStart;
	lstPoints[1]= ptEnd;	
	tslNew.dbCreate(sTubeScriptName, vecUcsX,vecUcsY,lstGenBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,_kModelSpace, mapTsl);
	tslNew.setPropValuesFromCatalog(sTubeCatalog);
}
//endregion

//region visualisation
Display dpVisualisation(nColor);
dpVisualisation.textHeight(U(4));
dpVisualisation.addHideDirection(_ZW);
dpVisualisation.addHideDirection(-_ZW);
dpVisualisation.elemZone(el, 0, 'I');

Point3d ptSymbol01 = _Pt0 - vyEl * 2 * dSymbolSize;
Point3d ptSymbol02 = ptSymbol01 - (vxEl + vyEl) * dSymbolSize;
Point3d ptSymbol03 = ptSymbol01 + (vxEl - vyEl) * dSymbolSize;

PLine plSymbol01(vzEl);
plSymbol01.addVertex(_Pt0);
plSymbol01.addVertex(ptSymbol01);
PLine plSymbol02(vzEl);
plSymbol02.addVertex(ptSymbol02);
plSymbol02.addVertex(ptSymbol01);
plSymbol02.addVertex(ptSymbol03);

dpVisualisation.draw(plSymbol01);
dpVisualisation.draw(plSymbol02);

Vector3d vxTxt = vxEl + vyEl;
vxTxt.normalize();
Vector3d vyTxt = vzEl.crossProduct(vxTxt);
dpVisualisation.draw(scriptName(), ptSymbol01, vxTxt, vyTxt, -1.1, 1.75);

{
	Display dpVisualisationPlan(nColor);
	dpVisualisationPlan.textHeight(U(4));
	dpVisualisationPlan.addViewDirection(_ZW);
	dpVisualisationPlan.addViewDirection(-_ZW);	
	dpVisualisationPlan.elemZone(el, 0, 'I');
	
	Point3d ptSymbol01 = _Pt0 + vzEl * 2 * dSymbolSize;
	Point3d ptSymbol02 = ptSymbol01 - (vxEl - vzEl) * dSymbolSize;
	Point3d ptSymbol03 = ptSymbol01 + (vxEl + vzEl) * dSymbolSize;
	
	PLine plSymbol01(vyEl);
	plSymbol01.addVertex(_Pt0);
	plSymbol01.addVertex(ptSymbol01);
	PLine plSymbol02(vyEl);
	plSymbol02.addVertex(ptSymbol02);
	plSymbol02.addVertex(ptSymbol01);
	plSymbol02.addVertex(ptSymbol03);
	
	dpVisualisationPlan.draw(plSymbol01);
	dpVisualisationPlan.draw(plSymbol02);
	
	Vector3d vxTxt = vxEl - vzEl;
	vxTxt.normalize();
	Vector3d vyTxt = vyEl.crossProduct(vxTxt);
	dpVisualisationPlan.draw(scriptName(), ptSymbol01, vxTxt, vyTxt, -1.1, 1.75);
}
//endregion

//region erase instance and tubes
String strRemoveInstanceAndTubes = T("|Remove instance and tubes|");
addRecalcTrigger(_kContext, strRemoveInstanceAndTubes);
if (_bOnRecalc && _kExecuteKey==strRemoveInstanceAndTubes)
{
	eraseInstance=true;
}

if(eraseInstance)//by context menu or errors
{
	reportMessage("\n" + scriptName() + ": " +eraseMessage);
	TslInst arTsl[] = el.tslInst();
	for( int i=0;i<arTsl.length();i++ ){
		TslInst tsl = arTsl[i];
		if( tsl.scriptName() == sTubeScriptName )
		{
			tsl.dbErase();
		}
	}
	eraseInstance();
	return;
}
//endregion

return;
#End
#BeginThumbnail

#End