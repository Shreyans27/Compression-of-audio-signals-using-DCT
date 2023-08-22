clc;
clear all;
close all;

load chirp.mat;
song=audioplayer(y,Fs);
filename='chippa.wav';
audiowrite('chippa.wav',y,Fs);
y=y';
info=audioinfo('chippa.wav');
info
z=info.BitsPerSample;
N=length(y);
cr1=N*z;
disp('data of the original signal in KB')
CR1=cr1/1024
%play the song
play(song)
plot(y,'g');
title("Original Signal");
y1 = adpcm_encoder(y);
figure
plot(y1);
title("Encoded Signal");
YY = adpcm_decoder(y1);
filename='chippacompress.wav';
audiowrite('chippacompress.wav',YY,Fs);
info1=audioinfo('chippacompress.wav');
info1
z1=info1.BitsPerSample;
L=length(YY);
cr2=L*z1;
disp('data of the compressed signal in KB')
CR2=cr2/1024
%play the song
soundsc(YY,Fs);
figure
plot(YY,'b');
title("Reconstructed Signal");
figure
plot(y,'g');
hold on
plot(YY,'y');
title("Comparision of Original and Compressed Signal");
d=YY;

function adpcm_y = adpcm_encoder(raw_y)
IndexTable = [-1, -1, -1, -1, 2, 4, 6, 8];
StepSizeTable = [7, 8, 8, 9, 10, 11, 12, 13, 14, 15, 17, 18, 20, 22, 24, 26, 29,
31, 34, 37, 41, 44, 48, 53, 58, 63, 69, 75, 82, 89, 98, 107, 116, 127];
prevsample = 0;
previndex = 1;
Ns = length(raw_y);
n = 1;
raw_y = 127 * raw_y; % 16-bit operation
while (n <= Ns)
predsample = prevsample;
index = previndex;
step = StepSizeTable(index);
diff = raw_y(n) - predsample; %difference
if (diff >= 0)
code = 0;
else
code = 8;
diff = -diff;
end
tempstep = step;
if (diff >= tempstep)
code = bitor(code, 4);
code = bitand(code,15);
diff = diff - tempstep;
end
tempstep = bitshift(tempstep, -1);
if (diff >= tempstep)
code = bitor(code, 2);
code = bitand(code,15);
diff = diff - tempstep;
end
tempstep = bitshift(tempstep, -1);
if (diff >= tempstep)
code = bitor(code, 1);
code = bitand(code,15);
end
diffq = bitshift(step, -3);
if (bitand(code, 4))
diffq = diffq + step;
end
if (bitand(code, 2))
diffq = diffq + bitshift(step, -1);
end
if (bitand(code, 1))
diffq = diffq + bitshift(step, -2);
end
if (bitand(code, 8))
predsample = predsample - diffq;
else
predsample = predsample + diffq;
end
if (predsample > 127)
predsample = 127;
elseif (predsample < -127)
predsample = -127;
end
x=bitand(code,7);
index = index + IndexTable(x+1);
if (index < 1)
index = 1;
end
if (index > 34)
index = 34;
end
prevsample = predsample;
previndex = index;
adpcm_y(n) = bitand(code, 15);
%adpcm_y(n) = code;
n = n + 1;
end
end

function raw_y = adpcm_decoder(adpcm_y)
IndexTable = [-1, -1, -1, -1, 2, 4, 6, 8];
StepSizeTable = [7, 8, 8, 9, 10, 11, 12, 13, 14, 15, 17, 18, 20, 22, 24, 26, 29,
31, 34, 37, 41, 44, 48, 53, 58, 63, 69, 75, 82, 89, 98, 107, 116, 127];
prevsample = 0;
previndex = 1;
Ns = length(adpcm_y);
n = 1;
while (n <= Ns)
predsample = prevsample;
index = previndex;
step = StepSizeTable(index);
code = adpcm_y(n);
diffq = bitshift(step, -3);
if (bitand(code, 4))
diffq = diffq + step;
end
if (bitand(code, 2))
diffq = diffq + bitshift(step, -1);
end
if (bitand(code, 1))
diffq = diffq + bitshift(step, -2);
end
if (bitand(code, 8))
predsample = predsample - diffq;
else
predsample = predsample + diffq;
end
if (predsample > 127)
predsample = 127;
elseif (predsample < -127)
predsample = -127;
end
x=bitand(code,7);
index = index + IndexTable(x+1);
if (index < 1)
index = 1;
end
if (index > 34)
index = 34;
end
prevsample = predsample;
previndex = index;
raw_y(n) = predsample / 127;
n = n + 1;
end
end