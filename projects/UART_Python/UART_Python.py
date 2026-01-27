import serial
import time

ser = serial.Serial()   # Create serial object
ser.port = 'COM3'       # Set the port to COM3
ser.baudrate = 9600     # Set the baudrate to 9600 bits/sec
ser.open()              # Open the serial port

# Count up from 0 to 9 on the first SSD every second
for i in range (10):
    ser.write(bytes([i]))
    time.sleep(1)

ser.close()             # Close the serial port