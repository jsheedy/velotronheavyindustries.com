import numpy as np
from PIL import Image

data = np.fromfile('data/float32.dat', dtype=np.float32)
data = data.reshape((360,720))
Image.fromarray(data*10**7).show()
