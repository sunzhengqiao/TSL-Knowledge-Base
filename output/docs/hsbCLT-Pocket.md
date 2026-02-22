# hsbCLT-Pocket

Creates rectangular pocket machining operations on CLT (Cross-Laminated Timber) panels with optional corner radius rounding. This tool is commonly used for housing hardware, creating recesses for connectors, or preparing joint areas on CLT elements.

## Overview

| Property | Value |
|----------|-------|
| **Script Type** | O-Type (Object) |
| **Version** | 2.1 |
| **Major Version** | 2 |
| **Minor Version** | 1 |
| **Category** | CLT Milling |
| **Keywords** | CLT; Pocket; Radius; Milling |
| **Settings File** | `hsbCLT-Freeprofile.xml` |

The hsbCLT-Pocket script generates a rectangular pocket (recess) on CLT panels. The pocket can have rounded corners with a positive radius, or overshoot corners with a negative radius for CNC machining compatibility. The tool automatically selects the appropriate machining method (Mortise, Free Profile, or Housing) based on pocket dimensions and settings.

## Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary workspace for pocket creation on CLT panels |
| Paper Space | No | Not intended for 2D layout views |
| Shop Drawing | Partial | Generates dimension requests for shop drawing display |

**Target Entities:**
- CLT Panels (Sip)
- Child Panels

**Settings Locations:**
- Company: `[Company Path]\TSL\Settings\hsbCLT-Freeprofile.xml`
- Install: `[Install Path]\Content\General\TSL\Settings\hsbCLT-Freeprofile.xml`

## Prerequisites

1. One or more CLT panels must exist in the drawing
2. Tool definitions should be configured in the settings file for negative radius operations
3. The panel(s) must be accessible and not locked
4. Panels must be co-planar if applying pocket across multiple panels

## Usage

### Insertion Workflow

1. **Launch the command** - Run the hsbCLT-Pocket insertion command or use `TSLINSERT` and select the script
2. **Configure properties** - A dialog appears to set pocket dimensions and alignment (or use catalog entry by entering the catalog name as execution key)
3. **Select panel(s)** - Click on one or more CLT panels to receive the pocket. ChildPanels are also accepted
4. **Pick insertion point** - Click to place the pocket center/reference point on the panel
5. **Continue or finish** - Click additional points for more pockets of the same configuration, or press Escape/Enter to finish

### Command Prompts

| Prompt | Description |
|--------|-------------|
| "Select panel(s)" | Select CLT panels or ChildPanels to apply the pocket |
| "Select point" | Specify the insertion point for the pocket |

### Quick Tips

- **Double-click** on an existing pocket to flip it to the opposite panel face
- Use the **rotation grip** (near the base point) to visually rotate the pocket orientation
- The pocket automatically adjusts to the panel thickness if depth is set to 0
- Multiple pockets can be placed in sequence during a single insertion session

## Parameters

### Geometry Category

| Parameter | Label | Type | Description | Default |
|-----------|-------|------|-------------|---------|
| `dLength` | (A) Length | PropDouble | The length dimension of the pocket along the X-axis | 200 mm |
| `dWidth` | (B) Width | PropDouble | The width dimension of the pocket along the Y-axis | 100 mm |
| `dDepth` | (C) Depth | PropDouble | Pocket depth into the panel. Set to 0 for through-pocket (full panel thickness) | 20 mm |
| `dRadius` | (D) Radius | PropDouble | Corner rounding radius. Positive = rounded corners. Negative = overshoot for CNC relief cuts | 0 mm |
| `sToolMode` | Tool Mode | PropString | Controls the machining export method: `<Default>`, `Free Profile`, or `Housing` | `<Default>` |

### Alignment Category

| Parameter | Label | Type | Description | Default |
|-----------|-------|------|-------------|---------|
| `sSide` | (E) Side | PropString | Which panel face to apply the pocket: `Reference Side` or `Opposite Side` | Reference Side |
| `dRotation` | (F) Rotation | PropDouble | Rotation angle in the XY plane of the panel. Can also be modified via the grip next to the base point | 0 degrees |
| `sOrientation` | (G) Orientation | PropString | Alignment of the pocket relative to the insertion point (9-point grid) | center-center |

### Orientation Grid

The orientation uses a 9-point alignment system relative to the insertion point:

```
1-front-left    2-front-center    3-front-right
4-center-left   5-center-center   6-center-right
7-back-left     8-back-center     9-back-right
```

The reference point is calculated from the insertion point based on the selected orientation. For example:
- **5-center-center**: Insertion point is at the center of the pocket
- **1-front-left**: Insertion point is at the front-left corner of the pocket

### Tool Definition Properties (Dialog Mode)

When adding or editing tool definitions via context menu, these properties appear in a dialog:

| Parameter | Category | Description |
|-----------|----------|-------------|
| `dDiameter` | Tool Definition | The diameter of the CNC milling tool |
| `dLength` | Tool Definition | The cutting length of the tool |
| `nToolIndex` | Tool Definition | The CNC machine tool index number (must be unique) |
| `sName` | Tool Definition | Display name for the tool (read-only in Edit mode) |

## Context Menu Commands

Right-click on an existing pocket to access these commands:

| Command | Description | Conditions |
|---------|-------------|------------|
| **Flip Side** | Moves the pocket to the opposite panel face | Always available |
| **Stretch Dimension** | Interactively extend the pocket by picking a new boundary point | Always available |
| **Add Panel** | Applies the pocket to additional selected panels | Always available |
| **Remove Panel** | Removes the pocket from a selected panel | Requires 2+ panels |
| **Extend Radius in Direction** | Extends the corner radius in a specific direction (enter 1-9, excluding 5) | Requires non-zero radius |
| **Remove Extended Radius** | Removes the radius extension | Only when extension is active |
| **Show Size in Shopdrawing** | Toggles dimension text display in shop drawings | Always available |
| **Hide Size in Shopdrawing** | Hides dimension text (alternative state) | When size display is enabled |
| **Add Tool Definition** | Adds a new CNC tool to the settings | Always available |
| **Edit Tool Definition** | Modifies an existing CNC tool definition | Always available |
| **Remove Tool Definition** | Deletes a tool definition from settings | Requires 2+ tools |
| **Import Settings** | Loads tool definitions from the XML settings file | When settings file exists |
| **Export Settings** | Saves current tool definitions to the XML settings file | When settings exist |

## Tool Mode Behavior

The script automatically selects the machining method based on parameters:

| Condition | Method | Notes |
|-----------|--------|-------|
| Width >= 1000 mm | Free Profile | Overcomes BTL format limitations on 4-050 pocket size |
| Positive radius + Free Profile mode | Free Profile | Explicit user selection via Tool Mode property |
| Negative radius with valid tool | Free Profile | Uses configured CNC tool diameter for overshoot |
| Housing mode selected | Housing | Uses Housing tool type with automatic round type detection |
| Default (all other cases) | Mortise | Standard mortise operation with explicit radius |

### Tool Selection Logic

When using negative radius (overshoot), the script:
1. Sorts available tools by diameter (descending)
2. Selects the largest tool diameter that fits within the specified radius (dDiameter <= |dRadius| * 2)
3. If no tool fits, uses the smallest available tool
4. The overshoot geometry is calculated based on the selected tool diameter

## Display and Visualization

### Color Coding

| Element | Color Index | Color Name |
|---------|-------------|------------|
| Reference Side pocket | 6 | Cyan |
| Opposite Side pocket | 3 | Green |
| Positive X-axis | 1 | Red |
| Negative X-axis | 14 | Pink/Light Magenta |
| Positive Y-axis | 3 | Green |
| Negative Y-axis | 96 | Olive |
| Depth indicator line | 150 | Gray |
| Orientation number (size display off) | 252 | Light Gray |
| Center number (size display on) | 2 | Yellow |

### Visual Elements

- **Pocket outline**: Displayed as a plane profile in the side-specific color
- **Axis indicators**: Colored lines showing X/Y orientation from the reference point
- **Orientation numbers**: Displayed at each of the 9 alignment points (1-9)
- **Depth indicator**: Gray line showing pocket depth from reference point
- **Radius text**: Displays the corner radius value at the pocket corner (format: "R[value]")
- **Size text**: When enabled, displays "LxW" on first line and "Depth" on second line

## Grips

| Grip | Behavior |
|------|----------|
| Base Point (_Pt0) | Standard insertion point grip |
| Rotation Grip (_PtG0) | Drag to rotate the pocket in the XY plane. The rotation angle is displayed during drag. |

## Tips and Best Practices

1. **For CNC compatibility:** Use a negative radius to create overshoot corners that allow the milling tool to reach sharp internal corners. The tool diameter from settings determines the overshoot geometry.

2. **Through-pockets:** Set Depth to 0 to automatically match the full panel thickness.

3. **Multiple panels:** Select multiple co-planar panels during insertion to apply the pocket across panel joints. Panels must be parallel and on the same reference plane. The script checks:
   - Panel orientation (vecZ must be parallel)
   - Panel plane alignment (same Z reference)

4. **Tool definitions:** Configure tool definitions in the settings file to ensure proper CNC export with correct tool indices and diameters. The script selects the largest available tool diameter that fits within the specified radius.

5. **Shop drawing dimensions:** Enable "Show Size in Shopdrawing" to display pocket dimensions (LxW and depth) automatically in fabrication drawings. Requires `sd_EntitySymbolDisplay` to be active on the viewport placeholder.

6. **Tool management:** Use the context menu to set up your tools once. They are saved in the drawing as a MapObject and can be reused without re-entering data.

7. **Panel orientation:** The pocket maintains its orientation relative to the first selected panel, even if grain direction changes (HSB-5393 fix). This is achieved by storing the coordinate system vectors in the instance map.

8. **Large pockets:** If the pocket width exceeds 1000mm, the script automatically generates it as a FreeProfile (extrusion body) to ensure BTL/CNC export compatibility.

9. **Catalog entries:** When inserting, you can specify a catalog name as the execution key to automatically apply saved property values.

10. **Performance:** For complex pockets with negative radius, the polyline is converted to line approximation (5mm segments) for improved performance.

## Settings Files

### hsbCLT-Freeprofile.xml

**Filename:** `hsbCLT-Freeprofile.xml`

**Location:**
- Primary: `[Company Path]\TSL\Settings\`
- Fallback: `[Install Path]\Content\General\TSL\Settings\`

**Purpose:** Stores the persistent list of available CNC tools

**Format:** Standard Hsb_Map XML format

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <lst nm="Tool[]">
    <lst nm="ToolName">
      <str nm="Name" vl="ToolName"/>
      <dbl nm="Diameter" ut="L" vl="20"/>
      <dbl nm="Length" ut="L" vl="100"/>
      <int nm="ToolIndex" vl="2"/>
    </lst>
  </lst>
  <lst nm="Display">
    <int nm="Transparency" vl="0"/>
    <int nm="Color" vl="-2"/>
    <lst nm="Extrusion">
      <int nm="Transparency" vl="0"/>
      <int nm="Color" vl="-2"/>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter"/>
</Hsb_Map>
```

### MapObject Storage

If the settings file is missing, the script creates a default MapObject in the drawing with key `"hsbTSL"` and name `"hsbCLT-Freeprofile"` that persists across sessions.

## Related Scripts

| Script | Relationship |
|--------|--------------|
| `hsbCLT-FreeProfile` | Settings file source for tool definitions |
| `sd_EntitySymbolDisplay` | Shop drawing symbol display for size text |
| `sd_TslRequests` | Radial dimension requests for shop drawings |

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Pocket not appearing | Verify the insertion point intersects the selected panel boundaries. The script checks intersection area and removes tools that don't intersect. |
| "Tool will be deleted" message | The pocket geometry does not intersect any panel - reposition the insertion point or check panel boundaries |
| "Invalid reference" message | Ensure at least one valid CLT panel is selected (Sip or ChildPanel) |
| Incorrect tool diameter | Check tool definitions via context menu > Edit Tool Definition |
| "The tool could not be set as index is already used for another tool" | Each tool must have a unique ToolIndex - assign a different index number |
| Pocket becomes complex solid | Width >= 1000mm triggers automatic FreeProfile mode to prevent export errors |
| Cannot change corner radius | The radius is determined by the selected tool diameter when using negative radius. Edit the tool definition or select a different tool |
| Panel not included in multi-panel pocket | Panels must be parallel (same vecZ) and co-planar. Check panel orientation. |
| Orientation changes unexpectedly | HSB-5393 fix ensures pocket keeps alignment independent from grain direction |

## Technical Notes

### Script Lifecycle

1. **Initialization**: Unit conversion set to mm, debug mode detected
2. **Settings Loading**: Attempts to read from MapObject first, then from XML file
3. **Dialog Mode Check**: Handles special dialog modes for tool editing (DialogMode 2, 3, 4)
4. **Property Definition**: OPM properties registered with categories and descriptions
5. **Insertion Phase**: User selection of panels and insertion points
6. **Execution Phase**: Geometry calculation, tool application, and visualization

### Tool Application Methods

The script applies tools using different methods based on the mode:

- **FreeProfile**: Uses `FreeProfile.setDepth()`, `FreeProfile.setCncMode()`, and `Sip.addTool()`
- **Mortise**: Uses `Mortise.setRoundType(_kExplicitRadius)` and `Mortise.addMeToGenBeamsIntersect()`
- **Housing**: Uses `House.setRoundType()` with automatic detection and `House.addMeToGenBeamsIntersect()`

### Dimension Requests

The script publishes dimension requests in `_Map` under `"DimRequest[]"` for shop drawing integration:

1. **Text Request**: Contains location, orientation vectors, device mode, and text content
2. **Radial Request**: Contains center and chord points for radial dimension display

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 2.1 | 05 Dec 2024 | Marsel Nakuci | HSB-23004: Save graphics in file for render in hsbView |
| 2.0 | 25 Oct 2023 | Thorsten Huck | HSB-19449: New option for tool mode property to force housings, new context commands to edit tool settings |
| 1.9 | 11 Sep 2023 | Thorsten Huck | HSB-19449: New property tool mode to force extrusion tool |
| 1.8 | 16 Mar 2021 | Thorsten Huck | HSB-11214: hsbCLT-Pocket will be exported as free profile as soon as the width is greater or equal than 1000mm (BTL limitation workaround) |
| 1.7 | 07 May 2020 | Thorsten Huck | HSB-7491: Bounding contour published for shopdrawings when radius is negative |
| 1.6 | 05 May 2020 | Thorsten Huck | HSB-7487: Bugfix on negative radius, performance improved by segmented defining contour |
| 1.5 | 31 Mar 2020 | Thorsten Huck | HSB-7145: When using a negative radius the tool is now exported as freeprofile (extrusionbody). Tool parameters are taken from hsbCLT-FreeProfile.xml settings |
| 1.4 | 18 Sep 2019 | Thorsten Huck | HSB-5629: A new custom command has been added to toggle between hiding and showing the dimensions in shopdrawing. Requires sd_EntitySymbolDisplay to be active on the viewport placeholder. |
| 1.3 | 18 Sep 2019 | Thorsten Huck | HSB-5628: New dimrequests published to draw pocket radius in blockspace as text or radial dimension |
| 1.2 | 17 Jul 2019 | Thorsten Huck | HSB-5393: Bugfix keep alignment independent from grain direction; HSB-5392: New display of alignment, new commands to add/remove radius extension |
| 1.1 | 01 Mar 2018 | Thorsten Huck | Uservoice link updated |
| 1.0 | 09 Jan 2018 | Thorsten Huck | Initial version |

## Hyperlink

The script includes a help hyperlink: `https://hsbcad.uservoice.com/knowledgebase/articles/1833748-hsbclt-pocket`
