#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
25.06.2019  -  version 3.04








#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 4
#KeyWords 
#BeginContents

/// <summary Lang=en>
/// This tsl adds nail-clusters to the element. The nail clusters are attached to a zone index. There are custom actions available to add and remove no nail areas.
/// The areas are specified by a polyline. The tsl is dependent on this polyline. This means that if the polyline changes the tsl is recalculated.
/// </summary>

/// <insert>
/// Select an element.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="3.04" date="25.06.2019"></version>

/// <history>
/// AS - 2.00 - 16.02.2011 -	Pilot version (base on tsl for Myresjohus)
/// AS - 2.01 - 16.02.2011 -	Add recalc trigger for recalc, add options to create an offset from one of the edges, or center line.
/// AS - 2.02 - 22.02.2011 -	Use referenceLine2 for zone 2
/// AS - 2.03 - 23.03.2011 -	Use solidWidth and -Length to calculate size
/// AS - 2.04 - 11.05.2011 -	Set up a nail area. Subtract openings and no nail areas from this area.
///									Add the option to add and remove no nail areas by selecting plines. Set dependency on those selected plines.
/// AS - 2.05 - 29.09.2011 -	Assign to specific layer
/// AS - 2.06 - 23.11.2011 -	Add option to change the size of a brander at a sheet joint.
/// AS - 2.07 - 10.11.2014 -	Add branders to frame profile
/// AS - 3.00 - 22.04.2015 -	Add nailclusters per sheet.
/// AS - 3.01 - 17.12.2015 -	Add zone 0 as possible brander.
/// RP - 3.02 - 14.02.2019 -	Different check against the element, was causing issues on mirroring
/// RP - 3.03 - 25.06.2019 -	Wrong vector was copied with previous fix
/// AS - 3.04 - 25.06.2019 -	Correct vector again
/// </history>

int executeMode = 0;
// 0 = default
// 1 = recalc/insert

PropString sBranderZoneSeparator(0, "", T("Brander"));
sBranderZoneSeparator.setReadOnly(true);
int arNBranderZone[] = {4,3,2,1,6,7,8,9,0};
PropInt nBranderZone(0, arNBranderZone, "     " + T("|Brander zone|"),1);
PropDouble dToEdgeBrander(0, U(0), "     " + T("Distance to edge of branders"));

PropString sFacadeZone1Separator(1, "", T("Facade zone 1"));
sFacadeZone1Separator.setReadOnly(true);
int arNFacadeZone[] = {99,5,4,3,2,7,8,9};
PropInt nFacadeZone01(1, arNFacadeZone, "     " + T("|Facade zone 1 (99 = no nail)|"),2);
PropInt nToolIndexFacade01(2, 4, "     " + T("|Tool index facade 1|"));
PropDouble dToEdgeFacade01(1, U(25), "     " + T("Distance to edge of facade 1"));
PropDouble dDistBetweenNailsFacade01(2, U(0), "     " + T("Distance between facade 1 nails (0 = 1 nail)"));
String arSReferenceLine[] = {T("|Left (top for horizontal)|"), T("|Center|"), T("|Right (bottom for horizontal)|")};
int arNReferenceLine[] = {1, 0, -1};
PropString sReferenceLineFacade01(2, arSReferenceLine, "     "+T("|Reference line facade 1|"), 1);
PropDouble dReferenceDistanceFacade01(3, U(0), "     "+T("|Offset from reference line facade 1|"));
PropDouble dChangeBranderSizeAtSheetJointTo(7, U(0), "     " + T("|Change brander size at sheet joint to|"));
dChangeBranderSizeAtSheetJointTo.setDescription(T("|Change the brander size at a sheet joint. Zero means that the brander size is not changed.|"));


PropString sFacadeZone02Separator(3, "", T("Facade zone 2"));
sFacadeZone02Separator.setReadOnly(true);
PropInt nFacadeZone02(3, arNFacadeZone, "     " + T("|Facade zone 2 (99 = no nail)|"),1);
PropInt nToolIndexFacade02(4, 5, "     " + T("|Tool index facade 2|"));
PropDouble dToEdgeFacade02(4, U(25), "     " + T("Distance to edge of facade 2"));
PropDouble dDistBetweenNailsFacade02(5, U(0), "     " + T("Distance between facade 2 nails (0 = 1 nail)"));
PropString sReferenceLineFacade02(4, arSReferenceLine, "     "+T("|Reference line facade 2|"), 1);
PropDouble dReferenceDistanceFacade02(6, U(0), "     "+T("|Offset from reference line facade 2|"));


PropString sSeperator01(7, "", T("|General|"));
sSeperator01.setReadOnly(true);
//Display representation to draw the obejct in
PropString sDispRep(5, _ThisInst.dispRepNames(), "     "+T("|Draw in display representation|"));

String sArLayer [] = { T("I-Layer"), T("J-Layer"), T("T-Layer"), T("Z-Layer")};
PropString sLayer(8, sArLayer, "     "+T("|Layer|"));

// filter GenBeams with label
PropString sFilterLabel(6,"","     "+T("Filter beams and sheets with label"));
PropString sFilterMaterial(9,"","     "+T("Filter beams and sheets with material"));
PropString sFilterBeamCode(10,"","     "+T("Filter beams and sheets with beamcode"));


String arSTrigger[] = {
	T("|Recalculate|"),
	T("-------"),
	T("|Add no nail area to facade zone 1|"),
	T("|Add no nail area to facade zone 2|"),
	T("|Remove no nail area|"),
	T("------- ")
}; // Some more triggers are added at the end of the script.
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );

if( _bOnDbCreated && _kExecuteKey != "" )
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	_Element.append(getElement(T("Select an element")));
	
	if( _kExecuteKey == "" )
		showDialog();
	
	_Map.setInt("ExecuteMode", 1);
	return;
}

if( _bOnElementDeleted || _Element.length()==0 ){
	eraseInstance();
	return;
}

ElementWallSF el = (ElementWallSF)_Element[0];
if( !el.bIsValid() ){
	eraseInstance();
	return;
}

//CoordSys element
CoordSys csEl = el.coordSys();
Point3d ptEl  =csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

int nReferenceLineFacade01 = arNReferenceLine[arSReferenceLine.find(sReferenceLineFacade01,2)];
int nReferenceLineFacade02 = arNReferenceLine[arSReferenceLine.find(sReferenceLineFacade02,2)];

int nZnBrander = nBranderZone;
if( nZnBrander > 5 )
	nZnBrander = 5 - nZnBrander;

int nZnFacade01 = nFacadeZone01;
if( nZnFacade01> 5 )
	nZnFacade01 = 5 - nZnFacade01;
	
int nZnFacade02 = nFacadeZone02;
if( nZnFacade02> 5 )
	nZnFacade02 = 5 - nZnFacade02;

String sFLabel = sFilterLabel + ";";
String arSFLabel[0];
int nIndexLabel = 0; 
int sIndexLabel = 0;
while(sIndexLabel < sFLabel.length()-1){
	String sTokenLabel = sFLabel.token(nIndexLabel);
	nIndexLabel++;
	if(sTokenLabel.length()==0){
		sIndexLabel++;
		continue;
	}
	sIndexLabel = sFilterLabel.find(sTokenLabel,0);

	arSFLabel.append(sTokenLabel);
}

String sFMaterial = sFilterMaterial + ";";
String arSFMaterial[0];
int nIndexMaterial = 0; 
int sIndexMaterial = 0;
while(sIndexMaterial < sFMaterial.length()-1){
	String sTokenMaterial = sFMaterial.token(nIndexMaterial);
	nIndexMaterial++;
	if(sTokenMaterial.length()==0){
		sIndexMaterial++;
		continue;
	}
	sIndexMaterial = sFilterMaterial.find(sTokenMaterial,0);

	arSFMaterial.append(sTokenMaterial);
}

String sFBeamCode = sFilterBeamCode + ";";
String arSFBeamCode[0];
int nIndexBeamCode = 0; 
int sIndexBeamCode = 0;
while(sIndexBeamCode < sFBeamCode.length()-1){
	String sTokenBeamCode = sFBeamCode.token(nIndexBeamCode);
	nIndexBeamCode++;
	if(sTokenBeamCode.length()==0){
		sIndexBeamCode++;
		continue;
	}
	sIndexBeamCode = sFilterBeamCode.find(sTokenBeamCode,0);

	arSFBeamCode.append(sTokenBeamCode);
}


if( _kExecuteKey == arSTrigger[2] ||_kExecuteKey == arSTrigger[3] ){// Add no nail area to facade zone 1 or 2
	EntPLine entPlNoNailArea = getEntPLine(T("|Select a polyline|"));
	_Entity.append(entPlNoNailArea);
	executeMode = 1;
}

for( int i=0;i<_Entity.length();i++ ){
	Entity ent = _Entity[i];
	EntPLine entPlNoNailArea = (EntPLine)ent;
	if( !entPlNoNailArea.bIsValid() )
		continue;
	
	setDependencyOnEntity(entPlNoNailArea);
	PLine plNoNailArea = entPlNoNailArea.getPLine();
	Map mapNoNailAreas = _Map.getMap("NoNailAreas");
	Map mapNoNail;
	mapNoNail.setPLine("PLINE", plNoNailArea);
	int nZn = nZnFacade01;
	if( _kExecuteKey == arSTrigger[3] )
		nZn = nZnFacade02;
	mapNoNail.setInt("ZONE", nZn);
	mapNoNail.setEntity("ENTPLINE", entPlNoNailArea);
	mapNoNailAreas.appendMap("NoNailArea", mapNoNail);
	_Map.setMap("NoNailAreas", mapNoNailAreas);

	executeMode = 1;
}

if( _kExecuteKey == arSTrigger[4] ){// Remove no nail area
	Point3d ptNailArea = getPoint(T("|Select a point inside a no nail area|"));
	Map mapNoNailAreas = _Map.getMap("NoNailAreas");
	for( int i=0;i<mapNoNailAreas.length();i++ ){
		if( mapNoNailAreas.hasMap(i) && mapNoNailAreas.keyAt(i) == "NoNailArea" ){
			Map mapNoNail = mapNoNailAreas.getMap(i);
			PLine plNoNailArea = mapNoNail.getPLine("PLINE");
			Entity entPlNoNail = mapNoNail.getEntity("ENTPLINE");
			PlaneProfile ppNoNail(csEl);
			ppNoNail.joinRing(plNoNailArea, _kAdd);
			if( ppNoNail.pointInProfile(ptNailArea) == _kPointInProfile ){
				mapNoNailAreas.removeAt(i, true);
				entPlNoNail.dbErase();
				break;
			}
		}
	}
	_Map.setMap("NoNailAreas", mapNoNailAreas);
	executeMode = 1;
}

Opening arOp[] = el.opening();

double dShrinkFrame = U(10);
PlaneProfile ppFrame(csEl);
ppFrame.joinRing(el.plEnvelope(), _kAdd);
ppFrame.shrink(dShrinkFrame);

GenBeam arGBm[] = el.genBeam();
GenBeam arGBmBrander[0];
Sheet arShFacade01[0];
Sheet arShFacade02[0];

for( int i=0;i<arGBm.length();i++ ){
	GenBeam gBm = arGBm[i];
	
	if( arSFLabel.find(gBm.label()) != -1 )
		continue;
	if( arSFMaterial.find(gBm.material()) != -1 )
		continue;
	if( arSFBeamCode.find(gBm.beamCode()) != -1 )
		continue;
	
	Sheet sh = (Sheet)gBm;
	
	if( gBm.myZoneIndex() == nZnBrander ){//Brander
		arGBmBrander.append(gBm);
		continue;
	}
	
	if (!sh.bIsValid())
		continue;
	
	if( sh.myZoneIndex() == nZnFacade01 ){//Facade 1
		arShFacade01.append(sh);
	}
	else if( sh.myZoneIndex() == nZnFacade02 ){//Facade 2
		arShFacade02.append(sh);
	}
}

for( int i=0;i<arGBmBrander.length();i++ ){
	GenBeam gBmBrander = arGBmBrander[i];
	Sheet sh = (Sheet)gBmBrander;
	if (sh.bIsValid()) 
		ppFrame.unionWith(sh.profShape());
	else 
		ppFrame.unionWith(gBmBrander.envelopeBody(false, true).shadowProfile(Plane(ptEl, vzEl)));
}

double dShrinkOpening = U(5);
PlaneProfile ppOpening(csEl);
for( int i=0;i<arOp.length();i++ )
	ppOpening.joinRing(arOp[i].plShape(), _kAdd);
ppOpening.shrink(dShrinkOpening);

PlaneProfile ppNailArea01(csEl);
ppNailArea01.unionWith(ppFrame);
ppNailArea01.subtractProfile(ppOpening);

PlaneProfile ppNailArea02(csEl);
ppNailArea02.unionWith(ppFrame);
ppNailArea02.subtractProfile(ppOpening);

PlaneProfile ppNoNailArea01(csEl);
PlaneProfile ppNoNailArea02(csEl);

Map mapNoNailAreas = _Map.getMap("NoNailAreas");
for( int i=0;i<mapNoNailAreas.length();i++ ){
	if( mapNoNailAreas.hasMap(i) && mapNoNailAreas.keyAt(i) == "NoNailArea" ){
		Map mapNoNailArea = mapNoNailAreas.getMap(i);
		PLine plNoNailArea = mapNoNailArea.getPLine("PLINE");
		int nZone = mapNoNailArea.getInt("ZONE");
		
		if( nZone == nZnFacade01 )
			ppNoNailArea01.joinRing(plNoNailArea, _kAdd);
		else if( nZone == nZnFacade02 )
			ppNoNailArea02.joinRing(plNoNailArea, _kAdd);
		
		ElemNoNail elNoNailArea(nZone, plNoNailArea);
		el.addTool(elNoNailArea);
	}
}

ppNailArea01.subtractProfile(ppNoNailArea01);
ppNailArea01.vis(3);

if( _Map.hasInt("ExecuteMode") ){
	executeMode = _Map.getInt("ExecuteMode");
	_Map.removeAt("ExecuteMode", true);
}

if( _bOnElementConstructed )
	executeMode = 1;

// recalculate
if( _kExecuteKey == arSTrigger[0] )
	executeMode = 1;

if( executeMode == 1 || _bOnDebug){
	_PtG.setLength(0);
	
	//Remove duplicates
	TslInst arTsl[] = el.tslInst();
	for( int i=0;i<arTsl.length();i++ ){
		TslInst tsl = arTsl[i];
		
		if( tsl.scriptName() == _ThisInst.scriptName() && tsl.handle() != _ThisInst.handle() )
			tsl.dbErase();
	}
	
	double dOffsetXEl = 0;
	
	//Debug - Preview zones that are important for this tsl.
	if( _bOnDebug ){
		int arNValidZones[] = {0, 1, 2, 3, 4};
		GenBeam arGBm[] = el.genBeam();
		Display dp(-1);
		for( int i=0;i<arGBm.length();i++ ){
			GenBeam gBm = arGBm[i];
			if( arNValidZones.find(gBm.myZoneIndex()) != -1 ){
				dp.color(gBm.color());
				dp.draw(gBm.realBody());
			}
		}
	}
	
	
	Point3d arPtToNail[0];
	int arNZoneIndexFromNail[0];
	Display debugDisplay(1);
	for( int i=0;i<arGBmBrander.length();i++ ){
		GenBeam gBmBrander = arGBmBrander[i];
		Sheet shBrander = (Sheet)gBmBrander;
		
		int bChangeSizeOnSheetJoint = true;
		if( dChangeBranderSizeAtSheetJointTo < U(1) && shBrander.bIsValid())
			bChangeSizeOnSheetJoint = false;
		
		PlaneProfile ppBrander(csEl);
		if (shBrander.bIsValid()) 
			ppBrander.unionWith(shBrander.profShape());
		else 
			ppBrander.unionWith(gBmBrander.envelopeBody(false, true).shadowProfile(Plane(ptEl, vzEl)));
		
//		PlaneProfile debug = ppBrander;
//		debug.transformBy(vzEl * i* 100);
//		debugDisplay.draw(debug);
		Point3d arPtBrander[] = ppBrander.getGripVertexPoints();
			
		//Coordsys of sheet in brander zone
		Point3d ptBrander = shBrander.ptCen();
		Vector3d vxBrander = shBrander.vecY();
		Vector3d vyBrander = shBrander.vecX();
		
		Line lnX(ptBrander, vxBrander);
		Line lnY(ptBrander, vyBrander);
		
		Point3d arPtBranderX[] = lnX.orderPoints(arPtBrander);
		Point3d arPtBranderY[] = lnY.orderPoints(arPtBrander);
		if ((arPtBranderX.length() * arPtBranderY.length()) ==  0) {
			reportMessage(T("|Invalid brander in element| " + el.number()));
			continue;
		}
		
		Point3d ptBLBrander = arPtBranderX[0];
		ptBLBrander += vyBrander * vyBrander.dotProduct(arPtBranderY[0] - ptBLBrander);
		Point3d ptTRBrander = arPtBranderX[arPtBranderX.length() - 1];
		ptTRBrander += vyBrander * vyBrander.dotProduct(arPtBranderY[arPtBranderY.length() - 1] - ptTRBrander);
		
		double branderLength = vxBrander.dotProduct(ptTRBrander - ptBLBrander);
		double branderWidth = vyBrander.dotProduct(ptTRBrander - ptBLBrander);
		
		if (branderLength < branderWidth) {
			Vector3d vTmp = vxBrander;
			vxBrander = vyBrander;
			vyBrander = vTmp;
			
			double dTmp = branderLength;
			branderLength = branderWidth;
			branderWidth = dTmp;
		}
		
//		Body bdShBrander = shBrander.realBody();

//		if( bdShBrander.lengthInDirection(vxBrander) < bdShBrander.lengthInDirection(vyBrander) ){
//			vxBrander = shBrander.vecX();
//			vyBrander = shBrander.vecY();
//		}
		Vector3d vzBrander = vxBrander.crossProduct(vyBrander);
		Point3d arPtBranderZ[] = Line(ptBrander, vzBrander).orderPoints(arPtBrander);
		if (arPtBranderZ.length() == 0) {
			reportMessage(T("|Invalid brander in element| " + el.number()));
			continue;
		}
		
		ptBLBrander += vzBrander * vzBrander.dotProduct(arPtBranderZ[0] - ptBLBrander);
		ptTRBrander += vzBrander * vzBrander.dotProduct(arPtBranderZ[arPtBranderZ.length() - 1] - ptTRBrander);
		ptBrander = (ptBLBrander + ptTRBrander)/2;

		CoordSys csBrander(ptBrander, vxBrander, vyBrander, vzBrander);
		csBrander.vis();
		
		Point3d ptMinShBrander = ptBrander - vxBrander * (0.5 * branderLength - dToEdgeBrander);//bdShBrander.ptCen() - vxBrander * (.5 * bdShBrander.lengthInDirection(vxBrander) - dToEdgeBrander); 
		ptMinShBrander.vis(2);
		Point3d ptMaxShBrander = ptBrander + vxBrander * (0.5 * branderLength - dToEdgeBrander);//bdShBrander.ptCen() + vxBrander * (.5 * bdShBrander.lengthInDirection(vxBrander) - dToEdgeBrander); 
		ptMaxShBrander.vis(3);
		Plane pnBrander(ptBrander, vyBrander);
		
		if( abs(branderWidth - dChangeBranderSizeAtSheetJointTo) < U(1) )
			bChangeSizeOnSheetJoint = false;
		
		PlaneProfile ppBranderResult(csEl);
		for( int j=0;j<arShFacade01.length();j++ ){
			Sheet shFacade01 = arShFacade01[j];
			Body bdShFacade01 = shFacade01.realBody();
			
			// Used to find sheet joints
			if( bChangeSizeOnSheetJoint ){
				PlaneProfile ppFacade01(csEl);
				ppFacade01.unionWith(shFacade01.profShape());
				ppFacade01.shrink(U(1));
				ppFacade01.vis(j);
				PlaneProfile ppBranderCopy = ppBrander;
				int bHasIntersection = ppBranderCopy.intersectWith(ppFacade01);
				if( bHasIntersection )
					int bProfilesAreCombined = ppBranderResult.unionWith(ppBranderCopy);
			}
			
			//Coordsys of sheet in facade zone 1
			Point3d ptFacade01 = shFacade01.ptCen();
			Vector3d vxFacade01 = shFacade01.vecY();
			Vector3d vyFacade01 = shFacade01.vecX();
			double dWFacade01 = shFacade01.solidLength();
			if( bdShFacade01.lengthInDirection(vxFacade01) < bdShFacade01.lengthInDirection(vyFacade01) ){
				vxFacade01 = shFacade01.vecX();
				vyFacade01 = shFacade01.vecY();
				dWFacade01 = shFacade01.solidWidth();
			}
			if(vyFacade01.dotProduct(vyEl) < 0 )
			{
				vyFacade01 *= -1;	
			}
			if(vxFacade01.dotProduct(vxEl) < 0 )
			{
				vxFacade01 *= -1;	
			}
			Vector3d vzFacade01 = vxFacade01.crossProduct(vyFacade01);
			CoordSys cs03(ptFacade01, vxFacade01, vyFacade01, vzFacade01);
			cs03.vis();
			
			if( vxFacade01.isPerpendicularTo(vyBrander) )
				continue;
			
			Point3d arPtSh[] = bdShFacade01.allVertices();
			Line lnY(shFacade01.ptCen(), vxFacade01);lnY.vis();
			Point3d arPtShY[] = lnY.projectPoints(arPtSh);
			arPtShY = lnY.orderPoints(arPtShY);
			if( arPtShY.length() < 2 ){
				reportWarning(TN("|Invalid sheet!|"));
				eraseInstance();
				return;
			}
		
			Point3d ptMinShFacade01 = arPtShY[0] + vxFacade01 * dToEdgeFacade01;//bdShFacade01.ptCen() - vyBrander * (.5 * bdShFacade01.lengthInDirection(vyBrander) - dToEdgeFacade01);
			ptMinShFacade01.vis(4);
			Point3d ptMaxShFacade01 = arPtShY[arPtShY.length() - 1] - vxFacade01 * dToEdgeFacade01;//bdShFacade01.ptCen() + vyBrander * (.5 * bdShFacade01.lengthInDirection(vyBrander) - dToEdgeFacade01);
			ptMaxShFacade01.vis(5);
	
			Line lnShFacade01(
				shFacade01.ptCen() + 
				vzEl * .5 * shFacade01.dD(vzEl) + 
				vyFacade01 * nReferenceLineFacade01 * (.5 * dWFacade01 - dReferenceDistanceFacade01) + 
				vxEl * .5 * dOffsetXEl, 
				vxFacade01
			);
			
			lnShFacade01.vis(1);
			
			Point3d ptThisIntersection = lnShFacade01.intersect(pnBrander,0);
			Point3d ptIntersect;
	//		double dMin = abs( vxFacade01.dotProduct(ptThisIntersection - ptMinShFacade01) );
	//		double dMax = abs( vxFacade01.dotProduct(ptThisIntersection - ptMaxShFacade01) );
			if( abs( vxFacade01.dotProduct(ptMinShFacade01 - ptThisIntersection) - dToEdgeFacade01 ) < U(.5) ){
				ptIntersect = ptThisIntersection + vxBrander * (dToEdgeFacade01 + U(.5));
			}
			else if( abs( vxFacade01.dotProduct(ptThisIntersection - ptMaxShFacade01) - dToEdgeFacade01 ) < U(.5) ){
				ptIntersect = ptThisIntersection - vxFacade01 * (dToEdgeFacade01 + U(.5));
			}
			else{
				ptIntersect = ptThisIntersection;
			}
			
			
			if( (vxFacade01.dotProduct(ptMinShFacade01 - ptIntersect) * vxFacade01.dotProduct(ptMaxShFacade01 - ptIntersect)) > 0 )continue;
			

			if( dDistBetweenNailsFacade01 > 0 ){
				Point3d ptNail01(ptIntersect);// - vyFacade01 * .5 * dDistBetweenNailsFacade01);
				double test1 = vxBrander.dotProduct(ptMinShBrander - ptNail01);
				double test2 = vyFacade01.dotProduct(ptMaxShBrander - ptNail01);
				if( (vyFacade01.dotProduct(ptMinShBrander - ptNail01) * vyFacade01.dotProduct(ptMaxShBrander - ptNail01)) < 0 ){
					if( ppNailArea01.pointInProfile(ptNail01) == _kPointInProfile ){
						arPtToNail.append(ptNail01);
						arNZoneIndexFromNail.append(nFacadeZone01);
					}
				}
				Point3d ptNail02(ptIntersect - vyFacade01 * nReferenceLineFacade01 * dDistBetweenNailsFacade01);
				if( (vyFacade01.dotProduct(ptMinShBrander - ptNail02) * vyFacade01.dotProduct(ptMaxShBrander - ptNail02)) < 0 ){
					if( ppNailArea01.pointInProfile(ptNail02) == _kPointInProfile ){
						arPtToNail.append(ptNail02);
						arNZoneIndexFromNail.append(nFacadeZone01);
					}
				}
			}
			else{
				if( (vxBrander.dotProduct(ptMinShBrander - ptIntersect) * vxBrander.dotProduct(ptMaxShBrander - ptIntersect)) < 0 ){
					if( ppNailArea01.pointInProfile(ptIntersect) == _kPointInProfile ){
						arPtToNail.append(ptIntersect);
						arNZoneIndexFromNail.append(nFacadeZone01);
					}
				}
			}
		}
		
		if( bChangeSizeOnSheetJoint  && shBrander.bIsValid()){
			PLine arPlRing[] = ppBranderResult.allRings();
			int arBRingIsOpening[] = ppBranderResult.ringIsOpening();
			
			int bIsOnSheetJoint = false;
			for( int j=0;j<arPlRing.length();j++ ){
				PLine plRing = arPlRing[j];
				Point3d arPtRing[] = plRing.vertexPoints(true);
				
				Point3d ptRingCen = Body(plRing, vzEl).ptCen();
				
				for( int k=0;k<arPlRing.length();k++ ){
					if( k==j )
						continue;
					PLine plOtherRing = arPlRing[k];
					
					for( int k=0;k<arPtRing.length();k++ ){
						Point3d pt = arPtRing[k];
						Vector3d vOffset = vyEl;
						if( vOffset.dotProduct(ptRingCen - pt) < 0 )
							vOffset *= -1;
						
						Line ln(pt + vOffset * U(0.1), vxEl);
						Point3d arPtIntersect[] = plOtherRing.intersectPoints(ln);
						if( arPtIntersect.length() > 1 ){
							bIsOnSheetJoint = true;
							break;
						}
					}
					if( bIsOnSheetJoint )
						break;
				}
				if( bIsOnSheetJoint )
						break;
			}
			
			if( bIsOnSheetJoint ){
				//Display dp(1);
				//dp.draw(ppBranderResult, _kDrawFilled);
				PlaneProfile ppSh = shBrander.profShape();
				//dp.draw(ppSh, _kDrawFilled);
				
				Point3d arPtEdge[] = ppSh.getGripEdgeMidPoints();
				int nIndexLeft = -1;
				int nIndexRight = -1;
				Point3d ptLeft;
				Point3d ptRight;
				for( int j=0;j<arPtEdge.length();j++ ){
					Point3d pt = arPtEdge[j];
					if( nIndexLeft == -1 ){
						nIndexLeft = j;
						ptLeft = pt;
					}
					else{
						if( vyBrander.dotProduct(ptLeft - pt) > U(1) ){
							nIndexLeft = j;
							ptLeft = pt;
						}
					}
					
					if( nIndexRight == -1 ){
						nIndexRight = j;
						ptRight = pt;
					}
					else{
						if( vyBrander.dotProduct(pt - ptRight) > U(1) ){
							nIndexRight = j;
							ptRight = pt;
						}
					}
				}
				
				Vector3d vMove = vyBrander * 0.5 * (dChangeBranderSizeAtSheetJointTo - branderWidth);
				int bLeftMoved = ppSh.moveGripEdgeMidPointAt(nIndexLeft, -vMove);
				int bRightMoved = ppSh.moveGripEdgeMidPointAt(nIndexRight, vMove);
				
				//dp.color(3);
				//dp.draw(ppSh, _kDrawFilled);
				
				Sheet shNewBrander;
				shNewBrander.dbCreate(ppSh, shBrander.dH(), 1);
				shNewBrander.assignToElementGroup(shBrander.element(), true, shBrander.myZoneIndex(), 'Z');
				shNewBrander.setColor(shBrander.color());
				shNewBrander.setMaterial(shBrander.material());
				shNewBrander.setLabel(shBrander.label());
				shNewBrander.setSubLabel(shBrander.subLabel());
				shNewBrander.setGrade(shBrander.grade());
				shNewBrander.setName(shBrander.name());
				
				shBrander.dbErase();
			}
		}

		
		for( int j=0;j<arShFacade02.length();j++ ){
			Sheet shFacade02 = arShFacade02[j];
			Body bdShFacade02 = shFacade02.realBody();
			
			//Coordsys of sheet in facade zone 1
			Point3d ptFacade02 = shFacade02.ptCen();
			Vector3d vxFacade02 = shFacade02.vecY();
			Vector3d vyFacade02 = shFacade02.vecX();
			double dWFacade02 = shFacade02.solidLength();
			if( bdShFacade02.lengthInDirection(vxFacade02) < bdShFacade02.lengthInDirection(vyFacade02) ){
				vxFacade02 = shFacade02.vecX();
				vyFacade02 = shFacade02.vecY();
				dWFacade02 = shFacade02.solidWidth();
			}
			if(vyFacade02.dotProduct(vyEl) < 0 )
			{
				vyFacade02 *= -1;	
			}
			if(vxFacade02.dotProduct(vxEl) < 0 )
			{
				vxFacade02 *= -1;	
			}
	
			Vector3d vzFacade02 = vxFacade02.crossProduct(vyFacade02);
			CoordSys cs03(ptFacade02, vxFacade02, vyFacade02, vzFacade02);
			cs03.vis();
			
			if( vxFacade02.isPerpendicularTo(vyBrander) )
				continue;
			
			Point3d arPtSh[] = bdShFacade02.allVertices();
			Line lnY(shFacade02.ptCen(), vxFacade02);lnY.vis();
			Point3d arPtShY[] = lnY.projectPoints(arPtSh);
			arPtShY = lnY.orderPoints(arPtShY);
			if( arPtShY.length() < 2 ){
				reportWarning(TN("|Invalid sheet!|"));
				eraseInstance();
				return;
			}
		
			Point3d ptMinShFacade02 = arPtShY[0] + vxFacade02 * dToEdgeFacade02;//bdShFacade02.ptCen() - vyBrander * (.5 * bdShFacade02.lengthInDirection(vyBrander) - dToEdgeFacade02);
			ptMinShFacade02.vis(4);
			Point3d ptMaxShFacade02 = arPtShY[arPtShY.length() - 1] - vxFacade02 * dToEdgeFacade02;//bdShFacade02.ptCen() + vyBrander * (.5 * bdShFacade02.lengthInDirection(vyBrander) - dToEdgeFacade02);
			ptMaxShFacade02.vis(5);
	
			Line lnShFacade02(
				shFacade02.ptCen() + 
				vzEl * .5 * shFacade02.dD(vzEl) + 
				vyFacade02 * nReferenceLineFacade02 * (.5 * dWFacade02 - dReferenceDistanceFacade02) + 
				vxEl * .5 * dOffsetXEl, 
				vxFacade02
			);
			Point3d ptThisIntersection = lnShFacade02.intersect(pnBrander,0);
			Point3d ptIntersect;
	//		double dMin = abs( vxFacade02.dotProduct(ptThisIntersection - ptMinShFacade02) );
	//		double dMax = abs( vxFacade02.dotProduct(ptThisIntersection - ptMaxShFacade02) );
			if( abs( vxFacade02.dotProduct(ptMinShFacade02 - ptThisIntersection) - dToEdgeFacade02 ) < U(.5) ){
				ptIntersect = ptThisIntersection + vxBrander * (dToEdgeFacade02 + U(.5));
			}
			else if( abs( vxFacade02.dotProduct(ptThisIntersection - ptMaxShFacade02) - dToEdgeFacade02 ) < U(.5) ){
				ptIntersect = ptThisIntersection - vxFacade02 * (dToEdgeFacade02 + U(.5));
			}
			else{
				ptIntersect = ptThisIntersection;
			}
			
						
			if( (vxFacade02.dotProduct(ptMinShFacade02 - ptIntersect) * vxFacade02.dotProduct(ptMaxShFacade02 - ptIntersect)) > 0 )continue;
			
			if( dDistBetweenNailsFacade02 > 0 ){
				Point3d ptNail01(ptIntersect);// - vyFacade02 * .5 * dDistBetweenNailsFacade02);
				if( (vyFacade02.dotProduct(ptMinShBrander - ptNail01) * vyFacade02.dotProduct(ptMaxShBrander - ptNail01)) < 0 ){
					if( ppNailArea02.pointInProfile(ptNail01) == _kPointInProfile ){
						arPtToNail.append(ptNail01);
						arNZoneIndexFromNail.append(nFacadeZone02);
					}
				}
				Point3d ptNail02(ptIntersect - vyFacade02 * nReferenceLineFacade02 * dDistBetweenNailsFacade02);
				if( (vyFacade02.dotProduct(ptMinShBrander - ptNail02) * vyFacade02.dotProduct(ptMaxShBrander - ptNail02)) < 0 ){
					if( ppNailArea02.pointInProfile(ptNail02) == _kPointInProfile ){
						arPtToNail.append(ptNail02);
						arNZoneIndexFromNail.append(nFacadeZone02);
					}
				}
			}
			else{
				if( (vxBrander.dotProduct(ptMinShBrander - ptIntersect) * vxBrander.dotProduct(ptMaxShBrander - ptIntersect)) < 0 ){
					if( ppNailArea02.pointInProfile(ptIntersect) == _kPointInProfile ){
						arPtToNail.append(ptIntersect);
						arNZoneIndexFromNail.append(nFacadeZone02);
					}
				}
			}
		}
	}
	
	if( _PtG.length() == 0 ){
		_PtG.append(arPtToNail);
	
		_Map = Map();
		for( int i=0;i<arNZoneIndexFromNail.length();i++ ){
			_Map.setInt(String(i), arNZoneIndexFromNail[i]);
		}
	}
	else{
		_Pt0 = _PtG[0];
	}
}

// add special context menu action to trigger the regeneration of the constuction
String sTriggerAddNailFacade01 = T("Add nail to facade zone 1");
addRecalcTrigger(_kContext, sTriggerAddNailFacade01 );
String sTriggerAddNailFacade02 = T("Add nail to facade zone 2");
addRecalcTrigger(_kContext, sTriggerAddNailFacade02 );
String sTriggerRemoveNail = T("Remove nail");
addRecalcTrigger(_kContext, sTriggerRemoveNail );

if( _kExecuteKey==sTriggerAddNailFacade01 ){
	Point3d ptNewNail = getPoint(T("Select a point to add to facade zone 1"));
	if( ppNailArea01.pointInProfile(ptNewNail) != _kPointInProfile ){
		reportWarning(TN("|There is no frame behind this nail.|"));
		return;
	}
	_PtG.append(ptNewNail);
	_Map.setInt((_PtG.length() - 1), nFacadeZone01);
}

if( _kExecuteKey==sTriggerAddNailFacade02 ){
	Point3d ptNewNail = getPoint(T("Select a point to add to facade zone 2"));
	if( ppNailArea02.pointInProfile(ptNewNail) != _kPointInProfile ){
		reportWarning(TN("|There is no frame behind this nail.|"));
		return;
	}
	_PtG.append(ptNewNail);
	_Map.setInt((_PtG.length() - 1), nFacadeZone02);
}

if( _kExecuteKey==sTriggerRemoveNail ){
	Point3d ptToRemove = getPoint(T("Select a point to remove"));
	
	if( !_Map.hasInt( String(_PtG.length()-1) ) ){
		reportError(T("\nInternal error!\nIndexes don't match grippoints"));
	}
	
	Point3d arPtNailTmp[0];
	int arNZoneIndexFromNailTmp[0];
	for( int i=0;i<_PtG.length();i++ ){
		Point3d pt = _PtG[i];
		if( !_Map.hasInt(String(i)) )reportError(T("\nInternal error!\nIndex not found in map"));
		int nZone = _Map.getInt(String(i));
//		if( nZone != 3 ){
//			arPtNailTmp.append(pt);
//			arNZoneIndexFromNailTmp.append(nZone);
//			continue;
//		}
		
		if( Vector3d(pt - (ptToRemove + vzEl * vzEl.dotProduct(pt - ptToRemove))).length() > U(5) ){
			arPtNailTmp.append(pt);
			arNZoneIndexFromNailTmp.append(nZone);
		}
		else{
			//Point to remove is found
			
		}
	}
	
	_PtG.setLength(0);
	_PtG.append(arPtNailTmp);
	
	_Map = Map();
	for( int i=0;i<arNZoneIndexFromNailTmp.length();i++ ){
		_Map.setInt(String(i), arNZoneIndexFromNailTmp[i]);
	}
}
 
Point3d arPtToNailFacade01[0];
Point3d arPtToNailFacade02[0];

Display dpFacade01(-1);
Display dpFacade02(-1);

if (el.bIsValid()){
	// assigning
	if (sLayer == sArLayer[0])
		assignToElementGroup(el, TRUE, 0, 'I');
	else if (sLayer == sArLayer[1])
		assignToElementGroup(el, TRUE, 0, 'J');
	else if (sLayer == sArLayer[2])
		assignToElementGroup(el, TRUE, 0, 'T');
	else if (sLayer == sArLayer[3])
		assignToElementGroup(el, TRUE, 0, 'Z');

	if (sLayer == sArLayer[0])
		dpFacade01.elemZone(el, nZnFacade01, 'I'); 
	else if (sLayer == sArLayer[1])
		dpFacade01.elemZone(el, nZnFacade01, 'J');
	else if (sLayer == sArLayer[2])
		dpFacade01.elemZone(el, nZnFacade01, 'T');
	else if (sLayer == sArLayer[3])
		dpFacade01.elemZone(el, nZnFacade01, 'Z');
		
	if (sLayer == sArLayer[0])
		dpFacade02.elemZone(el, nZnFacade02, 'I'); 
	else if (sLayer == sArLayer[1])
		dpFacade02.elemZone(el, nZnFacade02, 'J');
	else if (sLayer == sArLayer[2])
		dpFacade02.elemZone(el, nZnFacade02, 'T');
	else if (sLayer == sArLayer[3])
		dpFacade02.elemZone(el, nZnFacade02, 'Z');
}

dpFacade01.textHeight(U(10));
dpFacade01.showInDispRep(sDispRep);

dpFacade02.textHeight(U(10));
dpFacade02.showInDispRep(sDispRep);

for( int i=0;i<_PtG.length();i++ ){
	Point3d pt = _PtG[i];
	if( !_Map.hasInt(String(i)) )reportError(T("\nInternal error!\nIndex not found in map"));
	int nIndex = _Map.getInt(String(i));

//	int nIndex = arNZoneIndexFromNail[i];
	
	if( nIndex==nFacadeZone01 ){
		arPtToNailFacade01.append(pt);
		//dpFacade01.draw(i, pt, vxEl, vyEl, 0, 0, _kDevice);
		dpFacade01.draw(nFacadeZone01, pt, vxEl, vyEl, 0, 0, _kDevice);
	}
	else if( nIndex==nFacadeZone02 ){
		arPtToNailFacade02.append(pt);
		dpFacade02.draw(nFacadeZone02, pt, vxEl, vyEl, 0, 0, _kDevice);
	}
	else{
		reportError(T("\nPoint at wrong zone in element ") + el.code() + el.number());
	}
}

if( arPtToNailFacade01.length() > 0 ){
	for (int i=0;i<arShFacade01.length();i++ ){
		Sheet sh = arShFacade01[i];
		PlaneProfile ppSh = sh.profShape();
		
		Point3d arPtNail[0];
		for (int p=0;p<arPtToNailFacade01.length();p++) {
			Point3d pt = arPtToNailFacade01[p];
			if (ppSh.pointInProfile(pt) == _kPointInProfile)
				arPtNail.append(pt);
		}

		if (arPtNail.length() == 0)
			continue;
		ElemNailCluster elNailClusterForFacade01( nZnFacade01, arPtNail, nToolIndexFacade01 );
		el.addTool(elNailClusterForFacade01);
	}
}

if( arPtToNailFacade02.length() > 0 ){
	for (int i=0;i<arShFacade02.length();i++ ){
		Sheet sh = arShFacade02[i];
		PlaneProfile ppSh = sh.profShape();
		
		Point3d arPtNail[0];
		for (int p=0;p<arPtToNailFacade02.length();p++) {
			Point3d pt = arPtToNailFacade02[p];
			if (ppSh.pointInProfile(pt) == _kPointInProfile)
				arPtNail.append(pt);
		}

		if (arPtNail.length() == 0)
			continue;
		ElemNailCluster elNailClusterForFacade02( nZnFacade02, arPtNail, nToolIndexFacade02 );
		el.addTool(elNailClusterForFacade02);
	}
}













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