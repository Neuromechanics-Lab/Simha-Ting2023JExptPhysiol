function [t,r,rs,rd] = sarc2spindleDriver(results_file_bag,results_file_chain)

% Load the simulation back in
sim_bag = load(results_file_bag, '-mat');
sim_bag_output = sim_bag.sim_output;

sim_chain = load(results_file_chain, '-mat');
sim_chain_output = sim_chain.sim_output;

[t,r,rs,rd] = sarc2spindle_20220713clean(sim_bag_output,sim_chain_output,0.5,0.4,0.005);

end