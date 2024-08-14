function waitUntilRefresh(gettime, refresh)

 if refresh > gettime 
                pause((refresh-gettime)-0.03)
 else
                warning(strcat('per-frame code took took longer than a frame! It took', num2str(gettime)))

 end
end