# sd_ViewportFieldDescription

## Overview
This script is used to insert dynamic text labels or custom blocks (such as logos) into drawing layouts. It links the label to a specific shop drawing viewport to display project data like the sheet number, scale, or project name.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for Layouts/Sheets. |
| Paper Space | Yes | The script functions in the Sheet environment. |
| Shop Drawing | Yes | Specifically designed for shop drawing viewports. |

## Prerequisites
- **Required Entities**: A `ShopDrawView` (Viewport) must exist in the layout to link the text/block to.
- **Minimum Beam Count**: 0
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `sd_ViewportFieldDescription.mcr` from the list.

### Step 2: Configure Properties
A dialog box will appear automatically upon insertion.
- **Action**: Use the dropdowns to select the data field you wish to display (e.g., Project Name) or browse for a Block name if inserting a logo. Click OK to confirm.

### Step 3: Set Insertion Point
```
Command Line: Insertion point:
Action: Click in the Paper Space layout where you want the text or block to appear.
```

### Step 4: Select Viewport
```
Command Line: Select ShopDrawView:
Action: Click on the viewport (ShopDrawView) frame that you want to associate with this label.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sTxt | dropdown | \|Project\| | Selects the dynamic data field to display (e.g., Client Name, Sheet Number, Scale). |
| sBlock | text | | The name of an AutoCAD block to insert. If filled, this overrides the text display. |
| dScale | number | 1.0 | Scale factor for the block (only active if sBlock is used). |
| dAngle | number | 0.0 | Rotation angle for the text or block (in degrees). |
| dTxtH | number | U(70) | Height of the text characters (in mm). |
| nColor | number | -1 | Color index for the entity (-1 = ByLayer). |
| sDimStyle | dropdown | _DimStyles | The text style (font) to use for the label. |
| sVertical | dropdown | \|Top\| | Vertical alignment relative to the insertion point (Top, Center, Bottom). |
| sHorizontal | dropdown | \|Left\| | Horizontal alignment relative to the insertion point (Left, Center, Right). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Refreshes the text content if project data has changed. |

## Settings Files
None

## Tips
- **Logos**: To insert a company logo, type the block name into the `sBlock` property. The script will switch to "Block Mode" and hide the text.
- **Alignment**: Use the Vertical and Horizontal alignment properties to precisely fit text into title block frames without calculating offsets manually.
- **Dynamic Updates**: If you rename the project or change the scale in the main model, the text inserted by this script will update automatically when the drawing is recalculated.

## FAQ
- **Q: Why is my text not showing up?**
  A: Check the `sBlock` property. If it contains a block name, the script displays the block instead of text. Clear the `sBlock` field to revert to text mode.
- **Q: How do I change the font?**
  A: Change the `sDimStyle` property to a different dimension style defined in your drawing template.
- **Q: Can I move the label after inserting it?**
  A: Yes. Select the script instance in the drawing and drag the grip point to move it.