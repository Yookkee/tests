print('testing strings and string library')

local numbits = require'debug'.numbits

-- testing string comparisons
assert('alo' < 'alo1')
assert('' < 'a')
assert('alo\0alo' < 'alo\0b')
assert('alo\0alo\0\0' > 'alo\0alo\0')
assert('alo' < 'alo\0')
assert('alo\0' > 'alo')
assert('\0' < '\1')
assert('\0\0' < '\0\1')
assert('\1\0a\0a' <= '\1\0a\0a')
assert(not ('\1\0a\0b' <= '\1\0a\0a'))
assert('\0\0\0' < '\0\0\0\0')
assert(not('\0\0\0\0' < '\0\0\0'))
assert('\0\0\0' <= '\0\0\0\0')
assert(not('\0\0\0\0' <= '\0\0\0'))
assert('\0\0\0' <= '\0\0\0')
assert('\0\0\0' >= '\0\0\0')
assert(not ('\0\0b' < '\0\0a\0'))

-- testing string.sub
assert(string.sub("123456789",2,4) == "234")
assert(string.sub("123456789",7) == "789")
assert(string.sub("123456789",7,6) == "")
assert(string.sub("123456789",7,7) == "7")
assert(string.sub("123456789",0,0) == "")
assert(string.sub("123456789",-10,10) == "123456789")
assert(string.sub("123456789",1,9) == "123456789")
assert(string.sub("123456789",-10,-20) == "")
assert(string.sub("123456789",-1) == "9")
assert(string.sub("123456789",-4) == "6789")
assert(string.sub("123456789",-6, -4) == "456")
assert(string.sub("123456789",-2^31, -4) == "123456")
assert(string.sub("123456789",-2^31, 2^31 - 1) == "123456789")
assert(string.sub("123456789",-2^31, -2^31) == "")
assert(string.sub("\000123456789",3,5) == "234")
assert(("\000123456789"):sub(8) == "789")

-- testing string.find
assert(string.find("123456789", "345") == 3)
a,b = string.find("123456789", "345")
assert(string.sub("123456789", a, b) == "345")
assert(string.find("1234567890123456789", "345", 3) == 3)
assert(string.find("1234567890123456789", "345", 4) == 13)
assert(string.find("1234567890123456789", "346", 4) == nil)
assert(string.find("1234567890123456789", ".45", -9) == 13)
assert(string.find("abcdefg", "\0", 5, 1) == nil)
assert(string.find("", "") == 1)
assert(string.find("", "", 1) == 1)
assert(not string.find("", "", 2))
assert(string.find('', 'aaa', 1) == nil)
assert(('alo(.)alo'):find('(.)', 1, 1) == 4)

assert(string.len("") == 0)
assert(string.len("\0\0\0") == 3)
assert(string.len("1234567890") == 10)

assert(#"" == 0)
assert(#"\0\0\0" == 3)
assert(#"1234567890" == 10)

-- testing string.byte/string.char
assert(string.byte("a") == 97)
assert(string.byte("\xe4") > 127)
assert(string.byte(string.char(255)) == 255)
assert(string.byte(string.char(0)) == 0)
assert(string.byte("\0") == 0)
assert(string.byte("\0\0alo\0x", -1) == string.byte('x'))
assert(string.byte("ba", 2) == 97)
assert(string.byte("\n\n", 2, -1) == 10)
assert(string.byte("\n\n", 2, 2) == 10)
assert(string.byte("") == nil)
assert(string.byte("hi", -3) == nil)
assert(string.byte("hi", 3) == nil)
assert(string.byte("hi", 9, 10) == nil)
assert(string.byte("hi", 2, 1) == nil)
assert(string.char() == "")
assert(string.char(0, 255, 0) == "\0\255\0")
assert(string.char(0, string.byte("\xe4"), 0) == "\0\xe4\0")
assert(string.char(string.byte("\xe4l\0�u", 1, -1)) == "\xe4l\0�u")
assert(string.char(string.byte("\xe4l\0�u", 1, 0)) == "")
assert(string.char(string.byte("\xe4l\0�u", -10, 100)) == "\xe4l\0�u")

assert(string.upper("ab\0c") == "AB\0C")
assert(string.lower("\0ABCc%$") == "\0abcc%$")
assert(string.rep('teste', 0) == '')
assert(string.rep('t�s\00t�', 2) == 't�s\0t�t�s\000t�')
assert(string.rep('', 10) == '')

-- repetitions with separator
assert(string.rep('teste', 0, 'xuxu') == '')
assert(string.rep('teste', 1, 'xuxu') == 'teste')
assert(string.rep('\1\0\1', 2, '\0\0') == '\1\0\1\0\0\1\0\1')
assert(string.rep('', 10, '.') == string.rep('.', 9))
assert(not pcall(string.rep, "aa", 2^30))
assert(not pcall(string.rep, "", 2^30, "aa"))

assert(string.reverse"" == "")
assert(string.reverse"\0\1\2\3" == "\3\2\1\0")
assert(string.reverse"\0001234" == "4321\0")

for i=0,30 do assert(string.len(string.rep('a', i)) == i) end

assert(type(tostring(nil)) == 'string')
assert(type(tostring(12)) == 'string')
assert(''..12 == '12' and type(12 .. '') == 'string')
assert(string.find(tostring{}, 'table:'))
assert(string.find(tostring(print), 'function:'))
assert(#tostring('\0') == 1)
assert(tostring(true) == "true")
assert(tostring(false) == "false")

x = '"�lo"\n\\'
assert(string.format('%q%s', x, x) == '"\\"�lo\\"\\\n\\\\""�lo"\n\\')
assert(string.format('%q', "\0") == [["\0"]])
assert(load(string.format('return %q', x))() == x)
x = "\0\1\0023\5\0009"
assert(load(string.format('return %q', x))() == x)
assert(string.format("\0%c\0%c%x\0", string.byte("\xe4"), string.byte("b"), 140) ==
              "\0\xe4\0b8c\0")
assert(string.format('') == "")
assert(string.format("%c",34)..string.format("%c",48)..string.format("%c",90)..string.format("%c",100) ==
       string.format("%c%c%c%c", 34, 48, 90, 100))
assert(string.format("%s\0 is not \0%s", 'not be', 'be') == 'not be\0 is not \0be')
assert(string.format("%%%d %010d", 10, 23) == "%10 0000000023")
assert(tonumber(string.format("%f", 10.3)) == 10.3)
x = string.format('"%-50s"', 'a')
assert(#x == 52)
assert(string.sub(x, 1, 4) == '"a  ')

assert(string.format("-%.20s.20s", string.rep("%", 2000)) ==
                     "-"..string.rep("%", 20)..".20s")
assert(string.format('"-%20s.20s"', string.rep("%", 2000)) ==
       string.format("%q", "-"..string.rep("%", 2000)..".20s"))

-- format x tostring
assert(string.format("%s %s", nil, true) == "nil true")
assert(string.format("%s %.4s", false, true) == "false true")
assert(string.format("%.3s %.3s", false, true) == "fal tru")
local m = setmetatable({}, {__tostring = function () return "hello" end})
assert(string.format("%s %.10s", m, m) == "hello hello")


assert(string.format("%x", 0.3) == "0")
assert(string.format("%02x", 0.1) == "00")
assert(string.format("%08X", 2^32 - 1) == "FFFFFFFF")
assert(string.format("%+08d", 2^31 - 1) == "+2147483647")
assert(string.format("%+08d", -2^31) == "-2147483648")


-- longest number that can be formated
local largefinite = (numbits("float") >= 64) and 1e308 or 1e38
assert(string.len(string.format('%99.99f', -largefinite)) >= 100)


-- testing large numbers for format

assert(string.format("%08x", 2^22 - 1) == "003fffff")
assert(string.format("%d", -1) == "-1")
assert(string.format("0x%8X", 0x8f000003) == "0x8F000003")


local max, min = 2^63 - 1, -2^63
if max > 0 and min < 0 then
  -- "large" for 64 bits
  assert(max + 1 == min)
  assert(string.format("%x", 2^52 - 1) == "fffffffffffff")
  assert(string.format("0x%8X", 0x8f000003) == "0x8F000003")
  assert(string.format("%d", 2^53) == "9007199254740992")
  assert(string.format("%d", -2^53) == "-9007199254740992")
  assert(string.format("%x", max) == "7fffffffffffffff")
  assert(string.format("%x", min) == "8000000000000000")
  assert(string.format("%d", max) == "9223372036854775807")
  assert(string.format("%d", min) == "-9223372036854775808")
  assert(tostring(1234567890123) == '1234567890123')
else
  -- "large" for 32 bits
  max, min = 2^31 - 1, -2^31
  assert(max + 1 == min)
  assert(string.format("%8x", -1) == "ffffffff")
  assert(string.format("%x", max) == "7fffffff")
  assert(string.format("%x", min) == "80000000")
  assert(string.format("%d", max) == "2147483647")
  assert(string.format("%d", min) == "-2147483648")
end

if not _noformatA then
  print("testing 'format %a %A'")
  assert(tonumber(string.format("%.2a", 0.5)) == 0x1.00p-1)
  assert(tonumber(string.format("%A", 0x1fffff.0)) == 0X1.FFFFFP+20)
  assert(tonumber(string.format("%.4a", -3)) == -0x1.8000p+1)
  assert(tonumber(string.format("%a", -0.1)) == -0.1)
end


-- errors in format

local function check (fmt, msg)
  local s, err = pcall(string.format, fmt, 10)
  assert(not s and string.find(err, msg))
end

local aux = string.rep('0', 600)
check("%100.3d", "too long")
check("%1"..aux..".3d", "too long")
check("%1.100d", "too long")
check("%10.1"..aux.."004d", "too long")
check("%t", "invalid option")
check("%"..aux.."d", "repeated flags")
check("%d %d", "no value")


assert(load("return 1\n--coment�rio sem EOL no final")() == 1)


assert(table.concat{} == "")
assert(table.concat({}, 'x') == "")
assert(table.concat({'\0', '\0\1', '\0\1\2'}, '.\0.') == "\0.\0.\0\1.\0.\0\1\2")
local a = {}; for i=1,3000 do a[i] = "xuxu" end
assert(table.concat(a, "123").."123" == string.rep("xuxu123", 3000))
assert(table.concat(a, "b", 20, 20) == "xuxu")
assert(table.concat(a, "", 20, 21) == "xuxuxuxu")
assert(table.concat(a, "x", 22, 21) == "")
assert(table.concat(a, "3", 2999) == "xuxu3xuxu")
assert(table.concat({}, "x", 2^31-1, 2^31-2) == "")
assert(table.concat({}, "x", -2^31+1, -2^31) == "")
assert(table.concat({}, "x", 2^31-1, -2^31) == "")
assert(table.concat({[2^31-1] = "alo"}, "x", 2^31-1, 2^31-1) == "alo")

assert(not pcall(table.concat, {"a", "b", {}}))

a = {"a","b","c"}
assert(table.concat(a, ",", 1, 0) == "")
assert(table.concat(a, ",", 1, 1) == "a")
assert(table.concat(a, ",", 1, 2) == "a,b")
assert(table.concat(a, ",", 2) == "b,c")
assert(table.concat(a, ",", 3) == "c")
assert(table.concat(a, ",", 4) == "")

if not _port then

  local locales = { "ptb", "ISO-8859-1", "pt_BR" }
  local function trylocale (w)
    for i = 1, #locales do
      if os.setlocale(locales[i], w) then return true end
    end
    return false
  end

  if not trylocale("collate")  then
    print("locale not supported")
  else
    assert("alo" < "�lo" and "�lo" < "amo")
  end

  if not trylocale("ctype") then
    print("locale not supported")
  else
    assert(load("a = 3.4"));  -- parser should not change outside locale
    assert(not load("� = 3.4"));  -- even with errors
    assert(string.gsub("�����", "%a", "x") == "xxxxx")
    assert(string.gsub("����", "%l", "x") == "x�x�")
    assert(string.gsub("����", "%u", "x") == "�x�x")
    assert(string.upper"���{xuxu}��o" == "���{XUXU}��O")
  end

  os.setlocale("C")
  assert(os.setlocale() == 'C')
  assert(os.setlocale(nil, "numeric") == 'C')

end


-- testing pack/unpack

local numbytes = numbits'integer' // 8

-- basic pack/unpack with default arguments
for _, i in ipairs{0, 1, 2, 127, 128, 255, 0xffffffff, 0xffffffff} do
  assert(string.unpackint(string.packint(i)) == i)
  assert(string.unpackint(string.packint(-i)) == -i)
end

-- default size is the size of a Lua integer
assert(#string.packint(0) == numbytes)
assert(string.packint(-234, 0) == string.packint(-234))

-- endianess
assert(string.packint(34, 4, 'l') == "\34\0\0\0")
assert(string.packint(34, 4, 'b') == "\0\0\0\34")
assert(string.packint(0, 5, 'n') == "\0\0\0\0\0")

assert(string.packint(0x12345678, 4, 'l') == "\x78\x56\x34\x12")
assert(string.packint(0x12345678, 4, 'b') == "\x12\x34\x56\x78")

-- unsigned values
assert(string.packint(255, 1, 'l') == "\255")
assert(string.packint(0xffffff, 3) == "\255\255\255")
assert(string.packint(0x8000, 2, 'b') == "\x80\0")

-- for unsigned, we need to mask results (but there is no errors)
assert(string.unpackint("\x80\0", 1, 2, 'b') & 0xFFFF == 0x8000)

local m = 0xffffffff
assert(string.unpackint('\0\0\0\0\xff\xff\xff\xff', 5, 4, 'b') & m == m)
assert(string.unpackint('\0\0\0\0\xff\xff\xff\xff', 4, 5, 'b') == m)
assert(string.unpackint('\0\0\0\0\xff\xff\xff\xff', 3, 6, 'b') == m)
assert(string.unpackint('\0\0\0\0\xff\xff\xff\xff', 2, 7, 'b') == m)
assert(string.unpackint('\0\0\0\0\xff\xff\xff\xff', 1, 8, 'b') == m)



local function check (i, s, n)
  assert(string.packint(n, i, 'l') == s)
  assert(string.packint(n, i, 'b') == s:reverse())
  assert(string.unpackint(s, 1, i, 'l') == n)
  assert(string.unpackint(s:reverse(), 1, i, 'b') == n)
end


for i = 1, 8 do
  check(i, string.rep("\255", i), -1)
  check(i, "\127" .. string.rep("\0", i - 1), 127)
  check(i, "\209" .. string.rep("\255", i - 1), 209 - 256)
end

for i = 2, numbytes do
  -- unsigned numbers
  assert(string.packint(256^i - 1, i) == string.rep("\255", i))
  check(i, string.rep("\255", i - 1) .. "\0", 256^(i - 1) - 1)

  check(i, "\220" .. string.rep("\0", i - 2) .. "\105",
           105 * 256^(i - 1) + 220)
  check(i, "\123" .. string.rep("\0", i - 2) .. "\160",
           (160 * 256^(i - 1) + 123) - 256^i)
end

-- signal extension
assert(string.unpackint("\x19\xff\0", -3, 3, 'l') == 0xff19)
assert(string.unpackint("\19\xff\0", -3, 2, 'l') == -237)


-- position
local s = "\0\255\123\9\1\47\200"
for i = 1, #s do
  assert(string.unpackint(s, i, 1) % 256 == string.byte(s, i))
end

for i = 1, #s - 1 do
  assert(string.unpackint(s, i, 2, 'b') % 256^2 ==
  string.byte(s, i)*256 + string.byte(s, i + 1))
end

for i = 1, #s - 2 do
  assert(string.unpackint(s, i, 3, 'l') % 256^3 ==
  string.byte(s, i + 2)*256^2 + string.byte(s, i + 1)*256 + string.byte(s, i))
end


-- testing overflow in packing

local function checkerror (n, size, endian)
  local status, msg = pcall(string.packint, n, size, endian)
  assert(not status and string.find(msg, "does not fit"))
end

for i = 1, numbytes - 1 do
  local maxunsigned = 256^i - 1
  local minsigned = -maxunsigned // 2

  local s = string.packint(maxunsigned, i)
  assert(string.unpackint(s, 1, i) % (maxunsigned + 1) == maxunsigned)
  checkerror(maxunsigned + 1, i, 'l')
  checkerror(maxunsigned + 1, i, 'b')

  s = string.packint(minsigned, i)
  assert(string.unpackint(s, 1, i) == minsigned)
  checkerror(minsigned - 1, i, 'l')
  checkerror(minsigned - 1, i, 'b')
end


-- testing overflow in unpacking (note that with an 64-bit integer
-- overflows should be impossible)

checkerror = function (s, size, endian)
  if size > numbytes then
    local status, msg = pcall(string.unpackint, s, 1, size, endian)
    assert(not status and string.find(msg, "does not fit"))
  else
    assert(string.unpackint(s, 1, size, endian))
  end
end

checkerror("\3\0\0\0\0", 5, 'b')
checkerror("\200\0\0\0\0\0", 6, 'b')
checkerror("\3\0\0\0\0\0\0", 7, 'b')
checkerror("\0\0\0\0\0\0\0\3", 8, 'l')
checkerror("\3\xff\xff\xff\xff", 5, 'b')
checkerror("\x7f\xff\xff\xff\xff", 5, 'b')
checkerror("\x7f\xff\xff\xff\xff\xff", 6, 'b')
checkerror("\200\xff\xff\xff\xff\xff\xff", 7, 'b')
checkerror("\xff\xff\xff\xff\xff\xff\xff\200", 8, 'l')
checkerror("\xff\xff\xff\xff\xff\xff\xff\x7f", 8, 'l')
checkerror("\xff\xff\xff\xff\xff\xff\xff\1", 8, 'l')

-- looks like a negative integer, but it is not (because of leading zero)
checkerror("\0\xff\xff\xff\xff\x23", 6, 'b')
checkerror("\0\xff\xff\xff\xff\xff\x23", 7, 'b')

-- check errors in arguments
function check (msg, f, ...)
  local status, err = pcall(f, ...)
  assert(not status and string.find(err, msg))
end

check("string too short", string.unpackint, "\1\2\3\4", 2^63 - 1)
check("string too short", string.unpackint, "\1\2\3\4", 2^31 - 1)
check("string too short", string.unpackint, "\1\2\3\4", 4, 2)
check("endianess", string.unpackint, "\1\2\3\4", 1, 2, 'x')
check("endianess", string.packint, -1, 2, 'x')
check("out of valid range", string.packint, -1, 9)



-- checking pack/unpack of floating numbers

check("string too short", string.unpackfloat, "\1\2\3\4", 2, "f")
check("string too short", string.unpackfloat, "\1\2\3\4\5\6\7", 2, "d")
check("string too short", string.unpackfloat, "\1\2\3\4", 2^31 - 1)

assert(string.unpackfloat(string.packfloat(120.5, 'n', 'n'), 1, 'n', 'n')
   == 120.5)

for _, n in ipairs{0, -1.1, 1.9, 1/0, -1/0, 1e20, -1e20, 0.1, 2000.7} do
  assert(string.unpackfloat(string.packfloat(n)) == n)
  assert(string.unpackfloat(string.packfloat(n, 'd'), 1, 'd') == n)
  assert(string.packfloat(n, 'f', 'l') ==
         string.packfloat(n, 'f', 'b'):reverse())
  assert(string.packfloat(n, 'd', 'b') ==
         string.packfloat(n, 'd', 'l'):reverse())
end

-- for single precision, test only with "round" numbers
for _, n in ipairs{0, -1.5, 1/0, -1/0, 1e10, -1e9, 0.5, 2000.25} do
  assert(string.unpackfloat(string.packfloat(n, 'f'), 1, 'f') == n)
end

-- position
for i = 1, 11 do
  local s = string.rep("0", i)  .. string.packfloat(3.125)
  assert(string.unpackfloat(s, i + 1) == 3.125)
end

if not _port then
  assert(#string.packfloat(0, 'f') == 4)
  assert(#string.packfloat(0, 'd') == 8)
end

print('OK')

