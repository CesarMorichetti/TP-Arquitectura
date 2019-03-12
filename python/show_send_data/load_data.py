
if __name__ == "__main__":
    
    f = open("memoria.mem","r")
    cont = f.read()
    print cont
    cont = cont.replace("\n","")
    send = [cont[i : i+8] for i in range(0, len(cont), 8)]
    send_chr = [chr(int("0b"+i,2)) for i in send]
    for i in range(0, len(send_chr), 4):
        aux = send_chr[i:i+4]
        print aux
        for j in reversed(aux):
            print j

