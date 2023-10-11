import openpifpaf
import cv2
import matplotlib
import math
import torch
import os
import io
import csv
import PIL
import numpy as np

class Detector:
    
    # Performs pose estimation on a given .mp4-file utilizing the PifPaf-algorithm
    
    def __init__(self, file = None):
        self.setFile(file)
        self.csv_file = None
        # Setting up OpenPifPaf
        self.device = torch.device('cuda')
        # load trained neural network
        net_cuda, _ = openpifpaf.network.Factory(checkpoint='shufflenetv2k16-withdense').factory()

        self.net = net_cuda.to(self.device)

        openpifpaf.decoder.utils.CifSeeds.set_threshold(0.5) 
        openpifpaf.decoder.utils.nms.Keypoints.set_keypoint_threshold(0.2)
        openpifpaf.decoder.utils.nms.Keypoints.set_instance_threshold(0.2)
        self.processor = openpifpaf.decoder.factory([hn.meta for hn in self.net.head_nets])


        self.preprocess = openpifpaf.transforms.Compose([
          openpifpaf.transforms.NormalizeAnnotations(),
          openpifpaf.transforms.CenterPadTight(16),
          openpifpaf.transforms.EVAL_TRANSFORM,
        ])
    
    def setFile(self, file):
        
        
        
        
        self.file = file
       
       
        if (file != None):
       #Setting up the .csv file where all the features will be written
            path, self.filename = os.path.split(self.file)
            pre, ext = os.path.splitext (self.filename)
            csv_filename = os.path.join(path, pre + '.csv' )
            self.csv_file = open(csv_filename, 'w', newline='')
            self.writer = csv.writer(self.csv_file)
    
    

    def estimate(self):
        
        
        
        if(self.file != None):
            print("Pose Estimation is carried out for " + self.file)
           
            cam = cv2.VideoCapture(self.file)
          
            length = int(cam.get(cv2.CAP_PROP_FRAME_COUNT))
            fps = int(cam.get(cv2.CAP_PROP_FPS))
            self.writer.writerow(["Pose Estimation from:",self.filename ,"Number of Frames:", length, "FPS:", fps])
           

            
            currentFrame = 1
            while(True): 
            # reading from frame 
                ret,frame = cam.read() 
                if ret:
                    print( currentFrame , "/", length, " done...",end = "\r")
                   
                    # convert frame from BGR to RGB
                    frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB) #this may be unnecessary
                    pil_im = PIL.Image.fromarray(frame_rgb)
                
                    data = openpifpaf.datasets.PilImageList([pil_im], preprocess=self.preprocess)

                    loader = torch.utils.data.DataLoader(
                    data, batch_size=1, pin_memory=True, 
                    collate_fn=openpifpaf.datasets.collate_images_anns_meta)
                    # prediction
                    for images_batch, _, __ in loader:
                        predictions = self.processor.batch(self.net, images_batch, device=self.device)[0]
                        if len(predictions) >= 1:
                          
                            k=predictions[0].data.tolist()
                            self.writer.writerow([currentFrame]+k)
                    
                    
                    
                    currentFrame += 1
                else:
                    print("")
                    print("Done")
                    break     
            # Release all space and windows once done 
            cam.release() 
            cv2.destroyAllWindows()
        else:
            print("No file set.")

