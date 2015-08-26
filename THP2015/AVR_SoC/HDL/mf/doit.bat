set PROJ=test

del %PROJ%.lst
del %PROJ%.obj
del %PROJ%.rom
abc32 %PROJ%.bas
copy %PROJ%.rom %PROJ%.hex
del %PROJ%.rom
del %PROJ%.obj

hex2mem  %PROJ%.hex > %PROJ%.mem
hex2rom %PROJ%.hex rom1200 9l16s >rom1200.vhd
