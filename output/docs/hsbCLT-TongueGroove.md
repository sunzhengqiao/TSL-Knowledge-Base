# hsbCLT-TongueGroove

## Overview

The **hsbCLT-TongueGroove** tool creates tongue-and-groove connections between CLT (Cross-Laminated Timber) panels. This connection type is commonly used to join CLT panels edge-to-edge, providing both structural integrity and alignment between adjacent panels.

The tool automatically handles:
- Creating matching tongue (male) and groove (female) profiles on adjacent panel edges
- Splitting panels along a specified line if needed
- Stretching panel edges to establish proper joint contact
- Generating CNC-compatible milling operations for both connection sides

**Key Features:**
- Single or twin (double) tongue-and-groove configurations
- Adjustable reference alignment (reference side, axis, or opposite side)
- Configurable gaps, chamfers, and depth parameters
- Support for both panel-based and wall-based workflows
- Dynamic recalculation when linked panels are modified

## Environment

| Property | Value |
|----------|-------|
| **Type** | O (Object-based TSL) |
| **Workspace** | Model Space |
| **Required Beams** | 0 (works with CLT Panels/Sips) |
| **Version** | 3.1 |
| **Keywords** | Tongue, Groove, Nut, Feder, CLT, Joinery |

**System Requirements:**
- hsbDesign 26 or higher (for negative reference gap feature)
- Proper milling head definitions in HH2-Tab of hsbSettings

## Prerequisites

Before using this tool:

1. **CLT Panels must exist** - At least one CLT panel (Sip) must be present in the drawing
2. **Coplanar panels** - Panels to be connected must be in the same plane and have compatible thicknesses
3. **Adjacent edges** - Panels must have parallel, non-codirectional edges within connection range
4. **Milling head setup** - Custom milling heads must be properly defined in hsbSettings (HH2-Tab)

## Usage

### Method 1: Insert as Splitting Tool (Single Panel)

Use this method when you want to split an existing panel and create a tongue-groove joint at the split location.

1. Run the hsbCLT-TongueGroove command
2. Select one CLT panel
3. Pick the first split point on the panel
4. Pick the second split point to define the split line
5. For non-horizontal panels (roof panels), choose projection mode:
   - **Bottom face** - Project points to bottom face
   - **Axis** - Project to panel center (default)
   - **Top face** - Project to top face
   - **Not projected** - Use actual picked points
6. The panel will be split and the tongue-groove connection applied

### Method 2: Insert on Existing Edge (Single Panel)

Use this method to add a tongue-groove profile to one edge of a panel without connecting to another panel.

1. Run the hsbCLT-TongueGroove command
2. Select one CLT panel
3. Pick two points on the edge where you want the joint
4. The tool is placed on the designated edge
5. Later, use the **Add Panel(s)** context menu option to link additional panels

### Method 3: Connect Multiple Panels

Use this method to connect two or more existing panels.

1. Run the hsbCLT-TongueGroove command
2. Select all panels to connect (reference panel first)
3. Pick a point near the desired joint edge
4. If multiple connection options exist, pick a direction point or press Enter for all connections
5. The tool creates appropriate tongue-groove joints at detected connection edges

### Method 4: Wall-Based Insertion

Use this method when working with wall elements containing CLT panels.

1. Run the hsbCLT-TongueGroove command
2. Press Enter when prompted for panels (to select a wall instead)
3. Select the wall element
4. Pick a point on the wall outline
5. When wall is constructed, the tool automatically splits and connects panels

## Parameters

### Alignment

| Parameter | Label | Default | Description |
|-----------|-------|---------|-------------|
| `sReference` | (A) Reference | Reference Side | Specifies the reference location for tool placement: Reference Side, Axis, or Opposite Side |
| `dReferenceOffset` | (B) Offset | 10 mm | Distance offset from the reference location. Set to 0 for complete through-cut |

### Twin Connection

| Parameter | Label | Default | Description |
|-----------|-------|---------|-------------|
| `dGapCen` | (C) Gap | 0 mm | Depth of the gap between double tongue-groove connections (only active when Interdistance > 0) |
| `dInterdistance` | (D) Interdistance | 11 mm | Distance between double tongue-groove profiles. Set to 0 for single connection |

### Reference Side

| Parameter | Label | Default | Description |
|-----------|-------|---------|-------------|
| `dGapRef` | (E) Gap | 0 | Gap angle at reference side. Negative values create gaps between panels (requires hsbDesign 26+) |
| `dChamferRef` | (F) Chamfer | 0 mm | Chamfer size at reference side edge |

### Opposite Side

| Parameter | Label | Default | Description |
|-----------|-------|---------|-------------|
| `dGapOpp` | (G) Gap | 1 mm | Gap depth at opposite side |
| `dChamferOpp` | (H) Chamfer | 0 mm | Chamfer size at opposite side edge |

### Geometry

| Parameter | Label | Default | Description |
|-----------|-------|---------|-------------|
| `dWidthTongue` | (I) Width | 19 mm | Width of the tongue/groove profile measured from the reference side. Set to 0 for 50% of panel thickness |
| `dZDepth` | (J) Depth | 15 mm | Depth of the tongue/groove profile (how far it extends into the mating panel) |
| `dGapTongue` | (K) Gap | 0 mm | Gap between tongue and dado for fit tolerance. Must be >= 0 and < Depth |

## Context Menu Options

Right-click on the tool to access these commands:

### Panel Mode

| Command | Description |
|---------|-------------|
| **Flip Direction** | Reverses the tongue/groove assignment between panels (swaps male and female sides) |
| **Add Panel(s)** | Select additional panels to include in the connection |
| **Remove Panel(s)** | Select panels to remove from the connection (resets their edges) |
| **Edit in Place** / **Disable Edit in Place** | Toggle direct editing mode for grip point manipulation |

### Wall Mode

| Command | Description |
|---------|-------------|
| **Flip Side** | Moves the tool to the opposite side of the wall |
| **Flip Direction** | Reverses the connection direction |

**Double-click behavior:** Executes "Flip Direction" in panel mode or "Flip Side" in wall mode.

## Tips and Best Practices

### Panel Selection Order Matters
When connecting multiple panels, select the **reference panel first**. This panel determines the coordinate system and becomes the "male" (tongue) side of the connection.

### Negative Reference Gap
Setting a negative value for the Reference Side Gap (E) creates a physical gap between panels. This is useful for:
- Thermal expansion allowance
- Weather sealing installations
- Panel alignment adjustments

This feature requires hsbDesign version 26 or higher.

### Twin Connections for Thick Panels
For thick CLT panels, use twin (double) tongue-groove connections by setting Interdistance (D) > 0. This provides:
- Improved structural connection
- Better alignment over panel thickness
- More milling surface for glue application

### Edit in Place Mode
Enable "Edit in Place" to manually adjust the connection length using grip points. This is useful when:
- Only a portion of the edge needs the connection
- Working around openings or other features
- Fine-tuning connection extents

### Catalog Presets
The tool supports catalog entries that can be invoked by name. If catalog entries match panel style names, the tool automatically applies matching settings. Create catalogs for commonly used configurations.

### CNC Export
The tool generates proper CNC milling codes:
- Tongue operations use CNC mode -3
- Groove operations use CNC mode -2

Ensure your milling head definitions in hsbSettings match these codes.

### Handling Openings
The tool automatically detects panel openings and adjusts the connection accordingly. Openings that intersect the joint edge are preserved and the connection is modified to work around them.

### Connection Validation
The tool automatically:
- Removes non-coplanar panels from the connection
- Validates common connection ranges
- Erases duplicate instances on the same edge
- Displays warning if two male panels cannot be connected

## FAQ

**Q: Why does the script only draw a line and not cut the panel?**
A: The script requires Sips (Construction entities) to calculate the 3D cut. If you are in the early design phase (only ElementWalls exist), it draws a symbol. Generate the construction (Sips) and the script will automatically update to perform the cut.

**Q: How do I change from a rectangular groove to a dovetail?**
A: Change the `dGapRef` property. A value of 0 is rectangular. Adjusting this value adds the angled slope.

**Q: Can I move the connection after inserting it?**
A: Yes, use the AutoCAD MOVE command on the script instance. The machining on the panels will update to the new location.

**Q: What happens if I select panels that are not coplanar?**
A: The tool automatically filters out non-coplanar panels and displays a message indicating which panels were removed from the selection set.

**Q: Why am I getting "Two male panels cannot be connected" error?**
A: This occurs when both selected panels have edges facing the same direction. Use "Flip Direction" or reselect panels in a different order.
