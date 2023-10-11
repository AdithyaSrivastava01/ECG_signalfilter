from detection import Detector
import argparse
import os.path
from pathlib import Path

parser = argparse.ArgumentParser()    
parser.add_argument('--src', dest = 'src' , action = 'store', help = "File name of video that is to be estimated", default = None)
args = parser.parse_args()

if args.src != None:
    *_, ext = os.path.splitext(args.src)
    if(ext) == ".mp4":
        if os.path.isfile(args.src):
            
            # estimate keypoints
            est =Detector(args.src)
            est.estimate()

            
        else:
            print("Video-File does not exist.")
    
else:
    print("No source given.")
