# mapIO_TslInstAttached.mcr

## Overview
This script is a background utility used by other hsbCAD scripts. It automatically scans a selected timber element to detect and report any other scripts (TSLs) already attached to it, acting as a conflict detector to prevent duplicate machining.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates invisibly within the model space when called by other scripts. |
| Paper Space | No | Not designed for 2D layout or detailing views. |
| Shop Drawing | No | Not intended for shop drawing generation. |

## Prerequisites
- **Required Entities:** The script is triggered by another script acting on a specific entity (e.g., a beam or wall).
- **Minimum Beam Count:** 0 (It processes a single entity passed to it).
- **Required Settings:** The target entity must belong to at least one construction group.

## Usage Steps

### Step 1: Automatic Execution
**Command:** None (Manual run is not supported).
This script runs automatically when called by another hsbCAD script via the `callMapIO` function. You do not need to launch it manually.

### Step 2: Background Scan
When the parent script executes, this utility performs the following checks automatically:
1. It verifies that the target entity belongs to a Group.
2. It scans the model for all TSL instances.
3. It filters these instances to find those attached to the target element.

### Step 3: Data Return
The script passes the list of found attached scripts back to the parent script. The parent script then decides whether to proceed with an action or display a warning (e.g., "Connector already exists").

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not persist in the drawing and therefore has no editable properties in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No custom context menu options are provided. The script instance is erased immediately after execution. |

## Settings Files
- **Filename:** None required.
- **Location:** N/A
- **Purpose:** This script relies solely on input parameters passed directly from the calling script.

## Tips
- **Group Membership:** Ensure your beams and panels are assigned to a construction group. If an element is not grouped, this script cannot find attached machining, and the parent script may fail to detect duplicates.
- **Debugging:** If you are a developer troubleshooting a calling script, you can enable the internal `reportDebug` flag (via code) to see scan details in the command line.

## FAQ
- **Q: I tried to insert this script, but it disappeared immediately.**
  - A: This is normal behavior. `mapIO_TslInstAttached.mcr` is a utility function designed only to be called by other scripts. It deletes itself if run manually because it cannot function without input from a parent script.
- **Q: I received a warning saying "The entity needs to be assigned to at least one group."**
  - A: The target timber element you are working on is not in a construction group. Use the hsbCAD grouping tools to assign the element to a group, then retry the operation.
- **Q: Can I use this to find all scripts on a beam?**
  - A: Not directly. You must run a parent script that utilizes this utility. The parent script can be configured to report what this utility finds.