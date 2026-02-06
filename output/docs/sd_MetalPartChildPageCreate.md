# sd_MetalPartChildPageCreate

## Overview
Automates the creation of detail drawings (child pages) for metal parts during shop drawing generation. This script intelligently separates simple single steel plates from complex assemblies and places them into a specific area on your layout sheet.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used to insert the script and define the drawing area. |
| Paper Space | Yes | The child pages are generated here during the Shop Drawing process. |
| Shop Drawing | Yes | The script executes automatically when generating a multipage shop drawing. |

## Prerequisites
- **Required Entities**: Metal Part Collections (steel connections) must be present in the model.
- **Minimum Beam Count**: 0 (This script is geometry-independent but relies on attached metal parts).
- **Required Settings**: Valid Shop Drawing Style names must exist in your hsbCAD environment for "Assemblies", "Single Parts", and "GenBeams".

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `sd_MetalPartChildPageCreate.mcr` from the list.

### Step 2: Set Insertion Point
```
Command Line: (No specific prompt, usually accepts default or click)
Action: Click a point in the model to anchor the script instance.
```

### Step 3: Define Drawing Area
```
Command Line: Select pline area where child pages can be placed
Action: Select a closed polyline in the Model Space.
Note: This polyline defines the boundary (frame) on the layout sheet where the metal details will be placed. The script will remember this shape and remove the original line from the model.
```

### Step 4: Configure Properties (Optional)
Select the script instance and open the **Properties Palette**. Enter the names of the Shop Drawing Styles you wish to use for different types of metal parts.

### Step 5: Generate Shop Drawing
Run the standard `Generate Shopdrawing` command. The script will automatically scan for metal parts and populate the child pages based on your configuration.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Shopdraw style Metalpart Assembly | Text | "" | The name of the Shop Drawing Style used for complex metal connections (assemblies consisting of multiple parts). |
| Shopdraw style Metalpart Single | Text | "" | The name of the Shop Drawing Style used for simple metal parts (a single steel plate or item). |
| Shopdraw style GenBeam | Text | "" | The name of the Shop Drawing Style used for individual components (beams) inside a metal assembly. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Select pline area where child pages can be placed | Allows you to redefine the boundary area for the child pages. Select a new polyline in the model to update the layout frame. |

## Settings Files
This script relies on standard hsbCAD Shop Drawing Styles rather than specific external XML settings files. Ensure the styles referenced in the Properties Panel are defined in your project or database configuration.

## Tips
- **Area Definition**: The polyline you select acts as a "container." Ensure it is large enough to fit the expected details, or the shop drawing engine might overlap content.
- **Styles Logic**: The script checks the number of components in a metal part. If it finds multiple parts, it uses the "Assembly" style for the group and the "GenBeam" style for the pieces. If it finds only one part, it uses the "Single" style.
- **Filtering**: If you use the `HSBDEFINESHOPDRAWSHOWSETMETALPART` script, ensure your metal parts intersect correctly with the host beam, or they will be filtered out and not drawn.

## FAQ
- **Q: I see a warning "The shopdrawing might be incomplete due to missing numbers..."**
  **A:** This means one or more of your metal parts does not have a Position Number assigned. Edit the metal part block to assign a Position Number (PosNum) and regenerate the drawing.
- **Q: How do I move the details to a different spot on the sheet?**
  **A:** Use the Right-Click menu option "Select pline area where child pages can be placed" and draw a new polyline in the desired location. Regenerate the shop drawing to apply the change.
- **Q: Why are some of my steel parts not showing up?**
  **A:** Check if a visibility filter script is applied. The script filters out metal parts whose geometry does not physically intersect with the host GenBeam.