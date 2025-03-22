% Main Script for Single Burst Decoding
clc; clear;

% Example Inputs
H = [1 0 1 1 0; 0 1 1 1 1; 1 1 0 1 0]; % Parity-check matrix (3x5 matrix)
y = [1 1 0 1 0];                       % Received word (must match H's columns)
b = 3;                                 % Maximum burst length (window size)

% Compute the syndrome
S = mod(y * H', 2); % Syndrome is calculated as y * H^T mod 2

% Get the length of the received word
n = length(y);

% Initialize the result
decoded_word = 'failure';

% Sliding Window Decoding
for i = 1:(n - b + 1) % Start position of the sliding window
    % Extract the submatrix and subvector for the current window
    Hb_i = H(:, i:(i + b - 1)); % Submatrix of H (columns i to i+b-1)
    yb_i = y(i:(i + b - 1));    % Subvector of y (positions i to i+b-1)
    
    % Solve for e such that e * Hb_i' = S (mod 2)
    e = mod(S / Hb_i', 2); % Approximate the error vector
    
    % Check if the solution is valid
    if all(mod(e * Hb_i', 2) == S) % Verify if e solves the equation
        % Correct the burst and reconstruct the decoded word
        corrected_burst = mod(yb_i + e, 2); % Correct the burst
        decoded_word = y; % Start with the original received word
        decoded_word(i:(i + b - 1)) = corrected_burst; % Insert the corrected burst
        break; % Exit the loop as decoding is successful
    end
end

% Display the result
disp('Decoded word:');
disp(decoded_word);
