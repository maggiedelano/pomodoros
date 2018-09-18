%% load data
load pomodoros.mat
load roadFill.mat

%%

%% fun facts

% total pomodoros
totalPomodoros = sum(maggiedpomodoroscategories.VALUE); % should be 4840

% average per day worked
sortByDate = sortrows(maggiedpomodoroscategories,2); % sort by DATE

dates = [];
pomoDay = [];

for j = 1:length(sortByDate.DAYSTAMP)
    
    % if j == 1, initialize variables
    if j == 1
        dateString = sortByDate.DAYSTAMP(1);
        dayIndex = 1;
        dates = [dateString];
        pomoDay(dayIndex) = sortByDate.VALUE(j);
    else
        if dateString == sortByDate.DAYSTAMP(j)
            pomoDay(dayIndex) = pomoDay(dayIndex) + sortByDate.VALUE(j);
        else
            dateString = sortByDate.DAYSTAMP(j);
            dayIndex = dayIndex + 1;
            dates(end+1) = dateString;
            pomoDay(dayIndex) = sortByDate.VALUE(j);
        end
    end
end

meanPomodoros = mean(pomoDay(pomoDay > 0));
stdPomodoros = std(pomoDay(pomoDay > 0));

%%
% day most worked and per day total

daysOfWeek = weekday(dates);
dayMean = [];
dayTotal = [];
dayN = [];
daySTD = [];

for j = 1:7
    dayTotal(j) = sum(pomoDay(daysOfWeek == j));
    dayMean(j) = dayTotal(j) / sum(daysOfWeek == j);
    dayN(j) = sum(daysOfWeek == j); 
    
    alldays = pomoDay(daysOfWeek == j);
    daySTD(j) = std(alldays(alldays > 0));
    
end

%% 
% category totals

sortByCategory = sortrows(maggiedpomodoroscategories,8);
categories = [];
pomoCategory = [];

for j = 1:length(sortByCategory.CATEGORY)
    
    % if j == 1, initialize variables
    if j == 1
        catString = sortByCategory.CATEGORY(j);
        catIndex = 1;
        categories = catString;
        pomoCategory(catIndex) = sortByCategory.VALUE(j);
    else
        if catString == sortByCategory.CATEGORY(j)
            pomoCategory(catIndex) = pomoCategory(catIndex) + sortByCategory.VALUE(j);
        else
            catString = sortByCategory.CATEGORY(j);
            catIndex = catIndex + 1;
            categories(end+1) = catString;
            pomoCategory(catIndex) = sortByCategory.VALUE(j);
        end
    end
end
    
%% plot categories
%h = pie(pomoCategory,categoriesN);
%set(findobj(h,'type','text'),'fontsize',18);
% need to update the names of the categories

%% pomodoros on thesis
thesisPomos = sum(maggiedpomodoroscategories.VALUE(maggiedpomodoroscategories.SUBCATEGORY == 'Thesis')); % 363

%% plot over time

% very granular, try organizing by week
weeks = datetime('05/19/2013'):calweeks(1):datetime('01/21/2018');

weekPomos = zeros(1,length(weeks));

for j = 1:length(sortByDate.DAYSTAMP)
   
    if j == 1
        %weekString = 
        weekIndex = 1;
        weekPomos(weekIndex) = sortByDate.VALUE(j);
    else

        if j == 1064
            test = 0;
        end
        
        if (days(sortByDate.DAYSTAMP(j) - weeks(weekIndex)) < 7)
            weekPomos(weekIndex) = weekPomos(weekIndex) + sortByDate.VALUE(j);
        else
            while ((sortByDate.DAYSTAMP(j) - weeks(weekIndex)) >= 7)
                weekIndex = weekIndex + 1;
            end
            weekPomos(weekIndex) = sortByDate.VALUE(j);
        end
    end
        
end

%%
weekPomoSTD = std(weekPomos(weekPomos > 0));

bar(weeks,weekPomos)
set(gca,'FontSize',24);
xlabel('Date');
ylabel('Number of Pomodoros');
averagePomosPerWeek = mean(weekPomos(weekPomos > 0));
hold on
line([weeks(1) weeks(end)],[averagePomosPerWeek averagePomosPerWeek],'Color','black','LineStyle','-','LineWidth',4)
line([weeks(1) weeks(end)],[averagePomosPerWeek+weekPomoSTD averagePomosPerWeek+weekPomoSTD],'Color','black','LineStyle','--','LineWidth',4)
line([weeks(1) weeks(end)],[averagePomosPerWeek+weekPomoSTD*2 averagePomosPerWeek+weekPomoSTD*2],'Color','black','LineStyle','-.','LineWidth',4)
xlimits = xlim;
stairs(road1Fill.EndDate(1:end-1),road1Fill.Rate(2:end),'Color','black','LineWidth',1)
xlim(xlimits);
title('Number of Pomodoros Per Week','FontSize',36)
hold off

%%
weekPomoSTD = std(weekPomos(weekPomos > 0));
slidingMean4 = slidingavg(weekPomos,4);
slidingMean8 = slidingavg(weekPomos,40);

bar(weeks,weekPomos)
set(gca,'FontSize',24);
xlabel('Date');
ylabel('Number of Pomodoros');
averagePomosPerWeek = mean(weekPomos(weekPomos > 0));
hold on
%plot(weeks,slidingMean4,'LineWidth',8);
%plot(weeks,slidingMean8,'LineWidth',8);
%line([weeks(1) weeks(end)],[averagePomosPerWeek averagePomosPerWeek],'Color','black','LineStyle','-','LineWidth',4)
%line([weeks(1) weeks(end)],[averagePomosPerWeek+weekPomoSTD averagePomosPerWeek+weekPomoSTD],'Color','black','LineStyle','--','LineWidth',4)
%line([weeks(1) weeks(end)],[averagePomosPerWeek+weekPomoSTD*2 averagePomosPerWeek+weekPomoSTD*2],'Color','black','LineStyle','-.','LineWidth',4)
xlimits = xlim;
%stairs(road1Fill.EndDate(1:end-1),road1Fill.Rate(2:end),'Color','black','LineWidth',1)
xlim(xlimits);
title('Number of Pomodoros Per Week','FontSize',36)
hold off

%% penalty

twoSTDPomos = weekPomos(weekPomos > averagePomosPerWeek+2*weekPomoSTD);
twoSTDPomosIndices = find(weekPomos > averagePomosPerWeek+2*weekPomoSTD);
twoSTDPomosIndicesAfter = twoSTDPomosIndices + ones(1,length(twoSTDPomosIndices));

oneSTDPomos = weekPomos(weekPomos < averagePomosPerWeek+2*weekPomoSTD & weekPomos > averagePomosPerWeek+weekPomoSTD);
oneSTDPomosIndices = find(weekPomos < averagePomosPerWeek+2*weekPomoSTD & weekPomos > averagePomosPerWeek+weekPomoSTD);
oneSTDPomosIndicesAfter = oneSTDPomosIndices + ones(1,length(oneSTDPomosIndices));

meanSTDPomos = weekPomos(weekPomos < averagePomosPerWeek+weekPomoSTD & weekPomos > averagePomosPerWeek);
meanSTDPomosIndices = find(weekPomos < averagePomosPerWeek+weekPomoSTD & weekPomos > averagePomosPerWeek);
meanSTDPomosIndicesAfter = meanSTDPomosIndices + ones(1,length(meanSTDPomosIndices));

twoSTDDifference = twoSTDPomos - weekPomos(twoSTDPomosIndicesAfter);
oneSTDDifference = oneSTDPomos - weekPomos(oneSTDPomosIndicesAfter);
meanSTDDifference = meanSTDPomos - weekPomos(meanSTDPomosIndicesAfter);

mean(twoSTDDifference)
mean(oneSTDDifference)
mean(meanSTDDifference)

percentError(mean(weekPomos(twoSTDPomosIndicesAfter)),mean(twoSTDPomos))
percentError(mean(weekPomos(oneSTDPomosIndicesAfter)),mean(oneSTDPomos))
percentError(mean(weekPomos(meanSTDPomosIndicesAfter)),mean(meanSTDPomos))

%% per day
colors = [0 0.4470 0.7410; 0.85 0.325 0.098; 0.9290 0.6940 0.1250; 0.4940 0.1840 0.5560; 0.4660 0.6740 0.1880; 0.3010 0.7450 0.9330; 0.6350 0.0780 0.1840];
dayStrings = {'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'};

ci = 0.95;
alpha = 1 - ci;
clear ci95

for j = 1:7
    T_multiplier = tinv(1-alpha/2, dayN(j)-1);
    ci95(j) = T_multiplier*daySTD(j)/dayN(j);
end

bar([dayMean(2:end) dayMean(1)],'FaceColor',colors(4,:))
hold on
errorbar(1:7,[dayMean(2:end) dayMean(1)],[daySTD(2:end) daySTD(1)],'LineStyle','none','Color','black','LineWidth',2)
set(gca,'FontSize',24)
set(gca,'XTickLabel',dayStrings)
ylabel('Mean Pomodoros');
xlabel('Day of Week');
title('Mean Pomodoros for Each Day of the Week','FontSize',36)
hold off;

%% total per day
%% per day
colors = [0 0.4470 0.7410; 0.85 0.325 0.098; 0.9290 0.6940 0.1250; 0.4940 0.1840 0.5560; 0.4660 0.6740 0.1880; 0.3010 0.7450 0.9330; 0.6350 0.0780 0.1840];
dayStrings = {'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'};

% ci = 0.95;
% alpha = 1 - ci;
% clear ci95
% 
% for j = 1:7
%     T_multiplier = tinv(1-alpha/2, dayN(j)-1);
%     ci95(j) = T_multiplier*daySTD(j)/dayN(j);
% end

bar([dayTotal(2:end) dayTotal(1)],'FaceColor',colors(1,:))
hold on
%errorbar(1:7,[dayMean(2:end) dayMean(1)],[daySTD(2:end) daySTD(1)],'LineStyle','none','Color','black','LineWidth',2)
set(gca,'FontSize',24)
set(gca,'XTickLabel',dayStrings)
ylabel('Total Pomodoros');
xlabel('Day of Week');
title('Total Pomodoros for Each Day of the Week','FontSize',36)
hold off;

%%
dayStrings = {'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'};

bar([dayTotal(2:end) dayTotal(1)])
hold on
set(gca,'FontSize',24)
set(gca,'XTickLabel',dayStrings)
ylabel('Total Pomodoros');
xlabel('Day of Week');
hold off

%% statistical difference between days

dayStrings = {'sunday','monday','tuesday','wednesday','thursday','friday','saturday'};

for j = 1:7
    daysStruct.(dayStrings{j}).pomos = pomoDay(weekday(dates) == j); 
end

for j = 1:7
    
    for k = 1:7
        [h,p] = ttest2(daysStruct.(dayStrings{j}).pomos,daysStruct.(dayStrings{k}).pomos);
        daysStruct.(dayStrings{j}).pVals(k) = p;
        daysStruct.(dayStrings{j}).h(k) = h;
    end
end


