# hsbCNC.mcr

## Overview

**hsbCNC** creates CNC machining operations (saw cuts, millings, marking lines, and no-nail zones) on timber elements and wall panels. It is one of the core manufacturing tools in hsbCAD, used to define how timber components should be processed by CNC machines.

| Property | Value |
|----------|-------|
| **Script Type** | Object (O-Type) |
| **Version** | 8.6 |
| **Required Beams** | 0 |
| **Category** | Manufacturing / CNC Operations |
| **Keywords** | Element, CNC, Saw, Mill, Mark, Marker, NoNail |

**What it does:**
- Creates saw cut lines ( ElemSaw ) - angled or straight cuts
- Creates milling paths ( ElemMill ) - routing operations
- Creates marking lines ( ElemMarker ) - engraved reference lines
- Creates no-nail zones ( ElemNoNail ) - areas where fasteners should not be placed
- Supports solid body subtraction for openings and cutouts

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary environment for CNC operations on 3D elements |
| Paper Space | No | Not applicable |
| Shop Drawing | No | Manufacturing data is applied directly to 3D model |

## Prerequisites

- **Required Entities**: An existing `Element` (wall, floor, or roof) or `Sheet` must be selected
- **Minimum Beams**: 0 (Can be applied to sheets/panels without beams)
- **Zone Configuration**: The target element must have properly configured zones (material layers)

## Step-by-Step Usage Guide

### Step 1: Launch the Script
```
Command: TSLINSERT
Action: Select hsbCNC from the script list
```

### Step 2: Select Target Element
```
Command Line: Select a sheet of the desired zone or an element
Action: Click on a wall, floor, roof element, or individual sheet
```
The script will automatically detect the zone (material layer) of the selected sheet.

### Step 3: Define the Tool Path

**Option A: Draw Points Manually**
```
Command Line: Pick start point <Enter> to select defining entity
Action: Click points in sequence to define the path
        Press Enter when done
```
- Click the start point
- Click additional points to create the path
- Press Enter to finish

**Option B: Select Existing Geometry**
```
Command Line: Select a defining Entity (Beam, Polyline, Circle, Window, Door or Opening)
Action: Click an existing entity in the model
```
Supported defining entities:
- Polyline (EntPLine)
- Circle (converted to polyline automatically)
- Opening (window/door)
- Beam (creates tool path from beam intersection)
- Sheet (uses sheet envelope as contour)
- Another TSL script (if it publishes a `plCNC` polyline)

### Step 4: Configure Parameters in Properties Palette

Select the script instance and press **Ctrl+1** to open the Properties Palette (OPM).

---

## Properties Panel Parameters

### Tool Settings (Category: Tool)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **(A) Tool** | Selection | Saw | **Tool Type**. Options: Saw, Milling, No Nailing Zone, Marker |
| **(B) Zone** | Integer | varies | **Target Zone**. Specifies which material layer to machine. Use 99 for outermost positive zone, -99 for outermost negative zone, or specific zone index (-5 to 5) |
| **(C) Solid Operation** | Selection | no Operation | **Body Subtraction Mode**. Options: no Operation, no Operation with Nonail area, Solid Operation, Solid Operation with Nonail area |
| **(D) Depth** | Double | 0.0 | **Cut Depth**. 0 = full zone thickness, negative value = zone thickness + absolute value (extends deeper), positive value = specific depth |
| **(D1) Clear tool diameter** | Double | 0.0 | **Pocketing Diameter**. For milling operations with closed contours, defines tool diameter for clearing entire area. Only active when diameter > 0 |

### Machining Settings (Category: Machining)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **(F) Side** | Selection | Left | **Tool Side Offset**. Options: Left, Right, Center, Automatic. Determines which side of the path the tool cuts. Automatic detects based on defining geometry |
| **(G) Turning direction** | Selection | Against course | **CNC Router Direction**. Against course = conventional milling, With course = climb milling |
| **(H) Overshoot** | Selection | No | **Extend Cut**. Yes = extend cut slightly beyond endpoints for cleaner cuts |
| **(I) Tooling index** | Integer | 0 | **Tool Number**. CNC machine tool reference number for tool changes |
| **(J) Angle** | Double | 0.0 | **Saw Blade Angle**. Tilt angle in degrees (-89 to 89). Only applicable for Saw tool type |

### Offset Settings (Category: Offsets)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **(K) -X-Axis** | Double | 0.0 | **Negative X Offset**. Shrinks/expands contour on negative X side |
| **(L) X-Axis** | Double | 0.0 | **Positive X Offset**. Shrinks/expands contour on positive X side |
| **(M) -Y-Axis** | Double | 0.0 | **Negative Y Offset**. Shrinks/expands contour on negative Y side |
| **(N) Y-Axis** | Double | 0.0 | **Positive Y Offset**. Shrinks/expands contour on positive Y side |

**Note:** Offsets only apply when tool is defined by an entity (beam, opening, polyline), not when using grip points.

### Description Settings (Category: Description)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **(O) Text** | String | "" | **Label Text**. Annotation displayed at tool location. Supports variables: @(Width), @(Height), @(Cross Section), @(Name) |
| **(P) Text Height** | Double | 0.0 | **Label Size**. Visual height of text in model units. 0 = default size |

### Relation Settings (Category: Relation)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **(E) Relation** | Selection | Standard | **Zone Relationship**. Standard = fixed zone, Relative = zone follows parent orientation, Exclusive = tool only valid on specified zone |

---

## Right-Click Context Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add points** | Add additional grip points to manually drawn path (only in grip mode) |
| **Delete points** | Remove grip points from path (only in grip mode) |
| **Swap Direction** | Reverse the direction of the tool path (Start Point becomes End Point) |
| **Flip Side** | Toggle between Left and Right side offset (Saw and Milling only) |
| **Snap to edge** | Automatically align start/end points to zone contour edges |
| **Do not snap to edge** | Disable edge snapping |
| **Clear tooling** | Calculate offset passes to mill out entire closed contour area (pocketing). Prompts for tool diameter. Only available for Milling with closed contours |
| **Change Body Mode** | (Beam dependency only) Change how beam body is calculated: 0=envelope with cuts, 1=extrusion profile, 2=envelope only, 3=real body |
| **Edit in place** | Convert entity dependency to grip points for manual editing |
| **Assign defining object** | Change the defining entity (beam, opening, polyline, etc.) |

---

## Tool Type Details

### 1. Saw (ElemSaw)
Creates straight or angled saw cut lines.

**Applicable Parameters:**
- Depth, Angle, Side, Turning direction, Overshoot, Tooling index
- Solid Operation for creating cutouts

**Use Cases:**
- Wall panel cuts
- Angled bevel cuts
- Window/door opening cuts

### 2. Milling (ElemMill)
Creates router/milling paths along the defined contour.

**Applicable Parameters:**
- Depth, Side, Turning direction, Overshoot, Tooling index
- Clear tooling for pocketing operations
- Solid Operation for creating pockets

**Use Cases:**
- Routing channels
- Creating pockets/recesses
- Surface milling

### 3. No Nailing Zone (ElemNoNail)
Defines areas where nails/fasteners should not be placed.

**Applicable Parameters:**
- Zone, Relation, Offsets
- (Depth, Angle, Side are disabled)

**Use Cases:**
- Marking areas for mechanical connections
- Protecting service penetrations
- Defining zones for special fasteners

### 4. Marker (ElemMarker)
Creates engraved marking lines for reference.

**Applicable Parameters:**
- Zone, Tooling index
- (Depth, Angle, Side, Turning direction, Overshoot are disabled)

**Use Cases:**
- Alignment marks
- Reference lines
- Assembly markings

---

## Special Features

### Zone Selection
- **99**: Outermost positive zone (exterior side)
- **-99**: Outermost negative zone (interior side)
- **1-5**: Specific positive zones (from exterior)
- **-1 to -5**: Specific negative zones (from interior)

### Depth Behavior
- **0**: Full zone thickness (cuts through entire layer)
- **Positive value**: Specific depth (partial cut)
- **Negative value**: Zone thickness + absolute value (extends into underlying zones)

### Clear Tooling (Pocketing)
When using Milling with a closed contour:
1. Set Clear tool diameter to your router bit size
2. Right-click > Clear tooling
3. Script calculates offset passes until entire area is milled
4. Useful for creating rectangular or circular pockets

### Double-Click Action
Double-clicking the script instance toggles the Side parameter (Left <-> Right).

---

## Workflow Examples

### Creating a Window Cutout
1. Insert hsbCNC on wall element
2. Select window opening as defining entity
3. Set Tool = Saw
4. Set Depth = 0 (full thickness)
5. Set Solid Operation = "Solid Operation"
6. Tool path automatically matches window shape

### Creating a Milling Pocket
1. Insert hsbCNC on panel
2. Draw rectangular path with grip points
3. Set Tool = Milling
4. Set Depth = desired pocket depth
5. Set Clear tool diameter = router bit size
6. Right-click > Clear tooling

### Creating a No-Nail Zone Around a Beam
1. Insert hsbCNC on wall
2. Select intersecting beam as defining entity
3. Set Tool = No Nailing Zone
4. Zone automatically covers beam intersection area

---

## Tips and Best Practices

1. **Use Automatic Side Detection**: When using entity-defined paths, set Side to "Automatic" to let the script determine the correct side based on geometry.

2. **Zone Thickness Visibility**: The tool is displayed in the color of the target zone for easy identification.

3. **Catalog Support**: hsbCNC supports catalog-based presets. Create catalog entries with pre-configured parameters for common operations.

4. **Multiple Tool Lines**: If a defining contour crosses multiple zone rings (e.g., around openings), the script automatically creates multiple tool segments.

5. **Snap to Edge**: For grip-based paths, use "Snap to edge" to automatically align endpoints to the zone contour - useful for cuts that should end exactly at panel edges.

6. **Dynamic Labels**: Use variables in the Text field:
   - `@(Width)` - displays contour width
   - `@(Height)` - displays contour height
   - `@(Cross Section)` - displays beam dimensions (if beam-dependent)
   - `@(Name)` - displays linked beam name

7. **Exclusive Zone Relation**: Use "Exclusive" relation when the tool should only exist on a specific zone - prevents accidental application to wrong side of wall.

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Beam is not intersecting zone" | The defining beam does not cross the selected zone. Verify beam position and zone index. |
| "Beams which are perpendicular aligned to the Z-axis are not supported" | The beam is parallel to the zone plane. Use a different defining entity or grip points. |
| "Tool will be deleted" on insertion | No valid element or defining entity was selected. Ensure you click on a valid hsbCAD element. |
| Angle parameter is greyed out | Angle is only available for Saw tool type. Switch tool type to enable. |
| Clear tooling not available | Requires Milling tool with closed contour and depth less than zone thickness. |
| Tool segments outside zone are missing | This is expected behavior - only segments within the zone contour are created. |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 8.6 | 10/09/2024 | Added "Clear tool diameter" property for pocketing |
| 8.5 | 09/02/2023 | Bugfixes for arced segments and polyline-in-zone detection |
| 8.4 | 10/01/2023 | Improved circle detection |
| 8.3 | 26/10/2022 | Improved contour test (accepts multiple self-intersecting rings) |
| 8.2 | 19/10/2022 | Fixed intersection point failing when line parallel with plane |
| 8.1 | 01/07/2022 | Added zone description explaining 99 and -99 values |
| 8.0 | 20/09/2021 | TSL selection as defining entity supported (if defining contour published as plCNC) |

---

## Related Scripts

- **hsbCNC-Line**: Legacy predecessor (deprecated)
- **hsbOpening**: For creating window/door openings
- **hsbBeam**: For structural timber members
- **Nail-Distribution**: For fastener patterns (respects No-Nail zones)
- **sd_WallShopDrawing**: Shop drawings that display CNC operations

---

## Technical Notes

- The script uses `ElemSaw`, `ElemMill`, `ElemMarker`, and `ElemNoNail` tool classes
- Tool paths are projected to the zone plane if not coplanar
- Arc segments are approximated when projected to non-parallel planes
- The script validates against the zone contour and removes segments outside the valid area
- For beam dependencies, the intersection profile is calculated using the beam's body and the zone plane
