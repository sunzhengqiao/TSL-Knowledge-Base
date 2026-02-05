# Merk Stutzenfuss

## Overview
This script generates a "Merk" column foot connection, including steel hardware (base plate, cylindrical tube, pressure plate, and hex nut) and the necessary timber machining (drilling and end-cutting) to anchor a timber column to a foundation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is designed for 3D model generation. |
| Paper Space | No | Not supported for 2D layouts. |
| Shop Drawing | No | Not a shop drawing script. |

## Prerequisites
- **Required Entities:** A single GenBeam (Column).
- **Minimum Beam Count:** 1
- **Required Settings:** None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Merk Stutzenfuss.mcr` from the list.

### Step 2: Select Column
```
Command Line: Select beam:
Action: Click on the timber column (GenBeam) where you want to install the column foot.
```

### Step 3: Configure Properties
```
Action: A properties dialog appears automatically upon insertion. Adjust the dimensions (Height, Diameter, Offsets) as needed and click OK.
```

### Step 4: Completion
```
Action: The script inserts the steel parts (Base Plate, Cylinder, Pressure Plate, Nut) and applies the machining (Drills and Cut) to the selected column.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Height | Number | 200 | The height of the pressure plate connection relative to the base. This value determines the article code and cylinder length (see Tips). |
| Diameter | Number | 40 | The diameter of the main central bore hole drilled into the timber. |
| Base Height | Number | 0 | Vertical offset of the base plate. Use this to shift the entire connection up or down relative to the column's reference line. |
| Extra Drilling Depth | Number | 0 | Additional depth for the main bore hole beyond the standard calculation. |
| Depth Drill Housing | Number | 20 | The depth of the wider "housing" drill near the top of the connection where the pressure plate sits. |
| \|Group, Layername or Zone Character\| | Text | Z | Determines the layer or group assignment. Enter a Group Name, a Zone Character (T, I, J, Z, C), or a specific Layer Name. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific custom items to the right-click context menu. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Automatic Hardware Selection:** The script automatically selects the correct cylinder length and article code based on the **Height** parameter:
  - **Height ≤ 210 mm:** Uses Cylinder 300mm (Art 118 150).
  - **210 < Height ≤ 310 mm:** Uses Cylinder 400mm (Art 118 250).
  - **Height > 310 mm:** Uses Cylinder 620mm (Art 118 450).
- **Vertical Adjustment:** Use the **Base Height** parameter if you need to raise the base plate off the floor level or adjust for specific foundation details.
- **Layer Organization:** The **Group/Layer** property is flexible. If you type "Z", it assigns to the Zone. If you type an existing Group name, it adds to that Group. Otherwise, it creates a new Layer.

## FAQ
- **Q: Why did the cylinder size change when I only updated the Height?**
  - A: The script has built-in logic to switch hardware (Article 150, 250, or 450) depending on the height thresholds (210mm and 310mm).
- **Q: How do I move the entire assembly up the column?**
  - A: Modify the **Base Height** property in the Properties Palette. Increasing this value moves the base plate and all associated drilling upwards.
- **Q: The drill holes are in the wrong layer. How do I fix this?**
  - A: Change the **\|Group, Layername or Zone Character\|** property. If you want it on a specific layer, type the exact layer name there.