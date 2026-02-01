# HSB_G-SolidContainer

A diagnostic tool for comparing imported solid geometry with the actual GenBeam body in hsbCAD. This script visualizes differences between an imported body (stored in the script's Map) and the real solid body of a beam, sheet, or panel.

## Script Type

**Type O (Object)** - This is a standalone object script that attaches to GenBeam entities for solid body comparison and validation purposes.

**Important**: This script cannot be manually inserted by users. It is designed to be created programmatically through the property dialog for catalog creation or by other automation workflows.

## Purpose

The SolidContainer script serves as a quality assurance tool to:
- Store and display imported solid geometry alongside the actual hsbCAD GenBeam body
- Calculate and visualize volume differences between imported and actual bodies
- Provide visual feedback (green/red text) indicating whether a valid imported body was found
- Support formatted variable display for beam identification

## User Properties

### General

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Color | Dropdown | Green | Display color for the body visualization. Options: Default, Red, Yellow, Green, Cyan, Blue, Magenta, White, Black, Gray, Dark brown, Light brown |
| Group | Dropdown | (varies) | Assigns the script instance to a hsbCAD Group for organization |

### Body Display

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| View | Dropdown | Difference | Controls what is displayed. Options: Nothing, Imported body, Difference |
| Offset | Double | 300 mm | Distance to offset the displayed body from the original position |
| Offset Direction (GenBeam) | Dropdown | Z | Direction relative to GenBeam's coordinate system. Options: X, -X, Y, -Y, Z, -Z |
| Show Import Error | Yes/No | Yes | When enabled, displays face loops if no valid body was stored in the Map |

### Text Display

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Text Height | Double | 200 mm | Height of the displayed text labels |
| Text Offset | Double | 350 mm | Distance to offset the text from the beam center |
| Custom Text | String | (empty) | Custom text to display using formatted variables |

## Formatted Variables

The following variables can be used in the Custom Text field:

| Variable | Description |
|----------|-------------|
| @(Handler) | Entity handle ID |
| @(Posnum) | Position number |
| @(Length) | Solid length |
| @(Width) | Solid width |
| @(Height) | Solid height |
| @(Volume) | Volume |
| @(Grade) | Material grade |
| @(Profile) | Profile name |
| @(Material) | Material name |
| @(Label) | Label |
| @(SubLabel) | Sub-label |
| @(SubLabel2) | Sub-label 2 |
| @(Beamcode) | Beam code |
| @(Type) | Type designation |
| @(Information) | Information field |
| @(Name) | Name |
| @(PosnumAndText) | Position number with text |
| @(Layer) | Layer name |
| @(HsbId) | hsbCAD ID |
| @(Module) | Module name |

## Usage Workflow

1. **Automatic Creation**: This script is typically created automatically by other hsbCAD processes that import solid geometry for comparison. Manual insertion is blocked with the message: "TSL cannot be manually added. Please use property dialog for catalogs creation."

2. **Catalog Configuration**: Use the property dialog (shown on double-click) to configure and save catalog settings for different comparison scenarios.

3. **Viewing Results**:
   - **Green text** indicates a valid imported body was found and stored
   - **Red text** indicates no valid body was found in the Map
   - Set the "View" property to control what geometry is displayed

4. **Comparing Volumes**:
   - Set View to "Difference" to visualize geometric differences between imported and actual bodies
   - The script calculates both A-B and B-A differences to show all discrepancies
   - A volume tolerance of 15 cubic cm is applied by default to filter small numerical differences

5. **Adjusting Display**:
   - Use "Offset" and "Offset Direction" to move the displayed comparison geometry away from the original beam
   - Adjust "Text Height" and "Text Offset" for better readability

## Visual Indicators

- **Position Number Color**:
  - Green: Valid imported body found in Map
  - Red: No valid body found or import failure

- **Error Display**: When "Show Import Error" is enabled and no valid body exists, the script displays the face loops stored in the Map to help diagnose import issues.

## Technical Notes

- The script automatically removes duplicate instances attached to the same GenBeam
- Supports Beam, Sheet, and Sip (Structural Insulated Panel) entity types
- Volume differences are reported in mm3, cm3, and m3
- The script's insertion point (_Pt0) is locked to the GenBeam center and cannot be manually relocated
- A minimum volume threshold of 15 cubic cm (15,000,000 mm3) is used to filter insignificant geometry

## Version History

- **v1.12** (25 Jan 2020): Simplified View property options, improved difference visualization, added volume tolerance
- **v1.11** (14 Jan 2020): Locked _Pt0 grip point, automatic removal of duplicate instances
- **v1.10** (19 Nov 2019): Added Text Offset, Group, and Custom Text properties with formatted variables
- **v1.09** (21 Oct 2019): Imported body visible even when volume difference is zero
- **v1.08** (18 Oct 2019): Added volume comparison reporting in multiple units
- **v1.07** (18 Oct 2019): Removed manual creation, added display options
- **v1.00** (23 Sep 2019): Initial release
