# ViewportLabels

## Overview

ViewportLabels automatically generates text labels for entities (beams, sheets, TSL instances, or openings) within a Paper Space viewport. Labels are dynamically positioned with optional leader lines and support format strings to display entity properties. The script includes intelligent collision detection to prevent label overlap and provides flexible grip-based positioning with static/dynamic modes.

## Usage Environment

| Environment | Supported |
|------------|-----------|
| **Model Space** | No |
| **Paper Space** | Yes (displays labels in viewports) |
| **Script Type** | Object (Type O) - Annotation generator |
| **User Interaction** | High (viewport selection, formatting, filtering) |

## Prerequisites

- **Paper Space Layout** with at least one viewport
- **Element** assigned to the viewport (wall, floor, roof, etc.)
- **Target Entities** in Model Space:
  - GenBeams, Beams, or Sheets
  - TslInst instances
  - Opening entities
- **Optional**: PainterDefinition filters for selective labeling

## Usage Steps

### Initial Setup

1. **Start Script**: Run ViewportLabels command in Paper Space
2. **Select Viewport**: Click on the viewport to annotate
3. **Configure Settings** (dialog appears):
   - **Dimstyle**: Select text dimension style
   - **Text Height Override**: Set custom height (0 = use dimstyle default)
   - **Show Leader**: Yes/No - draw leader lines to entities
   - **Entity Type**: GenBeam, Beam, Sheet, TslInst, or Opening
   - **Label Format**: Format string (e.g., `@(mpLabel.stLabel)`)
   - **Include/Exclude Filters**: Optional PainterDefinition names
4. **Confirm Dialog**: Labels appear automatically

### Label Positioning

- **Initial Placement**: Labels appear at entity centers (transformed to Paper Space)
- **Dynamic Mode** (default): Labels maintain offset from entity center as entities move
- **Static Mode**: Labels stay at fixed Paper Space coordinates

### Adjusting Labels

1. **Move Individual Label**:
   - Click the label's grip point
   - Drag to new position
   - Release to confirm
2. **Switch to Static Mode**:
   - Right-click → **Set grip static**
   - Select the label grip
   - Label now stays at fixed position even if entity moves
3. **Switch to Dynamic Mode**:
   - Right-click → **Set grip dynamic**
   - Select the label grip
   - Label now follows entity with recorded offset
4. **Reset Overlapping Labels**:
   - Right-click → **Adjust Label Overlap**
   - Script automatically repositions labels to avoid collisions

## Properties Panel Parameters

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Dimstyle** | Dropdown | (active style) | AutoCAD dimension style for text formatting |
| **Text Height Override** | Double | 0 | Custom text height in Paper Space units (0 = use dimstyle height) |
| **Show Leader** | Dropdown | "No" | Display leader lines from labels to entity centers: "Yes" or "No" |
| **Zones to Report** | String | "0" | Comma-separated zone indices to include (e.g., "0,1,2") |
| **Label Color** | Integer | -1 | AutoCAD color index override (-1 = use layer color) |
| **Entity Type** | Dropdown | "GenBeam" | Type of entities to label (read-only after first insertion) |
| **Label Format** | String | `@(mpLabel.stLabel)` | Format string defining label text content |
| **Include Filter** | Dropdown | "None" | PainterDefinition name - only label matching entities |
| **Exclude Filter** | Dropdown | "None" | PainterDefinition name - exclude matching entities |

**Note**: **Entity Type** becomes read-only after the first dialog to prevent accidental type changes that would invalidate existing labels.

## Right-Click Menu

| Command | Function |
|---------|----------|
| **Set grip static** | Click to select a label grip and convert it to static (fixed) positioning |
| **Set grip dynamic** | Click to select a label grip and convert it to dynamic (offset-based) positioning |
| **Set grips for current element to static** | Convert all labels in current element/viewport to static mode |
| **Set grips for current element to dynamic** | Convert all labels in current element/viewport to dynamic mode |
| **Reset grips for current element** | Clear all stored grip positions for current viewport - labels reset to entity centers |
| **Reset grips for all elements** | Clear all stored grip positions across all viewports/elements |
| **Adjust Label Overlap** | Run collision detection to automatically reposition overlapping labels |
| **----------------------------** | *(Separator)* |

## Settings Files

This script does not use external XML settings. Label positions are stored internally in the script's Map system under `GripsAll` key, organized by Element handle.

### Grip Storage Format

Each grip is stored with this naming convention:
```
[EntityHandle]@[IsStatic]@[OriginalX];[OriginalY];[OriginalZ]
```

Example:
- `"ABC123@0@1500.5;2000.0;0.0"` - Dynamic grip for entity ABC123 at original position (1500.5, 2000.0, 0.0)
- `"DEF456@1"` - Static grip for entity DEF456 (no offset needed)

## Tips

- **Format Strings**: Use entity properties in labels:
  - `@(mpLabel.stLabel)` - Entity label
  - `@(mpLabel.stPosNum)` - Position number
  - Custom properties via `@(mpLabel.PropertyName)`
- **Collision Detection**:
  - Automatically runs on first insertion
  - Manually trigger with **Adjust Label Overlap** command
  - Runs when switching **Show Leader** to "Yes"
- **Zone Filtering**: Use **Zones to Report** to label specific zones only (e.g., "1,3,5")
- **PainterDefinitions**: Create filters to label only specific beam types, materials, or custom groups
- **Performance**: For large elements with hundreds of entities, use Include/Exclude filters to reduce label count
- **Leader Lines**: Leaders draw from label perimeter (circular boundary around text) to entity center

## FAQ

### Why aren't my labels appearing?

Check the following:
1. **Viewport has Element assigned**: Use `_HSBINSERTVIEWPORT` or assign Element in viewport properties
2. **Zones to Report** includes the target zone (default "0")
3. **Entity Type** matches your target entities
4. **Include/Exclude Filters** aren't blocking all entities
5. Console message: "No entities to label" indicates filtering issue

### What does "Dynamic" vs "Static" grip mode mean?

- **Dynamic**: Label maintains its offset vector from the entity center. If the beam moves, the label moves with it
- **Static**: Label stays at a fixed Paper Space coordinate regardless of entity movement
- **Default**: All labels start as dynamic

### How does collision detection work?

The script:
1. Creates bounding boxes around each label (text width × height)
2. Checks for overlapping boxes
3. Groups overlapping labels
4. Calculates the group center
5. Pushes each label away from center along its offset vector
6. Repeats up to 5 iterations until no overlaps remain

### Can I filter labels by beam material or size?

Yes! Create a PainterDefinition filter:
1. In hsbCAD, open Painter Definitions
2. Create a filter for your criteria (e.g., "Timber Type = LVL")
3. Save with a name (e.g., "LVL Beams Only")
4. Set **Include Filter** property to "LVL Beams Only"

### Why do some labels show "N/A"?

The format string contains a property that doesn't exist on that entity. Common causes:
- Entity missing the referenced Map property
- Format string contains `@` symbol that couldn't be resolved
- Check entity properties and adjust format string

### How do I reset all labels to default positions?

Right-click → **Reset grips for current element** (one viewport) or **Reset grips for all elements** (entire drawing).

### Can I label entities in multiple viewports with one script?

No. Each ViewportLabels instance is tied to one viewport. Insert separate instances for each viewport you want to annotate.

### What happens if I change the Element assigned to the viewport?

The script tracks labels by Element handle. Changing the Element will cause the script to:
- Lose previously stored grip positions
- Generate new labels for the new Element's entities

### Why are leader lines not drawing correctly?

Leaders draw from the circular boundary around the label to the entity center. If leaders appear incorrect:
- Verify **Show Leader** is set to "Yes"
- Check that entity center calculation is correct for the entity type
- Try running **Adjust Label Overlap** to recalculate positions

### Can I change the Entity Type after insertion?

No. The **Entity Type** property becomes read-only after the first dialog to prevent data corruption. To label a different entity type, insert a new instance of ViewportLabels.

### How do I export label positions for documentation?

Label positions are stored in the script's internal Map. To extract:
1. Use TSL debugging to inspect `_Map.getMap("GripsAll")`
2. Or write a custom export script to read and format the grip data

### What is the maximum number of labels this script can handle?

Tested with hundreds of labels per element. Performance depends on:
- Collision detection complexity (more overlaps = slower)
- Number of filter checks
- Paper Space zoom level and regen frequency
