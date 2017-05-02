% Lets simulate responses to a survey that asks how likely you are to help
% someone. In one survey the person you could help is victim of misfortune
% and in the other they are also the cause of their misfortune.

popSize = 15000;

% Simulate responses on a Likert scale from 1 to 5.
populationAnswerStd = 1.1;
helpVictim = randn(popSize, 1) * populationAnswerStd + 3.5;
helpCause = randn(popSize, 1) * populationAnswerStd + 1.5;

% We have two different sample sizes!
n1 = 20;
n2 = 15;

% If we draw two samples and compare the difference of their means, what
% will be the standard error?

trials = 1000;
for i = 1:trials
    
end