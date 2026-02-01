#Version 8
#BeginDescription
V5.26__21/may/2020__Validate quaders and remove instance if not all needed are valid (removes error message at drawing opening). Fixed issue displaying top view when angled connections
V5.25__09/23/2019__Commented debug lines
V5.24__13Sept2019__Fixed insertion on multiple joists/headers
V5.23__13Sept2019__Bugfix for legacy instances
V5.22__11Sept2019__Disabled |Add Hanger on Top| for walls
V5.21__06Sept2019__Added support for walls
V5.20__26Jul2019__Added option for additional hanger on top for floors
V5.19__26Jul2019__Added nails as hardware component and will cut beam only in floors
V5.18__19Jul2019__Will work with trusses
V5.17__22Nov2017__Bugfix for skwewd angers
V5.16__21Nov2017__Merged last changes to allow Nailing overrides
V5.15__21Nov2017__Will display on shop floor
V5.14__19Oct2017__Can be inserted on beams to posts
V5.13__15Sept2017__Can insert on roof cassette
V5.12__07Aug2017__Bugfix. Removed an equal sign when using custom hanger
V5.11__11July2017__Will not remove manual cuts added to the beams
V5.10__06July2017__Always adds a custom hanger in the selection set
V4.9__05July2017__Added tolerance when finding proper hangers for given joist
V4.8__1August2016__Added a hardwareComp for export
V4.7__5July2016__Altered the last edit to take both NA and N/A text into account
V4.6__5July2016__Will give proper options based on size
V4.5__10July2015__Registers to a mapobject for schedule
V4.4__8July 2015__Added security
V4.3__19Nov2014__You may now insert many continuously
V4.2__11Sept2014__Enhanced Display
V4.1__10Sept2014__Will export special data for Pipeline
V4.0__10July2014__Will trigger map hanger list TSL if used in new dwg
V3.9__RL__7July2014__Added map data for a different element layout schedule, Added a display for layout, added loose property

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 5
#MinorVersion 26
#KeyWords 
#BeginContents
	/*
	<>--<>--<>--<>--<>--<>--<>--<>____ Craig Colomb _____<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>
	
	For inserting Simpson hangers one at a time according to Mattamy standards.
	
	V0.0___Craig Colomb__ 25JULY2007
	V0.5___Seems to work, needs field testing__ 30JULY2007
	V0.7__18JUNE08_Revised to reference Excel sheet with .NET for hanger library
	and to be self-cloning.
	V0.8__2JULY2008_Added Backer Block property and function
	V0.85_3JULY2008_Converted .dll location to install directory.
	V0.86_17SEPT2008_Removed debug messages and prepped for user testing
	V0.9__28OCT2008_Final documentation and release with Labels & BOM
	V0.95_Added angled joists, triples & quads. Declare Hardware for Excel Export
	V0.96_Revised export fields 
	V0.97_Revised "Quantity" Hardware export field.
	V0.98_Changed Excel export from Hardware style to TSL
	V1.0 _Added ability to select ganged joists of different types
	V1.01_revised Hanger library import to trigger automatically when no data present.
	V1.8 __ 24FEB2009__Revised dotNet functions to local script HangerList.mcr
	V1.9__24FEB2009__Bugfix on adding web stiffeners to non-TJI joists
	V2.0__24FEB209__Bugfixes dealing with capitolization of EP names
	V2.1__24FEB2009__Bugfix on capitolization and Backer profiles
	V2.2__27FEB2009__Enable and mandate transfer of Min Nailing data
	V2.25_3MARCH2009__Bugfix on property indices
	V2.3__4MARCH2009__Converted to O-type TSL to avoid mirror bug
	V2.35_4MARCH2009__Placed safety to avoid non-fatal error messages about intersection
	V2.40_2APRIL2009__Bugfix in determining direction for angled joists.
	V2.45_11September2009__Added functionality for doubled, angled joists.
	V2.48_11September2009__Revised Web Stiffener positioning.
	V3.5_5February2010__Improved width calculation for sistered joists
	V3.6_5February2010__Revised actions on width tolerance exceeded
	
	
	Problems? Questions? Comments? Kudos??  cc@hsb-cad.com
	© Craig Colomb2007
	
	<>--<>--<>--<>--<>--<>--<>--<>_____  craigcad.us  _____<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>
	
	//######################################################################################
	//############################ Documentation #########################################
	<insert>
	Inserted by user in Model Space, will sort through selection sets of Joists & carrying beams
	Requires .NET .dll in "<hsb install>\Excel\ExcelReader\ExcelData.dll". Also needs to find 
	Excel file "<hsb Company>\Excel\HangerList.xls".
	</insert>
	
	<property name="xx">
	"Execution mode" controls whether hanger models are selected by joist type, or simple geometry.
	"Web Stiffener" & "Backer Block" turn these accessories on and off.
	</ property >
	
	<command name="xx">
	"Update Hanger List" runs the associated .dll and updates the local database from the 
	Excel file "<hsb Company>\Excel\HangerList.xls".
	</command>
	
	<remark>
	Requires .NET .dll in "<hsb install>\Excel\ExcelReader\ExcelData.dll".  
	Requires other accompanying resource files, email for details cc@hsb-cad.com
	Requires Excel file "<hsb Company>\Excel\HangerList.xls".
	Creates a 3d model of the appropriate Simpson hanger picked from databased stored 
	in the Excel file. Publishes data to Label & BOM scripts in PS.
	</remark>
	//########################## End Documentation #########################################
	//######################################################################################
*/


	
	Unit ( 1, "inch" ) ;
	
	//########_Retrieve Map of allowable Hangers by Joist & situation Code_########
	//########_Map has list of allowable joists for each geometry (sngle, dble, skw) and ExtrProf.
	String stDictionary = "Hangers" ;
	String stEntry = "Simpson" ;
	MapObject mo(stDictionary ,stEntry); 
	Map mpHangerLibrary ;
	int iUpdateList = FALSE ;	
	double dWidthTol = U(.015625);
	
		
	//__if mo is not valid, call HangerList to create it.
	if (!mo.bIsValid()) 
	{				
		String stName = "FLR_HangerList.mcr" ;
		GenBeam gb[0] ;
		Entity entList[0] ;		
		Point3d pts[0] ;
		int ints[0] ;
		double ds[0] ;
		String sts[0] ;		
		TslInst tsl ;
		tsl.dbCreate( stName, _XW, _YW, gb, entList, pts, ints, ds, sts ) ;		
	} 
	//Make sure it has been trigger once in this dwg
	else
	{
		Map mp = mo.map() ;
		String stDwg = mp.getMap("stLastDwgRun");
		
		if(stDwg != _kPathDwg)
		{
			String stName = "FLR_HangerList.mcr" ;
			GenBeam gb[0] ;
			Entity entList[0] ;		
			Point3d pts[0] ;
			int ints[0] ;
			double ds[0] ;
			String sts[0] ;		
			TslInst tsl ;
			tsl.dbCreate( stName, _XW, _YW, gb, entList, pts, ints, ds, sts ) ;		
		}
	}
	
	
	
	
	//__if mo is valid, need to get data from it 
	if (mo.bIsValid())
	 {
		 mpHangerLibrary = mo.map() ;
		if ( mpHangerLibrary.length() == 0 ) iUpdateList = TRUE ;
	} 
	
	//__Update Hanger list on user request
	addRecalcTrigger( _kContext, "Update Hanger List" ) ;
	if ( _kExecuteKey == "Update Hanger List" )  iUpdateList = TRUE ;
	if ( iUpdateList)
	{
		String stName = "FLR_HangerList.mcr" ;
		GenBeam gb[0] ;
		Entity entList[0] ;
		Point3d pts[0] ;
		int ints[0] ;
		double ds[0] ;
		String sts[0] ;		
		TslInst tsl ;
		tsl.dbCreate( stName, _XW, _YW, gb, entList, pts, ints, ds, sts ) ;	
		
		mpHangerLibrary = mo.map() ;		
		reportMessage( "\nRetreived Hanger list of length " + mpHangerLibrary.length() ) ;
		if ( mpHangerLibrary.length() == 0) reportNotice ( "Failed to retrieve hanger data, please consult CAD manager" ) ;
	}
	
	//######################################################################################
	//#########################__End retrieve hanger models_###################
	
	
	
	
	//##############_Declare properties and do insertion or get beams from _Map__##################
	//######################################################################################
	int iSP=0,iDP=0,iIP=0;
	String stArRunMode[] = { "Standard", "Manual" } ;
	PropString psRunMode ( 0, stArRunMode, "Execution Mode" ) ;
	psRunMode.set("Standard");
	PropDouble pdNum ( iDP++, -1, "Posnum" ) ; pdNum.setFormat( _kNoUnit ) ;
	PropString psNotes ( 1, "", T("General notes") ) ;
	
	String stYN[] = {"No", "Yes" } ;
	
	PropString psShipLoose( 2, stYN, "Ship Loose",0 ) ;
	PropString psWeb( 3, stYN, "Web Stiffener" ) ;
	String stBacker[] = { "None", "Single", "Double" } ;
	PropString psBacker( 4, stBacker, "Backer Block" ) ;
	PropInt piColor( iIP++, 6, "Hanger Color"  ) ;
	PropInt piLooseColor( iIP++, 2, "Loose Hanger Color"  ) ;
	if ( piColor < -1 || piColor > 256 ) piColor.set(6) ;
	String arNails[] = {
							"",
							"0.148 x 3\"",
							"0.148 x 2 1/2\"",
							"0.148 x 1 1/2\"",
							"0.162 x 3 1/2\"",
							"0.162 x 2 1/2\"",
							"0.131 x 2 1/2\"",
							"0.131 x 1 1/2\"",
							"0.250 x 3 1/2\" SDS",
							"0.250 x 3\" SDS",
							"0.250 x 2 1/2\" SDS",
							"0.250 x 1 1/2\" SDS"};
	PropString psFaceNails( 14, arNails, "Face Nails", 0) ;
	//if (arNails.find(psFaceNails) < 0) psFaceNails.set(arNails.first());
	PropString psTopNails( 15, arNails, "Top Nails", 0) ;
	//if (arNails.find(psTopNails) < 0) psTopNails.set(arNails.first());
	PropString psJoistNails( 16, arNails, "Joist Nails", 0) ;
	//if (arNails.find(psJoistNails) < 0) psJoistNails.set(arNails.first());
	PropInt piFaceNailsQty( iIP++, 0, "Face Nails Qty"  ) ;
	PropInt piTopNailsQty( iIP++, 0, "Top Nails Qty"  ) ;
	PropInt piJoistNailsQty(iIP++, 0, "Joist Nails Qty"  ) ;
	
	
	if ( _bOnInsert ) {
	
		String stTslName = scriptName() ;

		while(true)
		{
			Entity bmJoists[0] ;			
			PrEntity ssEJ("Select Joists, all must be parallel", Beam());
			ssEJ.addAllowedClass(TrussEntity());
			if (ssEJ.go()) 
			{
		   		bmJoists = ssEJ.set();
		    }
			if(bmJoists.length() == 0)break;
			
			Entity bmHeader[0] ;
			PrEntity ssEH("Select Carrying Beams", Beam());
			ssEH.addAllowedClass(TrussEntity());
			if (ssEH.go()) 
			{
		   		bmHeader = ssEH.set();
		    }
			if(bmHeader.length() == 0)break;
		
			TslInst tslSlave  ;
		
			
			Beam bmLst[0];
			double dLst[0] ;
			int iLst[0] ;
			Point3d ptLst[0] ;
			String stLst[0] ;
			
			String stAssigned;
			
			//__Sort and order selected Joist beams
			Element el = bmHeader.first().element();
			if (!el.bIsValid()) 
			{
				eraseInstance();
				return;
			}
			Vector3d vPerp = bmJoists[0].coordSys().vecX().crossProduct(el.vecZ()).normal();	
			Entity bmJoistsFiltered[0];
			String arFiltered[0];
			for (int q=0; q<bmJoists.length(); q++)
			{
				if ( ! bmJoists[q].coordSys().vecX().isPerpendicularTo(vPerp)){ continue;}
				else 
				{
					String stToAdd = String(String().format("%09.4f", (bmJoists[q].coordSys().ptOrg() - (el.ptOrg()-vPerp*U(5000))).dotProduct(vPerp)) + "@" + bmJoists[q].handle());
					arFiltered.append(stToAdd);
				}
			}
			//reportMessage("\n arFiltered: " + arFiltered);
			arFiltered = arFiltered.sorted();
			//reportMessage("\n arSorted: "+arFiltered);			
			for (int q=0; q<arFiltered.length(); q++)
			{
				Entity ent;
				ent.setFromHandle(arFiltered[q].token(1, "@"));
				bmJoistsFiltered.append(ent);
			}
			
			
			Quader qdJoistsFiltered[0];			
			for (int q=0; q<bmJoistsFiltered.length(); q++)
			{				
				Quader qdQ;
				if (bmJoistsFiltered[q].bIsKindOf(Beam())) 
				{
					Beam bmQ = (Beam) bmJoistsFiltered[q];
					qdQ = bmQ.quader();
				}
				else if (bmJoistsFiltered[q].bIsKindOf(TrussEntity()))
				{
					TrussEntity te = (TrussEntity) bmJoistsFiltered[q];
					TrussDefinition td = te.definition();
					Map mp = td.subMapX("Content");
					double sizes[] = { mp.getVector3d("Length").length(), mp.getVector3d("Width").length(), mp.getVector3d("Height").length()};
					CoordSys csT = te.coordSys();
					Quader qdT(csT.ptOrg() + 0.5*sizes[0]*csT.vecX() + 0.5*sizes[2]*csT.vecZ(), csT.vecX(), csT.vecY(), csT.vecZ(), sizes[0], sizes[1], sizes[2], 0, 0, 0);
					qdQ = qdT;
				}
				qdJoistsFiltered.append(qdQ);
			}
			
			int iNumJoists = bmJoistsFiltered.length() ;			
			ElementWall elW = (ElementWall) el;
			//__Extract doubles, triples, quads
			if (elW.bIsValid())
			{				
				for ( int j = 0; j < bmHeader.length(); j++)
					{					
						Entity bmAr[] = { bmJoistsFiltered.first(), bmHeader[j] };						
						if (bmJoistsFiltered.length()>1) { for (int k=1; k<bmJoistsFiltered.length(); k++) { bmAr.append(bmJoistsFiltered[k]);}}
						tslSlave.dbCreate( stTslName, _XW, _YW, bmLst, bmAr, ptLst, iLst, dLst, stLst );
						
					}
			}
			else
			{
				for ( int i = 0; i < iNumJoists; i++)
				{
					
					Entity bmJoist = bmJoistsFiltered[i];
					Quader qdJoist = qdJoistsFiltered[i];
					Entity bmSisters[0];
					int iIsLast = FALSE;
					if ( i == iNumJoists - 1) iIsLast = TRUE;
					
					double dJoistW = qdJoist.dD( vPerp );
					if ( ! iIsLast )
					{
						Entity bmNext = bmJoistsFiltered[i + 1];
						Quader qdNext = qdJoistsFiltered[i + 1];
						Vector3d vCenters = qdNext.coordSys().ptOrg() - qdJoist.coordSys().ptOrg();
						double dDist = vCenters.dotProduct( vPerp );
						double dWcombined = 0.5*(dJoistW + qdNext.dD(vPerp));
						int iSafe = 0;
						while ( dDist < dWcombined + U(.25))
						{
							bmSisters.append( bmNext );
							i ++;
							if ( i == iNumJoists - 1) break;
							Quader qdLast = qdNext;
							qdNext = qdJoistsFiltered[ i + 1 ];
							vCenters = qdNext.coordSys().ptOrg() - qdLast.coordSys().ptOrg();
							dDist = vCenters.dotProduct( vPerp );
							dWcombined = 0.5 * (qdLast.dD(vPerp) + qdNext.dD(vPerp));
							iSafe ++;
							if ( iSafe > 4)
							{
								reportMessage( "\nSafety broke sorting loop" );
								break;
							}
						}
					}
					
					reportMessage("\n bmSisters: " + bmSisters.length());
					for ( int j = 0; j < bmHeader.length(); j++)
					{
						Entity bmAr[] = { bmJoist, bmHeader[j] };
						bmAr.append( bmSisters );
						tslSlave.dbCreate( stTslName, _XW, _YW, bmLst, bmAr, ptLst, iLst, dLst, stLst );
						
					}
				}
			}
		}
		eraseInstance() ;
		return ;
	}	
	//######################################################################################
	//#############################__End Insertion Routine_###################################
	if (_Beam.length()>1)
	{
		_Entity.setLength(0);
		for (int i=0; i<_Beam.length(); i++)
		{
			Entity ent = (Entity) _Beam[i];
			_Entity.append(ent);
		}
		_Beam.setLength(0);
	}
	
	//__Convert T-type predefines _X0, _Z1, _Plf, _Pt0, _Pt1, _Pt2, _Pt3, _Pt4
	Element el = _Entity[0].element();
	reportMessage("\n ents: "+_Entity.length()+" on panel "+el.number());
	ElementWall elW = (ElementWall) el;
	if (elW.bIsValid())
	{
		if (_Entity.length()>2) 
		{
			Map mpAdditional;
			for (int i=2; i<_Entity.length(); i++) { mpAdditional.appendEntity("ent", _Entity[i]);}
			_Map.setMap("mpAdditional", mpAdditional);
		}
		else 
		{
			if (_Map.hasMap("mpAdditional"))
			{
				Map mpAdditional = _Map.getMap("mpAdditional");
				for (int i=0; i<mpAdditional.length(); i++) { _Entity.append(mpAdditional.getEntity(i));}
			}
		}
	}
	
	Quader qdAll[0], qdJoists[0];
	for (int i=0; i<_Entity.length(); i++)
	{
		if (_Entity[i].bIsKindOf(Beam())) 
		{
			Beam bmQ = (Beam) _Entity[i];
			qdAll.append(bmQ.quader());
			if (i != 1) qdJoists.append(bmQ.quader());
		}
		else if (_Entity[i].bIsKindOf(TrussEntity()))
		{
			TrussEntity te = (TrussEntity) _Entity[i];
			TrussDefinition td = te.definition();
			Map mp = td.subMapX("Content");
			double sizes[] = { mp.getVector3d("Length").length(), mp.getVector3d("Width").length(), mp.getVector3d("Height").length()};
			CoordSys csT = te.coordSys();
			Quader qdT(csT.ptOrg() + 0.5*sizes[0]*csT.vecX() + 0.5*sizes[2]*csT.vecZ(), csT.vecX(), csT.vecY(), csT.vecZ(), sizes[0], sizes[1], sizes[2], 0, 0, 0);			
			qdAll.append(qdT);
			if (i != 1) qdJoists.append(qdT);
		}
	}
	if (elW.bIsValid() )
	{	
		PlaneProfile ppJoist = Body(qdJoists.first()).getSlice(Plane(qdJoists.first().ptOrg(), qdJoists.first().vecX()));
				if (qdJoists.length()>1)
				{
					//ppJoist.shrink(-1*U(0.5));
					for (int k=1; k<qdJoists.length(); k++) 
					{
						PlaneProfile ppK = Body(qdJoists[k]).getSlice(Plane(qdJoists.first().ptOrg(), qdJoists.first().vecX()));
						ppJoist.unionWith(ppK);
					}
					//ppJoist.shrink(U(0.5));
				}
		Quader qdDummy(ppJoist.extentInDir(el.vecY()).ptMid(), el.vecX(), el.vecZ(), el.vecY(), qdJoists.first().dD(el.vecX()), 
						abs((ppJoist.extentInDir(el.vecZ()).ptStart()-ppJoist.extentInDir(el.vecZ()).ptEnd()).dotProduct(el.vecZ())),
						abs((ppJoist.extentInDir(el.vecY()).ptStart() - ppJoist.extentInDir(el.vecY()).ptEnd()).dotProduct(el.vecY())), 0, 0, 0);
		qdAll.first() = qdDummy;
		qdAll.setLength(2);		
		_Entity.setLength(2);
	}

	// validate all quaders
	for (int q=qdAll.length()-1; q>=0 ; q--) 
	{ 
		Quader qd=qdAll[q]; 
		if(qd.dD(qd.vecX()) == 0 || qd.dD(qd.vecX()) == 0 || qd.dD(qd.vecX()) == 0 )
		{ 
			qdAll.removeAt(q);
			continue;
		}
		
		qd.vis(2);
	}//next q
	
	if(qdAll.length() < 2)
	{ 
		reportMessage("\n" + scriptName() + "_" + _ThisInst.handle() + " " + T("|has been deleted because one or more beams are missing|\n")); 
		eraseInstance();
		return;
	}
	
	Vector3d vecX0 = qdAll[0].vecX() ;
	if ((qdAll[1].ptOrg() - qdAll[0].ptOrg()).dotProduct(vecX0)) vecX0 = - vecX0;
	Line lnBm0 ( qdAll[0].ptOrg(), vecX0 ) ;
	Line lnBm1 ( qdAll[1].ptOrg(), qdAll[1].vecX() );
	Point3d ptBmInt = lnBm0.closestPointTo( lnBm1 ) ;
	
	Vector3d vecHead = ptBmInt - qdAll[0].ptOrg() ;
	if ( vecHead.dotProduct( vecX0 ) < 0 ) vecX0 = -vecX0 ;
	Vector3d vecZ1 = _ZW.crossProduct( qdAll[1].vecX() )  ;
	if (qdAll[1].vecX().isParallelTo(_ZW )) vecZ1 = qdAll[0].vecX();
	if ( vecHead.dotProduct( vecZ1 ) < 0 ) vecZ1 = -vecZ1 ;
	Quader qdHeader = qdAll[1];	
	Plane _Plf = qdHeader.plFaceD( -vecZ1 ) ;
	ptBmInt.vis(3);
	
	
	String stAddTop = "Add Hanger On Top";
	PropString psAddTop(13, stYN, stAddTop, 0);
	if (elW.bIsValid()) {
		psAddTop.set(stYN[1]);
		psAddTop.setReadOnly(true);
	}
	
	//vecZ1.vis( ptBmInt, 4);
	Vector3d vecX1 = qdAll[1].vecX() ;
	//lnBm0.vis( 4 ) ;
	Line ln1, ln2, ln3, ln4 ;
	Point3d _Pt1, _Pt2, _Pt3, _Pt4 ;
	if( lnBm0.hasIntersection( _Plf) ) 
	{
		_Pt0 = lnBm0.intersect( _Plf, 0 ) ;	
		ptBmInt = _Pt0;
		Vector3d vecY0 = qdAll[0].vecY() ;
		Vector3d vecZ0 = qdAll[0].vecZ() ;
		Quader qdJoist = qdAll[0];		
		ln1 = qdJoist.lnEdgeD( vecY0, vecZ0 ) ;
		ln2 = qdJoist.lnEdgeD( vecY0, -vecZ0 ) ;
		ln3 = qdJoist.lnEdgeD( -vecY0, vecZ0 ) ;
		ln4 = qdJoist.lnEdgeD( -vecY0, -vecZ0 ) ;
		_Pt1 = ln1.intersect( _Plf, 0 ) ;
		_Pt2 = ln2.intersect( _Plf, 0 ) ;
		_Pt3 = ln3.intersect( _Plf, 0 ) ;
		_Pt4 = ln4.intersect( _Plf, 0 ) ;
	}
	
	
	//####################_Find Allowable hangers and declare prop__#############################
	//######################################################################################
	//_____________Sort out Joists from _Beam array
	String stExtProf;
	if (_Entity[0].bIsKindOf(Beam())) 
	{
		Beam bmQ = (Beam) _Entity[0];
		stExtProf = bmQ.extrProfile();		
	}
	else if (_Entity[0].bIsKindOf(TrussEntity()))
	{
		stExtProf = "Rectangular";
	}
	
	String stHeaderProf;
	if (_Entity[1].bIsKindOf(Beam())) 
	{
		Beam bmQ = (Beam) _Entity[1];
		stHeaderProf = bmQ.extrProfile();		
	}
	else if (_Entity[1].bIsKindOf(TrussEntity()))
	{
		stHeaderProf = "Rectangular";
	}
	String stJoistEP = stExtProf ;
	stJoistEP.makeUpper() ;
	int iIsIJoist = FALSE ;
	if ( stExtProf.find( "TJI",0 ) >= 0 || stExtProf.find( "LPI",0 ) >= 0 || stExtProf.find( "BCI",0 ) >= 0) iIsIJoist = TRUE ;
	//stHeaderProf.makeUpper() ;
	
	Entity bmJoists[0] ;
	for (int i=0; i<_Entity.length(); i++)
	{
		if (qdAll[i].vecX().isParallelTo(qdAll[0].vecX())) bmJoists.append(_Entity[i]);
	}

	for ( int i=0; i<bmJoists.length(); i++ ) 
	{		
		String stDB;
		if (bmJoists[i].bIsKindOf(Beam())) 
		{
			Beam bmQ = (Beam) bmJoists[i];
			stDB = bmQ.extrProfile().makeUpper();		
		}
		else if (bmJoists[i].bIsKindOf(TrussEntity()))
		{
			stDB = String("Rectangular").makeUpper();
		}
		if(stDB != stJoistEP ) psRunMode.set( "Manual" ) ;	
	}	


	int iNumJoists = bmJoists.length() ;

	//__Safety for when no beams exist
	if ( iNumJoists == 0 ) {
		reportMessage( "\nSimpson Hanger self-erasing since no joists can be found!");
		eraseInstance();
		return;
	}
	
	//__Safety for some beams deleted
	if( _Entity.length() < 2 )
	{
		reportMessage( "\nSimpson Hanger self-erasing not enough beams");
		eraseInstance();
		return;
	}
		
	String stArModel[0] ;
	String stJointType = "Square" ;
	if ( abs( vecX0.dotProduct( qdAll[1].vecX() ) ) > .02 ) stJointType = "Angled" ;
	
	pdNum.set(_ThisInst.posnum() ) ;
	pdNum.setReadOnly( TRUE ) ;		

	
	//__Need joist dimensions__###################################	
	Vector3d vX = vecX0 ;
	Vector3d vY = qdAll[0].vecY();
	Vector3d vZ = qdAll[0].vecZ();
	
	
	if ( abs( vZ.dotProduct( _ZW ) )< abs( vY.dotProduct( _ZW ) ) ) {
		Vector3d vTemp = vY ;
		vY = vZ ;
		vZ = vTemp ;
	}
	
	
	double dJoistW = qdAll[0].dD( vY ) ;
	double dJoistH = qdAll[0].dD( vZ ) ;
	double dHeaderH = qdAll[1].dD( vZ ) ;
	double dHeaderW = qdAll[1].dD( vecZ1 ) ;
	
	//force it angled
	double dAngleSkewed = qdAll[0].vecX().angleTo(-qdAll[1].vecX());
	if (abs(dAngleSkewed - 90) > 5)
	{
		stJointType = "Angled";
	}
	
	///__Adjust Joist Width for multiple joists when needed
	
	if( iNumJoists > 1 )
	{	
		Point3d ptCenFirst, ptCenLast ;
		double dWidthFirst, dWidthLast ;
				
		for ( int i=0; i<bmJoists.length(); i++)
		{		  
			Quader qd = qdAll[_Entity.find(bmJoists[i])];			
			if ( i==0) 
			{
				ptCenFirst = qd.ptOrg() ;
				dWidthFirst = qd.dD(vY ) ;
			}
			else
			{
				ptCenLast = qd.ptOrg() ;
				dWidthLast = qd.dD( vY ) ;
			}				
		}
		
		Vector3d vWidth = ptCenLast - ptCenFirst ;
		dJoistW = abs(vWidth.dotProduct( vY )) ;
		dJoistW += (dWidthFirst + dWidthLast)/2 ;
		
		double dMaxWidth = iNumJoists * dWidthFirst +  dWidthTol *(iNumJoists-1) ;
		if( dJoistW > dMaxWidth )
		// psRunMode.set( "Manual" ) ;
		{
			reportMessage ("\nWidth tolerance exceeded for Simpson Hanger, width = " + dJoistW) ;			
			reportMessage ("\n !##!!!----Simpson Hanger self-destructing------ !##!!!") ;
			eraseInstance() ;
			return;
		}
	}
	
	//__Go through Hanger Library and pull appropriate joists, set to mpHangers
	Map mpHangers ;
	String stKeys[] = {"stSingleJoist", "stDoubleJoist", "stTripleJoist", "stQuadJoist" } ;
	String stKey = stKeys[ iNumJoists - 1 ] ;	
	if ( stJointType == "Angled" && bmJoists.length() == 1) stKey = "stAngleJoist" ;	
	if ( stJointType == "Angled" && bmJoists.length() == 2) stKey = "stDoubleAngleJoist" ;
	
	if (psRunMode == "Standard" )
//	if( true)
	{	
		for ( int i=19; i<mpHangerLibrary.length(); i++ ) 
		{
			Map mpTemp = mpHangerLibrary.getMap( i) ;
			String stMapName = mpHangerLibrary.keyAt( i ) ;
			String stJoistList = mpTemp.getString( stKey ) ;
			//if ( stJoistList == "" ) continue;
			stJoistList.makeUpper() ;
			//reportMessage( "\nJoist List = " + stJoistList ) ;
	
			//__Look for the current joist profile in the list of joists
			int iFind = stJoistList.find( stJoistEP, 0 ) ;
			
			//__Joist not found, current hanger not appropriate
			if(stJoistList == "" || stJoistList == "NA")
			{
				double dHwdrW = mpTemp.getDouble("dWidth");
				
				if (!elW.bIsValid()) { if(dHwdrW < dJoistW || abs(dHwdrW - dJoistW) > U(.26)) {continue;}}
			}
			else if ( iFind < 0) continue;
			
			//__Joist has been located in current hanger's list
			//__Enable this to enforce automatic Hanger selection
			//if ( psRunMode == "Manual" ) psRunMode.set( "Standard" ) ;
	
			mpHangers.setMap( stMapName, mpTemp ) ;
			//reportMessage( "\nMap Name = " + stMapName ) ;
			//reportMessage( "\nJoist EP = " + stExtProf ) ;
		}
	}

	//__Test for available, valid hanger choices
	if ( mpHangers.length() == 0 || psRunMode == "Manual" ) 
	{
		reportMessage( "\nNo valid hangers listed for Joist Key " + stExtProf ) ;
		reportMessage( "\nSwitching to Manual Mode" ) ;
		psRunMode.set( "Manual" ) ;
		
		//_Go through library and grab all hangers with dimensions matching joist
		for ( int i=0; i<mpHangerLibrary.length(); i++ ) 
		{
			Map mpTemp = mpHangerLibrary.getMap( i) ;
			String stMapName = mpHangerLibrary.keyAt( i ) ;
			double dHangWidth =  mpTemp.getDouble( "dWidth" ) ;
			double dHangHeight = mpTemp.getDouble( "dJoistHeight" ) ;
			String stType = mpTemp.getString( "stType" ) ;
			
			//__only use S type hangers in Angled conditions.
			if ( stJointType == "Angled" && stType != "S" ) continue;
			if ( stJointType != "Angled" && stType == "S" ) continue;
			
			//__If hanger dimensions match joist dimension add to list
			double dHangDiff = dHangWidth - dJoistW ;
			if ( 0 <= (dHangDiff+U(0.01)) && dHangDiff < U(.25)  && dJoistH >= (dHangHeight - U(0.01)) ) 
			{
				if ( iIsIJoist && dJoistH < dHangHeight ) continue ;
				mpHangers.setMap( stMapName, mpTemp ) ;
			}
		}
	}
	
	//__At this point mpHangers should contain valid hanger descriptions.
	//__Write all possible models to String array and declare model property.
	for ( int i=0; i<mpHangers.length(); i++)
	{
		stArModel.append( mpHangers.keyAt( i ) );
	}
	
	//Add custom hanger
	String stUserDefinedHangerKey = T("**" + "|CUSTOM|" + "**");
	String stUserDefinedConcealedHangerKey = T("**" + "|CUSTOM CONCEALED|" + "**");
	Map mpCustomHanger;	
	//__Gather basic data from Map
	mpCustomHanger.setDouble( "dHangerHeight", U(10) ) ;
	mpCustomHanger.setString( "stType", "F" ) ;
	mpCustomHanger.setString( "stWebStiff", "No");
	mpCustomHanger.setInt( "iFaceNailsQty", int(piFaceNailsQty));
	mpCustomHanger.setInt( "iTopNailsQty",int(piTopNailsQty));
	mpCustomHanger.setInt( "iJoistNailsQty",int(piJoistNailsQty));
	mpCustomHanger.setString( "stFaceNails", String(psFaceNails));
	mpCustomHanger.setString( "stTopNails", String(psTopNails));
	mpCustomHanger.setString( "stJoistNails", String(psJoistNails));
	mpHangers.appendMap(stUserDefinedHangerKey, mpCustomHanger);
	stArModel.append(stUserDefinedHangerKey);
	
	//Add custom Concealed
	mpCustomHanger.setString( "stType", "CF" ) ;
	mpHangers.appendMap(stUserDefinedConcealedHangerKey, mpCustomHanger);
	stArModel.append(stUserDefinedConcealedHangerKey);
	
	//__Declare properties (Execution type already done, hanger Model, End Gap )__####################
	String stModelPropName = T("|My Hanger Model|");
	PropString pstModel( 5, stArModel, stModelPropName ) ;
	
	PropString pstCustomModel( 6, "" , "My Custom Hanger Model" ) ;
	PropDouble dEndGap( iDP++, 0, "Joist End Gap" ) ;
	
	
	//__Construct needed  hanger width for singles and doubles
	//__dJoistW is already adjusted for doubles
	double dHangW = dJoistW ;
	
	//__Half dimensions are commonly used in construction
	double dJoistHW = dJoistW / 2 ;
	double dJoistHH = dJoistH / 2 ;
	
	if(pstCustomModel == "")
	{	String stSize = iNumJoists + "-";
		 
		if( abs(dJoistW-U(1.5)) < U(0.01) ) stSize += int(dJoistW + .9 ) +"x" + int(dJoistH + .9);
		else if(stExtProf.makeUpper() != "RECTANGULAR")stSize += stExtProf;
		else if(U(1) == 25.4)stSize += round(dJoistW) + "x" + round(dJoistH);
		else stSize +=  round(dJoistW * 10)/10 +"x" + round(dJoistH * 10)/10;
		
		
		
		pstCustomModel.set("Hanger for " + stSize);
	}
	

	//__Available hangers array should be filled by now
	if ( stArModel.length() == 0 ) 
	{		
		for ( int i=0; i<bmJoists.length() ; i++)
		{
			Cut ct( _Pt0, vecX0 ) ;
			if (bmJoists[i].bIsKindOf(Beam()) && !elW.bIsValid())
			{
				Beam bm = (Beam) bmJoists[i];
				bm.addTool(ct);
			}
		}
		reportError( "\nNo available hangers for this situation. ;\nJoist Width = " + dJoistW + " Joist Height = " + dJoistH) ;
	}		
	else if(stArModel.find(pstModel) == -1)pstModel.set(stUserDefinedHangerKey);
	
	//######################################################################################
	//#########################__End contstruct set of allowable hanger models_###################
	
	
	//###################_Gather or construct info & geometry for this Model__#####################
	//######################################################################################
	//__Get chosen hanger map
	Map mpHanger = mpHangers.getMap( pstModel ) ;	
	//__Gather basic data from Map
	double dHangerH	= mpHanger.getDouble( "dHangerHeight" ) ;
	String stType = mpHanger.getString( "stType" ) ;
	String stWebStiff = mpHanger.getString( "stWebStiff" ) ;
	String stFaceNails = mpHanger.getString( "stFaceNails" ) ;
	String stTopNails = mpHanger.getString( "stTopNails" ) ;
	String stJoistNails = mpHanger.getString( "stJoistNails" ) ;
	
	int iFaceNailsQty = mpHanger.getInt( "iFaceNailsQty" ) ;
	int iTopNailsQty = mpHanger.getInt( "iTopNailsQty" ) ;
	int iJoistNailsQty = mpHanger.getInt( "iJoistNailsQty" ) ;
	
	
	//nail map
	int nFHFastener = mpHanger.getInt("nFHFastener");
	String stFaceFastenerType = mpHanger.getString("stFaceFastenerType");
	int nJoistFastener = mpHanger.getInt("nJoistFastener");
	String stJoistFastenerType = mpHanger.getString("stJoistFastenerType");
	
	if(dHangerH == U(0))dHangerH = .75 * dJoistH;
	if(stJointType == "Angled")stType = "S";

	
	
	//REVISIT
		
	if( pstModel != stUserDefinedHangerKey)
	{ 
		if (_bOnInsert || _bOnDbCreated || _kNameLastChangedProp == stModelPropName)
		{
			psFaceNails.set(stFaceNails) ;
			psJoistNails.set(stJoistNails);
			psTopNails.set(stTopNails);
			piFaceNailsQty.set(iFaceNailsQty);
			piJoistNailsQty.set(iJoistNailsQty);
			piTopNailsQty.set(iTopNailsQty);
		}
	}
	//_________Set WebStiffener from auto Props
	if ( psRunMode == "Standard" && pstModel != stUserDefinedHangerKey) 
	{
		if ( stWebStiff.find( "Y", 0 ) >= 0 ) psWeb.set( "Yes" ) ; else psWeb.set( "No" ) ;
		//if (stExtProf.find( "TJI", 0 ) <0 ) psWeb.set( "No" ) ;
		psWeb.setReadOnly( 1) ;
		
	} 
	else  psWeb.setReadOnly( 0) ;
	//return;
	//##################__Construct Hanger body__############################
	//__Declare descriptive parameters, and Plines
	double dTTabY, dTTabX, dFTabY, dFTabZ, dSideX, dSideZ, dSideZ1, dBotX, dBotY;
	PLine plSide( vY ) ; PLine plFace( vX ) ;
	Body bdTTab, bdFTab, bdSide, bdBot ;
	Body bdTTabM, bdFTabM, bdSideM ;
	Body bdHanger ;
	Point3d ptBot, ptSide, ptTop, ptNext ;
	Point3d ptCenter = _Pt0 ;
	if ( iNumJoists >1 ) 
	{
		Point3d ptCenters[0];
		for( int i=0; i<bmJoists.length(); i++ )
		{
			ptCenters.append( qdAll[_Entity.find(bmJoists[i])].ptOrg()) ;
		}		
		ptCenter.setToAverage( ptCenters ) ;
	}
	Line lnCenter ( ptCenter, vX ) ;
	//_Plf.vis(1);
	//vX.vis(ptCenter, 3);
	//for (int i = 0; i < qdAll.length(); i++) qdAll[i].vis(5);
	ptCenter = lnCenter.intersect( _Plf, 0 ) ;
	//ptCenter.vis(1) ;
	double dThick = U(.08) ;
	dBotY = dJoistW + dThick * 2 ;//_identical parameter for all Simpson hangers
		
	//vX.vis( _Pt0, 3 ) ;
	//vY.vis(_Pt0, 4 ) ;
	//vZ.vis( _Pt0, 4 ) ;
	
	//__Reference points
	ptBot = ptCenter - vZ * dJoistHH  ;
	ptTop = ptCenter + vZ * dJoistHH  ;
	//ptTop.vis( 12 ) ;
	//ptCenter.vis(2);
	Plane pnBot( ptBot, vZ ) ;
	
//#######################__Insert model parameters here//#########################
//dTTabX= dTTabY = dBotX =dFTabY= dFTabZ= U(1);
	//__All Model overrides need to set dBotX, dTTabX,dTTabY, dFTabY, dFTabZ
	//__All Model overrides need to define plFTab, plSide
	String stIUS =  "IUS1.81/11.88--IUS1.81/9.5--IUS2.37/9.5--IUS2.37/11.88--IUS2.56/11.88--IUS3.56/9.5--IUS3.56/11.88"  ;	
	if ( stIUS.find( pstModel, 0 ) >= 0 )
	{
		ptSide = ptTop + vY * dJoistHW ;
		dTTabY = U(.25) ;
		dTTabX = U(1) ;		
		dHangerH = dJoistH ;
		dBotX = U(2) ;
		Point3d ptBot = ptSide - vZ * dHangerH ;
		
		ptNext = ptBot + vZ * U(1.5) ; plFace.addVertex( ptNext ) ;	
		ptNext = ptNext + vY * U(1) + vZ * U(1.5) ; plFace.addVertex( ptNext ) ;
		ptNext = ptNext + vZ * U(1.5) ; plFace.addVertex( ptNext ) ;
		ptNext = ptNext + vZ * U(.5) + vY * U(.5) ; plFace.addVertex( ptNext ) ;
		ptNext = ptBot + vZ * dHangerH + vY * U( 1.5) ; plFace.addVertex( ptNext ) ;
		ptNext = ptBot + vZ * dHangerH ; plFace.addVertex( ptNext ) ;
		ptNext = ptBot + vZ * U(1.5) ; plFace.addVertex( ptNext ) ;
		//plFace.vis( 2 ) ;
		
		plSide.addVertex( ptBot) ;
		ptNext = ptBot - vX * dBotX ; plSide.addVertex( ptNext ) ;
		ptNext = ptNext + vZ * U( 1.375) ; plSide.addVertex( ptNext ) ;
		ptNext = ptNext + vX * U(1) + vZ * U(1.5) ; plSide.addVertex( ptNext ) ;
		ptNext = ptNext + vZ * U(1.5) ;plSide.addVertex( ptNext ) ;
		ptNext = ptNext + vX * U(.25) + vZ * U(.25) ; plSide.addVertex( ptNext ) ;
		ptNext = ptBot + vZ * dHangerH - vX * U(.75) ; plSide.addVertex( ptNext ) ;
		ptNext = ptBot + vZ * dHangerH ; plSide.addVertex( ptNext ) ;
		plSide.addVertex( ptBot ) ;
		//plSide.vis( 3 ) ;
	}
	
	String stHUCQ = "HUCQ1.81/11-SDS--HUCQ1.81/9-SDS--HUCQ410-SDS--HUCQ412-SDS--HUC310-2--HUC310--HUC210-2--HUC28-2--HUC312--HUC412" ;
	if ( stHUCQ.find( pstModel, 0 ) >= 0 ) 
	{
		ptSide = ptTop + vY * dJoistHW ;
		dBotX = U( 1.5 );	
		dSideX = U( .75 );	

		dFTabY  = U(1);
		dFTabZ = dHangerH ;
		dSideZ = dHangerH * .8;
		dSideZ1 = dHangerH * .7 ; 
		
		ptSide = ptSide - vZ *( dJoistH - dHangerH) ;
		//ptSide.vis(2) ;
		
		plFace.addVertex( ptSide) ;
		plFace.addVertex( ptSide - vY *dFTabY  + vZ * 0 ) ;
		plFace.addVertex( ptSide - vY *dFTabY  - vZ * (dFTabZ - dFTabY) ) ;
		plFace.addVertex( ptSide - vY *0  - vZ * dFTabZ  ) ;
		plFace.addVertex( ptSide) ;	
		
		plSide.addVertex( ptSide ) ;
		plSide.addVertex( ptSide - vX * 0 - vZ * dHangerH  ) ;
		plSide.addVertex( ptSide - vX * dBotX - vZ * dHangerH  ) ;
		plSide.addVertex( ptSide - vX * dBotX - vZ * dSideZ  ) ;
		plSide.addVertex( ptSide - vX * dSideX - vZ * dSideZ1  ) ;
		plSide.addVertex( ptSide - vX * dSideX - vZ * 0  ) ;
		plSide.addVertex( ptSide ) ;	
		
		if ( dEndGap == 0 ) dEndGap.set( U(.1875 ) ) ;	
	}

	
//############################--End Model Overrides Section--##########################

	
	//__Declare default parameters if not yet set
	if ( stType == "TT" && dBotX == 0 ) 
	{
		ptSide = ptTop + vY * dJoistHW ;
		dBotX = U( 1.5 );	
		dSideX = U( .75 );	
		dTTabX = U(1) ;
		dTTabY = U(1) ;
		dFTabY  = U(1);
		dFTabZ = dJoistH * .8 ;
		dSideZ = dJoistH * .8;
		dSideZ1 = dJoistH * .7 ; 
		
		plFace.addVertex( ptSide) ;
		plFace.addVertex( ptSide + vY *dFTabY  + vZ * 0 ) ;
		plFace.addVertex( ptSide + vY *dFTabY  - vZ * (dFTabZ - dFTabY) ) ;
		plFace.addVertex( ptSide + vY *0  - vZ * dFTabZ  ) ;
		plFace.addVertex( ptSide) ;	
		
		plSide.addVertex( ptSide ) ;
		plSide.addVertex( ptSide - vX * 0 - vZ * dJoistH  ) ;
		plSide.addVertex( ptSide - vX * dBotX - vZ * dJoistH  ) ;
		plSide.addVertex( ptSide - vX * dBotX - vZ * dSideZ  ) ;
		plSide.addVertex( ptSide - vX * dSideX - vZ * dSideZ1  ) ;
		plSide.addVertex( ptSide - vX * dSideX - vZ * 0  ) ;
		plSide.addVertex( ptSide ) ;		
	}
	
	if ( stType == "TF"&& dBotX == 0 ) 
	{
		//ptSide = ptTop  ;ptSide.vis( 3 ) ;
		dBotX = U( 1.5 );	
		dSideX = U( 1.5 );	
		dTTabX = U(1.25) ;
		dTTabY = dJoistW  ;
		dFTabY  = dJoistW;
		dFTabZ = U(1.25) ;
				
		plFace.addVertex( ptSide) ;
		plFace.addVertex( ptSide + vY *dFTabY  + vZ * 0 ) ;
		plFace.addVertex( ptSide + vY *dFTabY  - vZ * dFTabZ ) ;
		plFace.addVertex( ptSide + vY *0  - vZ * dFTabZ  ) ;
		plFace.addVertex( ptSide) ;	
		
		plSide.addVertex( ptSide ) ;
		plSide.addVertex( ptSide - vX * 0 - vZ * dJoistH  ) ;
		plSide.addVertex( ptSide - vX * dBotX - vZ * dJoistH  ) ;
		plSide.addVertex( ptSide - vX * dSideX - vZ * 0  ) ;
		plSide.addVertex( ptSide ) ;	
		plSide.transformBy( vY * dJoistHW ) ;
		//plSide.vis( 2 ) ;
	}
	//concealed flange
	if ( stType == "CF" && dBotX == 0) 
	{		
		ptSide = ptTop + vY * dJoistHW ;
		dBotX = U( 1.5 );	
		dSideX = U( .75 );	

		dFTabY  = U(1);
		dFTabZ = dHangerH ;
		dSideZ = dHangerH * .8;
		dSideZ1 = dHangerH * .7 ; 
		
		ptSide = ptSide - vZ *( dJoistH - dHangerH) ;
		//ptSide.vis(2) ;
		
		plFace.addVertex( ptSide) ;
		plFace.addVertex( ptSide - vY *dFTabY  + vZ * 0 ) ;
		plFace.addVertex( ptSide - vY *dFTabY  - vZ * (dFTabZ - dFTabY) ) ;
		plFace.addVertex( ptSide - vY *0  - vZ * dFTabZ  ) ;
		plFace.addVertex( ptSide) ;	
		
		plSide.addVertex( ptSide ) ;
		plSide.addVertex( ptSide - vX * 0 - vZ * dHangerH  ) ;
		plSide.addVertex( ptSide - vX * dBotX - vZ * dHangerH  ) ;
		plSide.addVertex( ptSide - vX * dBotX - vZ * dSideZ  ) ;
		plSide.addVertex( ptSide - vX * dSideX - vZ * dSideZ1  ) ;
		plSide.addVertex( ptSide - vX * dSideX - vZ * 0  ) ;
		plSide.addVertex( ptSide ) ;		
	}
	
	if ( stType == "F" && dBotX == 0) 
	{		
		ptSide = ptTop + vY * dJoistHW ;
		dBotX = U( 1.5 );	
		dSideX = U( .75 );	

		dFTabY  = U(1);
		dFTabZ = dHangerH ;
		dSideZ = dHangerH * .8;
		dSideZ1 = dHangerH * .7 ; 
		
		ptSide = ptSide - vZ *( dJoistH - dHangerH) ;
		//ptSide.vis(2) ;
		
		plFace.addVertex( ptSide) ;
		plFace.addVertex( ptSide + vY *dFTabY  + vZ * 0 ) ;
		plFace.addVertex( ptSide + vY *dFTabY  - vZ * (dFTabZ - dFTabY) ) ;
		plFace.addVertex( ptSide + vY *0  - vZ * dFTabZ  ) ;
		plFace.addVertex( ptSide) ;	
		
		plSide.addVertex( ptSide ) ;
		plSide.addVertex( ptSide - vX * 0 - vZ * dHangerH  ) ;
		plSide.addVertex( ptSide - vX * dBotX - vZ * dHangerH  ) ;
		plSide.addVertex( ptSide - vX * dBotX - vZ * dSideZ  ) ;
		plSide.addVertex( ptSide - vX * dSideX - vZ * dSideZ1  ) ;
		plSide.addVertex( ptSide - vX * dSideX - vZ * 0  ) ;
		plSide.addVertex( ptSide ) ;		
	}
	
	//########################## Add Skewed Hanger display ##########################
	//#######################//#######################//#######################//#####
	CoordSys csMirrorLR ;
	csMirrorLR.setToMirroring( Plane(ptCenter, vY ) ) ; 
	CoordSys csMirrorUD ;
	csMirrorUD.setToMirroring( Plane( ptCenter, vZ ) ) ;
	Point3d ptShort ;
		
	if( stType == "S" && dBotX == 0)
	{
		Quader qdJoist ;
		Point3d ptCorners[4] ;
		Point3d ptQCen = elW.bIsValid() ? qdAll.first().ptOrg() : qdAll[_Entity.find(bmJoists[0])].ptOrg() ;
		if ( bmJoists.length() == 1 ) 
		{
			qdJoist = elW.bIsValid() ? qdAll.first() : qdAll[_Entity.find(bmJoists[0])] ;
			ptCorners[0] = elW.bIsValid() ? qdJoist.pointAt(sign((qdAll[1].ptOrg()-qdJoist.ptOrg()).dotProduct(qdJoist.vecX())), 1, 1) : _Pt1;
			ptCorners[1] = elW.bIsValid() ? qdJoist.pointAt(sign((qdAll[1].ptOrg()-qdJoist.ptOrg()).dotProduct(qdJoist.vecX())), 1, -1) : _Pt2;
			ptCorners[2] = elW.bIsValid() ? qdJoist.pointAt(sign((qdAll[1].ptOrg()-qdJoist.ptOrg()).dotProduct(qdJoist.vecX())), -1, -1) : _Pt3;
			ptCorners[3] = elW.bIsValid() ? qdJoist.pointAt(sign((qdAll[1].ptOrg()-qdJoist.ptOrg()).dotProduct(qdJoist.vecX())), -1, 1) : _Pt4;		
		}
			
		if ( bmJoists.length() == 2 ) //__in case of doubled angled joists, build quader with dimension of both beams.
		{
			double dQW = qdAll[_Entity.find(bmJoists[0])].dD( vY ) + qdAll[_Entity.find(bmJoists[1])].dD(vY)  ;
			double dQH =  qdAll[_Entity.find(bmJoists[0])].dD( vZ ) ;
			Point3d ptBeamCenters[] = { qdAll[_Entity.find(bmJoists[0])].ptOrg(), qdAll[_Entity.find(bmJoists[0])].ptOrg() } ;			
			ptQCen.setToAverage( ptBeamCenters ) ;
			qdJoist = Quader( ptQCen, vX, vY, vZ, U(24), dQW, dQH)  ;
			ln1 = qdJoist.lnEdgeD( vY, vZ ) ;
			ln2 = qdJoist.lnEdgeD( vY, -vZ ) ;
			ln3 = qdJoist.lnEdgeD( -vY, vZ ) ;
			ln4 = qdJoist.lnEdgeD( -vY, -vZ ) ;
			ptCorners[0] = ln1.intersect( _Plf, 0 ) ;
			ptCorners[1] = ln2.intersect( _Plf, 0 ) ;
			ptCorners[2] = ln3.intersect( _Plf, 0 ) ;
			ptCorners[3] = ln4.intersect( _Plf, 0 ) ;			
		}			
			 
		Point3d ptJoistCen = ptQCen  ;
		double dDistCorners[4] ;		
		dDistCorners[0] = (ptCorners[0] - ptJoistCen).length() ;		
		dDistCorners[1] = (ptCorners[1] - ptJoistCen).length() ;		
		dDistCorners[2] = (ptCorners[2] - ptJoistCen).length() ;		
		dDistCorners[3] = (ptCorners[3] - ptJoistCen).length() ;
		
		ptShort = ptCorners[0] ;
		double dDistShort = dDistCorners[0] ;
		for ( int i=1; i<4; i++)
		{
			if( dDistShort > dDistCorners[i] ) 
			{
				ptShort = ptCorners[i] ;
				dDistShort = dDistCorners[i] ;
			}
		}
		//ptShort.vis(12) ;
		
		//___Construct cut point for joist with tolerance & hanger space
		Point3d ptCut = ptShort - vX * ( dThick + dEndGap ) ;		
		Cut ctJoist ( ptCut, vX ) ;
		for( int i=0; i<bmJoists.length(); i++)
		{
			if (bmJoists[i].bIsKindOf(Beam()) && !elW.bIsValid())
			{
				Beam bm = (Beam) bmJoists[i];
				bm.addTool( ctJoist );
			}
		}
		
		//__Get a reference point on the cut face
		Line lnCenter ( ptJoistCen, vX ) ;
		Point3d ptSCenter = lnCenter.closestPointTo( ptShort ) ;
		Point3d ptSBot = ptSCenter - vZ * dJoistH/2  ;
				
		Body bd ( ptSCenter, vX, vY, vZ, dThick, dBotY, dJoistH, -1, 0, 0 ) ;
		bdHanger += bd ;
		//bdHanger.vis(3) ;
		bd = Body( ptSBot, vX, vY, vZ, U(3), dBotY, dThick, -1, 0, -1 ) ;		
		bdHanger += bd ;
		
		//__Construct Bottom tabs 
		ptNext =  ptSBot + vY * dJoistW / 2 ;
		PLine plTab( ptNext, ptNext - vX * U(3), ptNext - vX * U(3) + vZ * U(1.5),
		ptNext - vX * U(2) + vZ * U(1.5) ) ;
		plTab.addVertex( ptNext ) ;
		bd = Body( plTab, vY * dThick ) ;
		bdHanger += bd ;
		bd.transformBy( csMirrorLR ) ;
		bdHanger += bd ;
		
		//__Construct Top Tabs
		ptNext = ptSBot + vZ * dJoistH + vY * dJoistW / 2 ;
		plTab = PLine( ptNext, ptNext - vX * U(3), ptNext - vX * U(3) - vZ * U(1),
		ptNext  - vZ * U(2) ) ;
		plTab.addVertex( ptNext ) ;
		bd = Body( plTab, vY * dThick ) ;
		bdHanger += bd ;
		bd.transformBy( csMirrorLR ) ;
		bdHanger += bd ;
		
		//__Construct inner face tab		
		Vector3d vInY = qdAll[1].vecX() ;
		if ( vX.dotProduct( vInY ) > 0 ) vInY = -vInY ;
		Vector3d vSY = vY ;
		if ( vY.dotProduct( vInY) < 0 ) vSY = -vSY ;		
		ptNext = pnBot.closestPointTo( ptSBot + vSY * dJoistW / 2  )  ;
		//vSY.vis( ptNext, 2 ) ;
		plTab = PLine( ptNext, ptNext + vInY * U(2.5) + vZ * U(2.5), 
		ptNext + vInY * U(2.5) + vZ * ( dJoistH - U(1)), ptNext + vZ * ( dJoistH - U(2)));		
		plTab.addVertex( ptNext ) ;		
		plTab.projectPointsToPlane( _Plf, vecZ1 ) ;
		//plTab.vis(3);
		bd = Body( plTab, -vecZ1 * dThick ) ;
		bdHanger += bd ;
		//bdHanger.vis(3) ;
		//__Construct outer face tab
//		ptNext = ptNext - vSY * dJoistW   ;
//		Line lnProject ( ptNext, vX ) ;
//		Point3d ptFaceBot = lnProject.intersect( _Plf, 0 ) ;
//		plTab = PLine( ptNext, ptFaceBot + _ZW * U(2.5), ptFaceBot + _ZW * ( dJoistH - U(1)),
//		ptNext + _ZW * (dJoistH - U(2) ) ) ;		
//		plTab.addVertex( ptNext ) ;
//		plTab.vis(3);
//		bd = Body( plTab, -vSY * dThick ) ;
		CoordSys csM;
		csM.setToMirroring(Line(LineSeg(_Pt1, _Pt3).ptMid(), vZ));
		bd.transformBy(csM);
		bdHanger += bd ;
	}
	else
	{
		//////__________________Create non-Skewed Bodies
		if ( dTTabX != 0 ) 
		{
			bdTTab = Body( ptSide - vX*dThick, vX, vY, vZ, dTTabX, dTTabY, dThick, 1, 1, 1 ) ;
			bdTTabM.copyPart( bdTTab ) ;
		}	
		
		bdFTab = Body( plFace, -vX * dThick, 1 ) ;
		bdFTabM.copyPart( bdFTab ) ;
		bdSide = Body( plSide, vY * dThick, 1 ) ;
		bdSideM.copyPart( bdSide ) ;
		bdBot = Body( ptBot, vX, vY, vZ, dBotX, dBotY, dThick, -1, 0, -1 ) ;
		
		//____________________Mirror Bodies
		
		if ( dTTabX != 0) bdTTabM.transformBy( csMirrorLR ) ;
		
		bdFTabM.transformBy( csMirrorLR ) ;
		bdSideM.transformBy( csMirrorLR ) ;
		
		//____________________Combine Bodies
		bdHanger = bdSide + bdSideM + bdBot + bdFTab + bdFTabM ;
		if ( dTTabX != 0 ) bdHanger += bdTTab + bdTTabM ;
		
		ptShort = ptSide;
	}
	//____________________Ddefine Color
	int iColor = piColor;
	if(psShipLoose == stYN[1])iColor = piLooseColor;
	
	//____________________Display Hanger
	Display dp (iColor) ; 
	dp.addHideDirection( _ZW); 
	Display dpPlan(iColor);
	dpPlan.addViewDirection(_ZW);
	
	String stDisplayTop = "Engineering Components Top", stDisplayModel = "Engineering Components Model";
	String arListDisplays[]=_ThisInst.dispRepNames();
	//if(arListDisplays.find(stDisplayTop) > -1)dpPlan.showInDispRep(stDisplayTop);
	//if(arListDisplays.find(stDisplayModel) > -1)dp.showInDispRep(stDisplayModel);
	
	if ( psRunMode == "Manual" ) dp.color( 12 ) ;	
	dp.draw( bdHanger ) ;
	int bTopNail, bFaceNail, bJoistNail;
	if (piTopNailsQty > 0 && psTopNails != arNails[0]) bTopNail = true;
	if (piFaceNailsQty > 0 && psFaceNails != arNails[0]) bFaceNail = true;
	if (piJoistNailsQty > 0 && psJoistNails != arNails[0]) bJoistNail = true;
	
	if (psAddTop == stYN[1] && !elW.bIsValid())
	{
		Body bdTop = bdHanger;
		CoordSys csMirrorT;
		csMirrorT.setToMirroring(Plane(ptBmInt, vecX0.crossProduct(vecX1)));
		bdTop.transformBy(csMirrorT);
		dp.draw(bdTop);
	}
		
	Display dpDxa(1);
	dpDxa.showInDxa(true);
	dpDxa.textHeight(U(4));
	dpDxa.showInDispRep("Bogus");
	
	if(el.bIsValid())
	{ 
		exportWithElementDxa(el);
		exportToDxi(true);
	}
	
	
		
	if( stJointType == "Angled")
	{
		PLine plLeft;
		double dLeg = U(3);
		double dOff = U(1);
		Vector3d vecHeader = vecX1 ;
		if( vecHeader.dotProduct( vX ) < 0 ) vecHeader = - vecHeader ;
		Vector3d vecSide = vY;
		if(vecSide.dotProduct(qdAll[0].ptOrg()-ptShort)<0)
			vecSide *= -1;
			
		Line lnHeader ( ptShort, vecHeader ) ;
		//lnHeader.vis(4) ;
		Line lnJoistLeft ( ptShort + vecSide * dJoistW, vX ) ;
		//lnJoistLeft.vis(2);
		Point3d ptLong = lnHeader.closestPointTo( lnJoistLeft );
		
		ptLong += -vX + vecHeader ;
		ptShort +=	 -vX - vecHeader ;
		//ptLong.vis(4) ;
		
		PLine plLong ( ptLong + vecHeader*dLeg, ptLong, ptLong - vX * dLeg);
		PLine plShort ( ptShort - vecHeader * dLeg, ptShort, ptShort  -vX*dLeg);
		dpPlan.draw( plLong ) ;
		dpPlan.draw( plShort ) ;
		
		//plLong.vis(2);
		
		//__Layout Display
		Display dpPlanLay(iColor);
		dpPlanLay.addViewDirection(_ZW);
		dpPlanLay.showInDispRep("LayoutDisplay");
		dpPlanLay.draw( plLong ) ;
		dpPlanLay.draw( plShort ) ;
	}
	else
	{		
		
		PLine plLeft;
		double dLeg = U(3);
		double dOff = U(1);
		plLeft.addVertex( ptCenter + vY * (dJoistW/2 + dOff + dLeg) - vX * dOff) ;
		plLeft.addVertex( ptCenter + vY * (dJoistW/2  + dOff) - vX * dOff ) ;
		plLeft.addVertex( ptCenter + vY * ( dJoistW/2 + dOff ) - vX *( dLeg + dOff) ) ;
		PLine plRight = plLeft;
		plRight.transformBy( csMirrorLR ) ;
		dpPlan.draw( plRight) ;
		dpPlan.draw( plLeft ) ;
		
		//__Layout Display
		Display dpPlanLay(iColor);
		dpPlanLay.addViewDirection(_ZW);
		dpPlanLay.showInDispRep("LayoutDisplay");
		dpPlanLay.draw( plRight) ;
		dpPlanLay.draw( plLeft ) ;
		
		if(el.bIsKindOf(ElementWall()))
		{ 
			dpDxa.draw(plSide);	
		}
		else
		{ 
			dpDxa.draw(plLeft);
			dpDxa.draw(plRight);
		}
	}
	


	
//##########################__End Construct Hanger body__##########################
//################################################################################
	
//###############################################################################
//############____Create Lists of Extrusion Profiles for WS & Backers__################

	
	String stJoistList[]  = { 
		"TJI 110 9.5 joist",						//_1  
		"TJI 110 11.875 joist",					//_2
		"TJI 230 9.5 joist",						//_3
		"TJI 230 11.875 joist",					//_4
		"TJI 360 9.5 joist",						//_5
		"TJI 360 11.875 joist",					//_6
		"TJI 560 11.875 joist",					//_7
		"LPI 20 Plus 9.5 joist",				//_8
		"LPI 32 Plus 9.5 joist",				//_9
		"LPI 20 Plus 11.875 joist",			//_10
		"NI-20 9.5 joist",						//_11
		"NI-40x 9.5 joist",						//_12
		"NI-20 11.875 joist",					//_13
		"NI-40x 11.875 joist",					//_14
		"NI-80 11.875 joist"					//_15
	} ;	
	
	//__Extrusion profiles need to be in CAPs
	for ( int i=0; i<stJoistList.length(); i++)
	{
		stJoistList[i] = stJoistList[i].makeUpper() ;
	}
		
		
	String stWSList[] = {
		"0.625 x 4.0 Web Stiffener",		//_1
		"0.625 x 4.0 Web Stiffener",		//_2
		"0.875 x 4.0 Web Stiffener",		//_3
		"0.875 x 4.0 Web Stiffener",		//_4
		"0.875 x 4.0 Web Stiffener",		//_5
		"0.875 x 4.0 Web Stiffener",		//_6
		"1.5 x 4.0 Web Stiffener",			//_7
		"1.0 x 4.0 Web Stiffener",			//_8
		"1.0 x 4.0 Web Stiffener",			//_9
		"1.0 x 4.0 Web Stiffener",			//_10
		"1.0 x 4.0 Web Stiffener",			//_11
		"1.0 x 4.0 Web Stiffener",			//_12
		"1.0 x 4.0 Web Stiffener",			//_13
		"1.0 x 4.0 Web Stiffener",			//_14
		"1.5 x 4.0 Web Stiffener"			//_15
	};
	
	double dWSW[] = {
		U(.625),		//_1
		U(.625), 		//_2
		U(.875), 		//_3
		U(.875), 		//_4
		U(.875), 		//_5
		U(.875), 		//_6
		U(1.5),	 		//_7
		U(1.0),	 		//_8
		U(1.0),	 		//_9
		U(1.0),	 		//_10
		U(1.0),	 		//_11
		U(1.0),	 		//_12
		U(1.0),	 		//_13
		U(1.0),	 		//_14
		U(1.5)	 		//_15
	} ;
	
	double dWSH[] = {
		U(4.0),		//_1
		U(4.0),		//_2
		U(4.0),		//_3
		U(4.0),		//_4
		U(4.0),		//_5
		U(4.0),		//_6
		U(4.0),		//_7
		U(4.0),		//_8
		U(4.0),		//_9
		U(4.0),		//_10
		U(4.0),		//_11
		U(4.0),		//_12
		U(4.0),		//_13
		U(4.0),		//_14
		U(4.0)		//_15
	} ;
	
	String stBackerList[] = {
		"0.625 x 6.625 Backer Block",		//_1
		"0.625 x 9 Backer Block",			      //_2
		"0.625 x 6.625 Backer Block",		//_3
		"0.625 x 9 Backer Block",			      //_4
		"1.0 x 6.625 Backer Block",		      //_5
		"1.0 x 9 Backer Block",				//_6
		"2 x 6",								//_7
		"1.0 x 6.375 Backer Block",			//_8
		"1.0 x 6.375 Backer Block",			//_9
		"1.0 x 8.75 Backer Block",			//_10
		"1.0 x 6.375 Backer Block",			//_11
		"1.0 x 6.375 Backer Block",			//_12
		"1.0 x 8.75 Backer Block",			//_13
		"1.0 x 8.75 Backer Block",			//_14
		"1.5 x 8.75 Backer Block"				//_15
	} ;	
	
	double dBackerW[] = {
		U(.625), 		//_1
		U(.625), 		//_2
		U(.625), 		//_3
		U(.625), 		//_4
		U(1.0),			//_5
		U(1.0), 			//_6
		U(1.5), 		      //_7
		U(1.0),	 		//_8
		U(1.0),	 		//_9
		U(1.0),	 		//_10
		U(1.0),	 		//_11
		U(1.0),	 		//_12
		U(1.0),	 		//_13
		U(1.0),	 		//_14
		U(1.5)	 		//_15
	} ;
	
	double dBackerH[] = {
		U(6.625), 		//_1
		U(9), 			//_2
		U(6.625), 		//_3
		U(9), 			//_4
		U(6.625), 		//_5
		U(9), 			//_6
		U(5.5),	 		//_7
		U(6.375),		//_8
		U(6.375), 		//_9
		U(8.75), 		//_10
		U(6.375),		//_11
		U(6.375), 		//_12
		U(8.75), 		//_13
		U(8.75), 		//_14
		U(8.75) 		//_15
	} ;	
	
	int iJoistIndex = stJoistList.find( stJoistEP) ;
	String stHeaderProfCAPS = stHeaderProf.makeUpper() ;
	int iHeaderIndex = stJoistList.find( stHeaderProfCAPS ) ;
	
	String stExtrBacker, stExtrStiff ;
	if ( iJoistIndex >= 0 ) stExtrStiff = stWSList[ iJoistIndex] ;
	if ( iHeaderIndex >= 0 ) stExtrBacker = stBackerList[ iHeaderIndex ] ;
	
	double dWSThick, dWSHeight ; 
	if ( iJoistIndex >= 0 ) dWSThick = dWSW[ iJoistIndex] ;
	if ( iJoistIndex >= 0 ) dWSHeight = dWSH[ iJoistIndex ] ;
	
	
	double dBackerThick, dBackerHeight ;
	if ( iHeaderIndex >= 0 ) dBackerThick = dBackerW[ iHeaderIndex ] ;
	if ( iHeaderIndex >= 0 ) dBackerHeight = dBackerH[ iHeaderIndex ] ;

//############____End Lists of Extrusion Profiles for WS & Backers__##############	
//###############################################################################


//##########################################################################
//################____Create Web Stiffener if requested__#########################
	if ( stType == "S" )
	{
		ptTop = ptShort.projectPoint( Plane(ptCenter, vY ), 0 ) - vX * (dEndGap +  dThick) ;		
	}
	
	//ptTop.vis(12) ;
	if ( psWeb == "Yes" && stExtrStiff != "" ) 
	{				
		//________Set Filler length by Joist height
		double dWSLength = U(6.625);
		if ( dJoistH > 10 ) dWSLength = U(9) ;
		
		//_________Calculate reference point
		Point3d ptFillerL = ptTop - vZ * U(1.5 ) + vY * dJoistHW;
		Point3d ptFillerR = ptFillerL - vY * dJoistW ;
		Point3d ptFillCenL = ptFillerL - vX * dWSHeight/2 - vY * dWSThick/2 - vZ * dWSLength;
		Point3d ptFillCenR = ptFillCenL ;
		ptFillCenR.transformBy( csMirrorLR ) ;
		
		//_________Create Beams if not in Map
		Entity bmL = _Map.getEntity( "bmFillL") ;		
		Entity bmR = _Map.getEntity( "bmFillR") ;		
		
		if (! bmL.bIsValid() )
		{			
			Beam bmLNew;
			bmLNew.dbCreate( ptFillerL, vZ, vY, vX, dWSLength, dWSThick, dWSHeight, -1, -1, -1 ) ;
			_Map.setEntity("bmFillL", bmLNew ) ;
			bmLNew.assignToGroups(el);
			bmLNew.setColor( 32 ) ;
			bmLNew.setExtrProfile( stExtrStiff) ;
			
			Beam bmRNew;
			bmRNew.dbCreate( ptFillerR, vZ, vY, vX, dWSLength, dWSThick, dWSHeight, -1, 1, -1 ) ;
			_Map.setEntity("bmFillR", bmRNew ) ;
			bmRNew.assignToGroups(el);
			bmRNew.setColor( 32 ) ;
			bmRNew.setExtrProfile( stExtrStiff) ;			
		} 
		
		//______Reposition beams whenever script runs,
		//only to prevent accidental user edits.		
		if ( bmL.bIsValid() && bmL.bIsKindOf(Beam()) && !elW.bIsValid())
		{
			Beam bm = (Beam) bmL;
			CoordSys csL( ptFillCenL, vZ, vY, vX ) ;
			bm.setCoordSys( csL ) ;
			Cut ctTop( ptFillerL, vZ ) ;
			Cut ctBot ( ptFillerL - vZ * dWSLength, -vZ ) ;
			bm.addTool( ctTop);
			bm.addTool( ctBot);
			bm.setExtrProfile( stExtrStiff) ;
		}
		if ( bmR.bIsValid() && bmR.bIsKindOf(Beam()) && !elW.bIsValid())
		{
			Beam bm  = (Beam) bmR; 
			CoordSys csR( ptFillCenR, vZ, vY, vX ) ;
			bm.setCoordSys( csR ) ;
			Cut ctTop( ptFillerL, vZ ) ;
			Cut ctBot ( ptFillerL - vZ * dWSLength, -vZ ) ;
			bm.addTool( ctTop);
			bm.addTool( ctBot);
			bm.setExtrProfile( stExtrStiff) ;
		}
				
	}	
	
	//____________Erase beams when parameters change.
	if ( (psWeb == "No" ) )
	{
		Entity entL = _Map.getEntity( "bmFillL" ) ;		
		if ( entL.bIsValid() ) entL.dbErase() ;
		_Map.removeAt("bmFillL", FALSE ) ;		
		Entity entR = _Map.getEntity( "bmFillR") ;		
		if( entR.bIsValid() ) entR.dbErase() ; 
		_Map.removeAt("bmFillR", FALSE ) ;
		
	}
	
	
//#########################__End Web Stiffener__############################
//##########################################################################



//################____Create Backer Block if requested__#########################
//##########################################################################
	if ( psBacker != "None" && stExtrBacker != "" ) 
	{				
		//________Set Backer length top iLevel Min.
		double dBackerLength = U(12);
		
		//_______ Set Mirror CS to aligne with header
		csMirrorLR.setToMirroring( Plane( qdAll[1].ptOrg(), vX) ) ;
		
		//_________Calculate reference point
		Point3d ptBackerF = _Pt0 - vZ * (dJoistH/2 - U(1.375) ) ;
		//ptBackerF.vis(3) ;
		Point3d ptBackerB = ptBackerF + vX * dHeaderW ;
		//ptBackerB.vis(2) ;
		Point3d ptBackerCen = ptBackerF + vX * dBackerThick/2 + vZ * dBackerHeight/2 ;
		
		//_________Create Beams if not in Map
		Entity entF = _Map.getEntity( "bmBackF") ;
		Beam bmF = (Beam)entF;
		Entity entB = _Map.getEntity( "bmBackB") ;
		Beam bmB = (Beam)entB;
		if (! bmF.bIsValid() )
		{
			
			bmF.dbCreate( ptBackerF, vY, vX, vZ, dBackerLength, dBackerThick, dBackerHeight, 0, 1, 1 ) ;
			_Map.setEntity("bmBackF", bmF ) ;
			bmF.assignToGroups(el);
			bmF.setColor( 32 ) ;
			bmF.setExtrProfile( stExtrBacker) ;

		} 
		
		if ( psBacker == "Double" && (! bmB.bIsValid()) ) 
		{
			bmB.dbCreate( ptBackerB, vY, -vX, vZ, dBackerLength, dBackerThick, dBackerHeight, 0, 1, 1 ) ;
			_Map.setEntity("bmBackB", bmB ) ;
			bmB.assignToGroups(el);
			bmB.setColor( 32 ) ;
			bmB.setExtrProfile( stExtrBacker) ;
		}
	}	
	
	//____________Erase beams when parameters change.
	if ( psBacker == "None" && _Map.hasEntity( "bmBackF")  )
	{
		Entity ent ;
		Beam bm ;
		ent = _Map.getEntity( "bmBackF" ) ;
		bm = (Beam)ent ;
		if ( bm.bIsValid() ) bm.dbErase() ;
		_Map.removeAt("bmBackF", FALSE ) ;
		
		ent = _Map.getEntity( "bmBackB") ;
		bm = (Beam)ent ;
		if( bm.bIsValid() ) bm.dbErase() ; 
		_Map.removeAt("bmBackB", FALSE ) ;
		
	}
	
	
	//#########################__End Backer Block__############################
	//##########################################################################

	
	
	
	
	//__Set End gap for Beam
	Cut ct( ptCenter - vecZ1 * dEndGap, vecZ1 ) ;
	Cut ctFlush ( _Pt0, vecZ1 ) ;
	
	for ( int i=0; i<iNumJoists; i++ )
	{
		if (bmJoists[i].bIsKindOf(Beam()) && !elW.bIsValid())
			{
				Beam bm = (Beam) bmJoists[i];
				bm.addTool( ct );
			}
	}
	String stModelOut = pstModel;
	if(pstModel == stUserDefinedHangerKey) stModelOut = pstCustomModel;
	//__Save out data for labeling
	_Map.setString( "stModel", stModelOut ) ;
	_Map.setPoint3d( "ptCenter", _Pt0 ) ;
	_Map.setString( "stNotes", psNotes) ;

	_Map.setString( "stJoistNails", psJoistNails ) ;
	_Map.setString( "stFaceNails", psFaceNails ) ;
	_Map.setString( "stTopNails", psTopNails ) ;
	_Map.setString( "iJoistNailsQty", piJoistNailsQty ) ;
	_Map.setString( "iFaceNailsQty", piFaceNailsQty ) ;
	_Map.setString( "iTopNailsMin", piTopNailsQty ) ;
	
	//################################
	_Map.setString( "stWeb", psWeb ) ;
	
	
	//__Add data for another schedule TSL used in layout
	_Map.setInt("HANGER_SCHEDULE",1);
	int iHqty = psAddTop == stYN[1] ? (!elW.bIsValid() ? 2 : 1) : 1;	
	_Map.setInt("HANGER_QTY",iHqty);
	_Map.setInt("HANGER_LOOSE",psShipLoose == stYN[1]?1:0);
	_Map.setString("HANGER_MODEL",stModelOut);
	Point3d ptArray[]={_Pt0};
	_Map.setPoint3dArray("HANGER_POINTS",ptArray);
	_Map.setVector3d("HANGER_VECTOR",-vX);
	
	
	
	String stFNail = (String)psFaceNails ;
	String stTNail = (String)psTopNails ;
	String stJNail  = (String)psJoistNails ;
	String stW = (String) psWeb;
	String stB = (String)psBacker ;
	String stNote = (String)psNotes;
	String stModel = (String)stModelOut ;
	String stCompare = stModel ;
	stCompare += stNote;
	stCompare += stW ;
	stCompare += stB ;
	stCompare += stJNail;
	stCompare += stFNail;
	stCompare += stTNail;
	stCompare += psShipLoose;
	setCompareKey( stCompare  ) ;
	
	//reportMessage( "\n" + stCompare ) ;
	
	_ThisInst.assignToGroups( _Entity[0] ) ;
	
	/*
	Declare Hardware data for Excel
	Format is -->Hardware name(String strType, String strDescription, String strModel,
	 double dLen, double dDiam, int nNumber, String strMaterial, String strNotes);
	
	*/
	Group gpBmAll[] = _Entity[0].groups() ;
	String stGroup = gpBmAll.length() > 0? gpBmAll[0].name() : "Loose" ;
	

//This is some export data for Pipeline. These fields names never change 
//but the exported data could be anything
	dxaout("PipelineItem",1);
	dxaout("ItemType","Hanger");
	dxaout("ItemDescription", stModelOut);
	dxaout("Quantity",1);
	dxaout("QuantityType","Each");
	dxaout("Dependency", _Entity[0].handle());
	dxaout("Notes","Depencency is the handle of the male beam it is attached to.");
	exportToDxi(TRUE);
	
	
	_ThisInst.setModelDescription(stModel);
	_ThisInst.setMaterialDescription("Hanger");
	_ThisInst.setOriginator("RC Hardware");	
	
	// dxaoutput for hsbExcel
   dxaout("Name",stModel);// description
   dxaout("Width", U(2)/U(1,"mm"));// width
   dxaout("Length", U(10)/U(1,"mm"));// length
   dxaout("Height", U(4)/U(1,"mm"));// length

   dxaout("Group",stGroup);// group
   dxaout("Label", stFNail );    
   dxaout("Sublabel", stJNail);                
   dxaout("Info", stTNail );  
   dxaout("Loose",psShipLoose);

//__Register this TSL to map Object for BOM
	MapObject moReg("moHangers","moHangers");
	//__Always clean it out
	Map mpReg = moReg.map();
	
	int bAdd = true;
	for(int i=mpReg.length()-1; i>-1; i--)
	{
		Entity ent=mpReg.getEntity(i);
		
		if(!ent.bIsValid())
		{
			mpReg.removeAt(i,true);
			continue;
		}
		
		if(ent == _ThisInst)bAdd = false;
	}
	
	if(bAdd)
	{
		mpReg.appendEntity("entTsl", _ThisInst);
	}
	
	if(moReg.bIsValid())moReg.setMap(mpReg);
	else moReg.dbCreate(mpReg);
	
	HardWrComp hwr[1];
	hwr[0].setModel(stModel);
	hwr[0].setQuantity(1);
	hwr[0].setDescription("Hanger");
	
	//Add nails here	
	HardWrComp hwrTopNail, hwrFaceNail, hwrJoistNail;
	
	
if (bTopNail || bFaceNail || bJoistNail)
{
	String stNailNote =", Nails: ";
	if (bTopNail)
	{
		hwrTopNail.setName("Nail");
		hwrTopNail.setArticleNumber(String(psTopNails));
		hwrTopNail.setModel(String(psTopNails));
		hwrTopNail.setQuantity(psAddTop == stYN[0] ? piTopNailsQty : 2*piTopNailsQty);
		hwr.append(hwrTopNail);
		stNailNote += String("(" + piTopNailsQty + ") " + String(psTopNails) + "-top");
	}
	if (bFaceNail)
	{
		hwrFaceNail.setName("Nail");
		hwrFaceNail.setArticleNumber(String(psFaceNails));
		hwrFaceNail.setModel(String(psFaceNails));
		hwrFaceNail.setQuantity(psAddTop == stYN[0] ? piFaceNailsQty : 2*piFaceNailsQty);
		hwr.append(hwrFaceNail);
		if (bTopNail) stNailNote += ", ";
		stNailNote += String("(" + piFaceNailsQty + ") " + String(psFaceNails) + "-face");
	}
	if (bJoistNail)
	{
		hwrJoistNail.setName("Nail");
		hwrJoistNail.setArticleNumber(String(psJoistNails));
		hwrJoistNail.setModel(String(psJoistNails));
		hwrJoistNail.setQuantity(psAddTop == stYN[0] ? piJoistNailsQty : 2*piJoistNailsQty);
		hwr.append(hwrJoistNail);
		if (bTopNail || bFaceNail) stNailNote += ", ";
		stNailNote += String("(" + piJoistNailsQty + ") " + String(psJoistNails) + "-joist");
	}
	hwr[0].setNotes(stNailNote);
}
	
	_ThisInst.setHardWrComps(hwr);









































#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`&3`6@#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P":BBBO=/OR
MQ;7MU9[A;SO&KXWH#\K@=F7HPY/!XYJ8WMM-_P`?6G0,3]Z2`F%_;`&4'_?'
MZ\U1HI61$J<9.[1<-EI\WS0:AY'<I=1MQ[!D#;L>I"]N/2&?2KVWA:9H-\"_
M>FA82QJ>F"RD@'IP3GD>M0U)#/-;3+-!*\4J_=>-BI';J*=Y+J0Z<EL_O_K_
M`#*M%:0U!F9S=6UM=;SN8RIABV`,EE(8].<G!)).3S08-,N/]5//:/T`G'FI
M]2Z@$?0(?KSQ7/W1+<ENONU_X/X&?J'D:RI76;.VU,$!2]VFZ4*#D*)1B10#
MSA6`Y/J<\S>_#KPS>9-M-J6F2,^\D%;J,#^XJ'8P'H2['`P<DY':'1;M^;39
M>KV^RMO;'KL^^!GC)4#IZC.?64J%&IT.2>#PU;>.OEI_7S/,=0^&/B*U4O8K
M;:N@`S_9\A:3.?NB)@LC8X)*H1COP<<K?6%YIEY)9W]I/:74>-\,\9C=<@$9
M4\C((/XU[Q4S7,DMJEI<+%=6J'<EO=PK/$K<_,$<%0>3R!GD^IKFG@/Y&>?5
MR;_GW+[_`//_`(!\\T5[->^"?"E_'M739=,<`A9+&X=AD]W24ONQV"LF>03T
M(Y?4/A7J"L6T?4K/4$)&(YG%K,!CEF#GR^O&!(Q((..N.6>'J0W1YU7`XBE\
M4?NU.!HK2U?P_J^@R(FJZ;<V@D+")Y(R$EVXR4?[KCD<J2.0<\BLVL#D"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`/H:BBBO=/OPHHHH`****`"BBB@`J^=7NY/\`CY:.[!X)
MN8Q(Q'H'/S`?0C&21@U0HH:3W)E",OB1=)TNXYDAGLWZDP'S4^@1B"/7)<_3
MGAITAY/^/2[M;MNZ1N5;/8!7"EB?1<G\QFI11JMF9NE;X7^O_!_$;/!-;3-#
M<1212K]Y)%*L._0U'5^#4+JW78DQ,>-IB<!T(!)`*MD'!)(R."<]:D,]A<?\
M?-EY3G_EK:MMY/5BC9!]=J[!U'IA\[ZH34UNK^G]?YE*&ZG@CEBCE813#;+$
M>4E7GY74\,,$C!!')K)OO#7AK4_,-WH4$4LF-UQ8.UNXQC&U!F)>@!_=\\GJ
M=U=$=.MIO^//4(V;H([E?)8GV.2F,>K`]>.F:MU8W5EM^TV\D:OG8Y'RN!W5
MNC#D<C(Y%3*%*I\2.>I1H5G:<=?N?^9Y_J/PMCDW2:+K,;'YF%MJ">4W^RBR
M+E6/8L_ECH>`3MY75O!?B+1+=[F^TN7[*@!>Z@99X4R<`-)&653G'!.>1QR*
M]BJ2">:VF6:WEDBE7[KQL58=NHKGG@8OX78X*N3TWK3=OQ/GNBO?+VRTO5,_
MVGHNFW99_,9S!Y4COW9I(MCL3DYW,<DY.3@URNH?#'2+E2=)U6YLI,`+%J"B
M:,G/),L:AEXZ`1MR.N#\O)/"58]+GG5<LQ%/5*_H>6T5UVH?#7Q-:,3:6:ZM
M%D!7TUO.8\<GRL"50#QED`SCGD9Y&N=IIV9PRC*+M)684444B0HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`/H:BBBO=/OPH
MHHH`****`"BBB@`HHHH`****`"BBB@`JQ;7UW9;OLMU/!OQN\J0KNQTSCZU7
MHH:ON)I-69>-]!/Q>6$#]O,@`@<#T&T;.O<J3SUZ8:;33IO]3?O`QYVW4)VJ
M/3<FXL??:`>>G2J=%*UMC-T5]G0L2:/J$<;2BV:6)`6>6`B5%QURR$@8ZX)H
MM=&U.^6-K:PN94D.%D6,[#SC[W3KWS4*.\4BR1NR.A#*RG!!'0@UZO;K<W6D
MZ?*RB8&SC:1I2#DE>3D\Y]2*X\?CIX2GSJ/,^R.'&XB>&BGH[G`1>$+]H]TT
M]G`<D!'EWD^_R!A^O:EU3PM>W\9>_M],UPLAC9ID628)_<5Y`)!G)QL.022,
M&N\DL[7:I>6*(D?\LW+@?4<\_C5.Y5+:)V@LY[]TY41RHBN.XP?GSUX4'/'.
M3@>+#,LPK3LZ<;>>GY_Y'DO'5*LK22?DUI^/^9XEK/PST*2;!AU+0;AL/L"&
M>+;TPL<A5QDC.XR-R",<C;R-[\+M=@CWV,^GZH0"62TF*N,=`$E5&<GG`0,>
M,8Y&?<]6\674<-[I\FEP6EO(F'BN`[.G'WOF(`/<''IZ5RU>W#"^TC>:Y7Y.
MZ.I99"K'F:Y7Y.Z_KYG@]]87FF7DEG?VD]I=1XWPSQF-UR`1E3R,@@_C5>OH
MC[;<&S^Q2R>?9][6=1+"><\QME3SSR.O/6N?U'P;X8U7<SZ?)IUPVX^=I\F%
M+-_$T3Y4@'D(AC')''&,IX*HOAU..KE-:&L'<\7HKT+4/A7.%+:-K%M>$`8A
MNT^R2LV><9+1X`YRTBDX(QTSQ^K^']7T&1$U73;FT$A81/)&0DNW&2C_`'7'
M(Y4D<@YY%<LH2AI)6//J4JE-VFK&;1114F84444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`'T-1117NGWX4444`%%%%`!1110`4458MK&[O=WV6UGG
MV8W>5&6VYZ9Q]*&[;B;25V5Z*VX?">K2,HEBBMU9=Q::505&,\J"6S[8S6C#
MX.@58FNM2+$G]XD$)/&>S,1U'M6$\31AO(Y:F/PU/>:^6OY')T5W</A[1X0V
M;66<DC!GF/R_39M_7/2M"&.WM65K:TMH&1=JM'"NX#&/O?>SCOG-<TLRI+X4
MV<53.:*^"+?X'GUOIU]>1F2VLKB=`=I:*)F`/ID"M2'PCJ3AC,]K;X(`WS!M
MWTV;OUQUKL7EDEQYDCOCIN.<4RN:>93?PJQQU,YJOX(I?B8,/A"T1E-S?RR`
M+\Z0Q!03CH&)Z9[[?PJ]%H&CPQ[?L;S'.=TTS$_0;=H__76A17-+&5Y?:.*>
M/Q,]YOY:?D+%Y=N[/;6]O;LPP3!"J'&<XR!G'`I7D>0YD=F.,98YIM/DC:!=
MT^(5)P&F8("?3+8YK!N4WW.5R;=VQE%5I=3TZ`L)+Z(LHR5C!<GV!`VD_C]<
M52E\2V*8\JWN9L]=Y6+'_H6?TK2.'JRV1',C2NX8KZRDL[M%FMW4J8W&0,@@
MD>AY/(P>:YW3?!%G;636DMU<S/YC>1(H`9$(`56'.[&.VW.<>F'R^*+DAA!;
M6\7/RN078#WR=I/X?E6O8ZUJ`\*7MX+C$ZRG:VQ<+S$.!C`^\>W?-;<E7#KV
MG-;I]YT4<96IIPIRLF9J?#Z5G=C?LD"IG<]N0Y;/3;NQC'?=^'>ID\'Z?:K&
M\Z7MR$.7<,J1MSTX#<=!PWKTJKH=Y=7>NV_VFYFFVI+M\R0MC,;9QFNG5F1@
MRL58="#BO,S/.\31<8QE:_I_D=*QV(FM9&(VBZ0RE?[-1,C&Y)9-P]QEB,_4
M&F#PU-;PM-H^I7UDK*-YD8B,X)Y:1,8`'^R<<\UI^(-8_LJTL'$3;YR[&6&0
M1R!E9<<X(8')R"#FN2GFGOM0:_MM;)O&XS,/LSD@8X(.P#;ZL">>.F?0RVEC
MITXUI5KQDKV:N=6'ABIQY^;W7WUV_(YK7O"6A3W<MKJ>BV:S*%`N=+(MFV?>
M4J$'E'(/5HR<'&1@8Y&]^%EE+EM+U_RF+Y$6HVQ543T\R/>78<#/EJ#R>.!7
M?7.G7EI&)9H&$).U9EPT;'T#C*GH>A['TJK7NO"TIJ_Y'9++L/55[:]UI^&Q
MY#J'@3Q1ID<DL^BW,D$<9EDN+3%S%&HR3NDC+*N`,D$@@8/0BN=KZ"CD>*19
M(W9'0AE93@@CH0:CU"VT_66+:QI=GJ+DAC+,A69B!@;I4*R-@<8+$8QQP,<T
M\#)?"S@JY/-:TY7]3P&BO5KWX::!<QXT[4-0L)0#C[7LN4=OX<LBH4`/4A7/
M/`XP>7U#X:^)K1B;2S75HL@*^FMYS'CD^5@2J`>,L@&<<\C/).C4A\2/.JX6
MM2^.-CD:*DG@FM;B6WN(I(9XG*21R*59&!P00>00>U1UF<X4444`%%%%`!11
M10`4444`%%%%`'T-16M%X9UB6/?]A>,9Q^^98B?H&(/?K6C%X-D#L+G4;=5`
MX\A&D).?<*,=><U[$\12A\4D?:U,;AZ?Q37Y_D<Q17:P>%]*B\LRO=7#*<O\
MRQJW/3`!(&/]K\JT(K#3X(]D6G6BC.3OC\PG\7R>W2N:>8T8[:G'4SBA'X4V
M<!;VMQ>2&.VMY9W`W%8D+$#UP*TX/"VKS>66MA`KGK/(J%1G&2I.['X5W$ES
M/*&#RNP8Y(+<?E45<TLSE]F)Q3SJH_@BE^/^1S</@XX8W.I1+R-H@B9\^N=V
MW';UK3C\.:+!(Q$-Q<`C`$\N`.G.$`/ZUHT5S3QM>76QQU,QQ,]Y6]-"."VL
M[7R_L]C:QF,Y5O*#,#G.=S9.?QJP\TL@Q)*[#.<,Q-1U(D,L@S'$[#.,JI-<
MTISF]7<Y)3E)WD[D=%127=E"NZ6^ME4G'RR"0_DF35&7Q#IT8;RUN)F4X`"A
M%;W#$D@?\!_*KC0J2V1%T:=%8$GBEMW[BQA"XY\YV<Y^JE>/PJC)X@U21=OV
MLQ\YS"BQG\U`./:MXX*H]]">9'8>3)Y?F;&$8&2Y&%`[DGH!562_T^%MLM_;
MJQ&?E)D'YH"*XJ::6XE:6:5Y9&ZN[$D_B:96T<#'[3%SG52>)-/1<Q0W,S9^
MZP6,?7.6_+%4Y?%$Q+""S@1<?*SEG9??J%/_`'S^=8-%;QPU*/07,S0GUO4K
M@*'NF4*0<1*(\D$$$[0,X(R,]*SZ**V22T0@HHHIB"NDLO\`D1K_`/Z['_T*
M&N;KI"/LG@-"KAFN[CY@1]U<]O?,0_,_6N/&ZTK>:_S+CN4O#?\`R'8?]R7_
M`-%M765S'A>)6U.64D[H8&9?0DD)S^#']*Z>OBL[:]I%>1TTMC!\;_\`'AH_
M_;;^:UQM==XV'[C2CM<927YBWRGYAP!G@^IQSD<G''(U]YE/^XTO\*/J<N_W
M:/S_`#9-;W5Q9R&2VN)8'(VEHG*DCTR*L&_BF_X^M/M92>-\:^2P'L$PN?<J
M??(XJC17?9'7*G&3NT7#:Z=<<PW;VK==ETA90/\`?09)[_<`Z\\<QR:/?1QM
M(L(F1`6=K>19@@'=BA.W\<=#Z57IR.\4BR1NR.A#*RG!!'0@T[R6S(=.2^%_
M?_7^97HK4.J2S?\`'[#!>]]TZG>3ZEU(<\<8)(]N!AI32[GH9[*0_P#;6,D_
MDRJ/^!G'J1R^?NB7S+=?=K_P?P*-U(NH6ZVVI00:A;HAC2.\C$OEJ1@A&/S1
MY`'*%3P.>!CF[[P!X6OO,:&.^TN9\8,$HGACQCI&_P`YR!WEX)ST&VNQ.CSR
M?\><L%[_`+,#'>3Z!&`<\<Y`(]^#BA)&\4C1R(R.A*LK#!!'4$5$J-*INCEJ
M87#UG[T=?N?]>IYO>_"S6$DSI=YI^HQ$G&;A;9T7^'>LI49([(S@8//0GD=2
MTG4M&N%M]4T^[L9V3>L=U"T3%<D9`8`XR#S[&O=*F6ZE%J]HQ66T<[GMID$D
M+GCEHV!5N@/(Z@'M7-/`K[#."KDZWIR^\^>:*]LO?"?A;4<F?1?LLC/YC2Z=
M<-"S'N-K[XU7G.%1<8&,#@\KJ'PKG"EM&UBVO"`,0W:?9)6;/.,EH\`<Y:12
M<$8Z9Y)X:K#='FU<!B*6KC=>6IY[16QK/A77=`7S-3TR>&W+A%N0`\#L1G"R
MKE&.`>`3T([&L>L#C:MHPHHHH`****`/M*BDEDAMRPGN((64997E4,/^`YW?
MIS5*76]+BQ_I,DV?^>,1./KNV_IFN6-&I+9%71>HK$E\3P@,(+%F8'Y6EEX/
MN5`!_#=^=49?$FHN6\MXH5(P%CB&5^C'+`^^?I6\<'4>^@N9'6)%)+GRXW?'
M7:N<5#+/;6X8SW=O'L.&!D!93Z%1EL_AQ7%7%Y=7>W[3<S3;<[?,D+8SUQFH
M*VC@5]ID\YU\VNZ9#D+++<-C(\J/"GV);!'Y'\>E49?%/3[/8(/[WG2%_P`M
MNW'ZUSU%;QPM*/07,S4E\1:G(&"SK"I/'E1JI7V#`;OU^M4)[FXNI`]Q/+,X
M&`TCEB!Z<U%16RC&.R$%%%%4(****`"BBB@`HHHH`****`"BBB@`KI+S_D1K
M#_KL/_0IJYNNDO/^1&L/^NP_]"FKAQWPQ]?T9<"+PK_Q^W?_`%[?^SI725S?
MA7_C]N_^O;_V=*Z2OB<Z_CQ_P_JSII;'+>.$5=6M"J@%[.,L0.IRPR?P`'X5
MS%=1XZ_Y"ME_UXQ_^A-7+U^BX'_=H>B/K,#_`+M#T"BBBNHZPHHHH`****`"
MKJ:M>K&L;RK,B`*BW$:S!!Z*'!V]NF.@]*I44-)[DRA&7Q*Y=+Z9<<2VDEHW
M0/;.74#W1SDGM]\#IQQRTZ4DO_'IJ%K*3R$D?R6`]]^%STX#'VR.:J44:K9D
M.E;X7^O]?>%S:7-G(([JWE@<C<%E0J2/7!^E0U?M]0N[6,Q13-Y).YH7`>-C
MZE#E3T'4=AZ5*;NTG_X^]/0MU,EJWDL3],%`,>B@].>N7SOJB;372_I_P?\`
M,HVUW<V<ADM;B6!R-I:)RI(],CZ5FWNA>'M3R;W0+'S"GEB6T4VK(/55C(CW
M#)(+(W;.0`*WCI]I+_Q[:E'GH$N8S$S'VQN4#W+#OG`YJO<Z=>6D8EF@80D[
M5F7#1L?0.,J>AZ'L?2IE&G4^)&%2G1JZ5%]^YP>H?"ZPN&+Z1K36I)'[C4HR
MRJN.?WL0)8D\X\M1@GGCYN7U7P!XDTJ.2<Z>UW:1AW:YL6$Z*B\[WVY:,$<C
MS`IX/'!QZU3HY'BD62-V1T(964X((Z$&N>>!@_A=C@JY12EK!M?B?/M%?0%]
M'9ZMYG]K:;8Z@TN/,EG@'G/C&,S+B7C`'#]!CIQ17.\%43T.&64UT]+,TZ**
M*V/'"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`KI
M+S_D1K#_`*[#_P!"FKFZZ*]=5\%:;&3AI)"RCU"M)G_T)?SKBQR?+'U_1EQ&
M>%?^/V[_`.O;_P!G2NDKF_"O_'[=_P#7M_[.E=)7Q&=?QX_X?U9TTMCE_'7_
M`"%;+_KQC_\`0FKEZZCQU_R%;+_KQC_]":N7K]%P/^[0]$?68'_=H>@4445U
M'6%%%%`!1110`4444`%%%%`!1110`5-;W5Q9R&2VN)8'(VEHG*DCTR*AHH$T
MFK,O'41/Q>VD%SGK)M\N3GJ=RXW,?5PW/U.6FVTR?_574]LYZ)/'O1?JZ\G\
M$[X]ZIT4K6V,W1C]G3^NVQ8DTB\6-I8D6YA4%FDMV$@5?5@.4&/[P!X/H:*A
M1WBD62-V1T(964X((Z$&BJYI$\E1=G^'^9;HHHKC/@PHHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*V]2.?#&A]>/M';_`&Q6)72^
M(R3H^B`DG$.![?NXJXL;*T$N[+CN)X5B7;>SY.X!(L=L,2Q_'*#]:WZP_"O_
M`!Z7W^_%_)ZW*^%SAMXGY(ZJ?PG)>-)A)K4*"16\JUC0@*1MX)P3WZYR/7':
MN<KH_&T@.OB'<[-!!'&VX#`.,_+CMSWYR3VQ7.5^E8-..'@GV1];@E_L\/0*
M***Z#I"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`NT445R'YX%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!72>(O^0/
MHO\`UQ_]IQ5S==#KI+:)HQ+!OD(R/]R.O.S"7P+S_0N'4F\*_P#'I??[\7\G
MK<K#\*_\>E]_OQ?R>MROB,W_`-Y^2.JG\)QOC3_D;;[_`+9_^BUK!K>\:?\`
M(VWW_;/_`-%K6#7ZA2_AQ]$?783_`'>'HOR"BBBK.@****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@"[1117(?G@4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%;.MNWV328L_(+19`/]HD@G\E7\JQJU];
M_P!5I7_7@G_H35YV.7O1^?Z%Q-#PK_QZ7W^_%_)ZW*R/#42II4TH)W2S[6],
M(HQC_OL_I6O7P^;-/$M=DCJI_"<;XT_Y&V^_[9_^BUK!K<\8H$\5WP!8Y*'Y
MF)ZHI[_R[5AU^HTOX<?0^NPG^[P]%^044459T!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`7:***Y#\\"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`K?\50+:WMI;H6*16VQ2W4@.XYK`KI/&G_`"&(
MO^N)_P#1CUYV.^./H_T-([%OPY_R`_\`MY?_`-!2M2LOPY_R`_\`MY?_`-!2
MMB!0]Q&K#*LX!'XU\-F47+&RBNMOR1TP^$X+Q1_R,VH?ZC_6G_4_=Z=_]K^]
M_M9K(K1U]R_B'420HQ<R#Y5`Z,1V_GWK.K]3A\*/L:"M2BO)!1115&H4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`%VBBBN0_/`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*Z'QC*K:\8@#NA3:WH22
M7X_!A^M<]6WXK8/XENF4Y5A&0?\`@"UY^.2]U]=?T+B:GAS_`)`?_;R__H*5
MLVW_`!]P_P"^O\ZQO#G_`"`_^WE__04K9MO^/N'_`'U_G7Q&._Y&'SC^2.J/
MP'G.N?\`(P:E_P!?4O\`Z$:H5?US_D8-2_Z^I?\`T(U0K]0A\*/LJ/\`#CZ(
M****HT"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`NT445R'YX%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!6OXD_P"0
M[-_N1?\`HM:RX89+B>.&)=TDC!%&<9).!6IXD_Y#LW^Y%_Z+6O,Q_P`</1_H
M:0V-[1(EBT*VVD_O2\K9]=VWCVP@_6M.V_X^X?\`?7^=9^D?\@*Q_P!Q_P#T
M8]:%M_Q]P_[Z_P`Z^(Q3;QSOW7Z'3'X3S759?/UB]F\MX_,N)&V2##+EB<$=
MC52IKHN;R<R+*KF1MPF;+@YYW'`R?7@5#7ZHM$?:05HI!1113*"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`NT445R'YX%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`%W1O^0YI__7S'_P"A"K7B3_D.
MS?[D7_HM:JZ-_P`AS3_^OF/_`-"%+K/_`"'-0_Z^9/\`T(UYN.C[T9>II$ZK
M2/\`D!6/^X__`*,>M&U!-W"`"?G!X^M9VD?\@*Q_W'_]&/6KIW_'_%^/\C7Q
M-:/-F/+WDOT.E?`>2T445^IGVP4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110!=HHHKD/SP****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`+NC?\AS3_P#KYC_]"%+K/_(<U#_KYD_]"-)HW_(<T_\`
MZ^8__0A2ZS_R'-0_Z^9/_0C7GXWH7$ZK2/\`D!6/^X__`*,>M73O^/\`B_'^
M1K/LHEATRSB4DJ(%;GKEAO/ZL:T-._X_XOQ_D:^(DT\R5OYE^:.K[!Y+1117
MZD?;!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`%VBBBN0_
M/`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`M:8YC
MU:S<8RLZ$9_WA4FL_P#(<U#_`*^9/_0C5GPQ"MQXAM8G`(8/U&<'8V#^!YJA
M>7'VN^N+G;L\Z5I-N<XR<XS7F8R_M/*W^9I'8[B#_CRM/^O:+_T!:DVEXIE5
MXD)AD`:;&Q?D/+9R,>N:C@_X\K3_`*]HO_0%J3SC;Q33+(T9CAD<.JABN$)R
M`>#]#7Q,/^1DO\?_`+<=D+V5CRZBBBOU0^S"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`+M%%%<A^>!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110!M^$?\`D:+/_@?_`*`U8M;7A,[?$=O*W$<2
MN\C]D781DGL.1S6+7FXU^^D:1V._@_X\K3_KVB_]`6GR;UL+Z6-V1XK25U93
M@@[3C![=:9!_QY6G_7M%_P"@+3Y?^05JG_7C+_Z#7QF'BI9HD_Y_U.VGO'Y'
ME]%%%?J!]D%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`7:
M***Y#\\"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M#<L4:P\.7U^5*O=$6L+#K@Y+Y!XP0",\\CM6)6YXA462V.D!P_V.(F0^DCG<
MPSQD="/KS6'7BUI\\VS5:(]$>)8&\A22L($2D]2%&T9]\"H[APFD:H2&.;.0
M?*I/48[?S[5/<_\`'W-_OM_.N>\1:VVGI-IL`(N)8]DY8?<1AG:/<C\@?7I\
MSE="K7S).*O:3;^\]'#4I59QC$XNBBBOTL^M"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`+M%%%<A^>!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!6OX=LFN-2%RSF.WLL7$TFTG`4YQ]3C\@>N,5D5
MT%J38^#+N="?,O;A8"5D'RJH)Z#GGY@0>Q'XXUY<M-L:W,6YG>ZNIKAP`\KL
M[!>@).>*BHHKQS4[WQ#JT6A>8Q!>^G#M;JI4B/G`=L_7(X.<'\/-*T=;_P"0
MBO\`U[6__HE*SJ]S`82EAJ5J:WU?S/K\OH1I45);R2;"BBBNT[@HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@"[1117(?G@4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`5NERW@500/EU'`PH'_+///KU
M[UA5T%XZQ>"M.@+2,T\[S+DY"A25('H.0?J37-BG:F5'<P****\HT'ZW_P`A
M%?\`KVM__1*5G5HZW_R$5_Z]K?\`]$I6=7TM'^''T1]KA/\`=X>B_(****T.
M@****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`NT445R'YX%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%;>I?\BOH7_;Q_
MZ&*Q*V=0?=X9T48QL:<?7Y@?ZUR8QI4[/JRH[F/1117F&A%?F-KK,4SRKY<8
M+.>0=@R/H#D#V`JM5_7/^1@U+_KZE_\`0C5"OIZ:M!(^XH*U**\D%%%%4:A1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`%VBBBN0_/`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`K6O?^1<TG_?G_FM9
M-;FNB."PTBUC3:OV47!.>I<#/ZJ3^/M7#CDW"/K^C+@8E%%%>>6+KG_(P:E_
MU]2_^A&J%7]<_P"1@U+_`*^I?_0C5"OIX?"C[FC_``X^B"BBBJ-`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@"[1117(?G@4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%6;2PN[^39:6TLQ!`.Q<A<],GH/QI7L,
MK45;O+)-+O8[35]2TK3)73>!>W\49V\@'&[."01D#K7,W7CKP79V8E_MV:\F
M,FWR+&QD)"XSN)E\L8SQ@$GD>^)=2"ZA9FW6UX@=9%TDHP8#3HAD'/(+`C\"
M,5YM-\8/#EK?R?8_"]_?6F`$:\U!86/`R2J(<<Y'WCQS]+%_\<]&N;J!_P#A
M#YYHH;:.%$?4M@7`R>D9)P20"3R,$@$X')B)*I&T2DK'45+%;7$Y00P22%R0
MH1"=Q`R0,=<`@UY/=?&'Q!+9BWL[#1K!A)O,T-GYKGC&W]\SC'0\#M]<Y6I?
M$[QOJMPL]QXGU)'5-@%K,;=<9)Y6/:">>N,]/05R*EW95SWK7M$O_MU_J,,2
MW-FUS*?.MW$@7#-N!QR"I!4Y'!!%<_7A-KKNL6.HSZC9ZK?6]]/N\ZYAN'22
M3<=S;F!R<D`G/4UV>D?&#7+*1UU/3])U6WD*AUELHX75>=P1X@NTD'J0V,`@
M=<^K3QEE:2/<P^<\L>6I';L>AT5CV?Q&\$ZM-;BX34M!DDW>=F,7=O'C[N&!
M$ASC^Z>6]!FNJM=)35[=KKP_J5CK,"H)&^R3`R1J1E=\9^96(!^7KD$=JZ8X
MBG+J>I2S+#5=I6?GI_P#-HISH\4C1R(R.A*LK#!!'4$4VMCN"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`NT445R'YX%%%%`!1110`444Y$>214
M169V("JHR23V%`#:*N2Z5>6UG->7<0L[6';YDUXZP(N3@?,Y`ZX'XCUK%O?$
MWA#2Y[F&[\4VDLD$>X)I\,ESYC8!"JX41DG.,[\`\''.(=2*W8[%ZBN3O?BS
MX5MV@;3M%U>^^9C*MW<1VP`R-H&T.6XR#RO3CKQS][\9-6=+J+3=&T>P25\Q
M2&%KB6)0V0,RLR$XX)V#/H.,9NO'H.QZ?##+<2K%#$\LC=$122?P%7+G3#IW
MDG6+_3M(6=2T3:A=I#OQC(`)SD;AGCCO7@]_\2O&FH2QO+XEU"'RXQ&J6DOV
M9`HSCY(MJYYZXST'85RM0\0^B#E/H*_\7^"--MYS)XF-W=PN4:WL+)Y-Y#8^
M21MJ,.^<X(Z9XSA7/Q<\,VMU#]A\/ZEJ$(C'F&[NTMLOSD!45SCH0=WMVY\:
MHK-U9OJ.R/0;KXP^();,6]G8:-8-YF\S0V?FN>,;?WS.,=#P.WUSSVM^.?%/
MB/SUU;7KZXAGV^9;^:4A;;C'[I<(.0#P.O/6N?HJ&V]QA1112`****`"BBB@
M`HHHH`*D@GFM;B*XMY9(9XG#QR1L59&!R"".00>]1T4`=QHWQ;\8Z0ODRZG_
M`&K:,Y>2VU5?M*N2,#+-\X`(!`#`9'N<]1#\5O#NH1E]2T:\TRZ`7<=/*SQ2
MMSO(1V0QC.,`,PQQVR?'Z*N%24/A9M1Q%6B[TY6/I'3TT3Q`P7PWXDT_4IB2
MBVSDVUP[`9.V.3!8!>=W3@^E5G1XI&CD1D="596&"".H(KYWKJ-&^(WC'0-@
MT_Q%?)&D0A2*:3SHT08P%23<JXP`,#@<=*Z88R2^)7/3HYU5BK5%S?@>O45R
M5O\`&.ROO*77/"\$;^:-UQI$OD;8NX\IPP9N2<[ESP,C&:ZS3]=\%Z^H;3/$
ML5A,07-KK(^SE%!QS+RC$G!"@YP?8UT1Q5-[Z'ITLVP\_B=O46BM&ZT'5K-I
M!/IUPHC&YW5"R`8SG<,C]:SJZ$T]CT8SC-7B[A1113*"BBB@`HHHH`****`"
MBBB@"[17/7OQ(\$V$]S'#-JVJ;(_W+V]LL$<CX!`+.Q8#/!.SW&>^'=_&R1+
MI7TCPGI-O"%!9+UY;IBWS#.=R#&#TQU&<],><Z\5L?GUF=^B/(<(K,0"<`9X
M`R3^`&:N_P!C:B(II9;22"&&,RR2W'[I$4=26?```YZUX9=?%'QI=68M?[>F
MMH1)YF+&..U);&.6B521CL3C@>@KF+Z_O-3O)+R_NY[NZDQOFGD,CM@`#+'D
MX``_"LWB'T0<I]#RZSX2T^*-]5\7:="TN=B6>;TC'7=Y60O48R>>?0US-S\5
M_"-M9H;/2M9O[K<0ZW#QVT84@_,"OF'(...A_0^+45FZLWU'9'IU[\9[TSW)
MTGP[I-E#+'LB-P)+F2+('S`LP0G/(RGL<\YYV]^)WC2_B@B;Q#=V\<&[8ECM
MM1SC.1$%ST[YQSCJ:Y.BH;;W&23SS75Q+<7$LDT\KEY))&+,[$Y))/))/>HZ
M**0!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`&IHGB36O#EQY^C:I=V+ET=Q#*560J<KO7HX&3PP(Y/K7<VWQEO[E`
MGB/2+34Y`A'VN`_9;AFW`@LR@HP"C;C9TQSG.?,J*<9.+NBZ=2=.7-!V9[QI
M7C/P-K<<<7]IWFBWI"*4U&,/$\C=A*G"J#U9PO!!QP:VX]*O+A?-L8C?VQ)"
M7-D/.ADP<95UR#R"/8Y!P17S95BQO[S3+R.\L+N>TNH\[)H)#&ZY!!PPY&02
M/QKHABJD=]3T:.;XBGI+WO4^@'1XI&CD1D="596&"".H(IM>;VWQ@\4"S2UU
M3['K,<0586OXFWQX&#AXV1F)XR6+9P#UKLM/^)?@C6&$=_9:AX>F8E5D1OME
MNJ@9W-P),GE<`$#@^N.F.,@_B5CTZ6=49651-/[U_G^!K45<TZQCUN2--$U/
M3-4=X!/LM;Q-Z(<?>1B'7&1G(&,@'GBH;BUN+.01W-O+`Y&X+*A4D>N#73&<
M9?"STZ=>E5^"29#1115&H4444`?/-%%%>$?`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`5ZY\*/&/B'7O&VF^&]8U6?4=*NGG>6*\Q,Q(@<C$C`
MNN"H^ZP[^IHHH3:V&FT[H]E\;:%IFG:6EW9VJPS27(5BK-C!5B0!G`Y`Z"N$
9HHKU<*VZ=V?6Y5.4\.G)WU84445T'HG_V79V
`
























#End
#BeginMapX

#End