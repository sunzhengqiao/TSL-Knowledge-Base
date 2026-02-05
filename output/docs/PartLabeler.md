# PartLabeler.mcr

## Overview
This script automatically assigns alphabetic labels (A, B, C...) to beams and sheets within a timber element. It groups similar parts based on user-defined criteria (such as material or dimensions) to ensure identical parts share the same mark number.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be attached to an Element in the model. |
| Paper Space | No | This script operates on model entities, not drawing views. |
| Shop Drawing | No | This prepares data in the model which can then be used in shop drawings. |

## Prerequisites
- **Required Entities**: An `Element` (e.g., a wall or floor panel) containing `GenBeam` entities (structural beams or sheeting materials).
- **Minimum beam count**: 0.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `PartLabeler.mcr`

### Step 2: Select Elements
```
Command Line: Select Elements
Action: Click on the timber element(s) (walls/floors) you wish to label and press Enter.
```
*Note: The script will automatically attach itself to each selected element.*

### Step 3: Configure Properties
```
Action: Select one of the attached elements and open the Properties Palette (Ctrl+1).
Locate the "Script" or "PartLabeler" section to adjust labeling rules.
```
You can change grouping criteria or zones here.

### Step 4: Update Labels
```
Action: Right-click on the element and select "|Update Labels|" from the context menu.
Result: The script will recalculate and write the label (e.g., "A", "B") to the "mpLabel" data map of every beam/sheet in the specified zones.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beam Criteria | text | @(posnum) | Determines how beams are grouped. Beams with identical attributes defined here (e.g., @(material), @(width)) will receive the same label. |
| Sheet Criteria | text | @(posnum) | Determines how sheets/panels are grouped. Uses the same logic as Beam Criteria but for sheeting material. |
| Zones to Label | text | (empty) | Specifies which construction zones to label. Leave blank to label all zones (-5 to 5). Enter numbers (e.g., "1, 2, 5") to target specific zones only. |
| Label Strategy | dropdown | \|Zone\| | Controls label uniqueness. <br>`|Zone|`: Labels restart at 'A' for every zone.<br>`|Element|`: Labels continue sequentially (A, B, C...) across the entire element without repeating. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| \|Update Labels\| | Triggers the script to re-scan the element, re-evaluate the grouping criteria, and apply new labels to the beams. |

## Settings Files
- None required.

## Tips
- **Grouping Logic**: To create more specific labels, add more tokens to the criteria. For example, changing `Beam Criteria` from `@(material)` to `@(material) @(length)` will ensure that beams of the same material but different lengths get different labels.
- **Data Access**: The script writes the calculated label to the `mpLabel` submap of each GenBeam. You can use this field in hsbCAD catalogs or label styles to display the mark on drawings.
- **Troubleshooting**: If labels are not appearing, check the `Zones to Label` property to ensure the beams are not outside the specified range.

## FAQ
- **Q: Why are all my beams labeled 'A'?**
  A: Your `Beam Criteria` is likely too broad. All beams currently match the defined criteria (e.g., they are all the same material). Try adding `@(length)` or `@(height)` to distinguish them.

- **Q: Can I label only the top plates of a wall?**
  A: Yes, provided your top plates are in a specific zone. Check which zone they belong to and enter that zone number (e.g., "2") into the `Zones to Label` property.

- **Q: What is the difference between '|Zone|' and '|Element|' strategies?**
  A: `|Zone|` treats every zone as an independent list (Zone 1 has parts A, B, C; Zone 2 also has parts A, B, C). `|Element|` treats the whole wall as one list (Zone 1 has A, B, C; Zone 2 continues with D, E, F).