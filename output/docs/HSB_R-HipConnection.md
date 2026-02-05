# HSB_R-HipConnection.mcr

## Overview
This script automates the connection of timber hip beams across multiple roof elements. It extends hip beams from lower elements over upper elements to create a physical overlap and optionally squares off the beam end at the ridge.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in 3D Model Space. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: Roof Elements (`ElementRoof`) containing Beams.
- **Minimum Selection**: At least 1 Roof Element (typically multiple elements are required to see the connection effect).
- **Identification**: Beams must be identifiable by a specific Beam Code (e.g., "HK-01") to be processed as hip beams.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_R-HipConnection.mcr`

### Step 2: Configure Parameters (Optional)
Before selecting elements, you can adjust settings in the **Properties Palette** (usually on the right side of the screen) if a catalog preset is not used automatically.
- Set the **Beamcode hip** to match the naming convention used in your project.
- Adjust **Overshoot length** and **Ridge connection** settings as desired.

### Step 3: Select Roof Elements
```
Command Line: Select a set of elements
Action: Click on the roof elements containing the hip beams you wish to connect. Press Enter to confirm selection.
```
*Note: The script will automatically detect the hip beams based on the code, calculate the overlaps, and apply cuts. The script instance will then delete itself.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Beamcode hip** | Text | HK-01 | The filter code used to identify which beams in the roof elements are hip beams. Only beams with this code will be modified. |
| **Overshoot length** | Number | 200 | The distance (in mm) the hip beam extends past the edge of the lower element into the upper element to create an overlap. |
| **Square off at ridge** | Dropdown | Yes | Determines if the end of the top-most hip beam (near the ridge) is cut perpendicular to its length. |
| **Offset cut at ridge** | Number | 20 | The offset distance (in mm) from the reference point where the square cut is applied at the ridge. Only active if "Square off at ridge" is Yes. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | The script executes immediately upon selection and erases itself. There are no persistent right-click options for the script instance. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on local TSL Properties rather than external XML settings files.

## Tips
- **Beam Alignment**: Ensure the hip beams in different elements are geometrically aligned (same vector direction and vertical position). The script groups beams based on this alignment.
- **Verification**: After running, check that the hip beams physically overlap at the element boundaries.
- **Chain Logic**: The script sorts the beams along their axis. Ensure your elements are ordered or positioned logically so the script can determine which is the "lower" and which is the "upper" element correctly.

## FAQ
- **Q: The script ran, but my beams weren't cut.**
  A: Check the **Beamcode hip** property. It must exactly match the name or code assigned to your hip beams in the project. If the codes do not match, the script ignores the beams.
- **Q: I got an error "Extremes of element not found!"**
  A: The selected roof elements might be empty or lack valid geometry to calculate bounding boxes. Ensure you have selected valid structural elements.
- **Q: Can I undo the changes?**
  A: Yes, use the standard AutoCAD `UNDO` command to revert the cuts if the result is not as expected.