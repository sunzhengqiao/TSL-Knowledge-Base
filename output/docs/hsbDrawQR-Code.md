# hsbDrawQR-Code.mcr

## Overview
This script generates a scannable QR code symbol that encodes data from selected timber elements, viewports, or shop drawings. It allows users to create machine-readable labels for tracking or identification directly within the CAD environment.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Attaches directly to a selected element. |
| Paper Space | Yes | Requires a viewport containing an element to encode data. |
| Shop Drawing | Yes | Requires a ShopDrawView selection; supports catalog presets. |

## Prerequisites
- **Required Entities:** 
    - **Model Space:** An existing Element (e.g., beam, wall).
    - **Paper Space:** A Layout with a Viewport containing an Element.
    - **Shop Drawing:** A ShopDrawView.
- **Minimum beam count:** 0.
- **Required settings files:** None (Standard properties only, though optional catalog entries can be used in Shopdrawing mode).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbDrawQR-Code.mcr`.

### Step 2: Configure Mode and Properties
The script displays properties in the AutoCAD Properties Palette (OPM) before or after insertion.
1. Set the **Mode** property to `Model`, `Paperspace`, or `Shopdrawing` depending on where you are working.
2. Set the **Format** property to define what data is encoded (e.g., `@(ElementNumber)`).
3. (Optional) Set **Size** and **Logo** preferences.

### Step 3: Select Entity based on Mode
Depending on the selected **Mode**, the command line will prompt:
- **Paperspace:**
    ```
    Command Line: Select a viewport
    Action: Click on a viewport frame in the layout that contains the element you wish to label.
    ```
- **Shopdrawing:**
    ```
    Command Line: Select a Shopdraw View
    Action: Select the view entity in the shop drawing environment.
    ```
- **Model:**
    ```
    (Implicit prompt / Selection box)
    Action: Select an element (beam, wall, etc.) in the model.
    ```

### Step 4: Set Insertion Point
```
Command Line: Insertion point
Action: Click in the drawing area to place the QR code.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Format | text | EL;@(ElementNumber) | Defines the text/attributes encoded in the QR code. Use `@()` to reference properties (e.g., `@(ElementNumber)`, `@(ProjectName)`). |
| Mode | dropdown | Paperspace | Determines the working environment. Options: `Paperspace`, `Shopdrawing`, `Model`. |
| Size | number | 25 | The physical size of the QR code symbol in drawing units. |
| Margin | number | 4 | The quiet zone (blank border) around the code, measured in modules. |
| Logo | dropdown | no logo | Embeds a colored hsbCAD logo in the center. Options: `no logo`, `red`, `yellow`, `green`, `cyan`. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Viewport | Prompts to re-select or link a different viewport (Paperspace mode). Can also be triggered by double-clicking the script instance. |
| Select Catalog Default | Allows selecting a catalog entry to automatically set Format and Logo properties (Shopdrawing mode only). |
| Add/Remove Format | Opens a command-line list to interactively add (+) or remove (-) property variables from the Format string. |

## Settings Files
- **Filename:** None required (Catalog entries optional).
- **Location:** N/A.
- **Purpose:** While not strictly required, using a catalog entry in Shopdrawing mode can streamline the setup of Format and Logo settings for different label types.

## Tips
- **Scanning Reliability:** If using a Logo, the script automatically increases error correction. However, ensure the **Size** is large enough (minimum 15-20mm) for scanners to read clearly on printed output.
- **Custom Data:** Use the `Add/Remove Format` context menu to quickly build complex strings without typing the syntax manually.
- **Viewport Linking:** In Paperspace, if the QR code shows "please add a viewport", use the **Add Viewport** context menu to link it to the correct view.

## FAQ
- **Q: My QR code isn't scanning.**
  - A: Ensure the **Size** is sufficient (e.g., 25mm or larger) and that the **Margin** is not set to 0. Also, check if the contrast is high enough on your final output.
- **Q: Can I combine multiple properties in one code?**
  - A: Yes. In the **Format** property, you can combine variables, e.g., `ID: @(ElementNumber) Len: @(Length)`.
- **Q: How do I change the element the QR code refers to?**
  - A: In Model or Paperspace, you can delete and re-insert, or use the provided context menu options (like "Add Viewport") to re-associate the script instance with a different entity.