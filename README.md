# TakeHome
Take home assignment - simple app to process json and output to console

How to run
Make sure you have ruby installed and then clone the repo to local machine

Run following commands
```
  gem install json
  gem install json-schema
  ruby challenge.rb
```

Brief explanation:  
We have 3 main classes that serve the purpose of this challenge  
- CompanyCollection:
  - Stores a collection of company; Has the ability to load company and user data from json files
  - Loading of json data is verified on multiple level(file existense/ file integrity/ json data correctness)  
  - The collection of company is stored in a sorted array for print to output, as well as in a dictionary for fast lookup
  
- Company:
  - Stores the info of a company and a sorted collection of users belonging to the company

- User:
  - Stores the info of a user

Error will be logged to the logfile.log
