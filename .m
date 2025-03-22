clc; clear all;close all;

% Inputs
H = [1 0 1 1 0; 0 1 1 1 1; 1 1 0 1 0]; % Parity-check matrix
y = [1 1 0 1 0];                       % Received word
b = 3;                                 % Window size
t = 1;                                 % Max independent errors outside the burst

n = length(y);                         % Length of the received word
positions_outside_burst = n - b;       % Number of positions outside the burst
L = de2bi(0:2^positions_outside_burst-1, positions_outside_burst, 'left-msb'); % All possible error patterns

% Sliding window decoding
for i = 1:(n - b + 1)
    Hb_i = H(:, i:(i + b - 1)); % Submatrix of H for the window
    for ell = 1:size(L, 1)
        % Add covering vector outside the window
        covering_vector = zeros(1, n);
        covering_positions = [1:i-1, i+b:n]; % Positions outside the burst
        covering_vector(covering_positions) = L(ell, :); % Map L to covering positions
        y_mod = mod(y + covering_vector, 2); % Modify received word with covering vector
        
        % Compute the syndrome
        S = mod(y_mod * H', 2);
        
        % Extract the modified subvector for the window
        yb_i = y_mod(i:(i + b - 1));
        
        % Solve for the error vector within the window
        e = mod(S / Hb_i', 2);
        
        % Check if decoding is valid
        if all(mod(e * Hb_i', 2) == S)
            % Reconstruct the decoded word
            decoded_word = y_mod;
            decoded_word(i:(i + b - 1)) = mod(yb_i + e, 2); % Correct burst
            disp('Decoded word:');
            disp(decoded_word);
            return;
        end
    end
end

disp('Decoding failed.');
