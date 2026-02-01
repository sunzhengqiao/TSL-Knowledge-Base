# Hilti-Verteilung

## Overview
This script automates the placement and distribution of Hilti anchors (fasteners) along the bottom plates of timber frame walls. It automatically detects whether a wall is an exterior or interior wall and applies specific spacing rules and anchor types for each.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates exclusively in Model Space. |
| Paper Space | No | Not supported for layouts or shop drawings. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: Element (Walls).
- **Minimum Beam Count**: 0 (Script operates on Element level).
- **Required Settings**:
    - The TSL script `Hilti-Verankerung` must be installed and available in the project.
    - Valid Catalog entries for `Hilti-Verankerung` must exist (typically starting with 'AW' for exterior walls and 'ZW' for interior walls).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Hilti-Verteilung.mcr`
```
Command Line: (Dialog appears to select script)
Action: Navigate to the script location and select 'Hilti-Verteilung.mcr'.
```

### Step 2: Select Wall Elements
```
Action: Select the Wall Elements (single or multiple) in the drawing where you want to distribute anchors.
```

### Step 3: Configure Properties
```
Action: With the script instance selected, open the Properties Palette (Ctrl+1). Set the desired Catalog Entries and Distribution parameters for both Exterior (Aussenwand) and Interior (Innenwand) categories.
```

### Step 4: Recalculate
```
Action: Right-click on the script instance and select 'Recalculate' (or Double-click the instance).
Action: The script will generate and insert the 'Hilti-Verankerung' instances along the bottom plates based on the settings.
```

## Properties Panel Parameters

### Exterior Walls (Aussenwand)
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Catalog Entry | dropdown | | Select the Hilti anchor hardware catalog entry (usually starting with 'AW'). |
| Mode of Distribution | dropdown | Stud based | Choose how anchors are spaced: <br>• **Stud based**: Aligns with existing studs.<br>• **Even**: Spaces anchors equally along the wall.<br>• **Fixed**: Uses a fixed step distance. |
| Start Offset | number | 150.0 mm | Distance from the start of the wall to the center of the first anchor. |
| Interdistance | number | 625.0 mm | Target spacing between anchors. In 'Stud based' mode, this acts as a maximum limit. |
| End Offset | number | 150.0 mm | Distance from the end of the wall to the center of the last anchor. |

### Interior Walls (Innenwand)
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Catalog Entry | dropdown | | Select the Hilti anchor hardware catalog entry (usually starting with 'ZW'). |
| Mode of Distribution | dropdown | Stud based | Choose how anchors are spaced (Same logic as Exterior Walls). |
| Start Offset | number | 150.0 mm | Distance from the start of the wall to the center of the first anchor. |
| Interdistance | number | 625.0 mm | Target spacing between anchors. |
| End Offset | number | 150.0 mm | Distance from the end of the wall to the center of the last anchor. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Hilti-Verteilung | Inserts the script instance into the drawing. |
| Delete Distribution | Removes all 'Hilti-Verankerung' anchor instances that were created by this script. |
| Recalculate | Re-runs the calculation logic. Use this after changing properties or wall geometry to update the anchor positions. |

## Settings Files
- **Dependency**: `Hilti-Verankerung.mcr`
- **Location**: TSL Script Database
- **Purpose**: This parent script relies on the `Hilti-Verankerung` script to generate the actual 3D geometry of the anchors. Ensure that script and its catalogs are correctly loaded.

## Tips
- **Automatic Detection**: You do not need to manually specify if a wall is Exterior or Interior; the script detects this and applies the correct parameter set (suffix 1 vs suffix 2).
- **Updates Required**: Changing a property in the palette (like Offset or Distance) does not move the anchors immediately. You **must** trigger a Recalculate (Right-click > Recalculate) to see changes.
- **Stud Based Mode**: If you select "Stud based" but no anchors appear, ensure the wall has valid studs defined and that the Interdistance is not too small for the stud spacing.

## FAQ
- **Q: I changed the Interdistance, but the anchors didn't move.**
- **A:** Changes to properties are not applied instantly. Right-click the script instance and select **Recalculate** to update the model.

- **Q: Can I use different anchor types for different walls in one run?**
- **A:** Yes. Configure the "Exterior" (Aussenwand) settings for exterior walls and the "Interior" (Innenwand) settings for interior walls. The script will apply the correct type automatically based on the wall type.

- **Q: What happens if my Start Offset + End Offset is larger than the wall length?**
- **A:** No anchors will be generated for that wall. Reduce the offset values in the Properties Panel and Recalculate.