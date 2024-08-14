function openIoPort(address)
% Open the port to send trigger codes and initialize global IOPORT variable containing the
% port address and I/O object. Requires the io64.mexw64 file.
% 
% For the setup in the lab in 138, the I/O port address is 'DFC8'.
%
% USE:
%         openIoPort('DFC8');
%
% 5/08/2023 Written ------------------------------------- CD ------ coledembski@gmail.com

global IOPORT

if ischar(address)
    address = hex2dec(address);
end

IOPORT.obj = io64;
IOPORT.address = address;
IOPORT.status = io64(IOPORT.obj);