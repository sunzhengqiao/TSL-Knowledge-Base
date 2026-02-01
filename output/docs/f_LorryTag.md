# f_LorryTag.mcr

## Overview
This script automatically generates logistics tags (labels) and applies color-coded hatching to timber packages (Lorry Packages) in shop drawings or model space. It helps visualize and identify package contents during production and shipping planning.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Tags packages or attaches to ShopDrawView viewports. |
| Paper Space | Yes | Updates automatically when viewed through viewports linked to Model Space. |
| Shop Drawing | Yes | Supports standard ShopDrawView entities and Multipage views. |

## Prerequisites
- **Required Entities**: `TslInst` (f_LorryPackage), `HSBCAD_MULTIPAGE`, or `ShopDrawView` (Viewport).
- **Minimum Beam Count**: 0
- **Required Settings**: Valid `PainterDefinition` entries (if using the hatching feature).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `f_LorryTag.mcr` from the list.

### Step 2: Select Target Entity
The command line prompt depends on your current drawing environment:
*   **If ShopDrawView viewports exist**:
    ```
    Command Line: Select shopdraw viewport
    Action: Click on the viewport in Model Space representing the shop drawing view you wish to annotate.
    ```
*   **If no ShopDrawView viewports exist**:
    ```
    Command Line: Select lorry packages (or its multipages)
    Action: Select the specific Lorry Package instances or Multipage entities in the drawing.
    ```

### Step 3: Define Placement (If Viewport Selected)
If you selected a viewport in Step 2:
```
Command Line: 
Action: Click a point in the drawing to set the reference location for the script instance.
```
*Note: If you selected Lorry Packages directly, the script will automatically apply tags to all selected items and finish.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Format | text | @(PosNum) | Defines the text displayed on the tag (e.g., Package Number). |
| Tag Placement | dropdown | Closest Location | Determines where the tag is placed: "Closest Location" or "Outside of Object". |
| Hatch active | dropdown | No | Toggles the visual hatching of the package boundary (Yes/No). |
| Dimstyle | dropdown | System DimStyles | Selects the CAD Dimension Style used for the tag text font and arrows. |
| Text Height | number | 0 | Defines the text height in mm. Set to 0 to use the DimStyle default. |
| Painter | dropdown | System Painters | Selects the Painter Definition where hatch settings are stored. |
| Color | number | 1 | Defines the Color index (ACI) for the hatch. |
| Transparency | number | 0 | Defines the Transparency level for the hatch (0-255). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Grip points on | Enables EditInPlace mode, showing grips that allow you to manually drag and reposition tags. |
| Grip points off | Disables EditInPlace mode and hides the manual repositioning grips. |
| Set painter hatches | Opens a dialog to assign hatch properties (Color, Transparency) to a specific Painter Definition. |
| Remove painter hatches | Opens a dialog to select a Painter Definition and remove its associated hatch data. |
| List Painter Hatches | Displays a report listing all Painter Definitions currently configured with hatch settings for this script. |

## Settings Files
- **Painter Definitions**: System database
- **Location**: hsbCAD Company/Project Standards
- **Purpose**: Stores hatch patterns and layer assignments used by the `Hatch active` parameter.

## Tips
- Set **Text Height** to `0` to ensure the tag text automatically scales if you change your drawing's DimStyle.
- Use **Hatch active** set to "Yes" with contrasting colors to visually separate different packages on congested loading plans.
- You can double-click the script instance to toggle "Grip points on/off" for quick adjustments.
- The **Format** property supports dynamic fields like `@(PosNum)`, `@(Length)`, or `@(Elev)` to display specific package data.

## FAQ
- Q: Why is my tag text appearing in the wrong size?
  A: Check the **Text Height** property. If it is set to `0`, the size is controlled by the **Dimstyle** property.
- Q: The hatch is not showing up even though "Hatch active" is set to "Yes".
  A: Ensure that the **Painter** property is set to a Painter Definition that actually contains hatch geometry or valid color assignments.
- Q: How do I move a tag that is overlapping another object?
  A: Right-click the script instance and select "Grip points on", then drag the blue grip points to move the tag to a clear location.