#Version 8
#BeginDescription
#Versions:
1.2 14.01.2022 HSB-10122: TSL to be attached as element TSL Author: Marsel Nakuci
1.1 21.12.2021 HSB-10122: Fix TSL assignment, consider only beams of zone 0 for nailing Author: Marsel Nakuci
version value="1.0" date="13jan2021" author="marsel.nakuci@hsbcad.com"
HSB-10122: initial

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords Tophat,nail,wall,wall2wall
#BeginContents
/// <History>//region
/// #Versions:
// Version 1.2 14.01.2022 HSB-10122: TSL to be attached as element TSL Author: Marsel Nakuci
// Version 1.1 21.12.2021 HSB-10122: Fix TSL assignment, consider only beams of zone 0 for nailing Author: Marsel Nakuci
/// <version value="1.0" date="13jan2021" author="marsel.nakuci@hsbcad.com"> HSB-10122: initial </version>
/// </History>

/// <insert Lang=en>
/// Select walls, enter properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates nailing between wall connections
/// User selects many walls. TSL will investigate possible connections such as 
/// corner connections, T connections and E connections
/// For each connection there will be a TSL instance
///
/// TSL can also be inserted at the connection details of the wall details
/// For the TSL detail user must specify properties by following map entries:
/// "mNailIndexmDirection" "mDistanceBottom" "mDistanceTop""mDistanceBetween"
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbWall2WallFixing")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Swap Direction|") (_TM "|select hsbWall2WallFixing TSL|"))) TSLCONTENT
//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end Constants//endregion
	
//region properties
	String sNailIndexName=T("|Nail Index|");
	int nNailIndexs[]={1,2,3};
	PropInt nNailIndex(nIntIndex++, 0, sNailIndexName);	
	nNailIndex.setDescription(T("|Defines the NailIndex|"));
	nNailIndex.setCategory(category);
	// direction of nail
	category = T("|Alignment|");
	String sDirectionName=T("|Direction|");	
	String sDirections[] ={ T("|Inner|"), T("|Outer|")};
	PropString sDirection(nStringIndex++, sDirections, sDirectionName);	
	sDirection.setDescription(T("|Defines the direction of nail|"));
	sDirection.setCategory(category);
	
	category = T("|Distribution|");
	
	String sModeDistributionName=T("|Mode|");
	String sModeDistributions[] ={ T("|Even|"), T("|Fixed|")};
	PropString sModeDistribution(nStringIndex++, sModeDistributions, sModeDistributionName);	
	sModeDistribution.setDescription(T("|Defines the Distribution Mode between even or fixed.|")+" "+
	T("|User can enter|")+" "+T("|Even|")+ " or "+T("|Fixed|"));
	sModeDistribution.setCategory(category);
	//distance from the bottom / start
	String sDistanceBottomName = T("|Distance Bottom/Start|");
	PropDouble dDistanceBottom(nDoubleIndex++, U(0), sDistanceBottomName);
	dDistanceBottom.setDescription(T("|Defines the distance at the bottom or start of distribution|"));
	dDistanceBottom.setCategory(category);
	// distance from the top/end
	String sDistanceTopName = T("|Distance Top/End|");
	PropDouble dDistanceTop(nDoubleIndex++, U(0), sDistanceTopName);
	dDistanceTop.setDescription(T("|Defines the distance at the top or end of distribution|"));
	dDistanceTop.setCategory(category);
	// distance in between/ nr of parts (when negative input)
	String sDistanceBetweenName=T("|Max. distance between / Nr.| ");	
	PropDouble dDistanceBetween(nDoubleIndex++, U(10), sDistanceBetweenName);
	dDistanceBetween.setDescription(T("|Defines the distance between the parts. Negative integer indicates nr of parts|"));
	// Negative number will indicate nr of parts from the integer part of the inserted double
	dDistanceBetween.setCategory(category);
	// nr of parts/distance in between after calculation
	String sDistanceBetweenResultName=T("|Distance between calculated|");	
	PropDouble dDistanceBetweenResult(nDoubleIndex++, U(0), sDistanceBetweenResultName);
	dDistanceBetweenResult.setDescription(T("|Exact distance between nails for an equal distribution|"));
	dDistanceBetweenResult.setReadOnly(true);
	dDistanceBetweenResult.setCategory(category);
	String sNrResultName=T("|Nr.|");
//	int nNrResults[]={1,2,3};
	PropInt nNrResult(nIntIndex++, 0, sNrResultName);
	nNrResult.setDescription(T("|Number of nails|"));
	nNrResult.setReadOnly(true);
	nNrResult.setCategory(category);
	
// filter by wall code
	String sCodeName=T("|Code|");	
	PropString sCode(nStringIndex++, "", sCodeName);	
	sCode.setDescription(T("|Defines the allowed connected Walls by Code.|")+" "
	+T("|Multiple Code entries can be seperated by ;|")+" "
	+T("|If property empty all walls are allowed.|"));
	sCode.setCategory(category);
//End properties//endregion 
	
//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);
		}	
	// standard dialog	
		else	
			showDialog();
		
	// prompt wall selection
	// prompt for elements
		Entity ents[0];
		PrEntity ssE(T("|Select stick frame walls|"), ElementWallSF());
	  	if (ssE.go())
			ents.append(ssE.set());
		
		for (int i=0;i<ents.length();i++) 
		{ 
			Element el = (Element)ents[i];
			if (el.bIsValid())
				if (_Element.find(el) < 0)
				{
					_Element.append(el);
					continue;
				}
		}//next i
		
		if(_Element.length()<2)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|At least two walls are needed|"));
			eraseInstance();
			return;
		}
		// insert mode is 1
		_Map.setInt("iMode", 1);
		return;
	}	
// end on insert	__________________//endregion

//if(_Element.length()<2)
//{ 
//	reportMessage(TN("|at least two walls are needed|"));
//	eraseInstance();
//	return;
//}
//return
_ThisInst.setAllowGripAtPt0(false);
//region mapIO: support property dialog input via map on element creation
{
	int bHasPropertyMap = _Map.hasMap("PROPSTRING[]") && _Map.hasMap("PROPDOUBLE[]");
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
		if(_Element[0].beam().length()==0)
		{ 
			// delete instance only if element 0 is deleted or doesnt have beams
			reportMessage("\n"+scriptName()+" "+T("|delete|"));
			eraseInstance();
			return;
		}
	}
	else if (_bOnElementConstructed && bHasPropertyMap)
	{ 
		setPropValuesFromMap(_Map);
		_Map = Map();
	}
}
//End mapIO: support property dialog input via map on element creation//endregion 

int iMode = _Map.getInt("iMode");

if(_bOnDbCreated || (_bOnElementConstructed && iMode!=1))
{ 
	// when tsl is inserted as detail in corner connection it has the properties defined as a map
	// in that case the properties are read from the _Map
	String key;
	key = "mNailIndex"; if (_Map.hasString(key)) nNailIndex.set(_Map.getString(key).atoi());
	// direction to be inputed as index 0 inner, 1 outer
	key = "mDirection"; if (_Map.hasString(key)) sDirection.set(sDirections[_Map.getString(key).atoi()]);
	key = "mModeDistribution"; if (_Map.hasString(key)) sModeDistribution.set(_Map.getString(key));
	key = "mDistanceBottom"; if (_Map.hasString(key)) dDistanceBottom.set(_Map.getString(key).atof());
	key = "mDistanceTop"; if (_Map.hasString(key)) dDistanceTop.set(_Map.getString(key).atof());
	key = "mDistanceBetween"; if (_Map.hasString(key)) dDistanceBetween.set(_Map.getString(key).atof());
	key = "mCode"; if (_Map.hasString(key)) sCode.set(_Map.getString(key));
}

String _sCode = sCode;
_sCode.trimLeft();
_sCode.trimRight();
String _sCodes[] = _sCode.tokenize(";");
//return
if(iMode==0)
{ 
	// detail mode, tsl inserted at a female wall
	// find the male wall
	if (_Element.length()!=1)
	{
		reportMessage("\n"+scriptName()+" "+T("|unexpected, no element|"));
		eraseInstance();
		return;	
	}
	
// create TSL
	TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
	GenBeam gbsTsl[] = {}; 
	Entity entsTsl[2]; 
	Point3d ptsTsl[] = {_Pt0};
	int nProps[]={nNrResult};
	double dProps[]={dDistanceBottom, dDistanceTop, dDistanceBetween, dDistanceBetweenResult};
	String sProps[]={sDirection,sModeDistribution, sCode};
	Map mapTsl;
	
	//
	ElementWallSF el0 = (ElementWallSF)_Element[0];
	String sNum = el0.code();
	if(_Element.length()<2)
	{ 
		Element elConnected[] = el0.getConnectedElements();
		for (int e=elConnected.length()-1; e>=0 ; e--) 
		{ 
			if((_sCodes.length()>0) && _sCodes.find(elConnected[e].code())<0)
			{
				// property not empty, only allow allowed codes
				elConnected.removeAt(e);
			}
		}//next e
		
		Point3d ptOrg0 = el0.ptOrg();
		Vector3d vecX0 = el0.vecX();
		Vector3d vecY0 = el0.vecY();
		Vector3d vecZ0 = el0.vecZ();
		PLine plOutlineWall0 = el0.plOutlineWall();
		// in xy, vertical planeprofile
		PlaneProfile ppEnvelope0 = el0.plEnvelope();
		// plane at base of el0
		Plane pn0(ptOrg0, vecY0);
		CoordSys csHor(pn0.ptOrg(), pn0.vecX(), pn0.vecY(), pn0.vecZ());
		PlaneProfile pp0(csHor);
		pp0.joinRing(plOutlineWall0, _kAdd);
		Point3d ptCen0;
		double dX0, dY0, dZ0;
		// get extents of profile
		{
			LineSeg seg = pp0.extentInDir(vecX0);
			ptCen0 = seg.ptMid();
			
			dX0 = abs(vecX0.dotProduct(seg.ptStart()-seg.ptEnd()));
			dZ0 = abs(vecZ0.dotProduct(seg.ptStart()-seg.ptEnd()));
			//
			// get extents of profile
			seg = ppEnvelope0.extentInDir(vecX0);
			dY0 = abs(vecY0.dotProduct(seg.ptStart() - seg.ptEnd()));
			ptCen0 += (vecY0 * vecY0.dotProduct(seg.ptMid() - ptCen0));
			ptCen0.vis(3);
		}
		Point3d ptsThis[] = plOutlineWall0.vertexPoints(true);
		
		for (int i=0;i<elConnected.length();i++) 
		{ 
			ElementWallSF el1 = (ElementWallSF)elConnected[i];
			if ( ! el1.bIsValid())
				continue;
			// general data of el1
			Point3d ptOrg1 = el1.ptOrg();
			Vector3d vecX1 = el1.vecX();
			Vector3d vecY1 = el1.vecY();
			Vector3d vecZ1 = el1.vecZ();
			
			// in xy, vertical planeprofile
			PlaneProfile ppEnvelope1 = el1.plEnvelope();
			LineSeg seg = ppEnvelope1.extentInDir(vecX1);
			Point3d ptCen1 = seg.ptMid();
			double dY1 = abs(vecY1.dotProduct(seg.ptStart() - seg.ptEnd()));
			// in xz from top view
			PLine plOutlineWall1 = el1.plOutlineWall();
			plOutlineWall1.projectPointsToPlane(pn0, vecY0);
			Point3d ptsOther[] = plOutlineWall1.vertexPoints(true);
			
			// common points on contour
			int nOnThis = 0, nOnOther = 0;
			Point3d ptsOnThis[0], ptsOnOther[0];
			// points from the other wall
			for (int p = 0; p < ptsOther.length(); p++)
			{
				double d = (ptsOther[p] - plOutlineWall0.closestPointTo(ptsOther[p])).length();
				if (d < dEps)
				{
					ptsOnThis.append(ptsOther[p]);// collect connecting points between 2 walls
					nOnThis++;// count points of wall in el1 that are connected with wall in el0
				}
			}
			// points from this wall at other wall 
			for (int p = 0; p < ptsThis.length(); p++)
			{
				double d = (ptsThis[p] - plOutlineWall1.closestPointTo(ptsThis[p])).length();
				if (d < dEps)
				{
					ptsOnOther.append(ptsThis[p]);
					nOnOther++;
				}
			}
			
			// capture walls on top of the other
			Point3d ptTop0 = ptCen0 + vecY0 * .5 * dY0;
			Point3d ptBottom0 = ptCen0 - vecY0 * .5 * dY0;
			Point3d ptTop1 = ptCen1 + vecY1 * .5 * dY1;
			Point3d ptBottom1 = ptCen1 - vecY1 * .5 * dY1;
			int iOntopOfEachOther = 0;
			
			if(abs(vecY0.dotProduct(ptTop0-ptBottom1))<dEps 
					|| abs(vecY0.dotProduct(ptTop1-ptBottom0))<dEps)
			{ 
				iOntopOfEachOther = 1;
			}
			// distinguish between different connections
			if(nOnThis==1 && nOnOther==2 && !vecX0.isParallelTo(vecX1) && !iOntopOfEachOther)
			{ 
				// corner connection mode 2, male-female
			// create TSL
				entsTsl[0] = el0;
				entsTsl[1] = el1;
				mapTsl.setInt("iMode", 2);
				//
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
			else if(nOnThis==2 && nOnOther==1 && !vecX0.isParallelTo(vecX1) && !iOntopOfEachOther)
			{ 
				// corner connection mode 1, female-male
			// create TSL
				entsTsl[0] = el1;
				entsTsl[1] = el0;
				mapTsl.setInt("iMode", 2);
				//
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
			// T- connection
			else if(nOnThis==0 && nOnOther==2 && !vecX0.isParallelTo(vecX1) && !iOntopOfEachOther)
			{ 
				// T connection male-female
			// create TSL
				entsTsl[0] = el0;
				entsTsl[1] = el1;
				mapTsl.setInt("iMode", 3);
				//
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
			else if(nOnThis==2 && nOnOther==0 && !vecX0.isParallelTo(vecX1) && !iOntopOfEachOther)
			{ 
				// T connection female-male
			// create TSL
				entsTsl[0] = el1;
				entsTsl[1] = el0;
				mapTsl.setInt("iMode", 3);
				//
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
			else if((nOnThis==2 && nOnOther==2) && !iOntopOfEachOther)
			{ 
				// parallel connection or non parallel connection
			// create TSL
				entsTsl[0] = el0;
				entsTsl[1] = el1;
				mapTsl.setInt("iMode", 4);
				//
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
			else if((nOnThis>0 || nOnOther>0) && vecX0.isParallelTo(vecX1) && !iOntopOfEachOther)
			{ 
				// parallel connection, different widths or displaced from axis
			// create TSL
				entsTsl[0] = el0;
				entsTsl[1] = el1;
				mapTsl.setInt("iMode", 5);
				//
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
			
//			Point3d ptRef = _Pt0;
//			ptRef.transformBy(elConnected[i].vecY()*elConnected[i].vecY().dotProduct(elConnected[i].ptOrg()-_Pt0)); 
//			ptRef.vis(1);
//			PLine pl = elConnected[i].plOutlineWall();
//			Point3d ptNext = pl.closestPointTo(ptRef);
//			ptNext.vis(4);
//			if(abs(el0.vecX().dotProduct(ptNext-ptRef))<dEps)
//			{ 
//				_Element.append(elConnected[i]);
//				break;
//			}
		}//next i
//		if (_Element.length()<2)
//		{
//			reportMessage("\n"+scriptName()+" "+T("|no connected element found|"));
//			eraseInstance();
//			return;	
//		}

		eraseInstance();
		return;
	}
	
//	Element el1 = _Element[1];
//	//
//	TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
//	GenBeam gbsTsl[] = {}; Entity entsTsl[] = {el0, el1}; Point3d ptsTsl[] = {_Pt0};
//	int nProps[]={nNrResult};
//	double dProps[]={dDistanceBottom, dDistanceTop, dDistanceBetween, dDistanceBetweenResult};
//	String sProps[]={sDirection, sCode};
//	Map mapTsl;
//	// give distribution mode. it will identify type of connection, corner,T, parallel
//	mapTsl.setInt("iMode", 1);
	//
//	tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
//	eraseInstance();
//	return;
}
if(iMode==1)
{ 
	// distribution mode, identify all connections between walls
	// remember couples already created
	// storing couples id as 1000*i+j
//	return
	int iCoupleIds[0];
	for (int i=0;i<_Element.length();i++) 
	{ 
		ElementWallSF el0 = (ElementWallSF) _Element[i];
		if ( ! el0.bIsValid())
			continue;
		
	// general data of el0
		Point3d ptOrg0 = el0.ptOrg();
		Vector3d vecX0 = el0.vecX();
		Vector3d vecY0 = el0.vecY();
		Vector3d vecZ0 = el0.vecZ();
		PLine plOutlineWall0 = el0.plOutlineWall();
		// in xy, vertical planeprofile
		PlaneProfile ppEnvelope0 = el0.plEnvelope();
		// plane at base of el0
		Plane pn0(ptOrg0, vecY0);
		CoordSys csHor(pn0.ptOrg(), pn0.vecX(), pn0.vecY(), pn0.vecZ());
		PlaneProfile pp0(csHor);
		pp0.joinRing(plOutlineWall0, _kAdd);
		Point3d ptCen0;
		double dX0, dY0, dZ0;
		// get extents of profile
		{
			LineSeg seg = pp0.extentInDir(vecX0);
			ptCen0 = seg.ptMid();
			
			dX0 = abs(vecX0.dotProduct(seg.ptStart()-seg.ptEnd()));
			dZ0 = abs(vecZ0.dotProduct(seg.ptStart()-seg.ptEnd()));
			//
			// get extents of profile
			seg = ppEnvelope0.extentInDir(vecX0);
			dY0 = abs(vecY0.dotProduct(seg.ptStart() - seg.ptEnd()));
			ptCen0 += (vecY0 * vecY0.dotProduct(seg.ptMid() - ptCen0));
			ptCen0.vis(3);
		}
		Quader qd0(ptCen0, vecX0, vecY0, vecZ0, dX0, dY0, dZ0, 0, 0, 0);
		Body bd0(qd0);
		// extended body to get intersection with slab when needed
		Quader qd0Extend(ptCen0, vecX0, vecY0, vecZ0, dX0, dY0+10*dEps, dZ0, 0, 0, 0);
		Body bd0Extend(qd0Extend);
		//
		Point3d ptsThis[] = plOutlineWall0.vertexPoints(true);
			
	// see if it forms one of 3 possible connections with any wall
		for (int j = 0; j < _Element.length(); j++)
		{
			if (i == j)
				continue;
				
			// avoid couples ij and ji
			int iThisId = 1000 * i + j;
			int iCheckId = 1000 * j + i;
			if(iCoupleIds.find(iCheckId)>-1)
				continue
				
			ElementWallSF el1 = (ElementWallSF)_Element[j];
			if ( ! el1.bIsValid())
				continue;
				
			// general data of el1
			Point3d ptOrg1 = el1.ptOrg();
			Vector3d vecX1 = el1.vecX();
			Vector3d vecY1 = el1.vecY();
			Vector3d vecZ1 = el1.vecZ();
			
			// in xy, vertical planeprofile
			PlaneProfile ppEnvelope1 = el1.plEnvelope();
			LineSeg seg = ppEnvelope1.extentInDir(vecX1);
			Point3d ptCen1 = seg.ptMid();
			double dY1 = abs(vecY1.dotProduct(seg.ptStart() - seg.ptEnd()));
			// in xz from top view
			PLine plOutlineWall1 = el1.plOutlineWall();
			plOutlineWall1.projectPointsToPlane(pn0, vecY0);
			plOutlineWall1.vis(2);
			Point3d ptsOther[] = plOutlineWall1.vertexPoints(true);
			
			// common points on contour
			int nOnThis = 0, nOnOther = 0;
			Point3d ptsOnThis[0], ptsOnOther[0];
			// points from the other wall
			for (int p = 0; p < ptsOther.length(); p++)
			{
				double d = (ptsOther[p] - plOutlineWall0.closestPointTo(ptsOther[p])).length();
				if (d < dEps)
				{
					ptsOnThis.append(ptsOther[p]);// collect connecting points between 2 walls
					nOnThis++;// count points of wall in el1 that are connected with wall in el0
				}
			}
			// points from this wall at other wall 
			for (int p = 0; p < ptsThis.length(); p++)
			{
				double d = (ptsThis[p] - plOutlineWall1.closestPointTo(ptsThis[p])).length();
				if (d < dEps)
				{
					ptsOnOther.append(ptsThis[p]);
					nOnOther++;
				}
			}
			
			// capture walls on top of the other
			Point3d ptTop0 = ptCen0 + vecY0 * .5 * dY0;
			Point3d ptBottom0 = ptCen0 - vecY0 * .5 * dY0;
			Point3d ptTop1 = ptCen1 + vecY1 * .5 * dY1;
			Point3d ptBottom1 = ptCen1 - vecY1 * .5 * dY1;
			int iOntopOfEachOther = 0;
			
			if(abs(vecY0.dotProduct(ptTop0-ptBottom1))<dEps 
					|| abs(vecY0.dotProduct(ptTop1-ptBottom0))<dEps)
			{ 
				iOntopOfEachOther = 1;
			}
			
			// distinguish between different connections
			if(nOnThis==1 && nOnOther==2 && !vecX0.isParallelTo(vecX1) && !iOntopOfEachOther)
			{ 
				iCoupleIds.append(1000 * i + j);
				// corner connection mode 2, male-female
			// create TSL
				TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {}; Entity entsTsl[] = {el0, el1}; Point3d ptsTsl[] = {_Pt0};
				int nProps[]={nNrResult};
				double dProps[]={dDistanceBottom, dDistanceTop, dDistanceBetween, dDistanceBetweenResult};
				String sProps[]={sDirection,sModeDistribution, sCode};
				Map mapTsl;	
				mapTsl.setInt("iMode", 2);
				//
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
			else if(nOnThis==2 && nOnOther==1 && !vecX0.isParallelTo(vecX1) && !iOntopOfEachOther)
			{ 
				iCoupleIds.append(1000 * i + j);
				
				// corner connection mode 1, female-male
			// create TSL
				TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {}; Entity entsTsl[] = {el1, el0}; Point3d ptsTsl[] = {_Pt0};
				int nProps[]={nNrResult};
				double dProps[]={dDistanceBottom, dDistanceTop, dDistanceBetween, dDistanceBetweenResult};
				String sProps[]={sDirection,sModeDistribution, sCode};
				Map mapTsl;	
				mapTsl.setInt("iMode", 2);
				//
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
			// T- connection
			else if(nOnThis==0 && nOnOther==2 && !vecX0.isParallelTo(vecX1) && !iOntopOfEachOther)
			{ 
				iCoupleIds.append(1000 * i + j);
				
				// T connection male-female
			// create TSL
				TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {}; Entity entsTsl[] = {el0, el1}; Point3d ptsTsl[] = {_Pt0};
				int nProps[]={nNrResult};
				double dProps[]={dDistanceBottom, dDistanceTop, dDistanceBetween, dDistanceBetweenResult};
				String sProps[]={sDirection,sModeDistribution,sCode};
				Map mapTsl;	
				mapTsl.setInt("iMode", 3);
				//
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
			else if(nOnThis==2 && nOnOther==0 && !vecX0.isParallelTo(vecX1) && !iOntopOfEachOther)
			{ 
				iCoupleIds.append(1000 * i + j);
				
				// T connection female-male
			// create TSL
				TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {}; Entity entsTsl[] = {el1, el0}; Point3d ptsTsl[] = {_Pt0};
				int nProps[]={nNrResult};
				double dProps[]={dDistanceBottom, dDistanceTop, dDistanceBetween, dDistanceBetweenResult};
				String sProps[]={sDirection,sModeDistribution,sCode};
				Map mapTsl;	
				mapTsl.setInt("iMode", 3);
				//
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
			else if((nOnThis==2 && nOnOther==2) && !iOntopOfEachOther)
			{ 
				// can be parallel or non parallel
				iCoupleIds.append(1000 * i + j);
				
				// parallel connection or non parallel connection
			// create TSL
				TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {}; Entity entsTsl[] = {el0, el1}; Point3d ptsTsl[] = {_Pt0};
				int nProps[]={};
				double dProps[]={dDistanceBottom, dDistanceTop, dDistanceBetween, dDistanceBetweenResult};
				String sProps[]={sDirection,sModeDistribution,sCode};
				Map mapTsl;	
				mapTsl.setInt("iMode", 4);
				//
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
			else if((nOnThis>0 || nOnOther>0) && vecX0.isParallelTo(vecX1) && !iOntopOfEachOther)
			{ 
				// nOnThis==2 && nOnOther==2 is captured at previous if condition
				iCoupleIds.append(1000 * i + j);
				
				// parallel connection, different widths or displaced from axis
			// create TSL
				TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {};	Entity entsTsl[] = {el0, el1};	Point3d ptsTsl[] = {_Pt0};
				int nProps[]={};
				double dProps[]={dDistanceBottom, dDistanceTop, dDistanceBetween, dDistanceBetweenResult};
				String sProps[]={sDirection,sModeDistribution,sCode};
				Map mapTsl;	
				mapTsl.setInt("iMode", 5);
				//
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
		}//next j
	}//next i
	// delete distribution TSL
	eraseInstance();
	return;
}
if (dDistanceBetween <U(5) && dDistanceBetween>-1)dDistanceBetween.set(U(5));
if (dDistanceBottom < 0)dDistanceBottom.set(U(0));
if (dDistanceTop < 0)dDistanceTop.set(U(0));
sCode.setReadOnly(_kReadOnly);
// calculation
int iModeDistribution = sModeDistributions.find(sModeDistribution);
// even,fixed
if(_Element.length()!=2)
{ 
	reportMessage("\n"+scriptName()+" "+T("|unexpected error|"));
	reportMessage("\n"+scriptName()+" "+T("|2 walls are needed for the connection|"));
	eraseInstance();
	return;
}
//return
Display dp(7);
//dp.draw(scriptName(), _Pt0, _XW, _YW, 0, 0, _kDeviceX);

// first wall
ElementWallSF el0 = (ElementWallSF) _Element[0];
// general data of el0
Point3d ptOrg0 = el0.ptOrg();
Vector3d vecX0 = el0.vecX();
Vector3d vecY0 = el0.vecY();
Vector3d vecZ0 = el0.vecZ();
PLine plOutlineWall0 = el0.plOutlineWall();
PlaneProfile ppEnvelope0 = el0.plEnvelope();
// plane at base of el0
Plane pn0(ptOrg0, vecY0);
CoordSys csHor(pn0.ptOrg(), pn0.vecX(), pn0.vecY(), pn0.vecZ());
PlaneProfile pp0(csHor);
pp0.joinRing(plOutlineWall0, _kAdd);
Point3d ptCen0;
double dX0, dY0, dZ0;
// get extents of profile
{
	LineSeg seg = pp0.extentInDir(vecX0);
	ptCen0 = seg.ptMid();
	
	dX0 = abs(vecX0.dotProduct(seg.ptStart()-seg.ptEnd()));
	dZ0 = abs(vecZ0.dotProduct(seg.ptStart()-seg.ptEnd()));
	//
	// get extents of profile
	seg = ppEnvelope0.extentInDir(vecX0);
	dY0 = abs(vecY0.dotProduct(seg.ptStart() - seg.ptEnd()));
	ptCen0 += (vecY0 * vecY0.dotProduct(seg.ptMid() - ptCen0));
	ptCen0.vis(3);
}
//return
nNailIndex.setReadOnly(true);
int iModesWw[] ={ 2, 3, 4, 5};
Display dpError(1);
dpError.textHeight(U(20));
if (iModesWw.find(iMode) >- 1)
{
	// wall-wall
	if (_Element.length() != 2)
	{
		reportMessage("\n"+scriptName()+" "+T("|unexpected: 2 walls are needed|"));
		eraseInstance();
		return;
	}
	// wall - wall connection
	// Modes 1,2,3,4,5
	ElementWallSF el1 = (ElementWallSF)_Element[1];
	// general data of el1
	Point3d ptOrg1 = el1.ptOrg();
	Vector3d vecX1 = el1.vecX();
	Vector3d vecY1 = el1.vecY();
	Vector3d vecZ1 = el1.vecZ();
	PLine plOutlineWall1 = el1.plOutlineWall();
	plOutlineWall1.projectPointsToPlane(pn0, vecY0);
	PlaneProfile ppEnvelope1 = el1.plEnvelope();
	PlaneProfile pp1(csHor);
	pp1.joinRing(plOutlineWall1,_kAdd);
	Point3d ptCen1;
	double dX1, dY1, dZ1;
	{
		LineSeg seg = pp1.extentInDir(vecX1);
		ptCen1 = seg.ptMid();
		
		dX1 = abs(vecX1.dotProduct(seg.ptStart()-seg.ptEnd()));
		dZ1 = abs(vecZ1.dotProduct(seg.ptStart()-seg.ptEnd()));
		//
		// get extents of profile
		seg = ppEnvelope1.extentInDir(vecX1);
		dY1 = abs(vecY1.dotProduct(seg.ptStart() - seg.ptEnd()));
		ptCen1 += (vecY1 * vecY1.dotProduct(seg.ptMid() - ptCen1));
		ptCen1.vis(3);
	}
	// get corner beams from each wall
	Beam bm0, bm1;
	Vector3d vecX01, vecX10;
	if(iMode==2 || iMode==3)
	{ 
		// corner, T
		{ 
			// male wall, get closest beam to female wall
			Beam beams[] = el0.beam();
			if (beams.length()==0)
			{ 
				return;
				// draw text
				dpError.draw("no beams in element", _Pt0, _XW, _YW, 0, 0, _kDeviceX);
				return;
//				eraseInstance();
//				return;
			}
			for (int i=beams.length()-1; i>=0 ; i--) 
			{ 
				if(beams[i].myZoneIndex()!=0) 
					beams.removeAt(i);
			}//next i
			Beam beamsVer[] = el0.vecX().filterBeamsPerpendicularSort(beams);
			vecX01 = vecX0;
			if (vecX01.dotProduct(ptCen1 - ptCen0) < 0)vecX01 *= -1;
			bm0 = beamsVer[0];
			double dDistMax = vecX01.dotProduct(bm0.ptCen());
			for (int i=0;i<beamsVer.length();i++) 
			{ 
				if(vecX01.dotProduct(beamsVer[i].ptCen())>dDistMax)
				{ 
					bm0 = beamsVer[i];
					dDistMax = vecX01.dotProduct(beamsVer[i].ptCen());
				}
			}//next i
		}
		bm0.envelopeBody().vis(3);
		{ 
			// female wall
			Beam beams[] = el1.beam();
			if (beams.length()==0)
			{ 
				return;
				dpError.draw("no beams in element", _Pt0, _XW, _YW, 0, 0, _kDeviceX);
				return;
				eraseInstance();
				return;
			}
			for (int i=beams.length()-1; i>=0 ; i--) 
			{ 
				if(beams[i].myZoneIndex()!=0) 
					beams.removeAt(i);
			}//next i
			Beam beamsVer[] = el1.vecX().filterBeamsPerpendicularSort(beams);
			vecX10 = vecX1;
			if (vecX10.dotProduct(ptCen0 - ptCen1) < 0)vecX10 *= -1;
			bm1 = beamsVer[0];
			
	//		double dDistMax = vecX10.dotProduct(bm1.ptCen());
	//		for (int i=0;i<beamsVer.length();i++) 
	//		{ 
	//			if(vecX10.dotProduct(beamsVer[i].ptCen())>dDistMax)
	//			{ 
	//				bm1 = beamsVer[i];
	//				dDistMax = vecX10.dotProduct(beamsVer[i].ptCen());
	//			}
	//		}//next i
	
			Body bdTest(bm0.ptCen(), vecX0, vecY0, vecZ0, U(10e8), U(10e8), bm0.dD(vecZ0));
			double dDistMax = -U(10e10);
			
			for (int i=0;i<beamsVer.length();i++) 
			{ 
				if(!beamsVer[i].envelopeBody().hasIntersection(bdTest))
				{ 
					continue;
				}
				double dDist = -vecX01.dotProduct(beamsVer[i].ptCen()-el1.ptOrg());
				if(dDist>dDistMax)
				{ 
					bm1 = beamsVer[i];
					dDistMax = -vecX01.dotProduct(beamsVer[i].ptCen() - el1.ptOrg());
				}
			}//next i
		}
	}
	else if(iMode==4 || iMode==5)
	{ 
		// parallel connected at 2 points or parallel different widths
		{ 
			// male wall
			Beam beams[] = el0.beam();
			if (beams.length()==0)
			{ 
				return;
				dpError.draw("no beams in element", _Pt0, _XW, _YW, 0, 0, _kDeviceX);
				return;
				eraseInstance();
				return;
			}
			for (int i=beams.length()-1; i>=0 ; i--) 
			{ 
				if(beams[i].myZoneIndex()!=0) 
					beams.removeAt(i);
			}//next i
			Beam beamsVer[] = el0.vecX().filterBeamsPerpendicularSort(beams);
			vecX01 = vecX0;
			if (vecX01.dotProduct(ptCen1 - ptCen0) < 0)vecX01 *= -1;
			bm0 = beamsVer[0];
			double dDistMax = vecX01.dotProduct(bm0.ptCen());
			for (int i=0;i<beamsVer.length();i++) 
			{ 
				if(vecX01.dotProduct(beamsVer[i].ptCen())>dDistMax)
				{ 
					bm0 = beamsVer[i];
					dDistMax = vecX01.dotProduct(beamsVer[i].ptCen());
				}
			}//next i
		}
		{ 
			// male wall
			Beam beams[] = el1.beam();
			if (beams.length()==0)
			{ 
				return;
				dpError.draw("no beams in element", _Pt0, _XW, _YW, 0, 0, _kDeviceX);
				return;
				eraseInstance();
				return;
			}
			for (int i=beams.length()-1; i>=0 ; i--) 
			{ 
				if(beams[i].myZoneIndex()!=0) 
					beams.removeAt(i);
			}//next i
			Beam beamsVer[] = el1.vecX().filterBeamsPerpendicularSort(beams);
			vecX10 = vecX1;
			if (vecX10.dotProduct(ptCen0 - ptCen1) < 0)vecX10 *= -1;
			bm1 = beamsVer[0];
			double dDistMax = vecX10.dotProduct(bm1.ptCen());
			for (int i=0;i<beamsVer.length();i++) 
			{ 
				if(vecX10.dotProduct(beamsVer[i].ptCen())>dDistMax)
				{ 
					bm1 = beamsVer[i];
					dDistMax = vecX10.dotProduct(beamsVer[i].ptCen());
				}
			}//next i
		}
	}
	double dPartLength = U(0);
	Point3d ptsDis[0];
	Vector3d vecNail;
	// common range
	if(!bm0.vecX().isParallelTo(bm1.vecX()))
	{ 
		reportMessage("\n"+scriptName()+" "+T("|unexpected studs not parallel|"));
		eraseInstance();
		return;
	}
	
	// get common range
	// outside is female, inside is male
	Point3d ptSide;
	// beam where the nail is applied
	Beam bmPlate;
	if(sDirections.find(sDirection)==1)
	{ 
		// outside
		ptSide = bm1.ptCen() + vecX01 * .5 * bm1.dD(vecX01);
		ptSide.vis(3);
		vecNail = -vecX01;
		bmPlate = bm1;
	}
	else if (sDirections.find(sDirection) == 0)
	{
		// inside
		ptSide = bm0.ptCen() - vecX01 * .5 * bm0.dD(vecX01);
		ptSide.vis(3);
		vecNail = vecX01;
		bmPlate = bm0;
	}
	Plane pn(ptSide, vecX01);
	PlaneProfile ppCommon(pn);
	{ 
		PlaneProfile pp0 = bm0.envelopeBody().shadowProfile(pn);
		
		PlaneProfile pp1 = bm1.envelopeBody().shadowProfile(pn);
		pp0.vis(1);
		pp1.vis(1);
		ppCommon = pp0;
		ppCommon.intersectWith(pp1);
		ppCommon.vis(1);
	}
	// 
	// get extents of profile
	LineSeg seg = ppCommon.extentInDir(vecY0);
	Vector3d vecDir = vecY0;
	double dX = abs(vecZ0.dotProduct(seg.ptStart()-seg.ptEnd()));
	double dY = abs(vecY0.dotProduct(seg.ptStart()-seg.ptEnd()));
	
	if(dY<=0)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|no common range|"));
		reportMessage("\n"+scriptName()+" "+T("|distribution not possible|"));
		eraseInstance();
		return;
	}
	
	Point3d ptStart = seg.ptMid() - vecY0 * .5 * dY;
	Point3d ptEnd = seg.ptMid() + vecY0 * .5 * dY;
	double dLengthTot = dY;
	if(dDistanceBetween+dDistanceTop>dLengthTot)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|no distribution possible|"));
		dpError.draw(scriptName()+"\P "+T("|no distribution possible|"), _Pt0, _XW, _YW, 0, 0, _kDeviceX);
		return;
	}
	ptStart.vis(4);
	ptEnd.vis(4);
	_Pt0 = ptStart; _Pt0 += (ptOrg0 - _Pt0).dotProduct(vecY0) * vecY0;
	Point3d pt1 = ptStart + vecDir * dDistanceBottom;
	Point3d pt2 = ptEnd - vecDir * (dDistanceTop+ dPartLength);
	double dDistTot = (pt2 - pt1).dotProduct(vecDir);
	if (dDistTot < 0)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|no distribution possible|"));
		dpError.draw(scriptName()+"\P "+T("|no distribution possible|"), _Pt0, _XW, _YW, 0, 0, _kDeviceX);
		return;
	}
	// distribution
	if (dDistanceBetween >= 0)
	{ 
		// distance in between > 0; distribute with distance
		// 2 scenarion even, fixed
		if (iModeDistribution == 0)
		{
			// modular distance
			double dDistMod = dDistanceBetween + dPartLength;
			int iNrParts = dDistTot / dDistMod;
			// calculated modular distance between subsequent parts
			
			double dNrParts = dDistTot / dDistMod;
			if (dNrParts - iNrParts > 0)iNrParts += 1;
			
			double dDistModCalc = 0;
			if (iNrParts != 0)
				dDistModCalc = dDistTot / iNrParts;
			
			// first point
			Point3d pt;
			pt = ptStart + vecDir * (dDistanceBottom + dPartLength / 2);
	//				pt.vis(1);
			ptsDis.append(pt);
			if(dDistModCalc>0)
			{ 
				for (int i = 0; i < iNrParts; i++)
				{ 
					pt += vecDir * dDistModCalc;
	//					pt.vis(1);
					ptsDis.append(pt);
				}
			}
			dDistanceBetweenResult.set(dDistModCalc-dPartLength);
			// set nr of parts
	//					dDistanceBetweenResult.set(-(ptsDis.length()));
			nNrResult.set(ptsDis.length());
		}
		else if(iModeDistribution==1)
		{ 
			// fixed
			// distance in between > 0; distribute with distance
			// modular distance
			double dDistMod = dDistanceBetween + dPartLength;
			int iNrParts = dDistTot / dDistMod;
//			double dNrParts=dDistTot / dDistMod;
//			if (dNrParts - iNrParts > 0)iNrParts += 1;
			// calculated modular distance between subsequent parts
			
			double dDistModCalc = 0;
//			if (iNrParts != 0)
//				dDistModCalc = dDistTot / iNrParts;
			dDistModCalc = dDistMod;
			// first point
			Point3d pt;
			pt = ptStart + vecDir * (dDistanceBottom + dPartLength / 2);
		//				pt.vis(1);
			ptsDis.append(pt);
			if(dDistModCalc>0)
			{ 
				for (int i = 0; i < iNrParts; i++)
				{ 
					pt += vecDir * dDistModCalc;
		//					pt.vis(1);
					ptsDis.append(pt);
				}
			}
			// last
			ptsDis.append(ptEnd- vecDir * (dDistanceTop + dPartLength / 2));
			dDistanceBetweenResult.set(dDistModCalc-dPartLength);
			nNrResult.set(ptsDis.length());
		}
	}
	else
	{ 
		double dDistModCalc;
		//
		int nNrParts = -dDistanceBetween / 1;
		if(nNrParts==1)
		{ 
			dDistModCalc = dDistanceBottom;
			ptsDis.append(ptStart + vecDir * dDistanceBottom );
		}
		else
		{ 
			double dDistMod = dDistTot / (nNrParts - 1);
			dDistModCalc = dDistMod;
			int nNrPartsCalc = nNrParts;
			// clear distance between parts
			double dDistBet = dDistMod - dPartLength;
			if (dDistBet < 0)
			{ 
				// distance between 2 subsequent parts < 0
				dDistModCalc = dPartLength;
				// nr of parts in between 
				nNrPartsCalc = dDistTot / dDistModCalc;
				nNrPartsCalc += 1;
			}
			// first point
			Point3d pt;
			pt = ptStart + vecDir * (dDistanceBottom + dPartLength / 2);
			ptsDis.append(pt);
			pt.vis(1);
			for (int i = 0; i < (nNrPartsCalc - 1); i++)
			{ 
				pt += vecDir * dDistModCalc;
				pt.vis(1);
				ptsDis.append(pt);
			}//next i
		}
		// set calculated distance between parts
//					dDistanceBetweenResult.set(dDistModCalc-dPartLength);
		dDistanceBetweenResult.set(dDistModCalc-dPartLength);
		// set nr of parts
		nNrResult.set(ptsDis.length());
	}
	// draw distribution
	for (int i=0;i<ptsDis.length();i++) 
	{ 
		Point3d pt = ptsDis[i];
		PLine pl(vecZ1);
//					pl.createCircle(pt, vecZ1, dPartLength / 2);
		pl.createCircle(pt, vecZ1, U(5));
		dp.draw(pl);
		
		PLine plNail1(pt, pt + vecNail * U(90));
		dp.draw(plNail1);
		PLine plNail2(pt - vecY0 * U(10), pt + vecY0 * U(10));
		dp.draw(plNail2);
		Vector3d vecZnail = vecNail.crossProduct(vecY0);
		PLine plNail3(pt - vecZnail * U(10), pt + vecZnail * U(10));
		dp.draw(plNail3);
		// 
		String ToolIndexKey = "ToolIndex";
		String StartPointKey = "StartPoint";
		String EndPointKey = "EndPoint";
		String MaleBeamHandleKey = "MaleBeamHandle";
		String FemaleBeamHandleKey = "FemaleBeamHandle";
		
		
//		Map itemMap = Map();
//		itemMap.setInt("INDEX",prIndexes);
		
		Map mapCncExportSteelTool;
		mapCncExportSteelTool.setInt(ToolIndexKey, nNailIndex);
		mapCncExportSteelTool.setPoint3d(StartPointKey, pt);
		mapCncExportSteelTool.setPoint3d(EndPointKey, pt + vecNail * U(90));
		mapCncExportSteelTool.setEntity(FemaleBeamHandleKey, bmPlate);
		CncExport cncExportSteelTool("FrameNailTool", mapCncExportSteelTool);
		bmPlate.addTool(cncExportSteelTool);
	}//next i
	bmPlate.envelopeBody().vis(3);
	if(sDirections.find(sDirection)==0)
		_ThisInst.assignToElementGroup(el0,true,0,'T');
	else
		_ThisInst.assignToElementGroup(el1,true,0,'T');
	
	// 
// Trigger Swap Direction//region
	String sTriggerSwapDirection = T("|Swap Direction|");
	addRecalcTrigger(_kContextRoot, sTriggerSwapDirection );
	if (_bOnRecalc && (_kExecuteKey==sTriggerSwapDirection || _kExecuteKey==sDoubleClick))
	{
		if(sDirections.find(sDirection)==0)
			sDirection.set(sDirections[1]);
		else if(sDirections.find(sDirection)==1)
			sDirection.set(sDirections[0]);
			
		setExecutionLoops(2);
		return;
	}//endregion
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
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-10122: Fix TSL assignment, consider only beams of zone 0 for nailing" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="12/21/2021 3:46:29 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End