function [ifd,vt,p,minError] = createSatCurve(S1,S12)
% Copyright 2020 The MathWorks, Inc.


% Create points on ifd and vt axes
IA = 1;

ifd1 = S1*IA + IA;
ifd12 = 1.2*S12*IA + 1.2*IA;

vtS = [0 1 1.2];
vta = 0:0.01:1.6;

%% create polynomial fit

% The quadratic curve has only two points to do the fit, and so we have insufficient
% information. The third point is where the curve has a derivative of 0 
% on the line with gradient 1 that goes through the origin.
% In this condition, the following applies
%
% (1-p(2))/2/p(1) = p(1)*((1-p(2))/2/p(1))^2 + p(2)*((1-p(2))/2/p(1)) + p(3)
%
% where the quadratic curve is
%
% y = p(1).*x^2 + p(2).*x + p(3)
%

% do a simple search to hit the right 3rd point 

init = linspace(1,10,500);

for l = 1:numel(init) % this is crude

p = polyfit(vtS,[init(l) ifd1 ifd12],2);
ifda = polyval(p,vta);

e1 = (1-p(2))/2/p(1);
e2 = p(1)*((1-p(2))/2/p(1))^2 + p(2)*((1-p(2))/2/p(1)) + p(3);

error(l) = abs(e1 - e2); %#ok<*NASGU>

end

minError = min(error); % if minError is > 1e-3 then the fit is 'bad'

init1 = init(find(error == minError)); %#ok<*FNDSB>

p = polyfit(vtS,[init1 ifd1 ifd12],2);
ifda = polyval(p,vta);

idx = vta > (1-p(2))/2/p(1);

ifd = [0 ifda(idx)];
vt = [0 vta(idx)];

% 
% figure(1),hp = plot(ifd,vt,'b',ifda,vta,'k--',ifd,vt,'b',ifd1,1,'k+',ifd12,1.2,'k+',[(1-p(2))/2/p(1) 2],[(1-p(2))/2/p(1) 2],'k--',[ifd1 ifd1],[0 1],'k--',[0 ifd1],[1 1],'k--',[ifd12 ifd12],[0 1.2],'k--',[0 ifd12],[1.2 1.2],'k--');grid on
% set(hp(1),'LineWidth',2);
% title('Generator Saturation Curve')
% xlabel('ifd'),ylabel('vt')
% drawnow

%% Plot results
% figure;
% hold all;


%figure(1),plot(ifd,vt,[0 2],[0 2],ifd1,1,'+',ifd12,1.2,'+')
% plot([0 1.6*IA],[0 1.6]);
% plot(ifd([idx1 idx12]),vt([idx1 idx12]),'+');
% plot([0 ifd(idx1)],[1 1],'k--');
% plot([0 ifd(idx12)],[1.2 1.2],'k--');
% plot([ifd(idx1) ifd(idx1)],[0 1],'k--');
% plot([ifd(idx12) ifd(idx12)],[0 1.2],'k--');
% plot([1 1],[0 1],'k--');
% plot([1.2 1.2],[0 1.2],'k--');
% 
% title(['S1.0 = ',num2str(S1),'       S1.2 = ',num2str(S12)])
% xlabel('ifd'),ylabel('vt')
end

