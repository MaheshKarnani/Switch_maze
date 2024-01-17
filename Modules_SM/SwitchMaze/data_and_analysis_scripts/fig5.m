%% environmental challenges transitions
clear all; close all
load('SM_Hartmann2023_biorxiv_data.mat');
n_animals=22;
x_chop=52;
f3=figure;
for exp=1:3 
    clearvars -except exp f1 f2 f3 f4 n_animals x_chop H P H2 P2 session_fig4cols23
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
     
    figure(f3);
    font=8;
    data1=cat(3,Etypes.aw1);
    data1=reshape(data1,[9,22]);
    mat1=mean(data1,2);
    eb=std(data1,0,2);
    X=[1,3,5,8,10,12,15,17,19];
    if exp==1 
        s=subplot(3,1,1),bar(X,mat1,0.4,'k','FaceAlpha',0.3);hold on;
        title('ctrl');
    elseif exp==2
        s=subplot(3,1,2),bar(X,mat1,0.4,'k','FaceAlpha',0.3);hold on;
        title('FD-RF');
    elseif exp==3
        s=subplot(3,1,3),bar(X,mat1,0.4,'k','FaceAlpha',0.3);hold on;
        title('SWAP');
    end
    h=errorbar(X,mat1,eb,'k+');
    set(s,'FontSize',font);
    data2=cat(3,Etypes.aw2);
    data2=reshape(data2,[9,22]);
    mat2=mean(data2,2);
    eb=std(data2,0,2);
    X=[1,3,5,8,10,12,15,17,19]+1;
    if exp==1
        s=subplot(3,1,1),bar(X,mat2,0.4,'w');hold on;
        legend('bsl','','ctrl');
        L = legend;
        L.AutoUpdate = 'off'; 
    elseif exp==2
        s=subplot(3,1,2),bar(X,mat2,0.4,'w');hold on;
        legend('bsl','','FD-RF');
        L = legend;
        L.AutoUpdate = 'off'; 
    elseif exp==3
        s=subplot(3,1,3),bar(X,mat2,0.4,'w');hold on;
        legend('bsl','','SWAP');
        L = legend;
        L.AutoUpdate = 'off'; 
    end
    h=errorbar(X,mat2,eb,'k+');
    X=[1,3,5,8,10,12,15,17,19]
    for n=1:9
        plot([X(n)+0.1 X(n)+0.9], [data1(n,:);data2(n,:)],'Color',[0 0 0 0.3]);
        [H(exp,n) P(exp,n)]=ttest(data1(n,:),data2(n,:));
    end
    ylim([0 150]);
    ylabel('count');
    xlabel('transition');
    xticks(sort([X-0.5 6.5 13.5 20.5],'ascend'));set(gca, 'TickDir', 'out');
    xticklabels({'Food','Drink','Home','','Food','Drink','Home','','Food','Drink','Home',''}); 
    xlim([0.5 21]);
    axlim = get(gca, 'XLim');                                           % Get ‘XLim’ Vector
    aylim = get(gca, 'YLim');                                           % Get ‘YLim’ Vector
    x_txt = min(axlim);      % Set ‘x’-Coordinate Of Text Object
    y_txt = min(aylim)-50;      % Set y Coordinate Of Text Object
    text(x_txt, y_txt, 'to Home');
    x_txt = min(axlim)+8;      % Set _x+-Coordinate Of Text Object
    y_txt = min(aylim)-50;      % Set y Coordinate Of Text Object
    text(x_txt, y_txt, 'to Drink')
    x_txt = min(axlim)+16;      % Set +x1-Coordinate Of Text Object
    y_txt = min(aylim)-50;      % Set y Coordinate Of Text Object
    text(x_txt, y_txt, 'to Food')
        
    % figure(f4) %transition matrices as heatmaps without individual data
    % load('SM_Hartmann2023_biorxiv_data.mat', 'cmap1');
    % load('SM_Hartmann2023_biorxiv_data.mat', 'cmap2');
    % clims1 = [0 70];
    % clims2 = [-35 35];
    % font=12;
    % mat1=mean(cat(3,Etypes.aw1),3);
    % if exp==1 
    %     axe(1)=subplot(3,3,1),imagesc(mat1,clims1);hold on;
    %     title('bsl');
    % elseif exp==2
    %     axe(1)=subplot(3,3,4),imagesc(mat1,clims1);hold on;
    %     title('food deprivation');    
    % elseif exp==3
    %     axe(1)=subplot(3,3,7),imagesc(mat1,clims1);hold on;
    %     title('bsl');   
    % end
    % colormap(axe(1),cmap1/255);
    % yticks([1:3]);xticks([1:3]);
    % ylabel('from');
    % xlabel('to');
    % yticklabels({'Food','Drink','Home'})
    % xticklabels({'Home','Drink','Food'})
    % colorbar;
    % 
    % mat2=mean(cat(3,Etypes.aw2),3);
    % if exp==1 
    %     axe(2)=subplot(3,3,2),imagesc(mat2,clims1);hold on;
    %     title('ctrl');
    % elseif exp==2
    %     axe(2)=subplot(3,3,5),imagesc(mat2,clims1);hold on;
    %     title('re-feeding');    
    % elseif exp==3
    %     axe(2)=subplot(3,3,8),imagesc(mat2,clims1);hold on;
    %     title('swap goals');   
    % end
    % colormap(axe(2),cmap1/255);
    % yticks([1:3]);xticks([1:3]);
    % ylabel('from');
    % xlabel('to');
    % yticklabels({'Food','Drink','Home'})
    % xticklabels({'Home','Drink','Food'})
    % colorbar;
    % 
    % mat_diff=cat(3,Etypes.aw2)-cat(3,Etypes.aw1);
    % mat3=mean(mat_diff,3);
    % if exp==1 
    %     axe(3)=subplot(3,3,3),imagesc(mat3,clims2);hold on;
    % elseif exp==2
    %     axe(3)=subplot(3,3,6),imagesc(mat3,clims2);hold on;   
    % elseif exp==3
    %     axe(3)=subplot(3,3,9),imagesc(mat3,clims2);hold on; 
    % end
    % colormap(axe(3),cmap2/255);
    % yticks([1:3]);xticks([1:3]);
    % ylabel('from');
    % xlabel('to');
    % yticklabels({'Food','Drink','Home'})
    % xticklabels({'Home','Drink','Food'})
    % title('difference');
    % colorbar;
    
   
end