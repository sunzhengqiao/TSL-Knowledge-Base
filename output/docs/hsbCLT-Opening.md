# hsbCLT-Opening.mcr

## Overview
This TSL script transforms raw opening voids in CLT (Cross Laminated Timber) panels into manufacturing-ready machining tools. It supports multiple strategies for detailing window and door openings, including surrounding splines (Midpoint/Corner Tools), standard through cuts (Opening), pockets (Extrusion), and specialized rectangular tooling (Housing/Mortise Tools).

## Script Metadata

| Property | Value |
|----------|-------|
| **Type** | O (Object) |
| **Version** | 2.9 |
| **Last Updated** | 30/04/2025 |
| **Required Beams** | 0 (operates on SIP/CLT panels) |
| **Grip Points** | 0 |
| **Category** | CLT Panel Tooling |

### Version History
| Version | Date | Changes |
|---------|------|---------|
| 2.9 | 30/04/2025 | Fix when radius is applied |
| 2.8 | 11/04/2025 | Fix when closing door openings; improved outer contour detection using envelopeBody with cuts |
| 2.7 | 01/04/2025 | Fix when getting rings of openings |
| 2.6 | 27/02/2024 | New strategies 'House Tool' and 'Mortise Tool' for rectangular openings |
| 2.5 | 01/08/2023 | Bugfix strategy 1 on doors |
| 2.4 | 09/09/2022 | Batch insert support added |
| 2.3 | 08/09/2022 | New commands: Show UI commands, Clone tool, new corner tool behavior |
| 2.2 | 30/06/2022 | New command "Flip Side"; double-click action changed to 'Flip Side' |

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| **Model Space** | Yes | Operates on CLT/SIP panels in 3D model |
| **Paper Space** | No | Not applicable |
| **Shop Drawing** | Indirect | Generates dimension points for shop drawings via sd_Opening ruleset |

## Prerequisites
- **Required Entities**: At least one CLT Panel (`Sip` or `GenBeam`) must exist in the model
- **Settings Files**: Optional XML configuration for display defaults (stored in Company or Install paths)
- **Related Scripts**: `sd_Opening` shopdrawing ruleset for dimension output

## Usage Workflow

### Step 1: Launch Script
```
Command: TSLINSERT
Select: hsbCLT-Opening.mcr
```
Or use catalog entry for silent insert:
```
Command: (hsb_ScriptInsert "hsbCLT-Opening" "CatalogEntryName")
```

### Step 2: Select Panels
```
Command Line: Select panels
Action: Click on one or more CLT/SIP panels to process
```

### Step 3: Select Openings
The script automatically detects:
- **Window openings**: Interior voids completely within panel boundary
- **Door openings**: Edge cutouts extending to the panel perimeter

Interactive prompt options:
| Keyword | Description |
|---------|-------------|
| **Polylines** | Select closed polylines to define custom opening shapes |
| **Openings** | Process only window-type openings (interior voids) |
| **Cutouts** | Process only door-type openings (edge cutouts) |
| **Shapes** | Process all detected shapes |
| **setArea** | Filter by area (e.g., `<=0.7` for openings <= 0.7 m^2) |

### Step 4: Configure Strategy (via Properties Palette or Dialog)
After insertion, configure the tool parameters in the AutoCAD Properties Palette (OPM).

---

## Properties Panel Parameters

### General Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Strategy** | Dropdown | Midpoint Tool | Manufacturing method for the opening. See Strategies section below. |
| **Filter by Area** | String | (empty) | Logical filter for area-based selection. Format: `<=0.7` (m^2 in metric), `>=100` (drawing units in imperial) |
| **Format** | String | (empty) | Display format for annotation text. Example: `@(Area:CU;m:RL3)m^2` shows area in m^2 rounded to 3 decimals |

### Tooling Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Radius** | Length | 0 mm | Corner radius for the opening. **Positive**: rounds corners with fillet. **Negative**: creates cleanup corner shape for sharp internal corners. Hidden for Midpoint Tool strategy. |
| **Offset X** | Length | 200 mm | X-direction offset of the tool from opening corners. Midpoint Tool: offset from corner. Corner Tool: length from corner. Hidden for Opening/Extrusion/Housing/Mortise strategies. |
| **Offset Y** | Length | 0 mm | Y-direction offset of the tool from opening corners. Same meaning as Offset X. Hidden for Opening/Extrusion/Housing/Mortise strategies. |
| **Width** | Length | 8 mm | Width of the cutting tool. Values <= 20mm create a Slot tool. Values > 20mm create a BeamCut tool. Hidden for Opening strategy. |
| **Depth** | Length | 0 mm | Depth of the tool cut. **0**: complete through cut. **Negative**: remaining depth (panel thickness + value). Hidden for Opening strategy. |
| **Face** | Dropdown | Reference Side | Side of the panel from which the tool is applied. Options: Reference Side, Opposite Side. |

### Edge Opening Category (For Door-Type Openings Only)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Length Edge Cut** | Length | 0 mm | Length of the additional slot/beamcut at the panel edge for door openings. Only applicable when Reinforcement Width > 0. |
| **Reinforcement Width** | Length | 200 mm | Width of the supporting frame left around door openings. Creates a rectangular reinforcement spline. Set to 0 to disable. |

---

## Strategies Explained

### 1. Midpoint Tool
Creates surrounding timber splines with tools placed at the **midpoint of each edge** minus the offset values.

**Behavior**:
- Adds Slot or BeamCut tools along each edge of the opening
- Tool length = Edge length - 2 * Offset
- Requires positive Offset X/Y values
- Radius property is hidden

**Best for**: Standard window/door openings where tools should be centered on edges.

### 2. Corner Tool
Creates tools at each **corner** of the opening.

**Behavior**:
- Places Slot or BeamCut tools starting from corners
- Tool length = Offset value
- Supports radius for rounded corners using FreeProfile milling
- Can use negative radius for cleanup corner shapes

**Best for**: Openings requiring corner reinforcement or rounded corners.

### 3. Opening
Creates a standard **through cut** matching the opening shape.

**Behavior**:
- Removes material completely through the panel
- Supports positive radius for rounded corners
- Supports negative radius for cleanup shapes
- All tool offset/width properties are hidden

**Best for**: Simple window openings or ventilation cutouts.

### 4. Extrusion
Creates a **pocket/recess** without cutting through the panel.

**Behavior**:
- Uses FreeProfile milling to create blind pockets
- Depth controls pocket depth (0 = through, negative = remaining thickness)
- Tool diameter selected from hsbCLT-Freeprofile settings based on radius match
- Automatically extends tool path for door openings to ensure clean edges

**Best for**: Hardware recesses, blind holes, or partial-depth cuts.

### 5. Housing Tool
Creates a rectangular **housing pocket** using the House tool.

**Behavior**:
- Creates a rectangular pocket with female-side end type
- No corner rounding
- Depth controls housing depth

**Best for**: Rectangular housing joints for beam connections.

### 6. Mortise Tool
Creates a rectangular **mortise pocket** using the Mortise tool.

**Behavior**:
- Creates a rectangular pocket with female-side end type
- Supports explicit corner radius
- Depth controls mortise depth

**Best for**: Mortise and tenon connections.

---

## Right-Click Context Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Flip Side** | Toggles the Face property between Reference Side and Opposite Side. Also triggered by double-clicking the tool. |
| **Clone Tool** | Creates a duplicate instance with editable properties. Dialog appears to modify parameters. If no changes made, clone is not created. |
| **Reset + Erase** | Removes the tool and restores the original raw opening void. For doors with reinforcement, restores the door-shaped opening. |
| **Edit Shape** | Creates an editable polyline from the tool shape for manual modification. Subsequent edits track the polyline. |
| **Configure Display** | Opens a dialog to configure visual settings (color, linetype, text height, stereotype, dimension toggles) for each strategy type. Settings are saved to XML. |
| **Add/Remove Tool Dimpoints to/from Shopdrawing** | Toggles additional dimensioning points for shop drawings. Requires sd_Opening ruleset. |

---

## Settings Files

### Primary Settings File
- **Filename**: `hsbCLT-Opening.xml`
- **Location**: `<CompanyPath>\TSL\Settings\` or `<InstallPath>\Content\General\TSL\Settings\`
- **Purpose**: Stores display configuration per strategy type

### Secondary Settings File
- **Filename**: `hsbCLT-Freeprofile.xml`
- **Location**: Same as primary
- **Purpose**: Defines CNC tool catalog (diameter, length, tool index, name) for Extrusion and Corner Tool strategies

### Settings Structure
```xml
<Hsb_Map>
  <lst nm="Midpoint Tool_Opening">
    <lst nm="LineWork">
      <dbl nm="LineTypeScale" vl="10"/>
      <str nm="LineType" vl="DASHED"/>
      <int nm="Color" vl="150"/>
      <int nm="Transparency" vl="0"/>
    </lst>
    <lst nm="Display">
      <dbl nm="TextHeight" vl="80"/>
      <str nm="DimStyle" vl="Standard"/>
      <int nm="Color" vl="150"/>
    </lst>
    <lst nm="Dimension">
      <str nm="Stereotype" vl="*"/>
      <int nm="IsActive" vl="1"/>
    </lst>
  </lst>
</Hsb_Map>
```

---

## Tips and Best Practices

### Strategy Selection
- Use **Midpoint Tool** or **Corner Tool** when you need physical surrounding timber pieces (splines) for the opening
- Use **Extrusion** for blind pockets that don't cut through the panel
- Use **Opening** for standard through-cuts without surrounding tools
- Use **Housing/Mortise Tool** for rectangular joinery connections

### Door Handling
- If a door opening doesn't close correctly at the panel edge, ensure the opening is detected as a door (edge cutout)
- Set **Reinforcement Width** > 0 to create a supporting frame around door openings
- Use **Length Edge Cut** to add additional edge slots for door frames

### Radius Behavior
- **Positive radius**: Rounds all corners of the opening
- **Negative radius**: Creates cleanup shapes at sharp internal corners (useful for CNC manufacturing constraints)
- Radius is automatically hidden for Midpoint Tool strategy

### Area Filtering
Use the **Filter by Area** property to batch-process only openings of a certain size:
- `<=0.5` - Only openings <= 0.5 m^2
- `>1.0` - Only openings > 1.0 m^2
- `=0.25` - Only openings exactly 0.25 m^2

### Batch Processing
- Select multiple panels at once during insertion
- All openings on selected panels will be highlighted for individual or batch selection
- Press Enter to process all detected openings

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Opening not detected | Ensure the opening is a true void in the SIP panel, not just a visual representation |
| Door opening leaves material at edge | Set **Reinforcement Width** to 0, or check that the opening properly extends to the panel boundary |
| Radius not applied | Verify strategy supports radius (hidden for Midpoint Tool); ensure X and Y offsets are positive for Corner Tool |
| Dimensions not appearing in shop drawing | Set **Add Dimension** to Yes in Configure Display dialog; ensure sd_Opening is in the ruleset |
| Tool not created after clone | Modify at least one property in the clone dialog - identical clones are automatically purged |

---

## Related Scripts

| Script | Relationship |
|--------|--------------|
| `sd_Opening` | Shop drawing ruleset that reads dimension points from this tool |
| `hsbCLT-Freeprofile` | Provides CNC tool catalog for Extrusion strategy |
| `hsb_ScriptInsert` | System function to insert this script programmatically |

---

## UI Commands for Custom Toolbuttons

The following commands can be used to create custom toolbuttons, palettes, or ribbon buttons:

```
; Insert new instance with dialog
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-Opening")) TSLCONTENT

; Insert with catalog entry (no dialog)
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-Opening" "ABC123")) TSLCONTENT

; Flip face of selected tool
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Side|") (_TM "|Select tool|"))) TSLCONTENT

; Clone selected tool
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Clone Tool|") (_TM "|Select tool|"))) TSLCONTENT

; Reset and erase selected tool
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Reset + Erase|") (_TM "|Select tool|"))) TSLCONTENT

; Edit shape of selected tool
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Edit Shape|") (_TM "|Select tool|"))) TSLCONTENT

; Configure display settings
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Configure Display|") (_TM "|Select tool|"))) TSLCONTENT

; Add tool dimpoints to shopdrawing
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Tool Dimpoints to Shopdrawing|") (_TM "|Select tool|"))) TSLCONTENT

; Remove tool dimpoints from shopdrawing
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Tool Dimpoints from Shopdrawing|") (_TM "|Select tool|"))) TSLCONTENT
```

---

## Technical Notes

### Opening Detection Logic
1. **Window openings**: Detected via `sip.plOpenings()` - interior voids
2. **Door openings**: Detected via blow-up-and-shrink algorithm comparing envelope to bounding box
3. **Rafter cutouts**: Also detected on gable-shaped panels

### Tool Creation
- **Slot**: Created when Width <= 20mm
- **BeamCut**: Created when Width > 20mm
- **FreeProfile**: Used for Extrusion strategy and Corner Tool with radius
- **House/Mortise**: Used for their respective strategies

### Dependency Tracking
- Script sets dependency on host SIP panel via `setDependencyOnDictObject()`
- Tracks shape changes via `vecRef` vector in Map
- Auto-erases if host panel becomes invalid

### Display Layers
- Tool geometry drawn in front with `setDrawOrderToFront(true)`
- Grips disabled at insertion point via `setAllowGripAtPt0(false)`
- Tool assigned to element group with 'T' suffix
