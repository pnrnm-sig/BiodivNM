from PIL import Image
import os
import PIL
import glob

#https://www.holisticseo.digital/python-seo/resize-image/

images = [file for file in os.listdir() if file.endswith(('jpeg', 'png', 'jpg'))]

compress = True

for imagefile in images:
    image = Image.open(imagefile)
    sizes = image.size
    max_ = max(sizes)
    min_ = min(sizes)
    if max_<1024:
        pass
    else:
        newmax = 1024
        ratio = newmax/float(max_)
        newmin = int(float(min_) * float(ratio))
        if sizes.index(max_)==0:
            image = image.resize((newmax, newmin), PIL.Image.NEAREST)
        else:
            image = image.resize((newmin, newmax), PIL.Image.NEAREST)
    if compress:
        imagefile=imagefile.replace('.png','.jpg')
        image.save(imagefile, optimize=True, quality=75)
    else:
        image.save(imagefile)
