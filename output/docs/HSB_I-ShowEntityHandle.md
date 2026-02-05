# HSB_I-ShowEntityHandle

## Overview
This utility script allows you to select any object in the model and displays its unique internal identification code (Handle). It is designed for debugging or troubleshooting to help identify specific elements within the CAD database.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Standard usage in the 3D model. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | Not applicable to manufacturing drawings. |

## Prerequisites
- **Required Entities**: Any graphical entity in the drawing (beams, elements, lines, etc.).
- **Minimum Beam Count**: 0.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
- Command: Type `TSLINSERT` (or use the hsbCAD Catalog browser).
- Action: Select `HSB_I-ShowEntityHandle.mcr` from the list and click Open.

### Step 2: Select an Entity
```
Command Line: Select Entity
Action: Click on any object in the drawing area.
```
- The script will immediately display a report message showing the alphanumeric Handle ID of the selected object.

### Step 3: Continue or Finish
- **To check another object**: The prompt will reappear automatically. Click on the next entity.
- **To finish**: Press the `Esc` key or right-click to cancel. The script will remove itself from the drawing.

## Properties Panel Parameters
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| *None* | *N/A* | *N/A* | *This script runs interactively and does not create persistent properties.* |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| *None* | *No custom context menu options are provided.* |

## Settings Files
- **Filename**: None.
- **Location**: N/A.
- **Purpose**: N/A.

## Tips
- **Workflow Efficiency**: You can select multiple objects in succession without restarting the script. The prompt loops continuously until you cancel.
- **Auto-Cleanup**: The script instance erases itself automatically when you finish, keeping your drawing database clean.

## FAQ
- **Q: What is a Handle used for?**
- **A:** A Handle is a unique ID assigned by the system to every object. Developers or support staff often need this ID to locate specific data within the drawing file during debugging.
- **Q: How do I stop the script?**
- **A:** Simply press the `Esc` key on your keyboard when you are prompted to select an entity.