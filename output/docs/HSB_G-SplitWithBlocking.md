# HSB_G-SplitWithBlocking.mcr

## Overview
Automatically splits selected beams within a timber element and inserts blocking (nogging) members at the split locations, with options to stretch the blocking to adjacent structural members.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates new instances and modifies geometry in `_kModelSpace`. |
| Paper Space | No | This script does not operate in Shop Drawings or Paper Space. |
| Shop Drawing | No | This script is for model generation only. |

## Prerequisites
- **Entities**: At least one timber `Element` must exist in the model.
- **Configuration**: Catalog entries for `HSB_G-SplitWithBlocking` and `HSB_G-FilterGenBeams` must be installed.
- **Filters**: If using specific beam filters, definitions must be created in the `HSB_G-FilterGenBeams` catalog.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-SplitWithBlocking.mcr`

### Step 2: Configure Properties (Optional)
```
Command Line: [Properties Palette updates]
Action: Before or after insertion, you can adjust settings like Filter definition, Split length, and Blocking dimensions in the Properties Palette (OPM).
```

### Step 3: Select Elements
```
Command Line: Select elements
Action: Click on the timber Element(s) containing the beams you wish to process. Press Enter to confirm selection.
```

### Step 4: Processing
```
Action: The script attaches to the selected Element, filters the beams, calculates split points, and generates the blocking members. The temporary script instance is erased, leaving only the new geometry.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter definition | dropdown | | Selects a predefined group of beams (from the Filter GenBeams catalog) to be processed. |
| Beamcode | text | | Refines the beam selection based on a specific text Beamcode (supports wildcards). |
| Incl/Excl | dropdown | Include | Determines if the Beamcode filter acts as a whitelist (Include) or blacklist (Exclude). |
| Split length | number | 1000 mm | The distance along the beam from the start (or previous split) where the blocking is inserted. |
| SecondSplit length | number | 0 mm | Alternative split position used if the standard Split Length is invalid near beam ends. |
| Single split | dropdown | No | If Yes, only one split is made per beam. If No, splits repeat along the beam length. |
| Flip Dir | dropdown | No | Reverses the direction in which the split distance is calculated from the beam's origin. |
| Blocking length | number | 100 mm | The length (thickness) of the blocking member along the split beam's axis. |
| Blocking height | number | 25 mm | The vertical depth of the blocking. Use -1 to match beam height or -2 for smart height. |
| Blocking width | number | 25 mm | The width of the blocking. Use -1 to match the underlying beam's width. |
| BlockingElementHeight | dropdown | No | If Yes, automatically stretches the blocking height to fit exactly between the element's top and bottom planes. |
| BlockingMaterial | text | -1 | Assigns material to the blocking. -1 inherits from the beam being split. |
| BlockingColor | number | -1 | Assigns display color. -1 inherits from the beam being split. |
| BeamCode | text | | Assigns a specific Beam Code (name) to the generated blocking members. |
| BeamStretch | dropdown | No | If Yes, extends the blocking to intersect and connect with the nearest perpendicular beams. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Regenerates the blocking and splits based on the current property values if you manually trigger the script instance. |

## Settings Files
- **Filename**: Catalog entries for `HSB_G-FilterGenBeams`
- **Location**: hsbCAD Catalog
- **Purpose**: Provides the filter definitions used to select specific sets of beams (e.g., "All Studs", "All Joists") within the element without manually selecting individual beams.

## Tips
- **Validation Error**: If the script disappears after insertion, check the command line. Ensure **Split length** is greater than **Blocking length**.
- **Full Height Blocking**: To create blocking that fills the entire space between top and bottom plates (e.g., for fire blocking), set **BlockingElementHeight** to Yes.
- **Smart Sizing**: Use **Blocking height** or **width** set to `-1` to automatically match the dimensions of the beam you are splitting, ensuring a perfect fit.

## FAQ
- Q: Why is my blocking not appearing?
- A: Ensure the **Filter definition** actually matches beams within your selected Element, and that the **Split length** is not longer than the beams themselves.
- Q: Can I stretch the blocking to reach other walls?
- A: The script stretches blocking to intersect *perpendicular* beams within the same element. It does not typically stretch across different elements.
- Q: What does the SecondSplit length do?
- A: It prevents the blocking from being partially unsupported near the ends of a beam. If the remaining space is too short for a standard split interval, the script uses this value instead.