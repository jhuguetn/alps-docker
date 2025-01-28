ALPS-docker
[![GitHub release](https://img.shields.io/github/v/release/jhuguetn/alps-docker?logo=github)](
https://github.com/jhuguetn/alps-docker/releases)
[![DockerHub pulls](https://img.shields.io/docker/pulls/jhuguetn/alps?logo=docker)](
https://hub.docker.com/r/jhuguetn/alps/tags)  
===========
Ready-to-use Docker image with `ALPS` script that automatically computes the diffusion 
along perivascular spaces (ALPS) metric from diffusion-weighted images (DWI). ALPS  
script repository: https://github.com/gbarisano/alps/.

References:  
[Liu X., Barisano G., et al., Cross-Vendor Test-Retest Validation of Diffusion Tensor 
Image Analysis along the Perivascular Space (DTI-ALPS) for Evaluating Glymphatic 
System Function. Aging and Disease (2023)](https://doi.org/10.14336/AD.2023.0321-2)   

Find the image in Docker Hub [here](https://hub.docker.com/r/jhuguetn/alps).

Components
----------
* Debian GNU/Linux 11 (bullseye)
* FSL 6.0.7.7 ("[minified](https://osf.io/ph9ex)" version)
* MRtrix3 3.0.4

Usage
-----
```bash
 docker pull jhuguetn/alps
 ...
 docker run -v /data:/data jhuguetn/alps -a /data/in/dwi.nii.gz -m /data/in/dwi.json \   
 -b /data/in/dwi.bval -c /data/in/dwi.bvec -i /data/in/rdwi.nii.gz -n /data/in/rdwi.json \
 -v /data/in/t1.nii.gz -o /data/out
```

Credits
-------
Jordi Huguet ([BarcelonaBeta Brain Research Center](http://barcelonabeta.org))
