# Simpson StrongTie - I-Joist Hanger

## Overview
Generates a 3D model of a Simpson Strong-Tie I-Joist Hanger (top-flange style) and automatically cuts the joist to fit against a supporting carrier beam. It validates beam dimensions against selected hardware sizes to ensure proper fit.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script creates 3D Bodies and applies Cuts to beams. |
| Paper Space | No | Not designed for 2D layout or drawings. |
| Shop Drawing | No | This is a model generation script, not a detailing script. |

## Prerequisites
- **Required Entities**: Two existing `GenBeams` (I-Joists or Timber beams).
- **Minimum Beam Count**: 2
- **Configuration**: The beams must be perpendicular to each other (forming a T-junction).
- **Alignment**: The "Male" joist and "Female" carrier should be positioned correctly relative to each other before running the script.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `Simpson StrongTie - I-Joist Hanger.mcr`.

### Step 2: Select Male Beam (Joist)
```
Command Line: Select male beam
Action: Click on the joist beam that will be inserted into the hanger.
```

### Step 3: Select Female Beam (Carrier)
```
Command Line: Select female beam
Action: Click on the supporting beam (rim joist or carrier) that the hanger will attach to.
```

### Step 4: Configure Properties
Action: Upon selection, the properties dialog will appear (or you can edit via the Properties Palette).
1. Select the appropriate **Model** based on your joist size.
2. Adjust **Tolerances** if the actual lumber is smaller than the nominal size.
3. Click OK to generate the hanger and cut.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Model | dropdown | IUS1.56/9.5 | The Simpson Strong-Tie catalog number. Options include IUS1.56/9.5, IUS1.56/11.88, etc. Select the size matching your joist dimensions. |
| Male Tolerance | number | 0 | Manufacturing underrun allowance for the width of the male joist. Increase this if the joist is narrower than the nominal hanger width to prevent insertion errors. |
| Female Tolerance | number | 0 | Manufacturing underrun allowance for the height of the male joist. Increase this if the joist height is less than the nominal hanger height. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the hanger geometry if the connected beams have been modified or moved. |

## Settings Files
No external settings files are required for this script. All configurations are handled via the Properties Panel.

## Tips
- **Beam Orientation**: Ensure the Male and Female beams are perpendicular. If the script fails, check the Z-axes of the beams.
- **Undersized Lumber**: If the script reports that the joist is too small for the hanger, do not reduce the hanger size; instead, increase the "Male Tolerance" or "Female Tolerance" values to account for lumber milling variance.
- **Nail Reporting**: The script automatically assigns the correct nail quantity (8x 3.75 x 75mm galvanized round wire nails) to the hardware entity for reports and BOMs.

## FAQ
- **Q: Why did the script fail to insert?**
  A: The most common cause is that the selected beams are not perfectly perpendicular, or the joist dimensions fall outside the acceptable range for the selected hanger model (even with zero tolerance).
- **Q: Can I use this for face-mount hangers?**
  A: No, this script is specifically designed for "IUS" series top-flange (wrap-over) hangers for I-Joists.
- **Q: How do I change the hanger size after insertion?**
  A: Select the generated hanger in the model, open the Properties palette (Ctrl+1), and choose a different option from the "Model" dropdown list. The geometry will update automatically.