# FreeProfile.mcr

## Overview

Creates custom free-form milling or cutting operations (grooves, slots, contours) on timber beams based on a user-defined path. This tool is ideal for complex geometries where standard rectangular or circular cuts are insufficient, allowing for tool path definition via points, circles, or existing openings.

| Property | Value |
|----------|-------|
| **Script Type** | O (Object) |
| **Version** | 1.8 |
| **Last Updated** | 21.11.2025 |
| **Minimum Beams Required** | 0 (Selected during insertion) |
| **Category** | Manufacturing / CNC Milling |

### Version History
| Version | Date | Changes |
|---------|------|---------|
| 1.8 | 21.11.2025 | Error capture for missing cutting body and PLine definition |
| 1.7 | 21.10.2025 | Common range considers slice in depth or opposite face |
| 1.6 | 06.10.2025 | Fixed radius cleanup for counter-clockwise polylines |
| 1.5 | 10.05.2024 | Fixed side change by trigger |
| 1.4 | 10.05.2024 | Polyline path with width > tool diameter exports as extrusion body |
| 1.3 | 01.06.2023 | Corrected overshoot on polyline path |
| 1.0 | 05.10.2022 | Initial release |

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary workspace - operates on 3D GenBeam entities |
| Paper Space | No | Not applicable for 3D machining operations |
| Shop Drawing | No | This is a 3D model generation script |

## Prerequisites

- **Required Entities:** At least one `GenBeam` (Timber Beam) - selected during insertion
- **Optional Entities:** `PLine` (Polyline), `Circle`, or `EcsMarker` for defining path geometry
- **Settings File:** `FreeProfile.xml` (optional - for tool presets and configurations)

## Insertion Workflow

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line
2. Select `FreeProfile.mcr` from the script list
3. A dialog appears to configure initial settings

### Step 2: Select Geometry
```
Command Prompt: Select genbeams and polylines
Action: Select one or more timber beams. Optionally, also select existing polylines or circles to define the cutting path.
```

### Step 3: Select Reference Face
```
Command Prompt: Select face [Flip side]
Action:
- Move cursor over the beam to highlight available faces
- Click to select the face where machining should start
- Press [Flip side] keyword to toggle between front/back faces
```

The script highlights faces in different colors:
- **Light Blue**: Available faces
- **Dark Yellow**: Currently selected/highlighted face

### Step 4: Define Profile Path

The method depends on the selected **Mode**:

#### Mode: Polyline Path
```
Command Prompt: Pick point [Left/Center/Right/FlipSide]
Action: Click points on the face to draw the cutting path. Press Enter to finish.
Options:
- [Left]: Align tool path to left side of drawn path
- [Center]: Center tool on drawn path
- [Right]: Align tool path to right side of drawn path
- [FlipSide]: Switch to opposite face
```

#### Mode: Extrusion Body
Same as Polyline Path, but the area enclosed by the path is milled completely.

#### Mode: Contour
Automatically extracts the common contour of all referenced beams.

#### Mode: Opening
```
Command Prompt: Pick point in opening [All/FlipSide]
Action: Click inside an existing opening (window/door cut) to trace its contour.
```

## Properties Panel Parameters

### General Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Mode** | Dropdown | Polyline Path | Defines how the tool processes the path. Options: Contour, Extrusion Body, Opening, Polyline Path |
| **Corner Cleanup** | Dropdown | None | Corner processing method. Options: None, Overshoot, Rounded |
| **Face** | Dropdown | Bottom Face | Reference face for machining. Options: Bottom Face, Top Face |
| **Alignment** | Dropdown | Center | Path alignment relative to drawn polyline. Options: Left, Center, Right |

### Tool Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Tool** | Dropdown | (from settings) | CNC tool selection from configured presets |
| **Depth** | Number | 20 mm | Depth of cut. Set to 0 for complete through-cut |
| **Width** | Number | 30 mm | Width of the tool path. Set to 0 to use tool diameter |

### Display Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Format** | String | R@(Radius) | Format string for description labels. Supports variables: Radius, Diameter, Freeprofile Width/Depth/Length/Area |
| **DimStyle** | Dropdown | (current) | Dimension style for text display |
| **Text Height** | Number | 0 | Text height for descriptions. 0 = use DimStyle default |

### Mode Descriptions

| Mode | Behavior |
|------|----------|
| **Polyline Path** | Mills along the specified path only - creates a groove following the drawn line |
| **Extrusion Body** | Mills the entire area inside the closed path - creates a pocket or slot |
| **Contour** | Automatically uses the beam's outer contour as the cutting path |
| **Opening** | Traces an existing opening (from SIP panels or sheets) as the cutting path |

### Corner Cleanup Options

| Option | Behavior |
|--------|----------|
| **None** | No special corner treatment - path ends at defined points |
| **Rounded** | Corners are rounded to tool radius - smooth transitions |
| **Overshoot** | Tool extends past corners to ensure complete material removal |

**Note:** Rounded and Overshoot options only work with **Vertical Milling Head** tools.

## Right-Click Context Menu

| Menu Item | Description |
|-----------|-------------|
| **Flip Side** | Moves the profile from current face to the opposite face of the beam |
| **Add GenBeams** | Add additional beams to be machined by this profile |
| **Remove Genbeams** | Remove beams from the machining list (minimum 1 required) |
| **Select defining polyline** | Choose a new polyline or circle to define the cutting path |
| **Create defining polyline** | Convert dynamic grip-based path into a static polyline entity |
| **Create defining grips** | Convert static polyline back to editable grip points |
| **Configure Tool** | Open dialog to define/edit tool properties (Diameter, Length, Index, Colors) |
| **Reset Configuration** | Reset to default tool configuration |
| **Import Settings** | Load tool parameters from `FreeProfile.xml` |
| **Export Settings** | Save current tool configuration to `FreeProfile.xml` |

## Tool Configuration

### Configure Tool Dialog

Accessed via right-click menu, allows defining custom milling tools:

| Setting | Description |
|---------|-------------|
| **Diameter** | Tool diameter in mm |
| **Length** | Working length/reach of the tool (0 = unlimited) |
| **ToolIndex** | CNC machine tool number (e.g., T4) |
| **Name** | Descriptive name for the tool preset |
| **Vertical Milling Head** | Yes/No - determines if tool is perpendicular or parallel to surface |
| **Accuracy** | Tolerance for arc-to-line conversion (0 = true curves) |
| **Color Reference Side** | Display color for reference face tool path |
| **Color Top Side** | Display color for opposite face tool path |
| **Transparency** | Tool body visualization transparency (0-100) |

### Default Tool Presets

When no custom settings exist, these defaults are available:

| Tool Name | Diameter | Type |
|-----------|----------|------|
| Finger Mill | varies | Vertical |
| Universal Mill | varies | Horizontal |
| Vertical Finger Mill | varies | Vertical |

## Settings Files

- **Filename:** `FreeProfile.xml`
- **Location:**
  - Company: `%HSB_COMPANY_PATH%\TSL\Settings\FreeProfile.xml`
  - Install: `%HSB_INSTALL_PATH%\Content\General\TSL\Settings\FreeProfile.xml`
- **Purpose:** Stores predefined tool configurations, CNC indices, colors, and accuracy settings

### XML Structure Example
```xml
<Hsb_Map>
  <lst nm="Tool[]">
    <lst nm="CustomMill">
      <dbl nm="Diameter" ut="L" vl="22"/>
      <dbl nm="Length" ut="L" vl="100"/>
      <int nm="CncIndex" vl="5"/>
      <int nm="isVertical" vl="1"/>
      <dbl nm="Accuracy" ut="L" vl="0.1"/>
    </lst>
  </lst>
</Hsb_Map>
```

## Tips and Best Practices

### Workflow Tips
1. **Preview Faces:** The face selection step shows a dynamic preview - use it to verify the correct machining surface
2. **Complex Shapes:** Use "Pick Point" mode to draw custom slots or tenons that aren't simple rectangles
3. **Existing Geometry:** Select a pre-drawn polyline or circle during insertion for precise control

### CNC Export Tips
1. **ToolIndex Verification:** Always verify the ToolIndex matches your CNC machine's tool database
2. **Accuracy Settings:** Set Accuracy = 0 for true curves (arcs); use higher values for faceted approximations
3. **Width vs Diameter:** When Width > Diameter, the tool automatically switches to extrusion mode

### Geometry Management
1. **Locking Profiles:** Use "Create defining polyline" to prevent accidental shifts when beam geometry changes
2. **Unlocking Profiles:** Use "Create defining grips" to restore edit handles on locked profiles
3. **Multiple Beams:** Add multiple beams to apply the same profile to all selected members

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| "Tool definition not found" | Tool name doesn't match XML settings | Select a valid tool from dropdown or import settings |
| "Could not find any opening" | Opening mode selected but no openings exist | Switch to a different mode or create openings first |
| "Non-vertical tool does not support rounding/overshooting" | Corner cleanup incompatible with tool type | Set Corner Cleanup to "None" or use vertical tool |
| "Defining PLine not accurately described" | Path has fewer than 3 points | Draw a valid path with at least 3 points |
| "Tooling not possible" | Internal profile area too small | Increase path size or check tool diameter |
| "Insertion in YZ-Plane not supported" | Attempting to insert on beam end face | Select top, bottom, or side face instead |
| "Width of contour milling cannot be smaller than tool diameter" | Invalid width setting | Set Width >= Tool Diameter or Width = 0 |

## Technical Notes

### SubMapX Data
The script stores additional data in `subMapX` for external access:

| Key | Data Type | Description |
|-----|-----------|-------------|
| `Freeprofile` | Map | Contains Width, Depth, Length, Area, Radius |
| `myConfig` | Map | Current tool configuration for persistence |
| `Grip[]` | Map | Grip point positions relative to world origin |
| `plDefine` | PLine | Backup of defining polyline |
| `LastToolMode` | String | Previous mode selection |
| `vecFace` | Vector3d | Face direction vector |

### Format Variables
Available for use in the **Format** property:
- `@(Radius)` - Tool radius
- `@(Diameter)` - Tool diameter
- `@(Freeprofile Width)` - Profile width
- `@(Freeprofile Depth)` - Profile depth
- `@(Freeprofile Length)` - Profile length
- `@(Freeprofile Area)` - Profile area

## Related Scripts

| Script | Relationship |
|--------|--------------|
| `Drill.mcr` | For simple circular holes |
| `Slot.mcr` | For standard rectangular slots |
| `Mortise.mcr` | For traditional mortise joints |
| `Cut.mcr` | For straight cutting operations |

## Commands

```
TSLINSERT          - Insert FreeProfile script
TSLCONTENT         - Direct insert command
TSLCONTENTDRAG     - Insert with drag recalc (Flip Side / Select Tool)
```
