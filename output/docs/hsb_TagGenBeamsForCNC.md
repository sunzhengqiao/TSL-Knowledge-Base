# hsb_TagGenBeamsForCNC.mcr

## Overview
This utility script allows you to batch update manufacturing attributes for selected beams and sheets. It is primarily used to exclude elements from CNC machining, control nailing/gluing permissions, and manage MEP processing, while automatically regenerating the Beam Code string to reflect these changes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for running this script. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities**: GenBeam or Sheet elements must exist in the model.
- **Minimum beam count**: 1 (can process multiple selections in one go).
- **Required settings**: None specific to this script.

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
Action: Browse and select hsb_TagGenBeamsForCNC.mcr
```

### Step 2: Select Beams/Sheets
```
Command Line: Please select beams/sheets
Action: Click on the beams or sheets you wish to modify. Press Enter to confirm selection.
```
*Note: Once confirmed, the script will apply the properties set in the Properties Palette and then remove itself from the drawing.*

## Properties Panel Parameters

### Beam CNC Operation

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| CNC Operation | dropdown | Exclude | Determines if the element is processed by CNC machinery. "Exclude" marks the beam to be skipped. |
| Exclusion Type | dropdown | Code | Defines *how* the beam is excluded.<br>**Code**: Adds 'EXC' prefix to the name and sets "Use on Table" to NO.<br>**Tag**: Adds hidden 'NoMount' data only (keeps "Use on Table" YES).<br>**Both**: Applies both Code and Tag logic. |
| Allow Nailing | dropdown | No | Sets whether the beam is allowed to have automated nailing operations applied. Updates Token 8 of the Beam Code. |
| Allow Gluing | dropdown | No | Sets whether the beam is allowed to be processed by gluing machines. |

### Tag beams for MEP

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| MEP Operation | dropdown | Exclude | Controls inclusion in MEP (Mechanical, Electrical, Plumbing) processing. "Exclude" adds a tag to prevent automated drilling. |

### General

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Information | text | (Empty) | User-defined text description or notes. This is written to Token 10 of the Beam Code. |
| Color | number | 1 | The AutoCAD color index used to visually change the color of the selected entities in the model. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific right-click context menu items. It runs once upon insertion and deletes itself. |

## Settings Files
None

## Tips
- **Bulk Processing**: You can select multiple beams and sheets in a single selection window to apply standard settings to a whole group (e.g., all purchased beams).
- **Visual Feedback**: Use the **Color** property to change the appearance of excluded beams (e.g., change to Red) so draftsmen can easily identify them visually in the model.
- **Beam Code Regeneration**: This script automatically regenerates the Beam Code string. Ensure you understand your company's naming convention before using the "Code" exclusion type, as it changes the visible text label.

## FAQ
- **Q: What is the difference between Exclusion Type "Code" and "Tag"?**
  - **A**: "Code" modifies the visible Beam Name (adding 'EXC') and sets the production flag "Use on Table" to NO. "Tag" leaves the name visible but adds hidden data ('NoMount') that tells the machine to skip it, while keeping "Use on Table" as YES. Use "Tag" if you want the label to stay clean but still prevent machining.
- **Q: Why did the script disappear after I ran it?**
  - **A**: This is a utility script designed to run once. Once it processes your selection, it automatically erases itself to keep your drawing clean.
- **Q: How do I allow nailing on a beam I previously excluded?**
  - **A**: Run the script again, select the beam, set "CNC Operation" to "Include" (or appropriate settings), and ensure "Allow Nailing" is set to "Yes".