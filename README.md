![Language](https://img.shields.io/badge/language-Verilog-orange?style=for-the-badge&logo=verilog)
![Platform](https://img.shields.io/badge/platform-Intel%20Cyclone%20IV-0071C5?style=for-the-badge&logo=intel)
![Toolchain](https://img.shields.io/badge/tool-Quartus%20Prime-success?style=for-the-badge)
![License](https://img.shields.io/github/license/leoo-c1/FPGA-Design-Library?style=for-the-badge&color=blue)

# FPGA Design Library
A library of resuable Verilog modules and projects for FPGA development.

## Target Hardware
These modules are configured for the Intel Cyclone IV EP4CE6E22C8N FPGA on the [RZ-EasyFPGA A2.2 / RZ-EP4CE6-WX board](https://web.archive.org/web/20210128152708/http://rzrd.net/product/?79_502.html) by Ruizhi Technology Co, but can be reused for a variety of boards.

### Pinout Configuration

| Signal Group | Signal Name | FPGA Pin | Description |
| :--- | :--- | :--- | :--- |
| **System** | `sys_clk` | **PIN_23** | 50MHz On-board Oscillator |
| | `sys_rst_n` | **PIN_25** | Active Low Reset Button (Key 4) |
| **UART** | `uart_rx` | **PIN_114** | Serial Receive (USB-TTL) |
| | `uart_tx` | **PIN_115** | Serial Transmit (USB-TTL) |
| **Display** | `seg_led[0]` (A) | **PIN_128** | 7-Segment Cathode A |
| | `seg_led[1]` (B) | **PIN_121** | 7-Segment Cathode B |
| | `seg_led[2]` (C) | **PIN_125** | 7-Segment Cathode C |
| | `seg_led[3]` (D) | **PIN_129** | 7-Segment Cathode D |
| | `seg_led[4]` (E) | **PIN_132** | 7-Segment Cathode E |
| | `seg_led[5]` (F) | **PIN_126** | 7-Segment Cathode F |
| | `seg_led[6]` (G) | **PIN_124** | 7-Segment Cathode G |
| | `seg_led[7]` (DP)| **PIN_127** | Decimal Point |
| **Digit Sel**| `dig_sel[0]` | **PIN_133** | Digit 1 Select (Active Low) |
| | `dig_sel[1]` | **PIN_135** | Digit 2 Select (Active Low) |
| | `dig_sel[2]` | **PIN_136** | Digit 3 Select (Active Low) |
| | `dig_sel[3]` | **PIN_137** | Digit 4 Select (Active Low) |

## Credit
- [UART_Communication](library/UART_Communication) implements Ben Marshall's [uart repository](https://github.com/ben-marshall/uart/tree/master).
