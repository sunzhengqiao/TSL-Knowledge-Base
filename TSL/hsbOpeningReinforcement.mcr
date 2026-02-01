#Version 8
#BeginDescription
1.1 02.02.2022 HSB-13856: Add information,material,label Author: Marsel Nakuci
1.0 02.02.2022 HSB-13856: Initial version Author: Marsel Nakuci


This tsl creates beam reinforcement at openings to help during transportation
If opening is wider then a max given width then vertical studs are placed 
at the middle of the opening
If opening is higher then a max value then horizontal beams are placed
at the middle of the opening
TSL can be inserted manually at walls or openings or
can be attached at walls or/and openings and be generated on wall calculation
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords opening,bracing,transportation,reinforcement
#BeginContents
//region <History>
// #Versions
// Version 1.1 02.02.2022 HSB-13856: Add information,material,label Author: Marsel Nakuci
// Version 1.0 02.02.2022 HSB-13856: Initial version Author: Marsel Nakuci
/// <insert Lang=en>
/// Select properties, select walls enter
/// </insert>

// <summary Lang=en>
// This tsl creates beam reinforcement at openings to help during transportation
// If opening is wider then a max given width then vertical studs are placed 
// at the middle of the opening
// If opening is higher then a max value then horizontal beams are placed
// at the middle of the opening
// TSL can be inserted manually at walls or openings or
// can be attached at walls or/and openings and be generated on wall calculation
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbOpeningReinforcement")) TSLCONTENT
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


//region Properties
	category = T("|Beam|");
	String sWidthName=T("|Width|");	
	PropDouble dWidth(nDoubleIndex++, U(44), sWidthName);	
	dWidth.setDescription(T("|Defines the Width of the reinforcing beam|"));
	dWidth.setCategory(category);
	
	String sHeightName=T("|Height|");	
	PropDouble dHeight(nDoubleIndex++, U(44), sHeightName);	
	dHeight.setDescription(T("|Defines the Height of the reinforcing beam|"));
	dHeight.setCategory(category);
	
	String sBeamCodeName=T("|BeamCode|");	
	PropString sBeamCode(nStringIndex++, "", sBeamCodeName);	
	sBeamCode.setDescription(T("|Defines the BeamCode for the reinforcing beam|"));
	sBeamCode.setCategory(category);
	
	String sBeamInformationName=T("|Information|");	
	PropString sBeamInformation(nStringIndex++, "", sBeamInformationName);	
	sBeamInformation.setDescription(T("|Defines the Beam Information|"));
	sBeamInformation.setCategory(category);
	
	String sBeamMaterialName=T("|Material|");	
	PropString sBeamMaterial(nStringIndex++, "", sBeamMaterialName);	
	sBeamMaterial.setDescription(T("|Defines the Beam Material|"));
	sBeamMaterial.setCategory(category);
	
	String sBeamLabelName=T("|Label|");	
	PropString sBeamLabel(nStringIndex++, "", sBeamLabelName);	
	sBeamLabel.setDescription(T("|Defines the Beam Label|"));
	sBeamLabel.setCategory(category);
	
	category = T("|Opening|");
	String sWidthOpeningMaxName=T("|Width|");	
	PropDouble dWidthOpeningMax(nDoubleIndex++, U(2500), sWidthOpeningMaxName);	
	dWidthOpeningMax.setDescription(T("|Defines the max. opening width for which no vertical beam is needed|"));
	dWidthOpeningMax.setCategory(category);
	
	String sHeightOpeningMaxName=T("|Height|");	
	PropDouble dHeightOpeningMax(nDoubleIndex++, U(2500), sHeightOpeningMaxName);	
	dHeightOpeningMax.setDescription(T("|Defines the max opening height for which no horizontal beam is needed|"));
	dHeightOpeningMax.setCategory(category);
	
	//tolerances
	category = T("|Tolerances|");
	String sLeftName=T("|Left|");	
	PropDouble dLeft(nDoubleIndex++, U(0), sLeftName);	
	dLeft.setDescription(T("|Defines the Left tolerance|"));
	dLeft.setCategory(category);
	
	String sRightName=T("|Right|");	
	PropDouble dRight(nDoubleIndex++, U(0), sRightName);	
	dRight.setDescription(T("|Defines the Right tolerance|"));
	dRight.setCategory(category);
	
	String sTopName=T("|Top|");	
	PropDouble dTop(nDoubleIndex++, U(0), sTopName);	
	dTop.setDescription(T("|Defines the Top tolerance|"));
	dTop.setCategory(category);
	
	String sBottomName=T("|Bottom|");	
	PropDouble dBottom(nDoubleIndex++, U(0), sBottomName);	
	dBottom.setDescription(T("|Defines the Bottom tolerance|"));
	dBottom.setCategory(category);
//End Properties//endregion 


//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
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
		
	// prompt for wall selections
		Entity ents[0];
		PrEntity ssE(T("|Select elements or/and openings|"), Element());
		ssE.addAllowedClass(Opening());
	  	if (ssE.go())
			ents.append(ssE.set());
		// create TSL
		
		TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {}; Entity entsTsl[1]; Point3d ptsTsl[] = {_Pt0};
		int nProps[]={}; 
		double dProps[]={dWidth,dHeight,dWidthOpeningMax,dHeightOpeningMax,
			dLeft,dRight,dTop,dBottom}; 
		String sProps[]={sBeamCode,sBeamInformation,sBeamMaterial,sBeamLabel};
		Map mapTsl;
		
		Element elements[0];
		Opening ops[0];
		
		for (int ient=0;ient<ents.length();ient++) 
		{ 
			Element el = (Element)ents[ient]; 
			if(el.bIsValid() && elements.find(el)<0)
				elements.append(el);
			Opening op = (Opening)ents[ient];
			if(op.bIsValid() && ops.find(op)<0)
				ops.append(op);
		}//next ient
		
		for (int iop=ops.length()-1; iop>=0 ; iop--) 
		{ 
			if(elements.find(ops[iop].element())>-1)
				ops.removeAt(iop);
		}//next iop
		
		
		
		if(elements.length()>0)
		{ 
			for (int iel=0;iel<elements.length();iel++) 
			{ 
				ElementWall eI=(ElementWall)elements[iel];
				if ( ! eI.bIsValid())continue;
				entsTsl[0] = eI;
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
							nProps, dProps, sProps,_kModelSpace, mapTsl);
			}//next iel
		}
		if(ops.length()>0)
		{ 
			for (int iop=0;iop<ops.length();iop++) 
			{ 
				Opening opI=(Opening)ops[iop];
				if ( ! opI.bIsValid())continue;
				entsTsl[0] = opI;
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
							nProps, dProps, sProps,_kModelSpace, mapTsl);
			}//next iel
		}
		eraseInstance();
		return;
	}
// end on insert	__________________//endregion


int iMode=_Map.getInt("Mode");
//if(iMode==0)
if(_Element.length()>0)
{ 
	// element mode
	if(_Element.length()==0)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|no wall found|"));
		eraseInstance();
		return;
	}
	
	Element el=_Element[0];
	// basic information
	Point3d ptOrg=el.ptOrg();
	Vector3d vecX=el.vecX();
	Vector3d vecY=el.vecY();
	Vector3d vecZ=el.vecZ();
	
	Opening ops[]=el.opening();
	if(ops.length()==0)
	{ 
		eraseInstance();
		return;
	}
	
	// create TSL
	TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
	GenBeam gbsTsl[] = {}; Entity entsTsl[1]; Point3d ptsTsl[] = {_Pt0};
	int nProps[]={}; 
	double dProps[]={dWidth,dHeight,dWidthOpeningMax,dHeightOpeningMax,
		dLeft,dRight,dTop,dBottom}; 
	String sProps[]={sBeamCode,sBeamInformation,sBeamMaterial,sBeamLabel};
	Map mapTsl;
	mapTsl.setInt("Mode", 1);
	for (int iop=0;iop<ops.length();iop++) 
	{ 
		entsTsl[0] = ops[iop];
		tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
							nProps, dProps, sProps,_kModelSpace, mapTsl);
	}//next iop
	eraseInstance();
	return;
}
//else if(iMode==1)
else if(_Opening.length()>0)
{ 
	// opening mode
	if(_Opening.length()==0)
	{ 
		eraseInstance();
		return;
	}
	// opening mode
	Opening op=_Opening[0];
	Element el=op.element();
	// basic information
	Point3d ptOrg=el.ptOrg();
	Vector3d vecX=el.vecX();
	Vector3d vecY=el.vecY();
	Vector3d vecZ=el.vecZ();
	// basic information
	CoordSys csOp=op.coordSys();
	Point3d ptOrgOp=csOp.ptOrg();
	Vector3d vecXOp=csOp.vecX();
	Vector3d vecYOp=csOp.vecY();
	Vector3d vecZOp=csOp.vecZ();
	_Pt0=ptOrgOp;
	
	vecXOp.vis(ptOrgOp,1);
	vecYOp.vis(ptOrgOp,3);
	vecZOp.vis(ptOrgOp,5);
	
	double dWidthOp=op.width();
	double dHeightOp=op.height();
	PlaneProfile ppOp(csOp);
	ppOp.joinRing(op.plShape(), _kAdd);
	ppOp.transformBy(vecZ * U(50));
	ppOp.vis(1);
	
	// get extents of profile
	Point3d ptMiddleOp=ppOp.extentInDir(vecX).ptMid();
	ElemZone eZone0=el.zone(0);
	ptMiddleOp+= vecZ*vecZ.dotProduct(ptOrg-vecZ*.5*eZone0.dH()-ptMiddleOp);
	ptMiddleOp.vis(5);
	
	Point3d ptEndOp=ptOrgOp+vecXOp*dWidthOp;
	
	Beam beams[]=el.beam();
	Sheet sheets[]=el.sheet();
	GenBeam genBeams[]=el.genBeam();
//	return
	
	double dLs[] ={ dWidthOp, dHeightOp };
	double dLmaxs[] ={ dWidthOpeningMax, dHeightOpeningMax };
	double dHs[] ={ dHeightOp, dWidthOp};
	Vector3d vxs[] ={ vecYOp, vecXOp};
	Vector3d vys[] ={ -vecXOp, vecYOp};
	double dTolBottoms[] ={ dBottom, dLeft};
	double dTolTops[] ={ dTop, dRight};
//	return
	LineSeg segOp = ppOp.extentInDir(vecX);
	for (int i=0;i<2;i++) 
	{ 
		if(dLs[i]>dLmaxs[i])
		{ 
			Beam bmNew;
			Point3d ptBeamBott = ptMiddleOp-vxs[i]*( .5*dHs[i]-dTolBottoms[i]);
			Point3d ptBeamTop = ptMiddleOp+vxs[i]*( .5*dHs[i]-dTolTops[i]);
			Point3d ptCenBm = .5*(ptBeamBott+ptBeamTop);
			double dLengthBm = abs(vxs[i].dotProduct(ptBeamTop - ptBeamBott));
			bmNew.dbCreate(ptCenBm,vxs[i],vys[i],vecZOp,dLengthBm,dWidth,dHeight,0,0,0);
			bmNew.setBeamCode(sBeamCode);
			bmNew.setInformation(sBeamInformation);
			bmNew.setMaterial(sBeamMaterial);
			bmNew.setLabel(sBeamLabel);
			bmNew.assignToElementGroup(el, true, 0, 'Z');
			
//			Body bdTop(ptMiddleOp+vxs[i]*.4*dHs[i], vxs[i], vys[i], vecZOp, U(6000), dWidth, dHeight, 1,0, 0);
//			bdTop.vis(3);
//			Body bdBott(ptMiddleOp-vxs[i]*.4*dHs[i], vxs[i], vys[i], vecZOp, U(6000), dWidth, dHeight, -1,0, 0);
//			bdBott.vis(2);
//			GenBeam gbTop, gbBottom;
//			Point3d ptTop, ptBottom;
//			double dBott = U(10e10), dTop = -U(10e10);
//		
//			for (int ig = 0; ig < genBeams.length(); ig++)
//			{
//				Body bdI = genBeams[ig].envelopeBody();
//				//			bdI.vis(1);
//				Body bdTopIntersect = bdI;
//				Body bdBottIntersect = bdI;
//				int iIntersectTop = bdTopIntersect.intersectWith(bdTop);
//				int iIntersectBot = bdBottIntersect.intersectWith(bdBott);
//				if ( !iIntersectTop && !iIntersectBot)continue;
//	//			bdTopIntersect.vis(1);
//				if(iIntersectTop)
//				{ 
//					PlaneProfile ppTopI = bdTopIntersect.shadowProfile(Plane(ptMiddleOp, vecZOp));
//					// get extents of profile
//					LineSeg segI=ppTopI.extentInDir(vecXOp);
//					Point3d ptBottI=vxs[i].dotProduct(segI.ptEnd()-segI.ptStart())<0?segI.ptEnd():segI.ptStart();
//					if(vxs[i].dotProduct(ptBottI-ptMiddleOp)<dBott)
//					{ 
//						gbTop = genBeams[ig];
//						dBott = vxs[i].dotProduct(ptBottI - ptMiddleOp);
//						ptTop = ptBottI;
//					}
//				}
//				if(iIntersectBot)
//				{ 
//					PlaneProfile ppBottI = bdBottIntersect.shadowProfile(Plane(ptMiddleOp, vecZOp));
//					// get extents of profile
//					LineSeg segI=ppBottI.extentInDir(vecXOp);
//					Point3d ptTopI=vxs[i].dotProduct(segI.ptEnd()-segI.ptStart())>0?segI.ptEnd():segI.ptStart();
//					if(vxs[i].dotProduct(ptTopI-ptMiddleOp)>dTop)
//					{ 
//						gbBottom = genBeams[ig];
//						dTop = vxs[i].dotProduct(ptTopI - ptMiddleOp);
//						ptBottom = ptTopI;
//					}
//				}
//			}
//			gbTop.envelopeBody().vis(1);
//			gbBottom.envelopeBody().vis(1);
//			ptTop.vis(6);
//			ptBottom.vis(6);
//			if(gbTop.bIsValid() && gbBottom.bIsValid())
//			{ 
//				// create stud in between
//				Beam bmNew;
//				double dLengthBm=abs(vxs[i].dotProduct(ptTop-ptBottom));
//				Point3d ptCenBm = .5 * (ptTop + ptBottom);
//				ptCenBm += vecZOp * vecZOp.dotProduct(ptMiddleOp - ptCenBm);
//				bmNew.dbCreate(ptCenBm,vxs[i],vys[i],vecZOp,dLengthBm,dWidth,dHeight,0,0,0);
//	//			bmNew.stretchDynamicTo(gbBottom);
//	//			bmNew.stretchDynamicTo(gbTop);
//			}
		}
		 
	}//next i
}

eraseInstance();
return;
#End
#BeginThumbnail

#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End