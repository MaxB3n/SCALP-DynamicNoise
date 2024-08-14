function sendTrigger(code)
% Sends trigger code to port contained in global IOPORT variable initialized by the
% openIoPort function. Requires the io64.mexw64 file.
%
% NOTE: Adds lag of 1/2 ms to code execution so that the port can be cleared. If you have
% very compute intensive code (or are having timing problems and are troubleshooting),
% you can get rid of the last two lines but ensure that you will nver be attempting to 
% send the same trigger code twice in a row because the port needs to be cleared by
% sending a 0 in order to do that.
%
% NOTE ON THE NOTE: It's a bad idea for your code to be so heavy that you're depending on 
% a half ms to get proper presentation time, even at 120 hz. First make sure it's actually
% a speed issue, not something else. If so, work on isolating the bottlenecks in your code
% and optimize it to run faster.
%
% 5/11/2023 Written ------------------------------------- CD ------ coledembski@gmail.com

global IOPORT;

io64(IOPORT.obj,IOPORT.address,code);
WaitSecs(0.00075);
io64(IOPORT.obj,IOPORT.address,0);
