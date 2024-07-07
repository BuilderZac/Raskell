# Raskell
This is an encryption algorithm I threw together based on the XOR cypher. Currently, there is only a Lua version, but I plan to port it to Python.

The basic idea is to do multiple XOR operations and each one shift the bytes over. Also somewhere is a wildcard byte that changes each time it is run so two of the same letter will come out diffrent. To decrypt you do the same operations just in reverse. This was initally made in lua so I could use it on to encrypt rednet transimitions in computer craft. An example can be found below.

1st key byte:  00110011
The letter A:  01000001
XOR operation: 01110010
Shift layer:   11100100

2nd key byte:  10101010
XOR operation: 01001110
Shift Layer:   10011100
