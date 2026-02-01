#Version 8
#BeginDescription
#Versions:
1.4 04.07.2022 HSB-15824: add option {both} for alignment, add beamcut at female beam when negative gap Author: Marsel Nakuci
tool removal on edge beams honours contact option

#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/// <History>//region
/// #Versions:
// 1.4 04.07.2022 HSB-15824: add option {both} for alignment, add beamcut at female beam when negative gap Author: Marsel Nakuci
/// <version value="1.3" date="23.feb2017" author="thorsten.huck@hsbcad.com"> new option to stretch male beam dynamically, tool cleanup enhanced </version>
/// <version value="1.2" date="22.feb2017" author="thorsten.huck@hsbcad.com"> silent catalog entry based insert supported </version>
/// <version value="1.1" date="22.feb2017" author="thorsten.huck@hsbcad.com"> the positive element x-axis expresses the default view direction of horizontal connections within elements </version>
/// <version value="1.0" date="21.feb2017" author="thorsten.huck@hsbcad.com"> initial, derived from hsbT-Marking 1.2 </version>
/// </History>

/// <insert Lang=en>
/// Select entities, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates halfcuts at t-connections of 2 beams It can be inserted by element or by beam selection set
/// </summary>//endregion
	
	
// constants //region
	U(1,"mm");
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("No"), T("Yes")};
//endregion
	
// Tool	
	category = T("|Tooling|");
	String sSides[] = {T("|Contact face|"), T("|Opposite contact face|"), T("|Z-axis|") , "-" +T("|Z-axis|") };
	
	String sSideName="(A)   " + T("|Side|");	
	PropString sSide(nStringIndex++, sSides, sSideName);	
	sSide.setDescription(T("|Defines the Side|"));
	sSide.setCategory(category);
	// HSB-15824:
	String sAlignments[] = {T("|Left|"), T("|Right|"), T("|Both|")};
	String sAlignmentName="(B)   " + T("|Alignment|");	
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the location of the tool|"));
	sAlignment.setCategory(category);
	
	String sDepthName="(C)   " + T("|Depth|");
	PropDouble dDepth(nDoubleIndex++,U(4), sDepthName);
	dDepth.setDescription(T("|Specifies the depth of the halfcut|"));
	dDepth.setCategory(category);
	
	category = T("|Geometry|");
	String sGapName="(D)   " + T("|Gap|");
	PropDouble dGap(nDoubleIndex++,0, sGapName);
	dGap.setDescription(T("|Specifies wether the marking is allowed on non touching beams|"));	
	dGap.setCategory(category);
	
	String sContactName="(E)   " + T("|Contact|");	
	PropString sContact(nStringIndex++, sNoYes, sContactName,0);	
	sContact.setDescription(T("|Defines wether the tool should stretch the male beam|"));
	sContact.setCategory(category);
	
// 	position inside or outside
	category = T("|Tooling|");
	String sPositionName="(F)   " + T("|Position|");
	String sPositions[]={ T("|Outside|"),T("|Inside|")};
	PropString sPosition(nStringIndex++, sPositions, sPositionName);
	sPosition.setDescription(T("|Defines the Position of the half cut.|"));
	sPosition.setCategory(category);
	
// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		
		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);
		}
		else
			showDialog();
		
		Beam males[0], females[0];
		Element elements[0];
		
	// collect male beams or elements to insert on every connection
		Entity ents[0];
		PrEntity ssE(T("|Select elements and/or beams|"), Beam());
		ssE.addAllowedClass(Element());
		if (ssE.go())
			ents=ssE.set();
		
	// potential male beams
		for (int i=0 ; i < ents.length() ; i++)
		{ 
		    if (ents[i].bIsKindOf(Beam()))
		    	males.append((Beam)ents[i]);
		}
		if(bDebug)reportMessage("\n"+males.length() + " males collected");
		
		for (int i=0 ; i < ents.length() ; i++) 
		{ 
		    Entity ent = ents[i];
		    if (ent.bIsKindOf(Element()))
		    {
		    	Element el = (Element)ent;
		    	elements.append(el);
		    	Beam beams[]=el.beam();
		    // remove any selected beam if part of element
		    	for (int j=males.length()-1; j>=0 ; j--) 
		    	{ 
		    		if (beams.find(males[j])>-1)
		    			males.removeAt(j); 
		    	}
		    }
		}
		if(bDebug)reportMessage("\n"+elements.length() + " elements collected");
		
	// specify creation cylces
		int nNumCreation = elements.length();
		
	// prompt for females if any loose males found
		int nIndexOffset;
		if (males.length()>0)
		{
		// allow male and female selection as  one sset
			females=males;
			if (females.length()>0)
			{
				nNumCreation++;
				nIndexOffset++;
			}
		}
		
	// declare the tslProps
		TslInst tslNew;
		Vector3d vecXU = _XW;
		Vector3d vecYU = _YW;
		GenBeam gbs[0];
		Entity entsTsl[0];
		Point3d ptsTsl[0];
		int nProps[]={};
		double dProps[] ={dDepth,dGap};
		String sProps[]={sSide,sAlignment, sContact,sPosition};
		Map mapTsl;
		
	// loop nNumCreation
		for (int c=0; c<nNumCreation; c++)
		{
			int e = c-nIndexOffset;
			if(males.length()==0 || (males.length()>0 && c>0))
			{
				if(e<0 || e>elements.length()-1)
					continue;
				males = elements[e].beam();
				females = males;	
			}
			for (int i=0; i<males.length(); i++)
			{
				gbs.setLength(0);
				Beam male = males[i];
				if (!male.bIsValid())continue;
				Vector3d vecX = male.vecX();
				Point3d ptCen = male.ptCenSolid();
				gbs.append(male);	
				Beam bmContacts[0];
				bmContacts = male.filterBeamsCapsuleIntersect(females);
				
			// refine contact beams as capsule intersect might also collect beams without a contact	
				Body bdMale(ptCen,vecX,male.vecY(),male.vecZ(),male.solidLength()+2*(dEps+dGap), male.solidWidth(), male.solidHeight(), 0,0,0);
				for (int j=bmContacts.length()-1; j>=0 ; j--) 
				{ 
					Body bd =  bmContacts[j].envelopeBody();
					if(!bd.hasIntersection(bdMale) || vecX.isParallelTo(bmContacts[j].vecX()))
						bmContacts.removeAt(j);
				}
				
				
				if(bDebug)reportMessage("\n"+ scriptName() + " has found stretchTo beams " + bmContacts.length());
	
			// group stretch beams by connection side: this way the female side could have multiple beams
				for(int v=0;v<2;v++)
				{
				// collect females on this side				
					for (int j=bmContacts.length()-1;j>=0; j--)
					{
						Point3d pt = Line(ptCen , vecX).intersect(Plane(bmContacts[j].ptCen(),bmContacts[j].vecD(vecX)),0);
						double d = vecX.dotProduct(pt-ptCen);
						if (((d>0 && v==0) || (d<0 && v==1)) && gbs.find(bmContacts[j])<0)
						{
							gbs.append(bmContacts[j]);
							tslNew.dbCreate(scriptName() , vecXU,vecYU,gbs, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
							gbs.setLength(1);
							//bmContacts.removeAt(j);
						}
	
					}
				}// next v
			}
		}// next c
		eraseInstance();
		return;
	}// END IF on insert_________________________________________________
	
// initial color
	if (_bOnDbCreated)
		_ThisInst.setColor(-1);
	
// properties by index
//	int nAlignment = sAlignments.find(sAlignment)==0?-1:1;
	int nAlignment = sAlignments.find(sAlignment);
	int nSide = sSides.find(sSide);
	int bContact = sNoYes.find(sContact,0);
	int nPosition=sPositions.find(sPosition);
// TriggerFlipSide
	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContext, sTriggerFlipSide);
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide|| _kExecuteKey==sDoubleClick))
	{
		if (nSide==0)nSide=1;
		else if (nSide==1)nSide=0;
		else if (nSide==2)nSide=3;
		else if (nSide==3)nSide=2;
		
		sSide.set(sSides[nSide]);
		setExecutionLoops(2);
		return;
	}
	
// standard T
	Vector3d vecX = _Z1;
	Vector3d vecY = _X1;
	Vector3d vecZ = _Y1;
	Beam bm0 = _Beam[0];
	Beam bm1 = _Beam[1];
	setDependencyOnBeamLength(bm0);
	setDependencyOnBeamLength(bm1);
	
// erase duplicates of t-connections
	Entity tents[] = bm1.eToolsConnected();
	for (int i=0;i<tents.length();i++) 
	{ 
		TslInst tsl = (TslInst)tents[i];
		if (tsl.bIsValid() && tsl.scriptName() == scriptName() && tsl!=_ThisInst && 
			tsl.propString(0) == sSide &&
			tsl.propString(1) == sAlignment)
		{
			Beam beams[] = tsl.beam();
			if (beams.find(bm0)>-1 && beams.find(bm1)>-1)
			{
				reportMessage("\n" + scriptName() + ": " +T("|duplicate will be purged.|"));
				eraseInstance();
				break;
			}
		}
	}
// test t-Connection
	int bHasTConnection = bm0.hasTConnection(bm1, dEps+abs(dGap), true);
// do not accept any dummy connection
	if(bm0.bIsDummy() || bm1.bIsDummy() || (!bHasTConnection && !bContact))
	{
		reportMessage("\n" + scriptName() + ": " +T("|Invalid connection.|"));	
		eraseInstance();
		return;
	}
	Body bd0, bd1=bm1.realBody();
	
// add contact cut
	Cut cut(_Pt0-vecX*dGap, vecX);
	if (bContact)
	{
		bm0.addTool(cut, _kStretchOnToolChange);
	}
// on the event of changing the contact state
	else if (_kNameLastChangedProp == sContactName && !bContact)
	{
		bm0.addToolStatic(cut, 1);
	}
	
	Plane pnRef(_Pt0,vecX);	
	if(nSide==1)pnRef = Plane(_Pt0+vecX*bm1.dD(vecX), vecX);
// set side direction reference vector (what's left and what's right?)
	Vector3d vecDir = vecY;
	
// adjust vecZ if linked to an element
	Element el=bm1.element();
	if (el.bIsValid())
	{
		if (vecX.isParallelTo(el.vecX()))
			vecDir = -el.vecY();
		else
			vecDir = el.vecX();
			
		if (vecZ.isParallelTo(el.vecZ()))
		{
			vecZ = el.vecZ();	
			vecY = vecX.crossProduct(-vecZ);
		}
		assignToElementGroup(el,true,0,'T');
	}
	Vector3d vecSides[]= {-vecX,vecX,vecZ,-vecZ};
	Vector3d vecSide = nSide>-1?vecSides[nSide]:-vecX;
	
	Point3d ptRef = _Pt0+vecZ*vecZ.dotProduct(bm1.ptCenSolid()-_Pt0);
	vecX.vis(ptRef,1);	vecY.vis(ptRef,3);	vecZ.vis(ptRef,150);
//	bm1.envelopeBody().vis(4);
	
// get locations
	Point3d pts[0];
	Vector3d vecN =vecDir.dotProduct(vecY)>0?vecY:-vecY;
	
	int iAlignments[] ={ -1, 1};
	int iPositions[]={ 1,-1};
	// Display
	Display dp(_ThisInst.color());

	for (int iside=0;iside<iAlignments.length();iside++) 
	{ 
		pts.setLength(0);
		if(nAlignment==iside || nAlignment==2)
		{ 
			vecN =vecDir.dotProduct(vecY)>0?vecY:-vecY;
			vecN*=iAlignments[iside];
			
			vecN.vis(ptRef);
		//	vecN*=nAlignment;
			
			// if beams are not perpendicular run extended contact test
			if (!bm0.vecX().isPerpendicularTo(bm1.vecX()))
			{
				bd0 = bm0.realBody();
				PlaneProfile pp0 = bd0.extractContactFaceInPlane(Plane(_Pt0,_Z1), dGap+dEps);
				pp0.vis(2);
				LineSeg seg0 = pp0.extentInDir(vecZ);
				Point3d pts0[]= { seg0.ptStart(), seg0.ptEnd()};
//				Line ln(_Pt0,nAlignment*vecN);
				Line ln(_Pt0,iAlignments[iside]*vecN);
				
				pts0 = ln.orderPoints(ln.projectPoints(pts0));
				
				if (pts0.length()<2)
				{
					reportMessage("\n"+ scriptName() + " " + T("|No location found.|"));
					eraseInstance();
					return;
				}
				
			// project locations to opposite face
				if(nSide==1)
				{
					pts0[0] = Line(pts0[0],_X0).intersect(pnRef,0);
					pts0[1] = Line(pts0[1],_X0).intersect(pnRef,0);
				}
		
			// append to collector
//				if (nAlignment==-1)
				if (iAlignments[iside]==-1)
					pts.append(pts0[0]);
				else
					pts.append(pts0[1]);
			}
			else
			{ 
				Line ln(ptRef,_X0);
				ln.transformBy(bm0.vecD(vecN)*.5*bm0.dD(vecN));
				ln.vis(3);
				Point3d pt = ln.intersect(pnRef,0);
				pts.append(ln.intersect(pnRef,0));
			}
			Point3d ptsLocs[0];
			ptsLocs=pts;
			ptsLocs[0].vis(2);
		// get contact face to validate locations
			PlaneProfile ppFace = bd1.extractContactFaceInPlane(pnRef, dEps);
			ppFace.shrink(-U(3.1));
			ppFace.shrink(U(3.1));
			PLine plRings[] = ppFace.allRings();
			int bIsOp[] = ppFace.ringIsOpening();
			ppFace.removeAllRings();
			for (int r=0;r<plRings.length();r++)
				if (!bIsOp[r])
					ppFace.joinRing(plRings[r],_kAdd);	
			ppFace.vis(6);
			ppFace.vis(1);
		
			LineSeg segFace = ppFace.extentInDir(vecZ);
			Point3d ptsFace[]= { segFace.ptStart(), segFace.ptEnd()};
			for (int i=ptsLocs.length()-1; i>=0 ; i--) 
			{ 
				Point3d pt= ptsLocs[i]; 
				int bRemove=ppFace.pointInProfile(pt)==_kPointOutsideProfile;
				if(!bRemove)
				for (int j=0 ; j<ptsFace.length() ; j++) 
				{ 
				    Point3d ptFace = ptsFace[j]; 
				    if (abs(vecY.dotProduct(ptFace-pt))<dEps)
				    {
				    	bRemove=true;
				    	break;
				    }
				}
		
				if(bRemove)
					ptsLocs.removeAt(i);
			}
			
		// project locations to face
			for (int i=0;i<ptsLocs.length();i++) 
			{ 
				ptsLocs[i].transformBy(vecSide*(vecSide.dotProduct(bm1.ptCenSolid()-ptsLocs[i])+.5*bm1.dD(vecSide)));
			}
			
		// remove if no point found	
			if (!bContact && (ptsLocs.length()<1 || dDepth<dEps))
			{
				if (bDebug)reportMessage("\n" + scriptName() + ": " +T("|could not find any valid tooling location.|") + " " + T("|Tool will be deleted.|"));
				reportMessage("\n"+scriptName()+" "+T("|could not find any valid tooling location.|")+" "+T("|Tool will be deleted.|"));
				eraseInstance();
				return;
			}
			
		// TOOL
			if (ptsLocs.length()>0)
			{
				ptsLocs[0].vis(6);
				HalfCut hc(ptsLocs[0]-vecSide*dDepth, vecN*iPositions[nPosition], -vecSide, true);
				bm1.addTool(hc);
			}
		
		// draw
			for (int i=0 ; i < ptsLocs.length() ; i++) 
			{ 
			    Point3d pt1 = ptsLocs[i]; 
			    PLine pl;
			    if (nSide>1)
			    {
			    	Point3d pt2 = pt1+bm1.vecD(_X0)*bm1.dD(_X0);
			    	pl = PLine(pt1,pt2);
			    }
			    else
			    	pl = PLine(pt1-vecZ*.5*bm1.dD(vecZ),pt1+vecZ*.5*bm1.dD(vecZ));
			    
			    dp.draw(pl);
			    PLine plCirc;
			    plCirc.createCircle(pl.ptMid()+vecN*iPositions[nPosition]*U(3), vecX, U(3));
			    dp.draw(plCirc);
			    //vecSide.vis(pt1,i);
			}
		}
	}//next iside
	
		
// draw contact symbol
	if (bContact)
	{
		double dDiam = bm0.dW()<bm0.dH()?bm0.dW():bm0.dH();
		PLine plCirc;
		plCirc.createCircle(_Pt0, vecX, dDiam*.25);
		dp.draw(plCirc);
		
		if(dGap>dEps)
		{
			Point3d pt = _L0.intersect(pnRef, -dGap);
			plCirc.transformBy(pt-_Pt0);
			dp.draw(plCirc);
			dp.draw(PLine(pt,_Pt0));
		}	
	}


#End
#BeginThumbnail
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
6%`&)%X:A699)KF65E.1FMNBB@#__V7LA
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
        <int nm="BreakPoint" vl="384" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15824: add option {both} for alignment, add beamcut at female beam when negative gap" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="7/4/2022 9:47:49 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End