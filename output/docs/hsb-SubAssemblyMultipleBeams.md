# hsb-SubAssemblyMultipleBeams

## Overview
This script groups a main beam and multiple secondary beams into a single logical SubAssembly component. It is useful for organizing timber elements (such as roof trusses or gable frames) so they can be treated, manufactured, and transported as one unified unit.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D model environment. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Not used for generating 2D drawings directly. |

## Prerequisites
- **Required Entities**: At least one GenBeam (Main Beam) and one or more additional GenBeams.
- **Minimum beam count**: 2 beams total (1 Main + 1 Extra).
- **Required settings**: The target script `hsb-SubAssembly.mcr` must be present in your hsbCAD environment, as this script generates an instance of it.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` → Select `hsb-SubAssemblyMultipleBeams.mcr` from the file dialog, or run via your custom hsbCAD toolbar/menu.

### Step 2: Select Main Beam
```
Command Line: Select Main Beam
Action: Click on the primary structural beam that will serve as the anchor/host for the assembly.
```

### Step 3: Select Extra Beams
```
Command Line: Extra beams to create SubAssembly
Action: Select all other beams that need to be included in this group. You can select multiple beams. Press Enter when finished.
```
*Note: If you accidentally select the Main Beam again during this step, the script will automatically ignore it.*

## Properties Panel Parameters
This script does not have persistent user-editable properties in the Properties Palette. It acts as a one-time generator to create the assembly and then removes itself from the project.

## Right-Click Menu Options
There are no specific context menu options added by this script. It executes immediately upon insertion.

## Settings Files
This script does not use external XML settings files. However, it depends on the script `hsb-SubAssembly.mcr` to function correctly.

## Tips
- **Auto-Cleanup**: The script instance automatically deletes itself after creating the SubAssembly. You do not need to manually delete the "launcher" script from the model.
- **Duplicate Prevention**: The script checks if an identical subassembly (same combination of beams) already exists on the main beam. If it finds a match, it will not create a duplicate, preventing errors.
- **Selection Order**: You can select the extra beams in any order. The script organizes them internally by their unique ID to ensure consistent naming.
- **Resulting Entity**: After running, look for the new SubAssembly attached to the Main Beam in your Project Tree.

## FAQ
- **Q: What happens if I select the main beam in the second group?**
  **A**: The script is smart enough to filter it out. You will not get a duplicate entry; the assembly will be created correctly.
- **Q: Can I use this to create a floor cassette?**
  **A**: Yes, this script is ideal for grouping multiple joists and bearers into a single cassette component.
- **Q: Why did the script disappear after I ran it?**
  **A**: This is normal behavior. The script is a "generator" tool. Its job is finished once the SubAssembly is created, so it erases itself to keep your model clean.