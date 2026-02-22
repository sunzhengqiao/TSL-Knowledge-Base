# hsbBeam-HalfCut

## Overview

Creates a half-cut (open-sided slot) on a beam face. The cut is applied to whichever face of the beam is most aligned with the current UCS Z-axis. Two user-picked points define the length and position of the cut along the surface, while depth, angle, and saw-kerf alignment are controlled through properties. The tool is commonly used for lap joints, housing joints, and similar timber connections where material must be removed from one face of a beam.

**Script Type**: O-Type (Object)
**Version**: 1.8 (14 May 2019)
**Keywords**: stab, halfcut, saw

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary working environment for this tool. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Model-level machining tool only. |

## Prerequisites

- At least one timber beam (GenBeam) must exist in the model.
- The UCS Z-axis should point toward the beam face where you want the cut applied. The script automatically selects the beam face whose outward normal is most aligned with the current UCS Z direction.

## Usage Steps

### Step 1: Launch the Script

Run `TSLINSERT` and select `hsbBeam-HalfCut`. A properties dialog appears where you can pre-configure depth, angle, and side, or load values from a saved catalog entry. Press OK to continue.

### Step 2: Select the Beam

```
Command Line: Select the Beam
Action: Click on the target beam. If no valid beam is selected, the script aborts
       with the message "select first a beam".
```

### Step 3: Pick the First Point

```
Command Line: Select first point
Action: Click a point on or near the beam surface to define one end of the cut.
```

### Step 4: Pick the Second Point

```
Command Line: Select second point
Action: Click a second point to define the other end. The distance between the two
       points determines the cut length. Points are projected onto the selected face.
```

The script is now inserted. The half-cut is applied to the beam face most aligned with the UCS Z-axis, and the entity appears with visual indicators showing the cut line and depth direction.

## Properties Panel Parameters

All parameters appear under the **Cut** category in the Properties Palette.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| **Depth** | Double | 70 mm | Any positive value | How deep the cut extends into the beam, measured perpendicular to the selected face. Can also be adjusted by dragging the depth grip point. |
| **Angle** | Double | 0 deg | -80 to +80 deg | Rotation angle of the cut around its length axis. Values outside this range are automatically clamped to 80 degrees. |
| **Side** | Dropdown | middle | middle / left / right | Controls how the 6 mm saw blade thickness (kerf) is aligned relative to the two picked points. See details below. |

### Side Parameter Explained

- **middle** -- The picked line sits at the center of the 6 mm kerf width. The cut is symmetric about the line.
- **left** -- The picked line sits at the left edge of the kerf. The 6 mm width extends to the right.
- **right** -- The picked line sits at the right edge of the kerf. The 6 mm width extends to the left.

This setting also affects how depth is measured, since the reference surface shifts with the kerf alignment.

## Grip Points

After insertion, three grip points are available:

| Grip | Label | Function |
|------|-------|----------|
| Grip 0 | Start Point | Drag to reposition one end of the cut along the beam face. |
| Grip 1 | End Point | Drag to reposition the other end. Moving either endpoint recalculates the midpoint and depth direction. |
| Grip 2 | Depth Handle | Drag to change the cut depth visually. If dragged past the surface plane, the cut direction flips automatically. |

All grip points are constrained to the original face plane. Moving them off-plane is not permitted.

## Right-Click Context Menu

| Menu Item | Description |
|-----------|-------------|
| **change direction of cut depth** | Reverses which side of the face the cut is applied to. Also triggered by double-clicking the entity. |

## Catalog Support

The script supports hsbCAD's catalog system. You can save parameter combinations (depth, angle, side) as named catalog entries, and recall them on future insertions. When launched via a command key, the script will try to match the key to an existing catalog name; if no match is found, it loads the last-inserted configuration.

## Copy, Mirror, and Rotate Behavior

The half-cut is linked to its parent beam and will be erased or copied together with it. When you copy, mirror, or rotate the entity:

- The operation is only valid if the cut remains on the same geometric plane after transformation.
- If a transformation moves the cut off its original plane, the script displays the warning "transformation operations like copy, move, mirror, rotate must only be performed so that the cut remains at the same plane where it is defined" and deletes itself.
- After a valid mirror operation, the angle and side properties are recalculated automatically to match the new geometry.

## Tips

- Orient your UCS Z-axis toward the desired beam face before launching the script. This determines which of the six faces receives the cut.
- Use the depth grip for quick visual adjustments instead of typing values into the Properties Palette.
- For precise lap joints, set the **Side** property to `left` or `right` so the kerf offset aligns with the mating piece.
- If the cut appears on the wrong side of the face, double-click the entity or use the context menu to flip the depth direction.

## FAQ

- **Q: The cut appeared on the wrong face. How do I fix it?**
  A: The script picks the face most aligned with the UCS Z-axis. Undo, adjust your UCS so Z points toward the correct face, then re-insert.

- **Q: I entered an angle of 90 degrees but it changed to 80. Why?**
  A: Angles beyond +/- 80 degrees are not supported. The script clamps to 80 and displays a warning.

- **Q: Can I change the saw kerf width (currently 6 mm)?**
  A: No. The kerf width is fixed at 6 mm in the script and is not exposed as a user property.

- **Q: My copy/mirror was rejected with a plane error. What happened?**
  A: The cut must stay on the same geometric plane. 3D rotations or mirrors that move the cut to a different plane are not allowed. Perform the transformation so the cut remains coplanar.
