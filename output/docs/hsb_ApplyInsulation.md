# hsb_ApplyInsulation.mcr

## Overview
This script automatically generates and inserts 3D insulation sheets (batts) into selected timber wall elements based on calculated cavity sizes. It allows users to define primary and secondary insulation layers, apply tolerances for friction fitting, and configure visual hatch patterns for drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D Element entities (e.g., Timber Walls). |
| Paper Space | No | Not designed for 2D layout or detailing views. |
| Shop Drawing | No | Not a shop drawing script. |

## Prerequisites
- **Required Entities**: Timber Wall Elements (or other Elements containing beams).
- **Minimum Beam Count**: 1 (The script processes beams within the selected Element).
- **Required Settings**: None (uses standard script properties).

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT` → Select `hsb_ApplyInsulation.mcr`

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on the timber wall elements you wish to insulate. Press Enter to confirm selection.
```
*Note: Once selected, the script attaches itself to these elements and begins calculation. The original insertion instance is removed.*

### Step 3: Configure Properties (Optional)
If not launched from a pre-configured catalog, a properties dialog may appear upon insertion. Alternatively, select the generated script instance (or the parent element) and modify parameters in the **Properties Palette**.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Zone to insulate** | dropdown | 0 | Identifies the specific construction layer or zone in the wall where the insulation should be physically located (0-10). |
| **Attach Insulation to Zone** | dropdown | 10 | Sets the logical Element Group zone to which the generated insulation sheets are assigned for reporting. |
| **Insulation Name (Main)** | text | | Commercial product name for the main insulation used in BOMs/schedules. |
| **Insulation Material (Main)** | text | Insulation | Generic material classification for the main insulation sheets. |
| **Insulation Thickness (Main)** | number | 89 | Thickness of the main insulation batts to be fitted into the wall cavities (mm). |
| **Insulation Width (Main)** | number | 1200 | Standard manufactured width of the main insulation stock (mm). |
| **Insulation Height (Main)** | number | 8000 | Standard manufactured length of the main insulation stock (mm). |
| **Insulation Name (Secondary)** | text | | Product name for thinner insulation used at connections. |
| **Insulation Material (Secondary)** | text | Insulation | Material classification for the secondary insulation. |
| **Insulation Thickness (Secondary)** | number | 60 | Thickness of insulation used specifically for connection areas where full depth is not possible (mm). |
| **Insulation Width (Secondary)** | number | 1200 | Standard width of the secondary insulation stock (mm). |
| **Insulation Height (Secondary)** | number | 8000 | Standard length of the secondary insulation stock (mm). |
| **Tolerance width** | number | 0 | Global reduction in sheet width to ensure a friction fit or account for swelling (mm). |
| **Tolerance height** | number | 0 | Global reduction in sheet height (mm). |
| **Minimal width/height** | number | 20 | Gaps smaller than this value will be left uninsulated (filters out slivers) (mm). |
| **Minimal Thickness** | number | 20 | Minimum valid thickness; sheets thinner than this will not be created (mm). |
| **Max Insulation Height** | number | 0 | Limits the height of generated sheets. Set to 0 to allow full available height. |
| **Fillter by Wall Code** | text | EA;EB; | Filters which wall types to process. Enter wall codes separated by a semicolon (;). |
| **Display Hatch Pattern** | dropdown | Yes | Toggles the visibility of the 2D hatch pattern in drawings. |
| **Hatch Pattern** | dropdown | | The visual style of the insulation pattern (e.g., ANSI31). |
| **Hatch Scale** | number | 7.5 | Controls the density/size of the hatch pattern. |
| **Hatch Color** | number | 51 | The color index of the insulation bodies and hatch. |
| **\|Show Only In Disp Rep Name\|** | text | | Limits hatch visibility to specific display representations. |

## Right-Click Menu Options
This script does not add specific custom items to the right-click context menu. All modifications are handled via the Properties Palette (OPM).

## Settings Files
- **Filename**: None detected.
- **Location**: N/A
- **Purpose**: N/A (Script uses standard properties).

## Tips
- **Filtering Walls**: If insulation is not appearing in specific walls, check the `Fillter by Wall Code` property. Ensure the wall codes in the model (e.g., "EA") match the list in the properties (e.g., "EA;EB;").
- **Updating Geometry**: To change insulation thickness or size, select the script instance in the model, change the values in the Properties Palette, and the sheets will automatically recalculate.
- **Tolerances**: Use the `Tolerance width` and `Tolerance height` settings (e.g., 2-5mm) to ensure insulation batts do not overlap or clash with adjacent timbers due to manufacturing variances.
- **Small Gaps**: If you see small uninsulated gaps that you want filled, lower the `Minimal width/height` value. If you see many tiny slivers cluttering the model, increase this value.

## FAQ
- **Q: Why are some walls not getting insulation?**
  **A:** Check the `Fillter by Wall Code` property. The script only processes walls whose codes match the list provided in this property (e.g., "EA;EB;").

- **Q: The insulation is too tight/clashing with studs. How can I fix this?**
  **A:** Increase the `Tolerance width` or `Tolerance height` values slightly. This will shrink the calculated insulation sheets.

- **Q: How can I see the insulation in a specific view only?**
  **A:** Use the `|Show Only In Disp Rep Name|` property. Enter the name of the Display Representation (e.g., "Presentation") to limit the hatch visibility to that view style.