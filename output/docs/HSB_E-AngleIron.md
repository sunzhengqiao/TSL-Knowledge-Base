# HSB_E-AngleIron.mcr

## Overview
This script generates a custom angle iron connection between multiple primary beams and a single secondary beam. It creates 3D geometry for the angle iron and an optional rod, with configurable properties for dimensions, positioning, and hardware export data.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates 3D `Body` objects and hardware components in the model. |
| Paper Space | No | This script does not function in Paper Space or Shop Drawings. |
| Shop Drawing | No | This is a detailing/modeling script only. |

## Prerequisites
- **Required Entities**: Beams (GenBeam).
- **Minimum Beam Count**: 2 (One or more beams for the first selection, and one beam for the second selection).
- **Required Settings**: None strictly required, though a Catalog entry can be used for predefined configurations.

## Usage Steps

### Step 1: Launch Script
Execute the command `TSLINSERT` and select `HSB_E-AngleIron.mcr` from the list.

### Step 2: Configuration Dialog (If applicable)
If the script is run without a specific Catalog Key, a configuration dialog may appear allowing you to preset the Angle Iron and Rod dimensions.

### Step 3: Select First Beams
```
Command Line: Select first beam(s)
Action: Click on one or multiple beams in the model that represent the primary side of the connection. Press Enter to confirm selection.
```

### Step 4: Select Second Beam
```
Command Line: Select second beam
Action: Click on the single beam that represents the secondary side of the connection.
```

### Step 5: Automatic Generation
The script will automatically generate an angle iron instance for every beam selected in Step 3, connecting them to the beam selected in Step 4.

## Properties Panel Parameters

These parameters can be edited in the AutoCAD Properties Palette (OPM) after selecting the generated script instance.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Length 1** | Number | 100 mm | Sets the length of the angle along the first (male) beam. |
| **Length 2** | Number | 100 mm | Sets the length of the angle along the second (female) beam. |
| **Width** | Number | 50 mm | Sets the width (leg size) of the angle iron. |
| **Thickness** | Number | 8 mm | Sets the material thickness of the angle iron. |
| **Position rod** | Number | 50 mm | Sets the offset position of the rod relative to the angle origin. |
| **Diameter rod** | Number | 10 mm | Sets the diameter of the rod. Set to **0** to omit the rod entirely. |
| **Flip side** | Boolean/Option | - | Toggles the angle iron to the opposite side of the connection point. |
| **Add to element** | Boolean | - | If Yes, assigns the hardware to the Element Group of the associated beam. |
| **Article** | String | - | Defines the Article Number for hardware export/listings. |
| **Description** | String | - | Defines the Description text for the hardware component. |
| **Material** | String | - | Defines the Material code for the hardware component. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Refreshes the script geometry to reflect changes in beam positions or property values. |

## Settings Files
- **Catalog Entries**: The script supports execution via Catalog Keys. If a catalog is used, default values for dimensions and material are loaded from the relevant catalog entry.

## Tips
- **Multiple Connections**: You can connect multiple beams to a single secondary beam in one operation by selecting all the primary beams during the "Select first beam(s)" prompt.
- **Removing the Rod**: If you only need the angle iron plate, simply set the **Diameter rod** property to `0`.
- **Flipping**: If the angle iron is generated on the wrong side of the beams, select the script instance and change the **Flip side** property in the Properties palette.

## FAQ
- **Q: I selected multiple beams, but nothing happened?**
  **A**: Ensure you select the "first" beams (multiple allowed), press Enter, and *then* select a valid "second" beam (single). The script requires both sets of inputs to generate geometry.

- **Q: How do I change the size after insertion?**
  **A**: Select the angle iron object in the model, open the Properties palette (Ctrl+1), and modify the **Length 1**, **Length 2**, **Width**, or **Thickness** values. The 3D model will update automatically.

- **Q: Why is there no rod in my model?**
  **A**: Check the **Diameter rod** property in the Properties palette. If it is set to 0, the rod is suppressed. Increase the value to generate the rod geometry.