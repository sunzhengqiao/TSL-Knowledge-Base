#Version 8
#BeginDescription
1.4 21.07.2021 HSB-12270: add property "Orientation Drill" no/yes Author: Marsel Nakuci
1.3 21.07.2021 HSB-12270: add property offset Author: Marsel Nakuci
1.2 27.06.2021 HSB-12397: separate TSL instance for the representation of male part Author: Marsel Nakuci
1.1 24.06.2021 HSB-12397: part can be aligned at a face in X direction Author: Marsel Nakuci
1.0 01.06.2021 HSB-11913: initial Author: Marsel Nakuci


This tsl creates a plate connector of of Knapp Walco
https://www.knapp-verbinder.com/produkt/walco-v/
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords Knapp,Walco,plate,connector
#BeginContents
//region <History>
// #Versions
// Version 1.4 21.07.2021 HSB-12270: add property "Orientation Drill" no/yes Author: Marsel Nakuci
// Version 1.3 21.07.2021 HSB-12270: add property offset Author: Marsel Nakuci
// Version 1.2 27.06.2021 HSB-12397: separate TSL instance for the representation of male part Author: Marsel Nakuci
// Version 1.1 24.06.2021 HSB-12397: part can be aligned at a face in X direction Author: Marsel Nakuci
// Version 1.0 01.06.2021 HSB-11913: initial Author: Marsel Nakuci

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl creates a plate connector of of Knapp Walco
// https://www.knapp-verbinder.com/produkt/walco-v/
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbKnappWalco")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
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
	
//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="PC";
	Map mapSetting;

// compose settings file location
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound = _bOnInsert ? sFolders.find(sFolder) >- 1 ? true : makeFolder(sPath + "\\" + sFolder) : false;
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";

// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() )
	{
		String sFile=findFile(sFullPath); 
	// if no settings file could be found in company try to find it in the installation path
		if (sFile.length()<1) sFile=findFile(sPathGeneral+sFileName+".xml");	
		if (sFile.length()>0)
		{ 
			mapSetting.readFromXmlFile(sFile);
			mo.dbCreate(mapSetting);			
		}
	}
	// validate version when creating a new instance
	if(_bOnDbCreated)
	{ 
		int nVersion = mapSetting.getInt("GeneralMapObject\\Version");
		String sFile = findFile(sPathGeneral + sFileName + ".xml");		// set default xml path
		if (sFile.length()<1) sFile=findFile(sFullPath);				// set custom xml path if no default found
		Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);	// read the xml from installation directory
		int nVersionInstall = mapSettingInstall.getMap("GeneralMapObject").getInt("Version");		
		if(sFile.length()>0 && nVersion!=nVersionInstall)
			reportNotice(TN("|A different Version of the settings has been found for|") + scriptName()+
			TN("|Current Version| ")+nVersion + "	" + _kPathDwg + TN("|Other Version| ") +nVersionInstall + "	" + sFile);
	}
//End Settings//endregion

//region manufacturer map
	String sManufacturers[0];
	sManufacturers.append("---");
	{ 
		// get the models of this family and populate the property list
		Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
		for (int i = 0; i < mapManufacturers.length(); i++)
		{
			Map mapManufacturerI = mapManufacturers.getMap(i);
			if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
			{
				String _sManufacturerName = mapManufacturerI.getString("Name");
				if (sManufacturers.find(_sManufacturerName) < 0)
				{
					sManufacturers.append(_sManufacturerName);
				}
			}
		}
	}
	
	if (sManufacturers.length()<1)
	{ 
		reportMessage("\n"+ scriptName() + ": "+ T("|Could not find manufacturer data.| ")+ T("|Tool will be deleted.|"));
		eraseInstance();
		return;
	}
//End manufacturer map//endregion 

//region Properties
// component
	category = T("|Component|");
	// Manufacturer
	String sManufacturerName=T("|Manufacturer|");	
	PropString sManufacturer(nStringIndex++, sManufacturers, sManufacturerName);
	sManufacturer.setDescription(T("|Defines the Manufacturer|"));
	sManufacturer.setCategory(category);
	// Family
	String sFamilys[0];
	sFamilys.append("---");
	String sFamilyName=T("|Family|");	
	PropString sFamily(nStringIndex++, "", sFamilyName);	
	sFamily.setDescription(T("|Defines the Family|"));
	sFamily.setCategory(category);
	// Product
	String sProducts[0];
	sProducts.append("---");
	String sProductName=T("|Product|");
	PropString sProduct(nStringIndex++, "", sProductName);
	sProduct.setDescription(T("|Defines the Product|"));
	sProduct.setCategory(category);
	
// distribution
	category=T("|Distribution|");
	String sModeDistributionName=T("|Mode of Distribution|");	
	String sModeDistributions[] ={ T("|Even|"), T("|Fixed|")};
	PropString sModeDistribution(nStringIndex++, sModeDistributions, sModeDistributionName);	
	sModeDistribution.setDescription(T("|Defines the Mode of Distribution|"));
	sModeDistribution.setCategory(category);
	
	//distance from the bottom / start
	String sDistanceBottomName = T("|Start Distance|");
	PropDouble dDistanceBottom(nDoubleIndex++, U(0), sDistanceBottomName);
	dDistanceBottom.setDescription(T("|Defines the Distance at the Start|"));
	dDistanceBottom.setCategory(category);
	// distance from the top/end
	String sDistanceTopName = T("|End Distance|");
	PropDouble dDistanceTop(nDoubleIndex++, U(0), sDistanceTopName);
	dDistanceTop.setDescription(T("|Defines the Distance at the End|"));
	dDistanceTop.setCategory(category);
	
	// distance in between/ nr of parts (when negative input)	
	String sDistanceBetweenName=T("|Max. Distance between / Quantity| ");	
	PropDouble dDistanceBetween(nDoubleIndex++, U(500), sDistanceBetweenName);	
	dDistanceBetween.setDescription(T("|Defines the Distance Between the parts. -integer indicates nr of parts|"));
	// . Negative number will indicate nr of parts from the integer part of the inserted double
	dDistanceBetween.setCategory(category);
	// screw types
	// nr of parts/distance in between
	String sDistanceBetweenResultName=T("|Real Distance between|");	
	PropDouble dDistanceBetweenResult(nDoubleIndex++, U(0), sDistanceBetweenResultName);	
	dDistanceBetweenResult.setDescription(T("|Shows the calculated distance between the articles|"));
	dDistanceBetweenResult.setReadOnly(true);
	dDistanceBetweenResult.setCategory(category);
	
	String sNrResultName=T("|Nr.|");	
	PropInt nNrResult(nIntIndex++, 0, sNrResultName);	
	nNrResult.setDescription(T("|Shows the calculated quantity of articles|"));
	nNrResult.setReadOnly(true);
	nNrResult.setCategory(category);
	
// alignment properties
	category = T("|Position|");
	String sOffsetName=T("|Offset|");	
	PropDouble dOffset(nDoubleIndex++, U(0), sOffsetName);	
	dOffset.setDescription(T("|Defines the Offset|"));
	dOffset.setCategory(category);
	
// female tooling
	category = T("|Tooling for connector beam|");
	// clip lock Y/N Sperrklappe
	String sClipLockName=T("|Clip Lock|");	
	PropString sClipLock(nStringIndex++, sNoYes, sClipLockName);	
	sClipLock.setDescription(T("|Defines whether clip lock will be applied or not|"));
	sClipLock.setCategory(category);
	// milling 0 means the default
	category = T("|Milling for connector beam|");
	String sMillFemaleWidthName=T("|Width|");
	PropDouble dMillFemaleWidth(nDoubleIndex++, U(0), sMillFemaleWidthName);
	String sMillFemaleWidthDescription=T("|Defines the Mill Width for the connector beam.|");
	dMillFemaleWidth.setDescription(sMillFemaleWidthDescription);
	dMillFemaleWidth.setCategory(category);
	// 
	String sMillFemaleLengthName=T("|Length|");	
	PropDouble dMillFemaleLength(nDoubleIndex++, U(0), sMillFemaleLengthName);	
	String sMillFemaleLengthDescription=T("|Defines the Mill Length for the connector beam.|");
	dMillFemaleLength.setDescription(sMillFemaleLengthDescription);
	dMillFemaleLength.setCategory(category);
	
	String sMillFemaleDepthName=T("|Depth|");	
	PropDouble dMillFemaleDepth(nDoubleIndex++, U(0), sMillFemaleDepthName);
	String sMillFemaleDepthDescription=T("|Defines the Mill Depth for the connector beam.|");
	dMillFemaleDepth.setDescription(sMillFemaleDepthDescription);
	dMillFemaleDepth.setCategory(category);
	
	category = T("|Drilling for connector beam|");
	String sDrillFemaleDiameterName=T("|Diameter|");
	PropDouble dDrillFemaleDiameter(nDoubleIndex++, U(0), sDrillFemaleDiameterName);
	String sDrillFemaleDiameterDescription=T("|Defines the Drill Diameter for the connector beam.|");
	dDrillFemaleDiameter.setDescription(sDrillFemaleDiameterDescription);
	dDrillFemaleDiameter.setCategory(category);
	
	String sDrillFemaleLengthName=T("|Depth|");	
	PropDouble dDrillFemaleLength(nDoubleIndex++, U(0), sDrillFemaleLengthName);
	String sDrillFemaleLengthDescription=T("|Defines the Drill Depth for the connector beam.|");
	dDrillFemaleLength.setDescription(sDrillFemaleLengthDescription);
	dDrillFemaleLength.setCategory(category);
	
// male tooling
//	category = T("|Tooling for the screw beam|");
//	String sDrillName=T("|Drill|");	
//	PropString sDrill(nStringIndex++, sNoYes, sDrillName);	
//	sDrill.setDescription(T("|Defines if Drill should be applied|"));
//	sDrill.setCategory(category);
	// diameter
	category = T("|Milling for the screw beam|");
	// milling can be relevant only when set is selected
	String sMillMaleWidthName=T("|Width|");	
	PropDouble dMillMaleWidth(nDoubleIndex++, U(0), sMillMaleWidthName);	
	String sMillMaleWidthDescription=T("|Defines the Mill Width for the screw beam.|");
	dMillMaleWidth.setDescription(sMillMaleWidthDescription);
	dMillMaleWidth.setCategory(category);
	
	String sMillMaleLengthName=T("|Length|");	
	PropDouble dMillMaleLength(nDoubleIndex++, U(0), sMillMaleLengthName);	
	String sMillMaleLengthDescription=T("|Defines the Mill Length for the screw beam.|");
	dMillMaleLength.setDescription(sMillMaleLengthDescription);
	dMillMaleLength.setCategory(category);
	
	String sMillMaleDepthName=T("|Depth|");	
	PropDouble dMillMaleDepth(nDoubleIndex++, U(0), sMillMaleDepthName);	
	String sMillMaleDepthDescription=T("|Defines the Mill Depth for the screw beam.|");
	dMillMaleDepth.setDescription(sMillMaleDepthDescription);
	dMillMaleDepth.setCategory(category);
	
	category = T("|Drilling for the screw beam|");
	String sDrillMaleDiameterName=T("|Diameter|");	
	PropDouble dDrillMaleDiameter(nDoubleIndex++, U(0), sDrillMaleDiameterName);
	String sDrillMaleDiameterDescription=T("|Defines the Drill Diameter for the screw beam.|");
	dDrillMaleDiameter.setDescription(sDrillMaleDiameterDescription);
	dDrillMaleDiameter.setCategory(category);
	
	String sDrillMaleLengthName=T("|Depth|");
	PropDouble dDrillMaleLength(nDoubleIndex++, U(0), sDrillMaleLengthName);	
	String sDrillMaleLengthDescription=T("|Defines the Drill Length for the screw beam.|");
	dDrillMaleLength.setDescription(sDrillMaleLengthDescription);
	dDrillMaleLength.setCategory(category);
	
// alignment
	category = T("|Alignment|");
	String sAlignmentName=T("|Alignment|");
//	String sAlignments[] ={ T("|+X|"), T("|-X|"), T("|+Y|"), T("|-Y|"), T("|+Z|"), T("|-Z|") };
	String sAlignments[] ={"+X","-X", "+Y", "-Y", "+Z", "-Z"};
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the face of the Genbeam where the nails will be placed|"));
	sAlignment.setCategory(category);
	sAlignment.setReadOnly(_kHidden);
	
// orientation drill
	category = T("|Orientation drill|");
	String sOrientationDrillName=T("|Drill|");	
	PropString sOrientationDrill(nStringIndex++, sNoYes, sOrientationDrillName);	
	sOrientationDrill.setDescription(T("|Defines the OrientationDrill|"));
	sOrientationDrill.setCategory(category);
//End Properties//endregion 

//region Bodies of v60 and v80
// -- Main Collar screw -- 
_Pt0.vis(1);
double dLengthScrew = U(25);
double dDiameterScrew = U(22);
Point3d ptScrew = _Pt0;
Body bdScrew(ptScrew, ptScrew + _YW * dLengthScrew, dDiameterScrew / 2);
double dLengthWasher = U(7);
Point3d pt = ptScrew - _YW * dLengthWasher;
double dDiameterWasher = U(22);
bdScrew.addPart(Body(ptScrew, pt, dDiameterWasher / 2));
// cylinder part after washer
double dLengthEnd = U(5.5);
double dDiameterEnd = U(12);
Body bdScrewEnd(pt, pt - _YW * dLengthEnd, .5 * dDiameterEnd);
bdScrew.addPart(bdScrewEnd);
pt -= _YW * dLengthEnd;
// Cone part of the  collar screw
double dLengthCone = U(6);
double dDiameterInner = U(12);
double dDiameterOutter = U(24);
Body bdCone(pt, pt - _YW * (dLengthCone), dDiameterInner / 2, dDiameterOutter / 2);
bdScrew.addPart(bdCone);
// last cylinder part of screw
pt -= _YW * dLengthCone;
double dLengthConeEnd = U(.5);
Body bdConeEnd(pt, pt - _YW * dLengthConeEnd, .5 * dDiameterOutter);
bdScrew.addPart(bdConeEnd);
bdScrew.vis(3);

// -- connector -- 
double dConnectorDistance = U(8);// distance from ptScrew
double dLengthConnector = U(60);
double dWidthConnector = U(60);
double dThicknessConnector = U(12);
Body bd(ptScrew - _YW * dConnectorDistance , _XW, _ZW, -_YW, 
		dLengthConnector, dWidthConnector, U(12), 0, 0, 1);
bd.subPart(bdScrew);
bd.subPart(Body(pt, pt - _YW * U(40), .5 * dDiameterOutter));
// removing space from connector to get semi correct shape
// remove the cone
pt = ptScrew - _YW * (dConnectorDistance + dThicknessConnector);
double dDiameter1ConeRemove = U(33.65);
double dDiameter2ConeRemove = U(18);
double dLengthConeRemove = U(10);
Body bdConeRemove(pt, pt + _YW * dLengthConeRemove, .5*dDiameter1ConeRemove, .5*dDiameter2ConeRemove);
//bdConeRemove.vis(2);
bd.subPart(bdConeRemove);
// cone 2
double dDiameter3ConeRemove = U(12);
pt += _YW * dLengthConeRemove;
//Body bdConeRemove2(pt, pt + _YW * U(2), .5 * dDiameter2ConeRemove, .5*dDiameter3ConeRemove);
//bd.subPart(bdConeRemove2);
// remove the pline that goes through all
pt += _YW * U(2);
PLine pl(_YW);
// store 3 points for the skew tooling
Point3d ptSkew1, ptSkew2, ptSkew3;
pt += _XW * .5 * dDiameter3ConeRemove + _ZW * .5 * dWidthConnector;
pt += _XW * U(12.6037);
pl.addVertex(pt);
ptSkew1 = pt;
pt -= _XW * U(12.6037) + _ZW * U(18);
pl.addVertex(pt);
ptSkew2 = pt;
pt += _ZW * _ZW.dotProduct(ptScrew - pt);
pl.addVertex(pt);
ptSkew3 = pt;
pt -= _XW * .5*dDiameter3ConeRemove;
pl.addVertex(pt);
pt += _ZW * .5 * dWidthConnector;
pl.addVertex(pt);
pl.close();
//pl.vis(3);
Body bd1(pl, _YW * dThicknessConnector, -1);
bd.subPart(bd1);
CoordSys csMirror;
csMirror.setToMirroring(Plane(ptScrew, _XW));
bd1.transformBy(csMirror);
bd.subPart(bd1);
// remove the skew parts
{ 
//	double dOffset = U(7.8284);
	double dOffsetPart = U(10.7407);
	double dXb = (ptSkew2 - ptSkew1).length();
	Vector3d vx = ptSkew2 - ptSkew1;
	vx.normalize();
	Vector3d vz = _YW;
	Vector3d vy = vz.crossProduct(vx);
	Point3d _ptSkew2 = ptSkew2-dOffsetPart * vy;
	Point3d _ptSkew1 = ptSkew1-dOffsetPart * vy;
	vx = _ptSkew2 - _ptSkew1;
	vx.normalize();
	vy = vz.crossProduct(vx);
	Point3d ptB = .5 * (_ptSkew2 + _ptSkew1);
	ptB-= _YW * dThicknessConnector;
//	ptB.vis(9);
	Body bdSub(ptB, vx, vy, vz, 1.5*dXb, U(20), U(18), -0.1, 1, 1);
	CoordSys csRotate;
	double dAngSkew = atan((.5 * dDiameter1ConeRemove - .5 * dDiameter2ConeRemove) / dLengthConeRemove);
	csRotate.setToRotation(dAngSkew, -vx, ptB);
	bdSub.transformBy(csRotate);
//	bdSub.vis(9);
	bd.subPart(bdSub);
	csMirror.setToMirroring(Plane(ptScrew, _XW));
	bdSub.transformBy(csMirror);
	bd.subPart(bdSub);
	
	//
	dXb = (ptSkew3 - ptSkew2).length();
	vx = ptSkew3 - ptSkew2;
	vx.normalize();
	vz = _YW;
	vy = vz.crossProduct(vx);
	Point3d _ptSkew3 = ptSkew3-dOffsetPart * vy;
	_ptSkew2 = ptSkew2-dOffsetPart * vy;
//	Point3d ptSkew2 -= dOffset * vy;
	vx = _ptSkew3 - _ptSkew2;
	vx.normalize();
	vy = vz.crossProduct(vx);
	ptB = .5 * (_ptSkew3 + _ptSkew2);
	ptB -= _YW * dThicknessConnector;
	ptB += _ZW * _ZW.dotProduct(_ptSkew3 - ptB);
	bdSub=Body(ptB, vx, vy, vz, 1.5*dXb, U(10), U(18), -1, 1, 1);
	csRotate.setToRotation(dAngSkew, -vx, ptB);
	bdSub.transformBy(csRotate);
	bd.subPart(bdSub);
//	bdSub.vis(9);
	csMirror.setToMirroring(Plane(ptScrew, _XW));
	bdSub.transformBy(csMirror);
	bd.subPart(bdSub);
}
// remove corners
double dDiameterFillet = U(15);
double dDiameterDrillScrew = U(6.3);
pt = ptScrew + _XW * (.5 * dLengthConnector - .5 * dDiameterFillet) + _ZW * (.5 * dWidthConnector - .5 * dDiameterFillet);
Body bdSub(pt, _XW, _ZW, _YW, .5*dDiameterFillet, .5*dDiameterFillet, U(50), 1, 1, 0);
bdSub.subPart(Body(pt - U(50) * _YW, pt + U(50) * _YW, .5 * dDiameterFillet));
Body bdDrill(pt - U(50) * _YW, pt + U(50) * _YW, .5 * dDiameterDrillScrew);
//bdSub.vis(2);
bd.subPart(bdSub);
csMirror.setToMirroring(Plane(ptScrew, _XW));
bdSub.transformBy(csMirror);
bd.subPart(bdSub);
csMirror.setToMirroring(Plane(ptScrew, _ZW));
bdSub.transformBy(csMirror);
bdDrill.transformBy(csMirror);
bd.subPart(bdSub);
bd.subPart(bdDrill);
csMirror.setToMirroring(Plane(ptScrew, _XW));
bdSub.transformBy(csMirror);
bdDrill.transformBy(csMirror);
bd.subPart(bdSub);
bd.subPart(bdDrill);
bdDrill.transformBy(_ZW * U(22.5));
bd.subPart(bdDrill);
bdDrill.transformBy(csMirror);
bd.subPart(bdDrill);
bdDrill.transformBy(-_ZW * U(22.5)-_XW * U(22.5));
bd.subPart(bdDrill);
bd.vis(1);

Point3d ptRefConnector = ptScrew - _YW * dConnectorDistance;
ptRefConnector.vis(1);
_XW.vis(ptRefConnector, 1);
_YW.vis(ptRefConnector, 3);
_ZW.vis(ptRefConnector, 5);
// 
// holes for the screws

Body bdPart;
bdPart.addPart(bd);
bdPart.addPart(bdScrew);
//End Bodies of v60 and v80//endregion 

//region Jig
	String strJigAction1 = "strJigAction1";
	if (_bOnJig && _kExecuteKey==strJigAction1) 
	{ 
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		int iModeDistribution = sModeDistributions.find(sModeDistribution);
		// graphic display of properties
		Display dpp(252);
		Display dpHighlight(3);
		Display dpTxt(5);
//		Display dpSelected(44);
		// uncomment to activate graphics interface !!!
		if(_Map.hasMap("mapProps") && 0)
		{
			// original coord
			Map mapPropsCoord=_Map.getMap("mapPropsCoord");
			Vector3d vecXgraph = mapPropsCoord.getVector3d("vecXgraph");
			Vector3d vecYgraph = mapPropsCoord.getVector3d("vecYgraph");
			Vector3d vecZgraph = mapPropsCoord.getVector3d("vecZgraph");
			Point3d ptStartGraph=mapPropsCoord.getPoint3d("ptStartGraph");
			//
			double dHview = getViewHeight();
			Vector3d vecXview = getViewDirection(0)*.001*dHview;
			Vector3d vecYview = getViewDirection(1)*.001*dHview;
			Vector3d vecZview = getViewDirection(2)*.001*dHview;
			Point3d ptStartGraphView = ptStartGraph;
			// set the point outside of genbeam
			{ 
				Body bdGb = _Map.getBody("bdGb");
				PlaneProfile ppGb = bdGb.shadowProfile(Plane(ptStartGraph, vecZview));
				ppGb.shrink(-U(20));
				// get extents of profile
				LineSeg seg = ppGb.extentInDir(vecXview);
				ptStartGraphView = seg.ptEnd();
			}
			dpTxt.textHeight(dHview*.02);
			dpp.textHeight(dHview*.02);
			CoordSys csGraphTransform;
			csGraphTransform.setToAlignCoordSys(ptStartGraph,vecXgraph,vecYgraph,vecZgraph,
												ptStartGraphView, vecXview, vecYview, vecZview 	);
			Map mapPropsGraph = _Map.getMap("mapProps");
			for (int i=0;i<mapPropsGraph.length();i++) 
			{ 
				Map mapI = mapPropsGraph.getMap(i);
				PlaneProfile ppProp = mapI.getPlaneProfile("ppProp");
				ppProp.transformBy(csGraphTransform);
				dpp.color(252);
				dpp.draw(ppProp, _kDrawFilled);
				if(ppProp.pointInProfile(ptJig)==_kPointInProfile)
					dpHighlight.draw(ppProp, _kDrawFilled, 60);
				String sTxtProp = mapI.getString("txtProp");
				Point3d ptTxtProp = mapI.getPoint3d("ptTxtProp");
				ptTxtProp.transformBy(csGraphTransform);
//				dpp.draw(sTxtProp, ptTxtProp, vecXview, vecYview, 0, 0);
				dpTxt.draw(sTxtProp, ptTxtProp, vecXview, vecYview, 0, 0);
				// options
				Map mapOps = mapI.getMap("mapOps");
				for (int iOp=0;iOp<mapOps.length();iOp++) 
				{ 
					Map mapIop = mapOps.getMap(iOp);
					PlaneProfile ppOp = mapIop.getPlaneProfile("ppOp");
					ppOp.transformBy(csGraphTransform);
					int iColorOp=mapIop.getInt("colorOp");
					dpp.color(iColorOp);
					dpp.draw(ppOp, _kDrawFilled);
					if(ppOp.pointInProfile(ptJig)==_kPointInProfile)
						dpHighlight.draw(ppOp, _kDrawFilled, 60);
					Point3d ptTxtOp = mapIop.getPoint3d("ptTxtOp");
					ptTxtOp.transformBy(csGraphTransform);
					String sTxtOp = mapIop.getString("txtOp");
//					dpp.draw(sTxtOp, ptTxtOp, vecXview, vecYview, 0, 0);
					if(iColorOp==1)
						dpTxt.color(iColorOp);
					dpTxt.draw(sTxtOp, ptTxtOp, vecXview, vecYview, 0, 0);
					dpp.color(252);
					dpTxt.color(5);
				}//next iOp
			}//next i
//			Map map
		}
		
		Point3d ptPlane = _Map.getPoint3d("ptPlane");
//		Vector3d vecPlane = _Map.getVector3d("vecPlane");
		// quad
		Point3d ptCen = _Map.getPoint3d("ptCen");
		Vector3d vecX = _Map.getVector3d("vecX");
		Vector3d vecY = _Map.getVector3d("vecY");
		Vector3d vecZ = _Map.getVector3d("vecZ");
		
		double dLength = _Map.getDouble("dLength");
		double dWidth = _Map.getDouble("dWidth");
		double dHeight = _Map.getDouble("dHeight");
		
		Entity entFemale = _Map.getEntity("bmFemale");
		Beam bmFemale = (Beam)entFemale;
		// 
		double dDiameterThread = _Map.getDouble("dDiameterThread");
		
		Quader qd(ptCen, vecX, vecY, vecZ, dLength, dWidth, dHeight);
		
		Vector3d vecs[] ={ vecX ,- vecX, vecY ,- vecY, vecZ ,- vecZ};
//		Vector3d vecs[] ={ vecY ,- vecY, vecZ ,- vecZ};
		Vector3d vecsValid[0];
		PlaneProfile ppValids[0];
		Map mapVecsValid = _Map.getMap("mapValidVectors");
		String ss;
		for (int iV=0;iV<vecs.length();iV++) 
		{ 
			String sInd = "ind" + iV+1;
			String pInd = "pp" + iV+1;
			if(mapVecsValid.hasInt(sInd))
			{
				vecsValid.append(vecs[iV]);
				ppValids.append(mapVecsValid.getPlaneProfile(pInd));
			}
		}//next iV
		
		Vector3d vecViewdirection = getViewDirection();
		PlaneProfile ppView;
		Vector3d vecValidDirection = vecsValid[0];
		int iVvalid = 0;
		for (int iV=0;iV<vecsValid.length();iV++) 
		{ 
			if(vecViewdirection.dotProduct(vecsValid[iV])>
				vecViewdirection.dotProduct(vecValidDirection))
			{ 
//				vecValidDirection = vecsValid[iV];
//				ppView = ppValids[iV];
				iVvalid = iV;
			}
		}//next iV
		ppView = ppValids[iVvalid];
		vecValidDirection = vecsValid[iVvalid];
		sAlignment.set(sAlignments[vecs.find(vecValidDirection)]);
		Vector3d vecAlignmentThis = vecValidDirection;
//		int indexValid = vecs.find(vecValidDirection);
//		dpTxt.draw("nr valid" + vecsValid.length(), ptJig, _XW, _YW, 0,0,_kDeviceX);
//		dpTxt.draw("indexValid" + indexValid, ptJig, _XW, _YW, 0,0,_kDeviceX);
		
		
//		Vector3d vecAlign = qd.vecD(vecViewdirection);
//		Vector3d vecAlign = bmFemale.vecD(vecViewdirection);
//		for (int iV=0;iV<vecs.length();iV++) 
//		{ 
//			if(vecs[iV].isCodirectionalTo(vecAlign))
//			{ 
//				sAlignment.set(sAlignments[iV]);
//				break;
//			}
//			 
//		}//next iV
		int iAlignment = sAlignments.find(sAlignment);
//		dpTxt.draw("iAlignment" + iAlignment, ptJig, _XW, _YW, 0,0,_kDeviceX);
//		dpTxt.draw("ss" + ss, ptJig, _XW, _YW, 0,0,_kDeviceX);
		Vector3d vecPlane = vecs[iAlignment];
		vecPlane = qd.vecD(vecAlignmentThis);
		Vector3d vecXplane, vecYplane;
//		Plane pn(ptCen + vecPlane * .5 * bmFemale.dD(vecPlane), vecPlane);
		Plane pn(ptCen + vecPlane * .5 * qd.dD(vecPlane), vecPlane);
		
//		Vector3d vecsMain[] ={ vecX, vecY, vecZ};
//		for (int i=0;i<vecsMain.length();i++) 
//		{ 
//			if(!vecPlane.isParallelTo(vecsMain[i]))
//			{ 
//				vecXplane = vecsMain[i];
//				break;
//			}
//		}//next i
		if(!vecPlane.isParallelTo(vecX))
			vecXplane = vecX;
		else if(!vecPlane.isParallelTo(vecY))
			vecXplane = vecY;
		else if(!vecPlane.isParallelTo(vecZ))
			vecXplane = vecZ;
		
		vecYplane = vecPlane.crossProduct(vecXplane);
		
		Display dpJig(3);
//		Point3d ptJigPlane = pn.closestPointTo(ptJig);
		Point3d ptJigPlane = ptJig.projectPoint(pn, dEps, vecViewdirection);
		
		PLine pl;
		pl.createRectangle(LineSeg(ptCen-vecXplane*.5*qd.dD(vecXplane)-vecYplane*.5*qd.dD(vecYplane),
			ptCen + vecXplane * .5 * qd.dD(vecXplane) + vecYplane * .5 * qd.dD(vecYplane)), vecXplane, vecYplane);
		PlaneProfile ppPlane(pn);
		ppPlane.joinRing(pl,_kAdd);
//		dpJig.transparency(98);
//		dpJig.draw(ppPlane, _kDrawFilled, 99);
		dpJig.draw(ppView, _kDrawFilled, 99);
		
		Body bdPart = _Map.getBody("bdPart");
		if(!_Map.hasPoint3d("ptJig0"))
		{ 
			// we are at first prompt, prompt for first point of distribution
			LineSeg lSeg(ptJigPlane-vecXplane*.5*dDiameterThread-vecYplane*.5*dDiameterThread, 
			ptJigPlane + vecXplane * .5 * dDiameterThread + vecYplane * .5 * dDiameterThread);
			dpJig.draw(lSeg);
			CoordSys csRot;
			csRot.setToRotation(90, vecPlane, ptJigPlane);
			lSeg.transformBy(csRot);
			dpJig.draw(lSeg);
			
			pl = PLine();
			pl.createCircle(ptJigPlane, vecPlane, dDiameterThread * .5);
			
			PlaneProfile ppDrill(pn);
			ppDrill.joinRing(pl, _kAdd);
			dpJig.color(1);
			dpJig.draw(ppDrill, _kDrawFilled, 30);
			// draw body
			Vector3d vecYpart = vecPlane;
			Vector3d vecZpart = qd.vecD(_ZW);
			if (vecZpart.isParallelTo(vecYpart))vecZpart = vecX;
			Vector3d vecXpart = vecYpart.crossProduct(vecZpart);
			vecXpart.normalize();
			CoordSys csPartTransform;
			csPartTransform.setToAlignCoordSys(Point3d(0,0,0), _XW, _YW, _ZW, 
				ptJigPlane, vecXpart, vecYpart, vecZpart);
				
			Body bdI = bdPart;
			bdI.transformBy(csPartTransform);
			dpJig.draw(bdI);
		}
		else
		{ 
			// second point of distribution
			Point3d ptStart = _Map.getPoint3d("ptJig0");
			Point3d ptEnd = ptJigPlane;
			Vector3d vecDir = ptEnd - ptStart;vecDir.normalize();
			double dLengthTot = (ptEnd - ptStart).dotProduct(vecDir);
			if (dDistanceBottom + dDistanceTop > dLengthTot)
			{ 
				dpJig.color(1);
				String sText = TN("|no distribution possible|");
				dpJig.draw(sText, ptJigPlane, _XW, _YW, 0, 0, _kDeviceX);
				return;
			}
			double dPartLength = 0;
			Point3d pt1 = ptStart + vecDir * dDistanceBottom;
			Point3d pt2 = ptEnd - vecDir * (dDistanceTop+ dPartLength);
			double dDistTot = (pt2 - pt1).dotProduct(vecDir);
			if (dDistTot < 0)
			{ 
				dpJig.color(1);
				String sText = TN("|no distribution possible|");
				dpJig.draw(sText, ptJigPlane, _XW, _YW, 0, 0, _kDeviceX);
				return;
			}
			Point3d ptsDis[0];
			if (dDistanceBetween >= 0)
			{ 
				// 2 scenarion even, fixed
				if (iModeDistribution == 0)
				{
					// even
					
					// distance in between > 0; distribute with distance
					// modular distance
					double dDistMod = dDistanceBetween + dPartLength;
					int iNrParts = dDistTot / dDistMod;
					double dNrParts = dDistTot / dDistMod;
					if (dNrParts - iNrParts > 0)iNrParts += 1;
					// calculated modular distance between subsequent parts
					
					double dDistModCalc = 0;
					if (iNrParts != 0)
						dDistModCalc = dDistTot / iNrParts;
					
					// first point
					Point3d pt;
					pt = ptStart + vecDir * (dDistanceBottom + dPartLength / 2);
					//				pt.vis(1);
					ptsDis.append(pt);
					if (dDistModCalc > 0)
					{
						for (int i = 0; i < iNrParts; i++)
						{
							pt += vecDir * dDistModCalc;
							//					pt.vis(1);
							ptsDis.append(pt);
						}
					}
					//				dDistanceBetweenResult.set(dDistModCalc-dPartLength);
					// set nr of parts
					//					dDistanceBetweenResult.set(-(ptsDis.length()));
					//				nNrResult.set(ptsDis.length());
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
//					dDistanceBetweenResult.set(dDistModCalc-dPartLength);
					// set nr of parts
				//					dDistanceBetweenResult.set(-(ptsDis.length()));
//					nNrResult.set(ptsDis.length());
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
//				dDistanceBetweenResult.set(dDistModCalc-dPartLength);
				// set nr of parts
//				nNrResult.set(ptsDis.length());
			}
			
			for (int i=0;i<ptsDis.length();i++) 
			{ 
				Point3d pt = ptsDis[i];
				
				pl = PLine();
				pl.createCircle(pt, vecPlane, dDiameterThread * .5);
				
				PlaneProfile ppDrill(pn);
				ppDrill.joinRing(pl, _kAdd);
				dpJig.color(1);
				dpJig.draw(ppDrill, _kDrawFilled, 30);
				// draw body
				// draw body
				Vector3d vecYpart = vecPlane;
				Vector3d vecZpart = qd.vecD(_ZW);
				if (vecZpart.isParallelTo(vecYpart))vecZpart = vecX;
				Vector3d vecXpart = vecYpart.crossProduct(vecZpart);
				vecXpart.normalize();
				CoordSys csPartTransform;
				csPartTransform.setToAlignCoordSys(Point3d(0,0,0), _XW, _YW, _ZW, 
					pt, vecXpart, vecYpart, vecZpart);
					
				Body bdI = bdPart;
				bdI.transformBy(csPartTransform);
				dpJig.draw(bdI);
			}//next i
		}
		return;
	}
//End Jig//endregion 

//region bOnInsert
if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	
	// select 2 beams, first selected defines the male beam
	// prompt for beams
	Beam beams[0];
	PrEntity ssE(T("|Select 2 beams|"), Beam());
	if (ssE.go())
		beams.append(ssE.beamSet());
				
	if(beams.length()<2)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|2 beams needed|"));
		eraseInstance();
		return;
	}
	
	_Beam.append(beams[0]);
	_Beam.append(beams[1]);
	
	
	// get opm key from the _kExecuteKey
	String sTokens[] = _kExecuteKey.tokenize("?");
	
	int iCatalog = false;
	if (sTokens.length() == 1 && _kExecuteKey.length() > 0)
	{
//		reportNotice("\n _kExecuteKey " + _kExecuteKey);
//		String files[] = getFilesInFolder(_kPathHsbCompany + "\\tsl\\catalog\\", scriptName() + " * .xml");
//		for (int i = 0; i < files.length(); i++)
//		{
//			String entry = files[i].left(files[i].length() - 4);
//			reportNotice("\n files " + entry);
//			String sEntries[] = TslInst().getListOfCatalogNames(entry);
//			
//			reportNotice("\n using sEntries " + sEntries);
//			if (sEntries.findNoCase(_kExecuteKey ,- 1) >- 1)
//			{
//				Map map = _ThisInst.mapWithPropValuesFromCatalog(entry, _kExecuteKey);
//				setPropValuesFromMap(map);
//				
//				reportNotice("\n using map " + map);
//				break;
//			}
//		}//next i

		// silent/dialog
		if (_kExecuteKey.length() > 0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			if (sEntries.findNoCase(_kExecuteKey ,- 1) >- 1)
			{
				if(sManufacturers.find(sTokens[0])<0)
				{
					setPropValuesFromCatalog(_kExecuteKey);
					iCatalog = true;
				}
			}
		}
	}
	
	if(!iCatalog)
	{
		String sOpmKey;
		if (sTokens.length() > 0)
		{
			sOpmKey = sTokens[0];
		}
		else
		{
			sOpmKey = "";
		}
		// get the Manufacturer from the _kExecuteKey or from the dialog box
		// validate the opmkeys, should be one of the Manufacturers supported
		if (sOpmKey.length() > 0)
		{
			String s1 = sOpmKey;
			s1.makeUpper();
			int bOk;
			
			for (int i = 0; i < sManufacturers.length(); i++)
			{
				String s2 = sManufacturers[i];
				s2.makeUpper();
				if (s1 == s2)
				{
					bOk = true;
					sManufacturer.set(T(sManufacturers[i]));
					//					setOPMKey(sManufacturers[i]);
					sManufacturer.setReadOnly(true);
					break;
				}
			}//next i
			// the opmKey does not match any family name -> reset
			if ( ! bOk)
			{
				reportNotice("\n" + scriptName() + ": " + T("|NOTE, the specified OPM key| '") +sOpmKey+T("' |cannot be found in the list of Manufacturers.|"));
				sOpmKey = "";
			}
		}
		else
		{
			// sOpmKey not specified, show the dialog
			sManufacturer.setReadOnly(false);
			if (sManufacturers.length() > 0)sManufacturer.set(sManufacturers[1]);
			sFamily.set("---");
			sFamily.setReadOnly(true);
			sProduct.set("---");
			sProduct.setReadOnly(true);
			// alignment
//	//			sAlignment.setReadOnly(false);
//				sAlignment.setReadOnly(_kHidden);
//				dAngle.setReadOnly(false);
//				dGapNail.setReadOnly(false);
//	//			nZone.setReadOnly(_kHidden);
//				// Drill
//				sModeDistribution.setReadOnly(false);
//				dDistanceBottom.setReadOnly(false);
//				dDistanceTop.setReadOnly(false);
//				dDistanceBetween.setReadOnly(false);
			showDialog("---");
			//			setOPMKey(sManufacturer);
			//			sOpmKey = sManufacturer;
		}
	
		// from the mapSetting get all the defined families
		if (sManufacturer != "---")
		{
			if (mapSetting.length() > 0)
			{
				Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
				if (mapManufacturers.length() < 1)
				{
					// wrong definition of the map
					reportMessage(TN("|wrong definition of the map, no Manufacturer|"));
					eraseInstance();
					return;
				}
				// find choosen Manufacturer
				for (int i = 0; i < mapManufacturers.length(); i++)
				{
					Map mapManufacturerI = mapManufacturers.getMap(i);
					if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
					{
						String _sManufacturerName = mapManufacturerI.getString("Name");
						if (_sManufacturerName.makeUpper() != sManufacturer.makeUpper())
						{
							// not this family, keep looking
							continue;
						}
					}
					else
					{
						// not a Manufacturer map
						continue;
					}
					
					// map of the selected Manufacturer is found
					// get its families
					Map mapFamilys = mapManufacturerI.getMap("Family[]");
					if (mapFamilys.length() < 1)
					{
						// wrong definition of the map
						reportMessage(TN("|no Family definition for this manufacturer|"));
						eraseInstance();
						return;
					}
					for (int j = 0; j < mapFamilys.length(); j++)
					{
						Map mapFamilyJ = mapFamilys.getMap(j);
						if (mapFamilyJ.hasString("Name") && mapFamilys.keyAt(j).makeLower() == "family")
						{
							String sName = mapFamilyJ.getString("Name");
							if (sFamilys.find(sName) < 0)
							{
								// populate sFamilies
								sFamilys.append(sName);
								if (bDebug)reportMessage("\n" + scriptName() + " sName: " + sName);
							}
						}
					}
					
					// set the Family
					if (sTokens.length() < 2)//Family not defined in opmkey, showdialog
					{
						// set array of sFamilys and get the first by default
						// manufacturer is set, set as readOnly
						sManufacturer.setReadOnly(true);
						sFamily.setReadOnly(false);
						sFamily = PropString(1, sFamilys, sFamilyName, 0);
						sFamily.set(sFamilys[0]);
						if (sFamilys.length() > 0)sFamily.set(sFamilys[1]);
						sProduct = PropString(2, sProducts, sProductName, 0);
						sProduct.set("---");
						sProduct.setReadOnly(true);
						//
//							sAlignment.setReadOnly(_kHidden);
//							dAngle.setReadOnly(false);
//							dGapNail.setReadOnly(false);
//	//						nZone.setReadOnly(_kHidden);
//							// distribution
//							sModeDistribution.setReadOnly(false);
//							dDistanceBottom.setReadOnly(false);
//							dDistanceTop.setReadOnly(false);
//							dDistanceBetween.setReadOnly(false);
						showDialog("---");
						//					showDialog();

					}
					else
					{
						// see if sTokens[1] is a valid Family name as in sFamilys from mapSetting
						int indexSTokens = sFamilys.find(sTokens[1]);
						if (indexSTokens >- 1)
						{
							// find
							//				sFamily = PropString(1, sFamilys, sFamilyName, indexSTokens);
							sFamily.set(sTokens[1]);
							if (bDebug)reportMessage("\n" + scriptName() + " from tokens ");
						}
						else
						{
							// wrong definition in the opmKey, accept the first Family from the xml
							reportMessage(TN("|wrong definition of the OPM key|"));
							sFamily.set(sFamilys[0]);
							if (sFamilys.length() > 0)sFamily.set(sFamilys[1]);
						}
					}
					if (sFamily != "---")
					{
						// for the chosen family get Familys and nails. first find the map of selected family
						for (int j = 0; j < mapFamilys.length(); j++)
						{
							Map mapFamilyJ = mapFamilys.getMap(j);
							if (mapFamilyJ.hasString("Name") && mapFamilys.keyAt(j).makeLower() == "family")
							{
								String _sFamilyName = mapFamilyJ.getString("Name");
								if (_sFamilyName.makeUpper() != sFamily.makeUpper())
								{
									// not this family, keep looking
									continue;
								}
							}
							else
							{
								// not a manufacturer map
								continue;
							}
							
							// mapFamilyJ is found, populate types and nails
							// map of the selected Family is found
							// get its types
							Map mapProducts = mapFamilyJ.getMap("Product[]");
							if (mapProducts.length() < 1)
							{
								// wrong definition of the map
								reportMessage(TN("|no Product definition for this family|"));
								eraseInstance();
								return;
							}
							
							for (int k = 0; k < mapProducts.length(); k++)
							{
								Map mapProductK = mapProducts.getMap(k);
								//								if (mapProductK.hasString("Name") && mapProducts.keyAt(k).makeLower() == "product")
								if (mapProductK.hasString("Name") && mapProducts.keyAt(k).makeLower() == "product")
								{
									//									String sName = mapProductK.getString("Name");
									String sName = mapProductK.getString("Name");
									if (sProducts.find(sName) < 0)
									{
										// populate sProducts
										sProducts.append(sName);
										if (bDebug)reportMessage("\n" + scriptName() + " sName: " + sName);
									}
								}
							}
							
							// set the family
							if (sTokens.length() < 3)
							{
								// Product not set in opm key, show the dialog to get the opm key
								// set array of sProducts and get the first by default
								// family is set, set as readOnly
								sManufacturer.setReadOnly(true);
								sFamily.setReadOnly(true);
								
								sProduct.setReadOnly(false);
								sProduct = PropString(2, sProducts, sProductName, 0);
								sProduct.set(sProducts[0]);
								if (sProducts.length() > 0)sProduct.set(sProducts[1]);
								// Alignment
//									sAlignment.setReadOnly(_kHidden);
//									dAngle.setReadOnly(false);
//									dGapNail.setReadOnly(false);
//	//								nZone.setReadOnly(_kHidden);
//									// distribution
//									sModeDistribution.setReadOnly(false);
//									dDistanceBottom.setReadOnly(false);
//									dDistanceTop.setReadOnly(false);
//									dDistanceBetween.setReadOnly(false);
								showDialog("---");
								//						showDialog();
								if (bDebug)reportMessage("\n" + scriptName() + " from dialog ");
								if (bDebug)reportMessage("\n" + scriptName() + " sProduct " + sProduct);
							}
							else
							{
								// see if sTokens[1] is a valid family name as in sFamilys from mapSetting
								int indexSTokens = sProducts.find(sTokens[1]);
								if (indexSTokens >- 1)
								{
									// find
									//				sModel = PropString(1, sModels, sModelName, indexSTokens);
									sProduct.set(sTokens[1]);
									if (bDebug)reportMessage("\n" + scriptName() + " from tokens ");
								}
								else
								{
									// wrong definition in the opmKey, accept the first family from the xml
									reportMessage(TN("|wrong definition of the OPM key|"));
									sProduct.set(sProducts[0]);
									if (sProducts.length() > 0)sProduct.set(sProducts[1]);
								}
							}
							// familys and nails are set
							break;
						}
						// family is set
						break;
					}
					else
					{
						sProduct.set(sProducts[0]);
						if (sProducts.length() > 0)sProduct.set(sProducts[1]);
						break;
					}
				}
			}
		}
		else
		{
			sFamily.set(sFamilys[0]);
			if (sFamilys.length() > 0)sFamily.set(sFamilys[1]);
			sProduct.set(sProducts[0]);
			if (sProducts.length() > 0)sProduct.set(sProducts[1]);
		}
	}
	
	Map mapFamily;
	Map mapProduct;
	int iFamilyFound = false;
	int iProductFound = false;
	{ 
		Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
		if(sManufacturer!="---")
		{ 
			for (int i = 0; i < mapManufacturers.length(); i++)
			{ 
				Map mapManufacturerI = mapManufacturers.getMap(i);
				if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
				{
					String _sManufacturerName = mapManufacturerI.getString("Name");
					String _sManufacturer = sManufacturer;_sManufacturer.makeUpper();
					if (_sManufacturerName.makeUpper() == _sManufacturer)
					{
						// this manufacturer
						Map mapManufacturer = mapManufacturerI;
						Map mapFamilys = mapManufacturer.getMap("Family[]");
						for (int ii = 0; ii < mapFamilys.length(); ii++)
						{
							Map mapFamilyI = mapFamilys.getMap(ii);
							if (mapFamilyI.hasString("Name") && mapFamilys.keyAt(ii).makeLower() == "family")
							{
	//							String sName = mapFamilyI.getString("Name");
								String _sFamilyName = mapFamilyI.getString("Name");
								String _sFamily = sFamily;_sFamily.makeUpper();
								if (_sFamilyName.makeUpper() == _sFamily)
								{ 
									// this family
									mapFamily = mapFamilyI;
									iFamilyFound = true;
									Map mapProducts = mapFamily.getMap("Product[]");
									for (int iii = 0; iii < mapProducts.length(); iii++)
									{ 
										Map mapProductI = mapProducts.getMap(iii);
										if (mapProductI.hasString("Name") && mapProducts.keyAt(iii).makeLower() == "product")
										{ 
											String _sProductName = mapProductI.getString("Name");
											String _sProduct = sProduct;_sProduct.makeUpper();
											if (_sProductName.makeUpper() == _sProduct)
											{ 
												mapProduct = mapProductI;
												iProductFound = true;
												break;
											}
										}
									}
									if (iProductFound)break;
								}
							}
						}
						if (iProductFound)break;
					}
				}
			}
		}
	}
	
	// body of part
	Body bdPart;
	{ 
		Map mapConnector=mapProduct.getMap("Connector");
		double dLengthPart, dWidthPart, dThicknessPart;
		String s;
		s = "Length"; if(mapConnector.hasDouble(s))dLengthPart = mapConnector.getDouble(s);
		s = "Width"; if(mapConnector.hasDouble(s))dWidthPart = mapConnector.getDouble(s);
		s = "Thickness"; if(mapConnector.hasDouble(s))dThicknessPart = mapConnector.getDouble(s);
		Point3d ptScrew = Point3d(0,0,0);
		Body bd(ptScrew, _XW, _ZW, -_YW, 
			dLengthConnector, dWidthConnector, dThicknessPart, 
			0, 0, 1);
		bdPart = bd;
	}
	
	Beam bm0 = _Beam[0];
	Beam bm = _Beam[1];
	
	
	// basic information
	Point3d ptCen0 = bm0.ptCen();
	Vector3d vecX0 = bm0.vecX();
	Vector3d vecY0 = bm0.vecY();
	Vector3d vecZ0 = bm0.vecZ();
	
	Point3d ptCen = bm.ptCen();
	Vector3d vecX = bm.vecX();
	Vector3d vecY = bm.vecY();
	Vector3d vecZ = bm.vecZ();
	
	int iModeDistribution = sModeDistributions.find(sModeDistribution);
	String sStringStart = "|Select first point [";
	String sStringStart2 = "|Select second point [";
	String sClickOption="firstDrill/";
	String sDistributeOptions;
	if(iModeDistribution==0)
	{ 
		sDistributeOptions = "Fixed/";
	}
	else if(iModeDistribution==1)
	{ 
		sDistributeOptions = "eVen/";
	}
	sDistributeOptions += "Start/";
	sDistributeOptions += "End/";
	sDistributeOptions += "Between]|";
	
	PrPoint ssP(sStringStart+sDistributeOptions);
	PrPoint ssP2(sStringStart2 + sClickOption+sDistributeOptions, _Pt0);
	
	Map mapArgs;
	mapArgs.setString("alignment", sAlignment);
	mapArgs.setString("modeDistribution", sModeDistribution);
	
	Quader qd(ptCen, vecX, vecY, vecZ, bm.solidLength(), bm.solidWidth(), bm.solidHeight());
	Quader qd0(ptCen0, vecX0, vecY0, vecZ0, bm0.solidLength(), bm0.solidWidth(), bm0.solidHeight());
	mapArgs.setBody("bdPart", bdPart);
	mapArgs.setPoint3d("ptCen", ptCen);
	mapArgs.setVector3d("vecX", vecX);
	mapArgs.setVector3d("vecY", vecY);
	mapArgs.setVector3d("vecZ", vecZ);
	mapArgs.setDouble("dLength", bm.solidLength());
	mapArgs.setDouble("dWidth", bm.solidWidth());
	mapArgs.setDouble("dHeight", bm.solidHeight());
	mapArgs.setBody("bdGb", bm.envelopeBody());
	mapArgs.setEntity("bmFemale", bm);
	
	mapArgs.setDouble("dDiameterThread", U(10));
	
	int iSingle = false;
	int iFirstPrompt = true;
	int nGoJig = -1;
	Vector3d vecs[] ={ vecX,-vecX, vecY , -vecY, vecZ ,- vecZ};
	Vector3d vecs0[] ={ vecX0,-vecX0, vecY0 , -vecY0, vecZ0 ,- vecZ0};
	Vector3d vecsValid[0];
	int iVecsValid[0];// indices of valid vectors
	Map mapVecsValid;
	for (int iV=0;iV<vecs.length();iV++) 
	{ 
		Vector3d vecXplane, vecX0plane;
		if(!vecs[iV].isParallelTo(vecX))
			vecXplane = vecX;
		else if(!vecs[iV].isParallelTo(vecY))
			vecXplane = vecY;
		else if(!vecs[iV].isParallelTo(vecZ))
			vecXplane = vecZ0;
		// bm0
		if(!vecs[iV].isParallelTo(vecX0))
			vecX0plane = vecX0;
		else if(!vecs[iV].isParallelTo(vecY0))
			vecX0plane = vecY0;
		else if(!vecs[iV].isParallelTo(vecZ0))
			vecX0plane = vecZ0;
//		Point3d ptPn = ptCen;// + .5 * bm.dD(vecs[iV] * vecs[iV]);
		Point3d ptPn = ptCen+ .5 * qd.dD(vecs[iV]) * vecs[iV];
		Plane pn(ptPn, vecs[iV]);
		PlaneProfile ppI0(pn);
		PlaneProfile ppI1(pn);
		PLine plRec();
		Vector3d vecN = vecXplane.crossProduct(vecs[iV]);
		Vector3d vecN0 = vecX0plane.crossProduct(vecs[iV]);
		plRec.createRectangle(LineSeg(ptCen-qd.vecD(vecN)*.5*qd.dD(vecN)-.5*vecXplane*qd.dD(vecXplane),
			ptCen + qd.vecD(vecN) * .5 * qd.dD(vecN) + .5 * vecXplane * qd.dD(vecXplane)), qd.vecD(vecN), vecXplane);
		ppI1.joinRing(plRec, _kAdd);
		plRec = PLine();
		
		plRec = PLine();
		plRec.createRectangle(LineSeg(ptCen0-qd0.vecD(vecN0)*.5*qd0.dD(vecN0)-.5*vecX0plane*qd0.dD(vecX0plane),
			ptCen0 + qd0.vecD(vecN0) * .5 * qd0.dD(vecN0) + .5 * vecX0plane * qd0.dD(vecX0plane)), qd0.vecD(vecN0), vecX0plane);
		ppI0.joinRing(plRec, _kAdd);
		
		if(ppI1.intersectWith(ppI0))
		{ 
			vecsValid.append(vecs[iV]);
			iVecsValid.append(iV);
//			reportMessage("\n"+scriptName()+" "+T("|iV|"+iV));
			String sInd = "ind" + iV+1;
			String pInd = "pp" + iV+1;
			mapVecsValid.setInt(sInd,iV);
			mapVecsValid.setPlaneProfile(pInd, ppI1);
		}
	}//next iV
	mapArgs.setMap("mapValidVectors", mapVecsValid);
	
	// create a map for each property
	PlaneProfile ppMode, ppModes[0];
	PlaneProfile ppStart, ppEnd, ppBetween;
	Vector3d vecXgraph;
	Vector3d vecYgraph;
	Vector3d vecZgraph;
	Point3d ptStartGraph;
	// valid vectors where there exist a commonplaneprofile
	
	// 
	Map mapPropsGraph;
	Map mapMode, mapModeOps;
	Map mapStart, mapEnd, mapBetween;
	int iColorSelected = 1;
	{ 
		vecXgraph = _XW;
		vecYgraph = _YW;
		vecZgraph = _ZW;
		ptStartGraph = ptCen;
		
		Map mapPropsCoord;
		mapPropsCoord.setPoint3d("ptStartGraph", ptStartGraph, _kAbsolute);
		mapPropsCoord.setVector3d("vecXgraph", vecXgraph, _kAbsolute);
		mapPropsCoord.setVector3d("vecYgraph", vecYgraph, _kAbsolute);
		mapPropsCoord.setVector3d("vecZgraph", vecZgraph, _kAbsolute);
		double dLengthBox = U(100);
		double dWidthBox = U(70);
		double dGapBox = U(10);
		Point3d pt = ptStartGraph;
		PlaneProfile ppBox(Plane(ptStartGraph, vecZgraph));
		{ 
			PLine pl;
			pl.createRectangle(LineSeg(pt, 
				pt + vecXgraph*dLengthBox - vecYgraph*dWidthBox), vecXgraph, vecYgraph);
			ppBox.joinRing(pl, _kAdd);
		}
		// mapMode
		{ 
//				pt += (dLengthBox + dGapBox) * vecXgraph;
			PlaneProfile pp=ppBox;
			pp.transformBy(pt - ptStartGraph);
			// property name
			mapMode.setPlaneProfile("ppProp", pp);
			ppMode = pp;
			String _sModeDistributionName = T("|Mode\P of \PDistribution|");
			mapMode.setString("txtProp", _sModeDistributionName);
			Point3d ptTxtProp = pt + .5 * dLengthBox * vecXgraph - .5 * dWidthBox * vecYgraph;
			mapMode.setPoint3d("ptTxtProp", ptTxtProp, _kAbsolute);
			
			// Options
			Map mapOps;
			Map mapEven = mapMode;
			PlaneProfile ppI= pp;
			ppI.transformBy(-vecYgraph * (dWidthBox+dGapBox));
			pt.transformBy(-vecYgraph * (dWidthBox+dGapBox));
			Point3d ptTxtOp = pt + .5 * dLengthBox * vecXgraph - .5 * dWidthBox * vecYgraph;
			mapEven.setPlaneProfile("ppOp", ppI);
			int iColorOp = 252;
			if (iModeDistribution == 0)iColorOp = iColorSelected;
			mapEven.setPoint3d("ptTxtOp", ptTxtOp, _kAbsolute);
			mapEven.setString("txtOp", T("|Even|"));
			mapEven.setInt("colorOp", iColorOp);
			ppModes.append(ppI);
			mapOps.appendMap("mapOp", mapEven);
			Map mapFixed=mapMode;
			ppI.transformBy(-vecYgraph * (dWidthBox+dGapBox));
			pt.transformBy(-vecYgraph * (dWidthBox+dGapBox));
			ptTxtOp = pt + .5 * dLengthBox * vecXgraph - .5 * dWidthBox * vecYgraph;
			iColorOp = 252;
			if (iModeDistribution == 1)iColorOp = iColorSelected;
			mapFixed.setPlaneProfile("ppOp", ppI);
			mapFixed.setPoint3d("ptTxtOp", ptTxtOp, _kAbsolute);
			mapFixed.setString("txtOp", T("|Fixed|"));
			mapFixed.setInt("colorOp", iColorOp);
			ppModes.append(ppI);
			mapOps.appendMap("mapOp", mapFixed);
			//
			mapModeOps = mapOps;
			mapMode.setMap("mapOps", mapOps);
			mapPropsGraph.appendMap("mapProp", mapMode);
		}
		// mapStart;
		{ 
			pt = ptStartGraph + vecXgraph*1*(dLengthBox + dGapBox);
			PlaneProfile pp=ppBox;
			pp.transformBy(pt - ptStartGraph);
			mapStart.setPlaneProfile("ppProp", pp);
			ppStart = pp;
			String _sDistanceBottomName = T("|Start \P Distance|")+"\P"+dDistanceBottom;
			mapStart.setString("txtProp", _sDistanceBottomName);
			Point3d ptTxtProp = pt + .5 * dLengthBox * vecXgraph - .5 * dWidthBox * vecYgraph;
			mapStart.setPoint3d("ptTxtProp", ptTxtProp, _kAbsolute);
			mapPropsGraph.appendMap("mapProp", mapStart);
		}
		// mapEnd;
		{ 
			pt = ptStartGraph + vecXgraph*2*(dLengthBox + dGapBox);
			PlaneProfile pp=ppBox;
			pp.transformBy(pt - ptStartGraph);
			mapEnd.setPlaneProfile("ppProp", pp);
			ppEnd = pp;
			String _sDistanceTopName = T("|End \P Distance|")+"\P"+dDistanceTop;
			mapEnd.setString("txtProp", _sDistanceTopName);
			Point3d ptTxtProp = pt + .5 * dLengthBox * vecXgraph - .5 * dWidthBox * vecYgraph;
			mapEnd.setPoint3d("ptTxtProp", ptTxtProp, _kAbsolute);
			mapPropsGraph.appendMap("mapProp", mapEnd);
		}
		// mapBetween;
		{ 
			pt = ptStartGraph + vecXgraph*3*(dLengthBox + dGapBox);
			PlaneProfile pp=ppBox;
			pp.transformBy(pt - ptStartGraph);
			mapBetween.setPlaneProfile("ppProp", pp);
			ppBetween = pp;
			String _sDistanceTopName = T("|Between \P Distance|")+"\P"+dDistanceBetween;
			mapBetween.setString("txtProp", _sDistanceTopName);
			Point3d ptTxtProp = pt + .5 * dLengthBox * vecXgraph - .5 * dWidthBox * vecYgraph;
			mapBetween.setPoint3d("ptTxtProp", ptTxtProp, _kAbsolute);
			mapPropsGraph.appendMap("mapProp", mapBetween);
		}
		mapArgs.setMap("mapProps", mapPropsGraph);
		mapArgs.setMap("mapPropsCoord", mapPropsCoord);
		
	}
	while (nGoJig != _kOk && nGoJig != _kNone)
	{
		int iGo = -1;
		if (iFirstPrompt)
		{
			nGoJig = ssP.goJig(strJigAction1, mapArgs);
		}
		else
		{
			nGoJig = ssP2.goJig(strJigAction1, mapArgs);
		}
		
		if (nGoJig == _kOk)
		{
			//				_Pt0 = ssP.value(); //retrieve the selected point
			//				_PtG.append(ptLast); //append the selected points to the list of grippoints _PtG
			Point3d ptJig;
			if (iFirstPrompt)
				ptJig = ssP.value();
			else
				ptJig = ssP2.value();
			
			if(0)
			{ 
				// activate for graphics interface
			
			
			// original coord
			//
			double dHview = getViewHeight();
			Vector3d vecXview = getViewDirection(0) * .001 * dHview;
			Vector3d vecYview = getViewDirection(1) * .001 * dHview;
			Vector3d vecZview = getViewDirection(2) * .001 * dHview;
			Point3d ptStartGraphView = ptStartGraph;
			// set the point outside of genbeam
			{
				PlaneProfile ppGb = bm.envelopeBody().shadowProfile(Plane(ptStartGraph, vecZview));
				ppGb.shrink(-U(20));
				// get extents of profile
				LineSeg seg = ppGb.extentInDir(vecXview);
				ptStartGraphView = seg.ptEnd();
			}
			CoordSys csGraphTransform;
			csGraphTransform.setToAlignCoordSys(ptStartGraph, vecXgraph, vecYgraph, vecZgraph,
			ptStartGraphView, vecXview, vecYview, vecZview);
			int iGraphClick;

			PlaneProfile ppModeTransform = ppMode;
			ppModeTransform.transformBy(csGraphTransform);
			if (ppModeTransform.pointInProfile(ptJig) == _kPointInProfile)
			{
				iGraphClick = true;
				nGoJig = - 1;
				continue;
			}
			Map mapModeOpsNew;
			for (int iM = 0; iM < ppModes.length(); iM++)
			{
				PlaneProfile ppModesTransformI = ppModes[iM];
				ppModesTransformI.transformBy(csGraphTransform);
				if (ppModesTransformI.pointInProfile(ptJig) == _kPointInProfile)
				{
					iGraphClick = true;
					sModeDistribution.set(sModeDistributions[iM]);
					for (int iiM = 0; iiM < mapModeOps.length(); iiM++)
					{
						Map mapI = mapModeOps.getMap(iiM);
						if (iiM != iM)
						{
							//
							mapI.setInt("colorOp", 252);
							mapModeOpsNew.appendMap("mapOp", mapI);
						}
						else
						{
							//
							mapI.setInt("colorOp", iColorSelected);
							mapModeOpsNew.appendMap("mapOp", mapI);
						}
					}//next iiM
					// update ssP
					String sDistributeOptions;
					int iModeDistribution = sModeDistributions.find(sModeDistribution);
					if (iModeDistribution == 0)
					{
						sDistributeOptions = "Fixed/";
					}
					else if (iModeDistribution == 1)
					{
						sDistributeOptions = "eVen/";
					}
					sDistributeOptions += "Start/";
					sDistributeOptions += "End/";
					sDistributeOptions += "Between]|";
					ssP = PrPoint(sStringStart + sDistributeOptions);
					ssP2 = PrPoint(sStringStart2 + sClickOption + sDistributeOptions, _Pt0);
					//
					nGoJig = - 1;
					// continue for loop
					//						continue;
					break;
				}
			}//next iM
			if (iGraphClick)
			{
				mapMode.setMap("mapOps", mapModeOpsNew);
				Map mapPropsGraphNew;
				for (int iM = 0; iM < mapPropsGraph.length(); iM++)
				{
					if (iM == 0)
					{
						mapPropsGraphNew.appendMap("mapProp", mapMode);
					}
					else
					{
						Map mm = mapPropsGraph.getMap(iM);
						mapPropsGraphNew.appendMap("mapProp", mm);
					}
				}//next iM
				
				//					mapPropsGraph.appendMap("mapProp", mapMode);
				mapPropsGraph = mapPropsGraphNew;
				mapArgs.setMap("mapProps", mapPropsGraph);
				nGoJig = - 1;
				continue;
			}
			PlaneProfile ppStartTransform = ppStart;
			ppStartTransform.transformBy(csGraphTransform);
			if (ppStartTransform.pointInProfile(ptJig) == _kPointInProfile)
			{
				String sEnter = getString(TN("|Enter Start Distance|") + " " + dDistanceBottom);
				dDistanceBottom.set(sEnter.atof());
				Map mapStartNew = mapStart;
				String _sDistanceBottomName = T("|Start \P Distance|") + "\P" + dDistanceBottom;
				mapStartNew.setString("txtProp", _sDistanceBottomName);
				Map mapPropsGraphNew;
				for (int iM = 0; iM < mapPropsGraph.length(); iM++)
				{
					if (iM == 1)
					{
						mapPropsGraphNew.appendMap("mapProp", mapStartNew);
					}
					else
					{
						Map mm = mapPropsGraph.getMap(iM);
						mapPropsGraphNew.appendMap("mapProp", mm);
					}
					
				}//next iM
				mapPropsGraph = mapPropsGraphNew;
				mapArgs.setMap("mapProps", mapPropsGraph);
				iGraphClick = true;
				nGoJig = - 1;
				// next while loop
				continue;
			}
			PlaneProfile ppEndTransform = ppEnd;
			ppEndTransform.transformBy(csGraphTransform);
			if (ppEndTransform.pointInProfile(ptJig) == _kPointInProfile)
			{
				String sEnter = getString(TN("|Enter End Distance|") + " " + dDistanceTop);
				dDistanceTop.set(sEnter.atof());
				Map mapEndNew = mapEnd;
				String _sDistanceTopName = T("|End \P Distance|") + "\P" + dDistanceTop;
				mapEndNew.setString("txtProp", _sDistanceTopName);
				Map mapPropsGraphNew;
				for (int iM = 0; iM < mapPropsGraph.length(); iM++)
				{
					if (iM == 2)
					{
						mapPropsGraphNew.appendMap("mapProp", mapEndNew);
					}
					else
					{
						Map mm = mapPropsGraph.getMap(iM);
						mapPropsGraphNew.appendMap("mapProp", mm);
					}
				}//next iM
				mapPropsGraph = mapPropsGraphNew;
				mapArgs.setMap("mapProps", mapPropsGraph);
				iGraphClick = true;
				nGoJig = - 1;
				// next while loop
				continue;
			}
			PlaneProfile ppBetweenTransform = ppBetween;
			ppBetweenTransform.transformBy(csGraphTransform);
			if (ppBetweenTransform.pointInProfile(ptJig) == _kPointInProfile)
			{
				String sEnter = getString(TN("|Enter Between Distance|") + " " + dDistanceBetween);
				dDistanceBetween.set(sEnter.atof());
				Map mapBetweenNew = mapBetween;
				String _sDistanceBetweenName = T("|Between \P Distance|") + "\P" + dDistanceBetween;
				mapBetweenNew.setString("txtProp", _sDistanceBetweenName);
				Map mapPropsGraphNew;
				for (int iM = 0; iM < mapPropsGraph.length(); iM++)
				{
					if (iM == 3)
					{
						mapPropsGraphNew.appendMap("mapProp", mapBetweenNew);
					}
					else
					{
						Map mm = mapPropsGraph.getMap(iM);
						mapPropsGraphNew.appendMap("mapProp", mm);
					}
				}//next iM
				mapPropsGraph = mapPropsGraphNew;
				mapArgs.setMap("mapProps", mapPropsGraph);
				iGraphClick = true;
				nGoJig = - 1;
				// next while loop
				continue;
			}
			
			}
			
			Vector3d vecViewdirection = getViewDirection();
			Vector3d vecValidDirection = vecsValid[0];
			for (int iV=0;iV<vecsValid.length();iV++) 
			{ 
				if(vecViewdirection.dotProduct(vecsValid[iV])>
					vecViewdirection.dotProduct(vecValidDirection))
				{ 
					vecValidDirection = vecsValid[iV];
				}
			}//next iV
			sAlignment.set(sAlignments[vecs.find(vecValidDirection)]);
			mapArgs.setVector3d("vecAlignment", vecValidDirection);
			_Map.setVector3d("vecAlignment", vecValidDirection);
//			Vector3d vecAlign = qd.vecD(vecViewdirection);
//			Vector3d vecAlign = bm.vecD(vecViewdirection);
//			for (int iV = 0; iV < vecs.length(); iV++)
//			{
//				if (vecs[iV].isCodirectionalTo(vecAlign))
//				{
//					sAlignment.set(sAlignments[iV]);
//					break;
//				}
//				
//			}//next iV
			
			int iAlignment = sAlignments.find(sAlignment);
			
			Vector3d vecPlane = vecs[iAlignment];
			vecPlane = vecValidDirection;
			Vector3d vecXplane, vecYplane;
			Plane pn(ptCen + vecPlane * .5 * qd.dD(vecPlane), vecPlane);
			
//			Vector3d vecsMain[] ={ vecX, vecY, vecZ};
//			for (int i = 0; i < vecsMain.length(); i++)
//			{
//				if ( ! vecPlane.isParallelTo(vecsMain[i]))
//				{
//					vecXplane = vecsMain[i];
//					break;
//				}
//			}//next i
			vecXplane = vecX;
			if(!vecPlane.isParallelTo(vecX))
				vecXplane = vecX;
			else if(!vecPlane.isParallelTo(vecY))
				vecXplane = vecY;
			else if(!vecPlane.isParallelTo(vecZ))
				vecXplane = vecZ;
			vecYplane = vecPlane.crossProduct(vecXplane);
			
			Point3d ptJigPlane = ptJig.projectPoint(pn, dEps, vecViewdirection);
			//				Point3d ptJigPlane = pn.closestPointTo(ptJig);
			// update request if changed
			String sDistributeOptions;
			int iModeDistribution = sModeDistributions.find(sModeDistribution);
			if (iModeDistribution == 0)
			{
				sDistributeOptions = "Fixed/";
			}
			else if (iModeDistribution == 1)
			{
				sDistributeOptions = "eVen/";
			}
			sDistributeOptions += "Start/";
			sDistributeOptions += "End/";
			sDistributeOptions += "Between]|";
			ssP = PrPoint(sStringStart + sDistributeOptions);
			if (iFirstPrompt)
			{
				mapArgs.setPoint3d("ptJig0", ptJigPlane);
				_Pt0 = ptJigPlane;
				
				if ( ! iSingle)
				{
					// not single distance, distribution
					iFirstPrompt = false;
					//						ssP2 = PrPoint(sStringStart2+sAlignmentOptionCurrent, _Pt0);
					ssP2 = PrPoint(sStringStart2 + sClickOption + sDistributeOptions, _Pt0);
					nGoJig = - 1;
				}
			}
			else
			{
				mapArgs.setPoint3d("ptJig1", ptJigPlane);
				_PtG.append(ptJigPlane);
			}
			_Map.setMap("mapJig", mapArgs );
		}
		else if (nGoJig == _kKeyWord)
		{
			int iIndex = - 1;
			if (iFirstPrompt)
				iIndex = ssP.keywordIndex();
			else
				iIndex = ssP2.keywordIndex();
			if (iIndex >= 0)
			{
				int iModeDistribution = sModeDistributions.find(sModeDistribution);
				if (iFirstPrompt)
				{
					String sDistributeOptions;
					// its prompt for first point
					if (ssP.keywordIndex() == 0)
					{
						if (iModeDistribution == 0)
						{
							sModeDistribution.set(sModeDistributions[1]);
							sDistributeOptions = "eVen/";
						}
						else
						{
							sModeDistribution.set(sModeDistributions[0]);
							sDistributeOptions = "Fixed/";
						}
						sDistributeOptions += "Start/";
						sDistributeOptions += "End/";
						sDistributeOptions += "Between]|";
						ssP = PrPoint(sStringStart + sDistributeOptions);
						// update map of graphics
						Map mapModeOpsNew;
						for (int iiM = 0; iiM < mapModeOps.length(); iiM++)
						{
							Map mapI = mapModeOps.getMap(iiM);
							if (iiM == iModeDistribution)
							{
								//
								mapI.setInt("colorOp", 252);
								mapModeOpsNew.appendMap("mapOp", mapI);
							}
							else
							{
								//
								mapI.setInt("colorOp", iColorSelected);
								mapModeOpsNew.appendMap("mapOp", mapI);
							}
						}//next iiM
						mapMode.setMap("mapOps", mapModeOpsNew);
						Map mapPropsGraphNew;
						for (int iM = 0; iM < mapPropsGraph.length(); iM++)
						{
							if (iM == 0)
							{
								mapPropsGraphNew.appendMap("mapProp", mapMode);
							}
							else
							{
								Map mm = mapPropsGraph.getMap(iM);
								mapPropsGraphNew.appendMap("mapProp", mm);
							}
						}//next iM
						mapPropsGraph = mapPropsGraphNew;
						mapArgs.setMap("mapProps", mapPropsGraph);
					}
					else if (ssP.keywordIndex() == 1)
					{
						String sEnter = getString(TN("|Enter Start Distance|") + " " + dDistanceBottom);
						dDistanceBottom.set(sEnter.atof());
						// update map
						Map mapStartNew = mapStart;
						String _sDistanceBottomName = T("|Start \P Distance|") + "\P" + dDistanceBottom;
						mapStartNew.setString("txtProp", _sDistanceBottomName);
						Map mapPropsGraphNew;
						for (int iM = 0; iM < mapPropsGraph.length(); iM++)
						{
							if (iM == 1)
							{
								mapPropsGraphNew.appendMap("mapProp", mapStartNew);
							}
							else
							{
								Map mm = mapPropsGraph.getMap(iM);
								mapPropsGraphNew.appendMap("mapProp", mm);
							}
							
						}//next iM
						mapPropsGraph = mapPropsGraphNew;
						mapArgs.setMap("mapProps", mapPropsGraph);
					}
					else if (ssP.keywordIndex() == 2)
					{
						String sEnter = getString(TN("|Enter End Distance|") + " " + dDistanceTop);
						dDistanceTop.set(sEnter.atof());
						// update map
						Map mapEndNew = mapEnd;
						String _sDistanceTopName = T("|End \P Distance|") + "\P" + dDistanceTop;
						mapEndNew.setString("txtProp", _sDistanceTopName);
						Map mapPropsGraphNew;
						for (int iM = 0; iM < mapPropsGraph.length(); iM++)
						{
							if (iM == 2)
							{
								mapPropsGraphNew.appendMap("mapProp", mapEndNew);
							}
							else
							{
								Map mm = mapPropsGraph.getMap(iM);
								mapPropsGraphNew.appendMap("mapProp", mm);
							}
						}//next iM
						mapPropsGraph = mapPropsGraphNew;
						mapArgs.setMap("mapProps", mapPropsGraph);
					}
					else if (ssP.keywordIndex() == 3)
					{
						String sEnter = getString(TN("|Enter Between Distance|") + " " + dDistanceBetween);
						dDistanceBetween.set(sEnter.atof());
						// update map
						Map mapBetweenNew = mapBetween;
						String _sDistanceBetweenName = T("|Between \P Distance|") + "\P" + dDistanceBetween;
						mapBetweenNew.setString("txtProp", _sDistanceBetweenName);
						Map mapPropsGraphNew;
						for (int iM = 0; iM < mapPropsGraph.length(); iM++)
						{
							if (iM == 3)
							{
								mapPropsGraphNew.appendMap("mapProp", mapBetweenNew);
							}
							else
							{
								Map mm = mapPropsGraph.getMap(iM);
								mapPropsGraphNew.appendMap("mapProp", mm);
							}
						}//next iM
						mapPropsGraph = mapPropsGraphNew;
						mapArgs.setMap("mapProps", mapPropsGraph);
					}
				}
				else
				{
					String sDistributeOptions;
					// prompt for seond point
					if (ssP2.keywordIndex() == 0)
					{
						mapArgs.removeAt("ptJig0", true);
						iFirstPrompt = true;
						if (iModeDistribution == 0)
						{
							sDistributeOptions = "Fixed/";
						}
						else
						{
							sDistributeOptions = "eVen/";
						}
						sDistributeOptions += "Start/";
						sDistributeOptions += "End/";
						sDistributeOptions += "Between]|";
						ssP = PrPoint(sStringStart + sDistributeOptions);
						nGoJig = - 1;
					}
					else if (ssP2.keywordIndex() == 1)
					{
						if (iModeDistribution == 0)
						{
							sModeDistribution.set(sModeDistributions[1]);
							sDistributeOptions = "eVen/";
						}
						else
						{
							sModeDistribution.set(sModeDistributions[0]);
							sDistributeOptions = "Fixed/";
						}
						sDistributeOptions += "Start/";
						sDistributeOptions += "End/";
						sDistributeOptions += "Between]|";
						ssP2 = PrPoint(sStringStart2 + sClickOption + sDistributeOptions, _Pt0);
						// update map of graphics
						Map mapModeOpsNew;
						for (int iiM = 0; iiM < mapModeOps.length(); iiM++)
						{
							Map mapI = mapModeOps.getMap(iiM);
							if (iiM == iModeDistribution)
							{
								//
								mapI.setInt("colorOp", 252);
								mapModeOpsNew.appendMap("mapOp", mapI);
							}
							else
							{
								//
								mapI.setInt("colorOp", iColorSelected);
								mapModeOpsNew.appendMap("mapOp", mapI);
							}
						}//next iiM
						mapMode.setMap("mapOps", mapModeOpsNew);
						Map mapPropsGraphNew;
						for (int iM = 0; iM < mapPropsGraph.length(); iM++)
						{
							if (iM == 0)
							{
								mapPropsGraphNew.appendMap("mapProp", mapMode);
							}
							else
							{
								Map mm = mapPropsGraph.getMap(iM);
								mapPropsGraphNew.appendMap("mapProp", mm);
							}
						}//next iM
						mapPropsGraph = mapPropsGraphNew;
						mapArgs.setMap("mapProps", mapPropsGraph);
					}
					else if (ssP2.keywordIndex() == 2)
					{
						String sEnter = getString(TN("|Enter Start Distance|") + " " + dDistanceBottom);
						dDistanceBottom.set(sEnter.atof());
						// update map
						Map mapStartNew = mapStart;
						String _sDistanceBottomName = T("|Start \P Distance|") + "\P" + dDistanceBottom;
						mapStartNew.setString("txtProp", _sDistanceBottomName);
						Map mapPropsGraphNew;
						for (int iM = 0; iM < mapPropsGraph.length(); iM++)
						{
							if (iM == 1)
							{
								mapPropsGraphNew.appendMap("mapProp", mapStartNew);
							}
							else
							{
								Map mm = mapPropsGraph.getMap(iM);
								mapPropsGraphNew.appendMap("mapProp", mm);
							}
							
						}//next iM
						mapPropsGraph = mapPropsGraphNew;
						mapArgs.setMap("mapProps", mapPropsGraph);
					}
					else if (ssP2.keywordIndex() == 3)
					{
						String sEnter = getString(TN("|Enter End Distance|") + " " + dDistanceTop);
						dDistanceTop.set(sEnter.atof());
						// update map
						Map mapEndNew = mapEnd;
						String _sDistanceTopName = T("|End \P Distance|") + "\P" + dDistanceTop;
						mapEndNew.setString("txtProp", _sDistanceTopName);
						Map mapPropsGraphNew;
						for (int iM = 0; iM < mapPropsGraph.length(); iM++)
						{
							if (iM == 2)
							{
								mapPropsGraphNew.appendMap("mapProp", mapEndNew);
							}
							else
							{
								Map mm = mapPropsGraph.getMap(iM);
								mapPropsGraphNew.appendMap("mapProp", mm);
							}
						}//next iM
						mapPropsGraph = mapPropsGraphNew;
						mapArgs.setMap("mapProps", mapPropsGraph);
					}
					else if (ssP2.keywordIndex() == 4)
					{
						String sEnter = getString(TN("|Enter Between Distance|") + " " + dDistanceBetween);
						dDistanceBetween.set(sEnter.atof());
						// update map
						Map mapBetweenNew = mapBetween;
						String _sDistanceBetweenName = T("|Between \P Distance|") + "\P" + dDistanceBetween;
						mapBetweenNew.setString("txtProp", _sDistanceBetweenName);
						Map mapPropsGraphNew;
						for (int iM = 0; iM < mapPropsGraph.length(); iM++)
						{
							if (iM == 3)
							{
								mapPropsGraphNew.appendMap("mapProp", mapBetweenNew);
							}
							else
							{
								Map mm = mapPropsGraph.getMap(iM);
								mapPropsGraphNew.appendMap("mapProp", mm);
							}
						}//next iM
						mapPropsGraph = mapPropsGraphNew;
						mapArgs.setMap("mapProps", mapPropsGraph);
					}
				}
			}
		}
		else if (nGoJig == _kCancel)
		{
			eraseInstance(); //do not insert this instance
			return;
		}
	}
	return;
}
// end on insert	__________________//endregion

//region maps of manufacturer,family,product and properties
Map mapManufacturer;
Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
if(sManufacturer!="---")
{ 
	// get mapManufacturer
	for (int i = 0; i < mapManufacturers.length(); i++)
	{ 
		Map mapManufacturerI = mapManufacturers.getMap(i);
		if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
		{
			String _sManufacturerName = mapManufacturerI.getString("Name");
			String _sManufacturer = sManufacturer;_sManufacturer.makeUpper();
			if (_sManufacturerName.makeUpper() != _sManufacturer)
			{
				continue;
			}
		}
		else
		{ 
			// not a manufacturer map
			continue;
		}
		mapManufacturer = mapManufacturers.getMap(i);
		break;
	}
	// set family and product
//	int indexManufacturer = sManufacturers.find(sManufacturer);
	Map mapFamilys = mapManufacturer.getMap("Family[]");
	sFamilys.setLength(0);
	sFamilys.append("---");
	for (int i = 0; i < mapFamilys.length(); i++)
	{
		Map mapFamilyI = mapFamilys.getMap(i);
		if (mapFamilyI.hasString("Name") && mapFamilys.keyAt(i).makeLower() == "family")
		{
			String sName = mapFamilyI.getString("Name");
			if (sFamilys.find(sName) < 0)
			{
				// populate sFamilys with all the sFamilys of the selected manufacturer
				sFamilys.append(sName);
			}
		}
	}
	int indexFamily = sFamilys.find(sFamily);
	sFamily = PropString(1, sFamilys, sFamilyName, 1);
	if (indexFamily >- 1 )
	{
		// selected sFamily contained in sFamilys
		sFamily = PropString(1, sFamilys, sFamilyName, indexFamily);
//			sFamily.set(sFamilys[indexFamily]);
		if(sManufacturer!="---"&& indexFamily==0 && _kNameLastChangedProp==sManufacturerName)
		{
			sFamily.set(sFamilys[1]);
//					sFamily = PropString(1, sFamilys, sFamilyName, 1);
		}
	}
	else
	{
		// existing sFamily is not found, Family has been changed so set 
		// to sFamily the first Family from sFamilys
		sFamily = PropString(1, sFamilys, sFamilyName, 1);
		sFamily.set(sFamilys[1]);
	}
	if (sFamily != "---")
	{ 
		// get map of Family
		Map mapFamily;
		for (int i = 0; i < mapFamilys.length(); i++)
		{ 
			Map mapFamilyI = mapFamilys.getMap(i);
			if (mapFamilyI.hasString("Name") && mapFamilys.keyAt(i).makeLower() == "family")
			{
				String _sFamilyName = mapFamilyI.getString("Name");
				String _sFamily = sFamily;_sFamily.makeUpper();
				if (_sFamilyName.makeUpper() != _sFamily)
				{
					continue;
				}
			}
			else
			{ 
				// not a manufacturer map
				continue;
			}
			mapFamily = mapFamilys.getMap(i);
			break;
		}
// set Type
		Map mapProducts = mapFamily.getMap("Product[]");
		sProducts.setLength(0);
		for (int i = 0; i < mapProducts.length(); i++)
		{
			Map mapProductI = mapProducts.getMap(i);
			if (mapProductI.hasString("Name") && mapProducts.keyAt(i).makeLower() == "product")
			{
				String sName = mapProductI.getString("Name");
				if (sProducts.find(sName) < 0)
				{
					// populate sProducts with all the sProducts of the selected categry
					sProducts.append(sName);
				}
			}
		}
		int indexProduct = sProducts.find(sProduct);
		sProduct = PropString(2, sProducts, sProductName, 0);
		if (indexProduct >- 1)
		{
			// selected sModelis contained in sModels
			sProduct = PropString(2, sProducts, sProductName, indexProduct);
			if(sFamily!="---"&& indexProduct==0 && (_kNameLastChangedProp==sManufacturerName || _kNameLastChangedProp==sFamilyName))
			{
				sProduct.set(sProducts[0]);
//					sProduct = PropString(2, sProducts, sProductName, 1);
			}
		}
		else
		{
			// existing sModel is not found, Product has been changed so set 
			// to sModel the first Model from sModels
			sProduct = PropString(2, sProducts, sProductName, 0);
			sProduct.set(sProducts[0]);
		}
	}
	else
	{ 
		sProducts.setLength(0);
		sProducts.append("---");
		sProduct = PropString(2, sProducts, sProductName, 0);
		sProduct.set(sProducts[0]);
	}
}
else
{ 
	sFamilys.setLength(0);
	sFamilys.append("---");
	
	sFamily = PropString(1, sFamilys, sFamilyName, 0);
	sFamily.set(sFamilys[0]);
	sProducts.setLength(0);
	sProducts.append("---");
	sProduct = PropString(2, sProducts, sProductName, 0);
	sProduct.set(sProducts[0]);
}



int iModeMale = _Map.getInt("ModeMale");
assignToLayer("i");

// common calculation for both male and female
// get map of the selected product
Map mapFamily;
Map mapProduct;
int iFamilyFound = false;
int iProductFound = false;
{
	Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
	if (sManufacturer != "---")
	{
		for (int i = 0; i < mapManufacturers.length(); i++)
		{
			Map mapManufacturerI = mapManufacturers.getMap(i);
			if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
			{
				String _sManufacturerName = mapManufacturerI.getString("Name");
				String _sManufacturer = sManufacturer;_sManufacturer.makeUpper();
				if (_sManufacturerName.makeUpper() == _sManufacturer)
				{
					// this manufacturer
					Map mapManufacturer = mapManufacturerI;
					Map mapFamilys = mapManufacturer.getMap("Family[]");
					for (int ii = 0; ii < mapFamilys.length(); ii++)
					{
						Map mapFamilyI = mapFamilys.getMap(ii);
						if (mapFamilyI.hasString("Name") && mapFamilys.keyAt(ii).makeLower() == "family")
						{
							//							String sName = mapFamilyI.getString("Name");
							String _sFamilyName = mapFamilyI.getString("Name");
							String _sFamily = sFamily;_sFamily.makeUpper();
							if (_sFamilyName.makeUpper() == _sFamily)
							{
								// this family
								mapFamily = mapFamilyI;
								iFamilyFound = true;
								Map mapProducts = mapFamily.getMap("Product[]");
								for (int iii = 0; iii < mapProducts.length(); iii++)
								{
									Map mapProductI = mapProducts.getMap(iii);
									if (mapProductI.hasString("Name") && mapProducts.keyAt(iii).makeLower() == "product")
									{
										String _sProductName = mapProductI.getString("Name");
										String _sProduct = sProduct;_sProduct.makeUpper();
										if (_sProductName.makeUpper() == _sProduct)
										{
											mapProduct = mapProductI;
											iProductFound = true;
											break;
										}
									}
								}
								if (iProductFound)break;
							}
						}
					}
					if (iProductFound)break;
				}
			}
		}
	}
}
Map mapConnector;
if (mapProduct.hasMap("Connector"))
{
	mapConnector = mapProduct.getMap("Connector");
}
String sUrl;
String s;
s = "url"; if(mapProduct.hasString(s))sUrl = mapProduct.getString(s);
_ThisInst.setHyperlink(sUrl);
Map mapArticles = mapProduct.getMap("Article[]");
Map mapMillFemale;
if (mapProduct.hasMap("MillFemale"))
{
	mapMillFemale = mapProduct.getMap("MillFemale");
}
Map mapDrillFemale;
if (mapProduct.hasMap("DrillFemale"))
{
	mapDrillFemale = mapProduct.getMap("DrillFemale");
}
Map mapMillMale;
if (mapProduct.hasMap("MillMale"))
{
	mapMillMale = mapProduct.getMap("MillMale");
}
Map mapDrillMale;
if (mapProduct.hasMap("DrillMale"))
{
	mapDrillMale = mapProduct.getMap("DrillMale");
}
Map mapDrillMale2;
if (mapProduct.hasMap("DrillMale2"))
{
	mapDrillMale2 = mapProduct.getMap("DrillMale2");
}
Map mapDrillMaleSinkHole;
if (mapProduct.hasMap("DrillMaleSinkHole"))
{
	mapDrillMaleSinkHole = mapProduct.getMap("DrillMaleSinkHole");
}
//End maps of manufacturer,family,product and properties//endregion
setOPMKey(sManufacturer);
//region body of part
bdPart = Body();

if(!iModeMale)
{ 
	// female mode
	double dLengthPart, dWidthPart, dThicknessPart;
	String s;
	s = "Length"; if(mapConnector.hasDouble(s))dLengthPart = mapConnector.getDouble(s);
	s = "Width"; if(mapConnector.hasDouble(s))dWidthPart = mapConnector.getDouble(s);
	s = "Thickness"; if(mapConnector.hasDouble(s))dThicknessPart = mapConnector.getDouble(s);
	Point3d ptScrew = Point3d(0,0,0);
	Body bd(ptScrew, _XW, _ZW, -_YW, 
		dLengthPart, dWidthPart, dThicknessPart, 
		0, 0, 1);
	bdPart = bd;
}
else if(iModeMale)
{ 
	// male part
	double dLengthPart, dDiameterPart;
	String s;
	s = "Depth"; if(mapDrillMale.hasDouble(s))dLengthPart = mapDrillMale.getDouble(s);
	s = "Diameter"; if(mapDrillMale.hasDouble(s))dDiameterPart = mapDrillMale.getDouble(s);
	Point3d ptScrew = Point3d(0,0,0);
	Body bd(ptScrew, ptScrew + dLengthPart * _YW, .5 * dDiameterPart);
	Body _bd(ptScrew, ptScrew - (U(5)) * _YW,  dDiameterPart);
	
	bdPart = bd;
	bdPart.addPart(_bd);
}
bdPart.vis(5);
//End body of part//endregion 

//region general calculation
if(_Beam.length()!=2)
{ 
	reportMessage("\n"+scriptName()+" "+T("|2 beams needed|"));
	eraseInstance();
	return;
}
Beam bm0 = _Beam[0];
// basic information
Point3d ptCen0 = bm0.ptCen();
Vector3d vecX0 = bm0.vecX();
Vector3d vecY0 = bm0.vecY();
Vector3d vecZ0 = bm0.vecZ();

double dLength0 = bm0.solidLength();
double dWidth0 = bm0.solidWidth();
double dHeight0 = bm0.solidHeight();

Beam bm = _Beam[1];
// basic information
Point3d ptCen = bm.ptCen();
Vector3d vecX = bm.vecX();
Vector3d vecY = bm.vecY();
Vector3d vecZ = bm.vecZ();

double dLength = bm.solidLength();
double dWidth = bm.solidWidth();
double dHeight = bm.solidHeight();

if(!iModeMale)
	assignToGroups(Entity(bm));
else if(iModeMale)
	assignToGroups(Entity(bm0));
//	bm.envelopeBody().vis(3);
//if(!vecX0.isParallelTo(vecX))
//{ 
//	reportMessage("\n"+scriptName()+" "+T("|beams must be parallel|"));
//	eraseInstance();
//	return;
//}
Quader qd0(ptCen0, vecX0, vecY0, vecZ0, dLength0, dWidth0, dHeight0);
Quader qd(ptCen, vecX, vecY, vecZ, dLength, dWidth, dHeight);

//Group grps[] = bm.groups();
//for (int iG=0;iG<grps.length();iG++) 
//{ 
//	grps[iG].addEntity(_ThisInst, false); 
//	 
//}//next iG
//Group grps0[] = bm0.groups();
//for (int iG=0;iG<grps0.length();iG++) 
//{ 
//	grps0[iG].addEntity(_ThisInst, false); 
//	 
//}//next iG

//grp.addEntity(_ThisInst);
//assignToGroups(bm0);
//assignToGroups(bm);
//_ThisInst.assignToGroups(bm0);
//_ThisInst.assignToGroups(bm);
//setKeepReferenceToGenBeamDuringCopy(_kBeam01);
setKeepReferenceToGenBeamDuringCopy(_kAllBeams);
setEraseAndCopyWithBeams(_kBeam01);

int iSingle =0;

if (_PtG.length() == 0 && dDistanceBetween == -1)iSingle = true;

Vector3d vecs[] ={vecX,-vecX, vecY ,- vecY, vecZ ,- vecZ};
int iAlignment = sAlignments.find(sAlignment);
Vector3d vecPlane = vecs[iAlignment];
Vector3d vecAlignment;
if(_Map.hasVector3d("vecAlignment"))
{
	vecAlignment= _Map.getVector3d("vecAlignment");
	vecPlane=qd.vecD(vecAlignment);
}
else
{ 
	 _Map.setVector3d("vecAlignment", vecPlane);
}



Vector3d vecXplane, vecYplane;
vecXplane = vecX;
if(!vecPlane.isParallelTo(vecX))
	vecXplane = vecX;
else if(!vecPlane.isParallelTo(vecY))
	vecXplane = vecY;
else if(!vecPlane.isParallelTo(vecZ))
	vecXplane = vecZ;
vecYplane = vecPlane.crossProduct(vecXplane);
Plane pn(ptCen + vecPlane * (.5 * qd.dD(vecPlane)+dOffset), vecPlane);
_Pt0 = pn.closestPointTo(_Pt0);

PlaneProfile pp0(pn), pp1(pn);
PLine _pl;
_pl.createRectangle(LineSeg(ptCen0-vecXplane*.5*qd0.dD(vecXplane)-vecYplane*.5*qd0.dD(vecYplane),
			ptCen0 + vecXplane * .5 * qd0.dD(vecXplane) + vecYplane * .5 * qd0.dD(vecYplane)), vecXplane, vecYplane);
pp0.joinRing(_pl,_kAdd);
_pl = PLine();
_pl.createRectangle(LineSeg(ptCen-vecXplane*.5*qd.dD(vecXplane)-vecYplane*.5*qd.dD(vecYplane),
			ptCen + vecXplane * .5 * qd.dD(vecXplane) + vecYplane * .5 * qd.dD(vecYplane)), vecXplane, vecYplane);
pp1.joinRing(_pl,_kAdd);
pp0.vis(3);
pp1.vis(2);
addRecalcTrigger(_kGripPointDrag, "_Pt0");
//End general calculation//endregion 
// clip lock yes or no
	int iClipLock = sNoYes.find(sClipLock);
	int iOrientationDrill = sNoYes.find(sOrientationDrill);
if(iSingle)
{ 
	// single instance
	sModeDistribution.setReadOnly(_kHidden);
	dDistanceTop.setReadOnly(_kHidden);
	dDistanceBottom.setReadOnly(_kHidden);
	dDistanceBetween.setReadOnly(_kHidden);
	dDistanceBetweenResult.setReadOnly(_kHidden);
	nNrResult.setReadOnly(_kHidden);
	double dDiameterThread = U(10);
	if (_bOnGripPointDrag && (_kExecuteKey == "_Pt0"))
	{ 
		Display dp(3);
		Point3d ptText = _Pt0;
		dp.color(1);
		PLine pl;
		pl = PLine();
		pl.createCircle(_Pt0, vecPlane, dDiameterThread * .5);
		
		PlaneProfile ppDrill(pn);
		ppDrill.joinRing(pl, _kAdd);
		dp.color(1);
		dp.draw(ppDrill, _kDrawFilled, 30);
		return
	}
	int iSwapDirection= _Map.getInt("iSwapDirection");
	Body bdReal = bm.envelopeBody(true,true);
	Display dp(1);
	Vector3d vecYpart = vecPlane;
//	Vector3d vecDir = iSwapDirection==0?vecX:-vecX;
	Vector3d vecDir = vecX;
	if(!vecPlane.isParallelTo(vecX))
		vecDir = vecX;
	else if(!vecPlane.isParallelTo(vecY))
		vecDir = vecY;
	else if(!vecPlane.isParallelTo(vecZ))
		vecDir = vecZ;
	//	Vector3d vecZpart = vecDir;
	Vector3d vecZpart = qd.vecD(_ZW);
	if (vecZpart.isParallelTo(vecYpart))vecZpart = vecDir;
	if (iSwapDirection)vecZpart *= -1;
	
	Point3d pt0PartStart = _Pt0;
	Display dpPart(252);
	Vector3d vecXpart = vecYpart.crossProduct(vecZpart);
	vecXpart.normalize();
	CoordSys csPartTransform;
	double dLengthDrillReal=U(70);
//vecDir.vis(_Pt0);
//vecPlane.vis(_Pt0);
//return
	Point3d pt = _Pt0;
//	Point3d ptGap = pnNailStart.closestPointTo(pt);
//	csPartTransform.setToAlignCoordSys(ptRefConnector, _XW, _YW, _ZW, pt, vecXpart, vecYpart, vecZpart);
	csPartTransform.setToAlignCoordSys(Point3d(0,0,0), _XW, _YW, _ZW, pt, vecXpart, vecYpart, vecZpart);
	// drill start and end wrt realbody when it goes throug it
	Point3d ptStart, ptEnd;
	{
//			PlaneProfile ppSlice = bdReal.getSlice(Plane(pt, vecXplane));
		PlaneProfile ppSlice = bdReal.getSlice(Plane(pt, vecDir));
		ppSlice.vis(9);
		PLine plSlices[] = ppSlice.allRings();
//			if (plSlices.length() == 0)continue;
//			Line lnDrill(pt, vecPlane);
		Line lnDrill(pt, vecYpart);
		Point3d ptsIntersect[0];
		for (int i=0;i<plSlices.length();i++) 
		{ 
			Point3d ptsI[] = plSlices[i].intersectPoints(lnDrill);
			ptsIntersect.append(ptsI);
		}//next i
		if (ptsIntersect.length() == 0)
		{
			reportMessage("\n"+scriptName()+" "+T("|part can not be placed|"));
			Display dpErr(1);
			dpErr.draw("error", _Pt0, _XW, _YW, 0, 0, _kDeviceX);
//			eraseInstance();
			return;
		}
		ptStart = ptsIntersect[0];
		ptEnd = ptsIntersect[0];
		for (int i=0;i<ptsIntersect.length();i++) 
		{ 
			if(vecPlane.dotProduct(ptsIntersect[i]-ptStart)>0)
			{ 
				ptStart = ptsIntersect[i];
			} 
			if(vecPlane.dotProduct(ptsIntersect[i]-ptStart)<0)
			{ 
				ptEnd = ptsIntersect[i];
			} 
		}//next i
	}

	PLine pl;
	pl.createCircle(pt, vecYpart, U(.5));
	pl.projectPointsToPlane(pn, vecYpart);
	
	PlaneProfile pp(Plane(ptStart, vecPlane));
	pp.joinRing(pl, _kAdd);
	dp.draw(pp, _kDrawFilled);
	ptStart.vis(3);
	ptEnd.vis(3);
	
	LineSeg lSeg (pt, pt+ vecYpart * dLengthDrillReal);
	dp.color(252);
//	dp.draw(lSeg);
	
	pl = PLine();
	pl.createCircle(pt+vecYpart * dLengthDrillReal, vecYpart, U(.5));
	pp = PlaneProfile (Plane(pt + vecYpart * dLengthDrillReal, vecYpart));
	pp.joinRing(pl, _kAdd);
	dp.color(1);
//	dp.draw(pp, _kDrawFilled);
	
	Body bdI = bdPart;
	bdI.transformBy(csPartTransform);
//	bdI.vis(1);
	dpPart.draw(bdI);
	
	String sDefaultValue=" "+T("|Default value =|")+" ";
	String _sDefaultValue;
	// milling female
	if(!iModeMale)
	{ 
		
		double dLengthMillFemale, dWidthMillFemale, dDepthMillFemale;
		String s;
		s = "Width"; if(mapMillFemale.hasDouble(s))dWidthMillFemale = mapMillFemale.getDouble(s);
		_sDefaultValue = sDefaultValue + dWidthMillFemale;
		dMillFemaleWidth.setDescription(sMillFemaleWidthDescription + _sDefaultValue);
		if (dMillFemaleWidth != 0)dWidthMillFemale = dMillFemaleWidth;
		
		s = "Length"; if(mapMillFemale.hasDouble(s))dLengthMillFemale = mapMillFemale.getDouble(s);
		_sDefaultValue = sDefaultValue + dLengthMillFemale;
		dMillFemaleLength.setDescription(sMillFemaleLengthDescription + _sDefaultValue);
		if (dMillFemaleLength != 0)dLengthMillFemale = dMillFemaleLength;
		
		s = "Depth"; if(mapMillFemale.hasDouble(s))dDepthMillFemale = mapMillFemale.getDouble(s);
		_sDefaultValue = sDefaultValue + dDepthMillFemale;
		dMillFemaleDepth.setDescription(sMillFemaleDepthDescription + _sDefaultValue);
		if (dMillFemaleDepth != 0)dDepthMillFemale = dMillFemaleDepth;
		// add 3mm from clip lock
		if (dMillFemaleDepth == 0 && iClipLock)dDepthMillFemale += U(3);
		double dLengthPart;
		s = "Length"; if(mapConnector.hasDouble(s))dLengthPart = mapConnector.getDouble(s);
		Point3d ptMs = ptStart - vecZpart * .5 * dLengthPart+vecPlane*dOffset;
		if(dLengthMillFemale>0 && dWidthMillFemale>0 && dDepthMillFemale)
		{ 
			Mortise ms(ptMs,   vecZpart, vecXpart,-vecYpart,
				dLengthMillFemale, dWidthMillFemale,dDepthMillFemale,1,0,1);
//			ms.setRoundType(_kExplicitRadius);
			ms.setRoundType(_kNotRound);
//			ms.setExplicitRadius(U(7));
			bm.addTool(ms);
		}
	}
	// Drill Female
	if ( ! iModeMale);
	{ 
		double dDepthDrillFemale, dDiameterDrillFemale;
		int iQuantity;
		String s;
		s = "Diameter"; if(mapDrillFemale.hasDouble(s))dDiameterDrillFemale = mapDrillFemale.getDouble(s);
		_sDefaultValue = sDefaultValue + dDiameterDrillFemale;
		dDrillFemaleDiameter.setDescription(sDrillFemaleDiameterDescription+ _sDefaultValue);
		if (dDrillFemaleDiameter != 0)dDiameterDrillFemale = dDrillFemaleDiameter;
		
		s = "Depth"; if(mapDrillFemale.hasDouble(s))dDepthDrillFemale = mapDrillFemale.getDouble(s);
		_sDefaultValue = sDefaultValue + dDepthDrillFemale;
		dDrillFemaleLength.setDescription(sDrillFemaleLengthDescription+ _sDefaultValue);
		if (dDrillFemaleLength != 0)dDepthDrillFemale = dDrillFemaleLength;
		
		s = "Quantity"; if(mapDrillFemale.hasInt(s))iQuantity = mapDrillFemale.getInt(s);
		for (int iDr=0;iDr<iQuantity;iDr++) 
		{ 
			int ii = iDr + 1;
			String sx = "x" + ii;
			String sy = "y" + ii;
			double dX = mapDrillFemale.getDouble(sx);
			double dY = mapDrillFemale.getDouble(sy);
			Point3d ptDr = ptStart + dX * vecXpart + dY * vecZpart+vecPlane*dOffset;
			if(dDepthDrillFemale>0 && dDiameterDrillFemale>0)
			{ 
				Drill dr(ptDr, ptDr -vecYpart * dDepthDrillFemale, .5 * dDiameterDrillFemale);
				bm.addTool(dr);
			}
		}//next iDr
	}
	// milling male
	if(mapProduct.hasMap("MillMale") && !iModeMale)
	{ 
		double dLengthMillMale, dWidthMillMale, dDepthMillMale;
		String s;
		s = "Width"; if(mapMillMale.hasDouble(s))dWidthMillMale = mapMillMale.getDouble(s);
		_sDefaultValue = sDefaultValue + dWidthMillMale;
		dMillMaleWidth.setDescription(sMillMaleWidthDescription + _sDefaultValue);
		if (dMillMaleWidth != 0)dWidthMillMale = dMillMaleWidth;
		
		
		s = "Length"; if(mapMillMale.hasDouble(s))dLengthMillMale = mapMillMale.getDouble(s);
		_sDefaultValue = sDefaultValue + dLengthMillMale;
		dMillMaleLength.setDescription(sMillMaleLengthDescription + _sDefaultValue);
		if (dMillMaleLength != 0)dLengthMillMale = dMillMaleLength;
		
		s = "Depth"; if(mapMillMale.hasDouble(s))dDepthMillMale = mapMillMale.getDouble(s);
		_sDefaultValue = sDefaultValue + dDepthMillMale;
		dMillMaleDepth.setDescription(sMillMaleDepthDescription + _sDefaultValue);
		if (dMillMaleDepth != 0)dDepthMillMale = dMillMaleDepth;

		double dLengthPart;
		s = "Length"; if(mapConnector.hasDouble(s))dLengthPart = mapConnector.getDouble(s);
		Point3d ptMs = ptStart - vecZpart * .5 * dLengthPart+vecPlane*dOffset;
		if(dLengthMillMale>0 && dWidthMillMale>0 && dDepthMillMale)
		{ 
			Mortise ms(ptMs,   vecZpart, vecXpart,vecYpart,
				dLengthMillMale, dWidthMillMale,dDepthMillMale,1,0,1);
			ms.setRoundType(_kNotRound);
//			ms.setExplicitRadius(U(7));
			ms.cuttingBody().vis(2);
			bm0.addTool(ms);
		}
	}
	// Drill male
	if(!iModeMale)
	{ 
		double dDepthDrillMale, dDiameterDrillMale;
		int iQuantity;
		String s;
		s = "Diameter"; if(mapDrillMale.hasDouble(s))dDiameterDrillMale = mapDrillMale.getDouble(s);
		_sDefaultValue = sDefaultValue + dDiameterDrillMale;
		dDrillMaleDiameter.setDescription(sDrillMaleDiameterDescription+ _sDefaultValue);
		if (dDrillMaleDiameter != 0)dDiameterDrillMale = dDrillMaleDiameter;
		s = "Depth"; if(mapDrillMale.hasDouble(s))dDepthDrillMale = mapDrillMale.getDouble(s);
		_sDefaultValue = sDefaultValue + dDepthDrillMale;
		dDrillMaleLength.setDescription(sDrillMaleLengthDescription+ _sDefaultValue);
		if (dDrillMaleLength != 0)dDepthDrillMale = dDrillMaleLength;
		
		s = "Quantity"; if(mapDrillMale.hasInt(s))iQuantity = mapDrillMale.getInt(s);
		for (int iDr=0;iDr<iQuantity;iDr++) 
		{ 
			int ii = iDr + 1;
			String sx = "x" + ii;
			String sy = "y" + ii;
			double dX = mapDrillMale.getDouble(sx);
			double dY = mapDrillMale.getDouble(sy);
			Point3d ptDr = ptStart + dX * vecXpart + dY * vecZpart+vecPlane*dOffset;
			if(dDepthDrillMale>0 && dDiameterDrillMale>0)
			{ 
				Drill dr(ptDr, ptDr +vecYpart * dDepthDrillMale, .5 * dDiameterDrillMale);
				bm0.addTool(dr);
			}
		}//next iDr
		if(iQuantity<=1)
		{ 
			if(dDepthDrillMale>0 && dDiameterDrillMale>0)
			{ 
				Point3d ptDr = ptStart + vecPlane*dOffset;
				Drill dr(ptDr, ptDr +vecYpart * dDepthDrillMale, .5 * dDiameterDrillMale);
				bm0.addTool(dr);
			}
		}
		
		//
		if(mapProduct.hasMap("DrillMaleSinkHole"))
		{ 
			double dDepthDrillMale, dDiameterDrillMale;
			String s;
			s = "Diameter"; if(mapDrillMaleSinkHole.hasDouble(s))dDiameterDrillMale = mapDrillMaleSinkHole.getDouble(s);
//			if (dDrillMaleDiameter >= 0)dDiameterDrillMale = dDrillMaleDiameter;
			s = "Depth"; if(mapDrillMaleSinkHole.hasDouble(s))dDepthDrillMale = mapDrillMaleSinkHole.getDouble(s);
//			if (dDrillMaleLength >= 0)dDepthDrillMale = dDrillMaleLength;
			if(dDepthDrillMale>0 && dDiameterDrillMale>0)
			{ 
				Point3d ptDr = ptStart + vecPlane*dOffset;
				Drill dr(ptDr, ptDr +vecYpart * dDepthDrillMale, .5 * dDiameterDrillMale);
//				Point3d ptDrill2 = ptDr + vecYpart * dDepthDrillMale;
				bm0.addTool(dr);
			}
		}
	}
	if(mapProduct.hasMap("DrillMale2") && !iModeMale)
	{ 
		double dDepthDrillMale, dDiameterDrillMale;
		int iQuantity;
		String s;
		s = "Diameter"; if(mapDrillMale2.hasDouble(s))dDiameterDrillMale = mapDrillMale2.getDouble(s);
//		if (dDrillMaleDiameter >= 0)dDiameterDrillMale = dDrillMaleDiameter;
		s = "Depth"; if(mapDrillMale2.hasDouble(s))dDepthDrillMale = mapDrillMale2.getDouble(s);
//		if (dDrillMaleLength >= 0)dDepthDrillMale = dDrillMaleLength;
		
		s = "Quantity"; if(mapDrillMale2.hasInt(s))iQuantity = mapDrillMale2.getInt(s);
		for (int iDr=0;iDr<iQuantity;iDr++) 
		{ 
			int ii = iDr + 1;
			String sx = "x" + ii;
			String sy = "y" + ii;
			double dX = mapDrillMale2.getDouble(sx);
			double dY = mapDrillMale2.getDouble(sy);
			Point3d ptDr = ptStart + dX * vecXpart + dY * vecZpart+vecPlane*dOffset;
			if(dDepthDrillMale>0 && dDiameterDrillMale>0)
			{ 
				Drill dr(ptDr, ptDr +vecYpart * dDepthDrillMale, .5 * dDiameterDrillMale);
				bm0.addTool(dr);
			}
		}//next iDr
		if(iQuantity<=1)
		{ 
			if(dDepthDrillMale>0 && dDiameterDrillMale>0)
			{ 
				Point3d ptDr = ptStart + vecPlane*dOffset;
				Drill dr(ptDr, ptDr +vecYpart * dDepthDrillMale, .5 * dDiameterDrillMale);
				bm0.addTool(dr);
			}
		}
	}
	//region add drill to indicate upward orientation of the part
	
	if(!iModeMale && iOrientationDrill)
	{ 
		Point3d ptDrill = ptCen + .5 * qd.dD(vecPlane) * qd.vecD(vecPlane) + (.5 * qd.dD(vecZpart) - U(30)) * qd.vecD(vecZpart);
		Drill drSide(ptDrill, ptDrill -vecYpart * U(10), U(10));
	//		drSide.cuttingBody().vis(1);
		bm.addTool(drSide);
		ptDrill = ptCen0 + .5 * qd0.dD(-vecPlane) * qd0.vecD(-vecPlane) + (.5 * qd0.dD(vecZpart) - U(30)) * qd0.vecD(vecZpart);
		Drill drSide0(ptDrill, ptDrill +vecYpart * U(10), U(10));
		bm0.addTool(drSide0);
	}
//End add drill to indicate upward orientation of the part//endregion 
	
//region Trigger swapBeams
	String sTriggerswapBeams = T("|swap Beams|");
	addRecalcTrigger(_kContextRoot, sTriggerswapBeams );
	if (_bOnRecalc && _kExecuteKey==sTriggerswapBeams)
	{
		Vector3d vecSnew[] ={ vecX0, -vecX0, vecY0, - vecY0, vecZ0 ,- vecZ0};
		Vector3d vecAlignmentNew = qd0.vecD(-vecAlignment);
//		int iAlignmentNew = -1;
//		for (int iV=0;iV<vecSnew.length();iV++) 
//		{ 
//			if( vecSnew[iV].isCodirectionalTo(-vecs[iAlignment]))
//			{ 
//				iAlignmentNew = iV;
//				break;
//			}
//		}//next iV
//		if(iAlignmentNew>-1)
//		{
//			sAlignment.set(sAlignments[iAlignmentNew]);
//			_Beam.swap(0, 1);
//		}
//		else
//		{ 
//			reportMessage("\n"+scriptName()+" "+T("|not possible|"));
//		}

		_Map.setVector3d("vecAlignment", vecAlignmentNew);
		_Beam.swap(0, 1);
		setExecutionLoops(2);
		return;
	}//endregion
	
//region Trigger swapDirection
	String sTriggerswapDirection = T("|swap Direction|");
	addRecalcTrigger(_kContextRoot, sTriggerswapDirection );
	if (_bOnRecalc && _kExecuteKey==sTriggerswapDirection)
	{
		int iSwapDirectionNew =! iSwapDirection;
		_Map.setInt("iSwapDirection", iSwapDirectionNew);
		setExecutionLoops(2);
		return;
	}//endregion
	
//region create male tsl
	if ( ! iModeMale)
	{
		TslInst tslMale;
		if ( ! _Map.hasEntity("maleTsl"))
		{
			TslInst tslNew; Vector3d vecXTsl = _XW; Vector3d vecYTsl = _YW;
			GenBeam gbsTsl[] = { bm0, bm}; Entity entsTsl[] = { }; Point3d ptsTsl[] = { _Pt0};
			int nProps[] ={ nNrResult};
			double dProps[] ={ dDistanceBottom, dDistanceTop, dDistanceBetween, dDistanceBetweenResult,dOffset,
				dMillFemaleWidth, dMillFemaleLength, dMillFemaleDepth, dDrillFemaleDiameter, dDrillFemaleLength,
			dMillMaleWidth, dMillMaleLength, dMillMaleDepth, dDrillMaleDiameter, dDrillMaleLength};
			String sProps[] ={ sManufacturer, sFamily, sProduct, sModeDistribution,
			sClipLock, sAlignment, sOrientationDrill};
			Map mapTsl;
			mapTsl.setInt("iSwapDirection", iSwapDirection);
			mapTsl.setInt("ModeMale", true);
			mapTsl.setVector3d("vecAlignment", vecAlignment);
			mapTsl.setEntity("femaleTsl", _ThisInst);
			tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl,
			ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			tslNew.recalc();
			tslMale = tslNew;
		}
		else
		{
			Entity tslEnt = _Map.getEntity("maleTsl");
			TslInst tslMaleThis = (TslInst)tslEnt;
			if ( ! tslMaleThis.bIsValid())
			{
				TslInst tslNew; Vector3d vecXTsl = _XW; Vector3d vecYTsl = _YW;
				GenBeam gbsTsl[] = { bm0, bm}; Entity entsTsl[] = { }; Point3d ptsTsl[] = { _Pt0};
				int nProps[] ={ nNrResult};
				double dProps[] ={ dDistanceBottom, dDistanceTop, dDistanceBetween, dDistanceBetweenResult,dOffset,
					dMillFemaleWidth, dMillFemaleLength, dMillFemaleDepth, dDrillFemaleDiameter, dDrillFemaleLength,
				dMillMaleWidth, dMillMaleLength, dMillMaleDepth, dDrillMaleDiameter, dDrillMaleLength};
				String sProps[] ={ sManufacturer, sFamily, sProduct, sModeDistribution,
				sClipLock, sAlignment, sOrientationDrill};
				Map mapTsl;
				mapTsl.setInt("iSwapDirection", iSwapDirection);
				mapTsl.setInt("ModeMale", true);
				mapTsl.setVector3d("vecAlignment", vecAlignment);
				mapTsl.setEntity("femaleTsl", _ThisInst);
				tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl,
				ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
				tslNew.recalc();
				tslMale = tslNew;
			}
			else
			{
				tslMale = tslMaleThis;
			}
		}
		Map mapMale = tslMale.map();
		mapMale.setEntity("femaleTsl", _ThisInst);
		tslMale.setMap(mapMale);
//		if(tslMale.bIsValid())
			_Map.setEntity("maleTsl", tslMale);
		if (_Entity.find(tslMale) < 0)
			_Entity.append(tslMale);
		setDependencyOnEntity(tslMale);
		
//		// properties
//		if(_kNameLastChangedProp==sNrResultName)
//		{
//			if(tslMale.propInt(sNrResultName)!=nNrResult)
			if(tslMale.propInt(0)!=nNrResult)
				tslMale.setPropInt(0, nNrResult);
//		}
////		//double
//		if(_kNameLastChangedProp==sDistanceBottomName)
//		{
			if(tslMale.propDouble(0)!=dDistanceBottom)
				tslMale.setPropDouble(0, dDistanceBottom);
//		}
//		if(_kNameLastChangedProp==sDistanceTopName)
//		{
			if(tslMale.propDouble(1)!=dDistanceTop)
				tslMale.setPropDouble(1, dDistanceTop);
//		}
//		if(_kNameLastChangedProp==sDistanceBetweenName)
//		{
			if(tslMale.propDouble(2)!=dDistanceBetween)
				tslMale.setPropDouble(2, dDistanceBetween);
//		}
//		if(_kNameLastChangedProp==sDistanceBetweenResultName)
//		{
			if(tslMale.propDouble(3)!=dDistanceBetweenResult)
				tslMale.setPropDouble(3, dDistanceBetweenResult);
//		}
			if(tslMale.propDouble(4)!=dOffset)
				tslMale.setPropDouble(4, dOffset);
//		if(_kNameLastChangedProp==sMillFemaleWidthName)
//		{
			if(tslMale.propDouble(5)!=dMillFemaleWidth)
				tslMale.setPropDouble(5,dMillFemaleWidth);
//		}
//		if(_kNameLastChangedProp==sMillFemaleLengthName)
//		{
			if(tslMale.propDouble(6)!=dMillFemaleLength)
				tslMale.setPropDouble(6,dMillFemaleLength);
//		}
//		if(_kNameLastChangedProp==sMillFemaleDepthName)
//		{
			if(tslMale.propDouble(7)!=dMillFemaleDepth)
				tslMale.setPropDouble(7,dMillFemaleDepth);
//		}
//		if(_kNameLastChangedProp==sDrillFemaleDiameterName)
//		{
			if(tslMale.propDouble(8)!=dDrillFemaleDiameter)
				tslMale.setPropDouble(8,dDrillFemaleDiameter);
//		}
//		if(_kNameLastChangedProp==sDrillFemaleLengthName)
//		{
			if(tslMale.propDouble(9)!=dDrillFemaleLength)
				tslMale.setPropDouble(9,dDrillFemaleLength);
//		}
//		if(_kNameLastChangedProp==sMillMaleWidthName)
//		{
	
//			double ddd = tslMale.propDouble(sMillMaleWidthName);
			if(tslMale.propDouble(10)!=dMillMaleWidth)
				tslMale.setPropDouble(10,dMillMaleWidth);
//		}
//		if(_kNameLastChangedProp==sMillMaleLengthName)
//		{
			if(tslMale.propDouble(11)!=dMillMaleLength)
				tslMale.setPropDouble(11,dMillMaleLength);
//		}
//		if(_kNameLastChangedProp==sMillMaleDepthName)
//		{
			if(tslMale.propDouble(12)!=dMillMaleDepth)
				tslMale.setPropDouble(12,dMillMaleDepth);
//		}
//		if(_kNameLastChangedProp==sDrillMaleDiameterName)
//		{
			if(tslMale.propDouble(13)!=dDrillMaleDiameter)
				tslMale.setPropDouble(13,dDrillMaleDiameter);
//		}
//		if(_kNameLastChangedProp==sDrillMaleLengthName)
//		{
			if(tslMale.propDouble(14)!=dDrillMaleLength)
				tslMale.setPropDouble(14,dDrillMaleLength);
//		}
//		if(_kNameLastChangedProp==sDrillMaleLengthName)
//		{
			if(tslMale.propDouble(15)!=dDrillMaleLength)
				tslMale.setPropDouble(15,dDrillMaleLength);
//		}
////		// string
//		if(_kNameLastChangedProp==sManufacturerName)
//		{
			if(tslMale.propString(0)!=sManufacturer)
				tslMale.setPropString(0,sManufacturer);
//		}
//		if(_kNameLastChangedProp==sFamilyName)
//		{
			if(tslMale.propString(1)!=sFamily)
				tslMale.setPropString(1,sFamily);
//		}
//		if(_kNameLastChangedProp==sProductName)
//		{
			if(tslMale.propString(2)!=sProduct)
				tslMale.setPropString(2,sProduct);
//		}
//		if(_kNameLastChangedProp==sModeDistributionName)
//		{
			if(tslMale.propString(3)!=sModeDistribution)
				tslMale.setPropString(3,sModeDistribution);
//		}
//		if(_kNameLastChangedProp==sClipLockName)
//		{
			if(tslMale.propString(4)!=sClipLock)
				tslMale.setPropString(4,sClipLock);
//		}
//		if(_kNameLastChangedProp==sAlignmentName)
//		{
			if(tslMale.propString(5)!=sAlignment)
				tslMale.setPropString(5,sAlignment);
//		}
			if(tslMale.propString(6)!=sOrientationDrill)
				tslMale.setPropString(6, sOrientationDrill);
//		// _Pt0
//		if(_kNameLastChangedProp=="_Pt0")
//		{
			if((tslMale.ptOrg()-_Pt0).length()>dEps)
				tslMale.setPtOrg(_Pt0);
//		}
		//
		_Map.setEntity("maleTsl", tslMale);
		if (_Entity.find(tslMale) < 0)
			_Entity.append(tslMale);
		setDependencyOnEntity(tslMale);
	}
//End create male tsl//endregion 
	if(iModeMale)
	{ 
		sManufacturer.setReadOnly(_kReadOnly);
		sFamily.setReadOnly(_kReadOnly);
		sProduct.setReadOnly(_kReadOnly);
//		sModeDistribution.setReadOnly(_kReadOnly);
		sClipLock.setReadOnly(_kReadOnly);
		sOrientationDrill.setReadOnly(_kReadOnly);
//		nNrResult.setReadOnly(_kReadOnly);
		dOffset.setReadOnly(_kReadOnly);
		//
		dMillFemaleWidth.setReadOnly(_kReadOnly);
		dMillFemaleLength.setReadOnly(_kReadOnly);
		dMillFemaleDepth.setReadOnly(_kReadOnly);
		
//		dDistanceBottom.setReadOnly(_kReadOnly);
//		dDistanceTop.setReadOnly(_kReadOnly);
//		dDistanceBetween.setReadOnly(_kReadOnly);
//		dDistanceBetweenResult.setReadOnly(_kReadOnly);
		
		dDrillFemaleDiameter.setReadOnly(_kReadOnly);
		dDrillFemaleLength.setReadOnly(_kReadOnly);
		dMillMaleWidth.setReadOnly(_kReadOnly);
		dMillMaleLength.setReadOnly(_kReadOnly);
		dMillMaleDepth.setReadOnly(_kReadOnly);
		dDrillMaleDiameter.setReadOnly(_kReadOnly);
		dDrillMaleLength.setReadOnly(_kReadOnly);
		dDrillMaleLength.setReadOnly(_kReadOnly);
		//
		
//		sAlignment.setReadOnly(_kReadOnly);
		
		//
		Entity tslEnt = _Map.getEntity("femaleTsl");
		TslInst tslFemale = (TslInst)tslEnt;
		if(!tslFemale.bIsValid())
		{ 
			eraseInstance();
			return;
		}
		if(_Entity.find(tslFemale)<0)
			_Entity.append(tslFemale);
		setDependencyOnEntity(tslFemale);
		// properties
//		if(_kNameLastChangedProp==sNrResultName)
//		{
//			if(tslFemale.propInt(sNrResultName)!=nNrResult)
//				tslFemale.setPropInt(sNrResultName, nNrResult);
//		}
////		//double
//		if(_kNameLastChangedProp==sDistanceBottomName)
//		{
//			if(tslFemale.propDouble(sDistanceBottomName)!=dDistanceBottom)
//				tslFemale.setPropDouble(sDistanceBottomName, dDistanceBottom);
//		}
//		if(_kNameLastChangedProp==sDistanceTopName)
//		{
//			if(tslFemale.propDouble(sDistanceTopName)!=dDistanceTop)
//				tslFemale.setPropDouble(sDistanceTopName, dDistanceTop);
//		}
//		if(_kNameLastChangedProp==sDistanceBetweenName)
//		{
//			if(tslFemale.propDouble(sDistanceBetweenName)!=dDistanceBetween)
//				tslFemale.setPropDouble(sDistanceBetweenName, dDistanceBetween);
//		}
//		if(_kNameLastChangedProp==sDistanceBetweenResultName)
//		{
//			if(tslFemale.propDouble(sDistanceBetweenResultName)!=dDistanceBetweenResult)
//				tslFemale.setPropDouble(sDistanceBetweenResultName, dDistanceBetweenResult);
//		}
//		if(_kNameLastChangedProp==sMillFemaleWidthName)
//		{
//			if(tslFemale.propDouble(sMillFemaleWidthName)!=dMillFemaleWidth)
//				tslFemale.setPropDouble(sMillFemaleWidthName,dMillFemaleWidth);
//		}
//		if(_kNameLastChangedProp==sMillFemaleLengthName)
//		{
//			if(tslFemale.propDouble(sMillFemaleLengthName)!=dMillFemaleLength)
//				tslFemale.setPropDouble(sMillFemaleLengthName,dMillFemaleLength);
//		}
//		if(_kNameLastChangedProp==sMillFemaleDepthName)
//		{
//			if(tslFemale.propDouble(sMillFemaleDepthName)!=dMillFemaleDepth)
//				tslFemale.setPropDouble(sMillFemaleDepthName,dMillFemaleDepth);
//		}
//		if(_kNameLastChangedProp==sDrillFemaleDiameterName)
//		{
//			if(tslFemale.propDouble(sDrillFemaleDiameterName)!=dDrillFemaleDiameter)
//				tslFemale.setPropDouble(sDrillFemaleDiameterName,dDrillFemaleDiameter);
//		}
//		if(_kNameLastChangedProp==sDrillFemaleLengthName)
//		{
//			if(tslFemale.propDouble(sDrillFemaleLengthName)!=dDrillFemaleLength)
//				tslFemale.setPropDouble(sDrillFemaleLengthName,dDrillFemaleLength);
//		}
//		if(_kNameLastChangedProp==sMillMaleWidthName)
//		{
//			if(tslFemale.propDouble(sMillMaleWidthName)!=dMillMaleWidth)
//				tslFemale.setPropDouble(sMillMaleWidthName,dMillMaleWidth);
//		}
//		if(_kNameLastChangedProp==sMillMaleLengthName)
//		{
//			if(tslFemale.propDouble(sMillMaleLengthName)!=dMillMaleLength)
//				tslFemale.setPropDouble(sMillMaleLengthName,dMillMaleLength);
//		}
//		if(_kNameLastChangedProp==sMillMaleDepthName)
//		{
//			if(tslFemale.propDouble(sMillMaleDepthName)!=dMillMaleDepth)
//				tslFemale.setPropDouble(sMillMaleDepthName,dMillMaleDepth);
//		}
//		if(_kNameLastChangedProp==sDrillMaleDiameterName)
//		{
//			if(tslFemale.propDouble(sDrillMaleDiameterName)!=dDrillMaleDiameter)
//				tslFemale.setPropDouble(sDrillMaleDiameterName,dDrillMaleDiameter);
//		}
//		if(_kNameLastChangedProp==sDrillMaleLengthName)
//		{
//			if(tslFemale.propDouble(sDrillMaleLengthName)!=dDrillMaleLength)
//				tslFemale.setPropDouble(sDrillMaleLengthName,dDrillMaleLength);
//		}
//		if(_kNameLastChangedProp==sDrillMaleLengthName)
//		{
//			if(tslFemale.propDouble(sDrillMaleLengthName)!=dDrillMaleLength)
//				tslFemale.setPropDouble(sDrillMaleLengthName,dDrillMaleLength);
//		}
////		// string
//		if(_kNameLastChangedProp==sManufacturerName)
//		{
//			if(tslFemale.propString(sManufacturerName)!=sManufacturer)
//				tslFemale.setPropString(sManufacturerName,sManufacturer);
//		}
//		if(_kNameLastChangedProp==sFamilyName)
//		{
//			if(tslFemale.propString(sFamilyName)!=sFamily)
//				tslFemale.setPropString(sFamilyName,sFamily);
//		}
//		if(_kNameLastChangedProp==sProductName)
//		{
//			if(tslFemale.propString(sProductName)!=sProduct)
//				tslFemale.setPropString(sProductName,sProduct);
//		}
//		if(_kNameLastChangedProp==sModeDistributionName)
//		{
//			if(tslFemale.propString(sModeDistributionName)!=sModeDistribution)
//				tslFemale.setPropString(sModeDistributionName,sModeDistribution);
//		}
//		if(_kNameLastChangedProp==sClipLockName)
//		{
//			if(tslFemale.propString(sClipLockName)!=sClipLock)
//				tslFemale.setPropString(sClipLockName,sClipLock);
//		}
//		if(_kNameLastChangedProp==sAlignmentName)
//		{
//			if(tslFemale.propString(sAlignmentName)!=sAlignment)
//				tslFemale.setPropString(sAlignmentName,sAlignment);
//		}
//		// pt0
//		if(_kNameLastChangedProp=="_Pt0")
//		{
//			if((tslFemale.ptOrg()-_Pt0).length()>dEps)
//				tslFemale.setPtOrg(_Pt0);
//		}
		
//		if(_Entity.find(tslFemale)<0)
//			_Entity.append(tslFemale);
//		setDependencyOnEntity(tslFemale);
		
	}
}
else if(!iSingle)
{ 	
	dDistanceBetweenResult.setReadOnly(_kHidden);
	nNrResult.setReadOnly(_kHidden);
	//
	addRecalcTrigger(_kGripPointDrag, "_PtG0");
	
	if(_PtG.length()==0)
	{ 
		// ToDo: when no grip point, do distribution all along the plane
		PlaneProfile ppIntersect = pp1;
		int iIntersect=ppIntersect.intersectWith(pp0);
		if(!iIntersect)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|no common range|"));
			eraseInstance();
			return;
		}
		// get extents of profile
		LineSeg seg = ppIntersect.extentInDir(vecYplane);
		double dX = abs(vecXplane.dotProduct(seg.ptStart()-seg.ptEnd()));
		_Pt0 = seg.ptMid() - .5 * dX*vecXplane;
		_PtG.append( seg.ptMid() + .5 * dX*vecXplane);
	}
	
	_PtG[0] = pn.closestPointTo(_PtG[0]);
	if(dDistanceBetween ==0)
		dDistanceBetween.set(U(5));
	
	double dDiameterThread = U(10);
	if (_bOnGripPointDrag && (_kExecuteKey == "_Pt0" || _kExecuteKey == "_PtG0"))
	{ 
		Display dp(3);
		Point3d ptStart = _Pt0;
		Point3d ptEnd = _PtG[0];
		Vector3d vecDir = _PtG[0] - _Pt0;vecDir.normalize();
		double dLengthTot = (ptEnd - ptStart).dotProduct(vecDir);
		Point3d ptText = _Pt0;
		if (_kExecuteKey == "_PtG0")ptText = _PtG[0];
		LineSeg lSeg(ptStart, ptEnd);
		dp.color(1);
		dp.draw(lSeg);
		if (dDistanceBottom + dDistanceTop > dLengthTot)
		{ 
			dp.color(1);
			String sText = TN("|no distribution possible|");
			dp.draw(sText, ptText, _XW, _YW, 0, 0, _kDeviceX);
			return;
		}
		
		double dPartLength = 0;
		Point3d pt1 = ptStart + vecDir * dDistanceBottom;
		Point3d pt2 = ptEnd - vecDir * (dDistanceTop+ dPartLength);
		double dDistTot = (pt2 - pt1).dotProduct(vecDir);
		if (dDistTot < 0)
		{ 
			dp.color(1);
			String sText = TN("|no distribution possible|");
			dp.draw(sText, ptText, _XW, _YW, 0, 0, _kDeviceX);
			return;
		}
		Point3d ptsDis[0];
		
		if (dDistanceBetween >= 0)
		{ 
			// distance in between > 0; distribute with distance
			// modular distance
			double dDistMod = dDistanceBetween + dPartLength;
			int iNrParts = dDistTot / dDistMod;
			double dNrParts=dDistTot / dDistMod;
			if (dNrParts - iNrParts > 0)iNrParts += 1;
			// calculated modular distance between subsequent parts
			
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
	//				dDistanceBetweenResult.set(dDistModCalc-dPartLength);
			// set nr of parts
		//					dDistanceBetweenResult.set(-(ptsDis.length()));
	//				nNrResult.set(ptsDis.length());
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
	//				dDistanceBetweenResult.set(dDistModCalc-dPartLength);
			// set nr of parts
	//				nNrResult.set(ptsDis.length());
		}
		
		for (int i=0;i<ptsDis.length();i++) 
		{ 
			Point3d pt = ptsDis[i];
			PLine pl;
			pl = PLine();
			pl.createCircle(pt, vecPlane, dDiameterThread * .5);
			
			PlaneProfile ppDrill(pn);
			ppDrill.joinRing(pl, _kAdd);
			dp.color(1);
			dp.draw(ppDrill, _kDrawFilled, 30);
			
		}//next i
		return
	}
	
	int iModeDistribution = sModeDistributions.find(sModeDistribution);
	Point3d ptStart = _Pt0;
	Point3d ptEnd = _PtG[0];
	
	Vector3d vecDir = _PtG[0] - _Pt0;vecDir.normalize();
	
	double dLengthTot = (ptEnd - ptStart).dotProduct(vecDir);
	if (dDistanceBottom + dDistanceTop > dLengthTot)
	{ 
		reportMessage(TN("|no distribution possible|"));
		return;
	}
	double dPartLength = 0;
	Point3d pt1 = ptStart + vecDir * dDistanceBottom;
	Point3d pt2 = ptEnd - vecDir * (dDistanceTop+ dPartLength);
	double dDistTot = (pt2 - pt1).dotProduct(vecDir);
	if (dDistTot < 0)
	{ 
		reportMessage(TN("|no distribution possible|"));
		return;
	}
	
	Point3d ptsDis[0];
	if (dDistanceBetween >= 0)
	{ 
		// 2 scenarion even, fixed
		if(iModeDistribution==0)
		{ 
			// even
			// distance in between > 0; distribute with distance
			// modular distance
			double dDistMod = dDistanceBetween + dPartLength;
			int iNrParts = dDistTot / dDistMod;
			double dNrParts=dDistTot / dDistMod;
			if (dNrParts - iNrParts > 0)iNrParts += 1;
			// calculated modular distance between subsequent parts
			
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
			nNrResult.set(ptsDis.length());
			// update description
			dDistanceBetween.setDescription(T("|Defines the Distance Between the parts. -integer indicates nr of parts.|")+
			T("|Real distance |")+dDistanceBetweenResult+" "+
			T("|Quantity of parts |")+nNrResult);
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
			// set nr of parts
			nNrResult.set(ptsDis.length());
			dDistanceBetween.setDescription(T("|Defines the Distance Between the parts. -integer indicates nr of parts.|")+
			T("|Real distance |")+dDistanceBetweenResult+" "+
			T("|Quantity of parts |")+nNrResult);
		}
	}
	else if(dDistanceBetween<0)
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
		dDistanceBetween.setDescription(T("|Defines the Distance Between the parts. -integer indicates nr of parts.|")+
			T("|Real distance |")+dDistanceBetweenResult+" "+
			T("|Quantity of parts |")+nNrResult);
	}
	int iSwapDirection= _Map.getInt("iSwapDirection");
	Body bdReal = bm.envelopeBody(true,true);
	Display dp(1);
	Point3d ptsDisValid[0];
	Vector3d vecYpart = vecPlane;
//	Vector3d vecZpart = vecDir;
	Vector3d vecZpart = qd.vecD(_ZW);
	if (vecZpart.isParallelTo(vecYpart))vecZpart = vecDir;
	if (iSwapDirection)vecZpart *= -1;
	
	Point3d pt0PartStart = _Pt0;
	Display dpPart(252);
	Vector3d vecXpart = vecYpart.crossProduct(vecZpart);
	vecYpart.normalize();
	//vecXpart.vis(pt0PartStart, 1);
	//vecYpart.vis(pt0PartStart, 3);
	//vecZpart.vis(pt0PartStart, 5);
	CoordSys csPartTransform;
	double dLengthDrillReal=U(70);
	//vecDir.vis(_Pt0);
	//vecPlane.vis(_Pt0);
	for (int i=0;i<ptsDis.length();i++) 
	{ 
		Point3d pt = ptsDis[i];
	//	Point3d ptGap = pnNailStart.closestPointTo(pt);
//		csPartTransform.setToAlignCoordSys(ptRefConnector, _XW, _YW, _ZW, pt, vecXpart, vecYpart, vecZpart);
		csPartTransform.setToAlignCoordSys(Point3d(0,0,0), _XW, _YW, _ZW, pt, vecXpart, vecYpart, vecZpart);
		// drill start and end wrt realbody when it goes throug it
		Point3d ptStart, ptEnd;
		{
	//			PlaneProfile ppSlice = bdReal.getSlice(Plane(pt, vecXplane));
			PlaneProfile ppSlice = bdReal.getSlice(Plane(pt, vecDir));
			ppSlice.vis(9);
			PLine plSlices[] = ppSlice.allRings();
			if (plSlices.length() == 0)continue;
	//			Line lnDrill(pt, vecPlane);
			Line lnDrill(pt, vecYpart);
			Point3d ptsIntersect[0];
			for (int i=0;i<plSlices.length();i++) 
			{ 
				Point3d ptsI[] = plSlices[i].intersectPoints(lnDrill);
				ptsIntersect.append(ptsI);
			}//next i
			if (ptsIntersect.length() == 0)continue;
			ptStart = ptsIntersect[0];
			ptEnd = ptsIntersect[0];
			for (int i=0;i<ptsIntersect.length();i++) 
			{ 
				if(vecPlane.dotProduct(ptsIntersect[i]-ptStart)>0)
				{ 
					ptStart = ptsIntersect[i];
				} 
				if(vecPlane.dotProduct(ptsIntersect[i]-ptStart)<0)
				{ 
					ptEnd = ptsIntersect[i];
				} 
			}//next i
		}
		ptsDisValid.append(ptStart);
		PLine pl;
	//		pl.createCircle(ptStart, vecPlane, U(.5));
		pl.createCircle(pt, vecYpart, U(.5));
	//		pl.vis(4);
		pl.projectPointsToPlane(pn, vecYpart);
	//		pl.vis(5);
		
		PlaneProfile pp(Plane(ptStart, vecPlane));
		pp.joinRing(pl, _kAdd);
		dp.draw(pp, _kDrawFilled);
		ptStart.vis(3);
		ptEnd.vis(3);
		
	//	if(dDepth0==0)
	//	{
	//			dDrillDepth = abs(vecPlane.dotProduct(ptStart - ptEnd));
	//			dDrillDepth = abs(vecXnail.dotProduct(ptStart - ptEnd));
	//	}
		//Body bdDrillMain(ptStart + vecPlane * dEps, ptStart - vecPlane * (dDrillDepth + dEps), .5 * dDiameter0);
		//SolidSubtract sosu(bdDrillMain, _kSubtract);
	//		Drill drill0(ptStart + vecPlane * dEps, ptStart - vecPlane * (dDrillDepth + dEps), .5 * dDiameterThread);
	//	if(iDrill)
	//	{ 
	//		Drill drill0(ptGap - vecXnail * dEps, ptGap + vecXnail * (dLengthDrillReal + dEps), .5 * dDiameterDrillReal);
	//		gb.addTool(drill0);
	//		if(_GenBeam.length()>1)
	//		{
	//			if(dLengthDrill!=0)
	//				_GenBeam[1].addTool(drill0);
	//		}
	//	}
	//		LineSeg lSeg (ptStart, ptStart - vecPlane * dDrillDepth);
		LineSeg lSeg (pt, pt+ vecYpart * dLengthDrillReal);
		dp.color(252);
//		dp.draw(lSeg);
		
	//		pp.transformBy(- vecPlane * dDrillDepth);
	//		pp.transformBy(vecXnail * dDrillDepth);
		pl = PLine();
		pl.createCircle(pt+vecYpart * dLengthDrillReal, vecYpart, U(.5));
		pp = PlaneProfile (Plane(pt + vecYpart * dLengthDrillReal, vecYpart));
		pp.joinRing(pl, _kAdd);
		dp.color(1);
//		dp.draw(pp, _kDrawFilled);
		
		Body bdI = bdPart;
		bdI.transformBy(csPartTransform);
		dpPart.draw(bdI);
		
		String sDefaultValue=" "+T("|Default value =|")+" ";
		String _sDefaultValue;
		// milling female
		if(!iModeMale)
		{ 
			double dLengthMillFemale, dWidthMillFemale, dDepthMillFemale;
			String s;
			s = "Width"; if(mapMillFemale.hasDouble(s))dWidthMillFemale = mapMillFemale.getDouble(s);
			_sDefaultValue = sDefaultValue + dWidthMillFemale;
			dMillFemaleWidth.setDescription(sMillFemaleWidthDescription + _sDefaultValue);
			if (dMillFemaleWidth != 0)dWidthMillFemale = dMillFemaleWidth;
			
			s = "Length"; if(mapMillFemale.hasDouble(s))dLengthMillFemale = mapMillFemale.getDouble(s);
			_sDefaultValue = sDefaultValue + dLengthMillFemale;
			dMillFemaleLength.setDescription(sMillFemaleLengthDescription + _sDefaultValue);
			if (dMillFemaleLength != 0)dLengthMillFemale = dMillFemaleLength;
			
			s = "Depth"; if(mapMillFemale.hasDouble(s))dDepthMillFemale = mapMillFemale.getDouble(s);
			_sDefaultValue = sDefaultValue + dDepthMillFemale;
			dMillFemaleDepth.setDescription(sMillFemaleDepthDescription + _sDefaultValue);
			if (dMillFemaleDepth != 0)dDepthMillFemale = dMillFemaleDepth;
			// add 3mm from clip lock
			if (dMillFemaleDepth == 0 && iClipLock)dDepthMillFemale += U(3);
			double dLengthPart;
			s = "Length"; if(mapConnector.hasDouble(s))dLengthPart = mapConnector.getDouble(s);
			Point3d ptMs = ptStart - vecZpart * .5 * dLengthPart+vecPlane*dOffset;
			
			if(dLengthMillFemale>0 && dWidthMillFemale>0 && dDepthMillFemale)
			{ 
				Mortise ms(ptMs,   vecZpart, vecXpart,-vecYpart,
					dLengthMillFemale, dWidthMillFemale,dDepthMillFemale,1,0,1);
//				ms.setRoundType(_kExplicitRadius);
				ms.setRoundType(_kNotRound);
//				ms.setExplicitRadius(U(7));
				bm.addTool(ms);
			}
		}
		// Drill Female
		if(!iModeMale)
		{ 
			double dDepthDrillFemale, dDiameterDrillFemale;
			int iQuantity;
			String s;
			s = "Diameter"; if(mapDrillFemale.hasDouble(s))dDiameterDrillFemale = mapDrillFemale.getDouble(s);
			_sDefaultValue = sDefaultValue + dDiameterDrillFemale;
			dDrillFemaleDiameter.setDescription(sDrillFemaleDiameterDescription+ _sDefaultValue);
			if (dDrillFemaleDiameter != 0)dDiameterDrillFemale = dDrillFemaleDiameter;
			
			s = "Depth"; if(mapDrillFemale.hasDouble(s))dDepthDrillFemale = mapDrillFemale.getDouble(s);
			_sDefaultValue = sDefaultValue + dDepthDrillFemale;
			dDrillFemaleLength.setDescription(sDrillFemaleLengthDescription+ _sDefaultValue);
			if (dDrillFemaleLength != 0)dDepthDrillFemale = dDrillFemaleLength;
		
			s = "Quantity"; if(mapDrillFemale.hasInt(s))iQuantity = mapDrillFemale.getInt(s);
			for (int iDr=0;iDr<iQuantity;iDr++) 
			{ 
				int ii = iDr + 1;
				String sx = "x" + ii;
				String sy = "y" + ii;
				double dX = mapDrillFemale.getDouble(sx);
				double dY = mapDrillFemale.getDouble(sy);
				Point3d ptDr = ptStart + dX * vecXpart + dY * vecZpart+vecPlane*dOffset;
				if(dDepthDrillFemale>0 && dDiameterDrillFemale>0)
				{ 
					Drill dr(ptDr, ptDr -vecYpart * dDepthDrillFemale, .5 * dDiameterDrillFemale);
					bm.addTool(dr);
				}
			}//next iDr
		}
		// milling male
		if(mapProduct.hasMap("MillMale") && !iModeMale)
		{ 
			double dLengthMillMale, dWidthMillMale, dDepthMillMale;
			String s;
			s = "Width"; if(mapMillMale.hasDouble(s))dWidthMillMale = mapMillMale.getDouble(s);
			_sDefaultValue = sDefaultValue + dWidthMillMale;
			dMillMaleWidth.setDescription(sMillMaleWidthDescription + _sDefaultValue);
			if (dMillMaleWidth != 0)dWidthMillMale = dMillMaleWidth;
			
			s = "Length"; if(mapMillMale.hasDouble(s))dLengthMillMale = mapMillMale.getDouble(s);
			_sDefaultValue = sDefaultValue + dLengthMillMale;
			dMillMaleLength.setDescription(sMillMaleLengthDescription + _sDefaultValue);
			if (dMillMaleLength != 0)dLengthMillMale = dMillMaleLength;
			
			s = "Depth"; if(mapMillMale.hasDouble(s))dDepthMillMale = mapMillMale.getDouble(s);
			_sDefaultValue = sDefaultValue + dDepthMillMale;
			dMillMaleDepth.setDescription(sMillMaleDepthDescription + _sDefaultValue);
			if (dMillMaleDepth != 0)dDepthMillMale = dMillMaleDepth;
	
			double dLengthPart;
			s = "Length"; if(mapConnector.hasDouble(s))dLengthPart = mapConnector.getDouble(s);
			Point3d ptMs = ptStart - vecZpart * .5 * dLengthPart+vecPlane*dOffset;
			
			if(dLengthMillMale>0 && dWidthMillMale>0 && dDepthMillMale)
			{ 
				Mortise ms(ptMs,   vecZpart, vecXpart,vecYpart,
					dLengthMillMale, dWidthMillMale,dDepthMillMale,1,0,1);
//				ms.setRoundType(_kExplicitRadius);
				ms.setRoundType(_kNotRound);
//				ms.setExplicitRadius(U(7));
				ms.cuttingBody().vis(2);
				bm0.addTool(ms);
			}
		}
		// Drill male
		if(!iModeMale)
		{ 
			double dDepthDrillMale, dDiameterDrillMale;
			int iQuantity;
			String s;
			s = "Diameter"; if(mapDrillMale.hasDouble(s))dDiameterDrillMale = mapDrillMale.getDouble(s);
			_sDefaultValue = sDefaultValue + dDiameterDrillMale;
			dDrillMaleDiameter.setDescription(sDrillMaleDiameterDescription+ _sDefaultValue);
			if (dDrillMaleDiameter != 0)dDiameterDrillMale = dDrillMaleDiameter;
			
			s = "Depth"; if(mapDrillMale.hasDouble(s))dDepthDrillMale = mapDrillMale.getDouble(s);
			_sDefaultValue = sDefaultValue + dDepthDrillMale;
			dDrillMaleLength.setDescription(sDrillMaleLengthDescription+ _sDefaultValue);
			if (dDrillMaleLength != 0)dDepthDrillMale = dDrillMaleLength;
			
			s = "Quantity"; if(mapDrillMale.hasInt(s))iQuantity = mapDrillMale.getInt(s);
			for (int iDr=0;iDr<iQuantity;iDr++) 
			{ 
				int ii = iDr + 1;
				String sx = "x" + ii;
				String sy = "y" + ii;
				double dX = mapDrillMale.getDouble(sx);
				double dY = mapDrillMale.getDouble(sy);
				Point3d ptDr = ptStart + dX * vecXpart + dY * vecZpart+vecPlane*dOffset;
				if(dDepthDrillMale>0 && dDiameterDrillMale>0)
				{ 
					Drill dr(ptDr, ptDr +vecYpart * dDepthDrillMale, .5 * dDiameterDrillMale);
					bm0.addTool(dr);
				}
			}//next iDr
			if(iQuantity<=1)
			{ 
				Point3d ptDr = ptStart + vecPlane*dOffset;
				Drill dr(ptDr, ptDr +vecYpart * dDepthDrillMale, .5 * dDiameterDrillMale);
				bm0.addTool(dr);
			}
			
			//
			if(mapProduct.hasMap("DrillMaleSinkHole"))
			{ 
				double dDepthDrillMale, dDiameterDrillMale;
				String s;
				s = "Diameter"; if(mapDrillMaleSinkHole.hasDouble(s))dDiameterDrillMale = mapDrillMaleSinkHole.getDouble(s);
	//			if (dDrillMaleDiameter >= 0)dDiameterDrillMale = dDrillMaleDiameter;
				s = "Depth"; if(mapDrillMaleSinkHole.hasDouble(s))dDepthDrillMale = mapDrillMaleSinkHole.getDouble(s);
	//			if (dDrillMaleLength >= 0)dDepthDrillMale = dDrillMaleLength;
				
				if(dDepthDrillMale>0 && dDiameterDrillMale>0)
				{ 
					Point3d ptDr = ptStart + vecPlane*dOffset;
					Drill dr(ptDr, ptDr +vecYpart * dDepthDrillMale, .5 * dDiameterDrillMale);
					bm0.addTool(dr);
				}
			}
		}
		if(mapProduct.hasMap("DrillMale2") && !iModeMale)
		{ 
			double dDepthDrillMale, dDiameterDrillMale;
			int iQuantity;
			String s;
			s = "Diameter"; if(mapDrillMale2.hasDouble(s))dDiameterDrillMale = mapDrillMale2.getDouble(s);
	//		if (dDrillMaleDiameter >= 0)dDiameterDrillMale = dDrillMaleDiameter;
			s = "Depth"; if(mapDrillMale2.hasDouble(s))dDepthDrillMale = mapDrillMale2.getDouble(s);
	//		if (dDrillMaleLength >= 0)dDepthDrillMale = dDrillMaleLength;
			
			s = "Quantity"; if(mapDrillMale2.hasInt(s))iQuantity = mapDrillMale2.getInt(s);
			for (int iDr=0;iDr<iQuantity;iDr++) 
			{ 
				int ii = iDr + 1;
				String sx = "x" + ii;
				String sy = "y" + ii;
				double dX = mapDrillMale2.getDouble(sx);
				double dY = mapDrillMale2.getDouble(sy);
				Point3d ptDr = ptStart + dX * vecXpart + dY * vecZpart+vecPlane*dOffset;
				if(dDepthDrillMale>0 && dDiameterDrillMale>0)
				{ 
					Drill dr(ptDr, ptDr +vecYpart * dDepthDrillMale, .5 * dDiameterDrillMale);
					bm0.addTool(dr);
				}
			}//next iDr
			if(iQuantity<=1)
			{ 
				if(dDepthDrillMale>0 && dDiameterDrillMale>0)
				{ 
					Point3d ptDr = ptStart + vecPlane*dOffset;
					Drill dr(ptDr, ptDr +vecYpart * dDepthDrillMale, .5 * dDiameterDrillMale);
					bm0.addTool(dr);
				}
			}
		}
		
	//	if(dDiameter1>0)
	//	{ 
	//		// sink hole
	//		double dSinkDepth1 = dDepth1;
	//		if(dDepth1==0)
	//			dSinkDepth1 = dDiameter1 * .5;
	//		
	//		// second point of cone
	//		double _dRadius2 = .5 * dDiameter0 - dEps;
	//		double _dDepth2 = (1-(_dRadius2 / (.5 * dDiameter1))) * dSinkDepth1;
	//		
	//		Body bdSink1(ptStart, ptStart - vecPlane * _dDepth2, .5*dDiameter1, _dRadius2);
	//		SolidSubtract sosu1(bdSink1, _kSubtract);
	//		gb.addTool(sosu1);
	//	}
	//	
	//	if(dDiameter2>0)
	//	{ 
	//		// sink hole
	//		double dSinkDepth2 = dDepth2;
	//		if(dDepth2==0)
	//			dSinkDepth2 = dDiameter2 * .5;
	//		
	//		// second point of cone
	//		double _dRadius2 = .5 * dDiameter0 - dEps;
	//		double _dDepth2 = (1-(_dRadius2 / (.5 * dDiameter2))) * dSinkDepth2;
	//		
	//		Body bdSink1(ptStart-vecPlane*dDrillDepth, ptStart-vecPlane*dDrillDepth+ vecPlane * _dDepth2, .5*dDiameter2, _dRadius2);
	//		SolidSubtract sosu2(bdSink1, _kSubtract);
	//		gb.addTool(sosu2);
	//	}
	}//next i
	
	
//region add drill to indicate upward orientation of the part
if(!iModeMale && iOrientationDrill)
{ 
	Point3d ptDrill = ptCen + .5 * qd.dD(vecPlane) * qd.vecD(vecPlane) + (.5 * qd.dD(vecZpart) - U(30)) * qd.vecD(vecZpart);
	Drill drSide(ptDrill, ptDrill -vecYpart * U(10), U(10));
	bm.addTool(drSide);
	ptDrill = ptCen0 + .5 * qd0.dD(-vecPlane) * qd0.vecD(-vecPlane) + (.5 * qd0.dD(vecZpart) - U(30)) * qd0.vecD(vecZpart);
	Drill drSide0(ptDrill, ptDrill +vecYpart * U(10), U(10));
	bm0.addTool(drSide0);
}
//End add drill to indicate upward orientation of the part//endregion 
	
//region Trigger swapBeams
	String sTriggerswapBeams = T("|swap Beams|");
	addRecalcTrigger(_kContextRoot, sTriggerswapBeams );
	if (_bOnRecalc && _kExecuteKey==sTriggerswapBeams)
	{
		Vector3d vecSnew[] ={ vecY0, - vecY0, vecZ0 ,- vecZ0};
		Vector3d vecAlignmentNew = qd0.vecD(-vecAlignment);
//		int iAlignmentNew = -1;
//		for (int iV=0;iV<vecSnew.length();iV++) 
//		{ 
//			if( vecSnew[iV].isCodirectionalTo(-vecs[iAlignment]))
//			{ 
//				iAlignmentNew = iV;
//				break;
//			}
//		}//next iV
//		if(iAlignmentNew>-1)
//		{
//			sAlignment.set(sAlignments[iAlignmentNew]);
//			_Beam.swap(0, 1);
//		}
//		else
//		{ 
//			reportMessage("\n"+scriptName()+" "+T("|not possible|"));
//		}
		
		_Map.setVector3d("vecAlignment", vecAlignmentNew);
		_Beam.swap(0, 1);
		setExecutionLoops(2);
		return;
	}//endregion	
	
//region Trigger swapDirection
	String sTriggerswapDirection = T("|swap Direction|");
	addRecalcTrigger(_kContextRoot, sTriggerswapDirection );
	if (_bOnRecalc && _kExecuteKey==sTriggerswapDirection)
	{
//			Point3d _pt = _Pt0;
//			_Pt0 = _PtG[0];
//			_PtG[0] = _pt;
		
		int iSwapDirectionNew =! iSwapDirection;
		_Map.setInt("iSwapDirection", iSwapDirectionNew);
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger generateSingleInstances
	String sTriggergenerateSingleInstances = T("|generate Single Instances|");
	addRecalcTrigger(_kContextRoot, sTriggergenerateSingleInstances );
	if (_bOnRecalc && _kExecuteKey==sTriggergenerateSingleInstances)
	{
//			int iSwapDirection = vecX.dotProduct(vecDir) < 0 ? 1 : 0;
		// create TSL
		TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {bm0,bm}; Entity entsTsl[] = {}; Point3d ptsTsl[] = {_Pt0};
		int nProps[]={nNrResult};			
		double dProps[]={dDistanceBottom, dDistanceTop,-1,dDistanceBetweenResult,dOffset,
		dMillFemaleWidth, dMillFemaleLength, dMillFemaleDepth, dDrillFemaleDiameter, dDrillFemaleLength,
		dMillMaleWidth, dMillMaleLength, dMillMaleDepth, dDrillMaleDiameter, dDrillMaleLength};				
		String sProps[]={sManufacturer, sFamily, sProduct, sModeDistribution, 
			sClipLock,sAlignment, sOrientationDrill};
		Map mapTsl;	
		mapTsl.setInt("iSwapDirection", iSwapDirection);
		mapTsl.setVector3d("vecAlignment", vecAlignment);
		for (int i=0;i<ptsDisValid.length();i++) 
		{ 
			ptsTsl[0] = ptsDis[i];
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
		}//next i
		
		eraseInstance();
		return;
	}//endregion	
	//region create male tsl
	if ( ! iModeMale)
	{
		
		TslInst tslMale;
		if ( ! _Map.hasEntity("maleTsl"))
		{
			TslInst tslNew; Vector3d vecXTsl = _XW; Vector3d vecYTsl = _YW;
			GenBeam gbsTsl[] = { bm0, bm}; Entity entsTsl[] = { }; Point3d ptsTsl[] = { _Pt0, _PtG[0]};
			int nProps[] ={ nNrResult};
			double dProps[] ={ dDistanceBottom, dDistanceTop, dDistanceBetween, dDistanceBetweenResult,dOffset,
				dMillFemaleWidth, dMillFemaleLength, dMillFemaleDepth, dDrillFemaleDiameter, dDrillFemaleLength,
			dMillMaleWidth, dMillMaleLength, dMillMaleDepth, dDrillMaleDiameter, dDrillMaleLength};
			String sProps[] ={ sManufacturer, sFamily, sProduct, sModeDistribution,
				sClipLock, sAlignment, sOrientationDrill};
			Map mapTsl;
			mapTsl.setInt("iSwapDirection", iSwapDirection);
			mapTsl.setInt("ModeMale", true);
			mapTsl.setEntity("femaleTsl", _ThisInst);
			tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl,
			ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			tslNew.recalc();
			tslMale = tslNew;
		}
		else
		{
			Entity tslEnt = _Map.getEntity("maleTsl");
			TslInst tslMaleThis = (TslInst)tslEnt;
			if ( ! tslMaleThis.bIsValid())
			{
				TslInst tslNew; Vector3d vecXTsl = _XW; Vector3d vecYTsl = _YW;
				GenBeam gbsTsl[] = { bm0, bm}; Entity entsTsl[] = { }; Point3d ptsTsl[] = { _Pt0, _PtG[0]};
				int nProps[] ={ nNrResult};
				double dProps[] ={ dDistanceBottom, dDistanceTop, dDistanceBetween, dDistanceBetweenResult,dOffset,
					dMillFemaleWidth, dMillFemaleLength, dMillFemaleDepth, dDrillFemaleDiameter, dDrillFemaleLength,
				dMillMaleWidth, dMillMaleLength, dMillMaleDepth, dDrillMaleDiameter, dDrillMaleLength};
				String sProps[] ={ sManufacturer, sFamily, sProduct, sModeDistribution,
					sClipLock, sAlignment, sOrientationDrill};
				Map mapTsl;
				mapTsl.setInt("iSwapDirection", iSwapDirection);
				mapTsl.setInt("ModeMale", true);
				mapTsl.setEntity("femaleTsl", _ThisInst);
				tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl,
				ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
				tslNew.recalc();
				tslMale = tslNew;
			}
			else
			{
				tslMale = tslMaleThis;
			}
		}
		Map mapMale = tslMale.map();
		mapMale.setEntity("femaleTsl", _ThisInst);
		tslMale.setMap(mapMale);
//		if(tslMale.bIsValid())
			_Map.setEntity("maleTsl", tslMale);
		if (_Entity.find(tslMale) < 0)
			_Entity.append(tslMale);
		setDependencyOnEntity(tslMale);
		
//		// properties
//		if(_kNameLastChangedProp==sNrResultName)
//		{
			if(tslMale.propInt(0)!=nNrResult)
				tslMale.setPropInt(0, nNrResult);
//		}
////		//double
//		if(_kNameLastChangedProp==sDistanceBottomName)
//		{
			if(tslMale.propDouble(0)!=dDistanceBottom)
				tslMale.setPropDouble(0, dDistanceBottom);
//		}
//		if(_kNameLastChangedProp==sDistanceTopName)
//		{
			if(tslMale.propDouble(1)!=dDistanceTop)
				tslMale.setPropDouble(1, dDistanceTop);
//		}
//		if(_kNameLastChangedProp==sDistanceBetweenName)
//		{
			if(tslMale.propDouble(2)!=dDistanceBetween)
				tslMale.setPropDouble(2, dDistanceBetween);
//		}
//		if(_kNameLastChangedProp==sDistanceBetweenResultName)
//		{
			if(tslMale.propDouble(3)!=dDistanceBetweenResult)
				tslMale.setPropDouble(3, dDistanceBetweenResult);
//		}
			if(tslMale.propDouble(4)!=dOffset)
				tslMale.setPropDouble(4, dOffset);
//		if(_kNameLastChangedProp==sMillFemaleWidthName)
//		{
			if(tslMale.propDouble(5)!=dMillFemaleWidth)
				tslMale.setPropDouble(5,dMillFemaleWidth);
//		}
//		if(_kNameLastChangedProp==sMillFemaleLengthName)
//		{
			if(tslMale.propDouble(6)!=dMillFemaleLength)
				tslMale.setPropDouble(6,dMillFemaleLength);
//		}
//		if(_kNameLastChangedProp==sMillFemaleDepthName)
//		{
			if(tslMale.propDouble(7)!=dMillFemaleDepth)
				tslMale.setPropDouble(7,dMillFemaleDepth);
//		}
//		if(_kNameLastChangedProp==sDrillFemaleDiameterName)
//		{
			if(tslMale.propDouble(8)!=dDrillFemaleDiameter)
				tslMale.setPropDouble(8,dDrillFemaleDiameter);
//		}
//		if(_kNameLastChangedProp==sDrillFemaleLengthName)
//		{
			if(tslMale.propDouble(9)!=dDrillFemaleLength)
				tslMale.setPropDouble(9,dDrillFemaleLength);
//		}
//		if(_kNameLastChangedProp==sMillMaleWidthName)
//		{
			if(tslMale.propDouble(10)!=dMillMaleWidth)
				tslMale.setPropDouble(10,dMillMaleWidth);
//		}
//		if(_kNameLastChangedProp==sMillMaleLengthName)
//		{
			if(tslMale.propDouble(11)!=dMillMaleLength)
				tslMale.setPropDouble(11,dMillMaleLength);
//		}
//		if(_kNameLastChangedProp==sMillMaleDepthName)
//		{
			if(tslMale.propDouble(12)!=dMillMaleDepth)
				tslMale.setPropDouble(12,dMillMaleDepth);
//		}
//		if(_kNameLastChangedProp==sDrillMaleDiameterName)
//		{
			if(tslMale.propDouble(13)!=dDrillMaleDiameter)
				tslMale.setPropDouble(13,dDrillMaleDiameter);
//		}
//		if(_kNameLastChangedProp==sDrillMaleLengthName)
//		{
			if(tslMale.propDouble(14)!=dDrillMaleLength)
				tslMale.setPropDouble(14,dDrillMaleLength);
//		}
//		if(_kNameLastChangedProp==sDrillMaleLengthName)
//		{
			if(tslMale.propDouble(15)!=dDrillMaleLength)
				tslMale.setPropDouble(15,dDrillMaleLength);
//		}
////		// string
//		if(_kNameLastChangedProp==sManufacturerName)
//		{
			if(tslMale.propString(0)!=sManufacturer)
				tslMale.setPropString(0,sManufacturer);
//		}
//		if(_kNameLastChangedProp==sFamilyName)
//		{
			if(tslMale.propString(1)!=sFamily)
				tslMale.setPropString(1,sFamily);
//		}
//		if(_kNameLastChangedProp==sProductName)
//		{
			if(tslMale.propString(2)!=sProduct)
				tslMale.setPropString(2,sProduct);
//		}
//		if(_kNameLastChangedProp==sModeDistributionName)
//		{
			if(tslMale.propString(3)!=sModeDistribution)
				tslMale.setPropString(3,sModeDistribution);
//		}
//		if(_kNameLastChangedProp==sClipLockName)
//		{
			if(tslMale.propString(4)!=sClipLock)
				tslMale.setPropString(4,sClipLock);
//		}
//		if(_kNameLastChangedProp==sAlignmentName)
//		{
			if(tslMale.propString(5)!=sAlignment)
				tslMale.setPropString(5,sAlignment);
//		}
			if(tslMale.propString(6)!=sAlignment)
				tslMale.setPropString(6,sOrientationDrill);
//		// _Pt0
//		if(_kNameLastChangedProp=="_Pt0")
//		{
			if((tslMale.ptOrg()-_Pt0).length()>dEps)
				tslMale.setPtOrg(_Pt0);
			if((tslMale.gripPoint(0)-_PtG[0]).length()>dEps)
			{
//				tslMale.setgrip(_Pt0);
				TslInst tslNew; Vector3d vecXTsl = _XW; Vector3d vecYTsl = _YW;
				GenBeam gbsTsl[] = { bm0, bm}; Entity entsTsl[] = { }; Point3d ptsTsl[] = { _Pt0, _PtG[0]};
				int nProps[] ={ nNrResult};
				double dProps[] ={ dDistanceBottom, dDistanceTop, dDistanceBetween, dDistanceBetweenResult,dOffset,
					dMillFemaleWidth, dMillFemaleLength, dMillFemaleDepth, dDrillFemaleDiameter, dDrillFemaleLength,
				dMillMaleWidth, dMillMaleLength, dMillMaleDepth, dDrillMaleDiameter, dDrillMaleLength};
				String sProps[] ={ sManufacturer, sFamily, sProduct, sModeDistribution,
					sClipLock, sAlignment, sOrientationDrill};
				Map mapTsl;
				mapTsl.setInt("iSwapDirection", iSwapDirection);
				mapTsl.setInt("ModeMale", true);
				mapTsl.setEntity("femaleTsl", _ThisInst);
				tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl,
				ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
				tslNew.recalc();
				tslMale.dbErase();
				tslMale = tslNew;
				_Map.setEntity("maleTsl", tslMale);
				if (_Entity.find(tslMale) < 0)
					_Entity.append(tslMale);
				setDependencyOnEntity(tslMale);
			}
//		}
		//
		_Map.setEntity("maleTsl", tslMale);
		if (_Entity.find(tslMale) < 0)
			_Entity.append(tslMale);
		setDependencyOnEntity(tslMale);
	}
	if(iModeMale)
	{ 
		sManufacturer.setReadOnly(_kReadOnly);
		sFamily.setReadOnly(_kReadOnly);
		sProduct.setReadOnly(_kReadOnly);
		sModeDistribution.setReadOnly(_kReadOnly);
		sClipLock.setReadOnly(_kReadOnly);
//		sAlignment.setReadOnly(_kReadOnly);
//		nNrResult.setReadOnly(_kReadOnly);
		//
		dDistanceBottom.setReadOnly(_kReadOnly);
		dDistanceTop.setReadOnly(_kReadOnly);
		dDistanceBetween.setReadOnly(_kReadOnly);
		dOffset.setReadOnly(_kReadOnly);
//		dDistanceBetweenResult.setReadOnly(_kReadOnly);
		dMillFemaleWidth.setReadOnly(_kReadOnly);
		dMillFemaleLength.setReadOnly(_kReadOnly);
		dMillFemaleDepth.setReadOnly(_kReadOnly);
		dDrillFemaleDiameter.setReadOnly(_kReadOnly);
		dDrillFemaleLength.setReadOnly(_kReadOnly);
		dMillMaleWidth.setReadOnly(_kReadOnly);
		dMillMaleLength.setReadOnly(_kReadOnly);
		dMillMaleDepth.setReadOnly(_kReadOnly);
		dDrillMaleDiameter.setReadOnly(_kReadOnly);
		dDrillMaleLength.setReadOnly(_kReadOnly);
		dDrillMaleLength.setReadOnly(_kReadOnly);
		//
		
	}
//End create male tsl//endregion 
}
if(!iModeMale)
{ 
// Hardware//region
// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 

// declare the groupname of the hardware components
	String sHWGroupName;
	// set group name
	{ 
	// element
		// try to catch the element from the parent entity
		Element elHW =bm.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid())	elHW = (Element)bm;
		if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
		}		
	}
	
	for (int iA=0;iA<mapArticles.length();iA++) 
	{ 
		Map mapArticleI = mapArticles.getMap(iA);
		String sArticleNumber, sName;
		String s;
		s = "ArticleNumber";if(mapArticleI.hasString(s)) sArticleNumber = mapArticleI.getString(s);
		s = "Name";if(mapArticleI.hasString(s)) sName = mapArticleI.getString(s);
		
		HardWrComp hwc(sArticleNumber, nNrResult);
		hwc.setManufacturer("Knapp");
		
//			hwc.setModel(sNameConnector);
			hwc.setName(sName);
//			hwc.setDescription(sHWDescription);
//			hwc.setMaterial(sHWMaterial);
//			hwc.setNotes(sHWNotes);
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(bm);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
//			hwc.setDScaleX(dLengthConnector);
//			hwc.setDScaleY(dWidthConnector);
//			hwc.setDScaleZ(dThicknessConnector);
		
	// apppend component to the list of components
		hwcs.append(hwc);
	}//next iA
	if(iClipLock)
	{ 
		Map mapClipLock = mapFamily.getMap("Sperrklappe");
		String sArticleNumber, sName;
		String s;
		s = "ArticleNumber";if(mapClipLock.hasString(s)) sArticleNumber = mapClipLock.getString(s);
		s = "Name";if(mapClipLock.hasString(s)) sName = mapClipLock.getString(s);
		HardWrComp hwc(sArticleNumber, nNrResult);
		hwc.setManufacturer("Knapp");
		
//			hwc.setModel(sNameConnector);
			hwc.setName(sName);
//			hwc.setDescription(sHWDescription);
//			hwc.setMaterial(sHWMaterial);
//			hwc.setNotes(sHWNotes);
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(bm);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
//			hwc.setDScaleX(dLengthConnector);
//			hwc.setDScaleY(dWidthConnector);
//			hwc.setDScaleZ(dThicknessConnector);
		
	// apppend component to the list of components
		hwcs.append(hwc);
	}
	
	
	// add main componnent
	
	
//		{ 
//			Map mapConnector = mapProduct.getMap("Connector");
//			String sNameConnector;
//			double dLengthConnector, dWidthConnector, dThicknessConnector;
//			String s;
//			s = "Name";if(mapConnector.hasString(s)) sNameConnector = mapConnector.getString(s);
//			s = "Length";if(mapConnector.hasDouble(s)) dLengthConnector = mapConnector.getDouble(s);
//			s = "Width";if(mapConnector.hasDouble(s)) dWidthConnector = mapConnector.getDouble(s);
//			s = "Thickness";if(mapConnector.hasDouble(s)) dThicknessConnector = mapConnector.getDouble(s);
//		
//			HardWrComp hwc(sNameConnector, 1); // the articleNumber and the quantity is mandatory
//			
//			hwc.setManufacturer("Knapp");
//			
//			hwc.setModel(sNameConnector);
//			hwc.setName(sNameConnector);
////			hwc.setDescription(sHWDescription);
////			hwc.setMaterial(sHWMaterial);
////			hwc.setNotes(sHWNotes);
//			
//			hwc.setGroup(sHWGroupName);
//			hwc.setLinkedEntity(bm);	
//			hwc.setCategory(T("|Connector|"));
//			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
//			
//			
//			hwc.setDScaleX(dLengthConnector);
//			hwc.setDScaleY(dWidthConnector);
//			hwc.setDScaleZ(dThicknessConnector);
//			
//		// apppend component to the list of components
//			hwcs.append(hwc);
//		}
//		// nails of connector
//		{ 
//			Map mapConnectorNail = mapProduct.getMap("ConnectorNail");
//			String sNameConnectorNail;
//			int iQuantityConnectorNail;
//			double dLengthConnectorNail, dDiameterConnectorNail;
//			String s;
//			s = "Name";if(mapConnectorNail.hasString(s)) sNameConnectorNail = mapConnectorNail.getString(s);
//			s = "Length";if(mapConnectorNail.hasDouble(s)) dLengthConnectorNail = mapConnectorNail.getDouble(s);
//			s = "Diameter";if(mapConnectorNail.hasDouble(s)) dDiameterConnectorNail = mapConnectorNail.getDouble(s);
//			s = "Quantity";if(mapConnectorNail.hasInt(s)) iQuantityConnectorNail = mapConnectorNail.getInt(s);
//		
//			HardWrComp hwc(sNameConnectorNail, iQuantityConnectorNail); // the articleNumber and the quantity is mandatory
//			
//			hwc.setManufacturer("Knapp");
//			
//			hwc.setModel(sNameConnectorNail);
//			hwc.setName(sNameConnectorNail);
////			hwc.setDescription(sHWDescription);
////			hwc.setMaterial(sHWMaterial);
////			hwc.setNotes(sHWNotes);
//			
//			hwc.setGroup(sHWGroupName);
//			hwc.setLinkedEntity(bm);	
//			hwc.setCategory(T("|Connector|"));
//			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
//			
//			
//			hwc.setDScaleX(dLengthConnectorNail);
//			hwc.setDScaleY(dDiameterConnectorNail);
////			hwc.setDScaleZ(dDiameterConnectorNail);
//			
//		// apppend component to the list of components
//			hwcs.append(hwc);
//		}
//		// screw for the male beam
//		{ 
//			Map mapScrewMale = mapProduct.getMap("ScrewMale");
//			String sNameScrewMale;
////			int iQuantityConnectorNail;
//			double dLengthScrewMale, dDiameterScrewMale;
//			String s;
//			s = "Name";if(mapScrewMale.hasString(s)) sNameScrewMale = mapScrewMale.getString(s);
//			s = "Length";if(mapScrewMale.hasDouble(s)) dLengthScrewMale = mapScrewMale.getDouble(s);
//			s = "Diameter";if(mapScrewMale.hasDouble(s)) dDiameterScrewMale = mapScrewMale.getDouble(s);
//		
//			HardWrComp hwc(sNameScrewMale, 1); // the articleNumber and the quantity is mandatory
//			
//			hwc.setManufacturer("Knapp");
//			
//			hwc.setModel(sNameScrewMale);
//			hwc.setName(sNameScrewMale);
////			hwc.setDescription(sHWDescription);
////			hwc.setMaterial(sHWMaterial);
////			hwc.setNotes(sHWNotes);
//			
//			hwc.setGroup(sHWGroupName);
//			hwc.setLinkedEntity(bm0);	
//			hwc.setCategory(T("|Connector|"));
//			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
//			
//			
//			hwc.setDScaleX(dLengthScrewMale);
//			hwc.setDScaleY(dDiameterScrewMale);
////			hwc.setDScaleZ(dDiameterConnectorNail);
//			
//		// apppend component to the list of components
//			hwcs.append(hwc);
//		}
//		// Sperrklappe, cliplock
//		if(iClipLock)
//		{ 
//			
//			HardWrComp hwc(sNameScrewMale, 1); // the articleNumber and the quantity is mandatory
//			
//			hwc.setManufacturer("Knapp");
//			
//			hwc.setModel(sNameScrewMale);
//			hwc.setName(sNameScrewMale);
////			hwc.setDescription(sHWDescription);
////			hwc.setMaterial(sHWMaterial);
////			hwc.setNotes(sHWNotes);
//			
//			hwc.setGroup(sHWGroupName);
//			hwc.setLinkedEntity(bm0);	
//			hwc.setCategory(T("|Connector|"));
//			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
//			
//			
//			hwc.setDScaleX(dLengthScrewMale);
//			hwc.setDScaleY(dDiameterScrewMale);
////			hwc.setDScaleZ(dDiameterConnectorNail);
//			
//		// apppend component to the list of components
//			hwcs.append(hwc);
//		}
	
// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);	
//endregion
}


#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$!+`$L``#_X1,U17AI9@``24DJ``@````2```!`P`!
M``````H```$!`P`!````@`<```(!`P`$````Y@````8!`P`!`````0````\!
M`@`&````[@```!`!`@`*````]````!(!`P`!`````0```!4!`P`!````!```
M`!H!!0`!````_@```!L!!0`!````!@$``"@!`P`!`````@```#$!`@`D````
M#@$``#(!`@`4````,@$``#L!`@`.````1@$``!,"`P`!`````@```)B"`@!;
M````5`$``*7$!P#0````KP$``&F'!``!````@`(``+`$```(``@`"``(`$Q%
M24-!`$1)1TE,55@@,@`L`0```0```"P!```!````061O8F4@4&AO=&]S:&]P
M($-#(#(P,34@*$UA8VEN=&]S:"D`,C`Q-CHP-CHR,B`Q-#HP-CHT.`!2;V)E
M<G0@2VET=&5L`,*I(%)O8F5R="!+:71T96P@XH"3($%L;&4@4F5C:'1E('9O
M<F)E:&%L=&5N+"!A;&P@<FEG:'1S(')E<V5R=F5D+"!4;W5S(&1R;VET<R!R
MPZES97)VPZES+@!0<FEN=$E-`#`R-3````X``0`6`!8``@```````P!D````
M!P``````"```````"0``````"@``````"P"L````#```````#0``````#@#$
M``````$%`````0$!````$`&`````"1$``!`G```+#P``$"<``)<%```0)P``
ML`@``!`G```!'```$"<``%X"```0)P``BP```!`G``#+`P``$"<``.4;```0
M)P```````````````````````````````````````````````````"0`FH(%
M``$````V!```G8(%``$````^!```(H@#``$````#````)X@#``$```!D````
M`)`'``0````P,C(P`Y`"`!0```!&!```!)`"`!0```!:!````9$'``0````!
M`@,``I$%``$```!N!````9(*``$```!V!````I(%``$```!^!```!)(*``$`
M``"&!```!9(%``$```".!```!Y(#``$````%````")(#``$`````````"9(#
M``$````0````"I(%``$```"6!````*`'``0````P,3`P`:`#``$```#__P``
M`J`$``$```!8`@```Z`$``$```!8`@``%Z(#``$````"`````*,'``$````#
M`````:,'``$````!`````J,'``@```">!````:0#``$``````````J0#``$`
M`````````Z0#``$````!````!*0%``$```"F!```!:0#``$````F````!J0#
M``$`````````!Z0#``$`````````"*0#``$`````````":0#``$`````````
M"J0#``$`````````#*0#``$````"``````````H```#0!P``4`````H````R
M,#`V.C`W.C(P(#$S.C$T.C`T`#(P,#8Z,#<Z,C`@,3,Z,30Z,#0`"`````$`
M``#<'0``Z`,``#P````*````0@```&0````4````"@```%\````*``````(`
M`@`!`0(`````"@``````!@`#`0,``0````8````:`04``0```/X$```;`04`
M`0````8%```H`0,``0````(````!`@0``0````X%```"`@0``0```!\.````
M````+`$```$````L`0```0```/_8_^T`#$%D;V)E7T--``'_[@`.061O8F4`
M9(`````!_]L`A``,"`@("0@,"0D,$0L*"Q$5#PP,#Q48$Q,5$Q,8$0P,#`P,
M#!$,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,`0T+"PT.#1`.#A`4#@X.
M%!0.#@X.%!$,#`P,#!$1#`P,#`P,$0P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,
M#`P,#`S_P``1"`"@`*`#`2(``A$!`Q$!_]T`!``*_\0!/P```04!`0$!`0$`
M`````````P`!`@0%!@<("0H+`0`!!0$!`0$!`0`````````!``(#!`4&!P@)
M"@L0``$$`0,"!`(%!P8(!0,,,P$``A$#!"$2,05!46$3(G&!,@84D:&Q0B,D
M%5+!8C,T<H+10P<EDE/PX?%C<S46HK*#)D235&1%PJ-T-A?25>)E\K.$P]-U
MX_-&)Y2DA;25Q-3D]*6UQ=7E]59F=H:6IK;&UN;V-T=79W>'EZ>WQ]?G]Q$`
M`@(!`@0$`P0%!@<'!@4U`0`"$0,A,1($05%A<2(3!3*!D12AL4(CP5+1\#,D
M8N%R@I)#4Q5C<S3Q)086HK*#!R8UPM)$DU2C%V1%539T9>+RLX3#TW7C\T:4
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
M;G;EJY&-E8N:S#S:V"]Y!I@?H<C:=_ZMO^CD:>_">[U?^XWK5HO5<RG,QA0_
M%<VQC@\/>1[',.[<WV[VN_-10X=?3^F860QW3\9N/976:W/K<XM<UVU_OKLW
M^]FSZ6];/0NAV=5(R+Y9TT<$:.OC\VMWTFXO[]W^'_P/Z+](\G0OJY^T=N7F
MM(Z?S74=#D=][_\`NE^Y_P!R_P#PK_2^R`#0&M$`:`#@!)2S&,K8VNMH8Q@#
M6M:(``T:UK0I))()4DDDDI__UO54DDDE*22224BR*&WU&MVG=KAR".'!46]*
M>+-VY@@$2`?SB-[MGYKG;?WUII)*:^-A58[6@2XL&UI/8#P5A)))2DDDDE*2
M2224@S<'$S\=V-F5-OI?RQXG4<.;^X]OYCV>]BRJ_J?TD7BVY^1E-;JVG(N?
M97H9&YCC^E;_`"+O4K6XDDI22222E))))*4DDDDI_]?U5))))2DDDDE*2222
M4I))))2DDDDE*22224I))))2DDDDE*22224I))))3__0]522224I))))2DDD
MDE*22224I))))2DDDDE*22224I))))2DDDDE*22224__V?_B`D!)0T-?4%)/
M1DE,10`!`0```C!!1$)%`A```&UN=')21T(@6%E:(`?/``8``P```````&%C
M<W!!4%!,`````&YO;F4````````````````````!``#VU@`!`````-,M041"
M10``````````````````````````````````````````````````````````
M````"F-P<G0```#\````,F1E<V,```$P````:W=T<'0```&<````%&)K<'0`
M``&P````%')44D,```'$````#F=44D,```'4````#F)44D,```'D````#G)8
M65H```'T````%&=865H```((````%&)865H```(<````%'1E>'0`````0V]P
M>7)I9VAT(#$Y.3D@061O8F4@4WES=&5M<R!);F-O<G!O<F%T960```!D97-C
M`````````!%!9&]B92!21T(@*#$Y.3@I````````````````````````````
M````````````````````````````````````````````````````````````
M``````````````````!865H@````````\U$``0````$6S%A96B``````````
M````````````8W5R=@`````````!`C,``&-U<G8``````````0(S``!C=7)V
M``````````$",P``6%E:(````````)P8``!/I0``!/Q865H@````````-(T`
M`*`L```/E5A96B`````````F,0``$"\``+Z<_^T`NE!H;W1O<VAO<"`S+C``
M.$))300$``````"='`%:``,;)4<<`@```@`"'`)0``U2;V)E<G0@2VET=&5L
M'`(W``@R,#`V,#<R,!P"/``+,3,Q-#`T*S`R,#`<`G0`6L*I(%)O8F5R="!+
M:71T96P@XH"3($%L;&4@4F5C:'1E('9O<F)E:&%L=&5N+"!A;&P@<FEG:'1S
M(')E<V5R=F5D+"!4;W5S(&1R;VET<R!RPZES97)VPZES+@#_X1"&:'1T<#HO
M+VYS+F%D;V)E+F-O;2]X87`O,2XP+P`\/WAP86-K970@8F5G:6X](N^[OR(@
M:60](E<U33!-<$-E:&E(>G)E4WI.5&-Z:V,Y9"(_/B`\>#IX;7!M971A('AM
M;&YS.G@](F%D;V)E.FYS.FUE=&$O(B!X.GAM<'1K/2)!9&]B92!835`@0V]R
M92`U+C8M8S`V-R`W.2XQ-3<W-#<L(#(P,34O,#,O,S`M,C,Z-#`Z-#(@("`@
M("`@("(^(#QR9&8Z4D1&('AM;&YS.G)D9CTB:'1T<#HO+W=W=RYW,RYO<F<O
M,3DY.2\P,B\R,BUR9&8M<WEN=&%X+6YS(R(^(#QR9&8Z1&5S8W)I<'1I;VX@
M<F1F.F%B;W5T/2(B('AM;&YS.GAM<#TB:'1T<#HO+VYS+F%D;V)E+F-O;2]X
M87`O,2XP+R(@>&UL;G,Z9&,](FAT='`Z+R]P=7)L+F]R9R]D8R]E;&5M96YT
M<R\Q+C$O(B!X;6QN<SIX;7!-33TB:'1T<#HO+VYS+F%D;V)E+F-O;2]X87`O
M,2XP+VUM+R(@>&UL;G,Z<W12968](FAT='`Z+R]N<RYA9&]B92YC;VTO>&%P
M+S$N,"]S5'EP92]297-O=7)C95)E9B,B('AM;&YS.G-T179T/2)H='1P.B\O
M;G,N861O8F4N8V]M+WAA<"\Q+C`O<U1Y<&4O4F5S;W5R8V5%=F5N=",B('AM
M;&YS.G!H;W1O<VAO<#TB:'1T<#HO+VYS+F%D;V)E+F-O;2]P:&]T;W-H;W`O
M,2XP+R(@>&UL;G,Z>&UP4FEG:'1S/2)H='1P.B\O;G,N861O8F4N8V]M+WAA
M<"\Q+C`O<FEG:'1S+R(@>&UP.DUO9&EF>41A=&4](C(P,38M,#8M,C)4,30Z
M,#8Z-#@K,#(Z,#`B('AM<#I#<F5A=&5$871E/2(R,#`V+3`W+3(P5#$S.C$T
M.C`T(B!X;7`Z365T861A=&%$871E/2(R,#$V+3`V+3(R5#$T.C`V.C0X*S`R
M.C`P(B!X;7`Z0W)E871O<E1O;VP](D%D;V)E(%!H;W1O<VAO<"!#4S(@36%C
M:6YT;W-H(B!D8SIF;W)M870](FEM86=E+VIP96<B('AM<$U-.D1O8W5M96YT
M240](F%D;V)E.F1O8VED.G!H;W1O<VAO<#HS.3`U.6,X.2TW.3`P+3$Q-SDM
M8C0P-BUD.65A9#<V-V%B8S<B('AM<$U-.DEN<W1A;F-E240](GAM<"YI:60Z
M9#)F-&(X,&8M.64S,BTT860V+3DR8C$M.&-F-60U-V0Q.&4Y(B!X;7!-33I/
M<FEG:6YA;$1O8W5M96YT240](G5U:60Z.3@P04(Q,C<R,C<U,3%$0CDU.31"
M13,T03!"144T-40B('!H;W1O<VAO<#I,96=A8WE)4%1#1&EG97-T/2)&,D)&
M-T(V.3,S0T4X140S14%%138U.41!-C,T-3$R-R(@<&AO=&]S:&]P.D1A=&5#
M<F5A=&5D/2(R,#`V+3`W+3(P5#$S.C$T.C`T*S`R.C`P(B!P:&]T;W-H;W`Z
M0V]L;W)-;V1E/2(S(B!P:&]T;W-H;W`Z24-#4')O9FEL93TB061O8F4@4D="
M("@Q.3DX*2(@>&UP4FEG:'1S.DUA<FME9#TB5')U92(^(#QD8SIC<F5A=&]R
M/B`\<F1F.E-E<3X@/')D9CIL:3Y2;V)E<G0@2VET=&5L/"]R9&8Z;&D^(#PO
M<F1F.E-E<3X@/"]D8SIC<F5A=&]R/B`\9&,Z<FEG:'1S/B`\<F1F.D%L=#X@
M/')D9CIL:2!X;6PZ;&%N9STB>"UD969A=6QT(C["J2!2;V)E<G0@2VET=&5L
M(.*`DR!!;&QE(%)E8VAT92!V;W)B96AA;'1E;BP@86QL(')I9VAT<R!R97-E
M<G9E9"P@5&]U<R!D<F]I=',@<L.I<V5R=L.I<RX\+W)D9CIL:3X@/"]R9&8Z
M06QT/B`\+V1C.G)I9VAT<SX@/'AM<$U-.D1E<FEV961&<F]M('-T4F5F.FEN
M<W1A;F-E240](G5U:60Z,3!%,3=%1$4Q0C-",3%$0C@X,#<Y131$03`T.#-!
M,T(B('-T4F5F.F1O8W5M96YT240](G5U:60Z,CE!-#`S,C8Q0C,Y,3%$0C@X
M,#<Y131$03`T.#-!,T(B+SX@/'AM<$U-.DAI<W1O<GD^(#QR9&8Z4V5Q/B`\
M<F1F.FQI('-T179T.F%C=&EO;CTB<V%V960B('-T179T.FEN<W1A;F-E240]
M(GAM<"YI:60Z.3<S,S(T934M-S,S-2TT8CDU+6(T9&4M8S<S,S(P-C,Y9#AE
M(B!S=$5V=#IW:&5N/2(R,#$V+3`V+3(R5#$T.C`V.C0X*S`R.C`P(B!S=$5V
M=#IS;V9T=V%R94%G96YT/2)!9&]B92!0:&]T;W-H;W`@0T,@,C`Q-2`H36%C
M:6YT;W-H*2(@<W1%=G0Z8VAA;F=E9#TB+R(O/B`\<F1F.FQI('-T179T.F%C
M=&EO;CTB<V%V960B('-T179T.FEN<W1A;F-E240](GAM<"YI:60Z9#)F-&(X
M,&8M.64S,BTT860V+3DR8C$M.&-F-60U-V0Q.&4Y(B!S=$5V=#IW:&5N/2(R
M,#$V+3`V+3(R5#$T.C`V.C0X*S`R.C`P(B!S=$5V=#IS;V9T=V%R94%G96YT
M/2)!9&]B92!0:&]T;W-H;W`@0T,@,C`Q-2`H36%C:6YT;W-H*2(@<W1%=G0Z
M8VAA;F=E9#TB+R(O/B`\+W)D9CI397$^(#PO>&UP34TZ2&ES=&]R>3X@/"]R
M9&8Z1&5S8W)I<'1I;VX^(#PO<F1F.E)$1CX@/"]X.GAM<&UE=&$^("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`@("`@("`@("`@/#]X<&%C:V5T(&5N9#TB=R(_/O_;`$,`!@0$
M!00$!@4%!08&!@<)#@D)"`@)$@T-"@X5$A86%1(4%!<:(1P7&!\9%!0=)QT?
M(B,E)246'"DL*"0K(20E)/_;`$,!!@8&"0@)$0D)$208%!@D)"0D)"0D)"0D
M)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)/_``!$(
M`:`!H`,!$0`"$0$#$0'_Q``<``$``@,!`0$`````````````!08#!`<"`0C_
MQ``_$``!`P,"!`,%!P(&`00#```!``(#!`41$B$&,4%1$R)A!Q1Q@9$R0E*A
ML<'1%2,6,V)RX?#Q)#1#@E.#PO_$`!8!`0$!```````````````````!`O_$
M`!81`0$!```````````````````!$?_:``P#`0`"$0,1`#\`_5*`@("`@("`
M@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`
M@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`
M@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`
M@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`
M@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`
M@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`
M@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`
M@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`
M@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`
M@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`
M@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`
M@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`
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
MY_+I="X$.:[8<MN6_-!]I)G.KW4E,T>[T[<2OR3_`'#N&CY;GY(,EUGDIXFL
M9(8FN_S)B,B)O?MD]$&[X893Z0]P<UN!(=W9QS]2@D;'9'")IDDE?$27ETA\
MTA)R?@$%C:T,:&M``'(!17U`0$!`0$!`0$!`0$!!6.-.`[?QC2?W`*>OC!\&
MJ:-V^COQ-]$')VUU\]G\W](XAM_O5$XD1ZW9:1WC?_\`R5IEBK.*>'GN<Z%M
M7">8:]HP/F@C).):35Y!*]SL!N&Y+CZ#*J.D<`>SJ2:6._<0P:9,A]-0OW$?
M9[Q^+TZ?'EFUJ1T]11`0$!`0$!`0$!`0$!`0$!`0$!`0$!`0$!`01EYLS;FQ
MLD;A%4Q_8DQM\#Z((":EJ*7RU-/)'C[PW;\B%48*>C<R4NA$C@1COU[=_5!O
M-L,]:YCY*9OD.6NE^Z>^$$S1V2*`A\SC,\=#]D?)14ER0$!`0$!`0$!`0$!`
M0$!`08*Z@I+E3OIJVFBJ(7C#HY6AP/U04^K]C/!E6XN-NEBR<XBJ'M'TSA-3
M$KP_[/N&N&'^+;;7$R;_`/-(3(\?!SB2/DBK$@("`@("`@("`@("`@("`@("
M`@("`@("`@("`@("``!R"`@("`@("`@("`@("`@("`@("`@("`@("`@("`@(
M"`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@(
M"`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@(
M"`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@(
M"`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@(
M"`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@(
M"`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@(
M"`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@(
M"`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@(
M"`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@(
M"`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@(
M"`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@(
M"`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@(
M"`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@(
M"`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@(
M"`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@("`@(
,"`@("`@("`@(/__9




#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS">
        <int nm="BREAKPOINT" vl="494" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12270: add property &quot;Orientation Drill&quot; no/yes" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="7/21/2021 3:24:10 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12270: add property offset" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="7/21/2021 1:28:59 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12397: separate TSL instance for the representation of male part" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="6/27/2021 8:08:10 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12397: part can be aligned at a face in X direction" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="6/24/2021 6:11:40 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11913: initial" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="6/1/2021 6:29:15 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End