Instructions: How to use Cell_Detection

1. Run Cell_Detection.m. This will open a window with multiple controls.
2. Click on "Load Image" and select an image in the .mat format, e.g., Cherry_30.mat in the folder, which is the 30th frame of one of our experiments, for the Cherry chanel. The image will appear in the left panel. 
3. Click on "Detect Cells". This should automatically identify the cells. One can optimize detection by selection other parameters (depending on the imaging technique  and quality of the image). These can be entered in the Params panels below.
	3.a. Min Area: minimal area of a detected cell, in pixel (default, 15 pixels).
	3.b. Threshold Max: maximal threshold value used to detect cells, in fraction of maximal amplitude. (default, 0.3). Too high max thresholds will fail identifying some cells.
	3.c. Threshold Min: minimal threshold value used to detect cells, in fraction of maximal amplitude. (default, 0.3). Too low value will yield noisy detection.
	3.d. Number of steps: number of intermediate thresholds used for detection, here, 1. 
4. Refine cell detection by removing false positive ("Remove" button) or adding  missed cells ("Add" button). The "Undo" button cancels the last operation (only one operation is stored in memory, so only the last "Remove" or "Add" operation can be undone). "Replot" shows a clean detection, with yellow cells those that were added manually.
5. "Save Cell Position" will save the position of the detected cells in a text file. 