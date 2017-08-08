%% SCMA Encoding
%input -FN:number of function
%      -VN:number of variable
%      -Data_source: the data to mapping resource
%ouput -PRE_o(a.k.a y):sending single
function [PRE_o] = scmaEncode(Data_source,CB)
%获取VN FN M值，m值暂时无用
[m, FN, VN] = size(CB);
%获取数据长度
Data_length = length(Data_source);  
PRE_o=zeros(FN,Data_length);
for data_ind=1:Data_length
    for v=1:VN
        PRE_o(:,data_ind)=PRE_o(:,data_ind)+CB(:,Data_source(v,data_ind),v);
    end   
end

end