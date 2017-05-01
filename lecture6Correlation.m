% Make data to calculate correlation for
n = 100;
slope = 0.48;
intercept = 1.62;

xMax = 10;
x = rand(n, 1) * xMax;

errorMag = 5;
errors = (rand(n, 1) - 0.5) * errorMag;
signal = intercept + slope * x;
y = signal + errors;


% Plot our observed points and underlying signal
scatter(x, y);
line([0, xMax],[intercept, intercept + slope * xMax]);

% Calculate regression and output
r = PearsonR(x, y);

clc();
fprintf("r   = %.2f\n", r);
fprintf("r^2 = %.2f\n", r * r);