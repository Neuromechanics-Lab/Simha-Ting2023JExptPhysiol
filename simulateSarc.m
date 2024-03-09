function [results_file] = simulateSarc(parms)

% adding some file paths
fp_CurrCode = parms.fnp;
fp_CurrSimIN = strcat(parms.fnp,'/sim_input');
fp_CurrSimOUT = strcat(parms.fnp,'/sim_output/');
addpath(genpath(parms.fp_MATMyoSim))

options_file = sprintf('%s/options.json',fp_CurrSimIN);

[SUCCESS,MESSAGE]  = mkdir(fp_CurrSimOUT,parms.date)
results_base_file = sprintf('%s%s/%s',fp_CurrSimOUT,parms.date,parms.protocolPick);

protocol_folder = sprintf('%s/Protocols/%s',fp_CurrSimIN);
[SUCCESS,MESSAGE]  = mkdir(protocol_folder,parms.date)
base_protocol_file =  sprintf('%s%s/%s',protocol_folder,parms.date,parms.protocolPick);

model_file = sprintf('%s/Models/%s%s.json',fp_CurrSimIN,parms.modelPick,parms.fibreType);
base_model = loadjson(model_file);

switch parms.fibreType
    case 'Bag'
        f = parms.b_f; g = parms.b_g;
    case 'Chain'
        f = parms.c_f; g = parms.c_g;
end

switch parms.protocolPick
    case 'rampNoThinFilamentDeact'
        base_model.MyoSim_model.hs_props.parameters.rate_func = parms.twoStateType;
        base_model.MyoSim_model.hs_props.parameters.k_coop = 0; %0
        base_model.MyoSim_model.hs_props.parameters.k_off = 0;
        base_model.MyoSim_model.hs_props.parameters.k_1 = f;
        base_model.MyoSim_model.hs_props.parameters.k_2_0 = g;
    case 'rampNoCoop'
        base_model.MyoSim_model.hs_props.parameters.rate_func = parms.twoStateType;
        base_model.MyoSim_model.hs_props.parameters.k_coop = 0; %0
        base_model.MyoSim_model.hs_props.parameters.k_1 = f;
        base_model.MyoSim_model.hs_props.parameters.k_2_0 = g;
    case 'ramp'
        base_model.MyoSim_model.hs_props.parameters.rate_func = parms.twoStateType;
        base_model.MyoSim_model.hs_props.parameters.k_coop = parms.k_coop; %0
        base_model.MyoSim_model.hs_props.parameters.k_1 = f; 
        base_model.MyoSim_model.hs_props.parameters.k_2_0 = g;
    case 'customTri'
        base_model.MyoSim_model.hs_props.parameters.rate_func = parms.twoStateType;
        base_model.MyoSim_model.hs_props.parameters.k_coop = parms.k_coop; %0
        base_model.MyoSim_model.hs_props.parameters.k_1 = f;
        base_model.MyoSim_model.hs_props.parameters.k_2_0 = g;
    case 'sine'
        base_model.MyoSim_model.hs_props.parameters.rate_func = parms.twoStateType;
        base_model.MyoSim_model.hs_props.parameters.k_1 = f;
        base_model.MyoSim_model.hs_props.parameters.k_2_0 = g;
end
model_file = sprintf('%s/Models/%s%s.json',fp_CurrSimIN,parms.modelPick,parms.fibreType);
savejson('MyoSim_model',base_model.MyoSim_model, model_file);

switch parms.protocolPick
    case 'rampNoThinFilamentDeact'
        protocol_file = sprintf('%sSim%ipCa%iAmp%iVel%i.txt',base_protocol_file,parms.simNo,round(parms.pCa*10),round(parms.amp*10),round(parms.vel*10));
        ampMagnitude = (parms.amp/100)*1300; % 1300 is resting sarcomere length. so this is a scaling step
        vel = (parms.vel/100)*1300;
        generate_ramp_protocol('time_step',0.001,...
            'output_file_string',protocol_file,'mode',parms.mode,'ramp_amp_nm',ampMagnitude,...
            'activating_pCa',parms.pCa,'ramp_rise_time_s',ampMagnitude/vel);
        results_file = sprintf('%sSim%i%spCa%iAmp%iVel%i.myo',results_base_file,parms.simNo,parms.fibreType,round(parms.pCa*10),round(parms.amp*10),round(parms.vel*10));

    case 'rampNoCoop'
        protocol_file = sprintf('%sSim%ipCa%iAmp%iVel%i.txt',base_protocol_file,parms.simNo,round(parms.pCa*10),round(parms.amp*10),round(parms.vel*10));
        ampMagnitude = (parms.amp/100)*1300; % 1300 is resting sarcomere length. so this is a scaling step
        vel = (parms.vel/100)*1300;
        generate_ramp_protocol('time_step',0.001,...
            'output_file_string',protocol_file,'mode',parms.mode,'ramp_amp_nm',ampMagnitude,...
            'activating_pCa',parms.pCa,'ramp_rise_time_s',ampMagnitude/vel);
        results_file = sprintf('%sSim%i%spCa%iAmp%iVel%i.myo',results_base_file,parms.simNo,parms.fibreType,round(parms.pCa*10),round(parms.amp*10),round(parms.vel*10));

    case 'ramp'
        protocol_file = sprintf('%sSim%ipCa%iAmp%iVel%i.txt',base_protocol_file,parms.simNo,round(parms.pCa*10),round(parms.amp*10),round(parms.vel*10));
        ampMagnitude = (parms.amp/100)*1300; % 1300 is resting sarcomere length. so this is a scaling step
        vel = (parms.vel/100)*1300;
        generate_ramp_protocol('time_step',0.001,...
            'output_file_string',protocol_file,'mode',parms.mode,'ramp_amp_nm',ampMagnitude,...
            'activating_pCa',parms.pCa,'ramp_rise_time_s',ampMagnitude/vel);
        results_file = sprintf('%sSim%i%spCa%iAmp%iVel%i.myo',results_base_file,parms.simNo,parms.fibreType,round(parms.pCa*10),round(parms.amp*10),round(parms.vel*10));

    case 'customTri'
        protocol_file = sprintf('%sSim%ipCa%iISI%icondAmp%iAmp%iVel%i.txt',base_protocol_file,parms.simNo,round(parms.pCa*10),round(parms.ISI*10),round(parms.condAmp*10),round(parms.amp*10),round(parms.vel*10));
        ampMagnitude = (parms.amp/100)*1300; % 1300 is resting sarcomere length. so this is a scaling step
        vel = (parms.vel/100)*1300;
        condAmpMagnitude = (parms.condAmp/100)*1300; 
        generate_triangle_protocol('time_step',0.001,...
            'output_file_string',protocol_file,'mode',parms.mode,'no_of_triangles',2,'triangle_nm',ampMagnitude,'cond_triangle_nm',condAmpMagnitude,...
            'inter_triangle_s',parms.ISI,'activating_pCa',parms.pCa,'plateau_s',0,'triangle_rise_time_s',ampMagnitude/vel,...
            'cond_triangle_rise_time_s',condAmpMagnitude/vel);
        results_file = sprintf('%sSim%i%spCa%iISI%icondAmp%iAmp%iVel%i.myo',results_base_file,parms.simNo,parms.fibreType,round(parms.pCa*10),round(parms.ISI*10),round(parms.condAmp*10),round(parms.amp*10),round(parms.vel*10));
   
    case 'sine'
        protocol_file = sprintf('%sSim%ipCa%iFreq%iAmp%i.txt',base_protocol_file,parms.simNo,round(parms.pCa*10),round(parms.freq),round(parms.amp*10000));
        ampMagnitude = (parms.amp/100)*1300; % 1300 is resting sarcomere length. so this is a scaling step
        generate_sine_wave_protocol('time_step',0.001,...
            'output_file_string',protocol_file,'mode',parms.mode,'dhsl_nm',ampMagnitude,...
            'frequencies',parms.freq,'activating_pCa',parms.pCa);
        results_file = sprintf('%sSim%i%spCa%iFreq%iAmp%i.myo',results_base_file,parms.simNo,parms.fibreType,round(parms.pCa*10),round(parms.freq),round(parms.amp*10000));
end

% Add the job to the batch structure
batch_structure.job{1}.model_file_string = model_file;
batch_structure.job{1}.options_file_string = options_file;
batch_structure.job{1}.protocol_file_string = protocol_file;
batch_structure.job{1}.results_file_string = results_file;

run_batch(batch_structure);

end