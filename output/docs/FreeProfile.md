# FreeProfile.mcr

## Overview
Creates custom free-form milling or cutting operations (grooves, slots, contours) on timber beams based on a user-defined path. This tool is ideal for complex geometries where standard rectangular or circular cuts are insufficient, allowing for tool path definition via points, circles, or existing openings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates on 3D GenBeam entities. |
| Paper Space | No | Not applicable for 3D machining operations. |
| Shop Drawing | No | This is a 3D model generation script. |

## Prerequisites
- **Required Entities:** At least one `GenBeam` (Timber Beam).
- **Optional Entities:** `PLine`, `Circle`, or `Element` (for defining path geometry).
- **Minimum Beam Count:** 1 (Second beam is optional).
- **Required Settings:** `FreeProfile.xml` (Required only for using presets or saving configurations).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Select `FreeProfile.mcr` from the list.

### Step 2: Select Primary Beam
```
Command Line: Select beam:
Action: Click on the timber beam you wish to machine.
```

### Step 3: Select Secondary Beam (Optional)
```
Command Line: Select second beam (or press Enter to skip):
Action: 
- If the cut involves an intersection with another beam, select the second beam.
- Otherwise, press Enter to proceed with the single beam.
```

### Step 4: Select Reference Face
```
Command Line: Select face:
Action: Move your cursor over the beam. A dynamic preview of the profile will appear on different faces.
Click to select the desired face (e.g., Top, Bottom, Left, Right) where the machining should start.
```

### Step 5: Define Profile Path
The script offers multiple ways to define the shape of the cut.
```
Command Line: [Pick Point / Select Circle / Select Opening]:
Action: Choose one of the following methods:
```
- **Option A (Pick Point):** Click points on the face to draw a custom polyline. Press Enter to finish the shape.
- **Option B (Select Circle):** Type `S` (if mapped) or select the circle option, then click an existing Circle entity in the drawing to use its shape.
- **Option C (Select Opening):** Type `O` (if mapped) or select the opening option, then click an existing Opening or Element to trace its contour.

### Step 6: Finalize
The script generates the 3D representation of the tool path and applies the machining operation to the beam.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Diameter** | Number | 20 mm | The diameter of the milling cutter or saw blade. Defines the width of the cut. |
| **Length** | Number | 0 mm | The working length/reach of the tool. A value of 0 typically implies infinite or maximum depth. |
| **ToolIndex** | Integer | 4 | The CNC machine tool number (e.g., T4) assigned to this operation for manufacturing data. |
| **Name** | Text | Millhead | The descriptive name of the tool configuration. Changing this can trigger preset loading if it matches an XML entry. |
| **Vertical Milling Head** | Dropdown | No | Determines tool orientation. "Yes" = perpendicular to surface; "No" = parallel to beam axis. |
| **Accuracy** | Number | dEps | Tolerance for converting curves to straight lines (0 = true curves, higher value = faceted). |
| **Color Reference Side** | Integer | 40 | AutoCAD color index for the tool path on the selected face. |
| **Color Top Side** | Integer | 40 | AutoCAD color index for the tool path on the opposite face. |
| **Transparency** | Integer | 90 | Transparency level of the tool body visualization (0 = Opaque, 100 = Invisible). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Configure Tool** | Opens a dialog box to edit Tool Name, Diameter, Length, Index, and other parameters in a centralized form. |
| **Flip Side** | Moves the profile path from the current reference face to the opposite face of the beam. |
| **Create defining polyline** | Locks the profile by converting the dynamic grip path into a static polyline entity. Removes editing grips. |
| **Create defining grips** | Unlocks the profile by converting a static polyline back into dynamic grips, allowing geometric edits. |
| **Import Settings** | Loads tool parameters (Diameter, Index, etc.) from an external `FreeProfile.xml` file. |
| **Export Settings** | Saves the current tool parameters to `FreeProfile.xml` for future reuse. |

## Settings Files
- **Filename**: `FreeProfile.xml`
- **Location**: Company or Install path (configured in hsbCAD settings).
- **Purpose**: Stores predefined tool configurations (presets). This allows you to save specific tool diameters and CNC indices and load them later via the "Name" property or Import function.

## Tips
- **Previewing Faces:** Use the "Select Face" step carefully; the visual preview shows exactly where the material will be removed.
- **Complex Shapes:** Use the "Pick Point" option to draw custom slots or tenons that aren't simple rectangles.
- **CNC Export:** Always check the **ToolIndex** property. If this number does not match a tool in your CNC machine's database, the manufacturing output may fail or default to a generic tool.
- **Locking Geometry:** Once a profile is exactly where you want it, use the **Create defining polyline** context menu option. This prevents accidental shifts if the beam geometry changes slightly.

## FAQ
- **Q: Can I use this to cut a hole all the way through the beam?**
  A: Yes. Define the path and ensure the **Length** parameter is sufficient to penetrate through the beam, or ensure the depth/height of the path geometry exceeds the beam's dimensions relative to the start face.
- **Q: What does "Accuracy = 0" do?**
  A: It tells the CAM system to export the path as true mathematical curves (Arcs). If you set a value > 0, curves are broken into small straight line segments.
- **Q: Why can't I edit the shape anymore?**
  A: The profile might be locked as a static polyline. Right-click the script instance and select **Create defining grips** to restore the edit handles.