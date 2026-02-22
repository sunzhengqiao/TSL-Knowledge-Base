# hsbCLT-FreeTextMarker

## Overview

The **hsbCLT-FreeTextMarker** script creates free text and/or marker lines on Cross-Laminated Timber (CLT) panels. This tool is essential for marking, labeling, and annotating CLT panels with text, markers, or combinations of both for fabrication and installation purposes.

**Key Features:**
- Add text to CLT panels for labeling and marking
- Create marker lines for reference points
- Support for multiple insertion modes (Text only, Marker only, or both)
- Grain direction-aware text positioning
- Customizable text formatting and alignment
- Dual-face support (Reference Face, Top Face, or Both)

## Script Information

| **Property** | **Value** |
|--------------|-----------|
| **Script Type** | Object (O) |
| **Version** | 1.7 (January 16, 2025) |
| **Author** | Marsel Nakuci |
| **Keywords** | CLT; Panel; Mark; Marking; FreeText; Text; Marker |

## Usage

### Basic Workflow

1. **Insert the script**
   - Command: `TSLCONTENT`
   - The script will automatically detect if you're working with multiple panels

2. **Select panel(s)**
   - For text mode: Multiple panels can be selected
   - For marker/both modes: Single panel selection

3. **Pick insertion point**
   - Click where you want the text/marker to appear
   - Optionally select a second point to define text direction

4. **Configure properties** (see Properties section below)

5. **Click OK to apply**

### Context Menu Options

The script provides several context menu options for enhanced functionality:

- **Flip Side**: Toggle between reference face and opposite face
- **Set Alignment**: Define custom text direction
- **Snap To Edge**: Auto-align to panel edge
- **Set Marker Perpendicular To Edge**: Orient marker perpendicular to panel edge

## Properties

### Mode Properties

| **Property** | **Options** | **Description** |
|--------------|-------------|-----------------|
| **Mode** | Text<br>Marker<br>Text + Marker | Defines the mode of operation - text only, marker only, or both |
| **Face** | Reference Face<br>Top Face<br>Both | Which face of the panel to apply the marking to |
| **Alignment** | Parallel<br>Perpendicular<br>Parallel to grain direction<br>Perpendicular to grain direction | Text/marker alignment relative to panel edges or grain direction |

### Text Properties

| **Property** | **Options** | **Description** |
|--------------|-------------|-----------------|
| **Alignment** | Top-Left<br>Top-Center<br>Top-Right<br>Center-Left<br>Center-Center<br>Center-Right<br>Bottom-Left<br>Bottom-Center<br>Bottom-Right | Text alignment within the marker line |
| **Text Height** | Custom value | Height of the text (default: 50mm) |
| **Format** | @(PosNum) | Text format using TSL formatting (e.g., position number, custom properties) |

### Marker Properties

| **Property** | **Options** | **Description** |
|--------------|-------------|-----------------|
| **Length** | Custom value<br>0 (by grip) | Length of the marker line (0 = use grip point distance) |

## Advanced Features

### Grain Direction Integration

The script automatically detects and integrates with grain direction markers:
- When a grain direction symbol is present on the panel, text can be aligned parallel or perpendicular to it
- Supports both property-based and symbol-based grain direction detection
- Ensures proper text orientation for manufacturing

### Multiple Panel Support

In text mode, the script supports:
- Multiple panel selection
- Automatic distribution across selected panels
- Each panel gets its own instance with consistent properties

### Map Integration for Shop Drawings

The script creates map requests for shop drawing integration:
- Stores text information in the DimRequest map
- Includes text properties, position, and orientation
- Supports reverse direction flag for proper shop drawing generation

## Practical Applications

### 1. **Panel Labeling**
```
Format: @(PosNum)
Result: A1, A2, B1, B2, etc.
```

### 2. **Dimension Marking**
```
Format: @(Length) x @(Width) mm
Result: 2400 x 1200 mm
```

### 3. **Quality Control Marks**
```
Format: QC-@(QCGrade)
Result: QC-A1, QC-B2, etc.
```

### 4. **Installation Guides**
```
Format: @(Zone)-@(PosNum)
Result: 1-A1, 2-B3, etc.
```

## Tips and Best Practices

1. **Text Size**: Use appropriate text heights (typically 30-100mm) for readability
2. **Marker Length**: For markers, length 0 uses the grip point distance for quick dimensioning
3. **Grain Alignment**: Use "Parallel to grain direction" for text that should follow the wood grain
4. **Face Selection**: Use "Both" when marks need to be visible from both sides
5. **Format Consistency**: Use consistent formatting across similar panels for better organization

## Troubleshooting

### Common Issues

**"Location may not be outside the panel"**
- The insertion point must be within the panel boundaries
- Use the visual feedback (colored outline) to see valid areas

**"Text and Format could not be resolved"**
- Ensure the format string is valid
- Check that the panel has the required properties for the format

**Text not visible on shop drawings**
- Verify that the DimRequest map is properly configured
- Check that the "AlsoReverseDirection" flag is set correctly

### Debug Mode

To enable debug mode:
1. Create a MapObject named "hsbTSLDev" with "hsbTSLDebugController"
2. Set the script name in the map
3. Debug information will be displayed in the command line

## Version History

- **1.7** (2025-01-16): Added map request text for shop drawings
- **1.6** (2020-12-15): Text can depend on grain direction
- **1.5** (2020-11-26): Fixed BTL export bug, maintain same vector for both sides
- **1.4** (2020-11-18): Support multiple insertion on text mode
- **1.3** (2020-10-29): Merge issue
- **1.2** (2020-09-07): Description and version updated
- **1.1** (2020-08-21): Cleaned up and added comments
- **1.0** (2020-08-10): Initial release

## Related Scripts

- **PartLabeler**: For labeling stick frame walls
- **hsbGrainDirection**: For defining grain direction on CLT panels
- **hsbCLT-SetProperties**: For setting panel properties that can be used in formatting

---

*This documentation is generated for hsbCAD - Timber Construction CAD System*