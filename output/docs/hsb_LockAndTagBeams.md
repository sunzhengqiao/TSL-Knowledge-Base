# hsb_LockAndTagBeams.mcr

## Overview
This utility script protects selected structural beams from being deleted or losing their connection to their parent element during automated model processes. It applies a specific 'NoErase' tag to the selected beams, ensuring they are preserved during updates, element splitting, or export routines.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary execution environment. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required entities**: Structural Beams (GenBeam) that belong to an Element.
- **Minimum beam count**: 1 or more.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_LockAndTagBeams.mcr`

### Step 2: Select Beams
```
Command Line: Select beams
Action: Click on the beams in the 3D model that you want to lock and protect. Press Enter to confirm the selection.
```

### Step 3: Automatic Processing
Action: The script will automatically run in the background. It will link the selected beams to their parent Element and apply the 'NoErase' attribute. The script instance will remove itself from the drawing immediately upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script has no editable properties in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add specific options to the right-click context menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- Use this script before running major model regeneration or export routines to safeguard critical structural members.
- Ensure the beams you select are already part of an Element; the script relies on finding the parent Element to function correctly.
- The process is instantaneous; the script will disappear from the drawing immediately after processing the beams.

## FAQ
- **Q: What happens if I run this script on a beam that is not part of an Element?**
  - A: The script may fail to tag the beam correctly because it cannot find a parent handle. Ensure beams are properly assigned to Elements before running.
- **Q: How can I remove the "NoErase" tag?**
  - A: This script acts as a "lock." You would typically need to use a complementary "Unlock" script or manually edit the beam attributes via the hsbCAD Entity Properties to remove the map entry named 'NoErase'.
- **Q: Does this script change the geometry of the beam?**
  - A: No. It only changes internal data attributes regarding the beam's relationship to its parent element and its deletion protection status.