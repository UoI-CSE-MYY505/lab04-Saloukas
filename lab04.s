
.globl str_ge, recCheck

.data

maria:    .string "Maria"
markos:   .string "Markos"
marios:   .string "Marios"
marianna: .string "Marianna"

.align 4  # make sure the string arrays are aligned to words (easier to see in ripes memory view)

# These are string arrays
# The labels below are replaced by the respective addresses
arraySorted:    .word maria, marianna, marios, markos

arrayNotSorted: .word marianna, markos, maria

.text

            la   a0, arrayNotSorted
            li   a1, 4
            jal  recCheck

            li   a7, 10
            ecall

str_ge:
    # Load the addresses of the two strings in registers a0 and a1
    loop:
        lb t0, 0(a0)            # Load a character from the first string
        lb t1, 0(a1)            # Load a character from the second string
        beq t0, t1, continue    # If characters are the same, continue

        blt t0, t1, return_0    # If t0 < t1, return 0
        j return_1              # If t0 > t1, return 1

    continue:
        beq t0, zero, return_1  # If both strings end here, they are equal
        addi a0, a0, 1          # Move to the next character of the first string
        addi a1, a1, 1          # Move to the next character of the second string
        j loop                  # Repeat the loop

    return_0:
        li a0, 0                # Return 0 if the first string is lexicographically before the second
        jr ra

    return_1:
        li a0, 1                # Return 1 if the first string is lexicographically after or equal to the second
        jr ra

#  You may move jr ra   if you wish.
#---------
            jr   ra
 
# ----------------------------------------------------------------------------
# recCheck(array, size)
# if size == 0 or size == 1
#     return 1
# if str_ge(array[1], array[0])      # if first two items in ascending order,
#     return recCheck(&(array[1]), size-1)  # check from 2nd element onwards
# else
#     return 0

recCheck:
    # Check if the array has 0 or 1 element (already sorted)
    li t0, 1
    ble a1, t0, return_1      # If size <= 1, return 1

    # Load the addresses of the first two elements in the array
    lw t1, 0(a0)              # First string (table[0])
    lw t2, 4(a0)              # Second string (table[1])

    # Compare the two strings with str_ge
    mv a0, t1                 # str_ge(a0 = table[0], a1 = table[1])
    mv a1, t2
    jal ra, str_ge            # Call str_ge subroutine

    beq a0, zero, return_0    # If str_ge returns 0, the array is not sorted

    # Recursive call for the remaining array
    addi a1, a1, -1           # Decrease the size by 1
    addi a0, a0, 4            # Move the pointer to the next element
    jal ra, recCheck          # Recursively call recCheck

    jr ra                     # Return

return_0:
    li a0, 0                  # Return 0 if the array is not sorted
    jr ra

return_1:
    li a0, 1                  # Return 1 if the array is sorted
    jr ra

#  You may move jr ra   if you wish.
#---------
            jr   ra
