function fig_setup(talk)
%talk =1 means it's a talk, bigger words

set(gcf,'color','w');
set(gcf,'Inverthardcopy','off','defaultaxeslayer','top');
if talk==1
   set(gcf,'defaulttextfontweight','bold','defaultaxesfontweight','bold','defaultaxesfontsize',12,'defaulttextfontsize',12);
   set(gcf,'defaultlinelinewidth',2,'defaultaxesticklength',[.02 .02]) 
   set(gcf,'defaultaxesxminortick','on','defaultaxesyminortick','on');
elseif talk==0
   set(gcf,'defaulttextfontweight','bold','defaultaxesfontsize',10,'defaulttextfontsize',10);
   set(gcf,'defaultlinelinewidth',1.5,'defaultaxesticklength',[.015 .015])   
   set(gcf,'defaultaxesxminortick','off','defaultaxesyminortick','off');
elseif talk==2
   set(gcf,'defaulttextfontweight','bold','defaultaxesfontweight','bold','defaultaxesfontsize',10,'defaulttextfontsize',10);
   set(gcf,'defaultlinelinewidth',1.5,'defaultaxesticklength',[.015 .015])   
   set(gcf,'defaultaxesxminortick','off','defaultaxesyminortick','off');
end
set(0,'defaultaxestickdir','out');
set(gcf,'defaultaxesxminortick','on','defaultaxesyminortick','on');
     col=[0 0 0;
          1         0    0;
         0    0         1;
    		0         .5        0;
         0    0.7500    0.7500;
    0.7500         0    0.7500;
    0.7500    0.7500         0;
    0.2500    0.2500    0.2500];
set(0,'defaultaxescolororder',col);
set(gcf,'defaultaxeslinewidth',0.75);

set(0,'defaultaxeslinewidth',0.75);
set(0,'defaultlinelinewidth',1);