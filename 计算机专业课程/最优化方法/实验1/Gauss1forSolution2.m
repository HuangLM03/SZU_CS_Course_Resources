function Gauss1forSolution2(A)
    disp("高斯消元法")
    %% 预处理
    [row_A, col_A] = size(A);
    I = eye(row_A);
    A_1 = [];
    for k = 1 : 1 : row_A
        b = I(:, k);
        b = b';
        AM = cat(2, A, b');
        [row_b, col_b] = size(b);
        [row_AM, col_AM] = size(AM);
        %% 求解
        disp("求解" + k + "组中...");
        if rank(A) ~= rank(AM)
            disp("无解");
            return; 
        end
        for i = 1 : row_AM
            for j = i + 1 : row_AM
                AM(j, :) = AM(j, :) - AM(j, i) .* AM(i, :) ./ AM(i, i);
            end
        end
    
        for i = row_AM : -1 : 1
            AM(i, :) = AM(i, :) ./ AM(i, i);       
            for j = i - 1 : -1 : 1
                AM(j, :) = AM(j, :) - AM(j, i) * AM(i, :);
            end
    
        end
        disp("求解结束" + k + "组结束...");
        A_1 = cat(2, A_1, AM(:, row_A + 1));
    end
    %% 输出结果
    disp("矩阵A的逆为：");
    disp(A_1);
    [row_A_1, col_A_1] = size(A_1);
    %% 验证解的正确性
    dev_I = A * A_1;
    exp = 1e-4;
    fail = false;
    for i = 1 : 1 : row_A
        for j = 1 : 1 : row_A
            if abs(I(i, j) - dev_I(i, j)) > exp
                fail = true;
                break;
            end
        end
        if fail == true
            break;
        end
    end
    real_A_1 = inv(A);
    disp("正确的逆为：");
        for i = 1 : 1 : row_A_1
        for j = 1 : 1 : col_A_1
            if abs(A_1(i, j) - real_A_1(i, j)) > exp
                fail = true;
                break;
            end
        end
        if fail == true
            break;
        end
    end
    disp(real_A_1);
    %% 计算损失
    loss = 0.0;
    for i = 1 : 1 : row_A
        for j = 1 : 1 : row_A
            loss = loss + abs(I(i, j) - dev_I(i, j));
        end
    end
    disp("loss: " + loss);

    if ~fail
        disp("求解正确");
    else
        disp("求解错误");
    end
    return;
    return;
end