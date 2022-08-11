# DeepFaceR
This is an R wrapper for a Python package deepface (https://github.com/serengil/deepface)

# Steps
## 1. Installation

### R

This wrapper relies on an R package "reticulate": 
```
install.package("reticulate")
library("reticulate")
```

Use `use_python()` to enable a specific Python version or `use_condaenv` to enable a specific Python version in Conda. 
Make sure the following packages are installed in your Python:
```
os
urllib
numpy
pandas
deepface
cv2
PIL
mtcnn
matplotlib
```
If not, use `py_install()` (or `conda_install` if using Conda environment) in R to install packages. For example, 
```
py_install('cv2')
```

If neither Conda or Python is installed yet, download Anaconda.org (https://www.anaconda.com/) and run the following code:
```
python.pkgs <- c('os', 'urllib', 'cv2', 'numpy', 'pandas', 'deepface', 'PIL', 'mtcnn', 'matplotlib')
conda_create('DeepFaceR')
for (pkg in python.pkgs) conda_install('DeepFaceR', pkg)
use_condaenv('DeepFaceR')
```
This code creates a new Conda environment called `DeepFaceR` and installs all necessary Python packages. 

## 2. Download DeepFaceR.R
Download DeepFaceR.R to your working directory and call the program in R using 
```
source('DeepFaceR.R')
```

## 3. Run
Ethnorace prediction can be performed using the function `DeepFaceR`. For example,
```
df = DeepFaceR(imgfile = 'FULL_PATH_TO_YOUR_IMAGE_FILE')
```
WHAT IT DOES: The function performs the following tasks:
- It detects the number of faces in a given image using `MTCNN`
- If more than one face is detected, it returns an error `ERROR: More than one face detected` and the code stops.
- If only one face is detected, it proceeds to the following steps:
  - It pre-processes the image by detecting and aligning the face using `DeepFace.detectFace`.
  - It then outputs the pre-processed image as a temporary file.
  - It then predicts an individual's ethnorace using `DeepFace.analyze`.
 
OUTPUT: The function outputs a dataframe containing probabilities assigned to each of the 6 ethnorace category, name of the image file, and name of the backend detector employed.

PARAMETERS:
- `imgfile` = full path to your image file (e.g., 'images/image1.jpeg')
- `outfile` = full path of the processed image file that are to be saved temporarily (default: saves as 'temp.jpg' to the working directory)
- `backend_detector` = face detector backend choice from 'retinaface', 'mtcnn', 'opencv', 'ssd' or 'dlib' during the pre-processing stage (default: 'opencv'). See https://github.com/serengil/deepface/blob/master/deepface for details.
- `skip_multiface` = if `True` it skips the detection of multiple faces using `MTCNN`. Set this to `False` if you already know that there's only one face in the image and want to speed the process  (default: False)

## 4. Example
```
library(reticulate)
source('DeepFaceR.R')

df <- plyr::ldply(list.files('images', full.names = T, recursive = T), function(x){
  df = DeepFaceR(imgfile = x, skip_multiface = FALSE)
  return(df)
})

print(df)
```

|index |  asian|   indian  |  black   | white |middle eastern| latino hispanic     |            fn |detector|
|------|------|------|------|------|------|------|------|------|
| race  |6.56082403 |5.34949462 |62.598781276  |3.887645  |     3.017876      |  18.58537 |images/image2.jpeg  | opencv|
| race |20.92332840 |1.12569947 | 0.433347281 |62.203264   |    4.683015       | 10.63134 |images/image3.jpeg  | opencv |
| race | 0.03598446 |0.02714235 | 0.001058319 |80.777507    |   3.225864        |15.93245 |images/image4.jpeg  | opencv|
