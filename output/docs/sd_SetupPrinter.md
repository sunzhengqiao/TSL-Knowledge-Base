# sd_SetupPrinter

Shop drawing printer configuration script for hsbCAD. This script allows users to configure and manage plot settings, printer selection, and output options for generating shop drawings.

## Overview

The sd_SetupPrinter script provides a centralized interface for configuring plot and print settings in hsbCAD shop drawings. It allows users to define plot styles, paper sizes, printers, and output options that apply to all shop drawing layouts.

## Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | Configuration script only, no geometry generation |
| Paper Space | Yes | Settings apply when generating shop drawings |
| Shop Drawing | Yes | Primary environment; executed by the shop drawing engine |

- **Script Type**: T-Type (Tool-based)
- **Required Beams**: 0
- **DXA Output**: No (configuration tool only)

## Prerequisites

1. **Plot Devices**: Windows printers or plot managers must be installed and available
2. **Plot Styles**: CTB (Color-dependent) or STB (Style-dependent) plot styles must be defined
3. **Layout Templates**: Paper space layouts with viewports must exist in the drawing

## Usage

### Automatic Execution (Recommended)

1. The script is automatically executed when generating shop drawings
2. Configuration is saved globally and applies to all future shop drawings
3. Settings persist between drawing sessions

### Manual Configuration

1. Command: `TSLINSERT` and select `sd_SetupPrinter.mcr`
2. The setup dialog opens with current configuration options
3. Modify settings and click OK to save

### Editing Existing Settings

1. Select an existing instance of the script in the drawing
2. Access Properties through right-click menu or Properties Palette
3. Modify plot configuration parameters
4. Changes apply immediately to new plot operations

## Parameters

### Printer Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Plotter Name | Dropdown | Default Windows Printer | Select output device |
| Paper Size | Dropdown | A4 | Select paper size for output |
| Orientation | Dropdown | Portrait | Page orientation (Portrait/Landscape) |
| Plot Area | Dropdown | Extents | Define what to plot (Extents/Limits/View/Window) |
| Plot Scale | Dropdown | Fit to Paper | Scale for the plot output |

### Plot Style Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Plot Style Table | Dropdown | acad.ctb | Select CTB or STB file |
| Show Plot Styles | Yes/No | Yes | Display plot style information |
| Apply Lineweights | Yes/No | Yes | Use lineweights from plot style |
| Override Colors | Yes/No | No | Use plot style colors instead of layer colors |

### Output Options

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Plot to File | Yes/No | No | Output to PDF instead of printer |
| File Format | Dropdown | PDF | Output format (PDF/DWG/DXF) |
| File Path | String | My Documents | Default save location |
| Embed Fonts | Yes/No | Yes | Include fonts in PDF output |
| Layer Information | Yes/No | Yes | Include layer plot settings |

### Quality Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Resolution (DPI) | Dropdown | 300 | Output resolution (150/300/600) |
| Monochrome | Yes/No | No | Black and white output |
| Hide Viewport Overrides | Yes/No | No | Ignore viewport hidden layers |
| Center Plot | Yes/No | Yes | Center output on paper |
| Preview Before Plot | Yes/No | Yes | Show plot preview |

## Menu Options

| Menu Item | Description |
|-----------|-------------|
| Properties | Opens the AutoCAD Properties Palette (OPM) for plot configuration |
| Save Settings | Saves current configuration as default for all future plots |
| Reset to Default | Restores default plot settings |
| Test Plot | Generates a test plot with current settings |

## Tips

### Optimizing Plot Output

- **PDF vs Print**: Use PDF for digital copies, printer for physical output
- **Resolution**: 300 DPI provides good balance for most shop drawings
- **Paper Size**: Choose appropriate size for content to avoid scaling issues
- **Plot Area**: Use Extents to capture all geometry or Window for specific areas

### Working with Plot Styles

- **CTB Files**: Color-based, easier for simple drawings
- **STB Files**: Style-based, more flexible for complex output
- **Custom Plot Styles**: Create dedicated styles for different drawing types
- **Layer Assignments**: Configure plot styles per layer for consistent output

### Performance Considerations

- Plotting large drawings may take time - consider using batch plotting for multiple layouts
- Hide unnecessary layers before plotting to improve performance
- Use appropriate resolution - higher DPI creates larger files
- Test plot settings on small areas before full-scale plotting

## FAQ

**Q: Why don't my plot settings persist between drawings?**

A: sd_SetupPrinter saves settings to the current drawing template. Save the drawing as a .dwt file to reuse settings.

**Q: My plot is coming out black and white. How do I enable color?**

A: Check the "Monochrome" parameter in the plot configuration. Set it to "No" and ensure plot style colors are enabled.

**Q: How can I plot to a specific file location?**

A: Enable "Plot to File" and set the full file path in the "File Path" parameter. Use network paths for shared locations.

**Q: The script reports "No plot devices found".**

A: Ensure Windows printers are properly installed and accessible. Check plotter configuration in Windows.

**Q: How do I create custom paper sizes?**

A: Custom paper sizes must be defined in Windows Plot Manager, not within hsbCAD. Set them in Windows first, then select from the dropdown.

**Q: Why are some lineweights not plotting correctly?**

A: Verify that plot styles (CTB/STB) include lineweight assignments and that "Apply Lineweights" is enabled in the script settings.

## Troubleshooting

### Common Plot Issues

- **Blank Output**: Check plot area settings and ensure geometry is within viewport
- **Wrong Scale**: Verify plot scale matches viewport scale
- **Distorted Text**: Ensure proper text height and font embedding settings
- **Missing Layers**: Check plot style layer visibility settings
- **Slow Plotting**: Reduce resolution or plot in sections for large drawings