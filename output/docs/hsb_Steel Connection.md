# hsb_Steel Connection.mcr

## Overview
Generates steel connection plates and applies corresponding timber cuts to join two beams (Male and Female). It supports end-to-end connections, perpendicular side connections, and angled front connections, including options for automatic plate sizing and bolt drilling.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script generates 3D solids and cuts. |
| Paper Space | No | Not designed for 2D drawings. |
| Shop Drawing | No | This is a model generation script. |

## Prerequisites
- **Required Entities**: At least one `GenBeam`. Typically requires two beams (Male and Female) to form a connection.
- **Minimum Beam Count**: 1 (if attaching a plate to a Post) or 2 (for standard beam-to-beam connections).
- **Required Settings**: `hsb-SubAssembly` (used for linking the plate to the construction hierarchy).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_Steel Connection.mcr`

### Step 2: Configure Properties (Initial)
Upon launch, the Properties Palette (OPM) may appear or defaults are loaded. You can adjust initial parameters like Plate Thickness or Drill Diameter now or after insertion.

### Step 3: Select Male Beam
```
Command Line: Select Male Beam
Action: Click on the primary beam (the one that defines the main reference or receives the plate first).
```

### Step 4: Select Connection Type (Branching)
The script behavior changes based on the type of beam selected in Step 3.

**If Male Beam is a Post (Vertical):**
```
Command Line: Select Female Beam
Action: Click the intersecting beam to join to the post.
```
*If no female beam is selected (or cancelled), the script proceeds to:*
```
Command Line: Please select a point on the side of the beam where you need the Plate
Action: Click a point on the side of the Post to place an end plate.
```

**If Male Beam is a Standard/Rafter (Horizontal/Angled):**
```
Command Line: Select Female Beam
Action: Click the second beam to form the connection (e.g., a perpendicular beam or a splice).
```

### Step 5: Automatic Generation
The script calculates the intersection, generates the steel plate solid, cuts the timber beams to accommodate the plate, and drills bolt holes (if configured).

## Properties Panel Parameters

### Timber Cuts (Male Beam)
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Top Cut Depth | Number | 20 | Vertical depth of the cut on the top edge of the beam. |
| Top Back Cut | Number | 20 | Horizontal setback of the top cut from the intersection face. |
| Bottom Cut Depth | Number | 20 | Vertical depth of the cut on the bottom edge of the beam. |
| Bottom Back Cut | Number | 20 | Horizontal setback of the bottom cut from the intersection face. |
| Left Cut Depth | Number | 20 | Depth of the cut on the left side of the beam. |
| Left Back Cut | Number | 20 | Setback of the left cut from the intersection face. |
| Right Cut Depth | Number | 20 | Depth of the cut on the right side of the beam. |
| Right Back Cut | Number | 20 | Setback of the right cut from the intersection face. |

### Plate Dimensions (Male)
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Plate Width M | Number | 80 | Width of the steel plate attached to the Male beam. |
| Plate Height M | Number | 150 | Height of the steel plate attached to the Male beam. |
| Plate Thickness M | Number | 15 | Thickness of the steel plate. |
| Auto Size M | Yes/No | No | If **Yes**, overrides Width/Height to match the beam profile automatically. |

### Plate Dimensions (Female)
*Used for angled connections or specific splice scenarios.*
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Plate Width F | Number | 80 | Width of the secondary steel plate (Female). |
| Plate Height F | Number | 150 | Height of the secondary steel plate (Female). |
| Plate Thickness F | Number | 15 | Thickness of the secondary steel plate. |
| Auto Size F | Yes/No | No | If **Yes**, automatically sizes the Female plate to the beam profile. |

### Connection Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Plate Location | Front/Side | Front | **Front**: End-to-end connection. **Side**: Perpendicular connection (beam meets the side of another). |
| Flip Side | Yes/No | No | Mirrors the plate to the opposite side of the beam centerline. |
| Cut Plate | Yes/No | No | If **Yes**, cuts the steel plate geometry to match the angle of the Male beam (useful for non-90° intersections). |
| Name | String | Plate | The model name/label assigned to the generated steel part. |

### Drilling
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Qty | Number | 0 | Number of bolt rows (0=No holes, 1=Single row, 2=Double row). |
| Drill Top Offset | Number | 32 | Distance from the top edge of the plate to the center of the hole. |
| Drill Side Offset | Number | 32 | Distance from the side edge of the plate to the center of the hole. |
| Drill Diam | Number | 16 | Diameter of the bolt holes. |

## Right-Click Menu Options
Standard context menu options are available. Modifications are primarily handled via the Properties Palette (OPM).

| Menu Item | Description |
|-----------|-------------|
| Properties | Opens the Properties Palette to edit all parameters listed above. |
| Erase | Removes the script instance and the generated steel plate. |

## Settings Files
- **Filename**: `hsb-SubAssembly`
- **Location**: hsbCAD Company or Install directory.
- **Purpose**: Manages the grouping hierarchy, ensuring the generated steel plate is correctly linked to the timber beam for export and BOM purposes.

## Tips
- **Automatic Sizing**: For standard connections, set `Auto Size M` to **Yes**. This ensures the plate perfectly fits the beam cross-section even if beam sizes change later.
- **Angled Connections**: If connecting two beams at an angle (not 90°), the script automatically detects this as an "Angled Front Connection." It creates two plates and aligns them along the bisecting vector. The `Plate Location` property may become read-only in this mode.
- **Drilling Patterns**: Set `Qty` to `2` to create a double row of bolts. Use the `Top Offset` and `Side Offset` to control the position of the first row; the second row is typically mirrored or spaced based on the plate dimensions.
- **Post Connections**: If you are attaching a plate to a Post but don't have a second beam yet (e.g., a base plate or column cap), simply select the Post and then select a point on its side when prompted for the Female beam.

## FAQ
- **Q: Why did the script disappear immediately after selecting beams?**
  **A:** The script performs an intersection check. If the selected beams do not physically touch or cross each other in 3D space, the script erases itself. Ensure your beams intersect properly.
  
- **Q: How do I make the plate go on the other side of the beam?**
  **A:** Change the `Flip Side` property to **Yes** in the Properties Palette.
  
- **Q: Can I use this for column base plates?**
  **A:** Yes. Select the Post as the Male beam. When prompted for the Female beam, hit Esc or cancel, then click a point on the side of the Post where you want the plate. Set your timber cuts (depths) to 0 if you do not want to cut the timber.

- **Q: The plate size is wrong after I changed the beam size.**
  **A:** If `Auto Size M` is set to **No**, the plate retains manual dimensions. Switch `Auto Size M` to **Yes** to force the plate to resize to the new beam profile.