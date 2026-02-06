# hsb_ShowSIPSplines.mcr

## Overview
This script automatically annotates 2D layout views (Paper Space) to distinguish between 'Spline' insulation members and standard 'Timber' members within a SIP (Structural Insulated Panel) wall or floor element. It places text labels in the drawing layout corresponding to the location of specific structural members.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script does not function in Model Space. |
| Paper Space | Yes | This is the primary space; script must be inserted on a Layout tab. |
| Shop Drawing | No | This is for general layout annotation. |

## Prerequisites
- **Required Entities:** A Viewport in Paper Space that is linked to a valid hsbCAD Element (Wall or Floor).
- **Minimum Beams:** 1 (The Element must contain beams/members to annotate).
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ShowSIPSplines.mcr`

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport border in the Paper Space layout that displays the Element you wish to annotate.
```

### Step 3: Configure Properties
```
Action: A property dialog will appear automatically.
Action: Adjust the Dim Style or Offset as needed and click OK.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dim Style | dropdown | _DimStyles | Determines the visual style (font, text height, color) of the annotation labels. |
| Offset From Element | number | 50 | Sets the distance (in mm) from the centerline of the element to the center of the text label. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific custom items to the right-click context menu. |

## Settings Files
- **Filename**: *None*
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Naming Convention:** The script identifies members by name. If a beam is named exactly "SPLINE", it will be labeled as "Spline". All other beams will be labeled "Timber".
- **Updating Labels:** If you rename a beam in the model (e.g., change a stud to "SPLINE"), the script will automatically update the label in the layout upon recalculation.
- **Self-Cleaning:** If you delete the Viewport associated with this script, the script instance will automatically remove itself from the drawing.

## FAQ
- **Q: Why is the text not appearing for some of my beams?**
  A: The script filters beams based on their orientation relative to the element's X-axis. Ensure the beams are roughly perpendicular to the element's length, and that they intersect the central analysis profile of the wall.
- **Q: How do I change the text size?**
  A: You cannot change the size directly with a number property. Instead, change the **Dim Style** property to a Dimension Style that uses your desired text height.
- **Q: Can I use this on normal timber walls?**
  A: Yes, but unless beams are named "SPLINE", they will all be labeled "Timber". This is primarily designed for SIP constructions where splines are distinct.