function [cans,y_i,score] = SolutionGeneration(Problem,Population, P, model,c_i, R_max, i)
% Solution-generation in MCEA/D
% This function is written by Masaya Nakata
score=[];
cans=[];

for r = 1 : R_max
    % Generate two candidate solutions
    candidate1           = OperatorDE(Problem, Population(i).dec, Population(P(1)).dec, Population(P(2)).dec);
    candidate2           = OperatorDE(Problem, Population(i).dec, Population(P(1)).dec, Population(P(2)).dec);
    N=size(Population,2);
    % 预选择
    s_1=Predict(model,candidate1);
    s_2=Predict(model,candidate2);
    score=[score;s_1;s_2];
    cans=[cans;candidate1;candidate2];
    rnd                 = randperm(length(P));
    P                   = P(rnd);
    if s_1>=s_2
        candidate=candidate1;
    else
        candidate=candidate2;
    end
    % Shuffle the parents
    rnd                 = randperm(length(P));
    P                   = P(rnd);
    
    % Input the candidate solution to SVM
    [c, d_i]      = c_i.PredictClass(candidate);
    
    if c == 1
        % If predicted label of the candidate solution is positive class
        % Return the candidate solution and terminate the process
        y_i = candidate;
        
        return
    else
        % If predicted label of the candidate solution is negative class
        % Choose the candidate solution having the best decision score function value
       
        if r == 1
         
            d_i_max = d_i;
            y_i     = candidate;
           
        elseif d_i_max < d_i
            d_i_max = d_i;
            y_i     = candidate;
        end
    end
end
end