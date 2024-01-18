clear all; close all
load('SM_Hartmann2023_biorxiv_data.mat','session_fig4col1');
session=session_fig4col1;
n_animals=20;
x_chop=216;

%bin data
bin=hours(4);
all_t=cat(2,session.Etimes);
cat_t=[];

for i=1:size(all_t,2)
    cat_t=[cat_t all_t(i).Etimes];
end
cat_t=dateshift(cat_t, 'start', 'hour');
bins=[min(cat_t):bin:max(cat_t)];
for a=1:size(session,2)
    an_t=[];
    cat_Tdurs=[];
    cat_Etimes=[];
    for i=1:size(session(a).Etimes,2)
        an_t=[an_t session(a).Etimes(i).Etimes(1,1)];
        cat_Tdurs=[cat_Tdurs session(a).Tdurs(i).Tdurs];%continue from here, plot Tdurs for habi plot.
        cat_Etimes=[cat_Etimes session(a).Etimes(i).Etimes];%continue from here, plot Tdurs for habi plot.
    end
    for b=1:size(bins,2)-1
        inds=find(an_t>bins(b) & an_t<bins(b+1));
        binE=session(a).E(inds);
        if length(find(binE==1))==0 & length(find(binE>1))==0
            RD(a,b)=NaN;
        else
            RD(a,b)=length(find(binE==1))/(1+length(find(binE>1)));
        end
        if isempty(find(session(a).Bstart>bins(b) & session(a).Bstart<bins(b+1)))
            Bdur(b).Bdur(a).Bdur=NaN;
        else
            Bdur(b).Bdur(a).Bdur=session(a).Bdur(find(session(a).Bstart>bins(b) & session(a).Bstart<bins(b+1)),1);
        end
        Etimes(b).Etimes(a).Etimes=cat_Etimes(find(cat_Etimes>bins(b) & cat_Etimes<bins(b+1)));
        Tdurs(b).Tdurs(a).Tdurs=cat_Tdurs(find(cat_Etimes>bins(b) & cat_Etimes<bins(b+1)));
    end
end
%% 
clearvars zg
%zeitgeber time vector starts at 11am = ct+1 (lights on 10am)
zg=hours(1)+bin/2:bin:(size(bins,2)-1)*bin+bin/2; %plot on center of bins!
zg=zg+hours(12);%reversed light cycle.
% lightcycle_t=hours(1)+bin/2:bin:(size(bins,2)-1)*bin+bin/2;
% lightcycle=12:
figure;
RD(:,end-2:end)=[];zg(:,end-2:end)=[];
% ax(1)=subplot(5,2,2),plot(zg,RD,'o');grid on;hold on;alpha(.3);
ax(1)=subplot(5,2,1),fill([zg fliplr(zg)],[nanmean(RD,1)-nanstd(RD,1)/sqrt(n_animals-sum(isnan(RD),1)) fliplr(nanmean(RD,1)+nanstd(RD,1)/sqrt(n_animals-sum(isnan(RD),1)))],'black','FaceAlpha',0.3,'LineStyle','--');hold on;
ax(1)=subplot(5,2,1),plot(zg,nanmean(RD,1),'k-','Linewidth',3);
set(gca, 'YGrid', 'on', 'XGrid', 'off');
% title('Drive switching');
ylabel('singles/runs');
yticks([0:8]);
ylim([0 5]);
xticks(hours([0:12:(size(zg,2)+2)*hours(bin)]));
set(gca,'xtick',[]);

% for a=1:size(session,2)
%     subplot(5,2,4),plot(session(a).Bstart,session(a).Bdur,'o',"MarkerEdgeColor",[0 0 1/a]);hold on;
%     grid on;
%     ylim([0 hours(1)]);
%     for b=1:size(Etimes,2)
%         subplot(5,2,6),plot(Etimes(b).Etimes(a).Etimes,milliseconds(Tdurs(b).Tdurs(a).Tdurs),'s',"MarkerEdgeColor",[0 0 1/a]);hold on;
%         alpha(.3);
%     end
% end
% grid on;
% ylim([0 hours(1)]);

clear binned_Bdur mean_Bdur
for i=1:size(Bdur,2)
    binned_Bdur(i).Bdur=[];
    binned_Tdurs(i).Tdurs=[];
    for j=1:size(Bdur(i).Bdur,2)
        binned_Bdur(i).Bdur=[binned_Bdur(i).Bdur; Bdur(i).Bdur(j).Bdur]; 
        binned_Tdurs(i).Tdurs=[binned_Tdurs(i).Tdurs Tdurs(i).Tdurs(j).Tdurs];
    end
    if sum(isnan(binned_Bdur(i).Bdur))==n_animals
        mean_Bdur(i)=NaN;
        sd_Bdur(i)=NaN;
        mean_Bcount(i)=NaN;
    else
        mean_Bdur(i)=nanmean(binned_Bdur(i).Bdur);
        sd_Bdur(i)=nanstd(seconds(binned_Bdur(i).Bdur))/sqrt(n_animals-sum(isnan(binned_Bdur(i).Bdur)));
        mean_Bcount(i)=(length(binned_Bdur(i).Bdur)-sum(isnan(binned_Bdur(i).Bdur)))/(n_animals-sum(isnan(binned_Bdur(i).Bdur)));
    end
    if sum(isnan(binned_Bdur(i).Bdur))==n_animals
        mean_Tdur(i)=NaN;
        sd_Tdur(i)=NaN;
        mean_Tcount(i)=NaN;
    else
        mean_Tdur(i)=nanmean(binned_Tdurs(i).Tdurs);
        sd_Tdur(i)=nanstd(binned_Tdurs(i).Tdurs)/sqrt(n_animals-sum(isnan(binned_Bdur(i).Bdur)));
        mean_Tcount(i)=length(binned_Tdurs(i).Tdurs)/(n_animals-sum(isnan(binned_Bdur(i).Bdur)));
    end
end
mean_Bdur(:,end-2:end)=[];sd_Bdur(:,end-2:end)=[];
ax(3)=subplot(5,2,3),fill([zg fliplr(zg)],[mean_Bdur-seconds(sd_Bdur) fliplr(mean_Bdur+seconds(sd_Bdur))],'black','FaceAlpha',0.3,'LineStyle','--');hold on;
ax(3)=subplot(5,2,3),plot(zg,mean_Bdur,'k-','Linewidth',3);
set(gca, 'YGrid', 'on', 'XGrid', 'off');
% title('Block duration');
ylabel('min/block');
ylim(minutes([0 20]));
yticks(minutes([0:5:20]));
yticklabels({'0','5','10','15','20'});
xticks(hours([0:12:(size(zg,2)+2)*hours(bin)]));
set(gca,'xtick',[]);

mean_Tdur(:,end-2:end)=[];sd_Tdur(:,end-2:end)=[];
ax(4)=subplot(5,2,5),fill([zg fliplr(zg)],[milliseconds(mean_Tdur)-milliseconds(sd_Tdur) fliplr(milliseconds(mean_Tdur)+milliseconds(sd_Tdur))],'black','FaceAlpha',0.3,'LineStyle','--');hold on;
ax(4)=subplot(5,2,5),plot(zg,milliseconds(mean_Tdur),'k-','Linewidth',3);
set(gca, 'YGrid', 'on', 'XGrid', 'off');
% title('Trial duration');
ylabel('s/trial');
ylim(seconds([0 80]));
xticks(hours([0:12:(size(zg,2)+2)*hours(bin)]));
set(gca,'xtick',[]);

clear binned_Bdur mean_Bdur
bin=hours(4);
bins=[min(cat_t):bin:max(cat_t)];
zg=hours(1)+bin/2:bin:(size(bins,2)-1)*bin+bin/2; %plot on center of bins!
zg=zg+hours(12);
for a=1:size(session,2)
    an_t=[];
    cat_Tdurs=[];
    cat_Etimes=[];
    for i=1:size(session(a).Etimes,2)
        an_t=[an_t session(a).Etimes(i).Etimes(1,1)];
        cat_Tdurs=[cat_Tdurs session(a).Tdurs(i).Tdurs];%continue from here, plot Tdurs for habi plot.
        cat_Etimes=[cat_Etimes session(a).Etimes(i).Etimes];%continue from here, plot Tdurs for habi plot.
    end
    for b=1:size(bins,2)-1
        inds=find(an_t>bins(b) & an_t<bins(b+1));
        binE=session(a).E(inds);
        if length(find(binE==1))==0 & length(find(binE>1))==0
            RD(a,b)=NaN;
        else
            RD(a,b)=length(find(binE==1))/(1+length(find(binE>1)));
        end
        if isempty(find(session(a).Bstart>bins(b) & session(a).Bstart<bins(b+1)))
            Bdur(b).Bdur(a).Bdur=NaN;
        else
            Bdur(b).Bdur(a).Bdur=session(a).Bdur(find(session(a).Bstart>bins(b) & session(a).Bstart<bins(b+1)),1);
        end
        Etimes(b).Etimes(a).Etimes=cat_Etimes(find(cat_Etimes>bins(b) & cat_Etimes<bins(b+1)));
        Tdurs(b).Tdurs(a).Tdurs=cat_Tdurs(find(cat_Etimes>bins(b) & cat_Etimes<bins(b+1)));
    end
end
for i=1:size(Bdur,2)
    binned_Bdur(i).Bdur=[];
    binned_Tdurs(i).Tdurs=[];    
    for j=1:size(Bdur(i).Bdur,2)
        binned_Bdur(i).Bdur=[binned_Bdur(i).Bdur; Bdur(i).Bdur(j).Bdur]; 
        animal_Bcounts(j)=length(Bdur(i).Bdur(j).Bdur(~isnan(Bdur(i).Bdur(j).Bdur)));        
        if isempty(Tdurs(i).Tdurs(j).Tdurs)
            binned_Tdurs(i).Tdurs=[binned_Tdurs(i).Tdurs NaN];
            animal_Tcounts(j)=NaN;
        else
            binned_Tdurs(i).Tdurs=[binned_Tdurs(i).Tdurs Tdurs(i).Tdurs(j).Tdurs];
            animal_Tcounts(j)=length(Tdurs(i).Tdurs(j).Tdurs);
        end
    end
    binned_Bdur(i).Bcount=animal_Bcounts;
    binned_Tdurs(i).Tcount=animal_Tcounts;
    if sum(isnan(binned_Bdur(i).Bdur))==n_animals
        mean_Bdur(i)=NaN;
        sd_Bdur(i)=NaN;
        mean_Bcount(i)=NaN;
    else
        mean_Bdur(i)=nanmean(binned_Bdur(i).Bdur);
        sd_Bdur(i)=nanstd(seconds(binned_Bdur(i).Bdur));
        mean_Bcount(i)=nanmean(binned_Bdur(i).Bcount);
        sd_Bcount(i)=nanstd(binned_Bdur(i).Bcount);
    end
    if sum(isnan(binned_Tdurs(i).Tdurs))==n_animals
        mean_Tdur(i)=NaN;
        sd_Tdur(i)=NaN;
        mean_Tcount(i)=NaN;
    else
        mean_Tdur(i)=nanmean(binned_Tdurs(i).Tdurs);
        sd_Tdur(i)=nanstd(binned_Tdurs(i).Tdurs);
        mean_Tcount(i)=nanmean(binned_Tdurs(i).Tcount);
        sd_Tcount(i)=nanstd(binned_Tdurs(i).Tcount);
    end
end
mean_Tcount(find(isnan(mean_Tcount)))=mean([mean_Tcount(find(isnan(mean_Tcount))-1) mean_Tcount(find(isnan(mean_Tcount))+1)]);
mean_Bcount(find(isnan(mean_Bcount)))=mean([mean_Bcount(find(isnan(mean_Bcount))-1) mean_Bcount(find(isnan(mean_Bcount))+1)]);
ax(5)=subplot(5,2,7),fill([zg fliplr(zg)],[mean_Bcount-sd_Bcount fliplr(mean_Bcount+sd_Bcount)],'black','FaceAlpha',0.3,'LineStyle','--');hold on;
ax(5)=subplot(5,2,7),plot(zg,mean_Bcount,'k-','Linewidth',3);
set(gca,'xtick',[]);
ylabel('blocks');
set(gca, 'YGrid', 'on', 'XGrid', 'off');

ax(6)=subplot(5,2,9),fill([zg fliplr(zg)],[mean_Tcount-sd_Tcount fliplr(mean_Tcount+sd_Tcount)],'black','FaceAlpha',0.3,'LineStyle','--');hold on;
ax(6)=subplot(5,2,9),plot(zg,mean_Tcount,'k-','Linewidth',3);

set(gca, 'YGrid', 'on', 'XGrid', 'off');
% title('entries and trials');
ylabel('trials');
% ylim(seconds([0 100]));
xticks(hours([0:12:(size(zg,2)+2)*hours(bin)]));
% legend('blocks','trials*10');
linkaxes(ax,'x');
xlim(hours([12 x_chop]));

%% environmental challenges
clear all; %close all
load('SM_Hartmann2023_biorxiv_data.mat','session_fig4cols23_fig5');
n_animals=22;
x_chop=52;
%% 
f1=figure;
f2=figure;
f3=figure;
f4=figure;
for exp=1:3 
    clearvars -except session_fig4cols23_fig5 exp n_animals x_chop f1 f2 f3 f4
    % clearvars all_t T cat_t RD bins Bdur Tdur Ttype
    session=session_fig4cols23_fig5(exp).session;
    BINNED=session_fig4cols23_fig5(exp).binned;
    BINNED_EXP=session_fig4cols23_fig5(exp).binned_exp;
        
    
    %correction to remove ends as events
    for an=1:size(session,2)
        list(an).list=[];
        list(an).feeding_length=[];
        for i=1:size(session(an).Etypes,2)
            t=categorical(session(an).Etypes(i).Etypes(1)); 
            if t=='FE' | t=='DE' | t=='EE'
                list(an).list=[list(an).list i];
            end
        end
        session(an).E(list(an).list)=[];
        session(an).Etimes(list(an).list)=[];
        session(an).Edurs(list(an).list)=[];
        session(an).Tdurs(list(an).list)=[];
        session(an).Etypes(list(an).list)=[];
    end
    %bin data
    bin=minutes(30);
    win=hours(4); %for rolling window
    all_t=cat(2,session.Etimes);
    cat_t=[];

    for i=1:size(all_t,2)
        cat_t=[cat_t all_t(i).Etimes];
    end
    cat_t=dateshift(cat_t, 'start', 'hour');
    bins=[min(cat_t):bin:max(cat_t)];
    for a=1:size(session,2)
        an_t=[];
        cat_Tdurs=[];
        cat_Etimes=[];
        cat_Etypes=[];
        for i=1:size(session(a).Etimes,2)
            an_t=[an_t session(a).Etimes(i).Etimes(1,1)]; %only for runs!
            cat_Tdurs=[cat_Tdurs session(a).Tdurs(i).Tdurs];
            cat_Etimes=[cat_Etimes session(a).Etimes(i).Etimes];
            cat_Etypes=[cat_Etypes session(a).Etypes(i).Etypes];    
        end
        for b=1:size(bins,2)-1
            inds_rd=find(an_t>bins(b)-win/2 & an_t<bins(b)+win/2);
            binE=session(a).E(inds_rd);
            if length(find(binE==1))==0 & length(find(binE>1))==0
                RD(a,b)=NaN;
            else
                RD(a,b)=length(find(binE==1))/(1+length(find(binE>1)));
            end
            if isempty(find(session(a).Bstart>bins(b)-win/2 & session(a).Bstart<bins(b)+win/2))
                Bdur(b).Bdur(a).Bdur=NaN;
            else
                Bdur(b).Bdur(a).Bdur=session(a).Bdur(find(session(a).Bstart>bins(b)-win/2 & session(a).Bstart<bins(b)+win/2),1);
            end
            Etimes(b).Etimes(a).Etimes=cat_Etimes(find(cat_Etimes>bins(b)-win/2 & cat_Etimes<bins(b)+win/2));
            Tdurs(b).Tdurs(a).Tdurs=cat_Tdurs(find(cat_Etimes>bins(b)-win/2 & cat_Etimes<bins(b)+win/2));
        end
        
        %analysis window metrics for bar plot
        for aw=1:2
            if aw==1
                inds_rd=find(an_t>datetime(date)+hours(16) & an_t<datetime(date)+hours(22));%runs
                inds=find(cat_Etimes>datetime(date)+hours(16) & cat_Etimes<datetime(date)+hours(22));%trials
                inds_b=find(session(a).Bstart>datetime(date)+hours(16) & session(a).Bstart<datetime(date)+hours(22));%blocks
            elseif aw==2
                inds_rd=find(an_t>datetime(date)+hours(16+24) & an_t<datetime(date)+hours(22+24));
                inds=find(cat_Etimes>datetime(date)+hours(16+24) & cat_Etimes<datetime(date)+hours(22+24));
                inds_b=find(session(a).Bstart>datetime(date)+hours(16+24) & session(a).Bstart<datetime(date)+hours(22+24));
            end
            
            binE=session(a).E(inds_rd);
            if length(find(binE==1))==0 & length(find(binE>1))==0
                RD_aw(a,aw)=NaN;
            else
                RD_aw(a,aw)=length(find(binE==1))/(1+length(find(binE>1)));
            end
            Bdur_aw(a,aw)=mean(session(a).Bdur(inds_b));
            Tdurs_aw(a,aw)= mean(cat_Tdurs(inds));
            Trials_aw(a,aw)= length(cat_Tdurs(inds));
            Blocks_aw(a,aw)=length(session(a).Bdur(inds_b));
        end

%         session=SESSION; %reload because edited out toE transitions!
        %extract Etype stats for analysis windows last 6h of light cycle 
        inds=find(cat_Etimes>datetime(date)+hours(16) & cat_Etimes<datetime(date)+hours(22)); %lights 10am-10pm
    %         aw1=[bins(find(bins) bins(23)];
    %         inds=find(cat_Etimes>aw1(1) & cat_Etimes<aw1(2));
        Etypes_aw1=categorical(cat_Etypes(inds));
        Etypes(a).aw1=[
            length(find(Etypes_aw1=='FE')) length(find(Etypes_aw1=='FD')) length(find(Etypes_aw1=='FF'));
            length(find(Etypes_aw1=='DE')) length(find(Etypes_aw1=='DD')) length(find(Etypes_aw1=='DF'));
            length(find(Etypes_aw1=='EE')) length(find(Etypes_aw1=='ED')) length(find(Etypes_aw1=='EF'))];
        F_entries_aw1(a)=sum(Etypes(a).aw1(:,3));


        inds=find(cat_Etimes>datetime(date)+hours(16+24) & cat_Etimes<datetime(date)+hours(22+24)); %lights 10am-10pm
        Etypes_aw2=categorical(cat_Etypes(inds));
        Etypes(a).aw2=[
            length(find(Etypes_aw2=='FE')) length(find(Etypes_aw2=='FD')) length(find(Etypes_aw2=='FF'));
            length(find(Etypes_aw2=='DE')) length(find(Etypes_aw2=='DD')) length(find(Etypes_aw2=='DF'));
            length(find(Etypes_aw2=='EE')) length(find(Etypes_aw2=='ED')) length(find(Etypes_aw2=='EF'))];
        F_entries_aw2(a)=sum(Etypes(a).aw2(:,3));

        %pellets during a 24h
        pellets_24(a)=sum(BINNED(a).pellets(5:28));
        drops_t24(a)=sum(BINNED(a).drops(5:28));
        food_t24(a)=sum(BINNED(a).food_trials(5:28));
        water_t24(a)=sum(BINNED(a).water_trials(5:28));
        wheel_t24(a)=sum(BINNED(a).wheel_use_trials(5:28));
        revolutions_t24(a)=sum(BINNED(a).wheel_revs(5:28));
    end    
    %% 
    clearvars zg
    %zeitgeber time vector starts at 11am = ct+1 (lights on 10am)
    zg=hours(1)+bin/2:bin:(size(bins,2)-1)*bin+bin/2; %plot on center of bins!
    zg=zg+hours(12);%reversed light cycle.
    figure(f1);
    RD(:,end-3:end)=[];zg(:,end-2:end)=[];
    if exp==1    
        ax(3)=subplot(5,2,1),plot(zg,nanmean(RD,1),'k','LineWidth',3);hold on;
    elseif exp==2
        ax(3)=subplot(5,2,1),plot(zg,nanmean(RD,1),'b','LineWidth',2.5);hold on;
    elseif exp==3
        ax(3)=subplot(5,2,1),plot(zg,nanmean(RD,1),'r','LineWidth',2);hold on;
    end
    set(gca, 'YGrid', 'on', 'XGrid', 'off');
%     title('Drive switching');
    ylabel('singles/runs');
    yticks([1:3]);
    ylim([0.8 3.5]);
    xticks(hours([0:12:(size(zg,2)+2)*hours(bin)]));
    set(gca,'xtick',[]);
    xlim(hours([17 x_chop]));

    clear binned_Bdur mean_Bdur
    for i=1:size(Bdur,2)
        binned_Bdur(i).Bdur=[];
        binned_Tdurs(i).Tdurs=[];
        for j=1:size(Bdur(i).Bdur,2)
            binned_Bdur(i).Bdur=[binned_Bdur(i).Bdur; Bdur(i).Bdur(j).Bdur]; 
            binned_Tdurs(i).Tdurs=[binned_Tdurs(i).Tdurs Tdurs(i).Tdurs(j).Tdurs];
        end
        if sum(isnan(binned_Bdur(i).Bdur))==n_animals
            mean_Bdur(i)=NaN;
            sd_Bdur(i)=NaN;
            mean_Bcount(i)=NaN;
        else
            mean_Bdur(i)=nanmean(binned_Bdur(i).Bdur);
            sd_Bdur(i)=nanstd(seconds(binned_Bdur(i).Bdur))/sqrt(n_animals-sum(isnan(binned_Bdur(i).Bdur)));
            mean_Bcount(i)=(length(binned_Bdur(i).Bdur)-sum(isnan(binned_Bdur(i).Bdur)))/(n_animals-sum(isnan(binned_Bdur(i).Bdur)));
        end
        if sum(isnan(binned_Bdur(i).Bdur))==n_animals
            mean_Tdur(i)=NaN;
            sd_Tdur(i)=NaN;
            mean_Tcount(i)=NaN;
        else
            mean_Tdur(i)=nanmean(binned_Tdurs(i).Tdurs);
            sd_Tdur(i)=nanstd(binned_Tdurs(i).Tdurs)/sqrt(n_animals-sum(isnan(binned_Bdur(i).Bdur)));
            mean_Tcount(i)=length(binned_Tdurs(i).Tdurs)/(n_animals-sum(isnan(binned_Bdur(i).Bdur)));
        end
    end
    mean_Bdur(:,end-3:end)=[];sd_Bdur(:,end-3:end)=[];
    if exp==1    
        ax(3)=subplot(5,2,3),plot(zg,mean_Bdur,'k','LineWidth',3);hold on;
    elseif exp==2
        ax(3)=subplot(5,2,3),plot(zg,mean_Bdur,'b','LineWidth',2.5);hold on;
    elseif exp==3
        ax(3)=subplot(5,2,3),plot(zg,mean_Bdur,'r','LineWidth',2);hold on;
    end
    set(gca, 'YGrid', 'on', 'XGrid', 'off');
    %title('Block duration');
    ylabel('min/block');
    ylim(minutes([3 8]));
    yticks(minutes([3:8]));
    yticklabels({'3','4','5','6','7','8'});
    xticks(hours([0:12:(size(zg,2)+2)*hours(bin)]));
    set(gca,'xtick',[]);
    xlim(hours([17 x_chop]));
    mean_Tdur(:,end-3:end)=[];sd_Tdur(:,end-3:end)=[]; 
    if exp==1    
        ax(4)=subplot(5,2,5),plot(zg,mean_Tdur/1000,'k','LineWidth',3);hold on;
    elseif exp==2
        ax(4)=subplot(5,2,5),plot(zg,mean_Tdur/1000,'b','LineWidth',2.5);hold on;
    elseif exp==3
        ax(4)=subplot(5,2,5),plot(zg,mean_Tdur/1000,'r','LineWidth',2);hold on;
    end
    set(gca, 'YGrid', 'on', 'XGrid', 'off');
    %title('Trial duration');
    ylabel('s/trial');
    legend('ctrl','FD-RF','swap goals');
    ylim(([10 45]));
    yticks([10:10:40]);
    xticks(hours([0:12:(size(zg,2)+2)*hours(bin)]));
    set(gca,'xtick',[]);
    xlim(hours([15 x_chop]));
    clear binned_Bdur mean_Bdur
    bin=minutes(30);
    bins=[min(cat_t):bin:max(cat_t)];
    zg=hours(1)+bin/2:bin:(size(bins,2)-1)*bin+bin/2; %plot on center of bins!
    zg=zg+hours(12);
    for a=1:size(session,2)
        an_t=[];
        cat_Tdurs=[];
        cat_Etimes=[];
        for i=1:size(session(a).Etimes,2)
            an_t=[an_t session(a).Etimes(i).Etimes(1,1)];
            cat_Tdurs=[cat_Tdurs session(a).Tdurs(i).Tdurs];
            cat_Etimes=[cat_Etimes session(a).Etimes(i).Etimes];
        end
        for b=1:size(bins,2)-1
            inds=find(an_t>bins(b)-win/2 & an_t<bins(b)+win/2);
            binE=session(a).E(inds);
            if length(find(binE==1))==0 & length(find(binE>1))==0
                RD(a,b)=NaN;
            else
                RD(a,b)=length(find(binE==1))/(1+length(find(binE>1)));
            end
            if isempty(find(session(a).Bstart>bins(b)-win/2 & session(a).Bstart<bins(b)+win/2))
                Bdur(b).Bdur(a).Bdur=NaN;
            else
                Bdur(b).Bdur(a).Bdur=session(a).Bdur(find(session(a).Bstart>bins(b)-win/2 & session(a).Bstart<bins(b)+win/2),1);
            end
            Etimes(b).Etimes(a).Etimes=cat_Etimes(find(cat_Etimes>bins(b)-win/2 & cat_Etimes<bins(b)+win/2));
            Tdurs(b).Tdurs(a).Tdurs=cat_Tdurs(find(cat_Etimes>bins(b)-win/2 & cat_Etimes<bins(b)+win/2));
        end
    end
    for i=1:size(Bdur,2)
        binned_Bdur(i).Bdur=[];
        binned_Tdurs(i).Tdurs=[];
        for j=1:size(Bdur(i).Bdur,2)
            binned_Bdur(i).Bdur=[binned_Bdur(i).Bdur; Bdur(i).Bdur(j).Bdur]; 
            if isempty(Tdurs(i).Tdurs(j).Tdurs)
                binned_Tdurs(i).Tdurs=[binned_Tdurs(i).Tdurs NaN];
            else
                binned_Tdurs(i).Tdurs=[binned_Tdurs(i).Tdurs Tdurs(i).Tdurs(j).Tdurs];
            end
        end
        if sum(isnan(binned_Bdur(i).Bdur))==n_animals
            mean_Bdur(i)=NaN;
            sd_Bdur(i)=NaN;
            mean_Bcount(i)=NaN;
        else
            mean_Bdur(i)=nanmean(binned_Bdur(i).Bdur);
            sd_Bdur(i)=nanstd(seconds(binned_Bdur(i).Bdur));
            mean_Bcount(i)=(length(binned_Bdur(i).Bdur)-sum(isnan(binned_Bdur(i).Bdur)))/(n_animals-sum(isnan(binned_Bdur(i).Bdur)));
        end
        if sum(isnan(binned_Tdurs(i).Tdurs))==n_animals
            mean_Tdur(i)=NaN;
            sd_Tdur(i)=NaN;
            mean_Tcount(i)=NaN;
        else
            mean_Tdur(i)=nanmean(binned_Tdurs(i).Tdurs);
            sd_Tdur(i)=nanstd(binned_Tdurs(i).Tdurs);
            mean_Tcount(i)=length(binned_Tdurs(i).Tdurs)/(n_animals-sum(isnan(binned_Tdurs(i).Tdurs)));
        end
    end

    
    if exp==1    
        ax(5)=subplot(5,2,7),plot(zg(1:100),mean_Bcount(1:100),'k','LineWidth',3);hold on;
        ax(6)=subplot(5,2,9),plot(zg(1:100),mean_Tcount(1:100),'k','LineWidth',3);hold on;
    elseif exp==2
        ax(5)=subplot(5,2,7),plot(zg(1:100),mean_Bcount(1:100),'b','LineWidth',2.5);hold on;
        ax(6)=subplot(5,2,9),plot(zg(1:100),mean_Tcount(1:100),'b','LineWidth',2.5);hold on;
    elseif exp==3
        ax(5)=subplot(5,2,7),plot(zg(1:100),mean_Bcount(1:100),'r','LineWidth',2);hold on;
            set(gca, 'YGrid', 'on', 'XGrid', 'off');
            %title('blocks');
            ylabel('blocks');
            ylim(([0 12]));
            xticks(hours([0:hours(bin):(size(zg,2)+2)*hours(bin)]));
            set(gca,'xtick',[]);
        ax(6)=subplot(5,2,9),plot(zg(1:100),mean_Tcount(1:100),'r','LineWidth',2);hold on;
            set(gca, 'YGrid', 'on', 'XGrid', 'off');
            %title('trials');
            ylabel('trials');
            ylim(([0 150]));
            xticks(hours([0:4:(size(zg,2)+2)*hours(bin)]));
            
    end
    linkaxes(ax,'x');
    xlim(hours([17 x_chop]));
    
%     %add a bar plot of windows showing change only in switching in swap
    for d=1:5
        if d==1
            n=2; %plot number
            data=RD_aw;
        elseif d==2
            n=4;
            data=minutes(Bdur_aw);
        elseif d==3
            n=6;
            data=Tdurs_aw;
        elseif d==4
            n=8;
            data=Blocks_aw;
        elseif d==5
            n=10;
            data=Trials_aw;    
        end
        mat2=mean(data,1);
        eb=std(data,0,1);
        if exp==1
            X=[1,2];
            subplot(5,2,n),bar(X,mat2,0.8,'k');hold on;
            errorbar(X,mat2,eb,'k+');
            plot([X(1)+0.1 X(2)-0.1],data,'Color',[0 0 0 0.3]);
            set(gca,'xtick',[]);
            [H2(exp,d) P2(exp,d)]=ttest(data(:,1),data(:,2));
        elseif exp==2
            X=[4,5];
            subplot(5,2,n),bar(X,mat2,0.8,'b');hold on;
            errorbar(X,mat2,eb,'k+');
            plot([X(1)+0.1 X(2)-0.1],data,'Color',[0 0 0 0.3]);
            set(gca,'xtick',[]);
            [H2(exp,d) P2(exp,d)]=ttest(data(:,1),data(:,2));
        elseif exp==3
            X=[7,8];
            subplot(5,2,n),bar(X,mat2,0.8,'r');hold on;
            errorbar(X,mat2,eb,'k+');
            plot([X(1)+0.1 X(2)-0.1],data,'Color',[0 0 0 0.3]);
            set(gca,'xtick',[]);
            [H2(exp,d) P2(exp,d)]=ttest(data(:,1),data(:,2));
        end
    end
 
    xlabel('groups');
    xticks([1 2 4 5 7 8]);set(gca, 'TickDir', 'out');
    xticklabels({'bsl','ctrl','FD','RF','bsl','SWAP'});   
    xlim([0 9]);
    
    
    'window stats for exp'
    exp
    mean_food_entries_aw1=mean(F_entries_aw1)
    sd_food_entries_aw1=std(F_entries_aw1,0,2)
    mean_food_entries_aw2=mean(F_entries_aw2)
    sd_food_entries_aw2=std(F_entries_aw2,0,2)
    [hyp pval]=ttest(F_entries_aw1,F_entries_aw2)
end
'24h stats'
mean_pellets=mean(pellets_24)
sd_pellets=std(pellets_24,0,2)
mean_pellet_retrieval=mean(pellets_24./food_t24)
sd_pellet_retrieval=std(pellets_24./food_t24,0,2)
mean_drops=mean(drops_t24)
sd_drops=std(drops_t24,0,2)
mean_drop_retrieval=mean(drops_t24./water_t24)
sd_drop_retrieval=std(drops_t24./water_t24,0,2)
mean_wheel=mean(wheel_t24)
sd_wheel=std(wheel_t24,0,2)
mean_wheel_use=mean(wheel_t24./water_t24)
sd_wheel_use=std(wheel_t24./water_t24,0,2)
mean_revs=mean(revolutions_t24)
sd_revs=std(revolutions_t24,0,2)
mean_food_entries=mean(food_t24)
sd_food_entries=std(food_t24,0,2)
mean_water_entries=mean(water_t24)
sd_water_entries=std(water_t24,0,2)