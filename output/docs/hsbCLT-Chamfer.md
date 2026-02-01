# hsbCLT-Chamfer

## Description

This TSL tool creates polyline-based chamfers on CLT (Cross-Laminated Timber) panels. Chamfers are angled cuts applied to panel edges, contours, or openings, commonly used for aesthetic finishing or structural connections. The tool supports multiple insertion modes to accommodate different chamfer application scenarios.

## Script Type

**O-Type (Object Tool)** - This is an object-based tool that modifies CLT panels by adding chamfer cuts.

## Properties

The following properties can be configured in the AutoCAD Properties Palette (OPM):

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **(A) Insertion Mode** | String (Selection) | Contour | Defines how the chamfer is applied. Options: Contour, Openings, Contour & Openings, Feed Direction, Polyline, Path |
| **(B) Alignment** | String (Selection) | Reference Side | Specifies which side of the panel receives the chamfer. Options: Reference Side, Opposite Side, Both Sides |
| **(C) Length** | Double | 4 mm | The chamfer length (leg of the 45-degree cut) |

### Insertion Mode Options

- **Contour**: Applies chamfer to the outer contour of the selected panel(s)
- **Openings**: Applies chamfer to openings (windows, doors) in the panel
- **Contour & Openings**: Applies chamfer to both the outer contour and all openings
- **Feed Direction**: Automatically detects and applies chamfer based on CNC feed direction
- **Polyline**: Allows selection of existing polylines or manual point picking to define chamfer path
- **Path**: Enables path selection by picking start and end points along panel edges

### Alignment Options

- **Reference Side**: Applies chamfer to the reference (front) side of the panel
- **Opposite Side**: Applies chamfer to the opposite (back) side of the panel
- **Both Sides**: Applies chamfer to both sides of the panel

## Usage Workflow

### Step 1: Launch the Tool
Insert the hsbCLT-Chamfer tool from the TSL library or run it via command.

### Step 2: Configure Properties
A dialog will appear allowing you to:
1. Select or create a catalog entry for saved settings
2. Choose the **Insertion Mode** based on where you want the chamfer
3. Set the **Alignment** (which side of the panel)
4. Specify the **Length** of the chamfer

### Step 3: Select Panels
When prompted with "Select panel(s)", select one or more CLT panels (Sip elements) to receive the chamfer.

### Step 4: Define Chamfer Location (varies by mode)

**Contour / Contour & Openings Mode:**
- The tool automatically creates chamfers along the panel contour
- If openings are included, all openings receive chamfers

**Openings Mode:**
- Pick points inside openings to select them
- Press Enter to select all openings, or click to toggle selection
- Click inside an opening again to deselect it

**Feed Direction Mode:**
- The tool automatically detects the CNC feed direction
- Chamfers are applied to edges perpendicular to the feed direction

**Polyline Mode:**
- Select existing polylines, or
- Press Enter to pick points manually
- Pick start point, then subsequent points to define the chamfer path
- Press Enter to finish

**Path Mode:**
- Pick start point on a panel edge
- Pick end point on the same ring (contour or opening)
- Use "S" (Swap Direction) to reverse the path direction if needed
- Press Enter to accept the path

### Step 5: Result
The chamfer tool is created and applied to the selected panel(s). The chamfer will automatically recalculate if the panel geometry changes.

## Context Menu Commands

Right-click on an inserted hsbCLT-Chamfer instance to access these commands:

| Command | Description |
|---------|-------------|
| **Add entities** | Add additional panels to the chamfer tool |
| **Remove entities** | Remove panels from the chamfer tool |
| **Show polyline** | Display the defining polyline (if currently hidden) |
| **Hide polyline** | Hide the defining polyline (if currently visible) |

**Note:** Double-clicking the chamfer instance will toggle the polyline visibility.

## Ribbon/Palette Commands

The following LISP commands can be used to control chamfer visibility from ribbon buttons or tool palettes:

- **Show polyline:**
  ```
  ^C^C(defun c:TSL_ShowChamferPolyline() (hsb_RecalcTslWithKey (_TM "|Show polyline|") (_TM "|Select chamfer tool(s)|"))) TSL_ShowChamferPolyline
  ```

- **Hide polyline:**
  ```
  ^C^C(defun c:TSL_HideChamferPolyline() (hsb_RecalcTslWithKey (_TM "|Hide polyline|") (_TM "|Select chamfer tool(s)|"))) TSL_HideChamferPolyline
  ```

## Technical Notes

- The chamfer creates a 45-degree angled cut with equal leg lengths
- For curved edges, the tool generates propeller surface cuts for accurate CNC machining
- Inner corners are automatically handled with mitre cuts to ensure clean geometry
- The tool supports multiple panels with the same orientation (parallel Z-axis)
- When the defining polyline is deleted, the chamfer instance auto-erases

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.2 | 22 Jan 2018 | thorsten.huck@hsbcad.com | Added custom command and double-click behavior to toggle polyline visibility |
| 1.1 | 24 May 2017 | thorsten.huck@hsbcad.com | Solid cleanup of concave corners |
| 1.0 | 15 Nov 2016 | thorsten.huck@hsbcad.com | Initial release |
