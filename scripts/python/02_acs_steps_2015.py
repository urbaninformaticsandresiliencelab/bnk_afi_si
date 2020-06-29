
# coding: utf-8

# In[ ]:


import pandas
import subprocess
import zipfile


# In[ ]:


ACS_5yr_Seq_Table_Number_Lookup = pandas.read_excel("../../reference_files/ACS_5yr_Seq_Table_Number_Lookup.xls")
ACS_5yr_Seq_Table_Number_Lookup["Sequence Number"] = ACS_5yr_Seq_Table_Number_Lookup["Sequence Number"].apply(lambda x: f"{x}".zfill(4))
ACS_5yr_Seq_Table_Number_Lookup["Line Number"] = ACS_5yr_Seq_Table_Number_Lookup["Line Number"].apply(lambda x: x if pandas.isna(x) else f"{int(x)}".replace(".0",""))


# ### A.

# In[ ]:


def getFile(state_abr, url,fnm,seq_num,var_name,var_postion,line_num):   
    all_gfiles_name = "../../reference_files/5_year_Mini_Geo.xlsx"    
    completed = subprocess.run(['mkdir',f"{WORKING_DIR}/{state_abr}"],stdout=subprocess.PIPE)
    print('returncode:', completed.returncode)
    print('Have {} bytes in stdout:\n{}'.format(len(completed.stdout),completed.stdout.decode('utf-8')))
    print(url)
    completed = subprocess.run(['wget', '-O' ,f"{WORKING_DIR}/{state_abr}/{fnm}", "--connect-timeout=5", f"{url}"],stdout=subprocess.PIPE)
    print('returncode:', completed.returncode)
    print('Have {} bytes in stdout:\n{}'.format(len(completed.stdout),completed.stdout.decode('utf-8')))
    print(f"{WORKING_DIR}/{state_abr}/{fnm}")
    zf = zipfile.ZipFile(f"{WORKING_DIR}/{state_abr}/{fnm}")
    fsize = sum([zinfo.file_size for zinfo in  zf.filelist])
    zip_kb = float(fsize)/1000 #kB
    print("file_size",zip_kb)


# In[ ]:


rslst = []
WORKING_DIR = "../../reference_files/"
var_names=[
            'B17021_001E',
            'B17021_002E',
            'B03002_001E',
            'B03002_003E',
            'B03002_004E',
            'B03002_006E',
            'B03002_012E',
            'B25008_001E',
            'B25008_003E',
            'B99051_001E',
            'B99051_005E',
            'B99051_006E',
            'B99051_007E',
            'B15003_001E',
            'B15003_022E',
            'B15003_023E',
            'B15003_024E',
            'B15003_025E',
    
            'B25010_001E', # average housing unit size (for occupied hunits)
            'B25010_002E',
            'B25010_003E',
    
            'B25036_001E', # by year structure was built (for occupied hunits)
            'B25036_012E',
            'B25036_011E',
            'B25036_010E',
            'B25036_009E',
            'B25036_008E',
            'B25036_007E',
            'B25036_006E',
    
            'B25036_023E',
            'B25036_022E',
            'B25036_021E',
            'B25036_020E',
            'B25036_019E',
            'B25036_018E',
            'B25036_017E',
    
            'B23025_004E', # emplynt
            'B23025_005E',
            'B23025_003E',
    
    
            'B25001_001E', # housing units (total)
            'B25004_001E' # vacant units
    
            ]

state_code_abbr = pandas.read_csv(f"{WORKING_DIR}/state.txt", delimiter='|', dtype={"STATE_NAME":str,"STUSAB":str,"STATE":str},index_col=False)
state_code_abbr["STATE"] = state_code_abbr["STATE"].apply(lambda x: x.zfill(2))
ratiodf = pandas.read_csv(f"{WORKING_DIR}/merged_fin.csv",dtype={"blg":str})
ratiodf["blg"] = ratiodf["blg"].apply(lambda x: f"{x}".zfill(12))
ratiodf['blg'] = ratiodf['blg'].apply(lambda x: f"{x}".zfill(12))
# get a list of states and get all the data for them
ratiodf["state_code"] = ratiodf['blg'].apply(lambda x: f"{x}"[:2])
ratiodf = ratiodf.loc[ratiodf["state_code"]!="00",]
for state_code in ratiodf.groupby("state_code", as_index=False).min()["state_code"].unique(): #[:4]
    STATEABBR = state_code_abbr.loc[state_code_abbr["STATE"]==state_code,]["STUSAB"].values[0]
    STATENAME = state_code_abbr.loc[state_code_abbr["STATE"]==state_code,]["STATE_NAME"].values[0]
    if f"{STATEABBR}" in files_inventrory:
        pass
    else:
        files_inventrory.update({f"{STATEABBR}":{}})
    stateabbr = STATEABBR
    state_ratiodf = ratiodf.loc[ratiodf["state_code"]==state_code,["blg","CITYNAME","state_code","GEO_blg"]]
    for VARNAME in var_names:
        varname = VARNAME
        url_seq_file_for_state_base = f"https://www2.census.gov/programs-surveys/acs/summary_file/2015/data/5_year_seq_by_state/{STATENAME.replace(' ','')}/Tracts_Block_Groups_Only/"
        TABLENAME = varname.split('_')[0]
        STATENAME_gfile_name = f"g20155{stateabbr.lower()}.zip"
        LINENUM = int(varname.split('_')[1].replace("E",""))
        print(f"LINENUM: {LINENUM}")
        _tumber_for_t  = ACS_5yr_Seq_Table_Number_Lookup.loc[ACS_5yr_Seq_Table_Number_Lookup["Table ID"]==TABLENAME,]# seq_tumber_for_t
        seq_tumber_for_t = _tumber_for_t ["Sequence Number"].values[0]
        print(f"seq_tumber_for_t: {seq_tumber_for_t}")
        VARSTARTPOSITION = int(_tumber_for_t.loc[_tumber_for_t["Start Position"].notnull(),]["Start Position"].values[0])
        print(f"VARSTARTPOSITION: {VARSTARTPOSITION}")
        seq_url_filename_patt = f'20155{stateabbr.lower()}{seq_tumber_for_t}000.zip'
        url_seq_file_for_state = f"{url_seq_file_for_state_base}{seq_url_filename_patt}"

        if f"{seq_tumber_for_t}" in files_inventrory[f"{STATEABBR}"]:
            print("downloaded")
        else: 
    #         try:
            getFile(STATEABBR, url_seq_file_for_state,seq_url_filename_patt,seq_tumber_for_t, varname,VARSTARTPOSITION, LINENUM)
            files_inventrory[f"{STATEABBR}"][f"{seq_tumber_for_t}"] = "downloaded"
            print("downloaded")


# ### B.

# In[ ]:



all_gfiles_name = "../../reference_files/5_year_Mini_Geo.xlsx"
for state_code in ratiodf.groupby("state_code", as_index=False).min()["state_code"].unique(): #[:4]
    STATEABBR = state_code_abbr.loc[state_code_abbr["STATE"]==state_code,]["STUSAB"].values[0]
    STATENAME = state_code_abbr.loc[state_code_abbr["STATE"]==state_code,]["STATE_NAME"].values[0]
    __omall_gfiles = pandas.read_excel(f"{WORKING_DIR}/{all_gfiles_name}",dtype={"GEOID":str,"LOGRECNO":str},sheet_name=STATEABBR,index_col=False)
    __omall_gfiles["summ_level"] = __omall_gfiles["GEOID"].apply(lambda x: x[:7])
    fromall_gfiles = __omall_gfiles.loc[__omall_gfiles["summ_level"] == "15000US",]
    fromall_gfiles.to_csv(f"{WORKING_DIR}/{STATEABBR}/geography_summ_level_bg.csv")


# In[ ]:


var_names=[
            'B17021_001E',
            'B17021_002E',
            'B03002_001E',
            'B03002_003E',
            'B03002_004E',
            'B03002_006E',
            'B03002_012E',
            'B25008_001E',
            'B25008_003E',
            'B99051_001E',
            'B99051_005E',
            'B99051_006E',
            'B99051_007E',
            'B15003_001E',
            'B15003_022E',
            'B15003_023E',
            'B15003_024E',
            'B15003_025E',
    
            'B25010_001E', # average housing unit size (for occupied hunits)
            'B25010_002E',
            'B25010_003E',
    
            'B25036_001E', # by year structure was built (for occupied hunits)
            'B25036_012E',
            'B25036_011E',
            'B25036_010E',
            'B25036_009E',
            'B25036_008E',
            'B25036_007E',
            'B25036_006E',
    
            'B25036_023E',
            'B25036_022E',
            'B25036_021E',
            'B25036_020E',
            'B25036_019E',
            'B25036_018E',
            'B25036_017E',
    
    
    
            'B23025_004E', # emplynt
            'B23025_005E',
            'B23025_003E',
    
    
    
    
            'B25001_001E', # housing units (total)
            'B25004_001E' # vacant units
            ]


for state_code in ratiodf.groupby("state_code", as_index=False).min()["state_code"].unique(): #[:4]
    STATEABBR = state_code_abbr.loc[state_code_abbr["STATE"]==state_code,]["STUSAB"].values[0]
    STATENAME = state_code_abbr.loc[state_code_abbr["STATE"]==state_code,]["STATE_NAME"].values[0]
    for VARNAME in var_names:
        TABLENAME = VARNAME.split('_')[0]
        STATENAME_gfile_name = f"g20155{STATEABBR.lower()}.zip"
        LINENUM = int(VARNAME.split('_')[1].replace("E",""))
        _tumber_for_t  = ACS_5yr_Seq_Table_Number_Lookup.loc[ACS_5yr_Seq_Table_Number_Lookup["Table ID"]==TABLENAME,]# seq_tumber_for_t
        seq_tumber_for_t = _tumber_for_t ["Sequence Number"].values.min()
        if (_tumber_for_t ["Sequence Number"].values.min() != _tumber_for_t ["Sequence Number"].values.max()):
            print("MULTIPLE SEQQ WARNING")
        _tumber_for_t_s = _tumber_for_t.loc[_tumber_for_t["Sequence Number"] == seq_tumber_for_t,]
        VARSTARTPOSITION = int(_tumber_for_t_s.loc[_tumber_for_t_s["Start Position"].notnull(),]["Start Position"].values[0])
        seq_url_filename_patt = f'20155{STATEABBR.lower()}{seq_tumber_for_t}000.zip'
        zf = zipfile.ZipFile(f"{WORKING_DIR}/{STATEABBR}/{seq_url_filename_patt}")
        fsize = sum([zinfo.file_size for zinfo in  zf.filelist])
        zip_kb = float(fsize)/1000 #kB
        print("file_size",zip_kb)
        logrecno = list()
        varvals = list()
        with zf.open(f"e{seq_url_filename_patt.replace('.zip','.txt')}") as fle:
            for lne in fle:
                logrecno.append(lne.decode().split(",")[5])
                varvals.append(lne.decode().split(",")[VARSTARTPOSITION+LINENUM-2])
        statevarseqfile = pandas.DataFrame({
            "LOGRECNO":logrecno,
            f"{VARNAME}": varvals
        })
        statevarseqfile.to_csv(f"{WORKING_DIR}/{STATEABBR}/{VARNAME}_seqfile.csv")


# # D.

# In[ ]:


for state_code in ratiodf.groupby("state_code", as_index=False).min()["state_code"].unique(): #[:4]
    STATEABBR = state_code_abbr.loc[state_code_abbr["STATE"]==state_code,]["STUSAB"].values[0]
    STATENAME = state_code_abbr.loc[state_code_abbr["STATE"]==state_code,]["STATE_NAME"].values[0]
    for VARNAME in var_names:
        TABLENAME = VARNAME.split('_')[0]
        statevarle = pandas.read_csv(f"{WORKING_DIR}/{STATEABBR}/{VARNAME}_seqfile.csv")
        statevarle.set_index("LOGRECNO", inplace=True)
        stategeodfle = pandas.read_csv(f"{WORKING_DIR}/{STATEABBR}/geography_summ_level_bg.csv")
        stategeodfle.set_index("LOGRECNO", inplace=True)
        statevarjoin = stategeodfle.join(statevarle, lsuffix="_geo",rsuffix="_seq")
        statevarjoin.to_csv(f"{WORKING_DIR}/{STATEABBR}/{VARNAME}_GEO.csv")
        


# ### E.

# In[ ]:


for state_code in ratiodf.groupby("state_code", as_index=False).min()["state_code"].unique(): #[:4]
    STATEABBR = state_code_abbr.loc[state_code_abbr["STATE"]==state_code,]["STUSAB"].values[0]
    STATENAME = state_code_abbr.loc[state_code_abbr["STATE"]==state_code,]["STATE_NAME"].values[0]
    states_tables_list = []
    for VARNAME in var_names:
        TABLENAME = VARNAME.split('_')[0]
        statevarjointable = pandas.read_csv(f"{WORKING_DIR}/{STATEABBR}/{VARNAME}_GEO.csv", index_col="GEOID")
        states_tables_list.append(statevarjointable)
    _mdf = states_tables_list.pop(0)
    for __df in states_tables_list:
        
        _mdf =_mdf.append(__df)
    _mdf = _mdf.groupby(_mdf.index).sum()
    _mdf.to_csv(f"{WORKING_DIR}/{STATEABBR}/geo_2015_5yrs.csv")
    

