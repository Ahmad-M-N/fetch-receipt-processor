# fetch-receipt-processor
## Overview
<ul>
<li>This repository has been created for <a href="https://github.com/fetch-rewards/receipt-processor-challenge">Fetch's Take Home Assessment</a>. </li>
<li>The program is built using Ruby on Rails. <b>Ruby 3.4.3 </b> and <b>Rails 8.0.2</b> were used. I have also included integration tests for the given test cases, written using Minitest.</li>
</ul


### Table of Contents
- [Overview](#overview)
- [Setup](#setup)
  - [Docker](#docker)
- [Assumptions](#assumptions)
- [Execution](#execution)
- [Optional: Testing](#optional-testing)
  - [Tests](#tests)
  - [Execute Tests](#execute-tests)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>


## Setup
First, let's get the repo on local.  
  
1. Run `git clone https://github.com/Ahmad-M-N/fetch-receipt-processor.git`  
2. Run `cd fetch-receipt-processor` to move into the repo folder

### Docker
This project has been setup to be run with docker. Kindly follow the instuctions to below to install docker on your device if you don't have it already:
|Operating System| Installation Guides |
| ----------- | ----------- |
|Windows|https://docs.docker.com/desktop/setup/install/windows-install/|
|GNU/Linux|https://docs.docker.com/engine/install/|
|MacOS|https://docs.docker.com/desktop/setup/install/mac-install/|

## Assumptions
Before we move on to exection, following are the assumptions I have made while writing my solution:
1. The input file is in the same directory as the python file.
2. User input is not erroneous (e.g. user doesn't put a non-numeric entry for points).
3. Timestamps will always have double digits in each notation, i.e 3:00 PM will be represented in the timestamp as 03 in hours, 00 in minutes, and 00 in seconds -- 03:00:00; same for date. This is done so I can perfom a simple sort on the timestamp string.
4. If the points of the payers in the input transaction files are negative, then we have assumed that those points are returned back to the payers at the given timestamp
    1. The above assumptions means that if there are 3 transactions, 
    "DANNON",1000,"2020-11-02T14:00:00Z"
    "UNILEVER",200,"2020-10-31T11:00:00Z"
    "DANNON",-200,"2020-10-31T15:00:00Z",
    then the assumptions is that DANNON can contribute only 800 points to the user input and not 1000. 

5. The negative points values have been subtracted from their respective payer groups.
6. Only valid inputs are assumed for each payer. ie
   1. No negative points can appear first ( as per timestamp ) as it is not possible to return points to the payer without them contributing first.
   2. Sum of negative points is assumed to always be greater than the sum of positive points per payer.
7. **Considering the timeframe, not ALL POSSIBLE unit tests have been written for this function. Ideally the above cases should have a unit test case associated with it.**

## Execution
1. If you are running Windows or MacOS, first we need to open the docker desktop app (not needed for GNU/Linux distros).
2. Open a terminal and navigate to the working directory.
3. Run the following command:
```
RAILS_MASTER_KEY=ae15adaff43943328f707f9b33364672 docker compose up --build
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &rarr; The api endpoints are now available at localhost:3000 to recieve requests.  
  
&nbsp;&nbsp;&nbsp;&nbsp;4. Here is a sample workflow:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;a. Open another terminal.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;b. Send a post request:
   
For GNU/Linux and MacOS:
```
curl -X POST http://localhost:3000/receipts/process   -H "Content-Type: application/json"   -d '{
    "retailer": "Target",
    "purchaseDate": "2022-01-01",
    "purchaseTime": "13:01",
    "items": [
      {
        "shortDescription": "Mountain Dew 12PK",
        "price": "6.49"
      },
      {
        "shortDescription": "Emils Cheese Pizza",
        "price": "12.25"
      },
      {
        "shortDescription": "Knorr Creamy Chicken",
        "price": "1.26"
      },
      {
        "shortDescription": "Doritos Nacho Cheese",
        "price": "3.35"
      },
      {
        "shortDescription": "   Klarbrunn 12-PK 12 FL OZ  ",
        "price": "12.00"
      }
    ],
    "total": "35.35"
  }'; echo
```
For Windows Command Prompt:
```
curl -X POST http://localhost:3000/receipts/process -H "Content-Type: application/json" -d "{\"retailer\":\"Target\",\"purchaseDate\":\"2022-01-01\",\"purchaseTime\":\"13:01\",\"items\":[{\"shortDescription\":\"Mountain Dew 12PK\",\"price\":\"6.49\"},{\"shortDescription\":\"Emils Cheese Pizza\",\"price\":\"12.25\"},{\"shortDescription\":\"Knorr Creamy Chicken\",\"price\":\"1.26\"},{\"shortDescription\":\"Doritos Nacho Cheese\",\"price\":\"3.35\"},{\"shortDescription\":\"   Klarbrunn 12-PK 12 FL OZ  \",\"price\":\"12.00\"}],\"total\":\"35.35\"}"
```
For Windows Power Shell:
```
Invoke-RestMethod -Uri http://localhost:3000/receipts/process -Method POST -Headers @{
  "Content-Type" = "application/json"
} -Body '{
  "retailer": "Target",
  "purchaseDate": "2022-01-01",
  "purchaseTime": "13:01",
  "items": [
    {"shortDescription": "Mountain Dew 12PK", "price": "6.49"},
    {"shortDescription": "Emils Cheese Pizza", "price": "12.25"},
    {"shortDescription": "Knorr Creamy Chicken", "price": "1.26"},
    {"shortDescription": "Doritos Nacho Cheese", "price": "3.35"},
    {"shortDescription": "   Klarbrunn 12-PK 12 FL OZ  ", "price": "12.00"}
  ],
  "total": "35.35"
}'
```
You should see something like
```
{"id":"0af5cbb1-7a94-4860-b968-4ee22af35142"}
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;c. Copy the `id` returned and send a `get request` with the same `id`:  
```
curl http://localhost:3000/receipts/{id}/points
```
In this run, for example, the `id` returned was "0af5cbb1-7a94-4860-b968-4ee22af35142", so we will send the following request:
```
curl http://localhost:3000/receipts/0af5cbb1-7a94-4860-b968-4ee22af35142/points
```
You should see the points associated with the recipe, something like:
```
{"points":28}
```
## Optional: Testing

For project completion and polish, I have added tests for the given 
### Pytest Setup
If you used the Makefile to run the program, Pytest should already be installed in your device and you can skip to the [tests](#tests). If not, kindly use the guide below to install Pytest on your device:  
|Installation Guide | https://docs.pytest.org/en/stable/getting-started.html |
| ----------- | ----------- |  


### Tests
Before we execute the tests, following are the scenarios for which the program has been tested:
#### 1. Given Example
This tests the program on the given example. 
#### 2. File Reading
This test if the program is successfully able to read the file.
#### 3. Edge Case 1
What if ...?
#### 4. Edge Case 2
What if ...?
#### 5. Edge Case 3
What if ...?

### Execute Tests
1. Kindly make sure all the files are in the same direcotry.
2. Just enter `pytest` in your terminal.

  
#### END: Hope this was an easy read. Thank you for your time :-). 
