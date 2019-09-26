This program is aimed at analyzing synchrony between single cells expression of HES signals. Whenever a numerical value is modified, it is necessary to press Enter for the program to validate this change. 

1. "Select Folder" allows you to open the folder containing the HES images as well as the position of cells identified on the cherry channel. 
2. "Numb Frame": indicate here the number of  frames to be analyzed in your movie. 80 is the appropriate number for the test data folder. 
3. "Typical Distance" is the maximal movement of cells between two consecutive frames
4. "Skipped Frames"  allows the tracking program to identify tracks even if the cell was not detected in all consecutive frames; the value indicates the number of frames allowed to skip. 
5. "Start from frame" box allows indicating whether all tracks shall start from Frame 1 only ("1 only") or from any frame ("All Frames"). 
6. "Track!": pressing this button will track the cells according to the parameters set up above and save the tracks.
7. "Show the track!" displays a tracked cell. The box on the right allows to specify which track to plot. "0" plots a random track. 
8. "Plot Mean hes" shows a plot of the averaged hes value for tracks of a minimal duration specified on the right. 
9. "Plot all hes" plots the hes expression for all tracks together with the averaged value.
10. "Analyze Synchrony" computes phases and performs the analyses described in the paper.
11. "Get oscillation period" computes the period of the oscillation using two methods (as indicated in the paper): the fast Fourier transform and the cross correlation. 