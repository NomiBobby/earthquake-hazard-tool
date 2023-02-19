function binbar(X, residual, N, title_name, label_unit)
%% plot residuals against X
figure
% split into N groups and clculate mean & standard deviation
m = max(X);
n = min(X);
m_interval = (m - n)/N;
mean_m = zeros(1, 10);
median_m = zeros(1, 10);
std_m = zeros(1, 10);
for i = 1 : N
    median_mm = n + (i-1) * m_interval + 1/2 * m_interval;
    median_m(i) = median_mm;
    aa = find(abs(X-median_mm)<m_interval);
    mean_m(i) = mean(residual(aa));
    std_mm = std(residual(aa));
    std_m(i) = std_mm;
end
X_bin = zeros(2496, 1);
for i = 1 : 2496
    X_bin(i) = n + m_interval*(floor((X(i)-n)/m_interval)+0.5);
    if X(i) == m
        X_bin(i) = n + m_interval*(floor((X(i)-n)/m_interval)-0.5);
    end
end
scatter(X_bin, residual, 15);
hold on
errorbar(median_m, mean_m, std_m, '-s', 'MarkerSize', 5, 'MarkerFaceColor', 'red', 'LineWidth', 2);
%scatter(X, residual, 50);
xlabel( sprintf('%s (%s)', title_name, label_unit));
ylabel('Residual');
legend('bin','original');
title(sprintf('%s',title_name));
hold off