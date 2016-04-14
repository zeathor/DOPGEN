close all
folderName = 'C:\PhD\Eclipse_Workspace\Latex\DSSC-Thesis\Images\Temporary\';
set(0,'DefaultAxesXGrid','on','DefaultAxesYGrid','on', 'DefaultAxesLineWidth',2);
% set(0,'DefaultAxesBox','on');
set(0,'defaultlinelinewidth',2);

%% DOP GRAPHING - DS
% DOP = DS(2,100);
% DOP.setCS([0,0]);
% [x,y,fitness] = DOP.graphDOP();
% surfcMoreLines(x,y,reshape(fitness,100,100),30); box off
% set(gca,'zlim',[0,70]); view(-16,30);
% set(gca,'xtick',-5:2:5); set(gca,'ytick',-5:2:5);
% saveFigure('DPGN-SphereM0');
% 
% yoff = 5*sin(3* (1:100));
% 
% DOP.setCS([yoff(1),yoff(1)]);
% [x,y,fitness] = DOP.graphDOP();
% surfcMoreLines(x,y,reshape(fitness,100,100),30); box off
% set(gca,'zlim',[0,70]); view(-16,30);
% set(gca,'xtick',-5:2:5); set(gca,'ytick',-5:2:5);
% saveFigure('DPGN-SphereM1')
% 
% DOP.setCS([yoff(2),yoff(2)]);
% [x,y,fitness] = DOP.graphDOP();
% surfcMoreLines(x,y,reshape(fitness,100,100),30); box off
% set(gca,'zlim',[0,70]); view(-16,30);
% set(gca,'xtick',-5:2:5); set(gca,'ytick',-5:2:5);
% saveFigure('DPGN-SphereM2')
% 
% DOP.setCS([yoff(3),-yoff(3)]);
% [x,y,fitness] = DOP.graphDOP();
% surfcMoreLines(x,y,reshape(fitness,100,100),30); box off
% set(gca,'zlim',[0,70]); view(-16,30);
% set(gca,'xtick',-5:2:5); set(gca,'ytick',-5:2:5);
% saveFigure('DPGN-SphereM3')

%% CDF plots for FEPC
% dirName = 'C:\PhD\Eclipse_Workspace\Latex\DSSC-Thesis\Progress\Results\SampleSize\CGFS-RSRG1_S-FEPC_S-';
% pSize = [50,100,200,500,1000,2000,5000,1e4,2e4,5e4,1e5];
% sampTech = {'URS','EDS','JGS','RSHS'};
% 
% for i = 1:length(pSize)
%     for j = 1:numel(sampTech)   
%         fileName = [dirName sampTech{j} '-' num2str(pSize(i)) '.mat'];
%         if(exist(fileName,'file'))
%             StatsPlottingSampling(fileName,[sampTech{j} '-' num2str(pSize(i))])
%         end
%     end
% end

%% Logistics function plotting
% A = linspace(1,4,1000);
%
% Y = ones(size(A))*0.35;
% for i = 1:1000
%    Y = A.*Y.*(1-Y);
% end
%
% plotPoints = zeros(50,length(A));
% for i = 1:50
%    Y = A.*Y.*(1-Y);
%    plotPoints(i,:) = Y;
% end
%
% plotPointsA = plotPoints';
% plotPointsA = plotPointsA(:);
% plotPointsA = plotPointsA';
% APlotPoints = repmat(A,1,50);
% scatter(APlotPoints,plotPointsA,'.');

%% Random shuffled Halton Sequence plotting
% rPos = RSHS(2,0,200,100);
% uPos = URS(2,0,200,100);
%
% figure
% scatter(uPos(:,1),uPos(:,2),100,'fill');
% figure
% scatter(rPos(:,1),rPos(:,2),100,'fill');

%% Circular GOM plotting, just for checking
% DOP = MPB();
% figure; hold on
% xlim([0,100]); ylim([0,100]);
% DOP.reset();
% for i = 1:250
%     DOP.circularGOM([0 5]);
%     optPos =DOP.C(DOP.sidx,:);
%     scatter(optPos(1),optPos(2),'g');
% end
% DOP.reset();
% for i = 1:30
%     DOP.circularGOM([0 10]);
%     optPos =DOP.C(DOP.sidx,:);
%     scatter(optPos(1),optPos(2),'b');
% end

%% Spectrogram plotting routines
% % probSet = {'CGF'};%,'DF1','DF1','MPB'}
% % probSet = {'MPB'}%,'MPB'};%,'MPB'};
% % probSet = {'CF4','DF1','CGF'};
% probSet = {'DF1'};
% % probSet = {'cell','cell','cell','cell','cell','cell','cell','cell','cell','cell','cell','cell'};
% % probSet = {'cell','cell','cell','cell','cell','cell','cell','cell'};
% % probSet = {'CGF'};
% % probSet = {'MPB'};
%
% % dynSet = {'SCG'};
% % dynSet = {'RCDFix'}%,'RCDF'};%,'RCDFix'};
% % dynSet = {'SCL','SCR','SCG'};
% % dynSet = {'FP1','FP2','RSR1','RSR2','RSRG1','RSRG2','RSQR1','RSQR2','RSS1','RSS2','RSG1','RSG2'};
% % dynSet = {'RSRG1','RSRG2','RSQR1','RSQR2','RSS1','RSS2','RSG1','RSG2'};
% dynSet = {'SCR'};
% % dynSet = {'RCDFix'};
%
% % rangeSet = {1:2:25};
% % rangeSet = {1:16,1:16,1:16};
% % [dynSettings] = setDynamicArrays(dynSet{:});
% rangeSet = {[1,5:5:25],[1,5:5:25],[1,5:5:25]};
% plotSpectAll(probSet, dynSet, rangeSet)
% % plotSpectAll(probSet, dynSet, {dynSettings.dynRange})

%% Frequency Domain analysis pictures
% t = 0:300; t1 = 0:100; t2 = 100:200; t3 = 200:300;
% y1 = sin(pi*t1/5);
% y2 = sin(pi*t1/1.5) + sin(pi*t1/4);
% y3 = sin(pi*t1/20) + sin(pi*t1/2) + sin(pi*t1/1.2);
% yAll = [y1(2:end) y2(2:end) y3(2:end)];
%
%
% figure('units','normalized','outerposition',[0 0 1 1]); hold on;
% plot(t1,y1,'b','linewidth',3);
% plot(t2,y2,'r','linewidth',3);
% plot(t3,y3,'g','linewidth',3);
% set(gca,'linewidth',2); box on;
% plot([100 100],[-2.5 2.5],'k','linewidth',2);
% plot([200 200],[-2.5 2.5],'k','linewidth',2);
% ylabel('Sample Fitness S(x,$\Delta_n$)','FontSize',24,'FontWeight','bold');
% xlabel('Environmental Change Index $\Delta_n$','FontSize',24,'FontWeight','bold');
% fileName = [folderName,'DPGN-Freq-Time'];export_fig(fileName,'-eps','-transparent');
% saveas(gcf,fileName,'fig');
%
% figure('units','normalized','outerposition',[0 0 1 1]); hold on;
% [fAll, pAll] = channelSpectrum(yAll);
% plot(fAll,pAll/max(pAll),'b','linewidth',3);
% set(gca,'linewidth',2); box on;
% ylabel('Magnitude','FontSize',24,'FontWeight','bold');
% xlabel('Frequency','FontSize',24,'FontWeight','bold');
% fileName = [folderName,'DPGN-Freq-FFT'];export_fig(fileName,'-eps','-transparent');
% saveas(gcf,fileName,'fig');
%
% figure('units','normalized','outerposition',[0 0 1 1]); hold on;
% [f1, p1] = channelSpectrum(y1,100);
% [f2, p2] = channelSpectrum(y2,100);
% [f3, p3] = channelSpectrum(y3,100);
% plot(f1,p1/max(p1),'b','linewidth',3);
% plot(f2+0.5,p2/max(p2),'r','linewidth',3);
% plot(f3+1,p3/max(p3),'g','linewidth',3);
% set(gca,'linewidth',2); box on;
% plot([0.5 0.5],[0 1],'k','linewidth',2);
% plot([1 1],[0 1],'k','linewidth',2);
% set(gca,'xtick',0.0001:0.1:1.5)
% set(gca,'xticklabel',{'0','0.1','0.2','0.3','0.4'})
% ylabel('Magnitude','FontSize',24,'FontWeight','bold');
% xlabel('Frequency','FontSize',24,'FontWeight','bold');
% fileName = [folderName,'DPGN-Freq-Freq'];export_fig(fileName,'-eps','-transparent');
% saveas(gcf,fileName,'fig');
%
% figure('units','normalized','outerposition',[0 0 1 1]); hold on;
% fs = 50; epoch = 2; eL = epoch*fs; window = hamming(eL);
% [~, ~, ~, p1] = spectrogram(y1,window,25,[],50);
% [~, ~, ~, p2] = spectrogram(y2,window,25,[],50);
% [~, f, t, p3] = spectrogram(y3,window,25,[],50);
% f = f/50;
% p1 = 10*log10(abs([p1 p1])); p2 = 10*log10(abs([p2 p2])); p3 = 10*log10(abs([p3 p3]));
% p1(p1 < -60) = -60; p2(p2 < -60) = -60; p3(p3 < -60) = -60;
% surf([0 100], f, p1, 'EdgeColor','none');
% surf([100 200], f, p2, 'EdgeColor','none');
% surf([200 300], f, p3, 'EdgeColor','none');
% axis xy;
% set(gca,'linewidth',2); box on;
% set(gca,'xtick',0:20:300)
%
% plot([0.5 0.5],[0 0.5],'k','linewidth',2);
% plot([1 1],[0 0.5],'k','linewidth',2);
% ylabel('Frequency','FontSize',24,'FontWeight','bold');
% xlabel('Environmental Change Index $\Delta_n$','FontSize',24,'FontWeight','bold');
% fileName = strcat(folderName, 'DPGN-Freq-Spec'); export_fig(fileName,'-eps','-transparent');
% saveas(gcf,fileName,'fig');

%% GE pictures
% dirName = 'C:\PhD\Eclipse_Workspace\Latex\DSSC-Thesis\Progress\Results\TimeSeries\'
%
% figure('units','normalized','outerposition',[0 0 1 1]);
% hold on
% cmap = paruly(25);
% for i = 1:2:25
%     output = load([dirName 'GE-CGF-SCG-' num2str(i) '-SF.mat']);
%     plot(movingmean(output.data.E_W,21),'color',cmap(i,:));
%     clear output
% end
% title('CGF benchmark, Step Change Gradual');
% ylim([0,1]);
% saveas(gcf,strcat(dirName,'GE-CGF-SCG'),'png');
%
% figure('units','normalized','outerposition',[0 0 1 1]);
% hold on
% title('DF1 benchmark, Step Change Random');
% for i = 1:2:25
%     output = load([dirName 'GE-DF1-SCR-' num2str(i) '-SF.mat']);
%     plot(movingmean(output.data.E_W,21),'color',cmap(i,:));
%     clear output
% end
% ylim([0,1]);
% saveas(gcf,strcat(dirName,'GE-DF1-SCR'),'png');
%
% figure('units','normalized','outerposition',[0 0 1 1]);
% hold on
% title('DF1 benchmark, Translational Change');
% for i = 1:25
%     output = load([dirName 'GE-DF1-TCD-' num2str(i) '-SF.mat']);
%     plot(movingmean(output.data.E_W,21),'color',cmap(i,:));
%     clear output
% end
% ylim([0,1]);
% saveas(gcf,strcat(dirName,'GE-DF1-TCD'),'png');
%
%
% figure('units','normalized','outerposition',[0 0 1 1]);
% hold on
% title('DF1 benchmark, Translational/rotational Change');
% for i = [1 5 10 15 20 25]
%     output = load([dirName 'GE-DF1-TRCD-' num2str(i) '-SF.mat']);
%     plot(movingmean(output.data.E_W,21),'color',cmap(i,:));
%     clear output
% end
% ylim([0,1]);
% saveas(gcf,strcat(dirName,'GE-DF1-TRCD'),'png');
%
%
% figure('units','normalized','outerposition',[0 0 1 1]);
% hold on
% cmap = paruly(16);
% title('DF1 benchmark, Rotational Change');
% for i = [1:14 16]
%     output = load([dirName 'GE-DF1-RCD-' num2str(i) '-SF.mat']);
%     plot(movingmean(output.data.E_W,21),'color',cmap(i,:));
%     clear output
% end
% ylim([0,1]);
% saveas(gcf,strcat(dirName,'GE-DF1-RCD'),'png');

%% Rotational Fuzzy Movement plotting;
% pos = [50,100];
% DOP = MPB();
% posRec = zeros(250,2,16);
% S = pi/16:pi/16:pi;
% for s = 1:length(S)
%    pos = [50,100];
%    for i = 1:250;
%        [ pos, ~] = RCDF(DOP, pos, S(s), [], i, 2);
%        posRec(i,:,s) = pos;
%    end
% end
%  hold on
% cmap = paruly(16);
% for s = 1:length(S)
%     figure;
%     plot3(posRec(:,1,s),posRec(:,2,s),1:2:500,'-o','color',cmap(s,:))
% end

%% Rotational Movement hypersphere
% dirName = 'C:\PhD\Eclipse_Workspace\Latex\DSSC-Thesis\Images\Temporary\';
% saveName = [dirName 'DPGN-MPB-Rot-Hyper'];
% DOP = MPB(5,1,19,40,60,2,10000);
%
% x = linspace(-20.5,120.5,100);
% y = x;
%
% fitPos = zeros(100*100,2);
%
% for i = 1:length(x)
%     for j = 1:length(y);
%         fitPos(j+(i-1)*length(x),:) = [x(i) y(j)];
%     end
% end
%
% fitness = DOP.calc(fitPos);
% fitness = reshape(fitness,100,100);
%
% iDom = [-1 -1; 1 -1; 1 1; -1 1; -1 -1];
% pos = rand(100,2)*2-1;
%
% theta = pi/16; RotMat = [cos(theta) -sin(theta); sin(theta) cos(theta)];
% pos1 = (pos* RotMat + 1) *50; iDom1 = (iDom* RotMat + 1) * 50;
% theta = pi/8; RotMat = [cos(theta) -sin(theta); sin(theta) cos(theta)];
% pos2 = (pos* RotMat + 1) * 50; iDom2 = (iDom* RotMat + 1) * 50;
% theta = 3*pi/16; RotMat = [cos(theta) -sin(theta); sin(theta) cos(theta)];
% pos3 = (pos* RotMat + 1) * 50; iDom3 = (iDom* RotMat + 1) * 50;
% theta = pi/4; RotMat = [cos(theta) -sin(theta); sin(theta) cos(theta)];
% pos4 = (pos* RotMat + 1) * 50; iDom4 = (iDom* RotMat + 1) * 50;
% pos = (pos + 1) * 50; iDom = (iDom+1)*50;
%
% figure('units','normalized','outerposition',[0 0 1 1]);
% contour(x,y,fitness,40,'linewidth',3);
% hold on
% scatter(pos(:,1),pos(:,2),'fill');
% plot(iDom(:,1),iDom(:,2),'k','linewidth',3);
% axis equal;
% xlim([-20.5,120.5]);
% export_fig(strcat(saveName,'0'),'-eps','-transparent');
% saveas(gcf,strcat(saveName,'0'),'fig');
%
% figure('units','normalized','outerposition',[0 0 1 1]);
% contour(x,y,fitness,40,'linewidth',3);
% hold on
% scatter(pos1(:,1),pos1(:,2),'fill');
% plot(iDom1(:,1),iDom1(:,2),'r','linewidth',2);
% plot(iDom(:,1),iDom(:,2),'k','linewidth',3);
% viscircles([50 50],50,'edgecolor','b','linewidth',3');
% axis equal;
% xlim([-20.5,120.5]);
% export_fig(strcat(saveName,'1'),'-eps','-transparent');
% saveas(gcf,strcat(saveName,'1'),'fig');
%
% figure('units','normalized','outerposition',[0 0 1 1]);
% contour(x,y,fitness,40,'linewidth',3);
% hold on
% scatter(pos2(:,1),pos2(:,2),'fill');
% plot(iDom2(:,1),iDom2(:,2),'r','linewidth',2);
% plot(iDom(:,1),iDom(:,2),'k','linewidth',3);
% viscircles([50 50],50,'edgecolor','b','linewidth',3');
% axis equal;
% xlim([-20.5,120.5]);
% export_fig(strcat(saveName,'2'),'-eps','-transparent');
% saveas(gcf,strcat(saveName,'2'),'fig');
%
% figure('units','normalized','outerposition',[0 0 1 1]);
% contour(x,y,fitness,40,'linewidth',3);
% hold on
% scatter(pos3(:,1),pos3(:,2),'fill');
% plot(iDom3(:,1),iDom3(:,2),'r','linewidth',2);
% plot(iDom(:,1),iDom(:,2),'k','linewidth',3);
% viscircles([50 50],50,'edgecolor','b','linewidth',3');
% axis equal;
% xlim([-20.5,120.5]);
% export_fig(strcat(saveName,'3'),'-eps','-transparent');
% saveas(gcf,strcat(saveName,'3'),'fig');
%
% figure('units','normalized','outerposition',[0 0 1 1]);
% contour(x,y,fitness,40,'linewidth',3);
% hold on
% scatter(pos4(:,1),pos4(:,2),'fill');
% plot(iDom4(:,1),iDom4(:,2),'r','linewidth',2);
% plot(iDom(:,1),iDom(:,2),'k','linewidth',3);
% viscircles([50 50],50,'edgecolor','b','linewidth',3');
% axis equal;
% xlim([-20.5,120.5]);
% export_fig(strcat(saveName,'4'),'-eps','-transparent');
% saveas(gcf,strcat(saveName,'4'),'fig');

%% Rotational Movement capture
% DOP = MPB(3, 30, 40, 1, 11, 2, 100*100);
% x = linspace(DOP.domain(1),DOP.domain(2),100);
% y = x;
% for i = 1:length(x)
%     for j = 1:length(y)
%         pos((i-1)*length(x)+j,:) = [x(i) y(j)];
%     end
% end
%
% hold on
%
% fitness1 = DOP.calc(pos);
% contour(x,y,reshape(fitness1,100,100)',40,'linewidth',2);
% scatter(DOP.C(:,2), DOP.C(:,1),40,'fill','b');
%
% [ pos2, ~] = RCD(DOP, pos, pi/3, 2,1, 1);
% fitness2 = DOP.calc(pos2);
% figure
% hold on
% contour(x,y,reshape(fitness2,100,100)',40,'linewidth',2);
% theta = -pi/3;
% rotMat = [cos(theta) -sin(theta); sin(theta) cos(theta)];
% CMod = (DOP.C - 50)*rotMat+50;
%
% scatter(CMod(:,2),CMod(:,1) ,40,'fill','b');
%
% [ pos3, ~] = RCD(DOP, pos, 2*pi/3, 2,1, 1);
% fitness3 = DOP.calc(pos3);
% figure
% hold on
% contour(x,y,reshape(fitness3,100,100)',40,'linewidth',2);
% theta = -2*pi/3;
% rotMat = [cos(theta) -sin(theta); sin(theta) cos(theta)];
% CMod = (DOP.C - 50)*rotMat+50;
%
% scatter(CMod(:,2),CMod(:,1) ,40,'fill','b');
%
% [ pos4, ~] = RCD(DOP, pos, pi, 2,1, 1);
% fitness4 = DOP.calc(pos4);
% figure
% hold on
% contour(x,y,reshape(fitness4,100,100)',40,'linewidth',2);
% theta = -pi;
% rotMat = [cos(theta) -sin(theta); sin(theta) cos(theta)];
% CMod = (DOP.C - 50)*rotMat+50;
%
% scatter(CMod(:,2),CMod(:,1) ,40,'fill','b');

%% Random Peak Movement
% T = 1:19;
%
% delta = randn(length(T)*2,3);
%
% pos = [0 0 0; cumsum(delta)];
%
% plot3(pos(:,1), pos(:,2),pos(:,3),'-<','linewidth',3);
% grid
% hold on
% zlim([-10 10]); xlim([-10 10]); ylim([-10 10]);
%
% plot3([-10 10], [0 0], [0 0],'k', 'linewidth',3);
% plot3([0 0], [-10 10], [0 0],'k', 'linewidth',3);
% plot3([0 0], [0 0], [-10 10],'k', 'linewidth',3);
%
% plot3(pos(:,1), pos(:,2), ones(1,length(pos))*-10,'-<','linewidth',2,'color', [0.7 0.7 0.7]);

%% Translational movement capture
% DOP = DF1(5, 20, 0, 8, 12, 2, 100*100);
% x = linspace(DOP.domain(1),DOP.domain(2),100);
% y = x;
% for i = 1:length(x)
%     for j = 1:length(y)
%         pos((i-1)*length(x)+j,:) = [x(i) y(j)];
%     end
% end
%
% hold on
%
% fitness1 = DOP.calc(pos);
% contour(x,y,reshape(fitness1,100,100)',40,'linewidth',2);
% scatter(DOP.C(:,2), DOP.C(:,1),40,'fill','b');
%
% [ pos2, ~] = TCD(DOP, pos, [0 -25], 2,1, 1);
% fitness2 = DOP.calc(pos2);
% figure
% hold on
% contour(x,y,reshape(fitness2,100,100)',40,'linewidth',2);
% scatter(DOP.C(:,2)+(25/100)*(DOP.domain(2)-DOP.domain(1)),DOP.C(:,1) ,40,'fill','b');
%
% [ pos3, ~] = TCD(DOP, pos, [+25 0], 2,1, 1);
% fitness3 = DOP.calc(pos3);
% figure
% hold on
% contour(x,y,reshape(fitness3,100,100)',40,'linewidth',2);
% scatter(DOP.C(:,2),DOP.C(:,1)-(25/100)*(DOP.domain(2)-DOP.domain(1)), 40,'fill','b');
%
% [ pos4, ~] = TCD(DOP, pos, [+25 -25], 2,1, 1);
% fitness4 = DOP.calc(pos4);
% figure
% hold on
% contour(x,y,reshape(fitness4,100,100)',40,'linewidth',2);
% scatter(DOP.C(:,2)+(25/100)*(DOP.domain(2)-DOP.domain(1)), DOP.C(:,1)-(25/100)*(DOP.domain(2)-DOP.domain(1)),40,'fill','b');

%% Spatial Temporal comparisons
% x = -5:0.05:5;
% f1 = 3*sin(2*x);
% f2 = -3*sin(2*x);
% f3 = -3*sin(2.01*x);
% f4 = sin(2*x);
% figure;
% hold on
% tempX = x(1:5:length(x));
%
% for i = 1:4
% h = plot3(patchVertex(:,1),ones(length(patchVertex),1)*i,patchVertex(:,2),'k','LineWidth',5);
% end
%
% idx = length(x) - 20;
% h1 = plot3(x, ones(1,length(x)), f1,'r','linewidth',5);
% h1 = plot3(x, ones(1,length(x)), f1,'b','linewidth',2);
% scatter3(tempX,ones(1,length(tempX)), f1(1:5:length(x)),'fill','b','sizedata',100);
%
% h2 = plot3(x, ones(1,length(x))*2, f2,'linewidth',2);
% scatter3(tempX,ones(1,length(tempX))*2, f2(1:5:length(x)),'fill','b','sizedata',100);
%
% h3 = plot3(x, ones(1,length(x))*3, f3,'linewidth',2);
% scatter3(tempX,ones(1,length(tempX))*3, f3(1:5:length(x)),'fill','b','sizedata',100);
%
% h4 = plot3(x, ones(1,length(x))*4, f4,'linewidth',2);
% scatter3(tempX,ones(1,length(tempX))*4, f4(1:5:length(x)),'fill','b','sizedata',100);
%
% patchVertex = [-5 5; 5 5; 5 -5; -5 -5; -5 5];
%
% plot3( repmat(x(idx),4,1), 1:4, [f1(idx) f2(idx) f3(idx) f4(idx)],'r', 'linewidth',5);
% scatter3(repmat(x(idx),4,1), 1:4, [f1(idx) f2(idx) f3(idx) f4(idx)],'r', 'fill','sizedata',300);
%
% grid
% set(gca, 'YTick', [1 2 3 4])
%
% xlabel('Input Solution $x$','Rotation',-37,'Fontsize',24);
% ylabel('Environmental Change Index $\Delta_n$','Rotation',5,'Fontsize',24);

% xlabel('Input Solution $x$','Rotation',-23,'Fontsize',24);
% ylabel('Environmental Change Index $\Delta_n$','Rotation',8,'Fontsize',24);
% zlabel('Solution Fitness $F(x)$');


% p2 = patch(patchVertex(:,1),ones(length(patchVertex),1)*2,patchVertex(:,2),'w');
% p3 = patch(patchVertex(:,1),ones(length(patchVertex),1)*3,patchVertex(:,2),'w');
% p4 = patch(patchVertex(:,1),ones(length(patchVertex),1)*4,patchVertex(:,2),'w');

%% Speed test, cf4 versus niching
% x=-5:0.1:5; y=x;
% global initial_flag
% initial_flag=0;
% func_num = 15;
%
% pos = [];
% for i = length(x):-1:1
%     for j = length(y):-1:1
%         pos((i-1)*length(x)+(j),:) = [x(i) y(j)];
%     end
% end
%
% cf4 = CF4(0,100,2, length(pos));
% L = length(x);
% f1 = zeros(L);
% tic
% for i=1:L
% 	for j=1:L
% 		f1(i,j) = niching_func([x(i),y(j)],func_num);
% 	end
% end
% toc
% f2 = zeros(L);
% tic
% for i=1:L
% 	for j=1:L
% 		f2(i,j) = cf4.calc([x(i),y(j)]);
% 	end
% end
% tic
% f3 = cf4.calc(pos);
% toc
%
% surf(x,y,reshape(f3,101,101),'FaceColor','interp','FaceLighting','phong','EdgeColor','none');
% hold on
% scatter3(cf4.O(:,1), cf4.O(:,2), ones(8,1)*100,'fill');

%% Speed test, basic functions
% x = linspace(-5,5,100);
% y = x;
% pos= [];
% for i = length(x):-1:1
%     for j = length(y):-1:1
%         pos((i-1)*length(x)+(j),:) = [x(i) y(j)];
%     end
% end
%
% tic
% for i = 1:1000;
%     fit1 = FEF8F2Old(pos);
% end
% toc
%
% tic
% for i = 1:1000;
%     fit2 = FEF8F2New(pos);
% end
% toc

%% EDS-URS Sinewave sampling
% x = -1:0.01:1;
% y = x;
% posCont = zeros(length(x));
% for i = 1:length(x)
%     for j = 1:length(y)
%         posCont(i,j) = twoDSineWave([x(i) y(j)]);
%     end
% end
%
% posEDS = EDS(2,-1,1,100);
% posURS = URS(2,-1,1,100);
% figure
% hold on
% contour(x,x,posCont,20,'linewidth',2);
% scatter(posEDS(:,1),posEDS(:,2),100,'fill','facecolor','r');
%
% figure
% hold on
% contour(x,x,posCont,20,'linewidth',2);
% scatter(posURS(:,1),posURS(:,2),100,'fill','facecolor','r');
%
%
% fitEDS = twoDSineWave(posEDS);
% fitURS = twoDSineWave(posURS);
% figure
% boxplot([fitEDS fitURS])

%% URS - CDF
% x10 = rand(10,1);
% x100 = rand(100,1);
% x1000 = rand(1000,1);
% x10000 = rand(10000,1);
% xEquit = 0:0.00001:1;
%
% figure
% hold on;
% c = cool(8)
% hx10 = cdfplot(x10);
% set(hx10,'color',c(1,:),'linewidth',3);
% hx100 = cdfplot(x100);
% set(hx100,'color',c(2,:),'linewidth',3);
% hx1000 = cdfplot(x1000);
% set(hx1000,'color',c(3,:),'linewidth',3);
% hx10000 = cdfplot(x10000);
% set(hx10000,'color',c(4,:),'linewidth',3);
% hEq = cdfplot(xEquit);
% set(hEq,'color','r','linewidth',2,'linestyle','--');

%% Uniform random sampling density
% load('C:\PhD\Eclipse_Workspace\Latex\DSSC-Thesis\Progress\Results\UniformDist');
% valMax = 100;
% pos = rand(10000,2)*valMax;
% scatter(pos(:,1),pos(:,2),10,'k','fill')
% qSize = 10;
% figure
% hold on
% qVals = zeros(qSize);
% xmin = 0:valMax/qSize:valMax-valMax/qSize;
% xmax = valMax/qSize:valMax/qSize:valMax;
% ymin = xmin;
% ymax = xmax;
%
% for i = 1:length(xmin)
%     for j = 1:length(ymin)
%        qVals(i,j) = sum(pos(:,1)>xmin(i) & pos(:,1)<(xmax(i)) & pos(:,2)>ymin(j) & pos(:,2)<ymax(j));
%     end
% end
% c = hsv(max(max(qVals)));
% colormap('hot');
%
% centres = valMax/qSize/2:valMax/qSize:valMax-valMax/qSize/2;
% h = imagesc(centres,centres,qVals,[1 max(max(qVals))]);
% % set(h, 'AlphaData',0.5);
% b = colorbar;
% scatter(pos(:,1),pos(:,2),10,'k','fill')

%% Random Selection Quasi Random
% W = ones(1,20);
% for i = 1:250
%     newIdx = rand*sum(W);
%
%     dummyIdx = 1;
%     dummy = 0;
%     while(dummyIdx <= 20)
%         dummy = dummy + W(dummyIdx);
%         if(dummy > newIdx)
%             W(dummyIdx) = W(dummyIdx)/2;
%             break
%         else
%             dummyIdx = dummyIdx + 1;
%         end
%     end
%     new(i) = dummyIdx;
%
%     if(mod(i,20*5) == 0)
%         W = W.*(2^5);
%     end
%
% end
% hist(new,20)
% grid

%% Random selection Gaussian
% M = 25;
% DOPidx = 15;
% Sg = 1:0.5:5.5;
% for j = 1:length(Sg)
%     for i = 1:250
%         newIdx = randn*Sg(j);
%
%         if newIdx > 0
%             new(i,j) = mod(floor(newIdx) + 1 + DOPidx,M+1);
%         else
%             new(i,j) = mod(ceil(newIdx) - 1 + DOPidx,M+1);
%         end
%         DOPidx = new(i,j);
%     end
% end
% DOPidx = newIdx;
%
% plot(new(:,1), 'linewidth',2);
% grid

%% Circular Global Optimum Movement
% DOP = df1(20,30,70,8,20,2,100);
% DOP = DF1(20, 1, 19, 8, 12, 2, 100);
%
% x = linspace(-1,1,100);
% y = x;
% for i = 1:length(x)
%     for j = 1:length(y)
%         fit1(i,j) = DOP.calc([x(i) y(j)]);
%     end
% end
% hold on
% contour(x,y,fit1);
% scatter(DOP.C(DOP.sidx,2), DOP.C(DOP.sidx,1), 'linewidth', 5);
% for i = 1:250
%     RGOM(DOP, x, 1, [], []);
%     scatter(DOP.C(DOP.sidx,2), DOP.C(DOP.sidx,1), 'linewidth', 5);
% end
%
% for k = 1:1:10
% DOP.reset;
% figure
% hold on
% for i = 1:250
%     RGOM(DOP, x, k, [], []);
%     scatter(DOP.C(DOP.sidx,2), DOP.C(DOP.sidx,1),'b', 'linewidth', 5);
% end
% end

%% DOP speed testing
% fit = zeros(1,1000000);
% tic
% for i = 1:1000000
%     fit(i) = griewankTest([0 0 0 0 0]);
% end
% toc

%% Repmat testing
% nChains = 100;
% x = 1:5;
% tic
% for j = 1:100000
%     idx = (1:size(x,1))';
%     temp1 = x(idx(:, ones(nChains, 1)), :);
% end
% toc
%
% tic
% for j = 1:100000
%     temp4 = x(ones(1,nChains),:);
% end
% toc
%
% tic
% for j = 1:100000
%     temp2 = x((1:size(x,1))' * ones(1,nChains),:);
% end
% toc
%
% tic
% for j = 1:100000
% temp3 = repmat(x,nChains,1);
% end
% toc

%% DOP dynamic testing
% x = linspace(0,100,101);
% y = linspace(0,100,101);
% DOP = MPB(5, 30, 40, 1, 11);
% domain = [0,100];
% fitness = zeros(1,101*101);
% XY = zeros(101*101,2);
% for i = 1:length(x)
%     for j = 1:length(y)
%         pos = [x(i) y(j)];
%         fitness(1,(101*(i-1)+j)) = DOP.calc(pos);
%         XY((101*(i-1)+j),1) = x(i);
%         XY((101*(i-1)+j),2) = y(j);
%     end
% end
%
%
%
% plot3(XY(:,1),XY(:,2),fitness,'.');
%
% for i = 1:length(XY)
%     pos = [XY(i,1) XY(i,2)];
%     fitness(i) = DOP.calc(pos);
% end
%
%
%
% for l = 1:10
%     for k = (pi/8:pi/8:pi)
%
%         XY = RCD(DOP, XY, domain, k, 2);
%         for i = 1:length(XY)
%             pos = [XY(i,1) XY(i,2)];
%             fitness(i) = DOP.calc(pos);
%         end
%
%         figure
%         plot3(XY(:,1),XY(:,2),fitness,'.');
%         title(strcat('Dynamic Setting = ', num2str(k), ' iter = ', num2str(l)));
%     end
% end

%% DOP script testing
% pos = rand(1000,2)*(5 - -5) - (5--5)/2;
% domain = [-5,5];
% for i = 1:200
%     [ pos] = TranslationalChangeDynamic(1, pos, domain, 30, 2);
% end

%% DOP GRAPHING - DF1, CGF
% DOP = DF1(10, 3, 3, 2, 5, 2,101*101);
% DOP = CGF(10,10,90,[],[],2,101*101);
% x = linspace(-5,5,101);
% y = x;
% for i = 1:length(x)
%     for j = 1:length(y)
%         pos1(j+(i-1)*101,:) = [x(i) y(j)];
%     end
% end
% fitness = DOP.calc(pos1);
% for i = 1:length(x)
%     for j = 1:length(y)
%         fitSquare1(i,j) = fitness(j+(i-1)*101,1);
%     end
% end
% figure
% contour(x,y,fitSquare1,30);
% for k = 1:3
% pos2 = RCD(DOP, pos, k*pi/2, 2);
% fitness = DOP.calc(pos2);
% for i = 1:length(x)
%     for j = 1:length(y)
%         fitSquare2(i,j) = fitness(j+(i-1)*101,1);
%     end
% end
% figure
% contour(x,y,fitSquare2,30);
% end

%% CLUSTER TESTING
% tic
% for i = 1:250
% [C,~,~] = clusterData(optPos);
% end
% toc
%
% tic
% for i = 1:250
%     [C, ~, ~] = dbscan(optPos', 0.02, 1);
% end
% toc
%
% tic
% for i = 1:250
%    [C,~] = dbscan2(optPos, 0.02,1);
%    A = max(C);
% end
% toc
%
%
% tic
% for i = 1:250
%    A = max(dbscan2(optPos, 0.02,1));
% end
% toc

%% Error Bar graphing

% KParam = 1:100;
% Val = KParam*randn + KParam/50;
% theRange = KParam.*randn(1,100)/10;
% errorbar(KParam,Val, theRange, ':r');

%% Clustered Chains
% A1 = [randi(200) randi(200)];
% px = x(A1);
% py = y(A1);
%
% vx = linspace(px(1), px(2),10);
% vy = linspace(py(1), py(2),10);
%
% r = sqrt((px(2)-px(1))^2 + (py(2)-py(1))^2);
%
% vx1 = vx;
% vx1(2:9) = vx1(2:9)+randn(1,8)*r/10;
% vy1 = vy;
% vy1(2:9) = vy1(2:9)+randn(1,8)*r/20;
%
%
% figure;
% scatter(x,y);
%
% figure;
% hold on
% scatter(x,y);
% scatter(x(A1),y(A1),'LineWidth', 5,'MarkerEdgeColor', 'r')
%
% figure;
% hold on
% scatter(x,y);
% scatter(x(A1),y(A1),'LineWidth', 5,'MarkerEdgeColor', 'r')
%
% scatter(vx,vy,'+','LineWidth', 2,'MarkerEdgeColor', 'k')
% figure;
% hold on
% scatter(x,y);
% scatter(x(A1),y(A1),'LineWidth', 5,'MarkerEdgeColor', 'r')
% scatter(vx1,vy1,'+','LineWidth', 2,'MarkerEdgeColor', 'k')
% plot(vx1,vy1,'k')

%% SLHC position aggregation
% temp = ones(1,200);
%
%
%
% theMean = mean(temp);
%
% dummy = temp(1);
% for i = 2:length(temp)
%     dummy = (dummy + temp(i))/2;
% end
% dummy





