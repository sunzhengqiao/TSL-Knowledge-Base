#Version 8
#BeginDescription
#Versions:
5.7 30/10/2024 Add grid reference offset Author: Robert Pol
5.6 07.12.2022 HSB-17142: Fix orientation of description
5.5 10/08/2021 Add option to use the real body of the beams in zone 0 
Version5.4 18-6-2021 Add option to dimension only points within a certain range.

This tsl places dimension lines around an element. Several parts of the element can be dimensioned.






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 5
#MinorVersion 7
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl places dimension lines around an element. Several parts of the element can be dimensioned.
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="5.04" date="18.06.2021"></version>
// #Versions:
//5.7 30/10/2024 Add grid reference offset Author: Robert Pol
// 5.6 07.12.2022 HSB-17142: Fix orientation of description Author: Marsel Nakuci
//5.5 10/08/2021 Add option to use the real body of the beams in zone 0 Author: Robert Pol
/// <history>
/// AS - 1.00 - 03.03.2004 -	First revision
/// AS - 2.00 - 03.04.2008 -	If no points added on tsl dim: return;
/// AS - 2.01 - 29.08.2008 -	Store available list of tsl's in _Map
/// AS - 2.02 - 01.12.2008 -	Add side dimensioning for beamcode dimensioning, Add rafters as a reference, Make it case-insensitive
/// AS - 2.03 - 17.02.2010 -	Add property for readdirection
/// AS - 2.04 - 17.02.2010 -	Add option for specials
/// AS - 2.05 - 04.06.2010 -	Hide dimline if there are no points for beamcode dimensioning found (only when dimensionObject is set to DimBeamCodes)
/// AS - 2.06 - 08.06.2010 -	Add link to the HSB-Section (PS) tsl.
/// AS - 2.07 - 01.09.2010 -	Update perimeter dimensioning
/// AS - 2.08 - 17.11.2010 -	Use envelopeBody insetad of realBody (if possible)
/// AS - 2.09 - 13.07.2011 -	Add check if tsl is valid before using it
/// AS - 2.10 - 15.07.2011 -	Add vadeko special
/// AS - 2.11 - 19.07.2011 -	Add option to skip dimension of first grip
/// AS - 2.12 - 15.09.2011 -	Add element filters
/// AS - 2.13 - 19.10.2011 -	Change visualisation when filter is active
/// AS - 2.14 - 25.10.2011 - 	Update filter
/// AS - 2.15 - 01.11.2011 - 	Set scale of viewport to a value with no decimals.
/// AS - 2.16 - 02.11.2011 - 	Continue if tsl is invalid
/// AS - 2.17 - 07.11.2011 - 	Add a regen to the commandstack after the scale is changed.
/// AS - 2.18 - 15.11.2011 - 	Adjust colors
/// AS - 2.19 - 22.11.2011 - 	Add option to switch between points at sheet joints and all sides.
/// AS - 3.00 - 25.11.2011 - 	Reorganize properties, add automatic mode.
/// AS - 3.01 - 28.11.2011 - 	Support wildcards for filters.
/// AS - 3.02 - 30.11.2011 - 	Improve automatic mode. Increase the possible objects to dimension
/// AS - 3.03 - 30.11.2011 - 	Solve bug on reference point 
/// AS - 3.04 - 08.12.2011 - 	Use realbody for reference points
/// AS - 3.05 - 14.12.2011 - 	Add option to dim side rafters
/// AS - 3.06 - 10.01.2012 - 	Add support for different kind of section tsls
/// AS - 3.07 - 12.01.2012 - 	Set dependency on section tsl
/// AS - 3.08 - 24.01.2012 - 	Add special IF (inside frame as extra dimpoints), add option to dimension only extremes of a zone.
/// AS - 3.09 - 25.01.2012 - 	Only show during label/name dim if there are beams with the specified label
/// AS - 3.10 - 26.01.2012 - 	Add special 'Face'. This dimensions the face for beamcode dimensioning
/// AS - 3.11 - 30.01.2012 - 	Bugfix on position for dimension beamcode with range.
/// AS - 3.12 - 08.02.2012 - 	Add option to seperate reference dimensions
/// AS - 3.13 - 27.02.2012 -	Add option to offset in paperspace units
/// AS - 3.14 - 08.03.2012 -	Add dimension options
/// AS - 3.15 - 16.03.2012 -	Correct bug on calculation of element length and element height
/// AS - 3.16 - 16.03.2012 -	Add material as filter
/// AS - 3.17 - 11.04.2012 -	Offset text corrected
/// AS - 3.18 - 17.04.2012 -	Add filter for hsbId
/// AS - 3.19 - 20.04.2012 -	Add text options to reference dimensions
/// AS - 3.20 - 20.04.2012 -	Only get genbeams from element once.
/// AS - 3.21 - 22.05.2012 -	Rafters as reference are now also reacting on side property
/// AS - 3.22 - 22.05.2012 -	Add property to specify the minimum distance allowed between dim points.
/// AS - 3.23 - 23.05.2012 -	Only take tsls with grip in section into account (only if used in combination with section)
/// AS - 3.24 - 02.07.2012 -	Make available for shopdrawings. Update perimeter dimension
/// AS - 3.25 - 04.07.2012 -	Regroup properties
/// AS - 3.26 - 09.07.2012 -	Add automatic position for walls
/// AS - 3.27 - 17.07.2012 -	Add option to combine beams for zone dimensioning. Add option to ignore side beams for zone dimensioning.
/// AS - 3.28 - 12.09.2012 -	Add filter for zones. Perimeter dimensioning improved.
/// AS - 3.29 - 18.09.2012 -	Only remove side beams if they are in a range of 100 mm to the edge.
/// AS - 3.30 - 04.10.2012 -	Add bmCode as reference option.
/// AS - 3.31 - 12.10.2012 -	Order beamtypes in alphabetic order; correct indexes of props
/// AS - 3.32 - 29.10.2012 -	Fix bug on auto dimension.
/// AS - 3.33 - 01.11.2012 -	Fix bug on dimension of side rafters/studs
/// AS - 3.34 - 06.11.2012 -	Return if nr of dimpoints is 0.
/// AS - 3.35 - 06.11.2012 -	Special BR-01 added.
/// AS - 3.36 - 14.11.2012 -	Change special 'Face' behaviour.
/// AS - 3.37 - 04.12.2012 -	Add properties for name and extra description. Sort dimension styles
/// AS - 3.38 - 19.12.2012 -	Tolerance changed for perimeter dimensions
/// AS - 3.39 - 10.01.2013 -	Ingnore single points and sheet joints dimensioning improved for zone dimension
/// AS - 3.40 - 10.01.2013 -	Add special "ElementOutline". This uses the element outline to calculate the extremes of the element.
/// AS - 3.41 - 16.01.2013 -	Special "Face" adjusted. It takes all points of the face when side is set to left&right.
/// AS - 3.42 - 17.01.2013 -	Add zone support for tsl dimensioning
/// AS - 3.43 - 29.01.2013 -	Add opening to module filter
/// AS - 3.44 - 07.02.2013 -	If dim is cummulative set ref point as first point in the list of points.
/// AS - 3.45 - 08.02.2013 -	Support left&right dim for element as reference
/// AS - 3.46 - 11.02.2013 -	Add hsbID 60 as stud for the stud/rafter dimension
/// AS - 3.47 - 13.02.2013 -	Add property to apply stud/rafter dim to specified zone. Use planeprofile for stud/rafter dimension
/// AS - 3.48 - 14.02.2013 -	Correct position of description (broken after change 3.44)
/// AS - 3.49 - 27.02.2013 -	Add beamtypes for stud/rafter dimensions
/// AS - 3.50 - 27.02.2013 -	Add specials InsideOpening & InsideOpening2
/// AS - 3.51 - 06.03.2013 -	Make use of viewport scale optional
/// AS - 3.52 - 27.03.2013 -	Add option to specify multiple specials
/// AS - 3.53 - 09.04.2013 -	Beamcode dim: take extremes of beam which are angled
/// AS - 3.54 - 09.04.2013 -	Add diminfo
/// AS - 3.55 - 01.05.2013 -	Add mapX data for perimeter dim
/// AS - 3.56 - 07.05.2013 -	Add special 'ExtraBeamCodes'
/// AS - 3.57 - 08.05.2013 -	Add option to dimension beams with hsbID
/// AS - 3.58 - 14.05.2013 -	Add beamcode in range as reference object
/// AS - 3.59 - 15.05.2013 -	Make it compatible with hsbCAD2011 again.
/// AS - 3.60 - 05.06.2013 -	Add id's to list of studs/rafters
/// AS - 3.61 - 13.06.2013 -	Tsl will be dimensioned if scriptname is added to the 'Special' property.
/// AS - 3.62 - 02.07.2013 -	Revise perimeter dimension
/// AS - 3.63 - 13.08.2013 -	Add grid and half grid as reference objects.
/// AS - 3.64 - 10.09.2013 -	Decrease shrink on rafter dimension, add BC-Back as special for the beamcode dimensioning.
/// AS - 3.65 - 10.09.2013 -	Improve special BC-Back.
/// AS - 3.66 - 11.09.2013 -	Sort reference points too, automatic side is working again.
/// AS - 3.67 - 09.10.2013 -	Check vector direction for rafter alignment with a tollerance.
/// AS - 3.68 - 23.10.2013 -	Project points to edge of element. Add option to combine touching rafters.
/// AS - 3.69 - 24.10.2013 -	Correct some typos. Add option to show the viewport outline, used for debugging and template setup. Add option to disable the tsl.
/// AS - 3.70 - 06.11.2013 -	Add grid as dimension object
/// AS - 3.71 - 26.11.2013 -	Add option to use all points from perimeter and not just the extremes
/// AS - 3.72 - 12.12.2013 -	Autoside detection now also working for walls. Sort points before description is added.
/// AS - 3.73 - 24.01.2014 -	Rafter dimension accuracy problem solved. Shrink - deshrink plane profile.
/// AS - 3.74 - 24.01.2014 -	Also rotate profile a little bit.
/// AS - 3.75 - 04.02.2014 -	Also take last gridline into account.
/// AS - 3.76 - 18.02.2014 -	Bugfix supporting beam dimensions
/// AS - 3.77 - 12.03.2014 -	Improve performance
/// AS - 3.78 - 04.04.2014 -	Extend options for extension lines. They can now be placed to side of the element, to the object or not at all.
/// AS - 3.79 - 08.04.2014 -	Correct delta position in automatic mode
/// AS - 3.80 - 08.04.2014 -	Perimeter dimension now shrinks and deshrinks its profile io the other way around. 
/// AS - 3.81 - 11.04.2014 -	Beampacks for zonedimension corrected.
/// AS - 3.82 - 18.04.2014 -	Correct side for beamcode dimension, add options for side delta dimension
/// AS - 3.83 - 07.05.2014 -	Add option to dimension connecting elements.
/// AS - 3.84 - 20.05.2014 -	Add element outline as reference
/// AS - 3.85 - 02.06.2014 -	Add support for connecting log elements.
/// AS - 3.86 - 07.07.2014 -	Rotate rafter profiles over element origin before joining them.
/// AS - 3.87 - 15.10.2014 -	Add inside frame as reference as a toggle
/// AS - 3.88 - 20.10.2014 -	Use realbody of beams at beamcode dim io collectDimPoints.
/// AS - 3.89 - 17.11.2014 -	Perimeter entities uses the vertices of the body.
/// AS - 3.90 - 20.11.2014 -	Add special "HSB-TILELATH-01": Add delta dims of tile laths to dimline.
/// AS - 3.91 - 20.11.2014 -	Create profile from entities in zone for perimeter dimension.
/// AS - 3.92 - 05.02.2015 -	Add supporting beams as valid stud type
/// AS - 3.93 - 25.02.2015 -	Add subtype as a dimension option for tsl dimensions. (FogBugzId 848)
/// AS - 3.94 - 10.03.2015 -	Add support for multiple dimInfo maps when dimensioning tsl's (FogBugzId 914)
/// AJ - 3.95 - 17.03.2015 -	Changed Body bdGBm = gBm.envelopeBody(false, true);//realBody(); because it was giving the wrong dimension when profile beams were used.
/// AS - 3.96 - 08.04.2015 -	Compare vectors for zone dimension with a tolerance.
/// AS - 3.97 - 16.04.2015 -	Check DimInfo of tsl before adding grippoints as dimpoints (FogBugzId 1053).
///							Add LeftStud and RightStud as valid studtypes for stud dimensioning.
/// AS - 3.98 - 24.04.2015 -	Center of objects can now also be set as reference. (FogBugzId 930)
/// AS - 3.99 - 01.05.2015 -	Add 'Panels' as dimension objects (FogBugzId 1219).
/// AS - 4.00 - 13.05.2015 -	Dont allow tsl to be dimensioned if dimrestrictions are set but not available in the tsl to dim.
/// AS - 4.01 - 08.06.2015 -	Check extrems oif vp for grid intersection. (FogBugzId 987)
/// AS - 4.02 - 08.06.2015 -	Perimeter dimension now uses z of viewport transformed to model. (FogBugzId 1043)
/// AS - 4.03 - 25.06.2015 -	Add specials for VKP. 
///							Special: 'Extremes' in combination with supporting beams will dimension the extremes of the supporting beams.
///							Special: 'STKR' adds the dimension from the STKR beam to the first tile lath.
/// AJ - 4.04 - 05.08.2015 -	Add option to not show description
/// AS - 4.05 - 28.08.2015 -	Add outside frame as reference as option.
/// AS - 4.06 - 07.10.2015 -	Add option to dimension rafters on the inside.
/// AS - 4.07 - 09.11.2015 -	Take ptCenSolid instead of ptCen from beams when dimensioning rafters.
/// AS - 4.08 - 15.12.2015 -	Bugfix tsl dimension when using multiple subtypes in dimension info. Add wall icon as reference object.
/// AS - 4.09 - 11.01.2016 -	Add option to merge sheets for zone dimensions
/// AS - 4.10 - 12.01.2016 -	Add extra rafter as rafter type.
/// AS - 4.11 - 12.01.2016 -	Use profShape from sheet for combining sheets in zone dimensioning.
/// AS - 4.12 - 18.01.2016 -	Extend tsl dimensioning. Grips can now be ignored. Perpendicular added as subtype for tsl dimensioning.
/// AS - 4.13 - 09.03.2016 -	Correct extension lines for seperated reference dimensions.
/// AS - 4.14 - 30.06.2016 -	Add first version of tool dimensioning. Drills are available.
/// AS - 4.15 - 31.08.2016 -	Add perimeter as reference.
/// AS - 4.16 - 11.11.2016 -	Add "ZONE" as special to add that object as extra dimension object.
/// AS - 4.17 - 18.11.2016 -	Allow center dimension for tsl objects.
/// AS - 4.18 - 05.12.2016 -	Correct counter in tool dimension
/// AS - 4.19 - 08.12.2016 -	Check length of beam array for dimensioning side beams at zone dimension.
/// AS - 4.20 - 08.12.2016 -	Use the normalized sort vectors
/// AS - 4.21 - 21.02.2017 -	Only add dimpoints from map if it has a matching zone index or subtype, or if there was no zone index and subtype set in the map and there were no zone index and subtype set as property.
/// AS - 4.22 - 04.03.2017 -	Add option to use realbody of reference beam
/// YB - 4.23 - 19.04.2017 - 	Add option to measure beamcuts.
/// AS - 4.24 - 12.05.2017 - 	Take zone profiles for element points if there are no genbeams present
/// AS - 4.25 - 12.05.2017 - 	Add 'W_knieschot goten' special for Groothuis.
/// AS - 4.26 - 12.05.2017 - 	Add option to exclude openings from perimeter dimension.
/// AS - 4.27 - 22.05.2017 - 	Add option to select a panel index to dimension.
/// AS - 4.28 - 08.06.2017 - 	Add option for minimum beamcut depth
/// AS - 4.29 - 15.06.2017 - 	First attempt to position the tsl based on the dimension object.
/// AS - 4.30 - 15.06.2017 - 	Add panel, with component index, as reference object.
/// AS - 4.31 - 16.06.2017 - 	Add component face and extremes for panel dimension.
/// YB - 4.32 - 06.07.2017 - 	Get reference position from property set if possible.
/// AS - 4.33 - 25.07.2017 - 	Extend usage of property set as reference
/// AS - 4.34 - 04.09.2017 - 	Add a range property to perimeter dimensions.
/// AS - 4.35 - 14.09.2017 - 	Enable positioning by object for tsl's.'
/// AS - 4.36 - 03.10.2017 - 	Default object points to dimension points.
/// AS - 4.37 - 07.03.2018 - 	Add support for affected zones on dimension tsl. Used in combination with installation point.
/// AS - 4.38 - 15.06.2018 - 	Add drill diameters as description next to line.
/// AS - 4.39 - 13.07.2018 - 	Correct perimeter dimension.
/// AS - 4.40 - 13.07.2018 - 	No longer rotate genbeams when building plane profiles.
/// RP - 4.41 - 19.09.2018 - 	Use extreme points of body when dimensioning zone and none of the vecD of the beam is aligned with the dimension line. 
/// DR - 4.42 - 26.10.2018 - 	Property added: <Include non perpendicular to dimension line>, collects points from beams not perpendicular
/// DR - 4.43 - 30.10.2018 - 	Avoided usage of Array.last() for older versions compatibility
/// RP - 4.44 - 22.11.2018 - 	Change beamcode for customer special ticket 2923858 VKP
/// AS - 4.45 - 15.03.2019 - 	Add basic support for trusses
/// AS - 4.46 - 15.04.2019 - 	Correct internal and external face dimensioning of full panel.
/// AS - 4.47 - 15.04.2019 - 	Extremes inside and outside full panel corrected.
/// RP - 4.48 - 11.06.2019 - 	Use planeProfile for perimeter not with el cs, but vp coordsys
/// RP - 5.00 - 14.11.2019 - 	Add categories and add compentenindexes as a string to support multiple components
/// RP - 5.01 - 13.02.2020 - 	Set missing categories and check for dimpoints on zone per genbeam (solves tolerance issue)
/// AS - 5.02 - 21.07.2020 - 	Add option to dimension multiple perimeters
/// RP - 5.03 - 04.03.2021 - 	Add option to not dimension points outside the reference boundary
///Rvw- 5.04 - 18.06.2021 -		Add option to dimension only points within a certain range.
/// </history> 

// "HSB-TILELATH-01": Add delta dims of tile laths to dimline

//PropString Index = 89 is used (v4.38)
double dEps = U(0.01,"mm"); // script uses mm
double dEpsScale = U(0.0001);
double dEpsDeltaDim = U(.4);

String category = T("|General|");

double vectorTolerance = U(0.01);

String arSDimStylesSorted[0];
arSDimStylesSorted.append(_DimStyles);
for(int s1=1;s1<arSDimStylesSorted.length();s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		String sA = arSDimStylesSorted[s11];
		sA.makeUpper();
		String sB = arSDimStylesSorted[s2];
		sB.makeUpper();
		if( sA < sB ){
			arSDimStylesSorted.swap(s2, s11);
			s11=s2;
		}
	}
}

String arSBmTypesSorted[0];
arSBmTypesSorted.append(_BeamTypes);
for(int s1=1;s1<arSBmTypesSorted.length();s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		if( arSBmTypesSorted[s11] < arSBmTypesSorted[s2] ){
			arSBmTypesSorted.swap(s2, s11);
			s11=s2;
		}
	}
}

if (_bOnInsert) {
	category =  T("|Space|");
	String sPaperSpace = T("|Paper space|");
	String sShopdrawSpace = T("|Shopdraw multipage|");
	String sArSpace[] = {sPaperSpace , sShopdrawSpace };
	PropString sSpace(43,sArSpace,T("|Drawing space|"));
	sSpace.setCategory(category);
	
	showDialog();
	_Pt0 = getPoint(T("|Select location|"));

	if (sSpace==sPaperSpace){
		Viewport vp = getViewport(T("|Select the viewport|")); // select viewport
		_Viewport.append(vp);
	}
	else if (sSpace==sShopdrawSpace){
		Entity ent = getShopDrawView(T("|Select the view entity|")); // select ShopDrawView
		_Entity.append(ent);
	}

//	Viewport vp = getViewport(T("|Select a viewport|")); // select viewport
//	_Viewport.append(vp);
}

//Space
category =  T("|Selected space|");
String sPaperSpace = T("|Paper space|");
String sShopdrawSpace = T("|Shopdraw multipage|");
String sArSpace[] = {sPaperSpace , sShopdrawSpace };
PropString sSpace(43,sArSpace,T("|Selected drawing space|"));
sSpace.setCategory(category);


// determine the space type depending on the contents of _Entity[0] and _Viewport[0]
if (_Viewport.length()>0)
	sSpace.set(sPaperSpace);
else if (_Entity.length()>0 && _Entity[0].bIsKindOf(ShopDrawView()))
		sSpace.set(sShopdrawSpace);
else {
	eraseInstance(); // this Tsl not allowed to be appended to model space
	return;
}
sSpace.setReadOnly(true);


int bError = 0; // 0 means FALSE = no error
// set of variables that change depending on the type of space
CoordSys ms2ps; // default to identity transformation
Element el;
Point3d ptVpLeft;
Point3d ptVpRight;
Point3d ptVpBottom;
Point3d ptVpTop;
String sVpHandle = "Invalid";
if( sSpace==sShopdrawSpace ){
	ShopDrawView sv;
	if (_Entity.length()>0)
		sv = (ShopDrawView)_Entity[0];
	if (!bError && !sv.bIsValid())
		bError = 1;
	
	// interprete the list of ViewData in my _Map
	ViewData arViewData[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
	int nIndFound = ViewData().findDataForViewport(arViewData, sv);// find the viewData for my view
	if (!bError && nIndFound<0)
		bError = 2; // no viewData found
	if (!bError) {
		ViewData vwData = arViewData[nIndFound];
		ms2ps = vwData.coordSys(); // transformation to view
		Entity arEnt[] = vwData.showSetDefineEntities();
		
		for( int i=0;i<arEnt.length();i++ ){
			Entity ent = arEnt[i];
			Element elInView = (Element)ent;
			if( elInView.bIsValid() ){
				el = elInView;
				break;
			}
		}
		
		ptVpLeft = vwData.ptCenPS() - _XW * 0.5 * vwData.widthPS();
		ptVpRight = vwData.ptCenPS() + _XW * 0.5 * vwData.widthPS();
		ptVpBottom = vwData.ptCenPS() - _YW * 0.5 * vwData.heightPS();
		ptVpTop = vwData.ptCenPS() + _YW * 0.5 * vwData.heightPS();

	}
}
// If it is a viewport
else if( sSpace==sPaperSpace ){
	//Is there a viewport selected?
	if( !bError && _Viewport.length()==0 )
		bError = 3;
	
	//get the selected viewport
	if( !bError ){
		Viewport vp = _Viewport[0];
		el = vp.element();
		if( !el.bIsValid() )
			bError = 4;// no hsbData attached to viewport.
		ms2ps = vp.coordSys();
		sVpHandle = vp.viewData().viewHandle();
		
		ptVpLeft = vp.ptCenPS() - _XW * 0.5 * vp.widthPS();
		ptVpRight = vp.ptCenPS() + _XW * 0.5 * vp.widthPS();
		ptVpBottom = vp.ptCenPS() - _YW * 0.5 * vp.heightPS();
		ptVpTop = vp.ptCenPS() + _YW * 0.5 * vp.heightPS();
	}
}

ptVpLeft.vis(1);
ptVpRight.vis(1);
ptVpBottom.vis(1);
ptVpTop.vis(1);

// do something for the last appended viewport only
//if( _Viewport.length()==0 ){
//	eraseInstance();
//	return;
//}
//Viewport vp = _Viewport[0];
//Element el = vp.element();

Map mapTslScriptNames = _Map.getMap("ScriptNames");
//mapTslScriptNames = Map();
if( mapTslScriptNames.length() == 0 ){
	mapTslScriptNames.setString("All", "All");
}
TslInst arTsl[0];
if( el.bIsValid() )
	arTsl.append(el.tslInst());

for( int i=0;i<arTsl.length();i++){
	TslInst tsl = arTsl[i];
	if( !tsl.bIsValid() )
		continue;
	
	String sScriptName = tsl.scriptName();
	
	if( !mapTslScriptNames.hasString(sScriptName) ){
		mapTslScriptNames.setString(sScriptName, sScriptName);
	}
}
_Map.setMap("ScriptNames", mapTslScriptNames);

String arSTsl[0];
for( int i=0;i<mapTslScriptNames.length();i++ ){
	arSTsl.append(mapTslScriptNames.getString(i));
}


String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

int arZone[]={10,9,8,7,6,0,1,2,3,4,5};

String arSSectionName[0];
Entity arEntTsl[] = Group().collectEntities(true, TslInst(), _kMySpace);
for( int i=0;i<arEntTsl.length();i++ ){
	TslInst tsl = (TslInst)arEntTsl[i];
	if( !tsl.bIsValid() )
		continue;
	Map mapTsl = tsl.map();
	String vpHandle = mapTsl.getString("VPHANDLE");
	if( vpHandle == "" )
		continue;
	if( arSSectionName.find(tsl.scriptName()) == -1 )
		arSSectionName.append(tsl.scriptName());
}

/// - Filter -
///
category =  T("|Filter|");
String arSFilterType[] = {
	T("|Exclude|")
};
PropString sFilterType(13, arSFilterType,T("|Filter type|"));
sFilterType.setCategory(category);
sFilterType.set(T("|Exclude|"));
PropString sSectionName(27, arSSectionName, T("|Section tsl name|"));
sSectionName.setCategory(category);
PropString sFilterBC(5,"",T("|Filter beams with beamcode|"));
sFilterBC.setCategory(category);
PropString sFilterLabel(6,"",T("|Filter beams and sheets with label|"));
sFilterLabel.setCategory(category);
PropString sFilterMaterial(35,"",T("|Filter beams and sheets with material|"));
sFilterMaterial.setCategory(category);
PropString sFilterHsbID(36,"",T("|Filter beams and sheets with hsbID|"));
sFilterHsbID.setCategory(category);

String arSFilterModule[] = {
	" --- ",
	T("|All modules|"),
	T("|All, except jacks|"),
	T("|All, except center jacks|"),
	T("|Opening modules|"),
	T("|Opening modules, except jacks|"),
	T("|Opening modules, except center jacks|")
};
PropString sFilterModule(33, arSFilterModule, T("|Filter modules|"));
sFilterModule.setCategory(category);
PropString sFilterZone(53, "", T("|Filter zones|"));
sFilterZone.setCategory(category);

/// - Dimension object -
/// 
category =  T("|Dimension Object|");
String sArObject[]={
	T("|Element|"),
	T("|Zone|"),
	T("|TSL|"),
	T("|Perimeter|"),
	T("|Beam with beamcode|"),
	T("|Beams and sheets with label|/")+T("|name|"),
	T("|Supporting beams|"),
	T("|Rafters|/")+T("|studs|"),
	T("|Beams with beamcode within range|"),
	T("|Beams of type|"),
	T("|Beams with ID|"),
	T("|Grid|"),
	T("|Connecting walls|"),
	T("|Panels|"),
	T("|Tools|"),
	T("|Trusses|")
};
PropString sObject(3,sArObject,T("|Dimension object| (DO)"));
sObject.setCategory(category);

category =  T("DO - |Zone|");
PropInt nZn(1,arZone,T("|Zone index|"),5); // index 5 is default
nZn.setCategory(category);
PropString sIgnoreSinglePoints(20, arSYesNo,T("|Ignore single points for sheets|"),1);
sIgnoreSinglePoints.setCategory(category);
sIgnoreSinglePoints.setDescription(T("|This property will be ignored if only the sheet joints are dimensioned|."));
PropString sOnlySheetJoints(58, arSYesNo, T("|Only use sheet joints|"),1);
sOnlySheetJoints.setCategory(category);
PropString sOnlyExtremesOfZone(29, arSYesNo, T("|Only use extremes of zone|"),1);
sOnlyExtremesOfZone.setCategory(category);
PropString sCombineTouchingGenBeams(51, arSYesNo, T("|Combine touching beams and sheets|"),1);
sCombineTouchingGenBeams.setCategory(category);
PropDouble dMergeTolerance(6, U(0.1), T("|Tolerance for combining beams and sheets|"));
dMergeTolerance.setCategory(category);
PropString sDimSideBeams(52, arSYesNo, T("|Dimension beams at the element edge|"),0);
sDimSideBeams.setCategory(category);
PropString useRealBodyOfZoneBeamProp(93, arSYesNo, T("|Use real body of beam|"), 1);
useRealBodyOfZoneBeamProp.setCategory(category);
useRealBodyOfZoneBeamProp.setDescription(T("|Specifies wheter the real body of the beam is used or the envelope body with cuts is used.|"));

category =  T("DO - |TSL|");
PropString sTsl(15,arSTsl,T("|TSL name|"));
sTsl.setCategory(category);
PropString sDimTslOrigin(19, arSYesNo, T("|Dimension origin point of tsl|"));
sDimTslOrigin.setCategory(category);
PropString sDimTslGripPoints(80, arSYesNo, T("|Dimension grip points of tsl|"));
sDimTslGripPoints.setCategory(category);
PropString sDimTslsInZone(59, "", T("|Dimension tsls in zones|"));
sDimTslsInZone.setCategory(category);
sDimTslsInZone.setDescription(T("|Only take tsls into account which are assigned to one of the specified zones.|")+TN("|NOTE|: ")+T("|Not all tsls do support this functionality|"));
PropString sTslSubType(71, "", T("|Dimension tsls with sub types|"));
sTslSubType.setCategory(category);
sTslSubType.setDescription(T("|Only take tsls into account which are of a specified subtype.|")+TN("|NOTE|: ")+T("|Not all tsls do support this functionality|"));

category =  T("DO - |Perimeter|");
PropInt nZnPerimeter(7,arZone,T("|Zone index perimeter|"),5); // index 5 is default
nZnPerimeter.setCategory(category);
PropString additionalPerimeterZoneIndexes(21, "", T("|Additional zone indexes|"));
additionalPerimeterZoneIndexes.setCategory(category);
String arSMapX[] = {T("|Use entities from zone|"), T("|Use profile from zone|"), "MapX.Outline.Inside", "MapX.Outline.Outside"};
PropString sSubMapXPerimeter(63, arSMapX, T("|Perimeter calculated from|"));
sSubMapXPerimeter.setCategory(category);
String perimeterDimensionModes[] = 
{
	T("|Convex hull|"),
	T("|Outline vertices|"),
	T("|Extremes|")
};
PropString perimeterDimensionModeProp(79, perimeterDimensionModes, T("|Perimeter dimension mode|"),1);
perimeterDimensionModeProp.setCategory(category);
PropString perimeterWithOpeningsProp(85, arSYesNo, T("|With openings|"),0);
perimeterWithOpeningsProp.setCategory(category);
PropDouble perimeterRange(9, U(0), T("|Perimeter range|"));
perimeterRange.setCategory(category);
perimeterRange.setDescription(T("|Only points within the specified range are taken into account.|"));

category =  T("DO - |Beam with beamcodes|");
PropString sDimBeamCode(4, "", T("|Beamcodes|"));
sDimBeamCode.setCategory(category);

category =  T("DO - |Beam with labels or names|");
PropString sDimLabel(16, "", T("|Labels or names|"));
sDimLabel.setCategory(category);
PropString sDimLabelIncludeNonPerpendiculars(91, arSYesNo, T("|Include non perpendicular to dimension line|"), 1);
sDimLabelIncludeNonPerpendiculars.setCategory(category);

category =  T("DO - |Rafters|/")+T("|studs|");
PropString sDimSideRafters(26, arSYesNo, T("|Dimension rafters|/")+T("|studs at the element edge|"),1);
sDimSideRafters.setCategory(category);
PropString sUseOnlyRaftersFromZone(60, arSYesNo, T("|Only take rafters|/")+T("|studs from the specified zone|"),1);
sUseOnlyRaftersFromZone.setCategory(category);
PropString sCombineTouchingRafters(66, arSYesNo, T("|Combine touching rafters|"),0);
sCombineTouchingRafters.setCategory(category);
PropString sDimRaftersInsideFrame(72, arSYesNo, T("|Dimension rafters on the inside of the frame|"),1);
sDimRaftersInsideFrame.setCategory(category);

category =  T("DO - |Beams with beamcodes within range|");
PropDouble dRange(2, U(0), T("|Range|"));
dRange.setCategory(category);
dRange.setDescription(T("|Only entities within this range are taken into account.|"));
PropString sDimPointsWithinRange(92, arSYesNo, T("|Only dimension points in range|"));
sDimPointsWithinRange.setCategory(category);

category =  T("DO - |Beam of type|");
PropString sDimBmType(34, arSBmTypesSorted, T("|Beam type|"));
sDimBmType.setCategory(category);

category =  T("DO - |Beam with hsb Id|");
PropString sDimHsbId (65, "", T("|Hsb Id|'s"));
sDimHsbId.setCategory(category);

category =  T("DO - |Panels|");
PropString componentIndex(69, "-1", T("|Component index|"));
componentIndex.setCategory(category);
componentIndex.setDescription(T("|Specifies the component index to dimension.|") + TN("-1 |will take all the components into account.|") + TN("|This can be a semicolon seperated list|"));

String componentFaces[] = 
{
	T("|Internal face|"),
	T("|External face|"),
	T("|Internal and extrenal face|")
};
PropString componentFaceProp(88, componentFaces, T("|Component face|"), 2);
componentFaceProp.setCategory(category);
PropString takeComponentExtremesProp(89, arSYesNo, T("|Take component extremes|"), 0);
takeComponentExtremesProp.setCategory(category);
PropString takeAllComponentExtremesProp(74, arSYesNo, T("|Take all component extremes|"), 1);
takeAllComponentExtremesProp.setCategory(category);
PropDouble panelRange(10, U(0), T("|Panel range|"));
panelRange.setCategory(category);
panelRange.setDescription(T("|Only points within the specified range are taken into account.|"));

category =  T("DO - |Tools|");
String toolTypes[] = {
	T("|Drill|"),
	T("|Beamcut|")
};
PropString toolType(82, toolTypes, T("|Tool type|"));
toolType.setCategory(category);
PropDouble onlyDrillDiameter(7, U(0), T("|Only with drill diameter|"));
onlyDrillDiameter.setCategory(category);
PropDouble minimumBeamCutDepth(8, U(0), T("|Minimum beam cut depth|"));
minimumBeamCutDepth.setCategory(category);

//String sArSideParBms[]={T("|Upper|"),T("|Center|"),T("|Lower|")};
//double dArSideParBms[]={1, 0.5, 0};
//PropString sSideParBms(13,sArSideParBms,T("|Dim side of beams parallel to dimline|"),2);
category =  T("|Miscellaneous|");
PropString sSpecial(18, "", T("|Special| - ")+T("|Customer specific|"));
sSpecial.setCategory(category);

/// - Positioning -
/// 
category =  T("|Positioning|");
String offsetFromOptions[] = { T("|Element|"), T("|Dimension objects|")};
PropString offsetFrom(87, offsetFromOptions, T("|Offset from|"), 0);
offsetFrom.setCategory(category);

PropString sUsePSUnits(32, arSYesNo, T("|Offset in paperspace units|"),1);
sUsePSUnits.setCategory(category);
//Used to set the distance to the element.
PropDouble dDimOff(0,U(300),T("|Offset dimension line|"));
dDimOff.setCategory(category);
PropDouble dTextOff(1,U(100),T("|Offset description|"));
dTextOff.setCategory(category);
//Used to set the dimension line to specific side of the element.
String arSPosition[] = {
	T("|Vertical Left|"),
	T("|Vertical Right|"),
	T("|Horizontal Bottom|"),
	T("|Horizontal Top|"),
	T("|Automatic Vertical|"),
	T("|Automatic Horizontal|")
};
PropString sPosition(8,arSPosition,T("|Position|"));
sPosition.setCategory(category);
PropInt nMinRequiredDimPoints(0, 2, T("|Minimum points required|"));
nMinRequiredDimPoints.setCategory(category);
PropDouble dAllowedTollerance(5, U(0.01), T("|Merge points closer to each other than|"));
dAllowedTollerance.setCategory(category);


/// - Style -
/// 
category =  T("|Style|");

//Used to set the side of the text.
String sArDeltaOnTop[]={T("|Above|"),T("|Below|"), T("|At element side|"), T("|At the other side|")};
int nArDeltaOnTop[]={0,1,2,3};
PropString sDeltaOnTop(0,sArDeltaOnTop,T("|Side of delta dimension|"),0);
sDeltaOnTop.setCategory(category);

String arSReadDirection[] = {T("|Top-left|"), T("|Bottom-right|")};
PropString sReadDirection(17, arSReadDirection, T("|Read direction|"));
sReadDirection.setCategory(category);

String sArTextSide[]={T("|Left|"),T("|Right|"),T("|None|")};
int nArTextSide[]={1,-1, 0};
PropString sTextSide(1,sArTextSide,T("|Side of description|"),0);
sTextSide.setCategory(category);

String sArStartDim[]={
	T("|Left|"),
	T("|Right|"),
	T("|Automatic|")
};
int nArStartDim[]={
	1,
	-1,
	99
};
PropString sStartDim(2,sArStartDim,T("|Start dimension|"));
sStartDim.setCategory(category);

//Used to set the dimension style
String sArDimStyle[] ={
	T("|Delta perpendicular|"),
	T("|Delta parallel|"),
	T("|Cumulative perpendicular|"),
	T("|Cumulative parallel|"),
	T("|Both perpendicular|"),
	T("|Both parallel|"),
	T("|Delta parallel|, ")+T("|Cumulative perpendicular|"),
	T("|Delta perpendicular|, ")+T("|Cumulative parallel|")
};
int nArDimStyleDelta[] = {_kDimPerp, _kDimPar,_kDimNone,_kDimNone,_kDimPerp,_kDimPar,_kDimPar,_kDimPerp};
int nArDimStyleCum[] = {_kDimNone,_kDimNone,_kDimPerp, _kDimPar,_kDimPerp,_kDimPar,_kDimPerp,_kDimPar};
PropString sDimStyle(9,sArDimStyle,T("|Dimension method|"));
sDimStyle.setCategory(category);

//Used to set the dimensioning side. Which side of the entity's in the element is dimensioned.
String sArSide[]={T("|Left|"),T("|Center|"),T("|Right|"), T("|Left| & ") + T("|Right|"), T("|Automatic Left|"), T("|Automatic Right|")};
int nArSide[]={_kLeft, _kCenter, _kRight, _kLeftAndRight, 4, 5};
PropString sSide(10,sArSide,T("|Dimension side|"));
sSide.setCategory(category);

//Used to set the dimensioning layout.
PropString sDimLayout(11,arSDimStylesSorted,T("|Dimension style|"),1);
sDimLayout.setCategory(category);
PropString sUseVpScaleAsDimScale(61, arSYesNo, T("|Use viewport scale as dimension scale|"),0);
sUseVpScaleAsDimScale.setCategory(category);

PropInt nDimColor(3,1,T("|Color|"));
nDimColor.setCategory(category);

String arSExtensionLines[] = {
	T("|To dimension objects|"),
	T("|To side of element|"),
	T("|No extension lines|")
};
PropString sExtLines(12,arSExtensionLines,T("|Place extension lines|"),1);
sExtLines.setCategory(category);

PropString sDescription(14, "", T("|Overrule description|"));
sDescription.setCategory(category);


/// - Reference -
/// 
category =  T("|Reference|");

//Used as a reference
String sArReference[] = {
	T("|Element|"),
	T("|Zone|"),
	T("|No reference|"), 
	T("|Rafters|"),
	T("|Beamcode|"),
	T("|Beamcode in range|"),
	T("|Grid|"),
	T("|Half grid|"),
	T("|Element outline|"),
	T("|Wall icon|"),
	T("|Perimeter|"),
	T("|Panel|")
};
PropString sReference(7,sArReference,T("|Reference object|"));
sReference.setCategory(category);
String arSExtraReference[] = {
	T("|No extra reference|"),
	T("|Inside frame|"),
	T("|Outside frame|")
};
PropString sExtraReference(70, arSExtraReference, T("|Frame as extra reference|"),0);
sExtraReference.setCategory(category);

PropInt nZnRef(2,arZone,T("|Reference zone|"),5); // index 5 is default
nZnRef.setCategory(category);

PropString sRefBmCode(54, "", T("|Reference beamcode|"));
sRefBmCode.setCategory(category);

PropString useRealBodyOfReferenceBeamProp(84, arSYesNo, T("|Use real body of reference beam|"), 1);
useRealBodyOfReferenceBeamProp.setCategory(category);
useRealBodyOfReferenceBeamProp.setDescription(T("|Specifies wheter the real body of the beam is used or the envelope body with cuts is used.|"));

PropInt nNrOfGridPoints(8, 1, T("|Number of grid points to dimension|"));
nNrOfGridPoints.setCategory(category);
nNrOfGridPoints.setDescription(T("|The number of grid points that will be dimensioned at the specified side. One point is required.|"));

PropDouble offsetGridReference(87, 0, T("|Offset Grid Reference|"));
offsetGridReference.setCategory(category);
offsetGridReference.setDescription(T("|Specify an offset for the bounds to look for a grid reference|"));

PropString sDimOutsideReference(86, arSYesNo, T("|Use points outside Reference boundary|"), 0);
sDimOutsideReference.setCategory(category);
sDimOutsideReference.setDescription(T("|Specifies wheter points that are outside of the reference points should be dimensioned|"));

PropString sSubMapXPerimeterReference(83, arSMapX, T("|Reference perimeter calculated from|"));
sSubMapXPerimeterReference.setCategory(category);

PropString componentIndexRef(73, "-1", T("|Component index reference|"));
componentIndexRef.setCategory(category);
PropString componentFaceRefProp(90, componentFaces, T("|Component face reference|"), 2);
componentFaceRefProp.setCategory(category);

String sArSideRef[]={T("|Left|"), T("|Center|"), T("|Right|"), T("|Left| & ") + T("|Right|")};
int nArSideRef[]={_kLeft, _kCenter, _kRight, _kLeftAndRight};
PropString sSideRef(28,sArSideRef,T("|Reference side|"));
sSideRef.setCategory(category);

PropString sDimRefSeperate(30, arSYesNo, T("|Reference seperated|"),1);
sDimRefSeperate.setCategory(category);
PropDouble dExtraOffsetRef(3, -U(25), T("|Extra offset seperated reference|"));
dExtraOffsetRef.setCategory(category);
PropString sShowSeperateRefSigned(31, arSYesNo, T("|Signed reference|"),1);
sShowSeperateRefSigned.setCategory(category);

PropString sTxtRefLeftPos(37, "", T("|Text positive reference left|"));
sTxtRefLeftPos.setCategory(category);
PropString sTxtRefLeftNeg(38, "", T("|Text negative reference left|"));
sTxtRefLeftNeg.setCategory(category);
PropString sTxtRefRightPos(39, "", T("|Text positive reference right|"));
sTxtRefRightPos.setCategory(category);
PropString sTxtRefRightNeg(40, "", T("|Text negative reference right|"));
sTxtRefRightNeg.setCategory(category);
String arSRefTextType[] = {
	T("|No text|"),
	T("|Text with dim|"),
	T("|Text at line|")
};
PropString sRefTextType(41, arSRefTextType, T("|Reference text type|"));
sRefTextType.setCategory(category);
PropDouble dyOffsetRefText(4, 0, T("Y-|Offset reference text|"));
dyOffsetRefText.setCategory(category);

/// - Name and description -
/// 
category =  T("|Name and description|");

PropInt nColorName(4, -1, T("|Default name color|"));
nColorName.setCategory(category);
PropInt nColorActiveFilter(5, 30, T("|Filter other element color|"));
nColorActiveFilter.setCategory(category);
PropInt nColorActiveFilterThisElement(6, 1, T("|Filter this element color|"));
nColorActiveFilterThisElement.setCategory(category);
PropString sDimStyleName(56, arSDimStylesSorted, T("|Dimension style name|"));
sDimStyleName.setCategory(category);
PropString sInstanceDescription(57, "", T("|Extra description|"));
sInstanceDescription.setCategory(category);
PropString sDisableTsl(68, arSYesNo, T("|Disable the tsl|"),1);
sDisableTsl.setCategory(category);
PropString sShowVpOutline(67, arSYesNo, T("|Show viewport outline|"),1);
sShowVpOutline.setCategory(category);

/// - End Properties - 
///


if(_bOnInsert){
	showDialogOnce();
	return;
}

//PropString sAdjustScale(20, arSYesNo, T("|Adjust scale to zero decimals|"),1);
int bAdjustScale = false;//arNYesNo[arSYesNo.find(sAdjustScale, 1)];


String arSTrigger[] = {
	T("|Filter this element|"),
	"     ----------",
	T("|Remove filter for this element|"),
	T("|Remove filter for all elements|")
};
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );


// Draw name
String sInstanceNameAndDescription = _ThisInst.scriptName();
if( sInstanceDescription.length() > 0 )
	sInstanceNameAndDescription += (" - "+sInstanceDescription);

Display dpName(nColorName);
dpName.dimStyle(sDimStyleName);
dpName.draw(sInstanceNameAndDescription, _Pt0, _XW, _YW, 1, 2);

double dTextHeightName = dpName.textHeightForStyle("HSB", sDimStyleName);

//CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
//if( bAdjustScale ){
//	double dScaleMS = 1/ms2ps.scale();
//	double nScaleMS = dScaleMS - int(dScaleMS);
//	if( abs(nScaleMS) > dEpsScale ){
//		double dNewScale = int(dScaleMS) + 1;
//		Point3d ptVpCenPS = vp.ptCenPS();
//		Point3d ptVpCenMS = ptVpCenPS;
//		ptVpCenMS.transformBy(ps2ms);
//		CoordSys csNew;
//		csNew.setToAlignCoordSys(ptVpCenMS, _XW, _YW, _ZW, ptVpCenPS, ms2ps.vecX() * dScaleMS/dNewScale, ms2ps.vecY() * dScaleMS/dNewScale, ms2ps.vecZ() * dScaleMS/dNewScale);
//		
//		vp.setCoordSys(csNew);
//		ms2ps = csNew;
//		ps2ms = ms2ps;
//		ps2ms.invert();
//		pushCommandOnCommandStack("_REGEN");
//	}
//}
double dVpScale = ps2ms.scale();

// Add filteer
if( _kExecuteKey == arSTrigger[0] ){
	Map mapFilterElements;
	if( _Map.hasMap("FilterElements") )
		mapFilterElements = _Map.getMap("FilterElements");
	
	mapFilterElements.setString(el.handle(), "Element Filter");
	_Map.setMap("FilterElements", mapFilterElements);
}

// Remove single filteer
if( _kExecuteKey == arSTrigger[2] ){
	Map mapFilterElements;
	if( _Map.hasMap("FilterElements") ){
		mapFilterElements = _Map.getMap("FilterElements");
		
		if( mapFilterElements.hasString(el.handle()) )
			mapFilterElements.removeAt(el.handle(), true);
		_Map.setMap("FilterElements", mapFilterElements);
	}
}

// Remove all filteer
if( _kExecuteKey == arSTrigger[3] ){
	if( _Map.hasMap("FilterElements") )
		_Map.removeAt("FilterElements", true);
}

int bShowVpOutline = arNYesNo[arSYesNo.find(sShowVpOutline,1)];
if( _Viewport.length() > 0 && (bShowVpOutline || _bOnDebug) ){
	Viewport vp = _Viewport[0];
	Display dpDebug(1);
	dpDebug.layer("DEFPOINTS");
	PLine plVp(_ZW);
	Point3d ptA = vp.ptCenPS() - _XW * 0.48 * vp.widthPS() - _YW * 0.48 * vp.heightPS();
	ptA.vis();
	Point3d ptB = vp.ptCenPS() + _XW * 0.48 * vp.widthPS() + _YW * 0.48 * vp.heightPS();
	plVp.createRectangle(LineSeg(ptA, ptB), _XW, _YW);
	dpDebug.draw(plVp);
}

int bDisableTsl = arNYesNo[arSYesNo.find(sDisableTsl,1)];
if( bDisableTsl ){
	dpName.color(nColorActiveFilterThisElement);
	dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
	dpName.textHeight(0.5 * dTextHeightName);
	dpName.draw(T("|Disbled|"), _Pt0, _XW, _YW, 1, 1);
	return;
}

Map mapFilterElements;
if( _Map.hasMap("FilterElements") )
	mapFilterElements = _Map.getMap("FilterElements");
if( mapFilterElements.length() > 0 ){
	if( mapFilterElements.hasString(el.handle()) ){
		dpName.color(nColorActiveFilterThisElement);
		dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
		dpName.textHeight(0.5 * dTextHeightName);
		dpName.draw(T("|Active filter|"), _Pt0, _XW, _YW, 1, 1);
		return;
	}
	else{
		dpName.color(nColorActiveFilter);
		dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
		dpName.textHeight(0.5 * dTextHeightName);
		dpName.draw(T("|Active filter|"), _Pt0, _XW, _YW, 1, 1);
	}
}


// check if the viewport has hsb data
if( !el.bIsValid() )
	return;

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

int bElIsRoof = false;
int bElIsFloor = false;
if( el.bIsKindOf(ElementRoof()) ){
	if( abs(vzEl.dotProduct(_ZW) - 1) < dEps )
		bElIsFloor = true;
	else
		bElIsRoof = true;
}	

int bElISWall = false;
if( el.bIsKindOf(ElementWallSF()) )
	bElISWall = true;

Line lnYEl(ptEl, vyEl);
Plane pnBack(ptEl - vzEl * el.zone(0).dH(), vzEl);


// Paperspace vectors
Vector3d vxps = _XW;
Vector3d vyps = _YW;
Vector3d vzps = _ZW;
// Paperspace vectors transformed to modelspace
Vector3d vxms = vxps;
vxms.transformBy(ps2ms);
vxms.normalize();
Vector3d vyms = vyps;
vyms.transformBy(ps2ms);
vyms.normalize();
Vector3d vzms = vzps;
vzms.transformBy(ps2ms);
vzms.normalize();

CoordSys csViewMs(ptEl, vxms, vyms, vzms);

Line lnX(ptEl, vxms);
Line lnY(ptEl, vyms);
Line lnZ(ptEl, vzms);



String arSRefPosition[] = {
	"BL", //Bottom - Left
	"BR", //Bottom - Right
	"TR", //Top-Right
	"TL", //Top - Left
	"LO", //Bottom - Left
	"RO", //Bottom - Right
	"RB", //Top - Right
	"LB", //Top - Left
	"Bottom left", //Bottom - Left
	"Bottom right", //Bottom - Right
	"Top right", //Top-Right
	"Top left" //Top - Left
};

Vector3d arVRefPosition[] = {
	-vxEl - vyEl,
	vxEl - vyEl,
	vxEl + vyEl,
	-vxEl + vyEl,
	-vxEl - vyEl,
	vxEl - vyEl,
	vxEl + vyEl,
	-vxEl + vyEl,
	-vxEl - vyEl,
	vxEl - vyEl,
	vxEl + vyEl,
	-vxEl + vyEl
};

int arNRefPosDimSideHor[] = {
	1,
	-1,
	-1,
	1
};
int arNRefPosDimSideVer[] = {
	1,
	1,
	-1,
	-1
};
int arNRefPosPositionHor[] = {
	2,//Bottom
	2,//Bottom
	3,//Top
	3//Top
};
int arNRefPosPositionVer[] = {
	0,//Left
	1,//Right
	1,//Right
	0//Left
};

int nZone = nZn;
if( nZone > 5 )
	nZone = 5 - nZone;

int nZonePerimeter = nZnPerimeter;
if( nZonePerimeter > 5 )
	nZonePerimeter = 5 - nZonePerimeter;
int perimeterZoneIndexes[] = { nZonePerimeter};
String _additionalPerimeterZoneIndexes[] = additionalPerimeterZoneIndexes.tokenize(';');
for (int i = 0;i<_additionalPerimeterZoneIndexes.length();i++)
{
	perimeterZoneIndexes.append(_additionalPerimeterZoneIndexes[i].atoi());
}

int nSubMapXPerimeter = arSMapX.find(sSubMapXPerimeter, 0);
int nSubMapXPerimeterReference = arSMapX.find(sSubMapXPerimeterReference, 0);

int componentFace = componentFaces.find(componentFaceProp,2);
int takeComponentExtremes = arNYesNo[arSYesNo.find(takeComponentExtremesProp, 0)];
int takeAllComponentExtremes = arNYesNo[arSYesNo.find(takeAllComponentExtremesProp, 0)];

int nZoneRef = nZnRef;
if( nZoneRef > 5 )
	nZoneRef = 5 - nZoneRef;

int nTextSide = nArTextSide[sArTextSide.find(sTextSide,0)];
int bCombineTouchingGenBeams = arNYesNo[arSYesNo.find(sCombineTouchingGenBeams,1)];
int bDimLabelIncludeNonPerpendiculars = arNYesNo[arSYesNo.find(sDimLabelIncludeNonPerpendiculars, 0)];
int nDimPointsWithinRange = arNYesNo[arSYesNo.find(sDimPointsWithinRange, 0)];

String sType;
if( bElIsRoof || bElIsFloor )
	sType = el.code();
else if( bElISWall )
	sType= el.subType();

String sRefPosition = sType.token(0);

String propSetName = "hsbInformation";
int propSetIsAttached = (el.attachedPropSetNames().find(propSetName) != -1);
if (propSetIsAttached)
{
	Map informationMap = el.getAttachedPropSetMap(propSetName);
	sRefPosition = informationMap.getString("hsbDimensionOrigin");
}
propSetName = "hsbExtendedElementData";
propSetIsAttached = (el.attachedPropSetNames().find(propSetName) != -1);
if (propSetIsAttached)
{
	Map informationMap = el.getAttachedPropSetMap(propSetName);
	sRefPosition = informationMap.getString("DimensionReferencePosition");
}

int nDeltaOnTop = nArDeltaOnTop[sArDeltaOnTop.find(sDeltaOnTop,0)];
int nPosition = arSPosition.find(sPosition,0);
if( nPosition > 3 ){
	Vector3d vRefPosition = arVRefPosition[arSRefPosition.find(sRefPosition, 0)];
	vRefPosition.transformBy(ms2ps);
	vRefPosition.normalize();
	
	double dx = vxps.dotProduct(vRefPosition);
	double dy = vyps.dotProduct(vRefPosition);
	
	int nRefIndex = 0;
	if( dx<0 ){//left
		nRefIndex = 3;//top-left
		if( dy<0 )//bottom-left
			nRefIndex = 0;
	}
	else{
		nRefIndex = 2;//top-right
		if( dy<0 )//bottom-right
			nRefIndex = 1;
	}
	
	int arNRefPosPosition[0];
	if( nPosition == 4 )
		arNRefPosPosition.append(arNRefPosPositionVer);
	else
		arNRefPosPosition.append(arNRefPosPositionHor);
	
	nPosition = arNRefPosPosition[nRefIndex];//arSRefPosition.find(sRefPosition, 0)];
}

if( nDeltaOnTop > 1 ){
	if( nDeltaOnTop == 2 ){
		nDeltaOnTop = 0;
		if( nPosition == 0 || nPosition == 3 )
			nDeltaOnTop = 1;
	}
	else{
		nDeltaOnTop = 1;
		if( nPosition == 0 || nPosition == 3 )
			nDeltaOnTop = 0;
	}
}

int bDeltaOnTop = nDeltaOnTop == 0;

int nSide = nArSide[sArSide.find(sSide,0)];

int nStartDim = nArStartDim[sArStartDim.find(sStartDim,0)];
if( nStartDim == 99 ){
	Vector3d vRefPosition = arVRefPosition[arSRefPosition.find(sRefPosition, 0)];
	vRefPosition.transformBy(ms2ps);
	vRefPosition.normalize();
	
	double dx = vxps.dotProduct(vRefPosition);
	double dy = vyps.dotProduct(vRefPosition);
	
	int nRefIndex = 0;
	if( dx<0 ){//left
		nRefIndex = 3;//top-left
		if( dy<0 )//bottom-left
			nRefIndex = 0;
	}
	else{
		nRefIndex = 2;//top-right
		if( dy<0 )//bottom-right
			nRefIndex = 1;
	}

	int arNRefPosDimSide[0];
	if( nPosition < 2 )
		arNRefPosDimSide.append(arNRefPosDimSideVer);
	else
		arNRefPosDimSide.append(arNRefPosDimSideHor);
		
	nStartDim = arNRefPosDimSide[nRefIndex];//arSRefPosition.find(sRefPosition, 0)];
	
	if( nSide == 4 ){
		nSide = _kLeft;
		if( nStartDim == -1 ){
			nSide = _kRight;
		}
	}
	else if( nSide == 5 ){
		nSide = _kRight;
		if( nStartDim == -1 ){
			nSide = _kLeft;
		}
	}
}

String sDimBC = sDimBeamCode + ";";
sDimBC.makeUpper();
String arSDimBC[0];
int nIndexDimBC = 0; 
int sIndexDimBC = 0;
while(sIndexDimBC < sDimBC.length()-1){
	String sTokenBC = sDimBC.token(nIndexDimBC);
	nIndexDimBC++;
	if(sTokenBC.length()==0){
		sIndexDimBC++;
		continue;
	}
	sIndexDimBC = sDimBC.find(sTokenBC,0);

	arSDimBC.append(sTokenBC);
}
String sDimLbl = sDimLabel + ";";
sDimLbl.makeUpper();
String arSDimLbl[0];
int nIndexDimLbl = 0; 
int sIndexDimLbl = 0;
while(sIndexDimLbl < sDimLbl.length()-1){
	String sTokenLbl = sDimLbl.token(nIndexDimLbl);
	nIndexDimLbl++;
	if(sTokenLbl.length()==0){
		sIndexDimLbl++;
		continue;
	}
	sIndexDimLbl = sDimLbl.find(sTokenLbl,0);

	arSDimLbl.append(sTokenLbl);
}

String sDimId = sDimHsbId + ";";
sDimId.makeUpper();
String arSDimHsbId[0];
int nIndexDimHsbId = 0; 
int sIndexDimHsbId = 0;
while(sIndexDimHsbId < sDimId.length()-1){
	String sTokenHsbId = sDimId.token(nIndexDimHsbId);
	nIndexDimHsbId++;
	if(sTokenHsbId.length()==0){
		sIndexDimHsbId++;
		continue;
	}
	sIndexDimHsbId = sDimId.find(sTokenHsbId,0);

	arSDimHsbId.append(sTokenHsbId);
}

int nDimBmType = _BeamTypes.find(sDimBmType);
String sFBC = sFilterBC + ";";
sFBC.makeUpper();
String arSExcludeBC[0];
int nIndexBC = 0; 
int sIndexBC = 0;
while(sIndexBC < sFBC.length()-1){
	String sTokenBC = sFBC.token(nIndexBC);
	nIndexBC++;
	if(sTokenBC.length()==0){
		sIndexBC++;
		continue;
	}
	sIndexBC = sFBC.find(sTokenBC,0);
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSExcludeBC.append(sTokenBC);
}
String sFLabel = sFilterLabel + ";";
sFLabel.makeUpper();
String arSExcludeLbl[0];
int nIndexLabel = 0; 
int sIndexLabel = 0;
while(sIndexLabel < sFLabel.length()-1){
	String sTokenLabel = sFLabel.token(nIndexLabel);
	nIndexLabel++;
	if(sTokenLabel.length()==0){
		sIndexLabel++;
		continue;
	}
	sIndexLabel = sFLabel.find(sTokenLabel,0);

	arSExcludeLbl.append(sTokenLabel);
}
String sFMaterial = sFilterMaterial + ";";
sFMaterial.makeUpper();
String arSExcludeMat[0];
int nIndexMaterial = 0; 
int sIndexMaterial = 0;
while(sIndexMaterial < sFMaterial.length()-1){
	String sTokenMaterial = sFMaterial.token(nIndexMaterial);
	nIndexMaterial++;
	if(sTokenMaterial.length()==0){
		sIndexMaterial++;
		continue;
	}
	sIndexMaterial = sFMaterial.find(sTokenMaterial,0);

	arSExcludeMat.append(sTokenMaterial);
}

String sFHsbId = sFilterHsbID + ";";
sFHsbId.makeUpper();
String arSExcludeHsbId[0];
int nIndexHsbId = 0; 
int sIndexHsbId = 0;
while(sIndexHsbId < sFHsbId.length()-1){
	String sTokenHsbId = sFHsbId.token(nIndexHsbId);
	nIndexHsbId++;
	if(sTokenHsbId.length()==0){
		sIndexHsbId++;
		continue;
	}
	sIndexHsbId = sFHsbId.find(sTokenHsbId,0);

	arSExcludeHsbId.append(sTokenHsbId);
}
int nFilterModule = arSFilterModule.find(sFilterModule,0);

int arNFilterZone[0];
int nIndex = 0;
String sZones = sFilterZone + ";";
int nToken = 0;
String sToken = sZones.token(nToken);
while( sToken != "" ){
	int nZn = sToken.atoi();
	if( nZn == 0 && sToken != "0" ){
		nToken++;
		sToken = sZones.token(nToken);
		continue;
	}
	if( nZn > 5 )
		nZn = 5 - nZn;	
	arNFilterZone.append(nZn);
	
	nToken++;
	sToken = sZones.token(nToken);
}

int arNTslZone[0];
nIndex = 0;
sZones = sDimTslsInZone + ";";
nToken = 0;
sToken = sZones.token(nToken);
while( sToken != "" ){
	int nZn = sToken.atoi();
	if( nZn == 0 && sToken != "0" ){
		nToken++;
		sToken = sZones.token(nToken);
		continue;
	}
	if( nZn > 5 )
		nZn = 5 - nZn;	
	arNTslZone.append(nZn);
	
	nToken++;
	sToken = sZones.token(nToken);
}

String arSTslSubType[0];
String sTslDimSubTypes = sTslSubType + ";";
sTslDimSubTypes.makeUpper();
int nIndexTslSubType = 0; 
int sIndexTslSubType = 0;
while(sIndexTslSubType < sTslDimSubTypes.length()-1){
	String sToken = sTslDimSubTypes.token(nIndexTslSubType);
	nIndexTslSubType++;
	if(sToken.length()==0){
		sIndexTslSubType++;
		continue;
	}
	sIndexTslSubType = sTslDimSubTypes.find(sToken,0);

	arSTslSubType.append(sToken);
}


int nReadDirection = arSReadDirection.find(sReadDirection);
int dimensionTslOrigin = arNYesNo[arSYesNo.find(sDimTslOrigin,0)];
int dimensionTslGripPoints = arNYesNo[arSYesNo.find(sDimTslGripPoints,0)];
int bIgnoreSinglePoints = arNYesNo[arSYesNo.find(sIgnoreSinglePoints,1)];
int bOnlySheetJoints = arNYesNo[arSYesNo.find(sOnlySheetJoints,1)];
int bOnlyExtremesOfZone = arNYesNo[arSYesNo.find(sOnlyExtremesOfZone,1)];
int perimeterDimensionMode = perimeterDimensionModes.find(perimeterDimensionModeProp);
int perimeterWithOpenings = arNYesNo[arSYesNo.find(perimeterWithOpeningsProp)];
int nReference = sArReference.find(sReference,0);
int useRealBodyOfReferenceBeam = arNYesNo[arSYesNo.find(useRealBodyOfReferenceBeamProp, 1)];
int useRealBodyOfZoneBeam = arNYesNo[arSYesNo.find(useRealBodyOfZoneBeamProp, 1)];
int nDimStyleDelta = nArDimStyleDelta[sArDimStyle.find(sDimStyle,0)];
int nDimStyleCum = nArDimStyleCum[sArDimStyle.find(sDimStyle,0)];
int bUseVpScaleAsDimScale = arNYesNo[arSYesNo.find(sUseVpScaleAsDimScale,0)];
if( nDimColor < 0 || nDimColor > 255 )
	nDimColor.set(0);
int nExtLines = arSExtensionLines.find(sExtLines,1);
int nDimSideBeams = arNYesNo[arSYesNo.find(sDimSideBeams,0)];
int nDimSideRafters = arNYesNo[arSYesNo.find(sDimSideRafters,1)];
int nUseOnlyRaftersFromZone = arNYesNo[arSYesNo.find(sUseOnlyRaftersFromZone,1)];
int bCombineTouchingRafters = arNYesNo[arSYesNo.find(sCombineTouchingRafters,0)];
int bDimRaftersInsideFrame = arNYesNo[arSYesNo.find(sDimRaftersInsideFrame,0)];
int bNoDimensionsOutsideRefence = arNYesNo[arSYesNo.find(sDimOutsideReference,0)];

//double dSideParBms = dArSideParBms[sArSideParBms.find(sSideParBms,2)];
int bUsePSUnits = arNYesNo[arSYesNo.find(sUsePSUnits,1)];
double dOffsetDim = dDimOff;
if( bUsePSUnits )
	dOffsetDim *= dVpScale;
double dOffsetText = dTextOff;
if( bUsePSUnits )
	dOffsetText *= dVpScale;
double dOffsetRef = dExtraOffsetRef;
if( bUsePSUnits )
	dOffsetRef *= dVpScale;
double dyOffsetTextRef = dyOffsetRefText;
if( bUsePSUnits )
	dyOffsetTextRef *= dVpScale;

//Specials
String sSpecials = sSpecial + ";";
//sSpecials.makeUpper();
String arSSpecial[0];
int nIndexSpecial = 0; 
int sIndexSpecial = 0;
while(sIndexSpecial < sSpecials.length()-1){
	String sTokenSpecial = sSpecials.token(nIndexSpecial);
	nIndexSpecial++;
	if(sTokenSpecial.length()==0){
		sIndexSpecial++;
		continue;
	}
	sIndexSpecial = sSpecials.find(sTokenSpecial,0);

	arSSpecial.append(sTokenSpecial);
}
//Use these types for rafters as refernce points
int nSideRef = nArSideRef[sArSideRef.find(sSideRef,0)];
int bDimPtRefSeperate = arNYesNo[arSYesNo.find(sDimRefSeperate,1)];
int bRefSigned = arNYesNo[arSYesNo.find(sShowSeperateRefSigned,1)];
int nRefTextType = arSRefTextType.find(sRefTextType, 0);

int bAddInsideFrameAsReference = (arSExtraReference.find(sExtraReference)) == 1;
int bAddOutsideFrameAsReference = (arSExtraReference.find(sExtraReference)) == 2;
int componentFaceRef = componentFaces.find(componentFaceRefProp,2);

String sRefBC = sRefBmCode + ";";
sRefBC.makeUpper();
String arSRefBC[0];
int nIndexRefBC = 0; 
int sIndexRefBC = 0;
while(sIndexRefBC < sRefBC.length()-1){
	String sTokenBC = sRefBC.token(nIndexRefBC);
	nIndexRefBC++;
	if(sTokenBC.length()==0){
		sIndexRefBC++;
		continue;
	}
	sIndexRefBC = sRefBC.find(sTokenBC,0);

	arSRefBC.append(sTokenBC);
}

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(4));
Display dp(nDimColor);
if( bUseVpScaleAsDimScale )
	dp.dimStyle(sDimLayout, dVpScale); // dimstyle was adjusted for display in paper space, sets textHeight
else
	dp.dimStyle(sDimLayout);

Entity arEntTslPS[] = Group().collectEntities(true, TslInst(), _kMySpace);
TslInst tslSection;
for( int i=0;i<arEntTslPS.length();i++ ){
	TslInst tsl = (TslInst)arEntTslPS[i];
	
	Map mapTsl = tsl.map();
	String vpHandle = mapTsl.getString("VPHANDLE");
	
	if( tsl.scriptName() == sSectionName  && vpHandle == sVpHandle ){
		tslSection = tsl;
		break;
	}
}

GenBeam arGBmAll[0];
TslInst arTslTmp[0];
if( !tslSection.bIsValid() ){
	arGBmAll = el.genBeam(); // collect all
	arTslTmp.append(arTsl);
}
else{
	_Entity.append(tslSection);
	setDependencyOnEntity(tslSection);
	
	Map mapTsl = tslSection.map();
	for( int i=0;i<mapTsl.length();i++ ){
		if( mapTsl.keyAt(i) == "GENBEAM" ){
			Entity entGBm = mapTsl.getEntity(i);
			arGBmAll.append((GenBeam)entGBm);
		}
		if( mapTsl.keyAt(i) == "TslInst" ){
			Entity entTsl = mapTsl.getEntity(i);
			arTslTmp.append((TslInst)entTsl);
		}
	}
}
arTsl.setLength(0);
arTsl.append(arTslTmp);

int arNTypeJack[] = {
	_kSFJackOverOpening,
	_kSFJackUnderOpening
};
String arSCenterJackId[] = {
	"99",
	"214"
};
GenBeam arGBeams[0];
Body arBd[0];
Beam arBms[0];
Point3d arPtGBm[0];
Point3d arPtGBmSelectedZn[0];
PlaneProfile ppPerimeter(csViewMs);
Point3d arPtGBmPerimeterZn[0];
Point3d arPtBm[0];
Beam arBmRafter[0];
Point3d arPtRafter[0];
Beam arDimBmType[0];
Beam arDimBmID[0];
GenBeam arGBmRefBmCode[0];
Point3d arPtRefBmCode[0];
Beam arBmModule[0];
Sip arSip[0];
PlaneProfile ppPerimeterRef(csEl);
Point3d arPtPerimeterRef[0];
//Used for special 'BR-01'
Beam arBmBR[0];
// Used for special 'STKR'
Beam arBmStkr[0];

int arNRafterType[] = {
	_kDakCenterJoist,
	_kDakLeftEdge,
	_kDakRightEdge,
	_kStud,
	_kKingStud,
	_kSFSupportingBeam,
	_kSFJackUnderOpening,
	_kSFJackOverOpening,
	_kRafter,
	_kExtraRafter,
	_kSFStudLeft,
	_kSFStudRight
};

String arSRafterId[] = {
	"60",
	"61",
	"62",
	"63",
	"64"
};

// Grid can be used as reference. (v3.63)
Grid grid;

// Store opening module names. It is an opening module if it has an horizontal beam.
String arSOpeningModuleNames[0];
for(int i=0;i<arGBmAll.length();i++){
	GenBeam gBm = arGBmAll[i];
	
	if ((nReference == 6 || nReference == 7 || sObject == sArObject[11]) && !grid.bIsValid()){
		Grid gridGBm = gBm.grid();
		if (gridGBm.bIsValid())
			grid = gridGBm;
	}
	
	Beam bm = (Beam)gBm;
	if( !bm.bIsValid() )
		continue;
	
	if( !bm.vecX().isParallelTo(vxEl) )
		continue;
	
	String sModuleName = bm.module();
	if( sModuleName == "" )
		continue;
	
	if( arSOpeningModuleNames.find(sModuleName) == -1 )
		arSOpeningModuleNames.append(sModuleName);
}

CoordSys csRotation;
csRotation.setToRotation(1,csEl.vecZ(), csEl.ptOrg());
CoordSys csInvertRotation = csRotation;
csInvertRotation.invert();

for(int i=0;i<arGBmAll.length();i++){
	GenBeam gBm = arGBmAll[i];
	int bExcludeGenBeam = false;
	
	//Exclude dummies
	if( gBm.bIsDummy() )
		continue;
	
	//Exlude zones
	int nZnIndex = gBm.myZoneIndex();
	if( arNFilterZone.find(nZnIndex) != -1 )
		continue;
	
	//Exclude labels
	String sLabel = gBm.label().makeUpper();
	sLabel.trimLeft();
	sLabel.trimRight();
	if( arSExcludeLbl.find(sLabel)!= -1 ){
		bExcludeGenBeam = true;
	}
	else{
		for( int j=0;j<arSExcludeLbl.length();j++ ){
			String sExclLbl = arSExcludeLbl[j];
			String sExclLblTrimmed = sExclLbl;
			sExclLblTrimmed.trimLeft("*");
			sExclLblTrimmed.trimRight("*");
			if( sExclLblTrimmed == "" )
				continue;
			if( sExclLbl.left(1) == "*" && sExclLbl.right(1) == "*" && sLabel.find(sExclLblTrimmed, 0) != -1 )
				bExcludeGenBeam = true;
			else if( sExclLbl.left(1) == "*" && sLabel.right(sExclLbl.length() - 1) == sExclLblTrimmed )
				bExcludeGenBeam = true;
			else if( sExclLbl.right(1) == "*" && sLabel.left(sExclLbl.length() - 1) == sExclLblTrimmed )
				bExcludeGenBeam = true;
		}
	}
	if( bExcludeGenBeam )
		continue;
	
	//Exclude material
	String sMaterial = gBm.material().makeUpper();
	sMaterial.trimLeft();
	sMaterial.trimRight();
	if( arSExcludeMat.find(sMaterial)!= -1 ){
		bExcludeGenBeam = true;
	}
	else{
		for( int j=0;j<arSExcludeMat.length();j++ ){
			String sExclMat = arSExcludeMat[j];
			String sExclMatTrimmed = sExclMat;
			sExclMatTrimmed.trimLeft("*");
			sExclMatTrimmed.trimRight("*");
			if( sExclMatTrimmed == "" )
				continue;
			if( sExclMat.left(1) == "*" && sExclMat.right(1) == "*" && sMaterial.find(sExclMatTrimmed, 0) != -1 )
				bExcludeGenBeam = true;
			else if( sExclMat.left(1) == "*" && sMaterial.right(sExclMat.length() - 1) == sExclMatTrimmed )
				bExcludeGenBeam = true;
			else if( sExclMat.right(1) == "*" && sMaterial.left(sExclMat.length() - 1) == sExclMatTrimmed )
				bExcludeGenBeam = true;
		}
	}
	if( bExcludeGenBeam )
		continue;

	//Exclude hsbId
	String sHsbId = gBm.hsbId().makeUpper();
	sHsbId.trimLeft();
	sHsbId.trimRight();
	if( arSExcludeHsbId.find(sHsbId)!= -1 ){
		bExcludeGenBeam = true;
	}
	else{
		for( int j=0;j<arSExcludeHsbId.length();j++ ){
			String sExclHsbId = arSExcludeHsbId[j];
			String sExclHsbIdTrimmed = sExclHsbId;
			sExclHsbIdTrimmed.trimLeft("*");
			sExclHsbIdTrimmed.trimRight("*");
			if( sExclHsbIdTrimmed == "" )
				continue;
			if( sExclHsbId.left(1) == "*" && sExclHsbId.right(1) == "*" && sHsbId.find(sExclHsbIdTrimmed, 0) != -1 )
				bExcludeGenBeam = true;
			else if( sExclHsbId.left(1) == "*" && sHsbId.right(sExclHsbId.length() - 1) == sExclHsbIdTrimmed )
				bExcludeGenBeam = true;
			else if( sExclHsbId.right(1) == "*" && sHsbId.left(sExclHsbId.length() - 1) == sExclHsbIdTrimmed )
				bExcludeGenBeam = true;
		}
	}
	if( bExcludeGenBeam )
		continue;

	
	//Exclude beamcodes
	String sBmCode = gBm.beamCode().token(0).makeUpper();
	sBmCode.trimLeft();
	sBmCode.trimRight();
	
	if( arSExcludeBC.find(sBmCode)!= -1 ){
		bExcludeGenBeam = true;
	}
	else{
		for( int j=0;j<arSExcludeBC.length();j++ ){
			String sExclBC = arSExcludeBC[j];
			String sExclBCTrimmed = sExclBC;
			sExclBCTrimmed.trimLeft("*");
			sExclBCTrimmed.trimRight("*");
			if( sExclBCTrimmed == "" ){
				if( sExclBC == "*" && sBmCode != "" )
					bExcludeGenBeam = true;
				else
					continue;
			}
			else{
				if( sExclBC.left(1) == "*" && sExclBC.right(1) == "*" && sBmCode.find(sExclBCTrimmed, 0) != -1 )
					bExcludeGenBeam = true;
				else if( sExclBC.left(1) == "*" && sBmCode.right(sExclBC.length() - 1) == sExclBCTrimmed )
					bExcludeGenBeam = true;
				else if( sExclBC.right(1) == "*" && sBmCode.left(sExclBC.length() - 1) == sExclBCTrimmed )
					bExcludeGenBeam = true;
			}
		}
	}
	if( bExcludeGenBeam )
		continue;
	
	Beam bm = (Beam)gBm;
	String sModuleName = gBm.module();
	if( sModuleName != "" && bm.bIsValid() )
		arBmModule.append(bm);
	if( nFilterModule > 0 ){
		if( sModuleName != "" ){
			if( nFilterModule == 1 ) // filter all modules
				bExcludeGenBeam = true;
			else if( nFilterModule == 2 || nFilterModule == 3 ){
				if( arNTypeJack.find(gBm.type()) == -1 )
					bExcludeGenBeam = true;
				else if( nFilterModule == 3  && arSCenterJackId.find(gBm.hsbId()) == -1 )
					bExcludeGenBeam = true;
			}
			else if( (nFilterModule == 4 || nFilterModule == 5 || nFilterModule == 6) && arSOpeningModuleNames.find(sModuleName) != -1 ){
				if( nFilterModule == 4 ){
					bExcludeGenBeam = true;
				}
				else{
					if( arNTypeJack.find(gBm.type()) == -1 )
						bExcludeGenBeam = true;
					else if( nFilterModule == 6  && arSCenterJackId.find(gBm.hsbId()) == -1 )
						bExcludeGenBeam = true;
				}
			}
		}
	}
	if( bExcludeGenBeam )
		continue;
	
	Sip sip = (Sip)gBm;
	if (sip.bIsValid())
		arSip.append(sip);
	
	arGBeams.append(gBm);
	Body bdGBm = gBm.envelopeBody(false, true);
	if (useRealBodyOfReferenceBeam)
		bdGBm = gBm.realBody();
	Body b = bdGBm;
	b.transformBy(ms2ps);
	b.transformBy(_YW * 10);
//	b.vis(i);
	
	Point3d arPtThisGBm[] = bdGBm.allVertices();
	arPtGBm.append(arPtThisGBm);
	
	if( nZone == nZnIndex )
		arPtGBmSelectedZn.append(arPtThisGBm);
		
	if( sObject==sArObject[3] && perimeterZoneIndexes.find(nZnIndex) != -1 && nSubMapXPerimeter == 0 ){
		arPtGBmPerimeterZn.append(arPtThisGBm);

		PlaneProfile ppThisGBm(CoordSys(ptEl, vxms,vyms,vzms));
		ppThisGBm.unionWith(bdGBm.getSlice(Plane(gBm.ptCen(), vzms)));//el.vecZ())));//shadowProfile(Plane(csEl.ptOrg(), csEl.vecZ())));
		ppThisGBm.shrink(-U(0.1));
		//ppThisGBm.transformBy(csRotation);

		PlaneProfile p = ppThisGBm;
		p.transformBy(ms2ps); p.vis(3);
		
		ppPerimeter.unionWith(ppThisGBm);
	}
	
	if( nReference == 10 && nZoneRef == nZnIndex && nSubMapXPerimeterReference == 0 ){
		arPtPerimeterRef.append(arPtThisGBm);

		PlaneProfile ppThisGBm(CoordSys(ptEl, vxms,vyms,vzms));
		ppThisGBm.unionWith(bdGBm.getSlice(Plane(gBm.ptCen(), vzms)));//el.vecZ())));//shadowProfile(Plane(csEl.ptOrg(), csEl.vecZ())));
		ppThisGBm.shrink(-U(0.1));
		//ppThisGBm.transformBy(csRotation);

		PlaneProfile p = ppThisGBm;
		p.transformBy(ms2ps); p.vis(3);
		
		ppPerimeterRef.unionWith(ppThisGBm);
	}
	
	if( arSRefBC.find(sBmCode) != -1 ){
		arGBmRefBmCode.append(gBm);
		arPtRefBmCode.append(arPtThisGBm);
	}
	
		
	if( !bm.bIsValid() )
		continue;

	arPtBm.append(arPtThisGBm);
	if( arNRafterType.find(bm.type()) != -1 || arSRafterId.find(bm.hsbId()) != -1 ){
		if( !nUseOnlyRaftersFromZone || (nUseOnlyRaftersFromZone && nZone == nZnIndex) ){
			arBmRafter.append(bm);
			arPtRafter.append(arPtThisGBm);
		}
	}
	
	if( gBm.type() == nDimBmType && bm.bIsValid() )
		arDimBmType.append(bm);
	
	if( arSDimHsbId.find(bm.hsbId()) != -1 && bm.bIsValid() )
		arDimBmID.append(bm);
		
	if( bm.myZoneIndex() != 0 )
		continue;
	
	//Special for BTF
	if( arSSpecial.find("BR-01") != -1 && sBmCode == "BR-01" )
		arBmBR.append(bm);

	//Special to dimension stkr beams to following tile lath
	if( arSSpecial.find("STKR") != -1 && sBmCode == "STKR" && bm.type() == _kDakBackEdge)
		arBmStkr.append(bm);
	
	arBms.append(bm);
}

ppPerimeter.shrink(U(0.1));
//ppPerimeter.transformBy(csInvertRotation);

if( ppPerimeter.area() > U(1000) ){
	arPtGBmPerimeterZn.setLength(0);
	arPtGBmPerimeterZn.append(ppPerimeter.getGripVertexPoints());
}

for (int p=0;p<arPtGBmPerimeterZn.length();p++)
{
	Point3d pt = arPtGBmPerimeterZn[p];
	pt.transformBy(ms2ps);
	pt.vis(p);
}

ppPerimeterRef.shrink(U(0.1));
//ppPerimeterRef.transformBy(csInvertRotation);

if( ppPerimeterRef.area() > U(1000) ){
	arPtPerimeterRef.setLength(0);
	arPtPerimeterRef.append(ppPerimeterRef.getGripVertexPoints());
}

//PlaneProfile pTmp = ppPerimeter;
//pTmp.transformBy(ms2ps);
//pTmp.transformBy(_YW * 10);
//pTmp.vis();

Point3d arPtRef[0];
arPtRef.append(arPtGBm);
if( arSSpecial.find("ElementOutline") != -1 )
{
	arPtRef = el.plEnvelope().vertexPoints(true);
}
if (arPtRef.length() == 0)
{
	for(int i=-5;i<6;i++)
		arPtRef.append(el.profNetto(i).getGripVertexPoints());
}

Point3d arPtBmX[] = lnX.orderPoints(arPtRef);
Point3d arPtBmY[] = lnY.orderPoints(arPtRef);
// Check if there are points
if( (arPtBmX.length() * arPtBmY.length()) == 0 )
	return;

// Points at min x - side
Point3d ptLeft = arPtBmX[0];
Point3d ptl = ptLeft;
ptl.transformBy(ms2ps);
ptl.vis();
Point3d arPtMinX[] = {
	ptLeft
};
for( int i=1;i<arPtBmX.length();i++ ){
	Point3d pt = arPtBmX[i];
	if( abs(vxms.dotProduct(pt - arPtMinX[0])) > dEps )
		break;
	arPtMinX.append(pt);
}
arPtMinX = lnY.orderPoints(arPtMinX);
if( arPtMinX.length() == 0 )
	return;

// Points at max x - side
Point3d ptRight = arPtBmX[arPtBmX.length() - 1];
Point3d arPtMaxX[] = {
	ptRight
};
for( int i=(arPtBmX.length() - 2);i>=0;i-- ){
	Point3d pt = arPtBmX[i];
	if( abs(vxms.dotProduct(pt - arPtMaxX[0])) > dEps )
		break;
	arPtMaxX.append(pt);
}
arPtMaxX = lnY.orderPoints(arPtMaxX);
if( arPtMaxX.length() == 0 )
	return;

// Points at min y - side
Point3d ptBottom = arPtBmY[0];
Point3d arPtMinY[] = {
	ptBottom
};
for( int i=1;i<arPtBmY.length();i++ ){
	Point3d pt = arPtBmY[i];
	if( abs(vyms.dotProduct(pt - arPtMinY[0])) > dEps )
		break;
	arPtMinY.append(pt);
}
arPtMinY = lnX.orderPoints(arPtMinY);
if( arPtMinY.length() == 0 )
	return;
	
// Points at max y - side
Point3d ptTop = arPtBmY[arPtBmY.length() - 1];
Point3d arPtMaxY[] = {
	ptTop
};
for( int i=(arPtBmY.length() - 2);i>=0;i-- ){
	Point3d pt = arPtBmY[i];
	if( abs(vyms.dotProduct(pt - arPtMaxY[0])) > dEps )
		break;
	arPtMaxY.append(pt);
}
arPtMaxY = lnX.orderPoints(arPtMaxY);
if( arPtMaxY.length() == 0 )
	return;

// 8-sided points
Point3d ptMinXMinY = arPtMinX[0];
Point3d ptMinXMaxY = arPtMinX[arPtMinX.length() - 1];
Point3d ptMaxXMinY = arPtMaxX[0];
Point3d ptMaxXMaxY = arPtMaxX[arPtMaxX.length() - 1];
Point3d ptMinYMinX = arPtMinY[0];
Point3d ptMinYMaxX = arPtMinY[arPtMinY.length() - 1];
Point3d ptMaxYMinX = arPtMaxY[0];
Point3d ptMaxYMaxX = arPtMaxY[arPtMaxY.length() - 1];

Vector3d vToDimLn;
// direction of dim 
Vector3d  vDimX, vDimY;
if( nPosition == 0 ){ //Vertical left
	vDimX = vyps;
	vDimY = -vxps;
	
	vToDimLn = -vxms;
}
else if( nPosition == 1 ){ //vertical right
	vDimX = vyps;
	vDimY = -vxps;
	
	vToDimLn = vxms;
}
else if( nPosition == 2 ){ //horizontal bottom
	vDimX = vxps;
	vDimY = vyps;
	
	vToDimLn = -vyms;
}
else if( nPosition == 3 ){ //horizontal top
	vDimX = vxps;
	vDimY = vyps;
	
	vToDimLn = vyms;
}
else{
	vDimX = vxps;
	vDimY = vyps;
	
	vToDimLn = vyms;
}

Point3d ptBL = ptLeft + vyms * vyms.dotProduct(ptBottom - ptLeft);
Point3d ptBR = ptRight + vyms * vyms.dotProduct(ptBottom - ptRight);
Point3d ptTR = ptRight + vyms * vyms.dotProduct(ptTop - ptRight);
Point3d ptTL = ptLeft + vyms * vyms.dotProduct(ptTop - ptLeft);
double dElemLength = abs(vxms.dotProduct(ptTR - ptBL));
double dElemHeight = abs(vyms.dotProduct(ptTR - ptBL));

double dxOffRef[] = {  0,dElemLength,0,0};
double dyOffRef[] = {  0,0,0,dElemHeight};

double dxOff[] = {  -dOffsetDim,(dOffsetDim + dElemLength),0,0};
double dyOff[] = { 0, 0, -dOffsetDim,dElemHeight+dOffsetDim};
double dxTextOff[0];
double dyTextOff[0];
if(nTextSide == 1 || nTextSide == 0){
	dxTextOff.append(0);//0);
	dxTextOff.append(0);//0);
	dxTextOff.append(-dOffsetText); //-(dElemLength + dOffsetText) );
	dxTextOff.append(-dOffsetText);// -(dElemLength + dOffsetText) );
	
	dyTextOff.append(-dOffsetText);// -(dElemHeight + dOffsetText) );
	dyTextOff.append(-dOffsetText);// -(dElemHeight + dOffsetText) );
	dyTextOff.append(0);//0);
	dyTextOff.append(0);//0);
}
else if(nTextSide == -1){
	dxTextOff.append(0);
	dxTextOff.append(0);
	dxTextOff.append( dElemLength + dOffsetText );
	dxTextOff.append( dElemLength + dOffsetText );
	
	dyTextOff.append( dElemHeight + dOffsetText );
	dyTextOff.append( dElemHeight + dOffsetText );
	dyTextOff.append(0);
	dyTextOff.append(0);
}

Point3d ptStrt = ptMinXMinY - vyms*vyms.dotProduct(ptMinXMinY-ptMinYMinX);
Point3d ptElRef = ptStrt + vxms * dxOffRef[nPosition] + vyms * dyOffRef[nPosition];
Point3d pElZero = ptStrt + vxms *( dxOff[nPosition] + dxTextOff[nPosition] )+ vyms *( dyOff[nPosition] + dyTextOff[nPosition] );
Point3d pSt = ptStrt;pSt.transformBy(ms2ps);
pSt.vis(5);

Point3d pel0 = pElZero;
pel0.transformBy(ms2ps);
pel0.vis(1);

DimLine lnPs; // dimline in PS (Paper Space)
lnPs = DimLine(pel0, vDimX, vDimY );
DimLine lnMs = lnPs; lnMs.transformBy(ps2ms); // dimline in MS (Model Space)
Vector3d vOrder = lnMs.vecX();
vOrder.normalize();
Vector3d vDimPerp = lnMs.vecY();
vDimPerp.normalize();
Line lnOrder(lnMs.ptOrg(), vOrder);
Line lnPerp(lnMs.ptOrg(), vDimPerp);

//Define line for sorting
Line lnPSSort (pel0,vDimX*nStartDim);
Line lnMSSort = lnPSSort;
lnMSSort.transformBy(ps2ms);

Point3d arPtCorners[] = { ptBL, ptBR, ptTR, ptTL };
Point3d arPtCornersSorted[] = lnOrder.orderPoints(arPtCorners);

// End description dimline
if( arSSpecial.find("BR-01") != -1 && arBmBR.length() == 0 )
	nSideRef = _kLeftAndRight;

Point3d arPtToDim[0];
Point3d arPtRefToDim[0];
//set reference to origin of element
if (nReference == 0){
	Point3d ptElRefMinXMinY = ptMinXMinY - vyms*vyms.dotProduct(ptMinXMinY-ptMinYMinX);
	Point3d ptElRefMaxXMaxY = ptMaxXMaxY - vyms*vyms.dotProduct(ptMaxXMaxY-ptMaxYMaxX);
	Point3d arPtElRef[] = {
		ptElRefMinXMinY,
		ptElRefMaxXMaxY
	};
	Line lnDimX(pel0, vDimX);
	lnDimX.transformBy(ps2ms);
	arPtElRef = lnDimX.orderPoints(arPtElRef);
	if (arPtRef.length() == 0)
		arPtRef.append(ptElRefMinXMinY);
	if( nSideRef == _kLeft || nSideRef == _kLeftAndRight )
		arPtRefToDim.append(arPtElRef[0]);
	if( nSideRef == _kRight || nSideRef == _kLeftAndRight )
		arPtRefToDim.append(arPtElRef[arPtElRef.length() - 1]);
	if (nSideRef == _kCenter)
		arPtRefToDim.append((arPtElRef[0] + arPtElRef[arPtElRef.length() - 1])/2);
}
//set reference to origin of zone
if (nReference == 1) {
	Point3d arPtRef[0];
	for (int i=0;i<arGBeams.length();i++ ){	
		GenBeam gBm = arGBeams[i];
		if( gBm.bIsDummy() )
			continue;
		if( gBm.myZoneIndex() == nZoneRef )
			arPtRef.append(gBm.realBody().allVertices());
	}
	Line lnDimX(pel0, vDimX);
	lnDimX.transformBy(ps2ms);
	arPtRef = lnDimX.orderPoints(arPtRef);
	if (arPtRef.length() == 0)
		arPtRef.append(el.ptOrg());
	if( nSideRef == _kLeft || nSideRef == _kLeftAndRight )
		arPtRefToDim.append(arPtRef[0]);
	if( nSideRef == _kRight || nSideRef == _kLeftAndRight )
		arPtRefToDim.append(arPtRef[arPtRef.length() - 1]);
	if (nSideRef == _kCenter)
		arPtRefToDim.append((arPtRef[0] + arPtRef[arPtRef.length() - 1])/2);
}
else if (nReference == 2) {
	//No reference
}
else if (nReference == 3) {//set reference to origin of rafters
	Line lnDimX (pel0, vDimX);
	lnDimX.transformBy(ps2ms);

	Point3d arPtRafterX[] = lnDimX.orderPoints(arPtRafter);
	if(arPtRafterX .length() == 0) 
		arPtRafterX.append(el.ptOrg());
	if( nSideRef == _kLeft || nSideRef == _kLeftAndRight )
		arPtRefToDim.append(arPtRafterX[0]);
	if( nSideRef == _kRight || nSideRef == _kLeftAndRight )
		arPtRefToDim.append(arPtRafterX[arPtRafterX.length() - 1]);
	if (nSideRef == _kCenter)
		arPtRefToDim.append((arPtRafterX[0] + arPtRafterX[arPtRafterX.length() - 1])/2);
}
else if( nReference == 4 ){
	arPtRefBmCode = lnOrder.orderPoints(arPtRefBmCode);
	
	if( arPtRefBmCode.length() > 0 ){ 
		if( nSideRef == _kLeft || nSideRef == _kLeftAndRight )
			arPtRefToDim.append(arPtRefBmCode[0]);
		if( nSideRef == _kRight || nSideRef == _kLeftAndRight )
			arPtRefToDim.append(arPtRefBmCode[arPtRefBmCode.length() - 1]);
		if (nSideRef == _kCenter)
			arPtRefToDim.append((arPtRefBmCode[0] + arPtRefBmCode[arPtRefBmCode.length() - 1])/2);
	}
}
else if( nReference == 5 ){
	arPtRefBmCode.setLength(0);
	for( int i=0;i<arGBmRefBmCode.length();i++ ){
		GenBeam gBm = arGBmRefBmCode[i];
		double dDist = abs(vDimPerp.dotProduct(gBm.ptCen() - ptElRef));
		if( abs(vDimPerp.dotProduct(gBm.ptCen() - ptElRef)) > dRange )
			continue;
		arPtRefBmCode.append(gBm.realBody().allVertices());
	}
	
	arPtRefBmCode = lnOrder.orderPoints(arPtRefBmCode);
	
	if( arPtRefBmCode.length() > 0 ){ 
		if( nSideRef == _kLeft || nSideRef == _kLeftAndRight )
			arPtRefToDim.append(arPtRefBmCode[0]);
		if( nSideRef == _kRight || nSideRef == _kLeftAndRight )
			arPtRefToDim.append(arPtRefBmCode[arPtRefBmCode.length() - 1]);
		if (nSideRef == _kCenter)
			arPtRefToDim.append((arPtRefBmCode[0] + arPtRefBmCode[arPtRefBmCode.length() - 1])/2);
	}
}
else if (nReference == 6 || nReference == 7) {
	if (!grid.bIsValid()) {
		reportMessage(TN("|No grid found|!"));
	}
	else {
		CoordSys csGrid = grid.coordSys();
		Vector3d vGrid = csGrid.vecX();
		if (abs(vxEl.dotProduct(vGrid)) < U(0.5))
			vGrid = csGrid.vecY();
	
		Point3d ptStart = ptMinXMinY;
		ptStart -= vOrder * offsetGridReference;
		Point3d ptEnd = ptMaxXMinY;
		ptEnd += vOrder * offsetGridReference;
		Point3d arPtGridIntersect[] = grid.intersectPoints(Line(ptStart, vGrid), vGrid);
		if (arPtGridIntersect.length() == 0)
			arPtGridIntersect.append(grid.intersectPoints(Line(ptEnd, vGrid), vGrid));
		
		arPtGridIntersect = lnOrder.orderPoints(arPtGridIntersect);
		if (arPtGridIntersect.length() > 0) {
			Point3d arPtGrid[0];
			for (int i=0;i<(arPtGridIntersect.length() - 1);i++) {
				Point3d ptGrid = arPtGridIntersect[i];
				Point3d ptGridNext = arPtGridIntersect[i+1];

				if ((vOrder.dotProduct(ptStart - ptGrid) * vOrder.dotProduct(ptEnd - ptGrid)) < 0)
				{
					arPtGrid.append(ptGrid);
				}
				
				if (nReference == 7) { // half grid
					Point3d ptHalfGrid = (ptGrid + ptGridNext)/2;
					if ((vOrder.dotProduct(ptStart - ptHalfGrid) * vOrder.dotProduct(ptEnd - ptHalfGrid)) < 0)
						arPtGrid.append(ptHalfGrid);
						
					if (_bOnDebug) {
						Point3d ptHalfGridPS = ptHalfGrid;
						ptHalfGridPS.transformBy(ms2ps);
						ptHalfGridPS.vis(i);
					}
				}
				
				
				// Add last point too, if its is between the start and end point.
				if (i==(arPtGridIntersect.length() - 2)) {
					if ((vOrder.dotProduct(ptStart - ptGridNext) * vOrder.dotProduct(ptEnd - ptGridNext)) < 0)
						arPtGrid.append(ptGridNext);
				}
			}
			arPtGridIntersect = arPtGrid;
		}
		
		if (_bOnDebug) {		
			for (int i=0;i<arPtGridIntersect.length();i++) {			
				Point3d ptGrid = arPtGridIntersect[i];
			
				Point3d p = ptGrid;
				p.transformBy(ms2ps);
				p.vis(i);
			}
		}
		
		if( arPtGridIntersect.length() > 0 ){ 
			if( nSideRef == _kLeft || nSideRef == _kLeftAndRight ) {
				for (int i=0;i<nNrOfGridPoints;i++){
					if( nNrOfGridPoints > (arPtGridIntersect.length() - 1))
						break;
					arPtRefToDim.append(arPtGridIntersect[i]);
				}
			}
			if( nSideRef == _kRight || nSideRef == _kLeftAndRight ) {
				for (int i=0;i<nNrOfGridPoints;i++){
					if ((arPtGridIntersect.length() - (1+i)) < 0)
						break;
					arPtRefToDim.append(arPtGridIntersect[arPtGridIntersect.length() - (1+i)]);
				}
			}
			if (nSideRef == _kCenter) {
				reportNotice(T("|The center of gridlines is not supported as reference|"));
			}
		}		
	}
}
else if (nReference == 8){ // Element outline
	Point3d arPtElementOutline[] = el.plEnvelope().vertexPoints(true);
	arPtElementOutline = lnOrder.orderPoints(arPtElementOutline);
	
	if( arPtElementOutline.length() > 0 ){ 
		if( nSideRef == _kLeft || nSideRef == _kLeftAndRight )
			arPtRefToDim.append(arPtElementOutline[0]);
		if( nSideRef == _kRight || nSideRef == _kLeftAndRight )
			arPtRefToDim.append(arPtElementOutline[arPtElementOutline.length() - 1]);
		if (nSideRef == _kCenter)
			arPtRefToDim.append((arPtElementOutline[0] + arPtElementOutline[arPtElementOutline.length() - 1])/2);
	}
}
else if (nReference == 9){ //Wall icon
	if (bElISWall)
		arPtRefToDim.append(((ElementWall)el).ptArrow());
}
else if (nReference == 10){
	Point3d arPtPerimeter[0];
	
	if( nSubMapXPerimeterReference == 1 ){
		Point3d arPtLeft[0];
		Point3d arPtRight[0];
		Point3d arPtBottom[0];
		Point3d arPtTop[0];
		
		PlaneProfile ppNetto = el.profNetto(nZoneRef);
		PLine arPlNetto[] = ppNetto.allRings();
		int arBIsOpening[] = ppNetto.ringIsOpening();
		for( int i=0;i<arPlNetto.length();i++ ){
			PLine plNetto = arPlNetto[i];
			int bIsOpening = arBIsOpening[i];
			
			int bDirectionIsChecked = false;
			Point3d arPtPl[] = plNetto.vertexPoints(false);
			for( int j=0;j<(arPtPl.length() - 1);j++ ){
				Point3d ptFrom = arPtPl[j];
				Point3d ptTo = arPtPl[j+1];
				Point3d ptMid = (ptFrom + ptTo)/2;
				
				Vector3d vLnSeg(ptTo - ptFrom);
				vLnSeg.normalize();
				Vector3d vPerp = vzEl.crossProduct(vLnSeg);
				
				if( !bDirectionIsChecked && ((ppNetto.pointInProfile(ptMid+vPerp) == _kPointOutsideProfile && !bIsOpening) ||
					 (ppNetto.pointInProfile(ptMid+vPerp) == _kPointInProfile && bIsOpening)) ){
					plNetto.reverse();
					arPtPl = plNetto.vertexPoints(false);
					
					bDirectionIsChecked = true;
					j=-1;
					continue;
				}
				bDirectionIsChecked = true;
				
				double dx = vPerp.dotProduct(vxms);
				double dy = vPerp.dotProduct(vyms);
				
				if( dx<-dEps ){
					arPtRight.append(ptFrom);
					arPtRight.append(ptTo);
				}
				else if( dx>dEps ){
					arPtLeft.append(ptFrom);
					arPtLeft.append(ptTo);
				}
				
				if( dy<-dEps ){
					arPtTop.append(ptFrom);
					arPtTop.append(ptTo);
				}
				else if( dy>dEps ){
					arPtBottom.append(ptFrom);
					arPtBottom.append(ptTo);
				}
			}
		}
		
		if(nPosition < 2 ){//Vertical left or right
			if( nPosition == 0 ){
				arPtPerimeter.append(arPtLeft);
			}
			else{
				arPtPerimeter.append(arPtRight);
			}
			
		}
		else if(nPosition < 4){//Horizontal bottom or top
			if( nPosition == 2 ){
				arPtPerimeter.append(arPtBottom);
			}
			else{
				arPtPerimeter.append(arPtTop);
			}
		}
	}
	else{
		if( nSubMapXPerimeterReference > 1 ){ // Reset arPtGBmPerimeterZn if the MapX data is used.
			Map mapOutline = el.subMapX("Outline");
			PLine plOutline;
			if( nSubMapXPerimeterReference == 2 )
				plOutline = PLine(mapOutline.getPLine("Inside"));
			if( nSubMapXPerimeterReference == 3 )
				plOutline = PLine(mapOutline.getPLine("Outside"));
			
			arPtGBmPerimeterZn.setLength(0);
			arPtGBmPerimeterZn.append(plOutline.vertexPoints(true));
		}
		
		Point3d arPtPerimeterRefX[] = lnX.orderPoints(arPtPerimeterRef);
		Point3d arPtPerimeterRefY[] = lnY.orderPoints(arPtPerimeterRef);
		// Check if there are points
		if( arPtPerimeterRefX.length() > 0 &&  arPtPerimeterRefY.length() > 0) {
			// Points at min x - side
			Point3d ptLeft = arPtPerimeterRefX[0];
			Point3d arPtMinPerimeterRefX[] = {
				ptLeft
			};
			for( int i=1;i<arPtPerimeterRefX.length();i++ ){
				Point3d pt = arPtPerimeterRefX[i];
				double d = vxms.dotProduct(pt - arPtMinPerimeterRefX[0]);
				Point3d x = pt;
				x.transformBy(ms2ps);
				x.vis(i);
				
				if( abs(vxms.dotProduct(pt - arPtMinPerimeterRefX[0])) > (2 * dEps) )
					break;
				arPtMinPerimeterRefX.append(pt);
			}
			arPtMinPerimeterRefX = lnY.orderPoints(arPtMinPerimeterRefX);
				
			// Points at max x - side
			Point3d ptRight = arPtPerimeterRefX[arPtPerimeterRefX.length() - 1];
			Point3d arPtMaxPerimeterRefX[] = {
				ptRight
			};
			for( int i=(arPtPerimeterRefX.length() - 2);i>=0;i-- ){
				Point3d pt = arPtPerimeterRefX[i];
				if( abs(vxms.dotProduct(pt - arPtMaxPerimeterRefX[0])) > (2 * dEps) )
					break;
				arPtMaxPerimeterRefX.append(pt);
			}
			arPtMaxPerimeterRefX = lnY.orderPoints(arPtMaxPerimeterRefX);
			
			// Points at min y - side
			Point3d ptBottom = arPtPerimeterRefY[0];
			Point3d arPtMinPerimeterRefY[] = {
				ptBottom
			};
			for( int i=1;i<arPtPerimeterRefY.length();i++ ){
				Point3d pt = arPtPerimeterRefY[i];
				Point3d p = ptBottom;
				p.transformBy(ms2ps);
				p.vis(3);
				double d=abs(vyms.dotProduct(pt - arPtMinPerimeterRefY[0]));
				if( abs(vyms.dotProduct(pt - arPtMinPerimeterRefY[0])) > (2 * dEps) )
					break;
				arPtMinPerimeterRefY.append(pt);
			}
			arPtMinPerimeterRefY = lnX.orderPoints(arPtMinPerimeterRefY);
				
			// Points at max y - side
			Point3d ptTop = arPtPerimeterRefY[arPtPerimeterRefY.length() - 1];
			Point3d arPtMaxPerimeterRefY[] = {
				ptTop
			};
			for( int i=(arPtPerimeterRefY.length() - 2);i>=0;i-- ){
				Point3d pt = arPtPerimeterRefY[i];
				if( abs(vyms.dotProduct(pt - arPtMaxPerimeterRefY[0])) > (2 * dEps) )
					break;
				arPtMaxPerimeterRefY.append(pt);
			}
			arPtMaxPerimeterRefY = lnX.orderPoints(arPtMaxPerimeterRefY);
			
			if( 	arPtMinPerimeterRefX.length() > 0 && arPtMaxPerimeterRefX.length() > 0 && 
				arPtMaxPerimeterRefY.length() > 0 && arPtMinPerimeterRefY.length() > 0 
			) {			
				// 8-sided points
				Point3d ptPerimeterRefMinXMinY = arPtMinPerimeterRefX[0];
				Point3d ptPerimeterRefMinXMaxY = arPtMinPerimeterRefX[arPtMinPerimeterRefX.length() - 1];
				Point3d ptPerimeterRefMaxXMinY = arPtMaxPerimeterRefX[0];
				Point3d ptPerimeterRefMaxXMaxY = arPtMaxPerimeterRefX[arPtMaxPerimeterRefX.length() - 1];
				
				Point3d ptPerimeterRefMinYMinX = arPtMinPerimeterRefY[0];
				Point3d ptPerimeterRefMinYMaxX = arPtMinPerimeterRefY[arPtMinPerimeterRefY.length() - 1];
				Point3d ptPerimeterRefMaxYMinX = arPtMaxPerimeterRefY[0];
				Point3d ptPerimeterRefMaxYMaxX = arPtMaxPerimeterRefY[arPtMaxPerimeterRefY.length() - 1];
				
				if(nPosition < 2 ){//Vertical left or right
					arPtPerimeter.append(ptPerimeterRefMinYMinX);
					arPtPerimeter.append(ptPerimeterRefMaxYMinX);
					if( nPosition == 0 ){
						arPtPerimeter.append(ptPerimeterRefMinXMinY);
						arPtPerimeter.append(ptPerimeterRefMinXMaxY);
					}
					else{
						arPtPerimeter.append(ptPerimeterRefMaxXMinY);
						arPtPerimeter.append(ptPerimeterRefMaxXMaxY);		
					}
					
				}
				else if(nPosition < 4){//Horizontal bottom or top
					arPtPerimeter.append(ptPerimeterRefMinXMinY);
					arPtPerimeter.append(ptPerimeterRefMaxXMinY);
					if( nPosition == 2 ){
						arPtPerimeter.append(ptPerimeterRefMinYMinX);
						arPtPerimeter.append(ptPerimeterRefMinYMaxX);
					}
					else{
						arPtPerimeter.append(ptPerimeterRefMaxYMinX);
						arPtPerimeter.append(ptPerimeterRefMaxYMaxX);
					}
				}
			}
		}
	}
		
	arPtPerimeter = lnOrder.orderPoints(arPtPerimeter);
	if( arPtPerimeter.length() > 0 ){ 
		if( nSideRef == _kLeft || nSideRef == _kLeftAndRight )
			arPtRefToDim.append(arPtPerimeter[0]);
		if( nSideRef == _kRight || nSideRef == _kLeftAndRight )
			arPtRefToDim.append(arPtPerimeter[arPtPerimeter.length() - 1]);
		if (nSideRef == _kCenter)
			arPtRefToDim.append((arPtPerimeter[0] + arPtPerimeter[arPtPerimeter.length() - 1])/2);
	}
}
else if (nReference == 11)
{
	String componentIndexesAsString[] = componentIndexRef.tokenize(";");
	int componentIndexes[0];
	for (int index=0;index<componentIndexesAsString.length();index++) 
	{ 
		String componentIndexeAsString = componentIndexesAsString[index]; 
		componentIndexes.append(componentIndexeAsString.atoi());
	}
	
	if (componentIndexes.find(-1) != -1 || componentIndexes.length() < 1)
	{
		arPtRefToDim.append(lnMs.collectDimPoints(arSip,nSideRef));
	}
	else
	{
		for (int s=0;s<arSip.length();s++)
		{
			Sip sip = arSip[s];
			
			Body sipComponent;
			
			for (int index=0;index<componentIndexes.length();index++) 
			{ 
				int componentIndex = componentIndexes[index]; 
				sipComponent += sip.realBodyOfComponentAt(componentIndex);
			}
						
			Point3d componentVertices[0];
			if (componentFaceRef == 0)
			{
				Plane internalPlane(sip.ptCen() - sip.vecD(vzEl) * 0.5 * sip.dD(vzEl), sip.vecD(vzEl));
				PlaneProfile internalFace = sipComponent.extractContactFaceInPlane(internalPlane, U(100));
				componentVertices.append(internalFace.getGripVertexPoints());
			}
			else if (componentFaceRef == 1)
			{
				Plane externalPlane(sip.ptCen() + sip.vecD(vzEl) * 0.5 * sip.dD(vzEl), sip.vecD(vzEl));
				PlaneProfile externalFace = sipComponent.extractContactFaceInPlane(externalPlane, U(100));
				componentVertices.append(externalFace.getGripVertexPoints());
			}
			else
			{
				componentVertices.append(sipComponent.allVertices());
			}
			componentVertices = lnOrder.orderPoints(componentVertices);
			if (componentVertices.length() == 0)
				continue;
			
			Point3d ptLeft = componentVertices[0];
			Point3d ptRight = componentVertices[componentVertices.length() - 1];
			Point3d ptCenter = (ptLeft + ptRight)/2;
			
			if( nSideRef == _kLeft || nSideRef == _kLeftAndRight )
				arPtRefToDim.append(ptLeft);
			if( nSideRef == _kRight || nSideRef == _kLeftAndRight )
				arPtRefToDim.append(ptRight);
			if( nSideRef == _kCenter )
				arPtRefToDim.append(ptCenter);
		}
	}
}

String objectDescription;
Point3d objectPoints[0];
if (sObject==sArObject[0]) {//Element
	objectPoints.append(arPtRef);

	if(nPosition < 2){//Vertical left or right
		arPtToDim.append(ptMinYMinX);
		arPtToDim.append(ptMaxYMinX);
	}
	else if(nPosition < 4){//Horizontal bottom or top
		arPtToDim.append(ptMinXMinY);
		arPtToDim.append(ptMaxXMinY);
	}
	else{
	}
}

String sMaterial;
if (sObject==sArObject[1] || arSSpecial.find("ZONE") != -1) { //zoneindex 
	if (nZone==0) { // we only take the beams
		Beam arBmToDim[0];
		for (int i=0;i<arBms.length();i++) {
			Beam bm = arBms[i];
			
			if (useRealBodyOfZoneBeam)
			{
				objectPoints.append(bm.realBody().allVertices());			
			}
			else
			{
				objectPoints.append(bm.envelopeBody().allVertices());			
				
			}
			
			if (abs(vOrder.dotProduct(bm.vecX())) < dEps)
				arBmToDim.append(bm);
		}
		
		for(int s1=1;s1<arBmToDim.length();s1++){
			int s11 = s1;
			for(int s2=s1-1;s2>=0;s2--){
				if( vOrder.dotProduct(arBmToDim[s11].ptCen()) < vOrder.dotProduct(arBmToDim[s2].ptCen()) ){
					arBmToDim.swap(s2, s11);
					s11=s2;
				}
			}
		}			
		
			

		//Beam arBmToDim[] = vOrder.filterBeamsPerpendicularSort(arBms);
		if( !nDimSideBeams  && arBmToDim.length() > 0 ){
			Beam bmLeft = arBmToDim[0];
			if( abs(vOrder.dotProduct(bmLeft.ptCen() - ptMinXMinY)) < U(100) )
				arBmToDim.removeAt(0);
			
			Beam bmRight = arBmToDim[arBmToDim.length() - 1];
			if( abs(vOrder.dotProduct(bmRight.ptCen() - ptMaxXMinY)) < U(100) )
				arBmToDim.removeAt(arBmToDim.length() - 1);
		}			
		
		if( bCombineTouchingGenBeams){
	   		PlaneProfile ppBm(csEl);
			for( int i=0;i<arBmToDim.length();i++ ){
				Beam bm = arBmToDim[i];
				Beam arBmThis[] = {
					bm
				};
				Point3d arPtDimThisBm[] = lnMs.collectDimPoints(arBmThis,nSide);
				if( arPtDimThisBm.length() > 0 )
				{
					Body beamBody = bm.envelopeBody(false, true);
					if (useRealBodyOfZoneBeam)
					{
						beamBody = bm.realBody();
					}
					PlaneProfile ppThisBm = beamBody.extractContactFaceInPlane(Plane(ptEl, vzEl), U(100));
					ppThisBm.shrink(-0.5 * dMergeTolerance);
					ppBm.unionWith(ppThisBm);
				}
			}
			ppBm.shrink(0.5 * dMergeTolerance);
			PLine arPlBm[] = ppBm.allRings();
			for( int j=0;j<arPlBm.length();j++ ){
				PLine plBm = arPlBm[j];
				Point3d arPtBm[] = plBm.vertexPoints(true);
				
				arPtBm = Line(lnMs.ptOrg(), vOrder).orderPoints(arPtBm);
				if( arPtBm.length() == 0 )
					continue;
				
				if( nSide == _kLeft || nSide == _kLeftAndRight )
					arPtToDim.append(arPtBm[0]);
				if( nSide == _kRight || nSide == _kLeftAndRight )
					arPtToDim.append(arPtBm[arPtBm.length() - 1]);
				if( nSide == _kCenter )
					arPtToDim.append((arPtBm[0] + arPtBm[arPtBm.length() - 1])/2);
			}
			
			ppBm.transformBy(ms2ps);
			ppBm.vis(1);
		}
		else{
			for (int i=0;i<arBmToDim.length();i++) {
				Beam bm  = arBmToDim[i];
				Point3d ptL = bm.ptCen() - vOrder * 0.5 * bm.dD(vOrder);
				Point3d ptR = bm.ptCen() + vOrder * 0.5 * bm.dD(vOrder);
				Body beamBody = bm.realBody();
				if (useRealBodyOfZoneBeam)
				{
					ptL = beamBody.ptCen() - vOrder * 0.5 * beamBody.lengthInDirection(vOrder);
					ptR = beamBody.ptCen() + vOrder * 0.5 * beamBody.lengthInDirection(vOrder);
				}
					
				if (abs(bm.vecD(vOrder).dotProduct(vOrder) < 1 - dEps))
				{
					Body bmBody = bm.realBody();
					Point3d extremeVertices[] = bmBody.extremeVertices(vOrder);
					ptL = extremeVertices[0];
					ptR = extremeVertices[extremeVertices.length() - 1];
				}
				if( nSide == _kLeft || nSide == _kLeftAndRight )
					arPtToDim.append(ptL);
				if( nSide == _kRight || nSide == _kLeftAndRight )
					arPtToDim.append(ptR);
				if (nSide == _kCenter)
					arPtToDim.append((ptL + ptR)/2);
			}
			//arPtToDim.append(lnMs.collectDimPoints(arBmToDim,nSide));
		}
	}
	else { // take the sheeting from a zone
		GenBeam arGBmZn[0];
		Point3d arPtSh[0];
		Sheet arShDimensioned[0];
		if (bCombineTouchingGenBeams && !(bOnlyExtremesOfZone || bOnlySheetJoints)) {
			PlaneProfile ppZn(csEl);
			for( int i=0;i<arGBeams.length();i++ ){
				GenBeam gBm = arGBeams[i];
				
				if (gBm.myZoneIndex() != nZone)
					continue;
					
				objectPoints.append(gBm.envelopeBody().allVertices());
				
				Sheet sh = (Sheet)gBm;
				if (!sh.bIsValid())
					continue;
						
				PlaneProfile ppThisGBm = sh.profShape();//gBm.envelopeBody(false, true).extractContactFaceInPlane(Plane(ptEl, gBm.vecD(vzEl)), U(100));
				ppThisGBm.shrink(-0.5 * dMergeTolerance);
				ppZn.unionWith(ppThisGBm);
			}
			ppZn.shrink(0.5 * dMergeTolerance);
			PLine arPlZn[] = ppZn.allRings();
			for( int j=0;j<arPlZn.length();j++ ){
				PLine plZn = arPlZn[j];
				Point3d arPtZn[] = plZn.vertexPoints(true);
				arPtZn = Line(lnMs.ptOrg(), vOrder).orderPoints(arPtZn);
				if( arPtZn.length() == 0 )
					continue;
				
				if( nSide == _kLeft || nSide == _kLeftAndRight )
					arPtSh.append(arPtZn[0]);
				if( nSide == _kRight || nSide == _kLeftAndRight )
					arPtSh.append(arPtZn[arPtZn.length() - 1]);
				if( nSide == _kCenter )
					arPtSh.append((arPtZn[0] + arPtZn[arPtZn.length() - 1])/2);
			}
			
			ppZn.transformBy(ms2ps);
			ppZn.vis(3);
		}
		else 
		{
			int bMaterialSet = false;
			for( int i=0;i<arGBeams.length();i++ ){
				GenBeam gBm = arGBeams[i];
				
				if( gBm.myZoneIndex() == nZone ){
					Sheet sh = (Sheet)gBm;
					
					objectPoints.append(gBm.envelopeBody().allVertices());
					
					if (!bMaterialSet){
						sMaterial = gBm.material();
						bMaterialSet = true;
					}
					else{
						if (sMaterial.find(gBm.material(),0) == -1)
							sMaterial += ("/"+gBm.material());
					}
					
					if( sh.bIsValid() ){
						Point3d arPtThisSh[] = sh.profShape().getGripVertexPoints();
						Point3d arPtThisShX[] = Line(lnMs.ptOrg(), vOrder).orderPoints(arPtThisSh);
						if( arPtThisShX.length() < 2 )
							continue;
						
						if( nSide == _kLeft || nSide == _kLeftAndRight ){
							Point3d arPtLeft[] = {
								arPtThisShX[0]
							};
							//for( int j=1;j<arPtThisShX.length();j++ ){
								//Point3d pt = arPtThisShX[j];
								//double d = abs(vOrder.dotProduct(pt - arPtThisShX[0]));
								//if( abs(vOrder.dotProduct(pt - arPtThisShX[0])) > dEps )
									//break;
								//arPtLeft.append(pt);
							//}
							arPtSh.append(arPtLeft);
						}
						if( nSide == _kRight || nSide == _kLeftAndRight ){
							Point3d arPtRight[] = {
								arPtThisShX[arPtThisShX.length() - 1]
							};
							//for( int j=(arPtThisShX.length() - 2);j>0;j-- ){
								//Point3d pt = arPtThisShX[j];
								//if( abs(vOrder.dotProduct(pt - arPtThisShX[arPtThisShX.length() - 1])) > dEps )
									//break;
								//arPtRight.append(pt);
							//}
							arPtSh.append(arPtRight);
						}
						arShDimensioned.append(sh);
					}
					else{
						arPtSh.append(gBm.dimPoints(lnMs, nSide));
					}
				}
			}
//			arPtSh.append(lnMs.collectDimPoints(arGBmZn,nSide));
			//Point3d arPtSh[] = lnMs.collectDimPoints(arGBmZn,nSide);
			arPtSh = Line(lnMs.ptOrg(), vOrder).orderPoints(arPtSh);
		}
		
		Point3d arPtExtremes[0];
		if( bOnlyExtremesOfZone || bOnlySheetJoints ){
			if( arPtSh.length() > 0 ){
				if( nSide == _kLeft || nSide == _kLeftAndRight )
					arPtExtremes.append(arPtSh[0]);
				if( nSide == _kRight || nSide == _kLeftAndRight )
					arPtExtremes.append(arPtSh[arPtSh.length() - 1]);
			}
	
			if( bOnlyExtremesOfZone )
				arPtSh = arPtExtremes;
		}
		
		Point3d arPtShJoints[0];
		if( bOnlySheetJoints ){
			double dMaxGapSheetJoint = U(5);
			for( int i=0;i<arShDimensioned.length();i++ ){
				Sheet sh = arShDimensioned[i];
				
				Point3d arPtThisSh[] = sh.profShape().getGripVertexPoints();
				Point3d arPtThisShX[] = Line(lnMs.ptOrg(), vOrder).orderPoints(arPtThisSh);
				if( arPtThisShX.length() < 2 )
					continue;
				
				Point3d ptLeft = arPtThisShX[0];
				Point3d ptRight = arPtThisShX[arPtThisShX.length() - 1];
				
				for( int j=0;j<arShDimensioned.length();j++ ){
					if( i==j )
						continue;
					
					Sheet shCheck = arShDimensioned[j];
					
					Point3d arPtCheckSh[] = shCheck.profShape().getGripVertexPoints();
					Point3d arPtCheckShX[] = Line(lnMs.ptOrg(), vOrder).orderPoints(arPtCheckSh);
					if( arPtCheckShX.length() < 2 )
						continue;
					
					Point3d ptCheckLeft = arPtCheckShX[0];
					Point3d ptCheckRight = arPtCheckShX[arPtCheckShX.length() - 1];
					
					Vector3d vCheck = vOrder;
					int bPtLeftOnShJoint = false;
					int bPtRightOnShJoint = false;
					if( abs(vCheck.dotProduct(ptLeft - ptCheckLeft)) < dMaxGapSheetJoint || abs(vCheck.dotProduct(ptLeft - ptCheckRight)) < dMaxGapSheetJoint )
						bPtLeftOnShJoint = true;
					
					if( abs(vCheck.dotProduct(ptRight - ptCheckLeft)) < dMaxGapSheetJoint || abs(vCheck.dotProduct(ptRight - ptCheckRight)) < dMaxGapSheetJoint )
						bPtRightOnShJoint = true;
					
					// At least one of the sides has to be on a joint.
					if( !(bPtLeftOnShJoint || bPtRightOnShJoint) )
						continue;
					
					if( bPtLeftOnShJoint && (nSide == _kLeft || nSide == _kLeftAndRight) )
						arPtShJoints.append(ptLeft);
					if( bPtRightOnShJoint && (nSide == _kRight || nSide == _kLeftAndRight) )
						arPtShJoints.append(ptRight);
				}
			}
			
			arPtSh = arPtExtremes;
			arPtSh.append(arPtShJoints);
			arPtSh = Line(lnMs.ptOrg(), vOrder).orderPoints(arPtSh);
		}
		
		if( bIgnoreSinglePoints && !bOnlySheetJoints ){
			if( arPtSh.length() > 0 ){
				Point3d ptPrev = arPtSh[0];
				Point3d arPtTmp[] = {ptPrev};
				for( int i=1;i<arPtSh.length();i++ ){
					Point3d ptThis = arPtSh[i];
					if( abs(vOrder.dotProduct(ptThis - ptPrev)) < U(1) || i==(arPtSh.length()-1) )
						arPtTmp.append(ptThis);
					ptPrev = ptThis;
				}
				arPtSh = arPtTmp;
			}
		}
		
		if( arPtSh.length() < 1 )
			return;
		arPtToDim.append(arPtSh);
		
		for (int s=0;s<arPtSh.length();s++) {
			Point3d p = arPtSh[s];
			p.transformBy(ms2ps);
			p.vis(s);
		}
	}
}

if (sObject==sArObject[2]) {//TSL
	Point3d pt(0,0,0);
	int nNrOfPoints = arPtToDim.length();
	for(int i = 0; i < arTsl.length(); i++){
		TslInst tsl = arTsl[i];
		if( !tsl.bIsValid() ){
			tsl.dbErase();
			continue;
		}

		if(sTsl == "All"){
			if( dimensionTslOrigin )
				arPtToDim.append(tsl.ptOrg());
			if ( dimensionTslGripPoints) {
				int p = 0;
				while( Vector3d(tsl.gripPoint(p) - pt).length() > 0 ){
					arPtToDim.append(tsl.gripPoint(p));
					p++;
				}
			}
		}
		else if(tsl.scriptName() == sTsl || sSpecial.find(tsl.scriptName(), 0) != -1 ){
			Map mapTsl = tsl.map();
			int bDimTsl = true;
			for (int j=0;j<mapTsl.length();j++) {
				if (mapTsl.keyAt(j) != "DimInfo" || !mapTsl.hasMap(j))
					continue;
				
				int bDimPointsFromMap = true;
				Map mapDimInfo = mapTsl.getMap(j);
				int tslZoneIndexes[0];
				int zoneIndexFound = false;
				
				if( mapDimInfo.hasInt("ZoneIndex") ){
					int nZn = mapDimInfo.getInt("ZoneIndex");
					zoneIndexFound = arNTslZone.find(nZn) != -1;
					
					if (mapDimInfo.hasMap("AffectedZoneIndex[]"))
					{
						tslZoneIndexes.setLength(0);
						Map affectedZones = mapDimInfo.getMap("AffectedZoneIndex[]");
						for (int m=0;m<affectedZones.length();m++)
						{
							int affectedZoneIndex = affectedZones.getInt(m);
							if (arNTslZone.find(affectedZoneIndex) != -1)
							{
								zoneIndexFound = true;
								break;
							}
						}
					}
					
					if( arNTslZone.length() > 0 && !zoneIndexFound ) {
						bDimTsl = false;
						continue;
					}
				}
				else if (arNTslZone.length() > 0) { // dont allow this tsl to be dimensioned if the zone is set in this dimension tsl, but the tsl to dimension doesn't have zone info attahced as map data.
					bDimTsl = false;
					continue;
				}

				int subTypeFound = false;
				if (mapDimInfo.hasString("SubType")) {
					String sSubType = mapDimInfo.getString("SubType").makeUpper();
					subTypeFound = (arSTslSubType.find(sSubType) != -1);
					if (arSTslSubType.length() > 0 && !subTypeFound) {
						bDimTsl = false;
						continue;
					}
					else if (subTypeFound && sSubType == "PERPENDICULAR") {
						if (mapDimInfo.hasVector3d("Direction")) {
							Vector3d direction = mapDimInfo.getVector3d("Direction");
							if (abs(direction.dotProduct(vOrder)) > dEps) {
								bDimTsl = false;
								continue;
							}
						}
						else {
							bDimTsl = false;
							continue;
						}
					}
				}
				else if (arSTslSubType.length() > 0) { // dont allow this tsl to be dimensioned if the subtype is set in this dimension tsl, but the tsl to dimension doesn't have subtype info attahced as map data.
					bDimTsl = false;
					continue;
				}

				
				if( mapDimInfo.hasPoint3dArray("Points") && (zoneIndexFound || subTypeFound || (arSTslSubType.length() == 0 && !mapDimInfo.hasString("SubType") && arNTslZone.length() == 0 && !mapDimInfo.hasInt("ZoneIndex"))))
					arPtToDim.append(mapDimInfo.getPoint3dArray("Points"));
				
				if (nSide == _kCenter) 
				{
					Point3d dimPoints[0];
					dimPoints= arPtToDim;
					dimPoints = lnOrder.orderPoints(dimPoints);
					if (dimPoints.length() > 0) 
					{
						arPtToDim.setLength(0);
						arPtToDim.append((dimPoints[0] + dimPoints[dimPoints.length() - 1])/2);
					}
				}
			}
			if (!bDimTsl)
				continue;
			
			if( dimensionTslOrigin )
				arPtToDim.append(tsl.ptOrg());
			
			if (dimensionTslGripPoints) {
				int p = 0;
				while( Vector3d(tsl.gripPoint(p) - pt).length() > 0 ){
					arPtToDim.append(tsl.gripPoint(p));
					p++;
				}
			}
		}
	}
	objectPoints.append(arPtToDim);
	if( arPtToDim.length() == nNrOfPoints )
		return;
}

if (sObject==sArObject[3]) {//Perimeter
	if( nSubMapXPerimeter == 1 )
	{
		Point3d arPtLeft[0];
		Point3d arPtRight[0];
		Point3d arPtBottom[0];
		Point3d arPtTop[0];
		
		PlaneProfile ppNetto(csEl);
		for (int i=0;i<perimeterZoneIndexes.length();i++)
		{
			PlaneProfile perimeterProfile = el.profNetto(perimeterZoneIndexes[i]);
			perimeterProfile.shrink(-U(5));
			ppNetto.unionWith(perimeterProfile);
		}
		ppNetto.shrink(U(5));
		
		PLine arPlNetto[] = ppNetto.allRings();
		int arBIsOpening[] = ppNetto.ringIsOpening();
		for( int i=0;i<arPlNetto.length();i++ ){
			PLine plNetto = arPlNetto[i];
			int bIsOpening = arBIsOpening[i];
			
			if (!perimeterWithOpenings && bIsOpening)
				continue;
			
			int bDirectionIsChecked = false;
			Point3d arPtPl[] = plNetto.vertexPoints(false);
			for( int j=0;j<(arPtPl.length() - 1);j++ )
			{
				Point3d ptFrom = arPtPl[j];
				Point3d ptTo = arPtPl[j+1];
				Point3d ptMid = (ptFrom + ptTo)/2;
				
				Vector3d vLnSeg(ptTo - ptFrom);
				vLnSeg.normalize();
				Vector3d vPerp = vzEl.crossProduct(vLnSeg);
				
				if( !bDirectionIsChecked && ((ppNetto.pointInProfile(ptMid+vPerp) == _kPointOutsideProfile && !bIsOpening) ||
					 (ppNetto.pointInProfile(ptMid+vPerp) == _kPointInProfile && bIsOpening)) ){
					plNetto.reverse();
					arPtPl = plNetto.vertexPoints(false);
					
					bDirectionIsChecked = true;
					j=-1;
					continue;
				}
				bDirectionIsChecked = true;
				
				double dx = vPerp.dotProduct(vxms);
				double dy = vPerp.dotProduct(vyms);
				
				if( dx<-dEps ){
					arPtRight.append(ptFrom);
					arPtRight.append(ptTo);
				}
				else if( dx>dEps ){
					arPtLeft.append(ptFrom);
					arPtLeft.append(ptTo);
				}
				
				if( dy<-dEps ){
					arPtTop.append(ptFrom);
					arPtTop.append(ptTo);
				}
				else if( dy>dEps ){
					arPtBottom.append(ptFrom);
					arPtBottom.append(ptTo);
				}
			}
		}
		
		if (perimeterDimensionMode == 2)
		{
			Point3d perimeterVertices[0];
			perimeterVertices.append(arPtLeft);
			perimeterVertices.append(arPtBottom);
			perimeterVertices.append(arPtRight);
			perimeterVertices.append(arPtTop);
			Point3d perimeterVerticesX[] = lnX.orderPoints(perimeterVertices);
			Point3d perimeterVerticesY[] = lnY.orderPoints(perimeterVertices);
			if ((perimeterVerticesX.length() * perimeterVerticesY.length()) > 0)
			{
				arPtToDim.append(perimeterVerticesX.first() + vyms * vyms.dotProduct(perimeterVerticesY.first() - perimeterVerticesX.first()));
				arPtToDim.append(perimeterVerticesX.last() + vyms * vyms.dotProduct(perimeterVerticesY.last() - perimeterVerticesX.last()));
			}
		}
		else
		{
			arPtLeft = lnY.orderPoints(arPtLeft);
			arPtRight = lnY.orderPoints(arPtRight);
			arPtBottom = lnX.orderPoints(arPtBottom);
			arPtTop = lnX.orderPoints(arPtTop);
			
			if (nPosition < 2 )
			{
				//Vertical left or right
				if ( nPosition == 0 ) 
				{
					if (arPtLeft.length() > 0)
					{
						if (perimeterDimensionMode == 0)
						{
							arPtToDim.append(arPtLeft);
						}
						else
						{
							arPtToDim.append(arPtLeft.first());
							arPtToDim.append(arPtLeft.last());
						}
					}
				}
				else 
				{
					if (arPtRight.length() > 0)
					{
						if (perimeterDimensionMode == 0)
						{
							arPtToDim.append(arPtRight);
						}
						else
						{
							arPtToDim.append(arPtRight.first());
							arPtToDim.append(arPtRight.last());
						}
					}
				}
				
			}
			else if (nPosition < 4)
			{
				//Horizontal bottom or top
				if ( nPosition == 2 ) 
				{
					if (arPtBottom.length() > 0)
					{
						if (perimeterDimensionMode == 0)
						{
							arPtToDim.append(arPtBottom);
						}
						else
						{
							arPtToDim.append(arPtBottom.first());
							arPtToDim.append(arPtBottom.last());
						}
					}
				}
				else 
				{
					if (arPtTop.length() > 0)
					{
						if (perimeterDimensionMode == 0)
						{
							arPtToDim.append(arPtTop);
						}
						else
						{
							arPtToDim.append(arPtTop.first());
							arPtToDim.append(arPtTop.last());
						}
					}
				}
			}
		}
	}
	else
	{
		if ( nSubMapXPerimeter > 1 ) 
		{ //Reset arPtGBmPerimeterZn if the MapX data is used.
			Map mapOutline = el.subMapX("Outline");
			PLine plOutline;
			if ( nSubMapXPerimeter == 2 )
				plOutline = PLine(mapOutline.getPLine("Inside"));
			if ( nSubMapXPerimeter == 3 )
				plOutline = PLine(mapOutline.getPLine("Outside"));
			
			arPtGBmPerimeterZn.setLength(0);
			arPtGBmPerimeterZn.append(plOutline.vertexPoints(true));
		}
		
		Point3d perimeterLeft[0];
		Point3d perimeterBottom[0];
		Point3d perimeterRight[0];
		Point3d perimeterTop[0];
		PLine perimeterRings[] = ppPerimeter.allRings();
		int perimeterRingsAreOpening[] = ppPerimeter.ringIsOpening();
		
		PLine perimeterOutlines[0];
		for (int r = 0; r < perimeterRings.length(); r++)
		{
			if (perimeterRingsAreOpening[r]) continue;
			perimeterOutlines.append(perimeterRings[r]);
		}
		for (int p = 0; p < perimeterOutlines.length(); p++)
		{
			PLine perimeterOutline = perimeterOutlines[p];
			
			Point3d perimeterVertices[] = perimeterOutline.vertexPoints(false);
			
			int loopProtector = 0;
			for (int v = 1; v < perimeterVertices.length(); v++)
			{
				Point3d from = perimeterVertices[v - 1];
				Point3d to = perimeterVertices[v];
				
				Vector3d direction(to - from);
				direction.normalize();
				
				// check direction
				if (v == 1 && loopProtector == 0)
				{
					loopProtector++;
					if (loopProtector > 1) break;
					
					Point3d mid = (from + to) / 2;
					Vector3d normal = vzms.crossProduct(direction);
					
					PlaneProfile perimeterOutlineProfile(perimeterOutline);
					if (perimeterOutlineProfile.pointInProfile(mid + normal) != _kPointInProfile)
					{
						perimeterOutline.reverse();
						perimeterVertices = perimeterOutline.vertexPoints(false);
						
						v--;
						continue;
					}
				}
				
				double dx = vxms.dotProduct(direction);
				double dy = vyms.dotProduct(direction);
				
				if (abs(dx) < vectorTolerance) //vertical
				{
					if (dy > 0) //right
					{
						perimeterRight.append(from);
						perimeterRight.append(to);
					}
					else
					{
						perimeterLeft.append(from);
						perimeterLeft.append(to);
					}
				}
				if (abs(dy) < vectorTolerance) //horizontal
				{
					if (dx > 0) //bottom
					{
						perimeterBottom.append(from);
						perimeterBottom.append(to);
					}
					else
					{
						perimeterTop.append(from);
						perimeterTop.append(to);
					}
				}
				else
				{
					if (dx > 0)
					{
						perimeterBottom.append(from);
						perimeterBottom.append(to);
						
						if (dy > 0)
						{
							perimeterRight.append(from);
							perimeterRight.append(to);
						}
						else
						{
							perimeterLeft.append(from);
							perimeterLeft.append(to);
						}
					}
					else
					{
						perimeterTop.append(from);
						perimeterTop.append(to);
						
						if (dy > 0)
						{
							perimeterLeft.append(from);
							perimeterLeft.append(to);
						}
						else
						{
							perimeterRight.append(from);
							perimeterRight.append(to);
						}
					}
				}
			}
		}
		
		
		Point3d arPtGBmPerimeterZnX[] = lnX.orderPoints(arPtGBmPerimeterZn);
		Point3d arPtGBmPerimeterZnY[] = lnY.orderPoints(arPtGBmPerimeterZn);
		// Check if there are points
		if ( (arPtGBmPerimeterZnX.length() * arPtGBmPerimeterZnY.length()) == 0 )
			return;
		
		// Points at min x - side
		Point3d ptLeft = arPtGBmPerimeterZnX[0];
		Point3d arPtMinPerimeterZnX[] = {
			ptLeft
		};
		for ( int i = 1; i < arPtGBmPerimeterZnX.length(); i++) {
			Point3d pt = arPtGBmPerimeterZnX[i];
			double d = vxms.dotProduct(pt - arPtMinPerimeterZnX[0]);
			Point3d x = pt;
			x.transformBy(ms2ps);
			x.vis(i);
			
			if ( abs(vxms.dotProduct(pt - arPtMinPerimeterZnX[0])) > (2 * dEps) )
				break;
			arPtMinPerimeterZnX.append(pt);
		}
		arPtMinPerimeterZnX = lnY.orderPoints(arPtMinPerimeterZnX);
		if ( arPtMinPerimeterZnX.length() == 0 )
			return;
		
		// Points at max x - side
		Point3d ptRight = arPtGBmPerimeterZnX[arPtGBmPerimeterZnX.length() - 1];
		Point3d arPtMaxPerimeterZnX[] = {
			ptRight
		};
		for ( int i = (arPtGBmPerimeterZnX.length() - 2); i >= 0; i--) {
			Point3d pt = arPtGBmPerimeterZnX[i];
			if ( abs(vxms.dotProduct(pt - arPtMaxPerimeterZnX[0])) > (2 * dEps) )
				break;
			arPtMaxPerimeterZnX.append(pt);
		}
		arPtMaxPerimeterZnX = lnY.orderPoints(arPtMaxPerimeterZnX);
		if ( arPtMaxPerimeterZnX.length() == 0 )
			return;
		
		// Points at min y - side
		Point3d ptBottom = arPtGBmPerimeterZnY[0];
		Point3d arPtMinPerimeterZnY[] = {
			ptBottom
		};
		for ( int i = 1; i < arPtGBmPerimeterZnY.length(); i++) {
			Point3d pt = arPtGBmPerimeterZnY[i];
			Point3d p = ptBottom;
			p.transformBy(ms2ps);
			p.vis(3);
			double d = abs(vyms.dotProduct(pt - arPtMinPerimeterZnY[0]));
			if ( abs(vyms.dotProduct(pt - arPtMinPerimeterZnY[0])) > (2 * dEps) )
				break;
			arPtMinPerimeterZnY.append(pt);
		}
		arPtMinPerimeterZnY = lnX.orderPoints(arPtMinPerimeterZnY);
		if ( arPtMinPerimeterZnY.length() == 0 )
			return;
		
		// Points at max y - side
		Point3d ptTop = arPtGBmPerimeterZnY[arPtGBmPerimeterZnY.length() - 1];
		Point3d arPtMaxPerimeterZnY[] = {
			ptTop
		};
		for ( int i = (arPtGBmPerimeterZnY.length() - 2); i >= 0; i--) {
			Point3d pt = arPtGBmPerimeterZnY[i];
			if ( abs(vyms.dotProduct(pt - arPtMaxPerimeterZnY[0])) > (2 * dEps) )
				break;
			arPtMaxPerimeterZnY.append(pt);
		}
		arPtMaxPerimeterZnY = lnX.orderPoints(arPtMaxPerimeterZnY);
		if ( arPtMaxPerimeterZnY.length() == 0 )
			return;
		
		// 8-sided points
		Point3d ptPerimeterZnMinXMinY = arPtMinPerimeterZnX[0];
		Point3d ptPerimeterZnMinXMaxY = arPtMinPerimeterZnX[arPtMinPerimeterZnX.length() - 1];
		Point3d ptPerimeterZnMaxXMinY = arPtMaxPerimeterZnX[0];
		Point3d ptPerimeterZnMaxXMaxY = arPtMaxPerimeterZnX[arPtMaxPerimeterZnX.length() - 1];
		Point3d ptPerimeterZnMinYMinX = arPtMinPerimeterZnY[0];
		Point3d ptPerimeterZnMinYMaxX = arPtMinPerimeterZnY[arPtMinPerimeterZnY.length() - 1];
		Point3d ptPerimeterZnMaxYMinX = arPtMaxPerimeterZnY[0];
		Point3d ptPerimeterZnMaxYMaxX = arPtMaxPerimeterZnY[arPtMaxPerimeterZnY.length() - 1];
		Point3d perimeterMin = ptPerimeterZnMinXMinY + vyms * vyms.dotProduct(ptPerimeterZnMinYMinX - ptPerimeterZnMinXMinY);
		Point3d perimeterMax = ptPerimeterZnMaxXMaxY + vyms * vyms.dotProduct(ptPerimeterZnMaxYMaxX - ptPerimeterZnMaxXMaxY);
		
		if (perimeterDimensionMode == 2 )
		{
			arPtToDim.append(perimeterMin);
			arPtToDim.append(perimeterMax);
		}
		else
		{
			if (nPosition < 2 )
			 {
			 	//Vertical left or right
				arPtToDim.append(ptPerimeterZnMinYMinX);
				arPtToDim.append(ptPerimeterZnMaxYMinX);
				if ( nPosition == 0 )
				{
					if ( perimeterDimensionMode == 0 )
					{
						arPtToDim.append(perimeterLeft);
					}
					else if ( perimeterDimensionMode == 1 )
					{
						arPtToDim.append(ptPerimeterZnMinXMinY);
						arPtToDim.append(ptPerimeterZnMinXMaxY);
					}
					else {
						//arPtToDim.append(perimeterLeft);//arPtMinPerimeterZnX);
					}
				}
				else
				{
					if ( perimeterDimensionMode == 0 )
					{
						arPtToDim.append(perimeterRight);
					}
					else if ( perimeterDimensionMode == 1 )
					{
						arPtToDim.append(ptPerimeterZnMaxXMinY);
						arPtToDim.append(ptPerimeterZnMaxXMaxY);
					}
					else
					{
						//arPtToDim.append(perimeterRight);//arPtMaxPerimeterZnX);
					}
					
				}
				
			}
			else if (nPosition < 4)
			 {
			 	//Horizontal bottom or top
				arPtToDim.append(ptPerimeterZnMinXMinY);
				arPtToDim.append(ptPerimeterZnMaxXMinY);
				if ( nPosition == 2 )
				{
					if ( perimeterDimensionMode == 0 )
					{
						arPtToDim.append(perimeterBottom);
					}
					else if ( perimeterDimensionMode == 1 )
					{
						arPtToDim.append(ptPerimeterZnMinYMinX);
						arPtToDim.append(ptPerimeterZnMinYMaxX);
					}
					else
					{
						//arPtToDim.append(perimeterBottom);//arPtMinPerimeterZnY);
					}
				}
				else
				{
					if ( perimeterDimensionMode == 0 )
					{
						arPtToDim.append(perimeterTop);
					}
					else if ( perimeterDimensionMode == 1 )
					{
						arPtToDim.append(ptPerimeterZnMaxYMinX);
						arPtToDim.append(ptPerimeterZnMaxYMaxX);
					}
					else
					{
						//arPtToDim.append(perimeterTop);//arPtMaxPerimeterZnY);
					}
				}
			}
		}
	}
	
	
	if (perimeterRange > U(0))
	{
		Vector3d vxDimMs = vOrder;
		Vector3d vzDimMs = vzms;
		Vector3d vyDimMs = vzDimMs.crossProduct(vxDimMs);
		PlaneProfile validArea(CoordSys(ptElRef, vxDimMs, vyDimMs, vzDimMs));
		PLine areaOutline;
		areaOutline.createRectangle(LineSeg(ptElRef - vxDimMs * U(25000) - vyDimMs * perimeterRange, ptElRef + vxDimMs * U(25000) + vyDimMs * perimeterRange), vxDimMs, vyDimMs);
		validArea.joinRing(areaOutline, _kAdd);
		
		Point3d validDimensionPoints[0];
		for (int p=0;p<arPtToDim.length();p++)
		{
			Point3d dimensionPoint = arPtToDim[p];
			if (validArea.pointInProfile(dimensionPoint) == _kPointInProfile)
				validDimensionPoints.append(dimensionPoint);
		}
		
		arPtToDim = validDimensionPoints;
	}
}

if( 
	sObject==sArObject[4] || sObject==sArObject[8] || 
	arSSpecial.find("ExtraBeamCodes") != -1 || arSSpecial.find("ExtraBeamCodesInRange") != -1 
) {//Beam with beamcode (8 = within range)
	int bWithRange = ((sObject==sArObject[8] || arSSpecial.find("ExtraBeamCodesInRange") != -1) && dRange > U(0));
	Body bdRange;
	if( bWithRange )
		bdRange = Body(ptElRef, vOrder, vzms.crossProduct(vOrder), vzms, U(50000), 2 * dRange, U(1000));
	
	bdRange.vis(3);
	el.plEnvelope().vis(4);
	GenBeam arGBmZn[0];	
	//Take all beams not only filtered
	Point3d arPtBmCode[0];
	for(int i=0;i<arGBmAll.length();i++){
		GenBeam gBm = arGBmAll[i];

		String sBmCode = gBm.beamCode().token(0).makeUpper();
		sBmCode.trimLeft();
		sBmCode.trimRight();
		
		int bValidCode = false;
		if( arSDimBC.find(sBmCode)!= -1 ){
			bValidCode = true;
		}
		else{
			for( int j=0;j<arSDimBC.length();j++ ){
				String sDimBC = arSDimBC[j];
				String sDimBCTrimmed = sDimBC;
				sDimBCTrimmed.trimLeft("*");
				sDimBCTrimmed.trimRight("*");
				if( sDimBC.left(1) == "*" && sDimBC.right(1) == "*" && sBmCode.find(sDimBCTrimmed, 0) != -1 )
					bValidCode = true;
				else if( sDimBC.left(1) == "*" && sBmCode.right(sDimBC.length() - 1) == sDimBCTrimmed )
					bValidCode = true;
				else if( sDimBC.right(1) == "*" && sBmCode.left(sDimBC.length() - 1) == sDimBCTrimmed )
					bValidCode = true;
			}
		}

		if( bValidCode ){
			if( bWithRange ){
				gBm.envelopeBody().vis(1);
				if( !bdRange.hasIntersection(gBm.envelopeBody()) )
					continue;
			}
			arGBmZn.append(gBm);
			
			Body bd = gBm.envelopeBody();
			bd.vis(1);
		}
	}
	
	if( arSSpecial.find("PV1") != -1 ){
		CoordSys csBack(csEl.ptOrg() - csEl.vecZ() * el.zone(0).dH(), csEl.vecX(), csEl.vecY(), csEl.vecZ());
		
		Beam arBmZn[0];
		for( int i=0;i<arGBmZn.length();i++ ){
			Beam bm = (Beam)arGBmZn[i];
			if( bm.bIsValid() )
				arBmZn.append(bm);
		}
		
		arBmZn = vOrder.filterBeamsPerpendicularSort(arBmZn);
		for( int i=0;i<arBmZn.length();i++ ){
			GenBeam gBm = arBmZn[i];
			gBm.realBody().vis();
			
			int nDimSide = 1;
			if( ((i/2.0) - i/2) > 0 )
				nDimSide *= -1;
			
			PlaneProfile ppBm(csBack);	
			ppBm.unionWith(gBm.realBody().extractContactFaceInPlane(Plane(csBack.ptOrg(), csBack.vecZ()), U(10)));
			ppBm.vis(1);
			
			Point3d arPtBm[] = ppBm.getGripVertexPoints();
			arPtBm = lnOrder.orderPoints(arPtBm);
			if( arPtBm.length() == 0 )
				continue;
			
			if( nDimSide == 1 )
				arPtToDim.append(arPtBm[arPtBm.length() - 1]);
			else
				arPtToDim.append(arPtBm[0]);
		}
	}
	if( arSSpecial.find("BC-Back") != -1 ){
		CoordSys csBack(csEl.ptOrg() - csEl.vecZ() * (el.zone(0).dH() - U(0.1)), csEl.vecX(), csEl.vecY(), csEl.vecZ());
		
		Beam arBmZn[0];
		for( int i=0;i<arGBmZn.length();i++ ){
			Beam bm = (Beam)arGBmZn[i];
			if( bm.bIsValid() )
				arBmZn.append(bm);
		}

		for( int i=0;i<arBmZn.length();i++ ){
			GenBeam gBm = arBmZn[i];
			gBm.realBody().vis();
			
			int nDimSide = 1;
			if( ((i/2.0) - i/2) > 0 )
				nDimSide *= -1;
			
			PlaneProfile ppBm(csBack);	
			ppBm.unionWith(gBm.realBody().getSlice(Plane(csBack.ptOrg(), csBack.vecZ())));//extractContactFaceInPlane(Plane(csBack.ptOrg(), csBack.vecZ()), U(10)));
			ppBm.vis(1);
			
			Point3d arPtBm[] = ppBm.getGripVertexPoints();
			arPtBm = lnOrder.orderPoints(arPtBm);
			if( arPtBm.length() == 0 )
				continue;
			
			if( nSide == _kLeft || nSide == _kLeftAndRight )
				arPtToDim.append(arPtBm[0]);
			if( nSide == _kRight || nSide == _kLeftAndRight )
				arPtToDim.append(arPtBm[arPtBm.length() - 1]);
		}
	}
	else if( arSSpecial.find("Face") == -1 ){
		for( int i=0;i<arGBmZn.length();i++ ){
			GenBeam gBm = arGBmZn[i];
			Point3d arPtGBm[] = gBm.realBody().allVertices();
			
			if (sObject == sArObject[8] && nDimPointsWithinRange && dRange > 0)
			{
				for (int p = 0; p < arPtGBm.length(); p++)
				{
					Point3d ptGBm = arPtGBm[p];
					if ( abs(vDimPerp.dotProduct(ptGBm - ptElRef)) > dRange )
					{
						arPtGBm.removeAt(p);
						p--;
					}
				}//next p
			}
			
			Line lnOrder(lnMs.ptOrg(), vOrder);
			arPtGBm = lnOrder.orderPoints(arPtGBm);
			
			if( nSide == _kLeft || nSide == _kLeftAndRight )
				arPtBmCode.append(arPtGBm[0]);
			if( nSide == _kRight || nSide == _kLeftAndRight )
				arPtBmCode.append(arPtGBm[arPtGBm.length() - 1]);
			if( nSide == _kCenter )
				arPtBmCode.append((arPtGBm[0] + arPtGBm[arPtGBm.length() - 1])/2);
		}

		if( arPtBmCode.length() == 0 )
			arPtBmCode.append( lnMs.collectDimPoints(arGBmZn,nSide) );
		if( arPtBmCode.length() == 0 )
			return;
		arPtToDim.append(arPtBmCode);
	}
	else{
		for( int i=0;i<arGBmZn.length();i++ ){
			GenBeam gBm = arGBmZn[i];
			gBm.realBody().vis();
			Plane(lnMs.ptOrg(), vDimPerp).vis();
			PlaneProfile ppGBm = gBm.realBody().extractContactFaceInPlane(Plane(lnMs.ptOrg(), vDimPerp), dOffsetDim + U(100));
			Point3d arPtGBm[] = ppGBm.getGripVertexPoints();
			if( arPtGBm.length() < 2 )
				continue;
			
			if (sObject == sArObject[8] && nDimPointsWithinRange && dRange > 0)
			{
				for (int p = 0; p < arPtGBm.length(); p++)
				{
					Point3d ptGBm = arPtGBm[p];
					if ( abs(vDimPerp.dotProduct(ptGBm - ptElRef)) > dRange )
					{
						arPtGBm.removeAt(p);
						p--;
					}
				}//next p
			}
						
			Line lnOrder(lnMs.ptOrg(), vOrder);
			arPtGBm = lnOrder.orderPoints(arPtGBm);
			
			if( nSide == _kLeft )
				arPtToDim.append(arPtGBm[0]);
			else if( nSide == _kRight )
				arPtToDim.append(arPtGBm[arPtGBm.length() - 1]);
			else
				arPtToDim.append(arPtGBm);
		}
		
		if( arPtToDim.length() == 0 ){
			arPtBmCode.append( lnMs.collectDimPoints(arGBmZn,nSide) );
			if( arPtBmCode.length() == 0 )
				return;
			arPtToDim.append(arPtBmCode);
		}
	}
}

if( sObject==sArObject[5] ) {//Beam with label/name or beamtype
	GenBeam arGBmZn[0];
	//Take all beams not only filtered
	for(int i=0;i<arGBmAll.length();i++){
		GenBeam gBm = arGBmAll[i];
		String sLabel = gBm.label();
		sLabel.makeUpper();
		String sName = gBm.name();
		sName.makeUpper();
		sName.trimLeft();
		sName.trimRight();
		for( int i=0;i<arSDimLbl.length();i++ ){
			String sDimLbl = arSDimLbl[i];
			if( sDimLbl == sLabel ){
				arGBmZn.append(gBm);
				break;
			}

			if( sDimLbl.right(1) == "*" && sLabel.left(sDimLbl.length() - 1) == sDimLbl.left(sDimLbl.length() - 1) ){
				arGBmZn.append(gBm);
				break;
			}
		}
		for( int i=0;i<arSDimLbl.length();i++ ){
			String sDimLbl = arSDimLbl[i];
			if( sDimLbl == sName ){
				arGBmZn.append(gBm);
				break;
			}
			
			if( sDimLbl.right(1) == "*" && sName.left(sDimLbl.length() - 1) == sDimLbl.left(sDimLbl.length() - 1) ){
				arGBmZn.append(gBm);
				break;
			}
		}
	}
	if( arGBmZn.length() == 0 )
		return;

	if (bDimLabelIncludeNonPerpendiculars)//DR 26.10.2018 v4.42
	{
		Point3d pts[0];
		for (int c = 0; c < arGBmZn.length(); c++)
		{
			GenBeam genBeam = arGBmZn[c];
			if ( ! genBeam.bIsValid())
				continue;
			
			Body bdGenBeam = genBeam.envelopeBody();
			Point3d ptExtremes[] = bdGenBeam.extremeVertices(vOrder);
			if (ptExtremes.length() < 2)
				continue;
			
			Point3d ptLeftGbm = ptExtremes[0];
			Point3d ptRightGbm = ptExtremes[ptExtremes.length()-1];
			if (nSide == _kLeft || nSide == _kLeftAndRight)
			{
				pts.append(ptLeftGbm);
			}
			if (nSide == _kRight || nSide == _kLeftAndRight)
			{
				pts.append(ptRightGbm);
			}
			if (nSide == _kCenter)
			{
				pts.append(bdGenBeam.ptCen());
			}
		}
		pts = lnX.orderPoints(pts);
		arPtToDim.append(pts);
	}
	else
		arPtToDim.append( lnMs.collectDimPoints(arGBmZn,nSide) );	
}

if( sObject==sArObject[9] ) {//Beam with beamtype
	for( int i=0;i<arDimBmType.length();i++ ){
		Beam bm = arDimBmType[i];
		Point3d arPtBm[] = bm.envelopeBody(true, true).allVertices();
		
		Line lnOrder(lnMs.ptOrg(), vOrder);
		arPtBm = lnOrder.orderPoints(arPtBm);
		
		if( arPtBm.length() == 0 )
			continue;
		
		if( nSide == _kLeft || nSide == _kLeftAndRight )
			arPtToDim.append(arPtBm[0]);
		if( nSide == _kRight || nSide == _kLeftAndRight )
			arPtToDim.append(arPtBm[arPtBm.length() - 1]);
	}
}

if( sObject==sArObject[10] ) {//Beam with hsbId
	for( int i=0;i<arDimBmID.length();i++ ){
		Beam bm = arDimBmID[i];
		Point3d arPtBm[] = bm.envelopeBody(true, true).allVertices();
		if( arPtBm.length() == 0 )
			continue;
		
		if( nSide == _kCenter ){
			arPtToDim.append((arPtBm[0] + arPtBm[arPtBm.length() - 1])/2);
		}
		else{	
			if( nSide == _kLeft || nSide == _kLeftAndRight )
				arPtToDim.append(arPtBm[0]);
			if( nSide == _kRight || nSide == _kLeftAndRight )
				arPtToDim.append(arPtBm[arPtBm.length() - 1]);
		}
	}
}

if (sObject==sArObject[6]) {//Supporting beams
	Beam arBmSupporting[0];
	for( int i=0;i<arBms.length();i++ ){
		Beam bm = arBms[i];
		
		if( abs(vzEl.dotProduct(bm.ptCen() - ptEl)) < el.zone(0).dH() )
			continue;
		
		Point3d arPtBm[] = bm.envelopeBody(true, true).allVertices();
		Line lnOrder(lnMs.ptOrg(), vOrder);
		arPtBm = lnOrder.orderPoints(arPtBm);

		if( arPtBm.length() == 0 )
			continue;
		
		if( nSide == _kCenter ){
			arPtToDim.append((arPtBm[0] + arPtBm[arPtBm.length() - 1])/2);
		}
		else if (sSpecial == "Extremes" && nSide != _kLeftAndRight) {
			if( nSide == _kLeft) {
				if (bm.type() == _kDakBackEdge)
					arPtToDim.append(arPtBm[arPtBm.length() - 1]);
				else
					arPtToDim.append(arPtBm[0]);
			}
			if( nSide == _kRight ) {
				if (bm.type() == _kDakBackEdge)
					arPtToDim.append(arPtBm[0]);
				else
					arPtToDim.append(arPtBm[arPtBm.length() - 1]);
			}
		}
		else{	
			if( nSide == _kLeft || nSide == _kLeftAndRight )
				arPtToDim.append(arPtBm[0]);
			if( nSide == _kRight || nSide == _kLeftAndRight )
				arPtToDim.append(arPtBm[arPtBm.length() - 1]);
		}
//
//			arBmSupporting.append(bm);
	}
//	arPtToDim.append( lnMs.collectDimPoints(arBmSupporting,nSide) );
}

if (sObject==sArObject[7]) {//Rafters	
	Point3d arPtDim[0];
	
	if (bCombineTouchingRafters){
		PlaneProfile ppRafterStud(CoordSys(ptEl, vxms, vyms, vzms));//PlaneProfile ppRafterStud(CoordSys(ptEl, vxEl, -vzEl, vyEl));		
		for( int i=0;i<arBmRafter.length();i++ ){
			//if( i==13 )
			//	continue;
			Beam bm = arBmRafter[i];
			String s = bm.name("posnumandtext");
			if( abs(abs(bm.vecX().dotProduct(vyEl)) - 1) > dEps )
				continue;
			
			Point3d ptBmBL = bm.ptCen() - 0.5 * (bm.vecX() * bm.solidLength() + bm.vecY() * bm.dD(bm.vecY()) + bm.vecZ() * bm.dD(bm.vecZ()));
			Point3d ptBmTR = bm.ptCen() + 0.5 * (bm.vecX() * bm.solidLength() + bm.vecY() * bm.dD(bm.vecY()) + bm.vecZ() * bm.dD(bm.vecZ()));
			PLine plRafterStud(vzms);
			plRafterStud.createRectangle(LineSeg(ptBmBL, ptBmTR), vxms, vyms);
			
			PlaneProfile ppThisRafterStud(CoordSys(ptEl, vxms, vyms, vzms));//PlaneProfile ppThisRafterStud(CoordSys(ptEl, vxEl, -vzEl, vyEl));
//			if (abs(abs(vyEl.dotProduct(vzms)) - 1) < dEps)
				
			if (bDimRaftersInsideFrame)
				ppThisRafterStud.unionWith(bm.envelopeBody(true, true).extractContactFaceInPlane(Plane(el.zone(-1).coordSys().ptOrg(), vzms), U(10000)));
			else
				ppThisRafterStud.joinRing(plRafterStud, _kAdd);

			ppThisRafterStud.shrink(-U(1));
			CoordSys csRotate;
			csRotate.setToRotation(0.01, vzms, ptEl);
			ppThisRafterStud.transformBy(csRotate);
			
			PlaneProfile pp = ppThisRafterStud;
			pp.transformBy(vzms * U(250));
			pp.vis(1);
			
			ppRafterStud.unionWith(ppThisRafterStud);

//			ppRafterStud.vis(i);
//			Body bdBm = bm.realBody();
//			bdBm.vis(i);
//			ppRafterStud.unionWith(bdBm.getSlice(Plane(bm.ptCen(), vyEl)));//shadowProfile(Plane(ptEl, vyEl)));
		}
		//Combine rings which are close to each other
//		ppRafterStud.shrink(-U(0.01));
		CoordSys csRotate;
		csRotate.setToRotation(-0.01, vzms, ptEl);
		ppRafterStud.transformBy(csRotate);
		
		ppRafterStud.shrink(U(1));
		ppRafterStud.vis();
		
		//Take the required points from each ring
		PLine arPlRafter[] = ppRafterStud.allRings();
		for( int i=0;i<arPlRafter.length();i++ ){
			PLine pl = arPlRafter[i];
			
			Point3d arPtPl[] = pl.vertexPoints(true);
			Point3d arPtPlX[] = lnOrder.orderPoints(arPtPl);
			if( arPtPlX.length() < 2 )
				continue;
			
			Point3d ptLeft = arPtPlX[0];
			Point3d ptRight = arPtPlX[arPtPlX.length() - 1];
			Point3d ptCenter = (ptLeft + ptRight)/2;
			
			if( nSide == _kLeft || nSide == _kLeftAndRight )
				arPtDim.append(ptLeft);
			if( nSide == _kRight || nSide == _kLeftAndRight )
				arPtDim.append(ptRight);
			if( nSide == _kCenter )
				arPtDim.append(ptCenter);
		}
	}
	else{
		for( int i=0;i<arBmRafter.length();i++ ){
			Beam bm = arBmRafter[i];
			if( abs(abs(bm.vecX().dotProduct(vyEl)) - 1) > dEps )
				continue;
			
			
			Point3d ptCenter = bm.ptCen();
			
			Point3d arPtBm[0];
			if (bDimRaftersInsideFrame) {
				arPtBm.append(bm.envelopeBody(true, true).extractContactFaceInPlane(Plane(el.zone(-1).coordSys().ptOrg(), vzEl), U(10000)).getGripVertexPoints());
			}
			else{
				Point3d ptBmBL = bm.ptCenSolid() - 0.5 * (bm.vecX() * bm.solidLength() + bm.vecY() * bm.dD(bm.vecY()) + bm.vecZ() * bm.dD(bm.vecZ()));
				Point3d ptBmTR = bm.ptCenSolid() + 0.5 * (bm.vecX() * bm.solidLength() + bm.vecY() * bm.dD(bm.vecY()) + bm.vecZ() * bm.dD(bm.vecZ()));

				arPtBm.append(ptBmBL);//ptCenter - vxEl * 0.5 * bm.dD(vxEl));
				arPtBm.append(ptBmTR);//ptCenter + vxEl * 0.5 * bm.dD(vxEl));
			};
			arPtBm = lnOrder.orderPoints(arPtBm);
			if( arPtBm.length() == 0 )
				continue;
						
			Point3d ptLeft = arPtBm[0];
			Point3d ptRight = arPtBm[arPtBm.length() - 1];
			
			if( nSide == _kLeft || nSide == _kLeftAndRight )
				arPtDim.append(ptLeft);
			if( nSide == _kRight || nSide == _kLeftAndRight )
				arPtDim.append(ptRight);
			if( nSide == _kCenter )
				arPtDim.append(ptCenter);	
		}
	}
	arPtDim = lnOrder.orderPoints(arPtDim);
	
	//Should we ignore the extreme points if they are closer than 100 mm from the edges/corners?
	if( !nDimSideRafters ){
		if( arPtCornersSorted.length() == 0 )
			return;
		Point3d ptL = arPtCornersSorted[0];
		Point3d ptR = arPtCornersSorted[arPtCornersSorted.length() - 1];		
		
		Point3d arPtTmp[0];
		for( int i=0;i<arPtDim.length();i++ ){
			Point3d ptDim = arPtDim[i];
			if( i==0 && abs(vOrder.dotProduct(ptDim - ptL)) < U(100) )
				continue;
			if( i==(arPtDim.length() - 1) && abs(vOrder.dotProduct(ptDim - ptR)) < U(100) )
				continue;
				
			arPtTmp.append(ptDim);
		}
		arPtDim = arPtTmp;
		if( arPtDim.length() == 0 )
			return;		
	}
	
	arPtToDim.append(arPtDim);
}

if( sObject == sArObject[11] ){
	if (!grid.bIsValid()) {
		reportMessage(TN("|No grid found|!"));
	}
	else {
		CoordSys csGrid = grid.coordSys();
		Vector3d vGrid = csGrid.vecX();
		double d = vOrder.dotProduct(vGrid);
		if (abs(vOrder.dotProduct(vGrid)) < U(0.5))
			vGrid = csGrid.vecY();
		
		Point3d ptStart = ptVpLeft;
		ptStart += _YW * _YW.dotProduct(ptVpBottom - ptStart);
		Point3d ptEnd = ptVpRight;
		ptEnd += _YW * _YW.dotProduct(ptVpTop - ptEnd);
		
		ptStart.transformBy(ps2ms);
		ptEnd.transformBy(ps2ms);
		ptStart.vis(1);
		ptEnd.vis(3);
		
		Point3d arPtGridIntersect[] = grid.intersectPoints(Line(ptStart, vGrid), vGrid);
		if (arPtGridIntersect.length() == 0)
			arPtGridIntersect.append(grid.intersectPoints(Line(ptEnd, vGrid), vGrid));

		arPtGridIntersect = lnOrder.orderPoints(arPtGridIntersect);
		for (int i=0;i<arPtGridIntersect.length();i++) {
			Point3d ptGrid = arPtGridIntersect[i];
			ptGrid.vis(5);
			
			if ((vOrder.dotProduct(ptStart - ptGrid) * vOrder.dotProduct(ptEnd - ptGrid)) < 0)
				arPtToDim.append(ptGrid);
		}
	}
}

if( sObject == sArObject[12] ){ // Connecting elements
	ElementLog elLog = (ElementLog)el;
	ElementWall elWall = (ElementWall)el;
	if (!elWall.bIsValid()) {
		reportMessage(TN("|Connecting elements is currently only supported for walls|!"));
	}
	else {
		PLine plOutlineWall = el.plOutlineWall();
		
		if( elLog.bIsValid() ){
			PlaneProfile ppElLog(plOutlineWall);
			
			Group grpFloor(elLog.elementGroup().namePart(0), elLog.elementGroup().namePart(1), "");
			Entity arEntElLog[] = grpFloor.collectEntities(true, ElementLog(), _kModelSpace);
			
			for( int i=0;i<arEntElLog.length();i++ ){
				ElementLog elLogConnected = (ElementLog)arEntElLog[i];
				if( !elLogConnected.bIsValid() )
					continue;
				
				if( elLogConnected.handle() == elLog.handle() )
					continue;
				
				PlaneProfile ppElLogConnected(elLogConnected.plOutlineWall());
				if( !ppElLogConnected.intersectWith(ppElLog) )
					continue;
				
				Point3d arPtDimThisConnection[0];
				
				arPtDimThisConnection.append(ppElLogConnected.getGripVertexPoints());
				
				arPtDimThisConnection = lnOrder.orderPoints(arPtDimThisConnection);
				// Only take walls into account with 2 points on the outline of this element.
				if( arPtDimThisConnection.length() < 2 )
					continue;
				
				Point3d ptLeft = arPtDimThisConnection[0];
				Point3d ptRight = arPtDimThisConnection[arPtDimThisConnection.length() - 1];
				Point3d ptCenter = (ptLeft + ptRight)/2;
				
				if( nSide == _kLeft || nSide == _kLeftAndRight )
					arPtToDim.append(ptLeft);
				if( nSide == _kRight || nSide == _kLeftAndRight )
					arPtToDim.append(ptRight);
				if( nSide == _kCenter )
					arPtToDim.append(ptCenter);
			}
		}
		else{
			Element arElConnected[] = elWall.getConnectedElements();
			for( int i=0;i<arElConnected.length();i++ ){
				Point3d arPtDimThisConnection[0];
				
				Element elConnected = arElConnected[i];
				Point3d arPtElConnected[] = elConnected.plOutlineWall().vertexPoints(true);
				
				for( int j=0;j<arPtElConnected.length();j++ ){
					Point3d pt = arPtElConnected[j];
					
					if( plOutlineWall.isOn(pt) )
						arPtDimThisConnection.append(pt);
				}
				
				arPtDimThisConnection = lnOrder.orderPoints(arPtDimThisConnection);
				// Only take walls into account with 2 points on the outline of this element.
				if( arPtDimThisConnection.length() < 2 )
					continue;
				
				Point3d ptLeft = arPtDimThisConnection[0];
				Point3d ptRight = arPtDimThisConnection[arPtDimThisConnection.length() - 1];
				Point3d ptCenter = (ptLeft + ptRight)/2;
				
				if( nSide == _kLeft || nSide == _kLeftAndRight )
					arPtToDim.append(ptLeft);
				if( nSide == _kRight || nSide == _kLeftAndRight )
					arPtToDim.append(ptRight);
				if( nSide == _kCenter )
					arPtToDim.append(ptCenter);
			}
		}
	}
}
if( sObject == sArObject[13] ){ // Panels
	
	Vector3d vxDimMs = vOrder;
	Vector3d vzDimMs = vzms;
	Vector3d vyDimMs = vzDimMs.crossProduct(vxDimMs);
	PlaneProfile validArea(CoordSys(ptElRef, vxDimMs, vyDimMs, vzDimMs));
	PLine areaOutline;
	areaOutline.createRectangle(LineSeg(ptElRef - vxDimMs * U(25000) - vyDimMs * panelRange, ptElRef + vxDimMs * U(25000) + vyDimMs * panelRange), vxDimMs, vyDimMs);
	validArea.joinRing(areaOutline, _kAdd);
	
//	if (componentIndex == -1)
//	{
//		arPtToDim.append(lnMs.collectDimPoints(arSip,nSide));
//	}
//	else
	{
		String componentIndexesAsString[] = componentIndex.tokenize(";");
		int componentIndexes[0];
		for (int index=0;index<componentIndexesAsString.length();index++) 
		{ 
			String componentIndexAsString = componentIndexesAsString[index]; 
			int componentIndex = componentIndexAsString.atoi();
			componentIndexes.append(componentIndex);
		}
		
		for (int s = 0; s < arSip.length(); s++)
		{
			Sip sip = arSip[s];
			
			
			Body sipComponent;
			if (componentIndexes.find(-1) != -1 || componentIndexes.length() < 1)
			{
				sipComponent = sip.realBody();
			}
			else
			{
				for (int index = 0; index < componentIndexes.length(); index++)
				{
					int componentIndex = componentIndexes[index];
					if ( componentIndex >= SipStyle(sip.style()).numSipComponents() || componentIndex < 0) continue;
					
					sipComponent += sip.realBodyOfComponentAt(componentIndex);
				}
			}
			
			if (takeAllComponentExtremes)
			{
				Point3d extremeVertices[] = sipComponent.extremeVertices(vOrder);
				if (panelRange > 0)
				{
					Point3d ptsInRange[0];
					for (int v = 0; v < extremeVertices.length(); v++)
					{
						if (validArea.pointInProfile(extremeVertices[v]) != _kPointOutsideProfile)
						{
							ptsInRange.append(extremeVertices[v]);
						}
					}
					extremeVertices = ptsInRange;
				}
				if (extremeVertices.length() > 1)
				{
					arPtToDim.append(extremeVertices[0]);
					arPtToDim.append(extremeVertices[extremeVertices.length() - 1]);
				}
			}
			else
			{
				Point3d componentVertices[0];
				if (componentFace == 0 || componentFace == 2)
				{
					Plane internalPlane(sip.ptCen() - sip.vecD(vzEl) * 0.5 * sip.dD(vzEl), sip.vecD(vzEl));
					PlaneProfile internalFace = sipComponent.extractContactFaceInPlane(internalPlane, U(100));
					componentVertices.append(internalFace.getGripVertexPoints());
					
					if (panelRange > 0)
					{
						Point3d ptsInRange[0];
						for (int v = 0; v < componentVertices.length(); v++)
						{
							if (validArea.pointInProfile(componentVertices[v]) != _kPointOutsideProfile)
							{
								ptsInRange.append(componentVertices[v]);
							}
						}
						componentVertices = ptsInRange;
					}
					
					componentVertices = lnOrder.orderPoints(componentVertices);
					if (componentVertices.length() == 0)
						continue;
					
					if (takeComponentExtremes)
					{
						Point3d ptLeft = componentVertices[0];
						Point3d ptRight = componentVertices[componentVertices.length() - 1];
						Point3d ptCenter = (ptLeft + ptRight) / 2;
						
						Point3d pl = ptLeft;
						pl.transformBy(ms2ps);
						pl.vis(1);
						Point3d pr = ptRight;
						pr.transformBy(ms2ps);
						pr.vis(1);
						if ( nSide == _kLeft || nSide == _kLeftAndRight )
							arPtToDim.append(ptLeft);
						if ( nSide == _kRight || nSide == _kLeftAndRight )
							arPtToDim.append(ptRight);
						if ( nSide == _kCenter )
							arPtToDim.append(ptCenter);
					}
					else
					{
						arPtToDim.append(componentVertices);
					}
				}
				if (componentFace == 1 || componentFace == 2)
				{
					Plane externalPlane(sip.ptCen() + sip.vecD(vzEl) * 0.5 * sip.dD(vzEl), sip.vecD(vzEl));
					PlaneProfile externalFace = sipComponent.extractContactFaceInPlane(externalPlane, U(100));
					componentVertices.append(externalFace.getGripVertexPoints());
					
					if (panelRange > 0)
					{
						Point3d ptsInRange[0];
						for (int v = 0; v < componentVertices.length(); v++)
						{
							if (validArea.pointInProfile(componentVertices[v]) != _kPointOutsideProfile)
							{
								ptsInRange.append(componentVertices[v]);
							}
						}
						componentVertices = ptsInRange;
					}
					
					componentVertices = lnOrder.orderPoints(componentVertices);
					if (componentVertices.length() == 0)
						continue;
					
					if (takeComponentExtremes)
					{
						Point3d ptLeft = componentVertices[0];
						Point3d ptRight = componentVertices[componentVertices.length() - 1];
						Point3d ptCenter = (ptLeft + ptRight) / 2;
						
						Point3d pl = ptLeft;
						pl.transformBy(ms2ps);
						pl.vis(1);
						Point3d pr = ptRight;
						pr.transformBy(ms2ps);
						pr.vis(1);
						if ( nSide == _kLeft || nSide == _kLeftAndRight )
							arPtToDim.append(ptLeft);
						if ( nSide == _kRight || nSide == _kLeftAndRight )
							arPtToDim.append(ptRight);
						if ( nSide == _kCenter )
							arPtToDim.append(ptCenter);
					}
					else
					{
						arPtToDim.append(componentVertices);
					}
				}
			}
		}
	}
}
if( sObject == sArObject[14] ){ // Tools
	for (int b=0;b<arBms.length();b++) {
		Beam bm = arBms[b];
		
		AnalysedTool tools[] = bm.analysedTools(1); 
		if (toolType == "Drill") 
		{
			String dimensionedDrillDiameters[0];
			int numberOfDrillsWithThisDiameter[0];
			AnalysedDrill drills[]= AnalysedDrill().filterToolsOfToolType(tools);
			for (int t=0;t<drills.length();t++) {
				AnalysedDrill drill = drills[t];
				
				if (onlyDrillDiameter > U(0) && drill.dDiameter() != onlyDrillDiameter)
					continue;
				
				Vector3d drillNormalDirection = drill.vecZ();
				if (abs(abs(vOrder.dotProduct(drillNormalDirection)) - 1) < dEps)
					continue;
				
				arPtToDim.append(drill.ptStart());
				
				String drillDiameter;
				drillDiameter.formatUnit(drill.dDiameter(), 2, 0);
				int diameterIndex = dimensionedDrillDiameters.find(drillDiameter);
				if ( diameterIndex == -1)
				{
					dimensionedDrillDiameters.append(drillDiameter);
					numberOfDrillsWithThisDiameter.append(1);
				}
				else
				{
					numberOfDrillsWithThisDiameter[diameterIndex]++;
				}
				
				String drillDescription;
				for (int d=0;d<dimensionedDrillDiameters.length();d++)
				{
					int amount = numberOfDrillsWithThisDiameter[d];
					String diameter = dimensionedDrillDiameters[d];
					
					String prefix = drillDescription == "" ? "Ø" : " & Ø";
					drillDescription += (prefix + diameter + "mm/" + amount + "x");
					
					objectDescription = drillDescription;
				}
			}
		}
		
		if(toolType == "Beamcut")
		{
			AnalysedBeamCut beamcuts[] = AnalysedBeamCut().filterToolsOfToolType(tools);
			for(int t = 0; t < beamcuts.length(); t++)
			{
				AnalysedBeamCut beamcut = beamcuts[t];
				if (beamcut.dDepth() < minimumBeamCutDepth)
					continue;
				
				Quader bcQuader = beamcut.quader();
				double bcLength = bcQuader.dD(vOrder);
								
				Point3d ptLeft = beamcut.ptOrg() - bcQuader.vecD(vOrder) * 0.5 * bcLength;
				Point3d ptRight = beamcut.ptOrg() + bcQuader.vecD(vOrder) * 0.5 * bcLength;
				Point3d ptCenter = (ptLeft + ptRight)/2;
				
				if( nSide == _kLeft || nSide == _kLeftAndRight )
					arPtToDim.append(ptLeft);
				if( nSide == _kRight || nSide == _kLeftAndRight )
					arPtToDim.append(ptRight);
				if( nSide == _kCenter )
					arPtToDim.append(ptCenter);
			}
		}
	}
}
if( sObject == sArObject[15] )
{
	// Trusses
	Entity trusses[] = el.elementGroup().collectEntities(true, TrussEntity(), _kModelSpace);
	for (int t = 0; t < trusses.length(); t++)
	{
		TrussEntity truss = (TrussEntity)trusses[t];
		Point3d trussOrigin = truss.coordSys().ptOrg();		
		
		Point3d trussVertices[] = truss.realBody().allVertices();
		
		Point3d trussVerticesX[] = lnOrder.orderPoints(trussVertices);
		Point3d trussVerticesY[] = lnPerp.orderPoints(trussVertices);
		Point3d trussVerticesZ[] = lnZ.orderPoints(trussVertices);
		
		Point3d ptLeft = trussOrigin;
		Point3d ptRight = trussOrigin;
		if (trussVerticesX.length() > 1 && trussVerticesY.length() > 1 && trussVerticesZ.length() > 1)
		{
			ptLeft = trussVerticesX[0];
			ptLeft += vDimPerp * vDimPerp.dotProduct(trussVerticesY[0] - ptLeft);
			ptLeft += vzms * vzms.dotProduct(trussVerticesZ[0] - ptLeft);
			
			ptRight = trussVerticesX[trussVerticesX.length() - 1];
			ptRight += vDimPerp * vDimPerp.dotProduct(trussVerticesY[trussVerticesY.length() - 1] - ptRight);
			ptRight += vzms * vzms.dotProduct(trussVerticesZ[trussVerticesZ.length() - 1] - ptRight);
		}
		
		Point3d ptCenter = (ptLeft + ptRight) / 2;
		
		if ( nSide == _kLeft || nSide == _kLeftAndRight )
			arPtToDim.append(ptLeft);
		if ( nSide == _kRight || nSide == _kLeftAndRight )
			arPtToDim.append(ptRight);
		if ( nSide == _kCenter )
			arPtToDim.append(ptCenter);
	}
}




// add special dim points to the dimline
if(arSSpecial.find("W_knieschot goten") != -1)
{
	arPtToDim.setLength(0);
	PlaneProfile elementProfile(csEl);
	elementProfile.joinRing(el.plEnvelope(), _kAdd);
	
	// Try to find the group 'W_knieschot goten'.
	Group allGroups[] = Group().allExistingGroups();
	for (int g=0;g<allGroups.length();g++) 
	{
		Group group = allGroups[g];
		if (group.namePart(2) != "")
			continue;
		
		String level1 = group.namePart(1);
		if (level1 == "W_knieschot goten") 
		{
			Entity elementEntities[] = group.collectEntities(true, ElementWallSF(), _kModelSpace);
			for (int e=0;e<elementEntities.length();e++)
			{
				ElementWallSF connectingElement = (ElementWallSF)elementEntities[e];
				// Only aligned elements are allowed.
				if (abs(abs(vOrder.dotProduct(connectingElement.vecX())) - 1) > dEps)
					continue;
				
				// Only intersecting elements are allowed.
				PlaneProfile intersectingElementProfile(csEl);
				intersectingElementProfile.joinRing(connectingElement.plOutlineWall(), _kAdd);
				
				if (intersectingElementProfile.intersectWith(elementProfile))
				{
					PLine outline = connectingElement.plOutlineWall();
					outline.transformBy(ms2ps);
					dp.draw(outline);
					Point3d textPosition = connectingElement.ptArrow();
					textPosition.transformBy(ms2ps);
					dp.draw(connectingElement.number(), textPosition, _XW, _YW, 0, 2);
					LineSeg diagonal = connectingElement.segmentMinMax();
					arPtToDim.append(diagonal.ptStart());
					arPtToDim.append(diagonal.ptEnd());
				}
			}
			
			break;
		}
	}
}

if( arSSpecial.find("L1") != -1 ){ // linex add points at the top of roof elements
	Point3d arPtRafter[0];
	for( int i=0;i<arBmRafter.length();i++ ){
		Beam bmRafter = arBmRafter[i];
		Body bdRafter = bmRafter.envelopeBody(FALSE, TRUE);
		PlaneProfile ppRafter = bdRafter.extractContactFaceInPlane(pnBack, U(100));
		arPtRafter.append(ppRafter.getGripVertexPoints());	
	}
	
	Point3d arPtRafterY[] = lnYEl.projectPoints(arPtRafter);
	arPtRafterY = lnYEl.projectPoints(arPtRafterY);
	if( arPtRafterY.length() > 0 )
		arPtToDim.append(arPtRafterY[arPtRafterY.length() - 1]);

	for( int i=0;i<arBms.length();i++ ){
		Beam bm = arBms[i];
		
		if( bm.beamCode().token(0) == "N" ){
			Point3d arPtBm[] = bm.envelopeBody().allVertices();
			Point3d arPtBmY[] = lnYEl.projectPoints(arPtBm);
			arPtBmY = lnYEl.orderPoints(arPtBm);
			if( arPtBmY.length() > 0 )
				arPtToDim.append(arPtBmY[arPtBmY.length() - 1]);
		}
	}
}

if( arSSpecial.find("VDK-01") != -1 ){
	//Take all beams not only filtered
	for(int i=0;i<arGBmAll.length();i++){
		GenBeam gBm = arGBmAll[i];
		if( arSDimBC.find(gBm.name("beamcode").token(0).makeUpper()) != -1 ){
			Body bdGBm = gBm.realBody();
			Point3d arPtGenBm[] = bdGBm.allVertices();
			arPtGenBm = Line(_PtW, _ZW).orderPoints(arPtGenBm);
			Point3d ptGenBmMinZ = arPtGenBm[0];
			PlaneProfile ppGBm = bdGBm.extractContactFaceInPlane(Plane(ptGenBmMinZ, vzEl), U(10));
			
			Point3d arPtGBm[] = ppGBm.getGripVertexPoints();
			arPtGBm = Line(ptEl, vyEl).orderPoints(arPtGBm);
			
			if( arPtGBm.length() == 0 )
				continue;
			
			Point3d pt = arPtGBm[0];
			arPtToDim.append(pt);
			for( int j=0;j<arPtGBm.length();j++ ){
				Point3d ptGBm = arPtGBm[j];
				if( abs(vyEl.dotProduct(ptGBm - pt)) > U(2) )
					break;
				arPtToDim.append(ptGBm);
			}
			
			ppGBm.transformBy(ms2ps);
			ppGBm.vis();	
		}
	}
}

int bAddInsideFrame = (bAddInsideFrameAsReference || arSSpecial.find("IF") != -1 || arSSpecial.find("InsideFrame") != -1);
int bAddOutsideFrame = (bAddOutsideFrameAsReference || arSSpecial.find("OF") != -1 || arSSpecial.find("OutsideFrame") != -1);
if (bAddInsideFrame || bAddOutsideFrame){
	Point3d arPtFrame[0];
	CoordSys csBack(csEl.ptOrg() - csEl.vecZ() * el.zone(0).dH(), csEl.vecX(), csEl.vecY(), csEl.vecZ());
	if (bAddOutsideFrame)
		csBack = CoordSys(csEl.ptOrg(), csEl.vecX(), csEl.vecY(), csEl.vecZ());

	for(int i=0;i<arBms.length();i++){
		Beam bm = arBms[i];
		
		PlaneProfile ppBm(csBack);
		ppBm.unionWith(bm.realBody().extractContactFaceInPlane(Plane(csBack.ptOrg(), csBack.vecZ()), U(10)));
		ppBm.vis(i);
		
		arPtFrame.append(ppBm.getGripVertexPoints());
	}
	
	Line lnDimX(pel0, vDimX);
	lnDimX.transformBy(ps2ms);
	arPtFrame = lnDimX.orderPoints(arPtFrame);
	
	if( arPtFrame.length() > 0 ){
		arPtToDim.append(arPtFrame[0]);
		arPtToDim.append(arPtFrame[arPtFrame.length() - 1]);
	}
}

if( arSSpecial.find("InsideOpening") != -1 || arSSpecial.find("InsideOpening2") != -1 ){
	int nBmSide = 1;
	if( arSSpecial.find("InsideOpening2") != -1 )
		nBmSide *= -1;
	
	Opening arOp[] = el.opening();
	for( int i=0;i<arOp.length();i++ ){
		Opening op = arOp[i];
		PLine plOp = op.plShape();
		plOp.transformBy(vzEl * vzEl.dotProduct((ptEl - vzEl * 0.5 * el.zone(0).dH()) - plOp.ptStart()));
		Point3d ptOpM = Body(plOp ,vzEl).ptCen();
		
		Beam arBmLeft[] = Beam().filterBeamsHalfLineIntersectSort(arBmModule, ptOpM, -vxEl);
		if( arBmLeft.length() == 0 )
			continue;
		Beam bmLeft = arBmLeft[0];
		arPtToDim.append(bmLeft.ptCen() + bmLeft.vecD(vxEl) * 0.5 * nBmSide * bmLeft.dD(vxEl));

		Beam arBmRight[] = Beam().filterBeamsHalfLineIntersectSort(arBmModule, ptOpM, vxEl);
		if( arBmRight.length() == 0 )
			continue;
		Beam bmRight = arBmRight[0];
		Point3d ptOpRight = bmRight.ptCen() - bmRight.vecD(vxEl) * 0.5 * nBmSide * bmRight.dD(vxEl);
		arPtToDim.append(ptOpRight);
	}
}


// This special adds a dimension from the stkr beam to the first following tile lath.
if (sSpecial.makeUpper() == "STKR") {
	Point3d arPtDimObject[0];
	arPtDimObject = arPtToDim;
	arPtDimObject = lnOrder.projectPoints(arPtDimObject);
	arPtDimObject = lnOrder.orderPoints(arPtDimObject, dEps);

	if (arPtDimObject.length() > 0) {		
		Point3d arPtDimSub[0];
		for (int i=0;i<arBmStkr.length();i++) {
			Beam bmStkr = arBmStkr[0];
			Point3d ptStkr = bmStkr.ptCenSolid() + vOrder * 0.5 * bmStkr.dD(vOrder);
			arPtDimSub.append(ptStkr);
				
			for( int i=(arPtDimObject.length() - 1);i>0;i-- ){
				Point3d pt = arPtDimObject[i];
				if (vOrder.dotProduct(ptStkr - pt) > 0) {
					arPtDimSub.append(pt);
					
//					DimLine dimLine(pt + vzEl * U(100), vOrder, vDimPerp);
					Dim dimSub(lnMs, arPtDimSub, "<>", "<>", _kDimPar, _kDimNone);
					dimSub.transformBy(ms2ps);
					dimSub.setReadDirection(-_XW + _YW);
					dimSub.setDeltaOnTop(bDeltaOnTop);
					dp.draw(dimSub);

					break;
				}
			}
		}
	}	
}


// This special adds delta dims to the tilelaths.
if (sSpecial.makeUpper() == "HSB-TILELATH-01") {
	Point3d arPtDimBetween[0];
	int nNrSameDeltaDim = 0;
	
	Point3d arPtDimObject[0];
	arPtDimObject = arPtToDim;
	arPtDimObject = lnOrder.projectPoints(arPtDimObject);
	arPtDimObject = lnOrder.orderPoints(arPtDimObject, dEps);

	if (arPtDimObject.length() > 0) {
		Point3d ptPrev = arPtDimObject[0];
		for( int i=1;i<(arPtDimObject.length() - 1);i++ ){
			Point3d ptThis = arPtDimObject[i];
			Point3d ptNext = arPtDimObject[i+1];
			
			double dPrevToThis = vDimX.dotProduct(ptThis - ptPrev);
			double dThisToNext = vDimX.dotProduct(ptNext - ptThis);
			
			if( abs(dPrevToThis - dThisToNext) > dEpsDeltaDim ){
				Point3d arPtDimSub[] = {
					ptPrev,
					ptThis,
					ptNext
				};
				Dim dimSub(lnMs, arPtDimSub, "<>", "<>", _kDimPar, _kDimNone);
				dimSub.transformBy(ms2ps);
				dimSub.setReadDirection(-_XW + _YW);
				dimSub.setDeltaOnTop(bDeltaOnTop);
				dp.draw(dimSub);
				
				nNrSameDeltaDim = 0;
			}
			
			nNrSameDeltaDim++;
			if( nNrSameDeltaDim == 5 || nNrSameDeltaDim == arPtDimObject.length() - 3 ){
				arPtDimBetween.setLength(0);
				arPtDimBetween.append(ptPrev);
				arPtDimBetween.append(ptThis);
			}
			if( (arPtDimBetween.length() > 1 ) && (nNrSameDeltaDim == 7 || nNrSameDeltaDim == arPtDimObject.length() - 2) ){			
				Dim dimSub(lnMs, arPtDimBetween, "<>", "<>", _kDimPar, _kDimNone);
				dimSub.transformBy(ms2ps);
				dimSub.setReadDirection(-_XW + _YW);
				dimSub.setDeltaOnTop(bDeltaOnTop);
				dp.draw(dimSub);
			}	
			
			ptPrev = ptThis;
		}
	}
}

if (objectPoints.length() == 0)
{
	objectPoints.append(arPtToDim);
}

for(int i=0;i<arPtToDim.length();i++){
	Point3d pt = arPtToDim[i];
	pt.transformBy(ms2ps);
	pt.vis(i);
}

//Offset to element. Different for each alignment 
double dxProj[] = {  -dOffsetDim,dOffsetDim,0,0};
double dyProj[] = { 0, 0, -dOffsetDim,dOffsetDim};
//Define line for projection of points.
Point3d ptProjectMs = pElZero - vxms * dxProj[nPosition] - vyms * dyProj[nPosition];
Point3d ptProjectPs = ptProjectMs;
ptProjectPs.transformBy(ms2ps);
Line lnPSProject (ptProjectPs,vDimX*nStartDim);
Line lnMSProject = lnPSProject;
lnMSProject.transformBy(ps2ms);


//Project points on one line.
//Order points. First point in array is start of cummulative dimensioning.
if( nExtLines == 2 ){
	arPtToDim = lnMSProject.projectPoints(arPtToDim);
	arPtRefToDim = lnMSProject.projectPoints(arPtRefToDim);
}
arPtRefToDim = lnMSSort.orderPoints(arPtRefToDim);

if (! bNoDimensionsOutsideRefence)
{
	if (arPtRefToDim.length() > 1)
	{
		Point3d startReference = arPtRefToDim[0];
		Point3d endReference = arPtRefToDim[arPtRefToDim.length() - 1];
		
		for (int index=0;index<arPtToDim.length();index++) 
		{ 
			Point3d dimPoint = arPtToDim[index]; 
			if (vOrder.dotProduct(startReference - dimPoint) * vOrder.dotProduct(endReference - dimPoint) > 0)
			{
				arPtToDim.removeAt(index);
				index--;
			}
			 
		}
		
	}
}

Point3d ptReference;
int bReferencePointSet = false;
if( nDimStyleCum != _kDimNone && arPtRefToDim.length() > 0 && !bDimPtRefSeperate ){
	ptReference = arPtRefToDim[0];
	arPtRefToDim.removeAt(0);
	bReferencePointSet = true;
}

if( bDimPtRefSeperate )
	arPtRefToDim = lnMSProject.orderPoints(arPtRefToDim);
else
	arPtToDim.append(arPtRefToDim);

arPtToDim = lnMSSort.orderPoints(arPtToDim);

if( bReferencePointSet )
	arPtToDim.insertAt(0, ptReference);

Point3d arPtDimLine[0];
for(int i=0; i<(arPtToDim.length() - 1);i++){
	Point3d ptThis = arPtToDim[i];
	Point3d ptNext = arPtToDim[i+1];
	if(i==0){
		arPtDimLine.append(ptThis);
	}
	Vector3d vCompare = vDimX;
	vCompare.transformBy(ps2ms);
	vCompare.normalize();
	double dBetweenPoints = abs(vCompare.dotProduct(ptNext - ptThis));
	if( dBetweenPoints > dAllowedTollerance ){
		arPtDimLine.append(ptNext);
	}
}
if( arPtToDim.length() != 1 )
	arPtToDim = arPtDimLine;

if( arPtToDim.length() < 1 || (arPtToDim.length() < 2 && arPtRefToDim.length() < 1) ){
	return;
}

if( bDimPtRefSeperate && arPtRefToDim.length() > 0 ){
	Point3d ptLnRef = lnMs.ptOrg();
	Vector3d vxLnRef =  vOrder;
	vxLnRef.normalize();
	Vector3d vyLnRef =  vDimPerp;
	vyLnRef.normalize();
	if( dxOff[nPosition] != 0 )
		ptLnRef += vxms * dxOff[nPosition]/abs(dxOff[nPosition]) * dOffsetRef;
	if( dyOff[nPosition] != 0 )
		ptLnRef += vyms * dyOff[nPosition]/abs(dyOff[nPosition]) * dOffsetRef;
	DimLine lnRef(ptLnRef, vxLnRef, vyLnRef);
	
	Point3d arPtDim[0];
	if( nSideRef == _kLeft || nSideRef == _kLeftAndRight ){
		Point3d ptDim = arPtToDim[0];
		Point3d ptRef = arPtRefToDim[0];
		if( abs(lnRef.vecX().dotProduct(ptRef - ptDim)) > dEps ){
			arPtDim.append(ptRef);
			arPtDim.append(ptDim);
			if( nExtLines == 2 )
				arPtDim= Line(ptLnRef, vxLnRef).projectPoints(arPtDim);

			String sRefText = "";
			String sRefTextDim = "";
			if( nRefTextType > 0 ){
				sRefText = sTxtRefLeftPos;
				if( lnRef.vecX().dotProduct(ptRef - ptDim) < 0 )
					sRefText = sTxtRefLeftNeg;
				
				if( nRefTextType == 1 )
					sRefTextDim = sRefText;
			}
			String sSign = "";
			if( bRefSigned ){
				sSign = "+";
				if( lnRef.vecX().dotProduct(ptRef - ptDim) < 0 )
					sSign = "-";
			}
			Dim dim(lnRef,arPtDim,sRefTextDim + sSign + "<>",sRefTextDim + sSign + "{<>}",nDimStyleDelta,nDimStyleCum); // def in MS
			dim.transformBy(ms2ps); // transfrom the dim from MS to PS
			
			Vector3d vReadDirection = -_XW + _YW;
			if( nReadDirection == 1 )
				vReadDirection = -_YW + _XW;
			dim.setReadDirection(vReadDirection);
			dim.setDeltaOnTop(bDeltaOnTop);
			dp.draw(dim);
			
			arPtDim = Line(ptLnRef, vxLnRef).orderPoints(arPtDim);
			if( nRefTextType == 2 && arPtDim.length() > 1 ){
				Point3d ptTextRef = 	ptLnRef + 
									vxLnRef * (vxLnRef.dotProduct(arPtDim[0] - ptLnRef) - dOffsetText) + 
									vyLnRef * dyOffsetTextRef;
				ptTextRef.transformBy(ms2ps);
				Vector3d vxTextRef = vxLnRef;
				vxTextRef.transformBy(ms2ps);
				Vector3d vyTextRef = vyLnRef;
				vyTextRef.transformBy(ms2ps);
				
				dp.draw(sRefText, ptTextRef, vxTextRef, vyTextRef, -1, 0);
			}

		}
	}
	
	arPtDim.setLength(0);
	if( nSideRef == _kRight || nSideRef == _kLeftAndRight ){
		Point3d ptDim = arPtToDim[arPtToDim.length() - 1];
		Point3d ptRef = arPtRefToDim[arPtRefToDim.length() - 1];
		if( abs(lnRef.vecX().dotProduct(ptDim - ptRef)) > dEps ){
			arPtDim.append(ptRef);
			arPtDim.append(ptDim);
			if( nExtLines == 2 )
				arPtDim= Line(ptLnRef, vxLnRef).projectPoints(arPtDim);

			String sRefText = "";
			String sRefTextDim = "";
			if( nRefTextType > 0 ){
				sRefText = sTxtRefRightPos;
				if(  lnRef.vecX().dotProduct(ptDim - ptRef) < 0 )
					sRefText = sTxtRefRightNeg;
				
				if( nRefTextType == 1 )
					sRefTextDim = sRefText;
			}
			String sSign = "";
			if( bRefSigned ){
				sSign = "+";
				if( lnRef.vecX().dotProduct(ptDim - ptRef) < 0 )
					sSign = "-";
			}
			Dim dim(lnRef,arPtDim,sSign + "<>" + sRefTextDim,sSign + "{<>}"  + sRefTextDim,nDimStyleDelta,nDimStyleCum); // def in MS
			dim.transformBy(ms2ps); // transfrom the dim from MS to PS
			
			Vector3d vReadDirection = -_XW + _YW;
			if( nReadDirection == 1 )
				vReadDirection = -_YW + _XW;
			dim.setReadDirection(vReadDirection);
			dim.setDeltaOnTop(bDeltaOnTop);
			dp.draw(dim);
			
			arPtDim = Line(ptLnRef, vxLnRef).orderPoints(arPtDim);
			if( nRefTextType == 2 && arPtDim.length() > 1 ){
				Point3d ptTextRef = 	ptLnRef + 
									vxLnRef * (vxLnRef.dotProduct(arPtDim[arPtDim.length() - 1] - ptLnRef) + dOffsetText) + 
									vyLnRef * dyOffsetTextRef;
				ptTextRef.transformBy(ms2ps);
				Vector3d vxTextRef = vxLnRef;
				vxTextRef.transformBy(ms2ps);
				Vector3d vyTextRef = vyLnRef;
				vyTextRef.transformBy(ms2ps);
				
				dp.draw(sRefText, ptTextRef, vxTextRef, vyTextRef, 1, 0);
			}
		}
	}
}

if( arPtToDim.length() < nMinRequiredDimPoints )
	return;

Point3d ptDimLn = lnMs.ptOrg();
Vector3d vxDimLn = vOrder;
vxDimLn.normalize();
Vector3d vyDimLn = vDimPerp;
vyDimLn.normalize();

Point3d XXX = lnMs.ptOrg();
XXX.transformBy(ms2ps);
XXX.vis(3);
if (offsetFrom == offsetFromOptions[1])
{
	for (int i=0;i<objectPoints.length();i++)
		objectPoints[i].vis(i);
		
	Point3d objectPointsPerp[] = Line(ptDimLn, vToDimLn).orderPoints(objectPoints);
	if (objectPointsPerp.length() > 0)
		lnMs = DimLine(objectPointsPerp[objectPointsPerp.length() - 1] + vToDimLn * dOffsetDim, vxDimLn, vyDimLn);
}
XXX = lnMs.ptOrg();
XXX.transformBy(ms2ps);
XXX.vis(1);

if( nExtLines == 1 )
	arPtToDim = Line(ptElRef, vxDimLn).projectPoints(arPtToDim);
else if (nExtLines == 2 )
	arPtToDim = Line(lnMs.ptOrg(), vOrder).projectPoints(arPtToDim);

Dim dim(lnMs,arPtToDim,"<>","{<>}",nDimStyleDelta,nDimStyleCum); // def in MS
dim.transformBy(ms2ps); // transfrom the dim from MS to PS

Vector3d vReadDirection=-_XW+_YW;
if(nReadDirection==1)
	vReadDirection=-_YW+_XW;
dim.setReadDirection(vReadDirection);
dim.setDeltaOnTop(bDeltaOnTop);
dp.draw(dim);

//Start description of dimline
String sDescText=objectDescription!=""?objectDescription:sObject;
if (sObject==sArObject[0]) sDescText=T("Element");
if (sObject==sArObject[1]) sDescText=el.zone(nZone).material();
if (sObject==sArObject[2]) sDescText=T("Tsl") + " - " +sTsl;
if (sObject==sArObject[4]) sDescText=sDimBeamCode;
if (nZone==0 && sObject == sArObject[1]) sDescText = T("Beams");

if (sDescription != "")
	sDescText = sDescription;
if (sDescription == "@Material")
	sDescText = sMaterial;


//arPtToDim = lnMSSort.orderPoints(arPtToDim);
arPtToDim = Line(ptDimLn, vxDimLn).orderPoints(arPtToDim);
if( arPtToDim.length() > 0 && nTextSide!=0 ){
	Point3d ptTextDim = ptDimLn + vxDimLn * (vxDimLn.dotProduct(arPtToDim[0] - ptDimLn) - dOffsetText);
	if( nTextSide == -1 )
		ptTextDim = ptDimLn + vxDimLn * (vxDimLn.dotProduct(arPtToDim[arPtToDim.length() - 1] - ptDimLn) + dOffsetText);
	ptTextDim.transformBy(ms2ps);
	Vector3d vxTextDim = vxDimLn;
	vxTextDim.transformBy(ms2ps);
	Vector3d vyTextDim = vyDimLn;
	vyTextDim.transformBy(ms2ps);
	if(nReadDirection==1)
	{ 
	// HSB-17142
		vxTextDim*=-1;
		vyTextDim*=-1;
		nTextSide*=-1;
	}
	dp.draw(sDescText, ptTextDim, vxTextDim, vyTextDim, -1*nTextSide, 0);
}
//
//if (nPosition < 2)
// 	dp.draw(sDescText,pel0,_YW,-_XW,-1*nTextSide,0);//vertical
//else if (nPosition < 4)
//	dp.draw(sDescText,pel0,_XW,_YW,-1*nTextSide,0);//horizontal



#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`KY
MID_X]=)_W+G_`-&+7TM7S3)_QZZ3_N7/_HQ:(?QH>HW_``Y>@4445]`>:%%%
M%`!1110`4D7_`!^R_P#7A<?^R4M+:H)-29"P4-8SC<W0?<YKCQ[MAY,VH-*H
MFQ]K;&2VAP7),8.%3.!4JVNY2R^85'4^7T_6I+-(E2!C,I5(QMP0,D9Z@G-2
M@J8W61XY,EB!\O4]P<\5YLL963M%]NG_``#Q:N)J*;47^!6^R_*IRX#?=)3`
M-5JU6E0JQW#+A<@L,+M'UK*KMP%>K5YO:=#HPE6=2_.%%%%>B=@4444,"9D\
MSP_H:YQF[;G_`(!+2FW`C$A,@0_Q>7Q_.GQJAT'1B\@3;<.1G^([91CVZ_I4
MR*B6A0.K.^-X+CD`]!S7SE#$3IIJ+^T1F==QJI1?1%<6X.S!D^?[O[OK]*;+
M`8ER2V0<$,N#6CYZ,T+$!2N[/[Q2!G^8JM?.K(-I'&T8!'8'H,\"M\/C,1.L
MHR6G_!/-I8FM*HHM:%&BBBO</5"BBB@".3_66O\`U]0?^C5J:Y_Y"^I?]?'_
M`+(M0R?ZRU_Z^H/_`$:M37/_`"%]2_Z^/_9%KAE_OB]#I7^[OU&T445W',%%
M%%`!1110`4L?_(.\1?\`8/7^4M)2Q_\`(.\1?]@]?Y2UP9C_``?FOS.K"?Q/
MDQ.U%':BNY;'*R6Q_P"0YIW_`%U?_P!%/7N7@C_D2M(_Z]EKPVQ_Y#FG?]=7
M_P#13U[EX(_Y$K2/^O9:\3%?[R_1'H4OX*]3?I#]T_2EI#]T_2LQF%X0_P"0
M(_\`U^W?_H^2MZL'PA_R!'_Z_;O_`-'R5O5,/A1K7_B2]0HHHJC(****`"BB
MB@`KYID_X]=)_P!RY_\`1BU]+5\TR?\`'KI/^Y<_^C%HA_&AZC?\.7H%%%%?
M0'FA1110`4444`%)%_Q^R_\`7A<?^R4M)%_Q^R_]>%Q_[)7)CO\`=Y&U!)U$
MF,A_U$?^Z/Y5)4<'_'O'_NC^525TQ2LC)K4****H04444`%%%%#`?-_R+FBG
M_IZ;_P!`EIE23?\`(N:)_P!?3?\`H$M1UYN6I>SEZLZ<5%*2MV"BBBO2L<P4
M444`%%%%`$<G^LM?^OJ#_P!&K4US_P`A?4O^OC_V1:AD_P!9:_\`7U!_Z-6I
MKG_D+ZE_U\?^R+7#+_?%Z'2O]W?J-HHHKN.8****`"BBB@`I8_\`D'>(O^P>
MO\I:2EC_`.0=XB_[!Z_REK@S'^#\U^9U83^)\F)VHH[45W+8Y62V/_(<T[_K
MJ_\`Z*>O<O!'_(E:1_U[+7AMC_R'-._ZZO\`^BGKW+P1_P`B5I'_`%[+7B8K
M_>7Z(]"E_!7J;](?NGZ4M(?NGZ5F,PO"'_($?_K]N_\`T?)6]6#X0_Y`C_\`
M7[=_^CY*WJF'PHUK_P`27J%%%%49!1110`4444`%?-,G_'KI/^Y<_P#HQ:^E
MJ^:9/^/72?\`<N?_`$8M$/XT/4;_`(<O0****^@/-"BBB@`HHHH`*2+_`(_9
M?^O"X_\`9*6DB_X_9?\`KPN/_9*Y,=_`D;X;^*AD'_'O'_NC^525'!_Q[Q_[
MH_E4E=,?A1B]PHHHJA!1110`4444`23?\BYHG_7TW_H$M1U)-_R+FB?]?3?^
M@2U'7G9;_#EZLZ\7\:]$%%%%>B<@4444`%%%%`$<G^LM?^OJ#_T:M37/_(7U
M+_KX_P#9%J&3_66O_7U!_P"C5J:Y_P"0OJ7_`%\?^R+7#+_?%Z'2O]W?J-HH
MHKN.8****`"BBB@`I8_^0=XB_P"P>O\`*6DI8_\`D'>(O^P>O\I:X,Q_@_-?
MF=6$_B?)B=J*.U%=RV.5DMC_`,AS3O\`KJ__`**>O<O!'_(E:1_U[+7AMC_R
M'-._ZZO_`.BGKW+P1_R)6D?]>RUXF*_WE^B/0I?P5ZF_2'[I^E+2'[I^E9C,
M+PA_R!'_`.OV[_\`1\E;U8/A#_D"/_U^W?\`Z/DK>J8?"C6O_$EZA1115&04
M444`%%%%`!7S3)_QZZ3_`+ES_P"C%KZ6KYFN)!'9Z2Q61OEN1B.-G/\`K%[`
M&B+2K0;[E6O"5NP^BH/M2_\`/"[_`/`63_XFC[4O_/"[_P#`63_XFO;]O3_F
M1Y_LY]B>BH/M2_\`/"[_`/`63_XFC[4O_/"[_P#`63_XFCV]/^9![.?8GHJ#
M[4O_`#PN_P#P%D_^)H^U+_SPN_\`P%D_^)H]O3_F0>SGV)Z2+_C]E_Z\+C_V
M2H?M2_\`/"[_`/`63_XFG6THEO9L1S+BPN/]9$R?W/4"N7&582H229MAX251
M-H6#_CWC_P!T?RJ2JL-RH@C_`'-U]T?\NLGI_NT_[4O_`#PN_P#P%D_^)KIC
M6IV7O(R=.=]B>BH/M2_\\+O_`,!9/_B:/M2_\\+O_P`!9/\`XFG[>G_,A>SG
MV)Z*@^U+_P`\+O\`\!9/_B:/M2_\\+O_`,!9/_B:/;T_YD'LY]B>BH/M2_\`
M/"[_`/`63_XFC[4O_/"[_P#`63_XFCV]/^9![.?8MS?\BYHG_7TW_H$M1TMP
MX7PQHKE9#_I3<+&Q;[DO8#-5_M2_\\+O_P`!9/\`XFN#+ZL(PE=]6=6*A)R5
MET1;CB\P$[@H!`Y!.<_2G-`%;:T@5O0JP/\`*BWRT`8"5"S*PS$X(&2,XQ_G
MCUJU),BS1D)-(B(54B-@0?4Y%8U\PY:CC"1XE6M4C.T;E<6I)(#9(ZC8W'Z5
M%(FQ@-P8$9!%:'GQ_;GF'G!<@X,3\\=1@=?K6;>3A95'E7)^4?=@=OY"GA,>
MZE3EF]+!AJM6I4Y6GL)14'VI?^>%W_X"R?\`Q-'VI?\`GA=_^`LG_P`37J>W
MI_S(]'V<^P^3_66O_7U!_P"C5J:Y_P"0OJ7_`%\?^R+50W`>:U417"YNH.6M
MW4?ZU>Y&*FO)Q'K.H@QSM^_ZI`[C[B]P"*XG5A];3OI8Z%"7L&K=1]%0?:E_
MYX7?_@+)_P#$T?:E_P">%W_X"R?_`!-=OMZ?\R.?V<^Q/14'VI?^>%W_`.`L
MG_Q-'VI?^>%W_P"`LG_Q-'MZ?\R#V<^Q/14'VI?^>%W_`.`LG_Q-'VI?^>%W
M_P"`LG_Q-'MZ?\R#V<^Q/2Q_\@[Q%_V#U_E+5?[4O_/"[_\``63_`.)J6WD$
MFF>(F"2+_H"\/&R'I+V(!KBS"K"5&R?5?F=.%A)5-5T8[M14'VI?^>%W_P"`
MLG_Q-'VI?^>%W_X"R?\`Q-=BK4[?$CF]G/L7+'_D.:=_UU?_`-%/7N7@C_D2
MM(_Z]EKPG39A)KVG`1SKB1SF2%T'^K?N0*]V\$?\B5I'_7LM>1B9*6);3Z([
MJ::I)/N;](?NGZ4M(QPIJ`,+PA_R!'_Z_;O_`-'R5O5@>$"/[$?G_E]N_P#T
M?)6_4P^%&M?^)+U"BLRW\1Z)=Z@=/MM8T^:]!(-O'<HT@(Z_*#GBM.J,@HHH
MH`****`"OFZ.YT^U@TE]216A,=R`&A,GS>8O8`]L\U](U\TR?\>ND_[ES_Z,
M6LY4U5G&#ZLTA/DC*2+W]L>$_P#GA%_X+W_^(H_MCPG_`,\(O_!>_P#\15&B
MNO\`L:'\[,O[0E_*B]_;'A/_`)X1?^"]_P#XBC^V/"7_`#PB_P#!>_\`\15&
MBE_8T/YV']H2_E1>_MCPG_SPB_\`!>__`,11_;'A/_GA%_X+W_\`B*HT4?V-
M#^=A_:$OY47O[8\)_P#/"+_P7O\`_$5`U[H]U=N-+C1&6QN-^VV:+CY,=5&:
M@I(O^/V7_KPN/_9*RKY9&C3<U)NQI3QLJDE&Q;@U?PH+>,-!%N"C/_$O<\X_
MW*D_MCPE_P`\(O\`P7O_`/$5FP?ZB/\`W1_*I*U63P:OSLCZ_):<J+W]L>$_
M^>$7_@O?_P"(H_MCPG_SPB_\%[__`!%4:*/[&A_.Q?VA+^5%[^V/"?\`SPB_
M\%[_`/Q%']L>$O\`GA%_X+W_`/B*HT4_[&A_.P_M"7\J+W]L>$_^>$7_`(+W
M_P#B*/[8\)_\\(O_``7O_P#$51HI?V-#^=A_:$OY466N=/BT31I[E5-E]K<A
M3"6&"DN/EP3Z=N*E_MCPG_SPB_\`!>__`,156;_D7-%_Z^F_]`EJ.N?#9=&O
M%MR:LVC:MBW3:270OG6O"C8+11L0,9-@YX_[XI/[8\)_\\(O_!>__P`151(F
MD!*XP.I+`?SI?(?UC_[^+_C6CRNA%\KJ,Y?[2C'W;(M?VQX2_P"?>+_P7O\`
M_$4?VQX2_P">$7_@O?\`^(JKY#^L?_?Q?\::Z-&V&QGKP<T1RNA)VC48XYFF
M[)(N?VQX3_YX1?\`@O?_`.(H_MCPG_SPB_\`!>__`,15&BM/[&A_.R_[0E_*
MB>YU/PY.+>.RAC6X:Z@V$63(?]:G<J,5*VHZ#;:EJ,>HQ1M/]HSEK1I.-BXY
M"FL^3_66O_7U!_Z-6IKC_D+ZC_U\?^R+6#RV*K*ES/:YK]<?L^>W4N?VQX3_
M`.>$7_@O?_XBC^V/"?\`SPB_\%[_`/Q%4:*W_L:'\[,O[0E_*B]_;'A/_GA%
M_P""]_\`XBC^V/"?_/"+_P`%[_\`Q%4:*?\`8T/YV']H2_E1>_MCPG_SPB_\
M%[__`!%']L>$O^>$7_@O?_XBJ-%+^QH?SL/[0E_*B]_;'A/_`)X1?^"]_P#X
MBH&NM-N;/Q!)IR*MNNGJ'"P&,9Q+G@@9XQ4%+'_R#_$7_8/7^4M88G+8T(<Z
MDWL:T<7*I+E:+O\`;'A/_GA%_P""]_\`XBC^V/"7_/"+_P`%[_\`Q%4:*W_L
M:#^VS/\`M"7\J+T%_HEUK&G)ID:+,)6+%;5HOE\I^Y4=\<5[3X(_Y$K2/^O9
M:\-L?^0YIW_75_\`T4]>X^"/^1*TC_KV6N9T%0K."=]$:.JZM-29T%9^L1V$
MU@R:C*([?(RQF,7/;D$5H5#<6\5S$8YXDD3KM=01^M4]B8NTDSC_``+;Z.D+
M26UP&O//N0$%TS?)YS8.W=CICG'\Z[*XV?9I?,)";#N(Z@8KSYY[K0OA]J.K
M:)I\4VI175PJ8@+D+]I92<+R0JY./]FH?A[XHUO7-:OK*\O)-5TU+<2"]ETP
MV120MCRMI)##;SGVYJ::M%&V*ES59.]_4\\\(6V@Q^,]$MX=4$UA:W$36UY;
MZ*D+R2NA,44UPOS9(/0CYN0<=OHX=*X?2?A/X7T;6%U&TANQLE6>.V:Y8P)(
MN=KA.Y&3C.<=J[BK.<****`"BBB@`KYID_X]=)_W+G_T8M?2U?-,EJ]W::3'
M'</`P2Y.Y5#9_>+QR*AU%3J0G+9,UITI54X1W844?V+=?]!>?_OS'_A1_8MU
M_P!!>?\`[\Q_X5Z/]JT/,/[&Q79!11_8MU_T%Y_^_,?^%']BW7_07G_[\Q_X
M4?VK0\P_L;%=D%%']BW7_07G_P"_,?\`A1_8MU_T%Y_^_,?^%']JT/,/[&Q7
M9!21?\?LO_7A<?\`LE+_`&+=?]!>?_OS'_A1#82VEY*9;R2XW6%P`&15Q]ST
M%88G,*-6DX1W*AE>(HRYYK1$<'_'O'_NC^524R'1;HP1D:M,`5''DQ^GTI_]
MBW7_`$%Y_P#OS'_A6RS2@E;4G^Q\4];!11_8MU_T%Y_^_,?^%']BW7_07G_[
M\Q_X4_[5H>8?V-BNR"BC^Q;K_H+S_P#?F/\`PH_L6Z_Z"\__`'YC_P`*/[5H
M>8?V-BNR"BC^Q;K_`*"\_P#WYC_PH_L2Z_Z"\_\`WYC_`,*/[4H>8?V-BNR)
M)O\`D7-$_P"OIO\`T"6HZDFM9)?#FBVZW#1N+IAYH4$\)+V/%1_V)=?]!>?_
M`+\Q_P"%<F#QU*C!J75LNIEU>NU*"VT+,*.(=PVC<ZX+$8[U8F\L3QF0JVQ,
M;UPVYO<#M5.32[MG!CU:>,!0N%C3L/IW//XTW^R[_P#Z#EU_W[3_``KFJXB-
M6?.W8\V?#V.J2YM$:H,'VF<JRY++\V0,#'.,UFW(`D4`Y&T8/K3/[+O_`/H.
M77_?M/\`"FMHUXQRVL7!/J8H_P#"C!UJ5"IS.388?AO&4I\SU^8E%']BW7_0
M7G_[\Q_X4?V+=?\`07G_`._,?^%>I_:M#S._^QL5V1')_K+7_KZ@_P#1JU-<
M_P#(7U+_`*^/_9%J&32KB"2VE?4I956Z@RAC0`_O5[@5-<Z;/=:MJ,D=_)`O
MGXV+&A'W%]17,\?2>(53I:Q?]FUU#V5M=QM%']BW7_07G_[\Q_X4?V+=?]!>
M?_OS'_A73_:M#S(_L;%=D%%']BW7_07G_P"_,?\`A1_8MU_T%Y_^_,?^%']J
MT/,/[&Q79!11_8MU_P!!>?\`[\Q_X4?V+=?]!>?_`+\Q_P"%']JT/,/[&Q79
M!2Q_\@[Q%_V#U_E+2?V)=?\`07G_`._,?^%.BLY+73_$,4ER\[-8*0[*H(XE
MXP!BN7%X^E5I\L>Z+IY;7H2YIK0;VHH_L2Z_Z"\__?F/_"C^Q;K_`*"\_P#W
MYC_PKI6:4/,C^QL4^B);'_D.:=_UU?\`]%/7N7@C_D2M(_Z]EKPVPTZ:TUO3
MI)+Z2<&1QM:-5Q^[?G@5[CX(_P"1*T?_`*]EKAJ5HUJ[G':R">'G0@H3W.@I
M#]T_2EJIJ%U+:6K2PV<UV^<>5"5#?7YB!^M,S2N[(XB\M=9O?ACJD&@22IJ3
M75SY7E2"-V`NF+*K'H2H8`^]4/AI8>*='UB>WU@W8L+N"2>."^OUGF@82[47
MKGE#R0-O"]SBKFGV=SXH\(WVAM#J.FK<3W#+?QN@\M_/9@/E?=D'@]C@\UH>
M'/AQ:>&?$HUFWU2_N6-DUJT=Y*9<Y=6W!B>/N=/>IA\*-<1%QJR3.UHHHJC$
M****`"BBB@`KYRMO]7I7_7*Y_P#1BU]&U\Y6W^KTK_KE<_\`HQ:YL3LCNR_^
M,C0HHHKA/J`HHHH`****`"JEQ_Q]-_UXW'_LE6ZJ7'_'TW_7C<?^R4T<^+_A
M,G@_X]XO]P?RJ2HX/^/>+_<'\JDI/<WC\*"BBB@84444`%%%%`,IC_D$Z-_U
M]O\`^@35<JF/^03HW_7V_P#Z!-5RAG'@O@?J%%%%!V!1110`4444`5KW_5P?
M]?4'_HU:>G_'_J'_`%\?^R+3+W_5P?\`7U!_Z-6GI_Q_ZA_U\?\`LBTSD?\`
MO*]":BBBD=84444`%%%%`!5*?_CWU[_L'+_[6J[5*?\`X]]>_P"P<O\`[6IG
M)C/X9=HHHI'6MB,?\A73?^NS?^BGKV+P1_R)6D?]>RUXZ/\`D*Z;_P!=F_\`
M13U[%X(_Y$K2/^O9:ZL-\3/G<T_B&_2'[II:0_=/TKM/+,'PA_R!'_Z_;O\`
M]'R5OU@^$/\`D"/_`-?MW_Z/DK>J8?"C6O\`Q)>H44451D%%%%`!1110`5\Y
M6W^KTK_KE<_^C%KZ-KYRMO\`5Z5_URN?_1BUS8G9'=E_\9&A1117"?4!1110
M`4444`%5+C_CZ;_KQN/_`&2K=5+C_CZ;_KQN/_9*:.?%_P`)D\'_`![Q?[@_
ME4E1P?\`'O%_N#^524GN;Q^%!1110,****`"BBB@&4Q_R"=&_P"OM_\`T":K
ME4Q_R"=&_P"OM_\`T":KE#./!?`_4****#L"BBB@`HHHH`K7O^K@_P"OJ#_T
M:M/3_C_U#_KX_P#9%IE[_JX/^OJ#_P!&K3T_X_\`4/\`KX_]D6F<C_WE>A-1
M112.L****`"BBB@`JE/_`,>^O?\`8.7_`-K5=JE/_P`>^O?]@Y?_`&M3.3&?
MPR[1112.M;$8_P"0KIO_`%V;_P!%/7L7@C_D2M(_Z]EKQT?\A73?^NS?^BGK
MV+P1_P`B5I'_`%[+75AOB9\[FG\0WZ0_=/TI:0_=/TKM/+,+PA_R!'_Z_;O_
M`-'R5O5PR>(HO"O@"^UB6!IU@O;@")7";F>Z9%!8\`989/84SP3\0;GQ-K%S
MI.H:7!9W<4'VE#:W\=W&T>[;RT>0K9(X)YZU,/A1K7_B2]3O****HR"BBB@`
MHHHH`*^<K;_5Z5_URN?_`$8M?1M?.5M_J]*_ZY7/_HQ:YL3LCNR_^,C0HHHK
MA/J`HHHH`****`"JEQ_Q]-_UXW'_`+)5NJEQ_P`?3?\`7C<?^R4T<^+_`(3)
MX/\`CWB_W!_*I*C@_P"/>+_<'\JDI/<WC\*"BBB@84444`%%%%`,IC_D$Z-_
MU]O_`.@35<JF/^03HW_7V_\`Z!-5RAG'@_@?J%%%%!V!1110`4444`5KW_5P
M?]?4'_HU:>G_`!_ZA_U\?^R+3+W_`%<'_7U!_P"C5IZ?\?\`J'_7Q_[(M,Y'
M_O*]":BBBD=84444`%%%%`!5*?\`X]]>_P"P<O\`[6J[5*?_`(]]>_[!R_\`
MM:F<F,_AEVBBBD=:V(Q_R%=-_P"NS?\`HIZ]B\$?\B5I'_7LM>.C_D*Z;_UV
M;_T4]>Q>"/\`D2M(_P"O9:ZL-\3/G<T_B&_2'[I^E+2'[I^E=IY9YSJM]<Z=
M\*=7N;2TANI%NK@&.:$RIL-TP9F0=0JDMCVK&^#NI2_VC>V9TZP%K<1//:ZA
M9:=]E$Z)(8_F``!!SD#J,-FNAGL-7U+X<:A;Z#<-!J?VV=X&$ACR5NF8KN!!
M&X`KU[UA_"CPUXMTC5KBZURWNK.&2V99TGO1-]IG,F5D55R$"H-O7G^4P^%&
MM?\`B2]3UNBBBJ,@HHHH`****`"OFNWOK94TX&9<QI<*_P#LDR+@'\C7TI7@
M>AG4_P"R(?)NK-8]S[5>V9B!O/4B09_*N3%NT4SKP<G&I=%3^TK/_GX3\Z/[
M2L_^?A/SK<SK'_/Y8_\`@&__`,=HSK'_`#^6/_@&_P#\=KS_`&G]?TCV/KL^
MQA_VE9_\_"?G1_:5G_S\)^=;F=8_Y_+'_P``W_\`CM&=8_Y_+'_P#?\`^.T>
MT_K^D'UV?8P_[2L_^?A/SH_M*S_Y^$_.MS.L?\_EC_X!O_\`':,ZQ_S^6/\`
MX!O_`/':/:?U_2#Z[/L8?]I6?_/PGYU5GO[5KAB)U(^QSIGW.W`_'!KILZQ_
MS^6/_@&__P`=HSK'_/Y8_P#@&_\`\=IJI_7](BIB9U(\K1S\.HV:P1@W"`A0
M/TJ3^TK/_GX3\ZW,ZQ_S^6/_`(!O_P#':,ZQ_P`_EC_X!O\`_':7M/Z_I%K&
M32M8P_[2L_\`GX3\Z/[2L_\`GX3\ZW,ZQ_S^6/\`X!O_`/':,ZQ_S^6/_@&_
M_P`=H]I_7](/KL^QA_VE9_\`/PGYT?VE9_\`/PGYUN9UC_G\L?\`P#?_`..T
M9UC_`)_+'_P#?_X[1[3^OZ0?79]C#_M*S_Y^$_.C^TK/_GX3\ZW,ZQ_S^6/_
M`(!O_P#':,ZQ_P`_EC_X!O\`_':/:?U_2#Z[/L<R+^U_LW2D\Y=T=R[..ZC9
M*,G\Q^=6O[2L_P#GX3\ZW,ZQ_P`_EC_X!O\`_':,ZQ_S^6/_`(!O_P#':?M/
MZ_I&5+$2IJR1A_VE9_\`/PGYT?VE9_\`/PGYUO1MJ8)\VYM&';;;,O\`[4-2
M"6]/_+:W_P"_+?\`Q59/$13L9SS=0ER-:_UYG._VE9_\_"?G1_:5G_S\)^==
M%YMX1GSK?'_7%O\`XJHF;568F.[LE7L&M7)_/S!3CB(R=AT\W527+'??^M3"
M_M*S_P"?A/SH_M*S_P"?A/SK<SK'_/Y8_P#@&_\`\=HSK'_/Y8_^`;__`!VK
M]I_7](Z/KL^QS=WJ%H\<06=21<0L<>@D4D_D*>FH6@O;YO/3:\^Y3ZC:HS^E
M=#G6/^?RQ_\``-__`([0#JX(S>6)'H+1Q_[5H=5)?U_D8SQ4HR]JULC,CFMY
M2%20,QQ@;@,DC(H6>W:"2<-^[C.&;=T/Y5M(US\XE>-E)X"(5^N3N.>?I4!&
MH%I";BWR3F/%N<+]?GYX^E<?M9WT78\2>8XWF?+%O;O\^IF//;(VUI5#%-X&
M[/&,YZ>E5O[2L_\`GX3\ZZ&3[2RJ8WB23JS&,D$_3<._O_C46=8_Y_+'_P``
MW_\`CM:T*LFGS'?EN.Q34O;+TN8?]I6?_/PGYT?VE9_\_"?G6YG6/^?RQ_\`
M`-__`([1G6/^?RQ_\`W_`/CM;^T_K^D>E]=GV,/^TK/_`)^$_.JDU_:F#6@)
ME)EL52,?WF_>\#WY'YUT^=8_Y_+'_P``W_\`CM&=8_Y_+'_P#?\`^.T_:?U_
M2,ZN(E4C9HP_[2L_^?A/SH_M*S_Y^$_.MS.L?\_EC_X!O_\`':,ZQ_S^6/\`
MX!O_`/':7M/Z_I&BQL^Q@#4;/^TK!_M";4E8L>P'EN.?Q(KVKP.0W@C1V4Y!
MME(->:9UC_G\L?\`P#?_`..UZ7X'S_PA&C[B"WV9<D#`KMPDN9L\O'5'-J3.
M@I#]T_2EI#]T_2NXX#"\(?\`($?_`*_;O_T?)6]6#X0_Y`C_`/7[=_\`H^2M
MZIA\*-:_\27J%%%%49!1110`4444`%>&:!_R!8/J_P#Z&U>Y]J\X@^%][:Q>
M5;^)W2(%BJFQ0XR2<9W<]:YL32E4C:)M0J*#NS%HK>_X5OJ?_0TM_P"`"?\`
MQ5'_``K?4_\`H:6_\`$_^*KB^I5#J^M0,&BM[_A6^I_]#2W_`(`)_P#%4?\`
M"M]3_P"AI;_P`3_XJCZE4#ZU`P:*WO\`A6^I_P#0TM_X`)_\51_PK?4_^AI;
M_P``$_\`BJ/J50/K4#!HK>_X5OJ?_0TM_P"`"?\`Q5'_``K?4_\`H:6_\`$_
M^*H^I5`^M0,&BM[_`(5OJ?\`T-+?^`"?_%4?\*WU/_H:6_\``!/_`(JCZE4#
MZU`P:*WO^%;ZG_T-+?\`@`G_`,51_P`*WU/_`*&EO_`!/_BJ/J50/K4#!HK>
M_P"%;ZG_`-#2W_@`G_Q5'_"M]3_Z&EO_```3_P"*H^I5`^M0,&BM[_A6^I_]
M#2W_`(`)_P#%4?\`"M]3_P"AI;_P`3_XJCZE4#ZU`P:*WO\`A6^I_P#0TM_X
M`)_\51_PK?4_^AI;_P``$_\`BJ/J50/K4#`R<].E(`><YY[UT'_"MM2_Z&EO
M_`!/_BJ/^%;ZG_T-+?\`@`G_`,56+RRI)W;/.G1IU)<TY/\`X<Y[!QCGO3E&
M!6__`,*WU/\`Z&EO_`!/_BJ/^%;ZG_T-+?\`@`G_`,53AEDX.Z8\-0H8>?/&
M^UC!HK>_X5OJ?_0TM_X`)_\`%4?\*WU/_H:6_P#`!/\`XJM?J50]#ZU`P:*W
MO^%;ZG_T-+?^`"?_`!5'_"M]3_Z&EO\`P`3_`.*H^HU!/$TVK,P:*WO^%;ZG
M_P!#2W_@`G_Q5'_"M]3_`.AI;_P`3_XJCZE4']:@8-%;W_"M]3_Z&EO_```3
M_P"*H_X5OJ?_`$-+?^`"?_%4?4J@?6H&#16]_P`*WU/_`*&EO_`!/_BJ/^%;
MZG_T-+?^`"?_`!5'U*H'UJ!@T5O?\*WU/_H:6_\``!/_`(JC_A6^I_\`0TM_
MX`)_\51]2J!]:@8-%;W_``K?4_\`H:6_\`$_^*H_X5OJ?_0TM_X`)_\`%4?4
MJ@?6H&#7H7@C_D2M(_Z]EKF_^%;ZG_T-+?\`@`G_`,57::)I@T;1+/31*TPM
MHA'YC``MCO@=*ZL+0E2;YCGKU8U+6+](>AI:J:@+TVI%@T"SY&#,I*X[]"#7
M88)7=C+\(?\`($?_`*_;O_T?)6_7+^$[+7+&!HM0^RI`9IWV(IWY:5F!SG&#
MG/K@BNHJ8?":UTO:.SN%%%%48A1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`48HHH`3%+110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%<1\0/B)%X$>R66Q%S]KAF=/WVPET,85>AZF3KV`/6@#M
MZ*YWP=XFE\3Z7<SW-@;"\M+N6SN;?S!($DC.#A@`&'(Y%=%0`4444`%%%%`!
M1110!R&K?$_PCHNISZ;>:J!>P.L<L*0NQ4D9SD#&`.2<\=^:ZY6#*&!R#R"*
M^<?&_P#PC<GBG6OLD>OJ1=R_;6@:(0*H5/M90'DD_N\CKG&..*^B++R/L%O]
MEV_9_+7RMO39CC'X8H`GHHHH`****`"BBB@"CJ^L:?H.FRZCJEREM:1$!Y7S
M@9(`Z>Y%8V@?$+PQXGU273M(U-+BYC&[:$8;E`&64D<CD"I/'5UI%GX-U"?7
M=/FU#3%51/;PQ[V(+`9`R.AP<Y&,9KS[X.ZE9G7-<LK73=9:.25)8+R^M54I
M&(D`21QT8C!'J,'O0![)1110`4444`%%%%`!7.:[XZ\/>&M8M-,UB^%I/=IO
MB:13LQG'+=%Y]>*Z.O+_`!_K>CZ)XQ22^TQM1N[C1VMH+1Y4$5QON(P$PP^]
MGG.>`#QW`!Z;#-%<0I-#(DD3@,KHP(8>H(ZT^N.^&G]G#PHT>FZ9)IB17<\4
MMD\WF^3*KD.JMW&1G\:[&@#'\1^)M+\*Z>E[JDSI')((HTCC+O(Y[*HY/`)_
M"H?#/C#1_%T-Q)I4TK-;.$FBFB:-XR1D95AGD5S?Q=OM*L/#ME+J%M<2S_;%
M-I);7/V>2%PK$N).@PH;@]3@>XS_`(,W]I>V^LD6MRFI%X);FYN;K[1)<(\>
MZ(L^`,A<C`'%`'J5%%%`!1110`4444`%%%%`!117*?$/0]5\0>%S8Z4Z%_/1
MY[=Y3$+J$?>BWCE=W'/M0!U=%>>?#/PKK/AJ757OK>'3M/N&C-MID5TUR(6`
MP[[VY^;CBO0MP/2@#Q6V\7>.G\4Q1.NIFY?4/(ETQM(Q:QP;R"PGSDX7G=7M
M?:O&+;X:^*5N-/U6?5+R74XM161XY+TF.,><6DF7GD-&%79C/7GM7L_:@`HH
MHH`****`"O/_`(B:1JVM:QH=KIEAILRJES*\^H:<MU&C*$*1EB/W8<Y&1S\H
M]*]`KSCXM>'_`!7K5A9MX7ED8HLD5S;1W/DF17*$-DD*<;2.>S'%`%CX3C5A
MI.O?VQ8&PN3K5PPM_+"JJD(?E./F&2V&YSZFN_KC_AMHNJ:%X5^R:I&UNQN9
M9+>S:<3&TA)^2+S!]['//O784`%%%%`!1110`4444`>&^+M3UM-.\;SP:)8G
M2$NI+:>.-#YX?:A%PW.&1N`P]`.N#7LFBSO<Z%I\\I!DEMHW8@8&2H)X'2O/
M_$\?Q4O&UVTTD:1'8@8LI%+)<2JW.%._"LO0EL`]J]#TI+B/2+)+O/VE8$$N
M3D[]HW<]^<T`6Z***`"BBB@`HHHH`Y[QSK5SX>\%ZIJMG;"XG@BRJ,N5&2`6
M8=U4')'H*\O^"^M7$GBC5+&.TM([2[@%XZ6<+HD#@JBM\W19%^<`=!C@<UZY
MXE.LKX?O'\/I;2:HJ;H([D920CJIY')&0"2!DC-<=X=L?'__``G-K?\`B$6"
MZ>VGLDBZ>VU%DW`JKJQRS#+<C(]Z`/1J***`"BBB@`HHHH`*\O\`BVVLV'V;
M5K#0-"O[6")A+>7]D;B:T8$D,N.0OO@@'K@5ZA7$>*_#.M:_XIL9;?5[_3],
MAM)/GLKD)BYW`H70_?7`Z?\`UZ`+?PWBO4\"Z=+?Q6,<US&+G_0E9582`/N;
M/\9SEL<9Z5UE<E\/-.US3/#L\7B$`:A)?3S-M<,I5GR"N"<+Z#L*ZV@#S[XO
M7%_:>%K>ZM-(M=3@AN1)<0W%MYX4!6VMM]-V`3V!K-^"<EU+I>L/+;Q""6Y2
M9;F.T^S"61HU,B[..%;C/0\UU7C?1-6UZVTRTTZ_N;.W^VJU\]I/Y,IAVMG:
MWL=O'?\`#G*\!>'?$>A>)O$KZW>R7]K.MJEE=O("95164Y7.0P&T$X&X\\T`
M=]1110`4444`%%%%`!1110`4AI:*`,6X?78DD:*.PG&#M0N\9_/#?RKC?#E_
MXB:;2O*M;:8G2E*B6\<!UROSM\A^;VY^M>ED`BF)!%&5*1JI5=HP,8'I]*AP
M;=[G33KJ,7%Q3N<]#<^,%)\[3=)?TV7DBX_\AFIOMOBC_H$:;_X'O_\`&JWZ
M*?+YF?M5_*OQ_P`S`^V^*/\`H$:;_P"![_\`QJC[;XH_Z!&F_P#@>_\`\:K?
MHHY?,/:+^5?C_F8'VWQ1_P!`C3?_``/?_P"-4?;?%'_0(TW_`,#W_P#C5;]%
M'+YA[1?RK\?\S`^V^*/^@1IO_@>__P`:K-\07WB4>'=1,FF6$2"VDW21WSEE
M&T\@>6.1]178TUT61"CJ&4C!!'!%)Q?<<:J33Y5^/^9SEK>^)S:0XTG3F&P<
MM?OD\?\`7*IOMOBC_H$:;_X'O_\`&JW@`!@4M/E?<'53=^5?C_F8'VWQ1_T"
M--_\#W_^-4?;?%'_`$"--_\``]__`(U6_11R^8O:+^5?C_F8'VWQ1_T"--_\
M#W_^-4?;?%'_`$"--_\``]__`(U6_11R^8>T7\J_'_,P/MOBC_H$:;_X'O\`
M_&J/MOBC_H$:;_X'O_\`&JWZ*.7S#VB_E7X_YG$WU]XD'B/2P=.LE<QS;8UO
MGVO]W.3Y?;MP>M:_VWQ1_P!`C3?_``/?_P"-5NF-"X<J"R\`XY%.Q247W+E6
MBTERK3U_S,#[;XH_Z!&F_P#@>_\`\:H^V^*/^@1IO_@>_P#\:K?HI\OF1[1?
MRK\?\S`^V^*/^@1IO_@>_P#\:H^V^*/^@1IG_@>__P`:K?JCK$J0:->RR7HL
M46!R;LX_<?*?GYXXZ\^E'+YA[1?RK\?\S.^V^*/^@1IO_@>__P`:H^V^*/\`
MH$:9_P"#!_\`XU7BK_$'Q"/"ETNF>)X[A+K5EM;6\O'A2:W@*N2\N/\`5AF7
MY2PX"GVJ/4/B3X@&A:0\6KW-DT-A+,LD@20WURDX0)NQAUV\\`>^>M'+YA[1
M?RK\?\SVTWGBC!_XE&F_^![_`/QJLGP[?>)&L9S'IUE,!>7`+2WS@@^:V0/W
M9X!X'L.@KKK&66XL+>:XB\F:2-6DC/\``Q&2OX'BIDC2,810H))P!W/6ERN^
MY2K146N5?C_F87VWQ1_T"--_\#W_`/C5'VWQ1_T"--_\#W_^-5OT4^7S)]HO
MY5^/^9@?;?%'_0(TW_P/?_XU1]M\4?\`0(TW_P`#W_\`C5;]%'+YA[1?RK\?
M\S`^V^*/^@1IO_@>_P#\:H^V^*/^@1IO_@>__P`:K?HHY7W#VB_E7X_YF!]M
M\4?]`C3?_`]__C59/B6^\2KX>O#+IUC"FSF2*^<LO(Z#RQ_.NUIKHLB%74,I
MZ@C(-)Q;5KE0K1C)2Y5IZF`MYXHVC_B4:;T_Y_W_`/C5.^V^*/\`H$:;_P"!
M[_\`QJM[%+3Y7W)]JOY5^/\`F<U=WOB<6<Q.E:<HV'++?OD<?]<JG\'S7D_A
MBP:]C16\B/8RR%RZ[1AFR!@GTY^M;I`(P1D&D1%C4*BA5`P`.@H4=;W'*JG#
MEY4AU%%%48A1110`4444`%%%%`!1110!S/CG7=3\.>'9-3TVWM9C"P,WVDR8
M5#QP(U+$Y('3`SDG`KB[_P",%W'IME>V.DVTJ)IT>IZB&N2?+C>01[(R!RV>
M>>!TZUW_`(C\.67B&UCCNYKR`PDLDEI<O"XSU&5/(/O7(+X1\%>)%T*V&F3P
MQ06"R0(DI0-!N!$<F#\WS'=]<\\TKHI0DU=(]'BD$T*2+G:ZAAGWI]-4HJA5
MV@#H!2[E_O"F2>4^#?B5XAU_Q-<:9J.G6%MLAFD@M]LL4\^PD#:7^0CCGG^1
MJ_IOC/Q1K7@:;6[.RTBUO+:]FCN8[V5Q%%#'G)W+DE@0/;K6WI_P_P!#TV_N
M+Z*2]DNI8GACEGNWD-NCCYA%D_+TZ]?PXJE:?"[0K/P[?Z$E]JCV-_*LLZR7
M622#D@''`)Z^N*`-;P)K6J>(O"-EJ^KVD-K<70,BQ19QY>?E/))Y'/XBNDJ.
M%(H(4AB")'&H557@*!T`I^Y?44`<)XP\9ZQX7\0Z;!]@LI-,O)TA5WE<2L25
M#$?+L7&X?>89[52TKXF7M]XTBTV72(X]*N;^XTZWN!/F430C+%EQC:<C&.G/
M6M?Q9X8T"\NXM8U5;R95EA1K:.Z<0RMO54+QYVG!(/X=ZAT/P?X6'BV^\06E
ME*E_#<N,/*3&DK*-[HF<`L&Y/MVI76Q7)+EYK:'<44FY?44;E]13)%HI-R^H
MHW+ZB@#)\4:T?#GAG4-76U>Z-I"9!"AP6Q[]AZGTKSK2/C1%/HNJRZA%8_;K
M9XH[06LY\FX>4$HI=P-NW!W$],$UZI>V\5]8W%I*[+'/&T;%&VL`PP2#V//6
MN;T;X>>%M$TR:R@TZ*X6=_,FDO,3.[X(W$MGGD],=30!QDWQ,\3R^`+'Q5IU
MMH4L3KY=U"\DAD$YD*K&BJ>I!4X)SSGI7JVGO=2:;:O?1I'=M$IG2,Y57P-P
M'L#FN8L?ASX?L+31;2)93;Z1.US#&SKB24]'DP/F8=CVP*Z_<OJ/SH`6BDW+
MZBC<OJ*`%HI-R^HHW+_>%`'GU]X\U;2?B#!H6H:;:"RN$EDA>*5O-V(K$,=P
M"9.T_*"2.M,\&^.)O&EU)IFM:/:Q07UC]OM45_-62W+F,K(&&-P(^AS5VY\'
M^&K+Q79:C<17=S<W5Q(88IKEY((9&1W=PC'`R`WXXP!4W@7PMX<T6";4]$MI
MHC>?+^_D+F-`Q^1<DX7.3BE=;%<DK<UM#>M_#6A6D,\-MHVG013@"9(K5%60
M#H&`'/?K5J73;&=;=9;*WD6V8-`'B4B(CH5XX/TJSN7U%&Y?44R1:*I:EJ<.
MFVZ32AF5YHX0%QG+N%!^F35L.N/O#\Z!\KM<=12;E]11N7U%`A:Q_%.M/X=\
M+ZAJ\=M]I>TB,@AW[-W/KVK7W+ZBL_6M(T[Q!I,^F:G"L]I.`'C+%<X((.0<
M@@@'\*`/+(/C7=R^$IKM=&BN=8%XEG#;6SN1(S(6R4*[QMP01CDC@XZ,U/XT
MWUOHVE_8=.M+G4+BU:ZO90)C!:(LA0[E"[^JD'.,''7-=BOPP\-+IT]J?MKS
M3RI,U\]XYN1(@(1A)G((#,!VYI;GX7^%;JSM+4VT\<=M&T68KJ1&F1FW.LA!
MRX9LDY]:`.NL;E;RPMKI'1UFB60-&<J00#D'N.:GJ&WB@M+:*V@5(X8D$<:+
MP%4#``_"I=R^HH`6BDW+ZBC<OJ*`%HJ.:=(87D)R$4L0/:H=.O8]1TZVO(@P
M2>-9%#=0",\_G1<?*[7+5%%%`@HHHH`****`"BBB@`HHHH`K7UG!?VDEK<1K
M)%(,,K=#7(Z7\/K*UDLS=V]O*L5F(9<9^>7(^;Z<&NWHQ4N";NS:GB*E.+C!
MV3,+_A#?#_\`T#(?UH_X0WP__P!`R']:W:*.6/87MZO\S^\PO^$-\/\`_0,A
M_6C_`(0WP_\`]`R']:W:*.6/8/;U?YG]YA?\(;X?_P"@9#^M'_"&^'_^@9#^
MM;M%'+'L'MZO\S^\Y35?`VD7-EY5I9012^;&VXY^Z'!8?B`1^-&G^!=)@DNS
M<V4$BR3EX@,_*F`,?F#75XHI>SC>]B_K=;EY>9V,+_A#?#__`$#(?UH_X0WP
M_P#]`R']:W:*?+'L1[>K_,_O,+_A#?#_`/T#(?UH_P"$-\/_`/0,A_6MVBCE
MCV#V]7^9_>87_"&^'_\`H&0_K1_PAOA__H&0_K6[11RQ[![>K_,_O,+_`(0W
MP_\`]`R']:/^$-\/_P#0,A_6MVBCECV#V]7^9_>87_"&^'_^@9#^M'_"&^'_
M`/H&0_K6U+-'"F^5U1>FYC@4DD\400R2(@=@J[F`R3T`]Z.6/8/;U?YG]YC?
M\(;X?_Z!D/ZT?\(;X?\`^@9#^M;7FQ^;Y6]?,`W%<\X]<4)+'(6".K;3M;:<
MX/H:.6/8/;U?YG]YR][X%TF6\L)(+*!(H96:92#\ZE&`'_?14_A1I7@;2+73
MHH;RQ@EG7.YQGGDD?I75T4O9QO>Q;Q=9QY>9V,+_`(0WP_\`]`R']:/^$-\/
M_P#0,A_6MVBGRQ[$>WJ_S/[SE-4\"Z3<VT:6EE!$ZSQ.S'/**X+#\0"/QJ\/
M!OA_'.F0_K6[BBCDCV*^LUK6YG]YA?\`"&^'_P#H&0_K1_PAOA__`*!D/ZUN
MT4<L>Q/MZO\`,_O,+_A#?#__`$#(?UH_X0WP_P#]`R']:W:*.6/8/;U?YG]Y
MA?\`"&^'_P#H&0_K1_PAOA__`*!D/ZUNT4<L>P>WJ_S/[S"_X0WP_P#]`R']
M:/\`A#?#_P#T#(?UK=HHY8]@]O5_F?WF%_PAOA__`*!D/ZT?\(;X?_Z!D/ZU
MNT4<L>P>WJ_S/[SGIO!>@O!(L>FP*Y4@'!X-6_#NC1:%HUO9QHBR+&OFE.CN
M%`)_2M:BA12=T@E7J2CRRDV@HHHJC(****`"BBB@`HHHH`****`#.*.M5K^:
M:"SEE@MS/*H^6-6"D_B>*Y;P[KFN2^'-/<Z)/=%K="9VN8P9.!\W)SSUJ7))
MV-8493BY*WWI'945@_VQK?\`T+<O_@5%_C1_;&M_]"W+_P"!47^-',A^PEY?
M>O\`,WJ*P?[8UO\`Z%N7_P`"HO\`&C^V-;_Z%N7_`,"HO\:.9!["7E]Z_P`S
M>HK!_MC6_P#H6Y?_``*B_P`:/[8UO_H6Y?\`P*B_QHYD'L)>7WK_`#-ZBL'^
MV-;_`.A;E_\``J+_`!H_MC6_^A;E_P#`J+_&CF0>PEY?>O\`,WJ*P?[8UO\`
MZ%N7_P`"HO\`&C^V-;_Z%N7_`,"HO\:.9!["7E]Z_P`S>HK!_MC6_P#H6Y?_
M``*B_P`:/[8UO_H6Y?\`P*B_QHYD'L)>7WK_`#-ZBL'^V-;_`.A;E_\``J+_
M`!H_MC6_^A;E_P#`J+_&CF0>PEY?>O\`,WJ*P?[8UO\`Z%N7_P`"HO\`&C^V
M-;_Z%N7_`,"HO\:.9!["7E]Z_P`SF/C!LD\-PVX\+W>O7,K.(%AA>1;9MN/,
M8)W&>`>O/(KS#5_"OB:[30GM]/UN[BAL(8;!+NS4[)5<[Q,I;]R,`X;DXVC-
M>[?VQK?_`$+<O_@5%_C1_:^M?]"W+_X%1?XT<R#V$O+[U_F>,VWA?Q8_Q(NK
MZ'2;ZWO99;MC/+S#"KQE8V6X#9D`."$*C'`^G2_![0M6TO5K^6YTB\TRV%E#
M!<+<G_CXNE8[Y5_O`@]??O7H']KZU_T+<O\`X%1?XTO]KZW_`-"W+_X%1?XT
M<R#V$O+[U_F;U%8/]L:W_P!"W+_X%1?XT?VQK?\`T+<O_@5%_C1S(/82\OO7
M^9O45@_VQK?_`$+<O_@5%_C1_;&M_P#0MR_^!47^-',@]A+R^]?YF]16#_;&
MM_\`0MR_^!47^-']L:W_`-"W+_X%1?XT<R#V$O+[U_F;U%8/]L:W_P!"W+_X
M%1?XT?VQK?\`T+<O_@5%_C1S(/82\OO7^9O45@_VQK?_`$+<O_@5%_C1_;&M
M_P#0MR_^!47^-',@]A+R^]?YF]16#_;&M_\`0MR_^!47^-']L:W_`-"W+_X%
M1?XT<R#V$O+[U_F;U%8/]L:W_P!"W+_X%1?XT?VQK?\`T+<O_@5%_C1S(/82
M\OO7^9O45@_VQK?_`$+<O_@5%_C1_;&M_P#0MR_^!47^-',@]A+R^]?YF]1F
MN;NM9UL6LQ_X1Z9,(?F^U1\<=>M6/"5Y=WWANQFO(9(Y#"GSNX8RC:/GX]??
MFA23=@E0E&'.[?>C<HHHJC$****`"BBB@`HHHH`****`$(!ZTR""*V@2""-8
MXHU"HBC`4#H`*DHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`:RJZE6`
K*D8(/>FPPQV\*0PHJ1HH5448"@=`*DHH`****`"BBB@`HHHH`****`/_V56`
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
  <lst nm="TslInfo">
    <lst nm="TSLINFO">
      <lst nm="TSLINFO">
        <lst nm="TSLINFO" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Add grid reference offset" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="10/30/2024 1:53:06 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17142: Fix orientation of description" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="12/7/2022 1:39:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option to use the real body of the beams in zone 0" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="8/10/2021 2:51:20 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option to dimension only points within a certain range." />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="6/18/2021 2:53:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option to not dimension points outside the reference boundary" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="3/4/2021 4:19:16 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End