#Version 8
#BeginDescription
#Versions
V0.1 08/03/2022 Tsl to create multiple rows of blocking in walls at specified elevation

• Top level group of walls needs to have correct equivalent story to be set. Ex. F1//Exterior set to 1 and  F3//Exterior set to 3
• During insert if you choose “Equivalent Story” -1  then it will allow you to select walls manually
• Blocking Height is in wall height direction and Width  in wall thickness direction. If blocking Width is set to 0 then it will use wall thickness
• Property Minimum blocking length specifies below which length it will not create a block
• TSL will be place into the group Helpful//Blocking Controls so you can turn on/off it’s display which draws how many walls at which equivalent story is assign to TSL as well as highlights blockings it created
• During insertion option Remove blockings not created by TSL will erase all existing blockings in the walls before creating its own
• After insertion if you can recreate blockings by using Regenerate Blocking Beams command from r-click menu
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 1
#KeyWords 
#BeginContents
Unit(1, "inch"); //TODO: metric support

String arFaces[]    = { T("Front"), T("Back"), T("Front and Back"), T("Middle")};	
int    arOffstZ[]   = { 1,			-1,		   1,					0};
String arStagger[] 	= { T("None"), T("Half height"), T("Full height"), T("Custom")};
double arKstagger[] = { 0, 		   0.5, 			 1.0, 			   1.0};
String arYN[]       = { T("Yes"),  T("No")};

Group gps[] = Group().allElementGroups();
String arsStories[0];
for (int i=0; i<gps.length(); i++) {
	Group gp = gps[i];
	int iStory = Group(gp.namePart(0) + "\\" + gp.namePart(1)).nEquivalentStory();
	String sStory = String().format("%03i", iStory);
	if (arsStories.find(sStory)<0) arsStories.append(sStory);
}
arsStories = arsStories.sorted();
int ariStories[0];
for (int i=0; i<arsStories.length(); i++){
	ariStories.append(arsStories[i].atoi());
}
if (!ariStories.length()) 
	ariStories.append(0);
ariStories.insertAt(0, - 1);

int ipi, ipd, ips;

PropInt	   piStory			(ipi++, ariStories, T("Equivalent story"));
PropDouble pdMinLen			(ipd++, U(4), 		T("Minimum blocking length"));
PropString psRemoveExisting (ips++, arYN, 		T("Remove blockings not created by this TSL"));

PropInt    piAmount1		(ipi++, 0, 			T("Amount"));                   	   piAmount1.setCategory(T("Blocking 1"));	
PropDouble pdHeightPos1		(ipd++, U(0), 		T("Height position"));          	pdHeightPos1.setCategory(T("Blocking 1"));	
PropDouble pdHeight1		(ipd++, U(0), 		T("Height"));                   	   pdHeight1.setCategory(T("Blocking 1"));	
PropDouble pdWidth1			(ipd++, U(0), 		T("Width"));                    		pdWidth1.setCategory(T("Blocking 1"));	
PropString psFace1			(ips++, arFaces, 	T("Wall face"), 2);             	     psFace1.setCategory(T("Blocking 1"));	
PropDouble pdGap1			(ipd++, U(0), 		T("Gap"));								  pdGap1.setCategory(T("Blocking 1"));
PropString psStagger1		(ips++, arStagger, 	T("Stagger"), 	0);             	  psStagger1.setCategory(T("Blocking 1"));	
PropDouble pdStaggerCustom1	(ipd++, U(0), 		T("Custom stagger height"));	pdStaggerCustom1.setCategory(T("Blocking 1"));	

PropInt    piAmount2		(ipi++, 0, 			T("Amount"));                   	   piAmount2.setCategory(T("Blocking 2"));	
PropDouble pdHeightPos2		(ipd++, U(0), 		T("Height position"));          	pdHeightPos2.setCategory(T("Blocking 2"));	
PropDouble pdHeight2		(ipd++, U(0), 		T("Height"));                   	   pdHeight2.setCategory(T("Blocking 2"));	
PropDouble pdWidth2			(ipd++, U(0), 		T("Width"));                    		pdWidth2.setCategory(T("Blocking 2"));	
PropString psFace2			(ips++, arFaces, 	T("Wall face"), 2);             	     psFace2.setCategory(T("Blocking 2"));	
PropDouble pdGap2			(ipd++, U(0), 		T("Gap"));								  pdGap2.setCategory(T("Blocking 2"));
PropString psStagger2		(ips++, arStagger, 	T("Stagger"), 	0);             	  psStagger2.setCategory(T("Blocking 2"));	
PropDouble pdStaggerCustom2	(ipd++, U(0), 		T("Custom stagger height"));	pdStaggerCustom2.setCategory(T("Blocking 2"));	

PropInt    piAmount3		(ipi++, 0, 			T("Amount"));                   	   piAmount3.setCategory(T("Blocking 3"));	
PropDouble pdHeightPos3		(ipd++, U(0), 		T("Height position"));          	pdHeightPos3.setCategory(T("Blocking 3"));	
PropDouble pdHeight3		(ipd++, U(0), 		T("Height"));                   	   pdHeight3.setCategory(T("Blocking 3"));	
PropDouble pdWidth3			(ipd++, U(0), 		T("Width"));                    		pdWidth3.setCategory(T("Blocking 3"));	
PropString psFace3			(ips++, arFaces, 	T("Wall face"), 2);             	     psFace3.setCategory(T("Blocking 3"));	
PropDouble pdGap3			(ipd++, U(0), 		T("Gap"));								  pdGap3.setCategory(T("Blocking 3"));
PropString psStagger3		(ips++, arStagger, 	T("Stagger"), 	0);             	  psStagger3.setCategory(T("Blocking 3"));	
PropDouble pdStaggerCustom3	(ipd++, U(0), 		T("Custom stagger height"));	pdStaggerCustom3.setCategory(T("Blocking 3"));

PropInt    piAmount4		(ipi++, 0, 			T("Amount"));                   	   piAmount4.setCategory(T("Blocking 4"));	
PropDouble pdHeightPos4		(ipd++, U(0), 		T("Height position"));          	pdHeightPos4.setCategory(T("Blocking 4"));	
PropDouble pdHeight4		(ipd++, U(0), 		T("Height"));                   	   pdHeight4.setCategory(T("Blocking 4"));	
PropDouble pdWidth4			(ipd++, U(0), 		T("Width"));                    		pdWidth4.setCategory(T("Blocking 4"));	
PropString psFace4			(ips++, arFaces, 	T("Wall face"), 2);             	     psFace4.setCategory(T("Blocking 4"));	
PropDouble pdGap4			(ipd++, U(0), 		T("Gap"));								  pdGap4.setCategory(T("Blocking 4"));
PropString psStagger4		(ips++, arStagger, 	T("Stagger"), 	0);             	  psStagger4.setCategory(T("Blocking 4"));	
PropDouble pdStaggerCustom4	(ipd++, U(0), 		T("Custom stagger height"));	pdStaggerCustom4.setCategory(T("Blocking 4"));	

PropInt    piAmount5		(ipi++, 0, 			T("Amount"));                   	   piAmount5.setCategory(T("Blocking 5"));	
PropDouble pdHeightPos5		(ipd++, U(0), 		T("Height position"));          	pdHeightPos5.setCategory(T("Blocking 5"));	
PropDouble pdHeight5		(ipd++, U(0), 		T("Height"));                   	   pdHeight5.setCategory(T("Blocking 5"));	
PropDouble pdWidth5			(ipd++, U(0), 		T("Width"));                    		pdWidth5.setCategory(T("Blocking 5"));	
PropString psFace5			(ips++, arFaces, 	T("Wall face"), 2);             	     psFace5.setCategory(T("Blocking 5"));	
PropDouble pdGap5			(ipd++, U(0), 		T("Gap"));								  pdGap5.setCategory(T("Blocking 5"));
PropString psStagger5		(ips++, arStagger, 	T("Stagger"), 	0);             	  psStagger5.setCategory(T("Blocking 5"));	
PropDouble pdStaggerCustom5	(ipd++, U(0), 		T("Custom stagger height"));	pdStaggerCustom5.setCategory(T("Blocking 5"));

PropInt    piAmount6		(ipi++, 0, 			T("Amount"));                   	   piAmount6.setCategory(T("Blocking 6"));	
PropDouble pdHeightPos6		(ipd++, U(0), 		T("Height position"));          	pdHeightPos6.setCategory(T("Blocking 6"));	
PropDouble pdHeight6		(ipd++, U(0), 		T("Height"));                   	   pdHeight6.setCategory(T("Blocking 6"));	
PropDouble pdWidth6			(ipd++, U(0), 		T("Width"));                    		pdWidth6.setCategory(T("Blocking 6"));	
PropString psFace6			(ips++, arFaces, 	T("Wall face"), 2);             	     psFace6.setCategory(T("Blocking 6"));	
PropDouble pdGap6			(ipd++, U(0), 		T("Gap"));								  pdGap6.setCategory(T("Blocking 6"));
PropString psStagger6		(ips++, arStagger, 	T("Stagger"), 	0);             	  psStagger6.setCategory(T("Blocking 6"));	
PropDouble pdStaggerCustom6	(ipd++, U(0), 		T("Custom stagger height"));	pdStaggerCustom6.setCategory(T("Blocking 6"));	

String sDeleteMe = T("Erase This Instance and Beams");
addRecalcTrigger(_kContextRoot, sDeleteMe);
if (_bOnRecalc && _kExecuteKey==sDeleteMe) {
	if (_Beam.length()) {
		for (int i=_Beam.length()-1; i>-1; i--) {
			Beam bm = _Beam[i];
			bm.dbErase();
		}
	}
	eraseInstance();
	return;
}
addRecalcTrigger(_kContextRoot, "-=-=-=-=-=-=-=-=-");

if (_bOnInsert) {
	if (insertCycleCount()>1) {
		eraseInstance();
		return;
	}
	showDialog();
	if (piStory == -1) {
		PrEntity pre(T("\n Select walls to assign blocking to"), ElementWall());
		if (pre.go()) _Element.append(pre.elementSet().filterValid());
	}
	else {
		for (int i=0; i<gps.length(); i++) {
			Group gp = gps[i];
			if (Group(gp.namePart(0) + "\\" + gp.namePart(1)).nEquivalentStory() != piStory) continue;
			Element el = gp.elementLinked();
			if (el.bIsValid()) _Element.append(el);
		}	
	}
	_Pt0 = getPoint(T("\n Select a point for display"));
}

if (piStory != -1){
	for (int i=0; i<gps.length(); i++) {
		Group gp = gps[i];
		if (Group(gp.namePart(0) + "\\" + gp.namePart(1)).nEquivalentStory() != piStory) continue;
		Element el = gp.elementLinked();
		if (el.bIsValid() && _Element.find(el)<0) _Element.append(el);
	}
}
_Element = _Element.filterValid();

if (_Element.length()<0){
	reportMessage("\n" + scriptName() + T(": No Element found.\n Erasing this instance."));
	eraseInstance();
	return;
}

Display dp(-1);
dp.textHeight(U(6));
String sText = T("Blocking at " + piStory + " equivalent story " + _Element.length() + " walls");
dp.draw(sText, _Pt0, _XW, _YW, 1, 1);

if (_bOnDbCreated && psRemoveExisting == arYN[0]) {
	for (int i = 0; i < _Element.length(); i++) {
		Element el = _Element[i];
		_Beam.append(Beam().filterAcceptedEntities(el.beam(), "((IsParallelToElementX == 'true'))and((Type == '_kBlocking')or(Type == '_kSFBlocking'))"));
	}
}
String sRegenerateBlockings = T("Regenerate Blocking Beams");
addRecalcTrigger(_kContextRoot, sRegenerateBlockings);

if (_bOnDbCreated || (_bOnRecalc && _kExecuteKey == sRegenerateBlockings)) { 
	if (_Beam.length()) {
		for (int i=_Beam.length()-1; i>-1; i--) {
			Beam bm = _Beam[i];
			_Beam.removeAt(i);
			bm.dbErase();
		}
	}
	
	int ariAmount[] 		  = { piAmount1, 		piAmount2, 		  piAmount3, 		piAmount4,		  piAmount5,		piAmount6		  	};
	double ardHeightPos[] 	  = { pdHeightPos1, 	pdHeightPos2, 	  pdHeightPos3, 	pdHeightPos4,	  pdHeightPos5,	 	pdHeightPos6		};
	double ardHeight[] 		  = { pdHeight1, 		pdHeight2, 		  pdHeight3, 		pdHeight4,		  pdHeight5,		pdHeight6		  	};
	double ardWidth[] 		  = { pdWidth1, 		pdWidth2, 		  pdWidth3, 		pdWidth4,		  pdWidth5,		 	pdWidth6			};
	String arsFace[] 		  = { psFace1,  		psFace2, 		  psFace3, 			psFace4,		  psFace5,		 	psFace6				};
	double ardGap[] 		  = { pdGap1, 			pdGap2, 		  pdGap3, 			pdGap4,			  pdGap5,			pdGap6			  	};
	String arsStagger[]  	  = { psStagger1, 		psStagger2, 	  psStagger3, 		psStagger4,		  psStagger5,		psStagger6		  	};
	double ardStaggerCustom[] = { pdStaggerCustom1, pdStaggerCustom2, pdStaggerCustom3, pdStaggerCustom4, pdStaggerCustom5,	pdStaggerCustom6	};
	
	for (int i=0; i<_Element.length(); i++){
		Element el = _Element[i];
		PlaneProfile ppEl = el.profNetto(0);
		Beam bms[] = el.beam();
		PlaneProfile ppBms;	double dShrink = U(0.0625);
		for (int k=0; k<bms.length(); k++) {
			PlaneProfile ppBm = bms[k].envelopeBody().shadowProfile(Plane(el.ptOrg(), el.vecZ()));
			ppBm.shrink(-dShrink);
			if (k == 0) ppBms = ppBm;
			else ppBms.unionWith(ppBm);
		}
		ppEl.subtractProfile(ppBms);
		ppEl.shrink(dShrink);
		ppEl.transformBy(-el.vecZ()*el.dBeamWidth()/2);
		LineSeg lsEl = ppEl.extentInDir(el.vecX());
		double dElLength = abs(el.vecX().dotProduct(lsEl.ptEnd() - lsEl.ptStart()));
		
		CoordSys csMirror;
		csMirror.setToMirroring(Plane(el.ptOrg()-el.vecZ()*el.dBeamWidth()/2, el.vecZ()));
		
		for (int p=0; p<ariAmount.length(); p++){
			int iAmount			  = ariAmount[p];	if (!iAmount) continue;		
			double dHeightPos	  = ardHeightPos[p];
			double dHeight		  = ardHeight[p];
			double dWidth		  = ardWidth[p];	if (dWidth < dShrink || dWidth - el.dBeamWidth() > dShrink) dWidth = el.dBeamWidth();
			String sFace		  = arsFace[p];		if (sFace == arFaces[2] & 2 * dWidth - el.dBeamWidth() > dShrink) sFace = arFaces[3];
			double dGap			  = ardGap[p];
			String sStagger		  = arsStagger[p];
			double dStaggerCustom = ardStaggerCustom[p];	if (sStagger != arStagger.last()) dStaggerCustom = dHeight;
			
			double dOffsetY = arKstagger[arStagger.find(sStagger)]*dStaggerCustom/2;
			int iOffsetZ = arOffstZ[arFaces.find(sFace)];
			Vector3d vecYZ[] = { el.vecY(), el.vecZ()};
			double dYZ[] = { dHeight, dWidth};
			int flagYZ[] = { 0, - iOffsetZ};
			if (dHeight < dWidth){
				vecYZ.swap(0,1);
				dYZ.swap(0, 1);
				flagYZ.swap(0, 1);
			}
			
			Plane plElev(el.ptOrg() + el.vecY() * dHeightPos, el.vecY()); LineSeg lsBmsY = ppBms.extentInDir(el.vecY());
			LineSeg lsElev(plElev.closestPointTo(lsEl.ptStart()) -el.vecX()*U(1), plElev.closestPointTo(lsEl.ptEnd()) +el.vecX()*U(1)); 
			LineSeg arLsCandidates[] = ppEl.splitSegments(lsElev, true);
			for (int q=arLsCandidates.length()-1; q>=0; q--){
				if (arLsCandidates[q].length() - dGap*2 < pdMinLen 
				|| el.vecY().dotProduct(arLsCandidates[q].ptMid()-lsBmsY.ptStart())*el.vecY().dotProduct(arLsCandidates[q].ptMid()-lsBmsY.ptEnd()) > 0) 
					arLsCandidates.removeAt(q);	
			}
			for (int q=0; q<arLsCandidates.length(); q++) {
				LineSeg lsBlocking = arLsCandidates[q];
				lsBlocking.transformBy(el.vecY()*dOffsetY*(q%2==0 ? 1 : -1));
				lsBlocking.transformBy(el.vecZ()*iOffsetZ*el.dBeamWidth()/2);
				lsBlocking.transformBy(el.vecY()*dHeight*iAmount/2);
				for (int t=0; t<iAmount; t++){
					Beam bmBlock;
					bmBlock.dbCreate(lsBlocking.ptMid() -el.vecY()*dHeight/2, el.vecX(), vecYZ[0], vecYZ[1], lsBlocking.length()-dGap*2, dYZ[0], dYZ[1], 0, flagYZ[0], flagYZ[1]);
					bmBlock.setColor(2);
					bmBlock.setType(_kBlocking);
					bmBlock.assignToElementGroup(el, true, 0, 'Z');
					_Beam.append(bmBlock);
					
					if (sFace == arFaces[2]) {
						Beam bmMirror = bmBlock.dbCopy();
						bmMirror.transformBy(csMirror);
						bmMirror.assignToElementGroup(el, true, 0, 'Z');
						_Beam.append(bmMirror);
					}
					lsBlocking.transformBy(-el.vecY()*dHeight);
				}
			}
		}
	}
}

for (int i=0; i<_Beam.length(); i++){
	Beam bm = _Beam[i];
	PlaneProfile ppBm = bm.envelopeBody().shadowProfile(Plane(bm.element().ptOrg(), _ZW));
	dp.draw(ppBm, _kDrawFilled, 80);
}
Group gpStory(T("Helpful"), T("Blocking Controls"), piStory);
if (!gpStory.bExists()) {
	gpStory.dbCreate();
	if (piStory >= 0) gpStory.setNEquivalentStory(piStory);
}
gpStory.addEntity(_ThisInst, true);
#End
#BeginThumbnail


#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End