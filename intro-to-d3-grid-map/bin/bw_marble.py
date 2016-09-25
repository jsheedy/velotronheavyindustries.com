# http://earthobservatory.nasa.gov/Features/BlueMarble/Images/land_ocean_ice_2048.jpg

import numpy as np
from PIL import Image

im = Image.open('data/land_ocean_ice_2048.jpg')
bytes = im.convert('L').tobytes()
data = np.fromstring(bytes,dtype=np.uint8).astype(np.float32)

with open('data/bw_marble.dat','wb') as f:
    f.write(data)
