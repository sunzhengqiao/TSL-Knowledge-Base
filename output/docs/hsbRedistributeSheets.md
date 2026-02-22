# hsbRedistributeSheets

## Overview

**hsbRedistributeSheets** is an advanced sheet redistribution tool for hsbCAD elements (walls, floors, roofs). It allows you to precisely control where sheet joints (panel edges) are positioned within a specific zone and distribution area of an element. This parametric tool is particularly useful when the default automatic sheet distribution does not meet design, construction, or manufacturing requirements.

### Primary Use Cases

- **Align sheet joints with structural members**: Position panel edges to coincide with specific studs, joists, or beams for better structural integration
- **Avoid joints at critical locations**: Keep panel joints away from hardware connections, load transfer points, or openings
- **Optimize paneling around openings**: Control how sheets are distributed in areas separated by windows and doors
- **Meet fabrication requirements**: Create custom sheet layouts that match CNC machine capabilities or material availability
- **Standardize panel sizes**: Force uniform panel widths across a distribution area for easier material ordering and installation

When an element contains openings (windows, doors), the sheet coverage is automatically divided into separate **distribution areas** — continuous regions of sheeting separated by the openings. This tool lets you pick a specific distribution area and place a **splitting point** that determines where one sheet ends and the next begins. The script then redistributes all sheets in that area using the widest existing sheet as a template, repeating it at regular intervals from the splitting point you selected.

The tool operates on any element zone (layers from -5 through 5, excluding zone 0) and supports interactive visual feedback during placement so you can see exactly how the redistribution will look before confirming.

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | Object (O-Type) |
| Workspace | Model Space |
| Attached To | Element (wall, floor, or roof) |
| Beams Required | None |
| Version | 1.10 (November 2022) |
| Unit System | Millimeters |

This script runs in Model Space and attaches itself to an hsbCAD Element. It modifies the sheets (paneling layers) within a selected zone of the element. The script is fully parametric — if the element geometry changes, the sheet redistribution recalculates automatically.

### Script Classification

| Category | Classification |
|----------|----------------|
| Primary Category | Base |
| Sub-Category | Core Functions |
| Prefix Pattern | `hsb*` |
| Functional Area | Sheet Distribution Management |

## Prerequisites

Before using this tool, ensure the following conditions are met:

### 1. Element Must Exist and Be Calculated

You need a fully calculated hsbCAD Element (wall, floor, or roof) in the drawing. The element must have completed its internal calculation so that sheets are already generated. If the element is in the middle of a regeneration cycle, the script will wait until sheets are available.

**Validation**: The script checks if `el.sheet(nZone).length() > 0`. If no sheets exist, it reports an error and will not insert.

### 2. Sheets Must Be Present in Target Zone

The target zone of the element must contain at least one sheet. If no sheets exist in the selected zone, the script will report:
```
hsbRedistributeSheets no sheet found for zone, [zone number]
```
And will not insert.

### 3. Multiple Zones Required

The element must have at least one zone with a non-zero height beyond zone 0. Elements with only zone 0 cannot use this tool because zone 0 is the structural frame layer and does not typically carry sheet materials.

**Error message if only zone 0 exists**:
```
hsbRedistributeSheets Element has only zone 0
```

### 4. Openings Are Optional

The script automatically handles openings (windows, doors) in the element. Openings are subtracted from the redistributed sheets. If openings divide the sheet area into multiple distribution areas, you can target each area independently.

## Usage Steps

### Step 1: Launch the Script

Insert the **hsbRedistributeSheets** tool from the TSL catalog or command line. The script begins its insertion routine.

**Command line example**:
```lisp
(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbRedistributeSheets")) TSLCONTENT
```

### Step 2: Select the Target Element

The command line prompts:

> **Select the element**

Click on the wall, floor, or roof element whose sheets you want to redistribute. The script examines the element to determine which zones contain valid sheets (zones with `dH() > 0`).

### Step 3: Configure Zone in the Properties Dialog

A properties dialog appears, allowing you to choose the **Zone** where the sheet redistribution should take place. The dialog only lists zones that actually exist in the selected element (zones with a non-zero height).

**Silent mode (catalog entry)**: If you provide a catalog entry name as a keyword during insertion, the script loads the saved properties without showing the dialog. If the keyword matches an existing catalog entry, those values are applied. Otherwise, the "Last Inserted" values are used.

**Example**:
- Insert with keyword: The script uses catalog settings
- Insert without keyword: The standard property dialog is shown

Select the desired zone and confirm by pressing **OK**.

### Step 4: Select Splitting Points (Interactive Jig)

After confirming the zone, the script enters an interactive placement mode. This is the core of the redistribution workflow — the jig system provides real-time visual feedback as you move your cursor.

#### Command Prompt Format

```
Select splitting point for the zone [zone number] [Zone-5/zoNe-4/zoNe-3/zonE-2/ZOne-1/...]
```

The keywords in brackets represent the other valid zones in the element. You can type a zone keyword to switch to a different zone without restarting the tool.

#### Interactive Jig Features

**1. Visual Feedback**

The script highlights the distribution areas on the element as you move your cursor:

- **Green highlight**: When your cursor hovers over a distribution area, it is highlighted in green (color 3), indicating this is the active area
- **Red highlight**: Areas outside the cursor's position are shown in red (color 1), indicating they are inactive
- **Large area detection**: The script creates extended profiles for each distribution area (extending infinitely in the Y direction) to make it easier to select areas even if your cursor is slightly outside the sheet envelope

**2. Sheet Preview**

Once your cursor is within a distribution area, a real-time preview shows how the sheets would be distributed based on the current cursor position:

- **New sheet boundaries**: Displayed as outlines (color 7) showing where the redistributed sheets would be positioned
- **Cross-hatch indicators**: Drawn in the plan view (top view) showing the redistribution extents as vertical hatch marks
- **Previously placed splitting points**: Marked with a circle-and-cross symbol (color 6) at each point you've already clicked in other distribution areas

**3. Distribution Algorithm Preview**

The jig calculates and displays:
- The **typical sheet width** (widest existing sheet in the zone)
- Distribution points at regular intervals from your cursor position
- Sheet clipping to distribution area boundaries
- Opening subtraction from sheets
- Plan view cross-sections showing the redistribution pattern

**4. Click to Place**

Click at the desired position to set a splitting point. The point you click defines where a sheet edge will be located. Sheets are then distributed at regular intervals (matching the typical sheet width) in both directions from this point.

**Position snapping**: If you click outside the sheet envelope, the script automatically snaps your point to the closest valid location within the sheet profile using `ppSheet.closestPointTo(_Pt0)`.

**5. Multiple Placements**

You can continue clicking to place splitting points in additional distribution areas or in other zones:

- **Multiple distribution areas**: Each distribution area can have one splitting point. When you click in an area, the script stores it in a Map structure (`mapNews`) for later creation
- **Zone switching**: Type a zone keyword (e.g., "Zone-5", "zOne-4") at the prompt to switch to another zone without leaving the tool. The display updates to show the sheet layout of the newly selected zone

**6. Finish or Cancel**

- **Finish**: Press **Enter** or **right-click** to confirm all placements. The script creates a separate TSL instance for each splitting point you placed.
- **Cancel**: Press **Escape** to cancel the entire operation. No redistribution will be applied, and any previously placed splitting points in the current session are discarded. The script reports:
  ```
  hsbRedistributeSheets canceled
  ```

### Step 5: Automatic Redistribution

After confirming, the script creates child TSL instances (one per splitting point) and erases the insertion instance. Each child instance then performs the following redistribution:

#### 1. Typical Sheet Identification

The script iterates all sheets in the zone and selects the one with the greatest width (measured along the element's X-axis) as the template.

```c
if (abs((seg.ptStart() - seg.ptEnd()).dotProduct(vecX)) > dWidthTypical)
{
    dWidthTypical = abs((seg.ptStart() - seg.ptEnd()).dotProduct(vecX));
    ppTypical = ppI;
    iTypical = i;
}
```

The typical sheet is extended to the maximum height (Y-direction extent) of all sheets in the zone to ensure full coverage.

#### 2. Distribution Point Calculation

Starting from the splitting point (`_Pt0`), points are generated at intervals equal to the typical sheet width in both the positive and negative X-direction of the element, until the distribution area boundaries are reached.

**Left side distribution**:
```c
while (iContinue && ii < 1000)
{
    ii++;
    Point3d pt = _Pt0 - ii * dWidthTypical * vecX;
    if ((ptLeft.dotProduct(vecX) - pt.dotProduct(vecX) > dWidthTypical ))
    {
        iContinue = false;
    }
    if(iContinue)
    {
        ptDistr.append(pt);
    }
}
```

**Right side distribution**: Similar logic with `+ ii * dWidthTypical * vecX`

The maximum iteration count (1000) ensures the loop terminates even for very long elements.

#### 3. Sheet Creation

The typical sheet (`shTypical`) is duplicated via `dbCopy()` and translated to each distribution point.

```c
for (int i = 0; i < ptDistr.length(); i++)
{
    Sheet shNew;
    shNew = shTypical.dbCopy();
    shNew.transformBy((ptDistr[i] - ptTypicalLeft).dotProduct(vecX) * vecX);
    if (shNew.bIsValid())
    {
        sheetsNew.append(shNew);
    }
}
```

#### 4. Sheet Clipping

New sheets are clipped to the distribution area boundaries and openings using Boolean operations:

**a. Intersect with overall sheet profile**:
```c
for (int j = 0; j < plRings.length(); j++)
{
    if (bIsOp[j])
    {
        // Subtract opening
        Sheet sheetsMod[] = sheetsNew[i].joinRing(plRings[j], _kSubtract);
        // Append to sheetsNew2
        for (int k = 0; k < sheetsMod.length(); k++)
        {
            if (sheetsNew2.find(sheetsMod[k]) < 0)
            {
                sheetsNew2.append(sheetsMod[k]);
            }
        }
    }
}
```

**b. Clip to distribution area**:
```c
// Outer profile
PlaneProfile pp1(eZone.coordSys());
pp1.joinRing(plRingsThis[j], _kAdd);
// Sheet profile
PlaneProfile ppSheet(eZone.coordSys());
plSheet = sheetsNew[i].plEnvelope();
ppSheet.joinRing(plSheet, _kAdd);
// Intersect with typical plane profile
pp1.intersectWith(ppSheet);

PlaneProfile ppSubtract = ppSheet;
ppSubtract.subtractProfile(pp1);

PLine plRingsSh[0];
plRingsSh = ppSubtract.allRings();

for (int k = 0; k < plRingsSh.length(); k++)
{
    Sheet sheetsMod[] = sheetsNew[i].joinRing(plRingsSh[k], _kSubtract);
    // Append non-duplicate results
}
```

#### 5. Opening Handling

All element openings (including their side, top, and bottom gaps) are subtracted from the new sheets:

```c
for (int i = 0; i < sheetsNew.length(); i++)
{
    for (int j = 0; j < openings.length(); j++)
    {
        // Subtract opening
        Sheet sheetsMod[] = sheetsNew[i].joinRing(openings[j].plShape(), _kSubtract);
        // Collect resulting sheets
    }
}
```

**Opening gap expansion**:
The script expands opening shapes to include construction gaps:
- `dGapSide`: Side gaps (left and right)
- `dGapTop`: Top gap
- `dGapBottom`: Bottom gap

These gaps are applied by extending the opening rectangle before subtraction.

#### 6. Additional Opening Subtraction

The script also subtracts expanded opening profiles (`ppAllOpenings`) from all sheets in the element, not just the redistributed area. This ensures consistent opening treatment across all zones:

```c
for (int i = 0; i < _sheetsLast.length(); i++)
{
    for (int j = 0; j < ppAllOpenings.length(); j++)
    {
        PLine pl[] = ppAllOpenings[j].allRings();
        Sheet sheetsMod[] = _sheetsLast[i].joinRing(pl[0], _kSubtract);
        // Collect results
    }
}
```

#### 7. Cleanup

Original sheets in the distribution area are deleted via `dbErase()`:

```c
for (int i=sheets.length()-1; i>=0 ; i--)
{
    if (sheetsThis.find(sheets[i]) >- 1)
    {
        // delete
        Sheet sh = sheets[i];
        sheets.removeAt(i);
        sh.dbErase();
    }
}
```

**Note**: The loop iterates backwards (`i--`) to safely remove items from the array during iteration.

#### 8. Element Group Assignment

New sheets are assigned to the element's zone and group using `assignToElementGroup()`:

```c
for (int i = 0; i < sheetsNew.length(); i++)
{
    sheetsNew[i].assignToElementGroup(el, true, nZone, 'E');
}
```

**Parameters**:
- `el`: The parent element
- `true`: Assign to element group
- `nZone`: Zone number
- `'E'`: Exterior face

The script itself also registers with the element:
```c
assignToElementGroup(el, true, nZone, 'E');
```

This ensures proper tracking during element operations such as regeneration, copying, or deletion.

#### 9. Visual Symbol Placement

A circle-and-cross symbol is placed at the splitting point location (`_Pt0`) to visually indicate where the redistribution is anchored:

**Symbol specifications**:
- Outer circle radius: 50 mm
- Inner circle radius: 45 mm (creating a ring)
- Cross extends to 60 mm from center
- Displayed in the zone's interior face (`'I'`)
- Also projected into the plan view via `addViewDirection(vecY)`
- Color matches the sheet color of the zone

**Elevation view symbol**:
```c
Display dp(1);
dp.elemZone(el, nZone, 'I');
dp.color(iColor);
PLine plCirc0(vecZ);
PLine plCirc1(vecZ);
plCirc0.createCircle(_Pt0, vecZ, U(50));
plCirc1.createCircle(_Pt0, vecZ, U(45));
PlaneProfile ppCirc(plCirc0);
ppCirc.joinRing(plCirc1, _kSubtract);
dp.draw(ppCirc, _kDrawFilled);

// X sign (two crossed rectangles)
PLine plCr(vecZ);
plCr.addVertex(_Pt0 - (vecX + vecY) * U(2.5));
plCr.addVertex(_Pt0 - (vecX - vecY) * U(60));
plCr.addVertex(_Pt0 + (vecX + vecY) * U(2.5));
plCr.addVertex(_Pt0 + (vecX - vecY) * U(60));
plCr.close();
dp.draw(PlaneProfile(plCr), _kDrawFilled);

// Second leg (rotated 90 degrees)
CoordSys csRot;
csRot.setToRotation(90, vecZ, _Pt0);
plCr.transformBy(csRot);
dp.draw(PlaneProfile(plCr), _kDrawFilled);
```

**Plan view symbol**:
```c
Display dpPlan(1);
dpPlan.color(iColor);
dpPlan.elemZone(el, nZone, 'I');
dpPlan.addViewDirection(vecY);

CoordSys csTrans;
csTrans.setToAlignCoordSys(_Pt0, vecX, vecY, vecZ, _Pt0, vecX, -vecZ, vecY);
plCr.transformBy(csTrans);
dpPlan.draw(PlaneProfile(plCr), _kDrawFilled);

csRot.setToRotation(90, vecY, _Pt0);
plCr.transformBy(csRot);
dpPlan.draw(PlaneProfile(plCr), _kDrawFilled);
```

The symbol serves as the grip point for interactive repositioning.

## Properties Panel Parameters

The following parameters are available in the AutoCAD Properties Palette (OPM) after the script is inserted:

### Zone

| Property | Details |
|----------|---------|
| Display Name | Zone |
| Type | Integer (dropdown) |
| Property Index | 0 |
| Category | General |
| Default | 1 (zone 1) |
| Options | Zone-5, zOne-4, zoNe-3, zonE-2, ZOne-1, 1, 2, 3, 4, 5 |
| Description | Defines the Zone where the sheets are to be redistributed |

This parameter selects which zone layer of the element will have its sheets redistributed. The dropdown only shows zones that exist in the attached element (zones with `dH() > 0`).

**Negative zone numbers** represent layers on the exterior side:
- Zone-5: Fifth layer from exterior
- zOne-4: Fourth layer from exterior
- zoNe-3: Third layer from exterior
- zonE-2: Second layer from exterior
- ZOne-1: First layer from exterior (closest to exterior face)

**Positive zone numbers** represent layers on the interior side:
- 1: First layer from interior (closest to interior face)
- 2: Second layer from interior
- 3: Third layer from interior
- 4: Fourth layer from interior
- 5: Fifth layer from interior

**Zone 0** is the structural frame and is excluded from sheet redistribution.

**Dynamic updates**: After insertion, if the element's zone configuration changes (e.g., a zone is deleted or added), the property list dynamically updates to reflect only the currently valid zones. This is achieved by reconstructing the `PropInt` in the calculation phase:

```c
int nZonesValid[0];
for (int iZ=0; iZ<nZones.length(); iZ++)
{
    if(el.zone(nZones[iZ]).dH()>0)
    {
        nZonesValid.append(nZones[iZ]);
    }
}

int iSelected = nZonesValid.find(nZone);
if(iSelected>-1)
{
    nZone = PropInt(0, nZonesValid, sZoneName, iSelected);
}
else
{
    nZone = PropInt(0, nZonesValid, sZoneName, 0);
}
```

### Distribution Range

| Property | Details |
|----------|---------|
| Display Name | Distribution Range |
| Type | Integer |
| Property Index | 1 |
| Category | General |
| Default | 0 (auto-assigned during insertion) |
| Visibility | Hidden |
| Read-Only | Yes |
| Description | Defines the Distribution Area |

This parameter is automatically assigned during the interactive jig placement and is hidden from the user in the Properties Palette. It identifies which distribution area (separated by openings) the splitting point belongs to.

**Distribution area numbering**: Distribution areas are numbered sequentially from left to right along the element's X-axis, starting at 1. The script sorts the distribution areas before numbering:

```c
for (int i = 0; i < ppAreas.length(); i++)
{
    for (int j = 0; j < ppAreas.length() - 1; j++)
    {
        LineSeg segJ = ppAreas[j].extentInDir(vecX);
        LineSeg segJ1 = ppAreas[j + 1].extentInDir(vecX);

        if (segJ.ptMid().dotProduct(vecX) > segJ1.ptMid().dotProduct(vecX))
        {
            ppAreas.swap(j, j + 1);
        }
    }
}
```

**Purpose**: This parameter is used internally to:
- Prevent multiple TSL instances from targeting the same distribution area in the same zone
- Identify which area needs recalculation when the element changes

**Validation**: If `nDistributionArea < 1`, the script sets it to 1 and reports:
```
hsbRedistributeSheets distribution area must be a positive integer number
```

If `nDistributionArea > ppAreas.length()`, the script erases itself (the distribution area no longer exists, possibly due to element modification).

You do not need to set this value manually. It is determined by where you click during the interactive jig phase.

## Right-Click Menu

No custom right-click context menu entries are defined by this script.

However, the script does register a **grip point drag** action on the insertion point (`_Pt0`). This means you can interact with the tool after placement by using standard AutoCAD grip editing.

### Grip Point Drag

**Purpose**: Allows you to interactively reposition the splitting point after insertion without deleting and re-inserting the tool.

**How to use**:
1. Select the TSL instance (click on the circle-and-cross symbol)
2. Click on the blue grip point at the center of the symbol
3. Drag the grip to a new position along the element surface
4. Release the mouse button

**What happens**:
- The script detects the grip drag via `_bOnGripPointDrag && (_kExecuteKey=="_Pt0")`
- The full sheet redistribution algorithm runs again with the new splitting point location
- All sheets in the distribution area are regenerated based on the new position
- The visual symbol moves to the new location
- The element updates automatically

**Registration**:
```c
addRecalcTrigger(_kGripPointDrag, "_Pt0");
```

This provides a convenient way to fine-tune the redistribution without restarting the tool.

**Position correction**: If you drag the grip outside the valid sheet envelope, the script automatically snaps it to the closest valid position within the sheet profile:

```c
if(ppSheetOuter.pointInProfile(_Pt0)==_kPointOutsideProfile)
    _Pt0 = ppSheet.closestPointTo(_Pt0);
```

## Technical Details

### Script Metadata

| Detail | Value |
|--------|-------|
| Script Name | hsbRedistributeSheets |
| Script Type | O (Object) |
| Version | 1.10 (November 7, 2022) |
| Author | Marsel Nakuci (marsel.nakuci@hsbcad.com) |
| Unit System | Millimeters (`U(1,"mm")`) |
| Implicit Insert | Yes (`#ImplInsert 1`) |
| DXA Output | Yes (`#DxaOut 1`) |
| File State | 1 |
| Beams Required | 0 |

### Version History

| Version | Date | Description |
|---------|------|-------------|
| 1.10 | Nov 7, 2022 | HSB-16939: Support canceling TSL during insertion jig |
| 1.9 | Jan 20, 2021 | HSB-8707: Improve prompt in jig, symbol not outside the envelope |
| 1.8 | Jan 19, 2021 | HSB-8707: Support jig, multiple enhancements |
| 1.7 | Sep 20, 2019 | HSB-5536: Only one TSL possible for a particular distribution area of an element |
| 1.6 | Sep 19, 2019 | HSB-5536: Remove openings from all the sheets of the element |
| 1.5 | Sep 19, 2019 | HSB-5536: Add property distribution area |
| 1.4 | Sep 18, 2019 | HSB-5536: Prompt a click point for each distribution area and generate a TSL |
| 1.3 | Aug 27, 2019 | Add display symbol in plan view |
| 1.2 | Aug 26, 2019 | Guard if (iTypical < 0) |
| 1.1 | Aug 26, 2019 | Working version |
| 1.0 | Aug 23, 2019 | Initial version |

### Insertion Mechanism

The script uses the `_bOnInsert` flag to manage the insertion phase. During insertion, it:

1. **Element Selection**: Prompts for element selection via `getElement("Select the element")`

2. **Zone Validation**: Validates zones and sheets, filtering only zones with `dH() > 0`

3. **Property Configuration**: Uses `showDialog()` for property configuration, or loads catalog values if a keyword is provided via `setPropValuesFromCatalog()`

4. **Distribution Area Analysis**: Analyzes the element's sheet profile to identify distribution areas separated by openings:
   ```c
   PLine plRings[] = ppAllSheets.allRings();
   int bIsOp[] = ppAllSheets.ringIsOpening();

   for (int i = 0; i < bIsOp.length(); i++)
   {
       if (bIsOp[i])
       {
           // It's an opening
           continue;
       }
       PlaneProfile ppThisArea(eZone.coordSys());
       ppThisArea.joinRing(plRings[i], _kAdd);
       ppAreas.append(ppThisArea);
   }
   ```

5. **Interactive Jig Loop**: Enters a `PrPoint.goJig()` loop for interactive splitting point placement with real-time visual preview:
   ```c
   while(iCount<100 && iContinue)
   {
       PrPoint ssP(sStringPrompt);
       int nGoJig = -1;

       while (nGoJig != _kOk && nGoJig!= _kNone)
       {
           nGoJig = ssP.goJig(strJigAction1, mapArgs);

           if (nGoJig == _kOk)
           {
               ptLast = ssP.value();
               // Store in mapNews
           }
           else if (nGoJig == _kKeyWord)
           {
               // Zone switching logic
           }
           else if (nGoJig == _kCancel)
           {
               iContinue = false;
               eraseInstance();
               return;
           }
           else if(nGoJig==_kNone)
           {
               // Create child TSL instances
               for (int itsl=0; itsl<mapNews.length(); itsl++)
               {
                   Map map = mapNews.getMap(itsl);
                   nProps[0] = map.getInt("Zone");
                   nProps[1] = map.getInt("Area");
                   ptsTsl[0] = map.getPoint3d("PtTsl");
                   tslNew.dbCreate(scriptName(), vecXTsl, vecYTsl, gbsTsl, entsTsl,
                       ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
               }
               iContinue = false;
               eraseInstance();
               return;
           }
       }
   }
   ```

6. **Child Instance Creation**: Creates child TSL instances (one per splitting point) via `TslInst.dbCreate()`, passing:
   - Zone number (property index 0)
   - Distribution area index (property index 1)
   - Splitting point (`ptsTsl[0]`)

7. **Insertion Instance Cleanup**: The insertion instance itself is erased after creating the child instances:
   ```c
   eraseInstance();
   return;
   ```

**Important**: The insertion instance does NOT perform the redistribution. It only creates child instances, which then perform the actual redistribution in their own calculation phases.

### Jig System

The interactive jig (`_bOnJig` with key `strJigAction1`) provides:

**1. Real-time Distribution Area Visualization**

The jig receives distribution area profiles via the `mapArgs` Map:
```c
for (int i=0; i<ppAreas.length(); i++)
{
    mapArgs.setPlaneProfile("pp"+i, ppAreas[i]);
}
mapArgs.setEntity("element", el);
mapArgs.setInt("iZone", nZone);
mapArgs.setPlaneProfile("sheet", ppSheet);
```

During jig execution:
```c
if (_bOnJig && _kExecuteKey==strJigAction1)
{
    Point3d ptJig = _Map.getPoint3d("_PtJig");
    PlaneProfile ppSheet = _Map.getPlaneProfile("sheet");
    PlaneProfile ppAreasMap[0];

    for (int i=0; i<100; i++)
    {
        if(_Map.hasPlaneProfile("pp"+i))
        {
            ppAreasMap.append(_Map.getPlaneProfile("pp"+i));
        }
        else
        {
            break;
        }
    }
}
```

**2. Active Area Detection**

The jig creates "large" profiles extending infinitely in the Y-direction to make area selection easier:
```c
PlaneProfile ppAreasMapLarge[0];
for (int i=0; i<ppAreasMap.length(); i++)
{
    LineSeg seg = ppAreasMap[i].extentInDir(vecX);
    double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
    PlaneProfile ppLarge(ppAreasMap[i].coordSys());
    PLine plLarge(vecZ);
    plLarge.createRectangle(LineSeg(seg.ptMid() - .5 * dX * vecX - U(10e7) * vecY,
                                     seg.ptMid() + .5 * dX * vecX + U(10e7) * vecY),
                            vecX, vecY);
    ppLarge.joinRing(plLarge, _kAdd);
    ppAreasMapLarge.append(ppLarge);
}

int iAreaSelected=-1;
for (int i=0; i<ppAreasMap.length(); i++)
{
    if(ppAreasMapLarge[i].pointInProfile(ptJig)==_kPointInProfile)
    {
        iAreaSelected = i;
        break;
    }
}
```

**3. Sheet Redistribution Preview**

Once an area is selected, the jig computes a full preview of the redistributed sheets using the same algorithm as the final calculation:

- Identifies typical sheet (widest sheet in zone)
- Calculates distribution points at intervals of `dWidthTypical`
- Creates PlaneProfile copies of the typical sheet at each distribution point
- Clips to distribution area and subtracts openings
- Displays results in both elevation view (color 7) and plan view (cross-hatching)

**4. Plan View Rendering**

The jig draws cross-hatch indicators in the plan view:
```c
PlaneProfile ppTop(Plane(ptOrg, vecY));
LineSeg seg = ppsNew[i].extentInDir(vecX);
Point3d pt1 = seg.ptStart();
pt1 += vecY * vecY.dotProduct(ptOrg - pt1);
pt1 += vecZ * vecZ.dotProduct(eZone.ptOrg() - pt1);
Point3d pt2 = seg.ptEnd();
pt2 += vecY * vecY.dotProduct(ptOrg - pt2);
pt2 += vecZ * vecZ.dotProduct(eZone.ptOrg()+eZone.dH()*eZone.vecZ() - pt2);
LineSeg lSeg1(pt1, pt2);
dpJig.draw(lSeg1);

PLine plTop(vecY);
plTop.createRectangle(lSeg1, vecX, vecZ);
ppTop.joinRing(plTop, _kAdd);
dpJig.draw(ppTop);
dpJig2.draw(ppTop, _kDrawFilled, 15);
```

This creates vertical hatching showing the sheet boundaries as seen from above.

**5. Previously Placed Splitting Points**

The jig displays already-placed splitting points via the `mapNews` structure:
```c
Map mapNews = _Map.getMap("mapNews");
dpJig.color(6);
for (int i=0; i<mapNews.length(); i++)
{
    Map map = mapNews.getMap(i);
    Point3d pt = map.getPoint3d("PtTsl");

    // Draw circle-and-cross symbol at pt
    PLine plCirc0(vecZ);
    plCirc0.createCircle(pt, vecZ, U(50));
    // ... (same symbol drawing code as final display)
}
```

**6. Zone Switching**

When the user types a zone keyword, the jig rebuilds the distribution area profiles for the new zone:
```c
else if (nGoJig == _kKeyWord)
{
    // Clear old profiles
    for (int i=0; i<100; i++)
    {
        if(mapArgs.hasPlaneProfile("pp"+i))
        {
            String sKey = "pp"+i;
            mapArgs.removeAt(sKey, true);
        }
        else
        {
            break;
        }
    }

    // Get selected zone from keyword
    int iZoneSelected = nZonesThis[ssP.keywordIndex()];
    mapArgs.setInt("iZone", iZoneSelected);
    nZone.set(nZonesValid[nZonesValid.find(iZoneSelected)]);

    // Rebuild distribution areas for new zone
    ElemZone eZone = el.zone(iZoneSelected);
    PlaneProfile ppAllSheets(eZone.coordSys());
    Sheet sheets[] = el.sheet(iZoneSelected);
    // ... (recalculate ppAreas)

    for (int i=0; i<ppAreas.length(); i++)
    {
        mapArgs.setPlaneProfile("pp"+i, ppAreas[i]);
    }

    // Update prompt string
    sStringPrompt = T(sStringStart+" "+iZoneSelected+" ["+sStringOptionsNew+"]|");
    ssP = PrPoint(sStringPrompt);
}
```

### Sheet Redistribution Algorithm

The core algorithm runs in the non-jig calculation phase for each child instance:

**Step 1: Typical Sheet Identification**

```c
double dWidthTypical = -10;
PlaneProfile ppTypical(eZone.coordSys());
Point3d ptTypicalLeft;
int iTypical = -1;

for (int i = 0; i < sheets.length(); i++)
{
    PLine pli = sheets[i].plEnvelope();
    PlaneProfile ppI(eZone.coordSys());
    ppI.joinRing(pli, _kAdd);

    LineSeg seg = ppI.extentInDir(vecX);
    if (abs((seg.ptStart() - seg.ptEnd()).dotProduct(vecX)) > dWidthTypical)
    {
        dWidthTypical = abs((seg.ptStart() - seg.ptEnd()).dotProduct(vecX));
        ppTypical = ppI;
        ptTypicalLeft = seg.ptStart();
        if (seg.ptStart().dotProduct(vecX) > seg.ptEnd().dotProduct(vecX))
        {
            ptTypicalLeft = seg.ptEnd();
        }
        PLine pl;
        pl.createRectangle(seg, vecX, vecY);
        PlaneProfile ppTypical2(pl);
        ppTypical = ppTypical2;
        iTypical = i;
    }
}
```

The typical sheet is extended to the maximum Y-extent of all sheets:
```c
LineSeg lSeg = ppTypical.extentInDir(vecX);
Point3d pt1 = lSeg.ptStart();
Point3d pt2 = lSeg.ptEnd();
pt1 += (ptMinY - pt1).dotProduct(vecY) * vecY;
pt2 += (ptMaxY - pt2).dotProduct(vecY) * vecY;
LineSeg lSegMax(pt1, pt2);
PLine pl;
pl.createRectangle(lSegMax, vecX, vecY);
PlaneProfile ppTypical2(pl);
ppTypical = ppTypical2;
```

**Step 2: Distribution Point Calculation**

```c
Point3d ptDistr[0];
ptDistr.append(_Pt0);

LineSeg seg = ppAllSheetsThis.extentInDir(vecX);
Point3d ptLeft = seg.ptStart();
Point3d ptRight = seg.ptEnd();
if (ptLeft.dotProduct(vecX) > ptRight.dotProduct(vecX))
{
    ptLeft = seg.ptEnd();
    ptRight = seg.ptStart();
}

// Points on the left of _Pt0
int iContinue = true;
int ii = 0;
while (iContinue && ii < 1000)
{
    ii++;
    Point3d pt = _Pt0 - ii * dWidthTypical * vecX;
    if ((ptLeft.dotProduct(vecX) - pt.dotProduct(vecX) > dWidthTypical))
    {
        iContinue = false;
    }
    if(iContinue)
    {
        ptDistr.append(pt);
    }
}

// Points on the right of _Pt0
iContinue = true;
ii = 0;
while (iContinue && ii < 1000)
{
    ii++;
    Point3d pt = _Pt0 + ii * dWidthTypical * vecX;
    if (ptRight.dotProduct(vecX) < pt.dotProduct(vecX))
    {
        iContinue = false;
    }
    if(iContinue)
    {
        ptDistr.append(pt);
    }
}

// Order points in direction of vecX
Line ln(_Pt0, vecX);
ptDistr = ln.orderPoints(ptDistr);
```

**Step 3: Sheet Creation**

```c
Sheet shTypical = sheets[iTypical];
PLine plRings[] = ppTypical.allRings();
shTypical.joinRing(plRings[0], _kAdd);

Sheet sheetsNew[0];
for (int i = 0; i < ptDistr.length(); i++)
{
    Sheet shNew;
    shNew = shTypical.dbCopy();
    shNew.transformBy((ptDistr[i] - ptTypicalLeft).dotProduct(vecX) * vecX);

    if (shNew.bIsValid())
    {
        sheetsNew.append(shNew);
    }
}
```

**Step 4: Opening Subtraction (Multiple Passes)**

The script performs opening subtraction in multiple passes to ensure comprehensive coverage:

**a. Subtract openings from overall sheet profile**:
```c
PLine plRings[] = ppAllSheets.allRings();
int bIsOp[] = ppAllSheets.ringIsOpening();

Sheet sheetsNew2[0];
for (int i=0; i<sheetsNew.length(); i++)
{
    for (int j = 0; j < plRings.length(); j++)
    {
        if (bIsOp[j])
        {
            Sheet sheetsMod[] = sheetsNew[i].joinRing(plRings[j], _kSubtract);
            for (int k = 0; k < sheetsMod.length(); k++)
            {
                if (sheetsNew2.find(sheetsMod[k]) < 0)
                {
                    sheetsNew2.append(sheetsMod[k]);
                }
            }
        }
    }
}
```

**b. Clip to distribution area and subtract distribution area openings**:
```c
PLine plRingsThis[] = ppAllSheetsThis.allRings();
int bIsOpThis[] = ppAllSheetsThis.ringIsOpening();

for (int i = 0; i < sheetsNew.length(); i++)
{
    for (int j = 0; j < plRingsThis.length(); j++)
    {
        if (bIsOpThis[j])
        {
            Sheet sheetsMod[] = sheetsNew[i].joinRing(plRingsThis[j], _kSubtract);
            // Collect results
        }
        else
        {
            // Intersect with outer profile
            PlaneProfile pp1(eZone.coordSys());
            pp1.joinRing(plRingsThis[j], _kAdd);

            PlaneProfile ppSheet(eZone.coordSys());
            PLine plSheet = sheetsNew[i].plEnvelope();
            ppSheet.joinRing(plSheet, _kAdd);

            pp1.intersectWith(ppSheet);

            PlaneProfile ppSubtract = ppSheet;
            ppSubtract.subtractProfile(pp1);

            if (ppSubtract.area() < pow(dEps, 2))
            {
                continue;
            }

            PLine plRingsSh[0];
            plRingsSh = ppSubtract.allRings();

            for (int k = 0; k < plRingsSh.length(); k++)
            {
                Sheet sheetsMod[] = sheetsNew[i].joinRing(plRingsSh[k], _kSubtract);
                // Collect results
            }
        }
    }
}
```

**c. Subtract individual element openings**:
```c
for (int i = 0; i < sheetsNew.length(); i++)
{
    for (int j = 0; j < openings.length(); j++)
    {
        Sheet sheetsMod[] = sheetsNew[i].joinRing(openings[j].plShape(), _kSubtract);
        // Collect results
    }
}
```

**d. Subtract expanded opening profiles from all element sheets**:
```c
Sheet sheetsLast[] = el.sheet();

for (int i = 0; i < sheetsLast.length(); i++)
{
    for (int j = 0; j < openings.length(); j++)
    {
        Sheet sheetsMod[] = sheetsLast[i].joinRing(openings[j].plShape(), _kSubtract);
        // Collect results
    }
}

Sheet _sheetsLast[] = el.sheet();

for (int i = 0; i < _sheetsLast.length(); i++)
{
    for (int j = 0; j < ppAllOpenings.length(); j++)
    {
        PLine pl[] = ppAllOpenings[j].allRings();
        Sheet sheetsMod[] = _sheetsLast[i].joinRing(pl[0], _kSubtract);
        // Collect results
    }
}
```

**Step 5: Cleanup and Assignment**

```c
// Delete original sheets in distribution area
for (int i=sheets.length()-1; i>=0 ; i--)
{
    if (sheetsThis.find(sheets[i]) >- 1)
    {
        Sheet sh = sheets[i];
        sheets.removeAt(i);
        sh.dbErase();
    }
}

// Assign new sheets to element
for (int i = 0; i < sheetsNew.length(); i++)
{
    sheetsNew[i].assignToElementGroup(el, true, nZone, 'E');
}

// Register TSL with element
assignToElementGroup(el, true, nZone, 'E');
```

### Duplicate Prevention

The script enforces a rule that only one `hsbRedistributeSheets` instance can exist per distribution area per zone of a given element.

**Duplicate detection logic**:
```c
TslInst tslAttached[] = el.tslInst();
for (int i = 0; i < tslAttached.length(); i++)
{
    TslInst tsli = tslAttached[i];

    if (tsli.scriptName() != "hsbRedistributeSheets")
    {
        continue;
    }

    if (tsli.propInt(1) != nDistributionArea || tsli.propInt(0) != nZone)
    {
        // Different distribution area or zone
        continue;
    }

    if (tsli == _ThisInst)
    {
        // This is the current instance
        continue;
    }

    // Found a duplicate - erase it
    tsli.dbErase();
}
```

**When is this check performed?**
- During every recalculation of a child instance (not during insertion)
- Before the redistribution algorithm runs

**Why is this necessary?**
- Prevents conflicting redistributions in the same distribution area
- Ensures the most recently placed instance takes precedence
- User does not need to manually remove old instances

**Important**: This check compares:
- `propInt(0)`: Zone number
- `propInt(1)`: Distribution area number

If both match, the older instance is erased.

### Display Symbol

The circle-and-cross symbol serves multiple purposes:

1. **Visual feedback**: Shows where the redistribution is anchored
2. **Grip point**: Provides an interactive handle for repositioning
3. **Documentation**: Marks the splitting point location in shop drawings

**Symbol specifications**:
- **Outer circle**: Radius 50 mm
- **Inner circle**: Radius 45 mm (creating a 5 mm ring)
- **Cross legs**: Two rectangles, each 5 mm wide and 120 mm long (60 mm in each direction from center)
- **Rotation**: Second cross leg rotated 90° around vecZ
- **Color**: Matches the sheet color of the zone
- **Visibility**: Drawn in both elevation view and plan view

**Elevation view**:
- Displayed on the interior face (`'I'`) of the zone
- Uses `Display.elemZone(el, nZone, 'I')` to anchor to zone face
- Orientation: Perpendicular to vecZ (facing out from the zone surface)

**Plan view**:
- Displayed via `addViewDirection(vecY)` (top view)
- Transformed to align with plan orientation using coordinate system transformation
- Cross legs rotated 90° around vecY to remain visible when viewed from above

**Why a circle-and-cross?**
- **Distinctive**: Easy to spot in complex drawings
- **Symmetrical**: Visible from multiple viewpoints
- **Grip-friendly**: Provides a clear target for mouse interaction
- **Non-obtrusive**: Ring design minimizes visual clutter

### Element Group Assignment

The script registers itself with the element's tracking system:
```c
assignToElementGroup(el, true, nZone, 'E');
```

**Parameters**:
- `el`: The parent element
- `true`: Enable assignment to element group
- `nZone`: Zone number (property index 0)
- `'E'`: Exterior face

**Purpose**:
- Ensures the TSL is included in element operations (copy, move, delete)
- Triggers recalculation when the element regenerates
- Maintains parent-child relationship in the drawing database

**Recalculation triggers**:
- Element geometry changes (beam movement, size changes)
- Opening modifications (added, removed, resized)
- Zone configuration changes
- Grip point drag on `_Pt0`

### Grip Point Interaction

**Registration**:
```c
addRecalcTrigger(_kGripPointDrag, "_Pt0");
```

**Detection**:
```c
if (_bOnGripPointDrag && (_kExecuteKey=="_Pt0"))
{
    // Full redistribution algorithm runs with new _Pt0 position
}
```

**Workflow**:
1. User selects TSL instance
2. User drags the grip at `_Pt0` to new position
3. Script detects grip drag
4. Position is validated and snapped if necessary
5. Full redistribution algorithm runs
6. Sheets are regenerated
7. Display symbol moves to new position

**Position correction**:
```c
PlaneProfile ppSheetOuter(ppSheet.coordSys());
PLine pls[] = ppSheet.allRings(true, false);
for (int i=0; i<pls.length(); i++)
{
    ppSheetOuter.joinRing(pls[i], _kAdd);
}

if(ppSheetOuter.pointInProfile(_Pt0)==_kPointOutsideProfile)
    _Pt0 = ppSheet.closestPointTo(_Pt0);
```

This ensures the splitting point always lies within valid sheet geometry.

### Debug Support

The script supports the hsbCAD debug controller system:

**Activation**:
```c
int bDebug = _bOnDebug;
MapObject mo("hsbTSLDev", "hsbTSLDebugController");
if (mo.bIsValid())
{
    Map m = mo.map();
    for (int i = 0; i < m.length(); i++)
    {
        if (m.getString(i) == scriptName())
        {
            bDebug = true;
            break;
        }
    }
}

if(bDebug)
    reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());
```

**Debug messages**:
- Script start with instance handle
- Distribution area calculations
- Sheet creation progress
- Error conditions

**How to enable**:
1. Create a MapObject named `hsbTSLDebugController` in the `hsbTSLDev` dictionary
2. Add the script name "hsbRedistributeSheets" to the Map
3. The script will print diagnostic messages to the command line

**Purpose**:
- Troubleshooting redistribution issues during development
- Verifying distribution point calculations
- Tracking sheet creation and deletion

### Point Snapping During Jig

During the interactive jig, the splitting point is automatically projected onto the zone's plane:

**Projection to zone plane**:
```c
Point3d ptOrgZone = eZone.ptOrg();
_Pt0.transformBy((ptOrgZone - _Pt0).dotProduct(vecZ) * vecZ);
```

**Snapping to valid sheet area**:
```c
PlaneProfile ppSheetOuter(ppSheet.coordSys());
PLine pls[] = ppSheet.allRings(true, false);
for (int i=0; i<pls.length(); i++)
{
    ppSheetOuter.joinRing(pls[i], _kAdd);
}

if(ppSheetOuter.pointInProfile(ptTsl)==_kPointOutsideProfile)
    ptTsl = ppSheet.closestPointTo(ptTsl);
```

This ensures:
- The splitting point always lies on the zone surface
- The splitting point is within the valid sheet coverage area
- User clicks near the sheet edge are automatically adjusted

### Performance Considerations

The script performs extensive geometric calculations:

**Expensive operations**:
1. **PlaneProfile Boolean operations**: `intersectWith()`, `subtractProfile()`, `joinRing()` with `_kSubtract`
2. **Sheet copying**: `shTypical.dbCopy()` for each distribution point
3. **Sheet Boolean operations**: `sheetsNew[i].joinRing()` for clipping and opening subtraction
4. **Opening subtraction loops**: Multiple nested loops for comprehensive opening handling

**Optimization strategies**:

1. **Early returns**: If `iTypical < 0` (element regenerating), return immediately without calculating
2. **Area threshold**: Skip sheets with area < `pow(dEps, 2)` to avoid processing tiny fragments
3. **Duplicate checking**: Prevent adding duplicate sheets to `sheetsNew2` array
4. **Limited iterations**: Maximum 1000 distribution points (prevents infinite loops for extremely long elements)
5. **Jig caching**: Distribution areas and sheet profiles are calculated once during insertion and passed via Map

**When to expect delays**:
- Elements with many openings (10+)
- Very long elements requiring 50+ sheet copies
- Complex sheet geometries with multiple holes
- Large zone heights (requiring tall sheet templates)

**Normal behavior**: On elements with 2-5 openings and 10-20 sheets, redistribution completes in under 2 seconds.

### Automatic Recalculation on Element Changes

Because this is a parametric tool, any change to the parent element triggers a recalculation:

**Recalculation triggers**:
- **Beam movement**: Element coordinate system changes
- **Element resizing**: Width, height, or length changes
- **Opening modifications**: Added, removed, or resized openings
- **Zone configuration changes**: Zone added, removed, or resized
- **Sheet regeneration**: Element recalculation that regenerates sheets

**Waiting for sheets**:
```c
sheets = el.sheet(nZone);
if (sheets.length() == 0)
{
    // When element is regenerated, the sheets are deleted
    // TSL will wait until the element is calculated and sheets are generated
    return;
}
```

If the element is in the middle of a regeneration and sheets are temporarily unavailable, the script exits early. hsbCAD will trigger the script again once the element calculation is complete.

**Self-deletion conditions**:
- Selected zone no longer exists (`eZone.dH() == 0`)
- Distribution area exceeds available areas (`nDistributionArea > ppAreas.length()`)
- No element found (`_Element.length() < 1`)
- Element has only zone 0

In these cases, the script erases itself and reports the reason to the command line.

## Tips and Best Practices

### Controlling Sheet Joint Positions

The splitting point you click determines the exact position where one sheet ends and the next begins. All other sheet joints are then placed at regular intervals (equal to the typical sheet width) in both directions from this point.

**To align a sheet joint with a specific stud or structural member**:
1. During the jig, move your cursor over the stud location
2. The preview will show the sheet joint at that position
3. Click to confirm
4. All other joints will be spaced at regular intervals from this point

**To avoid a joint at a specific location**:
1. Click at a position offset by half the typical sheet width from the location to avoid
2. This ensures the avoided location falls in the middle of a sheet, not at a joint

### Working with Multiple Distribution Areas

When an element has openings that divide the sheet coverage into separate areas, each area operates independently.

**Single insertion session for multiple areas**:
1. During the jig, click in the first distribution area
2. Click in the second distribution area
3. Click in the third distribution area
4. Press Enter to confirm all placements
5. The script creates one TSL instance per area

**Why this is useful**:
- Saves time (single insertion for entire element)
- Ensures consistent sheet width across all areas
- All areas use the same typical sheet template

**Limitations**:
- Each area can have only one splitting point
- Areas are processed independently (no cross-area distribution)

### Moving the Splitting Point After Placement

After the tool is inserted, you can use AutoCAD's grip editing to reposition the splitting point.

**How to reposition**:
1. Select the TSL instance (click on the circle-and-cross symbol)
2. Click on the blue grip point at the center of the symbol
3. Drag to a new position
4. Release the mouse button
5. The redistribution recalculates automatically

**Why this is faster than deleting and re-inserting**:
- No need to select the element again
- No need to select the zone again
- No need to confirm in the properties dialog
- Immediate visual feedback during dragging

**Position validation**: If you drag the grip outside the valid sheet area, it automatically snaps to the closest valid position.

### Switching Zones During Placement

During the interactive jig, you can switch zones by typing the zone keyword shown in the command prompt brackets.

**Example workflow**:
```
Select splitting point for the zone 1 [Zone-5/zOne-4/zoNe-3]
```

1. Type "Zone-5" and press Enter
2. The display updates to show zone -5 sheets
3. The prompt changes to:
   ```
   Select splitting point for the zone -5 [1/zOne-4/zoNe-3]
   ```
4. Click to place a splitting point in zone -5
5. Type "1" and press Enter to switch back to zone 1
6. Continue placing splitting points

**Why this is useful**:
- Redistribute sheets in multiple zones in a single operation
- Maintain consistent splitting point strategy across zones
- Faster than inserting the tool separately for each zone

### One Instance Per Area Rule

The script enforces a rule: **only one hsbRedistributeSheets instance can exist per distribution area per zone of a given element**.

**What happens if you insert a second instance**:
1. You select the same element, zone, and distribution area
2. The script detects an existing instance with matching zone and area
3. The older instance is automatically deleted
4. The new instance replaces it

**User benefit**: You don't need to manually search for and delete old instances. Just insert a new one, and the old one is cleaned up automatically.

**Important**: This rule applies per distribution area. You can have multiple instances in different distribution areas or different zones of the same element.

### Elements with Only Zone 0

If the element has only zone 0 (the structural frame), this tool cannot be used because zone 0 does not carry sheet materials.

**Error message**:
```
hsbRedistributeSheets Element has only zone 0
```

**Solution**: Ensure your element has at least one additional zone with sheets before attempting to use this script. For example:
- Zone 1: Interior sheathing
- Zone 2: Exterior sheathing
- Zone -1: Gypsum board
- Zone -2: OSB sheathing

The script will then allow you to select from these zones.

### Troubleshooting: Script Disappears Immediately

If the script deletes itself right after insertion, check the command line for diagnostic messages.

**Common causes and error messages**:

| Message | Cause | Solution |
|---------|-------|----------|
| `selected zone does not exist` | Zone was deleted or element was modified | Select a different zone |
| `no sheet found for zone, [number]` | Element not fully calculated yet | Wait for element calculation to complete |
| `Element has only zone 0` | No zones with sheets | Add zones to element definition |
| `no element found` | Element reference lost | Re-insert and select element again |
| `unexpected error` | No valid distribution areas found | Check element sheet coverage |

**Silent deletion (no message)**:
- Distribution area index exceeds available areas (element was modified)
- Element reference became invalid

**Debugging tip**: Enable debug mode by creating a `hsbTSLDebugController` MapObject containing the script name. This will print additional diagnostic messages.

### Understanding the Visual Symbol

After successful insertion, a circle-and-cross symbol appears at the splitting point location.

**Symbol characteristics**:
- **Color**: Matches the sheet color of the affected zone
- **Size**: 50 mm outer radius, 45 mm inner radius (5 mm ring)
- **Cross**: Two perpendicular rectangles, 60 mm long (120 mm total)
- **Visibility**: Visible in both elevation view (on zone interior face) and plan view (top view)
- **Function**: Serves as the grip point for dragging to reposition

**Visibility in different views**:
- **3D isometric view**: Visible on zone face
- **Elevation view**: Visible on zone interior face
- **Plan view**: Visible as cross-hatch symbol projected downward
- **Paper space layouts**: Visible if zone is displayed

**If symbol is not visible**:
- Check if the zone is currently displayed
- Verify the zone face orientation (interior vs. exterior)
- Check layer visibility settings

### Performance Considerations

The script performs extensive geometric calculations involving plane profiles, Boolean operations, and sheet clipping.

**On elements with many openings or a large number of sheets**:
- The recalculation may take a few moments (2-10 seconds)
- This is normal behavior
- The redistribution will complete once all calculations finish
- Progress can be monitored via command line messages (if debug mode is enabled)

**Performance tips**:
- **Minimize openings**: Fewer openings = faster calculation
- **Use standard sheet sizes**: Consistent sheet widths reduce complexity
- **Avoid very long elements**: Elements over 50 meters may have longer calculation times
- **Wait for element calculation**: Don't insert the tool during element regeneration

**Expected performance**:
- Elements with 0-5 openings: < 2 seconds
- Elements with 6-15 openings: 2-5 seconds
- Elements with 16+ openings: 5-10 seconds

### Automatic Recalculation on Element Changes

Because this is a parametric tool, any change to the parent element triggers a recalculation.

**Triggers**:
- Moving beams in the element
- Adding or removing openings
- Resizing the element
- Changing zone configuration
- Regenerating the element

**What happens**:
1. Element modification triggers TSL recalculation
2. Script checks if zone and distribution area still exist
3. If valid, redistribution algorithm runs again with current `_Pt0` position
4. Sheets are regenerated
5. Display symbol updates

**If element is regenerated and sheets are temporarily unavailable**:
- Script exits early (returns without error)
- hsbCAD triggers recalculation again once sheets are available
- Redistribution completes normally on second trigger

**User benefit**: You don't need to manually update the redistribution. It happens automatically as you modify the element.

### Using Catalog Entries

You can save your preferred zone settings as a catalog entry for reuse.

**How to create a catalog entry**:
1. Insert the script normally
2. Configure the zone in the properties dialog
3. Right-click on the TSL instance
4. Select "Add to catalog" from the context menu
5. Enter a catalog name (e.g., "Zone1_Redistribution")
6. Confirm

**How to use a catalog entry**:
1. Insert the script with the catalog name as a keyword:
   ```
   (defun c:ZONE1REDIST() (hsb_ScriptInsert "hsbRedistributeSheets" "Zone1_Redistribution")) ZONE1REDIST
   ```
2. The script loads the saved zone setting without showing the dialog
3. Interactive jig starts immediately with the saved zone

**Why this is useful**:
- Standardizes workflows (always use zone 1, for example)
- Saves time (no dialog clicking)
- Ensures consistency across projects

**Limitations**:
- Catalog entries only save the Zone property (not distribution area)
- Distribution area is always determined by where you click during the jig

## Related Scripts

### Sheet Distribution Tools

- **hsbSheetDistribution**: Automatic sheet distribution for element zones. This is the default distribution tool that `hsbRedistributeSheets` modifies.
- **hsbSplitSheets**: Manually split a single sheet into multiple sheets along a specified line.

### Element Modification Tools

- **hsb_CreateElement**: Create new wall, floor, or roof elements.
- **HSB_E-Insulation**: Add insulation layers to element zones.
- **HSB_E-NailClusters**: Define nailing patterns for sheet-to-beam connections.

### Sheet-Related Tools

- **hsbCLT-Opening**: Create openings in CLT panels (cross-laminated timber).
- **hsbCLT-Slot**: Create slots and notches in CLT panels.
- **hsb_SIP-CoverStrips**: Add cover strips to SIP panel joints.

### Shop Drawing Tools

- **sd_BeamAssembly**: Generate shop drawings for beam assemblies.
- **sd_WallShopDrawing**: Create wall panel shop drawings showing sheet layout.
- **NA_WALL_SHOP_DRAWING**: North America specific wall shop drawing tool.

## Frequently Asked Questions

**Q: Can I redistribute sheets in zone 0?**

A: No. Zone 0 is the structural frame layer and does not typically carry sheet materials. The script requires zones with non-zero height (zones -5 through -1, or 1 through 5).

**Q: What happens if I move an opening after redistributing sheets?**

A: The script automatically recalculates. The redistribution pattern remains anchored at the splitting point, and sheets are clipped to the new opening boundaries.

**Q: Can I have different typical sheet widths in different distribution areas?**

A: No. The script identifies a single "typical sheet" (the widest existing sheet in the zone) and uses it as the template for all distribution areas in that zone. All areas will have the same sheet width.

**Q: Can I redistribute sheets in multiple zones at once?**

A: Yes, during the interactive jig. Type zone keywords to switch zones, click to place splitting points in each zone, then press Enter to confirm all placements. The script creates one instance per zone per distribution area.

**Q: What happens if I drag the grip point outside the element?**

A: The script automatically snaps the splitting point to the closest valid position within the sheet coverage area. You cannot place the splitting point outside the valid sheet envelope.

**Q: Can I undo a sheet redistribution?**

A: Yes, using standard AutoCAD undo (`U` command). Or delete the TSL instance, and the original sheet distribution is restored when the element recalculates.

**Q: Why do I see multiple circle-and-cross symbols on one element?**

A: Each symbol represents a splitting point in a different distribution area or zone. Elements with multiple openings have multiple distribution areas, and each can have its own redistribution instance.

**Q: Can I change the typical sheet width after insertion?**

A: Not directly. The typical sheet width is determined by the widest existing sheet in the zone at insertion time. To change it, you would need to modify the element's sheet definition (e.g., change the element's zone sheet material width), which would trigger a recalculation with the new typical width.

**Q: Does this work for CLT panels?**

A: Yes, as long as the CLT panel is represented as an hsbCAD Element with zones containing sheets. The script works with any element type (walls, floors, roofs) that has sheet zones.

**Q: What is the difference between "distribution area" and "zone"?**

A: A **zone** is a layer of the element (e.g., zone 1 = interior sheathing). A **distribution area** is a continuous region within a zone, separated by openings. For example, a wall with one window has two distribution areas in each zone: the area to the left of the window, and the area to the right of the window.

## Summary

**hsbRedistributeSheets** is a powerful parametric tool for controlling sheet joint positions in hsbCAD elements. It provides:

- **Interactive jig system** with real-time visual feedback
- **Multiple distribution area support** for elements with openings
- **Zone switching** during placement for multi-zone redistribution
- **Grip point dragging** for post-insertion adjustments
- **Automatic recalculation** when element geometry changes
- **Duplicate prevention** to avoid conflicting redistributions

The tool is particularly valuable for:
- Aligning sheet joints with structural members
- Optimizing paneling around openings
- Meeting fabrication requirements
- Standardizing panel sizes across projects

For typical use, simply insert the tool, select the zone, click at the desired splitting point location, and confirm. The script handles all the complex geometric calculations automatically.
