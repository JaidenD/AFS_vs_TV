projectRoot = fileparts(mfilename("fullpath"));

addpath(fullfile(projectRoot, "config", "scenarios"));
addpath(fullfile(projectRoot, "models", "harness"));
addpath(fullfile(projectRoot, "models", "plants"));
addpath(fullfile(projectRoot, "src"));

VehicleStateBus = stateBus();
run(fullfile(projectRoot, "config", "eClassParams.m"));

scenario = curvedLaneParams();