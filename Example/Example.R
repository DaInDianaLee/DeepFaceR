library(reticulate)

use_condaenv("/Users/dianalee/opt/anaconda3/bin/python")
source_python('DeepFaceR.py')
plyr::ldply(list.files('images', full.names = T, recursive = T), function(x){
  df = DeepFaceR(imgfile = 'images/image2.jpeg', outfile = 'test.jpg', skip_multiface = TRUE)
  return(df)
})
