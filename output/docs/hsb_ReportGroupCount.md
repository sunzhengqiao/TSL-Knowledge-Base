# hsb_ReportGroupCount.mcr

## Overview
This script counts the total number of sub-groups (typically representing floors) within the main project Group structure and displays the result in the AutoCAD command line. It serves as a quick verification tool to check how many distinct floor levels or sections have been defined in the current project.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is designed to analyze the main project structure in Model Space. |
| Paper Space | No | Not applicable for paper space layouts. |
| Shop Drawing | No | Does not interact with shop drawing views or detailing. |

## Prerequisites
- **Required entities**: A valid hsbCAD Group structure (main group with sub-groups) must exist in the drawing.
- **Minimum beam count**: None.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or insert via the hsbCAD Scripts menu)
```
Action: Select 'hsb_ReportGroupCount.mcr' from the file dialog list.
```

### Step 2: Place and Execute
```
Command Line: Specify insertion point:
Action: Click anywhere in the drawing area to place the script instance.
```

### Step 3: View Results
```
Command Line: [Output displays automatically]
Action: Observe the command line for the reported group count.
Note: The script instance will automatically erase itself after reporting.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script has no configurable properties. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add specific context menu options. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Check History**: If you miss the count on the command line, press **F2** to open the AutoCAD Text Window and view the command history.
- **Clean Up**: You do not need to manually delete the script object; it is programmed to remove itself automatically after running.
- **Project Verification**: Use this script after importing or generating a new project to ensure all floors were processed correctly.

## FAQ
- **Q: Why didn't a dialog box appear?**
  **A:** This is a command-line reporter tool. It outputs the text directly to the AutoCAD command line interface (CLI).
- **Q: The script reported 0 groups. What does that mean?**
  **A:** This means the script could not find any sub-groups within the main project Group. Ensure your drawing is structured with a main Group containing the floor elements.
- **Q: Did the script work? I don't see anything new in the drawing.**
  **A:** Yes, if you see text in the command line (e.g., "Total groups found: X"). The script is designed to be invisible and self-deleting.