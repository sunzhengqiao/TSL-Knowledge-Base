# mapIO_LayerAssignment.mcr

## Overview
This is a background utility script used to automatically organize timber elements into the correct hsbCAD Layers and Project Groups. It ensures that generated parts are sorted into the correct project structure (e.g., "House/Wall1") based on defined rules, typically invoked by other generation scripts.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates on entities within the structural model. |
| Paper Space | No | Not applicable for paper space or layouts. |
| Shop Drawing | No | Not used for creating shop drawing views. |

## Prerequisites
- **Source Entity**: An existing element (beam, machining part, etc.) must be passed to the script via MapIO.
- **Calling Script**: This script is designed to be called by another TSL script using `callMapIO`; it is not intended for standalone manual use.

## Usage Steps

### Step 1: Automatic Invocation
*Note: This script has no command line interface or user prompts. It runs automatically when triggered by a parent script.*

1.  The parent script passes the target entity and desired location data to `mapIO_LayerAssignment`.
2.  The script checks if the requested Project Group (Folder) exists.
3.  If the Group exists, the entity is added to it.
4.  If the Group does not exist, the script assigns the entity to a specific Layer or inherits the Layer/Group from a parent host element.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose parameters to the Properties Palette. All configuration is handled internally via MapIO inputs. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add items to the right-click context menu. |

## Settings Files
- **None**: This script does not use external settings or XML files.

## Tips
- **Default Sublayers**: The script intelligently defaults to Sublayer 'Z' (Structure) for Beams and 'T' (Other) for different entity types unless overridden.
- **Group vs. Layer**: The script first attempts to find a Project Group matching the input. If none is found, it treats the input as a standard Layer name.
- **Inheritance**: If exact Group assignment fails, the script can copy the organizational properties from a "Parent" entity (e.g., assigning a stud to the same layer as the wall it is contained in).

## FAQ
- **Q: I tried to insert this script but nothing happened.**
  - **A**: This is a utility script that runs and deletes itself immediately (`eraseInstance`) to prevent cluttering the drawing. It functions only when called by other scripts.
- **Q: How do I change the layer assignment logic?**
  - **A**: You must modify the script that is *calling* `mapIO_LayerAssignment`. The inputs (Layer name, Sublayer character) are determined by that parent script.