# hsbCLT-QC

Creates CNC milling operations to cut quality control (QC) test panels from CLT masterpanels, with configurable bridge connections to prevent panel detachment during machining.

## Overview

The hsbCLT-QC script automates the creation of quality control test specimens from Cross-Laminated Timber (CLT) masterpanels. During CLT production, manufacturers must regularly extract small test panels to verify structural integrity, glue bond quality, and material properties. This script generates the necessary CNC milling toolpaths to cut these test pieces while maintaining thin "bridges" that keep them attached to the masterpanel until final manual separation.

**Key capabilities:**
- Automatically positions test panels along masterpanel edges where material is available
- Creates milling operations with configurable tool diameter and depth
- Supports multiple bridge modes to prevent test panel detachment during CNC processing
- Distributes multiple test panels around the masterpanel perimeter
- Integrates with hsbCLT-Masterpanelmanager for oversize and spacing information
- Can extend masterpanel dimensions when insufficient edge material exists

## Script Metadata

| Property | Value |
|----------|-------|
| Type | Object (O-Type) |
| Version | 1.7 |
| Released | October 30, 2024 |
| Author | Thorsten Huck |
| Requires Beams | 0 |
| Model Space | Yes |
| Paper Space | No |

### Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.7 | 30.10.2024 | Island strategy will always mill 4 sides, extension mode enhanced |
| 1.6 | 08.07.2024 | Island strategy revised |
| 1.5 | 03.07.2024 | Bugfix for corner duplex mode |
| 1.4 | 03.07.2024 | New bridging mode and offset property to mill on 4 sides (not applicable for openings) |
| 1.3 | 10.04.2024 | Bugfix for automatic tool index assignment |
| 1.2 | 10.04.2024 | New 'Bridge Mode' property supports duplex bridging |
| 1.1 | 21.03.2024 | Placement considers panels nested within openings |
| 1.0 | 21.03.2024 | Initial version |

## Prerequisites

- **Entity Required**: CLT MasterPanel
- **Related Script**: Works with hsbCLT-Masterpanelmanager (reads spacing and oversize values)
- **Settings File**: Optional XML configuration at `[Company]\TSL\Settings\hsbCLT-QC.xml` for tool diameter/index mappings

## Usage

### Insertion Workflow

1. Run the script command or select from TSL menu
2. A properties dialog appears to configure test panel parameters
3. Select one or more masterpanels when prompted: **"Select masterpanels"**
4. If placing a single test panel on one masterpanel, click to specify the location: **"Select location"**
5. The script automatically snaps to valid edge positions

### Placement Behavior

- Test panels are automatically positioned along masterpanel edges
- Light blue zones highlight valid placement areas during insertion and dragging
- The script avoids child panel areas and openings
- When edge material is insufficient, the script indicates where masterpanel extension is needed (orange highlight)

### Interactive Features

- **Grip Point Drag**: After placement, drag the test panel location along available edges
- **Double-Click**: Triggers masterpanel stretch when extension is required

## Parameters

### Distribution Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Quantity | Integer | 2 | Number of test panels to generate. When set to 1, places a single panel at the specified location. When greater than 1, panels are automatically distributed around the masterpanel corners and edges. |

### Geometry Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Length | Double | 100 mm | Length of the test piece in grain direction. This dimension always follows the wood grain orientation of the masterpanel. |
| Width | Double | 100 mm | Width of the test piece perpendicular to grain direction. This runs across the grain. |
| Offset | Double | 0 mm | Additional offset from masterpanel edge. **Important**: This offset only applies to outer edges and will be ignored within openings or on inner edges of cut-outs. |

### Tooling Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Bridge Thickness | Double | 10 mm | Remaining material thickness connecting test panel to masterpanel. Bridges align with grain direction for easy detachment. Set to 0 for no bridge (not recommended for most applications). |
| Bridge Mode | String | Single Bridge | Controls bridge placement strategy. See Bridge Modes table below for details. |
| Tool Diameter | Double | 40 mm | Milling tool diameter. If set to 0 and settings file exists, automatically assigned based on panel thickness. |
| Tool Index | Integer | 1 | CNC tool index for export. Becomes read-only when tool configuration is defined in settings file. |

### Bridge Modes

| Mode | Description | Best For |
|------|-------------|----------|
| **Single Bridge** | One bridge connection on one side of the test panel. The bridge maintains alignment with grain direction for easy manual detachment. | Small test pieces, standard applications |
| **Duplex Bridge** | Bridge connections on two opposite sides for enhanced stability during machining. Provides better hold while still allowing easy separation. | Medium-sized test panels, panels in high-vibration setups |
| **Island** | Mills all four sides, creating the test panel as an isolated milling island with bridges on opposing edges. Always mills all 4 sides regardless of position. | Large test panels, maximum stability required |
| **No Bridge** | Complete cutout with no remaining connections. **Warning**: Use with caution - loose pieces can damage CNC equipment. | Only when machining setup can safely handle loose pieces |

## Context Menu

Right-click the QC tool instance to access:

| Menu Item | Description |
|-----------|-------------|
| **Stretch Masterpanel** | Extends the masterpanel boundary to accommodate test panel placement when insufficient edge material exists. Also triggered by double-click. |
| **Import Settings** | Loads tool configuration from the XML settings file located in the Company settings folder. |
| **Export Settings** | Saves current tool configuration to XML settings file for reuse across projects. |

## Settings Configuration

The script reads tool mappings from an XML configuration file that associates panel thicknesses with appropriate tool diameters and indices.

**File Locations** (searched in order):
1. `[Company Path]\TSL\Settings\hsbCLT-QC.xml`
2. `[Install Path]\Content\General\TSL\Settings\hsbCLT-QC.xml`

**XML Structure**:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <lst nm="Tool[]">
    <lst nm="Tool">
      <dbl nm="Thickness" ut="L" vl="60"/>
      <dbl nm="Diameter" ut="L" vl="30"/>
      <int nm="ToolIndex" vl="1"/>
    </lst>
    <lst nm="Tool">
      <dbl nm="Thickness" ut="L" vl="100"/>
      <dbl nm="Diameter" ut="L" vl="40"/>
      <int nm="ToolIndex" vl="2"/>
    </lst>
    <lst nm="Tool">
      <dbl nm="Thickness" ut="L" vl="160"/>
      <dbl nm="Diameter" ut="L" vl="50"/>
      <int nm="ToolIndex" vl="3"/>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter"/>
</Hsb_Map>
```

**How It Works**:
- When Tool Diameter is set to 0, the script looks up the appropriate tool based on masterpanel thickness
- The script finds the first thickness value >= actual panel thickness and uses that tool configuration
- Tool Index becomes read-only when automatic assignment is active
- Tools are sorted by thickness (ascending) during processing

## Visual Feedback

The script provides color-coded visual feedback during operation:

| Color | Meaning |
|-------|---------|
| Green | Valid placement, ready for CNC export |
| Yellow/Orange | Milling area visualization (dark yellow with transparency) |
| Orange | Placement requires masterpanel extension - use "Stretch Masterpanel" |
| Red | Invalid placement location |
| Light Blue | Available snap zones during editing and jig insertion |
| Grey (line 7) | Grain direction indicator at masterpanel center |

## Tips

### Workflow Optimization

1. **Multiple Test Panels**: Set Quantity to the desired number before insertion. The script automatically distributes panels:
   - **2 panels**: Placed at opposite corners (diagonal)
   - **3 panels**: Triangular pattern around perimeter
   - **4 panels**: All four corners
   - **5+ panels**: Distributed radially around the masterpanel

2. **Bridge Selection**:
   - Use **Single Bridge** for standard small test pieces
   - Use **Duplex Bridge** for larger panels or when machining vibration is a concern
   - Use **Island** mode for maximum stability with large test panels
   - Avoid **No Bridge** unless your CNC setup has specific containment for loose pieces

3. **Masterpanel Extension**: When the orange "Stretch Masterpanel" indication appears:
   - Double-click the QC instance, OR
   - Right-click and select "Stretch Masterpanel"
   - The masterpanel boundary automatically extends to accommodate the test panel

4. **Tool Configuration**: Set up the XML settings file once with your shop's tool inventory:
   - Create `hsbCLT-QC.xml` in your Company settings folder
   - List all available tool diameters with corresponding panel thickness thresholds
   - Set Tool Diameter to 0 for automatic assignment based on panel thickness

### Placement Guidelines

5. **Opening Avoidance**: Test panels automatically avoid placement within masterpanel openings and respect child panel boundaries. The script calculates available space in real-time.

6. **Grain Alignment**:
   - The Length dimension always follows the grain direction
   - Width runs perpendicular to grain
   - Bridges are positioned along the grain for easier manual separation
   - A grey indicator line shows grain direction at the masterpanel center

7. **Sibling Coordination**: When multiple QC instances exist on the same masterpanel, they automatically coordinate to avoid overlapping placement zones.

8. **Offset Behavior**:
   - Offset applies only to outer edges of the masterpanel
   - Within openings or on inner edges of cut-outs, offset is ignored
   - The Offset property becomes hidden when placing within an opening

## Troubleshooting

| Problem | Possible Cause | Solution |
|---------|---------------|----------|
| Test piece not visible | Invalid geometry or placement | Check Offset value; may be too large for available edge space |
| Tool Index is read-only | Settings file configured | Expected behavior when auto-assignment is active; set Tool Diameter to non-zero value to override |
| Cannot place in desired location | Insufficient edge material | Use "Stretch Masterpanel" to extend the panel boundary |
| Unexpected bridge position | Grain direction affects bridge placement | Bridge always aligns with grain; verify grain direction with the grey indicator line |
| Multiple panels not distributing | Quantity set after insertion | Set Quantity before insertion; for existing instances, delete and re-insert with correct Quantity |

## FAQ

**Q: Why did my test piece disappear after placement?**
A: Check the Offset property. If the offset is too large relative to available edge material, or if placement is near an opening, the geometry might be invalid or moved outside panel bounds. Reduce the offset value or reposition the test piece.

**Q: How do I change which CNC tool is used?**
A: Two options:
1. Manually enter a specific Tool Index in the properties (will override auto-assignment)
2. Ensure `hsbCLT-QC.xml` contains the correct mapping for your panel thickness, then set Tool Diameter to 0 for automatic assignment

**Q: Can I place test panels within openings inside the panel?**
A: Test panels can be placed near openings but will not be placed within openings. The Offset property only applies to outer edges, not inner edges of cut-outs. The script automatically calculates available space avoiding all openings.

**Q: What happens if I set Quantity to 1?**
A: The script generates a single test piece at the insertion point (or where you click during jig placement). For automatic distribution around the panel perimeter, set Quantity > 1.

**Q: Why is my Tool Index read-only?**
A: When a settings file (`hsbCLT-QC.xml`) is configured AND your Tool Diameter matches a configured value (or is set to 0), the script automatically assigns the Tool Index based on the XML configuration. To manually specify, set Tool Diameter to a non-zero value that doesn't match any configured diameter.

**Q: How does Island mode differ from Duplex Bridge?**
A:
- **Duplex Bridge**: Mills three sides with bridges on the fourth side (or bridges on two sides)
- **Island**: Always mills all four sides, creating a true island with bridges on opposing edges. Best for maximum stability with larger test panels.

**Q: What is the "Stretch Masterpanel" feature?**
A: When there isn't enough material at the panel edge to accommodate the test piece (including tool diameter and offset), the script displays an orange zone indicating the required extension. Using "Stretch Masterpanel" (context menu or double-click) automatically extends the masterpanel shape to provide sufficient edge material.

## Related Scripts

| Script | Relationship |
|--------|-------------|
| hsbCLT-Masterpanelmanager | Provides oversize and spacing values for QC placement calculation |
| hsbCLT-Slot | Creates slot milling operations |
| hsbCLT-Pocket | Creates pocket milling operations |
| hsbCLT-Rabbet | Creates rabbet/rebate milling operations |

## Technical Notes

### Milling Path Generation

The script generates `ElemMill` tool operations with the following characteristics:
- **Turn Direction**: Against course (`_kTurnAgainstCourse`)
- **Overshoot**: Enabled (`_kOverShoot`)
- **Side Selection**: Automatically determined based on position and grain direction

### Coordinate System

The script works in the World Coordinate System (WCS) but respects:
- Masterpanel grain direction (detected from child panels)
- UCS orientation during insertion
- Panel orientation in 3D space

### Data Storage

- **Map Keys**: `ppQC` (placement zone), `Shape` (tool shape), `ppStretch` (extension zone)
- **DataLink**: Masterpanel reference stored under "DataLink" submap
- **Sibling Detection**: Identical script instances attached to same masterpanel
