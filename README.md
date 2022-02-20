# custom-hrtf
Generating Adjusted Spatial Audio from  Customized HRTF using 3D3A Lab HRTF Database

In this project, the main objective is to generate an adjusted spatial audio file using a custom-made HRTF, with inputs of images of ear pairs (left, right) and an audio file. 
The custom HRTF shall be based on the 3D3A Lab Head-Related Transfer Function Database [[1]](http://www.princeton.edu/3D3A/HRTFMeasurements.html).

Input: 	images of ears (left/right) of a subject
		azimuth, elevation value
		input audio file to be adjusted
		sampling rate of audio file
Output: 	audio file adjusted using the custom HRTF

Clone this project, and serve it as your workspace.


## Testing
test_customHRTF --> test function. Just run this to check if the project is working. This calls
all the function mentioned below.
![image](https://user-images.githubusercontent.com/46555394/154861070-67747ced-9308-4a85-b545-e75322f8c1ab.png)

## Sample of getting similarity score of input ears vs scanned ears
![image](https://user-images.githubusercontent.com/46555394/154861096-1d462d6a-ae5e-4360-a03b-6cd7d716a050.png)

## Sample Figure Results
Azimuth = 90, Elevation = 0 (Left dominated)
![image](https://user-images.githubusercontent.com/46555394/154861125-ae86e3fd-66a9-4189-aac3-6c9e23658241.png)

Azimuth = 270, Elevation = 0 (Right dominated)
![image](https://user-images.githubusercontent.com/46555394/154861170-db87155c-156d-4511-99fc-ca3ae4688616.png)

Reference for perspective
![image](https://user-images.githubusercontent.com/46555394/154861191-80de8415-7984-44b2-a55d-8232c55e6380.png)


## Code Summary
getSoundCHRTF(); 
Generate audio file adjusted using the custom HRTF
Example: 
s = getSoundCHRTF('realears/earright.png', 'realears/earleft.png', 'siren.mp3', 90, 30, 'dfeq', 96000, 1);

Saves the file in the format:
Format:  soundfilename_AZXX_ELYY_TYPE.type'
Example: siren.mp3_AZ90_EL0_DFEQ.wav

>>	getEarScans();
Read all scanned left/right ear images. Generating this is done by opening all .ply files from [2] and load it in Blender.
Next is to crop the left/right ear images with methods listed in [10]. 
>>	getSimilarEars();
Get similar ears from scanned ear list. 
1. Get top N ssim() results between leftRef and leftEarScans (N=5)
2. Get top N ssim() results between rightRef and rightEarScans
3. Get the intersection of 1 and 2
4. If no intersection, get Top 2 from both
>>	getMatchSubjects();
Get the .sofa files of the match indices from the similar ear index.
>>	getNewHRTF();
Gets personalized hrtf from hrtf_list
>>	listenHRTF();
Returns soundOutput based from input sound and hrtf values



