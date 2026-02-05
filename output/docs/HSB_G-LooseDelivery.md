# HSB_G-LooseDelivery.mcr

## Overview
This tool reorganizes loose timber parts within selected construction elements. It automatically moves specific beams (based on their beam codes) from the main element into designated "Loose Delivery" or "Sill" groups, replacing any existing outdated beams in the destination groups to ensure your packaging lists are accurate.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Not designed for 2D detailing generation. |

## Prerequisites
- **Required Entities**: You must have Elements (e.g., Walls, Roofs) already drawn in the model.
- **Group Structure**: The destination groups (e.g., groups named "Los" or "Loose") must exist in your project structure if you intend to use specific groups, rather than the "Parent floorgroup" option.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
- Select `HSB_G-LooseDelivery.mcr` from the file dialog.

### Step 2: Configure Properties
- Immediately after selection, the **Properties Palette** will appear.
- **Action**: Set up the rules for moving beams (see *Properties Panel Parameters* below).
- Once configured, close the Properties Palette to proceed.

### Step 3: Select Elements
```
Command Line: Select one or more elements
Action: Click on the Elements (walls/floors) in the model or draw a selection window.
```
- Press **Enter** to confirm selection.

### Step 4: Execution
- The script will attach to the selected elements, scan the beams inside them, and move any matching beams to the specified groups.
- Existing beams in the target groups that intersect with the new beams (by more than 85%) will be automatically deleted.

## Properties Panel Parameters

You can define up to 4 different rule sets (Loose delivery 1 through 4) to move beams to different locations simultaneously.

### Common Parameters for Loose Delivery 1-4

| Parameter | Type | Options / Default | Description |
|-----------|------|-------------------|-------------|
| **Group** (e.g., Group 1) | Dropdown | Parent floorgroup<br>Schwelle of parent floorgroup<br>[Dynamic List] | Select the destination where the identified beams should be moved.<br>- **Parent floorgroup**: Moves beams to the main group of the element.<br>- **Schwelle...**: Moves beams to the sill plate group associated with the element.<br>- **Dynamic List**: Shows any existing group in the project containing "Los" or "Loose" in its name. |
| **Beamcodes** (e.g., Beamcodes 1) | Text | Empty | Enter the beam codes to filter. Separate multiple codes with a semicolon (;).<br>Example: `STUD;BLOCK;TRIM` |

*(Note: Parameters labeled "Separator" are visual headers only and cannot be edited.)*

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Forces the script to re-scan the element. Use this if you have changed the Beam Codes or Group settings in the properties. |

## Settings Files
- No external settings files are used for this script.

## Tips
- **Updating Lists**: If you modify the element and new loose parts are generated, simply right-click the element and select **Recalculate**. The script will update the loose delivery groups accordingly.
- **Replacing Old Parts**: The script automatically deletes overlapping beams in the target group. This prevents duplicates when updating packaging lists.
- **Code Matching**: Ensure your Beam Codes are entered exactly as they appear in the Element or Beams. The check is case-sensitive based on your database settings.

## FAQ
- **Q: What does "Schwelle of parent floorgroup" mean?**
  - A: It refers to a specific group named after the floor level with the suffix "Schwelle" (e.g., if the floor is "01_GF", the target group would be "01_GFSchwelle"). This is useful for separating sill plates from the main structure.

- **Q: Can I use this to move beams to a completely new group?**
  - A: The dropdown dynamically looks for groups with "Los" or "Loose" in the name. Create a group in your project tree with one of these keywords (e.g., "DeliveryLoose") before running the script, and it will appear in the list.

- **Q: Why did some beams not move?**
  - A: Check the **Beamcodes** field. Ensure the codes of the beams you want to match are spelled correctly and separated by semicolons. If the beam code in the model does not match the list, it will remain in the original group.