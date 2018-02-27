%function BuildDatabase_MatrixMethod()

%Setup hyperparameters
sizeY=90;
sizeX=160;
workSpace_Name='Database.mat';
%Setup hyperparameters complete.


vid=VideoReader(input('Please enter the name of video for frame-ripping (inlcuding extension): ','s'));
%Create video reader object and load KIMINONAWA.mp4.

picPool=zeros(sizeY,sizeX,3,153342,'uint8');
%Declare a struct that contains all the frames as RPG pictures.

i=0;
while hasFrame(vid)
    i=i+1
    picPool(:,:,:,i)=imresize(readFrame(vid),[sizeY,NaN]);
end
numTotalPictures=i;
%Read the whole movie into picPool struct and record the total number of
%frames as numTotalPictures.

disp('Entering the most time-consuming step.');
tic;
temp=reshape(picPool,[],numTotalPictures)';
[~,ia,~]=unique(temp(:,20000:21000),'rows');
picPool_unique=temp(ia,:)';
picPool=reshape(picPool_unique,sizeY,sizeX,3,[]);
toc;
disp('Most time-consuming step finished.');

save(workSpace_Name,'picPool','-V7.3');
%Save the workspace as a file.

disp('Completed reading the movie file and saving workspace.');

%end
