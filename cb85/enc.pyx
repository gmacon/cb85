import cython

cdef unsigned char *ENCODE_B85 = [
    b'0', b'1', b'2', b'3', b'4', b'5', b'6', b'7', b'8', b'9',
    b'A', b'B', b'C', b'D', b'E', b'F', b'G', b'H', b'I', b'J',
    b'K', b'L', b'M', b'N', b'O', b'P', b'Q', b'R', b'S', b'T',
    b'U', b'V', b'W', b'X', b'Y', b'Z',
    b'a', b'b', b'c', b'd', b'e', b'f', b'g', b'h', b'i', b'j',
    b'k', b'l', b'm', b'n', b'o', b'p', b'q', b'r', b's', b't',
    b'u', b'v', b'w', b'x', b'y', b'z',
    b'!', b'#', b'$', b'%', b'&', b'(', b')', b'*', b'+', b'-',
    b';', b'<', b'=', b'>', b'?', b'@', b'^', b'_',	b'`', b'{',
    b'|', b'}', b'~'
]

@cython.cdivision(True)
cpdef bytes b85encode(bytes x, bint pad=False):
    cdef int sz = len(x)
    cdef int padding = sz % 4
    if padding > 0:
        padding = 4 - padding

    cdef bytearray out = bytearray(5 * (sz + padding) // 4)
    cdef unsigned char *z = x
    cdef unsigned char *o = out
    cdef unsigned int acc
    cdef int j = 0
    cdef int i

    for i in range(0, sz, 4):
        acc = (z[i+0] << 24) \
            | ((z[i+1] if i+1 < sz else 0) << 16) \
            | ((z[i+2] if i+2 < sz else 0) << 8) \
            | (z[i+3] if i+3 < sz else 0)

        o[j+0] = ENCODE_B85[acc // 52200625]
        o[j+1] = ENCODE_B85[(acc // 614125) % 85]
        o[j+2] = ENCODE_B85[(acc // 7225) % 85]
        o[j+3] = ENCODE_B85[(acc // 85) % 85]
        o[j+4] = ENCODE_B85[acc % 85]
        j += 5

    cdef result = bytes(out)
    if padding and not pad:
        result = result[:-padding]
    return result
