pkg load signal

antiAliasingR = 0.95 / (1 / 10e3 + 1 / 30.1e3);
antiAliasingC = 0.43 * 2.2e-6;
antiAliasingCutoffFrequencyHz = 1 / (2 * pi * antiAliasingR * antiAliasingC);

movingAverageLength = 16;
movingAverageOrder = 2;
adcSamplingFrequencyHz = 8000;
adcResolutionBits = 10;
adcMaximumValue = 2^adcResolutionBits - 1;

w = logspace(-1, log10(1000 * antiAliasingCutoffFrequencyHz * 2 * pi), 1000000);
wHz = w / (2 * pi);
wAdcNormalised = w * (1 / adcSamplingFrequencyHz);

antiAliasingB = [1];
antiAliasingA = [antiAliasingR*antiAliasingC 1];
antiAliasingH = freqs(antiAliasingB, antiAliasingA, w);
antiAliasingMagnitudeDb = 20 * log10(abs(antiAliasingH));
figure;
title('RC LPF Transfer Function');
semilogx(wHz, antiAliasingMagnitudeDb);

movingAverageB = ones(1, movingAverageLength) / movingAverageLength;
movingAverageA = [1];
movingAverageH = freqz(movingAverageB, movingAverageA, wAdcNormalised);
movingAverageMagnitudeDb = 20 * log10(abs(movingAverageH));
figure;
title('Moving Average Transfer Function');
plot(wHz, movingAverageMagnitudeDb);

figure;
title(['Moving Average Transfer Function (' num2str(movingAverageOrder) ' order)']);
plot(wHz, movingAverageMagnitudeDb * movingAverageOrder);

figure;
title('Combined Transfer Function');
plot(wHz, antiAliasingMagnitudeDb + movingAverageMagnitudeDb * movingAverageOrder);


t = linspace(0, 1, 1e6);
%samples = max(0, min(adcMaximumValue, adcMaximumValue * (0.5 + 0.5 * sin(2 * pi() * adcSamplingFrequencyHz * t))));
samples = sin(2 * pi() * adcSamplingFrequencyHz * t);
adcOversamplingFrequencyHz = adcSamplingFrequencyHz * 10000;
[antiAliasingBz, antiAliasingAz] = bilinear(antiAliasingB, antiAliasingA, 1 / adcOversamplingFrequencyHz);

wAdcOversampledNormalised = w * (1 / adcOversamplingFrequencyHz);
antiAliasingHz = freqz(antiAliasingBz, antiAliasingAz, wAdcOversampledNormalised);
antiAliasingMagnitudeDbz = 20 * log10(abs(antiAliasingHz));
figure;
title('RC LPF Transfer Function (Discrete)');
semilogx(wHz, antiAliasingMagnitudeDbz);


pause;
