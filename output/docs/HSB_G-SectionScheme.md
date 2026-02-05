# HSB_G-SectionScheme

## Overview
Generates 2D sectional views and schemes of the roof structure by cutting through roof elements and planes based on a user-defined cutting line. It creates detailed cross-section geometry, dimensions, and annotations directly in Model Space using an external calculation engine.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates here to generate geometry and collect roof entities. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | This is a Model Space generation tool, not a single-component detailing script. |

## Prerequisites
- **Required Entities**: `ElementRoof` and `ERoofPlane` must exist in the model to generate the section.
- **Minimum Beam Count**: 0 (Script relies on roof planes and elements rather than a specific count of beams).
- **Required Settings**: `HsbDogExe.exe` (legacy) or `HsbDog.dll` (modern) must be present in the hsbCAD Utilities path.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-SectionScheme.mcr`

### Step 2: Configure Settings
```
Command Line: [Dialog appears]
Action: Configure any initial settings in the dialog and click OK.
```

### Step 3: Define Start Point
```
Command Line: |Select start point of section|
Action: Click in the Model Space to set the start of the section cut line.
```

### Step 4: Define End Point
```
Command Line: |Select end point of section|
Action: Click to set the end of the section cut line. This defines the cut direction through the roof.
```

### Step 5: Define Position
```
Command Line: |Select a position|
Action: Click to place the section marker/label and determine the initial location of the generated geometry.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Scheme** | | | |
| Text height | Number | 150.0 | Sets the height for text labels and annotations in the generated section (in mm). |
| Offset name | Number | 500.0 | Sets the distance (in mm) the section name label is offset from the section start point. |
| Section name | Text | A-A | The alphanumeric identifier for the section (e.g., "A-A", "Section 1"). |
| Transform section | Dropdown | No | If "Yes", the generated 2D geometry moves when you drag the script grips. If "No", the geometry stays put and requires a reload if grips are moved. |
| Show milling | Dropdown | No | If "Yes", includes machining details (tenons, holes) in the 2D section view. |
| **Dimension** | | | |
| Default dimension style | Dropdown | [System List] | Selects the CAD dimension style (arrows, text size) to apply to all dimensions in the section. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Reload Section Scheme | Recalculates the section geometry. Use this if the roof model changes or if you moved the grip points while "Transform section" was set to "No". |

## Settings Files
- **Filename**: `HsbDogExe.exe` or `HsbDog.dll`
- **Location**: hsbCAD Utilities path (defined in your hsbCAD configuration)
- **Purpose**: External calculation engine used to process the roof cut and generate the detailed map of polylines, dimensions, and blocks.

## Tips
- **Moving the Section**: If you plan to move the section cut line frequently, set the **Transform section** property to "Yes". This allows the drawing to update dynamically as you drag the grips.
- **Recalc Warning**: If you see a "Recalc Required" warning near your section, it means the cut line moved but the drawing did not update. Right-click the section and choose **Reload Section Scheme**.
- **Milling Details**: Enable **Show milling** only if you need to see tooling details in the 2D section; this may increase calculation time slightly.

## FAQ
- **Q: I moved the section grips, but the drawing stayed in the old place.**
- **A: Your **Transform section** property is likely set to "No". Change it to "Yes" in the Properties palette to allow dynamic movement, or right-click and select **Reload Section Scheme** to update the geometry at the new location.

- **Q: The script crashes or does nothing when I insert it.**
- **A: Ensure `HsbDog.exe` or `HsbDog.dll` is installed in your hsbCAD Utilities folder. Also, verify that you have valid Roof Planes (`ERoofPlane`) in your model.