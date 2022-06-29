# Azure Shiny Upload Test

## Background
- There might be unannounced changes on Azure ML compute instance during May/Jun 2022
- Initially the `fileInput` function (from `shiny`) stopped working 
    - I only tested xlsx, xls and csv files.
    - the SHA uploaded of the uploaded files will be different.
    
- Then Azure ML compute instance would just stopped provisioning RStudio
    - As of today (29-Jun-2022), 
        - Azure docs doesn't mention this or the rational behind this.
        - 
        - the custom application approach of add RStudio doesn't work e.g. it can't access the folders/files on the compute instance.

## Shiny Upload App
- Clone the repo to your machine/env.
- Run the app as standard shiny app
- I have used the iris dataset as test data in different formats, these are located in the `/DATA`
- I have tested in various environments, so far it is working fine except in `Azure ML Compute Instance`

### Azure ML Compute Instance specific issues
- 

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