
# QU-GENE
## Creating a .qug file
1. Open the excel file 00_qugTemplate2.xlsx
2. Edit the sheet using information gathered from the literature 
    * For map, locus effects, and marker effects:
        * The map contains all markers and QTLs
        * The locus effects only contains QTLs
        * The marker effects only contains markers 
3. Save each sheet individually as a .csv file 
    * Make sure to delete content in unneeded cells (hold ctrl+shift+rightarrow/downarrow) and right click to delete
4. Open the copy_paste file
5. Open R and change the working directory 
6. Make sure csv file names match up with the ones in the copy_paste file 
7. Run the code from the copy_past file in R. This should generate a .qug file 

## Creating a .qmp file
1. Download the template .qmp file 
2. Fill out information about the breeding strategy (e.g. initial population size, number of cycles, number of runs, selection methods, etc.)

## Running QU-GENE
8. Run the QU-GENE engine 
9. Select the .qug file to run 
10. If sucessful, the QU-GENE engine will generate a number of files 
11. Create a .mio file, which should contain the following:
      * .ges file
      * .pop file
      * .qmp file 
      * your new file name
   
