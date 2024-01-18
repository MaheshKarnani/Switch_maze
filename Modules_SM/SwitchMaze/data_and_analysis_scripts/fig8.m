load('SM_Hartmann2023_biorxiv_data.mat', 'session_PFCdreadd_Sal_fig6_fig7_fig8', 'session_PFCdreadd_C21_fig6_fig7_fig8')
for exp=1:2
    clearvars all_t T cat_t RD bins Bdur Tdur Ttype
    if exp==1        
        session=session_PFCdreadd_Sal_fig6_fig7_fig8.session;
    elseif exp==2
        session=session_PFCdreadd_C21_fig6_fig7_fig8.session;
    end
    %count feeding lengths
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
    end
end

figure;
A=cat_feeding_length(1).cfl;
B=cat_feeding_length(2).cfl;
histogram(A,'DisplayStyle','bar','LineStyle','none','FaceColor','k','FaceAlpha',0.5);hold on;
histogram(B,'DisplayStyle','stairs','Linewidth',1,'EdgeColor','m');
title('run length');
[p,h] = ranksum(A,B)
xlabel('n');ylabel('count');
legend('Sal','C21');

figure;
m=mean(food_singles,2);
e=std(food_singles,0,2);
subplot(1,2,1),bar(m,'k','FaceAlpha',0.3);hold on;
errorbar(m,e,'k+');
plot([1.1 1.9],food_singles,'Color',[0 0 0 0.3]);
[hh pp]=ttest(food_singles(1,:),food_singles(2,:))
title('food singles');
percent_change=100*mean((food_singles(1,:)-food_singles(2,:))./food_singles(1,:))
percent_std=100*std((food_singles(1,:)-food_singles(2,:))./food_singles(1,:),0,2)
xticklabels({'Sal','C21'});

m=mean(food_runs,2);
e=std(food_runs,0,2);
subplot(1,2,2),bar(m,'k','FaceAlpha',0.3);hold on;
errorbar(m,e,'k+');
plot([1.1 1.9],food_runs,'Color',[0 0 0 0.3]);
[hh pp]=ttest(food_runs(1,:),food_runs(2,:))
title('food runs >1');
percent_change=100*mean((food_runs(1,:)-food_runs(2,:))./food_runs(1,:))
percent_std=100*std((food_runs(1,:)-food_runs(2,:))./food_runs(1,:),0,2)
xticklabels({'Sal','C21'});