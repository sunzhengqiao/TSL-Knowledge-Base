# HSB_E-ElementLinker

## Overview
This script logically links and groups multiple secondary elements to a primary "main" element. It is designed for data association and logistical grouping, allowing you to define assemblies (like studs or sub-beams) attached to a master element (like a wall or primary beam) for export or tracking purposes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in the 3D model environment. |
| Paper Space | No | Not supported for 2D layouts. |
| Shop Drawing | No | Not intended for production drawings. |

## Prerequisites
- **Required Entities**: At least one valid hsbCAD Element (Wall, Beam, etc.) to act as the parent.
- **Minimum Beams**: 1 (The Main Element).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-ElementLinker.mcr` from the catalog.

### Step 2: Select Main Element
```
Command Line: Select the main element
Action: Click on the primary element (Parent) you wish to use as the anchor for the group.
```

### Step 3: Select Sub Elements
```
Command Line: Select one or more elements
Action: Select all the secondary elements (Children) you want to associate with the main element. 
        Press Enter or Space to confirm the selection.
```

### Step 4: Completion
The script will generate a visual anchor symbol and a numbered list on the `DEFPOINTS` layer at the main element's origin to indicate the link has been created.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose editable parameters in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add subelements** | Prompts you to select additional elements in the model to append to the existing link group. |
| **Remove subelements** | Prompts you to select elements currently in the group to remove them from the link. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Non-Printing Visuals**: The script draws the link symbol and text on the `DEFPOINTS` layer. This ensures the visual indicators are visible on screen but will not plot on your drawings.
- **Data Storage**: The link data is stored directly inside the Main Element's attributes (SubMap). This means the relationship survives model regeneration.
- **Error Handling**: The script automatically prevents you from linking an element to itself or adding duplicate elements to the same group.

## FAQ
- **Q: Can I add more elements to a group after I have already created the link?**
  - A: Yes. Select the script instance in the model, right-click, and choose "Add subelements" from the context menu.
- **Q: What happens if I delete the main element?**
  - A: Since the script instance relies on the main element for its coordinate system and data storage, deleting the main element will likely result in errors or the script instance being deleted/invalidated.
- **Q: Why didn't the script link an element I selected?**
  - A: The script silently ignores selections if the chosen element is the Main Element itself or if it is already part of the linked group.