%% load data
load pomodoros.mat

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

%%
% day most worked

daysOfWeek = weekday(dates);
dayMean = [];

for j = 1:7
    dayTotal = sum(pomoDay(daysOfWeek == j));
    dayMean(j) = dayTotal / sum(daysOfWeek == j);
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
h = pie(pomoCategory,cellstr(categories));
set(findobj(h,'type','text'),'fontsize',18);
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
line([weeks(1) weeks(end)],[averagePomosPerWeek averagePomosPerWeek],'Color','red','LineStyle','--')
line([weeks(1) weeks(end)],[averagePomosPerWeek+weekPomoSTD averagePomosPerWeek+weekPomoSTD],'Color','blue','LineStyle','--')
line([weeks(1) weeks(end)],[averagePomosPerWeek+weekPomoSTD*2 averagePomosPerWeek+weekPomoSTD*2],'Color','green','LineStyle','--')
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

