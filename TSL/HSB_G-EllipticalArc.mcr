#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
03.03.2017  -  version 1.01
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
/// This tsl creates a elliptical arc.
/// </summary>

/// <insert>
/// Select a position.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="03.03.2017"></version>

/// <history>
/// AS - 1.00 - 27.02.2017 -	Pilot version
/// AS - 1.01 - 03.03.2017 -	Add option to assign arc to element
/// </history>

PropDouble width(0, U(1500), T("|Width|"));
PropDouble height(1, U(400), T("|Height|"));

String noYes[] = { T("|No|"), T("|Yes|")};
PropString showHelperLinesProp(0, noYes, T("|Show helper lines|"),1);

if (_bOnInsert) 
{
	if (insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}
	
	showDialog();
	
	String selectionMode = getString(T("|Place arc in in Element or <World>  UCS|"));
	if (selectionMode.left(1) ==  "E")
		_Element.append(getElement(T("|Select an element|") + T("<Enter> |to place the arc in world ucs|.")));
	
	_Pt0 = getPoint(T("|Select a position|"));
	
	return;
}

Vector3d vx = _XW;
Vector3d vy = _YW;
Vector3d vz = _ZW;

if (_Element.length() > 0)
{
	Element el = _Element[0];
	if (!el.bIsValid())
		return;
	
	_Pt0 = Plane(el.ptOrg(), el.vecZ()).closestPointTo(_Pt0);
	vx = el.vecX();
	vy = el.vecY();
	vz = el.vecZ();
	
	assignToElementGroup(el, true, 0, 'I');
}

int showHelperLines = noYes.find(showHelperLinesProp, 1);

Point3d A = _Pt0;
Point3d B = _Pt0 + vx * width;
Point3d C = (A+B)/2;
Point3d D = C + vy * height;
A.vis();
B.vis();
C.vis();
D.vis();

Display red(1);
Display blue(5);
Display green(3);
Display black(7);

PLine lineAB(A, B);
PLine lineCD(C, D);
PLine circleC_AC(vz);
circleC_AC.createCircle(C, vz, 0.5 * width);

Point3d E = C + vy * 0.5 * width;
double distanceDE = (D-E).length();
E.vis();

PLine circleD_DE(vz);
circleD_DE.createCircle(D, vz, distanceDE);

Vector3d directionDA(A-D);
directionDA.normalize();

Point3d F = D + directionDA * distanceDE;
F.vis();

Vector3d directionDB(B-D);
directionDB.normalize();

Point3d G = D + directionDB * distanceDE;
G.vis();

PLine lineAD(A,D);
PLine lineBD(B,D);

Point3d midAF = (A+F)/2;
Vector3d directionPH = vz.crossProduct(directionDA);
Point3d P = Line(midAF, directionPH).intersect(Plane(C, vx), U(0));
P.vis();

PLine linePH(P, midAF - directionPH * 0.5 * width);

Point3d midBG = (B+G)/2;
Vector3d directionPK = -vz.crossProduct(directionDB);

PLine linePK(P, midBG - directionPK * 0.5 * width);

Point3d H = Line(midAF, directionPH).intersect(Plane(A, vy), U(0));
H.vis();

Point3d K = Line(midBG, directionPK).intersect(Plane(A, vy), U(0));
K.vis();

double distanceHA =(H-A).length();
PLine circleH_HA(vz);
circleH_HA.createCircle(H, vz, distanceHA);

double distanceKB =(K-B).length();
PLine circleK_KB(vz);
circleK_KB.createCircle(K, vz, distanceKB);

Point3d L = H - directionPH * distanceHA;
L.vis();

Point3d M = K - directionPK * distanceKB;
M.vis();

PLine arc(vz);
arc.addVertex(_Pt0);
arc.addVertex(L, distanceHA, _kCWise, true);
arc.addVertex(M, D);
arc.addVertex(B, distanceKB, _kCWise, true);

if (showHelperLines)
{
	red.draw(lineAB);
	red.draw(lineCD);
	red.draw(circleC_AC);
	blue.draw(circleD_DE);
	green.draw(lineAD);
	green.draw(lineBD);
	green.draw(linePH);
	green.draw(linePK);
	blue.draw(circleH_HA);
	blue.draw(circleK_KB);
}

black.draw(arc);
#End
#BeginThumbnail


#End