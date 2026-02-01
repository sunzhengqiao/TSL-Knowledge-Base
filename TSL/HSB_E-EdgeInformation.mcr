#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
20.06.2017  -  version 1.00
Places edge information at a given position. Catalog for this tsl can be set from DSP; argument to pass should be "DspToTsl; <catalog name>". If the catalog name is set to e.g. "VAR57", it used variable 57 to get the catalog name. 
The detail name can be resolved from the variable names of roof elements. @(VAR60) will replace the detail name with the content of VAR60 of that specific detail.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 1
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Places edge information at a given position. Catalog for this tsl can be set from DSP; argument to pass should be "DspToTsl; <catalog-name>"
/// </summary>

/// <insert>
/// Auto: Attach the tsl to a DSP detail.
/// Manual: 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="20.06.2017"></version>
/// <history>
/// AS - 1.00 - 20.06.2017 - Pilot version
/// </history>

if( _bOnElementDeleted ){
	eraseInstance();
	return;
}

double dEps = Unit(0.1, "mm");

String categories[] = 
{
	T("|Edge Information|"),
	T("|Position and Style|")
};

String noYes[] = {T("|No|"),T("|Yes|")};;

String category = categories[0];

PropString detailName(0, "@(VAR60)", T("|Detail name|"));
detailName.setCategory(category);
PropString sDescription(1, "", T("|Description|"));
sDescription.setCategory(category);
PropString sExtraDescription(2, "", T("|Extra description|"));
sExtraDescription.setCategory(category);
PropString sExtraDescription2(3, "", T("|Extra description 2|"));
sExtraDescription2.setCategory(category);
PropString sExtraDescription3(4, "", T("|Extra description 3|"));
sExtraDescription3.setCategory(category);
PropString sExtraDescription4(5, "", T("|Extra description 4|"));
sExtraDescription4.setCategory(category);


category = categories[1];

PropDouble offsetFromEdge(2, U(0), T("|Offset from edge|"));
offsetFromEdge.setCategory(category);

PropDouble horizontalOffset(1, U(0), T("|Horizontal text offset|"));
horizontalOffset.setCategory(category);

PropDouble textSize(0, U(-1), T("|Text size|"));
textSize.setCategory(category);

PropInt textColor(0, -1, T("|Color|"));
textColor.setCategory(category);

String arSTextAlignment[] = {T("|Left|"), T("|Right|"), T("|Center|")};
double arDTextAlignment[] = {1, -1, 0};

PropString sHorizontalTextAlignment(6, arSTextAlignment, T("|Horizontal text alignment|"));
sHorizontalTextAlignment.setCategory(category);

PropString onlyVisibleInTopViewProp(7, noYes, T("|Visible on top view only|"),1);
onlyVisibleInTopViewProp.setCategory(category);

String arSZoneLayer[] = {
	"Tooling",
	"Information",
	"Zone",
	"Element"
};
char arChZoneCharacter[] = {
	'T',
	'I',
	'Z',
	'E'
};
PropString sZoneLayer(8, arSZoneLayer, T("|Assign to layer|"));

int arNZoneIndex[] = {0,1,2,3,4,5,6,7,8,9};
PropInt nZnIndex(1, arNZoneIndex, T("|Zone index|"));


// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if (_kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1) 
	setPropValuesFromCatalog(_kExecuteKey);
	
// Only allow insert to create and edit the catalog entries. Show a warning and erase tsl after the dialog has closed.
if (_bOnInsert)
{
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	setCatalogFromPropValues(T("|_LastInserted|"));
	
	Element selectedElement = getElement(T("|Select an element|"));
		
	LineSeg edges[0];
	String constructionDetails[0];
	if (selectedElement.bIsKindOf(ElementWallSF()))
	{
		PLine elementOutline = selectedElement.plEnvelope();
		// TODO: Check direction of outline.
			
		Point3d outlineVertices[] = elementOutline.vertexPoints(false);
		
		for (int v=0;v<(outlineVertices.length() - 1);v++)
		{
			Point3d from = outlineVertices[v];
			Point3d to = outlineVertices[v+1];
			
			edges.append(LineSeg(from, to));
			constructionDetails.append("");
		}
	}
	if (selectedElement.bIsKindOf(ElementRoof()))
	{
		ElementRoof roofElement = (ElementRoof)selectedElement;
		ElemRoofEdge roofEdges[] = roofElement.elemRoofEdges();
		for (int e=0;e<roofEdges.length();e++)
		{
			ElemRoofEdge roofEdge = roofEdges[e];
			
			Point3d from = roofEdge.ptNode();
			Point3d to = roofEdge.ptNodeOther();
			if (roofEdge.vecDir().dotProduct(to - from) < 0)
			{
				from = roofEdge.ptNodeOther();
				to = roofEdge.ptNode();
			}
			
			edges.append(LineSeg(from, to));
			constructionDetails.append(roofEdge.constrDetail());
		}
	}
	
	Point3d edgePositions[0];
	PrPoint ssPoint(T("|Select edge|") + T("<|optional|>"));
	if (ssPoint.go())
	{
		Point3d pointAtEdge = ssPoint.value();
		pointAtEdge = Plane(selectedElement.ptOrg(), selectedElement.vecZ()).closestPointTo(pointAtEdge);
		edgePositions.append(pointAtEdge);
	}
	
	
	String strScriptName = scriptName();
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Entity lstEntities[] = {selectedElement};
	
	Point3d lstPoints[3];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	mapTsl.setInt("ManualInserted", true);
	
	for (int p=0;p<edgePositions.length();p++)
	{
		Point3d edgePosition = edgePositions[p];
		Point3d startDetail, endDetail;
		String detail;
		double distanceToEdge = U(50000);
		
		for (int e=0;e<edges.length();e++)
		{
			LineSeg edge = edges[e];
			String constructionDetail = constructionDetails[e];
			Point3d from = edge.ptStart();
			Point3d to = edge.ptEnd();
			
			PLine pl(from, to);
			Point3d projectedPoint = pl.closestPointTo(edgePosition);
			
			double offsetFromEdge = Vector3d(edgePosition - projectedPoint).length();
			if (offsetFromEdge < distanceToEdge)
			{
				distanceToEdge = offsetFromEdge;
				startDetail = from;
				endDetail = to;
				detail = constructionDetail;
			}
		}
		
		Vector3d edgeDirection(endDetail - startDetail);
		edgeDirection.normalize();
		
		edgePosition += edgeDirection * edgeDirection.dotProduct((startDetail + endDetail)/2 - edgePosition);
		
		lstPoints.setLength(0);
		
		Line lineAtEdge(startDetail, edgeDirection);
		Line lineOffsettedFromEdge(edgePosition, edgeDirection);
		
		lstPoints.append(lineOffsettedFromEdge.closestPointTo(startDetail));
		lstPoints.append(lineOffsettedFromEdge.closestPointTo(endDetail));
		lstPoints.append(lineAtEdge.closestPointTo(edgePosition));
		
		TslInst tslNew;
		tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		
		Map detailMap;
		int success = detailMap.setDxContent(detail, true);
		if (!success)
		{
			reportWarning(scriptName() + T(" - |Element| ") + selectedElement.number() + 
				TN("|Could not convert detail string to map.|") + "\n" + detail);
			eraseInstance();
			return;
		}
		
		if (detailName.left(5) == "@(VAR")
		{
			int variableIndex = detailName.mid(5, detailName.length() - 6).atoi() - 1;
			
			String resolvedName = detailName;
			if (detailMap.hasDouble("DVAR" + variableIndex))
				resolvedName = detailMap.getDouble("DVAR" + variableIndex);
			else if (detailMap.hasString("STRVAR" + variableIndex))
				resolvedName = detailMap.getString("STRVAR" + variableIndex);
			
			// Set the resolved name. It remains unresolved if it couldn't find it in the detailMap.
			tslNew.setPropString(0, resolvedName);
		}
	}
	
	eraseInstance();
	return;
}

if (_Element.length() == 0) {
	reportWarning(T("|invalid or no element selected.|"));
	eraseInstance();
	return;
}

int manualInserted = false;
if (_Map.hasInt("ManualInserted")) {
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

// set properties from catalog
if (_bOnDbCreated && manualInserted)
	setPropValuesFromCatalog(T("|_LastInserted|"));

if (_PtG.length() == 0) 
{
	reportMessage("\n" + scriptName() + ": " +T("|No grippoints found. TSL Will be erased|"));
	eraseInstance();
	return;
}

Vector3d edgeNormal = -_Element[0].vecY();
if (_kNameLastChangedProp == T("|Offset from edge|"))
{
	_Pt0 += edgeNormal * edgeNormal.dotProduct((_PtG[0] + edgeNormal * offsetFromEdge) - _Pt0);
}

_Pt0.vis(1);
for (int i=0;i<_PtG.length();i++)
	_PtG[i].vis(2+i);

if (_PtG.length() < 2)
	_PtG.append((_Pt0 + _PtG[0])/2);

if (_Map.hasPoint3d("PtG0") && _Map.hasPoint3d("PtG1")) {
	// Reset the grippoints to the detail line.
	_PtG[0] = _Map.getPoint3d("PtG0");
	_PtG[1] = _Map.getPoint3d("PtG1");
}
else {
	// Reorganize the points passed in through the generator. 
	// _Pt0 muts become the anchor for the text. The grippoints will be the 2 points on the detail line.
	Point3d ptOrg = _PtG[1];
	Point3d ptGrip0 = _Pt0;
	Point3d ptGrip1 = _PtG[0];

	Vector3d vLn(ptGrip0 - ptGrip1);
	vLn.normalize();
	Line lnDetail(ptOrg, vLn);
	Line lnText(ptGrip0, vLn);
	
	ptGrip0 = lnDetail.closestPointTo(ptGrip0);
	ptGrip1 = lnDetail.closestPointTo(ptGrip1);
	ptOrg = lnText.closestPointTo(ptOrg);
	
	// Store the points on the detail line.
	_Map.setPoint3d("PtG0", ptGrip0, _kAbsolute);
	_Map.setPoint3d("PtG1", ptGrip1, _kAbsolute);
	
	// Set _Pt0 to the text position and the grippoints to the start and end of the detail.
	_Pt0 = ptOrg;
	_PtG[0] = ptGrip0;
	_PtG[1] = ptGrip1;
}

int nLog = 0;
if (_bOnDebug)
	nLog = 1;
if (nLog == 1)
	reportNotice("\n\t****\n" + _ThisInst.handle());

// Set properties from dsp
int setPropsFromDspVariableIndex = -1;
if( _Map.hasString("DspToTsl") ){
	String catalogName;
	String sArgument = _Map.getString("DspToTsl");
	
	if (nLog == 1)
		reportNotice(TN("|Argument set in DSP detail|: ")+sArgument);
	if( sArgument.left(3).makeUpper() == "VAR" ){
		setPropsFromDspVariableIndex = sArgument.right(sArgument.length() - 3).atoi();
	}
	else{
		catalogName = sArgument;
		if (catalogName == "" ) 
		{
			reportMessage("\n" + scriptName() + ": " +T("|No catalogname specified|"));
			eraseInstance();
			return;
		}
		
		setPropValuesFromCatalog(catalogName);
	}

	_Map.removeAt("DspToTsl", true);
}

if (nLog == 1)
	reportNotice(TN("|Take catalog key from|: ")+setPropsFromDspVariableIndex);

if( _bOnDbCreated && _kExecuteKey != "" )
	setPropValuesFromCatalog(_kExecuteKey);

if(_Element.length()==0||_PtG.length()<1)return;

Element el = _Element[0];
assignToElementGroup(el, true, 0, 'E');

//int bPublishDetailInformation = arNYesNo[arSYesNo.find(sPublishDetailInformation, 1)];

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Line lnX(ptEl, vxEl);
PLine plElOutline = el.plEnvelope();
plElOutline.transformBy(-vzEl * el.dBeamWidth());
plElOutline.vis();

// Find roofedge for this tsl and get the construction detail.
Vector3d vY = (_PtG[1] - _PtG[0]);
vY.normalize();
Vector3d vZ = el.vecZ();
Vector3d vX = vY.crossProduct(vZ);

Point3d ptOnDetailLine = (_PtG[1] + _PtG[0])/2;
if( el.bIsKindOf(ElementRoof()) ){
	ElementRoof elR = (ElementRoof)el;
	ElemRoofEdge arElRoofEdge[]=elR.elemRoofEdges();
	
	Vector3d arVDirection[0];
	Point3d arPtNode[0];
	Point3d arPtNodeOther[0];
	String arSDetail[0];
	
	for( int j=0;j<arElRoofEdge.length();j++ ){
		ElemRoofEdge elRoofEdge = arElRoofEdge[j];
		arVDirection.append(elRoofEdge.vecDir());
		arPtNode.append(elRoofEdge.ptNode());
		arPtNodeOther.append(elRoofEdge.ptNodeOther());
		arSDetail.append(elRoofEdge.constrDetail());
	}
	
	// Add the suporting details....
	double arDHSupportingDetail[0];
	String arSSupportingDetail[0];
	arDHSupportingDetail.append(elR.dKneeWallHeight());		arSSupportingDetail.append(elR.constrDetailKneeWall());
	arDHSupportingDetail.append(elR.dKneeWallHeight2());	arSSupportingDetail.append(elR.constrDetailKneeWall2());
	arDHSupportingDetail.append(elR.dWallPlateHeight());		arSSupportingDetail.append(elR.constrDetailWallPlate());
	arDHSupportingDetail.append(elR.dWallPlateHeight2());	arSSupportingDetail.append(elR.constrDetailWallPlate2());
	arDHSupportingDetail.append(elR.dStrutHeight());			arSSupportingDetail.append(elR.constrDetailStrut());
	arDHSupportingDetail.append(elR.dStrutHeight2());			arSSupportingDetail.append(elR.constrDetailStrut2());
	
	for (int j=0;j<arDHSupportingDetail.length();j++) {
		double dDetailH = arDHSupportingDetail[j];
		String sDetail = arSSupportingDetail[j];
		if (sDetail.length() == 0)
			continue;
		
		Plane pn(_PtW + _ZW * dDetailH, _ZW);
		Point3d arPtDetail[] = plElOutline.intersectPoints(pn);
		arPtDetail = lnX.orderPoints(arPtDetail);
		
		if (arPtDetail.length() < 2)
			continue;
		
		arVDirection.append(vxEl);
		arPtNode.append(arPtDetail[0]);
		arPtNodeOther.append(arPtDetail[arPtDetail.length() - 1]);
		arSDetail.append(sDetail);
	}
	
	double dMin = U(9999999);
	for( int j=0;j<arVDirection.length();j++ ){
		Vector3d vDirection = arVDirection[j];
		Point3d ptNode = arPtNode[j];
		Point3d ptNodeOther = arPtNodeOther[j];
		String sDetail = arSDetail[j];
		
		if( abs(abs(vY.dotProduct(vDirection)) - 1) < dEps ){
			double dDist = vX.dotProduct(ptOnDetailLine - ptNode);
			if( abs(dDist) < dMin ){
				dMin = abs(dDist);
				_Map.setString("DET", sDetail);
				_PtG[0] = ptNode;
				_PtG[1] = ptNodeOther;
			}
		}
	}
}

//_Pt0 += vY * vY.dotProduct((_PtG[0] + _PtG[1])/2 - _Pt0);
//Line ln(_PtG[0], vY);
//for( int i=0;i<_PtG.length();i++ ){
	//_PtG[i] = ln.closestPointTo(_PtG[i]);
//}

// Set properties if this tsl was inserted from DSP. This check is only done after the first run.
if( setPropsFromDspVariableIndex > -1 ){
	
	String detail;
	if( _Map.hasString("DET") ) {
		detail = _Map.getString("DET");
		
		if (nLog == 1)
			reportNotice(TN("|Catalog name taken from detail|: ")+detail);
	}
	
	String catalogName;
	Map detailMap;
	if (detailMap.setDxContent(detail, true))
	{
		if( setPropsFromDspVariableIndex == 0 )
		{
			catalogName = detailMap.getString("DESCRIPTION");
			
			if (nLog == 1)
				reportNotice(TN("|Catalog name taken dsp variable| ") + setPropsFromDspVariableIndex + T("|Catalog name|: ")+catalogName);
		}
		else
		{
			if (detailMap.hasString("STRVAR" + (setPropsFromDspVariableIndex-1)))
				catalogName = detailMap.getString("STRVAR" + (setPropsFromDspVariableIndex-1));
			else if (detailMap.hasDouble("DVAR" + (setPropsFromDspVariableIndex-1)))
				catalogName = detailMap.getDouble("DVAR" + (setPropsFromDspVariableIndex-1));
						
			if (catalogName == ""){
				reportMessage("\n" + scriptName() + ": " +T("|Catalog specified in| ") + detailMap.getString("DESCRIPTION") + 
					T(" |at| ") + "VAR" + setPropsFromDspVariableIndex + T(" |not found at element| ")  +  el.number() + ".");
				eraseInstance();
				return;
			}
			
			if (nLog == 1)
				reportNotice(TN("|Catalog found|: ")  + catalogName);
		}
	}
	else{
		catalogName = catalogName.token(setPropsFromDspVariableIndex);
		
		if (nLog == 1)
			reportNotice(TN("|Catalog name taken from index|: ")+ setPropsFromDspVariableIndex + " = " + catalogName);
	}
	
	if (catalogName == "" ) 
	{
		reportMessage("\n" + scriptName() + ": " +T("|Catalogname not found|"));
		eraseInstance();
		return;
	}
	
	int propsSet = setPropValuesFromCatalog(catalogName);
	
	if (detailName.left(5) == "@(VAR")
	{
		int variableIndex = detailName.mid(5, detailName.length() - 6).atoi() - 1;
		
		String resolvedName = detailName;
		if (detailMap.hasDouble("DVAR" + variableIndex))
			resolvedName = detailMap.getDouble("DVAR" + variableIndex);
		else if (detailMap.hasString("STRVAR" + variableIndex))
			resolvedName = detailMap.getString("STRVAR" + variableIndex);
		
		// Set the resolved name. It remains unresolved if it couldn't find it in the detailMap.
		detailName.set(resolvedName);
	}
}

setPropsFromDspVariableIndex > -1;

char chZoneCharacterTube = arChZoneCharacter[arSZoneLayer.find(sZoneLayer,0)];
int znIndex = nZnIndex;
if (znIndex > 5)
	znIndex = 5-znIndex;

double dxFlag = arDTextAlignment[arSTextAlignment.find(sHorizontalTextAlignment, 0)];
int onlyVisibleInTopView = noYes.find(onlyVisibleInTopViewProp,0);

Display dp(textColor);
if (textSize > 0)
	dp.textHeight(textSize);
//dp.dimStyle(sDimStyle);
dp.elemZone(el, znIndex, chZoneCharacterTube);
if(onlyVisibleInTopView)
{ 
	dp.addViewDirection(vzEl);
}
dp.showInDxa(true);

Vector3d vxTxt = vY;
double dx = vxEl.dotProduct(vxTxt);
double dy = vyEl.dotProduct(vxTxt);
if( dx < -dEps ){
	vxTxt *= -1;
}
else if( abs(dx) < dEps && dy < -dEps ){
	vxTxt *= -1;
}

Vector3d vyTxt = vzEl.crossProduct(vxTxt);
vxTxt.vis(_Pt0, 1);

int nSide = 1;
if( vX.dotProduct(vyTxt) > 0 )
	nSide *= -1;

String sInfoToDraw[0];
if(sDescription!="") sInfoToDraw.append(sDescription);
if(sExtraDescription!="") sInfoToDraw.append(sExtraDescription);
if(sExtraDescription2!="") sInfoToDraw.append(sExtraDescription2);
if(sExtraDescription3!="") sInfoToDraw.append(sExtraDescription3);
if(sExtraDescription4!="") sInfoToDraw.append(sExtraDescription4);
if(detailName!="") sInfoToDraw.append(detailName);

Point3d ptTxt = _Pt0 + vxTxt * horizontalOffset;
double dSpacing=3;
for (int s=0;s<sInfoToDraw.length();s++) 
{ 
	String sInfo = sInfoToDraw[s]; 
	dp.draw(sInfo, ptTxt , vxTxt, vyTxt, dxFlag, nSide * dSpacing*s, _kDevice);
	 
}
//setExecutionLoops(2);

int bPublishDetailInformation = true;
if (bPublishDetailInformation) {
	Point3d ptDetail = ptOnDetailLine;
	_Map.setPoint3d("Position", ptDetail, _kAbsolute);
	_Map.setPoint3d("Normal", vY, _kAbsolute);
	
	_Map.setString("DetailInfo", detailName + "\n" + sDescription + "\n" + sExtraDescription+ "\n" + sExtraDescription2+ "\n" + sExtraDescription3+ "\n" + sExtraDescription4);
	_Map.setString("DetailName", detailName);
	_Map.setString("Description", sDescription);
	_Map.setString("ExtraDescription", sExtraDescription);
	_Map.setString("ExtraDescription2", sExtraDescription2);
	_Map.setString("ExtraDescription3", sExtraDescription3);
	_Map.setString("ExtraDescription4", sExtraDescription4);
}

// Store detail in MapX of the element.
// Find all other detail tsl's attached to this element.
TslInst arTsl[] = el.tslInst();
String elementDetails[] = {
	detailName
};
for( int i=0;i<arTsl.length();i++ ){
	TslInst tsl = arTsl[i];
	if( tsl.scriptName() != _ThisInst.scriptName() )
		continue;
	
	Map mapTsl = tsl.map();
	if(mapTsl.hasString("DetailName") && elementDetails.find(mapTsl.getString("DetailName")) != -1 )
		continue;
	
	String detailName = mapTsl.getString("DetailName");
	if (detailName != "")
		elementDetails.append(detailName);
}	

Map mapDetails;
for( int i=0;i<elementDetails.length();i++ )
	mapDetails.appendString("Detail", elementDetails[i]);

el.setSubMapX("Details", mapDetails);
#End
#BeginThumbnail


#End