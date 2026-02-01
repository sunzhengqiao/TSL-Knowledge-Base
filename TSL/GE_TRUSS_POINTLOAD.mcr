#Version 8
#BeginDescription
Createss point load structure for TRUSS ENTITIES and WALLS below to them. 
v2.2: 07.may.2014: David Rueda (dr@hsb-cad.com)


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 2
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
*
* v2.2: 07.may.2014: David Rueda (dr@hsb-cad.com) 
	- Dropdown for lumber selection shows now THICKNESS+MATERIAL+GRADE+TREATMENT (if not null)
	- Cleaning area set for new values
	- Fixing of blocking set for new values
	- Applying new lumber items properties per element
	- Validation of beam width properly according to wall (wall in)
	- Correcting value for beam width if not found on inventory. Set to be as wall
	- Report message with detailed information of what was wrong and how beams are set
* v2.1: 04.may.2014: David Rueda (dr@hsb-cad.com) 
	- Added options for studs number: plies in girder/plies in girder +1
	- Added color NAMES dropdown for new beam colors
* v2.00: 29.apr.2014: David Rueda (dr@hsb-cad.com) 
	Major changes:
	- Hardware insertion comment out (but still present for the future)
	- Rules for framing and adding hardware based on uplifts comented out, relocating code to maintaing needed functionality
	- Added feature to select from 1 to up 10 studs
	- Added material to new studs, info from selected dropdown from defaults editor
	- Added grade to new studs, info from selected dropdown from defaults editor (one drop down only provides info for material and grade)
	- Added input for post assembly name as string and set to new studs
	- Added option to use/not studs between floors
	- Added unique module ID per assemblies on elements

	The following was settings BEFORE changes in this v2.0 (not valid anymore) :
		Studs, wall hold downs, anchors, MSTA straps and TWIST straps will be inserted according to HEEL HEIGHT and UPLIFT REACTION values. 
		Also, displays information of what is created by floor level. It is visible on "Wall Layout Items" display representation only.
		PLEASE NOTICE!: This tsl needs these tsl's in order to work properly
		GE_HDWR_WALL_ANCHOR
		GE_HDWR_STRAP_TWIST_HTS
		GE_HDWR_STRAP_TSA_ENHANCED
		GE_HDWR_WALL_HOLD_DOWN
		GE_PLOT_POINTLOAD_INFO

* v1.22: 03.nov.2013: David Rueda (dr@hsb-cad.com)
	- Stickframe path added to mapIn when calling dll
* v1.21: 26.mar.2013: David Rueda (dr@hsb-cad.com)
	- Children TSL's names updated to follow new TSL naming standards, new children: 
		GE_HDWR_WALL_ANCHOR
		GE_HDWR_STRAP_TWIST_HTS
		GE_HDWR_STRAP_TSA_ENHANCED
		GE_HDWR_WALL_HOLD_DOWN
		GE_PLOT_POINTLOAD_INFO
* v1.20: 26.ago.2012: David Rueda (dr@hsb-cad.com)
	- Description updated
* v1.19: 26.ago.2012: David Rueda (dr@hsb-cad.com)
	- Version control
* v1.18: 15.jul.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Thumbnail added
* v1.17: 15.feb.2012: David Rueda (dr@hsb-cad.com): 	
	- Changed children tsl to separate general and customer verions:
		* Before: TH_HTS_TWIST_STRAPS now: GE_HDWR_HTS_TWIST_STRAPS
		* Before: TH_MSTA_STRAPS now: GE_HDWR_MSTA_STRAPS
		* Before: TH_WALL_HOLD_DOWN now: GE_HDWR_WALL_HOLD_DOWN
* v1.16: 16.dec.2011: David Rueda (dr@hsb-cad.com): 	- Granted that HTS20 strap will have a beam with room enought to be nailed when is placed
* v1.15: 14.dec.2011: David Rueda (dr@hsb-cad.com): 	- Added cloning process to display connector H2.5T at truss with GE_PLOT_POINTLOAD_INFO tsl ONLY WHEN THERE ARE 2 H2.5T
* v1.14: 14.dec.2011: David Rueda (dr@hsb-cad.com): 	- Set to place HTS20 with its middle point located on top of higher top plate
* v1.13: 13.dec.2011: David Rueda (dr@hsb-cad.com): 	- Bugfix: when truss is not a complete triangle, but one half only, MSTA strap was being inserted with an odd offset from face of wall. This
															  was solved using the highest point of truss as reference instead of center of body to define which side of wall must have the MSTA inserted. 
															- Set to place H2.5T starting from bottom of lower top plate
* v1.12: 24.oct.2011: David Rueda (dr@hsb-cad.com): 	Added cloning process to display connector at truss with GE_PLOT_POINTLOAD_INFO tsl 
															Changed erasing child tsl's: will be taken all tsl's from group and delete according to handle inserted by this tsl
* v1.11: 18.oct.2011: David Rueda (dr@hsb-cad.com): 	Problem with creating new studs at sides of opening solved
															Problem placing straps in middle of wall instead on system floor height solved
* v1.10: 09.oct.2011: David Rueda (dr@hsb-cad.com): 	Problem with some new studs length fixed
															Set dialog values to last inserted
* v1.9: 09.oct.2011: David Rueda (dr@hsb-cad.com): 	Set dialog values to default
* v1.8: 07.oct.2011: David Rueda (dr@hsb-cad.com): 	Passing values to GE_PLOT_POINTLOAD_INFO tsl to display
* v1.7: 04.oct.2011: David Rueda (dr@hsb-cad.com): 	HST_TWIST_STRAP will be placed starting from bottom of lower top plate
* v1.6: 20.sep.2011: David Rueda (dr@hsb-cad.com): 	Floor hold downs will be inserted only when wall is on the floor
* v1.5: 20.sep.2011: David Rueda (dr@hsb-cad.com): 	Icon display modyfied to be seen only on "Wall Layout Items" display representation
* v1.4: 31.ago.2011: David Rueda (dr@hsb-cad.com): 	Display added
* v1.3: 31.ago.2011: David Rueda (dr@hsb-cad.com): 	Floor to floor straps are centered between floors
* v1.2: 30.ago.2011: David Rueda (dr@hsb-cad.com): 	Customer can select anchor type to be used on wall hold down by Automatic or Manual values
* v1.1: 27.jun.2011: David Rueda (dr@hsb-cad.com): 	Get back to original children tsl's (customer use them only):
															- TH_HTS_TWIST_STRAPS instead GE_HDWR_HTS_TWIST_STRAPS
															- TH_MSTA_STRAPS instead GE_HDWR_MSTA_STRAPS
															- TH_WALL_HOLD_DOWN instead GE_HDWR_WALL_HOLD_DOWN
* v1.0: 27.may.2011: David Rueda (dr@hsb-cad.com): 	Release
* v0.7: 26.may.2011: David Rueda (dr@hsb-cad.com): 	All metalparts erased when erase construction of elements (avoids duplicates)
* v0.6: 26.may.2011: David Rueda (dr@hsb-cad.com): 	Transfer beams form wall to wall created
															Performance improved
* v0.5: 25.may.2011: David Rueda (dr@hsb-cad.com): 	Bugfix: erasing interfering studs solved
															Display for MS and PS added
															Hold down is now attached to all new beams
* v0.4: 23.may.2011: David Rueda (dr@hsb-cad.com): 	Bugfix: straps were not placed on new studs when erased beam was sheeting joint 
* v0.3: 23.may.2011: David Rueda (dr@hsb-cad.com): 	Added extra stud when erased beam was sheeting joint 
* v0.2: 23.may.2011: David Rueda (dr@hsb-cad.com): 	Beams interference solved
* v0.1: 23.may.2011: David Rueda (dr@hsb-cad.com): 	Release candidate

*/
int nLunits=U(2,4);
int nPrec=U(2,3);

String sLumberSpecies[0], sLumberGrades[0];

// Calling dll to fill item lumber prop.
Map mapIn;

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

Map mapOut = callDotNetFunction2(sAssemblyPath, sClassName, sFunction, mapIn);
mapOut.writeToDxxFile("c:\\shared\\tmp.dxx");
// filling lumber items
String sLumberItemKeys[0];
String sLumberItemNames[0];
String sLumberItemNamesNoThickness[0];

for( int m=0; m<mapOut.length(); m++)
{
	String sKey= mapOut.keyAt(m);
	String sName= mapOut.getString(sKey+"\NAME");
	String sThickness, sSpecies, sGrade, sTreatment, sLumberItemNameNoThickness;
	double dThickness;
	if( sKey!="" && sName!="")
	{
		sLumberItemKeys.append( sKey );
		sLumberItemNames.append( sName);
		dThickness=mapOut.getDouble(sKey+"\WIDTH");
		sThickness.formatUnit(dThickness,nLunits,nPrec);

		sSpecies=mapOut.getString(sKey+"\SPECIES\NAME");
		sGrade=mapOut.getString(sKey+"\GRADE\NAME");
		sTreatment=mapOut.getString(sKey+"\TREATMENT\NAME");
		if(sTreatment.makeUpper() =="NONE")
			sTreatment="";
		sLumberItemNameNoThickness= sThickness+" x "+sSpecies+" "+sGrade+" "+sTreatment;
		sLumberItemNamesNoThickness.append(sLumberItemNameNoThickness);
	}
}

String sLumberItemNamesNoThicknessDisplay[0];
sLumberItemNamesNoThicknessDisplay=sLumberItemNamesNoThickness;
for(int i=0;i<sLumberItemNamesNoThicknessDisplay.length();i++)
{
	for(int j=sLumberItemNamesNoThicknessDisplay.length()-1;j>i;j--)
	{
		if(sLumberItemNamesNoThicknessDisplay[i]==sLumberItemNamesNoThicknessDisplay[j])
		{
			sLumberItemNamesNoThicknessDisplay.removeAt(j);
		}
	}
}
	

String sTab="     ";
String sNoYes[]={T("|No|"), T("|Yes|")};

String sColors[0]; int nColors[0];
sColors.append(T("|Default brown|")+" ("+"32)");					nColors.append(32);
sColors.append(T("|Light brown|")+" ("+"40)");					nColors.append(40);
sColors.append(T("|White|"));										nColors.append(0);
sColors.append(T("|Red|"));										nColors.append(1);
sColors.append(T("|Yellow|"));									nColors.append(2);
sColors.append(T("|Green|"));										nColors.append(3);
sColors.append(T("|Cyan|"));										nColors.append(4);
sColors.append(T("|Blue|"));										nColors.append(5);
sColors.append(T("|Magenta|"));									nColors.append(6);

PropString sEmpty0(0, "", T("|Lumber info|"));sEmpty0.setReadOnly(1);

PropString sBmLumberItem(1, sLumberItemNamesNoThicknessDisplay, sTab+sTab+T("|Lumber Item|"),0);
//PropString sBmLumberItem(1, sLumberItemNames, sTab+sTab+T("|Lumber Item|"),0);
String sNumbers[]={T("|Number of plies in girder|"),T("|Number of plies in girder +1|"),1,2,3,4,5,6,7,8,9,10};
PropString sBmNumber(2,sNumbers,sTab+sTab+T("|New Beams Qty.|"),0);
PropString sBmInformation(3,"",sTab+sTab+T("|Post Assembly Name|"),1);
PropString sBmColor(4, sColors, sTab+sTab+T("|Beam color|"), 5);
int nIndex= sColors.find(sBmColor, 0);
int nBmColor= nColors[nIndex];
PropString sEmpty4(5, "  ", T("|Extra features|"));
sEmpty4.setReadOnly(1);
PropDouble dLateralOff(0, 0, sTab+sTab+T("|Lateral offset|"));
dLateralOff.setDescription(T("|To right or left side of WALL. Can be positive or negative value|"));
PropString sUseTransferBeams(6,sNoYes,sTab+sTab+T("|Create studs between floors|"),0);

/*
PropString sLumberSpecie(1, sLumberSpecies, sTab+T("|Lumber species|"),0);
PropString sLumberGrade(2, sLumberGrades, sTab+T("|Lumber grade|"),0);
PropString sEmpty1(3, " ", T("|Floor to floor MSTA strap|"));
sEmpty1.setReadOnly(1);
PropString sForceToCS16(4,sNoYes,sTab+T("|Force to|")+" CS16",0);

PropString sEmpty2(5, "  ", T("|Anchor|"));
sEmpty2.setReadOnly(1);
String arAutoManual[]={"Automatic","Manual"};
PropString strAutoManual(6,arAutoManual,sTab+"Anchor selection",0);
int nAutoManual=arAutoManual.find(strAutoManual,0);
String arRodTypes[]={"3/8\" ATC Rod" , "1/2\" ATC Rod" , "5/8\" ATC Rod" , "3/8\" Bottom Plate Anchor" , "1/2\" Bottom Plate Anchor" , "5/8\" Bottom Plate Anchor" , "7/8\" Bottom Plate Anchor" , "3/8\" x 6\" Screw Anchor", "1/2\" x 6\" Screw Anchor", "1/2\" x 12\" Screw Anchor"};
PropString sRodTypes(7, arRodTypes, sTab+"Anchor type (when manual selection)",0);
int nRodType=arRodTypes.find(sRodTypes,0);

PropString sEmpty3(8, "  ", T("|Display|"));
sEmpty3.setReadOnly(1);
PropString sDimstyle(9, _DimStyles,T("|Dimstyle|"),7);
PropInt nDisplayColor(1,-1,sTab+T("|Color|"));
*/

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey); 

if(_bOnInsert)
{
	PrEntity ssTr("\n"+T("|Select truss(es)|"), TrussEntity());
	if(ssTr.go())
	{
		_Entity.append(ssTr.set());
	}
	
	if(_Entity.length()==0)
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
	
	showDialogOnce(T("_LastInserted"));

	
	// Getting truss
	for(int en=0; en<_Entity.length();en++)
	{
		TrussEntity teTruss;
		if(_Entity[en].bIsKindOf(TrussEntity()))
		{
			teTruss= (TrussEntity)_Entity[en];
		}
		else
			continue;

		String strDefinition = teTruss.definition();
		TrussDefinition trussDefinition(strDefinition);
		CoordSys csTruss= teTruss.coordSys();
		
		// Getting all beams representations
		Beam bmAllInTruss[]=trussDefinition.beam();
		Beam bmAllInTrussForcedCopy[0],bmAllInTrussForcedErase[0]; // For some reason dbCopy does not return a beam inside next loop, must force a dbCreate
		Beam bmVerticalsOnTruss[0];
		Vector3d vSupportX;
		//PlaneProfile ppTruss;
				
		Body bdSupport;
		for (int b=0; b< bmAllInTruss.length(); b++)
		{
			Beam bm= bmAllInTruss[b];
			Body bdBm= bm.realBody();
			bdBm.transformBy(csTruss);
			Vector3d vBdX=bm.vecX();
			vBdX.transformBy(csTruss);		
			bdSupport.combine(bdBm);
			if( !vBdX.isParallelTo( _ZW)) // Bm is any but vertical
			{
				vSupportX= vBdX; // Any vector but vertical will work, we need horizontal direction only
			}
			else
			{
				bmVerticalsOnTruss.append(bm);
			}
			Beam bm1;bm1.dbCreate(bdBm);bmAllInTrussForcedErase.append(bm1);bmAllInTrussForcedCopy.append(bm1); // To define how many plies the truss has (forced to create beam from body because dbCopy does not work at this point)
		}// Got support beam's body in bdSupport

		int nPlies=0;
		
		// Excludying verticals due to vectors for body creation
		if(bmAllInTrussForcedCopy[0].vecX().isParallelTo(_ZW))
		{
			for (int i=1;i<bmAllInTrussForcedCopy.length(); i++)
			{
				if(!bmAllInTrussForcedCopy[i].vecX().isParallelTo(_ZW))
					bmAllInTrussForcedCopy.swap(0,i);
			}
		}
		
		for (int i=0;i<bmAllInTrussForcedCopy.length(); i++)
		{
			Beam bm0=bmAllInTrussForcedCopy[i];
			Body bdBm0=bm0.envelopeBody();
			
			Vector3d vUp=bm0.vecD(_ZW);				
			Vector3d vSide;
			if(vUp.isParallelTo(bm0.vecY()))
				vSide=bm0.vecZ();
			else
				vSide=bm0.vecY();
			
			Body bdInt(bm0.ptCen(),bm0.vecX(),vUp,vSide,U(25000,1000),U(25000,1000),U(12,.5));
					
			for (int j=bmAllInTrussForcedCopy.length()-1;j>=0; j--)
			{
				Beam bm= bmAllInTrussForcedCopy[j];
				Body bdBm=bm.envelopeBody();
				if(bdInt.hasIntersection(bdBm) )
				{		
					bmAllInTrussForcedCopy.removeAt(j);
				}
			}
			nPlies++;
		}
		for(int b=0;b<bmAllInTrussForcedErase.length();b++)
		{
			bmAllInTrussForcedErase[b].dbErase();
		}

		Point3d ptAllInBodySupport[0];
		ptAllInBodySupport=bdSupport.allVertices();
		Point3d ptHighestOnTruss(0,0,0);
		for(int p=0; p<ptAllInBodySupport.length(); p++)
		{
			Point3d pt=ptAllInBodySupport[p];
			if(pt.Z()>ptHighestOnTruss.Z())
				ptHighestOnTruss=pt;
		}
		
		Plane pln0( Point3d(0,0,0), _ZW);
		vSupportX= vSupportX.projectVector( pln0);
		vSupportX.normalize();

		// Find walls under truss
		TslInst tslInst[0];
		tslInst.append(trussDefinition.tslInst());
		for( int t=0; t< tslInst.length(); t++)
		{	
			Map mapToClone;
	
			TslInst tslInTruss= tslInst[t];
			String sTslInTruss= tslInTruss.scriptName();
			String sTslToSearch="Alpine-BearingReaction";
			if( sTslInTruss != sTslToSearch)
			{
				continue;	
			}

			Point3d ptCen=tslInTruss.ptOrg();
			ptCen.transformBy(csTruss);
			//Construct body to search intersections
			Vector3d vBdX= vSupportX;
			Vector3d vBdY= _ZW;
			Vector3d vBdZ= vBdX.crossProduct( vBdY);
			double dBdX= U(250,10);
			double dBdY= abs( _ZW.dotProduct( ptCen- Point3d(0,0,0)));
			double dBdZ= bdSupport.lengthInDirection(vBdZ);
			double dTrussHeight= dBdZ;
			if( (dBdX == 0 || dBdY == 0 || dBdZ == 0) &&!_bOnInsert )
			{
				return;
			}
			
			Body bdSearch (ptCen, vBdX, vBdY, vBdZ, dBdX, dBdY, dBdZ, 0, -1, 0); //Every wall that intersects with this body is under truss
			
			// Getting REFERENCE BODY element and its location
			Body bdReference;
			Vector3d vxElRef, vzElRef;
			double dElRefBmW, dElRefBmH;
			
			int nReferenceElementFound=false;
			for( int e=0; e< _Element.length(); e++)
			{
				ElementWall el = (ElementWall) _Element[e];
				if (!el.bIsValid())
				{
					continue;
				}

				//Element vectors in model space
				CoordSys csEl=el.coordSys();
				vxElRef= csEl.vecX();
				vzElRef= csEl.vecZ();	
				dElRefBmW= el.dBeamWidth();
				dElRefBmH= el.dBeamHeight();
			
				PLine plOutlineWall=el.plOutlineWall();
				Body bdEl ( plOutlineWall, _ZW*1000, 0);
				if (bdSearch.hasIntersection( bdEl))
				{
					bdReference= bdEl;
					bdReference.intersectWith( bdSearch);
					mapToClone.setVector3d("VXELREF", vxElRef );
					mapToClone.setVector3d("VZELREF", vzElRef );
					mapToClone.setDouble("ELREFBEAMHEIGHT", dElRefBmH);
					mapToClone.setDouble("ELREFBEAMWIDTH", dElRefBmW);					
					mapToClone.setPoint3d("PT_HIGHEST_ON_TRUSS", ptHighestOnTruss);					
					nReferenceElementFound=true;
					break;
				}
			}
			if(!nReferenceElementFound)
			{
				continue;				
			}		

			Point3d ptRef= bdReference.ptCen();
			ptRef+= _ZW *_ZW.dotProduct( bdSupport.ptCen()- ptRef);
			
			// We have our reference body and point, now we need to find all elements that are aligned to this...
			ElementWall elAll[0];
			for( int e=0; e< _Element.length(); e++)
			{
				ElementWall el = (ElementWall) _Element[e];
				
				if (!el.bIsValid())
				{
					continue;
				}
				
				//Element vectors in model space
				CoordSys csEl=el.coordSys();
				Point3d ptOrgEl=csEl.ptOrg();
				Vector3d vx = csEl.vecX();
				Vector3d vy = csEl.vecY();
				Vector3d vz = csEl.vecZ();
			
				PLine plOutlineWall=el.plOutlineWall();
				Body bdEl ( plOutlineWall, vy*50, 1);
				if (bdReference.hasIntersection( bdEl))
				{
					elAll.append(el);
				}
			}
			// We have all elements to work with in elAll[]
			
			if( elAll.length()==0) // There are not walls under truss in this point
			{	
				continue;
			}			
			
			// Getting uplift
			double dUplift=abs(tslInTruss.map().getDouble("MaxVerticalUplift"));

			// Getting point for heel height: intersection between external face of wall and highest face on truss
			ElementWall elRef=elAll[0]; // Any wall is our reference for heel height, considering that all must be aligned
			CoordSys csElRef= elRef.coordSys();
			Vector3d vElementRefX=csElRef.vecX();
			Vector3d vElementRefZ=csElRef.vecZ();
			Point3d ptElementRefOrg= csElRef.ptOrg();
			Point3d ptElementRefBack= ptElementRefOrg- vElementRefZ*elRef.dBeamWidth();
			Vector3d vDir=vSupportX;
			if(vDir.dotProduct(ptElementRefOrg-bdSupport.ptCen())<0)
			{
				vDir=-vDir; // Always pointing from center of truss to element
			}

			Point3d ptHeel;
			if(vElementRefZ.dotProduct(vDir)>0)
			{
				ptHeel=ptElementRefOrg;
			}
			else
			{
				ptHeel=ptElementRefBack;
			}
		
			ptHeel+=vElementRefX*vElementRefX.dotProduct(bdSupport.ptCen()-ptHeel);
			ptHeel+=vSupportX*U(.05,.0001); // Avoids error on function with plane of body

			Line lnHeel(ptHeel, _ZW);
			Point3d ptIntersects[]=bdSupport.intersectPoints(lnHeel);
			//Vector3d vHeel(ptHeel+_ZW*10-ptHeel);
			//Point3d ptIntersects[]=bdSupport.extremeVertices(vHeel);
			if( ptIntersects.length()==0)
			{
				continue;		
			}

			ptHeel= ptIntersects[ptIntersects.length()-1];
			
			mapToClone.setVector3d("V_SUPPORTX", vSupportX);
			mapToClone.setDouble("TRUSS_HEIGHT", dTrussHeight);
			mapToClone.setPoint3d("TRUSS_CENTER", bdSupport.ptCen());
			mapToClone.setPoint3d("PTREF", ptRef);
			mapToClone.setPoint3d("PTHEEL", ptHeel);
			mapToClone.setDouble("UPLIFT", dUplift);
			mapToClone.setInt("FIRST_INSERTED",1);
			mapToClone.setInt("Plies",nPlies);
		
			// clone tsl per truss
			TslInst tsl;
			String sScriptName = "GE_TRUSS_POINTLOAD";
		
			Vector3d vecUcsX = _XW;
			Vector3d vecUcsY = _YW;
			Beam lstBeams[0];
			Entity lstEnts[0];
			Point3d lstPoints[0];
			int lstPropInt[0];
			double lstPropDouble[0];
			String lstPropString[0];
			
			lstEnts.append(teTruss);
			for( int e=0; e< elAll.length(); e++)
			{
				lstEnts.append( elAll[e]);
			}

			lstPropString.append(""); // sEmpty0
			lstPropString.append(sBmLumberItem);
			lstPropString.append(sBmNumber);
			lstPropString.append(sBmInformation);
			lstPropString.append(sBmColor);
			lstPropString.append("    "); // sEmpty4
			lstPropString.append(sUseTransferBeams); // sEmpty4
			lstPropDouble.append(dLateralOff);
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString, 1, mapToClone ); 			

/*
			lstPropString.append(sLumberSpecie);
			lstPropString.append(sLumberGrade);
			lstPropString.append(" "); // sEmpty1
			lstPropString.append(sNoYes[sNoYes.find(sForceToCS16,0)]);
			lstPropString.append("  "); // sEmpty2
			lstPropString.append(strAutoManual);
			lstPropString.append(sRodTypes);
			lstPropString.append("   "); // sEmpty3
			lstPropString.append(sDimstyle);
			lstPropInt.append(nDisplayColor);
*/
		}
	}
     	setCatalogFromPropValues(T("_LastInserted"));
	eraseInstance();
} // End _bOnInsert

if (_Entity.length()==0  || _Element.length()==0 ) 
{
	eraseInstance();
	return;
}

int nFirstInserted= _Map.getInt("FIRST_INSERTED");
if( nFirstInserted || _bOnElementConstructed	)
{
	String sWarningMessage="";
	// Getting truss
	TrussEntity teTruss;

	for(int en=0; en<_Entity.length();en++)
	{
		if(_Entity[en].bIsKindOf(TrussEntity()))
			teTruss= (TrussEntity)_Entity[en];
	}

	if (!teTruss.bIsValid()) {
		eraseInstance();
		return;
	}

	// Getting info from _Map stored on _bOnInsert
	Vector3d vSupportX= _Map.getVector3d("V_SUPPORTX");
	double dTrussHeight= _Map.getDouble("TRUSS_HEIGHT");
	Point3d ptRef= _Map.getPoint3d("PTREF");
	Vector3d vxElRef=	 _Map.getVector3d("VXELREF");
	double dUplift= _Map.getDouble("UPLIFT");
	Point3d ptHighOnTruss=_Map.getPoint3d("PT_HIGHEST_ON_TRUSS");
	int nPlies=_Map.getInt("Plies");

	_Pt0=ptRef+vxElRef*dLateralOff;
	if(vSupportX.dotProduct(ptRef-ptHighOnTruss)<0)
	{
		vSupportX=-vSupportX;
	}
	_Map.setVector3d("V_SUPPORTX", vSupportX);

	ElementWall elAll[0];
	for( int e=0; e<_Element.length(); e++)
	{
		elAll.append((ElementWall)_Element[e]);
	}
	// Sort elements according to height position
	int nNrOfRows=elAll.length();
	int bAscending=false;
	  
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
	// We have all elements to work with in elAll[] sorted: elAll[0] is the highets, elAll[ elAll.lenght()-1] is the lowest
		
	// Adding handle to new tsl's map, this will help to THIS tsl erase all tsl's inserted by it
	Map map; 
	map.setString("HANDLE", _ThisInst.handle());
	map.setInt("ERASEMEIFNOBEAMS",1);
	_Map.setString("HOLD_DOWN", "");
	
	if(elAll.length()==0)
	{
		eraseInstance();
		return;
	}

	// Setting dependency
	for( int e= 0; e<elAll.length(); e++)
	{
		Element el= elAll[e];
		setDependencyOnEntity(el);
	}
	
	// Getting points in both faces of wall
	ElementWall elTop=elAll[0];
	CoordSys csElTop=elTop.coordSys();
	Vector3d vxTop = csElTop.vecX(); 
	Vector3d vyTop = csElTop.vecY(); 
	Vector3d vzTop = csElTop.vecZ(); 
	Point3d ptOrgTop=csElTop.ptOrg();
	Beam bmAllBeamsOfTopElement[]=elTop.beam();

	ElementWall elBottom=elAll[elAll.length()-1];
	CoordSys csElBottom=elBottom.coordSys();
	Point3d ptOrgBottom=csElBottom.ptOrg();
	int nSide=0;

	if(  vzTop.dotProduct( ptHighOnTruss - ptOrgTop) >= 0 ) // ptHighOnTruss is on icon side of wall (front)
	{
		nSide=-1;
	}
	else // ptHighOnTruss is on the other side than icon side of wall (back)
	{
		nSide=1;
	}
	
	ElemZone elZnMax=elTop.zone(nSide*5);
	double dShThickMax=elZnMax.dH();
	Point3d ptMax=elZnMax.ptOrg()+nSide*vzTop*dShThickMax;ptMax.vis();
	ElemZone elZnMin=elTop.zone(-nSide*5);
	double dShThickMin=elZnMin.dH();
	Point3d ptMin=elZnMin.ptOrg()-nSide*vzTop*dShThickMin;
	
	// Getting heel height
	Wall wlTop=(Wall)elTop;
	double dElTopBaseHeight=wlTop.baseHeight();	
	Point3d ptTopOnTopElement= ptOrgTop+_ZW*dElTopBaseHeight;
	Point3d ptHeel= _Map.getPoint3d("PTHEEL");// heel height
	double dHeelH= abs(_ZW.dotProduct(ptHeel-ptTopOnTopElement));
	reportMessage("\nPoint load, "+ teTruss+"\tUplift: "+ dUplift+"\tHeel height: "+ dHeelH+"\tPlies: "+ nPlies); 
	_Map.setPoint3d("PTTOPONTOP", ptTopOnTopElement);
	_Map.setPoint3d("PTMAX", ptMax);
	_Map.setPoint3d("PTMIN", ptMin);
	
	// Getting top plates on top wall
	Beam bmHorizontals[]=vxTop.filterBeamsParallel(bmAllBeamsOfTopElement);
	Beam bmTopPlates[0];
	for( int b=0; b<bmHorizontals.length(); b++)
	{
		Beam bm=	bmHorizontals[b];
		if(bm.type()==_kSFTopPlate || bm.type()==_kTopPlate)
		{		
			bmTopPlates.append(bm);
		}
	}
	
	bmTopPlates=vyTop.filterBeamsPerpendicularSort(bmTopPlates);
	Beam bmLowestTop;
	Beam bmHighestTop;
	if( bmTopPlates.length()>0)
	{
		bmLowestTop=bmTopPlates[0];
		bmHighestTop=bmTopPlates[bmTopPlates.length()-1];
	}

	Point3d ptBottomOfLowerTopPlate;
	if(bmLowestTop.bIsValid())
		ptBottomOfLowerTopPlate=bmLowestTop.ptCen()-vyTop*bmLowestTop.dD(vyTop)*.5;
	Point3d ptTopOfHighestTopPlate;
	if(bmHighestTop.bIsValid())
		ptTopOfHighestTopPlate=bmHighestTop.ptCen()+vyTop*bmHighestTop.dD(vyTop)*.5;

	// START CASES		
	/* // DR 28-apr-2014
	if( dHeelH< U(304.8, 12)) // Heel height < 12"
	{
		if( dUplift< 700) // add at least one H2.5T to outside face of wall over sheathing
		{
			// Insert hardware tsl
			TslInst tsl;
			String sScriptName = "GE_HDWR_STRAP_TWIST_HTS";
		
			Vector3d vecUcsX = _XW;
			Vector3d vecUcsY = _YW;
			Beam lstBeams[0];
			Entity lstEnts[2];
			Point3d lstPoints[1];
			int lstPropInt[2];
			double lstPropDouble[1];
			String lstPropString[1];
			
			// Props
			lstEnts[0]=(Entity) teTruss;
			lstEnts[1]=(Entity) elTop;		
			lstPoints[0]=ptMax;
			int nDir=1; lstPropInt[0]=nDir;
			int nSide=1; lstPropInt[1]=nSide;
			double dHeal=0; lstPropDouble[0]=dHeal;
			String sStrap= "H2.5T";lstPropString[0]=sStrap;
			map.setPoint3d("PT_BOTTOM_ON_LOWEST_TOP_PLATE", ptBottomOfLowerTopPlate);

			// Metal part 1
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString, 1, map);
			
			if( dUplift >= 425 ) // add (2) H2.5T to outside face of wall over sheathing (one is previously inserted, only one more is needed)
			{
				// Metal part 2
				lstPropInt[1]=-nSide;
				tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString, 1, map );
				
				// Creating tsl to display on truss	
				Map mapToDisplay; 
				mapToDisplay.setString("HANDLE", _ThisInst.handle());	
				String sScriptNameDisplay = "GE_PLOT_POINTLOAD_INFO";
			
				TslInst tslDisplay;
				Vector3d vecUcsXDisplay = _XW;
				Vector3d vecUcsYDisplay = _YW;
				Beam lstBeamsDisplay[0];
				Entity lstEntsDisplay[0];
				Point3d lstPointsDisplay[0];
				int lstPropIntDisplay[0];
				double lstPropDoubleDisplay[0];
				String lstPropStringDisplay[0];
				
				lstEntsDisplay.append(teTruss);
				lstPointsDisplay.append(_Pt0);
				lstPropIntDisplay.append(0);//nBeams
				lstPropIntDisplay.append(0);//nFloorToFloorStraps
				lstPropDoubleDisplay.append(0);//dFloorToFloorStrapLength
				lstPropStringDisplay.append("No");//sFloorToFloorStrapForcedToCS16 (yes/no)
				lstPropStringDisplay.append("");//sHoldDown
				lstPropStringDisplay.append(sStrap);//sConnectionAtTruss
				lstPropIntDisplay.append(2);//nConnectionsAtTruss
				lstPropStringDisplay.append(sDimstyle);//sDimstyle
				lstPropIntDisplay.append(nDisplayColor);//nColor
					
				tslDisplay.dbCreate(sScriptNameDisplay, vecUcsXDisplay,vecUcsYDisplay,lstBeamsDisplay, lstEntsDisplay,lstPointsDisplay,lstPropIntDisplay, lstPropDoubleDisplay,lstPropStringDisplay, 1, mapToDisplay);		
			}
			_Map.setInt("FIRST_INSERTED",0);
			return;
		}
	}
	*/
	
	
	// Case: Heel height >= 12"
	/* DR 24-apr-2014
	if( dHeelH >= U(304.8, 12))
	{
		if( dUplift< 700) // add at least one MSTA12 to outside face of wall over sheathing
		{
			Beam bmAllHorizontalOnTopElement[0];
			bmAllHorizontalOnTopElement.append(_ZW.filterBeamsPerpendicularSort(bmAllBeamsOfTopElement));
			if(bmAllHorizontalOnTopElement.length()<=0||!bmAllHorizontalOnTopElement[bmAllHorizontalOnTopElement.length()-1].bIsValid())
				return;
				
			Beam bmHighestPlate=bmAllHorizontalOnTopElement[bmAllHorizontalOnTopElement.length()-1];
			Point3d ptTrussBase=bmHighestPlate.ptCen();
			ptTrussBase+=bmHighestPlate.vecX()*bmHighestPlate.vecX().dotProduct(_Pt0-ptTrussBase);
			ptTrussBase+=vSupportX*bmHighestPlate.dD(vSupportX)*.5;
			ptTrussBase+=_ZW*bmHighestPlate.dD(_ZW)*.5; // Aligned to edge of heel height over very top plate
			_Map.setPoint3d("PT_TRUSS_BASE",ptTrussBase);			
			// Insert hardware tsl
			TslInst tsl;
			String sScriptName = "GE_HDWR_STRAP_TSA_ENHANCED";
		
			Vector3d vecUcsX = _XW;
			Vector3d vecUcsY = _YW;
			Beam lstBeams[0];
			Entity lstEnts[2];
			Point3d lstPoints[1];
			int lstPropInt[1];
			double lstPropDouble[4];
			String lstPropString[3];
			
			// Props
			lstEnts[0]=(Entity) teTruss;
			lstEnts[1]=(Entity) elTop;
			int nFace=2; lstPropInt[0]=nFace;
			double dL=12; lstPropDouble[0]=dL;// Auto length
			double dOffFace=abs(vSupportX.dotProduct(ptMax-ptTrussBase)); lstPropDouble[1]=dOffFace;
			double dOffSide=0; lstPropDouble[2]=dOffSide;
			double dCS16Lgt=12; lstPropDouble[3]=dCS16Lgt;
			String pBmQty= "1 Selected";lstPropString[0]=pBmQty;
			String strEmpty= " ";lstPropString[1]=strEmpty;
			String strForceCs16= sNoYes[0];lstPropString[2]=strForceCs16;
			
			//ptBottomOfLowerTopPlate
			Point3d ptStrapCenter=ptTrussBase;
			ptStrapCenter+=_ZW*_ZW.dotProduct(ptBottomOfLowerTopPlate-ptStrapCenter);
			ptStrapCenter+=_ZW*dL*.5;
			
			lstPoints[0]=ptStrapCenter;

			// Metal part 1
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString, 1, map );
			
			if( dUplift >= 425 ) // add (2) MSTA12 to outside face of wall over sheathing (one is previously inserted, only one more is needed)
			{
				// Vertical scabb
				Vector3d vzScab=vSupportX;
				Vector3d vxScab=_ZW;
				Vector3d vyScab=vzScab.crossProduct(vxScab);
				double dScabL=dHeelH;
				double dScabW=U(38.1,1.5);
				double dScabH=U(88.9, 3.5);
				
				Point3d ptScabCen=ptTrussBase;
				ptScabCen+=vyScab*(dTrussHeight*.5+dScabW*.5);
				if(dScabL==0)
					return;
					
				// Create scab
				Beam bmScab;
				bmScab.dbCreate( ptScabCen, vxScab, vyScab, vzScab, dScabL, dScabW, dScabH, 1, 0, -1);
				bmScab.setColor(32);
				bmScab.setMaterial(sLumberSpecie);
				bmScab.setGrade(sLumberGrade);
				bmScab.assignToElementGroup(elTop, 1, 0, 'Z');
				
				// Metal part 2
				lstBeams.setLength(1);
				lstBeams[0]=bmScab;
				lstEnts.setLength(1);
				lstEnts[0]=(Entity) elTop;
				tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString, 1, map );		
			}
			_Map.setInt("FIRST_INSERTED",0);
			return;
		}
	}*/	
	
	////////////////////////// 		FROM THIS POINT HEEL HEIGHT SEEM TO BE NOT NEEDED ANYMORE, THEN WILL START CASES DEPENDING ON UPLIFT VALUES		//////////////////////////
	/* DR 24-apr-2014
	int nOneHST20TwistStrapOnly=FALSE;
	Vector3d vSideToPlaceStrap;
	double dTrussThickness=0;
	if( dUplift>= 700) // add at least one HTS20 to inside face of wall
		{
			// Insert hardware tsl
			TslInst tsl;
			String sScriptName = "GE_HDWR_STRAP_TWIST_HTS";
		
			Vector3d vecUcsX = _XW;
			Vector3d vecUcsY = _YW;
			Beam lstBeams[0];
			Entity lstEnts[2];
			Point3d lstPoints[1];
			int lstPropInt[0];
			double lstPropDouble[0];
			String lstPropString[0];
			
			// Props
			lstEnts[0]=(Entity) teTruss;
			lstEnts[1]=(Entity) elTop;
			lstPoints[0]=ptMin;
			int nDir=-1; lstPropInt.append(nDir);
			int nSide=1; lstPropInt.append(nSide);
			double dHeal=dHeelH; lstPropDouble.append(dHeal);
			String sStrap= "HTS20";lstPropString.append(sStrap);
			int nConnectionsAtTruss=1;
			map.setPoint3d("PT_TOP_ON_HIGHEST_TOP_PLATE", ptTopOfHighestTopPlate);

			// Metal part 1
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString, 1, map);
			
			// Define in what side of truss HTS20 will be inserted (need to bring some code from GE_HTS_TWIST_STRAPS tsl to define it. Whit this value we'll know where to place beams. NOTE: only needed when 
			// only one HTS20 is inserted, when there are 2 beams will be good placed because will be at least 3
			// Code from GE_HTS_TWIST_STRAPS
			Body bm1;
			CoordSys csBm;
		
			TrussDefinition cdTruss=teTruss.definition();
			CoordSys csT=teTruss.coordSys();csT.vis();
			Beam arBmTruss[]=cdTruss.beam();			
			for(int t=0;t<arBmTruss.length();t++){
				Beam bmNew=arBmTruss[t];
				CoordSys csBmT=bmNew.coordSys();
				if(!bmNew.bIsValid())
					continue;				
				Body bdBm=bmNew.envelopeBody();
				csBmT.transformBy(csT);
				bdBm.transformBy(csT);
				Point3d ptEnds[]=bdBm.extremeVertices(csT.vecX());
				double dz=U(0);	
				double d1=csT.vecX().dotProduct(_Pt0-ptEnds[0]),d2= csT.vecX().dotProduct(_Pt0-ptEnds[1]) ;
				double dzBm=bdBm.ptCen().Z();
				if(   csT.vecX().dotProduct(_Pt0-ptEnds[0]) * csT.vecX().dotProduct(_Pt0-ptEnds[1]) < 0 
					&& 
					bdBm.ptCen().Z() > dz)
				{
					dz=bdBm.ptCen().Z();
					bm1=bdBm;
					csBm=csBmT;
				}
			}
			
			Vector3d vxBdBeam=csBm.vecX(),vyBdBeam=csBm.vecY(),vzBdBeam=csBm.vecZ();
			Vector3d vUp=_ZW;
			
			if(vxBdBeam.dotProduct(vUp)<0)vxBdBeam=-vxBdBeam;		
			vSideToPlaceStrap=vUp.crossProduct(vxBdBeam)*nSide;
			vSideToPlaceStrap.normalize();
			// End GE_HTS_TWIST_STRAPS
			
			dTrussThickness=bm1.lengthInDirection(vSideToPlaceStrap);			
			nOneHST20TwistStrapOnly=TRUE;
			
			if( dUplift >= 1250 ) // add (2) HTS20 to inside face of wall (one is previously inserted, only one more is needed)
			{
				// Metal part 2
				lstPropInt[1]=-nSide;
				tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString, 1, map);
				nConnectionsAtTruss++;
				nOneHST20TwistStrapOnly=FALSE;
			}
									
			// Creating tsl to display on truss	
			Map mapToDisplay; 
			mapToDisplay.setString("HANDLE", _ThisInst.handle());	
			String sScriptNameDisplay = "GE_PLOT_POINTLOAD_INFO";
		
			TslInst tslDisplay;
			Vector3d vecUcsXDisplay = _XW;
			Vector3d vecUcsYDisplay = _YW;
			Beam lstBeamsDisplay[0];
			Entity lstEntsDisplay[0];
			Point3d lstPointsDisplay[0];
			int lstPropIntDisplay[0];
			double lstPropDoubleDisplay[0];
			String lstPropStringDisplay[0];
			
			lstEntsDisplay.append(teTruss);
			lstPointsDisplay.append(_Pt0);
			lstPropIntDisplay.append(0);//nBeams
			lstPropIntDisplay.append(0);//nFloorToFloorStraps
			lstPropDoubleDisplay.append(0);//dFloorToFloorStrapLength
			lstPropStringDisplay.append("No");//sFloorToFloorStrapForcedToCS16 (yes/no)
			lstPropStringDisplay.append("");//sHoldDown
			lstPropStringDisplay.append(sStrap);//sConnectionAtTruss
			lstPropIntDisplay.append(nConnectionsAtTruss);//nConnectionsAtTruss
			lstPropStringDisplay.append(sDimstyle);//sDimstyle
			lstPropIntDisplay.append(nDisplayColor);//nColor
				
			tslDisplay.dbCreate(sScriptNameDisplay, vecUcsXDisplay,vecUcsYDisplay,lstBeamsDisplay, lstEntsDisplay,lstPointsDisplay,lstPropIntDisplay, lstPropDoubleDisplay,lstPropStringDisplay, 1, mapToDisplay); 
	
		}*/

	// Collect all plates for stretch new transfers NOTICE: Heavy operation, but necessary
	//Beam bmAllNewTransfers[0], bmAllPlatesForTransfers[0];
	Beam bmAllTopPlatesForTransfers[0], bmAllBottomPlatesForTransfers[0];
	for( int e=0; e< elAll.length(); e++)
	{
		ElementWall el = elAll[e];
		Beam bmAll[]= el.beam();
		CoordSys csEl=el.coordSys();
		Vector3d vx = csEl.vecX();
		Beam bmHorizontals[]=vx.filterBeamsParallel(bmAll);
		for( int b=0; b<bmHorizontals.length(); b++)
		{
			Beam bm=bmHorizontals[b];
			int nType=bm.type();
			if( nType == _kSFTopPlate || nType == _kTopPlate)
			{
				bmAllTopPlatesForTransfers.append(bm);
			}
			if( nType == _kSFBottomPlate || nType == 25)
			{
				bmAllBottomPlatesForTransfers.append(bm);			
			}
		}
	}
	
	// Search openings along all ordered walls, if opening is found search is stopped. All walls that had no opening but are below uplift must be framed
	ElementWall elToFrame[0];
	ElementWall elWithOpening;
	int bOpeningFound=false;
	for( int e=0; e< elAll.length(); e++)
	{
		ElementWall el = elAll[e];
		double dBmH=el.dBeamHeight();
		Opening ops[]= el.opening();
		if(ops.length()==0) // Element has no openings, needs to be framed
		{
			elToFrame.append(el);
			continue;	
		}
		else // Element has openings, but we don't know if are below uplift
		{
			//Element vectors in model space
			CoordSys csEl=el.coordSys();
			Point3d ptOrgEl=csEl.ptOrg();
			Vector3d vx = csEl.vecX();
			Vector3d vy = csEl.vecY();
			Vector3d vz = csEl.vecZ();
			double dExtra=0;
			int nBeams=5; // Number of beams that might belong to a module from opening
			double dDistToExtendPerSide=dExtra+nBeams*dBmH;
			// Must ckeck all openings if are blow uplift
			for (int o=0; o<ops.length(); o++)
			{
				Opening op= ops[o];
				PLine plOp=op.plShape();  plOp.vis(1);
				Body bdOp(plOp, el.vecZ()*U(500, 20), 0);
				Point3d ptOpCen=bdOp.ptCen();
				double dOpW=op.width();
				Point3d ptL=ptOpCen-vx*(dOpW*.5+dDistToExtendPerSide);
				Point3d ptR=ptOpCen+vx*(dOpW*.5+dDistToExtendPerSide);
				// plL & ptR max points of opening along vx of element
				if( vx.dotProduct( ptRef- ptL) >=0 && vx.dotProduct( ptR-ptRef) >=0) // Uplift is above opening
				{
					bOpeningFound=true;
					break;						
				}
				
			}
			if(bOpeningFound)
			{
				elWithOpening=el;
				//bmAllPlatesForTransfers.append(el.beam());
				break;
			}
			else
			{
				elToFrame.append(el);
			}
		}
	}

	// Frame all walls needed	( this walls have no opening to care about )

/*
	CODE MOVED INSIDE LOOP FOR ELEMENTS, TO DEFINE MATERIAL PER EVERY ONE ACCORDING TO BEAM HEIGHT
	// Getting values from selected item lumber for SIDE POST
	String sBmMaterial, sBmGrade, sBmName="";
	double dBmWidth, dBmHeight;
	int nLumberItemIndex=sLumberItemNames.find(sBmLumberItem,-1);
	if( nLumberItemIndex!=sLumberItemNames.length()-1) //Any lumber item was defined from inventory
	{
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
	}
*/
	// Setting new beams number
	/*int nNewBeams=2; // Number of beams to create, depends on case but base number will be set here
	if( dUplift >= 1250 )
	{
		nNewBeams=3;
	}*/ 
	int nNewBeams;
	if(sNumbers.find(sBmNumber)==0)
		nNewBeams=nPlies;
	else if(sNumbers.find(sBmNumber)==1)
		nNewBeams=nPlies+1;
	else
		nNewBeams=sBmNumber.atoi();

	// Setting cleannign area based on number of new beams
	Point3d ptBdCleanOrg=_Pt0;
	Vector3d vCleanY=_ZW; // This is the only one we can rely on its positive value
	Vector3d vCleanZ=vSupportX; // Rely only on its direction, but not on it positive or negative value (always make flag 0 on body constructor)
	Vector3d vCleanX= vCleanY.crossProduct( vCleanZ);

	Body bdClean;
	for( int e=0; e< elToFrame.length(); e++)
	{
		// Adding info to map to be sent to GE_PLOT_POINTLOAD_INFO so it can draw pointload addings
		Map mapDisplay;
		int nBeamsToDisplay=0;
		int nFloorToFloorStrapsToDisplay=0;
		//double dFloorToFloorStrapLengthToDisplay=0;
		//String sFloorToFloorStrapsForcedToCS16=sNoYes[0];
		//String sHoldDownsToDisplay="";	

		ElementWall el = elToFrame[e];
		CoordSys csEl=el.coordSys();
		Point3d ptOrgEl=csEl.ptOrg();
		Vector3d vx = csEl.vecX();
		Vector3d vy = csEl.vecY();
		Vector3d vz = csEl.vecZ();
		Beam bmAll[]= el.beam();
		Sheet shAll[]=el.sheet();
		Beam bmVerticals[]=vy.filterBeamsParallel(bmAll);
		Beam bmHorizontals[]=vx.filterBeamsParallel(bmAll);
		Beam bmTopPlates[0], bmBottomPlates[0];
		for( int b=0; b<bmHorizontals.length(); b++)
		{
			Beam bm=bmHorizontals[b];
			int nType=bm.type();
			if( nType == _kSFTopPlate || nType == _kTopPlate)
			{
				bmTopPlates.append(bm);
				//bmAllPlatesForTransfers.append(bm);
			}
			if( nType == _kSFBottomPlate || nType == 25)
			{
				bmBottomPlates.append(bm);			
			}
		}


		// Getting values from selected item lumber for SIDE POST	
		String sBmMaterial, sBmGrade, sBmName="";
		double dBmWidth, dBmHeight, dBmHeightInMap;
		int bHeightFound=false;
		
		for(int i=0;i<sLumberItemNamesNoThickness.length();i++)
		{
			if(sBmLumberItem==sLumberItemNamesNoThickness[i])
			{
				String sKey= mapOut.keyAt(i);
				dBmWidth= mapOut.getDouble(sKey+"\WIDTH");
				sBmMaterial= mapOut.getString(sKey+"\HSB_MATERIAL");
				sBmGrade= mapOut.getString(sKey+"\HSB_GRADE");
				dBmHeightInMap= mapOut.getDouble(sKey+"\HEIGHT");
				if(abs(dBmHeightInMap-el.dBeamWidth())<U(1,.01))
				{
					dBmHeight= dBmHeightInMap;
					bHeightFound=true;
					break;
				}
			}
		}
		if(!bHeightFound)
		{
			sWarningMessage+="\nError on wall: "+el.code()+"-"+el.number()+
			"\n\t Width: "+ el.dBeamWidth()+ " was not defined on inventory list for "+ sBmLumberItem+". Set values:"
			+"\n\tGrade: "+sBmGrade
			+"\n\tMaterial: UNDEFINED"
			 +"\n\twidth taken from wall.";
			sBmMaterial="UNDEFINED";
			dBmHeight=el.dBeamHeight();
		}
		
		double dBdCleanX=nNewBeams*dBmWidth;
		double dBdCleanY=_ZW.dotProduct( _Pt0- Point3d(0,0,0));
		double dBdCleanZ=U(250,10);
		if( dBdCleanX == 0 || dBdCleanY == 0 || dBdCleanZ == 0 )
		{
			return;
		}
		
		/*if(nOneHST20TwistStrapOnly)
		{
			ptBdCleanOrg=_Pt0-vSideToPlaceStrap*dTrussThickness*.5; // Aligned to side face of truss
			ptBdCleanOrg+=vSideToPlaceStrap*dNewBmH; // Aligned to side face of truss			
		}*/
				
		Body bdClean (ptBdCleanOrg, vCleanX, vCleanY, vCleanZ, dBdCleanX, dBdCleanY, dBdCleanZ, 0, -1, 0); // This area must be clean, all studs erased and all blocking splitted
		PlaneProfile ppClean=bdClean.getSlice(Plane(_Pt0,vz));
		PLine plAllClean[]=ppClean.allRings();
		PLine plClean=plAllClean[0];
		_Map.setPLine("PL_CLEAN_AREA", plClean);

		//Cleaning area (erasing studs interfering)
		Beam bmToStrech[0];
		Beam bmAnyStud; // Will be copied to frame wall
		for( int b=0; b<bmVerticals.length(); b++)
		{
			Beam bm=bmVerticals[b];
			Body bdBm=bm.realBody();
			if(bm.type()==_kStud)
				bmAnyStud=bm;
			if(bdBm.hasIntersection( bdClean))
			{
				if( el == elToFrame[0]) // Only necesary on upper store
				{
					// Must check if erasing stud won't affect a possible sheeting joint
					for( int s=0; s< shAll.length(); s++)
					{
						Sheet sh= shAll[s];
						Body bdSh= sh.envelopeBody();
						Point3d ptShExtremesVX[]=bdSh.extremeVertices(vx);
						Point3d ptShL=ptShExtremesVX[0];
						Point3d ptShR=ptShExtremesVX[ptShExtremesVX.length()-1];
						double dBmW= bm.dD(vx);
						Point3d ptBmL= bm.ptCen()-vx*dBmW*.5;
						Point3d ptBmR= bm.ptCen()+vx*dBmW*.5;
						if( 
							( vx.dotProduct( ptShL- ptBmL) > 0 && vx.dotProduct( ptBmR- ptShL) > 0) // ptShL is between ptBmL and ptBmR
							||
							( vx.dotProduct( ptShR- ptBmL) > 0 && vx.dotProduct( ptBmR- ptShR) > 0) ) // ptShR is between ptBmL and ptBmR
						{	// Beam contains a sheeting joint
							nNewBeams++;
							break;
						}
					}
				}
				bm.dbErase();
			}
			else
			{
				bmToStrech.append(bm);
			}
		}
		
		// Creating new studs
		_Map.setInt("CREATED_BEAMS", nNewBeams); // Storing new beams # for display outside _bOnInsert
		Beam bmFloorToFloorStrap[0], bmHoldOnToSlab[0], bmCreated[0];
		Point3d ptNewBmCenter=_Pt0;

		/*if(nOneHST20TwistStrapOnly)
		{
			ptNewBmCenter=_Pt0-vSideToPlaceStrap*dTrussThickness*.5; // Aligned to side face of truss
			ptNewBmCenter+=vSideToPlaceStrap*dNewBmH*.5; // Aligned to side face of truss			
		}
		else
		{
			ptNewBmCenter+=vx*.5*dNewBmH*(1-(nNewBeams%2));
		}*/ 

		ptNewBmCenter+=vx*.5*dBmWidth*(1-(nNewBeams%2));
		
		Point3d ptMostLeftToClean, ptMostRightToClean; // For work with blocking 
		
		// Set values for GE_PLOT_PONITLOAD INFO tsl
		//nBeamsToDisplay=nNewBeams;

		for( int n=0; n<nNewBeams; n++)
		{
			int nSign;
			if(n%2==0)
				nSign=1;
			else
				nSign=-1;
			ptNewBmCenter+=vx*dBmWidth*n*nSign;
			Beam bmNew;
			bmNew=bmAnyStud.dbCopy();
			bmNew.setD(vx,dBmWidth);
			bmNew.setColor(nBmColor);
			//bmNew.setMaterial(sLumberSpecie);
			//bmNew.setGrade(sLumberGrade);			
			bmNew.setMaterial(sBmMaterial);
			bmNew.setGrade(sBmGrade);
			bmNew.setName(sBmName);	
			bmNew.setInformation(sBmInformation);
			bmNew.setModule(_ThisInst.handle()+e);
			bmNew.transformBy(vx*vx.dotProduct(ptNewBmCenter-bmNew.ptCen()));
			bmCreated.append(bmNew); // Usually for working with blocking	

			// Stretching to top and bottom plates making sure this new beam has right length
			Beam arBeamHitTops[] = Beam().filterBeamsHalfLineIntersectSort(bmTopPlates, bmNew.ptCen() , _ZW);
			if (arBeamHitTops.length()>0) 
			{
				Beam bmHitTop = arBeamHitTops[0];
				bmNew.stretchStaticTo(bmHitTop, 1);
			}
			Beam arBeamHitBottoms[] = Beam().filterBeamsHalfLineIntersectSort(bmBottomPlates, bmNew.ptCen() , -_ZW);
			if (arBeamHitBottoms.length()>0) 
			{
				Beam bmHitBottom = arBeamHitBottoms[0];
				bmNew.stretchStaticTo(bmHitBottom,1);
			}

			_Beam.append(bmNew); // To erase on _bOnElementDeleted
			
			// Creating transference beams from element to element (between elements)
			int nUseTransferBeams=sNoYes.find(sUseTransferBeams,0);
			if(el != elBottom && nUseTransferBeams) // Element is not first floor
			{
				Beam bmTransfer;
				Point3d ptTransferCen=bmNew.ptCen()+_ZW*_ZW.dotProduct(ptOrgEl-bmNew.ptCen());
				double dTransferL=U(100, 4);
				double dTransferW=bmNew.dD(bmNew.vecY());
				double dTransferH=bmNew.dD(bmNew.vecZ());
				if( dTransferW > 0 && dTransferH > 0)
				{
					bmTransfer.dbCreate( ptTransferCen, _ZW, bmNew.vecY(), bmNew.vecZ(), dTransferL, dTransferW, dTransferH, -1, 0, 0);				
					bmTransfer.setColor(nBmColor);
					//bmTransfer.setMaterial(sLumberSpecie);
					//bmTransfer.setGrade(sLumberGrade);
					bmTransfer.setMaterial(sBmMaterial);
					bmTransfer.setGrade(sBmGrade);
					bmTransfer.setName(sBmName);
					bmTransfer.setInformation(sBmInformation);
					//Setting length for transfer
					Beam bmAllToStretchOnTop[]=Beam().filterBeamsHalfLineIntersectSort(bmAllBottomPlatesForTransfers, bmTransfer.ptCen(), _ZW);
					if( bmAllToStretchOnTop.length()>0)
					{
						Beam bmToStretchTop=bmAllToStretchOnTop[0];
						bmTransfer.stretchDynamicTo(bmToStretchTop);
					}
					Beam bmAllToStretchOnBottom[]=Beam().filterBeamsHalfLineIntersectSort(bmAllTopPlatesForTransfers, bmTransfer.ptCen(), -_ZW);
					if( bmAllToStretchOnBottom.length()>0)
					{
						Beam bmToStretchBottom=bmAllToStretchOnBottom[0];
						bmTransfer.stretchDynamicTo(bmToStretchBottom);
					}
					
					_Beam.append(bmTransfer); // To erase on _bOnElementDeleted

					// Defining which transfer needs floor to floor strap					
					if(nNewBeams>0 && nNewBeams<=2) // 1 is needed
					{
						if(n==0) // Only on single or first of two
							bmFloorToFloorStrap.append(bmTransfer);
					}
					else // 2 are needed
					{	
						if(n==nNewBeams-2 || n==nNewBeams-1) // On before last and last
							bmFloorToFloorStrap.append(bmTransfer);			
					}
				}
			}  
			
			// Getting extreme vertex of clean area along vx (usually for working with blocking)
			double dBmNewH=bmNew.dD(vx);
			if(n==0)
			{
				ptMostLeftToClean= bmNew.ptCen()-vx*dBmNewH*.5;
				ptMostRightToClean= bmNew.ptCen()+vx*dBmNewH*.5;
			}
			else if(n%2==0)
				ptMostRightToClean= bmNew.ptCen()+nSign*vx*dBmNewH*.5;
			else
				ptMostLeftToClean= bmNew.ptCen()+nSign*vx*dBmNewH*.5;

			// Collecting bmHoldOnToSlab 
			bmHoldOnToSlab.append(bmNew);
		}

		// FLOOR TO FLOOR STRAPS
		/*
		// Insert hardware tsl: Add MSTA36 floor-to-floor strap
		if(el != elBottom) // Element is not first floor
		{
			for(int b=0; b<bmFloorToFloorStrap.length();b++)
			{
				Beam bmTransfer=bmFloorToFloorStrap[b];
				if(!bmTransfer.bIsValid())
					continue;
				
				// Insert hardware tsl
				TslInst tsl;
				String sScriptName = "GE_HDWR_STRAP_TSA_ENHANCED";
			
				Vector3d vecUcsX = _XW;
				Vector3d vecUcsY = _YW;
				Beam lstBeams[1];
				Entity lstEnts[1];
				Point3d lstPoints[1];
				int lstPropInt[1];
				double lstPropDouble[4];
				String lstPropString[3];
				
				// Props
				lstBeams[0]=bmTransfer;
				lstEnts[0]=(Entity) el;

				// Centering strap between floors
				Point3d ptCenterBetweenWalls=bmTransfer.ptCen();// This is a transfer beam, it will have the system floor depth
				lstPoints[0]=ptCenterBetweenWalls;
				
				// Setting strap length when forced to CS16
				double dExtraLenghtForStraps=U(304.8,12);
				double dFloorSystemDepth=bmTransfer.dL();
				double dLengthIfForcedToCS16=dExtraLenghtForStraps+dFloorSystemDepth;
				
				int nFace=2; lstPropInt[0]=nFace;
				double dLength=36; lstPropDouble[0]=dLength;
				double dOffFace=0; lstPropDouble[1]=dOffFace;
				double dOffSide=0; lstPropDouble[2]=dOffSide;
				double dCS16Lgt=dLengthIfForcedToCS16; lstPropDouble[3]=dCS16Lgt;
				String sBmQty= "1 Selected";lstPropString[0]=sBmQty;
				String strEmpty= " ";lstPropString[1]=strEmpty;
				int nForceToCS16=sNoYes.find(sForceToCS16,0);
				String strForceCs16= sNoYes[nForceToCS16];lstPropString[2]=strForceCs16;

				tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString, 1, map);
				// Set values for GE_PLOT_PONITLOAD INFO tsl
				nFloorToFloorStrapsToDisplay++;
				if(nForceToCS16)
					dFloorToFloorStrapLengthToDisplay=dLengthIfForcedToCS16;
				else
					dFloorToFloorStrapLengthToDisplay=dLength;
				sFloorToFloorStrapsForcedToCS16=strForceCs16;
			}
		}
		
		// HOLD DOWN SLAB
		else if(el == elBottom && ptOrgBottom.Z()<U(100, 4)) // Element is first floor and no more than 4 inches from floor
		{
			if(bmHoldOnToSlab.length()>0)
			{				
				TslInst tsl;
				Vector3d vecUcsX = _XW;
				Vector3d vecUcsY = _YW;
				Beam lstBeams[0];
				Entity lstEnts[0];
				Point3d lstPoints[0];
				int lstPropInt[1];
				double lstPropDouble[0];
				String lstPropString[4];
				
				// Props
				for(int b0; b0< bmHoldOnToSlab.length(); b0++)
					lstBeams.append(bmHoldOnToSlab[b0]);
				int nColor=-1; lstPropInt[0]=nColor;
				String sSide="Right";
				String strSide= sSide;lstPropString[1]=strSide;
				String pStretchBeams= "No";lstPropString[2]=pStretchBeams;
				String pDeleteBeams= "No";lstPropString[3]=pDeleteBeams;
				String sScriptName = "GE_HDWR_WALL_HOLD_DOWN";
					
				if( 700 <= dUplift && dUplift < 1800) // Add (1) DTT2Z hold down to slab at first floor
				{
					if(nAutoManual==0) // Auto
					{
						map.setString("Anchor",arRodTypes[7]);
						sRodTypes.set(arRodTypes[7]);
					}
					else
					{
						map.setString("Anchor",sRodTypes);
						sRodTypes.set(sRodTypes);
					}
					String strConnector= "DTT2Z";lstPropString[0]=strConnector;					
					tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString, 1, map );
					_Map.setString("HOLD_DOWN", strConnector);
					// Set values for GE_PLOT_PONITLOAD INFO tsl
					sHoldDownsToDisplay=strConnector;
				}
				
				if( 1800 <= dUplift ) // Add (1) HTT4 hold down to slab at first floor
				{
					if(nAutoManual==0) // Auto
					{
						map.setString("Anchor",arRodTypes[5]);
						sRodTypes.set(arRodTypes[5]);
					}
					else
					{
						map.setString("Anchor",sRodTypes);
						sRodTypes.set(sRodTypes);
					}
					String strConnector= "HTT4";lstPropString[0]=strConnector;		
					tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString, 1, map );
					_Map.setString("HOLD_DOWN", strConnector);
					sHoldDownsToDisplay=strConnector;
				}
			}
		}*/
		
		// Work with blocking
		double dBdSearchBlockX=(nNewBeams+2)*dBmWidth;
		if( dBdSearchBlockX == 0 || dBdCleanY == 0 || dBdCleanZ == 0 )
		{
			return;
		}
		
		Body bdSearchBlocking (ptBdCleanOrg, vCleanX, vCleanY, vCleanZ, dBdSearchBlockX, dBdCleanY, dBdCleanZ, 0, -1, 0);
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
					else if( vx.dotProduct( ptMostLeftToClean - ptBlockingRight ) <= bmAnyStud.dD(vx)) // blocking is at left of clean area
					{
						Beam bmAllToStretch[]=Beam().filterBeamsHalfLineIntersectSort(bmCreated, ptBlockingRight, vx);
						if( bmAllToStretch.length()>0)
						{
							Beam bmToStretch=bmAllToStretch[0];
							bmBlocking.stretchStaticTo(bmToStretch, 1);
						}
					}
					else if( vx.dotProduct( ptMostRightToClean - ptBlockingLeft ) <= bmAnyStud.dD(vx)) // blocking is at right of clean area
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
		}		

		// Creating tsl to display on elements
		/*
		Map mapToDisplay; 
		mapToDisplay.setString("HANDLE", _ThisInst.handle());
		
		TslInst tsl;
		String sScriptName = "GE_PLOT_POINTLOAD_INFO";
	
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEnts[0];
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		
		lstEnts.append(el);
		lstPoints.append(_Pt0);
		lstPropInt.append(nBeamsToDisplay);
		lstPropInt.append(nFloorToFloorStrapsToDisplay);
		lstPropDouble.append(dFloorToFloorStrapLengthToDisplay);
		lstPropString.append(sFloorToFloorStrapsForcedToCS16);
		lstPropString.append(sHoldDownsToDisplay);
		lstPropString.append("");//sConnectionAtTruss
		lstPropInt.append(0);//nConnectionsAtTruss
		lstPropString.append(sDimstyle);
		lstPropInt.append(nDisplayColor);
		
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString, 1, mapToDisplay); 	
		*/
		
	} // End for elToFrame
	if(sWarningMessage!="")
		reportNotice(sWarningMessage);
	_Map.setInt("FIRST_INSERTED",0);
	return;
}

if( _bOnElementDeleted )
{
	
	// Erasing all previous inserted tsl's by this tsl
	Entity arEnt[] = Group().collectEntities(true, TslInst(), _kModelSpace);
	for(int ent=0; ent<arEnt.length(); ent++)
	{	
		TslInst tsl= (TslInst) arEnt[ent];
		Map map=	tsl.map();
		String sTslHandle= map.getString("HANDLE");
		if( sTslHandle == _ThisInst.handle() )
		{
			tsl.dbErase();
		}
	}
	
	// Erasing all previous created beams by THIS tsl
	for( int b=0; b<_Beam.length(); b++)
		_Beam[b].dbErase();

	// Erasing all previous inserted tsl's by THIS tsl on truss
	TrussEntity teTruss;
	for(int en=0; en<_Entity.length();en++)
	{
		if(_Entity[en].bIsKindOf(TrussEntity()));
			teTruss= (TrussEntity)_Entity[en];	

		if (teTruss.bIsValid())
		{
			String strDefinition = teTruss.definition();
			TrussDefinition trussDefinition(strDefinition);
			TslInst tsls[]= trussDefinition.tslInst();
			for( int t=0; t<tsls.length(); t++)
			{
				TslInst tsl= tsls[t];
				Map map=	tsl.map();
				String sTslHandle= map.getString("HANDLE");
				if( sTslHandle == _ThisInst.handle() )
				{
					//tsl.dbErase();
				}
			}
		} 		
	}
	
	// Erasing all previous inserted tsl's by THIS tsl on element's
	for( int e= 0; e<_Element.length(); e++)
	{
		Element el= _Element[e];
		TslInst tsls[0];
		tsls.append( el.tslInstAttached());
		for( int t=0; t<tsls.length(); t++)
		{
			TslInst tsl= tsls[t];
			Map map=	tsl.map();
			String sTslHandle= map.getString("HANDLE");
			if( sTslHandle == _ThisInst.handle() )
			{
				//tsl.dbErase();
			}
		}
	}
	_Map.setInt("FIRST_INSERTED",0);
}

// Display on MS
Display dpMS (-1);
dpMS.addViewDirection(_ZW);
Vector3d vxElRef= _Map.getVector3d("VXELREF");
Vector3d vzElRef= _Map.getVector3d("VZELREF");
double dElRefBmH= _Map.getDouble("ELREFBEAMHEIGHT");
double dElRefBmW= _Map.getDouble("ELREFBEAMWIDTH");
int nNewBeamsToDisplay= _Map.getInt("CREATED_BEAMS");
if(nNewBeamsToDisplay==0)
	nNewBeamsToDisplay=U(25,1);
Point3d pt1=_Pt0-vxElRef*nNewBeamsToDisplay*dElRefBmH*.5-vzElRef*dElRefBmW*.5; 
Point3d pt2=_Pt0+vxElRef*nNewBeamsToDisplay*dElRefBmH*.5+vzElRef*dElRefBmW*.5; 
PLine plRectDisplayMS;
plRectDisplayMS.createRectangle(LineSeg(pt1, pt2), _XW, _YW);
PLine plCross;
plCross.addVertex( pt1);
plCross.addVertex( pt2);
dpMS.draw(plRectDisplayMS);
dpMS.draw(plCross);
Hatch hSolid("Solid",U(1));
dpMS.draw(PlaneProfile(plRectDisplayMS),hSolid);

Point3d ptTC=_Map.getPoint3d("TRUSS_CENTER");
ptTC.vis();
Point3d ptHigh=_Map.getPoint3d("PT_HIGHEST_ON_TRUSS");
ptHigh.vis();
Point3d ptOnTop=_Map.getPoint3d("PTTOPONTOP");ptOnTop.vis();
Point3d ptMax=_Map.getPoint3d("PTMAX");ptMax.vis();
Point3d ptMin=_Map.getPoint3d("PTMIN");ptMin.vis();
//Point3d ptTrussBase=_Map.getPoint3d("PT_TRUSS_BASE");ptTrussBase.vis(2);
Vector3d vSupportX= _Map.getVector3d("V_SUPPORTX");vSupportX.vis(ptHigh);

PLine plCleanArea=_Map.getPLine("PL_CLEAN_AREA");
plCleanArea.vis();

return;



#End
#BeginThumbnail
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
(B@`HHHH`_]FB
`







#End
