## The Presence, Distribution, and Modeling of Californian Sea Lions on the British Columbia Coast

### Overview

This project explores the presence and distribution of Californian Sea Lions on the B.C. Coast. The objective was to identify significant factors pertaining to their presence (sea lion count) in certain sites, months, years, etc. Poisson regression was initially used to model this objective, but due to extreme overdispersion, proved inappropriate for the data. Negative binomial regression performed much better. However, various assumptions are still not met and thus limit the model's accuracy, so mixed models were proposed to solve this issue.

### Data

Source: Canadian Open Data Portal, published by Oceans and Fisheries Canada

Link: <https://open.canada.ca/data/en/dataset/08f2ea2c-8fe3-4a97-b4f5-944580ac4154>

### Methods

-   Data cleaning

-   Exploratory Data Analysis

-   Poisson/Negative Binomial GLM

-   Model selection/diagnostics

### Technologies

-   R

### Findings

-   Data is extremely overdispersed and moderately zero-inflated

-   No obvious difference in sea lion counts across different months/years

-   Poisson models are inappropriate due to overdispersion

-   Negative binomial models perform much better than poisson

-   Mixed models may be more appropriate due to certain negative binomial assumptions remaining unmet (independence, linearity, multicollinearity)
