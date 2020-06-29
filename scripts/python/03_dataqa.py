
# coding: utf-8

# In[ ]:


import pandas, numpy, subprocess


# In[ ]:


import geopandas


# In[ ]:


df = pandas.read_csv("exportingv7.csv", dtype={
                                                                                "time_bnk_car":numpy.float64,
                                                                                "time_bnk_foot":numpy.float64,
                                                                                "time_bnk_pt":numpy.float64,
                                                                                "time_cc_car":numpy.float64,
                                                                                "time_cc_foot":numpy.float64,
                                                                                "time_cc_pt":numpy.float64,
                                                                                "weighted_time_bnk_car":numpy.float64,
                                                                                "weighted_time_bnk_foot":numpy.float64,
                                                                                "weighted_time_bnk_pt":numpy.float64,
                                                                                "weighted_time_cc_car":numpy.float64,
                                                                                "weighted_time_cc_foot":numpy.float64,
                                                                                "weighted_time_cc_pt":numpy.float64,
                                                                                "CITYNAME":str,
                                                                                "B17021_001E_2015":numpy.float64,
                                                                                "B17021_002E_2015":numpy.float64,
                                                                                "B03002_001E_2015":numpy.float64,
                                                                                "B03002_003E_2015":numpy.float64,
                                                                                "B03002_004E_2015":numpy.float64,
                                                                                "B03002_006E_2015":numpy.float64,
                                                                                "B03002_012E_2015":numpy.float64,
                                                                                "B25008_001E_2015":numpy.float64,
                                                                                "B25008_003E_2015":numpy.float64,
                                                                                "B99051_001E_2015":numpy.float64,
                                                                                "B99051_005E_2015":numpy.float64,
                                                                                "B99051_006E_2015":numpy.float64,
                                                                                "B99051_007E_2015":numpy.float64,
    
                                                                                "B15003_001E_2015":numpy.float64,
                                                                                "B15003_022E_2015":numpy.float64,
                                                                                "B15003_023E_2015":numpy.float64,
                                                                                "B15003_024E_2015":numpy.float64,
                                                                                "B15003_025E_2015":numpy.float64,
#                                                                                 "B25010_001E_2015":numpy.float64,
#                                                                                 "B25010_002E_2015":numpy.float64,
    
    
#                                                                                 "B25010_003E_2015":numpy.float64,
                                                                                "B25036_001E_2015":numpy.float64,
                                                                                "B25036_012E_2015":numpy.float64,
                                                                                "B25036_011E_2015":numpy.float64,
                                                                                "B25036_010E_2015":numpy.float64,
                                                                                "B25036_009E_2015":numpy.float64,
                                                                                "B25036_008E_2015":numpy.float64,
                                                                                "B25036_007E_2015":numpy.float64,
    
                                        
                                                                                "B25036_006E_2015":numpy.float64,
                                                                                "B25036_023E_2015":numpy.float64,
                                                                                "B25036_022E_2015":numpy.float64,
                                                                                "B25036_021E_2015":numpy.float64,
                                                                                "B25036_020E_2015":numpy.float64,
                                                                                "B25036_019E_2015":numpy.float64,
                                                                                "B25036_018E_2015":numpy.float64,
                                                                                "B25036_017E_2015":numpy.float64,

                                                                                "B25001_001E_2015":numpy.float64,
                                                                                "B25004_001E_2015":numpy.float64,
                                                                                "B25010_001E_2015":numpy.float64,
                                                                                "B25010_002E_2015":numpy.float64,
                                                                                "B25010_003E_2015":numpy.float64,
    
    
    
                                                                                "B23025_004E_2015":numpy.float64,
                                                                                "B23025_005E_2015":numpy.float64,
                                                                                "B23025_003E_2015":numpy.float64,
    
                                                                                "B17021_001E_2010":numpy.float64,
                                                                                "B17021_002E_2010":numpy.float64,
                                                                                "B03002_001E_2010":numpy.float64,
                                                                                "B03002_003E_2010":numpy.float64,
                                                                                "B03002_004E_2010":numpy.float64,
                                                                                "B03002_006E_2010":numpy.float64,
                                                                                "B03002_012E_2010":numpy.float64,
                                                                                "B25008_001E_2010":numpy.float64,
                                                                                "B25008_003E_2010":numpy.float64,
                                                                                "B99051_001E_2010":numpy.float64,
                                                                                "B99051_005E_2010":numpy.float64,
                                                                                "B99051_006E_2010":numpy.float64,
                                                                                "B99051_007E_2010":numpy.float64,
                                                                                "GEOID":str,
                                                                                "PCOUNT":numpy.float64 })


# In[ ]:


cols = df.columns


# In[ ]:


gdf = geopandas.read_file("shapefiles/aalblockgroups.shp")


# In[ ]:


gdf['area'] = gdf['geometry'].to_crs(epsg=3857).area / 10**6


# In[ ]:


gdf["geoid"] = gdf["geoid"].astype("str")


# In[ ]:


gdf["geoid"] = gdf["geoid"].apply(lambda x: x.zfill(12))


# In[ ]:


df["geoid"]= df["GEOID"].apply(lambda x: x.zfill(12))


# In[ ]:


df.set_index("geoid", inplace=True)


# In[ ]:


gdf.set_index("geoid", inplace=True)


# In[ ]:


def safeDiffrence(p15,p10):
    if p10 == 0 and p15 !=0:
        return numpy.log(p15) - numpy.log(1)
    elif p10 != 0 and p15 == 0:
        return numpy.log(1) - numpy.log(p10)
    elif p10 == 0 and p15 == 0:
        return 0
    else:
        return numpy.log(p15) - numpy.log(p10)
def safePerCapita(pc, p15):
    if p15 == 0:
        return pc / 1000
    else:
        return pc / (p15 * 1000)
def safePropOwner(rnt, totl):
    return 1 - (rnt / (totl+1))

def safeDevide(row1, row2):
    if row2 == 0 and row1 !=0:
        return row1
    elif row2 == 0 and row1 == 0:
        return 1
    else:
        return row1/row2


# In[ ]:


df["WHT15"] = df["B03002_003E_2015"] / df["B03002_001E_2015"]
df["BLC15"] = df["B03002_004E_2015"] / df["B03002_001E_2015"]
df["LAT15"] = df["B03002_012E_2015"] / df["B03002_001E_2015"]
df["ASIA15"] = df["B03002_006E_2015"] / df["B03002_001E_2015"]

df["OWN15"] = df.apply(lambda row: safePropOwner(row["B25008_003E_2015"], row["B25008_001E_2015"]), axis=1)  

df["POV15"] = df["B17021_002E_2015"] / df["B17021_001E_2015"]
df["FRN15"] = df["B99051_005E_2015"] / df["B99051_001E_2015"]

df["UMP15"]  = df["B23025_005E_2015"] / (df["B23025_004E_2015"] + df["B23025_005E_2015"])

df["EDU15"] = ( df["B15003_022E_2015"]  +  df["B15003_023E_2015"]  +  df["B15003_024E_2015"]  +  df["B15003_025E_2015"] ) / df["B15003_001E_2015"] 

df["BLB00"] = ((df["B25036_012E_2015"] + df["B25036_011E_2015"] + df["B25036_010E_2015"] + df["B25036_009E_2015"] + df["B25036_008E_2015"] + df["B25036_007E_2015"] + df["B25036_006E_2015"]) + (df["B25036_023E_2015"] + df["B25036_022E_2015"] + df["B25036_021E_2015"] + df["B25036_020E_2015"] + df["B25036_019E_2015"] + df["B25036_018E_2015"] + df["B25036_017E_2015"])) / df["B25036_001E_2015"]
df["HU15"] = df["B25001_001E_2015"]
df["HU15"] = df["B25001_001E_2015"]

df["VACRAT15"]  = df["B25004_001E_2015"] / df["B25001_001E_2015"]
df["POPCHRT1015"] = (df["B03002_001E_2015"] - df["B03002_001E_2010"]) / df["B03002_001E_2010"]
df["POPCHG_NATLOG1015"] = df.apply(lambda row: safeDiffrence(row["B03002_001E_2015"], row["B03002_001E_2010"]), axis=1)
df["POPDEN_NATLOG15"] = df["B03002_001E_2015"].apply(lambda x: numpy.log(x) if x != 0 else numpy.log(1)) 
df["COMDENPERCAPT"] = df.apply(lambda row: safePerCapita(row["PCOUNT"], row["B25004_001E_2015"]), axis=1)  


# In[ ]:


def diffPTfixwithFoot(bnk_pt, cc_pt, bnk_foot, cc_foot):   
        
    if bnk_pt == 0 or bnk_pt is None or bnk_pt == "NaN" or bnk_pt == "" or bnk_pt == "nan" or numpy.isnan(bnk_pt):
        if bnk_foot >= 0:
            bnk = bnk_foot / 60000
        else:
            bnk = 0
    else:
        bnk = bnk_pt/60
    if cc_pt == 0 or cc_pt is None or cc_pt == "NaN" or cc_pt == "" or cc_pt == "nan" or numpy.isnan(cc_pt):
        if cc_foot >= 0:
            cc = cc_foot / 60000
        else:
            cc = 0
    else:
        
        cc = cc_pt/60
    print(bnk, cc)
    return bnk - cc
    
    
def ratioPTfixwithFoot(bnk_pt, cc_pt, bnk_foot, cc_foot):   
        
    if bnk_pt == 0 or bnk_pt is None or bnk_pt == "NaN" or bnk_pt == "" or bnk_pt == "nan" or numpy.isnan(bnk_pt):
        if bnk_foot >= 0:
            bnk = bnk_foot / 60000
        else:
            bnk = 0
    else:
        bnk = bnk_pt/60
    if cc_pt == 0 or cc_pt is None or cc_pt == "NaN" or cc_pt == "" or cc_pt == "nan" or numpy.isnan(cc_pt):
        if cc_foot >= 0:
            cc = cc_foot / 60000
        else:
            cc = 0
    else:
        
        cc = cc_pt/60
    print(bnk, cc)
    return (bnk + 0.00001)/ (cc + 0.00001)
    


# In[ ]:


df = df.drop_duplicates("GEOID")


# In[ ]:


gdf = gdf.join(mdf)


# In[ ]:


gdf["HUDEN"] = gdf["HU15"]/ gdf["area"]


# In[ ]:


mdf.insert(0, 'pid', range(1, 1 + len(mdf)))


# In[ ]:


pandas.DataFrame(gdf).to_csv("exporting_718.csv")


# In[ ]:


gdf.to_file("shapefiles/ratioacsalblockgroupsv717.shp")

