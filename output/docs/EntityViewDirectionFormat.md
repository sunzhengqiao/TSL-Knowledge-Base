# EntityViewDirectionFormat.mcr

## Overview
This script automatically generates and positions text labels for CLT panels (or other entities) in drawings. It resolves dynamic format strings to display properties like "Loading Top Side" or "Surface Quality," intelligently adjusting the text content and position based on the view direction relative to the panel.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Attaches to MultiPage entities. Auto-deletes if text resolves to empty. |
| Paper Space | Yes | Attaches to ShopDrawView entities (Layouts). |
| Shop Drawing | Yes | Specifically designed for shop drawing annotations. |

## Prerequisites
- **Required Entities:**
  - **Paper Space:** A `ShopDrawView` entity (Viewport) must be present.
  - **Model Space:** A `MultiPage` entity must be selected.
- **Minimum Beam Count:** 0 (This script works on entities/panels, not beams).
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `EntityViewDirectionFormat.mcr` from the list.

### Step 2: Configure Properties (Optional)
Upon insertion, the Properties Palette may appear. You can accept defaults or set the **Format**, **Text Height**, or **Color** now.

### Step 3: Select Context
The script prompts differ based on your current space:

**In Paper Space / Layout Tab:**
```
Command Line: Select main viewport (optional)
Action: Click on a viewport to define the "main" view, or press Enter to skip.
```
```
Command Line: Specify point
Action: Click where you want the text label to appear within the viewport.
```

**In Model Space:**
```
Command Line: Select multipages
Action: Select one or more MultiPage entities from the drawing and press Enter.
```

*If multiple MultiPages were selected:*
```
Command Line: Select view
Action: Use the mouse (Jig) to hover over and select the specific view representation you want to annotate.
```

```
Command Line: Specify point
Action: Click to place the text in the selected view.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Format** | String | `""` | Defines the text content using hsbCAD keys. Supports standard keys (e.g., `@(Name)`) and special keys: `@(LoadingInfo)` (shows "Loading Top Side" or "Flip for Loading") and `@(SurfaceQuality)`. |
| **Textheight** | Double | `75` | Sets the height of the text annotation (in current drawing units). |
| **Color** | Integer | `40` | Sets the AutoCAD color index (0-256) for the text. |
| **Horizontal Alignment** | String | `Automatic` | Controls horizontal text placement. Options: Automatic, Left, Center, Right. "Automatic" calculates the best side based on the viewport center. |
| **Vertical Alignment** | String | `Automatic` | Controls vertical text placement. Options: Automatic, Bottom, Center, Top. "Automatic" positions text relative to the panel shadow or loading side. |
| **DimStyle** | String | *Sorted List* | Selects the Dimension Style to apply (controls font, text style, etc.). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add/Remove Format** | Opens a command-line list of available properties. Type the index number to add or remove that property from the Format string. |

## Settings Files
- **Filename:** N/A
- **Location:** N/A
- **Purpose:** This script does not rely on external settings files.

## Tips
- **CLT Panels:** Use the key `@(LoadingInfo)` in the Format property. It will automatically check if you are looking at the top or bottom of the panel and tell you if it needs to be flipped.
- **Automatic Alignment:** Keep Horizontal and Vertical Alignment set to "Automatic" to let the script snap the text to the clearest area near the panel or viewport center.
- **Editing Text:** Double-click the text or use the Properties Palette to change the `sFormat` string. You can combine multiple keys, e.g., `@(Name) - @(LoadingInfo)`.

## FAQ
- **Q: Why did my text disappear immediately after inserting it in Model Space?**
- **A:** The script automatically erases itself if the Format string resolves to an empty text string. Check your `sFormat` property and ensure the selected entity actually has the properties you are requesting.
- **Q: The "Surface Quality" text isn't showing up.**
- **A:** The `@(SurfaceQuality)` key only works if the view direction matches the positive or negative Z-axis of the panel. If viewing from an isometric angle, this data may be suppressed.
- **Q: What does "Flip for Loading" mean?**
- **A:** When using `@(LoadingInfo)`, the script compares your view direction to the panel's "World" Z direction. If you are looking at the back side (or a non-standard orientation for a floor/roof), it prompts you to flip the element to ensure the correct loading side is face up.