#Version 8
#BeginDescription
V0.5__12Dec2019__Uses truss coordsys for placement.
V0.4__Jul_18_2019__Add TrussEntity
V0.3__Jul_17_2019__Add nails for holdowns
V0.2__Jan_30_2019__Does not display text
V0.1__Jan_18_2019__Allows to add HoldDown to the selected beam in a Floor. Reads holddown geometry from file "HSBcompany\Abbund\holdowns.dxx".
#End
#Type O
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 5
#KeyWords 
#BeginContents
U(1,"inch");

double dThick=U(0.125);
String arHoldDownDescription[] = { "DTT2Z-SDS2.5 SIMPSON", "HDU4-SDS2.5 SIMPSON", "HDU8-SDS2.5 SIMPSON"};
String arHoldDownNames[] = { "DTT2Z-SDS2.5", "HDU4-SDS2.5", "HDU8-SDS2.5"};
double arDx[] = { U(1.625), U(3.25), U(3.5)};
double arDy[] = { U(6.9375), U(10.9375), U(16.625)};
double arDz[] = { U(3.25), U(3), U(3)};
int ariShape[] = { 3, 0, 0};
//For the holdowns, add their fasteners. If arHoldDownNames modified later, the below array should be modified also
int arNFastenerNum[] = { 8, 10, 20};
String arStFastenerType[] = { "1/4 x 2 1/2\" SDS", "1/4 x 2 1/2\" SDS", "1/4 x 2 1/2\" SDS" };

PropString prHoldDown(0, arHoldDownDescription, "Hold Down", 0);
String arLR[] = { "Left", "Right"};
PropString prPosition(1, arLR, "Beam side", 0);
String arYN[] = { "Yes", "No"};
PropString prShopInstall(2, arYN, "Shop Installed", 0);
PropDouble prDoffsetLdir(3, U(6), "End Offset");
PropDouble prDoffsetHdir(4, U(0), "Center Offset");

if (_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	showDialogOnce();
	PrEntity prEnt("\n Select beam or truss entity to attach to");
	prEnt.addAllowedClass(Beam());
	prEnt.addAllowedClass(TrussEntity());
	if(prEnt.go())
	{ 
		_Entity = prEnt.set();
	}
		
	_PtG.append(getPoint("\n Select end point of the beam"));
}
setMarbleDiameter(U(3));
if (_Beam.length()>0)
{
	for (int i=0; i<_Beam.length(); i++){
		if (_Beam[i].bIsValid()) _Entity.append(_Beam[i]);
	}
	_Beam.setLength(0);
}
if (_Entity.length()<1) { eraseInstance(); return;}

Entity ent = _Entity[0];
if (!ent.bIsValid()) { eraseInstance(); return;}

Element el = ent.element();
if (!el.bIsValid()) { eraseInstance(); return;}

assignToElementGroup(el, FALSE, 0, 'Z');

Group gp(String("X - Hardware" + "\\" + "X-Hold Down Connectors" + "\\" + prHoldDown));
if (gp.bExists() == FALSE) gp.dbCreate();
gp.setBIsDeliverableContainer(TRUE);
gp.addEntity(_ThisInst, FALSE);

//Need find truss entity's ptCen, dL, vecX, vecY, vecZ, dBmW
Point3d ptCenter;
Vector3d vecXDir, vecYDir, vecZDir; //Will be the normalized vector
double dEntL, dEntW, dEntH;

Beam bm = (Beam) ent;
TrussEntity trEnt = (TrussEntity) ent;
if(bm.bIsValid())
{ 
	//A beam selected
	ptCenter = bm.ptCen();
	vecXDir = bm.vecX().normal();
	vecYDir = bm.vecY().normal();
	vecZDir = bm.vecZ().normal();
	dEntL = bm.dL();
	dEntW = bm.dW();
	dEntH = bm.dH();
	
	bm.setPanhand(el);
	
}
else if(trEnt.bIsValid())
{ 
	CoordSys tCs = trEnt.coordSys();
	TrussDefinition tDef = trEnt.definition();
	Map mpContent = tDef.subMapX("Content");
	tCs.vis();
	vecXDir = mpContent.getVector3d("Length");
	vecYDir = mpContent.getVector3d("Width");
	vecZDir = mpContent.getVector3d("Height");
	
	dEntL = vecXDir.length();
	dEntW = vecYDir.length();
	dEntH = vecZDir.length();
	
	ptCenter = tCs.ptOrg() + tCs.vecX() * dEntL/2 + tCs.vecZ() * dEntH/2;
	
	vecXDir.normalize();
	vecYDir.normalize();
	vecZDir.normalize();
	
	vecXDir = tCs.vecX();
	vecYDir = tCs.vecY();
	vecZDir = tCs.vecZ();
}
else
{
	//Not the beam or TrussEntity, it should not happen. If here, end it
	eraseInstance();
	return;
}

Body bdEnt(ptCenter, vecXDir, vecYDir, vecZDir, dEntL, dEntW, dEntH);

_ThisInst.setAllowGripAtPt0(FALSE);
PLine plGrip(ptCenter + 0.5 * dEntL * vecXDir, ptCenter - 0.5 * dEntL * vecXDir);
if (plGrip.isOn(_PtG[0]) == FALSE) _PtG[0] = plGrip.closestPointTo(_PtG[0]);

Vector3d entX = vecXDir;
if ( (_PtG[0] - ptCenter).dotProduct(entX) < 0 ) entX = - entX;
Vector3d elZ = el.vecZ();
if ( elZ.dotProduct(_ZW) < 0 ) elZ = - elZ;
Vector3d entY = elZ.crossProduct(entX);
if (prPosition == "Right") entY = - entY;

entY.normalize();

double dBmW = bdEnt.lengthInDirection(entY);

Point3d ptHoldDown = ptCenter + (0.5 * dEntL - prDoffsetLdir) * entX + prDoffsetHdir * elZ + 0.5 * dBmW * entY;
_Pt0 = ptHoldDown;
_Map.setInt("HOLDDOWN_SCHEDULE", true);
_Map.setPoint3d("HOLDDOWN_POINT", ptHoldDown);
_Map.setInt("HOLDDOWN_QTY", 1);
_Map.setString("HOLDDOWN_MODEL", String(prHoldDown));
int iLoose = prShopInstall == arYN[1] ? true : false;
_Map.setInt("HOLDDOWN_LOOSE", iLoose);
_Map.setVector3d("HOLDDOWN_VECTOR", (_PtG.first() - ptHoldDown));


_Map.setPoint3d("ANCHOR_POINT", ptHoldDown);

entX.vis(ptHoldDown, 3);
Map mpHoldDowns;
mpHoldDowns.readFromDxxFile(String(_kPathHsbCompany+"\\Abbund\\holdowns.dxx"));
Body bdConnector = mpHoldDowns.getBody(prHoldDown);
CoordSys csNew;
csNew.setToAlignCoordSys(Point3d(0, 0, 0), _XW, _YW, _ZW, ptHoldDown, entY, - elZ, - entX);
bdConnector.transformBy(csNew);

Display dpMod(252),dpModLay(252);
dpModLay.showInDispRep("HoldDown");
dpModLay.textHeight(U(2));
dpMod.draw(bdConnector);
dpModLay.draw(bdConnector);
dpMod.showInDxa(true);

Display dpDxa(1);
dpDxa.showInDxa(true);
dpDxa.textHeight(U(4));
dpDxa.showInDispRep("Bogus");
int iFlagX = 1;
int iFlagY = 1;
if (entY.isPerpendicularTo(_XW))
{
	if (entY.dotProduct(_YW) < 0) iFlagY = -1;
}
else if (entY.isPerpendicularTo(_YW))
{
	if (entY.dotProduct(_XW) < 0) iFlagX = - 1;
}
if (prShopInstall == arYN[0])
{
	Plane pnEl(el.ptOrg(), elZ);
	PlaneProfile pp = bdConnector.shadowProfile(pnEl);
	PLine plRings[] = pp.allRings();
	for(int i=0;i<plRings.length(); i++)
	{ 
		dpDxa.draw(plRings[i]);		
	}
}


exportToDxi(TRUE);
model(prHoldDown);
material("Hold Down");
dxaout("Element",el.number());
dxaout("TH-Item",prHoldDown);
HardWrComp arHwr[0];
HardWrComp hwr;
hwr.setName("HoldDown");
hwr.setBVisualize(false);
hwr.setDescription("HoldDown");
hwr.setManufacturer("SIMPSON");
hwr.setArticleNumber(arHoldDownNames[arHoldDownDescription.find(prHoldDown)]);
hwr.setModel(arHoldDownNames[arHoldDownDescription.find(prHoldDown)]);
hwr.setQuantity(1);
hwr.setCountType("Amount");

int nIndex = arHoldDownDescription.find(prHoldDown);
if(nIndex > -1 )
{ 
	HardWrComp hwrNail;
	hwrNail.setName("Nail");
	hwrNail.setDescription("Nail");
	hwrNail.setQuantity(arNFastenerNum[nIndex]);
	hwrNail.setArticleNumber(arStFastenerType[nIndex]);
	hwrNail.setModel(arStFastenerType[nIndex]);
	arHwr.append(hwrNail);	
	String stNotes = String(", Fasteners: (" + arNFastenerNum[nIndex] + ") " + arStFastenerType[nIndex]);
	hwr.setNotes(stNotes);
	_Map.setString("HOLDDOWN_FASTENERS", "(" + arNFastenerNum[nIndex] + ") " + arStFastenerType[nIndex]);
}
arHwr.append(hwr);
_ThisInst.setHardWrComps(arHwr);

Map mapDxaOut;
mapDxaOut.appendInt(prHoldDown,1);
_Map.setMap("MapDxaOut",mapDxaOut);	
Map mpHDOut;
mpHDOut.setString("stTypeDescription", prHoldDown);
mpHDOut.setString("stConnector", arHoldDownNames[arHoldDownDescription.find(prHoldDown)]);
mpHDOut.setDouble("dSizeXEl", arDx[arHoldDownDescription.find(prHoldDown)]);
mpHDOut.setDouble("dSizeYEl", arDy[arHoldDownDescription.find(prHoldDown)]);
mpHDOut.setDouble("dSizeZEl", arDz[arHoldDownDescription.find(prHoldDown)]);
_Map.setMap("mpHoldDownData", mpHDOut);













































#End
#BeginThumbnail










#End
#BeginMapX

#End