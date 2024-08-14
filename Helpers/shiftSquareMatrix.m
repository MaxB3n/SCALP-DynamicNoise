function matrix = shiftSquareMatrix(matrix,direction) 

sz = size(matrix);
sz = sz(1) ;
switch direction
        case 4 %LEFT
            tmp = matrix(:,1,:) ;
            matrix(:,1:sz-1,:) = matrix(:,2:sz,:) ;
            matrix(:,sz,:) = tmp ;
        case 3 %UP
            tmp = matrix(1,:,:) ;
            matrix(1:sz-1,:,:) = matrix(2:sz,:,:) ;
            matrix(sz,:,:) = tmp;
        case 2 %RIGHT
            tmp = matrix(:,sz,:) ;
            matrix(:,2:sz,:) = matrix(:,1:sz-1,:) ;
            matrix(:,1,:) = tmp ;
        case 1 %DOWN
            tmp = matrix(sz,:,:) ;
            matrix(2:sz,:,:) = matrix(1:sz-1,:,:) ;
            matrix(1,:,:) = tmp ;
end

end