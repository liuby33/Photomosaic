# PictureAccolade
Personal Project that makes an accolade for a given 1080P picture with frames in an MP4 movie. 

This project was inspired by an idea of making an accolade of a picture of my girlfriend and I out of frames from Anime Movie "Your Name". 
The steps of the project can be broken down as follows:
1. A total of 153342 frames are extracted from the .mp4 file of the movie, and saved as 160px by 90px pictures as the reservoir of source pictures. This step is done in the BuildDatabase.m script. 
2. The target photo (Must be 16:9) is broken down into X-by-X components, each with size 16 by 9. Therefore, horizontal size of the target photo should equal to X times 16 and vertical size = X * 9. The following steps are done in the BuildPicture.m script.
3. Each component is then compared with every picture in the reservoir by an error function equal to the sum of squared errors. The picture with the least error is chosen to replace this component. 
4. The target photo is rebuilt with source picture component-by-component and is then regenerated and saved. 
