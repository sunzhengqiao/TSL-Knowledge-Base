#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
04.11.2016  -  version 1.05

Version 2.0 26-9-2024 Remove the dbErase action on the last beam if it is not joined. And add a _BonDebug for testing. Ronald van Wijngaarden
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl joins a set of beams if they are in line.
/// </summary>

/// <insert>
/// Select a set of beams
/// </insert>

/// <remark Lang=en>
/// ExecuteKey "StretchToExtremes" stretches the beam to the extreme points.
/// </remark>

/// <version  value="1.05" date="04.11.2016"></version>

/// <history>
/// AS - 1.00 - 15.07.2016 -	First revision
/// AS - 1.01 - 26.07.2016 -	Make joined beams invalid in main beam list.
/// AS - 1.02 - 31.08.2016 -	Show a warning when the last beam is not in line with the first beam and the join failed.
/// AS - 1.03 - 08.09.2016 -	Add option to stretch to extremes.
/// AS - 1.04 - 08.09.2016 -	Store affected elements.
/// RP - 1.05 - 04.11.2016 -	Not stretch to extremes on manual insert.
/// </history>

//#Versions
//2.0 26-9-2024 Remove the dbErase action on the last beam if it is not joined. And add a _BonDebug for testing. Ronald van Wijngaarden


double tolerance = U(1, "mm");
double vectorTolerance = U(0.01, "mm");

if (_bOnInsert) {
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	PrEntity beamsSelection(T("|Select beams to join|"), Beam());
	if (beamsSelection.go())
		_Beam.append(beamsSelection.beamSet());
	
	_Map.setInt("ManualInsert", true);

	return;
}

int manualInsert = false;
if (_Map.hasInt("ManualInsert")) {
	manualInsert = _Map.getInt("ManualInsert");
	_Map.removeAt("ManualInsert", true);
}

if (_bOnMapIO || manualInsert) {
	Entity entities[] = _Map.getEntityArray("Beams", "Beams", "Beam");
	for (int e=0;e<entities.length();e++) {
		Beam bm = (Beam)entities[e];
		if (bm.bIsValid())
			_Beam.append(bm);
	}
	
	if (_Beam.length() == 0) {
		eraseInstance();
		return;
	}
	
	Entity resultingBeams[0];
	for (int b1=0;b1<_Beam.length();b1++) {
		Beam mainBeam = _Beam[b1];
		if (!mainBeam.bIsValid())
			continue;
		
		Vector3d mainX = mainBeam.vecX();
		Vector3d mainY = mainBeam.vecY();
		Vector3d mainZ = mainBeam.vecZ();
		
		Beam beamsToJoin[] = {mainBeam};
		Point3d extremes[] = {
			mainBeam.ptCen() - mainX * 0.5 * mainBeam.solidLength(),
			mainBeam.ptCen() + mainX * 0.5 * mainBeam.solidLength()
		};

		// Find beams aligned with this one and join them if possible.
		for (int b2=0;b2<_Beam.length();b2++) {
			if (b1 == b2)
				continue;
			
			Beam bm = _Beam[b2];
			if (!bm.bIsValid())
				continue;
			
			Vector3d bmX = bm.vecX();
			Vector3d bmY = bm.vecY();
			Vector3d bmZ = bm.vecZ();
//			return;
			// Validate this beam
			// Are the aligned?
			if (abs(abs(mainX.dotProduct(bmX)) - 1) > vectorTolerance)
			continue;

			if (abs(abs(mainY.dotProduct(bmY)) - 1) > vectorTolerance)
			continue;
						
			if (abs(mainY.dotProduct(mainBeam.ptCen() - bm.ptCen())) > tolerance)
			continue;
				
			if (abs(mainZ.dotProduct(mainBeam.ptCen() - bm.ptCen())) > tolerance)
			continue;	

			beamsToJoin.append(bm);
			
			extremes.append(bm.ptCen() - bmX * 0.5 * bm.solidLength());
			extremes.append(bm.ptCen() + bmX * 0.5 * bm.solidLength());
		}
		
		// Sort in main x direction.
		for(int s1=1;s1<beamsToJoin.length();s1++){
			int s11 = s1;
			for(int s2=s1-1;s2>=0;s2--){
				if( mainX.dotProduct(beamsToJoin[s11].ptCen() - beamsToJoin[s2].ptCen()) < 0 ){
					beamsToJoin.swap(s2, s11);
					
					s11=s2;
				}
			}
		}

		if (beamsToJoin.length() == 0)
			continue;	
	
		Entity affectedElements[0];
		
		Element el = beamsToJoin[0].element();
		if (el.bIsValid())
			affectedElements.append(el);
		
		if (_kExecuteKey == "StretchToExtremes") {
			Beam beamToStretch = beamsToJoin[0];
			extremes = Line(beamToStretch.ptCen(), mainX).orderPoints(extremes);
			
			if (extremes.length() < 2) {
				reportWarning(T("|Extremes could not be calculated for beams with beam code| ") + beamToStretch.beamCode().token(0));
				
			}
			
			beamToStretch.addToolStatic(Cut(extremes[0], -mainX), _kStretchOnInsert);
			beamToStretch.addToolStatic(Cut(extremes[extremes.length() - 1], mainX), _kStretchOnInsert);
			
			for (int b=1;b<beamsToJoin.length();b++) {
				Beam bm = beamsToJoin[b];
				
				//Store the affected elements
				el = bm.element();
				
				if (el.bIsValid()) {
					if (affectedElements.find(el) == -1)
						affectedElements.append(el);
				}
				
				bm.dbErase();
			}
			beamsToJoin.setLength(0);
			beamsToJoin.append(beamToStretch);
		}
		else {
			// Join beams.
			for (int b=1;b<beamsToJoin.length();b++) {
				Beam bm = beamsToJoin[b];
				
				//Store the affected elements
				el = bm.element();
				
				if (el.bIsValid()) {
					if (affectedElements.find(el) == -1)
						affectedElements.append(el);
				}
				
				beamsToJoin[0].dbJoin(bm);
				int bmIndex = _Beam.find(bm);
				if (bmIndex !=-1)
					_Beam[bmIndex] = Beam();
			}
		}

		if (beamsToJoin.length() > 0) {
			Beam joinedBeam = beamsToJoin[0];
			resultingBeams.append(joinedBeam);
			
			String elementNumbers[0];
			for (int b=1;b<beamsToJoin.length();b++) {
				Beam bm = beamsToJoin[b];
				if (bm.bIsValid()) {
					elementNumbers.append(	bm.element().number());
					
					// Only report this warning if it is the last beam in line...
					if (b == (beamsToJoin.length() - 1)) {
						String elementNumbersTxt;
						for (int n=0;n<elementNumbers.length();n++) {
							if (n==0)
								elementNumbersTxt = elementNumbers[n];
							else if (n > 1 && n == (elementNumbers.length() - 1))
								elementNumbersTxt += (" & " + elementNumbers[n]);
							else
								elementNumbersTxt += (", " + elementNumbers[n]);
						}
						
						String beamCodeTxt, elementTxt, notJoinedTxt;
						if (elementNumbers.length() > 1) {
							beamCodeTxt = TN("|Beams with beam code| ");
							elementTxt = T(", |in elements| ");
							notJoinedTxt = T(", |are not aligned with the main beam and are not joined|!");
						}
						else {
							beamCodeTxt = TN("|Beam with beam code| ");
							elementTxt = T(", |in element| ");
							notJoinedTxt  = T(", |is not aligned with the main beam and is not joined|!");
						}
						
						reportWarning(
							beamCodeTxt + bm.beamCode().token(0) + elementTxt + elementNumbersTxt +  notJoinedTxt + 
							TN("|This means that the length will be incorrect|!"));
					}
				}
			}
			
			_Map.setEntityArray(affectedElements, false, joinedBeam.handle(), "Elements", "Element");
			
			int bmIndex = _Beam.find(joinedBeam);
			if (bmIndex !=-1)
				_Beam[bmIndex] = Beam();

		}
	}
	
	_Map.setEntityArray(resultingBeams, false, "Beams", "Beams", "Beam");
	
	if (manualInsert)
		eraseInstance();
	return;
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
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Remove the dbErase action on the last beam if it is not joined. And add a _BonDebug for testing." />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="9/26/2024 11:29:24 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End