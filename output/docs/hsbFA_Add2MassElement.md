# hsbFA_Add2MassElement.mcr

## Overview
This script inserts a fastener assembly (such as a threaded rod or bolt) based on a cylindrical MassElement. It automatically generates clearance holes through selected timber beams (GenBeams) and applies grouping keys for consistent shop drawing labels.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for inserting the script and interacting with 3D beams and mass elements. |
| Paper Space | No | |
| Shop Drawing | No | While it creates grouping data for shop drawings, the script itself runs in the model. |

## Prerequisites
- **Required Entities**: A cylindrical MassElement (shape type `_kMSTCylinder`) must exist in the model or be created during insertion.
- **Minimum Beam Count**: 0 (GenBeams are optional if you only want the fastener assembly without drilling).
- **Required Settings**: A valid Fastener Assembly Definition must exist in your hsbCAD catalog to select a Style.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `hsbFA_Add2MassElement.mcr`.

### Step 2: Select Mass Element
```
Command Line: Select Mass Element(s)
Action: Click on the cylindrical MassElement in the model that represents the location of the fastener.
```

### Step 3: Select GenBeams (Optional)
```
Command Line: Select GenBeam(s) (optional)
Action: Select the timber beams you wish to drill through. Press Enter to skip if no drilling is required.
```
*Note: If you insert the script using the specific execute key 'NOGENBEAM', this prompt is skipped automatically.*

### Step 4: Define Length (Optional)
```
Command Line: Select start and end point (optional)
Action: You can click two points in 3D space to manually define the length and direction of the fastener guideline. Press Enter to skip and use automatic calculation.
```

### Step 5: Configure Properties
Action: The Properties palette will appear. Select the **Fastener Style** and adjust diameters or depths as needed. The script will generate the fastener and drills immediately.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Fastener Style | dropdown | (Empty) | Selects the hardware configuration (e.g., threaded rod type) from your catalog. |
| Flip Side | dropdown | No | Reverses the drilling direction. "Yes" calculates depth from the opposite side of the intersection. |
| Delta Diameter | number | -1.0 | Adjusts the hole size. Positive values make the hole larger (clearance); negative values make it smaller. |
| Depth | number | 0.0 | Length of the drill. `0` creates a through-hole (drills completely through the beam). Any positive value creates a blind hole of that depth. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add GenBeam | Allows you to select additional timber beams after insertion. The script will calculate and add drills to these new beams. |
| Remove GenBeam | Prompts you to select a beam to remove its associated drill from this assembly. |
| Flip Side | Toggles the "Flip Side" property, reversing the drill direction instantly. |
| Edit in place | Allows you to manually redefine the start and end points of the fastener guideline by clicking in the model. |

## Settings Files
- **Filename**: None specified
- **Location**: N/A
- **Purpose**: This script relies on the standard hsbCAD Fastener Catalogs rather than external XML settings files.

## Tips
- **Through Holes**: Leave **Depth** set to `0.0` to ensure the drill goes all the way through the selected beams.
- **Clearance**: If your rod is 20mm and you want a 22mm hole, ensure your MassElement radius is 10mm and set **Delta Diameter** to `2.0`.
- **Direction**: The Z-axis of the MassElement defines the default drilling direction. Use **Flip Side** if the drill is going the wrong way.
- **Grouping**: The script automatically attaches a group key (if the `hsbDimGroup` property set is available) to group holes in shop drawings.

## FAQ
- **Q: Why is no drill appearing in my beam?**
  A: Check if you selected the correct GenBeam in Step 3 or used "Add GenBeam" from the right-click menu. Also, ensure the cylinder actually intersects with the timber.
- **Q: How do I make the hole larger than the rod?**
  A: Increase the **Delta Diameter** value. For example, `2.0` will add 1mm to the radius (2mm to the total diameter).
- **Q: Can I change the length of the rod visually?**
  A: Yes, use the "Edit in place" right-click option to select new start and end points, or grip-edit the guideline points if enabled.