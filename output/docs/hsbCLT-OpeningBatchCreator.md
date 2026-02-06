# hsbCLT-OpeningBatchCreator.mcr

## Overview
Batch processing tool that detects existing openings in CLT panels and automatically applies specific detailing strategies (such as lintels or stiffeners) based on size filters.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required. Select CLT panels in 3D model. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: CLT Panels (Sip entities) with existing voids or cutouts.
- **Minimum Beams**: 0 (This script operates on panels, not beams).
- **Required Settings**: Valid catalog entries for the script `hsbCLT-Opening` must exist in your database.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-OpeningBatchCreator.mcr`

### Step 2: Select Panels
```
Command Line: Select panels
Action: Select the CLT panels (Sip entities) containing the openings you wish to process and press Enter.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Strategy 1 | dropdown | `<|Disabled|>` | Select the first construction rule (from the `hsbCLT-Opening` catalog) to apply to detected openings. |
| Strategy 2 | dropdown | (Catalog entries) | Select a secondary rule to apply simultaneously with Strategy 1. |
| Strategy 3 | dropdown | (Catalog entries) | Select a tertiary rule to apply simultaneously with Strategies 1 and 2. |
| Filter by Area | text | (Empty) | Logical condition to filter openings by size (e.g., `<=0.7` or `>1.5`). Uses m² (metric) or drawing units² (imperial). Leave empty to process all openings. |
| Face | dropdown | `|byCatalog|` | Determines which side of the panel the detailing is applied to. Options: Reference Side, Opposite Side, or by Catalog default. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None available | This script does not add custom context menu items. |

## Settings Files
- **Catalog Dependency**: `hsbCLT-Opening`
- **Purpose**: This batch script relies entirely on the catalog configurations defined within the `hsbCLT-Opening` script. Ensure that script has valid, saved catalog entries (excluding system defaults) to populate the Strategy dropdowns.

## Tips
- **Small Openings**: Use the "Filter by Area" parameter (e.g., `<=0.5`) to ignore small service holes or drill holes so you only detail large windows or doors.
- **Combined Detailing**: You can use Strategy 1, 2, and 3 together to apply multiple different details to a single opening (e.g., Strategy 1 for a timber lintel and Strategy 2 for metal plate reinforcement).
- **Catalog Check**: If the Strategy dropdowns are empty or the script fails, verify that the `hsbCLT-Opening` script has valid catalog entries in your current project.

## FAQ
- **Q: What units should I use for the Area Filter?**
  - A: Use square meters (m²) if working in a metric project. If working in imperial, use your current drawing units squared.
- **Q: Why didn't the script create any visible geometry?**
  - A: This script creates *instances* of the `hsbCLT-Opening` script. It does not draw geometry directly. Check if the generated `hsbCLT-Opening` instances are visible and that their specific catalogs are configured to produce visible elements (machining or beams).
- **Q: Can I run this multiple times on the same panel?**
  - A: Yes, but be careful not to duplicate detailing. Check your existing `hsbCLT-Opening` instances before running the batch again.