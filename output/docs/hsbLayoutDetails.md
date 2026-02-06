# hsbLayoutDetails.mcr

## Overview
This script creates and manages 2D detail viewports in Paper Space. It automatically zooms a viewport to a specific 3D model detail (defined by a Detail Number) and labels it with the correct scale for shop drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script operates only in Paper Space (Layouts). |
| Paper Space | Yes | Requires an existing viewport to function. |
| Shop Drawing | Yes | Designed for creating manufacturing details and connection views. |

## Prerequisites
- **Required Entities**: A valid Viewport in the current Layout that is linked to a 3D Element.
- **Minimum Beam Count**: 0 (It reads Element data, not individual beams).
- **Required Settings**: The 3D Element must have the `hsbElementDetails` script attached if you wish to link to specific joint details.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbLayoutDetails.mcr`

### Step 2: Configure Properties
Upon insertion, the Properties Palette (OPM) will display the script parameters. Adjust the **Scale** (e.g., 10:1) and **Detail Number** before proceeding to ensure the view zooms correctly.

### Step 3: Select Label Location
```
Command Line: (Implicit cursor prompt)
Action: Click in the Paper Space layout where you want the Detail Label text to appear.
```

### Step 4: Select Viewport
```
Command Line: Select viewport
Action: Click on the border of the viewport you wish to control.
```
*Note: The script will verify if the selected viewport contains a valid Element. If valid, it will search for the Detail Number.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Scale | dropdown | 10:1 | Sets the zoom level of the viewport (e.g., 10:1 enlarges the view 10 times). |
| Dimstyle | dropdown | *Current* | The visual style (font, size) applied to the detail label text. |
| Detail Number | number | 0 | The ID of the 3D detail to zoom into. Must match a detail ID defined in the model's `hsbElementDetails` script. |
| Color | number | 251 | The AutoCAD color index for the detail label text. |
| Show setup graphics | dropdown | No | If set to "Yes", draws a 100-unit reference rectangle to help position the label. Turn off after finalizing. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Refreshes the script. Use this after changing the Detail Number or Scale in the properties to update the viewport view. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: This script relies on the standard hsbCAD environment and properties defined in the `hsbElementDetails` attached to the model element.

## Tips
- **Positioning**: Set **Show setup graphics** to "Yes" while placing the label. This draws a box representing the drawing area, helping you align the text. Switch it back to "No" when you are done.
- **Linking Details**: Ensure the **Detail Number** in the properties matches the specific detail ID assigned to a joint or component in the 3D model (via `hsbElementDetails`). If they don't match, the viewport may zoom to a default location.
- **Adjusting Views**: You can grip-edit the label text location in Paper Space without affecting the zoomed view of the viewport.

## FAQ
- **Q: Why is my viewport showing the wrong part of the model?**
  A: Check the **Detail Number** property. If it is set to 0 or a number that doesn't exist on the element, the script cannot find the specific detail location to center on.
- **Q: Can I change the scale after I insert the script?**
  A: Yes. Select the script in Paper Space, open the Properties Palette, change the **Scale**, and right-click to **Recalculate**.
- **Q: What does the rectangle appear when I insert?**
  A: This is the "Setup Graphics" (100-unit reference box). Change the **Show setup graphics** property to "No" to hide it.