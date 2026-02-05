# Pitzl Pfostenträger (Post Base)

## Overview
This script generates Pitzl post base connectors (Type 10930 or 10931) on timber beams. It creates the necessary 3D steel hardware model and applies machining (cuts and drills) to the beam for installation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used for generating 3D hardware and machining on beams. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | Does not generate 2D drawings directly. |

## Prerequisites
- **Required Entities**: `GenBeam` (Timber Beam)
- **Minimum Beam Count**: 1
- **Required Settings Files**: `Pitzl Pfostenträger.xml` (Must be located in the Company or Install `TSL\Settings` folder)

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Pitzl Pfostenträger.mcr`

### Step 2: Select Beam(s)
```
Command Line: Select beam(s)
Action: Click on the vertical or sloped timber beam you wish to equip with the post base.
```
*Note: The script will reject horizontal beams.*

### Step 3: Define Insertion Point
```
Command Line: Point for insertion (Optional)
Action: Click a point in the model to define the height/location, or press Enter to use the beam's bottom point automatically.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | dropdown | 10930 | Selects the product family: **10930** (Plane pipe) or **10931** (Threaded pipe). |
| Article | dropdown | (varies) | Selects the specific size and height adjustment range (e.g., 1000, 1100, 1200, etc.). |
| Milled | dropdown | No | Set to **Yes** to create a recess in the beam so the top plate sits flush. |
| Additional mill depth | number | 8.0 mm | Extra depth for the milling operation (added to the plate thickness). |
| Oversize drill | number | 2.0 mm | Diameter increase for drilled holes to allow for tolerances/coatings. |
| Cover hull | dropdown | No | Set to **Yes** to include a protective cover cylinder around the rod. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Set to standard height | Resets the installation height to the midpoint of the current Article's allowed range. |
| Rotate post base | Rotates the hardware 90 degrees around the beam axis. (Also triggered by double-clicking the script instance). |

## Settings Files
- **Filename**: `Pitzl Pfostenträger.xml`
- **Location**: `_kPathHsbCompany\TSL\Settings\` or `_kPathHsbInstall\Content\General\TSL\Settings\`
- **Purpose**: Contains manufacturer data, dimensions, drill sizes, and valid height ranges for the various Articles (e.g., 10930 vs 10931).

## Tips
- **Horizontal Beams**: The script will report an error if you try to insert it on a horizontal beam. Ensure the beam is vertical or sloped.
- **Rotation**: You can quickly rotate the post base orientation by double-clicking the script instance in the model.
- **Height Validation**: If you manually enter a height that is outside the range of the selected Article, the script will automatically correct (clamp) it to the nearest valid limit.

## FAQ
- **Q: I get an error "Insertion not possible for horizontal beams". Why?**
  A: This hardware is designed for vertical posts. You must select a beam that is vertical or sloped.
- **Q: Why did the Height value change when I selected a different Article?**
  A: The script automatically resets the height to the standard midpoint of the new Article's adjustment range to ensure it fits.
- **Q: What is the difference between Type 10930 and 10931?**
  A: 10930 uses a plane pipe connection, while 10931 uses a threaded pipe connection for the vertical rod.