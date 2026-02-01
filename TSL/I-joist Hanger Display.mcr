#Version 8
#BeginDescription
For inserting graphical representations of different hangers, and offering manual data entry to pass to export.
Minimal errror checking, hanger dimensions for display only and not always exactly matching actual hardware.
Export to Access or Excell. In Excel, Code entries are mapped to "Type" field and Model is mapped to "Model"

V0.0___Craig Colomb__ 24MAY2007
V0.5__25MAY2007___Script Functional, testing required
V0.6__26MAY2007___Added Map data to be used by HsbBOM. Changed to show insert dialog
V1.0__29MAY2007__Fixed BOM bug, added compare key for correct numbering.  ALL FIELDS MUST BE IDENTICAL
V1.1__27OCT2010__Add the TSL to the correct group so it will be export to the dBase.
V1.2__10JAN2011_Changed the TSL map to output to Name rather than Info - csawjani@itw-industry.com
V1.3__10JAN2011_Add the Hanger Key for the new data base
V1.4__22MAY2011_Add Offset Property for the text display
V1.6__28APRIL2015_Add context menu to change the reference direction of the hanger
V1.7__28APRIL2015_Added vz view direction for text
#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 8
#KeyWords 
#BeginContents
Unit( 1, "mm" );

String stArType[] = { "Heavy Universal", "Mini Hanger", "Face Hanger", "Top Fix"  } ;
PropString stType ( 0, stArType, "Hanger Type", 2 ) ;

PropString stCode ( 1, "", "Hanger Code" ) ;
PropString stModel (2, "", "Hanger Model" ) ;
PropInt iPosNum ( 0, 0, "PosNum" ) ;
iPosNum.set( _ThisInst.posnum()) ;
iPosNum.setReadOnly( 1 ) ;

String strYesNo[]= {T("No"), T("Yes")};
PropString strDisplay (3, strYesNo, T("Display Model"), 0);
int bDisplay  = strDisplay == T("Yes");

PropString sDimStyle(4,_DimStyles,T("|Dimstyle|"));

PropDouble dOffset(0, 0, T("Text Offset"));

if ( _bOnInsert ) {
	showDialogOnce();
	 _Beam.append( getBeam() );
	 _Beam.append( getBeam() );	
}

String strChangeReferenceDirection = T("|Change orientation|");
String strChangeReferenceDirectionKey = "OrientationChanged";
addRecalcTrigger(_kContext, strChangeReferenceDirection );

if (_bOnRecalc && _kExecuteKey==strChangeReferenceDirection )
{
	int referenceChanged=_Map.getInt(strChangeReferenceDirectionKey );
	_Map.setInt(strChangeReferenceDirectionKey, referenceChanged ? false : true);
}

// Construct coord sys for script from geometry
Vector3d vX = _X0 ;
Vector3d vY = _Y0 ;
Vector3d vZ = _Z0 ;

if ( vZ.dotProduct( _ZW )  <  vY.dotProduct( _ZW )  ) {

	Vector3d v = vY ;
	vY = vZ ;
	vZ = v ;
}

int bReferenceChanged=_Map.getInt(strChangeReferenceDirectionKey) ;
if(bReferenceChanged)
{
	vY = _Y0 ;
	vZ = _Z0 ;
}

vX.vis(_Pt0, 4) ;
vY.vis(_Pt0, 4) ;
vZ.vis(_Pt0, 4) ;

//--- Uncomment to stretch Male to connection--*************************************
//Cut ct( _Pt0, vX ) ;
//_Beam0.addTool( ct, 1 ) ;

//Get some dimensions from beams
double dMW = _Beam0.dD(vY) ;
double dMH = _Beam0.dD(vZ) ;
double dMF = _Beam1.dD(vX) ;


Display dp( 154 ) ;

if ( stType == "Heavy Universal" ) {
	Point3d ptSt = _Pt0 - vZ * ( dMH / 2 ) ;
	Body bd( ptSt, vX, vY, vZ, U(46), dMW +2, U(1), -1, 0, -1 ) ;
	Body bdSide( ptSt + vY * dMW / 2, vX, vY, vZ, U(46), U(1), dMH + 1, -1, 1, 1 ) ;
	Body bdFace( ptSt + vY * dMW / 2, vX, vY, vZ, U(1), U(45), dMH + 1, -1, 1, 1 ) ;
	Body bdTop( ptSt + vY * dMW / 2 + vZ * (dMH + 1) + vX * dMF/2, vX, vY, vZ, dMF + U(2), U(45), 1, 0, 1,1 ) ;
	
	Body bdSide1, bdFace1, bdFace2, bdFace3, bdTop1 ;
	bdSide1.copyPart( bdSide ) ;
	bdFace1.copyPart( bdFace ) ;
	bdFace2.copyPart( bdFace ) ;
	bdFace3.copyPart( bdFace ) ;
	bdTop1.copyPart( bdTop ) ;
	
	bdSide1.transformBy( -vY * (dMW + 1) ) ;
	bdFace1.transformBy( -vY *  (dMW + U(46)  ) ) ;
	bdTop1.transformBy( -vY * (dMW + U( 46) ) ) ;
	bdFace2.transformBy( -vY *  (dMW + U(46) ) + vX * (dMF + 1 ) ) ;
	bdFace3.transformBy(  vX * (dMF + 1 ) ) ;
	
	bd.addPart( bdSide ) ;
	bd.addPart( bdSide1) ;
	bd.addPart( bdFace ) ;
	bd.addPart( bdFace1 ) ;
	bd.addPart( bdTop ) ;
	bd.addPart( bdTop1 ) ;
	bd.addPart( bdFace2 ) ;
	bd.addPart( bdFace3 ) ;
	
	dp.draw( bd) ;
	
}

if ( stType == "Mini Hanger" ) {
	Point3d ptSt = _Pt0 - vZ * ( dMH / 2 ) ;
	ptSt.vis(4) ;
	Body bd( ptSt, vX, vY, vZ, U(46), dMW +2, U(1), -1, 0, -1 ) ;
	Body bdSide( ptSt + vY * dMW / 2, vX, vY, vZ, U(46), U(1), U(55), -1, 1, 1 ) ;
	Body bdFace( ptSt + vY * dMW / 2, vX, vY, vZ, U(1), U(45), U(55), -1, 1, 1 ) ;
	
	Body bdSide1, bdFace1 ;
	bdSide1.copyPart( bdSide ) ;
	bdFace1.copyPart( bdFace ) ;
	
	bdSide1.transformBy( -vY * (dMW + U(1) ) );
	bdFace1.transformBy(  -vY * (dMW + U(45) ) );
	
	bd.addPart( bdSide ) ;
	bd.addPart( bdFace ) ;
	bd.addPart( bdSide1 ) ;
	bd.addPart( bdFace1 ) ;
	
	dp.draw( bd ) ;	
}


if ( stType == "Face Hanger" ) {
	Point3d ptSt = _Pt0 - vZ * ( dMH / 2 ) ;
	Body bd( ptSt, vX, vY, vZ, U(75), dMW +2, U(1), -1, 0, -1 ) ;
	ptSt =  ptSt + vY * ( dMW/2 )  ; 
	PLine plSide( vY ) ;
	Point3d pt  = ptSt ;
	
	plSide.addVertex( ptSt ) ;
	
	pt = pt + vZ * dMH  ;
	plSide.addVertex( pt ) ;
	pt = pt - vX * U(25)  ;
	plSide.addVertex( pt ) ;
	pt = pt -vZ * dMH * .666  ;
	plSide.addVertex( pt ) ;
	pt =pt -vX * 50 - vZ * U(50) ;
	plSide.addVertex( pt ) ;
	pt = pt -vZ * (dMH * .333 - U(50) ) ;
	plSide.addVertex( pt ) ;
	plSide.addVertex( ptSt ) ;
	
	Body bdSide ( plSide, vY ) ;
	Body bdSide1;
	bdSide1.copyPart( bdSide ) ;
	bdSide1.transformBy( -vY * (dMW + U(1) ) ) ;
	
	PLine plFace( vX ) ;
	ptSt  = ptSt + vZ * dMH ;
	plFace.addVertex( ptSt ) ;
	pt = ptSt + vY * U(50) ;
	plFace.addVertex( pt ) ;
	pt = pt - vZ * (dMH * .666 ) ;
	plFace.addVertex( pt ) ;
	pt = pt - vY * U(50) - vZ * U(25) ;
	plFace.addVertex( pt ) ;
	plFace.addVertex( ptSt ) ;
	Body bdFace( plFace, -vX ) ;
	
	Body bdFace1 ;
	bdFace1.copyPart( bdFace ) ;
	CoordSys cs ;
	cs.setToMirroring( Plane( _Pt0, vY ) ) ;
	bdFace1.transformBy( cs ) ;
	 
	bd.addPart ( bdSide ) ;
	bd.addPart ( bdSide1 ) ;
	bd.addPart ( bdFace ) ;
	bd.addPart ( bdFace1 ) ;
	
	dp.draw( bd ) ;
	
		
}

if ( stType == "Top Fix" ) {
	
	Point3d ptSt = _Pt0 - vZ * ( dMH / 2 ) ;
	Body bd( ptSt, vX, vY, vZ, U(75), dMW +2, U(1), -1, 0, -1 ) ;
	
	ptSt =  ptSt + vY * ( dMW/2 )  ; 
	
	PLine plSide( vY ) ;
	Point3d pt  = ptSt ;	
	
	pt = pt + vZ * dMH ;
	plSide.addVertex( pt ) ;
	pt = pt - vX * U(35) - vZ * U(35) ;
	plSide.addVertex( pt ) ;
	pt = pt - vZ * dMH / 2 ;
	plSide.addVertex( pt ) ;
	pt = pt - vX * U(35) - vZ * U(35) ; 
	plSide.addVertex( pt ) ;
	pt = pt - vZ * ( dMH / 2 - U(70) ) ;
	plSide.addVertex( pt ) ;
	plSide.addVertex( ptSt ) ;
	
	Body bdSide( plSide, vY ) ;
	
	ptSt = ptSt + vZ * dMH ;
	pt = ptSt ;
	PLine plFace( vX ) ;
	plFace.addVertex( pt ) ;
	
	pt = pt + vY * U(50) ;
	plFace.addVertex( pt ) ;
	pt = pt - vY * U(20) - vZ * U(20) ;
	plFace.addVertex( pt ) ;
	pt = pt - vZ * dMH/2 ;
	plFace.addVertex( pt ) ;
	pt = pt - vY * U(30) - vZ * U(30) ;
	plFace.addVertex( pt ) ;
	plFace.addVertex( ptSt ) ;
	
	Body bdFace( plFace, -vX ) ;
	Body bdTop( ptSt, vX, vY, vZ, U(30), U(50), 1, 1, 1, 1 ) ;
	
	bdSide.addPart( bdFace ) ;
	bdSide.addPart( bdTop ) ;
	
	CoordSys cs ;
	cs.setToMirroring( Plane( _Pt0, vY ) ) ;
	Body bdSide1 ;
	bdSide1.copyPart( bdSide ) ;
	bdSide1.transformBy( cs ) ;
	
	bd.addPart( bdSide ) ;
	bd.addPart( bdSide1 ) ;
	
	dp.draw( bd ) ;
}


setDependencyOnEntity(_Beam[0]);

assignToGroups(_Beam[0]);

if (bDisplay)
{
	Point3d ptSign=_Pt0-vZ*(dMH*0.5)-_X0*U(80);
	Display dp(-1);
	dp.dimStyle(sDimStyle);
	dp.addViewDirection(_ZW);
	dp.addViewDirection(_Beam[0].vecD(_ZW));
	dp.addViewDirection(vZ);
	dp.addViewDirection(-vZ);	
	Vector3d vOffset=-_X0.crossProduct(_ZW);
	vOffset.normalize();
	ptSign=ptSign+vOffset*dOffset;
	dp.draw(stModel, ptSign, -_X0, _ZW, 1, 0, _kDevice); // draw a string with default text style with lower left corner at pnt1
}

String st1 = (String)stType ;
String st2 = (String)stCode ;
String st3 = (String)stModel ;
String stCompare = st1 + st2 + st3 ;
setCompareKey(stCompare) ;

//Declare Export fields for Access
//model( stModel ) ;
//dxaout( "Code", stCode ) ;

exportToDxi(TRUE);
dxaout("HANGER", "");
dxaout("MODEL",stModel);
dxaout("QUANTITY","1");

//For Excel
//Hardware hw( stCode, "", stModel, 0, 0, 0, "" ) ;

//Create Map for hsbBOM
Map TSLBOM ;
TSLBOM.appendString( "Name", stCode ) ;
TSLBOM.appendString( "Type", stModel ) ;
TSLBOM.appendInt( "Qty", 1 ) ;

_Map.setMap( "TSLBOM", TSLBOM ) ;


//_________Salut..................

/*
			sList[0] = tsl0.posnum();
			sList[1] = mapSub.getString("Name");
			sList[2] = mapSub.getInt("Qty") * nPcsList[i];
			if ( mapSub.getDouble("Length")!=0)
				sList[3] = mapSub.getDouble("Length");
			if ( mapSub.getDouble("Width")!=0)					
				sList[4] = mapSub.getDouble("Width");
			if ( mapSub.getDouble("Height")!=0)						
			sList[5] = mapSub.getDouble("Height");
			sList[6] = mapSub.getString("Mat");
			sList[7] = mapSub.getString("Grade");
			sList[8] = mapSub.getString("Info");
			sList[10] = mapSub.getString("Profile");
			sList[13] = mapSub.getString("Type");






























#End
#BeginThumbnail














#End