# hsbTranslatedText.mcr

## Overview
This script inserts a multi-lingual text annotation into the 3D model. It automatically translates keywords based on the active project language or custom language dictionaries, allowing for dynamic labels that update when language settings change.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary usage environment. |
| Paper Space | No | Not designed for 2D layout views. |
| Shop Drawing | No | Not intended for manufacturing drawings. |

## Prerequisites
- **Required Entities**: None.
- **Minimum Beam Count**: 0.
- **Required Settings**: 
  - MapObject `hsbTSL` with key `Languages` (required only if using "Custom" language modes).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `hsbTranslatedText.mcr` from the list and press Enter.

### Step 2: Pick Insertion Point
```
Command Line: Pick insertion point:
Action: Click in the Model Space to place the text annotation.
```

### Step 3: Configure Text
Action: Select the newly inserted text entity. Open the **Properties Palette** (Ctrl+1) to edit the text content, style, and translation settings.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Text | Text | | The main text to display. Enclose keywords in pipe characters (e.g., `|Beam|`) to enable automatic translation. |
| Prefix | Text | | Static text added before the main text. This is not translated. |
| Suffix | Text | | Static text added after the main text. This is not translated. |
| Alignment | Dropdown | |Left| | Sets the horizontal justification (Left, Center, Right). |
| Vertical | Dropdown | |Center| | Sets the vertical justification (Bottom, Center, Top). |
| XY-Orientation | Dropdown | |Horizontal| | Sets the text direction. Select "Vertical" to rotate text 90 degrees. |
| Language Mode | Dropdown | |Current| | Determines the translation source: Current project language, or Custom 1/2/1+2 (requires hsbTSL MapObject). |
| DimStyle | Dropdown | <Active> | Selects the visual style (font, line type) from available dimension styles. |
| Text Height | Number | U(20) | The height of the text characters in model units. |
| Color | Number | 251 | The AutoCAD color index (ACI) for the text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the text display if properties, language settings, or the text position have changed. |

## Settings Files
- **Filename**: `hsbTSL` (MapObject within drawing)
- **Location**: Drawing Dictionary
- **Purpose**: Stores the names and definitions of Custom Languages (Custom 1, Custom 2) used for the translation logic.

## Tips
- **Translation Syntax**: To use the translation feature, ensure the keyword in the "Text" property is wrapped in pipe characters (e.g., `|Wall|`). If you type plain text without pipes, it will display exactly as typed.
- **Custom Languages**: If you select "Custom 1" or "Custom 2" but the text does not translate, ensure the drawing contains the `hsbTSL` MapObject with the correct language definitions.
- **Orientation**: Use the "XY-Orientation" property to quickly flip text from horizontal to vertical without rotating the entire object manually.

## FAQ
- **Q: My text shows as `|Keyword|` instead of the translated word.**
  - A: The keyword `|Keyword|` might not exist in your current project language dictionary. Check your standard language files or switch the "Language Mode" to "Current" to ensure you are using the correct dictionary.
- **Q: How do I display two languages at once?**
  - A: Set the "Language Mode" property to `|Custom 1+2|`. This will display the translation for Custom 1 and Custom 2 separated by a slash (e.g., `Stab / Wall`).
- **Q: Can I add units that don't translate?**
  - A: Yes. Type the unit in the "Suffix" property (e.g., " mm"). The suffix is added to the end of the translated text and remains static.