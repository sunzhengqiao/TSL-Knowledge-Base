#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
22.12.2016  -  version 3.00

Description
This tsl adds blocking to the top-trimmer of an opening.
 
Insert
To insert the tsl, one or more elements can be selected. The tsl will insert an instance of itself to each selected element.
The tsl can also be attached to the element definition. If its attached to the element definition it will be executed automatically when the element is generated.




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl adds blocking to the top-trimmer of an opening.
/// </summary>

/// <insert>
/// To insert the tsl, one or more elements can be selected. The tsl will insert an instance of itself to each selected element.
/// The tsl can also be attached to the element definition. If its attached to the element definition it will be executed automatically when the element is generated.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="3.00" date="22.12.2016"></version>

/// <history>
/// AS - 1.00 - 16.04.2012 -	Pilot version
/// AS - 1.01 - 19.04.2012 -	Add blocking on both sides (top, bottom)
/// AS - 1.02 - 19.04.2012 -	Add support for toolpalette
/// AS - 2.00 - 14.02.2013 -	Add to localizer
/// AS - 2.01 - 19.08.2015 -	Add tolerance to find horizontal and vertical beams
/// AS - 2.02 - 21.08.2015 -	Add beam filters
/// AS - 3.00 - 22.12.2016 -	Use HSB_G-FilterGenBeams as filter.
/// </history>

String categories[] = 
{
	T("|Filters|"),
	T("|Blocking|")
};

double dEps = Unit(0.01, "mm");
double dVectorTolerance = U(0.01);

String arSReferenceSide[] = {T("|Outside|"), T("|Inside|")};
int arNReferenceSide[] = {1, -1};

// ---------------------------------------------------------------------------------
PropString sFilterOpening(0, "", T("|Filter openings with description|"));
sFilterOpening.setDescription(T("|Filter openings with specified descriptions|."));
sFilterOpening.setCategory(categories[0]);

// filter beams
String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");

PropString filterDefinition(1, filterDefinitions, T("|Filter definition female beams|"));
filterDefinition.setDescription(T("|Filter definition for beams.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
filterDefinition.setCategory(categories[0]);


PropDouble dBlockingL(0, U(300), T("|Length|"));
dBlockingL.setDescription(T("|Specifies the blocking length|."));
dBlockingL.setCategory(categories[1]);

PropString sReferenceSide(3, arSReferenceSide, T("|Reference side|"));
sReferenceSide.setDescription(T("|Specifies the reference side|."));
sReferenceSide.setCategory(categories[1]);



if( _bOnElementDeleted ){
	eraseInstance();
	return;
}

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_R-OpeningBlocking");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	int nNrOfTslsInserted = 0;
	//Select beam(s) and insertion point
	PrEntity ssE(T("|Select one or more elements|"), Element());
	if (ssE.go()) {
		Element arSelectedElements[] = ssE.elementSet();
		
		//insertion point
		String strScriptName = "HSB_R-OpeningBlocking"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Entity lstEntities[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", true);
		setCatalogFromPropValues("MasterToSatellite");
		mapTsl.setInt("ManualInsert", true);
		for( int i=0;i<arSelectedElements.length();i++ ){
			Element el = arSelectedElements[i];
			lstEntities[0] = el;
			
			TslInst arTsl[] = el.tslInst();
			for( int j=0;j<arTsl.length();j++ ){
				TslInst tsl = arTsl[j];
				if( tsl.scriptName() == strScriptName )
					tsl.dbErase();
			}
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
			nNrOfTslsInserted++;
		}
	}
	
	reportMessage(nNrOfTslsInserted + T(" |tsl(s) inserted|"));
	
	eraseInstance();
	return;
}
// set properties from master
if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", true);
	}
}
int bManualInsert = false;
if( _Map.hasInt("ManualInsert") ){
	bManualInsert = _Map.getInt("ManualInsert");
	_Map.removeAt("ManualInsert", true);
}

if( _Element.length() == 0 ){
	reportMessage(TN("|Invalid selection|!"));
	eraseInstance();
	return;
}

String sFOpening = sFilterOpening + ";";
sFOpening.makeUpper();
String arSFOpening[0];
int nIndexOpening = 0; 
int sIndexOpening = 0;
while(sIndexOpening < sFOpening.length()-1){
	String sTokenOpening = sFOpening.token(nIndexOpening);
	nIndexOpening++;
	if(sTokenOpening.length()==0){
		sIndexOpening++;
		continue;
	}
	sIndexOpening = sFilterOpening.find(sTokenOpening,0);

	arSFOpening.append(sTokenOpening);
}

int nReferenceSide = arNReferenceSide[arSReferenceSide.find(sReferenceSide,0)];

Element el = _Element[0];
CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
_Pt0 = ptEl;

Line lnElY(ptEl, vyEl);

PlaneProfile ppEl(csEl);
ppEl = el.profNetto(0);

PLine arPlEl[] = ppEl.allRings();
int arIsOpening[] = ppEl.ringIsOpening();

Plane pnElZMid(ptEl - vzEl * .5 * el.zone(0).dH(), vzEl);

Plane pnElReference = pnElZMid;
pnElReference.transformBy(vzEl * nReferenceSide * .5 * el.zone(0).dH());


Group grpEl = el.elementGroup();
Group grpFloor(grpEl.namePart(0), grpEl.namePart(1), "" );
Entity arEntOpRf[] = grpFloor.collectEntities(true, OpeningRoof(), _kModelSpace);
OpeningRoof arOpRf[0];
PLine arPlOp[0];
Point3d arPtOp[0];
String arSOpDescription[0];
for( int i=0;i<arEntOpRf.length();i++ ){
	Entity ent = arEntOpRf[i];
	OpeningRoof opRf = (OpeningRoof)ent;
	if( !opRf.bIsValid() )
		continue;
	
	Point3d ptOpRf = Body(opRf.plShape(), _ZW).ptCen();
	Line lnOpRfZ(ptOpRf, _ZW);
	ptOpRf = lnOpRfZ.intersect(pnElZMid,U(0));
	
	for( int j=0;j<arPlEl.length();j++ ){
		PLine plEl = arPlEl[j];
		int isOpening = arIsOpening[j];
		
		if( !isOpening )
			continue;
		
		PlaneProfile ppOp(csEl);
		ppOp.joinRing(plEl, _kAdd);
		
		if( ppOp.pointInProfile(ptOpRf) == _kPointInProfile ){
			arOpRf.append(opRf);
			
			plEl.vis();
			
			arPlOp.append(plEl);
			arPtOp.append(ptOpRf);
			arSOpDescription.append(opRf.description());
			break;
		}
	}	
}

GenBeam genBeams[] = el.genBeam();
Beam arBmHor[0];
Beam arBmVer[0];
Beam arBmOther[0];
Beam arBm[0];
Sheet arSh[0];

Entity genBeamEntities[0];
for (int b=0;b<genBeams.length();b++)
	genBeamEntities.append(genBeams[b]);

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, filterDefinition, filterGenBeamsMap);
if (!successfullyFiltered) {
	reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
} 
genBeamEntities = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
for (int e=0;e<genBeamEntities.length();e++) 
{
	Beam bm = (Beam)genBeamEntities[e];
	Sheet sh = (Sheet)genBeamEntities[e];

	if( sh.bIsValid() )
		arSh.append(sh);
		
	else if( bm.bIsValid() ){
		if( abs(bm.vecX().dotProduct(vyEl)) < dVectorTolerance ){
			arBmHor.append(bm);
		}
		else if( abs(bm.vecX().dotProduct(vxEl)) < dVectorTolerance ){
			arBmVer.append(bm);
		}
		else{
			arBmOther.append(bm);
		}
	}
}
arBm.append(arBmHor);
arBm.append(arBmVer);
arBm.append(arBmOther);


for( int i=0;i<arPtOp.length();i++ ){
	Point3d ptOp = arPtOp[i];
	
	ptOp.vis(3);

	int arNSide[] = {-1, 1};
	for( int j=0;j<arNSide.length();j++ ){
		int nOpSide = arNSide[j];
		
		Beam arBmTopBottom[] = Beam().filterBeamsHalfLineIntersectSort(arBmHor, ptOp, vyEl * nOpSide);
		if( arBmTopBottom.length() == 0 )
			continue;
		
		Beam bmTB = arBmTopBottom[0];
		
		bmTB.envelopeBody().vis(1);
		bmTB.ptCen().vis(1);

		CoordSys csBm = bmTB.coordSys();
		Vector3d vxBm = csBm.vecX();
		Vector3d vyBm = csBm.vecY();
		Vector3d vzBm = csBm.vecZ();
		
		double dBmW = bmTB.dW();
		double dBmH = bmTB.dH();
		if( dBmW > dBmH ){
			double dTmp = dBmW;
			dBmW = dBmH;
			dBmH = dTmp;
			
			Vector3d vTmp = vyBm;
			vyBm = vzBm;
			vzBm = vyBm;
		}
		
		if( vyBm.dotProduct(vyEl) < 0 )
			vyBm *= -1;
		
		Line lnBmTB(bmTB.ptCen(), vxBm);
		
		// Find rafters on both sides
		for( int k=0;k<arNSide.length();k++ ){
			int nSide = arNSide[k];
			Beam arBmRafterSide[] = Beam().filterBeamsHalfLineIntersectSort(arBmVer, bmTB.ptCenSolid() + nSide * vxEl * 0.45 * bmTB.solidLength(), nSide * vxEl);
			if( arBmRafterSide.length() == 0 )
				continue;
			Beam bmRafter = arBmRafterSide[0];
			bmRafter.envelopeBody().vis(i);
			
			Point3d ptBlock = lnBmTB.intersect(Plane(bmRafter.ptCen(), vxEl), 0);
			ptBlock += vyBm * nOpSide * 0.5 * bmTB.dD(vyBm);
			ptBlock += vyEl * nOpSide * dBlockingL;
			
			ptBlock = Line(ptBlock, vzBm).intersect(pnElReference, 0);
			ptBlock.vis(j+1);
			
			Beam bmBlock;
			bmBlock.dbCreate(ptBlock, -vyEl, vxEl, vzEl, dBlockingL, bmRafter.dD(vxEl), bmRafter.dD(vzEl), nOpSide, -2 * nSide, -nReferenceSide);
			bmBlock.assignToElementGroup(el, true, 0, 'Z');
			bmBlock.setColor(32);
			bmBlock.setType(_kBlocking);
			bmBlock.setBeamCode("BLK-OP");
			bmBlock.stretchStaticTo(bmTB, _kStretchOnInsert);
		}
	}
}

if(_bOnElementConstructed || bManualInsert )
	eraseInstance();

// visualisation
int nColor(4);
double dSymbolSize = U(40);
Display dpVisualisation(nColor);

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





#End
#BeginThumbnail
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
89$6-%1%"JHPJJ,`#TIU%%2<P4444`?_9
`


#End