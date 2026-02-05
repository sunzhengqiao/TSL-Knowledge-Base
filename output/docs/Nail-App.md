# Nail-App

## Overview
Automatically applies nailing patterns to selected timber elements (such as walls or floors) based on predefined engineering configurations. This script spawns detailed sub-scripts to generate the geometry and then deletes itself.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the model. |
| Paper Space | No | Not supported in layouts. |
| Shop Drawing | No | Not intended for shop drawing generation. |

## Prerequisites
- **Required Entities**: Element (e.g., a Wall or Floor panel).
- **Minimum Beam Count**: N/A (Requires an Element containing beams/sheets).
- **Required Settings**:
  - `Nail-Configuration.xml` (Must exist in Company or Install settings path).
  - Helper scripts `Nail-SheetOnBeam` and `Nail-SheetOnSheet` must be installed.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Nail-App.mcr` from the list.

### Step 2: Select Configuration
```
Command Line: (Dynamic Dialog appears if multiple configurations exist)
Action: Select the desired Nailing Rule Set from the drop-down list (e.g., "Roof Sheathing 150/300").
```
*Note: If only one configuration exists in the settings file, this step may be skipped automatically.*

### Step 3: Select Elements
```
Command Line: |Select elements|
Action: Click on the Element(s) (Walls/Floors) you wish to apply nailing to. Press Enter to confirm selection.
```

### Step 4: Processing
The script will automatically remove any existing nail lines and TSL instances on the selected elements and generate the new nailing patterns.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Configuration | dropdown | (First item in list) | Defines the name of the configuration (Rule Set) to apply. This determines nailing spacing, offsets, and nail types. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | The script instance erases itself immediately after execution, so there are no right-click menu options available after insertion. |

## Settings Files
- **Filename**: `Nail-Configuration.xml`
- **Location**: `_kPathHsbCompany\TSL\Settings` or `_kPathHsbInstall\Content\General\TSL\Settings\`
- **Purpose**: Stores the nailing rule configurations, including specific parameters for different connection types (Sheet to Beam, Sheet to Sheet).

## Tips
- **Self-Deleting Tool**: This script removes itself from the drawing immediately after running. To modify the nailing, you must edit the generated child TSLs or run the Nail-App tool again.
- **Cleanup**: The script automatically deletes existing nail lines and associated nailing TSLs on the selected elements before applying the new pattern.
- **Preparation**: Ensure your configurations are created in the XML file first (usually done by running the helper scripts individually and saving settings).

## FAQ
- **Q: Why did the tool disappear after I selected the elements?**
  A: This is intentional behavior. The "Nail-App" acts as a generator tool. It creates the specific nailing instances required and then self-destructs to keep the drawing clean.
- **Q: I get an error saying "No configurations found". What do I do?**
  A: The `Nail-Configuration.xml` file is likely empty or missing. You need to run the dependent scripts (like `Nail-SheetOnBeam`) to generate and save configurations to the settings file first.
- **Q: Can I edit the nails later?**
  A: Yes, but you cannot edit the "Nail-App" instance (since it is gone). You must modify the properties of the individual nailing instances (e.g., `Nail-SheetOnBeam`) that were created on the element, or re-run the Nail-App tool with a different configuration.