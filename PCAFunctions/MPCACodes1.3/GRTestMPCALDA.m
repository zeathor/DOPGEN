clc,clear all,close all;
[GaitDBDir,probes,numprobe]=testData;
disp(['Processing ',GaitDBDir]);

maxDim=600;
MPCADADim=200;%Dimension of MPCA features b4 LDA
Qval=97;%The Q value, percentage of energy kept
maxK=1;%Maximum number of iterations
strGRDB=[GaitDBDir(12:(end-1))];
%%%%%%%%%%Load gallery gait data
setname='Gal';
load([GaitDBDir,setname]);
Is=size(fea3D);numSpl=Is(4);

fea3D_Train = fea3D;gnd_Train = gnd;clear fea3D
%=================MPCALDA==========================
disp(['Training on gallery']);
[tUs, posIdx, TXmean, Wgt, LDAU] = MPCALDA(fea3D_Train,gnd_Train,MPCADADim,Qval,maxK);
if size(LDAU,2)<maxDim,maxDim=size(LDAU,2);end
testDims=21:maxDim;

newfea=ttm(tensor(fea3D_Train-repmat(TXmean,[ones(1,3), numSpl])),tUs,1:3);
clear fea3D_Train
newfea = reshape(newfea.data,size(newfea,1)*size(newfea,2)*size(newfea,3),numSpl)';
galfea = newfea(:,posIdx);
galfea=galfea*LDAU;
galgnd=gnd;

nDim=length(testDims);
AllSeqR1s=zeros(nDim,numprobe);%Rank 1 recognition rate based on matching gait sequences
AllSeqR5s=zeros(nDim,numprobe);%Rank 5 recognition rate based on matching gait sequences
for iprb=1:numprobe
    %%%%%%%%%%Load probe gait data
    setname=['Prb',probes(iprb)];
    disp(['Testing ',setname]);
    load([GaitDBDir,setname]);Is=size(fea3D);numSpl=Is(4);
    newfea=ttm(tensor(fea3D-repmat(TXmean,[ones(1,3), numSpl])),tUs,1:3);clear fea3D
    newfea = reshape(newfea.data,size(newfea,1)*size(newfea,2)*size(newfea,3),numSpl)';
    prbfea = newfea(:,posIdx);
    prbfea=prbfea*LDAU;
    prbgnd=gnd;    
    [SeqR1s,SeqR5s]=MADAll(galfea,galgnd,prbfea,prbgnd,testDims,Wgt);
    AllSeqR1s(:,iprb)=SeqR1s;  
    AllSeqR5s(:,iprb)=SeqR5s;      
end
MaxSeqR1=max(AllSeqR1s);
MaxSeqR5=max(AllSeqR5s);
disp('Rank 1 identification rate for Probe A to G')
disp(MaxSeqR1)
disp('Rank 5 identification rate for Probe A to G')
disp(MaxSeqR5)
disp(['Mean rank 1 identification rate=',num2str(mean(MaxSeqR1))])
disp(['Mean rank 5 identification rate=',num2str(mean(MaxSeqR5))])
