function output = conv2D(input, kernel)
% Input: input - input matrix
%        kernel - kernel matrix
% Output: output - output matrix after 2D convolution
%TAKEN FROM ChatGPT
input_rows = size(input, 1);
input_cols = size(input, 2);
kernel_size = size(kernel, 1);
pad_size = floor(kernel_size / 2); % Assuming zero-padding to preserve output size

% Zero-pad the input matrix
input_padded = padarray(input, [pad_size, pad_size],0);

% Initialize the output matrix
output = zeros(input_rows, input_cols);

% Iterate over the input matrix
for i = 1:input_rows
    for j = 1:input_cols
        
        % Iterate over the kernel matrix
        for k = -pad_size:pad_size
            for l = -pad_size:pad_size
                
                % Compute the input and kernel indices
                ii = i + k + pad_size;
                jj = j + l + pad_size;
                kk = k + pad_size + 1;
                ll = l + pad_size + 1;
                
                % Update the output element
                output(i, j) = output(i, j) + input_padded(ii, jj) * kernel(kk, ll);
            end
        end
    end
end
