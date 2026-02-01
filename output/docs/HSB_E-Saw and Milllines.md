# HSB_E-Saw and Milllines

## Overview
Automates the generation of CNC saw and milling toolpaths for sheeting zones (flooring, roofing, or cladding) on timber elements, optimizing cuts based on geometry and machine capabilities.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates directly on Elements (Walls, Floors, Roofs). |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Generates production data, not drawing annotations. |

## Prerequisites
- **Required Entities**: An Element (Wall, Floor, or Roof) containing Zones/Sheets.
- **Minimum Beam Count**: 0 (This script processes sheeting geometry on elements).
- **Required Settings**: None required, but Catalog presets can speed up insertion.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-Saw and Milllines.mcr` OR click the Catalog icon if pre-configured.

### Step 2: Configure Settings (Dialog)
If not using a catalog preset, a dialog will appear.
```
Action: Select the target Zone (e.g., Zone 1 for exterior sheathing).
Action: Set Tooling Indexes for Saw and Mill operations.
Action: Configure filters (Material/Label) if only specific sheets need machining.
Action: Click OK to confirm.
```

### Step 3: Select Element
```
Command Line: Select Element:
Action: Click on the Wall, Floor, or Roof element to process.
```

### Step 4: Completion
The script attaches to the element. Visual symbols (text/lines) appear on the info layer to indicate the tooling has been calculated and added to the element.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Apply tooling to element type** | String | Roof | Filters which elements are processed (e.g., Roof, Floor, Wall). |
| **Apply tooling to** | String | Zone 1 | Selects the specific Zone index (1-10) to machine. |
| **Identifier** | String | *Zone Index* | Unique ID to allow multiple instances of this script on the same element (e.g., one for Zone 1, one for Zone 2). |
| **In/Exclude Filters** | Dropdown | Exclude | Sets if the Material/Label filters act as a whitelist (Include) or blacklist (Exclude). |
| **Filter Material** | String | *Empty* | Filters sheets by Material name (e.g., "OSB"). Leave empty to ignore. |
| **Filter Label** | String | *Empty* | Filters sheets by Label name. Leave empty to ignore. |
| **Only saw external corners** | Yes/No | No | If Yes, internal corners are forced to be milled instead of sawed. |
| **Only process openings** | Yes/No | No | If Yes, only cuts out openings (windows/doors) and ignores the outer perimeter. |
| **Merge sheeting tolerance** | Double | 2 mm | Maximum gap between sheets to treat them as one continuous sheet. |
| **Tooling index saw** | Integer | 1 | CNC tool number for the saw operation. |
| **Side saw** | Dropdown | Left | Side of the cut line the saw cuts on (Left/Right). |
| **Turn saw** | Dropdown | Against course | Saw head direction at corners. |
| **Overshoot saw internal corners** | Yes/No | No | Extends the cut past the intersection for internal corners. |
| **Overshoot saw external corners** | Yes/No | Yes | Extends the cut past the intersection for external corners. |
| **Additional depth saw** | Double | 1 mm | Extra cut depth to ensure material is fully severed. |
| **Add zone thickness to additional depth** | String | ----- | Adds the thickness of a specific zone to the saw depth. |
| **Move direction saw** | Dropdown | None | Restricts sawing to specific segment directions (Horizontal/Vertical/Angled). |
| **Tooling index mill** | Integer | 1 | CNC tool number for the milling operation. |
| **Side mill** | Dropdown | Left | Side of the path the mill cuts on. |
| **Overshoot mill internal corners** | Yes/No | No | Extends the mill path past internal corners. |
| **Overshoot mill external corners** | Yes/No | Yes | Extends the mill path past external corners. |
| **Additional depth mill** | Double | 0 mm | Extra depth for milling operations. |
| **Move direction mill** | Dropdown | None | Restricts milling to specific segment directions. |

## Right-Click Menu Options
*Note: Specific custom menu items were not identified in the analysis. Standard script options (Recalculate, Erase) apply.*

## Settings Files
None required. The script relies on Element properties and Zone definitions.

## Tips
- **Multiple Instances**: Use the **Identifier** property to run different machining strategies on the same element. For example, set Identifier to "ExtSaw" for exterior sheathing and "IntMill" for interior sheeting.
- **Optimizing Machine Time**: Increase the **Merge sheeting tolerance** (e.g., to 5 mm) to combine small gaps between sheets. This creates continuous paths and reduces machine start/stop cycles.
- **Corner Quality**: Enable **Only saw external corners** if your machine struggles with tight internal corners using a saw. This forces the script to use the mill for precise internal cuts while keeping the fast saw for external edges.
- **Filtering**: If you only want to cut openings for windows in a wall that is otherwise sheeted on site, set **Only process openings** to "Yes".

## FAQ
- **Q: Why didn't the script generate any toolpaths?**
  - **A:** Check the **Apply tooling to element type** property. If your element is a "Wall" but the script is set to "Roof", it will skip processing. Also, ensure the selected Zone actually contains sheets.
- **Q: Can I mix sawing and milling on the same sheet?**
  - **A:** Yes. Use the **Only saw external corners** option, or set **Move direction** filters differently for Saw vs Mill. For instance, you might allow sawing only on "Horizontal" cuts and force all "Vertical" cuts to be milled.
- **Q: What happens if I change the Zone index in the properties?**
  - **A:** The script automatically recalculates and updates the tooling on the element to match the new Zone geometry.