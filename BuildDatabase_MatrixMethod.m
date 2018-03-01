%function BuildDatabase_MatrixMethod()

%Setup hyperparameters

workSpace_Name='Database.mat';
%Setup hyperparameters complete.


vid=VideoReader(input('Please enter the name of video for frame-ripping (inlcuding extension): ','s'));
%Create video reader object and load KIMINONAWA.mp4.
info=get(vid);
sizeX=160;
sizeY=floor(info.Height/info.Width*160);
picPool_temp=struct('cdata',zeros(sizeY,sizeX,3,'uint8'),'colormap',[]);
%Declare a struct that contains all the frames as RPG pictures.

i=0;
while hasFrame(vid)
    i=i+1
    picPool_temp(i).cdata=imresize(readFrame(vid),[sizeY,sizeX]);
end
numTotalPictures=i;

picPool=zeros(sizeY,sizeX,3,i,'uint8');
for i=1:numTotalPictures
    picPool(:,:,:,i)=picPool_temp(i).cdata;
end
%Read the whole movie into picPool array and record the total number of
%frames as numTotalPictures.

stepX=floor(size(picPool,2)/10);
stepY=floor(size(picPool,1)/10);
temp=reshape(picPool(1:stepY:size(picPool,1),1:stepX:size(picPool,2),:,:),[],numTotalPictures)';
[~,ia,~]=unique(temp,'rows');
% picPool_unique=temp(ia,:)';
% picPool=reshape(picPool_unique,sizeY,sizeX,3,[]);
picPool=picPool(:,:,:,ia);

save(workSpace_Name,'picPool','-V7.3');
%Save the workspace as a file.

disp('Completed reading the movie file and saving workspace.');

%end
