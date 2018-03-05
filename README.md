# Photomosaic
Personal Project that makes a photomosaic for a given picture using frames in a movie. 

This project was initiated by an idea of making a photomosaic of a picture of my girlfriend and me as the gift for our first Valentine. The source pictures with which to make the photomosaic was taken from an anime movie called Your Name. 

Originally, the code was only able to perform on a 4k picture. In the past two weeks, I have generalized it to be able to perform on any picture regardless of its aspect ratio. 

The steps of the project can be broken down as follows:

1. All frames are extracted from the movie (specified by the user, has to be under the same folder with the scripts), and saved as 160px by 90px (or 160px by X-px where X is determined by the aspect ratio of the movie) pictures as source pictures. Duplicate-reduction is applied to the source pictures to accelerated the selection process later on. 
This step is done in the BuildDatabase_MatrixMethod.m script, and all the following steps are done in the BuildPictureGPU_MatrixMethod.m script. The separation of scripts is because the reservoir can be reused. 

2. The target image (can be any size, but recommended to be high-definition) is broken down into components. The components should have same aspect ratio as the source images: The larger the components are, the less detail that the resulting image might retain. If the size of the target image cannot be divided by the size of components, the remainder area is discarded. This is acceptable as the discarded area is usually very small (for a 6000x4000 image with 32x18 components, the resulting image is 5984x3996, with 0.37% loss of pixels). 

3. In a loop over all the components, each component is compared with every picture in the reservoir. The comparison is done by calculating the sum of squared errors between two images. This step was vectorized and achieved more than 80x reduction of running time.  

4. With regard to each component, the picture with the least error compared to it is chosen to replace it. The result image is then rebuilt with all the chosen pictures component-by-component and is then saved. 
