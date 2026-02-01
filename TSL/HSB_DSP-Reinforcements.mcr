#Version 8
#BeginDescription
Last modified by: Anno Sportel (support.nl@hsbcad.com)
08.01.2018  -  version 1.01

This tsl copies the reinforcements to the other side of the rafter too.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
//region History
/// <summary Lang=en>
/// This tsl copies the reinforcements to the other side of the rafter too.
/// </summary>

/// <insert>
///  Must be attached to a DSP detail.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="08.01.2018"></version>

/// <history>
/// AS - 1.00 - 23.11.2017 -	Pilot version
/// AS - 1.01 - 08.01.2018 -	Check if tsl is attached to a detail line. If so it has an extra grip point.
/// </history>
//endregion

Unit(1, "mm");

if (_bOnInsert)
{
	reportNotice("\n" + scriptName() + T(" |must be attached to a DSP detail and cannot be inserted manually.|"));
	eraseInstance();
	return;
}

if (_Element.length() == 0) 
{
	reportNotice("\n" + scriptName() + TN("|No element selected.|"));
	eraseInstance();
	return;
}

ElementRoof el =(ElementRoof)_Element[0];
if (!el.bIsValid())
{
	reportNotice("\n" + scriptName() + TN("|The selected element is not a roof or a floor element.|"));
	eraseInstance();
	return;
}

if (_bOnElementConstructed)
{
	if (_PtG.length() == 0)
	{
		reportMessage("\n" + scriptName() + T(" - |Invalid detail line, the split direction could not be determined.|"));
		eraseInstance();
		return;
	}
	
	Vector3d elX = el.coordSys().vecX();
	
	Vector3d detailX(_PtG[0] - _Pt0);
	detailX.normalize();
	Line detailLine(_Pt0, detailX);
	
	String hsbId = "4110";
	
	Beam beams[] = el.beam();
	for (int b = 0; b < beams.length(); b++)
	{
		Beam bm = beams[b];
		Point3d beamStart = bm.ptCenSolid() - bm.vecX() * 0.5 * bm.solidLength();
		Point3d beamEnd = bm.ptCenSolid() + bm.vecX() * 0.5 * bm.solidLength();

		if (bm.hsbId() == hsbId)
		{
			// Copy the beam
			Point3d detailIntersection = detailLine.intersect(Plane(bm.ptCen(), bm.vecD(detailX)), U(0));
			detailIntersection.vis(1);
			
			if ((bm.vecX().dotProduct(beamStart - detailIntersection) * bm.vecX().dotProduct(beamEnd - detailIntersection)) > 0) continue;
			
			bm.dbCopy();
			bm.transformBy(-elX * (bm.dD(elX) + el.dBeamHeight()));
		}
	}
	
	eraseInstance();
	return;
}
#End
#BeginThumbnail



#End