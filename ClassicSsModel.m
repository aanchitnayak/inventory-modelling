function output = ClassicSsModel(rate,storageCosts,S,s,Lm,T,pdDemand,pdLeadTime)
    %%Use this function to create an (S,s) Model and simulate T days' 
    %%inventory behaviour. 
    
    % Input:
    % rate       -> selling price of each item in the inventory
    % S, s       -> Model Parameters, S and s are upper and lower bounds 
    %               for theInventory's buy and sell mechanism
    % Lm         -> Poisson Process Rate for incoming buyer orders
    % T          -> Maximum Length of Simulation. If not specified, 
    %               it will run for314 days
    % costFxn    -> Cost - Function for Storage
    % pdDemand   -> Distribution for Order Quantity coming from Buyer
    % pdLeadTime -> Lead Time for each re-supply order Distribution
    
    t = 0;
    Ch(1) = 0;
    Co(1) = 0;
    R(1) = 0;
    Y = 0;
    I(1) = S;
    lm = Lm;
    r = rate;
    h = storageCosts;
    to = inf;
    tA =  -(1/lm)*log(rand());
    
    for i = 1:T
        if min(tA,to)==tA
            if tA>=T
                Ch(i) = Ch(i-1) + (T-t(i-1))*h*I(i-1);
                X = (R(i)-Co(i)-Ch(i))/T;
                break
            else
                Ch(i+1) = Ch(i) + (tA - t(i))*h*I(i);
                t(i+1) = tA;
                tA = t(i+1) - (1/lm)*log(rand());
                B(i) = random(pdDemand);
                m = min(I(i),B(i));
                R(i+1) = R(i) + r*m;
                I(i+1) = I(i) - m;
                if I(i+1)<s && Y == 0
                    Y = S - I(i+1);
                    L(i) = random(pdLeadTime);
                    to = t(i+1) + L(i);
                end
                Co(i+1) = Co(i) + 0;
            end
        else
            if min(tA,to) == to
                if to>=T
                    Ch(i) = Ch(i-1) + (T-t(i-1))*h*I(i-1);
                    X = (R(i)-Co(i)-Ch(i))/T;
                    break
                else
                    Ch(i+1) = Ch(i) + (to - t(i))*h*I(i);
                    Co(i+1) = Co(i) + costFxn(Y);
                    I(i+1) = I(i) + Y;
                    t(i+1) = to;
                    to = inf;
                    Y = 0;
                    R(i+1) = R(i) + 0;
                end
            end
        end
    end
    X = (R-Co-Ch);
    output = [X; Co; Ch; R; I]';
    function NetCost = costFxn(Y)
        c = 1.5;
        NetCost = Y*c;
    end
end