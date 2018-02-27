# Photomosaic
Personal Project that makes a photomosaic for a given picture using frames in a movie. 

This project was initiated by an idea of making a photomosaic of a picture of my girlfriend and me as the gift for our first Valentine. The source pictures with which to make the photomosaic was taken from an anime movie called Your Name. 

Originally, the code was only able to perform on a 4k picture. In the past two weeks, I have generalized it to be able to perform on any picture regardless of 

The steps of the project can be broken down as follows:

1. A total of 153342 frames are extracted from the .mp4 file of the movie, and saved as 160px by 90px pictures as the reservoir of source pictures. The pictures then pass a step to reduce duplicates, resulting about 2000 eliminated. This increases efficiency a bit. 
This step is done in the BuildDatabase_MatrixMethod.m script, and all the following steps are done in the BuildPictureGPU_MatrixMethod.m script. The separation of scripts is because the reservoir can be reused. 

2. The target image (can be any size, but recommended to be high-definition) is broken down into components. The components should have sizes 16-by-9 or a multiple of it: The larger the components are, the less detail that the resulting image might retain. If the size of the target image cannot be divided by the size of components, the remainder area is discarded. This is acceptable as the discarded area is extremely small (for a 6000x4000 image with 32x18 components, the resulting image is 5984x3996, with 0.37% loss of pixels). 

3. In a loop over all the components, each component is compared with every picture in the reservoir. The comparison is done by calculating the sum of squared errors between two images. This step was vectorized and achieved more than 80x reduction of running time.  

4. With regard to each component, the picture with the least error compared to it is chosen to replace it. The result image is then rebuilt with all the chosen pictures component-by-component and is then saved. 
