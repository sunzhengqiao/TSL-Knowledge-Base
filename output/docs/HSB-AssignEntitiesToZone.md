# HSB-AssignEntitiesToZone.mcr

## Overview
Assigns selected model entities (beams, parts, etc.) to a specific logical zone or group within an element. This is useful for organizing elements for transport planning, phasing, or applying specific export filters.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required. Script operates on 3D model entities. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Not applicable. |

## Prerequisites
- **Required Entities**: At least one Element and one Entity (beam, part, etc.) must exist in the drawing.
- **Minimum Beam Count**: 0.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `HSB-AssignEntitiesToZone.mcr`.

### Step 2: Configure Properties
Action: The Properties Palette (or a dialog box) will appear upon insertion. Set the desired Zone Index, Zone Character, and Exclusive mode before proceeding to the selection prompts.

### Step 3: Select Target Element
```
Command Line: |Select the element to assign entities to|, <|Enter|> to keep current element association
```
Action: Click on the specific Element you wish to assign the entities to, or press **Enter** to keep the entities assigned to their existing parent elements.

### Step 4: Select Entities
```
Command Line: |Select entities|
```
Action: Select the beams, parts, or other entities you wish to group. Press **Enter** to finalize the selection and run the assignment.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Add exclusive | dropdown | Yes | If 'Yes', the entity is removed from any other groups/zones it previously belonged to. If 'No', the entity is added to this zone while retaining previous assignments. |
| Zone index | number | 0 | The numerical ID for the zone (e.g., 0, 1, 2). Note: Inputting values greater than 5 converts them to negative indices (e.g., 6 becomes -1, 7 becomes -2). |
| Zone character | dropdown | 'E' for element tools | Defines the category context for the zone assignment. Options: 'E' (element tools), 'Z' (general items), 'T' (beam tools), 'I' (information), 'C' (construction), 'D' (dimension). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are added by this script. |

## Settings Files
- **Filename**: None detected.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Negative Indices**: To assign a negative Zone Index (e.g., -1), enter the value `6` in the Zone index field. The script converts inputs > 5 automatically (7 becomes -2, etc.).
- **Parent Override**: Use the "Select element" prompt (Step 3) to move entities from one Element to another logically without physically moving them in the model.
- **Script Behavior**: This script is "fire-and-forget." Once the calculation is complete, the script instance deletes itself from the model. Only the property changes on the entities remain.

## FAQ
- **Q: Can an entity belong to multiple zones at the same time?**
  A: Yes. Set the "Add exclusive" property to "No". This allows the entity to exist in multiple groups simultaneously.
- **Q: What happens if I select the Element itself as an entity?**
  A: The script detects this and skips the assignment to prevent logic errors. Elements cannot be assigned as zones of themselves.
- **Q: Why did the script disappear after I used it?**
  A: The script is designed to erase itself (`eraseInstance`) immediately after updating the entity properties. This is normal behavior to keep the drawing clean.