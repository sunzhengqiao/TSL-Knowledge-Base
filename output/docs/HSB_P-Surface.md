# HSB_P-Surface.mcr

## Overview
This script visualizes surface finish classifications (e.g., Visible vs. Non-Visible) on structural panels by reading entity properties. It draws color-coded labels (VI, IVI, NVI) directly on the panel faces in the 3D model to indicate which sides require architectural finishing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be inserted into the Model Space. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | This is a modeling tool, not a drawing generation script. |

## Prerequisites
- **Required Entities**: A `Sip` (Structural Insulated Panel) or structural panel entity.
- **Minimum Beams**: 0 (This script relies on Panels/Sips).
- **Required Settings**:
  - The selected panel must be assigned to an `Element`.
  - The panel entity must have a specific property submap named `SipProperties`.
  - This submap must contain the string keys `SurfaceReference` and `SurfaceOpposite` with valid values (e.g., "VI", "IVI", "NVI").

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_P-Surface.mcr` from the list.

### Step 2: Configure Properties (If prompted)
```
Command Line: (Dialog appears if no execute key is preset)
Action: Set the Dimension style or other parameters in the dialog and click OK.
```
*Note: If the script is run from a catalog with preset values, this step may be skipped.*

### Step 3: Select Panels
```
Command Line: Select panels
Action: Click on the panel(s) you wish to annotate in the 3D model and press Enter.
```

### Step 4: Verification
The script will process the selected panels. If the panel has the correct properties (SipProperties), text labels will appear on the Reference and Opposite sides. If properties are missing, the script may issue a notice in the command line and remain dormant on that panel.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension style | dropdown/text | "" | Determines the text size and font style used for the surface labels. Select an existing Dimension Style from your drawing to control appearance. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on entity properties (`SipProperties` attached to the panel) rather than external XML settings files.

## Tips
- **Color Coding**: The script uses specific colors to indicate surface types:
  - **Red**: VI (Visible Industrial)
  - **Cyan**: IVI (Invisible Visible Industrial)
  - **White/Grey**: NVI (Non-Visible Industrial)
- **Updating Labels**: If you change the geometry of the panel or its position, the labels will automatically move to stay attached to the surface.
- **Modifying Appearance**: You can change the text height/style at any time by selecting the script instance in the model and changing the "Dimension style" property in the AutoCAD Properties Palette (Ctrl+1).

## FAQ
- **Q: I ran the script, but no text appeared on my panel.**
  **A:** Ensure the panel is assigned to an Element and has the `SipProperties` submap attached with valid `SurfaceReference` and `SurfaceOpposite` values. Check the command line for a "Surface information is not set" notice.

- **Q: How do I change the text size of the labels?**
  **A:** Select the script instance (hover over the panel to find it if necessary), open the Properties Palette (Ctrl+1), and change the "Dimension style" to a style with your desired text height.

- **Q: Can I use this on standard beams?**
  **A:** No, this script is designed specifically for `Sip` entities (Structural Insulated Panels).