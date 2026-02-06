# hsbMatchProperties.mcr

## Overview
This utility script allows you to copy specific properties from a "source" timber element (Beam, Sheet, or Sip) to multiple "target" elements. It is useful for standardizing attributes like material, grade, labels, and layer settings across a selection of elements without recreating geometry.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates only on 3D physical elements. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: At least one source element (Beam, Sheet, or Sip) and one or more target elements of the same type.
- **Minimum Beam Count**: 1 (Source).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbMatchProperties.mcr`

### Step 2: Configure Properties (AutoCAD Properties Palette)
After inserting the script, the AutoCAD Properties Palette will display a list of available properties. Set the ones you wish to copy to **Yes**.
```
Action: Toggle properties (e.g., Material, Grade, Color) to "Yes" as needed.
```

### Step 3: Select Source Entity
```
Command Line: Select source entity
Action: Click on the single timber element that has the properties you want to copy.
```

### Step 4: Select Target Entities
```
Command Line: Select beams (or Select sheets / Select sip)
Action: Select all the elements you want to update. Press Enter to confirm selection.
Note: The prompt changes based on the type of source element selected.
```

### Step 5: Completion
The script applies the properties and automatically removes itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Color | Dropdown | No | If Yes, copies the display color (layer color override) of the source entity. |
| Label | Dropdown | No | If Yes, copies the main Label (piece mark/position number). |
| SubLabel | Dropdown | No | If Yes, copies the SubLabel (secondary piece mark). |
| SubLabel2 | Dropdown | No | If Yes, copies the SubLabel2 (tertiary identifier). |
| Grade | Dropdown | No | If Yes, copies the timber strength grade (e.g., C24). |
| Information | Dropdown | No | If Yes, copies the Information field (free text comments). |
| Material | Dropdown | No | If Yes, copies the material definition (e.g., Spruce). |
| Name | Dropdown | No | If Yes, copies the entity Name property. |
| Beamtype | Dropdown | No | If Yes, copies the Beamtype classification. |
| Isotropic | Dropdown | No | If Yes, copies the material isotropy setting. |
| hsbId | Dropdown | No | If Yes, copies the internal hsbCAD ID. **Warning: This can cause database conflicts.** |
| Group | Dropdown | No | If Yes, copies group assignments. |
| Module | Dropdown | No | If Yes, copies the Element Module assignment. |
| Zone | Dropdown | No | If Yes, copies the Zone assignment (e.g., fire zone). |
| Transparency | Dropdown | No | If Yes, copies the display transparency percentage. |
| RenderMaterial | Dropdown | No | If Yes, copies the render material assignment. |
| LineWeight | Dropdown | No | If Yes, copies the line weight setting. |
| Notes | Dropdown | No | If Yes, copies notes attached to the element. |
| PropertySets | Dropdown | No | If Yes, copies user-defined Property Sets. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script runs immediately upon insertion and deletes itself afterwards; no persistent context menu options are available. |

## Settings Files
- None.

## Tips
- **Type Matching**: You can only copy properties from a Beam to Beams, or a Sheet to Sheets. You cannot copy from a Beam to a Sheet.
- **Avoid ID Conflicts**: Keep the **hsbId** parameter set to **No** unless you specifically intend to clone the ID, which is rarely recommended and can lead to data corruption.
- **Visual Updates**: Use the **Color** and **Transparency** options to quickly match visual styles for presentation models.

## FAQ
- **Q: Why did the script disappear after I used it?**
  - A: This is a "command" script that performs an action and then erases itself (`eraseInstance`). This keeps your drawing clean.
- **Q: Can I use this to change dimensions?**
  - A: No, this script copies data properties (attributes). It does not modify physical geometry (width/height/thickness) of the target elements.