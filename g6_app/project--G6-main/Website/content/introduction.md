---
title: "Introduction"
date: "2021-12-12"
---

# Goals and Impact 

All of us are aware of the urgent need to reduce our individual ecological footprint by reducing our overall consumption, shift our purchasing habits, recycle more, invest in renewable energies and globally contribute to a common goal: a cleaner planet. Even though world leaders gather to unify and work as a united front towards sustainable changes with the ultimate goal to slow climate change, we still currently detect many problems surrounding the topic of sustainability. 

First, we understand that many aspects of sustainability are not well understood. Indeed, it is associated with many difficult terms (e.g. bio capacity, life-cycle analysis, embodied energy, footprint intensity, etc.) that non-specialists do not necessarily understand. Because, the average layman does not necessarily understand these terms and is sometimes overwhelmed by the overload of information in the News regarding achieving sustainability, individuals tend to completely turn away from thinking about it. 

Second, it is not immediately obvious how our personal immediate actions (e.g. limit water use waste, riding a bike over driving a car) fit the overall picture of the community, country and the world. 

Third, sustainability data is scattered among all kinds of media in a "fuzzy" way. Oftentimes, when doing research about the topic, one ends up being constantly redirected to more and more sources that are not necessarily mutually exclusive and collectively exhaustive.

To address the above points and challenges, we want to create the S(ust)hinybility app based on a reliable database. This app aims at gathering worldwide data on ecological footprint of different types of production lands and exploit the information to produce visual outcomes enabling a user to look for specific information by country and by year. Therefore, the shiny app will provide visualization to compare between countries and understand the gravity and urgency of undertaking immediate long-lasting actions against climate change. 

We try to have the impact on three different levels. First, the individuals are nudged to learn about ecological footprints. This, increases knowledge and awareness and helps to make more informed decisions later on. Second, making ecological footprints comparable between countries helps to filter certain criteria and makes research more convenient. Here, the impact is a higher satisfaction of researchers looking for countries' involvement and responsibility towards sustainable changes. Third, the interactive app helps to track and trace developments. This tool could be a fact checker and used against wrongly spread information over the Internet in either way.  

# Plan 

Our approach is to explore a data set of more than 70,000 entries to investigate carbon emissions by country (and region) over time and, provide some visualization (*map*, *ggplot2* packages). To investigate the evolution over time of CO2 emissions, we will use time series (*tsibble* package) and ultimately, we will forecast (*package FPP3*) emissions for an horizon of time t, to be determined. To explore the data set and provide several features to our shiny app, we will use packages enabling us to manipulate the data (*dplyr*, *tidyverse*) to add features using built-in and our own functions before visually present (*map*, *ggplot2*) our findings.

It is very likely that such application is already existing but our focus is to apply notions learnt in class to this specific data set through an interactive shiny app enabling the users to select different features (e.g. checkboxes, filter button...) and have a customized output. 

Our data collection strategy was to look for official websites providing reliable data on carbon emissions by country. We chose this approach to rely on well collected and organized data. 

We found and downloaded a data set containing more than 70,000 entries ordered by country and by year on the following website: https://data.world/footprint. 
