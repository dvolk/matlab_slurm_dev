%
% Run a factorization with 1-64 workers, and plot the speedup relative to
% 1 worker
%

primeNumbers = primes(uint64(2^23));

compositNumbers = primeNumbers.*primeNumbers(randperm(numel(primeNumbers)));

factors = zeros(numel(primeNumbers),2);

singleworkertime = 1
numWorkers = [1,2,4,8,16,32,64]
tlocal = zeros(size(numWorkers));
for w=1:numel(numWorkers)
    tic;
    disp(numWorkers(w));
    parfor (idx = 1:numel(compositNumbers), numWorkers(w))
        factors(idx,:) = factor(compositNumbers(idx));
    end
    
    if (w == 1)
        singleworkertime = toc;
        tlocal(w) = 1/(toc/singleworkertime);
    else
        tlocal(w) = 1/(toc/singleworkertime);
    end
end
f = figure;
speedup = tlocal;
hold on;
plot(numWorkers, speedup, '-o');
plot(numWorkers, numWorkers, "b:");
title('Speedup with the number of workers');
xlim([0, 64])
ylim([0, 64])
xlabel('Number of workers');
xticks(numWorkers);
ylabel('Speedup');
grid on;
hold off;