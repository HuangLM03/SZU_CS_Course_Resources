function count_stablity(Q)
    [~, n] = size(Q);
    Error = zeros(1, n);
    for k = 2 : n
        max = 0;
        for i = 1 : k - 1
            tmp = abs(Q(:, i)' * Q(:, k));
            if tmp > max
                max = tmp;
            end
        end
        Error(:, k) = max;
    end

    plot(Error);
end
