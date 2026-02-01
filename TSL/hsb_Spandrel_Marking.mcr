#Version 8
#BeginDescription
This tsl marks the studs at the apex of a sloped edge of an stickframe wall.

version value="1.1" date="23mar2021" author="nils.gregor@hsbcad.com"> 
HSB-11028  new setup to cover all situations 

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
/// <History>//region
/// <version value="1.1" date="23mar2021" author="nils.gregor@hsbcad.com"> HSB-11028  new setup to cover all situations </version>
/// <version value="1.0" date="16mar2021" author="nils.gregor@hsbcad.com"> HSB-11028  initial </version>
/// </History>

/// <insert Lang=en>
/// Select properties or catalog entry and press OK, select element 
/// </insert>

/// <summary Lang=en>
/// This tsl marks the studs at the apex of a sloped edge of an stickframe wall.
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Spandrel_Marking_Tool ")) TSLCONTENT
//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
//	{ 
//		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
//		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
//		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
//	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end Constants//endregion


	String sOffsetName=T("|Offset for mark|");	
	PropDouble dOffset(nDoubleIndex++, U(5), sOffsetName);	
	dOffset.setDescription(T("|Defines the Offset|"));
	dOffset.setCategory(category);

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
			if (sEntries.findNoCase(sKey,-1)>-1)			
				setPropValuesFromCatalog(sKey);
			else
				showDialog();					
		}		
		else	
			showDialog();
		
	// collect male beams or elements to insert on every connection
		PrEntity ssE(T("|Select element(s)|"), ElementWallSF());
		if (ssE.go())
			_Element.append(ssE.elementSet());	


	// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE;	Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[] = {};	Entity entsTsl[1];// = {};
		Point3d ptsTsl[1];// = {};
		int nProps[]={};		double dProps[]={};		String sProps[]={};
		Map mapTsl;				String sScriptname = scriptName();
		
		for (int i=0;i<_Element.length();i++) 
		{ 
			entsTsl[0]= _Element[i]; 
			ptsTsl[0]=_Element[i].ptOrg();
			tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
				 nProps, dProps, sProps,_kModelSpace, mapTsl);
		}
		
		eraseInstance();
		return;
	}	
// end on insert	__________________

	//region mapIO: support property dialog input via map on element creation
	{
		int bHasPropertyMap = _Map.hasMap("PROPSTRING[]") && _Map.hasMap("PROPINT[]") && _Map.hasMap("PROPDOUBLE[]");
		if (_bOnMapIO)
		{ 
			if (bHasPropertyMap)
			{
				setPropValuesFromMap(_Map);
			}
			showDialog("---");
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
	}		
//End mapIO: support property dialog input via map on element creation//endregion 
	
// validate selection set
	if (_Element.length()<1 || !_Element[0].bIsKindOf(ElementWall()))		
	{
		reportMessage("\n" + scriptName() + " " + T("|could not find reference to element.|"));
		eraseInstance();
		return;				
	}	
		
// standards
	ElementWall el = (ElementWall)_Element[0];
	CoordSys cs =el.coordSys();
	Point3d ptOrg = cs.ptOrg();	
	Vector3d vecX = cs.vecX();
	Vector3d vecY = cs.vecY();
	Vector3d vecZ = cs.vecZ();
	assignToElementGroup(el, true,0,'E');

	Beam bmAll[] = el.beam();
	Beam bmHors[0], bmVerts[0], bmAngleds[0], bmIDs[0];
	
	if(bmAll.length() < 1)
		return;
	
	Point3d ptCens[0];
	Point3d ptsMarks[0];
	Plane pnZ0(ptOrg, vecZ);
	Plane pnBase(ptOrg, vecY);
	Plane pnSill;
	PlaneProfile ppZ0(pnZ0);
	Point3d ptElMid = el.profNetto(0, false, false).ptMid();
	PlaneProfile ppBase;
	
	//Filter studs and create a basic PlaneProfile as front view to create an inner PlaneProfile later on
	for(int i=0; i < bmAll.length();i++)
	{
		Beam bm = bmAll[i];

		if(bm.vecX().isParallelTo(vecY))
		{
			bmVerts.append(bm);
			ptCens.append(bm.ptCen());		
			PlaneProfile pp = bm.envelopeBody(false, true).shadowProfile(pnZ0);
			pp.shrink(-dEps);
			ppZ0.unionWith(pp);
			
			// Get expected studs for marking as default in case the inner PlaneProfile creation will fail
			if(bm.hsbId() == "26")
			{
				bmIDs.append(bm);
				ptCens.append(bm.ptCen());
			}
		}
		else if(bm.vecX().isParallelTo(vecX))
		{
			bmHors.append(bm);
			PlaneProfile pp = bm.envelopeBody(false, true).shadowProfile(pnZ0);
			pp.shrink(-dEps);
			ppZ0.unionWith(pp);
		}
		else
		{
			bmAngleds.append(bm);
			PlaneProfile pp = bm.envelopeBody(false, true).shadowProfile(pnZ0);
			pp.shrink(-dEps);
			ppZ0.unionWith(pp);
		}
	}
	
	//Without angled beams a marking is impossible
	if(bmAngleds.length() < 1)
	{
		eraseInstance();
		return;
	}
	
	//Check sill plates. It is assumed that only plates that touch eachother are used
	bmHors = vecY.filterBeamsPerpendicularSort(bmHors);
	PlaneProfile ppSill(pnZ0);
	Beam bmSills[0];
	for(int i=0; i < bmHors.length(); i++)
	{
		PlaneProfile ppS = ppSill;
		PlaneProfile pp = (bmHors[i].envelopeBody(false, true).shadowProfile(pnZ0));
		pp.shrink(-dEps);
		ppS.unionWith(pp);
		if(ppS.allRings(true, false).length() == 1)
		{
			ppSill.unionWith(pp);
			bmSills.append(bmHors[i]);
		}		
	}	
	
	if(bmSills.length() < 1 || ppSill.area() < pow(dEps,2))
	{
		reportMessage(TN("|No plates found. Instance deleted| " + scriptName()));			
		eraseInstance();
		return;				
	}
	
	//Create base PlaneProfile with all vertical studs touching. Connected studs will create one ring
	{ 
		LineSeg seg = ppSill.extentInDir(vecY);
		pnSill = Plane (seg.ptEnd() + vecY * U(5), bmSills[0].vecD(vecY)); pnSill.vis(2);
		ppBase = PlaneProfile(pnSill);
		
		for(int i=0; i < bmVerts.length(); i++)
		{
			PlaneProfile ppB = bmVerts[i].envelopeBody().extractContactFaceInPlane(pnSill, U(10));
			ppB.shrink(-dEps);
			ppBase.unionWith(ppB);			
		}
	}	
	ppBase.shrink(dEps); ppBase.vis(2);
	
	// If creation of inner profile failed, fall back to simpler creation
	PLine plZ0s[] = ppZ0.allRings(true, false);	
	if(plZ0s.length() != 1)
	{
		for(int i=0; i < bmIDs.length(); i++)
			ptsMarks.append(bmIDs[i].ptCen());
			
		if(ptsMarks.length() < 1)
			plZ0s = el.profNetto(0,false,false).allRings();
	}
	else // create outer PlaneProfile
		ppZ0 = PlaneProfile(plZ0s[0]);
	
	// Create inner PlaneProfile and get marking points if the Planeprofile exists
	if(ptsMarks.length() <1)
	{	
		//Substract all horizontal beams to create inner PlaneProfile
		for(int i=0; i < bmHors.length(); i++)
		{
			PlaneProfile pp = bmHors[i].envelopeBody().shadowProfile(pnZ0);
			pp.shrink(-dEps);
			ppZ0.subtractProfile(pp);		
		}
				
		PLine pls[] = ppZ0.allRings(true, false);
		if(pls.length() < 1)
		{ 
			eraseInstance();
			return;
		}
		ppZ0 = PlaneProfile(pls[0]);
		
		// Substract all angled beams to create inner PlaneProfile
		for(int i=0; i < bmAngleds.length(); i++)
		{
			PlaneProfile pp = bmAngleds[i].envelopeBody(false, true).shadowProfile(pnZ0);
			pp.shrink(-dEps);
			ppZ0.subtractProfile(pp);	
			PLine plTests[] = ppZ0.allRings();
			
			if(plTests.length() > 1)
			{
				for(int j = plTests.length()-1; j > -1; j--)
				{
					PlaneProfile ppTest(plTests[j]);
					int bSub;
					
					for(int k=0; k < ptCens.length();k++)
					{
						if(ppTest.pointInProfile(ptCens[k]))
							break;
						if(k == ptCens.length())
						{
							bSub = true;
						}
					}
					if(bSub)
						plTests.removeAt(j);
				}
				
				if(plTests.length() == 1)
				{
					ppZ0 = PlaneProfile(plTests[0]);
				}
				else
				{
					for(int i=0; i < bmIDs.length(); i++)
						ptsMarks.append(bmIDs[i].ptCen());
			
					if(ptsMarks.length() < 1)
					{
						reportMessage(TN("|Unexpected error of| " + scriptName()));			
						eraseInstance();
						return;					
					}					
				}
			}
			else if(plTests.length() == 1)
			{
				ppZ0 = PlaneProfile(plTests[0]);
			}
			else 
			{
				for(int i=0; i < bmIDs.length(); i++)
					ptsMarks.append(bmIDs[i].ptCen());
			
				if(ptsMarks.length() < 1)
				{
					reportMessage(TN("|Unexpected error of| " + scriptName()));			
					eraseInstance();
					return;					
				}
			}
		}	
		ppZ0.vis(6);	
		ppZ0.shrink(dEps);
		Point3d ptVertexs[] = ppZ0.getGripVertexPoints();
		
		if(ptVertexs.length() < 3)
		{ 
			eraseInstance();
			return;
		}
		
		// Extreme points get no marks
		Point3d ptsExtrem[0];
		ptsExtrem.append(ptVertexs.first());
		ptsExtrem.append(ptVertexs.last());
		Point3d ptsToCheck[0];
		
		// All vertex points which are not in an 90° angle are used
		for(int i=0; i < ptVertexs.length();i++)
		{
			Point3d ptPrev = (i == 0) ? ptVertexs.last() : ptVertexs[i - 1];
			Point3d ptNext = (i == ptVertexs.length() - 1) ? ptVertexs[0] : ptVertexs[i + 1];
			
			double dAngle = Vector3d (ptVertexs[i] - ptPrev).angleTo(Vector3d (ptNext - ptVertexs[i]));
			
			if(dAngle > dEps && dAngle < 90-dEps || dAngle > 90+dEps && dAngle < 180-dEps)
				ptsToCheck.append(ptVertexs[i]);		
		}
	
	// Delete eventual point at the rigde	
		Point3d ptTops[] = Line(ptOrg, vecY).orderPoints(ptVertexs);
		for (int i = ptTops.length() - 2; i > - 1; i--)
		{
			double d = abs(vecY.dotProduct(ptTops.last() - ptTops[i]));
			if (d > U(10))
				ptTops.removeAt(ptTops.length() - 1);
			break;
		}
		ptVertexs = ptTops;
		
		if(ptVertexs.length() < 3)
		{ 
			eraseInstance();
			return;
		}
		
		ptsToCheck = Line(ptOrg, vecX).orderPoints(ptsToCheck);
		
		ptsToCheck.removeAt(ptsToCheck.length() - 1);
		ptsToCheck.removeAt(0);
		
		ptsMarks = ptsToCheck;
	}
	
	if(ptsMarks.length() < 1)
	{
		eraseInstance();
		return;
	}
	
	double dZ0W = el.dBeamWidth();
	Point3d ptZMid = ptOrg - vecZ * 0.5 * dZ0W; 
	
	// Decompose PlaneProfile in single PlaneProfiles for accurate check
	PLine plsBase[] = ppBase.allRings(true, false);
	PlaneProfile ppBases[0];
	for(int i=0; i < plsBase.length(); i++)
	{
		ppBases.append(PlaneProfile(plsBase[i]));
	}
	
	for(int i=0; i < ptsMarks.length(); i++)
	{
		Point3d ptM = ptsMarks[i];
		ptM += vecZ * vecZ.dotProduct(ptZMid - ptM); ptM.vis(5);
		
		for(int j=0; j < ppBases.length(); j++)
		{
			int bBreak;
			PlaneProfile pp = ppBases[j];
			
			//Check different positions along vecZ
			for(int k=0; k < 3; k++)
			{
				if(k == 1)
					ptM -= vecZ * 0.25 * dZ0W;
				if(k == 2)
					ptM += vecZ * 0.25 * dZ0W;
					
				ptM = Line(ptM, vecY).intersect(pnSill,0);
					
				if(pp.pointInProfile(ptM) == _kPointInProfile)
				{						
					LineSeg seg = pp.extentInDir(vecX);		
					
					for(int k=0; k < 2; k++)
					{
						ptM = (k == 0)? seg.ptStart() : seg.ptEnd();
						int nSign = (k == 0) ? - 1 : 1;
						Beam bmMarks[] = Beam().filterBeamsHalfLineIntersectSort(bmSills, ptM, - vecY);
						if(bmMarks.length() < 1)
							bmMarks.append(bmSills.last());
						
						//Check against existing marks
						int bMark = true;
						AnalysedTool ants[] = bmMarks[0].analysedTools();
						for(int l=0; l < ants.length(); l++)
						{
							String s= ants[l].toolType();
							if(ants[l].toolType() == "AnalysedMarker")
							{
								if(abs(vecX.dotProduct(ptM - ((AnalysedMarker)ants[l]).ptOrg() + nSign*vecX*dOffset)) < dEps)
								{
									bMark = false;
									break;
								}
							}
						}
						
						if(bMark)
						{
							Vector3d vecM = bmMarks[0].vecD(vecY);
							ptM += vecY * vecY.dotProduct(bmMarks[0].ptCen() + 0.5 * vecM * bmMarks[0].dD(vecM)- ptM);
							Mark mk(ptM + nSign* vecX*dOffset , vecY);
							bmMarks[0].addToolStatic(mk);						
						}						
					}
					bBreak = true;
					break;
				}				
			}
			if(bBreak)
				break;
		}
	}

	if(! _bOnDebug)
	{
		eraseInstance();
	}
	
	
	
	
	
	
		
	
	
	

	


	
	
#End
#BeginThumbnail



#End
#BeginMapX

#End