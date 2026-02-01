#Version 8
#BeginDescription

V1.0 10/19/2021 TSL to draw cutlist of lumber in a bundle filtered by specified painter definition
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
U(1, "inch");
int i_pStr, i_pInt, i_pDbl;
PropString psDimStyle(i_pStr++, _DimStyles, "DimStyle", 0);
PropDouble pdTextHeight(i_pDbl++, 0, "Text Height");
String allPainter[] = PainterDefinition().getAllEntryNames().sorted(); 
PropString psPainter(i_pStr++, allPainter, "Painter Definition", 0);


if (_bOnInsert) {
	if (insertCycleCount()>1) {
		eraseInstance();
		return;
	}
	showDialog();
	_Pt0 = getPoint("\n Select a point");
	_Entity.append(getTslInst("\n Select a bundle TSL"));
}

if (_Entity.length()<1)
{
	eraseInstance();
	return;
}
TslInst tsl = (TslInst)_Entity[0];
if (!tsl.bIsValid())
{
	eraseInstance();
	return;
}
Map mp = tsl.subMapX("Hsb_StackingParent");
Entity elems[] = mp.getEntityArray("elems", "elems", "elems");
if (elems.length()<1)
{
	reportMessage("\n No elements in a bundle");
	return;
}
else 
{
	PainterDefinition paintdef(psPainter);
	if (!paintdef.bIsValid())
	{
		reportMessage("\n Painter definition is not valid!");
		return;
	}
	setDependencyOnDictObject(paintdef);	
	setDependencyOnEntity(tsl);
	int iFillerTypes[] = { 20, 37, 125, 126};
	String arActualSizeGrades[] = { "OSB", "ZIP", "GYP", "LSL", "LVL", "GLB"};
	String arFillerGrades[] = { "OSB", "ZIP", "GYP"};
	
	String arInfo[0], arInfowQtys[0];
	for (int i=0; i<elems.length(); i++) {
		Element el = (Element)elems[i];
		Beam bmAll[] = el.beam();
		for (int j=0; j<bmAll.length(); j++) {
			Beam bm_this = bmAll[j];
			if (bm_this.acceptObject(paintdef.filter())) 
			{
				int i_typeThis = bm_this.type();
				String st_typeThis = _BeamTypes[i_typeThis];
				if (st_typeThis.find("SF ", 0) >- 1) st_typeThis = st_typeThis.right(st_typeThis.length()-3);
				if (st_typeThis == "Left stud" || st_typeThis == "Right stud") st_typeThis = "Stud";
				if (st_typeThis.find("Cripple", 0) >- 1) st_typeThis = "Cripple";
				if (st_typeThis == "Jack over opening" || st_typeThis == "Jack under opening") st_typeThis = "Cripple";
				if (bm_this.hsbId().find("MASA", 0) >- 1) st_typeThis = "MASA " + st_typeThis;
				int b_isFiller = iFillerTypes.find(i_typeThis) >- 1;
				for (int j; j<arFillerGrades.length(); ++j) 
				{
					if (bm_this.grade().find(arFillerGrades[j], 0, false)>-1 
					|| bm_this.material().find(arFillerGrades[j], 0, false)>-1 
					|| bm_this.name().find(arFillerGrades[j], 0, false)>-1) b_isFiller = true;
				}
				if (b_isFiller) st_typeThis = "Filler";
				double ar_d_beamSizes[] = { bm_this.dW(), bm_this.dH()};
				if (ar_d_beamSizes[0] > ar_d_beamSizes[1]) ar_d_beamSizes.swap(0, 1);
				int b_isActualSize = false;
				for (int j; j<arActualSizeGrades.length(); ++j) 
				{
					if (bm_this.grade().find(arActualSizeGrades[j], 0 , false)>-1 
					|| bm_this.material().find(arActualSizeGrades[j], 0 , false)>-1 
					|| bm_this.name().find(arActualSizeGrades[j], 0 , false)>-1) b_isActualSize = true;
				}	
				if (b_isFiller) b_isActualSize = true;
				if (!b_isActualSize)
				{
					if (ceil(ar_d_beamSizes[0]) - ar_d_beamSizes[0] > 0) ar_d_beamSizes[0] = ceil(ar_d_beamSizes[0]);		
					if (ceil(ar_d_beamSizes[1]) - ar_d_beamSizes[1] > 0) ar_d_beamSizes[1] = ceil(ar_d_beamSizes[1]);
				}		
				String st_sizeThis = ar_d_beamSizes[0] + "x" + ar_d_beamSizes[1]+" "+bm_this.grade();
				if (b_isActualSize) st_sizeThis = String().formatUnit(ar_d_beamSizes[0], psDimStyle) + "x" + String().formatUnit(ar_d_beamSizes[1], psDimStyle) + " " + bm_this.grade();
				String st_lengthThis = String().formatUnit(bm_this.solidLength(), psDimStyle);
				String stInfo = st_typeThis+"~"+st_sizeThis+"~"+st_lengthThis;
				int iFind = arInfo.find(stInfo);
				if (iFind<0)
				{
					arInfo.append(stInfo);
					arInfowQtys.append(st_typeThis+"~"+st_sizeThis+"~"+"1"+"~"+st_lengthThis);
				}
				else
				{
					String arTokens[] = arInfowQtys[iFind].tokenize("~");
					arTokens[2] = arTokens[2].atoi() + 1;
					String stUpdated;
					for (int k=0; k<arTokens.length(); k++) {
						stUpdated += (k==0 ? "": "~")+arTokens[k];
					}
					arInfowQtys[iFind] = stUpdated;
				}
			}
				
		}
	}
	Display dp(-1);
	dp.dimStyle(psDimStyle);
	if (pdTextHeight>0)
		dp.textHeight(pdTextHeight);
	String arDraw[] = arInfowQtys.sorted();
	Vector3d vx = _XW, vy = _YW;
	double dRowH = dp.textHeightForStyle("(/)", psDimStyle)*1.5;	
	double dCharL = dp.textLengthForStyle("A", psDimStyle);
	if (pdTextHeight>0){
		dRowH = dp.textHeightForStyle("(/)", psDimStyle, pdTextHeight)*1.5;	
		dCharL = dp.textLengthForStyle("A", psDimStyle, pdTextHeight);
	}
	Point3d ptStart = _Pt0;
	String arHeaders[] = { "Timber", "Size", "Qty", "Length"};
	double dTotalL;
	for (int i=0; i<arHeaders.length(); i++) {
		String stHeader = arHeaders[i];
		double dColumnSize = dp.textLengthForStyle(stHeader, psDimStyle);
		if (pdTextHeight>0)
			dColumnSize = dp.textLengthForStyle(stHeader, psDimStyle, pdTextHeight);
		Point3d ptGo = ptStart;
		for (int j=arDraw.length()-1; j>-1; j--) {
			String stDraw = arDraw[j].token(i, "~");
			double dSize = dp.textLengthForStyle(stDraw, psDimStyle);
			if (pdTextHeight>0)
				dSize = dp.textLengthForStyle(stDraw, psDimStyle, pdTextHeight);
			if (dSize > dColumnSize) dColumnSize = dSize;
			ptGo += vy * dRowH / 2;
			dp.draw(stDraw, ptGo + vx * dCharL, vx, vy, 1, 0);
			ptGo += vy * dRowH / 2;			
		}
		ptGo += vy * dRowH / 2;
		dColumnSize += 2 * dCharL;
		dTotalL += dColumnSize;
		dp.draw(stHeader, ptGo + vx * dColumnSize / 2, vx, vy, 0, 0);
		ptGo += vy * dRowH / 2;
		PLine plColumn;
		plColumn.createRectangle(LineSeg(ptStart, ptGo + vx * dColumnSize), vx, vy);
		dp.draw(plColumn);
		ptStart += vx * dColumnSize;
	}
	for (int i=0; i<arDraw.length(); i++) {
		ptStart += vy * dRowH;
		dp.draw(LineSeg(ptStart, ptStart - vx * dTotalL));
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
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="TSL to draw cutlist of lumber in a bundle filtered by specified painter definition" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="10/19/2021 4:44:40 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End