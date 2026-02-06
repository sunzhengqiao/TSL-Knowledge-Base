# PC.mcr

## Overview
This script automates the generation and distribution of Knapp Walco plate connectors (specifically the Walco-V series) on a selected timber beam. It calculates the placement of connectors based on distribution rules, applies the necessary milling and drilling operations, and adds the hardware components to the Bill of Materials (BOM).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is a 3D modeling script for GenBeams. |
| Paper Space | No | Not applicable for detailing views. |
| Shop Drawing | No | Does not generate 2D drawings directly. |

## Prerequisites
- **Required Entities**: At least one `GenBeam` must exist in the drawing.
- **Minimum Beam Count**: 1
- **Required Settings Files**:
    - `PC.xml`: This file must be located in either your Company folder (`...\TSL\Settings`) or the hsbCAD Install folder (`...\Content\General\TSL\Settings`). It contains the manufacturer data, product families, and default tooling dimensions.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `PC.mcr` from the list.

### Step 2: Select Main Beam
```
Command Line: Select a GenBeam
Action: Click on the timber beam (e.g., a wall plate or rafter) where you want to install the connectors.
```

### Step 3: Position Connector
```
Command Line: Select a point on the beam to position the connector
Action: Click a point on the selected beam to define the start location or alignment area for the connectors.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Component** | | | |
| Manufacturer | dropdown | --- | Select the hardware manufacturer (e.g., Knapp). This loads specific catalog data. |
| Family | dropdown | --- | Select the product family (e.g., Walco-V) based on the selected manufacturer. |
| Product | dropdown | --- | Select the specific part number/model. This determines the physical size and fastener pattern. |
| **Distribution** | | | |
| Mode of Distribution | dropdown | Even | Choose how connectors are spaced: **Even** (maximizes spacing) or **Fixed** (uses exact step size). |
| Start Distance | number | 0 | The distance from the start of the beam reference point to the center of the first connector. |
| End Distance | number | 0 | The distance from the end of the beam reference point to the center of the last connector. |
| Max. Distance between / Quantity | number | 500 | In **Even** mode: Maximum spacing allowed. In **Fixed** mode: Exact spacing. Enter a **negative number** to specify a fixed quantity of parts. |
| Real Distance between | number | 0 | *(Read-only)* Displays the calculated distance between connector centers. |
| Nr. | integer | 0 | *(Read-only)* Displays the total quantity of connectors calculated. |
| **Position** | | | |
| Offset | number | 0 | Lateral offset of the connector relative to the beam's reference axis/centerline. |
| **Tooling for connector beam** | | | |
| Clip Lock | dropdown | No | Select **Yes** to include a clip-lock (Sperrklappe) hardware item in the BOM. |
| **Milling for connector beam** | | | |
| Width | number | 0 | Width of the pocket milled into the beam. Set to **0** to use the product default from XML. |
| Length | number | 0 | Length of the pocket milled into the beam. Set to **0** to use the product default from XML. |
| Depth | number | 0 | Depth of the pocket milled into the beam. Set to **0** to use the product default from XML. |
| **Drilling for connector beam** | | | |
| Diameter | number | 0 | Diameter of the drill holes for fasteners. Set to **0** to use the product default from XML. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom items to the right-click context menu. All modifications are handled via the Properties Palette. |

## Settings Files
- **Filename**: `PC.xml`
- **Location**: Searches `_kPathHsbCompany\TSL\Settings` first, then `_kPathHsbInstall\Content\General\TSL\Settings`.
- **Purpose**: Stores the catalog of manufacturers, families, products, and their associated default dimensions (milling depth, drill diameters, etc.).

## Tips
- **Fixed Quantity**: To insert exactly 5 connectors along the beam, enter `-5` in the **Max. Distance between / Quantity** field. The script will automatically space them evenly within the Start/End boundaries.
- **Restoring Defaults**: If you manually change the milling dimensions (Width/Length/Depth) and want to revert to the manufacturer's standard size, simply change the value back to `0`.
- **Error Handling**: If the script immediately deletes itself after insertion, check the command line for an error message. This usually means `PC.xml` is missing or the manufacturer data within it is corrupt.

## FAQ
- **Q: Why did the tool disappear immediately after I selected the beam?**
    - A: The script could not find the required manufacturer data in `PC.xml`. Ensure the file exists in your TSL Settings folder and contains valid data.
- **Q: How do I change the connector size after inserting it?**
    - A: Select the inserted script instance in the drawing, open the **Properties** palette (Ctrl+1), and change the **Product** dropdown. The milling and drilling dimensions will update automatically if they are set to 0.
- **Q: Can I use this for hardware other than Knapp Walco?**
    - A: Only if the `PC.xml` file has been updated with data for other manufacturers. The script relies strictly on the data provided in that XML file.