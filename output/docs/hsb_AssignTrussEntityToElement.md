# hsb_AssignTrussEntityToElement.mcr

## Overview
Assigns selected Truss or Joist entities to a specific construction Element and categorizes them into a defined logical "Zone" for manufacturing, reporting, and shop drawing organization.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D model where Truss Entities and Elements exist. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: Truss Entities (or Joists) and a target construction Element must exist in the model.
- **Minimum Beam Count**: N/A (Selects entities, not individual beams).
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse to and select `hsb_AssignTrussEntityToElement.mcr`.

### Step 2: Configure Zone
- A Dynamic Dialog will appear automatically upon insertion.
- Select the desired **Zone to Assign the Trusses** (Options 0 through 10).
- Click **OK** to proceed.

### Step 3: Select Trusses
```
Command Line: Select Truss/Joist entities
Action: Click on the trusses or joists you wish to assign. Press Enter to confirm selection.
```

### Step 4: Select Target Element
```
Command Line: Select element to link too
Action: Click on the construction Element (Wall, Floor, Roof) that the trusses belong to.
```

### Step 5: Completion
- The script processes the assignment and automatically erases itself from the model.
- The link is now established in the database.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone to Assign the Trusses | Dropdown | 0 | Categorizes the trusses into a specific group within the element. <br>**Mapping:**<br>Options 0-5 assign to positive indices (0-5).<br>Options 6-10 assign to negative indices (-1 to -5), typically used for secondary sides or layers. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not remain in the model after execution; therefore, no right-click menu options are available. |

## Settings Files
None required.

## Tips
- **Script Disappears**: This is a "fire and forget" tool. Once it links the entities, it deletes itself. You do not need to (and cannot) delete it manually afterwards.
- **Zone Logic**: Use the Zone index to differentiate trusses on different sides of a wall or in specific bays.
    - Example: Use `0` for the "Left Side" and `6` (which maps to index -1) for the "Right Side".
- **Verification**: To verify the assignment worked, check your production lists or element properties to ensure the trusses are now grouped under the correct Element and Zone.

## FAQ
- **Q: The script vanished immediately after I selected the element. Did it fail?**
  - A: No. This is the intended behavior. The script only exists temporarily to create the data link.
- **Q: How do I undo the assignment?**
  - A: There is no automatic "undo" button for this specific action. You would need to clear the entity assignments manually or re-run the script to assign them to a different element/zone.
- **Q: What happens if I select option 6 in the dropdown?**
  - A: Option 6 maps to internal index **-1**. This is useful if your production logic requires negative numbers for certain conditions (e.g., opposite walls).