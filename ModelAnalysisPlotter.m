function fig = ModelAnalysisPlotter(output)
    T = length(output);
    X = output(:,1);
    Co = output(:,2);
    Ch = output(:,3);
    R = output(:,4);
    I = output(:,5);
    fig = figure
    subplot(331)
    stairs(R)
    title('Total Revenue Generated')
    grid on 
    xlabel('Time')
    xlim([0,T])
    ylabel('R_t')
    subplot(333)
    stairs(Co)
    title('Cost of Resupplying Inventory')
    grid on
    xlabel('Time')
    xlim([0,T])
    ylabel('C_{ot}')
    subplot(335)
    stairs(X)
    title('Net Profit')
    grid on
    xlabel('Time')
    xlim([0,T])
    ylabel('X_{t}')
    subplot(337)
    stairs(Ch)
    title('Cost of Storage')
    grid on
    xlabel('Time')
    xlim([0,T])
    ylabel('C_{ht}')
    subplot(339)
    stairs(I)
    title('Inventory Level')
    grid on
    xlabel('Time')
    xlim([0,T])
    ylabel('I_{t}')
end