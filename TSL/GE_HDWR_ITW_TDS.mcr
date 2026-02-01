#Version 8
#BeginDescription
v1.6: 03.nov.2013: David Rueda (dr@hsb-cad.com)
Applies Tie Down System to n levels of multi store, adding 
-	Rods
-	Nuts
-	Square blocks
-	Washers
-	Couplers
-	Tuds 
-	Beams at sides of system (up to 5 per side)
-	Floor system blocking (optional)
-	Floor system straps (optional)
Available options:
-	System types: 5/8, 1/2, 7/8
-	Run start options: Concrete, wood beam
-	Run end options: Top plates
-	Rod embedment
-	Rod extension
-	Qty. of studs at left
-	Qty. of studs at right
-	Coupler height for first level
-	Coupler height for upper levels
-	Distance between studs (clear distance) 
-	Stud type
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
*  hsbSOFT 
*  UNITED STATES OF AMERICA
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY 
* -------------------------
* v1.6: 03.nov.2013: David Rueda (dr@hsb-cad.com)
	- Stickframe path added to mapIn when calling dll
* v1.5: 01.apr.2013: David Rueda (dr@hsb-cad.com)
	- Integrated manual insertion and construction directive insertion
	- Props values, read only, and hidden upon construction directive info provided
* v1.4: 01.apr.2013: David Rueda (dr@hsb-cad.com)
	- Prop. names updated
	- TSL won't be erased if inserted manually
* v1.3: 31.oct.2012: David Rueda (dr@hsb-cad.com)
*	- Color set to white
* v1.2: 10.oct.2012: David Rueda (dr@hsb-cad.com)
*	- Added code to avoid error on insertion when user had wrong pre-set values loaded
* v1.1: 09.oct.2012: David Rueda (dr@hsb-cad.com)
*	- Exporting to _Map values to be consumed by Revit
* v1.0: 06.oct.2012: David Rueda (dr@hsb-cad.com)
*	Release
*
*/

double dTolerance= U(0.01, 0.001);

if( _bOnInsert)
{
	String sLumberItemKeys[0];
	String sLumberItemNames[0];
	
	// Calling dll to fill item lumber prop.
	Map mapIn;
	Map mapOut;
	
	//Setting info
	String sCompanyPath = _kPathHsbCompany;
	mapIn.setString("CompanyPath", sCompanyPath);

	String sStickFramePath= _kPathHsbWallDetail;
	mapIn.setString("StickFramePath", sStickFramePath);
	
	String sInstallationPath			= 	_kPathHsbInstall;
	mapIn.setString("InstallationPath", sInstallationPath);
	
	String sAssemblyFolder			=	"\\Utilities\\hsbFramingDefaultsEditor";
	String sAssembly					=	"\\hsbFramingDefaults.Inventory.dll";
	String sAssemblyPath 			=	sInstallationPath+sAssemblyFolder+sAssembly;
	String sNameSpace				=	"hsbSoft.FramingDefaults.Inventory.Interfaces";
	String sClass						=	"InventoryAccessInTSL";
	String sClassName				=	sNameSpace+"."+sClass;
	String sFunction					=	"GetLumberItems";
	
	mapOut = callDotNetFunction2(sAssemblyPath, sClassName, sFunction, mapIn);
	_Map.setMap("mapOut",mapOut);
	_Map.setInt("ManuallyInserted",1);
}

String sLumberItemKeys[0];
String sLumberItemNames[0];
Map mapOut=_Map.getMap("mapOut");

// Filling lumber items
for( int m=0; m<mapOut.length(); m++)
{
	String sKey= mapOut.keyAt(m);
	String sName= mapOut.getString(sKey+"\NAME");
	if( sKey!="" && sName!="")
	{
		sLumberItemKeys.append( sKey );
		sLumberItemNames.append( sName);
	}
}
	
// OPM 
String sTab="     ";
String sNoYes[]={T("|No|"),T("|Yes|")};

String sSystemType[]=		{	"5/8",							"1/2",							"7/8"};
double dRodDiameters[]=		{	U(15, 0.625),					U(10, 0.5),					U(22, 0.875)};

															PropString sType						(0, sSystemType, T("|System type|"),0);
int nType=sSystemType.find(sType,0);
double dRodDiameter=dRodDiameters[nType];

double dNutSideLength=U(25, 1.062);
double dNutSideHeight=U(15, 0.625);
double dSquareBlockSideLength=U(75, 3);
double dSquareBlockSideHeight=U(20, 0.75);
double dSquareWasherSideLength=U(75, 3);
double dSquareWasherSideHeight=U(15, 0.625);
double dCouplerSideLength=U(25, 1.062);
double dCouplerSideHeight=U(75, 3);
double dTudDiameter=U(50, 2);
double dTudSideHeight=U(50, 2);
double dStrapLength=U(800,32);
double dStrapWidth=U(25,1);
double dStrapDepth=U(2.5,0.09375);

															PropString sBmLumberItem			(1, sLumberItemNames,T("|Stud type|"),0);
String sQtyStuds[]={"0","1","2","3","4","5"};
															PropString sStudsLeft					(2, sQtyStuds, T("|Studs at left|"),2);
int nStudsLeft=sQtyStuds.find(sStudsLeft,0);
															PropString sStudsRight				(3, sQtyStuds, T("|Studs at right|"),2);
int nStudsRight=sQtyStuds.find(sStudsRight,0);

															PropString sFloorSystemBlocking	(4, sNoYes, T("|Floor system blocking|"));
int nBlocking=sNoYes.find(sFloorSystemBlocking,0);
															PropString sStrapsOnBlocking		(5, sNoYes, "     -"+T("|Straps on blocking|"));
int nStrapsOnBlocking=sNoYes.find(sStrapsOnBlocking,0);

String sRunStartOptions[]={T("|Concrete|"),T("|Wood beam|")};
															PropString sRunStart					(6, sRunStartOptions, T("|Run Start Options|"));
int nRunStart=sRunStartOptions.find(sRunStart,0);

String sRunEndOptions[]={T("|Top plates|"),T("|Compression Bridge|")};
															PropString sRunEnd					(7, sRunEndOptions, T("|Run Termination|"));
int nRunEnd=sRunEndOptions.find(sRunEnd,0);
																		PropDouble dRodEmbedment					(0, U(200, 8),T("|Anchor bolt Embedment|"));
																		PropDouble dRodExtension					(1, U(75, 3),T("|Rod Extension|"));
																		PropDouble dFirstLevelCouplerHeight		(2, U(300, 12),T("|First Level Coupler Height|"));
																		PropDouble dOtherLevelsCouplerHeight		(3, U(300, 12),T("|Other Levels Coupler Height|"));
																		PropDouble dClearDistance					(4, U(150, 6),T("|Clear distance between posts|"));																																		

double dSearchHeight= U(25000, 1000);
double dSearchSide= U(1200,48);

if( _kNameLastChangedProp != "" )
{
	_Map.setInt("ExecutionMode",0);
}

int bManuallyInserted=_Map.getInt("ManuallyInserted");
if (_bOnElementDeleted && !bManuallyInserted)
{
	eraseInstance();
}

// Set all props read only
if( !bManuallyInserted)
{
	sType.set( _Map.getString("TYPE"));
	sType.setReadOnly(TRUE);
	sBmLumberItem.set(T("|System defined|"));
	sBmLumberItem.setReadOnly(TRUE);

	sStudsLeft.set(""); 
	sStudsLeft.setReadOnly(TRUE);

	sStudsRight.set(""); 
	sStudsRight.setReadOnly(TRUE);

	sFloorSystemBlocking.set(_Map.getString("FloorSystemBlocking"));
	sFloorSystemBlocking.setReadOnly(TRUE);

	sStrapsOnBlocking.set(_Map.getString("FloorSystemBlockingStraps"));
	sStrapsOnBlocking.setReadOnly(TRUE);

	sRunStart.set("");
	sRunStart.setReadOnly(TRUE);

	sRunEnd.set(_Map.getString("RunEnd"));
	sRunEnd.setReadOnly(TRUE);

	dRodEmbedment.set(_Map.getDouble("RodEmbedment"));
	dRodEmbedment.setReadOnly(TRUE);

	dRodExtension.set(_Map.getDouble("RodExtension"));
	dRodExtension.setReadOnly(TRUE);

	dFirstLevelCouplerHeight.set(_Map.getDouble("FirstLevelCouplerHeight"));
	dFirstLevelCouplerHeight.setReadOnly(TRUE);

	dOtherLevelsCouplerHeight.setReadOnly(TRUE);
	
	dClearDistance.set(_Map.getDouble("ClearDistance"));
	dClearDistance.setReadOnly(TRUE);
}

if( _bOnInsert || _bOnElementConstructed || _bOnRecalc || !_Map.getInt("ExecutionMode"))
{
	if(_bOnInsert)
	{
		
		if( insertCycleCount()>1 )
		{
			eraseInstance();
			return;
		}
		
		PrEntity ssEl("\n"+T("|Select walls|"), ElementWall());
		if( ssEl.go() )
		{
			_Element.append(ssEl.elementSet());
		}
		
		if(_Element.length()==0)
		{
			eraseInstance();
			return;	
		}
		
		_Pt0=getPoint();
		
		showDialog();

		// Find walls at point
		_Pt0.setZ(0);
		_Map.setVector3d("ORIGINALINSERTIONPOINT",_Pt0);
		_Element0=_Element[0];
		_Pt0+=_Element0.vecZ()*_Element0.vecZ().dotProduct(_Element[0].ptOrg()-_Pt0);
		Body bdSearch (_Pt0, _XW, _YW, _ZW, dSearchSide, dSearchSide, dSearchHeight, 0, 0, 1); //Every wall that intersects with this body is under truss

		// Getting REFERENCE BODY element
		Body bdReference;
		int nReferenceElementFound=false;
		for( int e=0; e< _Element.length(); e++)
		{
			ElementWall el = (ElementWall) _Element[e];
			if (!el.bIsValid())
			{
				continue;
			}
		
			PLine plOutlineWall=el.plOutlineWall();
			Body bdEl ( plOutlineWall, _ZW*((Wall)el).baseHeight(), 1);
			if (bdSearch.hasIntersection( bdEl))
			{
				Body bd(plOutlineWall, _ZW*dSearchHeight, 1);
				bdReference= bd;
				bdReference.transformBy(_ZW*_ZW.dotProduct(Point3d(0,0,0)-el.ptOrg()));																																				//bdReference.vis(3);bd.vis(3);
				bdReference.intersectWith( bdSearch);
				nReferenceElementFound=true;
				break;
			}
		}
		
		if(!nReferenceElementFound)
		{
			reportMessage("\n"+T("|Message from|")+" "+ scriptName()  +" TSL: "+T("|Reference element not found, TSL will be erased.|"));
			//eraseInstance();
			return;				
		}
		
		// We have our reference body and point, now we need to find all elements that are aligned to this...
		ElementWall elAll[0];
		for( int e=0; e< _Element.length(); e++)
		{
			ElementWall el = (ElementWall) _Element[e];
			
			if (!el.bIsValid())
			{
				continue;
			}
		
			PLine plOutlineWall=el.plOutlineWall();
			Body bdEl ( plOutlineWall, _ZW*((Wall)el).baseHeight(), 1); 
			if (bdReference.hasIntersection( bdEl))
			{
				elAll.append(el);
			}
		}

		// We have all elements to work with in elAll[]
		if( elAll.length()==0) // There are not walls at this point
		{	
			reportMessage("\n"+T("|Message from|")+" "+ scriptName()  +" TSL: "+ T("|No walls left after filter by location, TSL will be erased.|"));
			eraseInstance();
			return;
		}
		
		_Element.setLength(0);
		for(int e=0; e<elAll.length();e++)
		{
			_Element.append((Element)elAll[e]);
			setDependencyOnEntity(elAll[e]);	
		}
		
		int bNotFramed;
		for(int e=0;e<_Element.length();e++)
		{
			Element el=_Element[e];
			setDependencyOnEntity(el);
			Beam bmAll[]=el.beam();
			if (bmAll.length()==0)
			{
				bNotFramed=true;
			}
		}
	
		if(bNotFramed)
		{
			reportMessage("\n"+"|Message from| "+ scriptName()+"TSL : "+T(" |All walls must be framed prior this operation|"));
			return;
		}		
	}// End _bOnInsert
	
	int bNotFramed;
	for(int e=0;e<_Element.length();e++)
	{
		Element el=_Element[e];
		setDependencyOnEntity(el);
		Beam bmAll[]=el.beam();
		if (bmAll.length()==0)
		{
			bNotFramed=true;
		}
	}

	if(bNotFramed)
	{
		return;
	}

	int bManuallyInserted=_Map.getInt("ManuallyInserted");
	if(bManuallyInserted==0) // Not manually inserted, assumed to be at least by construction directive
	{
		nStudsLeft=nStudsRight=0;
		dClearDistance.set(U(25,1));dClearDistance.setReadOnly(TRUE);
	}
	else
	{
		// Erase all beams created by this tsl
		for(int b=0; b<_Beam.length();b++)
		{
			Beam bm=_Beam[b];
			bm.dbErase();
		}
				
		double dMinClearDistance=U(50, 3);
		if(dClearDistance<dMinClearDistance)
		{
			reportMessage("\n"+T("|Message from|")+" "+ scriptName()  +" TSL: "+T("|Clear distance can't be less than|")+" "+dMinClearDistance);
			dClearDistance.set(dMinClearDistance);
		}
	}  //END if(bManuallyInserted)

	// Rods
	Point3d ptAllRodsStartPoints[0];
	Point3d ptAllRodsEndPoints[0]; // MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllRodsStartPoints
	
	// Nuts
	Point3d ptAllNutsBasePoints[0]; // Insertion point for all nuts, aligned center in diameter, BASE in vertical
	Point3d ptAllNutsExtrusionPoints[0]; // define the vector to extrude body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllRodsBasePoints
	Point3d ptAllNutsDirectionPoints[0]; // define the vector to align body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllRodsBasePoints
	// Square metal blocks
	Point3d ptAllSquareBlocksBasePoints[0]; // Insertion point for all square metal blocks, aligned center in diameter, BASE in vertical
	Point3d ptAllSquareBlocksExtrusionPoints[0]; // define the vector to extrude body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllSquareBlocksBasePoints
	Point3d ptAllSquareBlocksDirectionPoints[0]; // define the vector to align body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllSquareBlocksBasePoints
	// Square washers
	Point3d ptAllSquareWashersBasePoints[0]; // Insertion point for all square washers, aligned center in diameter, BASE in vertical
	Point3d ptAllSquareWashersExtrusionPoints[0]; // define the vector to extrude body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllSquareBlocksBasePoints
	Point3d ptAllSquareWashersDirectionPoints[0]; // define the vector to align body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllSquareBlocksBasePoints
	//Couplers
	Point3d ptAllCouplersBasePoints[0]; // Insertion point for all couplers, aligned center in diameter, CENTER in vertical
	Point3d ptAllCouplersExtrusionPoints[0]; // define the vector to extrude body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllCouplersBasePoints
	Point3d ptAllCouplersDirectionPoints[0]; // define the vector to align body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllCouplersBasePoints
	//Tuds
	Point3d ptAllTudsBasePoints[0]; // Insertion point for all couplers, aligned center in diameter, BASE in vertical
	Point3d ptAllTudsExtrusionPoints[0]; // define the vector to extrude body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllTudsBasePoints
	Point3d ptAllTudsDirectionPoints[0]; // define the vector to align body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllTudsBasePoints
	//Straps
	Point3d ptAllStrapsCenterPoints[0]; // Insertion point for all straps, aligned center in diameter, CENTER in vertical
	Point3d ptAllStrapsExtrusionPoints[0]; // define the vector to extrude body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllStrapsCenterPoints
	Point3d ptAllStrapsDirectionPoints[0]; // define the vector to align body MAKE SURE ALWAYS HAS SAME LENGHT THAT ptAllStrapsCenterPoints
	
	ElementWall elAll[0];
	
	for( int e=0; e< _Element.length(); e++)
	{
		ElementWall el = (ElementWall) _Element[e];
		
		if (!el.bIsValid())
		{
			continue;
		}
		elAll.append(el);
	}
	
	if( elAll.length()==0)
	{
		reportMessage("\n"+T("|Message from|")+" "+ scriptName()  +" TSL: "+T("|Error: no valid element was provided|")+"\n");
		eraseInstance();
		return;
	}
	
	// Sort elements according to height position
	int nNrOfRows=elAll.length();
	int bAscending=true;
	  
	for(int s1=1; s1<nNrOfRows; s1++)
	{
		int s11 = s1;
		for(int s2=s1-1; s2>=0; s2--)
		{
			int bSort = elAll[s11].ptOrg().Z() > elAll[s2].ptOrg().Z();
			if( bAscending )
			{
				bSort = elAll[s11].ptOrg().Z() < elAll[s2].ptOrg().Z();
			}
			if( bSort )
			{
				elAll.swap(s2, s11);
				s11=s2;
			}
		}
	}		
	
	// We have all elements to work with in elAll[] sorted: elAll[0] is the lowest, elAll[ elAll.lenght()-1] is the highest
	// Get props from selected lumber item
	int nBmColor=3;
	String sBmMaterial, sBmGrade;
	double dBmWidth, dBmHeight;
	String sBmModule= scriptName()+ "_" + _ThisInst.handle() ;
	String sBmInformation="";

	if(bManuallyInserted)
	{
		// Getting values from selected item lumber
		int nLumberItemIndex=sLumberItemNames.find(sBmLumberItem,-1);
		if( nLumberItemIndex==-1) //Selected beam type was not found
		{
			reportMessage("\n"+T("|ERROR|")+": "+T("|There are not valid values for beam type|")+". "+"Please verify"+" :"+
				"\n- "+"Company folder"+
				"\n- "+"Drawing units"+
				"\n- "+"TSL insertion values. You can reset them setting to 'Default' catalog and reinserting TSL"+
				"\n- "+"If none before solves the issue, please contact any TSL support assistant");
			eraseInstance();
			return;
		}
				
		for( int m=0; m<mapOut.length(); m++)
		{
			String sSelectedKey= sLumberItemKeys[nLumberItemIndex];
			String sKey= mapOut.keyAt(m);
			if( sKey==sSelectedKey)
			{
				dBmWidth= mapOut.getDouble(sKey+"\WIDTH");
				dBmHeight= mapOut.getDouble(sKey+"\HEIGHT");
				sBmMaterial= mapOut.getString(sKey+"\HSB_MATERIAL");
				sBmGrade= mapOut.getString(sKey+"\HSB_GRADE");
				break;
			}
		}
	
		if( dBmWidth<=0 || dBmHeight<=0)
		{
			reportNotice("\n"+T("|Data incomplete, check values for new studs|"+":")
				+"\n"+T("|Material|")+": "+ sBmMaterial
				+"\n"+T("|Grade|")+": "+ sBmGrade
				+"\n"+T("|Width|")+": "+ dBmWidth
				+"\n"+T("|Height|")+": "+ dBmHeight);
			return;
		}
	}
	// Got all lumber item info needed

	// Neet to define what is same rigth, up and front vectors on all elements
	Vector3d vTDSx=elAll[0].vecX();
	Vector3d vTDSy=_ZW;
	Vector3d vTDSz=vTDSx.crossProduct(vTDSy);
	double dTDSWidth= dClearDistance+dBmWidth*(nStudsLeft+nStudsRight);
	_Map.setVector3d("vTDSx",vTDSx);
	_Map.setVector3d("vTDSy",vTDSy);
	_Map.setVector3d("vTDSz",vTDSz);
	
	// Parameters for new beams
	Vector3d vSideOfWall;
	Point3d ptSideOfWall;

	// Set cleaning area
 	Point3d ptBdCleanOrg=_Pt0-vTDSx*(dClearDistance*.5+dBmWidth*nStudsLeft);
	Vector3d vCleanX=vTDSx;
	Vector3d vCleanY=vTDSy;
	Vector3d vCleanZ=vTDSz;

	double dBdCleanX=dTDSWidth;
	double dBdCleanY=dSearchHeight;
	double dBdCleanZ=dSearchSide;
	if( dBdCleanX == 0 || dBdCleanY == 0 || dBdCleanZ == 0 )
	{
		return;
	}		
	
	Body bdClean (ptBdCleanOrg, vCleanX, vCleanY, vCleanZ, dBdCleanX, dBdCleanY, dBdCleanZ, 1, 1, 0); // This area must be clean, all studs erased and all blocking splitted
	PlaneProfile ppClean=bdClean.getSlice(Plane(_Pt0+_ZW*dTolerance,_ZW));
	PLine plAllClean[]=ppClean.allRings();
	PLine plClean=plAllClean[0];
	_Map.setPLine("PL_CLEAN_AREA", plClean);
	
	Beam bmAllTransfersToStretchAtTop[0]; // Will be created in current element and streched at next element
	int nElementsFramed;
	// Work with wall elements
	for( int e= 0; e<elAll.length(); e++)
	{
		Element el= elAll[e];
		setDependencyOnEntity(el);
		
		if(!el.bIsValid())
			continue;

		CoordSys csEl=el.coordSys();
		Point3d ptElOrg=csEl.ptOrg();
		Vector3d vx = csEl.vecX();
		Vector3d vy = csEl.vecY();
		Vector3d vz = csEl.vecZ();
		
		// Element's lenght
		PlaneProfile ppEl(el.plOutlineWall());
		LineSeg ls=ppEl.extentInDir(vx);
		double dElLength=abs(vx.dotProduct(ls.ptStart()-ls.ptEnd()));
		ls=ppEl.extentInDir(vz);
		double dElWidth=abs(vz.dotProduct(ls.ptStart()-ls.ptEnd()));
		double dElHeight= ((Wall)el).baseHeight();
		Point3d ptElStart= ptElOrg;
		Point3d ptElEnd= ptElOrg+vx*dElLength;
		Point3d ptElCenter= ptElOrg+vx*dElLength*.5-vz*dElWidth*.5;	
			
		// Bottom wall: realign _Pt0, add rod+square block+nut
		if(e==0) 
		{		
			// _Pt0 to bottom/center of wall
			_Pt0+= vy*vy.dotProduct(ptElCenter-_Pt0)+vz*vz.dotProduct(ptElCenter-_Pt0);
			vSideOfWall=vTDSz;
			Point3d ptOriginalInsertionPoint=_Map.getVector3d("ORIGINALINSERTIONPOINT");
			if(vSideOfWall.dotProduct(ptOriginalInsertionPoint-ptElCenter)<0)
				vSideOfWall=-vSideOfWall;
			ptSideOfWall=_Pt0+vSideOfWall*dElWidth*.5;
		}	

		// Define drill		
		Point3d ptDrillStart=_Pt0-_ZW*(dRodEmbedment+dTolerance);
		Point3d ptDrillEnd= ptDrillStart+_ZW*dSearchHeight;
		Drill drill(ptDrillStart, ptDrillEnd, dRodDiameter*.5);
		
		Beam bmAll[]=el.beam();
		if (bmAll.length()==0)
			continue;
	
		// Search top & bottom plates and blocking
		// Adding drill to plates
		Beam bmHorizontals[]=vx.filterBeamsParallel(bmAll);
		Beam bmVerticals[]=vy.filterBeamsParallel(bmAll);
		Beam bmBottomPlates[0], bmTopPlates[0], bmBlocking[0];
		for( int b=0; b<bmHorizontals.length(); b++)
		{
			Beam bm=	bmHorizontals[b];
			if(bm.type()==_kBottom || bm.type()==_kSFBottomPlate)
			{
				bmBottomPlates.append(bm);
				bm.addToolStatic(drill);
			}
			else if(bm.type()==_kTopPlate || bm.type()==_kSFTopPlate || bm.type()==_kSFVeryTopPlate)
			{
				bmTopPlates.append(bm);
				bm.addToolStatic(drill);
			}
			else if(bm.type()==_kSFBlocking || bm.type()==_kBlocking )
			{
				bmBlocking.append(bm);
			}
		}
		
		if(bmBottomPlates.length()==0 || bmTopPlates.length()==0)
			continue;
			
		bmBottomPlates=vy.filterBeamsPerpendicularSort(bmBottomPlates);
		Beam bmHighestBottomPlate=bmBottomPlates[bmBottomPlates.length()-1];
		Point3d ptTopOfBottomPlates=bmHighestBottomPlate.ptCen()+vy*bmHighestBottomPlate.dD(vy)*.5;
		Beam bmLowestBottomPlate=bmBottomPlates[0];
		Point3d ptBottomOfBottomPlates=bmLowestBottomPlate.ptCen()-vy*bmLowestBottomPlate.dD(vy)*.5;

		bmTopPlates=vy.filterBeamsPerpendicularSort(bmTopPlates);
		Beam bmLowestTopPlate=bmTopPlates[0];
		Point3d ptBottomOfTopPlates=bmLowestTopPlate.ptCen()-vy*bmLowestTopPlate.dD(vy)*.5;
		Beam bmHighestTopPlate=bmTopPlates[bmTopPlates.length()-1];
		Point3d ptTopOfTopPlates=bmHighestTopPlate.ptCen()+vy*bmHighestTopPlate.dD(vy)*.5;

		if(e==0) // Bottom wall
		{		
			Point3d ptRodStart=ptElCenter+vx*vx.dotProduct(_Pt0-ptElCenter)-_ZW*dRodEmbedment;
			
			if( nRunStart == 0) // concrete
			{
				// Bottom nut
				Point3d ptNutBase=ptRodStart+_ZW*U(5,.25);
				ptAllNutsBasePoints.append(ptNutBase);
				ptAllNutsExtrusionPoints.append(ptNutBase+_ZW);
				ptAllNutsDirectionPoints.append(ptNutBase+vx);
				
				// Square block
				Point3d ptSquareBlockBase=ptNutBase+_ZW*dNutSideHeight;
				ptAllSquareBlocksBasePoints.append(ptSquareBlockBase);
				ptAllSquareBlocksExtrusionPoints.append(ptSquareBlockBase+_ZW);
				ptAllSquareBlocksDirectionPoints.append(ptSquareBlockBase+vx);
				
				// Top nut
				ptNutBase=ptSquareBlockBase+_ZW*dSquareBlockSideHeight;
				ptAllNutsBasePoints.append(ptNutBase);
				ptAllNutsExtrusionPoints.append(ptNutBase+_ZW);
				ptAllNutsDirectionPoints.append(ptNutBase+vx);

			}
			else if( nRunStart == 1) // wood beam
			{
				// Square block
				Point3d ptSquareBlockBase=ptElCenter+vx*vx.dotProduct(_Pt0-ptElCenter)+vy*vy.dotProduct(ptBottomOfBottomPlates-ptElCenter);
				ptSquareBlockBase-=_ZW*dSquareBlockSideHeight;
				ptAllSquareBlocksBasePoints.append(ptSquareBlockBase);
				ptAllSquareBlocksExtrusionPoints.append(ptSquareBlockBase+_ZW);
				ptAllSquareBlocksDirectionPoints.append(ptSquareBlockBase+vx);
				
				// Bottom nut
				Point3d ptNutBase=ptSquareBlockBase-_ZW*dNutSideHeight;
				ptAllNutsBasePoints.append(ptNutBase);
				ptAllNutsExtrusionPoints.append(ptNutBase+_ZW);
				ptAllNutsDirectionPoints.append(ptNutBase+vx);
			}
			
			// Coupler
			Point3d ptCouplerCenter=ptElCenter+vx*vx.dotProduct(_Pt0-ptElCenter)+_ZW*dFirstLevelCouplerHeight;
			ptAllCouplersBasePoints.append(ptCouplerCenter);
			ptAllCouplersExtrusionPoints.append(ptCouplerCenter+_ZW);
			ptAllCouplersDirectionPoints.append(ptCouplerCenter+vx);
			
			// Rod
			ptAllRodsStartPoints.append(ptRodStart);
			ptAllRodsEndPoints.append(ptCouplerCenter);
			
			// Split rod
			ptAllRodsStartPoints.append(ptCouplerCenter);						
			
			// Setting values to be consumed by Revit (all set here to having them grouped)
			_Map.setInt("STORYNUMBER",elAll.length());	
			_Map.setDouble("BOTTOMPLATEHEIGHT",ptTopOfBottomPlates.Z());
			_Map.setDouble("STARTLEVELCOUPLERHEIGHT",dFirstLevelCouplerHeight);
			_Map.setDouble("RODEMBEDMENT",dRodEmbedment);
			_Map.setDouble("RODEXTENSION",dRodExtension);
			_Map.setDouble("OTHERLEVELSCOUPLERHEIGHT",dOtherLevelsCouplerHeight);
			// Set wall height
			int nStoryNumber=e+1;String sKeyName= "SYSTEM_"+nStoryNumber+"_WALLHEIGHT";			
			_Map.setDouble(sKeyName,((Wall)el).baseHeight());
		}
		
		else // Other than bottom wall
		{
			// Setting values to be consumed by Revit (all set here to having them grouped)
			// Get floor thickness
			String sKeyName= "SYSTEM_"+e+"_WALLHEIGHT";
			double dLastStoryHeight= _Map.getDouble(sKeyName);
			Wall wlBelow=(Wall)elAll[e-1];
			double dFloorThickness=el.ptOrg().Z()-wlBelow.baseHeight()-((Element)wlBelow).ptOrg().Z();
			// Set floor thickness
			int nStoryNumber=e+1;
			sKeyName= "SYSTEM_"+nStoryNumber+"_FLOORTHICKNESS";
			_Map.setDouble(sKeyName,dFloorThickness);
			// Set wall height
			sKeyName= "SYSTEM_"+nStoryNumber+"_WALLHEIGHT";
			_Map.setDouble(sKeyName,((Wall)el).baseHeight());

			// Square block
			Point3d ptSquareBlockBase=ptElCenter+vx*vx.dotProduct(_Pt0-ptElCenter)+vy*vy.dotProduct(ptTopOfBottomPlates-ptElCenter);
			ptAllSquareBlocksBasePoints.append(ptSquareBlockBase);
			ptAllSquareBlocksExtrusionPoints.append(ptSquareBlockBase+_ZW);
			ptAllSquareBlocksDirectionPoints.append(ptSquareBlockBase+vx);

			// Tud
			Point3d ptTudBase=ptSquareBlockBase+_ZW*dSquareBlockSideHeight;
			ptAllTudsBasePoints.append(ptTudBase);
			ptAllTudsExtrusionPoints.append(ptTudBase+_ZW);
			ptAllTudsDirectionPoints.append(ptTudBase+vx);
						
			// Coupler
			Point3d ptCouplerCenter=ptElCenter+vx*vx.dotProduct(_Pt0-ptElCenter)+_ZW*dOtherLevelsCouplerHeight;
			ptAllCouplersBasePoints.append(ptCouplerCenter);
			ptAllCouplersExtrusionPoints.append(ptCouplerCenter+_ZW);
			ptAllCouplersDirectionPoints.append(ptCouplerCenter+vx);	

			// Rod
			ptAllRodsEndPoints.append(ptCouplerCenter);
			ptAllRodsStartPoints.append(ptCouplerCenter);
		}
		
		if(e == elAll.length()-1) // Top wall
		{
			if( nRunEnd==0) // Top plates
			{
				// Square washer
				Point3d ptSquareWasherBase=ptElCenter+vx*vx.dotProduct(_Pt0-ptElCenter)+vy*vy.dotProduct(ptTopOfTopPlates-ptElCenter);
				ptAllSquareWashersBasePoints.append(ptSquareWasherBase);
				ptAllSquareWashersExtrusionPoints.append(ptSquareWasherBase+_ZW);
				ptAllSquareWashersDirectionPoints.append(ptSquareWasherBase+vx);
				
				// Top nut
				Point3d ptNutBase=ptSquareWasherBase+vy*dSquareWasherSideHeight;
				ptAllNutsBasePoints.append(ptNutBase);
				ptAllNutsExtrusionPoints.append(ptNutBase+_ZW);
				ptAllNutsDirectionPoints.append(ptNutBase+vx);	
				
				// Rod
				ptAllRodsEndPoints.append(ptSquareWasherBase+_ZW*dRodExtension);
			}
		}
		// Store info in _Map to display outside _bOnInsert || _bOnElementConstructed || _bOnRecalc || !_Map.getInt("ExecutionMode"
		
		// Rods
		_Map.setPoint3dArray("ptAllRodsStartPoints",ptAllRodsStartPoints);
		_Map.setPoint3dArray("ptAllRodsEndPoints",ptAllRodsEndPoints);
	
		// Nuts
		_Map.setPoint3dArray("ptAllNutsBasePoints",ptAllNutsBasePoints);
		_Map.setPoint3dArray("ptAllNutsExtrusionPoints",ptAllNutsExtrusionPoints);
		_Map.setPoint3dArray("ptAllNutsDirectionPoints",ptAllNutsDirectionPoints);
		// Square metal blocks
		_Map.setPoint3dArray("ptAllSquareBlocksBasePoints",ptAllSquareBlocksBasePoints);
		_Map.setPoint3dArray("ptAllSquareBlocksExtrusionPoints",ptAllSquareBlocksExtrusionPoints);
		_Map.setPoint3dArray("ptAllSquareBlocksDirectionPoints",ptAllSquareBlocksDirectionPoints);
		// Square washers
		_Map.setPoint3dArray("ptAllSquareWashersBasePoints",ptAllSquareWashersBasePoints);
		_Map.setPoint3dArray("ptAllSquareWashersExtrusionPoints",ptAllSquareWashersExtrusionPoints);
		_Map.setPoint3dArray("ptAllSquareWashersDirectionPoints",ptAllSquareWashersDirectionPoints);
		//Couplers
		_Map.setPoint3dArray("ptAllCouplersBasePoints",ptAllCouplersBasePoints);
		_Map.setPoint3dArray("ptAllCouplersExtrusionPoints",ptAllCouplersExtrusionPoints);
		_Map.setPoint3dArray("ptAllCouplersDirectionPoints",ptAllCouplersDirectionPoints);
		//Tuds
		_Map.setPoint3dArray("ptAllTudsBasePoints",ptAllTudsBasePoints);
		_Map.setPoint3dArray("ptAllTudsExtrusionPoints",ptAllTudsExtrusionPoints);
		_Map.setPoint3dArray("ptAllTudsDirectionPoints", ptAllTudsDirectionPoints);
		// DONE WITH METAL PARTS EXCEPT STRAPS

		// FRAMING (ONLY IF MANUALLY INSERTED
		if(bManuallyInserted)
		{
			//Cleaning area (erasing studs interfering)
			Beam bmCreated[0];// Blocking will be sreched to one of these
			for( int b=0; b<bmVerticals.length(); b++)
			{
				Beam bm=bmVerticals[b];
				Body bdBm=bm.realBody();
				if(bdBm.hasIntersection( bdClean))
				{
					bm.dbErase();
				}
			}

			// Stretching transfer beams created (somewhere below) in last element
			for( int t=0; t<bmAllTransfersToStretchAtTop.length();t++)
			{
				Beam bmTransferToStretch=bmAllTransfersToStretchAtTop[t];
				if(bmTransferToStretch.bIsValid())
				{
					Beam arBeamHitBottoms[] = Beam().filterBeamsHalfLineIntersectSort(bmBottomPlates, bmTransferToStretch.ptCen() , vTDSy);
					if (arBeamHitBottoms.length()>0) 
					{
						Beam bmHitBottom = arBeamHitBottoms[0];
						bmTransferToStretch.stretchDynamicTo(bmHitBottom);
						if(nStrapsOnBlocking)
						{
							// Defining which transfer needs floor to floor strap					
							Map subMapX=  bmTransferToStretch.subMapX("SUBMAP");
							if(subMapX.getInt("HAVESTRAP"))
							{							
								Point3d ptStrapCenter=bmTransferToStretch.ptCen()+vSideOfWall*vSideOfWall.dotProduct(ptSideOfWall-bmTransferToStretch.ptCen());
								ptAllStrapsCenterPoints.append(ptStrapCenter);
								ptAllStrapsExtrusionPoints.append(ptStrapCenter+vSideOfWall);
								ptAllStrapsDirectionPoints.append(ptStrapCenter+_ZW);
							}
						}					
					}
				}
			}
			
			//Straps
			_Map.setPoint3dArray("ptAllStrapsCenterPoints",ptAllStrapsCenterPoints);
			_Map.setPoint3dArray("ptAllStrapsExtrusionPoints",ptAllStrapsExtrusionPoints);
			_Map.setPoint3dArray("ptAllStrapsDirectionPoints", ptAllStrapsDirectionPoints);
			
			bmAllTransfersToStretchAtTop.setLength(0); // Erase array for improving performance
	
			// Creating new studs
			Point3d ptNewBmCenter, ptNewTransferBmCenter;
			Vector3d vBmX=vTDSy;
			Vector3d vBmY=vTDSx;
			Vector3d vBmZ=vTDSz;
			double dBmLength=U(25,1); // Just for creating beams. They will be stretched to other beams
			
			// Studs at left side
			// Center points for studs		
			// Vertical alignment
			ptNewBmCenter=_Pt0+vTDSy*vTDSy.dotProduct(ptTopOfBottomPlates-_Pt0); // Align to top of bottom plates		
			ptNewBmCenter+=vTDSy*U(25,1); // elevating a few to strech them later
			
			// Depth in wall alignment
			ptNewBmCenter+=vTDSz*vTDSz.dotProduct(ptSideOfWall-ptNewBmCenter); // Align to wall face
			ptNewBmCenter-=vSideOfWall*dBmHeight*.5;
	
			// Lateral alignment
			ptNewBmCenter-=vTDSx*(dClearDistance*.5+dBmWidth*.5);
	
			// Center points for transfer beams
			// Vertical alignment
			ptNewTransferBmCenter=_Pt0+vTDSy*vTDSy.dotProduct(ptTopOfTopPlates-_Pt0); // Align to top of top plates		
			ptNewTransferBmCenter+=vTDSy*U(25,1); // elevating a few to strech them later
			// Depth in wall alignment
			ptNewTransferBmCenter+=vTDSz*vTDSz.dotProduct(ptSideOfWall-ptNewTransferBmCenter); // Align to wall face
			ptNewTransferBmCenter-=vSideOfWall*dBmHeight*.5;
			// Lateral alignment
			ptNewTransferBmCenter-=vTDSx*(dClearDistance*.5+dBmWidth*.5);
					
			for( int n=0; n<nStudsLeft;n++)
			{
				Beam bmNew;
				bmNew.dbCreate(ptNewBmCenter, vBmX, vBmY, vBmZ, dBmLength, dBmWidth, dBmHeight,1,0,0);
				bmNew.setColor(nBmColor);
				bmNew.setMaterial(sBmMaterial);
				bmNew.setGrade(sBmGrade);
				bmNew.setModule(sBmModule);
				bmNew.setInformation(sBmInformation);
	
				// Stretching to top and bottom plates making sure this new beam has right length
				Beam arBeamHitTops[] = Beam().filterBeamsHalfLineIntersectSort(bmTopPlates, bmNew.ptCen() , vTDSy);
				if (arBeamHitTops.length()>0) 
				{
					Beam bmHitTop = arBeamHitTops[0];
					bmNew.stretchStaticTo(bmHitTop, 1);
				}
				Beam arBeamHitBottoms[] = Beam().filterBeamsHalfLineIntersectSort(bmBottomPlates, bmNew.ptCen() , -vTDSy);
				if (arBeamHitBottoms.length()>0) 
				{
					Beam bmHitBottom = arBeamHitBottoms[0];
					bmNew.stretchStaticTo(bmHitBottom,1);
				}
				_Beam.append(bmNew); // To erase later if needed
				bmCreated.append(bmNew); // For horizontal blocking
				bmNew.assignToElementGroup(el, 1, 0, 'Z');
				ptNewBmCenter-=vTDSx*dBmWidth;
	
				// Creating transference beams from flor system (between elements)
				if( nBlocking)
				{	
					if(e < elAll.length()-1) // Element is not top
					{
						Beam bmTransfer;
						bmTransfer.dbCreate(ptNewTransferBmCenter, vBmX, vBmY, vBmZ, dBmLength, dBmWidth, dBmHeight,1,0,0);				
						bmTransfer.setColor(nBmColor);
						bmTransfer.setMaterial(sBmMaterial);
						bmTransfer.setGrade(sBmGrade);
						bmTransfer.setModule(sBmModule);
						bmTransfer.setInformation(sBmInformation);					
						
						// Stretching to bottom plate OF THIS ELEMENT ONLY, later we need to stetch it to bottom of upper element
						Beam bmAllToStretchOnBottom[]=Beam().filterBeamsHalfLineIntersectSort(bmTopPlates, bmTransfer.ptCen(), -_ZW);
						if( bmAllToStretchOnBottom.length()>0)
						{
							Beam bmToStretchBottom=bmAllToStretchOnBottom[0];
							bmTransfer.stretchDynamicTo(bmToStretchBottom);
							
							// Define which transfer needs a strap
							Map subMapX;
							subMapX.setInt("HAVESTRAP",1);
							if( nStudsLeft==1) // only one strap is needed
							{
								bmTransfer.setSubMapX("SUBMAP",subMapX);
							}
							else if(nStudsLeft>1)// 2 straps are needed
							{	
								if( nStudsLeft==2 && n==nStudsLeft-1) // only one strap is needed at last beam
								{
									bmTransfer.setSubMapX("SUBMAP",subMapX);
								}
								else if( nStudsLeft>2) // two straps are needed
								{
									if (n==0 || n==nStudsLeft-1) // at first and last beams
									{
										bmTransfer.setSubMapX("SUBMAP",subMapX);
									}
								}
							}											
						}
						_Beam.append(bmTransfer); // To erase on _bOnElementDeleted
						bmTransfer.assignToElementGroup(el, 1, 0, 'Z');
						ptNewTransferBmCenter-=vTDSx*dBmWidth;
	
						bmAllTransfersToStretchAtTop.append(bmTransfer);
					}
				}
				
			} // End creating studs at left
					
			// Studs at righ side
			// Center points for studs
			// Vertical alignment
			ptNewBmCenter=_Pt0+vTDSy*vTDSy.dotProduct(ptTopOfBottomPlates-_Pt0); // Align to top of bottom plates		
			ptNewBmCenter+=vTDSy*U(25,1); // elevating a few to strech them later
			
			// Depth in wall alignment
			ptNewBmCenter+=vTDSz*vTDSz.dotProduct(ptSideOfWall-ptNewBmCenter); // Align to wall face
			ptNewBmCenter-=vSideOfWall*dBmHeight*.5;
	
			// Lateral alignment
			ptNewBmCenter+=vTDSx*(dClearDistance*.5+dBmWidth*.5);
	
			// Center points for transfer beams
			// Vertical alignment
			ptNewTransferBmCenter=_Pt0+vTDSy*vTDSy.dotProduct(ptTopOfTopPlates-_Pt0); // Align to top of top plates		
			ptNewTransferBmCenter+=vTDSy*U(25,1); // elevating a few to strech them later
			// Depth in wall alignment
			ptNewTransferBmCenter+=vTDSz*vTDSz.dotProduct(ptSideOfWall-ptNewTransferBmCenter); // Align to wall face
			ptNewTransferBmCenter-=vSideOfWall*dBmHeight*.5;
			// Lateral alignment
			ptNewTransferBmCenter+=vTDSx*(dClearDistance*.5+dBmWidth*.5);
			
			for( int n=0; n<nStudsRight;n++)
			{
				Beam bmNew;
				bmNew.dbCreate(ptNewBmCenter, vBmX, vBmY, vBmZ, dBmLength, dBmWidth, dBmHeight,1,0,0);
				bmNew.setColor(nBmColor);
				bmNew.setMaterial(sBmMaterial);
				bmNew.setGrade(sBmGrade);
				bmNew.setModule(sBmModule);
				bmNew.setInformation(sBmInformation);
	
				// Stretching to top and bottom plates making sure this new beam has right length
				Beam arBeamHitTops[] = Beam().filterBeamsHalfLineIntersectSort(bmTopPlates, bmNew.ptCen() , vTDSy);
				if (arBeamHitTops.length()>0) 
				{
					Beam bmHitTop = arBeamHitTops[0];
					bmNew.stretchStaticTo(bmHitTop, 1);
				}
				Beam arBeamHitBottoms[] = Beam().filterBeamsHalfLineIntersectSort(bmBottomPlates, bmNew.ptCen() , -vTDSy);
				if (arBeamHitBottoms.length()>0) 
				{
					Beam bmHitBottom = arBeamHitBottoms[0];
					bmNew.stretchStaticTo(bmHitBottom,1);
				}
				_Beam.append(bmNew); // To erase later if needed
				bmCreated.append(bmNew); // For horizontal blocking
				bmNew.assignToElementGroup(el, 1, 0, 'Z');
				ptNewBmCenter+=vTDSx*dBmWidth;
	
				// Creating transference beams from flor system (between elements)
				if( nBlocking)
				{	
					if(e < elAll.length()-1) // Element is not top
					{
						Beam bmTransfer;
						bmTransfer.dbCreate(ptNewTransferBmCenter, vBmX, vBmY, vBmZ, dBmLength, dBmWidth, dBmHeight,1,0,0);				
						bmTransfer.setColor(nBmColor);
						bmTransfer.setMaterial(sBmMaterial);
						bmTransfer.setGrade(sBmGrade);
						bmTransfer.setModule(sBmModule);
						bmTransfer.setInformation(sBmInformation);					
						
						// Stretching to bottom plate OF THIS ELEMENT ONLY, later we need to stetch it to bottom of upper element
						Beam bmAllToStretchOnBottom[]=Beam().filterBeamsHalfLineIntersectSort(bmTopPlates, bmTransfer.ptCen(), -_ZW);
						if( bmAllToStretchOnBottom.length()>0)
						{
							Beam bmToStretchBottom=bmAllToStretchOnBottom[0];
							bmTransfer.stretchDynamicTo(bmToStretchBottom);
	
							// Define which transfer needs a strap
							Map subMapX;
							subMapX.setInt("HAVESTRAP",1);
							if( nStudsRight==1) // only one strap is needed
							{
								bmTransfer.setSubMapX("SUBMAP",subMapX);
							}
							else if(nStudsRight>1)// 2 straps are needed
							{	
								if( nStudsRight==2 && n==nStudsRight-1) // only one strap is needed at last beam
								{
									bmTransfer.setSubMapX("SUBMAP",subMapX);
								}
								else if( nStudsRight>2) // two straps are needed
								{
									if (n==0 || n==nStudsRight-1) // at first and last beams
									{
										bmTransfer.setSubMapX("SUBMAP",subMapX);
									}
								}
							}
						}
						_Beam.append(bmTransfer); // To erase on _bOnElementDeleted
						bmTransfer.assignToElementGroup(el, 1, 0, 'Z');
						ptNewTransferBmCenter+=vTDSx*dBmWidth;
						
						bmAllTransfersToStretchAtTop.append(bmTransfer);
					}
				}
				
			} // End creating studs at right
			
			// Work with blocking
			vx=vTDSx;
			Point3d ptMostLeftToClean=_Pt0-vTDSx*(dClearDistance*.5+dBmWidth*nStudsLeft);
			Point3d ptMostRightToClean=_Pt0+vTDSx*(dClearDistance*.5+dBmWidth*nStudsRight);
			Body bdSearchBlocking=bdClean;
			//(ptBdCleanOrg, vCleanX, vCleanY, vCleanZ, dBdSearchBlockX, dBdCleanY, dBdCleanZ, 0, 1, 0);
			bdSearchBlocking.vis(3);
	
			for (int b=0; b<bmHorizontals.length(); b++)
			{
				Beam bmBlocking= bmHorizontals[b];
				if( bmBlocking.type() == _kSFBlocking || bmBlocking.type() == _kBlocking)
				{
					Body bdBlocking= bmBlocking.envelopeBody();
						bmBlocking.envelopeBody().vis();
					if( bdBlocking.hasIntersection(bdSearchBlocking))
					{
						Point3d ptBlockingLeft= bmBlocking.ptCen()-vx*bmBlocking.dL()*.5;
						Point3d ptBlockingRight= bmBlocking.ptCen()+vx*bmBlocking.dL()*.5;
						// There are some possible situations ( one per time only) for blocking:
		
						// 1 - Totally contained in area to clean - must be erased
						if( vx.dotProduct( ptBlockingLeft - ptMostLeftToClean ) >= 0 // left point of blocking is contained in clean area
						&& vx.dotProduct( ptMostRightToClean - ptBlockingRight ) >= 0 ) // right point of blocking is contained in clean area
							bmBlocking.dbErase();
		
						// 2 - Area to clean is between blocking right and left points - blocking will be splitted in 2 pieces separated by clean area
						else if( vx.dotProduct( ptMostLeftToClean - ptBlockingLeft ) > 0 // left point of is contained in blocking
						&& vx.dotProduct( ptBlockingRight - ptMostRightToClean ) > 0 ) // right point of clean area is contained in blocking
						{
							Beam bmCopy;
							bmCopy=bmBlocking.dbCopy();
							// Left cut applied to original beam
							Cut ctLeft( ptMostLeftToClean, vx);
							bmBlocking.addToolStatic(ctLeft, 1);
							// Right cut applied to copied beam
							Cut ctRight( ptMostRightToClean, -vx);
							bmCopy.addToolStatic(ctRight, 1);
						}
							
						// 3 - Area to clean is on left part of blocking - blocking will be streched
						else if( vx.dotProduct( ptBlockingLeft - ptMostLeftToClean ) > 0 // blocking left point is at right of clean area left point
						&& vx.dotProduct( ptMostRightToClean - ptBlockingLeft ) > 0 ) // blocking left point is at left of clean area right point
						{
							Cut ctLeft( ptMostRightToClean, -vx);
							bmBlocking.addToolStatic(ctLeft, 1);
						}
						// 4 - Area to clean is on right part of blocking - blocking will be streched				
						else if( vx.dotProduct( ptBlockingRight - ptMostLeftToClean ) > 0 // blocking right point is at right of clean area left point
						&& vx.dotProduct( ptMostRightToClean - ptBlockingRight ) > 0 ) // blocking right point is at left of clean area right point
						{
							Cut ctRight( ptMostLeftToClean, vx);
							bmBlocking.addToolStatic(ctRight, 1);
						}
						// 5 - Blocking was not modified by clean area: 
						//      Some of them won't be on cleaning area but possibly the beam it was attached to was erase, 
						//      then need to be streched to closest beams at right and left to fill this space
						else if( vx.dotProduct( ptMostLeftToClean - ptBlockingRight ) <= dBmHeight) // blocking is at left of clean area
						{
							Beam bmAllToStretch[]=Beam().filterBeamsHalfLineIntersectSort(bmCreated, ptBlockingRight, vx);
							if( bmAllToStretch.length()>0)
							{
								Beam bmToStretch=bmAllToStretch[0];
								bmBlocking.stretchStaticTo(bmToStretch, 1);
							}
						}
						else if( vx.dotProduct( ptMostRightToClean - ptBlockingLeft ) <= dBmHeight) // blocking is at right of clean area
						{
							Beam bmAllToStretch[]=Beam().filterBeamsHalfLineIntersectSort(bmCreated, ptBlockingRight, -vx);
							if( bmAllToStretch.length()>0)
							{
								Beam bmToStretch=bmAllToStretch[0];
								bmBlocking.stretchStaticTo(bmToStretch, 1);
							}
						}
						else // Something is wrong, blocking will be red colored
						{
							bmBlocking.setColor(1);
						}
					}
				}
			}// End of work with blocking
		}
	}// end of work for every element for( int e= 0; e<elAll.length(); e++)
	_Map.setInt("ExecutionMode",1);
} // END if( _bOnInsert || _bOnElementConstructed || _bOnRecalc || !_Map.getInt("ExecutionMode"))

// Displaying

// Get all info from _Map to display
// Rods
Point3d ptAllRodsStartPoints[]=_Map.getPoint3dArray("ptAllRodsStartPoints");
Point3d ptAllRodsEndPoints[]=_Map.getPoint3dArray("ptAllRodsEndPoints");
// Nuts
Point3d ptAllNutsBasePoints[]=_Map.getPoint3dArray("ptAllNutsBasePoints");
Point3d ptAllNutsExtrusionPoints[]=_Map.getPoint3dArray("ptAllNutsExtrusionPoints");
Point3d ptAllNutsDirectionPoints[]=_Map.getPoint3dArray("ptAllNutsDirectionPoints");
// Square metal blocks
Point3d ptAllSquareBlocksBasePoints[]=_Map.getPoint3dArray("ptAllSquareBlocksBasePoints");
Point3d ptAllSquareBlocksExtrusionPoints[]=_Map.getPoint3dArray("ptAllSquareBlocksExtrusionPoints");
Point3d ptAllSquareBlocksDirectionPoints[]=_Map.getPoint3dArray("ptAllSquareBlocksDirectionPoints");
// Square washers
Point3d ptAllSquareWashersBasePoints[]=_Map.getPoint3dArray("ptAllSquareWashersBasePoints");
Point3d ptAllSquareWashersExtrusionPoints[]=_Map.getPoint3dArray("ptAllSquareWashersExtrusionPoints");
Point3d ptAllSquareWashersDirectionPoints[]=_Map.getPoint3dArray("ptAllSquareWashersDirectionPoints");
//Couplers
Point3d ptAllCouplersBasePoints[]=_Map.getPoint3dArray("ptAllCouplersBasePoints");
Point3d ptAllCouplersExtrusionPoints[]=_Map.getPoint3dArray("ptAllCouplersExtrusionPoints");
Point3d ptAllCouplersDirectionPoints[]=_Map.getPoint3dArray("ptAllCouplersDirectionPoints");
//Tuds
Point3d ptAllTudsBasePoints[]=_Map.getPoint3dArray("ptAllTudsBasePoints");
Point3d ptAllTudsExtrusionPoints[]=_Map.getPoint3dArray("ptAllTudsExtrusionPoints");
Point3d ptAllTudsDirectionPoints[]=_Map.getPoint3dArray("ptAllTudsDirectionPoints");

//Straps
Point3d ptAllStrapsCenterPoints[]=_Map.getPoint3dArray("ptAllStrapsCenterPoints");
Point3d ptAllStrapsExtrusionPoints[]=_Map.getPoint3dArray("ptAllStrapsExtrusionPoints");
Point3d ptAllStrapsDirectionPoints[]=_Map.getPoint3dArray("ptAllStrapsDirectionPoints");

Display dp(7);

//Draw rods
for(int r=0;r<ptAllRodsStartPoints.length();r++)
{
	Point3d ptRodStart=ptAllRodsStartPoints[r];
	Point3d ptRodEnd=ptAllRodsEndPoints[r];
	Body bdRod(ptRodStart, ptRodEnd, dRodDiameter*.5);
	dp.draw(bdRod);
}

// Draw nuts
for(int n=0;n<ptAllNutsBasePoints.length();n++)
{
	double dRadius= dNutSideLength*.5;
	double dAngle=60;
	Point3d ptBase=ptAllNutsBasePoints[n];
	Point3d ptExtrude=ptAllNutsExtrusionPoints[n];
	Point3d ptDirection= ptAllNutsDirectionPoints[n];
	Vector3d vExtrude(ptExtrude-ptBase);vExtrude.normalize();
	Vector3d vDirection(ptDirection-ptBase);vDirection.normalize();
	Vector3d vVertex= vExtrude.crossProduct(vDirection);

	PLine plEx;
	for(int s=0;s<6;s++)
	{
		Point3d pt=ptBase+vVertex*dRadius;
		plEx.addVertex(pt);
			vVertex=vVertex.rotateBy(60, _ZW);
		
	}
	plEx.close();
	Body bdNut ( plEx, vExtrude*dNutSideHeight, 1);
	dp.draw(bdNut);
}
	
//Draw square blocks
for(int n=0;n<ptAllSquareBlocksBasePoints.length();n++)
{
	Point3d ptBase=ptAllSquareBlocksBasePoints[n];
	Point3d ptExtrude=ptAllSquareBlocksExtrusionPoints[n];
	Point3d ptDirection= ptAllSquareBlocksDirectionPoints[n];
	Vector3d vExtrude(ptExtrude-ptBase);vExtrude.normalize();
	Vector3d vDirection(ptDirection-ptBase);vDirection.normalize();
	Vector3d vVertex= vExtrude.crossProduct(vDirection);

	PLine plEx;
	vVertex=vVertex.rotateBy(45, _ZW);
	for(int s=0;s<4;s++)
	{
		Point3d pt=ptBase+vVertex*dSquareBlockSideLength;
		plEx.addVertex(pt);
			vVertex=vVertex.rotateBy(90, _ZW);
		
	}
	plEx.close();
	Body bdSquareBlock( plEx, vExtrude*dSquareBlockSideHeight, 1);
	dp.draw(bdSquareBlock);
}

//Draw square washers
for(int n=0;n<ptAllSquareWashersBasePoints.length();n++)
{
	Point3d ptBase=ptAllSquareWashersBasePoints[n];
	Point3d ptExtrude=ptAllSquareWashersExtrusionPoints[n];
	Point3d ptDirection= ptAllSquareWashersDirectionPoints[n];
	Vector3d vExtrude(ptExtrude-ptBase);vExtrude.normalize();
	Vector3d vDirection(ptDirection-ptBase);vDirection.normalize();
	Vector3d vVertex= vExtrude.crossProduct(vDirection);

	PLine plEx;
	vVertex=vVertex.rotateBy(45, _ZW);
	for(int s=0;s<4;s++)
	{
		Point3d pt=ptBase+vVertex*dSquareWasherSideLength;
		plEx.addVertex(pt);
			vVertex=vVertex.rotateBy(90, _ZW);		
	}
	plEx.close();
	Body bdSquareWasher( plEx, vExtrude*dSquareWasherSideHeight, 1);
	dp.draw(bdSquareWasher);
}

// Draw couplers
for(int n=0;n<ptAllCouplersBasePoints.length();n++)
{
	double dRadius= dCouplerSideLength*.5;
	double dAngle=60;
	Point3d ptBase=ptAllCouplersBasePoints[n];
	Point3d ptExtrude=ptAllCouplersExtrusionPoints[n];
	Point3d ptDirection= ptAllCouplersDirectionPoints[n];
	Vector3d vExtrude(ptExtrude-ptBase);vExtrude.normalize();
	Vector3d vDirection(ptDirection-ptBase);vDirection.normalize();
	Vector3d vVertex= vExtrude.crossProduct(vDirection);

	PLine plEx;
	for(int s=0;s<6;s++)
	{
		Point3d pt=ptBase+vVertex*dRadius;
		plEx.addVertex(pt);
			vVertex=vVertex.rotateBy(60, _ZW);
		
	}
	plEx.close();
	Body bdCoupler ( plEx, vExtrude*dCouplerSideHeight, 0);
	dp.draw(bdCoupler);
}
	
// Draw tuds
for(int n=0;n<ptAllTudsBasePoints.length();n++)
{
	double dRadius= dTudDiameter*.5;
	Point3d ptBase=ptAllTudsBasePoints[n];
	Point3d ptExtrude=ptAllTudsExtrusionPoints[n];
	Vector3d vExtrude(ptExtrude-ptBase);vExtrude.normalize();

	PLine plEx;
	plEx.createCircle(ptBase, ptExtrude, dRadius);
	Body bdTud ( ptBase, ptBase+vExtrude*dTudSideHeight, dRadius);
	dp.draw(bdTud);
}

//Draw straps
for(int n=0;n<ptAllStrapsCenterPoints.length();n++)
{
	Point3d ptCenter=ptAllStrapsCenterPoints[n];
	Point3d ptExtrude=ptAllStrapsExtrusionPoints[n];
	Point3d ptDirection= ptAllStrapsDirectionPoints[n];
	Vector3d vExtrude(ptExtrude-ptCenter);vExtrude.normalize();
	Vector3d vDirection(ptDirection-ptCenter);vDirection.normalize();
	Vector3d vVertex= vExtrude.crossProduct(vDirection);

	PLine plEx;
	Point3d pt=ptCenter;
	pt+=vDirection*dStrapLength*.5+vVertex*dStrapWidth*.5;
	plEx.addVertex(pt);
	pt+=-vDirection*dStrapLength;
	plEx.addVertex(pt);
	pt+=-vVertex*dStrapWidth;
	plEx.addVertex(pt);
	pt+=vDirection*dStrapLength;
	plEx.addVertex(pt);
	plEx.close();
	Body bdStrap( plEx, vExtrude*dStrapDepth, 1);
	dp.draw(bdStrap);
}

if(_bOnDebug)
{
	Vector3d vTDSx=_Map.getVector3d("vTDSx");
	Vector3d vTDSy=_Map.getVector3d("vTDSy");
	Vector3d vTDSz=_Map.getVector3d("vTDSz");
	PLine plClean=_Map.getPLine("PL_CLEAN_AREA");
	Body bdTDS(plClean, vTDSy*dSearchHeight,1);
	bdTDS.vis();
}







#End
#BeginThumbnail
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
>1110`4444`%%%%`!1110`4444`%%%%`!1110!__9
`








#End
