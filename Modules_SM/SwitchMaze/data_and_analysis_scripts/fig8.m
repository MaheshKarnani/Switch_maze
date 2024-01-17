%% NEW TRANSITION MATRIX
f2=figure;
f3=figure;
f4=figure;
load('SM_Hartmann2023_biorxiv_data.mat', 'session_PFCdreadd_Sal_fig6', 'session_PFCdreadd_C21_fig6')
for exp=1:2
    clearvars all_t T cat_t RD bins Bdur Tdur Ttype
    if exp==1        
        session=session_PFCdreadd_Sal_fig6.session;
    elseif exp==2
        session=session_PFCdreadd_C21_fig6.session;
    end
    %remove end exploits because they can only be singles, and count
    %feeding lengths.
    for an=1:size(session,2)
    list(an).list=[];
    list(an).feeding_length=[];
    for i=1:size(session(an).Etypes,2)
        t=categorical(session(an).Etypes(i).Etypes(1)); 
        if t=='FE' | t=='DE' | t=='EE'
            list(an).list=[list(an).list i];
        end
        if t=='EF' | t=='DF'
            list(an).feeding_length=[list(an).feeding_length session(an).E(i)];
        end
    end
    session(an).E(list(an).list)=[];
    session(an).feeding_length=list(an).feeding_length;
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
        food_runs_short(exp,a)=length(find(session(a).feeding_length>1 & session(a).feeding_length<7));
        food_runs_short(exp,a)=food_singles(exp,a);
        food_runs_long(exp,a)=length(find(session(a).feeding_length>6));
        food_runs_long(exp,a)=length(find(session(a).feeding_length>1));
    end
end
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

