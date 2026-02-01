# HSB_G-Information.mcr

## Overview
This script displays dynamic construction information (such as element number, area, volume, weight, or material data) directly on a Layout (Paper Space) viewport. It allows you to label specific elements with filtered data, formatted with custom prefixes, suffixes, and precision settings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed to place labels in Paper Space. |
| Paper Space | Yes | Script must be inserted on a Layout tab containing an active viewport. |
| Shop Drawing | Yes | Commonly used to tag elements or add material lists to production drawings. |

## Prerequisites
- **Viewport:** A layout viewport must exist that displays a generated hsbCAD element (wall, floor, roof, etc.).
- **Element Data:** The element shown in the viewport must be generated and contain valid data (beams, materials, etc.).
- **Optional Dependency:** To use the "Custom Property" feature, the script `HSB_G-ContentFormat.mcr` must be loaded in the drawing.

## Usage Steps

### Step 1: Launch Script
1.  In AutoCAD, type `TSLINSERT` and press Enter.
2.  Browse to select `HSB_G-Information.mcr` and click Open.

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport border inside the layout that displays the element you wish to label.
```
*Note: If no viewport is selected, the script instance will be automatically erased.*

### Step 3: Placement
```
Command Line: Select a point
Action: Click anywhere in the Paper Space to position the information text.
```

### Step 4: Configure Properties
1.  Select the newly inserted script instance.
2.  Open the **Properties** palette (Ctrl+1).
3.  Modify the **Filter**, **Information to display**, and **Presentation** settings as needed.

## Properties Panel Parameters

### Filter Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter | String | - | Visual separator. |
| Filter type | Dropdown | Include | Determines if the filter criteria Include matching items or Exclude them. |
| Filter beams with beamcode | String | - | Filter by beam code (e.g., "STU;PLA"). Leave empty to ignore. |
| Filter beams and sheets with name | String | - | Filter by entity name. |
| Filter beams and sheets with label | String | - | Filter by label property. |
| Filter beams and sheets with material | String | - | Filter by material name (e.g., "C24"). |
| Filter beams and sheets with hsbID | String | - | Filter by unique hsbCAD ID. |
| Filter zones | String | - | Filter by specific zone name. |

### Information to Display
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Information to display | String | - | Visual separator. |
| Show | Dropdown | Number | Selects the data to calculate and display (e.g., Element area, Volume, Weight, Project number, Quantity, etc.). |
| Prefix | String | - | Text added before the value (e.g., "Area: "). |
| Postfix | String | - | Text added after the value (e.g., " m²"). |
| Custom Property | String | - | Allows pulling custom data using format `@(PropertyName)`. Requires `HSB_G-ContentFormat.mcr`. |
| Token index | Integer | 0 | If the result contains a list of values, use this index to select a specific segment (0 = first). |
| Token | String | ; | The delimiter used to separate values for the Token index (default is semicolon). |
| Zone index | Integer | 0 | Selects the construction zone index to query data from (0 to 10). |
| Name tsl instance | String | - | The specific TSL filename to look for when "Show" is set to "Tsl instance". |
| Precision | Integer | 2 | Number of decimal places for numerical values (Area, Volume, Weight). |

### Presentation
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Presentation | String | - | Visual separator. |
| Dimension style | Dropdown | Current | Selects the AutoCAD Dimension Style to apply to the text. |
| Textheight | Double | 100 | Height of the text in Paper Space units. |
| Rotation | Double | 0 | Rotation angle of the text in degrees. |

## Right-Click Menu Options
This script utilizes the standard TSL context menu. You can access the following options by right-clicking the script instance in the drawing:

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the text if the element geometry or properties have changed. |
| Erase | Removes the script instance and the displayed text. |

## Settings Files
- **Filename**: `HSB_G-ContentFormat.mcr`
- **Location**: hsbCAD TSL Scripts folder (Company or Install path).
- **Purpose**: Required to parse and display "Custom Property" strings defined in the `propCustom` parameter. If this script is missing, a report notice will be displayed.

## Tips
- **Calculating Areas:** To get the surface area of specific parts (e.g., only cladding), use the **Filter beams with beamcode** field to enter relevant codes and set **Filter type** to "Include".
- **Formatting:** Use the **Prefix** and **Postfix** fields to add units automatically. For example, set Prefix to `Wt: ` and Postfix to ` kg` to display "Wt: 450.00 kg".
- **Roofing Data:** If the element is a roof, you can select "Tile lath distribution" or "Nail spacing" in the **Show** dropdown to retrieve specific roofing construction details.
- **Empty Results:** If the text does not appear after insertion, ensure the selected viewport actually contains a generated element and that your filters are not too restrictive (excluding all beams).

## FAQ
- **Q: Why does the text disappear or the script delete itself when I refresh?**
  - A: This usually happens if the Viewport selected during insertion was deleted or if it no longer contains a valid hsbCAD Element. Re-insert the script and select a valid viewport.
- **Q: How can I display the element code with the element number in one line?**
  - A: Currently, the script displays one "Show" type per instance. To show both Number and Code, insert two instances of the script, place them next to each other, and set one to "Number" and the other to "Code".
- **Q: I see an error about "HSB_G-ContentFormat". What do I do?**
  - A: You must load the `HSB_G-ContentFormat.mcr` script into your drawing to use the Custom Property feature. Load it via `TSLLOAD` or ensure it is in your startup folder.