# hsb_SIP-EdgeBom.mcr

## Overview
This script automates the creation of a Bill of Materials (BOM) for SIP (Structural Insulated Panel) edges directly in Paper Space. It generates a detailed table listing edge lengths, bevel angles, and projected pocket dimensions, while simultaneously labeling the corresponding edges on the drawing view.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script operates in Paper Space by referencing a viewport. |
| Paper Space | Yes | The script draws the BOM table and edge labels in the current layout. |
| Shop Drawing | Yes | Designed for creating production lists and cutting schedules. |

## Prerequisites
- **Required Entities**: An Element containing SIP (Structural Insulated Panel) data.
- **Minimum Beam Count**: 0 (This script works on Elements, not individual beams).
- **Required Settings**: None required, but a Dimension Style must exist in the drawing.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SIP-EdgeBom.mcr`

### Step 2: Locate Table
```
Command Line: Pick a point
Action: Click in the Paper Space layout where you want the top-left corner of the BOM table to be placed.
```

### Step 3: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport that displays the SIP Element you wish to annotate.
```

### Step 4: Adjust Configuration (Optional)
1. Select the inserted script instance (the insertion point).
2. Open the **Properties** palette (Ctrl+1).
3. Adjust parameters such as numbering mode, color, or offsets as needed.
4. The drawing and table will update automatically.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dim Style | dropdown | _DimStyles | Select the dimension style to control text font, size, and arrow style for the table and labels. |
| Numbering mode | dropdown | Numbers | Choose between labeling edges with sequential Numbers (1, 2, 3) or Letters (A, B, C). |
| Color | number | 3 | Set the AutoCAD Color Index (1-255) for the generated table lines and edge text. |
| Edge Offset | number | 60 | Distance in mm from the panel edge to the center of the edge label text (moves label towards panel interior). |
| Edge Text Height | number | 0 | Custom height for edge labels in mm. Enter 0 to use the text height defined in the selected Dim Style. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific custom items to the right-click context menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external XML settings files; it uses standard AutoCAD properties.

## Tips
- **Moving the Table**: You can select the script's insertion point (grip) and use the AutoCAD **Move** command to relocate the entire table and associated labels without re-running the script.
- **Text Consistency**: Keep the **Edge Text Height** set to `0` to ensure your labels automatically scale if you change the Dim Style.
- **Projection Data**: The script automatically detects and lists projected pocket lengths if the geometry allows (where adjacent angles are > 91 degrees).

## FAQ
- **Q: Why did the script disappear immediately after I selected the viewport?**
  - A: The script requires a valid SIP Element inside the selected viewport. If the viewport is empty or contains invalid data, the script will erase itself. Ensure you select a viewport showing a valid SIP.
- **Q: Can I change the labels from Numbers to Letters after inserting?**
  - A: Yes. Select the script, open the Properties palette, and change the **Numbering mode** property to "Letters". The table and drawing labels will update instantly.
- **Q: How are lengths calculated?**
  - A: Edge lengths are rounded up to the next millimeter for production accuracy.