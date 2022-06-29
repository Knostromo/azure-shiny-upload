# Azure Shiny Upload Test

## Background
- There might be unannounced changes on Azure ML compute instance during May/Jun 2022
- Initially the `fileInput` function (from `shiny`) stopped working 
    - I only tested xlsx, xls and csv files. There might be more issues with other filetypes
    - the SHA uploaded of the uploaded files will be different.
    
- Then Azure ML compute instance would just stopped provisioning RStudio
    - As of today (29-Jun-2022), 
        - Azure docs doesn't mention this or the rational behind this.
        - the custom application approach of add RStudio doesn't work e.g. it can't access the folders/files on the compute instance.

- I have created this app to test/check what actually happen to the uploaded file
    - Specifically I look at these properties of the uploaded file:
        - location
        - SHA
        - *Estimated* encoding
        - *if possible* table outpu

## Shiny Upload App
- Clone the repo to your machine/env.
- Run the app as standard shiny app
- I have used the iris dataset as test data in different formats, these are located in the `/DATA`
- I have tested in various environments, so far it is working fine except in `Azure ML Compute Instance`

- For example, if I run it locally:
    - XLSX
        - <img width="600" alt="image" src="https://user-images.githubusercontent.com/47578869/176476333-512e7bff-bc2a-43d5-bed9-36dec72d3984.png">
    - XLS
        - <img width="600" alt="image" src="https://user-images.githubusercontent.com/47578869/176476455-939a09c3-7044-4ebe-944f-ae46781fbc18.png">
    - CSV
        - <img width="600" alt="image" src="https://user-images.githubusercontent.com/47578869/176476661-06aeb4ce-2d47-48f4-9548-9fdb901c14d3.png">
    - **The SHA of the uploaded files matched** and all table outputs worked.

### Azure ML Compute Instance specific issues
- If you run the same app on Azure ML compute instance, you will see the **SHAs are different**.
    - XLSX
        - <img width="600" alt="image" src="https://user-images.githubusercontent.com/47578869/176477182-3f70b79b-fa24-4c13-b078-d3d68a7fe29e.png">
    - XLS
        - <img width="600" alt="image" src="https://user-images.githubusercontent.com/47578869/176477324-5743e563-2606-41f9-8010-07e4a29ea41b.png">
    - CSV
        - <img width="600" alt="image" src="https://user-images.githubusercontent.com/47578869/176477405-9ed93df9-0af8-4166-919c-30e9314ed273.png">
    - **All SHA of the uploaded files are different**, but ASCII based files (e.g. CSV) still works.
    - **NOTE** this used to work fine on Azure until ~ mid-May 2022 (I think)

### File encoding for reference
- These are the *estimated* encoding of the raw test data

```R
! Multiple files in zip: reading ''_rels/.rels''
           iris.csv iris.xls       iris.xlsx
encoding   "ASCII"  "windows-1250" "ASCII"  
confidence 1        0.22           1        
```

- Source code
```R
sapply(list.files("DATA/"), function(x) {
  readr::guess_encoding(paste0("DATA/",x))
  })
```


### Repo Structure
```
.
├── [   0]  DATA ** <- Sample Data**
│   ├── [3.8K]  iris.csv
│   ├── [ 36K]  iris.xls
│   └── [9.4K]  iris.xlsx
├── [   0]  R
│   └── [1.8K]  app.R
└── [ 730]  README.md
```
