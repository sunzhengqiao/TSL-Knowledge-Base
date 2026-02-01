# GE_OPENING_GARAGE_POST.mcr

## Overview
This script automates the generation of timber framing posts (king studs, jack studs, and trimmers) for garage openings defined as Stickframe types. It calculates dimensions and creates the necessary structural elements based on the selected opening and default material settings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment to generate beams. |
| Paper Space | No | Not intended for 2D layout or detailing. |
| Shop Drawing | No | This is a modeling script, not a drawing generator. |

## Prerequisites
- **Required Entities**:
  - An existing Stickframe Opening (`OpeningSF`).
  - A parent Wall (`ElementWall`) containing the opening.
- **Minimum Beam Count**: 0 (This script creates new beams).
- **Required Settings**:
  - Lumber Inventory defaults (configured via `hsbFramingDefaultsEditor`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_OPENING_GARAGE_POST.mcr`

### Step 2: Select Garage Opening
```
Command Line: Select Garage Opening instance:
Action: Click on the desired garage opening (Stickframe type) in the drawing.
```

### Step 3: Adjust Properties (Optional)
```
Action: Select the generated script instance and open the Properties palette (Ctrl+1) to adjust parameters like post splitting or coloring.
```
*Note: The script automatically recalculates when properties are changed.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Split Head Post | Yes/No | No | Determines whether the head post is split into two segments. |
| Mid Post Length | Number | Calculated | Sets the length of the middle post. If split is 'Yes', it contacts the opening top; if 'No', it matches the head post height. |
| Color on Beams | Integer | 32 | Determines the display color of the generated framing beams. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Forces the script to regenerate the beams based on current geometry and properties. (Note: This often triggers automatically when properties change). |

## Settings Files
- **System**: `hsbFramingDefaults.Inventory.dll`
- **Purpose**: This configuration ensures the correct beam material, grade, and dimensions are applied without requiring manual text entry in the script properties.

## Tips
- **Auto-Recalculation**: You do not need to manually run the recalculate command every time you change a property; the script is designed to update automatically.
- **Head Post Configuration**: Use the "Split Head Post" property to control how the vertical framing interacts with the header or top of the opening.
- **Material Management**: Keep your Lumber Inventory defaults up to date, as the script pulls beam data directly from there rather than individual script properties.

## FAQ
- Q: Why does the script not appear to do anything when I insert it?
  A: Ensure you are selecting a valid **Stickframe Opening (`OpeningSF`)**. Standard generic openings may not be recognized.
- Q: How do I change the wood material for the posts?
  A: The material is controlled by your global `hsbFramingDefaults` settings. Update the inventory defaults rather than looking for a material property in the script instance.
- Q: What happens if I delete the opening?
  A: The script relies on the geometry of the opening. If the opening is deleted or modified drastically, the script may error or require re-insertion.