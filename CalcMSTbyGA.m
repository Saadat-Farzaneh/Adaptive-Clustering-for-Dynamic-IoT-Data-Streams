%{
    This fuction returns minimum spanning tree of the MRD graph. Finding
    minimum spanning tree of a graph is an optimization problem. The function
    use binary gentic algorithm to solve this optimization problem.
%} 
 
function MST=CalcMSTbyGA(MRD)
    %% Problem Definition
     
    n=size(MRD,1);
     
    nVar=n*(n-1)/2;      % Number of Decision Variables
     
    VarSize=[1 nVar];    % Decision Variables Matrix Size
     
    SumMRDW=sum(MRD(:)); % Sum of all MRD Elements
    %% GA Parameters
     
    MaxIt=500;             % Maximum Number of Iterations
     
    nPop=10;                % Population Size
     
    pc=0.8;                 % Crossover Percentage
    nc=2*round(pc*nPop/2);  % Number of Offsprings (Parnets)
    beta=8;                 % Selection Pressure
     
    pm=0.3;                 % Mutation Percentage
    nm=round(pm*nPop);      % Number of Mutants
     
    mu=0.1;                % Mutation Rate
     
    %% Initialization
     
    empty_individual.Position=[];
    empty_individual.Cost=[];
    empty_individual.NewGraph=[];
     
    pop=repmat(empty_individual,nPop,1);
     
    for i=1:nPop
        % Initialize Position
        pop(i).Position=randi([0 1],VarSize);
        % Evaluation
        [pop(i).Cost,pop(i).NewGraph]=CostFunction_MST(pop(i).Position,MRD);
    end
     
    % Sort Population
    Costs=[pop.Cost];
    [Costs, SortOrder]=sort(Costs);
    pop=pop(SortOrder);
     
    % Store Best Solution
    BestSol=pop(1);
    BestCost=BestSol.Cost;
     
    % Store Cost
    WorstCost=pop(end).Cost;
     
     
    %% Main Loop
     
    counter1=1;
    counter2=0;
     
    while true
        
        counter1=counter1+1;
        
        % Calculate Selection Probabilities
        P=exp(-beta*Costs/WorstCost);
        P=P/sum(P);
        
        % Crossover
        popc=repmat(empty_individual,nc/2,2);
        
        for k=1:nc/2
            
            % Select Parents Indices
            i1=RouletteWheelSelection(P);
            i2=RouletteWheelSelection(P);
     
            % Select Parents
            p1=pop(i1);
            p2=pop(i2);
            
            % Apply Crossover
            [popc(k,1).Position, popc(k,2).Position]=...
                Crossover(p1.Position,p2.Position);
            
            % Evaluate Offsprings
            [popc(k,1).Cost,popc(k,1).NewGraph]=...
                CostFunction_MST(popc(k,1).Position,MRD);
            [popc(k,2).Cost,popc(k,2).NewGraph]=...
                CostFunction_MST(popc(k,2).Position,MRD);
            
        end
        popc=popc(:);
        
        
        % Mutation
        popm=repmat(empty_individual,nm,1);
        for k=1:nm
            
            % Select Parent
            i=randi([1 nPop]);
            p=pop(i);
            
            % Apply Mutation
            popm(k).Position=Mutate(p.Position,mu);
            
            % Evaluate Mutant
            [popm(k).Cost,popm(k).NewGraph]=...
                CostFunction_MST(popm(k).Position,MRD);
            
        end
        
        % Create Merged Population
        pop=[pop
             popc
             popm]; %#ok
         
        % Sort Population
        Costs=[pop.Cost];
        [Costs, SortOrder]=sort(Costs);
        pop=pop(SortOrder);
        
        % Update Worst Cost
        WorstCost=max(WorstCost,pop(end).Cost);
        
        % Truncation
        pop=pop(1:nPop);
        Costs=Costs(1:nPop);
        
        % Store Best Solution Ever Found
        BestSol=pop(1);
        
        if Costs(1)<SumMRDW && Costs(1)==BestCost
            counter2=counter2+1;     % Update counter    
        else
            counter2=0;             % Reset Counter
            BestCost=Costs(1); % Update BestCost
        end
        
        if (counter1>MaxIt || counter2==50)&& BestCost<SumMRDW
            break
        end
                   
    end
     
    %% Result
     
    MST=BestSol.NewGraph.*MRD;
     
    end
    