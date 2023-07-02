function saveCurrentWithForce(varargin)

p = inputParser;

addOptional(p,'results_file_extrafusal',{});
addOptional(p,'results_file_bag',{});
addOptional(p,'results_file_chain',{});
addOptional(p,'t',[]);
addOptional(p,'r',[]);
addOptional(p,'rs',[]);
addOptional(p,'rd',[]);
addOptional(p,'r_trunc',[]);
addOptional(p,'t_trunc',[]);
addOptional(p,'parms',[]);
addOptional(p,'outputfilename',[]);

parse(p,varargin{:});
p=p.Results;
t=p.t; r=p.r; rs=p.rs; rd=p.rd; t_trunc=p.t_trunc; r_trunc=p.r_trunc; parms=p.parms;

force.extrafusal_fas = [];force.extrafusal_mtu = [];
force.bag = []; force.chain = [];
yank.extrafusal_fas = [];yank.extrafusal_mtu = [];
yank.bag = []; yank.chain = [];
length.extrafusal_fas = [];length.extrafusal_mtu = [];
length.bag = []; length.chain = [];

if ~isempty(p.results_file_extrafusal)
    sim_extrafusal = load(p.results_file_extrafusal, '-mat');
    sim_extrafusal_output = sim_extrafusal.sim_output;
    force.extrafusal_fas = sim_extrafusal_output.hs_force;
    force.extrafusal_mtu = sim_extrafusal_output.muscle_force;
    yank.extrafusal_fas = [0;diff(sim_extrafusal_output.hs_force)];
    yank.extrafusal_mtu = [0;diff(sim_extrafusal_output.muscle_force)./diff(t)];
    length.extrafusal_fas = sim_extrafusal_output.hs_length;
    length.extrafusal_mtu = sim_extrafusal_output.muscle_length;
end

if ~isempty(p.results_file_bag)
    sim_bag = load(p.results_file_bag, '-mat');
    sim_bag_output = sim_bag.sim_output;
    force.bag = sim_bag_output.hs_force;
    yank.bag = [0;diff(sim_bag_output.hs_force)./diff(t)];
    length.bag = sim_bag_output.hs_length;
end

if ~isempty(p.results_file_chain)
    sim_chain = load(p.results_file_chain, '-mat');
    sim_chain_output = sim_chain.sim_output;
    force.chain = sim_chain_output.hs_force;
    yank.chain = [0;diff(sim_chain_output.hs_force)./diff(t)];
    length.chain = sim_chain_output.hs_length;
end

save(p.outputfilename,'force','yank','length','t','r','rs','rd','r_trunc','t_trunc','parms')