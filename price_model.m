clear

%%%% data loading %%%%

display('fetching data')

stats=blockchain_info;
M0=blockchain_info('market-cap');
n_transactions=blockchain_info('n-transactions-excluding-popular');
n_unique_addr=blockchain_info('n-unique-addresses');
miners_revenue=blockchain_info('miners-revenue');
hash_rate=blockchain_info('hash-rate');
market_price=blockchain_info('market-price');
total_bitcoins=blockchain_info('total-bitcoins');

%%%% data cleaning %%%%
display('cleaning data')

% times with all data
M0=M0(800:end-100,:); %ignore very early days
times=intersect(M0(:,1), n_transactions(:,1));
times=intersect(times, n_unique_addr(:,1));
times=intersect(times, hash_rate(:,1));
times=intersect(times, miners_revenue(:,1));
times=intersect(times, market_price(:,1));


% data aligning with times
for i=1:length(times)
    data(i,1)=times(i);
    data(i,2)=M0(find(M0(:,1)==times(i)),2);
    data(i,3)=n_transactions(find(n_transactions(:,1)==times(i)),2);
    data(i,4)=n_unique_addr(find(n_unique_addr(:,1)==times(i)),2);
    data(i,5)=hash_rate(find(hash_rate(:,1)==times(i)),2);
    data(i,6)=miners_revenue(find(miners_revenue(:,1)==times(i)),2);
    data(i,7)=market_price(find(market_price(:,1)==times(i)),2);
end

%%%% data analysis and plotting %%%%
rho=corrcoef(log10(data));


set(0,'DefaultLineLineSmoothing','on')

%%% --- std deviations of model - price

logprice = log10(data(:,2));
logmodel = log10( ( (10^-0.638) * smooth( data(:,3) ,7 ).^2.181 ) );

deviation=logprice-logmodel;


return

display('plotting data')

figure(7);clf
hist(deviation);
std(deviation)



figure(1); clf
plot(log10(smooth(data(:,3))),log10(smooth(data(:,2))),'k.-')
hold on
plot(log10((data(end,3))),log10((data(end,2))),'r*')
xlabel('log_{10} # transactions per day'); ylabel('log_{10} monetary base')
% linear fit, zero intercept
% compare with theoretical t^2 under network value assumption
% fit slope
x=2.2:.1:5.1;
p=polyfit(log10(smooth(data(:,3))),log10(smooth(data(:,2))),1);
alpha=p(1);beta=p(2);
theor_c_tx=(smooth(data(:,3)).^2)\smooth(data(:,2));
plot(x,alpha*x+beta,'r', x,2*x + log10(theor_c_tx),'r--')
% fair value price
fv=((10^beta)*(stats.n_tx^alpha))/(stats.totalbc/1e8);
fvt=theor_c_tx*(stats.n_tx^2)/(stats.totalbc/1e8);
title(['\alpha=' num2str(alpha,4) ', \beta=' num2str(beta,4) ',  fair value=' num2str(fv,4) ',  theoretical= ' num2str(fvt,4) ', c_\theta=' num2str((theor_c_tx)/(stats.totalbc/1e8),4)  ', \rho=' num2str(rho(3,2),4)]);
print -dpng -r300 /tmp/bitcoin-price-n_tx.png

figure(2); clf
plot(log10(smooth(data(:,4))),log10(smooth(data(:,2))),'k.-')
hold on
plot(log10(smooth(data(end,4))),log10(smooth(data(end,2))),'r*')
xlabel('log_{10} # unique addresses per day'); ylabel('log_{10} monetary base')
% fit slope
x=1.5:.1:5.3;
p=polyfit(log10(smooth(data(:,4))),log10(smooth(data(:,2))),1);
alpha=p(1);beta=p(2);
theor_c_ua=(smooth(data(:,4)).^2)\smooth(data(:,2));
plot(x,alpha*x+beta,'r', x,2*x + log10(theor_c_ua),'r--')
% fair value price
fv=((10^beta)*(data(end,4)^alpha))/(stats.totalbc/1e8);
fvt=theor_c_ua*(data(end,4)^2)/(stats.totalbc/1e8);
title(['\alpha=' num2str(alpha,4) ', \beta=' num2str(beta,4) ',  fair value=' num2str(fv,4) ',  theoretical= ' num2str(fvt,4)  ', c_\theta=' num2str((theor_c_ua)/(stats.totalbc/1e8),4) ', \rho=' num2str(rho(4,2),4)]);
print -dpng -r300 /tmp/bitcoin-price-n_ua.png

figure(3); clf
plot(log10(smooth(data(:,3))),log10(smooth(data(:,4))),'k.-')
hold on
plot(log10(smooth(data(end,3))),log10(smooth(data(end,4))),'r*')
ylabel('log_{10} # unique addresses per day'); xlabel('log_{10} # transactions per day')
% fit slope
x=4.2:.1:5.0;
p=polyfit(log10(smooth(data(:,3))),log10(smooth(data(:,4))),1);
alpha=p(1);beta=p(2);
theor_c=(smooth(data(:,3)))\smooth(data(:,4));
plot(x,alpha*x+beta,'r', x, x + log10(theor_c),'r--')
title(['\alpha=' num2str(alpha,4) ', \beta=' num2str(beta,4) ', \rho=' num2str(rho(3,4),4)]);
print -dpng -r300 /tmp/bitcoin-n_tx-n_ua.png

figure(4); clf
plot(log10(smooth(data(:,5))),log10(smooth(data(:,2))),'k.-')
hold on
plot(log10(smooth(data(end,5))),log10(smooth(data(end,2))),'r*')
xlabel('log_{10} # hash rate'); ylabel('log_{10} # monetary base')
% fit slope with intercept
p=polyfit(log10(smooth(data(:,5))),log10(smooth(data(:,2))),1);
alpha=p(1);beta=p(2);
x=4:.1:8.0;
plot(x,alpha*x+beta,'r')
% fair value price
fv=((10^beta)*(data(end,5)^alpha))/(stats.totalbc/1e8);
title(['\alpha=' num2str(alpha,4) ', \beta=' num2str(beta,4) ',  fair value=' num2str(fv,4) ', \rho=' num2str(rho(5,2),4)]);
print -dpng -r300 /tmp/bitcoin-price-hashrate.png

figure(5); clf
plot(log10(smooth(data(:,5))),log10(smooth(data(:,4))),'k.-')
hold on
plot(log10(smooth(data(end,5))),log10(smooth(data(end,4))),'r*')
xlabel('log_{10} # hash rate'); ylabel('log_{10} # transactions per day')
% fit slope with intercept
p=polyfit(log10(smooth(data(:,5))),log10(smooth(data(:,4))),1);
alpha=p(1);beta=p(2);
x=4:.1:8.0;
plot(x,alpha*x+beta,'r')
title(['\alpha=' num2str(alpha,4) ', \beta=' num2str(beta,4) ', \rho=' num2str(rho(5,4),4)]);
print -dpng -r300 /tmp/bitcoin-n_tx-hashrate.png


model_history

