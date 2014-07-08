Sustainability Indicators (SI) News Classifier
==================
The source code provided in this repository were developed as part of the research project presented in <a href="http://hdl.handle.net/2142/45309"> <i> Advancing sustainability indicators through text mining: a feasibility demonstration. </i></a> The project is licensed under The University of Illinois/NCSA Open Source License (NCSA) (READ License.txt) and it was last updated on June 25, 2014. The repository contains:
<ul>
<li> The code for the classification algorithm presented in Rivera et. al., (2013) (SI_News_Classifier.m  and associated fucntions files). </li>
<li> The RapidMiner_5 workflow used to pre-process the data. </li>
<li> An illustrative example of its use and implementation. </li>
</ul>

Further development of the algorithm, suggestions, corrections and new examples are always encouraged and welcome.

### Citing this work
##### We kindly ask any future publications using this software include a reference to the following publication:   Rivera, S., Minsker, B., Work, D. and Roth, D. (2013) “Advancing sustainability indicators through text mining: a feasibility demonstration.” <i> submitted to Environmental Modeling and Software.

###### Note: A python copy of the code will be release later this year (2014).


## Installation

### Requirements
<ol>
<li> The latest version of the source code was developed using Matlab (R2008a), however the code was tested and validated in later versions. A valid copy of the software and a license (can be educational) is needed.
</li>
 
<li> As stated in Rivera et. al., (2013), the implementation of the code requires the additional installation of the <i>Dataless Classification</i> software developed by the Cognitive Computation Group led by Professor Daniel Roth at the University of Illinois at Urbana-Champaign and available at: <a href = 'http://cogcomp.cs.illinois.edu/page/software_view/Descartes'> <i> Importance of Semantic Representation: Dataless Classification </i></a>. Instructions on the installation and setup of the <i> Dataless Classification </i> can be found in the link as well. To use the <i> Dataless Classification <i/> you will only need to provide the path to the installation folder (e.g. '../descartes-0.2/bin/DESCARTES').
</li>
</ol>


### Install

To begin using the function, download and integrate function into your code. Be sure to keep the provided archiving structure. Changes in the archiving structure will require modifications to the paths used in the source code.

## Implementation example

An illustartive example has been provided with the source code to help users udenrtand the structure of the input and output data. As part of the illustrative example the following files were inclueded:

<ul>
<li> News_Data.xls - The data used in this illustrative example was gathered by using news of different sources.
<ul>
<li> News_Labels_and_Sources - Provides a list of the news' sources and their labels.
<li> Words - List of all the words in the set of news articles obtained after pre-processing (tokenization and elimination of stop-words)
</ul>
<li> Example Data - Word-bag (binary and tf-dif) matrix, news labels, training and testing set.
<li> Example_1.m - Matlab file with the implementation example.
</ul>

###### Note: The set of news was pre-processed using the provided RapidMiner 5 workflow. Special attention should be paid to the order in which RapidMiner 5 and Matlab read the news articles as they are not necessarily the same.

The main script is the Example_1.m. Before running the script the appropiate path to the folder containing the <i>Dataless Classification </i> (e.g. '../descartes-0.2/bin/DESCARTES') should be provided.


