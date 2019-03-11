from bitstring import BitArray


def strbin_to_dec(binary):
    res = BitArray(bin=str(binary))
    return str(res.int)

def strbin_to_udec(binary):
    res = BitArray(bin=str(binary))
    return str(res.uint)
