fishGrowth = @(x, r, K, h) r*x*(K - x) - h;
fishPriceFun = @(a, b, h) a - b.*h;
netProfitFun = @(q, h, C) (q*h')' - C;
harvestFun = @(x, gamma, C) (x.*gamma).*C;
adaptationSpeed = @(C, Cl) 0.001.*C.*(Cl - C);


K = 1000;
r = 200/K^2;
initialFish = 500;
fishTypes = 2;
fishers = 6;
initialPrice = [1 2];
priceElasticity = [0.001/2 0.001];
technicalCatchEfficiency = ones(fishers, 1)*[0.004 0.006];
initialPriorities = ones(fishers, fishTypes)*0.5;
initialAvailableCapital = ones(fishers, 1)*100;
initialInvestment = ones(fishers, 1)*10;
maximumInvestment = ones(fishers, 1)*50;
investment = zeros(fishers, fishTypes);
for i = 1:fishers
  investment(i, :) = initialPriorities(i, :).*initialInvestment(i);
end
fish = initialFish*ones(1, fishTypes);
priorities = initialPriorities;
totalInvestment = initialInvestment;
iterations = 1000;
fishOverTime = zeros(fishTypes, iterations);

for i = 1:iterations
  fishOverTime(:, i) = fish;
  harvest = zeros(fishers, fishTypes);
  for f = 1:fishTypes 
    harvest(:, f) = harvestFun(fish(f), technicalCatchEfficiency(:, f), investment(:, f));
  end
  totalHarvest = sum(harvest);
  fishPrice = fishPriceFun(initialPrice, priceElasticity, totalHarvest);
  netProfit = netProfitFun(fishPrice, harvest, totalInvestment);
  
  totalInvestment = totalInvestment + (technicalCatchEfficiency*(fishPrice.*fish)' - 1).*adaptationSpeed(totalInvestment, maximumInvestment);
  for f = 1:fishers
   if (harvest(f, 1)*fishPrice(1)/priorities(f, 1) > harvest(f, 2)*fishPrice(2)/priorities(f, 2) && priorities(f, 1) < 1)
     priorities(f, :) = [priorities(f, 1) + 0.01, priorities(f, 2) - 0.01];
   elseif (priorities(f, 2) < 1)
     priorities(f, :) = [priorities(f, 1) - 0.01, priorities(f, 2) + 0.01];
   end
  end
  fish = fish + r.*fish.*(K - fish) - totalHarvest;
end
plot(1:1000, fishOverTime(1, :), 1:1000, fishOverTime(2, :))
legend('1', '2')