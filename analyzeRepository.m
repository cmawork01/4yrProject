function report = analyzeRepository(repoRoot)
%ANALYZEREPOSITORY Summarize MATLAB/P-code files in the repository.
%   REPORT = ANALYZEREPOSITORY(REPOROOT) scans the repository for .m and .p
%   files, extracts function names from MATLAB files, and prints a summary.
%   If REPOROOT is omitted, the current directory is used.

if nargin < 1 || isempty(repoRoot)
    repoRoot = pwd;
end

paths = strsplit(genpath(repoRoot), pathsep);
mFiles = {};
pFiles = {};

for i = 1:numel(paths)
    currentPath = paths{i};
    if isempty(currentPath) || contains(currentPath, [filesep '.git'])
        continue;
    end

    mListing = dir(fullfile(currentPath, '*.m'));
    pListing = dir(fullfile(currentPath, '*.p'));

    mFiles = [mFiles; fullfile({mListing.folder}, {mListing.name})']; %#ok<AGROW>
    pFiles = [pFiles; fullfile({pListing.folder}, {pListing.name})']; %#ok<AGROW>
end

mFiles = unique(mFiles);
pFiles = unique(pFiles);

[lineCounts, functionNames] = analyzeMatlabFiles(mFiles);

[sortedCounts, sortIdx] = sort(lineCounts, 'descend');
maxEntries = min(10, numel(sortIdx));
largestFiles = mFiles(sortIdx(1:maxEntries));

report = struct();
report.repoRoot = repoRoot;
report.matlabFileCount = numel(mFiles);
report.pcodeFileCount = numel(pFiles);
report.functionCount = numel(functionNames);
report.uniqueFunctions = unique(functionNames);
report.lineCounts = lineCounts;
report.largestFiles = largestFiles;
report.largestFileLineCounts = sortedCounts(1:maxEntries);

fprintf('Repository summary for: %s\n', repoRoot);
fprintf('MATLAB files (.m): %d\n', report.matlabFileCount);
fprintf('P-code files (.p): %d\n', report.pcodeFileCount);
fprintf('Extracted functions: %d\n', report.functionCount);
if ~isempty(report.uniqueFunctions)
    fprintf('Unique function names: %d\n', numel(report.uniqueFunctions));
end

if ~isempty(largestFiles)
    fprintf('\nTop %d MATLAB files by line count:\n', maxEntries);
    for i = 1:maxEntries
        fprintf('  %s (%d lines)\n', toRelativePath(largestFiles{i}, repoRoot), report.largestFileLineCounts(i));
    end
end

if ~isempty(report.uniqueFunctions)
    fprintf('\nSample of extracted function names:\n');
    sampleSize = min(10, numel(report.uniqueFunctions));
    for i = 1:sampleSize
        fprintf('  %s\n', report.uniqueFunctions{i});
    end
end
end

function [lineCounts, functionNames] = analyzeMatlabFiles(mFiles)
lineCounts = zeros(numel(mFiles), 1);
functionNames = {};

for i = 1:numel(mFiles)
    filePath = mFiles{i};
    fileText = fileread(filePath);
    lineCounts(i) = numel(splitlines(fileText));

    matches = regexp(fileText, '^\s*function\s+[\[\]\w,\s~]*=\s*(\w+)|^\s*function\s+(\w+)', 'tokens', 'lineanchors');
    if ~isempty(matches)
        flat = [matches{:}];
        flat = flat(~cellfun('isempty', flat));
        functionNames = [functionNames; flat(:)]; %#ok<AGROW>
    end
end
end

function relativePath = toRelativePath(filePath, repoRoot)
if startsWith(filePath, repoRoot)
    relativePath = filePath(numel(repoRoot) + 2:end);
else
    relativePath = filePath;
end
end
