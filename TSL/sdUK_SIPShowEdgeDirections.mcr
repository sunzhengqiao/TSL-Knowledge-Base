#Version 8
#BeginDescription
Shows the edge direction which is associated with edge details from sdUK_SIPShowEdgeDetails

#Versions
1.2 21.01.2021
HSB-10404 accepts alos panels which are not linked to an element



#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
// #Versions
// 1.2 21.01.2021 HSB-10404 accepts alos panels which are not linked to an element


/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2012 by
*  hsbSOFT 
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
* Created by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 13.07.2012 
* version 1.0: Release
*
* Modified by: Chirag Sawjani
* date: 11.06.2015
* version 1.1: Modified coordsys due to change in Sip coordsys from 19.1.104
*/
	
	Unit(1,"mm");
	double dEps = U(0.001);
	Sip sip;
	if (_Sip.length()>0)
		sip= _Sip[0]; // would be valid if added to a sip in the drawing
	if (!sip.bIsValid() && _Entity.length()>0)
		sip= (Sip)_Entity[0]; // when the shopdraw engine calls this Tsl, the _Entity array contains the Beam
		
	if (!sip.bIsValid()) {
		reportMessage("\n"+scriptName() +": " + T("|No Sip found. Instance erased.|"));
		eraseInstance();
		return;
	}
	
	Vector3d vecX=sip.vecX();
	Vector3d vecY=sip.vecY();
	Vector3d vecZ=sip.vecZ();
	Point3d ptCen = sip.ptCenSolid();
	PLine plOpenings[]=sip.plOpenings();
	double dZ=sip.dH();
	
	Vector3d vecXViews[] = {vecX,-vecZ,vecZ};
	Vector3d vecYViews[] = {vecY,vecX,vecY};	
	
	
	Element el=sip.element();
	if (el.bIsValid())
	{ 
		Vector3d vecXE=el.vecX();
		Vector3d vecYE=el.vecY();
		Vector3d vecZE=el.vecZ();
		
		Vector3d _vecXViews[] = {vecXE,-vecZE,vecZE};
		Vector3d _vecYViews[] = {vecYE,vecXE,vecYE};		
	}


	String strParentKey = String("Dim "+scriptName());


// loop viewing directions	
	for (int v=0;v<vecXViews.length();v++)
	{		
		Vector3d vecXView,vecYView,vecZView;
		vecXView = vecXViews[v];
		vecYView = vecYViews[v];
		vecZView = vecXView.crossProduct(vecYView);
		
			// flag if seen in vecZView
		int bIsNormal;
		if (vecZView.isParallelTo(sip.vecZ()))
			bIsNormal = true;
		
		
		if(bIsNormal)
		{
			//Get all the sip edges
			SipEdge spEdges[]=sip.sipEdges();
			//reportMessage("\n" +scriptName() + " "+ spEdges.length() + " in view " + vecZView);
			for(int s=0;s<spEdges.length();s++)
			{
				SipEdge edge=spEdges[s];
				
					//Get the centre point of the vertex
				Point3d ptStart=edge.ptStart();
				Point3d ptEnd=edge.ptEnd();
				Point3d ptMid=edge.ptMid();
				
				Vector3d vecN = edge.vecNormal();
				vecN .vis(ptMid);
				Vector3d vecVertex=ptEnd-ptStart;
				vecVertex.normalize();
				Vector3d vecVertexNorm=vecVertex.crossProduct(vecZView);
				
				String sRecessDepth;
				sRecessDepth.formatUnit(edge.dRecessDepth(),2,0);
				
				String sDetailReference="E"+(s+1);
				
				//DimRequestText dr(strParentKey ,sRecessDepth, edge.ptMid(),vecXView,vecYView);
				//dr.addAllowedView(vecZView, TRUE);
				//dr.setStereotype("Edge");
				//addDimRequest(dr);
				
				// calc bevel.
				Vector3d vecRef = -vecZ.crossProduct(vecN);
				vecRef.vis(ptMid);
				double dBevelAngle = abs(-vecZ.angleTo(vecN));
				double dBevelAngleQ1;
		
				if(dBevelAngle>90 && dBevelAngle<=180)
				{
					dBevelAngleQ1=90-abs(dBevelAngle-180);
				}
				else
				{
					dBevelAngleQ1=90-abs(dBevelAngle);		
				}

				
				double dOffsetDistance=edge.dRecessDepth()+U(70);
				if(dBevelAngleQ1<89.9 && dBevelAngleQ1>0.2)
				{
					dOffsetDistance=(dZ*tan(dBevelAngleQ1));
				}
				
				//reportNotice("\n"+dBevelAngle );		
				//reportNotice("\n"+sDetailReference);
				//reportNotice("\n"+dBevelAngleQ1);				
				//reportNotice("\n"+dOffsetDistance+"\n");
				Plane plSip(sip.ptCen(),vecZView);
				Body bdSip=sip.envelopeBody(false,true);
				PlaneProfile ppSip=bdSip.shadowProfile(plSip);
				
				Point3d ptEdgeDetail=ptMid-(dOffsetDistance+U(100))*vecVertexNorm;
				Point3d ptStartPoint=ptMid-dOffsetDistance*vecVertexNorm;
				if(ppSip.pointInProfile(ptStartPoint)==_kPointOutsideProfile)
				{
					ptEdgeDetail=ptMid+(dOffsetDistance+U(100))*vecVertexNorm;
					ptStartPoint=ptMid+dOffsetDistance*vecVertexNorm;
				}
				
				DimRequestText dr(strParentKey ,sDetailReference, ptEdgeDetail,vecXView,vecYView);
				dr.addAllowedView(vecZView, TRUE);
				dr.setShowLeaderLine(FALSE); 
				dr.setStereotype("Edge");
				addDimRequest(dr);
				
				PLine plArrow(vecYView);
				plArrow.addVertex(ptStartPoint);
				plArrow.addVertex(ptStartPoint+U(100)*vecVertex);
				plArrow.addVertex(ptStartPoint+U(70)*vecVertex+U(30)*vecVertexNorm);
				plArrow.addVertex(ptStartPoint+U(70)*vecVertex-U(30)*vecVertexNorm);
				plArrow.addVertex(ptStartPoint+U(100)*vecVertex);
				
				DimRequestPLine drPl(strParentKey ,plArrow,3);
				
				drPl.addAllowedView(vecZView, TRUE);
				drPl.setStereotype("Edge");
				drPl.setLineType("ByBlock");
				addDimRequest(drPl);
				
			}
			
			/*
			//Add text at centre of panel for size
			double dSipWidth=sip.dL();
			double dSipHeight=sip.dW();
			String sSipWidth;
			String sSipHeight;
			sSipWidth.formatUnit(dSipWidth,2,1);
			sSipHeight.formatUnit(dSipHeight,2,1);
			
			String sSipName=sip.label()+sip.subLabel();
	
			DimRequestText drName(strParentKey ,sSipName, ptCen,vecXView,vecYView);
			drName.addAllowedView(vecZView, TRUE); 
			drName.setShowLeaderLine(FALSE); 
			addDimRequest(drName);
			
			DimRequestText dr(strParentKey+"1" ,sSipWidth+"x"+sSipHeight, ptCen-vecYView*U(100),vecXView,-vecYView);
			dr.addAllowedView(vecZView, TRUE); 
			dr.setShowLeaderLine(FALSE); 
			addDimRequest(dr);
			*/
			
			

		}
	}



#End
#BeginThumbnail





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
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10404 accepts alos panels which are not linked to an element" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="1/21/2021 8:52:26 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End