Sustainability Indicators (SI) News Classifier
==================
The source code provided in this repository were developed as part of the research project presented in <a href="http://hdl.handle.net/2142/45309"> <i> Advancing sustainability indicators through text mining: a feasibility demonstration. </i></a> The project is licensed under The University of Illinois/NCSA Open Source License (NCSA) (READ License.txt) and it was last updated on June 25, 2014. The repository contains:
<ul>
<li> The m-code codes for the classification algorithm presented in Rivera et. al., (2013) (SI_News_Classifier.m  and associated fucntions files). </li>
<li> The RapidMiner_5 workflow used to pre-process the data. </li>
<li> An illustrative example of its use and implementation. </li>
</ul>

Further development of the algorithm, suggestions, corrections and new examples are always encouraged and welcome.

### Citing this work
##### We kindly ask any future publications using this software to include a reference to the following publication:   Rivera, S., Minsker, B., Work, D. and Roth, D. (2013) “Advancing sustainability indicators through text mining: a feasibility demonstration.” <i> submitted to Environmental Modeling and Software.

###### Note: A python copy of the code will be release later this year (2014). The documentation will be changed to address any concerns related to the python copy.


## Installation

### Requirements
<ol>
<li> The latest version of the source code was developed using Matlab (R2008a), however the code was tested and validated in later versions. A valid copy of the software and a license (can be educational) is needed.
</li>
 
<li> As stated in Rivera et. al., (2013), the implementation of the code requires the additional installation of the <i>Dataless Classification</i> software developed by the Cognitive Computation Group led by Professor Daniel Roth at the University of Illinois at Urbana-Champaign. The software is available at: <a href = 'http://cogcomp.cs.illinois.edu/page/software_view/Descartes'> <i> Importance of Semantic Representation: Dataless Classification </i></a>. Instructions on the installation and setup of the <i> Dataless Classification </i> can be found in the provided link. <b>The <i> Dataless Classification <i/> is integrated into the source codes by providing the path to the installation folder (e.g. '../descartes-0.2/bin/DESCARTES').</b>
</li>
</ol>


### Install

To begin using the classification algorithm, download and integrate the <b>SI_News_Classifier.m</b> function into your code. Be aware that if the provided archiving structure is changed further modifications could be required to the paths hard coded into the source code.

## Example of implementation

An illustartive example has been provided with the source code to help users udenrtand the structure of the input and output data. The example contains a total of 26 news articles divided in the following hierarchical tree:


  <head>  
   <script type='text/javascript' src='https://www.google.com/jsapi'></script>  
   <script type='text/javascript'>  
    google.load('visualization', '1', {packages:['orgchart']});  
    google.setOnLoadCallback(drawChart);  
    function drawChart() {  
     var data = new google.visualization.DataTable();  
     data.addColumn('string', 'Node');  
     data.addColumn('string', 'Parent');  
     data.addRows([  
      ['1', ''],  
      ['1.1', '1'],  
      ['1.2', '1'],  
      ['1.1.1', '1.1'],  
      ['1.1.2', '1.1'],  
      ['1.1.3', '1.1'],  
      ['1.2.1', '1.2'],  
      ['1.2.2', '1.2'],  
      ['1.1.1.1', '1.1.1'],  
      ['1.1.1.2', '1.1.1'],  
      ['1.1.3.1', '1.1.3'],  
      ['1.2.2.1', '1.2.2'],  
      ['1.2.2.2', '1.2.2']  
     ]);  
     var chart = new google.visualization.OrgChart(document.getElementById('chart_div'));  
     chart.draw(data);  
    }  
   </script>  
  </head>  
   
   <div id='chart_div'></div>  
  





As part of the illustrative example the following files were inclueded:

<ul>
<li> News_Data.xls - Metadata of news articles used for the illustrative example. Below a list of the workbooks:
<ul>
<li> News_Labels_and_Sources - Provides a list of the news sources and their labels
<li> Words - List of all the words in the set of news articles obtained after pre-processing (tokenization and elimination of stop-words)
</ul>
<li> Example Data - Word-bag (binary and tf-dif) matrix, news labels, training and testing set
<li> Example_1.m -  Main m-file for the implementation example
</ul>

###### Note: The set of news was pre-processed using the provided RapidMiner 5 workflow. Special attention should be paid to the order in which RapidMiner 5 and Matlab read the news articles as they are not necessarily the same.

The main script is the Example_1.m. Before running the script the appropiate path to the folder containing the <i>Dataless Classification </i> (e.g. '../descartes-0.2/bin/DESCARTES') should be modified in the script. 


