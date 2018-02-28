%function BuildPictureGPU_MatrixMethod()

clear
load Database.mat picPool;
%Uncomment the first line if BuildDatabase.m has never been run before.
targetLocation='Example Target Image.jpg';
resultingPic_Name='Example Result Image.jpg';
target=gpuArray(single(imread(targetLocation)));

%Setup hyperparameters
numTotalPictures=size(picPool,4);
m=45; %Determines the roughness parameter.
n=80;
comparisonKernalY=16;
comparisonKernalX=24; %This sets the size of kernals for comparison. Larger = slower = more accurate result.
roughnessY=floor(size(target,1)/m);
roughnessX=floor(size(target,2)/n);
sizeY=2*m; %Determined by the result image's desired size. 2* means twice the size.
sizeX=2*n;

disp('Hyperparameters are set.');

%Setup hyperparameters complete.

%Read target picture.
picPool_compressed=gpuArray(zeros(comparisonKernalY,comparisonKernalX,3,numTotalPictures,'uint8'));
picPool_compressed(:,:,:,1:numTotalPictures)=imresize(picPool(:,:,:,1:numTotalPictures),[comparisonKernalY,comparisonKernalX]);
targetPic=gpuArray(zeros(comparisonKernalY,comparisonKernalX,3,roughnessY,roughnessX,'single'));

disp('Compressed picture pool created.');

if comparisonKernalY==m
    for i=1:roughnessY
        for j=1:roughnessX
            targetPic(:,:,:,i,j)=target(((i-1)*m+1):(i*m),((j-1)*n+1):(j*n),:);
            %Reconstruct the target picture into roughness*roughness matrix of
            %comparisonKernalY*comparisonKernalX*3 pictures.
            disp([num2str(i*roughnessX+j),' out of ',num2str(roughnessX*roughnessY)]);
        end
    end
else
    for i=1:roughnessY
        for j=1:roughnessX
            targetPic(:,:,:,i,j)=imresize(target(((i-1)*m+1):(i*m),((j-1)*n+1):(j*n),:),[comparisonKernalY,comparisonKernalX]);
            %Reconstruct the target picture into roughness*roughness matrix of
            %comparisonKernalY*comparisonKernalX*3 pictures.
            disp([num2str(i*roughnessX+j),' out of ',num2str(roughnessX*roughnessY)]);
        end
    end
end

disp('Target picture dissection completed.');

k_temp=gpuArray(zeros(roughnessY,roughnessX));

picPool_compressed=single(picPool_compressed);

for i=1:roughnessY
    for j=1:roughnessX
        tic;
        a=(i-1)*roughnessX+j;
        target_compressed=repmat(targetPic(:,:,:,i,j),[1 1 1 numTotalPictures]);
        %Repeat pic 2 by numTotalPictures times and the resulting matrix is
        %comparisonKernalY by comparisonKernalX by 3 by numTotalPictures.
        diff=sum(sum(sum(((picPool_compressed-target_compressed).^2),1),2),3);
        %This vectorization allows the computation of total squared error
        %in one run, with output as a numTotalPictures dimension vector.
        [~, minLoc]=min(diff);
        %Find minimum total squared error and record the frame ID.
        k_temp(i,j)=minLoc;
        t=toc;
        ttemp=t;
        t=t*(roughnessY*roughnessX-a)/3600;
        disp([num2str(a),' out of ',num2str(roughnessY*roughnessX),' segments finished, spent ',...
            num2str(ttemp,3),' seconds, still need ',num2str(t,3),' hours.']);
    end
end

k_temp=gather(k_temp);

count=size(unique(k_temp));
disp(['pictures chosen, a total of ', num2str(count(1)), ' pictures are selected for the result.']);

mm=sizeY*roughnessY;
nn=sizeX*roughnessX;

resultingPic=zeros([mm,nn,3],'uint8');

for i=1:roughnessY
    for j=1:roughnessX
        resultingPic((((i-1)*sizeY+1):i*sizeY),((j-1)*sizeX+1):(j*sizeX),:) ...
            =imresize(picPool(:,:,:,k_temp(i,j)),[sizeY,sizeX]);
    end
end

imwrite(resultingPic,resultingPic_Name);

disp('All operations completed');

%end