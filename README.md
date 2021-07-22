# DashTest - Shinyapp Dashboard Test

This is an R Shiny app example, named DashTest. <br>
Its code is based on a similar app used for a monitoring system. <br>


## Content

This app only contains a few Tabs: opening window; installation selection; documentation; and seasonal weather monitoring. <br>
The main code is included in "app.R". Some html code is inserted in "Htmls0.R". <br>
The logos and icons are contained in the "www" folder. <br>
The "window_ex" figure shows how the app should look like. <br>
Each installation data is in its respective folder inside the main folder "data". <br>


## Details
The app contains reactive expressions such as to load data. <br>
The loaded data is in CSV and JSON files, besides figures in PNG. <br>
Plots use both R plotly and openair packages. <br>
There is some html and css code, and small pieces of Javascript code are also present. More are expected to be included. <br>


## Use

The app can run locally on RStudio or deployed on a server, such as the free version of 'shinyapps.io'. <br>
Persistent data can be stored locally, as it is in this version. <br>
Data storage can also be done remotely, for instance at dropbox, azure or aws. Automatic data updates can be visualized in near real-time. <br>
