# FLR_WebStiffenerNote.mcr

## Overview
Automates the creation of "Web Stiffener" (WS) annotations on floor beams or trusses. It intelligently categorizes the mark as Start (Pos), End (Neg), or Mid-span based on the click location relative to the beam ends.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script runs in the 3D model to attach data to beams. |
| Paper Space | No | Output is visible in Layouts via the Display representation, but insertion is in Model Space. |
| Shop Drawing | No | This is a model detailing script that generates data used by shop drawings. |

## Prerequisites
- **Required Entities**: Beams or TrussEntities.
- **Minimum Beam Count**: 1.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `FLR_WebStiffenerNote.mcr` from the file dialog.

### Step 2: Select Beams/Trusses
```
Command Line: Select a set of Beams/Trusses to Mark
Action: Click the beams or trusses you wish to annotate. You can select multiple beams at once to apply the mark to a group. Press Enter to confirm selection.
```

### Step 3: Mark Location
```
Command Line: Select a point near the location to mark
Action: Click on or near the beam where the web stiffener is required.
```
*Note: If you selected multiple beams in Step 2, the script will create a mark on every selected beam based on this single point location (relative to their individual geometry).*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Minimum Distance From End | Number | 8 (in/mm) | Defines the threshold for the "End Zone." If you click within this distance from the start or end of the beam, the note is labeled "Pos" (Start) or "Neg" (End). Clicks outside this range are labeled "Mid" (Mid-span). |
| Text Height | Number | 3 (in/mm) | Controls the visual size of the "WS" text label in the drawing. It also determines how far the label is offset from the beam surface to prevent clashing. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are defined in this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A (This script uses properties and geometric inputs only).

## Tips
- **Batch Marking**: You can select an entire row of joists or trusses in Step 2. By clicking a point in Step 3 (e.g., a point load location), a stiffener mark will be generated on *all* selected beams at that relative location.
- **Dynamic Labeling**: If you move the script instance using the AutoCAD `Move` command or Grip Edit, the label (Pos/Neg/Mid) will automatically update based on the new position relative to the beam ends.
- **Adjusting End Zones**: If your "Mid" marks are appearing too close to the supports, increase the "Minimum Distance From End" property.
- **Recovery**: If you delete or modify the referenced beam, the script will attempt to find the nearest beam in the current group to reattach itself. If it cannot find one, the instance will delete itself to prevent errors.

## FAQ
- **Q: What does "Pos", "Neg", and "Mid" mean?**
  **A:** These represent the stiffener location relative to the beam's local coordinate system:
  - **Pos**: Positive/Start side of the beam.
  - **Neg**: Negative/End side of the beam.
  - **Mid**: Mid-span (between the end zones).

- **Q: I clicked near the end, but it says "Mid". Why?**
  **A:** Your click was likely further away than the "Minimum Distance From End" setting. Increase this value in the Properties Palette or click closer to the beam end.

- **Q: Can I use this on single beams or only groups?**
  **A:** You can use it on a single beam or select multiple beams to process them all at once.

- **Q: What happens if I delete the beam the note is attached to?**
  **A:** The script attempts to find a replacement beam nearby. If no beam is found, the note instance will be automatically removed from the drawing.