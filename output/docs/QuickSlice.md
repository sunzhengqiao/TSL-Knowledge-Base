# QuickSlice.mcr

## Overview
Creates a dynamic, user-adjustable cross-section slice through selected timber elements to visualize intersections and clearances. It allows you to generate static layout lines from the section geometry.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D coordinate input and slicing. |
| Paper Space | No | Not designed for 2D layouts. |
| Shop Drawing | No | This is a modeling utility. |

## Prerequisites
- Select one or more timber entities (beams or bodies) to slice.
- Script must be run in 3D Model Space.
- No specific settings files are required.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `QuickSlice.mcr`

### Step 2: Select Entities
```
Command Line: Select Entities
Action: Click on the beams or elements you want to slice. Press Enter to confirm selection.
```

### Step 3: Define Anchor Point
```
Command Line: Select start point
Action: Click in the model to set the fixed origin point where the slicing plane will pass through.
```

### Step 4: Define Direction
```
Command Line: Select next point
Action: Click to define the direction of the slice.
Note: If you only want a vertical slice, you can stop here by pressing Esc or Enter.
```

### Step 5: (Optional) Define Tilt
```
Command Line: Select next point
Action: If you need a non-vertical (angled) slice, click a third point to define the tilt/pitch.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Color | Number | 4 | Sets the display color index (0-255) of the slice lines and visual indicators. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Lock Vertical plane | Forces the slicing plane to be perfectly vertical (perpendicular to the World Z-axis). Useful for standard cross-sections. |
| Commit Lines | Converts the current dynamic slice into static polylines (placed on the 'DEFPOINTS' layer) and removes the script instance. |

## Settings Files
None required.

## Tips
- **Grip Editing:** After insertion, use the visible grips to adjust the slice dynamically.
    - **Anchor Grip (Circle):** Moves the slice location without changing rotation.
    - **Direction Grip 1:** Rotates the slice around the anchor.
    - **Direction Grip 2:** Adjusts the tilt/pitch (only available if vertical lock is off).
- **Visualizing Intersections:** Use this tool to check how complex roof planes or wall connections meet before detailing.
- **Finalizing Geometry:** Remember to use "Commit Lines" if you want the slice to remain in the drawing as permanent geometry; otherwise, deleting the script instance will remove the slice.

## FAQ
- **Q: Can I slice through multiple beams at once?**
  - A: Yes, select all relevant beams during the initial "Select Entities" prompt.
- **Q: Why can't I tilt my slice?**
  - A: Check if "Lock Vertical plane" is active in the right-click menu. If locked, you can only rotate the slice vertically.
- **Q: Where do the committed lines go?**
  - A: When you use "Commit Lines," the resulting polylines are created on the `DEFPOINTS` layer.