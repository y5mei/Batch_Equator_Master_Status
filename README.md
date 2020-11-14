# Welcome to Batch_Equator Master Status
###  Explanation
---
This is a **Windows Batch Script** made in Nov 2020 for Stackpole International, Ancaster, ON. 

The **Renishaw Equator** is considered as a auto gauge, but not a coordinate measuring machine (CMM), as it does not have a active error mapping method. The error mapping for the Renishaw Equator is conducted by measuring and verifying the **master part** in a regular basis. Therefore, tracking the status of the master verification reports would be a fundamental requirement by the BSI auditor. 

The purpose of this Batch file is to perform a deep first search on every single line of all available .RTF master verification result files, under the current folder. A report will then be generated in the CMD terminal window presenting the following information:
- the shift information
- passing/failing status
- file name
- the detail of the dimensions failed for the master verification (if applicable)

<img src="https://github.com/y5mei/Saved-Pictures/blob/master/equator300.jpg" style="zoom:100%;"/>





###  Usage
---

1. Put the bat files in the same folder where the master verification result files are saved

2. Change the filters to match the file names that you want to this script to check through in line 29. For example, I am matching every result file which contains the string "OP10" in its' file name with the code below:

  `dir "%CD%\"*OP10*.RTF /b /o-d > fileslist.txt`

3. Double click the bat file, a status report will automatically show up in the CMD terminal. The status report is in time descending order, and will show pass, fail or not finished with colour coding.

### Demo

___


<img src="https://github.com/y5mei/Saved-Pictures/blob/master/RenishawDemo.gif" style="zoom:100%;"/>