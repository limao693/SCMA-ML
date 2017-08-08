%% SCMA simple Transceiverchain.m
clc;
clear; 
tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Parameter settings %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PAR.FN=4;   % variable nodes (VN), number of data layers
PAR.VN=6;   % function nodes (FN), number of physical resources
PAR.d_f=3;      % Each FN is connected to 3 VNs
PAR.d_v=2;      % Each VN is connected to 2 FNs 
PAR.M=4;        % Number of codeword in each codebook
PAR.Data_length=4096*60;    % Number of total data
PAR.N_iter= 5;  % Number of iterations in decoding
%PAR.EbNo = 10;
PAR.EbNo = [1:0.1:20];
PAR.CB=zeros(PAR.M,PAR.FN,PAR.VN);      %Codebooks
PAR.CB(:,:,1)=[  0,0,0,0;
            -0.1815-0.1318i,-0.6351-0.4615i,0.6351+0.4615i,0.1815+0.1318i;
            0,0,0,0;
            0.7851,-0.2243,0.2243,-0.7851];
 
PAR.CB(:,:,2)=[  0.7851,-0.2243,0.2243,-0.7851;
            0,0,0,0;
            -0.1815-0.1318i,-0.6351-0.4615i,0.6351+0.4615i,0.1815+0.1318i;
            0,0,0,0];
         
PAR.CB(:,:,3)=[  -0.6351+0.4615i,0.1815-0.1318i,-0.1815+0.1318i,0.6351-0.4615i;
            0.1392-0.1759i,0.4873-0.6156i,-0.4873+0.6156i,-0.1392+0.1759i;
            0,0,0,0;
            0,0,0,0];
         
PAR.CB(:,:,4)=[  0,0,0,0;
            0,0,0,0;
            0.7851,-0.2243,0.2243,-0.7851;
            -0.0055-0.2242i,-0.0193-0.7848i,0.0193+0.7848i,0.0055+0.2242i];
 
PAR.CB(:,:,5)=[  -0.0055-0.2242i,-0.0193-0.7848i,0.0193+0.7848i,0.0055+0.2242i;
            0,0,0,0;
            0,0,0,0;
             -0.6351+0.4615i,0.1815-0.1318i,-0.1815+0.1318i,0.6351-0.4615i;];
  
PAR.CB(:,:,6)=[  0,0,0,0;
            0.7851,-0.2243,0.2243,-0.7851;
            0.1392-0.1759i,0.4873-0.6156i,-0.4873+0.6156i,-0.1392+0.1759i;
            0,0,0,0]; 
        
%% AWGN Channel
hChan = comm.AWGNChannel('NoiseMethod', 'Signal to noise ratio (Eb/No)',...
  'SignalPower', 1, 'SamplesPerSymbol', 1,'BitsPerSymbol',2);

%% Initialization
data_source = ceil(rand(PAR.VN,PAR.Data_length)*4);    
data_source_2 = four2two(data_source);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Turbo encoding
% data_source_2 = data_source_2';    %矩阵翻转 以便Turbo编码
% intrlvrIndices = randperm(PAR.Data_length*2);
% hTEnc = comm.TurboEncoder('TrellisStructure',poly2trellis(4, ...
%         [13 15 17],13),'InterleaverIndices',intrlvrIndices);
% hTDec = comm.TurboDecoder('TrellisStructure',poly2trellis(4, ...
%         [13 15 17],13),'InterleaverIndices',intrlvrIndices, ...
%         'NumIterations',4);
%     
% for n = 1:PAR.VN
%     data_TE(:, n) = step(hTEnc, data_source_2(:,n));
% end
% %% SCMA encoding
% data_TE = data_TE';    %矩阵翻转 以便SCMA编码
% data_TE_4 = two2four(data_TE);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PRE_o = scmaEncode(data_source, PAR.CB);

%% addition AWGN and deconding
%PRE = step(hChan, PRE_o);
err_sym_sum(1, length(PAR.EbNo)) = 0;
SER(1, length(PAR.EbNo)) = 0;
for n = 1:length(PAR.EbNo)
    reset(hChan)    
        hChan.EbNo = PAR.EbNo(n);
    PRE = step(hChan, PRE_o);   %AWGN 信道输出
    
    % MPA detect
    [err_sum,demodSignal] = scmaDeML(PAR.CB, PRE, data_source);
%     %Turbo decoding
%     demodSignal2 = (four2two(demodSignal))';
%     for m = 1:PAR.VN
%         receivedBits(:,m) = step(hTDec,demodSignal2(:,m));
%     end
%     receivedBit = receivedBits';
%     demodsignal4 = two2four(receivedBit);
%     err=demodsignal4~=data_source;
%     err_sum_Tb=sum(sum(err));
    
    err_sym_sum(1, n) = err_sum;
    fprintf('EbNo_dB = %d , err_sum = %d \n',PAR.EbNo(n),err_sum);
    SER(1,n)=err_sym_sum(1, n)/PAR.VN/PAR.Data_length;
end

semilogy(PAR.EbNo, SER,'b+-');grid;xlabel('Eb/No (dB)');ylabel('BER');
