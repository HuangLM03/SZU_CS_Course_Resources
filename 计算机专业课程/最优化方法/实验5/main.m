clc;
clear;
load('FittingData.mat');
y = y';

X = zeros(41, 3);
for i = 1:3
    X(:, i) = x'.^(i - 1);
end

C = ones(3, 1);
d = 4;

[m, n] = size([X; C']);
[Q, R] = QR(m, n, [X; C']);
Q1 = Q(1:size(X, 1), :);
Q2 = Q(size(X, 1)+1:end, :);

[m, n] = size(Q2');
[Q_hat, R_hat] = QR(m, n, Q2');

u = linsolve(R_hat', d);
c = Q_hat' * Q1' * y - u;

w = linsolve(R_hat, c);
z = Q1' * y - Q2' * w;

a = linsolve(R, z);
disp("a:");
disp(a);
p = 0:1:10;
q = a(1) + a(2) * p + a(3) * p.^2;

grid on
hold on
scatter(x, y);
plot(p, q);
xlabel('x');
ylabel('y');

function [Q, R] = QR(m, n, A)
    Q = zeros(m, n);
    R = zeros(n, n);
    
    eps = 1e-11;
    for k = 1: n
        R(1:k - 1, k) = Q(:, 1:k - 1)' * A(:, k);
        q_hat = A(:, k) - Q(:, 1:k - 1) * R(1:k - 1, k);
        if q_hat < eps
            break;
        end
        R(k, k) = norm(q_hat);
        Q(:, k) = q_hat / R(k, k);
    end
end