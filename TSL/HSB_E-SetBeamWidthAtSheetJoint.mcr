#Version 8
#BeginDescription
#Versions:
Version 2.2 30/04/2025 HSB-23494: Add painter filter for beams , Author Marsel Nakuci
Version 2.1 30/04/2025 HSB-23494: Add zone filter for the beams , Author Marsel Nakuci
Version2.0 30-9-2021 Make tsl more general, remove type Elementroof restriction. Improve the insert of the tsl. , Author Ronald van Wijngaarden


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 2
#KeyWords Element,Sheet,zone,painter,joint
#BeginContents
/// <summary Lang=en>
/// This tsl changes the beam width the beams at sheet joints.
/// </summary>

/// <insert>
/// Select a set of elements. The tsl is reinserted for each element.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

//#Versions
// 2.2 30/04/2025 HSB-23494: Add painter filter for beams , Author Marsel Nakuci
// 2.1 30/04/2025 HSB-23494: Add zone filter for the beams , Author Marsel Nakuci
//2.0 30-9-2021 Make tsl more general, remove type Elementroof restriction. Improve the insert of the tsl. , Author Ronald van Wijngaarden


//Script uses mm

_ThisInst.setSequenceNumber(-1000);

double dEps = U(.001,"mm");
int nLog = 0;
String sLastInserted =T("|_LastInserted|");
String executeKey = "ManualInsert";

int arNZoneIndex[] = {1,2,3,4,5,6,7,8,9,10};
PropInt nZoneIndex(1, arNZoneIndex, T("|Zone index sheeting|"));
nZoneIndex.setDescription(T("|The beams behind sheet joints of this zone are changed.|"));
nZoneIndex.setCategory(T("|Sheet joints|"));

PropDouble dWBeam(0, U(36), T("|New beam width|"));
dWBeam.setDescription(T("|Sets the width of the beams at a sheet joint|"));
dWBeam.setCategory(T("|Beam Properties|"));

PropString sBmCode(0, "", +T("|Beamcode|"));
sBmCode.setDescription(T("|Sets the beamcode of the beams at sheet joints|"));
sBmCode.setCategory(T("|Beam Properties|"));

PropInt nBmColor(0, -2, +T("|Color|"));
nBmColor.setDescription(T("|Sets the color of the beams at sheet joints|") + 
								T("-2 |keeps the original color.|"));
nBmColor.setCategory(T("|Beam Properties|"));
// HSB-23494
String sBeamZonesName=T("|Beam Zones|");	
PropString sBeamZones(1, "0", sBeamZonesName);	
sBeamZones.setDescription(T("|Defines the zones where beams will be affected. When empty then all beams will be considered|"));
sBeamZones.setCategory(T("|Beam filter|"));

// 
String sFilters[0];
String sPainters[] = PainterDefinition().getAllEntryNames().sorted();
//String sPainterCollection = "hsbViewHatching";

for (int i=sPainters.length()-1; i>=0 ; i--) 
	if (sPainters[i].length()<1)
		sPainters.removeAt(i);

String sPainterStreamName=T("|PainterStream|");	
PropString sPainterStream(2, "", sPainterStreamName);	
sPainterStream.setDescription(T("|Defines the PainterStream|"));
sPainterStream.setCategory(T("|Beam filter|"));
sPainterStream.setReadOnly(_bOnDebug?0:_kHidden);

sFilters = sPainters;
sFilters.insertAt(0, T("|<Disabled>|"));

String sFilterName=T("|Painter Filter|");	
PropString sFilter(3, sFilters, sFilterName);	
sFilter.setDescription(T("|Defines the painter definition to filter entities.|"));
sFilter.setCategory(T("|Beam filter|"));

//if( _Map.hasString("DspToTsl") ){
//	String sCatalogName = _Map.getString("DspToTsl");
//	setPropValuesFromCatalog(sCatalogName);
//	
//	_Map.removeAt("DspToTsl", true);
//}

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( _bOnDbCreated && catalogNames.find(_kExecuteKey) != -1 ) 
{
	setPropValuesFromCatalog(_kExecuteKey);
}

//region mapIO: support property dialog input via map on element creation
int bHasPropertyMap = _Map.hasMap("PROPSTRING[]") && _Map.hasMap("PROPDOUBLE[]") && _Map.hasMap("PROPINT[]");
if (_bOnMapIO)
{ 
	if (bHasPropertyMap)
		setPropValuesFromMap(_Map);	
	showDialog();
	_Map = mapWithPropValues();
	return;
}
if (_bOnElementDeleted)
{
	eraseInstance();
	return;
}
else if (_bOnElementConstructed && bHasPropertyMap)
{ 
	setPropValuesFromMap(_Map);
	_Map = Map();
}

//End mapIO: support property dialog input via map on element creation//endregion 

// bOnInsert
if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
				
// silent/dialog
	String sKey = _kExecuteKey;
	sKey.makeUpper();

	if (sKey.length()>0)
	{
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for(int i=0;i<sEntries.length();i++)
		{
			sEntries[i] = sEntries[i].makeUpper();	
		}
		
		if (sEntries.find(sKey)>-1)
		{
			setPropValuesFromCatalog(sKey);
			setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
		}
		else
		{
			setPropValuesFromCatalog(sKey);
			setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
		}
	}	
	else	
	{
		showDialog();
		setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
	}
	
	// save stream of painter
	int nPainter = sPainters.findNoCase(sFilter,-1);
	{ 
		PainterDefinition painter;
		if (nPainter>-1)
		{
			painter = PainterDefinition(sPainters[nPainter]);
		}
		if (painter.bIsValid())
		{ 
			Map m;
			m.setString("Name", painter.name());
			m.setString("Type",painter.type());
			m.setString("Filter",painter.filter());
			m.setString("Format",painter.format());
			sPainterStream.set(m.getDxContent(true));
		}
		_ThisInst.setCatalogFromPropValues(sLastInserted);
	}
	
	// prompt for elements
	PrEntity ssE(T("|Select element(s)|"), Element());
  	if (ssE.go())
  	{
		_Element.append(ssE.elementSet());
  	}

	
	for (int e=0;e<_Element.length();e++) 
	{
		// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE;
		Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[] = {};
		Entity entsTsl[0];
		entsTsl.append(_Element[e]);
		Point3d ptsTsl[] = {};
		int nProps[]={};
		double dProps[]={};
		String sProps[]={};
		Map mapTsl;	
		String sScriptname = scriptName();
		
		ptsTsl.append(_Element[e].coordSys().ptOrg());
		
		tslNew.dbCreate(scriptName(),vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, sLastInserted, true, mapTsl, executeKey, "");
	}
			
	eraseInstance();		
	return;
}	
// end on insert	__________________

if (_bOnInsert || _bOnElementConstructed || _bOnDbCreated)
	{
		// HSB-15906: collect streams	
		String streams[0];
		String sScriptOpmName=_bOnDebug?"hsbViewHatching":scriptName();
		String entries[]=TslInst().getListOfCatalogNames(sScriptOpmName);
		int nStreamIndices[]={1};//index 1 of the stream property
		for (int i=0;i<entries.length();i++)
		{
			String& entry = entries[i];
			Map map = TslInst().mapWithPropValuesFromCatalog(sScriptOpmName, entry);
			Map mapProp = map.getMap("PropString[]");
			
			for (int j = 0; j < mapProp.length(); j++)
			{
				Map m = mapProp.getMap(j);
				int index = m.getInt("nIndex");
				String stream = m.getString("strValue");
				if (nStreamIndices.find(index) >- 1 && streams.findNoCase(stream ,- 1) < 0)
				{
					streams.append(stream);
				}
			}//next j
		}//next i
		// disabled or a painter rule
		int nRule = sFilters.find(sFilter);
		// by material or painter
		for (int i = 0; i < streams.length(); i++)
		{
			String& stream = streams[i];
			String _painters[0];
			_painters = sPainters;
			if (stream.length() > 0)
			{
				// get painter definition from property string	
				Map m;
				m.setDxContent(stream , true);
				String name = m.getString("Name");
				String type = m.getString("Type").makeUpper();
				String filter = m.getString("Filter");
				String format = m.getString("Format");
				// create definition if not present	
				//				if (m.hasString("Name") && m.hasString("Type") && name.find(sPainterCollection,0,false)>-1 &&
				//					_painters.findNoCase(name,-1)<0)
				if (m.hasString("Name") && m.hasString("Type") && _painters.findNoCase(name,- 1) < 0)
				{
					PainterDefinition pd(name);
					// HSB-20377: dont create painter definition if not requested on insert
					// HSB-20377: no disabled and no by material selected
					if(nRule!=0)
					if (!pd.bIsValid())
					{
						pd.dbCreate();
						pd.setType(type);
						pd.setFilter(filter);
						pd.setFormat(format);
						
						if (pd.bIsValid())
						{
							sPainters.append(name);
						}
					}
				}
			}
		}
	}

int nZnIndex = nZoneIndex;
if (nZnIndex > 5) 
	nZnIndex = 5 - nZnIndex;


// check if there is a valid element present
if( _Element.length() == 0 ){
	reportMessage(T("|No element selected.|"));
	eraseInstance();
	return;
}

// get selected element
Element el = _Element[0];
if( !el.bIsValid() ){
	reportMessage(T("|Invalid element selected.|"));
	eraseInstance();
	return;
}


CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
_Pt0 = ptEl;

Line lnX(ptEl, vxEl);
// HSB-23494
int nBeamZones[0];
if(sBeamZones!="")
{ 
	String _sBeamZones=sBeamZones;
	_sBeamZones.trimLeft();
	_sBeamZones.trimRight();
	String 	_sBeamZoness[]=_sBeamZones.tokenize(";");
	int nZonesAll[]={-5,-4,-3,-2,-1,0,1,2,3,4,5};
	for (int i=0;i<_sBeamZoness.length();i++) 
	{ 
		int nZoneI=_sBeamZoness[i].atoi();
		if(nZonesAll.find(nZoneI)>-1)
		{ 
			if(nBeamZones.find(nZoneI)<0)
			{ 
				nBeamZones.append(nZoneI);
			}
		}
	}//next i
}

int nFilter = sFilters.find(sFilter);
if (nFilter<0)
{ 
	sFilter.set(sFilters.first());
	setExecutionLoops(2);
	return;
}
int nPainter = sPainters.findNoCase(sFilter,-1);
PainterDefinition painter;
if (nPainter>-1)
{
	painter = PainterDefinition(sPainters[nPainter]);
	if (!painter.bIsValid())nPainter = -1;
}

if (painter.bIsValid())
{ 
	Map m;
	m.setString("Name",painter.name());
	m.setString("Type",painter.type());
	m.setString("Filter",painter.filter());
	m.setString("Format",painter.format());
	sPainterStream.set(m.getDxContent(true));
}
int bByPainter=nPainter>-1;
if (_kExecuteKey == executeKey || _bOnElementConstructed || _bOnRecalc)
{	
	Sheet arShZn[] = el.sheet(nZnIndex);
	if (arShZn.length() == 0 ) {
		reportNotice("\n" + scriptName() + TN("|No sheets found in zone| ") + nZoneIndex + T(" |for element| ") + el.number());
		eraseInstance();
		return;
	}
		
	Point3d arPtSh[0];
	for (int i = 0; i < arShZn.length(); i++) {
		Sheet sh = arShZn[i];
		
		PlaneProfile ppSh = sh.profShape();
		ppSh.shrink(U(1));		
		
		Point3d arPtThisSh[] = ppSh.getGripEdgeMidPoints();
		arPtThisSh = lnX.orderPoints(arPtThisSh);
		if (arPtThisSh.length() < 2)
			continue;
		
		// Add extremes.
		arPtSh.append(arPtThisSh[0]);
		arPtSh.append(arPtThisSh[arPtThisSh.length() - 1]);
	}
	
	arPtSh = lnX.projectPoints(arPtSh);
	arPtSh = lnX.orderPoints(arPtSh, U(0.1));
	
	if (arPtSh.length() < 2) {
		reportNotice("\n" + scriptName() + TN("|No sheet joints found in zone| ") + nZoneIndex + T(" |for element| ") + el.number());
		eraseInstance();
		return;
	}
	
	Point3d arPtShJoint[0];
	Point3d ptPrev = arPtSh[0];
	for (int i = 1; i < arPtSh.length(); i++) {
		Point3d ptThis = arPtSh[i];
		
		double dBetweenPoints = vxEl.dotProduct(ptThis - ptPrev);
		if (dBetweenPoints < U(10))
			arPtShJoint.append((ptThis + ptPrev) / 2);
		
		ptPrev = ptThis;
	}
	
	//TODO add blockings ID's for wall blockings?'
	String arSBlockingID[] = {
		"4109",
		"4110"
	};
	
	Beam arBm[] = el.beam();
	Beam arBmVert[0];
	Beam arBmBlock[0];
	for (int i = 0; i < arBm.length(); i++) {
		Beam bm = arBm[i];
		
		if (abs(bm.vecX().dotProduct(vxEl)) < dEps) {
			if (arSBlockingID.find(bm.hsbId()) != -1)
				arBmBlock.append(bm);
			else
				arBmVert.append(bm);
		}
	}
	
	for (int i = 0; i < arPtShJoint.length(); i++) {
		Point3d pt = arPtShJoint[i];
		pt.vis(i);
		
		// Find beam at this location
		for (int j = 0; j < arBmVert.length(); j++) {
			Beam bm = arBmVert[j];
			
			if (abs(vxEl.dotProduct(bm.ptCen() - pt)) < U(10)) 
			{
				// HSB-23494
				if(nBeamZones.length()>0)
				{ 
					if(nBeamZones.find(bm.myZoneIndex())<0)
					{ 
						continue;
					}
				}
				if(bByPainter)
				{ 
					if(!bm.acceptObject(painter.filter()))
					{ 
						continue;
					}
				}
				if (nBmColor > - 2)
					bm.setColor(nBmColor);
				
				if (sBmCode != "")
					bm.setBeamCode(sBmCode);
				
				bm.setD(vxEl, dWBeam);
				Body bodyBm = bm.realBody();
				bodyBm.vis();
				
				// Move intersecting blocks
				PlaneProfile ppBm(csEl);
				PLine plBm(vzEl);
				plBm.createRectangle(
				LineSeg(
				bm.ptCen() - bm.vecX() * 0.5 * bm.solidLength() - bm.vecD(vxEl) * 0.5 * dWBeam,
				bm.ptCen() + bm.vecX() * 0.5 * bm.solidLength() + bm.vecD(vxEl) * 0.5 * dWBeam),
				bm.vecX(), bm.vecD(vxEl)
				);
				ppBm.joinRing(plBm, _kAdd);
				
				for (int k = 0; k < arBmBlock.length(); k++) {
					Beam bmBlock = arBmBlock[k];
					PlaneProfile ppBmBlock(csEl);
					PLine plBmBlock(vzEl);
					plBmBlock.createRectangle(
					LineSeg(
					bmBlock.ptCen() - bmBlock.vecX() * 0.5 * bmBlock.solidLength() - bmBlock.vecD(vxEl) * 0.5 * bmBlock.dD(vxEl),
					bmBlock.ptCen() + bmBlock.vecX() * 0.5 * bmBlock.solidLength() + bmBlock.vecD(vxEl) * 0.5 * bmBlock.dD(vxEl)),
					bmBlock.vecX(), bmBlock.vecD(vxEl)
					);
					ppBmBlock.joinRing(plBmBlock, _kAdd);
					
					double dBlockArea = ppBmBlock.area();
					if (ppBmBlock.intersectWith(ppBm)) {
						if (ppBmBlock.area() < dBlockArea) {
							int nSide = 1;
							if (vxEl.dotProduct(bmBlock.ptCen() - bm.ptCen()) < 0)
								nSide *= -1;
							
							LineSeg lnSegIntersect = ppBmBlock.extentInDir(vxEl);
							bmBlock.transformBy(vxEl * nSide * abs(vxEl.dotProduct(lnSegIntersect.ptEnd() - lnSegIntersect.ptStart())));
						}
					}
				}
			}
		}
	}
	eraseInstance();
	return;
}







#End
#BeginThumbnail
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
(@`HHHH`__]FB
`




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
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23494: Add painter filter for beams" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="4/30/2025 9:26:10 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23494: Add zone filter for the beams" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="4/30/2025 8:42:30 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Make tsl more general, remove type Elementroof restriction. Improve the insert of the tsl." />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="9/30/2021 12:23:08 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End