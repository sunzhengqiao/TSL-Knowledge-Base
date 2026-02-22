# hsbCLT-PropellerTool

Creates propeller-shaped surface tools on CLT panels based on polyline definitions, enabling complex curved milling operations for CNC fabrication.

## Overview

The Propeller Tool is a specialized CLT machining script that generates 3D milling paths for curved and twisted surface cuts on Structural Insulated Panels (SIPs) or CLT panels. It creates a "propeller" surface tool based on one or two polylines that define the shape of the cut across the panel thickness.

**Key Capabilities:**
- Creates complex twisted/warped surface cuts using two polylines
- Single polyline mode for simpler operations (auto-projects to opposite face)
- Automatic face detection and tool orientation
- Configurable tool definitions with diameter, length, and CNC mode
- Visual feedback showing walking direction and bevel paths

**Use Cases:**
- Creating curved edge profiles on CLT panels
- Machining twisted or warped surfaces
- Complex architectural details requiring non-planar cuts
- Edge bevels that transition across panel thickness

## Environment

| Property | Value |
|----------|-------|
| Script Type | O (Object-based) |
| Environment | Model Space |
| Version | 1.7 |
| Required Beams | 0 |

## Prerequisites

Before using this script, ensure:

1. **Panel Selection**: One or more SIP/CLT panels must exist in the drawing
2. **Polyline Definition**: One or two open polylines must be drawn to define the tool path:
   - Polylines should be positioned on or near the panel surfaces
   - Closed polylines are not allowed
   - Straight-line polylines work but are intended for curved profiles
3. **Settings File**: Tool definitions should be configured (optional - defaults are available)

## Usage

### Step-by-Step Workflow

1. **Start the Command**: Launch the hsbCLT-PropellerTool script via TSLINSERT
2. **Configure Tool**: In the dialog, select the desired CNC tool and alignment settings
3. **Select Panel(s)**: When prompted "Select panels", click on one or more CLT/SIP panels
4. **Select Polylines**: When prompted "Select polylines", select one or two polylines that define the milling path:
   - **One polyline**: The script projects it to both panel faces
   - **Two polylines**: Define upper and lower edges of the propeller surface
5. **Confirm**: The tool is applied to the panel

### Understanding Polyline Positioning

- **On-Face Polylines**: Polylines drawn exactly on a panel face are used as-is
- **Off-Face Polylines**: Polylines not on a face are projected to the nearest surface
- **Mixed Positioning**: When using two polylines, one defines the "defining" edge and one defines the "bevel" edge

### Visual Indicators

Once placed, the tool displays:
- **Red polyline**: The defining (primary) edge on the panel face
- **Green polyline**: The bevel (secondary) edge
- **Red arrows**: Walking direction along the defining path
- **Blue arrows**: Connection between defining and bevel edges showing the twist

## Parameters

### Tool Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Tool | Dropdown | First available | Selects the CNC tool definition (includes diameter, length, and tool index) |
| Alignment | Dropdown | Automatic | Tool alignment relative to the path: Automatic, Left, Center, or Right |

### Available Alignment Options

| Option | Description |
|--------|-------------|
| Automatic | Script determines optimal side based on minimal material removal |
| Left | Tool cuts on the left side of the polyline direction |
| Center | Tool is centered on the polyline |
| Right | Tool cuts on the right side of the polyline direction |

## Context Menu Commands

Right-click on the placed tool instance to access these options:

### Primary Commands

| Command | Description |
|---------|-------------|
| Flip Face | Reverses the tool orientation (swaps which face is the defining side). Also triggered by double-click. |

### Tool Definition Management

| Command | Description |
|---------|-------------|
| Add Tool Definition | Creates a new CNC tool with custom diameter, length, and tool index |
| Edit Tool Definition | Modifies parameters of an existing tool |
| Remove Tool Definition | Deletes a tool definition (only available when more than one tool exists) |

### Settings Management

| Command | Description |
|---------|-------------|
| Import Settings | Loads tool definitions from the XML settings file |
| Export Settings | Saves current tool definitions to the settings file (prompts for confirmation if file exists) |

## Tool Definition Parameters

When adding or editing tool definitions:

| Parameter | Type | Description |
|-----------|------|-------------|
| Diameter | Length | Mill diameter (affects cutting body size) |
| Length | Length | Mill length (depth capability) |
| ToolIndex | Integer | CNC machine tool index for BTL/BVX export. Default modes: 0=Finger Mill, 1=Universal Mill, 2=Vertical Finger Mill |
| Name | String | Display name for the tool selection list |

## Settings File

Tool definitions are stored in XML format:

**Primary Location**: `[Company Path]\TSL\Settings\hsbCLT-Freeprofile.xml`

**Fallback Location**: `[Install Path]\Content\General\TSL\Settings\hsbCLT-Freeprofile.xml`

The script validates version compatibility between the drawing's cached settings and the XML file, reporting any mismatches.

### Example Tool Definition

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <lst nm="Tool[]">
    <lst nm="Finger Mill">
      <str nm="Name" vl="Finger Mill"/>
      <dbl nm="Diameter" ut="L" vl="20"/>
      <dbl nm="Length" ut="L" vl="100"/>
      <int nm="ToolIndex" vl="0"/>
    </lst>
    <lst nm="Universal Mill">
      <str nm="Name" vl="Universal Mill"/>
      <dbl nm="Diameter" ut="L" vl="16"/>
      <dbl nm="Length" ut="L" vl="80"/>
      <int nm="ToolIndex" vl="1"/>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter"/>
</Hsb_Map>
```

## Tips and Best Practices

### Polyline Creation

- **Curve Quality**: Use smooth polylines with adequate vertex density for curved sections
- **Direction Matters**: The polyline direction affects the walking direction of the tool
- **Avoid Closed Polylines**: The script explicitly rejects closed polylines with a warning message
- **Projection**: You do not need to manually flatten polylines onto the panel face; the script projects them automatically

### Tool Selection

- **Match Tool to Machine**: Ensure the Tool Index matches your CNC machine's tool library
- **Consider Diameter**: Larger diameters create smoother cuts but may not fit tight curves
- **Maximum Deviation**: The internal maximum deviation is set to 10mm for propeller surface calculations

### Orientation Issues

- **Use Flip Face**: If the tool cuts from the wrong side, use the context menu or double-click to flip
- **Check Visual Feedback**: The red/green polyline colors show which side is defining vs bevel
- **Automatic Side Detection**: When alignment is set to "Automatic", the script tests both sides and chooses the one with minimal material removal

### Performance

- **Envelope Body**: The script uses `envelopeBody()` for faster calculations
- **Execution Loops**: Set to 2 for proper recalculation after parameter changes

### Common Issues

| Issue | Solution |
|-------|----------|
| Tool deleted automatically | Ensure polylines intersect the panel boundary |
| Wrong cutting side | Use "Flip Face" from context menu or double-click |
| No tool options available | Import settings or add tool definitions manually |
| Polyline rejected | Ensure polyline is open (not closed) |
| "Invalid reference" message | Ensure a valid SIP/CLT panel is associated with the tool |
| Tool definition not found | The tool name may have been removed; script auto-selects first available |

## FAQ

**Q: Can I use a single polyline instead of two?**
A: Yes. Select one polyline and the script will automatically project it to both panel faces to create the propeller surface.

**Q: Why does my tool cut from the wrong side?**
A: Use "Flip Face" from the context menu or double-click on the tool instance to reverse the orientation.

**Q: How do I ensure the CNC machine uses the correct cutter?**
A: Verify that the Tool Index in the tool definition matches the physical position of the tool in your CNC machine's tool changer magazine.

**Q: The script says "Different Version of settings found" - what does this mean?**
A: The cached settings in the drawing differ from the XML file on disk. This is informational; you can use Import Settings to update.

## Related Scripts

- **hsbCLT-Freeprofile**: Creates free-form profile cuts on CLT panels (shares settings file)
- **hsbCLT-DrillGroup**: Drilling operations for CLT connections
- Other CLT machining scripts in the hsbCLT-* family
