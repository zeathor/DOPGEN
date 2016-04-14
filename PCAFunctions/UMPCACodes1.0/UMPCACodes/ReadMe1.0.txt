%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Matlab source codes for                              %
%       Uncorrelated Multilinear Principal Component Analysis (UMPCA)         %
%                                                                             %
% Author: Haiping LU                                                          %
% Email : hplu@ieee.org   or   eehplu@gmail.com                               %
% Release date: February 28, 2012                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%[Algorithm]%

The matlab codes provided here implement the UMPCA algorithm presented in the 
paper "UMPCA_TNN09.pdf" included in this package:

	Haiping Lu, K.N. Plataniotis, and A.N. Venetsanopoulos, 
	"Uncorrelated Multilinear Principal Component Analysis for Unsupervised
        Multilinear Subspace Learning",
	IEEE Transactions on Neural Networks, 
	Vol. 20, No. 11, pp. 1820-1836, Nov. 2009.

"maxeig.m" (by Todd K. Moon) is a function used by "UMPCA.m' to get the leading 
eigenvector.
---------------------------


%[Usages]%

Please refer to the comments in the codes for example usage on 2D data
"FERETC70A15S8_80x80" in the directory "FERETC70A15S8", which is used in the 
paper above. Various partitions used in the paper are included in the directory 
"FERETC70A15S8" for L=1 to 7.

Directory "USFGait17_32x22x10" contains the gait data used in the paper above.
---------------------------


%[Toolbox needed]%:

This code needs the tensor toolbox available at 
http://csmr.ca.sandia.gov/~tgkolda/TensorToolbox/
This package includes tensor toolbox version 2.1 for convenience.
---------------------------


%[Restriction]%

In all documents and papers reporting research work that uses the matlab codes 
provided here, the respective author(s) must reference the following paper: 

[1]	Haiping Lu, K.N. Plataniotis, and A.N. Venetsanopoulos, 
	"Uncorrelated Multilinear Principal Component Analysis for Unsupervised
        Multilinear Subspace Learning",
	IEEE Transactions on Neural Networks, 
	Vol. 20, No. 11, pp. 1820-1836, Nov. 2009.	
---------------------------


%[Additional Resources]%

The BibTeX file "MPCApublications.bib" contains the BibTex for UMPCA and 
related works. The included survey paper "SurveyMSL_PR2011.pdf" discusses the 
relations between UMPCA and related works.
---------------------------


%[Comment/Question?]%

Please send your comment (e.g., ways to improve the codes) or question (e.g., 
difficulty in using the codes) to hplu@ieee.org or eehplu@gmail.com
---------------------------


%[Update history]%

1. February 28, 2012: Version 1.0 is released.