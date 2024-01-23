csi_trace= read_bf_file('sample_data/csi.dat');
csi_amp1=get_csi_function(csi_trace);
save('sample_data','csi_amp1');


function csi_amp=get_csi_function(csi_trace)
row = size(csi_trace,1);%get the row number of csi_trace

for m=1:row    
    csia=get_scaled_csi(csi_trace{m});
    csi=csia(:).';  
    for ki=1:180    %3*3*30
           csi_amp(m,ki)=csi(ki);    
    end

end
end