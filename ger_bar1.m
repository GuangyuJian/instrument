function [b]=ger_bar1(x)
gcolor=[0.0281684445121474 0.714083928404786 0.294365426432224];
bcolor=[0 0.737539425402267 0.834439366978244];
rcolor=[1 0.367323240931323 0.413223681757493];
ccolor=[0.3010 0.7450+0.2 0.9330];
acolor=[0.4940 0.1840 0.5560];
pcolor=[1 0.737539425402267 0.834439366978244];
% n=length(varargin);
color=[rcolor
    bcolor;
    acolor;
    pcolor;
    ccolor;
    gcolor;
    0 0 0;
    0 1 0;
    1 0 0
    0 0 1];

b=bar(x);
% b(1).width=0.6;
% y = [1 3 5; 3 2 7; 3 4 2];
% b = bar(y,'FaceColor','flat');
for k = 1:length(b)
    b(k).FaceColor  = color(k,:);
end

% ylim([0 max(max(x))*1.3])
for k=1:length(b)

xtips2 = b(k).XEndPoints;
ytips2 = b(k).YEndPoints;
% labels2 = string(round(b(k).YData,2));
smmmmmm=3;
labels2 = string(round(b(k).YData,smmmmmm));
labels2=strcat('\textbf{',strrep(labels2,'-','$-$'),'}');
tt=text(xtips2,ytips2,labels2,'HorizontalAlignment','center','FontUnits','points',...
    'VerticalAlignment','bottom','FontWeight','Bold','Color',[0 0 0],'FontSize',10,'Interpreter','latex');
% tt.FontUnits='points';
% tt.FontSize10;
% ttstring=tt.String;
% tt.String=strcat('\textbf{',strrep(ttstring,'-','$-$'),'}');

end

end