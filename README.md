# arqi-frap

This repository is a collection of analysis scripts to process **F**luorescence **R**ecovery **A**fter **P**hotobleaching (FRAP) images  collected to understand the role of **A**ldehyde **r**esponsive **q**uorum-sensing **I**nhibitor (ArqI) in _Pseudomonas aeruginosa_. For details on data collection and interpretation, see the full manuscript "A novel glyoxal-specific aldehyde signaling axis in _Pseudomonas aeruginosa_ that influences quorum sensing and infection" by Dr Christopher Corcoran from the lab of Dr Andrew Ulijasz.

selectAndMaskCellsFRAP.m enables the user to manually select cells for analysis using the cellSelection.fig GUI. The file CellSelection  GUI instructions shows a brief tutorial on how to select cells using the GUI. Cells are stored as cropped and masked cropped cells for further analysis. 
FrapAnalysis.m performs the analysis to obtain diffusion coefficients and mobile fraction from cropped cells. All of the variables are saved as .mat file for further processing. 
plotFrapStatistics.m enables the user to plot the results of the analysis. 
