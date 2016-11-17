function fishDistribution = InitializeFishDistribution(gridSize, initialFishNb)
% Creates a square matrix of size gridSize on which the initialFishNb fishes are distributed. 
% The value in each matrix position corresponds to the number of fish in that area

  fishDistribution = zeros(gridSize,gridSize);
  for i = 1:initialFishNb
    x = fix(rand*gridSize)+1;
    y = fix(rand*gridSize)+1;
    fishDistribution(x,y) = fishDistribution(x,y)+1;
  end
end
