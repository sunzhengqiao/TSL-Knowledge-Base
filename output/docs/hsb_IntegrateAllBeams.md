# hsb_IntegrateAllBeams.mcr

## Overview
This script automates the integration of wall and floor beams by notching plates and cutting intersecting studs or joists. It is designed to create tight-fitting connections, including birdsmouth cuts for angled plates, ensuring proper bearing surfaces in timber frame construction.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates on Elements and GenBeams in the 3D model. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | This script modifies the physical model geometry, not drawing views. |

## Prerequisites
- **Required Entities**: Elements (containing GenBeams) must exist in the model.
- **Minimum Beam Count**: At least 1 element with beams must be selected.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or use the hsbCAD Scripts menu) → Select `hsb_IntegrateAllBeams.mcr`

### Step 2: Select Elements
```
Command Line: Please select Elements
Action: Click on the Wall or Floor Elements you wish to process and press Enter.
```
*Note: You can select multiple elements at once.*

### Step 3: Configure Parameters (Optional)
If the Properties Palette does not open automatically, select the script instance (if available) or check command line options. Adjust parameters such as notch depth or tolerance.

### Step 4: Execute
The script will calculate intersections and apply the cuts. The script instance will automatically erase itself once the cuts are applied to the beams.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Depth inside Plate | Number | 8 | The depth the Studs are cut into the top and bottom plates (mm). |
| Tolerance | Number | 0 | Clearance gap added to the notch width to prevent binding (mm). |
| |Square tool to plate| | Dropdown | No | If "Yes", forces a square (orthogonal) notch for angled plates instead of a birdsmouth. |
| Exclude elements with Information field | Text | | Text string (semicolon separated) matching the 'Information' field of elements to skip. |
| **Wall Beams to Notch** | | | | |
| Jack Over Opening | Dropdown | No | Set to "Yes" to integrate this beam type. |
| Jack Under Opening | Dropdown | No | Set to "Yes" to integrate this beam type. |
| Cripple Stud | Dropdown | No | Set to "Yes" to integrate this beam type. |
| Transom | Dropdown | No | Set to "Yes" to integrate this beam type. |
| King Stud | Dropdown | No | Set to "Yes" to integrate this beam type. |
| Sill | Dropdown | No | Set to "Yes" to integrate this beam type. |
| Angled TopPlate Left | Dropdown | No | Set to "Yes" to integrate this beam type. |
| Angled TopPlate Right | Dropdown | No | Set to "Yes" to integrate this beam type. |
| TopPlate | Dropdown | No | Set to "Yes" to integrate this beam type. |
| Bottom Plate | Dropdown | No | Set to "Yes" to integrate this beam type. |
| Blocking | Dropdown | No | Set to "Yes" to integrate this beam type. |
| Supporting Beam | Dropdown | No | Set to "Yes" to integrate this beam type. |
| Stud | Dropdown | No | Set to "Yes" to integrate this beam type. |
| **Floor Beams to Notch** | | | | |
| Floor Beam Types | Dropdown | No | Set to "Yes" to integrate floor beams (Joists, Rim Beams, Trimmers, etc.). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Re-runs the integration logic with current property values. (Available only if the script instance is still active). |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on internal properties and does not require external settings files.

## Tips
- **Filtering Elements**: If you have complex assemblies where you only want to integrate specific walls, enter the unique text from the 'Information' property of those walls into the "Exclude elements with Information field" parameter.
- **Angled Walls**: For steep roof angles or eaves, the script automatically adjusts the birdsmouth cut. If you prefer a square cut for easier manufacturing, set **|Square tool to plate|** to "Yes".
- **Self-Deleting**: This script acts as a "run-once" tool. Once it applies the cuts to the beams, the script instance disappears from the drawing. If you need to change the parameters significantly, use AutoCAD's **UNDO** command to revert the script execution and run it again with new settings.
- **Header Propagation**: The script is smart enough to apply notches to all stacked header beams if a header is detected at the connection.

## FAQ
- **Q: The script didn't cut a specific stud. Why?**
  **A:** Check the "Wall beams to notch" properties. That specific beam type (e.g., "Cripple Stud" or "King Stud") might be set to "No". Change it to "Yes" and recalculate (or Undo and re-run).

- **Q: How do I undo the cuts if the depth is wrong?**
  **A:** Since the script erases itself, you cannot simply select it and change properties. Use the standard AutoCAD **UNDO** command immediately after running the script to revert the changes, then adjust the "Depth inside Plate" property and insert the script again.

- **Q: What does the Tolerance parameter do?**
  **A:** It adds a small gap to the width of the notch. If your timber tends to swell or you want a looser fit for assembly, increase this value (e.g., 1mm or 2mm).