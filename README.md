# fetch-receipt-processor
## Overview
<ul>
<li>This repository has been created for <a href="https://github.com/fetch-rewards/receipt-processor-challenge">Fetch's Take Home Assessment</a>. </li>
<li>The program is built using Ruby on Rails. <b>Ruby 3.4.3 </b> and <b>Rails 8.0.2</b> were used. I have also included integration tests for the given test cases, written using Minitest.</li>
</ul> 

### Table of Contents
- [Overview](#overview)
- [Setup](#setup)
  - [Docker](#docker)
- [Assumptions & Validations](#assumptions--validations)
- [Execution](#execution)
- [Optional: Testing](#optional-testing)
  - [Tests](#tests)

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

## Assumptions & Validations
Before we move on to exection, following are the assumptions I have made while writing my solution:
1. Post Request Validation: Only the mentioned fields are permitted in the JSON payload, so if anything other than `retailer`, `purchaseDate`, `purchaseTime`, `items`, or `total`, and within `items`, anything other than `shortDescription` or `price` is sent, it is filtered out.
2. Additonally, each of these fields is assumed to be present in **every request** even if the **associated value is blank**; for example, even if there are no `items`, there is still an `"items"` key in the JSON, but it is associated with an empty array `[]`.
3. Get Request Validation: Only `id` is permitted through with the url; anything else is ignored.
4. The rule **"10 points if the time of purchase is after 2:00pm and before 4:00pm"** is interpreted such that extra points are given when time is strictly greater and strictly less than `2:00 PM` and `4:00 PM` respectively, so if a purchase happens at `2:00 PM` or `4:00 PM`, it is not awarded extra points.
5. Price amounts cannot be broken down beyond cents; in other words, only up to 2 decimal places per price are expected.
6. Based on the [given example](#given-example-2) with date `"2022-03-20"`, the date format is assumed to be `YYYY-MM-DD`.
7. Additionally, it is assumed user input has consistent date and time format with double digits for each entry; for example, `day 3` will always be `03`.
8. User input is not erroneous (e.g. user doesn't put a non-numeric entry for price).

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
#### You should see something like
```
{"id":"0af5cbb1-7a94-4860-b968-4ee22af35142"}
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;c. Copy the `id` returned and send a `get` request with the same `id`:  
```
curl http://localhost:3000/receipts/{id}/points
```
In this run, for example, the `id` returned from the `post` request was ```"0af5cbb1-7a94-4860-b968-4ee22af35142"```, so we will send the following request:
```
curl http://localhost:3000/receipts/0af5cbb1-7a94-4860-b968-4ee22af35142/points
```
You should see the points associated with the receipt, something like:
```
{"points":28}
```
## Optional: Testing

For project completion and polish, I have added tests for the given cases.
To execute, kindly follow these instructions:
1. Open a terminal.
2. Navigate to the working directory.
3. Run the following command:
```
docker-compose run --rm web bundle exec rails test
```

### Tests
Following are the scenarios for which the program has been tested:
#### Given Example 1
```
{
  "retailer": "Target",
  "purchaseDate": "2022-01-01",
  "purchaseTime": "13:01",
  "items": [
    {
      "shortDescription": "Mountain Dew 12PK",
      "price": "6.49"
    },{
      "shortDescription": "Emils Cheese Pizza",
      "price": "12.25"
    },{
      "shortDescription": "Knorr Creamy Chicken",
      "price": "1.26"
    },{
      "shortDescription": "Doritos Nacho Cheese",
      "price": "3.35"
    },{
      "shortDescription": "   Klarbrunn 12-PK 12 FL OZ  ",
      "price": "12.00"
    }
  ],
  "total": "35.35"
}
```
##### Expected Result:  
```
{ "points": 28 }
```
#### Given Example 2
```
{
  "retailer": "M&M Corner Market",
  "purchaseDate": "2022-03-20",
  "purchaseTime": "14:33",
  "items": [
    {
      "shortDescription": "Gatorade",
      "price": "2.25"
    },{
      "shortDescription": "Gatorade",
      "price": "2.25"
    },{
      "shortDescription": "Gatorade",
      "price": "2.25"
    },{
      "shortDescription": "Gatorade",
      "price": "2.25"
    }
  ],
  "total": "9.00"
}
```
##### Expected Result:  
```
{ "points": 109 }
```


  
#### END: Hope this was an easy read. Thank you for your time :-).
