# hsbCLT-Slot

Creates a slot machining operation on one of the main faces of a CLT (Cross-Laminated Timber) panel. This tool is used to machine rectangular slots into panel surfaces for electrical routing, hardware installation, conduit channels, or other purposes.

---

## Overview

| Property | Value |
|----------|-------|
| **Script Type** | Object (O-Type) |
| **Version** | 1.1 |
| **Release Date** | December 2, 2020 |
| **Author** | thorsten.huck@hsbcad.com |
| **HSB Reference** | HSB-9950 (compatible with version 22) |
| **Required Beams** | 0 |
| **Grip Points** | Dynamic (based on slot length) |

The hsbCLT-Slot tool creates a parametric slot cut on either face of a CLT panel. During insertion, an interactive preview (jig) displays the slot position and dimensions in real-time, allowing you to visually confirm placement before committing. The slot can be aligned to left, center, or right relative to the placement line, and can be applied to either the reference side or opposite side of the panel.

---

## Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in 3D model space to cut panel geometry |
| Paper Space | No | Not applicable for 2D layouts |
| Shop Drawing | No | Does not generate 2D drawing views directly |

---

## Prerequisites

Before using this tool:

1. A CLT panel (Sip entity) must exist in the drawing
2. The panel should be properly oriented with a defined reference side
3. Ensure you have a clear view to select start and end points for the slot

---

## Usage

### Insertion Workflow

1. **Launch the tool** via `TSLINSERT` command and select `hsbCLT-Slot.mcr`, or use the command alias if configured
2. **Dialog appears** (unless using catalog entry): Set geometry and alignment parameters, then click OK
3. **Select the panel**: Click on the CLT panel where the slot will be created
4. **Pick the start point**: Click the starting position of the slot on the panel face
5. **Pick the end point**: Use the interactive jig to define the slot length and position

### Interactive Jig Keywords

During end point selection, the command line shows:
```
Select end point [Start/Mid/End/Left/Center/Right/FlipSide]:
```

| Keyword | Action |
|---------|--------|
| **Start** | Align slot start at pick point |
| **Mid** | Center slot at pick point |
| **End** | Align slot end at pick point |
| **Left** | Offset slot to left of placement line |
| **Center** | Center slot on placement line |
| **Right** | Offset slot to right of placement line |
| **FlipSide** | Switch between Reference Side and Opposite Side |

### Visual Feedback During Jig

The interactive preview uses color coding to help you verify placement:

| Color | Meaning |
|-------|---------|
| **Brown/Orange (40)** | Slot is on the Reference Side (front face) |
| **Blue (5)** | Slot is on the Opposite Side (back face) |
| **Red (1)** | Line showing the length direction |
| **Green (3)** | Line showing the width direction |
| **Cyan (150)** | Line showing the depth direction |

A 3D box preview shows the slot dimensions in real-time as you move the cursor.

---

## Parameters

### Geometry Category

| Parameter | Type | Default | Unit | Description |
|-----------|------|---------|------|-------------|
| **Length** | PropDouble | 0 | Length | Length of the slot. Set to 0 to pick length interactively by selecting start and end points. When modified via Properties palette, the grip points automatically adjust. |
| **Width** | PropDouble | 8 | Length | Width of the slot (perpendicular to length direction). Must be greater than 0.1mm for the slot to be created. |
| **Depth** | PropDouble | 100 | Length | Depth of the slot into the panel face. Set greater than panel thickness for through-cut. Must be greater than 0.1mm. |

### Alignment Category

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Alignment** | PropString | Center | Left, Center, Right | Horizontal alignment of the slot relative to the placement line. Determines how the slot is offset perpendicular to the length direction. |
| **Face** | PropString | Reference Side | Reference Side, Opposite Side | Which face of the panel the slot is machined from. Determines the side from which the cut is made. |
| **Angle** | PropDouble | 0 | Radian | Rotation angle of the slot relative to the panel face normal. Must be between -90 and +90 degrees. The slot rotates around the width axis (Y-axis of the tool). |

### Parameter Dependencies

- **Length = 0**: The slot length is determined by the distance between the two pick points during insertion. Grip point editing is active.
- **Length > 0**: The slot uses the specified length. Moving grip points updates the Length parameter automatically.
- **Depth > Panel Thickness**: Creates a through-cut slot that penetrates completely through the panel.
- **Angle Range**: Must be strictly between -90 and +90 degrees (exclusive).

---

## Context Menu

Right-click on the slot tool instance to access these options:

| Menu Item | Description |
|-----------|-------------|
| **Flip Side** | Toggles the slot between Reference Side and Opposite Side. Equivalent to changing the Face parameter. |
| **Add Panels** | Opens a selection dialog to add additional panels. Only panels that intersect with the slot geometry will be added. Useful for applying the same slot to multiple stacked panels. |
| **Remove Panels** | Available when more than one panel is assigned. Opens a selection dialog to remove panels from the slot operation. At least one panel must remain assigned. |

**Double-click action:** Flips the slot to the opposite face (same as "Flip Side" context menu option).

---

## Behavior and Events

### Grip Point Editing

The script supports dynamic grip point editing:
- **Grip Point 0 (_PtG[0])**: Start point of the slot
- **Grip Point 1 (_PtG[1])**: End point of the slot
- **Origin (_Pt0)**: Center point of the slot

When grip points are dragged:
- The Length parameter automatically updates to reflect the new distance
- The slot preview updates in real-time
- The tool recalculates and reapplies the slot to all assigned panels

### Recalculation Triggers

The script automatically recalculates when:
- Panel geometry changes (the slot stays associated with the panel)
- Any parameter is modified via Properties palette
- Grip points are moved
- Context menu commands are executed

### Element Association

When the target panel belongs to a wall or floor Element:
- The slot tool is automatically assigned to that element group
- The slot will move and update with the element
- Copy/erase operations on the element will include the slot

### Validation and Error Handling

The script performs automatic validation:
- **Invalid panel selection**: Tool displays "Invalid reference. Tool will be deleted" and removes itself
- **Dimensions too small**: If Length, Width, or Depth is less than 0.1mm, the tool is automatically deleted
- **No panel assigned**: Tool cannot exist without at least one valid panel reference

---

## Tips

1. **Dynamic Length**: Leave the Length parameter at 0 to define the slot length by picking two points. This is useful when you need to match specific locations on the panel.

2. **Multiple Panels**: Use "Add Panels" from the context menu to apply the same slot to multiple stacked or adjacent panels. The tool automatically detects which panels intersect with the slot geometry and only adds valid candidates.

3. **Grip Point Editing**: After placement, drag the grip points to adjust the slot length. The Length parameter updates automatically when grip points are moved.

4. **Catalog Entries**: Save commonly used slot configurations as catalog entries for quick access during insertion. Access saved entries by name when inserting the tool (pass the catalog name as the execute key).

5. **Angle Rotation**: Use the Angle parameter to create angled slots (e.g., for conduit routing at an angle). The slot rotates around the width axis. Valid range is -90 to +90 degrees.

6. **Visual Verification**: The different colors (brown for reference side, blue for opposite side) help you quickly verify which face the slot will be machined from before committing.

7. **Element Association**: When the panel belongs to a wall or floor element, the slot tool is automatically associated with that element and will move/update with it.

8. **Through Cuts**: To ensure the slot goes all the way through, check your panel thickness and set the Depth slightly higher than that value.

9. **Precise Positioning**: Use the keyboard keywords (Start/Mid/End/Left/Center/Right) during jig mode for precise alignment without manual point selection.

10. **Quick Side Toggle**: Double-click the slot instance to quickly flip between Reference Side and Opposite Side without opening the Properties palette.

---

## FAQ

**Q: Why did the tool disappear after I selected a panel?**
A: The script requires a valid Panel (Sip entity). If you selected a different element type, or if the dimensions (Length, Width, or Depth) were set too small (< 0.1mm), the script will delete itself automatically.

**Q: Can I cut a slot at an angle?**
A: Yes. Use the Angle property in the Properties palette to rotate the slot relative to the panel face normal. The valid range is -90 to +90 degrees.

**Q: How do I cut the same slot in multiple stacked panels?**
A: Insert the slot on the first panel. Then, right-click the script instance and select "Add Panels" to select the other panels in the stack. Only panels that intersect with the slot geometry will be accepted.

**Q: What happens if I change the Length parameter after placement?**
A: The grip points automatically adjust to reflect the new length while maintaining the center position. The slot is recalculated and reapplied to all assigned panels.

**Q: Can I copy a slot to another location?**
A: Yes, you can copy the slot tool instance. However, the copy must still have a valid panel to cut. If the copied location does not intersect with any panel, the tool will delete itself.

**Q: What coordinate system does the slot use?**
A: The slot uses a local coordinate system where:
- X-axis: Along the length (start to end point)
- Y-axis: Along the width (perpendicular to length)
- Z-axis: Depth direction (into the panel face)

---

## Related Scripts

| Script | Purpose |
|--------|---------|
| `hsbCLT-Slot-Distribution.mcr` | Distributes multiple slots along a path or panel edge |
| `hsbCLT-Pocket.mcr` | Creates pocket cuts on CLT panels (similar but with closed profiles) |
| `hsbCLT-Cutout.mcr` | Creates through-cut openings in CLT panels |
| `hsbCLT-DrillMatrix.mcr` | Creates drilling patterns on CLT panels |
| `hsbCLT-Rabbet.mcr` | Creates rabbet/rebate cuts on panel edges |

---

## Technical Details

### Slot Tool Object

The script creates a `Slot` tool entity with the following signature:
```c
Slot slot(ptSlot, vecXT, vecYT, vecZT, dX, dWidth, dDepth, 0, nFace*nAlignment, 1);
slot.addMeToGenBeamsIntersect(_Sip);
```

Where:
- `ptSlot`: Center point of the slot
- `vecXT`: Unit vector along slot length
- `vecYT`: Unit vector along slot width
- `vecZT`: Unit vector along slot depth (into panel)
- `dX`: Slot length
- `dWidth`: Slot width
- `dDepth`: Slot depth
- `nFace*nAlignment`: Combined face and alignment factor (-1 or 1)

### Catalog Integration

The script supports catalog entries via:
- `setPropValuesFromCatalog()`: Loads saved parameter sets
- Default catalog key: `_LastInserted` for recalling previous settings
- Custom catalog entries can be created and accessed by name during insertion

### Debug Mode

Debug mode can be enabled via the `hsbTSLDebugController` MapObject:
```c
MapObject mo("hsbTSLDev", "hsbTSLDebugController");
```

When debug mode is active, additional messages are printed to the command line for troubleshooting.
