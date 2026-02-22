# Rothoblaas WHT

## Overview

The **Rothoblaas WHT** script automates the placement of Rothoblaas WHT (Wind Holding Tension) hold-down anchors onto vertical timber beams, SIP panels, or StickFrame Wall studs. The WHT product family consists of tensile angle brackets and plates engineered for wind and seismic resistance in timber frame construction. This comprehensive automation tool handles the complete installation workflow: it generates the 3D anchor geometry with accurate nail hole patterns, creates beam milling and plate drilling tooling operations, applies no-nail protection zones to StickFrame Wall cladding, publishes detailed hardware component lists for Bill of Material reports, and displays clear plan view symbols for construction drawings.

The script supports five standard WHT models ranging from 340mm to 740mm in height, each with manufacturer-specified dimensions, nail/screw counts, and ground anchoring bolt diameters. Advanced features include optional reinforcement washers (WHTW series), double-anchor placement for high-load applications, customizable ground-fixing systems via external XML configuration, automatic bottom plate drilling, and intelligent positioning that adapts to both standalone beams and complex StickFrame Wall assemblies.

**Key capabilities:**
- **Automatic geometry generation**: Creates dimensionally accurate 3D anchor bodies with proper nail hole patterns and optional reinforcement washers
- **Intelligent tooling**: Generates pocket milling, plate drilling, no-nail zones, and sheet cut-outs based on mounting configuration
- **Hardware BOM integration**: Publishes complete material lists including anchors, fasteners, ground fixings, and washers with manufacturer data
- **CNC data output**: Exports contour polylines for automated machining operations (hsbCNC, hsbMake, hsbShare)
- **Dual operation modes**: Beam mode for quick multi-beam placement, panel mode for precise point-by-point positioning on SIP panels

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| **Model Space** | ✓ Yes | Primary operation environment. The anchor is placed as a parametric 3D entity that responds to beam/panel movement and recalculates when properties change. |
| **Paper Space** | ✗ No | Not designed for paper space layouts. Use model space placement and rely on viewport-based shop drawings. |
| **Shop Drawing** | ~ Indirect | Does not generate standalone shop drawing annotations, but publishes CNC contour data (`plCNC` map entry) and hardware component metadata consumed by downstream tools (hsbCNC for machining paths, hsbMake/hsbShare for production data, shop drawing scripts for material lists). Element view format can display custom labels. |

## Prerequisites

### Required Elements

- **Vertical Beams or SIP Panels**: At least one vertical beam (with its local X-axis parallel to the World Z-axis) or at least one SIP panel must exist in the model prior to script insertion.
  - Vertical beams are automatically detected by checking if `Beam.vecX().isParallelTo(_ZW)` evaluates to true
  - Non-vertical beams in selection sets are filtered out automatically with a notification message
  - SIP panels can be in any orientation (vertical walls, floors, roofs)

### Optional Elements for Enhanced Functionality

- **StickFrame Wall Element**: When the reference beam is part of a StickFrame Wall (`ElementWallSF`), the script unlocks additional capabilities:
  - **No-nail area generation** (`ElemNoNail` tools) to prevent nailing machine interference
  - **Element saw lines** (`ElemSaw` tools) to create cut patterns in cladding panels
  - **Sheet cut-outs** (`BeamCut` on sheets) for zone 1/-1 cladding when zone 2 exists
  - **Automatic plate detection and drilling** for bottom/top plates intersecting the anchor path
  - **Zone-based tooling** with different oversize values per wall zone (inside to outside)

- **Settings File (`FixtureDefinition.xml`)**: Provides custom ground-anchoring fixture definitions
  - **Search path 1**: `[hsbCompany]\TSL\Settings\FixtureDefinition.xml` (company-specific customizations)
  - **Search path 2**: `[hsbInstall]\Content\General\TSL\Settings\FixtureDefinition.xml` (installation defaults)
  - If not found, script falls back to built-in defaults: VINYLPRO and EPOPLUS chemical anchoring systems
  - File can define multiple fixture types shared across different hardware scripts via `Application[]` tagging

- **hsbCAM Module**: Required for manufacturing-related features
  - No-nail area creation (`ElemNoNail`)
  - Automatic plate drilling (`Drill.addMeToGenBeamsIntersect`)
  - Element saw line generation (`ElemSaw`)
  - Warning messages displayed when these features are enabled without the module

## Usage Steps

### Step 1: Launch the Script

**Command**: Execute `TSLINSERT` (or access via the hsbCAD ribbon/toolbar) and select **Rothoblaas WHT** from the available script catalog.

**Dialog behavior**:
- **Default**: A properties dialog appears showing all configuration parameters (Type, Mounting type, Nailing, etc.)
- **With Execute Key**: If you provide an execute key (command-line argument) matching a saved catalog preset name, the script loads that configuration silently without showing the dialog
  - Example: `TSLINSERT "Rothoblaas WHT" -k="WHT540_FullNailing"` would load the saved "WHT540_FullNailing" preset
- **Last Inserted**: Press Enter in the dialog to accept the last-inserted configuration stored in the drawing

**Initial configuration options**:
- Select WHT model (WHT340, WHT440, WHT540, WHT620, WHT740)
- Choose mounting type (nails vs. screws, different lengths)
- Set nailing pattern (full vs. partial patterns)
- Configure ground anchoring system
- Set milling depth and tolerances
- Enable/disable no-nail areas and automatic drilling

### Step 2: Select Reference Beams or Panels

**Command line prompt**:
```
Select beam(s) or panel(s):
```

**Selection behavior**:
- **Allowed entity types**:
  - `Beam()` objects (timber members)
  - `Sip()` objects (Structural Insulated Panels)
- **Selection methods**: Click individual entities, or use window/crossing selection to capture multiple objects
- **Automatic filtering**: Non-vertical beams are removed from selection
  - A beam is considered vertical if `beam.vecX().isParallelTo(_ZW)` is true
  - Filtered count is reported: `"X not vertical beams were filtered out"`
- **Mixed selection**: You can select both beams and SIP panels in one selection set; they will be processed separately

**Press Enter** to confirm your selection and proceed to the next step.

### Step 3a: Pick the Insert Side (Beam Mode)

**Condition**: This step occurs only when you selected at least one beam in Step 2.

**Highlight phase**:
- All selected beams are temporarily highlighted with a hatched cross-section pattern (ANSI37, color 6)
- The highlight helps you visualize which beams are active
- A temporary TSL instance creates the highlight (erased after point selection)

**Command line prompt**:
```
Pick point on desired insert side:
```

**Point selection behavior**:
- Click a point anywhere in 3D space near the desired beam face
- The script projects your point to determine which beam face is closest
- The anchor is placed on that face, aligned at the beam bottom
- **Position calculation**:
  - Script creates a bottom plane at `beam.ptCen() - _ZW * 0.5 * beam.dL()` (beam bottom end)
  - Projects insertion point to this plane to find the anchor base point
  - Determines insert-side vector `vecY` pointing from beam center toward the closest face
  - Automatically adjusts position if anchor would overlap beyond beam edge (keeps anchor within beam width)

**Result**: One anchor instance is created per selected beam, all facing the same side direction.

### Step 3b: Pick Insert Points (Panel Mode)

**Condition**: This step occurs when you selected at least one SIP panel in Step 2.

**Panel-by-panel workflow**:
The script processes each panel sequentially. For each panel:

**1. Highlight phase**:
   - Current panel is highlighted with hatched cross-section pattern
   - Temporary TSL instance shows you which panel is active

**2. Alignment determination**:
   - **If panel is part of a wall element** (`ElementWall`): Alignment vector `vecZ` is set automatically to `element.vecY()` (perpendicular to wall face)
   - **If panel is vertical but standalone**:
     - Script reports: `"Panel is vertical aligned in the current coordinate system --> The suggested anchor alignment is in negative Z direction (downwards)"`
     - Alignment defaults to `_ZU` (upward in UCS)
   - **Otherwise**:
     - Command line prompts: `"Set the anchor alignment"`
     - Pick a point to define the alignment direction
     - Script projects the point onto the panel plane to determine the vector from panel center to picked point

**3. Insert point selection**:
   **Command line prompt**:
   ```
   Select insert point or <Enter> to continue:
   ```

   - Click one or more points on or near the panel surface
   - Each click creates one anchor instance at that location
   - Script projects each point to the panel face (closest point on panel envelope)
   - **If panel is part of a wall**: Points are also projected to the wall bottom edge along `element.vecY()`
   - **If panel is vertical standalone**: Points are also projected to the bottom edge along `-_ZU`
   - **Press Enter** to finish this panel and move to the next one

**4. Repeat** for each panel in your selection set

**Temporary highlight cleanup**: Each panel's highlight TSL is erased before moving to the next panel.

### Step 4: Adjust Properties After Placement

**Select the anchor instance** in the model (click on the 3D anchor geometry or plan view symbol).

**Open Properties Palette**: Press `Ctrl+1` or type `PROPERTIES` to display the AutoCAD Properties Palette.

**Available categories**:
- **Type**: Change WHT model, interdistance for double anchors, reinforcement washer
- **Mounting**: Adjust fastener type, nailing pattern, ground fixing, vertical height offset
- **Tooling**: Configure milling depth, oversize, no-nail areas, plate drilling
- **Additional Tooling**: Fine-tune no-nail area zones, plate drill oversize
- **Display**: Enable/disable plan symbol, change symbol color, set element view format

**Live recalculation**: The anchor recalculates immediately when you change any property value. Geometry, tooling, and hardware BOM are updated in real-time.

### Step 5 (Optional): Configure Custom Ground Fixings

**Right-click the anchor instance** and select **Edit Fixing** from the context menu.

**Edit Fixing dialog**:
- Displays current ground fixing properties (Article, Manufacturer, Description, Category, Model)
- Allows editing of geometry scale factors (Scale X, Y, Z)
- Changes are saved to `FixtureDefinition.xml` and become available for all future anchor instances
- Dialog shows properties currently associated with the selected "Anchoring to the ground" value

**Add Fixture to Rothoblaas WHT** (if available):
- Appears in context menu when the settings file contains fixture definitions not yet tagged for this script
- Opens a dialog to select an existing fixture from the global list
- Tags the selected fixture for use with Rothoblaas WHT by adding script name to the fixture's `Application[]` list

**Delete Fixing**:
- Opens a dialog to select and remove a fixture definition
- The fixture is untagged from this script but may remain available for other scripts

**Export Settings**:
- Saves current fixture configuration to `[hsbCompany]\TSL\Settings\FixtureDefinition.xml`
- Prompts for confirmation if file already exists
- Use this to backup or distribute custom fixture libraries

## Properties Panel Parameters

### Category: Type

| Parameter | Type | Default | Options / Range | Description |
|-----------|------|---------|-----------------|-------------|
| **Type** | String (dropdown) | WHT340 | WHT340, WHT440, WHT540, WHT620, WHT740 | Selects the WHT anchor model. Each model has distinct dimensions and load capacities:<br>• **WHT340**: 340mm height × 60mm width × 63mm depth, 20 nails (full) / 14 nails (partial), M16 bolt<br>• **WHT440**: 440mm height × 60mm width × 63mm depth, 30 nails (full) / 20 nails (partial), M16 bolt<br>• **WHT540**: 540mm height × 60mm width × 63mm depth, 45 nails (full) / 27 nails (partial), M20 bolt<br>• **WHT620**: 620mm height × 80mm width × 83mm depth, 55 nails (full) / 33 nails (partial), M24 bolt<br>• **WHT740**: 740mm height × 140mm width × 83mm depth, 75 nails (full) / 45 nails (partial), M27 bolt<br><br>Changing this parameter triggers complete recalculation of anchor geometry, nail hole pattern (count and positions), bottom bolt hole diameter, and compatible reinforcement washer options. |
| **Interdistance** | Double | 0 mm | 0 or ≥ anchor width (mm) | Creates a double-anchor configuration when set to a value greater than zero and at least equal to the anchor width. Two anchors are placed side-by-side on the same stud, separated by this distance measured between their centerlines.<br><br>**Double anchor logic**:<br>• Value must be ≥ anchor width (60mm for WHT340-540, 80mm for WHT620, 140mm for WHT740)<br>• Stud width check: `beam.dD(element.vecX()) < dWidth + dInterdistance` prevents placement if stud is too narrow<br>• If stud is insufficient, interdistance is reset to 0 and warning displays: "Stud not wide enough to place two anchors, interdistance has been reset"<br>• Affects milling width, no-nail area width, and hardware BOM quantity (doubled)<br>• Plan view symbol shows two circles when active<br><br>Typical use: High-load shear walls, seismic zones, transfer beams. |
| **Reinforcement Washer** | String (dropdown) | *(model-dependent)* | WHTW50, WHTW50L, WHTW70, WHTW70L, WHTW130 | Adds a reinforcement washer to the anchor base to distribute bearing loads on the foundation or substructure. Washer selection is model-dependent (compatibility matrix enforced by script):<br><br>**Compatibility matrix**:<br>• **WHT340**: WHTW50 (50×56mm, t=10mm, d=18mm)<br>• **WHT440**: WHTW50, WHTW50L (50×56mm, t=10mm, d=18mm or 22mm)<br>• **WHT540**: WHTW50, WHTW50L, WHTW70 (50×56mm or 70×77mm, t=10mm or 20mm)<br>• **WHT620**: WHTW50L, WHTW70, WHTW70L (50×56mm or 70×77mm, t=10mm-20mm, d=22mm or 26mm)<br>• **WHT740**: WHTW70, WHTW70L, WHTW130 (70×77mm or 130×77mm, t=20mm-40mm, d=22mm-29mm)<br><br>The washer is rendered as a separate 3D body at the anchor base (above the bottom plate), includes a central bolt hole matching the anchor hole diameter, and is added to the hardware BOM as a separate component. Script enforces compatibility and resets to first valid option if current selection becomes invalid after model change. |

### Category: Mounting

| Parameter | Type | Default | Options / Range | Description |
|-----------|------|---------|-----------------|-------------|
| **Mounting type** | String (dropdown) | Anchor Nail LBA 4x40 | • Anchor Nail LBA 4x40<br>• Anchor Nail LBA 4x60<br>• Round head screw LBS 5x40<br>• Round head screw LBS 5x50 | Selects the fastener type used to attach the anchor plate to the timber stud or panel. This controls nail hole diameter, fastener length, and article numbers published to the Bill of Material.<br><br>**Fastener specifications**:<br>• **LBA 4x40** (PF601440): Ø4mm × 40mm anchor nail<br>• **LBA 4x60** (PF601460): Ø4mm × 60mm anchor nail<br>• **LBS 5x40** (PF603540): Ø5mm × 40mm round head screw<br>• **LBS 5x50** (PF603560): Ø5mm × 50mm round head screw<br><br>Nail hole diameter in 3D anchor body updates to match (4mm vs. 5mm). Hardware BOM includes manufacturer (Rothoblaas), model, article number, description, and total quantity based on nailing pattern. |
| **Nailing** | String (dropdown) | Full Nailing | • Full Nailing<br>• Partial Nailing - Pattern 1<br>• Partial Nailing - Pattern 2 | Controls which nail holes are utilized in the anchor plate. This affects installation time, fastener count, and load capacity according to engineering specifications.<br><br>**Nailing patterns and quantities**:<br><br>• **Full Nailing**: Uses all available holes<br>  - WHT340: 20 nails, WHT440: 30 nails, WHT540: 45 nails, WHT620: 55 nails, WHT740: 75 nails<br>  - Drawn in color 1 (red) when filled<br><br>• **Partial Nailing - Pattern 1**: Reduced pattern, specific hole distribution<br>  - WHT340: 14 nails, WHT440: 20 nails, WHT540: 27 nails, WHT620: 33 nails, WHT740: 45 nails<br>  - Drawn in color 4 (cyan) when filled<br><br>• **Partial Nailing - Pattern 2**: Alternative reduced pattern<br>  - Same quantities as Pattern 1<br>  - Different hole distribution (varies by row)<br>  - Drawn in color 6 (magenta) when filled<br><br>**Hole pattern logic**: Script generates holes in rows spaced 40mm apart vertically, with 20mm horizontal spacing. Pattern selection determines which specific holes are filled vs. left empty (shown without fill color). |
| **Anchoring to the ground** | String (dropdown) | *(depends on settings)* | • VINYLPRO<br>• EPOPLUS<br>• *(custom fixtures from XML)* | Defines the anchoring system used to fix the WHT anchor to the foundation, concrete slab, or subfloor. Selection affects hardware BOM entry for the ground-fixing component.<br><br>**Default options (when `FixtureDefinition.xml` is not available)**:<br>• **VINYLPRO**: Rothoblaas chemical anchoring system, threaded rod diameter matches WHT model (M16 to M27)<br>• **EPOPLUS**: Rothoblaas epoxy anchoring system, threaded rod diameter matches WHT model (M16 to M27)<br><br>**Custom fixtures (from FixtureDefinition.xml)**:<br>When settings file exists and contains fixtures tagged for "Rothoblaas WHT" in their `Application[]` list, those fixture names replace the default options. Each custom fixture defines:<br>• Article number (for BOM)<br>• Manufacturer, Description, Category, Model (for BOM)<br>• Material type<br>• Scale X, Y, Z dimensions<br><br>**Hardware BOM entry**: One ground-fixing component per anchor instance (quantity = 1 or 2 based on interdistance). Includes all metadata for material ordering systems. |
| **Height** | Double | 0 mm | Any value (mm) | Adjusts the vertical position of the anchor relative to the calculated base point. Positive values move the anchor upward; negative values move it downward.<br><br>**Default base point calculation**:<br>• **Beam mode**: Bottom of beam (`beam.ptCen() - _ZW * 0.5 * beam.dL()`)<br>• **Panel mode**: User-picked point projected to bottom edge<br>• **StickFrame Wall mode**: Top surface of bottom plate (detected automatically)<br><br>**Height offset application**: `_Pt0 = _Pt0 + vecZ * dHeightProp`<br><br>**Use cases**:<br>• Raise anchor above bottom plate when plate is thicker than anchor expects<br>• Lower anchor when foundation detail requires anchor to extend below stud bottom<br>• Fine-tune vertical alignment with structural engineer's detail drawings<br>• Compensate for floor sheathing thickness<br><br>**Affects tooling**: Milling pocket and no-nail areas shift vertically with the anchor. |

### Category: Tooling

| Parameter | Type | Default | Options / Range | Description |
|-----------|------|---------|-----------------|-------------|
| **Mill depth** | Double | 0 mm | 0 or greater (mm) | Defines the depth of the pocket milling into the timber that allows the anchor to sit flush or recessed. When set to zero, the anchor mounts on the timber surface with no pocket milling.<br><br>**Milling geometry when > 0**:<br>• Creates a `BeamCut` with dimensions:<br>  - Width: `dWidth + 2*dMillOversize + dInterdistance`<br>  - Depth: `dMillDepth`<br>  - Height: `dHeight + dMillOversize`<br>• Applied to all beams in the element using `bcAnchor.addMeToGenBeamsIntersect(gbToMill)`<br>• Cutting body origin at `_Pt0` with vectors `vecX, vecY, vecZ`<br><br>**Effect on no-nail areas and sheet cut-outs**: When mill depth is 0 and StickFrame Wall zone 2 exists, sheet cut-out is enabled in zone 1. When mill depth > 0, sheet cut-out is skipped (pocket milling provides clearance).<br><br>**Typical values**: 0mm (surface mount), 10-20mm (partial recess), 30-60mm (full recess for flush finish). |
| **Oversize milling** | Double | 5 mm | 0 or greater (mm) | Adds clearance tolerance around all sides of the milling pocket to account for manufacturing tolerances, timber shrinkage, and installation clearance. This ensures the anchor can be inserted into the pocket without binding or interference.<br><br>**Applied to**:<br>• Milling pocket width and height (adds to both sides: total increase = 2 × dMillOversize)<br>• No-nail area boundaries (prevents nails from being placed in the clearance zone)<br>• Sheet cut-out dimensions (when enabled)<br><br>**Calculation example** (WHT340 with 5mm oversize):<br>• Milling pocket width = 60mm (anchor width) + 2×5mm = 70mm<br>• Milling pocket height = 340mm (anchor height) + 5mm (top oversize) = 345mm<br><br>**Recommended values**: 3-5mm for CNC precision, 8-10mm for manual machining or shrinkage-prone timber species. |
| **No nail areas** | String (dropdown) | No | No, Yes | Controls whether the script creates no-nail zones (`ElemNoNail` tools) in the StickFrame Wall element zones adjacent to the anchor. No-nail zones prevent automated nailing machines from placing fasteners in the anchor area, avoiding hardware conflicts.<br><br>**Activation conditions**:<br>• Reference beam must be part of a `ElementWallSF()`<br>• `nSide != 0` (anchor has valid side orientation)<br>• Company special ≠ RUB (special handling for RUB company mode)<br>• Requires **hsbCAM module** (warning displayed if module unavailable)<br><br>**Automatic activation**: This parameter is automatically set to "Yes" if the "Oversize No nail areas per zone" field contains any values.<br><br>**No-nail area geometry** (per zone):<br>• Width: `dWidth + 2*dMillOversize + 2*dTokenZone + dInterdistance`<br>• Height: `dHeight + dMillOversize + dTokenZone`<br>• Created as closed polyline, applied via `ElemNoNail(nSide*i, plNoNail)`<br>• Zones 1-5 (inside to outside) processed sequentially<br>• Only created for zones where `element.zone(nSide*i).dH() > 0`<br><br>**Sheet intersection logic (v2.6+)**: No-nail areas are clipped to sheet boundaries using `ppNoNail.intersectWith(ppSheets)` to prevent oversize areas from extending beyond cladding panels. |
| **Oversize No nail areas per zone** | String | *(empty)* | Semicolon-separated values:<br>"5;10;15;20;25"<br>or single incremental value:<br>"5" | Defines additional clearance values for no-nail areas in each wall zone, starting from the innermost zone (zone 1 or -1) and progressing outward. This allows different clearances per zone to account for varying cladding thicknesses or nailing patterns.<br><br>**Input format options**:<br><br>**1. Five explicit values** (semicolon-separated):<br>`"5;10;15;20;25"` assigns:<br>• Zone 1: 5mm oversize<br>• Zone 2: 10mm oversize<br>• Zone 3: 15mm oversize<br>• Zone 4: 20mm oversize<br>• Zone 5: 25mm oversize<br><br>**2. Single incremental value**:<br>`"5"` calculates:<br>• Zone 1: 5mm × 0 = 0mm<br>• Zone 2: 5mm × 1 = 5mm<br>• Zone 3: 5mm × 2 = 10mm<br>• Zone 4: 5mm × 3 = 15mm<br>• Zone 5: 5mm × 4 = 20mm<br><br>**Parsing logic** (code line 1507-1522):<br>```c<br>String sTokens[] = sNoNailZone.tokenize(";");<br>if (sTokens.length() == 5) {<br>  // Use explicit values<br>  dToken = sNoNailZone.token(i-1, ";").atof();<br>} else if (sTokens.length() > 0) {<br>  // Use incremental calculation<br>  double dInc = sTokens[0].atof();<br>  dToken = dInc * (i-1);<br>}<br>```<br><br>**Total no-nail area width** per zone:<br>`dX = 0.5*dWidth + dMillOversize + dToken + 0.5*dInterdistance`<br><br>**Requires hsbCAM module**. |

### Category: Additional Tooling

| Parameter | Type | Default | Options / Range | Description |
|-----------|------|---------|-----------------|-------------|
| **Drilling plate** | String (dropdown) | No | No, Yes | Enables automatic drilling of bottom plates (and any other plates) detected below the anchor. When activated, the script searches vertically downward from the anchor position to find all plates that would intersect the anchor bolt path, then creates through-drills matching the anchor's bottom hole diameter plus oversize tolerance.<br><br>**Activation conditions**:<br>• Reference beam must be part of a `ElementWallSF()`<br>• Requires **hsbCAM module**<br><br>**Plate detection logic** (code line 982-1010):<br>```c<br>Beam bmPlate[] = bm.filterBeamsHalfLineIntersectSort(<br>  bmToMill, <br>  _Pt0 + vecZ*(dHeight - dEps) + vecY*dEps, <br>  -_ZW<br>);<br>```<br>Finds all beams intersecting a vertical line from anchor top downward.<br><br>**Drill creation**:<br>• Origin: `_Pt0 + vecY*(dHoleOffsetBottom + dThickness - dMillDepth)`<br>• Direction: `-_ZW` (straight down)<br>• Diameter: `(dHoleDiaBottom + dDiaAddDrill) * 0.5` (radius)<br>• Depth: `dPlate + dEps` (sum of all plate thicknesses)<br>• Applied via `drPlate.addMeToGenBeamsIntersect(bmPlate)`<br><br>**Height adjustment**: When plates are detected, anchor base point is adjusted to sit on top of the bottom-most plate: `_Pt0 = _Pt0 - _ZW * (_ZW.dotProduct(_Pt0 - bmPlate[0].ptCen()) - 0.5*bmPlate[0].dD(_ZW))`<br><br>**Use case**: Ensures anchor bolt can pass through bottom plates without manual drilling operations. |
| **Oversize drill** | Double | 1 mm | 0 or greater (mm) | Adds clearance tolerance to the automatic plate drill diameter. The actual drill diameter equals the anchor's bottom hole diameter plus this oversize value. Only effective when "Drilling plate" parameter is set to "Yes".<br><br>**Drill diameter calculation**:<br>`drillDiameter = dHoleDiaBottom + dDiaAddDrill`<br><br>**Bottom hole diameters by model**:<br>• WHT340: Ø17mm → drill Ø18mm (with 1mm oversize)<br>• WHT440: Ø17mm → drill Ø18mm<br>• WHT540: Ø22mm → drill Ø23mm<br>• WHT620: Ø26mm → drill Ø27mm<br>• WHT740: Ø29mm → drill Ø30mm<br><br>**Recommended values**: 1-2mm for standard construction tolerances, 3-5mm when accounting for anchor installation misalignment or timber movement. |

### Category: Display

| Parameter | Type | Default | Options / Range | Description |
|-----------|------|---------|-----------------|-------------|
| **Plan view Symbol** | String (dropdown) | Yes | No, Yes | Controls visibility of the plan view identification symbol drawn above the anchor. The symbol consists of a filled circular ring with an inscribed filled triangle, providing clear anchor identification in plan view drawings and layouts.<br><br>**Symbol geometry**:<br>• **Position**: `_Pt0 + vecZ*(dHeight + 100mm)` (100mm above anchor top)<br>• **Outer circle**: Ø56mm filled ring<br>• **Inner circle**: Ø53mm cutout (creates 1.5mm ring thickness)<br>• **Triangle**: Inscribed equilateral triangle with 53mm vertices, one point facing `-vecY` (opposite of anchor facing direction)<br>• **View direction**: Only visible when looking along `+vecZ` axis (plan view from above)<br><br>**Double anchor handling**: When interdistance > 0, two symbols are drawn, offset by `±vecX * 0.5*dInterdistance`<br><br>**Drawing layer**: Symbol is drawn with the display object that has `showInDxa(true)` enabled, making it visible in production data exports.<br><br>**Color**: Controlled by separate "Color" parameter (default: 7 - white). |
| **Color** | Integer | 7 | 0-255 (AutoCAD color index) | Sets the AutoCAD color index for the plan view symbol. Does not affect the 3D anchor body color, which uses the instance color set during creation (color 5 for standard mode, color 9 for company-specific modes).<br><br>**Common color indices**:<br>• 1 = Red (high visibility)<br>• 2 = Yellow<br>• 3 = Green<br>• 4 = Cyan<br>• 5 = Blue<br>• 6 = Magenta<br>• 7 = White/Black (default, adapts to background)<br>• 8 = Dark gray<br>• 9 = Light gray<br><br>**Use case**: Differentiate anchor symbols from other plan view annotations by layer/color standards. Coordinate with company CAD standards or sheet organization systems. |
| **Elementview Format** | String | *(empty)* | Format string using hsbCAD format object syntax:<br>`%ArticleNumber%`<br>`%Manufacturer% - %Description%`<br>etc. | Defines a custom text label displayed in element view drawings. Uses the hsbCAD `formatObject()` system to compose labels from hardware component properties. The label is drawn at the anchor insertion point with text aligned to element axes.<br><br>**Available format variables** (from `mapAdditionals`):<br>• `%ArticleNumber%` - Ground fixing article number<br>• `%Manufacturer%` - Ground fixing manufacturer<br>• `%Description%` - Ground fixing description<br>• `%Category%` - Ground fixing category<br><br>**Label rendering**:<br>• Position: `_Pt0`<br>• Orientation: `el.vecX()` (horizontal), `el.vecY()` (vertical)<br>• Text height: 75mm (`dTxtH = U(75)`)<br>• Alignment: 0 (left), -2 (bottom)<br>• Display mode: `_kDevice` (device-independent text)<br>• Visibility: Only when element is valid, drawn with `dpElement` display object<br><br>**Example format strings**:<br>• `"%ArticleNumber%"` → displays "VINYLPRO"<br>• `"%Manufacturer% %Description%"` → displays "Rothoblaas M16"<br>• Leave empty for no label.<br><br>**Drawing layer**: Label appears in element view directions (perpendicular to `el.vecZ()`). |

## Right-Click Context Menu

| Menu Item | Availability | Description |
|-----------|--------------|-------------|
| **Flip Z alignment** | Panel (SIP) Mode only | Reverses the vertical alignment direction of the anchor by 180°. The anchor Z-axis is inverted (`vecZ = -vecZ`), flipping the anchor from facing upward to downward or vice versa.<br><br>**Trigger conditions**:<br>• Mode must be 0 (SIP/panel mode, not beam mode)<br>• Available in context menu for all SIP-mounted anchors<br>• Also triggered by **double-clicking** the anchor instance<br><br>**Execution**:<br>• Updates `_Map.setVector3d("vecAlign", vecZ)` with inverted vector<br>• Calls `setExecutionLoops(2)` to force immediate recalculation<br>• Anchor geometry regenerates with new orientation<br><br>**Use case**: Correct anchor orientation when default alignment assumption is incorrect (e.g., ceiling-mounted anchors in roof panels, or wall anchors that should face into the building instead of out). |
| **Set Z alignment** | Panel (SIP) Mode only | Prompts you to interactively define a new Z alignment direction by picking a point in 3D space. The picked point determines the desired vertical orientation of the anchor relative to the panel plane.<br><br>**Workflow**:<br>1. Command line prompts: `"select Z direction"`<br>2. Pick a point indicating the desired direction<br>3. Script calculates vector from `_Pt0` to picked point<br>4. Vector is projected onto the panel plane: `vecZ = vecZ.crossProduct(sip.vecZ()).crossProduct(-sip.vecZ())`<br>5. Anchor recalculates with new alignment<br><br>**Trigger conditions**:<br>• Mode must be 0 (SIP/panel mode)<br>• Only available for panel-mounted anchors<br><br>**Execution**:<br>• Stores new alignment in `_Map.setVector3d("vecAlign", vecZ)`<br>• Forces recalculation with `setExecutionLoops(2)`<br><br>**Use case**: Set precise anchor orientation for sloped roofs, complex panel assemblies, or when default alignment doesn't match structural requirements. |
| **Edit Fixing** | Always available | Opens a property dialog to add or modify a ground-anchoring fixture definition. The dialog displays editable fields for all fixture metadata and geometry parameters.<br><br>**Dialog fields**:<br>• **Article** (String): Article number/code for BOM and ordering systems<br>• **Manufacturer** (String): Manufacturer name<br>• **Description** (String): Human-readable description<br>• **Category** (String): Hardware category classification<br>• **Model** (String): Model number or designation<br>• **Scale X** (Double): X-dimension of fixture (mm)<br>• **Scale Y** (Double): Y-dimension of fixture (mm)<br>• **Scale Z** (Double): Z-dimension of fixture (mm)<br><br>**Pre-populated values**: If a fixture is currently selected in "Anchoring to the ground" property and exists in `FixtureDefinition.xml`, the dialog pre-fills with that fixture's current values. Otherwise, fields are empty.<br><br>**Save behavior**:<br>• On dialog confirm: Fixture is updated in `mapSetting` (Map structure)<br>• If `MapObject("hsbTSL", "FixtureDefinition")` exists: `mo.setMap(mapSetting)`<br>• If not: `mo.dbCreate(mapSetting)` creates new MapObject<br>• Fixture is automatically tagged for use with "Rothoblaas WHT" by adding script name to `Application[]` array<br>• Changes take effect immediately for current instance<br>• Use "Export Settings" to persist changes to XML file<br><br>**Use case**: Customize ground fixing definitions for proprietary anchoring systems, regional product variations, or company-specific hardware catalogs. |
| **Add Fixture to Rothoblaas WHT** | Conditional:<br>When `sAllFixings.length() != sFixings.length()` | Appears only when the `FixtureDefinition.xml` file contains fixture definitions that are not currently tagged for use with the Rothoblaas WHT script. Opens a dialog to select an existing fixture from the global list and tag it for use with this script.<br><br>**Dialog field**:<br>• **Article** (String dropdown): Lists all fixtures from `sAllFixings[]` (complete fixture list)<br><br>**Workflow**:<br>1. Dialog displays all fixture names from `mapFixings` (loaded from XML)<br>2. User selects one fixture from dropdown<br>3. Script finds the fixture entry in `mapFixings` by matching `map.getMapName().makeLower() == article.makeLower()`<br>4. Retrieves fixture's `Application[]` array<br>5. Checks if `scriptName()` ("Rothoblaas WHT") already exists in array<br>6. If not found: Appends `scriptName()` to the `Application[]` array<br>7. Updates `mapSetting` with modified fixture entry<br>8. Updates or creates MapObject<br>9. Reports: `"[article] is now available for these scripts: [app1, app2, ...]"`<br><br>**Result**: The selected fixture now appears in the "Anchoring to the ground" dropdown for this script. Changes persist in the MapObject until drawing is closed or "Export Settings" is used to save to XML.<br><br>**Use case**: Leverage a shared fixture library across multiple hardware scripts without duplicating definitions. |
| **Delete Fixing** | Conditional:<br>When `sFixings.length() > 0` | Opens a dialog to select and remove a fixture definition from the script's available list. The fixture is untagged from the Rothoblaas WHT script's `Application[]` array but remains in the global settings file (still available for other scripts).<br><br>**Dialog field**:<br>• **Article** (String dropdown): Lists fixtures currently available to this script (`sFixings[]`)<br><br>**Workflow**:<br>1. Dialog shows all fixtures tagged for "Rothoblaas WHT"<br>2. User selects one fixture to remove<br>3. Script rebuilds `mapSetting` by iterating through `mapFixings`:<br>   - Skips the selected fixture (not included in `mapNew`)<br>   - Copies all other fixtures to `mapNew`<br>4. Updates `mapSetting.setMap("Fixture[]", mapNew)`<br>5. If `mapNew.length() < 1`: Erases MapObject entirely (`mo.dbErase()`)<br>6. Otherwise: Updates or creates MapObject with reduced fixture list<br><br>**Permanent deletion option**: To permanently delete a fixture from the global library (all scripts), manually edit `FixtureDefinition.xml` or use "Export Settings" after deletion to overwrite the XML file without the fixture entry.<br><br>**Use case**: Clean up fixture lists, remove obsolete hardware definitions, or manage script-specific hardware catalogs. |
| **Export Settings** | Conditional:<br>When `mapSetting.length() > 0` | Exports the current fixture configuration from the drawing's MapObject to the `FixtureDefinition.xml` file in the company-specific settings path. This persists all fixture definitions, modifications, and script associations to disk for use in other drawings and by other users.<br><br>**Export path**: `[hsbCompany]\TSL\Settings\FixtureDefinition.xml`<br>• Variable: `sFullPath = sPath + "\\" + sFolder + "\\" + sFileName + ".xml"`<br>• Resolves to: `C:\hsbCAD\[Company]\TSL\Settings\FixtureDefinition.xml` (typical)<br><br>**Workflow**:<br>1. Command activates when context menu item selected<br>2. **Overwrite check**: If file already exists at `sFullPath`:<br>   - Prompts: `"Are you sure to overwrite existing settings? [No/Yes]"`<br>   - Reads first character of user input<br>   - Compares to first character of translated "Yes" string (language-independent)<br>   - If not confirmed: Cancels export<br>3. **Folder creation**: If `TSL\Settings` folder doesn't exist, creates it: `makeFolder(sPath + "\\" + sFolder)`<br>4. **MapObject sync**: `mo.setMap(mapSetting)` or `mo.dbCreate(mapSetting)` ensures MapObject is current<br>5. **XML write**: `mapSetting.writeToXmlFile(sFullPath)` serializes Map to XML format<br>6. **Success message**: Reports file path where settings were saved<br><br>**XML structure** (example):<br>```xml<br><?xml version="1.0" encoding="UTF-8"?><br><Hsb_Map><br>  <lst nm="Fixture[]"><br>    <lst nm="VINYLPRO"><br>      <str nm="Article" vl="VINYLPRO"/><br>      <str nm="Manufacturer" vl="Rothoblaas"/><br>      <str nm="Description" vl="Chemical anchor M16"/><br>      <str nm="Category" vl="Ground Fixing"/><br>      <str nm="Model" vl="M16"/><br>      <dbl nm="ScaleX" ut="L" vl="0"/><br>      <dbl nm="ScaleY" ut="L" vl="16"/><br>      <dbl nm="ScaleZ" ut="L" vl="0"/><br>      <lst nm="Application[]"><br>        <str nm="Application" vl="Rothoblaas WHT"/><br>      </lst><br>    </lst><br>  </lst><br>  <lst nm="GeneralMapObject"><br>    <int nm="Version" vl="1"/><br>  </lst><br></Hsb_Map><br>```<br><br>**Use case**: Share custom fixture libraries across team members, back up configuration changes, distribute company-standard hardware catalogs, or prepare settings for deployment to remote workstations. |

## Settings Files and Configuration

### FixtureDefinition.xml

**File Purpose**: Centralized storage for ground-anchoring fixture definitions that can be shared across multiple hardware scripts (Rothoblaas WHT, Hilti anchors, Simpson hold-downs, etc.).

**File Locations** (searched in order):
1. **Company-specific path**: `[hsbCompany]\TSL\Settings\FixtureDefinition.xml`
   - Highest priority
   - Allows company-wide customization without modifying installation files
   - Created by "Export Settings" command
2. **Installation default path**: `[hsbInstall]\Content\General\TSL\Settings\FixtureDefinition.xml`
   - Fallback when company file not found
   - Shipped with hsbCAD installation
   - Contains manufacturer default fixtures

**File Structure**:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <!-- Version tracking for compatibility checking -->
  <lst nm="GeneralMapObject">
    <int nm="Version" vl="1"/>
  </lst>

  <!-- Fixture definitions array -->
  <lst nm="Fixture[]">

    <!-- Individual fixture entry -->
    <lst nm="VINYLPRO">
      <str nm="Article" vl="VINYLPRO"/>
      <str nm="Manufacturer" vl="Rothoblaas"/>
      <str nm="Description" vl="Chemical anchoring system"/>
      <str nm="Category" vl="Ground Fixing"/>
      <str nm="Model" vl="Threaded Rod"/>
      <str nm="Material" vl="Steel"/>

      <!-- Geometry dimensions (in drawing units, typically mm) -->
      <dbl nm="ScaleX" ut="L" vl="0"/>
      <dbl nm="ScaleY" ut="L" vl="16"/>
      <dbl nm="ScaleZ" ut="L" vl="0"/>

      <!-- Script access control -->
      <lst nm="Application[]">
        <str nm="Application" vl="Rothoblaas WHT"/>
        <str nm="Application" vl="Simpson StrongTie Anchor"/>
      </lst>
    </lst>

    <!-- Additional fixtures... -->
    <lst nm="EPOPLUS">
      <!-- Similar structure -->
    </lst>

  </lst>
</Hsb_Map>
```

**Key Elements**:

| XML Element | Type | Description |
|-------------|------|-------------|
| **GeneralMapObject/Version** | Integer | Version number for compatibility tracking. Script compares this against MapObject version on instantiation and displays notice if different. Increment when making incompatible changes to fixture structure. |
| **Fixture[]** | List | Array of all fixture definitions. Each child element is a named fixture entry. |
| **Article** | String | Unique article number/code used as primary identifier in BOM systems and ordering workflows. |
| **Manufacturer** | String | Manufacturer name (e.g., "Rothoblaas", "Hilti", "Simpson Strong-Tie"). Appears in hardware component BOM. |
| **Description** | String | Human-readable description for BOM reports and material lists. |
| **Category** | String | Hardware category classification (e.g., "Ground Fixing", "Anchor", "Chemical Anchor"). Used for BOM grouping and filtering. |
| **Model** | String | Model number or designation (e.g., "M16", "VINYLPRO-450", "EPOPLUS-16"). |
| **Material** | String | Material specification (typically "Steel"). Appears in hardware BOM. |
| **ScaleX, ScaleY, ScaleZ** | Double (with unit) | Dimensional properties of the fixture. Interpretation varies by fixture type:<br>• ScaleY often represents bolt/rod diameter<br>• ScaleX/ScaleZ may represent length or other dimensions<br>• `ut="L"` specifies length unit type<br>• Values stored in drawing units (mm or inches) |
| **Application[]** | String List | Access control list of script names authorized to use this fixture. A fixture only appears in a script's dropdown if the script name exists in this list. Managed via "Add Fixture to..." and "Delete Fixing" context menu commands. |

**Version Tracking Logic** (code line 123-133):
```c
if (_bOnDbCreated) {
  int nVersion = mapSetting.getInt("GeneralMapObject\\Version");

  // Read installation default XML
  Map mapSettingInstall;
  mapSettingInstall.readFromXmlFile(sFile);
  int nVersionInstall = mapSettingInstall.getMap("GeneralMapObject").getInt("Version");

  // Compare versions
  if (sFile.length() > 0 && nVersion != nVersionInstall)
    reportNotice(
      "A different Version of the settings has been found for " + scriptName() +
      "Current Version: " + nVersion + " " + _kPathDwg +
      "Other Version: " + nVersionInstall + " " + sFile
    );
}
```

**Fallback Behavior**: When `FixtureDefinition.xml` is not found or contains no fixtures tagged for "Rothoblaas WHT" (`sFixings.length() < 1`), the script activates `bUseDefaultFixing = true` and provides two built-in options:
- **VINYLPRO**: Chemical anchoring system with diameter matching WHT model
- **EPOPLUS**: Epoxy anchoring system with diameter matching WHT model

### MapObject Caching System

**Purpose**: The script uses hsbCAD's MapObject dictionary system to cache settings in the drawing database, avoiding repeated XML file parsing during the same session.

**Dictionary Key**:
- **Dictionary Name**: `"hsbTSL"` (shared namespace for all TSL settings)
- **Object Key**: `"FixtureDefinition"` (specific to this settings file)

**Lifecycle**:

**1. On Script Insertion** (`_bOnInsert` or `_bOnDebug`):
```c
MapObject mo("hsbTSL", "FixtureDefinition");

if (mo.bIsValid()) {
  // MapObject exists in drawing: use cached settings
  mapSetting = mo.map();
  setDependencyOnDictObject(mo);  // Track changes to MapObject
}
else {
  // MapObject doesn't exist: read from XML file
  String sFile = findFile(sFullPath);  // Try company path
  if (sFile.length() < 1)
    sFile = findFile(sPathGeneral + sFileName + ".xml");  // Try installation path

  if (sFile.length() > 0) {
    mapSetting.readFromXmlFile(sFile);
    mo.dbCreate(mapSetting);  // Create MapObject for session caching
  }
}
```

**2. During Script Execution**:
- All instances in the same drawing share the same MapObject
- Changes to fixtures via "Edit Fixing" or "Add Fixture" dialogs update the MapObject immediately
- Other instances recalculate automatically due to `setDependencyOnDictObject()` linkage

**3. On Drawing Close**:
- MapObject is discarded (not saved with drawing file by default)
- Next session loads fresh from XML file
- Unless "Export Settings" was used to persist changes to XML

**Dependency Tracking**:
```c
setDependencyOnDictObject(mo);
```
This call ensures the TSL instance recalculates when the MapObject changes (e.g., when another anchor instance modifies fixtures via "Edit Fixing"). All linked instances update simultaneously.

**Benefits**:
- **Performance**: XML parsing happens once per drawing session, not once per anchor instance
- **Consistency**: All instances in the drawing use identical fixture definitions
- **Live updates**: Changes to fixtures propagate immediately to all instances
- **Session isolation**: Changes don't persist unless explicitly exported

## Detailed Workflow Examples

### Example 1: Basic Single Anchor Placement on Vertical Stud

**Scenario**: Place a WHT340 anchor on a vertical stud in a StickFrame wall, using full nailing with anchor nails.

**Steps**:
1. **Launch script**:
   - Command: `TSLINSERT` → Select "Rothoblaas WHT"
   - Dialog appears

2. **Configure parameters**:
   - Type: WHT340 (default)
   - Mounting type: Anchor Nail LBA 4x40 (default)
   - Nailing: Full Nailing (default)
   - Anchoring to the ground: VINYLPRO (default)
   - Mill depth: 0 (surface mount)
   - No nail areas: Yes (enable)
   - Drilling plate: Yes (enable automatic plate drilling)
   - Click OK

3. **Select reference beam**:
   - Command line: `"Select beam(s) or panel(s):"`
   - Click on the vertical stud
   - Press Enter

4. **Pick insert side**:
   - Command line: `"Pick point on desired insert side:"`
   - Stud is highlighted with hatched pattern
   - Click a point on the wall exterior face (outside of building)
   - Anchor is created on exterior face, bottom of stud

5. **Result**:
   - 3D anchor body appears with 20 red filled nail holes (full pattern)
   - Bottom plate is automatically drilled with Ø18mm hole (17mm anchor hole + 1mm oversize)
   - No-nail area created in wall zones (prevents nailing machine conflicts)
   - Plan view symbol appears 440mm above bottom (340mm anchor + 100mm offset)
   - Hardware BOM includes:
     - 1× WHT340 (Rothoblaas, Tensile anchor - Type WHT340)
     - 20× LBA 4x40 (Rothoblaas, Anchor Nail LBA 4x40)
     - 1× VINYLPRO M16 (Rothoblaas, Chemical anchoring system)

### Example 2: Double Anchor Configuration for High-Load Connection

**Scenario**: Place two WHT620 anchors on a single wide stud for a transfer beam connection, with partial nailing and pocket milling.

**Steps**:
1. **Launch script**:
   - `TSLINSERT` → "Rothoblaas WHT"

2. **Configure parameters**:
   - Type: WHT620
   - **Interdistance: 150** (places two anchors 150mm apart)
   - Mounting type: Round head screw LBS 5x50
   - Nailing: Partial Nailing - Pattern 1
   - Anchoring to the ground: EPOPLUS
   - **Mill depth: 20** (20mm pocket recess)
   - **Oversize milling: 8** (8mm clearance)
   - Reinforcement Washer: WHTW70L
   - No nail areas: Yes
   - Oversize No nail areas per zone: 10;15;20;25;30
   - Click OK

3. **Select reference beam**:
   - Click on the wide stud (must be ≥ 80mm + 150mm = 230mm wide)
   - Press Enter

4. **Pick insert side**:
   - Click point on desired face
   - Two anchors created side-by-side, 150mm apart

5. **Result**:
   - Two 3D anchor bodies, each with 33 cyan filled nail holes (partial pattern)
   - Two WHTW70L washers rendered at anchor bases
   - Pocket milling: 236mm wide × 20mm deep × 628mm high
     - Width = 80mm (anchor) + 2×8mm (oversize) + 150mm (interdistance) = 246mm
     - Height = 620mm (anchor) + 8mm (oversize) = 628mm
   - No-nail areas created in zones 1-5 with increasing oversize:
     - Zone 1: 10mm extra clearance
     - Zone 2: 15mm extra clearance
     - Zone 3: 20mm extra clearance
     - Zone 4: 25mm extra clearance
     - Zone 5: 30mm extra clearance
   - Two plan view symbols appear
   - Hardware BOM includes:
     - **2×** WHT620 (Rothoblaas, Tensile anchor - Type WHT620)
     - **2× 33 = 66** LBS 5x50 (Rothoblaas, Round head screw LBS 5x50)
     - **2×** EPOPLUS M24 (Rothoblaas, Epoxy anchoring system)
     - **2×** WHTW70L (Rothoblaas, Washer WHTW70L d26)

### Example 3: SIP Panel Installation with Custom Alignment

**Scenario**: Place WHT540 anchors on a sloped SIP roof panel, with custom vertical alignment to match roof pitch.

**Steps**:
1. **Launch script**:
   - `TSLINSERT` → "Rothoblaas WHT"

2. **Configure parameters**:
   - Type: WHT540
   - Mounting type: Anchor Nail LBA 4x60
   - Nailing: Full Nailing
   - Anchoring to the ground: VINYLPRO
   - Reinforcement Washer: WHTW50L
   - Mill depth: 0
   - No nail areas: No (SIP panels don't have wall zones)
   - Plan view Symbol: Yes
   - Click OK

3. **Select reference panel**:
   - Click on the sloped SIP roof panel
   - Press Enter

4. **Set alignment direction**:
   - Panel is highlighted
   - Command line: `"Set the anchor alignment"`
   - Pick a point downslope from panel center (defines gravity direction for anchor)
   - Script calculates alignment projected onto panel plane

5. **Place anchors**:
   - Command line: `"Select insert point or <Enter> to continue:"`
   - Click first point near roof ridge
   - Anchor #1 created
   - Click second point near roof eave
   - Anchor #2 created
   - Click third point mid-span
   - Anchor #3 created
   - Press Enter to finish

6. **Adjust alignment if needed**:
   - Select one anchor
   - Right-click → "Set Z alignment"
   - Pick new alignment point
   - Anchor reorients to new direction
   - Repeat for other anchors if necessary

7. **Result**:
   - Three anchors placed at picked locations
   - All aligned with custom Z-direction matching roof pitch
   - Each anchor shows 45 red filled nail holes (full WHT540 pattern)
   - WHTW50L washers at each base
   - Plan view symbols visible when looking down on roof
   - Hardware BOM includes:
     - **3×** WHT540
     - **3× 45 = 135** LBA 4x60
     - **3×** VINYLPRO M20
     - **3×** WHTW50L

### Example 4: Custom Ground Fixing Configuration

**Scenario**: Configure a proprietary ground fixing system for a company-specific foundation detail.

**Steps**:
1. **Place initial anchor** (any configuration):
   - `TSLINSERT` → "Rothoblaas WHT"
   - Accept defaults, select beam, place anchor

2. **Edit ground fixing**:
   - Select the anchor instance
   - Right-click → "Edit Fixing"
   - Dialog appears with current VINYLPRO properties

3. **Define custom fixture**:
   - Article: `CUSTOM-ANCHOR-M20`
   - Manufacturer: `XYZ Fasteners Inc.`
   - Description: `Heavy duty epoxy anchor M20x300`
   - Category: `Chemical Anchor`
   - Model: `HA-M20-300`
   - Scale X: `300` (length in mm)
   - Scale Y: `20` (diameter in mm)
   - Scale Z: `0`
   - Click OK

4. **Fixture saved**:
   - Script updates `mapSetting` in memory
   - MapObject updated: `mo.setMap(mapSetting)`
   - Fixture is automatically tagged for "Rothoblaas WHT"
   - Current instance recalculates

5. **Export to XML** (persist for other drawings):
   - Right-click anchor → "Export Settings"
   - Prompt: `"Are you sure to overwrite existing settings? [No/Yes]"`
   - Type: `Y`
   - File written to: `[hsbCompany]\TSL\Settings\FixtureDefinition.xml`
   - Success message displayed

6. **Use in new drawings**:
   - Open new drawing
   - `TSLINSERT` → "Rothoblaas WHT"
   - "Anchoring to the ground" dropdown now includes:
     - VINYLPRO
     - EPOPLUS
     - **CUSTOM-ANCHOR-M20** (new option)
   - Select CUSTOM-ANCHOR-M20
   - Hardware BOM will show XYZ Fasteners data

7. **Share with team**:
   - Copy `[hsbCompany]\TSL\Settings\FixtureDefinition.xml` to other workstations
   - All users now have access to custom fixture definition

## Tips and Best Practices

### Anchor Model Selection

**Match structural engineering specifications**: The five WHT models have significantly different load capacities:
- **WHT340/440**: Light to medium loads, smaller studs (60mm width)
- **WHT540**: Medium loads, standard studs (60mm width)
- **WHT620**: Heavy loads, wider studs (80mm width)
- **WHT740**: Maximum loads, very wide studs (140mm width)

**Bolt diameter consideration**: Ground anchoring bolt size increases with model:
- WHT340/440: M16 (Ø16mm)
- WHT540: M20 (Ø20mm)
- WHT620: M24 (Ø24mm)
- WHT740: M27 (Ø27mm)

Ensure your foundation detail can accommodate the required bolt diameter.

**Height vs. load capacity**: Taller anchors (higher model numbers) provide greater tensile load capacity but require more vertical clearance. Check floor-to-ceiling height constraints before selecting tall models.

### Double Anchor Placement

**Interdistance minimum**: The interdistance value must be at least equal to the anchor width (60mm, 80mm, or 140mm depending on model). The script enforces this requirement.

**Stud width requirement**:
- WHT340: Requires ≥ 60mm + interdistance stud width
- WHT620: Requires ≥ 80mm + interdistance stud width
- WHT740: Requires ≥ 140mm + interdistance stud width

**Example calculations**:
- WHT340 with 80mm interdistance: Requires ≥ 140mm stud
- WHT620 with 150mm interdistance: Requires ≥ 230mm stud
- WHT740 with 200mm interdistance: Requires ≥ 340mm stud

If stud is too narrow, the script automatically resets interdistance to 0 and displays warning: `"Stud not wide enough to place two anchors, interdistance has been reset"`.

**Use cases for double anchors**:
- High-load transfer beams
- Seismic zone shear walls
- Wind-critical connections (coastal/high-rise)
- Columns supporting multiple floors
- Engineered lumber posts (LVL, PSL)

### Reinforcement Washer Selection

**Compatibility matrix** (enforced by script):
| WHT Model | Compatible Washers |
|-----------|-------------------|
| WHT340 | WHTW50 only |
| WHT440 | WHTW50, WHTW50L |
| WHT540 | WHTW50, WHTW50L, WHTW70 |
| WHT620 | WHTW50L, WHTW70, WHTW70L |
| WHT740 | WHTW70, WHTW70L, WHTW130 |

**Selection criteria**:
- **Bearing stress**: Larger washers (WHTW70, WHTW130) distribute loads over greater area, reducing bearing stress on foundation
- **Bolt diameter**: Washer hole must match anchor hole:
  - WHTW50/50L: Ø18mm or Ø22mm → Use with WHT340/440/540
  - WHTW70/70L: Ø22mm or Ø26mm → Use with WHT540/620
  - WHTW130: Ø29mm → Use with WHT740 only
- **Foundation material**: Use thicker washers (WHTW70L 20mm, WHTW130 40mm) on softer materials (wood sills, composite decking)
- **Clearance**: Ensure washer dimensions fit within stud/panel footprint

**Script behavior on model change**: When you change the WHT Type parameter, the script validates the currently selected washer against the new model's compatibility list. If incompatible, it automatically resets to the first valid washer option for the new model.

### Milling and Tooling Configuration

**Flush vs. surface mounting**:
- **Mill depth = 0**: Anchor mounts on surface, no pocket milling (fastest installation)
- **Mill depth > 0**: Anchor sits in recessed pocket (flush or semi-flush finish)

**Recommended mill depths**:
- **10-15mm**: Semi-flush (anchor slightly proud, acceptable for interior)
- **20-30mm**: Flush mount (anchor flush with cladding, ideal for exterior)
- **40-60mm**: Full recess (anchor recessed below cladding, for plaster/stucco finish)

**Oversize milling recommendations**:
- **3-5mm**: CNC machined pockets, tight tolerances
- **5-8mm**: Standard construction, kiln-dried timber
- **8-12mm**: Green lumber, high shrinkage species (southern pine, Douglas fir)
- **10-15mm**: Field-cut pockets, manual router operations

**Pocket milling width formula**:
```
Pocket Width = Anchor Width + (2 × Oversize) + Interdistance
```

**Example** (WHT540 with 5mm oversize, 100mm interdistance):
```
Pocket Width = 60mm + (2 × 5mm) + 100mm = 170mm
```

### No-Nail Area Configuration

**When to enable**:
- ✓ Automated nailing machines used in production
- ✓ Prefabricated wall panels with pre-nailed cladding
- ✓ CNC-drilled stud layouts with automatic fastener insertion
- ✗ Field-nailed construction (manual nailing)
- ✗ SIP panels (no zone-based nailing)

**Zone oversize strategies**:

**1. Uniform oversize** (single value):
```
"5" → Zones get incremental clearance: 0, 5, 10, 15, 20 mm
```
Use when: All cladding layers same thickness, standard nailing pattern

**2. Explicit per-zone oversize** (semicolon-separated):
```
"5;10;15;20;25" → Zones get exact clearance: 5, 10, 15, 20, 25 mm
```
Use when: Different cladding thicknesses per zone (e.g., thicker exterior sheathing)

**3. Accounting for cladding stack-up**:
```
Zone 1 (interior): 5mm (gypsum drywall)
Zone 2 (vapor barrier): 10mm (gypsum + barrier)
Zone 3 (insulation): 15mm (gypsum + barrier + insulation compression)
Zone 4 (sheathing): 20mm (gypsum + barrier + insulation + OSB)
Zone 5 (exterior): 25mm (full stack-up + siding)
```

**v2.6 sheet intersection logic**: The script automatically clips no-nail areas to sheet boundaries, preventing oversize zones from extending into empty space beyond cladding edges. This is especially important for partial-height sheets, openings, and corner conditions.

### Automatic Plate Drilling

**When to enable**:
- ✓ Anchor placed above bottom plate in StickFrame wall
- ✓ Anchor bolt must pass through one or more plates
- ✓ CNC drilling workflow (hsbCAM module available)
- ✗ Anchor at bottom of stud (no plates below)
- ✗ Pre-drilled plates (drilling already done)

**Drill diameter calculation**:
```
Drill Diameter = Anchor Hole Diameter + Oversize Drill
```

**Examples**:
| WHT Model | Hole Ø | Oversize | Drill Ø |
|-----------|---------|----------|---------|
| WHT340 | 17mm | 1mm | 18mm |
| WHT540 | 22mm | 2mm | 24mm |
| WHT620 | 26mm | 3mm | 29mm |
| WHT740 | 29mm | 3mm | 32mm |

**Oversize recommendations**:
- **1-2mm**: Standard tolerance, straight bolt alignment
- **3-4mm**: Accommodation for slight misalignment
- **5-6mm**: Field adjustment, manual installation

**Multi-plate detection**: The script detects ALL plates in the vertical path from anchor bottom to base of wall, sums their thicknesses, and creates a through-drill spanning all plates. Example:
```
Double bottom plate (38mm + 38mm) + Mid-plate (38mm) = 114mm drill depth
```

### Plan View Symbol and Documentation

**Symbol visibility**:
- Appears only in plan view (looking down along +Z axis)
- Height above anchor: 100mm above anchor top
- Two symbols for double anchors (offset by interdistance)

**Color coding strategies**:
- **Color 1 (Red)**: High-priority connections, transfer loads
- **Color 3 (Green)**: Standard connections, routine installations
- **Color 4 (Cyan)**: Seismic-critical connections
- **Color 7 (White/Black)**: Default, adapts to drawing background

**Element view format examples**:
```
"%ArticleNumber%" → "VINYLPRO"
"%Manufacturer% %Model%" → "Rothoblaas M16"
"%Description%" → "Chemical anchoring system"
"Anchor: %ArticleNumber% (%Model%)" → "Anchor: VINYLPRO (M16)"
```

Leave empty if element view labels are not needed or clutter the drawing.

### Company-Specific Behavior

**Special modes** (detected from project settings):
- **BAUFRITZ**: Modifies no-nail area and element saw line generation
- **RUB**: Alternative no-nail area logic with element saw lines for each zone

**Detection**:
```c
String sSpecials[] = {"BAUFRITZ", "RUB"};
int nSpecial = sSpecials.find(projectSpecial().makeUpper());
```

**Instance color**:
- Standard mode: Color 5 (blue)
- Special mode (BAUFRITZ/RUB): Color 9 (light gray)

**Element view display**:
- Standard mode: No special display settings
- BAUFRITZ mode:
  - Dim style "BF 0.2"
  - Text height 75mm
  - Layer J5 for element zone 5

### Catalog Presets and Silent Insertion

**Create catalog preset**:
1. Place anchor with desired configuration
2. Select anchor instance
3. Right-click → "Save to Catalog" (standard TSL catalog system)
4. Enter preset name: `"WHT540_PartialNailing_20mmMill"`
5. Preset saved to drawing catalog

**Use preset silently**:
```
Command: TSLINSERT
Select script: Rothoblaas WHT
Execute key: WHT540_PartialNailing_20mmMill
```

Script loads configuration without showing dialog, proceeds directly to beam/panel selection.

**Batch placement workflow**:
1. Create catalog presets for common configurations:
   - `WHT340_Standard` (default settings)
   - `WHT540_HighLoad` (with washers, double anchor)
   - `WHT620_Seismic` (full nailing, reinforcement)
2. Use execute keys for rapid placement:
   - `TSLINSERT "Rothoblaas WHT" -k="WHT340_Standard"`
   - Select multiple beams
   - All anchors created with identical settings
3. Repeat for different configurations on different beam sets

### Performance and Session Management

**MapObject caching**:
- Fixture definitions loaded once per drawing session
- All instances share cached settings
- Changes propagate immediately via dependency tracking

**Execution loops**:
- Initial placement: 1 loop
- Property changes: 2 loops (forces hardware BOM update)
- Alignment changes (SIP mode): 2 loops

**Hardware BOM update timing**:
```c
if (_bOnDbCreated) setExecutionLoops(2);  // Force BOM update
```
Ensures hardware components are correctly published even when script is first created.

**Dependency management**:
```c
setDependencyOnDictObject(mo);  // Link to FixtureDefinition MapObject
setEraseAndCopyWithBeams(_kBeam0);  // Follow reference beam
```
Ensures anchor:
- Recalculates when fixture settings change
- Erases when reference beam is deleted
- Copies when reference beam is copied

## Technical Reference

### Script Classification

| Attribute | Value | Description |
|-----------|-------|-------------|
| **Script Type** | O-Type (Object) | Does not require pre-selected beams; prompts user during insertion for selection. Operates independently of command context. |
| **Script Name** | `Rothoblaas WHT` | Internal script name, also used as MapObject application tag and catalog identifier. |
| **Keywords** | `Anchor; Rothoblaas; Wall; Element` | Search terms for script browser and documentation lookup. |
| **Version** | 2.6 (April 17, 2024) | Current release version. |
| **Major Version** | 2 | Incremented for breaking changes or major feature additions. |
| **Minor Version** | 6 | Incremented for bug fixes and minor enhancements. |
| **File State** | 1 | Published/production state (vs. development/test). |

### Version History Highlights

| Version | Date | Key Changes |
|---------|------|-------------|
| **1.0** | Sep 13, 2016 | Initial version with basic WHT anchor placement on beams. |
| **1.1** | Jul 21, 2017 | Catalog insertion fixed, plan symbol added, assignment to Z0 layer. |
| **1.5** | Mar 12, 2018 | **Major update**: Anchor can be placed inside StickFrame walls (not just on exterior face), automatic plate drilling, height adjustment based on bottom plate detection, zone-based no-nail area oversize configuration, company-specific behavior modes. |
| **1.9** | Jul 9, 2019 | Alignment property added to SubMapX for element coordination. |
| **2.0** | Sep 20, 2021 | CNC contour publishing (`plCNC` map entry), **double anchor support** via Interdistance parameter, custom commands for editing fixtures. |
| **2.1** | Sep 22, 2021 | New property "Element view format", custom context menu commands for fixture editing. |
| **2.3** | Nov 24, 2021 | Added "Height" property for vertical position adjustment (HSB-13451). |
| **2.5** | Nov 7, 2022 | **Washer selection support**: Added Reinforcement Washer property with compatibility matrix (HSB-16852). |
| **2.6** | Apr 17, 2024 | **Current version**: No-nail areas clipped to sheet boundaries to prevent oversize zones in empty space (HSB-21887). Allows single-entry oversize value for incremental zone calculation. |

### Data Output and Integration

**DXA Output** (`#DxaOut 1`):
- 3D anchor body geometry exported to DXA
- Plan view symbol exported to DXA
- Display objects marked with `showInDxa(true)`
- Used by downstream manufacturing systems (CNC routers, nailing machines)

**CNC Contour Publishing**:
```c
_Map.setPLine("plCNC", pl);
```
- Published for zone 1 (or -1) only
- Polyline defines anchor outline for routing operations
- Consumed by hsbCNC for automated machining
- Includes milling oversize and no-nail area clearance
- Removed if polyline area < tolerance (`pow(dEps, 2)`)

**Hardware BOM Components** (up to 4 per instance):

**1. Anchor Component**:
```c
HardWrComp hwc(sMainScrew, nQty);  // Article = ground fixing selection, Qty = 1 or 2
hwc.setManufacturer("Rothoblaas");
hwc.setModel(sArticleName);  // WHT340, WHT440, etc.
hwc.setName(sArticleName);
hwc.setDescription("Tensile anchor - Type " + sArticleName);
hwc.setMaterial("Steel");
hwc.setCategory("Anchor");
hwc.setRepType(_kRTTsl);  // TSL-generated component
hwc.setDScaleX(dHeight);  // Anchor height
hwc.setDScaleY(dWidth);   // Anchor width
hwc.setDScaleZ(dDepth);   // Anchor depth
```

**2. Fastener Component** (nails or screws):
```c
HardWrComp hwc(sNailArticle, ppNails.length());  // Article = LBA440/LBS540/etc., Qty = nail count
hwc.setManufacturer("Rothoblaas");
hwc.setModel(sNailName);  // LBA440, LBS540, etc.
hwc.setName(sNailName);
hwc.setDescription(sNailType);  // "Anchor Nail LBA 4x40", etc.
hwc.setDScaleX(dNailLength);  // Fastener length
hwc.setDScaleY(dNailDia);     // Fastener diameter
```

**3. Ground Fixing Component**:
```c
HardWrComp hwc(sMainScrew, nQty);  // Article from FixtureDefinition.xml or default
// If using default fixtures:
hwc.setModel("M" + dMainScrewDia);  // M16, M20, M24, M27
hwc.setDescription(sMainScrew + " M" + dMainScrewDia);  // "VINYLPRO M16"
hwc.setDScaleY(dMainScrewDia);  // Bolt diameter

// If using custom fixtures from XML:
hwc.setManufacturer(m.getString("Manufacturer"));
hwc.setDescription(m.getString("Description"));
hwc.setCategory(m.getString("Category"));
hwc.setModel(m.getString("Model"));
hwc.setDScaleX(m.getDouble("ScaleX"));
hwc.setDScaleY(m.getDouble("ScaleY"));
hwc.setDScaleZ(m.getDouble("ScaleZ"));
```

**4. Reinforcement Washer Component** (if selected):
```c
HardWrComp hwc(sArticleReinfWasher, nQty);  // Article = WHTW50/WHTW70/etc.
hwc.setManufacturer("Rothoblaas");
hwc.setModel(sNameReinfWasher + " d" + dWasherDia);  // "WHTW50L d22"
hwc.setDescription("Washer " + sNameReinfWasher);
hwc.setDScaleX(dWasherWidth);      // Washer width
hwc.setDScaleY(dWasherDepth);      // Washer depth
hwc.setDScaleZ(dWasherThickness);  // Washer thickness
```

**Element Alignment SubMapX**:
```c
Map mapX;
mapX.setInt("InsideFrame", vecY.isParallelTo(el.vecX()));
_ThisInst.setSubMapX("ElementAlignment", mapX);
```
- `InsideFrame = 1`: Anchor faces parallel to element frame direction
- `InsideFrame = 0`: Anchor faces perpendicular to element frame
- Used by coordination scripts to detect anchor orientation

### Geometry Calculation Details

**Coordinate System**:
- `vecX`: Horizontal axis perpendicular to anchor face, parallel to beam width
- `vecY`: Anchor face normal, pointing outward from timber
- `vecZ`: Vertical axis (upward direction for wall anchors, custom for panels)

**Beam Mode Position Calculation**:
```c
// 1. Find bottom plane of beam
Plane pnBottom(bm.ptCen() - _ZW * 0.5 * bm.dL(), bm.vecX());

// 2. Get beam shadow profile in bottom plane
Body bdBeam = bm.envelopeBody();
PlaneProfile ppBeam = bdBeam.shadowProfile(pnBottom);

// 3. Project user point to beam profile (closest point on edge)
_Pt0 = ppBeam.closestPointTo(_Pt0);

// 4. Find inward direction to determine face normal
PlaneProfile ppBeam1 = ppBeam;
ppBeam1.shrink(U(-10));  // Expand profile outward
Point3d ptP0 = ppBeam1.closestPointTo(_Pt0);  // Interior point
vecY = (ptP0 - _Pt0);  // Vector pointing inward
vecY.normalize();

// 5. Construct coordinate system
vecX = vecY.crossProduct(_ZW);  // Horizontal
vecZ = vecX.crossProduct(vecY); // Vertical (upward)

// 6. Prevent anchor from overlapping beam edge
double dXpos = vecX.dotProduct(_Pt0 - bm.ptCen());
if (dXpos + dWidth*0.5 - bm.dD(vecX)*0.5 > 0)  // Right edge overlap
  _Pt0 = _Pt0 - vecX * (dXpos + dWidth*0.5 - bm.dD(vecX)*0.5);
if (dXpos - dWidth*0.5 + bm.dD(vecX)*0.5 < 0)  // Left edge overlap
  _Pt0 = _Pt0 + vecX * -1 * (dXpos - dWidth*0.5 + bm.dD(vecX)*0.5);
```

**Panel Mode Position Calculation**:
```c
// 1. Determine insert side (which panel face)
nSide = 1;
vecInsertSide = _Pt0 - sip.ptCen();
if (sip.vecZ().dotProduct(vecInsertSide) != 0)
  nSide = sip.vecZ().dotProduct(vecInsertSide) / abs(sip.vecZ().dotProduct(vecInsertSide));

// 2. Project point to panel surface
PlaneProfile ppSip(sip.plShadowCnc());
_Pt0 = ppSip.closestPointTo(_Pt0);
Plane pnInsert(sip.ptCen() + sip.vecZ()*nSide*0.5*sip.dH(), sip.vecZ());
_Pt0 = pnInsert.closestPointTo(_Pt0);

// 3. Construct coordinate system
vecZ = _Map.getVector3d("vecAlign");  // From user input or default
vecY = nSide * sip.vecZ();  // Panel face normal
vecX = vecY.crossProduct(vecZ);  // Horizontal
```

**Nail Hole Pattern Generation**:
```c
// Vertical spacing: 40mm
// Horizontal spacing: 20mm
// Top hole offset: varies by model (150-210mm from bottom)

// Double-row holes (every 40mm)
for (int i = 0; i < nQuantDouble; i++) {
  // Left hole (10mm from center)
  ppNail.transformBy(vecZ*i*U(40) + vecX*U(10));
  ppNails.append(ppNail);

  // Right hole (20mm spacing = 10mm from center on other side)
  ppNail.transformBy(-vecX*U(20));
  ppNails.append(ppNail);
}

// Triple-row holes (offset 20mm, every 40mm)
for (int i = 0; i < nQuantTriple; i++) {
  // Left hole
  ppNails.append(ppNail);

  // Center hole (full nailing only)
  ppNail.transformBy(vecX*U(20));
  if (nNailing == 0) ppNails.append(ppNail);
  else ppNotNailed.append(ppNail);

  // Right hole
  ppNail.transformBy(-vecX*U(40));
  if (nNailing == 0) ppNails.append(ppNail);
  else ppNotNailed.append(ppNail);
}
```

### Assignment and Layer Management

**Element Group Assignment** (when beam is part of element):
```c
assignToElementGroup(el, true, 0, 'E');
```
- Anchor assigned to element's group
- Entity type 'E' (element entity)
- Inherits element layer and visibility settings

**Standalone Assignment** (when beam is not part of element):
```c
assignToGroups(_GenBeam[0], 'Z');
```
- Anchor assigned to beam's group
- Layer type 'Z' (Z0 layer for visibility in plots)
- Ensures anchor is visible when plotting

**Erase and Copy Behavior**:
```c
setEraseAndCopyWithBeams(_kBeam0);
```
- Anchor follows reference beam during move/copy operations
- Anchor is automatically deleted when reference beam is deleted
- Maintains design integrity during model modifications

### Debugging and Visualization

**Debug Mode Activation**:
```c
int bDebug = _bOnDebug;
MapObject mo("hsbTSLDev", "hsbTSLDebugController");
if (mo.bIsValid()) {
  Map m = mo.map();
  for (int i = 0; i < m.length(); i++)
    if (m.getString(i) == scriptName()) {
      bDebug = true;
      break;
    }
}
```

**Debug Visualization** (when `bDebug = true`):
- Coordinate axes drawn with `.vis()` method:
  - `vecX.vis(_Pt0, 1)` → Red axis
  - `vecY.vis(_Pt0, 3)` → Green axis
  - `vecZ.vis(_Pt0, 5)` → Blue axis
- Intermediate geometry drawn on screen:
  - Bottom plane points
  - Beam profiles
  - No-nail area polylines
- Error checking disabled (prevents `eraseInstance()` on failure)
- Verbose console output: `reportMessage()` calls active

**Unit Handling**:
```c
U(1, "mm");  // Set default unit to millimeters
```
All dimensional values wrapped in `U()` function for automatic unit conversion between mm and inch drawing templates.

**Hyperlink**:
```c
_ThisInst.setHyperlink("http://www.rothoblaas.com/products/fastening/brackets-and-plates/tensile-angle-brackets-and-plates-for-buildings/wht");
```
Anchor instance includes clickable hyperlink to manufacturer product page for reference documentation.

## Troubleshooting

### Common Issues and Solutions

**Issue**: Script reports "No reference objects found ---> Tool will be deleted"
- **Cause**: No beams or SIP panels were selected, or selection was cancelled
- **Solution**: Ensure you select at least one beam or panel before pressing Enter

**Issue**: Script reports "X not vertical beams were filtered out"
- **Cause**: Selected beams are not vertical (X-axis not parallel to World Z)
- **Solution**: Only select vertical studs/posts. Check beam orientation with `BEAMDIR` command. Rotate beams if necessary to vertical orientation.

**Issue**: "Stud not wide enough to place two anchors, interdistance has been reset"
- **Cause**: Beam width < (anchor width + interdistance)
- **Solution**: Either increase stud width, reduce interdistance, or use single anchor (interdistance = 0)

**Issue**: "The reference beam is not vertical ---> Tool will be deleted"
- **Cause**: A horizontal or diagonal beam passed the selection filter but failed the vertical check during execution
- **Solution**: Script error-checking should prevent this. Report as bug if it occurs.

**Issue**: No-nail areas or automatic drilling don't appear
- **Cause 1**: hsbCAM module not available in current license
- **Cause 2**: Reference beam is not part of a StickFrame Wall element
- **Solution**:
  - Verify hsbCAM module license status
  - Ensure beam is part of an `ElementWallSF()` (create wall element if needed)
  - Check that "No nail areas" and "Drilling plate" are set to "Yes"

**Issue**: Reinforcement washer option disappears when changing anchor type
- **Cause**: Selected washer is not compatible with new anchor model
- **Solution**: Script automatically resets to first compatible washer. Review compatibility matrix in "Reinforcement Washer" parameter section above.

**Issue**: Plan view symbol not visible
- **Cause 1**: "Plan view Symbol" parameter set to "No"
- **Cause 2**: Current view direction not looking down along anchor Z-axis
- **Solution**:
  - Set "Plan view Symbol" to "Yes" in Properties Palette
  - Switch to plan view: `PLAN` command or `VIEW` → `Top`

**Issue**: Custom ground fixing doesn't appear in dropdown after editing
- **Cause**: Fixture was edited but not tagged for "Rothoblaas WHT" script
- **Solution**: Use "Add Fixture to Rothoblaas WHT" context menu command to tag the fixture

**Issue**: Settings changes don't persist across drawing sessions
- **Cause**: Changes made to MapObject but not exported to XML file
- **Solution**: Right-click anchor → "Export Settings" to save changes to `FixtureDefinition.xml`

**Issue**: Different fixture settings appear in different drawings
- **Cause**: Each drawing has its own company path or reads from different installation paths
- **Solution**: Use "Export Settings" in one drawing, copy `FixtureDefinition.xml` to company path, ensure all workstations point to same company path

**Issue**: "A different Version of the settings has been found" notice on instantiation
- **Cause**: MapObject version number differs from XML file version number
- **Solution**:
  - Use "Export Settings" to synchronize MapObject to XML
  - Or close drawing and reopen to reload from XML
  - Update XML file if installation has newer version

**Issue**: Anchor doesn't recalculate when property changed
- **Cause**: Script execution loop not triggered
- **Solution**: Select anchor, modify property value, press Enter or click away to confirm change. Script should recalculate automatically. If not, use `TSLRECALC` command.

**Issue**: Hardware BOM shows incorrect quantities
- **Cause**: Script uses cached hardware component array, needs recalculation
- **Solution**: Select anchor, change any property (even to same value), press Enter to force recalculation with `setExecutionLoops(2)`

**Issue**: Double-clicking anchor doesn't flip Z alignment
- **Cause 1**: Anchor is in beam mode (not panel mode)
- **Cause 2**: Double-click not registered by AutoCAD/hsbCAD
- **Solution**: Use context menu "Flip Z alignment" command instead of double-clicking

**Issue**: Element saw lines or sheet cut-outs missing in StickFrame Wall
- **Cause 1**: Company special mode set to BAUFRITZ or RUB (different logic)
- **Cause 2**: Wall zone 2 doesn't exist (sheet cut-out only created when zone 2 exists)
- **Cause 3**: Mill depth > 0 (sheet cut-out skipped when pocket milling active)
- **Solution**: Check project special setting, verify wall zone configuration, adjust mill depth parameter

## Related Scripts and Workflows

### Hardware Scripts (Rothoblaas Family)
- **Rothoblaas Titan F-N**: Flat angle brackets for beam-to-beam connections
- **Rothoblaas Titan V**: Angle brackets for rafter-to-wall connections
- **Rothoblaas WHT** (this script): Hold-down anchors for tension connections
- **Rothoblaas ALU**: Aluminum angle brackets for lightweight connections
- **Rothoblaas XYLOFON**: Screw-on angle brackets without nails
- **Rothoblaas Typ R**: Joist hangers for floor/ceiling systems
- **Rothoblaas Angle Bracket**: Generic angle bracket system

### Manufacturing Workflow Integration
1. **Design Phase**: Place WHT anchors using this script
2. **Validation**: Check hardware BOM with `HSB_G-BillOfMaterial`
3. **CNC Export**: Export `plCNC` contours with `hsbCNC` for routing
4. **Production Data**: Generate shop drawings with `sd_*` scripts
5. **Manufacturing**: Use hsbMake/hsbShare for CNC machine formats
6. **Assembly**: Reference element view labels and plan symbols during field installation

### Related Element Tools
- **HSB_E-NailClusters**: Automated nailing patterns for StickFrame walls (coordinates with no-nail areas)
- **HSB_E-Insulation**: Insulation layer management (must account for anchor depth)
- **HSB_G-Stack**: Logistics stacking (WHT anchors affect stack height calculations)
- **HSB_W-Blocking**: Wall blocking distribution (may conflict with anchor placement)

### Shop Drawing Scripts
- **sd_ABeamcutDE**: Shop drawing annotation for beam cuts (includes anchor milling pockets)
- **sd_DrillDE**: Drilling detail drawings (includes automatic plate drills)
- **sd_MetalPartEntity**: Hardware placement drawings (includes WHT anchor positions)

### Quality Control
- **HSB_I-ShowElementInfo**: Display element information including attached hardware components
- **HSB_G-EntityInformation**: Query individual entity properties and tooling operations
- **hsbRP_Analysis**: Structural analysis reports including anchor specifications

## Additional Resources

**Manufacturer Documentation**:
- Rothoblaas WHT Product Page: http://www.rothoblaas.com/products/fastening/brackets-and-plates/tensile-angle-brackets-and-plates-for-buildings/wht
- Technical datasheets for load capacities, installation requirements, and code approvals

**hsbCAD Documentation**:
- TSL Programming Reference Manual (for script customization)
- Hardware Component System Guide (for BOM integration)
- hsbCAM Module Documentation (for tooling operations)

**Training Videos**:
- hsbCAD YouTube channel: Hardware placement workflows
- Rothoblaas installation videos: Proper anchor installation techniques

**Support**:
- hsbCAD Technical Support: support@hsbcad.com
- Rothoblaas Technical Support: For product-specific questions
- User Forums: Community discussions on advanced usage patterns
