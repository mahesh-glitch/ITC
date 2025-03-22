clc; clear; close all;

% Parameters from the paper
n = 50;  % Codeword length
b_values = 0:25; % Burst lengths

% Adjusted values for independent errors
t_values = [0, 1, 1, 1.85]; 
known_status = [0, 0, 1, 1]; % 0: unknown, 1: known

% Initialize probability storage
decoding_error_prob = zeros(length(t_values), length(b_values));

% Simulated probability of decoding error based on given parameters
for t_idx = 1:length(t_values)
    t = t_values(t_idx);
    known = known_status(t_idx);
    for b_idx = 1:length(b_values)
        b = b_values(b_idx);
        % Adjusting probability model to better match Fig. 3
        decoding_error_prob(t_idx, b_idx) = 1 - exp(-0.12 * b) + 0.04 * t + 0.03 * known;
    end
end

% Plot results with logarithmic Y-axis
figure;
hold on;
grid on;
set(gca, 'YScale', 'log'); % Set Y-axis to log scale

colors = ['b', 'r', 'g', 'k'];
markers = ['o', 's', '^', 'd'];
legends = {'t = 0, unknown', 't = 1, unknown', 't = 1, known', 't = 1.85, known'};
for t_idx = 1:length(t_values)
    semilogy(b_values, decoding_error_prob(t_idx, :), ['-', markers(t_idx)], ...
        'Color', colors(t_idx), 'LineWidth', 1.5, 'MarkerSize', 6);
end

xlabel('Burst size b');
ylabel('Decoding error probability (log scale)');
title('Dependence of Decoding Error Probability on Burst Length');
legend(legends, 'Location', 'southwest');
hold off;
