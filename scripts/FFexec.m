
mpb = MPB(3, 20, 0, 1, 0);
x = linspace(0,100,100);
y = x;


for i = 1:length(x)
    for j = 1:length(y)
        pos = [x(i) y(j)];
        fitness(i,j) = mpb.calc(pos);
    end
end

figure('units','normalized','outerposition',[0 0 1 1]);
surf(x,y,fitness);

for i = 1:length(x)
    for j = 1:length(y)
        pos = [x(i) y(j)];
        fitness2(i,j) = mpb.calcSum(pos);
    end
end

figure('units','normalized','outerposition',[0 0 1 1]);
surf(x,y,fitness2);

% 
% for j = 1:5
%     mpb.linearMove([15 25])
%     for i = 1:length(x)
%         for j = 1:length(y)
%             pos = [x(i) y(j)];
%             fitness(i,j) = mpb.calc(pos);
%         end
%     end
%     figure('units','normalized','outerposition',[0 0 1 1]);
%     contour(x,y,fitness,100);
%     
% end

% mpb.linearMove([35 5])
% for i = 1:length(x)
%     for j = 1:length(y)
%         pos = [x(i) y(j)];
%         fitness3(i,j) = mpb.calc(pos);
%     end
% end
% 
% mpb.linearMove([35 5])
% for i = 1:length(x)
%     for j = 1:length(y)
%         pos = [x(i) y(j)];
%         fitness4(i,j) = mpb.calc(pos);
%     end
% end







% offsetOrigin = [50,50];
% newOffset = [50,0];
% close all
% for i = 1:length(x)
%     for j = 1:length(y)
%         pos = [x(i) y(j)];
%         fitness(i,j) = mpb.calc(pos);
%     end
% end
%  
% for i = 1:length(x)
%     for j = 1:length(y)
%         pos = [x(i) y(j)] - offsetOrigin;
%         pos = rotateTranslate(pos,pi/4,offsetOrigin,newOffset);
%         fitness2(i,j) = mpb.calc(pos);
%     end
% end
% 
% for i = 1:length(x)
%     for j = 1:length(y)
%         pos = [x(i) y(j)]- offsetOrigin;
%         pos = rotateTranslate(pos,pi/2,offsetOrigin,newOffset);
%         fitness3(i,j) = mpb.calc(pos);
%     end
% end
% 
% 
% for i = 1:length(x)
%     for j = 1:length(y)
%         pos = [x(i) y(j)]- offsetOrigin;
%         pos = rotateTranslate(pos,3*pi/4,offsetOrigin,newOffset);
%         fitness4(i,j) = mpb.calc(pos);
%     end
% end
% 
% for i = 1:length(x)
%     for j = 1:length(y)
%         pos = [x(i) y(j)]- offset;
%         pos = rotateTranslate(pos,0.8,offset);
%         fitness5(i,j) = mpb.calc(pos);
%     end
% end
% for i = 1:length(x)
%     for j = 1:length(y)
%         pos = [x(i) y(j)]- offset;
%         pos = rotateTranslate(pos,1.6,offset);
%         fitness6(i,j) = mpb.calc(pos);
%     end
% end
% for i = 1:length(x)
%     for j = 1:length(y)
%         pos = [x(i) y(j)]- offset;
%         pos = rotateTranslate(pos,0.6,offset);
%         fitness7(i,j) = mpb.calc(pos);
%     end
% end

% figure;
% surf(x,y,fitness);
% figure;
% surf(x,y,fitness2);
% figure;
% surf(x,y,fitness3);
% figure;
% surf(x,y,fitness4);
% close all
% figure('units','normalized','outerposition',[0 0 1 1]);
% contour(x,y,fitness,100);
% figure('units','normalized','outerposition',[0 0 1 1]);
% contour(x,y,fitness2,100);
% figure('units','normalized','outerposition',[0 0 1 1]);
% contour(x,y,fitness3,100);
% figure('units','normalized','outerposition',[0 0 1 1]);
% contour(x,y,fitness4,100);
% figure('units','normalized','outerposition',[0 0 1 1]);
% contour(x,y,fitness5,100);
% figure('units','normalized','outerposition',[0 0 1 1]);
% contour(x,y,fitness6,100);
% figure('units','normalized','outerposition',[0 0 1 1]);
% contour(x,y,fitness7,100);
