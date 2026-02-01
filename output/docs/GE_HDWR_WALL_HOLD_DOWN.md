# GE_HDWR_WALL_HOLD_DOWN

## Overview
This script generates 3D geometry, machining, and BOM data for metal hold-down brackets (e.g., Simpson Strong-Tie HTT, HDQ) attached to wall elements. It handles drilling for anchor rods and fasteners, automatically removes clashing studs during insertion, and manages dynamic links to anchor rod components.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates in 3D model space to generate solid bodies and apply drilling to wall elements. |
| Paper Space | No | This script does not generate 2D details directly in layout views. |
| Shop Drawing | No | This script is for model generation and BOM data, not shop drawing annotations. |

## Prerequisites
- **Required Entities**: A valid Wall Element (selected during insertion).
- **Minimum Beam Count**: 1 (The script relies on the Element context).
- **Required Settings**: `GE_HDWR_WALL_ANCHOR.mcr` (Must be available for anchor linking functionality).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_HDWR_WALL_HOLD_DOWN.mcr`

### Step 2: Select Element
```
Command Line: Select Element:
Action: Click on the Wall Element where the hold-down should be placed.
```
*Note: The script will automatically calculate the position based on the element's coordinate system.*

### Step 3: Configure Properties (Optional)
After insertion, select the generated connector and open the **Properties Palette** to adjust the connector model, dimensions, or fastener settings.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| arConnDescript | String | HTT4 SIMPSON | Select the specific catalog model of the hold-down. Changing this updates dimensions, hole positions, and shape logic automatically. |
| arDx | Length | 2.625" | The depth (width) of the connector plate perpendicular to the wall face. |
| arDy | Length | 12.375" | The vertical height of the connector. |
| arDz | Length | 0.25" | The thickness of the metal plate. |
| arDRod | Length | 0.625" | The diameter of the anchor rod (all-thread) that passes through the hold-down. |
| arDDrillCL | Length | 1.3125" | The distance from the wall face to the centerline of the anchor rod hole. |
| arIShape | Integer | 1 | A code determining the geometric topology (e.g., 1 for standard/HTT, 2 for HDQ, 4 for LTT, 6 for DH). |
| pFastenersType | String | 0.148 x 1 1/2" | The specific fastener (nail or screw) description used for the BOM. |
| iFastenersQty | Integer | 18 | The total quantity of fasteners required for installation. |
| strInstallation | String | Field Installed | Indicates the installation context (Field vs Shop) for reporting in lists. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Anchor | Creates an instance of the `GE_HDWR_WALL_ANCHOR` script linked to this hold-down, representing the concrete rod and embed. |
| Release Anchor | Removes the linked `GE_HDWR_WALL_ANCHOR` instance and clears the map reference. |

## Settings Files
- **Filename**: `GE_HDWR_WALL_ANCHOR.mcr`
- **Location**: TSL Search Path
- **Purpose**: Provides the anchor rod geometry and data that can be dynamically linked to this hold-down.

## Tips
- **Automatic Stud Removal**: When first inserted, the script checks for studs that clash with the connector body and automatically deletes them to provide clearance. This only happens during the initial creation.
- **Fastener Overrides**: If you modify the fastener type or quantity in the properties, the script will add an explicit line to the BOM, overriding the default catalog values.
- **Shape Logic**: The `arIShape` parameter controls the 3D generation logic. If you manually change dimensions but the shape looks wrong, ensure `arIShape` matches the connector type you are trying to simulate (e.g., ensure it is set to '2' for HDQ series brackets).

## FAQ
- **Q: Why did a stud disappear from my wall when I inserted the connector?**
  A: The script is designed to automatically detect and remove intersecting studs during the first insertion to ensure the hardware fits.
- **Q: How do I show the concrete rod in the foundation?**
  A: Right-click the hold-down connector and select **Add Anchor**. This will spawn the linked anchor script.
- **Q: I changed the connector model in the properties, but the holes didn't update.**
  A: Ensure you selected a valid model from the `arConnDescript` list. If you are manually adjusting dimensions, ensure `arIShape` matches the geometry logic you intend to use.