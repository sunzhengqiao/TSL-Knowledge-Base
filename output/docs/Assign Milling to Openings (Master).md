# Assign Milling to Openings (Master).mcr

## Overview
This script automates the attachment of CNC milling operations to wall or floor elements, specifically targeting areas around window and door openings. It is used to create dados or recesses for drywall returns, plaster stops, or flashing installation on prefabricated timber panels.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates on 3D Element objects (Walls/Floors). |
| Paper Space | No | Not designed for 2D layout views. |
| Shop Drawing | No | Does not generate views or dimensions. |

## Prerequisites
- **Required Entities**: Element (Wall or Floor).
- **Minimum Beams**: 0.
- **Required Settings Files**: `Assign Milling to Openings (Slave).mcr` (Must be in the TSL search path).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Assign Milling to Openings (Master).mcr`

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on the desired Wall or Floor elements in the 3D model. Press Enter to confirm selection.
```

### Step 3: Configure Milling Parameters
After selecting elements, the Properties Palette (or a dynamic dialog) will display.
Action: Adjust the milling settings (Depth, Tooling, Offsets, Side) as required for the production.
*Note: Changes made here will be applied to all selected elements.*

### Step 4: Generate Milling
The script automatically attaches a "Slave" script instance to each selected element with the defined parameters and then erases itself from the drawing.

## Properties Panel Parameters

### Milling Data
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Milling mode | dropdown | Opening | Determines the geometry logic. Choose 'Opening' for raw sub-entities or 'Opening where sheets intersect' for sheathing-based paths. |
| Zone | dropdown | 5 | Assigns the operation to a specific fabrication layer or priority level (-5 to 5). |
| Tooling index | number | 1 | The cutter number from the CNC machine magazine to use. |
| Side | dropdown | Right | The face of the panel to mill (Right or Left relative to the construction line). |
| Turning direction | dropdown | With course | Cutter feed direction: 'With course' (Climb) or 'Against course' (Conventional). |
| Overshoot | dropdown | No | Enables an overcut at corners to ensure a sharp finish. |
| Vacuum | dropdown | Yes | Controls machine vacuum hold-down (No releases suction to prevent loss if cutting through). |

### Dimensions
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Milling Depth | number | 14.29 | The depth of the cut into the timber material (mm). |
| Offset milling around opening | number | 0.0 | Clearance distance added around the entire perimeter of the opening (mm). |
| Offset milling panel top | number | 0.0 | Shifts the top edge of the milling path vertically (mm). |
| Offset milling panel sides | number | 0.0 | Shifts the side edges of the milling path horizontally (mm). |
| Offset from hole edge | number | 0.0 | Specific clearance offset applied around hole sub-elements (mm). |

### Locations
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Milling on top | dropdown | Yes | Enables or disables milling on the top edge of the opening. |
| Milling on top-left | dropdown | Yes | Enables or disables milling on the top-left corner radius. |
| Milling on left | dropdown | Yes | Enables or disables milling on the left edge. |
| Milling on bottom-left | dropdown | Yes | Enables or disables milling on the bottom-left corner radius. |
| Milling on bottom | dropdown | Yes | Enables or disables milling on the bottom edge. |
| Milling on bottom-right | dropdown | Yes | Enables or disables milling on the bottom-right corner radius. |
| Milling on right | dropdown | Yes | Enables or disables milling on the right edge. |
| Milling on top-right | dropdown | Yes | Enables or disables milling on the top-right corner radius. |

## Right-Click Menu Options
*None. The Master script erases itself after execution. Modifications are made via the Properties Palette on the generated Slave instances.*

## Settings Files
- **Filename**: `Assign Milling to Openings (Slave).mcr`
- **Location**: TSL Search Path (Company or Install folder).
- **Purpose**: This script is instantiated on the elements by the Master. It calculates the geometry and visualizes the actual milling.

## Tips
- **Disappearing Script**: Do not be alarmed if the Master script instance vanishes from the drawing immediately after running. This is intended behavior; it passes the data to the Slave scripts attached to the elements.
- **Modifying Specific Elements**: To change the milling depth or offset for a single wall, select the wall, open the Properties Palette, and find the entry labeled **Assign Milling to Openings (Slave)** to edit its properties.
- **Global Updates**: To change settings for multiple elements at once, simply re-run the Master script and re-select the elements. It will detect the old Slave instances, replace them, and apply the new settings.

## FAQ
- **Q: Where did the script go after I ran it?**
  A: The "Master" script is a one-time configuration tool. It creates "Slave" scripts on the elements to handle the actual geometry and deletes itself to keep the drawing clean.
- **Q: How do I create a U-shaped groove instead of a full rectangle?**
  A: In the Properties palette under the **Locations** category, set the specific sides you do *not* want to mill (e.g., the "Milling on bottom") to "No".
- **Q: What is the difference between 'Opening' and 'Opening where sheets intersect'?**
  A: "Opening" uses the exact wall opening geometry. "Opening where sheets intersect" calculates the path based on where the outer sheathing (like OSB) meets the opening, which is useful for specific detailing conditions.