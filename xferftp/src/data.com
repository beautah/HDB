$ ARCHIVE
OUTPUT=ON
DATA.DAT
DAY=-25
GET BMDC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET CRRC/AF
GET MPRC/AF
CLEAR
GET ECRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET EORU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET LCRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET LMRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET DCRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET PARC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET PVRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN                          ~~~~~
GET RFRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET RKRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET RWRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET SVRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET TPRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET VCRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET JDRU/AF,DUC_CFS,EVAP,FB,IN_CFS,REL_CFS,UNR_CFS,WEB_CFS
CLEAR
GET MAPC/QAVE,QMAX,QMIN
GET MBPC/QAVE,QMAX,QMIN
CLEAR
GET SOMC/QAVE,QMAX,QMIN
GET TBTC/QAVE,QMAX,QMIN
CLEAR
GET ALEC/QAVE,QMAX,QMIN
GET ALTC/QAVE,QMAX,QMIN                                             ~
CLEAR
GET GUNC/QAVE,QMAX,QMIN
GET DELC/QAVE,QMAX,QMIN
CLEAR
GET CCUC/QAVE,QMAX,QMIN
GET LSBC/QAVE,QMAX,QMIN
CLEAR
GET FALC/QAVE,QMAX,QMIN
GET FBLC/QAVE,QMAX,QMIN
CLEAR
GET UNCC/QAVE,QMAX,QMIN
GET WEBU/QAVE,QMAX,QMIN
CLEAR
GET LCCU/QAVE,QMAX,QMIN
GET EASU/QAVE,QMAX,QMIN
CLEAR
GET CLRU/QAVE,QMAX,QMIN
GET GJNC/QAVE,QMAX,QMIN
CLEAR
GET CARU/FB,AF,REL_CFS,IN_CFS
GET DALC/QAVE,QMAX,QMIN
CLEAR
GET GBTC/QAVE,QMAX,QMIN
GET GDCC/QAVE,QMAX,QMIN
CLEAR
GET ORPU/QAVE,QMAX,QMIN
GET UBRC/QAVE,QMAX,QMIN
CLEAR
GET UNDC/QAVE,QMAX,QMIN
GET UNOC/QAVE,QMAX,QMIN
CLEAR
GET URDC/QAVE,QMAX,QMIN
GET WREU/QAVE,QMAX,QMIN
CLEAR
GET WWSU/QAVE,QMAX,QMIN
CLEAR
DAY=+5
GET BMDC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET CRRC/AF
GET MPRC/AF
CLEAR
GET ECRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET EORU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET LCRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET LMRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET DCRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET PARC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET PVRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN                        ~
GET RFRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET RKRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET RWRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET SVRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET TPRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET VCRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET JDRU/AF,DUC_CFS,EVAP,FB,IN_CFS,REL_CFS,UNR_CFS,WEB_CFS
CLEAR
GET MAPC/QAVE,QMAX,QMIN
GET MBPC/QAVE,QMAX,QMIN
CLEAR
GET SOMC/QAVE,QMAX,QMIN
GET TBTC/QAVE,QMAX,QMIN
CLEAR
GET ALEC/QAVE,QMAX,QMIN
GET ALTC/QAVE,QMAX,QMIN                                           ~
CLEAR
GET GUNC/QAVE,QMAX,QMIN
GET DELC/QAVE,QMAX,QMIN
CLEAR
GET CCUC/QAVE,QMAX,QMIN
GET LSBC/QAVE,QMAX,QMIN
CLEAR
GET FALC/QAVE,QMAX,QMIN
GET FBLC/QAVE,QMAX,QMIN
CLEAR
GET UNCC/QAVE,QMAX,QMIN
GET WEBU/QAVE,QMAX,QMIN
CLEAR
GET LCCU/QAVE,QMAX,QMIN
GET EASU/QAVE,QMAX,QMIN
CLEAR
GET CLRU/QAVE,QMAX,QMIN
GET GJNC/QAVE,QMAX,QMIN                                          ~
CLEAR
GET CARU/FB,AF,REL_CFS,IN_CFS
GET DALC/QAVE,QMAX,QMIN
CLEAR
GET GBTC/QAVE,QMAX,QMIN
GET GDCC/QAVE,QMAX,QMIN
CLEAR
GET ORPU/QAVE,QMAX,QMIN
GET UBRC/QAVE,QMAX,QMIN
CLEAR
GET UNDC/QAVE,QMAX,QMIN
GET UNOC/QAVE,QMAX,QMIN
CLEAR
GET URDC/QAVE,QMAX,QMIN
GET WREU/QAVE,QMAX,QMIN
CLEAR
GET WWSU/QAVE,QMAX,QMIN
CLEAR
DAY=+5
GET BMDC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET CRRC/AF
GET MPRC/AF
CLEAR
GET ECRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET EORU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET LCRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET LMRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET DCRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET PARC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET PVRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN                     ~
GET RFRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET RKRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET RWRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET SVRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET TPRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET VCRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET JDRU/AF,DUC_CFS,EVAP,FB,IN_CFS,REL_CFS,UNR_CFS,WEB_CFS
CLEAR
GET MAPC/QAVE,QMAX,QMIN
GET MBPC/QAVE,QMAX,QMIN
CLEAR
GET SOMC/QAVE,QMAX,QMIN
GET TBTC/QAVE,QMAX,QMIN
CLEAR
GET ALEC/QAVE,QMAX,QMIN
GET ALTC/QAVE,QMAX,QMIN
CLEAR
GET GUNC/QAVE,QMAX,QMIN
GET DELC/QAVE,QMAX,QMIN
CLEAR
GET CCUC/QAVE,QMAX,QMIN
GET LSBC/QAVE,QMAX,QMIN
CLEAR
GET FALC/QAVE,QMAX,QMIN
GET FBLC/QAVE,QMAX,QMIN
CLEAR
GET UNCC/QAVE,QMAX,QMIN
GET WEBU/QAVE,QMAX,QMIN
CLEAR
GET LCCU/QAVE,QMAX,QMIN
GET EASU/QAVE,QMAX,QMIN
CLEAR
GET CLRU/QAVE,QMAX,QMIN
GET GJNC/QAVE,QMAX,QMIN                                        ~
CLEAR
GET CARU/FB,AF,REL_CFS,IN_CFS
GET DALC/QAVE,QMAX,QMIN
CLEAR
GET GBTC/QAVE,QMAX,QMIN
GET GDCC/QAVE,QMAX,QMIN
CLEAR
GET ORPU/QAVE,QMAX,QMIN
GET UBRC/QAVE,QMAX,QMIN
CLEAR
GET UNDC/QAVE,QMAX,QMIN
GET UNOC/QAVE,QMAX,QMIN
CLEAR
GET URDC/QAVE,QMAX,QMIN
GET WREU/QAVE,QMAX,QMIN
CLEAR
GET WWSU/QAVE,QMAX,QMIN
CLEAR
DAY=+5
GET BMDC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET CRRC/AF
GET MPRC/AF
CLEAR
GET ECRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET EORU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET LCRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET LMRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET DCRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET PARC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET PVRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET RFRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET RKRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET RWRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET SVRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET TPRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET VCRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET JDRU/AF,DUC_CFS,EVAP,FB,IN_CFS,REL_CFS,UNR_CFS,WEB_CFS
CLEAR
GET MAPC/QAVE,QMAX,QMIN
GET MBPC/QAVE,QMAX,QMIN
CLEAR
GET SOMC/QAVE,QMAX,QMIN
GET TBTC/QAVE,QMAX,QMIN
CLEAR
GET ALEC/QAVE,QMAX,QMIN
GET ALTC/QAVE,QMAX,QMIN
CLEAR
GET GUNC/QAVE,QMAX,QMIN
GET DELC/QAVE,QMAX,QMIN
CLEAR
GET CCUC/QAVE,QMAX,QMIN
GET LSBC/QAVE,QMAX,QMIN
CLEAR
GET FALC/QAVE,QMAX,QMIN
GET FBLC/QAVE,QMAX,QMIN
CLEAR
GET UNCC/QAVE,QMAX,QMIN
GET WEBU/QAVE,QMAX,QMIN
CLEAR
GET LCCU/QAVE,QMAX,QMIN
GET EASU/QAVE,QMAX,QMIN
CLEAR
GET CLRU/QAVE,QMAX,QMIN
GET GJNC/QAVE,QMAX,QMIN
CLEAR
GET CARU/FB,AF,REL_CFS,IN_CFS
GET DALC/QAVE,QMAX,QMIN
CLEAR
GET GBTC/QAVE,QMAX,QMIN
GET GDCC/QAVE,QMAX,QMIN
CLEAR
GET ORPU/QAVE,QMAX,QMIN
GET UBRC/QAVE,QMAX,QMIN
CLEAR
GET UNDC/QAVE,QMAX,QMIN
GET UNOC/QAVE,QMAX,QMIN
CLEAR
GET URDC/QAVE,QMAX,QMIN
GET WREU/QAVE,QMAX,QMIN
CLEAR
GET WWSU/QAVE,QMAX,QMIN
CLEAR
DAY=+5
GET BMDC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET CRRC/AF
GET MPRC/AF
CLEAR
GET ECRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET EORU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET LCRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET LMRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET DCRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET PARC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET PVRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET RFRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET RKRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET RWRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET SVRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET TPRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET VCRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET JDRU/AF,DUC_CFS,EVAP,FB,IN_CFS,REL_CFS,UNR_CFS,WEB_CFS
CLEAR
GET MAPC/QAVE,QMAX,QMIN
GET MBPC/QAVE,QMAX,QMIN
CLEAR
GET SOMC/QAVE,QMAX,QMIN
GET TBTC/QAVE,QMAX,QMIN
CLEAR
GET ALEC/QAVE,QMAX,QMIN
GET ALTC/QAVE,QMAX,QMIN
CLEAR
GET GUNC/QAVE,QMAX,QMIN
GET DELC/QAVE,QMAX,QMIN
CLEAR
GET CCUC/QAVE,QMAX,QMIN
GET LSBC/QAVE,QMAX,QMIN
CLEAR
GET FALC/QAVE,QMAX,QMIN
GET FBLC/QAVE,QMAX,QMIN
CLEAR
GET UNCC/QAVE,QMAX,QMIN
GET WEBU/QAVE,QMAX,QMIN
CLEAR
GET LCCU/QAVE,QMAX,QMIN
GET EASU/QAVE,QMAX,QMIN
CLEAR
GET CLRU/QAVE,QMAX,QMIN
GET GJNC/QAVE,QMAX,QMIN
CLEAR
GET CARU/FB,AF,REL_CFS,IN_CFS
GET DALC/QAVE,QMAX,QMIN
CLEAR
GET GBTC/QAVE,QMAX,QMIN
GET GDCC/QAVE,QMAX,QMIN
CLEAR
GET ORPU/QAVE,QMAX,QMIN
GET UBRC/QAVE,QMAX,QMIN
CLEAR
GET UNDC/QAVE,QMAX,QMIN
GET UNOC/QAVE,QMAX,QMIN
CLEAR
GET URDC/QAVE,QMAX,QMIN
GET WREU/QAVE,QMAX,QMIN
CLEAR
GET WWSU/QAVE,QMAX,QMIN
CLEAR
DAY=+5
GET BMDC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET CRRC/AF
GET MPRC/AF
CLEAR
GET ECRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET EORU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET LCRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET LMRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET DCRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET PARC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET PVRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET RFRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET RKRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET RWRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET SVRU/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET TPRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
CLEAR
GET VCRC/FB,AF,REL_CFS,IN_CFS,DPC,TMAX,TMIN
GET JDRU/AF,DUC_CFS,EVAP,FB,IN_CFS,REL_CFS,UNR_CFS,WEB_CFS
CLEAR
GET MAPC/QAVE,QMAX,QMIN
GET MBPC/QAVE,QMAX,QMIN
CLEAR
GET SOMC/QAVE,QMAX,QMIN
GET TBTC/QAVE,QMAX,QMIN
CLEAR
GET ALEC/QAVE,QMAX,QMIN
GET ALTC/QAVE,QMAX,QMIN
CLEAR
GET GUNC/QAVE,QMAX,QMIN
GET DELC/QAVE,QMAX,QMIN
CLEAR
GET CCUC/QAVE,QMAX,QMIN
GET LSBC/QAVE,QMAX,QMIN
CLEAR
GET FALC/QAVE,QMAX,QMIN
GET FBLC/QAVE,QMAX,QMIN
CLEAR
GET UNCC/QAVE,QMAX,QMIN
GET WEBU/QAVE,QMAX,QMIN
CLEAR
GET LCCU/QAVE,QMAX,QMIN
GET EASU/QAVE,QMAX,QMIN
CLEAR
GET CLRU/QAVE,QMAX,QMIN
GET GJNC/QAVE,QMAX,QMIN
CLEAR
GET CARU/FB,AF,REL_CFS,IN_CFS
GET DALC/QAVE,QMAX,QMIN
CLEAR
GET GBTC/QAVE,QMAX,QMIN
GET GDCC/QAVE,QMAX,QMIN
CLEAR
GET ORPU/QAVE,QMAX,QMIN
GET UBRC/QAVE,QMAX,QMIN
CLEAR
GET UNDC/QAVE,QMAX,QMIN
GET UNOC/QAVE,QMAX,QMIN
CLEAR
GET URDC/QAVE,QMAX,QMIN
GET WREU/QAVE,QMAX,QMIN
CLEAR
GET WWSU/QAVE,QMAX,QMIN
CLEAR
OUTPUT=OFF
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       