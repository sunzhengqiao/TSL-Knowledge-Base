# BlockToBeamConverter.mcr

## Overview
Converts AutoCAD Block References containing 3D Solids into native hsbCAD Beams. It automatically extracts naming and material properties from the source block's layer name using configurable delimiters.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for operation. Users must select Block References from here. |
| Paper Space | No | Script does not function in Layout views. |
| Shop Drawing | No | Script is intended for model generation, not detailing views. |

## Prerequisites
- **Required Entities**: Block References containing 3D Solids.
- **Minimum Beam Count**: 0 (Script creates beams from scratch).
- **Required Settings**: None (Relies on user-configured properties and layer naming structure).

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` (or via the hsbCAD TSL Palette) → Select `BlockToBeamConverter.mcr`

### Step 2: Configure Properties
**Action**: Before insertion, the Properties Palette (OPM) will appear. Configure the following:
1.  Set the **Separator** character (e.g., `-` or `_`) that splits your layer names.
2.  Define **Type** (Real vs Simplified Solid).
3.  Set up **Token Mapping** (which part of the layer name corresponds to Material, Name, etc.).
4.  Decide if you want to **Set source invisible**.

### Step 3: Select Entities
```
Command Line: |Select entities|
Action: Click on the Block References in the model that you wish to convert. Press Enter to confirm selection.
```
*Note: The script filters for Block References. Ensure your blocks contain 3D Solid geometry.*

### Step 4: Processing
**Action**: The script processes each block, extracts the solid geometry, and creates a new hsbCAD Beam in the same location. Depending on your settings, the original block will be hidden. The script instance will then automatically remove itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| |Separator| | Text | `-` | The character used to split the layer name into segments (tokens). E.g., if layer is `Beam-GL24h`, use `-`. |
| |Type| | Dropdown | `|Real Solid|` | Defines the geometry of the new beam. `|Real Solid|` keeps exact complex shapes; `|Simplified Solid|` uses a bounding box (faster). |
| |Set source invisible| | Dropdown | `|Yes|` | If `|Yes|`, the original Block Reference is hidden after successful conversion. |
| |Token 1| | Dropdown | `<|Disabled|>` | Maps the 1st segment of the layer name to a beam property (e.g., Name, Material, Grade). |
| |Token 2| | Dropdown | `<|Disabled|>` | Maps the 2nd segment of the layer name to a beam property. |
| |Token 3| | Dropdown | `<|Disabled|>` | Maps the 3rd segment of the layer name to a beam property. |
| |Token 4| | Dropdown | `<|Disabled|>` | Maps the 4th segment of the layer name to a beam property. |
| |Token 5| | Dropdown | `<|Disabled|>` | Maps the 5th segment of the layer name to a beam property. |
| |Token 6| | Dropdown | `<|Disabled|>` | Maps the 6th segment of the layer name to a beam property. |
| |Token 7| | Dropdown | `<|Disabled|>` | Maps the 7th segment of the layer name to a beam property. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Re-runs the script logic (Note: The script instance typically erases itself after completion, so this option is primarily available during debugging or if the script fails to finish). |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on direct user input via the Properties Palette and does not require external settings files.

## Tips
- **Layer Naming**: Organize your import layers carefully. For example, use `Structural-Floor-C24` if you want to map Token 1 to Name ("Structural"), Token 2 to Name ("Floor"), and Token 3 to Material ("C24").
- **Performance**: If converting a large number of complex architectural blocks (e.g., from Revit), use the `|Simplified Solid|` option initially to speed up processing. You can switch to `|Real Solid|` for specific elements later if detailed geometry is required.
- **Verification**: Set `|Set source invisible|` to `|No|` for your first run. This allows you to visually compare the new hsbCAD beam against the original block to ensure the conversion was accurate.

## FAQ
- **Q: My beams were created, but they have default names and materials. Why?**
  - A: Check your `|Separator|` setting. If the separator character does not match the one used in the actual layer name, the script cannot split the name into tokens to map properties.

- **Q: The new beams are simple boxes, but my original blocks had complex notches.**
  - A: Check the `|Type|` property. It is likely set to `|Simplified Solid|`. Change it to `|Real Solid|` and run the conversion again to preserve the exact geometry.

- **Q: Can I use this on nested blocks (blocks inside blocks)?**
  - A: The script iterates through entities within the selected block reference to find solids. Ensure you select the top-level parent block.