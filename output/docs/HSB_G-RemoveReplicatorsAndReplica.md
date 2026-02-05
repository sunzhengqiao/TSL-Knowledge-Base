# HSB_G-RemoveReplicatorsAndReplica.mcr

## Overview
This utility script removes all Replicator and Replica TSL instances from the current model. It clears the associated data links from Elements and Project properties, converting replicated assemblies into individual, static elements that no longer update via the replication logic.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script scans the entire Model Space to find relevant elements and TSL instances. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required entities**: Elements or TSL instances (specifically `HSB_E-Replicator` or `HSB_E-Replica`) must exist in the model.
- **Minimum beam count**: 0 (Safe to run on an empty or pre-cleaned model).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-RemoveReplicatorsAndReplica.mcr`

### Step 2: Trigger Execution
```
Command Line: |Select a position|
Action: Click anywhere in the Model Space.
```
**Note:** The specific location you click does not matter. This action is simply a trigger to initiate the cleanup process.

## Properties Panel Parameters
This script has no editable properties in the Properties Palette.

## Right-Click Menu Options
No custom right-click menu options are provided by this script.

## Settings Files
No external settings files are required or used by this script.

## Tips
- **Global Action:** This script processes the *entire* model automatically. You do not need to pre-select the specific replicators or elements you wish to clean.
- **Self-Cleaning:** The script instance deletes itself from the drawing immediately after finishing its task, so you do not need to erase it manually.
- **Data Finalization:** Use this script when you want to permanently break the link between a master element and its replicas, effectively "exploding" the replication logic while keeping the physical geometry intact.

## FAQ
- **Q: Will this delete my timber beams?**
  - **A:** No. It only deletes the "Replicator" and "Replica" script instances. The physical timber elements (GenBeams) remain in the model.
- **Q: Why would I use this?**
  - **A:** This is useful if you want to stop elements from updating automatically, if you are experiencing errors with broken replication links, or if you want to finalize the design and treat all elements as unique.
- **Q: Do I need to click on the specific Replicator script?**
  - **A:** No. You can click anywhere in the model space; the script finds all relevant replicator data automatically.