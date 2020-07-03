close all; 
%clear all; 
% %addpath ~/plot
Rearth=6371;cp=3993;rho=1025;
if ~exist('v4','var') load 'Data/CCMP.mat'; end
if ~exist('v3','var') load 'Data/ADT.mat'; end
%if ~exist('v3','var') load 'Data/ADT_argo.mat'; end
if ~exist('v2','var') load 'Data/SST.mat'; end
if ~exist('v1','var') load 'Data/ARGO.mat'; end
%if ~exist('v1','var') load 'Data/ARGO_zhj.mat'; end




xx=v2.xx;yy=v2.yy;
%%%%%%%make sure these are correct!
% pcolor(xx,yy,squeeze(v1.var(1,1,:,:)))
 pcolor(xx,yy,squeeze(v2.var(1,:,:)))
% pcolor(xx,yy,squeeze(v3.var(1,:,:)))
% pcolor(xx,yy,squeeze(v4.var1(1,:,:)))
% pcolor(xx,yy,squeeze(v4.var2(1,:,:)))

time=v1.time;
z=v1.z;
% dy=distance(yy(1:end-1,:),xx(1:end-1,:),yy(2:end,:),xx(2:end,:));dy=dy/180*pi*Rearth*1000;
% dx=distance(yy(:,1:end-1),xx(:,1:end-1),yy(:,2:end),xx(:,2:end));dx=dx/180*pi*Rearth*1000;
% dx(:,end+1)=dx(:,end);dy(end+1,:)=dy(end,:);
% 
% 
% [M,N]=size(xx);
% z=v1.z;
% dz=NaN*z;dz(1)=z(1);dz(2:end)=z(2:end)-z(1:end-1);
% dz3d  = repmat(dz,[1 M N]);
% for ll=1:84
%     twork=squeeze(v1.var(ll,:,:,:));
%     v1.ohc20(ll,:,:)=squeeze(sum(twork.*dz3d)).*dx.*dy.*cp.*rho;
% end
ohc=v1.ohc20 - repmat(mean(v1.ohc20),[84 1 1]);
ha=nansum(nansum(ohc,2),3);

dmask=find(~isnan(squeeze(ohc(1,:,:))));

train_label = 73:84;

y=squeeze(v1.var(train_label-12,30,dmask));

%x0=nanzscore(repmat(z,[1 size(y,2) size(y,3)])); %
x1=(nanzscore(v2.va(train_label,dmask)));
x2=(nanzscore(v3.va(train_label-12,dmask)));
x3=(nanzscore(v4.va1(train_label,dmask)));
x4=(nanzscore(v4.va2(train_label,dmask)));
x5=(nanzscore(v4.wa(train_label,dmask)));
x6=repmat(cosd(xx(dmask))',[size(x1,1) 1]);
x7=repmat(nanzscore(yy(dmask))',[size(x1,1) 1]);
X=[x1(:) x2(:) x3(:) x4(:) x5(:) x6(:) x7(:)];
[Y,mu,sigma]=nanzscore(y(:));
return

[net,tr]=drs_run_loop(X,Y,2,20);

test_label = 61:72;
ytest=squeeze(ohc(test_label,dmask))./sigma;
%[test]=deal(nan*zeros([length(test_label),size(ohc,2),size(ohc,3)]));
for ii=1:12
    il=test_label(ii);
    x1=(nanzscore(v2.va(il,dmask)));
    x2=(nanzscore(v3.va(il,dmask)));
    x3=(nanzscore(v4.va1(il,dmask)));
    x4=(nanzscore(v4.va2(il,dmask)));
    x5=(nanzscore(v4.wa(il,dmask)));
    x6=repmat(cosd(xx(dmask))',[size(x1,1) 1]);
    x7=repmat(nanzscore(yy(dmask))',[size(x1,1) 1]);
    
    Xtest=[x1(:) x2(:) x3(:) x4(:) x5(:) x6(:) x7(:)];

    test(ii,:) = net(Xtest');
end

