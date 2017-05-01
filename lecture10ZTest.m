% Lets set up a distribution of SAT scores as before
popSize = 6000;
clc();

% We don't need the intelligence, variable anymore apart from the fact that
% used it before to compute the SAT score
intelligence = max(min(randn(popSize, 1) * 15 + 50, 100), 0);
confoundingError = randn(popSize, 1) * 50;
satBefore = min((intelligence / 100) .^ 0.75 * (2500 - 1000) + 1000 + confoundingError, 2400);

% Note: We suppose we know this test-retest standard deviation and use it
% in our test

errorTestRetestStd = 150;

% Now simulate everyone using the special math app, and suppose it doesn't
% help at all (effect size is 0)
errorTestRetest = randn(popSize, 1) * errorTestRetestStd;
appInfluence = 0; % is the effect size, but not measured in standard errors
satAfter = satBefore + errorTestRetest + appInfluence;

satDifferences = satAfter - satBefore;

% Draw a sample
n = 80;
sample = datasample(satDifferences, n);

% Conduct a Z test on the sample
alpha = 0.05;
[rejectNull, z, p, d] = TestZ(sample, alpha, 0, errorTestRetestStd, 1);

% Knowing everything, we can interpret the results of our test
if rejectNull
    fprintf("False positive!\n");
else
    fprintf("Correctly failed to reject null hypothesis.\n");
end
fprintf("z = %.2f, p = %.2f, d = %.2f\n", z, p, d);

% Lets see how often we get a false positive if we did a ton of samples and 
% Z tests...
trials = 150000;
falsePositives = 0;
for i = 1:trials
    sample = datasample(satDifferences, n);
    rejectNull = TestZ(sample, alpha, 0, errorTestRetestStd, 1);
    if rejectNull == true
        falsePositives = falsePositives + 1;
    end
end

fprintf("\n");
fprintf("The proportion of times we got a false positive was %i/%i = %.2f\n", ...
    falsePositives, trials, falsePositives / trials);

%%
% We notice that the probability of a false positive is roughly alpha (it
% is 'roughly' alpha because it takes a LONG time to accurately measure
% the probability of this)

%%

% Now simulate everyone using the special math app, but this time suppose
% it DOES have a small effect
errorTestRetest = randn(popSize, 1) * errorTestRetestStd;

% QUESTION: Can we still use a z test if the sample variance is much
% different? Adding randomness to the test results changes the variance!
% appInfluence = 50;
appInfluence = max(randn(popSize, 1) * 60 + 50, 0);
satAfter = satBefore + errorTestRetest + appInfluence;

satDifferences = satAfter - satBefore;

% Set up an identical Z test
alpha = 0.05;
n = 80;

% Using all knowledge, calculate the power of our test
[power, effectSize] = TestZPower(alpha, n, 0, errorTestRetestStd, 1, ...
    Mean(satDifferences));
fprintf("\n");
fprintf("The math app has created an effect size:             %.2f\n", effectSize);
fprintf("Our test will recognize the effect with probability: %.2f\n", power);

%%

% Now we see if these predictions are correct by running the test
sample = datasample(satDifferences, n);
[rejectNull, z, p, d] = TestZ(sample, alpha, 0, errorTestRetestStd, 1);

% Knowing everything, we can interpret the results of our test
fprintf("\n");
if rejectNull
    fprintf("Correctly rejected the null hypothesis.\n");
else
    fprintf("False negative!\n");
end
fprintf("z = %.2f, p = %.2f, d = %.2f\n", z, p, d);

%%
% We observe that Cohen's d outputted from the test is roughly the effect
% size that we predicted - this is because Cohen's d is an estimator for
% the effect size.
%
% We can check if the power is actually what we claim by running the test
% many times.

% Keep track of the number of successful rejections of the null hypothesis
trials = 150000;
correctPositives = 0;
for i = 1:trials
    sample = datasample(satDifferences, n);
    rejectNull = TestZ(sample, alpha, 0, errorTestRetestStd, 1);
    if rejectNull == true
        correctPositives = correctPositives + 1;
    end
end

fprintf("\n");
fprintf("The proportion of times the test succeeded was %i/%i = %.2f\n", ...
    correctPositives, trials, correctPositives / trials);

%%
% We notice that the proportion of true positives is roughly the power that
% we calculated before.

