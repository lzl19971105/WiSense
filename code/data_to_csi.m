csi_file = read_bf_file('v/v1/a1t1.dat');
row = size(csi_file, 1);
temp = [];

for k = 1:row
    csi = get_scaled_csi(csi_file{k});
    csi = csi(:)';
    
    for m = 1:length(csi)
        csi(m) = abs(csi(m));
    end

    temp = [temp; csi];
end

writematrix(temp, 'v\a1t1.csv');
