# hsbPanelOpeningFillet

## Overview

hsbPanelOpeningFillet adds rounded corners (fillets) to window and door openings in panels. The tool automatically detects rectangular opening corners and applies a fillet with a specified radius to each corner, creating smoother, more finished opening edges.

This tool works on existing openings in SIP (Structural Insulated Panel) elements and can handle both window-type openings (completely enclosed) and door-type openings (open at one edge).

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | Object (O-Type) - Non-resident (erases itself after execution) |
| Required Beams | 0 |
| CAD Space | Model Space |
| Element Association | SIP (Panel) elements with openings |
| Version | 1.1 |

## Prerequisites

- A SIP (panel) element must exist in the model
- The panel must have at least one window or door opening
- The opening should have distinct corners that can receive fillets

## Usage Steps

1. **Start the command** using execute key or showing the dialog
2. **Configure radius**: Set the "Radius" property to your desired fillet size
   - Alternatively, select a preset catalog entry if available
3. **Click OK** to accept settings
4. **Select panel**: Click on the SIP panel containing the opening
5. **Click inside opening**: Click a point inside the window or door opening you want to fillet
6. **Repeat for additional openings**: The tool enters a loop allowing you to fillet multiple openings
   - Select another point in a different opening on the same or different panel
   - Press ESC or Enter to exit when finished

The tool automatically:
- Identifies whether the opening is a window or door type
- Stretches edges inward by the fillet radius
- Creates rounded corners at each edge intersection
- Updates the panel geometry immediately

## Properties Panel Parameters

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Radius** | Length | 20mm | The radius of the fillet to be applied at each corner of the opening |

## Right-Click Menu

No custom context menu commands are available for this tool.

## Settings Files

This script does not use external XML settings files.

## Tips

- **Multiple Openings**: The tool allows batch processing - you can fillet multiple openings in one operation by clicking inside each opening sequentially.

- **Automatic Detection**: The tool intelligently differentiates between window openings (enclosed) and door openings (open at bottom/top) and handles each type appropriately.

- **Edge Stretching**: For window openings, the tool stretches each edge inward by the radius amount before creating the fillet, ensuring proper corner geometry.

- **Door Openings**: For door-type openings, the tool extends the panel in the free direction before applying fillets to the sides.

- **Radius Limitations**: The tool automatically limits the fillet radius to the available space at each corner. If the radius is too large, it will be reduced to the maximum possible value.

- **Visual Feedback**: During processing, the tool uses color-coded visualization to show which edges are being modified.

- **Non-Resident**: This tool does not remain as a parametric object. Once applied, the filleted opening becomes part of the panel's geometry.

## FAQ

**Q: Can I change the fillet radius after applying it?**
A: No, this tool is non-resident - it modifies the panel geometry directly and then erases itself. To change the radius, you would need to undo and reapply with a different value.

**Q: What if my opening doesn't have clear corners?**
A: The tool works best on rectangular or polygonal openings with distinct corners. Openings with existing curves or irregular shapes may not process correctly.

**Q: Will this work on CLT panels?**
A: The tool is specifically designed for SIP elements. It retrieves the panel using `getSip()` method during insertion.

**Q: Can I fillet both windows and doors in the same operation?**
A: Yes, the tool handles both types automatically. Simply click inside each opening you want to process.

**Q: What happens if I click outside all openings?**
A: The tool will not find a matching opening and will skip that selection, allowing you to try again or exit.

**Q: Does the tool work on circular or curved openings?**
A: No, it's designed for openings with straight edges and corners. Circular openings already have curved edges.

**Q: Can I use this on external panel corners, not just openings?**
A: No, this tool specifically targets window and door openings within panels, not the panel's outer boundary.

**Q: What if my fillet radius is larger than the corner allows?**
A: The tool calculates the maximum available distance at each edge and automatically limits the fillet to prevent geometric errors.
