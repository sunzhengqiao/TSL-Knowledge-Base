# HSB_G-AttachMapXAsPropSet

## Overview
This utility extracts hidden internal data (MapX) from selected timber elements and converts it into standard AutoCAD Property Sets. This allows you to view and edit this metadata directly in the Properties Palette, making the data accessible for filtering, labeling, and exporting.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Select elements directly from the drawing. |
| Paper Space | No | Not designed for layout viewports. |
| Shop Drawing | No | Use only in the model environment. |

## Prerequisites
- **Required entities**: At least one entity (beam, panel, etc.) in the model that contains hidden MapX data.
- **Minimum beam count**: 1
- **Required settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-AttachMapXAsPropSet.mcr`

### Step 2: Select Entities
```
Command Line: Select one or more entities
Action: Click on the timber elements you wish to process and press Enter.
```
*Note: The script will automatically create Property Set definitions for any data found and then erase itself from the drawing.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not use editable parameters in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No custom right-click menu options are available for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Data Cleanup**: After the script successfully converts the data, the original hidden MapX data is removed from the entity to prevent data duplication.
- **Nested Data**: If the hidden data is structured in folders (nested maps), the script creates Property Set names using a dot separator (e.g., `Production.Info`).
- **Verification**: To verify the results, press `Ctrl+1` to open the Properties Palette, select a processed element, and look for the newly attached Property Sets.

## FAQ
- **Q: What if I see a warning "No entitie selected"?**
  A: You must click on at least one object in the drawing before pressing Enter. Run the script again and make a selection.
- **Q: Where can I see the data after running the script?**
  A: Select an element and open the AutoCAD Properties Palette (Ctrl+1). The new properties will appear in the list, often under a category specific to the data found.