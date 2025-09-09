cdef unsigned char *DECODE_B85 = [
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 62, 0, 63, 64, 65, 66, 0, 67, 68, 69, 70, 0, 71, 0, 0,
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 72, 73, 74, 75, 76,
    77, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
    25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 0, 0, 0, 78, 79,
    80, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
    51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 81, 82, 83, 84, 0
]

cpdef bytes b85decode(bytes x):
    cdef int sz = len(x)
    cdef int padding = sz % 5
    if padding > 0:
        padding = 5 - padding

    cdef bytearray out = bytearray(4 * (sz + padding) // 5)
    cdef unsigned char *z = x
    cdef unsigned char *o = out
    cdef unsigned int acc, de
    cdef int i, j
    cdef int k = 0

    for i in range(0, sz, 5):
        acc = 0

        for j in range(5):
            if i + j < sz:
                de = DECODE_B85[z[i+j]]
                acc = 85 * acc + de
            else:
                de = DECODE_B85[0x7e]
                acc = 85 * acc + de

        o[k+0] = (acc >> 24) & 0xff
        o[k+1] = (acc >> 16) & 0xff
        o[k+2] = (acc >>  8) & 0xff
        o[k+3] =  acc        & 0xff
        k += 4

    cdef result = bytes(out)
    if padding:
        result = result[:-padding]
    return result
