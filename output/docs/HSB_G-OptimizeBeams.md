# HSB_G-OptimizeBeams.mcr

## Overview
This script automatically splits long timber beams into specific maximum stock lengths based on their beam codes. It is primarily used to optimize beams for raw material availability or transport constraints (e.g., cutting 6m beams down to 5.4m stock).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D Elements and GenBeams. |
| Paper Space | No | Not designed for 2D drawings or layouts. |
| Shop Drawing | No | Does not generate drawing views. |

## Prerequisites
- **Required Entities:** Elements (with assigned GenBeams).
- **Minimum Beam Count:** 0.
- **Required Settings:** None (properties are configured manually or via catalogs).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-OptimizeBeams.mcr`

### Step 2: Configure Properties
```
Command Line: (Dialog Appears)
Action: A properties dialog will open automatically upon insertion if not run via an execute key. 
        Set the "Length" and "Beamcodes" for the 6 available categories here.
```

### Step 3: Select Elements
```
Command Line: Select one or more elements
Action: Click on the Elements in the Model Space that contain the beams you wish to optimize.
        Press Enter to confirm selection.
```

### Step 4: Automatic Processing
```
Command Line: (Processing...)
Action: The script automatically scans the selected elements, identifies beams matching the 
        codes, splits them if they exceed the defined lengths, and then removes itself from the 
        element to keep the project clean.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **General** | | | |
| Sequence number | Integer | 0 | Determines the execution order if multiple TSLs are assigned to the same element. |
| **Length 1** | | | |
| Length 1 | Number | 2440 | The maximum allowed length (mm) for beams matching "Beamcodes 1". |
| Beamcodes 1 | Text | "" | Semicolon-separated list of beam codes (e.g., "PL;R") to apply Length 1 restriction to. |
| **Length 2** | | | |
| Length 2 | Number | 5400 | The maximum allowed length (mm) for beams matching "Beamcodes 2". |
| Beamcodes 2 | Text | "" | Semicolon-separated list of beam codes to apply Length 2 restriction to. |
| **Length 3** | | | |
| Length 3 | Number | 5400 | The maximum allowed length (mm) for beams matching "Beamcodes 3". |
| Beamcodes 3 | Text | "" | Semicolon-separated list of beam codes to apply Length 3 restriction to. |
| **Length 4** | | | |
| Length 4 | Number | 5400 | The maximum allowed length (mm) for beams matching "Beamcodes 4". |
| Beamcodes 4 | Text | "" | Semicolon-separated list of beam codes to apply Length 4 restriction to. |
| **Length 5** | | | |
| Length 5 | Number | 5400 | The maximum allowed length (mm) for beams matching "Beamcodes 5". |
| Beamcodes 5 | Text | "" | Semicolon-separated list of beam codes to apply Length 5 restriction to. |
| **Length 6** | | | |
| Length 6 | Number | 5400 | The maximum allowed length (mm) for beams matching "Beamcodes 6". |
| Beamcodes 6 | Text | "" | Semicolon-separated list of beam codes to apply Length 6 restriction to. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | This script performs its action immediately upon insertion or element construction and self-destructs, leaving no persistent menu options on the element. |

## Settings Files
None required. All settings are managed through the Properties Palette (OPM).

## Tips
- **Beam Code Syntax:** When entering beam codes, use a semicolon `;` to separate multiple codes if you want the same length limit applied to different beam types (e.g., `FL;PL`).
- **Self-Cleaning:** This script automatically deletes itself from the element after it has finished optimizing the beams. You will not see it listed in the element's TSL list afterwards.
- **Iterative Splitting:** If a beam is significantly longer than the limit (e.g., 12m with a 5.4m limit), the script will split it multiple times until all segments are within the limit.

## FAQ
- **Q: Why did the script disappear after I ran it?**
  A: The script is designed to "self-destruct" after optimizing the beams. This prevents duplicate optimization and keeps the element properties clean.
- **Q: How do I apply different lengths to different wall parts?**
  A: Use the "Length 1" through "Length 6" categories. Assign the specific beam codes used in your wall layers to the corresponding "Beamcodes" field.
- **Q: Can I use this on a single beam instead of a whole wall?**
  A: The script operates at the Element level. If you need to optimize a single beam, ensure that beam has a unique Beam Code and apply that code to one of the script categories.