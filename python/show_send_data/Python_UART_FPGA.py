import time
import serial
import serial.tools.list_ports as port_list

"""Script que estoy usando por el momento para la
comunicacion con la placa"""

def main():

    #Configuracion del Serial
    ports = list(port_list.comports())
    for p in ports:
        print (p)
    #puerto = str(raw_input("Ingrese puerto: "))
    ser = serial.Serial(
        #port=puerto,	#Configurar con el puerto
        port = "/dev/ttyUSB1",
        baudrate=19200,
        parity=serial.PARITY_NONE,      #Sin bit de paridad
        stopbits=serial.STOPBITS_ONE,   #1 bit de stop
        bytesize=serial.EIGHTBITS       #1 byte de dato
    )
    ser.isOpen()

#    while(True):
        #op = int(raw_input("numero"))
    op = 0x02
    print op
    ser.write(chr(op))
    newFile = open("file3.txt","wb")
    for i in range(324):
        newFile.write("{0:08b}".format(ord(ser.read(1))) + "\n")

        
    #op = 0x01
    #print op
    #ser.write(chr(op))
    #ser.write(chr(0x00))
    #ser.write(chr(0x00))
    #ser.write(chr(0x02))
    #ser.write(chr(0x20))

    #ser.write(chr(0x00))
    #ser.write(chr(0x00))
    #ser.write(chr(0x03))
    #ser.write(chr(0x20))
    #
    #ser.write(chr(0x00))
    #ser.write(chr(0x00))
    #ser.write(chr(0x04))
    #ser.write(chr(0x20))

    #ser.write(chr(0xff))
    #ser.write(chr(0xff))
    #ser.write(chr(0xff))
    #ser.write(chr(0xff))
    #
    #op = 0x02
    #print op
    #ser.write(chr(op))

    #newFile = open("file2.txt","wb")
    #for i in range(324):
    #    newFile.write("{0:08b}".format(ord(ser.read(1))) + "\n")



    
    #newFile = open("filename.txt","wb")
    #for i in range(324):
    #    newFile.write("{0:08b}".format(ord(ser.read(1))) + "\n")
        #res = ord(ser.read(1))
        #print "{0:08b}".format(res)
        #print "-----------", i
        #import pdb;pdb.set_trace()
    #for byte in res:
    #    newFile.write("{0:08b}".format(byte) + "\n")
   # import pdb;pdb.set_trace()
        #BIP Resultado
        #acc_low = ord(ser.read(1))
        #acc_high = ord(ser.read(1))
        #acc = acc_high + acc_low
        #acc = int(acc)
        #pc = ord(ser.read(1))
    #        if result > 127: result = result - 256
        #print "ACC: ", acc,"" "PC: ", pc
        #print "ACC-binario: ", bin(acc), " PC-binario: ", bin(pc) 
if __name__ == "__main__":
    main()
