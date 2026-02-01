#Version 8
#BeginDescription
Last modified by: Yarnick Boertje (support.nl@hsbcad.com)
26.04.2017  -  version 1.01

This TSL changes the side of a blocking
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
/// <summary Lang=en>
/// This TSL changes the side of a blocking.
/// </summary>

/// <insert>
/// Select a set of elements.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="26.04.2017"></version>

/// <history>
/// YB - 1.00 - 26.04.2017 -	Pilot version
/// YB - 1.01 - 26.04.2017 - 	Properties now come with the TSL
/// </history>

PropDouble dBlockingLength(0, U(100), T("|Blocking length|"));
PropDouble dBlockingWidth(2, U(25), T("|Blocking width|"));
PropDouble dBlockingHeight(1, U(25), T("|Blocking height|"));

int manualInserted = false;
if (_Map.hasInt("ManualInserted")) {
	 manualInserted = _Map.getInt("ManualInserted");
}

if(!_bOnDbCreated && !manualInserted && !_bOnRecalc && !_bOnDebug) 
{
	reportNotice(T("|TSL can only get inserted through HSB_G-SplitWithBlocking!|"));
	eraseInstance();
	return;
}

if(_Entity.length() != 2)
{
	reportNotice(T("|Invalid amount of entities found!|"));
	eraseInstance();
	return;
}

if(!_Beam.length() >= 1)
{
	reportNotice(T("|Invalid amount of beams found!|"));
	eraseInstance();
	return;
}

double blockingLength = dBlockingLength;
double blockingHeight = dBlockingHeight;
double blockingWidth = dBlockingWidth;

if(dBlockingLength <= 0)
{
	reportNotice(T("|Blocking length can't be lower than 0!|") + TN("|Blocking length set to 100.|"));
	blockingLength = U(100);
}
if(dBlockingWidth <= 0)
{
	reportNotice(T("|Blocking width can't be lower than 0!|") + TN("|Blocking width set to 25.|"));
	blockingWidth = U(25);
}
if(dBlockingHeight <= 0)
{
	reportNotice(T("|Blocking height can't be lower than 0!|") + TN("|Blocking height set to 25.|"));
	blockingHeight = U(25);
}

Beam blockingBeam;
Element el;

for(int e = 0; e < _Entity.length(); e++)
{
	if(_Entity[e].bIsA(Beam()))
		blockingBeam = (Beam)_Entity[e];
	else
		el = (Element)_Entity[e];
}

Beam selectedBeam = _Beam[0];
Point3d bmCen = blockingBeam.ptCen();
Vector3d blockingY;

double sdas = blockingBeam.vecY().dotProduct(blockingBeam.ptCen() - selectedBeam.ptCen());

if(blockingBeam.vecY().dotProduct(blockingBeam.ptCen() - selectedBeam.ptCen()) < U(0.01))
	blockingY = blockingBeam.vecY();
else
	blockingY = -blockingBeam.vecY();
Beam beams[] = el.beam();

PlaneProfile blockingProfile = selectedBeam.envelopeBody().getSlice(Plane(selectedBeam.ptCen(), selectedBeam.vecZ()));
Point3d test = _Pt0 + blockingY * U(10);

double totalWidth = blockingBeam.dD(blockingY) + selectedBeam.dD(blockingY);

// Trigger Flip side
String sTriggerFlipside = T("|Flip side|");

addRecalcTrigger(_kContext, sTriggerFlipside );
if (_bOnRecalc && (_kExecuteKey==sTriggerFlipside || _kExecuteKey=="TslDoubleClick"))
{
	_Pt0 += blockingY * selectedBeam.dD(blockingY);
	blockingY *= -1;
}	

Beam newBeam;
newBeam.dbCreate(_Pt0, blockingBeam.vecX(), blockingY, blockingBeam.vecZ(), blockingLength, blockingHeight, blockingWidth, 0, -1, 0);
_Entity.append(newBeam);
blockingBeam.dbErase();

Beam intersectingBeams[] = Body(newBeam.envelopeBody()).filterGenBeamsIntersect(beams);

for(int b = 0; b < intersectingBeams.length(); b++)
	intersectingBeams[b].stretchStaticTo(newBeam, true);
#End
#BeginThumbnail


#End