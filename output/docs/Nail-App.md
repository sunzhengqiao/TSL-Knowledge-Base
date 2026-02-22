# Nail-App

## Overview
Batch-applies nailing rules to selected timber elements based on a stored XML configuration. The script reads rule sets from `Nail-Configuration.xml`, removes any existing nail lines and nailing TSL instances on each selected element, then creates new `Nail-SheetOnBeam` and/or `Nail-SheetOnSheet` instances according to the rules. The script erases itself after execution -- it acts purely as a generator tool.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary operating environment |
| Paper Space | No | Not supported |
| Shop Drawing | No | Not supported |

## Script Metadata
| Property | Value |
|----------|-------|
| Type | O (Object) |
| Version | 1.5 |
| Keywords | Nailing; Nail; Element; CNC |
| Required Beams | 0 |
| Plugin Mode | Supported (v1.5+) |

## Prerequisites
- **Configuration file**: `Nail-Configuration.xml` must exist in the company path (`_kPathHsbCompany\TSL\Settings\`) or the install path (`_kPathHsbInstall\Content\General\TSL\Settings\`).
- **Child scripts**: `Nail-SheetOnBeam` and `Nail-SheetOnSheet` must be installed; these are the scripts actually created on the elements.
- **Elements with sheets**: Target elements must contain at least one sheet. Elements without sheets are skipped.

## Usage Steps

### Step 1: Launch
Run `TSLINSERT` and select `Nail-App`, or use the command line alias: `(hsb_ScriptInsert "Nail-App")`.

### Step 2: Select Configuration
If multiple configurations exist in the settings file, a dialog appears to choose the desired rule set. If only one configuration exists, this step is skipped.

### Step 3: Select Elements
At the prompt "Select elements", click on the wall, floor, or roof elements to process. Press Enter to confirm.

### Step 4: Automatic Processing
For each selected element the script:
1. Removes all existing nail lines on the element.
2. Removes all existing `Nail-SheetOnBeam` / `Nail-SheetOnSheet` instances on the element.
3. Creates new TSL instances for each rule defined in the selected configuration, passing the stored property values (PropInt, PropDouble, PropString) to each child script.
4. Erases itself from the drawing.

## Properties Panel Parameters
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Configuration | String (dropdown) | First available | Selects which named rule set to apply from the settings file. |

## Settings File
- **Filename**: `Nail-Configuration.xml`
- **Lookup order**: Company path first, then install path.
- **Version check**: On creation the script compares the version stored in the drawing (MapObject) against the version in the XML file and warns if they differ.
- **Import/Export**: Use the hsbCAD ribbon command "XML-Settings" or the `hsbTslSettingsIO` script to transfer configurations between drawings.

## Tips
- This is a self-deleting tool. After execution only the child nailing TSLs remain on the elements. To change nailing, either edit the child TSL properties or re-run Nail-App with a different configuration.
- Configurations are created by running `Nail-SheetOnBeam` or `Nail-SheetOnSheet` individually, adjusting properties, and saving rules via their context commands.
- The script supports plugin mode (silent execution) via `_kExecuteKey` -- catalog entries or the last-inserted preset can be applied without a dialog.

## Related Scripts
| Script | Relationship |
|--------|-------------|
| Nail-SheetOnBeam | Child -- created by Nail-App to define sheet-to-beam nailing |
| Nail-SheetOnSheet | Child -- created by Nail-App to define sheet-to-sheet nailing |
| hsbTslSettingsIO | Utility for importing/exporting the XML configuration |
