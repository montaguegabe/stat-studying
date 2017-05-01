% Construct data for a bunch of people - we have their:
%   1) intelligence (0 to 100)
%   2) their SAT measure
%   3) average number of books read per month

n = 500;

intelligence = max(min(randn(n, 1) * 15 + 50, 100), 0);
confoundingError = randn(n, 1) * 50;
sat = min((intelligence / 100) .^ 0.75 * (2500 - 1000) + 1000 + confoundingError, 2400);
sat = round(sat / 50) * 50;
avgBooks = max(DistrSkewed(n, 0.6, 0.5, 0.8), 0);

% Output the first 5 people in table form
clc();
people = table(intelligence, sat, avgBooks);
disp(people(1:5,:));

% Compare SAT vs books read as a measure of intelligence:
rSat = PearsonR(intelligence, sat);
rBooks = PearsonR(intelligence, avgBooks);

fprintf("Correlation b/w SAT measure  and intelligence:\n");
fprintf("r^2 = %.2f\n", rSat * rSat);

fprintf("Correlation b/w books read and intelligence:\n");
fprintf("r^2 = %.2f\n", rBooks * rBooks);

%%
% Clearly SAT measure is a more reliable measure of intelligence than average
% books read per week.

%%

% Omitted: Percent agreement as test of reliability

%%

% Say we don't know intelligence now - we just have a test with 4 measures
% that is supposed to measure intelligence. Can we check its consistency?

% Construct results to a good test - all measures are good indicators of
% intelligence and range from 0 to 5.

error = randn(n, 4) * diag([1, 0.5, 1.6, 0.8]);
measures = zeros(n, 4);
measures(:, 1) = max(min(intelligence / 100 * 5 + error(:, 1), 5), 0);
measures(:, 2) = max(min((intelligence / 100) .^ 2 * 5 + error(:, 2), 5), 0);
measures(:, 3) = max(min((intelligence / 100) .^ 0.5 * 5 + error(:, 3), 5), 0);
measures(:, 4) = max(min(intelligence / 100 * 7.5 + error(:, 4), 5), 0);

% Output the first 5 results of our first test
test1 = table(measures(:, 1), measures(:, 2), measures(:, 3), measures(:, 4), ...
'VariableNames', {'measure1', 'measure2', 'measure3', 'measure4'});
fprintf('Test 1:\n');
disp(test1(1:5, :));

% Construct results to a bad test - not all questions are good indicators
% of intelligence. This test will be the same, except the results of the
% fourth measure have nothing to do with intelligence.

error = randn(n, 4) * diag([1, 0.5, 1.6, 0.8]);
measures = zeros(n, 4);
measures(:, 1) = max(min(intelligence / 100 * 5 + error(:, 1), 5), 0);
measures(:, 2) = max(min((intelligence / 100) .^ 2 * 5 + error(:, 2), 5), 0);
measures(:, 3) = max(min((intelligence / 100) .^ 0.5 * 5 + error(:, 3), 5), 0);
measures(:, 4) = max(min(DistrSkewed(n, 4.0, 1.0, -0.5), 5), 0);

% Output the first 5 results of our first test
test2 = table(measures(:, 1), measures(:, 2), measures(:, 3), measures(:, 4), ...
'VariableNames', {'measure1', 'measure2', 'measure3', 'measure4'});
fprintf('Test 2:\n');
disp(test2(1:5, :));

% Now analyze which of the two tests is better
k = 4; % the number of variables

measuresTest1 = table2array(test1);
measuresTest2 = table2array(test2);

% Compute alpha for test 1
y = sum(measuresTest1, 2); % the sum of the scores/measures
sySqr = Var(y);
siSqr = Var(measuresTest1, 1);
alpha1 = k / (k - 1) * (sySqr - sum(siSqr)) / sySqr;

% Compute alpha for test 2
y = sum(measuresTest2, 2); % the sum of the scores/measures
sySqr = Var(y);
siSqr = Var(measuresTest2, 1);
alpha2 = k / (k - 1) * (sySqr - sum(siSqr)) / sySqr;

% Examine results
fprintf("Test 1: alpha = %.2f\n", alpha1);
fprintf("Test 2: alpha = %.2f\n", alpha2);

%%
% Our modification to question 4 of the second test resulted in test 1
% being significantly more reliable than test 2.

