#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import os
import urllib
import cv2
import numpy as np
import pandas as pd
from deepface import DeepFace
from PIL import Image
from mtcnn.mtcnn import MTCNN
from matplotlib import pyplot
from matplotlib.pyplot import imread


# In[ ]:


def DeepFaceR(imgfile, outfile = 'temp.jpg', backend_detector = 'opencv', progress = True, skip_multiface = False):
    if skip_multiface == False:
        print('# Check Number of Faces')
        faces = MTCNN().detect_faces(pyplot.imread(imgfile))
        if (len(faces)>1): 
            print("ERROR: More than one face detected")
        if (len(faces)==1):
            img = DeepFace.detectFace(imgfile, detector_backend = backend_detector, enforce_detection = True, align = True)
            Image.fromarray(np.array(Image.fromarray((img * 255).astype(np.uint8)).resize((224, 224)).convert('L'))).save(outfile)

            prd = DeepFace.analyze(img_path = outfile, actions = ['race'], detector_backend = backend_detector, enforce_detection= False, prog_bar = progress)
            df = pd.DataFrame(prd).dropna(subset=['race']).race.to_frame().T.reset_index()
            df['fn']       = str(imgfile)
            df['detector'] = str(backend_detector)

            os.remove(outfile)
            return(df)
    if skip_multiface == True:
        img = DeepFace.detectFace(imgfile, detector_backend = backend_detector, enforce_detection = True, align = True)
        Image.fromarray(np.array(Image.fromarray((img * 255).astype(np.uint8)).resize((224, 224)).convert('L'))).save(outfile)

        prd = DeepFace.analyze(img_path = outfile, actions = ['race'], detector_backend = backend_detector, enforce_detection= False, prog_bar = progress)
        df = pd.DataFrame(prd).dropna(subset=['race']).race.to_frame().T.reset_index()
        df['fn']       = str(imgfile)
        df['detector'] = str(backend_detector)

        os.remove(outfile)
        return(df)

