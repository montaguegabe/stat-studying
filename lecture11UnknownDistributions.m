% Does the t distribution really have fatter tails?

% Make a population
popSize = 500000;
heights = randn(popSize, 1) * 2.9 + 69.1; % in inches
heightsMean = Mean(heights); % should be roughly 69.1
heightsStd = Std(heights); % should be roughly 2.9

% Now lets compare the DSMs
numSamples = 5000;
sampleSize = 6; % <- low sample size so that t and z are different

% Take a bunch of samples and calculate their z
zs = zeros(numSamples, 1);
for i = 1:numSamples
    sample = datasample(heights, sampleSize);
    sampleMean = Mean(sample);
    zs(i) = (sampleMean - heightsMean) / (heightsStd/sqrt(sampleSize));
    
end

% Take a bunch of samples and calculate their t
ts = zeros(numSamples, 1);
for i = 1:numSamples
    sample = datasample(heights, sampleSize);
    sampleMean = Mean(sample);
    
    inferredHeightsStd = InferredStd(sample);
    ts(i) = (sampleMean - heightsMean) / (inferredHeightsStd/sqrt(sampleSize));
    
end

figure();
h1 = histogram(ts);
hold on;
h2 = histogram(zs);

h1.Normalization = 'probability';
h1.BinWidth = 0.25;
h2.Normalization = 'probability';
h2.BinWidth = 0.25;

title('Blue is t, orange is z');

%%
% We notice that the blue distribution has relatively more weight in the
% tails.

% To think about: How is the distribution of z scores related to the DSM?

% To think about: Why can find the z score for individual samples (n=1),
% but not the t score?

%%

% Now lets create a similar situation to lecture 10 code: SAT scores before
% and after using a math app

clc();
popSize = 6000;

% Suppose that there is a constant effect of the app as we saw before
intelligence = max(min(randn(popSize, 1) * 15 + 50, 100), 0);
confoundingError = randn(popSize, 1) * 50;
satBefore = min((intelligence / 100) .^ 0.75 * (2500 - 1000) + 1000 + confoundingError, 2400);

errorTestRetestStd = 150;
errorTestRetest = randn(popSize, 1) * errorTestRetestStd;
appInfluence = 50;
satAfter = satBefore + errorTestRetest + appInfluence;
satDifferences = satAfter - satBefore;
satDifferencesMean = Mean(satDifferences); % should be appInfluence
satDifferencesStd = Std(satDifferences); % should be errorTestRetestStd

% Set up a test
alpha = 0.05;
n = 40;

% Which test has greater power? The Z test or T test?
powerZ = TestZPower(alpha, n, 0, errorTestRetestStd, 1, satDifferencesMean);
powerT = TestTPower(alpha, n, 0, 1, satDifferencesMean, satDifferencesStd);

fprintf("\n");
fprintf("Z test power: %.2f\n", powerZ);
fprintf("T test power: %.2f\n", powerT);

%%
% We notice that the t test has slightly less power. This should be obvious
% as the t test is conducted without any information about the population
% standard deviation, whereas we give the z test that information to make
% use of.
%
% We can check if these powers are correct by a large number of trials.

% Keep track of the number of successful rejections of the null hypothesis
% for both tests
trials = 150000;
correctPositivesZ = 0;
correctPositivesT = 0;
for i = 1:trials
    sample = datasample(satDifferences, n);
    zRejectsNull = TestZ(sample, alpha, 0, errorTestRetestStd, 1);
    tRejectsNull = TestT(sample, alpha, 0, 1);
    
    if zRejectsNull == true
        correctPositivesZ = correctPositivesZ + 1;
    end
    if tRejectsNull == true
        correctPositivesT = correctPositivesT + 1;
    end
end

fprintf("\n");
fprintf("The proportion of times the z test succeeded was %i/%i = %.2f\n", ...
    correctPositivesZ, trials, correctPositivesZ / trials);
fprintf("The proportion of times the t test succeeded was %i/%i = %.2f\n", ...
    correctPositivesT, trials, correctPositivesT / trials);

%%
% The powers are again correct - for our real data, the t test does not
% succeed as well as the Z test.

%%
% Now we create a situation in which the Z test is inappropriate - the
% improvement from the app is not constant, but drawn from a normal
% distribution. This makes the population variance impossible to know.

appInfluence = max(randn(popSize, 1) * 200 + 50, 0); % <- will add to the pop variance
errorTestRetest = randn(popSize, 1) * errorTestRetestStd;

satAfter = satBefore + errorTestRetest + appInfluence;
satDifferences = satAfter - satBefore;
satDifferencesMean = Mean(satDifferences); % should be appInfluence
satDifferencesStd = Std(satDifferences); % should be now BIGGER THAN errorTestRetestStd

fprintf("\n");
fprintf("Null hypothesis pop. standard dev. (errorTestRetestStd): %.2f\n", errorTestRetestStd);
fprintf("Alternative hypothesis pop. standard dev:                %.2f\n", satDifferencesStd);

%%
% We see that the population standard deviation now depends on which
% hypothesis is true, so we cannot use a z test. Let's see what happens
% when we still try...

% Copied from above (with tweak):

% Keep track of the number of successful rejections of the null hypothesis
% for both tests
trials = 75000;
correctPositivesZ = 0;
correctPositivesT = 0;
for i = 1:trials
    sample = datasample(satDifferences, n);
    
    % We estimate the variance as errorTestRetestStd for our Z test, even
    % though this estimate now could be off
    estimatedPopulationStd = errorTestRetestStd;
    zRejectsNull = TestZ(sample, alpha, 0, estimatedPopulationStd, 1);
    tRejectsNull = TestT(sample, alpha, 0, 1);
    
    if zRejectsNull == true
        correctPositivesZ = correctPositivesZ + 1;
    end
    if tRejectsNull == true
        correctPositivesT = correctPositivesT + 1;
    end
end

fprintf("\n");
fprintf("The proportion of times the z test succeeded was %i/%i = %.2f\n", ...
    correctPositivesZ, trials, correctPositivesZ / trials);
fprintf("The proportion of times the t test succeeded was %i/%i = %.2f\n", ...
    correctPositivesT, trials, correctPositivesT / trials);

% End copied from above

%%
% The z test still has a higher power experimentally, even though we are
% giving it the incorrect population standard deviation!
%
% Then why care about the T test?

powerT = TestTPower(alpha, n, 0, 1, satDifferencesMean, satDifferencesStd);

fprintf("\n");
fprintf("Z test power should be: (depends how good our pop. variance estimate is)\n");
fprintf("T test power should be: %.2f\n", powerT);

%%
% The T test has a predictable power, but the Z test does not.
%
% Additionally, we got lucky with our guess for the variance, because we
% let the Z test know the test-retest error, but most times in the real
% world we will not be able to guess this error, so we will not be so
% lucky.

% For instance, suppose we underestimate the population variance to be much
% greater than its actual value...

% Copied from above (with another tweak):

correctPositivesZ = 0;
correctPositivesT = 0;
for i = 1:trials
    sample = datasample(satDifferences, n);
    
    % We estimate the variance as errorTestRetestStd * 2 for our Z test
    % Now our estimate is guaranteed to be really off!
    estimatedPopulationStd = errorTestRetestStd * 2;
    zRejectsNull = TestZ(sample, alpha, 0, estimatedPopulationStd, 1);
    tRejectsNull = TestT(sample, alpha, 0, 1);
    
    if zRejectsNull == true
        correctPositivesZ = correctPositivesZ + 1;
    end
    if tRejectsNull == true
        correctPositivesT = correctPositivesT + 1;
    end
end

fprintf("\n");
fprintf("With a bad estimate: \n");
fprintf("The proportion of times the z test succeeded was %i/%i = %.2f\n", ...
    correctPositivesZ, trials, correctPositivesZ / trials);
fprintf("The proportion of times the t test succeeded was %i/%i = %.2f\n", ...
    correctPositivesT, trials, correctPositivesT / trials);

% End copied from above

%%
% We observe the z test is no longer as accurate as the t test. In summary,
% using the Z test here is unreliable.

%%

% Get a confidence interval from a single sample
sample = datasample(satDifferences, n);
confidence = 0.95;
[lower, upper] = TestTInterval(sample, confidence);

fprintf("\n");
fprintf("%i%% confidence interval is (%.2f,%.2f)\n", confidence * 100, ...
    lower, upper);
if lower <= satDifferencesMean && upper >= satDifferencesMean
    fprintf("Correct: The mean is in this interval.\n");
else
    fprintf("Incorrect! The mean is NOT in this interval!\n");
end

%%

% What is the number of times the mean lies in the interval?
trials = 15000;
correctPositives = 0;
for i = 1:trials
    sample = datasample(satDifferences, n);
    [lower, upper] = TestTInterval(sample, confidence);
    
    if lower <= satDifferencesMean && upper >= satDifferencesMean
        correctPositives = correctPositives + 1;
    end
end

fprintf("\n");
fprintf(['The proportion of times the confidence interval contained the' ...
    ' mean was %i/%i = %.2f\n'], correctPositives, trials, ...
    correctPositives / trials);

%%
% We observe that the probability of the mean being in the confidence
% interval is the confidence we specified.