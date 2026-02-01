# GA-T.mcr

## Overview
Inserts manufacturer-specific metal angle brackets to connect timber beams or trusses. It handles automatic placement fitting, collision detection with other connectors, and optional material subtraction for flush mounting.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates exclusively in the 3D model. |
| Paper Space | No | This script does not generate 2D drawings directly. |
| Shop Drawing | No | This is a modeling/ detailing tool. |

## Prerequisites
- **Required Entities**: `GenBeam` or `Truss` elements.
- **Minimum Beams**: 1 (primary element to connect).
- **Required Settings**: 
  - `GenericAngle.xml` (Configuration file).
  - Manufacturer definition files (e.g., Simpson Strong-Tie, Würth) located in `hsbCompany\TSL\Settings` or `hsbInstall\Content\General\TSL\Settings`.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GA-T.mcr` from the list.

### Step 2: Select Location
```
Command Line: Select beam or truss:
Action: Click on the timber element (beam or truss) where you want to place the bracket.
```
```
Command Line: Specify insertion point:
Action: Click on the face or edge of the beam to define the exact position for the connector.
```

### Step 3: Configure Bracket
- Upon insertion, a dialog may appear to select the **Catalogue** (Manufacturer).
- Alternatively, select the script instance and modify settings in the **Properties Palette**.

## Properties Panel Parameters

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Catalogue** | dropdown | `_Default` | Manufacturer List | Select the specific manufacturer catalog (e.g., Simpson, Würth). This defines geometry, size, and nail patterns. |
| **Subtract** | dropdown | No | Yes, No | If **Yes**, creates a recess/milling in the timber so the bracket sits flush. If **No**, the bracket sits on the surface. |
| **Side** | dropdown | Left | Left, Right | Determines the horizontal side of the beam's centerline for placement. |
| **SideDetail** | dropdown | Left | Left, Right | Refines the side orientation for specific detailing requirements or secondary connections. |
| **Display** | dropdown | Body | Body, Model, Symbol | Controls how the bracket is visualized: **Body** (3D Solid), **Model** (Wireframe), or **Symbol** (2D Representation). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Flip Y axis** | Flips the vertical orientation of the bracket. |
| **Swap legs** | Swaps the connection logic, effectively rotating the bracket 180 degrees or swapping which legs connect to which members. |

## Settings Files
- **Filenames**: `GenericAngle.xml` and Manufacturer XMLs (e.g., `Simpson.xml`, `Wuerth.xml`).
- **Location**: 
  - `hsbCompany\TSL\Settings` (Custom company settings).
  - `hsbInstall\Content\General\TSL\Settings` (Default hsbCAD settings).
- **Purpose**: These files contain the geometric dimensions, article numbers, and fastener patterns for the angle brackets.

## Tips
- **Automatic Fitting**: If the bracket does not fit at the selected location upon insertion, the script will automatically attempt to mirror or rotate it to find a valid position. If it still fails, the instance will be erased.
- **Collision Detection**: If you see the text **"Collision!!!"** at the insertion point, the new bracket overlaps with an existing one. Move the script or delete the conflicting bracket.
- **Flush Mounting**: Use the **Subtract** property set to **Yes** when you need the metalwork to be recessed into the timber (e.g., for architectural requirements or cladding clearance).

## FAQ
- **Q: Why did the script disappear immediately after I placed it?**
  **A:** The script could not find a valid geometric fit for the selected bracket size on that specific part of the beam, even after trying mirrored and rotated orientations. Try a different location or a smaller bracket.
- **Q: How do I hide the bracket details in the model to improve performance?**
  **A:** Select the bracket and change the **Display** property in the Properties Palette to **Symbol** or **Model**.
- **Q: The text "Collision!!!" appeared. What should I do?**
  **A:** This indicates the bracket is interfering with another connector. Move the script along the beam axis or adjust the **Side** parameter to shift it away from the obstacle.