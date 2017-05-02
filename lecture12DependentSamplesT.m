% Saw how to do these in previous lecture code, so let's just focus on
% effect size.

% Again, lets bring up the SAT scores example
intelligence = max(min(randn(popSize, 1) * 15 + 50, 100), 0);
confoundingError = randn(popSize, 1) * 50;
satBefore = min((intelligence / 100) .^ 0.75 * (2500 - 1000) + 1000 + confoundingError, 2400);

errorTestRetestStd = 150;
errorTestRetest = randn(popSize, 1) * errorTestRetestStd;
%appInfluenceMeanImprove = 50;
appInfluence = max(randn(popSize, 1) * 200 + appInfluenceMeanImprove, 0);
appInfluence = appInfluenceMeanImprove;
satAfter = satBefore + errorTestRetest + appInfluence;
satDifferences = satAfter - satBefore;
satDifferencesMean = Mean(satDifferences); % should be appInfluence
satDifferencesStd = Std(satDifferences);

n = 100;
df = n - 1;

% Take a bunch of sample-based estimates for the effect size and average
% them together
trials = 1000;
ts = zeros(trials, 1);
ds = zeros(trials, 1);
for i = 1:trials
    sample = datasample(satDifferences, n);
    [~, ts(i), ~, ds(i)] = TestT(sample, 0.05, 0, 1);
end

d = mean(ds);
t = mean(ts);

clc();
fprintf("\n");
fprintf("Estimated effect size: %.2f\n", d);
fprintf("Actual effect size:    %.2f\n", satDifferencesMean / satDifferencesStd);

% Measure variability explained by app
rSqr = (t^2) / (t^2 + df);
fprintf("Estimated variability due to effect: %.2f\n", rSqr);
fprintf("Actual variability due to effect:    %.2f\n", PearsonR(satBefore, satAfter)^2);

%%
% We observe the effect size estimates are good.
%
% As far as r-sqaured estimates, I'm puzzled by this one. Either the r^2
% refers to a different r or there is a mistake in the notes. It's not even
% close though..

