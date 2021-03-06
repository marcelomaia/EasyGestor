import glob
import sys

import serial

available_devices = {'daruma': ['DR800', 'DR700'],
                     'bematech': ['MP4000TH', 'MP4200TH', 'MP2500TH', 'MP100STH'],
                     'epson': ['TMT20', 'TMT81'],
                     'sweda': ['SI300S'],
                     'generic': ['VIRTUAL', 'GENERICSERIAL', 'GENERICSPOOLER']
                     }


def serial_ports():
    """ From http://stackoverflow.com/questions/12090503/listing-available-com-ports-with-python
        Lists serial port names
        :raises EnvironmentError:
            On unsupported or unknown platforms
        :returns:
            A list of the serial ports available on the system
    """
    if sys.platform.startswith('win'):
        ports = ['COM%s' % (i + 1) for i in range(256)]
    elif sys.platform.startswith('linux') or sys.platform.startswith('cygwin'):
        # this excludes your current terminal "/dev/tty"
        ports = glob.glob('/dev/tty[A-Za-z]*')
    elif sys.platform.startswith('darwin'):
        ports = glob.glob('/dev/tty.*')
    else:
        raise EnvironmentError('Unsupported platform')

    result = []
    for port in ports:
        try:
            s = serial.Serial(port)
            s.close()
            result.append((port, port))
        except (OSError, serial.SerialException, ValueError):
            pass
    return result
