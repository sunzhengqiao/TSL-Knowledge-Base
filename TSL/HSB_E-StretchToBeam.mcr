#Version 8
#BeginDescription
Last modified by: David De Lombaerde (david.delombaerde@hsbcad.com)
Stretch or cut horizontal beam to angled top plate
27.03.2020  -  version 2.04


















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 4
#KeyWords 
#BeginContents
//region History

/// <version  value="2.04" date="27.03.2020">Stretch horizontal beam to an angled top plate.</version>

//region Older Versions

	/// AS - 1.00 - 04.04.2011 -	Pilot version
	/// AS - 1.01 - 05.04.2011 -	Translate and add thumb
	/// AS - 1.02 - 11.04.2011 -	Add option to 'cut at' a beam instead of only 'stretch to' a beam
	/// AS - 1.03 - 08.07.2011 -	Add option to stretch to beamtype too.
	/// AS - 1.04 - 11.07.2011 -	Fix stretch to beam type
	/// AS - 1.05 - 21.10.2011 -	Chech intersection from center if stretchmode is set to cut.
	/// AS - 1.06 - 06.12.2011 -	Add support for wildcards
	/// AS - 1.07 - 28.07.2015 -	Add support for Walls
	/// AS - 2.00 - 04.01.2016 -	Rename from HSB-Stretch to beam to HSB_E-StretchToBeam.
	///							Add categories, change description, update insert routine.
	/// RP - 2.01 - 26.07.2017 -	Also stretch of beam if beam to stretch goes through the beam to strech to.
	/// AS - 2.02 - 31.07.2017 -	Add stretch margin as property.
	/// AS - 2.03 - 11.01.2018 -	Add stretch to margin.

//End Older Versions//endregion 

/// <summary Lang=en>
/// This tsl stretches one beam to another. The tsll can be attached to the element definition. 
/// The tsl can be attached to a dsp detail (not preferred because of possible duplicates). The catalog name can be passed to the tsl by specifing it as argument in the dsp detail: "DspToTsl;<catalogname>".
/// </summary>

/// <insert>
/// Select a set of elements. The tsl is reinserted for each element.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

//End History//endregion 

//region Constants
	
	//Script uses mm
	double dEps = U(.001,"mm");

	String categories[] = {
		T("|Beam to stretch|"),
		T("|Stretch to|"),
		T("|Stretch mode|")
	};

	PropInt sequenceNumber(0, 0, T("|Sequence number|"));
	sequenceNumber.setDescription(T("|The sequence number is used to sort the list of tsl's during generate construction|"));	

//End Constants//endregion 

//region Properties
		
	PropString sBmCodeToStretch(0, "ZSP-02", T("|Beamcode to stretch|"));
	sBmCodeToStretch.setCategory(categories[0]);
	
	String arSStretchTo[] = {T("|Code|"), T("|Type|")};
	PropString sStretchTo(1, arSStretchTo, T("|Stretch to|"));
	sStretchTo.setCategory(categories[1]);
	PropString sCodeToStretchTo(2, "KRL-07", T("|Stretch to code|"));
	sCodeToStretchTo.setCategory(categories[1]);
	PropString sTypeToStretchTo(3, _BeamTypes, T("|Stretch to type|"));
	sTypeToStretchTo.setCategory(categories[1]);
	
	String arSStretchType[] = {T("|Stretch to|"), T("|Cut at|")};
	int arNStretchType[] = {_kStretchOnInsert, _kStretchNot};
	PropString sStretchType(4, arSStretchType, T("|Stretch or cut|"));
	sStretchType.setCategory(categories[2]);
	PropDouble stretchMargin(0, U(0), T("|Stretch margin|"));
	stretchMargin.setDescription(T("|Allow this beam to stretch if it ends up outside, but within this margin, of the beam to stretch to.|"));
	stretchMargin.setCategory(categories[2]);
	
	PropDouble stretchToMargin(1, U(0), T("|Stretch to margin|"));
	stretchToMargin.setDescription(T("|Allow this beam to stretch, if the distance between this beam and the beam to stretch to is closer then the specified margin.|"));
	stretchToMargin.setCategory(categories[2]);

//End Properties//endregion 

// The tsl can be attached to a dsp detail. 
// The catalog name can be passed to the tsl by specifing it as argument in the dsp detail: "DspToTsl;<catalogname>".
if( _Map.hasString("DspToTsl") ){
	String sCatalogName = _Map.getString("DspToTsl");
	setPropValuesFromCatalog(sCatalogName);	
	_Map.removeAt("DspToTsl", true);
}

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames("HSB_E-StretchToBeam");
if (_kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
		showDialog();
		
	setCatalogFromPropValues(T("|_LastInserted|"));
	
	PrEntity ssElements(T("|Select elements|"), Element());
	if (ssElements.go())
	{
		Element selectedElements[] = ssElements.elementSet();
		
		String strScriptName = scriptName();
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Entity lstEntities[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("ManualInserted", true);

		for (int e=0;e<selectedElements.length();e++) {
			Element selectedElement = selectedElements[e];
			if (!selectedElement.bIsValid())
				continue;
			
			lstEntities[0] = selectedElement;

			TslInst tslNew;
			tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}		
	}
	
	eraseInstance();
	return;
}

if (_Element.length() == 0) {
	reportWarning(T("|Invalid or no element selected.|"));
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

// Set the sequence number
_ThisInst.setSequenceNumber(sequenceNumber);
	
if( _bOnDebug || _bOnElementConstructed || manualInserted )
{
	Element el = _Element[0];
	
	int nStretchTo = arSStretchTo.find(sStretchTo,0);
	int nTypeToStretchTo = _BeamTypes.find(sTypeToStretchTo);
	
	if( nStretchTo == 0 && (sBmCodeToStretch == sCodeToStretchTo || sBmCodeToStretch == "" || sCodeToStretchTo == "") ){
		eraseInstance();
		return;
	}
			
	int nStretchType = arNStretchType[arSStretchType.find(sStretchType, 0)];
	
	// coordinate system of this element
	CoordSys csEl = el.coordSys();
	Point3d ptEl = csEl.ptOrg();
	Vector3d vxEl = csEl.vecX();
	Vector3d vyEl = csEl.vecY();
	Vector3d vzEl = csEl.vecZ();
	_Pt0 = ptEl;
	
	Beam arBm[] = el.beam();
	Beam arBmToStretch[0];
	Beam arBmToStretchTo[0];
	for( int i=0;i<arBm.length();i++ )
	{
		Beam bm = arBm[i];
		String sBmCode = bm.beamCode().token(0);
		sBmCode.trimLeft();
		sBmCode.trimRight();
		if( sBmCode == sBmCodeToStretch ){
			arBmToStretch.append(bm);
		}
		
		if( nStretchTo == 0 && sCodeToStretchTo .right(1) == "*" && sBmCode.left(sCodeToStretchTo .length() - 1) + "*" == sCodeToStretchTo ){
			arBmToStretchTo.append(bm);
		}	
		else if( nStretchTo == 0 && sBmCode == sCodeToStretchTo ){
			arBmToStretchTo.append(bm);
		}
		else if( nStretchTo == 1 && bm.type() == nTypeToStretchTo ){
			arBmToStretchTo.append(bm);
		}
	}
	
	for( int i=0;i<arBmToStretch.length();i++ )
	{
		Beam bmToStretch = arBmToStretch[i];
		Point3d ptBmToStretch = bmToStretch.ptCen();
		Vector3d vxBmToStretch = bmToStretch.vecX();
		Line lnBmToStretchX(ptBmToStretch, vxBmToStretch);
		bmToStretch.envelopeBody().vis(1);
		Point3d ptBmToStretchPos = ptBmToStretch;
		Point3d ptBmToStretchNeg = ptBmToStretch;
		
		Vector3d vyBmToStretch = bmToStretch.vecY();
		
		if( nStretchType != _kStretchNot )
		{
			ptBmToStretchPos = ptBmToStretch + vxBmToStretch * .49 * bmToStretch.solidLength();
			ptBmToStretchNeg = ptBmToStretch - vxBmToStretch * .49 * bmToStretch.solidLength();
		}
			
		Beam arBmToStretchToPosPos[] = Beam().filterBeamsHalfLineIntersectSort(arBmToStretchTo, ptBmToStretchPos, vxBmToStretch);
		Beam arBmToStretchToNegNeg[] = Beam().filterBeamsHalfLineIntersectSort(arBmToStretchTo, ptBmToStretchNeg, -vxBmToStretch);
		Beam arBmToStretchToPosNeg[] = Beam().filterBeamsHalfLineIntersectSort(arBmToStretchTo, ptBmToStretchPos,- vxBmToStretch);
		Beam arBmToStretchToNegPos[] = Beam().filterBeamsHalfLineIntersectSort(arBmToStretchTo, ptBmToStretchNeg, vxBmToStretch);
		
		Beam arBmCut[0];
		if( arBmToStretchToPosPos.length() > 0 )
			arBmCut.append(arBmToStretchToPosPos[0]);
		if( arBmToStretchToNegNeg.length() > 0 )
			arBmCut.append(arBmToStretchToNegNeg[0]);
		
		if (arBmCut.length() < 1)
		{
			if( arBmToStretchToPosNeg.length() > 0 )
				arBmCut.append(arBmToStretchToPosNeg[0]);
			if( arBmToStretchToNegPos.length() > 0 )
				arBmCut.append(arBmToStretchToNegPos[0]);
		}
		
	       int encapsulated = 0;
		if(arBmCut.length() < 1)
		{ 
			for (int k = 0; k < arBmToStretchTo.length(); k++)
			{ 	
				Beam bmToStretchTo = arBmToStretchTo[k];
				//arBmToStretchTo[k].envelopeBody().vis(6);
				
				Point3d ptBmToStretchTo = bmToStretchTo.ptCen();					
				Vector3d vxBmToStretchTo = bmToStretchTo.vecX();
								
				Line lnBmToStretchToX(ptBmToStretchTo, vxBmToStretchTo);
				Plane pnBmToStretchTo(ptBmToStretchTo, bmToStretchTo.vecD(vxBmToStretch));
				
				//lnBmToStretchToX.vis(50);
				
				Point3d ptIntersect = lnBmToStretchX.intersect(pnBmToStretchTo, 0);
				//ptIntersect.vis(3);
				
				Vector3d vyBmToStretch = bmToStretch.vecY();
				//vyBmToStretch.vis(ptIntersect);
								
				Beam arBmToStretchToPosPos2[] = Beam().filterBeamsHalfLineIntersectSort(arBmToStretchTo, ptIntersect, vyBmToStretch);
				Beam arBmToStretchToNegNeg2[] = Beam().filterBeamsHalfLineIntersectSort(arBmToStretchTo, ptIntersect, -vyBmToStretch);
				Beam arBmToStretchToPosNeg2[] = Beam().filterBeamsHalfLineIntersectSort(arBmToStretchTo, ptIntersect,- vyBmToStretch);
				Beam arBmToStretchToNegPos2[] = Beam().filterBeamsHalfLineIntersectSort(arBmToStretchTo, ptIntersect, vyBmToStretch);
				
				if( arBmToStretchToPosPos2.length() > 0 )
					arBmCut.append(arBmToStretchToPosPos2[0]);
				if( arBmToStretchToNegNeg2.length() > 0 )
					arBmCut.append(arBmToStretchToNegNeg2[0]);
		
				if (arBmCut.length() < 1)
				{
					if( arBmToStretchToPosNeg2.length() > 0 )
						arBmCut.append(arBmToStretchToPosNeg2[0]);
					if( arBmToStretchToNegPos2.length() > 0 )
						arBmCut.append(arBmToStretchToNegPos2[0]);
				}
				
				if (arBmCut.length() > 1)
					encapsulated = 1;
			}
		}
		
		for( int j=0;j<arBmCut.length();j++ )
		{
			Beam bmToStretchTo = arBmCut[j];
			//bmToStretchTo.envelopeBody().vis(1);
			Point3d ptBmToStretchTo = bmToStretchTo.ptCen();
			//ptBmToStretchTo.vis(1);
			Vector3d vxBmToStretchTo = bmToStretchTo.vecX();
			
			if( vxBmToStretchTo.isParallelTo(vxBmToStretch) )
				continue;
			
			Line lnBmToStretchToX(ptBmToStretchTo, vxBmToStretchTo);
			Plane pnBmToStretchTo(ptBmToStretchTo, bmToStretchTo.vecD(vxBmToStretch));
			
			Point3d ptIntersect = lnBmToStretchX.intersect(pnBmToStretchTo, 0);
			//ptIntersect.vis(3);
			
			Point3d arPtBmToStretchTo[] = bmToStretchTo.envelopeBody(false, true).allVertices();
			Point3d arPtBmToStretchToX[] = lnBmToStretchToX.orderPoints(arPtBmToStretchTo);
			
			Point3d test = arPtBmToStretchToX[0];
			test.vis(4);
			if( arPtBmToStretchToX.length() < 2 )
				continue;
			
			Point3d stretchStart = arPtBmToStretchToX[0] - vxBmToStretchTo * stretchMargin;
			Point3d stretchEnd = arPtBmToStretchToX[arPtBmToStretchToX.length() - 1] + vxBmToStretchTo * stretchMargin;
			if( (vxBmToStretchTo.dotProduct(ptIntersect - stretchStart) * vxBmToStretchTo.dotProduct(ptIntersect - stretchEnd)) > 0 )
				continue;
			
			Vector3d vCut = bmToStretchTo.vecD(bmToStretch.vecX());
				
			Line lnToStretch(bmToStretch.ptCen(), bmToStretch.vecX());
			Plane pnToStretchTo(bmToStretchTo.ptCen(), vCut);
			Point3d ptCut = lnToStretch.intersect(pnToStretchTo, 0);
			
			if( vCut.dotProduct(ptCut - bmToStretch.ptCen()) < 0 )
				vCut *= -1;
			
			if (encapsulated == 1)
			{ 
				ptCut += vCut * 0.5 * bmToStretchTo.dD(vCut);
			}
			else
			{ 
				ptCut -= vCut * 0.5 * bmToStretchTo.dD(vCut);
			}
			
			if (stretchToMargin > 0 && vCut.dotProduct(ptCut - bmToStretch.ptCenSolid()) > (0.5 * bmToStretch.solidLength() + stretchToMargin)) continue;
			
			if( nStretchType == _kStretchNot )
			{
				if( !bmToStretch.envelopeBody().hasIntersection(bmToStretchTo.envelopeBody()) && encapsulated == 0  )
					continue;
				
				Cut cut(ptCut, vCut);	
				bmToStretch.addToolStatic(cut, nStretchType);
			}
			else
			{
				if (encapsulated == 1)
				{ 
					Cut cut(ptCut, vCut);	
					bmToStretch.addToolStatic(cut, nStretchType);	
				}
				else
				{ 
					bmToStretch.stretchStaticTo(bmToStretchTo, nStretchType);	
				}
			}
		}
	}
	eraseInstance();
	return;
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
  <lst nm="TslInfo">
    <lst nm="TSLINFO">
      <lst nm="TSLINFO" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End