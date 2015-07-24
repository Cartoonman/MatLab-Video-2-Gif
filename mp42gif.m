% This program converts MP4 video file into an animated GIF file.
% The GIF format have advantages especially in Power-Point presentation,
% and in internet browsers.
%
% Written by Moshe Lindner , Bar-Ilan University, Israel.
% September 2010 (C)
% Modified and revised by Carl Colena, City College of New York, United States
% August 2015
% Covered with the BSD Licence:

%{
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the distribution

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
%}
% Tested to work as of R2015a.

clear all
[file_name file_path]=uigetfile({'*.mp4','MP4 video files'},'Select Video file');
[file_name2 file_path2]=uiputfile('*.gif','Save as animated GIF',[file_path,file_name(1:end-3)]);
avi_file=VideoReader([file_path,file_name]); % Reads Video File
avi_info=get(avi_file); % Gathers Video info (Not used for now)


lps=questdlg('How many loops?','Loops','Forever','None','Other','Forever'); % Loop prompt
switch lps
    case 'Forever'
        loops=65535;
    case 'None'
        loops=1;
    case 'Other'
        loops=inputdlg('Enter number of loops? (must be an integer between 1-65535)        .','Loops');
        loops=str2num(loops{1});
end
fps=avi_file.FrameRate;
delay=inputdlg('What is the delay time? (in seconds)        .','Delay',1,{num2str(1/fps)});
delay=str2num(delay{1});
dly=questdlg('Different delay for the first image?','Delay','Yes','No','No');
if strcmp(dly,'Yes')
    delay1=inputdlg('What is the delay time for the first image? (in seconds)        .','Delay');
    delay1=str2num(delay1{1});
else
    delay1=delay;
end
%%% Edited out due to inability to count w/o deprecation
%dly=questdlg('Different delay for the last image?','Delay','Yes','No','No');
%if strcmp(dly,'Yes')
%    delay2=inputdlg('What is the delay time for the last image? (in seconds)        .','Delay');
%    delay2=str2num(delay2{1});
%else
%    delay2=delay;
%end
h = waitbar(0,['0% done'],'name','Progress') ; %Progress par initialization
i = 0;
while hasFrame(avi_file) %%% Loop to convert each frame in the video
    [M  c_map]= rgb2ind(readFrame(avi_file),256);
    i=i+1;
    if i==1
        imwrite(M,c_map,[file_path2,file_name2],'gif','LoopCount',loops,'DelayTime',delay1)
    %elseif i==(avi_file.Duration*avi_file.FrameRate)
    %    imwrite(M,c_map,[file_path2,file_name2],'gif','WriteMode','append','DelayTime',delay2)
    else
        imwrite(M,c_map,[file_path2,file_name2],'gif','WriteMode','append','DelayTime',delay)
    end
    waitbar(i/(avi_file.Duration*avi_file.FrameRate),h,[num2str(round(100*i/(avi_file.Duration*avi_file.FrameRate))),'% done']) ;
end
close(h);
msgbox('Finished Successfully!')