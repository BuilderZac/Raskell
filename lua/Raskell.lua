--Usable functions are keyGen, keyWrite, keyTool, keyRead, encrypt, and decrypt

-- ras is used to export the lua functions
local ras = {}
-- loopCap sets the max number the wild card will be before looping
local loopCap = 255

-- function for replacing one char
local function replaceChar(pos, str, r)
    return str:sub(1, pos-1) .. r .. str:sub(pos+1)
end

-- function for moving a char from front to the end
local function moveToEnd(str)
   return str:sub(2) .. str:sub(1,1)
end

-- same thing as above just reverse
local function moveToFront(str)
   return str:sub(8, 8) .. str:sub(1, 7)
end

-- for converting a string in ascii to a string of binary
local function stringBinary(input)
   local num1 = input
   if num1 == nil then
      num1 = 0
   end
   local num2 = 256
   local string = "00000000"
   for i = 0, 8, 1 do
      if num1 >= num2 then
         num1 = num1 - num2
         string = replaceChar(i, string, "1")
      end
      num2 = num2 / 2
   end
   return string
end

-- this function was used for easier formating on my part
local function ezbyte(input)
   return stringBinary(string.byte(input))
end

-- a function for doing the XOR operations
local function bitFlip(byte1, byte2)
   local tembyte2 = byte2
   for i = 0, 8, 1 do
      if string.sub(byte1, i, i) == "1" then
         if string.sub(tembyte2, i, i) == "1" then
            tembyte2 = replaceChar(i, tembyte2, "0")
         else
            tembyte2 = replaceChar(i, tembyte2, "1")
         end
      end
   end
   return tembyte2
end

-- a fucntion for converting strings of binary to ints
local function binaryInt(byte)
   local total = 0
   local num1 = 256
   for i = 0, 8, 1 do
      if string.sub(byte, i, i) == "1" then
         total = total + num1
      end
      num1 = num1 / 2
   end
   return total
end

-- a fucntion for converting strings of binary to hex
local function binaryHex(byte)
   local tem = string.format("%x", binaryInt(byte))
   if string.len(tem) < 2 then
      tem = "0" .. tem
   end
   return tem
end

-- a function for converting strings of hex to strings of binary
local function hexBinary(hex)
   return stringBinary(tonumber(hex, 16))
end

-- a fucntion for converting strings of binary to strings of ascii
local function binaryString(byte)
   return string.char(binaryInt(byte))
end

-- a function for generating keys with a wildcard in them
function ras.keyGen(length, seed)
   math.randomseed(seed)
   local keyString = ""
   local kk = false
   for i = 1, length, 1 do
      local tem = math.random(0, 255)
      if math.random(i, length) == i and kk == false then
         keyString = keyString .. "kk"
         kk = true
      else
         keyString = keyString .. string.format("%x", tem)
      end
   end
   return keyString
end

-- a function for writeing keys to a file
function ras.keyWrite(key, keyName)
   local file = io.open(keyName, "w")
   io.output(file)
   io.write(key)
   io.close(file)
end

-- a function for reading keys from a file
function ras.keyRead(keyName)
   local file = io.open(keyName, "r")
   io.input(file)
   local key = io.read()
   io.close(file)
   return key
end

-- the main encryption function
function ras.encrypt(key, text)
   -- sets up the variables used
   local output = ""
   local tem = ""
   local temKey = ""
   local keyTick = 1

   -- this converts the key which is saved in hex to a long string of binary
   for i = 1, string.len(key), 2 do
      if key:sub(i, i + 1) == "kk" then
         temKey = temKey .. "kkkkkkkk" else
         temKey = temKey .. hexBinary(key:sub(i, i + 1))
      end
   end

   -- this loop takes each letter and turns them into a byte
   for i = 1, string.len(text), 1 do
      tem = ezbyte(text:sub(i,i))

      -- this loop runs each letter through the key
      for x = 1, (string.len(temKey)), 8 do

         -- this if statment handles the wildcard
         if temKey:sub(x, x + 7) == "kkkkkkkk" then
            tem = bitFlip(tem, ezbyte(keyTick))
            if keyTick >= loopCap then
               keyTick = 0
            end
            keyTick = keyTick + 1
         else
            -- if it does not trigger the wildcard the XOR is done normally
            tem = bitFlip(tem, temKey:sub(x, x + 7))
         end

         -- triggers the move to end operation after the XOR is done
         tem = moveToEnd(tem)
      end

      -- appends the newly scrabled string of binary representing one ascii letter and saves them as a hex value
      output = output .. binaryHex(tem)
   end
   return output
end

-- it does the same thing as the encryption fucntion just in reverse
function ras.decrypt(key, text)
   local output = ""
   local tem = ""
   local temKey = ""
   local keyTick = (string.len(text) / 2) % loopCap
   for i = 1, string.len(key), 2 do
      if key:sub(i, i + 1) == "kk" then
         temKey = temKey .. "kkkkkkkk"
      else
         temKey = temKey .. hexBinary(key:sub(i, i + 1))
      end
   end
   for i = string.len(text), 1, -2 do
      tem = hexBinary(text:sub(i - 1,i))
      for x = (string.len(temKey)), 1, -8 do
         tem = moveToFront(tem)
         if temKey:sub(x - 7, x) == "kkkkkkkk" then
            tem = bitFlip(tem, ezbyte(keyTick))
            if keyTick <= 1 then
               keyTick = loopCap + 1
            end
            keyTick = keyTick - 1
         else
            tem = bitFlip(tem, temKey:sub(x - 7, x))
         end
      end
      output = binaryString(tem) .. output
   end
   return output
end

-- a tool for managing and making keys easily
-- note this tool makes its keys based on time
function ras.keyTool()
   io.write("-------Raskell Key gen tool-------\n")
   io.write("Engter the key length: ")
   local keyLength = io.read()
   io.write("Enter the key name: ")
   keyWrite(keyGen(keyLength, os.time()), io.read())
end

return ras
