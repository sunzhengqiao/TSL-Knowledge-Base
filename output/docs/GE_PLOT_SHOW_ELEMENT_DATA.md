# GE_PLOT_SHOW_ELEMENT_DATA.mcr

## Overview
This script annotates Paper Space layouts with specific dimensional or attribute data extracted from a selected model viewport. It is used to display element properties—such as Wall Code, Length, Height, or Stud Spacing—as text labels on your production drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script extracts data from model elements but operates in the Layout. |
| Paper Space | Yes | This script must be inserted in a Layout tab containing an active viewport. |
| Shop Drawing | No | This is a general annotation tool for Layouts. |

## Prerequisites
- **Required Entities**: A Viewport in Paper Space that is linked to a valid hsbCAD Element (e.g., a Wall or Floor).
- **Minimum Beam Count**: None (Data is pulled from the Element properties).
- **Required Settings**: Dimension Styles (e.g., `hsb-Bom`) must exist in the drawing to format numeric values correctly.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Select `GE_PLOT_SHOW_ELEMENT_DATA.mcr` from the file browser.

### Step 2: Configure Properties (Dialog)
Upon insertion, a configuration dialog may appear (or check the Properties Palette):
- **Type of data**: Select what you want to show (e.g., Wall Code, Height, Length).
- **DimStyle**: Select the dimension style to control units (mm/inches) and decimal precision.
- **Show data name**: Choose "Yes" to include a label (e.g., "Height: 2750") or "No" for just the value.

### Step 3: Select Location
```
Command Line: Select location
Action: Click the point in Paper Space where you want the text label to be placed.
```

### Step 4: Select Viewport
```
Command Line: Select the viewport from which the element is taken
Action: Click inside the viewport frame that displays the model element (Wall/Floor) you wish to annotate.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| pDimStyle | Dropdown | hsb-Bom | Select the dimension style that determines unit formatting (e.g., mm vs. inches) and precision for the numerical values. |
| pType | Dropdown | Type of data | Select the specific property to display. Options include Description, Information, Subtype, Stud Spacing, Length, Width, Height, Frame Thickness, Stud Length, Wall Code, Wall Code and number, and Length of supporting beam. |
| pShowDataName | Dropdown | No | If set to "Yes", the label will include the category name (e.g., "Length: 5000"). If "No", only the value is shown (e.g., "5000"). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the text label if the model geometry has changed or if you have modified the Element properties. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: This script relies on standard AutoCAD/hsbCAD Dimension Styles configured within the current drawing rather than external XML files.

## Tips
- **Viewport Linking**: Ensure the viewport you select is actually linked to an Element. If the viewport is looking at plain geometry or a non-hsbCAD object, the script will not generate text.
- **Stud Spacing**: When using "Stud Spacing", ensure the selected wall has spacing data defined; otherwise, the result may be blank.
- **Formatting**: To switch between Metric and Imperial labels, simply change the `pDimStyle` property to a style defined in your drawing for that unit system.
- **Supporting Beams**: The "Length of supporting beam" option is particularly useful for floor panels to list the lengths of the rim beams or trimmers in a single label.

## FAQ
- **Q: Why did the text not appear after I selected the viewport?**
- **A:** The selected viewport might not contain a valid hsbCAD Element, or the Element might not support the specific data type selected (e.g., asking for "Stud Spacing" on a Floor slab). Try switching the `pType` to a generic property like "Description" to test the connection.

- **Q: Can I move the text after inserting it?**
- **A:** Yes. Select the text in Paper Space and use the standard AutoCAD Move command or drag the grip to reposition it.

- **Q: How do I change the units from mm to inches?**
- **A:** You do not change this in the script directly. Select the inserted script entity, open the Properties Palette, and change the `pDimStyle` dropdown to a dimension style that is set up for Imperial units.