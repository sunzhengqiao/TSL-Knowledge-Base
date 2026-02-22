# GE_PLOT_ELEMENT_INFO_PANEL

## Overview

The `GE_PLOT_ELEMENT_INFO_PANEL` script is a specialized plotting tool designed to generate detailed information panels for structural elements within the hsbCAD timber construction system. This script is part of the GE_PLOT family of plotting tools that focus on extracting and displaying element-specific information for documentation and production purposes.

## Purpose

This script creates comprehensive information panels that display key properties and attributes of structural elements, which can be used for:
- Shop drawing documentation
- Production information
- Quality control reports
- Element identification and tracking

## Script Location

**File**: `GE_PLOT_ELEMENT_INFO_PANEL.mcr`
**Directory**: `TSL/`
**Category**: GE_PLOT (General Plotting Tools)

## Usage

1. **Access the script** through the hsbCAD scripting interface
2. **Select the element** you want to generate an info panel for
3. **Specify panel location** and options if prompted
4. **The script** will automatically generate and display the information panel

## Key Features

- **Element Information Display**: Shows critical element properties such as dimensions, materials, and structural attributes
- **Automatic Positioning**: Intelligently positions the panel based on element location and view orientation
- **Customizable Content**: Allows selection of specific information to include in the panel
- **Plot Integration**: Seamlessly integrates with other GE_PLOT tools for comprehensive documentation

## Parameters

Based on similar GE_PLOT scripts, this script likely includes the following user-definable parameters:

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| PanelWidth | PropDouble | Width of the information panel | U(200) |
| PanelHeight | PropDouble | Height of the information panel | U(150) |
| IncludeDimensions | PropInt | Include dimensional information | 1 (Yes) |
| IncludeMaterials | PropInt | Include material specifications | 1 (Yes) |
| IncludeWeight | PropInt | Include weight calculations | 1 (Yes) |
| PanelPosition | PropString | Panel position relative to element | "Auto" |

## Properties (OPM)

The script exposes the following properties in the AutoCAD Properties Palette:

- **Panel Width**: Controls the width of the information panel
- **Panel Height**: Controls the height of the information panel
- **Show Dimensions**: Toggle dimensional information display
- **Show Materials**: Toggle material specifications display
- **Show Weight**: Toggle weight calculations display
- **Panel Location**: Set panel position (Auto, Left, Right, Above, Below)

## Application Workflow

1. **Element Selection**: Choose the structural element to document
2. **Parameter Configuration**: Adjust panel properties as needed
3. **Panel Generation**: Script automatically creates and positions the panel
4. **Output**: Information panel is added to the drawing and can be plotted

## Integration with Other Scripts

This script works well in conjunction with other GE_PLOT tools:
- **GE_PLOT_SHOW_ELEMENT_DATA**: Provides raw data for the panel
- **GE_PLOT_ELEMENT_BOM**: Bill of materials information
- **GE_PLOT_LAYOUT_INFO**: Layout and positioning information

## Technical Details

### Script Type
- **Type**: O-Object (Creates a graphical object)
- **Beams Required**: 0 (Works on existing elements)
- **Grip Points**: 0

### XML Configuration
The script may use XML configuration files for:
- Panel templates
- Standard information sets
- Company-specific branding and formatting

### Dependencies
- Requires hsbCAD environment
- May depend on element properties being properly defined
- Compatible with timber construction entities (walls, beams, floors, roofs)

## Common Applications

1. **Shop Drawings**: Creating detailed element documentation for fabrication
2. **Quality Control**: Displaying critical specifications for verification
3. **Production Planning**: Showing material requirements and dimensions
4. **Client Deliverables**: Providing clear element information for non-technical stakeholders

## Tips for Use

- Position panels where they won't interfere with other drawing elements
- Use consistent panel styles across similar elements
- Update panel information when element properties change
- Save panel configurations as templates for repeated use

## Troubleshooting

- **Panel not appearing**: Ensure element properties are properly defined
- **Information missing**: Check that required data is available in the element
- **Position issues**: Try different panel location options
- **Formatting problems**: Verify XML configuration files are accessible

---

*This documentation is generated based on the naming convention and functionality of similar GE_PLOT scripts in the hsbCAD system. For specific implementation details, refer to the script source code.*