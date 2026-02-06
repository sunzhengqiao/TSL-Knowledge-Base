# hsb_SetOpeningConfiguration.mcr

## Overview
This script allows you to bulk-configure the vertical framing arrangement around wall openings. It sets the specific count of load-bearing (Jack studs) and non-load-bearing (King studs) members on both the left and right sides of selected openings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the model where opening entities exist. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | This is a configuration tool for the model generation phase. |

## Prerequisites
- **Required Entities:** `Opening` entities must exist in the drawing.
- **Minimum beam count:** None.
- **Required settings files:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SetOpeningConfiguration.mcr`

### Step 2: Select Openings
```
Command Line: Please select Openings
Action: Click on the opening(s) (windows or doors) you wish to modify. You can select multiple openings at once. Press Enter to confirm selection.
```

### Step 3: Configure Parameters
After selection, the script attaches to the openings. Use the **Properties Palette** (Ctrl+1) to adjust the stud counts. The model will regenerate automatically to reflect the changes.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Number Support Beams Left | number | 1 | Number of load-bearing vertical members (e.g., Jack Studs) on the left side that support the lintel/header. |
| Number No Support Beams Left | number | 1 | Number of non-load-bearing vertical members (e.g., King Studs) on the left side used for stiffening. |
| Number Support Beams Right | number | 1 | Number of load-bearing vertical members (e.g., Jack Studs) on the right side that support the lintel/header. |
| Number No Support Beams Right | number | 1 | Number of non-load-bearing vertical members (e.g., King Studs) on the right side used for stiffening. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are defined for this script. Use the Properties Palette to make changes. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Bulk Editing:** You can select multiple openings in Step 2 (e.g., all windows on a specific wall) and change the properties once to update them all simultaneously.
- **Validation:** After changing the numbers, the script automatically triggers a model regeneration. Verify the updated framing in the 3D model or plan view.

## FAQ
- **Q: What is the difference between "Support" and "No Support" beams?**
  - **A:** "Support Beams" typically refer to Jack Studs or Trimmer Studs that carry the load of the header above the opening. "No Support Beams" typically refer to King Studs or full-height stiffeners that provide stability but do not directly support the header.
- **Q: I changed the numbers but see no change in the drawing.**
  - **A:** Ensure the wall containing the openings is not locked or frozen. The script attempts to regenerate the construction automatically; if it fails, try running the `Hsb_GenerateConstruction` command manually.