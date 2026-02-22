# hsbBlocking

Creates blocking (noggin) members between rafters in roof constructions, with automatic groove/housing machining at rafter connections.

---

## Overview

The **hsbBlocking** script generates blocking boards (Stellbretter) between rafters based on a reference wall or plate (purlin). It automatically:

- Creates properly sized and positioned blocking beams between selected rafters
- Machines grooves (housings) in the rafters to receive the blocking
- Optionally stretches sheeting zones to meet the blocking (wall reference only)
- Supports optional kerve (notch) machining at sheet zones (wall reference only)
- Handles hip rafter intersections with specialized beamcut logic

The script operates in three internal modes:
1. **Distribution mode (mode 0)**: The main insertion mode. Creates blocking beams, distributes groove child instances to each rafter, and optionally creates kerve child instances.
2. **Tooling mode (mode 1)**: Child instance that applies the groove/housing to an individual rafter. Visible in the Properties Palette with OPM key "Groove".
3. **Kerve mode (mode 2)**: Child instance that applies kerve (notch) machining at sheet zones on a rafter. Visible with OPM key "Kerve".

### Reference Modes

| Mode | Reference Object | Outside Detection | Notes |
|------|-----------------|-------------------|-------|
| Wall-based | ElementWall | Outside face of wall (can be overridden via settings file) | Full parameter set available |
| Beam-based | Plate or purlin beam | Automatic ridge/eaves detection, or manual override | Alignment detection, sheeting zone, and kerve parameters are read-only |

---

## Environment

| Property | Value |
|----------|-------|
| Type | O (Object) |
| Space | Model Space |
| Beams Required | 0 (selected during insertion) |
| Script Version | 1.22 |
| Keywords | Blocking; Roof; Wall; Abbund |

---

## Prerequisites

Before using this script, ensure:

1. **Roof structure exists** with a valid ERoofPlane containing the target rafters
2. **Reference object available**: either an ElementWall or a plate/purlin beam
3. **At least 2 rafters** associated with the roof plane
4. The reference wall or plate must **not run parallel** to the projected rafter direction

---

## Usage

### Insertion Workflow

1. Launch the script via TSLINSERT or the TSL menu
2. **Select reference object(s)**: choose one or more walls or plate beams
   - For walls: select ElementWall objects (pure AutoCAD walls are rejected with a message)
   - For plates: select beams that are not dummies and not rafter types
   - Duplicate colinear walls on the same side are automatically removed
3. **Select rafters**: pick the rafters between which blocking will be placed (minimum 2)
4. **Configure parameters**: a dialog appears (or catalog preset is applied silently)
   - When walls are selected: alignment detection is read-only
   - When beams are selected: bottom offset reference, sheeting zone, modify sheeting, kerve, gap X/Y, and gap sheet are read-only
5. **Confirm**: the script creates blocking beams between each pair of adjacent rafters, distributes groove child instances to the rafters, and optionally distributes kerve child instances

### After Insertion

- Select a **groove marker** (child instance) to modify groove parameters via the Properties Palette (OPM key: "Groove")
- Select a **kerve marker** (child instance) to modify kerve parameters (OPM key: "Kerve")
- Right-click context menu on groove instances provides "Load Settings" and "Write Settings" options

---

## Parameters

### Geometry

| Parameter | Default | Description |
|-----------|---------|-------------|
| A - Thickness | 32 mm | Thickness of the blocking board |
| B - Height | 0 (Auto) | Raw height of blocking board before cutting. 0 = automatically calculated from rafter depth to roof plane |

### Roofplane Offsets

| Parameter | Default | Description |
|-----------|---------|-------------|
| C - Top | 1 mm | Perpendicular offset from the roof plane surface |
| D - Bottom | 0 mm | Perpendicular offset from the bottom face of the rafter (wall reference only) |
| E - Bottom offset reference | Outside edge of wall | Whether bottom offset refers to the wall's outside edge or to the blocking beam's bottom edge. Automatically set to blocking beam if horizontal offset exceeds the blocking thickness |

### Alignment

| Parameter | Default | Description |
|-----------|---------|-------------|
| F - Alignment | perpendicular to WCS | Blocking orientation: perpendicular to World Coordinate System, or perpendicular to roof plane |
| G - Horizontal Offset Blocking | 0 mm | Offset from the outer side of the reference object. Calculated horizontally even for aligned blockings |
| H - Alignment detection | Automatic | Ridge/eaves situation detection: Automatic uses lower half of roof for eaves, upper half for ridge (beam reference only) |

### Blocking Groove

These parameters appear both on the main dialog during insertion and on each groove child instance in the Properties Palette.

| Parameter | Default | Description |
|-----------|---------|-------------|
| I - Depth | 6 mm | Groove depth cut into the rafter |
| J - Gap Depth | 1 mm | Gap allowance added to groove depth |
| K - Width | 0 (Auto) | Groove width. 0 = matches blocking thickness |
| L - Conic Groove | 0 mm | Additional depth for a tapered/conic groove shape |
| M - Start height of conic groove | 0 mm | Bottom offset where the conic groove begins |
| Expand Groove to Plumb | No | Adds plumb housing machining for angled blockings. Creates additional beamcuts to achieve a plumb-aligned groove in the rafter |
| Maximize Groove | No | Extends groove to maximum depth in rafter (groove child instance only) |

### Element Settings

| Parameter | Default | Description |
|-----------|---------|-------------|
| N - Sheeting Zone | 0 (Auto) | Zone for sheet manipulation. 0 = auto-detect zones below or further outside |
| O - Modify sheeting zones | No | Whether to stretch sheeting to meet blocking (wall reference only) |
| O1 - Kerve | Disabled | Kerve (notch) mode at the selected zone. Options: Disabled, Outer Zone, Inner Zone, or specific zone number (-5 to 5) |
| O1a - Gap X | 0 mm | X-direction gap for kerve positioning |
| O1b - Gap Y | 0 mm | Y-direction gap for kerve positioning |
| O2 - Gap Sheet | 0 mm | Gap between bottom of blocking and top of plate/sheet |

### Attributes

| Parameter | Default | Description |
|-----------|---------|-------------|
| P - Material | Spruce | Material assigned to the blocking beam |
| Q - Grade | (empty) | Grade classification |
| R - Name | Blocking | Name assigned to blocking beams |
| S - Color | 30 | Display color index |

---

## Context Menu

When a groove child instance is selected, right-click provides:

| Menu Item | Action |
|-----------|--------|
| Load Settings | Reloads settings from the external XML configuration file |
| Write Settings | Saves current settings to the external XML configuration file and reports the file path |

Settings file location: `[WallDetail Path]\SFSettings.xml`

---

## Tips

### Best Practices

1. **Select multiple walls at once** when placing blocking along several walls for efficiency; the script creates one distribution per reference object
2. **Use Automatic alignment detection** (default) for standard roof configurations; it determines ridge vs. eaves based on position within the roof plane
3. **Leave Height at 0** for automatic calculation -- the blocking will fit precisely from the reference plane to the roof surface
4. **Adjust D - Bottom offset** if the blocking needs to clear a top plate; the script auto-adjusts this value when it detects a plate within the wall zone
5. **Use "Write Settings" once** after initial placement to create the SFSettings.xml file, then edit it with a text editor to set defaults for future drawings

### Common Issues

| Symptom | Cause | Solution |
|---------|-------|----------|
| "could not find the associated roofplane" | Selected rafters are not part of a valid ERoofPlane | Ensure the roof is properly generated with hsbCAD roof tools |
| "The element may not be parallel with the projected rafter alignment" | Wall or plate runs parallel to the rafter direction | Select a reference object that runs perpendicular to the rafters |
| "requires at least 2 rafters" | Fewer than 2 rafters selected | Select two or more rafters |
| "Walls without hsbcad data are not supported" | A pure AutoCAD wall was selected instead of an ElementWall | Use walls created by hsbCAD (ElementWall objects) |
| Blocking deletes itself | Roofplane offset settings prevent creation (top cut leaves no volume) | Reduce C - Top offset or check roof plane geometry |
| Kerve child deletes itself | Kerve set to "Disabled" | This is normal; only the kerve machining is removed. Blocking and grooves remain |

### Hip Rafter Handling

- The script ensures that the first rafter in the sorted list is a standard rafter (not a hip rafter) for correct roof plane detection
- Groove tooling at hip rafters uses a specialized beamcut approach: a shadow profile of the blocking is projected onto the hip rafter face, and beamcuts are applied accordingly
- Since version 1.22, when the blocking and rafter are not perpendicular, the tooling automatically switches to the hip-rafter beamcut method
- Kerve machining is automatically skipped for hip rafters

### Settings File (SFSettings.xml)

The script reads shared settings from `SFSettings.xml` stored in the WallDetail path. This file can configure defaults for multiple TSL scripts.

| Setting | Values | Description |
|---------|--------|-------------|
| ViewingSideExteriorWalls | 0 or 1 | Controls which side of the wall is considered "outside" (0 = opposite side, 1 = icon/vecZ side) |
| ScriptName | hsbBlocking | Identifies which script the settings apply to |
| Color | Integer | Default display color |

The settings file uses the `<Hsb_Map>` XML format with a `TslSetting[]` array. Multiple scripts can share the same file. Use "Load Settings" from the context menu to reload after editing.

---

## Related Scripts

- **hsbBlocking (Groove)** -- Child instance handling groove/housing machining on each rafter (OPM key: "Groove")
- **hsbBlocking (Kerve)** -- Child instance handling kerve machining at sheet zones (OPM key: "Kerve")
