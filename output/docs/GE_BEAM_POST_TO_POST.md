# GE_BEAM_POST_TO_POST.mcr

## Overview
This script automatically generates filler beams (studs or blocking) between two selected vertical posts. It allows for manual or inventory-based sizing and offers options for beam distribution across the post width.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for generating beams. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | This is a modeling script, not a detailing tool. |

## Prerequisites
- **Required Entities**: Two existing `GenBeam` entities representing vertical posts.
- **Minimum Beam Count**: 2 existing beams must be selected during insertion.
- **Required Settings**:
    - `hsbFramingDefaults.Inventory.dll`: Used to retrieve material grades and standard lumber sizes.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_BEAM_POST_TO_POST.mcr` from the list.

### Step 2: Select First Post
```
Command Line: Select first post
Action: Click on the first vertical GenBeam (post) you wish to span between.
```

### Step 3: Select Second Post
```
Command Line: Select another post
Action: Click on the second vertical GenBeam.
```

### Step 4: Configure Properties
```
Action: The Dynamic Dialog appears automatically. Adjust the number of beams, size source, and distribution pattern as needed. Click OK to generate.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Distribution | Integer | 0 | Determines how beams are arranged: 0=Left to Right, 1=Centered, 2=Right to Left. |
| Beam Count | Integer | 1 | The number of filler beams to generate between the posts. |
| Size Source | String | Inventory | Choose between "Inventory" (uses dll defaults) or "Manual" (uses custom properties). |
| Manual Size | String | 2x4 | Nominal size (e.g., 2x6, 2x8) used only if Size Source is set to Manual. |
| Material | String | - | The material name. Can be pulled from Inventory or entered manually. |
| Grade | String | - | The structural grade of the lumber. Can be pulled from Inventory or entered manually. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This is a "Generator" script. It runs once, creates the beams, and then erases itself from the drawing. It does not remain for context menu editing. |

## Settings Files
- **DLL**: `hsbFramingDefaults.Inventory.dll`
- **Location**: hsbCAD installation directory (typically mapped in `TSL.INI`).
- **Purpose**: Provides default dimensions, material names, and grade information based on the selected lumber item key.

## Tips
- **Post Alignment**: Ensure the two selected posts are vertical and have their top surfaces at the same Z-height. The script validates this and may fail if they are misaligned.
- **Fit Check**: The script calculates if the selected number of beams will physically fit on the width of the post. If the total width of the new beams exceeds the post width (plus a small tolerance), generation may fail.
- **Centered Distribution**: Use the "Centered" (1) distribution option for symmetrical layouts like window sills or headers between posts.

## FAQ
- Q: Why did the script disappear immediately after I ran it?
- A: This is normal behavior for generator scripts. Once the beams are created and added to the model, the script instance removes itself to prevent duplicate data.
- Q: Can I edit the beams after creation?
- A: Yes. You can select the newly generated GenBeams and modify their properties using the standard AutoCAD Properties Palette (OPM) or other hsbCAD editing tools.