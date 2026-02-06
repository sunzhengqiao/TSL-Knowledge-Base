# hsbCLT-CloneXRefChild.mcr

## Overview
Clones CLT child panels from external reference (XRef) drawings into the current model, with options to either insert loose panels for manual placement or generate a fully configured manufacturing assembly wrapped in a MasterPanel.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates entirely in 3D Model Space to generate structural elements. |
| Paper Space | No | Not supported for layout generation. |
| Shop Drawing | No | This is a model generation tool, not a detailing script. |

## Prerequisites
- **Required Entities**: An XRef drawing containing `ChildPanel` or `MasterPanel` entities must be loaded in the current drawing.
- **Catalog Entries**: A valid catalog entry for the script `klhMasterPanelManager` is required if using the "Childs + Master panel" option.
- **Styles**: Valid `MasterPanelStyle` and `SipStyle` definitions must exist in the catalog to assign attributes to the cloned panels.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-CloneXRefChild.mcr`

### Step 2: Configure Options
```
Action: A dialog appears automatically upon insertion.
Select Option:
1. "Only Childs": Imports loose panels based on a selected point.
2. "Childs + Master panel + klhMasterPanelManager": Creates a new MasterPanel group and assigns a management script automatically.
```

### Step 3: Select Entities
```
Command Line: |Select entitys|
Action: Click on the CLT panels (ChildPanels) in the XRef that you want to clone into the current model.
```

### Step 4: Select Insertion Point (Conditional)
```
Command Line: |Select point|
Condition: Only appears if "Only Childs" was selected in Step 2.
Action: Click in the Model Space to define the origin point where the loose panels will be placed.
Note: If "Childs + Master panel..." was selected, this step is skipped; the new assembly is placed automatically.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Option | dropdown | Only Childs | Defines the scope of the cloning operation. <br>**Only Childs**: Places loose geometry at a user-defined point.<br>**Childs + Master panel...**: Generates a manufacturing-ready group with nesting structures and automation scripts. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | The script instance removes itself from the drawing immediately after execution. No context menu options are available on the script instance. |

## Settings Files
- **Catalog Entry**: `klhMasterPanelManager`
- **Location**: hsbCAD Catalog (TSL Scripts)
- **Purpose**: Provides the production logic and automation for the generated MasterPanel when Option 2 is used.

## Tips
- **Production Workflow**: Use the "Childs + Master panel + klhMasterPanelManager" option when preparing data for manufacturing. This creates nesting groups and applies the necessary management script automatically.
- **Manual Layout**: Use the "Only Childs" option if you need to manually position panels or integrate them into an existing structure not handled by the master panel logic.
- **XRef Management**: Ensure the XRef is loaded and unloaded correctly before running the script to ensure the entity selection detects the geometry properly.

## FAQ
- **Q: Why didn't the script ask me for an insertion point?**
- **A:** You likely selected the "Childs + Master panel + klhMasterPanelManager" option. This mode calculates the placement automatically to fit the new MasterPanel container, bypassing the manual point selection.
- **Q: What happens to the original panels in the XRef?**
- **A:** The original panels remain untouched in the XRef. The script creates new copies (clones) in the current model.
- **Q: Can I use this on standard beams?**
- **A:** No, this script is designed specifically for CLT panels (`ChildPanel` and `MasterPanel` entities).