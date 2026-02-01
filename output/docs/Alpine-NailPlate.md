# Alpine-NailPlate.mcr

## Overview
Visualizes nail plates in the 3D model based on data imported from external structural engineering software (Model Map). It generates a 3D representation of the plate using size and orientation data provided by the import file.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script creates 3D bodies in the model. |
| Paper Space | No | Not designed for 2D layout or detailing. |
| Shop Drawing | No | Does not generate shop drawings directly. |

## Prerequisites
- **Required Entities**: None (This script is data-driven via Model Map import).
- **Minimum Beam Count**: 0
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Import
This script is typically executed automatically during a data import.
- **Action**: Run the standard **Model Map Import** function in hsbCAD.
- **Input**: Select the import file (e.g., from Alpine or other structural software) that contains the nail plate definitions.

### Step 2: Visualization
- **Action**: The script reads the Map data and generates 3D rectangular bodies at the calculated coordinates.
- **Result**: The plates appear in the model with the dimensions and labels specified in the import file.

*(Note: If inserted manually via `TSLINSERT` without import data, the script may not generate visible geometry as it relies on specific Map length vectors to define size.)*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Plate Gauge | String | Value from _Map | The gauge or thickness specification of the nail plate (e.g., "20Ga"). Note: This is for information/reporting; the visual thickness is fixed. |
| Plate Label | String | Value from _Map | The manufacturer part number or descriptive ID for the plate. |
| Plate Length | Integer | Value from _Map | The physical length of the plate (mm). |
| Plate Height | Integer | Value from _Map | The physical height/width of the plate (mm). |

*Note: These properties are typically set to Read-Only to preserve the integrity of the imported engineering data.*

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None Specific* | This script does not add custom items to the right-click menu. Standard hsbCAD options (Erase, Move, Rotate, etc.) apply. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not use external settings files; all configuration comes from the Model Map import data.

## Tips
- **Visual Thickness**: The 3D body of the plate is drawn with a fixed thickness of 2mm for performance and visualization consistency, regardless of the "Plate Gauge" value displayed in the properties.
- **Missing Plates**: If a plate is missing from the view, check the source data to ensure the Length value is greater than 0. The script suppresses creation if dimensions are invalid.
- **Moving Plates**: You can use standard AutoCAD grips or commands (Move/Rotate) to adjust the plate position. The geometry will recalculate to maintain the correct orientation relative to the insertion point.

## FAQ
- **Q: Can I edit the size of the plate directly in the properties palette?**
  A: No, the dimensions are imported from engineering data and are usually Read-Only to prevent mismatching the structural design.
- **Q: Why does the plate look thin even if the Gauge indicates a thicker material?**
  A: The script uses a fixed 2mm visual thickness for the 3D model. The "Plate Gauge" property stores the correct specification for bills of materials and labels.
- **Q: The plate appears rotated incorrectly compared to the beam.**
  A: The script calculates orientation based on the import data. If the vectors in the import file are zero, it defaults to the Instance Coordinate System. Check the orientation of the instance or the source data vectors.