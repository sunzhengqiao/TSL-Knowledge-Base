#Version 8
#BeginDescription
#Versions: 
Version 2.6 04/03/2025 HSB-23612: Add extra tolerance if beamcut face exactly aligns with genbeam face , Author Marsel Nakuci
Version 2.5 11.11.2024 HSB-22941: When attached to installation point and length 0 use the width of the active side (reference/opposite) of the hsbInstallationPoint , 
2.4 25.01.2024 HSB-21189: dont change grips if trigger comes from moving the grips 
2.3 13.04.2023 HSB-18550: Make sure TSL gets updated if genbeam dimensions get changed 
version value="2.2" date="29apr2019" author="thorsten.huck@hsbcad.com"
HSB-4858 splitting, adding and removing of beams enhanced
validation on element deleted 
alignment limited to bottom side when attached to a wall

grip behaviour fixed of walls, openings or installation points
supports also selection of walls, openings or installation points, display supports view directions 

bugfix validation

tool can be copied
alignment property based on ECS </version>
NOTE: properties have been changed, catalogs of previous versions are most likely invalid
automatic conversion of instances created by a previous version
new commands and behaviour on grip changes, grips can be used to alter all dimensions

This tsl creates a beamcut on one face of a beam.




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 6
#KeyWords Beam;Beamcut
#BeginContents
/// <History>//region
/// #Versions:
// 2.6 04/03/2025 HSB-23612: Add extra tolerance if beamcut face exactly aligns with genbeam face , Author Marsel Nakuci
// 2.5 11.11.2024 HSB-22941: When attached to installation point and length 0 use the width of the active side (reference/opposite) of the hsbInstallationPoint , Author Marsel Nakuci
// 2.4 25.01.2024 HSB-21189: dont change grips if trigger comes from moving the grips Author: Marsel Nakuci
// 2.3 13.04.2023 HSB-18550: Make sure TSL gets updated if genbeam dimensions get changed Author: Marsel Nakuci
/// <version value="2.2" date="29apr2019" author="thorsten.huck@hsbcad.com"> HSB-4858 splitting, adding and removing of beams enhanced, description updated </version>
/// <version value="2.1" date="29apr2019" author="thorsten.huck@hsbcad.com"> HSB-4858 splitting, adding and removing of beams enhanced </version>
/// <version value="2.0" date="26feb2019" author="thorsten.huck@hsbcad.com"> validation on element deleted </version>
/// <version value="1.9" date="19feb2019" author="thorsten.huck@hsbcad.com"> alignment limited to bottom side when attached to a wall </version>
/// <version value="1.8" date="19feb2019" author="thorsten.huck@hsbcad.com"> grip behaviour fixed of walls, openings or installation points </version>
/// <version value="1.7" date="01feb2019" author="thorsten.huck@hsbcad.com"> supports also selection of walls, openings or installation points, display supports view directions </version>
/// <version value="1.6" date="31jan2019" author="thorsten.huck@hsbcad.com"> supports also selection of walls, openings or installation points </version>
/// <version value="1.5" date="08nov2018" author="thorsten.huck@hsbcad.com"> bugfix validation </version>
/// <version value="1.4" date="09aug2018" author="thorsten.huck@hsbcad.com"> tool can be copied </version>
/// <version value="1.3" date="09aug2018" author="thorsten.huck@hsbcad.com"> alignment property based on ECS </version>
/// <version value="1.2" date="31jul2018" author="thorsten.huck@hsbcad.com"> revised, NOTE: properties have been changed, catalogs of previous versions are most likely invalid, new commands and behaviour on grip changes, grips can be used to alter all dimensions </version>
/// <version value="1.1" date="17may2017" author="thorsten.huck@hsbcad.com"> alignment options reduced and insert mechanism redesigned </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a beamcut on one face of a beam.

// command to insert
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbBeamcut")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Beam|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Beam|") (_TM "|Select Tool|"))) TSLCONTENT
/// </summary>//endregion


//region constants 
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
//end constants//endregion
	
//region Properties
// GEOMETRY
	category = T("|Geometry|");
	String sLengthName=T("|Length|");	
	PropDouble dLength(nDoubleIndex++, U(300), sLengthName);	
	dLength.setDescription(T("|Defines the Length|") + + " " +T("|0 = full length|") + T(" |If dependent from an installation or opening the location is fixed if length <=0|"));
	dLength.setCategory(category);

	String sWidthName=T("|Width|");	
	PropDouble dWidth(nDoubleIndex++, U(30), sWidthName);	
	dWidth.setDescription(T("|Defines the Width|") + " " +T("|0 = complete|"));
	dWidth.setCategory(category);

	String sDepthName=T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(30), sDepthName);	
	dDepth.setDescription(T("|Defines the Depth|"));
	dDepth.setCategory(category);

// Alignment
	category = T("|Alignment|");
	String sAxisOffsetName=T("|Offset|");	
	PropDouble dAxisOffset(nDoubleIndex++, U(0), sAxisOffsetName);	
	dAxisOffset.setDescription(T("|Defines the Offset|") + " " + T("|Use '+' or '-' to align to an edge, enter a value to specify offset from axis|"));
	dAxisOffset.setCategory(category);

	String sReferenceSideName=T("|Reference Side|");
	String sReferenceSides[] = {T("|ECS| Y"),T("|ECS| Z"), T("|ECS| -Y"),T("|ECS| -Z")};
	int nRefColors[] ={ 140,170,230, 120};
	PropString sReferenceSide(nStringIndex++, sReferenceSides, sReferenceSideName);	
	sReferenceSide.setDescription(T("|Defines the Reference Side|") + T(" |This option is irrelevant if not linked to a beam.|") );
	sReferenceSide.setCategory(category);	
//End Properties//endregion 
	
//region onInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return;}

	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();

		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();	
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
		else	
			showDialogOnce();
		
	
	// resolve properties
		int nReferenceSide = sReferenceSides.find(sReferenceSide);


	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select reference item (Beam, Walls, E-Installations or Doors)|"), Beam());
		ssE.addAllowedClass(ElementWallSF());
		ssE.addAllowedClass(OpeningSF());
		ssE.addAllowedClass(TslInst());
		if (ssE.go())
			ents.append(ssE.set());
		
	// distinguish between genbeam or other classes, beam and wall class supports only one item at a time as it requires point input
		GenBeam gb;
		ElementWallSF el;
		OpeningSF openings[0];
		TslInst installations[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			if (gb.bIsValid() || el.bIsValid())break;
			GenBeam _gb = (GenBeam)ents[i]; 
			if (_gb.bIsValid())
			{
				gb = _gb;
				break;
			}
			
			ElementWallSF _el = (ElementWallSF)ents[i]; 
			if (_el.bIsValid())
			{
				el = _el;
				break;
			}
			
			OpeningSF _op = (OpeningSF)ents[i]; 
			if (_op.bIsValid() && openings.find(_op)<0)
			{
				openings.append(_op);
				continue;
			}
			
			TslInst t = (TslInst)ents[i];
			if (t.bIsValid())
			{ 
				Map m = t.map();
				if ( ! m.hasPoint3dArray("ptsConduitExtremes"))continue;
				installations.append(t);
			}
		}//next i
		
		//reportMessage("\n " + gb.bIsValid() + " GenBeam,  "+ el.bIsValid() + " Element,  "+ openings.length() + " opening,  "+ + installations.length() + " Installations");
		
	//region GenBeam or element mode
		int bGetPoint;
		Point3d ptCen;
		Vector3d vecXB, vecYB, vecZB;	
		Opening op;
		if(gb.bIsValid())
		{
			_Map.appendEntity("GenBeam", gb);

			ptCen = gb.ptCen();
			vecXB = gb.vecX();
			vecYB = gb.vecY();
			vecZB = gb.vecZ();	
			bGetPoint = true;
		}
		else if (el.bIsValid())
		{ 
			_Element.append(el);
	
			ptCen = el.ptOrg();
			vecXB = el.vecX();
			vecYB = el.vecY();
			vecZB = el.vecZ();	
			
			bGetPoint = true;
		}
	// opening	
		else if (openings.length()==1 && dLength>0)
		{ 
			op = openings[0];
			Element el = op.element();
			_Opening.append(op);
			CoordSys cs = op.coordSys();
			ptCen = PlaneProfile(op.plShape()).extentInDir(cs.vecX()).ptMid();
			ptCen += cs.vecY() * cs.vecY().dotProduct(el.ptOrg() - ptCen);
			vecXB = el.vecX();
			vecYB = el.vecY();
			vecZB = el.vecZ();
			bGetPoint = true;
		}
	//End GenBeam or element mode//endregion 
	
	// point request
		if (bGetPoint)
		{ 
		// prompt insertion points
			Point3d ptLast;
			String sMsg = T("|Pick point to specify length by points|") +  T(", |<Enter> to insert full length|");//+ " " +T("|Revert direction to swap side.|") 
			if (dLength>0)
				sMsg = T("|Insertion Point|");
			
				
		// get first point
			PrPoint ssP(sMsg);
			if (ssP.go() == _kOk)
			{
				ptLast = ssP.value();
				_PtG.append(ptLast);
			}
		
		// get second point	
			if (_PtG.length()>0)
			{
			// set prompt
				if (dLength>0)
					sMsg = T("|Specify direction|")+T(", |<Enter> to insert at center|");	//+ " " + T("|Revert direction to swap side.|")
				else
					sMsg = T("|Pick second point|");
					
			// get second point	
				ssP =PrPoint(sMsg, ptLast);
				if (ssP.go() == _kOk)
				{
					ptLast = ssP.value(); // retrieve the selected point
					_PtG.append(ptLast); // append the selected points to the list of grippoints _PtG
				}
			}
			
	
		// two valid grips
			Vector3d vecDir = gb.vecX();
			if (_PtG.length()==2)
			{
			// given length, direction specified
				if(dLength>0)
				{
					if (vecDir.dotProduct(_PtG[1]-_PtG[0])<0)
						vecDir *= -1;
					_PtG[1] = _PtG[0] + vecDir * dLength;
					_Pt0.setToAverage(_PtG);// = _PtG[0]+vecDir*.5*dLength;
				}			
			// set length based on grips	
				else			
				{
					_Pt0.setToAverage(_PtG);
					dLength.set(abs(gb.vecX().dotProduct(_PtG[1]-_PtG[0])));				
				}
			}
		// one grip given and length > 0 means use first grip as center	
			else if (dLength>0 && _PtG.length()==1)
			{
				_Pt0 = _PtG[0];
				_PtG[0] = _Pt0-vecDir*.5*dLength;	
				_PtG.append(_Pt0+vecDir*.5*dLength);
			}
		// no grip and no length given genbeam
			else if (gb.bIsValid())
			{
				_Pt0 = gb.ptCenSolid();
				dLength.set(gb.solidLength());
			}
		// no grip and no length given element
			else if (el.bIsValid())
			{
				_Pt0 = el.ptOrg();
				LineSeg seg = el.segmentMinMax();
				dLength.set(abs(el.vecX().dotProduct(seg.ptEnd()-seg.ptStart())));
			}
		// no grip and no length given element
			else if (op.bIsValid())
			{
				_Pt0 = ptCen+vecXB*.5*op.width();
				dLength.set(op.width());
			}			
			else
			{ 
				reportMessage("\n"+scriptName()+" "+T("|Unexpected error|"));
				//eraseInstance();
			}
		}
	// multiple inserts
		else
		{ 
			Entity ents[0];
			for (int i = 0; i < installations.length(); i++) ents.append(installations[i]);
			for (int i = 0; i < openings.length(); i++) ents.append(openings[i]);
			
		// create TSL
			TslInst tslNew; Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
			GenBeam gbsTsl[]={}; Entity entsTsl[1]; Point3d ptsTsl[]={_Pt0};
			int nProps[]={}; double dProps[]={dLength,dWidth,dDepth,dAxisOffset}; String sProps[]={sReferenceSide};
			Map mapTsl;
			
			for (int i=0;i<ents.length();i++) 
			{ 
				//reportMessage("\n" + scriptName() + ": " +T("|creating tool dependent to| ") + ents[i].typeDxfName());
				
				Element el = ents[i].element();
				if (el.bIsValid())
				{ 
					vecXTsl = el.vecX();
					vecYTsl = el.vecY();
				}
//				reportMessage("\nelement is valid " + el.bIsValid());
				
				int n1 = installations.find(ents[i]);
				int n2 = openings.find(ents[i]);
				if (n1 >- 1)
				{
					String sArMill[] = {T("|None|"),T("|Bottom|"),T("|Top|"),T("|Both|")};
					int nMill = sArMill.find(installations[n1].propString(0));
					if (nMill <2)sProps[0] = sReferenceSides[2];
					else if (nMill ==2)sProps[0] = sReferenceSides[0];
					ptsTsl[0] = installations[n1].ptOrg();
					
					// top, bottom. one beamcut for top and one beamcut for bottom
					int bTop, bBottom;
					// 
					int bTopRef,bTopOpp,bBottomRef,bBottomOpp;
					
					// milling on reference side
					int nMillRef=sArMill.find(installations[n1].propString(0));
					// milling on opposite side
					int nMillOpp=sArMill.find(installations[n1].propString(1));
					
					if(nMillRef==1 || nMillRef==3)
					{ 
						bBottomRef=true;
					}
					if(nMillRef==2 || nMillRef==3)
					{ 
						bTopRef=true;
					}
					if(nMillOpp==1 || nMillOpp==3)
					{ 
						bBottomOpp=true;
					}
					if(nMillOpp==2 || nMillOpp==3)
					{ 
						bTopOpp=true;
					}
					// create tsl on top and on bottom
					entsTsl[0]=ents[i];
					if(bTopRef || bTopOpp)
					{ 
						// tsl on top
						mapTsl.setInt("InstallationPointBottom",false);
						sProps[0] = sReferenceSides[0];
						tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
					}
					if(bBottomRef || bBottomOpp)
					{ 
						// tsl on bottom
						mapTsl.setInt("InstallationPointBottom",true);
						sProps[0] = sReferenceSides[2];
						tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
					}
				}
				else if (n2 >- 1)
				{
					Opening opening = openings[n2];
					Point3d pt = PlaneProfile(opening.plShape()).extentInDir(el.vecX()).ptMid();
					pt += el.vecY() * el.vecY().dotProduct(el.ptOrg() - pt);
					ptsTsl[0] =pt;
					sProps[0] = sReferenceSides[2];
					//
					entsTsl[0] = ents[i];
					tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
				}
//				entsTsl[0] = ents[i];
//				tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
			}//next i
			eraseInstance();
		}
		
		return;
	}
//end on insert________________________________________________________//endregion 
	
// get/set ints
	int nReferenceSide = sReferenceSides.find(sReferenceSide);
	int nc=nReferenceSide>-1?nRefColors[nReferenceSide]:230;
	
	//reportMessage("\ncollected genbeams " + _GenBeam.length() );
	
// get type
	GenBeam gbRef, genbeams[0];
	ElementWallSF elRef;
	OpeningSF opening;
	TslInst installation; int bTopBottomInstallation;
	int bGetAutoLength;
	if (_Map.hasEntity("GenBeam"))
	{
		//reportMessage("\nref mode = 1");
		Entity ent =  _Map.getEntity("GenBeam");
		gbRef = (GenBeam)ent;
		if (!gbRef.bIsValid())
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|invalid reference.|"));
			eraseInstance();
			return;				
		}
		for (int i=0;i<_Map.length();i++) 
		{ 
			if (_Map.keyAt(i)=="GenBeam")
			{
				ent = _Map.getEntity(i);
				GenBeam gb = (GenBeam)ent;
				if (gb.bIsValid())
				{
					_GenBeam.append(gb); 
					_Map.removeAt(i, true);
				}
			}	 
		}//next i
	}
	else if (_Element.length() > 0)
	{
		//reportMessage("\nref mode = 2");
		elRef = (ElementWallSF)_Element[0];
		setDependencyOnEntity(elRef);
		
	// limit alignment in wall mode
		if (nReferenceSide!=2)
		{ 
			sReferenceSide.set(sReferenceSides[2]);
			nReferenceSide = 2;
		}
		sReferenceSide.setReadOnly(true);
		//_Pt0+=elRef.vecZ()*(elRef.vecZ().dotProduct(elRef.ptOrg()-_Pt0)-.5*elRef.dBeamWidth());
	}
	else if (_Opening.length() > 0)
	{
		//reportMessage("\nref mode = 3");
		opening = (OpeningSF)_Opening[0];
		setDependencyOnEntity(opening);
		if (dLength <= dEps)bGetAutoLength = true;
		Element e = opening.element();
		Point3d pt = _Pt0;
		if (dLength<=dEps)pt=PlaneProfile(opening.plShape()).extentInDir(e.vecX()).ptMid();
		pt += e.vecY() * e.vecY().dotProduct(e.ptOrg() - pt);
		_Pt0 = pt;
		sReferenceSide.setReadOnly(true);
	}
	else if (_Entity.length() > 0 && _Entity[0].bIsKindOf(TslInst()))
	{
		//reportMessage("\nref mode = 4");
		installation = (TslInst)_Entity[0];
		setDependencyOnEntity(installation);
		if (dLength <= dEps)bGetAutoLength = true;
		
		bTopBottomInstallation = installation.propString(0) == T("|Both|");
		Point3d ptsConduit[] = installation.map().getPoint3dArray("ptsConduitExtremes");
		Point3d pt=installation.ptOrg();
		Point3d ptsConduitSort[]=Line(_Pt0,_ZW).orderPoints(ptsConduit);
		if(_Map.hasInt("InstallationPointBottom"))
		{ 
			if(ptsConduitSort.length()>0)
				if(_Map.getInt("InstallationPointBottom"))
				{
					// bottom
					pt=ptsConduitSort.first();
				}
				else if(!_Map.getInt("InstallationPointBottom"))
				{ 
					// top
					pt=ptsConduitSort.last();
				}
		}
		else 
		{ 
			if (ptsConduit.length()>1)
			{ 
				if (nReferenceSide <2)pt=ptsConduit[1];
				else pt=ptsConduit[0];
			}
		}	
		
		_Pt0 = pt;
	}
// legacy	
	else if (_GenBeam.length()>0)
	{ 
		//reportMessage("\nref mode = 5 bGetAutoLength" +bGetAutoLength);
		gbRef=_GenBeam[0];
		//_GenBeam.append(_GenBeam);
	}
	else
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|invalid reference.|"));
		eraseInstance();
		return;	
	}
	if (bGetAutoLength)_PtG.setLength(0);
	
//region get element ref 
	GenBeam gb = gbRef;
	Element el=elRef;
	if (!gb.bIsValid())//if not in genbeam mode
	{ 
		if (installation.bIsValid())
			el = installation.element();
		else if (opening.bIsValid())
			el = opening.element();
		else if (elRef.bIsValid())
			_Pt0 += elRef.vecY() * elRef.vecY().dotProduct(elRef.ptOrg() - _Pt0);
	}
	else
		el = gb.element();
	
// element assignment	
	if (el.bIsValid())assignToElementGroup(el, true, 0, 'T');
	
// get beams by element reference
	if (!gb.bIsValid())
	{ 
		//reportMessage("\n" + _ThisInst.handle()+" get beams by element ");
		Vector3d vecX = el.vecX();
		Vector3d vecY = el.vecY();
		Vector3d vecZ = el.vecZ();
		Beam beams[] = el.beam();
	
	// remove vertical beams
		for (int i=beams.length()-1; i>=0 ; i--)  
			if(beams[i].vecX().isParallelTo(vecY))
				beams.removeAt(i); 
		Point3d ptRef = _Pt0 + vecZ * (vecZ.dotProduct(el.ptOrg() - _Pt0));
		_Pt0 += vecZ * (vecZ.dotProduct(ptRef - _Pt0)-.5 * el.dBeamWidth());
		
	// find intersecting beam
		double dX = dLength;
		double dY = dDepth;
		double dZ = dWidth;
		
		double dYFlag = nReferenceSide<2?-1:1;
		double dZFlag = - 1;
		
		//el.plOutlineWall().vis(4);
		if (dX <= dEps && installation.bIsValid())
		{
			// HSB-22941
			if(_Map.hasInt("InstallationPointBottom"))
			{ 
				String sArMill[]={T("|None|"),T("|Bottom|"),T("|Top|"),T("|Both|")};
				int bTopRef,bTopOpp,bBottomRef,bBottomOpp;
				// bottom, 
				int nMillRef=sArMill.find(installation.propString(0));
				// milling on opposite side
				int nMillOpp=sArMill.find(installation.propString(1));
				//
				if(nMillRef==1 || nMillRef==3)
				{ 
					bBottomRef=true;
				}
				if(nMillRef==2 || nMillRef==3)
				{ 
					bTopRef=true;
				}
				if(nMillOpp==1 || nMillOpp==3)
				{ 
					bBottomOpp=true;
				}
				if(nMillOpp==2 || nMillOpp==3)
				{ 
					bTopOpp=true;
				}
				// calculate width
				if(_Map.getInt("InstallationPointBottom"))
				{ 
					// bottom beamcut instance
					double dwref,dwopp;
					if(bBottomRef)
					{ 
						dwref=installation.propDouble(0);
					}
					if(bBottomOpp)
					{ 
						dwopp=installation.propDouble(2);
					}
					dX=dwref>dwopp?dwref:dwopp;
				}
				else if(!_Map.getInt("InstallationPointBottom"))
				{ 
					// top beamcut instance
					double dwref,dwopp;
					if(bTopRef)
					{ 
						dwref=installation.propDouble(0);
					}
					if(bTopOpp)
					{ 
						dwopp=installation.propDouble(2);
					}
					dX=dwref>dwopp?dwref:dwopp;
				}
			}
			else
			{ 
				dX = installation.propDouble(0);
			}
		}
		else if (dX <= dEps && opening.bIsValid())dX = opening.width();
		if (dZ <= 0) dZ = el.dBeamWidth();
		
		if (dX>dEps && dY>dEps && dZ>dEps)
		{ 
			Body bd(ptRef, vecX, vecY, vecZ, dX, dY, dZ, 0, dYFlag, dZFlag);
			bd.vis(6);
			
			Beam _beams[] = bd.filterGenBeamsIntersect(beams);
			if (_beams.length()>0)
			{
				gb = _beams[0];
				for (int i=0;i<_beams.length();i++) 
				{ 
					_GenBeam.append(_beams[i]); 
				}//next i
			}
			
		// wait	
			if (!gb.bIsValid())
			{ 
				Display dpPlan(nc), dpModel(nc), dpElement(nc);
				if (bTopBottomInstallation)	dpModel.addHideDirection(vecY);
				dpPlan.addViewDirection(vecY);
				dpElement.addViewDirection(vecZ);
				dpElement.addViewDirection(-vecZ);
				dpModel.draw(bd);
				
				PlaneProfile ppPlan = bd.shadowProfile(Plane(ptRef, vecY));
				LineSeg seg = ppPlan.extentInDir(vecX);
				Vector3d vecDir = seg.ptEnd() - seg.ptStart(); vecDir.normalize();
				Vector3d vecPerp = vecDir.crossProduct(vecY);
				if (nReferenceSide == 0)vecPerp *= -1;
				PlaneProfile ppSub;
				ppSub.createRectangle(LineSeg(seg.ptStart(), seg.ptEnd() + vecPerp * U(1000)), vecDir, vecPerp);
				ppPlan.subtractProfile(ppSub);
				
				dpElement.draw(bd.shadowProfile(Plane(ptRef, vecZ)), _kDrawFilled, 70);
				dpPlan.draw(ppPlan, _kDrawFilled, 70);
				dpPlan.draw(ppPlan);


			// on the event of changing a grip
				String sGrips[] ={ "_PtG0", "_PtG1"};
				int nGripChanged = sGrips.find(_kNameLastChangedProp);
				if (nGripChanged==0 || nGripChanged==1)
				{
					Point3d ptRef = _Pt0 + (nReferenceSide < 2 ?- 1 : 1) * vecY * dY;
					
					double dNewX = abs(vecX.dotProduct(_PtG[0] - _PtG[1]));
					double dNewY = abs(vecY.dotProduct(_PtG[0] - _PtG[1]));
					double dNewZ = vecZ.dotProduct(ptRef-_PtG[nGripChanged]);
				
				// change depth only if length and width has not changed	
					if (dNewZ>0 && abs(dLength-dNewX)<dEps && abs(dWidth-dNewY)<dEps)
					{
						dDepth.set(dNewZ);		
					}
				
				// change width only if length has not changed	
//					else if (abs(dLength-dNewX)<dEps)
//					{
//						dWidth.set(abs(vecY.dotProduct(_PtG[0]-_PtG[1])));
//						dAxisOffset.set(vecY.dotProduct((_PtG[0]+_PtG[1])/2 - _Pt0));
//					}
//				// change length in any other case
//					else if (abs(dLength-dNewX)>dEps)
//					{	
//						dLength.set(dNewX);
//						_PtG[nGripChanged].transformBy(vecY*(vecY.dotProduct(ptRef-_PtG[nGripChanged])+(nGripChanged==0?-1:1)*.5*dY));
//					}
					else
					{ 
						// HSB-21189: allow to change width and length at same time
						_PtG[nGripChanged]=Plane(ptRef,vecZ).closestPointTo(_PtG[nGripChanged]);
						dWidth.set(abs(vecY.dotProduct(_PtG[0]-_PtG[1])));
						dAxisOffset.set(vecY.dotProduct((_PtG[0]+_PtG[1])/2 - _Pt0));
						
						dLength.set(dNewX);
//						_PtG[nGripChanged].transformBy(vecY*(vecY.dotProduct(ptRef-_PtG[nGripChanged])+(nGripChanged==0?-1:1)*.5*dY));
					}
					_Pt0.setToAverage(_PtG);
					setExecutionLoops(2);
					return;
				}


				if (_PtG.length()>1)
				{
					_PtG[0] = _Pt0-.5*(vecX*dX+vecZ*dZ);
					_PtG[1] = _Pt0+.5*(vecX*dX+vecZ*dZ)+(nReferenceSide<2?-1:1)*vecY*dY;
				}
				
				
				return;
			}
			
		}
		else
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|invalid tool dimensions|"));
			eraseInstance();
			return;
			
		}
	}	
//End get element ref if not in genbeam mode//endregion 


	if (!gb.bIsValid())
	{
		reportMessage("\n"+scriptName()+" "+T("|Unexpected error|"));
		Display dp(1);
		dp.draw(scriptName(), _Pt0, _XW, _YW, 0, 0);
		return;
	}
// assignment
	if (!el.bIsValid())assignToGroups(gb,'T');

// the reference beam
	setKeepReferenceToGenBeamDuringCopy(true);
	Point3d ptCen = gb.ptCen();
	Vector3d vecXB = gb.vecX();
	Vector3d vecYB = gb.vecY();
	Vector3d vecZB = gb.vecZ();
	Quader qdr(ptCen, vecXB, vecYB, vecZB,gb.solidLength(), gb.dW(),gb.dH(), 0,0,0);
	Line ln(ptCen, vecXB);
	
//// convert tsl from old property structure into new //region
//	String sOldSide = _ThisInst.propString(1);
//	if (sOldSide.length()>0)
//	{ 
//		String sOldSides[] = {T("|UCS| Y"),T("|UCS| Z")};
//		int nOldSide = sOldSides.find(sOldSide);
//		
//		
//	// get coordSys
//		Vector3d vecXG = _PtG[1]-_PtG[0]; vecXG.normalize();
//		Vector3d vecX =_XF0;
//		if (vecXG.dotProduct(vecX)<0)
//			vecX*=-1;
//		Vector3d vecY =-_Y0;
//		if (_X0.isCodirectionalTo(_XF0))
//			vecY*=-1;
//		if (nOldSide==0)
//			vecY=-_Z0;
//		Vector3d vecZ =vecX.crossProduct(vecY);		
//		if (nOldSide>-1)
//		{ 
//			Vector3d vecSide = qdr.vecD(vecZ);
//			int nSide = -1;
//			if (vecSide.isCodirectionalTo(vecYB))nSide = 0;
//			else if (vecSide.isCodirectionalTo(vecZB))nSide = 1;
//			else if (vecSide.isCodirectionalTo(-vecYB))nSide = 2;
//			else if (vecSide.isCodirectionalTo(-vecZB))nSide = 3;
//
//			if (nSide>-1)
//			{ 
//			// create TSL
//				TslInst tslNew;		Entity entsTsl[] = {};	Map mapTsl;	
//				Point3d ptsTsl[] = {_Pt0};
//				ptsTsl.append(_PtG);
//				int nProps[]={};	double dProps[]={dLength, dWidth, dDepth, _ThisInst.propString(0).atof()};		String sProps[]={sReferenceSides[nSide]};
//				
//							
//				tslNew.dbCreate(scriptName() , vecXB ,vecYB,_GenBeam, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
//				
//			// conversion succeeded
//				if (tslNew.bIsValid())
//				{ 
//					reportMessage("\n" + scriptName() + T("|upgraded.|"));
//					eraseInstance();
//					return;
//				}	
//			}
//		}
//	}//endregion

	_PtG = ln.orderPoints(_PtG);
	

// get coordSys
	Vector3d vecX = vecXB;
	Vector3d vecZ = vecZB;
	
	if (opening.bIsValid())
	{ 
		vecZ = -el.vecY();
	}
	else
	{ 
		if (nReferenceSide == 0)
			vecZ = vecYB;
		else if (nReferenceSide == 2)
			vecZ =-vecYB;
		else if (nReferenceSide == 3)
			vecZ =-vecZB;		
	}

		
		
	Vector3d vecY = vecX.crossProduct(-vecZ);
	vecX.vis(_Pt0 ,1);
	vecY.vis(_Pt0 ,3);
	vecZ.vis(_Pt0 ,150);	

// get dD of genBeam
	double dZQdr = qdr.dD(vecZ);
	double dYQdr = qdr.dD(vecY);
	double dXQdr = qdr.dD(vecX);


// tool dimensions
	double dX = dLength<=0?dXQdr:dLength;
	double dY = dWidth<=0?dYQdr:dWidth;
	double dZ = dDepth;
	// HSB-21189: dont change grips if trigger comes from moving the grips
	// HSB-18550
	String sGrips[] ={ "_PtG0", "_PtG1"};
	int nGripChanged = sGrips.find(_kNameLastChangedProp);
	if(_PtG.length()==2 && nGripChanged<0)
	{ 
	// if genbeam dimensions are changed, make sure to update the tsl
		if(dWidth<=0)
			if(abs(abs(vecY.dotProduct(_PtG[1]-_PtG[0]))-dY))
			{ 
				_PtG.setLength(0);
				setExecutionLoops(2);
				return;
			}
		if(dLength<=0)
			if(abs(abs(vecX.dotProduct(_PtG[1]-_PtG[0]))-dX))
			{ 
				_PtG.setLength(0);
				setExecutionLoops(2);
				return;
			}
	}
	
	// override for instalations
	if (installation.bIsValid() && dLength<=0)
	{
		// HSB-22941
		if(_Map.hasInt("InstallationPointBottom"))
		{ 
			String sArMill[]={T("|None|"),T("|Bottom|"),T("|Top|"),T("|Both|")};
			int bTopRef,bTopOpp,bBottomRef,bBottomOpp;
			// bottom, 
			int nMillRef=sArMill.find(installation.propString(0));
			// milling on opposite side
			int nMillOpp=sArMill.find(installation.propString(1));
			//
			if(nMillRef==1 || nMillRef==3)
			{ 
				bBottomRef=true;
			}
			if(nMillRef==2 || nMillRef==3)
			{ 
				bTopRef=true;
			}
			if(nMillOpp==1 || nMillOpp==3)
			{ 
				bBottomOpp=true;
			}
			if(nMillOpp==2 || nMillOpp==3)
			{ 
				bTopOpp=true;
			}
			// calculate width
			if(_Map.getInt("InstallationPointBottom"))
			{ 
				// bottom beamcut instance
				double dwref,dwopp;
				if(bBottomRef)
				{ 
					dwref=installation.propDouble(0);
				}
				if(bBottomOpp)
				{ 
					dwopp=installation.propDouble(2);
				}
				dX=dwref>dwopp?dwref:dwopp;
			}
			else if(!_Map.getInt("InstallationPointBottom"))
			{ 
				// top beamcut instance
				double dwref,dwopp;
				if(bTopRef)
				{ 
					dwref=installation.propDouble(0);
				}
				if(bTopOpp)
				{ 
					dwopp=installation.propDouble(2);
				}
				dX=dwref>dwopp?dwref:dwopp;
			}
		}
		else
		{ 
			dX = installation.propDouble(0);
		}
	}
	else if (opening.bIsValid() && dLength<=0)
		dX = opening.width();

// set tool width to extremes of linked genbeams if more than 1
	if (dWidth<=0 && _GenBeam.length()>1)
	{ 
		Point3d pts[0];
		for (int i=0;i<_GenBeam.length();i++) 
		{ 
			GenBeam& gb= _GenBeam[i];
			pts.append(gb.envelopeBody(false, true).extremeVertices(vecY));
			 
		}//next i
		pts = Line(_Pt0, vecY).orderPoints(pts);
		if (pts.length()>0)
		{
			dY =abs(vecY.dotProduct(pts[0] - pts[pts.length() - 1]));
			Point3d ptMid = (pts[0] + pts[pts.length() - 1]) / 2;
			ln.transformBy(vecY * vecY.dotProduct(ptMid - ptCen));
		}
	}


// the reference location
	Point3d ptRef = ln.closestPointTo(_Pt0) + vecZ*.5 * dZQdr + vecY*dAxisOffset;
	ptRef.vis(6);

// on the event of changing the face alignment
	if (_kNameLastChangedProp==sReferenceSideName)
	{ 
		_PtG.setLength(0);
		setExecutionLoops(2);
		return;
	}


// add grips if not found
	if (_PtG.length()<2)
	{
		_PtG.setLength(0);
		_PtG.append(ptRef-.5*(vecX*dX+vecY*dY));
		_PtG.append(ptRef+.5*(vecX*dX+vecY*dY));
	}

// relocate on dbCreation
	if (_bOnDbCreated)
		for (int i=0;i<_PtG.length();i++) 
			_PtG[i].transformBy(vecY*(vecY.dotProduct(ptRef-_PtG[i])+(i==0?-1:1)*.5*dY));
		

// TriggerRotate
	if (_bOnRecalc && _kExecuteKey==sDoubleClick)
	{
		nReferenceSide++;
		if (nReferenceSide == 4)nReferenceSide = 0;
		sReferenceSide.set(sReferenceSides[nReferenceSide]);
		_PtG.setLength(0);
		setExecutionLoops(2);
		return;
	}

// Trigger Add//region
	String sTriggerAdd = T("|Add Beam|");
	addRecalcTrigger(_kContext, "../"+sTriggerAdd);
	if (_bOnRecalc && (_kExecuteKey==sTriggerAdd || _kExecuteKey=="../"+sTriggerAdd))
	{
	// prompt for beams
		Beam beams[0];
		PrEntity ssE(T("|Select beams|"), Beam());
		if (ssE.go())
			beams.append(ssE.beamSet());
		//reportMessage(TN("|adding|") + beams.length());
		
		for (int i=0;i<beams.length();i++) 
		{ 
			_GenBeam.append(beams[i]);	
			_Beam.append(beams[i]);	
//			int n = _GenBeam.find(beams[i]);	
//			if (n<0)
//			{
//				_GenBeam.append(beams[i]);	
//				reportMessage("\nindex " + i + " added to list of " + _GenBeam.length());
//			}
		}//next i
		
		setExecutionLoops(2);
		return;
	}//endregion

// Trigger Remove//region
	String sTriggerRemove = T("|Remove Beam|");
	addRecalcTrigger(_kContext, "../"+sTriggerRemove);
	if (_bOnRecalc && (_kExecuteKey==sTriggerRemove || _kExecuteKey=="../"+sTriggerRemove))
	{
	// prompt for beams
		Beam beams[0];
		PrEntity ssE(T("|Select beam(s)|"), Beam());
		if (ssE.go())
			beams.append(ssE.beamSet());
		
		for (int i=0;i<beams.length();i++) 
		{ 
			int n = _GenBeam.find(beams[i]);
		// remove
			if (n>-1 && _GenBeam.length()>1)
				_GenBeam.removeAt(n);			 
		}//next i
		setExecutionLoops(2);
		return;
	}//endregion

	
// on the event of changing the length
	if (_kNameLastChangedProp == sLengthName)
	{
	// change to full length
		if (dLength<=0)
		{
			_Pt0.transformBy(vecX*vecX.dotProduct(ptCen-_Pt0));
			_PtG.setLength(0);				

//			for(int i=0;i<_PtG.length();i++)
//				_PtG[i].transformBy(vecX*vecX.dotProduct(ptCen-_PtG[i]));			
		}
		else if (_PtG.length()>1)
		{
			_PtG[0] = ptRef-.5*(vecX*dX+vecY*dY);
			_PtG[1] = ptRef+.5*(vecX*dX+vecY*dY);
		}
		setExecutionLoops(2);
		return;
	}
// on the event of changing a grip
//	String sGrips[] ={ "_PtG0", "_PtG1"};
//	int nGripChanged = sGrips.find(_kNameLastChangedProp);
	if (nGripChanged==0 || nGripChanged==1)
	{
		double dNewX = abs(vecX.dotProduct(_PtG[0] - _PtG[1]));
		double dNewY = abs(vecY.dotProduct(_PtG[0] - _PtG[1]));
		double dNewZ = vecZ.dotProduct(ptRef-_PtG[nGripChanged]);
	
	// change depth only if length and width has not changed	
		if (dNewZ>0 && abs(dLength-dNewX)<dEps && abs(dWidth-dNewY)<dEps)
		{
			dDepth.set(dNewZ);		
		}
	
	// change width only if length has not changed	
//		else if (abs(dLength-dNewX)<dEps)
//		{
//			dWidth.set(abs(vecY.dotProduct(_PtG[0]-_PtG[1])));
//			dAxisOffset.set(vecY.dotProduct((_PtG[0]+_PtG[1])/2 - ptCen));
//		}
//	// change length in any other case
//		else if (abs(dLength-dNewX)>dEps)
//		{	
//			dLength.set(dNewX);
//			_PtG[nGripChanged].transformBy(vecY*(vecY.dotProduct(ptRef-_PtG[nGripChanged])+(nGripChanged==0?-1:1)*.5*dY));
//		}
		else
		{ 
			// HSB-21189: allow to change width and length at same time
			_PtG[nGripChanged]=Plane(ptRef,vecZ).closestPointTo(_PtG[nGripChanged]);
			dWidth.set(abs(vecY.dotProduct(_PtG[0]-_PtG[1])));
			dAxisOffset.set(vecY.dotProduct((_PtG[0]+_PtG[1])/2 - ptCen));
			
			dLength.set(dNewX);
//			_PtG[nGripChanged].transformBy(vecY*(vecY.dotProduct(ptRef-_PtG[nGripChanged])+(nGripChanged==0?-1:1)*.5*dY));
		}
		_Pt0.setToAverage(_PtG);
		setExecutionLoops(2);
		return;
	}
// on the event of changing the width
	if (_kNameLastChangedProp==sWidthName)
	{
//		reportMessage("\nevent " + _kNameLastChangedProp);
		if (dWidth<=0)
		{
			dAxisOffset.set(0);
			ptRef = ln.closestPointTo(_Pt0) + vecZ*.5 * dZQdr + vecY*dAxisOffset;
			
		}
		for (int i=0;i<_PtG.length();i++) 
		{ 
			_PtG[i].transformBy(vecY*(vecY.dotProduct(ptRef-_PtG[i])+(i==0?-1:1)*.5*dY));
			 
		}//next i
		
		
		setExecutionLoops(2);
		return;
	}				


// set grips to depth
	if (_PtG.length()>1)
	{ 
		_PtG[0]+=vecZ*(vecZ.dotProduct(ptRef-_PtG[0])); 
		_PtG[1]+=vecZ*(vecZ.dotProduct(ptRef-_PtG[1])-dDepth); 		
	}


	if (_kNameLastChangedProp=="_Pt0")
	{ 
		//reportMessage("\nevent " + _kNameLastChangedProp);
		dAxisOffset.set(vecY.dotProduct(_Pt0 - ptCen));
		setExecutionLoops(2);
	}
	else if (!bGetAutoLength)
	{
		//reportMessage("\nevent not " + bGetAutoLength);
		_Pt0.setToAverage(_PtG);
		ptRef += vecX * vecX.dotProduct(_Pt0-ptRef);
	}
//
// the tool
	Point3d ptBc = ptRef+vecZ*dEps;
	Body bd;
	if (dX>dEps && dY>dEps && dZ>dEps)
	{
		// Check whether any face of beamcut aligns exactly at genbeam face
		// If yes then add extra tolerance
		Point3d ptBcNew=ptBc;
		double dXnew=dX,dYnew=dY,dZnew=dZ+dEps;
		int bModified;
		{ 
			Point3d ptBcs[0];
			ptBcs.append(ptBc+vecX*.5*dX);
			ptBcs.append(ptBc-vecX*.5*dX);
			ptBcs.append(ptBc+vecY*.5*dY);
			ptBcs.append(ptBc-vecY*.5*dY);
			ptBcs.append(ptBc+vecZ*(dZ+dEps));
			ptBcs.append(ptBc-vecZ*(dZ+dEps));
			Vector3d vecsBc[]={vecX,-vecX,vecY,-vecY,vecZ,-vecZ};
			//
			Body bdBc(ptBc, vecX, vecY, vecZ, dX, dY, 2*(dZ+dEps), 0,0,0);
			for (int v=0;v<vecsBc.length();v++) 
			{ 
				Vector3d vv=vecsBc[v];
				Point3d ptv=ptBcs[v];
				for (int g=0;g<_GenBeam.length();g++) 
				{ 
					Body bdG=Body(_GenBeam[g].bodyExtents()); 
					if(!bdBc.hasIntersection(bdG))
					{ 
						continue;
					}
					
					Quader qdG=_GenBeam[g].bodyExtents();
					Vector3d vxg=qdG.vecX();
					Vector3d vyg=qdG.vecY();
					Vector3d vzg=qdG.vecZ();
					double dxg=qdG.dX();
					double dyg=qdG.dY();
					double dzg=qdG.dZ();
					
					Plane pnGs[0];
					pnGs.append(Plane(qdG.ptOrg()+vxg*.5*dxg,vxg));
					pnGs.append(Plane(qdG.ptOrg()-vxg*.5*dxg,vxg));
					pnGs.append(Plane(qdG.ptOrg()+vyg*.5*dyg,vyg));
					pnGs.append(Plane(qdG.ptOrg()-vyg*.5*dyg,vyg));
					pnGs.append(Plane(qdG.ptOrg()+vzg*.5*dzg,vzg));
					pnGs.append(Plane(qdG.ptOrg()-vzg*.5*dzg,vzg));
					
					Vector3d vecsG[]={vxg,-vxg,vyg,-vyg,vzg,-vzg};
					
					for (int j=0;j<vecsG.length();j++) 
					{ 
						Vector3d vj = vecsG[j]; 
						if(!vv.isParallelTo(vj))
						{ 
							continue;
						}
						// 
						Point3d ptPnj=pnGs[j].closestPointTo(ptv);
						if((ptPnj-ptv).length()<dEps)
						{ 
							// faces align
							bModified=true;
							double dExtra=U(1);
							ptBcNew+=vv*.5*dExtra;
							if(v==0 || v==1)
							{ 
								dXnew+=dExtra;
							}
							if(v==2 || v==3)
							{ 
								dYnew+=dExtra;
							}
							else if(v==4 || v==5)
							{ 
								dZnew+=dExtra;
							}
						}
					}//next vj
				}//next g
			}//next v
		}
		ptRef.vis(7);
		// HSB-23612
//		BeamCut bc(ptBc, vecX, vecY, vecZ, dX, dY, 2*(dZ+dEps), 0,0,0);
		BeamCut bc(ptBcNew, vecX, vecY, vecZ, dXnew, dYnew, 2*(dZnew+dEps), 0,0,0);
		
		bd = bc.cuttingBody();//
		bd.vis(2);
		bc.addMeToGenBeamsIntersect(_GenBeam);
	}	


//
//	if (dX<=0)dX = dXQdr;	
//	if (dY<=0)dY = dYQdr;
//
//
//	
//
//
//// display _Pt0 on axis of tool
//	_Pt0.transformBy(vecZ*.5*(dZQdr-dZ)+vecY*dAxisOffset);
//	for(int i=0;i<_PtG.length();i++)
//		_PtG[i].transformBy(vecY*vecY.dotProduct(_Pt0-_PtG[i])+vecZ*vecZ.dotProduct(_Pt0-_PtG[i]));
//

//	ptBc.vis(2);
//	

//	else
//	{
//		reportMessage("\n" + scriptName() + ": " +T("|Invalid dimensions.|") + " " + T("|Toll will be deleted.|"));
//		eraseInstance();
//		return;
//	
//	}
//	

	Point3d ptsRef[] = {_PtG[0], _PtG[1]};
//	_PtG = ptsRef;
	
// display coordinate axises
	double dAxisMin = U(20);
	Point3d ptAxis=ptRef;
	double dXAxis = .5*dX;	if(dX > dAxisMin*2) dXAxis = dAxisMin*2;
	double dYAxis = .5*dY;	if(dY > dAxisMin) dYAxis = dAxisMin ;
	double dZAxis = .5*dZ;	if(dZ > dAxisMin) dZAxis = dAxisMin ;
	
	PLine plReference (ptsRef[0], ptsRef[1]);
	PLine plXPos (ptAxis, ptAxis+vecXB*dXAxis);
	PLine plXNeg (ptAxis, ptAxis-vecXB*dXAxis);
	PLine plYPos (ptAxis, ptAxis+vecYB*dYAxis);
	PLine plYNeg (ptAxis, ptAxis-vecYB*dYAxis);
	PLine plZPos (ptAxis, ptAxis+vecZB*dZAxis);
	PLine plZNeg (ptAxis, ptAxis-vecZB*dZAxis);

	Display dpAxis(nc);
	dpAxis.draw(plReference);
	//dpAxis.draw(bd);

	dpAxis.color(1);		dpAxis.draw(plXPos);
	dpAxis.color(14);		dpAxis.draw(plXNeg);
	dpAxis.color(3);		dpAxis.draw(plYPos);
	dpAxis.color(96);		dpAxis.draw(plYNeg);
	dpAxis.color(150);	dpAxis.draw(plZPos);
	dpAxis.color(154);	dpAxis.draw(plZNeg);	




#End
#BeginThumbnail
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
/!"Q!:.,*2.G`JS10!__9
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="933" />
        <int nm="BreakPoint" vl="1134" />
        <int nm="BreakPoint" vl="1144" />
        <int nm="BreakPoint" vl="1215" />
        <int nm="BreakPoint" vl="1153" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23612: Add extra tolerance if beamcut face exactly aligns with genbeam face" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="3/4/2025 2:34:59 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22941: When attached to installation point and length 0 use the width of the active side (reference/opposite) of the hsbInstallationPoint" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="11/11/2024 9:36:45 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-21189: dont change grips if trigger comes from moving the grips" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="1/25/2024 11:27:42 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18550: Make sure TSL gets updated if genbeam dimensions get changed" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="4/13/2023 4:47:45 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End