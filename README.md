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

### UART Communication Interface
To communicate with the board via UART, an external USB-to-Serial converter is used. The FPGA logic voltage is 3.3V, so the adapter must be configured correctly to avoid damaging the pins (on the XC4464, the onboard switch can be set to 3.3V to achieve this).

**Hardware Adapter:**\
[Duinotech Arduino Compatible USB to Serial Adaptor (XC4464)](https://www.jaycar.com.au/duinotech-arduino-compatible-usb-to-serial-adaptor/p/XC4464) | [XC4464 Manual](https://media.jaycar.com.au/product/resources/XC4464_manualMain_74523.pdf)
> **Important:** Ensure the voltage selection switch on the adapter is set to 3.3V. Do not connect the 5V pin.

| Adapter Pin | FPGA Pin | Description |
| :--- | :--- | :--- |
| **GND** | **GND** | Common Ground |
| **CTS** | **N/C** | **Do Not Connect** |
| **5V** | **N/C** | **Do Not Connect** |
| **TXD** | **PIN_114** | Serial Transmit (Connects to FPGA `uart_rx`) |
| **RXD** | **PIN_115** | Serial Receive (Connects to FPGA `uart_tx`) |
| **DTR** | **N/C** | **Do Not Connect** |

**Terminal Setup**
We use PuTTY for serial communication - [PuTTY download](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)

* **Connection Type:** `Serial`
* **Serial Line:** `COM3` (Note: Check Device Manager as this may vary)
* **Speed:** `9600`
* **Flow Control:** `None`

## Credit
- [UART_Communication](library/UART_Communication) implements Ben Marshall's [uart repository](https://github.com/ben-marshall/uart/tree/master).
