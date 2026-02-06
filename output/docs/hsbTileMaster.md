# hsbTileMaster

## Overview
Calculates roof tile quantities, waste factors, and distribution based on selected roof planes and a tile catalog. It generates a graphical material schedule (table) in Model Space and provides options to create physical 3D tile elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The schedule is drawn and inserted into the 3D model. |
| Paper Space | No | Not designed for use in Layouts. |
| Shop Drawing | No | This is a detailing/planning tool, not a drawing generator. |

## Prerequisites
- **Required Entities**: `ERoofPlane` (Roof Planes) must exist in the model.
- **Minimum Beam Count**: 0.
- **Required Settings**: `hsbTileCatalog.xml` must be present in the `<hsbCompany>\Abbund\` directory.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbTileMaster.mcr` from the list.

### Step 2: Select Roof Planes
```
Command Line: Select roofplanes and (optional) tsl instances to delete
Action: Click on the roof planes you wish to include in the calculation. You may also select existing tile instances (hsbTileSingle/hsbTileEdge) to delete and replace them. Press Enter to confirm.
```

### Step 3: Place Schedule
```
Command Line: Insertion point of table
Action: Click in the Model Space to define where the top-left corner of the schedule table should be placed.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Supplier / Product (`sTileProduct`) | dropdown | | Selects the manufacturer and tile profile (e.g., 'Brahas;Monier'). This loads dimensions and waste data from the catalog. |
| Auto group analysis BOM (`sGroup`) | text | | Defines the grouping hierarchy for the Bill of Materials (use `\` to separate levels). |
| Offset left (`dDeltaL`) | number | 0 | Setback distance (in mm) from the left roof outline to the lath contour. Used to exclude fascia/overhangs. |
| Offset right (`dDeltaR`) | number | 0 | Setback distance (in mm) from the right roof outline to the lath contour. |
| Dimstyle (`sDimStyle`) | dropdown | | Selects the dimension style to control the text appearance in the schedule. |
| Auto update after changes (`sAutoUpdate`) | dropdown | \|No\| | If set to \|Yes\|, the schedule recalculates automatically on geometry changes. If \|No\|, performance increases but requires manual updates. |
| Color (`nColor`) | number | 252 | The AutoCAD color index for the schedule lines and text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| \|Update\| | Recalculates all tile quantities and redraws the schedule table. |
| \|append roofplanes\| | Adds new roof planes to the existing calculation without deleting the current setup. |
| \|create Tiles\| | Generates the physical 3D tile elements (hsbTileSingle/hsbTileEdge) on the roof. |
| \|Delete tiles\| | Removes all generated 3D tile elements associated with this schedule. |
| \|Add tiles\| | Adds tile elements based on current settings to the roof. |
| \|Modify tile\| | Updates existing tile elements to match current parameters. |
| \|append roof edge\| | Adds roof edges to the calculation context. |
| \|read catalog\| | Reloads the tile data from `hsbTileCatalog.xml`. Use this if you manually edited the XML file. |

## Settings Files
- **Filename**: `hsbTileCatalog.xml`
- **Location**: `<hsbCompany>\Abbund\`
- **Purpose**: Contains definitions for tile profiles, including dimensions (widths), waste factors, and article numbers for both area tiles and ridge/hip tiles.

## Tips
- **Performance**: For large projects, set **Auto update after changes** to `|No|` to prevent lag while modeling. Update manually via the right-click menu when needed.
- **Offsets**: Use the **Offset left** and **Offset right** properties to precisely define the tiling area, excluding large overhangs or specific architectural features.
- **Error Handling**: If the schedule displays an error about "invalid values," check your `hsbTileCatalog.xml` to ensure the `WMin` and `WMax` values for the selected product are greater than 0.

## FAQ
- **Q: The schedule table is empty or shows an error about invalid values.**
  **A:** The script detected missing or corrupt data in `hsbTileCatalog.xml`. Ensure the selected product has valid width parameters defined in the XML file, then right-click and select `|read catalog|`.

- **Q: How do I visualize the actual tiles in 3D?**
  **A:** After generating the schedule, right-click the instance and choose `|create Tiles|`. This will place the physical `hsbTileSingle` and `hsbTileEdge` elements on the roof planes.

- **Q: Can I add more roof planes later?**
  **A:** Yes. Right-click the schedule instance and select `|append roofplanes|`. You can then select additional planes to add to the calculation.