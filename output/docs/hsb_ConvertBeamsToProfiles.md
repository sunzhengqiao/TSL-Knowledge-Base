# hsb_ConvertBeamsToProfiles.mcr

## Overview
This script automates the conversion of standard or parametric beams within a construction element to specific extrusion profiles. It matches beams based on their width and height dimensions and updates them to the corresponding extrusion profile defined in the properties.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model elements. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not applicable for 2D detailing views. |

## Prerequisites
- **Required Entities**: An `Element` containing `GenBeams`.
- **Required Settings**: The script `HSB_G-FilterGenBeams` must be loaded in the drawing to use the filter functionality.
- **Catalogs**: Valid Extrusion Profiles must exist in the catalog.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse and select `hsb_ConvertBeamsToProfiles.mcr`.

### Step 2: Configure Properties
1. Upon insertion, the **Properties Palette** will open automatically (unless a specific Execute Key/Catalog preset is used).
2. Set the **Filter definition** (optional) to target specific beams (e.g., only rafters).
3. Select **Extrusion profiles** (1-16) that correspond to the beam sizes you wish to convert.
   - *Note*: The script will calculate the width/height of these profiles and look for beams with matching dimensions.

### Step 3: Select Element
```
Command Line: Select element(s)
Action: Click on the construction element(s) in the model containing the beams you want to convert.
```
4. Press **Enter** to confirm selection.

### Step 4: Execution
1. The script attaches to the element, filters the beams, and applies the profile changes.
2. The script instance will automatically delete itself from the drawing once the conversion is complete.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter definition for beam to convert | Dropdown | | Select a filter from the 'HSB_G-FilterGenBeams' catalog to limit which beams are processed (e.g., "Rafters"). |
| Extrusion profile 1 | Dropdown | | Select the extrusion profile to apply to beams matching the dimensions of this profile. |
| Extrusion profile 2 | Dropdown | | Select an additional extrusion profile for different beam sizes. |
| Extrusion profile 3 | Dropdown | | Select an additional extrusion profile for different beam sizes. |
| Extrusion profile 4 | Dropdown | | Select an additional extrusion profile for different beam sizes. |
| Extrusion profile 5 | Dropdown | | Select an additional extrusion profile for different beam sizes. |
| Extrusion profile 6 | Dropdown | | Select an additional extrusion profile for different beam sizes. |
| Extrusion profile 7 | Dropdown | | Select an additional extrusion profile for different beam sizes. |
| Extrusion profile 8 | Dropdown | | Select an additional extrusion profile for different beam sizes. |
| Extrusion profile 9 | Dropdown | | Select an additional extrusion profile for different beam sizes. |
| Extrusion profile 10 | Dropdown | | Select an additional extrusion profile for different beam sizes. |
| Extrusion profile 11 | Dropdown | | Select an additional extrusion profile for different beam sizes. |
| Extrusion profile 12 | Dropdown | | Select an additional extrusion profile for different beam sizes. |
| Extrusion profile 13 | Dropdown | | Select an additional extrusion profile for different beam sizes. |
| Extrusion profile 14 | Dropdown | | Select an additional extrusion profile for different beam sizes. |
| Extrusion profile 15 | Dropdown | | Select an additional extrusion profile for different beam sizes. |
| Extrusion profile 16 | Dropdown | | Select an additional extrusion profile for different beam sizes. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| ManualInsert | Inserts the script into the drawing to select elements and convert beams based on the current property settings. |

## Settings Files
- **Dependency**: `HSB_G-FilterGenBeams.tsl`
- **Purpose**: This script is required to filter the beams within the selected element. Ensure it is loaded in the drawing before running the converter.

## Tips
- **Dimension Matching**: The script converts beams only if their current Width and Height exactly match (within 0.1mm) the bounding box of the selected Extrusion Profile.
- **Standard Profiles**: This script ignores standard rectangular or round profiles in the dropdown list. It is designed to convert beams to *custom* extrusion profiles.
- **Auto-Cleanup**: The script instance erases itself after running, so it will not remain in your project history or clutter the drawing.
- **Use Catalog Presets**: If you frequently convert the same sets of beams, consider saving your property settings as a Catalog Entry so you don't have to re-select profiles every time.

## FAQ
- **Q: Why did my beams not change?**
  **A**: Ensure that the width and height of the current beams exactly match the dimensions of the Extrusion Profile you selected. Also, check that the `HSB_G-FilterGenBeams` script is loaded and that your Filter Definition (if used) actually targets the beams you intended.
- **Q: Can I use this to change a beam from one size to another?**
  **A**: No. This script only swaps the cross-section *type* (e.g., from a standard rectangular timber to a complex profile) if the dimensions (Width/Height) remain the same.
- **Q: What happens if I don't select a Filter Definition?**
  **A**: The script will attempt to process all beams within the selected element, checking them against all 16 profile slots.