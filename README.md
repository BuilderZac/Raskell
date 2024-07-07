# Raskell
This is an encryption algorithm I threw together based on the XOR cypher. Currently, there is only a Lua version, but I plan to port it to Python.

The basic idea is to do multiple XOR operations and each one shift the bytes over. Also somewhere is a wildcard byte that changes each time it is run so two of the same letter will come out different. To decrypt you do the same operations just in reverse. This was initially made in lua so I could use it on to encrypt rednet transmissions in computer craft. An example can be found below.

1st key byte:&emsp;&emsp;&ensp;00110011\
The letter A:&ensp;&emsp;&emsp;01000001\
XOR operation:&emsp;01110010\
Shift layer:&emsp;&emsp;&emsp;11100100\
2nd key byte:&emsp;&emsp;10101010\
XOR operation:&emsp;01001110\
Shift Layer:&emsp;&emsp;&emsp;10011100
