import time
import serial
import serial.tools.list_ports as port_list
import show_data

def send_program(program_name):
    f = open(program_name,"r")
    cont = f.read()
    print cont
    cont = cont.replace("\n","")
    send = [cont[i : i+8] for i in range(0, len(cont), 8)]
    send_chr = [chr(int("0b"+i,2)) for i in send]
    for i in range(0, len(send_chr), 4):
        aux = send_chr[i:i+4]
        print aux
        for j in reversed(aux):
            ser.write(j)
            #print j
    print "programa cargado"

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
    

    while(1):
        op = raw_input("Ingrese modo de operacion:")
        print op

        if int(op) == 1:
            archivo = raw_input("Nombre archivo: ") 
            op = 0x01
            ser.write(chr(op))
            f = open(archivo,"r")
            cont = f.read()
            print cont
            cont = cont.replace("\n","")
            send = [cont[i : i+8] for i in range(0, len(cont), 8)]
            send_chr = [chr(int("0b"+i,2)) for i in send]
            for i in range(0, len(send_chr), 4):
                aux = send_chr[i:i+4]
                print aux
                for j in reversed(aux):
                    ser.write(j)
                    #print j
            print "programa cargado"
            
        elif int(op) == 2:
            op = 0x02
            print op
            ser.write(chr(op))
            data = []
            newFile = open("file.txt","wb")
            for i in range(324):
                aux = "{0:08b}".format(ord(ser.read(1)))
                data.append(aux)
                newFile.write(aux)
            
            data = show_data.merge_list(data)
            show_data.main(data)
        else:
            op = 0x03
            print op
            ser.write(chr(op))
            stop = "0"
            while(1):
                otro_step = raw_input("Otro step? 1:yes o 0:no")
                if int(otro_step) and stop == "0":
                    ser.write(chr(0x0f))
                    data = []
                    for i in range(324):
                        data.append("{0:08b}".format(ord(ser.read(1))))
                    
                    data = show_data.merge_list(data)
                    stop = show_data.main(data)
                    print "--------------", stop, type(stop)
                else: 
                    break

    """
    op = 0x02
    print op
    ser.write(chr(op))
    newFile = open("file_2.txt","wb")
    for i in range(324):
        newFile.write("{0:08b}".format(ord(ser.read(1))) + "\n")
    """
    """
    op = 0x01
    ser.write(chr(op))
    f = open("clear.mem","r")
    cont = f.read()
    print cont
    cont = cont.replace("\n","")
    send = [cont[i : i+8] for i in range(0, len(cont), 8)]
    send_chr = [chr(int("0b"+i,2)) for i in send]
    for i in range(0, len(send_chr), 4):
        aux = send_chr[i:i+4]
        print aux
        for j in reversed(aux):
            ser.write(j)
            #print j
    print "programa cargado"
    """
        
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
