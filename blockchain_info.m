% returns data via blockchain.info json API

function data=blockchain_info(varargin)

    addpath jsonlab

    if nargin==0
        url='http://blockchain.info/stats?format=json';
        json=urlread(url);
        data=loadjson(json);
    else

        chart_key=varargin{1};
        display(['Fetching ' chart_key])

        fname=['/tmp/' chart_key '.json'];
        url=['http://blockchain.info/charts/' chart_key '?format=json&timespan=all'];

        if exist(fname)~=2
            display(['querying blockchain.info API for ' chart_key])
            urlwrite(url, fname);
        end

        tmp=loadjson(fname); % time; data
        tmp=tmp.values;
        data=nan*zeros(length(tmp),2);
        for j=1:length(tmp)
            data(j,1)=tmp{j}.x;
            data(j,2)=tmp{j}.y;
        end

    end
