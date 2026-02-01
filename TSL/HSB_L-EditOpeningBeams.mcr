#Version 8
#BeginDescription
Last modified by: Ronald van Wijngaarden (support.nl@hsbcad.com)
18.02.2019  -  version 1.03

Description
This tsl adds cuts to the beams that end inside an opening.
 
Insert
Select one or more elements. Or select on or more openings.
 
Remarks
-.







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl adds the required tooling for fitting a beam in a log wall.
/// </summary>

/// <insert>
/// Select an element and a set of beams
/// </insert>

/// <remark Lang=en>
/// The notch is exported to the element as elemItem.
/// </remark>

/// <version  value="1.03" date="18.02.2019"></version>

/// <history>
/// AS - 1.00 - 26.11.2012 - 	Pilot version
/// AS - 1.01 - 29.11.2012 - 	Add symbol
/// RVW - 1.02 - 12.02.2019 -	Add option to select an individual opening. And check if in the element or opening there already is an tslinstance present, if so erase it.
/// RVW - 1.03 - 18.02.2019 -	Change centerpoint of beam regarding the tongueheight. Calculate centerpoint from beam bottom point + (total beamheight minus tongueheight divided by 2). 
/// </history>

double dEps = Unit(0.01,"mm");

String lastInserted = "_LastInserted";
String arUserSelect[] = { T("|Elements|"), T("|Opening|")};

String categories[] =
{
	T("|Selection set|"),
	T("|Cut & Symbol|")
};

PropString sUserSelect(2, arUserSelect, T("|Select elements or openings|"));	
sUserSelect.setDescription(T("|Choose if tsl has to be executed on set of elements or set of openings.|"));
sUserSelect.setCategory(categories[0]);

PropString sSeperator01(0, "", T("|Cut|"));
sSeperator01.setReadOnly(true);
sSeperator01.setCategory(categories[1]);
PropDouble dOffsetCut(0,U(7), "     "+T("|Offset cut|"));
dOffsetCut.setCategory(categories[1]);
PropDouble dAngleCut(1,45, "     "+T("|Angle cut|"));
dAngleCut.setCategory(categories[1]);

PropString sSeperator02(1, "", T("|Symbol|"));
sSeperator02.setReadOnly(true);
sSeperator02.setCategory(categories[1]);
PropDouble dSymbolOffset (2,U(15), "     "+T("|Symbol size|"));
dSymbolOffset.setCategory(categories[1]);
PropInt nSymbolColor(0, 1, "     "+T("|Symbol color|"));
nSymbolColor.setCategory(categories[1]);

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_L-EditOpeningBeams");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);


String strScriptName = "HSB_L-EditOpeningBeams"; //name of the script
Vector3d vecUcsX(1, 0, 0);
Vector3d vecUcsY(0, 1, 0);
Beam lstBeams[0];
Opening lstOpenings[1];

Point3d lstPoints[0];
int lstPropInt[0];
double lstPropDouble[0];
String lstPropString[0];
Map mapTsl;


if ( _bOnInsert )
{
	if ( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
	{
		showDialog();
		setCatalogFromPropValues(lastInserted);
	}
		
	int iUserSelect = arUserSelect.find(sUserSelect);
	String strScriptName = scriptName();
	
	Opening selectedOpenings[0];
	
	
	if (iUserSelect == 0)
	{
		PrEntity ssE(T("|Select a set of elements|"), Element());
		if ( ssE.go() ) 
		{
			Element arSelectedElements[] = ssE.elementSet();
			for ( int i = 0; i < arSelectedElements.length(); i++) 
			{
				Element selectedEl = arSelectedElements[i];
				selectedOpenings.append(selectedEl.opening());
				
				TslInst arTsl[] = selectedEl.tslInst();
			
				for ( int j = 0; j < arTsl.length(); j++)
				{
					TslInst tsl = arTsl[j];
					if ( ! tsl.bIsValid() || (tsl.scriptName() == strScriptName))
					{
					tsl.dbErase();
					}
				}				
			}
		}
	}
		
	else if (iUserSelect == 1)
	{
		PrEntity ssO(T("|Select a set of openings|"), Opening());
		if ( ssO.go() ) 
		{
			Entity openingsAsEntity[] = ssO.set();
			for (int j = 0; j < openingsAsEntity.length();j++)
			{
				Opening op = (Opening)openingsAsEntity[j];
				if ( ! op.bIsValid()) continue;
				
				selectedOpenings.append(op);
				TslInst arTsl[] = op.tslInstAttached();

				for ( int j = 0; j < arTsl.length(); j++)
				{
					TslInst tsl = arTsl[j];
					if ( ! tsl.bIsValid() || (tsl.scriptName() == strScriptName))
					{
					tsl.dbErase();
					}
				}		
			}
		}
	}
		
	for ( int i = 0; i < selectedOpenings.length(); i++) 
	{
		Opening selectedOp = selectedOpenings[i];
		lstOpenings[0] = selectedOp;
		
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX, vecUcsY, lstBeams, lstOpenings, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	}
	
	eraseInstance();
	return;		
}

if( _Opening.length() == 0 )
{
	reportMessage(TN("|No openings attached to the selected element|!"));
	eraseInstance();
	return;
}

if (_bOnDbCreated)
{
	setPropValuesFromCatalog(lastInserted);
}

Opening op = _Opening[0];

Element el = op.element();
ElementLog elLog = (ElementLog)el;
if( !elLog.bIsValid() )
	return;

Display dpSymbol(nSymbolColor);
dpSymbol.elemZone(elLog, 0, 'T');

_ThisInst.assignToElementGroup(elLog, true, 0, 'T');

// coordsys of the element, determination of side, and repositioning of point
CoordSys csEl= elLog.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
_Pt0 = ptEl;

PLine plOp = op.plShape();
plOp.vis();

PlaneProfile ppOp(csEl);
ppOp.joinRing(plOp, _kAdd);
ppOp.shrink(-U(10));

Beam arBm[] = elLog.beam();

for ( int i = 0; i < arBm.length(); i++) {
	Beam bm = arBm[i];
	String bmExtrPr = bm.extrProfile();
	ExtrProfile extrusionProfile(bmExtrPr);
	double tongueHeight = extrusionProfile.dTongueHeight();
	
	Point3d bmPtBottom = bm.ptCenSolid() - bm.vecZ() * 0.5 * bm.solidHeight();
	Point3d nwPtCenter = bmPtBottom + bm.vecZ() * (bm.solidHeight() - tongueHeight) / 2;
	Point3d ptBmMax = nwPtCenter + bm.vecX() * 0.5 * bm.solidLength();
	Point3d ptBmMin = nwPtCenter - bm.vecX() * 0.5 * bm.solidLength();
			
	if ( ppOp.pointInProfile(ptBmMax) == _kPointInProfile ) {
		bm.envelopeBody(false, true).vis(4);
		Point3d ptCut = ptBmMax + vyEl * dOffsetCut;
		Vector3d vCut = bm.vecX().rotateBy(dAngleCut, vzEl);
		ptBmMax.vis(1);
		vCut.vis(ptCut, 1);
		Cut cut(ptCut, vCut);
		bm.addTool(cut, _kStretchNot);
		
		// Draw symbol
		Point3d ptArrow = ptCut - bm.vecX() * dSymbolOffset + vyEl * 0.25 * dSymbolOffset;
		PLine plArrow(ptArrow, ptArrow + vCut * 0.75 * dSymbolOffset);
		dpSymbol.draw(plArrow);
		Vector3d vCutPlane = vzEl.crossProduct(vCut);
		PLine plArrowHead(
		ptArrow + vCut * 0.50 * dSymbolOffset + vCutPlane * 0.10 * dSymbolOffset,
		ptArrow + vCut * 0.75 * dSymbolOffset,
		ptArrow + vCut * 0.50 * dSymbolOffset - vCutPlane * 0.10 * dSymbolOffset
		);
		dpSymbol.draw(plArrowHead);
		
		ptCut = ptBmMax - vyEl * dOffsetCut;
		vCut = bm.vecX().rotateBy(-dAngleCut, vzEl);
		
		vCut.vis(ptCut, 3);
		cut = Cut(ptCut, vCut);
		bm.addTool(cut, _kStretchNot);
		
		// Draw symbol
		ptArrow = ptCut - bm.vecX() * dSymbolOffset - vyEl * 0.25 * dSymbolOffset;
		plArrow = PLine(ptArrow, ptArrow + vCut * 0.75 * dSymbolOffset);
		dpSymbol.draw(plArrow);
		vCutPlane = vzEl.crossProduct(vCut);
		plArrowHead = PLine(
		ptArrow + vCut * 0.50 * dSymbolOffset + vCutPlane * 0.10 * dSymbolOffset,
		ptArrow + vCut * 0.75 * dSymbolOffset,
		ptArrow + vCut * 0.50 * dSymbolOffset - vCutPlane * 0.10 * dSymbolOffset
		);
		dpSymbol.draw(plArrowHead);
	}
	if ( ppOp.pointInProfile(ptBmMin) == _kPointInProfile ) {
		bm.envelopeBody(false, true).vis(5);
		Point3d ptCut = ptBmMin + vyEl * dOffsetCut;
		Vector3d vCut = - bm.vecX().rotateBy(-dAngleCut, vzEl);
		ptBmMin.vis(1);
		
		vCut.vis(ptCut, 1);
		Cut cut(ptCut, vCut);
		bm.addTool(cut, _kStretchNot);
		
		// Draw symbol
		Point3d ptArrow = ptCut + bm.vecX() * dSymbolOffset + vyEl * 0.25 * dSymbolOffset;
		PLine plArrow(ptArrow, ptArrow + vCut * 0.75 * dSymbolOffset);
		dpSymbol.draw(plArrow);
		Vector3d vCutPlane = vzEl.crossProduct(vCut);
		PLine plArrowHead(
		ptArrow + vCut * 0.50 * dSymbolOffset + vCutPlane * 0.10 * dSymbolOffset,
		ptArrow + vCut * 0.75 * dSymbolOffset,
		ptArrow + vCut * 0.50 * dSymbolOffset - vCutPlane * 0.10 * dSymbolOffset
		);
		dpSymbol.draw(plArrowHead);
		
		ptCut = ptBmMin - vyEl * dOffsetCut;
		vCut = - bm.vecX().rotateBy(dAngleCut, vzEl);
		
		vCut.vis(ptCut, 3);
		cut = Cut(ptCut, vCut);
		bm.addTool(cut, _kStretchNot);
		
		// Draw symbol
		ptArrow = ptCut + bm.vecX() * dSymbolOffset - vyEl * 0.25 * dSymbolOffset;
		plArrow = PLine(ptArrow, ptArrow + vCut * 0.75 * dSymbolOffset);
		dpSymbol.draw(plArrow);
		vCutPlane = vzEl.crossProduct(vCut);
		plArrowHead = PLine(
		ptArrow + vCut * 0.50 * dSymbolOffset + vCutPlane * 0.10 * dSymbolOffset,
		ptArrow + vCut * 0.75 * dSymbolOffset,
		ptArrow + vCut * 0.50 * dSymbolOffset - vCutPlane * 0.10 * dSymbolOffset
		);
		dpSymbol.draw(plArrowHead);
	}
}

#End
#BeginThumbnail
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
,$''S=>::B)U%8__9


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
  <lst nm="TslInfo">
    <lst nm="TSLINFO">
      <lst nm="TSLINFO" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End