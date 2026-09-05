

clear;
close all;
clc;

rng(1);

% ------------------------------------------------------------
% Generate class +1
% ------------------------------------------------------------

N1 = 50;

X1 = randn(N1,2) + [2 2];
Y1 = ones(N1,1);

% ------------------------------------------------------------
% Generate class -1
% ------------------------------------------------------------

N2 = 50;

X2 = randn(N2,2) + [-2 -2];
Y2 = -ones(N2,1);

% Combine data
X = [X1; X2];
Y = [Y1; Y2];

% ------------------------------------------------------------
% SVM parameters
% ------------------------------------------------------------

C = 1;

tol = 1e-3;

maxPasses = 20;

% ------------------------------------------------------------
% Train
% ------------------------------------------------------------

model = svm_smo(X,Y,C,tol,maxPasses);

% ------------------------------------------------------------
% Predict
% ------------------------------------------------------------

[predicted,score] = svm_predict(model,X);

% Classification accuracy

accuracy = mean(predicted == Y);

fprintf('Training accuracy = %.2f %%\n',100*accuracy);

fprintf('Number of support vectors = %d\n', ...
        length(model.sv));


%---------------------------------------------------------



figure;

hold on;

% Plot class +1
scatter(X(Y==1,1),X(Y==1,2),50,'filled');

% Plot class -1
scatter(X(Y==-1,1),X(Y==-1,2),50,'filled');

% Highlight support vectors
sv = model.sv;

plot(X(sv,1),X(sv,2),'ko', ...
     'MarkerSize',12, ...
     'LineWidth',2);

% Grid
x1 = linspace(min(X(:,1))-1,max(X(:,1))+1,200);

x2 = linspace(min(X(:,2))-1,max(X(:,2))+1,200);

[Xg1,Xg2] = meshgrid(x1,x2);

Xgrid = [Xg1(:),Xg2(:)];

score = Xgrid*model.w + model.b;

Score = reshape(score,size(Xg1));

% Decision boundary
contour(Xg1,Xg2,Score,[0 0],'k','LineWidth',2);

% Margins
contour(Xg1,Xg2,Score,[-1 -1],'--k');
contour(Xg1,Xg2,Score,[1 1],'--k');

xlabel('$x_1$','Interpreter','latex');
ylabel('$x_2$','Interpreter','latex');

title('Soft-Margin SVM from the Dual Problem');

legend('Class +1','Class -1','Support vectors', ...
       'Location','best');

grid on;
axis equal;

hold off;








%--------------------------------------------------------
function [label, score] = svm_predict(model, X)

    score = X * model.w + model.b;

    label = ones(size(score));
    label(score < 0) = -1;

end





function model = svm_smo(X, Y, C, tol, maxPasses)

% ============================================================
% SVM using the dual formulation and SMO
%
% Input:
%   X         : N x d training matrix
%   Y         : N x 1 labels (+1 or -1)
%   C         : soft-margin parameter
%   tol       : numerical tolerance
%   maxPasses : maximum number of passes without changes
%
% Output:
%   model.alpha
%   model.w
%   model.b
%   model.sv
%   model.C
% ============================================================

    [N,d] = size(X);

    % Ensure column vector
    Y = Y(:);

    % Initial dual variables
    alpha = zeros(N,1);

    % Bias
    b = 0;

    % Precompute Gram matrix
    K = X * X';

    passes = 0;

    while passes < maxPasses

        numChanged = 0;

        for i = 1:N

            % Error for point i
            f_i = sum(alpha .* Y .* K(:,i)) + b;
            E_i = f_i - Y(i);

            % KKT violation
            if ((Y(i)*E_i < -tol) && (alpha(i) < C)) || ...
               ((Y(i)*E_i > tol)  && (alpha(i) > 0))

                % Randomly choose j != i
                j = randi(N-1);

                if j >= i
                    j = j + 1;
                end

                % Error for point j
                f_j = sum(alpha .* Y .* K(:,j)) + b;
                E_j = f_j - Y(j);

                alpha_i_old = alpha(i);
                alpha_j_old = alpha(j);

                % Compute bounds L and H
                if Y(i) ~= Y(j)

                    L = max(0, alpha(j) - alpha(i));
                    H = min(C, C + alpha(j) - alpha(i));

                else

                    L = max(0, alpha(i) + alpha(j) - C);
                    H = min(C, alpha(i) + alpha(j));

                end

                if L == H
                    continue;
                end

                % eta
                eta = 2*K(i,j) - K(i,i) - K(j,j);

                if eta >= 0
                    continue;
                end

                % Update alpha_j
                alpha(j) = alpha(j) ...
                    - Y(j)*(E_i - E_j)/eta;

                % Clip alpha_j
                alpha(j) = min(H, max(L, alpha(j)));

                % Check if change is significant
                if abs(alpha(j) - alpha_j_old) < 1e-5
                    alpha(j) = alpha_j_old;
                    continue;
                end

                % Update alpha_i from equality constraint
                alpha(i) = alpha_i_old + ...
                    Y(i)*Y(j)*(alpha_j_old - alpha(j));

                % Compute candidate biases
                b1 = b - E_i ...
                    - Y(i)*(alpha(i)-alpha_i_old)*K(i,i) ...
                    - Y(j)*(alpha(j)-alpha_j_old)*K(i,j);

                b2 = b - E_j ...
                    - Y(i)*(alpha(i)-alpha_i_old)*K(i,j) ...
                    - Y(j)*(alpha(j)-alpha_j_old)*K(j,j);

                % Select new bias
                if alpha(i) > 0 && alpha(i) < C

                    b = b1;

                elseif alpha(j) > 0 && alpha(j) < C

                    b = b2;

                else

                    b = (b1+b2)/2;

                end

                numChanged = numChanged + 1;

            end
        end

        if numChanged == 0
            passes = passes + 1;
        else
            passes = 0;
        end

    end

    % --------------------------------------------------------
    % Recover primal weight vector
    % --------------------------------------------------------

    w = X' * (alpha .* Y);

    % Support vectors
    sv = find(alpha > tol);

    % Store model
    model.alpha = alpha;
    model.w = w;
    model.b = b;
    model.sv = sv;
    model.C = C;

end




