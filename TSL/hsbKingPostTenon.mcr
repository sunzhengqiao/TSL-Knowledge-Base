#Version 8
#BeginDescription
version value="1.2" date="29Oct2020" author="marsel.nakuci@hsbcad.com" 

HSB-9322: add properties nR drills, distance between drills
Initial
This tsl creates a tenon connection between a joist and a post.
When other other joist are connected at the same level with the same tsl the intersecting part gets cut off by a 4mm tolerance.
#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords post;joist;double cut;drill;slot;tenon;miter
#BeginContents
/// <History>//region
/// <version value="1.2" date="29Oct2020" author="marsel.nakuci@hsbcad.com"> HSB-9322: add properties nR drills, distance between drills </version>
/// <version value="1.1" date="07Jul2020" author="geoffroy.cenni@hsbcad.com"> Added a heart offset for the drill & multi beam select </version>
/// <version value="1.0" date="05Jun2020" author="geoffroy.cenni@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a tenon connection between a joist and a post.
/// When another joist is connected at the same level with the same tsl the intersecting part gets cut off by a 4mm tolerance.
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbKingPostTenon")) TSLCONTENT
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
//region Props 
	category = T("|Shoulder|");
	//3	Depth in beam
	String sShoulderName=T("|Width|");
	PropDouble dShoulder(nDoubleIndex++, U(30), sShoulderName);	
	dShoulder.setDescription(T("|Defines the Width|"));
	dShoulder.setCategory(category);
	
	category = T("|Pen|");
	//4 Extra depth pen - dianeter
	String sPenDepthName=T("|Diameter|");	
	PropDouble dPenDepth(nDoubleIndex++, U(22), sPenDepthName);	
	dPenDepth.setDescription(T("|Defines the Diameter|"));
	dPenDepth.setCategory(category);
	//8	Position Peghole/drill
	String sPenHeightName=T("|Height|");	
	PropDouble dPenHeight(nDoubleIndex++, U(90), sPenHeightName);	
	dPenHeight.setDescription(T("|Defines the Height from bottom|"));
	dPenHeight.setCategory(category);
	//Position relative to heart
	String sPenHeartOffsetName=T("|Heart Offset|");	
	PropDouble dPenHeartOffset(nDoubleIndex++, U(10), sPenHeartOffsetName);	
	dPenHeartOffset.setDescription(T("|Defines the Heart Offset|"));
	dPenHeartOffset.setCategory(category);
	// HSB-9322: nr drills
	String sNrName=T("|Nr|");	
	int nNrs[]={1,2,3};
	PropInt nNr(nIntIndex++, 1, sNrName);	
	nNr.setDescription(T("|Defines the Nr|"));
	nNr.setCategory(category);
	String sPenDistanceName=T("|Distance|");	
	PropDouble dPenDistance(nDoubleIndex++, U(25), sPenDistanceName);
	dPenDistance.setDescription(T("|Defines the Distance|"));
	dPenDistance.setCategory(category);
	
	category = T("|Tenon|");
	//1 Height Tenon
	String sTenonHeightName=T("|Height|");	
	PropDouble dTenonHeight(nDoubleIndex++, U(180), sTenonHeightName);	
	dTenonHeight.setDescription(T("|Defines the Height|"));
	dTenonHeight.setCategory(category);
	//2 Extra Height tenon
	String sTenonHeightExtraName=T("|Height Tolerance|");	
	PropDouble dTenonHeightExtra(nDoubleIndex++, U(2), sTenonHeightExtraName);	
	dTenonHeightExtra.setDescription(T("|Defines the Height Tolerance|"));
	dTenonHeightExtra.setCategory(category);
	//5	Length of the tenon.
	String sTenonLengthName=T("|Length|");	
	PropDouble dTenonLength(nDoubleIndex++, U(100), sTenonLengthName);	
	dTenonLength.setDescription(T("|Defines the Length|"));
	dTenonLength.setCategory(category);
	//6	Extra depth tenon
	String sTenonLengthExtraName=T("|Length Tolerance|");	
	PropDouble dTenonLengthExtra(nDoubleIndex++, U(2), sTenonLengthExtraName);	
	dTenonLengthExtra.setDescription(T("|Defines the Length Tolerance|"));
	dTenonLengthExtra.setCategory(category);
	//9
	String sTenonWidthName=T("|Width|");	
	PropDouble dTenonWidth(nDoubleIndex++, U(60), sTenonWidthName);	
	dTenonWidth.setDescription(T("|Defines the Width|"));
	dTenonWidth.setCategory(T("|Tenon|"));
	//7	Extra width tenon
	String sTenonWidthExtraName=T("|Width Tolerance|");	
	PropDouble dTenonWidthExtra(nDoubleIndex++, U(2), sTenonWidthExtraName);	
	dTenonWidthExtra.setDescription(T("|Defines the Width Tolerance|"));
	dTenonWidthExtra.setCategory(category);
//End Props //endregion 

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
		
		int bIsVert = 0;
		PrEntity ssE(T("|Select beams|"), Beam());
		if(ssE.go())
		{ 
			_Beam.append(ssE.beamSet());
			for (int i=0;i<ssE.beamSet().length();i++) 
			{ 
				//Check if vertical
				if(_Beam[i].vecX().dotProduct(_ZW) == 1)
				{ 
					bIsVert = i;
				}
			}//next i
		}
		_Beam.swap(bIsVert, 1);
		//_Beam.append(_Beam[0]);
		
		_Map.setInt("mode", 1);
		
		return;
	}
//endregion

int nMode = _Map.getInt("mode");

//region toolMode
		
if (nMode == 0)
{
	//region Properties
	//Easy local var
	Beam joist = _Beam[0];
	Beam post = _Beam[1];
	Point3d ptCen0 = joist.ptCenSolid();
	
	//Visualise vectors from Joist & Post
	_X0.vis(ptCen0, 1);
	_Y0.vis(ptCen0, 3);
	_Z0.vis(ptCen0, 150);
	
	//Set the local Vector Connection Set
	Vector3d vecZC = _X1;
	Vector3d vecXC = _Z1;
	
	//Check Post Vertical direction (vPX), if not equal to _ZW invert
	double dZPostDotProdW = vecZC.dotProduct(_ZW);
	if (dZPostDotProdW < 0)
		vecZC *= -1;
	
	Vector3d vecYC = vecZC.crossProduct(vecXC);
	//	Vector3d vecXC = vecZC.isPerpendicularTo(_X0) ? _X0 : _Y0;
	//	Vector3d vecYC = vecZC.crossProduct(_X0);
	//	vecYC.normalize();
	//	vecXC = vecZC.crossProduct(-vecYC);
	//	vecYC.normalize();
	
	vecXC.vis(_Pt0, 1);
	vecYC.vis(_Pt0, 3);
	vecZC.vis(_Pt0, 150);
	
	double dHeight = joist.dD(vecZC);
	double dWidth = joist.dD(vecYC);
	
	Plane pnJoistZ(ptCen0, joist.vecD(vecZC));
	Line lnZ(_Pt0, vecZC);
	
	pnJoistZ.vis(4);
	_Pt0.vis(2);
	//End Properties//endregion
	
	//region ExtendBeam
	//Get position of Extended Point
	Point3d ptE = _Pt0 + vecXC * dTenonLength;
	//ptE.vis(2);
	//Extend cut beam to extension point
	Cut ctExtend(ptE, vecXC);
	joist.addTool(ctExtend, _kStretchOnToolChange);
	//End ExtendBeam//endregion
	
	//region Does Post And Joist Align ?
	//Get intersection point Center-Center
	Point3d ptCenCen = _Pt0 + _X0 * post.dD(vecXC) * .5;
//ptCenCen.vis(2);
	//////Is not being visualized on center-center?
	

	//set up intersection box
	Body bdIntrSectBox(ptCenCen, _X0, _Y0, _Z0, U(10e4), joist.dD(_Y0), joist.dD(_Z0));
	bdIntrSectBox.addTool(Cut(_Pt0, - vecXC), 0);
	bdIntrSectBox.addTool(Cut(_Pt0 + vecXC * post.dD(vecXC), vecXC), 0);
	//bdIntrSectBox.vis(2);
	
	//get post envelop
	Body bdPost = post.envelopeBody();
	
	// compare if bodies intersect
	if (bdPost.hasIntersection(bdIntrSectBox))
	{
		bdPost.intersectWith(bdIntrSectBox); //replace bd by intersection body
		
		if (abs(bdIntrSectBox.volume() - bdPost.volume()) < pow(dEps, 3))
		{
			//bdPost.vis(3);
		}
		else
		{
			reportMessage("\n" + scriptName() + T(" : |Selected bodies do not intersect fully.|"));
			eraseInstance();
			return;
		}
	}
	else
	{
		reportMessage("\n" + scriptName() + T(" : |Selected bodies do not intersect.|"));
		eraseInstance();
		return;
	}
	//End Does Post And Joist Align ?//endregion

	//region DoubleCutShoulder
	Point3d ptShoulderTop = lnZ.intersect(pnJoistZ, .5 * dHeight);//_Pt0 + vecZC * (dHeight * .5);
	//ptShoulderTop.vis(2);
	
	Point3d ptShoulderBottom = Line(_Pt0 + vecXC * dShoulder, vecZC).intersect(pnJoistZ, - .5 * dHeight);//+ vecXC * dShoulder;
	//ptShoulderBottom.vis(2);
	
	Vector3d vecZS = ptShoulderTop - ptShoulderBottom;
	vecZS.normalize();
	//vecZS.vis(ptShoulderTop, 1);
	
	Vector3d vecXS = vecYC.crossProduct(vecZS);
	//vecXS.vis(ptShoulderTop, 1);
	
	Vector3d vShoulderBottom = joist.vecD(vecZC);
	//vShoulderBottom.vis(ptShoulderBottom, 2);
//joist.vecD(vecZC).vis(ptShoulderBottom);
//vecXS.vis(ptShoulderBottom);
	DoubleCut dcShoulder(ptShoulderBottom, joist.vecD(vecZC), ptShoulderBottom, - vecXS);
	post.addTool(dcShoulder, _kStretchNot);
	//End DoubleCutShoulder//endregion
	
	//region DoubleCutTenonHeightAndSides
	if (dTenonHeight < dHeight)
	{
		Line ln(ptShoulderBottom, vecZS);
		//ln.vis( 1);
		Point3d ptTenonTop = ln.intersect(pnJoistZ, .5 * dHeight - (dHeight - dTenonHeight));
		//ptTenonTop.vis(2);
		DoubleCut dc(ptTenonTop, joist.vecD(vecZC) , ptTenonTop, vecXS);
		joist.addTool(dc, _kStretchNot);
	}
	else
	{
		dTenonHeight.set(dHeight);
	}
	// DoubleCutTenonSides
	for (int i = 0; i < 2; i++)
	{
		int inv = i == 0 ? 1 : - 1;
		DoubleCut dc(ptShoulderTop + vecYC * inv * (dTenonWidth * .5), vecYC * inv , ptShoulderTop, vecXS);
		joist.addTool(dc, _kStretchNot);
	}//next index
	//End DoubleCutTenonHeightAndSides//endregion
	
	//region Trigger DebugAddTools
	if (bDebug)
	{
		String sTriggerDebugAddTools = T("../|DebugAddTools|");
		addRecalcTrigger(_kContext, sTriggerDebugAddTools );
		if (_bOnRecalc && _kExecuteKey == sTriggerDebugAddTools)
		{
			_Entity.append(getEntity(T("|Select tool|")))	;
			setExecutionLoops(2);
			return;
		}
	}
	//End Trigger DebugAddTools//endregion
	
	//region Set Map Value
	String vecName = "vecXc";
	String endPointName = "ptE";
	String subMapxName = "BeamConnectorData";
	
	Map mapX;
	mapX.setVector3d(vecName, vecXC);
	mapX.setPoint3d(vecName, ptE);
	
	_ThisInst.setSubMapX(subMapxName, mapX);
	//End Set Map Value//endregion
	
	//region Set Debug Connected tools
	Entity etools[] = post.eToolsConnected();
	if (bDebug)
	{
		etools.append(_Entity);
		reportMessage("\nNumber of etools: " + etools.length());
	}
	//End Set Debug Connected tools//endregion
	
	//region MiterCut - Other TSL
	//Is there an intersection with the same tsl?
	//What is the angle?, cut by 4mm distance
	//eToolsConnected
	double dDistanceTolerance = U(4);
	for (int i = 0; i < etools.length(); i++)
	{
		//Does other TSL have same map name?
		if (etools[i].subMapXKeys().findNoCase(subMapxName, - 1) < 0) continue;
		
		//Is other TSL valid and not the same is current?
		TslInst tsl = (TslInst)etools[i];
		if ( ! tsl.bIsValid() || _ThisInst == tsl) continue;
		
		//Get other TSL supmapx value
		Vector3d vOtherBeamXC = tsl.subMapX(subMapxName).getVector3d(vecName);
		Point3d ptOtherBeamE = tsl.subMapX(subMapxName).getPoint3d(endPointName);
		
		//Get other TSL Beam
		Beam beams[] = tsl.beam();
		if (beams.length() < 2) continue;
		int iPost = beams.find(post);
		int iJoist = iPost == 0 ? 1 : 0;
		Beam otherBeam = beams[iJoist];
		
		Line(tsl.ptOrg(), otherBeam.vecX()).hasIntersection(Plane(_Pt0, vecYC), ptOtherBeamE);
			
			
		//ptOtherBeamE = Line(tsl.ptOrg(), otherBeam.vecX()).intersect(Plane(_Pt0, vecYC), 0);
		Point3d ptOtherBeamCenterZtoE = tsl.ptOrg();
		ptOtherBeamCenterZtoE.setZ(ptOtherBeamE.Z());
		vOtherBeamXC = ptOtherBeamE - ptOtherBeamCenterZtoE;
		vOtherBeamXC.normalize();
		ptOtherBeamE.vis(3);
		vOtherBeamXC.vis(ptOtherBeamE, 3);
		
		otherBeam.envelopeBody().vis(2);
		
		//Compare height
		double dZOtherBeam = tsl.ptOrg().Z();
		double dZCurrentBeam = _Pt0.Z();
		
		double dHOtherBeam = otherBeam.dH();
		double dHCurrentBeam = joist.dH();
		
		double dMaxIntserSecHeight = dHOtherBeam * .5 + dHCurrentBeam * .5;
		double dLowIntersec = dZCurrentBeam - dMaxIntserSecHeight;
		double dHighIntersec = dZCurrentBeam + dMaxIntserSecHeight;
		
		////////Take into account the height when angled?
		if (dZOtherBeam > dLowIntersec && dZOtherBeam < dHighIntersec)
		{
			if (vecXC.isParallelTo(joist.vecD(vOtherBeamXC)))
			{
				Body bdJoist = joist.envelopeBody();
				bdJoist.addTool(Cut(ptE, vecXC));
//bdJoist.vis(3);
				
				Body bdJoist2 = otherBeam.envelopeBody();
				bdJoist2.addTool(Cut(ptOtherBeamE, vOtherBeamXC));
//bdJoist2.vis(2);
				
				if (bdJoist.hasIntersection(bdJoist2))
				{
					reportMessage("\nIntersects");
					Point3d ptMidPost = _Pt0 + vecXC * (post.dD(vecXC) * .5 - dDistanceTolerance * .5);
//ptMidPost.vis(3);
//ptE.vis(3);
					//if the current input tenon length is smaller then length to post center, do nothing
					if (vecXC.dotProduct(ptE - ptMidPost) > 0)
					{ 
						//ptE = ptMidPost;
						Cut cJoist(ptMidPost, vecXC);
						joist.addTool(cJoist);
						
						//mapX.setPoint3d(vecName, ptMidPost);
						//_ThisInst.setSubMapX(subMapxName, mapX);
					}
				}
			}
			else
			{
				Point3d ptMiter;
				Vector3d vMiter = vecXC + vOtherBeamXC;
				if ( ! Line(_Pt0, vecXC).hasIntersection(Plane(tsl.ptOrg(), otherBeam.vecD(vecXC)), ptMiter)) continue;
				Point3d ptMiter2 = ptMiter + vecZC  * - 1;
				Point3d ptMiter3 = ptMiter + vMiter * - 1;

vMiter.vis(ptMiter, 2);
//ptMiter.vis(2);
//ptMiter2.vis(2);
//ptMiter3.vis(2);

				Plane pnMiter(ptMiter, ptMiter2, ptMiter3);
				
				Point3d ptToPlane = pnMiter.closestPointTo(_Pt0);
ptToPlane.vis(2);
				
				Vector3d vPt02pn = ptToPlane - _Pt0;
				//Vector3d vPt02pn = vMiter.crossProduct(vecZC);
				vPt02pn.normalize();
vPt02pn.vis(ptOtherBeamE, 2);
				
				Point3d ptTrimPos = ptToPlane - vPt02pn * dDistanceTolerance * .5;
ptTrimPos.vis(3);
				Cut cJoist(ptTrimPos, vPt02pn);
				joist.addTool(cJoist);
			}
		}
		tsl.transformBy(Vector3d(0, 0, 0));
	}//next i
	//End  MiterCut - Other TSL//endregion
	
	//region PostSlot
	Point3d ptBottom = lnZ.intersect(pnJoistZ, - .5 * joist.dD(vecZC));
	//ptBottom.vis(1);
	
	double dSlotWidth = dTenonWidth + dTenonWidthExtra;
	
	Line lnSlotEnd(ptE + vecXC * dTenonLengthExtra, vecZC);
	Point3d ptSlotBottomEnd = lnSlotEnd.intersect(pnJoistZ, - .5 * dHeight);
	//ptSlotBottomEnd.vis(1);
	
	double dSlotLength = _X0.dotProduct(ptSlotBottomEnd - ptBottom);
	
	Point3d ptSlotTopEnd = lnSlotEnd.intersect(pnJoistZ, .5 * dHeight - (dHeight - dTenonHeight) + dTenonHeightExtra);
	//ptSlotTopEnd.vis(1);
	
	
	////If Slot vecZ vecZC is used
	//double dSlotHeight = vecZC.dotProduct(ptSlotTopEnd - ptSlotBottomEnd);
	////If Slot vecZ _Z0 is used
	double dSlotHeight = dTenonHeight + dTenonHeightExtra;
	
	Slot slot(ptBottom, _Z0, _Y0, _X0, dSlotHeight, dSlotWidth, dSlotLength, 1, 0, 1);
	//////When beam is angled the dSlotwidh 62 is resulting in drawing as 58,26?
	////////which is gives the slot a smaller width then the tenon
	
	post.addTool(slot);
	//End PostSlot//endregion
	
	//region Drill Hole
	Line lnTenonEnd(ptE, vecZC);
ptE.vis(3);
//	Point3d ptTenonEndCenter = lnTenonEnd.intersect(pnJoistZ, 0);
	Point3d ptDrillOffset = _Pt0 + vecXC * ((vecXC.dotProduct(ptE - _Pt0) - dTenonLengthExtra)*.5 + dPenHeartOffset);
//ptDrillOffset.vis(2);
	Point3d ptDrillPos = Line(ptDrillOffset, vecZC).intersect(pnJoistZ , - .5 * dHeight + dPenHeight);
//ptDrillPos.vis(2);

	// HSB-9322: draw drills
	// direction vector for distribution of drills
	Vector3d vecDrillDistrib = vecYC.crossProduct(vecXS);vecDrillDistrib.normalize();
	if (vecDrillDistrib.dotProduct(vecZC) > 0)vecDrillDistrib *= -1;
vecDrillDistrib.vis(_Pt0);
	
	Point3d ptHoleEnd = ptDrillPos - vecYC * post.dD(vecYC) * .5;
	Point3d ptHoleStart = ptDrillPos + vecYC * post.dD(vecYC) * .5;
	// HSB-9322: 
	if (nNr < 1)nNr.set(1);
	double dDistDrillTot = (nNr - 1) * dPenDistance;
	ptHoleStart -= .5 * dDistDrillTot * vecDrillDistrib;
	ptHoleEnd -= .5 * dDistDrillTot * vecDrillDistrib;
	for (int i = 0; i < nNr; i++)
	{ 
		Point3d pt1 = ptHoleStart + i * dPenDistance * vecDrillDistrib;
		Point3d pt2 = ptHoleEnd + i * dPenDistance * vecDrillDistrib;
		Drill dJoist(pt1, pt2, dPenDepth / 2);
		joist.addTool(dJoist, _kStretchNot);
		post.addTool(dJoist, _kStretchNot);
	}//next i
	
//	Drill dJoist(ptHoleStart, ptHoleEnd, dPenDepth / 2);
//	joist.addTool(dJoist, _kStretchNot);
//	post.addTool(dJoist, _kStretchNot);
	//End Drill Hole//endregion
	
	//HARDWARE
	
	// Hardware//region
	// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
	// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i = hwcs.length() - 1; i >= 0; i--)
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i);
		
		// declare the groupname of the hardware components
		String sHWGroupName;
		// set group name
		{
			// element
			// try to catch the element from the parent entity
			Element elHW = _ThisInst.element();
			// check if the parent entity is an element
			if ( ! elHW.bIsValid())	elHW = (Element)_ThisInst;
			if (elHW.bIsValid()) 	sHWGroupName = elHW.elementGroup().name();
			// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length() > 0)	sHWGroupName = groups[0].name();
		}
	}
	
	// add main componnent
	{
		String sHWArticleNumber = T("|Peg| ") + dPenDepth + "mm X " + post.dD(vecYC) + "mm";
		HardWrComp hwc(sHWArticleNumber, 1); //the articleNumber and the quantity is mandatory
		
		//		hwc.setManufacturer(sHWManufacturer);
		//		hwc.setModel(sHWModel);
		//		hwc.setName(sHWName);
		//		hwc.setDescription(sHWDescription);
		//		hwc.setMaterial(sHWMaterial);
		//		hwc.setNotes(sHWNotes);
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(_ThisInst);
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); //the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(joist.dD(vecYC));
		hwc.setDScaleY(dPenDepth);
		//hwc.setDScaleZ(dHWHeight);
		
		// apppend component to the list of components
		hwcs.append(hwc);
	}
	
	// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);
	_ThisInst.setHardWrComps(hwcs);
	//endregion
	
	//Visualize a ref line
	Display dp(9);
	int iAnchorScale = 25;
	Point3d ptA1 = _Pt0 + _X0 * U(iAnchorScale * 2) - _Z0 * U(iAnchorScale * .5);
	Point3d ptA2 = _Pt0 + _Y0 * U(iAnchorScale);
	Point3d ptA3 = _Pt0 + _X0 * U(iAnchorScale * 2) + _Z0 * U(iAnchorScale * .5);
	Point3d ptA4 = _Pt0 - _Y0 * U(iAnchorScale);
	PLine plTslAnchor1(ptA1, ptA2, ptA3);
	PLine plTslAnchor2(ptA3, ptA4, ptA1);
	PLine plTslAnchor3(ptA2, ptA4);
	dp.draw(plTslAnchor1);
	dp.draw(plTslAnchor2);
	dp.draw(plTslAnchor3);
}
//End toolMode//endregion
else if(nMode == 1)
{
	if(!bDebug)
	{ 
	// create TSL
		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {_Beam[0],_Beam[1]};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
		int nProps[] ={nNr };
		double dProps[]={dShoulder,dPenDepth,dPenHeight,dPenHeartOffset,dPenDistance, dTenonHeight,dTenonHeightExtra,dTenonLength,dTenonLengthExtra,dTenonWidth,dTenonWidthExtra};				
		String sProps[]={};
		Map mapTsl;															//dPenHeartOffset
		for (int i=0;i<_Beam.length();i++) 
		{ 
			gbsTsl[0] = _Beam[i]; 
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
		}//next i
		eraseInstance();
		return;
	}
}
#End
#BeginThumbnail
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
J;EAS/DL?U\7MA;E*.LEP7,I+5KB^01$5281$0!$1`$1$`1$0!$1`?__9


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
        <int nm="BreakPoint" vl="415" />
        <int nm="BreakPoint" vl="404" />
        <int nm="BreakPoint" vl="426" />
        <int nm="BreakPoint" vl="372" />
        <int nm="BreakPoint" vl="376" />
        <int nm="BreakPoint" vl="350" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End