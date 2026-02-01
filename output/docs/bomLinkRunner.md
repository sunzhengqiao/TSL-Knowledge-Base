# bomLinkRunner.mcr

## Overview
This script facilitates the export of timber model data (geometry, materials, and machining) to an external BOMLink system or specific production file formats. It acts as a bridge between the hsbCAD model and external manufacturing or procurement software.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script explicitly collects entities from Model Space. |
| Paper Space | No | Not designed for Paper Space entities. |
| Shop Drawing | No | Not intended for use within Shop Drawing layouts. |

## Prerequisites
- **Required Entities**: At least one hsbCAD Entity (beams, walls, etc.) in the model.
- **Minimum Beam Count**: 0 (Can export empty sets if configured, though usually requires data).
- **Required Settings**:
  - `hsbSoft.BomLink.Tsl.dll`: The external .NET assembly provided by hsbSoft must be installed and accessible.
  - **BOMLink Configuration**: Valid BOMLink projects must be defined in the configuration. A default project can be set via the Project Map (`HSB_PROJECTSETTINGS` -> `BOMLINKPROJECT`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or run via Catalog)
Action: Select `bomLinkRunner.mcr` from the file dialog or catalog entry.

### Step 2: Select Entities
```
Command Line: Select entities, <Enter> to select all
Action: Click the specific beams or elements you wish to export, or press Enter to export the entire model.
```

### Step 3: Configure Project (If required)
*If a default project is not found in the Project Settings, or if multiple projects are available:*
- A dialog box will appear listing available BOMLink Projects.
- Select the appropriate Project (e.g., specific factory or ERP context) and click OK.

### Step 4: Configure Output
*Once the project is set, a dialog will appear listing available Outputs for that project:*
- Select the desired Output type (e.g., ProductionData, CutList, XML_Export).
- Click OK to proceed.

### Step 5: Execution
- The script will gather the model data and pass it to the BOMLink engine.
- The script instance will automatically erase itself from the drawing.
- Check the AutoCAD command line for a "Success" or error message.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Project** | dropdown (PropString) | *Retrieved from Project Map* | Defines the current bomLink Project context. Changing this updates the available Output options. |
| **Output** | dropdown (PropString) | *First available option* | Defines the specific type of export or destination (e.g., CSV, PXML) for the selected Project. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | The script instance erases itself immediately after execution. Standard context menus are not available post-run. |

## Settings Files
- **BOMLink Configuration**: External configuration files managed by the `hsbSoft.BomLink.Tsl.dll`.
- **Project Map Key**: `HSB_PROJECTSETTINGS` -> `BOMLINKPROJECT`.
  - **Purpose**: Stores the default BOMLink project for the drawing, allowing the script to run without prompts if the setting is already defined.

## Tips
- **Full Model Export**: To export everything quickly, simply press `Enter` immediately when prompted to select entities.
- **Automation**: If you set the `BOMLINKPROJECT` key in your Project Map settings, the script can skip the Project Selection dialog, speeding up the workflow.
- **Debugging**: If the script disappears but you suspect an error, check the AutoCAD command line history. Any failure messages from the BOMLink engine will be displayed there.

## FAQ
- **Q: Why did the script disappear immediately after I inserted it?**
  - A: This is normal behavior. The script runs the export task and then erases itself (`eraseInstance`) to prevent cluttering the drawing with utility scripts.
- **Q: How do I export only specific walls?**
  - A: When the command line prompts "Select entities", manually click the specific walls or beams you want. Do not press Enter.
- **Q: I got an error "No Projects could be found". What do I do?**
  - A: This means the external BOMLink configuration is missing or empty. Contact your CAD Manager to ensure the `hsbSoft.BomLink.Tsl.dll` and its configuration files are correctly installed.