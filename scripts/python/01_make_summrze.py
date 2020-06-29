
# coding: utf-8

# In[ ]:


import pandas
import os
import subprocess
def fixBlockId(bid):
    if len(bid) == 14:
        ret = "0{0}".format(bid)
    else:
        ret = "{0}".format(bid)
    return ret

def fizGeoid(gid):
    if len(gid) == 11:
        ret = "0{0}".format(gid)
    else:
        ret = "{0}".format(gid)
    return ret

def prcPov(acsdictret):
    return float(acsdictret["B17017_002E"]) 

def getBlockPop(gid):
    ddff = blockpop_lookup.loc[[f"{gid}"]]["POP10"].tolist()[0]
    return ddff

def makeSafeProp(ta1,ta2):
    if ta1 == 0:
        return 0
    elif ta2 == 0:
        return 'NA'
    else:
        return "{0}".format(ta1/ta2)
def minimumForBlocksAverageBlockGroups():
    for c in csvs:
        c_file = c.decode("utf-8")
        df = pandas.read_csv("{0}/{1}".format(data_dir,c_file))
        df["bl1"] = df["geoid"].astype(str)
        df["bl"] = df["bl1"].apply(fixBlockId)
        dfbl = df.groupby("bl", as_index=False)
        minblodf = dfbl.min()
        minblodf["blg"] = minblodf["bl"].apply(lambda x: x[:12])
        dfbl = minblodf.groupby("blg", as_index=False)
        avergdf = dfbl.mean()
        avergdf["blg"] = avergdf["blg"].apply(fizGeoid)
        avergdf.to_csv("{0}/{1}_min_bl_avr_bg.csv".format(avg_blg_min_bkl,c_file.replace(".csv","")))
blockpop_lookup = pandas.read_csv("block_pop_states_lookup.csv",usecols=["BLOCKID10","POP10"])
blockpop_lookup["BLOCKID10"] = blockpop_lookup["BLOCKID10"].astype(str)
blockpop_lookup["BLOCKID10"] = blockpop_lookup["BLOCKID10"].apply(fixBlockId)
blockpop_lookup = blockpop_lookup.set_index(["BLOCKID10"])
avg_blg_min_bkl = "avg_blg_min_bkl"
data_dir = "_all_data"
analysis_dir = "analysis"
def fixBlockId(bid):
    if len(bid) == 14:
        ret = "0{0}".format(bid)
    else:
        ret = "{0}".format(bid)
    return ret


r = subprocess.check_output(["ls"], cwd=data_dir)

city_names = [
        "el_paso",
        "new_york",    
        "los_angeles",
        "detroit",
        "philadelphia",
        "phoenix",
        "san_antonio",
        "san_diego",
        "dallas",
        "san_jose",
        "austin",
        "jacksonville",
        "indianapolis",
        "san_francisco",
        "columbus",
        "fort_worth",
        "chicago",
        "memphis",
        "houston",
        "boston"
        ]
csvs = r.split()
MODEs=["car","foot","pt"]
all_mdfs = []
def fixBlockId(bid):
    if len(bid) == 14:
        ret = "0{0}".format(bid)
    else:
        ret = "{0}".format(bid)
    return ret

def fizGeoid(gid):
    if len(gid) == 11:
        ret = "0{0}".format(gid)
    else:
        ret = "{0}".format(gid)
    return ret

def prcPov(acsdictret):
    return float(acsdictret["B17017_002E"]) 

def getBlockPop(gid):
    ddff = blockpop_lookup.loc[[f"{gid}"]]["POP10"].tolist()[0]
    return ddff

def makeSafeProp(ta1,ta2):
    if ta1 == 0:
        return 0
    elif ta2 == 0:
        return 'NA'
    else:
        return "{0}".format(ta1/ta2)
def minimumForBlocksAverageBlockGroups():
    for c in csvs:
        c_file = c.decode("utf-8")
        df = pandas.read_csv("{0}/{1}".format(data_dir,c_file))
        df["bl1"] = df["geoid"].astype(str)
        df["bl"] = df["bl1"].apply(fixBlockId)

        dfbl = df.groupby("bl", as_index=False)
        minblodf = dfbl.min()
        minblodf["blg"] = minblodf["bl"].apply(lambda x: x[:12])
        dfbl = minblodf.groupby("blg", as_index=False)
        avergdf = dfbl.mean()
        avergdf["blg"] = avergdf["blg"].apply(fizGeoid)
        avergdf.to_csv("{0}/{1}_min_bl_avr_bg.csv".format(avg_blg_min_bkl,c_file.replace(".csv","")))


def nakeRatioFiles(CITYNAME):
    all_mdfs = []
    unw_all_mdfs = []
    for MODE in MODEs:
        if MODE in ["car","foot"]:
            ccc_file = "res_check_cashings_{0}_blocks_within_{0}_{1}.csv".format(CITYNAME, MODE)
            bnkc_file = "res_banks_{0}_blocks_within_{0}_{1}.csv".format(CITYNAME, MODE)
        else:
            ccc_file = "res_check_cashing_{1}_{0}_blocks_within_{0}_{1}.csv".format(CITYNAME, MODE)
            bnkc_file = "res_bank_{1}_{0}_blocks_within_{0}_{1}.csv".format(CITYNAME, MODE)
        bnk_df = pandas.read_csv("{0}/{1}".format(data_dir,bnkc_file))
        cc_df = pandas.read_csv("{0}/{1}".format(data_dir,ccc_file))
        bnk_df = bnk_df.loc[bnk_df["time"]>0,]
        cc_df = cc_df.loc[cc_df["time"]>0,]

        bnk_df["bl1"] = bnk_df["geoid"].astype(str)
        bnk_df["bl"] = bnk_df["bl1"].apply(fixBlockId)    
        bnk_dfbl = bnk_df.groupby("bl", as_index=False)
        bnk_minblodf = bnk_dfbl.min()
        bnk_minblodf["blg"] = bnk_minblodf["bl"].apply(lambda x: x[:12])
        
        def getCensusT(bl):
            sql = "select * from {0} where geoid like '{1}';"
            popdf= pandas.read_sql_query(sqlalchemy.text(sql.format("blocks",bl)),con=engine)

        bnk_minblodf['blockpop'] = bnk_minblodf["bl"].apply(getBlockPop)
        bnk_minblodf['weighted_time'] = bnk_minblodf['time'] * bnk_minblodf['blockpop'] 
        bnk_minblodf['weighted_time'] = bnk_minblodf['weighted_time'].astype(float)

        f = {'weighted_time': {'weighted_time_sum' : 'sum'}, 'blockpop': {'sum_pop': 'sum'} }

        bnk_dfbl = bnk_minblodf.groupby("blg", as_index=False)
        unw_bnk_avergdf = bnk_dfbl.mean()
        unw_bnk_avergdf["blg"] = unw_bnk_avergdf["blg"].apply(fizGeoid)
        
        
        cc_df["bl1"] = cc_df["geoid"].astype(str)
        cc_df["bl"] = cc_df["bl1"].apply(fixBlockId)

        cc_dfbl = cc_df.groupby("bl", as_index=False)
        cc_minblodf = cc_dfbl.min()
        cc_minblodf["blg"] = cc_minblodf["bl"].apply(lambda x: x[:12])
    
        cc_minblodf['blockpop'] = cc_minblodf["bl"].apply(getBlockPop)
        cc_minblodf['weighted_time'] = cc_minblodf['time'] * cc_minblodf['blockpop'] 
        
        cc_minblodf['weighted_time'] = cc_minblodf['weighted_time'].astype(float)
        

        cc_dfbl = cc_minblodf.groupby("blg", as_index=False)
        unw_cc_avergdf = cc_dfbl.mean()
        unw_cc_avergdf["blg"] = unw_cc_avergdf["blg"].apply(fizGeoid)
        

        
        unw_mdf = pandas.merge(left=unw_bnk_avergdf,right=unw_cc_avergdf,on="blg",suffixes=('_bnk','_cc'))
        unw_rat__ = "BNK_CC_{0}".format(MODE.upper())
        unw_mdf[unw_rat__] = unw_mdf["time_bnk"] / unw_mdf["time_cc"]
        unw_mdf["TM_BNK_{0}".format(MODE.upper())] = unw_mdf["time_bnk"] 
        unw_mdf["TM_CC_{0}".format(MODE.upper())] =unw_mdf["time_cc"]
        
        unw_all_mdfs.append(unw_mdf)
 
    
    unw_mode1 = unw_all_mdfs[0]
    unw_mode2 = unw_all_mdfs[1]
    unw_mode3 = unw_all_mdfs[2]
    
    unw_m1 = pandas.merge(left=unw_mode1,right=unw_mode2,on='blg',suffixes=("_{0}".format(MODEs[0]),"_{0}".format(MODEs[1])), how="outer")
    unw_m2 = pandas.merge(left=unw_m1,right=unw_mode3,on='blg',suffixes=("_","_{0}".format(MODEs[2])), how="outer")
    os.system("rm -rf {0}/fin/{1}_ratios_min_un_weightmean2.csv".format(analysis_dir,CITYNAME))
    unw_m2.to_csv("{0}/fin/{1}_ratios_min_un_weightmean2.csv".format(analysis_dir,CITYNAME))


# In[ ]:


r2 = subprocess.check_output(["ls"], cwd=avg_blg_min_bkl)
csvs2 = r2.split()

for city in city_names:
    
    nakeRatioFiles(city)


# In[ ]:


mfile = csvs2.pop(0)
md = mfile.decode("utf-8")
mdf = pandas.read_csv("{0}/{1}".format(data_dir,md))
md = md.replace("_ratios_min_un_weightmean.csv","")
mdf["CITYNAME"] = f"{md}"


# In[ ]:


mdf.to_csv("{0}/{1}".format(data_dir,"merged_fin.csv"))

