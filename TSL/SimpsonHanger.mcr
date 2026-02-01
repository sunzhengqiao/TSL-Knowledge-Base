#Version 8
#BeginDescription
For inserting Simpson hangers one at a time according to company preferences. 
Requires HangerList.mcr to have been previously run in .dwg.
Double joists and angles only defined for some specific cases.  Adjustable angle hangers not yet done

V4.12_18September2018__Revised BOM data, made tolerant of BCI headers
V4.10_17September2018__Revised to work with hsb_ElementBOM





























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 4
#MinorVersion 12
#KeyWords 
#BeginContents
/*
<>--<>--<>--<>--<>--<>--<>--<>____ Craig Colomb _____<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>

V0.0___Craig Colomb__ 25JULY2007
V4.0__30April2013__Customized for RMLH


Problems? Questions? Comments? Kudos??  cc@hsb-cad.com
© Craig Colomb2007

<>--<>--<>--<>--<>--<>--<>--<>_____  craigcad.us  _____<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>

//######################################################################################
//############################ Documentation #########################################
<insert>
Inserted by user in Model Space, will sort through selection sets of Joists & carrying beams

</insert>

<property name="xx">
"Execution mode" controls whether hanger models are selected by joist type, or simple geometry.
"Web Stiffener" & "Backer Block" turn these accessories on and off.
</ property >

<command name="xx">
"Update Hanger List" runs the associated .dll and updates the local store
</command>

<remark>
Requires HangerList.mcr to be run in the .dwg to create store of Hanger models
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
	String stName = "HangerList.mcr" ;
	GenBeam gb[0] ;
	Entity entList[0] ;		
	Point3d pts[0] ;
	int ints[0] ;
	double ds[0] ;
	String sts[0] ;		
	TslInst tsl ;
	tsl.dbCreate( stName, _XW, _YW, gb, entList, pts, ints, ds, sts ) ;		
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
	String stName = "HangerList.mcr" ;
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

String stArRunMode[] = { "Standard", "Manual" } ;
PropString psRunMode ( 0, stArRunMode, "Execution Mode" ) ;
PropDouble pdNum ( 6, -1, "Posnum" ) ; pdNum.setFormat( _kNoUnit ) ;
PropString psNotes ( 1, "", T("General notes") ) ;

String stYN[] = {"No", "Yes" } ;
PropString psWeb( 2, stYN, "Web Stiffener" ) ;
String stBacker[] = { "None", "Single", "Double" } ;
PropString psBacker( 10, stBacker, "Backer Block" ) ;
PropInt piColor( 0, 6, "Hanger Color"  ) ;
if ( piColor < -1 || piColor > 256 ) piColor.set(6) ;
String stTslName = scriptName() ;

if ( _bOnInsert ) 
{		
	if ( insertCycleCount() > 1 )  eraseInstance(); 
	
	Beam bmJoists[0] ;
	PrEntity ssEJ("Select Joists, all must be parallel", Beam());
	if (ssEJ.go()) {
   		bmJoists = ssEJ.beamSet();
     }

	Beam bmHeader[0] ;
	PrEntity ssEH("Select Carrying Beams", Beam());
	if (ssEH.go()) {
   		bmHeader = ssEH.beamSet();
     }


	TslInst tslSlave  ;

	
	Element elLst[0] ;
	double dLst[0] ;
	int iLst[0] ;
	Point3d ptLst[0] ;
	String stLst[0] ;
	
	String stAssigned;
	
	//__Sort and order selected Joist beams
	Vector3d vPerp = bmJoists[0].vecX().crossProduct( _ZW )  ;
	bmJoists = vPerp.filterBeamsPerpendicularSort( bmJoists ) ;
	int iNumJoists = bmJoists.length() ;
	
	//__Extract doubles, triples, quads
	for ( int i=0; i < iNumJoists ; i++ ) 
	{	
			
		Beam bmJoist = bmJoists[i] ;
		Beam bmSisters[0] ;	
		int iIsLast = FALSE ;
		if ( i == iNumJoists - 1) iIsLast = TRUE ;		 
		
		double dJoistW = bmJoist.dD( vPerp ) ;
		if (! iIsLast )
		{
			Beam bmNext = bmJoists[ i+1 ];
			Vector3d vCenters = bmNext.ptCen() - bmJoist.ptCen() ;
			double dDist = vCenters.dotProduct( vPerp ) ;
			int iSafe = 0 ;
			while ( dDist < dJoistW + U(.25))
			{
				bmSisters.append( bmNext  ) ;				
				i ++ ;
				if ( i == iNumJoists - 1) break;
				Beam bmLast = bmNext ; 
				bmNext = bmJoists[ i+1 ] ;
				vCenters = bmNext.ptCen() - bmLast.ptCen() ;
				dDist = vCenters.dotProduct( vPerp ) ;
				iSafe ++ ;
				if ( iSafe > 4) 
				{
					reportMessage( "\nSafety broke sorting loop" ) ;
					break;
				}
			}
		}
		
						
		for ( int j = 0; j < bmHeader.length(); j++ ) {
			
			if ( bmJoist.hasTConnection( bmHeader[j], U(5), 1 ) ) {
				
				Beam bmAr[] = {bmJoist, bmHeader[j] } ;
				if ( bmSisters.length() > 0 ) bmAr.append( bmSisters ) ;
				tslSlave.dbCreate( stTslName, _XW, _YW, bmAr, elLst, ptLst, iLst, dLst, stLst ) ;
			}
		}
	}
		
return ;
}	
//######################################################################################
//#############################__End Insertion Routine_###################################

	//__Safety for some beams deleted
if( _GenBeam.length() < 2 )
{
	reportMessage( "\nSimpson Hanger self-erasing not enough beams");
	reportMessage("\n_GenBeam.length() = " + _GenBeam.length() ) ;
	eraseInstance();
	return;
}

if ( _Beam.length() == 0 )
{
	for (int i=0; i<_GenBeam.length(); i++)
	{
		Beam bm = (Beam) _GenBeam[i];
		_Beam.append(bm);
	}
}
	

//__Convert T-type predefines _X0, _Z1, _Plf, _Pt0, _Pt1, _Pt2, _Pt3, _Pt4
Vector3d vX = _X0 ;//_Beam0.vecX() ;
Line lnBm0 ( _Beam0.ptCen(), vX ) ;
Line lnBm1 ( _Beam1.ptCen(), _Beam1.vecX() ) ;
Point3d ptBmInt = lnBm0.closestPointTo( lnBm1 ) ;

Vector3d vecHead = ptBmInt - _Beam0.ptCen() ;
if ( vecHead.dotProduct( vX ) < 0 ) vX = -vX ;
Vector3d vZ1 = _ZW.crossProduct( _Beam1.vecX() )  ;
if ( vecHead.dotProduct( vZ1 ) < 0 ) vZ1 = -vZ1 ;
Quader qdHeader = _Beam1.quader() ;
Plane _Plf = qdHeader.plFaceD( -vZ1 ) ;
_Plf.vis( 3 ) ;


lnBm0.vis( 4 ) ;
Line ln1, ln2, ln3, ln4 ;
Point3d _Pt1, _Pt2, _Pt3, _Pt4 ;
if( lnBm0.hasIntersection( _Plf) ) 
{
	_Pt0 = lnBm0.intersect( _Plf, 0 ) ;	
	Vector3d vY0 = _Beam0.vecY() ;
	Vector3d vZ0 = _Beam0.vecZ() ;
	Quader qdJoist = _Beam0.quader() ;
	ln1 = qdJoist.lnEdgeD( vY0, vZ0 ) ;
	ln2 = qdJoist.lnEdgeD( vY0, -vZ0 ) ;
	ln3 = qdJoist.lnEdgeD( -vY0, vZ0 ) ;
	ln4 = qdJoist.lnEdgeD( -vY0, -vZ0 ) ;
	_Pt1 = ln1.intersect( _Plf, 0 ) ;
	_Pt2 = ln2.intersect( _Plf, 0 ) ;
	_Pt3 = ln3.intersect( _Plf, 0 ) ;
	_Pt4 = ln4.intersect( _Plf, 0 ) ;
}


//####################_Find Allowable hangers and declare prop__#############################
//######################################################################################
//_____________Sort out Joists from _Beam array
String stExtProf = _Beam0.extrProfile() ;
Beam bmHeader = _Beam1 ;
String stHeaderProf = bmHeader.extrProfile();
String stJoistEP = stExtProf ;
stJoistEP.makeUpper() ;
int iIsIJoist = FALSE ;
if ( stExtProf.find( "TJI",0 ) >= 0 ) iIsIJoist = TRUE ;
if ( stExtProf.find( "BCI",0 ) >= 0 ) iIsIJoist = TRUE ;
//stHeaderProf.makeUpper() ;

Beam bmJoists[0] ;
bmJoists = _Beam0.filterBeamsParallel( _Beam ) ;

for ( int i=0; i<bmJoists.length(); i++ ) 
{		
	String stDB = bmJoists[i].extrProfile().makeUpper() ;
	if( bmJoists[i].extrProfile().makeUpper() != stJoistEP ) psRunMode.set( "Manual" ) ;	
}	



int iNumJoists = bmJoists.length() ;

/*	//__Safety for when no beams exist
if ( iNumJoists == 0 ) {
	reportMessage( "\nSimpson Hanger self-erasing since no joists can be found!");
	eraseInstance();
	return;
}
*/


	
String stArModel[0] ;
String stJointType = "Square" ;
if ( abs( vX.dotProduct( _X1 ) ) > .02 ) stJointType = "Angled" ;

if ( ! vX.isPerpendicularTo(_ZW )) stJointType = "Sloped" ;


pdNum.set(_ThisInst.posnum() ) ;
pdNum.setReadOnly( TRUE ) ;		




//__Need joist dimensions__###################################	
Vector3d vY = _Y0 ;
Vector3d vZ = _Z0 ;
Vector3d vX0Flat = vY.crossProduct(_ZW);


if ( abs( vZ.dotProduct( _ZW ) )< abs( vY.dotProduct( _ZW ) ) ) {
	Vector3d vTemp = vY ;
	vY = vZ ;
	vZ = vTemp ;
}


double dJoistW = _Beam0.dD( vY ) ;
double dJoistH = _Beam0.dD( vZ ) ;
double dHeaderH = bmHeader.dD( vZ ) ;
double dHeaderW = bmHeader.dD( vZ1 ) ;

///__Adjust Joist Width for multiple joists when needed

if( iNumJoists > 1 )
{	
	Point3d ptCenFirst, ptCenLast ;
	double dWidthFirst, dWidthLast ;
			
	for ( int i=0; i<bmJoists.length(); i++)
	{		  
		Beam bm = bmJoists[i] ;
		if ( i==0) 
		{
			ptCenFirst = bm.ptCen() ;
			dWidthFirst = bm.dD(vY ) ;
		}
		else
		{
			ptCenLast = bm.ptCen() ;
			dWidthLast = bm.dD( vY ) ;
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
if ( stJointType == "Sloped" ) stKey = "stSlopedJoist";

if (psRunMode == "Standard" || stJointType == "Sloped" )
//	if( true)
{	
	for ( int i=0; i<mpHangerLibrary.length(); i++ ) 
	{
		Map mpTemp = mpHangerLibrary.getMap( i) ;
		String stMapName = mpHangerLibrary.keyAt( i ) ;
		String stJoistList = mpTemp.getString( stKey ) ;
		if ( stJoistList == "" || stJoistList =="N/A" ) continue;
		stJoistList.makeUpper() ;
		//reportMessage( "\nJoist List = " + stJoistList ) ;

		//__Look for the current joist profile in the list of joists
		int iFind = stJoistList.find( stJoistEP, 0 ) ;
		
		//__Joist not found, current hanger not appropriate
		if ( iFind < 0 ) continue;
		
		//__Joist has been located in current hanger's list
		//__Enable this to enforce automatic Hanger selection
		//if ( psRunMode == "Manual" ) psRunMode.set( "Standard" ) ;

		mpHangers.setMap( stMapName, mpTemp ) ;
		//reportMessage( "\nMap Name = " + stMapName ) ;
		//reportMessage( "\nJoist EP = " + stExtProf ) ;
	}
}

//__Test for available, valid hanger choices
if ( (mpHangers.length() == 0 || psRunMode == "Manual") && stJointType != "Sloped" ) 
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

		//__If hanger dimensions match joist dimension add to list
		double dHangDiff = dHangWidth - dJoistW ;
		if ( 0 <= dHangDiff && dHangDiff < U(.25)  && dJoistH >= dHangHeight ) 
		{
			if ( iIsIJoist && dJoistH < dHangHeight ) continue ;
			mpHangers.setMap( stMapName, mpTemp ) ;
		}
	}
}

//__At this point mpHangers should contain valid hanger descriptions.
//__Write all possible models to String array and declare model property.
if ( mpHangers.length() == 0 ) mpHangers.setInt("No Hardware Available", 0 );

for ( int i=0; i<mpHangers.length(); i++)
{
	stArModel.append( mpHangers.keyAt( i ) );
}

//__Declare properties (Execution type already done, hanger Model, End Gap )__####################
PropString pstModel( 3, stArModel, "Hanger Model" ) ;
PropDouble pdEndGap( 2, 0, "Joist End Gap" ) ;

			//__Set End gap for Beam
Cut ct( _Pt0 - vX0Flat * pdEndGap, vX0Flat ) ;
Cut ctFlush ( _Pt0, vZ1 ) ;

for ( int i=0; i<iNumJoists; i++ )
{
	bmJoists[i].addTool( ct, 1 ) ;
}

if (mpHangers.hasInt("No Hardware Available") ) return;

//__Construct needed  hanger width for singles and doubles
//__dJoistW is already adjusted for doubles
double dHangW = dJoistW ;

//__Half dimensions are commonly used in construction
double dJoistHW = dJoistW / 2 ;
double dJoistHH = dJoistH / 2 ;


//__Available hangers array should be filled by now
if ( stArModel.length() == 0 ) 
{		
	for ( int i=0; i<bmJoists.length() ; i++)
	{
		Cut ct( _Pt0, vX ) ;
		bmJoists[i].addTool( ct) ;
	}
	reportError( "\nNo available hangers for this situation. ;\nJoist Width = " + dJoistW + " Joist Height = " + dJoistH) ;
}		

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
String stFaceNailsMin = mpHanger.getString( "stFaceNailsMin" ) ;
String stTopNailsMin = mpHanger.getString( "stTopNailsMin" ) ;
String stJoistNailsMin = mpHanger.getString( "stJoistNailsMin" ) ;
String stFaceNails = mpHanger.getString( "stFaceNails" ) ;
String stTopNails = mpHanger.getString( "stTopNails" ) ;
String stJoistNails = mpHanger.getString( "stJoistNails" ) ;



PropString psFaceNails( 4, "", "Face Nails"  ) ;
PropString psTopNails( 5, "", "Top Nails"  ) ;
PropString psJoistNails( 6, "", "Joist Nails"  ) ;
PropString psFaceNailsMin( 7, "", "Face Nails Min"  ) ;
PropString psTopNailsMin( 8, "", "Top Nails Min"  ) ;
PropString psJoistNailsMin( 9, "", "Joist Nails Min"  ) ;

psFaceNails.set( stFaceNails) ;
psJoistNails.set( stJoistNails );
psTopNails.set( stTopNails );
psFaceNailsMin.set( stFaceNailsMin) ;
psJoistNailsMin.set( stJoistNailsMin );
psTopNailsMin.set( stTopNailsMin );

//_________Set WebStiffener from auto Props
if ( psRunMode == "Standard") 
{
	if ( stWebStiff.find( "Y", 0 ) >= 0 ) psWeb.set( "Yes" ) ; else psWeb.set( "No" ) ;
	//if (stExtProf.find( "TJI", 0 ) <0 ) psWeb.set( "No" ) ;
	psWeb.setReadOnly( 1) ;
	
} else  psWeb.setReadOnly( 0) ;

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
		ptCenters.append( bmJoists[i].ptCen() ) ;
	}		
	ptCenter.setToAverage( ptCenters ) ;
}

ptCenter.vis(4);
_Plf.vis(2);
Line lnCenter ( ptCenter, vX ) ;
lnCenter.vis(2);
ptCenter = lnCenter.intersect( _Plf, 0 ) ;
ptCenter.vis(1) ;
double dThick = U(.08) ;
dBotY = dJoistW + dThick * 2 ;//_identical parameter for all Simpson hangers
	
vX.vis( _Pt0, 3 ) ;
vY.vis(_Pt0, 4 ) ;
vZ.vis( _Pt0, 4 ) ;

//__Reference points
ptBot = ptCenter - vZ * dJoistHH  ;
ptTop = ptCenter + vZ * dJoistHH  ;
ptTop.vis( 12 ) ;
ptCenter.vis(2);
Plane pnBot( ptBot, vZ ) ;

CoordSys csMirrorLR ;
csMirrorLR.setToMirroring( Plane(ptCenter, vY ) ) ; 

//#######################__Insert model parameters here//#########################

//__Save Model name for Bomlink
_Map.setString("stPartNumber", pstModel);

//__All Model overrides need to set dBotX, dTTabX,dTTabY, dFTabY, dFTabZ
//__All Model overrides need to define plFTab, plSide

if ( pstModel.find( "IUS", 0 ) >= 0 )
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
	plFace.vis( 2 ) ;
	
	plSide.addVertex( ptBot) ;
	ptNext = ptBot - vX * dBotX ; plSide.addVertex( ptNext ) ;
	ptNext = ptNext + vZ * U( 1.375) ; plSide.addVertex( ptNext ) ;
	ptNext = ptNext + vX * U(1) + vZ * U(1.5) ; plSide.addVertex( ptNext ) ;
	ptNext = ptNext + vZ * U(1.5) ;plSide.addVertex( ptNext ) ;
	ptNext = ptNext + vX * U(.25) + vZ * U(.25) ; plSide.addVertex( ptNext ) ;
	ptNext = ptBot + vZ * dHangerH - vX * U(.75) ; plSide.addVertex( ptNext ) ;
	ptNext = ptBot + vZ * dHangerH ; plSide.addVertex( ptNext ) ;
	plSide.addVertex( ptBot ) ;
	plSide.vis( 3 ) ;
}

String stHUCQ = "HUCQ1.81/11-SDS--HUCQ1.81/9-SDS--HUCQ410-SDS--HUCQ412-SDS--HUC310-2--HUC310--HUC210-2--HUC28-2" ;
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
	ptSide.vis(2) ;
	
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
	
	if ( pdEndGap == 0 ) pdEndGap.set( U(.1875 ) ) ;	
}

if ( pstModel.find( "LSSU", 0 ) >= 0 )
{
	double dSlope = vX0Flat.angleTo(_X0);
	double dSlopeAdjust = cos(dSlope);
	double dFaceH = dJoistH / dSlopeAdjust;
	
	double dSkew = vX0Flat.angleTo(vZ1);
	Plane pnJoistSide (ptCenter + vY * dJoistW/2, vY);
	Vector3d vLeft = _ZW.crossProduct(vZ1);
	int iShortIsLeft = true;
	
	if ( vX.dotProduct(vLeft) > 0 ) 
	{
		pnJoistSide.transformBy( - vY * dJoistW);
		iShortIsLeft = false;
	}
	
	Point3d ptJoistShort = pnJoistSide.intersect(_Plf).ptOrg();
	ptJoistShort.vis(1);
	vLeft.vis(ptJoistShort, 3);
			
	Plane pnJoistEnd(ptJoistShort, vX0Flat);
	ptCenter = lnBm0.intersect(pnJoistEnd, -pdEndGap);
	
	ct = Cut(ptCenter, vX0Flat);
	_Beam0.addTool(ct);
	
	vX0Flat.vis(ptCenter, 2);
	
	//__Vertical end plate
	Point3d ptBase = ptCenter - _ZW * dFaceH/2;
	PLine plFacePlate(ptBase + vY * dJoistW/2, ptBase + vY * dJoistW/2 + _ZW * U(8.5));
	plFacePlate.addVertex(ptBase - vY * dJoistW/2 + _ZW * U(8.5, "inch"));
	plFacePlate.addVertex(ptBase - vY * dJoistW/2);
	plFacePlate.addVertex(ptBase + vY * dJoistW/2);
	bdHanger += Body(plFacePlate, vX0Flat * U(.1), 1);
	
	//__Seat Plate
	PLine plSeat( ptBase + vY * dJoistW/2, ptBase + vY * dJoistW/2 - vX * U(3.5) );
	plSeat.addVertex(ptBase - vY * dJoistW/2 - vX * U(3.5));
	plSeat.addVertex(ptBase - vY * dJoistW/2);
	plSeat.addVertex( ptBase + vY * dJoistW/2 );
	bdHanger += Body(plSeat, - vZ * U(.1), 1 );
	
	//__ Seat Wings
	Point3d ptWing = ptBase + vY * dJoistW/1.999 - vZ * U(.1) ;
	PLine plWing(ptWing, ptWing - vX * U(3.5), ptWing - vX * U(3.5) + vZ * U(1.8));
	plWing.addVertex(ptWing - vX * U(1.9) + vZ * U(1.8));
	plWing.addVertex(ptWing);
	Body bdWing ( plWing, vY * U(.1), 1);
	
	bdHanger.addPart( bdWing );
	bdWing.transformBy(csMirrorLR);
	bdHanger += bdWing;
	
	//__Top Wings
	ptWing += _ZW * U(8.5);
	PLine plTopWing(ptWing, ptWing - vX0Flat * U(1.75), ptWing - vX0Flat * U(1.75) - _ZW * U(1.75));
	plTopWing.addVertex(ptWing - _ZW * U(2.8));
	plTopWing.addVertex(ptWing);
	Body bdTopWing(plTopWing, vY * U(.1), 1);
	bdHanger += bdTopWing;
	bdTopWing.transformBy(csMirrorLR);
	bdHanger += bdTopWing;
	
	//__Flat Header Plate
	Point3d ptHPBase = ptBase + vY * dJoistW/2.01 - vZ * U(.1) ;
	Vector3d vHeaderSlope = vLeft.rotateBy(30, vZ1);
	
	if ( ! iShortIsLeft )
	{
		ptHPBase = ptBase - vY * dJoistW/2.01 - vZ * U(.1) ; 
		vHeaderSlope = -vLeft.rotateBy(30, -vZ1);
	}
	
	PLine plHeaderPlate(ptHPBase, ptHPBase + _ZW * U(5.7), ptHPBase + _ZW * U(5.7) + vHeaderSlope * U(2));
	plHeaderPlate.addVertex(ptHPBase + vHeaderSlope * U(2));
	plHeaderPlate.addVertex(ptHPBase);
	bdHanger += Body(plHeaderPlate, -vZ1 * U(.1), 1);
	
	//__Skewed Header Plate
	ptHPBase = ptBase - vY * dJoistW/2.001 ;
	vHeaderSlope = vX0Flat.rotateBy(30, -vY);
	
	if ( ! iShortIsLeft )
	{
		ptHPBase = ptBase + vY * dJoistW/2.001 ; 			
	}
	PLine plSlopePlate(ptHPBase, Line(ptHPBase, vHeaderSlope).intersect(_Plf, 0));
	Point3d ptSlopePlateTop = ptHPBase + _ZW * U(5.7);
	plSlopePlate.addVertex(Line (ptSlopePlateTop, vHeaderSlope).intersect(_Plf,0));
	plSlopePlate.addVertex(ptSlopePlateTop);
	plSlopePlate.addVertex(ptHPBase);
	Body bdSlopePlate(plSlopePlate, - vY * U(.1), 1);
	bdHanger += bdSlopePlate;
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
	ptSide = ptTop  ;ptSide.vis( 3 ) ;
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
	plSide.vis( 2 ) ;
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
	ptSide.vis(2) ;
	
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

CoordSys csMirrorUD ;
csMirrorUD.setToMirroring( Plane( ptCenter, vZ ) ) ;
Point3d ptShort ;

if( stType == "S" && dBotX == 0)
{
	Quader qdJoist ;
	Point3d ptCorners[4] ;
	Point3d ptQCen = bmJoists[0].ptCen() ;
	if ( bmJoists.length() == 1 ) 
	{
		qdJoist = bmJoists[0].quader() ;
		ptCorners[0] = _Pt1 ;
		ptCorners[1] = _Pt2 ;
		ptCorners[2] = _Pt3 ;
		ptCorners[3] = _Pt4 ;		
	}
		
	if ( bmJoists.length() == 2 ) //__in case of doubled angled joists, build quader with dimension of both beams.
	{
		double dQW = bmJoists[0].dD( vY ) + bmJoists[1].dD(vY)  ;
		double dQH =  bmJoists[0].dD( vZ ) ;
		Point3d ptBeamCenters[] = { bmJoists[0].ptCen(), bmJoists[1].ptCen() } ;			
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
	ptShort.vis(12) ;
	
	//___Construct cut point for joist with tolerance & hanger space
	Point3d ptCut = ptShort - vX * ( dThick + pdEndGap ) ;		
	Cut ctJoist ( ptCut, vX ) ;
	for( int i=0; i<bmJoists.length(); i++)
	{
		bmJoists[i].addTool( ctJoist, _kStretchOnToolChange ) ;
	}
	
	//__Get a reference point on the cut face
	Line lnCenter ( ptJoistCen, vX ) ;
	Point3d ptSCenter = lnCenter.closestPointTo( ptShort ) ;
	Point3d ptSBot = ptSCenter - vZ * dJoistH/2  ;
			
	Body bd ( ptSCenter, vX, vY, vZ, dThick, dBotY, dJoistH, -1, 0, 0 ) ;
	bdHanger += bd ;
	bdHanger.vis(3) ;
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
	Vector3d vInY = _X1 ;
	if ( vX.dotProduct( vInY ) > 0 ) vInY = -vInY ;
	Vector3d vSY = vY ;
	if ( vY.dotProduct( vInY) < 0 ) vSY = -vSY ;		
	ptNext = pnBot.closestPointTo( ptSBot + vSY * dJoistW / 2  )  ;
	vSY.vis( ptNext, 2 ) ;
	plTab = PLine( ptNext, ptNext + vInY * U(2.5) + vZ * U(2.5), 
	ptNext + vInY * U(2.5) + vZ * ( dJoistH - U(1)), ptNext + vZ * ( dJoistH - U(2)));		
	plTab.addVertex( ptNext ) ;		
	plTab.projectPointsToPlane( _Plf, vZ1 ) ;
	bd = Body( plTab, -vZ1 * dThick ) ;
	bdHanger += bd ;
	
	//__Construct outer face tab
	ptNext = ptNext - vSY * dJoistW   ;
	Line lnProject ( ptNext, vX ) ;
	Point3d ptFaceBot = lnProject.intersect( _Plf, 0 ) ;
	plTab = PLine( ptNext, ptFaceBot + _ZW * U(2.5), ptFaceBot + _ZW * ( dJoistH - U(1)),
	ptNext + _ZW * (dJoistH - U(2) ) ) ;
	plTab.addVertex( ptNext ) ;
	bd = Body( plTab, -vSY * dThick ) ;
	bdHanger += bd ;
}
else
{
	if ( stJointType != "Sloped")
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
	}
}



//____________________Display Hanger
Display dp (piColor) ; 
if ( psRunMode == "Manual" ) dp.color( 12 ) ;
dp.draw( bdHanger ) ;




//##########################__End Construct Hanger body__##########################
//################################################################################

//##########################################################################
//################____Create Web Stiffener if requested__#########################
if ( stType == "S" )
{
	ptTop = ptShort.projectPoint( Plane(ptCenter, vY ), 0 ) - vX * (pdEndGap +  dThick) ;		
}

ptTop.vis(12) ;

if ( psWeb == "Yes" )//&& stExtrStiff != "" ) 
{				
	//________Set Filler length by Joist height
	double dWSLength = U(6.625);
	if ( dJoistH > 10 ) dWSLength = U(9) ;
	
	//_________Find WSHeight by simple lookup on expected ExtrusionProfiles
	double dWSHeight = U(9.4375);
	if ( stExtProf.find("11.875", 0) >=0 ) dWSHeight = U(11.8125);
	if ( stExtProf.find("14", 0) >=0 ) dWSHeight = U(13.9375);
	if ( stExtProf.find("16", 0) >=0 ) dWSHeight = U(15.9375);
	if ( stExtProf.find("18", 0) >=0 ) dWSHeight = U(17.9375);
	if ( stExtProf.find("20", 0) >=0 ) dWSHeight = U(19.9375);
	
	//_________Find WSThick by simple lookup on expected Extrusion Profiles
	double dWSThick = U(.5);
	if ( stExtProf.find("210", 0) >= 0 ) dWSThick = U(.75);
	if ( stExtProf.find("230", 0) >= 0 || stExtProf.find("360", 0) >=0 ) dWSThick = U(1);
	if ( stExtProf.find("560", 0) >= 0 ) dWSThick = U(1.5);
	
	//_________Calculate reference point
	Point3d ptFillerL = ptTop - vZ * U(1.5 ) + vY * dJoistHW;
	Point3d ptFillerR = ptFillerL - vY * dJoistW ;
	Point3d ptFillCenL = ptFillerL - vX * dWSHeight/2 - vY * dWSThick/2 - vZ * dWSLength;
	Point3d ptFillCenR = ptFillCenL ;
	ptFillCenR.transformBy( csMirrorLR ) ;
	
	//_________Create Beams if not in Map
	Entity entL = _Map.getEntity( "bmFillL") ;
	Beam bmL = (Beam)entL;
	Entity entR = _Map.getEntity( "bmFillR") ;
	Beam bmR = (Beam)entR;
	
	if (! bmL.bIsValid() )
	{			
		bmL.dbCreate( ptFillerL, vZ, vY, vX, dWSLength, dWSThick, dWSHeight, -1, -1, -1 ) ;
		_Map.setEntity("bmFillL", bmL ) ;
		bmL.assignToGroups( _Beam0 );
		bmL.setColor( 32 ) ;
		//bmL.setExtrProfile( stExtrStiff) ;
		
		
		bmR.dbCreate( ptFillerR, vZ, vY, vX, dWSLength, dWSThick, dWSHeight, -1, 1, -1 ) ;
		_Map.setEntity("bmFillR", bmR ) ;
		bmR.assignToGroups( _Beam0 );
		bmR.setColor( 32 ) ;
		//bmR.setExtrProfile( stExtrStiff) ;			
	} 
	
	//______Reposition beams whenever script runs,
	//only to prevent accidental user edits.
	if ( bmL.bIsValid() )
	{
		CoordSys csL( ptFillCenL, vZ, vY, vX ) ;
		CoordSys csR( ptFillCenR, vZ, vY, vX ) ;
		bmL.setCoordSys( csL ) ;
		bmR.setCoordSys( csR ) ;
		Cut ctTop( ptFillerL, vZ ) ;
		Cut ctBot ( ptFillerL - vZ * dWSLength, -vZ ) ;
		bmL.addTool( ctTop, _kStretchOnToolChange ) ;
		bmL.addTool( ctBot, _kStretchOnToolChange ) ;
		bmR.addTool( ctTop, _kStretchOnToolChange ) ;
		bmR.addTool( ctBot, _kStretchOnToolChange ) ;
		bmL.addTool(ct);
		bmR.addTool(ct);
		//bmL.setExtrProfile( stExtrStiff) ;
		//bmR.setExtrProfile( stExtrStiff) ;
	}
			
}	

//____________Erase beams when parameters change.
if ( (psWeb == "No" ) )
{
	Entity ent ;
	Beam bm ;
	ent = _Map.getEntity( "bmFillL" ) ;
	bm = (Beam)ent ;
	if ( bm.bIsValid() ) bm.dbErase() ;
	_Map.removeAt("bmFillL", FALSE ) ;
	
	ent = _Map.getEntity( "bmFillR") ;
	bm = (Beam)ent ;
	if( bm.bIsValid() ) bm.dbErase() ; 
	_Map.removeAt("bmFillR", FALSE ) ;
	
}


//#########################__End Web Stiffener__############################
//##########################################################################



//################____Create Backer Block if requested__#########################
//##########################################################################

/*
if ( psBacker != "None" && stExtrBacker != "" ) 
{				
	//________Set Backer length top iLevel Min.
	double dBackerLength = U(12);
	
	//_______ Set Mirror CS to aligne with header
	csMirrorLR.setToMirroring( Plane( bmHeader.ptCen(), vX) ) ;
	
	//_________Calculate reference point
	Point3d ptBackerF = _Pt0 - vZ * (dJoistH/2 - U(1.375) ) ;
	ptBackerF.vis(3) ;
	Point3d ptBackerB = ptBackerF + vX * dHeaderW ;
	ptBackerB.vis(2) ;
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
		bmF.assignToGroups( _Beam0 );
		bmF.setColor( 32 ) ;
		bmF.setExtrProfile( stExtrBacker) ;

	} 
	
	if ( psBacker == "Double" && (! bmB.bIsValid()) ) 
	{
		bmB.dbCreate( ptBackerB, vY, -vX, vZ, dBackerLength, dBackerThick, dBackerHeight, 0, 1, 1 ) ;
		_Map.setEntity("bmBackB", bmB ) ;
		bmB.assignToGroups( _Beam0 );
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
*/


//#########################__End Backer Block__############################
//##########################################################################

//__Save out data for labeling
_Map.setString( "stModel", pstModel ) ;
_Map.setPoint3d( "ptCenter", _Pt0 ) ;
_Map.setString( "stNotes", psNotes) ;

_Map.setString( "stJoistNails", psJoistNails ) ;
_Map.setString( "stFaceNails", psFaceNails ) ;
_Map.setString( "stTopNails", psTopNails ) ;
_Map.setString( "stJoistNailsMin", psJoistNailsMin ) ;
_Map.setString( "stFaceNailsMin", psFaceNailsMin ) ;
_Map.setString( "stTopNailsMin", psTopNailsMin ) ;

//################################
_Map.setString( "stWeb", psWeb ) ;


if ( pstModel == "" ) pstModel.set( stArModel[0] ) ;
String stFNail = (String)psFaceNails ;
String stTNail = (String)psTopNails ;
String stJNail  = (String)psJoistNails ;
String stW = (String) psWeb;
String stB = (String)psBacker ;
String stNote = (String)psNotes;
String stModel = (String)pstModel ;
String stCompare = stModel ;
stCompare += stNote;
stCompare += stW ;
stCompare += stB ;
stCompare += stJNail;
stCompare += stFNail;
stCompare += stTNail;
setCompareKey( stCompare  ) ;

reportMessage( "\n" + stCompare ) ;

_ThisInst.assignToGroups( _Beam0 ) ;

/*
Declare Hardware data for Excel
Format is -->Hardware name(String strType, String strDescription, String strModel,
 double dLen, double dDiam, int nNumber, String strMaterial, String strNotes);

*/
Group gpBmAll[] = _Beam0.groups() ;
String stGroup = gpBmAll[0].name() ;

//Hardware hd( _Beam0.posnum(), stModel, stGroup, _ThisInst.posnum(), 1, 1, stJNail, stFNail + ", " + stTNail ) ;

//reportMessage( "\nPosnum = " + _ThisInst.posnum() ) ;

// dxaoutput for hsbExcel
dxaout("Name",stModel);// description
dxaout("Width", U(2)/U(1,"mm"));// width
dxaout("Length", U(10)/U(1,"mm"));// length
dxaout("Height", U(4)/U(1,"mm"));// length

dxaout("Group",stGroup);// group
dxaout("Label", stFNail );    
dxaout("Sublabel", stJNail);                
dxaout("Info", stTNail );  

model(stModel);
material("steel");  

if ( bdHanger.volume() == 0 )
{
	PLine plHandle ;
	plHandle.createCircle( _Pt0, _ZW, U(3) ) ;
	dp.draw( plHandle ) ;
	dp.color( 3 ) ;
	plHandle.createCircle( _Pt0, _ZW, U(4) ) ;
	dp.draw( plHandle ) ;
}
	

Map mpTslBomBucket, mpTslBom;
mpTslBom.setString("Name", "Joist Hanger");
mpTslBom.setString("Type", stModel);
mpTslBomBucket.setMap("TSLBOM", mpTslBom);
_Map.setMap("TSLBOM[]", mpTslBomBucket);

































#End
#BeginThumbnail




































#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="mpIDESettings">
    <dbl nm="PREVIEWTEXTHEIGHT" ut="N" vl="1" />
  </lst>
  <lst nm="mpTslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End