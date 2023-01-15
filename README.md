# Ridge counting code for fingerprint images
This function package is designed to count ridge lines of binary skeletonized fingerprint images that intersect GUI chosen line between two points. 
The function horizontal_ridge_count is for a ridge count of a horizonal line and the function ridge_count is for a sloped line. 

The file ridge_count.R contains both functions and is created to for R. 

## Prior fingerprint requirement
Before ridge counting is performed there is a requirement for alter fingerprint images to a black and white binary mode where 0 is chosen as a value for a black pixel.
In the development of the code .png images where used and altared by the use of [Utkarsh-Deshmukh/Fingerprint-Enhancement-Python](https://github.com/Utkarsh-Deshmukh/Fingerprint-Enhancement-Python) for binarizaiton and ridge enhancement along with code from [linbojin/Skeletonization-by-Zhang-Suen-Thinning-Algorithm](https://github.com/linbojin/Skeletonization-by-Zhang-Suen-Thinning-Algorithm) for skeletonization. New images where created for to be used for the code. 

## Input and output
Input for both functions is the location and the name for an image, f.e.
```
horizontal_ridge_count("c:/Folder/Pictures/fingerprint_image.png")
```
or

```
ridge_count("c:/Folder/Pictures/fingerprint_image.png")
```
The ouput is the count of ridge count and a plotted image with intersected points as can be seen below for horizontal_ridge_count():
![This is an image](test.png)

Both functions require input where two points are chose to create the line which intersected ridges wil be counted. 

The horizontal_ridge_count requires the first point to be point who is higher on the plotted image and its the one that controls the x-axis locaiton of the line. 

The ridge_count requires the first point to be the lower point of the image. 

### Notes to to consider

The ridge_count value can be biased when the line is nearly horizontal or vertical so visual confirmaiton is needed for accurate assesement.
