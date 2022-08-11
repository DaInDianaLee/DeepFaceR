DeepFaceR <- function(imgfile, 
                      outfile = 'temp.jpg', 
                      backend_detector = 'opencv',
                      skip_multiface = FALSE){
  
  library(reticulate)
  oldw <- getOption("warn")
  options(warn=-1)
  
  py_run_string("import os")
  py_run_string("import urllib")
  py_run_string("import cv2")
  py_run_string("import numpy as np")
  py_run_string("import pandas as pd")
  py_run_string("from deepface import DeepFace")
  py_run_string("from PIL import Image")
  py_run_string("from mtcnn.mtcnn import MTCNN")
  py_run_string("from matplotlib import pyplot")
  py_run_string("from matplotlib.pyplot import imread")
  
  py_run_string(paste0('imgfile = "', imgfile, '"'))
  py_run_string(paste0('outfile ="', outfile,'"'))
  py_run_string(paste0('backend_detector ="', backend_detector,'"'))
  
  if (skip_multiface == FALSE){
    py_run_string("faces = MTCNN().detect_faces(pyplot.imread(imgfile))")
    if (length(py$faces)>1){
      print('ERROR: More than one face detected')
      df <- NULL
      return(df)
    }
    else{
      py_run_string("img = DeepFace.detectFace(imgfile, detector_backend = backend_detector, enforce_detection = True, align = True)")
      py_run_string("Image.fromarray(np.array(Image.fromarray((img * 255).astype(np.uint8)).resize((224, 224)).convert('L'))).save(outfile)")
      py_run_string("prd = DeepFace.analyze(img_path = outfile, actions = ['race'], detector_backend = backend_detector, enforce_detection= False, prog_bar = True)")
      py_run_string("df = pd.DataFrame(prd).dropna(subset=['race']).race.to_frame().T.reset_index()")
      py_run_string("df['fn'] = imgfile")
      py_run_string("df['detector'] = str(backend_detector)")
      py_run_string("os.remove(outfile)")
      return(py$df)
    }
  }
  if (skip_multiface == TRUE){
    py_run_string("img = DeepFace.detectFace(imgfile, detector_backend = backend_detector, enforce_detection = True, align = True)")
    py_run_string("Image.fromarray(np.array(Image.fromarray((img * 255).astype(np.uint8)).resize((224, 224)).convert('L'))).save(outfile)")
    py_run_string("prd = DeepFace.analyze(img_path = outfile, actions = ['race'], detector_backend = backend_detector, enforce_detection= False, prog_bar = True)")
    py_run_string("df = pd.DataFrame(prd).dropna(subset=['race']).race.to_frame().T.reset_index()")
    py_run_string("df['fn'] = imgfile")
    py_run_string("df['detector'] = str(backend_detector)")
    py_run_string("os.remove(outfile)")
    return(py$df)
  }
  options(warn = oldw)
}
