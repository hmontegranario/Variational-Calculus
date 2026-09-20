
X = [0 0 1 1; 0 1 0 1];
y = [0 1 1 0];

[W1, b1, W2, b2, loss] = mlpXOR(X, y, 10000, 0.5);

% Test
sig = @(z) 1 ./ (1 + exp(-z));
A1 = sig(W1 * X + b1);
A2 = sig(W2 * A1 + b2);

fprintf('Outputs: %.4f %.4f %.4f %.4f\n', A2);
fprintf('Rounded: %d %d %d %d\n', round(A2));
[X' round(A2)']



function [W1, b1, W2, b2, lossHist] = mlpXOR(X, y, epochs, lr)
% X: 2 x m, y: 1 x m (values 0 or 1)

[~, m] = size(X);

% Xavier initialization
W1 = randn(2, 2) * 0.5;
b1 = zeros(2, 1);
W2 = randn(1, 2) * 0.5;
b2 = 0;

sig = @(z) 1 ./ (1 + exp(-z));
lossHist = zeros(1, epochs);

for epoch = 1:epochs
    % --- Forward ---
    Z1 = W1 * X + b1;       % 2 x m
    A1 = sig(Z1);
    Z2 = W2 * A1 + b2;      % 1 x m
    A2 = sig(Z2);

    % --- Loss (binary cross-entropy) ---
    eps_ = 1e-12;
    loss = -mean(y .* log(A2 + eps_) + ...
        (1 - y) .* log(1 - A2 + eps_));
    lossHist(epoch) = loss;

    % --- Backward ---
    dZ2 = (A2 - y) / m;           % 1 x m
    dW2 = dZ2 * A1';              % 1 x 2
    db2 = sum(dZ2, 2);

    dA1 = W2' * dZ2;              % 2 x m
    dZ1 = dA1 .* A1 .* (1 - A1);  % sigmoid'
    dW1 = dZ1 * X';               % 2 x 2
    db1 = sum(dZ1, 2);

    % --- Update ---
    W1 = W1 - lr * dW1;
    b1 = b1 - lr * db1;
    W2 = W2 - lr * dW2;
    b2 = b2 - lr * db2;
end
end

