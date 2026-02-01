# CSG-Converter

## Overview
Converts "dumb" 3D solids (e.g., imported DWG or IFC models) into intelligent hsbCAD Beams and associative FreeDrills. It automatically parses layer names to assign properties like Material, Grade, and Name to the new timber elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | This is a construction/modeling tool, not a detailing script. |

## Prerequisites
- **Required Entities:** 3D Solids (AcDb3dSolid) representing timber parts, and optionally cylindrical solids representing holes. If creating drills only, existing Beams are required.
- **Required Settings:** Painter Definitions located in the folder `TSL\Conversion\`. If these are missing, the script will attempt to auto-generate default definitions named "Solid To Beam" and "Solid To Drill".
- **Layer Naming:** Source solids should be on layers with structured names (e.g., `GL28_240x60_C24`) to allow the script to extract data.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `CSG-Converter.mcr`
The script inserts into the drawing. If Painter Definitions are missing, it will automatically create default ones.

### Step 2: Configure Conversion Settings
Before selecting objects, configure the script parameters in the Properties Palette (Ctrl+1).
1.  **Beam Painter:** Choose a Painter Definition (e.g., `|Beam Conversion|`) to filter which solids become beams. Set to `<bySelection>` to pick manually, or `<Disabled>` to skip beam creation.
2.  **Drill Painter:** Choose a Painter Definition (e.g., `|Drill Conversion|`) for identifying holes.
3.  **Layer Separator:** Enter the character that separates data in your layer names (e.g., `_`).
4.  **Token Mapping:** Assign the split parts of the layer name to Beam properties.
    *   *Example:* If Layer is `GL24h_200x45`, Separator is `_`:
        *   Token 1 = `GL24h` → Set `sToken1` to **Material**.
        *   Token 2 = `200x45` → Set `sToken2` to **Name**.

### Step 3: Select Entities
The prompts vary based on your Painter settings in Step 2.

**Scenario A: Using Painter Definitions**
```
Command Line: Select entities:
Action: Select a window of all objects (solids) you want to process. The script will use the Painter to filter them automatically.
```

**Scenario B: Manual Selection (<bySelection>)**
```
Command Line: Select solids for beam conversion:
Action: Click specifically on the solids that represent timber beams.
Command Line: Select solids for drill conversion:
Action: Click specifically on the solids that represent drill holes.
```

**Scenario C: Drills Only (Beam Painter set to <Disabled>)**
```
Command Line: Select beams to apply drills to:
Action: Select the existing hsbCAD Beams that you want to add machining to.
```

### Step 4: Processing
1.  The script converts valid solids into Beams.
2.  It calculates the axis and dimensions for drill solids.
3.  It detects intersections and applies FreeDrills to the appropriate beams.
4.  A summary is printed to the command line (e.g., "5 Beams created, 12 Drills added").
5.  The script instance automatically removes itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **sPainter** | Selection | `|Beam Conversion|` | Determines which solids are converted into Beams. Select a specific Painter Definition, `<bySelection>` for manual picking, or `<Disabled>` to skip beam creation. |
| **sPainterDrill** | Selection | `|Drill Conversion|` | Determines which solids are converted into Drills. Select a specific Painter Definition, `<bySelection>` for manual picking, or `<Disabled>` to skip drill creation. |
| **sSeparator** | String | `_` | The delimiter character used to split the layer name (e.g., `_`, `-`, or `.`). |
| **sToken1** | Mapping | `|Name|` | Maps the first segment of the layer name to a Beam property (Name, Material, Grade, etc.). |
| **sToken2** | Mapping | `|Material|` | Maps the second segment of the layer name to a Beam property. |
| **sToken3** | Mapping | `|Grade|` | Maps the third segment of the layer name to a Beam property. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script executes immediately upon configuration and entity selection. It does not remain in the model as a persistent interactive object. |

## Settings Files
- **Filename:** `Solid To Beam.xml`, `Solid To Drill.xml` (Auto-generated defaults)
- **Location:** `TSL\Conversion\` (in your Company or hsbCAD Install path)
- **Purpose:** These Painter Definition files store the rules (Layer, Color, etc.) used to identify which imported solids correspond to structural beams vs. drill holes.

## Tips
- **Layer Organization:** Rename your import layers to a structured format (e.g., `Material_Width-Height_Grade`) before running this script to automate data entry.
- **Visualizing Loose Drills:** If a drill solid does not intersect any beam, the script will draw a temporary line to show its location. Check the command line for warnings if drills are missed.
- **Complex Geometry:** If a drill solid is not a perfect cylinder, the script automatically creates a temporary beam to calculate its axis vector.

## FAQ
- **Q: I get an error about missing Painter Definitions.**
  A: The script tries to create default definitions in `TSL\Conversion\`. Ensure you have write permissions to this folder, or manually create the Painter Definitions named "Solid To Beam" and "Solid To Drill".
- **Q: My beams were created, but they have no material info.**
  A: Check your `sSeparator` and `sToken` settings. If your layer is `Beam_240x60` and your separator is `_`, ensure you have mapped `sToken1` or `sToken2` to the correct property.
- **Q: The drills didn't attach to the beams.**
  A: Drills require a physical volume intersection with the beam. Ensure the cylindrical solids in your import overlap the beam solids sufficiently.