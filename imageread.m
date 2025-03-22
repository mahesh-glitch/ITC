
clc;
clear all;
close all;

% Read the image file
image = imread('im3.jpg'); % Replace 'filename.jpg' with your image file name

% Display the image
imshow(image);
%title('Loaded Image');


[rows, cols, channels] = size(image);
if channels == 3
    disp('The image is RGB.');
else
    disp('The image is Grayscale.');
end

flattened_image = image(:);  % Image ni oka line lo arrange cheyyi
[values, freq] = unique(flattened_image);  % Unique pixel values, frequency


% Calculate probabilities for each pixel value
prob = zeros(size(values));
for i = 1:length(values)
    prob(i) = sum(flattened_image == values(i)) / length(flattened_image);
end

% Create Huffman dictionary
dict = huffmandict(values, prob);

% Encode the image using Huffman coding
encoded_image = huffmanenco(flattened_image, dict);

% Calculate compression ratio
original_size = numel(flattened_image) * 8;  % 8 bits per pixel
compressed_size = numel(encoded_image);
compression_ratio = original_size / compressed_size;

% Save the compressed data
save('compressed_image.mat', 'encoded_image', 'dict', 'rows', 'cols', 'channels');

% To decompress the image:
decoded_image = huffmandeco(encoded_image, dict);
reconstructed_image = reshape(decoded_image, rows, cols, channels);

% Display results
figure;
subplot(1,2,1); imshow(image); title('Original Image');
subplot(1,2,2); imshow(uint8(reconstructed_image)); title('Reconstructed Image');

fprintf('Compression Ratio: %.2f:1\n', compression_ratio);
fprintf('Original Size: %d bits\n', original_size);   
fprintf('Compressed Size: %d bits\n', compressed_size);