close all

Fset = 1:20;
k = randi(20);
kstart = k;
S = 0.25;

randset = S * randn(250,1);
randset(find(randset > 0)) = floor(randset(find(randset > 0))+1);
randset(find(randset < 0)) = ceil(randset(find(randset < 0))-1);



for i = 1:length(randset)
    dummy = k + randset(i);
    sel(i) =  mod(dummy,length(Fset));
%     if dummy > 20
%         sel(i) = 1;
%     elseif dummy < 1
%         sel(i) = 20;
%     end
    

    k = sel(i);
end
plot(sel)
figure
hist(sel,20)
    


% % set1 = zeros(1,20);
% % set1(2) = 1;
% % 
% % dummy = 0;
% % for i = 1:100;
% %     dummy = dummy + set1(randi(20));
% % end
% close all
% Fset = 1:20;
% w = ones(1,20);
% sel = zeros(1,20);
% 
% for i = 1:100
%     PrSum = sum(w);
%     PrSel = rand*PrSum;
%     j = 1;
%     idx = 0;
%     
%     while j <= 20
%         idx = idx + w(j);
%         if (idx > PrSel)
%             idx = j;
%             j = 21;
%         else
%             j = j+1;
%         end
%         
%     end
%     sel(i) = Fset(idx); 
% end
% figure
% hist(sel,20);
% figure
% plot(sel);
% 
% Fset = 1:20;
% w = ones(1,20);
% sel = zeros(1,20);
% 
% for i = 1:100
%     PrSum = sum(w);
%     PrSel = rand*PrSum;
%     j = 1;
%     idx = 0;
%     
%     while j <= 20
%         idx = idx + w(j);
%         if (idx > PrSel)
%             idx = j;
%             w(j) = w(j)/2;
%             j = 21;
%         else
%             j = j+1;
%         end
%         
%     end
%     sel(i) = Fset(idx);
%     
%     if(mod(i,100) == 0)
%         w = w.*2^5;
%     end
% end
% figure
% hist(sel,20);
% figure
% plot(sel);