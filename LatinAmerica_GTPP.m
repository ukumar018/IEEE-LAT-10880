%% Comparative analysis of HO and RO GTPP models
% Requires MATLAB Control System Toolbox

clear;
clc;
close all;

%% 1. Transfer-function definitions

% Fourth-order high-order (HO) GTPP system
H4 = tf([-0.05655, -2.5442, -31.360, 3212.230], ...
        [1, 45.030, 601.400, 2019.00, 3336.00]);

% Proposed BBO--FAHP-assisted WMPM reduced-order model
R2 = tf([0.0023541, 8.9530], ...
        [1, 5.002504, 9.29840]);

% Model I: GWO-assisted AHP-based TPM method
Model_I = tf([0.5454, 3.762], ...
             [0.4241, 2.941, 3.907]);

% Model II: CPA method
Model_II = tf([-4.1562, 18.0180], ...
              [1, 11.3482, 0.6962]);

% Model III: MCPA method
Model_III = tf([-14.751, 43.153], ...
               [1, 26.99, 1.668]);

% Model IV: MNPA method
Model_IV = tf([-0.46010, 5.39107], ...
              [1, 3.4257, 0.2083]);

% Store systems and corresponding labels
systems = {H4, R2, Model_I, Model_II, Model_III, Model_IV};

modelNames = { ...
    'HO GTPP system', ...
    'Proposed BBO--FAHP--WMPM', ...
    'GWO--AHP--TPM', ...
    'CPA', ...
    'MCPA', ...
    'MNPA'};

% Colors and line styles
colors = lines(length(systems));
lineStyles = {'-', '--', '-.', ':', '--', '-.'};

%% 2. Display poles, zeros, and DC gains

fprintf('\n======================================================\n');
fprintf('POLES, ZEROS, AND DC GAINS OF THE GTPP MODELS\n');
fprintf('======================================================\n');

for k = 1:length(systems)
    fprintf('\n%s\n', modelNames{k});
    fprintf('DC gain:\n');
    disp(dcgain(systems{k}));

    fprintf('Poles:\n');
    disp(pole(systems{k}));

    fprintf('Zeros:\n');
    disp(zero(systems{k}));
end

%% 3. Step-response comparison

% A sufficiently long interval is used to capture slow model dynamics
tStep = linspace(0, 150, 15001);

figure('Color', 'w', 'Position', [100, 100, 900, 600]);
hold on;

for k = 1:length(systems)
    yStep = step(systems{k}, tStep);
    yStep = squeeze(yStep);

    plot(tStep, yStep, ...
        'Color', colors(k,:), ...
        'LineStyle', lineStyles{k}, ...
        'LineWidth', 1.6);
end

grid on;
box on;
xlabel('Time (s)', 'FontSize', 11);
ylabel('Amplitude', 'FontSize', 11);
title('Step Responses of the HO and RO GTPP Models', ...
      'FontSize', 12);
legend(modelNames, 'Location', 'best', 'FontSize', 9);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
hold off;

% Uncomment to export the figure
% exportgraphics(gcf,'GTPP_step_response.pdf','ContentType','vector');

%% 4. Enlarged step-response comparison for the HO and proposed models

figure('Color', 'w', 'Position', [100, 100, 900, 600]);
hold on;

yHO = squeeze(step(H4, tStep));
yProposed = squeeze(step(R2, tStep));

plot(tStep, yHO, 'k-', 'LineWidth', 2.0);
plot(tStep, yProposed, 'r--', 'LineWidth', 2.0);

grid on;
box on;
xlabel('Time (s)', 'FontSize', 11);
ylabel('Amplitude', 'FontSize', 11);
title('Step-Response Comparison of the HO and Proposed RO Models', ...
      'FontSize', 12);
legend('HO GTPP system', 'Proposed BBO--FAHP--WMPM', ...
       'Location', 'best');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
hold off;

%% 5. Impulse-response comparison

tImpulse = linspace(0, 150, 15001);

figure('Color', 'w', 'Position', [100, 100, 900, 600]);
hold on;

for k = 1:length(systems)
    yImpulse = impulse(systems{k}, tImpulse);
    yImpulse = squeeze(yImpulse);

    plot(tImpulse, yImpulse, ...
        'Color', colors(k,:), ...
        'LineStyle', lineStyles{k}, ...
        'LineWidth', 1.6);
end

grid on;
box on;
xlabel('Time (s)', 'FontSize', 11);
ylabel('Amplitude', 'FontSize', 11);
title('Impulse Responses of the HO and RO GTPP Models', ...
      'FontSize', 12);
legend(modelNames, 'Location', 'best', 'FontSize', 9);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
hold off;

% Uncomment to export the figure
% exportgraphics(gcf,'GTPP_impulse_response.pdf','ContentType','vector');

%% 6. Bode-plot comparison

% Frequency range in rad/s
w = logspace(-3, 3, 2000);

figure('Color', 'w', 'Position', [100, 100, 900, 700]);

% Magnitude plot
subplot(2,1,1);
hold on;

for k = 1:length(systems)
    [magnitude, phase, wout] = bode(systems{k}, w);
    magnitude = squeeze(magnitude);

    semilogx(wout, 20*log10(magnitude), ...
        'Color', colors(k,:), ...
        'LineStyle', lineStyles{k}, ...
        'LineWidth', 1.5);
end

grid on;
box on;
ylabel('Magnitude (dB)', 'FontSize', 11);
title('Bode Responses of the HO and RO GTPP Models', ...
      'FontSize', 12);
legend(modelNames, 'Location', 'best', 'FontSize', 8);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
hold off;

% Phase plot
subplot(2,1,2);
hold on;

for k = 1:length(systems)
    [magnitude, phase, wout] = bode(systems{k}, w);
    phase = squeeze(phase);

    semilogx(wout, phase, ...
        'Color', colors(k,:), ...
        'LineStyle', lineStyles{k}, ...
        'LineWidth', 1.5);
end

grid on;
box on;
xlabel('Frequency (rad/s)', 'FontSize', 11);
ylabel('Phase (deg)', 'FontSize', 11);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
hold off;

% Uncomment to export the figure
% exportgraphics(gcf,'GTPP_bode_plot.pdf','ContentType','vector');

%% 7. Pole-zero map: all systems on the same axes

figure('Color', 'w', 'Position', [100, 100, 900, 600]);
hold on;

legendHandles = gobjects(length(systems),1);

for k = 1:length(systems)
    systemPoles = pole(systems{k});
    systemZeros = zero(systems{k});

    % Plot poles using cross markers
    plot(real(systemPoles), imag(systemPoles), 'x', ...
        'Color', colors(k,:), ...
        'MarkerSize', 10, ...
        'LineWidth', 2.0);

    % Plot zeros using circular markers
    plot(real(systemZeros), imag(systemZeros), 'o', ...
        'Color', colors(k,:), ...
        'MarkerSize', 8, ...
        'LineWidth', 1.8);

    % Dummy handle for a model-based legend
    legendHandles(k) = plot(nan, nan, '-', ...
        'Color', colors(k,:), ...
        'LineWidth', 2.0);
end

xline(0, 'k--', 'LineWidth', 1.0, ...
      'HandleVisibility', 'off');
yline(0, 'k-', 'LineWidth', 0.8, ...
      'HandleVisibility', 'off');

grid on;
box on;
xlabel('Real Axis', 'FontSize', 11);
ylabel('Imaginary Axis', 'FontSize', 11);
title({'Pole--Zero Map of the HO and RO GTPP Models', ...
       'Poles: \times    Zeros: \circ'}, ...
       'FontSize', 12);

legend(legendHandles, modelNames, ...
       'Location', 'best', 'FontSize', 8);

set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
hold off;

% Uncomment to export the figure
% exportgraphics(gcf,'GTPP_pole_zero_map.pdf','ContentType','vector');

%% 8. Individual pole-zero maps

figure('Color', 'w', 'Position', [50, 50, 1100, 700]);
tiledlayout(2,3, 'TileSpacing', 'compact', ...
                  'Padding', 'compact');

for k = 1:length(systems)
    nexttile;
    pzmap(systems{k});
    grid on;
    title(modelNames{k}, 'FontSize', 10);
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 9);
end

sgtitle('Individual Pole--Zero Maps of the GTPP Models', ...
        'FontName', 'Times New Roman', 'FontSize', 12);

%% 9. Step-response performance measures

fprintf('\n======================================================\n');
fprintf('STEP-RESPONSE PERFORMANCE MEASURES\n');
fprintf('======================================================\n');

for k = 1:length(systems)
    responseInfo = stepinfo(systems{k});

    fprintf('\n%s\n', modelNames{k});
    fprintf('Rise time       = %.6f s\n', responseInfo.RiseTime);
    fprintf('Settling time   = %.6f s\n', responseInfo.SettlingTime);
    fprintf('Peak time       = %.6f s\n', responseInfo.PeakTime);
    fprintf('Peak value      = %.6f\n', responseInfo.Peak);
    fprintf('Overshoot       = %.6f %%\n', responseInfo.Overshoot);
    fprintf('Steady-state DC = %.6f\n', dcgain(systems{k}));
end



% ===============================================================================================
% ===============================================================================================
% PEI Values for 


clc;
clear;
close all;

%% Model Names
Models = {'Proposed','Model I','Model II','Model III','Model IV'};

%% Performance Error Indices

PEI = [...
    0.1608   0.01188   0.4841    0.0197    2.008    0.04137;
    0.2656   0.03274   0.6220    0.05661   2.025    0.11100;
    42.72    289.2     307.2     2266      2372     18500;
    42.39    285.7     305.2     2243      2359     18350;
    42.17    284.9     304.6     2238      2356     18310];

%% Plot

figure('Color','w','Position',[100 100 1000 500]);

b = bar(PEI,'grouped','BarWidth',0.85);

%% Bright publication-quality colors

b(1).FaceColor = [0 0.4470 0.7410];      % Blue
b(2).FaceColor = [0.8500 0.3250 0.0980]; % Orange
b(3).FaceColor = [0.9290 0.6940 0.1250]; % Yellow
b(4).FaceColor = [0.4940 0.1840 0.5560]; % Purple
b(5).FaceColor = [0.4660 0.6740 0.1880]; % Green
b(6).FaceColor = [0.3010 0.7450 0.9330]; % Cyan

% Black bar edges
for k = 1:length(b)
    b(k).EdgeColor = 'k';
    b(k).LineWidth = 0.6;
end

%% Logarithmic y-axis

set(gca,'YScale','log')

% Better axis limits
ylim([1e-2 1e5])

% Log ticks
yticks([1e-2 1e-1 1 10 100 1000 10000 100000])

%% Formatting

set(gca,...
    'FontSize',12,...
    'FontWeight','bold',...
    'LineWidth',1.3,...
    'XTickLabel',Models);

xlabel('Reduced Order Models','FontSize',14,'FontWeight','bold');
ylabel('Performance Error Index (Log Scale)','FontSize',14,'FontWeight','bold');

title('Comparison of Performance Error Indices','FontSize',15,'FontWeight','bold');

legend({'IAE','ISE','ITAE','ITSE','IT^2AE','IT^2SE'},...
    'Orientation','horizontal',...
    'Location','northoutside',...
    'NumColumns',3,...
    'FontSize',11);

grid on;
grid minor;
box on;

ax = gca;
ax.GridAlpha = 0.35;
ax.MinorGridAlpha = 0.15;


% ===============================================================================================
% ===============================================================================================
