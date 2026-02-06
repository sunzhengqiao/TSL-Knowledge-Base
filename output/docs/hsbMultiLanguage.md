# hsbMultiLanguage.mcr

## Overview
This script is a configuration utility used to set the primary and secondary language for the current hsbCAD project. It allows you to define how textual output (such as dimensions, labels, and material lists) appears in generated drawings and reports.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is a setup tool intended to be run in the model space to configure project settings. |
| Paper Space | No | |
| Shop Drawing | No | This script does not generate geometry but configures settings used by other scripts. |

## Prerequisites
- **Required entities**: None
- **Minimum beam count**: 0
- **Required settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbMultiLanguage.mcr`

### Step 2: Configure Languages
```
Interface: Properties Palette (or ShowDialog)
Action: 
1. Locate the 'Languages' category in the Properties Palette.
2. Select the desired language from the 'Primary Language' dropdown.
3. (Optional) Select a second language from the 'Secondary Language' dropdown for bilingual output.
4. Close the Properties Palette or click OK to apply changes.
```

### Step 3: Complete
```
Action: The script updates the project database and automatically removes itself from the drawing.
Note: It is normal for the script instance to disappear immediately after insertion.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Primary Language (sLanguage1) | dropdown | |_Default| | Sets the main language for text output in drawings and reports (e.g., dimensions, labels). |
| Secondary Language (sLanguage2) | dropdown | |_Default| | Sets a secondary language for dual-language output. If Primary is set to |Disabled|, this language becomes the primary. |

**Supported Languages Include:**
Bulgarian, Croatian, Czech, Danish, Dutch, English, Estonian, Finnish, French, German, Greek, Hungarian, Italian, Japanese, Korean, Lithuanian, Norwegian, Polish, Portuguese, Romanian, Russian, Slovak, Slovenian, Spanish, Swedish, Turkish, Ukrainian, Mandarin.

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | This script runs once upon insertion and erases itself. Standard edit options do not apply to the instance. |

## Settings Files
- No external settings files are required for this script.

## Tips
- **Script Disappears**: Do not be alarmed if the script entity vanishes immediately after you run it. This is intended behavior; it writes the settings to the drawing database and then cleans itself up.
- **Clearing Settings**: To remove specific language overrides and revert to system defaults, set both the Primary and Secondary Language options to `|Disabled|`.
- **Fallback Logic**: If you leave the Primary Language empty or disabled, the script will automatically use the Secondary Language as the primary output language.

## FAQ
- **Q: Can I use this script to change the language of an existing single drawing element?**
  - A: No, this script sets the global project language configuration stored in the drawing database. It affects how other scripts and hsbCAD functions generate new text.
- **Q: How do I reset the language back to the CAD system default?**
  - A: Run the script again and set the Primary Language to `|Disabled|`. The script will clear the custom language entry from the database.