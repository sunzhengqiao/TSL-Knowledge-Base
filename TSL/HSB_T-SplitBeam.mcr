#Version 8
#BeginDescription

#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents


if (_bOnInsert)
{
	Beam bm = getBeam(T("|Select a beam|"));
	
	Point3d from = getPoint(T("|Split from|"));
	Point3d to;
	while (true)
	{
		PrPoint ssPt(T("|Split to|"), from);
		if (ssPt.go() == _kOk)
		{
			to = ssPt.value();
			break;
		}
		else
		{
			reportWarning(scriptName() + TN("|Invalid split location|"));
			eraseInstance();
			return;
		}
	}
	
	if (bm.vecX().dotProduct(from - to) < 0)
	{
		Point3d p = from;
		from = to;
		to = p;
	}
	
	bm.dbSplit(from, to);
	
	eraseInstance();
	return;	
}
#End
#BeginThumbnail

#End