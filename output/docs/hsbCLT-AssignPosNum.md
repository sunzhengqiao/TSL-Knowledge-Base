# hsbCLT-AssignPosNum

## Overview
This script interactively assigns sequential position numbers to CLT panels or panel references. It allows you to control the starting number and decide whether to overwrite existing numbers or preserve them, based on the order you select the panels in the model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script runs in the 3D model to modify panel attributes. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Not designed for detailing views. |

## Prerequisites
- **Required entities**: Panels (Sip), ChildPanels, or TslInst items must exist in the model.
- **Minimum beam count**: 0
- **Required settings files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-AssignPosNum.mcr` from the file browser.

### Step 2: Configure Properties
After selecting the script file, the Properties Palette (OPM) will appear automatically.
```
Action: Set the StartNumber and Keep existing number options.
```
- **StartNumber**: Enter the integer you want to begin the sequence with (e.g., 1, 100, 500).
- **Keep existing number**: Choose "No" to overwrite all selected panels, or "Yes" to skip panels that already have a number.

### Step 3: Select Panels
```
Command Line: Select panel or panel reference (item, child panel)
Action: Click on a panel in the model.
```
- You can click directly on a panel, or select a reference to a panel (such as a child panel or an item instance).

### Step 4: Continue Selection Loop
The script will assign the current number to the selected panel and increment the counter.
```
Command Line: Select panel or panel reference (item, child panel)
Action: Continue clicking panels to assign the next number in the sequence.
```

### Step 5: Finish
```
Action: Press Enter or Escape on the keyboard.
```
The script instance will erase itself automatically, leaving the numbered panels in the model.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| StartNumber | number | 1 | The number assigned to the first panel you select. Subsequent panels receive +1, +2, etc. |
| Keep existing number | dropdown | No | Determines how to treat panels that already have a position number. <br>**No**: Overwrites existing numbers with the new sequence.<br>**Yes**: Skips panels that are already numbered and only assigns numbers to unnumbered panels. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script runs immediately upon insertion and does not add persistent right-click menu options to entities. |

## Settings Files
- **Filename**: None required
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Reference Selection**: You can select panels that are grouped inside assemblies or references. The script will find the parent panel automatically.
- **Preventing Duplicates**: If you accidentally select the same panel twice in one session, the script will ignore the second selection to prevent duplicate numbering.
- **Batch Renumbering**: Use the "Keep existing number = No" setting to completely renumber a specific batch of panels starting from a specific index (e.g., starting a new phase at 100).

## FAQ
- **Q: Can I use this to number just one panel?**
  - A: Yes. Select the panel and press Enter immediately to assign just the start number.
- **Q: What happens if I select a panel that already has number 10, but my StartNumber is 1?**
  - A: It depends on the "Keep existing number" setting. If "No", the panel loses the 10 and gets assigned 1. If "Yes", the panel keeps 10, and your StartNumber (1) is assigned to the next unnumbered panel you select.
- **Q: Why did the script disappear after I pressed Enter?**
  - A: This is a single-use utility script. It automatically erases itself after the numbering task is complete to keep your drawing clean.