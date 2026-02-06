# hsbLathMarking

## Overview
Projects the location of beams or laths from one construction zone (source) onto another zone (target) as machine markers or layout lines. This is typically used to project rafter or lath positions onto underlying structural layers for machining or assembly guides.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model elements (ElementRoof). |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | Generates 3D marker data only. |

## Prerequisites
- **Required Entities**: An `ElementRoof` containing generated beams in at least two different zones.
- **Minimum Beams**: Beams must exist in both the Source (Defining) and Target (Marking) zones.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbLathMarking.mcr`

### Step 2: Configure Properties
```
Command Line: Select properties or catalog entry and press OK, then select roofelements
Action: A dialog appears. Set the Source Zone (Defining), Target Zone (Marking), and Tooling Index. Click OK to confirm.
```

### Step 3: Select Elements
```
Command Line: Select element(s)
Action: Click on the desired ElementRoof entities in the model view. Press Enter to finish selection and generate the markings.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Defining Zone | dropdown | 10 | The "Source" zone containing the beams whose positions you want to project (e.g., laths). |
| Marking Zone | dropdown | 0 | The "Target" zone that will receive the projected marks (e.g., rafters or top plates). |
| Tooling Index | number | 1 | The machine identifier code (CNC/CAM) assigned to the generated marker lines. |
| Max. Width | number | 0 | Restricts the script to elements with a width less than or equal to this value (0 = any width). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Edit in Place | Toggles "Edit Mode". When active, allows you to select and modify individual projection lines using grip points. When inactive, the script automatically calculates markings for the whole element. |

## Settings Files
- **Filename**: None specific.
- **Location**: N/A
- **Purpose**: Uses internal script maps to store "LastInserted" settings and temporary edit states.

## Tips
- **Validation**: The script will automatically delete itself if the element width exceeds the "Max. Width" value or if the Defining and Marking Zones are set to the same index.
- **Zone Hierarchy**: Ensure your Defining Zone is logically positioned relative to the Marking Zone to avoid "Defining zone may not be above marking zone" errors.
- **Fine-tuning**: Use the "Edit in Place" function to adjust specific marker lines that might intersect with obstacles or require manual tweaking.

## FAQ
- **Q: Why did the script disappear after I inserted it?**
  **A:** Check the command line for an error. This usually happens if the element width is larger than the "Max. Width" setting, or if the selected zones do not contain any beams yet.
- **Q: Can I change the machine operation after creating the marks?**
  **A:** Yes. Select the element, open the Properties Palette, and change the "Tooling Index" value. The markers will update to the new ID.
- **Q: How do I move just one mark?**
  **A:** Right-click the element and select "Edit in Place". Select the specific line you wish to move and use the blue grip point to slide it along the beam.