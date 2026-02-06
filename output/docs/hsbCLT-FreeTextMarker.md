# hsbCLT-FreeTextMarker

## Overview
This script adds free text labels (such as position numbers) and/or directional marker lines to CLT panels. The annotations are created in the 3D model and automatically included in generated shop drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary usage environment. Script must be inserted on panels in 3D. |
| Paper Space | No | Not supported for direct insertion. |
| Shop Drawing | Yes | Generates text and markers on the panel layout via MapRequest. |

## Prerequisites
- **Required Entities:** CLT Panels (Sip entities).
- **Minimum Beams:** 1 (though Text mode supports multiple).
- **Required Settings Files:** None.
- **Dependencies:** `hsbGrainDirection` (Optional: only required if using alignment options related to grain direction).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or select from Catalog) → Select `hsbCLT-FreeTextMarker.mcr`

### Step 2: Configure Properties
The Properties Palette will appear. Before selecting elements, adjust the **Mode** property:
- **Text:** Best for adding labels (e.g., Position Numbers) to multiple panels at once.
- **Marker** or **Text+Marker**: Requires selecting a single panel and defining specific points.

### Step 3: Select Panel(s)
**If Mode is set to "Text":**
```
Command Line: Select panels
Action: Click on the CLT panels you want to label. You can select multiple panels. Press Enter to confirm.
```
*Note: The script will automatically place the text at the center of selected panels.*

**If Mode is set to "Marker" or "Text+Marker":**
```
Command Line: Select panels
Action: Click on a single CLT panel.
```

### Step 4: Pick Base Point
*(Only appears for single panel selection)*
```
Command Line: Pick base point
Action: Click on the panel surface where you want the text/marker to start.
```
*Note: If you click outside the panel boundaries, the script will automatically project the point onto the panel surface.*

### Step 5: Set Direction (Optional)
*(Only appears for single panel selection)*
```
Command Line: Select point in direction <Enter> to align with edge
Action: Click a second point to define the rotation of the text/marker. Alternatively, press Enter to automatically align it with the nearest panel edge.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Mode | dropdown | Text | Selects the type of annotation: "Text" only, "Marker" only, or both. |
| Face | dropdown | Reference Face | Determines which side of the panel receives the annotation: Reference Face, Top Face, or Both. |
| Alignment | dropdown | Parallel | Sets the orientation relative to the panel edge or grain direction. Options include Parallel, Perpendicular, Parallel to grain direction, and Perpendicular to grain direction. |
| Alignment (Text) | dropdown | Top-Left | Sets the anchor point of the text string (e.g., Top-Left, Center-Center). |
| Text Height | number | 0 | Defines the height of the text characters in millimeters. If 0, a default height is used. |
| Format | text | @(PosNum) | The content of the text. Supports dynamic tokens (e.g., `@(PosNum)`, `@(Length)`) or custom strings. |
| Length (Marker) | number | 0 | Defines the length of the marker line in millimeters. Set to 0 to use the grip point length. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side | Toggles the annotation between the Reference Face and Top Face. (Also available by Double-Clicking the tool). |
| Set Alignment | Prompts you to click a point to manually set a custom rotation direction for the text/marker. |
| Snap To Edge | Removes any custom rotation and snaps the annotation back to align with the nearest panel edge. |
| Set Marker Perpendicular To Edge | Rotates the marker line 90 degrees relative to the nearest panel edge. |

## Settings Files
No specific settings files are required for this script.

## Tips
- **Batch Labeling:** Use the **Text** mode to quickly apply Position Numbers to a selection of multiple panels in one operation.
- **Dynamic Text:** Use the `Format` property to include tokens like `@(Length)` or `@(Width)` to display panel dimensions that update automatically if the panel changes size.
- **Grip Editing:** After insertion, select the tool in the model to see a blue grip point. Drag this grip to easily rotate the text/marker or change the marker length without opening the properties menu.
- **Grain Direction:** To align text with the wood grain, ensure the `hsbGrainDirection` script is applied to the panel and set the **Alignment** property to "Parallel to grain direction".

## FAQ
- **Q: I selected multiple panels, but the tool only appeared on one. Why?**
- A: Ensure the **Mode** property is set to "Text". "Marker" and "Text+Marker" modes only support single panel selection because they require a specific insertion point.
- **Q: My text displays as "0" or "Unknown".**
- A: Check the **Format** property. If you are using a token (like `@(PosNum)`), ensure that specific property exists and has a value for the selected element.
- **Q: How do I put the label on the top side of the panel instead of the bottom?**
- A: Select the tool, right-click, and choose **Flip Side**, or change the **Face** property in the Properties Palette to "Top Face".