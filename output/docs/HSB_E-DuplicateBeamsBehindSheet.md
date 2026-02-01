# HSB_E-DuplicateBeamsBehindSheet

## Overview
This script automatically duplicates vertical studs behind sheeting joints to provide backing for nailing. It detects the edges of structural sheeting on a wall and generates extra backing beams (studs) to sandwich the sheet joint, ensuring strong connections.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates directly on 3D Wall elements. |
| Paper Space | No | Not applicable for 2D views. |
| Shop Drawing | No | This is a detailing/modification script, not a drawing generator. |

## Prerequisites
- **Required Entities**: A Wall element containing both beams (studs) and sheeting.
- **Minimum Beam Count**: None specific, but vertical beams must exist to be duplicated.
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `HSB_E-DuplicateBeamsBehindSheet.mcr`

### Step 2: Configure Properties
A dynamic dialog will appear upon insertion. Adjust the following settings to define which studs to duplicate and which sheeting layer to analyze.

### Step 3: Select Wall
```
Command Line: Select wall
Action: Click on the desired Wall element in the 3D model that contains the sheeting and studs you wish to process.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter type | dropdown | Include | Determines if the Beamcode filter acts as a whitelist (**Include**) or blacklist (**Exclude**). |
| Beamcode filter | text | (empty) | The beam code(s) to identify studs (e.g., "Stud"). Separate multiple codes with a semicolon (;). |
| Zone index | number | 1 | The index of the sheeting layer on the wall to analyze for joints (Range: 1-10). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific context menu options. It runs once upon insertion and deletes itself. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Script Behavior**: This script is a "run-once" tool. It will automatically delete itself from the drawing after processing the wall. If you need to undo the changes, use the standard AutoCAD `UNDO` command.
- **Beam Codes**: Ensure the `Beamcode filter` matches the codes used in your project (e.g., "Stud", "Cripple"). If the filter is empty, the script may process all or none depending on the `Filter type` logic.
- **Dual Pitch Roofs**: The script is smart enough to handle studs that intersect with different roof planes on either side (e.g., in a valley or dual-pitch situation), applying the correct cut angles to the new backing beams.
- **Mirroring**: If you have mirrored the wall, run this script again to ensure the backing studs are correctly generated for the mirrored geometry.

## FAQ
- **Q: Why did the script disappear after I selected the wall?**
  - A: The script is designed to erase itself after executing. Check your model to see if the new backing beams have been created behind the sheet joints.
- **Q: No beams were created. Why?**
  - A: This usually happens for three reasons: 1) The selected wall does not have sheeting in the specified `Zone index`. 2) No vertical studs were found that match the `Beamcode filter`. 3) The vertical studs are not aligned with any sheeting joints.
- **Q: What is the difference between Include and Exclude?**
  - A: **Include** only duplicates studs that match the code you type (e.g., only duplicate "Stud"). **Exclude** duplicates all studs *except* the ones matching the code (e.g., duplicate everything except "Trim").