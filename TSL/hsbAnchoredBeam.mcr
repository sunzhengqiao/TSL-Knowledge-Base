#Version 8
#BeginDescription
version value="1.1" date="26aug2020" author="geoffroy.cenni@hsbcad.com"> optimized for vertical joists

This tsl creates a tenon connection between a joist and a post.
#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords post;joist;double cut;distributed slot;tenon
#BeginContents
/// <History>//region
/// <version value="1.1" date="26aug2020" author="geoffroy.cenni@hsbcad.com"> optimized for vertical joists </version>
/// <version value="1.0" date="25may2020" author="geoffroy.cenni@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// Dialog: Input Chamfer Width
/// Dialog: Input Shoulder Width
/// Dialog: Input Slot Amount
/// Dialog: Input Slot Depth in Pole
/// Dialog: Input Slot Width and Height
/// Dialog: Input Tenon Width
/// Dialog: Input Tenon Length
/// Dialog: Input Tenon Height Tolerance
/// Dialog: Input Tenon Width Tolerance
/// Select Joist
/// Select Post
/// </insert>

/// <summary Lang=en>
/// This tsl creates a tenon connection between a joist and a post.
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbAnchoredBeam")) TSLCONTENT

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

//region PROPERTIES	
//region Props General
	//G
	String sChamferWidthName=T("|Chamfer Width|");	
	PropDouble dChamferWidth(nDoubleIndex++, U(57), sChamferWidthName);	
	dChamferWidth.setDescription(T("|Defines the Chamfer Width|"));
	dChamferWidth.setCategory(category);
	//A
	String sShoulderName=T("|Shoulder Width|");	
	PropDouble dShoulder(nDoubleIndex++, U(30), sShoulderName);	
	dShoulder.setDescription(T("|Defines the Shoulder Width|"));
	dShoulder.setCategory(category);
//End Props General//endregion 
//region Props Slot
	category = T("|Slot|");
	//Amount of locks
	String sLocksAmountName=T("|Amount|");	
	int nLocksAmounts[]={1,2,3,4};
	PropInt nLocksAmount(nIntIndex++, nLocksAmounts, sLocksAmountName);	
	nLocksAmount.setDescription(T("|Defines the Amount|"));
	nLocksAmount.setCategory(category);
	//E
	String sLocksExtraDepthName=T("|Depth in Post|");	
	PropDouble dLocksExtraDepth(nDoubleIndex++, U(10), sLocksExtraDepthName);	
	dLocksExtraDepth.setDescription(T("|Defines the Depth in Post|"));
	dLocksExtraDepth.setCategory(category);
	//D
	String sLocksWidthHeightName=T("|Width and Height|");	
	PropDouble dLocksWidthHeight(nDoubleIndex++, U(40), sLocksWidthHeightName);	
	dLocksWidthHeight.setDescription(T("|Defines the Width and Height|"));
	dLocksWidthHeight.setCategory(category);
//End Props Slot//endregion 
//region Props Tenon
	category = T("|Tenon|");
	//1 Height Tenon
	String sTenonHeightName=T("|Height|");	
	PropDouble dTenonHeight(nDoubleIndex++, U(180), sTenonHeightName);	
	dTenonHeight.setDescription(T("|Defines the Height|"));
	dTenonHeight.setCategory(category);
	//Width of Tenon
	String sTenonWidthName=T("|Width|");	
	PropDouble dTenonWidth(nDoubleIndex++, U(60), sTenonWidthName);	
	dTenonWidth.setDescription(T("|Defines the Width|"));
	dTenonWidth.setCategory(category);
	//F
	String sTenonLengthName=T("|Length|");	
	PropDouble dTenonLength(nDoubleIndex++, U(360), sTenonLengthName);	
	dTenonLength.setDescription(T("|Defines the Length|"));
	dTenonLength.setCategory(category);
	//C
	String sTenonHeightExtraName=T("|Height Tolerance|");	
	PropDouble dTenonHeightExtra(nDoubleIndex++, U(2), sTenonHeightExtraName);	
	dTenonHeightExtra.setDescription(T("|Defines the Height Tolerance|"));
	dTenonHeightExtra.setCategory(category);
	//Extra Width of Tenon
	String sTenonWidthExtraName=T("|Width Tolerance|");	
	PropDouble dTenonWidthExtra(nDoubleIndex++, U(2), sTenonWidthExtraName);	
	dTenonWidthExtra.setDescription(T("|Defines the Width Tolerance|"));
	dTenonWidthExtra.setCategory(category);
//End Props Tenon//endregion 
//End PROPERTIES//endregion 


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
		
		_Beam.append(getBeam(T("|Please select joist|")));
		_Beam.append(getBeam(T("|Please select post|")));
			
		return;
	}	
// end on insert	__________________//endregion

//region LOCAL PROPS

	//check - If joist connection is not parallel to post from top view exit
	if(_X0.dotProduct(_Y1) > U(10e-5))
	{ 
		reportMessage("\nSelected post and joist are not perpendicular.");
		eraseInstance();
		return;
	}
	
	//Easy local var
	Beam joist = _Beam[0];
	Beam post = _Beam[1];
	Point3d ptCen0 = joist.ptCenSolid();
	
//Visualise vectors from Joist & Post
_X0.vis(ptCen0, 1);
_Y0.vis(ptCen0, 3);
_Z0.vis(ptCen0, 150);

_X1.vis(_Beam[1].ptCen(), 1);
_Y1.vis(_Beam[1].ptCen(), 3);
_Z1.vis(_Beam[1].ptCen(), 150);
	
	//Set the local Vector Connection Set
	Vector3d vecZC = _X1;
	Vector3d vecXC = _Z1;
	
	//Check Post Vertical direction (_X1), if not equal to _ZW invert
	if(vecZC.dotProduct(_ZW) < 0)
		vecZC *= -1;
	
	Vector3d vecYC = vecZC.crossProduct(vecXC);

vecXC.vis(_Pt0, 1);
vecYC.vis(_Pt0, 3);
vecZC.vis(_Pt0, 150);

	double dHeight = joist.dD(vecZC);
	double dWidth= joist.dD(vecYC);
	
	Plane pnJoistZ(ptCen0, joist.vecD(vecZC));
	Line lnZ(_Pt0, vecZC);
	
pnJoistZ.vis(4);
_Pt0.vis(2);
//End LOCAL PROPS//endregion 

//region ExtendBeam
	//Get position of Extended Point
	Point3d ptE = _Pt0 + _X0 * dTenonLength;
//ptE.vis(2);
	//Extend cut beam to extension point
	Cut ctExtend(ptE, vecXC);
	joist.addTool(ctExtend, _kStretchOnToolChange);
//End ExtendBeam//endregion 

//region Does Post And Joist Align ?
	//Get intersection point Center-Center
	Point3d ptCenCen = _Pt0 + _X0 * ( post.dD(vecXC) / 2);
//ptCenCen.vis(2);
	
	//set up intersection box
	Body bdIntrSectBox(ptCenCen,_X0,_Y0,_Z0, U(10e4),joist.dD(_Y0),joist.dD(_Z0));
	bdIntrSectBox.addTool(Cut(_Pt0, - vecXC), 0);
	bdIntrSectBox.addTool(Cut(_Pt0 + vecXC * post.dD(vecXC), vecXC), 0);
//bdIntrSectBox.vis(2);

	//get post envelop
	Body bdPost = post.envelopeBody();
	
	// compare if bodies intersect
	if (bdPost.hasIntersection(bdIntrSectBox))
	{
 		bdPost.intersectWith(bdIntrSectBox); // replace bd by intersection body

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
	Point3d ptShoulderTop = lnZ.intersect(pnJoistZ, .5*dHeight);//_Pt0 + vecZC * (dHeight * .5);
//ptShoulderTop.vis(2);
	Point3d ptShoulderBottom =  Line(_Pt0+vecXC*dShoulder, vecZC).intersect(pnJoistZ, -.5*dHeight);// + vecXC * dShoulder;
	ptShoulderBottom.vis(2);
	
	Vector3d vecZS = ptShoulderTop - ptShoulderBottom;
	vecZS.normalize();
vecZS.vis(ptShoulderTop, 1);

	Vector3d vecXS = vecYC.crossProduct(vecZS);
//vecXS.vis(ptShoulderTop, 1);
	
	Vector3d vShoulderBottom = joist.vecD(vecZC);	
//vShoulderBottom.vis(ptShoulderBottom, 2);

	DoubleCut dcShoulder(ptShoulderBottom, joist.vecD(vecZC), ptShoulderBottom, -vecXS);
	post.addTool(dcShoulder, _kStretchNot);
//End DoubleCutShoulder//endregion 

//region DoubleCutTenonHeightAndSides
	if (dTenonHeight < dHeight)
	{ 
		Line ln(ptShoulderBottom,vecZS);
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
	for (int i = 0; i < 2; i++)
	{
		int inv = i == 0 ? 1 : - 1;
		//region Chamfer
		
		Line lnTenonEnd(_Pt0 + _X0 * dTenonLength,vecZC);
//lnTenonEnd.vis(4);
		
		Point3d ptE = lnTenonEnd.intersect(pnJoistZ, -.5 * dHeight + .5 * dTenonHeight);
ptE.vis(4);
		
		//set point
		Point3d ptCH = ptE + vecZC * inv * ((dHeight * .5) - dChamferWidth); //* ((_H0 * .5) - dChamfDist)
		ptCH.vis(2);
		//set vector
		Vector3d vecCH = _X0 + vecZC * inv;
		vecCH.vis(ptCH, 150);
		//cut
		Cut ctCH(ptCH, vecCH);
		joist.addTool(ctCH, _kStretchNot);
		//End Chamfer//endregion
		
		//region DoubleCutTenonSides
		DoubleCut ctTS(ptShoulderTop + vecYC * inv * (dTenonWidth * .5), vecYC * inv , ptShoulderTop, vecXS);
		//DoubleCut ctTS(ptShoulderBottom + _Y0 * inv * (dTenonWidth * .5), _Y0 * inv , ptShoulderBottom, - vecZS);
		joist.addTool(ctTS, _kStretchNot);
		//End DoubleCutTenonSides//endregion
	}//next index

//End DoubleCutTenonHeightAndSides//endregion

//region PostSlot
	Line lnPostEnd(_Pt0 + vecXC * post.dD(vecXC),vecZC);
lnPostEnd.vis(2);
	Point3d ptSlot = lnPostEnd.intersect(pnJoistZ, - .5 * dHeight);
	//Point3d ptSlot = _Pt0 - vecZC * joist.dH() * .5 + vecXC * dZSlot + vecYC * dTenonWidthExtra * .5;
ptSlot.vis(2);
	double dZSlot = abs(_X0.dotProduct(_Pt0 - ptSlot)); // joist.dD(vecXC);
if (bDebug) reportMessage("\n dZSlot: " + dZSlot);
	Slot slot(ptSlot, joist.vecD(vecZC), vecYC, -_X0, dTenonHeight + dTenonHeightExtra, dTenonWidth + dTenonWidthExtra, dZSlot *2, 1, 0, 1);
slot.cuttingBody().vis(4);
	post.addTool(slot);
//End PostSlot//endregion 

//region CutLocks
	//Set point on Pole Exterior
	Point3d ptPext = _Pt0 + vecXC * post.dD(vecXC);
//ptPext.vis(2);
	
	//Set start point distribution
	Line lnDistriEnd(_Pt0 + vecXC * (post.dD(vecXC) - dLocksExtraDepth),vecZC);
	Point3d ptDistriEnd = lnDistriEnd.intersect(pnJoistZ, - .5 * dHeight + 1.5*dLocksWidthHeight);
ptDistriEnd.vis(2);
	Point3d ptDistriStrt = lnDistriEnd.intersect(pnJoistZ, - .5 * dHeight + dTenonHeight - 1.5*dLocksWidthHeight);
ptDistriStrt.vis(2);
	
	//Set total height of distri
	double dMaxLockHeight = dTenonHeight - dLocksWidthHeight * 2;
	
	//how many locks fit
	double dMaxCount = dMaxLockHeight / dLocksWidthHeight;
	int iMaxLock = dMaxCount;
	double dMaxLockDistrInBetween;
	if(iMaxLock > 1)
	{ 
		dMaxLockDistrInBetween = ( dMaxLockHeight - dLocksWidthHeight * iMaxLock ) / ( iMaxLock - 1 );
		
		while(dMaxLockDistrInBetween < dLocksWidthHeight / 2)
		{ 
			iMaxLock--;
			
			if(iMaxLock == 1)
				break;
				
			dMaxLockDistrInBetween = ( dMaxLockHeight - dLocksWidthHeight * iMaxLock ) / ( iMaxLock - 1 );
		}
	}
	if (iMaxLock == 0 && dTenonHeight >= dLocksWidthHeight * 3)
	{
		iMaxLock = 1;
	}
	
	if (iMaxLock > 0)
	{
		if (iMaxLock < nLocksAmount)
		{
			reportMessage("\n" + scriptName() + T(" : |Maximum allowed locks for current height is: |") + iMaxLock);
			nLocksAmount.set(iMaxLock);
			setExecutionLoops(2);
			return;
		}
		
		//Calculate all lock position
		if (nLocksAmount == 1)
		{
			//center
			Point3d pntCntr = lnDistriEnd.intersect(pnJoistZ, -.5 * dHeight + .5 * dTenonHeight);
pntCntr.vis(2);
			Slot slCtLck(pntCntr, vecZC, vecXC, vecYC, dLocksWidthHeight , dLocksWidthHeight + dLocksExtraDepth, dTenonWidth, 0, 1, 1);
			joist.addTool(slCtLck);
		}
		else
		{
			//Set distribution height
			double dDistriLockHeight = ( dMaxLockHeight - dLocksWidthHeight * nLocksAmount ) / ( nLocksAmount - 1 ) + dLocksWidthHeight;
			
			for (double i = 0; i <= dMaxLockHeight; i = i + dDistriLockHeight)
			{
				Point3d ptDstr = ptDistriStrt - vecZC * i;
				Slot slCtLck(ptDstr, vecZC, vecXC, vecYC, dLocksWidthHeight , dLocksWidthHeight + dLocksExtraDepth, dTenonWidth, 0, 1, 1);
				joist.addTool(slCtLck);
			}//next i
		}
	}
//End CutLocks//endregion 

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
			Element elHW =_ThisInst.element(); 
			// check if the parent entity is an element
			if (!elHW.bIsValid())	elHW = (Element)_ThisInst;
			if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
		// loose
			else
			{
				Group groups[] = _ThisInst.groups();
				if (groups.length()>0)	sHWGroupName=groups[0].name();
			}		
		}
		
	// add main componnent
		{ 
			String sHWArticleNumber = T("|Lock| ") + dLocksWidthHeight + "mm X " + dLocksWidthHeight + "mm";
			HardWrComp hwc(sHWArticleNumber, nLocksAmount); // the articleNumber and the quantity is mandatory
			
//			hwc.setManufacturer("zgdszg");
//			hwc.setModel(sHWModel);
//			hwc.setName(sHWName);
//			hwc.setDescription(sHWDescription);
//			hwc.setMaterial(sHWMaterial);
//			hwc.setNotes(sHWNotes);
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(_ThisInst);	
			hwc.setCategory(T("|Connector|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
//			hwc.setDScaleX(dHWLength);
//			hwc.setDScaleY(dHWWidth);
//			hwc.setDScaleZ(dHWHeight);
			
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
Point3d ptA1 = _Pt0 + _X0 * U(iAnchorScale*2) - _Z0 * U(iAnchorScale*.5);
Point3d ptA2 = _Pt0 + _Y0 * U(iAnchorScale);
Point3d ptA3 = _Pt0 + _X0 * U(iAnchorScale*2) + _Z0 * U(iAnchorScale*.5);
Point3d ptA4 = _Pt0 - _Y0 * U(iAnchorScale);
PLine plTslAnchor1(ptA1, ptA2, ptA3);
PLine plTslAnchor2(ptA3, ptA4, ptA1);
PLine plTslAnchor3(ptA2, ptA4);
dp.draw(plTslAnchor1);
dp.draw(plTslAnchor2);
dp.draw(plTslAnchor3);
#End
#BeginThumbnail
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
<_P!VE\OS//****^P/E@HHHH`****`"BBB@#_V0``



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
        <int nm="BREAKPOINT" vl="307" />
      </lst>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End