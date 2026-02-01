#Version 8
#BeginDescription
#Versions
Version 5.25 03.11.2025 HSB-24830: Support the previous styles TT,TL , Author: Marsel Nakuci
Version 5.24 17.10.2025 HSB-24722: Change TT->DQ and TL->DL , Author: Marsel Nakuci
Version 5.23 26.05.2025 HSB-24086: V5.11 only to be applied on creation , Author: Marsel Nakuci
Version 5.22 26/03/2025 HSB-23619: For Sips add additional variable in format "ViewSide"  , Author Marsel Nakuci
Version 5.21 24.02.2025 HSB-23527: KLH: Compose body from array of bodies if body in map not possible , Author: Marsel Nakuci
Version 5.20 10.02.2025 HSB-23446: KLH: Use color magenta for Oberflächenveredelung , Author: Marsel Nakuci
Version 5.19 03.02.2025 HSB-23445: Fix transformation for klhCombiTruck , Author: Marsel Nakuci
Version 5.18 13.01.2025 HSB-23243: Consider klhCombiTruck TSLs , Author: Marsel Nakuci
5.17 09.12.2024 HSB-23131: Show command to ignore check for "klhLiftingDeviceAdditional" only if needed to ignore Author: Marsel Nakuci
5.16 04.12.2024 HSB-23058: Add check for "klhLiftingDeviceAdditional" Author: Marsel Nakuci
Version 5.15 21.10.2024 HSB-22813: Add reference via DataLink to reference entity , Author Marsel Nakuci
5.14 05/08/2024 HSB-22499: For KLH add as additional format @(CoatingCode) Marsel Nakuci
5.13 05.10.2023 HSB-20243: KLH: set text color from highest quality
5.12 12.09.2023 HSB-19939: Apply contour thickness on the inside
5.11 05.09.2023 HSB-19958: KLH: For "R" and "F" f_Item must be positioned on the reference side 
5.10 10.07.2023 HSB-19483: Apply thickness at contour 
5.9 28.06.2023 HSB-19334: get from xml flag "PropertyReadOnly" 
5.8 27.06.2023 HSB-19334: On insert set properties to readonly for KLH 
5.7 27.06.2023 HSB-19334: Set "Lagentrennung" text at the top of the display text 
5.6 02.06.2023 HSB-19078: Fix when adding Tag to format for KLH
5.5 26.05.2023 HSB-18964: For KLH Modify Tag property if flag "BeddingRequested" is set (it is set from f_Truck) 
5.4 04.05.2023 HSB-18847: Fix name and MP-Text 
5.3 23.03.2023 HSB-18371: Write name and MP-Text in the mapX 
5.2 29.08.2022 HSB-16359 add lifting device trigger 
5.1 02.07.2021 HSB-12497: display if stacking orientation not same as klhDevice orientation
5.0 25.01.2021
HSB-10448 item creation prevented if parent or child entities of element relations are stacked 
4.9 21.01.2021
HSB-9303 bugfix column offset during creation
HSB-9873 Text drawn at center of elements
HSB-9860 The transformation of the stacking item published
HSB-9873 entities which belong to an element are refused if the element has an associated item 
HSB-9860 The transformation of the stacking item to the reference plane has been fixed for source entities 
like MassElement, RoofElement and other classes not being based genBeam
HSB-9338 internal variable renaming </version>


EN:
This tsl creates a stackable item and shows it in XY World.




























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 5
#MinorVersion 25
#KeyWords Stacking;Truck;Nesting;Delivery
#BeginContents
// history, properties and on insert//region
/// <History>//region
// #Versions
// 5.25 03.11.2025 HSB-24830: Support the previous styles TT,TL , Author: Marsel Nakuci
// 5.24 17.10.2025 HSB-24722: Change TT->DQ and TL->DL , Author: Marsel Nakuci
// 5.23 26.05.2025 HSB-24086: V5.11 only to be applied on creation , Author: Marsel Nakuci
// 5.22 26/03/2025 HSB-23619: For Sips add additional variable in format "ViewSide"  , Author Marsel Nakuci
// 5.21 24.02.2025 HSB-23527: KLH: Compose body from array of bodies if body in map not possible , Author: Marsel Nakuci
// 5.20 10.02.2025 HSB-23446: KLH: Use color magenta for Oberflächenveredelung , Author: Marsel Nakuci
// 5.19 03.02.2025 HSB-23445: Fix transformation for klhCombiTruck , Author: Marsel Nakuci
// 5.18 13.01.2025 HSB-23243: Consider klhCombiTruck TSLs , Author: Marsel Nakuci
// 5.17 09.12.2024 HSB-23131: Show command to ignore check for "klhLiftingDeviceAdditional" only if needed to ignore Author: Marsel Nakuci
// 5.16 04.12.2024 HSB-23058: Add check for "klhLiftingDeviceAdditional" Author: Marsel Nakuci
// 5.15 21.10.2024 HSB-22813: Add reference via DataLink to reference entity , Author Marsel Nakuci
// 5.14 05/08/2024 HSB-22499: For KLH add as additional format @(CoatingCode) Marsel Nakuci
// 5.13 05.10.2023 HSB-20243: KLH: set text color from highest quality Author: Marsel Nakuci
// 5.12 12.09.2023 HSB-19939: Apply contour thickness on the inside Author: Marsel Nakuci
// 5.11 05.09.2023 HSB-19958: KLH: For "R" and "F" f_Item must be positioned on the reference side Author: Marsel Nakuci
// 5.10 10.07.2023 HSB-19483: Apply thickness at contour Author: Marsel Nakuci
// 5.9 28.06.2023 HSB-19334: get from xml flag "PropertyReadOnly" Author: Marsel Nakuci
// 5.8 27.06.2023 HSB-19334: On insert set properties to readonly for KLH Author: Marsel Nakuci
// 5.7 27.06.2023 HSB-19334: Set "Lagentrennung" text at the top of the display text Author: Marsel Nakuci
// 5.6 02.06.2023 HSB-19078: Fix when adding Tag to format for KLH Author: Marsel Nakuci
// 5.5 26.05.2023 HSB-18964: For KLH Modify Tag property if flag "BeddingRequested" is set (it is set from f_Truck) Author: Marsel Nakuci
// 5.4 04.05.2023 HSB-18847: Fix name and MP-Text Author: Marsel Nakuci
// 5.3 23.03.2023 HSB-18371: Write name and MP-Text in the mapX Author: Marsel Nakuci
// 5.2 29.08.2022 HSB-16359 add lifting device trigger Author: Marsel Nakuci
// Version 5.1 02.07.2021 HSB-12497: display if stacking orientation not same as klhDevice orientation Author: Marsel Nakuci
// 5.0 25.01.2021 HSB-10448 item creation prevented if parent or child entities of element relations are stacked , Author Thorsten Huck
// 4.9 21.01.2021 HSB-9303 bugfix column offset during creation
/// <version value="4.8" date="24nov2020" author="thorsten.huck@hsbcad.com"> HSB-9873 Text drawn at center of elements </version>
/// <version value="4.7" date="24nov2020" author="thorsten.huck@hsbcad.com"> HSB-9860 The transformation of the stacking item published </version>
/// <version value="4.6" date="24nov2020" author="thorsten.huck@hsbcad.com"> HSB-9873 entities which belong to an element are refused if the element has an associated item </version>
/// <version value="4.5" date="23nov2020" author="thorsten.huck@hsbcad.com"> HSB-9860 The transformation of the stacking item to the reference plane has been fixed for source entities like MassElement, RoofElement and other classes not being based genBeam </version>
/// <version value="4.4" date="20oct2020" author="thorsten.huck@hsbcad.com"> HSB-9338 internal variable renaming </version>
/// <version value="4.3" date="01oct2020" author="thorsten.huck@hsbcad.com"> HSB-9055 f_item bugfix multiple insert when no grouping or ordering definition can be found </version>
/// <version value="4.2" date="18aug2020" author="thorsten.huck@hsbcad.com"> HSB-8560 data published for truck packages</version>
/// <version value="4.1" date="21jul2020" author="thorsten.huck@hsbcad.com"> HSB-8332 new settings property maxHeight for each selection set, new command to set max height, HSb-8336 new context command to specify ordering for each selection set, HSB-8333 surface qualities visualized by transpoarent filling and outline</version>
/// <version value="4.0" date="10jul2020" author="thorsten.huck@hsbcad.com"> HSB-8112 new property to control the top face alignment by quality. </version>
/// <version value="3.9" date="10jul2020" author="thorsten.huck@hsbcad.com"> HSB-8131 optional display of surface quality if specified in settings Item\SurfaceQuality[] </version>
/// <version value="3.8" date="08jan2020" author="thorsten.huck@hsbcad.com"> display format redesigned to @(<VariableName>) syntax. Display set takes new entry 'Format' in priority over 'Tag[]'</version>
/// <version value="3.7" date="07mar2019" author="thorsten.huck@hsbcad.com"> new parameter to validate truck number against property of the defining entity </version>
/// <version value="3.6" date="06mar2019" author="thorsten.huck@hsbcad.com"> bugfix selection set </version>
/// <version value="3.5" date="05mar2019" author="thorsten.huck@hsbcad.com"> HSBCAD-584 add tsl graphics, new parameter in settings </version>
/// <version value="3.4" date="07feb2019" author="thorsten.huck@hsbcad.com"> parent/child naming changed, NOTE: do not update existing entities  </version>
/// <version value="3.3" date="22mar2018" author="thorsten.huck@hsbcad.com"> new syntax of description variables, requires 21.0.32 or higher. To see the list of available variables fire context command 'add override', this version requires validation of the stacking settings </version>
/// <version value="3.2" date="30jan2018" author="thorsten.huck@hsbcad.com"> property 'Number'.'Information' and 'Weight' supported for free or roof elements </version>
/// <version value="3.1" date="10jul2017" author="thorsten.huck@hsbcad.com"> packages supported </version>
/// <version value="3.0" date="10jul2017" author="thorsten.huck@hsbcad.com"> ptCen published to mapX </version>
/// <version value="2.9" date="05jul2017" author="thorsten.huck@hsbcad.com"> grouping of items activated with HsbGrouping </version>
/// <version value="2.8" date="28jun2017" author="thorsten.huck@hsbcad.com"> tagging added </version>
/// <version value="2.7" date="27jun2017" author="thorsten.huck@hsbcad.com"> grouping and ordering of items prepared to work with HsbGrouping </version>
/// <version value="2.6" date="22jun2017" author="thorsten.huck@hsbcad.com"> tag location set to solid center, new context command to append a tag override from property list </version>
/// <version value="2.5" date="26may2017" author="thorsten.huck@hsbcad.com"> elements are represented by their genbeams instead of the element solid </version>
/// <version value="2.4" date="11may2017" author="thorsten.huck@hsbcad.com"> supports additional child panel reference as color reference, new optional setting SurfaceQuality[].SurfaceQuality.Color to map quality colors with contact face display. </version>
/// <version value="2.3" date="11may2017" author="thorsten.huck@hsbcad.com"> child panel support added. </version>
/// <version value="2.2" date="07apr2017" author="thorsten.huck@hsbcad.com"> Quality display if sip surface quality of upper face is higher than bottom face </version>
/// <version value="2.1" date="06apr2017" author="thorsten.huck@hsbcad.com"> MassGroup and TslInst added as valid entity types </version>
/// <version value="2.0" date="20mar2017" author="thorsten.huck@hsbcad.com"> minor bugfix </version>
/// <version value="1.9" date="13mar2017" author="thorsten.huck@hsbcad.com"> new property to set allowed calsses of selection set, MassElement and MassGroup added </version>
/// <version value="1.8" date="07mar2017" author="thorsten.huck@hsbcad.com"> the previously called term 'Stack' is now called 'Layer'</version>
/// <version value="1.7" date="03mar2017" author="thorsten.huck@hsbcad.com"> new triggers to align item </version>
/// <version value="1.6" date="20feb2017" author="thorsten.huck@hsbcad.com"> bugfixes </version>
/// <version value="1.5" date="15feb2017" author="thorsten.huck@hsbcad.com"> external settings added </version>
/// <version value="1.4" date="13feb2017" author="thorsten.huck@hsbcad.com"> bugfixes </version>
/// <version value="1.3" date="03feb2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a stackable item and shows it in XY World. 



/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "f_item")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|Select item|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Rotate 90° X-Axis|") (_TM "|Select item|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Rotate 90° Z-Axis|") (_TM "|Select item|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Side|") (_TM "|Select item|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Low Detail|") (_TM "|Select item|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Show Relation|") (_TM "|Select item|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Hide Relation|") (_TM "|Select item|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Override|") (_TM "|Select item|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Disable unstacked display|") (_TM "|Select item|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Display unstacked items|") (_TM "|Select item|"))) TSLCONTENT

/// </summary>//endregion

//region Part 1
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
	String sProjectSpecial=projectSpecial();
	sProjectSpecial.makeUpper();
	int bIsKlh=sProjectSpecial=="KLH";
	int nPropertyReadOnly;
	String kDataLink = "DataLink", kData="Data",kScript="f_Item";
	String sTypes[]={"R","F","W"};
//end constants//endregion
	
	
//region Constants 2
// performance test
	int nTick=getTickCount();
	
// stacking family key words
	String sItemX="Hsb_Item";
	
// selection sets
	String sSelectionSets[0];
	String sSupportedAllowedClasses[]= {"BEAM","SHEET","SIP","ELEMENTROOF","ELEMENTWALL","MASSELEMENT", "MASSGROUP", "TSLINST","CHILDPANEL"};
	
// default tags
	String sTags[0];
	String sDisplaySets[0];

// declare grouping method
	String sAssemblyPath=findFile(_kPathHsbInstall+"\\NetAC\\hsbGrouping.dll");
	String sType="hsbCad.Grouping.ItemGroupingTsl";
	String sFunction="ItemGrouping";
	
// row and column interdistance
	double dRowOffset=U(1000);
	double dColumnOffset=U(1000);
	double dMaxWidth=U(20000);
	
	double dMaxHeight;// max height expresses the height when stacked vertically and the width if stacked horizontally
	// HSB-19483 map containing contour properties like thickness
	Map mapContour;
	
	int nMode=_Map.getInt("mode");
	String sDisabled=T("<|Disabled|>");
	String sSequences[]={T("|Descending|"), T("|Ascending|")};
//End Constants 2//endregion 

//region Functions #FU

//region getAttachedTsls
	TslInst[] getAttachedTsls(Sip _sip, String _scriptName)
	{ 
		TslInst _tsls[0];
		Group grp();
		Entity ents[] = grp.collectEntities(true, TslInst(), _kModelSpace);
		for (int j = 0; j < ents.length(); j++)
		{
			TslInst t = (TslInst)ents[j];
			if ( ! t.bIsValid())
			{
				// not a TslInst
				continue;
			}
			// its a TslInst
			// see if it contains the sip
			Sip sipsTsl[] = t.sip();
			if (sipsTsl.length() == 0)
			{ 
				// no panel attached to this tsl
				continue;
			}
			if (sipsTsl[0] != _sip)
			{ 
				continue;
			}
			if (t.scriptName() != "klhCoating" )continue;
			if(_tsls.find(t)<0)
			{ 
				_tsls.append(t);
			}
		}
	
		return _tsls;
	}
//End getAttachedTsls//endregion

//region isBottomPlate
	// HSB-22499
	// returns if it is the bottom plate (unterste Platte)
	int isBottomPlate(Sip _s)
	{ 
		int _bBottomPlate;
		
		String sHandleBottom=_s.formatObject("@(BOTTOMPANEL.f_Package.InternalMapx.BOTTOMPANEL:D)");
		String sHandleBottomLayer=_s.formatObject("@(BOTTOMPANEL.f_Truck.InternalMapx.BOTTOMPANEL:D)");
		
		_bBottomPlate=(sHandleBottom!="" || sHandleBottomLayer!="");
		
		return _bBottomPlate;
	}
//End isBottomPlate//endregion

//region refinementCodeIsUsed
	// if coating tsl is added at sip
	// and a code allowed for item is used
	//HSB-22499
	int refinementCodeIsUsed(Sip _s,String _sCodesItem[])
	{ 
		int _bRefinementCodeIsUsed;
		
		TslInst _tslCoatings[]=getAttachedTsls(_s,"klhCoating");
		
		for (int t=0;t<_tslCoatings.length();t++) 
		{ 
			String sCodeI=_tslCoatings[t].propString(0);
			if(_sCodesItem.find(sCodeI)>-1)
			{ 
//				sCoatingCodeUsed=sCodeI;
				_bRefinementCodeIsUsed=true;
				break;
			}
		}//next t
		
		return _bRefinementCodeIsUsed;
	}
//End refinementCodeIsUsed//endregion

//region drawError
	// it draws the cross and the text of the error	
	void drawError(Sip s, Map _min)
	{ 
		Vector3d vx=s.vecX();
		Vector3d vy=s.vecY();
		Vector3d vz=s.vecZ();
		Point3d ptC=s.ptCen();
		
		if(_min.hasVector3d("vx"))
			vx=_min.getVector3d("vx");
		if(_min.hasVector3d("vy"))
			vy=_min.getVector3d("vy");
		if(_min.hasVector3d("vz"))
			vz=_min.getVector3d("vz");
		if(_min.hasPoint3d("ptC"))
			ptC=_min.getPoint3d("ptC");
		
		Body b;
		if(_min.hasBody("bd"))
			b=_min.getBody("bd");
		else
			b=s.envelopeBody();
		String _sError="Error";
		if(_min.hasString("sError"))
			_sError=_min.getString("sError");
		
		
		PlaneProfile ppShadow = b.shadowProfile(Plane(ptC,vz));
		LineSeg seg=ppShadow.extentInDir(vx);
		
		PLine pl;
		pl.addVertex(seg.ptStart());
		pl.addVertex(seg.ptEnd());
		pl.addVertex(seg.ptMid());
		seg = ppShadow.extentInDir(vy);
		pl.addVertex(seg.ptStart());
		pl.addVertex(seg.ptEnd());
		
		
		Vector3d vecXRead=-vx+vy;
		vecXRead.normalize();
		Vector3d vecYRead = vecXRead.crossProduct(-_ZW);
		vecYRead.normalize();
		
		int nColor=5;
		if(_min.hasInt("Color"))
			nColor=_min.getInt("Color");
		Display dpErr(nColor);
		dpErr.draw(_sError, seg.ptMid(), vecXRead, vecYRead, 0, 0, _kDevice);
		dpErr.draw(pl);
		Point3d _pts[]=_min.getPoint3dArray("pts");
		if(_pts.length()>0)
		{ 
			for (int i=0;i<_pts.length();i++) 
			{ 
				PLine _pl;
				_pl.createCircle(_pts[i],vz,U(10)); 
				dpErr.color(1);
				dpErr.draw(_pl);
				dpErr.draw(PlaneProfile(_pl),_kDrawFilled,40);
			}//next i
		}
		return;
	}
//End drawError//endregion

//region getType
// gets the type of the panel
// R,F,W	
	Map getType(Sip s)
	{ 
		int nT=0;
		String sT="R";
		int bW=false;
		Map m;
		
		String sLabel=s.label();
		String sEnd=sLabel.right(2);
		bW=sEnd.makeUpper()=="W-";
		if(sEnd.makeUpper()=="F-")
			sT="F-";
		nT=sTypes.find(sT);
		
		m.setInt("nType",nT);
		m.setString("sType",sT);
		m.setInt("bWall", bW);
		return m;
	}
//End getType//endregion

//region ArrayToMapFunctions
	//region Function GetBodyArray
	// returns an array of bodies stored in map
	Body[] GetBodyArray(Map mapIn)
	{ 
		Body bodies[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasBody(i))
				bodies.append(mapIn.getBody(i));
	
		return bodies;
	}//endregion

	//region Function SetBodyArray
	// sets an array of bodies in map
	Map SetBodyArray(Body bodies[])
	{ 
		Map mapOut;
		for (int i=0;i<bodies.length();i++) 
			mapOut.appendBody("bd", bodies[i]);	
		return mapOut;
	}//endregion
//End ArrayToMapFunctions //endregion
//End Functions #FU//endregion 


//region Temporary instance to store the orderBy properties
	if (nMode==10)
	{ 
		if (_Entity.length()<1)
		{ 
			eraseInstance();
			return;
		}
		Entity ent = _Entity[0];
		String key = T("|Order|");
		setOPMKey("orderBy");
		
	// get properties and translated
		String variables[] = ent.formatObjectVariables();
		String variablesT[0];
		for (int i=0;i<variables.length();i++) 
			variablesT.append(T("|"+variables[i]+"|")); 
		
	// order alphabetically
		for (int i=0;i<variablesT.length();i++) 
			for (int j=0;j<variablesT.length()-1;j++) 
				if (variablesT[j]>variablesT[j+1])
				{
					variables.swap(j, j + 1);
					variablesT.swap(j, j + 1);	
				}
		variables.insertAt(0, "<|Disabled|>");		
		variablesT.insertAt(0, sDisabled);
		
		
		String sSequenceName=T("|Sequence|");
		String sSequenceDesc=T("|Defines the Sequence of the ordering|");
		String sPropertyName=T("|Property|");
		String sPropertyDesc=T("|Defines the property to oder the items|");
		
		int n = 1;
		category = key + " "+(n++);
		PropString sProperty_1(nStringIndex++, variablesT, sPropertyName,0);	sProperty_1.setDescription(T("|Defines the ordering|"));	sProperty_1.setCategory(category);			
		PropString sSequence_1(nStringIndex+4, sSequences, sSequenceName,1);	sSequence_1.setDescription(sPropertyDesc);					sSequence_1.setCategory(category);
		if (variablesT.find(sProperty_1) < 0) sProperty_1.set(sDisabled);

		category = key + " "+(n++);
		PropString sProperty_2(nStringIndex++, variablesT, sPropertyName,0);	sProperty_2.setDescription(T("|Defines the ordering|"));	sProperty_2.setCategory(category);			
		PropString sSequence_2(nStringIndex+4, sSequences, sSequenceName,1);	sSequence_2.setDescription(sPropertyDesc);					sSequence_2.setCategory(category);
		if (variablesT.find(sProperty_2) < 0) sProperty_2.set(sDisabled);
		
		category = key + " "+(n++);
		PropString sProperty_3(nStringIndex++, variablesT, sPropertyName,0);	sProperty_3.setDescription(T("|Defines the ordering|"));	sProperty_3.setCategory(category);			
		PropString sSequence_3(nStringIndex+4, sSequences, sSequenceName,1);	sSequence_3.setDescription(sPropertyDesc);					sSequence_3.setCategory(category);
		if (variablesT.find(sProperty_3) < 0) sProperty_3.set(sDisabled);
		
		category = key + " "+(n++);
		PropString sProperty_4(nStringIndex++, variablesT, sPropertyName,0);	sProperty_4.setDescription(T("|Defines the ordering|"));	sProperty_4.setCategory(category);			
		PropString sSequence_4(nStringIndex+4, sSequences, sSequenceName,1);	sSequence_4.setDescription(sPropertyDesc);					sSequence_4.setCategory(category);		
		if (variablesT.find(sProperty_4) < 0) sProperty_4.set(sDisabled);
		
		category = key + " "+(n++);
		PropString sProperty_5(nStringIndex++, variablesT, sPropertyName,0);	sProperty_5.setDescription(T("|Defines the ordering|"));	sProperty_5.setCategory(category);			
		PropString sSequence_5(nStringIndex+4, sSequences, sSequenceName,1);	sSequence_5.setDescription(sPropertyDesc);					sSequence_5.setCategory(category);		
		if (variablesT.find(sProperty_5) < 0) sProperty_5.set(sDisabled);

		return;
	}
//End Temporary instance to store the orderBy properties//endregion 

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="f_Stacking";
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
		if (sFile.length()<1)sFile=findFile(_kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\"+sFileName+".xml");		
		if (sFile.length()>0)
		{ 
			mapSetting.readFromXmlFile(sFile);
			mo.dbCreate(mapSetting);			
		}
	}		
//End Settings//endregion

//region Read Settings
	Map mapSets,mapSSets, mapSurfaceQuality;
	String sTruckValidationProperty;
	{
		String k;
		Map m;//.getMap("SubNode[]");

	// SELECTION SETS
		mapSSets= mapSetting.getMap("Item\\SelectionSet[]");
		for (int i=0;i<mapSSets.length();i++) 
		{ 
			Map t = mapSSets.getMap(i);
			if (t.hasString("Name") && t.hasMap("AllowedClass[]"))
			{
				String sSelectionSet = T("|" + t.getString("Name") + "|");
				if (sSelectionSets.find(sSelectionSet)<0)	sSelectionSets.append(T(t.getString("Name")));				
			}
		}

	// ITEM
		mapSets= mapSetting.getMap("Item\\Set[]");
		for (int i=0;i<mapSets.length();i++) 
		{ 
			Map t = mapSets.getMap(i);
			if (t.hasString("Name") && sDisplaySets.find(t.getString("Name"))<0)
				sDisplaySets.append(t.getString("Name"));
		}

	// surface quality
		mapSurfaceQuality= mapSetting.getMap("Item\\SurfaceQuality[]");

	// grid
		m = mapSetting.getMap("Item\\Grid"); 
		k= "RowOffset"; 	if (m.hasDouble(k))	dRowOffset=m.getDouble(k);
		k= "ColumnOffset";	if (m.hasDouble(k))	dColumnOffset=m.getDouble(k);
		k= "MaxWidth"; 		if(m.hasDouble(k))	dMaxWidth=m.getDouble(k);

	// validation of truck assignment
		m = mapSetting.getMap("Item\\TruckValidation");
		k= "SourceProperty"; 	if (m.hasString(k))	sTruckValidationProperty=m.getString(k);
		
		k="PropertyReadOnly"; if (mapSetting.hasInt(k)) nPropertyReadOnly= mapSetting.getInt(k);
	// contour 
		// HSB-19483
		m = mapSetting.getMap("Item");
		k="Contour"; if (m.hasMap(k)) mapContour=m.getMap(k);
	}
//End Read Settings//endregion 

//region Properties
// selection set
	category = T("|Selection Set|");
	String sSelectionSetName=T("|Allowed Types|");
	sSelectionSets = sSelectionSets.sorted();
	String sSelectionSetDefault = "_"+T("|All Types|");
	if(sSelectionSets.length()<1)
		sSelectionSets.append(sSelectionSetDefault);
	PropString sSelectionSet(nStringIndex++, sSelectionSets, sSelectionSetName);
	sSelectionSet.setDescription(T("|Specifies the allowed entity types of the selection set|"));
	sSelectionSet.setCategory(category);
	
// display
	category = T("|Display|");


// order sDisplaySets	
	sDisplaySets = sDisplaySets.sorted();
	sDisplaySets.insertAt(0, T("|Disabled|"));
	String sDisplaySetName=T("|Display Set|");	
	PropString sDisplaySet(nStringIndex++, sDisplaySets, sDisplaySetName);
	sDisplaySet.setCategory(category);

	String sTagName =T("|Override|");
	PropString sTag(nStringIndex++,"",sTagName);
	sTag.setDescription(T("|Defines the properties to be displayed.|") + " " + T("|Separate lines by| \\P, ") + 
	T("|empty = use set|")+ TN("|Example to display the posnum and the material in two lines:| ")+"@(PosNum)\\P@(Name)|");
	sTag.setCategory(category);
	
	category = T("|Alignment|");
	String sFaceAlignmentName=T("|Top Face|");	
	String sFaceAlignments[] = {T("|Unchanged|"), T("|Higher Quality|"), T("|Lower Quality|")};
	PropString sFaceAlignment(nStringIndex++, sFaceAlignments, sFaceAlignmentName,0);
	sFaceAlignment.setDescription(T("|Defines the default alignment of the item if it supports quality definitions|"));
	sFaceAlignment.setCategory(category);

	double dGrainSize=U(400);
	double dSize = U(100);	
//End Properties//endregion 
	
//region Read Settings DimRequest Scriptnames
	// flag to display dimrequests of attached tsls, if no dedicated list specified all request are taken
	int bAddRequest;
	String sScriptNames[0];
	
	{
		Map mapSet;
		for (int i=0;i<mapSets.length();i++) 
		{ 
			Map t = mapSets.getMap(i);
			if (t.getString("Name")==sDisplaySet)
			{ 
				mapSet = t;
				break;
			}
		}
		
		if (mapSet.hasMap("ScriptName[]"))
		{ 
		// only collect tsls which are in this dwg	
			String sAllEntries[] = TslScript().getAllEntryNames();
			bAddRequest = true;
			Map m = mapSet.getMap("ScriptName[]");
			for (int i=0;i<m.length();i++) 
			{ 
				String s = m.getString(i);
				if (sScriptNames.find(s)<0 && sAllEntries.find(s)>-1)
					sScriptNames.append(s);
			}//next i	
		}	
	}
	
// get selection set
	Map mapSSet;
	int nIndexSet=-1;
	for (int i = 0; i < mapSSets.length(); i++)
	{
		Map m = mapSSets.getMap(i);
		String name = m.getString("Name");
		int x = name.find("|", 0);
		if (x >- 1 && name.find("|", x) >- 1)name = T(name);
		if (sSelectionSet == name)
		{
			nIndexSet = i;
			mapSSet = m;
			break;
		}
	}
//End Read Settings//endregion 
		
//End Part 1//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
		if(bIsKlh || nPropertyReadOnly)
		{ 
		// HSB-19334: Set properties to ReadOnly
			sSelectionSet.setReadOnly(_kReadOnly);
			sTag.setReadOnly(_kReadOnly);
			_Map.setInt("readOnly",true);
		}
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
		
	// prompt for entities
		Entity ents[0];
		PrEntity ssE;

	// get selection set map
		for (int i = 0; i < mapSSets.length(); i++)
		{
			Map m = mapSSets.getMap(i);
			String name = m.getString("Name");
			int x = name.find("|", 0);
			if (x >- 1 && name.find("|", x) >- 1)name = T(name);
			if (sSelectionSet == name)
			{
				nIndexSet = i;
				mapSSet = m;
				break;
			}
		}

	// get maps of allowed classes and grouping
		Map mapAllowedClasses= mapSSet.getMap("AllowedClass[]");
		Map mapGroupBy= mapSSet.getMap("GroupBy[]");
		Map mapOrderBy= mapSSet.getMap("OrderBy[]");
		dMaxHeight = mapSSet.getDouble("MaxHeight");

		if(bDebug)reportMessage("\n"+ scriptName() + 
			"\n	mapAllowedClasses " +mapAllowedClasses + " (" + mapAllowedClasses.length() + ")"+ 
			"\n	mapGroupBy " +mapGroupBy + " (" + mapGroupBy.length() + ")"+ 
			"\n	mapOrderBy " +mapOrderBy + " (" + mapOrderBy.length() + ")");
		
	// get allowed classes
		String sAllowedClasses[0],sPrompt;
		for (int i=0;i<mapAllowedClasses.length();i++) 
		{
			String sAllowedClass = mapAllowedClasses.getString(i);
			if(bDebug)reportMessage("\n"+ scriptName() + " getAllowedClass " +sAllowedClass);
			if (sSupportedAllowedClasses.find(String(sAllowedClass).makeUpper())>-1)
			{
				sAllowedClasses.append(sAllowedClass);
				if (sPrompt.length()<1)
					sPrompt=T("|Select entity(s) of type|") + " " + T("|" + sAllowedClass+ "|");
				else
					sPrompt +=", " + T("|" + sAllowedClass+ "|");
			}
		}
			
	//region Prompt selection
		if (sAllowedClasses.length()<1)
		{
			
			ssE=PrEntity(T("|Select entity(s)"), Entity());
		}
		else
		{
			int nNumAdded;
			
			for (int i=0;i<sAllowedClasses.length();i++) 	
			{
			
			// "BEAM","SHEET","SIP","ELEMENTROOF","ELEMENTWALL","MASSELEMENT", "MASSGROUP", "TSLINST","CHILDPANEL"
				int n=sSupportedAllowedClasses.find(sAllowedClasses[i].makeUpper());
				if(bDebug)reportMessage("\n"+ scriptName() + " n" +n + " " + sSupportedAllowedClasses + " " +sAllowedClasses[i] );
				int nInd;
				if (n==nInd++)		
				{
					if (nNumAdded<1)	ssE=PrEntity(sPrompt, Beam());
					else 				ssE.addAllowedClass(Beam());
					nNumAdded++;
				}
				else if (n==nInd++)		
				{
					if (nNumAdded<1)	ssE=PrEntity(sPrompt, Sheet());
					else 				ssE.addAllowedClass(Sheet());
					nNumAdded++;
				}
				else if (n==nInd++)		
				{
					if (nNumAdded<1)	ssE=PrEntity(sPrompt, Sip());
					else 				ssE.addAllowedClass(Sip());
					nNumAdded++;
				}
				else if (n==nInd++)		
				{
					if (nNumAdded<1)	ssE=PrEntity(sPrompt, ElementRoof());
					else 				ssE.addAllowedClass(ElementRoof());
					nNumAdded++;
				}
				else if (n==nInd++)		
				{
					if (nNumAdded<1)	ssE=PrEntity(sPrompt, ElementWall());
					else 				ssE.addAllowedClass(ElementWall());
					nNumAdded++;
				}
				else if (n==nInd++)		
				{
					if (nNumAdded<1)	ssE=PrEntity(sPrompt, MassElement());
					else 				ssE.addAllowedClass(MassElement());
					nNumAdded++;
					if(bDebug)reportMessage("\n"+ scriptName() + " add MassElement" +nNumAdded);
				}
				else if (n==nInd++)		
				{
					if (nNumAdded<1)	ssE=PrEntity(sPrompt, MassGroup());
					else 				ssE.addAllowedClass(MassGroup());
					nNumAdded++;
					if(bDebug)reportMessage("\n"+ scriptName() + " add MassGroup" +nNumAdded);
				}
				else if (n==nInd++)		
				{
					if (nNumAdded<1)	ssE=PrEntity(sPrompt, TslInst());
					else 				ssE.addAllowedClass(TslInst());
					nNumAdded++;
				}
				else if (n==nInd++)		
				{
					if (nNumAdded<1)	ssE=PrEntity(sPrompt, ChildPanel());
					else 				ssE.addAllowedClass(ChildPanel());
					nNumAdded++;
				}				
			}
		}

	  	if (ssE.go())
			ents.append(ssE.set());			
	//End Prompt selection//endregion 

	//region Collect existing items
		Entity entsItems[] = Group().collectEntities(true, TslInst(), _kModelSpace);
		Entity entsWithItems[0];
		
		for (int i=0;i<entsItems.length();i++) 
		{ 
			TslInst tsl = (TslInst)entsItems[i]; 
			if (tsl.scriptName()!=scriptName() || tsl==_ThisInst) 
				{ continue;}
			Entity e[] = tsl.entity();
			if (e.length()>0)
				entsWithItems.append(e[0]);
		}
		if(bDebug)reportMessage("\n		"+ scriptName() + " " + entsWithItems.length() + " found in dwg." +  ents.length() + " to be created.");	
		
		
		Element elItems[0]; // a list of all elements being itemized
		for (int i=0;i<entsWithItems.length();i++) 
		{ 
			Element el  =(Element)entsWithItems[i]; 
			if (el.bIsValid())elItems.append(el); 
		}//next i
	//End Collect existing items//endregion 
		
	//region Refuse items and trucks
	// collect an overall profile of potential child panels
		Plane pnW(_PtW, _ZW);
		PlaneProfile ppChild(CoordSys(_PtW, _XW,_YW,_ZW));
		int nNumChildPanel;
		int nNumRejected;
		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
			Entity ent=ents[i]; 
			Element el = (Element)ent;
			Element elParent = ent.element();
			
			String err;
			int bOk=true;
		// refuse items and trucks
			if (ent.bIsKindOf(TslInst()) && (((TslInst)ent).scriptName()==scriptName() | ((TslInst)ent).map().getInt("isTruck")))
			{
				err = T("|Trucks and items cannot be stacked|");
				bOk=false;
			}
		// refuse if the entity is a child to an item
			else if (entsWithItems.find(ent)>-1)	
			{
				GenBeam gb = (GenBeam)ent;
				if (gb.bIsValid())
					err = T("|Genbeam| ") + gb.name() + " " + gb.posnum();
				else if (el.bIsValid())
					err = T("|Element| ")+ el.number();					
				else
					err = ent.typeDxfName();
				err += T(" |is already stacked|");
				bOk=false;
			}
		// refuse if the entity is an element and...
			else if (el.bIsValid())
			{
				GenBeam gbs[] = el.genBeam();
				
			// ...with no genbeams and realBody turned off	
				if (ent.realBody().volume()<pow(dEps,3) && gbs.length()<1)
				{ 
					err = T("|Element| ")+el.number() + T(" |is not represented by a solid|");
					bOk=false;
				}
			// element contains a genbeam which is already stacked	
				else
				{
					for (int j=0;j<gbs.length();j++) 
					{ 
						if (entsWithItems.find(gbs[j])>-1)
						{
							err = T("|Element| ")+el.number() + T(" |contains the genbeam| "+gbs[j].name()+ " / "+ gbs[j].posnum() + T(" |which is already stacked|"));
							bOk=false;
							break; 
						}
					}//next j
				}
			}
		// refuse if the entity has a parent element and this element has an item association
			else if (elParent.bIsValid() && elItems.find(elParent)>-1)
			{
				err = T("|The parent element| ")+elParent.number() +T(" |is stacked|");

				bOk=false;				
			}
		// refuse non solids
			else if (ent.realBody().volume()<pow(dEps,3))
				bOk=false;

			if (!bOk)
			{
			// show first line of report	
				if (nNumRejected==0)
					reportNotice("\n\n"+scriptName() + T(" |refuses the creation for the follwing entities|:"));
			
			// show reason for refusal
				GenBeam gb = (GenBeam)ent;
				String sInfo =(gb.bIsValid() ? + " " +gb.name() + " "+ gb.posnum() : "");
				reportNotice("\n  "+err + sInfo);
				if (bDebug)reportMessage("\n	refusing "+ ent.typeDxfName());
				ents.removeAt(i);
				nNumRejected++;
			}
						
			if (ent.bIsKindOf(ChildPanel()))
			{
				nNumChildPanel++;
				PlaneProfile pp = ent.realBody().shadowProfile(pnW);
				PLine plRings[] = pp.allRings();
				int bIsOp[] = pp.ringIsOpening();
				for (int r=0;r<plRings.length();r++)
					if (!bIsOp[r])
						ppChild.joinRing(plRings[r],_kAdd);
			}
		}
					
	//End refuse items and trucks//endregion 

	// invalid slection set
		if (ents.length()<1)
		{ 
			eraseInstance();
			return;
		}




	//region Get collection based transformation vector
	// items of child panels shall be placed like the child panels
		Vector3d vecTrans; 
		int bIsChildPanelCollection;
		if (nNumChildPanel==ents.length())
		{
			LineSeg seg =ppChild.extentInDir(_XW);
		
		// get extents of profile
			double dX = abs(_XW.dotProduct(seg.ptStart()-seg.ptEnd()));
			double dY = abs(_YW.dotProduct(seg.ptStart()-seg.ptEnd()));
			Point3d ptFrom = seg.ptMid()-_XW*.5*dX+_YW*.5*dY;	
			
		// prompt for point input
			PrPoint ssP(TN("|Select point|"), ptFrom); 
			if (ssP.go()==_kOk) 
				_Pt0 = ssP.value(); // append the selected points to the list of grippoints _PtG
			
			vecTrans=_Pt0-ptFrom;	
			bIsChildPanelCollection=true;
		}
		else
			_Pt0 = getPoint();			
	//End // get collection based transformation vector//endregion 

	//region Create item instances
	// prepare tsl cloning
		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
		int nProps[]={};			double dProps[]={};				String sProps[]={sSelectionSet,sDisplaySet,sTag,sFaceAlignment};
		Map mapTsl;					String sScriptname = scriptName();

		Point3d ptStart = _Pt0;
		Point3d ptIns = ptStart;	
	
	// group entities
		if (sAssemblyPath.length()>0 && ents.length()>1 && !bIsChildPanelCollection && (mapOrderBy.length()>0 ||mapGroupBy.length()>0))
		{ 
		// set flags
			ModelMapComposeSettings mmFlags;
	
		// compose ModelMap
			ModelMap mm;
			mm.setEntities(ents);
			mm.dbComposeMap(mmFlags);		
			
		// declare and set input
			Map mapIn;
			mapIn.setMap("ModelMap", mm.map());			
	
		// set filter
			String sValue;
			for (int i=0;i<sAllowedClasses.length();i++) 
			{ 
				if (i>0)
					sValue+=";";
				sValue += sAllowedClasses[i]; 			 
			}
			Map mapFilter,mapFilters;
			mapFilter.setString("Property", "Type");
		    mapFilter.setString("Operation", "Is");
		    mapFilter.setString("Value", sValue);
			mapFilters.appendMap("Filter", mapFilter);
			
			Map mapItemGroupDefinition,mapItemGroupDefinitions;
			mapItemGroupDefinition.setString("Name", sSelectionSet);
			mapItemGroupDefinition.setMap("Filter[]", mapFilters);
		    mapItemGroupDefinition.setMap("GroupBy[]", mapGroupBy);
		    mapItemGroupDefinition.setMap("OrderBy[]", mapOrderBy);
			mapItemGroupDefinitions.setMap("ItemGroupDefinition",mapItemGroupDefinition);
			mapIn.setMap("ItemGroupDefinition[]", mapItemGroupDefinitions);
			if (bDebug)mapIn.writeToDxxFile(_kPathDwg+"\\mapIn.dxx");

			Map mapOut, mapItemGroups;
			mapOut= callDotNetFunction2(sAssemblyPath, sType, sFunction, mapIn);
			if (bDebug)mapOut.writeToDxxFile(_kPathDwg+"\\mapOut.dxx");

		// error report
			Map mapError = mapOut.getMap("Errors");
			if (mapError.length()>0)
			{ 	
				reportMessage("\n" + scriptName() + ": " +T("|executed with|") +" "+mapError.length() + " "+ (mapError.length()==1?T("|error|"):T("|errors|")))+":";
				for (int e=0;e<mapError.length();e++) 
					reportMessage("\n(" + (e+1) + ")  "+mapError.getString(e)); 
			}

		// get potential itemGroups
			mapItemGroups= mapOut.getMap("ItemGroup[]");	
			
			for (int i=0;i<mapItemGroups.length();i++) 
			{ 
				Map mapItemGroup = mapItemGroups.getMap(i); 
				Map mapEntities = mapItemGroup.getMap("Entities"); 

				int nNumItems;
				for (int m=0;m<mapEntities.length();m++) 
				{ 
					String sHandle= mapEntities.getString(m);
					Entity ent;
					ent.setFromHandle(sHandle);
					double dXPrevious;
					if (ent.bIsValid())
					{ 
					// cast to sip if possible	
						GenBeam gb = (GenBeam)ent;
						Sip sip = (Sip)ent;
						if (!sip.bIsValid())
						{ 
							ChildPanel child = (ChildPanel)ent;
							if (child.bIsValid())
								sip = child.sipEntity();
						}
					
					// check if the item belongs to a wall element and if the coordSys matches
						int bRotateAsWall;
						ElementWall wall;
						{ 
							Element el = ent.element();
							if (el.bIsValid())
								wall = (ElementWall)el;
						}
						if (wall.bIsValid() && gb.bIsValid())
						{ 
							Vector3d vecYW = wall.vecY();							
							Vector3d vecXG = gb.vecX();
							bRotateAsWall = vecXG.isParallelTo(vecYW);							
						}
						
					// lock face alignment for non sips					
						if (!sip.bIsValid() && sFaceAlignment!=sFaceAlignments.first())
							sProps[3] = sFaceAlignments.first();
						else
							sProps[3] = sFaceAlignment;
						
						entsTsl.setLength(1);
						entsTsl[0] = ent;
						ptsTsl[0] = ptIns;
//		{ 
//			EntPLine epl;
//			epl.dbCreate(PLine(_PtW, ptIns));
//			
//		}				
						tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
							nProps, dProps, sProps,_kModelSpace, mapTsl);	
						if (tslNew.bIsValid())
						{
							//tslNew.setPropValuesFromCatalog(sLastInserted);
							Body bd = tslNew.realBody();
							PlaneProfile pp=bd.shadowProfile(pnW);
						// get extents of profile
							LineSeg seg = pp.extentInDir(vecXTsl);
							double dX = abs(vecXTsl.dotProduct(seg.ptStart()-seg.ptEnd()));
							double dY = abs(vecYTsl.dotProduct(seg.ptStart()-seg.ptEnd()));
							
							double dAngle;
							if (bRotateAsWall)
							{ 
								double d = dY;
								dY=dX;
								dX=d;
								dAngle = 90;
							}
							
							
							int bRotate= dX<dY;
							if (dMaxHeight>0)
								bRotate = dY > dMaxHeight && dX <= dMaxHeight;
							else
								bRotate= dX<dY;
							
							if (bRotate)
								dAngle += 90;
							
							//if (bRotate)
							//	reportNotice("\nRotate item by " +dAngle + " wall=" +bRotateAsWall+ " MaxHeight:" +dMaxHeight + " dX: " + dX + + " dY:" +dY);	

							
						// prealign greatest dimension to be X
							if(dAngle!=0)
							{ 
								CoordSys csRot;
								csRot.setToRotation(dAngle,_ZW,seg.ptMid());
								tslNew.transformBy(csRot);
							}
							
							dX = tslNew.realBody().lengthInDirection(_XW);
							dY = tslNew.realBody().lengthInDirection(_YW);
							
							Vector3d vec = _XW * (_XW.dotProduct(ptIns - tslNew.ptOrg())+.5*dX+dXPrevious);
							vec+=_YW * (_YW.dotProduct(ptIns - tslNew.ptOrg()) + .5 * dY);
							tslNew.transformBy(vec);
							

//							else if (!bIsChildPanelCollection)
//								tslNew.transformBy(.5* (vecXTsl*dX+vecYTsl*dY));
								
							ptIns.transformBy(vecXTsl*(dX+dXPrevious+dColumnOffset));
							dXPrevious = dX;
							if (vecXTsl.dotProduct(ptIns-ptStart)>dMaxWidth)
							{
								ptIns.transformBy(-vecYTsl*(dRowOffset));
								ptIns.setX(ptStart.X());
								dXPrevious = 0;
							}
							nNumItems++;
						}		
					}
				}
				
			// line feed next group
				ptIns.transformBy(-vecYTsl*(1.5*dRowOffset));
				ptIns.setX(ptStart.X());
				
				reportMessage("\n	" + nNumItems+ " "+T("|of|")+" " + ents.length()+ " "+ T("|items grouped|")); 
			}			
		}
		
		else
		{
		// loop sset and create one on one
			double dXPrevious;
			for (int i=0;i<ents.length();i++) 
			{ 
				entsTsl.setLength(1);
				Entity ent = ents[i];
				entsTsl[0] = ent;
				ptsTsl[0] = ptIns;
				
			// change vectors if based on a child
				if (ent.bIsKindOf(ChildPanel()))
				{
					ChildPanel child = (ChildPanel)ent;
					Sip sip = child.sipEntity();
					CoordSys csRef = sip.coordSys();
					csRef.transformBy(child.sipToMeTransformation());
					csRef = CoordSys(child.realBody().ptCen(), csRef.vecX(),csRef.vecY(),csRef.vecZ());				
					
					vecXTsl = csRef.vecX();
					vecYTsl = csRef.vecY();
					entsTsl[0] = sip;
					entsTsl.append(child);
					if (bIsChildPanelCollection)
						ptsTsl[0]=csRef.ptOrg()+vecTrans;	
				}
				
			// set face alignment to unchanged if not panel baased	
				if (!ent.bIsKindOf(Sip()) && !ent.bIsKindOf(ChildPanel()) && sFaceAlignment!=sFaceAlignments.first())
					sProps[3] = sFaceAlignments.first();
				else
					sProps[3] = sFaceAlignment;

			// create item
				tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
					nProps, dProps, sProps,_kModelSpace, mapTsl);	
				if (tslNew.bIsValid())
				{
					//tslNew.setPropValuesFromCatalog(sLastInserted);
					Body bd = tslNew.realBody();
					double dX = bd.lengthInDirection(vecXTsl);
					double dY = bd.lengthInDirection(vecYTsl);
					if (ent.bIsKindOf(Element()))
					{ 
						Point3d pts[] = bd.extremeVertices(vecXTsl);
						if (pts.length()>1)
							tslNew.transformBy(vecXTsl*(vecXTsl.dotProduct(ptIns-pts.first())));
					}
					else if (!bIsChildPanelCollection)
					{
						tslNew.transformBy(vecXTsl*.5 * dX);
					}

					ptIns.transformBy(vecXTsl*(dX+dColumnOffset));
					if (vecXTsl.dotProduct(ptIns-ptStart)>dMaxWidth)
					{
						ptIns.transformBy(-vecYTsl*(dRowOffset));
						ptIns.setX(ptStart.X());

					}

				}		
			}			
		}

		if(nNumRejected>0)
			reportMessage("\n" + scriptName() + ": "+ nNumRejected +T(" |entity(s) refused because of existing item link.|"));
			
	//End Create item instances//endregion 
	
		eraseInstance();
		return;
	}			
//End bOnInsert__________________//endregion 
//endregion history, properties and on insert

// validations //region
// validate item ref
	if (_Entity.length()<1)
	{
		reportMessage("\n" + scriptName() + ": " +T("|Invalid reference.|"));
		eraseInstance();
		return;	
	}
	
// get the main entity ref
	// if a child panel was selected during insert an additional entity is passed in
	Entity entRef=_Entity[0];
	ChildPanel childRef; 
	int nColor = entRef.color();
	// purely used to enable child panel based coloring
	if (_Entity.length()>1 && _Entity[1].bIsKindOf(ChildPanel()))
	{
		nColor = _Entity[1].color();
	}
	if (_ThisInst.color()!=nColor)
		_ThisInst.setColor(nColor);

//region Write OrderBy Definition to Settings
	String sTriggerOrderBy = T("|Setup Ordering|");
	addRecalcTrigger(_kContext, sTriggerOrderBy );
	if (_bOnRecalc && _kExecuteKey==sTriggerOrderBy)
	{
	// create TSL
		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};		Entity entsTsl[] = {entRef};	Point3d ptsTsl[] = {_Pt0};
		int nProps[]={};			double dProps[]={};				String sProps[10];
		Map mapTsl;	
		mapTsl.setInt("mode", 10);
		
	// initialize instance with current values
		if (nIndexSet>-1)
		{
			Map mapOrders = mapSSet.getMap("OrderBy[]");		
			for (int j=0;j<mapOrders.length();j++) 
			{ 
				Map m= mapOrders.getMap(j);
				sProps[j] = m.getString("Property");
				int bAscending = m.getInt("IsAscending");
				sProps[j + 5] = sSequences[(bAscending ? 1 : 0)]; 
			}//next j
		}


		tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
		int bOk = tslNew.showDialog();
		if (bOk && tslNew.bIsValid() && nIndexSet>-1)
		{ 
		// build orderBy map from properties
			Map mapOrderBys;
			for (int i=0;i<5;i++) 
			{ 
				String property = tslNew.propString(i);
				if (property == sDisabled)continue;
				Map m;
				m.setString("Property", property);
				int bIsAscending = sSequences.find(tslNew.propString(i+5), 1);
				m.setInt("IsAscending", bIsAscending);
				mapOrderBys.appendMap("OrderBy", m);
				
			}//next i
		
		// replace selectionset map
			mapSSet.setMap("OrderBy[]", mapOrderBys);
			mapSSets.removeAt(nIndexSet, true);					
			mapSSets.appendMap("SelectionSet", mapSSet);	

		// overwrite existing settings
			reportNotice("\n******************** " + scriptName() + " *************************");
			reportNotice(TN("|The ordering of the selection set| ") + sSelectionSet + T(" |has been modified.|"));
			reportNotice(TN("|The ordering will take affect during creation of new items|"));
			reportNotice(TN("|You can export these settings by hsbTslSettingsIO to make them available in other drawings.|"));
			
			
			mapSetting.setMap("Item\\SelectionSet[]", mapSSets);
			mo.setMap(mapSetting);

		// erase temp instance
			tslNew.dbErase();
		}
		setExecutionLoops(2);
		return;
	}	
	
	
	String sTriggerSetupMaxHeight = T("|Setup max Height|");
	addRecalcTrigger(_kContext, sTriggerSetupMaxHeight );
	if (_bOnRecalc && _kExecuteKey==sTriggerSetupMaxHeight)	
	{ 
		double dCurrent = mapSSet.getDouble("MaxHeight");
		double dNew = getDouble(T("|Enter max Height|") + T(", |0 to remove entry|") + (dCurrent>0?"("+dCurrent+")":""));
		if (nIndexSet>-1)
		{
			mapSSets.removeAt(nIndexSet, true);	
			if (dNew>=0)
				mapSSet.setDouble("MaxHeight", dNew);
			else
				mapSSet.removeAt("MaxHeight", true);
			mapSSets.appendMap("SelectionSet", mapSSet);				
			mapSetting.setMap("Item\\SelectionSet[]", mapSSets);	
			mo.setMap(mapSetting);
		}
		setExecutionLoops(2);
		return;
	}
//End OrderBy Definition//endregion 
	
	
// collect all items, erase if there is an reference to the same entity
	if (_bOnDbCreated || _bOnRecalc)
	{
		Entity entsItems[] = Group().collectEntities(true, TslInst(), _kModelSpace);
		for (int i=0;i<entsItems.length();i++) 
		{ 
			TslInst tsl = (TslInst)entsItems[i]; 
			if (tsl.scriptName()!=scriptName() || tsl==_ThisInst) 
				{ continue;}
			Entity e[] = tsl.entity();
			if (e.find(entRef)>-1)
			{
				reportMessage("\n" + scriptName() + ": " +T("|Duplicate found and erased.|"));
				eraseInstance();
				return;
			}
		}
	}
	

// set render material by ref
	_ThisInst.setRenderMaterial(entRef.renderMaterial());

	if(bIsKlh || nPropertyReadOnly)
	{ 
	// HSB-19334: Set properties to ReadOnly
		int nReadOnly=!_Map.getInt("readOnly");
		if(nReadOnly)
		{ 
			sSelectionSet.setReadOnly(_kReadOnly);
			sTag.setReadOnly(_kReadOnly);
		}
		else
		{ 
			sSelectionSet.setReadOnly(false);
			sTag.setReadOnly(false);
		}
		String sTriggerblockProperties = T("|Unblock Properties|");
		if(!nReadOnly)
			sTriggerblockProperties = T("|Block Properties|");
		addRecalcTrigger(_kContextRoot, sTriggerblockProperties);
		if (_bOnRecalc && _kExecuteKey==sTriggerblockProperties)
		{
			_Map.setInt("readOnly",nReadOnly);
			setExecutionLoops(2);
			return;
		}//endregion
	}
// order alphabetically
	String sFormatVariables[] = entRef.formatObjectVariables();
	for (int i=0;i<sFormatVariables.length();i++) 
		for (int j=0;j<sFormatVariables.length()-1;j++) 
			if (sFormatVariables[j]>sFormatVariables[j+1])
				sFormatVariables.swap(j, j + 1);
	
	
// validate displayset
	int nDisplaySet = sDisplaySets.find(sDisplaySet);
	if (nDisplaySet<0)
	{ 
		nDisplaySet=sDisplaySets.length()>1?1:0;
		sDisplaySet.set(sDisplaySets[nDisplaySet]);		
	}

// get settings
	String sDimStyle;
	double dTxtH;
	int nTextColor=-2;
	String sFormat;
	if (nDisplaySet>0)
	{
		Map m;
		for (int i=0;i<mapSets.length();i++) 
		{ 
			Map t = mapSets.getMap(i);
			if (t.getString("Name")==sDisplaySet)
				m = t;
		}	
		if (m.length()>0)
		{
		// set highDetail mode if not set
			String k = "HighDetail";
			if (!_Map.hasInt(k) || _kNameLastChangedProp==sDisplaySetName)
				_Map.setInt(k, m.getInt(k));		
		

		// get description format
			sFormat = m.getString("Format");
		// collect default tags (legacy)
			if (sFormat.length()<1)
			{ 
				Map t = m.getMap("Tag[]");
				for (int i=0;i<t.length();i++) 
				{ 
					String sTag = T(t.getString(i).trimLeft().trimRight());
					if (sTag.length()>0 && sTags.findNoCase(sTag,-1)<0)
						sTags.append("@("+sTag+")");	
						
				// collect old tag syntax		
					if (sTag.length()>0 && sFormat.find(sTag,0,false)<0)
					{
					// append format as format
						if (sTag.find("@(",0)==0 && sTag.find(")",0)==sTag.length()-1)
							sFormat += (sFormat.length()>0?"\P":"")+sTag;
					// append text as format
						else
							sFormat += (sFormat.length()>0?"\P":"")+"@("+sTag+")";
					}
						
				}				
			}

		
		// collect dimsytle and textheight
			sDimStyle = m.getString("DimStyle");
			dTxtH = m.getDouble("TextHeight");
			nTextColor = m.getInt("Color");
		}
	}
// end validations //endregion	
		
// get settings from set
	Display dp(nColor);
	if(_DimStyles.find(sDimStyle)>-1)dp.dimStyle(sDimStyle);
	if (dTxtH>0)dp.textHeight(dTxtH);
	Map mapXtsl;
// set format byoverride property
	if (sTag.length()>0)
	{
	// append format as format
		if (sTag.find("@(",0)>-1)
			sFormat = sTag;
	// HSB-19078 add only the Text
	
		else if(sTag.find("--Lagentrennung",0)>-1)
		{
			sFormat=sTag+sFormat;
			// HSB-22813
			mapXtsl.setInt("LayerSeparation",true);
		}
			//HSB-19334
//			sFormat +="\P"+sTag;
	// append text as format (legacy)
		else
			sFormat += "@("+sTag+")";
	}
	// HSB-22813
	_ThisInst.setSubMapX("InternalMapX",mapXtsl);

// get entity coordSys
	_Pt0.setZ(0);
	Vector3d vecXE = _XW;
	Vector3d vecYE = _YW;
	Vector3d vecZE= _ZW;
	Point3d ptOrgE = _Pt0;
	CoordSys csRef(ptOrgE, vecXE, vecYE, vecZE);

// cases
	Element element;
	Sip sip;
	SurfaceQualityStyle sqBot,sqTop;
	GenBeam genBeam;
	TslInst tslInst;
	MassElement massElement;
	MassGroup massGroup;
	ChildPanel child;
	
	int nRefType = -1;
	if (entRef.bIsKindOf(Element()))
	{
		element = (Element)entRef;
		csRef = element.coordSys();
		nRefType=0;		
	}
	else if (entRef.bIsKindOf(Sip()))
	{
		sip = (Sip)entRef;
		element = sip.element();
		csRef = sip.coordSys();
		csRef = CoordSys (sip.ptCenSolid(), csRef.vecX(),csRef.vecY(),csRef.vecZ());
		nRefType=1;	
		sqBot =SurfaceQualityStyle(sip.formatObject("@(SurfaceQualityBottomStyleDefinition.Name)"));
		sqTop =SurfaceQualityStyle(sip.formatObject("@(SurfaceQualityTopStyleDefinition.Name)"));
	}
	else if (entRef.bIsKindOf(GenBeam()))
	{
		genBeam = (GenBeam)entRef;
		csRef = genBeam.coordSys();
		csRef = CoordSys (genBeam.ptCenSolid(), csRef.vecX(),csRef.vecY(),csRef.vecZ());
		nRefType=2;		
	}
	else if (entRef.bIsKindOf(TslInst()))
	{
		tslInst = (TslInst)entRef;
		csRef =tslInst.coordSys();
		Map map = tslInst.map();
		if (map.hasVector3d("vecX") && map.hasVector3d("vecY") && map.hasVector3d("vecZ"))
		{
			vecXE = map.getVector3d("vecX");
			vecYE = map.getVector3d("vecY");
			vecZE = map.getVector3d("vecZ");
			csRef = CoordSys (tslInst.ptOrg(), vecXE, vecYE, vecZE);
		}
		nRefType=3;	
	}
	else if (entRef.bIsKindOf(MassElement()))
	{
		massElement = (MassElement)entRef;
		csRef = massElement.coordSys();
		csRef = CoordSys (csRef.ptOrg(), csRef.vecX(), csRef.vecY(), csRef.vecZ());	//csRef.ptOrg().vis(94);
	 	nRefType=4;	
	}
	else if (entRef.bIsKindOf(MassGroup()))
	{
		massGroup = (MassGroup)entRef;
		csRef = massGroup.coordSys();
		csRef = CoordSys (csRef.ptOrg(), csRef.vecX(),csRef.vecY(),csRef.vecZ());
		nRefType=5;	
	}
	else
	{
		reportMessage(TN("|The entity type|") + " " + entRef.typeDxfName() + T("|is not supported.|"));
		eraseInstance();
		return;
	}

	if (nRefType>-1)
	{
		setDependencyOnEntity(entRef);
		vecXE = csRef.vecX();
		vecYE = csRef.vecY();
		vecZE = csRef.vecZ();
		ptOrgE = csRef.ptOrg();
		TslInst tslRef=(TslInst)entRef;
		// HSB-23445
		if(bIsKlh)
		if(tslRef.bIsValid() && tslRef.scriptName()=="klhCombiTruck")
		{ 
			ptOrgE=tslRef.map().getBody("bd").ptCen();
			Body bd=tslRef.map().getBody("bd");
			if(bd.volume()<pow(U(1),3))
			{ 
				// HSB-23527
				Map mapBdItemsAlls=tslRef.map().getMap("mapBdItemsAlls");
				Body bdItemsAlls0[]=GetBodyArray(mapBdItemsAlls);
				for (int b=0;b<bdItemsAlls0.length();b++) 
				{ 
					bd.addPart(bdItemsAlls0[b]);
				}//next b
				Body bdCombi=tslRef.map().getBody("bdItemsAllCombi");
				// HSB-23341
				if(bdCombi.volume()>pow(U(1),3))
				{ 
					bd.subPart(bdCombi);
				}
				ptOrgE=bd.ptCen();
			}
		}
	}
	
// set model coordSys	
	Vector3d vecX = _Map.getVector3d("vecX");
	if (vecX.bIsZeroLength())vecX=_XW;
	Vector3d vecY = _Map.getVector3d("vecY");
	if (vecY.bIsZeroLength())vecY=_YW;
	Vector3d vecZ = _Map.getVector3d("vecZ");
	if (vecZ.bIsZeroLength())vecZ=_ZW;
	Point3d ptOrg = _Pt0;	

	CoordSys cs2Item;
	cs2Item.setToAlignCoordSys(csRef.ptOrg(),csRef.vecX(),csRef.vecY(),csRef.vecZ(),_Pt0, vecX, vecY, vecZ);
// HSB-23619: Add viewside
	int bIsSip=entRef.bIsKindOf(Sip());
	String sViewSide=T("|Reference side|");
	Map mapAddFormat;
	if(entRef.bIsKindOf(Sip()))
	{ 
		Sip sip=(Sip)entRef;
		Vector3d vecRefItem=-sip.vecZ();
		vecRefItem.vis(sip.ptCen());
		vecRefItem.transformBy(cs2Item);
		if(vecRefItem.dotProduct(_ZW)<0)
		{ 
			sViewSide=T("|Opposite side|");
		}
		
		
		mapAddFormat.setString(T("|ViewSide|"),sViewSide);
		sTag.setDefinesFormatting(entRef,mapAddFormat);
	}
	
	
// set myUID
	String sMyUID = _ThisInst.handle();


// set parent reference to childs
	if (0)//_bOnDbCreated)
	{
	// write child data to this (parent), (over)write submapX
		Map m;
		m.setString("MyUid", entRef.handle());
		m.setPoint3d("ptOrg", _Pt0, _kRelative);
		m.setVector3d("vecX", vecX, _kScalable); // coordsys carries size
		m.setVector3d("vecY", vecY, _kScalable);
		m.setVector3d("vecZ", vecZ, _kScalable);
		//mapParent.setMap("PackageData", mapData);
		_ThisInst.setSubMapX("Hsb_LayerChild",m);			
	}
	
// get potential parent
	Map mapParent = _ThisInst.subMapX("Hsb_LayerParent");
	String sParentId=mapParent.getString("MyUid");
	
	Entity entParent;
	entParent.setFromHandle(mapParent.getString("MyUid"));
	if (bDebug)
	{
		String sParentTxt = " has no parent!";
		if (entParent.bIsValid())
		{
			sParentTxt = " has parent "+ entParent.handle() + " of type " + entParent.typeDxfName();
			if (entParent.bIsKindOf(TslInst()))
			{
				TslInst tsl = (TslInst)entParent;
				sParentTxt+= tsl.scriptName() + " " + tsl.entity().length() + " entities linked.";
			}
		}
		//reportMessage("\n		"+ scriptName() + " (" + _kExecutionLoopCount +") " + _ThisInst.handle()   + sParentTxt);	
	}
	// HSB-18964
	double dBeddingHeight;
	int nBeddingHeightValid;
	if(bIsKlh)
	if(entParent.bIsValid())
	{ 
		TslInst tslParent=(TslInst)entParent;
		if(tslParent.bIsValid())
		{ 
			if(tslParent.scriptName()=="f_Layer")
			{ 
				dBeddingHeight=tslParent.propDouble(0);
				nBeddingHeightValid=true;
			}
		}
	}
	if(bDebug)dBeddingHeight=U(30);
	if(bIsKlh && nBeddingHeightValid || bDebug)
	{ 
		int nBeddingActive=_Map.getInt("BeddingRequested");
		if(abs(dBeddingHeight-U(30))<dEps 
			|| abs(dBeddingHeight-U(20))<dEps)
		{ 
			// 
			String sPropOverride=sTag;
			String sPropOverrideNew;
			String sLayerTxt="--Lagentrennung--\P";
			if (abs(dBeddingHeight-U(20))<dEps)
				sLayerTxt="--Lagentrennung 20mm--\P";
			if (nBeddingActive)
			{
				sPropOverrideNew=sLayerTxt+sPropOverride;
				int nFirst=sPropOverride.find(sLayerTxt ,- 1, false);
				if (nFirst>-1)
				{
					// dont change it has it
					sPropOverrideNew=sPropOverride;
				}
			}
			else
			{ 
				int nFirst=sPropOverride.find(sLayerTxt,-1,false);
				sPropOverrideNew=sPropOverride;
				if(nFirst>-1)
				{ 
					sPropOverrideNew=sPropOverride;
					sPropOverrideNew.delete(nFirst,sLayerTxt.length());
				}
			}
			sTag.set(sPropOverrideNew);
		}
			
	}
	
// transformation of child representation
	CoordSys csItem;
	csItem.setToAlignCoordSys(ptOrgE,vecXE,vecYE,vecZE,ptOrg,vecX,vecY,vecZ);

	vecX.vis(ptOrg,1);
	vecX.vis(ptOrgE,1);


//region Collect list of available object variables and append properties which are unsupported by formatObject (yet)
	Entity ents[]={entRef};
	String sObjectVariables[0];
	for (int i=0;i<ents.length();i++) 
	{ 
		String _sObjectVariables[0];
		_sObjectVariables.append(ents[i].formatObjectVariables());
		
	// append all variables, they might vary by type as different property sets could be attached
		for (int j=0;j<_sObjectVariables.length();j++)  
		{
			String sVariable=_sObjectVariables[j];
			if(sObjectVariables.find(sVariable)<0)
				sObjectVariables.append(sVariable); 
		}				
	}//next

//region Add custom variables for format resolving
// adding custom variables or variables which are currently not supported by core
	for (int i=0;i<ents.length();i++)
	{ 
		String k;

	// all solids
		k = "Calculate Weight"; if (sObjectVariables.find(k) < 0 && ents[i].realBody().volume()>pow(dEps,3))sObjectVariables.append(k);
			
		if (ents[i].bIsKindOf(Sip()) || ents[i].bIsKindOf(ChildPanel()))
		{ 
			k = "GrainDirection";		if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "GrainDirectionText";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "GrainDirectionTextShort";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SurfaceQuality";	if(sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SurfaceQualityTop";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SurfaceQualityBottom";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SipComponent.Name";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SipComponent.Material";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);		
		}
		else if (ents[i].bIsKindOf(Beam()))
		{ 
			k = "Surface Quality";		if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);		
		}		
		// metalpart collection entity	
		else if (ents[i].bIsKindOf(MetalPartCollectionEnt()))
		{ 
			k = "Definition"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);	
		}	
		
	}
// get translated list of variables
	String sTranslatedVariables[0];
	for (int i=0;i<sObjectVariables.length();i++) 
		sTranslatedVariables.append(T("|"+sObjectVariables[i]+"|")); 
	
// order both arrays alphabetically
	for (int i=0;i<sTranslatedVariables.length();i++) 
		for (int j=0;j<sTranslatedVariables.length()-1;j++) 
			if (sTranslatedVariables[j]>sTranslatedVariables[j+1])
			{
				sObjectVariables.swap(j, j + 1);
				sTranslatedVariables.swap(j, j + 1);
			}			
//End add custom variables//endregion

//End get list of available object variables//endregion 

//region Trigger AddRemoveFormat
	String sTriggerAddRemoveFormat = T("|Add/Remove Format|");
	addRecalcTrigger(_kContext, "../"+sTriggerAddRemoveFormat );
	if (_bOnRecalc && (_kExecuteKey=="../"+sTriggerAddRemoveFormat || _kExecuteKey==sTriggerAddRemoveFormat))
	{
		String sPrompt;
//		if (bHasSDV && entsDefineSet.length()<1)
//			sPrompt += "\n" + T("|NOTE: During a block setup only limited properties are accesable, but you can enter \nany valid format expression or use custom catalog entries.|");
		sPrompt+="\n"+ T("|Select a property by index to add(+) or to remove(-)|") + T(" ,|-1 = Exit|");
		reportNotice(sPrompt);
		
		for (int s=0;s<sObjectVariables.length();s++) 
		{ 
			String key = sObjectVariables[s]; 
			String keyT = sTranslatedVariables[s];
			String sValue;
			for (int j=0;j<ents.length();j++) 
			{ 
				String _value = ents[j].formatObject("@(" + key + ")");
				if (_value.length()>0)
				{ 
					sValue = _value;
					break;
				}
			}//next j

			String sAddRemove = sFormat.find(key,0, false)<0?"(+)" : "(-)";
			int x = s + 1;
			String sIndex = ((x<10)?"    " + x:"   " + x)+ "  "+sAddRemove+"  :";
			
			reportNotice("\n"+sIndex+keyT + "........: "+ sValue);
			
		}//next i
		int nRetVal = getInt(sPrompt)-1;
				
	// select property	
		while (nRetVal>-1)
		{ 
			if (nRetVal>-1 && nRetVal<=sObjectVariables.length())
			{ 
				String newAttrribute = sFormat;
	
			// get variable	and append if not already in list	
				String sVariable ="@(" + sObjectVariables[nRetVal] + ")";
				int x = sFormat.find(sVariable, 0);
				if (x>-1)
				{
					int y = sFormat.find(")", x);
					String left = sFormat.left(x);
					String right= sFormat.right(sFormat.length()-y-1);
					newAttrribute = left + right;
					reportMessage("\n" + sObjectVariables[nRetVal] + " new: " + newAttrribute);				
				}
				else
				{ 
					newAttrribute+="@(" +sObjectVariables[nRetVal]+")";
								
				}
				sTag.set(newAttrribute);
				reportMessage("\n" + sTagName + " " + T("|set to|")+" " +sTag);	
			}
			nRetVal = getInt(sPrompt)-1;
		}
	
		setExecutionLoops(2);
		return;
	}	
	
	
//endregion
	// by default always show thickness if defined in xml
	int bHasPlotViewport=true;
	if(bIsKlh)bHasPlotViewport=false;
	if(bIsKlh)
	if(mapContour.length()>0)
	{ 
		if(mapContour.getDouble("Thickness")>0)
		{ 
			TslInst truck;
			String sHandle = entRef.subMapX("Hsb_TruckChild").getString("ParentUID");
			truck.setFromHandle(sHandle);
			if (truck.bIsValid())
			{ 
				Entity entsTruck[]=truck.entity();
				for (int i=0;i<entsTruck.length();i++)
				{ 
					PlotViewport p=(PlotViewport)entsTruck[i];
					if(p.bIsValid())
					{ 
						bHasPlotViewport=true;
						break;
					}
				}
			}
		}
	}
	

//region Solid Display
	int bHighDetail = _Map.getInt("HighDetail");
	Point3d ptCen = _Pt0;
	Body item;
	double dZW;
	TslInst tslCombi;
	if (nRefType<6)
	{	
		int qualities[0];
		String entries[0];
	// element	
		if (nRefType==0)
		{
			Vector3d vecZ = element.vecZ();
			double dZ = element.dBeamWidth();
			
			Body items[0];
			GenBeam genBeams[]=element.genBeam();
			Opening openings[] = element.opening();
			
		// collect and combine genbeams per zone	
			for (int z=-5;z<6;z++) 
			{ 
				Body _item;
				for (int i=genBeams.length()-1; i>=0 ; i--) 
				{
					GenBeam gb=genBeams[i];
					if (gb.bIsDummy())
					{
						genBeams.removeAt(i);
						continue;	
					}
					else if (z!=gb.myZoneIndex())
						continue;
						
						
				// test high/low detail
					if (bHighDetail)
						_item.combine(gb.realBody());
					else
						_item.combine(gb.envelopeBody(false,true));	
				}
				if (_item.volume()>pow(dEps,3))
					items.append(_item);
			}
			
		// combine to element representation
			for (int i=0;i<items.length();i++) 
			{ 
				Body _item =items[i];
				if (bHighDetail)
					item.combine(_item);
				else
				{
					//_item.vis(i); 
				// get shadow
					Point3d pts[]=_item.extremeVertices(vecZ);
					if (pts.length()<2)continue;
					Point3d pt; pt.setToAverage(pts);
					double _dZ = vecZ.dotProduct(pts[1]-pts[0]);
					PlaneProfile pp = _item.shadowProfile(Plane(pt, vecZ));
					pp.shrink(-U(1));
					pp.shrink(U(1));
					
				// simplify profile
					_item = Body();
					PLine plRings[] = pp.allRings();
					int bIsOp[] = pp.ringIsOpening();
					for (int r=0;r<plRings.length();r++)
						if (!bIsOp[r])
						{
							_item.combine(Body(plRings[r], vecZ*_dZ,0));
						}
				// re-append openings
					for (int r=0;r<plRings.length();r++)
					{ 
						if (bIsOp[r])
						{
							PlaneProfile _pp(plRings[r]);
							for (int o=0;o<openings.length();o++)
							{
								Point3d ptMid;
								ptMid.setToAverage(openings[o].plShape().vertexPoints(true));
								if (_pp.pointInProfile(ptMid)==_kPointInProfile)
								{
									Body bd(plRings[r], vecZ*_dZ*2,0);
									_item.subPart(bd);
									break;
								}
							}
						}
					}	
					//_item.transformBy(vecZ*U(200));
					_item.vis(i);
					item.combine(_item);
				}
			}
		}
	// not genbeam or child panel	
		else if (nRefType!=1 && nRefType!=2)
		{
			item= entRef.realBody();
			// HSB-23243
			if(entRef.bIsKindOf(TslInst()))
			{ 
				TslInst tslRef=(TslInst)entRef;
				if(tslRef.bIsValid() && tslRef.scriptName()=="klhCombiTruck")
				{ 
					tslCombi=tslRef;
					item=tslRef.map().getBody("bd");
					Body bd;
					// HSB-23527
					if(item.volume()<pow(U(1),3))
					{ 
						Map mapBdItemsAlls=tslRef.map().getMap("mapBdItemsAlls");
						Body bdItemsAlls0[]=GetBodyArray(mapBdItemsAlls);
						for (int b=0;b<bdItemsAlls0.length();b++) 
						{ 
							bd.addPart(bdItemsAlls0[b]);
						}//next b
						Body bdCombi=tslRef.map().getBody("bdItemsAllCombi");
						// HSB-23341
						if(bdCombi.volume()>pow(U(1),3))
						{ 
							bd.subPart(bdCombi);
						}
						item=bd;
					}
				}
			}
		}
	// sip
		else if (nRefType==1)
		{	
			if (bHighDetail)
				item = sip.realBody();
			else
				item = sip.envelopeBody(false,true);
		}
		else if (bHighDetail)
			item = genBeam.realBody();
		else
			item = genBeam.envelopeBody(true,true);

	// transform source body to items coordSys
		item.transformBy(csItem);
		// HSB-9860
		{ 
			Point3d pts[] = item.extremeVertices(_ZW);
			if (pts.length()>0)
			{ 
				double d = _ZW.dotProduct(_Pt0-pts[0]);
				if (abs(d)>dEps)	
				{
					csItem.transformBy(_ZW * d);
					item.transformBy(_ZW * d);
				}
			}
		}

		
	// get center in _ZW
		dZW = item.lengthInDirection(_ZW);
//		item.transformBy(_ZW*.5*dZW);	//HSB-9860
		PlaneProfile ppShadow = item.shadowProfile(Plane(_Pt0,_ZW));
		LineSeg segShadow = ppShadow.extentInDir(vecX);
		ptCen = segShadow.ptMid()+_ZW*.5*dZW;
		
	// get transformation to refEnt
		CoordSys csItem2Ref=cs2Item;
		csItem2Ref.invert();
		{ 
			Point3d ptXRf = csRef.ptOrg();
			ptXRf.transformBy(csItem);
			ptXRf.transformBy(vecZ * vecZ.dotProduct(ptCen - ptXRf));
			//ptXRf.vis(3);ptCen.vis(4);
			csItem2Ref.setToAlignCoordSys(ptXRf, vecX, vecY, vecZ,csRef.ptOrg(),csRef.vecX(),csRef.vecY(),csRef.vecZ());				
		}

	// draw body in XY plane
		dp.draw(item);

	// show quality colored contact face
		if ((nRefType==1)&& mapSurfaceQuality.length()>0)
		{
			Map mapRequests;
	
			String k;
			int bIsPlan = vecZ.isParallelTo(_ZW);
			String qualities[] ={ sqBot.entryName(),sqTop.entryName()};
			int colors[2], transparencies[2];
			Vector3d vecDir = -vecZ;
			if(bIsPlan && vecZ.isCodirectionalTo(_ZW))
			{
				vecDir *= -1;
				qualities.swap(0, 1);
			}
		
		// get colors of settings
			for (int i=0;i<qualities.length();i++) 
				for (int j=0;j<mapSurfaceQuality.length();j++) 
				{ 
					Map m=mapSurfaceQuality.getMap(j);
					String sName=m.getString("Name");
					if (qualities[i].makeUpper()==sName.makeUpper())
					{
						k="Color"; if (m.hasInt(k)) colors[i]=m.getInt(k);
						k="Transparency"; if (m.hasInt(k)) transparencies[i]=m.getInt(k);
						if (colors[i]==0)colors[i]=_ThisInst.color(); // using color 0 draws the outline in the color of the transparency
						break;
					}
				}
			
			double dD = item.lengthInDirection(vecZ)*.5;
			
		// loop qualities
			for (int i=0;i<qualities.length();i++) 
			{ 
				int nc = colors[i];
				int nt = transparencies[i];
				PlaneProfile ppContact = item.extractContactFaceInPlane(Plane(ptCen+vecDir *dD, vecDir), dEps);				
				
				PlaneProfile ppReq= ppContact;
				ppReq.transformBy(csItem2Ref);
				
				//ppReq.vis(i+2);
				
				Map mapRequest;
				mapRequest.setInt("Color", nc);
				//mapRequest.setInt("DrawFilled", true);
				mapRequest.setInt("Transparency", nt);
				mapRequest.setVector3d("AllowedView", vecZ);
				mapRequest.setPlaneProfile("PlaneProfile", ppReq);
				mapRequests.appendMap("DimRequest", mapRequest);
				
				dp.color(nc);
				
	
			// draw outline in opposite color	
				if (bIsPlan && i==0)
				{
					if (nt>0 && nt<100)
						dp.draw(ppContact,_kDrawFilled,nt);
					
					dp.color(colors[1]);
					dp.draw(ppContact);
					// HSB-19483
					if(bHasPlotViewport)
					if(mapContour.length()>0)
					{ 
						if(mapContour.getDouble("Thickness")>0)
						{ 
							double dThicknessContour=mapContour.getDouble("Thickness");
							PlaneProfile ppOutter=ppContact;
//							PlaneProfile ppInner=ppContact;
							PLine pls[]=ppContact.allRings(true,false);
							PlaneProfile ppInner(pls[0]);
							if(!bIsKlh)
							{ 
								ppOutter.shrink(-.5*dThicknessContour);
								ppInner.shrink(.5*dThicknessContour);
							}
							// HSB-19939: Apply contour thickness on the inside
							if(bIsKlh)
								ppInner.shrink(dThicknessContour);
							ppOutter.subtractProfile(ppInner);
							dp.draw(ppOutter,_kDrawFilled);
						}
					}
					
					//break;
				}
				else if (!bIsPlan)
					dp.draw(ppContact);
				vecDir *= -1;
				 
			}//next i
			Map mapDimInfo;
			mapDimInfo.setMap("DimRequest[]", mapRequests);	
			_ThisInst.setSubMapX("Hsb_DimensionInfo", mapDimInfo);
			
		}	
	}		
//End Solid Display//endregion 

//region set item ref to entRef
	{ 
	// write child data to this (parent), (over)write submapX
		Map m;
		m.setString("MyUid", sMyUID);
		m.setPoint3d("ptOrg", csItem.ptOrg(), _kRelative); 
		m.setVector3d("vecX", csItem.vecX(), _kScalable); // coordsys carries size
		m.setVector3d("vecY", csItem.vecY(), _kScalable);
		m.setVector3d("vecZ", csItem.vecZ(), _kScalable);
		
		m.setPoint3d("ptCen", ptCen, _kRelative);
		entRef.setSubMapX("Hsb_ItemParent",m);			
	}
	// HSB-22813
	Map mapX;
	String sKeys[]=entRef.subMapXKeys();
	if(sKeys.findNoCase(kDataLink,-1)>-1)
		mapX=entRef.subMapX(kDataLink);
	mapX.setEntity(kScript,_ThisInst);
	entRef.setSubMapX(kDataLink,mapX);
//End set item ref to entRef//endregion 


//region Get Face Alignment
	int nFaceAlignment = sFaceAlignments.find(sFaceAlignment);
	if (nFaceAlignment<0)
	{ 
		sFaceAlignment.set(sFaceAlignments.first());
		setExecutionLoops(2);
		return;
	}
	else if (nRefType!=1 && nFaceAlignment!=0)
	{ 
		nFaceAlignment = 0;
		sFaceAlignment.set(sFaceAlignments.first());
		sFaceAlignment.setReadOnly(true);
	}	
//End Get Face Alignment//endregion 


//region Trigger
// Trigger Rotate90
	String sTriggerRotate90 = T("|Rotate 90° Z-Axis|") + " (" + T("|Doubleclick|")+")";
	addRecalcTrigger(_kContext, "../"+ sTriggerRotate90);
	if (_bOnRecalc && (_kExecuteKey=="../"+sTriggerRotate90 || _kExecuteKey==sTriggerRotate90 || _kExecuteKey==sDoubleClick))
	{
		CoordSys csRot;
		csRot.setToRotation(90,_ZW,_Pt0);
		_ThisInst.transformBy(csRot);
		setExecutionLoops(2);
		return;
	}
// Trigger swapYZ
	String sTriggerSwapYZ = T("|Rotate 90° X-Axis|");
	addRecalcTrigger(_kContext, "../"+sTriggerSwapYZ );
	if (_bOnRecalc && (_kExecuteKey=="../"+sTriggerSwapYZ ||_kExecuteKey==sTriggerSwapYZ))
	{	
		CoordSys cs;
		cs.setToRotation(90, vecX,ptCen);
		_ThisInst.transformBy(cs);
		setExecutionLoops(2);
		return;
	}
	
	
// Trigger Flip
	String sTriggerFlip = T("|Flip Side|");
	if (nFaceAlignment==0 || sqBot.quality()==sqTop.quality()) 
	{ 
		addRecalcTrigger(_kContext, "../"+sTriggerFlip );
		if (_bOnRecalc && (_kExecuteKey==sTriggerFlip ||_kExecuteKey=="../"+sTriggerFlip))
		{	
	
			CoordSys cs;
			cs.setToRotation(180, vecX,_Pt0);
			_ThisInst.transformBy(cs);
			setExecutionLoops(2);
			return;
		}
	}
	

// add high/low detail trigger
	String sToggleDetailTrigger = T("|High Detail|");
	if (bHighDetail)sToggleDetailTrigger = T("|Low Detail|");
	if (nRefType==0 || nRefType==1 || nRefType==2)
	{
		addRecalcTrigger(_kContext, "../"+sToggleDetailTrigger );
		if (_bOnRecalc && (_kExecuteKey=="../"+sToggleDetailTrigger || _kExecuteKey==sToggleDetailTrigger) )
		{
			if (bHighDetail)	bHighDetail=false;
			else bHighDetail=true;
			_Map.setInt("HighDetail",bHighDetail);
			setExecutionLoops(2);
			return;
		}		
	}

// add show / hide relathion trigger
	String sToggleRelationTrigger = T("|Show Relation|");
	int bShowRelation = _Map.getInt("ShowRelation");
	if (bShowRelation)sToggleRelationTrigger = T("|Hide Relation|");
	addRecalcTrigger(_kContext, "../"+sToggleRelationTrigger );
	if (_bOnRecalc &&(_kExecuteKey==sToggleRelationTrigger || _kExecuteKey=="../"+sToggleRelationTrigger)) 
	{
		if (bShowRelation)	bShowRelation=false;
		else bShowRelation=true;
		_Map.setInt("ShowRelation",bShowRelation);
		setExecutionLoops(2);
		return;
	}

// Trigger ValidateStacking//region
	int bValidateStacking = _Map.getInt("ValidateStacking");
	String sTriggerValidateStacking = bValidateStacking? T("|Disable unstacked display|"):T("|Display unstacked items|");
	addRecalcTrigger(_kContext, "../"+sTriggerValidateStacking );
	if (_bOnRecalc && (_kExecuteKey==sTriggerValidateStacking || _kExecuteKey=="../"+sTriggerValidateStacking))
	{
		bValidateStacking = bValidateStacking ? false : true;
		_Map.setInt("ValidateStacking",bValidateStacking);
		setExecutionLoops(2);
		return;
	}//endregion
	
// HSB-12497: display if stacking orientation is not same as klhLiftingDisplay
	if(sip.subMapXKeys().find("klhStackingCheck")>-1)
	{ 
		Map mapStackingCheck = sip.subMapX("klhStackingCheck");
		int iOrientation = true;
		if (mapStackingCheck.getInt("ErrorStacking"))iOrientation = false;
		if(!iOrientation)
		{ 
			PlaneProfile ppWarn = item.shadowProfile(Plane(ptCen, _ZW));
			Display dpv(1);
			dpv.textHeight(U(100));
//			dpv.draw(pp, _kDrawFilled);
			PLine pl;
			LineSeg segWarn = ppWarn.extentInDir(vecX);
			pl.addVertex(segWarn.ptStart());
			pl.addVertex(segWarn.ptEnd());
			pl.addVertex(segWarn.ptMid());
			segWarn = ppWarn.extentInDir(vecY);
			pl.addVertex(segWarn.ptStart());
			pl.addVertex(segWarn.ptEnd());
			dpv.draw(pl);
			Vector3d vecXRead = segWarn.ptEnd() - segWarn.ptStart(); vecXRead.normalize();
			if (vecXRead.dotProduct(_XW) < 0)vecXRead *= -1;
			Vector3d vecYRead = vecXRead.crossProduct(-_ZW);
			dpv.draw(T("|Wrong stacking orientation|"), segWarn.ptMid(), vecXRead, vecYRead, 0, 1.5);
		}
	}
//End Trigger//endregion 

//region HSB-16359 add lifting device trigger
	Entity entsAttached[]=sip.eToolsConnected();
	TslInst tslLiftings[0];
	for (int itsl=0;itsl<entsAttached.length();itsl++) 
	{ 
		TslInst tslI=(TslInst)entsAttached[itsl];
		if(!tslI.bIsValid())
			continue;
		
		if(tslI.scriptName()!="klhLiftingDevice")
			continue;
		if(tslLiftings.find(tslI)<0)
		{ 
			tslLiftings.append(tslI);
		}
	}//next itsl
	if(tslLiftings.length()==1)
	{ 
		TslInst tslLifting=tslLiftings[0];
		Map mapTsl=tslLifting.map();
		if(mapTsl.hasString("publicCommandf_Item"))
		{ 
			String sPublicCommand=mapTsl.getString("publicCommandf_Item");
			
		//region Trigger 
			String sTrigger = sPublicCommand;
			addRecalcTrigger(_kContextRoot, sTrigger );
			if (_bOnRecalc && _kExecuteKey==sTrigger)
			{
				Point3d ptHook=mapTsl.getPoint3d("ptHookf_Item");
				ptHook.transformBy(cs2Item);
				PrPoint ssP("\n"+ T("|Select point closed to edge|"),ptHook); 
				Vector3d vyLift=mapTsl.getVector3d("vyLiftf_Item");
				
				if (ssP.go()==_kOk)
				{ // do the actual query
					Point3d ptNew= ssP.value(); // retrieve the selected point
					
					Point3d ptCenSip=sip.ptCen();
					Point3d ptCenItem=ptCenSip;ptCenItem.transformBy(cs2Item);
					Vector3d vecItemNew=ptNew-ptCenItem;
					CoordSys csItem2Ref = cs2Item;csItem2Ref.invert();
					Vector3d vecSipNew=vecItemNew;vecSipNew.transformBy(csItem2Ref);
					Vector3d vxNewLift = vyLift;
					if (vxNewLift.dotProduct(vecSipNew)<0)vxNewLift*=-1;
					mapTsl.setVector3d("vxNewLiftf_Item", vxNewLift);
				
					mapTsl.setInt("triggerFromOutside", true);
					tslLifting.setMap(mapTsl);
					tslLifting.recalcNow(sPublicCommand);
					setExecutionLoops(2);
					return;
				}
			}//endregion
		}
	}
	
//End add lifting device trigger//endregion 

//  HSB-23058
//region check for klhLiftingDeviceAdditional for KLH
if(bIsKlh && sip.bIsValid())
{ 
	// 
	int bSupressLiftingAddittional=_Map.getInt("SupressLiftingAddittional");
	int bKlhLiftingDeviceAdditionalFound=true;// default no error;
	if(!bSupressLiftingAddittional)
	{ 
		Map mType=getType(sip);
		int bWall=mType.getInt("bWall");
		if(!bWall)
		{ 
			int bBottomPlate=isBottomPlate(sip);
			if(bBottomPlate)
			{ 
			// read coating xml file
				String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";
				String sFileNameCoating="klhCoating";
				Map mapSettingCoating;
				String sFullPathCoating = sPath+"\\"+sFolder+"\\"+sFileNameCoating+".xml";
	
				MapObject moCoating(sDictionary ,sFileNameCoating);
				if (moCoating.bIsValid())
				{
					mapSettingCoating=moCoating.map();
					setDependencyOnDictObject(moCoating);
				}
				else if ((_bOnInsert || _bOnDebug) && !moCoating.bIsValid() )
				{
					String sFile=findFile(sFullPathCoating); 
				// if no settings file could be found in company try to find it in the installation path
					if (sFile.length()<1) sFile=findFile(sPathGeneral+sFileNameCoating+".xml");	
					if (sFile.length()>0)
					{ 
						mapSettingCoating.readFromXmlFile(sFile);
						moCoating.dbCreate(mapSetting);			
					}
				}
				
				// allowed coatings considered for for item
				String sCodesItem[0];
				Map mCodes=mapSettingCoating.getMap("Code[]");
				for (int m=0;m<mCodes.length();m++) 
				{ 
					Map mI=mCodes.getMap(m);
					String sCodeI=mI.getString("HSB-reference");
					if(mI.hasInt("ShowAtItem"))
					{ 
						if(mI.getInt("ShowAtItem"))
						{ 
							if(sCodesItem.find(sCodeI)<0)
							{ 
								sCodesItem.append(sCodeI);
							}
						}
					}
				}//next m
				// bottom plate check the refinement code
				int bRefinementCodeIsUsed=refinementCodeIsUsed(sip,sCodesItem);
				if(bRefinementCodeIsUsed)
				{ 
					// also refinement code is used
					// make sure that there is a klhliftingAdditional
					bKlhLiftingDeviceAdditionalFound=false;// show error
					Entity entTools[] = sip.eToolsConnected();
					for (int e=0;e<entTools.length();e++) 
					{ 
						TslInst tsl=(TslInst)entTools[e];
						if(tsl.bIsValid() && tsl.scriptName()=="klhLiftingDeviceAdditional")
						{ 
							bKlhLiftingDeviceAdditionalFound=true;
							break;
						}
					}//next e
				}
			}
		}
		if(!bKlhLiftingDeviceAdditionalFound)
		{ 
			Map mInError;
			mInError.setBody("bd",item);
			mInError.setString("sError","Panel requires klhLiftingDeviceAdditional");
			mInError.setVector3d("vx",_XW);
			mInError.setVector3d("vy",_YW);
			mInError.setVector3d("vz",_ZW);
			mInError.setPoint3d("ptC",item.ptCen());
			drawError(sip, mInError);
		}
	}
	int bKlhDisplayFound;
	Entity entTools[] = sip.eToolsConnected();
	for (int e=0;e<entTools.length();e++) 
	{ 
		TslInst tsl=(TslInst)entTools[e];
		if(tsl.bIsValid() && tsl.scriptName()=="klhDisplay")
		{ 
			bKlhDisplayFound=true;
			break;
		}
	}//next e
	//region Trigger IgnoreLiftingAdditionalRule
	String sTriggerIgnoreLiftingAdditionalRule = T("|Ignore klhLiftingDeviceAdditional|");
	if(bSupressLiftingAddittional)
		sTriggerIgnoreLiftingAdditionalRule = T("|Don't ignore klhLiftingDeviceAdditional|");
	//HSB-23131
	if(_Map.hasInt("SupressLiftingAddittional") || !bKlhLiftingDeviceAdditionalFound)
	{
		// show command only if it is set or rule is shown
		addRecalcTrigger(_kContext, sTriggerIgnoreLiftingAdditionalRule);
	}
	
	if (_bOnRecalc && _kExecuteKey==sTriggerIgnoreLiftingAdditionalRule)
	{
		int bSupressLiftingAddittional=!_Map.getInt("SupressLiftingAddittional");
		_Map.setInt("SupressLiftingAddittional",bSupressLiftingAddittional);
		if(!bSupressLiftingAddittional)
		{ 
			// remove from map
			_Map.removeAt("SupressLiftingAddittional",true);
		}
		// update klhDisplay
		
		int bKlhDisplayFound;
		TslInst tslKlhDisplay;
		Entity entTools[] = sip.eToolsConnected();
		for (int e=0;e<entTools.length();e++) 
		{ 
			TslInst tsl=(TslInst)entTools[e];
			if(tsl.bIsValid() && tsl.scriptName()=="klhDisplay")
			{ 
				bKlhDisplayFound=true;
				tslKlhDisplay=tsl;
				break;
			}
		}//next e
		if(bKlhDisplayFound)
		{ 
			Map mapKlhDisplay=tslKlhDisplay.map();
			mapKlhDisplay.setInt("SupressLiftingAddittional",bSupressLiftingAddittional);
			if(!bSupressLiftingAddittional)
			{ 
				// remove from map
				mapKlhDisplay.removeAt("SupressLiftingAddittional",true);
			}
			tslKlhDisplay.setMap(mapKlhDisplay);
			tslKlhDisplay.recalc();
		}
		setExecutionLoops(2);
		return;
	}//endregion
}
//End check for klhLiftingDeviceAdditional for KLH//endregion

//region Validate FaceAlignment

	int bFlipByQuality;
	if (nRefType==1 && vecZ.isParallelTo(_ZW) && nFaceAlignment!=0)
	{
		int nQualityBot = sqBot.quality();
		int nQualityTop = sqTop.quality();
		bFlipByQuality = (vecZ.isCodirectionalTo(_ZW) && nQualityBot > nQualityTop)|| (vecZ.isCodirectionalTo(-_ZW) && nQualityBot < nQualityTop);
		
		if (nFaceAlignment == 2)
			bFlipByQuality = !bFlipByQuality;
	}
	// HSB-19958
	int bFlipByReferenceSide;
	String sQualityHigh;
	String sQualities[0];
	int nColorQualities[0];
	if(bIsKlh)
	{ 
//		if(nRefType==1 && vecZ.isParallelTo(_ZW) && nFaceAlignment==0)
		if(nRefType==1)
		{ 
			String sLabel=sip.label();
			String sType=sLabel.makeUpper().left(1);
			// HSB-24086: set side only onDbCreated
			if((sType=="F" || sType=="R") && _bOnDbCreated)
			{ 
				if(vecZ.dotProduct(_ZW)<0)
				{ 
					bFlipByReferenceSide=true;
				}
				else
				{ 
					//dont change; at R,F reference side has priority
					bFlipByQuality=false;
				}
			}
		}
		String _sQualities[]={"Wsi","Wzi","Wta","Wgb","Isi","Nsi"};
		sQualities=_sQualities;
		int _nColorQualities[]={1,22,21,232,94,7};
		nColorQualities=_nColorQualities;
	}
	
	if (bFlipByQuality && _kExecutionLoopCount==0 
		|| bFlipByReferenceSide && _kExecutionLoopCount==0)
	{
		CoordSys cs;
		if(!bIsKlh)
		{
			cs.setToRotation(180, vecX,_Pt0);
		}
		else
		{ 
			// 
			String sStyle=sip.style();
			if (sStyle.find("DQ",-1,false)>-1 || sStyle.find("TT",-1,false)>-1)
			{ 
				cs.setToRotation(180, vecY,_Pt0);
			}
			else
			{ 
				cs.setToRotation(180, vecX,_Pt0);
			}
		}
		_ThisInst.transformBy(cs);
		setExecutionLoops(2);
		return;
	}
//End Validate FaceAlignment//endregion


	double dShrink;
	PlaneProfile ppWarn;
	LineSeg segWarn;
	if (bValidateStacking)
	{ 
		ppWarn = item.shadowProfile(Plane(ptCen, _ZW));
		
	// get extents of profile
		segWarn = ppWarn.extentInDir(vecX);
		double dX = abs(vecX.dotProduct(segWarn.ptStart()-segWarn.ptEnd()));
		double dY = abs(vecY.dotProduct(segWarn.ptStart()-segWarn.ptEnd()));	
		
		dShrink = U(100);
		if (dX * .25 < dShrink)dShrink = .25 * dX;
		if (dY * .25 < dShrink)dShrink = .25 * dY;	
	}
	
	if (bValidateStacking && !entParent.bIsValid())
	{ 
		PlaneProfile pp = ppWarn;
		PlaneProfile pp2 = pp;
		pp2.shrink(dShrink);
		pp.subtractProfile(pp2);		

		Display dpv(1);
		dpv.textHeight(U(100));
		dpv.draw(pp, _kDrawFilled);
		
		Vector3d vecXRead = segWarn.ptEnd() - segWarn.ptStart(); vecXRead.normalize();
		if (vecXRead.dotProduct(_XW) < 0)vecXRead *= -1;
		Vector3d vecYRead = vecXRead.crossProduct(-_ZW);
		dpv.draw(T("|Not assigned to truck|"), segWarn.ptMid(), vecXRead, vecYRead, 0, 1.5);
		ppWarn=pp2;
		
	}
	if (bValidateStacking && sTruckValidationProperty.length()>0)
	{ 

		Display dpv(2);
		dpv.textHeight(U(100));

		String value,value2;
		if (sip.bIsValid())value = sip.formatObject(sTruckValidationProperty);
		else if (genBeam.bIsValid()) value = genBeam.formatObject(sTruckValidationProperty);
		else if (tslInst.bIsValid()) value = tslInst.formatObject(sTruckValidationProperty);
		else if (element.bIsValid()) value = element.formatObject(sTruckValidationProperty);
		value = value.trimLeft().trimRight(); 
		
		TslInst truck;
		String sHandle = entRef.subMapX("Hsb_TruckChild").getString("ParentUID");
		truck.setFromHandle(sHandle);
		if (truck.bIsValid())
			value2 = truck.propInt(0);

		
		if (value2!="" && value!=value2)
		{ 
			PlaneProfile pp=ppWarn;
			PlaneProfile pp2=pp;
			pp2.shrink(dShrink);
			pp.subtractProfile(pp2);
			
			dpv.draw(pp,_kDrawFilled);
			
			Vector3d vecXRead=segWarn.ptEnd()-segWarn.ptStart(); vecXRead.normalize();
			if (vecXRead.dotProduct(_XW) < 0)vecXRead *= -1;
			Vector3d vecYRead=vecXRead.crossProduct(-_ZW);
			dpv.draw(T("|Truck does not match| ")+value+"<>"+value2,segWarn.ptMid(),vecXRead,vecYRead,0,-1.5);
			
		}
	}

	//if(bDebug)reportMessage("\n		"+ scriptName() + " reading the properties took " + (getTickCount()-nTick)+ " milliseconds");
	
	
// show source ref
	dp.color(254);

// draw relation if toggled
	if (bShowRelation)
	{
		Display dpRelation(_ThisInst.color());	
		Point3d ptStart = ptOrg;
		Point3d ptEnd = ptOrgE;
		Point3d ptMid = (ptStart+ptEnd)/2;
		Vector3d vecs[] ={_XW,_YW,_ZW};

		for (int v=0;v<vecs.length();v++)
		{
			
			double d = vecs[v].dotProduct(ptEnd-ptStart)*.5;
			Vector3d vec = vecs[v]*d;
			dpRelation.draw(PLine(ptStart, ptStart+vec));
			dpRelation.draw(PLine(ptEnd, ptEnd-vec));
			ptStart.transformBy(vec);
			ptEnd.transformBy(-vec);	
		}
	}
//	if (bDebug)
//		dp.draw(sMyUID + ": " + entRef.typeDxfName() + " " + entRef.handle(),  ptOrg, vecX, vecY, 1,0);
//

// draw tags
// draw properties and plines
	dp.color(nTextColor>-2?nTextColor:255);
	
	
//region Resolve format by entity
	Vector3d vecXView = _XW;// TODO specify reading direction, vecZView to resolve combined surface quality bottom/top
	Vector3d vecYView = _YW;
	String sNameMap,sMpTextMap;
	for (int i=0;i<ents.length();i++) 
	{ 
		CoordSys ms2ps = cs2Item;//(_PtW, _XW, _YW, _ZW); // TODO assign modelspace to paperspace transformation if text needs to be displayed in paperspace
		Vector3d vecZView = vecXView.crossProduct(vecYView);
		Entity ent = ents[i]; 
		Beam bm = (Beam)ent;
		Sheet sh = (Sheet)ent;
		Sip sip = (Sip)ent;
		Opening opening = (Opening)ent;
		OpeningSF openingSF = (OpeningSF)ent;
		Element element = (Element)ent;
		TslInst tsl = (TslInst)ent;
		MetalPartCollectionEnt mpce = (MetalPartCollectionEnt)ent;
		ChildPanel child = (ChildPanel)ent;
		
		Point3d ptCen;
		{
			Point3d pts[] = ent.gripPoints();
			if (pts.length()>0)ptCen.setToAverage(ent.gripPoints());
		}
		ptCen.vis(3);
		int bIsSolid = ent.realBody().volume() > pow(dEps, 3);

	//region Sip & tsl specifics
		Vector3d vecXGrain, vecYGrain;
		int nRowGrain = - 1;
		double dLengthBeforeGrain; // the potential line number of the grain symbol and the amount of characters in the same row befor symbol
		int nGrainMode = -1; // 0 = X lengthwise, 1 = Y crosswise, 2 = Z parallel to view
		String sqTop,sqBottom; 
		SipComponent components[0];
		HardWrComp hwcs[0];
		
		if (child.bIsValid())
			sip = child.sipEntity();
		
	// sip specifics		
		if (sip.bIsValid())
		{
			SipStyle style(sip.style());
			sqTop = sip.surfaceQualityOverrideTop();
			if (sqTop.length() < 1)sqTop = style.surfaceQualityTop();
			if (sqTop.length() < 1)sqTop = "?";
			int nQualityTop = SurfaceQualityStyle(sqTop).quality();
			
			sqBottom = sip.surfaceQualityOverrideBottom();
			if (sqBottom.length() < 1)sqBottom = style.surfaceQualityBottom();
			if (sqBottom.length() < 1)sqBottom = "?";
			int nQualityBottom = SurfaceQualityStyle(sqBottom).quality();
			// HSB-20243
			if(bIsKlh)
			{ 
				sQualityHigh=sqTop;
				if(nQualityBottom>nQualityTop)
					sQualityHigh=sqBottom;
			}
			
			components = style.sipComponents();
			
			ptCen = sip.ptCen();
			//
			ms2ps.setToAlignCoordSys(ptCen, sip.vecX(), sip.vecY(), sip.vecZ(), ptCen, vecXView , vecYView, vecZView);
			//ptCen.transformBy(ms2ps);
			
			vecXGrain = sip.woodGrainDirection();
			vecYGrain = vecXGrain.crossProduct(sip.vecZ());
			if (!vecXGrain.bIsZeroLength())
			{
				if (child.bIsValid())
				{
					vecXGrain.transformBy(child.sipToMeTransformation());
					vecYGrain.transformBy(child.sipToMeTransformation());
				}
				vecXGrain.transformBy(ms2ps);
				vecYGrain.transformBy(ms2ps);
												
				nGrainMode = sip.vecX().isParallelTo(vecXGrain) ? 0 : 1;
				if (nGrainMode>-1 && !vecZView.bIsZeroLength() && vecXGrain.isParallelTo(vecZView))
					nGrainMode = 2;
				vecXGrain.normalize();
				vecYGrain.normalize();
				
			}	
		}
	// tsl specifics	
		else if (tsl.bIsValid())
		{
			hwcs=tsl.hardWrComps();
		}
	//End Sip & tsl specifics//endregion 	
		String sLines[0];// store the resolved variables by line (if \P was found)	
		String sValues[0];	
		String sValue=ent.formatObject(sFormat);
		// HSB-23446
		int bShowAtItem;
		if(bIsKlh && sip.bIsValid())
		{ 
			// HSB-22499:
//			if(sFormat.find("@(CoatingCode)",-1,false)>-1)
			{ 
				// coating code is prompted
				// read coating xml file
				{ 
					String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";
					String sFileNameCoating="klhCoating";
					Map mapSettingCoating;
					String sFullPathCoating = sPath+"\\"+sFolder+"\\"+sFileNameCoating+".xml";

					MapObject moCoating(sDictionary ,sFileNameCoating);
					if (moCoating.bIsValid())
					{
						mapSettingCoating=moCoating.map();
						setDependencyOnDictObject(moCoating);
					}
					else if ((_bOnInsert || _bOnDebug) && !moCoating.bIsValid() )
					{
						String sFile=findFile(sFullPathCoating); 
					// if no settings file could be found in company try to find it in the installation path
						if (sFile.length()<1) sFile=findFile(sPathGeneral+sFileNameCoating+".xml");	
						if (sFile.length()>0)
						{ 
							mapSettingCoating.readFromXmlFile(sFile);
							moCoating.dbCreate(mapSetting);			
						}
					}
					
					// allowed coatings considered for for item
					String sCodesItem[0];
					Map mCodes=mapSettingCoating.getMap("Code[]");
					for (int m=0;m<mCodes.length();m++) 
					{ 
						Map mI=mCodes.getMap(m);
						String sCodeI=mI.getString("HSB-reference");
						if(mI.hasInt("ShowAtItem"))
						{ 
							if(mI.getInt("ShowAtItem"))
							{ 
								if(sCodesItem.find(sCodeI)<0)
								{ 
									sCodesItem.append(sCodeI);
								}
							}
						}
					}//next m
					// get all coating TSLS
					TslInst tslCoatings[]=getAttachedTsls(sip,"klhCoating");
				// get the codes used for this panel, accept only those that are allowed in the 
				// xml definition
					
					String sCoatingCodeUsed;
					for (int t=0;t<tslCoatings.length();t++) 
					{ 
						String sCodeI=tslCoatings[t].propString(0);
						if(sCodesItem.find(sCodeI)>-1)
						{ 
							sCoatingCodeUsed=sCodeI;
							// HSB-23446: Oberflächenveredelung
							bShowAtItem=true;
							break;
						}
					}//next t
					if(sFormat.find("@(CoatingCode)",-1,false)>-1)
					{ 
						//
						Map mapAdd;
						mapAdd.setString("CoatingCode",sCoatingCodeUsed);
						sValue=ent.formatObject(sFormat,mapAdd);
					}
				}
			}
		}
	
	// parse for any \P (new line)
		int left=sValue.find("\\P",0);
		while(left>-1)
		{
			sValues.append(sValue.left(left));
			sValue=sValue.right(sValue.length()-2-left);
			left=sValue.find("\\P",0);
		}
		sValues.append(sValue);	
	
	// resolve unknown variables
		for (int v= 0; v < sValues.length(); v++)
		{
			String& value = sValues[v];
			int left = value.find("@(", 0);
			
		// get formatVariables and prefixes
			if (left>-1)
			{ 
				// tokenize does not work for strings like '(@(KEY))'
				String sTokens[0];
				while (value.length() > 0)
				{
					left = value.find("@(", 0);
					int right = value.find(")", left);
					
				// key found at first location	
					if (left == 0 && right > 0)
					{
						String sVariable = value.left(right + 1);
	
					// any solid	
						if (bIsSolid && sVariable.find("@(Calculate Weight)",0,false)>-1)
						{
							Map mapIO,mapEntities;
							mapEntities.appendEntity("Entity", ents[i]);
							mapIO.setMap("Entity[]",mapEntities);
							TslInst().callMapIO("hsbCenterOfGravity", mapIO);
							double dWeight = mapIO.getDouble("Weight");// / dConversionFactor;
							
							String sTxt;
							if (dWeight<10)	sTxt.formatUnit(dWeight, 2,1);			
							else			sTxt.formatUnit(dWeight, 2,0);
							sTxt = sTxt + " kg";						
							sTokens.append(sTxt);
						}
					// SIP
						else if (sip.bIsValid())
						{ 
							if (sVariable.find("@(GrainDirectionText)",0,false)>-1)
								sTokens.append(vecXGrain.isParallelTo(_XW) ? T("|Lengthwise|") : T("|Crosswise|"));
							else if (sVariable.find("@(GrainDirectionTextShort)",0,false)>-1)
								sTokens.append(vecXGrain.isParallelTo(_XW) ? T("|Grain LW|") : T("|Grain CW|"));
							else if (sVariable.find("@(surfaceQualityBottom)",0,false)>-1)
								sTokens.append(sqBottom);	
							else if (sVariable.find("@(surfaceQualityTop)",0,false)>-1)
								sTokens.append(sqTop);	
							else if (sVariable.find("@(SurfaceQuality)",0,false)>-1)
							{
								String sQualities[] ={sqBottom, sqTop};
								if (!vecZView.bIsZeroLength() && sip.vecZ().isCodirectionalTo(vecZView))sQualities.swap(0, 1);
								String sQuality = sQualities[0] + " (" + sQualities[1] + ")";
								sTokens.append(sQuality);	
							}
							else if (sVariable.find("@(Graindirection)",0,false)>-1 && !vecXGrain.bIsZeroLength())
							{
								nRowGrain = sLines.length();
								String sBefore;
								for (int j=0;j<sTokens.length();j++) 
									sBefore += sTokens[j]; // the potential characters before the grain direction symbol
								dLengthBeforeGrain = dp.textLengthForStyle(sBefore, sDimStyle, dTxtH);
								sTokens.append("  ");//  2 blanks, symbol size max 2 characters lengt
							}
							else if (sVariable.find("@(SipComponent.Name)",0,false)>-1)
								sTokens.append(SipStyle(sip.style()).sipComponentAt(0).name());								
							else if (sVariable.find("@(SipComponent.Material)",0,false)>-1)
								sTokens.append(SipStyle(sip.style()).sipComponentAt(0).material());
							else if (sVariable.find("@("+T("|ViewSide|"),0,false)>-1)
							{
								sViewSide= entRef.formatObject(sVariable,mapAddFormat);// enable Alias
								sTokens.append(sViewSide);	// HSB-23619
							}
						}
					// OPENING	
						else if (opening.bIsValid())
						{
							if (sVariable.find("@(Width)", 0, false) >- 1)			sTokens.append(opening.width());
							else if (sVariable.find("@(Height)", 0, false) >- 1)	sTokens.append(opening.height());
							else if (sVariable.find("@(Rise)", 0, false) >- 1)		sTokens.append(opening.rise());
							else if (sVariable.find("@(SillHeight)", 0, false) >- 1)		sTokens.append(opening.sillHeight());
							else if (sVariable.find("@(HeadHeight)", 0, false) >- 1)		sTokens.append(opening.headHeight());
							else if (sVariable.find("@(Description)", 0, false) >- 1)		sTokens.append(opening.description());
							else if (sVariable.find("@(Type)", 0, false) >- 1)		sTokens.append(opening.type());
						}
					// OPENING SF	
						else if (openingSF.bIsValid())
						{ 							
							if (sVariable.find("@(GapSide)",0,false)>-1)		sTokens.append(openingSF.dGapSide());
							else if (sVariable.find("@(GapTop)",0,false)>-1)		sTokens.append(openingSF.dGapTop());
							else if (sVariable.find("@(GapBottom)",0,false)>-1)		sTokens.append(openingSF.dGapBottom());
							else if (sVariable.find("@(StyleNameSF)",0,false)>-1)		sTokens.append(openingSF.styleNameSF());
						}
					// BEAM
						else if (bm.bIsValid())
						{ 
							if (sVariable.find("@(Surface Quality)",0,false)>-1)	sTokens.append(bm.texture());
						}
					// MetalPartCollectionEnt
						else if (bm.bIsValid())
						{ 
							if (sVariable.find("@(Definition)",0,false)>-1)	sTokens.append(mpce.definition());
						}							
						value = value.right(value.length() - right - 1);
					}
				// any text inbetween two variables	
					else if (left > 0 && right > 0)
					{
						sTokens.append(value.left(left));
						value = value.right(value.length() - left);
					}
				// any postfix text
					else
					{
						sTokens.append(value);
						value = "";
					}
				}
	
				for (int j=0;j<sTokens.length();j++) 
					value+= sTokens[j]; 
			}
			//sAppendix += value;
			sLines.append(value);
		}	
		
	// text out
		String sText;
		for (int j=0;j<sLines.length();j++) 
		{ 
			sText += sLines[j];
			if (j < sLines.length() - 1)sText += "\\P";		 
		}//next j
		Point3d ptTxt = _Pt0;
		if (element.bIsValid())
		{
			ptTxt.setToAverage(element.plEnvelope().vertexPoints(true));
			ptTxt.transformBy(csItem);
			ptTxt.setZ(0);
			ptTxt+=_ZW *(dZW);
		}
		// HSB-20243
		if(bIsKlh)
		{ 
			// HSB-23446
			if(!bShowAtItem)
			{ 
				// Map color
				int nColorInd=sQualities.findNoCase(sQualityHigh,-1);
				if(nColorInd>-1)
				{ 
					dp.color(nColorQualities[nColorInd]);
				}
			}
			else
			{ 
				// bShowAtItem true, Oberflächenveredelung
				dp.color(6);
			}
		}
		dp.draw(sText, ptTxt,vecXView,vecYView,0,0);
	// HSB-18847: Fix name and MP-Text
		sNameMap=ent.formatObject("@(Name)");
		sMpTextMap=ent.formatObject("@(KLH Elementliste.MP-Text)");
//		if(sLines.length()<=2)
//		{ 
//			sNameMap=sLines[0];
//			if(sLines.length()==2)
//				sMpTextMap=sLines[1];
//		}
//		else if(sLines.length()>2)
//		{ 
//			sNameMap=sLines[1];
//			if(sLines.length()>2)
//				sMpTextMap=sLines[2];
//		}
	// draw the grain direction symbol
		if (nRowGrain>-1 && sLines.length()>0)
		{ 
			double dYBox=dp.textHeightForStyle(sText,sDimStyle,dTxtH);
			double dRowHeight=dYBox/sLines.length();
			double dX=vecXView.isParallelTo(vecXGrain)?2*dp.textLengthForStyle("O",sDimStyle,dTxtH):.8*dTxtH;
			Point3d pt=_Pt0+vecYView*(.5*(dYBox-dRowHeight)-nRowGrain*dRowHeight);
			if (dLengthBeforeGrain>0)pt+=vecXView*.5*(dLengthBeforeGrain+dX);
			PLine pl;	
			pl.addVertex(pt-vecXGrain*.5*dX-vecYGrain*.5*dTxtH);
			pl.addVertex(pt-vecXGrain*dX);
			pl.addVertex(pt+vecXGrain*dX);
			pl.addVertex(pt+vecXGrain*.5*dX+vecYGrain*.5*dTxtH);
			dp.draw(pl);
		}		
	}//next i
// HSB-18371
	if(ents.length()==1)
	{ 
		Map mapXproperties;
		mapXproperties.setString("Name",sNameMap);
		mapXproperties.setString("MpText",sMpTextMap);
		_ThisInst.setSubMapX("mapXproperties",mapXproperties);
	}
//End Resolve format by entity//endregion 

// collect additional requests
	Map mapRequests[0];
	TslInst tsls[0];
	if (bAddRequest && sip.bIsValid())
	{ 
		Entity ents[] = sip.eToolsConnected();
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t = (TslInst)ents[i];
			if (t.bIsValid())tsls.append(t);
		}//next i	
	}
	
	for (int i=0;i<tsls.length();i++) 
	{ 
		TslInst& t = tsls[i];
		String sScriptName = t.scriptName();
		int bAdd;
		if(sScriptNames.length() < 1) bAdd=true;
		else
		{ 
			for (int j=0;j<sScriptNames.length();j++) 
			{ 
				if(sScriptNames[j].find(sScriptName,0,false)>-1) 
				{ 
					bAdd = true;
					break;
				}
			}//next j
		}
		if (bAdd)
		{
			Map m = t.map();
			if (m.hasMap("DimRequest[]"))
				mapRequests.append(m.getMap("DimRequest[]"));
		}
	}//next i	

// draw additional requests
	Vector3d vecZMid = _ZE * _ZE.dotProduct(item.ptCen() - _Pt0);
	for (int i=0;i<mapRequests.length();i++) 
	{ 
		Map& m2 = mapRequests[i]; 
		for (int j=0;j<m2.length();j++) 
		{ 
			Map mapRequest = m2.getMap(j);
			mapRequest.transformBy(csItem);
			mapRequest.transformBy(vecZMid);
			
		// allow only requests which match the ParentUID or are not tagged with parentUID
			String sParentUID = mapRequest.getString("ParentUID");
			if (sParentUID.length()>0 && sParentUID!=entRef.handle())continue;	
			
		// get and validate allowed view direction and flag if reverese view is allowed (default = true)
			Vector3d vecZView = mapRequest.getVector3d("AllowedView");
			int bAlsoReverseView = true;
			if (mapRequest.hasInt("AlsoReverseDirection"))bAlsoReverseView =mapRequest.getInt("AlsoReverseDirection");			
			if (!vecZView.isParallelTo(_ZE) || (bAlsoReverseView==false && !vecZView.isCodirectionalTo(_ZE))) {continue;}
		
		//region // PLine Request
			if (mapRequest.hasPLine("pline"))
			{ 
				int nDrawFilled = mapRequest.getInt("DrawFilled");
				int nt = mapRequest.getInt("Transparency");
				Display dp(mapRequest.getInt("color"));
				if (mapRequest.hasString("lineType"))dp.lineType(mapRequest.getString("lineType"));
				PLine pl = mapRequest.getPLine("pline");
				PlaneProfile pp(pl);
			// scale if this is required
				if (mapRequest.hasPoint3d("ptScale"))
				{
					Point3d ptScale= mapRequest.getPoint3d("ptScale");
					double dScale =1;///dViewScale;
					CoordSys csScale;
					CoordSys cs = pp.coordSys();
					csScale.setToAlignCoordSys(ptScale,cs.vecX() ,cs.vecY(),cs.vecZ(),ptScale,cs.vecX() *dScale ,cs.vecY()*dScale ,cs.vecZ()*dScale );
					pl.transformBy(csScale);
					pp.transformBy(csScale);
				}		
				if (pl.length() < pow(dEps, 2))continue;

			// draw profile	
				if (nt>0)// 1.1
					dp.draw(pp,nDrawFilled, nt);
				else if (nDrawFilled!=0)// 1.1
					dp.draw(pp,nDrawFilled);
				else
					dp.draw(pl);				
			}				
		//End // PLine Request//endregion 
		//region Block Request
			else if (mapRequest.hasString("BlockName"))
			{ 	
				String sBlockName = mapRequest.getString("BlockName");
				Point3d ptLoc = mapRequest.getPoint3d("ptLocation");;
				Vector3d vecXB = mapRequest.getVector3d("vecX");
				Vector3d vecYB = mapRequest.getVector3d("vecY");			
				Vector3d vecZB = vecXB.crossProduct(vecYB);

				Display dp(mapRequest.getInt("color"));
				dp.draw(Block(sBlockName), ptLoc,vecXB, vecYB, vecZB);
			}	
		//End Block Request//endregion 	
		//region Text Request
			else if (mapRequest.hasString("text"))
			{ 
				int nc,nDeviceMode;
				String sThisDimStyle = sDimStyle,sLineType;
				double dThisTextHeight = dTxtH;
				
				String k;
				k = "color"; 		if (mapRequest.hasInt(k)) 		nc = mapRequest.getInt(k);
				k = "dimStyle"; 	if (mapRequest.hasString(k) && _DimStyles.find(mapRequest.getString(k))>-1) sThisDimStyle = mapRequest.getString(k);
				k = "textHeight"; 	if (mapRequest.hasDouble(k))	dThisTextHeight = mapRequest.getDouble(k);
				k = "lineType"; 	if (mapRequest.hasString(k) && _LineTypes.find(mapRequest.getString(k))>-1) sLineType = mapRequest.getString(k);
				k = "deviceMode"; 	if (mapRequest.hasInt(k)) 		nDeviceMode = mapRequest.getInt(k);


				Display dp(nc);		
				dp.dimStyle(sThisDimStyle);	
				if (dThisTextHeight>0)	dp.textHeight(dThisTextHeight);
				if (sLineType!="")dp.lineType(sLineType);

				Vector3d vecX = mapRequest.getVector3d("vecX");
				Vector3d vecY = mapRequest.getVector3d("vecY");
				double dXFlag = mapRequest.getDouble("dXFlag");
				double dYFlag = mapRequest.getDouble("dYFlag");
				Point3d ptLoc = mapRequest.getPoint3d("ptLocation");
				String sText= mapRequest.getString("text");	
				vecX.normalize();vecY.normalize();	
			// set text vecs
				Vector3d vecXTxt = vecX;
				Vector3d vecYTxt = vecY;
				if (nDeviceMode == _kDeviceX)
				{
					vecXTxt = _XW;
					vecYTxt = _YW;
				}
			// draw the text	
				if (nDeviceMode>0)
					dp.draw(sText,ptLoc,vecXTxt , vecYTxt , dXFlag, dYFlag,nDeviceMode);	
				else
				{
				// workaround to mimic device mode	
					if (!vecXTxt.crossProduct(vecYTxt).isCodirectionalTo(_ZW))vecYTxt *= -1;
					if (vecYTxt.isCodirectionalTo(-_YW) || vecYTxt.isCodirectionalTo(_XW)){vecXTxt *= -1;vecYTxt *= -1;}					
					dp.draw(sText,ptLoc,vecXTxt , vecYTxt , dXFlag, dYFlag);					
				}		
			}
		
		//End Text Request//endregion 	
		}
	}//next i





	_Map.setVector3d("vecX",_XE);
	_Map.setVector3d("vecY",_YE);
	_Map.setVector3d("vecZ",_ZE);
	_Map.setPoint3d("ptCen", ptCen);


// store freight data in mapX
	{
		Map mapX;
		mapX.setString("MyUid", entRef.handle());
		_ThisInst.setSubMapX(sItemX,mapX);
	}
	
//	// TODO make it compatible to PanelChildGrouping
//	{ 
//	// compose mapX with Stacking info 
//		Map mapX;
//		mapX.setEntity("Entity", entRef);
//		mapX.setString("ParentUid", entParent.handle());
//		mapX.setPoint3d("ptRelOrg", csChildRel.ptOrg(), _kAbsolute);
//		mapX.setPoint3d("ptVecX", csChildRel.ptOrg() + csChildRel.vecX(), _kAbsolute);
//		mapX.setPoint3d("ptVecY", csChildRel.ptOrg() + csChildRel.vecY(), _kAbsolute);
//		mapX.setPoint3d("ptVecZ", csChildRel.ptOrg() + csChildRel.vecZ(), _kAbsolute);
//
//	// (over)write submapX
//		_ThisInst.setSubMapX("Hsb_StackingChild",mapX);
//	}
	
	

// display coordinate axises
{
	double dAxisMin = U(20);
	Point3d ptAxis=ptCen;
	double dXAxis = dAxisMin;//.5*dX;	if(dX > dAxisMin*2) dXAxis = dAxisMin*2;
	double dYAxis = dAxisMin;//.5*dY;	if(dY > dAxisMin) dYAxis = dAxisMin ;
	double dZAxis = dAxisMin;//.5*dZ;	if(dZ > dAxisMin) dZAxis = dAxisMin ;
	
	PLine plXPos (ptAxis, ptAxis+vecX*dXAxis);
	PLine plXNeg (ptAxis, ptAxis-vecX*dXAxis);
	PLine plYPos (ptAxis, ptAxis+vecY*dYAxis);
	PLine plYNeg (ptAxis, ptAxis-vecY*dYAxis);
	PLine plZPos (ptAxis, ptAxis+vecZ*dZAxis);
	PLine plZNeg (ptAxis, ptAxis-vecZ*dZAxis);

	Display dpAxis(7);
	
	dpAxis.color(1);		dpAxis.draw(plXPos);
	dpAxis.color(14);		dpAxis.draw(plXNeg);
	dpAxis.color(3);		dpAxis.draw(plYPos);
	dpAxis.color(96);		dpAxis.draw(plYNeg);
	dpAxis.color(150);	dpAxis.draw(plZPos);
	dpAxis.color(154);	dpAxis.draw(plZNeg);
}

if (bDebug) reportMessage("\n			" + scriptName() + " " +_ThisInst.handle() + " ("+_kExecutionLoopCount+") " +(getTickCount()-nTick) + "ms");	

	
	



























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
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BJDVI65O?VUA-<QI=W6[R82WS/M
M!)('H`.M6Z`"BBB@`HHHH`***J6.I66II,]C<QW"0RF&1HSD!QC(S[9%`%NB
MBB@`HHHH`****`"BBB@`HHHH`**:S*B%G8*H&22<`4D<B2QK)&=R,,J?44`/
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHKC/''BK^RK8Z?92?Z;*/G8?\LE/]3V_/TK*M6C1@YR-\/AYXBHJ<-V
M0Z]\0X]-U&2SL;9+GR^'D+X&[N!ZXKGKWXIZI#`T@MK.-1T^5B?YURMI:SWM
MU';6T;232-A5'4US6L_:(]3GM+A#&]O(T90]B#@UX4,5B:TF[V7]:'UU/+,'
M32@XIR\_S/H;P1X@?Q+X8@OY]GVC>\<P08`8'C_QTJ?QK4UNZELM`U&[@(6:
M"UED0D9`95)'\J\H^"^K^5J%_H[M\LR">('^\O##\01_WS7J/B;_`)%36/\`
MKQF_]`->[AY<\$SY;,:'L,1**VW7S/GSX7:C>:K\7-/O+^YDN;F03%Y)&R3^
MZ?\`3VKZ8KY&\!^(+7PMXOL]8O(II8(%D#)"`6.Y&48R0.I'>O3;G]H)!,1:
M^'6:+LTMWM8_@%./SKMJP<I:(\BC4C&/O,]LHKA_!'Q.TKQI,UFD,EEJ"KO^
MSR,&#@==K<9QZ8!K5\7>-=)\&6"7&HNS2RY$-O$,O)CK]`.Y-8\KO8Z>>-N:
M^AT=%>%S_M!7!E/V?P]$L>>/,N23^BBK^D?'N&YNXH-0T*2(2,%$EO.'Y)Q]
MT@?SJO93[$>WAW+'QVUS4M,TS2K&RNY((+XS"X$?!<+LP,]<?,<CO6C\"_\`
MD0)?^OZ3_P!!2N>_:$^[X=^MS_[2K"\#?%&Q\%>#6T_[!->7SW3R[`P1%4A0
M,MR<\'H*M1;II(R<U&LVSZ*HKQ?3_P!H&VDN%34=!DAA/62"X$A'_`2H_G7K
M>EZK9:UIL.H:?<+/:S+E'7^1]".XK*4)1W-XU(RV9=HK.U'6+73<+(2\I&1&
MO7\?2LH>)[F3F'3RR^NXG^E26=-161I6M-J%R\$EL865-V=V>X'3'O46HZ])
M:7SVD-F973&3N]1GH![T`;E%<RWB._C&Z73BJ>I##]:U-,UFWU/**#'*HR48
M_P`O6@#2HJM>WUO80>;.^`>@'5OI6&WBS+$16+,H]7P?Y&@"7Q8Q%A"`3@R<
MC/7BM72_^039_P#7%?Y5RVKZU'J=K'&(6C='W$$Y'2NITO\`Y!5I_P!<5_E0
M!;HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@#"\6>(X?#&A/?2??=Q%"""07()&?;`)_"O![SQ#'<7,EQ*\DTTC%F;'
M4U[#\4['[9X#NV5=SV\D<R@#_:"G]&->$V]AC#3?@M>/F*3FN=Z=CZO(H05%
MS2UO9GO?@/P_%IVC0:C+'_IMW$'.[K&AY"C\,$__`%JX'XO>'S!K]OJEL@VW
MJ;9`#_&F!G\05_(UD#QSXCTN%?(U25L855EPXQZ?,#2ZUXTN_%UK9K>6T44M
MH7R\1.'W;>QZ8V^O>AUZ7U;E@K6'1P6*AC?;3DFG>_IT_0R?"4]YI/BS3;N*
M%V*SJK*@R65OE8`=S@FOH3Q-QX4UC_KQF_\`0#7)?#SPA]BB36K^/%S(O^CQ
ML/\`5J?XC[D?D/K76^)O^14UC_KQF_\`0#7;@8S4+SZGDYUB*=6M:'V5:_\`
M78^7/`6@6WB;QG8:3>/(EO,7:0QG#$*A;&>V<8KZ)?X7^#6TUK(:)`JE=HE4
MGS1[[R<YKPSX._\`)3M+_P!V;_T4]?45>E6DU+0^?P\8N-VCY(\(22Z5\1M(
M$+G='J,<)/JI?8WY@FNK^._G?\)U;;\^7]@3R_3[[Y_6N2T3_DI&G?\`87C_
M`/1PKZ1\8^#-$\90P6NI,8KJ,,UO+$X$BCC/!ZKTR,?E5SDHR39G3BY0:1Y_
MX3UKX46?AJPCO8+`7HA47/VRQ:5_,Q\WS%3QG.,'I6]::5\+/%MTD6F1Z=]K
M1MZ+;9MWR.<A>-WY&L(_L^VF?E\0S`=@;4'_`-FKRGQ-HL_@OQ=<:=#>^9-9
MNCQW$7R'D!E/7@C([U*49/W64Y2@O>BK'J'[0GW?#OUN?_:5-^$/@7P[KOAJ
M35=4T\7=R+IXE\QVVA0%/W0<=SUJG\:[Q]0T#P;>R#:]Q;RS,,="RPG^M=?\
M"_\`D0)/^OZ3_P!!2AMJD-).L[F#\6_AYHFF>&3K>CV2V<UO*BS+$3L=&.WI
MV()'(]Z;\`=3D\G6M-=R88_+N(U_NDY#?GA?RK?^-VM6]EX).EF5?M5_*@6+
M/S;%;<6QZ94#\:YGX`V+O)KMV01'LBA4^I.XG\N/SI*[I:C:2K+E/0='MQJV
ML2W%R-RC]X5/0G/`^G^%=B`%4```#H!7(^&I!:ZI-;2_*S*5`/\`>!Z?SKKZ
MP.H2JMSJ%G9']_,B,W..I/X#FK1.%)]!7%Z1;+K&J327;,W&\@'&>?Y4`=!_
MPD6EG@W!Q[QM_A6#8M#_`,)2K6I_<L[;<<#!!KH?[!TS;C[(N/\`>;_&N?M8
M([;Q8L,0VQI(0HSGM3`EU!?[2\4I:N3Y:$+@>@&X_P!:ZJ**."(1Q(J(.BJ,
M5RLS"S\8B20@*SC!/3#+BNMI`<YXLC06L$@1=YDP6QSC'K6QI?\`R"K3_KBO
M\JRO%G_'C!_UT_H:U=+_`.05:?\`7%?Y4`6Z***`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`0@,""`01@@UQNO?#C2M4#
M36(%A<GG]VO[MC[KV_"NSHK.I2A45IJYM1Q%6A+FINS/`=5^&WBL7'E0:<L\
M:=)(YT"M]-Q!_2NA\!_#>^MKXW7B"U$,4+!HX"ZOYC=B<$C`].]>NT5A'!4H
MV/0J9SB:D'#17ZK?\PK/UVWEN_#VI6UNF^::TECC7(&YBA`'/O6A176>2SP/
MX:_#WQ3H7CRPU'4]):"TB$H>0S1MC,;`<!B>I%>^4454Y.3NR(04%9'SEI7P
MT\86WC>QU"71F6UCU*.9I//BX02`DXW9Z5Z'\6/!.M^+/[*N-%:'S+'S=RO+
ML8[MF-IQC^$]2*]*HJG4;:9*HQ47'N?-R^&?BY9KY,;ZTJ#@+'J65'TP^*M>
M'_@OXBU74EN/$++9VQ??-NF$DTG<XP2,GU)_`U]#T4_;2Z$_5X]3S3XI^`=3
M\6VNCQZ-]E1;`2J8Y7*<,$VA>".-IZX[5Y>GPN^(FF.?L5G*O^U;7T:Y_P#'
MP:^FZ*4:KBK#E1C)W/F^Q^#?C/6+P2:LT=H"?GFN;@2OCV"DY/L2*]W\,>&[
M'PIH4.E6`/EI\SR-]Z1SU8^Y_D`*V:*4JCEHRH4HPU1A:MH!NI_M5HXCFZD'
M@$COGL:JJ_B6$;-GF`="=I_6NGHJ#0R-*_MAKEVU#`AV?*OR]<CT_&LZ?0KZ
MRO&N-+<8)X7(!'MSP17444`<R(/$ES\DDHA7UW*/_0>:2UT&YL=8MI0?-A'+
MOD#!P>U=/10!DZSHPU)%>-@EP@PI/0CT-9T1\1VB"(1"55X4MM;CZY_G73T4
G`<G<6.NZIM6Y5%13D`E0!^7-=+9PM;6,$#D%HXPI(Z<"IZ*`/__9
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
        <int nm="BreakPoint" vl="1872" />
        <int nm="BreakPoint" vl="2824" />
        <int nm="BreakPoint" vl="2659" />
        <int nm="BreakPoint" vl="1500" />
        <int nm="BreakPoint" vl="2986" />
        <int nm="BreakPoint" vl="1957" />
        <int nm="BreakPoint" vl="847" />
        <int nm="BreakPoint" vl="2975" />
        <int nm="BreakPoint" vl="1550" />
        <int nm="BreakPoint" vl="2918" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24830: Support the previous styles TT,TL" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="25" />
      <str nm="Date" vl="11/3/2025 11:41:00 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24722: Change TT-&gt;DQ and TL-&gt;DL" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="24" />
      <str nm="Date" vl="10/17/2025 11:43:52 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24086: V5.11 only to be applied on creation" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="23" />
      <str nm="Date" vl="5/26/2025 2:14:38 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23619: For Sips add additional variable in format &quot;ViewSide&quot; " />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="22" />
      <str nm="Date" vl="3/26/2025 4:10:49 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23527: KLH: Compose body from array of bodies if body in map not possible" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="21" />
      <str nm="Date" vl="2/24/2025 3:43:35 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23446: KLH: Use color magenta for Oberflächenveredelung" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="20" />
      <str nm="Date" vl="2/10/2025 10:51:59 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23445: Fix transformation for klhCombiTruck" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="19" />
      <str nm="Date" vl="2/3/2025 2:47:08 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23243: Consider klhCombiTruck TSLs" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="18" />
      <str nm="Date" vl="1/13/2025 10:40:58 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23131: Show command to ignore check for &quot;klhLiftingDeviceAdditional&quot; only if needed to ignore" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="17" />
      <str nm="Date" vl="12/9/2024 9:50:22 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23058: Add check for &quot;klhLiftingDeviceAdditional&quot;" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="16" />
      <str nm="Date" vl="12/4/2024 11:28:22 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22813: Add reference via DataLink to reference entity" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="15" />
      <str nm="Date" vl="10/21/2024 10:08:37 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22499: For KLH add as additional format @(CoatingCode)" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="14" />
      <str nm="Date" vl="8/5/2024 2:46:15 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20243: KLH: set text color from highest quality" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="10/5/2023 5:26:19 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19939: Apply contour thickness on the inside" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="9/12/2023 1:35:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19958: KLH: For &quot;R&quot; and &quot;F&quot; f_Item must be positioned on the reference side" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="9/5/2023 9:47:14 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19483: Apply thickness at contour" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="7/10/2023 11:53:06 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19334: get from xml flag &quot;PropertyReadOnly&quot;" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="6/28/2023 10:36:16 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19334: On insert set properties to readonly for KLH" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="6/27/2023 10:12:32 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19334: Set &quot;Lagentrennung&quot; text at the top of the display text" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="6/27/2023 9:33:48 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19078: Fix when adding Tag to format for KLH" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="6/2/2023 9:47:13 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18964: For KLH Modify Tag property if flag &quot;BeddingRequested&quot; is set (it is set from f_Truck)" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="5/26/2023 5:25:51 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18847: Fix name and MP-Text" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="5/4/2023 9:26:04 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="#DEV: HSB-18371: Write name and MP-Text in the mapX" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="3/23/2023 3:11:01 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16359 add lifting device trigger" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="8/29/2022 2:37:30 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12497: display if stacking orientation not same as klhDevice orientation" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="7/2/2021 4:10:26 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10448 item creation prevented if parent or child entities of element relations are stacked" />
      <int nm="MajorVersion" vl="5" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="1/25/2021 10:55:17 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-9303 bugfix column offset during creation" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="1/21/2021 10:57:17 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End
