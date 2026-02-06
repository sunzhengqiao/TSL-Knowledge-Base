# hsbLayoutEntityTag.mcr

## Overview
Automates the creation of labeling tags (position numbers, dimensions, and attributes) for structural elements in Paper Space layouts. The script includes automatic clash detection to resolve overlapping tags and supports various graphical styles and content formats.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | Script operates on layout views. |
| Paper Space | Yes | Tags are generated directly on the layout sheet. |
| Shop Drawing | Yes | Designed for annotating production drawings and plans. |

## Prerequisites
- **Required Entities**: GenBeams, Sheets, Panels, WallElements, Openings, or TSL components must exist in the model.
- **Minimum Beam Count**: 0.
- **Required Settings**: A Paper Space Layout with at least one viewport defined is required.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbLayoutEntityTag.mcr` from the catalog list.

### Step 2: Configure Settings (Optional)
If the script does not automatically launch into input mode, a dialog may appear. Otherwise, proceed to the command line prompts. Initial properties can be adjusted in the Properties Palette (Ctrl+1) after insertion.

### Step 3: Select Viewport
```
Command Line: Select a viewport
Action: Click inside a viewport on the layout that displays the elements you wish to tag.
```

### Step 4: Place Script Reference
```
Command Line: Pick a point outside of paperspace
Action: Click a point in the layout (typically in blank space) to define the location of the script instance reference. The tags themselves will position automatically based on the entities in the viewport.
```

### Step 5: Customize Tags
Select the inserted script instance and open the **Properties Palette (Ctrl+1)**.
- Set **Type** (e.g., Beam, Panel) to filter elements.
- Set **Format** (e.g., `@(Length)`, `@(Posnum)`) to define tag content.
- Set **Style** to define the visual appearance (e.g., Border, Leader).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | dropdown | byZone | Defines the type of entity to collect (e.g., Beam, Panel, Opening, GenBeam). |
| TSL Names | text | | Specifies a list of TSL script names to filter specific components (separated by semicolons). |
| Format | text | | Defines the text content. Use `@(PropertyName)` for dynamic data (e.g., `@(Length:0)`). Separate multiple lines with a backslash `\`. |
| Zone | text | | Defines the zone to collect. If empty, it defaults to the current viewport's zone. |
| Dimstyle | dropdown | | Sets the dimension style for text font and arrow appearance. |
| Text Height | number | 0 | Defines the text height. **0** uses the Dimstyle default. |
| Color | number | -2 | Defines the color. **-2** = ByEntity, **-1** = ByLayer, **0** = ByBlock. |
| Orientation | dropdown | byEntity | Sets text rotation. Options: byEntity, Horizontal, Vertical. |
| Style | dropdown | Text only | Sets the graphical style (e.g., Text + Leader, Border, Filled Frame). |
| Behaviour | dropdown | Automatic | Controls numbering and dependencies. "Automatic" assigns missing posnums. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Viewport | Prompts to select an additional viewport to add tags from. (Also triggered by Double Click). |
| Add/Remove Format | Opens a list to easily add or remove attributes (like Length or Width) to the tag format. |
| Add/Remove TSL | Manages the list of TSL script names used for filtering. |
| Set Leader Offset | Adjusts the offset settings for leader lines. |
| Add No-Tag Area | Draws a rectangular area where tags are forbidden or moved away from. |
| Remove No-Tag Area | Removes previously defined exclusion zones. |

## Settings Files
- **Filename**: None defined.
- **Location**: N/A
- **Purpose**: Script relies on standard hsbCAD properties and internal logic.

## Tips
- **Clash Detection**: If tags are overlapping, try reducing the **Text Height** or increase the spacing of elements in the model. The script attempts to move tags automatically, but space is limited.
- **Formatting**: Use rounding in the format string for cleaner numbers. Example: `@(Length:0)` rounds to the nearest whole number.
- **Multi-Line Tags**: Use a backslash `\` in the **Format** property to stack text (e.g., `Posnum: @(Posnum)\nLen: @(Length)`).
- **ByZone vs Specific Type**: If **Type** is set to `byZone`, the script respects the **Zone** property. If a specific type (e.g., "Beam") is selected, the **Zone** property acts as a secondary filter.

## FAQ
- **Q: Why are no tags appearing in my layout?**
  **A:** Check the **Type** property to ensure it matches the entities in your model (e.g., if you have walls, ensure Type is set to "WallElement" or "Panel"). Also verify the selected viewport actually contains visible elements.
- **Q: How do I display dimensions like Length or Height?**
  **A:** In the **Format** property, type the attribute name inside parentheses prefixed with `@`. For example: `@(Length)` or `@(Height:1)`.
- **Q: Can I tag elements from multiple viewports on one sheet?**
  **A:** Yes. Use the right-click context menu and select **Add Viewport** to append additional views to the script instance.