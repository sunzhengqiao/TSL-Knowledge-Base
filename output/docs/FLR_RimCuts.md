# FLR_RimCuts.mcr

## Overview
Splits a selected long beam into multiple shorter segments based on a user-defined maximum length. This utility is useful for breaking down continuous rim joists or band beams into manageable stock lengths to match material availability.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script modifies 3D beam geometry in the model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This is a modeling tool, not a detailing tool. |

## Prerequisites
- **Required Entities**: At least one existing `Beam` entity in the drawing.
- **Minimum Beam Count**: 1.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `FLR_RimCuts.mcr`

### Step 2: Configure Properties (If prompted)
Depending on your configuration, a Properties dialog may appear automatically upon insertion.
- **Action**: Verify the **Max Rim Length** value is correct. If not, type the desired value (e.g., 2400 for mm or 8' for imperial) and click OK.

### Step 3: Select Beam
```
Command Line: 
Select a Beam
```
**Action**: Click on the beam in the drawing that you wish to split into smaller pieces.

### Step 4: Execution
- **Action**: The script will automatically calculate the number of cuts required and split the beam into segments of the specified length.
- **Result**: The script instance will delete itself from the drawing, leaving only the modified beams.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Max Rim Length | Number | U(144) | The target maximum length for each resulting beam segment. The script will cut the beam so that no resulting piece exceeds this length. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | The script runs once upon insertion and erases itself. There are no persistent right-click menu options. |

## Settings Files
- None required.

## Tips
- **Unit Independence**: The script uses internal unit conversion functions, so the **Max Rim Length** property works correctly whether your project is set to Metric (mm) or Imperial (inches).
- **Undoing**: Since the script erases itself after running, you can use the standard AutoCAD `UNDO` command to revert the beam to its original single-piece state immediately after execution.
- **Zero Length Error**: Ensure the **Max Rim Length** is set to a positive number. If set to 0, the script may fail to calculate the cuts.

## FAQ
- **Q: What happens if my beam is shorter than the Max Rim Length?**
  A: The script will detect that the beam does not need splitting, perform no action, and simply erase itself.
- **Q: Can I use this on curved beams?**
  A: The script splits based on the solid length along the beam's local X-axis. While it primarily targets linear rim joists, it will calculate length based on the centerline of the selected beam.
- **Q: Why did the script disappear from my drawing?**
  A: This is a "utility" script designed to perform a one-time action. It automatically removes itself (`eraseInstance`) after modifying the geometry to keep your drawing clean.