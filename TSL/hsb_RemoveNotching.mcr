#Version 8
#BeginDescription
#Versions:
1.1 05.09.2022 HSB-16424: remove "hsbT-Connection" tsls if found Author: Marsel Nakuci


Modified by: Chirag Sawjani (chirag.sawjani@hsbcad.com
Date: 02.02.2019 - version 1.0


Removes notching between beams in elements
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords Notching,remove
#BeginContents
//region <History>
// #Versions
// 1.1 05.09.2022 HSB-16424: remove "hsbT-Connection" tsls if found Author: Marsel Nakuci

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl creates 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsb_RemoveNotching")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion


if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}

//	if (_kExecuteKey=="")
//		showDialogOnce();

	PrEntity ssE(T("Please select Elements"),Element());
 	if (ssE.go())
	{
 		Entity ents[0];
 		ents = ssE.set();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			Element el = (Element) ents[i];
			if (el.bIsValid())
 				_Element.append(el);
 		 }
 	}
 	
 	return;
}

if (_Element.length()==0)
{
	eraseInstance();
	return;
}
//return
for (int e = 0; e < _Element.length(); e++)
{
	Element el = _Element[e];
		
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0 = csEl.ptOrg();
	
	Beam bmAll[]=el.beam();
	if (bmAll.length()<1)	
	{
		continue;
	}
	
	Plane plElement(csEl.ptOrg(), vz);
	PlaneProfile ppBeams[0];
	//Find the beam responsible for this notch
	for(int s = 0; s < bmAll.length(); s++)
	{ 
		Beam bmCurr = bmAll[s];
		Body body = bmCurr.envelopeBody(FALSE, TRUE);
		PlaneProfile pp = body.shadowProfile(plElement);
		ppBeams.append(pp);
	}
	
	for (int i = 0; i < bmAll.length(); i++)
	{
		Beam bm = bmAll[i];
	// HSB-16424: check for hsbT-Connection tsls
		Entity eConnected[] = bm.eToolsConnected();
		for (int ient=0;ient<eConnected.length();ient++) 
		{ 
			TslInst tsl=(TslInst)eConnected[ient];
			if(tsl.bIsValid() && tsl.scriptName()=="hsbT-Connection")
			{ 
				reportMessage("\n"+scriptName()+" "+T("|hsbT-Connection deleted|"));
				tsl.recalcNow(T("|Reset + Erase|"));
			}
		}//next ient
		
		Cut cuts[] = bm.getToolsStaticOfTypeCut();
		BeamCut beamCuts[] = bm.getToolsStaticOfTypeBeamCut();
		PlaneProfile ppBeamCuts[0];
		for(int b=0; b<beamCuts.length();b++)
		{
			BeamCut beamCut = beamCuts[b];
			PlaneProfile cuttingBodyProfile = beamCut.cuttingBody().shadowProfile(plElement);
			ppBeamCuts.append(cuttingBodyProfile);
		}
				
		AnalysedTool analysedToolsForBeam[] = bm.analysedTools();
		for(int t = 0 ; t < analysedToolsForBeam.length() ; t++)
		{ 
			AnalysedBeamCut tool = (AnalysedBeamCut)analysedToolsForBeam[t];
			if ( ! tool.bIsValid()) continue;
			
			String subType = tool.toolSubType();

			if(subType!=_kABCSeatCut && subType!=_kABCOpenSeatCut)
			{ 
				continue;
			}
			
			Quader analysedToolQuader = tool.quader();
			Point3d analysedToolQuaderPoint = analysedToolQuader.ptOrg();
			analysedToolQuaderPoint = analysedToolQuaderPoint.projectPoint(plElement, 0);
			
			Body toolCuttingBody = tool.cuttingBody();
			PlaneProfile ppCuttingBody = toolCuttingBody.shadowProfile(plElement);
//			ppCuttingBody.vis(1);
			
			int bNotcherFound = FALSE;
			//Find the beam responsible for this notch
			for(int s = 0; s < bmAll.length(); s++)
			{ 
				Beam bmNotcher = bmAll[s];
				PlaneProfile ppBm = ppBeams[s];
				//Ignore if it is this beam as it cannot notch itself
				if (bm == bmNotcher) continue;

				int result = ppBm.intersectWith(ppCuttingBody);
				double intersectionArea = ppBm.area();
				ppBm.vis(1);
				if(result && intersectionArea > U(5) * U(5))
				{ 
					//Intersection exists, stretch this beam to the other.  note the analysed beam cut might be made of multiple beams.
					bNotcherFound = TRUE;
					bmNotcher.stretchStaticTo(bm, TRUE);
//					bm.realBody().vis(s);
//					bmNotcher.realBody().vis(s);
//					int x = 5;
				}
			}
			
			if(bNotcherFound)
			{ 
				//Remove beamcut creating notch
				for(int b=0; b<beamCuts.length();b++)
				{
					BeamCut beamCut = beamCuts[b];
					PlaneProfile ppBeamCut = ppBeamCuts[b];
					
					int result = ppBeamCut.intersectWith(ppCuttingBody);
					if(result && ppBeamCut.area() > U(1) * U(1))
					{ 
						//Found it, remove beam cut.
						ppBeamCut.vis(t);
						bm.removeToolStatic(beamCut);
					}
					
				}
			}
		}
	}
}
return
eraseInstance();
return;

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
      <str nm="Comment" vl="HSB-16424: remove &quot;hsbT-Connection&quot; tsls if found" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="9/5/2022 11:33:06 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End