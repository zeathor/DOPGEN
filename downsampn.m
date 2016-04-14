function M=downsampn(M,bindims)
%DOWNSAMPN - simple tool for downsampling n-dimensional nonsparse arrays
%
%  M=downsampn(M,bindims)
%
%in:
%
% M: an array
% bindims: a vector of integer binning dimensions
%
%out:
%
% M: the downsized array
nn=length(bindims);
[sz{1:nn}]=size(M); %M is the original array
sz=[sz{:}];
newdims=sz./bindims;
args=num2cell([bindims;newdims]);
M=reshape(M,args{:});
for ii=1:nn
   M=mean(M,2*ii-1);
end
M=reshape(M,newdims);