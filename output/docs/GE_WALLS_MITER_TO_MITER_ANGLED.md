# GE_WALLS_MITER_TO_MITER_ANGLED

## Overview

This script automates the structural framing connection between two stud walls that meet at an angle other than 90 degrees - for example bay windows, chamfered building corners, or any angled wall junction. It handles the full carpentry sequence automatically:

- Removes studs that physically conflict with the corner zone
- Inserts corner filler beams sized and cut to the chosen connection geometry
- Cuts top plates, very top plates (VTPs), and bottom plates at the miter line
- Optionally laps the VTPs from one wall over the other for structural continuity
- Cuts wall sheathing panels at the miter line with a configurable gap
- Stretches or removes any blocking members near the connection

Seven different corner framing strategies are available, from a full mitered assembly with corner studs on both walls to simpler squared cuts and various beveled stud configurations.

The script is a living entity: once placed, it re-evaluates and rebuilds the connection geometry every time either wall moves or its parameters are changed in the Properties Palette.

## Usage Environment

| Property | Value |
|---|---|
| Script type | O-Type (Object - attaches to wall elements and recalculates) |
| Works in | Model Space only |
| Paper Space | Not applicable |
| Shop Drawing | Not applicable |
| Beams required at insert | 0 (walls are selected interactively) |
| Elements required | 2 ElementWall entities that physically touch at an angle |

## Prerequisites

Before running this script the following conditions must be met:

- Two `ElementWall` objects must already exist in the drawing and must be physically touching (their outlines must intersect in exactly two points).
- The walls must meet at an angle that is neither 90 degrees (perpendicular) nor 0/180 degrees (parallel). The script validates this and erases itself if either condition is violated.
- Each wall must have a true miter-to-miter geometry: both walls must each share both intersection points as vertices of their outlines. T-connections and open-angle end-to-end connections are rejected.
- The walls must contain at least one stud, one bottom plate, and one top plate each, so the script can determine the stud bay dimensions for new corner members.
- The file `hsbFramingDefaults.Inventory.dll` must be present in the hsbCAD installation directory (`_kPathHsbInstall\Utilities\hsbFramingDefaultsEditor\`) for the lumber catalog to load. If the DLL is missing the lumber dropdown will be empty.
- Only one instance of this script may manage a given wall pair. If you attempt to insert a second instance for the same two walls, the new instance erases itself automatically.

## How to Use

### Step 1: Insert the script

Run the AutoCAD command `TSLINSERT` and browse to `GE_WALLS_MITER_TO_MITER_ANGLED.mcr`, or use the hsbCAD script browser to locate and launch it.

### Step 2: Select the two angled walls

The command line prompts:

```
Select 2 angled elements
```

Click on the first wall, then click on the second wall. Both walls must already be touching at the angled corner. The selection order does not affect the result.

### Step 3: The script validates the geometry

After selection the script performs the following checks in order. If any check fails, the script erases itself and reports an error message in the command line:

1. Exactly 2 `ElementWall` entities were selected.
2. The two walls are physically connected (their outlines share contact points).
3. The walls are not perpendicular and not parallel.
4. The connection is a true miter-to-miter topology (two outline intersection points, both walls each having two coincident vertices at those points).
5. No other instance of this same script already manages this exact wall pair.

### Step 4: Adjust parameters in the Properties Palette (OPM)

Once the script is placed successfully, open the AutoCAD Properties Palette (press `Ctrl+1` or type `PROPERTIES`). Select the script entity to see and adjust its parameters. The corner geometry rebuilds automatically whenever you change a value.

### Step 5: The model updates dynamically

If either wall is later moved, resized, or regenerated, the script recalculates and rebuilds the connection automatically. No manual re-application is needed.

## Properties Panel (OPM Parameters)

### Connection Geometry

| Property | Type | Default | Description |
|---|---|---|---|
| Connection type | Dropdown | Mitered End with Assembly | Selects the framing strategy for the corner. See the table below for all options. |
| Lap top plates | Dropdown (No / Yes) | No | When set to Yes, the very top plate (VTP) of one wall is lapped over the VTP of the other wall at the corner, rather than both being cut at the miter line. |
| Switch lap side | Dropdown (No / Yes) | No | Active only when "Lap top plates" is Yes. Toggles which wall's VTP sits on top of the other. Use this to satisfy structural sequencing requirements. |
| VTP Lap limits | Number (length) | 3.175 mm / 0.125 in | The setback distance applied to the lapped VTP. Controls how far the overlapping plate extends past the contact point. |
| Sheeting limits | Number (length) | 3.175 mm / 0.125 in | The gap offset applied when cutting wall sheathing at the miter line. A small positive value prevents the two sheathing panels from touching flush at the corner. |

### New Beam Properties

The script creates new corner filler beams (corner studs, beveled studs, or cavity fillers depending on the connection type). These new beams need lumber properties assigned to them.

| Property | Type | Default | Description |
|---|---|---|---|
| All new beams info | Label (read-only) | - | Section header, not editable. |
| Apply custom properties to new beams | Dropdown (No / Yes) | No | When No, new beams inherit all lumber properties (name, material, grade, etc.) from the nearest stud in the respective wall. When Yes, the fields below are used instead. |
| Name | Text | SYP #2 2x4 | Stock name for new corner beams. Active only when "Apply custom properties" is Yes. |
| Material | Text | SYP | Lumber species for new corner beams. |
| Grade | Text | #2 | Structural grade for new corner beams. |
| Information | Text | STUD | Usage classification tag for new corner beams. |
| Label | Text | (empty) | Primary label text applied to new corner beams. |
| Sublabel | Text | (empty) | Secondary label text applied to new corner beams. |
| Sublabel2 | Text | (empty) | Additional label text applied to new corner beams. |
| Beam code | Text | ;;;;;;;;;;;;; | Semicolon-delimited code string applied to new corner beams. |
| Beam color | Integer | 3 | AutoCAD color index applied to new corner beams (3 = green). |

## Connection Type Options

| Index | Name | Description |
|---|---|---|
| 0 | Mitered End with Assembly | Two full-height corner studs are added, one per wall, each with a miter cut at the shared face. Both studs sit at the inner corner and touch along the miter plane. This is the most complete assembly. |
| 1 | Mitered end without assembly | Plates are cut at the miter angle but no additional corner studs are inserted. The end of each wall's framing terminates at the miter cut with an open cavity. |
| 2 | Squared end | Plates on both walls are cut perpendicular to each wall's length axis (squared off at the short point of the corner), not at the miter angle. No additional corner studs are inserted. |
| 3 | Beveled Edge Stud (Stud length) | A triangular cavity-filler beam is inserted in each wall to fill the triangular void at the corner. The beam height spans between the top face of the bottom plate and the bottom face of the lower top plate (stud length only, not including plate thickness). |
| 4 | Beveled Edge Stud (Wall length) | Same triangular cavity-filler concept as type 3, but the beam height spans the full wall height including the plate thicknesses. |
| 5 | Beveled stud not split | A single beveled stud per wall spans the full corner pocket as one piece, cut on both faces (interior and exterior corner lines). Blocking in the corner zone is removed rather than stretched. |
| 6 | Beveled stud splitted | Same as type 5 but each beveled stud is split into two separate pieces (one at the interior corner point, one at the exterior corner point) with a gap between them at 1/3 of the miter distance. Blocking in the corner zone is removed. |

## Right-Click Menu Options

This script does not add any custom entries to the AutoCAD right-click context menu. All parameters are accessed through the Properties Palette (OPM).

## Settings Files

| Item | Detail |
|---|---|
| File | `hsbFramingDefaults.Inventory.dll` |
| Location | `<hsbCAD install path>\Utilities\hsbFramingDefaultsEditor\` |
| Purpose | Provides access to the lumber inventory database so that lumber items can be listed in the Properties Palette dropdowns. |
| Company path | Also checked: `_kPathHsbWallDetail` (stickframe path) and `_kPathHsbCompany` (company-specific path). |

## What the Script Modifies

When executed or recalculated, the script makes the following permanent changes to the drawing database:

- **Studs removed**: All vertical members (studs, king studs, jack studs) in both walls whose envelope body intersects the connection clean zone are permanently erased.
- **Blocking**: Blocking members near the connection are either stretched dynamically to the new corner stud (connection types 0-4) or permanently erased (types 5-6).
- **Plates cut**: Top plates, very top plates, and bottom plates on both walls receive a static cut tool at the miter line (or at the squared end line for type 2).
- **VTP lap cut**: When "Lap top plates" is Yes, one wall's VTP receives a cut set back by "VTP Lap limits" and the other wall's VTP is cut flush at the outer corner point.
- **New corner beams**: One or more new beams are created and assigned to their respective wall element groups with beam properties set by the OPM parameters.
- **Sheathing cut**: Sheet members (OSB, gypsum, etc.) on both walls that overlap the corner zone receive a static cut at the miter line offset by "Sheeting limits".

## Tips and Notes

**Wall angle requirement**: This script is specifically for angled (miter-to-miter) connections. It will immediately erase itself and report an error if the walls are perpendicular or parallel. For 90-degree corners use the appropriate right-angle corner connection tool instead.

**True miter-to-miter topology required**: The two walls must each be properly trimmed to the miter line before applying this script. Both wall outlines must intersect in exactly two points, and each wall must have corner vertices at both of those points. If the walls have not been cleaned up to a true miter-to-miter condition, the script will report an error and erase itself.

**Contact required**: The walls must be physically touching. If there is a gap between them, the script erases itself. Use the hsbCAD stretch or connect tools to bring the walls into contact first.

**Duplicate prevention**: Only one instance of this script can manage a given pair of walls. If you accidentally insert a second instance for the same two walls, the duplicate is erased automatically and silently.

**Choosing the connection type**: The most structurally complete option is type 0 (Mitered End with Assembly), which places corner studs on both walls with miter cuts. Types 5 and 6 (Beveled stud) are useful when a triangular solid member that spans both wall thicknesses is preferred. Types 1 and 2 leave the corner open (no added studs) and are useful when the corner will be handled by other means.

**Top plate lapping for structural continuity**: When "Lap top plates" is set to Yes, the script cuts the very top plate of one wall flush at the outer corner point and extends the VTP of the other wall past the inner corner point by the "VTP Lap limits" distance. Use "Switch lap side" to control which wall's plate runs continuously, based on the load path requirements of your design.

**Custom beam properties vs. wall inheritance**: By default ("Apply custom properties to new beams" = No), the new corner beams inherit all lumber properties from the stud that is closest to the connection point in each wall. This ensures the corner members match the wall framing automatically. Use the custom properties option only if the corner requires a different lumber specification, for example a pressure-treated post in an exterior bay window corner.

**Sheeting gap**: The default "Sheeting limits" value of 3.175 mm (1/8 inch) is the standard construction clearance to prevent sheathing panels from butting tightly at the angled corner. Adjust this value if your project standard requires a different gap or if the panels need to be brought flush.

**Recalculation**: Because this is an O-Type entity, it recalculates whenever the attached walls are modified. If either wall changes height, thickness, stud layout, or position, the connection is automatically rebuilt. There is no need to delete and re-insert the script after wall edits.

**Blocking behavior by type**: For connection types 0 through 4, any blocking members in both walls that fall within the corner search zone are stretched dynamically so that they butt against the new corner stud. For types 5 and 6 (beveled studs), those same blocking members are permanently erased instead, because the beveled stud geometry does not provide a clean face to stretch to.

## Version History

| Version | Date | Change |
|---|---|---|
| 1.9 | 03 Nov 2013 | Stickframe path added to DLL call map |
| 1.8 | 19 Mar 2013 | Version control improvements |
| 1.7 | 14 Aug 2012 | Description and thumbnail updated |
| 1.6 | 20 Oct 2011 | VTP lapping and switch lap side functionality added; beam property sourcing fixed to exclude component/assembly studs |
| 1.5 | 14 Mar 2011 | User can now set custom properties for new beams |
| 1.4 | 21 Dec 2010 | Blocking stretch bug fix |
| 1.3 | 10 Dec 2010 | Blocking stretch functionality added |
| 1.2 | 08 Dec 2010 | Script renamed from GE_WALLS_MITRE_TO_MITRE_ANGLED; display updated |
| 1.1 | 04 Dec 2010 | Property indexes updated |
| 1.0 | 02 Dec 2010 | Initial release |
