# NA_WALL_BLOCKING_BY_STORY

## Overview
Automates the generation of wall blocking (such as bridging, fire stops, or nailing backers) based on selected building stories or manual wall selection. It allows for up to six unique blocking configurations with varying heights, sizes, and positions within a wall.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates directly on wall elements in 3D model space. |
| Paper Space | No | Not designed for layout views or 2D drawings. |
| Shop Drawing | No | Does not generate shop drawing annotations. |

## Prerequisites
- **Required Entities**: ElementWall entities must exist in the model.
- **Group Structure**: Walls must be organized in Groups (assigned to an Equivalent Story) to use the Story selection mode.
- **Minimum Beams**: None (Script creates beams, does not require pre-existing ones).

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` → Select `NA_WALL_BLOCKING_BY_STORY.mcr`
The script will load into the drawing.

### Step 2: Configure Properties
**Action**: Select the script instance and open the **Properties Palette** (Ctrl+1).
**Action**: Set the **Story Index** property.
- If you want to select specific walls manually, leave this at `-1`.
- If you want to process an entire floor/story, select the corresponding Index number (e.g., 1 for Story 1).

### Step 3: Select Walls (Manual Mode Only)
*Skip this step if Story Index is set to a number greater than -1.*
```
Command Line: Select ElementWall(s):
Action: Click on the specific walls you want to add blocking to. Press Enter to confirm selection.
```

### Step 4: Place Text Label
```
Command Line: Give point for text:
Action: Click in the model space to define where the status text (displaying the script name and settings) will appear.
```

### Step 5: Review Generation
The script will automatically generate the blocking beams based on the default or modified configuration parameters. If you make changes later, see the Right-Click Menu options below.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Story Index** | Integer | -1 | Selects the building level (Equivalent Story) to process. Set to -1 to manually select walls. |
| **Min Length** | Length | 4" | The minimum length a piece of blocking must be. Segments shorter than this are ignored. |
| **Remove Existing** | Yes/No | Yes | If "Yes", deletes previously generated blocking beams associated with these walls before creating new ones. |
| **Amount (1-6)** | Integer | 0 | Number of rows of blocking to generate for this specific configuration group. |
| **Height Pos (1-6)** | Length | 0" | The vertical elevation (from the bottom of the wall) where the *highest* row of this group is placed. |
| **Height (1-6)** | Length | 0" | The vertical dimension (Y-axis) of the blocking board. |
| **Width (1-6)** | Length | 0" | The thickness (Z-axis) of the blocking board. |
| **Face (1-6)** | Enum | Front/Back | Placement relative to the wall centerline: Front, Back, Middle, or both Front and Back. |
| **Gap (1-6)** | Length | 0" | Clearance cut from each end of the blocking (e.g., for dimensional tolerance). |
| **Stagger (1-6)** | Enum | None | Offsets blocking in adjacent openings to align with studs for easier nailing. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Regenerate Blocking Beams** | Clears existing blocking created by this instance and runs the generation logic again. Use this after changing properties in the palette. |
| **Erase This Instance and Beams** | Removes the TSL instance and all generated blocking beams associated with it from the drawing. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external XML settings files; all configuration is managed via the Properties Palette.

## Tips
- **Story Organization**: To utilize the Story Index effectively, ensure your Element Groups are assigned the correct "Equivalent Story" mapping in your project setup.
- **Small Gaps**: If you see blocking missing in small gaps between studs, increase the **Min Length** property to a smaller value (e.g., 2").
- **Double Blocking**: Setting the **Face** property to "Front and Back" is useful for drywall backing where nailing surfaces are needed on both sides of the wall, but ensure your **Width** settings do not exceed the total wall thickness.

## FAQ
- **Q: I changed the Height properties, but the blocking didn't move.**
  - A: Changes in the Properties Palette do not update automatically. You must Right-Click the script instance and select **Regenerate Blocking Beams**.
- **Q: Why is no blocking generated?**
  - A: Check the **Amount** property; if it is set to 0, no rows will be created. Also, verify that the **Height Pos** is actually within the vertical height of your wall.
- **Q: Can I use this on curved walls?**
  - A: The script is designed for ElementWalls. While it calculates geometry based on the wall profile, complex curves might result in blocking segments that are shorter than your **Min Length** setting.
- **Q: What does "Manual Mode" (-1) do?**
  - A: It allows you to pick and choose which walls get blocking, rather than applying it to every wall in a specific Story/Index.