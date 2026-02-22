# NA_DIM_GENBEAMS_AT_VIEWPORT_SIDE

## Overview and Purpose

**NA_DIM_GENBEAMS_AT_VIEWPORT_SIDE** is a professional shop drawing dimensioning tool that automatically generates dimension chains along the edges of an element viewport in Paper Space (Layout). This script is specifically designed for North American timber framing fabrication drawings, where precise member positioning is critical for manufacturing.

The script measures the positions of beams and sheets within an hsbCAD element (wall, floor, or roof assembly) and creates dimension lines with witness lines extending from each member. It supports both **cumulative** (running) dimensions and **delta** (incremental) dimensions, with extensive filtering capabilities to dimension only the members you need.

### Key Capabilities

- **Automatic Dimension Placement**: Generates dimension chains along any of the four viewport edges (left, right, top, bottom)
- **Advanced Filtering**: Uses Painter Definitions to include/exclude specific beam types (studs vs. headers, etc.)
- **Visual Emphasis**: Optional hatching of dimensioned members with customizable patterns, colors, and transparency
- **Per-Element Configuration**: Different dimension settings for each element in multi-page shop drawing sets
- **Interactive Repositioning**: Drag dimension lines using grip points while maintaining associations
- **Beam Packing**: Automatically groups adjacent/overlapping members to reduce dimension clutter
- **Zone-Based Selection**: Dimension members from specific element zones (inside container, front/back faces, etc.)

### Typical Use Cases

1. **Wall Panel Shop Drawings**: Dimension stud spacing from bottom plate to top plate
2. **Floor Joist Layouts**: Create cumulative dimensions showing joist positions across a floor assembly
3. **Roof Truss Placement**: Dimension truss locations for accurate field installation
4. **Multi-Layer Wall Details**: Dimension different layers (framing, sheathing) independently using zone filters
5. **Header and Opening Layouts**: Combine inclusion/exclusion filters to dimension only specific member types

---

## Technical Specifications

| Property | Value |
|----------|-------|
| **Script Type** | O-Type (Object — standalone TSL instance) |
| **Workspace** | Paper Space (Layout / Shop Drawing viewport) |
| **Required Beams** | 0 (operates on viewport element, not individual beams) |
| **Implicit Insertion** | Yes (#ImplInsert 1) |
| **Language Support** | English (en-US), French Canadian (fr-CA) |
| **Version** | 0.19 (October 17, 2023) |
| **Grip Points** | Dynamic (dimension line position grip in Dynamic mode) |

---

## Prerequisites

Before using this script, ensure the following conditions are met:

### Required Setup

1. **Shop Drawing Layout Exists**: You must have a Paper Space layout (tab) with at least one viewport displaying an hsbCAD element
2. **Valid Element in Viewport**: The viewport must contain a valid Element entity (wall, floor, or roof) with beams and/or sheets
3. **Dimension Style Available**: A dimension style must be defined in your drawing (default: "NA Shopdrawing")
   - If "NA Shopdrawing" style doesn't exist, select an alternative style during configuration
   - The dimension style controls arrowhead size, text font, precision, and other formatting

### Optional (For Advanced Filtering)

4. **Painter Definitions**: To use inclusion/exclusion filters, create Painter Definitions of type "GenBeam" in your drawing
   - Example: Create a Painter Definition named "Studs Only" that filters beams by size (e.g., 2x6 only)
   - Example: Create "Exclude Headers" to remove header beams from dimensions

### Drawing Unit System

The script automatically detects metric vs. imperial unit systems and applies appropriate defaults:
- **Metric drawings** (mm): Default dimension line offset = 4 mm
- **Imperial drawings** (inches): Default dimension line offset = 5/32 inch

---

## Installation and First-Time Insertion

### Step 1: Access the Script

In Paper Space (Layout tab), run the TSL insertion command:
```
Command: TSLINSERT
```
Then browse to and select `NA_DIM_GENBEAMS_AT_VIEWPORT_SIDE.mcr`

### Step 2: Select Viewport

When prompted at the command line:
```
Select element viewport
```
Click on the viewport containing the element you want to dimension. The script validates that:
- The selected object is a valid viewport
- The viewport contains a valid hsbCAD Element entity

If validation fails, the script reports an error and erases itself.

### Step 3: Configure Dimension Properties

After viewport selection, a properties dialog opens immediately with four category tabs:

1. **Dimension Options** — Hatching and visual display settings
2. **Beams/Sheets to Dimension** — What to measure
3. **Beams/Sheets to Reference** — Boundary reference points (e.g., plates)
4. **Dimension Style and Positioning** — Dimension line location, style, and text formatting

Configure the settings according to your requirements (see detailed parameter reference below) and click **OK**.

### Step 4: Initial Dimension Display

The dimension line and witness lines are drawn automatically in Paper Space along the chosen viewport edge. If "Dimension line position" is set to **Dynamic** (default), a grip point appears at the dimension line location for manual repositioning.

**Important**: The script only allows a single insertion cycle. If you attempt to insert again without canceling, the instance will erase itself. To modify settings after insertion, use the right-click context menu.

---

## Parameter Reference

All parameters are accessible through the OPM (Object Properties Manager) dialog. Parameters are organized into four categories.

### Category 1: Dimension Options

These settings control visual display and hatching of dimensioned members.

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Dimensioned entities** | Dropdown | Dimensioned and referenced | • Dimensioned and referenced<br>• Dimensioned only<br>• Referenced only<br>• Reference to self | Controls which beam sets contribute to the dimension chain.<br>• **Dimensioned and referenced**: Uses both dimensioned beams (measured) and reference beams (boundary markers like plates).<br>• **Dimensioned only**: Ignores reference beams; dimension chain has no start/end boundary markers.<br>• **Referenced only**: Ignores dimensioned beams; only reference beams are shown.<br>• **Reference to self**: Uses dimensioned beams as their own reference (self-referencing mode for special cases). |
| **Hatch pattern** | Dropdown | None | • None<br>• SOLID<br>• (all hatch patterns in drawing) | Applies a hatch pattern to the outlines of dimensioned and referenced beam/sheet cross-sections for visual emphasis in the shop drawing. Select **None** to disable hatching entirely. |
| **Hatch scale** | Number (unitless) | 1.0 | Any positive number | Controls the scale of the hatch pattern in Paper Space. The value is automatically multiplied by the viewport scale factor to maintain correct appearance. Increase for larger hatch spacing; decrease for tighter spacing. |
| **Hatch angle** | Angle | 0° | Any angle in degrees | Rotation angle of the hatch pattern lines. Use 45° for diagonal hatching, 0° for horizontal, 90° for vertical. |
| **Hatch colour** | Integer | -1 (inherit) | -1, or any AutoCAD Color Index (ACI) | Color for the hatch display. Set to **-1** to inherit the color from the TSL instance itself (recommended). Valid ACI values: 1–255. Common values: 1 (red), 2 (yellow), 3 (green), 4 (cyan), 5 (blue), 7 (white/black). |
| **Hatch transparency** | Integer (%) | 60 | 0 to 100 | Transparency percentage applied when the hatch pattern is set to **SOLID**. Higher values make the fill more see-through, allowing underlying drawing details to remain visible. This setting only takes effect when **Hatch pattern** is set to SOLID; other patterns ignore transparency. 0 = opaque, 100 = fully transparent. |

**Hatching Workflow**:
1. Set **Hatch pattern** to "SOLID" and **Hatch transparency** to 60 for semi-transparent highlighting
2. Or choose a standard pattern like "ANSI31" with **Hatch scale** = 1.0 and **Hatch angle** = 45° for diagonal lines
3. Set **Hatch colour** to 3 (green) to highlight dimensioned members in a specific color

---

### Category 2: Beams/Sheets to Dimension

These settings control **which beams/sheets are measured** by the dimension chain and **how their characteristic points are extracted**.

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Element side** | Dropdown | Entire element | • Entire element<br>• Half of element | When set to **Half of element**, only beams/sheets located in the half of the element closest to the dimension line are dimensioned. This is useful for double-sided walls where you want to measure members on one face only. Beams that overlap the midpoint boundary are included. |
| **Element zone** | Integer Dropdown | Zone 1 | • Zone 0<br>• Zone 1 through Zone 5<br>• Zone -1 through Zone -5 | Selects which element zone the dimensioned beams belong to. Zone assignments follow hsbCAD element zone conventions:<br>• **Zone 0**: Inside element container (plates, rim joists, chords)<br>• **Zones 1–5**: Front of wall container, or top of floor/roof container (exterior sheathing, studs on front face)<br>• **Zones -1 to -5**: Back of wall container, or bottom of floor/roof container (interior sheathing, studs on back face)<br><br>For typical North American wall panel dimensioning, use **Zone 1** for studs and **Zone 0** for plates. |
| **Include filter** | Dropdown | None | • None<br>• (Painter Definitions of type GenBeam) | An inclusion filter using a Painter Definition. When set, only beams/sheets matching the Painter Definition criteria at the selected zone will be dimensioned. Set to **None** to include all beams in the zone without filtering.<br><br>**Example**: Create a Painter Definition named "2x6 Studs Only" that filters by material name and size, then select it here to dimension only 2x6 studs while excluding headers, sills, cripples, etc. |
| **Exclude filter** | Dropdown | None | • None<br>• (Painter Definitions of type GenBeam) | An exclusion filter using a Painter Definition. Beams/sheets matching this filter are removed from the dimensioned set. When both Include and Exclude filters are active, **inclusion is applied first**, then **exclusion removes matching items from that result**.<br><br>**Example**: Set Include filter to "All Studs" and Exclude filter to "Jack Studs" to dimension only king studs and common studs, excluding jack studs at openings. |
| **Points to dimension** | Dropdown | Start point | • Start point<br>• Middle point<br>• End point<br>• Start and end points<br>• All points | Determines which characteristic points of each beam/sheet outline serve as dimension witness points along the dimension line direction.<br>• **Start point**: Uses the first edge (bottom of vertical members, left of horizontal members).<br>• **End point**: Uses the last edge (top of vertical members, right of horizontal members).<br>• **Start and end points**: Uses both extremes; creates two witness lines per member.<br>• **Middle point**: Uses the midpoint of the beam outline edge closest to the dimension line (centerline dimensioning).<br>• **All points**: Includes every outline vertex; useful for complex non-rectangular profiles. |
| **Beam/Sheet side** | Dropdown | Entire beam/sheet | • Entire beam/sheet<br>• Half of beam/sheet<br>• Closest edge of beam/sheet | Controls which portion of each beam/sheet outline contributes dimension points.<br>• **Entire beam/sheet**: Uses all outline vertices (default).<br>• **Half of beam/sheet**: Only uses points on the half of the beam closest to the dimension line. For vertical dimensions on a vertical stud, this would use only the left or right half face.<br>• **Closest edge of beam/sheet**: Uses only the single edge face of the beam nearest to the dimension line. This creates cleaner dimensions for rectangular members. |
| **Pack dimensioned beams/sheets** | Dropdown | No | • Yes<br>• No | When set to **Yes**, adjacent beams/sheets whose outlines overlap or touch are merged (Boolean union) into a single combined outline before extracting dimension points. This reduces the number of dimension witness lines for cleaner drawings.<br><br>**Especially useful for**:<br>• Doubled studs (king stud + jack stud side-by-side)<br>• Built-up headers (multiple plies laminated together)<br>• Closely packed members with no gap between them<br><br>The packing algorithm applies a 1mm shrink/expand smoothing cycle to close tiny gaps, then splits the result into separate "lumps" (disconnected regions) before extracting dimension points from each lump. |

**Typical Configuration Examples**:

- **Standard Stud Layout Dimensioning**:
  - Element zone = Zone 1
  - Include filter = None (or "Studs Only" if you have one)
  - Exclude filter = None
  - Points to dimension = Start point
  - Beam/Sheet side = Entire beam/sheet
  - Pack dimensioned beams/sheets = No

- **Doubled Stud Dimensioning (Treat Pairs as Single Unit)**:
  - Element zone = Zone 1
  - Include filter = "Studs Only"
  - Pack dimensioned beams/sheets = **Yes**
  - Points to dimension = Start point
  - Beam/Sheet side = Closest edge of beam/sheet

- **Centerline Dimensioning**:
  - Points to dimension = **Middle point**
  - Beam/Sheet side = Entire beam/sheet

---

### Category 3: Beams/Sheets to Reference

Reference beams provide the **start and/or end boundary points** for the dimension chain. For example, the top and bottom plates of a wall that frame the dimensioned studs would serve as references.

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Element side** | Dropdown | Entire element | • Entire element<br>• Half of element | Same behavior as the dimensioned category. When set to **Half of element**, only reference beams on the half closest to the dimension line are considered. |
| **Element zone** | Integer Dropdown | Zone 0 | • Zone 0<br>• Zone 1 through Zone 5<br>• Zone -1 through Zone -5 | Selects which element zone the reference beams belong to. Typically set to **Zone 0** (inside the element container) so that plates or boundary members serve as reference endpoints.<br><br>For wall panels: Zone 0 contains bottom plate, top plate, and rim/header members.<br>For floor assemblies: Zone 0 contains rim joists and perimeter beams. |
| **Include filter** | Dropdown | None | • None<br>• (Painter Definitions of type GenBeam) | Inclusion filter for reference beams. Identical in behavior to the dimensioned-beams inclusion filter. Use this if your plates have mixed sizes and you want to reference only specific plate members. |
| **Exclude filter** | Dropdown | None | • None<br>• (Painter Definitions of type GenBeam) | Exclusion filter for reference beams. Identical in behavior to the dimensioned-beams exclusion filter. |
| **Points to reference** | Dropdown | Start and end points | • Start point<br>• End point<br>• Start and end points | Determines which edges of the combined reference outline serve as start/end anchor points for the dimension chain.<br>• **Start and end points** (default): Places reference marks at both the beginning and end of the chain to establish the full measurement range (e.g., bottom plate edge and top plate edge).<br>• **Start point**: Only the bottom/left reference edge is marked.<br>• **End point**: Only the top/right reference edge is marked. |
| **Beam/Sheet side** | Dropdown | Entire beam/sheet | • Entire beam/sheet<br>• Half of beam/sheet<br>• Closest edge of beam/sheet | Same behavior as for dimensioned beams, but applied to reference beams. Typically left at **Entire beam/sheet** for plates. |

**Reference Beam Workflow**:

For a typical wall panel with bottom plate and top plate:
1. Set **Element zone** = Zone 0 (plates are in the container zone)
2. Set **Points to reference** = Start and end points
3. The dimension chain will span from the bottom plate to the top plate
4. All dimensioned studs (from Category 2 settings) will be measured relative to these reference boundaries

**What if I don't have reference beams?**
- Set **Dimensioned entities** (Category 1) to "Dimensioned only"
- The dimension chain will measure between the outermost dimensioned beams without explicit reference boundaries

---

### Category 4: Dimension Style and Positioning

These settings control the dimension line location, AutoCAD dimension style, and text formatting.

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Dimension orientation** | Dropdown | Vertical left | • Vertical left<br>• Vertical right<br>• Horizontal top<br>• Horizontal bottom | Specifies which side of the viewport the dimension line is placed on and the measurement direction.<br>• **Vertical left**: Dimension line to the left of viewport, measuring vertically upward (normal direction).<br>• **Vertical right**: Dimension line to the right of viewport, measuring vertically upward.<br>• **Horizontal top**: Dimension line above viewport, measuring horizontally to the right.<br>• **Horizontal bottom**: Dimension line below viewport, measuring horizontally to the right. |
| **Dimension direction** | Dropdown | Normal | • Normal<br>• Reverse | Reverses the measurement direction of the dimension line. Normal directions are vertical upward and horizontal rightward. Choose **Reverse** to flip the measurement order (vertical downward or horizontal leftward). This is useful when dimension text should read in the opposite direction. |
| **Dimension type** | Dropdown | Cummulative | • Delta<br>• Cummulative | • **Delta**: Creates incremental dimensions measuring the distance between each consecutive pair of points. Each dimension segment shows the spacing between adjacent members.<br>• **Cumulative** (default): Creates running dimensions measuring from the reference start/end points to each dimensioned point. Each dimension value shows the cumulative distance from the origin (standard for North American shop drawings). |
| **Dimension line offset** | Length | 4 mm (metric)<br>5/32 in (imperial) | Any positive length in Paper Space units | The offset distance from the viewport edge (in **Static** mode) or from the outermost dimensioned/reference points (in **Dynamic** mode) to the dimension line.<br><br>This value is specified in Paper Space units (mm or inches). Increase to move the dimension line farther from the viewport/members; decrease to bring it closer. |
| **Dimension line position** | Dropdown | Dynamic | • Static<br>• Dynamic | • **Static**: Places the dimension line at a fixed offset from the **viewport edge**. The dimension line always stays at the same distance from the viewport boundary, regardless of beam positions.<br>• **Dynamic** (default): Calculates an initial position based on the outermost beam outlines plus the specified offset, and allows you to **reposition the dimension line by dragging its grip point**. The grip point appears in Paper Space and can be moved perpendicular to the dimension line. The new position is saved per element and persists across drawing save/reload cycles. |
| **Project points to dimension line** | Dropdown | Yes | • Yes<br>• No | • **Yes** (default): All dimension witness points are projected perpendicularly onto the dimension line, resulting in clean perpendicular leader lines from the beams to the dimension line.<br>• **No**: Leader lines extend from the actual beam edge points directly to the dimension line, which may produce angled leaders for non-orthogonal members or when beams are skewed relative to the dimension line direction. |
| **Dimension style** | Dropdown | NA Shopdrawing | (all dimension styles defined in the drawing) | Selects which AutoCAD dimension style to apply. The dimension style controls:<br>• Arrowhead type and size<br>• Text font, height, and color<br>• Precision (decimal places or fractional precision)<br>• Tolerances and limits<br>• Extension line overshoot and offset<br>• All other standard AutoCAD dimension formatting properties<br><br>If "NA Shopdrawing" is not available in your drawing, select an alternative style from the dropdown. |
| **Text height** | Length | 0 (use style default) | 0 or any positive length in Paper Space units | Overrides the dimension text height from the selected dimension style. Set to **0** (default) to use the height defined in the dimension style. Set to a positive value (e.g., 3 mm or 1/8 inch) to override the style's text height for this dimension instance only.<br><br>This is useful when you want to use a standard dimension style but need larger or smaller text for a specific shop drawing layout. |
| **Text side** | Dropdown | Away from dimensioned points | • Away from dimensioned points<br>• Towards dimensioned points | Controls on which side of the dimension line the dimension text values are placed, relative to the dimensioned members.<br>• **Away from dimensioned points** (default): Text appears on the far side of the dimension line, away from the beams (standard North American practice).<br>• **Towards dimensioned points**: Text appears between the dimension line and the beams. |
| **Text orientation** | Dropdown | Perpendicular | • Parallel<br>• Perpendicular | Controls the rotation of dimension text relative to the dimension line.<br>• **Perpendicular** (default): Places text at 90 degrees to the dimension line. For vertical dimensions, this makes text read horizontally (standard for North American shop drawings). For horizontal dimensions, text reads vertically.<br>• **Parallel**: Aligns text along the dimension line direction. For vertical dimensions, text reads vertically; for horizontal dimensions, text reads horizontally. |

**Typical Configuration Examples**:

- **Standard North American Wall Panel Dimensioning** (Cumulative vertical dimensions on left side):
  - Dimension orientation = Vertical left
  - Dimension direction = Normal
  - Dimension type = Cummulative
  - Dimension line offset = 5/32 in (imperial) or 4 mm (metric)
  - Dimension line position = Dynamic
  - Project points to dimension line = Yes
  - Dimension style = NA Shopdrawing
  - Text height = 0 (use style default)
  - Text side = Away from dimensioned points
  - Text orientation = Perpendicular

- **Horizontal Floor Joist Spacing** (Delta dimensions showing spacing between joists):
  - Dimension orientation = Horizontal top
  - Dimension direction = Normal
  - Dimension type = **Delta**
  - Text orientation = Perpendicular (text reads horizontally)

- **Custom Text Size Override**:
  - Dimension style = Standard (from drawing template)
  - Text height = **3.5** (override to 3.5 mm for larger text in this layout)

---

## Usage Workflows

### Workflow 1: Basic Wall Panel Stud Dimensioning

**Goal**: Create cumulative vertical dimensions showing stud positions from bottom plate to top plate.

1. **Ensure Prerequisites**:
   - Paper Space layout with viewport showing wall element
   - Wall has beams in zones: Zone 0 (plates), Zone 1 (studs)

2. **Insert Script**:
   - Command: `TSLINSERT`
   - Select: `NA_DIM_GENBEAMS_AT_VIEWPORT_SIDE.mcr`
   - Click on viewport when prompted

3. **Configure Dialog** (Categories 1–4):

   **Category 1: Dimension Options**
   - Dimensioned entities = Dimensioned and referenced
   - Hatch pattern = SOLID
   - Hatch transparency = 60
   - (Leave other hatch settings at defaults)

   **Category 2: Beams/Sheets to Dimension**
   - Element side = Entire element
   - Element zone = Zone 1 (studs)
   - Include filter = None (or "Studs Only" if available)
   - Exclude filter = None
   - Points to dimension = Start point
   - Beam/Sheet side = Entire beam/sheet
   - Pack dimensioned beams/sheets = No

   **Category 3: Beams/Sheets to Reference**
   - Element side = Entire element
   - Element zone = Zone 0 (plates)
   - Points to reference = Start and end points
   - (Leave other settings at defaults)

   **Category 4: Dimension Style and Positioning**
   - Dimension orientation = Vertical left
   - Dimension direction = Normal
   - Dimension type = Cummulative
   - Dimension line offset = 4 mm (or 5/32 in)
   - Dimension line position = Dynamic
   - Project points to dimension line = Yes
   - Dimension style = NA Shopdrawing
   - Text height = 0
   - Text side = Away from dimensioned points
   - Text orientation = Perpendicular

4. **Click OK**: Dimension line appears with cumulative dimensions from bottom plate to top plate, with witness lines at each stud.

5. **Adjust Position** (Optional):
   - A grip point appears at the dimension line
   - Click and drag the grip point to move the dimension line closer to or farther from the viewport
   - Release to fix the position

---

### Workflow 2: Doubled Stud Dimensioning with Packing

**Goal**: Dimension king studs + jack studs as single units (treat doubled studs as one dimension point).

**Prerequisites**:
- Create a Painter Definition named "Studs Only" that filters beams by size (e.g., 2x6 nominal size)
- Exclude plates, headers, sills, cripples

**Configuration Changes** (relative to Workflow 1):

**Category 2: Beams/Sheets to Dimension**
- Include filter = **Studs Only**
- Points to dimension = **Start point**
- Beam/Sheet side = **Closest edge of beam/sheet**
- Pack dimensioned beams/sheets = **Yes** ← This merges adjacent studs

**Result**: Doubled studs (king + jack) are merged into a single outline via Boolean union, then a single dimension witness line is placed at the combined unit's start edge. This prevents duplicate dimensions for closely spaced members.

---

### Workflow 3: Centerline Dimensioning

**Goal**: Dimension to the centerline of each member instead of edge faces.

**Configuration Changes**:

**Category 2: Beams/Sheets to Dimension**
- Points to dimension = **Middle point**
- Beam/Sheet side = Entire beam/sheet

**Result**: One dimension witness line per member, located at the beam centerline (midpoint of the outline edge closest to the dimension line).

---

### Workflow 4: Per-Element Overrides for Multi-Page Layouts

**Goal**: Use the same dimension instance across multiple elements in a multi-page shop drawing set, but customize settings for one specific element.

**Scenario**: You have 10 wall panels in a multi-page layout controller. Wall #5 needs different zone settings (Zone 2 instead of Zone 1).

**Steps**:

1. **Navigate to Wall #5 Layout Page**: Switch to the Paper Space tab/page showing Wall #5.

2. **Select Dimension Instance**: Click on the existing dimension instance.

3. **Right-Click** → **Add properties override for current element**

4. **Modify Settings** in the override dialog:
   - Element zone = **Zone 2** (override only for this wall)
   - (Leave other settings unchanged)

5. **Click OK**: Wall #5 now uses Zone 2 for dimensioned beams, while all other walls continue using Zone 1.

6. **To Remove Override Later**:
   - Navigate to Wall #5 page
   - Select dimension instance
   - Right-click → **Remove properties override for current element**
   - Wall #5 reverts to shared default settings

---

### Workflow 5: Filtering by Include + Exclude Combination

**Goal**: Dimension only common studs and king studs, excluding jack studs, headers, and cripples.

**Prerequisites**:
- Create Painter Definition "All Vertical Members" (includes studs, jacks, cripples by size filter)
- Create Painter Definition "Jack Studs Only" (filters by position near openings or by custom property)

**Configuration**:

**Category 2: Beams/Sheets to Dimension**
- Include filter = **All Vertical Members** ← First pass: Select all vertical members
- Exclude filter = **Jack Studs Only** ← Second pass: Remove jack studs from the result
- Points to dimension = Start point
- Pack dimensioned beams/sheets = No

**Result**: The inclusion filter selects all vertical members (studs, jacks, cripples). Then the exclusion filter removes jack studs from that set. The final dimension chain shows only common studs and king studs.

**Processing Order**: `Include → Exclude → Zone Filter → Element Side Filter → Beam Side Filter → Extract Points`

---

## Right-Click Context Menu

When you select the dimension instance in Paper Space and right-click, the following context menu items are available:

| Menu Item | Function |
|-----------|----------|
| **Edit dimension properties** | Opens the full properties dialog with all four categories, allowing you to modify any dimension setting. Changes apply **globally** to all elements unless a per-element override exists for a particular element. After clicking OK, the dimension regenerates immediately. |
| **Add properties override for current element** | Creates a **per-element** copy of the current properties for the active element's viewport only. The override dialog opens immediately for editing. Once created, subsequent changes to the shared default properties will not affect elements that have overrides. Use this for multi-page layouts where most elements share settings but one or two elements need special configuration. |
| **Remove properties override for current element** | Deletes the per-element property override for the current element, reverting it to use the shared default settings. The dimension regenerates immediately using the global defaults. |
| **Reset grip points for current element** | Removes all custom grip point positions for the current element's viewport. The dimension line position and any other grip-controlled positions will recalculate to their automatic defaults based on beam geometry. Use this if you manually repositioned the dimension line and want to restore the automatic calculated position. |

**Important Notes**:
- **Global vs. Per-Element Settings**: By default, all elements share one set of properties (global). When you create a per-element override, that specific element uses its own independent copy of the settings.
- **Override Identification**: When you select a dimension instance that has a per-element override, the command line reports: `"This is an override for element <number>"`
- **Persistent Grip Positions**: Grip point positions are stored per element in the Map data structure keyed by element handle. They persist across drawing save/reload cycles.

---

## Advanced Features

### Dependent TSL Scripts (Child Dimension Scripts)

This script supports **dependent (child) TSL scripts** such as `NA_DIM_GENBEAMS_DIAGONAL`. When dependent TSL instances are registered in the parent script's Map data under the `"Dependants"` key, this script automatically passes viewport coordinate system data, element reference, and dimension direction information to each dependent script on every recalculation.

**Data Passed to Dependent Scripts**:
- The associated Element entity reference
- The dimension direction vector (vertical or horizontal, normal or reversed)
- The full viewport coordinate system (origin point, X/Y/Z axis vectors in model space)
- The viewport center point in Paper Space
- The viewport width and height in Paper Space

This allows child dimension scripts to align their measurements with the parent viewport context without needing to independently query the viewport. For example, `NA_DIM_GENBEAMS_DIAGONAL` can create diagonal dimension lines that are synchronized with the parent's dimension orientation.

**How to Use Dependent Scripts** (Advanced):
1. Insert `NA_DIM_GENBEAMS_AT_VIEWPORT_SIDE` (parent) and configure it
2. Insert the dependent script (e.g., `NA_DIM_GENBEAMS_DIAGONAL`)
3. Use the dependent script's interface to register itself with the parent
4. The parent will automatically provide viewport context data to the dependent on each recalculation

---

### Beam Packing Algorithm (Pack Dimensioned Beams/Sheets)

When **Pack dimensioned beams/sheets** is set to **Yes**, the script performs the following operations:

1. **Collect Outlines**: Extract outlines for all dimensioned beams/sheets
2. **Boolean Union**: Merge all outlines into a single combined outline using `PlaneProfile.unionWith()`
3. **Smoothing Cycle**: Apply a small shrink/expand cycle (1 mm) to close tiny gaps and smooth the result:
   - `outJoinedOutline.shrink(-1 mm)` → Expand by 1 mm
   - `outJoinedOutline.shrink(+1 mm)` → Shrink back by 1 mm
   - `outJoinedOutline.simplify()` → Simplify the outline geometry
4. **Split into Lumps**: Extract separate "lumps" (disconnected outline regions) from the combined outline
5. **Extract Points**: For each lump, extract dimension points based on the "Points to dimension" setting

**Result**: Adjacent or overlapping beams are treated as single units. This is especially useful for:
- Doubled studs (king + jack)
- Built-up headers (multiple plies)
- Closely packed members with no gap

**Performance Note**: Packing involves Boolean operations and can be slower for elements with hundreds of beams. Use packing selectively when needed.

---

### Zone Selection System

hsbCAD elements (walls, floors, roofs) organize beams and sheets into **zones** based on their position relative to the element container:

| Zone Index | Location | Typical Members (Wall) | Typical Members (Floor/Roof) |
|------------|----------|------------------------|------------------------------|
| **Zone 0** | Inside element container | Bottom plate, top plate, headers, sills | Rim joists, perimeter beams, blocking |
| **Zone 1** | Front of wall / Top of floor or roof | Exterior studs, exterior sheathing | Joists, top sheathing (roof deck) |
| **Zone 2** | Front of wall / Top of floor or roof (farther) | Second layer sheathing | Insulation, additional layers |
| **Zone 3–5** | Front of wall / Top of floor or roof (even farther) | Additional layers | Additional layers |
| **Zone -1** | Back of wall / Bottom of floor or roof | Interior studs, interior sheathing | Ceiling sheathing, bottom layer |
| **Zone -2** | Back of wall / Bottom of floor or roof (farther) | Second layer interior sheathing | Additional layers |
| **Zone -3 to -5** | Back of wall / Bottom of floor or roof (even farther) | Additional layers | Additional layers |

**Dimension Strategy by Zone**:
- **Dimensioned beams zone** = Zone 1 (studs, joists)
- **Reference beams zone** = Zone 0 (plates, rim joists)

**Special Case — Multi-Layer Walls**:
For a double-sided wall with different stud layouts on front and back faces:
1. Insert dimension instance with Zone 1 (front face studs) on the left side of viewport
2. Insert a second dimension instance with Zone -1 (back face studs) on the right side of viewport
3. Each instance dimensions its own layer independently

---

### Element Side Filtering (Half of Element)

When **Element side** is set to **Half of element**, the script calculates a bounding box for the overall element outline, then splits it in half perpendicular to the dimension line direction. Only beams/sheets whose outlines intersect the half closest to the dimension line are included.

**Use Case**: Double-sided walls where both faces have members in the same zone, but you want to dimension each face separately.

**Algorithm**:
1. Get overall element outline from all beams in the selected zones
2. Extract outline vertices and order them along the direction away from the dimension line
3. Find the midpoint of the element extent in that direction
4. Create a bounding rectangle from the element midpoint to the far edge (closest to dimension line)
5. Test each beam outline for intersection with the bounding rectangle
6. Remove beams that don't intersect

**Result**: Only beams on the half of the element closest to the dimension line are dimensioned.

---

### Beam/Sheet Side Filtering (Half of Beam/Sheet, Closest Edge)

The **Beam/Sheet side** parameter controls which portion of each individual beam/sheet outline contributes dimension points:

| Option | Behavior |
|--------|----------|
| **Entire beam/sheet** | Uses all outline vertices (default). For a rectangular stud, all four corners are candidates for dimension points. |
| **Half of beam/sheet** | Only uses points on the half of the beam closest to the dimension line. For a vertical dimension on a vertical stud, this would use only the left or right half of the stud face. |
| **Closest edge of beam/sheet** | Uses only the single edge face of the beam nearest to the dimension line. For a rectangular stud and a vertical dimension, this would use only the left edge or right edge (whichever is closer), resulting in two points (top and bottom of that edge). |

**Typical Usage**:
- **Entire beam/sheet**: Default; most common
- **Closest edge of beam/sheet**: Use with "Start and end points" or "Start point" to create clean edge-based dimensions
- **Half of beam/sheet**: Advanced use cases for complex non-rectangular profiles

---

### Grip Point System (Dynamic Mode)

When **Dimension line position** is set to **Dynamic**, a grip point appears at the calculated dimension line location. You can interactively reposition the dimension line by dragging this grip point.

**Grip Point Behavior**:
1. **Initial Position**: Calculated based on the outermost dimensioned/reference beam outline plus the specified **Dimension line offset**
2. **Drag Operation**: Click and hold the grip point, then move the mouse perpendicular to the dimension line direction
3. **Constraint**: The grip point is constrained to move only perpendicular to the dimension line (no movement along the dimension line direction)
4. **Persistence**: The new grip point position is saved in the Map data structure keyed by element handle under `VisualControls~<elementHandle>`. It survives drawing save/reload cycles.
5. **Per-Element Storage**: Each element can have its own independent grip point position if per-element overrides are used

**To Reset Grip Position**:
Right-click → **Reset grip points for current element** → The grip point returns to its automatic calculated position

---

### Version Tracking and Force Update

The script tracks its version number (`_ThisInst.version()`) and compares it to the recorded version in the user-selected values map. When the script version changes (e.g., after an update from 0.18 to 0.19), all properties are **force-updated** to incorporate new or modified options while preserving previously selected values where possible.

**Force Update Triggers**:
- Script version mismatch
- First-time insertion (`_bOnInsert`)
- User invokes "Edit dimension properties" menu
- User invokes "Add properties override" menu

**Version History** (from `#BeginDescription`):
- V0.19 (10/17/2023): Corrected genbeamOutline function
- V0.18 (10/16/2023): Added support of dependent TSLs like NA_DIM_GENBEAMS_DIAGONAL
- V0.17 (10/10/2023): Fixed negative zones selection bug
- V0.16 (10/3/2023): Added option to pack dimensioned beams/sheets
- V0.15 (9/26/2023): Corrected closest edge point detection
- V0.14 (9/25/2023): Fixed bug with middle point

---

## Troubleshooting

### Problem: Dimension instance erases itself immediately after insertion

**Cause**: Attempted to insert the script more than once in a single insertion cycle.

**Solution**: The script only allows one insertion per command. If you need to insert multiple dimension instances, complete the first insertion (configure dialog, click OK), then run `TSLINSERT` again for the second instance.

---

### Problem: "No valid element in viewport" error

**Cause**: The selected viewport does not contain a valid hsbCAD Element entity.

**Solutions**:
1. Verify that the viewport displays an Element (wall, floor, or roof), not just individual beams
2. Check that the Element is not corrupted or deleted
3. Ensure you are in Paper Space (Layout tab), not Model Space
4. If the Element exists but is not recognized, try regenerating the viewport (`REGEN`)

---

### Problem: No dimension lines appear after configuration

**Cause**: No beams match the selected zone and filter criteria.

**Solutions**:
1. Check **Element zone** settings in Categories 2 and 3
   - Verify that beams actually exist in the selected zones (use `HSB_G-ElementStrengthening` or `HSB_D-Element` to inspect zones)
2. Check **Include filter** and **Exclude filter** settings
   - Temporarily set both to "None" to see if filters are excluding all beams
   - Verify that Painter Definitions are correctly configured and match beam properties
3. Check **Element side** setting
   - If set to "Half of element", beams may be on the opposite half
   - Temporarily set to "Entire element" to test

---

### Problem: Dimension line is in the wrong location

**Solution 1** (Static Mode):
- The dimension line is offset from the viewport edge by **Dimension line offset**
- Increase or decrease the offset value in Category 4

**Solution 2** (Dynamic Mode):
- Click and drag the grip point to reposition the dimension line manually
- Or right-click → **Reset grip points for current element** to recalculate the automatic position

---

### Problem: Dimension text is too small or too large

**Solutions**:
1. **Adjust Dimension Style**: Select a different **Dimension style** in Category 4 that has appropriate text height
2. **Override Text Height**: Set **Text height** to a specific value (e.g., 3 mm or 1/8 in) to override the style's default
3. **Modify Dimension Style** (Advanced): Use AutoCAD's `DIMSTYLE` command to edit the dimension style text properties globally

---

### Problem: Dimension text is rotated incorrectly

**Solution**:
- For vertical dimensions with horizontal text, set **Text orientation** = Perpendicular
- For vertical dimensions with vertical text, set **Text orientation** = Parallel
- For horizontal dimensions, reverse the orientation setting

---

### Problem: Hatching is too dense or too sparse

**Solutions**:
1. Increase **Hatch scale** for sparser hatching (larger spacing)
2. Decrease **Hatch scale** for denser hatching (tighter spacing)
3. If using SOLID hatch, adjust **Hatch transparency** to make the fill less opaque

---

### Problem: Hatching color doesn't change

**Cause**: **Hatch colour** is set to -1 (inherit from TSL instance).

**Solution**:
1. Set **Hatch colour** to a specific ACI value (1–255)
2. Or change the TSL instance color (select instance, change color via AutoCAD properties)

---

### Problem: Doubled studs are dimensioned twice (redundant witness lines)

**Solution**:
- Set **Pack dimensioned beams/sheets** = Yes in Category 2
- This merges adjacent/overlapping beams into single dimension points

---

### Problem: Per-element override doesn't apply

**Cause**: You are viewing a different element than the one with the override.

**Solution**:
1. Navigate to the correct layout page showing the specific element
2. Select the dimension instance
3. Check the command line for the message: `"This is an override for element <number>"`
4. If no message appears, the override doesn't exist for this element; create it via right-click → **Add properties override**

---

### Problem: Dimension line disappears after drawing reload

**Cause**: The Element or viewport was deleted or corrupted.

**Solution**:
1. Verify that the viewport and Element still exist
2. If the viewport was deleted, the dimension instance will erase itself on next recalculation
3. Recreate the dimension instance if necessary

---

## Tips and Best Practices

### Tip 1: Start with Cumulative Dimensions for Shop Drawings

For typical stud layout dimensioning, use **Dimension type** = Cummulative. Cumulative (running) dimensions from plate to plate are the standard convention in North American shop drawings. Each dimension value shows the distance from the reference start point (bottom plate) to that stud, making it easy for fabricators to measure and mark.

Use **Delta** dimensions only when you specifically need to show the spacing between each consecutive pair of members (e.g., joist spacing checks).

---

### Tip 2: Use Painter Definition Filters to Separate Member Types

Create Painter Definitions to filter different member types, then use **Include filter** and **Exclude filter** to focus dimension chains on specific members.

**Example Painter Definitions**:
- "Studs Only": Filters beams by size (e.g., 2x6 nominal)
- "Headers Only": Filters beams by position or custom property (e.g., members above openings)
- "Jack Studs": Filters beams by proximity to openings or by custom tagging
- "Exclude Cripples": Filters short vertical members below window sills

**Workflow**:
1. Create Painter Definitions in hsbCAD (Painter Definition Manager)
2. In the dimension script, set **Include filter** = "Studs Only"
3. Optionally set **Exclude filter** = "Jack Studs" to remove jack studs from the result

This two-step filtering approach gives fine-grained control without needing overly specific Painter Definitions.

---

### Tip 3: Combine Include and Exclude Filters for Complex Selections

The **Include filter** is applied first to narrow down to a subset, then the **Exclude filter** removes unwanted items from that subset.

**Example**:
- **Include filter** = "All Vertical Members" (selects studs, jacks, cripples, posts)
- **Exclude filter** = "Cripples and Jacks" (removes short members and opening jacks)
- **Result**: Only common studs and king studs are dimensioned

---

### Tip 4: Use "Half of Element" for Double-Sided Walls

When dimensioning a wall that has members on both faces:
1. Set **Element side** = Half of element (Category 2)
2. Set **Dimension orientation** = Vertical left (for the left face)
3. This dimensions only the beams on the half of the element closest to the dimension line (left side)

To dimension the right face:
1. Insert a second dimension instance
2. Set **Element side** = Half of element
3. Set **Dimension orientation** = Vertical right
4. This dimensions only the beams on the right half of the element

**Result**: Two independent dimension chains, one for each face.

---

### Tip 5: Enable "Pack Dimensioned Beams/Sheets" for Doubled Members

When members overlap or abut each other (doubled studs, built-up headers), enable **Pack dimensioned beams/sheets** = Yes to merge touching beam outlines into groups via Boolean union. This reduces clutter from redundant witness lines.

**Best for**:
- Doubled studs (king + jack side-by-side)
- Built-up headers (multiple plies laminated together)
- Stacked members with no gap

**Note**: Packing involves Boolean operations and can be slower for large element sets. Use selectively when needed.

---

### Tip 6: Use Per-Element Overrides for Multi-Page Layouts

When a single dimension instance covers multiple elements through a multipage setup (e.g., 20 wall panels in a single shop drawing set), but one particular element needs different settings:

1. **Do NOT duplicate the entire script instance**. Instead, use per-element overrides.
2. Navigate to the layout page for the special element
3. Select the dimension instance
4. Right-click → **Add properties override for current element**
5. Modify only the settings that differ (e.g., different zone, different filter)
6. Click OK

**Result**: The special element uses its own settings, while all other elements continue using the shared global settings. This avoids managing multiple separate dimension instances.

---

### Tip 7: Drag the Grip Point in Dynamic Mode for Visual Adjustment

In **Dynamic mode**, a grip point appears at the dimension line. Instead of repeatedly editing the **Dimension line offset** value in the properties dialog, simply:
1. Click and drag the grip point to visually adjust the dimension line position
2. Release when satisfied
3. The new position is saved and persists across drawing sessions

This is much faster than iterative trial-and-error with offset values.

---

### Tip 8: Apply Hatch Patterns to Visually Distinguish Dimensioned Members

Use **Hatch pattern** = SOLID with **Hatch transparency** = 60 to apply semi-transparent highlighting to dimensioned beams. This helps drawing reviewers quickly identify which members are being measured by each dimension chain.

**Alternative**: Use a standard hatch pattern like "ANSI31" with **Hatch scale** = 1.0 and **Hatch angle** = 45° for diagonal line hatching.

**Color Coding**: Set **Hatch colour** to specific ACI values to color-code different dimension chains:
- Hatch colour = 3 (green) for studs
- Hatch colour = 1 (red) for headers
- Hatch colour = 4 (cyan) for plates

---

### Tip 9: Use Zone 0 for Reference Beams (Plates)

For typical wall panel dimensioning:
- **Dimensioned beams zone** = Zone 1 (studs)
- **Reference beams zone** = Zone 0 (plates)

This ensures that the dimension chain spans from bottom plate to top plate, with witness lines at each stud.

**Zone 0 members** (plates, rim joists, perimeter beams) serve as the boundary reference points, while **Zone 1 members** (studs, joists) are the measured items.

---

### Tip 10: Dimension Text Orientation Best Practices

**For vertical dimensions** (left or right side of viewport):
- Set **Text orientation** = **Perpendicular** so text reads horizontally (standard North American practice)

**For horizontal dimensions** (top or bottom of viewport):
- Set **Text orientation** = **Perpendicular** if you want text to read vertically
- Or set **Text orientation** = **Parallel** if you want text to read horizontally along the dimension line

**North American convention**: Vertical dimensions have horizontal text, horizontal dimensions have horizontal text (use Perpendicular for vertical dims, Parallel for horizontal dims).

---

### Tip 11: Metric vs. Imperial Defaults

The script auto-detects the drawing unit system by checking `U(1, "mm") == 1`:
- **Metric drawings** (mm): Default dimension line offset = 4 mm
- **Imperial drawings** (inches): Default dimension line offset = 5/32 inch

You can override these defaults by manually setting **Dimension line offset** to any value in Paper Space units.

---

### Tip 12: Use "Reference to Self" for Special Cases

The **Dimensioned entities** option "Reference to self" uses the dimensioned beams as their own reference points. This is an advanced mode for special dimensioning scenarios where you don't have separate reference beams (plates), and you want the dimension chain to reference the first and last dimensioned member as boundary points.

**Use Case**: Floor joist layout where the first and last joists serve as the reference endpoints, and all intermediate joists are dimensioned relative to those endpoints.

---

### Tip 13: Check Beam Outlines with Visual Debugging

If dimensions are not appearing correctly, use the script's internal outline extraction functions combined with `.vis()` debugging to visualize beam outlines:

**Advanced Debugging** (requires script modification):
1. Uncomment or add `thisOutline.vis(3);` after the `getGenbeamOutline()` function call
2. Reload the script
3. Beam outlines will display in color 3 (green) in Model Space, allowing you to verify that outlines are extracted correctly

This is an advanced technique for troubleshooting outline extraction issues with complex beam geometries.

---

### Tip 14: Understand the Processing Order

When multiple filters and settings are applied, the script processes in this order:

1. **Zone Filter**: Select beams from the specified zone (Zone 0, Zone 1, etc.)
2. **Include Filter**: If set, keep only beams matching the Painter Definition
3. **Exclude Filter**: If set, remove beams matching the Painter Definition
4. **Element Side Filter**: If "Half of element", remove beams on the far half
5. **Beam Side Filter**: Extract outline points based on "Beam/Sheet side" setting
6. **Points to Dimension**: Extract specific points (start, middle, end, all) from outlines
7. **Pack Beams** (if enabled): Merge overlapping outlines before extracting points

Understanding this order helps diagnose why certain beams are included or excluded.

---

## Related Scripts

### Dimension and Layout Tools

| Script Name | Purpose | Relationship |
|-------------|---------|--------------|
| **NA_DIM_GENBEAMS_DIAGONAL** | Diagonal dimension lines across viewport | Child/dependent script; receives viewport data from this parent script |
| **NA_DIM_GENBEAMS_REFERENCED_TO_GENBEAM_STACK** | Dimension beams referenced to a stack of beams | Alternative dimensioning strategy for complex assemblies |
| **NA_DIM_GENBEAM_EDGES_TO_REFERENCE** | Dimension individual beam edges to a reference line | Complementary edge dimensioning |
| **NA_WALL_SHOP_DRAWING** | Generate complete wall panel shop drawings | Often used together; this dimension script is inserted into layouts created by the wall shop drawing script |
| **hsbLayoutDim** | General layout dimensioning tool | Alternative dimension system for hsbCAD layouts |
| **hsbViewDimension** | Model Space view-based dimensioning | Model Space equivalent; this script is the Paper Space version |

### Element and Zone Inspection Tools

| Script Name | Purpose | Use for Troubleshooting |
|-------------|---------|-------------------------|
| **HSB_D-Element** | Display element structure and zones | Inspect which beams are in which zones before dimensioning |
| **HSB_G-ElementStrengthening** | View and modify element zone assignments | Verify zone assignments if dimensions don't appear |
| **HSB_I-ShowElementInfo** | Show detailed element information | Check element validity and beam counts |

### Painter Definition Management

| Script Name | Purpose | Use for Filtering |
|-------------|---------|-------------------|
| **Painter Definition Manager** (hsbCAD UI) | Create and edit Painter Definitions | Define custom filters for Include/Exclude filtering |

---

## Technical Implementation Notes

### Property Storage System (Map-Based)

Unlike typical TSL scripts that use `PropDouble`, `PropInt`, and `PropString` declarations at file scope, this script uses a **Map-based property system** stored in `_Map.getMap(dimensionTypeName)`. This allows:
- **Per-element overrides**: Separate property maps keyed by element handle (e.g., `UserSelectedValues~<elementHandle>`)
- **Version tracking**: Properties include a "Version" key compared against `_ThisInst.version()`
- **Multi-language support**: Property names and values stored with language tags (e.g., `Name:en-US`, `Name:fr-CA`)
- **Flexible property addition**: New properties can be added in future versions without breaking existing user data

**Storage Structure**:
```
_Map
  └─ "Genbeams at viewport side"
       ├─ UserSelectedValues (shared defaults)
       ├─ UserSelectedValues~<elementHandle1> (override for element 1)
       ├─ UserSelectedValues~<elementHandle2> (override for element 2)
       └─ VisualControls~<elementHandle1>
            └─ GripPoint[]
                 └─ "Genbeams at viewport side~Dimension line position" (grip point location)
```

---

### Coordinate System Transformation (Paper Space ↔ Model Space)

All dimension geometry is calculated in **Model Space** coordinates using the viewport's coordinate system transformation (`CoordSys`), then transformed to **Paper Space** for final display.

**Transformation Workflow**:
1. Get viewport transformation: `CoordSys modelToPaperTransformation = thisViewPort.coordSys();`
2. Invert for reverse transformation: `paperToModelTransformation.invert();`
3. Extract viewport scale: `double viewportScale = paperToModelTransformation.scale();`
4. Transform layout axes to model space:
   - `layoutXInModel = _XW.transformBy(paperToModelTransformation).normalize()`
   - `layoutYInModel = _YW.transformBy(paperToModelTransformation).normalize()`
   - `layoutZInModel = _ZW.transformBy(paperToModelTransformation).normalize()`
5. Perform all geometry calculations in Model Space using `layoutXInModel`, `layoutYInModel`, `layoutZInModel`
6. Transform final dimension geometry back to Paper Space using `modelToPaperTransformation`

**Viewport Scale Application**: The viewport scale factor is applied to dimension styling and hatch scaling to ensure consistent appearance regardless of viewport zoom.

---

### Beam Outline Extraction (`getGenbeamOutline`)

The script extracts 2D beam outlines by projecting the beam's 3D solid body onto the viewport plane:

**Primary Method**:
1. Align vector to viewport Z-axis: `getAlignedVector(inGenbeam, -layoutZInModel, isAlignedToLength)`
2. Find extreme vertices in that direction: `inGenbeam.realBody().extremeVertices(thisNormal)`
3. Create contact plane at the farthest vertex: `Plane contactPlane(extremes.last(), thisNormal)`
4. Extract face outline: `inGenbeam.realBody().extractContactFaceInPlane(contactPlane, distToCen)`

**Fallback Method** (if primary fails or produces tiny area):
1. Get analysed tools (cuts): `inGenbeam.analysedTools()` → filter for `AnalysedCut`
2. Determine if using hip cuts or end cuts based on `isAlignedToLength`
3. Find closest analysed cut to the extreme vertex
4. Use the analysed cut's normal to create the contact plane
5. Re-extract outline with the corrected plane

**Outline Cleanup**:
- Remove opening rings: `outOutline.removeAllOpeningRings()`
- This ensures only the outer boundary is used for dimensioning (no interior holes)

---

### Packing Algorithm Detail

When **Pack dimensioned beams/sheets** = Yes:

**Step 1**: Collect all dimensioned beam outlines
```cpp
PlaneProfile outlines[] = getGenbeamOutlines(dimensionedBeams);
```

**Step 2**: Boolean union to merge all outlines
```cpp
PlaneProfile joinedOutline(workingPlane);
for (int i=0; i<outlines.length(); i++) {
    if (i == 0) joinedOutline = outlines[i];
    else joinedOutline.unionWith(outlines[i]);
}
```

**Step 3**: Smoothing cycle (closes small gaps)
```cpp
double smoothingDistance = mmToDrawingUnits(1);  // 1 mm
joinedOutline.shrink(-1 * smoothingDistance);    // Expand by 1 mm
joinedOutline.shrink(smoothingDistance);         // Shrink back by 1 mm
joinedOutline.simplify();                        // Simplify geometry
```

**Step 4**: Split into lumps (separate disconnected regions)
```cpp
PLine profileRings[] = joinedOutline.allRings(true, false);
for (int i=0; i<profileRings.length(); i++) {
    PlaneProfile lump(profileRings[i]);
    lumps.append(lump);
}
```

**Step 5**: Extract dimension points from each lump independently

**Result**: Closely spaced or touching beams are merged into single units, reducing the number of dimension witness lines.

---

### Grip Point Persistence

Grip points are stored in the Map data structure using this hierarchy:
```
VisualControls~<elementHandle>
  └─ GripPoint[]
       └─ "Genbeams at viewport side~Dimension line position" → Point3d
```

**Storage Format**: `Point3d` in **Model Space** coordinates (transformed from Paper Space grip location)

**Retrieval**:
1. Get grip points map: `Map mapGrips = mapDimensionProperties.getMap("VisualControls~"+thisElement.handle()).getMap("GripPoint[]");`
2. Transform to Paper Space: `gripPoint.transformBy(modelToPaperTransformation)`
3. Create `Grip` object: `Grip thisGrip(gripPoint);`
4. Append to `_Grip` array for display

**Update on Grip Drag**:
1. User drags grip in Paper Space
2. New location stored in `_Grip` array
3. On recalculation, transform to Model Space: `gripPoint.transformBy(paperToModelTransformation)`
4. Store in Map: `mapGripPoints.appendPoint3d("Genbeams at viewport side~Dimension line position", gripPoint)`

**Per-Element Storage**: Each element has its own `VisualControls~<handle>` entry, so grip positions are independent across elements.

---

## Summary

**NA_DIM_GENBEAMS_AT_VIEWPORT_SIDE** is a production-grade shop drawing dimensioning tool with professional-level features:
- **Four-category configuration** covering dimension options, beam selection, reference boundaries, and styling
- **Advanced filtering** via Painter Definitions (include/exclude)
- **Zone-based selection** for multi-layer assemblies
- **Beam packing** to reduce dimension clutter
- **Per-element overrides** for multi-page layouts
- **Interactive grip-point repositioning** in Dynamic mode
- **Hatching for visual emphasis** with customizable patterns and transparency
- **Dependent script support** for coordinated dimension chains

Master this script to create clean, professional shop drawings for timber framing fabrication, with precise control over what gets dimensioned and how it appears on the drawing.

---

**Script File**: `TSL/NA_DIM_GENBEAMS_AT_VIEWPORT_SIDE.mcr`
**Version**: 0.19 (October 17, 2023)
**Category**: North America / Shop Drawing / Dimensioning
**Author**: hsbCAD Development Team
