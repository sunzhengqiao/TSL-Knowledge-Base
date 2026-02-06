# hsb_SplitBeamsByCode.mcr

## Overview
Automatically splits specific beams within selected construction elements based on intersections with other beams identified by their codes. This tool is typically used to cut studs or joists where they intersect with blocking or bracing members, ensuring proper fit-up for structural connections.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script interacts with 3D construction elements and beam geometry. |
| Paper Space | No | Script is designed for model manipulation only. |
| Shop Drawing | No | Does not interact with 2D views or layouts. |

## Prerequisites
- **Required Entities:** Construction Elements containing Beams.
- **Minimum Beam Count:** 0 (Script handles empty elements gracefully).
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SplitBeamsByCode.mcr`

### Step 2: Configure Properties
```
Command Line: Properties Palette (Ctrl+1)
Action: Define the filtering logic for the split operation.
```
- **sFilterBlocking:** Enter the Beam Codes for the beams you want to *cut* (e.g., `STUD;JOIST`). Leave empty to cut *all* beams except those defined in the Intersection filter.
- **sFilterIntersection:** Enter the Beam Codes for the beams causing the cut (e.g., `BLOCK;NAILER`).

### Step 3: Select Elements
```
Command Line: Select Elements
Action: Click on the construction elements containing the beams you wish to process.
```
Press **Enter** to confirm selection.

### Step 4: Processing
The script will automatically calculate intersections, split the target beams, and create gaps where necessary. The script instance will delete itself from the model once finished.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sFilterBlocking | String | (Empty) | **Target Codes.** List of beam codes to be split. Separate multiple codes with a semicolon. If left empty, the script splits all beams *except* those matching the Intersection codes. |
| sFilterIntersection | String | (Empty) | **Obstacle Codes.** List of beam codes that act as the "cutter." The script calculates split points where the target beams intersect with these beams. |
| dGR | Double | 0 (Derived) | **Gap Ratio.** Defines the offset distance for the gap based on the width of the intersecting beam. Usually left to 0 to allow automatic geometric calculation. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This is a "Run Once" script. It performs the operation and immediately deletes itself from the drawing. No context menu options are available after execution. |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** N/A

## Tips
- **Inverted Filtering:** If you want to cut every beam in a wall *except* for the top and bottom plates, leave `sFilterBlocking` empty and enter the plate codes (e.g., `PLATE`) into `sFilterIntersection`.
- **Clean Up:** The script automatically removes any resulting beam segments longer than 25 meters to prevent geometry errors.
- **Verification:** Since the script erases itself after running, use the AutoCAD `List` command or select the beams to verify that the splits have occurred as expected.

## FAQ
- **Q: Why did the script disappear after I selected the elements?**
  A: This is normal behavior. The script is designed to run once and then remove itself from the model, leaving only the modified beams behind.
- **Q: Nothing happened when I ran the script.**
  A: Check that the Beam Codes in your properties exactly match the codes assigned to your beams in the model. Ensure there are actual physical intersections between the "Target" beams and the "Obstacle" beams.
- **Q: Can I undo the changes?**
  A: Yes, use the standard AutoCAD `Undo` command immediately after running the script.