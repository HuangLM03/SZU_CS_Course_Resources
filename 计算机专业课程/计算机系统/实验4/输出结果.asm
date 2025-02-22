.ORIG x3000
LEA R0,fir
PUTS
LEA R0,sec
PUTS
LEA R0,thi
PUTS
LEA R0,fou
PUTS
LEA R0,fif
PUTS
LEA R0,six
PUTS
LEA R0,sev
PUTS
LEA R0,eig
PUTS
LEA R0,nin
PUTS
LEA R0,ten
PUTS
LEA R0,ele
PUTS

LEA R0,res
PUTS
res .STRINGZ "Æ½¾Ö\n"

fir .STRINGZ "*1*1*2*1*2*\n"
sec .STRINGZ "111 222 1 2\n"
thi .STRINGZ "*1*2*2*2*1*\n"
fou .STRINGZ "1 2 1 2 111\n"
fif .STRINGZ "*2*2*2*1*1*\n"
six .STRINGZ "222 1 1 2 1\n"
sev .STRINGZ "*2*2*1*1*1*\n"
eig .STRINGZ "2 2 1 1 2 2\n"
nin .STRINGZ "*1*1*2*1*1*\n"
ten .STRINGZ "1 2 1 2 1 2\n"
ele .STRINGZ "*2*1*2*2*2*\n\n"
.END