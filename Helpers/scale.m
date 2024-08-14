function output = scale(input,range)
% output = Scale(input,[range])
% Perform an affine scaling to put data in range [0-1].
    
output = input - min(input(:));
mo = max(output(:));
if mo>0
    output = output ./ mo;
end
if nargin > 1
    r = range(2)-range(1);
    output = output .* r + range(1);
end