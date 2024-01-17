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
    cat_feeding_length(exp).cfl=[];
    for a=1:size(session,2)
        an_t=[];
        cat_Tdurs=[];
        cat_Etimes=[];
        cat_Etypes=[];
        for i=1:size(session(a).Etimes,2)
            an_t=[an_t session(a).Etimes(i).Etimes(1,1)];
            cat_Tdurs=[cat_Tdurs session(a).Tdurs(i).Tdurs];%continue from here, plot Tdurs for habi plot.
            cat_Etimes=[cat_Etimes session(a).Etimes(i).Etimes];%continue from here, plot Tdurs for habi plot.
            cat_Etypes=[cat_Etypes session(a).Etypes(i).Etypes];      
        end 
        %extract Etype stats for analysis window
        Etypes_aw1=categorical(cat_Etypes);
        Etypes(a).aw1=[
            length(find(Etypes_aw1=='FE')) length(find(Etypes_aw1=='FD')) length(find(Etypes_aw1=='FF'));
            length(find(Etypes_aw1=='DE')) length(find(Etypes_aw1=='DD')) length(find(Etypes_aw1=='DF'));
            length(find(Etypes_aw1=='EE')) length(find(Etypes_aw1=='ED')) length(find(Etypes_aw1=='EF'))];
        % Etypes(a).aw1=Etypes(a).aw1/sum(sum(Etypes(a).aw1))*100; %percentage likelihoods
        if exp==1
            Etypes(a).aw2=Etypes(a).aw1;
        end
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
        legend('bsl','','C21');
        L = legend;
        L.AutoUpdate = 'off'; 
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
        
        percent_change_FF=100*mean((data1(7,:)-data2(7,:))./data1(7,:))
        percent_std_FF=100*std((data1(7,:)-data2(7,:))./data1(7,:),0,2)
        end
    figure(f4)
    load('SM_Hartmann2023_biorxiv_data.mat', 'cmap1');
    load('SM_Hartmann2023_biorxiv_data.mat', 'cmap2');
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