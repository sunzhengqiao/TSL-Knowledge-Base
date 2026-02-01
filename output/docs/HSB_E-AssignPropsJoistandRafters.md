# HSB_E-AssignPropsJoistandRafters

## Overview
This script allows you to batch assign properties (such as Name, Material, Grade, and Production Codes) to floor joists and roof rafters. It automatically identifies horizontal beams as joists and sloped beams as rafters, updating only fields that are currently empty to preserve your existing data.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model where Floor or Roof elements exist. |
| Paper Space | No | Not designed for layout views or shop drawings. |
| Shop Drawing | No | Does not process 2D drawings. |

## Prerequisites
- **Required Entities**: Floor or Roof elements containing beams.
- **Minimum Beam Count**: 1 beam within the selected element(s).
- **Required Settings**: None (properties are set via the Properties Panel).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Select `HSB_E-AssignPropsJoistandRafters.mcr` from the list and click **Open**.

### Step 2: Configure Properties
If you are running the script manually (without a predefined Catalog key):
1.  The **Properties Palette** (OPM) will open automatically.
2.  Set the default values for Joists and Rafters.
3.  Click the "Close" button or simply click back into the drawing area to proceed.

### Step 3: Select Elements
```
Command Line: Select elements
Action: Click on the Floor or Roof elements you wish to process.
```
1.  Select one or more elements in the model.
2.  Press **Enter** or **Space** to confirm.
3.  The script will process the beams and attach itself to the elements.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Sequence number** | number | 0 | Determines the execution order of this script during automated construction generation. |
| **Name Joists** | text | (empty) | The entity name assigned to floor joists. |
| **Name Rafters** | text | (empty) | The entity name assigned to roof rafters. |
| **Material Joists** | text | (empty) | The timber material code for joists (e.g., C24). |
| **Material Rafters** | text | (empty) | The timber material code for rafters. |
| **Grade Joists** | text | (empty) | The structural strength grade for joists. |
| **Grade Rafters** | text | (empty) | The structural strength grade for rafters. |
| **Information Joists** | text | (empty) | Additional notes or handling instructions for joists. |
| **Information Rafters** | text | (empty) | Additional notes or handling instructions for rafters. |
| **Label Joists** | text | (empty) | The primary label used for joists in drawings and production lists. |
| **Label Rafters** | text | (empty) | The primary label used for rafters in drawings and production lists. |
| **SubLabel Joists** | text | (empty) | A secondary label for sorting or grouping joists. |
| **SubLabel Rafters** | text | (empty) | A secondary label for sorting or grouping rafters. |
| **SubLabel2 Joists** | text | (empty) | A tertiary categorization label for joists. |
| **SubLabel2 Rafters** | text | (empty) | A tertiary categorization label for rafters. |
| **Beamcode Joists** | text | (empty) | Production code often used to trigger specific machining or nesting logic for joists. |
| **Beamcode Rafters** | text | (empty) | Production code often used to trigger specific machining or nesting logic for rafters. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific custom options to the entity right-click menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on the Properties Palette for configuration; no external settings files are required.

## Tips
- **Smart Update**: The script only updates fields that are currently empty. If you have already manually named a specific beam, running this script will not overwrite your custom entry.
- **Orientation Detection**: The script determines if a beam is a "Joist" or "Rafter" based on its slope. Beams perfectly horizontal (perpendicular to World Z) are treated as Joists; sloped beams are treated as Rafters.
- **Catalog Use**: To speed up workflow, you can create a Catalog entry with pre-filled properties (e.g., a standard "C24 Roof" preset). Running the script via this catalog will skip the Properties Palette step and apply the saved settings immediately.

## FAQ
- **Q: Why didn't the script update the Material for my specific beam?**
  **A:** The script is designed to preserve data. It will only fill in a field (like Material) if that field is currently empty on the beam. Check if the beam already has a value assigned.
- **Q: How does it distinguish between a floor joist and a roof rafter?**
  **A:** It checks the geometry. If the beam is horizontal (flat), it uses the "Joist" settings. If the beam is sloped, it uses the "Rafter" settings.
- **Q: Can I use this on Wall elements?**
  **A:** No, the script is specifically designed for Floor and Roof elements (using the `ElementRoof` filter).