%×öÉ¢µã
t=1993:1/12:2019;
t=t(1:end-1);
int10=std(SegTrend(t,ohc_int,120)); %60 months = 5 years
inp10=std(SegTrend(t,ohc_inp,120));
int5=std(SegTrend(t,ohc_int,60)); %60 months = 5 years
inp5=std(SegTrend(t,ohc_inp,60));
%
att10=std(SegTrend(t,ohc_att,120)); %60 months = 5 years
atp10=std(SegTrend(t,ohc_atp,120));
att5=std(SegTrend(t,ohc_att,60)); %60 months = 5 years
atp5=std(SegTrend(t,ohc_atp,60));
%
pat10=std(SegTrend(t,ohc_pat,120)); %60 months = 5 years
pap10=std(SegTrend(t,ohc_pap,120));
pat5=std(SegTrend(t,ohc_pat,60)); %60 months = 5 years
pap5=std(SegTrend(t,ohc_pap,60));
%
sot10=std(SegTrend(t,ohc_sot,120)); %60 months = 5 years
sop10=std(SegTrend(t,ohc_sop,120));
sot5=std(SegTrend(t,ohc_sot,60)); %60 months = 5 years
sop5=std(SegTrend(t,ohc_sop,60));
IAP30010=[int10 att10 pat10 sot10];
IAP3005=[int5 att5 pat5 sot5];
OPEN30010=[inp10 atp10 pap10 sop10];
OPEN3005=[inp5 atp5 pap5 sop5];