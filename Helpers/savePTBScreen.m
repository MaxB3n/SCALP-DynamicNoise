function savePTBScreen(w,fileName)

bmp = Screen('GetImage', w) ;
imwrite(bmp, fileName,'png')

end