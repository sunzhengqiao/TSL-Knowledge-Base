# NA_DIM_GENBEAMS_DIAGONAL.mcr

## Overview
This script automatically creates a diagonal dimension line for generic beams (GenBeams) displayed in a Paper Space viewport. It calculates the dimension based on filtered beam properties and allows users to choose between the longest or shortest diagonal of the selected elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script operates within Paper Space layouts. |
| Paper Space | Yes | This is the primary environment; a Viewport must be selected. |
| Shop Drawing | No | This is a general detailing script, not a shop drawing generator. |

## Prerequisites
- **Required Entities**: A Viewport on a Paper Space layout containing a valid Element with GenBeams.
- **Minimum beam count**: 0.
- **Required settings**: The script relies on existing hsbCAD PainterDefinitions and PropertyDefinitions for filtering beams.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `NA_DIM_GENBEAMS_DIAGONAL.mcr`

### Step 2: Select Existing TSL (Optional)
```
Command Line: Optional: Select viewport side TSL to use its starting point and direction for diagonal dimension line
Action: If you have an existing 'NA_DIM_GENBEAMS_AT_VIEWPORT_SIDE' script on your drawing and wish to use its configuration, click it. Otherwise, press Enter or Esc to skip this step.
```

### Step 3: Select Viewport
```
Command Line: Select element viewport
Action: Click on the viewport frame (or inside it) that contains the element you want to dimension.
```

### Step 4: Configuration
After insertion, the script runs using default settings. To configure the dimension, select the script instance and use the Properties Palette or the Right-Click menu to adjust filters, text styles, and diagonal options.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Default language | dropdown | en-US | Sets the language for script messages (en-US or fr-CA). |
| **Genbeam selection** | | | |
| Genbeam filter | dropdown | First in list | Selects the PainterDefinition to filter which beams to include. |
| Genbeam subfilter | dropdown | First in list | Selects a Property Definition to further refine the beam selection. |
| Genbeam property name | dropdown | First in list | The specific property name used for filtering. |
| Genbeam property minimum | number | 0 | Minimum value for the property filter. |
| Genbeam property maximum | number | 99999 | Maximum value for the property filter. |
| Side selection | dropdown | Top | Selects which side of the element to dimension (Top or Bottom). |
| **Dimension styling** | | | |
| Dimension style | dropdown | Standard | The AutoCAD dimension style to apply. |
| Text height | number | 2.5 | Height of the dimension text. |
| Text side | dropdown | Above dimension line | Places text above or below the dimension line. |
| Text orientation | dropdown | Parallel | Aligns text parallel or perpendicular to the dimension line. |
| Project points to dimension line | dropdown | Yes | If Yes, projects points onto the dimension line; if No, uses raw coordinates. |
| Dimension line offset | number | 5 | Distance between the dimension line and the measured geometry. |
| Diagonal to dimension | dropdown | Longest diagonal | Chooses between dimensioning the longest or shortest diagonal of the profile. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Edit dimension properties / Modifier les propriétés de cote | Opens a dialog box to modify global dimension properties, such as filters and text styles. |
| Add properties override for current element / Ajouter un remplacement de propriétés pour l’élément actuel | Saves the current settings specifically for the Element in the selected viewport. This allows different settings for different elements. |
| Remove properties override for current element / Supprimer le remplacement de propriétés pour l’élément actuel | Deletes the element-specific settings and reverts to the global default settings. |
| Reset grip points for current element / Réinitialiser les points de préhension pour l’élément actuel | Clears the internal grip point logic for the current element. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script uses internal hsbCAD definitions (Painter/Property definitions) and does not require an external settings XML file.

## Tips
- **Filtering**: Use the "Genbeam filter" property to target specific types of beams (e.g., only rafters or only joists).
- **Overrides**: If you have multiple elements on one sheet that require different dimension configurations (e.g., different text heights), use the "Add properties override" option on each script instance rather than changing the global properties.
- **Diagonal Choice**: If dimensioning a rectangular wall, "Longest diagonal" gives the overall span, while "Shortest diagonal" might be useful for specific panel checks.

## FAQ
- **Q: Why did my script instance disappear?**
- **A:** The script requires a valid Viewport linked to an Element. If the viewport or element is deleted, or if the script is inserted in a cycle that duplicates it, it will automatically erase itself to prevent errors.
- **Q: Can I use this script in Model Space?**
- **A:** No, this script is designed specifically for creating dimensions in Paper Space viewports.
- **Q: How do I change which beams are dimensioned?**
- **A:** Use the Properties Palette to change the "Genbeam filter" or "Genbeam property name" to match the specific attributes of the beams you wish to measure.