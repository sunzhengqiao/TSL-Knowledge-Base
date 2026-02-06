# hsbCLT-LapJoint

## Overview
This script automates the creation of lap joints on CLT (Cross Laminated Timber) panels. It allows users to split panels based on defined reference points, supports previewing joints before construction is generated, and provides tools to modify joint orientation and depth.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model to split and manipulate panel geometry. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: At least one CLT Panel (Element) in the Model Space.
- **Minimum Beam Count**: 1 Panel.
- **Required Settings**: `hsbCLT-LapJoint.xml` (Optional configuration file for default values).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-LapJoint.mcr` from the list.

### Step 2: Select Panel
```
Command Line: Select Element/Panel
Action: Click on the CLT panel in the model where you want to apply the lap joint.
```

### Step 3: Define Reference Point
```
Command Line: Specify Split point/Edge point
Action: Click a point on the panel to define where the lap joint should occur.
```

### Step 4: Configuration
The script will initialize and check for existing construction (SIPs/GenBeams).
- **If construction exists**: The panel will split immediately, and the joint geometry will be generated.
- **If no construction**: A plan-view symbol will be drawn. The split will occur automatically once construction is generated on the panel.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Joint Width | Number | Var. | Determines the width of the lap joint cut. |
| Joint Depth | Number | Auto | Sets the depth of the cut. Use 'Auto' (<=0) for half the panel thickness, or enter a manual value. |
| Gap | Number | 0 | Defines the gap size between joined parts. |
| Chamfer | Number | 0 | Sets the chamfer size on the joint edges. |
| Radius | Number | 0 | Applies a fillet radius to internal corners. |
| Side | Integer | 1 | Determines which side of the reference point the joint is applied to. |
| Flip Direction | Boolean | False | Toggles the orientation of the tool relative to the panel normal. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side | Reverses the side of the joint (swaps internal/external). This can also be triggered by double-clicking the instance. |
| Flip Direction | Toggles the joint direction 180 degrees relative to the panel surface. |
| Swap Depth | Swaps depth parameters between the reference side and the opposite side. |
| Add Panel(s) | Links additional existing panels to the current lap joint instance. |
| Remove Panel(s) | Unlinks panels from the lap joint instance. |

## Settings Files
- **Filename**: `hsbCLT-LapJoint.xml`
- **Location**: Company or Install path (standard hsbCAD search paths).
- **Purpose**: Stores catalog entries and default configuration parameters for dimensions and material assignments.

## Tips
- **Preview Mode**: You can insert this script on a panel before the construction (SIPs) is generated. The script will draw a preview symbol and automatically execute the split once the construction is calculated.
- **Auto Depth**: Leave the 'Joint Depth' set to 0 or negative to automatically default the depth to 50% of the panel thickness.
- **Quick Edit**: Double-click the graphical symbol in the model to quickly Flip the Side of the joint without using the context menu.

## FAQ
- **Q: Why didn't the panel split when I inserted the script?**
- **A:** The script is likely in "Preview Mode" because no construction (SIPs/GenBeams) exists inside the panel yet. Generate the construction for the panel, and the split will occur automatically.
- **Q: How do I move the joint to a different location?**
- **A:** Use the Grip Edit function. Click and drag the graphical grip in the model to relocate the joint reference point.
- **Q: What happens if I change the panel thickness?**
- **A:** If the Joint Depth is set to 'Auto', the cut depth will update automatically to match the new thickness (50%).