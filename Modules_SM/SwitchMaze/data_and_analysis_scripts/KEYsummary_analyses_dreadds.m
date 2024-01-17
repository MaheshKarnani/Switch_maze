%% histograms of exploit runs
clear all; close all
% load('C:\Data\Tmaze\method_paper\fig1example\example1_PFCgroup2SB.mat');
load('C:\Data\Tmaze\method_paper\PFC_dreadd\SB.mat');
% load('C:\Data\Tmaze\method_paper\LH_dreadd\SB.mat');
% load('C:\Data\Tmaze\method_paper\ctrl_combined\SB.mat');

for an=1:size(session,2)
    list(an).list=[];
    list(an).feeding_length=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
%         if t=='ED' | t=='FD'
        if t=='EF' | t=='DF'
            list(an).feeding_length=[list(an).feeding_length session(an).E(i)];
        end
    end
    session(an).E(list(an).list)=[];
    session(an).feeding_length=list(an).feeding_length;
end

s_bsl=session;
s_bsl_exp=binned_exp;
load('C:\Data\Tmaze\method_paper\PFC_dreadd\SC21.mat');
% load('C:\Data\Tmaze\method_paper\LH_dreadd\SC21.mat');
% load('C:\Data\Tmaze\method_paper\ctrl_combined\SC21.mat');
for an=1:size(session,2)
    list(an).list=[];
    list(an).feeding_length=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
%         if t=='ED' | t=='FD'
        if t=='EF' | t=='DF'
            list(an).feeding_length=[list(an).feeding_length session(an).E(i)];
        end
    end
    session(an).E(list(an).list)=[];
    session(an).feeding_length=list(an).feeding_length;
end
s_C21=session;
s_C21_exp=binned_exp;

%% additional metrics 
figure; 
m=[mean(cat(1,s_bsl_exp.pellets)) mean(cat(1,s_C21_exp.pellets))];
e=[std(cat(1,s_bsl_exp.pellets)) std(cat(1,s_C21_exp.pellets))];
bar(m,'k','FaceAlpha',0.3);hold on;
errorbar(m,e,'k+');
plot([1.1 1.9], [cat(1,s_bsl_exp.pellets) cat(1,s_C21_exp.pellets)],'Color',[0 0 0 0.3]);
[hh pp]=ttest(cat(1,s_bsl_exp.pellets),cat(1,s_C21_exp.pellets))
title('pellets');
percent_change=100*mean((cat(1,s_bsl_exp.pellets)-cat(1,s_C21_exp.pellets))./cat(1,s_bsl_exp.pellets))
percent_std=100*std((cat(1,s_bsl_exp.pellets)-cat(1,s_C21_exp.pellets))./cat(1,s_bsl_exp.pellets),0,1)

%make that an anova
baseline=[];experiment=[];
baseline=cat(1,s_bsl_exp.pellets);
experiment=cat(1,s_C21_exp.pellets);
load('C:\Data\Tmaze\method_paper\ctrl_combined\SB.mat');
baseline=[baseline;cat(1,binned_exp.pellets)];
load('C:\Data\Tmaze\method_paper\LH_dreadd\SB.mat');
baseline=[baseline;cat(1,binned_exp.pellets)];

load('C:\Data\Tmaze\method_paper\ctrl_combined\SC21.mat');
experiment=[experiment;cat(1,binned_exp.pellets)];
load('C:\Data\Tmaze\method_paper\LH_dreadd\SC21.mat');
experiment=[experiment;cat(1,binned_exp.pellets)];

Subject=['d' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l']';
t=table(Subject,baseline,experiment,'VariableNames',{'Subject','bsl','C21'});
%define within-subjects variable
condition=[1 2]';
%fit a repeated measures model where parameter is the response and subject
%type is the predictor variable
rm_pellets=fitrm(t,'bsl-C21 ~ Subject','WithinDesign',condition);
%perform repeated measures analysis of variance
pellet_anova=ranova(rm_pellets)

%% 
% baseline=[];experiment=[];
baseline=cat(1,s_bsl_exp.block_dur);
experiment=cat(1,s_C21_exp.block_dur);
load('C:\Data\Tmaze\method_paper\ctrl_combined\SB.mat');
baseline=[baseline;cat(1,binned_exp.block_dur)];
load('C:\Data\Tmaze\method_paper\LH_dreadd\SB.mat');
baseline=[baseline;cat(1,binned_exp.block_dur)];

load('C:\Data\Tmaze\method_paper\ctrl_combined\SC21.mat');
experiment=[experiment;cat(1,binned_exp.block_dur)];
load('C:\Data\Tmaze\method_paper\LH_dreadd\SC21.mat');
experiment=[experiment;cat(1,binned_exp.block_dur)];

baseline=seconds(baseline);
experiment=seconds(experiment);
Subject=['d' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l']';
t=table(Subject,baseline,experiment,'VariableNames',{'Subject','bsl','C21'});
%define within-subjects variable
condition=[1 2]';
%fit a repeated measures model where parameter is the response and subject
%type is the predictor variable
rm_block_dur=fitrm(t,'bsl-C21 ~ Subject','WithinDesign',condition);
%perform repeated measures analysis of variance
block_dur_anova=ranova(rm_block_dur)


baseline=[];experiment=[];
baseline=cat(1,s_bsl_exp.trial_dur);
experiment=cat(1,s_C21_exp.trial_dur);
load('C:\Data\Tmaze\method_paper\ctrl_combined\SB.mat');
baseline=[baseline;cat(1,binned_exp.trial_dur)];
load('C:\Data\Tmaze\method_paper\LH_dreadd\SB.mat');
baseline=[baseline;cat(1,binned_exp.trial_dur)];

load('C:\Data\Tmaze\method_paper\ctrl_combined\SC21.mat');
experiment=[experiment;cat(1,binned_exp.trial_dur)];
load('C:\Data\Tmaze\method_paper\LH_dreadd\SC21.mat');
experiment=[experiment;cat(1,binned_exp.trial_dur)];

Subject=['d' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l']';
t=table(Subject,baseline,experiment,'VariableNames',{'Subject','bsl','C21'});
%define within-subjects variable
condition=[1 2]';
%fit a repeated measures model where parameter is the response and subject
%type is the predictor variable
rm_trial_dur=fitrm(t,'bsl-C21 ~ Subject','WithinDesign',condition);
%perform repeated measures analysis of variance
trial_dur_anova=ranova(rm_trial_dur)


baseline=[];experiment=[];
baseline=cat(1,s_bsl_exp.decisions);
experiment=cat(1,s_C21_exp.decisions);
load('C:\Data\Tmaze\method_paper\ctrl_combined\SB.mat');
baseline=[baseline;cat(1,binned_exp.decisions)];
load('C:\Data\Tmaze\method_paper\LH_dreadd\SB.mat');
baseline=[baseline;cat(1,binned_exp.decisions)];

load('C:\Data\Tmaze\method_paper\ctrl_combined\SC21.mat');
experiment=[experiment;cat(1,binned_exp.decisions)];
load('C:\Data\Tmaze\method_paper\LH_dreadd\SC21.mat');
experiment=[experiment;cat(1,binned_exp.decisions)];

Subject=['d' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l']';
t=table(Subject,baseline,experiment,'VariableNames',{'Subject','bsl','C21'});
%define within-subjects variable
condition=[1 2]';
%fit a repeated measures model where parameter is the response and subject
%type is the predictor variable
rm_decisions=fitrm(t,'bsl-C21 ~ Subject','WithinDesign',condition);
%perform repeated measures analysis of variance
decisions_anova=ranova(rm_decisions)


baseline=[];experiment=[];
baseline=cat(1,s_bsl_exp.starts);
experiment=cat(1,s_C21_exp.starts);
load('C:\Data\Tmaze\method_paper\ctrl_combined\SB.mat');
baseline=[baseline;cat(1,binned_exp.starts)];
load('C:\Data\Tmaze\method_paper\LH_dreadd\SB.mat');
baseline=[baseline;cat(1,binned_exp.starts)];

load('C:\Data\Tmaze\method_paper\ctrl_combined\SC21.mat');
experiment=[experiment;cat(1,binned_exp.starts)];
load('C:\Data\Tmaze\method_paper\LH_dreadd\SC21.mat');
experiment=[experiment;cat(1,binned_exp.starts)];

Subject=['d' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l']';
t=table(Subject,baseline,experiment,'VariableNames',{'Subject','bsl','C21'});
%define within-subjects variable
condition=[1 2]';
%fit a repeated measures model where parameter is the response and subject
%type is the predictor variable
rm_starts=fitrm(t,'bsl-C21 ~ Subject','WithinDesign',condition);
%perform repeated measures analysis of variance
starts_anova=ranova(rm_starts)

% stop

%% NEW TRANSITION MATRIX
f2=figure;
f3=figure;
f4=figure;
for exp=1:2
    clearvars all_t T cat_t RD bins Bdur Tdur Ttype
    if exp==1
        session=s_bsl;
    elseif exp==2
        session=s_C21;
    end
    cat_feeding_length(exp).cfl=[];
    for a=1:size(session,2)
        an_t=[];
        cat_Tdurs=[];
        cat_Etimes=[];
        cat_Etypes=[];
        cat_feeding_length(exp).cfl=[cat_feeding_length(exp).cfl session(a).feeding_length];
        mean_feeding_length(exp,a)=mean(session(a).feeding_length); 
        mean_feeding_run_length(exp,a)=mean(session(a).feeding_length(find(session(a).feeding_length>1))); 
        food_singles(exp,a)=length(find(session(a).feeding_length==1));
        food_runs(exp,a)=length(find(session(a).feeding_length>1));
%         food_runs_short(exp,a)=length(find(session(a).feeding_length>1 & session(a).feeding_length<7));
        food_runs_short(exp,a)=food_singles(exp,a);
%         food_runs_long(exp,a)=length(find(session(a).feeding_length>6));
        food_runs_long(exp,a)=length(find(session(a).feeding_length>1));
        for i=1:size(session(a).Etimes,2)
            an_t=[an_t session(a).Etimes(i).Etimes(1,1)];
            cat_Tdurs=[cat_Tdurs session(a).Tdurs(i).Tdurs];%continue from here, plot Tdurs for habi plot.
            cat_Etimes=[cat_Etimes session(a).Etimes(i).Etimes];%continue from here, plot Tdurs for habi plot.
            cat_Etypes=[cat_Etypes session(a).Etypes(i).Etypes];      
        end
        
        %extract Etype stats for analysis window which is the full rec
        %length for dreadd data
       
        Etypes_aw1=categorical(cat_Etypes);
        Etypes(a).aw1=[
            length(find(Etypes_aw1=='FE')) length(find(Etypes_aw1=='FD')) length(find(Etypes_aw1=='FF'));
            length(find(Etypes_aw1=='DE')) length(find(Etypes_aw1=='DD')) length(find(Etypes_aw1=='DF'));
            length(find(Etypes_aw1=='EE')) length(find(Etypes_aw1=='ED')) length(find(Etypes_aw1=='EF'))];
        Etypes(a).aw1=Etypes(a).aw1/sum(sum(Etypes(a).aw1))*100; %percentage likelihoods
        if exp==1
            Etypes(a).aw2=Etypes(a).aw1;
        end
    end
    figure(f2);
        X=[0,3.2;0,3.2];
        Y=[0.8,0.8;3.2,3.2];
        Z =[0,0;0,0];
        faceColor = {
                'm','c','y';
                'm','c','y';
                'm','c','y'};
        font=12;
   
    if exp==1 
        mat1=mean(cat(3,Etypes.aw2),3);
        eb=std(cat(3,Etypes.aw2),0,3);
        s=subplot(3,3,1),surf(X,Y,Z,'FaceColor','k','FaceAlpha',0.2,'EdgeColor','none');hold on;
        h=barError3d(mat1,eb,eb,faceColor);
        set(s,'FontSize',font);
        yticks([1:3]);xticks([0.5:1:2.5]);grid off
        xlim([0 3]);
        xlabel('from');
        ylabel('to');
        zlabel('mean/6h');
        xticklabels({'Food','Drink','Home'})
        yticklabels({'Home','Drink','Food'})
        title('bsl');
        zlim([0 80]);
    elseif exp==2
        mat2=mean(cat(3,Etypes.aw1),3);
        eb=std(cat(3,Etypes.aw1),0,3);
        s=subplot(3,3,2),surf(X,Y,Z,'FaceColor','k','FaceAlpha',0.2,'EdgeColor','none');hold on;
        h=barError3d(mat2,eb,eb,faceColor);
        set(s,'FontSize',font);
        yticks([1:3]);xticks([0.5:1:2.5]);grid off
        xlim([0 3]);
        xlabel('from');
        ylabel('to');
        zlabel('mean/6h');
        xticklabels({'Food','Drink','Home'})
        yticklabels({'Home','Drink','Food'})
        zlim([0 80]);
        title('C21');
        
        mat_diff=cat(3,Etypes.aw1)-cat(3,Etypes.aw2); %other way around this time.
        mat3=mean(mat_diff,3);
        eb=std(mat_diff,0,3);
        s=subplot(3,3,3),surf(X,Y,Z,'FaceColor','k','FaceAlpha',0.2,'EdgeColor','none');hold on;
        h=barError3d(mat3,eb,eb,faceColor);
        set(s,'FontSize',font);
        yticks([1:3]);xticks([0.5:1:2.5]);grid off
        xlim([0 3]);
        xlabel('from');
        ylabel('to');
        zlabel('mean/6h');
        xticklabels({'Food','Drink','Home'})
        yticklabels({'Home','Drink','Food'})
        title('difference');
        zlim([-30 30]);
    end
    figure(f3);
    font=8;
    if exp==1 
        data1=cat(3,Etypes.aw2);
        data1=reshape(data1,[9,size(session,2)]);
        mat1=mean(data1,2);
        eb=std(data1,0,2);
        X=[1,3,5,8,10,12,15,17,19];
        s=subplot(3,1,1),bar(X,mat1,0.4,'k','FaceAlpha',0.3);hold on;
        h=errorbar(X,mat1,eb,'k+');
    elseif exp==2
        data2=cat(3,Etypes.aw1);
        data2=reshape(data2,[9,size(session,2)]);
        mat2=mean(data2,2);
        eb=std(data2,0,2);
        X=[1,3,5,8,10,12,15,17,19]+1;
        s=subplot(3,1,1),bar(X,mat2,0.4,'w','FaceAlpha',0.3);hold on;
        h=errorbar(X,mat2,eb,'k+');
        set(s,'FontSize',font);
        X=[1,3,5,8,10,12,15,17,19]
        for n=1:9
            plot([X(n)+0.1 X(n)+0.9], [data1(n,:);data2(n,:)],'Color',[0 0 0 0.3]);
            [H(exp,n) P(exp,n)]=ttest(data1(n,:),data2(n,:));
        end
        ylim([0 80]);
        ylabel('count');
        xlabel('transition');
        xticks(sort([X-0.5 6.5 13.5 20.5],'ascend'));set(gca, 'TickDir', 'out');
        xticklabels({'Food','Drink','Home','','Food','Drink','Home','','Food','Drink','Home',''})    
        xlim([0.5 21]);
        
        percent_change_FF=100*mean((data1(7,:)-data2(7,:))./data1(7,:))
        percent_std_FF=100*std((data1(7,:)-data2(7,:))./data1(7,:),0,2)
        end
    figure(f4)
    load('colormapsRandRB.mat', 'cmap1');
    load('colormapsRandRB.mat', 'cmap2');
    clims1 = [0 60];
    clims2 = [-10 10];
    font=12;
    
    if exp==1 
        mat1=mean(cat(3,Etypes.aw2),3);
        axe(1)=subplot(3,3,1),imagesc(mat1,clims1);hold on;
        title('bsl');
        colormap(axe(1),cmap1/255);
    elseif exp==2
        mat2=mean(cat(3,Etypes.aw1),3);
        axe(2)=subplot(3,3,2),imagesc(mat2,clims1);hold on;
        title('C21');    
        colormap(axe(2),cmap1/255);
    end
    
    yticks([1:3]);xticks([1:3]);
    ylabel('from');
    xlabel('to');
    yticklabels({'Food','Drink','Home'})
    xticklabels({'Home','Drink','Food'})
    colorbar;

    if exp==2
        mat_diff=cat(3,Etypes.aw1)-cat(3,Etypes.aw2); %delta
%         mat_diff=cat(3,Etypes.aw1)-cat(3,Etypes.aw2)./cat(3,Etypes.aw1); %delta percent
        mat_diff(find(isnan(mat_diff)))=0;
        mat3=mean(mat_diff,3);
        axe(3)=subplot(3,3,3),imagesc(mat3,clims2);hold on;
        colormap(axe(3),cmap2/255);
        yticks([1:3]);xticks([1:3]);
        ylabel('from');
        xlabel('to');
        yticklabels({'Food','Drink','Home'})
        xticklabels({'Home','Drink','Food'})
        title('difference');
        colorbar;
    end
        
end
% stop
%% additional metrics 
figure; 
m=mean(mean_feeding_length,2);
e=std(mean_feeding_length,0,2);
bar(m,'k','FaceAlpha',0.3);hold on;
errorbar(m,e,'k+');
plot([1.1 1.9],mean_feeding_length,'Color',[0 0 0 0.3]);
[hh pp]=ttest(mean_feeding_length(1,:),mean_feeding_length(2,:))
title('feeding length');
percent_change=100*mean((mean_feeding_length(1,:)-mean_feeding_length(2,:))./mean_feeding_length(1,:))
percent_std=100*std((mean_feeding_length(1,:)-mean_feeding_length(2,:))./mean_feeding_length(1,:),0,2)
figure; 
m=mean(mean_feeding_run_length,2);
e=std(mean_feeding_run_length,0,2);
bar(m,'k','FaceAlpha',0.3);hold on;
errorbar(m,e,'k+');
plot([1.1 1.9],mean_feeding_run_length,'Color',[0 0 0 0.3]);
[hh pp]=ttest(mean_feeding_run_length(1,:),mean_feeding_run_length(2,:))
title('feeding RUN length');
percent_change=100*mean((mean_feeding_run_length(1,:)-mean_feeding_run_length(2,:))./mean_feeding_run_length(1,:))
percent_std=100*std((mean_feeding_run_length(1,:)-mean_feeding_run_length(2,:))./mean_feeding_run_length(1,:),0,2)
figure; 
m=mean(food_singles,2);
e=std(food_singles,0,2);
subplot(1,4,1),bar(m,'k','FaceAlpha',0.3);hold on;
errorbar(m,e,'k+');
plot([1.1 1.9],food_singles,'Color',[0 0 0 0.3]);
[hh pp]=ttest(food_singles(1,:),food_singles(2,:))
title('food singles');
percent_change=100*mean((food_singles(1,:)-food_singles(2,:))./food_singles(1,:))
percent_std=100*std((food_singles(1,:)-food_singles(2,:))./food_singles(1,:),0,2)

m=mean(food_runs,2);
e=std(food_runs,0,2);
subplot(1,4,2),bar(m,'k','FaceAlpha',0.3);hold on;
errorbar(m,e,'k+');
plot([1.1 1.9],food_runs,'Color',[0 0 0 0.3]);
[hh pp]=ttest(food_runs(1,:),food_runs(2,:))
title('all food runs');
percent_change=100*mean((food_runs(1,:)-food_runs(2,:))./food_runs(1,:))
percent_std=100*std((food_runs(1,:)-food_runs(2,:))./food_runs(1,:),0,2)


m=mean(food_runs_short,2);
e=std(food_runs_short,0,2);
subplot(1,4,3),bar(m,'k','FaceAlpha',0.3);hold on;
errorbar(m,e,'k+');
plot([1.1 1.9],food_runs_short,'Color',[0 0 0 0.3]);
[hh pp]=ttest(food_runs_short(1,:),food_runs_short(2,:))
title('short food runs');
percent_change=100*mean((food_runs_short(1,:)-food_runs_short(2,:))./food_runs_short(1,:))
percent_std=100*std((food_runs_short(1,:)-food_runs_short(2,:))./food_runs_short(1,:),0,2)

m=mean(food_runs_long,2);
e=std(food_runs_long,0,2);
subplot(1,4,4),bar(m,'k','FaceAlpha',0.3);hold on;
errorbar(m,e,'k+');
plot([1.1 1.9],food_runs_long,'Color',[0 0 0 0.3]);
[hh pp]=ttest(food_runs_long(1,:),food_runs_long(2,:))
title('long food runs');
percent_change=100*mean((food_runs_long(1,:)-food_runs_long(2,:))./food_runs_long(1,:))
percent_std=100*std((food_runs_long(1,:)-food_runs_long(2,:))./food_runs_long(1,:),0,2)
ylim([0 30])

food_SI=food_singles./food_runs;
figure; 
m=mean(food_SI,2);
e=std(food_SI,0,2);
bar(m,'k','FaceAlpha',0.3);hold on;
errorbar(m,e,'k+');
plot([1.1 1.9],food_SI,'Color',[0 0 0 0.3]);
[hh pp]=ttest(food_SI(1,:),food_SI(2,:))
title('food SI');
percent_change=100*mean((food_SI(1,:)-food_SI(2,:))./food_SI(1,:))
percent_std=100*std((food_SI(1,:)-food_SI(2,:))./food_SI(1,:),0,2)

figure;
A=cat_feeding_length(1).cfl;
B=cat_feeding_length(2).cfl;
histogram(A,'DisplayStyle','bar','LineStyle','none','FaceColor','k','FaceAlpha',0.5);hold on;
histogram(B,'DisplayStyle','stairs','Linewidth',1,'EdgeColor','m');
% xline(mean(A),'b','Linewidth',3);
% xline(mean(B),'r','Linewidth',2);
title('run length');
[p,h] = ranksum(A,B)
xlabel('n');ylabel('count');

figure;
A=cat_feeding_length(1).cfl;
B=cat_feeding_length(2).cfl;
histogram(A(find(A>1)),'DisplayStyle','bar','LineStyle','none','FaceColor','k','FaceAlpha',0.5);hold on;
histogram(B(find(B>1)),'DisplayStyle','stairs','Linewidth',1,'EdgeColor','m');
% xline(mean(A),'b','Linewidth',3);
% xline(mean(B),'r','Linewidth',2);
title('run length');
[p,h] = ranksum(A(find(A>1)),B(find(B>1)))
xlabel('n');ylabel('count');
%%

figure; 
m=[sum(A(find(A>1)));sum(B(find(B>1)))];
e=[std(A(find(A>1)),0,2); std(B(find(B>1)),0,2)];
subplot(1,4,1),bar(m,'k','FaceAlpha',0.3);hold on;
errorbar(m,e,'k+');
% plot([1.1 1.9],mean_feeding_run_length,'Color',[0 0 0 0.3]);
% [hh pp]=ttest(mean_feeding_run_length(1,:),mean_feeding_run_length(2,:))
title('all');
percent_change=100*(m(1)-m(2))/m(1)
percent_std=100*(e(1)-e(2))/e(1)

m=[sum(A(find(A>1 & A<4)));sum(B(find(B>1 & B<4)))];
e=[std(A(find(A>1 & A<4)),0,2); std(B(find(B>1 & B<4)),0,2)];
subplot(1,4,2),bar(m,'k','FaceAlpha',0.3);hold on;
errorbar(m,e,'k+');
% plot([1.1 1.9],mean_feeding_run_length,'Color',[0 0 0 0.3]);
% [hh pp]=ttest(mean_feeding_run_length(1,:),mean_feeding_run_length(2,:))
title('short');
percent_change=100*(m(1)-m(2))/m(1)
percent_std=100*(e(1)-e(2))/e(1)

m=[sum(A(find(A>3 & A<8)));sum(B(find(B>3 & B<8)))];
e=[std(A(find(A>3 & A<8)),0,2); std(B(find(B>3 & B<8)),0,2)];
subplot(1,4,3),bar(m,'k','FaceAlpha',0.3);hold on;
errorbar(m,e,'k+');
% plot([1.1 1.9],mean_feeding_run_length,'Color',[0 0 0 0.3]);
% [hh pp]=ttest(mean_feeding_run_length(1,:),mean_feeding_run_length(2,:))
title('MID');
percent_change=100*(m(1)-m(2))/m(1)
percent_std=100*(e(1)-e(2))/e(1)

m=[sum(A(find(A>7)));sum(B(find(B>7)))];
e=[std(A(find(A>7)),0,2); std(B(find(B>7)),0,2)];
subplot(1,4,4),bar(m,'k','FaceAlpha',0.3);hold on;
errorbar(m,e,'k+');
% plot([1.1 1.9],mean_feeding_run_length,'Color',[0 0 0 0.3]);
% [hh pp]=ttest(mean_feeding_run_length(1,:),mean_feeding_run_length(2,:))
title('high');
percent_change=100*(m(1)-m(2))/m(1)
percent_std=100*(e(1)-e(2))/e(1)

%% cumulative plots of meal duration

%add ctrl data

%preprocess
% load('C:\Data\Tmaze\method_paper\PFC_dreadd\SB.mat');
% load('C:\Data\Tmaze\method_paper\LH_dreadd\SB.mat');
load('C:\Data\Tmaze\method_paper\ctrl_combined\SB.mat');
for an=1:size(session,2)
    list(an).list=[];
    list(an).feeding_length=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
%         if t=='ED' | t=='FD'
        if t=='EF' | t=='DF'
            list(an).feeding_length=[list(an).feeding_length session(an).E(i)];
        end
    end
    session(an).E(list(an).list)=[];
    session(an).feeding_length=list(an).feeding_length;
end
s_bsl_ctrl=session;
% load('C:\Data\Tmaze\method_paper\PFC_dreadd\SC21.mat');
% load('C:\Data\Tmaze\method_paper\LH_dreadd\SC21.mat');
load('C:\Data\Tmaze\method_paper\ctrl_combined\SC21.mat');
for an=1:size(session,2)
    list(an).list=[];
    list(an).feeding_length=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
%         if t=='ED' | t=='FD'
        if t=='EF' | t=='DF'
            list(an).feeding_length=[list(an).feeding_length session(an).E(i)];
        end
    end
    session(an).E(list(an).list)=[];
    session(an).feeding_length=list(an).feeding_length;
end
s_C21_ctrl=session;

%extract feeding lengths ctrl
for exp=3:4
    clearvars all_t T cat_t RD bins Bdur Tdur Ttype
    if exp==3
        session=s_bsl_ctrl;
    elseif exp==4
        session=s_C21_ctrl;
    end
    cat_feeding_length(exp).cfl=[];
    for a=1:size(session,2)
        cat_feeding_length(exp).cfl=[cat_feeding_length(exp).cfl session(a).feeding_length];
    end
end


clear a b A B f1 f2 f3
A=cat_feeding_length(1).cfl;
B=cat_feeding_length(2).cfl;
% A=cat_feeding_length(3).cfl;
% B=cat_feeding_length(4).cfl;
f1=figure;f2=figure;f3=figure;
figure(f1);
ax(1)=subplot(1,3,1),histogram(A,'DisplayStyle','bar','LineStyle','none','FaceColor','k','FaceAlpha',0.5);hold on;
histogram(B,'DisplayStyle','stairs','Linewidth',1,'EdgeColor','m');
% set(gca, 'YScale', 'log');
% xline(mean(A),'b','Linewidth',3);
% xline(mean(B),'r','Linewidth',2);
[p(1),h(1)] = ranksum(A,B)
title('PFC dreadd');xlabel('n');ylabel('count');

figure(f1);
a=histogram(A);
figure(f2);
subplot(1,3,1),plot([0:a.NumBins],[0 cumsum(a.Values)/sum(a.Values)],'k','Linewidth',1);hold on;
figure(f1);
b=histogram(B);
figure(f2);
plot([0:b.NumBins],[0 cumsum(b.Values)/sum(b.Values)],'m','Linewidth',1);
[hh(1),pp(1)] = kstest2(A,B)
title('PFC dreadd meal lengths');xlabel('n');ylabel('count');

figure(f1);
a=histogram(A(find(A>1)));
figure(f2);
subplot(1,3,2),plot([0:a.NumBins],[0 cumsum(a.Values)/sum(a.Values)],'k','Linewidth',1);hold on;
figure(f1);
b=histogram(B(find(B>1)));
figure(f2);
plot([0:b.NumBins],[0 cumsum(b.Values)/sum(b.Values)],'m','Linewidth',1);
[hh(1),pp(1)] = kstest2(A(find(A>1)),B(find(B>1)))
title('PFC dreadd food runs');xlabel('n');ylabel('count');
% stop
%% continue old code

A=cat(2,s_bsl.E);
B=cat(2,s_C21.E);
f1=figure;f2=figure;f3=figure;
figure(f1);
ax(1)=subplot(1,3,1),histogram(A,'DisplayStyle','bar','LineStyle','none','FaceColor','k','FaceAlpha',0.5);hold on;
histogram(B,'DisplayStyle','stairs','Linewidth',1,'EdgeColor','m');
% set(gca, 'YScale', 'log');
% xline(mean(A),'b','Linewidth',3);
% xline(mean(B),'r','Linewidth',2);
[p(1),h(1)] = ranksum(A,B)
title('PFC dreadd');xlabel('n');ylabel('count');

a=histogram(A);
b=histogram(B);
figure(f2);
subplot(1,3,1),plot([0:a.NumBins],[0 cumsum(a.Values)/sum(a.Values)],'k','Linewidth',1);hold on;
plot([0:b.NumBins],[0 cumsum(b.Values)/sum(b.Values)],'m','Linewidth',1);
% xline(mean(A),'b','Linewidth',3);
% xline(mean(B),'r','Linewidth',2);
[hh(1),pp(1)] = kstest2(A,B)
title('PFC dreadd');xlabel('n');ylabel('count');

% figure(f3);
% subplot(1,3,1),semilogy(a.BinEdges(1:end-1),a.Values,'k','Linewidth',1);hold on;
% plot(b.BinEdges(1:end-1),b.Values,'m','Linewidth',1);
% 

load('C:\Data\Tmaze\method_paper\ctrl_combined\SB.mat');
for an=1:size(session,2)
    list(an).list=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
    end
    session(an).E(list(an).list)=[];
end
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\ctrl_combined\SC21.mat');
for an=1:size(session,2)
    list(an).list=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
    end
    session(an).E(list(an).list)=[];
end
s_C21=session;
% s_C21=binned_exp;
C=cat(2,s_bsl.E);
D=cat(2,s_C21.E);
figure(f1);
ax(2)=subplot(1,3,2),histogram(C,'DisplayStyle','bar','LineStyle','none','FaceColor','k','FaceAlpha',0.5);hold on;
histogram(D,'DisplayStyle','stairs','Linewidth',1,'EdgeColor','m');
% set(gca, 'YScale', 'log');
% xline(mean(C),'b','Linewidth',3);
% xline(mean(D),'r','Linewidth',2);
title('ctrl');xlabel('n');
[p(2),h(2)] = ranksum(C,D)


a=histogram(C);
b=histogram(D);
figure(f2);
subplot(1,3,2),plot([0:a.NumBins],[0 cumsum(a.Values)/sum(a.Values)],'k','Linewidth',1);hold on;
plot([0:b.NumBins],[0 cumsum(b.Values)/sum(b.Values)],'m','Linewidth',1);
% xline(mean(A),'b','Linewidth',3);
% xline(mean(B),'r','Linewidth',2);
title('ctrl');xlabel('n');
[hh(2),pp(2)] = kstest2(C,D)
ylabel('count');


load('C:\Data\Tmaze\method_paper\LH_dreadd\SB.mat');
for an=1:size(session,2)
    list(an).list=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
    end
    session(an).E(list(an).list)=[];
end
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\LH_dreadd\SC21.mat');
for an=1:size(session,2)
    list(an).list=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
    end
    session(an).E(list(an).list)=[];
end
s_C21=session;
% s_C21=binned_exp;

E=cat(2,s_bsl.E);
F=cat(2,s_C21.E);
figure(f1);
ax(3)=subplot(1,3,3),histogram(E,'DisplayStyle','bar','LineStyle','none','FaceColor','k','FaceAlpha',0.5);hold on;
histogram(F,'DisplayStyle','stairs','Linewidth',1,'EdgeColor','m');legend('bsl','C21');
% set(gca, 'YScale', 'log');
% xline(mean(E),'b','Linewidth',3);
% xline(mean(F),'r','Linewidth',2);
title('LH dreadd');xlabel('n');
[p(3),h(3)] = ranksum(E,F)
linkaxes(ax);
sgtitle('n-trial exploitation runs');

a=histogram(E);
b=histogram(F);
figure(f2);
subplot(1,3,3),plot([0:a.NumBins],[0 cumsum(a.Values)/sum(a.Values)],'k','Linewidth',1);hold on;
plot([0:b.NumBins],[0 cumsum(b.Values)/sum(b.Values)],'m','Linewidth',1);
% xline(mean(A),'b','Linewidth',3);
% xline(mean(B),'r','Linewidth',2);
[hh(3),pp(3)] = kstest2(E,F)
title('LH dreadd');xlabel('n');;ylabel('count');
sgtitle('n-trial exploitation runs');

%% count the ones and >1s
clear A B C D E F P H
load('C:\Data\Tmaze\method_paper\PFC_dreadd\SB.mat');
%% get chance estimate
tic
n_shuffles=10;
for a=1:size(session,2)
    session(a).shuffles.Etypes=[];
    session(a).shuffles.E=[];
    for shuf=1:n_shuffles
        L=session(a).sequence;
        L=L(randperm(length(L))); %SHUFFLE order
        j=1;
        k=1;
        if L(1)=="BB3" %init Etypes, treating first as E->x transition
            Etypes={'ED'};
        elseif L(1)=="BB4"
            Etypes={'EF'};
        elseif L(1)=="END"
            Etypes={'EE'};
        end

        for i=2:length(L)-1
            if L(i)==L(i-1)
                j=j+1;
                if L(i)=="BB4"
                    Etypes=[Etypes 'FF'];
                elseif L(i)=="BB3"
                    Etypes=[Etypes 'DD'];
                elseif L(i)=="END"
                    Etypes=[Etypes 'EE'];
                end
            else
                session(a).shuffles(shuf).E(k)=j; %run length
                session(a).shuffles(shuf).Etypes(k).Etypes=Etypes; %types of trial transition for confusion matrix
                %init next round
                k=k+1;
                j=1;
                if L(i-1)=="BB4"
                    if L(i)=="BB3"
                        Etypes={'FD'};
                    elseif L(i)=="BB4"
                        Etypes={'FF'};
                    elseif L(i)=="END"
                        Etypes={'FE'};
                    end
                elseif L(i-1)=="BB3"
                    if L(i)=="BB3"
                        Etypes={'DD'};
                    elseif L(i)=="BB4"
                        Etypes={'DF'};
                    elseif L(i)=="END"
                        Etypes={'DE'};
                    end
                elseif L(i-1)=="END"
                    if L(i)=="BB3"
                        Etypes={'ED'};
                    elseif L(i)=="BB4"
                        Etypes={'EF'};
                    elseif L(i)=="END"
                        Etypes={'EE'};
                    end
                end 
            end
        end
        %the correction for ends as below before next shuffle
        list(a).list=[];
        list(a).feeding_length=[];
        for i=1:size(session(a).shuffles(shuf).Etypes,2)
            t=categorical(session(a).shuffles(shuf).Etypes(i).Etypes(1)); 
            if t=='FE' | t=='DE' | t=='EE'
                list(a).list=[list(a).list i];
            end
    %         if t=='ED' | t=='FD'
            if t=='EF' | t=='DF'
                list(a).feeding_length=[list(a).feeding_length session(a).shuffles(shuf).E(i)];
            end
        end
        session(a).shuffles(shuf).E(list(a).list)=[];
        session(a).shuffles(shuf).feeding_length=list(a).feeding_length;
        % end correction
    end
    % shuffels made, count average SI across shuffles
    for shuf=1:size(session(a).shuffles,2)
        S(a,shuf)=length(find(session(a).shuffles(shuf).E==1));
        Sm(a,shuf)=length(find(session(a).shuffles(shuf).E>1)); 
    end
    session(a).SI_shuf_med=median(S(a,:)./Sm(a,:),2);
    session(a).SI_shuf_99=prctile((S(a,:)./Sm(a,:)),99);
end
toc

%% 
for an=1:size(session,2)
    list(an).list=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
    end
    session(an).E(list(an).list)=[];
end
s_PFC_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\PFC_dreadd\SC21.mat');
%% get chance estimate
tic
for a=1:size(session,2)
    session(a).shuffles.Etypes=[];
    session(a).shuffles.E=[];
    for shuf=1:n_shuffles
        L=session(a).sequence;
        L=L(randperm(length(L))); %SHUFFLE order
        j=1;
        k=1;
        if L(1)=="BB3" %init Etypes, treating first as E->x transition
            Etypes={'ED'};
        elseif L(1)=="BB4"
            Etypes={'EF'};
        elseif L(1)=="END"
            Etypes={'EE'};
        end

        for i=2:length(L)-1
            if L(i)==L(i-1)
                j=j+1;
                if L(i)=="BB4"
                    Etypes=[Etypes 'FF'];
                elseif L(i)=="BB3"
                    Etypes=[Etypes 'DD'];
                elseif L(i)=="END"
                    Etypes=[Etypes 'EE'];
                end
            else
                session(a).shuffles(shuf).E(k)=j; %run length
                session(a).shuffles(shuf).Etypes(k).Etypes=Etypes; %types of trial transition for confusion matrix
                %init next round
                k=k+1;
                j=1;
                if L(i-1)=="BB4"
                    if L(i)=="BB3"
                        Etypes={'FD'};
                    elseif L(i)=="BB4"
                        Etypes={'FF'};
                    elseif L(i)=="END"
                        Etypes={'FE'};
                    end
                elseif L(i-1)=="BB3"
                    if L(i)=="BB3"
                        Etypes={'DD'};
                    elseif L(i)=="BB4"
                        Etypes={'DF'};
                    elseif L(i)=="END"
                        Etypes={'DE'};
                    end
                elseif L(i-1)=="END"
                    if L(i)=="BB3"
                        Etypes={'ED'};
                    elseif L(i)=="BB4"
                        Etypes={'EF'};
                    elseif L(i)=="END"
                        Etypes={'EE'};
                    end
                end 
            end
        end
        %the correction for ends as below before next shuffle
        list(a).list=[];
        list(a).feeding_length=[];
        for i=1:size(session(a).shuffles(shuf).Etypes,2)
            t=categorical(session(a).shuffles(shuf).Etypes(i).Etypes(1)); 
            if t=='FE' | t=='DE' | t=='EE'
                list(a).list=[list(a).list i];
            end
    %         if t=='ED' | t=='FD'
            if t=='EF' | t=='DF'
                list(a).feeding_length=[list(a).feeding_length session(a).shuffles(shuf).E(i)];
            end
        end
        session(a).shuffles(shuf).E(list(a).list)=[];
        session(a).shuffles(shuf).feeding_length=list(a).feeding_length;
        % end correction
    end
    % shuffels made, count average SI across shuffles
    for shuf=1:size(session(a).shuffles,2)
        S(a,shuf)=length(find(session(a).shuffles(shuf).E==1));
        Sm(a,shuf)=length(find(session(a).shuffles(shuf).E>1)); 
    end
    session(a).SI_shuf_med=median(S(a,:)./Sm(a,:),2);
    session(a).SI_shuf_99=prctile((S(a,:)./Sm(a,:)),99);
end
toc
for an=1:size(session,2)
    list(an).list=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
    end
    session(an).E(list(an).list)=[];
end
s_PFC_C21=session;
% s_C21=binned_exp;
for a=1:size(s_PFC_bsl,2)
    A(a)=length(find(s_PFC_bsl(a).E==1));
    B(a)=length(find(s_PFC_C21(a).E==1));
    Am(a)=length(find(s_PFC_bsl(a).E>1));
    Bm(a)=length(find(s_PFC_C21(a).E>1));
end
figure;
ax(1)=subplot(1,3,1),plot([1 2],[A; B],'r');hold on;
plot([1 2],mean([A; B],2),'r^');
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('PFC dreadd');
[H(1) P(1)]=ttest(A, B)

load('C:\Data\Tmaze\method_paper\ctrl_combined\SB.mat');
%% get chance estimate
tic
for a=1:size(session,2)
    session(a).shuffles.Etypes=[];
    session(a).shuffles.E=[];
    for shuf=1:n_shuffles
        L=session(a).sequence;
        L=L(randperm(length(L))); %SHUFFLE order
        j=1;
        k=1;
        if L(1)=="BB3" %init Etypes, treating first as E->x transition
            Etypes={'ED'};
        elseif L(1)=="BB4"
            Etypes={'EF'};
        elseif L(1)=="END"
            Etypes={'EE'};
        end

        for i=2:length(L)-1
            if L(i)==L(i-1)
                j=j+1;
                if L(i)=="BB4"
                    Etypes=[Etypes 'FF'];
                elseif L(i)=="BB3"
                    Etypes=[Etypes 'DD'];
                elseif L(i)=="END"
                    Etypes=[Etypes 'EE'];
                end
            else
                session(a).shuffles(shuf).E(k)=j; %run length
                session(a).shuffles(shuf).Etypes(k).Etypes=Etypes; %types of trial transition for confusion matrix
                %init next round
                k=k+1;
                j=1;
                if L(i-1)=="BB4"
                    if L(i)=="BB3"
                        Etypes={'FD'};
                    elseif L(i)=="BB4"
                        Etypes={'FF'};
                    elseif L(i)=="END"
                        Etypes={'FE'};
                    end
                elseif L(i-1)=="BB3"
                    if L(i)=="BB3"
                        Etypes={'DD'};
                    elseif L(i)=="BB4"
                        Etypes={'DF'};
                    elseif L(i)=="END"
                        Etypes={'DE'};
                    end
                elseif L(i-1)=="END"
                    if L(i)=="BB3"
                        Etypes={'ED'};
                    elseif L(i)=="BB4"
                        Etypes={'EF'};
                    elseif L(i)=="END"
                        Etypes={'EE'};
                    end
                end 
            end
        end
        %the correction for ends as below before next shuffle
        list(a).list=[];
        list(a).feeding_length=[];
        for i=1:size(session(a).shuffles(shuf).Etypes,2)
            t=categorical(session(a).shuffles(shuf).Etypes(i).Etypes(1)); 
            if t=='FE' | t=='DE' | t=='EE'
                list(a).list=[list(a).list i];
            end
    %         if t=='ED' | t=='FD'
            if t=='EF' | t=='DF'
                list(a).feeding_length=[list(a).feeding_length session(a).shuffles(shuf).E(i)];
            end
        end
        session(a).shuffles(shuf).E(list(a).list)=[];
        session(a).shuffles(shuf).feeding_length=list(a).feeding_length;
        % end correction
    end
    % shuffels made, count average SI across shuffles
    for shuf=1:size(session(a).shuffles,2)
        S(a,shuf)=length(find(session(a).shuffles(shuf).E==1));
        Sm(a,shuf)=length(find(session(a).shuffles(shuf).E>1)); 
    end
    session(a).SI_shuf_med=median(S(a,:)./Sm(a,:),2);
    session(a).SI_shuf_99=prctile((S(a,:)./Sm(a,:)),99);
end
toc
for an=1:size(session,2)
    list(an).list=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
    end
    session(an).E(list(an).list)=[];
end
s_CTRL_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\ctrl_combined\SC21.mat');
%% get chance estimate
tic
for a=1:size(session,2)
    session(a).shuffles.Etypes=[];
    session(a).shuffles.E=[];
    for shuf=1:n_shuffles
        L=session(a).sequence;
        L=L(randperm(length(L))); %SHUFFLE order
        j=1;
        k=1;
        if L(1)=="BB3" %init Etypes, treating first as E->x transition
            Etypes={'ED'};
        elseif L(1)=="BB4"
            Etypes={'EF'};
        elseif L(1)=="END"
            Etypes={'EE'};
        end

        for i=2:length(L)-1
            if L(i)==L(i-1)
                j=j+1;
                if L(i)=="BB4"
                    Etypes=[Etypes 'FF'];
                elseif L(i)=="BB3"
                    Etypes=[Etypes 'DD'];
                elseif L(i)=="END"
                    Etypes=[Etypes 'EE'];
                end
            else
                session(a).shuffles(shuf).E(k)=j; %run length
                session(a).shuffles(shuf).Etypes(k).Etypes=Etypes; %types of trial transition for confusion matrix
                %init next round
                k=k+1;
                j=1;
                if L(i-1)=="BB4"
                    if L(i)=="BB3"
                        Etypes={'FD'};
                    elseif L(i)=="BB4"
                        Etypes={'FF'};
                    elseif L(i)=="END"
                        Etypes={'FE'};
                    end
                elseif L(i-1)=="BB3"
                    if L(i)=="BB3"
                        Etypes={'DD'};
                    elseif L(i)=="BB4"
                        Etypes={'DF'};
                    elseif L(i)=="END"
                        Etypes={'DE'};
                    end
                elseif L(i-1)=="END"
                    if L(i)=="BB3"
                        Etypes={'ED'};
                    elseif L(i)=="BB4"
                        Etypes={'EF'};
                    elseif L(i)=="END"
                        Etypes={'EE'};
                    end
                end 
            end
        end
        %the correction for ends as below before next shuffle
        list(a).list=[];
        list(a).feeding_length=[];
        for i=1:size(session(a).shuffles(shuf).Etypes,2)
            t=categorical(session(a).shuffles(shuf).Etypes(i).Etypes(1)); 
            if t=='FE' | t=='DE' | t=='EE'
                list(a).list=[list(a).list i];
            end
    %         if t=='ED' | t=='FD'
            if t=='EF' | t=='DF'
                list(a).feeding_length=[list(a).feeding_length session(a).shuffles(shuf).E(i)];
            end
        end
        session(a).shuffles(shuf).E(list(a).list)=[];
        session(a).shuffles(shuf).feeding_length=list(a).feeding_length;
        % end correction
    end
    % shuffels made, count average SI across shuffles
    for shuf=1:size(session(a).shuffles,2)
        S(a,shuf)=length(find(session(a).shuffles(shuf).E==1));
        Sm(a,shuf)=length(find(session(a).shuffles(shuf).E>1)); 
    end
    session(a).SI_shuf_med=median(S(a,:)./Sm(a,:),2);
    session(a).SI_shuf_99=prctile((S(a,:)./Sm(a,:)),99);
end
toc
for an=1:size(session,2)
    list(an).list=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
    end
    session(an).E(list(an).list)=[];
end
s_CTRL_C21=session;
% s_C21=binned_exp;for a=1:size(s_bsl,2)
for a=1:size(s_CTRL_bsl,2)
    C(a)=length(find(s_CTRL_bsl(a).E==1));
    D(a)=length(find(s_CTRL_C21(a).E==1));
    Cm(a)=length(find(s_CTRL_bsl(a).E>1));
    Dm(a)=length(find(s_CTRL_C21(a).E>1));
end
ax(2)=subplot(1,3,2),plot([1 2],[C; D],'k');hold on;
plot([1 2],mean([C; D],2),'k^');
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('ctrl');
[H(2) P(2)]=ttest(C, D)

load('C:\Data\Tmaze\method_paper\LH_dreadd\SB.mat');
%% get chance estimate
tic
for a=1:size(session,2)
    session(a).shuffles.Etypes=[];
    session(a).shuffles.E=[];
    for shuf=1:n_shuffles
        L=session(a).sequence;
        L=L(randperm(length(L))); %SHUFFLE order
        j=1;
        k=1;
        if L(1)=="BB3" %init Etypes, treating first as E->x transition
            Etypes={'ED'};
        elseif L(1)=="BB4"
            Etypes={'EF'};
        elseif L(1)=="END"
            Etypes={'EE'};
        end

        for i=2:length(L)-1
            if L(i)==L(i-1)
                j=j+1;
                if L(i)=="BB4"
                    Etypes=[Etypes 'FF'];
                elseif L(i)=="BB3"
                    Etypes=[Etypes 'DD'];
                elseif L(i)=="END"
                    Etypes=[Etypes 'EE'];
                end
            else
                session(a).shuffles(shuf).E(k)=j; %run length
                session(a).shuffles(shuf).Etypes(k).Etypes=Etypes; %types of trial transition for confusion matrix
                %init next round
                k=k+1;
                j=1;
                if L(i-1)=="BB4"
                    if L(i)=="BB3"
                        Etypes={'FD'};
                    elseif L(i)=="BB4"
                        Etypes={'FF'};
                    elseif L(i)=="END"
                        Etypes={'FE'};
                    end
                elseif L(i-1)=="BB3"
                    if L(i)=="BB3"
                        Etypes={'DD'};
                    elseif L(i)=="BB4"
                        Etypes={'DF'};
                    elseif L(i)=="END"
                        Etypes={'DE'};
                    end
                elseif L(i-1)=="END"
                    if L(i)=="BB3"
                        Etypes={'ED'};
                    elseif L(i)=="BB4"
                        Etypes={'EF'};
                    elseif L(i)=="END"
                        Etypes={'EE'};
                    end
                end 
            end
        end
        %the correction for ends as below before next shuffle
        list(a).list=[];
        list(a).feeding_length=[];
        for i=1:size(session(a).shuffles(shuf).Etypes,2)
            t=categorical(session(a).shuffles(shuf).Etypes(i).Etypes(1)); 
            if t=='FE' | t=='DE' | t=='EE'
                list(a).list=[list(a).list i];
            end
    %         if t=='ED' | t=='FD'
            if t=='EF' | t=='DF'
                list(a).feeding_length=[list(a).feeding_length session(a).shuffles(shuf).E(i)];
            end
        end
        session(a).shuffles(shuf).E(list(a).list)=[];
        session(a).shuffles(shuf).feeding_length=list(a).feeding_length;
        % end correction
    end
    % shuffels made, count average SI across shuffles
    for shuf=1:size(session(a).shuffles,2)
        S(a,shuf)=length(find(session(a).shuffles(shuf).E==1));
        Sm(a,shuf)=length(find(session(a).shuffles(shuf).E>1)); 
    end
    session(a).SI_shuf_med=median(S(a,:)./Sm(a,:),2);
    session(a).SI_shuf_99=prctile((S(a,:)./Sm(a,:)),99);
end
toc
for an=1:size(session,2)
    list(an).list=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
    end
    session(an).E(list(an).list)=[];
end
s_LH_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\LH_dreadd\SC21.mat');
%% get chance estimate
tic
for a=1:size(session,2)
    session(a).shuffles.Etypes=[];
    session(a).shuffles.E=[];
    for shuf=1:n_shuffles
        L=session(a).sequence;
        L=L(randperm(length(L))); %SHUFFLE order
        j=1;
        k=1;
        if L(1)=="BB3" %init Etypes, treating first as E->x transition
            Etypes={'ED'};
        elseif L(1)=="BB4"
            Etypes={'EF'};
        elseif L(1)=="END"
            Etypes={'EE'};
        end

        for i=2:length(L)-1
            if L(i)==L(i-1)
                j=j+1;
                if L(i)=="BB4"
                    Etypes=[Etypes 'FF'];
                elseif L(i)=="BB3"
                    Etypes=[Etypes 'DD'];
                elseif L(i)=="END"
                    Etypes=[Etypes 'EE'];
                end
            else
                session(a).shuffles(shuf).E(k)=j; %run length
                session(a).shuffles(shuf).Etypes(k).Etypes=Etypes; %types of trial transition for confusion matrix
                %init next round
                k=k+1;
                j=1;
                if L(i-1)=="BB4"
                    if L(i)=="BB3"
                        Etypes={'FD'};
                    elseif L(i)=="BB4"
                        Etypes={'FF'};
                    elseif L(i)=="END"
                        Etypes={'FE'};
                    end
                elseif L(i-1)=="BB3"
                    if L(i)=="BB3"
                        Etypes={'DD'};
                    elseif L(i)=="BB4"
                        Etypes={'DF'};
                    elseif L(i)=="END"
                        Etypes={'DE'};
                    end
                elseif L(i-1)=="END"
                    if L(i)=="BB3"
                        Etypes={'ED'};
                    elseif L(i)=="BB4"
                        Etypes={'EF'};
                    elseif L(i)=="END"
                        Etypes={'EE'};
                    end
                end 
            end
        end
        %the correction for ends as below before next shuffle
        list(a).list=[];
        list(a).feeding_length=[];
        for i=1:size(session(a).shuffles(shuf).Etypes,2)
            t=categorical(session(a).shuffles(shuf).Etypes(i).Etypes(1)); 
            if t=='FE' | t=='DE' | t=='EE'
                list(a).list=[list(a).list i];
            end
    %         if t=='ED' | t=='FD'
            if t=='EF' | t=='DF'
                list(a).feeding_length=[list(a).feeding_length session(a).shuffles(shuf).E(i)];
            end
        end
        session(a).shuffles(shuf).E(list(a).list)=[];
        session(a).shuffles(shuf).feeding_length=list(a).feeding_length;
        % end correction
    end
    % shuffels made, count average SI across shuffles
    for shuf=1:size(session(a).shuffles,2)
        S(a,shuf)=length(find(session(a).shuffles(shuf).E==1));
        Sm(a,shuf)=length(find(session(a).shuffles(shuf).E>1)); 
    end
    session(a).SI_shuf_med=median(S(a,:)./Sm(a,:),2);
    session(a).SI_shuf_99=prctile((S(a,:)./Sm(a,:)),99);
end
toc
for an=1:size(session,2)
    list(an).list=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
    end
    session(an).E(list(an).list)=[];
end
s_LH_C21=session;
% s_C21=binned_exp;
for a=1:size(s_LH_bsl,2)
    E(a)=length(find(s_LH_bsl(a).E==1));
    F(a)=length(find(s_LH_C21(a).E==1));
    Em(a)=length(find(s_LH_bsl(a).E>1));
    Fm(a)=length(find(s_LH_C21(a).E>1));
end
ax(3)=subplot(1,3,3),plot([1 2],[E; F],'b');hold on;
plot([1 2],mean([E; F],2),'b^');
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('LH dreadd');
[H(3) P(3)]=ttest(E, F)
linkaxes(ax);
sgtitle('# of 1-trial switches');
%%
% close all;
figure;
% %%% CORRECTION FOR MAKING HABI CURVE LOOK BETTER *************************
% %has minor effect on p value
% Am=Am+1;Bm=Bm+1;Cm=Cm+1;Dm=Dm+1;Em=Em+1;Fm=Fm+1;
% %%% END CORRECTION********************************************************
j=0;%counter for above stochastic limit
k=0;
bsl_above=0;
C21_above=0;
eb=std([A./Am; B./Bm],0,2);
h=subplot(2,3,1),errorbar(mean([A./Am; B./Bm],2),eb,'k+');hold on;
ax(1)=subplot(2,3,1),bar([1 2],mean([A./Am; B./Bm],2),0.5,'r');hold on;
plot([0.7 1.3],[mean(cat(1,s_PFC_bsl.SI_shuf_med)) mean(cat(1,s_PFC_bsl.SI_shuf_med))],'k--');
plot([0.7 1.3],[mean(cat(1,s_PFC_bsl.SI_shuf_99)) mean(cat(1,s_PFC_bsl.SI_shuf_99))],'k--');
plot([1.7 2.3],[mean(cat(1,s_PFC_C21.SI_shuf_med)) mean(cat(1,s_PFC_C21.SI_shuf_med))],'k--');
plot([1.7 2.3],[mean(cat(1,s_PFC_C21.SI_shuf_99)) mean(cat(1,s_PFC_C21.SI_shuf_99))],'k--');
% set(get(ax(1),'Children'),'FaceAlpha',0.2);
% errorbar([1 2],mean([A./Am; B./Bm],2),std([A./Am; B./Bm],0,2),'r','LineStyle','none');
plot([1.1 1.8],[A./Am; B./Bm],'k');
for a=1:size(A,2)
   if A(a)/Am(a)>s_PFC_bsl(a).SI_shuf_99
       plot(1.1,A(a)/Am(a),'mo');
       j=j+1;bsl_above=bsl_above+1;
   end
   if B(a)/Bm(a)>s_PFC_C21(a).SI_shuf_99
       plot(1.8,B(a)/Bm(a),'mo');
       C21_above=C21_above+1;
   end
   if A(a)/Am(a)>s_PFC_bsl(a).SI_shuf_med
       k=k+1;
   end
end
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('PFC dreadd');
[H(1) P(1)]=ttest(A./Am, B./Bm)
change_percent=mean(((B./Bm)-(A./Am))./(A./Am))
change_sd=std(((B./Bm)-(A./Am))./(A./Am),0,2)
subplot(2,3,4),bar([bsl_above/size(A,2) 1-bsl_above/size(A,2); C21_above/size(A,2) 1-C21_above/size(A,2)],0.5,'stacked');
xlim([0.5 2.5]);

session=s_LH_C21;
bsl_above=0;
C21_above=0;
S=[];
for a=1:size(session,2);
    for shuf=1:size(session(a).shuffles,2)
        S=[S cat(2,session(a).shuffles(shuf).E)];
    end
end
X=cat(2,session.E);
[P1 H1]=ranksum(S,X)

eb=std([C./Cm; D./Dm],0,2);
h=subplot(2,3,2),errorbar(mean([C./Cm; D./Dm],2),eb,'k+');hold on;
ax(2)=subplot(2,3,2),bar([1 2],mean([C./Cm; D./Dm],2),0.5,'k');hold on;
plot([0.7 1.3],[mean(cat(1,s_CTRL_bsl.SI_shuf_med)) mean(cat(1,s_CTRL_bsl.SI_shuf_med))],'k--');
plot([0.7 1.3],[mean(cat(1,s_CTRL_bsl.SI_shuf_99)) mean(cat(1,s_CTRL_bsl.SI_shuf_99))],'k--');
plot([1.7 2.3],[mean(cat(1,s_CTRL_C21.SI_shuf_med)) mean(cat(1,s_CTRL_C21.SI_shuf_med))],'k--');
plot([1.7 2.3],[mean(cat(1,s_CTRL_C21.SI_shuf_99)) mean(cat(1,s_CTRL_C21.SI_shuf_99))],'k--');
% set(get(ax(2),'Children'),'FaceAlpha',0.2);
plot([1.1 1.8],[C./Cm; D./Dm],'k');
for a=1:size(C,2)
   if C(a)/Cm(a)>s_CTRL_bsl(a).SI_shuf_99
       plot(1.1,C(a)/Cm(a),'mo');
       j=j+1;bsl_above=bsl_above+1;
   end
   if D(a)/Dm(a)>s_CTRL_C21(a).SI_shuf_99
       plot(1.8,D(a)/Dm(a),'mo');
       C21_above=C21_above+1;
   end
    if C(a)/Cm(a)>s_CTRL_bsl(a).SI_shuf_med
       k=k+1;
   end
end
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('ctrl');
[H(2) P(2)]=ttest(C./Cm, D./Dm)
subplot(2,3,5),bar([bsl_above/size(C,2) 1-bsl_above/size(C,2); C21_above/size(C,2) 1-C21_above/size(C,2)],0.5,'stacked');
xlim([0.5 2.5]);

bsl_above=0;
C21_above=0;
eb=std([E./Em; F./Fm],0,2);
h=subplot(2,3,3),errorbar(mean([E./Em; F./Fm],2),eb,'k+');hold on;
ax(3)=subplot(2,3,3),bar([1 2],mean([E./Em; F./Fm],2),0.5,'b');hold on;
plot([0.7 1.3],[mean(cat(1,s_LH_bsl.SI_shuf_med)) mean(cat(1,s_LH_bsl.SI_shuf_med))],'k--');
plot([0.7 1.3],[mean(cat(1,s_LH_bsl.SI_shuf_99)) mean(cat(1,s_LH_bsl.SI_shuf_99))],'k--');
plot([1.7 2.3],[mean(cat(1,s_LH_C21.SI_shuf_med)) mean(cat(1,s_LH_C21.SI_shuf_med))],'k--');
plot([1.7 2.3],[mean(cat(1,s_LH_C21.SI_shuf_99)) mean(cat(1,s_LH_C21.SI_shuf_99))],'k--');
% set(get(ax(3),'Children'),'FaceAlpha',0.2);
plot([1.1 1.8],[E./Em; F./Fm],'K');
for a=1:size(E,2)
   if E(a)/Em(a)>s_LH_bsl(a).SI_shuf_99
       plot(1.1,E(a)/Em(a),'mo');
       j=j+1;bsl_above=bsl_above+1;
   end
   if F(a)/Fm(a)>s_LH_C21(a).SI_shuf_99
       plot(1.8,F(a)/Fm(a),'mo');
       C21_above=C21_above+1;
   end
   if E(a)/Em(a)>s_LH_bsl(a).SI_shuf_med
       k=k+1;
   end
end
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('LH dreadd');
[H(3) P(3)]=ttest(E./Em, F./Fm)
linkaxes(ax);
subplot(2,3,6),bar([bsl_above/size(E,2) 1-bsl_above/size(E,2); C21_above/size(E,2) 1-C21_above/size(E,2)],0.5,'stacked');
xlim([0.5 2.5]);

sgtitle('ratio of 1-trial to >1 trial runs');

figure;
plot([1 2],[C./Cm; D./Dm],'k');hold on;
plot([1 2],mean([C./Cm; D./Dm],2),'k^');
plot([1 2],[A./Am; B./Bm],'r');hold on;
plot([1 2],mean([A./Am; B./Bm],2),'r^');
xlim([0.5 2.5]);
%make table
Subject=['d' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'd' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'c' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l' 'l']';
t=table(Subject,[A./Am C./Cm E./Em]',[B./Bm D./Dm F./Fm]','VariableNames',{'Subject','bsl','C21'});
t=table(Subject,[A./Am C./Cm E./Em]',[B./Bm D./Dm F./Fm]','VariableNames',{'Subject','bsl','C21'});
%define within-subjects variable
condition=[1 2]';
%fit a repeated measures model where parameter is the response and subject
%type is the predictor variable
rm=fitrm(t,'bsl-C21 ~ Subject','WithinDesign',condition);
%perform repeated measures analysis of variance
ranovatbl=ranova(rm)

%summary stats
mean_Switchrate=mean([A./Am C./Cm E./Em])
std_Switchrate=std([A./Am C./Cm E./Em],0,2)
how_many_above_99th=j
how_many_below_99th=size([A./Am C./Cm E./Em],2)-j
how_many_above_med=k

STOP
%% durations
clear A B C D E F H P h p
load('C:\Data\Tmaze\method_paper\PFC_dreadd\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\PFC_dreadd\SC21.mat');
s_C21=session;
% s_C21=binned_exp;
A=cat(2,s_bsl.Edurs);
A=horzcat(A.Edurs)/1000;
B=cat(2,s_C21.Edurs);
B=horzcat(B.Edurs)/1000;
figure;
edges = [-1:0.5:-0.5, linspace(-0.5,0.5,50), 0.5:0.5:50];
ax(1)=subplot(1,3,1),histogram(A,edges,'DisplayStyle','stairs','Linewidth',3);hold on;
histogram(B,edges,'DisplayStyle','stairs','Linewidth',2);legend('bsl','C21');
title('ctrl');
[p(1),h(1)] = ranksum(A,B)
title('PFC dreadd');xlabel('s');ylabel('count');
load('C:\Data\Tmaze\method_paper\ctrl_combined\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\ctrl_combined\SC21.mat');
s_C21=session;
% s_C21=binned_exp;
C=cat(2,s_bsl.Edurs);
C=horzcat(C.Edurs)/1000;
D=cat(2,s_C21.Edurs);
D=horzcat(D.Edurs)/1000;
ax(2)=subplot(1,3,2),histogram(C,edges,'DisplayStyle','stairs','Linewidth',3);hold on;
histogram(D,edges,'DisplayStyle','stairs','Linewidth',2);legend('bsl','C21');
title('ctrl');xlabel('s');
[p(2),h(2)] = ranksum(C,D)
load('C:\Data\Tmaze\method_paper\LH_dreadd\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\LH_dreadd\SC21.mat');
s_C21=session;
% s_C21=binned_exp;
E=cat(2,s_bsl.Edurs);
E=horzcat(E.Edurs)/1000;
F=cat(2,s_C21.Edurs);
F=horzcat(F.Edurs)/1000;
ax(3)=subplot(1,3,3),histogram(E,edges,'DisplayStyle','stairs','Linewidth',3);hold on;
histogram(F,edges,'DisplayStyle','stairs','Linewidth',2);legend('bsl','C21');
title('LH dreadd');xlabel('s');
[p(3),h(3)] = ranksum(E,F)
linkaxes(ax);
sgtitle('entry duration');
%% just the 1-trial switch speeds
clear A B C D E F H P h p
load('C:\Data\Tmaze\method_paper\PFC_dreadd\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\PFC_dreadd\SC21.mat');
s_C21=session;
% s_C21=binned_exp;
for a=1:size(s_bsl,2)
    AA=s_bsl(a).Edurs(find(s_bsl(a).E==1));
    A(a)=mean(cat(2,AA.Edurs));
    BB=s_C21(a).Edurs(find(s_C21(a).E==1));
    B(a)=mean(cat(2,BB.Edurs));
end
figure;
ax(1)=subplot(1,3,1),plot([1 2],[A; B],'r');hold on;
plot([1 2],mean([A; B],2),'r^');
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('PFC dreadd');ylabel('ms');
[H(1) P(1)]=ttest(A, B)

load('C:\Data\Tmaze\method_paper\ctrl_combined\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\ctrl_combined\SC21.mat');
s_C21=session;
% s_C21=binned_exp;for a=1:size(s_bsl,2)
for a=1:size(s_bsl,2)
    CC=s_bsl(a).Edurs(find(s_bsl(a).E==1));
    C(a)=mean(cat(2,CC.Edurs));
    DD=s_C21(a).Edurs(find(s_C21(a).E==1));
    D(a)=mean(cat(2,DD.Edurs));
end
ax(2)=subplot(1,3,2),plot([1 2],[C; D],'k');hold on;
plot([1 2],mean([C; D],2),'k^');
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('ctrl');ylabel('ms');
[H(2) P(2)]=ttest(C, D)

load('C:\Data\Tmaze\method_paper\LH_dreadd\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\LH_dreadd\SC21.mat');
s_C21=session;
% s_C21=binned_exp;
for a=1:size(s_bsl,2)
    EE=s_bsl(a).Edurs(find(s_bsl(a).E==1));
    E(a)=mean(cat(2,EE.Edurs));
    FF=s_C21(a).Edurs(find(s_C21(a).E==1));
    F(a)=mean(cat(2,FF.Edurs));
end
ax(3)=subplot(1,3,3),plot([1 2],[E; F],'b');hold on;
plot([1 2],mean([E; F],2),'b^');
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('LH dreadd');ylabel('ms');
[H(3) P(3)]=ttest(E, F)
linkaxes(ax);
sgtitle('entry dur of 1-trial switches');

%% >1 trial run entry durations
clear A B C D E F H P h p
load('C:\Data\Tmaze\method_paper\PFC_dreadd\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\PFC_dreadd\SC21.mat');
s_C21=session;
% s_C21=binned_exp;
for a=1:size(s_bsl,2)
    AA=s_bsl(a).Edurs(find(s_bsl(a).E>1));
    A(a)=mean(cat(2,AA.Edurs));
    BB=s_C21(a).Edurs(find(s_C21(a).E>1));
    B(a)=mean(cat(2,BB.Edurs));
end
figure;
ax(1)=subplot(1,3,1),plot([1 2],[A; B],'r');hold on;
plot([1 2],mean([A; B],2),'r^');
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('PFC dreadd');ylabel('ms');
[H(1) P(1)]=ttest(A, B)

load('C:\Data\Tmaze\method_paper\ctrl_combined\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\ctrl_combined\SC21.mat');
s_C21=session;
% s_C21=binned_exp;for a=1:size(s_bsl,2)
for a=1:size(s_bsl,2)
    CC=s_bsl(a).Edurs(find(s_bsl(a).E>1));
    C(a)=mean(cat(2,CC.Edurs));
    DD=s_C21(a).Edurs(find(s_C21(a).E>1));
    D(a)=mean(cat(2,DD.Edurs));
end
ax(2)=subplot(1,3,2),plot([1 2],[C; D],'k');hold on;
plot([1 2],mean([C; D],2),'k^');
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('ctrl');ylabel('ms');
[H(2) P(2)]=ttest(C, D)

load('C:\Data\Tmaze\method_paper\LH_dreadd\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\LH_dreadd\SC21.mat');
s_C21=session;
% s_C21=binned_exp;
for a=1:size(s_bsl,2)
    EE=s_bsl(a).Edurs(find(s_bsl(a).E>1));
    E(a)=mean(cat(2,EE.Edurs));
    FF=s_C21(a).Edurs(find(s_C21(a).E>1));
    F(a)=mean(cat(2,FF.Edurs));
end
ax(3)=subplot(1,3,3),plot([1 2],[E; F],'b');hold on;
plot([1 2],mean([E; F],2),'b^');
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('LH dreadd');ylabel('ms');
[H(3) P(3)]=ttest(E, F)
linkaxes(ax);
sgtitle('entry dur of >1 trial runs');
%% >3 trial run entry durations
clear A B C D E F H P h p
load('C:\Data\Tmaze\method_paper\PFC_dreadd\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\PFC_dreadd\SC21.mat');
s_C21=session;
% s_C21=binned_exp;
for a=1:size(s_bsl,2)
    AA=s_bsl(a).Edurs(find(s_bsl(a).E>3));
    A(a)=mean(cat(2,AA.Edurs));
    BB=s_C21(a).Edurs(find(s_C21(a).E>3));
    B(a)=mean(cat(2,BB.Edurs));
end
figure;
ax(1)=subplot(1,3,1),plot([1 2],[A; B],'r');hold on;
plot([1 2],mean([A; B],2),'r^');
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('PFC dreadd');ylabel('ms');
[H(1) P(1)]=ttest(A, B)

load('C:\Data\Tmaze\method_paper\ctrl_combined\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\ctrl_combined\SC21.mat');
s_C21=session;
% s_C21=binned_exp;for a=1:size(s_bsl,2)
for a=1:size(s_bsl,2)
    CC=s_bsl(a).Edurs(find(s_bsl(a).E>3));
    C(a)=mean(cat(2,CC.Edurs));
    DD=s_C21(a).Edurs(find(s_C21(a).E>3));
    D(a)=mean(cat(2,DD.Edurs));
end
ax(2)=subplot(1,3,2),plot([1 2],[C; D],'k');hold on;
plot([1 2],mean([C; D],2),'k^');
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('ctrl');ylabel('ms');
[H(2) P(2)]=ttest(C, D)

load('C:\Data\Tmaze\method_paper\LH_dreadd\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\LH_dreadd\SC21.mat');
s_C21=session;
% s_C21=binned_exp;
for a=1:size(s_bsl,2)
    EE=s_bsl(a).Edurs(find(s_bsl(a).E>3));
    E(a)=mean(cat(2,EE.Edurs));
    FF=s_C21(a).Edurs(find(s_C21(a).E>3));
    F(a)=mean(cat(2,FF.Edurs));
end
ax(3)=subplot(1,3,3),plot([1 2],[E; F],'b');hold on;
plot([1 2],mean([E; F],2),'b^');
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('LH dreadd');ylabel('ms');
[H(3) P(3)]=ttest(E, F)
linkaxes(ax);
sgtitle('entry dur of >3 trial runs');

%% all trials entry durations
clear A B C D E F H P h p
load('C:\Data\Tmaze\method_paper\PFC_dreadd\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\PFC_dreadd\SC21.mat');
s_C21=session;
% s_C21=binned_exp;
for a=1:size(s_bsl,2)
    AA=s_bsl(a).Edurs;
    A(a)=mean(cat(2,AA.Edurs));
    BB=s_C21(a).Edurs;
    B(a)=mean(cat(2,BB.Edurs));
end
figure;
ax(1)=subplot(1,3,1),plot([1 2],[A; B],'r');hold on;
plot([1 2],mean([A; B],2),'r^');
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('PFC dreadd');ylabel('ms');
[H(1) P(1)]=ttest(A, B)

load('C:\Data\Tmaze\method_paper\ctrl_combined\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\ctrl_combined\SC21.mat');
s_C21=session;
% s_C21=binned_exp;for a=1:size(s_bsl,2)
for a=1:size(s_bsl,2)
    CC=s_bsl(a).Edurs;
    C(a)=mean(cat(2,CC.Edurs));
    DD=s_C21(a).Edurs;
    D(a)=mean(cat(2,DD.Edurs));
end
ax(2)=subplot(1,3,2),plot([1 2],[C; D],'k');hold on;
plot([1 2],mean([C; D],2),'k^');
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('ctrl');ylabel('ms');
[H(2) P(2)]=ttest(C, D)

load('C:\Data\Tmaze\method_paper\LH_dreadd\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\LH_dreadd\SC21.mat');
s_C21=session;
% s_C21=binned_exp;
for a=1:size(s_bsl,2)
    EE=s_bsl(a).Edurs;
    E(a)=mean(cat(2,EE.Edurs));
    FF=s_C21(a).Edurs;
    F(a)=mean(cat(2,FF.Edurs));
end
ax(3)=subplot(1,3,3),plot([1 2],[E; F],'b');hold on;
plot([1 2],mean([E; F],2),'b^');
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('LH dreadd');ylabel('ms');
[H(3) P(3)]=ttest(E, F)
linkaxes(ax);
sgtitle('entry dur of all trials');


%% trial durations
clear A B C D E F H P h p
load('C:\Data\Tmaze\method_paper\PFC_dreadd\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\PFC_dreadd\SC21.mat');
s_C21=session;
% s_C21=binned_exp;
A=cat(2,s_bsl.Tdurs);
A=horzcat(A.Tdurs)/1000;
B=cat(2,s_C21.Tdurs);
B=horzcat(B.Tdurs)/1000;
figure;
edges = [-1:0.5:-0.5, linspace(-0.5,0.5,50), 0.5:0.5:50];
ax(1)=subplot(1,3,1),histogram(A,edges,'DisplayStyle','stairs','Linewidth',3);hold on;
histogram(B,edges,'DisplayStyle','stairs','Linewidth',2);legend('bsl','C21');
title('ctrl');
[p(1),h(1)] = ranksum(A,B)
title('PFC dreadd');xlabel('s');ylabel('count');
load('C:\Data\Tmaze\method_paper\ctrl_combined\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\ctrl_combined\SC21.mat');
s_C21=session;
% s_C21=binned_exp;
C=cat(2,s_bsl.Tdurs);
C=horzcat(C.Tdurs)/1000;
D=cat(2,s_C21.Tdurs);
D=horzcat(D.Tdurs)/1000;
ax(2)=subplot(1,3,2),histogram(C,edges,'DisplayStyle','stairs','Linewidth',3);hold on;
histogram(D,edges,'DisplayStyle','stairs','Linewidth',2);legend('bsl','C21');
title('ctrl');xlabel('s');
[p(2),h(2)] = ranksum(C,D)
load('C:\Data\Tmaze\method_paper\LH_dreadd\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\LH_dreadd\SC21.mat');
s_C21=session;
% s_C21=binned_exp;
E=cat(2,s_bsl.Tdurs);
E=horzcat(E.Tdurs)/1000;
F=cat(2,s_C21.Tdurs);
F=horzcat(F.Tdurs)/1000;
ax(3)=subplot(1,3,3),histogram(E,edges,'DisplayStyle','stairs','Linewidth',3);hold on;
histogram(F,edges,'DisplayStyle','stairs','Linewidth',2);legend('bsl','C21');
title('LH dreadd');xlabel('s');
[p(3),h(3)] = ranksum(E,F)
linkaxes(ax);
sgtitle('trial duration');
%% just the 1-trial switch durs
clear A B C D E F H P h p
load('C:\Data\Tmaze\method_paper\PFC_dreadd\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\PFC_dreadd\SC21.mat');
s_C21=session;
% s_C21=binned_exp;
for a=1:size(s_bsl,2)
    AA=s_bsl(a).Tdurs(find(s_bsl(a).E==1));
    A(a)=mean(cat(2,AA.Tdurs));
    BB=s_C21(a).Tdurs(find(s_C21(a).E==1));
    B(a)=mean(cat(2,BB.Tdurs));
end
figure;
ax(1)=subplot(1,3,1),plot([1 2],[A; B],'r');hold on;
plot([1 2],mean([A; B],2),'r^');
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('PFC dreadd');ylabel('ms');
[H(1) P(1)]=ttest(A, B)

load('C:\Data\Tmaze\method_paper\ctrl_combined\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\ctrl_combined\SC21.mat');
s_C21=session;
% s_C21=binned_exp;for a=1:size(s_bsl,2)
for a=1:size(s_bsl,2)
    CC=s_bsl(a).Tdurs(find(s_bsl(a).E==1));
    C(a)=mean(cat(2,CC.Tdurs));
    DD=s_C21(a).Tdurs(find(s_C21(a).E==1));
    D(a)=mean(cat(2,DD.Tdurs));
end
ax(2)=subplot(1,3,2),plot([1 2],[C; D],'k');hold on;
plot([1 2],mean([C; D],2),'k^');
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('ctrl');ylabel('ms');
[H(2) P(2)]=ttest(C, D)

load('C:\Data\Tmaze\method_paper\LH_dreadd\SB.mat');
s_bsl=session;
% s_bsl=binned_exp;
load('C:\Data\Tmaze\method_paper\LH_dreadd\SC21.mat');
s_C21=session;
% s_C21=binned_exp;
for a=1:size(s_bsl,2)
    EE=s_bsl(a).Tdurs(find(s_bsl(a).E==1));
    E(a)=mean(cat(2,EE.Tdurs));
    FF=s_C21(a).Tdurs(find(s_C21(a).E==1));
    F(a)=mean(cat(2,FF.Tdurs));
end
ax(3)=subplot(1,3,3),plot([1 2],[E; F],'b');hold on;
plot([1 2],mean([E; F],2),'b^');
xlim([0.5 2.5]);xticks([1 2]);xticklabels({'veh','C21'});
title('LH dreadd');ylabel('ms');
[H(3) P(3)]=ttest(E, F)
linkaxes(ax);
sgtitle('trial duration of 1-trial switches');